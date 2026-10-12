if _G.AmbitiousRunning then
  local _existingHub = nil
  pcall(function()
    local _pg = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if _pg then _existingHub = _pg:FindFirstChild("AmbitiousHub") end
    if not _existingHub then
      _existingHub = game:GetService("CoreGui"):FindFirstChild("AmbitiousHub")
    end
  end)
  if _existingHub then return end
  _G.AmbitiousRunning = nil
end
_G.AmbitiousRunning = true

repeat task.wait() until game:IsLoaded()
Players = game:GetService("Players")
UserInputService = game:GetService("UserInputService")
TweenService = game:GetService("TweenService")
RunService = game:GetService("RunService")
HttpService = game:GetService("HttpService")
Lighting = game:GetService("Lighting")
Workspace = game:GetService("Workspace")
Stats = game:GetService("Stats")
MaterialService = game:GetService("MaterialService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
SoundService = game:GetService("SoundService")

LP = Players.LocalPlayer
PlayerGui = LP:WaitForChild("PlayerGui")

-- ============================================================
-- CONTENITORE GUI DELL'HUB
-- gethui() restituisce un contenitore protetto (di solito dentro CoreGui),
-- non ispezionabile dagli anticheat che scansionano PlayerGui e non
-- azzerato ai reset del personaggio. Fallback in ordine: gethui ->
-- get_hidden_gui -> CoreGui -> PlayerGui, cosi' lo script gira anche su
-- executor che non espongono nessuna delle tre.
-- ATTENZIONE: le GUI DEL GIOCO (Duels timer, bottone jump mobile) restano
-- su PlayerGui, non vanno cercate qui.
-- ============================================================
HubGui = PlayerGui
-- PlayerGui is the reliable visible parent for the main hub UI.
-- Executor-only containers can make the ScreenGui invisible on some clients.

_G.AmbitiousGuiParent = HubGui


_SV = {} -- setVisual callbacks (merged to save local slots)

-- ============================================================
-- WAIT CHARACTER READY (condiviso)
-- Al respawn il character esiste prima delle sue parti. Aspettare un
-- tempo fisso e' inaffidabile: qui si aspetta che Head, HumanoidRootPart
-- e Humanoid esistano davvero. Ritorna false se scade il timeout o se il
-- character viene sostituito nel frattempo.
-- ============================================================
function _G._AmbitiousWaitCharReady(character, timeout)
  character = character or LP.Character
  if not character then return false end
  local deadline = os.clock() + (tonumber(timeout) or 5)
  while os.clock() < deadline do
    if not character.Parent then return false end
    if LP.Character and LP.Character ~= character then return false end
    if character:FindFirstChild("Head")
       and character:FindFirstChild("HumanoidRootPart")
       and character:FindFirstChildOfClass("Humanoid") then
      return true
    end
    task.wait(0.05)
  end
  return false
end


_G.AmbitiousIsMobile = true

for _, name in ipairs({"AmbitiousHub", "AmbitiousHub", "AmbitiousHub"}) do
  local old = HubGui:FindFirstChild(name)
  if old then old:Destroy() end
  -- ripulisce anche le versioni vecchie che stavano in PlayerGui
  old = PlayerGui:FindFirstChild(name)
  if old then old:Destroy() end
end

NS = 59.5
CS = 28.8
LAGGER_SPEED = 29
LAGGER_CARRY_SPEED = 15
currentSpeedMode = "Normal"
autoCarrySpeedEnabled = false
setAutoCarrySpeedVisual = nil
_G.AmbitiousAutoCarryWasCarrying = false
_G.AmbitiousAutoCarrySavedMode = nil
-- Auto Carry Speed mode: "NORMAL" oppure "SOFT"
_G._AmbitiousAutoCarryMode = _G._AmbitiousAutoCarryMode or "NORMAL"
-- Stato SOFT: scan animali + raggio
_G._AmbitiousAutoCarrySoft = _G._AmbitiousAutoCarrySoft or {radius = 9.5, animals = {}, lastScan = 0, scanInterval = 2}

-- Auto Switch To Carry state
-- interval = 0 -> il massimo possibile: task.wait(0) riprende al frame
-- successivo, quindi il check gira una volta per frame (~60/s a 60 fps).
-- Scendere sotto non serve: task.wait non puo' risvegliarsi piu' spesso di un Heartbeat.
_G._AmbitiousAS = _G._AmbitiousAS or {interval=0, wasLow=false, locked=false, savedMode=nil, restoring=false}

autoStealEnabled = false
selectedStealMode = "Normal"
selectedSemiMode = "V3"
autoStealRadius = 62
_G.AmbitiousStealRadii = _G.AmbitiousStealRadii or {Normal = 62, Semi = 60}
autoStealRadiusBox = nil
_G._AmbitiousSyncAfterHit = {
  enabled = false,
  conn = nil,
  setVisual = nil,
  gen = 0,
  wasRagdoll = false,
}

selectedAimbotMode = "V1"
AIMBOT_SPEED = 82
LAGGER_AIMBOT_SPEED = 55
_G.AmbitiousBatAimbotV2Speed = _G.AmbitiousBatAimbotV2Speed or 86
if _G.AmbitiousBatAimbotV2LaggerSpeed == nil or tonumber(_G.AmbitiousBatAimbotV2LaggerSpeed) == 58 then _G.AmbitiousBatAimbotV2LaggerSpeed = 55 end

mirrorTPDownEnabled = false

-- >>> ANTI VOID BEGIN
-- ============================================================
-- ANTI VOID
-- Sempre attivo dall'esecuzione. Un thread per giocatore tiene 0.07s
-- di storico dei CFrame: se in quella finestra copre 150 stud totali
-- oppure 100 stud di sola Y, e' un teletrasporto. La posizione buona e'
-- quella del campione piu' vecchio dello storico, e il TP viene contato
-- solo se partiva dalla Safe Zone. Da li' in poi aimbot V1/V2,
-- Bat Counter, Look At Enemy, ESP e tracker puntano al punto d'origine.
-- ============================================================
do
  -- Limiti di coordinate della Safe Zone
  local MAP_BOUNDS = {
    MinX = -535.7,
    MaxX = -422.0,
    MinY = -7.9,
    MaxY = 115.0,
    MinZ = -72.0,
    MaxZ = 193.3,
  }

  -- Finestra UNICA da 0.07s per tutti gli assi:
  --   150 stud di distanza totale (X/Z/Y)  oppure  100 stud di sola Y
  local TP_TOTAL   = 150
  local TP_DELTA_Y = 100
  local WINDOW     = 0.07
  -- Il fantasma non sparisce rientrando nella zona: sparisce quando il
  -- giocatore ha camminato WALK_CLEAR stud ORIZZONTALI dentro la zona.
  -- La Y e' esclusa dal conteggio: cadere o salire non lo cancella.
  local WALK_CLEAR = 15
  local STEP_MAX   = 50   -- oltre questo non e' camminata, non si accumula

  local function enabled() return _G.AmbitiousAntiVoidEnabled == true end

  local ghost   = setmetatable({}, { __mode = "k" })  -- [player] = posizione d'origine
  local ghostCF = setmetatable({}, { __mode = "k" })  -- [player] = CFrame d'origine
  local isOutOf = setmetatable({}, { __mode = "k" })  -- [player] = bool
  local tracked = setmetatable({}, { __mode = "k" })  -- [player] = true (thread gia' avviato)

  local function isWithinBounds(pos)
    if typeof(pos) ~= "Vector3" then return false end
    return pos.X >= MAP_BOUNDS.MinX and pos.X <= MAP_BOUNDS.MaxX
       and pos.Y >= MAP_BOUNDS.MinY and pos.Y <= MAP_BOUNDS.MaxY
       and pos.Z >= MAP_BOUNDS.MinZ and pos.Z <= MAP_BOUNDS.MaxZ
  end

  -- Richiamata SOLO quando un teleport viene confermato
  local function onTeleportDetected(player, originCFrame)
    isOutOf[player] = true
    ghostCF[player] = originCFrame
    ghost[player]   = originCFrame.Position
  end


  -- ============================================================
  -- RESCUE (rete di sicurezza per LP)
  -- Se LP finisce fuori dalla Safe Zone (void part assente, fling,
  -- micro-bug) viene riportato all'ultima posizione sicura a terra.
  -- Attivo solo quando Anti Void e' acceso. Cooldown zero: interviene
  -- ad ogni Heartbeat finche' LP non e' rientrato nella zona.
  -- ============================================================
  local _rescueLastSafePos = nil   -- ultima pos a terra dentro la zona
  local _rescueSpawnOrigin = nil   -- prima pos sicura rilevata all'accensione
  local _rescueLastRescue  = 0     -- os.clock() dell'ultimo rescue
  local RESCUE_COOLDOWN    = 0     -- istantaneo (come in Ambitious_2_)
  local RESCUE_UPDATE_INT  = 0.1   -- ogni quanto aggiornare il checkpoint
  local _rescueLastUpdate  = 0

  local function _rescueUpdateCheckpoint()
    local c   = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum) then return end
    local now = os.clock()
    if now - _rescueLastUpdate < RESCUE_UPDATE_INT then return end
    _rescueLastUpdate = now
    local pos = hrp.Position
    if not _rescueSpawnOrigin and isWithinBounds(pos) then
      _rescueSpawnOrigin = pos
    end
    -- salva checkpoint solo se e' a terra (non in aria) e dentro la zona
    if hum.FloorMaterial ~= Enum.Material.Air and isWithinBounds(pos) then
      _rescueLastSafePos = pos
    end
  end

  local function _rescueTryRescue()
    local c   = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not (hrp and hrp.Parent) then return end
    if isWithinBounds(hrp.Position) then return end
    local now = os.clock()
    if now - _rescueLastRescue < RESCUE_COOLDOWN then return end
    _rescueLastRescue = now
    local dest = _rescueLastSafePos or _rescueSpawnOrigin
    if dest and isWithinBounds(dest) then
      pcall(function()
        hrp.AssemblyLinearVelocity  = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(dest + Vector3.new(0, 3, 0))
      end)
    end
  end

  -- Heartbeat dedicato al rescue LP. Si registra una sola volta
  -- e controlla enabled() ogni frame: zero overhead quando spento.
  RunService.Heartbeat:Connect(function()
    if not enabled() then return end
    _rescueUpdateCheckpoint()
    _rescueTryRescue()
  end)

  -- Resetta il checkpoint al respawn di LP: la nuova vita riparte da zero
  LP.CharacterAdded:Connect(function()
    _rescueLastSafePos = nil
    _rescueSpawnOrigin = nil
    _rescueLastRescue  = 0
    _rescueLastUpdate  = 0
  end)
  -- ============================================================
  -- FINE RESCUE
  -- ============================================================

  local function trackPlayer(player)
    if player == LP then return end
    if tracked[player] then return end
    tracked[player] = true

    local history      = {}
    local walkedXZ     = 0     -- spostamento orizzontale accumulato a piedi
    local lastCheckPos = nil

    task.spawn(function()
      while player and player.Parent do
        -- Poll passivo finche' l'Anti Void e' spento: nessun overhead.
        -- Il giocatore e' gia' in tracked, quindi se viene acceso basta
        -- uscire dal poll e il ciclo attivo riparte immediatamente.
        if not enabled() then
          -- Resetta lo stato in modo che la prima rilevazione sia pulita
          isOutOf[player] = false
          history      = {}
          walkedXZ     = 0
          lastCheckPos = nil
          task.wait(0.5)
        else
          local char = player.Character
          local hrp  = char and char:FindFirstChild("HumanoidRootPart")
          local hum  = char and char:FindFirstChildOfClass("Humanoid")

          if hrp and hum and hum.Health > 0 then
            local now = tick()
            local currentCFrame = hrp.CFrame
            local currentPos = currentCFrame.Position

            if isOutOf[player] then
              -- FASE 1: fantasma attivo, si misura solo la camminata X/Z
              if lastCheckPos then
                local moveVector = currentPos - lastCheckPos
                local moveXZ = Vector3.new(moveVector.X, 0, moveVector.Z).Magnitude
                if moveXZ < STEP_MAX and isWithinBounds(currentPos) then
                  walkedXZ = walkedXZ + moveXZ
                end
              end
              lastCheckPos = currentPos

              if walkedXZ >= WALK_CLEAR then
                isOutOf[player] = false
                ghost[player]   = currentPos
                ghostCF[player] = currentCFrame
                history      = {}
                walkedXZ     = 0
                lastCheckPos = nil
              end
            else
              -- FASE 2: nessun fantasma, si cerca il teletrasporto
              walkedXZ     = 0
              lastCheckPos = currentPos
              ghost[player]   = currentPos
              ghostCF[player] = currentCFrame

              table.insert(history, {time = now, cframe = currentCFrame})
              while #history > 0 and (now - history[1].time) > WINDOW do
                table.remove(history, 1)
              end

              local oldest = history[1]
              if oldest then
                local totalDistance = (currentPos - oldest.cframe.Position).Magnitude
                local deltaY = math.abs(currentPos.Y - oldest.cframe.Position.Y)

                if totalDistance >= TP_TOTAL or deltaY >= TP_DELTA_Y then
                  local refCFrame = oldest.cframe
                  local refPos = refCFrame.Position
                  local studsTraveledVector = currentPos - refPos
                  local exactOriginPos = currentPos - studsTraveledVector
                  local exactCFrame = CFrame.new(exactOriginPos) * (refCFrame - refCFrame.Position)

                  if isWithinBounds(exactOriginPos) then
                    onTeleportDetected(player, exactCFrame)
                  end
                  history = {}
                end
              end
            end
          else
            -- morto o senza character: niente fantasma
            isOutOf[player] = false
            history      = {}
            walkedXZ     = 0
            lastCheckPos = nil
          end
          RunService.Heartbeat:Wait()
        end
      end
      tracked[player] = nil
    end)
  end

  Players.PlayerAdded:Connect(trackPlayer)

  -- I thread partono all'accensione e muoiono allo spegnimento: da spento
  -- il modulo non tiene niente in esecuzione.
  local function startAll()
    for _, plr in ipairs(Players:GetPlayers()) do trackPlayer(plr) end
  end

  local function stopAll()
    for plr in pairs(isOutOf) do isOutOf[plr] = false end
  end

  local function posFor(player, rawPos)
    if not player or not enabled() then return rawPos, false end
    if isOutOf[player] then
      local g = ghost[player]
      if g then return g, true end
    end
    return rawPos, false
  end

  -- Come sopra ma partendo da una BasePart del nemico
  local function posForPart(part, rawPos)
    if not part then return rawPos, false end
    local model = part:FindFirstAncestorOfClass("Model")
    local player = model and Players:GetPlayerFromCharacter(model)
    return posFor(player, rawPos or part.Position)
  end

  _G.AmbitiousAntiVoidEnabled = _G.AmbitiousAntiVoidEnabled == true

  -- Avvia subito un thread per ogni giocatore gia' presente.
  -- I thread fanno poll passivo se Anti Void e' spento, tracking attivo
  -- se e' acceso: nessun giocatore viene perso indipendentemente dallo stato.
  startAll()

  _G.AmbitiousAntiVoid = {
    setEnabled = function(on)
      on = on and true or false
      local was = _G.AmbitiousAntiVoidEnabled == true
      _G.AmbitiousAntiVoidEnabled = on
      if on and not was then
        -- Per sicurezza: aggiunge thread per giocatori entrati nel frattempo
        startAll()
      elseif (not on) and was then
        stopAll()
      end
    end,
    isEnabled  = function() return _G.AmbitiousAntiVoidEnabled == true end,
    bounds     = MAP_BOUNDS,
    posFor     = posFor,
    posForPart = posForPart,
    isOut      = function(player) return player and isOutOf[player] == true end,
    ghostOf    = function(player) return player and ghost[player] or nil end,
  }

  -- ---------- REPLICA ESP SULLA POSIZIONE FANTASMA ----------
  -- Al TP si congela una copia del corpo sul CFrame d'origine calcolato
  -- dal tracker, con lo stesso contorno e overhead dell'ESP. L'ESP vero
  -- viene nascosto, cosi' non lo segue nel void.
  -- NB: ghostCF e' quello dichiarato sopra dal tracker, non ridichiararlo
  -- qui o la replica leggerebbe una tabella sempre vuota.
  local replicas   = {}
  local ghostFolder = nil

  local function ensureFolder()
    if ghostFolder and ghostFolder.Parent then return ghostFolder end
    ghostFolder = Instance.new("Folder")
    ghostFolder.Name = "AmbitiousAntiVoid"
    ghostFolder.Parent = workspace
    return ghostFolder
  end

  -- Mostra o nasconde l'ESP reale del nemico
  local function setRealESP(char, visible)
    if not char then return end
    local hl = char:FindFirstChild("AmbitiousHubESP")
    if hl then pcall(function() hl.Enabled = visible end) end
    local head = char:FindFirstChild("Head")
    local tag = head and head:FindFirstChild("AmbitiousHubESPTag")
    if tag then pcall(function() tag.Enabled = visible end) end
  end

  local function clearReplica(plr)
    local r = replicas[plr]
    if r then pcall(function() r:Destroy() end) end
    replicas[plr] = nil
  end

  local function buildReplica(plr, char, cf)
    clearReplica(plr)
    -- ESP spento: non si crea niente. Il resto (aimbot, tracker,
    -- Look At Enemy) continua a funzionare sulla posizione fantasma.
    if not char:FindFirstChild("AmbitiousHubESP") then return end
    local ok, clone = pcall(function()
      char.Archivable = true
      return char:Clone()
    end)
    if not ok or not clone then return end

    -- Congela la copia: niente script, niente fisica, niente collisioni
    for _, d in ipairs(clone:GetDescendants()) do
      if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Humanoid") then
        pcall(function() d:Destroy() end)
      elseif d:IsA("BasePart") then
        d.Anchored   = true
        d.CanCollide = false
        d.CanQuery   = false
        d.CanTouch   = false
      end
    end
    clone.Name = "GhostReplica_" .. tostring(plr.Name)
    clone.Parent = ensureFolder()
    pcall(function() clone:PivotTo(cf) end)

    -- L'ESP e il suo overhead sono figli del personaggio, quindi la copia
    -- se li porta dietro identici e congelati sull'ultimo valore.
    local hl = clone:FindFirstChild("AmbitiousHubESP")
    if hl then pcall(function() hl.Enabled = true end) end

    local cloneHead = clone:FindFirstChild("Head")
    local tag = cloneHead and cloneHead:FindFirstChild("AmbitiousHubESPTag")
    if tag then
      pcall(function() tag.Enabled = true end)
      -- scritta VOID sotto la velocita', al posto dove stava il nome
      local box = tag:FindFirstChildOfClass("Frame") or tag
      local vl = Instance.new("TextLabel")
      vl.Name = "VoidTag"
      vl.Size = UDim2.new(1, -10, 0, 16)
      vl.Position = UDim2.new(0, 5, 0, 19)
      vl.BackgroundTransparency = 1
      vl.TextColor3 = Color3.fromRGB(255, 255, 255)
      vl.Font = Enum.Font.GothamBlack
      vl.TextSize = 16
      vl.TextStrokeTransparency = 0.4
      vl.Text = "VOID"
      vl.Parent = box
    end

    replicas[plr] = clone
  end

  -- Repliche ESP: lo stato lo tiene gia' il thread di tracciamento
  local lastMarkerTick = 0
  RunService.Heartbeat:Connect(function()
    local now = os.clock()
    if now - lastMarkerTick < 0.1 then return end
    lastMarkerTick = now

    for _, plr in ipairs(Players:GetPlayers()) do
      if plr ~= LP then
        local c   = plr.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        local out = enabled() and (hrp ~= nil) and (hum ~= nil) and hum.Health > 0 and isOutOf[plr] == true
        if out and ghostCF[plr] then
          setRealESP(c, false)
          if not replicas[plr] or not replicas[plr].Parent then
            buildReplica(plr, c, ghostCF[plr])
          end
        else
          if replicas[plr] then
            clearReplica(plr)
            setRealESP(c, true)
          end
        end
      end
    end
  end)

  Players.PlayerRemoving:Connect(function(plr)
    ghost[plr] = nil
    isOutOf[plr] = nil
    ghostCF[plr] = nil
    tracked[plr] = nil
    clearReplica(plr)
  end)
end
-- <<< ANTI VOID END
_G.AmbitiousNormalAimbotOn = _G.AmbitiousNormalAimbotOn or false
_G.AmbitiousBatAimbotV2On = _G.AmbitiousBatAimbotV2On or false
-- >>> AIMBOT CHASE MODE BEGIN
-- Modalita' di inseguimento per ciascun aimbot: "NORMAL" oppure "BYPASS".
-- Cambia SOLO la matematica del chase, non i nomi, le velocita' o il resto.
_G._AmbitiousAimbotChase = _G._AmbitiousAimbotChase or { V1 = "NORMAL", V2 = "NORMAL" }
-- <<< AIMBOT CHASE MODE END
batCounterEnabled = false
batCounterMode = "V1"  -- "V1" o "V2"
medCounterEnabled = false

antiKickEnabled = false
espEnabled = false
showTrackerEnabled = false
ragdollCountdownEnabled = false
fpsBoostEnabled = false
local antiLagVisualEnabled = true
local headlessEnabled = false
local korbloxEnabled = false

-- >>> ANTI DROP BEGIN (versione con raw metatable)
-- ============================================================
-- ANTI DROP
-- Sempre attivo, non si spegne: nessun toggle, nessun salvataggio.
-- Non tocca la velocita' reale, fa solo vedere al gioco 16 studs/s
-- qualunque sia la velocita' effettiva. Al movimento ci pensa la
-- root.Velocity dell'HRP (speed, jump, Anti Bat: tutti la' sopra).
-- checkcaller() fa passare intatte le scritture dell'hub.
-- ============================================================
do
    local VS_FAKE = 16   -- velocita' mostrata al gioco (walkspeed normale)
    local spoofedVelocity = Vector3.zero
    -- Unico bersaglio: l'HRP. I due proxy (speed booster e infinite jump)
    -- non esistono piu', ora si scrive tutto sulla root.Velocity, quindi i
    -- loro nomi qui erano voci morte.
    local SPOOF_NAMES = {
        HumanoidRootPart = true,
    }
    local function isSpoofTarget(self)
        if typeof(self) ~= "Instance" then return false end
        if not self:IsA("BasePart") then return false end
        if not SPOOF_NAMES[self.Name] then return false end
        local char = LP.Character
        return char ~= nil and self:IsDescendantOf(char)
    end
    -- Hook tramite raw metatable (piÃ¹ robusto e meno rilevabile)
    pcall(function()
        if not (getrawmetatable and setreadonly and newcclosure and checkcaller) then
            return
        end
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldIndex = mt.__index
        mt.__index = newcclosure(function(self, key)
            if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                if isSpoofTarget(self) then
                    return spoofedVelocity
                end
            end
            return oldIndex(self, key)
        end)
        local oldNewIndex = mt.__newindex
        mt.__newindex = newcclosure(function(self, key, value)
            if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                if isSpoofTarget(self) then
                    spoofedVelocity = value   -- memorizza il valore che l'hub vorrebbe scrivere
                    return                     -- blocca la scrittura reale
                end
            end
            return oldNewIndex(self, key, value)
        end)
        setreadonly(mt, true)
    end)
    -- Aggiorna la velocitÃ  finta in base alla direzione di movimento
    local function updateFakeVelocity()
        local char = LP.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root or hum.Health <= 0 then return end
        local dir = hum.MoveDirection
        if dir.Magnitude > 0.05 then
            -- compatibilitÃ  con il client (opzionale)
            pcall(function()
                if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
            end)
            local unit = dir.Unit
            spoofedVelocity = Vector3.new(unit.X * VS_FAKE, root.Velocity.Y, unit.Z * VS_FAKE)
        else
            spoofedVelocity = Vector3.new(0, root.Velocity.Y, 0)
        end
    end
    local sig = RunService.PreSimulation or RunService.Stepped
    sig:Connect(updateFakeVelocity)
end
-- <<< ANTI DROP END

-- >>> ANTI BAT BEGIN
-- ============================================================
-- ANTI BAT
-- Quando attivo: lo Speed Booster smette di usare il suo proxy (che
-- viene distrutto) e scrive su root.Velocity. L'Infinite Jump non viene
-- toccato e continua a usare il suo proxy. Spegnendolo il proxy dello
-- speed booster viene ricreato: nulla di permanente.
-- ============================================================
do
  local AntiBatConn = nil
  local Speed     = 10000
  local Angle     = 0
  local Direction = 1   -- 1 aumenta, -1 diminuisce

  local function stopAntiBat()
    if AntiBatConn then
      pcall(function() AntiBatConn:Disconnect() end)
      AntiBatConn = nil
    end
    Speed     = 10000
    Angle     = 0
    Direction = 1
    _G._AmbitiousAntiBatDesiredXZ = nil
    _G._AmbitiousAntiBatSpiking = false
  end

  local function startAntiBat()
    stopAntiBat()
    AntiBatConn = RunService.Heartbeat:Connect(function()
      if not _G.AmbitiousAntiBatEnabled then return end
      local char = LP.Character
      local root = char and char:FindFirstChild("HumanoidRootPart")
      if not root or not root.Parent then return end

      -- Salva la velocita' originale X e Z
      local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)

      -- Speed oscillante tra 10000 e 20000
      Speed = Speed + (50 * Direction)
      if Speed >= 20000 then
        Speed = 20000
        Direction = -1
      elseif Speed <= 10000 then
        Speed = 10000
        Direction = 1
      end

      -- Angolo caotico + raggio variabile
      Angle = Angle + (math.random() * 0.5)
      local radius = Speed + math.random(-5000, 5000)
      local newX = math.cos(Angle) * radius
      local newZ = math.sin(Angle) * radius

      _G._AmbitiousAntiBatSpiking = true
      root.Velocity = Vector3.new(newX, root.Velocity.Y, newZ)

      RunService.RenderStepped:Wait()

      -- Ripristina X e Z: se lo speed booster ha una velocita' desiderata
      -- si riscrive quella (la speed dell'hub), altrimenti l'originale.
      if root.Parent then
        local want = _G._AmbitiousAntiBatDesiredXZ
        if want then
          root.Velocity = Vector3.new(want.X, root.Velocity.Y, want.Z)
        else
          root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
        end
      end
      _G._AmbitiousAntiBatSpiking = false
    end)
  end

  _G.AmbitiousAntiBatEnabled = _G.AmbitiousAntiBatEnabled == true

  -- Ogni fase e' protetta: se una fallisce non blocca le altre e si vede l'errore
  local function step(_, fn)
    pcall(fn)
  end

  _G.AmbitiousAntiBat = {
    setEnabled = function(on)
      on = on and true or false
      _G.AmbitiousAntiBatEnabled = on
      if on then
        step("startAntiBat", startAntiBat)
      else
        step("stopAntiBat", stopAntiBat)
      end
    end,
    isEnabled = function() return _G.AmbitiousAntiBatEnabled == true end,
  }

  -- Watchdog permanente: se il flag e' acceso ma i loop non ci sono
  -- (errore, respawn, disconnessione imprevista) li riavvia da solo.
  task.spawn(function()
    while true do
      task.wait(0.5)
      if _G.AmbitiousAntiBatEnabled then
        if not AntiBatConn then
          step("watchdog:start", startAntiBat)
        end
      elseif AntiBatConn then
        step("watchdog:stop", stopAntiBat)
      end
    end
  end)

  -- Respawn: il vecchio HRP e' morto, si riparte pulito
  LP.CharacterAdded:Connect(function(char)
    if _G._AmbitiousWaitCharReady then _G._AmbitiousWaitCharReady(char, 10) end
    if _G.AmbitiousAntiBatEnabled then
      startAntiBat()
    else
      stopAntiBat()
    end
  end)
end
-- <<< ANTI BAT END

-- ============================================================
-- TOOLS ENGINE (Rainbow / Transparent)
-- ============================================================
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
    -- Gestore condiviso della trasparenza dei tool.
    -- Ogni modulo "prenota" un valore, vince la priorita' piu' alta,
    -- e il valore originale vero viene letto una sola volta (baseline).
    -- ------------------------------------------------------------
    local CT_Trans = {}
    do
        local PRIORITY = { "transparent" }
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
        -- Scrive solo quando il valore cambia, evitando property write inutili.
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
    -- Gira solo quando Transparent Tools e' acceso.
    task.spawn(function()
        while true do
            task.wait(0.25)
            if _G.AmbitiousTransparentToolsEnabled == true then
                pcall(CT_Trans.enforce)
            end
        end
    end)

    -- ############################################################
    -- ##                   TRANSPARENT TOOLS                    ##
    -- ############################################################
    do
        local TRANSPARENCY = 0.5   -- 0 = opaco, 1 = invisibile

        local enabled  = false
        local tracked  = setmetatable({}, { __mode = "k" })
        local watchers = setmetatable({}, { __mode = "k" })
        local unregister

        local function canTouch(d)
            if not d:IsA("BasePart") then return false end
            -- non toccare le parti invisibili di default (baseline, non valore corrente)
            local base = CT_Trans.getBaseline(d)
            if base == nil or base >= 1 then return false end
            return true
        end

        local function addNode(entry, d)
            if not canTouch(d) then return end
            if entry.seen[d] then return end
            entry.seen[d] = true
            local node = { obj = d }
            table.insert(entry.parts, node)
            CT_Trans.claim(d, "transparent", TRANSPARENCY)
        end

        local function register(root)
            if tracked[root] then return end
            local entry = { parts = {}, seen = {}, conns = {} }
            tracked[root] = entry

            for _, d in ipairs(root:GetDescendants()) do addNode(entry, d) end
            if root:IsA("BasePart") then addNode(entry, root) end

            table.insert(entry.conns, root.DescendantAdded:Connect(function(d)
                addNode(entry, d)
            end))
            table.insert(entry.conns, root.AncestryChanged:Connect(function(_, parent)
                if not parent then unregister(root, false) end
            end))
        end

        function unregister(root, doRestore)
            local entry = tracked[root]
            if not entry then return end
            for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
            for _, node in ipairs(entry.parts) do
                CT_Trans.release(node.obj, "transparent")
            end
            tracked[root] = nil
        end

        local function tryRegister(inst)
            if not enabled then return end
            if ctMatchItem(inst) then register(inst) end
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
            for root in pairs(tracked) do unregister(root, false) end
            -- pulizia totale: il vecchio Character e il vecchio Backpack sono morti
            for container in pairs(watchers) do unwatch(container) end
            if not enabled then return end
            watch(char)
            task.defer(function()
                if enabled then watchAll() end
            end)
        end)

        table.insert(CT_JANITORS, function()
            for root in pairs(tracked) do
                if not root.Parent then unregister(root, false) end
            end
            for container in pairs(watchers) do
                if not container.Parent then unwatch(container) end
            end
        end)

        _G.AmbitiousTransparentTools = {
            setEnabled = function(on)
                on = on and true or false
                enabled = on
                _G.AmbitiousTransparentToolsEnabled = on
                if on then
                    watchAll()
                else
                    for root in pairs(tracked) do unregister(root, true) end
                    for container in pairs(watchers) do unwatch(container) end
                end
            end,
            isEnabled = function() return enabled end,
        }
    end

    -- Custom Sounds rimossi: ora viene usato il Padre Nostro.
    _G.AmbitiousTransparentToolsEnabled = false
    _G.AmbitiousCustomSoundsEnabled     = false
end

local headlessConnections = {}
local korbloxConnections = {}
local antiLagDescConn = nil
local vividGraphicsEnabled = false
local _vividContrastConn = nil
-- Vivid Graphics custom values stored on _G to avoid local slot usage
_G._AmbitiousVivid = _G._AmbitiousVivid or {
    pickerGui = nil,
    saturation = 0.6,
    bloomIntensity = 0.8,
    bloomSize = 24,
    dofFocus = 25,
    sunIntensity = 0.2,
}
local xrayEnabled = false
local highPingWarningEnabled = false
-- ===== KICK WARNING state (su _G per non consumare slot locals del main chunk) =====
_G._AmbitiousKickWarn = _G._AmbitiousKickWarn or {enabled=false, wasLow=false, active=false, gen=0}
_G._AmbitiousHPWNextAllowed = _G._AmbitiousHPWNextAllowed or 0
local removeAccessoriesEnabled = false
-- defLightBrightness/Clock/Ambient su _G per liberare slot locals del main chunk
_G._AmbitiousDefLightBrightness = _G._AmbitiousDefLightBrightness or nil
_G._AmbitiousDefLightClock = _G._AmbitiousDefLightClock or nil
_G._AmbitiousDefLightAmbient = _G._AmbitiousDefLightAmbient or nil
_G._ambitiousStretchUILock = false
_G.AmbitiousTrackerActive = false
_G.AmbitiousTrackerSavedStretchIndex = nil
local fovEnabled = false
local fovValue = 70
local noCamCollisionEnabled = false
local motionBlurEnabled = false
local _motionBlurConn = nil
local _motionBlurEffect = nil
local _motionBlurCurrentValue = 0
_G.AmbitiousNoPlayerCollisionEnabled = _G.AmbitiousNoPlayerCollisionEnabled or false
local unwalkEnabled = false
local selectedAnimPackIndex = 1  -- 1=NONE, 2..6=Pack1..5, 7=CUSTOM

-- >>> CUSTOM ANIM PACK BEGIN
-- ID scelti dall'utente per il pack CUSTOM (indice 7 dello slider).
-- Su _G e non su un local del main chunk per non consumare registri.
-- Stringa vuota = slot non impostato, quel movimento resta quello del gioco.
_G.AmbitiousCustomAnimIds = _G.AmbitiousCustomAnimIds
  or { idle = "", walk = "", run = "", jump = "", fall = "", climb = "" }
_G.AmbitiousCustomAnimSlots = { "idle", "walk", "run", "jump", "fall", "climb" }
_G.AmbitiousCustomAnimLabels = {
  idle = "IDLE", walk = "WALK", run = "RUN",
  jump = "JUMP", fall = "FALL", climb = "CLIMB",
}
function _G.AmbitiousHasCustomAnim()
  for _, slot in ipairs(_G.AmbitiousCustomAnimSlots) do
    local v = _G.AmbitiousCustomAnimIds[slot]
    if v and v ~= "" then return true end
  end
  return false
end
-- <<< CUSTOM ANIM PACK END
local _animPackUnwalkWasActive = false  -- unwalk era attivo quando si Ã¨ selezionato un pack
local _animPackSavedIndex = 1          -- pack salvato quando unwalk viene attivato su un pack attivo
local _animPackSystemEnabled = false
local _animPackCharConn = nil
local _animPackTracks = {}
local _animPackCurrentAnim = "idle"
local setAnimPackVisual = nil  -- callback UI aggiornamento slider
local skyTheme = "Off"
local skyEventConnections = {}
local originalSkyObjects = {}

-- ===== STATUS BAR RIMOSSA =====
_G.AmbitiousSetNoPlayerCollisionVisual = _G.AmbitiousSetNoPlayerCollisionVisual or nil
local skyValueLabel = nil

local autoLeftEnabled = false
local autoRightEnabled = false

local DEFAULT_SPEED_KEYBINDS = {
  SpeedToggle = Enum.KeyCode.Q,
  LaggerToggle = Enum.KeyCode.R,
  DropBrainrot = Enum.KeyCode.X,
  BatBypass = Enum.KeyCode.E,
  AutoPlay = Enum.KeyCode.Z,
  InstantReset = Enum.KeyCode.G,
  Float = Enum.KeyCode.B,
  -- TP Bat: bind effettivo (prima era presente solo nella GUI).
  BatTP = Enum.KeyCode.T,

  ToggleUI = Enum.KeyCode.LeftControl,
}
local DEFAULT_TP_DOWN_KEYBIND = Enum.KeyCode.F

local speedKeybinds = {
  SpeedToggle = DEFAULT_SPEED_KEYBINDS.SpeedToggle,
  LaggerToggle = DEFAULT_SPEED_KEYBINDS.LaggerToggle,
  DropBrainrot = DEFAULT_SPEED_KEYBINDS.DropBrainrot,
  BatBypass = DEFAULT_SPEED_KEYBINDS.BatBypass,
  AutoPlay = DEFAULT_SPEED_KEYBINDS.AutoPlay,
  InstantReset = DEFAULT_SPEED_KEYBINDS.InstantReset,
  Float = DEFAULT_SPEED_KEYBINDS.Float,
  BatTP = DEFAULT_SPEED_KEYBINDS.BatTP,
  ToggleUI = DEFAULT_SPEED_KEYBINDS.ToggleUI,
}

local speedKeybindButtons = {}
local listeningForSpeedKey = nil

local autoTPEnabled = false
local autoTPHeight = 20
local autoTPConn = nil
local autoTPLastRun = 0
local autoTPClickDebounce = false
local tpDownKeybind = Enum.KeyCode.F
local tpDownKeybindButton = nil
local listeningForTPDownKey = false
local keybindListenStartedAt = 0

-- ============================================================
-- GROUND DETECTION (TP Down / Auto TP Down)
-- Prima si teletrasportava sempre a Y = -7 alla cieca: se stai sopra
-- una montagna o una piattaforma alta, -7 e' molto sotto il pavimento
-- reale, quindi sembra un no-clip attraverso mezza mappa.
-- Adesso si lancia un raycast verso il basso, si trova la Y reale del
-- suolo sotto di noi e ci si posiziona esattamente sopra.
-- Se sotto non c'e' niente (void) si torna al vecchio -7.
-- Tutto dentro un do-block + funzioni globali per non consumare
-- slot di local nel main chunk.
-- ============================================================
do
  local TP_DOWN_FALLBACK_Y = -7.00
  local TP_DOWN_MAX_DISTANCE = 4000
  local TP_DOWN_MAX_STEPS = 12

  -- Exclude sulle versioni nuove, Blacklist su quelle vecchie.
  local EXCLUDE_FILTER = (function()
    local ok, v = pcall(function() return Enum.RaycastFilterType.Exclude end)
    if ok and v then return v end
    local ok2, v2 = pcall(function() return Enum.RaycastFilterType.Blacklist end)
    if ok2 then return v2 end
    return nil
  end)()

  -- Altezza del centro dell'HumanoidRootPart quando si sta in piedi sul pavimento.
  local function standOffset(hum, hrp)
    local half = 1
    pcall(function() half = hrp.Size.Y * 0.5 end)
    if half <= 0 then half = 1 end
    local off = half * 3
    pcall(function()
      if hum and hum.RigType == Enum.HumanoidRigType.R6 then
        off = half * 3
      elseif hum then
        off = half + (hum.HipHeight or (half * 2))
      end
    end)
    -- SANITY CLAMP: l'InstantReset scrive HipHeight = 1e30 come exploit
    -- per uccidere il character. Se il TP Down parte durante quella
    -- finestra (fino a ~2s) leggeremmo 1e30 e la Y finale sarebbe assurda.
    -- Stesso discorso per NaN o valori negativi.
    if off ~= off or off < 1 or off > 12 then off = half * 3 end
    return off + 0.15
  end

  local function rayDown(fromY, x, z, filter)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = filter
    if EXCLUDE_FILTER then params.FilterType = EXCLUDE_FILTER end
    params.IgnoreWater = true
    pcall(function() params.RespectCanCollide = true end)
    local res
    pcall(function()
      res = Workspace:Raycast(Vector3.new(x, fromY, z), Vector3.new(0, -TP_DOWN_MAX_DISTANCE, 0), params)
    end)
    return res
  end

  -- Ritorna: Y a cui teletrasportarsi, Y del suolo, distanza dal suolo.
  -- Ritorna nil se sotto non c'e' nessun pavimento.
  function _G.AmbitiousGetGroundTPY(char, hrp, hum)
    char = char or LP.Character
    if not char then return nil end
    hrp = hrp or char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    hum = hum or char:FindFirstChildOfClass("Humanoid")

    -- Si escludono il proprio personaggio e quelli degli altri player,
    -- altrimenti si atterra sulla testa di qualcuno.
    local filter = {char}
    pcall(function()
      for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
          table.insert(filter, plr.Character)
        end
      end
    end)

    local origin = hrp.Position
    local halfY = 1
    pcall(function() halfY = hrp.Size.Y * 0.5 end)
    local startY = origin.Y - halfY - 0.1
    local groundY = nil

    for _ = 1, TP_DOWN_MAX_STEPS do
      local res = rayDown(startY, origin.X, origin.Z, filter)
      if not res then break end
      local part = res.Instance
      local skip = false
      if part then
        pcall(function()
          if part:IsA("BasePart") and part.CanCollide == false then skip = true end
          local model = part:FindFirstAncestorOfClass("Model")
          if model and model:FindFirstChildOfClass("Humanoid") then skip = true end
        end)
      else
        skip = true
      end
      if skip then
        if part then table.insert(filter, part) end
        startY = res.Position.Y - 0.05
      else
        groundY = res.Position.Y
        break
      end
    end

    if not groundY then return nil end
    local targetY = groundY + standOffset(hum, hrp)
    return targetY, groundY, (origin.Y - groundY)
  end

  -- Y finale da usare per il TP: suolo reale se c'e', altrimenti -7 come prima.
  -- Secondo valore = true se il suolo e' stato trovato davvero.
  function _G.AmbitiousResolveTPDownY(char, hrp, hum)
    local ok, y = pcall(_G.AmbitiousGetGroundTPY, char, hrp, hum)
    if ok and type(y) == "number" then return y, true end
    return TP_DOWN_FALLBACK_Y, false
  end
end

-- >>> TP DOWN METHOD BEGIN
-- "NORMAL" = teletrasporto secco col CFrame (comportamento originale)
-- "SLOW"   = discesa con velocita' negativa applicata al proxy del jump
_G._AmbitiousTPDownMethod = _G._AmbitiousTPDownMethod or "NORMAL"
-- ZigZag: lato della prossima discesa. -1 sinistra, 1 destra. Si alterna a
-- ogni chiamata, cosi' due TP Down di fila non atterrano mai dalla stessa
-- parte.
_G._AmbitiousZigZagSide = _G._AmbitiousZigZagSide or 1
_G._AmbitiousSlowFallActive = false
-- Blocca il jump (sia Normal che Slow Fall) finche' il char non tocca terra
_G._AmbitiousTPDownJumpLocked = false

-- Scende fino a targetY spingendo verso il basso con SLOW_FALL_POWER.
-- Usa lo stesso proxy dell'Infinite Jump, quindi non tocca l'HRP.
-- Blocca il jump per tutta la durata della discesa (altrimenti l'inf-jump
-- annulla la velocita' negativa). Il lock viene tolto solo quando il char
-- tocca terra (FloorMaterial ~= Air), non prima.
-- zig = true: stessa identica discesa, ma con una spinta laterale costante
-- che rende la traiettoria diagonale invece che verticale. La direzione e'
-- il fianco del personaggio (RightVector) e viene presa UNA volta alla
-- partenza: se la si rileggesse ogni frame, girando la visuale durante la
-- caduta la traiettoria si incurverebbe invece di restare dritta.
function _G.AmbitiousSlowFallDown(targetY, zig)
  if _G._AmbitiousSlowFallActive then return end
  _G._AmbitiousSlowFallActive = true
  _G._AmbitiousTPDownJumpLocked = true   -- blocca il jump subito

  -- Lato e velocita' si fissano adesso, prima di partire.
  local zigVec = nil
  -- Con questo alzato il loop della speed non scrive la X/Z sulla root:
  -- premendo W riscriveva la velocita' orizzontale a ogni frame e la
  -- deriva laterale spariva. Stesso meccanismo dello spike dell'Anti Bat.
  _G._AmbitiousZigZagFalling = false
  if zig then
    _G._AmbitiousZigZagSide = (_G._AmbitiousZigZagSide == -1) and 1 or -1
    local ch  = LP.Character
    local hr  = ch and ch:FindFirstChild("HumanoidRootPart")
    if hr then
      local rv = hr.CFrame.RightVector
      local flat = Vector3.new(rv.X, 0, rv.Z)
      if flat.Magnitude > 0.001 then
        -- Velocita' laterale = esattamente quella della modalita' che stai
        -- usando (Normal, Carry, Lagger, Lagger Carry), senza correzioni.
        local spd = (_G.AmbitiousGetCurrentSpeedValue
                     and _G.AmbitiousGetCurrentSpeedValue()) or 16
        zigVec = flat.Unit * spd * _G._AmbitiousZigZagSide
        _G._AmbitiousZigZagFalling = true
      end
    end
  end

  task.spawn(function()
    -- Lo ZigZag scende un po' piu' piano dello Slow Fall normale: la
    -- diagonale ha cosi' piu' tempo per aprirsi, senza dover alzare la
    -- velocita' laterale.
    local POWER = zigVec and 50 or 115
    local deadline = os.clock() + 6
    local landed = false
    while os.clock() < deadline do
      local char = LP.Character
      local hrp  = char and char:FindFirstChild("HumanoidRootPart")
      local hum  = char and char:FindFirstChildOfClass("Humanoid")
      if not hrp or not hum or hum.Health <= 0 then break end
      -- Esci dal loop di spinta quando tocca terra oppure scade il tempo;
      -- il lock rimane attivo: viene tolto solo sotto, dopo aver verificato
      -- che il char sia davvero a terra.
      if hum.FloorMaterial ~= Enum.Material.Air then landed = true break end

      local proxy = _G._jumpEnsureProxy and _G._jumpEnsureProxy() or nil
      local part = proxy or hrp
      local v = part.Velocity
      -- Con lo ZigZag la X/Z le imponiamo noi (deriva laterale costante),
      -- altrimenti si lasciano quelle che ci sono gia'.
      if zigVec then
        part.Velocity = Vector3.new(zigVec.X, -POWER, zigVec.Z)
      else
        part.Velocity = Vector3.new(v.X, -POWER, v.Z)
      end
      RunService.Heartbeat:Wait()
    end

    -- Si toglie la spinta SOLO se siamo usciti per timeout, non per
    -- atterraggio. FloorMaterial diventa diverso da Air quando il pavimento
    -- e' entro l'HipHeight, cioe' mezzo stud PRIMA di toccarlo: azzerare la
    -- Y li' lasciava il personaggio fermo a mezz'aria e l'ultimo pezzo lo
    -- faceva in caduta libera da velocita' 0, l'effetto "piuma".
    if not landed then
      local char = LP.Character
      local hrp  = char and char:FindFirstChild("HumanoidRootPart")
      local proxy = _G._jumpEnsureProxy and _G._jumpEnsureProxy() or nil
      if proxy then
        local v = proxy.Velocity
        pcall(function() proxy.Velocity = Vector3.new(v.X, 0, v.Z) end)
      elseif hrp then
        local v = hrp.Velocity
        pcall(function() hrp.Velocity = Vector3.new(v.X, 0, v.Z) end)
      end
    end
    _G._AmbitiousSlowFallActive = false
    -- Da qui in poi la speed puo' riprendere il controllo della X/Z.
    _G._AmbitiousZigZagFalling = false

    -- Aspetta che il char tocchi davvero terra prima di sbloccare il jump.
    -- Deadline di sicurezza: 8s massimo.
    local groundDeadline = os.clock() + 8
    while os.clock() < groundDeadline do
      local c2  = LP.Character
      local h2  = c2 and c2:FindFirstChildOfClass("Humanoid")
      if not h2 or h2.Health <= 0 then break end
      if h2.FloorMaterial ~= Enum.Material.Air then break end
      RunService.Heartbeat:Wait()
    end
    _G._AmbitiousTPDownJumpLocked = false
  end)
end
-- <<< TP DOWN METHOD END

local function doAutoTPDown(force)
  local char = LP.Character
  if not char then return end
  local hrp = char:FindFirstChild("HumanoidRootPart")
  if not hrp then return end
  local hum2 = char:FindFirstChildOfClass("Humanoid")
  if not hum2 then return end
  if not force then
    if hum2.FloorMaterial ~= Enum.Material.Air then return end
    if hrp.Position.Y < autoTPHeight then return end
  end
  -- Y del suolo reale sotto di noi (fallback -7 se sotto c'e' il vuoto)
  local targetY = _G.AmbitiousResolveTPDownY(char, hrp, hum2)
  -- Se siamo gia' praticamente appoggiati, non ha senso teletrasportarsi.
  if not force and (hrp.Position.Y - targetY) < 0.75 then return end
  -- >>> TP DOWN METHOD BEGIN
  if _G._AmbitiousTPDownMethod == "SLOW" or _G._AmbitiousTPDownMethod == "ZIGZAG" then
    if _G.AmbitiousSlowFallDown then
      _G.AmbitiousSlowFallDown(targetY, _G._AmbitiousTPDownMethod == "ZIGZAG")
    end
    return
  end
  -- <<< TP DOWN METHOD END
  hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z) * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
  hrp.AssemblyLinearVelocity = Vector3.zero
  -- Blocca il jump finche' il char non tocca terra dopo il tp.
  _G._AmbitiousTPDownJumpLocked = true
  task.spawn(function()
    local groundDeadline = os.clock() + 8
    while os.clock() < groundDeadline do
      local c2 = LP.Character
      local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
      if not h2 or h2.Health <= 0 then break end
      if h2.FloorMaterial ~= Enum.Material.Air then break end
      RunService.Heartbeat:Wait()
    end
    _G._AmbitiousTPDownJumpLocked = false
  end)
end

local function _clearAutoTPConnection()
  if autoTPConn then
    pcall(function() autoTPConn:Disconnect() end)
    pcall(function() task.cancel(autoTPConn) end)
    autoTPConn = nil
  end
end

local function startAutoTP()
  autoTPEnabled = true
  _clearAutoTPConnection()
  autoTPLastRun = 0
  autoTPConn = RunService.Heartbeat:Connect(function()
    if not autoTPEnabled then
      _clearAutoTPConnection()
      return
    end
    local now = tick()
    if now - autoTPLastRun < 0.1 then return end
    autoTPLastRun = now
    pcall(function() doAutoTPDown(false) end)
  end)
  if _SV.setAutoTPVisual then _SV.setAutoTPVisual(true) end
end

local function stopAutoTP()
  autoTPEnabled = false
  _clearAutoTPConnection()
  if _SV.setAutoTPVisual then _SV.setAutoTPVisual(false) end
end

local function runTPFloor()
  pcall(function() doAutoTPDown(true) end)
end

-- Ingresso globale al TP Down: serve ai moduli che stanno PRIMA di questa
-- riga nel file (il modulo e' molto piu' in alto e non puo' vedere il
-- local). Con forceNormal si ignora lo Slow Fall eventualmente selezionato,
-- ripristinando subito dopo la scelta dell'utente.
function _G.AmbitiousRunTPDown(forceNormal)
  if not forceNormal then
    pcall(runTPFloor)
    return
  end
  local prev = _G._AmbitiousTPDownMethod
  _G._AmbitiousTPDownMethod = "NORMAL"
  pcall(runTPFloor)
  _G._AmbitiousTPDownMethod = prev
end

local function toggleAutoTP(on)
  if on then
    startAutoTP()
  else
    stopAutoTP()
  end
  saveAmbitiousConfig()
end

function _G.AmbitiousStopAutoTPForAction()
  if autoTPEnabled then
    stopAutoTP()
    pcall(function() if _SV.setAutoTPVisual then _SV.setAutoTPVisual(false) end end)
    pcall(saveAmbitiousConfig)
  end
end

local dropBrainrotActive = false
local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150

local function runDropBrainrot()
  if dropBrainrotActive then return end
  if _G.AmbitiousStopAutoTPForAction then _G.AmbitiousStopAutoTPForAction() end
  local char = LP.Character
  if not char then return end
  local root = char:FindFirstChild("HumanoidRootPart")
  if not root then return end
  dropBrainrotActive = true
  local startTime = tick()
  local dropConn
  dropConn = RunService.Heartbeat:Connect(function()
    local currentChar = LP.Character
    local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
    if not currentChar or not currentRoot then
      if dropConn then dropConn:Disconnect() end
      dropBrainrotActive = false
      return
    end
    if tick() - startTime >= DROP_ASCEND_DURATION then
      if dropConn then dropConn:Disconnect() end
      -- Arrivati in cima si scende col TP DOWN vero, SEMPRE quello
      -- Normal: il drop deve rientrare di colpo, il metodo scelto nelle
      -- impostazioni (Slow Fall / ZigZag) qui non c'entra. Il true forza
      -- il Normal e ripristina subito dopo la tua scelta.
      -- Prima qui c'era una discesa fatta in casa: un solo raycast verso
      -- il basso e un CFrame secco. Il raycast escludeva solo il
      -- personaggio, quindi si fermava sulla PRIMA cosa incontrata anche
      -- se non calpestabile, mentre il TP Down usa
      -- AmbitiousResolveTPDownY, che insiste per piu' passaggi finche'
      -- non trova terreno buono.
      currentRoot.AssemblyLinearVelocity = Vector3.zero
      currentRoot.AssemblyAngularVelocity = Vector3.zero
      if _G.AmbitiousRunTPDown then
        pcall(_G.AmbitiousRunTPDown, true)
      end
      dropBrainrotActive = false
      return
    end
    -- USA IL PROXY per il boost verticale
    local proxy = _G._jumpEnsureProxy()
    if proxy then
      local curVel = proxy.Velocity
      proxy.Velocity = Vector3.new(curVel.X, DROP_ASCEND_SPEED, curVel.Z)
    else
      currentRoot.Velocity = Vector3.new(currentRoot.Velocity.X, DROP_ASCEND_SPEED, currentRoot.Velocity.Z)
    end
  end)
end

local dropActive = false
local _wfConns = {}
local selectedDropMode = "TP UP"

local function runDropStandStill()
    if dropActive then return end
    if autoBatEnabled then
        autoBatEnabled = false
        if resetAutoBatMotion then resetAutoBatMotion() end
        if autoBatSetVisual then autoBatSetVisual(false) end
    end
    dropActive = true

    local colConn = RunService.Stepped:Connect(function()
        if not dropActive then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end)
    table.insert(_wfConns, colConn)

    local flingThread = coroutine.create(function()
        while dropActive do
            RunService.Heartbeat:Wait()
            local c = LP.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if not root then break end
            local vel = root.Velocity
            root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            if root and root.Parent then root.Velocity = vel end
            RunService.Stepped:Wait()
            if root and root.Parent then root.Velocity = vel + Vector3.new(0, 0.1, 0) end
        end
    end)
    table.insert(_wfConns, flingThread)
    coroutine.resume(flingThread)

    task.delay(0.1, function()
        dropActive = false
        for _, c in ipairs(_wfConns) do
            if typeof(c) == "RBXScriptConnection" then
                pcall(function() c:Disconnect() end)
            elseif type(c) == "thread" then
                pcall(coroutine.close, c)
            end
        end
        _wfConns = {}
    end)
end

local infJumpEnabled = false
local infJumpMode = "HOLD" -- "HOLD" o "MANUAL"
local antiRagdollEnabled = false
local antiRagdollConn = nil
-- antiRagdollMode su _G per non consumare local slot: "V1" o "V2"
_G._AmbitiousAntiRagdollMode = _G._AmbitiousAntiRagdollMode or "V1"

-- ===== ANTI RAGDOLL V2 =====
_G._AmbitiousARV2 = _G._AmbitiousARV2 or {conn = nil, cached = {}}
do
  local _arv2 = _G._AmbitiousARV2
  local _camera = workspace.CurrentCamera

  local function _arv2Cache()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    _arv2.cached = {character = char, humanoid = hum, root = root}
    _camera.CameraSubject = hum
    return true
  end

  local function _arv2IsRagdolled()
    local hum = _arv2.cached.humanoid
    if not hum then return false end
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Physics
    or st == Enum.HumanoidStateType.Ragdoll
    or st == Enum.HumanoidStateType.FallingDown then return true end
    local et = LP:GetAttribute("RagdollEndTime")
    if et then
      if (et - workspace:GetServerTimeNow()) > 0 then return true end
    end
    return false
  end

  local function _arv2RemoveConstraints()
    local char = _arv2.cached.character
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
      if v:IsA("BallSocketConstraint") or
         (v:IsA("Attachment") and v.Name:find("RagdollAttachment")) then
        pcall(function() v:Destroy() end)
      end
    end
  end

  local function _arv2ForceExit()
    local hum = _arv2.cached.humanoid
    local root = _arv2.cached.root
    if not hum or not root then return end
    pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
    if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
    root.Anchored = false
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(root.Orientation.Y), 0)
    if _camera.CameraSubject ~= hum then _camera.CameraSubject = hum end
  end

  function _G._AmbitiousStartARV2()
    if _arv2.conn then return end
    if not _arv2Cache() then return end
    _arv2.conn = RunService.RenderStepped:Connect(function()
      if not _arv2.cached.humanoid or not _arv2.cached.humanoid.Parent then return end
      if _arv2IsRagdolled() then
        _arv2RemoveConstraints()
        _arv2ForceExit()
      end
    end)
  end

  function _G._AmbitiousStopARV2()
    if _arv2.conn then
      _arv2.conn:Disconnect()
      _arv2.conn = nil
    end
    _arv2.cached = {}
  end

  function _G._AmbitiousRestartARV2()
    _G._AmbitiousStopARV2()
    task.wait(0.5)
    if antiRagdollEnabled and _G._AmbitiousAntiRagdollMode == "V2" then
      _arv2Cache()
      _G._AmbitiousStartARV2()
    end
  end
end
-- ===== FINE ANTI RAGDOLL V2 =====

local antiDieEnabled = false
-- Intento dell'UTENTE, separato dallo stato reale del modulo: e' questo a
-- comandare la riga nella GUI e quello che finisce nel config.
-- L'accensione automatica muove antiDieEnabled ma non questo, cosi' la riga
-- resta com'e' mentre in background l'Anti Die gira davvero.
_G._AmbitiousAntiDieUserWanted = false
local antiDieConnections = {}          -- tutte le connessioni attive (Health, Died, AncestryChanged)
local antiDieCharAddedConn = nil       -- connessione a CharacterAdded


-- ===== ANTI RAGDOLL V1 (nuova logica) =====
local function _arv1ResetCharacter(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
        hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") then
                obj.Enabled = true
            elseif obj:IsA("BasePart") then
                obj.CanCollide = true
                obj.AssemblyLinearVelocity = Vector3.zero
                obj.AssemblyAngularVelocity = Vector3.zero
            end
        end
        workspace.CurrentCamera.CameraSubject = hum
        local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local CM = PM:FindFirstChild("ControlModule")
            if CM then
                local ok, mod = pcall(require, CM)
                if ok and mod and mod.Enable then mod:Enable() end
            end
        end
    end)
end

local function _startAntiRagdollV1()
    if antiRagdollConn then return end
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown or
           state == Enum.HumanoidStateType.Dead or
           hum.PlatformStand == true or
           hum.Sit == true then
            _arv1ResetCharacter(char)
        end
    end)
end
-- ===== FINE ANTI RAGDOLL V1 =====

local function startAntiRagdoll()
    antiRagdollEnabled = true
    if _G._AmbitiousAntiRagdollMode == "V2" then
        if _G._AmbitiousStartARV2 then _G._AmbitiousStartARV2() end
    else
        _startAntiRagdollV1()
    end
end

local function stopAntiRagdoll()
    antiRagdollEnabled = false
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
    if _G._AmbitiousStopARV2 then _G._AmbitiousStopARV2() end
end

local function setAntiRagdoll(on)
    antiRagdollEnabled = on and true or false
    if antiRagdollEnabled then
        startAntiRagdoll()
    else
        stopAntiRagdoll()
    end
end

-- =============================================
-- ANTI-DIE: configurazione interna
-- =============================================
local _antiDieConfig = {
    healthThreshold    = 25,    -- soglia HP sotto cui si cura
    invincibilityFrames = 0.5,  -- secondi di invincibilitÃ  post-heal
    blockDeadState     = true,  -- disabilita lo stato Dead sull'Humanoid
    blockDamageEvents  = true,  -- override TakeDamage + segnale Damage
    autoRepairCharacter = true, -- ricrea parti mancanti come parti invisibili
}
local _antiDieInvincibleUntil = 0  -- tick() limite invincibilitÃ 
local _antiDieHeartbeatConn   = nil -- RunService.Heartbeat (loop principale)

-- =============================================
-- SUPER HEAL (senza ChangeState)
-- =============================================
local function _antiDieSuperHeal(hum)
    if not hum or not hum.Parent then return end
    if tick() < _antiDieInvincibleUntil then return end
    local maxHP = hum.MaxHealth or 100
    hum.Health = maxHP
    _antiDieInvincibleUntil = tick() + _antiDieConfig.invincibilityFrames
    -- azzera BoolValue "dead" e ripristina NumberValue health nel character
    pcall(function()
        local char = hum.Parent
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local n = child.Name:lower()
                if n:find("health") or n:find("hp") or n:find("life") then
                    child.Value = maxHP
                end
            end
            if child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end)
end

-- =============================================
-- RIPARAZIONE PARTI MANCANTI (invisibili)
-- =============================================
local function _antiDieRepairCharacter(char)
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    local needed = {"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}
    for _, partName in ipairs(needed) do
        if not char:FindFirstChild(partName) then
            local p = Instance.new("Part")
            p.Name        = partName
            p.Size        = Vector3.new(2, 1, 1)
            p.Transparency = 1
            p.CanCollide  = false
            p.Anchored    = false
            p.Material    = Enum.Material.SmoothPlastic
            p.CFrame      = root.CFrame + Vector3.new(0, 2, 0)
            p.Parent      = char
            local m       = Instance.new("Motor6D")
            m.Part0       = root
            m.Part1       = p
            m.Parent      = p
        end
    end
end

-- =============================================
-- PROTEZIONE DANNO DIRETTO
-- =============================================
local function _antiDieBlockDamage(hum, conns)
    -- Override TakeDamage
    pcall(function()
        local orig = hum.TakeDamage
        hum.TakeDamage = function(self, amount)
            if amount and amount > 0 then
                _antiDieSuperHeal(hum)
                return
            end
            return orig(self, amount)
        end
    end)
    -- Segnale Damage (alcuni giochi custom)
    pcall(function()
        table.insert(conns, hum.Damage:Connect(function(amount)
            if amount and amount > 0 then
                _antiDieSuperHeal(hum)
            end
        end))
    end)
end

-- =============================================
-- APPLICA GOD-MODE A UN CHARACTER
-- =============================================
local function applyGodMode(character)
    -- Attende che l'Humanoid esista
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        humanoid = character:WaitForChild("Humanoid", 5)
        if not humanoid then return end
    end

    local conns = {}  -- connessioni per questo character

    -- ---- tasks spawned (cancellabili al disconnect) ----
    local _godTasks = {}
    local function _spawnGodTask(fn)
        local t = task.spawn(fn)
        table.insert(_godTasks, t)
    end

    -- helper: inserisce una conn e la restituisce
    local function _addConn(c)
        table.insert(conns, c)
        return c
    end

    -- =============================================
    -- 1) Assicura HumanoidRootPart
    -- =============================================
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        root = Instance.new("Part")
        root.Name        = "HumanoidRootPart"
        root.Size        = Vector3.new(2, 1, 1)
        root.Transparency = 1
        root.CanCollide  = false
        root.Anchored    = false
        root.Parent      = character
        pcall(function() humanoid:SetRootPart(root) end)
    end

    -- =============================================
    -- 2) ProprietÃ  base Humanoid
    -- =============================================
    humanoid.BreakJointsOnDeath = false
    humanoid.RequiresNeck       = false

    -- =============================================
    -- 3) Rimuovi script Health ostile
    -- =============================================
    local healthScript = character:FindFirstChild("Health")
    if healthScript then healthScript:Destroy() end

    -- =============================================
    -- 4) ForceField invisibile (danni nativi)
    -- =============================================
    if not character:FindFirstChild("ForceField") then
        local ff = Instance.new("ForceField")
        ff.Visible = false
        ff.Parent  = character
    end

    -- =============================================
    -- 5) Disabilita stati pericolosi
    -- =============================================
    if _antiDieConfig.blockDeadState then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false) end)

    -- =============================================
    -- 6) StateChanged â†’ forza Running se morto/ragdoll
    -- =============================================
    _addConn(humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Dead
        or newState == Enum.HumanoidStateType.Ragdoll
        or newState == Enum.HumanoidStateType.FallingDown then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end))

    -- =============================================
    -- 7) Health cambiata â†’ cura istantanea
    -- =============================================
    _addConn(humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if humanoid.Health <= 0 or humanoid.Health <= _antiDieConfig.healthThreshold then
            _antiDieSuperHeal(humanoid)
        end
        if humanoid.Health > humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end))

    -- =============================================
    -- 8) Evento Died â†’ ripristino
    -- =============================================
    _addConn(humanoid.Died:Connect(function()
        task.wait(0.05)
        if humanoid and humanoid.Parent then
            _antiDieSuperHeal(humanoid)
        end
    end))

    -- =============================================
    -- 9) MaxHealth cambiato
    -- =============================================
    _addConn(humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
        if humanoid.MaxHealth < 100 then
            humanoid.MaxHealth = math.huge
        end
        if humanoid.Health > humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
        if humanoid.Health <= 0 then
            _antiDieSuperHeal(humanoid)
        end
    end))

    -- =============================================
    -- 10) Protezione danno diretto
    -- =============================================
    if _antiDieConfig.blockDamageEvents then
        _antiDieBlockDamage(humanoid, conns)
    end

    -- =============================================
    -- 11) Listener BreakJointsOnDeath
    -- =============================================
    _addConn(humanoid:GetPropertyChangedSignal("BreakJointsOnDeath"):Connect(function()
        if humanoid.BreakJointsOnDeath == true then
            humanoid.BreakJointsOnDeath = false
        end
    end))

    -- =============================================
    -- 12) Override BreakJoints (humanoid + character)
    -- =============================================
    pcall(function()
        humanoid.BreakJoints = function() end
    end)
    pcall(function()
        character.BreakJoints = function() end
    end)

    -- =============================================
    -- 13) Protezione Weld/Motor6D (smembramento)
    -- =============================================
    local function _protectJoint(desc)
        if desc:IsA("Motor6D") or desc:IsA("Weld") then
            _addConn(desc.AncestryChanged:Connect(function(_, parent)
                if not parent and desc.Part0 and desc.Part1 then
                    pcall(function()
                        local clone = desc:Clone()
                        clone.Parent = desc.Part0
                    end)
                end
            end))
        end
    end
    for _, desc in pairs(character:GetDescendants()) do
        _protectJoint(desc)
    end
    _addConn(character.DescendantAdded:Connect(_protectJoint))

    -- =============================================
    -- 14) Disinnesco killbricks/lava al tocco
    -- =============================================
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            _addConn(part.Touched:Connect(function(hit)
                if hit and hit.Parent then
                    local hn = string.lower(hit.Name)
                    if hn:find("kill") or hn:find("damage") or hn:find("lava")
                    or hn:find("hit")  or hn:find("fire")   or hn:find("spike") then
                        pcall(function()
                            hit.CanTouch = false
                            local ti = hit:FindFirstChild("TouchInterest")
                            if ti then ti:Destroy() end
                        end)
                    end
                end
            end))
        end
    end

    -- =============================================
    -- 15) ChildAdded â†’ distruggi esplosioni/fuoco/smoke
    --     e disabilita CanTouch sui Tool
    -- =============================================
    _addConn(character.ChildAdded:Connect(function(child)
        RunService.RenderStepped:Wait()
        if child:IsA("Explosion") or child:IsA("Fire") or child:IsA("Smoke") then
            child:Destroy()
        end
        if child:IsA("Tool") then
            for _, p in pairs(child:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanTouch = false
                    local ti = p:FindFirstChild("TouchInterest")
                    if ti then ti:Destroy() end
                end
            end
        end
    end))

    -- =============================================
    -- 16) ChildRemoved â†’ ripara parti critiche
    -- =============================================
    local _criticalParts = {"Head","UpperTorso","Torso","HumanoidRootPart",
                            "LeftArm","RightArm","LeftLeg","RightLeg",
                            "Left Arm","Right Arm","Left Leg","Right Leg"}
    _addConn(character.ChildRemoved:Connect(function(child)
        -- Ricostruzione HumanoidRootPart
        if child.Name == "HumanoidRootPart" then
            local newRoot = Instance.new("Part")
            newRoot.Name        = "HumanoidRootPart"
            newRoot.Size        = Vector3.new(2, 1, 1)
            newRoot.Transparency = 1
            newRoot.CanCollide  = false
            newRoot.Anchored    = false
            newRoot.CFrame      = CFrame.new(character:GetPivot().Position)
            newRoot.Parent      = character
            root = newRoot
            pcall(function() humanoid.RootPart = root end)
        end
        -- Ripara altre parti critiche
        for _, nm in ipairs(_criticalParts) do
            if child.Name == nm then
                task.wait(0.05)
                _antiDieSuperHeal(humanoid)
                _antiDieRepairCharacter(character)
                break
            end
        end
    end))

    -- =============================================
    -- 17) ChildRemoved â†’ repara se arriva autoRepair
    -- =============================================
    if _antiDieConfig.autoRepairCharacter then
        _antiDieRepairCharacter(character)
    end

    -- =============================================
    -- 18) Loop integritÃ  leggero ogni 2s
    -- =============================================
    _spawnGodTask(function()
        while character and character.Parent and antiDieEnabled do
            task.wait(2)
            if not antiDieEnabled then break end
            pcall(function()
                humanoid.RequiresNeck       = false
                humanoid.BreakJointsOnDeath = false
                if _antiDieConfig.blockDeadState then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                if not character:FindFirstChild("ForceField") then
                    local nff = Instance.new("ForceField")
                    nff.Visible = false
                    nff.Parent  = character
                end
                if _antiDieConfig.autoRepairCharacter then
                    _antiDieRepairCharacter(character)
                end
            end)
        end
    end)

    -- =============================================
    -- 19) Loop veloce 0.1s â†’ HP / BreakJoints / RequiresNeck
    -- =============================================
    _spawnGodTask(function()
        while character and character.Parent and antiDieEnabled do
            task.wait(0.1)
            if not antiDieEnabled then break end
            pcall(function()
                if humanoid.Health < humanoid.MaxHealth then
                    _antiDieSuperHeal(humanoid)
                end
                if humanoid.BreakJointsOnDeath == true then
                    humanoid.BreakJointsOnDeath = false
                end
                if humanoid.RequiresNeck == true then
                    humanoid.RequiresNeck = false
                end
                if _antiDieConfig.blockDeadState then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end
            end)
        end
    end)

    -- =============================================
    -- 20) Loop rigenerazione ForceField ogni 1s
    -- =============================================
    _spawnGodTask(function()
        while character and character.Parent and antiDieEnabled do
            task.wait(1)
            if not antiDieEnabled then break end
            if not character:FindFirstChild("ForceField") then
                local nff = Instance.new("ForceField")
                nff.Visible = false
                nff.Parent  = character
            end
        end
    end)

    -- =============================================
    -- Prima heal iniziale
    -- =============================================
    _antiDieSuperHeal(humanoid)

    -- Salva connessioni + tasks per cleanup
    antiDieConnections[character] = {conns = conns, tasks = _godTasks}
end

-- silent = mossa dell'automatismo, non tua: la riga non si muove e non si
-- salva niente nel config.
local function startAntiDie(silent)
    if next(antiDieConnections) ~= nil or antiDieCharAddedConn then
        -- Gia' agganciato. Il flag va rimesso a true COMUNQUE: se resta
        -- false i loop interni escono subito ("if not antiDieEnabled then
        -- return end") e la protezione sembra attiva ma non fa niente.
        antiDieEnabled = true
        return
    end

    antiDieEnabled = true

    -- Loop Heartbeat (senza ChangeState)
    if not _antiDieHeartbeatConn then
        _antiDieHeartbeatConn = RunService.Heartbeat:Connect(function()
            if not antiDieEnabled then return end
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if hum.Health <= 0 or hum.Health <= _antiDieConfig.healthThreshold then
                _antiDieSuperHeal(hum)
            end
        end)
    end

    -- Applica al personaggio corrente
    if LP.Character then
        applyGodMode(LP.Character)
    end

    -- Connessione PERSISTENTE per i respawn futuri
    antiDieCharAddedConn = LP.CharacterAdded:Connect(function(newChar)
        task.wait(0.1)
        if antiDieEnabled then
            applyGodMode(newChar)
        end
    end)

    if not silent then
        if _SV.setAntiDieVisual then _SV.setAntiDieVisual(true) end
        saveAmbitiousConfig()
    end
end

local function stopAntiDie(silent)
    antiDieEnabled = false

    -- 1) Ferma il Heartbeat loop principale
    if _antiDieHeartbeatConn then
        _antiDieHeartbeatConn:Disconnect()
        _antiDieHeartbeatConn = nil
    end

    -- 2) Disconnetti connessioni + cancella task per OGNI character
    for character, entry in pairs(antiDieConnections) do
        -- Disconnessione connessioni evento
        local connList = (type(entry) == "table" and entry.conns) or entry
        if connList then
            for _, conn in ipairs(connList) do
                pcall(function() conn:Disconnect() end)
            end
        end
        -- Cancella task spawned (loop integritÃ , HP, FF)
        if type(entry) == "table" and entry.tasks then
            for _, t in ipairs(entry.tasks) do
                pcall(function() task.cancel(t) end)
            end
        end
        -- Ripristina stato normale sull'Humanoid
        pcall(function()
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true) end)
                hum.BreakJointsOnDeath = true
                hum.RequiresNeck       = true
            end
        end)
        -- Rimuovi ForceField aggiunto da anti-die
        pcall(function()
            local ff = character:FindFirstChildOfClass("ForceField")
            if ff then ff:Destroy() end
        end)
    end
    antiDieConnections = {}

    -- 3) Rimuovi il listener per i respawn futuri
    if antiDieCharAddedConn then
        antiDieCharAddedConn:Disconnect()
        antiDieCharAddedConn = nil
    end

    -- 4) Ripristino sicurezza sul personaggio corrente
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true) end)
                hum.BreakJointsOnDeath = true
                hum.RequiresNeck       = true
            end)
        end
        pcall(function()
            local ff = char:FindFirstChildOfClass("ForceField")
            if ff then ff:Destroy() end
        end)
    end

    -- 5) Reset timer invincibilitÃ 
    _antiDieInvincibleUntil = 0

    if not silent then
        if _SV.setAntiDieVisual then _SV.setAntiDieVisual(false) end
        saveAmbitiousConfig()
    end
end

local function setAntiDie(on)
    -- Scelta esplicita dell'utente: l'auto non deve piu' comandare
    if _G.AmbitiousAntiDieUserOverride then _G.AmbitiousAntiDieUserOverride() end
    antiDieEnabled = on and true or false
    _G._AmbitiousAntiDieUserWanted = antiDieEnabled
    if antiDieEnabled then
        startAntiDie()
    else
        stopAntiDie()
    end
end

-- >>> ANTI DIE AUTO BEGIN
-- ============================================================
-- ANTI DIE AUTOMATICO
-- Con Bat Counter V2, Bat Aimbot V1 o V2 attivi l'Anti Die
-- si accende da solo, e si rispegne quando si spengono tutti.
-- Se l'avevi gia' acceso a mano NON viene toccato: allo spegnimento
-- dei moduli resta acceso com'era.
-- Nessun loop: la sync viene chiamata dai punti che accendono e
-- spengono quei moduli (vedi i wrapper in fondo al file e le due
-- chiamate dentro il Bat Counter V2).
-- ============================================================
do
  -- autoOn sta su _G perche' lo legge anche saveAmbitiousConfig: quando
  -- l'Anti Die e' acceso dall'automatismo non va scritto nel config, se no
  -- alla sessione dopo te lo ritrovi acceso come se l'avessi scelto tu.
  _G._AmbitiousAntiDieAutoOn = false

  local function combatActive()
    if _G.AmbitiousBatCounterV2On == true then return true end   -- Bat Counter V2
    if _G.AmbitiousNormalAimbotOn == true then return true end   -- Bat Aimbot V1
    if _G.AmbitiousFloatOn == true then return true end          -- Float
    return false
  end

  -- Finche' uno di quei moduli e' acceso l'Anti Die non si puo' spegnere
  -- dalla riga: ci conta sopra.
  function _G.AmbitiousAntiDieLocked()
    return combatActive()
  end

  function _G.AmbitiousAntiDieAutoSync()
    local active = combatActive()
    if active and not antiDieEnabled then
      -- era spento: lo accendiamo noi, in silenzio, e ce ne ricordiamo
      _G._AmbitiousAntiDieAutoOn = true
      pcall(startAntiDie, true)
    elseif not active and _G._AmbitiousAntiDieAutoOn then
      -- si sono spenti tutti: si torna com'era prima, ma non durante la
      -- finestra di avvio (vedi ArmNow). Se siamo dentro la finestra si
      -- ricontrolla quando scade, se no un modulo che parte e finisce
      -- in fretta lascerebbe l'Anti Die acceso per sempre.
      local hold = _G._AmbitiousAntiDieHoldUntil or 0
      if os.clock() < hold then
        if not _G._AmbitiousAntiDieHoldPending then
          _G._AmbitiousAntiDieHoldPending = true
          task.delay((hold - os.clock()) + 0.05, function()
            _G._AmbitiousAntiDieHoldPending = false
            if _G.AmbitiousAntiDieAutoSync then pcall(_G.AmbitiousAntiDieAutoSync) end
          end)
        end
      else
        _G._AmbitiousAntiDieAutoOn = false
        pcall(stopAntiDie, true)
      end
    elseif active and antiDieEnabled and not _G._AmbitiousAntiDieAutoOn then
      -- era gia' acceso a mano dall'utente: non si tocca niente, e allo
      -- stop dei moduli resta acceso com'era
      _G._AmbitiousAntiDieAutoOn = false
    end
  end

  -- Se l'utente spegne l'Anti Die a mano mentre lo tenevamo acceso noi,
  -- molliamo la presa: non deve riaccendersi da solo allo stop dei moduli.
  function _G.AmbitiousAntiDieUserOverride()
    _G._AmbitiousAntiDieAutoOn = false
  end

  -- ARMAMENTO IMMEDIATO.
  -- L'Anti Die deve essere gia' in piedi PRIMA che il modulo faccia la sua
  -- istante in cui parte, e se la protezione si arma dopo quel primo frame
  -- e' gia' scoperto. La AutoSync normale gira a fine chiamata e va bene
  -- per lo spegnimento e per la contabilita', non per l'accensione.
  -- Ritorna solo quando la protezione e' CONFERMATA sul personaggio
  -- corrente, non quando e' stata semplicemente richiesta. Non basta il
  -- flag antiDieEnabled: quello dice "acceso", mentre la protezione vera
  -- e' applyGodMode, che registra il character in antiDieConnections. Chi
  -- chiama puo' quindi partire subito dopo, sicuro di essere coperto.
  -- Nel caso normale non aspetta nemmeno un frame, perche' applyGodMode e'
  -- sincrona: il ciclo serve solo se qualcosa va storto.
  function _G.AmbitiousAntiDieArmNow(timeout)
    local function armed()
      if not antiDieEnabled then return false end
      local char = LP.Character
      if not char then return true end   -- niente character da proteggere
      return antiDieConnections[char] ~= nil
    end

    if armed() then return true end

    -- Finestra di protezione. Le funzioni di avvio, PRIMA di alzare il
      -- chiama StopNormalAimbot e StopBatAimbotV2, che sono avvolti e fanno
    -- scattare la AutoSync. In quell'istante nessun flag e' ancora su, la
    -- sync vede "nessun modulo attivo" e spegne l'Anti Die che avevamo
    -- appena acceso: acceso e spento nello stesso momento. Per mezzo
    -- secondo lo spegnimento automatico e' vietato, il tempo che la
    -- sequenza di avvio finisca e alzi il suo flag.
    _G._AmbitiousAntiDieHoldUntil = os.clock() + 0.5

    if not antiDieEnabled then
      _G._AmbitiousAntiDieAutoOn = true
      pcall(startAntiDie, true)
    elseif LP.Character then
      -- Acceso ma non applicato a QUESTO character (respawn appena fatto):
      -- si riaggancia solo lui invece di riavviare tutto.
      pcall(applyGodMode, LP.Character)
    end

    local deadline = os.clock() + (tonumber(timeout) or 0.5)
    while os.clock() < deadline do
      if armed() then return true end
      RunService.Heartbeat:Wait()
    end
    return false
  end

  -- Lettura dello stato, per chi volesse controllarlo a mano:
  --   print(_G.AmbitiousAntiDieStatus())
  -- "applicato" e' quello che conta davvero: dice se il god mode e'
  -- agganciato al personaggio che hai adesso. Non stampa niente da sola.
  function _G.AmbitiousAntiDieStatus()
    local char = LP.Character
    return ("AntiDie acceso=%s | applicato=%s | auto=%s | moduli=%s"):format(
      tostring(antiDieEnabled),
      tostring(char ~= nil and antiDieConnections[char] ~= nil),
      tostring(_G._AmbitiousAntiDieAutoOn == true),
      tostring(combatActive()))
  end
end
-- <<< ANTI DIE AUTO END

-- ============================================================
-- INSTANT RESET
-- ============================================================
_G._AmbitiousInstantResetBusy = false

-- Sequenza di reset vera e propria
-- Versione del metodo di reset: 1 = HipHeight, 2 = fling fisico.
_G.AmbitiousInstantResetVersion = math.clamp(
  tonumber(_G.AmbitiousInstantResetVersion) or 1, 1, 2)

-- ---------- V2: FLING FISICO ----------
-- Si mette l'Humanoid in stato Physics con PlatformStand e si spara la
-- root verso l'alto: il personaggio viene sbalzato e muore.
-- La camera NON viene toccata qui: se ne occupa gia'
-- _AmbitiousLockResetCamera, che la congela dal momento in cui premi fino
-- al respawn vero. Il codice da cui viene questa logica forzava invece la
-- camera su un CFrame fisso per 0.1s, che con la nostra gestione si
-- accavallerebbe e darebbe uno scatto.
_G._AmbitiousDoInstantResetV2 = function()
    _G._AmbitiousResetGaveUp = false
    local character = LP.Character
    if not character then _G._AmbitiousResetGaveUp = true return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then _G._AmbitiousResetGaveUp = true return end

    local savedPlatform = humanoid.PlatformStand
    local savedBreak    = humanoid.BreakJointsOnDeath

    -- INSISTENZA.
    -- Una spinta sola a volte non attacca: se capita nel frame sbagliato
    -- (personaggio non ancora pronto, stato riscritto dal gioco, root
    -- riassegnata) va persa e il reset non parte nemmeno. Quindi si
    -- riapplica fino a 50 volte invece di una.
    -- I tentativi sono distribuiti UN PER FRAME, non tutti dentro 0.1s:
    -- la fisica avanza una volta per frame, quindi cinquanta scritture
    -- nello stesso istante varrebbero quanto una sola: si sovrascrivono
    -- a vicenda prima che il motore le guardi. Un tentativo per frame e'
    -- il massimo che il gioco possa effettivamente vedere.
    -- Appena il personaggio muore si smette: i tentativi rimasti non
    -- vengono sprecati.
    -- 500 reset VERI, uno dietro l'altro, come se premessi il pulsante 500
    -- volte di fila. Non c'e' attesa tra uno e l'altro: cedere il frame
    -- li spalmerebbe su quasi un secondo, cosi' invece finiscono tutti in
    -- una manciata di microsecondi, ben dentro il decimo di secondo.
    -- Poi si continua a insistere una volta per frame finche' la finestra
    -- non scade: e' quella la parte che lascia alla fisica il tempo di
    -- agire, visto che il motore avanza una volta per frame.
    -- WINDOW: se entro questo tempo non sei morto si dichiara il
    -- fallimento, si ripristina tutto e la camera torna libera. In caso di
    -- riuscita non c'entra niente, perche' il ciclo esce appena vede la
    -- morte e la camera resta bloccata fino al respawn vero.
    local BURST, WINDOW = 500, 0.3
    local FLING = 1e9   -- velocita' esorbitante: non deve avere scampo

    -- Corpo della spinta come funzione NOMINATA, creata una volta sola.
    -- Prima era una funzione anonima dentro il pcall, quindi veniva
    -- allocata da capo a ogni giro: con 500 giri sono 500 closure create
    -- e buttate nello stesso frame, tutta spazzatura per il garbage
    -- collector. Humanoid e root cambiano a ogni tentativo, quindi non si
    -- poteva semplicemente spostarla fuori: arrivano come PARAMETRI, che
    -- pcall inoltra alla funzione. Comportamento identico, zero
    -- allocazioni.
    local function applyFling(hum, r)
        hum.BreakJointsOnDeath = true
        hum.PlatformStand = true
        hum:ChangeState(Enum.HumanoidStateType.Physics)
        r.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        r.AssemblyLinearVelocity = Vector3.new(0, FLING, 0)
    end

    local function attempt()
        local ch = LP.Character
        if ch ~= character or not character.Parent then return false end
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        -- Root ripresa ogni volta: durante il fling puo' cambiare.
        local r = ch:FindFirstChild("HumanoidRootPart")
        if r then
            pcall(applyFling, hum, r)
        end
        return true
    end

    local t0 = os.clock()
    for _ = 1, BURST do
        if not attempt() then return end   -- morto o respawnato: fatto
    end

    while (os.clock() - t0) < WINDOW do
        RunService.Heartbeat:Wait()
        if not attempt() then return end
    end

    -- Ultimo controllo prima di arrendersi: puo' essere morto proprio nel
    -- frame in cui si e' usciti dal ciclo.
    if not character.Parent or LP.Character ~= character then return end
    if humanoid.Health <= 0 then return end

    -- Non e' morto: si rimette tutto com'era e si dichiara la rinuncia.
    _G._AmbitiousResetGaveUp = true
    pcall(function()
        humanoid.PlatformStand = savedPlatform
        humanoid.BreakJointsOnDeath = savedBreak
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end)
end

-- ---------- V1: HIPHEIGHT ----------
_G._AmbitiousDoInstantResetV1 = function()
    _G._AmbitiousResetGaveUp = false
    local character = LP.Character
    if not character then _G._AmbitiousResetGaveUp = true return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then _G._AmbitiousResetGaveUp = true return end

    local originalHipHeight = humanoid.HipHeight
    local attempts = 0
    local done = false

    while character and character.Parent and humanoid
          and humanoid.Health > 0 and LP.Character == character
          and attempts < 40 do
        pcall(function()
            humanoid.HipHeight = 1e30
            humanoid.AutoRotate = true
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)

        if not character.Parent or humanoid.Health <= 0 or LP.Character ~= character then
            done = true
            break
        end

        attempts = attempts + 1
        task.wait(0.05)
    end

    -- Fallback: se il trucco dell'HipHeight non ha funzionato
    if not done and character and character.Parent and humanoid and humanoid.Health > 0 then
        pcall(function() humanoid.Health = 0 end)
        task.wait(0.1)
        if not character.Parent or humanoid.Health <= 0 then done = true end
    end

    -- Se non e' morto comunque, rimetti tutto a posto
    if not done then
        _G._AmbitiousResetGaveUp = true
        if character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end)
        end
    end
end

-- Smistatore. Tutto il contorno â€” camera bloccata, Anti Die e Anti Void
-- sospesi, attesa del respawn â€” resta in AmbitiousInstantReset ed e'
-- identico per le due versioni: cambia solo COME si muore.
_G._AmbitiousDoInstantReset = function()
    if (tonumber(_G.AmbitiousInstantResetVersion) or 1) == 2 then
        _G._AmbitiousDoInstantResetV2()
    else
        _G._AmbitiousDoInstantResetV1()
    end
end

_G._AmbitiousResetCamConn = nil
_G._AmbitiousResetCamSaved = nil

-- Congela la camera esattamente dove sta guardando adesso
_G._AmbitiousLockResetCamera = function()
    local cam = workspace.CurrentCamera
    if not cam then return end

    _G._AmbitiousUnlockResetCamera()

    _G._AmbitiousResetCamSaved = {
        cframe  = cam.CFrame,
        type    = cam.CameraType,
        subject = cam.CameraSubject,
    }

    cam.CameraType = Enum.CameraType.Scriptable

    -- Roblox puo' riassegnare la camera al respawn: la riportiamo
    -- al fotogramma salvato ad ogni frame finche' non sblocchiamo.
    _G._AmbitiousResetCamConn = RunService.RenderStepped:Connect(function()
        local c = workspace.CurrentCamera
        local saved = _G._AmbitiousResetCamSaved
        if not c or not saved then return end
        if c.CameraType ~= Enum.CameraType.Scriptable then
            c.CameraType = Enum.CameraType.Scriptable
        end
        c.CFrame = saved.cframe
    end)
end

_G._AmbitiousUnlockResetCamera = function()
    if _G._AmbitiousResetCamConn then
        pcall(function() _G._AmbitiousResetCamConn:Disconnect() end)
        _G._AmbitiousResetCamConn = nil
    end

    local saved = _G._AmbitiousResetCamSaved
    _G._AmbitiousResetCamSaved = nil
    if not saved then return end

    local cam = workspace.CurrentCamera
    if not cam then return end

    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        cam.CameraType = (saved.type == Enum.CameraType.Scriptable)
            and Enum.CameraType.Custom or saved.type
        cam.CameraSubject = hum or saved.subject
    end)
end

-- Punto d'ingresso: stacca Anti Die, resetta, dopo 0.5s lo riattacca
_G.AmbitiousInstantReset = function()
    if _G._AmbitiousInstantResetBusy then return end
    _G._AmbitiousInstantResetBusy = true

    local wasAntiDie = (antiDieEnabled == true)
    -- >>> INSTANT RESET / ANTI VOID BEGIN
    -- L'Anti Void teletrasporta chi finisce fuori mappa: durante il reset
    -- lavorerebbe contro di noi, quindi va messo in pausa come l'Anti Die.
    -- Il toggle NON si spegne a schermo e la config non registra un "off":
    -- e' una sospensione in background, non una scelta dell'utente.
    local wasAntiVoid = (_G.AmbitiousAntiVoidEnabled == true)
    -- <<< INSTANT RESET / ANTI VOID END
    _G._AmbitiousResetOldChar = LP.Character
    _G._AmbitiousResetGaveUp = false

    -- >>> INSTANT RESET / ANTI VOID BEGIN
    if wasAntiVoid then
      _G._AmbitiousAntiVoidPaused = true
      if _G.AmbitiousAntiVoid then
        pcall(_G.AmbitiousAntiVoid.setEnabled, false)
      end
      if _SV.setAntiVoidVisual then pcall(_SV.setAntiVoidVisual, true) end
    end
    -- <<< INSTANT RESET / ANTI VOID END

    if wasAntiDie then
        -- Spegnimento tecnico e temporaneo: in silenzio, cosi' non tocca
        -- ne' la riga ne' il config (prima li muoveva e li rimetteva a
        -- posto subito dopo, con il toggle che lampeggiava).
        pcall(stopAntiDie, true)
        antiDieEnabled = true
        if _SV.setAntiDieVisual then pcall(_SV.setAntiDieVisual, true) end
    end

    pcall(_G._AmbitiousLockResetCamera)

    task.spawn(function()
        pcall(_G._AmbitiousDoInstantReset)
    end)

    -- >>> INSTANT RESET / ANTI VOID BEGIN
    -- La camera resta bloccata FINO AL RESPAWN VERO. Prima bastava che il
    -- nuovo personaggio esistesse con vita sopra zero: in quell'istante il
    -- gioco lo sta ancora costruendo, e sbloccando li' si vedeva lo scatto.
    -- Ora si aspetta anche che sia pronto (root e humanoid a posto).
    task.spawn(function()
        local oldChar = _G._AmbitiousResetOldChar
        local deadline = tick() + 25
        while tick() < deadline do
            -- il reset ha rinunciato: non morira' mai, sblocca subito
            if _G._AmbitiousResetGaveUp then break end
            local ch = LP.Character
            if ch and ch.Parent and ch ~= oldChar then
                if _G._AmbitiousWaitCharReady then
                    pcall(_G._AmbitiousWaitCharReady, ch, 10)
                end
                local hum = ch:FindFirstChildOfClass("Humanoid")
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then break end
            end
            task.wait(0.05)
        end
        pcall(_G._AmbitiousUnlockResetCamera)

        -- Anti Void ripreso solo qui: rimetterlo prima significherebbe
        -- riaccenderlo su un cadavere o a meta' respawn.
        if wasAntiVoid then
            if _G.AmbitiousAntiVoid then
                pcall(_G.AmbitiousAntiVoid.setEnabled, true)
            end
            _G._AmbitiousAntiVoidPaused = false
            if _SV.setAntiVoidVisual then pcall(_SV.setAntiVoidVisual, true) end
        end
    end)
    -- <<< INSTANT RESET / ANTI VOID END

    task.delay(0.5, function()
        if not wasAntiDie then
            _G._AmbitiousInstantResetBusy = false
            return
        end

        task.spawn(function()
            -- Non riattaccare l'Anti Die su un personaggio morto: il suo loop
            -- Heartbeat curerebbe il cadavere e annullerebbe il reset.
            -- Se il reset e' fallito il personaggio e' ancora vivo e si riattacca
            -- subito; altrimenti si aspetta il respawn.
            local deadline = tick() + 20
            while tick() < deadline do
                local ch = LP.Character
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                if ch and ch.Parent and hum and hum.Health > 0 then break end
                task.wait(0.1)
            end

            -- rimessa a false perche' setAntiDie/startAntiDie ripartano puliti
            antiDieEnabled = false
            pcall(setAntiDie, true)
            if _SV.setAntiDieVisual then pcall(_SV.setAntiDieVisual, true) end
            _G._AmbitiousInstantResetBusy = false
        end)
    end)
end

_G.AmbitiousNormalInfJump = _G.AmbitiousNormalInfJump or {holdPressed=false, holdActive=false, controllerActive=false, mobilePressed=false, mobileActive=false, hooked={}}

_G.AmbitiousNormalInfJump = _G.AmbitiousNormalInfJump or {
    holdPressed = false,
    holdActive = false,
    controllerActive = false,
    mobilePressed = false,
    mobileActive = false,
    hooked = {}
}

-- >>> ROOT VELOCITY <<<
-- Il proxy del jump non esiste piu'. Era una Part invisibile saldata
-- all'HRP: essendo saldata faceva parte della stessa assembly, quindi
-- scriverci sopra la AssemblyLinearVelocity equivaleva gia' a scrivere sulla
-- root, solo per vie traverse. Ora si scrive direttamente sull'HRP, che e'
-- lo stesso metodo usato quando l'Anti Bat e' attivo.
--
-- La funzione conserva il nome storico e restituisce l'HRP: tutti i punti
-- che facevano "local proxy = _jumpEnsureProxy(); proxy.Velocity
-- = ..." continuano a funzionare e ora agiscono sulla root (Drop TP Up,
-- Slow Fall, Infinite Jump...).
local _jumpProxy = nil
local _jumpProxyWeld = nil

function _G._jumpEnsureProxy()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

-- Applica il boost di salto sulla root velocity
function _G.AmbitiousApplyNormalInfJumpBoost(boost)
    if not infJumpEnabled then return end
    -- Blocca il jump se il TP Down e' in corso (Normal o Slow Fall):
    -- senza questo l'inf-jump annullerebbe la discesa.
    if _G._AmbitiousTPDownJumpLocked then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    local proxy = _G._jumpEnsureProxy()
    if not proxy then return end

    -- Mantiene X e Z invariati, modifica solo Y (root velocity)
    local curVel = proxy.Velocity
    proxy.Velocity = Vector3.new(curVel.X, boost or 50, curVel.Z)
end

-- Resetta gli stati di pressione (identico)
function _G.AmbitiousStopNormalInfJumpHoldState()
    local S = _G.AmbitiousNormalInfJump
    S.holdPressed = false
    S.holdActive = false
    S.controllerActive = false
    S.mobilePressed = false
    S.mobileActive = false
end

-- ===== INPUT HANDLER (tastiera, gamepad, mobile) =====

-- JumpRequest (trigger immediato)
-- In MANUAL mode: singolo hop per ogni pressione, nessun hold loop
-- In HOLD mode: comportamento originale (boost continuo finchÃ© tieni premuto)
UserInputService.JumpRequest:Connect(function()
    _G.AmbitiousApplyNormalInfJumpBoost(50)
end)

-- InputBegan (per tenere premuto)
UserInputService.InputBegan:Connect(function(input)
    if UserInputService:GetFocusedTextBox() then return end
    local S = _G.AmbitiousNormalInfJump

    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        if infJumpMode == "MANUAL" then
            -- MANUAL: JumpRequest gestisce giÃ  il singolo hop, non attiviamo hold
            return
        end
        -- HOLD: logica originale
        S.holdPressed = true
        task.delay(0.12, function()
            if _G.AmbitiousNormalInfJump.holdPressed and infJumpEnabled then
                _G.AmbitiousNormalInfJump.holdActive = true
                _G.AmbitiousApplyNormalInfJumpBoost(50)
            end
        end)
    elseif input.KeyCode == Enum.KeyCode.ButtonA and input.UserInputType.Name:match("^Gamepad") then
        if infJumpMode ~= "MANUAL" then
            S.controllerActive = true
        end
    end
end)

-- InputEnded (rilascio tasti)
UserInputService.InputEnded:Connect(function(input)
    local S = _G.AmbitiousNormalInfJump
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        S.holdPressed = false
        S.holdActive = false
    end
    if input.KeyCode == Enum.KeyCode.ButtonA and input.UserInputType.Name:match("^Gamepad") then
        S.controllerActive = false
    end
end)

-- Hook per il pulsante mobile JumpButton
function _G.AmbitiousHookNormalInfMobileJumpButton(obj)
    local S = _G.AmbitiousNormalInfJump
    if not obj or obj.Name ~= "JumpButton" or not obj:IsA("GuiButton") or S.hooked[obj] then return end
    S.hooked[obj] = true

    obj.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch or not infJumpEnabled then return end
        if infJumpMode == "MANUAL" then
            -- MANUAL mobile: JumpRequest giÃ  triggerato dal sistema, non attiviamo hold
            return
        end
        -- HOLD mobile: logica originale
        _G.AmbitiousNormalInfJump.mobilePressed = true
        task.delay(0.12, function()
            if _G.AmbitiousNormalInfJump.mobilePressed and infJumpEnabled then
                _G.AmbitiousNormalInfJump.mobileActive = true
                _G.AmbitiousApplyNormalInfJumpBoost(50)
            end
        end)
    end)

    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            _G.AmbitiousNormalInfJump.mobilePressed = false
            _G.AmbitiousNormalInfJump.mobileActive = false
        end
    end)

    obj.AncestryChanged:Connect(function(_, parent)
        if not parent then
            _G.AmbitiousNormalInfJump.hooked[obj] = nil
            _G.AmbitiousNormalInfJump.mobilePressed = false
            _G.AmbitiousNormalInfJump.mobileActive = false
        end
    end)
end

-- Hook per pulsanti giÃ  esistenti/futuri. Guardato per evitare errori se PlayerGui
-- non Ã¨ ancora disponibile nell'executor.
do
    local _pg = PlayerGui or (LP and LP:FindFirstChildOfClass("PlayerGui"))
    if _pg then
        for _, obj in ipairs(_pg:GetDescendants()) do
            _G.AmbitiousHookNormalInfMobileJumpButton(obj)
        end
        _pg.DescendantAdded:Connect(function(obj)
            task.defer(function()
                if obj and obj.Parent then
                    _G.AmbitiousHookNormalInfMobileJumpButton(obj)
                end
            end)
        end)
    end
end


-- ===== HEARTBEAT LOOP (mantiene il boost quando premuto, solo in HOLD mode) =====
RunService.Heartbeat:Connect(function()
    local S = _G.AmbitiousNormalInfJump
    if infJumpEnabled and infJumpMode == "HOLD" and (S.holdActive or S.mobileActive or S.controllerActive) then
        _G.AmbitiousApplyNormalInfJumpBoost(50)
    end
end)

-- ===== SETTER (chiamato dal toggle UI) =====
setInfJumpInternal = function(on)
    infJumpEnabled = on and true or false
    if not infJumpEnabled then
        _G.AmbitiousStopNormalInfJumpHoldState()
        -- Azzera la velocita' della root quando si disattiva
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function() hrp.Velocity = Vector3.zero end)
        end
    end
end

-- ===== RESPAWN: ricrea il proxy quando il personaggio viene rigenerato =====
LP.CharacterAdded:Connect(function(char)
    _G._AmbitiousWaitCharReady(char, 10)
    _jumpProxy = nil
    _jumpProxyWeld = nil
    -- Se il jump Ã¨ attivo, ricrea subito il proxy
    if infJumpEnabled then
        _G._jumpEnsureProxy()
    end
end)

-- [FIX 1] RESPAWN: riavvia l'anti-ragdoll dopo ogni respawn.
-- Senza questo, dopo una morte il Heartbeat era ancora collegato ma
-- il personaggio era nuovo, e in alcuni giochi il ragdoll veniva
-- applicato subito allo spawn prima che il loop potesse reagire.
-- Disconnettiamo e ricreiamo la connessione cosÃ¬ il cooldown viene
-- anche resettato e parte pulito sul nuovo personaggio.
LP.CharacterAdded:Connect(function(char)
    _G._AmbitiousWaitCharReady(char, 10)
    if antiRagdollEnabled then
        if antiRagdollConn then
            antiRagdollConn:Disconnect()
            antiRagdollConn = nil
        end
        if _G._AmbitiousStopARV2 then _G._AmbitiousStopARV2() end
        startAntiRagdoll()
    end
end)

-- ===== AVVIO: crea il proxy se il giocatore Ã¨ giÃ  spawnato =====
if LP.Character then
    task.wait(0.1)
    if infJumpEnabled then
        _G._jumpEnsureProxy()
    end
end

local currentBackground = 1
local ambitiousGuiScaleValue = 0.75
local ambitiousProgressBarScaleValue = 0.90

CONFIG_FILE = "AmbitiousHub_Config.json"
KEYBINDS_CONFIG_FILE = "AmbitiousHub_Keybinds.json"
_ambitious_isfile = isfile or (syn and syn.isfile) or function(path)
  local ok, result = pcall(function() return readfile(path) end)
  return ok and result ~= nil
end
_ambitious_readfile = readfile or (syn and syn.readfile)
_ambitious_writefile = writefile or (syn and syn.writefile)
canSaveConfig = (type(_ambitious_readfile) == "function" and type(_ambitious_writefile) == "function")

-- Intro
selectedIntroMusic = 1 -- fixed: the only intro song
_introEnabled = (_introEnabled ~= false)
setIntroVisual = nil
INTRO_MUSIC_OPTIONS = {
  {name="Padre Nostro", url="https://commons.wikimedia.org/wiki/Special:Redirect/file/Pater_noster.ogg", file="GesuHub_PadreNostro.ogg"},
}

function getIntroSongName()
  local opt = INTRO_MUSIC_OPTIONS[selectedIntroMusic]
  return opt and opt.name or "No Songs Added"
end

introPreviewSound = nil
introPlaybackSound = nil
introPreviewToken = 0
introPlaybackToken = 0
introSongCache = introSongCache or {}
introSongDownloading = introSongDownloading or {}

function stopIntroPreview()
  introPreviewToken = introPreviewToken + 1
  if introPreviewSound then
    local sound = introPreviewSound
    local fadeTween = TweenService:Create(sound, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {
      Volume = 0
    })
    fadeTween:Play()
    task.delay(1.6, function()
      pcall(function()
        if sound and sound.Parent then
          sound:Stop()
          sound:Destroy()
        end
      end)
    end)
    introPreviewSound = nil
  end
end

function stopIntroPlayback()
  introPlaybackToken = introPlaybackToken + 1
  
  -- Fade away del volume prima di distruggere il sound
  if introPlaybackSound then
    local sound = introPlaybackSound
    local startVol = sound.Volume
    
    -- Crea un tween per abbassare il volume gradualmente in 1.5 secondi
    local fadeTween = TweenService:Create(sound, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {
      Volume = 0
    })
    
    fadeTween:Play()
    
    -- Distrugge il sound dopo che il fade Ã¨ completato
    task.delay(1.6, function()
      pcall(function()
        if sound and sound.Parent then
          sound:Stop()
          sound:Destroy()
        end
      end)
    end)
    
    introPlaybackSound = nil
  end
end

function _safeNotify(msg)
  if showActionNotification then pcall(function() showActionNotification(msg) end) end
end

-- Padre Nostro: audio pubblico da Wikimedia Commons (Pater noster.ogg, public domain).

function cacheIntroSong(option, allowDownload)
  if not option then return nil end
  if not (getcustomasset and (isfile or writefile)) then return nil end
  local fileName = option.file or ("AmbitiousHubIntroSong_" .. tostring(option.name or "song") .. ".mp3")
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
  -- Se il file e' locale non serve alcun download web.
  if not option.url or option.url == "" then return nil end
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

function preloadIntroSongs()
  task.spawn(function()
    cacheIntroSong(INTRO_MUSIC_OPTIONS[selectedIntroMusic], true)
    for _, option in ipairs(INTRO_MUSIC_OPTIONS) do
      if option ~= INTRO_MUSIC_OPTIONS[selectedIntroMusic] then
        cacheIntroSong(option, true)
        task.wait(0.05)
      end
    end
  end)
end

function makeIntroSoundFromId(soundId, name, parent)
  if not soundId then return nil end
  local sound = Instance.new("Sound")
  sound.Name = name or "AmbitiousHubIntroMusic"
  sound.Volume = 0.65
  sound.Looped = false
  sound.SoundId = soundId
  sound.Parent = parent or SoundService
  return sound
end

function createIntroSound(option, fileName, parent, allowDownload)
  if not option then return nil end
  local soundId = cacheIntroSong(option, allowDownload)
  if not soundId then return nil end
  return makeIntroSoundFromId(soundId, fileName, parent)
end

function previewIntroMusic(index)
  stopIntroPreview()
  stopIntroPlayback()
  if not INTRO_MUSIC_OPTIONS[index] then _safeNotify("ADD SONG LINKS"); return end
  local token = introPreviewToken
  task.spawn(function()
    local option = INTRO_MUSIC_OPTIONS[index]
    local sound = createIntroSound(option, "AmbitiousHubIntroPreview_" .. tostring(token), SoundService, true)
    if token ~= introPreviewToken then if sound then sound:Destroy() end; return end
    introPreviewSound = sound
    if not sound then _safeNotify("SONG LOADING..."); return end
    sound.TimePosition = 0
    pcall(function() sound:Play() end)
    task.delay(10, function() if token == introPreviewToken then stopIntroPreview() end end)
  end)
end

function playIntroMusic()
  stopIntroPreview()
  stopIntroPlayback()
  if not _introEnabled then return end
  local option = INTRO_MUSIC_OPTIONS[selectedIntroMusic]
  if not option then return end
  local token = introPlaybackToken
  task.spawn(function()
    local sound = createIntroSound(option, "AmbitiousDuelsIntroMusic_" .. tostring(token), SoundService, true)
    if token ~= introPlaybackToken or not _introEnabled then if sound then pcall(function() sound:Destroy() end) end; return end
    introPlaybackSound = sound
    if not sound then _safeNotify("SONG FAILED"); return end
    sound.TimePosition = 0
    local loadStart = tick()
    while sound and not sound.IsLoaded and tick() - loadStart < 10 do task.wait(0.05) end
    pcall(function() sound:Play() end)
    task.delay(10, function() if token == introPlaybackToken then stopIntroPlayback() end end)
  end)
end

preloadIntroSongs()

savedConfig = {}
_G.AmbitiousGuiLocked = _G.AmbitiousGuiLocked == true
_G.AmbitiousHideMobileButtons = _G.AmbitiousHideMobileButtons == true
-- >>> HIDE PER SINGOLO BOTTONE <<<
-- Lista e helper stanno QUI, in cima: la UI delle impostazioni viene
-- costruita prima del modulo dei bottoni mobile, e definirli la' dentro
-- significava chiamarli quando ancora non esistevano.
-- Una chiave assente vuol dire "incluso": cosi' di default il toggle
-- nasconde tutti i bottoni, come ha sempre fatto.
_G.AmbitiousMobileHideList = _G.AmbitiousMobileHideList or {}
_G.AmbitiousMobileHideIncluded = function(key)
  local v = _G.AmbitiousMobileHideList[key]
  if v == nil then return true end
  return v == true
end
_G.AmbitiousMobileButtonScale = 0.75
_G.AmbitiousMobileButtonPositions = _G.AmbitiousMobileButtonPositions or {}
savedMainPositionTable = nil
savedMiniPositionTable = nil
-- Posizione salvata della Steal Bar (barra progresso auto steal)
savedStealBarPositionTable = nil

function udim2ToTable(u)
  return {xs = u.X.Scale, xo = u.X.Offset, ys = u.Y.Scale, yo = u.Y.Offset}
end

function tableToUDim2(t, fallback)
  if type(t) == "table" then
    return UDim2.new(tonumber(t.xs) or 0, tonumber(t.xo) or 0, tonumber(t.ys) or 0, tonumber(t.yo) or 0)
  end
  return fallback
end

function collectAmbitiousMobileButtonPositions()
  local out = {}
  for key, entry in pairs(_G.AmbitiousMobileButtonRefs or {}) do
    local holder = entry and entry.holder
    if holder then out[key] = udim2ToTable(holder.Position) end
  end
  if next(out) == nil and type(_G.AmbitiousMobileButtonPositions) == "table" then
    return _G.AmbitiousMobileButtonPositions
  end
  _G.AmbitiousMobileButtonPositions = out
  return out
end

function keyToString(key)
  if not key then return "None" end
  if key == "MB3" then return "MB3" end
  return tostring(key):gsub("Enum.KeyCode.", "")
end

function stringToKeyCode(value)
  if type(value) ~= "string" or value == "" or value == "None" then return nil end
  if value == "MB3" then return "MB3" end
  return Enum.KeyCode[value]
end

function keybindsToTable()
  local out = {}
  for keyId in pairs(DEFAULT_SPEED_KEYBINDS) do
    out[keyId] = keyToString(speedKeybinds[keyId])
  end
  for keyId, key in pairs(speedKeybinds) do
    out[keyId] = keyToString(key)
  end
  return out
end

function collectAmbitiousKeybindConfig()
  return {
    keybinds = keybindsToTable(),
    tpDownKeybind = keyToString(tpDownKeybind),
  }
end

function applySavedKeybinds(t)
  if type(t) ~= "table" then return end
  for keyId in pairs(speedKeybinds) do
    if t[keyId] ~= nil then
      speedKeybinds[keyId] = stringToKeyCode(t[keyId])
    end
  end
end

function applyDefaultAmbitiousKeybinds()
  for keyId, key in pairs(DEFAULT_SPEED_KEYBINDS) do
    speedKeybinds[keyId] = key
  end
  tpDownKeybind = DEFAULT_TP_DOWN_KEYBIND
end

-- ============================================================
-- LOOK AT ENEMY (GLOBALE)
-- ============================================================
_G.AmbitiousLookAtEnabled = false
_G.AmbitiousLookAtRadius  = _G.AmbitiousLookAtRadius  or 20

_G._AmbitiousLookAt = _G._AmbitiousLookAt or {}
do
  local S = _G._AmbitiousLookAt
  local hiddenLAE    = workspace:FindFirstChild("Terrain") or workspace
  S.externalPart     = nil
  S.alignObj         = nil
  S.alignConn        = nil
  S.diedConn         = nil

  local function _laeGetClosest()
    local char  = LP.Character
    local myHRP = char and char:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    local radius = tonumber(_G.AmbitiousLookAtRadius) or 20
    local closest, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LP then
        local tc = player.Character
        if tc then
          local tHRP = tc:FindFirstChild("HumanoidRootPart")
          local tHum = tc:FindFirstChildOfClass("Humanoid")
          if tHRP and tHum and tHum.Health > 0 then
            -- >>> ANTI VOID BEGIN
            -- Nel void la distanza si misura sulla posizione fantasma,
            -- altrimenti il nemico esce dal raggio e non lo si aggancia.
            local tPos = tHRP.Position
            if _G.AmbitiousAntiVoid then
              tPos = _G.AmbitiousAntiVoid.posForPart(tHRP, tPos)
            end
            local dist = (myHRP.Position - tPos).Magnitude
            -- <<< ANTI VOID END
            if dist <= radius and dist < closestDist then
              closestDist = dist
              closest = tHRP
            end
          end
        end
      end
    end
    return closest
  end

  local function _laeStop()
    if S.alignConn  then S.alignConn:Disconnect();  S.alignConn  = nil end
    if S.diedConn   then S.diedConn:Disconnect();   S.diedConn   = nil end
    for _, obj in ipairs(hiddenLAE:GetChildren()) do
      if obj.Name:find("LAEAnchor_") or obj.Name == "LAEOrientation" then
        obj:Destroy()
      end
    end
    S.externalPart = nil
    S.alignObj     = nil
    local char = LP.Character
    if char then
      local hum = char:FindFirstChildOfClass("Humanoid")
      if hum then hum.AutoRotate = true end
    end
  end

  local function _laeStart()
    _laeStop()
    local char  = LP.Character
    if not char then return end
    local myHRP = char:FindFirstChild("HumanoidRootPart")
    local hum   = char:FindFirstChildOfClass("Humanoid")
    if not myHRP or not hum or hum.Health <= 0 then return end

    S.diedConn = hum.Died:Connect(function() _laeStop() end)

    local ep = Instance.new("Part")
    ep.Name = "LAEAnchor_" .. tostring(math.random(1000,9999))
    ep.Size = Vector3.new(1,1,1)
    ep.Transparency = 1
    ep.CanCollide = false
    ep.Anchored = true
    ep.CFrame = myHRP.CFrame
    ep.Parent = hiddenLAE
    S.externalPart = ep

    local attExt   = Instance.new("Attachment", ep)
    local attLocal = myHRP:FindFirstChild("RootAttachment")
    if not attLocal then
      attLocal      = Instance.new("Attachment")
      attLocal.Name = "RootAttachment"
      attLocal.Parent = myHRP
    end

    local ao = Instance.new("AlignOrientation")
    ao.Name               = "LAEOrientation"
    ao.Mode               = Enum.OrientationAlignmentMode.TwoAttachment
    ao.Attachment0        = attLocal
    ao.Attachment1        = attExt
    ao.MaxTorque          = 999999
    ao.MaxAngularVelocity = 999999
    ao.Responsiveness     = 200
    ao.Enabled            = false
    ao.Parent             = hiddenLAE
    S.alignObj = ao

    S.alignConn = RunService.Heartbeat:Connect(function()
      local cc  = LP.Character
      local cHRP = cc and cc:FindFirstChild("HumanoidRootPart")
      local cHum = cc and cc:FindFirstChildOfClass("Humanoid")
      if not cHRP or not cHum or cHum.Health <= 0 then _laeStop(); return end
      local tHRP = _laeGetClosest()
      if tHRP and S.externalPart and S.alignObj then
        cHum.AutoRotate = false
        S.alignObj.Enabled = true
        -- >>> ANTI VOID BEGIN
        local _laePos = tHRP.Position
        if _G.AmbitiousAntiVoid then
          _laePos = _G.AmbitiousAntiVoid.posForPart(tHRP, _laePos)
        end
        local flat = Vector3.new(_laePos.X, cHRP.Position.Y, _laePos.Z)
        -- <<< ANTI VOID END
        S.externalPart.CFrame = CFrame.lookAt(cHRP.Position, flat)
      else
        cHum.AutoRotate = true
        if S.alignObj then S.alignObj.Enabled = false end
      end
    end)
  end

  function _G.AmbitiousToggleLookAt(state)
    if state ~= nil then
      _G.AmbitiousLookAtEnabled = state
    else
      _G.AmbitiousLookAtEnabled = not _G.AmbitiousLookAtEnabled
    end
    if _G.AmbitiousLookAtEnabled then _laeStart() else _laeStop() end
  end

  function _G.AmbitiousStopLookAt() _laeStop() end
  function _G.AmbitiousStartLookAt() _laeStart() end

  LP.CharacterAdded:Connect(function(newChar)
    _laeStop()
    if _G.AmbitiousLookAtEnabled then
      local hrp = newChar:WaitForChild("HumanoidRootPart", 5)
      local hum2 = newChar:WaitForChild("Humanoid", 5)
      if hrp and hum2 then task.wait(0.1); _laeStart() end
    end
  end)

  LP.CharacterRemoving:Connect(function() _laeStop() end)
end

function collectAmbitiousConfig()
      local savedStretchIdx = stretchCurrentIndex
  local savedStretchEn = stretchEnabled

  if _G.AmbitiousTrackerActive and _G.AmbitiousTrackerSavedStretchIndex then
      savedStretchIdx = _G.AmbitiousTrackerSavedStretchIndex
      savedStretchEn = savedStretchIdx ~= 1
  end
  return {
    mainPosition = savedMainPositionTable,
    stealBarPosition = savedStealBarPositionTable,
    keybinds = keybindsToTable(),
    tpDownKeybind = keyToString(tpDownKeybind),
    trackerColor = BoxedESPOptions and BoxedESPOptions.trackerColor and {
      r = math.floor(BoxedESPOptions.trackerColor.R * 255 + 0.5),
      g = math.floor(BoxedESPOptions.trackerColor.G * 255 + 0.5),
      b = math.floor(BoxedESPOptions.trackerColor.B * 255 + 0.5),
    } or nil,
    NS = NS,
    CS = CS,
    LAGGER_SPEED = LAGGER_SPEED,
    LAGGER_CARRY_SPEED = LAGGER_CARRY_SPEED,
    currentSpeedMode = currentSpeedMode,
    autoCarrySpeedEnabled = autoCarrySpeedEnabled == true,
    autoCarryMode = (_G._AmbitiousAutoCarryMode == "SOFT") and "SOFT" or "NORMAL",
    autoTPEnabled = autoTPEnabled,
    autoTPHeight = autoTPHeight,
    tpDownMethod = _G._AmbitiousTPDownMethod or "NORMAL",   -- >>> TP DOWN METHOD <<<
    infJumpEnabled = infJumpEnabled,
    infJumpMode = infJumpMode,
    lookAtEnabled = _G.AmbitiousLookAtEnabled == true,
    lookAtRadius  = tonumber(_G.AmbitiousLookAtRadius) or 20,
    antiRagdollEnabled = antiRagdollEnabled,
    antiRagdollMode = _G._AmbitiousAntiRagdollMode or "V1",
    -- si salva quello che hai scelto tu, non l'accensione automatica
    antiDieEnabled = _G._AmbitiousAntiDieUserWanted == true,
    selectedDropMode = selectedDropMode,
    instantResetVersion = tonumber(_G.AmbitiousInstantResetVersion) or 1,
    selectedStealMode = selectedStealMode,
    selectedSemiMode = selectedSemiMode,
    autoStealEnabled = autoStealEnabled,
    autoStealRadius = autoStealRadius,
    jesusModeEnabled = _G.AmbitiousJesusMode and _G.AmbitiousJesusMode.enabled == true or false,
    syncAfterHitEnabled = _G._AmbitiousSyncAfterHit.enabled,
    ambitiousStealRadii = _G.AmbitiousStealRadii,
    semiAutoGrabStopTime     = _G.AmbitiousSemiSteal and _G.AmbitiousSemiSteal.autoGrabStopTime     or 1.29,
    semiAutoGrabStopPercent  = _G.AmbitiousSemiSteal and _G.AmbitiousSemiSteal.autoGrabStopPercent  or 75,
    semiAutoGrabDelayRadius  = _G.AmbitiousSemiSteal and _G.AmbitiousSemiSteal.autoGrabSetDelayRadius or 8,
    selectedAimbotMode = selectedAimbotMode,
    AIMBOT_SPEED = AIMBOT_SPEED,
    LAGGER_AIMBOT_SPEED = LAGGER_AIMBOT_SPEED,
    BAT_AIMBOT_V2_SPEED = _G.AmbitiousBatAimbotV2Speed,
    BAT_AIMBOT_V2_LAGGER_SPEED = _G.AmbitiousBatAimbotV2LaggerSpeed,
    mirrorTPDownEnabled = mirrorTPDownEnabled,
    normalAimbotEnabled = _G.AmbitiousNormalAimbotOn == true,
    batTpEnabled = _G.AmbitiousBatTPOn == true,
    batAimbotV2Enabled = _G.AmbitiousBatAimbotV2On == true,
    aimbotChaseV1 = (_G._AmbitiousAimbotChase and _G._AmbitiousAimbotChase.V1) or "NORMAL",   -- >>> AIMBOT CHASE MODE <<<
    aimbotChaseV2 = (_G._AmbitiousAimbotChase and _G._AmbitiousAimbotChase.V2) or "NORMAL",   -- >>> AIMBOT CHASE MODE <<<
    batCounterEnabled = batCounterEnabled,
    batCounterMode = batCounterMode,
    medCounterEnabled = medCounterEnabled,
    antiBatEnabled = _G.AmbitiousAntiBatEnabled == true,   -- >>> ANTI BAT <<<
    -- Durante un Instant Reset l'Anti Void e' sospeso: si salva comunque
    -- acceso, altrimenti un salvataggio in quella finestra lo spegnerebbe
    -- per la prossima sessione.
    antiVoidEnabled = (_G.AmbitiousAntiVoidEnabled == true)
                   or (_G._AmbitiousAntiVoidPaused == true),   -- >>> ANTI VOID <<<

    safeMode = antiKickEnabled == true,
    espEnabled = espEnabled,
    showTrackerEnabled = showTrackerEnabled,
    ragdollCountdownEnabled = ragdollCountdownEnabled,
    fpsBoostEnabled = fpsBoostEnabled,
    antiLagVisualEnabled = antiLagVisualEnabled,
    vividGraphicsEnabled = vividGraphicsEnabled,
    vividSaturation = _G._AmbitiousVivid.saturation,
    vividBloomIntensity = _G._AmbitiousVivid.bloomIntensity,
    vividBloomSize = _G._AmbitiousVivid.bloomSize,
    vividDofFocus = _G._AmbitiousVivid.dofFocus,
    vividSunIntensity = _G._AmbitiousVivid.sunIntensity,
    xrayEnabled = xrayEnabled,
    brainrotXRayEnabled = _G.AmbitiousBrainrotXRayEnabled == true,   -- >>> BRAINROT X-RAY <<<
    highPingWarningEnabled = highPingWarningEnabled,
    kickWarningEnabled = _G._AmbitiousKickWarn.enabled == true,
    ultimateAntiKick = _G.AmbitiousUAKEnabled == true,
    fovEnabled = fovEnabled,
    fovValue = fovValue,
    noCamCollisionEnabled = noCamCollisionEnabled,
    motionBlurEnabled = motionBlurEnabled,
    noPlayerCollisionEnabled = _G.AmbitiousNoPlayerCollisionEnabled,
    unwalkEnabled = unwalkEnabled,
    skyTheme = skyTheme,
    autoLeftEnabled = autoLeftEnabled,
    autoRightEnabled = autoRightEnabled,
    -- >>> AUTO PLAY <<< lato rilevato + server in cui e' stato rilevato.
    -- Questi tre restano vuoti se non si e' nel posto di gioco previsto:
    -- e' li' che sta il controllo, non qui.
    autoPlayJob  = _G.AmbitiousAutoPlay and _G.AmbitiousAutoPlay.saveJob or nil,
    autoPlaySide = _G.AmbitiousAutoPlay and _G.AmbitiousAutoPlay.saveSide or nil,
    currentBackground = currentBackground,
    customFont = _G.AmbitiousFontChoice or "Default",
    ambitiousGuiScaleValue = ambitiousGuiScaleValue,
    ambitiousProgressBarScaleValue = ambitiousProgressBarScaleValue,
    introEnabled = _introEnabled == true,
    guiLocked = _G.AmbitiousGuiLocked == true,
    hideMobileButtons = _G.AmbitiousHideMobileButtons == true,
    mobileHideList    = _G.AmbitiousMobileHideList,   -- >>> HIDE PER BOTTONE <<<
    ambitiousMobileButtonScale = _G.AmbitiousMobileButtonScale,
    mobileButtonPositions = collectAmbitiousMobileButtonPositions(),
    stretchCurrentIndex = savedStretchIdx,
    stretchEnabled = savedStretchEn,
    headlessEnabled = headlessEnabled == true,
    korbloxEnabled = korbloxEnabled == true,

    transparentToolsEnabled = _G.AmbitiousTransparentToolsEnabled == true,
    customSoundsEnabled     = _G.AmbitiousCustomSoundsEnabled == true,

    selectedAnimPackIndex = selectedAnimPackIndex or 1,
    customAnimIds = _G.AmbitiousCustomAnimIds,   -- >>> CUSTOM ANIM PACK <<<
    animPackSavedIndex = _animPackSavedIndex or 1,
  }
end

function saveAmbitiousConfig()
  if not canSaveConfig then return end
  pcall(function()
    _ambitious_writefile(CONFIG_FILE, HttpService:JSONEncode(collectAmbitiousConfig()))
    _ambitious_writefile(KEYBINDS_CONFIG_FILE, HttpService:JSONEncode(collectAmbitiousKeybindConfig()))
  end)
end

-- ========== STRETCH REZ (GLOBALE) ==========
local stretchPresets = {
    ["0.8"] = CFrame.new(0,0,0, 1,0,0, 0,0.45,0, 0,0,1),
    ["1.0"] = CFrame.new(0,0,0, 1,0,0, 0,0.65,0, 0,0,1),
    ["1.2"] = CFrame.new(0,0,0, 1,0,0, 0,0.82,0, 0,0,1),
}
local stretchPresetMapping = {
    ["X1"]   = nil,
    ["X1.5"] = "1.2",
    ["X2"]   = "1.0",
    ["X3"]   = "0.8",
}
local stretchPresetOrder = {"X1", "X1.5", "X2", "X3"}
stretchCurrentIndex = 1          -- reso globale (non local)
stretchEnabled = false           -- reso globale
currentStretch = nil
stretchRezConn = nil

local function applyStretchPreset(index)
    -- Se il tracker Ã¨ attivo, non siamo in fase di forzatura (lock) e l'utente sceglie un valore diverso da X1,
    -- aggiorna l'indice salvato in modo che il salvataggio usi quello.
    if not _G._ambitiousStretchUILock and _G.AmbitiousTrackerActive then
        _G.AmbitiousTrackerSavedStretchIndex = index
    end

    stretchCurrentIndex = index
    local label = stretchPresetOrder[index]
    local key = stretchPresetMapping[label]
    if key then
        currentStretch = stretchPresets[key]
        stretchEnabled = true
    else
        currentStretch = nil
        stretchEnabled = false
    end
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
    if stretchEnabled then
        stretchRezConn = RunService.RenderStepped:Connect(function()
            if not stretchEnabled or not currentStretch then
                if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
                return
            end
            local cam = workspace.CurrentCamera
            if cam and currentStretch then
                cam.CFrame = cam.CFrame * currentStretch
            end
        end)
    end
    if not _G._ambitiousStretchUILock and _G.AmbitiousRefreshStretchSelector then
        _G.AmbitiousRefreshStretchSelector()
    end
end

local function cycleStretch(direction)
    local newIdx = stretchCurrentIndex + direction
    if newIdx < 1 then newIdx = #stretchPresetOrder end
    if newIdx > #stretchPresetOrder then newIdx = 1 end
    applyStretchPreset(newIdx)
end

local function setStretchEnabled(on)
    if on then
        applyStretchPreset(stretchCurrentIndex == 1 and 2 or stretchCurrentIndex)
    else
        applyStretchPreset(1)
    end
end

-- Esponiamo le funzioni per usarle nella UI
_G.StretchRez = {
    apply = applyStretchPreset,
    cycle = cycleStretch,
    setEnabled = setStretchEnabled,
    getIndex = function() return stretchCurrentIndex end,
    isEnabled = function() return stretchEnabled end,
    getOrder = function() return stretchPresetOrder end,
}

function loadAmbitiousConfig()
  if not canSaveConfig or not _ambitious_isfile(CONFIG_FILE) then return end
  local ok, data = pcall(function()
    return HttpService:JSONDecode(_ambitious_readfile(CONFIG_FILE))
  end)
  if not ok or type(data) ~= "table" then return end
  savedConfig = data
  local keybindData = data
  pcall(function()
    if _ambitious_isfile(KEYBINDS_CONFIG_FILE) then
      local kb = HttpService:JSONDecode(_ambitious_readfile(KEYBINDS_CONFIG_FILE))
      if type(kb) == "table" then keybindData = kb end
    end
  end)
  savedMainPositionTable = data.mainPosition
  savedMiniPositionTable = nil
  savedStealBarPositionTable = type(data.stealBarPosition) == "table" and data.stealBarPosition or nil
  _G.AmbitiousGuiLocked = data.guiLocked == true
  _G.AmbitiousHideMobileButtons = data.hideMobileButtons == true
  _G.AmbitiousMobileHideList = (type(data.mobileHideList) == "table") and data.mobileHideList or {}
  _G.AmbitiousMobileButtonScale = math.clamp(tonumber(data.ambitiousMobileButtonScale) or tonumber(_G.AmbitiousMobileButtonScale) or 0.75, 0.30, 1.35)
  _G.AmbitiousMobileButtonPositions = type(data.mobileButtonPositions) == "table" and data.mobileButtonPositions or {}
  applySavedKeybinds(keybindData.keybinds)
  if keybindData.tpDownKeybind ~= nil then
    if tostring(keybindData.tpDownKeybind) == "None" then
      tpDownKeybind = nil
    else
      tpDownKeybind = stringToKeyCode(keybindData.tpDownKeybind) or DEFAULT_TP_DOWN_KEYBIND
    end
  end
  for keyId, defaultKey in pairs(DEFAULT_SPEED_KEYBINDS) do
    local savedKeys = keybindData and keybindData.keybinds
    if (not savedKeys or savedKeys[keyId] == nil) and speedKeybinds[keyId] == nil then
      speedKeybinds[keyId] = defaultKey
    end
  end
  NS = tonumber(data.NS) or NS
  CS = tonumber(data.CS) or CS
  LAGGER_SPEED = tonumber(data.LAGGER_SPEED) or LAGGER_SPEED
  LAGGER_CARRY_SPEED = tonumber(data.LAGGER_CARRY_SPEED) or LAGGER_CARRY_SPEED
  currentSpeedMode = data.currentSpeedMode or currentSpeedMode
  if currentSpeedMode ~= "Normal" and currentSpeedMode ~= "Carry" and currentSpeedMode ~= "Lagger" and currentSpeedMode ~= "Lagger Carry" then currentSpeedMode = "Normal" end
  autoCarrySpeedEnabled = data.autoCarrySpeedEnabled == true
  _G._AmbitiousAutoCarryMode = (data.autoCarryMode == "SOFT") and "SOFT" or "NORMAL"
  autoTPEnabled = data.autoTPEnabled == true
  autoTPHeight = tonumber(data.autoTPHeight) or autoTPHeight
  -- >>> TP DOWN METHOD <<<
  local _tpm = data.tpDownMethod
  _G._AmbitiousTPDownMethod = (_tpm == "SLOW" or _tpm == "ZIGZAG") and _tpm or "NORMAL"
  infJumpEnabled = data.infJumpEnabled == true
  if data.infJumpMode == "MANUAL" then infJumpMode = "MANUAL" else infJumpMode = "HOLD" end
  _G.AmbitiousLookAtEnabled = data.lookAtEnabled == true
  _G.AmbitiousLookAtRadius  = math.clamp(tonumber(data.lookAtRadius) or 20, 1, 200)
  antiRagdollEnabled = data.antiRagdollEnabled == true
  _G._AmbitiousAntiRagdollMode = (data.antiRagdollMode == "V2") and "V2" or "V1"
  antiDieEnabled = data.antiDieEnabled == true
  _G._AmbitiousAntiDieUserWanted = antiDieEnabled
  selectedDropMode = data.selectedDropMode or selectedDropMode
  _G.AmbitiousInstantResetVersion = math.clamp(tonumber(data.instantResetVersion) or 1, 1, 2)
  if selectedDropMode ~= "Stand Still" then selectedDropMode = "TP UP" end
  selectedStealMode = data.selectedStealMode or selectedStealMode
  if selectedStealMode ~= "Semi" then selectedStealMode = "Normal" end
  selectedSemiMode = data.selectedSemiMode or selectedSemiMode
  selectedSemiMode = "V3"
  autoStealEnabled = data.autoStealEnabled == true
  _G._AmbitiousSyncAfterHit.enabled = data.syncAfterHitEnabled == true
  if type(data.ambitiousStealRadii) == "table" then
    _G.AmbitiousStealRadii.Normal = tonumber(data.ambitiousStealRadii.Normal) or _G.AmbitiousStealRadii.Normal or 62
    _G.AmbitiousStealRadii.Semi = tonumber(data.ambitiousStealRadii.Semi) or _G.AmbitiousStealRadii.Semi or 60
    _G.AmbitiousStealRadii.SemiV2Radius = tonumber(data.ambitiousStealRadii.SemiV2Radius) or _G.AmbitiousStealRadii.SemiV2Radius or 60
    _G.AmbitiousStealRadii.SemiV2SemiRadius = tonumber(data.ambitiousStealRadii.SemiV2SemiRadius) or _G.AmbitiousStealRadii.SemiV2SemiRadius or 8
  end
  -- Fix: aggiorna il corretto slot di StealRadii in base al modo selezionato
  local _loadedRadius = tonumber(data.autoStealRadius) or autoStealRadius
  if not (type(data.ambitiousStealRadii) == "table") then
    -- Config vecchio senza ambitiousStealRadii: usa autoStealRadius per il modo corretto
    if selectedStealMode == "Semi" then
      _G.AmbitiousStealRadii.Semi = _loadedRadius
    else
      _G.AmbitiousStealRadii.Normal = _loadedRadius
    end
  end
  autoStealRadius = _loadedRadius
  -- Ripristina valori semi steal
  -- (AmbitiousSemiSteal non Ã¨ ancora inizializzato qui, li salviamo in pending)
  _G._AmbitiousSemiStealPending = {
    autoGrabStopTime       = math.clamp(tonumber(data.semiAutoGrabStopTime) or 1.29, 0.01, 1.29),
    autoGrabStopPercent    = math.clamp(tonumber(data.semiAutoGrabStopPercent) or 75, 1, 100),
    autoGrabSetDelayRadius = tonumber(data.semiAutoGrabDelayRadius) or 8,
  }
  if _G.AmbitiousSemiSteal then
    local A = _G.AmbitiousSemiSteal
    A.autoGrabStopTime       = _G._AmbitiousSemiStealPending.autoGrabStopTime
    A.autoGrabStopPercent    = _G._AmbitiousSemiStealPending.autoGrabStopPercent
    A.autoGrabSetDelayRadius = _G._AmbitiousSemiStealPending.autoGrabSetDelayRadius
    A.autoGrabStopEnabled    = true
  end
  if selectedStealMode == "Normal" then
    _G.AmbitiousStealRadii.Normal = _G.AmbitiousStealRadii.Normal or autoStealRadius or 62
    autoStealRadius = _G.AmbitiousStealRadii.Normal
  else
    _G.AmbitiousStealRadii.Semi = _G.AmbitiousStealRadii.Semi or autoStealRadius or 60
    autoStealRadius = _G.AmbitiousStealRadii.Semi
  end
  -- Bat Aimbot: single Normal toggle, using VX7 visible tuning.
  selectedAimbotMode = "V1"
  AIMBOT_SPEED = tonumber(data.AIMBOT_SPEED) or AIMBOT_SPEED
  LAGGER_AIMBOT_SPEED = tonumber(data.LAGGER_AIMBOT_SPEED) or LAGGER_AIMBOT_SPEED
  local _v2Spd = data.BAT_AIMBOT_V2_SPEED or data.ANTI_BYPASS_AIMBOT_SPEED
  local _v2Lag = data.BAT_AIMBOT_V2_LAGGER_SPEED or data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED
  _G.AmbitiousBatAimbotV2Speed = tonumber(_v2Spd) or _G.AmbitiousBatAimbotV2Speed or 86
  if _v2Lag == nil or tonumber(_v2Lag) == 58 then
    _G.AmbitiousBatAimbotV2LaggerSpeed = 40
  else
    _G.AmbitiousBatAimbotV2LaggerSpeed = tonumber(_v2Lag) or 55
  end
  mirrorTPDownEnabled = data.mirrorTPDownEnabled == true
  _G.AmbitiousNormalAimbotOn = data.normalAimbotEnabled == true
  -- V2 non viene usato dalla UI attuale: il toggle unico Ã¨ Normal.
  _G.AmbitiousBatAimbotV2On = false
  _G.AmbitiousBatTPOn = data.batTpEnabled == true
  -- TP Bat usa una sola implementazione: quella della Clean source.
  _G.AmbitiousBatTPVersion = "CLEAN"
  -- >>> AIMBOT CHASE MODE BEGIN
  _G._AmbitiousAimbotChase = _G._AmbitiousAimbotChase or { V1 = "NORMAL" }
  _G._AmbitiousAimbotChase.V1 = _G._AmbitiousAimbotChase.V1 or "NORMAL"
  _G._AmbitiousAimbotChase.V1 = "NORMAL"
  _G._AmbitiousAimbotChase.V2 = "NORMAL"
  -- <<< AIMBOT CHASE MODE END
  -- (stesso pattern di _AmbitiousSemiStealPending) che il do-block consuma all'avvio.
  batCounterEnabled = data.batCounterEnabled == true
  if data.batCounterMode == "V2" then batCounterMode = "V2" else batCounterMode = "V1" end
  medCounterEnabled = data.medCounterEnabled == true

  _G.AmbitiousAntiBatEnabled          = data.antiBatEnabled == true   -- >>> ANTI BAT <<<

  antiKickEnabled = data.safeMode == true
  espEnabled = data.espEnabled == true
  _G.AmbitiousESPOn = espEnabled   -- >>> ANTI VOID <<<
  showTrackerEnabled = data.showTrackerEnabled == true
  ragdollCountdownEnabled = data.ragdollCountdownEnabled == true
  fpsBoostEnabled = data.fpsBoostEnabled == true
  antiLagVisualEnabled = data.antiLagVisualEnabled ~= false
  vividGraphicsEnabled = data.vividGraphicsEnabled == true
  if data.vividSaturation then _G._AmbitiousVivid.saturation = math.clamp(tonumber(data.vividSaturation) or 0.6, 0, 2) end
  if data.vividBloomIntensity then _G._AmbitiousVivid.bloomIntensity = math.clamp(tonumber(data.vividBloomIntensity) or 0.8, 0, 3) end
  if data.vividBloomSize then _G._AmbitiousVivid.bloomSize = math.clamp(tonumber(data.vividBloomSize) or 24, 1, 56) end
  if data.vividDofFocus then _G._AmbitiousVivid.dofFocus = math.clamp(tonumber(data.vividDofFocus) or 25, 1, 100) end
  if data.vividSunIntensity then _G._AmbitiousVivid.sunIntensity = math.clamp(tonumber(data.vividSunIntensity) or 0.2, 0, 1) end
  xrayEnabled = data.xrayEnabled == true
  _G.AmbitiousBrainrotXRayEnabled = data.brainrotXRayEnabled == true   -- >>> BRAINROT X-RAY <<<
  highPingWarningEnabled = data.highPingWarningEnabled == true
  _G._AmbitiousKickWarn.enabled = data.kickWarningEnabled == true
  _G.AmbitiousUAKEnabled = data.ultimateAntiKick == true
  fovEnabled = data.fovEnabled == true
  fovValue = tonumber(data.fovValue) or fovValue
  noCamCollisionEnabled = data.noCamCollisionEnabled == true
  motionBlurEnabled = data.motionBlurEnabled == true
  _G.AmbitiousNoPlayerCollisionEnabled = data.noPlayerCollisionEnabled == true
  unwalkEnabled = data.unwalkEnabled == true
  skyTheme = (type(data.skyTheme) == "string" and data.skyTheme) or skyTheme
  -- Migrazione: vecchio preset "Tech" rinominato in "Cyber"
  if skyTheme == "Tech" then skyTheme = "Cyber" end
    -- Stretch Rez state
  do
      local savedIdx = data.stretchCurrentIndex and math.max(1, math.min(data.stretchCurrentIndex, #stretchPresetOrder)) or 1
      local savedOn  = data.stretchEnabled == true
      -- >>> STRETCH REZ <<< il valore scelto nella tendina: X1 non e' una
      -- scelta possibile, quindi si ricade su X1.5.
      _G.AmbitiousStretchPick = (savedIdx > 1) and savedIdx or 2
      -- Ripristina l'indice e lo stato (X1 = off, qualsiasi altro = on)
      if savedOn and savedIdx ~= 1 then
          applyStretchPreset(savedIdx)
      else
          stretchCurrentIndex = savedIdx
          stretchEnabled = false
      end
  end
  autoLeftEnabled = false
  autoRightEnabled = false
  -- >>> AUTO PLAY <<< si mette da parte quello che era stato salvato; a
  -- decidere se vale ancora (posto giusto, stesso server) ci pensa
  -- restore(), che e' dove sta tutta la regola.
  _G._AmbAutoPlaySavedJob  = (type(data.autoPlayJob) == "string" and data.autoPlayJob ~= "") and data.autoPlayJob or nil
  _G._AmbAutoPlaySavedSide = (data.autoPlaySide == "L" or data.autoPlaySide == "R") and data.autoPlaySide or nil
  if _G.AmbitiousAutoPlay and _G.AmbitiousAutoPlay.restore then
    pcall(_G.AmbitiousAutoPlay.restore)
  end
  headlessEnabled = data.headlessEnabled == true
  korbloxEnabled = data.korbloxEnabled == true

  _G.AmbitiousAntiVoidEnabled         = data.antiVoidEnabled == true   -- >>> ANTI VOID <<<
    _G.AmbitiousTransparentToolsEnabled = data.transparentToolsEnabled == true
  _G.AmbitiousCustomSoundsEnabled     = data.customSoundsEnabled == true
  selectedAnimPackIndex = math.clamp(tonumber(data.selectedAnimPackIndex) or 1, 1, 7)
  _animPackSavedIndex = math.clamp(tonumber(data.animPackSavedIndex) or 1, 1, 7)
  -- >>> CUSTOM ANIM PACK BEGIN
  if type(data.customAnimIds) == "table" then
    for _, slot in ipairs(_G.AmbitiousCustomAnimSlots) do
      local v = data.customAnimIds[slot]
      -- Solo cifre: qualsiasi altra cosa e' spazzatura e va scartata.
      _G.AmbitiousCustomAnimIds[slot] =
        (type(v) == "string" and v:match("^%d+$")) and v or ""
    end
  end
  -- <<< CUSTOM ANIM PACK END
  if data.introEnabled ~= nil then _introEnabled = data.introEnabled == true end
  if autoLeftEnabled and autoRightEnabled then autoRightEnabled = false end
  BoxedESPOptions = BoxedESPOptions or {}
  BoxedESPOptions.trackerColor = Color3.fromRGB(255, 220, 70)
end

loadAmbitiousConfig()


_G.AmbitiousCounterState = _G.AmbitiousCounterState or {}
_G.AmbitiousCounterState.batConn = nil
_G.AmbitiousCounterState.batDebounce = false
_G.AmbitiousCounterState.medConns = _G.AmbitiousCounterState.medConns or {}
_G.AmbitiousCounterState.medDebounce = false
_G.AmbitiousCounterState.medLastUsed = _G.AmbitiousCounterState.medLastUsed or 0
_G.AmbitiousMedusaCooldown = 25

function _G.AmbitiousFindMedusa()
  local c = LP.Character
  if not c then return nil end
  for _, t in ipairs(c:GetChildren()) do
    if t:IsA("Tool") then
      local n = t.Name:lower()
      if n:find("medusa") or n:find("head") or n:find("stone") then return t end
    end
  end
  local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
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

function _G.AmbitiousUseMedusaCounter()
  if not medCounterEnabled then return end
  if _G.AmbitiousCounterState.medDebounce then return end
  if tick() - (_G.AmbitiousCounterState.medLastUsed or 0) < _G.AmbitiousMedusaCooldown then return end
  local c = LP.Character
  if not c then return end
  _G.AmbitiousCounterState.medDebounce = true
  local med = _G.AmbitiousFindMedusa()
  if not med then
    _G.AmbitiousCounterState.medDebounce = false
    return
  end
  if med.Parent ~= c then
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum:EquipTool(med) end) end
    task.wait(0.05)
  end
  pcall(function() med:Activate() end)
  _G.AmbitiousCounterState.medLastUsed = tick()
  _G.AmbitiousCounterState.medDebounce = false
end

function _G.AmbitiousOnMedusaAnchorChanged(part)
  return part:GetPropertyChangedSignal("Anchored"):Connect(function()
    if part.Anchored and part.Transparency == 1 then
      if medCounterEnabled then
        _G.AmbitiousUseMedusaCounter()
      end
    end
  end)
end

function _G.AmbitiousStartMedCounter(char)
  _G.AmbitiousStopMedCounter()
  char = char or LP.Character
  if not char then return end
  for _, part in ipairs(char:GetDescendants()) do
    if part:IsA("BasePart") then
      table.insert(_G.AmbitiousCounterState.medConns, _G.AmbitiousOnMedusaAnchorChanged(part))
    end
  end
  table.insert(_G.AmbitiousCounterState.medConns, char.DescendantAdded:Connect(function(part)
    if part:IsA("BasePart") then
      table.insert(_G.AmbitiousCounterState.medConns, _G.AmbitiousOnMedusaAnchorChanged(part))
    end
  end))
end

function _G.AmbitiousStopMedCounter()
  for _, c in pairs(_G.AmbitiousCounterState.medConns or {}) do
    pcall(function() c:Disconnect() end)
  end
  _G.AmbitiousCounterState.medConns = {}
  _G.AmbitiousCounterState.medDebounce = false
end

-- true SOLO durante la finestra di counter del Bat Counter V2:
_G.AmbitiousBatCounterV2On = false

_G.AmbitiousBatCounterSlapList = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}

function _G.AmbitiousFindBatForCounter()
  local c = LP.Character
  if not c then return nil end
  local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
  for _, name in ipairs(_G.AmbitiousBatCounterSlapList) do
    local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
    if t then return t end
  end
  for _, ch in ipairs(c:GetChildren()) do
    if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
  end
  if bp then
    for _, ch in ipairs(bp:GetChildren()) do
      if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
  end
  return nil
end

function _G.AmbitiousSwingBatForCounter(bat, char)
  if not bat or not char then return end
  local hum = char:FindFirstChildOfClass("Humanoid")
  if bat.Parent ~= char then
    if hum then pcall(function() hum:EquipTool(bat) end) end
    task.wait(0.05)
  end
  local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
  if remote and remote:IsA("RemoteEvent") then
    pcall(function() remote:FireServer() end)
    task.wait(0.15)
    pcall(function() remote:FireServer() end)
  else
    pcall(function() bat:Activate() end)
    task.wait(0.15)
    pcall(function() bat:Activate() end)
  end
end

function _G.AmbitiousCounterIsRagdoll(hum)
  if not hum then return false end
  local st = hum:GetState()
  return st == Enum.HumanoidStateType.Physics
    or st == Enum.HumanoidStateType.Ragdoll
    or st == Enum.HumanoidStateType.FallingDown
    or hum.PlatformStand == true
end

-- Versione usata dal bat counter: esclude FallingDown (piccoli bump non devono triggerare)
function _G.AmbitiousCounterIsRagdollForBat(hum)
  if not hum then return false end
  local st = hum:GetState()
  return st == Enum.HumanoidStateType.Physics
    or st == Enum.HumanoidStateType.Ragdoll
    or hum.PlatformStand == true
end

-- ============================================================
-- BAT COUNTER V2: LOCK RAGDOLL NEMICO
-- Watcher identico a quello del Ragdoll Countdown nemico
-- (DescendantAdded -> BallSocketConstraint), ma indipendente:
-- funziona anche col Ragdoll Countdown spento.
-- Quando il nemico viene ragdollato parte un lock di 2.6s.
-- Se durante quei 2.6s veniamo ragdollati, il Bat Counter V2
-- IGNORA l'evento e non parte (nessuna attesa, si salta e basta).
-- Il lock e' a TEMPO, non sullo stato: se il watcher non vede nulla
-- il counter parte normalmente.
-- ============================================================
_G.AmbitiousBatCounterRagdollSeconds = _G.AmbitiousBatCounterRagdollSeconds or 2.6
_G.AmbitiousBatCounterEnemyLock = _G.AmbitiousBatCounterEnemyLock or {}
_G.AmbitiousBatCounterWatchConns = _G.AmbitiousBatCounterWatchConns or {}

function _G.AmbitiousBCMarkEnemyRagdoll(plr)
  if not plr or plr == LP then return end
  local secs = tonumber(_G.AmbitiousBatCounterRagdollSeconds) or 2.6
  _G.AmbitiousBatCounterEnemyLock[plr] = tick() + secs
end

function _G.AmbitiousStopBatCounterWatcher()
  local conns = _G.AmbitiousBatCounterWatchConns
  for k, c in pairs(conns) do
    pcall(function() c:Disconnect() end)
    conns[k] = nil
  end
  for k in pairs(_G.AmbitiousBatCounterEnemyLock) do
    _G.AmbitiousBatCounterEnemyLock[k] = nil
  end
end

function _G.AmbitiousStartBatCounterWatcher()
  _G.AmbitiousStopBatCounterWatcher()
  local conns = _G.AmbitiousBatCounterWatchConns

  local function hookChar(plr, char)
    if not char then return end
    local key = tostring(plr.UserId) .. "_char"
    if conns[key] then pcall(function() conns[key]:Disconnect() end) end
    conns[key] = char.DescendantAdded:Connect(function(d)
      if d:IsA("BallSocketConstraint") then
        _G.AmbitiousBCMarkEnemyRagdoll(plr)
      end
    end)
  end

  local function watchPlayer(plr)
    if plr == LP then return end
    local key = tostring(plr.UserId) .. "_added"
    if conns[key] then pcall(function() conns[key]:Disconnect() end) end
    conns[key] = plr.CharacterAdded:Connect(function(char)
      hookChar(plr, char)
    end)
    if plr.Character then hookChar(plr, plr.Character) end
  end

  conns["_playerAdded"] = Players.PlayerAdded:Connect(watchPlayer)
  conns["_playerRemoving"] = Players.PlayerRemoving:Connect(function(plr)
    _G.AmbitiousBatCounterEnemyLock[plr] = nil
    local ka = tostring(plr.UserId) .. "_added"
    local kc = tostring(plr.UserId) .. "_char"
    if conns[ka] then pcall(function() conns[ka]:Disconnect() end) conns[ka] = nil end
    if conns[kc] then pcall(function() conns[kc]:Disconnect() end) conns[kc] = nil end
  end)

  for _, plr in ipairs(Players:GetPlayers()) do
    watchPlayer(plr)
  end
end

-- Giocatore piu' vicino a noi (vivo), senza limiti di distanza
function _G.AmbitiousGetNearestEnemy()
  local char = LP.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  if not hrp then return nil end
  local myPos = hrp.Position
  local best, bestDist = nil, math.huge
  for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LP then
      local ec = plr.Character
      local ehrp = ec and ec:FindFirstChild("HumanoidRootPart")
      local ehum = ec and ec:FindFirstChildOfClass("Humanoid")
      if ehrp and ehum and ehum.Health > 0 then
        local d = (ehrp.Position - myPos).Magnitude
        if d < bestDist then
          bestDist = d
          best = plr
        end
      end
    end
  end
  return best
end

-- true se il nemico piu' vicino e' stato ragdollato da meno di 2.6s
function _G.AmbitiousIsNearestEnemyRagdolled()
  local plr = _G.AmbitiousGetNearestEnemy()
  if not plr then return false end
  local lockUntil = _G.AmbitiousBatCounterEnemyLock[plr]
  return lockUntil ~= nil and lockUntil > tick()
end

function _G.AmbitiousStartBatCounter()
  if _G.AmbitiousCounterState.batConn then return end
  _G.AmbitiousCounterState.batDebounce = false
  if _G.AmbitiousStartBatCounterWatcher then pcall(_G.AmbitiousStartBatCounterWatcher) end
  _G.AmbitiousCounterState.batConn = RunService.Heartbeat:Connect(function()
    if not batCounterEnabled then return end
    if _G.AmbitiousCounterState.batDebounce then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    -- Morto, o Instant Reset in corso: il ragdoll che si vede in questi due
    -- casi non e' un colpo preso, e' il nostro stesso reset (o la morte).
    -- Di regola il counter risponde a un hit, quindi qui non deve partire.
    -- Vale per V1 e V2: passano tutte e due da questo punto.
    if hum.Health <= 0 then return end
    if _G._AmbitiousInstantResetBusy then return end
    if _G.AmbitiousCounterIsRagdollForBat(hum) then
      _G.AmbitiousCounterState.batDebounce = true
      -- ANTI DIE QUI, non dentro il task.spawn piu' sotto. Li' arrivava
      -- 0.05s dopo, e questo ramo parte proprio perche' sei GIA' a terra
      -- ragdollato: 0.05s in quella situazione sono un'eternita'. Ora la
      -- protezione sale nello stesso frame in cui il ragdoll viene visto,
      -- prima di qualunque attesa, teletrasporto o swing.
      if _G.AmbitiousAntiDieArmNow then pcall(_G.AmbitiousAntiDieArmNow) end
      if batCounterMode == "V2" then
        -- Se il nemico e' dentro il lock di 2.6s il counter NON parte e questo
        -- hit viene SALTATO del tutto (niente attesa, niente ricontrollo):
        -- il debounce si riapre solo quando usciamo dal nostro ragdoll,
        -- cosi' e' pronto per la volta successiva.
        if _G.AmbitiousIsNearestEnemyRagdolled then
          local okRag, enemyRag = pcall(_G.AmbitiousIsNearestEnemyRagdolled)
          if okRag and enemyRag then
            task.spawn(function()
              local t0 = tick()
              while tick() - t0 < 10 do
                local c2 = LP.Character
                local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
                if not h2 or not _G.AmbitiousCounterIsRagdollForBat(h2) then break end
                task.wait(0.1)
              end
              task.wait(0.2)
              _G.AmbitiousCounterState.batDebounce = false
            end)
            return
          end
        end
        -- V2: salva CFrame, esegue lo snap del counter, poi ritorna
        task.spawn(function()
          task.wait(0.05)
          local hrpNow = char and char:FindFirstChild("HumanoidRootPart")
          local savedCF = hrpNow and hrpNow.CFrame or nil
          _G.AmbitiousBatCounterV2On = true
          if _G.AmbitiousAntiDieAutoSync then _G.AmbitiousAntiDieAutoSync() end
          local bat = _G.AmbitiousFindBatForCounter()
          if bat then task.spawn(function() _G.AmbitiousSwingBatForCounter(bat, char) end) end

          -- SNAP PROPRIO DEL COUNTER.
          -- Puo' partire indipendentemente dal resto della GUI.
          -- nemico va a terra: in tutti quei casi lo snap non avveniva.
          -- Qui teletrasportiamo noi, ogni frame, senza nessuna soglia di
          -- distanza, esattamente come la fase 2 del Bat Aimbot V2.
          local snapConn
          snapConn = RunService.Heartbeat:Connect(function()
            local c2 = LP.Character
            local h2 = c2 and c2:FindFirstChild("HumanoidRootPart")
            local hum2 = c2 and c2:FindFirstChildOfClass("Humanoid")
            if not h2 or not hum2 or hum2.Health <= 0 then return end
            local t2 = _G.AmbitiousGetNearestEnemy and _G.AmbitiousGetNearestEnemy() or nil
            local tc2 = t2 and t2.Character
            local tr2 = tc2 and tc2:FindFirstChild("HumanoidRootPart")
            if not tr2 then return end
            -- >>> ANTI VOID BEGIN
            -- Se il nemico si e' tpato nel void si va sul punto d'origine,
            -- altrimenti lo snap ci porterebbe fuori mappa dietro di lui.
            local _bcPos = tr2.Position
            if _G.AmbitiousAntiVoid then
              _bcPos = _G.AmbitiousAntiVoid.posForPart(tr2, _bcPos)
            end
            -- <<< ANTI VOID END
            pcall(function()
              h2.CFrame = CFrame.new(_bcPos + Vector3.new(0, 0.9, 0))
              h2.AssemblyLinearVelocity = Vector3.zero
              h2.AssemblyAngularVelocity = Vector3.zero
            end)
          end)

          task.wait(0.4)
          if snapConn then pcall(function() snapConn:Disconnect() end) snapConn = nil end
          _G.AmbitiousBatCounterV2On = false
          if _G.AmbitiousAntiDieAutoSync then _G.AmbitiousAntiDieAutoSync() end
          if savedCF then
            local hrpBack = char and char:FindFirstChild("HumanoidRootPart")
            if hrpBack then
              pcall(function()
                hrpBack.CFrame = savedCF
                hrpBack.AssemblyLinearVelocity = Vector3.zero
              end)
            end
          end
          task.wait(0.5)
          _G.AmbitiousCounterState.batDebounce = false
        end)
      else
        -- V1: look at + bat partono insieme, dopo 0.7s si ripristina look at
        task.spawn(function()
          local wasLookAtEnabled = _G.AmbitiousLookAtEnabled
          local savedRadius = _G.AmbitiousLookAtRadius
          _G.AmbitiousLookAtRadius = math.huge
          -- look at e bat partono insieme
          if _G.AmbitiousStartLookAt then pcall(_G.AmbitiousStartLookAt) end
          local bat = _G.AmbitiousFindBatForCounter()
          if bat then task.spawn(function() _G.AmbitiousSwingBatForCounter(bat, char) end) end
          task.wait(0.7)
          _G.AmbitiousLookAtRadius = savedRadius
          if wasLookAtEnabled then
            if _G.AmbitiousStartLookAt then pcall(_G.AmbitiousStartLookAt) end
          else
            if _G.AmbitiousStopLookAt then pcall(_G.AmbitiousStopLookAt) end
          end
          task.wait(0.5)
          _G.AmbitiousCounterState.batDebounce = false
        end)
      end
    end
  end)
end

function _G.AmbitiousStopBatCounter()
  if _G.AmbitiousCounterState.batConn then
    _G.AmbitiousCounterState.batConn:Disconnect()
    _G.AmbitiousCounterState.batConn = nil
  end
  _G.AmbitiousCounterState.batDebounce = false
  _G.AmbitiousBatCounterV2On = false
  if _G.AmbitiousStopBatCounterWatcher then pcall(_G.AmbitiousStopBatCounterWatcher) end
end

startBatCounter = _G.AmbitiousStartBatCounter
stopBatCounter = _G.AmbitiousStopBatCounter
setupMedusaCounter = _G.AmbitiousStartMedCounter
stopMedusaCounter = _G.AmbitiousStopMedCounter

-- ============================================================
-- NO PLAYER COLLISION v3 (event-driven)
-- Sostituisce il vecchio blocco a polling. Differenze:
--   1. ZERO loop. Ogni BasePart e' registrata una volta con
--      GetPropertyChangedSignal("CanCollide"): se qualcosa la riaccende
--      torna a false nello STESSO frame, non dopo 0.2s.
--   2. DescendantAdded sul character: accessori, tool equipaggiati e
--      arti che arrivano tardi al respawn vengono presi subito.
--   3. Copre anche l'assembly esterna (brainrot trasportato, hitbox
--      weldate ma parented in workspace), che prima era ignorata.
--   4. Spegne anche le TUE parti: sono le uniche di cui hai il network
--      ownership, quindi replicano davvero sul client dell'altro.
--      senza pestarsi i piedi (AmbitiousNoCollisionAcquire/Release).
-- Tutto dentro un do-end: non consuma slot locals nel main chunk.
-- ============================================================
_G.AmbitiousNoPlayerCollisionState = _G.AmbitiousNoPlayerCollisionState or {}

do
  local NPC = _G.AmbitiousNoPlayerCollisionState
  NPC.connections = NPC.connections or {}
  NPC.parts       = NPC.parts or {}       -- part -> {conn, destroy, cc, ct}
  NPC.charConns   = NPC.charConns or {}   -- character -> {conns}
  NPC.holders     = NPC.holders or {}     -- tag -> true
  NPC.running     = NPC.running or false

  -- Parti del corpo R6 + R15
  local BODY = {
    HumanoidRootPart = true, Head = true, Torso = true, UpperTorso = true, LowerTorso = true,
    ["Left Arm"] = true, ["Right Arm"] = true, ["Left Leg"] = true, ["Right Leg"] = true,
    LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
    RightUpperArm = true, RightLowerArm = true, RightHand = true,
    LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
    RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
  }

  local function isOn() return NPC.running == true end

  -- Rete di sicurezza per le scritture interne del motore che non emettono
  -- GetPropertyChangedSignal. Passa su tutti i giocatori, ma UNA VOLTA AL
  -- SECONDO, non ad ogni frame.
  -- Abbassalo a 0.25 se vedi ancora micro-spinte entrando nei nemici;
  -- mettilo a 0 per restare puramente event-driven.
  local SELF_VERIFY_INTERVAL = 1

  -- ---------- registro parti ----------
  local function lockPart(part, killTouch)
    if not part or not part:IsA("BasePart") then return end
    if NPC.parts[part] then return end

    local e = {cc = part.CanCollide, ct = part.CanTouch}
    NPC.parts[part] = e

    pcall(function() part.CanCollide = false end)
    if killTouch then pcall(function() part.CanTouch = false end) end

    -- Cuore del fix: reazione immediata, non ogni 0.2s.
    e.conn = part:GetPropertyChangedSignal("CanCollide"):Connect(function()
      if not isOn() then return end
      if part.CanCollide then pcall(function() part.CanCollide = false end) end
    end)

    e.destroy = part.AncestryChanged:Connect(function()
      if part:IsDescendantOf(game) then return end
      if e.conn then pcall(function() e.conn:Disconnect() end) end
      if e.destroy then pcall(function() e.destroy:Disconnect() end) end
      NPC.parts[part] = nil
    end)
  end

  local function unlockPart(part)
    local e = NPC.parts[part]
    if not e then return end
    if e.conn then pcall(function() e.conn:Disconnect() end) end
    if e.destroy then pcall(function() e.destroy:Disconnect() end) end
    NPC.parts[part] = nil
    if part and part.Parent then
      pcall(function() part.CanCollide = e.cc end)
      pcall(function() part.CanTouch = e.ct end)
    end
  end

  local hookHumanoid

  -- Riscrive CanCollide = false sulle parti gia' registrate di un character.
  -- Serve quando il motore le rimette a true senza emettere il segnale.
  local function reassert(char, isSelf)
    if not char or isSelf then return end -- non modificare mai le collisioni del proprio personaggio
    for _, obj in ipairs(char:GetDescendants()) do
      if obj:IsA("BasePart") and NPC.parts[obj] then
        if not (isSelf and obj.Name == "HumanoidRootPart") then
          if obj.CanCollide then pcall(function() obj.CanCollide = false end) end
        end
      end
    end
  end

  hookHumanoid = function(hum, char, isSelf)
    if not NPC.charConns[char] then NPC.charConns[char] = {} end
    table.insert(NPC.charConns[char], hum.StateChanged:Connect(function()
      if not isOn() then return end
      -- differita di un frame: l'Humanoid scrive dopo il cambio di stato
      task.defer(function()
        if isOn() and char.Parent then reassert(char, isSelf) end
      end)
    end))
    table.insert(NPC.charConns[char], hum:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
      if not isOn() then return end
      task.defer(function()
        if isOn() and char.Parent then reassert(char, isSelf) end
      end)
    end))
  end

  -- ---------- aggancio character ----------
  -- isSelf: sul tuo character l'HRP resta collidibile o l'Humanoid sprofonda.
  local function hookCharacter(char, isSelf)
    if not char then return end
    if NPC.charConns[char] then return end
    NPC.charConns[char] = {}

    local function handle(obj)
      if not isOn() then return end
      if not obj:IsA("BasePart") then return end
      -- Il toggle riguarda solo gli altri giocatori: non disattivare le
      -- collisioni del proprio character, altrimenti si possono attraversare i muri.
      if isSelf then return end
      lockPart(obj, true)
    end

    for _, obj in ipairs(char:GetDescendants()) do handle(obj) end
    table.insert(NPC.charConns[char], char.DescendantAdded:Connect(handle))

    -- Salto, caduta, atterraggio, ragdoll: l'Humanoid rimette mano alle
    -- collisioni. Qui le riportiamo giu' subito dopo, senza polling.
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
      local hc
      hc = char.ChildAdded:Connect(function(c)
        if c:IsA("Humanoid") then
          hc:Disconnect()
          hookHumanoid(c, char, isSelf)
        end
      end)
      table.insert(NPC.charConns[char], hc)
    else
      hookHumanoid(hum, char, isSelf)
    end
    table.insert(NPC.charConns[char], char.AncestryChanged:Connect(function(_, parent)
      if parent == nil then
        for _, c in ipairs(NPC.charConns[char] or {}) do pcall(function() c:Disconnect() end) end
        NPC.charConns[char] = nil
      end
    end))
  end

  -- ---------- assembly esterne (brainrot trasportato, hitbox) ----------
  local function ownedByOtherPlayer(part)
    local root = part.AssemblyRootPart
    if not root then return false end
    local model = root:FindFirstAncestorOfClass("Model")
    if not model then return false end
    local plr = Players:GetPlayerFromCharacter(model)
    return plr ~= nil and plr ~= LP
  end

  local function hookWorkspacePart(obj)
    if not isOn() then return end
    if not obj:IsA("BasePart") then return end
    if NPC.parts[obj] then return end
    -- il weld arriva un frame dopo il parenting
    task.defer(function()
      if not isOn() then return end
      if not obj.Parent then return end
      if ownedByOtherPlayer(obj) then lockPart(obj, true) end
    end)
  end

  -- ---------- start / stop interni ----------
  local function startCore()
    if NPC.running then return end
    NPC.running = true

    for _, c in ipairs(NPC.connections or {}) do pcall(function() c:Disconnect() end) end
    NPC.connections = {}
    local function track(c) table.insert(NPC.connections, c) end

    local function watchPlayer(plr)
      if plr == LP then return end
      if plr.Character then hookCharacter(plr.Character, false) end
      track(plr.CharacterAdded:Connect(function(char)
        if isOn() then hookCharacter(char, false) end
      end))
    end
    for _, plr in ipairs(Players:GetPlayers()) do watchPlayer(plr) end
    track(Players.PlayerAdded:Connect(watchPlayer))

    if LP.Character then hookCharacter(LP.Character, true) end
    track(LP.CharacterAdded:Connect(function(char)
      if isOn() then hookCharacter(char, true) end
    end))

    for _, obj in ipairs(Workspace:GetChildren()) do hookWorkspacePart(obj) end
    track(Workspace.DescendantAdded:Connect(hookWorkspacePart))

    if SELF_VERIFY_INTERVAL > 0 then
      local acc = 0
      track(RunService.Heartbeat:Connect(function(dt)
        if not isOn() then return end
        acc = acc + (dt or 0)
        if acc < SELF_VERIFY_INTERVAL then return end
        acc = 0
        for _, plr in ipairs(Players:GetPlayers()) do
          local char = plr.Character
          if char then
            local isSelf = (plr == LP)
            reassert(char, isSelf)
            -- parti mai registrate (comparse in una finestra scoperta)
            for _, obj in ipairs(char:GetDescendants()) do
              if obj:IsA("BasePart") and not NPC.parts[obj] then
                if not (isSelf and obj.Name == "HumanoidRootPart") then
                  lockPart(obj, not isSelf)
                end
              end
            end
          end
        end
      end))
    end
  end

  local function stopCore()
    if not NPC.running then return end
    NPC.running = false

    for _, c in ipairs(NPC.connections or {}) do pcall(function() c:Disconnect() end) end
    NPC.connections = {}

    for char, conns in pairs(NPC.charConns) do
      for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
      NPC.charConns[char] = nil
    end

    for part in pairs(NPC.parts) do unlockPart(part) end
    NPC.parts = {}
  end

  -- Ripassata completa: riaggancia character e parti gia' presenti.
  -- Serve dopo un cambio di holder, per non restare in attesa del
  -- prossimo DescendantAdded.
  local function rescan()
    if not isOn() then return end
    for _, plr in ipairs(Players:GetPlayers()) do
      local char = plr.Character
      if char then
        if plr ~= LP then
          for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then lockPart(obj, true) end
          end
          hookCharacter(char, false)
        end
      end
    end
  end

  -- ---------- API ref-count ----------
  function _G.AmbitiousNoCollisionAcquire(tag)
    NPC.holders[tag or "default"] = true
    startCore()
  end

  function _G.AmbitiousNoCollisionRelease(tag)
    NPC.holders[tag or "default"] = nil
    -- Il toggle utente vince sempre: finche' e' acceso non si spegne nulla,
    -- anche se il tag "user" si fosse perso per strada.
    if _G.AmbitiousNoPlayerCollisionEnabled == true then
      NPC.holders["user"] = true
      rescan()
      return
    end
    if next(NPC.holders) == nil then stopCore() end
  end
end

-- Toggle utente (chiamato dalla UI e da applyAmbitiousConfig)
function enableNoPlayerCollision()
  _G.AmbitiousNoPlayerCollisionEnabled = true
  _G.AmbitiousNoCollisionAcquire("user")
end

function disableNoPlayerCollision()
  _G.AmbitiousNoPlayerCollisionEnabled = false
  _G.AmbitiousNoCollisionRelease("user")
end

-- Compatibilita' con il vecchio nome usato altrove nello script
function _G.AmbitiousSetOtherPlayerCollision(state)
  if state == false then
    _G.AmbitiousNoCollisionAcquire("legacy")
  else
    _G.AmbitiousNoCollisionRelease("legacy")
  end
end

-- ===== UNWALK (logica da uranium.lua) =====
-- startUnwalk/stopUnwalk dichiarate outer: servono dopo il do-block (toggle UI, apply-config)
-- Le helper interne stanno nel do-block: i loro registri vengono liberati subito,
-- evitando il "out of local limits" al main chunk.
local startUnwalk, stopUnwalk
do
  local unwalkLoopConnection = nil

  local function killAllAnimations(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
      for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop() end)
      end
    end
    local animate = char:FindFirstChild("Animate")
    if animate and animate:IsA("LocalScript") then animate.Disabled = true end
    if hum and hum:GetState() ~= Enum.HumanoidStateType.Running then
      pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
  end

  local function restoreAnimations(char)
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if animate and animate:IsA("LocalScript") then
      animate.Disabled = false
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
      task.wait()
      pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
  end

  local function startUnwalkLoop()
    if unwalkLoopConnection then return end
    unwalkLoopConnection = RunService.Heartbeat:Connect(function()
      if not unwalkEnabled then return end
      local char = LP.Character
      if not char then return end
      local hum = char:FindFirstChildOfClass("Humanoid")
      if not hum then return end
      local hasAnim = false
      local animator = hum:FindFirstChildOfClass("Animator")
      if animator then
        local tracks = animator:GetPlayingAnimationTracks()
        if #tracks > 0 then
          hasAnim = true
          for _, t in pairs(tracks) do pcall(function() t:Stop() end) end
        end
      end
      local animate = char:FindFirstChild("Animate")
      if animate and animate:IsA("LocalScript") and not animate.Disabled then
        animate.Disabled = true
        hasAnim = true
      end
      if hasAnim then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end) end
    end)
  end

  local function stopUnwalkLoop()
    if unwalkLoopConnection then
      unwalkLoopConnection:Disconnect()
      unwalkLoopConnection = nil
    end
    local char = LP.Character
    if char then restoreAnimations(char) end
  end

  startUnwalk = function()
    if unwalkEnabled then return end
    unwalkEnabled = true
    local char = LP.Character
    if char then killAllAnimations(char) end
    startUnwalkLoop()
  end

  stopUnwalk = function()
    if not unwalkEnabled then return end
    unwalkEnabled = false
    stopUnwalkLoop()
    local char = LP.Character
    if char then restoreAnimations(char) end
  end

  LP.CharacterAdded:Connect(function(char)
    _G._AmbitiousWaitCharReady(char, 10)
    -- Animate arriva dopo Head/HRP/Humanoid: senza questa attesa
    -- lo script non verrebbe disabilitato e le animazioni resterebbero.
    pcall(function() char:WaitForChild("Animate", 3) end)
    if unwalkEnabled then
      killAllAnimations(char)
    else
      restoreAnimations(char)
    end
  end)
end
-- ===== FINE UNWALK =====

-- ===== ANIMATION PACKS =====
do
  local ANIM_PACKS = {
    -- NONE (index 1): nessun pack, usa animazioni default
    [1] = nil,
    -- Pack 1
    [2] = {
      idle = "rbxassetid://619542203",
      walk = "rbxassetid://619544080",
      run  = "rbxassetid://619543231",
      jump = "rbxassetid://619542888",
      fall = "rbxassetid://619541867",
    },
    -- Pack 2
    [3] = {
      idle = "rbxassetid://754637456",
      walk = "rbxassetid://754636298",
      run  = "rbxassetid://754635032",
      jump = "rbxassetid://754637084",
      fall = "rbxassetid://754636589",
    },
    -- Pack 3
    [4] = {
      idle = "rbxassetid://1113742618",
      walk = "rbxassetid://1113741192",
      run  = "rbxassetid://1113740510",
      jump = "rbxassetid://1113742359",
      fall = "rbxassetid://1113742092",
    },
    -- Pack 4
    [5] = {
      idle = "rbxassetid://126354114956642",
      walk = "rbxassetid://106810508343012",
      run  = "rbxassetid://124765145869332",
      jump = "rbxassetid://115715495289805",
      fall = "rbxassetid://93993406355955",
    },
    -- Pack 5
    [6] = {
      idle = "rbxassetid://619535834",
      walk = "rbxassetid://619537468",
      run  = "rbxassetid://619536621",
      jump = "rbxassetid://619536283",
      fall = "rbxassetid://619535616",
    },
  }


  local function _animLoadTrack(animator, id)
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

  -- >>> CUSTOM ANIM PACK BEGIN
  -- Le connessioni agli eventi dell'Humanoid non venivano MAI chiuse.
  -- Ogni ricarica del sistema (cambio pack, o cambio di un asset custom)
  -- ne aggiungeva un altro set sopra ai precedenti: i vecchi restavano
  -- vivi e continuavano a comandare Play/Stop sulle tracce, quindi la
  -- nuova animazione non prendeva il controllo finche' non respawnavi,
  -- perche' solo allora l'Humanoid vecchio moriva insieme alle connessioni.
  -- Ora si tengono in una lista e si chiudono a ogni stop.
  _G._AmbitiousAnimPackConns = _G._AmbitiousAnimPackConns or {}
  -- <<< CUSTOM ANIM PACK END

  local function _animStopAll()
    for _, track in pairs(_animPackTracks) do
      pcall(function() track:Stop(0) end)
    end
    _animPackTracks = {}
    -- >>> CUSTOM ANIM PACK BEGIN
    for _, c in ipairs(_G._AmbitiousAnimPackConns) do
      pcall(function() c:Disconnect() end)
    end
    _G._AmbitiousAnimPackConns = {}
    -- <<< CUSTOM ANIM PACK END
  end

  -- >>> CUSTOM ANIM PACK BEGIN
  -- L'indice 7 non ha una tabella fissa: si costruisce al volo dagli ID
  -- che l'utente ha inserito, e contiene SOLO gli slot valorizzati. Per
  -- gli altri movimenti resta l'animazione del gioco, esattamente come
  -- fa Uranium: non si forza niente su uno slot vuoto.
  local function _animCustomPack()
    local t, any = {}, false
    for _, slot in ipairs(_G.AmbitiousCustomAnimSlots) do
      local id = _G.AmbitiousCustomAnimIds[slot]
      if id and id ~= "" then
        t[slot] = "rbxassetid://" .. id
        any = true
      end
    end
    if not any then return nil end
    return t
  end
  -- <<< CUSTOM ANIM PACK END

  local function _animStartSystem(char)
    _animStopAll()
    if not _animPackSystemEnabled then return end
    -- >>> CUSTOM ANIM PACK BEGIN
    local pack
    if selectedAnimPackIndex == 7 then
      pack = _animCustomPack()
      -- Nessun ID impostato: si lascia il sistema nativo acceso invece di
      -- spegnere Animate e restare senza animazioni.
      if not pack then return end
    else
      pack = ANIM_PACKS[selectedAnimPackIndex]
    end
    if not pack then return end
    -- <<< CUSTOM ANIM PACK END

    local humanoid = char:WaitForChild("Humanoid")
    local animator = humanoid:WaitForChild("Animator")
    local Animate = char:FindFirstChild("Animate")

    -- >>> CUSTOM ANIM PACK BEGIN
    -- COPERTURA PARZIALE.
    -- Lo script Animate del gioco si accende o si spegne per TUTTO il
    -- personaggio: non esiste un modo di spegnerlo solo per l'idle. Finche'
    -- un pack copre tutti e cinque i movimenti la cosa non si nota, ma col
    -- pack CUSTOM puoi lasciare uno slot vuoto. Spegnendo Animate lo slot
    -- vuoto non aveva NIENTE da suonare, e la traccia custom precedente
    -- restava in loop: sembrava che l'asset venisse riapplicato di nascosto,
    -- mentre in realta' non era mai stato fermato.
    -- Se la copertura non e' completa, Animate resta ACCESO e le tracce
    -- custom girano sopra con priorita' Action, che vince su Idle e
    -- Movement del gioco. Dove non c'e' una traccia custom riemerge quella
    -- originale, che e' esattamente il comportamento voluto.
    local partial = false
    if selectedAnimPackIndex == 7 then
      for _, sl in ipairs({"idle", "walk", "run", "jump", "fall"}) do
        if not pack[sl] then partial = true break end
      end
    end

    if not partial then
      if Animate then Animate.Disabled = true end
    elseif Animate then
      Animate.Disabled = false
    end
    task.wait(0.1)
    if not partial then
      for _, t in pairs(animator:GetPlayingAnimationTracks()) do
        pcall(function() t:Stop(0) end)
      end
    end
    -- <<< CUSTOM ANIM PACK END

    for name, id in pairs(pack) do
      local track = _animLoadTrack(animator, id)
      track.Looped = (name == "idle" or name == "walk" or name == "run" or name == "fall")
      if partial then
        -- Sopra a tutto quello che suona il gioco.
        track.Priority = Enum.AnimationPriority.Action
      elseif name == "idle" then
        track.Priority = Enum.AnimationPriority.Idle
      elseif name == "walk" or name == "run" then
        track.Priority = Enum.AnimationPriority.Movement
      else
        track.Priority = Enum.AnimationPriority.Action
      end
      _animPackTracks[name] = track
    end

    local function playAnim(name, forceRestart)
      if not _animPackSystemEnabled then return end
      -- >>> CUSTOM ANIM PACK BEGIN
      if not _animPackTracks[name] then
        -- Slot senza asset: si FERMA la traccia custom in corso, altrimenti
        -- resta in loop e copre l'animazione del gioco. Prima si usciva e
        -- basta, ed e' per questo che togliendo l'idle continuavi a vedere
        -- l'animazione custom.
        local cur = _animPackTracks[_animPackCurrentAnim]
        if cur then pcall(function() cur:Stop(0.15) end) end
        _animPackCurrentAnim = name
        return
      end
      -- <<< CUSTOM ANIM PACK END
      if _animPackCurrentAnim == name and not forceRestart then return end
      if _animPackTracks[_animPackCurrentAnim] and _animPackCurrentAnim ~= name then
        pcall(function() _animPackTracks[_animPackCurrentAnim]:Stop(0.15) end)
      end
      _animPackCurrentAnim = name
      if forceRestart then _animPackTracks[name]:Stop() end
      _animPackTracks[name]:Play(0.15)
    end

    -- Hookiamo gli eventi PRIMA del play iniziale
    -- >>> CUSTOM ANIM PACK BEGIN: ogni connessione va registrata <<<
    local _conns = _G._AmbitiousAnimPackConns
    table.insert(_conns, humanoid.Running:Connect(function(speed)
      if not _animPackSystemEnabled then return end
      local state = humanoid:GetState()
      if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then return end
      if speed > 14 then playAnim("run")
      elseif speed > 0.5 then playAnim("walk")
      else playAnim("idle") end
    end))
    table.insert(_conns, humanoid.Jumping:Connect(function(active)
      if not _animPackSystemEnabled or not active then return end
      playAnim("jump", true)
    end))
    table.insert(_conns, humanoid.FreeFalling:Connect(function(active)
      if not _animPackSystemEnabled or not active then return end
      playAnim("fall")
    end))
    table.insert(_conns, humanoid.StateChanged:Connect(function(_, newState)
      if not _animPackSystemEnabled then return end
      if newState == Enum.HumanoidStateType.Landed then
        if humanoid.MoveDirection.Magnitude > 0 then
          if humanoid.WalkSpeed > 14 then playAnim("run") else playAnim("walk") end
        else playAnim("idle") end
      end
    end))

    -- Determina l'animazione iniziale in base allo stato attuale del personaggio
    -- invece di forzare sempre idle
    local currentState = humanoid:GetState()
    if currentState == Enum.HumanoidStateType.Jumping then
      _animPackCurrentAnim = "jump"
      if _animPackTracks.jump then _animPackTracks.jump:Play(0.15) end
    elseif currentState == Enum.HumanoidStateType.Freefall then
      _animPackCurrentAnim = "fall"
      if _animPackTracks.fall then _animPackTracks.fall:Play(0.15) end
    elseif humanoid.MoveDirection.Magnitude > 0.1 then
      if humanoid.WalkSpeed > 14 then
        _animPackCurrentAnim = "run"
        if _animPackTracks.run then _animPackTracks.run:Play(0.15) end
      else
        _animPackCurrentAnim = "walk"
        if _animPackTracks.walk then _animPackTracks.walk:Play(0.15) end
      end
    else
      _animPackCurrentAnim = "idle"
      if _animPackTracks.idle then _animPackTracks.idle:Play(0.15) end
    end
  end

  local function _animRestoreDefault()
    _animStopAll()
    local char = LP.Character
    if char then
      local Animate = char:FindFirstChild("Animate")
      if Animate then Animate.Disabled = false end
      local humanoid = char:FindFirstChild("Humanoid")
      if humanoid then
        local animator = humanoid:FindFirstChild("Animator")
        if animator then
          for _, t in pairs(animator:GetPlayingAnimationTracks()) do t:Stop(0) end
        end
      end
    end
  end

  -- Flag condiviso tra AmbitiousSetAnimPack e stopUnwalk override:
  -- alzato quando Ã¨ il pack stesso a chiamare stopUnwalk (non l'utente),
  -- cosÃ¬ stopUnwalk non fa il ripristino automatico in quel caso.
  local _packCallingStop = false

  -- Funzione pubblica: applica un pack per indice (1=NONE, 2-6=pack 1-5)
  _G.AmbitiousGetSelectedAnimPackIndex = function()
    return selectedAnimPackIndex or 1
  end

  _G.AmbitiousSetAnimPack = function(index)
    index = math.clamp(tonumber(index) or 1, 1, 7)   -- 7 = CUSTOM

    if index == 1 then
      -- L'utente ha cliccato NONE manualmente
      _animPackSystemEnabled = false
      _animRestoreDefault()
      selectedAnimPackIndex = 1

      if unwalkEnabled then
        -- Unwalk Ã¨ attivo: l'utente ha confermato NONE esplicitamente
        -- Azzera il pack salvato cosÃ¬ quando unwalk si spegne non ripristina niente
        _animPackSavedIndex = 1
        _animPackUnwalkWasActive = false
        -- Unwalk rimane ON, aggiornamento visivo giÃ  corretto (unwalk toggle Ã¨ giÃ  acceso)
      else
        -- Unwalk non Ã¨ attivo: torno a NONE normalmente
        -- Se c'era un flag unwalk pendente (unwalk era stato forzato OFF da un pack),
        -- lo riattivo perchÃ© l'utente Ã¨ tornato a NONE
        if _animPackUnwalkWasActive then
          _animPackUnwalkWasActive = false
          _animPackSavedIndex = 1
          startUnwalk()
          if _SV.setUnwalkVisual then _SV.setUnwalkVisual(true) end
        end
      end

    else
      -- L'utente ha selezionato pack 1-5
      if unwalkEnabled then
        _animPackSavedIndex = index
        _animPackUnwalkWasActive = true
        _packCallingStop = true
        stopUnwalk()
        if _SV.setUnwalkVisual then _SV.setUnwalkVisual(false) end
      end
      selectedAnimPackIndex = index
      _animPackSystemEnabled = true
      local char = LP.Character
      if char then
        task.spawn(function() _animStartSystem(char) end)
      end
    end

    if setAnimPackVisual then setAnimPackVisual(selectedAnimPackIndex) end
    -- >>> VISIBILE SOLO CON CUSTOM <<<
    if _G.AmbitiousCustomAnimSetRowVisible then
      _G.AmbitiousCustomAnimSetRowVisible(selectedAnimPackIndex == 7, true)
    end
    saveAmbitiousConfig()
  end

  -- Override di startUnwalk/stopUnwalk per gestire l'interazione col pack
  -- Si aggiunge alla logica esistente, non la sostituisce
  local _origStartUnwalk = startUnwalk
  local _origStopUnwalk  = stopUnwalk

  startUnwalk = function()
    -- Se c'Ã¨ un pack attivo, salvalo e torna a NONE prima di avviare unwalk
    if selectedAnimPackIndex ~= 1 then
      _animPackSavedIndex = selectedAnimPackIndex
      _animPackUnwalkWasActive = true
      _animPackSystemEnabled = false
      _animRestoreDefault()
      selectedAnimPackIndex = 1
      if setAnimPackVisual then setAnimPackVisual(1) end
    end
    _origStartUnwalk()
  end

  stopUnwalk = function()
    _origStopUnwalk()
    -- Se chiamato internamente dal pack, non fare niente
    if _packCallingStop then
      _packCallingStop = false
      return
    end
    -- Se c'era un pack salvato prima che unwalk lo coprisse, ripristinalo
    if _animPackSavedIndex ~= 1 then
      local idx = _animPackSavedIndex
      _animPackSavedIndex = 1
      _animPackUnwalkWasActive = false
      task.delay(0.25, function()
        if not unwalkEnabled and _G.AmbitiousSetAnimPack then
          _G.AmbitiousSetAnimPack(idx)
        end
      end)
    end
  end

  -- >>> CUSTOM ANIM PACK BEGIN
  -- Chiamata dal picker ogni volta che un ID viene aggiunto o tolto:
  -- se CUSTOM e' la selezione attiva il sistema va ricaricato subito,
  -- altrimenti la modifica si vedrebbe solo al respawn.
  function _G.AmbitiousReloadCustomAnimPack()
    if selectedAnimPackIndex ~= 7 then return end
    local char = LP.Character
    if not char then return end
    if _G.AmbitiousHasCustomAnim() then
      -- Si riparte da zero: _animStartSystem chiama _animStopAll, che ora
      -- chiude anche le connessioni, quindi il set nuovo e' l'unico attivo
      -- e l'asset appena inserito si applica subito, senza reset.
      _animPackSystemEnabled = true
      task.spawn(function() _animStartSystem(char) end)
    else
      _animPackSystemEnabled = false
      _animRestoreDefault()
    end
  end
  -- <<< CUSTOM ANIM PACK END

  -- Avvio automatico del pack quando il personaggio riappare
  LP.CharacterAdded:Connect(function(newChar)
    _G._AmbitiousWaitCharReady(newChar, 10)
    pcall(function() newChar:WaitForChild("Animate", 3) end)
    if _animPackSystemEnabled and selectedAnimPackIndex ~= 1 then
      task.spawn(function() _animStartSystem(newChar) end)
    end
  end)

  -- Avvio immediato se il personaggio Ã¨ giÃ  spawnato
  if LP.Character and _animPackSystemEnabled and selectedAnimPackIndex ~= 1 then
    task.spawn(function() _animStartSystem(LP.Character) end)
  end
end
-- ===== FINE ANIMATION PACKS =====


function _G.AmbitiousSafeModeGetCountdownLabel()
  local ok, label = pcall(function()
    return LP.PlayerGui
      and LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
      and LP.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
      and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
      and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
  end)
  return (ok and label) or nil
end

function _G.AmbitiousSafeModeCountdownNumber(text)
  local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
  if t == "GO" or t == "START" or t == "READY" then return true end
  local n = tonumber(t)
  return n ~= nil and n >= 0 and n <= 10
end

-- Il numero che il cartello sta mostrando, oppure nil se non e' un conto
-- alla rovescia. "GO"/"START" valgono 0: il conto e' finito.
function _G.AmbitiousSafeModeCountdownValue()
  local label = _G.AmbitiousSafeModeGetCountdownLabel()
  if not label then return nil end
  local t = tostring(label.Text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
  if t == "GO" or t == "START" or t == "READY" then return 0 end
  local n = tonumber(t)
  if n ~= nil and n >= 0 and n <= 10 then return n end
  return nil
end

function _G.AmbitiousSafeModeInDuelCountdown()
  local label = _G.AmbitiousSafeModeGetCountdownLabel()
  return label and _G.AmbitiousSafeModeCountdownNumber(label.Text) or false
end

_G.AmbitiousSafeModeBlockedTools = {
  bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true,
  medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true,
}

function _G.AmbitiousSafeModeIsCarryableTool(tool)
  if not tool or not tool:IsA("Tool") then return false end
  local name = tool.Name:lower()
  for word in pairs(_G.AmbitiousSafeModeBlockedTools) do
    if name:find(word, 1, true) then return false end
  end
  return true
end

function _G.AmbitiousSafeModeHoldingBrainrot()
  local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
  if ok and val == true then return true end
  local ok2, val2 = pcall(function() return LP:GetAttribute("AntiKick") end)
  if ok2 and val2 == true then return true end
  local char = LP.Character
  if not char then return false end
  local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
  if ok3 and val3 == true then return true end
  if _G.AutoCarrySpeed and type(_G.AutoCarrySpeed.IsCarryingBrainrot) == "function" then
    local okCarry, carrying = pcall(function() return _G.AutoCarrySpeed.IsCarryingBrainrot(char) end)
    if okCarry and carrying then return true end
  end
  for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
    local v = char:FindFirstChild(name, true)
    if v then
      if v:IsA("BoolValue") and v.Value then return true end
      if v:IsA("ObjectValue") and v.Value then return true end
      if v:IsA("StringValue") and v.Value ~= "" then return true end
    end
  end
  for _, child in ipairs(char:GetChildren()) do
    if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
      local n = child.Name:lower()
      if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
        return true
      end
    end
  end
  return false
end

function _G.AmbitiousSafeModeIsLocked()
  if not antiKickEnabled then return false end
  return _G.AmbitiousSafeModeInDuelCountdown() or _G.AmbitiousSafeModeHoldingBrainrot()
end

function _G.AmbitiousSafeModeForceStop(reason)
  local stopped = false
  if _G.AmbitiousNormalAimbotOn and _G.AmbitiousStopNormalAimbot then _G.AmbitiousStopNormalAimbot(); stopped = true end
  if _G.AmbitiousBatAimbotV2On and _G.AmbitiousStopBatAimbotV2 then _G.AmbitiousStopBatAimbotV2(false); stopped = true end
  if autoLeftEnabled then
    autoLeftEnabled = false
    if _G.AmbitiousSetAutoLeftVisual then _G.AmbitiousSetAutoLeftVisual(false) end
    if _G.AmbitiousStopAutoLeft then _G.AmbitiousStopAutoLeft() end
    stopped = true
  end
  if autoRightEnabled then
    autoRightEnabled = false
    if _G.AmbitiousSetAutoRightVisual then _G.AmbitiousSetAutoRightVisual(false) end
    if _G.AmbitiousStopAutoRight then _G.AmbitiousStopAutoRight() end
    stopped = true
  end
  if stopped and showActionNotification then pcall(function() showActionNotification(reason or "SAFE MODE LOCK") end) end
end

function _G.AmbitiousSafeModeTryStart()
  if _G.AmbitiousSafeModeIsLocked and _G.AmbitiousSafeModeIsLocked() then
    _G.AmbitiousSafeModeForceStop("SAFE MODE LOCK")
    return false
  end
  return true
end

_G.AmbitiousSafeModeMonitorStarted = _G.AmbitiousSafeModeMonitorStarted or false
if not _G.AmbitiousSafeModeMonitorStarted then
  _G.AmbitiousSafeModeMonitorStarted = true
  RunService.Heartbeat:Connect(function()
    if antiKickEnabled and _G.AmbitiousSafeModeIsLocked and _G.AmbitiousSafeModeIsLocked() then
      _G.AmbitiousSafeModeForceStop("SAFE MODE LOCK")
    end
  end)
end

LP.CharacterAdded:Connect(function(char)
  _G._AmbitiousWaitCharReady(char, 10)
  if medCounterEnabled then _G.AmbitiousStartMedCounter(char) end
  if batCounterEnabled then _G.AmbitiousStartBatCounter() end
end)

_G.AmbitiousNormalAimbot = _G.AmbitiousNormalAimbot or {conn = nil, target = nil, swingCooldown = false}

function _G.AmbitiousFindAimbotBat()
  local char = LP.Character
  if not char then return nil end
  for _, tool in ipairs(char:GetChildren()) do
    if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
      return tool
    end
  end
  local bp = LP:FindFirstChild("Backpack")
  if bp then
    for _, tool in ipairs(bp:GetChildren()) do
      if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
        return tool
      end
    end
  end
  return nil
end

function _G.AmbitiousGetClosestAimbotTarget()
  local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
  if not root then return nil end
  local closest, minDist = nil, math.huge
  for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LP and plr.Character then
      local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
      local hum = plr.Character:FindFirstChildOfClass("Humanoid")
      if tRoot and hum and hum.Health > 0 then
        -- >>> ANTI VOID BEGIN
        -- Nel void la distanza va misurata sulla posizione fantasma,
        -- altrimenti il bersaglio risulta lontanissimo e il trigger
        -- dei 4 stud del V2 non scatta mai.
        local tPos = tRoot.Position
        if _G.AmbitiousAntiVoid then
          tPos = _G.AmbitiousAntiVoid.posFor(plr, tPos)
        end
        local dist = (tPos - root.Position).Magnitude
        -- <<< ANTI VOID END
        -- Aggancio piu' preciso: preferisce la parte piu' vicina tra testa e root,
        -- mantenendo il root come fallback per evitare target instabili.
        local tHead = plr.Character:FindFirstChild("Head")
        local aimPart = tRoot
        if tHead then
          local headPos = tHead.Position
          if _G.AmbitiousAntiVoid then headPos = _G.AmbitiousAntiVoid.posFor(plr, headPos) end
          if (headPos - root.Position).Magnitude < dist + 2.5 then aimPart = tHead end
        end
        if dist < minDist then
          minDist = dist
          closest = aimPart
        end
      end
    end
  end
  return closest
end

function _G.AmbitiousGetNormalAimbotSpeed()
  if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
    return tonumber(LAGGER_AIMBOT_SPEED) or 55
  end
  return tonumber(AIMBOT_SPEED) or 82
end

function _G.AmbitiousGetBatAimbotV2Speed()
  if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
    return tonumber(_G.AmbitiousBatAimbotV2LaggerSpeed) or 55
  end
  return tonumber(_G.AmbitiousBatAimbotV2Speed) or 86
end

function _G.AmbitiousGetSelectedAimbotSpeedValues()
  return tonumber(AIMBOT_SPEED) or 82, tonumber(LAGGER_AIMBOT_SPEED) or 40
end

function _G.AmbitiousSetSelectedAimbotSpeedValues(normalValue, laggerValue)
  if normalValue then AIMBOT_SPEED = normalValue end
  if laggerValue then LAGGER_AIMBOT_SPEED = laggerValue end
end

function _G.AmbitiousRefreshAimbotSpeedBoxes()
  local n, l = _G.AmbitiousGetSelectedAimbotSpeedValues()
  if _G.AmbitiousAimbotSpeedBox then _G.AmbitiousAimbotSpeedBox.Text = tostring(n) end
  if _G.AmbitiousLaggerAimbotSpeedBox then _G.AmbitiousLaggerAimbotSpeedBox.Text = tostring(l) end
end

function _G.AmbitiousStartNormalAimbot(keepV2)
  if _G.AmbitiousBatTPOn and _G.AmbitiousStopBatTP then pcall(_G.AmbitiousStopBatTP) end
  if _G.AmbitiousAntiDieArmNow then pcall(_G.AmbitiousAntiDieArmNow) end
  if _G.AmbitiousSafeModeTryStart and not _G.AmbitiousSafeModeTryStart() then return false end
  if _G.AmbitiousStopAutoTPForAction then _G.AmbitiousStopAutoTPForAction() end

  selectedAimbotMode = "V1"
  _G._AmbitiousAimbotChase = _G._AmbitiousAimbotChase or {}
  _G._AmbitiousAimbotChase.V1 = "NORMAL"
  _G.AmbitiousBatAimbotV2On = false
  _G.AmbitiousNormalAimbotOn = true

  if _G.AmbitiousStartChaseRagdollWatcher then pcall(_G.AmbitiousStartChaseRagdollWatcher) end
  if _G.AmbitiousNormalAimbot and _G.AmbitiousNormalAimbot.conn then
    pcall(function() _G.AmbitiousNormalAimbot.conn:Disconnect() end)
    _G.AmbitiousNormalAimbot.conn = nil
  end

  local VX7_BAT_RANGE = 2.0
  local VX7_MAX_H_SPEED = 58.6
  local VX7_LATENCY_COMP = 0.06
  local VX7_MIN_PRED_TIME = 0.03
  local VX7_MAX_PRED_TIME = 0.35
  local VX7_APPROACH_SPEED = 58
  local VX7_ROTATION_SPEED = 120
  local VX7_Y_SPEED_MULT = 9

  local function _isBatTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = string.lower(tool.Name or "")
    return string.find(n, "bat", 1, true) ~= nil
  end

  local function _findBat()
    local char = LP.Character
    if not char then return nil end
    local t = char:FindFirstChildOfClass("Tool")
    if t and _isBatTool(t) then return t end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
      for _, tool in ipairs(backpack:GetChildren()) do
        if _isBatTool(tool) then return tool end
      end
    end
    return _G.AmbitiousFindAimbotBat and _G.AmbitiousFindAimbotBat() or nil
  end

  local function _trySwing()
    pcall(function()
      local char = LP.Character
      if not char then return end
      local bat = _findBat()
      if not bat then return end
      if bat.Parent ~= char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:EquipTool(bat) end) end
      end
      bat:Activate()
      local remote = bat:FindFirstChildWhichIsA("RemoteEvent", true)
      if remote then pcall(function() remote:FireServer() end) end
    end)
  end

  _G.AmbitiousNormalAimbot.conn = RunService.RenderStepped:Connect(function()
    if not _G.AmbitiousNormalAimbotOn then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end

    local bat = _findBat()
    if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end

    local target = _G.AmbitiousGetClosestAimbotTarget and _G.AmbitiousGetClosestAimbotTarget() or nil
    if not target or not target.Parent then return end
    _G.AmbitiousNormalAimbot.target = target

    local targetVel = target.AssemblyLinearVelocity
    local myPos = root.Position
    local targetPos = target.Position
    if _G.AmbitiousAntiVoid then
      local ok, gp, ghost = pcall(function() return _G.AmbitiousAntiVoid.posForPart(target, targetPos) end)
      if ok and gp then
        targetPos = gp
        if ghost then targetVel = Vector3.zero end
      end
    end

    -- VX7 visible tuning: latency compensation + bounded prediction.
    local speed = targetVel.Magnitude
    local predTime = math.clamp(VX7_LATENCY_COMP + speed / 250, VX7_MIN_PRED_TIME, VX7_MAX_PRED_TIME)
    local predictedPos = targetPos + targetVel * predTime

    local look = target.CFrame.LookVector
    predictedPos = predictedPos + look * 0.15

    local flat = Vector3.new(predictedPos.X - myPos.X, 0, predictedPos.Z - myPos.Z)
    local flatDir = flat.Magnitude > 0.05 and flat.Unit or Vector3.zero
    local chaseSpeed = math.clamp(tonumber(_G.AmbitiousGetNormalAimbotSpeed and _G.AmbitiousGetNormalAimbotSpeed() or VX7_APPROACH_SPEED) or VX7_APPROACH_SPEED, 1, VX7_MAX_H_SPEED)

    local desiredY = targetPos.Y + 1.2
    local yVel = (desiredY - myPos.Y) * VX7_Y_SPEED_MULT + targetVel.Y * 0.55
    yVel = math.clamp(yVel, -70, 90)
    local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.72)

    local toTarget = predictedPos - myPos
    if toTarget.Magnitude > 0.08 then
      local goal = CFrame.lookAt(myPos, predictedPos)
      local dx, dy, dz = (root.CFrame:Inverse() * goal):ToEulerAnglesXYZ()
      root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(dx * VX7_ROTATION_SPEED, dy * VX7_ROTATION_SPEED, dz * VX7_ROTATION_SPEED))
    end

    if (root.Position - targetPos).Magnitude <= VX7_BAT_RANGE then
      _trySwing()
    end
  end)

  if _G.AmbitiousRefreshAimbotVisual then _G.AmbitiousRefreshAimbotVisual() end
  if _G.AmbitiousRefreshMobileButtonStates then _G.AmbitiousRefreshMobileButtonStates() end
  return true
end

-- ============================================================
-- BAT AIMBOT STOP / TOGGLE / VISUAL
-- Queste funzioni erano referenziate da keybind e UI ma mancavano:
-- senza Stop il keybind poteva solo accendere l'aimbot, non spegnerlo.
-- ============================================================
function _G.AmbitiousRefreshAimbotVisual()
  local on = _G.AmbitiousNormalAimbotOn == true
  if _G.AmbitiousAimbotSetVisual then
    pcall(_G.AmbitiousAimbotSetVisual, on)
  end
  if _G.AmbitiousRefreshMobileButtonStates then
    pcall(_G.AmbitiousRefreshMobileButtonStates)
  end
end

function _G.AmbitiousStopNormalAimbot()
  _G.AmbitiousNormalAimbotOn = false

  if _G.AmbitiousStopChaseRagdollWatcher then
    pcall(_G.AmbitiousStopChaseRagdollWatcher)
  end

  -- Reset pathfind se presente (non lascia waypoint del chase attivo)
  if _G.AmbitiousPathfind and _G.AmbitiousPathfind.reset then
    pcall(_G.AmbitiousPathfind.reset, "aimbot")
  end

  local st = _G.AmbitiousNormalAimbot
  if st then
    if st.conn then
      pcall(function() st.conn:Disconnect() end)
      st.conn = nil
    end
    st.target = nil
    st.swingCooldown = false
  end

  -- Ferma anche V2 se per qualche motivo era rimasto acceso
  _G.AmbitiousBatAimbotV2On = false
  if _G.AmbitiousBatAimbotV2 and _G.AmbitiousBatAimbotV2.conn then
    pcall(function() _G.AmbitiousBatAimbotV2.conn:Disconnect() end)
    _G.AmbitiousBatAimbotV2.conn = nil
  end

  local char = LP.Character
  local root = char and char:FindFirstChild("HumanoidRootPart")
  if root then
    pcall(function()
      root.AssemblyLinearVelocity = Vector3.zero
      root.AssemblyAngularVelocity = Vector3.zero
      root.Velocity = Vector3.zero
    end)
  end

  if _G.AmbitiousRefreshAimbotVisual then pcall(_G.AmbitiousRefreshAimbotVisual) end
  if _G.AmbitiousRefreshMobileButtonStates then pcall(_G.AmbitiousRefreshMobileButtonStates) end
end

-- Stub V2 stop (la UI attuale usa solo Normal / V1)
function _G.AmbitiousStopBatAimbotV2(_keep)
  _G.AmbitiousBatAimbotV2On = false
  if _G.AmbitiousBatAimbotV2 and _G.AmbitiousBatAimbotV2.conn then
    pcall(function() _G.AmbitiousBatAimbotV2.conn:Disconnect() end)
    _G.AmbitiousBatAimbotV2.conn = nil
  end
  if not _keep then
    if _G.AmbitiousStopChaseRagdollWatcher then pcall(_G.AmbitiousStopChaseRagdollWatcher) end
  end
  if _G.AmbitiousRefreshAimbotVisual then pcall(_G.AmbitiousRefreshAimbotVisual) end
end

function _G.AmbitiousToggleSelectedAimbot()
  if _G.AmbitiousSafeModeIsLocked and _G.AmbitiousSafeModeIsLocked() then
    if _G.AmbitiousSafeModeForceStop then
      pcall(_G.AmbitiousSafeModeForceStop, "SAFE MODE LOCK")
    end
    return
  end

  if _G.AmbitiousNormalAimbotOn == true or _G.AmbitiousBatAimbotV2On == true then
    if _G.AmbitiousStopNormalAimbot then pcall(_G.AmbitiousStopNormalAimbot) end
    if _G.AmbitiousStopBatAimbotV2 then pcall(_G.AmbitiousStopBatAimbotV2, false) end
  else
    if _G.AmbitiousStartNormalAimbot then pcall(_G.AmbitiousStartNormalAimbot) end
  end

  if _G.AmbitiousRefreshAimbotVisual then pcall(_G.AmbitiousRefreshAimbotVisual) end
  if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

-- Mirror TP Down: setter minimo se mancante (evita errori UI)
if type(_G.AmbitiousSetMirrorTPDown) ~= "function" then
  function _G.AmbitiousSetMirrorTPDown(enabled)
    mirrorTPDownEnabled = enabled == true
    if _G.AmbitiousMirrorTPDownSetVisual then
      pcall(_G.AmbitiousMirrorTPDownSetVisual, mirrorTPDownEnabled)
    end
  end
end

-- ============================================================
-- CLEAN SOURCE: BAT BYPASS + BAT DESYNC + TP BAT
-- Core algorithm copied from Clean; only host-compatibility glue is added.
-- ============================================================
localPlayer = LP
newVector3 = Vector3.new
zeroVector = Vector3.zero
newCFrame = CFrame.new
clamp = math.clamp
floor = math.floor
huge = math.huge
sqrt = math.sqrt
lookAtCFrame = CFrame.lookAt
getTime = tick
raycastParams = RaycastParams.new
if not getPlayersCached then
    local _cleanPlayersCache, _cleanPlayersCacheTime = nil, 0
    getPlayersCached = function()
        local now = getTime()
        if _cleanPlayersCache and now - _cleanPlayersCacheTime < 0.03 then return _cleanPlayersCache end
        _cleanPlayersCache = Players:GetPlayers()
        _cleanPlayersCacheTime = now
        return _cleanPlayersCache
    end
end
if not waitForCharacterReady then
    waitForCharacterReady = function(character, timeout)
        local deadline = getTime() + (timeout or 5)
        while not character or not character.Parent or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") do
            if deadline < getTime() then return false end
            task.wait(0.05)
        end
        return true
    end
end
BAT_COUNTER_SLAP_LIST = BAT_COUNTER_SLAP_LIST or { "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap" }
_G.AceSafeModeTryStart = _G.AceSafeModeTryStart or _G.AmbitiousSafeModeTryStart
_G.AceStopAutoTPForAction = _G.AceStopAutoTPForAction or _G.AmbitiousStopAutoTPForAction
_G.AceStopNormalAimbot = _G.AceStopNormalAimbot or _G.AmbitiousStopNormalAimbot
_G.AceAimbotSetVisual = _G.AceAimbotSetVisual or _G.AmbitiousAimbotSetVisual
_G.AceRefreshAimbotVisual = _G.AceRefreshAimbotVisual or _G.AmbitiousRefreshAimbotVisual
_G.AceAntiBypassAimbotSpeed = _G.AceAntiBypassAimbotSpeed or _G.AmbitiousBatAimbotV2Speed
_G.AceAntiBypassLaggerAimbotSpeed = _G.AceAntiBypassLaggerAimbotSpeed or _G.AmbitiousBatAimbotV2LaggerSpeed
_G.AceAntiBypassAimbotOn = _G.AceAntiBypassAimbotOn or _G.AmbitiousBatAimbotV2On
_G.AceGetAntiBypassAimbotSpeed = _G.AceGetAntiBypassAimbotSpeed or _G.AmbitiousGetBatAimbotV2Speed
_G.AceStartAntiBypassAimbot = _G.AceStartAntiBypassAimbot or _G.AmbitiousStartBatAimbotV2
_G.AceStopAntiBypassAimbot = _G.AceStopAntiBypassAimbot or _G.AmbitiousStopBatAimbotV2
_G.AceToggleSelectedAimbot = _G.AceToggleSelectedAimbot or _G.AmbitiousToggleSelectedAimbot
_G.AceAntiBypassStart = _G.AceAntiBypassStart or _G.AmbitiousStartBatAimbotV2
_G.AceAntiBypassStop = _G.AceAntiBypassStop or _G.AmbitiousStopBatAimbotV2
_G.AceAntiBypassSaveToConfig = _G.AceAntiBypassSaveToConfig or function() if saveAmbitiousConfig then saveAmbitiousConfig() end end
_G.AceAntiBypassLoadFromConfig = _G.AceAntiBypassLoadFromConfig or function() end
disableAllAimbots = disableAllAimbots or function() if _G.AmbitiousStopNormalAimbot then pcall(_G.AmbitiousStopNormalAimbot) end if _G.AmbitiousStopBatAimbotV2 then pcall(_G.AmbitiousStopBatAimbotV2, true) end end
saveAllSettings = saveAllSettings or saveAmbitiousConfig
    BAT_V2_SPEED = BAT_V2_SPEED or 55
    BAT_V2_HIT_DIST = BAT_V2_HIT_DIST or 13
    BAT_V2_LEAD_STUDS = BAT_V2_LEAD_STUDS or 3
    BAT_V2_BODY_LOCK_RANGE = BAT_V2_BODY_LOCK_RANGE or 60
    snowVS = _G.SnowVS or {}
    _G.SnowVS = snowVS
    snowVS.BatBypass = snowVS.BatBypass or {}
    snowVS.AimbotBypassV2 = snowVS.BatBypass
    do
        local batBypass = snowVS.BatBypass
        batBypass.Enabled = batBypass.Enabled or false
        batBypass.Connection = batBypass.Connection or nil
        batBypass.Z = batBypass.Z
            or {
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
            }
        batBypass.ZCFG = batBypass.ZCFG
            or {
                FOLLOW_SPEED = BAT_V2_SPEED,
                ACTIVATE_DISTANCE = BAT_V2_HIT_DIST,
                MIN_FOLLOW_DISTANCE = 1,
                PREDICTION_TIME = 0.22,
                PREDICT_AHEAD = BAT_V2_LEAD_STUDS,
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
            }
        local function averageVectors(vectors)
            if #vectors == 0 then
                return Vector3.zero
            end
            local sum = Vector3.zero
            for _, entry in ipairs(vectors) do
                sum += entry
            end
            return sum / #vectors
        end
        local function pushBounded(history, entry, maxEntries)
            table.insert(history, entry)
            if #history > maxEntries then
                table.remove(history, 1)
            end
        end
        batBypass.FindBat = function()
            local character = localPlayer.Character
            if not character then
                return nil
            end
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                local lowercaseText = tool.Name:lower()
                if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                    return tool
                end
            end
            local backpack = localPlayer:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, child in ipairs(backpack:GetChildren()) do
                    if child:IsA("Tool") then
                        local lowercaseText = child.Name:lower()
                        if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                            return child
                        end
                    end
                end
            end
            return nil
        end
        local function resetPredictionState()
            local z = batBypass.Z
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
        local function findClosestPlayer(rootPart)
            local closestDistance = math.huge
            local closestPlayer = nil
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoidRootPart and humanoid and humanoid.Health > 0 then
                        local magnitude = (rootPart.Position - humanoidRootPart.Position).Magnitude
                        if magnitude < closestDistance then
                            closestDistance = magnitude
                            closestPlayer = player
                        end
                    end
                end
            end
            return closestPlayer
        end
        local function applyAngularAim(rootPart, direction)
            if direction.Magnitude < 0.01 then
                return
            end
            local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
            local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
            rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80
                or Vector3.zero
        end
        local function updatePing()
            local ok, result = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            local z = batBypass.Z
            if ok and type(result) == "number" then
                z.realPingMs = math.floor(result)
            end
            z.currentPing = math.clamp(
                z.realPingMs / 1000,
                batBypass.ZCFG.MIN_PING_COMPENSATION,
                batBypass.ZCFG.MAX_PING_COMPENSATION
            )
        end
        batBypass.PingLoopStarted = batBypass.PingLoopStarted or false
        if not batBypass.PingLoopStarted then
            batBypass.PingLoopStarted = true
            task.spawn(function()
                while true do
                    pcall(updatePing)
                    task.wait(0.5)
                end
            end)
        end
        batBypass.StartBodyLock = function() end
        batBypass.StopBodyLock = function() end
        batBypass.Stop = function()
            local z = batBypass.Z
            batBypass.Enabled = false
            if batBypass.Connection then
                batBypass.Connection:Disconnect()
                batBypass.Connection = nil
            end
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            character = character and character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                humanoid.AutoRotate = true
            end
            if character then
                character.AssemblyAngularVelocity = Vector3.zero
            end
            resetPredictionState()
            z.lastActivationTime = 0
        end
        batBypass.Start = function()
            if batBypass.Connection then
                return
            end
            local character = localPlayer.Character
            local humanoid1387 = character and character:FindFirstChildOfClass("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoid1387 or not rootPart then
                return
            end
            batBypass.Enabled = true
            humanoid1387.AutoRotate = false
            local tool = batBypass.FindBat()
            if tool and tool.Parent ~= character then
                pcall(function()
                    humanoid1387:EquipTool(tool)
                end)
            end
            batBypass.Connection = RunService.RenderStepped:Connect(function(deltaTime)
                if not batBypass.Enabled then
                    batBypass.Stop()
                    return
                end
                local z = batBypass.Z
                local zcfg = batBypass.ZCFG
                if _G.AceGetAntiBypassAimbotSpeed then
                    zcfg.FOLLOW_SPEED = _G.AceGetAntiBypassAimbotSpeed()
                end
                local character2 = localPlayer.Character
                local rootPart1394 = character2 and character2:FindFirstChild("HumanoidRootPart")
                local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
                if not rootPart1394 or not humanoid or humanoid.Health <= 0 then
                    return
                end
                humanoid.AutoRotate = false
                rootPart = rootPart1394
                humanoid1387 = humanoid
                tool = character2:FindFirstChildOfClass("Tool") or batBypass.FindBat()
                if tool and tool.Parent ~= character2 then
                    pcall(humanoid.EquipTool, humanoid, tool)
                end
                z.targetPlayer = findClosestPlayer(rootPart)
                local character3 = z.targetPlayer and z.targetPlayer.Character
                local rootPart1442 = character3 and character3:FindFirstChild("HumanoidRootPart")
                character3 = character3 and character3:FindFirstChildOfClass("Humanoid")
                if not rootPart1442 or not character3 or character3.Health <= 0 then
                    resetPredictionState()
                    return
                end
                local position = rootPart1442.Position
                local sampleDeltaTime = math.max(deltaTime, 0.0041666666666666666)
                if z.lastTargetPos then
                    local targetVelocity = (position - z.lastTargetPos) / sampleDeltaTime
                    local vector = targetVelocity - z.targetVelocity
                    if zcfg.MAX_VELOCITY_CHANGE < vector.Magnitude then
                        targetVelocity = z.targetVelocity + vector.Unit * zcfg.MAX_VELOCITY_CHANGE
                    end
                    local vector3 = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
                    if vector3.Magnitude > zcfg.MAX_HORIZONTAL_VELOCITY then
                        local vector = vector3.Unit * zcfg.MAX_HORIZONTAL_VELOCITY
                        targetVelocity = Vector3.new(vector.X, targetVelocity.Y, vector.Z)
                    end
                    pushBounded(z.accelerationHistory, (targetVelocity - z.targetVelocity) / sampleDeltaTime, 4)
                    pushBounded(z.velocityHistory, targetVelocity, 8)
                    z.targetVelocity = targetVelocity
                    z.smoothedVelocity = z.smoothedVelocity:Lerp(targetVelocity, zcfg.VELOCITY_SMOOTHING)
                end
                z.lastTargetPos = position
                local isAirborne = character3.FloorMaterial == Enum.Material.Air
                z.airborneTime = isAirborne and z.airborneTime + sampleDeltaTime or 0
                if isAirborne and z.airborneTime >= zcfg.MIN_AIRBORNE_TIME then
                    pushBounded(z.aerialVelocityHistory, z.targetVelocity, 6)
                elseif not isAirborne then
                    z.aerialVelocityHistory = {}
                end
                local smoothedVelocity = z.smoothedVelocity
                if isAirborne and #z.aerialVelocityHistory > 0 then
                    local vector = averageVectors(z.aerialVelocityHistory)
                    smoothedVelocity = Vector3.new(vector.X, z.targetVelocity.Y, vector.Z) * zcfg.AIR_CONTROL_FACTOR
                end
                local changedDirectionQuickly = false
                local vector3 = Vector3.new(z.targetVelocity.X, 0, z.targetVelocity.Z)
                if vector3.Magnitude > 5 then
                    local unit = vector3.Unit
                    if z.previousDirection and z.previousDirection:Dot(unit) < 0.5 then
                        local lastDirectionChangeTime = z.lastDirectionChangeTime
                        changedDirectionQuickly = tick() - lastDirectionChangeTime
                            < zcfg.DIRECTION_CHANGE_DETECTION_TIME
                        z.lastDirectionChangeTime = tick()
                    end
                    z.previousDirection = unit
                end
                local predictionTime = z.currentPing + zcfg.SERVER_TICKRATE
                if changedDirectionQuickly then
                    predictionTime *= zcfg.QUICK_DIRECTION_CHANGE_MULTIPLIER
                end
                local accelerationPredictionWeight = zcfg.ACCELERATION_PREDICTION_WEIGHT
                local predictedPosition = position
                    + smoothedVelocity * predictionTime
                    + averageVectors(z.accelerationHistory)
                        * accelerationPredictionWeight
                        * predictionTime
                        * predictionTime
                        * 0.5
                local leadTime = zcfg.PREDICTION_TIME * 1.1
                local leadPosition
                if isAirborne then
                    leadPosition = predictedPosition
                        + smoothedVelocity * leadTime
                        + Vector3.new(0, -0.5 * zcfg.GRAVITY * leadTime * leadTime, 0)
                else
                    leadPosition = predictedPosition + smoothedVelocity * leadTime
                end
                local vector4 = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
                if vector4.Magnitude > 1 then
                    leadPosition += vector4.Unit * zcfg.PREDICT_AHEAD
                end
                local targetDirection = leadPosition - rootPart.Position
                applyAngularAim(rootPart, targetDirection)
                local withinActivationRange = (position - rootPart.Position).Magnitude <= zcfg.ACTIVATE_DISTANCE
                if withinActivationRange then
                    local lastActivationTime = z.lastActivationTime
                    withinActivationRange = tick() - lastActivationTime >= 0.3
                end
                if withinActivationRange then
                    if tool then
                        pcall(tool.Activate, tool)
                    end
                    z.lastActivationTime = tick()
                end
                if zcfg.MIN_FOLLOW_DISTANCE < targetDirection.Magnitude then
                    rootPart.AssemblyLinearVelocity = targetDirection.Unit * zcfg.FOLLOW_SPEED
                else
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
                end
            end)
        end
        batBypass.Toggle = function()
            if batBypass.Enabled then
                batBypass.Stop()
            else
                batBypass.Start()
            end
        end
    end
    local desyncLoopRunning, networkSpamThread, startCharacterRecoveryLoop, stopCharacterRecoveryLoop, setOutgoingBandwidthLimit, sendBlockListPayload
    do
        local function saveAimbotSettings()
            if type(saveAllSettings) == "function" then
                pcall(saveAllSettings)
            end
        end
        local function refreshSpeedModeLabel()
            if currentSpeedMode == "Lagger Carry" then
                return "Lagger Carry"
            end
            if currentSpeedMode == "Lagger" then
                return "Lagger"
            end
            if currentSpeedMode == "Carry" then
                return "Carry"
            end
            return "Normal"
        end
        _G.AceGetAntiBypassAimbotSpeed = function()
            local speedModeName = refreshSpeedModeLabel()
            if speedModeName == "Lagger" or speedModeName == "Lagger Carry" then
                return tonumber(_G.AceAntiBypassLaggerAimbotSpeed) or 40
            end
            return tonumber(_G.AceAntiBypassAimbotSpeed) or 60
        end
        _G.AceRefreshAimbotVisual = function()
            if _G.AceAimbotSetVisual then
                _G.AceAimbotSetVisual(_G.AceAntiBypassAimbotOn == true)
            end
        end
        _G.AceStartAntiBypassAimbot = function()
            if _G.AceSafeModeTryStart and not _G.AceSafeModeTryStart() then
                return false
            end
            if _G.AceStopAutoTPForAction then
                _G.AceStopAutoTPForAction()
            end
            if _G.AceStopNormalAimbot then
                _G.AceStopNormalAimbot()
            end
            selectedAimbotMode = "Bat Bypass"
            _G.AceAntiBypassAimbotOn = true
            snowVS.BatBypass.ZCFG.FOLLOW_SPEED = _G.AceGetAntiBypassAimbotSpeed()
            snowVS.BatBypass.Start()
            if _G.AceRefreshAimbotVisual then
                _G.AceRefreshAimbotVisual()
            end
            saveAimbotSettings()
            return true
        end
        _G.AceStopAntiBypassAimbot = function(updateVisual)
            snowVS.BatBypass.Stop()
            _G.AceAntiBypassAimbotOn = false
            if updateVisual ~= false and _G.AceRefreshAimbotVisual then
                _G.AceRefreshAimbotVisual()
            end
            saveAimbotSettings()
        end
        _G.AceToggleSelectedAimbot = function()
            if selectedAimbotMode == "Bat Bypass" then
                if _G.AceAntiBypassAimbotOn then
                    _G.AceStopAntiBypassAimbot()
                else
                    _G.AceStartAntiBypassAimbot()
                end
            end
            if _G.AceRefreshAimbotVisual then
                _G.AceRefreshAimbotVisual()
            end
            saveAimbotSettings()
        end
    end
    do
        local object, object1476
        _G.AceAntiBypassStart = _G.AceStartAntiBypassAimbot
        _G.AceAntiBypassStop = _G.AceStopAntiBypassAimbot
        enableBatV2 = function()
            selectedAimbotMode = "Bat Bypass"
            if _G.AceStartAntiBypassAimbot() ~= false then
                autoBatV2Enabled = true
                if autoBatV2SetVisual then
                    autoBatV2SetVisual(true)
                end
                if batV2FloatingButton then
                    local frame = batV2FloatingButton:FindFirstChild("Frame")
                    if frame then
                        paintFloatingBtn(frame, true)
                    end
                end
            end
        end
        disableBatV2 = function()
            _G.AceStopAntiBypassAimbot()
            autoBatV2Enabled = false
            if autoBatV2SetVisual then
                autoBatV2SetVisual(false)
            end
            if batV2FloatingButton then
                local frame = batV2FloatingButton:FindFirstChild("Frame")
                if frame then
                    paintFloatingBtn(frame, false)
                end
            end
        end
        toggleBatV2 = function()
            if autoBatV2Enabled then
                disableBatV2()
            else
                enableBatV2()
            end
        end
        _G.AceAntiBypassSaveToConfig = function(value)
            local vector = value or {}
            vector.selectedAimbotMode = selectedAimbotMode
            vector.ANTI_BYPASS_AIMBOT_SPEED = _G.AceAntiBypassAimbotSpeed
            vector.ANTI_BYPASS_LAGGER_AIMBOT_SPEED = _G.AceAntiBypassLaggerAimbotSpeed
            vector.antiBypassAimbotEnabled = _G.AceAntiBypassAimbotOn == true
            return vector
        end
        _G.AceAntiBypassLoadFromConfig = function(vector)
            if type(vector) ~= "table" then
                return
            end
            selectedAimbotMode = vector.selectedAimbotMode or selectedAimbotMode
            if selectedAimbotMode == "Anti Bypass" then
                selectedAimbotMode = "Bat Bypass"
            end
            if selectedAimbotMode ~= "Bat Bypass" then
                selectedAimbotMode = "Normal"
            end
            _G.AceAntiBypassAimbotSpeed = tonumber(vector.ANTI_BYPASS_AIMBOT_SPEED) or _G.AceAntiBypassAimbotSpeed or 60
            if
                vector.ANTI_BYPASS_LAGGER_AIMBOT_SPEED == nil
                or tonumber(vector.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) == 58
            then
                _G.AceAntiBypassLaggerAimbotSpeed = 40
            else
                _G.AceAntiBypassLaggerAimbotSpeed = tonumber(vector.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) or 40
            end
            _G.AceAntiBypassAimbotOn = vector.antiBypassAimbotEnabled == true
        end
        batDesyncTpEnabled = false
        batDesyncTpConn = nil
        batDesyncTpSetVisual = nil
        isActive = false
        _G.AlvaroTP = _G.AlvaroTP
            or {
                conn = nil,
                on = false,
                h = nil,
                hrp = nil,
                hittingCooldown = false,
                _charConn = nil,
            }
        desyncLoopRunning = false
        do
            local recoveryThread = nil
            networkSpamThread = nil
            object = nil
            object1476 = nil
            startCharacterRecoveryLoop = function()
                if recoveryThread then
                    return
                end
                recoveryThread = task.spawn(function()
                    while batDesyncTpEnabled do
                        pcall(function()
                            local character = localPlayer.Character
                            if not character then
                                task.wait(0.1)
                                return
                            end
                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            if humanoid then
                                if humanoid.Health <= 0 then
                                    humanoid.Health = humanoid.MaxHealth
                                end
                                if humanoid.PlatformStand then
                                    humanoid.PlatformStand = false
                                end
                                if humanoid.Sit then
                                    humanoid.Sit = false
                                end
                                local state = humanoid:GetState()
                                if
                                    state == Enum.HumanoidStateType.Physics
                                    or state == Enum.HumanoidStateType.Ragdoll
                                    or state == Enum.HumanoidStateType.FallingDown
                                then
                                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                                end
                            end
                            if humanoidRootPart and sethiddenproperty then
                                pcall(sethiddenproperty, humanoidRootPart, "PhysicsRepRootPart", nil)
                            end
                            if character then
                                for _, descendant in ipairs(character:GetDescendants()) do
                                    if descendant:IsA("BasePart") then
                                        descendant.CanCollide = false
                                    end
                                end
                            end
                        end)
                        task.wait(0.05)
                    end
                    recoveryThread = nil
                end)
            end
            stopCharacterRecoveryLoop = function()
                if recoveryThread then
                    pcall(task.cancel, recoveryThread)
                    recoveryThread = nil
                end
            end
        end
        do
            local function createNestedPayload()
                if object then
                    return object
                end
                local payloadRoot = {}
                local payloadCursor = payloadRoot
                for i = 1, 12 do
                    local nestedTable = {}
                    payloadCursor[1] = nestedTable
                    payloadCursor = nestedTable
                end
                object = payloadRoot
                return payloadRoot
            end
            local function createBlockListPayload()
                if object1476 then
                    return object1476
                end
                local nestedPayload = createNestedPayload()
                local blockListPayload = table.create(800)
                for i = 1, 300 do
                    blockListPayload[i] = nestedPayload
                end
                object1476 = blockListPayload
                return blockListPayload
            end
            setOutgoingBandwidthLimit = function(limit)
                pcall(function()
                    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(limit)
                end)
            end
            sendBlockListPayload = function()
                pcall(function()
                    local playersService = game:GetService("Players")
                    if playersService and playersService:FindFirstChild("SetPlayerBlockList") then
                        playersService.SetPlayerBlockList:FireServer(createBlockListPayload())
                    end
                end)
            end
        end
    end
    do
        local function startNetworkSpamLoop()
            if not networkSpamThread then
                networkSpamThread = task.spawn(function()
                    task.wait(0.05)
                    while batDesyncTpEnabled do
                        setOutgoingBandwidthLimit(12000)
                        sendBlockListPayload()
                        task.wait(0.15)
                    end
                    setOutgoingBandwidthLimit(0)
                    networkSpamThread = nil
                end)
                return
            end
            return
        end
        local function stopNetworkSpamLoop()
            if networkSpamThread then
                pcall(task.cancel, networkSpamThread)
                networkSpamThread = nil
            end
            setOutgoingBandwidthLimit(0)
        end
        local function findAndEquipBat()
            local character = localPlayer.Character
            if not character then
                return nil
            end
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Tool") then
                    local lowercaseText = child.Name:lower()
                    if lowercaseText:find("bat") or lowercaseText:find("slap") then
                        return child
                    end
                end
            end
            local backpack = localPlayer:FindFirstChild("Backpack")
            if not backpack then
                return nil
            end
            for _, child in ipairs(backpack:GetChildren()) do
                if child:IsA("Tool") then
                    local lowercaseText = child.Name:lower()
                    if lowercaseText:find("bat") or lowercaseText:find("slap") then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            pcall(function()
                                humanoid:EquipTool(child)
                            end)
                        end
                        return child
                    end
                end
            end
            return nil
        end
        local function tryHitBatDesync()
            if desyncLoopRunning then
                return
            end
            desyncLoopRunning = true
            pcall(function()
                local bat = findAndEquipBat()
                if not bat then
                    return
                end
                bat:Activate()
                local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
                if remoteEvent then
                    remoteEvent:FireServer()
                end
            end)
            task.delay(0.08, function()
                desyncLoopRunning = false
            end)
        end
        local function findNearestOpponent(rootPart)
            local huge2 = math.huge
            local closestPlayer = nil
            for _, player in ipairs(Players:GetPlayers()) do
                local character = player ~= localPlayer and player.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                character = character and character:FindFirstChildOfClass("Humanoid")
                if humanoidRootPart and character and character.Health > 0 then
                    local magnitude = (rootPart.Position - humanoidRootPart.Position).Magnitude
                    if magnitude < huge2 then
                        huge2 = magnitude
                        closestPlayer = player
                    end
                end
            end
            return closestPlayer, huge2
        end
        local function teleportToTarget(callback, rootPart)
            pcall(function()
                if callback.SetNetworkOwner then
                    callback:SetNetworkOwner(nil)
                end
            end)
            task.wait()
            callback.CFrame = newCFrame(rootPart.Position + newVector3(0, 2.5, 0))
            callback.AssemblyLinearVelocity = rootPart.AssemblyLinearVelocity
            pcall(function()
                if callback.SetNetworkOwner then
                    callback:SetNetworkOwner(localPlayer)
                end
            end)
        end
        local function updateBatDesyncTeleport()
            if not batDesyncTpEnabled then
                return
            end
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not humanoidRootPart or not humanoid then
                return
            end
            local remoteEvent = humanoid:FindFirstChildOfClass("RemoteEvent")
            if remoteEvent then
                pcall(function()
                    for _, entry in ipairs(remoteEvent:GetPlayingAnimationTracks()) do
                        entry:Stop()
                    end
                end)
            end
            local instance = findAndEquipBat()
            if instance and instance.Parent ~= character then
                pcall(function()
                    humanoid:EquipTool(instance)
                end)
            end
            local player, distance = findNearestOpponent(humanoidRootPart)
            if not player or distance > 100 then
                return
            end
            local character2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not character2 then
                return
            end
            teleportToTarget(humanoidRootPart, character2)
            local currentCamera2 = workspace.CurrentCamera
            if currentCamera2 then
                currentCamera2.CFrame = newCFrame(currentCamera2.CFrame.Position, character2.Position)
            end
            tryHitBatDesync()
            pcall(function()
                for _, descendant in ipairs(character:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.CanCollide = false
                    end
                end
            end)
        end
        startAlvaroTP = function()
            if batDesyncTpConn then
                batDesyncTpConn:Disconnect()
                batDesyncTpConn = nil
            end
            batDesyncTpEnabled = true
            _G.AlvaroTP.on = true
            _G.AlvaroTP.conn = nil
            desyncLoopRunning = false
            local character = localPlayer.Character
            if character then
                _G.AlvaroTP.h = character:FindFirstChildOfClass("Humanoid")
                _G.AlvaroTP.hrp = character:FindFirstChild("HumanoidRootPart")
            end
            batDesyncTpConn = RunService.Heartbeat:Connect(updateBatDesyncTeleport)
            _G.AlvaroTP.conn = batDesyncTpConn
            startCharacterRecoveryLoop()
            startNetworkSpamLoop()
            if batDesyncTpSetVisual then
                batDesyncTpSetVisual(true)
            end
            updateTpBatButtonWithAntiDie(true)
        end
        stopAlvaroTP = function()
            batDesyncTpEnabled = false
            _G.AlvaroTP.on = false
            if batDesyncTpConn then
                batDesyncTpConn:Disconnect()
                batDesyncTpConn = nil
            end
            _G.AlvaroTP.conn = nil
            _G.AlvaroTP.hittingCooldown = false
            desyncLoopRunning = false
            stopCharacterRecoveryLoop()
            stopNetworkSpamLoop()
            local hrp = _G.AlvaroTP.hrp
            if hrp and hrp.Parent then
                pcall(function()
                    if hrp.SetNetworkOwner then
                        hrp:SetNetworkOwner(localPlayer)
                    end
                end)
            end
            if batDesyncTpSetVisual then
                batDesyncTpSetVisual(false)
            end
            updateTpBatButtonWithAntiDie(false)
        end
    end
local restoreLightingState, applyNeonWeather, makeDraggable
toggleAlvaroTP = function()
    if batDesyncTpEnabled then
        stopAlvaroTP()
    else
        startAlvaroTP()
    end
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end
    if _G.AlvaroTP.on then
        if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
            pcall(function()
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end)
        end
    end
end)
if _G.AlvaroTP._charConn then
    pcall(function()
        _G.AlvaroTP._charConn:Disconnect()
    end)
    _G.AlvaroTP._charConn = nil
end
do
    local function updateAlvaroCharacterReferences(character)
        task.wait(0.15)
        _G.AlvaroTP.h = character and character:FindFirstChildOfClass("Humanoid") or nil
        _G.AlvaroTP.hrp = character and character:FindFirstChild("HumanoidRootPart") or nil
        if batDesyncTpEnabled and not batDesyncTpConn then
            startAlvaroTP()
        end
    end
    _G.AlvaroTP._charConn = localPlayer.CharacterAdded:Connect(function(character)
        pcall(function()
            updateAlvaroCharacterReferences(character)
        end)
    end)
    if localPlayer.Character then
        task.spawn(function()
            pcall(function()
                updateAlvaroCharacterReferences(localPlayer.Character)
            end)
        end)
    end
end
startBatDesyncTp = function()
    if not _G.AmbitiousSafeModeTryStart() then
        return
    end
    if not unwalkEnabled then
        startUnwalk()
        unwalkEnabled = true
        isActive = true
        if setUnwalkVisual then
            setUnwalkVisual(true)
        end
    end
    startAlvaroTP()
end
stopBatDesyncTp = function()
    stopAlvaroTP()
    if isActive then
        stopUnwalk()
        unwalkEnabled = false
        isActive = false
        if setUnwalkVisual then
            setUnwalkVisual(false)
        end
    end
end
toggleBatDesyncTp = function()
    if batDesyncTpEnabled then
        stopBatDesyncTp()
    else
        disableAllAimbots()
        if autoLeftEnabled then
            autoLeftEnabled = false
            stopAutoLeft()
            if autoLeftSetVisual then
                autoLeftSetVisual(false)
            end
            if mobSetAutoLeft then
                mobSetAutoLeft(false)
            end
        end
        if autoRightEnabled then
            autoRightEnabled = false
            stopAutoRight()
            if autoRightSetVisual then
                autoRightSetVisual(false)
            end
            if mobSetAutoRight then
                mobSetAutoRight(false)
            end
        end
        startBatDesyncTp()
    end
    saveAllSettings()
end
setTPBatVersion = function() end
updateTpBatButtonWithAntiDie = function(value)
    if batDesyncTpSetVisual then
        batDesyncTpSetVisual(value)
    end
end
_G.AmbitiousBatTPVersion = "CLEAN"
_G.AlvaroTPBat = {
    toggle = toggleAlvaroTP,
    start = startAlvaroTP,
    stop = stopAlvaroTP,
    getStatus = function()
        return _G.AlvaroTP.on
    end,
}

-- Roma API aliases for the Clean TP Bat implementation.
_G.AmbitiousBatTPOn = _G.AlvaroTP and _G.AlvaroTP.on == true or batDesyncTpEnabled == true
_G.AmbitiousStartBatTP = function() local r = startBatDesyncTp(); _G.AmbitiousBatTPOn = _G.AlvaroTP and _G.AlvaroTP.on == true or batDesyncTpEnabled == true; return r end
_G.AmbitiousStopBatTP = function() local r = stopBatDesyncTp(); _G.AmbitiousBatTPOn = false; return r end
_G.AmbitiousToggleBatTP = function() local r = toggleBatDesyncTp(); _G.AmbitiousBatTPOn = _G.AlvaroTP and _G.AlvaroTP.on == true or batDesyncTpEnabled == true; return r end
_G.AmbitiousSetBatTPVersion = function(_) _G.AmbitiousBatTPVersion = "CLEAN" end
_G.AmbitiousRefreshBatTPVisual = function() if batDesyncTpSetVisual then pcall(batDesyncTpSetVisual, _G.AmbitiousBatTPOn == true) end end
_G.AmbitiousToggleSelectedAimbot = _G.AmbitiousToggleSelectedAimbot or _G.AceToggleSelectedAimbot
_G.AmbitiousStartBatAimbotV2 = _G.AmbitiousStartBatAimbotV2 or _G.AceStartAntiBypassAimbot
_G.AmbitiousStopBatAimbotV2 = _G.AmbitiousStopBatAimbotV2 or _G.AceStopAntiBypassAimbot
_G.AmbitiousBatAimbotV2On = _G.AmbitiousBatAimbotV2On == true or _G.AceAntiBypassAimbotOn == true

-- RAGDOLL DETECTOR PER IL CHASE (Bat Aimbot V1 / V2)
-- Detector del chase, ciclo di vita compreso:
-- le connessioni si creano allo start del chase e si staccano allo stop.
-- A chase spento non resta collegato nulla.
-- ========================================================
do
  local chaseRagdollEnabled = false
  local chaseRagdollPlayerConns = {}
  local chaseRagdollAddedConn = nil
  local chaseRagdollRemovingConn = nil

  local function onChaseEnemyRagdollStarted()
    if not chaseRagdollEnabled then return end
    -- Disattivazione ISTANTANEA al rilevamento hit (nessun cooldown)
    if _G.AmbitiousBatAimbotV2On then
      -- V2: si spegne il chase e non riparte da solo.
      if _G.AmbitiousStopBatAimbotV2 then _G.AmbitiousStopBatAimbotV2() end
    elseif _G.AmbitiousNormalAimbotOn then
      if _G.AmbitiousStopNormalAimbot then _G.AmbitiousStopNormalAimbot() end
    end
  end

  local function setupChaseRagdollDetector(enemyChar)
    local conn = enemyChar.DescendantAdded:Connect(function(d)
      if d:IsA("BallSocketConstraint") then onChaseEnemyRagdollStarted() end
    end)
    return conn
  end

  local function watchChaseEnemyPlayer(plr)
    if plr == LP then return end
    if chaseRagdollPlayerConns[plr] then
      pcall(function() chaseRagdollPlayerConns[plr]:Disconnect() end)
    end
    chaseRagdollPlayerConns[plr] = plr.CharacterAdded:Connect(function(char)
      if char and chaseRagdollEnabled then
        local detectorConn = setupChaseRagdollDetector(char)
        char.AncestryChanged:Connect(function(_, parent)
          if not parent then pcall(function() detectorConn:Disconnect() end) end
        end)
      end
    end)
    if plr.Character then
      local detectorConn = setupChaseRagdollDetector(plr.Character)
      plr.Character.AncestryChanged:Connect(function(_, parent)
        if not parent then pcall(function() detectorConn:Disconnect() end) end
      end)
    end
  end

  -- Avviato da StartNormalAimbot (vale sia per il V1 che per la fase 1 del V2)
  function _G.AmbitiousStartChaseRagdollWatcher()
    if chaseRagdollEnabled then return end
    chaseRagdollEnabled = true
    if chaseRagdollAddedConn then chaseRagdollAddedConn:Disconnect() end
    chaseRagdollAddedConn = Players.PlayerAdded:Connect(watchChaseEnemyPlayer)
    for _, plr in ipairs(Players:GetPlayers()) do
      watchChaseEnemyPlayer(plr)
    end
    if chaseRagdollRemovingConn then chaseRagdollRemovingConn:Disconnect() end
    chaseRagdollRemovingConn = Players.PlayerRemoving:Connect(function(plr)
      if chaseRagdollPlayerConns[plr] then
        pcall(function() chaseRagdollPlayerConns[plr]:Disconnect() end)
        chaseRagdollPlayerConns[plr] = nil
      end
    end)
  end

  -- Fermato da StopNormalAimbot / StopBatAimbotV2
  function _G.AmbitiousStopChaseRagdollWatcher()
    chaseRagdollEnabled = false
    if chaseRagdollAddedConn then
      chaseRagdollAddedConn:Disconnect()
      chaseRagdollAddedConn = nil
    end
    if chaseRagdollRemovingConn then
      chaseRagdollRemovingConn:Disconnect()
      chaseRagdollRemovingConn = nil
    end
    for _, conn in pairs(chaseRagdollPlayerConns) do
      pcall(function() conn:Disconnect() end)
    end
    table.clear(chaseRagdollPlayerConns)
  end
end


_G.__AmbitiousSetupNormalAutoSteal = function()
  _G.AmbitiousNormalSteal = _G.AmbitiousNormalSteal or {
    enabled = false,
    radius = 62,
    duration = 1.3,
    animals = {},
    promptCache = {},
    internalCache = {},
    scannerStarted = false,
    scanning = false,
    isStealing = false,
    stealConn = nil,
    refreshThread = nil,
    lastSteal = 0,
    cooldown = 0.08,
  }
  if _G.AmbitiousNormalSteal.stealConn then pcall(function() _G.AmbitiousNormalSteal.stealConn:Disconnect() end); _G.AmbitiousNormalSteal.stealConn = nil end
  _G.AmbitiousNormalSteal.enabled = false
  _G.AmbitiousNormalSteal.isStealing = false

  local function barProgress(p)
    p = math.clamp(tonumber(p) or 0, 0, 1)
    pcall(function()
      if _G.StealBar then
        _G.StealBar.SetState("STEALING")
        _G.StealBar.SetProgress(p)
      end
    end)
  end

  local function resetBar()
    pcall(function()
      if _G.StealBar then _G.StealBar.Reset() end
    end)
  end

  local function getRoot()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
  end

  local function isMyBase(plotName)
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    local yourBase = sign and sign:FindFirstChild("YourBase")
    return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
  end

  local function scanPlots()
    local a = _G.AmbitiousNormalSteal
    a.animals = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
      if plot:IsA("Model") and not isMyBase(plot.Name) then
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
          for _, podium in ipairs(podiums:GetChildren()) do
            if podium:IsA("Model") then
              local base = podium:FindFirstChild("Base")
              local spawn = base and base:FindFirstChild("Spawn")
              if spawn then
                table.insert(a.animals, {
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

  local function ensureScanner()
    local a = _G.AmbitiousNormalSteal
    if a.scannerStarted then return end
    a.scannerStarted = true
    task.spawn(function()
      task.wait(1)
      while _G.AmbitiousNormalSteal do
        if _G.AmbitiousNormalSteal.enabled then
          pcall(scanPlots)
        end
        task.wait(3)
      end
    end)
  end

  local function findPrompt(data)
    if not data then return nil end
    local a = _G.AmbitiousNormalSteal
    local cached = a.promptCache[data.uid]
    if cached and cached.Parent then return cached end
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(data.plot)
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    local podium = podiums and podiums:FindFirstChild(data.slot)
    local base = podium and podium:FindFirstChild("Base")
    local spawn = base and base:FindFirstChild("Spawn")
    local attach = spawn and spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, prompt in ipairs(attach:GetChildren()) do
      if prompt:IsA("ProximityPrompt") then
        a.promptCache[data.uid] = prompt
        return prompt
      end
    end
    return nil
  end

  local function cacheCallbacks(prompt)
    local a = _G.AmbitiousNormalSteal
    if a.internalCache[prompt] then return end
    local data = {hold = {}, trigger = {}, ready = true}
    pcall(function()
      if getconnections then
        for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
          if type(conn.Function) == "function" then table.insert(data.hold, conn.Function) end
        end
        for _, conn in ipairs(getconnections(prompt.Triggered)) do
          if type(conn.Function) == "function" then table.insert(data.trigger, conn.Function) end
        end
      end
    end)
    if #data.hold > 0 or #data.trigger > 0 then
      a.internalCache[prompt] = data
    end
  end

  -- Stesso identico check delle modalita' Semi: distanza dal prompt vivo
  -- (prompt.Parent.Parent = la parte Spawn), non da una posizione salvata.
  local function stillInRange(prompt)
    local a = _G.AmbitiousNormalSteal
    local root = getRoot()
    if not root or not prompt.Parent or not prompt.Parent.Parent then return false end
    return (root.Position - prompt.Parent.Parent.Position).Magnitude <= (tonumber(a.radius) or 62)
  end

  -- Trigger robusto: alcuni executor non espongono getconnections() oppure
  -- i callback ottenuti da PromptButtonHoldBegan/Triggered non possono essere
  -- invocati direttamente. In quel caso usiamo fireproximityprompt come
  -- fallback nativo dell'executor.
  local function fireStealPrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    if type(fireproximityprompt) == "function" then
      local ok = pcall(function() fireproximityprompt(prompt) end)
      if ok then return true end
    end
    return false
  end

  local function doSteal(prompt)
    local a = _G.AmbitiousNormalSteal
    if not prompt or not prompt.Parent or a.isStealing then return end
    if tick() - (a.lastSteal or 0) < (a.cooldown or 0.08) then return end
    cacheCallbacks(prompt)
    local data = a.internalCache[prompt]
    if not data then
      -- Non dipendere da getconnections(): fireproximityprompt basta per gli
      -- executor che non permettono di leggere i callback del prompt.
      if type(fireproximityprompt) ~= "function" then return end
      data = {hold = {}, trigger = {}, ready = true}
      a.internalCache[prompt] = data
    end
    if not data.ready then return end
    data.ready = false
    a.isStealing = true
    a.lastSteal = tick()
    pcall(function() if _G.StealBar then _G.StealBar.SetState("STEALING") end end)
    task.spawn(function()
      if #data.hold > 0 then
        for _, fn in ipairs(data.hold) do task.spawn(function() pcall(fn) end) end
      end
      local startTime = tick()
      local dur = 1.3
      a.duration = dur
      -- La barra si riempie in 1.25s e resta piena per gli ultimi 0.05s:
      -- cosi' il 100% e' visibile invece di comparire nello stesso frame del reset.
      local fillDur = math.max(dur - 0.05, 0.05)
      local aborted = false
      while a.enabled and selectedStealMode == "Normal" and tick() - startTime < dur do
        if not stillInRange(prompt) then
          aborted = true
          break
        end
        barProgress((tick() - startTime) / fillDur)
        task.wait(0.02)
      end
      if aborted or not a.enabled or selectedStealMode ~= "Normal" then
        data.ready = true
        a.isStealing = false
        resetBar()
        return
      end
      barProgress(1)
      local triggered = false
      if #data.trigger > 0 then
        for _, fn in ipairs(data.trigger) do task.spawn(function() pcall(fn) end) end
        triggered = true
      end
      if not triggered then
        fireStealPrompt(prompt)
      end
      pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
      -- nessun wait: ripartenza immediata al prossimo Heartbeat
      data.ready = true
      a.isStealing = false
      resetBar()
    end)
  end

  local function nearestAnimal()
    local a = _G.AmbitiousNormalSteal
    local root = getRoot()
    if not root then return nil end
    local radius = tonumber(a.radius) or 62

    -- STESSA SCELTA DEL BERSAGLIO DELLA SEMI.
    -- Prima si guardava la lista costruita dallo scan della Normal, che
    -- contiene TUTTI i podi (anche quelli vuoti), e si usava la
    -- worldPosition salvata al momento della scansione. Due problemi in
    -- uno: si prendeva di mira un podio senza niente sopra, e anche
    -- quando l'animale spariva la posizione vecchia restava buona,
    -- quindi lo steal partiva lo stesso a vuoto.
    -- La lista della Semi nasce invece dall'AnimalList del plot (solo
    -- slot davvero occupati) e la posizione viene risolta ADESSO dal
    -- podio: se non c'e' piu' niente, animalPos ritorna nil e quella
    -- voce non e' un bersaglio.
    -- #list > 0 e non solo "e' una tabella": lo scan condiviso ci mette un
    -- attimo a partire (aspetta ReplicatedStorage), e con la lista ancora
    -- vuota si usciva subito senza bersaglio invece di ripiegare sulla
    -- scansione propria. Era per quello che la Normal sembrava morta
    -- finche' non passavi da Semi e tornavi indietro.
    if _G.AmbitiousStealAnimals then
      local list = _G.AmbitiousStealAnimals()
      if type(list) == "table" and #list > 0 then
        local best, bestDist = nil, math.huge
        for _, data in ipairs(list) do
          local mine = _G.AmbitiousStealIsMyBase and _G.AmbitiousStealIsMyBase(data)
          local occupied = (not _G.AmbitiousStealSlotOccupied)
                           or _G.AmbitiousStealSlotOccupied(data)
          if not mine and occupied then
            local pos = _G.AmbitiousStealAnimalPos and _G.AmbitiousStealAnimalPos(data)
            if pos then
              local dist = (root.Position - pos).Magnitude
              if dist <= radius and dist < bestDist then
                best, bestDist = data, dist
              end
            end
          end
        end
        return best
      end
    end

    -- Ripiego: la Semi non e' ancora stata inizializzata. Anche qui la
    -- posizione si risolve dal vivo, non dalla worldPosition salvata.
    local best, bestDist = nil, math.huge
    for _, data in ipairs(a.animals) do
      if not isMyBase(data.plot) then
        local plots = workspace:FindFirstChild("Plots")
        local plot = plots and plots:FindFirstChild(data.plot)
        local podiums = plot and plot:FindFirstChild("AnimalPodiums")
        local podium = podiums and podiums:FindFirstChild(data.slot)
        if podium then
          local dist = (root.Position - podium:GetPivot().Position).Magnitude
          if dist <= radius and dist < bestDist then
            best, bestDist = data, dist
          end
        end
      end
    end
    return best
  end

  _G.AmbitiousNormalAutoStealSetRadius = function(v)
    _G.AmbitiousNormalSteal.radius = tonumber(v) or _G.AmbitiousNormalSteal.radius or 62
  end

  _G.AmbitiousNormalAutoStealStop = function()
    local a = _G.AmbitiousNormalSteal
    a.enabled = false
    a.isStealing = false
    if a.stealConn then a.stealConn:Disconnect(); a.stealConn = nil end
    resetBar()
  end

  _G.AmbitiousNormalAutoStealStart = function()
    local a = _G.AmbitiousNormalSteal
    a.radius = tonumber(autoStealRadius) or a.radius or 62
    a.duration = 1.3
    a.enabled = true
    ensureScanner()
    pcall(scanPlots)
    -- Lista condivisa con la Semi: va fatta partire, se no resta vuota e
    -- nearestAnimal non ha niente su cui lavorare.
    if _G.AmbitiousStealEnsureScan then pcall(_G.AmbitiousStealEnsureScan) end
    if a.stealConn then a.stealConn:Disconnect(); a.stealConn = nil end
    a.stealConn = RunService.Heartbeat:Connect(function()
      if not a.enabled then return end
      if selectedStealMode ~= "Normal" then _G.AmbitiousNormalAutoStealStop(); return end
      if a.isStealing then return end
      local target = nearestAnimal()
      if not target then return end
      local prompt = findPrompt(target)
      if prompt then doSteal(prompt) end
    end)
  end

  _G.AmbitiousNormalAutoStealSync = function()
    if selectedStealMode == "Normal" and autoStealEnabled then
      _G.AmbitiousNormalAutoStealStart()
    else
      _G.AmbitiousNormalAutoStealStop()
    end
  end
end

_G.__AmbitiousSetupNormalAutoSteal()

_G.__AmbitiousSetupSemiAutoSteal = function()
  _G.AmbitiousSemiSteal = _G.AmbitiousSemiSteal or {}
  local A = _G.AmbitiousSemiSteal
  if A.conn then pcall(function() A.conn:Disconnect() end); A.conn = nil end
  A.enabled    = false
  A.cooldown   = A.cooldown   or 0.05
  A.primeRange = A.primeRange or 80
  A.radius     = tonumber(autoStealRadius) or A.radius or 60
  -- applica valori salvati dal config (loadAmbitiousConfig gira prima di questo setup)
  local pending = _G._AmbitiousSemiStealPending
  A.autoGrabStopTime       = (pending and pending.autoGrabStopTime)       or A.autoGrabStopTime       or 1.29
  A.autoGrabStopPercent    = (pending and pending.autoGrabStopPercent)    or A.autoGrabStopPercent    or 75
  A.autoGrabSetDelayRadius = (pending and pending.autoGrabSetDelayRadius) or A.autoGrabSetDelayRadius or 8
  A.autoGrabStopEnabled    = true
  _G._AmbitiousSemiStealPending = nil


  A.conn = A.conn
  A.scanThread = A.scanThread
  A.plotSync = A.plotSync or {caches = {}, connections = {}}
  A.animals = A.animals or {}
  A.promptCache = A.promptCache or {}
  A.internalCache = A.internalCache or {}
  A.state = A.state or {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0}

  local function barSet(p, label)
    pcall(function()
      if _G.StealBar then
        _G.StealBar.SetState(label or "STEALING")
        _G.StealBar.SetProgress(math.clamp(tonumber(p) or 0, 0, 1))
      end
    end)
  end

  local function barReset()
    pcall(function()
      if _G.StealBar then _G.StealBar.Reset() end
    end)
  end

  local function rootPart()
    local char = LP.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")) or nil
  end

  local function splitPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for part in string.gmatch(tostring(path), "[^%.]+") do
      table.insert(out, tonumber(part) or part)
    end
    return out
  end

  local function resolvePath(path, root)
    local current, parent, key = root, nil, nil
    for _, part in ipairs(splitPath(path)) do
      parent = current
      key = part
      current = current and current[part] or nil
    end
    return current, parent, key
  end

  local function applySyncDiff(channelName, packet)
    local cache = A.plotSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local current, parent, key = resolvePath(path, cache)
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

  local function attachPlotChannel(remote, plots, requestData)
    if A.plotSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if requestData and A.plotSync.caches[channelName] == nil then
      local ok, data = pcall(function() return requestData:InvokeServer(channelName) end)
      A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
    elseif A.plotSync.caches[channelName] == nil then
      A.plotSync.caches[channelName] = {}
    end
    A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
      for _, packet in ipairs(queue) do applySyncDiff(channelName, packet) end
    end)
  end

  local function ensureSync()
    if A.syncReady then return true end
    local ok = pcall(function()
      local rs = game:GetService("ReplicatedStorage")
      A.packages = rs:WaitForChild("Packages", 10)
      A.datas = rs:WaitForChild("Datas", 10)
      A.plots = workspace:WaitForChild("Plots", 10)
      if not (A.packages and A.datas and A.plots) then return end
      A.animalsData = require(A.datas:WaitForChild("Animals", 10))
      local sync = A.packages:WaitForChild("Synchronizer", 10)
      A.channelFolder = sync:WaitForChild("Channel", 10)
      A.routeRemote = sync:WaitForChild("CommunicationRoute", 10)
      A.requestData = sync:FindFirstChild("RequestData")
      for _, child in ipairs(A.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
      end
      A.channelFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
      end)
      A.routeRemote.OnClientEvent:Connect(function(actions)
        for _, action in ipairs(actions) do
          local kind, channelName = action[1], tostring(action[2])
          if A.plots and A.plots:FindFirstChild(channelName) then
            if kind == "ListenerAdded" then
              local remote = A.channelFolder and A.channelFolder:FindFirstChild(channelName)
              if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote, A.plots, A.requestData) end
            elseif kind == "ListenerRemoved" then
              for remote, conn in pairs(A.plotSync.connections) do
                if tostring(remote.Name) == channelName then
                  pcall(function() conn:Disconnect() end)
                  A.plotSync.connections[remote] = nil
                  A.plotSync.caches[channelName] = nil
                  break
                end
              end
            end
          end
        end
      end)
      A.syncReady = true
    end)
    return ok and A.syncReady == true
  end

  local function getPlotOwner(plot)
    local sign = plot and plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
  end

  local function isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot or not A.plots then return false end
    local plot = A.plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    local owner = getPlotOwner(plot)
    return owner == LP.DisplayName or owner == LP.Name
  end

  local function podiumFor(animalData)
    local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    return podiums and podiums:FindFirstChild(animalData.slot) or nil
  end

  local function animalPos(animalData)
    local podium = podiumFor(animalData)
    return podium and podium:GetPivot().Position or nil
  end

  local function distToAnimal(animalData)
    local root = rootPart()
    local pos = animalPos(animalData)
    return root and pos and (root.Position - pos).Magnitude or math.huge
  end

  local function findPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached = A.promptCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local podium = podiumFor(animalData)
    local base = podium and podium:FindFirstChild("Base")
    local spawn = base and base:FindFirstChild("Spawn")
    local attach = spawn and spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, prompt in ipairs(attach:GetChildren()) do
      if prompt:IsA("ProximityPrompt") then
        A.promptCache[animalData.uid] = prompt
        return prompt
      end
    end
    return nil
  end

  local function scanAllPlots()
    if not ensureSync() then return 0 end
    local newCache = {}
    for _, plot in ipairs(A.plots:GetChildren()) do
      local cache = A.plotSync.caches[plot.Name]
      local animalList = cache and cache.AnimalList
      if typeof(animalList) == "table" then
        for slot, animalData in pairs(animalList) do
          if type(animalData) == "table" then
            local animalName = animalData.Index
            local info = A.animalsData and A.animalsData[animalName]
            if info then
              table.insert(newCache, {
                name = info.DisplayName or animalName,
                plot = plot.Name,
                slot = tostring(slot),
                uid = plot.Name .. "_" .. tostring(slot),
              })
            end
          end
        end
      end
    end
    A.animals = newCache
    return #newCache
  end

  local function pickClosest()
    local root = rootPart()
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(A.animals) do
      if not isMyBaseAnimal(animalData) then
        local pos = animalPos(animalData)
        local dist = pos and (root.Position - pos).Magnitude or math.huge
        if dist <= (A.primeRange or 80) and dist < bestDist then
          best, bestDist = animalData, dist
        end
      end
    end
    return best
  end

  local function buildCallbacks(prompt)
    if A.internalCache[prompt] then return end
    local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
    local okHold, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if okHold and type(holds) == "table" then
      for _, conn in ipairs(holds) do
        if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
      end
    end
    local okTrigger, triggers = pcall(getconnections, prompt.Triggered)
    if okTrigger and type(triggers) == "table" then
      for _, conn in ipairs(triggers) do
        if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
      end
    end
    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then A.internalCache[prompt] = data end
  end

  -- Valori semi steal
  A.autoGrabStopTime       = A.autoGrabStopTime       or 1.29  -- punto in cui la barra si ferma (V1, secondi)
  A.autoGrabStopPercent    = A.autoGrabStopPercent    or 75    -- punto in cui la barra si ferma (V3, percento)
  A.autoGrabSetDelayRadius = A.autoGrabSetDelayRadius or 8     -- raggio trigger del secondo step
  A.autoGrabStopEnabled    = true                              -- sempre attivo
  A.cooldown = A.cooldown or 0.05

  local function executeSemi(prompt, animalData)
    if not prompt or not prompt.Parent or not animalData then return false end
    buildCallbacks(prompt)
    local data = A.internalCache[prompt]
    if not data then
      if type(fireproximityprompt) ~= "function" then return false end
      data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
      A.internalCache[prompt] = data
    end
    if not data.ready then return false end
    data.ready = false
    A.state.active  = true
    A.state.startTime = tick()
    A.state.phase   = "holding"
    A.state.label   = animalData.name or "Animal"

    task.spawn(function()
      local startTime = A.state.startTime
      local duration  = 1.3  -- durata fase hold (secondi)

      -- avvia hold callbacks
      for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end

      -- ====================== MODALITÃ€ STOP-AND-WAIT ======================
      -- Semi V3: identica alla V1, ma lo stop e' una PERCENTUALE della
      -- barra invece che un tempo in secondi. Si converte qui e da questo
      -- punto in poi il codice e' esattamente lo stesso, quindi anche
      -- l'anticipo di 0.05s della barra sul trigger resta identico.
      local stopTime = A.autoGrabStopTime  -- es. 1.29s
      if selectedSemiMode == "V3" then
        local pct = math.clamp(tonumber(A.autoGrabStopPercent) or 75, 1, 100)
        stopTime = duration * (pct / 100)
      end

      -- fase 1: avanza fino a stopTime
      while A.enabled and selectedStealMode == "Semi" do
        local elapsed = tick() - startTime
        if elapsed >= stopTime then break end
        barSet(math.clamp(elapsed / duration, 0, 1), "STEALING")
        local root = rootPart()
        if not root or not prompt.Parent or not prompt.Parent.Parent then break end
        if (root.Position - prompt.Parent.Parent.Position).Magnitude > (tonumber(A.radius) or 60) then break end
        task.wait()
      end

      local stopProgress = math.clamp(stopTime / duration, 0, 1)
      barSet(stopProgress, "STEALING")

      -- fase 2: aspetta entrata nel delayRadius oppure timeout
      -- Budget contato dall'inizio del ciclo: dai 2.99 si tolgono sia il
      -- tempo gia' speso nella fase 1 (stopTime) sia quello che servira'
      -- per completare la barra (1.3 - stopTime).
      -- stopTime e' sempre in secondi (la V3 converte la % prima di qui),
      -- quindi la formula e' identica per V1 e V3.
      local phase2Timeout = math.max(2.99 - stopTime - math.max(duration - stopTime, 0), 0.05)
      local phase2Start = tick()

      while A.enabled and selectedStealMode == "Semi" do
        if tick() - phase2Start >= phase2Timeout then
          -- timeout: reset e riparti subito
          barReset()
          data.ready = true
          A.state.active = false
          A.state.phase  = "idle"
          executeSemi(prompt, animalData)
          return
        end

        if not prompt.Parent or not prompt.Parent.Parent then
          barReset()
          data.ready = true
          A.state.active = false
          A.state.phase  = "idle"
          return
        end

        local root = rootPart()
        if root then
          local dist = (root.Position - prompt.Parent.Parent.Position).Magnitude
          if dist <= (A.autoGrabSetDelayRadius or 8) then
            break  -- entrato nel raggio trigger
          elseif dist > (tonumber(A.radius) or 60) then
            barReset()
            data.ready = true
            A.state.active = false
            A.state.phase  = "idle"
            return
          end
        end
        task.wait()
      end

      -- fase 3: completa la barra da stopProgress a 1 e triggera
      if A.enabled and selectedStealMode == "Semi" then
        -- Costo REALE della fase 3: nessun pavimento a 0.05, altrimenti il
        -- trigger slitta in avanti (con stopTime 1.29 restavano 0.01s ma se
        -- ne pagavano 0.05, quindi lo steal partiva 40ms tardi e il ciclo
        -- sforava la finestra di 2.99s).
        local fillDuration = math.max(duration - stopTime, 0)
        -- I 50ms sono solo l'anticipo VISIVO della barra: vengono presi da
        -- dentro fillDuration, non aggiunti dopo. Se la fase 3 dura meno di
        -- 50ms l'anticipo si accorcia insieme a lei.
        local barLead   = math.min(0.05, fillDuration)
        local fillRamp  = fillDuration - barLead
        local fillStart = tick()
        while true do
          local fp = (fillRamp > 0) and math.clamp((tick() - fillStart) / fillRamp, 0, 1) or 1
          barSet(stopProgress + fp * (1 - stopProgress), "STEALING")
          if fp >= 1 then break end
          task.wait()
        end
        barSet(1, "STEALING")
        if barLead > 0 then task.wait(barLead) end
        local triggered = false
        if #data.triggerCallbacks > 0 then
          for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
          triggered = true
        end
        if not triggered then
          fireStealPrompt(prompt)
        end
        pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
        A.state.lastResult = "Stole " .. tostring(A.state.label)
      else
        A.state.lastResult = "Cancelled"
      end

      -- cleanup: nessun wait extra, ripartenza immediata
      A.state.active         = false
      A.state.phase          = "idle"
      A.state.lastResultTime = tick()
      data.ready = true
      barReset()
    end)
    return true
  end

  -- ---- lista bersagli condivisa con la modalita' Normal ----
  -- La Normal costruiva una lista sua scorrendo i podi: ci finiva DENTRO
  -- ogni podio esistente, pieno o vuoto che fosse. Questa invece nasce
  -- dall'AnimalList del plot, quindi contiene solo gli slot che hanno
  -- davvero un animale sopra. Esposta su _G perche' il blocco della
  -- Normal sta prima di questo nel file e non vede questi local.
  _G.AmbitiousStealAnimals   = function() return A.animals end
  _G.AmbitiousStealAnimalPos = function(d) return animalPos(d) end
  _G.AmbitiousStealIsMyBase  = function(d) return isMyBaseAnimal(d) end

  -- Lo slot ha ANCORA un animale sopra, adesso.
  -- La lista viene ricostruita ogni 5 secondi, quindi da sola non basta:
  -- un animale appena rubato resta in elenco fino al giro dopo, e il
  -- podio esiste comunque (vuoto), quindi anche la posizione risulta
  -- valida. Le cache dei plot sono invece aggiornate dal vivo dai
  -- RemoteEvent del Synchronizer: chiedendo a loro si sa in quell'istante
  -- se lo slot e' occupato.
  _G.AmbitiousStealSlotOccupied = function(d)
    if not d or not d.plot or not d.slot then return false end
    local cache = A.plotSync and A.plotSync.caches and A.plotSync.caches[d.plot]
    local list = cache and cache.AnimalList
    -- Cache non disponibile: non si puo' dire di no, se no con la sync
    -- non pronta la Normal non partirebbe mai.
    if typeof(list) ~= "table" then return true end
    -- Le chiavi possono essere numeri o stringhe a seconda di come
    -- arrivano dal server: si provano entrambe.
    local entry = list[d.slot] or list[tonumber(d.slot) or -1]
    return type(entry) == "table"
  end

  local function ensureScanThread()
    if A.scanThread then return end
    A.scanThread = task.spawn(function()
      while _G.AmbitiousSemiSteal do
        -- Lo scan gira anche per la Normal, che ora legge da qui.
        if A.enabled or selectedStealMode == "Semi"
           or (selectedStealMode == "Normal" and autoStealEnabled) then
          pcall(scanAllPlots)
        end
        task.wait(5)
      end
    end)
  end

  -- Avvio dello scan su richiesta. La Normal ora legge da questa lista,
  -- ma il thread che la riempie partiva SOLO dall'avvio della Semi: senza
  -- aver mai acceso la Semi la lista restava vuota e la Normal non
  -- trovava mai un bersaglio. Da qui la puo' far partire chiunque.
  _G.AmbitiousStealEnsureScan = function()
    ensureScanThread()
    task.spawn(function() pcall(scanAllPlots) end)
  end

  _G.AmbitiousSemiAutoStealSetRadius = function(v)
    local n = tonumber(v)
    if n then A.radius = n end
  end

  _G.AmbitiousSemiAutoStealStop = function()
    A.enabled = false
    if A.conn then A.conn:Disconnect(); A.conn = nil end
    A.state.active = false
    A.state.phase = "idle"
    barReset()
  end

  _G.AmbitiousSemiAutoStealStart = function()
    A.radius = tonumber(autoStealRadius) or A.radius or 60
    A.enabled = true
    ensureSync()
    ensureScanThread()
    pcall(scanAllPlots)
    if A.conn then A.conn:Disconnect(); A.conn = nil end
    A.conn = RunService.Heartbeat:Connect(function()
      if not A.enabled then return end
      if selectedStealMode ~= "Semi" then _G.AmbitiousSemiAutoStealStop(); return end
      if A.state.active then return end
      local target = pickClosest()
      if not target then return end
      local prompt = findPromptForAnimal(target)
      if prompt then executeSemi(prompt, target) end
    end)
  end

  _G.AmbitiousSemiAutoStealSync = function()
    if selectedStealMode == "Semi" and autoStealEnabled then
      _G.AmbitiousSemiAutoStealStart()
    else
      _G.AmbitiousSemiAutoStealStop()
    end
  end
end

_G.__AmbitiousSetupSemiAutoSteal()

-- ===== SEMI V1/V2 ENGINES REMOVED: Semi now uses V3 only =====

_G.AmbitiousAutoStealSync = function()
  if not autoStealEnabled then
    if _G.AmbitiousNormalAutoStealStop then _G.AmbitiousNormalAutoStealStop() end
    if _G.AmbitiousSemiAutoStealStop then _G.AmbitiousSemiAutoStealStop() end
    return
  end
  if selectedStealMode == "Normal" then
    if _G.AmbitiousSemiAutoStealStop then _G.AmbitiousSemiAutoStealStop() end
    if _G.AmbitiousNormalAutoStealSync then _G.AmbitiousNormalAutoStealSync() end
  elseif selectedStealMode == "Semi" then
    if _G.AmbitiousNormalAutoStealStop then _G.AmbitiousNormalAutoStealStop() end
    if _G.AmbitiousSemiAutoStealSync then _G.AmbitiousSemiAutoStealSync() end
  end
end

-- ===== SYNC AFTER HIT =====
-- Al momento esatto del ragdoll (Physics o Ragdoll, FallingDown escluso):
--   1. Ferma il loop steal IMMEDIATAMENTE (disconnette conn, azzera stato interno)
--   2. Aspetta 1.45s (2.45s se medusa)
--   3. Riavvia il loop come se fosse appena stato attivato per la prima volta
-- Un token di generazione garantisce che hit multipli in rapida successione
-- schedulino un solo riavvio (l'ultimo vince).
-- Definita qui (prima di _doSyncAfterHit) per essere catturata come upvalue corretta.
local function _isMedusaHit() return (tick() - (_G._AmbitiousMedusaHitTime or 0)) < 4 end
_G._AmbitiousIsMedusaHit = _isMedusaHit

local function _doSyncAfterHit()
  -- 1) Stop immediato + reset completo stato interno
  if selectedStealMode == "Normal" then
    local a = _G.AmbitiousNormalSteal
    if a then
      a.enabled = false
      a.isStealing = false
      if a.stealConn then pcall(function() a.stealConn:Disconnect() end); a.stealConn = nil end
      -- resetta i ready dei prompt cosÃ¬ il prossimo ciclo riparte pulito
      for _, d in pairs(a.internalCache or {}) do d.ready = true end
      pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
    end
  elseif selectedStealMode == "Semi" then
    if false then
      local B = _G.AmbitiousSemiV2Steal
      if B then
        B.enabled = false
        if B.conn then pcall(function() B.conn:Disconnect() end); B.conn = nil end
        B.state.active = false
        B.state.phase  = "idle"
        for _, d in pairs(B.internalCache or {}) do d.ready = true end
        pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
      end
    else
      local A = _G.AmbitiousSemiSteal
      if A then
        A.enabled = false
        if A.conn then pcall(function() A.conn:Disconnect() end); A.conn = nil end
        A.state.active = false
        A.state.phase  = "idle"
        -- resetta i ready dei prompt
        for _, d in pairs(A.internalCache or {}) do d.ready = true end
        pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
      end
    end
  end

  -- 2) Aspetta poi riavvia (solo se il token non Ã¨ cambiato = nessun altro hit).
  --    Se il ragdoll Ã¨ causato da medusa aspetta 2.45s, altrimenti 1.45s.
  --    _isMedusaHit() controlla se l'Anchored Ã¨ stato visto negli ultimi 4s:
  --    medusa freeze â†’ Anchored â†’ poi Physics/Ragdoll, tutto entro ~4s.
  local myGen = _G._AmbitiousSyncAfterHit.gen
  local syncDelay = _isMedusaHit() and 2.45 or 1.45
  task.delay(syncDelay, function()
    if myGen ~= _G._AmbitiousSyncAfterHit.gen then return end
    _G._AmbitiousSyncAfterHit.wasRagdoll = false
    if _G._AmbitiousSyncAfterHit.enabled and autoStealEnabled then
      if selectedStealMode == "Normal" then
        if _G.AmbitiousNormalAutoStealStart then pcall(_G.AmbitiousNormalAutoStealStart) end
      elseif selectedStealMode == "Semi" then
        if false then
          if _G.AmbitiousSemiV2AutoStealStart then pcall(_G.AmbitiousSemiV2AutoStealStart) end
        else
          if _G.AmbitiousSemiAutoStealStart then pcall(_G.AmbitiousSemiAutoStealStart) end
        end
      end
    end
  end)
end

local function _startSyncAfterHitWatcher()
  if _G._AmbitiousSyncAfterHit.conn then
    pcall(function() _G._AmbitiousSyncAfterHit.conn:Disconnect() end)
    _G._AmbitiousSyncAfterHit.conn = nil
  end
  _G._AmbitiousSyncAfterHit.wasRagdoll = false
  _G._AmbitiousSyncAfterHit.conn = RunService.Heartbeat:Connect(function()
    if not _G._AmbitiousSyncAfterHit.enabled then return end
    if not autoStealEnabled then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local state = hum:GetState()
    -- Solo Physics e Ragdoll; FallingDown escluso intenzionalmente
    local isRagdolled = (state == Enum.HumanoidStateType.Physics or
                         state == Enum.HumanoidStateType.Ragdoll)
    if isRagdolled and not _G._AmbitiousSyncAfterHit.wasRagdoll then
      -- Rising edge: primo frame del ragdoll â†’ agisci subito
      _G._AmbitiousSyncAfterHit.wasRagdoll = true
      _G._AmbitiousSyncAfterHit.gen = _G._AmbitiousSyncAfterHit.gen + 1
      _doSyncAfterHit()
    elseif not isRagdolled then
      _G._AmbitiousSyncAfterHit.wasRagdoll = false
    end
  end)
end

local function _stopSyncAfterHitWatcher()
  if _G._AmbitiousSyncAfterHit.conn then
    pcall(function() _G._AmbitiousSyncAfterHit.conn:Disconnect() end)
    _G._AmbitiousSyncAfterHit.conn = nil
  end
  _G._AmbitiousSyncAfterHit.wasRagdoll = false
end

_startSyncAfterHitWatcher()

-- ===== MEDUSA HIT WATCHER (sempre attivo, indipendente dal ragdoll countdown) =====
-- Flusso medusa: parti diventano Anchored (freeze) â†’ poi si de-anchorano â†’ Physics/Ragdoll.
-- Quando rileva Anchored+Transparency==1 salva il timestamp.
-- _doSyncAfterHit e beginCountdown controllano se il timestamp Ã¨ entro 4s â†’ era medusa.
do
  local _medusaWatcherConns = {}

  local function _clearMedusaWatcher()
    for _, c in ipairs(_medusaWatcherConns) do pcall(function() c:Disconnect() end) end
    _medusaWatcherConns = {}
  end

  local function _hookPart(part)
    if not part:IsA("BasePart") then return end
    local c = part:GetPropertyChangedSignal("Anchored"):Connect(function()
      if part.Anchored and part.Transparency == 1 then
        _G._AmbitiousMedusaHitTime = tick()
      end
    end)
    table.insert(_medusaWatcherConns, c)
  end

  local function _attachMedusaWatcher(char)
    _clearMedusaWatcher()
    _G._AmbitiousMedusaHitTime = 0
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
      _hookPart(part)
    end
    table.insert(_medusaWatcherConns, char.DescendantAdded:Connect(function(part)
      _hookPart(part)
    end))
  end

  if LP.Character then _attachMedusaWatcher(LP.Character) end
  LP.CharacterAdded:Connect(function(char) _G._AmbitiousWaitCharReady(char, 10); _attachMedusaWatcher(char) end)
end
-- ===== FINE MEDUSA HIT WATCHER =====

task.spawn(function()
  while task.wait(30) do
    saveAmbitiousConfig()
  end
end)

local lastMoveDir = Vector3.new(0, 0, 0)

local function getCurrentSpeedValue()
  if currentSpeedMode == "Carry" then
    return CS
  elseif currentSpeedMode == "Lagger" then
    return LAGGER_SPEED
  elseif currentSpeedMode == "Lagger Carry" then
    return LAGGER_CARRY_SPEED
  end
  return NS
end
-- Esposta perche' serve allo ZigZag del TP Down, che sta molto piu' in alto
-- nel file e non puo' vedere questo local.
_G.AmbitiousGetCurrentSpeedValue = getCurrentSpeedValue

local refreshSpeedModeRows = nil

local function setSpeedMode(mode)
  if mode ~= "Normal" and mode ~= "Carry" and mode ~= "Lagger" and mode ~= "Lagger Carry" then
    mode = "Normal"
  end
  -- Blocca switch SOLO quando siamo in lock (speed bassa)
  -- Permette comunque di switchare tra Carry e Lagger Carry
  -- I restore interni dell'auto switch bypassano questo guard
  if not _G._AmbitiousAS.restoring and autoCarrySpeedEnabled and _G._AmbitiousAS.locked then
    if mode ~= "Carry" and mode ~= "Lagger Carry" then return end
  end
  currentSpeedMode = mode
  if refreshSpeedModeRows then
    refreshSpeedModeRows()
  end
  if _G.AmbitiousRefreshMobileButtonStates then _G.AmbitiousRefreshMobileButtonStates() end
  saveAmbitiousConfig()
end

local function toggleCarryMode()
  if autoCarrySpeedEnabled and _G._AmbitiousAS.locked then
    -- Mentre lockati: Q porta sempre a Carry (rimuove il lato lagger)
    setSpeedMode("Carry")
    return
  end
  if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
    setSpeedMode("Carry")
  elseif currentSpeedMode == "Carry" then
    setSpeedMode("Normal")
  else
    setSpeedMode("Carry")
  end
end

local function toggleLaggerMode()
  if autoCarrySpeedEnabled and _G._AmbitiousAS.locked then
    -- Mentre lockati: R porta sempre a Lagger Carry (aggiunge il lato lagger)
    setSpeedMode("Lagger Carry")
    return
  end
  if currentSpeedMode ~= "Lagger" and currentSpeedMode ~= "Lagger Carry" then
    setSpeedMode("Lagger Carry")
  elseif currentSpeedMode == "Lagger Carry" then
    setSpeedMode("Lagger")
  else
    setSpeedMode("Lagger Carry")
  end
end

State = State or {}
State.normalSpeed = NS
State.carrySpeed = CS
State.laggerSpeed = LAGGER_SPEED
State.speedToggled = (currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry")
State.laggerEnabled = (currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry")
toggleRefs = toggleRefs or {}

function setCarry(on)
  if on then
    setSpeedMode("Carry")
  else
    if currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry" then
      setSpeedMode("Normal")
    end
  end
  State.speedToggled = on == true
end

function setLagger(on)
  if on then
    setSpeedMode("Lagger")
  else
    if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
      setSpeedMode("Normal")
    end
  end
  State.laggerEnabled = on == true
end

State = State or {}
State.normalSpeed = State.normalSpeed or 59
State.carrySpeed = State.carrySpeed or 30
State.laggerSpeed = State.laggerSpeed or 60
State.speedToggled = State.speedToggled or false
State.laggerEnabled = State.laggerEnabled or false
State._autoCarryFromSteal = State._autoCarryFromSteal or false
State._autoCarryGraceUntil = State._autoCarryGraceUntil or 0
State._waitingForCarryPickup = State._waitingForCarryPickup or false
State._carryPickupWatchUntil = State._carryPickupWatchUntil or 0
State._autoCarryReturnMode = State._autoCarryReturnMode or nil
toggleRefs = toggleRefs or {}

local function safeSaveConfig()
  if type(saveConfig) == "function" then
    task.spawn(saveConfig)
  end
end

-- ===== NEAREST ANIMAL PER AUTO CARRY SPEED (SOFT) =====
-- Stessa logica di scan usata dall'Auto Steal (Plots > AnimalPodiums > Base > Spawn),
-- esclude la propria base tramite PlotSign.YourBase.
function _G.AmbitiousAutoCarryScanAnimals()
  local S = _G._AmbitiousAutoCarrySoft
  local list = {}
  local plots = workspace:FindFirstChild("Plots")
  if not plots then S.animals = list; return end
  for _, plot in ipairs(plots:GetChildren()) do
    if plot:IsA("Model") then
      local mine = false
      local sign = plot:FindFirstChild("PlotSign")
      local yourBase = sign and sign:FindFirstChild("YourBase")
      if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true then mine = true end
      if not mine then
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
          for _, podium in ipairs(podiums:GetChildren()) do
            if podium:IsA("Model") then
              local base = podium:FindFirstChild("Base")
              local spawn = base and base:FindFirstChild("Spawn")
              if spawn then table.insert(list, spawn.Position) end
            end
          end
        end
      end
    end
  end
  S.animals = list
end

function _G.AmbitiousAutoCarryNearestAnimalDist()
  local S = _G._AmbitiousAutoCarrySoft
  local char = LP.Character
  local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
  if not root then return math.huge end
  local now = tick()
  if (now - (S.lastScan or 0)) >= (S.scanInterval or 2) then
    S.lastScan = now
    pcall(_G.AmbitiousAutoCarryScanAnimals)
  end
  local rp = root.Position
  local bestDist = math.huge
  for _, pos in ipairs(S.animals) do
    local d = (rp - pos).Magnitude
    if d < bestDist then bestDist = d end
  end
  return bestDist
end

function _G.AmbitiousAutoCarryInSoftRadius()
  local S = _G._AmbitiousAutoCarrySoft
  return _G.AmbitiousAutoCarryNearestAnimalDist() <= (tonumber(S.radius) or 9.5)
end
-- ===== FINE NEAREST ANIMAL PER AUTO CARRY SPEED (SOFT) =====

-- ===== AUTO SWITCH TO CARRY =====
local function updateAutoSwitchToCarry()
  if not autoCarrySpeedEnabled then return end
  local char = LP.Character
  if not char then return end
  local h = char:FindFirstChildOfClass("Humanoid")
  if not h then return end
  -- Durante il countdown del duello la walkspeed viene abbassata dal gioco.
  -- Non basta uscire dalla funzione: se il lock era gia' scattato (tipico, perche'
  -- il gioco rallenta prima ancora che compaia il countdown) resterebbe attivo per
  -- tutto il countdown, e con il lock attivo Q/R forzano Carry / Lagger Carry.
  -- Quindi rilasciamo il lock e ripristiniamo la mode salvata: durante il countdown
  -- sei libero di stare su Normal o Lagger senza che nulla ti switchi.
  if _G.AmbitiousSafeModeInDuelCountdown then
    local okCd, inCd = pcall(_G.AmbitiousSafeModeInDuelCountdown)
    if okCd and inCd then
      if _G._AmbitiousAS.locked then
        _G._AmbitiousAS.locked = false
        if _G._AmbitiousAS.savedMode then
          _G._AmbitiousAS.restoring = true
          setSpeedMode(_G._AmbitiousAS.savedMode)
          _G._AmbitiousAS.restoring = false
          _G._AmbitiousAS.savedMode = nil
        end
      end
      -- Azzerato cosi' a fine countdown l'edge-trigger rivaluta da zero:
      -- se la speed e' ancora bassa rilocka, se e' alta resta libero.
      _G._AmbitiousAS.wasLow = false
      return
    end
  end
  local isLow = h.WalkSpeed < 25
  -- SOFT: il lock scatta anche entrando nel raggio di 9.5 stud dall'animale piu' vicino.
  -- Uscendo dal raggio si resta lockati solo se la walkspeed e' sotto 25 (= stai portando),
  -- altrimenti si torna alla mode che era selezionata prima di entrare nel raggio.
  if _G._AmbitiousAutoCarryMode == "SOFT" then
    local inR = false
    local okR, resR = pcall(_G.AmbitiousAutoCarryInSoftRadius)
    if okR then inR = resR and true or false end
    isLow = inR or isLow
  end
  if isLow == _G._AmbitiousAS.wasLow then return end
  _G._AmbitiousAS.wasLow = isLow
  if isLow then
    _G._AmbitiousAS.locked = true
    -- Salva solo se non siamo gia in una carry mode (evita di salvare "Carry" come saved)
    if currentSpeedMode ~= "Carry" and currentSpeedMode ~= "Lagger Carry" then
      _G._AmbitiousAS.savedMode = currentSpeedMode
      if currentSpeedMode == "Lagger" then
        setSpeedMode("Lagger Carry")
      else
        -- Normal (o qualsiasi altra): vai a Carry
        setSpeedMode("Carry")
      end
    end
    -- Gia in Carry o Lagger Carry: non fa nulla, ma il lock e' gia settato
  else
    -- Speed tornata sopra 25 -> UNLOCK poi ripristina la mode precedente
    _G._AmbitiousAS.locked = false
    if _G._AmbitiousAS.savedMode then
      _G._AmbitiousAS.restoring = true
      setSpeedMode(_G._AmbitiousAS.savedMode)
      _G._AmbitiousAS.restoring = false
      _G._AmbitiousAS.savedMode = nil
    end
  end
end

task.spawn(function()
  while true do
    task.wait(_G._AmbitiousAS.interval)
    updateAutoSwitchToCarry()
    if _G.AmbitiousUpdateKickWarning then pcall(_G.AmbitiousUpdateKickWarning) end
  end
end)
-- ===== FINE AUTO SWITCH TO CARRY =====

-- ============================================================
-- ULTIMATE ANTI KICK
-- Quando compare il popup del Kick Warning, se ti trovi vicino a una
-- delle due basi, alza un muro invisibile davanti all'uscita opposta e
-- lo toglie 0.1s prima che il conto alla rovescia finisca.
--
-- Il muro e' una part creata dal client: blocca solo te, che e' proprio
-- lo scopo. Anchored e senza ombra, cosi' non pesa sulla fisica ne' sul
-- rendering; l'unica cosa che fa e' esistere e avere CanCollide.
--
-- Tutto su _G: non aggiunge nemmeno un local al chunk principale.
-- ============================================================
_G.AmbitiousUltimateAntiKick = _G.AmbitiousUltimateAntiKick or {}
_G.AmbitiousUAKEnabled = _G.AmbitiousUAKEnabled == true

_G.AmbitiousUltimateAntiKick.cfg = {
  RADIUS   = 30,    -- quanto vicino devi essere alla base perche' scatti
  LEAD     = 0.1,   -- quanto prima della scadenza il muro sparisce
  HEIGHT   = 40,    -- altezza del muro
  THICK    = 2,     -- spessore
  RISE     = 8,     -- di quanto il centro sta sopra i tuoi piedi
}

-- Ogni zona: "at" e' il punto vicino al quale devi trovarti, "wall" i due
-- estremi del muro da alzare. Le coordinate sono solo X/Z: la Y viene
-- presa dalla tua posizione al momento, cosi' il muro e' sempre alla
-- quota giusta qualunque sia il piano su cui ti trovi.
_G.AmbitiousUltimateAntiKick.zones = {
  { at = {x = -488, z = 24},
    wall = {x1 = -478, z1 = 88, x2 = -422, z2 = 88} },
  { at = {x = -488, z = 95},
    wall = {x1 = -478, z1 = 32, x2 = -422, z2 = 32} },
}

function _G.AmbitiousUltimateAntiKick.clear()
  local w = workspace:FindFirstChild("AmbitiousAntiKickWall")
  while w do
    pcall(function() w:Destroy() end)
    w = workspace:FindFirstChild("AmbitiousAntiKickWall")
  end
end

-- Zona in cui ti trovi, o nil. La distanza si misura solo su X/Z: la Y
-- non deve contare, se no stando su una rampa o saltando la zona non
-- verrebbe riconosciuta.
function _G.AmbitiousUltimateAntiKick.zoneFor(pos)
  local U = _G.AmbitiousUltimateAntiKick
  for _, z in ipairs(U.zones) do
    local dx = pos.X - z.at.x
    local dz = pos.Z - z.at.z
    if math.sqrt(dx * dx + dz * dz) <= U.cfg.RADIUS then
      return z
    end
  end
  return nil
end

-- Chiamata dal Kick Warning nel momento in cui il popup appare.
-- duration = quanto dura il conto alla rovescia, per sapere quando
-- togliere il muro.
function _G.AmbitiousUltimateAntiKick.onWarning(duration)
  -- Serve che siano accesi TUTTI E DUE: il muro e' una reazione al popup
  -- del Kick Warning, senza quello non ha nemmeno un momento in cui
  -- alzarsi. Il controllo sta qui e non solo nella UI, cosi' vale anche
  -- se lo stato viene cambiato da config o da codice.
  if _G.AmbitiousUAKEnabled ~= true then return end
  if not (_G._AmbitiousKickWarn and _G._AmbitiousKickWarn.enabled == true) then return end
  local U = _G.AmbitiousUltimateAntiKick
  local char = LP.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  if not hrp then return end

  local zone = U.zoneFor(hrp.Position)
  if not zone then return end

  U.clear()

  local w = zone.wall
  local mx = (w.x1 + w.x2) / 2
  local mz = (w.z1 + w.z2) / 2
  local dx = w.x2 - w.x1
  local dz = w.z2 - w.z1
  local length = math.sqrt(dx * dx + dz * dz)
  if length < 0.1 then return end

  local part = Instance.new("Part")
  part.Name        = "AmbitiousAntiKickWall"
  part.Anchored    = true
  part.CanCollide  = true
  part.CanQuery    = false   -- non deve intercettare i raycast del hub
  part.CanTouch    = false
  part.CastShadow  = false
  part.Transparency = 1
  part.Size = Vector3.new(length, U.cfg.HEIGHT, U.cfg.THICK)
  -- CFrame.lookAt allinea la faccia lunga lungo la congiungente dei due
  -- punti, quindi il muro copre esattamente il tratto indicato anche se
  -- un domani i due estremi non fossero piu' allineati sull'asse X.
  local a = Vector3.new(w.x1, hrp.Position.Y + U.cfg.RISE, w.z1)
  local b = Vector3.new(w.x2, hrp.Position.Y + U.cfg.RISE, w.z2)
  local mid = Vector3.new(mx, hrp.Position.Y + U.cfg.RISE, mz)
  part.CFrame = CFrame.lookAt(mid, b) * CFrame.Angles(0, math.rad(90), 0)
  part.Parent = workspace

  -- Rimozione programmata. Il token evita che un vecchio timer cancelli
  -- il muro di un avviso successivo.
  U.token = (U.token or 0) + 1
  local myToken = U.token
  local wait_s = math.max((tonumber(duration) or 2.35) - U.cfg.LEAD, 0.05)
  task.delay(wait_s, function()
    if U.token ~= myToken then return end
    U.clear()
  end)
end

-- ===== KICK WARNING (DONT COLLECT / COLLECT NOW) =====
function _G.AmbitiousDestroyKickWarning()
  local KW = _G._AmbitiousKickWarn
  KW.gen = (KW.gen or 0) + 1
  KW.active = false
  local g = HubGui:FindFirstChild("AmbitiousHubKickWarning")
  if g then pcall(function() g:Destroy() end) end
  -- Popup distrutto a mano: il muro non deve restare in piedi.
  if _G.AmbitiousUltimateAntiKick then pcall(_G.AmbitiousUltimateAntiKick.clear) end
end

function _G.AmbitiousShowKickWarning()
  local KW = _G._AmbitiousKickWarn
  if KW.active then return end
  if HubGui:FindFirstChild("AmbitiousHubKickWarning") then return end
  -- Doppio check: non mostrare il popup durante il countdown del duello
  if _G.AmbitiousSafeModeInDuelCountdown then
    local okCd, inCd = pcall(_G.AmbitiousSafeModeInDuelCountdown)
    if okCd and inCd then return end
  end
  -- Il Kick Warning ha la precedenza: se c'e' un Ping Warning a schermo
  -- gli si fa fare un'uscita rapida e il rosso entra appena e' sparito.
  -- Il conto alla rovescia del kick parte comunque SUBITO: quando entra
  -- e' gia' a tempo, non riparte da zero.
  local KW_ENTER_DELAY = 0
  do
    local pw = HubGui:FindFirstChild("AmbitiousHubPingWarning")
    if pw then
      local pwFrame = pw:FindFirstChild("WarningFrame")
      KW_ENTER_DELAY = 0.12
      pcall(function()
        TweenService:Create(pwFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
          Position = UDim2.new(0.5, -210, 0, -60)
        }):Play()
      end)
      task.delay(0.13, function() pcall(function() pw:Destroy() end) end)
    end
  end

  KW.active = true
  KW.gen = (KW.gen or 0) + 1
  local myGen = KW.gen

  local FRAME_W, FRAME_H = 420, 52
  local DURATION = 2.35
  -- >>> ULTIMATE ANTI KICK <<< il muro si alza adesso, nello stesso
  -- istante in cui parte il conto alla rovescia, e viene tolto da solo
  -- 0.1s prima della scadenza.
  if _G.AmbitiousUltimateAntiKick then
    pcall(_G.AmbitiousUltimateAntiKick.onWarning, DURATION)
  end
  local COL_RED   = Color3.fromRGB(255, 220, 70)
  local COL_GREEN = Color3.fromRGB(255, 220, 70)

  local gui = Instance.new("ScreenGui")
  gui.Name = "AmbitiousHubKickWarning"
  gui.ResetOnSpawn = false
  gui.IgnoreGuiInset = true
  gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  gui.DisplayOrder = 99999
  gui.Parent = HubGui

  -- frame rosso: ZIndex 1, ClipsDescendants=true maschera il fill agli angoli
  local frame = Instance.new("Frame")
  frame.Name = "WarningFrame"
  frame.Size = UDim2.new(0, FRAME_W, 0, FRAME_H)
  frame.Position = UDim2.new(0.5, -FRAME_W/2, 0, -60)
  frame.BackgroundColor3 = COL_RED
  frame.BackgroundTransparency = 0
  frame.BorderSizePixel = 0
  frame.ClipsDescendants = true
  frame.ZIndex = 1
  frame.Parent = gui
  Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

  -- fillFrame verde: ZIndex 2, figlio di frame, mascherato agli angoli da ClipsDescendants
  local fillFrame = Instance.new("Frame")
  fillFrame.Name = "FillFrame"
  fillFrame.Size = UDim2.new(0, 0, 1, 0)
  fillFrame.Position = UDim2.new(0, 0, 0, 0)
  fillFrame.BackgroundColor3 = COL_GREEN
  fillFrame.BackgroundTransparency = 0
  fillFrame.BorderSizePixel = 0
  fillFrame.ZIndex = 2
  fillFrame.Parent = frame
  Instance.new("UICorner", fillFrame).CornerRadius = UDim.new(0, 12)

  -- warnText: ZIndex 3, sempre sopra al fill verde
  local warnText = Instance.new("TextLabel")
  warnText.Name = "WarningText"
  warnText.Size = UDim2.new(1, -24, 1, 0)
  warnText.Position = UDim2.new(0, 12, 0, 0)
  warnText.BackgroundTransparency = 1
  warnText.Text = "âš ï¸ DONT COLLECT âš ï¸"
  warnText.TextColor3 = Color3.fromRGB(255, 255, 255)
  warnText.Font = Enum.Font.GothamBlack
  warnText.TextSize = 16
  warnText.TextXAlignment = Enum.TextXAlignment.Center
  warnText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  warnText.TextStrokeTransparency = 0.25
  warnText.ZIndex = 3
  warnText.Parent = frame

  -- Slide in: ritardato solo se deve aspettare l'uscita del ping warning.
  -- L'animazione del riempimento parte comunque subito, quindi il popup
  -- entra gia' al punto giusto invece di ricominciare.
  local function slideIn()
    if KW.gen ~= myGen or not gui.Parent then return end
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
      Position = UDim2.new(0.5, -FRAME_W/2, 0, 18)
    }):Play()
  end
  if KW_ENTER_DELAY > 0 then
    task.delay(KW_ENTER_DELAY, slideIn)
  else
    slideIn()
  end

  local function stillLow()
    if _G.AmbitiousSafeModeInDuelCountdown then
      local okCd, inCd = pcall(_G.AmbitiousSafeModeInDuelCountdown)
      if okCd and inCd then return false end
    end
    local c = LP.Character
    local hh = c and c:FindFirstChildOfClass("Humanoid")
    if not hh then return false end
    return hh.WalkSpeed < 25
  end

local function closeKW()
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -FRAME_W/2, 0, -60)
        -- Niente BackgroundTransparency
    }):Play()
    -- Rimuovi i tween su warnText e fillFrame
    task.wait(0.35)
    pcall(function() gui:Destroy() end)
    KW.active = false
    -- Chiusura anticipata (walkspeed risalita): via il muro.
    if _G.AmbitiousUltimateAntiKick then pcall(_G.AmbitiousUltimateAntiKick.clear) end
end

  task.spawn(function()
    local t0 = tick()
    -- Fase 1: fill da 0 a FRAME_W in DURATION secondi esatti
    while true do
      if KW.gen ~= myGen or not gui.Parent then KW.active = false; return end
      if not stillLow() then closeKW(); return end
      local elapsed = tick() - t0
      local p = math.clamp(elapsed / DURATION, 0, 1)
      fillFrame.Size = UDim2.new(0, math.floor(p * FRAME_W), 1, 0)
      if p >= 1 then break end
      RunService.Heartbeat:Wait()
    end

    if KW.gen ~= myGen or not gui.Parent then KW.active = false; return end

    -- Fase 2: testo cambia
    warnText.Text = "âœ”ï¸ COLLECT NOW âœ”ï¸"

    -- Fase 3: resta finche walkspeed non risale
    while true do
      if KW.gen ~= myGen or not gui.Parent then KW.active = false; return end
      if not stillLow() then break end
      task.wait(0.05)
    end

    if KW.gen ~= myGen or not gui.Parent then KW.active = false; return end
    closeKW()
  end)
end

-- Stesso check dell'Auto Switch To Carry: walkspeed sotto 25 (edge-triggered)
function _G.AmbitiousUpdateKickWarning()
  local KW = _G._AmbitiousKickWarn
  local char = LP.Character
  local h = char and char:FindFirstChildOfClass("Humanoid")
  if not h then return end
  -- Durante il countdown del duello la walkspeed viene abbassata dal gioco:
  -- ignora completamente il check e distruggi il popup se fosse aperto.
  if _G.AmbitiousSafeModeInDuelCountdown then
    local okCd, inCd = pcall(_G.AmbitiousSafeModeInDuelCountdown)
    if okCd and inCd then
      -- Siamo nel countdown: chiudi il popup se aperto e resetta wasLow
      if KW.active then pcall(_G.AmbitiousDestroyKickWarning) end
      KW.wasLow = false  -- resettiamo cosi' al termine del countdown riparte da zero
      return
    end
  end
  local isLow = h.WalkSpeed < 25
  if not KW.enabled then
    KW.wasLow = isLow
    return
  end
  if isLow == KW.wasLow then return end
  KW.wasLow = isLow
  if isLow then
    _G.AmbitiousShowKickWarning()
  end
end
-- ===== FINE KICK WARNING =====


-- ============================================================
-- PATHFINDING
-- Due strategie diverse, perche' i due casi d'uso sono diversi.
--
-- AUTO LEFT / AUTO RIGHT vanno verso punti FISSI e conosciuti: li' si
-- puo' usare il PathfindingService vero, che restituisce dei waypoint
-- che rispettano la geometria camminabile. ComputeAsync pero' cede il
-- controllo (yield) e costa parecchio, quindi non puo' girare dentro un
-- Heartbeat: il calcolo va in un task a parte e il loop legge il
-- risultato quando e' pronto. Nel frattempo si continua ad andare
-- diretti, esattamente come prima.
--
-- I BAT AIMBOT inseguono un bersaglio che si muove: ricalcolare un
-- percorso a ogni spostamento introdurrebbe un ritardo che
-- sull'inseguimento si sente subito. Li' si usa invece un evitamento a
-- raggi, che costa pochissimo e risponde nello stesso frame: si guarda
-- avanti, e se c'e' un muro si sterza dell'angolo minimo che libera la
-- strada.
--
-- Tutto sotto _G per non aggiungere local al chunk principale, che e'
-- al limite dei 200 registri di Luau.
-- ============================================================
_G.AmbitiousPathfind = _G.AmbitiousPathfind or {}

_G.AmbitiousPathfind.cfg = {
  PROBE      = 14,    -- quanto avanti si guarda per gli aimbot (studs)
  ANGLES     = {18, 36, 54, 72, 90},  -- sterzate provate, in ordine
  WALL_Y     = 0.6,   -- sopra questo la superficie e' una rampa, non un muro
  WP_REACH   = 4,     -- quando un waypoint si considera raggiunto
  RECOMPUTE  = 1.25,  -- ogni quanto al massimo si ricalcola un percorso
  GOAL_DRIFT = 6,     -- se la meta si sposta di piu', si ricalcola subito
}

-- Parametri del raycast: si ignorano il proprio personaggio e quelli
-- degli altri giocatori. Gli altri player NON sono ostacoli da aggirare:
-- l'aimbot ci deve andare addosso, sterzare per evitarli sarebbe
-- esattamente il contrario di quello che serve.
function _G.AmbitiousPathfind.rayParams()
  local params = RaycastParams.new()
  local ignore = {}
  local ch = LP.Character
  if ch then ignore[#ignore + 1] = ch end
  for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LP and plr.Character then ignore[#ignore + 1] = plr.Character end
  end
  params.FilterDescendantsInstances = ignore
  params.FilterType = Enum.RaycastFilterType.Exclude
  params.IgnoreWater = true
  return params
end

-- true se in quella direzione, entro dist, c'e' qualcosa che blocca
-- davvero il passaggio. Una rampa o un gradino non bloccano: ci si
-- cammina sopra, e sterzare per evitarli farebbe girare a vuoto.
function _G.AmbitiousPathfind.blocked(origin, dir, dist, params)
  local res = workspace:Raycast(origin, dir * dist, params)
  if not res then return false end
  if math.abs(res.Normal.Y) > _G.AmbitiousPathfind.cfg.WALL_Y then return false end
  return true
end

-- Sterzata minima che libera la strada.
-- Si prova prima l'angolo piu' piccolo, e per ogni angolo entrambi i
-- lati: cosi' la deviazione resta la minore possibile e non si prende
-- il giro largo quando ne basta uno stretto. Se nessuna sterzata libera
-- (vicolo cieco) si tiene la direzione originale, che e' meglio di
-- fermarsi: la fisica ci fa comunque strisciare lungo il muro.
function _G.AmbitiousPathfind.steer(origin, dir, dist)
  if dir.Magnitude < 0.01 then return dir end
  dir = dir.Unit
  local C = _G.AmbitiousPathfind.cfg
  dist = dist or C.PROBE
  local params = _G.AmbitiousPathfind.rayParams()

  -- Due altezze: una all'altezza del torso e una piu' bassa, se no i
  -- muretti bassi passano sotto al raggio e non vengono visti.
  local low = origin - Vector3.new(0, 2, 0)
  if not _G.AmbitiousPathfind.blocked(origin, dir, dist, params)
     and not _G.AmbitiousPathfind.blocked(low, dir, dist, params) then
    return dir
  end

  for _, deg in ipairs(C.ANGLES) do
    for _, sign in ipairs({1, -1}) do
      local rot = CFrame.Angles(0, math.rad(deg * sign), 0)
      local cand = rot:VectorToWorldSpace(dir)
      cand = Vector3.new(cand.X, 0, cand.Z)
      if cand.Magnitude > 0.01 then
        cand = cand.Unit
        if not _G.AmbitiousPathfind.blocked(origin, cand, dist, params)
           and not _G.AmbitiousPathfind.blocked(low, cand, dist, params) then
          return cand
        end
      end
    end
  end
  return dir
end

-- ---------- percorsi veri, per Auto Left / Auto Right ----------
_G.AmbitiousPathfind.paths = _G.AmbitiousPathfind.paths or {}

function _G.AmbitiousPathfind.reset(key)
  _G.AmbitiousPathfind.paths[key] = nil
end

-- Ritorna la direzione verso il prossimo waypoint, oppure nil se un
-- percorso non c'e' (ancora, o proprio non calcolabile). Chi chiama in
-- quel caso va diretto: il pathfinding aggiunge, non sostituisce.
-- opts (facoltativo): { recompute = secondi, drift = studs }
-- Serve per i bersagli in MOVIMENTO. Con i punti fissi di Auto Left/Right
-- un ricalcolo ogni 1.25s va benissimo; dietro a un giocatore che corre
-- quel percorso e' vecchio dopo pochi metri, quindi chi insegue passa
-- valori piu' stretti.
function _G.AmbitiousPathfind.dirTo(key, from, goal, opts)
  local C = _G.AmbitiousPathfind.cfg
  local st = _G.AmbitiousPathfind.paths[key]
  local now = os.clock()
  local recompute = (opts and tonumber(opts.recompute)) or C.RECOMPUTE
  local drift     = (opts and tonumber(opts.drift))     or C.GOAL_DRIFT

  if st and st.goal and (st.goal - goal).Magnitude > drift then
    st = nil
  end

  if not st then
    st = {goal = goal, wp = nil, i = 1, computing = false, last = 0}
    _G.AmbitiousPathfind.paths[key] = st
  end

  -- Calcolo in un task a parte: ComputeAsync cede il controllo e dentro
  -- un Heartbeat bloccherebbe il frame.
  if not st.computing and (not st.wp or (now - st.last) > recompute) then
    st.computing = true
    st.last = now
    st.goal = goal
    local origin = from
    task.spawn(function()
      local ok, path = pcall(function()
        -- Servizio preso al volo e messo in cache: dichiararlo come local
        -- in cima al file costerebbe un registro al chunk principale, che
        -- e' gia' al limite.
        _G.AmbitiousPathfind.svc = _G.AmbitiousPathfind.svc
          or game:GetService("PathfindingService")
        local p = _G.AmbitiousPathfind.svc:CreatePath({
          AgentRadius = 2.5,
          AgentHeight = 5,
          AgentCanJump = true,
          WaypointSpacing = 6,
        })
        p:ComputeAsync(origin, goal)
        return p
      end)
      local cur = _G.AmbitiousPathfind.paths[key]
      if cur ~= st then return end   -- nel frattempo la meta e' cambiata
      st.computing = false
      if ok and path and path.Status == Enum.PathStatus.Success then
        local pts = path:GetWaypoints()
        -- Il primo waypoint e' sempre il punto di partenza: inutile.
        st.wp = pts
        st.i = math.min(2, #pts)
      else
        st.wp = nil   -- si torna alla linea diretta
      end
    end)
  end

  local wp = st.wp
  if not wp or #wp == 0 then return nil end

  -- Avanzamento: si salta al waypoint successivo quando quello corrente
  -- e' stato raggiunto. Il confronto e' solo su X/Z perche' la Y di un
  -- waypoint sta a terra e la nostra e' all'altezza del torso.
  while st.i <= #wp do
    local p = wp[st.i].Position
    local d = Vector3.new(p.X - from.X, 0, p.Z - from.Z)
    if d.Magnitude > C.WP_REACH then
      if d.Magnitude < 0.01 then return nil end
      return d.Unit
    end
    st.i = st.i + 1
  end

  -- Waypoint finiti: si e' arrivati, da qui in poi linea diretta.
  return nil
end

_G.AmbitiousAutoPathState = _G.AmbitiousAutoPathState or {leftConn=nil,rightConn=nil,leftPhase=1,rightPhase=1}
_G.AmbitiousAutoPathPoints = _G.AmbitiousAutoPathPoints or {
  L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), LFace=Vector3.new(-482.25,-4.96,92.09),
  R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), RFace=Vector3.new(-482.06,-6.93,35.47),
}

function _G.AmbitiousAutoPathSpeed()
  if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
    return LAGGER_SPEED
  end
  return NS
end

function _G.AmbitiousStopAutoLeft()
  local S = _G.AmbitiousAutoPathState
  if S.leftConn then S.leftConn:Disconnect(); S.leftConn = nil end
  S.leftPhase = 1
  -- Percorsi buttati: alla prossima accensione si riparte dalla posizione
  -- di allora, non da waypoint calcolati chissa' dove.
  if _G.AmbitiousPathfind then
    _G.AmbitiousPathfind.reset("L1"); _G.AmbitiousPathfind.reset("L2")
  end
  local char = LP.Character
  local hum = char and char:FindFirstChildOfClass("Humanoid")
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  if hum then hum:Move(Vector3.zero, false) end
  if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0) end
end

function _G.AmbitiousStopAutoRight()
  local S = _G.AmbitiousAutoPathState
  if S.rightConn then S.rightConn:Disconnect(); S.rightConn = nil end
  S.rightPhase = 1
  if _G.AmbitiousPathfind then
    _G.AmbitiousPathfind.reset("R1"); _G.AmbitiousPathfind.reset("R2")
  end
  local char = LP.Character
  local hum = char and char:FindFirstChildOfClass("Humanoid")
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  if hum then hum:Move(Vector3.zero, false) end
  if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0) end
end

function _G.AmbitiousSetAutoLeft(on, skipSave)
  if on and _G.AmbitiousSafeModeTryStart and not _G.AmbitiousSafeModeTryStart() then
    autoLeftEnabled = false
    if _G.AmbitiousSetAutoLeftVisual then _G.AmbitiousSetAutoLeftVisual(false) end
    if _G.AmbitiousRefreshMobileButtonStates then _G.AmbitiousRefreshMobileButtonStates() end
    if not skipSave then saveAmbitiousConfig() end
    return false
  end
  autoLeftEnabled = on and true or false
  if _G.AmbitiousSetAutoLeftVisual then _G.AmbitiousSetAutoLeftVisual(autoLeftEnabled) end
  if autoLeftEnabled then
    autoRightEnabled = false
    if _G.AmbitiousSetAutoRightVisual then _G.AmbitiousSetAutoRightVisual(false) end
    if _G.AmbitiousStopAutoRight then _G.AmbitiousStopAutoRight() end
    if _G.AmbitiousStartAutoLeft then _G.AmbitiousStartAutoLeft() end
  else
    if _G.AmbitiousStopAutoLeft then _G.AmbitiousStopAutoLeft() end
  end
  if _G.AmbitiousRefreshMobileButtonStates then _G.AmbitiousRefreshMobileButtonStates() end
  if not skipSave then saveAmbitiousConfig() end
end

function _G.AmbitiousSetAutoRight(on, skipSave)
  if on and _G.AmbitiousSafeModeTryStart and not _G.AmbitiousSafeModeTryStart() then
    autoRightEnabled = false
    if _G.AmbitiousSetAutoRightVisual then _G.AmbitiousSetAutoRightVisual(false) end
    if _G.AmbitiousRefreshMobileButtonStates then _G.AmbitiousRefreshMobileButtonStates() end
    if not skipSave then saveAmbitiousConfig() end
    return false
  end
  autoRightEnabled = on and true or false
  if _G.AmbitiousSetAutoRightVisual then _G.AmbitiousSetAutoRightVisual(autoRightEnabled) end
  if autoRightEnabled then
    autoLeftEnabled = false
    if _G.AmbitiousSetAutoLeftVisual then _G.AmbitiousSetAutoLeftVisual(false) end
    if _G.AmbitiousStopAutoLeft then _G.AmbitiousStopAutoLeft() end
    if _G.AmbitiousStartAutoRight then _G.AmbitiousStartAutoRight() end
  else
    if _G.AmbitiousStopAutoRight then _G.AmbitiousStopAutoRight() end
  end
  if _G.AmbitiousRefreshMobileButtonStates then _G.AmbitiousRefreshMobileButtonStates() end
  if not skipSave then saveAmbitiousConfig() end
end

function _G.AmbitiousStartAutoLeft()
  local S = _G.AmbitiousAutoPathState
  if S.leftConn then S.leftConn:Disconnect() end
  S.leftPhase = 1
  S.leftConn = RunService.Heartbeat:Connect(function()
    if not autoLeftEnabled then return end
    local char = LP.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local st = hum:GetState()
    if hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll then
      hum:Move(Vector3.zero, false)
      if _G.AmbitiousSetAutoLeft then _G.AmbitiousSetAutoLeft(false) end
      return
    end
    local P = _G.AmbitiousAutoPathPoints
    local spd = _G.AmbitiousAutoPathSpeed()
    if S.leftPhase == 1 then
      local tgt = Vector3.new(P.L1.X, hrp.Position.Y, P.L1.Z)
      if (tgt - hrp.Position).Magnitude < 1 then
        S.leftPhase = 2
        -- >>> PATHFINDING <<< cambio di meta': il percorso vecchio non
        -- serve piu', si butta cosi' il prossimo parte pulito.
        if _G.AmbitiousPathfind then _G.AmbitiousPathfind.reset("L1") end
        local d = P.L2 - hrp.Position
        local mv = Vector3.new(d.X, 0, d.Z).Unit
        hum:Move(mv, false)
        hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        return
      end
      local d = P.L1 - hrp.Position
      local mv = Vector3.new(d.X, 0, d.Z).Unit
      -- >>> PATHFINDING <<< se un percorso c'e' si segue il waypoint, se
      -- no (calcolo non ancora pronto, o punto irraggiungibile) si va
      -- diretti come si e' sempre fatto.
      if _G.AmbitiousPathfind then
        local pd = _G.AmbitiousPathfind.dirTo("L1", hrp.Position, P.L1)
        if pd then mv = pd end
      end
      hum:Move(mv, false)
      hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
    elseif S.leftPhase == 2 then
      local tgt = Vector3.new(P.L2.X, hrp.Position.Y, P.L2.Z)
      if (tgt - hrp.Position).Magnitude < 1 then
        hum:Move(Vector3.zero, false)
        hrp.AssemblyLinearVelocity = Vector3.zero
        autoLeftEnabled = false
        if S.leftConn then S.leftConn:Disconnect(); S.leftConn = nil end
        S.leftPhase = 1
        if _G.AmbitiousSetAutoLeftVisual then _G.AmbitiousSetAutoLeftVisual(false) end
        if _G.AmbitiousRefreshMobileButtonStates then _G.AmbitiousRefreshMobileButtonStates() end
        if P.LFace and (P.LFace - hrp.Position).Magnitude > 0.01 then
          hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(P.LFace.X, hrp.Position.Y, P.LFace.Z))
        end
        saveAmbitiousConfig()
        return
      end
      local d = P.L2 - hrp.Position
      local mv = Vector3.new(d.X, 0, d.Z).Unit
      if _G.AmbitiousPathfind then
        local pd = _G.AmbitiousPathfind.dirTo("L2", hrp.Position, P.L2)
        if pd then mv = pd end
      end
      hum:Move(mv, false)
      hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
    end
  end)
end

function _G.AmbitiousStartAutoRight()
  local S = _G.AmbitiousAutoPathState
  if S.rightConn then S.rightConn:Disconnect() end
  S.rightPhase = 1
  S.rightConn = RunService.Heartbeat:Connect(function()
    if not autoRightEnabled then return end
    local char = LP.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local st = hum:GetState()
    if hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll then
      hum:Move(Vector3.zero, false)
      if _G.AmbitiousSetAutoRight then _G.AmbitiousSetAutoRight(false) end
      return
    end
    local P = _G.AmbitiousAutoPathPoints
    local spd = _G.AmbitiousAutoPathSpeed()
    if S.rightPhase == 1 then
      local tgt = Vector3.new(P.R1.X, hrp.Position.Y, P.R1.Z)
      if (tgt - hrp.Position).Magnitude < 1 then
        S.rightPhase = 2
        -- >>> PATHFINDING <<< cambio di meta': via il percorso vecchio.
        if _G.AmbitiousPathfind then _G.AmbitiousPathfind.reset("R1") end
        local d = P.R2 - hrp.Position
        local mv = Vector3.new(d.X, 0, d.Z).Unit
        hum:Move(mv, false)
        hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        return
      end
      local d = P.R1 - hrp.Position
      local mv = Vector3.new(d.X, 0, d.Z).Unit
      -- >>> PATHFINDING <<< waypoint se disponibile, altrimenti diretto.
      if _G.AmbitiousPathfind then
        local pd = _G.AmbitiousPathfind.dirTo("R1", hrp.Position, P.R1)
        if pd then mv = pd end
      end
      hum:Move(mv, false)
      hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
    elseif S.rightPhase == 2 then
      local tgt = Vector3.new(P.R2.X, hrp.Position.Y, P.R2.Z)
      if (tgt - hrp.Position).Magnitude < 1 then
        hum:Move(Vector3.zero, false)
        hrp.AssemblyLinearVelocity = Vector3.zero
        autoRightEnabled = false
        if S.rightConn then S.rightConn:Disconnect(); S.rightConn = nil end
        S.rightPhase = 1
        if _G.AmbitiousSetAutoRightVisual then _G.AmbitiousSetAutoRightVisual(false) end
        if _G.AmbitiousRefreshMobileButtonStates then _G.AmbitiousRefreshMobileButtonStates() end
        if P.RFace and (P.RFace - hrp.Position).Magnitude > 0.01 then
          hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(P.RFace.X, hrp.Position.Y, P.RFace.Z))
        end
        saveAmbitiousConfig()
        return
      end
      local d = P.R2 - hrp.Position
      local mv = Vector3.new(d.X, 0, d.Z).Unit
      if _G.AmbitiousPathfind then
        local pd = _G.AmbitiousPathfind.dirTo("R2", hrp.Position, P.R2)
        if pd then mv = pd end
      end
      hum:Move(mv, false)
      hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
    end
  end)
end

-- ============================================================
-- AUTO PLAY
-- Un solo comando al posto di Auto Left e Auto Right. La direzione non la
-- scegli tu: la decide DOVE SEI quando parte il primo duello. Da quel
-- momento Auto Play e' a tutti gli effetti il pulsante di quella
-- direzione â€” si accende, si spegne e si comporta esattamente come
-- l'Auto Right (o l'Auto Left) di sempre, e ad accenderlo sei sempre tu.
-- La rilevazione serve solo a capire QUALE dei due sei, e si fa una volta
-- per tutte.
--
-- IL SEGNALE. Il timer del duello, quello che la Safe Mode gia' guarda e
-- che l'Auto Carry Speed usa per non toccare la velocita' durante il
-- conto alla rovescia, e se ne legge il NUMERO. Dal 2 in giu' si comincia
-- a guardare dove sei e si prende il primo istante in cui sei davvero su
-- una base; prima si e' ancora per strada. Fuori dal countdown non si
-- guarda affatto, perche' passare di li' in un momento qualsiasi non vuol
-- dire nulla.
--
-- LE ZONE si confrontano su X e Z soltanto. La Y cambia con il piano su
-- cui ti trovi, e includerla vorrebbe dire non riconoscere piu' la base
-- appena salti o sali su una rampa.
--
-- RILEVARE NON E' AVVIARE. Il countdown serve solo a capire da che parte
-- sei: finita la rilevazione non parte niente e Auto Play resta spento.
-- Proprio per questo l'ascolto non va acceso a mano â€” gira da solo
-- dall'avvio dello script. Chiedere una pressione per abilitare un
-- ascoltatore che non agisce sarebbe un passaggio in piu' senza motivo, e
-- per giunta facile da dimenticare proprio prima del duello.
--
-- IL RICORDO DEL SERVER. Se ti buttano fuori e rientri NELLO STESSO
-- server, un secondo duello di apertura non c'e' piu': il countdown non
-- ricomparira', e senza un appiglio Auto Play resterebbe muto per tutta
-- la sessione. Per questo il lato rilevato viene salvato insieme al JobId
-- del server; al rientro, se il JobId coincide, la rilevazione si salta e
-- si riprende il lato di prima (solo il lato: Auto Play resta spento e
-- lo accendi tu). Il JobId e' proprio l'identita' di
-- quella partita: cambiare server significa JobId diverso, quindi nessun
-- ricordo e si ricomincia da capo, che e' il comportamento giusto.
-- Tutto questo vale SOLO nel posto di gioco previsto: altrove non si
-- salva e non si ricorda niente, perche' quelle due coordinate li' non
-- vogliono dire nulla.
--
-- Tutto su _G: zero local aggiunti al chunk principale.
-- ============================================================
_G.AmbitiousAutoPlay = _G.AmbitiousAutoPlay or {}

_G.AmbitiousAutoPlay.cfg = {
  RADIUS = 10,
  -- Da quale numero del conto alla rovescia in giu' si comincia a
  -- guardare dove sei. Prima si e' ancora per strada, e una posizione
  -- letta li' e' una posizione di passaggio.
  AT     = 2,
  LEFT   = {x = -466.48, z = 6.65},
  RIGHT  = {x = -466.90, z = 113.56},
  WAIT   = 25,               -- tetto all'attesa della fine del countdown
  PLACE  = 99606176102979,   -- solo qui si salva e ci si ricorda
}

-- Si riparte da spento e senza lato, anche rieseguendo lo script nella
-- stessa sessione: _G sopravvive, e un watcher vecchio resterebbe appeso
-- qui dentro. Il lato non va perso pero': lo rimette restore() leggendo
-- il salvataggio, che e' la stessa strada del rientro dopo un kick.
if _G.AmbitiousAutoPlay.conn then
  pcall(function() _G.AmbitiousAutoPlay.conn:Disconnect() end)
  _G.AmbitiousAutoPlay.conn = nil
end
_G.AmbitiousAutoPlay.side = nil

function _G.AmbitiousAutoPlay.placeOk()
  local ok, id = pcall(function() return game.PlaceId end)
  return ok and id == _G.AmbitiousAutoPlay.cfg.PLACE
end

-- "L", "R" oppure nil se non sei vicino a nessuna delle due basi.
function _G.AmbitiousAutoPlay.zoneDir()
  local A = _G.AmbitiousAutoPlay
  local char = LP.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  if not hrp then return nil end
  local p = hrp.Position
  local function near(z)
    local dx, dz = p.X - z.x, p.Z - z.z
    return math.sqrt(dx * dx + dz * dz) <= A.cfg.RADIUS
  end
  if near(A.cfg.LEFT)  then return "L" end
  if near(A.cfg.RIGHT) then return "R" end
  return nil
end

-- Il lato rilevato sta girando?
function _G.AmbitiousAutoPlay.running()
  local A = _G.AmbitiousAutoPlay
  if A.side == "L" then return autoLeftEnabled == true end
  if A.side == "R" then return autoRightEnabled == true end
  return false
end

function _G.AmbitiousAutoPlay.save()
  local A = _G.AmbitiousAutoPlay
  if not A.placeOk() then return end
  local ok, job = pcall(function() return tostring(game.JobId or "") end)
  if not ok or job == "" then return end
  A.saveJob  = job
  A.saveSide = A.side
  -- Si ricorda il LATO, non se era acceso: rientrando decidi tu quando
  -- farlo partire. Ripristinare anche l'acceso vorrebbe dire ritrovarsi a
  -- correre da soli appena finito di caricare.
  if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

-- Accende o spegne il lato rilevato. Da qui in poi Auto Play non e' altro
-- che il pulsante di quella direzione.
function _G.AmbitiousAutoPlay.setSideOn(on)
  local A = _G.AmbitiousAutoPlay
  if A.side == "L" then
    if _G.AmbitiousSetAutoLeft then _G.AmbitiousSetAutoLeft(on and true or false) end
  elseif A.side == "R" then
    if _G.AmbitiousSetAutoRight then _G.AmbitiousSetAutoRight(on and true or false) end
  else
    return
  end
  A.save()
  if _G.AmbitiousRefreshMobileButtonStates then
    pcall(_G.AmbitiousRefreshMobileButtonStates)
  end
end

-- Stato per il bottone: e' semplicemente il lato acceso o spento. La
-- rilevazione non e' uno stato da mostrare â€” gira per conto suo e non
-- comanda niente.
function _G.AmbitiousAutoPlay.active()
  return _G.AmbitiousAutoPlay.running()
end

-- Smette di ascoltare. Non tocca la direzione.
function _G.AmbitiousAutoPlay.stop()
  local A = _G.AmbitiousAutoPlay
  if A.conn then pcall(function() A.conn:Disconnect() end); A.conn = nil end
end

-- Mette in ascolto del countdown. Parte da sola all'avvio dello script:
-- non c'e' niente da "armare", perche' rilevare non fa succedere nulla â€”
-- serve solo a sapere da che parte sei. Chiedere una pressione per
-- accendere un ascoltatore che non agisce sarebbe un passaggio in piu'
-- senza motivo, e per giunta facile da dimenticare prima del duello.
function _G.AmbitiousAutoPlay.watch()
  local A = _G.AmbitiousAutoPlay
  if A.side then return end     -- lato gia' noto: non c'e' piu' niente da rilevare
  if A.conn then pcall(function() A.conn:Disconnect() end) end

  A.conn = RunService.Heartbeat:Connect(function()
    if A.side then return end

    -- SI LEGGE IL NUMERO, non un cronometro. Il cartello mostra 5, 4, 3 e
    -- via cosi', quindi l'informazione "a che punto siamo" e' gia' li' â€”
    -- contare i secondi per conto proprio voleva dire ricostruire a mano
    -- una cosa gia' scritta, e infatti sbagliava: tra un numero e l'altro
    -- il cartello sparisce per un istante e il conto ripartiva da zero.
    -- Dal numero AT in giu' si comincia a guardare: prima si e' ancora per
    -- strada. Fuori dal countdown non si guarda niente, perche' passare
    -- vicino a una base in un momento qualsiasi non vuol dire nulla.
    local ok, n = pcall(_G.AmbitiousSafeModeCountdownValue)
    if not ok or n == nil or n > A.cfg.AT then return end

    local dir = A.zoneDir()
    if not dir then
      -- Ancora per strada, o countdown di passaggio con te da tutt'altra
      -- parte: non si decide niente e non si smette di ascoltare. Quella
      -- che conta e' la prima volta UTILE, se no un cartello visto per
      -- caso spegnerebbe la rilevazione per tutta la sessione.
      return
    end

    -- Arrivato. Si rileva e basta: NON si avvia niente, da qui in poi Auto
    -- Play e' il pulsante di quella direzione e a premerlo sei tu.
    A.side = dir
    A.stop()
    A.save()
    if _G.AmbitiousRefreshMobileButtonStates then
      pcall(_G.AmbitiousRefreshMobileButtonStates)
    end
  end)
end

-- Butta via il ricordo. Serve quando il ricordo e' di un'altra partita:
-- tenerlo non farebbe danni (il confronto sul JobId lo scarterebbe
-- comunque) ma resterebbe li' a sporcare, e soprattutto il ricordo giusto
-- di questa partita deve poterlo sostituire senza ambiguita'.
function _G.AmbitiousAutoPlay.forget()
  local A = _G.AmbitiousAutoPlay
  A.saveJob, A.saveSide = nil, nil
  _G._AmbAutoPlaySavedJob  = nil
  _G._AmbAutoPlaySavedSide = nil
  -- QUI NON SI SALVA. Dimenticare capita quasi sempre mentre la config si
  -- sta ancora caricando, e far partire un salvataggio in quel momento
  -- vorrebbe dire scrivere su disco uno stato applicato a meta' â€” cioe'
  -- perdere impostazioni che non c'entrano niente con Auto Play.
  -- Azzerare i campi basta: il ricordo e' gia' morto, e il primo
  -- salvataggio normale (un toggle qualsiasi) lo toglie anche dal file.
end

-- Rientro nello stesso server dopo un kick: si salta la rilevazione.
function _G.AmbitiousAutoPlay.restore()
  local A = _G.AmbitiousAutoPlay
  if A.side then return end
  -- Fuori dal posto di gioco previsto non si tocca niente: la config e'
  -- una sola per tutti i giochi, e cancellare da qui vorrebbe dire
  -- buttare il ricordo di una partita che magari e' ancora valida.
  if not A.placeOk() then return end
  local side = _G._AmbAutoPlaySavedSide
  if side ~= "L" and side ~= "R" then return end

  local ok, job = pcall(function() return tostring(game.JobId or "") end)
  if not (ok and job ~= "" and job == _G._AmbAutoPlaySavedJob) then
    -- Server diverso: il vecchio ricordo non vale piu' e viene buttato
    -- subito. Auto Play riparte in ascolto e il prossimo 1v1 scrive il
    -- ricordo nuovo â€” se restasse il vecchio, con il lato gia' deciso,
    -- resteresti inchiodato alla direzione di un'altra partita.
    A.forget()
    return
  end

  -- Si riprende SOLO il lato. Auto Play resta spento: sapere da che parte
  -- andare non vuol dire volerci andare adesso, e ritrovarsi a correre
  -- appena rientrati sarebbe una sorpresa, non una comodita'. Da qui in
  -- poi il bottone e' quello di quella direzione, e lo premi tu.
  A.side = side           -- lato noto: il countdown non serve piu' guardarlo
  A.stop()
  -- Il ricordo viene riportato anche nei campi che la config riscrive: se
  -- restassero vuoti, il primo salvataggio qualsiasi (basta accendere
  -- un'altra opzione) cancellerebbe il ricordo appena ripreso, e un
  -- secondo kick ti troverebbe senza niente.
  A.saveJob, A.saveSide = job, side
  if _G.AmbitiousRefreshMobileButtonStates then
    pcall(_G.AmbitiousRefreshMobileButtonStates)
  end
end

-- Per controllare a occhio cosa sta facendo, senza riempire lo schermo di
-- avvisi: nella console dell'executor basta
--   print(_G.AmbitiousAutoPlayStatus())
-- Dice il lato (o che sta ancora ascoltando), il server di adesso e
-- quello a cui appartiene il ricordo: se i due JobId sono diversi e il
-- lato risulta ancora quello vecchio, allora il ricordo non e' stato
-- scartato â€” ed e' quello il sintomo da riportare.
function _G.AmbitiousAutoPlayStatus()
  local A = _G.AmbitiousAutoPlay
  local ok, job = pcall(function() return tostring(game.JobId or "") end)
  return table.concat({
    "lato=" .. tostring(A.side or "nessuno"),
    "ascolto=" .. tostring(A.conn ~= nil),
    "placeOk=" .. tostring(A.placeOk()),
    "jobOra=" .. ((ok and job ~= "" and job) or "?"),
    "jobRicordo=" .. tostring(A.saveJob or _G._AmbAutoPlaySavedJob or "nessuno"),
  }, " | ")
end

function _G.AmbitiousAutoPlayToggle()
  local A = _G.AmbitiousAutoPlay
  -- Nessun lato ancora rilevato: non c'e' niente da accendere, e accendere
  -- "a caso" una delle due direzioni sarebbe peggio che non fare nulla.
  if not A.side then return end
  A.setSideOn(not A.running())
end

-- La config puo' essere gia' stata letta prima che questo blocco
-- esistesse: si prova subito, e ci riprova anche chi la legge.
pcall(_G.AmbitiousAutoPlay.restore)
-- E si mette in ascolto da subito: se il lato e' gia' noto watch() esce
-- da sola, se no aspetta il primo countdown senza che nessuno debba
-- ricordarsi di accendere niente.
pcall(_G.AmbitiousAutoPlay.watch)

LP.CharacterAdded:Connect(function(char)
  _G._AmbitiousWaitCharReady(char, 10)
  if autoLeftEnabled and _G.AmbitiousStartAutoLeft then _G.AmbitiousStartAutoLeft() end
  if autoRightEnabled and _G.AmbitiousStartAutoRight then _G.AmbitiousStartAutoRight() end
end)

local overheadGui = nil
local overheadSpeedLabel = nil

local function setupOverheadInfo(char)
    -- Distrugge la GUI precedente
    if overheadGui then
        pcall(function() overheadGui:Destroy() end)
        overheadGui = nil
        overheadSpeedLabel = nil
        ragdollCountdownLabel = nil
    end
    if not char then return end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
    if not head then return end

    overheadGui = Instance.new("BillboardGui")
    overheadGui.Name = "AmbitiousHubOverheadInfo"
    overheadGui.Size = UDim2.new(0, 250, 0, 88)
    overheadGui.StudsOffset = Vector3.new(0, 1.75, 0)
    overheadGui.AlwaysOnTop = true
    overheadGui.LightInfluence = 0
    overheadGui.Parent = head

    -- RAGDOLL COUNTDOWN (INVARIATO - verde)
    ragdollCountdownLabel = Instance.new("TextLabel")
    ragdollCountdownLabel.Name = "RagdollCountdown"
    ragdollCountdownLabel.Size = UDim2.new(1, 0, 0, 26)
    ragdollCountdownLabel.Position = UDim2.new(0, 0, 0, 0)
    ragdollCountdownLabel.BackgroundTransparency = 1
    ragdollCountdownLabel.Text = ""
    ragdollCountdownLabel.Visible = false
    ragdollCountdownLabel.TextColor3 = Color3.fromRGB(255, 220, 70)
    ragdollCountdownLabel.TextStrokeColor3 = Color3.fromRGB(255, 220, 70)
    ragdollCountdownLabel.TextStrokeTransparency = 0
    ragdollCountdownLabel.Font = Enum.Font.GothamBlack
    ragdollCountdownLabel.TextSize = 22
    ragdollCountdownLabel.TextXAlignment = Enum.TextXAlignment.Center
    ragdollCountdownLabel.ZIndex = 10
    ragdollCountdownLabel.Parent = overheadGui

    -- LABEL DISCORD (GRADIENTE GALATTICO SUL TESTO)
    local discordLbl = Instance.new("TextLabel")
    discordLbl.Name = "Discord"
    discordLbl.Size = UDim2.new(1, 0, 0, 30)
    discordLbl.Position = UDim2.new(0, 0, 0, 26)
    discordLbl.BackgroundTransparency = 1
    discordLbl.RichText = true
    discordLbl.Text = "<font color=\"#FFD83D\">Gesu</font><font color=\"#FFFFFF\"> Hub</font>"
    discordLbl.TextColor3 = Color3.fromRGB(255, 220, 70)
    discordLbl.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    discordLbl.TextStrokeTransparency = 0.35
    discordLbl.Font = Enum.Font.GothamBlack
    discordLbl.TextSize = 22
    discordLbl.TextXAlignment = Enum.TextXAlignment.Center
    discordLbl.ZIndex = 10
    discordLbl.Parent = overheadGui

    -- DIVISORE (GRADIENTE GALATTICO)
    local dividerLine = Instance.new("Frame")
    dividerLine.Name = "DividerLine"
    dividerLine.Size = UDim2.new(0.7, 0, 0, 2)
    dividerLine.Position = UDim2.new(0.15, 0, 0, 55)
    dividerLine.BackgroundColor3 = Color3.fromRGB(255, 220, 70)
    dividerLine.BackgroundTransparency = 0.15
    dividerLine.BorderSizePixel = 0
    dividerLine.ZIndex = 10
    dividerLine.Parent = overheadGui

    -- LABEL SPEED (GRADIENTE GALATTICO SUL TESTO)
    overheadSpeedLabel = Instance.new("TextLabel")
    overheadSpeedLabel.Name = "Speed"
    overheadSpeedLabel.Size = UDim2.new(1, 0, 0, 26)
    overheadSpeedLabel.Position = UDim2.new(0, 0, 0, 56)
    overheadSpeedLabel.BackgroundTransparency = 1
    overheadSpeedLabel.Text = "Speed: 0"
    overheadSpeedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    overheadSpeedLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    overheadSpeedLabel.TextStrokeTransparency = 0.35
    overheadSpeedLabel.Font = Enum.Font.GothamBlack
    overheadSpeedLabel.TextSize = 20
    overheadSpeedLabel.TextXAlignment = Enum.TextXAlignment.Center
    overheadSpeedLabel.ZIndex = 10
    overheadSpeedLabel.Parent = overheadGui
end

_G._AmbitiousRCD = _G._AmbitiousRCD or {conn=nil, charConn=nil, endTime=0, seconds=2.6}
-- Flag alzato quando il ragdoll corrente Ã¨ causato da medusa (rilevato via Anchored+Transparency==1)
-- Usa 'or 0' invece di reset incondizionato: preserva un hit recente in caso di re-inject.
_G._AmbitiousMedusaHitTime = _G._AmbitiousMedusaHitTime or 0
-- _isMedusaHit Ã¨ definita prima di _doSyncAfterHit (sezione SYNC AFTER HIT) per essere una upvalue valida.

function stopRagdollCountdown()
  if _G._AmbitiousRCD.conn then _G._AmbitiousRCD.conn:Disconnect(); _G._AmbitiousRCD.conn = nil end
  if _G._AmbitiousRCD.charConn then _G._AmbitiousRCD.charConn:Disconnect(); _G._AmbitiousRCD.charConn = nil end
  if ragdollCountdownLabel then
    ragdollCountdownLabel.Visible = false
    ragdollCountdownLabel.Text = ""
  end
end

-- ============================================================
-- ENEMY RAGDOLL COUNTDOWN SYSTEM
-- Shows countdown above enemies when they get ragdolled
-- ============================================================
local enemyRagdollData = {}
-- Esposto per il Bat Counter V2 (deve restare la STESSA tabella: mai riassegnarla)
_G.AmbitiousEnemyRagdollData = enemyRagdollData
local enemyCountdownConns = {}
local enemyCountdownUpdateLoop = nil
local ENEMY_RAGDOLL_SECONDS = 2.6

function _G.AmbitiousStartEnemyRagdollCountdown()
    if enemyRagdollConn then return end  -- usiamo enemyRagdollConn come flag

    -- Loop di aggiornamento countdown (ogni 0.05 sec, non ogni frame)
    enemyCountdownUpdateLoop = RunService.Heartbeat:Connect(function()
        local now = tick()
        for plr, data in pairs(enemyRagdollData) do
            if not data or not data.gui or not data.gui.Parent then
                enemyRagdollData[plr] = nil
                continue
            end
            if data.endTime and data.endTime > now then
                local left = data.endTime - now
                local label = data.gui:FindFirstChild("Countdown")
                if label then
                    label.Text = string.format("RAGDOLL %.1f", left)
                    label.TextColor3 = left <= 1 and Color3.fromRGB(255, 220, 70) or Color3.fromRGB(255, 220, 70)
                end
            else
                -- Il timer Ã¨ scaduto: nascondi la GUI e rimuovi il dato
                pcall(function() data.gui:Destroy() end)
                enemyRagdollData[plr] = nil
            end
        end
    end)

    -- Rilevamento ragdoll tramite DescendantAdded
    local function setupEnemyRagdollDetector(enemyChar, plr)
        -- Pulisci vecchie connessioni per questo giocatore
        if enemyCountdownConns[plr] then
            local old = enemyCountdownConns[plr]
            pcall(function() if old.ragdollDetect then old.ragdollDetect:Disconnect() end end)
            pcall(function() if old.stateChange   then old.stateChange:Disconnect()   end end)
            -- NON disconnettiamo charAdded qui: viene gestita in watchEnemyPlayer
            enemyCountdownConns[plr] = nil
        end

        -- Connessione per rilevare l'inizio del ragdoll
        local conn = enemyChar.DescendantAdded:Connect(function(d)
            if d:IsA("BallSocketConstraint") then
                -- Rilevato ragdoll: imposta il countdown
                local now = tick()
                local data = enemyRagdollData[plr]
                if not data then
                    -- Crea la GUI se non esiste
                    local head = enemyChar:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "AmbitiousEnemyRagdollCountdown"
                        bb.Adornee = head
                        bb.Size = UDim2.new(0, 120, 0, 30)
                        bb.StudsOffset = Vector3.new(0, 3.2, 0)
                        bb.AlwaysOnTop = true
                        bb.LightInfluence = 0
                        -- Parent to PlayerGui so it survives character resets/destruction
                        bb.Parent = HubGui

                        local label = Instance.new("TextLabel")
                        label.Name = "Countdown"
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = ""
                        label.TextColor3 = Color3.fromRGB(255, 220, 70)
                        label.TextStrokeColor3 = Color3.fromRGB(255, 220, 70)
                        label.TextStrokeTransparency = 0
                        label.Font = Enum.Font.GothamBlack
                        label.TextSize = 20
                        label.TextXAlignment = Enum.TextXAlignment.Center
                        label.ZIndex = 10
                        label.Parent = bb

                        enemyRagdollData[plr] = {
                            gui = bb,
                            endTime = now + ENEMY_RAGDOLL_SECONDS
                        }
                    end
                else
                    -- Se il ragdoll Ã¨ giÃ  attivo, resetta il timer
                    data.endTime = now + ENEMY_RAGDOLL_SECONDS
                end
            end
        end)

        -- Connessione per rilevare la fine del ragdoll (quando lo stato non Ã¨ piÃ¹ ragdoll)
        local hum = enemyChar:FindFirstChildOfClass("Humanoid")
        local stateConn
        if hum then
            stateConn = hum.StateChanged:Connect(function(_, newState)
                local stillRagdoll = (newState == Enum.HumanoidStateType.Physics or
                                      newState == Enum.HumanoidStateType.Ragdoll)
                if not stillRagdoll then
                    -- Uscito dal ragdoll: rimuovi la GUI solo se il countdown Ã¨ giÃ  scaduto
                    local data = enemyRagdollData[plr]
                    if data then
                        if tick() >= (data.endTime or 0) then
                            if data.gui then pcall(function() data.gui:Destroy() end) end
                            enemyRagdollData[plr] = nil
                        end
                        -- Se il timer Ã¨ ancora in corso, il loop Heartbeat gestirÃ  la rimozione
                    end
                end
            end)
        else
            -- Se non c'Ã¨ Humanoid, pulisci quando il personaggio viene distrutto
            stateConn = enemyChar.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    local data = enemyRagdollData[plr]
                    if data and data.gui then
                        pcall(function() data.gui:Destroy() end)
                    end
                    enemyRagdollData[plr] = nil
                end
            end)
        end

        enemyCountdownConns[plr] = {ragdollDetect = conn, stateChange = stateConn}
    end

    -- Applica a tutti i giocatori esistenti e futuri
    local function watchEnemyPlayer(plr)
        if plr == LP then return end
        -- Disconnetti la vecchia CharacterAdded se esiste
        if enemyCountdownConns[plr] and enemyCountdownConns[plr].charAdded then
            pcall(function() enemyCountdownConns[plr].charAdded:Disconnect() end)
        end
        local charConn = plr.CharacterAdded:Connect(function(char)
            if char then setupEnemyRagdollDetector(char, plr) end
        end)
        -- Salva la conn nel record del player (merge con ragdollDetect/stateChange)
        if not enemyCountdownConns[plr] then enemyCountdownConns[plr] = {} end
        enemyCountdownConns[plr].charAdded = charConn
        if plr.Character then setupEnemyRagdollDetector(plr.Character, plr) end
    end

    -- Pulisci vecchie connessioni prima di ricreare
    for _, conns in pairs(enemyCountdownConns) do
        pcall(function()
            if conns.ragdollDetect then conns.ragdollDetect:Disconnect() end
            if conns.stateChange then conns.stateChange:Disconnect() end
            if conns.charAdded then conns.charAdded:Disconnect() end
        end)
    end
    enemyCountdownConns = {}

    -- Attiva il watcher
    enemyRagdollConn = Players.PlayerAdded:Connect(watchEnemyPlayer)
    for _, plr in ipairs(Players:GetPlayers()) do
        watchEnemyPlayer(plr)
    end

    -- Pulisci alla rimozione del giocatore. La connessione sta in una
    -- variabile sua: messa dentro enemyCountdownConns (indicizzata per
    -- giocatore) la pulizia non la trovava e restava appesa per sempre.
    if _G._AmbitiousEnemyCountdownRemovingConn then
        pcall(function() _G._AmbitiousEnemyCountdownRemovingConn:Disconnect() end)
    end
    _G._AmbitiousEnemyCountdownRemovingConn = Players.PlayerRemoving:Connect(function(plr)
        local data = enemyRagdollData[plr]
        if data and data.gui then
            pcall(function() data.gui:Destroy() end)
        end
        enemyRagdollData[plr] = nil
        if enemyCountdownConns[plr] then
            pcall(function()
                if enemyCountdownConns[plr].ragdollDetect then enemyCountdownConns[plr].ragdollDetect:Disconnect() end
                if enemyCountdownConns[plr].stateChange then enemyCountdownConns[plr].stateChange:Disconnect() end
                if enemyCountdownConns[plr].charAdded then enemyCountdownConns[plr].charAdded:Disconnect() end
            end)
            enemyCountdownConns[plr] = nil
        end
    end)
end

function _G.AmbitiousStopEnemyRagdollCountdown()
    if enemyRagdollConn then
        enemyRagdollConn:Disconnect()
        enemyRagdollConn = nil
    end
    if enemyCountdownUpdateLoop then
        enemyCountdownUpdateLoop:Disconnect()
        enemyCountdownUpdateLoop = nil
    end
    if _G._AmbitiousEnemyCountdownRemovingConn then
        pcall(function() _G._AmbitiousEnemyCountdownRemovingConn:Disconnect() end)
        _G._AmbitiousEnemyCountdownRemovingConn = nil
    end
    for _, conns in pairs(enemyCountdownConns) do
        pcall(function()
            if conns.ragdollDetect then conns.ragdollDetect:Disconnect() end
            if conns.stateChange then conns.stateChange:Disconnect() end
            -- Senza questa la CharacterAdded restava viva e ad ogni respawn
            -- rimetteva in piedi rilevatore e GUI a funzione spenta.
            if conns.charAdded then conns.charAdded:Disconnect() end
        end)
    end
    enemyCountdownConns = {}
    for plr, data in pairs(enemyRagdollData) do
        if data and data.gui then
            pcall(function() data.gui:Destroy() end)
        end
    end
    -- Pulizia IN-PLACE: se riassegnassimo la tabella, _G.AmbitiousEnemyRagdollData
    -- resterebbe agganciato a quella vecchia e il Bat Counter V2 leggerebbe dati morti.
    for plr in pairs(enemyRagdollData) do enemyRagdollData[plr] = nil end
end

local _originalStopRagdoll = stopRagdollCountdown
function stopRagdollCountdown()
  _originalStopRagdoll()
  _G.AmbitiousStopEnemyRagdollCountdown()
end

function hookRagdollCountdown(char)
  stopRagdollCountdown()
  if not ragdollCountdownEnabled then return end
  -- Avvia il rilevamento ragdoll nemici
  _G.AmbitiousStartEnemyRagdollCountdown()
  char = char or LP.Character
  if not char then return end
  local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 4)
  if not hum then return end

  local function beginCountdown()
    local duration = _isMedusaHit() and 3.6 or _G._AmbitiousRCD.seconds
    _G._AmbitiousRCD.endTime = tick() + duration
    if ragdollCountdownLabel then
      ragdollCountdownLabel.Visible = true
    end
  end

  local function isRagdollStateForCountdown()
    local st = hum:GetState()
    return hum.PlatformStand
      or st == Enum.HumanoidStateType.Physics
      or st == Enum.HumanoidStateType.Ragdoll
  end

  _G._AmbitiousRCD.charConn = hum.StateChanged:Connect(function(_, newState)
    if newState == Enum.HumanoidStateType.Physics
      or newState == Enum.HumanoidStateType.Ragdoll then
      beginCountdown()
    end
  end)

  _G._AmbitiousRCD.conn = RunService.RenderStepped:Connect(function()
    if not ragdollCountdownEnabled then stopRagdollCountdown(); return end
    if not ragdollCountdownLabel or not ragdollCountdownLabel.Parent then return end
    if isRagdollStateForCountdown() and _G._AmbitiousRCD.endTime < tick() then
      beginCountdown()
    end
    local left = math.max(0, _G._AmbitiousRCD.endTime - tick())
    if left > 0 then
      ragdollCountdownLabel.Visible = true
      ragdollCountdownLabel.Text = string.format("RAGDOLL %.1f", left)
      if left <= 1 then
        ragdollCountdownLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
      else
        ragdollCountdownLabel.TextColor3 = Color3.fromRGB(255, 220, 70)
      end
    else
      ragdollCountdownLabel.Visible = false
      ragdollCountdownLabel.Text = ""
    end
  end)

end

if LP.Character then
  task.spawn(function()
    setupOverheadInfo(LP.Character)
  end)
end

LP.CharacterAdded:Connect(function(char)
  _G._AmbitiousWaitCharReady(char, 10)
  setupOverheadInfo(char)
  if ragdollCountdownEnabled then hookRagdollCountdown(char) end
end)

-- ========== SPEED BOOSTER PROXY ==========
-- Variabili e helper nel do-block: liberano 6 slot locals dal main chunk.
do
  -- >>> ROOT VELOCITY <<<
  -- Niente piu' proxy: la speed scrive direttamente sulla root.Velocity
  -- dell'HRP, che e' il metodo che prima si usava solo con l'Anti Bat acceso.
  local _sbConn  = nil
  local _sbActive = false

  local function _sbStart()
    if _sbConn then _sbConn:Disconnect(); _sbConn = nil end
    _sbActive = true
    _sbConn = RunService.Heartbeat:Connect(function()
      if not _sbActive then
        _sbConn:Disconnect(); _sbConn = nil
        return
      end
      local char = LP.Character
      if not char then return end
      local hrp = char:FindFirstChild("HumanoidRootPart")
      if not hrp then return end
      local hum = char:FindFirstChildOfClass("Humanoid")
      if not hum then return end
      local state = hum:GetState()
      if hum.PlatformStand
        or state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown then
        lastMoveDir = Vector3.new(0, 0, 0)
        return
      end
      local md = hum.MoveDirection
      local spd = getCurrentSpeedValue()
      if not autoLeftEnabled and not autoRightEnabled and md.Magnitude > 0 then
        lastMoveDir = md
        -- >>> ROOT VELOCITY <<<
        -- Percorso unico per tutti: si scrive la X/Z sulla root e si lascia
        -- stare la Y, cosi' salto e caduta restano gestiti dal gioco.
        -- Pubblica la X/Z desiderata: Anti Bat la riusa dopo ogni spike,
        -- altrimenti si tornerebbe alla velocita' della walkspeed.
        -- Durante lo ZigZag non si pubblica nemmeno la X/Z desiderata:
        -- l'Anti Bat la riapplicherebbe dopo ogni spike, rimettendo la
        -- direzione dei tasti al posto della deriva laterale.
        if _G._AmbitiousZigZagFalling then
          _G._AmbitiousAntiBatDesiredXZ = nil
        else
          _G._AmbitiousAntiBatDesiredXZ = Vector3.new(md.X * spd, 0, md.Z * spd)
        end
        -- Mentre lo spike dell'Anti Bat e' attivo NON si scrive: altrimenti
        -- la velocita' caotica verrebbe cancellata nello stesso frame e
        -- l'Anti Bat non avrebbe effetto mentre ci si muove.
        if not _G._AmbitiousAntiBatSpiking and not _G._AmbitiousZigZagFalling then
          local curVel = hrp.Velocity
          hrp.Velocity = Vector3.new(md.X * spd, curVel.Y, md.Z * spd)
        end
      end
      -- >>> ANTI BAT BEGIN
      if md.Magnitude <= 0 or autoLeftEnabled or autoRightEnabled then
        _G._AmbitiousAntiBatDesiredXZ = nil
      end
      -- <<< ANTI BAT END
      -- Aggiorna overhead speed label
      if overheadSpeedLabel then
        local displaySpeed
        if _G.AmbitiousNormalAimbotOn then
          displaySpeed = _G.AmbitiousGetNormalAimbotSpeed and _G.AmbitiousGetNormalAimbotSpeed() or spd
        elseif _G.AmbitiousBatAimbotV2On then
          displaySpeed = _G.AmbitiousGetBatAimbotV2Speed and _G.AmbitiousGetBatAimbotV2Speed() or spd
        elseif autoLeftEnabled or autoRightEnabled then
          displaySpeed = _G.AmbitiousAutoPathSpeed()
        -- >>> ANTI BAT BEGIN
        elseif _G.AmbitiousAntiBatEnabled then
          -- Con Anti Bat la velocita' misurata schizza a migliaia per un frame:
          -- si mostra la speed impostata invece di leggere l'HRP.
          displaySpeed = (md.Magnitude > 0) and spd or 0
        -- <<< ANTI BAT END
        else
            local vel = hrp.AssemblyLinearVelocity
            local raw = Vector3.new(vel.X, 0, vel.Z).Magnitude
            displaySpeed = raw > 200 and 0 or raw
        end
        -- (la root la scriviamo noi, quindi il valore letto e' gia' quello vero)
        overheadSpeedLabel.Text = string.format("%.1f", displaySpeed)
      end
    end)
  end

  local function _sbStop()
    _sbActive = false
    if _sbConn then _sbConn:Disconnect(); _sbConn = nil end
    -- >>> ROOT VELOCITY <<< si azzera la X/Z della root, la Y la lascia
    -- stare: altrimenti spegnendo la speed a mezz'aria si resterebbe
    -- appesi con la caduta annullata.
    local ch = LP.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if hrp then
      pcall(function()
        local v = hrp.Velocity
        hrp.Velocity = Vector3.new(0, v.Y, 0)
      end)
    end
    _G._AmbitiousAntiBatDesiredXZ = nil
  end


  -- Avvia subito
  if LP.Character then
    task.wait(0.1)
    _sbStart()
  else
    LP.CharacterAdded:Wait()
    task.wait(0.1)
    _sbStart()
  end
end -- fine do-block speed booster proxy
-- ========== FINE SPEED BOOSTER PROXY ==========

local COLORS = {
  bg = Color3.fromRGB(0, 0, 0),
  row = Color3.fromRGB(0, 0, 0),
  row2 = Color3.fromRGB(0, 0, 0),
  stroke = Color3.fromRGB(255, 220, 70),
  strokeSoft = Color3.fromRGB(255, 220, 70),
  white = Color3.fromRGB(255, 220, 70),
  textDim = Color3.fromRGB(255, 220, 70),
  txt = Color3.fromRGB(255, 220, 70),
  txtDim = Color3.fromRGB(255, 220, 70),
  toggleBg = Color3.fromRGB(0, 0, 0),
  knob = Color3.fromRGB(255, 220, 70),
}

function corner(parent, radius)
  local c = Instance.new("UICorner")
  c.CornerRadius = UDim.new(0, radius or 8)
  c.Parent = parent
  return c
end

function stroke(parent, color, thickness, transparency)
  local s = Instance.new("UIStroke")
  s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  s.Color = color or COLORS.stroke
  s.Thickness = thickness or 1
  s.Transparency = transparency or 0.35
  s.Parent = parent
  local g = Instance.new("UIGradient")
  g.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
  })
  g.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.55),
    NumberSequenceKeypoint.new(0.5, 0.1),
    NumberSequenceKeypoint.new(1, 0.55),
  })
  g.Parent = s
  return s
end

function tween(obj, props, time)
  TweenService:Create(obj, TweenInfo.new(time or 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- Due glifi sovrapposti (su / giu) che si scambiano in dissolvenza.
-- Ruotare un singolo glifo lo spostava fuori asse, perche' la punta
-- non e' centrata dentro la riga di testo del font.
_G._AmbitiousArrowGlyph = function(arrow)
  if not arrow then return nil, nil end
  local up = arrow:FindFirstChild("GlyphUp")
  local down = arrow:FindFirstChild("GlyphDown")
  if not up then
    local function mk(name, char)
      local g = Instance.new("TextLabel")
      g.Name = name
      g.BackgroundTransparency = 1
      g.Size = UDim2.new(1, 0, 1, 0)
      g.Position = UDim2.new(0, 0, 0, 0)
      g.Text = char
      g.TextColor3 = arrow.TextColor3
      g.TextStrokeColor3 = arrow.TextStrokeColor3
      g.TextStrokeTransparency = arrow.TextStrokeTransparency
      g.TextSize = arrow.TextSize
      g.Font = arrow.Font
      g.TextXAlignment = Enum.TextXAlignment.Center
      g.TextYAlignment = Enum.TextYAlignment.Center
      g.ZIndex = (arrow.ZIndex or 1) + 1
      g.Parent = arrow
      return g
    end
    up = mk("GlyphUp", "\u{25B2}")
    down = mk("GlyphDown", "\u{25BC}")
    down.TextTransparency = 1
    down.TextStrokeTransparency = 1
    arrow.Text = ""
  end
  return up, down
end

-- ===== TEMA ACCENTO (viola sui background 1-2, grigio su 3-4 e custom) =====
_G._AmbitiousAccentList = _G._AmbitiousAccentList or {}

_G._AmbitiousAccentIsGrey = function()
  if _G._AmbitiousBgCustom == true then return true end
  local i = tonumber(_G._AmbitiousBgIndex) or 1
  return not (i == 1 or i == 2)
end

_G._AmbitiousApplyAccent = function()
  local grey = _G._AmbitiousAccentIsGrey()

  local c0, c1, c2, edge, soft, base
  if grey then
    c0   = Color3.fromRGB(255, 220, 70)
    c1   = Color3.fromRGB(255, 220, 70)
    c2   = Color3.fromRGB(0, 0, 0)
    edge = Color3.fromRGB(255, 220, 70)
    soft = Color3.fromRGB(255, 220, 70)
    base = Color3.fromRGB(255, 220, 70)
  else
    c0   = Color3.fromRGB(255, 220, 70)
    c1   = Color3.fromRGB(0, 0, 0)
    c2   = Color3.fromRGB(0, 0, 0)
    edge = Color3.fromRGB(255, 220, 70)
    soft = Color3.fromRGB(255, 220, 70)
    base = Color3.fromRGB(0, 0, 0)
  end

  local cs = ColorSequence.new({
    ColorSequenceKeypoint.new(0, c0),
    ColorSequenceKeypoint.new(0.5, c1),
    ColorSequenceKeypoint.new(1, c2),
  })
  local slideAlpha = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.08),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.08),
  })
  local pickAlpha = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.12),
    NumberSequenceKeypoint.new(0.5, 0.05),
    NumberSequenceKeypoint.new(1, 0.12),
  })

  local list = _G._AmbitiousAccentList
  for i = #list, 1, -1 do
    local e = list[i]
    if not (e and e.obj and e.obj.Parent) then
      table.remove(list, i)
    else
      local st = e.obj:FindFirstChildOfClass("UIStroke")
      if e.kind == "soft" then
        if st then st.Color = soft end
      elseif e.kind == "button" then
        -- Se il gradiente e' spento il bottone e' in uno stato speciale
        -- (conferma / done): non ci mettiamo mano.
        if not (e.grad and e.grad.Enabled == false) then
          e.obj.BackgroundColor3 = base
          e.obj.BackgroundTransparency = 0
          if e.grad then e.grad.Color = cs end
          if st then st.Color = edge end
        end
      elseif e.kind == "toggle" then
        -- Fill del toggle: colore e gradiente, ma la trasparenza la gestisce
        -- setVisual (acceso = visibile, spento = invisibile). Non toccarla.
        e.obj.BackgroundColor3 = base
        if e.grad then e.grad.Color = cs end
        local isOn = (e.obj.BackgroundTransparency < 0.5)
        if e.track then
          if isOn then e.track.BackgroundColor3 = base end
          local tst = e.track:FindFirstChildOfClass("UIStroke")
          if tst and isOn then tst.Color = edge end
        end
        if e.knob and isOn then
          local kst = e.knob:FindFirstChildOfClass("UIStroke")
          if kst then kst.Color = edge end
        end
        if e.row and isOn then
          local rst = e.row:FindFirstChildOfClass("UIStroke")
          if rst then rst.Color = base end
        end
      else
        e.obj.BackgroundColor3 = base
        e.obj.BackgroundTransparency = (e.kind == "slide") and 0.1 or 0.28
        if e.grad then
          e.grad.Color = cs
          e.grad.Transparency = (e.kind == "slide") and slideAlpha or pickAlpha
        end
        if st then st.Color = edge end
      end
    end
  end
end

_G._AmbitiousRegAccent = function(obj, grad, kind, track, knob, row)
  if not obj then return end
  table.insert(_G._AmbitiousAccentList,
    {obj = obj, grad = grad, kind = kind or "pick", track = track, knob = knob, row = row})
  pcall(_G._AmbitiousApplyAccent)
end

-- Colore acceso/spento del toggle, richiesto da setVisual
_G._AmbitiousToggleOnColor = function()
  if _G._AmbitiousAccentIsGrey() then
    return Color3.fromRGB(255, 220, 70), Color3.fromRGB(255, 220, 70)
  end
  return Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 220, 70)
end

-- Dopo che una tendina si chiude il canvas si accorcia, ma Roblox lascia
-- la CanvasPosition dov'era: si continua a scrollare nel vuoto. Qui la riallineiamo.
_G._AmbitiousClampCanvas = function(page)
  if not page or not page.Parent then return end
  if not page:IsA("ScrollingFrame") then return end
  task.defer(function()
    if not page or not page.Parent then return end
    local maxY = math.max(0, page.AbsoluteCanvasSize.Y - page.AbsoluteWindowSize.Y)
    local cp = page.CanvasPosition
    if cp.Y > maxY then
      page.CanvasPosition = Vector2.new(cp.X, maxY)
    end
  end)
end

-- Apertura/chiusura a tendina, altezza fissa nota
_G._AmbitiousExpand = function(holder, open, fullHeight, arrow)
  if not holder or not holder.Parent then return end
  holder.ClipsDescendants = true
  local info = TweenInfo.new(0.22, Enum.EasingStyle.Quart,
    open and Enum.EasingDirection.Out or Enum.EasingDirection.In)
  holder:SetAttribute("_expandToken", (holder:GetAttribute("_expandToken") or 0) + 1)
  local myToken = holder:GetAttribute("_expandToken")

  local gUp, gDown = _G._AmbitiousArrowGlyph(arrow)
  if gUp and gDown then
    local st = arrow.TextStrokeTransparency
    TweenService:Create(gUp, info, {TextTransparency = open and 1 or 0, TextStrokeTransparency = open and 1 or st}):Play()
    TweenService:Create(gDown, info, {TextTransparency = open and 0 or 1, TextStrokeTransparency = open and st or 1}):Play()
  end

  local page = holder.Parent
  local sx, ox = holder.Size.X.Scale, holder.Size.X.Offset
  if open then
    holder.Visible = true
    if holder.Size.Y.Offset >= fullHeight then
      holder.Size = UDim2.new(sx, ox, 0, 0)
    end
    TweenService:Create(holder, info, {Size = UDim2.new(sx, ox, 0, fullHeight)}):Play()
  else
    local closeTween = TweenService:Create(holder, info, {Size = UDim2.new(sx, ox, 0, 0)})
    closeTween.Completed:Connect(function()
      if holder and holder.Parent and holder:GetAttribute("_expandToken") == myToken then
        holder.Visible = false
      end
      _G._AmbitiousClampCanvas(page)
    end)
    closeTween:Play()
  end
end

-- Variante per contenitori ad altezza automatica
_G._AmbitiousExpandAuto = function(holder, open, layout, arrow)
  if not holder or not holder.Parent then return end
  holder.ClipsDescendants = true
  local info = TweenInfo.new(0.26, Enum.EasingStyle.Quart,
    open and Enum.EasingDirection.Out or Enum.EasingDirection.In)
  holder:SetAttribute("_expandToken", (holder:GetAttribute("_expandToken") or 0) + 1)
  local myToken = holder:GetAttribute("_expandToken")

  local gUp, gDown = _G._AmbitiousArrowGlyph(arrow)
  if gUp and gDown then
    local st = arrow.TextStrokeTransparency
    TweenService:Create(gUp, info, {TextTransparency = open and 1 or 0, TextStrokeTransparency = open and 1 or st}):Play()
    TweenService:Create(gDown, info, {TextTransparency = open and 0 or 1, TextStrokeTransparency = open and st or 1}):Play()
  end

  -- Altezza del contenuto in unita' LOCALI (non absolute): AbsoluteContentSize e
  -- AbsoluteSize sono moltiplicati dalla UIScale della GUI, mentre Size.Y.Offset no.
  -- Mischiare le due cose lasciava un buco vuoto sotto la lista con GUI Scale > 1.
  local function contentHeight()
    local total, n = 0, 0
    for _, ch in ipairs(holder:GetChildren()) do
      if ch:IsA("GuiObject") and ch.Visible then
        total = total + ch.Size.Y.Offset
        n = n + 1
      end
    end
    if layout and layout:IsA("UIListLayout") and n > 1 then
      total = total + layout.Padding.Offset * (n - 1)
    end
    if total <= 0 and layout then total = layout.AbsoluteContentSize.Y end
    local pad = holder:FindFirstChildOfClass("UIPadding")
    if pad then
      total = total + pad.PaddingTop.Offset + pad.PaddingBottom.Offset
    end
    return total
  end

  local sx, ox = holder.Size.X.Scale, holder.Size.X.Offset
  if open then
    holder.AutomaticSize = Enum.AutomaticSize.None
    holder.Visible = true
    holder.Size = UDim2.new(sx, ox, 0, 0)
    local openTweenAuto = TweenService:Create(holder, info, {Size = UDim2.new(sx, ox, 0, contentHeight())})
    -- Agganciato al Completed del tween, non a un task.delay a tempo fisso,
    -- cosi' il ripristino avviene esattamente alla fine dell'animazione.
    openTweenAuto.Completed:Connect(function()
      if holder and holder.Parent and holder:GetAttribute("_expandToken") == myToken then
        -- Azzera l'offset PRIMA di riattivare AutomaticSize: con AutomaticSize il Size
        -- funziona da altezza minima, quindi un offset residuo troppo grande resterebbe
        -- come spazio vuoto in fondo. Con 0 la frame si adatta esattamente al contenuto.
        holder.Size = UDim2.new(sx, ox, 0, 0)
        holder.AutomaticSize = Enum.AutomaticSize.Y
        holder.ClipsDescendants = false
        _G._AmbitiousClampCanvas(holder.Parent)
      end
    end)
    openTweenAuto:Play()
  else
    holder.AutomaticSize = Enum.AutomaticSize.None
    holder.Size = UDim2.new(sx, ox, 0, contentHeight())
    local page = holder.Parent
    local closeTweenAuto = TweenService:Create(holder, info, {Size = UDim2.new(sx, ox, 0, 0)})
    closeTweenAuto.Completed:Connect(function()
      if holder and holder.Parent and holder:GetAttribute("_expandToken") == myToken then
        holder.Visible = false
      end
      _G._AmbitiousClampCanvas(page)
    end)
    closeTweenAuto:Play()
  end
end

function makeDraggable(frame)
  local dragging = false
  local dragStart
  local startPos
  local dragInput
  frame.InputBegan:Connect(function(input)
    if _G.AmbitiousGuiLocked == true then return end
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
  frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
      dragInput = input
    end
  end)
  UserInputService.InputChanged:Connect(function(input)
    if _G.AmbitiousGuiLocked == true then return end
    if input == dragInput and dragging then
      local delta = input.Position - dragStart
      frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
      )
    end
  end)
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "AmbitiousHub"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 100000
Gui.Enabled = true
Gui.Parent = HubGui

local FULL_MAIN_SIZE = UDim2.new(0, 400, 0, 528)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Size = FULL_MAIN_SIZE
Main.Position = tableToUDim2(savedMainPositionTable, UDim2.new(0.5, 0, 0.5, 0))
savedMainPositionTable = udim2ToTable(Main.Position)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BackgroundTransparency = 0.18
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = true
Main.Parent = Gui
corner(Main, 16)

-- VX7-style glass panel: visual only; Roma controls/settings remain untouched.
do
  local panelGradient = Instance.new("UIGradient")
  panelGradient.Name = "VX7PanelGradient"
  panelGradient.Rotation = 115
  panelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 34)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(16, 16, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 36)),
  })
  panelGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.10),
    NumberSequenceKeypoint.new(0.55, 0.34),
    NumberSequenceKeypoint.new(1, 0.12),
  })
  panelGradient.Parent = Main

  local panelGlow = Instance.new("Frame")
  panelGlow.Name = "PanelHeaderGlow"
  panelGlow.BackgroundColor3 = COLORS.stroke
  panelGlow.BackgroundTransparency = 0.92
  panelGlow.BorderSizePixel = 0
  panelGlow.Size = UDim2.new(1, -18, 0, 54)
  panelGlow.Position = UDim2.new(0, 9, 0, 8)
  panelGlow.ZIndex = 2
  panelGlow.Parent = Main
  corner(panelGlow, 12)
end

local Vx7TopBar = Instance.new("Frame")
Vx7TopBar.Name = "VX7TopBar"
Vx7TopBar.Size = UDim2.new(1, 0, 0, 68)
Vx7TopBar.Position = UDim2.new(0, 0, 0, 0)
Vx7TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
Vx7TopBar.BackgroundTransparency = 0.10
Vx7TopBar.BorderSizePixel = 0
Vx7TopBar.ZIndex = 4
Vx7TopBar.Parent = Main
corner(Vx7TopBar, 16)
local vxTopGrad = Instance.new("UIGradient")
vxTopGrad.Rotation = 12
vxTopGrad.Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 32, 38)),
  ColorSequenceKeypoint.new(0.62, Color3.fromRGB(20, 20, 25)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 36)),
})
vxTopGrad.Parent = Vx7TopBar
local vxHeaderAccent = Instance.new("Frame")
vxHeaderAccent.Name = "HeaderAccent"
vxHeaderAccent.Size = UDim2.fromOffset(54, 2)
vxHeaderAccent.Position = UDim2.fromOffset(60, 48)
vxHeaderAccent.BackgroundColor3 = COLORS.stroke
vxHeaderAccent.BorderSizePixel = 0
vxHeaderAccent.ZIndex = 6
vxHeaderAccent.Parent = Vx7TopBar
corner(vxHeaderAccent, 2)
local vxBrand = Instance.new("TextLabel")
vxBrand.Name = "Brand"
vxBrand.Size = UDim2.new(0, 130, 1, 0)
vxBrand.Position = UDim2.new(0, 60, 0, 0)
vxBrand.BackgroundTransparency = 1
vxBrand.RichText = true
vxBrand.Text = "<font color=\"#FFD83D\">Gesu</font> <font color=\"#FFFFFF\">Hub</font>"
vxBrand.TextColor3 = Color3.fromRGB(255,255,255)
vxBrand.Font = Enum.Font.GothamBlack
vxBrand.TextSize = 12
vxBrand.TextXAlignment = Enum.TextXAlignment.Left
vxBrand.ZIndex = 6
vxBrand.Parent = Vx7TopBar
local vxSub = Instance.new("TextLabel")
vxSub.Name = "Sub"
vxSub.Size = UDim2.new(0, 100, 0, 12)
vxSub.Position = UDim2.new(0, 60, 0, 37)
vxSub.BackgroundTransparency = 1
vxSub.Text = "DUELS"
vxSub.TextColor3 = Color3.fromRGB(150,150,160)
vxSub.Font = Enum.Font.GothamMedium
vxSub.TextSize = 7
vxSub.TextXAlignment = Enum.TextXAlignment.Left
vxSub.ZIndex = 6
vxSub.Parent = Vx7TopBar

stroke(Main, COLORS.stroke, 1.2, 0.25)

makeDraggable(Main)
-- Posizione di riposo della hub: e' QUESTA l'unica verita'. L'animazione di
-- apertura/chiusura sposta Main, ma e' un fatto puramente visivo e non deve
-- mai poter cambiare questo valore.
_G._AmbitiousHubRestPos = Main.Position

Main:GetPropertyChangedSignal("Position"):Connect(function()
  -- Durante l'animazione di apertura/chiusura la Position passa per punti
  -- fuori schermo: non vanno salvati, altrimenti alla riapertura la hub
  -- si ritroverebbe parcheggiata fuori dal monitor.
  if _G._AmbitiousHubAnimating then return end
  _G._AmbitiousHubRestPos = Main.Position
  savedMainPositionTable = udim2ToTable(Main.Position)
end)

-- Lo sfondo della finestra e' l'ImageLabel "JesusBackground" (BgImage), fisso.
-- Non esistono piu' preset o immagini custom. Qui c'era un secondo ImageLabel fisso sullo sfondo 1,
-- stessa misura e stesso ZIndex: veniva coperto in pieno da BgImage e non si
-- e' mai visto. Rimosso, erano due immagini caricate per mostrarne una.

-- Immagine locale di Martina Smeraldi.
-- Metti "MartinaSmeraldi.png" nella cartella custom asset del tuo executor.
-- getcustomasset/getsynasset sono usati quando disponibili; in assenza si
-- non usa nessun logo precedente come fallback: cosi non compare mai Ambitious.
local ROMA_HUB_COLOSSEO_IMAGE = ""
local ROMA_HUB_COLOSSEO_FILE = "GesuHubJesus.jpg"
local SARA_DIAMANTE_FILE = "SaraDiamante.jpg"
local MIA_KHALIFA_FILE = "MiaKhalifa.jpg"
local SWEATY_FOX_FILE = "SweatyFox.jpg"
local SWEETIE_FOX_FILE = "SweetieFoxThird.jpg"

-- Immagine caricata dall'utente per la terza scelta. Viene ricreata automaticamente
-- nella cartella custom asset se il file non esiste gia'.
local SWEETIE_FOX_EMBEDDED_B64 = [[
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
]]


-- Foto pubblica di Martina Smeraldi usata come prima scelta.
local ROMA_HUB_COLOSSEO_URL = "https://commons.wikimedia.org/wiki/Special:Redirect/file/Jesus_Christ_-_Hofmann.jpg"
-- Seconda scelta: foto pubblica di Sara Diamante.
local SARA_DIAMANTE_URL = "https://slyvi-tstorage.fra1.cdn.digitaloceanspaces.com/r107192664264_tml428072744705_345674896597_1683522398483785.jpg"
-- Quarta scelta: foto pubblica e non esplicita di Mia Khalifa.
local MIA_KHALIFA_URL = "https://www.publinews.gt/resizer/v2/FR5PHUH43BHHVKYC7E7DLZ2M2E.jpg?auth=789c93ea2c60f34295d19a3f98911dbb93f05555c2f98853d4155652a397f272&height=1200&smart=true&width=1200"
-- Preset Sweaty Fox mantenuto come risorsa interna di compatibilita.
local SWEATY_FOX_URL = "https://images.unsplash.com/photo-1571852858920-b4bb12fc2d84?auto=format&fit=crop&fm=jpg&q=90&w=1600"

local function _romaHubGetAssetFile(name)
  local fns = {getcustomasset, getsynasset}
  for _, fn in ipairs(fns) do
    if type(fn) == "function" then
      local ok, res = pcall(fn, name)
      if ok and type(res) == "string" and res ~= "" then return res end
    end
  end
  return nil
end

-- Prima prova i file locali, poi prova a scaricare automaticamente la foto.
local _localNames = {
  ROMA_HUB_COLOSSEO_FILE,
  "MartinaSmeraldi.png",
  "RomaHub_Colosseo_Reale.png",
  "RomaHub_Colosseo.png"
}
for _, name in ipairs(_localNames) do
  local asset = _romaHubGetAssetFile(name)
  if asset then ROMA_HUB_COLOSSEO_IMAGE = asset break end
end

local SARA_DIAMANTE_IMAGE = ""
local MIA_KHALIFA_IMAGE = ""
local SWEATY_FOX_IMAGE = ""
local SWEETIE_FOX_IMAGE = ""

local function _romaHubBase64Decode(data)
  local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  data = tostring(data or ""):gsub("%s", "")
  local out = {}
  local buffer, bits = 0, 0
  for i = 1, #data do
    local c = data:sub(i, i)
    if c ~= "=" then
      local v = alphabet:find(c, 1, true)
      if v then
        buffer = buffer * 64 + (v - 1)
        bits = bits + 6
        if bits >= 8 then
          bits = bits - 8
          local byte = math.floor(buffer / (2 ^ bits)) % 256
          out[#out + 1] = string.char(byte)
          buffer = buffer % (2 ^ bits)
        end
      end
    end
  end
  return table.concat(out)
end

do
  local asset = _romaHubGetAssetFile(SARA_DIAMANTE_FILE) or _romaHubGetAssetFile("SaraDiamante.png")
  if asset then SARA_DIAMANTE_IMAGE = asset end
end
do
  local asset = _romaHubGetAssetFile(MIA_KHALIFA_FILE) or _romaHubGetAssetFile("MiaKhalifa.png")
  if asset then MIA_KHALIFA_IMAGE = asset end
end
do
  local asset = _romaHubGetAssetFile(SWEATY_FOX_FILE) or _romaHubGetAssetFile("SweatyFox.png")
  if asset then SWEATY_FOX_IMAGE = asset end
end
do
  local asset = _romaHubGetAssetFile(SWEETIE_FOX_FILE) or _romaHubGetAssetFile("SweetieFoxThird.png")
  if asset then SWEETIE_FOX_IMAGE = asset end
end

if ROMA_HUB_COLOSSEO_IMAGE == "" and type(writefile) == "function" then
  local _httpGet = nil
  if type(game) == "userdata" and type(game.HttpGet) == "function" then
    _httpGet = function(url) return game:HttpGet(url) end
  end
  if not _httpGet and type(request) == "function" then
    _httpGet = function(url)
      local r = request({Url = url, Method = "GET"})
      return r and r.Body
    end
  end
  if not _httpGet and type(http_request) == "function" then
    _httpGet = function(url)
      local r = http_request({Url = url, Method = "GET"})
      return r and r.Body
    end
  end
  if _httpGet then
    pcall(function()
      local body = _httpGet(ROMA_HUB_COLOSSEO_URL)
      if type(body) == "string" and #body > 10000 then
        writefile(ROMA_HUB_COLOSSEO_FILE, body)
        local asset = _romaHubGetAssetFile(ROMA_HUB_COLOSSEO_FILE)
        if asset then ROMA_HUB_COLOSSEO_IMAGE = asset end
      end
    end)
  end
end

-- Se disponibile un metodo HTTP, scarica anche la seconda scelta.
if SARA_DIAMANTE_IMAGE == "" and type(writefile) == "function" then
  local _httpGetSara = nil
  if type(game) == "userdata" and type(game.HttpGet) == "function" then
    _httpGetSara = function(url) return game:HttpGet(url) end
  end
  if not _httpGetSara and type(request) == "function" then
    _httpGetSara = function(url)
      local r = request({Url = url, Method = "GET"})
      return r and r.Body
    end
  end
  if not _httpGetSara and type(http_request) == "function" then
    _httpGetSara = function(url)
      local r = http_request({Url = url, Method = "GET"})
      return r and r.Body
    end
  end
  if _httpGetSara then
    pcall(function()
      local body = _httpGetSara(SARA_DIAMANTE_URL)
      if type(body) == "string" and #body > 10000 then
        writefile(SARA_DIAMANTE_FILE, body)
        local asset = _romaHubGetAssetFile(SARA_DIAMANTE_FILE)
        if asset then SARA_DIAMANTE_IMAGE = asset end
      end
    end)
  end
end

-- Scarica anche la terza scelta se non e' presente localmente.
if MIA_KHALIFA_IMAGE == "" and type(writefile) == "function" then
  local _httpGetMia = nil
  if type(game) == "userdata" and type(game.HttpGet) == "function" then
    _httpGetMia = function(url) return game:HttpGet(url) end
  end
  if not _httpGetMia and type(request) == "function" then
    _httpGetMia = function(url)
      local r = request({Url = url, Method = "GET"})
      return r and r.Body
    end
  end
  if not _httpGetMia and type(http_request) == "function" then
    _httpGetMia = function(url)
      local r = http_request({Url = url, Method = "GET"})
      return r and r.Body
    end
  end
  if _httpGetMia then
    pcall(function()
      local body = _httpGetMia(MIA_KHALIFA_URL)
      if type(body) == "string" and #body > 10000 then
        writefile(MIA_KHALIFA_FILE, body)
        local asset = _romaHubGetAssetFile(MIA_KHALIFA_FILE)
        if asset then MIA_KHALIFA_IMAGE = asset end
      end
    end)
  end
end

-- Scarica la foto Sweaty Fox se non e' gia' presente localmente.
if SWEATY_FOX_IMAGE == "" and type(writefile) == "function" then
  local _httpGetFox = nil
  if type(game) == "userdata" and type(game.HttpGet) == "function" then
    _httpGetFox = function(url) return game:HttpGet(url) end
  end
  if not _httpGetFox and type(request) == "function" then
    _httpGetFox = function(url)
      local r = request({Url = url, Method = "GET"})
      return r and r.Body
    end
  end
  if not _httpGetFox and type(http_request) == "function" then
    _httpGetFox = function(url)
      local r = http_request({Url = url, Method = "GET"})
      return r and r.Body
    end
  end
  if _httpGetFox then
    pcall(function()
      local body = _httpGetFox(SWEATY_FOX_URL)
      if type(body) == "string" and #body > 10000 then
        writefile(SWEATY_FOX_FILE, body)
        local asset = _romaHubGetAssetFile(SWEATY_FOX_FILE)
        if asset then SWEATY_FOX_IMAGE = asset end
      end
    end)
  end
end

-- La terza scelta richiesta dall'utente e' incorporata nella source: se il file
-- locale non esiste, viene ricreato automaticamente senza bisogno di un URL esterno.
if SWEETIE_FOX_IMAGE == "" and type(writefile) == "function" then
  pcall(function()
    local raw = _romaHubBase64Decode(SWEETIE_FOX_EMBEDDED_B64)
    if type(raw) == "string" and #raw > 1000 then
      writefile(SWEETIE_FOX_FILE, raw)
      local asset = _romaHubGetAssetFile(SWEETIE_FOX_FILE)
      if asset then SWEETIE_FOX_IMAGE = asset end
    end
  end)
end

-- Ultimo fallback della prima scelta se il download non riesce.
if ROMA_HUB_COLOSSEO_IMAGE == "" then
  ROMA_HUB_COLOSSEO_IMAGE = "rbxassetid://2414424666"
end

-- Se il download delle scelte successive non riesce, resta disponibile la prima foto.
if SARA_DIAMANTE_IMAGE == "" then
  SARA_DIAMANTE_IMAGE = ROMA_HUB_COLOSSEO_IMAGE
end
if MIA_KHALIFA_IMAGE == "" then
  MIA_KHALIFA_IMAGE = ROMA_HUB_COLOSSEO_IMAGE
end
if SWEATY_FOX_IMAGE == "" then
  SWEATY_FOX_IMAGE = ROMA_HUB_COLOSSEO_IMAGE
end
if SWEETIE_FOX_IMAGE == "" then
  SWEETIE_FOX_IMAGE = ROMA_HUB_COLOSSEO_IMAGE
end

-- Unica immagine della GUI: BgImage copre tutta Main.
-- Non vengono piÃ¹ creati ImageLabel separati per header/logo/titolo, cosÃ¬
-- la foto compare una sola volta in tutta la GUI e non viene duplicata.
local BgImage, MiniBg

-- >>> FIXED JESUS HUB BRANDING BEGIN
-- Unica immagine fissa: Gesu. Nessun Title Style selector.
_G.AmbitiousTitleStyles = {
  { image = ROMA_HUB_COLOSSEO_IMAGE, scale = 1, prev = 1.0, name = "Gesu" },
}
_G.AmbitiousTitleStyle = 1
_G.AmbitiousApplyTitleStyle = function()
  local image = ROMA_HUB_COLOSSEO_IMAGE
  pcall(function()
    if BgImage then
      BgImage.Image = image
      BgImage.Visible = image ~= ""
    end
    if MiniBg then MiniBg.Image = image end
    if _G.AmbitiousRefreshMobileButtonBackgrounds then
      task.defer(function() pcall(_G.AmbitiousRefreshMobileButtonBackgrounds) end)
    end
  end)
end
_G.AmbitiousApplyTitleStyle(1)
-- <<< FIXED JESUS HUB BRANDING END

local MiniFrame = Instance.new("Frame")
MiniFrame.Name = "MiniFrame"
MiniFrame.AnchorPoint = Vector2.new(0, 0)
MiniFrame.Size = UDim2.new(0, 130, 0, 35)
local MINI_DEFAULT_POSITION = UDim2.new(0, 132, 0, 112)
MiniFrame.Position = MINI_DEFAULT_POSITION
savedMiniPositionTable = nil
MiniFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MiniFrame.BackgroundTransparency = 1
MiniFrame.BorderSizePixel = 0
MiniFrame.Visible = true
MiniFrame.Active = true
MiniFrame.ZIndex = 20
MiniFrame.Parent = Gui
corner(MiniFrame, 8)
stroke(MiniFrame, Color3.fromRGB(255, 220, 70), 1, 0.22)

local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.new(1, 0, 1, 0)
MiniButton.Position = UDim2.new(0, 0, 0, 0)
MiniButton.BackgroundTransparency = 1
MiniButton.RichText = true
MiniButton.Text = "<font color=\"#FFD83D\">Gesu</font> <font color=\"#FFFFFF\">Hub</font>"
MiniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
MiniButton.TextStrokeTransparency = 0.25
MiniButton.TextSize = 17
MiniButton.Font = Enum.Font.GothamBlack
MiniButton.AutoButtonColor = false
MiniButton.ZIndex = 21
MiniButton.Parent = MiniFrame


do
  local miniDragging = false
  local miniDragStart = nil
  local miniStartPos = nil
  local miniMoved = false
  local miniHeldInput = nil
  local DRAG_DEADZONE = 6
  MiniButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      miniDragging = true
      miniMoved = false
      miniHeldInput = input
      miniDragStart = input.Position
      miniStartPos = MiniFrame.Position
    end
  end)
  UserInputService.InputChanged:Connect(function(input)
    if not miniDragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    if not miniDragStart or not miniStartPos then return end
    local delta = input.Position - miniDragStart
    if math.abs(delta.X) > DRAG_DEADZONE or math.abs(delta.Y) > DRAG_DEADZONE then
      miniMoved = true
    end
    MiniFrame.Position = UDim2.new(
      miniStartPos.X.Scale,
      miniStartPos.X.Offset + delta.X,
      miniStartPos.Y.Scale,
      miniStartPos.Y.Offset + delta.Y
    )
  end)
  UserInputService.InputEnded:Connect(function(input)
    if input ~= miniHeldInput then return end
    local wasDrag = miniMoved
    miniDragging = false
    miniHeldInput = nil
    miniDragStart = nil
    miniStartPos = nil
    if wasDrag then
      return
    end
    if _G.AmbitiousHubOpen then
      -- NIENTE salvataggio della posizione qui: AmbitiousHubOpen sposta
      -- subito Main FUORI schermo per farla rientrare animata. Leggere
      -- Main.Position in questo istante significa salvare la posizione
      -- fuori schermo, e alla sessione dopo la hub si riapriva fuori dal
      -- monitor: era quello il bug della "GUI sparita". La posizione di
      -- riposo resta gia' in savedMainPositionTable, non va toccata.
      _G.AmbitiousHubOpen()
    else
      Main.Visible = true
      MiniFrame.Visible = false
      Main.Size = FULL_MAIN_SIZE
      savedMainPositionTable = udim2ToTable(Main.Position)
    end
  end)
end

-- >>> HUB OPEN/CLOSE ANIMATION BEGIN
-- La finestra esce ed entra dal bordo dello schermo a cui e' piu' vicina:
-- a sinistra esce a sinistra, a destra a destra, in alto verso l'alto, in
-- basso verso il basso. Uscita con accelerazione (Quint In) e leggera
-- rimpicciolita + inclinazione; entrata con frenata elastica (Back Out).
--
-- NOTA LOCAL: nessun local a livello di chunk, il main e' a ridosso del
-- limite di 200. Tutto su _G, e Main/MiniFrame/FULL_MAIN_SIZE arrivano
-- come upvalue.
_G._AmbitiousHubAnimating = false
_G._AmbitiousHubAnimToken = 0

-- Centro della finestra ricavato dalla Position (AnchorPoint e' 0.5, 0.5),
-- non da AbsolutePosition: cosi' e' esatto anche nel frame in cui la
-- finestra viene resa visibile.
_G._AmbitiousHubEdgeFor = function(pos)
  local cam = workspace.CurrentCamera
  local vp  = (cam and cam.ViewportSize) or Vector2.new(1920, 1080)
  if vp.X < 1 or vp.Y < 1 then vp = Vector2.new(1920, 1080) end
  local cx = pos.X.Scale * vp.X + pos.X.Offset
  local cy = pos.Y.Scale * vp.Y + pos.Y.Offset
  -- distanze normalizzate: cosi' il confronto regge anche su schermi molto
  -- piu' larghi che alti
  local dLeft, dTop = cx / vp.X, cy / vp.Y
  local dRight, dBottom = 1 - dLeft, 1 - dTop
  local best, dir = dLeft, "Left"
  if dRight  < best then best, dir = dRight,  "Right"  end
  if dTop    < best then best, dir = dTop,    "Top"    end
  if dBottom < best then best, dir = dBottom, "Bottom" end
  return dir
end

-- Posizione fuori schermo sul bordo scelto, partendo da una Position data.
_G._AmbitiousHubOffscreen = function(pos, dir)
  local cam = workspace.CurrentCamera
  local vp  = (cam and cam.ViewportSize) or Vector2.new(1920, 1080)
  if vp.X < 1 or vp.Y < 1 then vp = Vector2.new(1920, 1080) end
  local sz = Main.AbsoluteSize
  local sw = (sz.X > 1) and sz.X or 324
  local sh = (sz.Y > 1) and sz.Y or 576
  local cx = pos.X.Scale * vp.X + pos.X.Offset
  local cy = pos.Y.Scale * vp.Y + pos.Y.Offset
  local dx, dy = 0, 0
  if dir == "Left" then
    dx = -(cx + sw * 0.8)
  elseif dir == "Right" then
    dx = (vp.X - cx) + sw * 0.8
  elseif dir == "Top" then
    dy = -(cy + sh * 0.8)
  else
    dy = (vp.Y - cy) + sh * 0.8
  end
  return UDim2.new(pos.X.Scale, pos.X.Offset + dx, pos.Y.Scale, pos.Y.Offset + dy)
end

-- Inclinazione in uscita: segue il verso della fuga, da' peso al movimento
_G._AmbitiousHubTilt = function(dir)
  if dir == "Left"  then return -7 end
  if dir == "Right" then return  7 end
  if dir == "Top"   then return -4 end
  return 4
end

-- Pop del mini popup (comparsa/sparizione)
_G._AmbitiousMiniPop = function(show)
  if not MiniFrame then return end
  local full = UDim2.new(0, 130, 0, 35)
  if show then
    MiniFrame.Size = UDim2.new(0, 0, 0, 0)
    MiniFrame.Visible = true
    TweenService:Create(MiniFrame,
      TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
      { Size = full }):Play()
  else
    TweenService:Create(MiniFrame,
      TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
      { Size = UDim2.new(0, 0, 0, 0) }):Play()
    task.delay(0.17, function()
      MiniFrame.Visible = false
      MiniFrame.Size = full
    end)
  end
end

-- POSIZIONE DI RIPOSO.
-- Prima sia la chiusura sia l'apertura facevano "restPos = Main.Position".
-- Va bene solo se la finestra e' ferma: se spammi chiudi/apri, la seconda
-- chiamata legge la Position mentre il tween e' gia' a meta' strada FUORI
-- schermo e se la porta a casa come posizione di riposo. Al giro dopo
-- l'offset fuori schermo viene calcolato a partire da quella, e cosi' via:
-- ogni spam raddoppia la distanza, finche' la hub non si pianta a
-- coordinate negative enormi e non rientra piu'.
-- Qui la posizione di riposo NON si legge mai da Main.Position: e' un valore
-- a se', scritto solo quando l'utente trascina la finestra (l'handler su
-- Position, che durante l'animazione si tira fuori). L'animazione quindi non
-- puo' piu' inquinarla, per quanto la si spammi.
-- In piu' la posizione viene riportata dentro lo schermo: se per qualunque
-- motivo fosse gia' finita fuori, al primo uso torna raggiungibile.
_G._AmbitiousHubRest = function()
  local p = _G._AmbitiousHubRestPos or Main.Position
  local cam = workspace.CurrentCamera
  local vp  = (cam and cam.ViewportSize) or Vector2.new(1920, 1080)
  if vp.X < 1 or vp.Y < 1 then vp = Vector2.new(1920, 1080) end
  local sz = Main.AbsoluteSize
  local sw = (sz.X > 1) and sz.X or 324
  local sh = (sz.Y > 1) and sz.Y or 576
  local cx = p.X.Scale * vp.X + p.X.Offset
  local cy = p.Y.Scale * vp.Y + p.Y.Offset
  -- almeno un quarto di finestra dentro lo schermo, su ogni lato
  local ncx = math.clamp(cx, sw * 0.25, math.max(vp.X - sw * 0.25, sw * 0.25))
  local ncy = math.clamp(cy, sh * 0.15, math.max(vp.Y - sh * 0.15, sh * 0.15))
  if math.abs(ncx - cx) > 0.5 or math.abs(ncy - cy) > 0.5 then
    p = UDim2.new(p.X.Scale, p.X.Offset + (ncx - cx), p.Y.Scale, p.Y.Offset + (ncy - cy))
    _G._AmbitiousHubRestPos = p
    savedMainPositionTable = udim2ToTable(p)
  end
  return p
end

-- CHIUSURA: scivola fuori dal bordo piu' vicino
_G.AmbitiousHubClose = function(showMini)
  -- Lo stato lo decidono queste due funzioni, non chi le chiama: prima il
  -- bottone "-" si fidava del proprio flag, che restava disallineato se la
  -- hub era stata riaperta dal mini popup o dal keybind. Risultato: il
  -- primo click non faceva niente e serviva cliccare due volte.
  _G.__AmbitiousDuelsMinimized = true
  if not Main.Visible then
    if showMini then _G._AmbitiousMiniPop(true) end
    return
  end
  _G._AmbitiousHubAnimToken = _G._AmbitiousHubAnimToken + 1
  local token = _G._AmbitiousHubAnimToken
  _G._AmbitiousHubAnimating = true

  local restPos = _G._AmbitiousHubRest()
  local restSize = FULL_MAIN_SIZE or Main.Size
  local dir = _G._AmbitiousHubEdgeFor(restPos)
  local offPos = _G._AmbitiousHubOffscreen(restPos, dir)

  -- SOLO Position. Ne' Size ne' Rotation:
  --  * la Size rifa' il layout interno e le righe finiscono mozzate
  --  * la Rotation DISATTIVA il ClipsDescendants (un GuiObject ruotato in
  --    Roblox non clippa piu' i figli), ed e' per quello che i bottoni
  --    schizzavano fuori dalla finestra durante l'animazione
  TweenService:Create(Main,
    TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
    { Position = offPos }):Play()

  if showMini then
    task.delay(0.2, function()
      if token ~= _G._AmbitiousHubAnimToken then return end
      _G._AmbitiousMiniPop(true)
    end)
  end

  task.delay(0.4, function()
    if token ~= _G._AmbitiousHubAnimToken then return end
    Main.Visible  = false
    Main.Rotation = 0
    Main.Size     = restSize
    Main.Position = restPos
    _G._AmbitiousHubAnimating = false
  end)
end

-- APERTURA: rientra dallo stesso bordo con frenata elastica
_G.AmbitiousHubOpen = function()
  _G.__AmbitiousDuelsMinimized = false
  if _G.AmbitiousIdleWake then _G.AmbitiousIdleWake() end
  _G._AmbitiousHubAnimToken = _G._AmbitiousHubAnimToken + 1
  local token = _G._AmbitiousHubAnimToken
  _G._AmbitiousMiniPop(false)

  local restPos  = _G._AmbitiousHubRest()
  local restSize = FULL_MAIN_SIZE or Main.Size
  local dir = _G._AmbitiousHubEdgeFor(restPos)

  _G._AmbitiousHubAnimating = true
  Main.Size     = restSize   -- misura sempre piena: niente re-layout, niente tagli
  Main.Rotation = 0          -- mai ruotata: altrimenti smette di clippare i figli
  Main.Position = _G._AmbitiousHubOffscreen(restPos, dir)
  Main.Visible  = true

  -- Tutto il carattere sta nell'easing della Position: Back Out supera di
  -- poco il punto d'arrivo e rientra.
  TweenService:Create(Main,
    TweenInfo.new(0.52, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    { Position = restPos }):Play()

  task.delay(0.6, function()
    if token ~= _G._AmbitiousHubAnimToken then return end
    Main.Rotation = 0
    Main.Size     = restSize
    Main.Position = restPos
    _G._AmbitiousHubAnimating = false
  end)
end
-- <<< HUB OPEN/CLOSE ANIMATION END

-- >>> IDLE FADE BEGIN
-- 5 secondi senza toccare la hub -> tutto il contenuto va a 0.7 di
-- trasparenza. Al primo contatto torna com'era. Lo sfondo non si tocca.
--
-- COME, e perche' cosi': i tentativi precedenti scrivevano la trasparenza su
-- ogni singolo elemento, cioe' sulle STESSE proprieta' che usa l'effetto
-- hover delle righe. I due si pestavano i piedi e le righe restavano
-- inchiodate sullo stato di hover. Qui invece il contenuto viene messo
-- dentro un CanvasGroup e si anima solo la sua GroupTransparency: una
-- proprieta' sola, sul contenitore. Nessuna proprieta' dei figli viene mai
-- toccata, quindi l'hover continua a funzionare per conto suo e il
-- ripristino e' esatto per definizione.
--
-- NOTA LOCAL: niente local a livello di chunk, il main e' al limite.
_G._AmbitiousIdle = {
  delay    = 5,      -- secondi di inattivita'
  value    = 0.7,    -- trasparenza da raggiungere
  fadeOut  = 0.3,    -- durata dello sbiadire
  fadeIn   = 0.14,   -- durata del ritorno: corto, deve sembrare immediato
  last     = os.clock(),
  faded    = false,
  group    = nil,
  started  = false,
}

-- Cosa NON va spostato dentro il gruppo: lo sfondo e i modificatori di
-- layout, che devono restare figli diretti di Main.
_G._AmbitiousIdleStays = function(ch)
  if ch.Name == "JesusBackground" then return true end
  if ch:IsA("UICorner") or ch:IsA("UIStroke") or ch:IsA("UIScale")
     or ch:IsA("UIPadding") or ch:IsA("UIListLayout") or ch:IsA("UIGradient")
     or ch:IsA("UIAspectRatioConstraint") or ch:IsA("UISizeConstraint") then
    return true
  end
  return false
end

_G._AmbitiousIdleEnsureGroup = function()
  local S = _G._AmbitiousIdle
  if S.group and S.group.Parent then return S.group end

  local ok, g = pcall(function() return Instance.new("CanvasGroup") end)
  if not ok or not g then return nil end   -- client vecchio: si rinuncia, meglio che rompere

  g.Name = "AmbitiousFadeGroup"
  g.BackgroundTransparency = 1
  g.BorderSizePixel = 0
  g.Size = UDim2.new(1, 0, 1, 0)
  g.Position = UDim2.new(0, 0, 0, 0)
  g.ZIndex = 2                -- sopra lo sfondo (ZIndex 1), sotto niente
  g.GroupTransparency = 0
  g.Active = false            -- non intercetta input: il drag di Main resta com'e'
  g.Parent = Main

  for _, ch in ipairs(Main:GetChildren()) do
    if ch ~= g and not _G._AmbitiousIdleStays(ch) then
      ch.Parent = g
    end
  end

  -- Se qualcosa viene creato dopo e appeso a Main, entra anche lui.
  Main.ChildAdded:Connect(function(ch)
    if ch == g or _G._AmbitiousIdleStays(ch) then return end
    task.defer(function()
      if ch.Parent == Main then ch.Parent = g end
    end)
  end)

  S.group = g
  return g
end

_G._AmbitiousIdleSet = function(fade)
  local S = _G._AmbitiousIdle
  local g = _G._AmbitiousIdleEnsureGroup()
  if not g then return end
  S.faded = fade and true or false
  TweenService:Create(g,
    TweenInfo.new(fade and S.fadeOut or S.fadeIn,
                  Enum.EasingStyle.Quad,
                  fade and Enum.EasingDirection.Out or Enum.EasingDirection.Out),
    { GroupTransparency = fade and S.value or 0 }):Play()
end

_G.AmbitiousIdleWake = function()
  local S = _G._AmbitiousIdle
  S.last = os.clock()
  if S.faded then _G._AmbitiousIdleSet(false) end
end

_G.AmbitiousIdleStart = function()
  local S = _G._AmbitiousIdle
  if S.started then return end
  S.started = true

  -- mouse e touch sulla finestra
  Main.InputBegan:Connect(_G.AmbitiousIdleWake)
  Main.InputChanged:Connect(_G.AmbitiousIdleWake)
  Main.MouseEnter:Connect(_G.AmbitiousIdleWake)

  -- controller: non ha puntatore, si sveglia su qualsiasi input gamepad
  UserInputService.InputBegan:Connect(function(input)
    local t = input.UserInputType
    if t == Enum.UserInputType.Gamepad1 or t == Enum.UserInputType.Gamepad2
       or t == Enum.UserInputType.Gamepad3 or t == Enum.UserInputType.Gamepad4 then
      _G.AmbitiousIdleWake()
    end
  end)

  task.spawn(function()
    while true do
      task.wait(0.25)
      if Main.Visible and not _G._AmbitiousHubAnimating then
        if not S.faded and (os.clock() - S.last) >= S.delay then
          _G._AmbitiousIdleSet(true)
        end
      elseif S.faded then
        _G._AmbitiousIdleSet(false)
        S.last = os.clock()
      end
    end
  end)
end

task.defer(function()
  pcall(_G.AmbitiousIdleStart)
end)
-- <<< IDLE FADE END

local BackgroundIDs = { "ROMA_HUB_COLOSSEO" }
do
  currentBackground = 1
end

BgImage = Instance.new("ImageLabel")
BgImage.Name = "JesusBackground"
BgImage.BackgroundTransparency = 1
BgImage.ImageTransparency = 0
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Position = UDim2.new(0, 0, 0, 0)
BgImage.Visible = false
BgImage.ZIndex = 1
BgImage.ClipsDescendants = true
BgImage.Parent = Main
corner(BgImage, 14)

-- Header in forma Yout, usando esattamente le immagini di Roma Hub.
local RomaYoutHeader = Instance.new("Frame")
RomaYoutHeader.Name = "RomaYoutHeader"
RomaYoutHeader.Size = UDim2.new(1, -20, 0, 104)
RomaYoutHeader.Position = UDim2.new(0, 10, 0, 0)
RomaYoutHeader.BackgroundTransparency = 1
RomaYoutHeader.BorderSizePixel = 0
RomaYoutHeader.ZIndex = 8
RomaYoutHeader.Parent = Main
corner(RomaYoutHeader, 13)
-- Gesu Hub usa una sola foto di Gesu come sfondo della GUI.
BgImage.Image = ROMA_HUB_COLOSSEO_IMAGE
BgImage.Visible = ROMA_HUB_COLOSSEO_IMAGE ~= ""

MiniBg = Instance.new("ImageLabel")
MiniBg.Name = "MiniBg"
MiniBg.Size = UDim2.new(1, 0, 1, 0)
MiniBg.Position = UDim2.new(0, 0, 0, 0)
MiniBg.BackgroundTransparency = 1
MiniBg.ScaleType = Enum.ScaleType.Crop
MiniBg.ZIndex = 20
MiniBg.Visible = ROMA_HUB_COLOSSEO_IMAGE ~= ""
MiniBg.Parent = MiniFrame
local _miniBgCorner = Instance.new("UICorner")
_miniBgCorner.CornerRadius = UDim.new(0, 8)
_miniBgCorner.Parent = MiniBg

function applyBackground(index)
  currentBackground = 1
  local image = ROMA_HUB_COLOSSEO_IMAGE
  BgImage.Image = image
  BgImage.Visible = image ~= ""
  MiniBg.Image = image
  saveAmbitiousConfig()
  _G._AmbitiousBgIndex = currentBackground
  _G._AmbitiousBgCustom = false
  if _G._AmbitiousApplyAccent then pcall(_G._AmbitiousApplyAccent) end
  if _G.AmbitiousRefreshMobileButtonBackgrounds then pcall(_G.AmbitiousRefreshMobileButtonBackgrounds) end
  return "Gesu Hub Background"
end

applyBackground(1)
_G._AmbitiousBgIndex = currentBackground
_G._AmbitiousBgCustom = false
if _G._AmbitiousApplyAccent then pcall(_G._AmbitiousApplyAccent) end

-- Header: discord tag compatto.
-- RIMOSSO IL LINK DISCORD
local HeaderDivider = Instance.new("Frame")
HeaderDivider.Name = "HeaderDivider"
HeaderDivider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HeaderDivider.BackgroundTransparency = 0
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Size = UDim2.new(1, -34, 0, 1)
HeaderDivider.Position = UDim2.new(0, 17, 0, 68)
HeaderDivider.ZIndex = 6
HeaderDivider.Parent = Main

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Close.BackgroundTransparency = 0.28
Close.Text = "-"
Close.TextColor3 = Color3.fromRGB(0, 0, 0)
Close.TextSize = 22
Close.Font = Enum.Font.GothamSemibold
Close.Size = UDim2.new(0, 32, 0, 28)
Close.Position = UDim2.new(1, -42, 0, 10)
Close.AutoButtonColor = false
Close.ZIndex = 5
Close.Parent = Main
corner(Close, 8)
stroke(Close, COLORS.stroke, 1, 0.35)

AmbitiousLockTopButton = Instance.new("TextButton")
AmbitiousLockTopButton.Name = "LockGUI"
AmbitiousLockTopButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AmbitiousLockTopButton.BackgroundTransparency = 0.28
AmbitiousLockTopButton.TextColor3 = Color3.fromRGB(0, 0, 0)
AmbitiousLockTopButton.TextSize = 8
AmbitiousLockTopButton.Font = Enum.Font.GothamBlack
AmbitiousLockTopButton.Size = UDim2.new(0, 32, 0, 28)
AmbitiousLockTopButton.Position = UDim2.new(0, 12, 0, 10)   -- spostato a sinistra
AmbitiousLockTopButton.AutoButtonColor = false
AmbitiousLockTopButton.ZIndex = 5
AmbitiousLockTopButton.Parent = Main
corner(AmbitiousLockTopButton, 8)
stroke(AmbitiousLockTopButton, COLORS.stroke, 1, 0.35)

function AmbitiousUpdateGuiLockVisual()
  if AmbitiousLockTopButton then
    AmbitiousLockTopButton.Text = (_G.AmbitiousGuiLocked == true) and "UNLOCK" or "LOCK"
    AmbitiousLockTopButton.BackgroundTransparency = (_G.AmbitiousGuiLocked == true) and 0.08 or 0.28
    local st = AmbitiousLockTopButton:FindFirstChildOfClass("UIStroke")
    if st then
      st.Transparency = (_G.AmbitiousGuiLocked == true) and 0.08 or 0.35
      st.Color = (_G.AmbitiousGuiLocked == true) and Color3.fromRGB(255,255,255) or COLORS.stroke
    end
  end
  if setLockGuiVisual then pcall(setLockGuiVisual, _G.AmbitiousGuiLocked == true) end
end

AmbitiousLockTopButton.Activated:Connect(function()
  _G.AmbitiousGuiLocked = not (_G.AmbitiousGuiLocked == true)
  AmbitiousUpdateGuiLockVisual()
  saveAmbitiousConfig()
end)
AmbitiousUpdateGuiLockVisual()

-- Layout GUI in stile Yout: header alto, tab orizzontali compatte e contenuto scrollabile.
-- Le pagine e tutte le impostazioni di Roma Hub restano invariate.
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 10, 0, 76)
Content.Size = UDim2.new(1, -20, 1, -140)
Content.ZIndex = 20
Content.Parent = Main

local Tabs = Instance.new("Frame")
Tabs.Name = "Tabs"
Tabs.BackgroundTransparency = 1
Tabs.Position = UDim2.new(0, 10, 0, 76)
Tabs.Size = UDim2.new(1, -20, 0, 44)
Tabs.ZIndex = 40
Tabs.Parent = Main

local Vx7Nav = Instance.new("Frame")
Vx7Nav.Name = "VX7TopNavigation"
Vx7Nav.Size = UDim2.new(1, -20, 0, 44)
Vx7Nav.Position = UDim2.new(0, 10, 0, 76)
Vx7Nav.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
Vx7Nav.BackgroundTransparency = 0.12
Vx7Nav.BorderSizePixel = 0
Vx7Nav.ZIndex = 39
Vx7Nav.Parent = Main
corner(Vx7Nav, 13)
stroke(Vx7Nav, Color3.fromRGB(75,75,85), 0.8, 0.38)
local vxNavGrad = Instance.new("UIGradient")
vxNavGrad.Rotation = 90
vxNavGrad.Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,36)),
  ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18,18,23)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(30,30,36)),
})
vxNavGrad.Parent = Vx7Nav

-- Nessun pannello nero/trasparente dietro le sezioni: il contenuto resta direttamente
-- sopra la foto di Roma, come richiesto. Le singole righe mantengono il loro stile.
local Vx7ContentPanel = nil

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 3)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Parent = Tabs

local pages = {}
local tabButtons = {}
local tabNames = {"MOVEMENT", "COMBAT", "KEYBINDS", "VISUALS", "SETTINGS"}
local activeTab = "MOVEMENT"

function addPage(name)
  local page = Instance.new("ScrollingFrame")
  page.Name = name
  page.BackgroundTransparency = 1
  page.BorderSizePixel = 0
  page.ScrollBarThickness = 3
  page.ScrollBarImageTransparency = 0.35
  page.CanvasSize = UDim2.new(0, 0, 0, 0)
  page.AutomaticCanvasSize = Enum.AutomaticSize.Y
  page.Size = UDim2.new(1, 0, 1, 0)
  page.ZIndex = 21
  page.Visible = false
  page.Parent = Content
  local layout = Instance.new("UIListLayout")
  layout.Padding = UDim.new(0, 7)
  layout.SortOrder = Enum.SortOrder.LayoutOrder
  layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
  layout.Parent = page
  local pagePadding = Instance.new("UIPadding")
  pagePadding.Name = "PagePad"
  pagePadding.PaddingBottom = UDim.new(0, 12)
  pagePadding.Parent = page
  pages[name] = page
  if _G._AmbitiousApplyPagePadding then _G._AmbitiousApplyPagePadding() end
  return page
end


function setTab(name)
  if not pages[name] then return end
  activeTab = name
  for pageName, page in pairs(pages) do
    page.Visible = (pageName == name)
    page.Active = (pageName == name)
    page.ZIndex = (pageName == name) and 21 or 20
  end
  if name == "SETTINGS" and pages.SETTINGS then
    pages.SETTINGS.CanvasPosition = Vector2.new(0, 0)
  end
  for tabName, btn in pairs(tabButtons) do
    local on = (tabName == name)
    btn.Active = true
    btn.Selectable = true
    btn.TextColor3 = on and COLORS.txt or COLORS.txtDim
    btn.BackgroundColor3 = on and COLORS.stroke or COLORS.row
    btn.BackgroundTransparency = on and 0.15 or 0.35
    btn.ZIndex = 30
    local st = btn:FindFirstChildOfClass("UIStroke")
    if st then
      st.Transparency = on and 0.3 or 0.65
      st.Color = COLORS.stroke
    end
    local ul = btn:FindFirstChild("Underline")
    if ul then ul.Visible = on end
  end
end

for _, name in ipairs(tabNames) do
  addPage(name)
  local btn = Instance.new("TextButton")
  btn.Name = name
  btn.Size = UDim2.new(1/5, -5, 1, -8)
  btn.BackgroundColor3 = COLORS.row
  btn.BackgroundTransparency = 1
  btn.BorderSizePixel = 0
  btn.Text = ({MOVEMENT="MOVE", COMBAT="COMBAT", KEYBINDS="KEYS", VISUALS="VISUAL", SETTINGS="SETTINGS"})[name] or name
  btn.TextColor3 = COLORS.txtDim
  btn.TextSize = 10
  btn.Font = Enum.Font.GothamBlack
  btn.AutoButtonColor = false
  btn.ZIndex = 45
  btn.Parent = Tabs
  corner(btn, 10)
  stroke(btn, COLORS.stroke, 1.2, 1)

  local underline = Instance.new("Frame")
  underline.Name = "Underline"
  underline.Size = UDim2.new(0.64, 0, 0, 3)
  underline.Position = UDim2.new(0.5, 0, 1, -2)
  underline.AnchorPoint = Vector2.new(0.5, 0)
  underline.BackgroundColor3 = COLORS.stroke
  underline.BorderSizePixel = 0
  underline.Visible = false
  underline.ZIndex = 46
  underline.Parent = btn
  corner(underline, 3)

  tabButtons[name] = btn
  btn.Activated:Connect(function()
    setTab(name)
  end)
  btn.MouseEnter:Connect(function()
    if activeTab == name then return end
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.55, TextColor3 = COLORS.txt}):Play()
  end)
  btn.MouseLeave:Connect(function()
    if activeTab == name then return end
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = COLORS.txtDim}):Play()
  end)
end

-- Fixed Yout-style tab geometry. Tab Position customization is removed.
Tabs.Position = UDim2.new(0, 10, 0, 76)
Tabs.Size = UDim2.new(1, -20, 0, 44)
Content.Position = UDim2.new(0, 10, 0, 128)
Content.Size = UDim2.new(1, -20, 1, -138)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 3)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

function section(parent, text, order)
  local label = Instance.new("TextLabel")
  label.Name = text
  label.BackgroundTransparency = 1
  label.Text = text
  label.TextColor3 = Color3.fromRGB(255, 220, 70)
  label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  label.TextStrokeTransparency = 0.35
  label.TextSize = 15
  label.Font = Enum.Font.GothamBlack
  label.TextXAlignment = Enum.TextXAlignment.Left
  label.Size = UDim2.new(1, -6, 0, 17)
  label.LayoutOrder = order
  label.ZIndex = 8
  label.Parent = parent
  return label
end

function baseRow(parent, labelText, order)
  local row = Instance.new("Frame")
  row.Name = labelText
  row.BackgroundColor3 = COLORS.row
  row.BackgroundTransparency = 0.3
  row.Size = UDim2.new(1, -4, 0, 38)
  row.BorderSizePixel = 0
  row.LayoutOrder = order
  row.ZIndex = 4
  row.Parent = parent
  corner(row, 9)
  stroke(row, COLORS.strokeSoft, 1.15, 0.38)
  local label = Instance.new("TextLabel")
  label.Name = "Label"
  label.BackgroundTransparency = 1
  label.Text = labelText
  label.TextColor3 = Color3.fromRGB(0, 0, 0)
  label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
  label.TextStrokeTransparency = 0.6
  label.TextSize = 14
  label.Font = Enum.Font.GothamBold
  label.TextXAlignment = Enum.TextXAlignment.Left
  label.Position = UDim2.new(0, 12, 0, 0)
  label.Size = UDim2.new(1, -132, 1, 0)
  label.ZIndex = 5
  label.Parent = row
  -- L'hover scrive sulla stessa proprieta' che usa la dissolvenza idle.
  -- Mentre la hub e' sbiadita o in transizione l'hover viene ignorato:
  -- altrimenti il suo tween finiva DOPO il ripristino e la riga restava
  -- inchiodata al valore di hover (piu' scura) finche' non ci si ripassava
  -- sopra per far scattare il MouseLeave.
  row.MouseEnter:Connect(function()
    tween(row, {BackgroundTransparency = 0.22})
  end)
  row.MouseLeave:Connect(function()
    tween(row, {BackgroundTransparency = 0.3})
  end)
  return row
end

function textboxRow(parent, labelText, value, order)
  local row = baseRow(parent, labelText, order)
  local box = Instance.new("TextBox")
  box.Name = "ValueBox"
  box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  box.BackgroundTransparency = 0.18
  box.Text = tostring(value or "")
  box.TextColor3 = Color3.fromRGB(0, 0, 0)
  box.TextSize = 14
  box.Font = Enum.Font.GothamBold
  box.ClearTextOnFocus = false
  box.Size = UDim2.new(0, 58, 0, 24)
  box.Position = UDim2.new(1, -68, 0.5, -12)
  box.BorderSizePixel = 0
  box.ZIndex = 6
  box.Parent = row
  corner(box, 7)
  stroke(box, COLORS.strokeSoft, 1, 0.45)
  return row, box
end

function toggleRow(parent, labelText, default, order)
  local row = baseRow(parent, labelText, order)
  local button = Instance.new("TextButton")
  button.Name = "ToggleButton"
  button.BackgroundTransparency = 1
  button.Text = ""
  button.Size = UDim2.new(1, 0, 1, 0)
  button.Position = UDim2.new(0, 0, 0, 0)
  button.AutoButtonColor = false
  button.ZIndex = 7
  button.Parent = row
  local track = Instance.new("Frame")
  track.Name = "Track"
  track.BackgroundColor3 = COLORS.toggleBg
  track.BackgroundTransparency = 0.12
  track.Size = UDim2.new(0, 48, 0, 24)
  track.Position = UDim2.new(1, -58, 0.5, -12)
  track.BorderSizePixel = 0
  track.ClipsDescendants = false
  track.ZIndex = 5
  track.Parent = button
  corner(track, 11)
  stroke(track, COLORS.strokeSoft, 1.3, 0.4)

  -- Riempimento viola che sfuma quando il toggle e' acceso
  local fill = Instance.new("Frame")
  fill.Name = "Fill"
  fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  fill.BackgroundTransparency = default and 0 or 1
  fill.Size = UDim2.new(1, 0, 1, 0)
  fill.BorderSizePixel = 0
  fill.ZIndex = 5
  fill.Parent = track
  corner(fill, 11)
  local fillGrad = Instance.new("UIGradient")
  fillGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
  })
  fillGrad.Rotation = 18
  fillGrad.Parent = fill

  local knob = Instance.new("Frame")
  knob.Name = "Knob"
  knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  knob.Size = UDim2.new(0, 18, 0, 18)
  knob.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
  knob.BorderSizePixel = 0
  knob.ZIndex = 7
  knob.Parent = track
  corner(knob, 999)
  local knobStroke = Instance.new("UIStroke")
  knobStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  knobStroke.Color = default and Color3.fromRGB(255, 220, 70) or Color3.fromRGB(255, 220, 70)
  knobStroke.Thickness = 1.4
  knobStroke.Transparency = 0.15
  knobStroke.Parent = knob
  local shine = Instance.new("Frame")
  shine.Name = "Shine"
  shine.BackgroundColor3 = COLORS.white
  shine.BackgroundTransparency = 0.55
  shine.Size = UDim2.new(1, -5, 0, 5)
  shine.Position = UDim2.new(0, 2.5, 0, 2.5)
  shine.BorderSizePixel = 0
  shine.ZIndex = 8
  shine.Parent = knob
  corner(shine, 5)
  _G._AmbitiousRegAccent(fill, fillGrad, "toggle", track, knob, row)
  local state = default and true or false
  local trackStroke = track:FindFirstChildOfClass("UIStroke")
  local rowStroke = row:FindFirstChildOfClass("UIStroke")
  local function setVisual(on)
    state = on and true or false
    tween(knob, {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)})
    local _onBg, _onEdge = _G._AmbitiousToggleOnColor()
    tween(track, {
      BackgroundTransparency = state and 0 or 0.12,
      BackgroundColor3 = state and _onBg or COLORS.toggleBg
    })
    tween(fill, { BackgroundTransparency = state and 0 or 1 })
    tween(knobStroke, {
      Color = state and _onEdge or Color3.fromRGB(255, 220, 70)
    })
    if trackStroke then
      tween(trackStroke, {
        Color = state and _onEdge or COLORS.strokeSoft,
        Transparency = state and 0 or 0.4,
        Thickness = 1.4
      })
    end
    if rowStroke then
      tween(rowStroke, {
        Color = state and _onBg or COLORS.strokeSoft,
        Transparency = state and 0.08 or 0.38,
        Thickness = 1.25
      })
    end
  end
  setVisual(state)
  button.Activated:Connect(function() end)
  return row, setVisual
end

_G.AmbitiousSyncToggleVisuals = function()
  pcall(function() if setAutoStealVisual then setAutoStealVisual(autoStealEnabled == true) end end)
  pcall(function() if _G._AmbitiousSyncAfterHit.setVisual then _G._AmbitiousSyncAfterHit.setVisual(_G._AmbitiousSyncAfterHit.enabled == true) end end)
  pcall(function() if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end end)
  pcall(function() if _SV.setLookAtVisual then _SV.setLookAtVisual(_G.AmbitiousLookAtEnabled == true) end end)
  pcall(function() if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end end)
  pcall(function() if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end end)
  pcall(function() if _G.AmbitiousRefreshAutoCarryModeSelector then _G.AmbitiousRefreshAutoCarryModeSelector() end end)
  pcall(function() if _SV.setAutoTPVisual then _SV.setAutoTPVisual(autoTPEnabled == true) end end)
end

_G.AmbitiousActionToggleRow = function(parent, labelText, default, order)
  local row = baseRow(parent, labelText, order)
  local button = Instance.new("TextButton")
  button.Name = "ToggleButton"
  button.BackgroundTransparency = 1
  button.Text = ""
  button.Size = UDim2.new(1, 0, 1, 0)
  button.Position = UDim2.new(0, 0, 0, 0)
  button.AutoButtonColor = false
  button.ZIndex = 7
  button.Parent = row
  local track = Instance.new("Frame")
  track.Name = "Track"
  track.BackgroundColor3 = COLORS.toggleBg
  track.BackgroundTransparency = 0.12
  track.Size = UDim2.new(0, 44, 0, 22)
  track.Position = UDim2.new(1, -54, 0.5, -11)
  track.BorderSizePixel = 0
  track.ClipsDescendants = false
  track.ZIndex = 5
  track.Parent = button
  corner(track, 11)
  stroke(track, COLORS.strokeSoft, 1.3, 0.4)

  -- Riempimento viola che sfuma quando il toggle e' acceso
  local fill = Instance.new("Frame")
  fill.Name = "Fill"
  fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  fill.BackgroundTransparency = default and 0 or 1
  fill.Size = UDim2.new(1, 0, 1, 0)
  fill.BorderSizePixel = 0
  fill.ZIndex = 5
  fill.Parent = track
  corner(fill, 11)
  local fillGrad = Instance.new("UIGradient")
  fillGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
  })
  fillGrad.Rotation = 18
  fillGrad.Parent = fill

  local knob = Instance.new("Frame")
  knob.Name = "Knob"
  knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  knob.Size = UDim2.new(0, 16, 0, 16)
  knob.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
  knob.BorderSizePixel = 0
  knob.ZIndex = 7
  knob.Parent = track
  corner(knob, 999)
  local knobStroke = Instance.new("UIStroke")
  knobStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  knobStroke.Color = default and Color3.fromRGB(255, 220, 70) or Color3.fromRGB(255, 220, 70)
  knobStroke.Thickness = 1.4
  knobStroke.Transparency = 0.15
  knobStroke.Parent = knob
  local shine = Instance.new("Frame")
  shine.Name = "Shine"
  shine.BackgroundColor3 = COLORS.white
  shine.BackgroundTransparency = 0.55
  shine.Size = UDim2.new(1, -5, 0, 5)
  shine.Position = UDim2.new(0, 2.5, 0, 2.5)
  shine.BorderSizePixel = 0
  shine.ZIndex = 8
  shine.Parent = knob
  corner(shine, 5)
  _G._AmbitiousRegAccent(fill, fillGrad, "toggle", track, knob, row)
  local trackStroke = track:FindFirstChildOfClass("UIStroke")
  local rowStroke = row:FindFirstChildOfClass("UIStroke")
  local function setVisual(on)
    local state = on and true or false
    tween(knob, {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)})
    local _onBg, _onEdge = _G._AmbitiousToggleOnColor()
    tween(track, {
      BackgroundTransparency = state and 0 or 0.12,
      BackgroundColor3 = state and _onBg or COLORS.toggleBg
    })
    tween(fill, { BackgroundTransparency = state and 0 or 1 })
    tween(knobStroke, {
      Color = state and _onEdge or Color3.fromRGB(255, 220, 70)
    })
    if trackStroke then
      tween(trackStroke, {
        Color = state and _onEdge or COLORS.strokeSoft,
        Transparency = state and 0 or 0.4,
        Thickness = 1.4
      })
    end
    if rowStroke then
      tween(rowStroke, {
        Color = state and _onBg or COLORS.strokeSoft,
        Transparency = state and 0.08 or 0.38,
        Thickness = 1.25
      })
    end
  end
  setVisual(default)
  return row, setVisual, button
end

function dropdownRow(parent, labelText, value, order)
  local row = baseRow(parent, labelText, order)
  local select = Instance.new("TextButton")
  select.Name = "Dropdown"
  select.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  select.BackgroundTransparency = 0.18
  select.Text = tostring(value or "None") .. "  â–¼"
  select.TextColor3 = Color3.fromRGB(0, 0, 0)
  select.TextSize = 11
  select.Font = Enum.Font.GothamSemibold
  select.Size = UDim2.new(0, 70, 0, 24)
  select.Position = UDim2.new(1, -80, 0.5, -12)
  select.BorderSizePixel = 0
  select.ZIndex = 6
  select.Parent = row
  corner(select, 7)
  stroke(select, COLORS.strokeSoft, 1, 0.45)
  return row, select
end

-- RIMOSSA TUTTA LA LOGICA ANIMATION PACK

function keyName(key)
  if not key then return "None" end
  if key == "MB3" then return "MB3" end
  local name = tostring(key):gsub("Enum.KeyCode.", "")
  name = name:gsub("Button", "BTN ")
  name = name:gsub("DPad", "DPad ")
  return name
end

function refreshSpeedKeybindButton(keyId)
  local btn = speedKeybindButtons[keyId]
  if btn then
    if listeningForSpeedKey == keyId then
      btn.Text = "Press..."
    else
      btn.Text = keyName(speedKeybinds[keyId])
    end
  end
end

function refreshAllSpeedKeybinds()
  for keyId in pairs(speedKeybindButtons) do
    refreshSpeedKeybindButton(keyId)
  end
end

function refreshTPDownKeybind()
  if tpDownKeybindButton then
    tpDownKeybindButton.Text = listeningForTPDownKey and "Press..." or keyName(tpDownKeybind)
  end
end

function tpDownKeybindRow(parent, order)
  local row = baseRow(parent, "TP Down", order)
  local btn = Instance.new("TextButton")
  btn.Name = "TPDownKeybindButton"
  btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  btn.BackgroundTransparency = 0.18
  btn.Text = keyName(tpDownKeybind)
  btn.TextColor3 = Color3.fromRGB(0, 0, 0)
  btn.TextSize = 11
  btn.Font = Enum.Font.GothamSemibold
  btn.Size = UDim2.new(0, 56, 0, 24)
  btn.Position = UDim2.new(1, -64, 0.5, -12)
  btn.BorderSizePixel = 0
  btn.ZIndex = 6
  btn.AutoButtonColor = false
  btn.Parent = row
  corner(btn, 7)
  stroke(btn, COLORS.strokeSoft, 1, 0.45)
  local clearBtn = Instance.new("TextButton")
  clearBtn.Name = "ClearKeybindButton"
  clearBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  clearBtn.BackgroundTransparency = 0.18
  clearBtn.Text = "Ã—"
  clearBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
  clearBtn.TextSize = 14
  clearBtn.Font = Enum.Font.GothamBlack
  clearBtn.Size = UDim2.new(0, 22, 0, 24)
  clearBtn.Position = UDim2.new(1, -90, 0.5, -12)
  clearBtn.BorderSizePixel = 0
  clearBtn.ZIndex = 6
  clearBtn.AutoButtonColor = false
  clearBtn.Parent = row
  corner(clearBtn, 7)
  stroke(clearBtn, COLORS.strokeSoft, 1, 0.45)
  tpDownKeybindButton = btn
  btn.Activated:Connect(function()
    listeningForSpeedKey = nil
    listeningForTPDownKey = true
    keybindListenStartedAt = tick()
    refreshAllSpeedKeybinds()
    refreshTPDownKeybind()
  end)
  clearBtn.Activated:Connect(function()
    listeningForSpeedKey = nil
    listeningForTPDownKey = false
    tpDownKeybind = nil
    if tpDownKeybindButton then tpDownKeybindButton.Text = "None" end
    refreshAllSpeedKeybinds()
    refreshTPDownKeybind()
    saveAmbitiousConfig()
  end)
  return row, btn
end

function speedKeybindRow(parent, labelText, keyId, order)
  local row = baseRow(parent, labelText, order)
  local btn = Instance.new("TextButton")
  btn.Name = "KeybindButton"
  btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  btn.BackgroundTransparency = 0.18
  btn.Text = keyName(speedKeybinds[keyId])
  btn.TextColor3 = Color3.fromRGB(0, 0, 0)
  btn.TextSize = 11
  btn.Font = Enum.Font.GothamSemibold
  btn.Size = UDim2.new(0, 56, 0, 24)
  btn.Position = UDim2.new(1, -64, 0.5, -12)
  btn.BorderSizePixel = 0
  btn.ZIndex = 6
  btn.AutoButtonColor = false
  btn.Parent = row
  corner(btn, 7)
  stroke(btn, COLORS.strokeSoft, 1, 0.45)
  local clearBtn = Instance.new("TextButton")
  clearBtn.Name = "ClearKeybindButton"
  clearBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  clearBtn.BackgroundTransparency = 0.18
  clearBtn.Text = "Ã—"
  clearBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
  clearBtn.TextSize = 14
  clearBtn.Font = Enum.Font.GothamBlack
  clearBtn.Size = UDim2.new(0, 22, 0, 24)
  clearBtn.Position = UDim2.new(1, -90, 0.5, -12)
  clearBtn.BorderSizePixel = 0
  clearBtn.ZIndex = 6
  clearBtn.AutoButtonColor = false
  clearBtn.Parent = row
  corner(clearBtn, 7)
  stroke(clearBtn, COLORS.strokeSoft, 1, 0.45)
  speedKeybindButtons[keyId] = btn
  btn.Activated:Connect(function()
    listeningForSpeedKey = keyId
    listeningForTPDownKey = false
    keybindListenStartedAt = tick()
    refreshAllSpeedKeybinds()
    refreshTPDownKeybind()
  end)
  clearBtn.Activated:Connect(function()
    listeningForSpeedKey = nil
    listeningForTPDownKey = false
    speedKeybinds[keyId] = nil
    if speedKeybindButtons[keyId] then speedKeybindButtons[keyId].Text = "None" end
    refreshAllSpeedKeybinds()
    refreshTPDownKeybind()
    saveAmbitiousConfig()
  end)
  return row, btn
end

local normalModeValueLabel = nil
local aimbotButtonLabel = nil
local aimbotSpeedLabel = nil
local laggerAimbotSpeedLabel = nil
local combatAimbotKeybindLabel = nil


function getAimbotModeDisplay()
  return "Bat Bypass"
end

function refreshAimbotButtonLabel()
  if aimbotButtonLabel then
    aimbotButtonLabel.Text = "Bat Bypass"
  end
end

function refreshAimbotModeLabels()
  if aimbotSpeedLabel then aimbotSpeedLabel.Text = "Bat Bypass Speed" end
  if laggerAimbotSpeedLabel then laggerAimbotSpeedLabel.Text = "Bat Bypass Lagger Speed" end
  if combatAimbotKeybindLabel then combatAimbotKeybindLabel.Text = "Bat Bypass" end
  refreshAimbotButtonLabel()
  pcall(function()
    local mobileButtons = _G.AmbitiousMobileButtonRefs
    local aimbotEntry = mobileButtons and mobileButtons.aimbot
    local aimbotMobileBtn = aimbotEntry and aimbotEntry.btn
    if aimbotMobileBtn then
      aimbotMobileBtn.Text = ""
      local aimbotText = aimbotMobileBtn:FindFirstChild("ButtonText")
      if aimbotText then aimbotText.Text = "BAT\nAIMBOT" end
    end
  end)
  if _G._AmbHideOptLabel_aimbot then pcall(_G._AmbHideOptLabel_aimbot) end
end

refreshSpeedModeRows = function()
  if normalModeValueLabel then
    -- Mostra la modalitÃ  corrente completa
    normalModeValueLabel.Text = currentSpeedMode
  end
end

-- MODE ROW COMBINATA (rimossa la seconda)
function modeDisplayRow(parent, order)
  local row = baseRow(parent, "Mode", order)
  row.Size = UDim2.new(1, -4, 0, 42)
  -- Qui c'era BackgroundTransparency = 0.42, che sovrascriveva lo 0.3 di
  -- baseRow: la riga nasceva piu' chiara di tutte le altre e diventava
  -- uguale solo dopo il primo passaggio del mouse, perche' e' il MouseLeave
  -- di baseRow a riportarla a 0.3.
  local label = row:FindFirstChild("Label")
  if label then
    label.Text = "Mode"
    label.TextSize = 13
    label.Size = UDim2.new(0, 110, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
  end
  local value = Instance.new("TextLabel")
  value.Name = "ModeValue"
  value.BackgroundTransparency = 1
  value.Text = currentSpeedMode
  value.TextColor3 = Color3.fromRGB(0, 0, 0)
  value.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
  value.TextStrokeTransparency = 0.6
  value.TextSize = 13
  value.Font = Enum.Font.GothamBold
  value.TextXAlignment = Enum.TextXAlignment.Right
  value.Position = UDim2.new(1, -132, 0, 0)
  value.Size = UDim2.new(0, 120, 1, 0)
  value.ZIndex = 6
  value.Parent = row
  local click = Instance.new("TextButton")
  click.Name = "ModeClick"
  click.BackgroundTransparency = 1
  click.Text = ""
  click.Size = UDim2.new(1, 0, 1, 0)
  click.Position = UDim2.new(0, 0, 0, 0)
  click.AutoButtonColor = false
  click.ZIndex = 8
  click.Parent = row
  normalModeValueLabel = value
  click.MouseButton1Click:Connect(function()
    local mode = currentSpeedMode
    if mode == "Normal" then
      setSpeedMode("Carry")
    elseif mode == "Carry" then
      setSpeedMode("Normal")
    elseif mode == "Lagger" then
      setSpeedMode("Lagger Carry")
    elseif mode == "Lagger Carry" then
      setSpeedMode("Lagger")
    else
      setSpeedMode("Normal")
    end
  end)
  refreshSpeedModeRows()
  return row, value
end

function aimbotModeButtonRow(parent, order)
  -- Roma UI wired to the Clean-source Bat Bypass.
  selectedAimbotMode = "Bat Bypass"
  local row, setVisual = toggleRow(parent, "Bat Bypass", _G.AmbitiousBatAimbotV2On == true, order)
  aimbotButtonLabel = row and row:FindFirstChild("Label")
  _G.AmbitiousAimbotSetVisual = setVisual
  local btn = row and row:FindFirstChild("ToggleButton")
  if btn then
    btn.Activated:Connect(function()
      if _G.AmbitiousToggleSelectedAimbot then
        _G.AmbitiousToggleSelectedAimbot()
      end
      if _G.AmbitiousRefreshAimbotVisual then _G.AmbitiousRefreshAimbotVisual() end
    end)
  end
  refreshAimbotModeLabels()
  if _G.AmbitiousRefreshAimbotVisual then _G.AmbitiousRefreshAimbotVisual() end
  return row, setVisual
end

function autoStealSelectorRow(parent, order)
  local holder = Instance.new("Frame")
  holder.Name = "Auto Steal Mode"
  holder.BackgroundColor3 = COLORS.row
  holder.BackgroundTransparency = 0.28
  holder.Size = UDim2.new(1, -4, 0, 42)
  holder.BorderSizePixel = 0
  holder.LayoutOrder = order
  holder.ZIndex = 4
  holder.ClipsDescendants = true
  holder.Parent = parent
  corner(holder, 14)
  stroke(holder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
  _G._AmbitiousRegAccent(holder, nil, "soft")

  local slide = Instance.new("Frame")
  slide.Name = "SelectedSlide"
  slide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  slide.BackgroundTransparency = 0.1
  slide.Size = UDim2.new(0.5, -3, 1, -8)
  slide.Position = UDim2.new(0, 4, 0, 4)
  slide.BorderSizePixel = 0
  slide.ZIndex = 5
  slide.Parent = holder
  corner(slide, 13)
  local slideStroke = Instance.new("UIStroke")
  slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  slideStroke.Color = Color3.fromRGB(255, 220, 70)
  slideStroke.Thickness = 1.5
  slideStroke.Transparency = 0.1
  slideStroke.Parent = slide
  local slideGradient = Instance.new("UIGradient")
  slideGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
  })
  slideGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.08),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.08),
  })
  slideGradient.Parent = slide
  _G._AmbitiousRegAccent(slide, slideGradient, "slide")
  slideGradient.Rotation = 22

  local normalText = Instance.new("TextLabel")
  normalText.Name = "NormalText"
  normalText.BackgroundTransparency = 1
  normalText.Text = "NORMAL"
  normalText.TextColor3 = Color3.fromRGB(0, 0, 0)
  normalText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  normalText.TextStrokeTransparency = 0.2
  normalText.TextSize = 11
  normalText.Font = Enum.Font.GothamBlack
  normalText.TextXAlignment = Enum.TextXAlignment.Center
  normalText.Size = UDim2.new(0.5, 0, 1, 0)
  normalText.Position = UDim2.new(0, 0, 0, 0)
  normalText.ZIndex = 8
  normalText.Parent = holder

  local semiText = Instance.new("TextLabel")
  semiText.Name = "SemiText"
  semiText.BackgroundTransparency = 1
  semiText.Text = "SEMI"
  semiText.TextColor3 = Color3.fromRGB(0, 0, 0)
  semiText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  semiText.TextStrokeTransparency = 0.2
  semiText.TextSize = 11
  semiText.Font = Enum.Font.GothamBlack
  semiText.TextXAlignment = Enum.TextXAlignment.Center
  semiText.Size = UDim2.new(0.5, 0, 1, 0)
  semiText.Position = UDim2.new(0.5, 0, 0, 0)
  semiText.ZIndex = 8
  semiText.Parent = holder

  local normalClick = Instance.new("TextButton")
  normalClick.Name = "NormalClick"
  normalClick.BackgroundTransparency = 1
  normalClick.Text = ""
  normalClick.AutoButtonColor = false
  normalClick.Size = UDim2.new(0.5, 0, 1, 0)
  normalClick.Position = UDim2.new(0, 0, 0, 0)
  normalClick.ZIndex = 10
  normalClick.Parent = holder

  local semiClick = Instance.new("TextButton")
  semiClick.Name = "SemiClick"
  semiClick.BackgroundTransparency = 1
  semiClick.Text = ""
  semiClick.AutoButtonColor = false
  semiClick.Size = UDim2.new(0.5, 0, 1, 0)
  semiClick.Position = UDim2.new(0.5, 0, 0, 0)
  semiClick.ZIndex = 10
  semiClick.Parent = holder

  local function setMode(mode)
    if mode ~= "Semi" then
      mode = "Normal"
    end
    _G.AmbitiousStealRadii = _G.AmbitiousStealRadii or {Normal = 62, Semi = 60}
    -- Salva il radius corrente nel slot giusto prima di cambiare modo
    _G.AmbitiousStealRadii[selectedStealMode] = tonumber(autoStealRadius) or _G.AmbitiousStealRadii[selectedStealMode]
    selectedStealMode = mode
    -- Aggiorna il radiusBox con il valore corretto per il nuovo modo
    autoStealRadius = _G.AmbitiousStealRadii[selectedStealMode] or ((selectedStealMode == "Semi") and 60 or 62)
    if autoStealRadiusBox then
      autoStealRadiusBox.Text = tostring(autoStealRadius)
    end
    -- Tween visivo PRIMA delle operazioni pesanti, cosi il rettangolo si muove subito
    local onSemi = selectedStealMode == "Semi"
    tween(slide, {
      Position = onSemi and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
    }, 0.18)
    tween(normalText, {
      TextTransparency = onSemi and 0.5 or 0,
      TextStrokeTransparency = onSemi and 0.38 or 0.2
    }, 0.14)
    tween(semiText, {
      TextTransparency = onSemi and 0 or 0.5,
      TextStrokeTransparency = onSemi and 0.2 or 0.38
    }, 0.14)
    -- Mostra/nasconde subito i row Semi (sincrono, prima dello spawn)
    if _G.AmbitiousRefreshSemiStealRows then _G.AmbitiousRefreshSemiStealRows() end
    -- Operazioni pesanti in background (saveConfig + sync con possibili WaitForChild/InvokeServer)
    -- cosi non bloccano il thread e non ritardano il tween
    task.spawn(function()
      saveAmbitiousConfig()
      if _G.AmbitiousNormalAutoStealSetRadius then _G.AmbitiousNormalAutoStealSetRadius(_G.AmbitiousStealRadii.Normal or 62) end
      if _G.AmbitiousSemiAutoStealSetRadius then _G.AmbitiousSemiAutoStealSetRadius(_G.AmbitiousStealRadii.Semi or 60) end
      if _G.AmbitiousAutoStealSync then _G.AmbitiousAutoStealSync() end
    end)
  end

  normalClick.MouseButton1Click:Connect(function()
    setMode("Normal")
  end)
  semiClick.MouseButton1Click:Connect(function()
    setMode("Semi")
  end)
  setMode(selectedStealMode)
  _G.AmbitiousSetStealMode = setMode
  return holder, setMode
end

-- ============================================================
-- MOVEMENT PAGE
-- ============================================================
task.wait()
Movement = pages.MOVEMENT

-- RIMOSSA la sezione AUTO SPEED e spostato il toggle sotto Mode

section(Movement, "SPEED", 1)
_, normalSpeedBox = textboxRow(Movement, "Normal Speed", tostring(NS), 2)
normalSpeedBox.FocusLost:Connect(function()
  local v = tonumber(normalSpeedBox.Text)
  if v and v > 0 and v <= 250 then
    NS = v
  end
  normalSpeedBox.Text = tostring(NS)
  saveAmbitiousConfig()
end)

_, carrySpeedBox = textboxRow(Movement, "Carry Speed", tostring(CS), 3)
carrySpeedBox.FocusLost:Connect(function()
  local v = tonumber(carrySpeedBox.Text)
  if v and v > 0 and v <= 250 then
    CS = v
  end
  carrySpeedBox.Text = tostring(CS)
  saveAmbitiousConfig()
end)

-- LAGGER NORMAL e LAGGER CARRY (rinominati)
_, laggerSpeedBox = textboxRow(Movement, "Lagger Normal", tostring(LAGGER_SPEED), 4)
laggerSpeedBox.FocusLost:Connect(function()
  local v = tonumber(laggerSpeedBox.Text)
  if v and v > 0 and v <= 250 then
    LAGGER_SPEED = v
  end
  laggerSpeedBox.Text = tostring(LAGGER_SPEED)
  saveAmbitiousConfig()
end)

_, laggerCarrySpeedBox = textboxRow(Movement, "Lagger Carry", tostring(LAGGER_CARRY_SPEED), 5)
laggerCarrySpeedBox.FocusLost:Connect(function()
  local v = tonumber(laggerCarrySpeedBox.Text)
  if v and v > 0 and v <= 250 then
    LAGGER_CARRY_SPEED = v
  end
  laggerCarrySpeedBox.Text = tostring(LAGGER_CARRY_SPEED)
  saveAmbitiousConfig()
end)

-- ===== AUTO CARRY SPEED MODE SELECTOR BUILDER (stile Infinite Jump) =====
_G._AmbitiousBuildAutoCarryModeSelector = function(row, parentFrame)
  local acModeExpanded = false

  local acArrow = Instance.new("TextButton")
  acArrow.Name = "AutoCarryModeArrow"
  acArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  acArrow.BackgroundTransparency = 0.18
  acArrow.BorderSizePixel = 0
  acArrow.Size = UDim2.new(0, 28, 0, 24)
  acArrow.Position = UDim2.new(1, -90, 0.5, -12)
  acArrow.Text = "\226\150\178"
  acArrow.TextColor3 = Color3.fromRGB(0, 0, 0)
  acArrow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  acArrow.TextStrokeTransparency = 0.3
  acArrow.TextSize = 15
  acArrow.Font = Enum.Font.GothamBold
  acArrow.AutoButtonColor = false
  acArrow.ZIndex = 8
  acArrow.Parent = row
  corner(acArrow, 7)
  stroke(acArrow, COLORS.strokeSoft, 1, 0.45)

  local acHolder = Instance.new("Frame")
  acHolder.Name = "AutoCarry Mode Selector"
  acHolder.BackgroundColor3 = COLORS.row
  acHolder.BackgroundTransparency = 0.28
  acHolder.Size = UDim2.new(1, -4, 0, 42)
  acHolder.BorderSizePixel = 0
  acHolder.LayoutOrder = 6.5
  acHolder.ZIndex = 4
  acHolder.ClipsDescendants = true
  acHolder.Visible = false
  acHolder.Parent = parentFrame
  corner(acHolder, 14)
  stroke(acHolder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
  _G._AmbitiousRegAccent(acHolder, nil, "soft")

  local acSlide = Instance.new("Frame")
  acSlide.Name = "SelectedSlide"
  acSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  acSlide.BackgroundTransparency = 0.1
  acSlide.Size = UDim2.new(0.5, -3, 1, -8)
  acSlide.Position = UDim2.new(0, 4, 0, 4)
  acSlide.BorderSizePixel = 0
  acSlide.ZIndex = 5
  acSlide.Parent = acHolder
  corner(acSlide, 13)
  local acSlideStroke = Instance.new("UIStroke")
  acSlideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  acSlideStroke.Color = Color3.fromRGB(255, 220, 70)
  acSlideStroke.Thickness = 1.5
  acSlideStroke.Transparency = 0.1
  acSlideStroke.Parent = acSlide
  local acSlideGrad = Instance.new("UIGradient")
  acSlideGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
  })
  acSlideGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.08),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.08),
  })
  acSlideGrad.Parent = acSlide
  _G._AmbitiousRegAccent(acSlide, acSlideGrad, "slide")
  acSlideGrad.Rotation = 22

  local acNormalText = Instance.new("TextLabel")
  acNormalText.Name = "NormalText"
  acNormalText.BackgroundTransparency = 1
  acNormalText.Text = "NORMAL"
  acNormalText.TextColor3 = Color3.fromRGB(0, 0, 0)
  acNormalText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  acNormalText.TextStrokeTransparency = 0.2
  acNormalText.TextSize = 11
  acNormalText.Font = Enum.Font.GothamBlack
  acNormalText.TextXAlignment = Enum.TextXAlignment.Center
  acNormalText.Size = UDim2.new(0.5, 0, 1, 0)
  acNormalText.Position = UDim2.new(0, 0, 0, 0)
  acNormalText.ZIndex = 8
  acNormalText.Parent = acHolder

  local acSoftText = Instance.new("TextLabel")
  acSoftText.Name = "SoftText"
  acSoftText.BackgroundTransparency = 1
  acSoftText.Text = "SOFT"
  acSoftText.TextColor3 = Color3.fromRGB(0, 0, 0)
  acSoftText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  acSoftText.TextStrokeTransparency = 0.2
  acSoftText.TextSize = 11
  acSoftText.Font = Enum.Font.GothamBlack
  acSoftText.TextXAlignment = Enum.TextXAlignment.Center
  acSoftText.Size = UDim2.new(0.5, 0, 1, 0)
  acSoftText.Position = UDim2.new(0.5, 0, 0, 0)
  acSoftText.ZIndex = 8
  acSoftText.Parent = acHolder

  local acNormalClick = Instance.new("TextButton")
  acNormalClick.Name = "NormalClick"
  acNormalClick.BackgroundTransparency = 1
  acNormalClick.Text = ""
  acNormalClick.AutoButtonColor = false
  acNormalClick.Size = UDim2.new(0.5, 0, 1, 0)
  acNormalClick.Position = UDim2.new(0, 0, 0, 0)
  acNormalClick.ZIndex = 10
  acNormalClick.Parent = acHolder

  local acSoftClick = Instance.new("TextButton")
  acSoftClick.Name = "SoftClick"
  acSoftClick.BackgroundTransparency = 1
  acSoftClick.Text = ""
  acSoftClick.AutoButtonColor = false
  acSoftClick.Size = UDim2.new(0.5, 0, 1, 0)
  acSoftClick.Position = UDim2.new(0.5, 0, 0, 0)
  acSoftClick.ZIndex = 10
  acSoftClick.Parent = acHolder

  local function applyACModeVisual(mode)
    local isSoft = (mode == "SOFT")
    tween(acSlide, {
      Position = isSoft and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
    }, 0.18)
    tween(acNormalText, {
      TextTransparency = isSoft and 0.5 or 0,
      TextStrokeTransparency = isSoft and 0.38 or 0.2
    }, 0.14)
    tween(acSoftText, {
      TextTransparency = isSoft and 0 or 0.5,
      TextStrokeTransparency = isSoft and 0.2 or 0.38
    }, 0.14)
  end

  local function setACMode(mode)
    if mode ~= "SOFT" then mode = "NORMAL" end
    if _G._AmbitiousAutoCarryMode ~= mode then
      -- Cambio mode: sblocca e ripristina la mode salvata, cosi' non resta stato sporco
      _G._AmbitiousAS.locked = false
      _G._AmbitiousAS.wasLow = false
      if _G._AmbitiousAS.savedMode then
        _G._AmbitiousAS.restoring = true
        pcall(function() setSpeedMode(_G._AmbitiousAS.savedMode) end)
        _G._AmbitiousAS.restoring = false
        _G._AmbitiousAS.savedMode = nil
      end
      _G._AmbitiousAutoCarrySoft.lastScan = 0
    end
    _G._AmbitiousAutoCarryMode = mode
    applyACModeVisual(mode)
    saveAmbitiousConfig()
  end

  _G.AmbitiousRefreshAutoCarryModeSelector = function()
    applyACModeVisual(_G._AmbitiousAutoCarryMode or "NORMAL")
  end

  local function setExpandedAC(expanded)
    acModeExpanded = expanded
    _G._AmbitiousExpand(acHolder, expanded, 42, acArrow)
  end

  acArrow.Activated:Connect(function()
    setExpandedAC(not acModeExpanded)
  end)
  acNormalClick.MouseButton1Click:Connect(function()
    setACMode("NORMAL")
  end)
  acSoftClick.MouseButton1Click:Connect(function()
    setACMode("SOFT")
  end)

  applyACModeVisual(_G._AmbitiousAutoCarryMode or "NORMAL")
end
-- ===== FINE AUTO CARRY SPEED MODE SELECTOR BUILDER =====

-- Auto Carry Speed toggle (ordine 6, prima di Mode)
_, setAutoCarrySpeedVisual = toggleRow(Movement, "Auto Carry Speed", autoCarrySpeedEnabled, 6)
do
  local row = Movement:FindFirstChild("Auto Carry Speed")
  _ambitiousBtn = row and row:FindFirstChild("ToggleButton")
  if _ambitiousBtn then
    _ambitiousBtn.Activated:Connect(function()
      autoCarrySpeedEnabled = not autoCarrySpeedEnabled
      if autoCarrySpeedEnabled ~= true then
        if _G.AutoCarrySpeed and _G.AutoCarrySpeed.Disable then
          _G.AutoCarrySpeed.Disable()
        end
        -- Reset stato auto switch to carry
        _G._AmbitiousAS.locked = false
        _G._AmbitiousAS.wasLow = false
        if _G._AmbitiousAS.savedMode then
          _G._AmbitiousAS.restoring = true
          setSpeedMode(_G._AmbitiousAS.savedMode)
          _G._AmbitiousAS.restoring = false
          _G._AmbitiousAS.savedMode = nil
        end
      end
      if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end
      saveAmbitiousConfig()
    end)
  end
  if row then
    _G._AmbitiousBuildAutoCarryModeSelector(row, Movement)
  end
end

modeDisplayRow(Movement, 7)   -- modalitÃ  combinata

section(Movement, "TELEPORT", 8)
autoTPRow = nil
autoTPRow, _SV.setAutoTPVisual = toggleRow(Movement, "Auto TP Down", autoTPEnabled, 9)
do
  local autoTPButton = autoTPRow and autoTPRow:FindFirstChild("ToggleButton")
  if autoTPButton then
    autoTPButton.MouseButton1Click:Connect(function()
      if autoTPClickDebounce then return end
      autoTPClickDebounce = true
      local nextState = not autoTPEnabled
      toggleAutoTP(nextState)
      task.delay(0.15, function()
        autoTPClickDebounce = false
        if _SV.setAutoTPVisual then _SV.setAutoTPVisual(autoTPEnabled) end
      end)
    end)
  end
  if autoTPEnabled then
    startAutoTP()
  else
    stopAutoTP()
  end
end

-- >>> AUTO TP HEIGHT ARROW BEGIN
-- Il vecchio textboxRow "Auto TP Height" e' stato tolto: ora il valore sta
-- dentro una tendina aperta dalla freccetta sulla riga Auto TP Down,
-- esattamente come il raggio del Look At Enemy e il FOV Value.
do
  local atpdExpanded = false

  local atpdArrow = Instance.new("TextButton")
  atpdArrow.Name = "AutoTPHeightArrow"
  atpdArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  atpdArrow.BackgroundTransparency = 0.18
  atpdArrow.BorderSizePixel = 0
  atpdArrow.Size = UDim2.new(0, 28, 0, 24)
  atpdArrow.Position = UDim2.new(1, -90, 0.5, -12)
  atpdArrow.Text = "\u{25B2}"
  atpdArrow.TextColor3 = Color3.fromRGB(0, 0, 0)
  atpdArrow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  atpdArrow.TextStrokeTransparency = 0.3
  atpdArrow.TextSize = 15
  atpdArrow.Font = Enum.Font.GothamBold
  atpdArrow.AutoButtonColor = false
  atpdArrow.ZIndex = 8
  atpdArrow.Parent = autoTPRow
  corner(atpdArrow, 7)
  stroke(atpdArrow, COLORS.strokeSoft, 1, 0.45)

  local atpdHolder = Instance.new("Frame")
  atpdHolder.Name = "Auto TP Height Holder"
  atpdHolder.BackgroundColor3 = COLORS.row
  atpdHolder.BackgroundTransparency = 0.28
  atpdHolder.Size = UDim2.new(1, -4, 0, 42)
  atpdHolder.BorderSizePixel = 0
  atpdHolder.LayoutOrder = 9
  atpdHolder.ZIndex = 4
  atpdHolder.ClipsDescendants = true
  atpdHolder.Visible = false
  atpdHolder.Parent = Movement
  corner(atpdHolder, 14)
  stroke(atpdHolder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
  _G._AmbitiousRegAccent(atpdHolder, nil, "soft")

  local atpdLabel = Instance.new("TextLabel")
  atpdLabel.Name = "Label"
  atpdLabel.BackgroundTransparency = 1
  atpdLabel.Text = "Auto TP Height"
  atpdLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
  atpdLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  atpdLabel.TextStrokeTransparency = 0.25
  atpdLabel.TextSize = 11
  atpdLabel.Font = Enum.Font.GothamSemibold
  atpdLabel.TextXAlignment = Enum.TextXAlignment.Left
  atpdLabel.Size = UDim2.new(0.55, 0, 1, 0)
  atpdLabel.Position = UDim2.new(0, 12, 0, 0)
  atpdLabel.ZIndex = 8
  atpdLabel.Parent = atpdHolder

  -- Stesso nome globale di prima: reset e refresh continuano a funzionare.
  autoTPHeightBox = Instance.new("TextBox")
  autoTPHeightBox.Name = "AutoTPHeightBox"
  autoTPHeightBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  autoTPHeightBox.BackgroundTransparency = 0.18
  autoTPHeightBox.Text = tostring(autoTPHeight)
  autoTPHeightBox.TextColor3 = Color3.fromRGB(0, 0, 0)
  autoTPHeightBox.TextSize = 12
  autoTPHeightBox.Font = Enum.Font.GothamSemibold
  autoTPHeightBox.ClearTextOnFocus = false
  autoTPHeightBox.Size = UDim2.new(0, 58, 0, 24)
  autoTPHeightBox.Position = UDim2.new(1, -68, 0.5, -12)
  autoTPHeightBox.BorderSizePixel = 0
  autoTPHeightBox.ZIndex = 6
  autoTPHeightBox.Parent = atpdHolder
  corner(autoTPHeightBox, 7)
  stroke(autoTPHeightBox, COLORS.strokeSoft, 1, 0.45)

  _G.AmbitiousRefreshAutoTPHeightBox = function()
    pcall(function() autoTPHeightBox.Text = tostring(autoTPHeight) end)
  end

  autoTPHeightBox.FocusLost:Connect(function()
    local v = tonumber(autoTPHeightBox.Text)
    if v and v >= -500 and v <= 500 then
      autoTPHeight = v
    end
    autoTPHeightBox.Text = tostring(autoTPHeight)
    saveAmbitiousConfig()
  end)

  atpdArrow.Activated:Connect(function()
    atpdExpanded = not atpdExpanded
    _G._AmbitiousExpand(atpdHolder, atpdExpanded, 42, atpdArrow)
  end)
end
-- <<< AUTO TP HEIGHT ARROW END


-- >>> DROP METHOD BEGIN
-- La sezione "DROP METHOD" e' stata rimossa: ora e' una riga singola
-- "Drop Method" (solo etichetta + freccetta, nessun toggle) piazzata
-- sopra Infinite Jump. La freccetta apre lo slider TP UP / STAND STILL.
_G._AmbitiousBuildDropMethodSelector = function(parentFrame, rowOrder, holderOrder)
  local dropExpanded = false

  local dropRow = baseRow(parentFrame, "Drop Method", rowOrder)

  local dropArrow = Instance.new("TextButton")
  dropArrow.Name = "DropMethodArrow"
  dropArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  dropArrow.BackgroundTransparency = 0.18
  dropArrow.BorderSizePixel = 0
  dropArrow.Size = UDim2.new(0, 28, 0, 24)
  dropArrow.Position = UDim2.new(1, -40, 0.5, -12)
  dropArrow.Text = "\u{25B2}"
  dropArrow.TextColor3 = Color3.fromRGB(0, 0, 0)
  dropArrow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  dropArrow.TextStrokeTransparency = 0.3
  dropArrow.TextSize = 15
  dropArrow.Font = Enum.Font.GothamBold
  dropArrow.AutoButtonColor = false
  dropArrow.ZIndex = 8
  dropArrow.Parent = dropRow
  corner(dropArrow, 7)
  stroke(dropArrow, COLORS.strokeSoft, 1, 0.45)

  -- Selector row: TP UP / STAND STILL (stesso stile di autoStealSelectorRow)
  local dropMethodHolder = Instance.new("Frame")
  dropMethodHolder.Name = "Drop Method Mode"
  dropMethodHolder.BackgroundColor3 = COLORS.row
  dropMethodHolder.BackgroundTransparency = 0.28
  dropMethodHolder.Size = UDim2.new(1, -4, 0, 42)
  dropMethodHolder.BorderSizePixel = 0
  dropMethodHolder.LayoutOrder = holderOrder
  dropMethodHolder.ZIndex = 4
  dropMethodHolder.ClipsDescendants = true
  dropMethodHolder.Visible = false
  dropMethodHolder.Parent = parentFrame
  corner(dropMethodHolder, 14)
  stroke(dropMethodHolder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
  _G._AmbitiousRegAccent(dropMethodHolder, nil, "soft")

  local dropSlide = Instance.new("Frame")
  dropSlide.Name = "SelectedSlide"
  dropSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  dropSlide.BackgroundTransparency = 0.1
  dropSlide.Size = UDim2.new(0.5, -3, 1, -8)
  dropSlide.Position = UDim2.new(0, 4, 0, 4)
  dropSlide.BorderSizePixel = 0
  dropSlide.ZIndex = 5
  dropSlide.Parent = dropMethodHolder
  corner(dropSlide, 13)
  local dropSlideStroke = Instance.new("UIStroke")
  dropSlideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  dropSlideStroke.Color = Color3.fromRGB(255, 220, 70)
  dropSlideStroke.Thickness = 1.5
  dropSlideStroke.Transparency = 0.1
  dropSlideStroke.Parent = dropSlide
  local dropSlideGradient = Instance.new("UIGradient")
  dropSlideGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
  })
  dropSlideGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.08),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.08),
  })
  dropSlideGradient.Parent = dropSlide
  _G._AmbitiousRegAccent(dropSlide, dropSlideGradient, "slide")
  dropSlideGradient.Rotation = 22

  local dropTpUpText = Instance.new("TextLabel")
  dropTpUpText.Name = "TpUpText"
  dropTpUpText.BackgroundTransparency = 1
  dropTpUpText.Text = "TP UP"
  dropTpUpText.TextColor3 = Color3.fromRGB(0, 0, 0)
  dropTpUpText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  dropTpUpText.TextStrokeTransparency = 0.2
  dropTpUpText.TextSize = 11
  dropTpUpText.Font = Enum.Font.GothamBlack
  dropTpUpText.TextXAlignment = Enum.TextXAlignment.Center
  dropTpUpText.Size = UDim2.new(0.5, 0, 1, 0)
  dropTpUpText.Position = UDim2.new(0, 0, 0, 0)
  dropTpUpText.ZIndex = 8
  dropTpUpText.Parent = dropMethodHolder

  local dropStandStillText = Instance.new("TextLabel")
  dropStandStillText.Name = "StandStillText"
  dropStandStillText.BackgroundTransparency = 1
  dropStandStillText.Text = "STAND STILL"
  dropStandStillText.TextColor3 = Color3.fromRGB(0, 0, 0)
  dropStandStillText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  dropStandStillText.TextStrokeTransparency = 0.2
  dropStandStillText.TextSize = 11
  dropStandStillText.Font = Enum.Font.GothamBlack
  dropStandStillText.TextXAlignment = Enum.TextXAlignment.Center
  dropStandStillText.Size = UDim2.new(0.5, 0, 1, 0)
  dropStandStillText.Position = UDim2.new(0.5, 0, 0, 0)
  dropStandStillText.ZIndex = 8
  dropStandStillText.Parent = dropMethodHolder

  local dropTpUpClick = Instance.new("TextButton")
  dropTpUpClick.Name = "TpUpClick"
  dropTpUpClick.BackgroundTransparency = 1
  dropTpUpClick.Text = ""
  dropTpUpClick.AutoButtonColor = false
  dropTpUpClick.Size = UDim2.new(0.5, 0, 1, 0)
  dropTpUpClick.Position = UDim2.new(0, 0, 0, 0)
  dropTpUpClick.ZIndex = 10
  dropTpUpClick.Parent = dropMethodHolder

  local dropStandStillClick = Instance.new("TextButton")
  dropStandStillClick.Name = "StandStillClick"
  dropStandStillClick.BackgroundTransparency = 1
  dropStandStillClick.Text = ""
  dropStandStillClick.AutoButtonColor = false
  dropStandStillClick.Size = UDim2.new(0.5, 0, 1, 0)
  dropStandStillClick.Position = UDim2.new(0.5, 0, 0, 0)
  dropStandStillClick.ZIndex = 10
  dropStandStillClick.Parent = dropMethodHolder

  local function applyDropVisual()
    local onStandStill = selectedDropMode == "Stand Still"
    tween(dropSlide, {
      Position = onStandStill and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
    }, 0.18)
    tween(dropTpUpText, {
      TextTransparency = onStandStill and 0.5 or 0,
      TextStrokeTransparency = onStandStill and 0.38 or 0.2
    }, 0.14)
    tween(dropStandStillText, {
      TextTransparency = onStandStill and 0 or 0.5,
      TextStrokeTransparency = onStandStill and 0.2 or 0.38
    }, 0.14)
  end

  local function setDropMode(mode)
    if mode ~= "Stand Still" then
      mode = "TP UP"
    end
    selectedDropMode = mode
    applyDropVisual()
    saveAmbitiousConfig()
  end

  -- Usato da Reset All Settings / load config
  _G.AmbitiousRefreshDropMethodSelector = function()
    applyDropVisual()
  end

  dropTpUpClick.MouseButton1Click:Connect(function()
    setDropMode("TP UP")
  end)
  dropStandStillClick.MouseButton1Click:Connect(function()
    setDropMode("Stand Still")
  end)

  dropArrow.Activated:Connect(function()
    dropExpanded = not dropExpanded
    _G._AmbitiousExpand(dropMethodHolder, dropExpanded, 42, dropArrow)
  end)

  applyDropVisual()
end
-- <<< DROP METHOD END


-- Helper separato per evitare il limite Luau dei 200 registri locali nel
-- builder principale della GUI. Non cattura variabili locali del builder.
-- ===== BUILDER LOOK AT ENEMY RADIUS SELECTOR =====
_G._AmbitiousBuildLookAtRadiusSelector = function(row, parentFrame)
  local laeExpanded = false

  local arrowLAE = Instance.new("TextButton")
  arrowLAE.Name = "LookAtArrow"
  arrowLAE.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  arrowLAE.BackgroundTransparency = 0.18
  arrowLAE.BorderSizePixel = 0
  arrowLAE.Size = UDim2.new(0, 28, 0, 24)
  arrowLAE.Position = UDim2.new(1, -90, 0.5, -12)
  arrowLAE.Text = "â–²"
  arrowLAE.TextColor3 = Color3.fromRGB(0, 0, 0)
  arrowLAE.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  arrowLAE.TextStrokeTransparency = 0.3
  arrowLAE.TextSize = 15
  arrowLAE.Font = Enum.Font.GothamBold
  arrowLAE.AutoButtonColor = false
  arrowLAE.ZIndex = 8
  arrowLAE.Parent = row
  corner(arrowLAE, 7)
  stroke(arrowLAE, COLORS.strokeSoft, 1, 0.45)

  local laeHolder = Instance.new("Frame")
  laeHolder.Name = "Look At Enemy Radius Holder"
  laeHolder.BackgroundColor3 = COLORS.row
  laeHolder.BackgroundTransparency = 0.28
  laeHolder.Size = UDim2.new(1, -4, 0, 42)
  laeHolder.BorderSizePixel = 0
  laeHolder.LayoutOrder = 15.5
  laeHolder.ZIndex = 4
  laeHolder.ClipsDescendants = true
  laeHolder.Visible = false
  laeHolder.Parent = parentFrame
  corner(laeHolder, 14)
  stroke(laeHolder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
  _G._AmbitiousRegAccent(laeHolder, nil, "soft")

  local laeLabel = Instance.new("TextLabel")
  laeLabel.BackgroundTransparency = 1
  laeLabel.Text = "Look At Enemy Radius"
  laeLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
  laeLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  laeLabel.TextStrokeTransparency = 0.25
  laeLabel.TextSize = 11
  laeLabel.Font = Enum.Font.GothamSemibold
  laeLabel.TextXAlignment = Enum.TextXAlignment.Left
  laeLabel.Size = UDim2.new(0.55, 0, 1, 0)
  laeLabel.Position = UDim2.new(0, 12, 0, 0)
  laeLabel.ZIndex = 8
  laeLabel.Parent = laeHolder

  local laeBox = Instance.new("TextBox")
  laeBox.Name = "LookAtRadiusBox"
  laeBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  laeBox.BackgroundTransparency = 0.18
  laeBox.Text = tostring(tonumber(_G.AmbitiousLookAtRadius) or 20)
  laeBox.TextColor3 = Color3.fromRGB(0, 0, 0)
  laeBox.TextSize = 12
  -- >>> TAB POSITION BEGIN
  -- Era GothamBlack: unica textbox della hub con un font diverso.
  -- textboxRow() usa GothamSemibold per tutte le altre.
  laeBox.Font = Enum.Font.GothamSemibold
  -- <<< TAB POSITION END
  laeBox.ClearTextOnFocus = false
  laeBox.Size = UDim2.new(0, 58, 0, 24)
  laeBox.Position = UDim2.new(1, -68, 0.5, -12)
  laeBox.BorderSizePixel = 0
  laeBox.ZIndex = 6
  laeBox.Parent = laeHolder
  corner(laeBox, 7)
  stroke(laeBox, COLORS.strokeSoft, 1, 0.45)

  _G.AmbitiousLookAtRadiusBox = laeBox

  laeBox.FocusLost:Connect(function()
    local v = math.clamp(tonumber(laeBox.Text) or 20, 1, 200)
    _G.AmbitiousLookAtRadius = v
    laeBox.Text = tostring(v)
    saveAmbitiousConfig()
  end)

  local function setLAEExpanded(expanded)
    laeExpanded = expanded
    _G._AmbitiousExpand(laeHolder, expanded, 42, arrowLAE)
  end

  arrowLAE.Activated:Connect(function()
    setLAEExpanded(not laeExpanded)
  end)
end

-- >>> TP DOWN METHOD BEGIN
-- Riga "TP Down Method": solo etichetta + freccetta, nessun toggle.
-- Aprendola compare lo slider NORMAL / SLOW FALL / ZIGZAG.
_G._AmbitiousBuildTPDownMethodSelector = function(parentFrame, rowOrder, holderOrder)
  local row = baseRow(parentFrame, "TP Down Method", rowOrder)

  local arrow = Instance.new("TextButton")
  arrow.Name = "TPDownMethodArrow"
  arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  arrow.BackgroundTransparency = 0.18
  arrow.BorderSizePixel = 0
  arrow.Size = UDim2.new(0, 28, 0, 24)
  arrow.Position = UDim2.new(1, -38, 0.5, -12)
  arrow.Text = "\u{25B2}"
  arrow.TextColor3 = Color3.fromRGB(0, 0, 0)
  arrow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  arrow.TextStrokeTransparency = 0.3
  arrow.TextSize = 15
  arrow.Font = Enum.Font.GothamBold
  arrow.AutoButtonColor = false
  arrow.ZIndex = 8
  arrow.Parent = row
  corner(arrow, 7)
  stroke(arrow, COLORS.strokeSoft, 1, 0.45)

  local holder = Instance.new("Frame")
  holder.Name = "TP Down Method Selector"
  holder.BackgroundColor3 = COLORS.row
  holder.BackgroundTransparency = 0.28
  holder.Size = UDim2.new(1, -4, 0, 42)
  holder.BorderSizePixel = 0
  holder.LayoutOrder = holderOrder
  holder.ZIndex = 4
  holder.ClipsDescendants = true
  holder.Visible = false
  holder.Parent = parentFrame
  corner(holder, 14)
  stroke(holder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
  _G._AmbitiousRegAccent(holder, nil, "soft")

  -- Tre segmenti: NORMAL, SLOW FALL, ZIGZAG.
  local TPM_MODES = {"NORMAL", "SLOW", "ZIGZAG"}
  local TPM_TEXT  = {"NORMAL", "SLOW FALL", "ZIGZAG"}
  local TPM_N = #TPM_MODES
  local tpmW = 1 / TPM_N

  local slide = Instance.new("Frame")
  slide.Name = "SelectedSlide"
  slide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  slide.BackgroundTransparency = 0.1
  slide.Size = UDim2.new(tpmW, -8, 1, -8)
  slide.Position = UDim2.new(0, 4, 0, 4)
  slide.BorderSizePixel = 0
  slide.ZIndex = 5
  slide.Parent = holder
  corner(slide, 13)
  local slideStroke = Instance.new("UIStroke")
  slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  slideStroke.Color = Color3.fromRGB(255, 220, 70)
  slideStroke.Thickness = 1.5
  slideStroke.Transparency = 0.1
  slideStroke.Parent = slide
  local slideGrad = Instance.new("UIGradient")
  slideGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
  })
  slideGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.08),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.08),
  })
  slideGrad.Rotation = 22
  slideGrad.Parent = slide
  _G._AmbitiousRegAccent(slide, slideGrad, "slide")

  local tpmTexts = {}

  local function applyVisual(mode)
    local idx = 1
    for i, m in ipairs(TPM_MODES) do if m == mode then idx = i break end end
    tween(slide, {
      Position = UDim2.new(tpmW * (idx - 1), 4, 0, 4)
    }, 0.18)
    for i, t in ipairs(tpmTexts) do
      local sel = (i == idx)
      tween(t, {
        TextTransparency = sel and 0 or 0.5,
        TextStrokeTransparency = sel and 0.2 or 0.38
      }, 0.14)
    end
  end

  local function setMode(mode)
    local ok = false
    for _, m in ipairs(TPM_MODES) do if m == mode then ok = true break end end
    if not ok then mode = "NORMAL" end
    _G._AmbitiousTPDownMethod = mode
    applyVisual(mode)
    saveAmbitiousConfig()
  end

  for i, mode in ipairs(TPM_MODES) do
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = TPM_TEXT[i]
    t.TextColor3 = Color3.fromRGB(0, 0, 0)
    t.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    t.TextStrokeTransparency = 0.2
    t.TextSize = 11
    t.Font = Enum.Font.GothamBlack
    t.TextXAlignment = Enum.TextXAlignment.Center
    t.Size = UDim2.new(tpmW, 0, 1, 0)
    t.Position = UDim2.new(tpmW * (i - 1), 0, 0, 0)
    t.ZIndex = 8
    t.Parent = holder
    tpmTexts[i] = t

    local b = Instance.new("TextButton")
    b.BackgroundTransparency = 1
    b.Text = ""
    b.AutoButtonColor = false
    b.Size = UDim2.new(tpmW, 0, 1, 0)
    b.Position = UDim2.new(tpmW * (i - 1), 0, 0, 0)
    b.ZIndex = 10
    b.Parent = holder
    b.MouseButton1Click:Connect(function() setMode(mode) end)
  end

  local expanded = false
  arrow.Activated:Connect(function()
    expanded = not expanded
    _G._AmbitiousExpand(holder, expanded, 42, arrow)
  end)

  _G.AmbitiousRefreshTPDownMethodSelector = function()
    applyVisual(_G._AmbitiousTPDownMethod or "NORMAL")
  end
  applyVisual(_G._AmbitiousTPDownMethod or "NORMAL")
end

-- La riga vive nella sezione TELEPORT (LayoutOrder 10.5/10.6), ma la
-- chiamata deve stare DOPO la definizione del builder, non prima.
-- Sopra Auto TP Down (9): riga 8 + holder 8, subito dopo la sezione TELEPORT (8).
_G._AmbitiousBuildTPDownMethodSelector(Movement, 8, 8)
-- <<< TP DOWN METHOD END

-- ===== BUILDER JUMP MODE SELECTOR (funzione separata per non saturare i local del chunk) =====
_G._AmbitiousBuildJumpModeSelector = function(row, parentFrame)
  local jumpModeExpanded = false

  local arrowBtn = Instance.new("TextButton")
  arrowBtn.Name = "JumpModeArrow"
  arrowBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  arrowBtn.BackgroundTransparency = 0.18
  arrowBtn.BorderSizePixel = 0
  arrowBtn.Size = UDim2.new(0, 28, 0, 24)
  arrowBtn.Position = UDim2.new(1, -90, 0.5, -12)
  arrowBtn.Text = "â–²"
  arrowBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
  arrowBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  arrowBtn.TextStrokeTransparency = 0.3
  arrowBtn.TextSize = 15
  arrowBtn.Font = Enum.Font.GothamBold
  arrowBtn.AutoButtonColor = false
  arrowBtn.ZIndex = 8
  arrowBtn.Parent = row
  corner(arrowBtn, 7)
  stroke(arrowBtn, COLORS.strokeSoft, 1, 0.45)

  local jumpModeHolder = Instance.new("Frame")
  jumpModeHolder.Name = "Jump Mode Selector"
  jumpModeHolder.BackgroundColor3 = COLORS.row
  jumpModeHolder.BackgroundTransparency = 0.28
  jumpModeHolder.Size = UDim2.new(1, -4, 0, 42)
  jumpModeHolder.BorderSizePixel = 0
  jumpModeHolder.LayoutOrder = 15
  jumpModeHolder.ZIndex = 4
  jumpModeHolder.ClipsDescendants = true
  jumpModeHolder.Visible = false
  jumpModeHolder.Parent = parentFrame
  corner(jumpModeHolder, 14)
  stroke(jumpModeHolder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
  _G._AmbitiousRegAccent(jumpModeHolder, nil, "soft")

  local jumpModeSlide = Instance.new("Frame")
  jumpModeSlide.Name = "SelectedSlide"
  jumpModeSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  jumpModeSlide.BackgroundTransparency = 0.1
  jumpModeSlide.Size = UDim2.new(0.5, -3, 1, -8)
  jumpModeSlide.Position = UDim2.new(0, 4, 0, 4)
  jumpModeSlide.BorderSizePixel = 0
  jumpModeSlide.ZIndex = 5
  jumpModeSlide.Parent = jumpModeHolder
  corner(jumpModeSlide, 13)
  local jmsStroke = Instance.new("UIStroke")
  jmsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  jmsStroke.Color = Color3.fromRGB(255, 220, 70)
  jmsStroke.Thickness = 1
  jmsStroke.Transparency = 0.08
  jmsStroke.Parent = jumpModeSlide
  local jmsGrad = Instance.new("UIGradient")
  jmsGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
  })
  jmsGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.08),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.08),
  })
  jmsGrad.Parent = jumpModeSlide
  _G._AmbitiousRegAccent(jumpModeSlide, jmsGrad, "slide")

  local holdText = Instance.new("TextLabel")
  holdText.Name = "HoldText"
  holdText.BackgroundTransparency = 1
  holdText.Text = "HOLD"
  holdText.TextColor3 = Color3.fromRGB(0, 0, 0)
  holdText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  holdText.TextStrokeTransparency = 0.2
  holdText.TextSize = 11
  holdText.Font = Enum.Font.GothamBlack
  holdText.TextXAlignment = Enum.TextXAlignment.Center
  holdText.Size = UDim2.new(0.5, 0, 1, 0)
  holdText.Position = UDim2.new(0, 0, 0, 0)
  holdText.ZIndex = 8
  holdText.Parent = jumpModeHolder

  local manualText = Instance.new("TextLabel")
  manualText.Name = "ManualText"
  manualText.BackgroundTransparency = 1
  manualText.Text = "MANUAL"
  manualText.TextColor3 = Color3.fromRGB(0, 0, 0)
  manualText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  manualText.TextStrokeTransparency = 0.2
  manualText.TextSize = 11
  manualText.Font = Enum.Font.GothamBlack
  manualText.TextXAlignment = Enum.TextXAlignment.Center
  manualText.Size = UDim2.new(0.5, 0, 1, 0)
  manualText.Position = UDim2.new(0.5, 0, 0, 0)
  manualText.ZIndex = 8
  manualText.Parent = jumpModeHolder

  local holdClick = Instance.new("TextButton")
  holdClick.Name = "HoldClick"
  holdClick.BackgroundTransparency = 1
  holdClick.Text = ""
  holdClick.AutoButtonColor = false
  holdClick.Size = UDim2.new(0.5, 0, 1, 0)
  holdClick.Position = UDim2.new(0, 0, 0, 0)
  holdClick.ZIndex = 10
  holdClick.Parent = jumpModeHolder

  local manualClick = Instance.new("TextButton")
  manualClick.Name = "ManualClick"
  manualClick.BackgroundTransparency = 1
  manualClick.Text = ""
  manualClick.AutoButtonColor = false
  manualClick.Size = UDim2.new(0.5, 0, 1, 0)
  manualClick.Position = UDim2.new(0.5, 0, 0, 0)
  manualClick.ZIndex = 10
  manualClick.Parent = jumpModeHolder

  local function applyJumpModeVisual(mode)
    local isManual = (mode == "MANUAL")
    tween(jumpModeSlide, {
      Position = isManual and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
    }, 0.18)
    tween(holdText, {
      TextTransparency = isManual and 0.5 or 0,
      TextStrokeTransparency = isManual and 0.38 or 0.2
    }, 0.14)
    tween(manualText, {
      TextTransparency = isManual and 0 or 0.5,
      TextStrokeTransparency = isManual and 0.2 or 0.38
    }, 0.14)
  end

  local function setJumpMode(mode)
    if mode ~= "MANUAL" then mode = "HOLD" end
    infJumpMode = mode
    if infJumpMode == "MANUAL" then
      _G.AmbitiousStopNormalInfJumpHoldState()
    end
    applyJumpModeVisual(infJumpMode)
    saveAmbitiousConfig()
  end

  _G.AmbitiousRefreshInfJumpModeSelector = function()
    applyJumpModeVisual(infJumpMode)
  end

  local function setExpanded(expanded)
    jumpModeExpanded = expanded
    _G._AmbitiousExpand(jumpModeHolder, expanded, 42, arrowBtn)
  end

  arrowBtn.Activated:Connect(function()
    setExpanded(not jumpModeExpanded)
  end)
  holdClick.MouseButton1Click:Connect(function()
    setJumpMode("HOLD")
  end)
  manualClick.MouseButton1Click:Connect(function()
    setJumpMode("MANUAL")
  end)

  applyJumpModeVisual(infJumpMode)
end

-- RINOMINATA sezione JUMP in UTILITY
section(Movement, "UTILITY", 13)
-- >>> INSTANT RESET METHOD: riga sopra Drop Method <<<
-- Solo etichetta + freccetta, nessun toggle. Aprendola compare lo slider
-- V1 / V2. LayoutOrder 13 come Drop Method ma creata PRIMA, quindi il
-- UIListLayout la mette sopra (a parita' di ordine vale l'inserimento).
do
  local irRow = baseRow(Movement, "Instant Reset Method", 13)

  local irHolder = Instance.new("Frame")
  irHolder.Name = "Instant Reset Method Mode"
  irHolder.BackgroundColor3 = COLORS.row
  irHolder.BackgroundTransparency = 0.28
  irHolder.Size = UDim2.new(1, -4, 0, 42)
  irHolder.BorderSizePixel = 0
  irHolder.LayoutOrder = 13
  irHolder.ZIndex = 4
  irHolder.ClipsDescendants = true
  irHolder.Visible = false
  irHolder.Parent = Movement
  corner(irHolder, 14)
  stroke(irHolder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
  _G._AmbitiousRegAccent(irHolder, nil, "soft")

  local irSlide = Instance.new("Frame")
  irSlide.Name = "SelectedSlide"
  irSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  irSlide.BackgroundTransparency = 0.1
  irSlide.Size = UDim2.new(0.5, -8, 1, -8)
  irSlide.Position = UDim2.new(0, 4, 0, 4)
  irSlide.BorderSizePixel = 0
  irSlide.ZIndex = 5
  irSlide.Parent = irHolder
  corner(irSlide, 13)
  local irSlideStroke = Instance.new("UIStroke")
  irSlideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  irSlideStroke.Color = Color3.fromRGB(255, 220, 70)
  irSlideStroke.Thickness = 1.5
  irSlideStroke.Transparency = 0.1
  irSlideStroke.Parent = irSlide
  local irSlideGrad = Instance.new("UIGradient")
  irSlideGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
  })
  irSlideGrad.Rotation = 22
  irSlideGrad.Parent = irSlide
  _G._AmbitiousRegAccent(irSlide, irSlideGrad, "slide")

  local irTexts = {}
  for i = 1, 2 do
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = "V" .. i
    t.TextColor3 = Color3.fromRGB(0, 0, 0)
    t.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    t.TextStrokeTransparency = 0.2
    t.TextSize = 14
    t.Font = Enum.Font.GothamBlack
    t.TextXAlignment = Enum.TextXAlignment.Center
    t.Size = UDim2.new(0.5, 0, 1, 0)
    t.Position = UDim2.new(0.5 * (i - 1), 0, 0, 0)
    t.ZIndex = 8
    t.Parent = irHolder
    irTexts[i] = t
  end

  local function irApplyVisual()
    local idx = (tonumber(_G.AmbitiousInstantResetVersion) or 1) == 2 and 2 or 1
    tween(irSlide, {Position = UDim2.new(0.5 * (idx - 1), 4, 0, 4)}, 0.18)
    for i, t in ipairs(irTexts) do
      local sel = (i == idx)
      tween(t, {
        TextTransparency = sel and 0 or 0.5,
        TextStrokeTransparency = sel and 0.2 or 0.38,
      }, 0.14)
    end
  end
  _G.AmbitiousRefreshInstantResetSelector = irApplyVisual

  for i = 1, 2 do
    local b = Instance.new("TextButton")
    b.BackgroundTransparency = 1
    b.Text = ""
    b.AutoButtonColor = false
    b.Size = UDim2.new(0.5, 0, 1, 0)
    b.Position = UDim2.new(0.5 * (i - 1), 0, 0, 0)
    b.ZIndex = 10
    b.Parent = irHolder
    local picked = i
    b.MouseButton1Click:Connect(function()
      _G.AmbitiousInstantResetVersion = picked
      irApplyVisual()
      saveAmbitiousConfig()
    end)
  end

  local irArrow = Instance.new("TextButton")
  irArrow.Name = "InstantResetMethodArrow"
  irArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  irArrow.BackgroundTransparency = 0.18
  irArrow.BorderSizePixel = 0
  irArrow.Size = UDim2.new(0, 28, 0, 24)
  irArrow.Position = UDim2.new(1, -40, 0.5, -12)
  irArrow.Text = "\u{25B2}"
  irArrow.TextColor3 = Color3.fromRGB(0, 0, 0)
  irArrow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  irArrow.TextStrokeTransparency = 0.3
  irArrow.TextSize = 15
  irArrow.Font = Enum.Font.GothamBold
  irArrow.AutoButtonColor = false
  irArrow.ZIndex = 8
  irArrow.Parent = irRow
  corner(irArrow, 7)
  stroke(irArrow, COLORS.strokeSoft, 1, 0.45)

  local irExpanded = false
  irArrow.Activated:Connect(function()
    irExpanded = not irExpanded
    _G._AmbitiousExpand(irHolder, irExpanded, 42, irArrow)
  end)

  irApplyVisual()
end

-- >>> DROP METHOD: riga singola sopra Infinite Jump (14) <<<
_G._AmbitiousBuildDropMethodSelector(Movement, 13, 13)
_, setInfJumpVisual = toggleRow(Movement, "Infinite Jump", infJumpEnabled, 14)
do
  local row = Movement:FindFirstChild("Infinite Jump")
  _ambitiousBtn = row and row:FindFirstChild("ToggleButton")
  if _ambitiousBtn then
    _ambitiousBtn.Activated:Connect(function()
      setInfJumpInternal(not infJumpEnabled)
      if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end
      saveAmbitiousConfig()
    end)
  end
  if row then
    _G._AmbitiousBuildJumpModeSelector(row, Movement)
  end
end

_, _SV.setLookAtVisual = toggleRow(Movement, "Look At Enemy", _G.AmbitiousLookAtEnabled, 15)
do
  local row = Movement:FindFirstChild("Look At Enemy")
  _ambitiousBtn = row and row:FindFirstChild("ToggleButton")
  if _ambitiousBtn then
    _ambitiousBtn.Activated:Connect(function()
      _G.AmbitiousToggleLookAt(not _G.AmbitiousLookAtEnabled)
      if _SV.setLookAtVisual then _SV.setLookAtVisual(_G.AmbitiousLookAtEnabled == true) end
      saveAmbitiousConfig()
    end)
  end
  if row then
    _G._AmbitiousBuildLookAtRadiusSelector(row, Movement)
  end
end

-- ===== ANTI RAGDOLL MODE SELECTOR BUILDER (stile Infinite Jump) =====
_G._AmbitiousBuildAntiRagdollModeSelector = function(row, parentFrame)
  local arModeExpanded = false

  local arArrow = Instance.new("TextButton")
  arArrow.Name = "AntiRagdollModeArrow"
  arArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  arArrow.BackgroundTransparency = 0.18
  arArrow.BorderSizePixel = 0
  arArrow.Size = UDim2.new(0, 28, 0, 24)
  arArrow.Position = UDim2.new(1, -90, 0.5, -12)
  arArrow.Text = "â–²"
  arArrow.TextColor3 = Color3.fromRGB(0, 0, 0)
  arArrow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  arArrow.TextStrokeTransparency = 0.3
  arArrow.TextSize = 15
  arArrow.Font = Enum.Font.GothamBold
  arArrow.AutoButtonColor = false
  arArrow.ZIndex = 8
  arArrow.Parent = row
  corner(arArrow, 7)
  stroke(arArrow, COLORS.strokeSoft, 1, 0.45)

  local arHolder = Instance.new("Frame")
  arHolder.Name = "AntiRagdoll Mode Selector"
  arHolder.BackgroundColor3 = COLORS.row
  arHolder.BackgroundTransparency = 0.28
  arHolder.Size = UDim2.new(1, -4, 0, 42)
  arHolder.BorderSizePixel = 0
  arHolder.LayoutOrder = 16.5
  arHolder.ZIndex = 4
  arHolder.ClipsDescendants = true
  arHolder.Visible = false
  arHolder.Parent = parentFrame
  corner(arHolder, 14)
  stroke(arHolder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
  _G._AmbitiousRegAccent(arHolder, nil, "soft")

  local arSlide = Instance.new("Frame")
  arSlide.Name = "SelectedSlide"
  arSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  arSlide.BackgroundTransparency = 0.1
  arSlide.Size = UDim2.new(0.5, -3, 1, -8)
  arSlide.Position = UDim2.new(0, 4, 0, 4)
  arSlide.BorderSizePixel = 0
  arSlide.ZIndex = 5
  arSlide.Parent = arHolder
  corner(arSlide, 13)
  local arSlideStroke = Instance.new("UIStroke")
  arSlideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  arSlideStroke.Color = Color3.fromRGB(255, 220, 70)
  arSlideStroke.Thickness = 1.5
  arSlideStroke.Transparency = 0.1
  arSlideStroke.Parent = arSlide
  local arSlideGrad = Instance.new("UIGradient")
  arSlideGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
  })
  arSlideGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.08),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.08),
  })
  arSlideGrad.Parent = arSlide
  _G._AmbitiousRegAccent(arSlide, arSlideGrad, "slide")
  arSlideGrad.Rotation = 22

  local arV1Text = Instance.new("TextLabel")
  arV1Text.Name = "V1Text"
  arV1Text.BackgroundTransparency = 1
  arV1Text.Text = "V1"
  arV1Text.TextColor3 = Color3.fromRGB(0, 0, 0)
  arV1Text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  arV1Text.TextStrokeTransparency = 0.2
  arV1Text.TextSize = 11
  arV1Text.Font = Enum.Font.GothamBlack
  arV1Text.TextXAlignment = Enum.TextXAlignment.Center
  arV1Text.Size = UDim2.new(0.5, 0, 1, 0)
  arV1Text.Position = UDim2.new(0, 0, 0, 0)
  arV1Text.ZIndex = 8
  arV1Text.Parent = arHolder

  local arV2Text = Instance.new("TextLabel")
  arV2Text.Name = "V2Text"
  arV2Text.BackgroundTransparency = 1
  arV2Text.Text = "V2"
  arV2Text.TextColor3 = Color3.fromRGB(0, 0, 0)
  arV2Text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  arV2Text.TextStrokeTransparency = 0.2
  arV2Text.TextSize = 11
  arV2Text.Font = Enum.Font.GothamBlack
  arV2Text.TextXAlignment = Enum.TextXAlignment.Center
  arV2Text.Size = UDim2.new(0.5, 0, 1, 0)
  arV2Text.Position = UDim2.new(0.5, 0, 0, 0)
  arV2Text.ZIndex = 8
  arV2Text.Parent = arHolder

  local arV1Click = Instance.new("TextButton")
  arV1Click.Name = "V1Click"
  arV1Click.BackgroundTransparency = 1
  arV1Click.Text = ""
  arV1Click.AutoButtonColor = false
  arV1Click.Size = UDim2.new(0.5, 0, 1, 0)
  arV1Click.Position = UDim2.new(0, 0, 0, 0)
  arV1Click.ZIndex = 10
  arV1Click.Parent = arHolder

  local arV2Click = Instance.new("TextButton")
  arV2Click.Name = "V2Click"
  arV2Click.BackgroundTransparency = 1
  arV2Click.Text = ""
  arV2Click.AutoButtonColor = false
  arV2Click.Size = UDim2.new(0.5, 0, 1, 0)
  arV2Click.Position = UDim2.new(0.5, 0, 0, 0)
  arV2Click.ZIndex = 10
  arV2Click.Parent = arHolder

  local function applyARModeVisual(mode)
    local isV2 = (mode == "V2")
    tween(arSlide, {
      Position = isV2 and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
    }, 0.18)
    tween(arV1Text, {
      TextTransparency = isV2 and 0.5 or 0,
      TextStrokeTransparency = isV2 and 0.38 or 0.2
    }, 0.14)
    tween(arV2Text, {
      TextTransparency = isV2 and 0 or 0.5,
      TextStrokeTransparency = isV2 and 0.2 or 0.38
    }, 0.14)
  end

  local function setARMode(mode)
    if mode ~= "V2" then mode = "V1" end
    local wasEnabled = antiRagdollEnabled
    if wasEnabled then stopAntiRagdoll() end
    _G._AmbitiousAntiRagdollMode = mode
    applyARModeVisual(mode)
    if wasEnabled then startAntiRagdoll() end
    saveAmbitiousConfig()
  end

  _G.AmbitiousRefreshAntiRagdollModeSelector = function()
    applyARModeVisual(_G._AmbitiousAntiRagdollMode or "V1")
  end

  local function setExpandedAR(expanded)
    arModeExpanded = expanded
    _G._AmbitiousExpand(arHolder, expanded, 42, arArrow)
  end

  arArrow.Activated:Connect(function()
    setExpandedAR(not arModeExpanded)
  end)
  arV1Click.MouseButton1Click:Connect(function()
    setARMode("V1")
  end)
  arV2Click.MouseButton1Click:Connect(function()
    setARMode("V2")
  end)

  applyARModeVisual(_G._AmbitiousAntiRagdollMode or "V1")
end
-- ===== FINE ANTI RAGDOLL MODE SELECTOR BUILDER =====

_, setAntiRagdollVisual = toggleRow(Movement, "Anti Ragdoll", antiRagdollEnabled, 16)
do
  local row = Movement:FindFirstChild("Anti Ragdoll")
  _ambitiousBtn = row and row:FindFirstChild("ToggleButton")
  if _ambitiousBtn then
    _ambitiousBtn.Activated:Connect(function()
      setAntiRagdoll(not antiRagdollEnabled)
      if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end
      saveAmbitiousConfig()
    end)
  end
  if row then
    _G._AmbitiousBuildAntiRagdollModeSelector(row, Movement)
  end
end

_, _SV.setAntiDieVisual = toggleRow(Movement, "Anti Die", antiDieEnabled, 17)
do
  local row = Movement:FindFirstChild("Anti Die")
  _ambitiousBtn = row and row:FindFirstChild("ToggleButton")
  if _ambitiousBtn then
    _ambitiousBtn.Activated:Connect(function()
      local wanted = _G._AmbitiousAntiDieUserWanted == true

      -- Riga spenta ma Anti Die gia' acceso in background da un modulo: il
      -- click non spegne, te lo fa ADOTTARE. Da qui in poi e' roba tua e
      -- resta acceso anche quando il modulo finisce.
      if not wanted and _G._AmbitiousAntiDieAutoOn then
        _G._AmbitiousAntiDieAutoOn = false
        _G._AmbitiousAntiDieUserWanted = true
        antiDieEnabled = true
        if _SV.setAntiDieVisual then _SV.setAntiDieVisual(true) end
        saveAmbitiousConfig()
        return
      end

      -- Tentativo di spegnere il TUO Anti Die mentre un modulo ci conta
      -- sopra: si ignora e si rimette il visivo su ON, cosi' il bottone
      -- sembra bloccato invece di lampeggiare e tornare indietro.
      if wanted and _G.AmbitiousAntiDieLocked and _G.AmbitiousAntiDieLocked() then
        if _SV.setAntiDieVisual then _SV.setAntiDieVisual(true) end
        return
      end

      setAntiDie(not wanted)
      if _SV.setAntiDieVisual then _SV.setAntiDieVisual(_G._AmbitiousAntiDieUserWanted == true) end
      saveAmbitiousConfig()
    end)
  end
end

-- Spostati da Combat: No Player Collision,Safe Mode
_, _G.AmbitiousSetNoPlayerCollisionVisual = toggleRow(Movement, "No Player Collision", _G.AmbitiousNoPlayerCollisionEnabled, 18)
do
  _ambitiousBtn = Movement:FindFirstChild("No Player Collision") and Movement:FindFirstChild("No Player Collision"):FindFirstChild("ToggleButton")
  if _ambitiousBtn then
    _ambitiousBtn.Activated:Connect(function()
      _G.AmbitiousNoPlayerCollisionEnabled = not _G.AmbitiousNoPlayerCollisionEnabled
      if _G.AmbitiousSetNoPlayerCollisionVisual then _G.AmbitiousSetNoPlayerCollisionVisual(_G.AmbitiousNoPlayerCollisionEnabled) end
      if _G.AmbitiousNoPlayerCollisionEnabled then
        if enableNoPlayerCollision then enableNoPlayerCollision() end
      else
        if disableNoPlayerCollision then disableNoPlayerCollision() end
      end
      saveAmbitiousConfig()
    end)
  end
end

_, _SV.setUnwalkVisual = toggleRow(Movement, "Unwalk", unwalkEnabled, 19)
do
  _ambitiousBtn = Movement:FindFirstChild("Unwalk") and Movement:FindFirstChild("Unwalk"):FindFirstChild("ToggleButton")
  if _ambitiousBtn then
    _ambitiousBtn.Activated:Connect(function()
      if unwalkEnabled then stopUnwalk() else startUnwalk() end
      if _SV.setUnwalkVisual then _SV.setUnwalkVisual(unwalkEnabled) end
      saveAmbitiousConfig()
    end)
  end
end

_, _SV.setSafeModeVisual = toggleRow(Movement, "Safe Mode", antiKickEnabled, 20)
do
  _ambitiousBtn = Movement:FindFirstChild("Safe Mode") and Movement:FindFirstChild("Safe Mode"):FindFirstChild("ToggleButton")
  if _ambitiousBtn then
    _ambitiousBtn.Activated:Connect(function()
      antiKickEnabled = not antiKickEnabled
      if _SV.setSafeModeVisual then _SV.setSafeModeVisual(antiKickEnabled) end
      if antiKickEnabled and _G.AmbitiousSafeModeForceStop then _G.AmbitiousSafeModeForceStop("SAFE MODE") end
      saveAmbitiousConfig()
    end)
  end
end

-- RIMOSSO animationPackRow

refreshSpeedModeRows()

-- ============================================================
-- COMBAT PAGE (rimossi No Player Collision,Safe Mode)
-- ============================================================
task.wait()
Combat = pages.COMBAT
-- >>> COLOR PICKER CONDIVISO BEGIN
-- Palette unica e ORDINATA, usata da tutti i color picker dell'hub.
-- Ordine: neutri (marrone compreso, cosi' non finisce vicino al rosso),
-- poi rossi/arancioni/gialli, verdi, ciano/blu, viola/rosa.
_G.AmbitiousColorPresets = {
  -- neutri
  Color3.fromRGB(255, 255, 255),
  Color3.fromRGB(230, 230, 230),
  Color3.fromRGB(50, 50, 50),
  Color3.fromRGB(0, 0, 0),
  Color3.fromRGB(0, 0, 0),
  -- rossi / arancioni / gialli
  Color3.fromRGB(0, 0, 0),
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(255, 220, 70),
  -- verdi
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(255, 220, 70),
  -- ciano / blu
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(255, 220, 70),
  -- viola / rosa
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(0, 0, 0),
  Color3.fromRGB(255, 220, 70),
  Color3.fromRGB(255, 220, 70),
}

-- Costruisce una riga "<nome> Color" a tendina, identica a quella del
-- Tracker Color: freccetta sulla riga indicata, pallino di anteprima e
-- bottone PICK che apre il popup con la palette + i campi RGB.
--
-- cfg = {
--   parent    = frame della tab
--   anchorRow = riga su cui mettere la freccetta
--   rowName   = testo della riga (es. "Tracker Color")
--   rowOrder  = LayoutOrder della riga
--   title     = titolo del popup (es. "TRACKER COLOR")
--   getColor  = function() -> Color3      (colore corrente)
--   onColor   = function(Color3)          (applica il nuovo colore)
-- }
-- Ritorna: row, setPreview(Color3)
_G._AmbitiousBuildColorPickerRow = function(cfg)
  local row = baseRow(cfg.parent, cfg.rowName, cfg.rowOrder)
  row.Size = UDim2.new(1, -4, 0, 42)
  row.ClipsDescendants = true
  row.Visible = false

  -- ---- FRECCETTA SULLA RIGA PADRE ----
  if cfg.anchorRow then
    local expanded = false
    local arrow = Instance.new("TextButton")
    arrow.Name = "ColorArrow"
    arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    arrow.BackgroundTransparency = 0.18
    arrow.BorderSizePixel = 0
    arrow.Size = UDim2.new(0, 28, 0, 24)
    arrow.Position = UDim2.new(1, -90, 0.5, -12)
    arrow.Text = "\u{25B2}"
    arrow.TextColor3 = Color3.fromRGB(0, 0, 0)
    arrow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    arrow.TextStrokeTransparency = 0.3
    arrow.TextSize = 15
    arrow.Font = Enum.Font.GothamBold
    arrow.AutoButtonColor = false
    arrow.ZIndex = 8
    arrow.Parent = cfg.anchorRow
    corner(arrow, 7)
    stroke(arrow, COLORS.strokeSoft, 1, 0.45)
    arrow.Activated:Connect(function()
      expanded = not expanded
      _G._AmbitiousExpand(row, expanded, 42, arrow)
    end)
  end

  -- ---- PALLINO DI ANTEPRIMA ----
  local preview = Instance.new("Frame")
  preview.Name = "ColorPreview"
  preview.Size = UDim2.new(0, 28, 0, 28)
  preview.Position = UDim2.new(1, -114, 0.5, -14)
  preview.BackgroundColor3 = cfg.getColor() or Color3.fromRGB(230, 230, 230)
  preview.BorderSizePixel = 0
  preview.ZIndex = 6
  preview.Parent = row
  Instance.new("UICorner", preview).CornerRadius = UDim.new(1, 0)
  local previewStroke = Instance.new("UIStroke")
  previewStroke.Color = Color3.fromRGB(255, 255, 255)
  previewStroke.Thickness = 1.5
  previewStroke.Transparency = 0.3
  previewStroke.Parent = preview

  -- ---- BOTTONE PICK ----
  local btnHolder = Instance.new("Frame")
  btnHolder.Name = "ColorButtonHolder"
  btnHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  btnHolder.BackgroundTransparency = 0.28
  btnHolder.BorderSizePixel = 0
  btnHolder.Size = UDim2.new(0, 66, 0, 30)
  btnHolder.Position = UDim2.new(1, -73, 0.5, -15)
  btnHolder.ClipsDescendants = true
  btnHolder.ZIndex = 6
  btnHolder.Parent = row
  corner(btnHolder, 15)
  stroke(btnHolder, Color3.fromRGB(255, 220, 70), 1.5, 0.15)

  local pickGrad = Instance.new("UIGradient")
  pickGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
  })
  pickGrad.Rotation = 18
  pickGrad.Parent = btnHolder
  _G._AmbitiousRegAccent(btnHolder, pickGrad, "pick")

  local pickBtn = Instance.new("TextButton")
  pickBtn.Name = "ColorButton"
  pickBtn.BackgroundTransparency = 1
  pickBtn.Text = "PICK"
  pickBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
  pickBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  pickBtn.TextStrokeTransparency = 0.3
  pickBtn.TextSize = 12
  pickBtn.Font = Enum.Font.GothamBlack
  pickBtn.TextXAlignment = Enum.TextXAlignment.Center
  pickBtn.Size = UDim2.new(1, 0, 1, 0)
  pickBtn.Position = UDim2.new(0, 0, 0, 0)
  pickBtn.BorderSizePixel = 0
  pickBtn.ZIndex = 8
  pickBtn.AutoButtonColor = false
  pickBtn.Parent = btnHolder

  pickBtn.MouseEnter:Connect(function()
    tween(btnHolder, {Size = UDim2.new(0, 72, 0, 32), Position = UDim2.new(1, -76, 0.5, -16)}, 0.12)
  end)
  pickBtn.MouseLeave:Connect(function()
    tween(btnHolder, {Size = UDim2.new(0, 66, 0, 30), Position = UDim2.new(1, -73, 0.5, -15)}, 0.12)
  end)

  local function setPreview(c)
    if c then preview.BackgroundColor3 = c end
  end

  -- ---- POPUP ----
  local pickerGui = nil

  local function closePicker()
    if pickerGui and pickerGui.Parent then
      TweenService:Create(pickerGui.Frame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
      task.delay(0.25, function()
        if pickerGui and pickerGui.Parent then pickerGui:Destroy() end
        pickerGui = nil
      end)
    end
  end

  local function applyColor(c)
    setPreview(c)
    if cfg.onColor then cfg.onColor(c) end
  end

  pickBtn.Activated:Connect(function()
    if pickerGui and pickerGui.Parent then
      closePicker()
      return
    end

    pickerGui = Instance.new("ScreenGui")
    pickerGui.Name = "AmbitiousHubColorPicker"
    pickerGui.ResetOnSpawn = false
    pickerGui.IgnoreGuiInset = true
    pickerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pickerGui.DisplayOrder = 9999
    pickerGui.Parent = HubGui

    local backdrop = Instance.new("Frame")
    backdrop.Name = "Backdrop"
    backdrop.Size = UDim2.new(1, 0, 1, 0)
    backdrop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    backdrop.BackgroundTransparency = 0.5
    backdrop.BorderSizePixel = 0
    backdrop.ZIndex = 1
    backdrop.Parent = pickerGui

    local pickerFrame = Instance.new("Frame")
    pickerFrame.Name = "Frame"
    pickerFrame.Size = UDim2.new(0, 320, 0, 420)
    pickerFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
    pickerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pickerFrame.BorderSizePixel = 0
    pickerFrame.ZIndex = 2
    pickerFrame.Parent = pickerGui
    corner(pickerFrame, 16)
    stroke(pickerFrame, Color3.fromRGB(0, 0, 0), 1.2, 0.3)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 44)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    titleBar.BackgroundTransparency = 0.1
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 3
    titleBar.Parent = pickerFrame
    corner(titleBar, 16)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = cfg.title or "COLOR"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 4
    titleLabel.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -40, 0, 6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 13
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 4
    closeBtn.Parent = titleBar
    corner(closeBtn, 8)
    stroke(closeBtn, Color3.fromRGB(0, 0, 0), 1, 0.4)
    closeBtn.MouseEnter:Connect(function()
      tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(255, 220, 70)}, 0.12)
    end)
    closeBtn.MouseLeave:Connect(function()
      tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}, 0.12)
    end)
    closeBtn.Activated:Connect(closePicker)

    local currentPreview = Instance.new("Frame")
    currentPreview.Name = "CurrentPreview"
    currentPreview.Size = UDim2.new(0, 64, 0, 64)
    currentPreview.Position = UDim2.new(0.5, -32, 0, 60)
    currentPreview.BackgroundColor3 = preview.BackgroundColor3
    currentPreview.BorderSizePixel = 0
    currentPreview.ZIndex = 3
    currentPreview.Parent = pickerFrame
    Instance.new("UICorner", currentPreview).CornerRadius = UDim.new(1, 0)
    local cpStroke = Instance.new("UIStroke")
    cpStroke.Color = Color3.fromRGB(255, 255, 255)
    cpStroke.Thickness = 2
    cpStroke.Transparency = 0.2
    cpStroke.Parent = currentPreview

    local colorGrid = Instance.new("Frame")
    colorGrid.Name = "ColorGrid"
    colorGrid.Size = UDim2.new(1, -24, 0, 240)
    colorGrid.Position = UDim2.new(0, 12, 0, 140)
    colorGrid.BackgroundTransparency = 1
    colorGrid.BorderSizePixel = 0
    colorGrid.ZIndex = 3
    colorGrid.Parent = pickerFrame

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 42, 0, 42)
    gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
    gridLayout.FillDirection = Enum.FillDirection.Horizontal
    gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = colorGrid

    for i, color in ipairs(_G.AmbitiousColorPresets) do
      local cBtn = Instance.new("TextButton")
      cBtn.Name = "Color_" .. i
      cBtn.Size = UDim2.new(1, 0, 1, 0)
      cBtn.BackgroundColor3 = color
      cBtn.BorderSizePixel = 0
      cBtn.Text = ""
      cBtn.AutoButtonColor = false
      cBtn.LayoutOrder = i
      cBtn.ZIndex = 4
      cBtn.Parent = colorGrid
      Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 14)

      local cGrad = Instance.new("UIGradient")
      cGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, color),
        ColorSequenceKeypoint.new(1, color),
      })
      cGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 0),
      })
      cGrad.Rotation = 125
      cGrad.Parent = cBtn

      local cStroke = Instance.new("UIStroke")
      cStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      cStroke.Color = Color3.fromRGB(255, 255, 255)
      cStroke.Thickness = 1.5
      cStroke.Transparency = 0.65
      cStroke.Parent = cBtn

      cBtn.MouseEnter:Connect(function()
        tween(cBtn, {Size = UDim2.new(1, 8, 1, 8), Position = UDim2.new(0, -4, 0, -4)}, 0.12)
        tween(cStroke, {Transparency = 0, Thickness = 2.6}, 0.12)
      end)
      cBtn.MouseLeave:Connect(function()
        tween(cBtn, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)}, 0.12)
        tween(cStroke, {Transparency = 0.65, Thickness = 1.5}, 0.12)
      end)
      cBtn.Activated:Connect(function()
        applyColor(color)
        currentPreview.BackgroundColor3 = color
        closePicker()
      end)
    end

    local rgbFrame = Instance.new("Frame")
    rgbFrame.Name = "RGBFrame"
    rgbFrame.Size = UDim2.new(1, -24, 0, 36)
    rgbFrame.Position = UDim2.new(0, 12, 1, -52)
    rgbFrame.BackgroundTransparency = 1
    rgbFrame.ZIndex = 3
    rgbFrame.Parent = pickerFrame

    local rBox = Instance.new("TextBox")
    rBox.Name = "R"
    rBox.Size = UDim2.new(0, 80, 1, 0)
    rBox.Position = UDim2.new(0, 0, 0, 0)
    rBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    rBox.Text = tostring(math.floor(preview.BackgroundColor3.R * 255))
    rBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    rBox.Font = Enum.Font.GothamBold
    rBox.TextSize = 13
    rBox.ClearTextOnFocus = false
    rBox.ZIndex = 4
    rBox.Parent = rgbFrame
    corner(rBox, 8)
    stroke(rBox, Color3.fromRGB(255, 220, 70), 1, 0.4)

    local gBox = Instance.new("TextBox")
    gBox.Name = "G"
    gBox.Size = UDim2.new(0, 80, 1, 0)
    gBox.Position = UDim2.new(0.5, -40, 0, 0)
    gBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    gBox.Text = tostring(math.floor(preview.BackgroundColor3.G * 255))
    gBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    gBox.Font = Enum.Font.GothamBold
    gBox.TextSize = 13
    gBox.ClearTextOnFocus = false
    gBox.ZIndex = 4
    gBox.Parent = rgbFrame
    corner(gBox, 8)
    stroke(gBox, Color3.fromRGB(255, 220, 70), 1, 0.4)

    local bBox = Instance.new("TextBox")
    bBox.Name = "B"
    bBox.Size = UDim2.new(0, 80, 1, 0)
    bBox.Position = UDim2.new(1, -80, 0, 0)
    bBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bBox.Text = tostring(math.floor(preview.BackgroundColor3.B * 255))
    bBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    bBox.Font = Enum.Font.GothamBold
    bBox.TextSize = 13
    bBox.ClearTextOnFocus = false
    bBox.ZIndex = 4
    bBox.Parent = rgbFrame
    corner(bBox, 8)
    stroke(bBox, Color3.fromRGB(255, 220, 70), 1, 0.4)

    local function applyRGB()
      local r = math.clamp(tonumber(rBox.Text) or 0, 0, 255)
      local g = math.clamp(tonumber(gBox.Text) or 0, 0, 255)
      local b = math.clamp(tonumber(bBox.Text) or 0, 0, 255)
      local newColor = Color3.fromRGB(r, g, b)
      applyColor(newColor)
      currentPreview.BackgroundColor3 = newColor
      rBox.Text = tostring(r)
      gBox.Text = tostring(g)
      bBox.Text = tostring(b)
    end

    rBox.FocusLost:Connect(applyRGB)
    gBox.FocusLost:Connect(applyRGB)
    bBox.FocusLost:Connect(applyRGB)

    backdrop.InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1
         or input.UserInputType == Enum.UserInputType.Touch then
        closePicker()
      end
    end)

    pickerFrame.Size = UDim2.new(0, 0, 0, 0)
    pickerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(pickerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
      Size = UDim2.new(0, 320, 0, 420),
      Position = UDim2.new(0.5, -160, 0.5, -210)
    }):Play()
  end)

  return row, setPreview
end
-- <<< COLOR PICKER CONDIVISO END

section(Combat, "AUTO STEAL", 1)
autoStealSelectorRow(Combat, 2)
_ambitiousRow, setAutoStealVisual = toggleRow(Combat, "Auto Steal", autoStealEnabled, 3)
do
  _ambitiousBtn = _ambitiousRow and _ambitiousRow:FindFirstChild("ToggleButton")
  if _ambitiousBtn then
    _ambitiousBtn.Activated:Connect(function()
      autoStealEnabled = not autoStealEnabled
      if setAutoStealVisual then setAutoStealVisual(autoStealEnabled) end
      if _G.AmbitiousAutoStealSync then _G.AmbitiousAutoStealSync() end
      saveAmbitiousConfig()
    end)
  end
end

_, radiusBox = textboxRow(Combat, "Radius", tostring(autoStealRadius), 4)
autoStealRadiusBox = radiusBox
-- Corregge il valore iniziale del box in base al modo caricato dal config
if selectedStealMode == "Semi" then
  radiusBox.Text = tostring(_G.AmbitiousStealRadii.Semi or 60)
else
  radiusBox.Text = tostring(_G.AmbitiousStealRadii.Normal or 62)
end
radiusBox.FocusLost:Connect(function()
  local v = tonumber(radiusBox.Text)
  _G.AmbitiousStealRadii = _G.AmbitiousStealRadii or {Normal = 62, Semi = 60}
  if true then
    if v and v > 0 and v <= 500 then
      autoStealRadius = v
    end
    _G.AmbitiousStealRadii[selectedStealMode] = autoStealRadius
    radiusBox.Text = tostring(autoStealRadius)
    if _G.AmbitiousNormalAutoStealSetRadius then _G.AmbitiousNormalAutoStealSetRadius(_G.AmbitiousStealRadii.Normal or 62) end
    if _G.AmbitiousSemiAutoStealSetRadius then _G.AmbitiousSemiAutoStealSetRadius(_G.AmbitiousStealRadii.Semi or 60) end
  end
  if _G.AmbitiousAutoStealSync then _G.AmbitiousAutoStealSync() end
  saveAmbitiousConfig()
end)

-- ===== SEMI SUB-MODE SELECTOR REMOVED: Semi uses V3 only =====
-- ===== SEMI STEAL SETTINGS (visibili solo in modalitÃ  Semi) =====
;(function()
  local A = _G.AmbitiousSemiSteal

  local function getSemi(key, def)
    return A and A[key] or def
  end
  local function setSemi(key, val)
    if A then A[key] = val end
  end

  -- Delay Radius (4.1) â€” raggio entro cui scatta il trigger nella fase 2 (Semi V1)
  local _, delayRadBox = textboxRow(Combat, "Delay Radius", tostring(getSemi("autoGrabSetDelayRadius", 8)), 4.1)
  _G.AmbitiousDelayRadBox = delayRadBox
  delayRadBox.FocusLost:Connect(function()
    local v = tonumber(delayRadBox.Text)
    if v and v > 0 and v <= 500 then
      setSemi("autoGrabSetDelayRadius", v)
    end
    delayRadBox.Text = tostring(getSemi("autoGrabSetDelayRadius", 8))
    saveAmbitiousConfig()
  end)

  -- Stop Time (4.2) â€” barra si ferma qui prima di aspettare il raggio (Semi V1)
  local _, stopTimeBox = textboxRow(Combat, "Legacy Stop Time (s)", tostring(getSemi("autoGrabStopTime", 1.29)), 4.2)
  _G.AmbitiousStopTimeBox = stopTimeBox
  stopTimeBox.Parent.Visible = false
  stopTimeBox.FocusLost:Connect(function()
    local v = tonumber(stopTimeBox.Text)
    -- Tetto a 1.29s: oltre, la barra resterebbe ferma a 100% e il trigger
    -- diventerebbe istantaneo, che non e' il comportamento voluto per la V1.
    if v and v > 0 and v <= 1.29 then
      setSemi("autoGrabStopTime", v)
    end
    stopTimeBox.Text = tostring(getSemi("autoGrabStopTime", 1.29))
    saveAmbitiousConfig()
  end)

  -- Stop Time % (4.25) â€” come sopra ma espresso in percentuale di riempimento
  -- della barra (Semi V3). Il motore e' lo stesso della V1: la percentuale
  -- viene convertita in secondi dentro executeSemi.
  local _, stopPctBox = textboxRow(Combat, "Stop Time (%)", tostring(getSemi("autoGrabStopPercent", 75)), 4.25)
  _G.AmbitiousStopPctBox = stopPctBox
  stopPctBox.FocusLost:Connect(function()
    local v = tonumber(stopPctBox.Text)
    if v and v > 0 and v <= 100 then
      setSemi("autoGrabStopPercent", v)
    end
    stopPctBox.Text = tostring(getSemi("autoGrabStopPercent", 75))
    saveAmbitiousConfig()
  end)

  

  -- Funzione per mostrare/nascondere le righe in base alla modalitÃ 
  local function refreshSemiRowsVisibility()
    local onSemi = selectedStealMode == "Semi"
    local onV3   = onSemi


    -- Delay Radius: usato sia dalla V1 che dalla V3 (stesso motore)
    if delayRadBox and delayRadBox.Parent then delayRadBox.Parent.Visible = onSemi end

    -- Semi usa esclusivamente V3: stop espresso in percentuale.
    if stopTimeBox and stopTimeBox.Parent then stopTimeBox.Parent.Visible = false end
    if stopPctBox and stopPctBox.Parent then stopPctBox.Parent.Visible = onSemi end

  
    -- aggiorna i valori quando si torna nei rispettivi tab
    if A then
      stopPctBox.Text = tostring(A.autoGrabStopPercent or 75)
      delayRadBox.Text = tostring(A.autoGrabSetDelayRadius or 8)
    end
  end

  -- Mostra subito lo stato corretto
  refreshSemiRowsVisibility()

  -- Espone la funzione per essere chiamata dal mode switcher (Normal/Semi slider e V1/V2/V3 slider)
  _G.AmbitiousRefreshSemiStealRows = refreshSemiRowsVisibility
end)()

-- ===== SYNCHRONIZE AFTER HIT (condiviso Normal + Semi) =====
-- Ordine 3 come il toggle Auto Steal: essendo creata dopo, finisce
-- subito sotto di esso e sopra il Radius (4).
do
  local syncRow, _setSyncVisual = toggleRow(Combat, "Synchronize After Hit", _G._AmbitiousSyncAfterHit.enabled, 3)
  _G._AmbitiousSyncAfterHit.setVisual = _setSyncVisual
  local syncBtn = syncRow and syncRow:FindFirstChild("ToggleButton")
  if syncBtn then
    syncBtn.Activated:Connect(function()
      _G._AmbitiousSyncAfterHit.enabled = not _G._AmbitiousSyncAfterHit.enabled
      if _G._AmbitiousSyncAfterHit.setVisual then _G._AmbitiousSyncAfterHit.setVisual(_G._AmbitiousSyncAfterHit.enabled) end
      if _G._AmbitiousSyncAfterHit.enabled then
        _startSyncAfterHitWatcher()
      else
        _stopSyncAfterHitWatcher()
      end
      saveAmbitiousConfig()
    end)
  end
  -- applica stato iniziale al watcher (giÃ  avviato sopra, ma rifÃ  il visual)
  if _G._AmbitiousSyncAfterHit.setVisual then _G._AmbitiousSyncAfterHit.setVisual(_G._AmbitiousSyncAfterHit.enabled) end
end

section(Combat, "BAT BYPASS", 5)
aimbotModeButtonRow(Combat, 6)


-- Compatibility aliases for the TP Bat integration.
_G.VX7StartBatTP = _G.AmbitiousStartBatTP
_G.VX7StopBatTP = _G.AmbitiousStopBatTP
_G.VX7ToggleBatTP = _G.AmbitiousToggleBatTP

-- TP BAT: single Clean source implementation
local batTPRow, batTPSetVisual = toggleRow(Combat, "TP Bat", _G.AmbitiousBatTPOn == true, 6.5)
_G.AmbitiousRefreshBatTPVisual = function()
  if batTPSetVisual then batTPSetVisual(_G.AmbitiousBatTPOn == true) end
  if _G.AmbitiousRefreshMobileButtonStates then pcall(_G.AmbitiousRefreshMobileButtonStates) end
end
if batTPRow then
  local btn = batTPRow:FindFirstChild("ToggleButton")
  if btn then
    local busy = false
    local function doBatTPButtonToggle()
      if busy then return end
      busy = true
      -- Usa sempre Toggle: spegne davvero il loop (token + task.cancel)
      if type(_G.AmbitiousToggleBatTP) == "function" then
        pcall(_G.AmbitiousToggleBatTP)
      elseif _G.AmbitiousBatTPOn then
        if type(_G.AmbitiousStopBatTP) == "function" then pcall(_G.AmbitiousStopBatTP) end
      else
        if type(_G.AmbitiousStartBatTP) == "function" then pcall(_G.AmbitiousStartBatTP) end
      end
      if _G.AmbitiousRefreshBatTPVisual then pcall(_G.AmbitiousRefreshBatTPVisual) end
      if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
      task.delay(0.15, function() busy = false end)
    end
    -- Activated copre mobile + PC; MouseButton1Click resta come fallback
    btn.Activated:Connect(doBatTPButtonToggle)
  end
end
if _G.AmbitiousRefreshAimbotVisual then _G.AmbitiousRefreshAimbotVisual() end

-- TP Bat: single Clean source implementation; no V1/V2 selector.
_G.AmbitiousBatTPVersion = "CLEAN"

_G.AmbitiousMirrorTPDownRow, _G.AmbitiousMirrorTPDownSetVisual, _G.AmbitiousMirrorTPDownBtn = _G.AmbitiousActionToggleRow(Combat, "Mirror TP Down (Recommended)", mirrorTPDownEnabled, 7.1)
local mirrorTPDownLabel = _G.AmbitiousMirrorTPDownRow and _G.AmbitiousMirrorTPDownRow:FindFirstChild("Label")
if mirrorTPDownLabel then mirrorTPDownLabel.TextSize = 10 end
if _G.AmbitiousMirrorTPDownBtn then
  _G.AmbitiousMirrorTPDownBtn.MouseButton1Click:Connect(function()
    if _G.AmbitiousMirrorTPDownClickBusy then return end
    _G.AmbitiousMirrorTPDownClickBusy = true
    _G.AmbitiousSetMirrorTPDown(not mirrorTPDownEnabled)
    saveAmbitiousConfig()
    task.delay(0.12, function() _G.AmbitiousMirrorTPDownClickBusy = false end)
  end)
end

aimbotSpeedRow, aimbotSpeedBox = textboxRow(Combat, "Bat Bypass Speed", tostring(AIMBOT_SPEED), 8)
_G.AmbitiousAimbotSpeedBox = aimbotSpeedBox
aimbotSpeedLabel = aimbotSpeedRow and aimbotSpeedRow:FindFirstChild("Label")
refreshAimbotModeLabels()
aimbotSpeedBox.FocusLost:Connect(function()
  local v = tonumber(aimbotSpeedBox.Text)
  if v and v > 0 and v <= 250 then
    _G.AmbitiousSetSelectedAimbotSpeedValues(v, nil)
  end
  if _G.AmbitiousRefreshAimbotSpeedBoxes then _G.AmbitiousRefreshAimbotSpeedBoxes() else aimbotSpeedBox.Text = tostring(AIMBOT_SPEED) end
  saveAmbitiousConfig()
end)

laggerAimbotSpeedRow, laggerAimbotSpeedBox = textboxRow(Combat, "Bat Bypass Lagger Speed", tostring(LAGGER_AIMBOT_SPEED), 9)
_G.AmbitiousLaggerAimbotSpeedBox = laggerAimbotSpeedBox
laggerAimbotSpeedLabel = laggerAimbotSpeedRow and laggerAimbotSpeedRow:FindFirstChild("Label")
refreshAimbotModeLabels()
if _G.AmbitiousRefreshAimbotSpeedBoxes then _G.AmbitiousRefreshAimbotSpeedBoxes() end
laggerAimbotSpeedBox.FocusLost:Connect(function()
  local v = tonumber(laggerAimbotSpeedBox.Text)
  if v and v > 0 and v <= 250 then
    _G.AmbitiousSetSelectedAimbotSpeedValues(nil, v)
  end
  if _G.AmbitiousRefreshAimbotSpeedBoxes then _G.AmbitiousRefreshAimbotSpeedBoxes() else laggerAimbotSpeedBox.Text = tostring(LAGGER_AIMBOT_SPEED) end
  saveAmbitiousConfig()
end)

-- ===== BUILDER BAT COUNTER MODE SELECTOR (V1 / V2) =====
_G._AmbitiousBuildBatCounterModeSelector = function(row, parentFrame)
  local batModeExpanded = false

  local arrowBtn = Instance.new("TextButton")
  arrowBtn.Name = "BatCounterModeArrow"
  arrowBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  arrowBtn.BackgroundTransparency = 0.18
  arrowBtn.BorderSizePixel = 0
  arrowBtn.Size = UDim2.new(0, 28, 0, 24)
  arrowBtn.Position = UDim2.new(1, -90, 0.5, -12)
  arrowBtn.Text = "â–²"
  arrowBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
  arrowBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  arrowBtn.TextStrokeTransparency = 0.3
  arrowBtn.TextSize = 15
  arrowBtn.Font = Enum.Font.GothamBold
  arrowBtn.AutoButtonColor = false
  arrowBtn.ZIndex = 8
  arrowBtn.Parent = row
  corner(arrowBtn, 7)
  stroke(arrowBtn, COLORS.strokeSoft, 1, 0.45)

  local batModeHolder = Instance.new("Frame")
  batModeHolder.Name = "Bat Counter Mode Selector"
  batModeHolder.BackgroundColor3 = COLORS.row
  batModeHolder.BackgroundTransparency = 0.28
  batModeHolder.Size = UDim2.new(1, -4, 0, 42)
  batModeHolder.BorderSizePixel = 0
  batModeHolder.LayoutOrder = 12
  batModeHolder.ZIndex = 4
  batModeHolder.ClipsDescendants = true
  batModeHolder.Visible = false
  batModeHolder.Parent = parentFrame
  corner(batModeHolder, 14)
  stroke(batModeHolder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
  _G._AmbitiousRegAccent(batModeHolder, nil, "soft")

  local batModeSlide = Instance.new("Frame")
  batModeSlide.Name = "SelectedSlide"
  batModeSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  batModeSlide.BackgroundTransparency = 0.1
  batModeSlide.Size = UDim2.new(0.5, -3, 1, -8)
  batModeSlide.Position = UDim2.new(0, 4, 0, 4)
  batModeSlide.BorderSizePixel = 0
  batModeSlide.ZIndex = 5
  batModeSlide.Parent = batModeHolder
  corner(batModeSlide, 13)
  local bmsStroke = Instance.new("UIStroke")
  bmsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  bmsStroke.Color = Color3.fromRGB(255, 220, 70)
  bmsStroke.Thickness = 1
  bmsStroke.Transparency = 0.08
  bmsStroke.Parent = batModeSlide
  local bmsGrad = Instance.new("UIGradient")
  bmsGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
  })
  bmsGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.08),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.08),
  })
  bmsGrad.Parent = batModeSlide
  _G._AmbitiousRegAccent(batModeSlide, bmsGrad, "slide")

  local v1Text = Instance.new("TextLabel")
  v1Text.Name = "V1Text"
  v1Text.BackgroundTransparency = 1
  v1Text.Text = "COUNTER V1"
  v1Text.TextColor3 = Color3.fromRGB(0, 0, 0)
  v1Text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  v1Text.TextStrokeTransparency = 0.2
  v1Text.TextSize = 11
  v1Text.Font = Enum.Font.GothamBlack
  v1Text.TextXAlignment = Enum.TextXAlignment.Center
  v1Text.Size = UDim2.new(0.5, 0, 1, 0)
  v1Text.Position = UDim2.new(0, 0, 0, 0)
  v1Text.ZIndex = 8
  v1Text.Parent = batModeHolder

  local v2Text = Instance.new("TextLabel")
  v2Text.Name = "V2Text"
  v2Text.BackgroundTransparency = 1
  v2Text.Text = "COUNTER V2"
  v2Text.TextColor3 = Color3.fromRGB(0, 0, 0)
  v2Text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  v2Text.TextStrokeTransparency = 0.2
  v2Text.TextSize = 11
  v2Text.Font = Enum.Font.GothamBlack
  v2Text.TextXAlignment = Enum.TextXAlignment.Center
  v2Text.Size = UDim2.new(0.5, 0, 1, 0)
  v2Text.Position = UDim2.new(0.5, 0, 0, 0)
  v2Text.ZIndex = 8
  v2Text.Parent = batModeHolder

  local v1Click = Instance.new("TextButton")
  v1Click.Name = "V1Click"
  v1Click.BackgroundTransparency = 1
  v1Click.Text = ""
  v1Click.AutoButtonColor = false
  v1Click.Size = UDim2.new(0.5, 0, 1, 0)
  v1Click.Position = UDim2.new(0, 0, 0, 0)
  v1Click.ZIndex = 10
  v1Click.Parent = batModeHolder

  local v2Click = Instance.new("TextButton")
  v2Click.Name = "V2Click"
  v2Click.BackgroundTransparency = 1
  v2Click.Text = ""
  v2Click.AutoButtonColor = false
  v2Click.Size = UDim2.new(0.5, 0, 1, 0)
  v2Click.Position = UDim2.new(0.5, 0, 0, 0)
  v2Click.ZIndex = 10
  v2Click.Parent = batModeHolder

  local function applyBatModeVisual(mode)
    local isV2 = (mode == "V2")
    tween(batModeSlide, {
      Position = isV2 and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
    }, 0.18)
    tween(v1Text, {
      TextTransparency = isV2 and 0.5 or 0,
      TextStrokeTransparency = isV2 and 0.38 or 0.2
    }, 0.14)
    tween(v2Text, {
      TextTransparency = isV2 and 0 or 0.5,
      TextStrokeTransparency = isV2 and 0.2 or 0.38
    }, 0.14)
  end

  local function setBatMode(mode)
    if mode ~= "V2" then mode = "V1" end
    batCounterMode = mode
    applyBatModeVisual(batCounterMode)
    saveAmbitiousConfig()
  end

  _G.AmbitiousRefreshBatCounterModeSelector = function()
    applyBatModeVisual(batCounterMode)
  end

  local function setBatModeExpanded(expanded)
    batModeExpanded = expanded
    _G._AmbitiousExpand(batModeHolder, expanded, 42, arrowBtn)
  end

  arrowBtn.Activated:Connect(function()
    setBatModeExpanded(not batModeExpanded)
  end)
  v1Click.MouseButton1Click:Connect(function()
    setBatMode("V1")
  end)
  v2Click.MouseButton1Click:Connect(function()
    setBatMode("V2")
  end)

  applyBatModeVisual(batCounterMode)
end

section(Combat, "COUNTERS", 12)

-- >>> ANTI BAT BEGIN
do
  -- >>> ORDINE COUNTERS: Bat Counter (12) -> Anti Bat (13) <<<
  local _abRow, setAntiBatVisual = toggleRow(Combat, "Anti Bat", _G.AmbitiousAntiBatEnabled == true, 13)
  _SV.setAntiBatVisual = setAntiBatVisual
  local _abBtn = _abRow and _abRow:FindFirstChild("ToggleButton")
  if _abBtn then
    _abBtn.Activated:Connect(function()
      local on = not (_G.AmbitiousAntiBatEnabled == true)
      if _G.AmbitiousAntiBat then _G.AmbitiousAntiBat.setEnabled(on) end
      if setAntiBatVisual then setAntiBatVisual(on) end
      saveAmbitiousConfig()
    end)
  end
end
-- <<< ANTI BAT END

-- >>> ANTI VOID BEGIN
do
  local _avRow, setAntiVoidVisual = toggleRow(Combat, "Anti Void", _G.AmbitiousAntiVoidEnabled == true, 14)
  _SV.setAntiVoidVisual = setAntiVoidVisual
  local _avBtn = _avRow and _avRow:FindFirstChild("ToggleButton")
  if _avBtn then
    _avBtn.Activated:Connect(function()
      local on = not (_G.AmbitiousAntiVoidEnabled == true)
      if _G.AmbitiousAntiVoid then _G.AmbitiousAntiVoid.setEnabled(on) end
      if setAntiVoidVisual then setAntiVoidVisual(on) end
      saveAmbitiousConfig()
    end)
  end
end
-- <<< ANTI VOID END
_, setBatCounterVisual = toggleRow(Combat, "Bat Counter", batCounterEnabled, 12)
do
  _ambitiousBtn = Combat:FindFirstChild("Bat Counter") and Combat:FindFirstChild("Bat Counter"):FindFirstChild("ToggleButton")
  if _ambitiousBtn then
    _ambitiousBtn.Activated:Connect(function()
      batCounterEnabled = not batCounterEnabled
      if setBatCounterVisual then setBatCounterVisual(batCounterEnabled) end
      if batCounterEnabled then
        if _G.AmbitiousStartBatCounter then _G.AmbitiousStartBatCounter() end
      else
        if _G.AmbitiousStopBatCounter then _G.AmbitiousStopBatCounter() end
      end
      saveAmbitiousConfig()
    end)
  end
  local batRow = Combat:FindFirstChild("Bat Counter")
  if batRow then
    _G._AmbitiousBuildBatCounterModeSelector(batRow, Combat)
  end
end

_, setMedCounterVisual = toggleRow(Combat, "Med Counter", medCounterEnabled, 15)
do
  _ambitiousBtn = Combat:FindFirstChild("Med Counter") and Combat:FindFirstChild("Med Counter"):FindFirstChild("ToggleButton")
  if _ambitiousBtn then
    _ambitiousBtn.Activated:Connect(function()
      medCounterEnabled = not medCounterEnabled
      if setMedCounterVisual then setMedCounterVisual(medCounterEnabled) end
      if medCounterEnabled then
        if _G.AmbitiousStartMedCounter then _G.AmbitiousStartMedCounter(LP.Character) end
      else
        if _G.AmbitiousStopMedCounter then _G.AmbitiousStopMedCounter() end
      end
      saveAmbitiousConfig()
    end)
  end
end


-- RIMOSSI Counter, No Player Collision, Safe Mode (spostati in Movement)

task.wait()
Keybinds = pages.KEYBINDS
section(Keybinds, "MOVEMENT KEYBINDS", 1)
speedKeybindRow(Keybinds, "Speed Key", "SpeedToggle", 2)
speedKeybindRow(Keybinds, "Lagger Mode Key", "LaggerToggle", 3)
tpDownKeybindRow(Keybinds, 4)
speedKeybindRow(Keybinds, "Drop Brainrot", "DropBrainrot", 5)

section(Keybinds, "COMBAT KEYBINDS", 6)
aimbotKeybindRow = speedKeybindRow(Keybinds, "Bat Bypass", "BatBypass", 7)
combatAimbotKeybindLabel = aimbotKeybindRow and aimbotKeybindRow:FindFirstChild("Label")
refreshAimbotModeLabels()
-- VX7 TP BAT KEYBIND: configurable keybind, default T
tpBatKeybindRow = speedKeybindRow(Keybinds, "TP Bat", "BatTP", 8)
tpBatKeybindLabel = tpBatKeybindRow and tpBatKeybindRow:FindFirstChild("Label")
-- Stesso LayoutOrder e creata subito dopo: a parita' di ordine il
-- UIListLayout rispetta l'inserimento, quindi finisce sotto i combat keybind.
speedKeybindRow(Keybinds, "Float", "Float", 9)
speedKeybindRow(Keybinds, "Auto Play", "AutoPlay", 10)
speedKeybindRow(Keybinds, "Instant Reset", "InstantReset", 12)

-- ============================================================
-- VISUALS PAGE
-- ============================================================
do
  THEME_ACCENT = THEME_ACCENT or Color3.fromRGB(0, 0, 0)
  THEME_ACCENT_DIM = THEME_ACCENT_DIM or Color3.fromRGB(145, 145, 145)
  PlayerESP = PlayerESP or {enabled=false, playerData={}, conns={}, discordText="<font color=\"#FFD84A\">Gesu</font><font color=\"#FFFFFF\"> Hub</font>"}
  BoxedESPOptions = BoxedESPOptions or {box=false, tracker=false, trackerColor=Color3.fromRGB(255, 220, 70)}
  BoxedESPData = BoxedESPData or {}
  BoxedESPConn = BoxedESPConn or nil
  stretchRezConn = stretchRezConn or nil
  antiLagDescConn = antiLagDescConn or nil
  noCamCollisionConn = noCamCollisionConn or nil
  noCamCollisionParts = noCamCollisionParts or {}
  _ambitiousCustomFontOrig = _ambitiousCustomFontOrig or {}
  _ambitiousCustomFontConn = _ambitiousCustomFontConn or nil
  _ambitiousCustomFont = _ambitiousCustomFont or nil

function startPlayerESP()
    if PlayerESP.enabled then return end
    PlayerESP.enabled = true

    function cleanup(plr)
        local d = PlayerESP.playerData[plr]; if not d then return end
        pcall(function() if d.highlight then d.highlight:Destroy() end end)
        pcall(function() if d.billboard then d.billboard:Destroy() end end)
        if d.conns then for _,c in ipairs(d.conns) do pcall(function() c:Disconnect() end) end end
        PlayerESP.playerData[plr] = nil
    end

    function setup(plr, char)
        if not PlayerESP.enabled or plr == LP then return end
        cleanup(plr)
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",5))
        local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head",5))
        if not hrp or not head then return end

        local hl = Instance.new("Highlight")
        hl.Name = "AmbitiousHubESP"; hl.Adornee = char; hl.FillColor = Color3.fromRGB(0, 0, 0); hl.FillTransparency = 0.78
        hl.OutlineColor = Color3.fromRGB(0, 0, 0); hl.OutlineTransparency = 0; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = char

        local bb = Instance.new("BillboardGui")
        bb.Name = "AmbitiousHubESPTag"; bb.Adornee = head; bb.Size = UDim2.new(0,124,0,34); bb.StudsOffset = Vector3.new(0,2.7,0); bb.AlwaysOnTop = true; bb.LightInfluence = 0; bb.Parent = head

        local box = Instance.new("Frame", bb); box.Size = UDim2.new(1,0,1,0); box.BackgroundTransparency = 1; box.BorderSizePixel = 0
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,9)

        -- Label velocitÃ  (dimensione piÃ¹ grande)
        local n = Instance.new("TextLabel", box)
        n.Size = UDim2.new(1,-10,0,17)
        n.Position = UDim2.new(0,5,0,2)
        n.BackgroundTransparency = 1
        n.TextColor3 = Color3.fromRGB(0, 0, 0)
        n.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        n.Font = Enum.Font.GothamBlack
        n.TextSize = 22
        n.TextStrokeTransparency = 0.25

        local conn = RunService.Heartbeat:Connect(function()
            if not PlayerESP.enabled or not hrp.Parent then return end
            local v = hrp.AssemblyLinearVelocity or hrp.Velocity
            n.Text = string.format("%d speed", math.floor(Vector3.new(v.X,0,v.Z).Magnitude+0.5))
        end)

        PlayerESP.playerData[plr] = {highlight = hl, billboard = bb, conns = {conn}}
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            if plr.Character then setup(plr, plr.Character) end
            table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup, plr, c) end))
        end
    end
    table.insert(PlayerESP.conns, Players.PlayerAdded:Connect(function(plr)
        if plr ~= LP then
            table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup, plr, c) end))
        end
    end))
    table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(cleanup))
end

  function stopPlayerESP()
    PlayerESP.enabled = false
    for _, c in ipairs(PlayerESP.conns or {}) do pcall(function() c:Disconnect() end) end
    PlayerESP.conns = {}
    for plr, d in pairs(PlayerESP.playerData or {}) do
      pcall(function() if d.highlight then d.highlight:Destroy() end end)
      pcall(function() if d.billboard then d.billboard:Destroy() end end)
      -- La Heartbeat che aggiorna la velocita' del nemico va chiusa qui,
      -- altrimenti resta viva a girare a vuoto e se ne accumula una per
      -- giocatore ad ogni spegnimento.
      if d.conns then
        for _, c in ipairs(d.conns) do pcall(function() c:Disconnect() end) end
      end
    end
    PlayerESP.playerData = {}
  end

  function _ambitiousEspColor()
    if BoxedESPOptions and BoxedESPOptions.trackerColor then
      return BoxedESPOptions.trackerColor
    end
    return THEME_ACCENT or Color3.fromRGB(0,0,0)
  end

  function _safeDrawing(kind, props)
    if not Drawing or not Drawing.new then return nil end
    local ok, obj = pcall(function() return Drawing.new(kind) end)
    if not ok or not obj then return nil end
    for k, v in pairs(props or {}) do pcall(function() obj[k] = v end) end
    return obj
  end

  function _cleanupBoxedESPPlayer(player)
    local data = BoxedESPData[player]
    if not data then return end
    for _, obj in pairs(data) do
      pcall(function()
        obj.Visible = false
        if obj.Remove then obj:Remove() end
      end)
    end
    BoxedESPData[player] = nil
  end

  function _cleanupBoxedESP()
    for player, _ in pairs(BoxedESPData) do _cleanupBoxedESPPlayer(player) end
  end

  local function getEdgePoint(cam, targetWorldPos)
    local view = cam.ViewportSize
    local center = Vector2.new(view.X / 2, view.Y / 2)

    local targetScreen = cam:WorldToViewportPoint(targetWorldPos)
    local targetV2 = Vector2.new(targetScreen.X, targetScreen.Y)

    if targetScreen.Z > 0 then
      local margin = 50
      if targetV2.X >= -margin and targetV2.X <= view.X + margin
         and targetV2.Y >= -margin and targetV2.Y <= view.Y + margin then
        return targetV2
      end
    end

    local dir = targetV2 - center

    if targetScreen.Z <= 0 then
      local playerPos = cam.CFrame.Position
      local toTarget = (targetWorldPos - playerPos).Unit
      local right = cam.CFrame.RightVector
      local up = cam.CFrame.UpVector
      local dotRight = toTarget:Dot(right)
      local dotUp = toTarget:Dot(up)
      dir = Vector2.new(dotRight, -dotUp) * 1000
    end

    local mag = dir.Magnitude
    if mag < 0.001 then
      return Vector2.new(center.X, view.Y - 20)
    end
    dir = dir / mag

    local edgePad = 20
    local halfW = (view.X / 2) - edgePad
    local halfH = (view.Y / 2) - edgePad

    local tX = math.huge
    local tY = math.huge

    if math.abs(dir.X) > 0.001 then
      tX = halfW / math.abs(dir.X)
    end
    if math.abs(dir.Y) > 0.001 then
      tY = halfH / math.abs(dir.Y)
    end

    local t = math.min(tX, tY)

    return Vector2.new(
      math.clamp(center.X + dir.X * t, edgePad, view.X - edgePad),
      math.clamp(center.Y + dir.Y * t, edgePad, view.Y - edgePad)
    )
  end

  function _updateBoxedESP()
    local cam = workspace.CurrentCamera
    if not cam then return end

    local showTracker = BoxedESPOptions and BoxedESPOptions.tracker == true

    if not showTracker then
      _cleanupBoxedESP()
      return
    end

    -- Tracker parte DAL PETTO del tuo personaggio (non dai piedi)
    local function getMyScreenPos()
        local myChar = LP.Character
        if not myChar then return Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y) end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y) end
        -- Offset -1.5: parte dal petto/zona superiore
        local myPos, onScreen = cam:WorldToViewportPoint(myRoot.Position - Vector3.new(0, 1, 0))
        if onScreen then
            return Vector2.new(myPos.X, myPos.Y)
        end
        return Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y - 10)
    end

    local fromPoint = getMyScreenPos()

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end

        local char = player.Character
        if not char then
            _cleanupBoxedESPPlayer(player)
            continue
        end

        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local humanoid = char:FindFirstChildOfClass("Humanoid")

        if not root or not head then
            _cleanupBoxedESPPlayer(player)
            continue
        end

        if humanoid and humanoid.Health <= 0 then
            _cleanupBoxedESPPlayer(player)
            continue
        end

        -- Calcola la posizione 3D del TORSO (metÃ  tra testa e HumanoidRootPart)
        local torsoPos = (root.Position + head.Position) / 2
        -- Sposta leggermente in alto per puntare al petto (non alla pancia)
        torsoPos = torsoPos + Vector3.new(0, -0.7, 0)
        -- >>> ANTI VOID BEGIN
        -- Nemico fuori dalla safe zone: il tracker punta all'ultima
        -- posizione valida invece di seguirlo nel vuoto.
        if _G.AmbitiousAntiVoid then
          local gp, isGhost = _G.AmbitiousAntiVoid.posFor(player, root.Position)
          if isGhost then torsoPos = gp + Vector3.new(0, 1.2, 0) end
        end
        -- <<< ANTI VOID END
        
        -- Converti in coordinate schermo
        local torsoScreen = cam:WorldToViewportPoint(torsoPos)

        if torsoScreen.Z <= 0 then
            _cleanupBoxedESPPlayer(player)
            continue
        end

        local data = BoxedESPData[player]
        if not data then
            data = {
                tracker = _safeDrawing("Line", {
                    Thickness = 2.8,
                    Transparency = 0.15,
                    Color = _ambitiousEspColor(),
                    Visible = false
                }),
                box = _safeDrawing("Square", {
                    Thickness = 1.8,
                    Transparency = 0.15,
                    Color = _ambitiousEspColor(),
                    Filled = false,
                    Visible = false
                }),
            }
            BoxedESPData[player] = data
        end

        local color = _ambitiousEspColor()

        if data.tracker then
            data.tracker.Color = color
            data.tracker.Thickness = 2.5
            data.tracker.From = fromPoint
            -- Punta al TORSO del nemico (calcolato in 3D)
            data.tracker.To = Vector2.new(torsoScreen.X, torsoScreen.Y)
            data.tracker.Visible = true
        end

        -- Box visivo 2D attorno all'avversario. Ãˆ solo un indicatore grafico.
        if data.box then
            local top3D = head.Position + Vector3.new(0, 0.35, 0)
            local bottom3D = root.Position - Vector3.new(0, 2.8, 0)
            local top = cam:WorldToViewportPoint(top3D)
            local bottom = cam:WorldToViewportPoint(bottom3D)
            local h = math.abs(bottom.Y - top.Y)
            local w = math.clamp(h * 0.48, 18, 160)
            data.box.Color = color
            data.box.Position = Vector2.new(torsoScreen.X - w/2, math.min(top.Y, bottom.Y))
            data.box.Size = Vector2.new(w, math.max(h, 20))
            data.box.Visible = true
        end
    end

    for player, _ in pairs(BoxedESPData) do
        if not player.Parent then
            _cleanupBoxedESPPlayer(player)
        end
    end
  end

  -- indice stretch salvato prima di attivare il tracker
  local _trackerSavedStretchIndex = nil

function refreshBoxedESP()
    local trackerOn = BoxedESPOptions and BoxedESPOptions.tracker == true
    _G.AmbitiousTrackerActive = trackerOn   -- <-- NUOVO

    if BoxedESPConn then
        BoxedESPConn:Disconnect()
        BoxedESPConn = nil
    end

    if trackerOn then
        if stretchCurrentIndex ~= 1 then
            _G.AmbitiousTrackerSavedStretchIndex = stretchCurrentIndex   -- <-- NUOVO
            _G._ambitiousStretchUILock = true
            applyStretchPreset(1)
            _G._ambitiousStretchUILock = false

            task.defer(function()
                if _G.AmbitiousTrackerSavedStretchIndex and _G.AmbitiousTrackerSavedStretchIndex ~= 1 then
                    local restoreIdx = _G.AmbitiousTrackerSavedStretchIndex
                    applyStretchPreset(restoreIdx)
                end
            end)
        else
            _G.AmbitiousTrackerSavedStretchIndex = nil
        end

        BoxedESPConn = RunService.RenderStepped:Connect(_updateBoxedESP)
    else
        _cleanupBoxedESP()
        _G.AmbitiousTrackerSavedStretchIndex = nil   -- <-- NUOVO
    end
end

  Players.PlayerRemoving:Connect(_cleanupBoxedESPPlayer)

  -- Le tabelle SKY_PRESETS_LIST / SKY_PRESETS / SKY_PRESET_COLORS complete
  -- sono definite piÃ¹ avanti (blocco "SKY CHANGER"). Questo Ã¨ solo un placeholder
  -- per evitare errori se questo blocco viene eseguito prima di quel blocco.
  SKY_PRESETS_LIST = SKY_PRESETS_LIST or {"Off"}
  SKY_PRESETS = SKY_PRESETS or {["Off"]={kind="off"}}
  SKY_PRESET_COLORS = SKY_PRESET_COLORS or {}

  function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end
  function _v4mpClearSky()
    for _, v in ipairs(Lighting:GetChildren()) do
      if v:GetAttribute("_AmbitiousHubSky") then pcall(function() v:Destroy() end) end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
      for _, v in ipairs(terrain:GetChildren()) do
        if v:GetAttribute("_AmbitiousHubSky") then pcall(function() v:Destroy() end) end
      end
    end
  end

  -- applyCustomSky Ã¨ definita globalmente nel blocco SKY CHANGER (versione completa con anti-destroy).
  -- Questo stub garantisce che chiamate interne al do-block usino quella versione.
  function applyCustomSky(mode)
    -- sarÃ  sovrascritta dalla definizione globale; questo Ã¨ solo un fallback precoce
    skyTheme = (mode == "Off" or not SKY_PRESETS or not SKY_PRESETS[mode]) and "Off" or mode
  end

-- ========== STRETCH REZ: variabili e funzioni definite sopra (prima di loadAmbitiousConfig) ==========
-- (blocco duplicato rimosso: usare le variabili/funzioni del primo blocco per il corretto save/load)

  function enableCustomFov()
    fovEnabled = true
    workspace.CurrentCamera.FieldOfView = fovValue
    if customFovConn then customFovConn:Disconnect() end
    customFovConn = RunService.RenderStepped:Connect(function()
      if not fovEnabled then
        customFovConn:Disconnect()
        customFovConn = nil
        return
      end
      workspace.CurrentCamera.FieldOfView = fovValue
    end)
  end

  function disableCustomFov()
    fovEnabled = false
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    workspace.CurrentCamera.FieldOfView = fpsBoostEnabled and 107 or 70
  end

-- ============================================================
-- NO ANIMATIONS (integrato nell'Anti-Lag)
-- ============================================================

local SetNoAnimations
do
    local _NA = { Enabled = false, SavedTracks = {}, Connections = {} }

    local function _isPlayerAnim(animator)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and animator:IsDescendantOf(plr.Character) then
                return true
            end
        end
        return false
    end

    local function _stopAnimator(animator)
        pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                if not _isPlayerAnim(animator) then
                    _NA.SavedTracks[#_NA.SavedTracks + 1] = { track = track, speed = track.Speed }
                    track:Stop(0)
                end
            end
        end)
    end

    local function _scanAll()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Animator") then _stopAnimator(obj) end
        end
    end

    local function _restoreAll()
        for _, e in ipairs(_NA.SavedTracks) do
            pcall(function()
                if e.track and e.track.Parent then
                    e.track:Play(0)
                    e.track:AdjustSpeed(e.speed)
                end
            end)
        end
        _NA.SavedTracks = {}
    end

    SetNoAnimations = function(enabled)
        _NA.Enabled = enabled
        for _, c in ipairs(_NA.Connections) do pcall(function() c:Disconnect() end) end
        _NA.Connections = {}
        if enabled then
            _scanAll()
            _NA.Connections[#_NA.Connections + 1] = Workspace.DescendantAdded:Connect(function(obj)
                task.defer(function()
                    if not _NA.Enabled then return end
                    if obj:IsA("Animator") then
                        _stopAnimator(obj)
                    elseif obj:IsA("AnimationTrack") then
                        local a = obj.Parent
                        if a and a:IsA("Animator") then _stopAnimator(a) end
                    end
                end)
            end)
        else
            _restoreAll()
        end
    end
end

-- ============================================================
-- ANTI-LAG (versione uranium, adattata a AmbitiousTest)
-- ============================================================

local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:GetAttribute("_AmbitiousHubSky") ~= nil then return end
        if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then return end
        if skyTheme ~= "Off" and obj.Parent == Lighting then
            if obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect") or obj:IsA("ColorCorrectionEffect")
                or obj:IsA("BloomEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("BrightnessEffect")
                or obj:IsA("DitheringEffect") then return end
        end
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            local char = LP.Character
            if char and obj:IsDescendantOf(char) then return end
            obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
            obj.TopSurface    = Enum.SurfaceType.Smooth
            obj.BottomSurface = Enum.SurfaceType.Smooth
            obj.FrontSurface  = Enum.SurfaceType.Smooth
            obj.BackSurface   = Enum.SurfaceType.Smooth
            obj.LeftSurface   = Enum.SurfaceType.Smooth
            obj.RightSurface  = Enum.SurfaceType.Smooth
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 0.5
                end
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 0.5
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        elseif obj:IsA("SelectionBox") and obj.Name ~= "AmbitiousHubESP" then
            pcall(function() obj:Destroy() end)
        end
    end)
end

function enableAntiLag()
    antiLagVisualEnabled = true
    removeAccessoriesEnabled = true

    _G._AmbitiousDefLightBrightness = _G._AmbitiousDefLightBrightness or Lighting.Brightness
    _G._AmbitiousDefLightClock = _G._AmbitiousDefLightClock or Lighting.ClockTime
    _G._AmbitiousDefLightAmbient = _G._AmbitiousDefLightAmbient or Lighting.OutdoorAmbient

    pcall(function()
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Disabled
    end)

    if skyTheme == "Off" then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.FogStart = 0
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ShadowSoftness = 0
        Lighting.ExposureCompensation = 0
        pcall(function() Lighting.Technology = Enum.Technology.Compatibility end)

        for _, e in pairs(Lighting:GetChildren()) do
            pcall(function()
                -- Non toccare gli effetti di Vivid Graphics
                if e:GetAttribute("_AmbitiousVivid") then return end
                if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                    or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("BrightnessEffect")
                    or e:IsA("DitheringEffect") then
                    e.Enabled = false
                end
            end)
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        applyAntiLagDerender(obj)
    end

    pcall(function()
        workspace.Terrain.WaterWaveSize = 0
        workspace.Terrain.WaterWaveSpeed = 0
        workspace.Terrain.WaterReflectance = 0
        workspace.Terrain.WaterTransparency = 0
        workspace.Terrain.Decoration = false
    end)

    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if obj:GetAttribute("_AmbitiousHubSky") then return end
        if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then return end
        if removeAccessoriesEnabled then applyAntiLagDerender(obj) end
    end)

    -- Ferma le animazioni non-player per ridurre il lag
    SetNoAnimations(true)
end

function disableAntiLag()
    antiLagVisualEnabled = false
    removeAccessoriesEnabled = false
    if antiLagDescConn then
        antiLagDescConn:Disconnect()
        antiLagDescConn = nil
    end
    if skyTheme == "Off" then
        pcall(function()
            if _G._AmbitiousDefLightBrightness then Lighting.Brightness = _G._AmbitiousDefLightBrightness end
            if _G._AmbitiousDefLightClock then Lighting.ClockTime = _G._AmbitiousDefLightClock end
            if _G._AmbitiousDefLightAmbient then Lighting.OutdoorAmbient = _G._AmbitiousDefLightAmbient end
            Lighting.ExposureCompensation = 0
            Lighting.GlobalShadows = true
        end)
    end

end

  -- RIMOSSO NUKE OPTIMISER

  -- ===== X-RAY =====
_G._AmbitiousXRayFolders = {
    "Base", "PlotSign", "FriendPanel", "Cash", "Laser",
    "Decorations", "Skin", "Unlock", "Purchases"
}
_G._AmbitiousXRayOrigTrans = {}  -- tabella forte: il GC non raccoglie le chiavi durante il restore
_G._AmbitiousXRayConns = {}
_G._AmbitiousXRayLoopId = 0

do
local function setXRayTargetTransparency(instance, alphaPercent, loopId)
    if not instance then return end
    if loopId and loopId ~= _G._AmbitiousXRayLoopId then return end
    local function apply(obj)
        if obj:IsA("BasePart") then
            if _G._AmbitiousXRayOrigTrans[obj] == nil then
                _G._AmbitiousXRayOrigTrans[obj] = obj.Transparency
            end
            local orig = _G._AmbitiousXRayOrigTrans[obj]
            if orig < 1 then
                local target = orig + (1 - orig) * alphaPercent
                if math.abs(obj.Transparency - target) > 0.01 then
                    obj.Transparency = target
                end
            end
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if _G._AmbitiousXRayOrigTrans[obj] == nil then
                _G._AmbitiousXRayOrigTrans[obj] = { text = obj.TextTransparency, bg = obj.BackgroundTransparency }
            end
            local orig = _G._AmbitiousXRayOrigTrans[obj]
            if orig.text < 1 then
                local target = orig.text + (1 - orig.text) * alphaPercent
                if math.abs(obj.TextTransparency - target) > 0.01 then obj.TextTransparency = target end
            end
            if orig.bg < 1 then
                local target = orig.bg + (1 - orig.bg) * alphaPercent
                if math.abs(obj.BackgroundTransparency - target) > 0.01 then obj.BackgroundTransparency = target end
            end
        elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
            if _G._AmbitiousXRayOrigTrans[obj] == nil then
                _G._AmbitiousXRayOrigTrans[obj] = obj.BackgroundTransparency
            end
            local orig = _G._AmbitiousXRayOrigTrans[obj]
            if orig < 1 then
                local target = orig + (1 - orig) * alphaPercent
                if math.abs(obj.BackgroundTransparency - target) > 0.01 then obj.BackgroundTransparency = target end
            end
        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            if _G._AmbitiousXRayOrigTrans[obj] == nil then
                _G._AmbitiousXRayOrigTrans[obj] = { img = obj.ImageTransparency, bg = obj.BackgroundTransparency }
            end
            local orig = _G._AmbitiousXRayOrigTrans[obj]
            if orig.img < 1 then
                local target = orig.img + (1 - orig.img) * alphaPercent
                if math.abs(obj.ImageTransparency - target) > 0.01 then obj.ImageTransparency = target end
            end
            if orig.bg < 1 then
                local target = orig.bg + (1 - orig.bg) * alphaPercent
                if math.abs(obj.BackgroundTransparency - target) > 0.01 then obj.BackgroundTransparency = target end
            end
        end
    end
    apply(instance)
    local descendants = instance:GetDescendants()
    for i, child in ipairs(descendants) do
        apply(child)
        if i % 300 == 0 then
            task.wait()
            if loopId and loopId ~= _G._AmbitiousXRayLoopId then return end
        end
    end
end

local function trackXRaySubtree(root, alphaPercent, loopId)
    if not root then return end
    if loopId ~= _G._AmbitiousXRayLoopId then return end
    setXRayTargetTransparency(root, alphaPercent, loopId)
    if loopId ~= _G._AmbitiousXRayLoopId then return end
    table.insert(_G._AmbitiousXRayConns, root.DescendantAdded:Connect(function(obj)
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        setXRayTargetTransparency(obj, alphaPercent, loopId)
    end))
end

local function processPlotXRay(plot, alphaPercent, loopId)
    if not plot then return end
    if loopId ~= _G._AmbitiousXRayLoopId then return end
    for _, fname in ipairs(_G._AmbitiousXRayFolders) do
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        trackXRaySubtree(plot:FindFirstChild(fname), alphaPercent, loopId)
    end
    if loopId ~= _G._AmbitiousXRayLoopId then return end
    table.insert(_G._AmbitiousXRayConns, plot.ChildAdded:Connect(function(child)
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        for _, fname in ipairs(_G._AmbitiousXRayFolders) do
            if child.Name == fname then
                trackXRaySubtree(child, alphaPercent, loopId)
                break
            end
        end
    end))
    local animalPodiums = plot:FindFirstChild("AnimalPodiums")
    if animalPodiums then
        local function processPodium(podium)
            for _, child in ipairs(podium:GetChildren()) do
                if child.Name == "Claim" then
                    trackXRaySubtree(child, alphaPercent, loopId)
                elseif child.Name == "Base" then
                    trackXRaySubtree(child:FindFirstChild("Decorations"), alphaPercent, loopId)
                elseif child:IsA("Model") and child.Name ~= "Decorations" then
                    trackXRaySubtree(child, alphaPercent, loopId)
                end
            end
        end
        for _, podium in ipairs(animalPodiums:GetChildren()) do
            processPodium(podium)
        end
        table.insert(_G._AmbitiousXRayConns, animalPodiums.ChildAdded:Connect(function(podium)
            if loopId ~= _G._AmbitiousXRayLoopId then return end
            task.wait(0.1)
            if loopId ~= _G._AmbitiousXRayLoopId then return end
            processPodium(podium)
        end))
    end
end

local function applyTransparencyToAllPlotsXRay(alphaPercent, loopId)
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then return end
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        processPlotXRay(plot, alphaPercent, loopId)
        task.wait()
    end
    table.insert(_G._AmbitiousXRayConns, plotsFolder.ChildAdded:Connect(function(plot)
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        task.wait(0.2)
        processPlotXRay(plot, alphaPercent, loopId)
    end))
end

function setXRay(enabled)
    for _, conn in ipairs(_G._AmbitiousXRayConns) do
        if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    _G._AmbitiousXRayConns = {}
    _G._AmbitiousXRayLoopId = _G._AmbitiousXRayLoopId + 1
    local currentLoopId = _G._AmbitiousXRayLoopId
    if enabled then
        local alphaPercent = 0.5
        task.spawn(function()
            while currentLoopId == _G._AmbitiousXRayLoopId and not workspace:FindFirstChild("Plots") do
                task.wait(0.5)
            end
            if currentLoopId ~= _G._AmbitiousXRayLoopId then return end
            pcall(applyTransparencyToAllPlotsXRay, alphaPercent, currentLoopId)
        end)
    else
        local snapshot = _G._AmbitiousXRayOrigTrans
        _G._AmbitiousXRayOrigTrans = {}  -- tabella forte: il GC non raccoglie le chiavi durante il restore
        for obj, orig in pairs(snapshot) do
            pcall(function()
                if obj:IsA("BasePart") then
                    obj.Transparency = orig
                elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    obj.TextTransparency = orig.text
                    obj.BackgroundTransparency = orig.bg
                elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                    obj.BackgroundTransparency = orig
                elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                    obj.ImageTransparency = orig.img
                    obj.BackgroundTransparency = orig.bg
                end
            end)
        end
    end
end
end -- X-RAY do block

-- >>> BRAINROT X-RAY BEGIN
-- Rende trasparenti i brainrot (i Model il cui nome sta in Datas.Animals).
--
-- NOTA SUI LOCAL: il main chunk e' a ridosso del limite di 200 local, quindi
-- qui NON se ne dichiara nemmeno uno: stato e funzioni stanno tutti dentro
-- la tabella _G._AmbitiousBrainrotXRay. I local dentro le funzioni non
-- contano, vivono nello scope della funzione.
--
-- Logica a eventi, come il No Animations dell'Anti Lag:
--  * UNA sola scansione del Workspace, all'accensione, spezzata in blocchi
--    per non far scattare il frame. Da li' in poi non si riscansiona piu'.
--  * Il DescendantAdded lavora solo sull'istanza arrivata: se e' un Model
--    animale applica a quello, se e' una parte risale al massimo 3 livelli.
--  * Spegnendolo, ogni istanza toccata torna alla trasparenza ORIGINALE,
--    con lo stesso snapshot che usa l'X-Ray normale.
_G._AmbitiousBrainrotXRay = {
  enabled = false,
  trans   = 0.5,
  names   = nil,
  -- [istanza] = trasparenza originale.
  -- TABELLA FORTE, NON weak: con __mode="k" il GC puo' buttare via la voce
  -- anche se la parte e' ancora viva nel mondo (Lua non ha piu' un
  -- riferimento suo, ma l'istanza esiste lo stesso nel DataModel). Era per
  -- quello che alcuni brainrot restavano trasparenti allo spegnimento.
  -- Non cresce all'infinito: viene svuotata ad ogni spegnimento.
  saved   = {},
  conns   = {},
  scanId  = 0,
}

_G._AmbitiousBrainrotXRay.loadNames = function()
  local BRX = _G._AmbitiousBrainrotXRay
  if BRX.names then return BRX.names end
  local t = {}
  pcall(function()
    local datas = ReplicatedStorage:FindFirstChild("Datas")
    local m = datas and datas:FindFirstChild("Animals")
    if m and m:IsA("ModuleScript") then
      for k in pairs(require(m)) do t[k] = true end
    end
  end)
  BRX.names = t
  return t
end

_G._AmbitiousBrainrotXRay.isHitbox = function(o)
  local n = string.lower(o.Name)
  return (string.find(n, "hit") or string.find(n, "target") or string.find(n, "box")
       or string.find(n, "root") or string.find(n, "collect") or string.find(n, "prompt")) ~= nil
end

-- Applica a UNA istanza, salvando il valore originale la prima volta.
_G._AmbitiousBrainrotXRay.applyOne = function(o)
  local BRX = _G._AmbitiousBrainrotXRay
  if not (o:IsA("BasePart") or o:IsA("Decal") or o:IsA("Texture")) then return end
  local orig = BRX.saved[o]
  if orig == nil then
    orig = o.Transparency
    -- Le hitbox gia' semi-trasparenti vanno trattate come invisibili,
    -- altrimenti spegnendo tornerebbero visibili a meta'.
    if orig > 0.5 and orig < 0.99 and o:IsA("BasePart") and BRX.isHitbox(o) then
      orig = 1
    end
    BRX.saved[o] = orig
  end
  -- Si tocca solo cio' che era davvero visibile.
  if orig < 0.5 and o.Transparency ~= BRX.trans then
    o.Transparency = BRX.trans
  end
end

_G._AmbitiousBrainrotXRay.applyModel = function(m)
  local BRX = _G._AmbitiousBrainrotXRay
  for _, o in ipairs(m:GetDescendants()) do
    BRX.applyOne(o)
  end
end

_G._AmbitiousBrainrotXRay.isAnimal = function(m)
  local BRX = _G._AmbitiousBrainrotXRay
  return m:IsA("Model") and BRX.names and BRX.names[m.Name] == true
end

-- Gate O(1): si risale di pochi livelli, non si cerca nulla.
_G._AmbitiousBrainrotXRay.animalAncestor = function(inst)
  local BRX = _G._AmbitiousBrainrotXRay
  local p = inst.Parent
  -- 5 livelli invece di 3: mesh e accessori possono stare piu' in fondo,
  -- e se non li si riconosce restano opachi (e poi non si ripristinano).
  for _ = 1, 5 do
    if not p or p == workspace then return nil end
    if p:IsA("Model") and BRX.names and BRX.names[p.Name] then return p end
    p = p.Parent
  end
  return nil
end

_G._AmbitiousBrainrotXRay.restoreAll = function()
  local BRX = _G._AmbitiousBrainrotXRay
  -- Si stacca lo snapshot e si riparte da zero, cosi' la tabella non
  -- accumula istanze morte da una sessione all'altra.
  local snapshot = BRX.saved
  BRX.saved = {}
  for o, orig in pairs(snapshot) do
    pcall(function()
      if o and o.Parent then o.Transparency = orig end
    end)
  end
end

function _G.AmbitiousSetBrainrotXRay(on)
  local BRX = _G._AmbitiousBrainrotXRay
  on = on and true or false
  BRX.enabled = on
  _G.AmbitiousBrainrotXRayEnabled = on

  for _, c in ipairs(BRX.conns) do
    pcall(function() c:Disconnect() end)
  end
  BRX.conns = {}
  BRX.scanId = BRX.scanId + 1

  if not on then
    BRX.restoreAll()
    return
  end

  BRX.loadNames()

  -- Scansione iniziale, a blocchi di 500 istanze
  local myScan = BRX.scanId
  task.spawn(function()
    local n = 0
    for _, d in ipairs(workspace:GetDescendants()) do
      if BRX.scanId ~= myScan then return end
      if BRX.isAnimal(d) then BRX.applyModel(d) end
      n = n + 1
      if n % 500 == 0 then task.wait() end
    end
  end)

  -- Da qui in poi: solo l'istanza che arriva, niente rescan.
  table.insert(BRX.conns, workspace.DescendantAdded:Connect(function(inst)
    if not BRX.enabled then return end
    if inst:IsA("Model") then
      if BRX.names and BRX.names[inst.Name] then
        -- il model arriva vuoto: si aspetta un frame che si popoli
        task.defer(function()
          if BRX.enabled and inst.Parent then BRX.applyModel(inst) end
        end)
      end
      return
    end
    if inst:IsA("BasePart") or inst:IsA("Decal") or inst:IsA("Texture") then
      if BRX.animalAncestor(inst) then BRX.applyOne(inst) end
    end
  end))
end
-- <<< BRAINROT X-RAY END

  -- ===== VIVID GRAPHICS =====
function enableVividGraphics()
    vividGraphicsEnabled = true
    -- Pulisci eventuali effetti precedenti
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_AmbitiousVivid") then child:Destroy() end
    end
    -- COLOR CORRECTION
    local color = Instance.new("ColorCorrectionEffect")
    color:SetAttribute("_AmbitiousVivid", true)
    color.Parent = Lighting
    color.Saturation = _G._AmbitiousVivid.saturation
    color.Contrast = 0.4
    color.Brightness = 0.05
    color.TintColor = Color3.fromRGB(255, 220, 70)
    -- BLOOM
    local bloom = Instance.new("BloomEffect")
    bloom:SetAttribute("_AmbitiousVivid", true)
    bloom.Parent = Lighting
    bloom.Intensity = _G._AmbitiousVivid.bloomIntensity
    bloom.Size = _G._AmbitiousVivid.bloomSize
    bloom.Threshold = 1
    -- ATMOSPHERE
    local atmosphere = Instance.new("Atmosphere")
    atmosphere:SetAttribute("_AmbitiousVivid", true)
    atmosphere.Parent = Lighting
    atmosphere.Density = 0.3
    atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(255, 220, 70)
    atmosphere.Decay = Color3.fromRGB(255, 220, 70)
    atmosphere.Glare = 0.2
    atmosphere.Haze = 1
    -- SUN RAYS
    local sun = Instance.new("SunRaysEffect")
    sun:SetAttribute("_AmbitiousVivid", true)
    sun.Parent = Lighting
    sun.Intensity = _G._AmbitiousVivid.sunIntensity
    sun.Spread = 0.8
    -- DEPTH OF FIELD
    local dof = Instance.new("DepthOfFieldEffect")
    dof:SetAttribute("_AmbitiousVivid", true)
    dof.Parent = Lighting
    dof.FocusDistance = _G._AmbitiousVivid.dofFocus
    dof.InFocusRadius = 10
    dof.NearIntensity = 0.2
    dof.FarIntensity = 0.4
    -- CONTRAST PULSE
    if _vividContrastConn then pcall(function() task.cancel(_vividContrastConn) end) _vividContrastConn = nil end
    _vividContrastConn = task.spawn(function()
        while vividGraphicsEnabled do
            if color and color.Parent then
                color.Contrast = 0.35 + math.sin(tick()*2)*0.05
            end
            task.wait(0.03)
        end
    end)
end

function disableVividGraphics()
    vividGraphicsEnabled = false
    if _vividContrastConn then
        pcall(function() task.cancel(_vividContrastConn) end)
        _vividContrastConn = nil
    end
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_AmbitiousVivid") then
            pcall(function() child:Destroy() end)
        end
    end
end

end -- fine do-block VISUALS PAGE (temp: riaperto dopo KORBLOX)

-- ===== HEADLESS + KORBLOX =====
-- Le helper interne (costanti, clean, apply) stanno nel do-block:
-- liberano ~14 slot locals dal main chunk evitando il limite di 200.
do -- do-block HEADLESS (locals: HEADLESS_MESH_ID, _headlessCharConn + 5 funzioni = 7 slot)
    local HEADLESS_MESH_ID   = "rbxassetid://1095708"
    local _headlessCharConn  = nil

    -- â”€â”€ HEADLESS helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    local function _headlessCleanConnections()
        for _, conn in ipairs(headlessConnections) do
            pcall(function() conn:Disconnect() end)
        end
        headlessConnections = {}
    end

    local function _removeFace(head)
        local face = head:FindFirstChild("face")
        if face then face:Destroy() end
    end

    local function _applyHeadlessMesh(head)
        if not head then return end
        if head:FindFirstChild("HeadlessMesh") then return end
        head.Transparency = 1
        head.CanCollide = false
        _removeFace(head)
        local mesh = Instance.new("SpecialMesh")
        mesh.Name = "HeadlessMesh"
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID
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
    end

    local function _applyHeadlessToCharacter(character)
        if not character then return end
        _headlessCleanConnections()
        local head = character:FindFirstChild("Head")
        task.wait(0.1)
        if head and headlessEnabled then _applyHeadlessMesh(head) end
    end

    function enableHeadless()
        headlessEnabled = true
        if _headlessCharConn then pcall(function() _headlessCharConn:Disconnect() end) end
        local char = LP.Character
        if char then _applyHeadlessToCharacter(char) end
        _headlessCharConn = LP.CharacterAdded:Connect(function(char)
            _G._AmbitiousWaitCharReady(char, 10)
            if headlessEnabled then _applyHeadlessToCharacter(char) end
        end)
        if _SV.setHeadlessVisual then _SV.setHeadlessVisual(true) end
    end

    function disableHeadless()
        headlessEnabled = false
        _headlessCleanConnections()
        if _headlessCharConn then
            pcall(function() _headlessCharConn:Disconnect() end)
            _headlessCharConn = nil
        end
        -- Restore head visibility
        pcall(function()
            local char = LP.Character
            if not char then return end
            local head = char:FindFirstChild("Head")
            if not head then return end
            local m = head:FindFirstChild("HeadlessMesh")
            if m then m:Destroy() end
            head.Transparency = 0
            head.CanCollide = true
        end)
        if _SV.setHeadlessVisual then _SV.setHeadlessVisual(false) end
    end

end -- fine do-block HEADLESS

do -- do-block KORBLOX
    local KORBLOX_MESH_ID    = "rbxassetid://101851696"
    local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
    local DARK_GREY_COLOR    = Color3.fromRGB(64, 64, 64)
    local _korbloxCharConn   = nil

    -- â”€â”€ KORBLOX helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    local function _korbloxCleanConnections()
        for _, conn in ipairs(korbloxConnections) do
            pcall(function() conn:Disconnect() end)
        end
        korbloxConnections = {}
    end

    local function _applyKorbloxR6(character)
        local rightLeg = character:FindFirstChild("Right Leg")
        if not rightLeg then return end
        if rightLeg:FindFirstChild("KorbloxMesh") then return end
        for _, child in ipairs(rightLeg:GetChildren()) do
            if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then child:Destroy() end
        end
        rightLeg.Color = DARK_GREY_COLOR
        local colorConn = rightLeg:GetPropertyChangedSignal("Color"):Connect(function()
            if rightLeg.Color ~= DARK_GREY_COLOR then rightLeg.Color = DARK_GREY_COLOR end
        end)
        table.insert(korbloxConnections, colorConn)
        local korbloxMesh = Instance.new("SpecialMesh")
        korbloxMesh.Name = "KorbloxMesh"
        korbloxMesh.MeshType = Enum.MeshType.FileMesh
        korbloxMesh.MeshId = KORBLOX_MESH_ID
        korbloxMesh.TextureId = KORBLOX_TEXTURE_ID
        korbloxMesh.Scale = Vector3.new(1, 1, 1)
        korbloxMesh.Parent = rightLeg
    end

    local function _applyKorbloxR15(character)
        local rightUpperLeg = character:FindFirstChild("RightUpperLeg")
        if not rightUpperLeg then return end
        if character:FindFirstChild("KorbloxLeg") then return end
        rightUpperLeg.Transparency = 1
        local rightLowerLeg = character:FindFirstChild("RightLowerLeg")
        local rightFoot = character:FindFirstChild("RightFoot")
        if rightLowerLeg then rightLowerLeg.Transparency = 1 end
        if rightFoot then rightFoot.Transparency = 1 end
        local korbloxLeg = Instance.new("Part")
        korbloxLeg.Name = "KorbloxLeg"
        korbloxLeg.Size = Vector3.new(1, 2, 1)
        korbloxLeg.Anchored = false
        korbloxLeg.CanCollide = false
        korbloxLeg.Color = DARK_GREY_COLOR
        korbloxLeg.Parent = character
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = KORBLOX_MESH_ID
        mesh.TextureId = KORBLOX_TEXTURE_ID
        mesh.Scale = Vector3.new(1, 1, 1)
        mesh.Parent = korbloxLeg
        local weld = Instance.new("Weld")
        weld.Part0 = rightUpperLeg
        weld.Part1 = korbloxLeg
        weld.C0 = CFrame.new(0, -0.45, 0)
        weld.Parent = korbloxLeg
    end

    local function _applyKorbloxToCharacter(character)
        if not character then return end
        _korbloxCleanConnections()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        task.wait(0.1)
        if not korbloxEnabled then return end
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            _applyKorbloxR6(character)
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            _applyKorbloxR15(character)
        end
    end

    function enableKorblox()
        korbloxEnabled = true
        if _korbloxCharConn then pcall(function() _korbloxCharConn:Disconnect() end) end
        local char = LP.Character
        if char then _applyKorbloxToCharacter(char) end
        _korbloxCharConn = LP.CharacterAdded:Connect(function(char)
            _G._AmbitiousWaitCharReady(char, 10)
            if korbloxEnabled then _applyKorbloxToCharacter(char) end
        end)
        if _SV.setKorbloxVisual then _SV.setKorbloxVisual(true) end
    end

    function disableKorblox()
        korbloxEnabled = false
        _korbloxCleanConnections()
        if _korbloxCharConn then
            pcall(function() _korbloxCharConn:Disconnect() end)
            _korbloxCharConn = nil
        end
        -- Restore right leg
        pcall(function()
            local char = LP.Character
            if not char then return end
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                local m = rightLeg:FindFirstChild("KorbloxMesh")
                if m then m:Destroy() end
            end
            local korbloxLeg = char:FindFirstChild("KorbloxLeg")
            if korbloxLeg then korbloxLeg:Destroy() end
            local rul = char:FindFirstChild("RightUpperLeg")
            local rll = char:FindFirstChild("RightLowerLeg")
            local rf  = char:FindFirstChild("RightFoot")
            if rul then rul.Transparency = 0 end
            if rll then rll.Transparency = 0 end
            if rf  then rf.Transparency  = 0 end
        end)
        if _SV.setKorbloxVisual then _SV.setKorbloxVisual(false) end
    end
end -- fine do-block KORBLOX

do -- do-block VISUALS PAGE (continuazione dopo HEADLESS+KORBLOX)

  -- delegated to outer enableNoCamCollision / disableNoCamCollision (smooth zoom override)

  function enableCustomFont()
    customFontVisualEnabled = false
    if V then V.customFontEnabled = false end
  end

  function disableCustomFont()
    customFontVisualEnabled = false
    if V then V.customFontEnabled = false end
  end
end

V = V or {}
V.skyTheme = skyTheme or V.skyTheme or "Off"
V.customFontEnabled = false
V.potatoGraphicsEnabled = V.potatoGraphicsEnabled or false

_G._AmbitiousNC = _G._AmbitiousNC or {targetZoom=10, currentZoom=10, zoomConn=nil, watchConns={}, resync=true}
loadstring(game:HttpGet("https://pastebin.com/raw/2H5JyQKE"))()
function enableNoCamCollision()
  noCamCollisionEnabled = true
  local NC = _G._AmbitiousNC
  local cam0 = workspace.CurrentCamera
  NC.targetZoom  = math.clamp(10, LP.CameraMinZoomDistance, LP.CameraMaxZoomDistance)
  NC.currentZoom = NC.targetZoom
  NC.resync = true   -- al primo frame utile si riallinea alla camera vera

  if NC.zoomConn then NC.zoomConn:Disconnect() end
  NC.zoomConn = UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if not noCamCollisionEnabled then return end
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseWheel then
      local curMin = LP.CameraMinZoomDistance
      local curMax = LP.CameraMaxZoomDistance
      NC.targetZoom = math.clamp(NC.targetZoom - (input.Position.Z * 4), curMin, curMax)
    end
  end)

  -- WATCHER: se il gioco cambia la camera da solo (limiti di zoom, prima
  -- persona forzata, cambio di camera al respawn) si chiede un riallineamento
  -- invece di continuare a imporre il nostro zoom.
  for _, c in ipairs(NC.watchConns or {}) do pcall(function() c:Disconnect() end) end
  NC.watchConns = {}
  local function askResync() NC.resync = true end
  table.insert(NC.watchConns, LP:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(askResync))
  table.insert(NC.watchConns, LP:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(askResync))
  table.insert(NC.watchConns, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(askResync))
  table.insert(NC.watchConns, LP.CharacterAdded:Connect(askResync))
  if cam0 then
    table.insert(NC.watchConns, cam0:GetPropertyChangedSignal("CameraType"):Connect(askResync))
    table.insert(NC.watchConns, cam0:GetPropertyChangedSignal("CameraSubject"):Connect(askResync))
  end

  pcall(function() RunService:UnbindFromRenderStep("AmbitiousNoCamCollision") end)
  RunService:BindToRenderStep("AmbitiousNoCamCollision", Enum.RenderPriority.Camera.Value + 1, function(deltaTime)
    if not noCamCollisionEnabled then return end

    -- la camera si rilegge ogni frame: dopo un respawn quella vecchia e' morta
    local cam = workspace.CurrentCamera
    if not cam then return end
    if cam.CameraType == Enum.CameraType.Scriptable then NC.resync = true return end
    if cam.CameraSubject == nil then NC.resync = true return end

    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then NC.resync = true return end

    local curMin = LP.CameraMinZoomDistance
    local curMax = LP.CameraMaxZoomDistance

    -- il gioco sta forzando la prima persona: non si scrive nulla, altrimenti
    -- si resta incastrati in prima persona anche dopo che la rilascia
    if curMax <= 1 then
      NC.resync = true
      return
    end

    local realZoom = (cam.CFrame.Position - cam.Focus.Position).Magnitude

    if realZoom < 0.6 then
      -- prima persona non decisa da noi: ci si adegua e si aspetta
      NC.resync = true
      return
    end

    -- Riallineamento: al primo frame buono dopo un cambio del gioco, oppure
    -- se la camera si e' allontanata piu' di quanto avessimo imposto noi
    -- (solo il gioco puo' farlo: la collisione avvicina, non allontana).
    if NC.resync or realZoom > NC.currentZoom + 0.5 then
      NC.targetZoom  = math.clamp(realZoom, curMin, curMax)
      NC.currentZoom = NC.targetZoom
      NC.resync = false
    end

    NC.targetZoom  = math.clamp(NC.targetZoom, curMin, curMax)
    NC.currentZoom = NC.currentZoom + (NC.targetZoom - NC.currentZoom) * math.min(deltaTime * 15, 1)
    cam.CFrame = cam.Focus * cam.CFrame.Rotation * CFrame.new(0, 0, NC.currentZoom)
  end)
end

function disableNoCamCollision()
  noCamCollisionEnabled = false
  pcall(function() RunService:UnbindFromRenderStep("AmbitiousNoCamCollision") end)
  if _G._AmbitiousNC.zoomConn then _G._AmbitiousNC.zoomConn:Disconnect(); _G._AmbitiousNC.zoomConn = nil end
  for _, c in ipairs(_G._AmbitiousNC.watchConns or {}) do pcall(function() c:Disconnect() end) end
  _G._AmbitiousNC.watchConns = {}
  noCamCollisionParts = {}
end

-- ==================== SKY CHANGER (PRESET + LOGICA ANTI-DESTROY da Uranium) ====================

SKY_PRESETS_LIST = {
  "Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night",
  "Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse",
  "Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky",
  "Clear Sky","Golden Hour","Moonlight","Cotton Candy","Monochrome","Rainbow",
  "Ultraviolet","Blue Hour","Nebula","Thunderhead","Fuchsia Dawn",
  "Ice Cavern","Crimson Dusk","Neon Rain","Copper Sky","Pearl Rose",
  "Red Giant","Moonfall",
  "Ashfall","Marshlight","Abyss",
  "Timelapse","Lightning","Pulsar","Ionosphere","Midnight Sun",
  "Polar Night","Infrared","Sepia","Chrome","Supernova",
  "Mars","Titan","Dreamcore","Ember Night","PH"
}

SKY_PRESET_COLORS = {
  ["Off"]            = {120,120,120},
  ["Night"]          = {120,60,180},
  ["Aurora"]         = {150,90,200},
  ["Sunset"]         = {255,140,60},
  ["Galaxy"]         = {40,20,90},
  ["Cyber"]          = {0,200,255},
  ["Sakura"]         = {255,180,205},
  ["Pink Night"]     = {255,80,180},
  ["Blood Moon"]     = {200,40,40},
  ["Emerald Dawn"]   = {80,200,140},
  ["Volcanic"]       = {220,90,30},
  ["Arctic"]         = {170,215,255},
  ["Midnight Ocean"] = {30,80,160},
  ["Vaporwave"]      = {255,100,220},
  ["Toxic"]          = {150,210,90},
  ["Solar Eclipse"]  = {255,150,40},
  ["Hellscape"]      = {210,50,20},
  ["Heaven"]         = {255,250,225},
  ["Storm"]          = {90,95,115},
  ["Sunrise"]        = {255,180,100},
  ["Deep Space"]     = {20,10,45},
  ["Lavender Dream"] = {190,160,255},
  ["Inferno"]        = {225,100,40},
  ["Mint Sky"]       = {165,250,215},
  ["Clear Sky"]      = {110,190,255},
  ["Golden Hour"]    = {255,190,110},
  ["Moonlight"]      = {170,190,225},
  ["Cotton Candy"]   = {255,180,225},
  ["Monochrome"]     = {152,152,152},
  ["Rainbow"]        = {255,90,120},
  ["Ultraviolet"]    = {150,40,240},
  ["Blue Hour"]      = {80,120,190},
  ["Nebula"]         = {190,70,205},
  ["Thunderhead"]    = {130,145,215},
  ["Fuchsia Dawn"]   = {255,45,160},
  ["Ice Cavern"]     = {150,215,240},
  ["Crimson Dusk"]   = {200,50,80},
  ["Neon Rain"]      = {0,230,210},
  ["Copper Sky"]     = {200,115,60},
  ["Pearl Rose"]     = {255,215,228},
  ["Red Giant"]      = {215,75,45},
  ["Moonfall"]       = {185,200,235},
  ["Ashfall"]        = {112,104,98},
  ["Marshlight"]     = {96,150,105},
  ["Abyss"]          = {15,70,80},
  ["Timelapse"]      = {255,160,90},
  ["Lightning"]      = {200,215,255},
  ["Pulsar"]         = {120,160,255},
  ["Ionosphere"]     = {90,235,175},
  ["Midnight Sun"]   = {255,205,120},
  ["Polar Night"]    = {60,80,130},
  ["Infrared"]       = {255,60,60},
  ["Sepia"]          = {190,150,100},
  ["Chrome"]         = {190,200,215},
  ["Supernova"]      = {255,245,220},
  ["Mars"]           = {215,150,105},
  ["Titan"]          = {200,140,60},
  ["Dreamcore"]      = {215,190,255},
  ["Ember Night"]    = {235,110,45},
  ["PH"]             = {242,140,40},
}

SKY_PRESETS = {
  ["Off"]            = {kind = "off"},
  ["Night"]          = {clock=22,  brightness=2,   ambient={110,100,130}, outAmb={120,110,140}, sky={stars=4000,  moon=18, sun=0,  moonTex=true}, atm={dens=0.45, color={120,60,180},   decay={60,20,100},   glare=0.5, haze=1.2}},
  ["Aurora"]         = {clock=14,  brightness=2.2, ambient={140,130,150}, outAmb={150,140,160},                                                    atm={dens=0.35, color={220,140,200},  decay={200,120,160}, glare=1.2, haze=1.6}, clouds={cover=0.5,  dens=0.5,  color={240,230,245}}},
  ["Sunset"]         = {clock=17.2,brightness=2.5, ambient={170,120,100}, outAmb={180,130,110}, sky={stars=0,    sun=25,  moon=0},                 atm={dens=0.5,  color={255,130,60},   decay={255,80,30},   glare=2,   haze=2.5}, clouds={cover=0.55, dens=0.55, color={255,200,140}}},
  ["Galaxy"]         = {clock=0,   brightness=1.5, ambient={70,60,100},   outAmb={80,70,110},   sky={stars=10000,moon=30, sun=0},                  atm={dens=0.15, color={40,20,80},     decay={20,10,50},    glare=0.3, haze=0.5}},
  ["Cyber"]          = {clock=21,  brightness=2.2, ambient={90,130,170},  outAmb={100,140,180}, sky={stars=2000, moon=12},                         atm={dens=0.4,  color={0,200,255},    decay={150,0,255},   glare=2,   haze=2},   clouds={cover=0.4,  dens=0.6,  color={100,200,255}}},
  ["Sakura"]         = {clock=11,  brightness=3.5, ambient={170,150,160}, outAmb={180,160,170}, sky={sun=8},                                       atm={dens=0.3,  color={255,200,220},  decay={255,170,200}, glare=1,   haze=1.5}, clouds={cover=0.6,  dens=0.4,  color={255,250,252}}},
  ["Pink Night"]     = {clock=23,  brightness=2.2, ambient={120,60,110},  outAmb={140,70,120},  sky={stars=5000, moon=22, sun=0,  moonTex=true},   atm={dens=0.5,  color={255,80,180},   decay={140,30,100},  glare=0.7, haze=1.4}, clouds={cover=0.3,  dens=0.5,  color={180,90,150}}},
  ["Blood Moon"]     = {clock=22.5,brightness=1.4, ambient={120,50,50},   outAmb={130,60,60},   sky={stars=1500, moon=28, sun=0,  moonTex=true},   atm={dens=0.5,  color={180,50,50},    decay={100,30,30},   glare=0.9, haze=1.5}, clouds={cover=0.4,  dens=0.55, color={110,40,40}}},
  ["Emerald Dawn"]   = {clock=6.5, brightness=2.8, ambient={130,170,140}, outAmb={140,180,150}, sky={sun=18,     moon=0,  stars=0},                atm={dens=0.4,  color={80,200,140},   decay={40,150,90},   glare=1.8, haze=2.2}, clouds={cover=0.5,  dens=0.5,  color={200,255,220}}},
  ["Volcanic"]       = {clock=19,  brightness=1.6, ambient={170,90,50},   outAmb={180,100,60},  sky={stars=200,  sun=12,  moon=0},                 atm={dens=0.55, color={200,80,30},    decay={150,50,20},   glare=1.5, haze=2.0}, clouds={cover=0.6,  dens=0.7,  color={120,50,30}}},
  ["Arctic"]         = {clock=9,   brightness=3.2, ambient={200,220,235}, outAmb={210,230,245}, sky={sun=10,     stars=0, moon=0},                 atm={dens=0.3,  color={180,220,255},  decay={140,200,240}, glare=1.5, haze=1.8}, clouds={cover=0.7,  dens=0.6,  color={250,253,255}}},
  ["Midnight Ocean"] = {clock=1.5, brightness=1.7, ambient={60,90,130},   outAmb={70,100,140},  sky={stars=6000, moon=24, sun=0,  moonTex=true},   atm={dens=0.5,  color={20,60,140},    decay={10,30,90},    glare=0.6, haze=1.5}},
  ["Vaporwave"]      = {clock=19.5,brightness=2.4, ambient={180,120,200}, outAmb={190,130,210}, sky={stars=1000, moon=14},                         atm={dens=0.45, color={255,100,220},  decay={120,60,255},  glare=2.2, haze=2.4}, clouds={cover=0.5,  dens=0.55, color={200,150,255}}},
  ["Toxic"]          = {clock=13,  brightness=2.2, ambient={145,170,110}, outAmb={155,180,120},                                                    atm={dens=0.4,  color={130,200,90},   decay={90,160,60},   glare=1.2, haze=1.8}, clouds={cover=0.55, dens=0.55, color={190,230,150}}},
  ["Solar Eclipse"]  = {clock=12,  brightness=0.9, ambient={50,40,60},    outAmb={60,50,70},    sky={stars=3500, sun=22,  moon=0},                 atm={dens=0.5,  color={255,140,40},   decay={30,20,40},    glare=2.8, haze=1.8}},
  ["Hellscape"]      = {clock=18,  brightness=1.4, ambient={170,70,40},   outAmb={180,80,50},   sky={stars=100,  sun=30,  moon=0},                 atm={dens=0.5,  color={200,50,20},    decay={110,30,10},   glare=1.8, haze=2.5}, clouds={cover=0.8,  dens=0.8,  color={90,30,20}}},
  ["Heaven"]         = {clock=12,  brightness=4,   ambient={240,235,210}, outAmb={250,245,220}, sky={sun=16,     moon=0,  stars=0},                atm={dens=0.25, color={255,250,220},  decay={255,240,200}, glare=3,   haze=1.5}, clouds={cover=0.85, dens=0.5,  color={255,255,255}}},
  ["Storm"]          = {clock=15,  brightness=1.4, ambient={90,90,110},   outAmb={100,100,120}, sky={stars=0,    sun=6,   moon=0},                 atm={dens=0.65, color={80,90,120},    decay={40,50,80},    glare=0.5, haze=3},   clouds={cover=0.95, dens=0.95, color={60,65,80}}},
  ["Sunrise"]        = {clock=6.2, brightness=2.8, ambient={220,180,130}, outAmb={230,190,140}, sky={sun=22,     stars=0, moon=0},                 atm={dens=0.45, color={255,180,100},  decay={255,140,80},  glare=2.4, haze=2.2}, clouds={cover=0.4,  dens=0.4,  color={255,220,180}}},
  ["Deep Space"]     = {clock=0,   brightness=1,   ambient={30,25,50},    outAmb={40,35,60},    sky={stars=15000,moon=0,  sun=0},                  atm={dens=0.08, color={15,5,40},      decay={5,0,20},      glare=0.2, haze=0.3}},
  ["Lavender Dream"] = {clock=18.5,brightness=2.6, ambient={180,160,220}, outAmb={190,170,230}, sky={stars=800,  moon=16, sun=0},                  atm={dens=0.4,  color={200,160,255},  decay={160,120,220}, glare=1.4, haze=1.8}, clouds={cover=0.55, dens=0.5,  color={220,200,255}}},
  ["Inferno"]        = {clock=17.5,brightness=1.8, ambient={200,100,50},  outAmb={210,110,60},  sky={sun=26,     moon=0,  stars=0},                atm={dens=0.5,  color={220,100,40},   decay={180,70,20},   glare=2.0, haze=2.4}, clouds={cover=0.6,  dens=0.6,  color={180,90,50}}},
  ["Mint Sky"]       = {clock=10,  brightness=3.2, ambient={180,230,210}, outAmb={190,240,220}, sky={sun=10},                                      atm={dens=0.32, color={150,255,210},  decay={100,220,180}, glare=1.6, haze=1.6}, clouds={cover=0.55, dens=0.45, color={240,255,250}}},
  ["Clear Sky"]      = {clock=13.5,brightness=3,   ambient={180,200,220}, outAmb={190,210,230}, sky={sun=12,     stars=0, moon=0},                 atm={dens=0.28, color={140,200,255},  decay={90,160,230},  glare=1.4, haze=1.4}, clouds={cover=0.25, dens=0.35, color={255,255,255}}},
  ["Golden Hour"]    = {clock=16.6,brightness=2.2, ambient={195,168,132}, outAmb={205,178,142}, sky={sun=15,     stars=0, moon=0},                 atm={dens=0.36, color={240,195,140},  decay={205,150,95},  glare=1.3, haze=1.6}, clouds={cover=0.4,  dens=0.4,  color={245,225,200}}},
  ["Moonlight"]      = {clock=23.5,brightness=1.8, ambient={140,150,175}, outAmb={150,160,185}, sky={stars=7000, moon=26, sun=0,  moonTex=true},   atm={dens=0.4,  color={170,190,225},  decay={60,75,110},   glare=0.8, haze=1.4}, clouds={cover=0.35, dens=0.45, color={150,165,195}}},
  ["Cotton Candy"]   = {clock=18,  brightness=3,   ambient={225,190,225}, outAmb={235,200,235}, sky={sun=10,     stars=0, moon=0},                 atm={dens=0.35, color={255,180,225},  decay={160,200,255}, glare=1.6, haze=1.8}, clouds={cover=0.6,  dens=0.45, color={255,230,245}}},
  -- Grigio piatto da vecchia TV in bianco e nero: nessuna tinta da nessuna
  -- parte (Color e Decay sono due grigi neutri), sole/luna/stelle spenti
  -- cosi' non entra colore, nuvole coperte e slavate, luce senza contrasto.
  ["Monochrome"]     = {clock=13,  brightness=1.9, ambient={148,148,148}, outAmb={158,158,158}, sky={sun=0,      stars=0, moon=0},                 atm={dens=0.5,  color={125,125,125},  decay={178,178,178}, glare=0,   haze=2.4}, clouds={cover=0.85, dens=0.75, color={142,142,142}}},
  -- Stesso cielo della versione dorato/rosa; rainbow=true fa scorrere la
  -- coppia di tinte lungo tutto lo spettro. Il passaggio e' calcolato sul
  -- tempo reale (non sui frame) e la coppia mantiene sempre lo stesso
  -- scarto di tinta, quindi resta l'effetto che ti piaceva, solo che i due
  -- colori si spostano insieme in modo continuo.
  ["Rainbow"]        = {clock=17.4,brightness=2.6, ambient={200,185,215}, outAmb={210,195,225}, sky={sun=18,     stars=0, moon=0},                 atm={dens=0.3,  color={130,70,255},   decay={255,120,50},  glare=1.8, haze=3},   clouds={cover=0.35, dens=0.4,  color={255,235,250}}, rainbow=true},

  -- ---------------------------------------------------------------
  -- Tema nuovi. Ognuno punta su una leva diversa invece di essere un
  -- semplice cambio di tinta: densita' e foschia estreme (Sandstorm,
  -- Amber Fog), glare altissimo su base scura (Thunderhead, Neon Rain),
  -- Color e Decay in contrasto netto invece che in gradazione
  -- (Nebula, Neon Rain), o tutto spento (Void).
  -- ---------------------------------------------------------------

  -- Viola di MEZZOGIORNO, non di notte. La tinta viene solo da Atmosphere e
  -- la sua forza dipende da Density: troppo bassa e resta il blu di Roblox,
  -- troppo alta e il viola ti mangia tutta la scena, compreso il terreno.
  -- Il valore giusto sta in mezzo e va trovato per tentativi: a 0.6 il viola
  -- tingeva anche terreno e GUI, a 0.38 non bastava a coprire il cielo
  -- azzurro di default di Roblox e tornava tutto blu. Dens 0.5 con haze 2.3
  -- copre il cielo lasciando leggibile il mondo sotto. Le tinte restano
  -- quelle morbide, non quelle sature della versione che accecava.
  ["Ultraviolet"]    = {clock=12,  brightness=2.2, ambient={150,130,195}, outAmb={160,140,205}, sky={sun=10,     stars=0, moon=0},                 atm={dens=0.5,  color={115,35,205},   decay={170,120,235}, glare=1.4, haze=2.3}, clouds={cover=0.35, dens=0.45, color={205,170,250}}},

  -- L'ora blu vera: il sole e' gia' sotto l'orizzonte, niente luna,
  -- poche stelle. Cielo profondo sopra e chiarore freddo sul fondo.
  ["Blue Hour"]      = {clock=19.6,brightness=1.9, ambient={95,115,150},  outAmb={105,125,160}, sky={stars=600,  sun=0,   moon=0},                 atm={dens=0.45, color={70,110,175},   decay={150,170,205}, glare=0.8, haze=1.8}, clouds={cover=0.3,  dens=0.4,  color={120,140,175}}},

  -- Nebulosa: magenta sopra e ciano sul fondo, due tinte opposte invece
  -- della solita sfumatura. Le nuvole tinte di viola fanno da banda.
  ["Nebula"]         = {clock=0.5, brightness=1.6, ambient={95,70,120},   outAmb={105,80,130},  sky={stars=12000,moon=10, sun=0},                  atm={dens=0.3,  color={190,60,200},   decay={40,170,190},  glare=1.6, haze=1.2}, clouds={cover=0.45, dens=0.65, color={150,70,200}}},

  -- Fronte temporalesco illuminato da dentro: nuvolone quasi nero ma
  -- glare a 3, come il lampo che sta per arrivare. Diverso da Storm,
  -- che e' grigio piatto e spento.
  ["Thunderhead"]    = {clock=16,  brightness=1.5, ambient={105,110,140}, outAmb={115,120,150}, sky={sun=5,      stars=0, moon=0},                 atm={dens=0.7,  color={150,165,255},  decay={45,50,75},    glare=3,   haze=2.8}, clouds={cover=0.95, dens=0.9,  color={70,75,100}}},

  -- Alba fucsia. Color e Decay restano tutti e due nel magenta (con il
  -- Decay oro che avevo provato prima veniva fuori un tramonto dorato,
  -- perche' all'alba l'orizzonte e' la parte di cielo che guardi), ma la
  -- densita' a 0.5: a 0.65 il fucsia colorava anche terreno e GUI, a 0.4
  -- non copriva l'azzurro di default e il cielo tornava blu. Nuvole rosa
  -- chiare invece che fucsia piene, cosi' il cielo respira.
  ["Fuchsia Dawn"]   = {clock=6.4, brightness=2.2, ambient={212,145,175}, outAmb={222,155,185}, sky={sun=12,     stars=0, moon=0},                 atm={dens=0.5,  color={240,55,155},   decay={215,110,160}, glare=1.3, haze=2.3}, clouds={cover=0.45, dens=0.5,  color={255,175,205}}},

  -- Alba polare dentro il ghiaccio: azzurro freddo, luce bassa, luna
  -- piccola. Arctic e' pieno giorno, questo e' l'opposto.
  ["Ice Cavern"]     = {clock=5,   brightness=1.5, ambient={130,175,200}, outAmb={140,185,210}, sky={stars=1200, moon=8,  sun=0},                  atm={dens=0.55, color={110,200,230},  decay={200,235,250}, glare=0.9, haze=2.6}, clouds={cover=0.6,  dens=0.6,  color={190,225,240}}},

  -- Tramonto rosso cupo che vira al viola verso il basso. Niente luna:
  -- non c'entra con Blood Moon, e' solo il cielo.
  ["Crimson Dusk"]   = {clock=18.8,brightness=1.9, ambient={165,80,90},   outAmb={175,90,100},  sky={sun=9,      stars=300, moon=0},               atm={dens=0.55, color={190,40,70},    decay={90,25,80},    glare=1.6, haze=2.2}, clouds={cover=0.55, dens=0.6,  color={150,55,75}}},

  -- Notte di pioggia al neon: base grigio-blu spenta, ciano sopra e
  -- magenta sul fondo, nuvole compatte. Cyber e' sereno, questo e' chiuso.
  ["Neon Rain"]      = {clock=21.5,brightness=1.6, ambient={80,95,125},   outAmb={90,105,135},  sky={stars=300,  moon=0,  sun=0},                  atm={dens=0.6,  color={0,230,210},    decay={225,40,175},  glare=2.6, haze=2.8}, clouds={cover=0.9,  dens=0.85, color={55,65,90}}},

  -- Cielo di rame: arancio metallico e terroso, aria sporca. Golden Hour
  -- e' morbido e dorato, questo e' duro e industriale.
  ["Copper Sky"]     = {clock=15.5,brightness=2,   ambient={185,120,75},  outAmb={195,130,85},  sky={sun=13,     stars=0, moon=0},                 atm={dens=0.5,  color={200,110,55},   decay={150,80,45},   glare=1.5, haze=2.6}, clouds={cover=0.65, dens=0.6,  color={190,140,100}}},

  -- Rosa chiaro perlato: niente disco solare (sun=0), la luce arriva solo
  -- diffusa da una copertura di nuvole al 90%. Il risultato e' una velatura
  -- uniforme, quasi senza ombre. Sakura e Cotton Candy hanno il sole e
  -- cielo aperto, quindi restano cieli rosa "normali": questo e' luce.
  ["Pearl Rose"]     = {clock=9.5, brightness=3.4, ambient={240,220,228}, outAmb={248,228,236}, sky={sun=0,      stars=0, moon=0},                 atm={dens=0.38, color={255,205,220},  decay={250,240,242}, glare=0.9, haze=2},   clouds={cover=0.9,  dens=0.55, color={255,245,250}}},

  -- Questi due giocano sulla dimensione angolare di sole e luna, una leva
  -- che nessun altro preset tocca: tutti gli altri stanno sotto 30, qui si
  -- va a 75. Il tema non lo fa il colore ma l'OGGETTO enorme in cielo.

  -- Stella morente: un sole gigantesco e basso, cielo cupo e stelle gia'
  -- visibili nonostante sia giorno. Inferno e Hellscape sono rossi, ma il
  -- loro sole e' normale: li' brucia l'atmosfera, qui e' il disco stesso.
  ["Red Giant"]      = {clock=17.6,brightness=1.5, ambient={150,75,60},   outAmb={160,85,70},   sky={sun=75,     stars=400, moon=0},               atm={dens=0.55, color={150,40,30},    decay={235,120,70},  glare=2.2, haze=2.6}, clouds={cover=0.35, dens=0.5,  color={150,75,55}}},

  -- Luna enorme addosso al pianeta: notte fonda, cielo d'acciaio, niente
  -- tinte calde. Moonlight ha la stessa ora ma la luna normale, ed e' un
  -- cielo tranquillo; questo vuole sembrare l'impatto in arrivo.
  ["Moonfall"]       = {clock=1,   brightness=1.5, ambient={125,140,175}, outAmb={135,150,185}, sky={stars=9000, moon=75, sun=0,  moonTex=true},   atm={dens=0.45, color={90,115,165},   decay={185,200,230}, glare=1.1, haze=1.8}, clouds={cover=0.3,  dens=0.45, color={150,165,200}}},

  -- ===============================================================
  -- VENTI TEMI NUOVI.
  -- Qui non si cambia la tinta e si cambia nome: ognuno tira una leva
  -- che nessuno degli altri tocca. Cinque famiglie:
  --   NEBBIA VERA  - Ashfall, Marshlight, Abyss, Titan: niente
  --                  Atmosphere, la visibilita' viene tagliata di netto a
  --                  una distanza precisa. E' l'unico modo di avere un
  --                  muro davanti agli occhi invece di una sfumatura.
  --   CIELI VIVI   - Timelapse, Lightning, Pulsar, Ionosphere: cambiano da
  --                  soli mentre giochi, non sono un'immagine ferma.
  --   FALSO COLORE - Infrared, Sepia, Dreamcore, Ember Night: luci e
  --                  ombre tinte separatamente, cosa che nessun preset
  --                  faceva; il colore non viene dal cielo ma da come la
  --                  luce colpisce le cose.
  --   ASTRONOMIA   - Midnight Sun, Polar Night, Supernova: si sposta il
  --                  PERCORSO del sole (latitudine) o la sua scala, non
  --                  il colore dell'aria.
  --   ALTRI MONDI  - Mars, Titan, Chrome: densita', esposizione e luce
  --                  d'ambiente portate agli estremi.
  -- ===============================================================

  -- Pioggia di cenere: nebbia grigio-calda corta, sole quasi spento,
  -- ombre tolte perche' sotto una coltre di cenere non ce ne sono.
  -- Storm e' un grigio che resta lontano, questa e' aria sporca addosso.
  ["Ashfall"]        = {clock=15,  brightness=1.2, ambient={92,86,80},    outAmb={104,98,92},   sky={sun=4,      stars=0, moon=0},   noAtm=true, shadows=false, exposure=-0.35,
                        fog={10, 260, {104, 97, 90}}, clouds={cover=0.9,  dens=0.85, color={86,80,74}}},

  -- Palude all'alba: verde malato che non viene dal cielo ma dall'aria
  -- ferma tra gli alberi. Toxic e' verde acceso e aperto, questo e' chiuso
  -- e basso.
  ["Marshlight"]     = {clock=6.8, brightness=1.6, ambient={104,132,104}, outAmb={116,144,116}, sky={sun=8,      stars=0, moon=0},   noAtm=true, envD=0.8,
                        fog={15, 200, {88, 140, 98}},  clouds={cover=0.75, dens=0.7,  color={120,150,125}}},

  -- Sott'acqua: acqua torbida che si chiude a 90 studs, luce che arriva
  -- smorzata dall'alto e nessun riflesso speculare, come sotto la
  -- superficie. Midnight Ocean e' il mare visto da fuori, questo e' da
  -- dentro.
  ["Abyss"]          = {clock=12,  brightness=1.4, ambient={30,80,92},    outAmb={36,92,104},   sky={sun=3,      stars=0, moon=0},   noAtm=true, shadows=false, exposure=-0.4, envD=0.5, envS=0.2,
                        fog={0, 90, {12, 62, 74}}},

  -- Il giorno scorre davvero: quasi due ore di gioco al secondo, quindi
  -- un ciclo completo in poco meno di tredici secondi. Alba,
  -- mezzogiorno, tramonto e notte si susseguono mentre giochi. E' l'unico
  -- preset in cui l'ora non e' un numero fisso.
  ["Timelapse"]      = {clock=5,   brightness=2.4, ambient={170,160,165}, outAmb={180,170,175}, sky={sun=16,     stars=2500, moon=14, moonTex=true}, drift=1.875,
                        atm={dens=0.35, color={190,150,190},  decay={210,140,110}, glare=1.6, haze=1.8}, clouds={cover=0.45, dens=0.5,  color={235,225,235}}},

  -- Temporale con i lampi veri: base cupa e colpi di luce a intervalli
  -- IRREGOLARI, a due o tre alla volta. Regolari sembrerebbero un difetto
  -- della GUI; il tremolio no. Thunderhead ha il glare del lampo ma sta
  -- fermo, qui il lampo c'e'.
  --
  -- LA MACCHIA BIANCA IN CIELO. Non era il disco del sole: quello era gia'
  -- spento. Era il GLARE dell'Atmosphere, che disegna un alone nella
  -- direzione del sole indipendentemente da quanto e' grande il disco â€” a
  -- 1.1 con la foschia a 2.8 diventava una chiazza enorme. Qui va a zero,
  -- e l'ora passa alle 19.2 con il sole appena sotto l'orizzonte: cosi'
  -- una direzione del sole in cielo non c'e' proprio, e non c'e' piu'
  -- niente che possa accendersi.
  ["Lightning"]      = {clock=19.2,brightness=1.6, ambient={95,100,125},  outAmb={105,110,135}, sky={sun=0,      stars=0, moon=0},
                        flash={peak=3.4, gapMin=2.2, gapMax=6.5, bursts=3},
                        atm={dens=0.68, color={160,175,255},  decay={40,44,66},    glare=0,   haze=2.8}, clouds={cover=0.95, dens=0.92, color={62,66,88}}},

  -- Pulsar: la luce respira, su e giu' con un ciclo di quattro secondi,
  -- come il faro di una stella di neutroni che gira. Nessun colore si
  -- muove, solo l'intensita': e' quello a renderlo inquietante.
  ["Pulsar"]         = {clock=0,   brightness=1.8, ambient={70,90,150},   outAmb={80,100,160},  sky={stars=11000,moon=0,  sun=0},
                        pulse={min=0.6, max=4.2, period=4},
                        atm={dens=0.25, color={60,100,235},   decay={200,220,255}, glare=2,   haze=1}},

  -- Ionosfera: notte verde, ferma. Verde in alto e verde scuro sul fondo,
  -- senza una goccia di blu da nessuna parte â€” la parte bassa del cielo e'
  -- quella che si guarda di piu', e bastava un decay tendente all'azzurro
  -- perche' tutto il tema virasse li'. L'Aurora esistente e' rosa e
  -- dipinta sulle nuvole; qui non ci sono nuvole ed e' l'aria a essere
  -- verde, sopra ottomila stelle.
  ["Ionosphere"]     = {clock=1.2, brightness=1.7, ambient={100,155,110}, outAmb={110,165,120}, sky={stars=8000, moon=8,  sun=0},
                        atm={dens=0.42, color={60,235,140},   decay={18,85,45},    glare=1.8, haze=1.5}},

  -- Sole di mezzanotte. La latitudine spostata a 89 gradi cambia il
  -- PERCORSO del sole, non la sua tinta: invece di salire in alto striscia
  -- lungo l'orizzonte senza tramontare mai. Luce dorata che arriva sempre
  -- di taglio, ombre lunghissime. Nessun altro preset tocca questa leva.
  ["Midnight Sun"]   = {clock=0,   brightness=2.6, ambient={215,185,140}, outAmb={225,195,150}, sky={sun=20,     stars=0, moon=0},   lat=89,
                        atm={dens=0.42, color={255,190,110},  decay={235,150,90},  glare=2.2, haze=2.2}, clouds={cover=0.4,  dens=0.45, color={255,225,190}}},

  -- L'opposto esatto: latitudine negativa estrema e il sole a mezzogiorno
  -- non sorge proprio. E' giorno sull'orologio ma la luce e' quella blu e
  -- piatta del crepuscolo polare, per mesi.
  ["Polar Night"]    = {clock=12,  brightness=1.3, ambient={62,80,120},   outAmb={72,90,130},   sky={stars=2200, sun=10,  moon=6},   lat=-88, exposure=-0.25,
                        atm={dens=0.5,  color={45,70,130},    decay={120,150,200}, glare=0.6, haze=2.2}, clouds={cover=0.55, dens=0.5,  color={80,100,140}}},

  -- Falso colore termico: le luci virate al rosso e le ombre al blu
  -- profondo, separatamente. Il colore non viene dal cielo ma da come la
  -- luce colpisce le cose â€” il terreno esposto scotta, quello in ombra e'
  -- gelido. Nessun preset rosso fa questo: quelli tingono l'aria.
  ["Infrared"]       = {clock=13,  brightness=2.2, ambient={120,60,70},   outAmb={130,70,80},   sky={sun=10,     stars=0, moon=0},
                        shiftTop={120, 0, 0}, shiftBot={0, 20, 90}, envS=0.3,
                        atm={dens=0.3,  color={90,20,40},     decay={200,60,60},   glare=1.4, haze=1.4}},

  -- Viraggio seppia da stampa vecchia: luci ambrate, ombre brune, poca
  -- luce d'ambiente. Il Monochrome toglie il colore, questo lo sostituisce
  -- con uno solo â€” e sono due cose diverse.
  ["Sepia"]          = {clock=14,  brightness=2,   ambient={160,140,110}, outAmb={170,150,120}, sky={sun=9,      stars=0, moon=0},
                        shiftTop={90, 55, 10}, shiftBot={35, 20, 5}, envD=0.45, envS=0.1,
                        atm={dens=0.45, color={185,150,100},  decay={150,115,70},  glare=1,   haze=2.4}, clouds={cover=0.5,  dens=0.5,  color={205,185,150}}},

  -- Cromato: luce d'ambiente diffusa quasi azzerata e speculare al
  -- massimo, cosi' ogni superficie si comporta come metallo lucido invece
  -- che come materia opaca. Il cielo e' solo acciaio di contorno: qui il
  -- tema sono gli OGGETTI, non l'aria.
  ["Chrome"]         = {clock=12,  brightness=2.8, ambient={150,160,175}, outAmb={160,170,185}, sky={sun=14,     stars=0, moon=0},
                        envD=0.15, envS=3, exposure=0.2,
                        atm={dens=0.3,  color={175,190,210},  decay={120,135,160}, glare=2.6, haze=1.2}},

  -- Supernova: il disco solare portato a 130 (tutti gli altri stanno sotto
  -- 75) piu' esposizione e glare al massimo. Non e' un cielo luminoso, e'
  -- un cielo in cui non riesci a guardare in quella direzione.
  ["Supernova"]      = {clock=12,  brightness=4.5, ambient={255,245,225}, outAmb={255,250,235}, sky={sun=130,    stars=0, moon=0},   exposure=0.9,
                        atm={dens=0.2,  color={255,250,235},  decay={255,210,150}, glare=5,   haze=1.6}},

  -- Marte: il cielo butterscotch della polvere in sospensione, sole
  -- piccolo e lontano, latitudine equatoriale. Non e' "arancione" come
  -- Copper Sky o Volcanic, che sono tramonti terrestri: e' un cielo
  -- diurno che sulla Terra non esiste.
  ["Mars"]           = {clock=11,  brightness=1.9, ambient={190,145,110}, outAmb={200,155,120}, sky={sun=7,      stars=0, moon=0},   lat=2, envS=0.2,
                        shiftTop={70, 30, 0},
                        atm={dens=0.38, color={205,150,105},  decay={175,120,80},  glare=1.1, haze=2}},

  -- Titano: la luna di Saturno vista da sotto la sua foschia di metano.
  -- Nebbia arancione fitta e luce quasi assente â€” laggiu' arriva un
  -- centesimo della luce che arriva a noi. Heaven e' bianco e arioso,
  -- questo e' l'opposto: una coltre che chiude tutto, e per giunta al
  -- buio.
  ["Titan"]          = {clock=12,  brightness=0.9, ambient={150,100,45},  outAmb={160,110,55},  sky={sun=0,      stars=0, moon=0},   noAtm=true, shadows=false, exposure=-0.15, envD=1.3, envS=0,
                        fog={0, 150, {168, 108, 38}}},

  -- Dreamcore: ombre spente e luce d'ambiente piatta, quindi niente
  -- volume e niente profondita' â€” tutto sembra disegnato invece che
  -- illuminato. Cotton Candy e Lavender Dream sono cieli pastello
  -- normali; qui il pastello e' nel MODO in cui la luce si posa.
  ["Dreamcore"]      = {clock=13,  brightness=2.6, ambient={215,200,240}, outAmb={225,210,250}, sky={sun=0,      stars=0, moon=0},   shadows=false, envD=1.8, envS=0,
                        shiftTop={60, 30, 80}, exposure=0.3,
                        atm={dens=0.3,  color={215,185,255},  decay={235,215,255}, glare=0.6, haze=2.6}, clouds={cover=0.7,  dens=0.35, color={250,240,255}}},

  -- Notte di brace: nero sopra, arancio che sale dal basso. Le ombre
  -- tinte di arancio fanno sembrare che la luce venga da terra â€” da un
  -- incendio dietro la collina â€” invece che dal cielo. Volcanic e
  -- Hellscape hanno il cielo in fiamme; qui il cielo e' spento e quello
  -- che brucia sta fuori campo.
  ["Ember Night"]    = {clock=23,  brightness=1.2, ambient={80,45,30},    outAmb={92,52,34},    sky={stars=2600, moon=0,  sun=0},
                        shiftBot={120, 45, 0}, exposure=-0.2,
                        atm={dens=0.55, color={25,18,22},     decay={225,95,35},   glare=1.8, haze=2.4}, clouds={cover=0.5,  dens=0.6,  color={70,40,30}}},
  -- PH: cielo nero, atmosfera arancione.
  ["PH"]             = {clock=0, brightness=0.75, ambient={18,12,8}, outAmb={12,8,6}, sky={black=true, stars=0, moon=0, sun=0}, exposure=-0.15,
                        atm={dens=0.58, color={5,5,5}, decay={242,140,40}, glare=0.4, haze=1.8}},
}

function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

-- Rimuove solo gli oggetti sky taggati da AmbitiousHub
function _v4mpClearSky()
  for _, v in ipairs(Lighting:GetChildren()) do
    if v:GetAttribute("_AmbitiousHubSky") then pcall(function() v:Destroy() end) end
  end
  local terrain = workspace:FindFirstChildOfClass("Terrain")
  if terrain then
    for _, v in ipairs(terrain:GetChildren()) do
      if v:GetAttribute("_AmbitiousHubSky") then pcall(function() v:Destroy() end) end
    end
  end
end

-- Disconnette tutti gli event listener del sky changer
local function clearSkyConnections()
  for _, conn in ipairs(skyEventConnections) do
    pcall(conn.Disconnect, conn)
  end
  skyEventConnections = {}
end

-- Salva lo stato originale del Lighting (Sky, Atmosphere, Clouds) prima di sovrascriverlo
local function saveOriginalSky()
  if #originalSkyObjects > 0 then return end

  local function saveObj(obj, parent)
    if not obj then return end
    local data = { class = obj.ClassName, parent = parent, properties = {} }
    if obj:IsA("Sky") then
      data.properties.StarCount      = obj.StarCount
      data.properties.MoonAngularSize = obj.MoonAngularSize
      data.properties.SunAngularSize  = obj.SunAngularSize
      data.properties.MoonTextureId   = obj.MoonTextureId
    elseif obj:IsA("Atmosphere") then
      data.properties.Density = obj.Density
      data.properties.Color   = obj.Color
      data.properties.Decay   = obj.Decay
      data.properties.Glare   = obj.Glare
      data.properties.Haze    = obj.Haze
    elseif obj:IsA("Clouds") then
      data.properties.Cover   = obj.Cover
      data.properties.Density = obj.Density
      data.properties.Color   = obj.Color
    end
    table.insert(originalSkyObjects, data)
  end

  local sky   = Lighting:FindFirstChildWhichIsA("Sky")
  if sky then saveObj(sky, Lighting) end
  local atm   = Lighting:FindFirstChildWhichIsA("Atmosphere")
  if atm then saveObj(atm, Lighting) end
  local terrain = workspace:FindFirstChildOfClass("Terrain")
  if terrain then
    local clouds = terrain:FindFirstChildWhichIsA("Clouds")
    if clouds then saveObj(clouds, terrain) end
  end
end

-- Ripristina gli oggetti sky originali dopo aver disattivato il preset
local function restoreOriginalSky()
  for _, data in ipairs(originalSkyObjects) do
    local parent = data.parent
    if not parent then continue end
    local newObj = Instance.new(data.class)
    for prop, val in pairs(data.properties) do
      newObj[prop] = val
    end
    newObj.Parent = parent
  end
  originalSkyObjects = {}
end

-- Distrugge gli oggetti originali del gioco per fare posto al preset
local function removeOriginalSkyObjects()
  local function remove(obj)
    if obj and not obj:GetAttribute("_AmbitiousHubSky") then
      obj:Destroy()
    end
  end
  for _, obj in ipairs(Lighting:GetChildren()) do
    if obj:IsA("Sky") or obj:IsA("Atmosphere") then remove(obj) end
  end
  local terrain = workspace:FindFirstChildOfClass("Terrain")
  if terrain then
    for _, obj in ipairs(terrain:GetChildren()) do
      if obj:IsA("Clouds") then remove(obj) end
    end
  end
end

-- Funzione principale: applica il preset sky con logica anti-destroy completa
function applyCustomSky(mode)
  skyTheme = mode
  _v4mpClearSky()
  clearSkyConnections()
  -- >>> RAINBOW <<< ferma il ciclo di tinte del preset precedente
  _G._AmbitiousSkyRainbowToken = (_G._AmbitiousSkyRainbowToken or 0) + 1
  -- Stessa cosa per i preset che si muovono da soli (giorno che scorre,
  -- lampi, pulsazione, lampeggio): un token che cambia e il vecchio ciclo
  -- si accorge di non essere piu' quello buono e si ferma.
  _G._AmbitiousSkyDynToken = (_G._AmbitiousSkyDynToken or 0) + 1
  -- Il vecchio ciclo si spegne al frame dopo: la sua luce del lampo la si
  -- toglie subito, per non lasciarla accesa in mezzo alla scena.
  local _oldFlash = workspace:FindFirstChild("AmbitiousSkyFlash")
  while _oldFlash do
    pcall(function() _oldFlash:Destroy() end)
    _oldFlash = workspace:FindFirstChild("AmbitiousSkyFlash")
  end

  if mode == "Off" then
    restoreOriginalSky()
    if not antiLagVisualEnabled then
      Lighting.FogEnd    = 100000
      Lighting.FogStart  = 0
      Lighting.FogColor  = Color3.fromRGB(192,192,192)
      Lighting.Brightness  = 2
      Lighting.ClockTime   = 14
      Lighting.GlobalShadows = true
      -- Leve introdotte dai preset nuovi: se restassero impostate, un
      -- tema con l'esposizione alzata o la latitudine spostata
      -- continuerebbe a farsi sentire anche dopo averlo spento.
      Lighting.ExposureCompensation     = 0
      Lighting.ColorShift_Top           = Color3.fromRGB(0, 0, 0)
      Lighting.ColorShift_Bottom        = Color3.fromRGB(0, 0, 0)
      Lighting.GeographicLatitude       = 41.733
      Lighting.EnvironmentDiffuseScale  = 1
      Lighting.EnvironmentSpecularScale = 1
    end
    V.skyTheme = "Off"
    if skyValueLabel then skyValueLabel.Text = "Off" end
    return
  end

  local preset = SKY_PRESETS[mode]
  if not preset then
    V.skyTheme = "Off"
    return
  end

  saveOriginalSky()
  removeOriginalSkyObjects()

  -- NEBBIA VERA contro ATMOSPHERE: sono alternative, non si sommano.
  -- Con un'Atmosphere in scena il motore ignora FogStart/FogEnd, quindi i
  -- preset che vogliono la nebbia chiedono noAtm e si prendono tutto il
  -- controllo della visibilita': e' cosi' che si ottiene il muro bianco
  -- della bufera o l'acqua torbida, cose che con l'Atmosphere non si
  -- possono fare perche' quella sfuma la distanza, non la taglia.
  if preset.fog then
    Lighting.FogStart = preset.fog[1]
    Lighting.FogEnd   = preset.fog[2]
    Lighting.FogColor = _vC3(preset.fog[3])
  else
    Lighting.FogEnd    = 100000
    Lighting.FogStart  = 0
    Lighting.FogColor  = Color3.fromRGB(200,200,200)
  end
  -- Leve che nessun preset precedente toccava:
  -- shadows  - ombre spente: luce piatta, niente volume (irreale di
  --            proposito, oppure buio totale dove un'ombra non ha senso)
  -- exposure - diaframma: schiaccia nel nero o brucia nel bianco SENZA
  --            cambiare i colori, cosa che Brightness da sola non fa
  -- shiftTop/shiftBot - tingono separatamente luci e ombre: e' la leva
  --            del falso colore (termico, viraggio seppia)
  -- lat      - latitudine: decide il PERCORSO del sole nel cielo, non la
  --            sua tinta. A 89 gradi il sole striscia sull'orizzonte
  --            tutto il giorno, a -85 non sorge proprio
  -- envD/envS - quanta luce d'ambiente diffusa e speculare: envS alto fa
  --            sembrare ogni superficie metallica
  Lighting.GlobalShadows = (preset.shadows ~= false)
  Lighting.ExposureCompensation     = preset.exposure or 0
  Lighting.ColorShift_Top           = preset.shiftTop and _vC3(preset.shiftTop) or Color3.fromRGB(0, 0, 0)
  Lighting.ColorShift_Bottom        = preset.shiftBot and _vC3(preset.shiftBot) or Color3.fromRGB(0, 0, 0)
  Lighting.GeographicLatitude       = preset.lat  or 41.733
  Lighting.EnvironmentDiffuseScale  = preset.envD or 1
  Lighting.EnvironmentSpecularScale = preset.envS or 1
  Lighting.ClockTime   = preset.clock or 14
  -- Punto di partenza dell'ora per i preset che la fanno scorrere. Sta
  -- qui e non dentro il ciclo perche' il ciclo puo' essere ricreato (se
  -- il gioco ci butta dentro un suo Sky, i nostri oggetti vengono rifatti
  -- e con loro riparte il ciclo): ripartendo da capo ogni volta, il sole
  -- tornava di colpo all'ora iniziale. Cosi' invece riprende da dov'era.
  _G._AmbitiousSkyClk = preset.clock or 14
  Lighting.Brightness  = preset.brightness or 2
  if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
  if preset.ambient  then Lighting.Ambient        = _vC3(preset.ambient) end

  -- Funzione interna: (ri)crea Sky, Atmosphere, Clouds taggati
  local function createSkyObjects()
    -- Rimuovi eventuali duplicati rimasti
    _v4mpClearSky()

    if preset.sky then
      local sky = Instance.new("Sky")
      sky:SetAttribute("_AmbitiousHubSky", true)
      if preset.sky.black then
        -- Cielo completamente nero per il preset PH.
        sky.CelestialBodiesShown = false
        sky.StarCount = 0
        sky.SunAngularSize = 0
        sky.MoonAngularSize = 0
        sky.SkyboxBk = ""; sky.SkyboxDn = ""; sky.SkyboxFt = ""
        sky.SkyboxLf = ""; sky.SkyboxRt = ""; sky.SkyboxUp = ""
      else
        if preset.sky.stars   then sky.StarCount        = preset.sky.stars   end
        if preset.sky.moon    then sky.MoonAngularSize  = preset.sky.moon    end
        if preset.sky.sun     then sky.SunAngularSize   = preset.sky.sun     end
        if preset.sky.moonTex then sky.MoonTextureId    = "rbxasset://sky/moon.jpg" end
      end
      sky.Parent = Lighting
    end

    -- Niente Atmosphere se il preset vuole la nebbia: finche' ce n'e' una
    -- in scena FogStart/FogEnd non vengono nemmeno guardati.
    local atm = nil
    if not preset.noAtm then
      atm = Instance.new("Atmosphere")
      atm:SetAttribute("_AmbitiousHubSky", true)
      if preset.atm then
        atm.Density = preset.atm.dens  or 0.3
        atm.Color   = _vC3(preset.atm.color)
        atm.Decay   = _vC3(preset.atm.decay)
        atm.Glare   = preset.atm.glare or 1
        atm.Haze    = preset.atm.haze  or 1
      end
      atm.Parent = Lighting
    end

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
      local clouds = Instance.new("Clouds")
      clouds:SetAttribute("_AmbitiousHubSky", true)
      clouds.Cover   = preset.clouds.cover or 0.5
      clouds.Density = preset.clouds.dens  or 0.5
      clouds.Color   = _vC3(preset.clouds.color)
      clouds.Parent  = terrain
    end

    -- >>> RAINBOW BEGIN
    -- La tinta si ricava dal TEMPO, non da un contatore incrementato a ogni
    -- frame: cosi' la velocita' non dipende dagli fps e il passaggio non ha
    -- scatti. RAINBOW_PERIOD = secondi per un giro completo dello spettro.
    -- Decay resta sempre a RAINBOW_GAP di distanza da Color, quindi le due
    -- tinte in cielo restano contrastate come nel dorato/rosa.
    if preset.rainbow and atm then
      local myToken = (_G._AmbitiousSkyRainbowToken or 0) + 1
      _G._AmbitiousSkyRainbowToken = myToken
      local RAINBOW_PERIOD = 34
      local RAINBOW_GAP    = 0.55
      task.spawn(function()
        while _G._AmbitiousSkyRainbowToken == myToken do
          if not (atm and atm.Parent) then break end
          local h = (os.clock() % RAINBOW_PERIOD) / RAINBOW_PERIOD
          pcall(function()
            atm.Color = Color3.fromHSV(h, 0.75, 1)
            atm.Decay = Color3.fromHSV((h + RAINBOW_GAP) % 1, 0.8, 1)
          end)
          RunService.Heartbeat:Wait()
        end
      end)
    end
    -- <<< RAINBOW END

    -- >>> CIELI CHE SI MUOVONO <<<
    -- Quattro leve diverse, un ciclo solo. Tutte leggono il TEMPO invece
    -- di contare i frame, cosi' vanno alla stessa velocita' a 30 come a
    -- 240 fps.
    --   drift  - l'ora del giorno avanza: alba, mezzogiorno, tramonto e
    --            notte scorrono davvero mentre giochi
    --   flash  - lampi: il buio viene spezzato da colpi di luce a
    --            intervalli irregolari, perche' regolari sembrerebbero
    --            un difetto e non un temporale
    --   pulse  - respiro lento della luminosita', avanti e indietro
    if preset.drift or preset.flash or preset.pulse then
      local myTok = (_G._AmbitiousSkyDynToken or 0) + 1
      _G._AmbitiousSkyDynToken = myTok
      local baseB = preset.brightness or 2
      task.spawn(function()
        local nextFlash = os.clock() + 1.5
        -- L'ora del giorno la teniamo NOI, in questa variabile, e ogni
        -- frame la riscriviamo su Lighting. Prima invece si leggeva
        -- Lighting.ClockTime e gli si sommava il passo: sembra la stessa
        -- cosa, ma non lo e' se qualcun altro scrive li' dentro. Il gioco
        -- ha il suo ciclo giorno/notte e rimette l'ora sua; leggendo da
        -- lui si ripartiva ogni volta dal suo valore e il giro non si
        -- chiudeva mai â€” l'ora ballava avanti e indietro e il sole
        -- restava piantato. Tenendo il conto per conto nostro l'ultima
        -- parola e' la nostra e il giro si completa.
        local clk = _G._AmbitiousSkyClk or (preset.clock or 14)

        -- DA DOVE ARRIVA IL LAMPO.
        -- Alzare la luminosita' generale illumina tutto in modo uguale e
        -- non ha una provenienza: sembra che si accenda una lampadina
        -- nella stanza, non che cada un fulmine. Serve una sorgente vera
        -- messa da qualche parte, e questa e' una luce puntiforme piazzata
        -- ogni volta in un punto diverso: angolo pescato su tutto il giro,
        -- piu' distanza e altezza casuali. L'angolo e' in coordinate del
        -- MONDO e non della telecamera â€” legandolo alla telecamera i lampi
        -- finivano sempre dallo stesso lato rispetto a te, che e'
        -- esattamente il difetto da togliere.
        local flashPart, flashLight
        if preset.flash then
          flashPart = Instance.new("Part")
          flashPart.Name         = "AmbitiousSkyFlash"
          flashPart.Anchored     = true
          flashPart.CanCollide   = false
          flashPart.CanQuery     = false
          flashPart.CanTouch     = false
          flashPart.CastShadow   = false
          flashPart.Transparency = 1
          flashPart.Size         = Vector3.new(1, 1, 1)
          flashPart.Parent       = workspace

          flashLight = Instance.new("PointLight")
          flashLight.Color      = Color3.fromRGB(255, 220, 70)
          flashLight.Range      = 60
          flashLight.Brightness = 0
          flashLight.Shadows    = false
          flashLight.Enabled    = false
          flashLight.Parent     = flashPart
        end
        while _G._AmbitiousSkyDynToken == myTok do
          local dt = RunService.Heartbeat:Wait()
          if preset.drift then
            clk = (clk + preset.drift * dt) % 24
            _G._AmbitiousSkyClk = clk
            Lighting.ClockTime = clk
          end
          if preset.pulse then
            local w = (math.sin(os.clock() * math.pi * 2 / preset.pulse.period) + 1) * 0.5
            Lighting.Brightness = preset.pulse.min + (preset.pulse.max - preset.pulse.min) * w
          end
          if preset.flash and os.clock() >= nextFlash then
            local gapA, gapB = preset.flash.gapMin or 2, preset.flash.gapMax or 6
            nextFlash = os.clock() + gapA + math.random() * (gapB - gapA)
            -- Il punto da cui arriva questo lampo: a sinistra, a distanza
            -- e altezza casuali. Si sceglie una volta per lampo, non a
            -- ogni colpo, se no i tre sfarfallii sembrerebbero tre fulmini
            -- diversi invece che uno solo che tremola.
            if flashPart then
              local cam = workspace.CurrentCamera
              if cam then
                local ang  = math.random() * math.pi * 2
                local dist = 28 + math.random() * 26
                flashPart.Position = cam.CFrame.Position + Vector3.new(
                  math.cos(ang) * dist,
                  16 + math.random() * 16,
                  math.sin(ang) * dist)
              end
            end
            task.spawn(function()
              -- Due o tre colpi ravvicinati: un lampo singolo e pulito
              -- non somiglia a niente, il tremolio si'.
              for _ = 1, (preset.flash.bursts or 2) do
                if _G._AmbitiousSkyDynToken ~= myTok then return end
                if flashLight then
                  flashLight.Brightness = 14
                  flashLight.Enabled = true
                end
                Lighting.Brightness = preset.flash.peak or 6
                task.wait(0.05)
                if _G._AmbitiousSkyDynToken ~= myTok then return end
                if flashLight then flashLight.Enabled = false end
                Lighting.Brightness = baseB
                task.wait(0.06 + math.random() * 0.1)
              end
            end)
          end
        end
        -- Cambiato tema: la sorgente del lampo se ne va con lui.
        if flashPart then pcall(function() flashPart:Destroy() end) end
      end)
    end
    -- <<< CIELI CHE SI MUOVONO
  end

  createSkyObjects()

  -- 1) Lock delle proprietÃ  Lighting: se qualcosa le cambia le riportiamo al valore del preset
  local function onLightingPropChanged(prop)
    return function()
      if skyTheme == "Off" then return end
      local p = SKY_PRESETS[skyTheme]
      if not p then return end
      local current  = Lighting[prop]
      local expected
      -- Un preset che muove l'ora o la luminosita' da solo non va
      -- riportato indietro: il blocco serve contro chi tocca il cielo da
      -- fuori, non contro il preset stesso.
      if     prop == "ClockTime"       then
        -- Con un preset che fa scorrere l'ora, il valore atteso non e'
        -- quello fisso del preset ma quello a cui e' arrivato il ciclo.
        -- Prima qui si usciva e basta, lasciando campo libero: il gioco ha
        -- il suo script del giorno/notte che nei primi secondi scrive la
        -- SUA ora, e se tocca a lui per ultimo nel frame e' la sua che si
        -- vede â€” il sole partiva nel posto sbagliato e si rimetteva a
        -- posto solo quando quello script la smetteva. Adesso ogni
        -- scrittura che non sia la nostra viene corretta all'istante.
        expected = p.drift and (_G._AmbitiousSkyClk or p.clock or 14)
                   or (p.clock or 14)
      elseif prop == "Brightness"      then
        if p.flash or p.pulse then return end
        expected = p.brightness or 2
      elseif prop == "OutdoorAmbient"  then expected = p.outAmb  and _vC3(p.outAmb)
      elseif prop == "Ambient"         then expected = p.ambient and _vC3(p.ambient)
      end
      if expected then
        local ok = pcall(function()
          if typeof(current) == "number" then
            if math.abs(current - expected) > 0.001 then Lighting[prop] = expected end
          else
            Lighting[prop] = expected
          end
        end)
      end
    end
  end

  for _, prop in ipairs({"ClockTime","Brightness","OutdoorAmbient","Ambient"}) do
    local conn = Lighting:GetPropertyChangedSignal(prop):Connect(onLightingPropChanged(prop))
    table.insert(skyEventConnections, conn)
  end

  -- 2) Anti-destroy: se un oggetto esterno (Sky/Atmosphere/Clouds) viene aggiunto, lo distruggiamo
  --    e ricreamo i nostri. Compatibile con l'anti-lag di AmbitiousTest (controlla _AmbitiousHubSky).
  local function onForeignObjectAdded(obj)
    if skyTheme == "Off" then return end
    if obj:GetAttribute("_AmbitiousHubSky") then return end
    if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then
      pcall(function() obj:Destroy() end)
      task.defer(createSkyObjects)
    end
  end

  local lightingDescConn = Lighting.DescendantAdded:Connect(onForeignObjectAdded)
  table.insert(skyEventConnections, lightingDescConn)

  local terrain = workspace:FindFirstChildOfClass("Terrain")
  if terrain then
    local terrainDescConn = terrain.DescendantAdded:Connect(onForeignObjectAdded)
    table.insert(skyEventConnections, terrainDescConn)
  end

  -- 3) Se i nostri oggetti vengono rimossi (Destroy dall'esterno), li ricreamo
  local function onOurObjectRemoved(obj)
    if skyTheme == "Off" then return end
    if obj:GetAttribute("_AmbitiousHubSky") then
      task.defer(createSkyObjects)
    end
  end

  local function attachAncestryChanged(obj)
    local conn = obj.AncestryChanged:Connect(function(_, parent)
      if not parent then onOurObjectRemoved(obj) end
    end)
    table.insert(skyEventConnections, conn)
  end

  for _, obj in ipairs(Lighting:GetDescendants()) do
    if obj:GetAttribute("_AmbitiousHubSky") then
      attachAncestryChanged(obj)
    end
  end
  if terrain then
    for _, obj in ipairs(terrain:GetDescendants()) do
      if obj:GetAttribute("_AmbitiousHubSky") then
        attachAncestryChanged(obj)
      end
    end
  end

  V.skyTheme = mode
  if skyValueLabel then skyValueLabel.Text = mode end
end

function enableUltraMode()
  V.ultraModeEnabled = true
  applyKTMOptimization()
end

function disableUltraMode()
  V.ultraModeEnabled = false
end

function enableRemoveAccessories()
  V.removeAccessoriesEnabledSep = true
  removeAccessoriesEnabled = true
  removeAllAccessories()
  if not V.removeAccCharConns then V.removeAccCharConns = {} end
  if V.removeAccConn then V.removeAccConn:Disconnect() end
  V.removeAccConn = Players.PlayerAdded:Connect(function(player)
    -- Disconnetti eventuale conn precedente per questo player
    if V.removeAccCharConns[player] then
      pcall(function() V.removeAccCharConns[player]:Disconnect() end)
    end
    V.removeAccCharConns[player] = player.CharacterAdded:Connect(function(char)
      task.wait(0.5)
      if V.removeAccessoriesEnabledSep or removeAccessoriesEnabled then
        for _, obj in ipairs(char:GetDescendants()) do processAntiLagDescendant(obj) end
      end
    end)
  end)
  -- Pulizia alla rimozione del player
  if V.removeAccRemovingConn then V.removeAccRemovingConn:Disconnect() end
  V.removeAccRemovingConn = Players.PlayerRemoving:Connect(function(player)
    if V.removeAccCharConns and V.removeAccCharConns[player] then
      pcall(function() V.removeAccCharConns[player]:Disconnect() end)
      V.removeAccCharConns[player] = nil
    end
  end)
  if antiLagDescConn then antiLagDescConn:Disconnect() end
  antiLagDescConn = Workspace.DescendantAdded:Connect(function(obj)
    if antiLagEnabled or V.ultraModeEnabled or removeAccessoriesEnabled or V.removeAccessoriesEnabledSep then
      processAntiLagDescendant(obj)
    end
  end)
end

function disableRemoveAccessories()
  V.removeAccessoriesEnabledSep = false
  removeAccessoriesEnabled = false
  if V.removeAccConn then V.removeAccConn:Disconnect(); V.removeAccConn = nil end
  if V.removeAccRemovingConn then V.removeAccRemovingConn:Disconnect(); V.removeAccRemovingConn = nil end
  if V.removeAccCharConns then
    for _, conn in pairs(V.removeAccCharConns) do pcall(function() conn:Disconnect() end) end
    table.clear(V.removeAccCharConns)
  end
  if not antiLagEnabled and not V.ultraModeEnabled and antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
end

-- RIMOSSO NUKE OPTIMISER completamente

function enableCustomFont()
  customFontVisualEnabled = false
  if V then V.customFontEnabled = false end
end

function disableCustomFont()
  customFontVisualEnabled = false
  if V then V.customFontEnabled = false end
end

__ambitious_src_enableNoCamCollision = enableNoCamCollision
function enableNoCamCollision()
  __ambitious_src_enableNoCamCollision()
  noCamCollisionEnabled = true
end

__ambitious_src_disableNoCamCollision = disableNoCamCollision
function disableNoCamCollision()
  __ambitious_src_disableNoCamCollision()
  noCamCollisionEnabled = false
end



-- ============================================================
-- JESUS MODE
-- Modalita' cosmetica locale: pelle/abbigliamento chiaro, aureola,
-- aura luminosa e animazione "Ghost" per walk/run/idle.
-- ============================================================
_G.AmbitiousJesusMode = _G.AmbitiousJesusMode or {
  enabled = false,
  saved = {},
  char = nil,
}

local JESUS_GHOST_WALK = "rbxassetid://124260679864309"
local JESUS_GHOST_IDLE = "rbxassetid://110395159339100"

-- Jesus Mode usa il pack di animazioni selezionato nella UI (1-5).
-- NONE lascia le animazioni Roblox normali.
_G.AmbitiousGetSelectedAnimPackIndex = _G.AmbitiousGetSelectedAnimPackIndex or function()
  return 1
end

local function _jesusSavePart(part)
  local J = _G.AmbitiousJesusMode
  J.saved.parts = J.saved.parts or {}
  if not J.saved.parts[part] then
    J.saved.parts[part] = {
      Color = part.Color,
      Material = part.Material,
      Transparency = part.Transparency,
    }
  end
end

local function _jesusSetAnimations(char, enable)
  local J = _G.AmbitiousJesusMode
  if not char then return end
  if not enable then
    -- Se Jesus Mode viene spento, lascia che il sistema Animation Packs ripristini
    -- il pack scelto; in assenza di pack torna alle animazioni Roblox.
    if _G.AmbitiousSetAnimPack then
      local idx = 1
      pcall(function() idx = _G.AmbitiousGetSelectedAnimPackIndex() or 1 end)
      pcall(function() _G.AmbitiousSetAnimPack(idx) end)
    else
      local animate = char:FindFirstChild("Animate")
      if animate then animate.Disabled = false end
    end
    return
  end

  -- Non sostituiamo piu' la camminata con il vecchio Ghost: Jesus Mode
  -- segue ESATTAMENTE una delle 5 animazioni scelte dall'utente.
  local idx = 1
  pcall(function() idx = _G.AmbitiousGetSelectedAnimPackIndex() or 1 end)
  idx = math.clamp(tonumber(idx) or 1, 1, 7)
  if idx >= 2 and idx <= 6 and _G.AmbitiousSetAnimPack then
    pcall(function() _G.AmbitiousSetAnimPack(idx) end)
  elseif idx == 7 and _G.AmbitiousSetAnimPack then
    pcall(function() _G.AmbitiousSetAnimPack(7) end)
  end
end

local JESUS_HAIR_BEARD_ASSET = 75183550977245
local JESUS_HAIR_BEARD_ASSET_ALT = 119860830091287
local JESUS_CROWN_ASSET = 72338631586167
-- Outfit 3D Jesus: layered accessories verificati sul catalogo Roblox.
-- Top: Jesus (Affloct), Lower: Jesus Suit (Kursed Studio).
local JESUS_REALISTIC_TOP_ASSET = 137432705485091
local JESUS_REALISTIC_LOWER_ASSET = 130868456545479

local function _jesusClearExtras(char)
  if not char then return end
  for _, name in ipairs({
    "JesusAura", "JesusHalo", "JesusLight", "JesusHighlight",
    "JesusRobe", "JesusRobeLower", "JesusRobeFront", "JesusRobeBack", "JesusRobeSideL", "JesusRobeSideR", "JesusRobeLowerFront", "JesusRobeLowerBack", "JesusRobeLowerSideL", "JesusRobeLowerSideR", "JesusMantle", "JesusMantleEdge", "JesusSash",
    "JesusHairBeard", "JesusThornCrown", "JesusRealisticTop", "JesusRealisticLower", "HaloGlow"
  }) do
    local obj = char:FindFirstChild(name)
    if obj then pcall(function() obj:Destroy() end) end
  end
  for _, obj in ipairs(char:GetChildren()) do
    if obj.Name == "JesusSleeve" or obj.Name == "JesusRobeSkirt" then pcall(function() obj:Destroy() end) end
  end
end

local function _jesusWeldPart(part, parentPart, cf)
  part.Anchored = false
  part.CanCollide = false
  part.CanTouch = false
  part.CanQuery = false
  part.Massless = true
  part.CastShadow = false
  part.CFrame = parentPart.CFrame * cf
  part.Parent = parentPart.Parent
  local weld = Instance.new("WeldConstraint")
  weld.Part0 = parentPart
  weld.Part1 = part
  weld.Parent = part
  return part
end

local function _jesusMakeRobe(char, torso, humanoid)
  -- Tunica piu' realistica: tessuto sottile vicino al corpo + gonna lunga
  -- leggermente svasata, mantello separato e fascia in vita.
  local robeColor = Color3.fromRGB(224, 214, 193)
  local robeShadow = Color3.fromRGB(198, 184, 160)
  local mantleColor = Color3.fromRGB(96, 55, 42)
  local mantleEdge = Color3.fromRGB(122, 78, 58)
  local sashColor = Color3.fromRGB(184, 140, 57)
  local lower = char:FindFirstChild("LowerTorso")
  local isR15 = humanoid and humanoid.RigType == Enum.HumanoidRigType.R15

  local function addPart(name, parentPart, size, color, offset, material, transparency, shape)
    if not parentPart then return nil end
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Color = color
    p.Material = material or Enum.Material.Fabric
    p.Transparency = transparency or 0.08
    if shape then p.Shape = shape end
    _jesusWeldPart(p, parentPart, offset or CFrame.new())
    return p
  end

  local function sleeve(part, name)
    if not part then return end
    -- Piccolo margine sul braccio: sembra stoffa, non un secondo braccio.
    addPart(name, part, part.Size + Vector3.new(0.045, 0.045, 0.045), robeColor,
      CFrame.new(), Enum.Material.Fabric, 0.16)
  end

  if isR15 and lower then
    local ux, uy, uz = torso.Size.X, torso.Size.Y, torso.Size.Z
    -- Busto: solo un sottile strato esterno, con apertura davanti.
    addPart("JesusRobeFront", torso, Vector3.new(ux + .06, uy + .04, .045), robeColor,
      CFrame.new(0, 0, -uz/2 - .024), Enum.Material.Fabric, .04)
    addPart("JesusRobeBack", torso, Vector3.new(ux + .06, uy + .04, .045), robeColor,
      CFrame.new(0, 0, uz/2 + .024), Enum.Material.Fabric, .11)
    addPart("JesusRobeSideL", torso, Vector3.new(.045, uy + .04, uz + .02), robeColor,
      CFrame.new(-ux/2 - .024, 0, 0), Enum.Material.Fabric, .10)
    addPart("JesusRobeSideR", torso, Vector3.new(.045, uy + .04, uz + .02), robeColor,
      CFrame.new(ux/2 + .024, 0, 0), Enum.Material.Fabric, .10)

    -- Gonna lunga svasata: 8 pannelli sottili attorno al LowerTorso.
    -- La parte alta resta vicina al corpo, mentre il bordo inferiore si apre.
    local lx, ly, lz = lower.Size.X, lower.Size.Y, lower.Size.Z
    local radius = math.max(lx, lz) * 0.52
    local skirtHeight = math.max(2.25, ly * 1.55)
    for i = 1, 8 do
      local a = ((i - 1) / 8) * math.pi * 2
      local px, pz = math.cos(a) * radius, math.sin(a) * radius
      local panel = Instance.new("WedgePart")
      panel.Name = "JesusRobeSkirt"
      panel.Size = Vector3.new(.62, skirtHeight, 1.10)
      panel.Color = (i % 2 == 0) and robeColor or robeShadow
      panel.Material = Enum.Material.Fabric
      panel.Transparency = .08
      panel.CanCollide = false
      panel.CanTouch = false
      panel.CanQuery = false
      panel.Massless = true
      panel.CastShadow = false
      panel.CFrame = lower.CFrame
        * CFrame.new(px, -ly * .55, pz)
        * CFrame.Angles(0, -a, 0)
      panel.Parent = char
      local weld = Instance.new("WeldConstraint")
      weld.Part0 = lower
      weld.Part1 = panel
      weld.Parent = panel
    end

    -- Orlo' basso leggermente piu' scuro per dare profondita' al tessuto.
    addPart("JesusRobeLowerBack", lower, Vector3.new(lx + .18, .08, .10), robeShadow,
      CFrame.new(0, -ly * 1.08, lz/2 + .03), Enum.Material.Fabric, .02)

    -- Fascia sottile, avvolta in vita.
    addPart("JesusSash", lower, Vector3.new(lx + .18, .13, lz + .12), sashColor,
      CFrame.new(0, ly * .18, 0), Enum.Material.Fabric, .02)

    -- Mantello sulle spalle, piu' spesso al centro e piu' sottile ai lati.
    addPart("JesusMantle", torso, Vector3.new(ux + .46, uy * .82, .07), mantleColor,
      CFrame.new(0, .02, uz/2 + .055), Enum.Material.Fabric, .08)
    addPart("JesusMantleEdge", torso, Vector3.new(ux + .50, .07, .08), mantleEdge,
      CFrame.new(0, -uy * .36, uz/2 + .075), Enum.Material.Fabric, .04)
  else
    -- R6: tunica sottile sul torso + pannelli verticali per dare lunghezza.
    local sx, sy, sz = torso.Size.X, torso.Size.Y, torso.Size.Z
    addPart("JesusRobeFront", torso, Vector3.new(sx + .08, sy + .08, .05), robeColor,
      CFrame.new(0, 0, -sz/2 - .028), Enum.Material.Fabric, .05)
    addPart("JesusRobeBack", torso, Vector3.new(sx + .08, sy + .08, .05), robeColor,
      CFrame.new(0, 0, sz/2 + .028), Enum.Material.Fabric, .12)
    addPart("JesusSash", torso, Vector3.new(sx + .16, .14, sz + .10), sashColor,
      CFrame.new(0, -.18, 0), Enum.Material.Fabric, .02)
  end

  sleeve(char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"), "JesusSleeveLeftUpper")
  sleeve(char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"), "JesusSleeveRightUpper")
  if isR15 then
    sleeve(char:FindFirstChild("LeftLowerArm"), "JesusSleeveLeftLower")
    sleeve(char:FindFirstChild("RightLowerArm"), "JesusSleeveRightLower")
  end
end

local function _jesusTryAccessory(char, assetId, name)
  local ok, objects = pcall(function()
    if game.GetObjects then
      return game:GetObjects("rbxassetid://" .. tostring(assetId))
    end
    return nil
  end)
  if not ok or type(objects) ~= "table" then return nil end
  for _, obj in ipairs(objects) do
    if obj and obj:IsA("Accessory") then
      obj.Name = name
      obj.Parent = char
      local hum = char:FindFirstChildOfClass("Humanoid")
      if hum then pcall(function() hum:AddAccessory(obj) end) end
      return obj
    end
    if obj then pcall(function() obj:Destroy() end) end
  end
  return nil
end

local function _jesusBuildFaceAndClothes(char, head, torso, humanoid)
  -- Prima usiamo veri accessori 3D del catalogo: hanno pieghe, bordi e volume
  -- molto piu' credibili dei Parts costruiti a mano. Se l'executor non consente
  -- GetObjects, _jesusMakeRobe resta il fallback locale.
  local realisticTop = _jesusTryAccessory(char, JESUS_REALISTIC_TOP_ASSET, "JesusRealisticTop")
  local realisticLower = _jesusTryAccessory(char, JESUS_REALISTIC_LOWER_ASSET, "JesusRealisticLower")
  local realisticOutfitLoaded = (realisticTop ~= nil or realisticLower ~= nil)

  -- Capelli + barba e corona di spine.
  local hair = _jesusTryAccessory(char, JESUS_HAIR_BEARD_ASSET, "JesusHairBeard")
  if not hair then
    _jesusTryAccessory(char, JESUS_HAIR_BEARD_ASSET_ALT, "JesusHairBeard")
  end
  _jesusTryAccessory(char, JESUS_CROWN_ASSET, "JesusThornCrown")

  -- Pelle calda e naturale; non tocchiamo il colore del resto del corpo.
  local faceTone = Color3.fromRGB(214, 178, 145)
  for _, name in ipairs({"Head", "LeftHand", "RightHand", "Left Arm", "Right Arm", "LeftLowerArm", "RightLowerArm"}) do
    local part = char:FindFirstChild(name)
    if part and part:IsA("BasePart") then
      part.Color = faceTone
      part.Material = Enum.Material.SmoothPlastic
    end
  end
  return realisticOutfitLoaded
end

local function _jesusBuildAura(char)
  _jesusClearExtras(char)
  local head = char:FindFirstChild("Head")
  local hrp = char:FindFirstChild("HumanoidRootPart")
  local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
  local hum = char:FindFirstChildOfClass("Humanoid")
  if not head then return end

  local aura = Instance.new("ParticleEmitter")
  aura.Name = "JesusAura"
  aura.Rate = 32
  aura.Lifetime = NumberRange.new(0.9, 1.8)
  aura.Speed = NumberRange.new(0.15, 0.8)
  aura.SpreadAngle = Vector2.new(360, 360)
  aura.LightEmission = 0.9
  aura.Color = ColorSequence.new(Color3.fromRGB(255, 230, 145), Color3.fromRGB(255,255,255))
  aura.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.16),
    NumberSequenceKeypoint.new(0.45, 0.30),
    NumberSequenceKeypoint.new(1, 0),
  })
  aura.Parent = head

  local halo = Instance.new("Folder")
  halo.Name = "JesusHalo"
  halo.Parent = char
  local haloRadius = 0.92
  local haloY = 0.72
  local segments = 24
  for i = 1, segments do
    local a = (i / segments) * math.pi * 2
    local seg = Instance.new("Part")
    seg.Name = "HaloSegment"
    seg.Shape = Enum.PartType.Cylinder
    seg.Size = Vector3.new(0.105, 0.34, 0.105)
    seg.Material = Enum.Material.Neon
    seg.Color = Color3.fromRGB(255, 221, 105)
    seg.Transparency = 0.04
    seg.CanCollide = false
    seg.CanTouch = false
    seg.CanQuery = false
    seg.Massless = true
    seg.CastShadow = false
    local x, z = math.cos(a) * haloRadius, math.sin(a) * haloRadius
    seg.CFrame = head.CFrame
      * CFrame.new(x, haloY, z)
      * CFrame.Angles(0, a, math.rad(90))
    seg.Parent = halo
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = seg
    weld.Parent = seg
  end
  -- Piccoli punti di luce attorno all'anello per un effetto aureola piÃ¹ morbido.
  local haloGlow = Instance.new("PointLight")
  haloGlow.Name = "HaloGlow"
  haloGlow.Color = Color3.fromRGB(255, 220, 130)
  haloGlow.Brightness = 0.8
  haloGlow.Range = 5
  haloGlow.Shadows = false
  haloGlow.Parent = head


  if hrp then
    local light = Instance.new("PointLight")
    light.Name = "JesusLight"
    light.Color = Color3.fromRGB(255, 226, 151)
    light.Brightness = 1.35
    light.Range = 11
    light.Shadows = false
    light.Parent = hrp
  end

  local hl = Instance.new("Highlight")
  hl.Name = "JesusHighlight"
  hl.FillColor = Color3.fromRGB(255, 235, 180)
  hl.FillTransparency = 0.94
  hl.OutlineColor = Color3.fromRGB(255, 220, 120)
  hl.OutlineTransparency = 0.28
  hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
  hl.Parent = char

  if hum then
    -- Mantiene la silhouette/avatar Roblox standard e rende le proporzioni piu naturali.
    pcall(function()
      if hum.RigType == Enum.HumanoidRigType.R15 then
        for _, scaleName in ipairs({"BodyDepthScale", "BodyWidthScale", "BodyHeightScale", "HeadScale"}) do
          local sc = hum:FindFirstChild(scaleName)
          if sc and sc:IsA("NumberValue") then sc.Value = 1 end
        end
      end
    end)
  end
  -- Costruisce prima capelli/accessori e il vero outfit 3D.
  -- Solo se gli accessori non sono disponibili usiamo la tunica procedurale.
  local realisticOutfitLoaded = _jesusBuildFaceAndClothes(char, head, torso, hum)
  if torso and not realisticOutfitLoaded then
    _jesusMakeRobe(char, torso, hum)
  end
end

function _G.AmbitiousJesusMode.SetEnabled(on)
  local J = _G.AmbitiousJesusMode
  on = on == true
  if J.enabled == on and J.char == LP.Character then return end

  local char = LP.Character
  if not char then
    J.enabled = on
    return
  end
  local hum = char:FindFirstChildOfClass("Humanoid")
  if not hum then return end

  if on then
    J.saved = {parts = {}, anims = {}}
    J.char = char
    for _, part in ipairs(char:GetDescendants()) do
      if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
        _jesusSavePart(part)
      end
    end
    _jesusSetAnimations(char, true)
    _jesusBuildAura(char)
    J.enabled = true
  else
    _jesusSetAnimations(char, false)
    for part, old in pairs(J.saved.parts or {}) do
      if part and part.Parent then
        pcall(function()
          part.Color = old.Color
          part.Material = old.Material
          part.Transparency = old.Transparency
        end)
      end
    end
    _jesusClearExtras(char)
    J.enabled = false
    J.char = nil
    J.saved = {}
  end
end

LP.CharacterAdded:Connect(function(char)
  task.defer(function()
    _G._AmbitiousWaitCharReady(char, 10)
    if _G.AmbitiousJesusMode and _G.AmbitiousJesusMode.enabled then
      _G.AmbitiousJesusMode.char = char
      task.wait(0.2)
      _G.AmbitiousJesusMode.SetEnabled(true)
    end
  end)
end)

function __AmbitiousDuelsSetupVisualsUI()
  local Utility = pages.VISUALS
  local skyThemes = SKY_PRESETS_LIST or {"Off", "Night", "Aurora", "Sunset", "Galaxy", "Cyber", "Sakura"}
  local skyIndex = 1
  for i, name in ipairs(skyThemes) do if name == skyTheme then skyIndex = i break end end

  function skyThemeSelectorRow(parent, order)
    local row = baseRow(parent, "Sky Theme", order)
    row.Size = UDim2.new(1, -4, 0, 42)
    row.ClipsDescendants = true
    local label = row:FindFirstChild("Label")
    if label then
      label.Size = UDim2.new(0, 92, 1, 0)
      label.TextSize = 11
    end

    local holder = Instance.new("Frame")
    holder.Name = "SkyValueHolder"
    holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    holder.BackgroundTransparency = 0.28
    holder.BorderSizePixel = 0
    holder.Size = UDim2.new(0, 124, 0, 30)
    holder.Position = UDim2.new(1, -132, 0.5, -15)
    holder.ClipsDescendants = true
    holder.ZIndex = 7
    holder.Parent = row
    corner(holder, 15)
    stroke(holder, Color3.fromRGB(255, 220, 70), 1.5, 0.15)

    local skyHolderGrad = Instance.new("UIGradient")
    skyHolderGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    skyHolderGrad.Rotation = 18
    skyHolderGrad.Parent = holder
    _G._AmbitiousRegAccent(holder, skyHolderGrad, "pick")

    skyValueLabel = Instance.new("TextLabel")
    skyValueLabel.Name = "SkyValue"
    skyValueLabel.BackgroundTransparency = 1
    skyValueLabel.Text = skyTheme or "Off"
    skyValueLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    skyValueLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    skyValueLabel.TextStrokeTransparency = 0.22
    skyValueLabel.TextSize = 11
    skyValueLabel.Font = Enum.Font.GothamBlack
    skyValueLabel.TextXAlignment = Enum.TextXAlignment.Center
    skyValueLabel.Size = UDim2.new(1, 0, 1, 0)
    skyValueLabel.ZIndex = 9
    skyValueLabel.Parent = holder

    local openBtn = Instance.new("TextButton")
    openBtn.Name = "OpenSkyPicker"
    openBtn.BackgroundTransparency = 1
    openBtn.Text = ""
    openBtn.Size = UDim2.new(1, 0, 1, 0)
    openBtn.AutoButtonColor = false
    openBtn.ZIndex = 10
    openBtn.Parent = holder

    openBtn.MouseEnter:Connect(function()
      tween(holder, {Size = UDim2.new(0, 130, 0, 32), Position = UDim2.new(1, -135, 0.5, -16)}, 0.12)
    end)
    openBtn.MouseLeave:Connect(function()
      tween(holder, {Size = UDim2.new(0, 124, 0, 30), Position = UDim2.new(1, -132, 0.5, -15)}, 0.12)
    end)

    -- Usa SKY_PRESET_COLORS globale (definito nel blocco sky changer sopra)
    local function getSkyColor(name)
      local t = SKY_PRESET_COLORS and SKY_PRESET_COLORS[name]
      if t then return Color3.fromRGB(t[1], t[2], t[3]) end
      return Color3.fromRGB(128, 128, 128)
    end

    local skyPickerGui = nil

    local function closeSkyPicker()
      if skyPickerGui and skyPickerGui.Parent then
        local fadeTween = TweenService:Create(skyPickerGui.Frame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        fadeTween:Play()
        fadeTween.Completed:Connect(function()
          skyPickerGui:Destroy()
          skyPickerGui = nil
        end)
      end
    end

    openBtn.Activated:Connect(function()
      if skyPickerGui and skyPickerGui.Parent then
        closeSkyPicker()
        return
      end

      skyPickerGui = Instance.new("ScreenGui")
      skyPickerGui.Name = "AmbitiousHubSkyPicker"
      skyPickerGui.ResetOnSpawn = false
      skyPickerGui.IgnoreGuiInset = true
      skyPickerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
      skyPickerGui.DisplayOrder = 9999
      skyPickerGui.Parent = HubGui

      local backdrop = Instance.new("Frame")
      backdrop.Name = "Backdrop"
      backdrop.Size = UDim2.new(1, 0, 1, 0)
      backdrop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      backdrop.BackgroundTransparency = 0.45
      backdrop.BorderSizePixel = 0
      backdrop.ZIndex = 1
      backdrop.Parent = skyPickerGui

      local pickerFrame = Instance.new("Frame")
      pickerFrame.Name = "Frame"
      pickerFrame.Size = UDim2.new(0, 380, 0, 520)
      pickerFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
      pickerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      pickerFrame.BorderSizePixel = 0
      pickerFrame.ZIndex = 2
      pickerFrame.Parent = skyPickerGui
      corner(pickerFrame, 16)
      stroke(pickerFrame, Color3.fromRGB(0, 0, 0), 1.2, 0.3)

      local titleBar = Instance.new("Frame")
      titleBar.Name = "TitleBar"
      titleBar.Size = UDim2.new(1, 0, 0, 48)
      titleBar.Position = UDim2.new(0, 0, 0, 0)
      titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      titleBar.BackgroundTransparency = 0.15
      titleBar.BorderSizePixel = 0
      titleBar.ZIndex = 3
      titleBar.Parent = pickerFrame
      corner(titleBar, 16)

      local titleLabel = Instance.new("TextLabel")
      titleLabel.Name = "Title"
      titleLabel.Size = UDim2.new(1, -60, 1, 0)
      titleLabel.Position = UDim2.new(0, 18, 0, 0)
      titleLabel.BackgroundTransparency = 1
      titleLabel.Text = "SELECT SKY PRESET"
      titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
      titleLabel.Font = Enum.Font.GothamBlack
      titleLabel.TextSize = 16
      titleLabel.TextXAlignment = Enum.TextXAlignment.Left
      titleLabel.ZIndex = 4
      titleLabel.Parent = titleBar

      local closeBtn = Instance.new("TextButton")
      closeBtn.Name = "CloseBtn"
      closeBtn.Size = UDim2.new(0, 36, 0, 36)
      closeBtn.Position = UDim2.new(1, -44, 0, 6)
      closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      closeBtn.BackgroundTransparency = 0.1
      closeBtn.BorderSizePixel = 0
      closeBtn.Text = "X"
      closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
      closeBtn.Font = Enum.Font.GothamBlack
      closeBtn.TextSize = 14
      closeBtn.AutoButtonColor = false
      closeBtn.ZIndex = 4
      closeBtn.Parent = titleBar
      corner(closeBtn, 10)
      stroke(closeBtn, Color3.fromRGB(0, 0, 0), 1, 0.4)

      closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(255, 220, 70)}, 0.12)
      end)
      closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}, 0.12)
      end)
      closeBtn.Activated:Connect(closeSkyPicker)

      local scrollFrame = Instance.new("ScrollingFrame")
      scrollFrame.Name = "Scroll"
      scrollFrame.Size = UDim2.new(1, -16, 1, -64)
      scrollFrame.Position = UDim2.new(0, 8, 0, 56)
      scrollFrame.BackgroundTransparency = 1
      scrollFrame.BorderSizePixel = 0
      scrollFrame.ScrollBarThickness = 4
      scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 220, 70)
      scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
      scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
      scrollFrame.ZIndex = 3
      scrollFrame.Parent = pickerFrame

      local gridLayout = Instance.new("UIGridLayout")
      gridLayout.CellSize = UDim2.new(0, 108, 0, 108)
      gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
      gridLayout.FillDirection = Enum.FillDirection.Horizontal
      gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
      gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
      gridLayout.Parent = scrollFrame

      local skyGridPad = Instance.new("UIPadding", scrollFrame)
      skyGridPad.PaddingLeft = UDim.new(0, 8)
      skyGridPad.PaddingRight = UDim.new(0, 8)
      skyGridPad.PaddingTop = UDim.new(0, 8)
      skyGridPad.PaddingBottom = UDim.new(0, 8)

      for i, presetName in ipairs(SKY_PRESETS_LIST) do
        local presetBtn = Instance.new("TextButton")
        presetBtn.Name = "Preset_" .. presetName
        presetBtn.Size = UDim2.new(1, 0, 1, 0)
        presetBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        presetBtn.BackgroundTransparency = 0
        presetBtn.BorderSizePixel = 0
        presetBtn.Text = ""
        presetBtn.AutoButtonColor = false
        presetBtn.LayoutOrder = i
        presetBtn.ZIndex = 4
        presetBtn.ClipsDescendants = true
        presetBtn.Parent = scrollFrame
        corner(presetBtn, 18)

        local presetCol = getSkyColor(presetName)
        local isSelected = (skyTheme == presetName)

        -- Alone colorato: il colore del preset sfuma dal basso verso l'alto
        local cardGrad = Instance.new("UIGradient")
        cardGrad.Color = ColorSequence.new({
          ColorSequenceKeypoint.new(0, presetCol),
          ColorSequenceKeypoint.new(0.55, Color3.fromRGB(
            math.floor(presetCol.R * 110),
            math.floor(presetCol.G * 110),
            math.floor(presetCol.B * 110))),
          ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
        })
        cardGrad.Rotation = 90
        cardGrad.Parent = presetBtn

        local btnStroke = Instance.new("UIStroke")
        btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        btnStroke.Color = isSelected and Color3.fromRGB(255, 255, 255) or presetCol
        btnStroke.Thickness = isSelected and 2.4 or 1.2
        btnStroke.Transparency = isSelected and 0 or 0.55
        btnStroke.Parent = presetBtn

        local colorCircle = Instance.new("Frame")
        colorCircle.Name = "ColorCircle"
        colorCircle.Size = UDim2.new(0, 40, 0, 40)
        colorCircle.Position = UDim2.new(0.5, -20, 0, 18)
        colorCircle.BackgroundColor3 = presetCol
        colorCircle.BorderSizePixel = 0
        colorCircle.ZIndex = 5
        colorCircle.Parent = presetBtn
        Instance.new("UICorner", colorCircle).CornerRadius = UDim.new(0, 12)

        local circleGrad = Instance.new("UIGradient")
        if presetName == "Rainbow" then
          -- pallino sfumato, cosi' si capisce a colpo d'occhio cos'e'
          circleGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 220, 70)),
            ColorSequenceKeypoint.new(0.2,  Color3.fromRGB(255, 220, 70)),
            ColorSequenceKeypoint.new(0.4,  Color3.fromRGB(255, 220, 70)),
            ColorSequenceKeypoint.new(0.6,  Color3.fromRGB(255, 220, 70)),
            ColorSequenceKeypoint.new(0.8,  Color3.fromRGB(255, 220, 70)),
            ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 220, 70)),
          })
        else
        circleGrad.Color = ColorSequence.new({
          ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
          ColorSequenceKeypoint.new(0.45, presetCol),
          ColorSequenceKeypoint.new(1, presetCol),
        })
        end
        if presetName ~= "Rainbow" then
        circleGrad.Transparency = NumberSequence.new({
          NumberSequenceKeypoint.new(0, 0.55),
          NumberSequenceKeypoint.new(0.45, 0),
          NumberSequenceKeypoint.new(1, 0),
        })
        end
        circleGrad.Rotation = 125
        circleGrad.Parent = colorCircle

        local circleStroke = Instance.new("UIStroke")
        circleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        circleStroke.Color = Color3.fromRGB(255, 255, 255)
        circleStroke.Thickness = isSelected and 2 or 1.2
        circleStroke.Transparency = isSelected and 0.05 or 0.45
        circleStroke.Parent = colorCircle

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "Name"
        nameLabel.Size = UDim2.new(1, -8, 0, 24)
        nameLabel.Position = UDim2.new(0, 4, 1, -32)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = string.upper(presetName)
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.TextStrokeTransparency = 0.4
        nameLabel.Font = Enum.Font.GothamBlack
        nameLabel.TextSize = 10
        nameLabel.TextWrapped = true
        nameLabel.ZIndex = 6
        nameLabel.Parent = presetBtn

        presetBtn.MouseEnter:Connect(function()
          tween(btnStroke, {Transparency = 0, Thickness = 2.4}, 0.12)
          tween(colorCircle, {Size = UDim2.new(0, 46, 0, 46), Position = UDim2.new(0.5, -23, 0, 15)}, 0.12)
        end)
        presetBtn.MouseLeave:Connect(function()
          tween(btnStroke, {
            Transparency = isSelected and 0 or 0.55,
            Thickness = isSelected and 2.4 or 1.2
          }, 0.12)
          tween(colorCircle, {Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(0.5, -20, 0, 18)}, 0.12)
        end)

        presetBtn.Activated:Connect(function()
          skyTheme = presetName
          if skyValueLabel then skyValueLabel.Text = skyTheme end
          if applyCustomSky then applyCustomSky(skyTheme) end
          saveAmbitiousConfig()
          closeSkyPicker()
        end)
      end

      backdrop.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
          closeSkyPicker()
        end
      end)

      pickerFrame.Size = UDim2.new(0, 0, 0, 0)
      pickerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
      TweenService:Create(pickerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 520),
        Position = UDim2.new(0.5, -190, 0.5, -260)
      }):Play()
    end)

    return row
  end

  -- ===== JESUS MODE =====
  section(Utility, "JESUS", 0)
  do
    local row, setVisual = toggleRow(Utility, "Jesus Mode", _G.AmbitiousJesusMode.enabled, 0)
    _SV.setJesusModeVisual = setVisual
    local btn = row and row:FindFirstChild("ToggleButton")
    if btn then
      btn.Activated:Connect(function()
        _G.AmbitiousJesusMode.SetEnabled(not _G.AmbitiousJesusMode.enabled)
        if setVisual then setVisual(_G.AmbitiousJesusMode.enabled) end
        saveAmbitiousConfig()
      end)
    end
  end

  -- ===== ESP =====
  section(Utility, "ESP", 1)
  do
    -- ORDINE ESP: Show Tracker (2) -> Tracker Color (2, tendina) -> ESP (3) -> Ragdoll Countdown (3)
    local espRow, setESPVisual = toggleRow(Utility, "ESP", espEnabled, 3)
    _SV.setPlayerESPVisual = setESPVisual
    _ambitiousBtn = espRow and espRow:FindFirstChild("ToggleButton")
    if _ambitiousBtn then
      _ambitiousBtn.Activated:Connect(function()
        espEnabled = not espEnabled
        _G.AmbitiousESPOn = espEnabled   -- >>> ANTI VOID <<<
        if espEnabled then
          if startPlayerESP then startPlayerESP() end
          if BoxedESPOptions then BoxedESPOptions.box = true end
        else
          if stopPlayerESP then stopPlayerESP() end
          if BoxedESPOptions then BoxedESPOptions.box = false end
        end
        if refreshBoxedESP then refreshBoxedESP() end
        if setESPVisual then setESPVisual(espEnabled) end
        saveAmbitiousConfig()
      end)
    end
  end

  do
    local trackerRow, setTrackerVisual = toggleRow(Utility, "Show Tracker", showTrackerEnabled, 2)
    _SV.setTrackerESPVisual = setTrackerVisual
    _ambitiousBtn = trackerRow and trackerRow:FindFirstChild("ToggleButton")
    if _ambitiousBtn then
      _ambitiousBtn.Activated:Connect(function()
        showTrackerEnabled = not showTrackerEnabled
        if BoxedESPOptions then
          BoxedESPOptions.tracker = showTrackerEnabled
          -- NON toccare box qui
        end
        if refreshBoxedESP then refreshBoxedESP() end
        if setTrackerVisual then setTrackerVisual(showTrackerEnabled) end
        saveAmbitiousConfig()
      end)
    end
  end

  do
    -- Ordine 3 come il toggle ESP: creata dopo, finisce subito sotto di esso.
    local row, setVisual = _G.AmbitiousActionToggleRow(Utility, "Ragdoll Countdown", ragdollCountdownEnabled, 3)
    _SV.setRagdollCountdownVisual = setVisual
    _ambitiousBtn = row and row:FindFirstChild("ToggleButton")
    if _ambitiousBtn then
      _ambitiousBtn.Activated:Connect(function()
        ragdollCountdownEnabled = not ragdollCountdownEnabled
        if ragdollCountdownEnabled then
          hookRagdollCountdown(LP.Character)
          _G.AmbitiousStartEnemyRagdollCountdown()
        else
          stopRagdollCountdown()
          _G.AmbitiousStopEnemyRagdollCountdown()
        end
        if setVisual then setVisual(ragdollCountdownEnabled) end
        saveAmbitiousConfig()
      end)
    end
  end

  -- ===== PERFORMANCE (SOLO ANTI LAG) =====
  section(Utility, "PERFORMANCE", 7)
  do
    local row, setVisual = toggleRow(Utility, "Anti Lag", antiLagVisualEnabled, 9)
    _SV.setAntiLagVisual = setVisual
    _ambitiousBtn = row and row:FindFirstChild("ToggleButton")
    if _ambitiousBtn then
      _ambitiousBtn.Activated:Connect(function()
        if antiLagVisualEnabled then disableAntiLag() else enableAntiLag() end
        if setVisual then setVisual(antiLagVisualEnabled) end
        saveAmbitiousConfig()
      end)
    end
  end
  do
    -- Ordine 8: sopra Anti Lag (9), subito dopo la sezione PERFORMANCE (7).
    local row2, setVisual2 = toggleRow(Utility, "Vivid Graphics", vividGraphicsEnabled, 8)
    _SV.setVividGraphicsVisual = setVisual2

    local _vividToggleBtn = row2 and row2:FindFirstChild("ToggleButton")
    if _vividToggleBtn then
      _vividToggleBtn.Activated:Connect(function()
        if vividGraphicsEnabled then disableVividGraphics() else enableVividGraphics() end
        if setVisual2 then setVisual2(vividGraphicsEnabled) end
        saveAmbitiousConfig()
      end)
    end

    -- >>> VIVID CHANGER A TENDINA BEGIN
    -- Il PICK non sta piu' schiacciato a destra del toggle: la riga ha la
    -- freccetta (stile Infinite Jump) e aprendola compare "Vivid Graphics
    -- Changer" che ospita il bottone.
    local vividChangerRow = baseRow(Utility, "Vivid Graphics Changer", 8)
    vividChangerRow.Size = UDim2.new(1, -4, 0, 42)
    vividChangerRow.ClipsDescendants = true
    vividChangerRow.Visible = false

    do
      local vividExpanded = false
      local vividArrow = Instance.new("TextButton")
      vividArrow.Name = "VividChangerArrow"
      vividArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      vividArrow.BackgroundTransparency = 0.18
      vividArrow.BorderSizePixel = 0
      vividArrow.Size = UDim2.new(0, 28, 0, 24)
      vividArrow.Position = UDim2.new(1, -90, 0.5, -12)
      vividArrow.Text = "\u{25B2}"
      vividArrow.TextColor3 = Color3.fromRGB(0, 0, 0)
      vividArrow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      vividArrow.TextStrokeTransparency = 0.3
      vividArrow.TextSize = 15
      vividArrow.Font = Enum.Font.GothamBold
      vividArrow.AutoButtonColor = false
      vividArrow.ZIndex = 8
      vividArrow.Parent = row2
      corner(vividArrow, 7)
      stroke(vividArrow, COLORS.strokeSoft, 1, 0.45)
      vividArrow.Activated:Connect(function()
        vividExpanded = not vividExpanded
        _G._AmbitiousExpand(vividChangerRow, vividExpanded, 42, vividArrow)
      end)
    end
    -- <<< VIVID CHANGER A TENDINA END

    -- PICK button dentro la tendina
    local vividBtnHolder = Instance.new("Frame")
    vividBtnHolder.Name = "VividButtonHolder"
    vividBtnHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    vividBtnHolder.BackgroundTransparency = 0.28
    vividBtnHolder.BorderSizePixel = 0
    vividBtnHolder.Size = UDim2.new(0, 66, 0, 30)
    vividBtnHolder.Position = UDim2.new(1, -73, 0.5, -15)
    vividBtnHolder.ClipsDescendants = true
    vividBtnHolder.ZIndex = 9
    vividBtnHolder.Parent = vividChangerRow
    corner(vividBtnHolder, 15)
    stroke(vividBtnHolder, Color3.fromRGB(255, 220, 70), 1.5, 0.15)

    local vividPickGrad = Instance.new("UIGradient")
    vividPickGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    vividPickGrad.Rotation = 18
    vividPickGrad.Parent = vividBtnHolder
    _G._AmbitiousRegAccent(vividBtnHolder, vividPickGrad, "pick")

    local vividPickBtn = Instance.new("TextButton")
    vividPickBtn.Name = "VividPickBtn"
    vividPickBtn.BackgroundTransparency = 1
    vividPickBtn.Text = "PICK"
    vividPickBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    vividPickBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    vividPickBtn.TextStrokeTransparency = 0.3
    vividPickBtn.TextSize = 12
    vividPickBtn.Font = Enum.Font.GothamBlack
    vividPickBtn.TextXAlignment = Enum.TextXAlignment.Center
    vividPickBtn.Size = UDim2.new(1, 0, 1, 0)
    vividPickBtn.Position = UDim2.new(0, 0, 0, 0)
    vividPickBtn.BorderSizePixel = 0
    vividPickBtn.ZIndex = 10
    vividPickBtn.AutoButtonColor = false
    vividPickBtn.Parent = vividBtnHolder

    vividPickBtn.MouseEnter:Connect(function()
      tween(vividBtnHolder, {Size = UDim2.new(0, 72, 0, 32), Position = UDim2.new(1, -76, 0.5, -16)}, 0.12)
    end)
    vividPickBtn.MouseLeave:Connect(function()
      tween(vividBtnHolder, {Size = UDim2.new(0, 66, 0, 30), Position = UDim2.new(1, -73, 0.5, -15)}, 0.12)
    end)

    local function _closeVividPicker()
      if _G._AmbitiousVivid.pickerGui and _G._AmbitiousVivid.pickerGui.Parent then
        local fr = _G._AmbitiousVivid.pickerGui:FindFirstChild("Frame")
        if fr then
          TweenService:Create(fr, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
        task.delay(0.25, function()
          if _G._AmbitiousVivid.pickerGui and _G._AmbitiousVivid.pickerGui.Parent then
            _G._AmbitiousVivid.pickerGui:Destroy()
          end
          _G._AmbitiousVivid.pickerGui = nil
        end)
      end
    end

    local function _makeVividStepper(parent, labelText, getVal, setVal, minVal, maxVal, step, fmt, yPos)
      local stepFrame = Instance.new("Frame")
      stepFrame.Name = labelText
      stepFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      stepFrame.BackgroundTransparency = 0.1
      stepFrame.BorderSizePixel = 0
      stepFrame.Size = UDim2.new(1, -24, 0, 38)
      stepFrame.Position = UDim2.new(0, 12, 0, yPos)
      stepFrame.ZIndex = 4
      stepFrame.Parent = parent
      corner(stepFrame, 9)
      stroke(stepFrame, Color3.fromRGB(0, 0, 0), 1, 0.45)

      local lbl = Instance.new("TextLabel")
      lbl.BackgroundTransparency = 1
      lbl.Text = labelText
      lbl.TextColor3 = Color3.fromRGB(0, 0, 0)
      lbl.Font = Enum.Font.GothamBold
      lbl.TextSize = 13
      lbl.TextXAlignment = Enum.TextXAlignment.Left
      lbl.Position = UDim2.new(0, 10, 0, 0)
      lbl.Size = UDim2.new(1, -140, 1, 0)
      lbl.ZIndex = 5
      lbl.Parent = stepFrame

      local minusBtn = Instance.new("TextButton")
      minusBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      minusBtn.BackgroundTransparency = 0.05
      minusBtn.BorderSizePixel = 0
      minusBtn.Text = "-"
      minusBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
      minusBtn.TextSize = 15
      minusBtn.Font = Enum.Font.GothamBlack
      minusBtn.TextXAlignment = Enum.TextXAlignment.Center
      minusBtn.TextYAlignment = Enum.TextYAlignment.Center
      minusBtn.AutoButtonColor = false
      minusBtn.Size = UDim2.new(0, 26, 0, 24)
      minusBtn.Position = UDim2.new(1, -120, 0.5, -12)
      minusBtn.ZIndex = 6
      minusBtn.Parent = stepFrame
      corner(minusBtn, 7)
      stroke(minusBtn, Color3.fromRGB(0, 0, 0), 1, 0.5)

      local valLabel = Instance.new("TextLabel")
      valLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      valLabel.BackgroundTransparency = 0.0
      valLabel.BorderSizePixel = 0
      valLabel.Text = string.format(fmt, getVal())
      valLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
      valLabel.Font = Enum.Font.GothamBlack
      valLabel.TextSize = 12
      valLabel.TextXAlignment = Enum.TextXAlignment.Center
      valLabel.Size = UDim2.new(0, 46, 0, 24)
      valLabel.Position = UDim2.new(1, -88, 0.5, -12)
      valLabel.ZIndex = 6
      valLabel.Parent = stepFrame
      corner(valLabel, 7)
      stroke(valLabel, Color3.fromRGB(0, 0, 0), 1, 0.5)

      local plusBtn = Instance.new("TextButton")
      plusBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      plusBtn.BackgroundTransparency = 0.05
      plusBtn.BorderSizePixel = 0
      plusBtn.Text = "+"
      plusBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
      plusBtn.TextSize = 14
      plusBtn.Font = Enum.Font.GothamBold
      plusBtn.TextXAlignment = Enum.TextXAlignment.Center
      plusBtn.TextYAlignment = Enum.TextYAlignment.Center
      plusBtn.LineHeight = 0.85
      plusBtn.AutoButtonColor = false
      plusBtn.Size = UDim2.new(0, 26, 0, 24)
      plusBtn.Position = UDim2.new(1, -36, 0.5, -12)
      plusBtn.ZIndex = 6
      plusBtn.Parent = stepFrame
      corner(plusBtn, 7)
      stroke(plusBtn, Color3.fromRGB(0, 0, 0), 1, 0.5)

      local function applyVal(v)
        local prec = math.floor(1 / step + 0.5)
        local clamped = math.clamp(math.floor(v * prec + 0.5) / prec, minVal, maxVal)
        setVal(clamped)
        valLabel.Text = string.format(fmt, clamped)
      end

      minusBtn.MouseButton1Click:Connect(function() applyVal(getVal() - step) end)
      plusBtn.MouseButton1Click:Connect(function() applyVal(getVal() + step) end)
      for _, btn in ipairs({minusBtn, plusBtn}) do
        btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}, 0.1) end)
        btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}, 0.1) end)
      end
    end

    vividPickBtn.MouseButton1Click:Connect(function()
      if _G._AmbitiousVivid.pickerGui and _G._AmbitiousVivid.pickerGui.Parent then
        _closeVividPicker()
        return
      end

      _G._AmbitiousVivid.pickerGui = Instance.new("ScreenGui")
      _G._AmbitiousVivid.pickerGui.Name = "AmbitiousHubVividPicker"
      _G._AmbitiousVivid.pickerGui.ResetOnSpawn = false
      _G._AmbitiousVivid.pickerGui.IgnoreGuiInset = true
      _G._AmbitiousVivid.pickerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
      _G._AmbitiousVivid.pickerGui.DisplayOrder = 9999
      _G._AmbitiousVivid.pickerGui.Parent = HubGui

      local backdrop = Instance.new("Frame")
      backdrop.Name = "Backdrop"
      backdrop.Size = UDim2.new(1, 0, 1, 0)
      backdrop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      backdrop.BackgroundTransparency = 0.5
      backdrop.BorderSizePixel = 0
      backdrop.ZIndex = 1
      backdrop.Parent = _G._AmbitiousVivid.pickerGui

      local POPUP_H = 348
      local pickerFrame = Instance.new("Frame")
      pickerFrame.Name = "Frame"
      pickerFrame.Size = UDim2.new(0, 330, 0, POPUP_H)
      pickerFrame.Position = UDim2.new(0.5, -165, 0.5, -POPUP_H/2)
      pickerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      pickerFrame.BorderSizePixel = 0
      pickerFrame.ZIndex = 2
      pickerFrame.Parent = _G._AmbitiousVivid.pickerGui
      corner(pickerFrame, 16)
      stroke(pickerFrame, Color3.fromRGB(0, 0, 0), 1.2, 0.3)

      local titleBar = Instance.new("Frame")
      titleBar.Name = "TitleBar"
      titleBar.Size = UDim2.new(1, 0, 0, 48)
      titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      titleBar.BackgroundTransparency = 0.1
      titleBar.BorderSizePixel = 0
      titleBar.ZIndex = 3
      titleBar.Parent = pickerFrame
      corner(titleBar, 16)

      local titleLabel = Instance.new("TextLabel")
      titleLabel.Name = "Title"
      titleLabel.Size = UDim2.new(1, -60, 1, 0)
      titleLabel.Position = UDim2.new(0, 16, 0, 0)
      titleLabel.BackgroundTransparency = 1
      titleLabel.Text = "VIVID GRAPHICS CHANGER"
      titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
      titleLabel.Font = Enum.Font.GothamBlack
      titleLabel.TextSize = 13
      titleLabel.TextXAlignment = Enum.TextXAlignment.Left
      titleLabel.ZIndex = 4
      titleLabel.Parent = titleBar

      local closeBtn = Instance.new("TextButton")
      closeBtn.Name = "CloseBtn"
      closeBtn.Size = UDim2.new(0, 32, 0, 32)
      closeBtn.Position = UDim2.new(1, -40, 0, 8)
      closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      closeBtn.BorderSizePixel = 0
      closeBtn.Text = "X"
      closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
      closeBtn.Font = Enum.Font.GothamBlack
      closeBtn.TextSize = 13
      closeBtn.AutoButtonColor = false
      closeBtn.ZIndex = 4
      closeBtn.Parent = titleBar
      corner(closeBtn, 8)
      stroke(closeBtn, Color3.fromRGB(0, 0, 0), 1, 0.4)
      closeBtn.MouseEnter:Connect(function() tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(255, 220, 70)}, 0.12) end)
      closeBtn.MouseLeave:Connect(function() tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}, 0.12) end)
      closeBtn.Activated:Connect(_closeVividPicker)

      local contentStart = 56
      local stepSpacing = 50

      _makeVividStepper(pickerFrame, "Saturation", function() return _G._AmbitiousVivid.saturation end, function(v)
        _G._AmbitiousVivid.saturation = v
        if vividGraphicsEnabled then for _, c in ipairs(Lighting:GetChildren()) do if c:IsA("ColorCorrectionEffect") and c:GetAttribute("_AmbitiousVivid") then c.Saturation = v end end end
        saveAmbitiousConfig()
      end, 0, 2, 0.1, "%.1f", contentStart)

      _makeVividStepper(pickerFrame, "Bloom Intensity", function() return _G._AmbitiousVivid.bloomIntensity end, function(v)
        _G._AmbitiousVivid.bloomIntensity = v
        if vividGraphicsEnabled then for _, c in ipairs(Lighting:GetChildren()) do if c:IsA("BloomEffect") and c:GetAttribute("_AmbitiousVivid") then c.Intensity = v end end end
        saveAmbitiousConfig()
      end, 0, 3, 0.1, "%.1f", contentStart + stepSpacing)

      _makeVividStepper(pickerFrame, "Bloom Size", function() return _G._AmbitiousVivid.bloomSize end, function(v)
        _G._AmbitiousVivid.bloomSize = v
        if vividGraphicsEnabled then for _, c in ipairs(Lighting:GetChildren()) do if c:IsA("BloomEffect") and c:GetAttribute("_AmbitiousVivid") then c.Size = v end end end
        saveAmbitiousConfig()
      end, 1, 56, 1, "%.0f", contentStart + stepSpacing * 2)

      _makeVividStepper(pickerFrame, "Sun Rays", function() return _G._AmbitiousVivid.sunIntensity end, function(v)
        _G._AmbitiousVivid.sunIntensity = v
        if vividGraphicsEnabled then for _, c in ipairs(Lighting:GetChildren()) do if c:IsA("SunRaysEffect") and c:GetAttribute("_AmbitiousVivid") then c.Intensity = v end end end
        saveAmbitiousConfig()
      end, 0, 1, 0.05, "%.2f", contentStart + stepSpacing * 3)

      _makeVividStepper(pickerFrame, "DOF Focus Dist", function() return _G._AmbitiousVivid.dofFocus end, function(v)
        _G._AmbitiousVivid.dofFocus = v
        if vividGraphicsEnabled then for _, c in ipairs(Lighting:GetChildren()) do if c:IsA("DepthOfFieldEffect") and c:GetAttribute("_AmbitiousVivid") then c.FocusDistance = v end end end
        saveAmbitiousConfig()
      end, 1, 100, 1, "%.0f", contentStart + stepSpacing * 4)

      -- RESET TO DEFAULT footer
      local resetHolder = Instance.new("Frame")
      resetHolder.Name = "ResetHolder"
      resetHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      resetHolder.BackgroundTransparency = 0
      resetHolder.BorderSizePixel = 0
      resetHolder.Size = UDim2.new(1, -24, 0, 36)
      resetHolder.Position = UDim2.new(0, 12, 1, -45)
      resetHolder.ZIndex = 4
      resetHolder.Parent = pickerFrame
      corner(resetHolder, 18)
      stroke(resetHolder, Color3.fromRGB(255, 220, 70), 1.5, 0.15)

      local vividResetGrad = Instance.new("UIGradient")
      vividResetGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
      })
      vividResetGrad.Rotation = 18
      vividResetGrad.Parent = resetHolder
      _G._AmbitiousRegAccent(resetHolder, vividResetGrad, "button")

      local resetBtn = Instance.new("TextButton")
      resetBtn.Name = "ResetToDefault"
      resetBtn.BackgroundTransparency = 1
      resetBtn.Text = "RESET TO DEFAULT"
      resetBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
      resetBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      resetBtn.TextStrokeTransparency = 0.25
      resetBtn.TextSize = 12
      resetBtn.Font = Enum.Font.GothamBlack
      resetBtn.Size = UDim2.new(1, 0, 1, 0)
      resetBtn.Position = UDim2.new(0, 0, 0, 0)
      resetBtn.AutoButtonColor = false
      resetBtn.ZIndex = 5
      resetBtn.Parent = resetHolder
      local _vrStroke = resetHolder:FindFirstChildOfClass("UIStroke")
      resetBtn.MouseEnter:Connect(function()
        tween(resetHolder, {Size = UDim2.new(1, -18, 0, 38), Position = UDim2.new(0, 9, 1, -46)}, 0.12)
        if _vrStroke then tween(_vrStroke, {Transparency = 0, Thickness = 2.2}, 0.12) end
      end)
      resetBtn.MouseLeave:Connect(function()
        tween(resetHolder, {Size = UDim2.new(1, -24, 0, 36), Position = UDim2.new(0, 12, 1, -45)}, 0.12)
        if _vrStroke then tween(_vrStroke, {Transparency = 0.15, Thickness = 1.5}, 0.12) end
      end)
      resetBtn.MouseButton1Click:Connect(function()
        -- Ripristina valori di default
        _G._AmbitiousVivid.saturation = 0.6
        _G._AmbitiousVivid.bloomIntensity = 0.8
        _G._AmbitiousVivid.bloomSize = 24
        _G._AmbitiousVivid.sunIntensity = 0.2
        _G._AmbitiousVivid.dofFocus = 25
        -- Applica subito se vivid e' attivo
        if vividGraphicsEnabled then
          for _, c in ipairs(Lighting:GetChildren()) do
            if c:GetAttribute("_AmbitiousVivid") then
              if c:IsA("ColorCorrectionEffect") then c.Saturation = 0.6
              elseif c:IsA("BloomEffect") then c.Intensity = 0.8; c.Size = 24
              elseif c:IsA("SunRaysEffect") then c.Intensity = 0.2
              elseif c:IsA("DepthOfFieldEffect") then c.FocusDistance = 25 end
            end
          end
        end
        saveAmbitiousConfig()
        -- Chiudi e riapri il popup per aggiornare i valori mostrati
        _closeVividPicker()
        task.delay(0.28, function()
          if vividPickBtn and vividPickBtn.Parent then
            vividPickBtn.MouseButton1Click:Fire()
          end
        end)
      end)

      backdrop.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
          _closeVividPicker()
        end
      end)

      pickerFrame.Size = UDim2.new(0, 0, 0, 0)
      pickerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
      TweenService:Create(pickerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 330, 0, POPUP_H),
        Position = UDim2.new(0.5, -165, 0.5, -POPUP_H/2)
      }):Play()
    end)
  end
  do
    local rowXR, setVisualXR = toggleRow(Utility, "X-Ray", xrayEnabled, 10)
    _SV.setXRayVisual = setVisualXR
    local _xrBtn = rowXR and rowXR:FindFirstChild("ToggleButton")
    if _xrBtn then
      _xrBtn.Activated:Connect(function()
        xrayEnabled = not xrayEnabled
        pcall(setXRay, xrayEnabled)
        if setVisualXR then setVisualXR(xrayEnabled) end
        saveAmbitiousConfig()
      end)
    end
  end
  -- >>> BRAINROT X-RAY <<< riga subito sotto X-Ray
  do
    local rowBX, setVisualBX = toggleRow(Utility, "Brainrot X-Ray", _G.AmbitiousBrainrotXRayEnabled == true, 10)
    _SV.setBrainrotXRayVisual = setVisualBX
    local _bxBtn = rowBX and rowBX:FindFirstChild("ToggleButton")
    if _bxBtn then
      _bxBtn.Activated:Connect(function()
        local on = not (_G.AmbitiousBrainrotXRayEnabled == true)
        if _G.AmbitiousSetBrainrotXRay then _G.AmbitiousSetBrainrotXRay(on) end
        if setVisualBX then setVisualBX(on) end
        saveAmbitiousConfig()
      end)
    end
  end
  do
    -- LayoutOrder 8 come Vivid Graphics e la sua riga Changer, ma creata
    -- dopo: a parita' di ordine il UIListLayout rispetta l'inserimento,
    -- quindi finisce subito sotto quelle due e sopra Anti Lag (9).
    local rowKW, setVisualKW = toggleRow(Utility, "Kick Warning", _G._AmbitiousKickWarn.enabled, 8)
    _SV.setKickWarningVisual = setVisualKW

    -- ---- tendina con l'Ultimate Anti Kick ----
    local kwHolder = Instance.new("Frame")
    kwHolder.Name = "Kick Warning Options"
    kwHolder.BackgroundTransparency = 1
    kwHolder.Size = UDim2.new(1, 0, 0, 38)
    kwHolder.BorderSizePixel = 0
    kwHolder.LayoutOrder = 8
    kwHolder.ZIndex = 4
    kwHolder.ClipsDescendants = true
    kwHolder.Visible = false
    kwHolder.Parent = Utility

    -- Riga interna nello stesso stile delle sotto-righe dell'Avatar
    -- Changer: sfondo, bordo, hover e toggle uguali, senza PICK.
    local uakRow = Instance.new("Frame")
    uakRow.Name = "UltimateAntiKickRow"
    uakRow.BackgroundColor3 = COLORS.row
    uakRow.BackgroundTransparency = 0.3
    uakRow.Size = UDim2.new(1, -8, 0, 34)
    uakRow.Position = UDim2.new(0, 4, 0, 2)
    uakRow.BorderSizePixel = 0
    uakRow.ZIndex = 4
    uakRow.Parent = kwHolder
    corner(uakRow, 9)
    local uakStroke = stroke(uakRow, COLORS.strokeSoft, 1.15, 0.38)
    uakRow.MouseEnter:Connect(function() tween(uakRow, {BackgroundTransparency = 0.22}) end)
    uakRow.MouseLeave:Connect(function() tween(uakRow, {BackgroundTransparency = 0.3}) end)

    local uakLbl = Instance.new("TextLabel")
    uakLbl.BackgroundTransparency = 1
    uakLbl.Text = "Ultimate Anti Kick"
    uakLbl.TextColor3 = Color3.fromRGB(0, 0, 0)
    uakLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    uakLbl.TextStrokeTransparency = 0.25
    uakLbl.TextSize = 12
    uakLbl.Font = Enum.Font.GothamSemibold
    uakLbl.TextXAlignment = Enum.TextXAlignment.Left
    uakLbl.Position = UDim2.new(0, 12, 0, 0)
    uakLbl.Size = UDim2.new(1, -70, 1, 0)
    uakLbl.ZIndex = 5
    uakLbl.Parent = uakRow

    local uakTrack = Instance.new("Frame")
    uakTrack.Name = "Track"
    uakTrack.BackgroundColor3 = COLORS.toggleBg
    uakTrack.BackgroundTransparency = 0.12
    uakTrack.Size = UDim2.new(0, 44, 0, 22)
    uakTrack.Position = UDim2.new(1, -52, 0.5, -11)
    uakTrack.BorderSizePixel = 0
    uakTrack.ZIndex = 5
    uakTrack.Parent = uakRow
    corner(uakTrack, 11)
    local uakTrackStroke = stroke(uakTrack, COLORS.strokeSoft, 1.3, 0.4)

    local uakFill = Instance.new("Frame")
    uakFill.Name = "Fill"
    uakFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    uakFill.BackgroundTransparency = (_G.AmbitiousUAKEnabled == true) and 0 or 1
    uakFill.Size = UDim2.new(1, 0, 1, 0)
    uakFill.BorderSizePixel = 0
    uakFill.ZIndex = 5
    uakFill.Parent = uakTrack
    corner(uakFill, 11)
    local uakFillGrad = Instance.new("UIGradient")
    uakFillGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    uakFillGrad.Rotation = 18
    uakFillGrad.Parent = uakFill

    local uakKnob = Instance.new("Frame")
    uakKnob.Name = "Knob"
    uakKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    uakKnob.Size = UDim2.new(0, 16, 0, 16)
    uakKnob.Position = (_G.AmbitiousUAKEnabled == true)
      and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    uakKnob.BorderSizePixel = 0
    uakKnob.ZIndex = 7
    uakKnob.Parent = uakTrack
    corner(uakKnob, 999)
    local uakKnobStroke = Instance.new("UIStroke")
    uakKnobStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uakKnobStroke.Color = (_G.AmbitiousUAKEnabled == true)
      and Color3.fromRGB(255, 220, 70) or Color3.fromRGB(255, 220, 70)
    uakKnobStroke.Thickness = 1.4
    uakKnobStroke.Transparency = 0.15
    uakKnobStroke.Parent = uakKnob

    local uakShine = Instance.new("Frame")
    uakShine.BackgroundColor3 = COLORS.white
    uakShine.BackgroundTransparency = 0.55
    uakShine.Size = UDim2.new(1, -5, 0, 5)
    uakShine.Position = UDim2.new(0, 2.5, 0, 2.5)
    uakShine.BorderSizePixel = 0
    uakShine.ZIndex = 8
    uakShine.Parent = uakKnob
    corner(uakShine, 5)
    _G._AmbitiousRegAccent(uakFill, uakFillGrad, "toggle", uakTrack, uakKnob, uakRow)

    local function uakPaint(on)
      local onBg, onEdge = _G._AmbitiousToggleOnColor()
      tween(uakKnob, {Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)})
      tween(uakTrack, {
        BackgroundTransparency = on and 0 or 0.12,
        BackgroundColor3 = on and onBg or COLORS.toggleBg
      })
      tween(uakFill, {BackgroundTransparency = on and 0 or 1})
      tween(uakKnobStroke, {Color = on and onEdge or Color3.fromRGB(255, 220, 70)})
      tween(uakTrackStroke, {
        Color = on and onEdge or COLORS.strokeSoft,
        Transparency = on and 0 or 0.4,
        Thickness = 1.4
      })
      tween(uakStroke, {
        Color = on and onBg or COLORS.strokeSoft,
        Transparency = on and 0.08 or 0.38,
        Thickness = 1.25
      })
    end
    _G.AmbitiousRefreshUAKVisual = function()
      uakPaint(_G.AmbitiousUAKEnabled == true)
    end

    local uakBtn = Instance.new("TextButton")
    uakBtn.Name = "ToggleButton"
    uakBtn.BackgroundTransparency = 1
    uakBtn.Text = ""
    uakBtn.Size = UDim2.new(1, 0, 1, 0)
    uakBtn.AutoButtonColor = false
    uakBtn.ZIndex = 9
    uakBtn.Parent = uakRow
    uakBtn.Activated:Connect(function()
      _G.AmbitiousUAKEnabled = not (_G.AmbitiousUAKEnabled == true)
      -- Spento a muro alzato: va tolto subito, se no resti chiuso dentro
      -- fino alla scadenza del timer.
      if not _G.AmbitiousUAKEnabled and _G.AmbitiousUltimateAntiKick then
        pcall(_G.AmbitiousUltimateAntiKick.clear)
      end
      uakPaint(_G.AmbitiousUAKEnabled)
      saveAmbitiousConfig()
    end)
    uakPaint(_G.AmbitiousUAKEnabled == true)

    -- ---- freccetta sulla riga Kick Warning ----
    local kwArrow = Instance.new("TextButton")
    kwArrow.Name = "KickWarningArrow"
    kwArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    kwArrow.BackgroundTransparency = 0.18
    kwArrow.BorderSizePixel = 0
    kwArrow.Size = UDim2.new(0, 28, 0, 24)
    kwArrow.Position = UDim2.new(1, -90, 0.5, -12)
    kwArrow.Text = "\u{25B2}"
    kwArrow.TextColor3 = Color3.fromRGB(0, 0, 0)
    kwArrow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    kwArrow.TextStrokeTransparency = 0.3
    kwArrow.TextSize = 15
    kwArrow.Font = Enum.Font.GothamBold
    kwArrow.AutoButtonColor = false
    kwArrow.ZIndex = 8
    kwArrow.Parent = rowKW
    corner(kwArrow, 7)
    stroke(kwArrow, COLORS.strokeSoft, 1, 0.45)

    local kwExpanded = false
    kwArrow.Activated:Connect(function()
      kwExpanded = not kwExpanded
      _G._AmbitiousExpand(kwHolder, kwExpanded, 38, kwArrow)
    end)

    local _kwBtn = rowKW and rowKW:FindFirstChild("ToggleButton")
    if _kwBtn then
      _kwBtn.Activated:Connect(function()
        _G._AmbitiousKickWarn.enabled = not _G._AmbitiousKickWarn.enabled
        if not _G._AmbitiousKickWarn.enabled then
          if _G.AmbitiousDestroyKickWarning then _G.AmbitiousDestroyKickWarning() end
        else
          local _c = LP.Character
          local _h = _c and _c:FindFirstChildOfClass("Humanoid")
          _G._AmbitiousKickWarn.wasLow = (_h ~= nil) and (_h.WalkSpeed < 25) or false
        end
        if setVisualKW then setVisualKW(_G._AmbitiousKickWarn.enabled) end
        saveAmbitiousConfig()
      end)
    end
  end

  -- High Ping Warning subito sotto il Kick Warning e la sua tendina:
  -- stesso LayoutOrder 8, creata dopo.
  do
    local rowHPW, setVisualHPW = toggleRow(Utility, "High Ping Warning", highPingWarningEnabled, 8)
    _SV.setHighPingWarningVisual = setVisualHPW
    local _hpwBtn = rowHPW and rowHPW:FindFirstChild("ToggleButton")
    if _hpwBtn then
      _hpwBtn.Activated:Connect(function()
        highPingWarningEnabled = not highPingWarningEnabled
        if not highPingWarningEnabled then
          local existingWarning = HubGui:FindFirstChild("AmbitiousHubPingWarning")
          if existingWarning then pcall(function() existingWarning:Destroy() end) end
          _G._AmbitiousHPWNextAllowed = 0
        end
        if setVisualHPW then setVisualHPW(highPingWarningEnabled) end
        saveAmbitiousConfig()
      end)
    end
  end

  -- ===== ANIMATION PACKS =====
  section(Utility, "ANIMATION PACKS", 10)
  do
    -- >>> CUSTOM ANIM PACK BEGIN
    -- Settimo segmento: CUSTOM. Su due righe perche' a un settimo di riga
    -- "CUSTOM" per intero non ci sta, e rimpicciolire il testo lo avrebbe
    -- reso diverso da tutti gli altri.
    local PACK_LABELS = {"NONE", "1", "2", "3", "4", "5", "CUS\nTOM"}
    -- <<< CUSTOM ANIM PACK END
    local NUM_PACKS = #PACK_LABELS  -- 7

    -- Holder principale (occupa tutta la riga, come stretch rez)
    local animPackHolder = Instance.new("Frame")
    animPackHolder.Name = "Animation Pack Selector"
    animPackHolder.BackgroundColor3 = COLORS.row
    animPackHolder.BackgroundTransparency = 0.28
    animPackHolder.Size = UDim2.new(1, -4, 0, 42)
    animPackHolder.BorderSizePixel = 0
    -- LayoutOrder INTERO: e' un intero nella proprieta', e un 10.5 verrebbe
    -- arrotondato con l'ordine deciso dal nome. A parita' di ordine il nome
    -- decide, e "ANIMATION PACKS" < "Animation Pack Selector" <
    -- "Custom Animation Pack": esattamente l'ordine voluto.
    animPackHolder.LayoutOrder = 10
    animPackHolder.ZIndex = 4
    animPackHolder.ClipsDescendants = true
    animPackHolder.Parent = Utility
    corner(animPackHolder, 14)
    stroke(animPackHolder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
    _G._AmbitiousRegAccent(animPackHolder, nil, "soft")

    -- Slide indicator (si muove orizzontalmente)
    local animSlide = Instance.new("Frame")
    animSlide.Name = "AnimSlide"
    animSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    animSlide.BackgroundTransparency = 0.1
    animSlide.AnchorPoint = Vector2.new(0.5, 0.5)
    animSlide.Size = UDim2.new(1/NUM_PACKS, -4, 1, -8)
    animSlide.Position = UDim2.new(0.5/NUM_PACKS, 0, 0.5, 0)
    animSlide.BorderSizePixel = 0
    animSlide.ZIndex = 5
    animSlide.Parent = animPackHolder
    corner(animSlide, 13)
    local animSlideStroke = Instance.new("UIStroke")
    animSlideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    animSlideStroke.Color = Color3.fromRGB(255, 220, 70)
    animSlideStroke.Thickness = 1.5
    animSlideStroke.Transparency = 0.1
    animSlideStroke.Parent = animSlide
    local animSlideGrad = Instance.new("UIGradient")
    animSlideGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    animSlideGrad.Transparency = NumberSequence.new({
      NumberSequenceKeypoint.new(0, 0.08),
      NumberSequenceKeypoint.new(0.5, 0.02),
      NumberSequenceKeypoint.new(1, 0.08),
    })
    animSlideGrad.Parent = animSlide
    _G._AmbitiousRegAccent(animSlide, animSlideGrad, "slide")
    animSlideGrad.Rotation = 22

    -- Crea label e click per ogni bottone
    local animBtnLabels = {}
    local segW = 1 / NUM_PACKS
    for i, label in ipairs(PACK_LABELS) do
      local lbl = Instance.new("TextLabel")
      lbl.Name = "AnimPackLabel_" .. tostring(i)
      lbl.BackgroundTransparency = 1
      lbl.Text = label
      lbl.TextColor3 = Color3.fromRGB(0, 0, 0)
      lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      lbl.TextStrokeTransparency = 0.2
      lbl.TextSize = 10
      lbl.Font = Enum.Font.GothamBlack
      lbl.TextXAlignment = Enum.TextXAlignment.Center
      lbl.TextYAlignment = Enum.TextYAlignment.Center
      lbl.LineHeight = 0.92   -- le due righe di CUS/TOM restano compatte
      -- >>> CUSTOM ANIM PACK BEGIN
      -- Ancoraggio al CENTRO. Posizionando dal bordo sinistro, la posizione
      -- del riquadro e la sua meta' larghezza vengono arrotondate a intero
      -- separatamente, e i due errori si sommano in modo diverso da un
      -- segmento all'altro: e' per questo che un numero solo (il "5")
      -- risultava spostato di un pixel. Con AnchorPoint 0.5 il centro e'
      -- l'unica cosa calcolata, quindi c'e' UN solo arrotondamento e tutti
      -- i segmenti si comportano allo stesso modo.
      -- <<< CUSTOM ANIM PACK END
      lbl.AnchorPoint = Vector2.new(0.5, 0.5)
      lbl.Size = UDim2.new(segW, 0, 1, 0)
      lbl.Position = UDim2.new(segW * (i - 0.5), 0, 0.5, 0)
      lbl.ZIndex = 8
      lbl.Parent = animPackHolder
      animBtnLabels[i] = lbl

      local clickBtn = Instance.new("TextButton")
      clickBtn.Name = "AnimPackClick_" .. tostring(i)
      clickBtn.BackgroundTransparency = 1
      clickBtn.Text = ""
      clickBtn.AutoButtonColor = false
      clickBtn.AnchorPoint = Vector2.new(0.5, 0.5)
      clickBtn.Size = UDim2.new(segW, 0, 1, 0)
      clickBtn.Position = UDim2.new(segW * (i - 0.5), 0, 0.5, 0)
      clickBtn.ZIndex = 10
      clickBtn.Parent = animPackHolder
      local idx = i
      clickBtn.MouseButton1Click:Connect(function()
        if _G.AmbitiousSetAnimPack then _G.AmbitiousSetAnimPack(idx) end
      end)
    end

    -- Funzione che aggiorna la posizione dello slide e la trasparenza dei testi
    -- con velocitÃ  proporzionale alla distanza (come stretch rez)
    local function applyAnimPackVisual(index)
      index = math.clamp(tonumber(index) or 1, 1, NUM_PACKS)
      local segW_scalar = 1 / NUM_PACKS
      -- VelocitÃ  di transizione proporzionale alla distanza
      local prevIdx = selectedAnimPackIndex or 1
      local dist = math.abs(index - prevIdx)
      local tweenTime = (dist <= 1) and 0.18 or math.clamp(0.08 * dist + 0.10, 0.18, 0.42)
      -- >>> CUSTOM ANIM PACK BEGIN
      -- Geometria SIMMETRICA. Prima la pillola era spostata di -1 px e
      -- larga -3: il suo centro cadeva 2.5 px a sinistra del centro del
      -- segmento, mentre le label sono centrate sul segmento. Da qui il
      -- testo che sembra spinto a destra dentro la pillola (e sul primo
      -- segmento, con l'offset +4, spinto a sinistra).
      -- Con +2 di posizione e -4 di larghezza il centro della pillola
      -- coincide esattamente con quello della label, per ogni indice.
      -- Stesso centro delle label: concentrici per costruzione.
      tween(animSlide, {
        Position = UDim2.new(segW_scalar * (index - 0.5), 0, 0.5, 0),
        Size = UDim2.new(segW_scalar, -4, 1, -8),
      }, tweenTime)
      -- <<< CUSTOM ANIM PACK END
      for i, lbl in ipairs(animBtnLabels) do
        local isSelected = (i == index)
        tween(lbl, {
          TextTransparency = isSelected and 0 or 0.22,
          TextStrokeTransparency = isSelected and 0.2 or 0.45,
        }, 0.14)
      end
    end

    -- Esponi il visual callback al sistema logico
    setAnimPackVisual = applyAnimPackVisual

    -- Inizializza visuale con il valore caricato dal config
    applyAnimPackVisual(selectedAnimPackIndex or 1)
  end

  -- >>> CUSTOM ANIM PACK BEGIN
  -- ===== CUSTOM ANIMATION PACK ROW + PICKER =====
  ;(function()
    local SLOTS  = _G.AmbitiousCustomAnimSlots
    local LABELS = _G.AmbitiousCustomAnimLabels

    -- ---------- LA RIGA ----------
    local capRow = baseRow(Utility, "Custom Animation Pack", 10)
    capRow.Size = UDim2.new(1, -4, 0, 42)
    -- >>> VISIBILE SOLO CON CUSTOM <<<
    -- La riga serve solo quando e' selezionato il pack CUSTOM (indice 7).
    -- Compare e scompare con la stessa animazione a tendina delle freccette.
    capRow.ClipsDescendants = true
    capRow.Visible = false

    local capHolder = Instance.new("Frame")
    capHolder.Name = "CustomAnimBtnHolder"
    capHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    capHolder.BackgroundTransparency = 0.28
    capHolder.BorderSizePixel = 0
    capHolder.Size = UDim2.new(0, 66, 0, 30)
    capHolder.Position = UDim2.new(1, -73, 0.5, -15)
    capHolder.ClipsDescendants = true
    capHolder.ZIndex = 6
    capHolder.Parent = capRow
    corner(capHolder, 15)
    stroke(capHolder, Color3.fromRGB(255, 220, 70), 1.5, 0.15)

    local capGrad = Instance.new("UIGradient")
    capGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    capGrad.Rotation = 18
    capGrad.Parent = capHolder
    _G._AmbitiousRegAccent(capHolder, capGrad, "pick")

    local capBtn = Instance.new("TextButton")
    capBtn.Name = "CustomAnimButton"
    capBtn.BackgroundTransparency = 1
    capBtn.Text = "PICK"
    capBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    capBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    capBtn.TextStrokeTransparency = 0.3
    capBtn.TextSize = 12
    capBtn.Font = Enum.Font.GothamBlack
    capBtn.TextXAlignment = Enum.TextXAlignment.Center
    capBtn.Size = UDim2.new(1, 0, 1, 0)
    capBtn.Position = UDim2.new(0, 0, 0, 0)
    capBtn.BorderSizePixel = 0
    capBtn.ZIndex = 8
    capBtn.AutoButtonColor = false
    capBtn.Parent = capHolder
    capBtn.MouseEnter:Connect(function()
      tween(capHolder, {Size = UDim2.new(0, 72, 0, 32), Position = UDim2.new(1, -76, 0.5, -16)}, 0.12)
    end)
    capBtn.MouseLeave:Connect(function()
      tween(capHolder, {Size = UDim2.new(0, 66, 0, 30), Position = UDim2.new(1, -73, 0.5, -15)}, 0.12)
    end)

    -- Il contatore accanto al PICK e' stato tolto: quanti slot sono
    -- impostati si vede aprendo il picker, e nessun'altra riga della hub
    -- mostra un valore li'.
    local function refreshCount() end
    _G.AmbitiousCustomAnimRefreshRow = refreshCount

    -- >>> VISIBILE SOLO CON CUSTOM <<<
    -- animate = false allo start e al load config (deve solo trovarsi gia'
    -- nello stato giusto), true quando l'utente cambia pack.
    _G.AmbitiousCustomAnimSetRowVisible = function(show, animate)
      show = show and true or false
      if animate == false then
        capRow.Visible = show
        capRow.Size = UDim2.new(1, -4, 0, show and 42 or 0)
        return
      end
      if show then
        if capRow.Visible and capRow.Size.Y.Offset >= 42 then return end
        capRow.Visible = true
        capRow.Size = UDim2.new(1, -4, 0, 0)
        tween(capRow, {Size = UDim2.new(1, -4, 0, 42)}, 0.22)
      else
        if not capRow.Visible then return end
        tween(capRow, {Size = UDim2.new(1, -4, 0, 0)}, 0.18)
        task.delay(0.19, function()
          if capRow.Parent and capRow.Size.Y.Offset <= 1 then capRow.Visible = false end
        end)
      end
    end

    _G.AmbitiousCustomAnimSetRowVisible(selectedAnimPackIndex == 7, false)

    -- ---------- IL PICKER ----------
    local capGui = nil
    local cardRefs = {}
    -- Stessa guardia del Tab Position: il backdrop non assorbe il click,
    -- quindi senza questa il PICK richiuderebbe e riaprirebbe subito.
    local capJustClosedAt = 0

    -- Dissolvenza come gli altri picker, non rimpicciolimento.
    local function closeCap()
      if capGui and capGui.Parent then
        local f = capGui:FindFirstChild("Frame")
        if f then
          TweenService:Create(f, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
        local g = capGui
        capGui = nil
        cardRefs = {}
        capJustClosedAt = tick()
        task.delay(0.25, function() pcall(function() g:Destroy() end) end)
      end
    end
    _G.AmbitiousCustomAnimClose = closeCap

    -- Aggiorna una card dopo che l'ID e' stato messo o tolto.
    local function refreshCard(slot)
      local r = cardRefs[slot]
      if not r then return end
      local id = _G.AmbitiousCustomAnimIds[slot] or ""
      if id ~= "" then
        r.mark.Text = "\u{2713}"
        r.mark.TextSize = 18
        r.mark.TextColor3 = Color3.fromRGB(0, 0, 0)
        r.sub.Text = id
        r.sub.TextSize = 9
        r.sub.TextColor3 = Color3.fromRGB(0, 0, 0)
        r.stroke.Color = Color3.fromRGB(255, 220, 70)
        r.stroke.Thickness = 1.5
        r.stroke.Transparency = 0.12
        r.clear.Visible = true
      else
        r.mark.Text = "+"
        r.mark.TextSize = 24
        r.mark.TextColor3 = Color3.fromRGB(0, 0, 0)
        r.sub.Text = "ADD"
        r.sub.TextSize = 10
        r.sub.TextColor3 = Color3.fromRGB(0, 0, 0)
        r.stroke.Color = Color3.fromRGB(255, 220, 70)
        r.stroke.Thickness = 1
        r.stroke.Transparency = 0.5
        r.clear.Visible = false
      end
      refreshCount()
    end

    -- ---------- MINI POPUP ASSET ID ----------
    local function openAssetPopup(slot)
      if not capGui or not capGui.Parent then return end
      local pickerMain = capGui:FindFirstChild("Frame")
      if not pickerMain then return end

      local miniOverlay = Instance.new("Frame")
      miniOverlay.Name = "AddAnimMiniOverlay"
      miniOverlay.Size = UDim2.new(1, 0, 1, 0)
      miniOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      miniOverlay.BackgroundTransparency = 0.48
      miniOverlay.BorderSizePixel = 0
      miniOverlay.ZIndex = 100
      miniOverlay.Parent = pickerMain
      local oc = Instance.new("UICorner")
      oc.CornerRadius = UDim.new(0, 16)
      oc.Parent = miniOverlay

      local outsideClose = Instance.new("TextButton")
      outsideClose.Size = UDim2.new(1, 0, 1, 0)
      outsideClose.BackgroundTransparency = 1
      outsideClose.Text = ""
      outsideClose.AutoButtonColor = false
      outsideClose.ZIndex = 100
      outsideClose.Parent = miniOverlay
      outsideClose.MouseButton1Click:Connect(function() miniOverlay:Destroy() end)

      local miniPanel = Instance.new("Frame")
      miniPanel.Name = "AddAnimPanel"
      miniPanel.AnchorPoint = Vector2.new(0.5, 0.5)
      miniPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
      miniPanel.Size = UDim2.new(0, 300, 0, 158)
      miniPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      miniPanel.BorderSizePixel = 0
      miniPanel.ZIndex = 101
      miniPanel.ClipsDescendants = true
      miniPanel.Parent = miniOverlay
      corner(miniPanel, 16)
      stroke(miniPanel, COLORS.stroke, 1.1, 0.3)

      local mHeader = Instance.new("Frame")
      mHeader.Size = UDim2.new(1, 0, 0, 42)
      mHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      mHeader.BackgroundTransparency = 0.1
      mHeader.BorderSizePixel = 0
      mHeader.ZIndex = 102
      mHeader.Parent = miniPanel
      corner(mHeader, 16)

      local mTitle = Instance.new("TextLabel")
      mTitle.Size = UDim2.new(1, -52, 1, 0)
      mTitle.Position = UDim2.new(0, 14, 0, 0)
      mTitle.BackgroundTransparency = 1
      mTitle.Text = "ASSET ID  \u{2014}  " .. (LABELS[slot] or slot)
      mTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
      mTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      mTitle.TextStrokeTransparency = 0.3
      mTitle.Font = Enum.Font.GothamBlack
      mTitle.TextSize = 13
      mTitle.TextXAlignment = Enum.TextXAlignment.Left
      mTitle.ZIndex = 103
      mTitle.Parent = mHeader

      local mCloseBtn = Instance.new("TextButton")
      mCloseBtn.Size = UDim2.new(0, 28, 0, 28)
      mCloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
      mCloseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      mCloseBtn.BackgroundTransparency = 0.28
      mCloseBtn.BorderSizePixel = 0
      mCloseBtn.Text = "-"
      mCloseBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
      mCloseBtn.TextSize = 18
      mCloseBtn.Font = Enum.Font.GothamSemibold
      mCloseBtn.AutoButtonColor = false
      mCloseBtn.ZIndex = 104
      mCloseBtn.Parent = mHeader
      corner(mCloseBtn, 8)
      stroke(mCloseBtn, COLORS.stroke, 1, 0.35)
      mCloseBtn.MouseButton1Click:Connect(function() miniOverlay:Destroy() end)

      local mDivider = Instance.new("Frame")
      mDivider.Size = UDim2.new(1, -28, 0, 1)
      mDivider.Position = UDim2.new(0, 14, 0, 42)
      mDivider.BackgroundColor3 = Color3.fromRGB(255, 220, 70)
      mDivider.BackgroundTransparency = 0.45
      mDivider.BorderSizePixel = 0
      mDivider.ZIndex = 102
      mDivider.Parent = miniPanel

      local mBoxHolder = Instance.new("Frame")
      mBoxHolder.Size = UDim2.new(1, -24, 0, 36)
      mBoxHolder.Position = UDim2.new(0, 12, 0, 52)
      mBoxHolder.BackgroundColor3 = COLORS.row2
      mBoxHolder.BackgroundTransparency = 0.1
      mBoxHolder.BorderSizePixel = 0
      mBoxHolder.ZIndex = 102
      mBoxHolder.Parent = miniPanel
      corner(mBoxHolder, 9)
      stroke(mBoxHolder, COLORS.strokeSoft, 1, 0.38)

      local mBox = Instance.new("TextBox")
      mBox.Name = "AssetInput"
      mBox.Size = UDim2.new(1, -16, 1, 0)
      mBox.Position = UDim2.new(0, 8, 0, 0)
      mBox.BackgroundTransparency = 1
      mBox.BorderSizePixel = 0
      mBox.PlaceholderText = "Insert The Asset ID"
      mBox.PlaceholderColor3 = Color3.fromRGB(255, 220, 70)
      mBox.Text = _G.AmbitiousCustomAnimIds[slot] or ""
      mBox.TextColor3 = Color3.fromRGB(0, 0, 0)
      mBox.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      mBox.TextStrokeTransparency = 0.4
      mBox.Font = Enum.Font.GothamSemibold
      mBox.TextSize = 12
      mBox.ClearTextOnFocus = false
      mBox.ZIndex = 103
      mBox.Parent = mBoxHolder

      local mErr = Instance.new("TextLabel")
      mErr.Size = UDim2.new(1, -24, 0, 14)
      mErr.Position = UDim2.new(0, 12, 0, 94)
      mErr.BackgroundTransparency = 1
      mErr.Text = ""
      mErr.TextColor3 = Color3.fromRGB(0, 0, 0)
      mErr.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      mErr.TextStrokeTransparency = 0.4
      mErr.Font = Enum.Font.GothamSemibold
      mErr.TextSize = 10
      mErr.TextXAlignment = Enum.TextXAlignment.Left
      mErr.ZIndex = 102
      mErr.Parent = miniPanel

      local mConfirmHolder = Instance.new("Frame")
      mConfirmHolder.Size = UDim2.new(1, -24, 0, 32)
      mConfirmHolder.Position = UDim2.new(0, 12, 0, 114)
      mConfirmHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      mConfirmHolder.BackgroundTransparency = 0.28
      mConfirmHolder.BorderSizePixel = 0
      mConfirmHolder.ZIndex = 102
      mConfirmHolder.Parent = miniPanel
      corner(mConfirmHolder, 9)
      stroke(mConfirmHolder, Color3.fromRGB(255, 220, 70), 1, 0.28)

      local mConfirm = Instance.new("TextButton")
      mConfirm.Size = UDim2.new(1, 0, 1, 0)
      mConfirm.BackgroundTransparency = 1
      mConfirm.BorderSizePixel = 0
      mConfirm.Text = "CONFIRM"
      mConfirm.TextColor3 = Color3.fromRGB(0, 0, 0)
      mConfirm.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      mConfirm.TextStrokeTransparency = 0.22
      mConfirm.Font = Enum.Font.GothamBlack
      mConfirm.TextSize = 11
      mConfirm.AutoButtonColor = false
      mConfirm.ZIndex = 103
      mConfirm.Parent = mConfirmHolder
      mConfirm.MouseEnter:Connect(function()
        TweenService:Create(mConfirmHolder, TweenInfo.new(0.12), {BackgroundTransparency = 0.1}):Play()
      end)
      mConfirm.MouseLeave:Connect(function()
        TweenService:Create(mConfirmHolder, TweenInfo.new(0.12), {BackgroundTransparency = 0.28}):Play()
      end)

      local isChecking = false
      local function tryConfirm()
        if isChecking then return end
        local raw = mBox.Text:match("^%s*(.-)%s*$")
        if raw == "" then mErr.Text = "Invalid Asset Please Try Again" return end
        local assetId = raw:match("^(%d+)$") or raw:match("rbxassetid://(%d+)$")
        if not assetId then mErr.Text = "Invalid Asset Please Try Again" return end

        isChecking = true
        mErr.Text = ""
        mConfirm.Text = "CHECKING..."
        TweenService:Create(mConfirmHolder, TweenInfo.new(0.12), {BackgroundTransparency = 0.55}):Play()

        task.spawn(function()
          -- Validazione come Uranium: si scarica l'asset e si cerca dentro
          -- una Animation. Un ID che carica ma non contiene animazioni non
          -- va accettato, altrimenti il pack parte e non si muove niente.
          local url = "rbxassetid://" .. assetId
          local valid = false
          pcall(function()
            local objs = game:GetObjects(url)
            if objs then
              for _, obj in pairs(objs) do
                if obj:IsA("Animation") then valid = true return end
                local deep = obj:FindFirstChildWhichIsA("Animation", true)
                if deep then valid = true return end
              end
            end
          end)
          -- Ripiego: alcuni asset non tornano oggetti ma esistono davvero.
          if not valid then
            local tempImg = Instance.new("ImageLabel")
            tempImg.Image = url
            tempImg.Parent = miniOverlay
            local timeout = tick() + 4
            repeat task.wait(0.05) until tempImg.IsLoaded or tick() > timeout
            valid = tempImg.IsLoaded
            tempImg:Destroy()
          end

          if not miniOverlay or not miniOverlay.Parent then return end
          if valid then
            _G.AmbitiousCustomAnimIds[slot] = assetId
            refreshCard(slot)
            saveAmbitiousConfig()
            if _G.AmbitiousReloadCustomAnimPack then
              pcall(_G.AmbitiousReloadCustomAnimPack)
            end
            miniOverlay:Destroy()
          else
            isChecking = false
            mErr.Text = "Invalid Asset Please Try Again"
            mConfirm.Text = "CONFIRM"
            TweenService:Create(mConfirmHolder, TweenInfo.new(0.12), {BackgroundTransparency = 0.28}):Play()
          end
        end)
      end

      mConfirm.MouseButton1Click:Connect(tryConfirm)
      mBox.FocusLost:Connect(function(enter) if enter then tryConfirm() end end)
      task.delay(0.05, function() if mBox and mBox.Parent then mBox:CaptureFocus() end end)
    end

    -- ---------- APERTURA DEL PICKER ----------
    capBtn.Activated:Connect(function()
      if capGui and capGui.Parent then closeCap() return end
      if tick() - capJustClosedAt < 0.25 then return end

      capGui = Instance.new("ScreenGui")
      capGui.Name = "AmbitiousHubCustomAnimPicker"
      capGui.ResetOnSpawn = false
      capGui.IgnoreGuiInset = true
      capGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
      capGui.DisplayOrder = 9999
      capGui.Parent = HubGui

      local backdrop = Instance.new("Frame")
      backdrop.Name = "Backdrop"
      backdrop.Size = UDim2.new(1, 0, 1, 0)
      backdrop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      backdrop.BackgroundTransparency = 0.5
      backdrop.BorderSizePixel = 0
      backdrop.ZIndex = 1
      backdrop.Parent = capGui
      backdrop.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
          or input.UserInputType == Enum.UserInputType.Touch then closeCap() end
      end)

      local frame = Instance.new("Frame")
      frame.Name = "Frame"
      frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      frame.BorderSizePixel = 0
      frame.ZIndex = 2
      frame.Parent = capGui
      corner(frame, 16)
      stroke(frame, Color3.fromRGB(0, 0, 0), 1.2, 0.3)

      local titleBar = Instance.new("Frame")
      titleBar.Size = UDim2.new(1, 0, 0, 48)
      titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      titleBar.BackgroundTransparency = 0.15
      titleBar.BorderSizePixel = 0
      titleBar.ZIndex = 3
      titleBar.Parent = frame
      corner(titleBar, 16)

      local title = Instance.new("TextLabel")
      title.BackgroundTransparency = 1
      title.Text = "<font color=\"#FFD83D\">Gesu</font> <font color=\"#FFFFFF\">Hub</font>"
      title.TextColor3 = Color3.fromRGB(255, 255, 255)
      title.Font = Enum.Font.GothamBlack
      title.TextSize = 16
      title.TextXAlignment = Enum.TextXAlignment.Left
      title.Size = UDim2.new(1, -60, 1, 0)
      title.Position = UDim2.new(0, 18, 0, 0)
      title.ZIndex = 4
      title.Parent = titleBar

      -- Chiusura del popup GRANDE: X, come tutti gli altri picker della hub
      -- (Sky Theme, Music Player). Il "-" resta solo sul
      -- mini popup dell'Asset ID.
      local closeBtn = Instance.new("TextButton")
      closeBtn.Name = "CloseBtn"
      closeBtn.Size = UDim2.new(0, 36, 0, 36)
      closeBtn.Position = UDim2.new(1, -44, 0, 6)
      closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      closeBtn.BackgroundTransparency = 0.1
      closeBtn.BorderSizePixel = 0
      closeBtn.Text = "X"
      closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
      closeBtn.Font = Enum.Font.GothamBlack
      closeBtn.TextSize = 14
      closeBtn.AutoButtonColor = false
      closeBtn.ZIndex = 4
      closeBtn.Parent = titleBar
      corner(closeBtn, 10)
      stroke(closeBtn, Color3.fromRGB(0, 0, 0), 1, 0.4)
      closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(255, 220, 70)}):Play()
      end)
      closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
      end)
      closeBtn.Activated:Connect(closeCap)

      -- Contenuto dentro una ScrollingFrame, esattamente come il Background
      -- Changer: e' quella a dare a tutti i picker della hub lo stesso
      -- comportamento in apertura, perche' ritaglia da sola e il contenuto
      -- resta contenuto mentre il riquadro cresce.
      local scrollFrame = Instance.new("ScrollingFrame")
      scrollFrame.Name = "Scroll"
      scrollFrame.Size = UDim2.new(1, -16, 1, -64)
      scrollFrame.Position = UDim2.new(0, 8, 0, 56)
      scrollFrame.BackgroundTransparency = 1
      scrollFrame.BorderSizePixel = 0
      scrollFrame.ScrollBarThickness = 4
      scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 220, 70)
      scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
      scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
      scrollFrame.ZIndex = 3
      scrollFrame.Parent = frame

      local grid = Instance.new("UIGridLayout")
      grid.CellSize = UDim2.new(0, 165, 0, 76)
      grid.CellPadding = UDim2.new(0, 8, 0, 8)
      grid.FillDirection = Enum.FillDirection.Horizontal
      grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
      grid.SortOrder = Enum.SortOrder.LayoutOrder
      grid.Parent = scrollFrame

      local gridPad = Instance.new("UIPadding", scrollFrame)
      gridPad.PaddingLeft = UDim.new(0, 8)
      gridPad.PaddingTop = UDim.new(0, 8)
      gridPad.PaddingRight = UDim.new(0, 8)
      gridPad.PaddingBottom = UDim.new(0, 8)

      cardRefs = {}
      for i, slot in ipairs(SLOTS) do
        local card = Instance.new("TextButton")
        card.Name = slot
        card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        card.BorderSizePixel = 0
        card.Text = ""
        card.AutoButtonColor = false
        card.LayoutOrder = i
        card.ZIndex = 3
        card.Parent = scrollFrame
        corner(card, 12)
        local cs = stroke(card, Color3.fromRGB(255, 220, 70), 1, 0.5)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = LABELS[slot] or slot
        nameLbl.TextColor3 = Color3.fromRGB(0, 0, 0)
        nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLbl.TextStrokeTransparency = 0.3
        nameLbl.Font = Enum.Font.GothamBlack
        nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.Size = UDim2.new(1, -20, 0, 16)
        nameLbl.Position = UDim2.new(0, 12, 0, 8)
        nameLbl.ZIndex = 5
        nameLbl.Parent = card

        local mark = Instance.new("TextLabel")
        mark.BackgroundTransparency = 1
        mark.Font = Enum.Font.GothamBlack
        mark.TextXAlignment = Enum.TextXAlignment.Center
        mark.Size = UDim2.new(0, 30, 0, 30)
        mark.Position = UDim2.new(0, 10, 0, 30)
        mark.ZIndex = 5
        mark.Parent = card

        local sub = Instance.new("TextLabel")
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.GothamSemibold
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.TextTruncate = Enum.TextTruncate.AtEnd
        sub.Size = UDim2.new(1, -78, 0, 30)
        sub.Position = UDim2.new(0, 42, 0, 30)
        sub.ZIndex = 5
        sub.Parent = card

        -- X identica a quella delle miniature: una "X"
        -- maiuscola normale, non il simbolo Unicode. GothamBlack non ha il
        -- glifo U+2715 e Roblox al suo posto disegna il rettangolo del
        -- carattere mancante.
        local clear = Instance.new("TextButton")
        clear.Name = "Clear"
        clear.Size = UDim2.new(0, 22, 0, 22)
        clear.Position = UDim2.new(1, -26, 0, 5)
        clear.BackgroundTransparency = 1
        clear.BorderSizePixel = 0
        clear.Text = "X"
        clear.TextColor3 = Color3.fromRGB(0, 0, 0)
        clear.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        clear.TextStrokeTransparency = 0
        clear.Font = Enum.Font.GothamBlack
        clear.TextSize = 14
        clear.AutoButtonColor = false
        clear.Visible = false
        clear.ZIndex = 9
        clear.Parent = card
        clear.MouseEnter:Connect(function()
          TweenService:Create(clear, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255, 220, 70)}):Play()
        end)
        clear.MouseLeave:Connect(function()
          TweenService:Create(clear, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255, 220, 70)}):Play()
        end)
        clear.MouseButton1Click:Connect(function()
          _G.AmbitiousCustomAnimIds[slot] = ""
          refreshCard(slot)
          saveAmbitiousConfig()
          if _G.AmbitiousReloadCustomAnimPack then
            pcall(_G.AmbitiousReloadCustomAnimPack)
          end
        end)

        card.MouseEnter:Connect(function()
          tween(card, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}, 0.12)
        end)
        card.MouseLeave:Connect(function()
          tween(card, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}, 0.12)
        end)
        card.Activated:Connect(function() openAssetPopup(slot) end)

        cardRefs[slot] = {mark = mark, sub = sub, stroke = cs, clear = clear}
        refreshCard(slot)
      end

      frame.Size = UDim2.new(0, 0, 0, 0)
      frame.Position = UDim2.new(0.5, 0, 0.5, 0)
      TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 336),
        Position = UDim2.new(0.5, -190, 0.5, -168)
      }):Play()
    end)
  end)()
  -- <<< CUSTOM ANIM PACK END

  -- ===== AVATAR (HEADLESS, KORBLOX) =====
  section(Utility, "AVATAR", 11)


  do
    local rowH, setVisualH = toggleRow(Utility, "Enable Headless", headlessEnabled, 12)
    _SV.setHeadlessVisual = setVisualH
    local _headlessBtn = rowH and rowH:FindFirstChild("ToggleButton")
    if _headlessBtn then
      _headlessBtn.Activated:Connect(function()
        if headlessEnabled then disableHeadless() else enableHeadless() end
        if setVisualH then setVisualH(headlessEnabled) end
        saveAmbitiousConfig()
      end)
    end
  end
  do
    local rowK, setVisualK = toggleRow(Utility, "Enable Korblox", korbloxEnabled, 12)
    _SV.setKorbloxVisual = setVisualK
    local _korbloxBtn = rowK and rowK:FindFirstChild("ToggleButton")
    if _korbloxBtn then
      _korbloxBtn.Activated:Connect(function()
        if korbloxEnabled then disableKorblox() else enableKorblox() end
        if setVisualK then setVisualK(korbloxEnabled) end
        saveAmbitiousConfig()
      end)
    end
  end

  -- ===== TOOLS (TRANSPARENT) =====
  section(Utility, "TOOLS", 12)


  do
    local rowTT, setVisualTT = toggleRow(Utility, "Transparent Tools", _G.AmbitiousTransparentToolsEnabled == true, 12)
    _SV.setTransparentToolsVisual = setVisualTT
    local btn = rowTT and rowTT:FindFirstChild("ToggleButton")
    if btn then
      btn.Activated:Connect(function()
        local on = not (_G.AmbitiousTransparentToolsEnabled == true)
        if _G.AmbitiousTransparentTools then _G.AmbitiousTransparentTools.setEnabled(on) end
        if setVisualTT then setVisualTT(on) end
        saveAmbitiousConfig()
      end)
    end
  end

-- ===== CAMERA (STRETCH REZ, FOV, FOV VALUE, NO CAM COLLISION) =====
section(Utility, "CAMERA", 13)

-- >>> STRETCH REZ: toggle + tendina BEGIN
-- Il toggle decide se lo stretch e' attivo: spento significa X1, acceso
-- applica il valore scelto nella tendina. La freccetta (stile Infinite Jump)
-- apre lo slider con SOLO i tre valori veri: X1.5, X2, X3 â€” X1 non e' piu'
-- un'opzione della lista, e' semplicemente "toggle spento".
do
    local STRETCH_PICKS = { {idx = 2, name = "X1.5"}, {idx = 3, name = "X2"}, {idx = 4, name = "X3"} }
    local SEG_N = #STRETCH_PICKS

    -- Valore scelto quando il toggle e' acceso (indice dentro stretchPresetOrder)
    _G.AmbitiousStretchPick = _G.AmbitiousStretchPick
        or ((stretchCurrentIndex and stretchCurrentIndex > 1) and stretchCurrentIndex or 2)

    local row, setStretchVisual = toggleRow(Utility, "Stretch Rez", stretchEnabled == true, 14)

    -- ---------- tendina con i tre valori ----------
    local segHolder = Instance.new("Frame")
    segHolder.Name = "Stretch Rez Options"
    segHolder.BackgroundColor3 = COLORS.row
    segHolder.BackgroundTransparency = 0.28
    segHolder.Size = UDim2.new(1, -4, 0, 42)
    segHolder.BorderSizePixel = 0
    segHolder.LayoutOrder = 14
    segHolder.ZIndex = 4
    segHolder.ClipsDescendants = true
    segHolder.Visible = false
    segHolder.Parent = Utility
    corner(segHolder, 14)
    stroke(segHolder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
    _G._AmbitiousRegAccent(segHolder, nil, "soft")

    local segSlide = Instance.new("Frame")
    segSlide.Name = "SelectedSlide"
    segSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    segSlide.BackgroundTransparency = 0.1
    segSlide.AnchorPoint = Vector2.new(0.5, 0.5)
    segSlide.Size = UDim2.new(1 / SEG_N, -4, 1, -8)
    segSlide.Position = UDim2.new(0.5 / SEG_N, 0, 0.5, 0)
    segSlide.BorderSizePixel = 0
    segSlide.ZIndex = 5
    segSlide.Parent = segHolder
    corner(segSlide, 13)
    local segSlideStroke = Instance.new("UIStroke")
    segSlideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    segSlideStroke.Color = Color3.fromRGB(255, 220, 70)
    segSlideStroke.Thickness = 1.5
    segSlideStroke.Transparency = 0.1
    segSlideStroke.Parent = segSlide
    local segSlideGrad = Instance.new("UIGradient")
    segSlideGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    segSlideGrad.Rotation = 22
    segSlideGrad.Parent = segSlide
    _G._AmbitiousRegAccent(segSlide, segSlideGrad, "slide")

    local segLabels = {}
    local segW = 1 / SEG_N
    for i, p in ipairs(STRETCH_PICKS) do
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Text = p.name
        lbl.TextColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextStrokeTransparency = 0.2
        lbl.TextSize = 11
        lbl.Font = Enum.Font.GothamBlack
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Size = UDim2.new(segW, 0, 1, 0)
        lbl.Position = UDim2.new(segW * (i - 0.5), 0, 0.5, 0)
        lbl.ZIndex = 8
        lbl.Parent = segHolder
        segLabels[i] = lbl

        local clk = Instance.new("TextButton")
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.AnchorPoint = Vector2.new(0.5, 0.5)
        clk.Size = UDim2.new(segW, 0, 1, 0)
        clk.Position = UDim2.new(segW * (i - 0.5), 0, 0.5, 0)
        clk.ZIndex = 10
        clk.Parent = segHolder
        local picked = p.idx
        clk.MouseButton1Click:Connect(function()
            _G.AmbitiousStretchPick = picked
            -- Se il toggle e' acceso il nuovo valore parte subito;
            -- se e' spento resta memorizzato per la prossima accensione.
            if stretchEnabled then applyStretchPreset(picked) end
            if _G.AmbitiousRefreshStretchSelector then _G.AmbitiousRefreshStretchSelector() end
            saveAmbitiousConfig()
        end)
    end

    local function refreshStretchSelector()
        -- Quale segmento evidenziare: quello scelto, non stretchCurrentIndex,
        -- che a toggle spento vale 1 e non corrisponde a nessun segmento.
        local pick = _G.AmbitiousStretchPick or 2
        local segIdx = 1
        for i, p in ipairs(STRETCH_PICKS) do
            if p.idx == pick then segIdx = i break end
        end
        tween(segSlide, {
            Position = UDim2.new(segW * (segIdx - 0.5), 0, 0.5, 0),
            Size = UDim2.new(segW, -4, 1, -8),
        }, 0.18)
        for i, lbl in ipairs(segLabels) do
            tween(lbl, {
                TextTransparency = (i == segIdx) and 0 or 0.45,
                TextStrokeTransparency = (i == segIdx) and 0.2 or 0.45,
            }, 0.14)
        end
        if setStretchVisual then pcall(setStretchVisual, stretchEnabled == true) end
    end
    _G.AmbitiousRefreshStretchSelector = refreshStretchSelector

    local sBtn = row and row:FindFirstChild("ToggleButton")
    if sBtn then
        sBtn.Activated:Connect(function()
            if stretchEnabled then
                applyStretchPreset(1)                       -- spento = X1
            else
                applyStretchPreset(_G.AmbitiousStretchPick or 2)
            end
            refreshStretchSelector()
            saveAmbitiousConfig()
        end)
    end

    local sArrow = Instance.new("TextButton")
    sArrow.Name = "StretchRezArrow"
    sArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sArrow.BackgroundTransparency = 0.18
    sArrow.BorderSizePixel = 0
    sArrow.Size = UDim2.new(0, 28, 0, 24)
    sArrow.Position = UDim2.new(1, -90, 0.5, -12)
    sArrow.Text = "\u{25B2}"
    sArrow.TextColor3 = Color3.fromRGB(0, 0, 0)
    sArrow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    sArrow.TextStrokeTransparency = 0.3
    sArrow.TextSize = 15
    sArrow.Font = Enum.Font.GothamBold
    sArrow.AutoButtonColor = false
    sArrow.ZIndex = 8
    sArrow.Parent = row
    corner(sArrow, 7)
    stroke(sArrow, COLORS.strokeSoft, 1, 0.45)

    local sExpanded = false
    sArrow.Activated:Connect(function()
        sExpanded = not sExpanded
        _G._AmbitiousExpand(segHolder, sExpanded, 42, sArrow)
    end)

    refreshStretchSelector()
end
-- <<< STRETCH REZ: toggle + tendina END

-- ===== MOTION BLUR =====
do
    local function _startMotionBlur()
        if _motionBlurConn then pcall(function() _motionBlurConn:Disconnect() end); _motionBlurConn = nil end
        -- Crea o recupera il BlurEffect in Lighting
        if not _motionBlurEffect or not _motionBlurEffect.Parent then
            _motionBlurEffect = Lighting:FindFirstChildOfClass("BlurEffect")
            if not _motionBlurEffect then
                _motionBlurEffect = Instance.new("BlurEffect")
                _motionBlurEffect.Name = "AmbitiousMotionBlur"
            end
        end
        _motionBlurEffect.Size = 0
        _motionBlurEffect.Enabled = true
        _motionBlurEffect.Parent = Lighting
        local camera = Workspace.CurrentCamera
        local lastCFrame = camera.CFrame
        _motionBlurCurrentValue = 0
        _motionBlurConn = RunService.RenderStepped:Connect(function(deltaTime)
            if not motionBlurEnabled then
                if _motionBlurConn then pcall(function() _motionBlurConn:Disconnect() end); _motionBlurConn = nil end
                if _motionBlurEffect and _motionBlurEffect.Parent then
                    _motionBlurEffect.Size = 0
                    _motionBlurEffect.Enabled = false
                end
                return
            end
            local cam = Workspace.CurrentCamera
            if not cam then return end
            local currentCF = cam.CFrame
            local dot = currentCF.LookVector:Dot(lastCFrame.LookVector)
            local angleRad = math.acos(math.clamp(dot, -1, 1))
            local angleDeg = math.deg(angleRad)
            local speed = angleDeg * 20
            local targetBlur = math.min(speed, 7)
            _motionBlurCurrentValue = _motionBlurCurrentValue + (targetBlur - _motionBlurCurrentValue) * math.min(1, deltaTime * 10)
            if _motionBlurEffect and _motionBlurEffect.Parent then
                _motionBlurEffect.Size = _motionBlurCurrentValue
            end
            lastCFrame = currentCF
        end)
    end

    local function _stopMotionBlur()
        if _motionBlurConn then pcall(function() _motionBlurConn:Disconnect() end); _motionBlurConn = nil end
        if _motionBlurEffect and _motionBlurEffect.Parent then
            _motionBlurEffect.Size = 0
            _motionBlurEffect.Enabled = false
        end
        _motionBlurCurrentValue = 0
    end

    local row, setVisual = toggleRow(Utility, "Motion Blur", motionBlurEnabled, 15)
    _SV.setMotionBlurVisual = setVisual
    local _mblurBtn = row and row:FindFirstChild("ToggleButton")
    if _mblurBtn then
        _mblurBtn.Activated:Connect(function()
            motionBlurEnabled = not motionBlurEnabled
            if motionBlurEnabled then
                _startMotionBlur()
            else
                _stopMotionBlur()
            end
            if setVisual then setVisual(motionBlurEnabled) end
            saveAmbitiousConfig()
        end)
    end

    -- Ripristina lo stato al load
    if motionBlurEnabled then
        _startMotionBlur()
    end
end

-- ORDINE CAMERA: Stretch Rez (14) -> FOV (14) -> Motion Blur (15) -> No Cam Collision (16)
do
    local row, setVisual = toggleRow(Utility, "No Cam Collision", noCamCollisionEnabled, 16)
    _SV.setNoCamCollisionVisual = setVisual
    _ambitiousBtn = row and row:FindFirstChild("ToggleButton")
    if _ambitiousBtn then
        _ambitiousBtn.Activated:Connect(function()
            if noCamCollisionEnabled then disableNoCamCollision() else enableNoCamCollision() end
            if setVisual then setVisual(noCamCollisionEnabled) end
            saveAmbitiousConfig()
        end)
    end
end

-- >>> FOV VALUE ARROW BEGIN
-- Il vecchio textboxRow "FOV Value" e' stato tolto: ora il valore sta
-- dentro una tendina aperta dalla freccetta sulla riga FOV, esattamente
-- come il raggio del Look At Enemy.
do
    local fovExpanded = false

    -- Ordine 14 come lo Stretch Rez: creata dopo, finisce subito sotto di esso.
    local row, setVisual = toggleRow(Utility, "FOV", fovEnabled, 14)
    _SV.setFOVVisual = setVisual
    _ambitiousBtn = row and row:FindFirstChild("ToggleButton")
    if _ambitiousBtn then
        _ambitiousBtn.Activated:Connect(function()
            if fovEnabled then disableCustomFov() else enableCustomFov() end
            if setVisual then setVisual(fovEnabled) end
            saveAmbitiousConfig()
        end)
    end

    local fovArrow = Instance.new("TextButton")
    fovArrow.Name = "FOVArrow"
    fovArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fovArrow.BackgroundTransparency = 0.18
    fovArrow.BorderSizePixel = 0
    fovArrow.Size = UDim2.new(0, 28, 0, 24)
    fovArrow.Position = UDim2.new(1, -90, 0.5, -12)
    fovArrow.Text = "\u{25B2}"
    fovArrow.TextColor3 = Color3.fromRGB(0, 0, 0)
    fovArrow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    fovArrow.TextStrokeTransparency = 0.3
    fovArrow.TextSize = 15
    fovArrow.Font = Enum.Font.GothamBold
    fovArrow.AutoButtonColor = false
    fovArrow.ZIndex = 8
    fovArrow.Parent = row
    corner(fovArrow, 7)
    stroke(fovArrow, COLORS.strokeSoft, 1, 0.45)

    local fovHolder = Instance.new("Frame")
    fovHolder.Name = "FOV Value Holder"
    fovHolder.BackgroundColor3 = COLORS.row
    fovHolder.BackgroundTransparency = 0.28
    fovHolder.Size = UDim2.new(1, -4, 0, 42)
    fovHolder.BorderSizePixel = 0
    fovHolder.LayoutOrder = 14
    fovHolder.ZIndex = 4
    fovHolder.ClipsDescendants = true
    fovHolder.Visible = false
    fovHolder.Parent = Utility
    corner(fovHolder, 14)
    stroke(fovHolder, Color3.fromRGB(255, 220, 70), 1.4, 0.32)
    _G._AmbitiousRegAccent(fovHolder, nil, "soft")

    local fovLabel = Instance.new("TextLabel")
    fovLabel.Name = "Label"
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = "FOV Value"
    fovLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    fovLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    fovLabel.TextStrokeTransparency = 0.25
    fovLabel.TextSize = 11
    fovLabel.Font = Enum.Font.GothamSemibold
    fovLabel.TextXAlignment = Enum.TextXAlignment.Left
    fovLabel.Size = UDim2.new(0.55, 0, 1, 0)
    fovLabel.Position = UDim2.new(0, 12, 0, 0)
    fovLabel.ZIndex = 8
    fovLabel.Parent = fovHolder

    local fovBox = Instance.new("TextBox")
    fovBox.Name = "FOVValueBox"
    fovBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fovBox.BackgroundTransparency = 0.18
    fovBox.Text = tostring(fovValue)
    fovBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    fovBox.TextSize = 12
    fovBox.Font = Enum.Font.GothamSemibold
    fovBox.ClearTextOnFocus = false
    fovBox.Size = UDim2.new(0, 58, 0, 24)
    fovBox.Position = UDim2.new(1, -68, 0.5, -12)
    fovBox.BorderSizePixel = 0
    fovBox.ZIndex = 6
    fovBox.Parent = fovHolder
    corner(fovBox, 7)
    stroke(fovBox, COLORS.strokeSoft, 1, 0.45)

    -- Bridge per Reset All Settings / load config
    _G.AmbitiousFovValueBox = fovBox
    _G.AmbitiousRefreshFovValueBox = function()
        pcall(function() fovBox.Text = tostring(fovValue) end)
    end

    fovBox.FocusLost:Connect(function()
        local v = tonumber(fovBox.Text)
        if v and v >= 30 and v <= 120 then
            fovValue = v
            if fovEnabled and workspace.CurrentCamera then
                workspace.CurrentCamera.FieldOfView = fovValue
            end
        end
        fovBox.Text = tostring(fovValue)
        saveAmbitiousConfig()
    end)

    fovArrow.Activated:Connect(function()
        fovExpanded = not fovExpanded
        _G._AmbitiousExpand(fovHolder, fovExpanded, 42, fovArrow)
    end)
end
-- <<< FOV VALUE ARROW END

end -- chiude __AmbitiousDuelsSetupVisualsUI

-- ============================================================
-- SETTINGS PAGE
-- ============================================================
Settings = pages.SETTINGS
-- Settings resta la pagina completa di Roma Hub e parte sempre dalla cima.
-- Questo evita che, con la shell Yout, la pagina venga mostrata gia' scorsa.
Settings.CanvasPosition = Vector2.new(0, 0)
Settings.AutomaticCanvasSize = Enum.AutomaticSize.Y
Settings.ScrollingDirection = Enum.ScrollingDirection.Y
Settings.ScrollBarThickness = 4
Settings.ScrollBarImageTransparency = 0.05
Settings.ScrollBarImageColor3 = COLORS.stroke
Settings.ZIndex = 4
pcall(function()
  local oldHeader = Settings:FindFirstChild("RomaSettingsHeader")
  if oldHeader then oldHeader:Destroy() end
end)

ambitiousGuiScaleValue = tonumber(savedConfig.ambitiousGuiScaleValue) or 0.75
ambitiousGuiScaleValue = math.clamp(tonumber(ambitiousGuiScaleValue) or 0.50, 0.50, 1.50)
ambitiousProgressBarScaleValue = tonumber(savedConfig.ambitiousProgressBarScaleValue) or 0.85
ambitiousMainScale = Main:FindFirstChild("AmbitiousMainScale") or Instance.new("UIScale")
ambitiousMainScale.Name = "AmbitiousMainScale"
ambitiousMainScale.Scale = ambitiousGuiScaleValue
ambitiousMainScale.Parent = Main

local function applyAmbitiousProgressBarScale()
  local sg = HubGui:FindFirstChild("AmbitiousHubStealBarGui")
  local bar = sg and sg:FindFirstChild("StealBar")
  if not bar then return end
  local sc = bar:FindFirstChild("AmbitiousProgressBarScale") or Instance.new("UIScale")
  sc.Name = "AmbitiousProgressBarScale"
  sc.Scale = ambitiousProgressBarScaleValue
  sc.Parent = bar

  -- UIScale ridimensiona i frame ma NON il TextSize fisso: senza questo
  -- le scritte restavano sempre della stessa grandezza. La misura di
  -- partenza di ogni label si salva una volta in un attributo, cosi' lo
  -- scaling parte sempre dal valore originale e non si accumula.
  for _, d in ipairs(bar:GetDescendants()) do
    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
      local base = d:GetAttribute("AmbBaseTextSize")
      if not base then
        base = d.TextSize
        d:SetAttribute("AmbBaseTextSize", base)
      end
      pcall(function()
        d.TextSize = math.max(1, math.floor(base * ambitiousProgressBarScaleValue + 0.5))
      end)
    end
  end
end
_G.AmbitiousApplyProgressBarScale = applyAmbitiousProgressBarScale

_G.__AmbitiousDuelsSetupSettingsUI = function()
  section(Settings, "GUI SETTINGS", 1)
  -- La riga "Lock GUI" e' stata tolta: il lucchetto sta gia' in alto a
  -- sinistra nella finestra, averlo anche qui era un doppione. La funzione
  -- e il salvataggio restano identici, comanda solo quel bottone.

  do
    local row, setVisual = _G.AmbitiousActionToggleRow(Settings, "Hide Mobile Buttons", _G.AmbitiousHideMobileButtons == true, 9)
    setHideMobileButtonsVisual = setVisual
    local btn = row and row:FindFirstChild("ToggleButton")
    if btn then
      btn.Activated:Connect(function()
        _G.AmbitiousHideMobileButtons = not (_G.AmbitiousHideMobileButtons == true)
        if setVisual then setVisual(_G.AmbitiousHideMobileButtons == true) end
        if _G.AmbitiousApplyMobileButtonsHidden then _G.AmbitiousApplyMobileButtonsHidden() end
        -- Apri automaticamente le opzioni per scegliere quali pulsanti nascondere.
        if _G.AmbitiousHideMobileButtons and _G.AmbitiousExpandMobileHideOptions then
          _G.AmbitiousExpandMobileHideOptions(true)
        end
        saveAmbitiousConfig()
      end)
    end

    -- >>> SELEZIONE BOTTONI DA NASCONDERE <<<
    -- Freccetta stile Infinite Jump: aprendola si sceglie QUALI bottoni il
    -- toggle deve nascondere. Tutti accesi di default; spegnendone uno,
    -- quel bottone resta a schermo anche col toggle attivo.
    local HIDE_ITEMS = {
      { key = "drop",         label = "Drop BR" },
      { key = "autoPlay",     label = "Auto Play" },
      -- La versione accanto al nome e' sincronizzata col bottone mobile:
      -- "dyn" dice che l'etichetta va ricalcolata invece che fissa.
      { key = "aimbot",       label = "Bat Bypass", dyn = "aimbot" },
      { key = "batTP",        label = "TP Bat" },
      { key = "instantReset", label = "Instant Reset" },
      { key = "tp",           label = "TP Down" },
      { key = "carry",        label = "Carry Speed" },
      { key = "laggerNormal", label = "Lagger Normal" },
      { key = "laggerCarry",  label = "Lagger Carry" },
    }

    local ROW_H, GAP = 34, 6
    local HOLDER_H = #HIDE_ITEMS * ROW_H + (#HIDE_ITEMS - 1) * GAP + 8

    -- Testo della riga: per l'aimbot ci si attacca la versione attiva,
    -- esattamente come fa il bottone mobile ("BAT BYPASS").
    local function hideItemText(item)
      if item.dyn == "aimbot" then
        return item.label
      end
      return item.label
    end

    local hmHolder = Instance.new("Frame")
    hmHolder.Name = "Hide Mobile Buttons Options"
    hmHolder.BackgroundTransparency = 1
    hmHolder.Size = UDim2.new(1, 0, 0, HOLDER_H)
    hmHolder.BorderSizePixel = 0
    hmHolder.LayoutOrder = 9
    hmHolder.ZIndex = 4
    hmHolder.ClipsDescendants = true
    hmHolder.Visible = false
    hmHolder.Parent = Settings

    local hmList = Instance.new("UIListLayout")
    hmList.Padding = UDim.new(0, GAP)
    hmList.SortOrder = Enum.SortOrder.LayoutOrder
    hmList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    hmList.Parent = hmHolder

    local hmPad = Instance.new("UIPadding")
    hmPad.PaddingTop = UDim.new(0, 4)
    hmPad.Parent = hmHolder

    for i, item in ipairs(HIDE_ITEMS) do
      -- Riga identica alle sotto-righe: stesso sfondo,
      -- stesso bordo, stesso hover e stesso toggle (track + fill + knob con
      -- shine). L'unica differenza e' che qui non serve il bottone PICK.
      local r = Instance.new("Frame")
      r.Name = "HideOpt_" .. item.key
      r.BackgroundColor3 = COLORS.row
      r.BackgroundTransparency = 0.3
      r.Size = UDim2.new(1, -8, 0, 34)
      r.BorderSizePixel = 0
      r.LayoutOrder = i
      r.ZIndex = 4
      r.Parent = hmHolder
      corner(r, 9)
      local rStroke = stroke(r, COLORS.strokeSoft, 1.15, 0.38)
      r.MouseEnter:Connect(function() tween(r, {BackgroundTransparency = 0.22}) end)
      r.MouseLeave:Connect(function() tween(r, {BackgroundTransparency = 0.3}) end)

      local lbl = Instance.new("TextLabel")
      lbl.BackgroundTransparency = 1
      lbl.Text = hideItemText(item)
      lbl.TextColor3 = Color3.fromRGB(0, 0, 0)
      lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      lbl.TextStrokeTransparency = 0.25
      lbl.TextSize = 12
      lbl.Font = Enum.Font.GothamSemibold
      lbl.TextXAlignment = Enum.TextXAlignment.Left
      lbl.Position = UDim2.new(0, 12, 0, 0)
      lbl.Size = UDim2.new(1, -70, 1, 0)
      lbl.ZIndex = 5
      lbl.Parent = r

      local startOn = _G.AmbitiousMobileHideIncluded(item.key)

      local track = Instance.new("Frame")
      track.Name = "Track"
      track.BackgroundColor3 = COLORS.toggleBg
      track.BackgroundTransparency = 0.12
      track.Size = UDim2.new(0, 44, 0, 22)
      track.Position = UDim2.new(1, -52, 0.5, -11)
      track.BorderSizePixel = 0
      track.ZIndex = 5
      track.Parent = r
      corner(track, 11)
      local trackStroke = stroke(track, COLORS.strokeSoft, 1.3, 0.4)

      local fill = Instance.new("Frame")
      fill.Name = "Fill"
      fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      fill.BackgroundTransparency = startOn and 0 or 1
      fill.Size = UDim2.new(1, 0, 1, 0)
      fill.BorderSizePixel = 0
      fill.ZIndex = 5
      fill.Parent = track
      corner(fill, 11)
      local fillGrad = Instance.new("UIGradient")
      fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
      })
      fillGrad.Rotation = 18
      fillGrad.Parent = fill

      local knob = Instance.new("Frame")
      knob.Name = "Knob"
      knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      knob.Size = UDim2.new(0, 16, 0, 16)
      knob.Position = startOn and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
      knob.BorderSizePixel = 0
      knob.ZIndex = 7
      knob.Parent = track
      corner(knob, 999)
      local knobStroke = Instance.new("UIStroke")
      knobStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      knobStroke.Color = startOn and Color3.fromRGB(255, 220, 70) or Color3.fromRGB(255, 220, 70)
      knobStroke.Thickness = 1.4
      knobStroke.Transparency = 0.15
      knobStroke.Parent = knob

      local shine = Instance.new("Frame")
      shine.BackgroundColor3 = COLORS.white
      shine.BackgroundTransparency = 0.55
      shine.Size = UDim2.new(1, -5, 0, 5)
      shine.Position = UDim2.new(0, 2.5, 0, 2.5)
      shine.BorderSizePixel = 0
      shine.ZIndex = 8
      shine.Parent = knob
      corner(shine, 5)
      _G._AmbitiousRegAccent(fill, fillGrad, "toggle", track, knob, r)

      local function paint(on)
        local onBg, onEdge = _G._AmbitiousToggleOnColor()
        tween(knob, {Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)})
        tween(track, {
          BackgroundTransparency = on and 0 or 0.12,
          BackgroundColor3 = on and onBg or COLORS.toggleBg
        })
        tween(fill, {BackgroundTransparency = on and 0 or 1})
        tween(knobStroke, {Color = on and onEdge or Color3.fromRGB(255, 220, 70)})
        tween(trackStroke, {
          Color = on and onEdge or COLORS.strokeSoft,
          Transparency = on and 0 or 0.4,
          Thickness = 1.4
        })
        tween(rStroke, {
          Color = on and onBg or COLORS.strokeSoft,
          Transparency = on and 0.08 or 0.38,
          Thickness = 1.25
        })
      end

      local toggleBtn = Instance.new("TextButton")
      toggleBtn.Name = "ToggleButton"
      toggleBtn.BackgroundTransparency = 1
      toggleBtn.Text = ""
      toggleBtn.Size = UDim2.new(1, 0, 1, 0)
      toggleBtn.Position = UDim2.new(0, 0, 0, 0)
      toggleBtn.AutoButtonColor = false
      toggleBtn.ZIndex = 9
      toggleBtn.Parent = r
      toggleBtn.Activated:Connect(function()
        local on = not _G.AmbitiousMobileHideIncluded(item.key)
        _G.AmbitiousMobileHideList[item.key] = on
        paint(on)
        if _G.AmbitiousApplyMobileButtonsHidden then _G.AmbitiousApplyMobileButtonsHidden() end
        saveAmbitiousConfig()
      end)

      -- Refresh esterno (load config / reset)
      _G["_AmbHideOptPaint_" .. item.key] = paint
      if item.dyn then
        _G["_AmbHideOptLabel_" .. item.key] = function()
          lbl.Text = hideItemText(item)
        end
      end
      paint(startOn)
    end

    _G.AmbitiousRefreshMobileHideList = function()
      for _, item in ipairs(HIDE_ITEMS) do
        local f = _G["_AmbHideOptPaint_" .. item.key]
        if f then pcall(f, _G.AmbitiousMobileHideIncluded(item.key)) end
      end
    end

    local hmArrow = Instance.new("TextButton")
    hmArrow.Name = "HideMobileArrow"
    hmArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hmArrow.BackgroundTransparency = 0.18
    hmArrow.BorderSizePixel = 0
    hmArrow.Size = UDim2.new(0, 28, 0, 24)
    hmArrow.Position = UDim2.new(1, -90, 0.5, -12)
    hmArrow.Text = "\u{25B2}"
    hmArrow.TextColor3 = Color3.fromRGB(0, 0, 0)
    hmArrow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    hmArrow.TextStrokeTransparency = 0.3
    hmArrow.TextSize = 15
    hmArrow.Font = Enum.Font.GothamBold
    hmArrow.AutoButtonColor = false
    hmArrow.ZIndex = 8
    hmArrow.Parent = row
    corner(hmArrow, 7)
    stroke(hmArrow, COLORS.strokeSoft, 1, 0.45)

    local hmExpanded = false
    hmArrow.Activated:Connect(function()
      hmExpanded = not hmExpanded
      _G._AmbitiousExpand(hmHolder, hmExpanded, HOLDER_H, hmArrow)
    end)

    _G.AmbitiousExpandMobileHideOptions = function(forceOpen)
      hmExpanded = forceOpen == nil and not hmExpanded or forceOpen == true
      _G._AmbitiousExpand(hmHolder, hmExpanded, HOLDER_H, hmArrow)
    end
  end

  -- Background fixed: Roma Hub uses one image only.

-- ============================================================
-- CUSTOM FONTS
-- Applica un font a TUTTO il testo della hub: righe, sezioni, bottoni,
-- popup, lock e minimize, barra dell'auto grab, avvisi, e anche
-- l'etichetta sopra la testa â€” che non sta dentro la hub ma sulla Head
-- del personaggio, quindi va inseguita a parte a ogni respawn.
--
-- PERCHE' CENTINAIA E NON CINQUANTA.
-- Enum.Font ha una cinquantina di voci ed e' l'API vecchia: ogni voce e'
-- una combinazione famiglia+peso gia' decisa. Quella nuova e' FontFace,
-- che prende famiglia, PESO e stile separatamente. Si ricavano quindi le
-- famiglie uniche da Enum.Font e si moltiplicano per i nove pesi
-- (Thin..Heavy) e per corsivo si'/no: da ~25 famiglie vengono centinaia
-- di combinazioni vere, non nomi diversi per lo stesso disegno.
--
-- "Default" non e' un font: e' il ripristino. Di ogni elemento si salva
-- il FontFace ORIGINALE la prima volta che lo si tocca, cosi' tornare
-- indietro rimette esattamente quello che aveva ciascuno invece di
-- appiattire tutto su un font solo.
--
-- La tabella dei font originali e' STRONG di proposito: con __mode="k"
-- Luau scarterebbe le chiavi Instance anche se gli oggetti sono vivi
-- nella GUI, e al ripristino ci si ritroverebbe senza il valore da
-- rimettere.
--
-- Tutto su _G: zero local aggiunti al chunk principale.
-- ============================================================
_G.AmbitiousFonts = _G.AmbitiousFonts or {}
_G.AmbitiousFonts.orig = _G.AmbitiousFonts.orig or {}
_G.AmbitiousFonts.conns = _G.AmbitiousFonts.conns or {}
-- TextSize di partenza di ogni elemento, per l'adattamento automatico.
-- Strong come orig: senza il valore originale il ripristino non tornerebbe.
_G.AmbitiousFonts.size = _G.AmbitiousFonts.size or {}
_G.AmbitiousFontChoice = _G.AmbitiousFontChoice or "Default"

-- Nome breve del peso, per l'etichetta della card.
_G.AmbitiousFonts.WEIGHT_LABEL = {
  Thin = "Thin", ExtraLight = "ExLight", Light = "Light", Regular = "",
  Medium = "Medium", SemiBold = "SemiBold", Bold = "Bold",
  ExtraBold = "ExBold", Heavy = "Heavy",
}

-- Catalogo completo, costruito una volta sola e tenuto in cache: sono
-- centinaia di voci, rifarle a ogni apertura del popup sarebbe sprecato.
function _G.AmbitiousFonts.list()
  local F = _G.AmbitiousFonts
  if F.cache then return F.cache end

  local out = {{ key = "Default", label = "Default", font = nil }}

  -- Famiglie uniche ricavate da Enum.Font. Si parte da li' perche' e'
  -- l'unico elenco che il motore garantisce: niente id inventati.
  local seen, families = {}, {}
  for _, item in ipairs(Enum.Font:GetEnumItems()) do
    if item.Name ~= "Unknown" then
      local ok, f = pcall(function() return Font.fromEnum(item) end)
      if ok and f and f.Family and not seen[f.Family] then
        seen[f.Family] = true
        -- Nome leggibile: dal percorso rbxasset si tiene solo il file.
        local nice = tostring(f.Family):match("([^/\\]+)%.json$")
                  or tostring(f.Family):match("([^/\\]+)$")
                  or item.Name
        families[#families + 1] = { family = f.Family, nice = nice }
      end
    end
  end

  for _, fam in ipairs(families) do
    for _, w in ipairs(Enum.FontWeight:GetEnumItems()) do
      for _, italic in ipairs({false, true}) do
        local ok, f = pcall(function()
          return Font.new(fam.family, w,
            italic and Enum.FontStyle.Italic or Enum.FontStyle.Normal)
        end)
        if ok and f then
          local wl = F.WEIGHT_LABEL[w.Name] or w.Name
          local label = fam.nice
          if wl ~= "" then label = label .. " " .. wl end
          if italic then label = label .. " Italic" end
          out[#out + 1] = {
            key = fam.family .. "|" .. w.Name .. "|" .. (italic and "i" or "n"),
            label = label,
            font = f,
          }
        end
      end
    end
  end

  F.cache = out
  return out
end

function _G.AmbitiousFonts.byKey(key)
  for _, e in ipairs(_G.AmbitiousFonts.list()) do
    if e.key == key then return e end
  end
  return nil
end

-- I contenitori da percorrere. HubGui copre tutte le ScreenGui della hub;
-- il billboard sopra la testa vive sulla Head e va aggiunto a mano.
function _G.AmbitiousFonts.roots()
  local list = {}
  if HubGui then list[#list + 1] = HubGui end
  local char = LP.Character
  local head = char and char:FindFirstChild("Head")
  local oh = head and head:FindFirstChild("AmbitiousHubOverheadInfo")
  if oh then list[#list + 1] = oh end
  return list
end

-- Un simbolo solo: freccette, "-", "+", "X". Restano com'erano, font
-- compreso. Un glifo del genere non e' scrittura, e' un segno grafico
-- disegnato apposta per quel quadratino: prendendo il font scelto puo'
-- venire tutt'altra forma, storto o di un peso che stona. Il controllo e'
-- sui caratteri veri e non sui byte, se no una freccia ne conterebbe tre.
function _G.AmbitiousFonts.isGlyph(obj)
  local t = obj.Text
  if t == nil then return false end
  -- Una lettera o una cifra sono scrittura anche da sole: la "Q" di una
  -- keybind o la "X" di un bottone sono caratteri normali, e devono
  -- seguire il font come tutto il resto. L'esenzione vale solo per i
  -- segni: â–² â–¼ â—€ â–¶ - +.
  if string.match(t, "%w") then return false end
  local ok, n = pcall(function() return utf8.len(t) end)
  return ok and n ~= nil and n <= 1
end

function _G.AmbitiousFonts.applyOne(obj, font)
  if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
    return
  end
  -- Elementi esenti: le anteprime del popup dei font devono mostrare
  -- CIASCUNA il proprio campione. Sono dentro la hub come tutto il resto,
  -- quindi senza questa uscita il font scelto le sovrascriverebbe e i
  -- campioni diventerebbero tutti uguali fra loro.
  if obj:GetAttribute("AmbFontLock") then return end
  local F = _G.AmbitiousFonts
  -- Primo contatto: si conservano FontFace e TextSize di partenza.
  if F.orig[obj] == nil then
    F.orig[obj] = obj.FontFace
    F.size[obj] = obj.TextSize
  end
  if F.isGlyph(obj) then font = nil end   -- i simboli restano l'originale
  pcall(function()
    obj.FontFace = font or F.orig[obj]
    -- Si riparte SEMPRE dalla misura originale: l'adattamento sotto
    -- puo' solo rimpicciolire, mai ingrandire oltre com'era. Su Default
    -- questa riga e' anche il ripristino, e nessun adattamento segue.
    if F.size[obj] then obj.TextSize = F.size[obj] end
  end)
end

-- ADATTAMENTO AUTOMATICO DELLA MISURA
-- Ogni famiglia ha larghezze diverse: lo stesso testo che con Gotham sta
-- dentro la riga, con un font piu' largo esce dai margini.
--
-- La misura si CALCOLA, non si cerca a tentativi: GetTextBoundsAsync dice
-- quanto occuperebbe quel testo con quel font a quella misura, e con due
-- divisioni si ricava di quanto scalare. Ogni scritta e' a posto al primo
-- colpo, anche quelle che in quel momento non sono a schermo â€” le
-- dimensioni esistono comunque, mentre TextFits lo calcola il motore solo
-- su cio' che disegna, ed era per quello che si adattava la sola tab
-- aperta.
--
-- MARGIN: non basta che il testo "ci stia", deve anche non arrivare
-- appiccicato al bottone che ha accanto. Si toglie quel tanto di spazio
-- dai lati prima di fare il conto.
--
-- Su "Default" non gira affatto: le misure restano quelle di sempre.
_G.AmbitiousFonts.MIN_SIZE = 7    -- sotto e' illeggibile
_G.AmbitiousFonts.MARGIN   = 8    -- respiro ai lati, in pixel
_G.AmbitiousFonts.MAX_GROW = 1.35 -- quanto al massimo puo' crescere
-- Chiavi deboli: qui non si conserva niente da ripristinare, sono solo
-- appunti su chi e' gia' stato agganciato. Se l'oggetto sparisce dalla
-- GUI puo' sparire anche l'appunto.
_G.AmbitiousFonts.tconns = _G.AmbitiousFonts.tconns
  or setmetatable({}, {__mode = "k"})
-- Lunghezza del testo con cui ogni scritta e' stata adattata l'ultima
-- volta, per non rifare il conto a vuoto su un contatore che cambia cifra
-- restando lungo uguale.
_G.AmbitiousFonts.lastLen = _G.AmbitiousFonts.lastLen
  or setmetatable({}, {__mode = "k"})

function _G.AmbitiousFonts.params()
  local F = _G.AmbitiousFonts
  if F.gtbp == nil then
    local ok, p = pcall(function() return Instance.new("GetTextBoundsParams") end)
    F.gtbp = (ok and p) or false
  end
  return F.gtbp or nil
end

-- ------------------------------------------------------------
-- Il conto e' in DUE parti, e la differenza e' tutta qui.
--
-- 1) LA MISURA (costosa): quanto occupa quel testo col font nuovo e
--    quanto occupava col font originale. Da queste due nasce il rapporto
--    s0 â€” quanto scalare per avere lo stesso ingombro che la scritta
--    aveva su Default. Non c'entra niente con la casella, quindi si puo'
--    fare subito, anche su una scritta appena nata che non e' ancora
--    stata impaginata.
--
-- 2) IL CONTENIMENTO (gratis): il testo deve stare dentro la sua casella.
--    Qui serve la dimensione vera, ma NON serve rimisurare niente: le
--    dimensioni del testo sono gia' in cache, e ridurle allo spazio
--    disponibile sono due divisioni.
--
-- Separandole si risolve il problema di prima. Le scritte dei popup
-- nascono mentre il riquadro si sta ancora aprendo, e la loro casella in
-- quel momento e' piu' piccola di quella finale: con un conto solo o si
-- sbagliava, o bisognava aspettare e correggere dopo â€” ed era quello che
-- si vedeva cambiare sotto gli occhi. Adesso la parte 1 si applica
-- all'istante e la parte 2 si riapplica da sola a ogni variazione della
-- casella, quindi mentre il popup si ingrandisce il testo lo segue e
-- arriva gia' giusto. Stessa cosa per una freccetta o una riga dentro una
-- tendina chiusa: quando compare e prende una dimensione, si sistema da
-- se' senza che nessuno la tocchi.
-- ------------------------------------------------------------
_G.AmbitiousFonts.m = _G.AmbitiousFonts.m or setmetatable({}, {__mode = "k"})
_G.AmbitiousFonts.aconns = _G.AmbitiousFonts.aconns
  or setmetatable({}, {__mode = "k"})
_G.AmbitiousFonts.stamp = _G.AmbitiousFonts.stamp or 0

-- Parte 2: solo aritmetica sui numeri gia' in cache.
function _G.AmbitiousFonts.reclamp(obj)
  local F = _G.AmbitiousFonts
  local c = F.m[obj]
  if not c then return end
  -- Stessa esenzione di fitOne: un simbolo solo resta com'era.
  if F.isGlyph(obj) then
    if obj.TextSize ~= c.base then obj.TextSize = c.base end
    return
  end
  local s = c.s0
  local box = obj.AbsoluteSize
  if box.X > 1 and box.Y > 1 then
    -- AutomaticSize: su quell'asse la casella non e' un limite, e' il
    -- testo stesso a deciderla. Contenere il testo dentro una casella che
    -- lo insegue non ha senso e per di piu' si morde la coda: cambio la
    -- misura -> cambia la casella -> l'aggancio scatta -> ricontengo ->
    -- cambio di nuovo la misura, e si finisce dove capita. Il contatore
    -- degli MS e quello degli FPS sono gli unici due cosi' fatti nella
    -- barra, ed e' per questo che uno dei due si ritrovava con una misura
    -- che non c'entrava niente.
    local auto = obj.AutomaticSize
    local freeX = (auto == Enum.AutomaticSize.X or auto == Enum.AutomaticSize.XY)
    local freeY = (auto == Enum.AutomaticSize.Y or auto == Enum.AutomaticSize.XY)
    if not freeY then
      s = math.min(s, math.max(box.Y - 2, 1) / c.by)
    end
    -- Il respiro laterale e' in pixel, ma su una casella stretta 8px sono
    -- un quinto dello spazio: sotto una certa larghezza si accorcia con
    -- lei, se no le scritte piccole (FPS, MS, la percentuale) si
    -- ridurrebbero a niente.
    if not (freeX or c.wrapped) then
      s = math.min(s, math.max(box.X - math.min(F.MARGIN, box.X * 0.08), 1) / c.bx)
    end
  end
  local want = math.floor(c.base * s + 0.5)
  if want < F.MIN_SIZE then want = F.MIN_SIZE end
  if obj.TextSize ~= want then obj.TextSize = want end
end

-- Parte 1: le due misurazioni, e il rapporto con l'ingombro di Default.
function _G.AmbitiousFonts.measure(obj)
  local F = _G.AmbitiousFonts
  local font = F.current()
  if not font then return false end
  local prm = F.params()
  if not prm then return false end
  F.tsvc = F.tsvc or game:GetService("TextService")

  local base = F.size[obj]
  if not base then base = obj.TextSize; F.size[obj] = base end

  local txt = obj.Text
  if txt == nil or txt == "" then
    F.m[obj] = {base = base, bx = 1, by = 1, s0 = 1, stamp = F.stamp, text = txt}
    return true
  end

  -- Con TextWrapped la larghezza e' vincolata e quello che conta e'
  -- l'altezza; senza, si misura su una riga sola.
  local wrapped = obj.TextWrapped and obj.AbsoluteSize.X > 1
  prm.Text = txt
  prm.Size = base
  prm.Width = wrapped and obj.AbsoluteSize.X or 0

  prm.Font = font
  local ok, b = pcall(function() return F.tsvc:GetTextBoundsAsync(prm) end)
  if not (ok and b and b.X > 0 and b.Y > 0) then return false end

  -- L'ingombro col font ORIGINALE e' il riferimento: e' com'era la GUI su
  -- Default. Il font nuovo va portato li' â€” se disegna piu' largo si
  -- rimpicciolisce, se disegna piu' stretto si INGRANDISCE.
  local s0 = 1
  local of = F.orig[obj]
  if of then
    prm.Font = of
    local ok2, b2 = pcall(function() return F.tsvc:GetTextBoundsAsync(prm) end)
    if ok2 and b2 and b2.X > 0 and b2.Y > 0 then
      -- Il confronto e' sulla LARGHEZZA: l'altezza dei due riquadri e'
      -- quasi sempre la stessa (la misura del font e' gia' l'altezza
      -- della riga) e quel rapporto vale circa 1 sempre. Sul testo a capo
      -- vale l'opposto, li' la larghezza e' fissa per definizione.
      s0 = wrapped and (b2.Y / b.Y) or (b2.X / b.X)
    end
  end
  -- Tetto alla crescita: un font molto stretto non deve diventare enorme
  -- solo perche' la casella e' larga.
  if s0 > F.MAX_GROW then s0 = F.MAX_GROW end

  F.m[obj] = {base = base, bx = b.X, by = b.Y, s0 = s0,
              wrapped = wrapped, stamp = F.stamp, text = txt}
  return true
end

-- Misura se serve, poi contiene. noBox e' rimasto per compatibilita': la
-- casella ormai la guarda solo reclamp, che e' gratis.
function _G.AmbitiousFonts.fitOne(obj)
  local F = _G.AmbitiousFonts
  if not F.current() then return end
  if obj:GetAttribute("AmbFontLock") then return end
  if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
  if obj.TextScaled then return end

  -- I BOTTONI DI UN SEGNO SOLO NON SI TOCCANO, ne' nel font ne' nella
  -- misura: il criterio "stesso ingombro che aveva su Default" su un
  -- simbolo non vuol dire niente, e ricalcolarlo produceva solo quelle
  -- variazioni che sembravano un difetto quando li premevi.
  if F.isGlyph(obj) then return true end

  local c = F.m[obj]
  if not (c and c.stamp == F.stamp and c.text == obj.Text) then
    if not F.measure(obj) then return false end
  end
  F.reclamp(obj)
  return true
end

-- Aggancia una scritta: da qui in poi si tiene aggiornata da sola.
-- Un aggancio per oggetto, fatto una volta sola.
function _G.AmbitiousFonts.watch(obj)
  local F = _G.AmbitiousFonts
  if F.aconns[obj] then return end
  -- La casella cambia: durante l'apertura di un popup, con la GUI Scale,
  -- quando una tendina si apre. Qui non si rimisura niente, si ricontiene
  -- e basta.
  F.aconns[obj] = obj:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    local G = _G.AmbitiousFonts
    if not G.current() then return end
    if G.m[obj] then G.reclamp(obj) else pcall(G.fitOne, obj) end
  end)
  if F.tconns[obj] then return end
  -- Il testo cambia: LOCK che diventa UNLOCK, una keybind, un contatore.
  -- Un contatore che passa da 58 a 59 pero' occupa lo stesso spazio, e
  -- rimisurarlo a ogni cifra sarebbe lavoro buttato su roba che cambia
  -- anche piu' volte al secondo: si rifa il conto quando cambia la
  -- lunghezza.
  F.tconns[obj] = obj:GetPropertyChangedSignal("Text"):Connect(function()
    local G = _G.AmbitiousFonts
    if not G.current() then return end
    if G.lastLen[obj] == #obj.Text then return end
    G.lastLen[obj] = #obj.Text
    -- Anche il font va rideciso: una scritta puo' diventare un simbolo
    -- solo (o smettere di esserlo) e l'esenzione cambia con lei.
    pcall(G.applyOne, obj, G.current())
    pcall(G.fitOne, obj)
  end)
end

function _G.AmbitiousFonts.fit(pass)
  local F = _G.AmbitiousFonts
  F.fitToken = (F.fitToken or 0) + 1
  local myToken = F.fitToken
  if not F.current() then return end   -- Default: nessuna modifica
  F.tsvc = F.tsvc or game:GetService("TextService")

  task.spawn(function()
    local list = {}
    for _, root in ipairs(F.roots()) do
      for _, d in ipairs(root:GetDescendants()) do
        if (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox"))
           and not d.TextScaled and not d:GetAttribute("AmbFontLock") then
          list[#list + 1] = d
        end
      end
    end

    for _, o in ipairs(list) do
      if F.fitToken ~= myToken then return end   -- font cambiato nel frattempo
      if o.Parent then
        F.fitOne(o)
        F.lastLen[o] = #o.Text
        F.watch(o)
      end
    end

    -- Un ripasso comunque: un font appena scelto puo' non essere ancora
    -- stato caricato dal motore, e finche' non lo e' le misure che
    -- tornano sono quelle del ripiego. Il secondo giro cade a
    -- caricamento finito. La cache viene buttata apposta, se no si
    -- riuserebbero proprio i numeri sbagliati.
    pass = (tonumber(pass) or 0) + 1
    if pass < 3 then
      task.delay(pass == 1 and 0.35 or 1.5, function()
        if F.fitToken ~= myToken then return end
        F.stamp = F.stamp + 1
        F.fit(pass)
      end)
    end
  end)
end

-- Font attualmente scelto, oppure nil se siamo su "Default".
function _G.AmbitiousFonts.current()
  local key = _G.AmbitiousFontChoice
  if not key or key == "Default" then return nil end
  local e = _G.AmbitiousFonts.byKey(key)
  return e and e.font or nil
end

function _G.AmbitiousFonts.applyAll()
  local F = _G.AmbitiousFonts
  local font = F.current()
  for _, root in ipairs(F.roots()) do
    F.applyOne(root, font)
    for _, d in ipairs(root:GetDescendants()) do
      F.applyOne(d, font)
    end
  end
  F.fit()
end

-- Aggancio a eventi, non a un loop: i popup e le righe create dopo
-- devono nascere gia' col font giusto, ma senza riscandire niente.
function _G.AmbitiousFonts.hook()
  local F = _G.AmbitiousFonts
  for _, c in ipairs(F.conns) do pcall(function() c:Disconnect() end) end
  F.conns = {}
  for _, root in ipairs(F.roots()) do
    F.conns[#F.conns + 1] = root.DescendantAdded:Connect(function(d)
      if _G.AmbitiousFontChoice == "Default" then return end
      F.applyOne(d, F.current())
      -- Subito, nello stesso istante in cui nasce: cosi' compare gia'
      -- della misura giusta invece di correggersi sotto gli occhi un
      -- attimo dopo. Il contenimento nella casella non serve aspettarlo,
      -- ci pensa l'aggancio qui sotto mentre il riquadro si apre.
      pcall(F.fitOne, d)
      pcall(F.watch, d)
    end)
  end
end

function _G.AmbitiousFonts.set(key, skipSave)
  _G.AmbitiousFontChoice = key or "Default"
  -- Font diverso, misure diverse: quello che c'e' in cache non vale piu'.
  _G.AmbitiousFonts.stamp = (_G.AmbitiousFonts.stamp or 0) + 1
  _G.AmbitiousFonts.applyAll()
  _G.AmbitiousFonts.hook()
  if not skipSave and saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

-- Il catalogo si costruisce una volta sola; farlo adesso in sottofondo
-- vuol dire che al primo click sul PICK e' gia' pronto in cache.
task.spawn(function() pcall(_G.AmbitiousFonts.list) end)


-- L'etichetta sopra la testa viene ricreata a ogni respawn: si riapplica
-- il font e si riaggancia il listener sul nuovo billboard.
if not _G.AmbitiousFonts.charConn then
  _G.AmbitiousFonts.charConn = LP.CharacterAdded:Connect(function()
    task.delay(1.5, function()
      if _G.AmbitiousFontChoice == "Default" then return end
      pcall(_G.AmbitiousFonts.applyAll)
      pcall(_G.AmbitiousFonts.hook)
    end)
  end)
end


  -- ===== CUSTOM FONTS ROW =====
  -- Riga con PICK, stessa forma di Tab Position, creata subito dopo con
  -- lo stesso LayoutOrder: a parita' di ordine il UIListLayout segue
  -- l'inserimento, quindi finisce sotto.
  ;(function()
    local cfRow = baseRow(Settings, "Custom Fonts", 2)
    cfRow.Size = UDim2.new(1, -4, 0, 42)

    local cfHolder = Instance.new("Frame")
    cfHolder.Name = "CustomFontsBtnHolder"
    cfHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    cfHolder.BackgroundTransparency = 0.28
    cfHolder.BorderSizePixel = 0
    cfHolder.Size = UDim2.new(0, 66, 0, 30)
    cfHolder.Position = UDim2.new(1, -73, 0.5, -15)
    cfHolder.ClipsDescendants = true
    cfHolder.ZIndex = 6
    cfHolder.Parent = cfRow
    corner(cfHolder, 15)
    stroke(cfHolder, Color3.fromRGB(255, 220, 70), 1.5, 0.15)

    local cfGrad = Instance.new("UIGradient")
    cfGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    cfGrad.Rotation = 18
    cfGrad.Parent = cfHolder
    _G._AmbitiousRegAccent(cfHolder, cfGrad, "pick")

    local cfBtn = Instance.new("TextButton")
    cfBtn.Name = "CustomFontsButton"
    cfBtn.BackgroundTransparency = 1
    cfBtn.Text = "PICK"
    cfBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    cfBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    cfBtn.TextStrokeTransparency = 0.3
    cfBtn.TextSize = 12
    cfBtn.Font = Enum.Font.GothamBlack
    cfBtn.Size = UDim2.new(1, 0, 1, 0)
    cfBtn.BorderSizePixel = 0
    cfBtn.ZIndex = 8
    cfBtn.AutoButtonColor = false
    cfBtn.Parent = cfHolder

    cfBtn.MouseEnter:Connect(function()
      tween(cfHolder, {Size = UDim2.new(0, 72, 0, 32), Position = UDim2.new(1, -76, 0.5, -16)}, 0.12)
    end)
    cfBtn.MouseLeave:Connect(function()
      tween(cfHolder, {Size = UDim2.new(0, 66, 0, 30), Position = UDim2.new(1, -73, 0.5, -15)}, 0.12)
    end)

    -- ---------- POPUP ----------
    -- Ricalcato sullo Sky Picker riga per riga: stesse misure, stesso
    -- backdrop, stessa apertura in Back/Out da zero e stessa chiusura in
    -- dissolvenza, stesso click fuori che chiude. Cambia solo il
    -- contenuto delle celle.
    local fontPickerGui = nil

    local function closeFontPicker()
      if fontPickerGui and fontPickerGui.Parent then
        local fadeTween = TweenService:Create(fontPickerGui.Frame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        fadeTween:Play()
        fadeTween.Completed:Connect(function()
          if fontPickerGui then
            pcall(function() fontPickerGui:Destroy() end)
            fontPickerGui = nil
          end
        end)
      end
    end
    _G.AmbitiousFontPickerClose = closeFontPicker

    cfBtn.Activated:Connect(function()
      if fontPickerGui and fontPickerGui.Parent then
        closeFontPicker()
        return
      end

      fontPickerGui = Instance.new("ScreenGui")
      fontPickerGui.Name = "AmbitiousHubFontPicker"
      fontPickerGui.ResetOnSpawn = false
      fontPickerGui.IgnoreGuiInset = true
      fontPickerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
      fontPickerGui.DisplayOrder = 9999
      fontPickerGui.Parent = HubGui
      local fpGui = fontPickerGui

      local fpBack = Instance.new("Frame")
      fpBack.Name = "Backdrop"
      fpBack.Size = UDim2.new(1, 0, 1, 0)
      fpBack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      fpBack.BackgroundTransparency = 0.45
      fpBack.BorderSizePixel = 0
      fpBack.ZIndex = 1
      fpBack.Parent = fpGui

      local fpFrame = Instance.new("Frame")
      fpFrame.Name = "Frame"
      fpFrame.Size = UDim2.new(0, 380, 0, 520)
      fpFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
      fpFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      fpFrame.BorderSizePixel = 0
      fpFrame.ZIndex = 2
      fpFrame.Parent = fpGui
      corner(fpFrame, 16)
      stroke(fpFrame, Color3.fromRGB(0, 0, 0), 1.2, 0.3)

      local fpBar = Instance.new("Frame")
      fpBar.Name = "TitleBar"
      fpBar.Size = UDim2.new(1, 0, 0, 48)
      fpBar.Position = UDim2.new(0, 0, 0, 0)
      fpBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      fpBar.BackgroundTransparency = 0.15
      fpBar.BorderSizePixel = 0
      fpBar.ZIndex = 3
      fpBar.Parent = fpFrame
      corner(fpBar, 16)

      local fpTitle = Instance.new("TextLabel")
      fpTitle.Name = "Title"
      fpTitle.Size = UDim2.new(1, -60, 1, 0)
      fpTitle.Position = UDim2.new(0, 18, 0, 0)
      fpTitle.BackgroundTransparency = 1
      fpTitle.Text = "SELECT FONT"
      fpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
      fpTitle.Font = Enum.Font.GothamBlack
      fpTitle.TextSize = 16
      fpTitle.TextXAlignment = Enum.TextXAlignment.Left
      fpTitle.ZIndex = 4
      fpTitle.Parent = fpBar

      local fpClose = Instance.new("TextButton")
      fpClose.Name = "CloseBtn"
      fpClose.Size = UDim2.new(0, 36, 0, 36)
      fpClose.Position = UDim2.new(1, -44, 0, 6)
      fpClose.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      fpClose.BackgroundTransparency = 0.1
      fpClose.BorderSizePixel = 0
      fpClose.Text = "X"
      fpClose.TextColor3 = Color3.fromRGB(255, 255, 255)
      fpClose.Font = Enum.Font.GothamBlack
      fpClose.TextSize = 14
      fpClose.AutoButtonColor = false
      fpClose.ZIndex = 4
      fpClose.Parent = fpBar
      corner(fpClose, 10)
      stroke(fpClose, Color3.fromRGB(0, 0, 0), 1, 0.4)

      fpClose.MouseEnter:Connect(function()
        tween(fpClose, {BackgroundColor3 = Color3.fromRGB(255, 220, 70)}, 0.12)
      end)
      fpClose.MouseLeave:Connect(function()
        tween(fpClose, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}, 0.12)
      end)
      fpClose.Activated:Connect(closeFontPicker)

      local fpScroll = Instance.new("ScrollingFrame")
      fpScroll.Name = "Scroll"
      fpScroll.Size = UDim2.new(1, -16, 1, -64)
      fpScroll.Position = UDim2.new(0, 8, 0, 56)
      fpScroll.BackgroundTransparency = 1
      fpScroll.BorderSizePixel = 0
      fpScroll.ScrollBarThickness = 4
      fpScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 220, 70)
      fpScroll.ZIndex = 3
      fpScroll.Parent = fpFrame

      -- RIUSO DELLE CARD (niente UIGridLayout)
      -- I font sono centinaia: creare una card per ognuno vuol dire
      -- migliaia di istanze in un colpo solo, ed e' quello lo scatto
      -- all'apertura. Qui le card create sono solo quelle che entrano
      -- nello schermo piu' una riga di margine: scorrendo non se ne
      -- creano altre, si riscrive il contenuto di quelle che ci sono.
      -- La griglia viene calcolata a mano perche' un UIGridLayout
      -- pretenderebbe che tutte le celle esistessero davvero: le misure
      -- pero' sono identiche a quelle dello Sky Picker (108 + 10 di gap).
      local FP_COLS, FP_CELL, FP_GAP = 3, 108, 10
      local FP_STEP = FP_CELL + FP_GAP
      local fpList = _G.AmbitiousFonts.list()
      local fpRows = math.ceil(#fpList / FP_COLS)
      -- L'altezza del canvas e' quella che avrebbero TUTTE le righe: la
      -- barra di scorrimento resta giusta anche se le card non esistono.
      fpScroll.CanvasSize = UDim2.new(0, 0, 0, 16 + fpRows * FP_STEP)

      local fpPool = {}

      local function fpEntryOf(card)
        local idx = card:GetAttribute("FontIdx")
        return idx and fpList[idx] or nil
      end

      local function fpPaint()
        for _, c in ipairs(fpPool) do
          local e = fpEntryOf(c)
          local sel = (e ~= nil and _G.AmbitiousFontChoice == e.key)
          local st = c:FindFirstChildOfClass("UIStroke")
          if st then
            tween(st, {
              Color = sel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 220, 70),
              Transparency = sel and 0 or 0.55,
              Thickness = sel and 2.4 or 1.2,
            }, 0.12)
          end
        end
      end

      local function fpBind(card, idx)
        local e = fpList[idx]
        if not e then
          card:SetAttribute("FontIdx", nil)
          card.Visible = false
          return
        end
        local row = math.floor((idx - 1) / FP_COLS)
        local col = (idx - 1) % FP_COLS
        card.Position = UDim2.new(0, 10 + col * FP_STEP, 0, 8 + row * FP_STEP)
        card:SetAttribute("FontIdx", idx)
        local prv = card:FindFirstChild("Preview")
        if prv then
          if e.font then prv.FontFace = e.font else prv.Font = Enum.Font.GothamBlack end
        end
        local nl = card:FindFirstChild("FontName")
        if nl then nl.Text = e.label end
        card.Visible = true
      end

      -- Quante card servono davvero: le righe visibili piu' due di
      -- margine, cosi' scorrendo non si vede mai un buco.
      for j = 1, (math.ceil(456 / FP_STEP) + 2) * FP_COLS do
        local card = Instance.new("TextButton")
        card.Name = "FontCard_" .. tostring(j)
        card.Size = UDim2.new(0, FP_CELL, 0, FP_CELL)
        card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        card.BackgroundTransparency = 0
        card.BorderSizePixel = 0
        card.Text = ""
        card.AutoButtonColor = false
        card.Visible = false
        card.ZIndex = 4
        card.ClipsDescendants = true
        card.Parent = fpScroll
        corner(card, 18)

        local cardStroke = Instance.new("UIStroke")
        cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        cardStroke.Color = Color3.fromRGB(255, 220, 70)
        cardStroke.Thickness = 1.2
        cardStroke.Transparency = 0.55
        cardStroke.Parent = card

        -- ANTEPRIMA. L'attributo la mette fuori dalla portata del motore
        -- dei font: senza, il font appena scelto verrebbe applicato anche
        -- a lei â€” sta dentro la hub come tutto il resto â€” e i campioni
        -- diventerebbero tutti uguali.
        local prv = Instance.new("TextLabel")
        prv.Name = "Preview"
        prv.BackgroundTransparency = 1
        prv.Size = UDim2.new(1, -10, 0, 58)
        prv.Position = UDim2.new(0, 5, 0, 8)
        prv.Text = "Aa"
        prv.TextColor3 = Color3.fromRGB(255, 255, 255)
        prv.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        prv.TextStrokeTransparency = 0.4
        prv.TextSize = 34
        prv.Font = Enum.Font.GothamBlack
        prv.ZIndex = 5
        prv.Parent = card
        prv:SetAttribute("AmbFontLock", true)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Name = "FontName"
        nameLbl.Size = UDim2.new(1, -8, 0, 32)
        nameLbl.Position = UDim2.new(0, 4, 1, -36)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = ""
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLbl.TextStrokeTransparency = 0.4
        nameLbl.Font = Enum.Font.GothamBlack
        nameLbl.TextSize = 9
        nameLbl.TextWrapped = true
        nameLbl.ZIndex = 6
        nameLbl.Parent = card
        nameLbl:SetAttribute("AmbFontLock", true)

        card.MouseEnter:Connect(function()
          tween(cardStroke, {Transparency = 0, Thickness = 2.4}, 0.12)
          tween(prv, {TextSize = 40}, 0.12)
        end)
        card.MouseLeave:Connect(function()
          local e = fpEntryOf(card)
          local sel = (e ~= nil and _G.AmbitiousFontChoice == e.key)
          tween(cardStroke, {
            Transparency = sel and 0 or 0.55,
            Thickness = sel and 2.4 or 1.2,
          }, 0.12)
          tween(prv, {TextSize = 34}, 0.12)
        end)

        card.Activated:Connect(function()
          local e = fpEntryOf(card)
          if not e then return end
          _G.AmbitiousFonts.set(e.key)
          fpPaint()
        end)

        fpPool[#fpPool + 1] = card
      end

      -- Si ridisegna solo quando cambia la prima riga visibile: durante
      -- uno scorrimento fluido la maggior parte dei frame non fa nulla.
      local fpFirstRow = -1
      local function fpRender()
        local first = math.max(0, math.floor((fpScroll.CanvasPosition.Y - 8) / FP_STEP) - 1)
        if first == fpFirstRow then return end
        fpFirstRow = first
        for j, card in ipairs(fpPool) do
          fpBind(card, first * FP_COLS + j)
        end
        fpPaint()
      end
      fpScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(fpRender)
      fpRender()

      fpBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
          closeFontPicker()
        end
      end)

      fpFrame.Size = UDim2.new(0, 0, 0, 0)
      fpFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
      TweenService:Create(fpFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 520),
        Position = UDim2.new(0.5, -190, 0.5, -260)
      }):Play()
    end)
  end)()
  -- ===== FINE CUSTOM FONTS ROW =====

  function stepperRow(parent, labelText, defaultValue, order, callback, minValue, maxValue)
    local row = Instance.new("Frame")
    row.Name = labelText
    row.BackgroundColor3 = COLORS.row
    row.BackgroundTransparency = 0.22
    row.Size = UDim2.new(1, -4, 0, 42)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 4
    row.Parent = parent
    corner(row, 10)
    stroke(row, COLORS.strokeSoft, 1.15, 0.32)

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.25
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -155, 1, 0)
    label.ZIndex = 5
    label.Parent = row

    local value = defaultValue
    local minus = Instance.new("TextButton")
    minus.Name = "Minus"
    minus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    minus.BackgroundTransparency = 0.1
    minus.BorderSizePixel = 0
    minus.Text = "-"
    minus.TextColor3 = Color3.fromRGB(0, 0, 0)
    minus.TextSize = 14
    minus.Font = Enum.Font.GothamBlack
    minus.AutoButtonColor = false
    minus.Size = UDim2.new(0, 28, 0, 26)
    minus.Position = UDim2.new(1, -118, 0.5, -13)
    minus.ZIndex = 6
    minus.Parent = row
    corner(minus, 7)
    stroke(minus, COLORS.strokeSoft, 1, 0.5)

    local valueBox = Instance.new("TextLabel")
    valueBox.Name = "Value"
    valueBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    valueBox.BackgroundTransparency = 0.05
    valueBox.BorderSizePixel = 0
    valueBox.Text = string.format("%.2f", value)
    valueBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    valueBox.TextSize = 13
    valueBox.Font = Enum.Font.GothamBlack
    valueBox.TextXAlignment = Enum.TextXAlignment.Center
    valueBox.Size = UDim2.new(0, 48, 0, 26)
    valueBox.Position = UDim2.new(1, -84, 0.5, -13)
    valueBox.ZIndex = 6
    valueBox.Parent = row
    corner(valueBox, 7)
    stroke(valueBox, COLORS.strokeSoft, 1, 0.5)

    local plus = Instance.new("TextButton")
    plus.Name = "Plus"
    plus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    plus.BackgroundTransparency = 0.1
    plus.BorderSizePixel = 0
    plus.Text = "+"
    plus.TextColor3 = Color3.fromRGB(0, 0, 0)
    plus.TextSize = 14
    plus.Font = Enum.Font.GothamBlack
    plus.AutoButtonColor = false
    plus.Size = UDim2.new(0, 28, 0, 26)
    plus.Position = UDim2.new(1, -30, 0.5, -13)
    plus.ZIndex = 6
    plus.Parent = row
    corner(plus, 7)
    stroke(plus, COLORS.strokeSoft, 1, 0.5)

    local function setValue(nextValue)
      value = math.clamp(math.floor((nextValue * 100) + 0.5) / 100, minValue or 0.50, maxValue or 1.50)
      valueBox.Text = string.format("%.2f", value)
      if callback then callback(value) end
    end

    minus.MouseButton1Click:Connect(function()
      setValue(value - 0.05)
    end)
    plus.MouseButton1Click:Connect(function()
      setValue(value + 0.05)
    end)
    return row
  end

  stepperRow(Settings, "GUI Scale", ambitiousGuiScaleValue, 4, function(v)
    ambitiousGuiScaleValue = v
    ambitiousMainScale.Scale = v
    saveAmbitiousConfig()
  end, 0.50, 1.50)

  stepperRow(Settings, "Progress Bar Size", ambitiousProgressBarScaleValue, 5, function(v)
    ambitiousProgressBarScaleValue = v
    applyAmbitiousProgressBarScale()
    saveAmbitiousConfig()
  end, 0.50, 1.50)

  speedKeybindRow(Settings, "Toggle UI", "ToggleUI", 6)

  section(Settings, "MOBILE BUTTONS", 7)
  stepperRow(Settings, "Mobile Buttons Size", tonumber(_G.AmbitiousMobileButtonScale) or 0.75, 10, function(v)
    _G.AmbitiousMobileButtonScale = math.clamp(tonumber(v) or 0.35, 0.30, 1.35)
    if _G.AmbitiousApplyMobileButtonSize then _G.AmbitiousApplyMobileButtonSize() end
    saveAmbitiousConfig()
  end, 0.30, 1.35)

  do
    local row = baseRow(Settings, "Reset Mobile Buttons", 11)
    local mobResetBg = Instance.new("Frame")
    mobResetBg.Name = "ResetMobileButtonsBg"
    mobResetBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mobResetBg.BackgroundTransparency = 0
    mobResetBg.BorderSizePixel = 0
    mobResetBg.Size = UDim2.new(0, 78, 0, 24)
    mobResetBg.Position = UDim2.new(1, -88, 0.5, -12)
    mobResetBg.ZIndex = 7
    mobResetBg.Parent = row
    corner(mobResetBg, 12)
    stroke(mobResetBg, Color3.fromRGB(255, 220, 70), 1.5, 0.15)

    local button = Instance.new("TextButton")
    button.Name = "ResetMobileButtons"
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.Text = "RESET"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    button.TextStrokeTransparency = 0.3
    button.TextSize = 12
    button.Font = Enum.Font.GothamBlack
    button.AutoButtonColor = false
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.ZIndex = 8
    button.Parent = mobResetBg

    local mobResetGrad = Instance.new("UIGradient")
    mobResetGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    mobResetGrad.Rotation = 18
    mobResetGrad.Parent = mobResetBg
    _G._AmbitiousRegAccent(mobResetBg, mobResetGrad, "button")

    button.MouseEnter:Connect(function()
      tween(mobResetBg, {Size = UDim2.new(0, 82, 0, 26), Position = UDim2.new(1, -90, 0.5, -13)}, 0.12)
    end)
    button.MouseLeave:Connect(function()
      tween(mobResetBg, {Size = UDim2.new(0, 78, 0, 24), Position = UDim2.new(1, -88, 0.5, -12)}, 0.12)
    end)
    button.Activated:Connect(function()
      if _G.AmbitiousResetMobileButtons then
        _G.AmbitiousResetMobileButtons()
      else
        _G.AmbitiousMobileButtonScale = 0.75
        _G.AmbitiousHideMobileButtons = false
        if _G.AmbitiousApplyMobileButtonsHidden then _G.AmbitiousApplyMobileButtonsHidden() end
        if _G.AmbitiousApplyMobileButtonSize then _G.AmbitiousApplyMobileButtonSize() end
        saveAmbitiousConfig()
      end
    end)
  end

  section(Settings, "INTRO", 50)
  do
    local row, setVisual = toggleRow(Settings, "Intro", _introEnabled, 51)
    setIntroVisual = setVisual
    local btn = row and row:FindFirstChild("ToggleButton")
    if btn then
      btn.Activated:Connect(function()
        _introEnabled = not _introEnabled
        if not _introEnabled then stopIntroPlayback(); stopIntroPreview() end
        if setIntroVisual then setIntroVisual(_introEnabled) end
        saveAmbitiousConfig()
      end)
    end
    if setIntroVisual then setIntroVisual(_introEnabled) end
  end

  section(Settings, "SETTINGS", 999)
  local resetHolder = Instance.new("Frame")
  resetHolder.Name = "Reset All Settings Holder"
  resetHolder.BackgroundTransparency = 1
  resetHolder.BorderSizePixel = 0
  resetHolder.Size = UDim2.new(1, -4, 0, 44)
  resetHolder.LayoutOrder = 1000
  resetHolder.ZIndex = 5
  resetHolder.Parent = Settings

  local resetBg = Instance.new("Frame")
  resetBg.Name = "ResetBg"
  resetBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  resetBg.BackgroundTransparency = 0
  resetBg.BorderSizePixel = 0
  resetBg.Size = UDim2.new(1, -16, 0, 42)
  resetBg.Position = UDim2.new(0, 8, 0, 1)
  resetBg.ZIndex = 6
  resetBg.Parent = resetHolder
  corner(resetBg, 21)

  local resetBtn = Instance.new("TextButton")
  resetBtn.Name = "Reset All Settings"
  resetBtn.BackgroundTransparency = 1
  resetBtn.BorderSizePixel = 0
  resetBtn.Text = "Reset All Settings"
  resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
  resetBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
  resetBtn.TextStrokeTransparency = 0.3
  resetBtn.TextSize = 13
  resetBtn.Font = Enum.Font.GothamBlack
  resetBtn.AutoButtonColor = false
  resetBtn.Size = UDim2.new(1, 0, 1, 0)
  resetBtn.Position = UDim2.new(0, 0, 0, 0)
  resetBtn.ZIndex = 7
  resetBtn.Parent = resetBg

  local resetGrad = Instance.new("UIGradient")
  resetGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
  })
  resetGrad.Rotation = 18
  resetGrad.Parent = resetBg

  local resetStroke = Instance.new("UIStroke")
  resetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  resetStroke.Color = Color3.fromRGB(255, 220, 70)
  resetStroke.Thickness = 1.5
  resetStroke.Transparency = 0.15
  resetStroke.Parent = resetBg

  _G._AmbitiousRegAccent(resetBg, resetGrad, "button")
  local function resetDefaultBg()
    local b = _G._AmbitiousToggleOnColor()
    return b
  end
  local function resetEdgeCol()
    local _, e = _G._AmbitiousToggleOnColor()
    return e
  end
  local function resetHoverBg()
    local b = _G._AmbitiousToggleOnColor()
    return b:Lerp(Color3.fromRGB(255, 255, 255), 0.16)
  end
  local resetConfirmBg = Color3.fromRGB(0, 0, 0)
  local resetDoneBg = Color3.fromRGB(0, 0, 0)
  local resetDefaultText = Color3.fromRGB(255, 255, 255)
  local resetConfirmText = Color3.fromRGB(255, 220, 70)
  local resetDoneText = Color3.fromRGB(255, 220, 70)
  local confirmState = false
  local confirmTimer = nil

  function setResetDefaultTheme()
    confirmState = false
    resetBtn.Text = "RESET ALL SETTINGS"
    resetBtn.TextColor3 = resetDefaultText
    resetGrad.Enabled = true
    tween(resetBg, {BackgroundColor3 = resetDefaultBg()}, 0.18)
    tween(resetStroke, {Color = resetEdgeCol(), Transparency = 0.15, Thickness = 1.5}, 0.18)
  end

  function setResetConfirmTheme()
    resetBtn.Text = "CLICK AGAIN TO CONFIRM"
    resetBtn.TextColor3 = resetConfirmText
    resetGrad.Enabled = false
    tween(resetBg, {BackgroundColor3 = resetConfirmBg}, 0.18)
    tween(resetStroke, {Color = resetConfirmText, Transparency = 0.02, Thickness = 1.4}, 0.18)
  end

  function setResetDoneTheme()
    resetBtn.Text = "DONE - REJOINING..."
    resetBtn.TextColor3 = resetDoneText
    resetGrad.Enabled = false
    tween(resetBg, {BackgroundColor3 = resetDoneBg}, 0.18)
    tween(resetStroke, {Color = resetDoneText, Transparency = 0.02, Thickness = 1.4}, 0.18)
  end

  resetBtn.Text = "RESET ALL SETTINGS"

  resetBtn.MouseEnter:Connect(function()
    -- La scala si applica sempre (anche in stato "conferma"),
    -- il colore solo quando non siamo in conferma.
    tween(resetBg, {Size = UDim2.new(1, -8, 0, 44), Position = UDim2.new(0, 4, 0, 0)}, 0.12)
    if not confirmState then
      tween(resetBg, {BackgroundColor3 = resetHoverBg()}, 0.12)
    end
  end)

  resetBtn.MouseLeave:Connect(function()
    tween(resetBg, {Size = UDim2.new(1, -16, 0, 42), Position = UDim2.new(0, 8, 0, 1)}, 0.12)
    if not confirmState then
      tween(resetBg, {BackgroundColor3 = resetDefaultBg()}, 0.12)
    end
  end)

  resetBtn.MouseButton1Click:Connect(function()
    if not confirmState then
      confirmState = true
      setResetConfirmTheme()
      if confirmTimer then task.cancel(confirmTimer) end
      confirmTimer = task.delay(3, function()
        setResetDefaultTheme()
      end)
      return
    end
    if confirmTimer then
      task.cancel(confirmTimer)
      confirmTimer = nil
    end
    resetBtn.Text = "RESETTING..."
    pcall(function()
      local files = {
        CONFIG_FILE,
        KEYBINDS_CONFIG_FILE,
        "AmbitiousHub_Config.json",
        "AmbitiousHub_Config.json",
        "AmbitiousHub_Settings.json",
        "AmbitiousHub_Keybinds.json",
        "AmbitiousHub_GUI.json",
      }
      for _, fname in ipairs(files) do
        pcall(function()
          if fname and isfile and isfile(fname) and delfile then
            delfile(fname)
          end
        end)
      end
    end)
    pcall(function()
      ambitiousGuiScaleValue = 0.75
      ambitiousProgressBarScaleValue = 0.90
      NS = 59.5; CS = 28.8; LAGGER_SPEED = 29; LAGGER_CARRY_SPEED = 15
      currentSpeedMode = "Normal"
      autoCarrySpeedEnabled = false
      _G._AmbitiousAutoCarryMode = "NORMAL"
      _G._AmbitiousAS.locked = false; _G._AmbitiousAS.wasLow = false; _G._AmbitiousAS.savedMode = nil; _G._AmbitiousAS.restoring = false
      _G._AmbitiousAutoCarrySoft.animals = {}; _G._AmbitiousAutoCarrySoft.lastScan = 0
      autoTPHeight = 20
      -- >>> TP DOWN METHOD BEGIN
      _G._AmbitiousTPDownMethod = "NORMAL"
      if _G.AmbitiousRefreshTPDownMethodSelector then pcall(_G.AmbitiousRefreshTPDownMethodSelector) end
      -- <<< TP DOWN METHOD END
      autoStealEnabled = false; selectedStealMode = "Normal"; selectedSemiMode = "V3"; autoStealRadius = 62
      _G._AmbitiousSyncAfterHit.enabled = false; _stopSyncAfterHitWatcher()
      _G.AmbitiousStealRadii = {Normal = 62, Semi = 60}
      selectedAimbotMode = "V1"
      AIMBOT_SPEED = 82; LAGGER_AIMBOT_SPEED = 55
      _G._AmbitiousAimbotChase = { V1 = "NORMAL" }   -- single NORMAL chase mode
      _G.AmbitiousBatAimbotV2Speed = 58; _G.AmbitiousBatAimbotV2LaggerSpeed = 40;       mirrorTPDownEnabled = false;       -- ORDINE SPEGNIMENTO: prima l'Anti-Void
               _G.AmbitiousNormalAimbotOn = false; _G.AmbitiousBatAimbotV2On = false
      antiRagdollEnabled = false; _G._AmbitiousAntiRagdollMode = "V1"; infJumpEnabled = false; infJumpMode = "HOLD"; autoTPEnabled = false
      _G.AmbitiousLookAtEnabled = false; _G.AmbitiousLookAtRadius = 20
      if _G.AmbitiousStopLookAt then _G.AmbitiousStopLookAt() end
      batCounterEnabled = false; batCounterMode = "V1"; medCounterEnabled = false; antiKickEnabled = false
      espEnabled = false; showTrackerEnabled = false; ragdollCountdownEnabled = false
      fpsBoostEnabled = false; antiLagVisualEnabled = false; vividGraphicsEnabled = false; xrayEnabled = false; highPingWarningEnabled = false
      _G._AmbitiousKickWarn.enabled = false; _G._AmbitiousKickWarn.wasLow = false
      _G.AmbitiousUAKEnabled = false
      if _G.AmbitiousUltimateAntiKick then pcall(_G.AmbitiousUltimateAntiKick.clear) end
      if _G.AmbitiousRefreshUAKVisual then pcall(_G.AmbitiousRefreshUAKVisual) end
      if _G.AmbitiousDestroyKickWarning then pcall(_G.AmbitiousDestroyKickWarning) end
      _G._AmbitiousHPWNextAllowed = 0
      fovEnabled = false; fovValue = 70; noCamCollisionEnabled = false; _G.AmbitiousNoPlayerCollisionEnabled = false
      if _G.AmbitiousRefreshFovValueBox then pcall(_G.AmbitiousRefreshFovValueBox) end   -- >>> FOV VALUE ARROW <<<
      motionBlurEnabled = false
      if _motionBlurConn then pcall(function() _motionBlurConn:Disconnect() end); _motionBlurConn = nil end
      if _motionBlurEffect and _motionBlurEffect.Parent then _motionBlurEffect.Size = 0; _motionBlurEffect.Enabled = false end
      _motionBlurCurrentValue = 0
      if _SV.setMotionBlurVisual then _SV.setMotionBlurVisual(false) end
      skyTheme = "Off"; currentBackground = 1
      _introEnabled = true
      headlessEnabled = false; korbloxEnabled = false
      if setIntroVisual then setIntroVisual(_introEnabled) end
      stopIntroPlayback(); stopIntroPreview()
      autoLeftEnabled = false; autoRightEnabled = false
      selectedDropMode = "TP UP"
      _G.AmbitiousInstantResetVersion = 1
      if _G.AmbitiousRefreshInstantResetSelector then
        pcall(_G.AmbitiousRefreshInstantResetSelector)
      end
      if _G.AmbitiousRefreshDropMethodSelector then pcall(_G.AmbitiousRefreshDropMethodSelector) end   -- >>> DROP METHOD <<<
      _G.AmbitiousGuiLocked = false; _G.AmbitiousHideMobileButtons = false; _G.AmbitiousMobileButtonScale = 0.75
      _G.AmbitiousMobileHideList = {}   -- >>> HIDE PER BOTTONE <<<
      if _G.AmbitiousRefreshMobileHideList then pcall(_G.AmbitiousRefreshMobileHideList) end
      if AmbitiousUpdateGuiLockVisual then AmbitiousUpdateGuiLockVisual() end
      unwalkEnabled = false
      -- Reset animation pack
      selectedAnimPackIndex = 1
      _animPackSavedIndex = 1
      _animPackSystemEnabled = false
      _animPackUnwalkWasActive = false
      if _G.AmbitiousSetAnimPack then pcall(function() _G.AmbitiousSetAnimPack(1) end) end
      antiDieEnabled = false
      _G._AmbitiousAntiDieUserWanted = false
      _G._AmbitiousAntiDieAutoOn = false
      stretchCurrentIndex = 1    -- <-- AGGIUNGI
      stretchEnabled = false      -- <-- AGGIUNGI   
      _G.AmbitiousTrackerSavedStretchIndex = nil 
      -- Reset semi steal settings (Stop Time & Delay Radius)
if _G.AmbitiousSemiSteal then
    _G.AmbitiousSemiSteal.autoGrabStopTime = 1.29
    _G.AmbitiousSemiSteal.autoGrabStopPercent = 75
    _G.AmbitiousSemiSteal.autoGrabSetDelayRadius = 8
end
if _G.AmbitiousStopTimeBox then
    _G.AmbitiousStopTimeBox.Text = "1.29"
end
if _G.AmbitiousStopPctBox then
    _G.AmbitiousStopPctBox.Text = "75"
end
if _G.AmbitiousDelayRadBox then
    _G.AmbitiousDelayRadBox.Text = "8"
end

-- Reset tracker color
if BoxedESPOptions then
    BoxedESPOptions.trackerColor = Color3.fromRGB(255, 220, 70)
end

      ambitiousMainScale.Scale = ambitiousGuiScaleValue
      applyAmbitiousProgressBarScale()
      applyBackground(1)
      updateBackgroundButtons()
      applyDefaultAmbitiousKeybinds()
      -- Forza il reset di TUTTI i keybind ai valori di default
for keyId, defaultKey in pairs(DEFAULT_SPEED_KEYBINDS) do
    speedKeybinds[keyId] = defaultKey
end
      refreshAllSpeedKeybinds()
      refreshTPDownKeybind()
      if stopAutoTP then stopAutoTP() end
      if stopAntiRagdoll then stopAntiRagdoll() end
      if stopUnwalk then stopUnwalk() end
      if stopAntiDie then stopAntiDie() end
      if disableVividGraphics then pcall(disableVividGraphics) end
      if _SV.setVividGraphicsVisual then _SV.setVividGraphicsVisual(false) end
      if setXRay then pcall(setXRay, false) end
      if _SV.setXRayVisual then _SV.setXRayVisual(false) end
      -- >>> BRAINROT X-RAY <<<
      if _G.AmbitiousSetBrainrotXRay then pcall(_G.AmbitiousSetBrainrotXRay, false) end
      if _SV.setBrainrotXRayVisual then pcall(_SV.setBrainrotXRayVisual, false) end
      -- La hub potrebbe essere sbiadita dall'idle proprio mentre resetti:
      -- si riporta a piena visibilita', altrimenti resti a guardare i
      -- toggle appena resettati attraverso la trasparenza.
      if _G.AmbitiousIdleWake then pcall(_G.AmbitiousIdleWake) end
      if _SV.setMotionBlurVisual then _SV.setMotionBlurVisual(false) end
      if _SV.setHighPingWarningVisual then _SV.setHighPingWarningVisual(false) end
      if _SV.setKickWarningVisual then _SV.setKickWarningVisual(false) end
      if disableHeadless then pcall(disableHeadless) end
      if _SV.setHeadlessVisual then _SV.setHeadlessVisual(false) end
      if disableKorblox then pcall(disableKorblox) end
      if _SV.setKorbloxVisual then _SV.setKorbloxVisual(false) end
    
      -- >>> ANTI BAT BEGIN
      if _G.AmbitiousAntiBat then pcall(function() _G.AmbitiousAntiBat.setEnabled(false) end) end
      if _SV.setAntiBatVisual then _SV.setAntiBatVisual(false) end
      -- <<< ANTI BAT END
      -- Float spento col Reset: lo stato vive solo a runtime, ma il loop
      -- resterebbe attaccato e continuerebbe a tenerti in quota.
      pcall(function() if _G.AmbitiousFloatStop then _G.AmbitiousFloatStop() end end)
      -- >>> ANTI VOID BEGIN
      if _G.AmbitiousAntiVoid then pcall(function() _G.AmbitiousAntiVoid.setEnabled(false) end) end
      if _SV.setAntiVoidVisual then _SV.setAntiVoidVisual(false) end
      -- <<< ANTI VOID END
      if _G.AmbitiousTransparentTools then pcall(function() _G.AmbitiousTransparentTools.setEnabled(false) end) end
      if _SV.setTransparentToolsVisual then _SV.setTransparentToolsVisual(false) end
      if _G.AmbitiousCustomSounds then pcall(function() _G.AmbitiousCustomSounds.setEnabled(false) end) end
      if _SV.setCustomSoundsVisual then _SV.setCustomSoundsVisual(false) end

      if _G.StretchRez and _G.StretchRez.apply then
          _G.StretchRez.apply(1)
      end
      if normalSpeedBox then normalSpeedBox.Text = tostring(NS) end
      if carrySpeedBox then carrySpeedBox.Text = tostring(CS) end
      if laggerSpeedBox then laggerSpeedBox.Text = tostring(LAGGER_SPEED) end
      if laggerCarrySpeedBox then laggerCarrySpeedBox.Text = tostring(LAGGER_CARRY_SPEED) end
      if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
      if radiusBox then radiusBox.Text = tostring(autoStealRadius) end
      if setAutoStealVisual then setAutoStealVisual(false) end
      if _G.AmbitiousSetStealMode then _G.AmbitiousSetStealMode("Normal") end
      if _G.AmbitiousSetSemiSubModeVisual then _G.AmbitiousSetSemiSubModeVisual("V1") end
      if _G.AmbitiousRefreshAimbotSpeedBoxes then _G.AmbitiousRefreshAimbotSpeedBoxes() end
      if type(applyCustomSky) == "function" then applyCustomSky("Off") end
      if skyValueLabel then skyValueLabel.Text = "Off" end
      savedStealBarPositionTable = nil
      if _G.AmbitiousResetStealBarPosition then pcall(_G.AmbitiousResetStealBarPosition) end
      if _G.AmbitiousResetMobileButtons then _G.AmbitiousResetMobileButtons() end
      if _G.AmbitiousRefreshStretchSelector then _G.AmbitiousRefreshStretchSelector() end
      if _G.AmbitiousDuelsApplySavedGameplayStates then _G.AmbitiousDuelsApplySavedGameplayStates() end
      if _G.AmbitiousStopMedCounter then _G.AmbitiousStopMedCounter() end
      if _G.AmbitiousRefreshInfJumpModeSelector then _G.AmbitiousRefreshInfJumpModeSelector() end
      if _G.AmbitiousRefreshAntiRagdollModeSelector then _G.AmbitiousRefreshAntiRagdollModeSelector() end
      if _G.AmbitiousRefreshAutoCarryModeSelector then _G.AmbitiousRefreshAutoCarryModeSelector() end
      if _G.AmbitiousRefreshBatCounterModeSelector then _G.AmbitiousRefreshBatCounterModeSelector() end
      if _SV.setLookAtVisual then pcall(function() _SV.setLookAtVisual(false) end) end
      if _G.AmbitiousLookAtRadiusBox then _G.AmbitiousLookAtRadiusBox.Text = "20" end


      -- >>> RESET VISUALS BEGIN
      -- Dieci toggle venivano spenti nella logica ma la loro riga restava
      -- accesa a schermo: il reset non chiamava mai il loro setVisual.
      -- Il risultato era che dopo un Reset All Settings la GUI mentiva, e
      -- al rientro successivo (dove il config, salvato qui sotto, viene
      -- riletto) comparivano spenti senza che nessuno li avesse spenti.
      -- E' esattamente il caso di Synchronize After Hit.
      if _G._AmbitiousSyncAfterHit and _G._AmbitiousSyncAfterHit.setVisual then
        pcall(_G._AmbitiousSyncAfterHit.setVisual, false)
      end
      for _, _vn in ipairs({
        "setAntiDieVisual",
        "setAntiLagVisual",
        "setAutoTPVisual",
        "setFOVVisual",
        "setNoCamCollisionVisual",
        "setPlayerESPVisual",
        "setRagdollCountdownVisual",
        "setTrackerESPVisual",
        "setUnwalkVisual",
      }) do
        local _fn = _SV[_vn]
        if type(_fn) == "function" then pcall(_fn, false) end
      end
      -- <<< RESET VISUALS END

      saveAmbitiousConfig()
    end)
    task.wait(0.35)
    setResetDoneTheme()
    task.wait(0.6)
    pcall(function()
      local TeleportService = game:GetService("TeleportService")
      TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    end)
  end)
end

task.wait()
__AmbitiousDuelsSetupVisualsUI()
_G.__AmbitiousDuelsSetupSettingsUI()
if AmbitiousUpdateGuiLockVisual then AmbitiousUpdateGuiLockVisual() end
if _G.AmbitiousApplyMobileButtonsHidden then _G.AmbitiousApplyMobileButtonsHidden() end

-- ============================================================
-- RESTORE RUNTIME SETTINGS
-- ============================================================
-- Il config salva lo STATO dei toggle, ma alcuni moduli hanno anche bisogno
-- che venga ricreata la connessione/thread/effect. In precedenza, rieseguendo
-- lo script, poteva quindi succedere: toggle ON + funzione realmente OFF.
-- Questo passaggio viene eseguito una sola volta dopo che tutti i moduli sono
-- stati definiti, senza modificare o risalvare il config.
do
  local function safe(fn, ...)
    if type(fn) == "function" then
      pcall(fn, ...)
    end
  end

  -- Moduli movimento
  if autoTPEnabled then safe(startAutoTP) else safe(stopAutoTP) end
  if antiRagdollEnabled then safe(startAntiRagdoll) else safe(stopAntiRagdoll) end
  if antiDieEnabled then safe(startAntiDie, true) else safe(stopAntiDie, true) end
  if unwalkEnabled then safe(startUnwalk) else safe(stopUnwalk) end

  -- Camera / visual
  if fovEnabled then safe(enableCustomFov) else safe(disableCustomFov) end
  if noCamCollisionEnabled then safe(enableNoCamCollision) else safe(disableNoCamCollision) end
  if _G.AmbitiousNoPlayerCollisionEnabled then
    safe(enableNoPlayerCollision)
  else
    safe(disableNoPlayerCollision)
  end

  -- Performance / grafica
  if antiLagVisualEnabled then safe(enableAntiLag) else safe(disableAntiLag) end
  if vividGraphicsEnabled then safe(enableVividGraphics) else safe(disableVividGraphics) end
  if xrayEnabled then safe(setXRay, true) else safe(setXRay, false) end
  if _G.AmbitiousBrainrotXRayEnabled then
    safe(_G.AmbitiousSetBrainrotXRay, true)
  else
    safe(_G.AmbitiousSetBrainrotXRay, false)
  end

  -- Player cosmetics
  if headlessEnabled then safe(enableHeadless) else safe(disableHeadless) end
  if korbloxEnabled then safe(enableKorblox) else safe(disableKorblox) end

  -- ESP / tracker / ragdoll countdown
  if espEnabled then
    safe(startPlayerESP)
    if BoxedESPOptions then BoxedESPOptions.box = true end
  else
    safe(stopPlayerESP)
    if BoxedESPOptions then BoxedESPOptions.box = false end
  end
  if BoxedESPOptions then
    BoxedESPOptions.tracker = showTrackerEnabled == true
  end
  if refreshBoxedESP then safe(refreshBoxedESP) end

  if ragdollCountdownEnabled then
    safe(hookRagdollCountdown, LP.Character)
    safe(_G.AmbitiousStartEnemyRagdollCountdown)
  else
    safe(stopRagdollCountdown)
    safe(_G.AmbitiousStopEnemyRagdollCountdown)
  end

  -- Combat / counters
  if batCounterEnabled then safe(_G.AmbitiousStartBatCounter) else safe(_G.AmbitiousStopBatCounter) end
  if medCounterEnabled then safe(_G.AmbitiousStartMedCounter, LP.Character) else safe(_G.AmbitiousStopMedCounter) end

  -- Aimbot / TP Bat
  if _G.AmbitiousNormalAimbotOn then
    safe(_G.AmbitiousStartNormalAimbot)
  else
    safe(_G.AmbitiousStopNormalAimbot)
  end
  if _G.AmbitiousBatTPOn then
    safe(_G.AmbitiousStartBatTP)
  else
    safe(_G.AmbitiousStopBatTP)
  end

  -- Anti Bat / Anti Void / Transparent Tools
  if _G.AmbitiousAntiBat then
    safe(_G.AmbitiousAntiBat.setEnabled, _G.AmbitiousAntiBatEnabled == true)
  end
  if _G.AmbitiousAntiVoid then
    safe(_G.AmbitiousAntiVoid.setEnabled, _G.AmbitiousAntiVoidEnabled == true)
  end
  if _G.AmbitiousTransparentTools then
    safe(_G.AmbitiousTransparentTools.setEnabled, _G.AmbitiousTransparentToolsEnabled == true)
  end

  -- Auto Steal: riattiva lo scanner/loop corretto in base alla modalitÃ  salvata.
  if _G.AmbitiousAutoStealSync then
    safe(_G.AmbitiousAutoStealSync)
  end

  -- Look At Enemy
  if _G.AmbitiousLookAtEnabled then
    safe(_G.AmbitiousStartLookAt)
  else
    safe(_G.AmbitiousStopLookAt)
  end

  -- Animazioni
  if selectedAnimPackIndex and selectedAnimPackIndex >= 2 and _G.AmbitiousSetAnimPack then
    safe(_G.AmbitiousSetAnimPack, selectedAnimPackIndex)
  elseif selectedAnimPackIndex == 1 and _G.AmbitiousSetAnimPack then
    safe(_G.AmbitiousSetAnimPack, 1)
  end

  -- Jesus Mode
  if _G.AmbitiousJesusMode and _G.AmbitiousJesusMode.SetEnabled then
    safe(_G.AmbitiousJesusMode.SetEnabled, _G.AmbitiousJesusMode.enabled == true)
  end

  -- Keybind/UI state e valori visivi: non cambiano il config, sincronizzano
  -- solo ciÃ² che l'utente vede con lo stato realmente ripristinato.
  if _SV.setAutoTPVisual then safe(_SV.setAutoTPVisual, autoTPEnabled == true) end
  if _SV.setAntiRagdollVisual then safe(_SV.setAntiRagdollVisual, antiRagdollEnabled == true) end
  if _SV.setAntiDieVisual then safe(_SV.setAntiDieVisual, antiDieEnabled == true) end
  if _SV.setUnwalkVisual then safe(_SV.setUnwalkVisual, unwalkEnabled == true) end
  if _SV.setPlayerESPVisual then safe(_SV.setPlayerESPVisual, espEnabled == true) end
  if _SV.setTrackerESPVisual then safe(_SV.setTrackerESPVisual, showTrackerEnabled == true) end
  if _SV.setRagdollCountdownVisual then safe(_SV.setRagdollCountdownVisual, ragdollCountdownEnabled == true) end
  if _SV.setAntiLagVisual then safe(_SV.setAntiLagVisual, antiLagVisualEnabled == true) end
  if _SV.setVividGraphicsVisual then safe(_SV.setVividGraphicsVisual, vividGraphicsEnabled == true) end
  if _SV.setXRayVisual then safe(_SV.setXRayVisual, xrayEnabled == true) end
  if _SV.setHeadlessVisual then safe(_SV.setHeadlessVisual, headlessEnabled == true) end
  if _SV.setKorbloxVisual then safe(_SV.setKorbloxVisual, korbloxEnabled == true) end
  if _SV.setFOVVisual then safe(_SV.setFOVVisual, fovEnabled == true) end
  if _SV.setNoCamCollisionVisual then safe(_SV.setNoCamCollisionVisual, noCamCollisionEnabled == true) end
  if _G.AmbitiousSetNoPlayerCollisionVisual then safe(_G.AmbitiousSetNoPlayerCollisionVisual, _G.AmbitiousNoPlayerCollisionEnabled == true) end
  if _SV.setLookAtVisual then safe(_SV.setLookAtVisual, _G.AmbitiousLookAtEnabled == true) end
  if _SV.setAntiBatVisual then safe(_SV.setAntiBatVisual, _G.AmbitiousAntiBatEnabled == true) end
  if _SV.setAntiVoidVisual then safe(_SV.setAntiVoidVisual, _G.AmbitiousAntiVoidEnabled == true) end
  if _SV.setTransparentToolsVisual then safe(_SV.setTransparentToolsVisual, _G.AmbitiousTransparentToolsEnabled == true) end
  if _SV.setMotionBlurVisual then safe(_SV.setMotionBlurVisual, motionBlurEnabled == true) end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
  local isControllerInput = tostring(input.UserInputType):find("Gamepad") ~= nil
  local isMB3 = input.UserInputType == Enum.UserInputType.MouseButton3

  -- Helper: verifica se un keybind (KeyCode o "MB3") corrisponde all'input corrente
  local function isKeyMatch(boundKey)
    if not boundKey then return false end
    if boundKey == "MB3" then return isMB3 end
    return (not isMB3) and input.KeyCode == boundKey
  end

  if gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and not listeningForSpeedKey and not listeningForTPDownKey then return end
  if UserInputService:GetFocusedTextBox() then return end
  -- Lascia passare: tastiera, gamepad, oppure MB3 (durante listening o come tasto bindato)
  if input.UserInputType ~= Enum.UserInputType.Keyboard and not isControllerInput and not isMB3 then return end
  -- Blocca KeyCode.Unknown solo per input che NON sono MB3
  if not isMB3 and input.KeyCode == Enum.KeyCode.Unknown then return end


  if isKeyMatch(speedKeybinds.ToggleUI) then
    if Main.Visible then
      if _G.AmbitiousHubClose then _G.AmbitiousHubClose(true)
      else Main.Visible = false; MiniFrame.Visible = true end
    else
      if _G.AmbitiousHubOpen then _G.AmbitiousHubOpen()
      else Main.Visible = true; MiniFrame.Visible = false; Main.Size = FULL_MAIN_SIZE end
    end
    saveAmbitiousConfig()
    return
  end

  if listeningForSpeedKey then
    if tick() - (keybindListenStartedAt or 0) < 0.18 then return end
    local targetKey = listeningForSpeedKey
    -- Escape annulla il listening (solo tastiera)
    if not isMB3 and input.KeyCode == Enum.KeyCode.Escape then
      listeningForSpeedKey = nil
      refreshAllSpeedKeybinds()
      return
    end
    -- Backspace/Delete rimuove il binding (solo tastiera)
    if not isMB3 and (input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete) then
      speedKeybinds[targetKey] = nil
    else
      -- Il tasto da bindare: "MB3" oppure il KeyCode premuto
      local pressedKey = isMB3 and "MB3" or input.KeyCode
      -- Rimuove eventuali duplicati su altri keybind
      for otherKeyId, boundKey in pairs(speedKeybinds) do
        if otherKeyId ~= targetKey and boundKey == pressedKey then
          speedKeybinds[otherKeyId] = nil
        end
      end
      if tpDownKeybind == pressedKey then
        tpDownKeybind = nil
        refreshTPDownKeybind()
      end
      speedKeybinds[targetKey] = pressedKey
    end
    listeningForSpeedKey = nil
    refreshAllSpeedKeybinds()
    saveAmbitiousConfig()
    return
  end

  if listeningForTPDownKey then
    if tick() - (keybindListenStartedAt or 0) < 0.18 then return end
    if not isMB3 and input.KeyCode == Enum.KeyCode.Escape then
      listeningForTPDownKey = false
      refreshTPDownKeybind()
      return
    end
    if not isMB3 and (input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete) then
      tpDownKeybind = nil
    else
      local pressedKey = isMB3 and "MB3" or input.KeyCode
      for keyId, boundKey in pairs(speedKeybinds) do
        if boundKey == pressedKey then
          speedKeybinds[keyId] = nil
        end
      end
      tpDownKeybind = pressedKey
    end
    listeningForTPDownKey = false
    refreshAllSpeedKeybinds()
    refreshTPDownKeybind()
    saveAmbitiousConfig()
    return
  end

  if isKeyMatch(speedKeybinds.SpeedToggle) then
    toggleCarryMode()
    return
  end
  if isKeyMatch(speedKeybinds.LaggerToggle) then
    toggleLaggerMode()
    return
  end
  if isKeyMatch(speedKeybinds.BatBypass) then
    if _G.AmbitiousSafeModeIsLocked and _G.AmbitiousSafeModeIsLocked() then
      if _G.AmbitiousSafeModeForceStop then _G.AmbitiousSafeModeForceStop("SAFE MODE LOCK") end
      return
    end
    -- Toggle dedicato: spegne davvero conn + flag (prima Stop mancava e restava acceso)
    if type(_G.AmbitiousToggleSelectedAimbot) == "function" then
      pcall(_G.AmbitiousToggleSelectedAimbot)
    elseif _G.AmbitiousNormalAimbotOn == true then
      if type(_G.AmbitiousStopNormalAimbot) == "function" then pcall(_G.AmbitiousStopNormalAimbot) end
    else
      if type(_G.AmbitiousStartNormalAimbot) == "function" then pcall(_G.AmbitiousStartNormalAimbot) end
    end
    if _G.AmbitiousRefreshAimbotVisual then pcall(_G.AmbitiousRefreshAimbotVisual) end
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
    return
  end

  if isKeyMatch(speedKeybinds.DropBrainrot) then
    if selectedDropMode == "Stand Still" then
      runDropStandStill()
    else
      runDropBrainrot()
    end
    return
  end
  if isKeyMatch(speedKeybinds.AutoPlay) then
    if _G.AmbitiousAutoPlayToggle then _G.AmbitiousAutoPlayToggle() end
    return
  end
  if isKeyMatch(speedKeybinds.Float) then
    if _G.AmbitiousFloatToggle then _G.AmbitiousFloatToggle() end
    return
  end
  if isKeyMatch(speedKeybinds.InstantReset) then
    if _G.AmbitiousInstantReset then _G.AmbitiousInstantReset() end
    return
  end

  -- TP BAT: keybind reale. Deve stare nell'handler principale, non solo
  -- nella riga GUI del pannello Keybinds.
  if isKeyMatch(speedKeybinds.BatTP) then
    if type(_G.AmbitiousToggleBatTP) == "function" then
      pcall(_G.AmbitiousToggleBatTP)
    elseif _G.AmbitiousBatTPOn then
      if type(_G.AmbitiousStopBatTP) == "function" then pcall(_G.AmbitiousStopBatTP) end
    else
      if type(_G.AmbitiousStartBatTP) == "function" then pcall(_G.AmbitiousStartBatTP) end
    end
    if _G.AmbitiousRefreshBatTPVisual then pcall(_G.AmbitiousRefreshBatTPVisual) end
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
    return
  end

  if isKeyMatch(tpDownKeybind) then
    runTPFloor()
    return
  end
end)

-- TAB NAVIGATION FINAL FIX: assicura che tutti i 5 pannelli siano collegati e visibili.
for _, _tabName in ipairs(tabNames) do
  local _btn = tabButtons[_tabName]
  local _page = pages[_tabName]
  if _btn and _page then
    _btn.Active = true
    _btn.Selectable = true
    _btn.ZIndex = 30
    _page.ZIndex = 21
  end
end
setTab("MOVEMENT")
if Settings then
  Settings.CanvasPosition = Vector2.new(0, 0)
  Settings.Active = true
  Settings.ScrollBarThickness = 5
end

_G.__AmbitiousDuelsSetupStealBar = function()
  -- Safe Roma Steal Bar: black/orange, centered "Gesu Hub", no image/gradient
  -- dependencies that can cause client-side errors. Roma's public API is kept.
  local RunService = game:GetService("RunService")
  local UIS = UserInputService

  local old = PlayerGui:FindFirstChild("AmbitiousHubStealBarGui")
  if old then pcall(function() old:Destroy() end) end

  local W, H = 372, 54
  local ACCENT = Color3.fromRGB(255, 220, 70)
  local DARK = Color3.fromRGB(8, 8, 8)

  local gui = Instance.new("ScreenGui")
  gui.Name = "AmbitiousHubStealBarGui"
  gui.ResetOnSpawn = false
  gui.IgnoreGuiInset = true
  gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  gui.DisplayOrder = 50
  gui.Parent = PlayerGui

  local pbFrame = Instance.new("Frame")
  pbFrame.Name = "StealBar"
  pbFrame.Size = UDim2.fromOffset(W, H)
  pbFrame.Position = tableToUDim2(savedStealBarPositionTable, UDim2.new(0.5, -math.floor(W/2), 1, -134))
  pbFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  pbFrame.BackgroundTransparency = 1
  pbFrame.BorderSizePixel = 0
  pbFrame.Active = true
  pbFrame.ClipsDescendants = true
  pbFrame.Parent = gui
  corner(pbFrame, 8)

  local jesusBarImage = Instance.new("ImageLabel")
  jesusBarImage.Name = "JesusImage"
  jesusBarImage.Size = UDim2.fromScale(1, 1)
  jesusBarImage.Position = UDim2.fromScale(0, 0)
  jesusBarImage.BackgroundTransparency = 1
  jesusBarImage.Image = ROMA_HUB_COLOSSEO_IMAGE
  jesusBarImage.ScaleType = Enum.ScaleType.Crop
  jesusBarImage.ImageTransparency = 0.12
  jesusBarImage.ZIndex = 1
  jesusBarImage.Parent = pbFrame
  corner(jesusBarImage, 8)

  local jesusBarShade = Instance.new("Frame")
  jesusBarShade.Name = "JesusImageShade"
  jesusBarShade.Size = UDim2.fromScale(1, 1)
  jesusBarShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  jesusBarShade.BackgroundTransparency = 0.48
  jesusBarShade.BorderSizePixel = 0
  jesusBarShade.ZIndex = 2
  jesusBarShade.Parent = pbFrame
  corner(jesusBarShade, 8)

  local stroke = Instance.new("UIStroke")
  stroke.Color = ACCENT
  stroke.Thickness = 1
  stroke.Transparency = 0.15
  stroke.Parent = pbFrame

  local scale = Instance.new("UIScale")
  scale.Name = "AmbitiousProgressBarScale"
  scale.Scale = ambitiousProgressBarScaleValue or 1
  scale.Parent = pbFrame

  local title = Instance.new("TextLabel")
  title.Name = "GesuHubCenterLabel"
  title.BackgroundTransparency = 1
  title.Size = UDim2.fromOffset(170, 24)
  title.Position = UDim2.new(0.5, -85, 0, 3)
  title.RichText = true
  title.Text = "<font color=\"#FFD83D\">Gesu</font> <font color=\"#FFFFFF\">Hub</font>"
  title.TextColor3 = Color3.fromRGB(255,255,255)
  title.Font = Enum.Font.GothamBlack
  title.TextSize = 18
  title.TextXAlignment = Enum.TextXAlignment.Center
  title.ZIndex = 21
  title.Parent = pbFrame

  local titleLine = Instance.new("Frame")
  titleLine.Name = "GesuHubCenterAccent"
  titleLine.Size = UDim2.fromOffset(82, 2)
  titleLine.Position = UDim2.new(0.5, -41, 0, 27)
  titleLine.BackgroundColor3 = ACCENT
  titleLine.BorderSizePixel = 0
  titleLine.Parent = pbFrame
  corner(titleLine, 2)

  local track = Instance.new("Frame")
  track.Name = "VX7StealTrack"
  track.Size = UDim2.fromOffset(258, 13)
  track.Position = UDim2.fromOffset(101, 36)
  -- Track vuoto nero: solo la parte completata segue la percentuale in arancione.
  track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  track.BorderSizePixel = 0
  track.ClipsDescendants = true
  track.ZIndex = 21
  track.Parent = pbFrame
  corner(track, 13)

  local fill = Instance.new("Frame")
  fill.Name = "StealFill"
  fill.Size = UDim2.new(0, 0, 1, 0)
  -- Fill arancione proporzionale alla percentuale.
  fill.BackgroundColor3 = ACCENT
  fill.BorderSizePixel = 0
  fill.Parent = track
  corner(fill, 13)

  local pct = Instance.new("TextLabel")
  pct.Name = "StealPercent"
  pct.BackgroundTransparency = 0
  pct.BackgroundColor3 = DARK
  pct.Size = UDim2.fromOffset(72, 18)
  pct.Position = UDim2.fromOffset(14, 32)
  pct.Text = "0%"
  pct.TextColor3 = Color3.fromRGB(255, 255, 255)
  pct.Font = Enum.Font.GothamBold
  pct.TextSize = 10
  pct.TextXAlignment = Enum.TextXAlignment.Left
  pct.ZIndex = 21
  pct.Parent = pbFrame

  local status = Instance.new("TextLabel")
  status.Name = "StealStatus"
  status.BackgroundTransparency = 1
  status.Size = UDim2.fromOffset(80, 14)
  status.Position = UDim2.fromOffset(14, 17)
  status.Text = "STEAL"
  status.TextColor3 = ACCENT
  status.Font = Enum.Font.GothamBold
  status.TextSize = 8
  status.TextXAlignment = Enum.TextXAlignment.Left
  status.ZIndex = 21
  status.Parent = pbFrame

  local fps = Instance.new("TextLabel")
  fps.Name = "StealFpsValue"
  fps.BackgroundTransparency = 1
  fps.Size = UDim2.fromOffset(55, 14)
  fps.Position = UDim2.fromOffset(275, 4)
  fps.Text = "FPS 0"
  fps.TextColor3 = Color3.fromRGB(200, 200, 200)
  fps.Font = Enum.Font.GothamMedium
  fps.TextSize = 8
  fps.TextXAlignment = Enum.TextXAlignment.Right
  fps.ZIndex = 21
  fps.Parent = pbFrame

  local ping = Instance.new("TextLabel")
  ping.Name = "StealPingValue"
  ping.BackgroundTransparency = 1
  ping.Size = UDim2.fromOffset(55, 14)
  ping.Position = UDim2.fromOffset(275, 18)
  ping.Text = "PING 0ms"
  ping.TextColor3 = Color3.fromRGB(200, 200, 200)
  ping.Font = Enum.Font.GothamMedium
  ping.TextSize = 8
  ping.TextXAlignment = Enum.TextXAlignment.Right
  ping.ZIndex = 21
  ping.Parent = pbFrame

  local dragging, dragStart, startPos = false, nil, nil
  local drag = Instance.new("TextButton")
  drag.Name = "DragOverlay"
  drag.Size = UDim2.fromScale(1, 1)
  drag.BackgroundTransparency = 1
  drag.Text = ""
  drag.AutoButtonColor = false
  drag.ZIndex = 20
  drag.Parent = pbFrame
  -- Keep labels above the transparent drag surface while still allowing drag.
  for _, obj in ipairs(pbFrame:GetChildren()) do
    if obj:IsA("TextLabel") or obj.Name == "VX7StealTrack" then obj.ZIndex = 21 end
  end

  drag.InputBegan:Connect(function(input)
    if _G.AmbitiousGuiLocked == true then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      dragStart = input.Position
      startPos = pbFrame.Position
      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
          dragging = false
          savedStealBarPositionTable = udim2ToTable(pbFrame.Position)
          pcall(saveAmbitiousConfig)
        end
      end)
    end
  end)

  local inputConn = UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
      local d = input.Position - dragStart
      pbFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
  end)

  pbFrame:GetPropertyChangedSignal("Position"):Connect(function()
    savedStealBarPositionTable = udim2ToTable(pbFrame.Position)
  end)

  _G.AmbitiousStealBarDefaultPosition = UDim2.new(0.5, -math.floor(W/2), 1, -134)
  _G.AmbitiousResetStealBarPosition = function()
    if pbFrame.Parent then
      pbFrame.Position = _G.AmbitiousStealBarDefaultPosition
      savedStealBarPositionTable = udim2ToTable(pbFrame.Position)
    else
      savedStealBarPositionTable = nil
    end
  end
  _G.AmbitiousApplyStealBarPosition = function()
    if pbFrame.Parent then
      pbFrame.Position = tableToUDim2(savedStealBarPositionTable, _G.AmbitiousStealBarDefaultPosition)
      savedStealBarPositionTable = udim2ToTable(pbFrame.Position)
    end
  end
  _G.AmbitiousApplyProgressBarScale = function()
    if scale.Parent then scale.Scale = ambitiousProgressBarScaleValue or 1 end
  end
  _G.AmbitiousStealBarSyncBackground = function() return false end

  local targetP, shownP = 0, 0
  local state = "IDLE"
  local alive = true
  gui.AncestryChanged:Connect(function(_, parent)
    if not parent then
      alive = false
      pcall(function() inputConn:Disconnect() end)
    end
  end)

  local renderConn = RunService.RenderStepped:Connect(function(dt)
    if not alive or not pbFrame.Parent then
      pcall(function() renderConn:Disconnect() end)
      return
    end
    local alpha = 1 - math.exp(-32 * math.min(dt, 0.1))
    shownP = shownP + (targetP - shownP) * alpha
    if math.abs(targetP - shownP) < 0.003 then shownP = targetP end
    fill.Size = UDim2.new(math.clamp(shownP, 0, 1), 0, 1, 0)
    pct.Text = tostring(math.floor(shownP * 100 + 0.5)) .. "%"
  end)

  local StealBar = {}
  function StealBar.SetProgress(p)
    targetP = math.clamp(tonumber(p) or 0, 0, 1)
  end
  function StealBar.Reset()
    targetP, shownP = 0, 0
    fill.Size = UDim2.new(0, 0, 1, 0)
    pct.Text = "0%"
    status.Text = "STEAL"
    status.TextColor3 = ACCENT
  end
  function StealBar.SetState(s)
    state = tostring(s or "IDLE"):upper()
    status.Text = (state == "IDLE") and "STEAL" or state
    status.TextColor3 = ACCENT
  end
  StealBar.Reset()

  -- FPS reale: contiamo ogni frame da RenderStepped, non ogni task.wait.
  -- In questo modo il valore non viene falsato dal throttling dello scheduler.
  do
    local fpsFrames = 0
    local fpsElapsed = 0
    local lastPingUpdate = 0
    local fpsConn
    fpsConn = RunService.RenderStepped:Connect(function(dt)
      if not alive or not pbFrame.Parent then
        pcall(function() fpsConn:Disconnect() end)
        return
      end

      fpsFrames += 1
      fpsElapsed += math.max(dt or 0, 0)

      -- Aggiornamento abbastanza frequente da essere reattivo, ma stabile.
      if fpsElapsed >= 0.5 then
        local f = math.floor((fpsFrames / fpsElapsed) + 0.5)
        fpsFrames = 0
        fpsElapsed = 0

        local now = tick()
        if now - lastPingUpdate >= 0.45 then
          local p = 0
          pcall(function()
            -- GetNetworkPing restituisce i secondi di latenza.
            p = math.floor((LP:GetNetworkPing() * 1000) + 0.5)
          end)
          ping.Text = "PING " .. tostring(p) .. "ms"
          lastPingUpdate = now
        end

        fps.Text = "FPS " .. tostring(f)
      end
    end)
  end

  task.defer(function() pcall(_G.AmbitiousApplyProgressBarScale) end)
  _G.StealBar = StealBar
end

_G.__AmbitiousDuelsSetupStealBar()
if _G.AmbitiousAutoStealSync then task.defer(_G.AmbitiousAutoStealSync) end

_G.__AmbitiousDuelsSetupMinimizeToggle = function()
  _G.__AmbitiousDuelsMinimized = false
  Close.MouseButton1Click:Connect(function()
    -- Si guarda lo stato REALE della finestra, non un flag che puo' essere
    -- rimasto indietro.
    if Main.Visible then
      if _G.AmbitiousHubClose then _G.AmbitiousHubClose(true)
      else _G.__AmbitiousDuelsMinimized = true; Main.Visible = false; MiniFrame.Visible = true end
    else
      if _G.AmbitiousHubOpen then _G.AmbitiousHubOpen()
      else _G.__AmbitiousDuelsMinimized = false; Main.Visible = true; MiniFrame.Visible = false; Main.Size = FULL_MAIN_SIZE end
    end
    saveAmbitiousConfig()
  end)
end

_G.__AmbitiousDuelsSetupMinimizeToggle()

_G.__AmbitiousDuelsRunIntro = function()
  local TS = TweenService
  local introGuiParent = Gui and Gui.Parent or HubGui
  local origSize = FULL_MAIN_SIZE or Main.Size
  local wasMinimizedBeforeIntro = (_G.__AmbitiousDuelsMinimized == true)

  if not _introEnabled then
    stopIntroPlayback()
    stopIntroPreview()
    Main.Size = origSize
    if not wasMinimizedBeforeIntro then
      Main.Visible = true
      MiniFrame.Visible = false
    else
      Main.Visible = false
      MiniFrame.Visible = true
    end
    return
  end

  playIntroMusic()
  Main.Visible = false
  MiniFrame.Visible = false
  Main.Size = UDim2.new(0, 0, 0, 0)

  task.spawn(function()
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "AmbitiousHubIntro"
    introGui.IgnoreGuiInset = true
    introGui.DisplayOrder = 100
    introGui.ResetOnSpawn = false
    introGui.Parent = introGuiParent
    local introActive = true

    function finishIntro()
      if not introActive then return end
      introActive = false
      stopIntroPlayback()
      MiniFrame.Visible = false
      Main.Visible = true
      pcall(function()
        TS:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = origSize}):Play()
      end)
      task.delay(0.75, function()
        pcall(function() introGui:Destroy() end)
      end)
    end

    local darkBg = Instance.new("Frame", introGui)
    darkBg.Size = UDim2.new(1, 0, 1, 0)
    darkBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    darkBg.BackgroundTransparency = 1
    darkBg.BorderSizePixel = 0
    darkBg.ZIndex = 1

    local bgGrad = Instance.new("UIGradient", darkBg)
    bgGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
      ColorSequenceKeypoint.new(0.45, Color3.fromRGB(0, 0, 0)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    bgGrad.Rotation = 90

    local redWash = Instance.new("Frame", introGui)
    redWash.Size = UDim2.new(1,0,1,0)
    redWash.BackgroundColor3 = Color3.fromRGB(255,255,255)
    redWash.BackgroundTransparency = 1
    redWash.BorderSizePixel = 0
    redWash.ZIndex = 2

local skipBtn = Instance.new("TextButton", introGui)
skipBtn.Name = "SkipIntro"
skipBtn.AnchorPoint = Vector2.new(1,0)
skipBtn.Position = UDim2.new(1,-22,0,22)
skipBtn.Size = UDim2.new(0,104,0,34)
skipBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- base
skipBtn.BackgroundTransparency = 0
skipBtn.BorderSizePixel = 0
skipBtn.Text = "SKIP INTRO"
skipBtn.TextColor3 = Color3.fromRGB(0, 0, 0)  -- TESTO NERO
skipBtn.TextSize = 11
skipBtn.Font = Enum.Font.GothamBlack
skipBtn.AutoButtonColor = false
skipBtn.ZIndex = 80
Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0,10)

-- Gradiente (i colori verranno aggiornati)
local grad = Instance.new("UIGradient", skipBtn)
grad.Rotation = 0
grad.Transparency = NumberSequence.new(0)

-- Colori iniziali (galattici)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
})

-- Funzione per ruotare le tonalitÃ  (hue) di un colore
local function shiftHue(color, offset)
    local r, g, b = color.R, color.G, color.B
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local h, s, v
    v = max
    local d = max - min
    s = (max == 0) and 0 or d / max
    if max == min then
        h = 0
    else
        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        else
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    h = (h + offset) % 1
    local function hueToRgb(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < 1/6 then return p + (q - p) * 6 * t end
        if t < 1/2 then return q end
        if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
        return p
    end
    if s == 0 then
        return Color3.fromRGB(v, v, v)
    end
    local q = v * (1 - s * (1 - (h * 6 % 1)))
    local p = v * (1 - s)
    local tr = v
    local tg = v
    local tb = v
    if h < 1/6 then
        tr = v
        tg = v * (1 - s * (1 - (h * 6)))
        tb = v * (1 - s)
    elseif h < 1/3 then
        tr = v * (1 - s * (h * 6 - 1))
        tg = v
        tb = v * (1 - s)
    elseif h < 1/2 then
        tr = v * (1 - s)
        tg = v
        tb = v * (1 - s * (1 - (h * 6 - 2)))
    elseif h < 2/3 then
        tr = v * (1 - s)
        tg = v * (1 - s * (h * 6 - 3))
        tb = v
    elseif h < 5/6 then
        tr = v * (1 - s * (1 - (h * 6 - 4)))
        tg = v * (1 - s)
        tb = v
    else
        tr = v
        tg = v * (1 - s)
        tb = v * (1 - s * (h * 6 - 5))
    end
    return Color3.new(tr, tg, tb)
end

-- Animazione: cambia i colori lentamente
task.spawn(function()
    local hueOffset = 0
    local speed = 0.002  -- velocitÃ  lenta per effetto morbido
    while skipBtn and skipBtn.Parent do
        hueOffset = (hueOffset + speed) % 1
        
        -- Colori base (galattici) con tonalitÃ  spostata
        local c1 = shiftHue(Color3.fromRGB(255, 220, 70), hueOffset)
        local c2 = shiftHue(Color3.fromRGB(0, 0, 0), hueOffset)
        local c3 = shiftHue(Color3.fromRGB(0, 0, 0), hueOffset)
        
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, c1),
            ColorSequenceKeypoint.new(0.50, c2),
            ColorSequenceKeypoint.new(1.00, c3),
        })
        
        task.wait(0.05)
    end
end)

skipBtn.MouseButton1Click:Connect(finishIntro)

-- INTRO SOLO TESTO: GESU HUB parte da sinistra e scorre fino al centro.
-- Nessuna foto/immagine viene mostrata. La musica dell'intro resta quella
-- gia' gestita da playIntroMusic() e non viene modificata.
local center = Instance.new("Frame", introGui)
center.AnchorPoint = Vector2.new(0.5,0.5)
center.Position = UDim2.new(0.5,0,0.5,0)
center.Size = UDim2.new(0,660,0,120)
center.BackgroundTransparency = 1
center.ClipsDescendants = false
center.ZIndex = 40

local titleShadow = Instance.new("TextLabel", center)
titleShadow.AnchorPoint = Vector2.new(0.5,0.5)
titleShadow.Size = UDim2.new(0,900,0,140)
titleShadow.Position = UDim2.new(0, -700, 0.5, 4)
titleShadow.BackgroundTransparency = 1
titleShadow.RichText = true
titleShadow.Text = "<font color=\"#000000\">Gesu Hub</font>"
titleShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
titleShadow.Font = Enum.Font.GothamBlack
titleShadow.TextSize = 110
titleShadow.TextTransparency = 1
titleShadow.TextStrokeTransparency = 1
titleShadow.ZIndex = 42

local title = Instance.new("TextLabel", center)
title.AnchorPoint = Vector2.new(0.5,0.5)
title.Size = UDim2.new(0,900,0,140)
title.Position = UDim2.new(0, -700, 0.5, 0)
title.BackgroundTransparency = 1
title.RichText = true
title.Text = "<font color=\"#FFD83D\">Gesu</font> <font color=\"#FFFFFF\">Hub</font>"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 110
title.TextTransparency = 1
title.TextStrokeTransparency = 1
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
title.ZIndex = 43

    TS:Create(darkBg, TweenInfo.new(0.65), {BackgroundTransparency = 0.22}):Play()
    task.wait(0.85)

    -- GESU HUB entra da sinistra, poi si ferma perfettamente al centro.
    task.wait(0.15)
    TS:Create(titleShadow, TweenInfo.new(0.75, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
      Position = UDim2.new(0.5, 4, 0.5, 4),
      TextTransparency = 0.35
    }):Play()
    TS:Create(title, TweenInfo.new(0.75, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
      Position = UDim2.new(0.5, 0, 0.5, 0),
      TextTransparency = 0,
      TextStrokeTransparency = 0.18
    }):Play()

    task.wait(0.9)
    if not introActive then return end

    TS:Create(center, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)}):Play()
    TS:Create(title, TweenInfo.new(0.36), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    TS:Create(titleShadow, TweenInfo.new(0.36), {TextTransparency = 1}):Play()
    TS:Create(darkBg, TweenInfo.new(0.75), {BackgroundTransparency = 1}):Play()

    Main.Visible = true
    MiniFrame.Visible = false
    TS:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = origSize}):Play()
    task.wait(2.9)
    introActive = false
    pcall(function() introGui:Destroy() end)
  end)
end

-- Start with a visible hub. The intro may temporarily hide it, but the rescue below
-- always restores either the full panel or the small opener.
Main.Visible = false
Main.Size = FULL_MAIN_SIZE
MiniFrame.Visible = false
_G.__AmbitiousDuelsRunIntro()

-- ===== END FINAL THEME PASS =====



-- ============================================================
-- MOBILE BUTTONS PATCH
-- Ricrea i nove pulsanti touch gia' previsti dalle impostazioni.
-- ============================================================
if not _G.__AmbitiousBuildMobileButtons_PATCHED_V2 then
  _G.__AmbitiousBuildMobileButtons_PATCHED_V2 = true
  task.defer(function()
    local ok, err = pcall(function()
      local UIS = game:GetService("UserInputService")
      local Players = game:GetService("Players")
      local player = Players.LocalPlayer
      local playerGui = player and player:WaitForChild("PlayerGui", 10)
      if not playerGui then return end

      local oldGui = playerGui:FindFirstChild("AmbitiousMobileButtonsGui")
      if oldGui then oldGui:Destroy() end

      local gui = Instance.new("ScreenGui")
      gui.Name = "AmbitiousMobileButtonsGui"
      gui.ResetOnSpawn = false
      gui.IgnoreGuiInset = true
      gui.DisplayOrder = 100
      gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
      gui.Enabled = true
      gui.Parent = playerGui

      _G.AmbitiousMobileButtonRefs = {}
      -- Rispetta la scelta salvata dell'utente.
      _G.AmbitiousHideMobileButtons = _G.AmbitiousHideMobileButtons == true
      _G.AmbitiousMobileButtonScale = tonumber(_G.AmbitiousMobileButtonScale) or 0.75
      _G.AmbitiousMobileButtonPositions = _G.AmbitiousMobileButtonPositions or {}

      local defs = {
        {key="drop", label="DROP BR", size=1},
        {key="autoPlay", label="AUTO PLAY", size=1},
        {key="aimbot", label="BAT\nAIMBOT", size=1},
        {key="batTP", label="TP BAT", size=1},
        {key="instantReset", label="INSTANT\nRESET", size=1},
        {key="tp", label="TP DOWN", size=1},
        {key="carry", label="CARRY\nSPEED", size=1},
        {key="laggerNormal", label="LAGGER\nNORMAL", size=1},
        {key="laggerCarry", label="LAGGER\nCARRY", size=1},
      }

      local baseW, baseH, gap = 88, 48, 7
      local function buttonActive(key)
        if key == "autoPlay" then return _G.AmbitiousAutoPlay and _G.AmbitiousAutoPlay.active and _G.AmbitiousAutoPlay.active() or false end
        if key == "aimbot" then return _G.AmbitiousBatAimbotV2On == true or _G.AceAntiBypassAimbotOn == true end
        if key == "batTP" then return _G.AmbitiousBatTPOn == true end
        if key == "carry" then return currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry" end
        if key == "laggerNormal" then return currentSpeedMode == "Lagger" end
        if key == "laggerCarry" then return currentSpeedMode == "Lagger Carry" end
        return false
      end

      local function safeSave()
        if type(saveAmbitiousConfig) == "function" then pcall(saveAmbitiousConfig) end
      end

      local function runAction(key)
        if key == "drop" then
          if selectedDropMode == "Stand Still" then
            if type(runDropStandStill) == "function" then runDropStandStill()
            elseif type(runDropBrainrot) == "function" then runDropBrainrot() end
          elseif type(runDropBrainrot) == "function" then
            runDropBrainrot()
          end
        elseif key == "autoPlay" then
          if type(_G.AmbitiousAutoPlayToggle) == "function" then _G.AmbitiousAutoPlayToggle() end
        elseif key == "aimbot" then
          if _G.AmbitiousSafeModeIsLocked and _G.AmbitiousSafeModeIsLocked() then
            if _G.AmbitiousSafeModeForceStop then _G.AmbitiousSafeModeForceStop("SAFE MODE LOCK") end
            return
          end
          if type(_G.AmbitiousToggleSelectedAimbot) == "function" then _G.AmbitiousToggleSelectedAimbot() end
          if _G.AmbitiousRefreshAimbotVisual then pcall(_G.AmbitiousRefreshAimbotVisual) end
        elseif key == "batTP" then
          if type(_G.AmbitiousToggleBatTP) == "function" then _G.AmbitiousToggleBatTP()
          elseif _G.AmbitiousBatTPOn and type(_G.AmbitiousStopBatTP) == "function" then _G.AmbitiousStopBatTP()
          elseif type(_G.AmbitiousStartBatTP) == "function" then _G.AmbitiousStartBatTP() end
          if _G.AmbitiousRefreshBatTPVisual then pcall(_G.AmbitiousRefreshBatTPVisual) end
        elseif key == "instantReset" then
          if type(_G.AmbitiousInstantReset) == "function" then _G.AmbitiousInstantReset() end
        elseif key == "tp" then
          if type(runTPFloor) == "function" then runTPFloor() end
        elseif key == "carry" then
          if currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry" then
            setSpeedMode("Normal")
          else
            setSpeedMode("Carry")
          end
        elseif key == "laggerNormal" then
          if currentSpeedMode == "Lagger" then setSpeedMode("Normal")
          else setSpeedMode("Lagger") end
        elseif key == "laggerCarry" then
          if currentSpeedMode == "Lagger Carry" then setSpeedMode("Normal")
          else setSpeedMode("Lagger Carry") end
        end
        safeSave()
      end

      local function refreshOne(key, entry)
        if not entry or not entry.btn then return end
        local active = buttonActive(key)
        entry.btn.BackgroundColor3 = active and Color3.fromRGB(255, 205, 45) or Color3.fromRGB(18, 18, 18)
        entry.btn.TextColor3 = active and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(255, 255, 255)
        local label = entry.btn:FindFirstChild("ButtonText")
        if label then
          label.TextColor3 = active and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(255, 255, 255)
          if key == "autoPlay" and not (_G.AmbitiousAutoPlay and _G.AmbitiousAutoPlay.side) then
            label.Text = "AUTO PLAY\nWAIT"
          end
        end
        local hide = _G.AmbitiousHideMobileButtons == true and _G.AmbitiousMobileHideIncluded and _G.AmbitiousMobileHideIncluded(key)
        entry.holder.Visible = not hide
      end

      for i, def in ipairs(defs) do
        local holder = Instance.new("Frame")
        holder.Name = "Mobile_" .. def.key
        holder.BackgroundTransparency = 1
        holder.BorderSizePixel = 0
        holder.Size = UDim2.fromOffset(baseW, baseH)
        local col = (i-1) % 3
        local row = math.floor((i-1) / 3)
        local defaultPos = UDim2.new(1, -(baseW + 12) * (3-col) + 4, 0.55, (row-1) * (baseH+gap))
        local saved = _G.AmbitiousMobileButtonPositions[def.key]
        if type(tableToUDim2) == "function" then
          holder.Position = tableToUDim2(saved, defaultPos)
        else
          holder.Position = defaultPos
        end
        holder.ZIndex = 100
        holder.Parent = gui

        local btn = Instance.new("TextButton")
        btn.Name = "MobileButton"
        btn.Size = UDim2.fromScale(1, 1)
        btn.Position = UDim2.fromScale(0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        btn.BackgroundTransparency = 0.08
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Text = ""
        btn.TextScaled = false
        btn.ZIndex = 101
        btn.Parent = holder
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = btn
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 210, 55)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.05
        stroke.Parent = btn
        local txt = Instance.new("TextLabel")
        txt.Name = "ButtonText"
        txt.BackgroundTransparency = 1
        txt.Size = UDim2.new(1, -4, 1, -4)
        txt.Position = UDim2.fromOffset(2, 2)
        txt.Font = Enum.Font.GothamBold
        txt.Text = def.label
        txt.TextSize = 11
        txt.TextWrapped = true
        txt.TextColor3 = Color3.fromRGB(255,255,255)
        txt.TextStrokeTransparency = 0.7
        txt.ZIndex = 102
        txt.Parent = btn

        local entry = {holder=holder, btn=btn, key=def.key, baseW=baseW, baseH=baseH}
        _G.AmbitiousMobileButtonRefs[def.key] = entry

        local dragging, dragStart, startPos, moved = false, nil, nil, false
        btn.InputBegan:Connect(function(input)
          if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = holder.Position
            local ended
            ended = input.Changed:Connect(function()
              if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if ended then ended:Disconnect() end
                if moved then
                  _G.AmbitiousMobileButtonPositions[def.key] = type(udim2ToTable) == "function" and udim2ToTable(holder.Position) or nil
                  safeSave()
                end
              end
            end)
          end
        end)
        UIS.InputChanged:Connect(function(input)
          if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            if math.abs(delta.X) + math.abs(delta.Y) > 8 then moved = true end
            if moved then
              holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
          end
        end)
        btn.Activated:Connect(function()
          if moved then return end
          local success, actionErr = pcall(runAction, def.key)
          if not success then warn("[MobileButton] " .. def.key .. ": " .. tostring(actionErr)) end
          for key, ref in pairs(_G.AmbitiousMobileButtonRefs) do refreshOne(key, ref) end
        end)
      end

      _G.AmbitiousApplyMobileButtonSize = function()
        local scale = math.clamp(tonumber(_G.AmbitiousMobileButtonScale) or 0.75, 0.30, 1.35)
        for _, entry in pairs(_G.AmbitiousMobileButtonRefs or {}) do
          if entry.holder then entry.holder.Size = UDim2.fromOffset(baseW * scale, baseH * scale) end
          local label = entry.btn and entry.btn:FindFirstChild("ButtonText")
          if label then label.TextSize = math.clamp(math.floor(11 * scale + 0.5), 8, 16) end
        end
      end

      _G.AmbitiousApplyMobileButtonsHidden = function()
        for key, entry in pairs(_G.AmbitiousMobileButtonRefs or {}) do refreshOne(key, entry) end
      end

      _G.AmbitiousRefreshMobileButtonStates = function()
        for key, entry in pairs(_G.AmbitiousMobileButtonRefs or {}) do refreshOne(key, entry) end
      end

      _G.AmbitiousResetMobileButtons = function()
        _G.AmbitiousMobileButtonScale = 0.75
        _G.AmbitiousHideMobileButtons = false
        _G.AmbitiousMobileButtonPositions = {}
        local index = 0
        for _, def in ipairs(defs) do
          index = index + 1
          local entry = _G.AmbitiousMobileButtonRefs[def.key]
          if entry and entry.holder then
            local col = (index-1) % 3
            local row = math.floor((index-1) / 3)
            entry.holder.Position = UDim2.new(1, -(baseW + 12) * (3-col) + 4, 0.55, (row-1) * (baseH+gap))
          end
        end
        _G.AmbitiousApplyMobileButtonSize()
        _G.AmbitiousApplyMobileButtonsHidden()
        safeSave()
      end

      _G.AmbitiousApplyMobileButtonSize()
      _G.AmbitiousApplyMobileButtonsHidden()
      task.spawn(function()
        while gui.Parent do
          task.wait(0.35)
          if _G.AmbitiousRefreshMobileButtonStates then
            pcall(_G.AmbitiousRefreshMobileButtonStates)
          end
        end
      end)
    end)
    if not ok then warn("[MobileButtonsPatch] " .. tostring(err)) end
  end)
end


-- ============================================================
-- MOBILE TOUCH INTERACTION FIX V4
-- Make existing UI buttons touch/selectable on mobile and ensure
-- toggle rows are hit-testable without changing their callbacks.
-- ============================================================
if not _G.__AmbitiousMobileTouchFixV4 then
  _G.__AmbitiousMobileTouchFixV4 = true
  task.defer(function()
    local ok, err = pcall(function()
      local Players = game:GetService("Players")
      local UIS = game:GetService("UserInputService")
      local player = Players.LocalPlayer
      local pg = player and player:WaitForChild("PlayerGui", 15)
      if not pg then return end

      local function prepare(obj)
        if not obj:IsA("GuiButton") then return end
        pcall(function() obj.Active = true end)
        pcall(function() obj.Selectable = true end)
        pcall(function() obj.Interactable = true end)
        -- Buttons with empty Text are still valid hit targets.
        pcall(function() obj.Modal = false end)
      end

      for _, obj in ipairs(pg:GetDescendants()) do prepare(obj) end
      pg.DescendantAdded:Connect(function(obj)
        task.defer(function() pcall(prepare, obj) end)
      end)

      -- Ensure the primary hub screen and scroll pages accept touch input.
      for _, obj in ipairs(pg:GetDescendants()) do
        if obj:IsA("ScrollingFrame") then
          pcall(function() obj.Active = true end)
          pcall(function() obj.ScrollingEnabled = true end)
        end
      end

      -- Some executor-created GUIs have a stale modal flag; clear it only
      -- on this hub's own ScreenGuis, not on Roblox's core mobile controls.
      for _, child in ipairs(pg:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name:lower():find("ambitious") or child.Name:lower():find("roma") or child.Name:lower():find("hub")) then
          pcall(function() child.Enabled = true end)
          pcall(function() child.ZIndexBehavior = Enum.ZIndexBehavior.Sibling end)
        end
      end
    end)
    if not ok then warn("[MobileTouchFixV4] " .. tostring(err)) end
  end)
end