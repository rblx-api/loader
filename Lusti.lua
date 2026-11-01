--[[fmwm.1.OTIwNGRhYTYtMzkwZS00OWJhLTgyNGUtODk0ODU4NmNkMzQwfDMxOGJhZGY3LTk4NTEtNDVlMi05ZWUzLTk0NmNiYTFhM2YzNnxiN2NmNzNmOTcwZjkzOTAwNDc5OWJmZjI5YmY5NGYyOXwxNzkxMTU5MzMx.30f22b83baac]]
-- thin prelude
pcall(function()
  -- prelude
  pcall(function() if _G._FAULMOR_DIAG then print('DIAG: PRELUDE_START') end end)
  local _lO0lO = "09e42d6cb1de3c633137e00bac6c4c7c5edbf4d475bacc678d78733f9275b672"
  local _lI1lI = "12345678-1234-1234-1234-123456789abc"
  local _lOo0O = "1047323669535391834"
  local _l1i1l = "m4tivs"
  local _l0IiI = "lifetime"
  local _l1oO0 = nil
  local _lI0o1 = 1
  local _l0l0l = "Xeno"
  local _lI1i1 = true
  local function _fm_hb_env()
    local ok, e = pcall(function() return type(getgenv) == 'function' and getgenv() end)
    if ok and type(e) == 'table' then return e end
    local ok2, e2 = pcall(function() return type(getfenv) == 'function' and getfenv(0) end)
    if ok2 and type(e2) == 'table' then return e2 end
    return _G
  end
  do
    local env=nil do local gg=nil local ok,g=pcall(function() return type(getgenv) == 'function' and getgenv() end) if ok and type(g)=='table' then gg=g end local function tr(l) if type(getfenv) == 'function' then local ok2,e=pcall(getfenv,l) if ok2 and type(e)=='table' then return e end end end env=tr(2) or tr(3) or gg or tr(1) or tr(0) or _G end
    if type(env) == 'table' then
      env.LRM_ScriptKey = _lO0lO
      env.LRM_HWID = _lI1lI
      env.LRM_LinkedDiscordID = _lOo0O
      env.LRM_LinkedDiscordName = _l1i1l
      env.LRM_KeyType = _l0IiI
      env.LRM_KeyExpiresAt = _l1oO0
      env.LRM_TotalExecutions = _lI0o1
      env.LRM_Executor = _l0l0l
      env.LRM_IsPremium = _lI1i1
      local _spawn = (type(task) == 'table' and type(task.spawn) == 'function' and task.spawn) or (type(coroutine) == 'table' and type(coroutine.create) == 'function' and type(coroutine.resume) == 'function' and function(f) local co=coroutine.create(f); pcall(coroutine.resume, co) end)
      local _wait = (type(task) == 'table' and type(task.wait) == 'function' and task.wait) or (type(wait) == 'function' and wait)
      local _unpack = (type(table) == 'table' and type(table.unpack) == 'function' and table.unpack) or (type(unpack) == 'function' and unpack)
      if _spawn then env.LRM_Spawn = _spawn end
      if _wait then env.LRM_Wait = _wait end
      if _unpack then env.LRM_Unpack = _unpack end
    end
  end
  -- session
  local _FM_SESS = { t = "st.1.9204daa6-390e-49ba-824e-8948586cd340.318badf7-9851-45e2-9ee3-946cba1a3f36.b7cf73f970f939004799bff29bf94f29.6.1791159330.1791159630.1.c129e99cc6593916.2df4bbd45272d3938163fd2fde4bfb74b05acf2d3316c748a6410f6574563832", e = 1791159630, u = "https://faulmor.site/api/public/session/refresh", h = _lI1lI }
  local _fm_spawn = (type(task) == 'table' and type(task.spawn) == 'function' and task.spawn) or (type(coroutine) == 'table' and type(coroutine.create) == 'function' and type(coroutine.resume) == 'function' and function(f) local co=coroutine.create(f); pcall(coroutine.resume, co) end)
  local _fm_wait = (type(task) == 'table' and type(task.wait) == 'function' and task.wait) or (type(wait) == 'function' and wait)
  if _fm_spawn and _fm_wait then
    pcall(function() if _G._FAULMOR_DIAG then print('DIAG: PHASE=PRELUDE_INIT _fm_spawn=' .. type(_fm_spawn) .. ' _fm_wait=' .. type(_fm_wait)) end end)
    pcall(_fm_spawn, function()
    local hs; local ok, svc = pcall(function() return type(game) == 'table' and type(game.GetService) == 'function' and game:GetService('HttpService') end); if ok and svc then hs = svc end
    if not hs then return end
    while true do
      local now = os.time()
      local left = _FM_SESS.e - now
      if left <= 30 then
        local body = '{"token":"' .. _FM_SESS.t .. '","hwid":"' .. _FM_SESS.h .. '","script_key":"' .. _lO0lO .. '"}'
        local ok2, resp = pcall(hs.PostAsync, hs, _FM_SESS.u, body, 2, 'application/json')
        if ok2 and type(resp) == 'string' then
          local nt = resp:match('"token"%s*:%s*"([^"]+)"')
          local ne = tonumber(resp:match('"exp"%s*:%s*(%d+)'))
          if nt and ne then _FM_SESS.t = nt; _FM_SESS.e = ne end
        end
        _fm_wait(15)
      else
        _fm_wait(math.max(5, left - 30))
      end
    end
  end)
  end
  do local _e=_fm_hb_env(); if type(_e)=='table' then local _old=_e["__fmbh"]; if type(_old)=='table' then _old.enabled=false end; _e["__fmbh"]=nil end end
  -- end prelude

end)
if _G.BloodHoundsRunning then return end
_G.BloodHoundsRunning = true

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera

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

-- Shared UI/ESP caches must be declared before functions that reference them.
local espHighlightCache = {}
local espBillboardCache = {}
local espTracerCache = {}
local profileImageCache = {}

-- Tipografía consistente: Builder Sans es limpia y moderna; Gotham queda como respaldo.
local function resolveFont(name, fallback)
    local ok, font = pcall(function() return Enum.Font[name] end)
    return (ok and font) or fallback
end

local UI_FONT       = resolveFont("Montserrat", Enum.Font.Gotham)
local UI_FONT_BOLD  = resolveFont("Montserrat", Enum.Font.GothamBold)
local UI_FONT_HEAVY = resolveFont("GothamBlack", Enum.Font.GothamBlack)

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
CONFIG_FILE = "VX7_BloodHounds_Config.json"
-- Nueva generación de configuración: invalida los ajustes guardados anteriormente.
CONFIG_RESET_VERSION = 3
_isDraggingButton = false

backgroundIndex = 1
backgroundImages = {
    "88139170832911",
    "83962148425762",
    "78418040549415",
    "86952050926223",
    "91411557607071",
    "130901785905213"
}
floatingButtonScale = 1
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
    _lastCollisionSweep = 0,
    _maxForce = 2200,
    _freeForce = 500,

    _heartbeatConn = nil,
    _softStealScanner = nil,
    _softStealAnimals = {},
    _softStealScanning = false,
    _softStealScanToken = 0,

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
    if self.laggerMode == 1 then return self.laggerSpeed end
    if self.laggerMode == 2 then return self.laggerCarrySpeed end
    if self.speedToggled then return self.carrySpeed end
    return self.normalSpeed
end

function CarrySystem:getStatus()
    if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
        return "NORMAL", self.normalSpeed
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
    self._softStealScanToken = (self._softStealScanToken or 0) + 1
    local token = self._softStealScanToken
    self:scanSoftStealAnimals()
    -- Los podiums no necesitan escanearse 60 veces por segundo.
    self._softStealScanner = task.spawn(function()
        while self._softStealScanning and self._softStealScanToken == token do
            task.wait(0.75)
            if self._softStealScanning and self._softStealScanToken == token then
                self:scanSoftStealAnimals()
            end
        end
    end)
end

function CarrySystem:stopSoftStealScanner()
    self._softStealScanning = false
    self._softStealScanToken = (self._softStealScanToken or 0) + 1
    if self._softStealScanner then
        pcall(task.cancel, self._softStealScanner)
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

local function nowForCollisionSweep(system, now)
    if now - (system._lastCollisionSweep or 0) < 0.20 then return false end
    system._lastCollisionSweep = now
    return true
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

    if blocked and nowForCollisionSweep(self, _tick()) then
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

function CarrySystem:setNormalSpeed(v) v = tonumber(v); if v then self.normalSpeed = v end end
function CarrySystem:setCarrySpeed(v) v = tonumber(v); if v then self.carrySpeed = v end end
function CarrySystem:setLaggerSpeed(v) v = tonumber(v); if v then self.laggerSpeed = v end end
function CarrySystem:setLaggerCarrySpeed(v) v = tonumber(v); if v then self.laggerCarrySpeed = v end end
function CarrySystem:setSoftStealSpeed(v) v = tonumber(v); if v then self.softStealSpeed = v end end
function CarrySystem:setSoftStealRadius(v)
    v = tonumber(v)
    if v then self.softStealRadius = _clamp(v, 1, 200) end
end

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

-- Tema morado fijo; no se expone un selector de color.
local THEME_PURPLE = Color3.fromRGB(170, 85, 255)
currentColorTheme = "Morado"
selectedColor = THEME_PURPLE
function getThemeColor() return THEME_PURPLE end
local _lastThemeUpdate = 0
local _lastThemeColor = nil
function applyColorTheme(_)
    currentColorTheme = "Morado"
    selectedColor = THEME_PURPLE
    updateAllUIThemeColors(selectedColor)
end
function updateAllUIThemeColors(color)
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.1 then return end
    _lastThemeUpdate = now
    _lastThemeColor = color

    if progressFill then
        progressFill.BackgroundColor3 = color
        local grad = progressFill:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(210, 160, 255)),
                ColorSequenceKeypoint.new(0.50, color),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(105, 40, 170)),
            })
        end
    end
    if pbFrame then
        local border = pbFrame:FindFirstChildOfClass("UIStroke")
        if border then border.Color = Color3.fromRGB(0, 0, 0) end
        local fpsNeon = pbFrame:FindFirstChild("FPSNeon")
        if fpsNeon then fpsNeon.TextColor3 = color end
    end
    local function searchAndUpdateText(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("TextLabel") then
                if child.Text:find("Spd:") or child.Name == "BloodHoundsSpeedIndicator" or child.Text:find("FPS") then
                    child.TextColor3 = color
                end
            end
            if child:IsA("UIStroke") then
                if child.Color == Color3.fromRGB(180, 180, 190) then child.Color = color end
            end
        end
    end
    if gui then searchAndUpdateText(gui) end
    for _, tab in ipairs(tabButtons or {}) do
        if tab.TextColor3 == Color3.fromRGB(180, 180, 190) then tab.TextColor3 = color end
    end
    for _, hl in pairs(espHighlightCache) do
        if hl then hl.FillColor = color; hl.OutlineColor = color end
    end
    for _, lines in pairs(espTracerCache) do
        if lines then
            for _, ln in ipairs(lines) do
                if ln then ln.Color = color end
            end
        end
    end
    for _, bb in pairs(espBillboardCache) do
        if bb then
            local img = bb:FindFirstChildOfClass("ImageLabel")
            if img then
                local stroke = img:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = color end
            end
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

-- Diseño fijo: solo se conserva GUI 1; cualquier ajuste antiguo se normaliza.
function applyMenuGuiStyle(_)
    menuGuiStyle = "GUI 1"
    menuGuiWidth = 320
    local visibleName = "4KTDUELS"
    if gui then gui.Name = visibleName end
    if menuMetricsTitle and menuMetricsTitle.Parent then menuMetricsTitle.Text = "" end

    local panel = main
    if not panel or not panel.Parent then return end
    local titleFrame = panel:FindFirstChild("TitleFrame")
    local tabBar = panel:FindFirstChild("TopTabBar")
    local tabContent = panel:FindFirstChild("PanelContent")
    local tabLayout = tabBar and tabBar:FindFirstChildOfClass("UIListLayout")
    local bgImage = panel:FindFirstChild("BackgroundImage")
    local bgShade = panel:FindFirstChild("FireShade")
    local closeButton = panel:FindFirstChild("CloseButton")

    panel.Size = UDim2.new(0, 320, 0, 420)
    panel.BackgroundTransparency = 1
    panel.ClipsDescendants = true
    if bgImage then bgImage.ImageTransparency = 0 end
    if bgShade then
        bgShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bgShade.BackgroundTransparency = 0.62
    end
    if titleFrame then
        titleFrame.Name = "TitleFrame"
        titleFrame.Visible = true
        titleFrame.BackgroundTransparency = 1
        titleFrame.AnchorPoint = Vector2.new(0.5, 0)
        titleFrame.Size = UDim2.new(1, -16, 0, 90)
        titleFrame.Position = UDim2.new(0.5, 0, 0, 0)
    end
    if menuHeaderImage then
        menuHeaderImage.Visible = true
        menuHeaderImage.Size = UDim2.new(1, 0, 1, 0)
        menuHeaderImage.Position = UDim2.new(0, 0, 0, 0)
        menuHeaderImage.ImageTransparency = 0
    end
    if menuV1Brand then
        menuV1Brand.Visible = false
        menuV1Brand.Size = UDim2.new(1, -54, 1, 0)
        menuV1Brand.Position = UDim2.new(0, 10, 0, 0)
        menuV1Brand.Text = ""
        menuV1Brand.TextColor3 = THEME_PURPLE
        menuV1Brand.Font = UI_FONT_HEAVY
        menuV1Brand.TextSize = 28
        menuV1Brand.TextXAlignment = Enum.TextXAlignment.Left
        menuV1Brand.TextYAlignment = Enum.TextYAlignment.Center
        menuV1Brand.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        menuV1Brand.TextStrokeTransparency = 0.12
        menuV1Brand.ZIndex = 22
    end
    if menuV2Brand then menuV2Brand.Visible = false end
    if closeButton then
        closeButton.Size = UDim2.new(0, 24, 0, 24)
        closeButton.Position = UDim2.new(1, -32, 0, 8)
        closeButton.BackgroundTransparency = 1
        closeButton.TextSize = 18
    end
    if tabBar then
        tabBar.Size = UDim2.new(1, -8, 0, 32)
        tabBar.Position = UDim2.new(0, 4, 1, -36)
    end
    if tabLayout then
        tabLayout.FillDirection = Enum.FillDirection.Horizontal
        tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        tabLayout.Padding = UDim.new(0, 2)
    end
    for _, button in ipairs(tabButtons or {}) do
        button.Size = UDim2.new(0.2, -2, 1, -6)
        button.TextSize = 9
        button.TextColor3 = THEME_PURPLE
        button.BackgroundColor3 = Color3.fromRGB(26, 8, 22)
        local stroke = button:FindFirstChild("TabStroke")
        if stroke then stroke.Color = THEME_PURPLE end
        local underline = button:FindFirstChild("Underline")
        if underline then
            underline.Size = UDim2.new(0, 42, 0, 3)
            underline.Position = UDim2.new(0.5, 0, 1, -3)
            underline.AnchorPoint = Vector2.new(0.5, 0)
            underline.BackgroundColor3 = THEME_PURPLE
        end
    end
    if tabContent then
        tabContent.Size = UDim2.new(1, -8, 1, -130)
        tabContent.Position = UDim2.new(0, 4, 0, 90)
    end
end

local OUTFIT_TAG = "AuFfit"
local originalOutfitCache = setmetatable({}, {__mode = "k"})

local function cacheOriginalAppearance(char)
    if not char or originalOutfitCache[char] then return end
    local head = char:FindFirstChild("Head")
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    local headMesh = head and head:FindFirstChildWhichIsA("SpecialMesh")
    local saved = {
        shirtTemplate = shirt and shirt.ShirtTemplate,
        hadShirt = shirt ~= nil,
        pantsTemplate = pants and pants.PantsTemplate,
        hadPants = pants ~= nil,
        headMeshId = head and head:IsA("MeshPart") and head.MeshId or nil,
        headTextureId = head and head:IsA("MeshPart") and head.TextureID or nil,
        hadSpecialMesh = headMesh ~= nil,
        specialMeshId = headMesh and headMesh.MeshId,
        specialTextureId = headMesh and headMesh.TextureId,
        accessories = {},
    }
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") then table.insert(saved.accessories, child) end
    end
    originalOutfitCache[char] = saved
end

local function applyNoOutfit(char, restoreOriginal)
    if not char then char = LP.Character end
    if not char then return end
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #OUTFIT_TAG) == OUTFIT_TAG or d.Name:sub(1, 14) == "OceanVX7Outfit" then
            pcall(function() d:Destroy() end)
        end
    end
    local oldAcc = char:FindFirstChild("AuFfitAccessory")
    if oldAcc then pcall(function() oldAcc:Destroy() end) end
    if restoreOriginal == false then
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") then
                pcall(function() child:Destroy() end)
            end
        end
    end
    local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
    if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
    local oldZurichKorblox = char:FindFirstChild("ZurichKorbloxLeg")
    if oldZurichKorblox then pcall(function() oldZurichKorblox:Destroy() end) end
    for _, limb in ipairs({char:FindFirstChild("Right Leg"), char:FindFirstChild("RightUpperLeg")}) do
        local mesh = limb and limb:FindFirstChild("ZurichKorbloxMesh")
        if mesh then pcall(function() mesh:Destroy() end) end
    end
    for _, torso in ipairs({char:FindFirstChild("Torso"), char:FindFirstChild("UpperTorso")}) do
        local mesh = torso and torso:FindFirstChild("OceanZurichTorsoMesh")
        if mesh then pcall(function() mesh:Destroy() end) end
    end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local head = char:FindFirstChild("Head")
    local saved = originalOutfitCache[char]
    if head then
        head.Transparency = 0
        head.CanCollide = true
        head.LocalTransparencyModifier = 0
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 0 end
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm and (not saved or not saved.hadSpecialMesh) then pcall(function() sm:Destroy() end) end
        if saved and head:IsA("MeshPart") and saved.headMeshId then
            pcall(function()
                head.MeshId = saved.headMeshId
                head.TextureID = saved.headTextureId or ""
            end)
        elseif saved and saved.hadSpecialMesh and saved.specialMeshId then
            local restored = Instance.new("SpecialMesh")
            restored.MeshType = Enum.MeshType.FileMesh
            restored.MeshId = saved.specialMeshId
            restored.TextureId = saved.specialTextureId or ""
            restored.Parent = head
        end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = true end
    end)
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}) do
        local limb = char:FindFirstChild(partName)
        if limb then
            limb.Transparency = 0
            limb.LocalTransparencyModifier = 0
        end
    end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    if saved and restoreOriginal ~= false then
        if saved.hadShirt then
            shirt = shirt or Instance.new("Shirt", char)
            shirt.ShirtTemplate = saved.shirtTemplate or ""
        elseif shirt then shirt:Destroy() end
        if saved.hadPants then
            pants = pants or Instance.new("Pants", char)
            pants.PantsTemplate = saved.pantsTemplate or ""
        elseif pants then pants:Destroy() end
        for _, accessory in ipairs(saved.accessories) do
            if accessory and not accessory.Parent then accessory.Parent = char end
        end
    end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 0 end
        end
    end
end

local OUTFITS = {
    {
        label = "Off",
        customApply = applyNoOutfit,
    },
    {
        accessory = 10159600649,
        offset = _V3new(0, 1, -0.2),
        shirt = "http://www.roblox.com/asset/?id=9683332638",
        pants = "http://www.roblox.com/asset/?id=93182020184041",
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918 ",
        korblox = "none",
        label = "Outfit V1",
        headlessKorblox = true,
    },
    {
        accessory = 1744060292,
        offset = _V3new(0, 1.3, -0.2),
        shirt = "http://www.roblox.com/asset/?id=9683332638",
        pants = "http://www.roblox.com/asset/?id=93182020184041",
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918 ",
        korblox = "none",
        label = "Outfit V2",
        headlessKorblox = true,
    },
    {
        label = "Outfit V4",
        items = {10997283529, 125085889448130},
    },
    {
        label = "Outfit V5",
        items = {125157548394108, 123231522991173, 74827642361405},
    },
    {
        label = "Outfit V6",
        items = {136644276218918, 132022106987543, 131740907052260},
    },
    {
        label = "Outfit V7",
        items = {119331031817124, 84952305140948},
        headlessOnly = true,
    },
    {
        label = "Outfit V8",
        items = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702},
        headlessOnly = true,
    },
    {
        label = "Outfit V9",
        items = {13935333090, 16110951997, 10632503818},
    },
    {
        label = "Outfit V10",
        items = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424},
        headlessOnly = true,
    },
    {
        label = "Outfit V11",
        items = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718},
        headlessOnly = true,
        hideRight = true,
        bodyVisual = true,
    },
    {
        label = "Outfit V12",
        torsoMesh = "http://www.roblox.com/asset/?id=1660648364",
        items = {9733132546, 5706164157, 111149505826763},
        headlessKorblox = true,
    },
    {
        label = "Outfit V13",
        torsoMesh = "http://www.roblox.com/asset/?id=1660648364",
        items = {10796276786, 5706164157, 111149505826763},
        headlessKorblox = true,
    },
    {
        label = "Outfit V14",
        torsoMesh = "http://www.roblox.com/asset/?id=1660648364",
        items = {8844377623, 5706164157, 111149505826763},
        headlessKorblox = true,
    },
    {
        label = "Outfit V15",
        torsoMesh = "http://www.roblox.com/asset/?id=1660648364",
        items = {16107371158, 5706164157, 111149505826763},
        headlessKorblox = true,
    },
    {
        label = "Outfit V16",
        torsoMesh = "http://www.roblox.com/asset/?id=1660648364",
        items = {15970848598, 5706164157, 111149505826763},
        headlessKorblox = true,
    },
    {
        label = "Outfit V17",
        torsoMesh = "http://www.roblox.com/asset/?id=1660648364",
        items = {8844377623, 5706164157, 111149505826763},
        headlessKorblox = true,
    },
    {
        label = "Outfit V18",
        items = {130666125397672, 91321960147976, 111553288808103, 17274218093, 17387240647},
    },
    {
        label = "Outfit V19",
        items = {77038549270215, 16717004839, 127788745429250, 143803235928952},
    },
    {
        label = "Outfit V20",
        items = {7884186381, 13063157758, 8261840689},
        headlessKorblox = true,
    },
    {
        label = "Outfit V21",
        items = {9683332649, 13063157758, 91950080535908, 96954292222783, 17309352545, 132404403424262},
        headlessKorblox = true,
    },
    -- Preset cosmético personalizado.
    {
        label = "Skin",
        items = {10928435480, 6913613757, 9683332649},
        bundles = {263995361762992},
        headlessKorblox = true,
    },
    {
        label = "Outfit V22",
        items = {107377896731216, 215718515, 82831174733357, 122851471549264, 139051312584295, 124572458012582, 105029428205930},
        headlessKorblox = true,
    },
    {
        label = "Outfit V23",
        items = {76059443, 74891470, 1180433861, 8781331764, 8682542843},
        headlessKorblox = true,
    },
    {
        label = "Outfit V24",
        items = {82831174733357, 139051312584295, 107062966543626, 71184246276344, 111383282415116, 78289009309744, 71017311084699},
        headlessKorblox = true,
    },
}
local currentOutfitIndex = 1
local outfitSelectorLabel = nil
local appliedOutfitChar = nil
local appliedOutfitIndex = nil

local outfitAssetTemplateCache = {}
local outfitPreloadPauseUntil = 0
local function loadObjectsStd(id)
    id = tonumber(id) or id
    local cached = outfitAssetTemplateCache[id]
    if cached then
        local clones = {}
        for _, template in ipairs(cached) do
            local ok, clone = pcall(function() return template:Clone() end)
            if ok and clone then table.insert(clones, clone) end
        end
        if #clones > 0 then return clones end
    end
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if not ok or typeof(res) ~= "table" or #res == 0 then
        ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
        if ok and res then res = {res} end
    end
    if not ok or not res or #res == 0 then return nil end
    local templates = {}
    for _, obj in ipairs(res) do
        local saved = obj
        local cloneOk, clone = pcall(function() return saved:Clone() end)
        if cloneOk and clone then table.insert(templates, clone) end
        pcall(function() saved:Destroy() end)
    end
    if #templates == 0 then return nil end
    outfitAssetTemplateCache[id] = templates
    local clones = {}
    for _, template in ipairs(templates) do
        local cloneOk, clone = pcall(function() return template:Clone() end)
        if cloneOk and clone then table.insert(clones, clone) end
    end
    return #clones > 0 and clones or nil
end

local classicClothingTemplateCache = {}
local function resolveClassicClothingTemplate(value, className, propertyName)
    if value == nil then return "" end
    local raw = tostring(value)
    local assetId = tonumber(raw:match("%d+"))
    if not assetId then return raw end
    local key = className .. ":" .. tostring(assetId)
    if classicClothingTemplateCache[key] then return classicClothingTemplateCache[key] end
    local objects = loadObjectsStd(assetId)
    if objects then
        local result
        for _, root in ipairs(objects) do
            local candidates = {root}
            for _, descendant in ipairs(root:GetDescendants()) do table.insert(candidates, descendant) end
            for _, candidate in ipairs(candidates) do
                if candidate:IsA(className) then
                    local ok, template = pcall(function() return candidate[propertyName] end)
                    if ok and template and template ~= "" then result = template; break end
                end
            end
            pcall(function() root:Destroy() end)
            if result then break end
        end
        if result then
            classicClothingTemplateCache[key] = result
            return result
        end
    end
    return raw
end

local function applyHeadlessKorblox(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        head.CanCollide = false
        head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 1 end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = false end
    end)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            local w = v:FindFirstChildWhichIsA("Weld") or v:FindFirstChildWhichIsA("WeldConstraint") or v:FindFirstChildWhichIsA("Motor6D")
            if w then
                local p0, p1 = w.Part0, w.Part1
                if ((p0 and p0.Name == "Head") or (p1 and p1.Name == "Head"))
                    and v.Name:sub(1, #OUTFIT_TAG) ~= OUTFIT_TAG then
                    v.Parent = nil
                end
            end
        end
    end
    local rightLegConfig = {
        id = "rbxassetid://139607718",
        targetBodyPart = "RightUpperLeg",
        partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
        scale = _V3new(1, 1, 1),
        offset = _CFnew(0, 0, 0)
    }
    local targetPart = char:FindFirstChild(rightLegConfig.targetBodyPart)
    if targetPart then
        local oldAsset = char:FindFirstChild("Korblox_RightLeg")
        if oldAsset then oldAsset:Destroy() end
        for _, partName in ipairs(rightLegConfig.partsToHide) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
        end
        local success, objects = pcall(function() return game:GetObjects(rightLegConfig.id) end)
        if success and objects and #objects > 0 then
            local assetModel = objects[1]
            assetModel.Name = "Korblox_RightLeg"
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if mainMesh then
                mainMesh.Size = mainMesh.Size * rightLegConfig.scale
                mainMesh.CanCollide = false
                mainMesh.CFrame = targetPart.CFrame * rightLegConfig.offset
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = targetPart
                weld.Part1 = mainMesh
                weld.Parent = mainMesh
                assetModel.Parent = char
            end
        end
    end
end

local function attachVX7OutfitItems(char, items, bodyVisual)
    if not items then return end
    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart") or head
    local function findAttachment(name)
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                local a = part:FindFirstChild(name)
                if a and a:IsA("Attachment") then return a end
            end
        end
    end
    local function sanitize(obj)
        for _, d in ipairs(obj:GetDescendants()) do
            if d:IsA("LuaSourceContainer") then
                d:Destroy()
            elseif d:IsA("BasePart") then
                d.Anchored = false
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
                d.Massless = true
            end
        end
    end
    for _, assetId in ipairs(items) do
        local objects = loadObjectsStd(assetId)
        if objects then
            for _, sourceRoot in ipairs(objects) do
                local candidates = {sourceRoot}
                for _, descendant in ipairs(sourceRoot:GetDescendants()) do
                    table.insert(candidates, descendant)
                end
                for _, source in ipairs(candidates) do
                    if source:IsA("Shirt") or source:IsA("Pants") or source:IsA("ShirtGraphic") then
                        local old = char:FindFirstChildWhichIsA(source.ClassName)
                        if old then old:Destroy() end
                        local clothing = source:Clone()
                        clothing.Name = OUTFIT_TAG .. "VX7Clothing_" .. tostring(assetId)
                        clothing.Parent = char
                    elseif source:IsA("Accessory") then
                        local accessory = source:Clone()
                        local handle = accessory:FindFirstChild("Handle") or accessory:FindFirstChildWhichIsA("BasePart", true)
                        if handle and (head or root) then
                            sanitize(accessory)
                            accessory.Name = OUTFIT_TAG .. "VX7Accessory_" .. tostring(assetId)
                            accessory.Parent = char
                            local sourceAttachment
                            for _, child in ipairs(handle:GetChildren()) do
                                if child:IsA("Attachment") then
                                    sourceAttachment = child
                                    break
                                end
                            end
                            local targetAttachment = sourceAttachment and findAttachment(sourceAttachment.Name)
                            local targetPart = targetAttachment and targetAttachment.Parent or head or root
                            if targetAttachment and targetPart and targetPart:IsA("BasePart") then
                                handle.CFrame = targetAttachment.WorldCFrame * sourceAttachment.CFrame:Inverse()
                            else
                                handle.CFrame = targetPart.CFrame
                            end
                            local weld = Instance.new("WeldConstraint")
                            weld.Name = "OceanVX7OutfitWeld"
                            weld.Part0 = handle
                            weld.Part1 = targetPart
                            weld.Parent = handle
                        else
                            accessory:Destroy()
                        end
                    elseif bodyVisual and source:IsA("BasePart") and not source:FindFirstAncestorWhichIsA("Accessory") and root then
                        local partName = source.Name
                        local target = char:FindFirstChild(partName)
                        if target and target:IsA("BasePart") then
                            local visual = source:Clone()
                            sanitize(visual)
                            visual.Name = OUTFIT_TAG .. "VX7Body_" .. tostring(assetId)
                            visual.CFrame = target.CFrame
                            visual.Parent = char
                            local weld = Instance.new("WeldConstraint")
                            weld.Name = "OceanVX7OutfitWeld"
                            weld.Part0 = visual
                            weld.Part1 = target
                            weld.Parent = visual
                        end
                    end
                end
                pcall(function() sourceRoot:Destroy() end)
            end
        end
    end
end

local function applyVX7HeadlessOnly(char)
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        head.CanCollide = false
        head.LocalTransparencyModifier = 1
        for _, d in ipairs(head:GetDescendants()) do
            if d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 1 end
        end
    end
    local neck = char:FindFirstChild("Neck")
    if neck then neck.Enabled = false end
end

local outfitBundleItemCache = {}
local function expandOutfitAssets(items, bundles)
    local expanded, seen = {}, {}
    for _, id in ipairs(items or {}) do
        id = tonumber(id)
        if id and not seen[id] then seen[id] = true; expanded[#expanded + 1] = id end
    end
    for _, bundleId in ipairs(bundles or {}) do
        bundleId = tonumber(bundleId)
        if bundleId then
            local assetIds = outfitBundleItemCache[bundleId]
            if not assetIds then
                assetIds = {}
                pcall(function()
                    local details = game:GetService("AssetService"):GetBundleDetailsAsync(bundleId)
                    if details and type(details.Items) == "table" then
                        for _, item in ipairs(details.Items) do
                            local id = item.Type == "Asset" and tonumber(item.Id)
                            if id then assetIds[#assetIds + 1] = id end
                        end
                    end
                end)
                outfitBundleItemCache[bundleId] = assetIds
            end
            for _, id in ipairs(assetIds) do
                if not seen[id] then seen[id] = true; expanded[#expanded + 1] = id end
            end
        end
    end
    return expanded
end

function applyOutfitByIndex(index)
    local cfg = OUTFITS[index]
    if not cfg then return end
    local char = LP.Character
    if not char then return end
    if appliedOutfitChar == char and appliedOutfitIndex == index then return end
    outfitPreloadPauseUntil = os.clock() + 2
    if cfg.customApply then
        cfg.customApply(char)
        appliedOutfitChar = char
        appliedOutfitIndex = index
        if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
        return
    end
    cacheOriginalAppearance(char)
    applyNoOutfit(char, false)

    char:WaitForChild("Head", 5)
    local head = char:FindFirstChild("Head")
    if not head then return end
    if cfg.headMesh then
        for _, d in ipairs(char:GetChildren()) do
            if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
                pcall(function() d:Destroy() end)
            end
        end
        local done = false
        if head:IsA("MeshPart") then
            done = pcall(function()
                head.MeshId = cfg.headMesh
                if cfg.headTexture then head.TextureID = cfg.headTexture end
            end)
        end
        if not done then
            local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
            sm.Parent = head
            sm.MeshType = Enum.MeshType.FileMesh
            sm.MeshId = cfg.headMesh
            sm.TextureId = cfg.headTexture or ""
        end
    end
    if cfg.items then
        attachVX7OutfitItems(char, expandOutfitAssets(cfg.items, cfg.bundles), cfg.bodyVisual)
    end
    if cfg.torsoMesh then
        local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if torso then
            local oldTorsoMesh = torso:FindFirstChild("OceanZurichTorsoMesh")
            if oldTorsoMesh then oldTorsoMesh:Destroy() end
            local torsoMesh = Instance.new("SpecialMesh")
            torsoMesh.Name = "OceanZurichTorsoMesh"
            torsoMesh.MeshType = Enum.MeshType.FileMesh
            torsoMesh.MeshId = cfg.torsoMesh
            torsoMesh.Parent = torso
        end
    end
    if cfg.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = resolveClassicClothingTemplate(cfg.shirt, "Shirt", "ShirtTemplate")
        s.Parent = char
    end
    if cfg.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = resolveClassicClothingTemplate(cfg.pants, "Pants", "PantsTemplate")
        p.Parent = char
    end
    local old = char:FindFirstChild("AuFfitAccessory")
    if old then old:Destroy() end
    if cfg.accessory and head then
        local objs = loadObjectsStd(cfg.accessory)
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = _CFnew(cfg.offset)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    if cfg.headlessOnly then
        applyVX7HeadlessOnly(char)
    elseif cfg.headlessKorblox then
        applyHeadlessKorblox(char)
    else
        if char then
            local head2 = char:FindFirstChild("Head")
            if head2 then
                head2.Transparency = 0
                head2.CanCollide = true
                head2.LocalTransparencyModifier = 0
                local face2 = head2:FindFirstChild("face")
                if face2 then face2.Transparency = 0 end
            end
            pcall(function()
                local neck = char:FindFirstChild("Neck")
                if neck then neck.Enabled = true end
            end)
            for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local limb = char:FindFirstChild(partName)
                if limb then limb.Transparency = 0 end
            end
            local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
            if oldKorblox then oldKorblox:Destroy() end
        end
    end
    if cfg.hideLeft or cfg.hideRight then
        local leftParts = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}
        local rightParts = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}
        if cfg.hideLeft then
            for _, name in ipairs(leftParts) do
                local part = char:FindFirstChild(name)
                if part then part.Transparency = 1 end
            end
        end
        if cfg.hideRight then
            for _, name in ipairs(rightParts) do
                local part = char:FindFirstChild(name)
                if part then part.Transparency = 1 end
            end
        end
    end
    appliedOutfitChar = char
    appliedOutfitIndex = index
    if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
end

-- ============================================================
-- BAT SKINS
-- Skin Minecraft estilo espada pixelada, integrada desde el módulo adjunto.
-- ============================================================
local BAT_SKIN_OPTIONS = {"Off", "DiamondSword", "Katana"}
local BAT_SKIN_DATA = {
    DiamondSword = {
        mesh = "rbxassetid://8827558932",
        tex = "rbxassetid://8827558969",
        scale = Vector3.new(0.2, 0.2, 0.2),
        c0 = CFrame.new(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), math.rad(300)),
    },
    Katana = {
        mesh = "rbxassetid://13528902482",
        tex = "rbxassetid://13528902373",
        scale = Vector3.new(1.4, 1.4, 1.4),
        c0 = CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)),
    },
}
local MEDUSA_SKIN_OPTIONS = {"Off", "GoldenDeagle"}
local MEDUSA_SKIN_DATA = {
    GoldenDeagle = {
        mesh = "rbxassetid://430251413",
        tex = "rbxassetid://435840335",
        scale = Vector3.new(0.01, 0.01, 0.01),
        c0 = CFrame.new(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0),
    },
}

local function getBatSkinIndex(skinName)
    for index, name in ipairs(BAT_SKIN_OPTIONS) do
        if name == skinName then return index end
    end
    return 1
end
local function getMedusaSkinIndex(skinName)
    for index, name in ipairs(MEDUSA_SKIN_OPTIONS) do
        if name == skinName then return index end
    end
    return 1
end
local currentBatSkin = "Off"
local batSkinSelectorLabel = nil
local batSkinIndex = 1
local batSkinState = setmetatable({}, {__mode = "k"})
local currentMedusaSkin = "Off"
local medusaSkinSelectorLabel = nil
local medusaSkinIndex = 1

local function isBatSkinTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    return name:find("bat") or name:find("slap") or name:find("sword")
end

local function restoreBatSkinTool(tool)
    local state = batSkinState[tool]
    if state and state.flashConn then
        pcall(function() state.flashConn:Disconnect() end)
    end
    if state and state.handle and state.handle.Parent then
        state.handle.Transparency = state.transparency
        state.handle.CanQuery = state.canQuery
        state.handle.CanTouch = state.canTouch
    end
    if state and state.replica and state.replica.Parent then
        state.replica:Destroy()
    end
    batSkinState[tool] = nil
end

local function beginBatSkinReplica(tool, replicaName)
    local handle = tool and tool:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return nil, nil end

    restoreBatSkinTool(tool)
    local state = {
        handle = handle,
        transparency = handle.Transparency,
        canQuery = handle.CanQuery,
        canTouch = handle.CanTouch,
    }
    batSkinState[tool] = state
                handle.Transparency = 1
                -- El Handle original debe seguir siendo detectable por el juego.
                -- Desactivar CanTouch puede impedir que el bate registre golpes.
                handle.CanQuery = true
                handle.CanTouch = true

    local model = Instance.new("Model")
    model.Name = replicaName
    model.Parent = handle
    state.replica = model
    return handle, model
end

local function addMinecraftBlock(model, handle, name, size, offset, color, material)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.CFrame = handle.CFrame * offset
    part.Color = color
    part.Material = material or Enum.Material.SmoothPlastic
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.Massless = true
    part.CastShadow = false
    part.Parent = model

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = part
    weld.Parent = part
    return part
end

local function buildAssetBatSkin(tool, skinKey, dataSet)
    local data = (dataSet or BAT_SKIN_DATA)[skinKey]
    if not data then return end
    local handle, model = beginBatSkinReplica(tool, "VX7" .. skinKey .. "BatSkin")
    if not handle or not model then return end

    local part = Instance.new("Part")
    part.Name = "MainPart"
    part.Size = Vector3.new(1, 1, 1)
    part.Transparency = 0
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.Massless = true
    part.CastShadow = false
    part.Parent = model

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = data.mesh
    mesh.TextureId = data.tex
    mesh.Scale = data.scale
    mesh.Parent = part

    local weld = Instance.new("Motor6D")
    weld.Part0 = handle
    weld.Part1 = part
    weld.C0 = data.c0
    weld.Parent = part
end

local function applyBatSkinToTool(tool)
    if not isBatSkinTool(tool) then return end
    if BAT_SKIN_DATA[currentBatSkin] then
        buildAssetBatSkin(tool, currentBatSkin)
    else
        restoreBatSkinTool(tool)
    end
end

local function isMedusaSkinTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    return name:find("medusa") or name:find("head")
end

local function applyMedusaSkinToTool(tool)
    if not isMedusaSkinTool(tool) then return end
    if currentMedusaSkin == "GoldenDeagle" then
        buildAssetBatSkin(tool, currentMedusaSkin, MEDUSA_SKIN_DATA)
    else
        restoreBatSkinTool(tool)
    end
end

local function applyBatSkinToCharacter()
    local char = LP.Character
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, container in ipairs({char, backpack}) do
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Tool") then
                    task.defer(applyBatSkinToTool, child)
                    task.defer(applyMedusaSkinToTool, child)
                end
            end
        end
    end
end

local function scheduleBatSkinRefresh()
    -- Algunas herramientas crean su Handle unos instantes después de equiparse.
    task.defer(applyBatSkinToCharacter)
    task.delay(0.15, applyBatSkinToCharacter)
    task.delay(0.5, applyBatSkinToCharacter)
end

local function hookBatSkinCharacter(char)
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            task.defer(applyBatSkinToTool, child)
            task.defer(applyMedusaSkinToTool, child)
        end
    end
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            scheduleBatSkinRefresh()
            child.ChildAdded:Connect(function(descendant)
                if descendant.Name == "Handle" then
                    task.defer(applyBatSkinToTool, child)
                    task.defer(applyMedusaSkinToTool, child)
                    task.delay(0.15, applyBatSkinToCharacter)
                end
            end)
        end
    end)
end

if LP.Character then hookBatSkinCharacter(LP.Character) end
LP.CharacterAdded:Connect(hookBatSkinCharacter)
local backpack = LP:FindFirstChildOfClass("Backpack")
if backpack then
    backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            scheduleBatSkinRefresh()
            child.ChildAdded:Connect(function(descendant)
                if descendant.Name == "Handle" then
                    task.defer(applyBatSkinToTool, child)
                    task.defer(applyMedusaSkinToTool, child)
                    task.delay(0.15, applyBatSkinToCharacter)
                end
            end)
        end
    end)
end

-- ============================================================
-- CUSTOM SOUND: BATE (activo automáticamente)
-- Independiente de las skins; sustituye temporalmente solo el audio del bate.
-- ============================================================
local customSoundState = setmetatable({}, {__mode = "k"})
local customSoundHooked = setmetatable({}, {__mode = "k"})
local customSoundWatchers = setmetatable({}, {__mode = "k"})
local CUSTOM_SOUND_DATA = {
    Bat = {id = "rbxassetid://5713085119", skip = 0.2},
}

local function getCustomSoundKind(tool)
    if not tool or not tool:IsA("Tool") then return nil end
    local name = tool.Name:lower()
    if name:find("bat") or name:find("slap") then return "Bat" end
    return nil
end

local function teardownCustomSoundTool(tool)
    local state = customSoundState[tool]
    if not state then return end
    if state.timer then pcall(task.cancel, state.timer) end
    for _, conn in ipairs(state.conns or {}) do pcall(function() conn:Disconnect() end) end
    if state.custom and state.custom.Parent then pcall(function() state.custom:Destroy() end) end
    for snd, volume in pairs(state.muted or {}) do
        customSoundHooked[snd] = nil
        if snd and snd.Parent then pcall(function() snd.Volume = volume end) end
    end
    customSoundState[tool] = nil
end

local function playCustomToolSound(state, allowDouble)
    if not state or not state.custom or not state.custom.Parent then return end
    local data = state.data
    pcall(function()
        state.custom:Stop()
        state.custom.TimePosition = data.skip or 0
        state.custom.Volume = 1
        state.custom:Play()
    end)
    if allowDouble ~= false and data.doublePlay and data.delay then
        if state.timer then pcall(task.cancel, state.timer) end
        state.timer = task.delay(data.delay, function()
            state.timer = nil
            if customSoundsEnabled then playCustomToolSound(state, false) end
        end)
    end
end

local function hookCustomSound(state, snd)
    if not snd:IsA("Sound") or snd.Name == "CustomSound" then return end
    if customSoundHooked[snd] then return end
    state.muted[snd] = snd.Volume
    customSoundHooked[snd] = true
    local function trigger()
        if not customSoundsEnabled then return end
        if snd.Playing or snd.TimePosition > 0 then
            pcall(function() snd.Volume = 0; snd:Stop() end)
            playCustomToolSound(state)
        end
    end
    -- TimePosition cambia durante la reproducción y podía disparar el reemplazo
    -- varias veces dentro de una sola ventana de impacto. Solo escuchamos Playing.
    local c1 = snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
    table.insert(state.conns, c1)
    local c3
    c3 = snd.AncestryChanged:Connect(function(_, parent)
        if parent then return end
        customSoundHooked[snd] = nil
        state.muted[snd] = nil
        pcall(function() c1:Disconnect(); c3:Disconnect() end)
    end)
    table.insert(state.conns, c3)
    if snd.Playing then trigger() end
end

local function setupCustomSoundTool(tool)
    local kind = getCustomSoundKind(tool)
    if not kind or customSoundState[tool] then return end
    local handle = tool:FindFirstChild("Handle")
    if not handle then return end
    local data = CUSTOM_SOUND_DATA[kind]
    local custom = Instance.new("Sound")
    custom.Name = "CustomSound"
    custom.SoundId = data.id
    custom.Volume = 1
    custom.Looped = false
    custom.RollOffMode = Enum.RollOffMode.Inverse
    custom.MaxDistance = 1000
    custom.MinDistance = 1000
    custom.Parent = handle
    local state = {custom = custom, data = data, conns = {}, muted = {}, timer = nil}
    customSoundState[tool] = state
    for _, descendant in ipairs(tool:GetDescendants()) do hookCustomSound(state, descendant) end
    table.insert(state.conns, tool.DescendantAdded:Connect(function(descendant)
        if customSoundState[tool] then hookCustomSound(state, descendant) end
    end))
    table.insert(state.conns, tool.AncestryChanged:Connect(function(_, parent)
        if not parent then teardownCustomSoundTool(tool) end
    end))
end

local function refreshCustomSoundTools()
    if not customSoundsEnabled then return end
    for _, container in ipairs({LP.Character, LP:FindFirstChildOfClass("Backpack")}) do
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Tool") then setupCustomSoundTool(child) end
            end
        end
    end
end

local function setCustomSoundsEnabled(on)
    customSoundsEnabled = on == true
    if customSoundsEnabled then
        refreshCustomSoundTools()
    else
        for tool in pairs(customSoundState) do teardownCustomSoundTool(tool) end
    end
end

local function watchCustomSoundContainer(container)
    if not container or customSoundWatchers[container] then return end
    local conns = {}
    table.insert(conns, container.ChildAdded:Connect(function(child)
        if customSoundsEnabled and child:IsA("Tool") then
            task.defer(setupCustomSoundTool, child)
        end
    end))
    customSoundWatchers[container] = conns
    for _, child in ipairs(container:GetChildren()) do
        if customSoundsEnabled and child:IsA("Tool") then setupCustomSoundTool(child) end
    end
end

if LP.Character then watchCustomSoundContainer(LP.Character) end
if backpack then watchCustomSoundContainer(backpack) end
LP.CharacterAdded:Connect(function(char)
    task.defer(function() watchCustomSoundContainer(char); refreshCustomSoundTools() end)
end)
LP.ChildAdded:Connect(function(child)
    if child:IsA("Backpack") then watchCustomSoundContainer(child) end
end)

-- ============================================================
-- X-RAY: transparencia de elementos de los plots
-- ============================================================
_G.OceanXRayFolders = {"Base", "PlotSign", "FriendPanel", "Cash", "Laser", "Decorations", "Skin", "Unlock", "Purchases"}
_G.OceanXRayOrigTrans = {}
_G.OceanXRayConns = {}
_G.OceanXRayLoopId = 0

local function setOceanXRayTarget(instance, alphaPercent, loopId)
    if not instance or loopId ~= _G.OceanXRayLoopId then return end
    local function apply(obj)
        if obj:IsA("BasePart") then
            if _G.OceanXRayOrigTrans[obj] == nil then _G.OceanXRayOrigTrans[obj] = obj.Transparency end
            local orig = _G.OceanXRayOrigTrans[obj]
            if orig < 1 then obj.Transparency = orig + (1 - orig) * alphaPercent end
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if _G.OceanXRayOrigTrans[obj] == nil then
                _G.OceanXRayOrigTrans[obj] = {text = obj.TextTransparency, bg = obj.BackgroundTransparency}
            end
            local orig = _G.OceanXRayOrigTrans[obj]
            if orig.text < 1 then obj.TextTransparency = orig.text + (1 - orig.text) * alphaPercent end
            if orig.bg < 1 then obj.BackgroundTransparency = orig.bg + (1 - orig.bg) * alphaPercent end
        elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
            if _G.OceanXRayOrigTrans[obj] == nil then _G.OceanXRayOrigTrans[obj] = obj.BackgroundTransparency end
            local orig = _G.OceanXRayOrigTrans[obj]
            if orig < 1 then obj.BackgroundTransparency = orig + (1 - orig) * alphaPercent end
        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            if _G.OceanXRayOrigTrans[obj] == nil then
                _G.OceanXRayOrigTrans[obj] = {img = obj.ImageTransparency, bg = obj.BackgroundTransparency}
            end
            local orig = _G.OceanXRayOrigTrans[obj]
            if orig.img < 1 then obj.ImageTransparency = orig.img + (1 - orig.img) * alphaPercent end
            if orig.bg < 1 then obj.BackgroundTransparency = orig.bg + (1 - orig.bg) * alphaPercent end
        end
    end
    apply(instance)
    for i, child in ipairs(instance:GetDescendants()) do
        apply(child)
        if i % 300 == 0 then task.wait(); if loopId ~= _G.OceanXRayLoopId then return end end
    end
end

local function trackOceanXRaySubtree(root, alphaPercent, loopId)
    if not root or loopId ~= _G.OceanXRayLoopId then return end
    setOceanXRayTarget(root, alphaPercent, loopId)
    table.insert(_G.OceanXRayConns, root.DescendantAdded:Connect(function(obj)
        if loopId == _G.OceanXRayLoopId then setOceanXRayTarget(obj, alphaPercent, loopId) end
    end))
end

local function processOceanXRayPlot(plot, alphaPercent, loopId)
    if not plot or loopId ~= _G.OceanXRayLoopId then return end
    for _, folderName in ipairs(_G.OceanXRayFolders) do
        trackOceanXRaySubtree(plot:FindFirstChild(folderName), alphaPercent, loopId)
    end
    table.insert(_G.OceanXRayConns, plot.ChildAdded:Connect(function(child)
        if loopId ~= _G.OceanXRayLoopId then return end
        for _, folderName in ipairs(_G.OceanXRayFolders) do
            if child.Name == folderName then trackOceanXRaySubtree(child, alphaPercent, loopId); break end
        end
    end))
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if podiums then
        local function processPodium(podium)
            for _, child in ipairs(podium:GetChildren()) do
                if child.Name == "Claim" then trackOceanXRaySubtree(child, alphaPercent, loopId)
                elseif child.Name == "Base" then trackOceanXRaySubtree(child:FindFirstChild("Decorations"), alphaPercent, loopId)
                elseif child:IsA("Model") and child.Name ~= "Decorations" then trackOceanXRaySubtree(child, alphaPercent, loopId) end
            end
        end
        for _, podium in ipairs(podiums:GetChildren()) do processPodium(podium) end
        table.insert(_G.OceanXRayConns, podiums.ChildAdded:Connect(function(podium)
            if loopId == _G.OceanXRayLoopId then task.wait(0.1); processPodium(podium) end
        end))
    end
end

local function setXRayEnabled(on)
    xrayEnabled = on == true
    for _, conn in ipairs(_G.OceanXRayConns) do pcall(function() conn:Disconnect() end) end
    _G.OceanXRayConns = {}
    _G.OceanXRayLoopId = _G.OceanXRayLoopId + 1
    local loopId = _G.OceanXRayLoopId
    if xrayEnabled then
        task.spawn(function()
            while loopId == _G.OceanXRayLoopId and not Workspace:FindFirstChild("Plots") do task.wait(0.5) end
            if loopId ~= _G.OceanXRayLoopId then return end
            local plots = Workspace:FindFirstChild("Plots")
            if not plots then return end
            for _, plot in ipairs(plots:GetChildren()) do
                processOceanXRayPlot(plot, 0.5, loopId)
                task.wait()
            end
            table.insert(_G.OceanXRayConns, plots.ChildAdded:Connect(function(plot)
                if loopId == _G.OceanXRayLoopId then task.wait(0.2); processOceanXRayPlot(plot, 0.5, loopId) end
            end))
        end)
    else
        local snapshot = _G.OceanXRayOrigTrans
        _G.OceanXRayOrigTrans = {}
        for obj, orig in pairs(snapshot) do
            pcall(function()
                if obj:IsA("BasePart") then obj.Transparency = orig
                elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextTransparency = orig.text; obj.BackgroundTransparency = orig.bg
                elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then obj.BackgroundTransparency = orig
                elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then obj.ImageTransparency = orig.img; obj.BackgroundTransparency = orig.bg end
            end)
        end
    end
end

speedMode = false
antiRagdollMode = "off"
antiDieEnabled = false
antiFlingEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
autoCarryEnabled = false
autoCarryMode = "On Pick Up"
antiBatEnabled = false
dropMode = 1
antiLagEnabled = false
potatoGraphicsEnabled = false
potatoGraphicsSavedQuality = nil
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = true
hideButtons = false
uiScaleValue = 100
menuGuiStyle = "GUI 1"
menuGuiWidth = 320
espEnabled = false
-- El reemplazo de sonido se deja desactivado: algunos bates usan el evento
-- Playing/TimePosition como parte de su ventana de impacto.
customSoundsEnabled = false
xrayEnabled = false

bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false

savedProgressBarPos = nil
savedButtonPositions = {}
AUTO_SWING_ENABLED = true
savedMobilePanelPos = nil
savedMainMenuPos = nil
savedMainMenuOpen = false
instaResetFloatingPos = nil
instaResetFloatingButton = nil

neonWeatherEnabled = false
_originalLighting = nil
setNeonWeatherVisual = nil

currentAnimPack = "Off"
originalTryardAnims = nil
tryardHeartbeatConn = nil
animSelectorLabel = nil

useCarrySystem = false
lastMoveDir = _V3zero

local CoreGui = game:GetService("CoreGui")

local InfiniteJump = {
    enabled = false,
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
    if InfiniteJump.enabled then return end
    InfiniteJump.enabled = true
    connectEvents()
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
    if autoBatEnabled then return end
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
    if laggerCarryToggled then return LAGGER_CARRY_SPEED end
    if laggerToggled then return LAGGER_SPEED end
    if speedMode then return CS end
    return NS
end

ANIM_PACKS = {
    ["Zombie"] = { idle1="rbxassetid://616158929", idle2="rbxassetid://616160636", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119", swim="rbxassetid://616165109", swimidle="rbxassetid://616166655" },
    ["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656117400", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359", swim="rbxassetid://656117400", swimidle="rbxassetid://656117400" },
    ["Knight"] = { idle1="rbxassetid://657595757", idle2="rbxassetid://657595757", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781", swim="rbxassetid://657595757", swimidle="rbxassetid://657595757" },
    ["Elder"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038", swim="rbxassetid://845397899", swimidle="rbxassetid://845397899" },
    ["Levitate"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616006778", swimidle="rbxassetid://616006778" },
    ["Astronaut"] = { idle1="rbxassetid://891621366", idle2="rbxassetid://891621366", walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353", swim="rbxassetid://891621366", swimidle="rbxassetid://891621366" },
    ["Pirate"] = { idle1="rbxassetid://750781874", idle2="rbxassetid://750781874", walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899", swim="rbxassetid://750781874", swimidle="rbxassetid://750781874" },
    ["Toy"] = { idle1="rbxassetid://782841498", idle2="rbxassetid://782841498", walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869", swim="rbxassetid://782841498", swimidle="rbxassetid://782841498" },
    ["Vampire"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238", swim="rbxassetid://1083445855", swimidle="rbxassetid://1083445855" },
    ["Werewolf"] = { idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517", walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000", swim="rbxassetid://1083195517", swimidle="rbxassetid://1083195517" },
    ["Rthro"] = { idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951", walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778", swim="rbxassetid://2510196951", swimidle="rbxassetid://2510196951" },
    ["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616136790", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594", swim="rbxassetid://616136790", swimidle="rbxassetid://616136790" },
}

ANIM_PACK_ORDER = {{"Off", "Off"}, {"Zombie", "Zombie"}, {"Ninja", "Ninja"}, {"Knight", "Knight"}, {"Elder", "Elder"}, {"Levitate", "Levitate"}, {"Astronaut", "Astronaut"}, {"Pirate", "Pirate"}, {"Toy", "Toy"}, {"Vampire", "Vampire"}, {"Werewolf", "Werewolf"}, {"Rthro", "Rthro"}, {"Stylish", "Stylish"}}

local function isPackAnim(id)
    for _, pack in pairs(ANIM_PACKS) do
        for _, v in pairs(pack) do
            if v == id then return true end
        end
    end
    return false
end

local function saveOriginalAnims(char)
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids = {
        idle1 = g(animate.idle and animate.idle.Animation1),
        idle2 = g(animate.idle and animate.idle.Animation2),
        walk  = g(animate.walk and animate.walk.WalkAnim),
        run   = g(animate.run  and animate.run.RunAnim),
        jump  = g(animate.jump and animate.jump.JumpAnim),
        fall  = g(animate.fall and animate.fall.FallAnim),
        climb = g(animate.climb and animate.climb.ClimbAnim),
        swim  = g(animate.swim and animate.swim.Swim),
        swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
    }
    if not isPackAnim(ids.walk) then originalTryardAnims = ids end
end

local function applyAnimPack(packName)
    currentAnimPack = packName
    if animSelectorLabel then animSelectorLabel.Text = packName end
    if packName == "Off" then
        if originalTryardAnims and LP.Character then
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then
                local function s(obj,id) if obj then obj.AnimationId = id end end
                s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
                s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
                s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
                s(animate.run  and animate.run.RunAnim,   originalTryardAnims.run)
                s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
                s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
                s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
                s(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
                s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
            end
        end
        if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect(); tryardHeartbeatConn = nil end
        return
    end
    local pack = ANIM_PACKS[packName]
    if not pack then return end
    if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end
    local refreshAccumulator = 0
    tryardHeartbeatConn = RunService.Heartbeat:Connect(function(dt)
        refreshAccumulator = refreshAccumulator + (dt or 0.016)
        if refreshAccumulator < 0.50 then return end
        refreshAccumulator = 0
        local c = LP.Character
        if not c then return end
        local animate = c:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj,id) if obj then obj.AnimationId = id end end
        s(animate.idle and animate.idle.Animation1, pack.idle1)
        s(animate.idle and animate.idle.Animation2, pack.idle2)
        s(animate.walk and animate.walk.WalkAnim, pack.walk)
        s(animate.run  and animate.run.RunAnim,   pack.run)
        s(animate.jump and animate.jump.JumpAnim, pack.jump)
        s(animate.fall and animate.fall.FallAnim, pack.fall)
        s(animate.climb and animate.climb.ClimbAnim, pack.climb)
        s(animate.swim and animate.swim.Swim, pack.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
    end)
end

local function startAnimPack(packName)
    local char = LP.Character
    if char then
        saveOriginalAnims(char)
        applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    else
        applyAnimPack(packName)
    end
    currentAnimPack = packName
end

local function stopAnimPack()
    currentAnimPack = "Off"
    if animSelectorLabel then animSelectorLabel.Text = "Off" end
    applyAnimPack("Off")
end

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X, gp = nil},
    AutoLeft     = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight    = {kb = Enum.KeyCode.C, gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
    Float        = {kb = Enum.KeyCode.G, gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q, gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R, gp = nil},
    InstaReset   = {kb = Enum.KeyCode.H, gp = nil},
}

KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoLeft     = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp},
    AutoRight    = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp},
    AutoBat      = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp},
    TPFloor      = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp},
    Float        = {kb = DEFAULT_KB.Float.kb, gp = DEFAULT_KB.Float.gp},
    GuiHide      = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp},
    CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp},
    LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp},
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = {
    AUTO_STEAL_ENABLED = false,
    STEAL_RANGE = 61,
}

local plots = workspace:WaitForChild("Plots")
local stealConnection = nil

local Steal = {
    AutoStealEnabled = false,
    StealRadius = CONFIG.STEAL_RANGE,
    StealDuration = 1.3,
    StealDelay = 0.25,
    Data = {}
}

local isStealing = false
local zenxAdaptStealBar = { gui = nil, frame = nil, fill = nil, percent = nil, metrics = nil, renderConn = nil, position = nil, stopDrag = nil, dragConnections = nil, scale = nil }
local stealBarScale = 1
local stealBarScaleLabel = nil
local stealTimerLabel = nil
local function setZenxAdaptStealBarScale(value, persist)
    value = tonumber(value)
    if not value or value ~= value then return end
    stealBarScale = math.clamp(_floor(value * 10 + 0.5) / 10, 0.5, 1.6)
    local scale = zenxAdaptStealBar.scale
    if scale and scale.Parent then scale.Scale = stealBarScale end
    if stealBarScaleLabel and stealBarScaleLabel.Parent then
        stealBarScaleLabel.Text = string.format("%d%%", _floor(stealBarScale * 100 + 0.5))
    end
    if persist and type(saveAllSettings) == "function" then pcall(saveAllSettings) end
end

local function ensureZenxAdaptStealBar()
    if zenxAdaptStealBar.gui and zenxAdaptStealBar.gui.Parent then return true end
    for _, connection in ipairs(zenxAdaptStealBar.dragConnections or {}) do
        pcall(function() connection:Disconnect() end)
    end
    zenxAdaptStealBar.dragConnections = nil
    local playerGui = LP and (LP:FindFirstChildOfClass("PlayerGui") or LP:FindFirstChild("PlayerGui"))
    if not playerGui then return false end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZenxAdaptStealBarHUD"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 50
    screenGui.Enabled = false
    screenGui.Parent = playerGui

    local card = Instance.new("Frame")
    card.Name = "StealBar"
    card.Size = UDim2.new(0, 280, 0, 54)
    card.Position = zenxAdaptStealBar.position or (savedProgressBarPos and UDim2.new(
        savedProgressBarPos.XScale or 0.5,
        savedProgressBarPos.XOffset or -140,
        savedProgressBarPos.YScale or 1,
        savedProgressBarPos.YOffset or -62
    )) or UDim2.new(0.5, -140, 1, -62)
    card.BackgroundTransparency = 1
    card.BackgroundColor3 = Color3.fromRGB(0, 0, 6)
    card.BorderSizePixel = 0
    card.Active = not uiLocked
    card.ZIndex = 50
    card.Parent = screenGui
    local barBackground = Instance.new("ImageLabel", card)
    barBackground.Name = "AutoGrabBarBackground"
    barBackground.Size = UDim2.new(1, 0, 1, 0)
    barBackground.Position = UDim2.new(0, 0, 0, 0)
    barBackground.BackgroundTransparency = 1
    barBackground.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
    barBackground.ImageTransparency = 0
    barBackground.ScaleType = Enum.ScaleType.Crop
    barBackground.ZIndex = 49
    barBackground.Active = false
    barBackground.ClipsDescendants = true
    Instance.new("UICorner", barBackground).CornerRadius = UDim.new(0, 8)
    local cardScale = Instance.new("UIScale")
    cardScale.Name = "StealBarScale"
    cardScale.Scale = stealBarScale
    cardScale.Parent = card
    zenxAdaptStealBar.scale = cardScale
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local dragging, dragStart, startPos, activeInput = false, nil, nil, nil
    local ownsGlobalDrag = false
    local function stopCardDrag()
        dragging, dragStart, startPos, activeInput = false, nil, nil, nil
        if ownsGlobalDrag then _isDraggingButton = false; ownsGlobalDrag = false end
    end
    zenxAdaptStealBar.stopDrag = stopCardDrag
    local dragConnections = {}
    dragConnections[#dragConnections + 1] = card.InputBegan:Connect(function(input)
        if uiLocked or _isDraggingButton then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            activeInput = input
            dragStart = input.Position
            startPos = card.Position
            _isDraggingButton = true
            ownsGlobalDrag = true
        end
    end)
    dragConnections[#dragConnections + 1] = UIS.InputChanged:Connect(function(input)
        if not dragging or not activeInput then return end
        if uiLocked then stopCardDrag(); return end
        local touchMove = activeInput.UserInputType == Enum.UserInputType.Touch and input == activeInput
        local mouseMove = activeInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement
        if not touchMove and not mouseMove then return end
        local delta = input.Position - dragStart
        card.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        zenxAdaptStealBar.position = card.Position
    end)
    dragConnections[#dragConnections + 1] = UIS.InputEnded:Connect(function(input)
        local sameMouseButton = activeInput and activeInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseButton1
        if dragging and (input == activeInput or sameMouseButton) then
            zenxAdaptStealBar.position = card.Position
            pcall(saveAllSettings)
            stopCardDrag()
        end
    end)
    zenxAdaptStealBar.dragConnections = dragConnections

    local outline = Instance.new("UIStroke", card)
    outline.Color = Color3.fromRGB(0, 0, 0)
    outline.Thickness = 1.5
    outline.Transparency = 0

    local percent = Instance.new("TextLabel")
    percent.Name = "ProgressPercent"
    percent.Size = UDim2.new(0, 80, 0, 18)
    percent.Position = UDim2.new(0, 10, 0, 4)
    percent.BackgroundTransparency = 1
    percent.Text = "0%"
    percent.TextColor3 = THEME_PURPLE
    percent.Font = Enum.Font.GothamBold
    percent.TextSize = 11
    percent.TextXAlignment = Enum.TextXAlignment.Left
    percent.TextStrokeTransparency = 1
    percent.ZIndex = 51
    percent.Parent = card

    local metrics = Instance.new("TextLabel")
    metrics.Name = "AdaptMetrics"
    metrics.Size = UDim2.new(0, 120, 0, 18)
    metrics.Position = UDim2.new(1, -130, 0, 4)
    metrics.BackgroundTransparency = 1
    metrics.Text = "FPS --   PING --ms"
    metrics.TextColor3 = THEME_PURPLE
    metrics.Font = Enum.Font.GothamBold
    metrics.TextSize = 11
    metrics.TextXAlignment = Enum.TextXAlignment.Right
    metrics.TextStrokeTransparency = 1
    metrics.ZIndex = 51
    metrics.Parent = card

    local trough = Instance.new("Frame")
    trough.Name = "ProgressTrack"
    trough.Size = UDim2.new(1, -20, 0, 18)
    trough.Position = UDim2.new(0, 10, 1, -22)
    trough.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
    trough.BorderSizePixel = 0
    trough.ClipsDescendants = true
    trough.ZIndex = 51
    trough.Parent = card
    Instance.new("UICorner", trough).CornerRadius = UDim.new(1, 0)
    local troughStroke = Instance.new("UIStroke", trough)
    troughStroke.Color = Color3.fromRGB(0, 0, 0)
    troughStroke.Thickness = 1
    troughStroke.Transparency = 0

    local fill = Instance.new("Frame")
    fill.Name = "ProgressFill"
    fill.Size = UDim2.fromScale(0, 1)
    fill.BackgroundColor3 = THEME_PURPLE
    fill.BorderSizePixel = 0
    fill.ZIndex = 52
    fill.Parent = trough
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local gradient = Instance.new("UIGradient", fill)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 160, 255)),
        ColorSequenceKeypoint.new(0.5, THEME_PURPLE),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 40, 170)),
    })
    gradient.Rotation = 90

    zenxAdaptStealBar.gui = screenGui
    zenxAdaptStealBar.frame = card
    zenxAdaptStealBar.fill = fill
    zenxAdaptStealBar.percent = percent
    zenxAdaptStealBar.metrics = metrics

    -- Mantiene FPS/PING como en la barra de Adapt, sin crear conexiones por cada robo.
    local frameCount = 0
    local renderConn = RunService.RenderStepped:Connect(function() frameCount += 1 end)
    zenxAdaptStealBar.renderConn = renderConn
    task.spawn(function()
        while screenGui.Parent do
            task.wait(1)
            if not screenGui.Parent then break end
            local fps = frameCount
            frameCount = 0
            local ping = 0
            pcall(function() ping = math.floor(LP:GetNetworkPing() * 1000 + 0.5) end)
            metrics.Text = string.format("FPS %d   PING %dms", fps, ping)
        end
        if renderConn.Connected then renderConn:Disconnect() end
    end)

    return true
end

local function showZenxAdaptStealBar(enabled, progress)
    if not ensureZenxAdaptStealBar() then return false end
    local bar = zenxAdaptStealBar
    progress = math.clamp(tonumber(progress) or 0, 0, 1)
    bar.gui.Enabled = enabled == true
    bar.fill.Size = UDim2.fromScale(progress, 1)
    bar.percent.Text = _floor(progress * 100) .. "%"
    return true
end

local function syncAdaptStealBar(enabled, progress)
    enabled = enabled == true
    progress = tonumber(progress) or 0
    _G._ZenxAdaptStealBarEnabled = enabled
    _G._ZenxAdaptStealBarProgress = progress

    -- Oculta el HUD externo si existe y usa el HUD integrado, que respeta Lock UI.
    local setter = rawget(_G, "_AdaptSetExternalStealBar")
    if type(setter) == "function" then
        pcall(setter, false, 0)
    end
    local ok, result = pcall(showZenxAdaptStealBar, enabled, progress)
    if enabled and isStealing then
        if stealTimerLabel then
            stealTimerLabel.Text = string.format("%.1fs", math.max(Steal.StealDuration * (1 - math.clamp(progress, 0, 1)), 0))
            stealTimerLabel.Visible = true
        end
        task.defer(function()
            if not isStealing and stealTimerLabel then stealTimerLabel.Visible = false end
        end)
    elseif stealTimerLabel then
        stealTimerLabel.Visible = false
    end
    return ok and result == true
end
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
                                if child:IsA("ProximityPrompt") and type(child.ActionText) == "string"
                                   and child.ActionText:lower():find("steal", 1, true) then
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
    syncAdaptStealBar(Steal.AutoStealEnabled, 0)

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
                syncAdaptStealBar(Steal.AutoStealEnabled, progress)
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
            syncAdaptStealBar(Steal.AutoStealEnabled, stopProgress)

            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = _tick()

            while isStealing and Steal.AutoStealEnabled do
                if _tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    syncAdaptStealBar(Steal.AutoStealEnabled, 0)
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
                    syncAdaptStealBar(Steal.AutoStealEnabled, 0)
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
                        syncAdaptStealBar(Steal.AutoStealEnabled, 0)
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
                    syncAdaptStealBar(Steal.AutoStealEnabled, totalProgress)
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
                syncAdaptStealBar(Steal.AutoStealEnabled, progress)
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
        syncAdaptStealBar(Steal.AutoStealEnabled, 0)
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
            syncAdaptStealBar(true, 0)
            return true
        end
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    Steal.StealRadius = CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    CONFIG.AUTO_STEAL_ENABLED = true
    syncAdaptStealBar(true, 0)
    local scanAccumulator = 0
    stealConnection = RunService.Heartbeat:Connect(function(dt)
        if not Steal.AutoStealEnabled or isStealing then return end
        scanAccumulator = scanAccumulator + (dt or 0.016)
        if scanAccumulator < 0.10 then return end
        scanAccumulator = 0
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
    if stealTimerLabel then stealTimerLabel.Visible = false end
    Steal.AutoStealEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    syncAdaptStealBar(false, 0)
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
fovValue = 105
customFovConn = nil
setFovVisual = nil
fovSliderSet = nil

_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil

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
setAntiBatVisual = nil
customSoundsSetVisual, setXRayVisual = nil, nil
autoSwingSetVisual = nil
setAntiRagVisual, setJumpVisual, setUnwalkVisual, setAntiLagVisual, setPotatoGraphicsVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil, nil, nil
setAntiDieVisual = nil
setHideButtonsVisual = nil
setESPVIsual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil, nil, nil, nil, nil, nil, nil, nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
instaResetFloatingButton = nil
showGui = nil
hideGui = nil
mainUIScale = nil
menuMetricsTitle = nil
menuHeaderImage = nil
menuHeaderImageAvailable = false
menuV1Brand = nil
menuV2Brand = nil
animSelectorLabel = nil
pbScale = nil
pbBackgroundImage = nil
tabButtons = nil

function applyHideButtonsVisibility()
    local visible = hideButtons ~= true
    if MobilePanel then MobilePanel.Enabled = visible end
    if instaResetFloatingButton then instaResetFloatingButton.Enabled = visible end
end

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
    antiRagdollMode = mode
    if mode == "v1" then AntiRagdollV1.start()
    elseif mode == "v2" then startAntiRagdollV2() end
    if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(mode) end
    saveAllSettings()
end

local AntiDieModule = {
    enabled = false,
    healthConn = nil,
    diedConn = nil,
    charConn = nil,
    humanoid = nil,
    prevStates = {},
    prevBreakJointsOnDeath = nil,
    _reviving = false,
}

local function disconnectHumanoid()
    if AntiDieModule.healthConn then AntiDieModule.healthConn:Disconnect(); AntiDieModule.healthConn = nil end
    if AntiDieModule.diedConn then AntiDieModule.diedConn:Disconnect(); AntiDieModule.diedConn = nil end
    local oldHumanoid = AntiDieModule.humanoid
    if oldHumanoid and oldHumanoid.Parent then
        pcall(function()
            if AntiDieModule.prevBreakJointsOnDeath ~= nil then
                oldHumanoid.BreakJointsOnDeath = AntiDieModule.prevBreakJointsOnDeath
            end
            for stateType, wasEnabled in pairs(AntiDieModule.prevStates) do
                oldHumanoid:SetStateEnabled(stateType, wasEnabled)
            end
        end)
    end
    AntiDieModule.humanoid = nil
    AntiDieModule.prevStates = {}
    AntiDieModule.prevBreakJointsOnDeath = nil
end

local function activateOnCharacter(char)
    if not AntiDieModule.enabled then return end
    char = char or LP.Character or LP.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
    if not hum or not AntiDieModule.enabled then return end
    disconnectHumanoid()
    AntiDieModule.humanoid = hum
    AntiDieModule.prevBreakJointsOnDeath = hum.BreakJointsOnDeath
    AntiDieModule.prevStates = {}
    pcall(function()
        for _, stateType in ipairs({Enum.HumanoidStateType.Dead, Enum.HumanoidStateType.Dying}) do
            AntiDieModule.prevStates[stateType] = hum:GetStateEnabled(stateType)
        end
    end)

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
    if AntiDieModule.enabled and AntiDieModule.charConn then return end
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
    disconnectHumanoid()
    print("[AntiDie] Desactivado (interno)")
end

_G.AntiDie = AntiDieModule

local FloatModule
do
FloatModule = {
    RISE = 17, RATE = 55, CYCLE = 2.5, PAUSE = 0.5, SAMPLE = 0.08, PIT_MARGIN = 15,
    running = false, locked = false, targetY = nil, baseY = nil, baseGround = nil,
    safeValid = false, safeX = 0, safeZ = 0, safeY = 0,
    conn = nil, thread = nil, charConn = nil, respawnTask = nil,
    cycleToken = 0, respawnToken = 0, rayParams = nil,
}

function FloatModule.syncAntiDieForMovement()
    if antiDieEnabled == true or FloatModule.running then
        AntiDieModule.start()
    else
        AntiDieModule.stop()
    end
end

function FloatModule.getCharacterParts()
    local char = LP.Character
    if not char then return nil, nil end
    return char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid")
end

function FloatModule.findGround(char, root)
    local F = FloatModule
    if not F.rayParams then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.IgnoreWater = true
        pcall(function() params.RespectCanCollide = true end)
        F.rayParams = params
    end
    local filter = {char}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            filter[#filter + 1] = player.Character
        end
    end
    local half = root.Size.Y * 0.5
    if half <= 0 then half = 1 end
    local origin = root.Position
    local startY = origin.Y - half - 0.1
    for _ = 1, 6 do
        F.rayParams.FilterDescendantsInstances = filter
        local result = Workspace:Raycast(
            Vector3.new(origin.X, startY, origin.Z), Vector3.new(0, -1000, 0), F.rayParams
        )
        if not result then return nil, half end
        local part = result.Instance
        if part and part:IsA("BasePart") and part.CanCollide then
            local model = part:FindFirstAncestorOfClass("Model")
            if not (model and model:FindFirstChildOfClass("Humanoid")) then
                return result.Position.Y, half
            end
        end
        if part then filter[#filter + 1] = part end
        startY = result.Position.Y - 0.05
    end
    return nil, half
end

function FloatModule.isSafeGround(groundY)
    if not groundY then return false end
    if FloatModule.baseGround and groundY < FloatModule.baseGround - FloatModule.PIT_MARGIN then
        return false
    end
    return true
end

function FloatModule.groundTP()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    local position = root.Position
    local groundY, half
    pcall(function() groundY, half = FloatModule.findGround(char, root) end)
    if not FloatModule.isSafeGround(groundY) and FloatModule.safeValid then
        groundY = FloatModule.safeY
    end
    local targetY
    if groundY then
        half = half or math.max(root.Size.Y * 0.5, 1)
        local offset = half * 3
        if hum.RigType ~= Enum.HumanoidRigType.R6 then
            offset = half + (hum.HipHeight or (half * 2))
        end
        if offset ~= offset or offset < 1 or offset > 12 then offset = half * 3 end
        targetY = groundY + offset + 0.15
    elseif FloatModule.baseY then
        targetY = FloatModule.baseY
    end
    if targetY and targetY == targetY and targetY > -400 then
        pcall(function()
            if position.Y - targetY < 0.5 then
                root.AssemblyLinearVelocity = Vector3.zero
                return
            end
            root.CFrame = CFrame.new(position.X, targetY, position.Z) * root.CFrame.Rotation
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

function FloatModule.startLoop()
    local F = FloatModule
    local function getFloatSelectedSpeed()
        if autoBatEnabled or autoLeftEnabled or autoRightEnabled or dropActive
            or _G.InstaResetInProgress == true then
            return nil
        end
        if laggerCarryToggled then return tonumber(LAGGER_CARRY_SPEED) end
        if laggerToggled then return tonumber(LAGGER_SPEED) end
        if speedMode then return tonumber(CS) end
        return tonumber(NS)
    end
    if F.conn then return end
    F.locked, F.targetY = false, nil
    local firstChar = LP.Character
    local firstRoot = firstChar and firstChar:FindFirstChild("HumanoidRootPart")
    local firstHum = firstChar and firstChar:FindFirstChildOfClass("Humanoid")
    if firstHum and firstHum.FloorMaterial ~= Enum.Material.Air then
        pcall(function() firstHum:ChangeState(Enum.HumanoidStateType.Freefall) end)
    end
    F.safeValid, F.baseGround = false, nil
    if firstChar and firstRoot then
        local ok, ground = pcall(F.findGround, firstChar, firstRoot)
        if ok and ground then
            F.baseGround = ground
            F.safeX, F.safeZ, F.safeY = firstRoot.Position.X, firstRoot.Position.Z, ground
            F.safeValid = true
        end
    end
    local currentChar, currentRoot, currentHum = nil, nil, nil
    local sampleTime = 0
    F.conn = RunService.Heartbeat:Connect(function(dt)
        local char = LP.Character
        if char ~= currentChar or not currentRoot or not currentRoot.Parent then
            currentChar = char
            currentRoot = char and char:FindFirstChild("HumanoidRootPart") or nil
            currentHum = char and char:FindFirstChildOfClass("Humanoid") or nil
        end
        if not currentRoot or not currentHum or currentHum.Health <= 0 then return end
        local cf = currentRoot.CFrame
        local position = cf.Position
        local velocity = currentRoot.AssemblyLinearVelocity
        sampleTime = sampleTime + dt
        if sampleTime >= F.SAMPLE then
            sampleTime = 0
            local ok, ground = pcall(F.findGround, currentChar, currentRoot)
            if ok and F.isSafeGround(ground) then
                F.safeX, F.safeZ, F.safeY = position.X, position.Z, ground
                F.safeValid = true
            elseif ok and F.safeValid and F.baseGround
                and position.Y < F.baseGround - F.PIT_MARGIN and velocity.Y < -8 then
                position = Vector3.new(F.safeX, position.Y, F.safeZ)
            end
        end
        if not F.targetY then
            F.baseY = position.Y
            F.targetY = position.Y + F.RISE
        end
        local y = F.targetY
        if not F.locked then
            y = math.min(position.Y + F.RATE * dt, F.targetY)
            if y >= F.targetY then F.locked = true end
        end
        currentRoot.CFrame = CFrame.new(position.X, y, position.Z) * cf.Rotation
        local horizontalX, horizontalZ = velocity.X, velocity.Z
        local moveDirection = currentHum.MoveDirection
        if moveDirection.Magnitude > 0.05 then
            local speed = getFloatSelectedSpeed()
            if type(speed) == "number" then
                speed = math.clamp(speed, 0, 500)
                horizontalX = moveDirection.Unit.X * speed
                horizontalZ = moveDirection.Unit.Z * speed
            end
        end
        currentRoot.AssemblyLinearVelocity = Vector3.new(horizontalX, 0, horizontalZ)
    end)
end

function FloatModule.stopLoop(tpDown)
    if FloatModule.conn then
        pcall(function() FloatModule.conn:Disconnect() end)
        FloatModule.conn = nil
    end
    if tpDown then pcall(FloatModule.groundTP) end
end

function FloatModule.waitGrounded(timeout)
    local deadline = os.clock() + (timeout or 3)
    while os.clock() < deadline do
        if not FloatModule.running then return end
        local root, hum = FloatModule.getCharacterParts()
        if not root or not hum or hum.Health <= 0 then return end
        if hum.FloorMaterial ~= Enum.Material.Air then
            task.wait(FloatModule.PAUSE)
            return
        end
        RunService.Heartbeat:Wait()
    end
end

function FloatModule.spawnCycle()
    local F = FloatModule
    if F.thread then pcall(task.cancel, F.thread); F.thread = nil end
    F.cycleToken = F.cycleToken + 1
    local token = F.cycleToken
    F.thread = task.spawn(function()
        while F.running and F.cycleToken == token do
            task.wait(F.CYCLE)
            if not F.running or F.cycleToken ~= token then break end
            F.stopLoop(true)
            F.waitGrounded(3)
            if not F.running or F.cycleToken ~= token then break end
            F.startLoop()
        end
        if F.cycleToken == token then F.thread = nil end
    end)
end

function FloatModule.setEnabled(state)
    local F = FloatModule
    local desired = state == true
    if desired then
        if not F.running then
            F.running = true
            FloatModule.syncAntiDieForMovement()
            F.startLoop()
            F.spawnCycle()
        end
    elseif F.running or F.thread or F.conn or F.respawnTask then
        F.running = false
        F.cycleToken = F.cycleToken + 1
        F.respawnToken = F.respawnToken + 1
        if F.thread then pcall(task.cancel, F.thread); F.thread = nil end
        if F.respawnTask then pcall(task.cancel, F.respawnTask); F.respawnTask = nil end
        F.stopLoop(true)
        F.safeValid, F.baseGround = false, nil
        FloatModule.syncAntiDieForMovement()
    else
        FloatModule.syncAntiDieForMovement()
    end
    if setFloatVisual then pcall(setFloatVisual, F.running) end
    if mobSetFloat then pcall(mobSetFloat, F.running) end
    return F.running
end

function FloatModule.toggle()
    return FloatModule.setEnabled(not FloatModule.running)
end

FloatModule.charConn = LP.CharacterAdded:Connect(function(char)
    local F = FloatModule
    if not F.running then return end
    F.cycleToken = F.cycleToken + 1
    if F.thread then pcall(task.cancel, F.thread); F.thread = nil end
    if F.conn then pcall(function() F.conn:Disconnect() end); F.conn = nil end
    F.safeValid, F.baseGround, F.targetY, F.locked = false, nil, nil, false
    F.respawnToken = F.respawnToken + 1
    local token = F.respawnToken
    if F.respawnTask then pcall(task.cancel, F.respawnTask); F.respawnTask = nil end
    F.respawnTask = task.spawn(function()
        local deadline = os.clock() + 5
        while os.clock() < deadline and F.running and F.respawnToken == token do
            if char.Parent and char:FindFirstChild("HumanoidRootPart")
                and char:FindFirstChildOfClass("Humanoid") then break end
            task.wait(0.05)
        end
        local root = char.Parent and char:FindFirstChild("HumanoidRootPart")
        local hum = char.Parent and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or not F.running or F.respawnToken ~= token then return end
        task.wait(0.3)
        if not F.running or F.respawnToken ~= token or LP.Character ~= char then return end
        FloatModule.syncAntiDieForMovement()
        local groundDeadline = os.clock() + 3
        while os.clock() < groundDeadline and F.running and F.respawnToken == token do
            if hum.Health <= 0 then return end
            if hum.FloorMaterial ~= Enum.Material.Air then break end
            RunService.Heartbeat:Wait()
        end
        if F.running and F.respawnToken == token and LP.Character == char then
            F.startLoop()
            F.spawnCycle()
        end
        F.respawnTask = nil
    end)
end)

function FloatModule.cleanup()
    FloatModule.setEnabled(false)
    if FloatModule.charConn then
        pcall(function() FloatModule.charConn:Disconnect() end)
        FloatModule.charConn = nil
    end
    FloatModule.syncAntiDieForMovement()
    local env = type(getgenv) == "function" and getgenv() or _G
    pcall(function() rawset(env, "__BloodHoundsFloatCleanup", nil) end)
    pcall(function() rawset(_G, "__BloodHoundsFloatCleanup", nil) end)
end

local floatEnv = type(getgenv) == "function" and getgenv() or _G
pcall(function() rawset(floatEnv, "__BloodHoundsFloatCleanup", FloatModule.cleanup) end)
pcall(function() rawset(_G, "__BloodHoundsFloatCleanup", FloatModule.cleanup) end)
end -- Float module scope; release helper locals before the rest of the script

local AntiFlingShieldModule = {
    enabled = false,
    loop = nil,
    velocityThreshold = 80,
}

local function stabilizeRoot(root)
    if not root or not root.Parent then return end
    local velocity = root.AssemblyLinearVelocity
    if velocity.Magnitude <= AntiFlingShieldModule.velocityThreshold then return end
    local stabilized = _V3new(0, velocity.Y, 0)
    pcall(function() root.AssemblyLinearVelocity = stabilized end)
    pcall(function() root.AssemblyAngularVelocity = _V3zero end)
    pcall(function() root.Velocity = stabilized end)
    pcall(function() root.RotVelocity = _V3zero end)
end

function AntiFlingShieldModule.start()
    AntiFlingShieldModule.enabled = true
    if AntiFlingShieldModule.loop then AntiFlingShieldModule.loop:Disconnect() end
    AntiFlingShieldModule.loop = RunService.Heartbeat:Connect(function()
        if not AntiFlingShieldModule.enabled then return end
        local char = LP.Character
        stabilizeRoot(char and char:FindFirstChild("HumanoidRootPart"))
    end)
    print("[AntiFlingShield] Activado (interno)")
end

function AntiFlingShieldModule.stop()
    AntiFlingShieldModule.enabled = false
    if AntiFlingShieldModule.loop then
        AntiFlingShieldModule.loop:Disconnect()
        AntiFlingShieldModule.loop = nil
    end
    print("[AntiFlingShield] Desactivado (interno)")
end

_G.AntiFlingShield = AntiFlingShieldModule

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
        lbl.Font = UI_FONT_HEAVY
        lbl.TextScaled = true
        lbl.TextColor3 = selectedColor
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextStrokeTransparency = 0
        lbl.Text = ""
        lbl.Parent = bb
        local grad = Instance.new("UIGradient", lbl)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, selectedColor),
            ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, selectedColor),
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

local espConn = nil
local _espLastRun = 0

local function clearESP()
    for plr in pairs(espHighlightCache) do
        pcall(function() espHighlightCache[plr]:Destroy() end)
    end
    for plr in pairs(espBillboardCache) do
        pcall(function() espBillboardCache[plr]:Destroy() end)
    end
    for plr in pairs(espTracerCache) do
        for _, ln in ipairs(espTracerCache[plr]) do
            pcall(function() ln.Visible = false; ln:Remove() end)
        end
    end
    espHighlightCache = {}
    espBillboardCache = {}
    espTracerCache = {}
end

local function makeESPTracers()
    if not (Drawing and type(Drawing.new) == "function") then return nil end
    local color = getThemeColor()
    local outer = Drawing.new("Line")
    outer.Color = color
    outer.Thickness = 2.2
    outer.Transparency = 0.90
    outer.Visible = false
    local mid = Drawing.new("Line")
    mid.Color = color
    mid.Thickness = 1.2
    mid.Transparency = 0.74
    mid.Visible = false
    local core = Drawing.new("Line")
    core.Color = color
    core.Thickness = 0.6
    core.Transparency = 0.10
    core.Visible = false
    return {outer, mid, core}
end

local function updateESP()
    local now = _tick()
    if now - _espLastRun < 0.08 then return end
    _espLastRun = now
    if not espEnabled then clearESP(); return end
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myPos = myRoot.Position
    local currentCamera = workspace.CurrentCamera or camera
    if not currentCamera then return end
    local viewport = currentCamera.ViewportSize
    local myVec = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
    local currentPlayers = _GetPlayersCached()
    local plrSet = {}
    for _, p in ipairs(currentPlayers) do plrSet[p] = true end
    for plr in pairs(espHighlightCache) do
        if not plrSet[plr] then
            pcall(function() espHighlightCache[plr]:Destroy() end)
            espHighlightCache[plr] = nil
        end
    end
    for plr in pairs(espBillboardCache) do
        if not plrSet[plr] then
            pcall(function() espBillboardCache[plr]:Destroy() end)
            espBillboardCache[plr] = nil
        end
    end
    for plr in pairs(espTracerCache) do
        if not plrSet[plr] then
            for _, ln in ipairs(espTracerCache[plr]) do
                pcall(function() ln.Visible = false; ln:Remove() end)
            end
            espTracerCache[plr] = nil
        end
    end
    local color = getThemeColor()
    for _, plr in ipairs(currentPlayers) do
        if plr == LP then continue end
        local char = plr.Character
        if not char then
            if espHighlightCache[plr] then
                pcall(function() espHighlightCache[plr]:Destroy() end)
                espHighlightCache[plr] = nil
            end
            if espBillboardCache[plr] then
                pcall(function() espBillboardCache[plr]:Destroy() end)
                espBillboardCache[plr] = nil
            end
            if espTracerCache[plr] then
                for _, ln in ipairs(espTracerCache[plr]) do
                    pcall(function() ln.Visible = false end)
                end
            end
            continue
        end
        local tRoot = char:FindFirstChild("HumanoidRootPart")
        local tHead = char:FindFirstChild("Head")
        local tHum = char:FindFirstChildOfClass("Humanoid")
        local alive = tRoot and tHum and tHum.Health > 0
        if alive then
            -- Player ESP solo muestra la línea de ubicación y la velocidad.
            -- El perfil/indicador sobre la cabeza y el resaltado del cuerpo se eliminan.
            if espHighlightCache[plr] then
                pcall(function() espHighlightCache[plr]:Destroy() end)
                espHighlightCache[plr] = nil
            end
            if espBillboardCache[plr] then
                pcall(function() espBillboardCache[plr]:Destroy() end)
                espBillboardCache[plr] = nil
            end
            if tHead then
                local oldProfile = tHead:FindFirstChild("ProfilePic")
                if oldProfile then pcall(function() oldProfile:Destroy() end) end
            end
            local lines = espTracerCache[plr]
            if not lines then
                lines = makeESPTracers()
                espTracerCache[plr] = lines or {}
            end
            if lines and #lines > 0 then
                local destPos = tRoot.Position
                local pos, onScreen = currentCamera:WorldToViewportPoint(destPos)
                if onScreen and pos.Z > 0 then
                    local tVec = Vector2.new(pos.X, pos.Y)
                    for _, ln in ipairs(lines) do
                        ln.From = myVec
                        ln.To = tVec
                        ln.Visible = true
                    end
                else
                    for _, ln in ipairs(lines) do ln.Visible = false end
                end
            end
        else
            if espHighlightCache[plr] then
                pcall(function() espHighlightCache[plr]:Destroy() end)
                espHighlightCache[plr] = nil
            end
            if espBillboardCache[plr] then
                pcall(function() espBillboardCache[plr]:Destroy() end)
                espBillboardCache[plr] = nil
            end
            if espTracerCache[plr] then
                for _, ln in ipairs(espTracerCache[plr]) do
                    pcall(function() ln.Visible = false end)
                end
            end
        end
    end
end

local function startESPLoop()
    if espConn then espConn:Disconnect() end
    espConn = RunService.RenderStepped:Connect(updateESP)
end

local function stopESPLoop()
    if espConn then espConn:Disconnect(); espConn = nil end
    clearESP()
end

function toggleESP(on)
    espEnabled = on
    if on then startESPLoop() else stopESPLoop() end
    if setESPVIsual then setESPVIsual(on) end
end

local _enemySpeedAcc = 0
function updateEnemySpeedLabels()
    _enemySpeedAcc = _enemySpeedAcc + 1
    if _enemySpeedAcc < 6 then return end
    _enemySpeedAcc = 0

    local color = getThemeColor()
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
                        tl.Font = UI_FONT_BOLD
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
    -- Eliminar también los BillboardGui creados para jugadores anteriores.
    for player, label in pairs(enemySpeedLabels) do
        pcall(function()
            local bb = label and label.Parent
            if bb then bb:Destroy() end
        end)
        enemySpeedLabels[player] = nil
    end
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

local function _bodyLockTick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local target = getClosestTargetBody()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = _clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = _clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = _V3new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = _CFlookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = _clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    local acc = 0
    _bodyLockConn = RunService.Heartbeat:Connect(function(dt)
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        acc = acc + dt
        if acc < 0.033 then return end
        acc = 0
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then
        _bodyLockConn:Disconnect()
        _bodyLockConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = _V3zero
        root.AssemblyLinearVelocity = _V3new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function _suppressBodyLock()
    _blSuppressCount = _blSuppressCount + 1
    if _blSuppressCount == 1 and bodyLockEnabled then
        _blWasEnabled = true
        stopBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(false) end
        if _blRestoreTimer then
            task.cancel(_blRestoreTimer)
            _blRestoreTimer = nil
        end
        _blSmoothRestore = false
    end
end

function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then
        _blSuppressCount = _blSuppressCount - 1
    end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        if _blRestoreTimer then
            pcall(task.cancel, _blRestoreTimer)
            _blRestoreTimer = nil
        end
        local function restore()
            _blRestoreTimer = nil
            if bodyLockEnabled then
                _blSmoothRestore = true
                startBodyLock()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                task.delay(0.5, function() _blSmoothRestore = false end)
            end
        end
        if delayed then
            _blRestoreTimer = task.delay(1, restore)
        else
            restore()
        end
    end
end

function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("BloodHoundsSpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "BloodHoundsSpeedIndicator"
    bb.Size = UDim2.new(0, 180, 0, 106)
    bb.StudsOffset = _V3new(0, 4.1, 0)
    bb.AlwaysOnTop = true
    local titleLabel = Instance.new("TextLabel", bb)
    titleLabel.Name = "4KTDuelsTitle"
    titleLabel.Size = UDim2.new(1, 0, 0, 42)
    titleLabel.Position = UDim2.new(0, 0, 0, 28)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "4KT DUELS"
    titleLabel.TextColor3 = getThemeColor()
    titleLabel.Font = UI_FONT_HEAVY
    titleLabel.TextScaled = true
    titleLabel.TextStrokeTransparency = 0
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    applyShimmerToText(titleLabel, 0.9)
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Size = UDim2.new(1, 0, 0, 36)
    speedLabel.Position = UDim2.new(0, 0, 0, 70)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Spd: 0.0"
    speedLabel.TextColor3 = getThemeColor()
    speedLabel.Font = UI_FONT_BOLD
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    applyShimmerToText(speedLabel, 0.9)
end

local unwalkSavedAnimate = nil

function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        unwalkSavedAnimate = anim:Clone()
        anim:Destroy()
    end
end

function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then
                starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then
                unwalkSavedAnimate:Clone().Parent = c
            end
        end
    end
    unwalkSavedAnimate = nil
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
    -- Mantener sincronizados ambos motores de movimiento. Antes, al usar
    -- CarrySystem, los botones solo cambiaban la UI y el motor conservaba
    -- la velocidad/modo anterior.
    if useCarrySystem then
        CarrySystem.speedToggled = speedMode == true
        if laggerCarryToggled then
            CarrySystem:setLaggerMode(2)
        elseif laggerToggled then
            CarrySystem:setLaggerMode(1)
        else
            CarrySystem:setLaggerMode(0)
        end
    end
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

-- ============================================================
-- Auto Carry de Zenx (On Pick Up + Soft Steal)
-- ============================================================
do
    _G._VynxAutoSpeedRange = tonumber(_G._VynxAutoSpeedRange) or 12
    local state = { active = false, previous = nil, graceUntil = 0, conn = nil }
    local soft  = { spots = {}, nextScan = 0, latched = false, held = false, armed = true }
    local checkAccumulator = 0

    local function getFamily()
        if laggerToggled or laggerCarryToggled then return "lagger" end
        return "normal"
    end
    local function getCarry()
        return (speedMode == true) or (laggerCarryToggled == true)
    end
    local function setFamilyCarry(family, carry)
        carry = carry == true
        if family == "lagger" then
            laggerCarryToggled = carry
            laggerToggled      = not carry
            speedMode          = false
        else
            laggerToggled      = false
            laggerCarryToggled = false
            speedMode          = carry
        end
    end
    local function refresh()
        if refreshSpeedModeLabel then pcall(refreshSpeedModeLabel) end
        if _G.__ZenxApplySpeedNow then pcall(_G.__ZenxApplySpeedNow) end
    end

    local function isWeaponName(value)
        local n = tostring(value or ""):lower()
        return n:find("bat") or n:find("slap") or n:find("medusa")
            or n:find("head") or n:find("stone")
    end

    local function isCarrying(character)
        if not character then return false end
        if LP:GetAttribute("Stealing") == true
            or LP:GetAttribute("AntiKick") == true
            or character:GetAttribute("Stealing") == true then
            return true
        end
        for _, entry in ipairs({ "Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab" }) do
            local inst = character:FindFirstChild(entry, true)
            if inst and (
                (inst:IsA("BoolValue")    and inst.Value)
                or (inst:IsA("ObjectValue") and inst.Value)
                or (inst:IsA("StringValue") and inst.Value ~= "")
            ) then return true end
        end
        for _, child in ipairs(character:GetChildren()) do
            local n = child.Name:lower()
            if child:IsA("Tool") and not isWeaponName(n) then return true end
            local bp = child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true)
            local hit
            if bp then
                hit = n:find("brainrot") or n:find("animal") or n:find("carry")
                   or n:find("grab")     or n:find("steal")  or n:find("hold")
            else
                hit = bp
            end
            if hit then return true end
        end
        return false
    end

    local function enable()
        if state.active then
            state.graceUntil = tick() + 0.75
            return
        end
        state.previous   = { family = getFamily(), carry = getCarry() }
        state.active     = true
        state.graceUntil = tick() + 0.75
        setFamilyCarry(getFamily(), true)
        refresh()
    end

    local function restore()
        if not state.active then return end
        local previous = state.previous
        state.active   = false
        state.previous = nil
        if previous then setFamilyCarry(previous.family, previous.carry) end
        refresh()
    end

    local function softEnable()
        if not state.active then
            state.previous = { family = getFamily(), carry = getCarry() }
            state.active   = true
        end
        state.graceUntil = tick() + 0.75
        setFamilyCarry(getFamily(), true)
        refresh()
    end

    local function scanSpots()
        local spots = {}
        local plots = workspace:FindFirstChild("Plots")
        if not plots then soft.spots = spots; return end
        for _, child in ipairs(plots:GetChildren()) do
            local sign = child:FindFirstChild("PlotSign")
            sign = sign and sign:FindFirstChild("YourBase")
            if not (sign and sign:IsA("BillboardGui") and sign.Enabled == true) then
                local pods = child:FindFirstChild("AnimalPodiums")
                if pods then
                    for _, pod in ipairs(pods:GetChildren()) do
                        local base = pod:FindFirstChild("Base")
                        base = base and base:FindFirstChild("Spawn")
                        if base then spots[#spots + 1] = base.Position end
                    end
                end
            end
        end
        soft.spots = spots
    end

    local function nearStealSpot(character)
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        local range = tonumber(_G._VynxAutoSpeedRange) or 15
        local target = _G._VantaStealTargetPos or _G._RaVeStealTargetPos
        if typeof(target) == "Vector3" and (root.Position - target).Magnitude <= range then
            return true
        end
        local now = tick()
        if soft.nextScan <= now then
            soft.nextScan = now + 0.5
            scanSpots()
        end
        for _, spot in ipairs(soft.spots) do
            if (root.Position - spot).Magnitude <= range then return true end
        end
        return false
    end

    local function startAutoCarry()
        if state.conn then state.conn:Disconnect() end
        checkAccumulator = 0
        state.conn = RunService.RenderStepped:Connect(function(dt)
            checkAccumulator = checkAccumulator + (dt or 0.016)
            if checkAccumulator < 0.08 then return end
            checkAccumulator = 0
            if not autoCarryEnabled then
                restore(); return
            end
            local character = LP.Character
            local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
            if not character or not humanoid or humanoid.Health <= 0 then
                restore(); return
            end

            if autoCarryMode == "Soft Steal" then
                local near     = nearStealSpot(character)
                local carrying = isCarrying(character)
                local away     = not near

                if away then soft.armed = true end
                if away or getCarry() ~= true then soft.latched = false end

                if near and soft.armed and not soft.latched then
                    soft.latched = true
                    soft.held    = false
                    softEnable()
                end

                if state.active then
                    if carrying then
                        soft.held = true
                        state.graceUntil = tick() + 0.75
                    elseif soft.held then
                        soft.held    = false
                        soft.latched = false
                        soft.armed   = false
                        restore()
                    else
                        local away2 = not near
                        if away2 then away2 = tick() > state.graceUntil end
                        if away2 then
                            soft.latched = false
                            restore()
                        end
                    end
                end
                return
            end

            if isCarrying(character) then
                enable()
            elseif state.active then
                restore()
            end
        end)
    end

    local function stopAutoCarry()
        if state.conn then
            state.conn:Disconnect()
            state.conn = nil
        end
        soft.latched = false
        soft.held    = false
        soft.armed   = true
        restore()
    end

    LP.CharacterAdded:Connect( function()
        soft.latched = false
        soft.held    = false
        soft.armed   = true
    end)

    _G._AdaptStartAutoCarry = startAutoCarry
    _G._AdaptStopAutoCarry  = stopAutoCarry
    _G._CandyIsCarrying     = isCarrying
    _G.AutoCarrySpeed = {
        IsCarryingBrainrot = isCarrying,
        Enable             = enable,
        Disable            = restore,
        Restore            = restore,
        WatchPickup        = function() end,
    }
    _G.__ZenxAutoCarryRestore = restore
    _G.__ZenxAutoCarryReapply = function() end
    startAutoCarry()
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
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, closestDist = nil, _huge
    for _, player in ipairs(_GetPlayersCached()) do
        if player ~= LP then
            local targetChar = player.Character
            local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHum and targetHum.Health > 0 then
                local dist = (targetRoot.Position - root.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = targetRoot
                end
            end
        end
    end
    return closest
end

function trySwing()
    local char = LP.Character
    if not char then return end
    local bat = findBat()
    -- No cambiar la herramienta que el jugador ya equipó.
    if bat and bat.Parent == char then pcall(function() bat:Activate() end) end
end

-- Bat aimbot replacement adapted from Vx7Leakedbyme.
-- Preserves the attached implementation's nearest-target tracking, per-target
-- velocity prediction, predictive steering, LinearVelocity mover, and swing flow.
local _vx7Aimbot = {
    connection = nil,
    swing = false,
    attachmentName = "VX7AimbotMoveAttachment",
    moverName = "VX7AimbotMoveVelocity",
    minForce = 1000000,
    maxForce = 50000000,
}
local _vx7Predictions = setmetatable({}, {__mode = "k"})

local function vx7CurrentSpeed()
    local laggerEnabled = laggerToggled or laggerCarryToggled
    local configured = laggerEnabled and (laggerCarryToggled and LAGGER_CARRY_SPEED or LAGGER_SPEED) or BAT_AIMBOT_SPEED
    return _clamp(tonumber(configured) or (laggerEnabled and 40 or 58), 1, 500)
end

local function vx7GetBat()
    local character = LP.Character
    if not character then return nil end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            local name = child.Name:lower()
            if name:find("bat", 1, true) or name:find("slap", 1, true) then return child end
        end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("bat", 1, true) or name:find("slap", 1, true) then return child end
            end
        end
    end
    return nil
end

local function vx7NearestTarget(root)
    local nearest, nearestDistance = nil, _huge
    for _, player in ipairs(_GetPlayersCached()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (targetRoot.Position - root.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearest = targetRoot
                end
            end
        end
    end
    return nearest
end

local function vx7ClearMover(root)
    root = root or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
    if not root then return end
    local mover = root:FindFirstChild(_vx7Aimbot.moverName)
    local attachment = root:FindFirstChild(_vx7Aimbot.attachmentName)
    if mover and mover:IsA("LinearVelocity") then mover:Destroy() end
    if attachment and attachment:IsA("Attachment") then attachment:Destroy() end
end

local function vx7EnsureMover(root, speed)
    local attachment = root:FindFirstChild(_vx7Aimbot.attachmentName)
    if attachment and not attachment:IsA("Attachment") then attachment:Destroy(); attachment = nil end
    if not attachment then
        attachment = Instance.new("Attachment")
        attachment.Name = _vx7Aimbot.attachmentName
        attachment.Parent = root
    end
    local mover = root:FindFirstChild(_vx7Aimbot.moverName)
    if not mover or not mover:IsA("LinearVelocity") then
        if mover then mover:Destroy() end
        mover = Instance.new("LinearVelocity")
        mover.Name = _vx7Aimbot.moverName
        mover.Attachment0 = attachment
        mover.RelativeTo = Enum.ActuatorRelativeTo.World
        mover.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        mover.ForceLimitsEnabled = true
        mover.ForceLimitMode = Enum.ForceLimitMode.PerAxis
        mover.VectorVelocity = _V3zero
        mover.Parent = root
    else
        mover.Attachment0 = attachment
    end
    local force = _clamp(root.AssemblyMass * math.max(speed * 220, 6000), _vx7Aimbot.minForce, _vx7Aimbot.maxForce)
    mover.MaxAxesForce = _V3new(force, force, force)
    mover.Enabled = true
    return mover
end

local function vx7ApplyMove(root, desiredVelocity, speed, dt)
    local mover = vx7EnsureMover(root, speed)
    local alpha = 1 - math.exp(-math.max(dt or (1 / 60), 0) * 26)
    mover.VectorVelocity = mover.VectorVelocity:Lerp(desiredVelocity, alpha)
    -- Keep the optional executor sync hook from the attached implementation,
    -- but never require it in ordinary Roblox/Luau environments.
    if type(_G._vxSyncSpoof) == "function" then
        pcall(_G._vxSyncSpoof, _V3new(
            _clamp(desiredVelocity.X, -16, 16),
            root.AssemblyLinearVelocity.Y,
            _clamp(desiredVelocity.Z, -16, 16)
        ))
    end
end

local function vx7ResetMotion()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if root then
        vx7ClearMover(root)
        root.Anchored = false
        root.AssemblyLinearVelocity = _V3zero
        root.AssemblyAngularVelocity = _V3zero
        local look = root.CFrame.LookVector
        local flat = _V3new(look.X, 0, look.Z)
        flat = flat.Magnitude > 0.01 and flat.Unit or _V3new(0, 0, -1)
        root.CFrame = _CFlookAt(root.Position, root.Position + flat)
        if type(_G._vxSyncSpoof) == "function" then pcall(_G._vxSyncSpoof, _V3zero) end
    end
    if humanoid then
        humanoid.AutoRotate = true
        humanoid.PlatformStand = false
        pcall(function() humanoid:Move(_V3zero, false) end)
        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

local function vx7Update(dt)
    if not autoBatEnabled then return end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not root or not humanoid or humanoid.Health <= 0 then return end

    local target = vx7NearestTarget(root)
    if not target then
        humanoid.AutoRotate = true
        root.AssemblyAngularVelocity = _V3zero
        vx7ClearMover(root)
        return
    end

    local speed = vx7CurrentSpeed()
    humanoid.AutoRotate = false
    local now = _tick()
    local sample = _vx7Predictions[target]
    local targetVelocity = _V3zero
    if not sample then
        _vx7Predictions[target] = {pos = target.Position, time = now, vel = _V3zero}
    else
        local elapsed = _clamp(now - sample.time, 1 / 120, 0.25)
        local measured = (target.Position - sample.pos) / elapsed
        sample.vel = sample.vel:Lerp(measured.Magnitude > 80 and measured.Unit * 80 or measured, 0.25)
        sample.pos = target.Position
        sample.time = now
        targetVelocity = sample.vel
    end

    local predicted = target.Position
        + targetVelocity * _clamp(targetVelocity.Magnitude / 130, 0.05, 0.12)
    local delta = predicted - root.Position
    local aimDirection = delta.Magnitude > 0.01 and delta.Unit or _V3zero
    local flatDelta = _V3new(delta.X, 0, delta.Z)

    if delta.Magnitude > 0.01 and flatDelta.Magnitude > 0.01 then
        local yaw = (math.deg(math.atan2(-flatDelta.X, -flatDelta.Z)) - root.Orientation.Y + 180) % 360 - 180
        local pitch = (math.deg(math.atan2(delta.Y, flatDelta.Magnitude)) - root.Orientation.X + 180) % 360 - 180
        local yawRate = _clamp(math.rad(yaw) * 285, -28, 28)
        local pitchRate = _clamp(math.rad(pitch) * 285, -28, 28)
        local angle = math.rad(root.Orientation.Y)
        local pitchAxis = _V3new(math.cos(angle), 0, -math.sin(angle))
        root.AssemblyAngularVelocity = _V3new(0, yawRate, 0) + pitchAxis * pitchRate
    else
        root.AssemblyAngularVelocity = _V3zero
    end

    -- Same contact geometry as the attached implementation.
    local contactDelta = predicted - aimDirection * 2.8 + _V3new(0, 4.75, 0) - root.Position
    local horizontalDelta = _V3new(contactDelta.X, 0, contactDelta.Z)
    local horizontalVelocity = horizontalDelta.Magnitude > 0.1 and horizontalDelta.Unit * speed or _V3zero
    local verticalVelocity = math.abs(contactDelta.Y) > 0.1
        and _V3new(0, math.sign(contactDelta.Y) * 52, 0)
        or _V3new(0, -2, 0)
    vx7ApplyMove(root, horizontalVelocity + verticalVelocity, speed, dt)
    if horizontalDelta.Magnitude > 0.5 then humanoid:Move(horizontalDelta.Unit, false) end

    if AUTO_SWING_ENABLED then
        local bat = vx7GetBat()
        if bat and bat.Parent == character then
            pcall(function() bat:Activate() end)
        end
    end
end

_G.__VX7ClearAimbotMover = function() pcall(vx7ClearMover) end

function stopAimbotAdapt()
    if _vx7Aimbot.connection then
        pcall(function() _vx7Aimbot.connection:Disconnect() end)
        _vx7Aimbot.connection = nil
    end
    _vx7Predictions = setmetatable({}, {__mode = "k"})
    _vx7Aimbot.swing = false
    vx7ResetMotion()
    _unsuppressBodyLock(true)
end

function startAimbotAdapt()
    if _vx7Aimbot.connection then return end
    _suppressBodyLock()
    _vx7Predictions = setmetatable({}, {__mode = "k"})
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if character and humanoid and not character:FindFirstChildOfClass("Tool") then
        local bat = vx7GetBat()
        if bat and bat.Parent ~= character then pcall(function() humanoid:EquipTool(bat) end) end
    end
    vx7ClearMover()
    _vx7Aimbot.connection = RunService.RenderStepped:Connect(vx7Update)
end

function disableAutoBat()
    autoBatEnabled = false
    CarrySystem._batAimbotToggled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

function enableAutoBat()
    autoBatEnabled = true
    CarrySystem._batAimbotToggled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

-- ============================================================
-- ANTI BAT
-- Pulso horizontal breve para contrarrestar el golpe del bate.
-- No fuerza estados de ragdoll: esa responsabilidad queda en Anti Ragdoll.
-- ============================================================
local AntiBat = {Connection = nil}

function stopAntiBat()
    antiBatEnabled = false
    if AntiBat.Connection then
        pcall(function() AntiBat.Connection:Disconnect() end)
        AntiBat.Connection = nil
    end
end

function startAntiBat()
    stopAntiBat()
    antiBatEnabled = true

    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    AntiBat.Connection = RunService.Heartbeat:Connect(function()
        if not antiBatEnabled then return end
        if not root or not root.Parent then
            root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
        end

        local vel = root.AssemblyLinearVelocity
        local flat = _V3new(vel.X, 0, vel.Z)
        root.AssemblyLinearVelocity = _V3new(500, vel.Y, 500)
        RunService.RenderStepped:Wait()
        if root and root.Parent and antiBatEnabled then
            local y2 = root.AssemblyLinearVelocity.Y
            root.AssemblyLinearVelocity = _V3new(flat.X, y2, flat.Z)
        end
    end)
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
    local bp = LP:FindFirstChildOfClass("Backpack")
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
            local hum2 = c:FindFirstChildOfClass("Humanoid")
            pcall(function()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, _V3new(0, -3000, 0), rp)
                if rr then
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

-- Anti Lag de Bubble Hub integrado.
-- Procesa el mapa por lotes, reduce carga de render y restaura todas las
-- propiedades modificadas al desactivarse para evitar dejar el mapa roto.
local antiLagSaved = setmetatable({}, {__mode = "k"})
local antiLagAnimationSaved = setmetatable({}, {__mode = "k"})
local antiLagDetached = {}
local antiLagConnections = {}
local antiLagGeneration = 0
local antiLagWorker = nil

local function antiLagSet(instance, property, value)
    if not instance then return end
    local saved = antiLagSaved[instance]
    if not saved then
        saved = {}
        antiLagSaved[instance] = saved
    end
    if saved[property] == nil then
        local ok, old = pcall(function() return instance[property] end)
        if not ok then return end
        saved[property] = old
    end
    pcall(function() instance[property] = value end)
end

local function antiLagSkip(instance)
    if not instance then return true end
    local char = LP.Character
    if char and (instance == char or instance:IsDescendantOf(char)) then return true end
    local current = instance
    while current and current ~= workspace do
        local name = current.Name or ""
        if current:IsA("LayerCollector") or current:IsA("GuiObject") or current:IsA("GuiBase2d") then
            return true
        end
        if name:match("^Bubble") or name:match("^__Bubble")
            or name:match("^ESP_") or name:match("^SkinChanger_")
            or name:match("^Korblox_") or name == "Headless_Headless"
            or name == "GreenDuelsBB" or name == "PredictionSphere" then
            return true
        end
        current = current.Parent
    end
    return false
end

local function antiLagStopAnimator(animator)
    if not animator or antiLagSkip(animator) then return end
    local tracks = {}
    local ok = pcall(function()
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track.IsPlaying then
                tracks[track] = {
                    animator = animator,
                    time = track.TimePosition,
                    speed = track.Speed,
                }
                track:Stop(0)
            end
        end
    end)
    if ok and next(tracks) then
        for track, data in pairs(tracks) do antiLagAnimationSaved[track] = data end
    end
end

function applyAntiLagDerender(obj)
    if not obj or antiLagSkip(obj) then return end
    pcall(function()
        if obj:IsA("Terrain") then
            antiLagSet(obj, "Decoration", false)
            antiLagSet(obj, "WaterWaveSize", 0)
            antiLagSet(obj, "WaterWaveSpeed", 0)
            antiLagSet(obj, "WaterReflectance", 0)
            antiLagSet(obj, "WaterTransparency", 1)
        elseif obj:IsA("BasePart") then
            antiLagSet(obj, "Material", Enum.Material.Plastic)
            antiLagSet(obj, "MaterialVariant", "")
            antiLagSet(obj, "Reflectance", 0)
            antiLagSet(obj, "CastShadow", false)
            if obj:IsA("MeshPart") then
                antiLagSet(obj, "TextureID", "")
                antiLagSet(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
                antiLagSet(obj, "DoubleSided", false)
            elseif obj:IsA("PartOperation") then
                antiLagSet(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
            end
        elseif obj:IsA("SpecialMesh") then
            antiLagSet(obj, "TextureId", "")
        elseif obj:IsA("SurfaceAppearance") then
            if antiLagSaved[obj] == nil then table.insert(antiLagDetached, obj) end
            antiLagSet(obj, "Parent", nil)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            antiLagSet(obj, "Transparency", 1)
            antiLagSet(obj, "Texture", "")
        elseif obj:IsA("ParticleEmitter") then
            antiLagSet(obj, "Enabled", false)
            antiLagSet(obj, "Rate", 0)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Trail") then
            antiLagSet(obj, "Enabled", false)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke")
            or obj:IsA("Sparkles") or obj:IsA("Light")
            or obj:IsA("PostEffect") or obj:IsA("Clouds") then
            antiLagSet(obj, "Enabled", false)
        elseif obj:IsA("Atmosphere") then
            antiLagSet(obj, "Density", 0)
            antiLagSet(obj, "Haze", 0)
            antiLagSet(obj, "Glare", 0)
        elseif obj:IsA("Sky") then
            for _, property in ipairs({"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp", "SunTextureId", "MoonTextureId"}) do
                antiLagSet(obj, property, "")
            end
            antiLagSet(obj, "StarCount", 0)
            antiLagSet(obj, "CelestialBodiesShown", false)
        elseif obj:IsA("Shirt") then
            antiLagSet(obj, "ShirtTemplate", "")
        elseif obj:IsA("Pants") then
            antiLagSet(obj, "PantsTemplate", "")
        elseif obj:IsA("ShirtGraphic") then
            antiLagSet(obj, "Graphic", "")
        elseif obj:IsA("Animator") then
            antiLagStopAnimator(obj)
        end
    end)
end

local function applyAntiLagLighting()
    antiLagSet(Lighting, "GlobalShadows", false)
    antiLagSet(Lighting, "EnvironmentDiffuseScale", 0)
    antiLagSet(Lighting, "EnvironmentSpecularScale", 0)
    antiLagSet(Lighting, "FogStart", 0)
    antiLagSet(Lighting, "FogEnd", 10000000000)
    pcall(function() antiLagSet(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01) end)
    pcall(function()
        antiLagSet(UserSettings():GetService("UserGameSettings"), "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
    end)
end

local function antiLagWalkBatch(root, callback, generation)
    local descendants = root:GetDescendants()
    local index, total = 0, #descendants
    while index < total and antiLagEnabled and antiLagGeneration == generation do
        for _ = 1, 200 do
            index += 1
            if index > total then break end
            callback(descendants[index])
        end
        task.wait()
    end
end

function enablePotatoGraphics()
    if potatoGraphicsEnabled then return end
    potatoGraphicsEnabled = true
    pcall(function()
        local rendering = settings().Rendering
        if potatoGraphicsSavedQuality == nil then
            potatoGraphicsSavedQuality = rendering.QualityLevel
        end
        rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
end

function disablePotatoGraphics()
    potatoGraphicsEnabled = false
    pcall(function()
        if potatoGraphicsSavedQuality then
            settings().Rendering.QualityLevel = potatoGraphicsSavedQuality
        end
    end)
    potatoGraphicsSavedQuality = nil
end

function enableAntiLag()
    -- Si la preferencia se cargó desde el archivo, antiLagEnabled ya es true,
    -- pero todavía no existen worker ni conexiones: en ese caso debe iniciarse.
    if antiLagEnabled and (antiLagWorker or #antiLagConnections > 0) then return end
    antiLagEnabled = true
    antiLagGeneration += 1
    local generation = antiLagGeneration
    applyAntiLagLighting()
    antiLagWorker = task.spawn(function()
        antiLagWalkBatch(workspace, applyAntiLagDerender, generation)
        if antiLagEnabled and antiLagGeneration == generation then
            antiLagWalkBatch(Lighting, applyAntiLagDerender, generation)
        end
        antiLagWorker = nil
    end)
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if antiLagEnabled and antiLagGeneration == generation then
            task.defer(applyAntiLagDerender, obj)
        end
    end)
    table.insert(antiLagConnections, Lighting.DescendantAdded:Connect(function(obj)
        if antiLagEnabled and antiLagGeneration == generation then
            task.defer(applyAntiLagDerender, obj)
        end
    end))
    table.insert(antiLagConnections, Lighting.Changed:Connect(function(property)
        if antiLagEnabled and antiLagGeneration == generation
            and (property == "GlobalShadows" or property == "EnvironmentDiffuseScale"
            or property == "EnvironmentSpecularScale" or property == "FogStart" or property == "FogEnd") then
            applyAntiLagLighting()
        end
    end))
end

function disableAntiLag()
    antiLagEnabled = false
    antiLagGeneration += 1
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
    for _, connection in ipairs(antiLagConnections) do
        pcall(function() connection:Disconnect() end)
    end
    antiLagConnections = {}
    if antiLagWorker then
        pcall(task.cancel, antiLagWorker)
        antiLagWorker = nil
    end
    for instance, properties in pairs(antiLagSaved) do
        for property, value in pairs(properties) do
            pcall(function() instance[property] = value end)
        end
        antiLagSaved[instance] = nil
    end
    table.clear(antiLagDetached)
    for track, data in pairs(antiLagAnimationSaved) do
        pcall(function()
            if data.animator and data.animator.Parent and not track.IsPlaying then
                track:Play(0, 1, data.speed)
                track.TimePosition = data.time
            end
        end)
        antiLagAnimationSaved[track] = nil
    end
end

CUSTOM_FOV_BIND = "OceanCustomFOV"

function enableCustomFov()
    local cam = workspace.CurrentCamera
    if cam and origFOV == nil then origFOV = cam.FieldOfView end
    fovEnabled = true
    -- FOV amplio para que la cámara se vea más alejada.
    fovValue = 105
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
        ColorShiftTop = Lighting.ColorShift_Top,
        ColorShiftBottom = Lighting.ColorShift_Bottom,
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
    if old.ColorShiftTop then Lighting.ColorShift_Top = old.ColorShiftTop end
    if old.ColorShiftBottom then Lighting.ColorShift_Bottom = old.ColorShiftBottom end
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

function paintFloatingBtn(btnFrame, active)
    if not btnFrame then return end
    local bg = btnFrame:FindFirstChild("BtnGrad")
    local label = btnFrame:FindFirstChild("TextLabel")
    local stroke = btnFrame:FindFirstChildOfClass("UIStroke")
    -- Activo = morado; inactivo = blanco. El texto permanece negro en ambos estados.
    btnFrame.BackgroundTransparency = 1
    btnFrame.BackgroundColor3 = active and THEME_PURPLE or Color3.fromRGB(255, 255, 255)
    local buttonBackground = btnFrame:FindFirstChild("FloatingButtonBackground")
    if buttonBackground and buttonBackground:IsA("ImageLabel") then
        buttonBackground.ImageColor3 = active and Color3.fromRGB(125, 255, 125) or Color3.fromRGB(255, 255, 255)
    end
    if bg then
        bg.Transparency = NumberSequence.new(1)
        bg.Color = active and ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, THEME_PURPLE),
            ColorSequenceKeypoint.new(0.18, THEME_PURPLE),
            ColorSequenceKeypoint.new(0.82, THEME_PURPLE),
            ColorSequenceKeypoint.new(1.00, THEME_PURPLE),
        }) or ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)),
        })
    end
    if label then
        label.TextColor3 = Color3.fromRGB(170, 255, 170)
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.TextStrokeTransparency = 0.2
    end
    if stroke then
        stroke.Color = THEME_PURPLE
        stroke.Thickness = active and 1.4 or 1.1
        stroke.Transparency = active and 0.25 or 0.45
    end
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then
            uiScale.Scale = floatingButtonScale
        end
    end
end

local function drag(f)
    local dn, ds, sp, di = false, nil, nil, nil
    local endConn = nil
    local function stopDrag()
        dn = false
        di = nil
        if endConn then
            endConn:Disconnect()
            endConn = nil
        end
    end
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dn = true; ds = i.Position; sp = f.Position
            if endConn then endConn:Disconnect() end
            endConn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then stopDrag() end
            end)
        end
    end)
    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if f == main and not uiLocked then
                savedMainMenuPos = {XScale = f.Position.X.Scale, XOffset = f.Position.X.Offset, YScale = f.Position.Y.Scale, YOffset = f.Position.Y.Offset}
                pcall(saveAllSettings)
            end
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
        end
    end)
end

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    local ccAcc = 0
    local speedLabelAccumulator = 0
    steppedConn = RunService.Heartbeat:Connect(function(dt)
        ccAcc = ccAcc + dt
        if ccAcc < 0.15 then return end
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

    movementLoop = RunService.RenderStepped:Connect(function(dt)
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        if not useCarrySystem and not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
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

        speedLabelAccumulator = speedLabelAccumulator + (dt or 0.016)
        if speedLabel and speedLabelAccumulator >= 0.10 then
            speedLabelAccumulator = 0
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
    if pbFrame then pbFrame.Active = not uiLocked end
    if zenxAdaptStealBar.frame then
        zenxAdaptStealBar.frame.Active = not uiLocked
        if uiLocked and zenxAdaptStealBar.stopDrag then
            pcall(zenxAdaptStealBar.stopDrag)
        end
    end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
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
    stopAntiBat()
    if antiFlingEnabled then AntiFlingShieldModule.stop() end
    stopBatCounter()
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if espEnabled then toggleESP(false) end
    if dropActive then stopDropBrainrot() end
    if bodyLockEnabled then stopBodyLock() end
    _blSuppressCount = 0
    _blWasEnabled = false
    if _blRestoreTimer then
        pcall(task.cancel, _blRestoreTimer)
        _blRestoreTimer = nil
    end
    if _bodyLockConn then
        _bodyLockConn:Disconnect()
        _bodyLockConn = nil
    end
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
        configResetVersion = CONFIG_RESET_VERSION,
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED,
        laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        antiRagdollMode = antiRagdollMode,
        antiDieEnabled = antiDieEnabled,
        floatEnabled = FloatModule.running == true,
        antiBat = antiBatEnabled,
        -- Clave antigua conservada para compatibilidad con configuraciones previas.
        antiBatEnabled = antiBatEnabled,
        infiniteJump = jumpEnabled,
        batSkin = currentBatSkin,
        medusaSkin = currentMedusaSkin,
        xrayEnabled = xrayEnabled,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
        laggerToggled = laggerToggled,
        laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        autoSwingEnabled = AUTO_SWING_ENABLED,
        dropMode = dropMode,
        stretchEnabled = stretchEnabled,
        stretchFOV = stretchFOV,
        fovEnabled = fovEnabled,
        fovValue = fovValue,
        uiScale = uiScaleValue,
        animPack = currentAnimPack,
        espEnabled = espEnabled,
        antiLag = antiLagEnabled,
        potatoGraphics = potatoGraphicsEnabled,
        autoBatEnabled = autoBatEnabled,
        autoLeftEnabled = autoLeftEnabled,
        autoRightEnabled = autoRightEnabled,
        autoCarryEnabled = autoCarryEnabled == true,
        autoCarryMode = autoCarryMode,
        unwalk = unwalkEnabled,
        neonWeather = neonWeatherEnabled,
        mobileButtonPositions = savedButtonPositions,
        mainMenuPos = savedMainMenuPos,
        mainMenuOpen = savedMainMenuOpen,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        floatKey = {kb = KB.Float.kb and KB.Float.kb.Name, gp = KB.Float.gp and KB.Float.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        instaResetFloatingPos = instaResetFloatingPos,
        bodyLockEnabled = bodyLockEnabled,
        bodyLockRange = bodyLockRange,
        progressBarPos = savedProgressBarPos,
        autoGrabBarPos = zenxAdaptStealBar.position,
        stealBarScale = stealBarScale,
        lockUI = uiLocked,
        hideButtons = hideButtons,
        backgroundIndex = backgroundIndex,
        floatingButtonScale = floatingButtonScale,
        menuGuiStyle = menuGuiStyle,
        menuGuiWidth = menuGuiWidth,
        outfitIndex = currentOutfitIndex,
        outfitConfigVersion = 3,
        useCarrySystem = useCarrySystem,
        carrySysNormal = CarrySystem.normalSpeed,
        carrySysCarry = CarrySystem.carrySpeed,
        carrySysLagger = CarrySystem.laggerSpeed,
        carrySysLaggerCarry = CarrySystem.laggerCarrySpeed,
    }
    if zenxAdaptStealBar.position then
        config.autoGrabBarPos = {
            XScale = zenxAdaptStealBar.position.X.Scale,
            XOffset = zenxAdaptStealBar.position.X.Offset,
            YScale = zenxAdaptStealBar.position.Y.Scale,
            YOffset = zenxAdaptStealBar.position.Y.Offset
        }
    end
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

-- Guardado automático periódico de estados, posiciones y valores.
do
    task.spawn(function()
        while task.wait(2.5) do
            if not _isLoading and not _isResetting then pcall(saveAllSettings) end
        end
    end)
end

function loadAllSettings()
    if not isfile or not isfile(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
    if not success or not data then return false end
    if data.configResetVersion ~= CONFIG_RESET_VERSION then
        -- Borrar por completo la configuración vieja y arrancar desde cero.
        pcall(function()
            if delfile and isfile(CONFIG_FILE) then delfile(CONFIG_FILE) end
        end)
        return false
    end
    _isLoading = true
    -- Validar y acotar valores antes de usarlos en física/UI.
    local function positiveNumber(value, fallback, minValue, maxValue)
        value = tonumber(value)
        if not value or value ~= value then return fallback end
        return _clamp(value, minValue or 0.1, maxValue or 500)
    end
    NS = positiveNumber(data.normalSpeed, NS, 1, 500)
    CS = positiveNumber(data.carrySpeed, CS, 1, 500)
    LAGGER_SPEED = positiveNumber(data.laggerSpeed1, LAGGER_SPEED, 1, 500)
    LAGGER_CARRY_SPEED = positiveNumber(data.laggerSpeed2, LAGGER_CARRY_SPEED, 1, 500)
    CarrySystem:setNormalSpeed(NS)
    CarrySystem:setCarrySpeed(CS)
    CarrySystem:setLaggerSpeed(LAGGER_SPEED)
    CarrySystem:setLaggerCarrySpeed(LAGGER_CARRY_SPEED)
    CONFIG.STEAL_RANGE = _clamp(_floor(positiveNumber(data.stealRadius, CONFIG.STEAL_RANGE, 5, 300) + 0.5), 5, 300)
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if data.lockUI ~= nil then
        uiLocked = data.lockUI == true
    end
    hideButtons = data.hideButtons == true
    applyHideButtonsVisibility()
    if data.antiRagdollMode then
        antiRagdollMode = data.antiRagdollMode
    else
        antiRagdollMode = data.antiRagdoll and "v2" or "off"
    end
    antiDieEnabled = data.antiDieEnabled == true
    antiBatEnabled = data.antiBat == true or data.antiBatEnabled == true
    jumpEnabled = data.infiniteJump == true
    local savedBatSkin = data.batSkin == "Minecraft" and "Off" or data.batSkin
    currentBatSkin = getBatSkinIndex(savedBatSkin) > 1 and savedBatSkin or "Off"
    batSkinIndex = getBatSkinIndex(currentBatSkin)
    if batSkinSelectorLabel then batSkinSelectorLabel.Text = currentBatSkin end
    currentMedusaSkin = getMedusaSkinIndex(data.medusaSkin) > 1 and data.medusaSkin or "Off"
    medusaSkinIndex = getMedusaSkinIndex(currentMedusaSkin)
    if medusaSkinSelectorLabel then medusaSkinSelectorLabel.Text = currentMedusaSkin end
    applyBatSkinToCharacter()
    customSoundsEnabled = false
    setCustomSoundsEnabled(false)
    antiFlingEnabled = data.antiFlingEnabled or false
    CONFIG.AUTO_STEAL_ENABLED = data.autoSteal or false
    medusaCounterEnabled = data.medusaCounter or false
    batCounterEnabled = data.batCounter or false
    unwalkEnabled = data.unwalk == true
    autoBatEnabled = data.autoBatEnabled == true
    autoLeftEnabled = data.autoLeftEnabled == true
    autoRightEnabled = data.autoRightEnabled == true
    autoCarryEnabled = data.autoCarryEnabled == true
    if data.autoCarryMode == "Soft Steal" then autoCarryMode = "Soft Steal" else autoCarryMode = "On Pick Up" end
    antiLagEnabled = data.antiLag == true
    potatoGraphicsEnabled = data.potatoGraphics == true
    if potatoGraphicsEnabled then enablePotatoGraphics() else disablePotatoGraphics() end
    laggerToggled = data.laggerToggled or false
    speedMode = data.carryMode or false
    laggerCarryToggled = data.laggerCarryToggled or false

    uiScaleValue = _clamp(tonumber(data.uiScale) or 78, 50, 150)
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = uiScaleValue / 100 end
    espEnabled = data.espEnabled or false
    if espEnabled then toggleESP(true) else toggleESP(false) end
    xrayEnabled = data.xrayEnabled == true
    setXRayEnabled(xrayEnabled)
    if setXRayVisual then setXRayVisual(xrayEnabled) end
    neonWeatherEnabled = data.neonWeather or false
    if neonWeatherEnabled then
        task.defer(function() toggleNeonWeather(true) end)
    else
        toggleNeonWeather(false)
    end
    if data.animPack and ANIM_PACKS[data.animPack] then
        startAnimPack(data.animPack)
    else
        currentAnimPack = "Off"
        stopAnimPack()
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
    lk(KB.Float, data.floatKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.InstaReset, data.instaResetKey)
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        if ref.btn and entry then
            ref.btn.Text = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        end
    end
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.mainMenuPos then
        savedMainMenuPos = data.mainMenuPos
        if main then
            main.Position = UDim2.new(savedMainMenuPos.XScale or 0.5, savedMainMenuPos.XOffset or -((menuGuiWidth or 320) / 2), savedMainMenuPos.YScale or 0.5, savedMainMenuPos.YOffset or -210)
        end
    end
    if data.mainMenuOpen ~= nil then savedMainMenuOpen = data.mainMenuOpen == true end
    if data.instaResetFloatingPos then instaResetFloatingPos = data.instaResetFloatingPos end
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    if data.autoGrabBarPos then
        savedProgressBarPos = data.autoGrabBarPos
        zenxAdaptStealBar.position = UDim2.new(
            data.autoGrabBarPos.XScale or 0.5,
            data.autoGrabBarPos.XOffset or -140,
            data.autoGrabBarPos.YScale or 1,
            data.autoGrabBarPos.YOffset or -62
        )
    end
    if data.stealBarScale ~= nil then
        local loadedStealBarScale = tonumber(data.stealBarScale)
        if loadedStealBarScale then setZenxAdaptStealBarScale(loadedStealBarScale, false) end
    end
    if data.bodyLockEnabled ~= nil then
        bodyLockEnabled = data.bodyLockEnabled
        if bodyLockEnabled then
            task.defer(function()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                startBodyLock()
            end)
        end
    end
    if data.bodyLockRange then
        bodyLockRange = _clamp(_floor(positiveNumber(data.bodyLockRange, bodyLockRange, 5, 200) + 0.5), 5, 200)
        if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    end
    dropMode = (tonumber(data.dropMode) == 2) and 2 or 1
    stretchEnabled = data.stretchEnabled == true
    fovValue = _clamp(_floor(positiveNumber(data.fovValue, 105, 20, 120) + 0.5), 20, 120)
    fovEnabled = data.fovEnabled or false
    if fovSliderSet then fovSliderSet(fovValue) end
    if fovEnabled then enableCustomFov() end
    if setFovVisual then setFovVisual(fovEnabled) end
    stretchFOV = _clamp(_floor(positiveNumber(data.stretchFOV, 120, 20, 180) + 0.5), 20, 180)
    BAT_AIMBOT_SPEED = _clamp(_floor(positiveNumber(data.batAimbotSpeed, BAT_AIMBOT_SPEED, 1, 200) + 0.5), 1, 200)
    AUTO_SWING_ENABLED = data.autoSwingEnabled ~= false
    if autoSwingSetVisual then autoSwingSetVisual(AUTO_SWING_ENABLED) end
    backgroundIndex = _clamp(tonumber(data.backgroundIndex) or 1, 1, #backgroundImages)
    floatingButtonScale = _clamp(tonumber(data.floatingButtonScale) or 1, 0.5, 2)
    applyMenuGuiStyle(data.menuGuiStyle or menuGuiStyle)
    if data.outfitIndex then
        if data.outfitConfigVersion == 3 then
            currentOutfitIndex = data.outfitIndex
        elseif data.outfitConfigVersion == 2 then
            -- Outfit V3 fue eliminado: desplazar los outfits que estaban después.
            local oldIndex = tonumber(data.outfitIndex) or 1
            currentOutfitIndex = oldIndex == 4 and 1 or (oldIndex > 4 and oldIndex - 1 or oldIndex)
        else
            -- Migración de configuraciones aún más antiguas.
            currentOutfitIndex = data.outfitIndex == 4 and 1 or (data.outfitIndex + 1)
        end
        if currentOutfitIndex < 1 or currentOutfitIndex > #OUTFITS then currentOutfitIndex = 1 end
        task.defer(function()
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel then
                outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
            end
        end)
    end

    useCarrySystem = data.useCarrySystem == true
    CarrySystem.normalSpeed = data.carrySysNormal or NS
    CarrySystem.carrySpeed = data.carrySysCarry or CS
    CarrySystem.laggerSpeed = data.carrySysLagger or LAGGER_SPEED
    CarrySystem.laggerCarrySpeed = data.carrySysLaggerCarry or LAGGER_CARRY_SPEED
    if useCarrySystem then
        CarrySystem:start()
        CarrySystem.speedToggled = speedMode
        if laggerCarryToggled then
            CarrySystem:setLaggerMode(2)
        elseif laggerToggled then
            CarrySystem:setLaggerMode(1)
        else
            CarrySystem:setLaggerMode(0)
        end
    else
        CarrySystem:stop()
    end

    FloatModule.setEnabled(data.floatEnabled == true)
    if setFloatVisual then setFloatVisual(FloatModule.running) end
    if mobSetFloat then mobSetFloat(FloatModule.running) end
    FloatModule.syncAntiDieForMovement()

    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    refreshSpeedModeLabel()
    _lastSavedJSON = HS:JSONEncode(buildConfigTable())
    _isLoading = false
    task.defer(function() pcall(saveAllSettings) end)
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
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if carrySysNormalBox then carrySysNormalBox.Text = tostring(CarrySystem.normalSpeed) end
    if carrySysCarryBox then carrySysCarryBox.Text = tostring(CarrySystem.carrySpeed) end
    if carrySysLaggerBox then carrySysLaggerBox.Text = tostring(CarrySystem.laggerSpeed) end
    if carrySysLaggerCarryBox then carrySysLaggerCarryBox.Text = tostring(CarrySystem.laggerCarrySpeed) end
    if carrySystemToggleSetter then carrySystemToggleSetter(useCarrySystem) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(autoSwingSetVisual, false)
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
    safeSet(setMedusaVisual, false)
    safeSet(customSoundsSetVisual, false)
    safeSet(setXRayVisual, false)
    safeSet(setJumpVisual, false)
    safeSet(setFloatVisual, false)
    if mobSetFloat then pcall(mobSetFloat, false) end
    safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false)
    safeSet(setPotatoGraphicsVisual, false)
    safeSet(setLockUIVisual, false)
    safeSet(setHideButtonsVisual, false)
    safeSet(setInstaGrab, false)
    safeSet(setESPVIsual, false)
    safeSet(bodyLockSetVisual, false)
    safeSet(setNeonWeatherVisual, false)
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
    if antiDieEnabled then
        AntiDieModule.stop()
        antiDieEnabled = false
    end
    if antiFlingEnabled then
        AntiFlingShieldModule.stop()
        antiFlingEnabled = false
    end
    jumpEnabled = false
    InfiniteJump.stop()
    currentBatSkin = "Off"
    batSkinIndex = 1
    if batSkinSelectorLabel then batSkinSelectorLabel.Text = "Off" end
    currentMedusaSkin = "Off"
    medusaSkinIndex = 1
    if medusaSkinSelectorLabel then medusaSkinSelectorLabel.Text = "Off" end
    applyBatSkinToCharacter()
    setCustomSoundsEnabled(true)
    setXRayEnabled(false)
    hideButtons = false
    applyHideButtonsVisibility()
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    currentColorTheme = "Morado"
    selectedColor = THEME_PURPLE
    updateAllUIThemeColors(selectedColor)
    if miniBtn then miniBtn.TextColor3 = Color3.fromRGB(0, 0, 0) end
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
                        paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
                    end
                end
            end
        end
    end
    saveAllSettings()
end

function resetFloatingPositions()
    -- Estas dimensiones deben existir tambien fuera de createMobilePanel.
    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local COLUMNS, ROWS = 2, 5
    local PANEL_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1)
    local PANEL_H = BTN_H * ROWS + (GAP + 10) * (ROWS - 1)

    -- Limpiar siempre las posiciones guardadas, incluso si el panel aún no está creado.
    savedButtonPositions = {}
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        container.Position = UDim2.new(1, -(PANEL_W + 12), 0.5, -PANEL_H / 2)
        local btnContainer = container:FindFirstChild("ButtonsContainer")
        if btnContainer then
            for _, btn in ipairs(btnContainer:GetChildren()) do
                if btn:IsA("TextButton") and btn.Name then
                    local defX, defY = getDefaultButtonPosition(btn.Name)
                    btn.Position = UDim2.new(0, defX, 0, defY)
                    btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
                end
            end
        end
    end
    -- Insta Reset está dentro de la cuadrícula, así que se restablece con savedButtonPositions.
    instaResetFloatingPos = nil
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        instaResetFloatingButton.Frame.Position = UDim2.new(0.5, (menuGuiWidth or 320) / 2 + 12, 0.5, -42)
    end
    -- Volver al tamaño normal de todos los botones flotantes.
    floatingButtonScale = 1
    for _, floatingScale in ipairs(_floatingUIScales) do
        if floatingScale and floatingScale.Parent then floatingScale.Scale = 1 end
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -140, 1, -94)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
    savedMainMenuPos = nil
    if main then
        local menuW = menuGuiWidth or 320
        local menuH = 420
        main.Position = UDim2.new(0.5, -menuW / 2, 0.5, -menuH / 2)
        if miniBtn then miniBtn.Position = main.Position end
    end
    pcall(saveAllSettings)
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAllBackgroundTasks()
        FloatModule.setEnabled(false)
        stopAutoSteal()
        stopBatCounter()
        stopMedusaCounter()
        if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if antiDieEnabled then AntiDieModule.stop() end
        if antiFlingEnabled then AntiFlingShieldModule.stop() end
        stopUnwalk()
        disableAutoBat()
        stopBodyLock()
        if espEnabled then toggleESP(false) end
        if stretchEnabled then disableStretch() end
        if antiLagEnabled then disableAntiLag() end
        if dropActive then stopDropBrainrot() end
        toggleNeonWeather(false)
        if antiDieEnabled then
            antiDieEnabled = false
            FloatModule.syncAntiDieForMovement()
        end
        if antiFlingEnabled then
            AntiFlingShieldModule.stop()
            antiFlingEnabled = false
        end
        NS = 60
        CS = 29
        LAGGER_SPEED = 15
        LAGGER_CARRY_SPEED = 24.5
        CONFIG.STEAL_RANGE = 61
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = false
        autoCarryEnabled = false
        autoCarryMode = "On Pick Up"
        if _G.__ZenxAutoCarryRestore then pcall(_G.__ZenxAutoCarryRestore) end
        if _G.__ZenxAutoCarryRefresh then pcall(_G.__ZenxAutoCarryRefresh) end
        antiRagdollMode = "off"
        antiDieEnabled = false
        antiBatEnabled = false
        antiFlingEnabled = false
        jumpEnabled = false
        currentBatSkin = "Off"
        batSkinIndex = 1
        currentMedusaSkin = "Off"
        medusaSkinIndex = 1
        hideButtons = false
        medusaCounterEnabled = false
        batCounterEnabled = false
        autoBatEnabled = false
        autoLeftEnabled = false
        autoRightEnabled = false
        unwalkEnabled = false
        antiLagEnabled = false
        potatoGraphicsEnabled = false
        disablePotatoGraphics()
        uiLocked = true
        CONFIG.AUTO_STEAL_ENABLED = false
        BAT_AIMBOT_SPEED = 58
        dropMode = 1
        stretchEnabled = false
        stretchFOV = 120
        fovValue = 105
        disableCustomFov()
        if fovSliderSet then fovSliderSet(105) end
        if setFovVisual then setFovVisual(false) end
        uiScaleValue = 100
        if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
        if pbScale then pbScale.Scale = uiScaleValue / 100 end
        espEnabled = false
        bodyLockEnabled = false
        bodyLockRange = 20
        backgroundIndex = 1
        floatingButtonScale = 1
        menuGuiStyle = "GUI 1"
        applyMenuGuiStyle(menuGuiStyle)
        currentAnimPack = "Off"
        stopAnimPack()
        currentOutfitIndex = 1
        currentColorTheme = "Morado"
        selectedColor = THEME_PURPLE
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
        CarrySystem.softStealLatched = false
        if isfile and isfile(CONFIG_FILE) then
            pcall(delfile, CONFIG_FILE)
        end
        resetFloatingPositions()
        savedMainMenuPos = nil
        if main then
            main.Position = UDim2.new(0.5, -((menuGuiWidth or 320) / 2), 0.5, -210)
            if miniBtn then miniBtn.Position = main.Position end
        end
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
    -- La barra es solo visual; Auto Steal continúa funcionando sin ella.
    if pbFrame then pbFrame.Visible = false end
end

function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local color = getThemeColor()
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200,200,200)),
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
        TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7, InstaReset = 8, Float = 9
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


-- ============================================================
-- Música de Domina Hub
-- ============================================================
local DOMINA_MUSIC_LIBRARY={
    {artist="LAJA",songs={
        {name="LAJA - SETEADORA",url="https://file.garden/anQAxCXXiQfEPX90/LAJA-SETEADORA(Video%20Oficial)%20Shot.Bycheckthefootage%20%23spanishdrill%20-%20LAJA.mp3"},
        {name="LAJA - GRRRMOSTWANTED",url="https://file.garden/anQAxCXXiQfEPX90/LAJA-GRRRMOSTWANTED(Video%20Oficial)Shot.By@checkthefootage%20%23spanishdrill.mp3"},
        {name="LAJA - AVENTADOR",url="https://file.garden/anQAxCXXiQfEPX90/LAJA-AVENTADOR(Video%20Oficial)Shot.By@checkthefootage%23spanishdrill.mp3"},
        {name="LAJA X POPERULIN - SHOW ME",url="https://file.garden/anQAxCXXiQfEPX90/LAJA%20X%20POPERULIN-SHOW%20ME(Video%20Oficial)Shot.By%20@checkthefootage%20%23spanishdrill.mp3"},
        {name="LAJA X POPERULIN - LOV SHOOTOUT",url="https://file.garden/anQAxCXXiQfEPX90/LAJA%20X%20POPERULIN%20-%20LOV%20SHOOTOUT%20(Video%20Oficial)%20Shot.By%20@checkthefootage%20%23spanishdrill.mp3"},
        {name="LAJA x HUAN62 - OTRA AMIGA",url="https://file.garden/anQAxCXXiQfEPX90/LAJA%20x%20HUAN62%20-%20OTRA%20AMIGA%20(Video%20Oficial)%20Shot.by@checkthefootage%20%23spanishdrill.mp3"},
        {name="LAJA x HADES66 X YAMA - CUANTO GRAMO",url="https://file.garden/anQAxCXXiQfEPX90/LAJA%20x%20HADES66%20X%20YAMA%20-%20CUANTO%20GRAMO%20(VIDEO%20OFICIAL).mp3"},
        {name="LAJA - STAY ALIVE",url="https://file.garden/anQAxCXXiQfEPX90/LAJA%20-%20STAY%20ALIVE%20(Video%20Oficial)%20Shot.by%20@checkthefootage%20%23spanishdrill.mp3"},
        {name="LAJA - NADIE TA FRIO",url="https://file.garden/anQAxCXXiQfEPX90/LAJA%20-%20NADIE%20TA%20FRIO%20(Video%20Oficial)%20Shot.By@checkthefootage%20%23spanishdrill.mp3"},
        {name="LAJA - MALDITO ANIMAL",url="https://file.garden/anQAxCXXiQfEPX90/LAJA%20-%20MALDITO%20ANIMAL%20(Video%20Oficial)%20Shot.by%20@checkthefootage%20%23spanishdrill.mp3"},
        {name="LAJA - 7ELEVEN",url="https://file.garden/anQAxCXXiQfEPX90/LAJA%20-%207ELEVEN%20(Video%20Oficial)%20Shot.by%20@checkthefootage%20%23spanishdrill.mp3"},
    }},
    {artist="El Americano 4KT",songs={
        {name="YO NO TENIA NA",url="https://file.garden/anQAxCXXiQfEPX90/YO%20NO%20TENIA%20NA%20%20-%20El%20Americano%204KT%20(Video%20Oficial).mp3"},
        {name="MAMAXITA",url="https://file.garden/anQAxCXXiQfEPX90/MAMAXITA%20%20-%20EL%20AMERICANO%204KT%20(Video%20Oficial).mp3"},
        {name="The Flow's Son Black X Kobby FREE",url="https://file.garden/anQAxCXXiQfEPX90/El%20Americano%204KT%20X%20Kobby%20FREE%20-%20The%20Flow's%20Son%20Black.mp3"},
        {name="The Flow's Son Black",url="https://file.garden/anQAxCXXiQfEPX90/El%20Americano%204KT%20-%20The%20Flow's%20Son%20Black%20(LetraLyrics)%20Ronaldo%20es%20cabra%2C%20Messi%20es%20winner%20cap.mp3"},
        {name="COMO ASI",url="https://file.garden/anQAxCXXiQfEPX90/EL%20AMERICANO%204KT%20-%20COMO%20ASI%20(video%20oficial).mp3"},
    }},
    {artist="LIL NAAY",songs={
        {name="BABY SUPREME",url="https://file.garden/anQAxCXXiQfEPX90/LIL%20NAAY%20-%20BABY%20SUPREME.mp3"},
        {name="PRENDE",url="https://file.garden/anQAxCXXiQfEPX90/LIL%20NAAY%20-%20PRENDE%20VIDEO%20OFFICIAL.mp3"},
        {name="PERRA",url="https://file.garden/anQAxCXXiQfEPX90/LIL%20NAAY%20-%20PERRA%20(%20VIDEO%20OFFICIAL%20).mp3"},
        {name="PERFECT",url="https://file.garden/anQAxCXXiQfEPX90/LIL%20NAAY%20-%20PERFECT.mp3"},
    }},
    {artist="HUAN 62",songs={{name="CHIQUITA",url="https://file.garden/anQAxCXXiQfEPX90/CHIQUITA%20-%20HUAN%2062%20-%20(V%C3%ADdeo%20Oficial).mp3"}}},
    {artist="XXXTENTACION",songs={{name="Hope",url="https://file.garden/anQAxCXXiQfEPX90/XXXTENTACION%20-%20Hope%20%20Lyrics.mp3"}}},
    {artist="Artista Desconocido",songs={{name="Desconocido - Beretta",url="https://file.garden/anQAxCXXiQfEPX90/Beretta%20-%20video%20oficial.mp3"}}},
}

local dominaMusicSound = nil
local dominaActiveSong = nil
local dominaMusicToken = 0

local function dominaAudioFileExists(path)
    if type(isfile) ~= "function" then return false end
    local ok, result = pcall(isfile, path)
    return ok and result == true
end

local function dominaValidAudio(data)
    if type(data) ~= "string" or #data < 2048 then return false end
    local header = data:sub(1, 256):lower()
    return not (header:find("<html", 1, true) or header:find("<!doctype", 1, true)
        or header:find("access denied", 1, true) or header:find("not found", 1, true)
        or header:find("error", 1, true))
end

local function dominaDownloadAudio(url, path)
    if type(writefile) ~= "function" then return false, "writefile no está disponible" end
    local data, lastError
    local requestFunction = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
    if type(requestFunction) == "function" then
        local ok, response = pcall(requestFunction, {
            Url = url,
            Method = "GET",
            Headers = { ["User-Agent"] = "Mozilla/5.0", ["Accept"] = "audio/mpeg,audio/*;q=0.9,*/*;q=0.8" }
        })
        if ok and type(response) == "table" then
            local code = tonumber(response.StatusCode or response.Status or response.status_code) or 0
            local body = response.Body or response.body
            if (code == 0 or (code >= 200 and code < 300)) and dominaValidAudio(body) then
                data = body
            else
                lastError = "respuesta HTTP inválida (" .. tostring(code) .. ")"
            end
        elseif not ok then
            lastError = tostring(response)
        end
    end
    if not data then
        local ok, result = pcall(function() return game:HttpGet(url, true) end)
        if ok and dominaValidAudio(result) then data = result
        elseif not ok then lastError = tostring(result) end
    end
    if not data then return false, lastError or "no se pudo descargar el audio" end
    local ok, err = pcall(writefile, path, data)
    if not ok then return false, tostring(err) end
    return true
end

local function stopDominaMusic()
    dominaMusicToken = dominaMusicToken + 1
    if dominaMusicSound then
        pcall(function() dominaMusicSound:Stop(); dominaMusicSound:Destroy() end)
        dominaMusicSound = nil
    end
    dominaActiveSong = nil
end

local function playDominaMusic(song, button)
    if dominaActiveSong == song then
        stopDominaMusic()
        if button then button.Text = "PLAY" end
        return
    end
    stopDominaMusic()
    local myToken = dominaMusicToken
    dominaActiveSong = song
    if button then button.Text = "..." end
    task.spawn(function()
        local fileName = "ZenxDominaMusic_" .. tostring(song.name):gsub("[^%w]+", "_") .. ".mp3"
        local assetFunction = getcustomasset or getsynasset
        if type(assetFunction) ~= "function" then
            warn("[DOMINA MUSIC] getcustomasset/getsynasset no está disponible")
            if dominaActiveSong == song then dominaActiveSong = nil; if button then button.Text = "PLAY" end end
            return
        end
        if not dominaAudioFileExists(fileName) then
            local downloaded, err = dominaDownloadAudio(song.url, fileName)
            if not downloaded then
                warn("[DOMINA MUSIC] " .. song.name .. ": " .. tostring(err))
                if dominaActiveSong == song then dominaActiveSong = nil; if button then button.Text = "PLAY" end end
                return
            end
        end
        if myToken ~= dominaMusicToken or dominaActiveSong ~= song then return end
        local ok, assetId = pcall(assetFunction, fileName)
        if not ok or type(assetId) ~= "string" or assetId == "" then
            warn("[DOMINA MUSIC] no se pudo crear el asset local para " .. song.name)
            if dominaActiveSong == song then dominaActiveSong = nil; if button then button.Text = "PLAY" end end
            return
        end
        local sound = Instance.new("Sound")
        sound.Name = "ZenxDominaMusic"
        sound.SoundId = assetId
        sound.Volume = 0.85
        sound.Looped = true
        sound.Parent = game:GetService("SoundService")
        dominaMusicSound = sound
        local deadline = os.clock() + 8
        while dominaMusicSound == sound and sound.Parent and not sound.IsLoaded and os.clock() < deadline do task.wait(0.1) end
        if dominaMusicSound == sound and sound.Parent then
            pcall(function() sound:Play() end)
            if button then button.Text = "STOP" end
        end
    end)
end

function buildGui()
    local SILVER = THEME_PURPLE
    local SILVER_DARK = Color3.fromRGB(205, 82, 0)
    local SILVER_LIGHT = THEME_PURPLE
    local BG = Color3.fromRGB(10, 5, 10)
    local BG2 = Color3.fromRGB(24, 8, 20)
    local ROW_BG = Color3.fromRGB(30, 10, 24)
    local ROW_BORDER = Color3.fromRGB(145, 145, 150)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local GRAY = Color3.fromRGB(220, 130, 35)
    local INP = Color3.fromRGB(16, 7, 15)
    local OFF = Color3.fromRGB(20, 8, 18)
    local TAB_ACTIVE = SILVER
    local TAB_INACT = SILVER_DARK
    local SECT_LBL = SILVER_LIGHT
    local HOV = Color3.fromRGB(58, 18, 44)
    local DOT_ON = Color3.fromRGB(0,0,0)
    local ON_COLOR = THEME_PURPLE
    local STROKE_COLOR = Color3.fromRGB(124, 46, 40)
    -- Panel compacto: evita que la interfaz ocupe demasiado ancho/pantalla.
    local GUI_W, GUI_H = menuGuiWidth or 320, 420

    for _, oldName in ipairs({"BloodHounds", "zenx hub", "FRESH", "Zenx"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(oldName)
        if old then old:Destroy() end
    end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        for _, oldName in ipairs({"BloodHounds", "zenx hub", "FRESH", "Zenx"}) do
            local old = pg:FindFirstChild(oldName)
            if old then old:Destroy() end
        end
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "4KTDUELS"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = savedMainMenuPos
        and UDim2.new(savedMainMenuPos.XScale or 0.5, savedMainMenuPos.XOffset or -GUI_W / 2, savedMainMenuPos.YScale or 0.5, savedMainMenuPos.YOffset or -GUI_H / 2)
        or UDim2.new(0.5, -GUI_W / 2, 0.5, -GUI_H / 2)
    main.Visible = false
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
    bgImage.ImageTransparency = 0
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    bgImage.ClipsDescendants = true
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 18)

    local bgShade = Instance.new("Frame", main)
    bgShade.Name = "FireShade"
    bgShade.Size = UDim2.new(1, 0, 1, 0)
    bgShade.Position = UDim2.new(0, 0, 0, 0)
    bgShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgShade.BackgroundTransparency = 0.62
    bgShade.BorderSizePixel = 0
    bgShade.ZIndex = 1
    Instance.new("UICorner", bgShade).CornerRadius = UDim.new(0, 18)

    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    local titleFrame = Instance.new("Frame", main)
    titleFrame.Name = "TitleFrame"
    titleFrame.AnchorPoint = Vector2.new(0.5, 0)
    titleFrame.Size = UDim2.new(1, -16, 0, 90)
    titleFrame.Position = UDim2.new(0.5, 0, 0, 0)
    titleFrame.BackgroundTransparency = 1
    titleFrame.ZIndex = 20

    local headerImage = Instance.new("ImageLabel", titleFrame)
    menuHeaderImage = headerImage
    headerImage.Name = "ZenxHeaderImage"
    headerImage.Size = UDim2.new(1, 0, 1, 0)
    headerImage.Position = UDim2.new(0, 0, 0, 0)
    headerImage.BackgroundTransparency = 1
    headerImage.Visible = true
    -- ID de la imagen del encabezado Zenx.
    local ZENX_HEADER_ASSET_ID = "129421984812930"
    menuHeaderImageAvailable = true
    headerImage.Image = "rbxassetid://" .. ZENX_HEADER_ASSET_ID
    headerImage.ImageTransparency = 0
    headerImage.ScaleType = Enum.ScaleType.Crop
    headerImage.ZIndex = 20
    Instance.new("UICorner", headerImage).CornerRadius = UDim.new(0, 8)

    -- Respaldo textual oculto; el encabezado se muestra únicamente con la imagen.
    menuV1Brand = Instance.new("TextLabel", titleFrame)
    menuV1Brand.Name = "ZenxV1BrandFallback"
    menuV1Brand.Size = UDim2.new(1, -54, 1, 0)
    menuV1Brand.Position = UDim2.new(0, 10, 0, 0)
    menuV1Brand.BackgroundTransparency = 1
    menuV1Brand.Text = ""
    menuV1Brand.TextColor3 = THEME_PURPLE
    menuV1Brand.Font = UI_FONT_HEAVY
    menuV1Brand.TextSize = 28
    menuV1Brand.TextXAlignment = Enum.TextXAlignment.Left
    menuV1Brand.TextYAlignment = Enum.TextYAlignment.Center
    menuV1Brand.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    menuV1Brand.TextStrokeTransparency = 0.12
    menuV1Brand.Visible = false
    menuV1Brand.ZIndex = 22

    menuV2Brand = Instance.new("TextLabel", titleFrame)
    menuV2Brand.Name = "ZenxV2Brand"
    menuV2Brand.Size = UDim2.new(1, -12, 1, 0)
    menuV2Brand.Position = UDim2.new(0, 6, 0, 0)
    menuV2Brand.BackgroundTransparency = 1
    -- El encabezado usa solo la imagen, sin título superpuesto.
    menuV2Brand.Text = ""
    menuV2Brand.TextColor3 = THEME_PURPLE
    menuV2Brand.Font = UI_FONT_HEAVY
    menuV2Brand.TextSize = 23
    menuV2Brand.TextXAlignment = Enum.TextXAlignment.Center
    menuV2Brand.TextYAlignment = Enum.TextYAlignment.Center
    menuV2Brand.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    menuV2Brand.TextStrokeTransparency = 0.12
    menuV2Brand.Visible = false
    menuV2Brand.ZIndex = 22

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "−"
    closeBtn.TextColor3 = WHITE
    closeBtn.Font = UI_FONT_BOLD
    closeBtn.TextSize = 26
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = getThemeColor()}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = Color3.fromRGB(30,30,35)}):Play()
    end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Name = "ZenxMiniButton"
    miniBtn.Size = UDim2.new(0, 96, 0, 32)
    miniBtn.Position = UDim2.new(0, 16, 0, 40)
    miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.BackgroundTransparency = 0.12
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = ""
    miniBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.Font = UI_FONT_HEAVY
    miniBtn.TextSize = 12
    miniBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.TextStrokeTransparency = 0.15
    miniBtn.TextWrapped = true
    miniBtn.AutoButtonColor = false
    miniBtn.ZIndex = 20
    miniBtn.Visible = true
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 4)
    local miniHeaderImage = Instance.new("ImageLabel", miniBtn)
    miniHeaderImage.Name = "MiniHeaderImage"
    miniHeaderImage.Size = UDim2.new(1, 0, 1, 0)
    miniHeaderImage.Position = UDim2.new(0, 0, 0, 0)
    miniHeaderImage.BackgroundTransparency = 1
    miniHeaderImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
    miniHeaderImage.ImageTransparency = 0.18
    miniHeaderImage.ScaleType = Enum.ScaleType.Crop
    miniHeaderImage.ZIndex = 21
    miniHeaderImage.Visible = true
    miniHeaderImage.Active = false
    Instance.new("UICorner", miniHeaderImage).CornerRadius = UDim.new(0, 3)
    local miniBrand = Instance.new("TextLabel", miniBtn)
    miniBrand.Name = "MiniBrand"
    miniBrand.Size = UDim2.new(1, -8, 1, 0)
    miniBrand.Position = UDim2.new(0, 4, 0, 0)
    miniBrand.BackgroundTransparency = 1
    miniBrand.Text = "4KT DUEL"
    miniBrand.TextColor3 = Color3.fromRGB(255, 255, 255)
    miniBrand.Font = UI_FONT_BOLD
    miniBrand.TextSize = 18
    miniBrand.TextXAlignment = Enum.TextXAlignment.Center
    miniBrand.TextYAlignment = Enum.TextYAlignment.Center
    miniBrand.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    miniBrand.TextStrokeTransparency = 0.1
    miniBrand.ZIndex = 22
    miniBrand.Active = false
    local miniStroke = Instance.new("UIStroke", miniBtn)
    miniStroke.Color = selectedColor
    miniStroke.Thickness = 1.2
    miniStroke.Transparency = 0.15

    local slideTween = nil
    local mainOriginalPos = main.Position
    -- El botón de reapertura empieza en la misma posición que el menú.
    miniBtn.Position = mainOriginalPos

    showGui = function()
        if slideTween then slideTween:Cancel() end
        if not main then return end
        savedMainMenuOpen = true
        pcall(saveAllSettings)
        main.Visible = true
        miniBtn.Visible = false
        local targetPos = savedMainMenuPos
            and UDim2.new(savedMainMenuPos.XScale or 0.5, savedMainMenuPos.XOffset or -GUI_W / 2, savedMainMenuPos.YScale or 0.5, savedMainMenuPos.YOffset or -GUI_H / 2)
            or miniBtn.Position
        main.Position = UDim2.new(targetPos.X.Scale, targetPos.X.Offset - (menuGuiWidth or GUI_W) - 20, targetPos.Y.Scale, targetPos.Y.Offset)
        slideTween = TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
        slideTween:Play()
        slideTween.Completed:Connect(function() slideTween = nil end)
    end

    hideGui = function()
        if slideTween then slideTween:Cancel() end
        if not main or not main.Visible then return end
        savedMainMenuOpen = false
        savedMainMenuPos = {
            XScale = main.Position.X.Scale,
            XOffset = main.Position.X.Offset,
            YScale = main.Position.Y.Scale,
            YOffset = main.Position.Y.Offset,
        }
        -- El botón para volver a abrir queda junto al menú donde fue movido.
        miniBtn.Position = main.Position
        pcall(saveAllSettings)
        local targetPos = UDim2.new(main.Position.X.Scale, main.Position.X.Offset - (menuGuiWidth or GUI_W) - 20, main.Position.Y.Scale, main.Position.Y.Offset)
        slideTween = TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
        slideTween:Play()
        slideTween.Completed:Connect(function()
            main.Visible = false
            -- El botón minimizado conserva la misma imagen del menú y de los botones flotantes.
            if miniHeaderImage then
                miniHeaderImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
                miniHeaderImage.Visible = true
            end
            miniBtn.Visible = true
            slideTween = nil
        end)
    end

    closeBtn.MouseButton1Click:Connect(hideGui)

    -- El botón de reapertura se puede mover cuando el menú está cerrado.
    -- Con Lock activo queda fijo, pero todavía permite abrir el menú.
    local miniDragging = false
    local miniMoved = false
    local miniDragStart = nil
    local miniStartPos = nil
    local miniDragInput = nil
    local miniSuppressClick = false

    miniBtn.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if uiLocked then return end
        miniDragging = true
        miniMoved = false
        miniDragStart = input.Position
        miniStartPos = miniBtn.Position
        miniDragInput = input
    end)

    miniBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            miniDragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not miniDragging or not miniDragStart or not miniStartPos then return end
        if input.UserInputType ~= Enum.UserInputType.Touch
            and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local delta = input.Position - miniDragStart
        if delta.Magnitude > 3 then
            miniMoved = true
            miniSuppressClick = true
        end
        if miniMoved and not uiLocked then
            miniBtn.Position = UDim2.new(
                miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X,
                miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if not miniDragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if miniMoved and not uiLocked then
            -- Guardar inmediatamente la nueva posición del botón de apertura.
            savedMainMenuPos = {
                XScale = miniBtn.Position.X.Scale,
                XOffset = miniBtn.Position.X.Offset,
                YScale = miniBtn.Position.Y.Scale,
                YOffset = miniBtn.Position.Y.Offset,
            }
            pcall(saveAllSettings)
        end
        miniDragging = false
        miniDragInput = nil
        miniDragStart = nil
        miniStartPos = nil
        if miniMoved then
            task.delay(0.15, function()
                miniSuppressClick = false
            end)
        end
        miniMoved = false
    end)

    miniBtn.MouseButton1Click:Connect(function()
        if miniSuppressClick then
            miniSuppressClick = false
            return
        end
        showGui()
    end)

    -- Barra superior de apartados, siguiendo el estilo de Updateyout.
    local tabBar = Instance.new("Frame", main)
    tabBar.Name = "TopTabBar"
    tabBar.Size = UDim2.new(1, -8, 0, 32)
    tabBar.Position = UDim2.new(0, 4, 1, -36)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 10
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 2)

    local tabContent = Instance.new("Frame", main)
    tabContent.Name = "PanelContent"
    tabContent.Size = UDim2.new(1, 0, 1, -130)
    tabContent.Position = UDim2.new(0, 0, 0, 90)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    -- Orden de pestañas: Movement, Combat, Keybinds, Visual y Music.
    local tabs = {"Speed", "Combat", "Keybinds", "Main", "Music"}
    local tabLabels = {Speed="MOVEMENT", Combat="COMBAT", Keybinds="KEYBINDS", Main="VISUAL", Music="MUSIC"}
    tabButtons = {}
    local contentPages = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Name = name .. "Tab"
        btn.LayoutOrder = i
        btn.Size = UDim2.new(1 / #tabs, -2, 1, -6)
        btn.BackgroundColor3 = Color3.fromRGB(26, 8, 22)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = tabLabels[name]
        btn.TextColor3 = THEME_PURPLE
        btn.Font = UI_FONT_HEAVY
        btn.TextSize = 9
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        local tabBgGrad = Instance.new("UIGradient", btn)
        tabBgGrad.Name = "TabBgGrad"
        tabBgGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,150,215)), ColorSequenceKeypoint.new(1, Color3.fromRGB(214,42,126))})
        tabBgGrad.Rotation = 0
        local tabStroke = Instance.new("UIStroke", btn)
        tabStroke.Name = "TabStroke"
        tabStroke.Color = THEME_PURPLE
        tabStroke.Thickness = 1.5
        tabStroke.Transparency = 1
        local underline = Instance.new("Frame", btn)
        underline.Name = "Underline"
        underline.Size = UDim2.new(0, 42, 0, 3)
        underline.Position = UDim2.new(0.5, 0, 1, -3)
        underline.AnchorPoint = Vector2.new(0.5, 0)
        underline.BackgroundColor3 = THEME_PURPLE
        underline.BorderSizePixel = 0
        underline.Visible = false
        underline.ZIndex = 12
        Instance.new("UICorner", underline).CornerRadius = UDim.new(1, 0)

        local page = Instance.new("ScrollingFrame", tabContent)
        page.Name = name .. "Section"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(0, 0, 0, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = THEME_PURPLE
        page.ScrollBarImageTransparency = 0.3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        page.Visible = (i == 1)
        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 8); padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingTop = UDim.new(0, 6); padding.PaddingBottom = UDim.new(0, 20)
        contentPages[name] = page

        btn.MouseButton1Click:Connect(function()
            local activeAccent = THEME_PURPLE
            for _, pg in pairs(contentPages) do pg.Visible = false end
            page.Visible = true
            for _, other in ipairs(tabButtons) do
                local ul = other:FindFirstChild("Underline")
                if ul then ul.Visible = false end
                local stroke = other:FindFirstChild("TabStroke")
                TS:Create(other, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(26, 8, 22),
                    TextColor3 = THEME_PURPLE
                }):Play()
                if stroke then TS:Create(stroke, TweenInfo.new(0.2), {Transparency = 1}):Play() end
            end
            underline.Visible = true
            underline.BackgroundColor3 = activeAccent
            TS:Create(btn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
                BackgroundTransparency = 1,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                TextColor3 = THEME_PURPLE
            }):Play()
            local stroke = btn:FindFirstChild("TabStroke")
            if stroke then
                stroke.Color = activeAccent
                TS:Create(stroke, TweenInfo.new(0.22), {Transparency = 0.3}):Play()
            end
        end)
        btn.MouseEnter:Connect(function()
            if underline.Visible then return end
            TS:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.55, TextColor3 = THEME_PURPLE}):Play()
        end)
        btn.MouseLeave:Connect(function()
            if underline.Visible then return end
            TS:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = THEME_PURPLE}):Play()
        end)
        table.insert(tabButtons, btn)
    end
    if tabButtons[1] then
        local first = tabButtons[1]
        first.Underline.Visible = true
        first.BackgroundColor3 = THEME_PURPLE
        first.BackgroundTransparency = 1
        first.TextColor3 = THEME_PURPLE
        first.TabStroke.Transparency = 0.3
    end

    local pageCounters = {}

    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -16, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = getThemeColor()
        l.Font = UI_FONT_HEAVY
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextStrokeColor3 = Color3.fromRGB(60,60,60)
        l.TextStrokeTransparency = 0.3
        l.ZIndex = 8
        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(1, -24, 0, 1.5)
        line.Position = UDim2.new(0, 12, 1, -4)
        line.BackgroundColor3 = getThemeColor()
        line.BackgroundTransparency = 0.6
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
        l.Font = UI_FONT_BOLD
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.5
        l.ZIndex = 8
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Name = "Track"
        pill.Size = UDim2.new(0, 34, 0, 18)
        pill.AnchorPoint = Vector2.new(0.5, 0.5)
        pill.Position = UDim2.new(1, -(offset or 48), 0.5, 0)
        pill.BackgroundColor3 = Color3.fromRGB(0,0,0)
        pill.BackgroundTransparency = 0
        pill.BorderSizePixel = 0
        pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 9)
        local stroke = Instance.new("UIStroke", pill)
        stroke.Color = Color3.fromRGB(145, 145, 150)
        stroke.Thickness = 1
        stroke.Transparency = 0.35
        stroke.Name = "PillStroke"

        local dot = Instance.new("Frame", pill)
        dot.Name = "Knob"
        dot.Size = UDim2.new(0, 13, 0, 13)
        dot.AnchorPoint = Vector2.new(0, 0)
        dot.Position = UDim2.new(0, 3, 0.5, -6)
        dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
        dot.BorderSizePixel = 0
        dot.ZIndex = 10
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local shine = Instance.new("Frame", dot)
        shine.Name = "Shine"
        shine.Size = UDim2.new(1, -4, 0, 4)
        shine.Position = UDim2.new(0, 2, 0, 2)
        shine.BackgroundColor3 = Color3.fromRGB(0,0,0)
        shine.BackgroundTransparency = 0.82
        shine.BorderSizePixel = 0
        shine.ZIndex = 10
        Instance.new("UICorner", shine).CornerRadius = UDim.new(0, 4)

        return pill, dot
    end

    local function animPill(pill, dot, on)
        local stroke = pill:FindFirstChildOfClass("UIStroke")
        local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(dot, info, {
            Position = on and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
            BackgroundColor3 = on and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255),
        }):Play()
        TS:Create(pill, info, {
            BackgroundColor3 = on and getThemeColor() or Color3.fromRGB(0,0,0),
            BackgroundTransparency = 0,
        }):Play()
        if stroke then
            TS:Create(stroke, info, {
                Color = on and getThemeColor() or Color3.fromRGB(145, 145, 150),
                Transparency = on and 0.2 or 0.35,
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
        valLabel.Font = UI_FONT_BOLD
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
        if txt == "Auto Steal" then
            local autoGrabBackground = Instance.new("ImageLabel", pill)
            autoGrabBackground.Name = "AutoGrabBackground"
            autoGrabBackground.Size = UDim2.new(1, 0, 1, 0)
            autoGrabBackground.Position = UDim2.new(0, 0, 0, 0)
            autoGrabBackground.BackgroundTransparency = 1
            autoGrabBackground.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
            autoGrabBackground.ImageTransparency = 0
            autoGrabBackground.ScaleType = Enum.ScaleType.Crop
            autoGrabBackground.ZIndex = 8
            autoGrabBackground.Active = false
            Instance.new("UICorner", autoGrabBackground).CornerRadius = UDim.new(0, 9)
        end
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            local nextState = not on
            sv(nextState)
            pcall(cb, nextState)
            pcall(saveAllSettings)
        end)
        return sv
    end

    local function mkSelector(parent, default, options, cb)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0, 184, 1, 0)
        container.Position = UDim2.new(1, -192, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8

        local valueFrame = Instance.new("Frame", container)
        valueFrame.Name = "SelectorValue"
        valueFrame.Size = UDim2.new(0, 112, 0, 28)
        valueFrame.Position = UDim2.new(0.5, -56, 0.5, -14)
        valueFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        valueFrame.BorderSizePixel = 0
        valueFrame.ZIndex = 8
        Instance.new("UICorner", valueFrame).CornerRadius = UDim.new(0, 10)
        local valueStroke = Instance.new("UIStroke", valueFrame)
        valueStroke.Color = THEME_PURPLE
        valueStroke.Thickness = 1.6
        valueStroke.Transparency = 0.05
        local valueGradient = Instance.new("UIGradient", valueFrame)
        valueGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 8)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(24, 8, 8)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
        })
        valueGradient.Rotation = 90

        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 30, 0, 28)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -14)
        leftBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        leftBtn.BackgroundTransparency = 0
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "‹"
        leftBtn.TextColor3 = THEME_PURPLE
        leftBtn.Font = UI_FONT_BOLD
        leftBtn.TextSize = 20
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 10)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = THEME_PURPLE
        leftStroke.Thickness = 1

        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(0, 86, 0, 28)
        label.Position = UDim2.new(0.5, -43, 0.5, -14)
        label.BackgroundTransparency = 1
        label.Text = default
        label.TextColor3 = THEME_PURPLE
        label.Font = UI_FONT_BOLD
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.ZIndex = 9

        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 30, 0, 28)
        rightBtn.Position = UDim2.new(1, -30, 0.5, -14)
        rightBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        rightBtn.BackgroundTransparency = 0
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = "›"
        rightBtn.TextColor3 = THEME_PURPLE
        rightBtn.Font = UI_FONT_BOLD
        rightBtn.TextSize = 20
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 10)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = THEME_PURPLE
        rightStroke.Thickness = 1

        local function updateLabel(newText)
            label.Text = tostring(newText)
        end
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
        tb.Font = UI_FONT_BOLD
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
            if cb then local n = tonumber(tb.Text); if n then cb(n); pcall(saveAllSettings) else tb.Text = tostring(default) end end
        end)
        return tb
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
        btn.Font = UI_FONT_BOLD
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

    local function addDiscordInviteRow(page)
        local row = mkRow(page, 30)
        local invite = Instance.new("TextLabel", row)
        invite.Size = UDim2.new(1, -16, 1, 0)
        invite.Position = UDim2.new(0, 8, 0, 0)
        invite.BackgroundTransparency = 1
        invite.Text = "Discord: discord.gg/4KTDUELS"
        invite.TextColor3 = getThemeColor()
        invite.Font = UI_FONT_BOLD
        invite.TextSize = 11
        invite.TextXAlignment = Enum.TextXAlignment.Center
        invite.TextYAlignment = Enum.TextYAlignment.Center
        invite.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        invite.TextStrokeTransparency = 0.4
        invite.ZIndex = 8
    end

    local speedPage = contentPages["Speed"]
    addDiscordInviteRow(speedPage)
    mkSect(speedPage, "Speed Settings")
    do local row = mkRow(speedPage, 38); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 58, 64, function(v) if v > 0 then NS = v; CarrySystem:setNormalSpeed(v) end end) end
    do local row = mkRow(speedPage, 38); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 58, 64, function(v) if v > 0 then CS = v; CarrySystem:setCarrySpeed(v) end end) end
    do local row = mkRow(speedPage, 38); mkLabel(row, "Lagger 1 Speed"); laggerBox = mkBox(row, LAGGER_SPEED, 58, 64, function(v) if v > 0 then LAGGER_SPEED = v; CarrySystem:setLaggerSpeed(v) end end) end
    do local row = mkRow(speedPage, 38); mkLabel(row, "Lagger 2 Speed"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 58, 64, function(v) if v > 0 then LAGGER_CARRY_SPEED = v; CarrySystem:setLaggerCarrySpeed(v) end end) end
    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Current Mode")
        modeValLbl = Instance.new("TextLabel", row)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = WHITE
        modeValLbl.Font = UI_FONT_HEAVY
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

    mkSect(speedPage, "Movement")
    setFloatVisual = mkToggle(speedPage, "Float", function(on)
        FloatModule.setEnabled(on)
    end)
    if setFloatVisual then setFloatVisual(FloatModule.running) end

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

    mkSect(speedPage, "Auto Carry")
    local autoCarrySetVisual = mkToggle(speedPage, "Auto Carry", function(on)
        autoCarryEnabled = on
        if not on and _G.__ZenxAutoCarryRestore then pcall(_G.__ZenxAutoCarryRestore) end
        pcall(saveAllSettings)
    end)
    local autoCarryModeLabel
    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Auto Carry Mode")
        local options = { "On Pick Up", "Soft Steal" }
        autoCarryModeLabel = mkSelector(row, autoCarryMode, options, function(direction, update)
            local index = (autoCarryMode == "Soft Steal") and 2 or 1
            index = ((index - 1 + direction) % #options) + 1
            autoCarryMode = options[index]
            update(autoCarryMode)
            if _G.__ZenxAutoCarryReapply then pcall(_G.__ZenxAutoCarryReapply) end
            pcall(saveAllSettings)
        end)
    end
    autoCarrySetVisual(autoCarryEnabled == true)
    _G.__ZenxAutoCarrySetVisual = autoCarrySetVisual
    _G.__ZenxAutoCarryRefresh = function()
        autoCarrySetVisual(autoCarryEnabled == true)
        if autoCarryModeLabel then autoCarryModeLabel.Text = autoCarryMode end
    end

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
        actLbl.Font = UI_FONT_BOLD
        actLbl.TextSize = 9
        actLbl.TextXAlignment = Enum.TextXAlignment.Right
        actLbl.ZIndex = 8
    end

    local combatPage = contentPages["Combat"]

    mkSect(combatPage, "Anti Ragdoll")
    do
        local ragOptions = {"Off", "V1", "V2"}
        local function ragLabel(mode)
            if mode == "v1" then return "V1" end
            if mode == "v2" then return "V2" end
            return "Off"
        end
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Anti Ragdoll")
        local current = ragLabel(antiRagdollMode)
        local selectorLabel = mkSelector(row, current, ragOptions, function(direction, update)
            local idx = 1
            for i, value in ipairs(ragOptions) do
                if value == current then idx = i; break end
            end
            idx = ((idx - 1 + direction) % #ragOptions) + 1
            current = ragOptions[idx]
            update(current)
            setAntiRagdollMode(current:lower())
        end)
        local function updateAntiRagdollUI(mode)
            current = ragLabel(mode)
            if selectorLabel then selectorLabel.Text = current end
        end
        _G.updateAntiRagdollUI = updateAntiRagdollUI
        updateAntiRagdollUI(antiRagdollMode)
    end

    mkSect(combatPage, "Defense")
    setAntiBatVisual = mkToggle(combatPage, "Anti Bat", function(on)
        if on then startAntiBat() else stopAntiBat() end
        saveAllSettings()
    end)
    if setAntiBatVisual then setAntiBatVisual(antiBatEnabled) end

    setJumpVisual = mkToggle(combatPage, "Infinite Jump", function(on)
        jumpEnabled = on == true
        if jumpEnabled then InfiniteJump.start() else InfiniteJump.stop() end
        saveAllSettings()
    end)
    if setJumpVisual then setJumpVisual(jumpEnabled) end

    setUnwalkVisual = mkToggle(combatPage, "Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        antiDieEnabled = on == true
        FloatModule.syncAntiDieForMovement()
        saveAllSettings()
    end)
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end

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

    mkSect(combatPage, "Targeting")
    bodyLockSetVisual = mkToggle(combatPage, "Body Lock", function(on)
        bodyLockEnabled = on
        if on then
            if _blSuppressCount == 0 then startBodyLock() end
        else
            stopBodyLock()
        end
    end)
    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Body Lock Range")
        bodyLockRangeBox = mkBox(row, bodyLockRange, 50, 56, function(v)
            if v and v > 0 then
                bodyLockRange = _clamp(_floor(v), 5, 200)
                if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
            end
        end)
    end

    mkSect(combatPage, "Aimbots")
    autoBatSetVisual = mkToggle(combatPage, "Auto Bat", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
    end)

    do local row = mkRow(combatPage, 38); mkLabel(row, "Bat Aimbot Speed"); batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 56, function(v) if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v; saveAllSettings() end end) end

    autoSwingSetVisual = mkToggle(combatPage, "Auto Swing", function(on)
        AUTO_SWING_ENABLED = on == true
        saveAllSettings()
    end)
    if autoSwingSetVisual then autoSwingSetVisual(AUTO_SWING_ENABLED) end
    mkSect(combatPage, "Steal")
    setInstaGrab = mkToggle(combatPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        updateProgressBarVisibility()
    end)

    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Steal Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = _floor(v+0.5)
                Steal.StealRadius = CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                saveAllSettings()
            end
        end)
    end

    mkSect(combatPage, "Tamaño barra Steal")
    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Tamaño de barra")

        local function makeStealBarSizeButton(text, rightOffset)
            local button = Instance.new("TextButton", row)
            button.Size = UDim2.new(0, 28, 0, 26)
            button.Position = UDim2.new(1, -rightOffset, 0.5, -13)
            button.BackgroundColor3 = Color3.fromRGB(24, 10, 28)
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = WHITE
            button.Font = UI_FONT_BOLD
            button.TextSize = 16
            button.AutoButtonColor = true
            button.ZIndex = 9
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)
            local stroke = Instance.new("UIStroke", button)
            stroke.Color = THEME_PURPLE
            stroke.Thickness = 1
            stroke.Transparency = 0.25
            return button
        end

        local smallerButton = makeStealBarSizeButton("-", 104)
        local largerButton = makeStealBarSizeButton("+", 24)
        stealBarScaleLabel = Instance.new("TextLabel", row)
        stealBarScaleLabel.Size = UDim2.new(0, 44, 0, 26)
        stealBarScaleLabel.Position = UDim2.new(1, -72, 0.5, -13)
        stealBarScaleLabel.BackgroundTransparency = 1
        stealBarScaleLabel.TextColor3 = WHITE
        stealBarScaleLabel.Font = UI_FONT_BOLD
        stealBarScaleLabel.TextSize = 11
        stealBarScaleLabel.TextXAlignment = Enum.TextXAlignment.Center
        stealBarScaleLabel.ZIndex = 9
        setZenxAdaptStealBarScale(stealBarScale, false)

        smallerButton.MouseButton1Click:Connect(function()
            setZenxAdaptStealBarScale(stealBarScale - 0.1, true)
        end)
        largerButton.MouseButton1Click:Connect(function()
            setZenxAdaptStealBarScale(stealBarScale + 0.1, true)
        end)
    end

    local visualPage = contentPages["Main"]

    mkSect(visualPage, "Interface")
    setLockUIVisual = mkToggle(visualPage, "Lock UI", function(on)
        toggleLockUI(on)
        saveAllSettings()
    end)

    setHideButtonsVisual = mkToggle(visualPage, "Hide Buttons", function(on)
        hideButtons = on == true
        applyHideButtonsVisibility()
        saveAllSettings()
    end)
    if setHideButtonsVisual then setHideButtonsVisual(hideButtons) end

    mkSect(visualPage, "Bat Skins")
    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "Bat Skins")
        batSkinIndex = getBatSkinIndex(currentBatSkin)
        batSkinSelectorLabel = mkSelector(row, BAT_SKIN_OPTIONS[batSkinIndex], BAT_SKIN_OPTIONS, function(direction, update)
            batSkinIndex = ((batSkinIndex - 1 + direction) % #BAT_SKIN_OPTIONS) + 1
            currentBatSkin = BAT_SKIN_OPTIONS[batSkinIndex]
            update(currentBatSkin)
            applyBatSkinToCharacter()
            saveAllSettings()
        end)
    end

    addDiscordInviteRow(visualPage)
    mkSect(visualPage, "Personalización")

    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "Anim Pack")
        local animOptions = {}
        for _, entry in ipairs(ANIM_PACK_ORDER) do table.insert(animOptions, entry[2]) end
        local animIndex = 1
        for i, name in ipairs(animOptions) do
            if name == currentAnimPack then animIndex = i; break end
        end
        animSelectorLabel = mkSelector(row, animOptions[animIndex], animOptions, function(direction, update)
            animIndex = ((animIndex - 1 + direction) % #animOptions) + 1
            local packName = animOptions[animIndex]
            update(packName)
            if packName == "Off" then stopAnimPack() else startAnimPack(packName) end
            saveAllSettings()
        end)
    end

    setESPVIsual = mkToggle(visualPage, "Player ESP", function(on) toggleESP(on) end)

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

    mkSect(visualPage, "Performance")
    setPotatoGraphicsVisual = mkToggle(visualPage, "Potato Graphics", function(on)
        if on then enablePotatoGraphics() else disablePotatoGraphics() end
        saveAllSettings()
    end)
    if setPotatoGraphicsVisual then setPotatoGraphicsVisual(potatoGraphicsEnabled == true) end

    setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
        saveAllSettings()
    end)

    mkSect(visualPage, "Fondo X Menu")
    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "Fondo X Menu")
        local bgOptions = {}
        for i = 1, #backgroundImages do table.insert(bgOptions, tostring(i) .. "/" .. #backgroundImages) end
        local currentBgIndex = backgroundIndex
        local bgLabel = mkSelector(row, bgOptions[currentBgIndex], bgOptions, function(direction, update)
            currentBgIndex = ((currentBgIndex - 1 + direction) % #backgroundImages) + 1
            backgroundIndex = currentBgIndex
            update(tostring(currentBgIndex) .. "/" .. #backgroundImages)
            local bgImg = main:FindFirstChild("BackgroundImage")
            if bgImg then bgImg.Image = "rbxassetid://" .. backgroundImages[currentBgIndex] end
            if miniHeaderImage then
                miniHeaderImage.Image = "rbxassetid://" .. backgroundImages[currentBgIndex]
                miniHeaderImage.Visible = true
            end
            if pbBackgroundImage then pbBackgroundImage.Image = "rbxassetid://" .. backgroundImages[currentBgIndex] end
            if MobilePanel then
                for _, obj in ipairs(MobilePanel:GetDescendants()) do
                    if obj.Name == "FloatingButtonBackground" and obj:IsA("ImageLabel") then obj.Image = "rbxassetid://" .. backgroundImages[currentBgIndex] end
                end
            end
            if miniHeaderImage then
                miniHeaderImage.Image = "rbxassetid://" .. backgroundImages[currentBgIndex]
                miniHeaderImage.Visible = true
            end
            if instaResetFloatingButton then
                for _, obj in ipairs(instaResetFloatingButton:GetDescendants()) do
                    if obj.Name == "FloatingButtonBackground" and obj:IsA("ImageLabel") then obj.Image = "rbxassetid://" .. backgroundImages[currentBgIndex] end
                end
            end
            if main then
                for _, obj in ipairs(main:GetDescendants()) do
                    if obj.Name == "AutoGrabBackground" and obj:IsA("ImageLabel") then obj.Image = "rbxassetid://" .. backgroundImages[currentBgIndex] end
                end
            end
            if zenxAdaptStealBar.frame then
                local barBackground = zenxAdaptStealBar.frame:FindFirstChild("AutoGrabBarBackground")
                if barBackground then barBackground.Image = "rbxassetid://" .. backgroundImages[currentBgIndex] end
            end
            saveAllSettings()
        end)
    end

    -- Configuración movida al final de VISUAL.

    mkSect(visualPage, "UI Settings")
    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "UI Scale")
        uiScaleBox = mkBox(row, uiScaleValue, 50, 56, function(v)
            local n = _clamp(_floor(v+0.5), 50, 150)
            uiScaleValue = n
            if mainUIScale then mainUIScale.Scale = n/100 end
            if pbScale then pbScale.Scale = n/100 end
        end)
    end

    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "Float Scale")
        local box = mkBox(row, _floor(floatingButtonScale * 100), 50, 56, function(v)
            local val = _clamp(v, 50, 200)
            floatingButtonScale = val / 100
            applyFloatingButtonScale()
            saveAllSettings()
        end)
    end

    mkSect(visualPage, "Config Management")
    do
        local row = mkRow(visualPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(1, -20, 0.72, 0)
        saveBtn.Position = UDim2.new(0, 10, 0.14, 0)
        saveBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        saveBtn.BackgroundTransparency = 0.12
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = WHITE
        saveBtn.Font = UI_FONT_BOLD
        saveBtn.TextSize = 13
        saveBtn.TextStrokeColor3 = Color3.fromRGB(60,60,60)
        saveBtn.TextStrokeTransparency = 0
        saveBtn.AutoButtonColor = false
        saveBtn.ZIndex = 8
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 12)
        local saveStroke = Instance.new("UIStroke", saveBtn)
        saveStroke.Color = Color3.fromRGB(255,255,255)
        saveStroke.Thickness = 1.3
        saveStroke.Transparency = 0.18
        saveBtn.MouseButton1Click:Connect(function()
            local ok = saveAllSettings()
            saveBtn.Text = ok and "SAVED ✓" or "ERROR"
            task.delay(1.2, function()
                if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE CONFIG" end
            end)
        end)
    end

    do
        local row = mkRow(visualPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local resetPosBtn = Instance.new("TextButton", row)
        resetPosBtn.Size = UDim2.new(1, -20, 0.72, 0)
        resetPosBtn.Position = UDim2.new(0, 10, 0.14, 0)
        resetPosBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        resetPosBtn.BackgroundTransparency = 0.12
        resetPosBtn.BorderSizePixel = 0
        resetPosBtn.Text = "RESET POSITIONS"
        resetPosBtn.TextColor3 = WHITE
        resetPosBtn.Font = UI_FONT_BOLD
        resetPosBtn.TextSize = 13
        resetPosBtn.TextStrokeColor3 = Color3.fromRGB(60,60,60)
        resetPosBtn.TextStrokeTransparency = 0
        resetPosBtn.AutoButtonColor = false
        resetPosBtn.ZIndex = 8
        Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 12)
        local resetStroke = Instance.new("UIStroke", resetPosBtn)
        resetStroke.Color = Color3.fromRGB(255,255,255)
        resetStroke.Thickness = 1.3
        resetStroke.Transparency = 0.18
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

    do
        local row = mkRow(visualPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(1, -20, 0.72, 0)
        delBtn.Position = UDim2.new(0, 10, 0.14, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        delBtn.BackgroundTransparency = 0.12
        delBtn.BorderSizePixel = 0
        delBtn.Text = "DELETE SETTINGS"
        delBtn.TextColor3 = WHITE
        delBtn.Font = UI_FONT_BOLD
        delBtn.TextSize = 13
        delBtn.TextStrokeColor3 = Color3.fromRGB(60,60,60)
        delBtn.TextStrokeTransparency = 0
        delBtn.AutoButtonColor = false
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 12)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = Color3.fromRGB(255,255,255)
        delStroke.Thickness = 1.3
        delStroke.Transparency = 0.18
        local deleteState = 0
        local originalDeleteText = "DELETE SETTINGS"
        local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then
                deleteState = 1
                delBtn.Text = "CONFIRM?"
                delBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local success = pcall(resetToFactoryDefaults)
                delBtn.Text = success and "DELETED ✓" or "ERROR"
                delBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
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
    addKeybindRow(keyPage, "Insta Reset", KB.InstaReset)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Float", KB.Float)
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    local musicPage = contentPages["Music"]
    mkSect(musicPage, "Music")
    for _, group in ipairs(DOMINA_MUSIC_LIBRARY) do
        mkSect(musicPage, group.artist)
        for _, song in ipairs(group.songs) do
            local row = mkRow(musicPage, 38)
            mkLabel(row, song.name)
            local playBtn = Instance.new("TextButton", row)
            playBtn.Size = UDim2.new(0, 58, 0, 24)
            playBtn.Position = UDim2.new(1, -68, 0.5, -12)
            playBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            playBtn.BackgroundTransparency = 0.18
            playBtn.BorderSizePixel = 0
            playBtn.Text = "PLAY"
            playBtn.TextColor3 = WHITE
            playBtn.Font = UI_FONT_BOLD
            playBtn.TextSize = 9
            playBtn.AutoButtonColor = false
            playBtn.ZIndex = 9
            Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 7)
            local playStroke = Instance.new("UIStroke", playBtn)
            playStroke.Color = getThemeColor()
            playStroke.Thickness = 1
            playBtn.MouseButton1Click:Connect(function() playDominaMusic(song, playBtn) end)
        end
    end

    local spacer = Instance.new("Frame", keyPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keyPage)
    spacer.ZIndex = 7

    pbFrame = Instance.new("Frame", gui)
    -- Barra de robo compacta y transparente: solo progreso, porcentaje y contorno.
    pbFrame.Size = UDim2.new(0, 280, 0, 42)
    pbFrame.Position = UDim2.new(0.5, -140, 1, -94)
    pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pbFrame.BackgroundTransparency = 1
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    -- Ocultar únicamente la barra de progreso; no desactiva Auto Steal.
    pbFrame.Visible = false
    pbFrame.ZIndex = 10

    pbBackgroundImage = Instance.new("ImageLabel", pbFrame)
    pbBackgroundImage.Name = "SelectedPanelBackground"
    pbBackgroundImage.Size = UDim2.new(1, 0, 1, 0)
    pbBackgroundImage.Position = UDim2.new(0, 0, 0, 0)
    pbBackgroundImage.BackgroundTransparency = 1
    pbBackgroundImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
    pbBackgroundImage.ImageTransparency = 0.22
    pbBackgroundImage.ScaleType = Enum.ScaleType.Crop
    pbBackgroundImage.ZIndex = 10
    pbBackgroundImage.ClipsDescendants = true
    Instance.new("UICorner", pbBackgroundImage).CornerRadius = UDim.new(0, 8)
    local pbShade = Instance.new("Frame", pbFrame)
    pbShade.Name = "SelectedPanelShade"
    pbShade.Size = UDim2.new(1, 0, 1, 0)
    pbShade.Position = UDim2.new(0, 0, 0, 0)
    pbShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pbShade.BackgroundTransparency = 0.42
    pbShade.BorderSizePixel = 0
    pbShade.ZIndex = 11
    Instance.new("UICorner", pbShade).CornerRadius = UDim.new(0, 8)
    pbScale = Instance.new("UIScale", pbFrame)
    pbScale.Scale = uiScaleValue / 100

    if savedProgressBarPos then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5,
            savedProgressBarPos.XOffset or -140,
            savedProgressBarPos.YScale or 1,
            savedProgressBarPos.YOffset or -94
        )
    end

    local barCorner = Instance.new("UICorner", pbFrame)
    barCorner.CornerRadius = UDim.new(0, 8)

    local border = Instance.new("UIStroke", pbFrame)
    border.Color = Color3.fromRGB(0, 0, 0)
    border.Thickness = 1.5
    border.Transparency = 0.18
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local topRow = Instance.new("Frame", pbFrame)
    topRow.Name = "MetricsRow"
    topRow.Size = UDim2.new(1, -20, 0, 16)
    topRow.Position = UDim2.new(0, 10, 0, 3)
    topRow.BackgroundTransparency = 1
    topRow.ZIndex = 15

    local metricsTitle = Instance.new("TextLabel", topRow)
    menuMetricsTitle = metricsTitle
    metricsTitle.Name = "MetricsTitle"
    metricsTitle.Size = UDim2.new(0.42, 0, 1, 0)
    metricsTitle.BackgroundTransparency = 1
    metricsTitle.Text = ""
    metricsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    metricsTitle.Font = UI_FONT_HEAVY
    metricsTitle.TextSize = 10
    metricsTitle.TextXAlignment = Enum.TextXAlignment.Left
    metricsTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    metricsTitle.TextStrokeTransparency = 0.15
    metricsTitle.ZIndex = 16

    applyMenuGuiStyle(menuGuiStyle)

    local fpsNeon = Instance.new("TextLabel", topRow)
    fpsNeon.Name = "FPSNeon"
    fpsNeon.Size = UDim2.new(0.58, 0, 1, 0)
    fpsNeon.Position = UDim2.new(0.42, 0, 0, 0)
    fpsNeon.BackgroundTransparency = 1
    fpsNeon.Text = "FPS --  |  Ping -- ms"
    fpsNeon.TextColor3 = getThemeColor()
    fpsNeon.Font = UI_FONT_BOLD
    fpsNeon.TextSize = 9
    fpsNeon.TextXAlignment = Enum.TextXAlignment.Right
    fpsNeon.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    fpsNeon.TextStrokeTransparency = 0.1
    fpsNeon.ZIndex = 16

    task.spawn(function()
        local t = 0
        while fpsNeon and fpsNeon.Parent do
            t = t + 0.03
            local baseColor = getThemeColor()
            local hueShift = math.sin(t * 1.5) * 0.08
            fpsNeon.TextColor3 = Color3.new(
                _clamp(baseColor.r + hueShift, 0, 1),
                _clamp(baseColor.g + hueShift * 0.6, 0, 1),
                _clamp(baseColor.b - hueShift * 0.3, 0, 1)
            )
            task.wait(0.05)
        end
    end)

    local progressRow = Instance.new("Frame", pbFrame)
    progressRow.Name = "ProgressRow"
    progressRow.Size = UDim2.new(1, -20, 0, 12)
    progressRow.Position = UDim2.new(0, 10, 0, 25)
    progressRow.BackgroundTransparency = 1
    progressRow.ZIndex = 15

    local fillRegion = Instance.new("Frame", progressRow)
    fillRegion.Name = "ProgressTrack"
    fillRegion.Size = UDim2.new(1, 0, 1, 0)
    fillRegion.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    fillRegion.BackgroundTransparency = 1
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    fillRegion.ZIndex = 16
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(0, 6)
    local trackStroke = Instance.new("UIStroke", fillRegion)
    trackStroke.Color = Color3.fromRGB(0, 0, 0)
    trackStroke.Transparency = 0
    trackStroke.Thickness = 1

    progressFill = Instance.new("Frame", fillRegion)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = getThemeColor()
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 17
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 6)

    local fillGrad = Instance.new("UIGradient", progressFill)
    local color2 = THEME_PURPLE
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(210, 160, 255)),
        ColorSequenceKeypoint.new(0.50, color2),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(105, 40, 170)),
    })

    local glowEnd = Instance.new("Frame", progressFill)
    glowEnd.Size = UDim2.new(0, 12, 1, 0)
    glowEnd.Position = UDim2.new(1, -12, 0, 0)
    glowEnd.BackgroundColor3 = Color3.fromRGB(220, 190, 255)
    glowEnd.BackgroundTransparency = 0.62
    glowEnd.BorderSizePixel = 0
    glowEnd.ZIndex = 18
    Instance.new("UICorner", glowEnd).CornerRadius = UDim.new(1, 0)

    progressPct = Instance.new("TextLabel", progressRow)
    progressPct.Name = "ProgressPercent"
    progressPct.Size = UDim2.new(1, -8, 1, 0)
    progressPct.Position = UDim2.new(0, 4, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressPct.Font = UI_FONT_HEAVY
    progressPct.TextSize = 10
    progressPct.TextXAlignment = Enum.TextXAlignment.Center
    progressPct.TextYAlignment = Enum.TextYAlignment.Center
    progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    progressPct.TextStrokeTransparency = 0
    progressPct.ZIndex = 19

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
                fpsNeon.Text = string.format("FPS %d  |  Ping %d ms", _floor(fpsAvg + 0.5), _floor(ping + 0.5))
            end
            task.wait(0.75)
        end
    end)

    -- Unificar todos los botones visibles del panel en el estilo de referencia.
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextButton") and (obj.Text ~= "" or obj == closeBtn or obj == miniBtn) then
            obj.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            obj.BackgroundTransparency = 0.12
            obj.TextColor3 = Color3.fromRGB(255, 255, 255)
            obj.AutoButtonColor = false
            local btnStroke = obj:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", obj)
            btnStroke.Color = Color3.fromRGB(255, 255, 255)
            btnStroke.Thickness = 1.1
            btnStroke.Transparency = 0.45
            if not obj:FindFirstChildOfClass("UICorner") then
                Instance.new("UICorner", obj).CornerRadius = UDim.new(0, 10)
            end
        end
    end

    drag(main)
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "BloodHoundsMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.Enabled = not hideButtons
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local COLUMNS = 2
    local ROWS = 5
    local PANEL_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1)
    local PANEL_H = BTN_H * ROWS + (GAP + 10) * (ROWS - 1)

    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    container.Position = UDim2.new(1, -(PANEL_W + 12), 0.5, -PANEL_H / 2)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    -- Solo los botones reciben input; los espacios vacios no bloquean controles de Roblox.
    container.Active = false
    container.Selectable = false
    container.ClipsDescendants = false

    local containerScale = Instance.new("UIScale", container)
    containerScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, containerScale)

    local btnContainer = Instance.new("Frame", container)
    btnContainer.Name = "ButtonsContainer"
    btnContainer.Size = UDim2.new(1, 0, 1, 0)
    btnContainer.BackgroundTransparency = 1
    btnContainer.ClipsDescendants = false
    btnContainer.Active = false

    local WHITE = Color3.fromRGB(255, 255, 255)
    local INACTIVE_BG = WHITE
    local INACTIVE_TEXT = Color3.fromRGB(170, 255, 170)
    local STROKE_COLOR = THEME_PURPLE
    local ACTIVE_BG = THEME_PURPLE
    local ACTIVE_TEXT = Color3.fromRGB(170, 255, 170)

    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2", "InstaReset", "Float"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\n1", "LAGGER\n2", "INSTA\nRESET", "FLOAT"}

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

        btn.BackgroundTransparency = 1
        btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18)

        local buttonBackground = Instance.new("ImageLabel", btn)
        buttonBackground.Name = "FloatingButtonBackground"
        buttonBackground.Size = UDim2.new(1, 0, 1, 0)
        buttonBackground.BackgroundTransparency = 1
        buttonBackground.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
        buttonBackground.ImageTransparency = 0
        buttonBackground.ScaleType = Enum.ScaleType.Crop
        buttonBackground.ZIndex = 9
        buttonBackground.Active = false
        Instance.new("UICorner", buttonBackground).CornerRadius = UDim.new(0, 18)

        local bgGrad = Instance.new("UIGradient", btn)
        bgGrad.Name = "BtnGrad"
        bgGrad.Rotation = 90
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(22,22,25)),
            ColorSequenceKeypoint.new(0.18, Color3.fromRGB(2,2,3)),
            ColorSequenceKeypoint.new(0.82, Color3.fromRGB(2,2,3)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(22,22,25)),
        })

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = THEME_PURPLE
        stroke.Thickness = 1.1
        stroke.Transparency = 0.45
        stroke.Name = "NormalStroke"

        local label = Instance.new("TextLabel", btn)
        label.Name = "TextLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = INACTIVE_TEXT
        label.Font = UI_FONT_HEAVY
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
                TS:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, startPos.X.Offset, 0, startPos.Y.Offset + 4),
                    Size = UDim2.new(0, BTN_W, 0, BTN_H - 4)
                }):Play()
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
                    local releasePosition = hasMoved and btn.Position or startPos
                    dragging = false
                    hasMoved = false
                    dragStart = nil
                    startPos = nil
                    movedDistance = 0
                    _isDraggingButton = false
                    TS:Create(btn, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = releasePosition or btn.Position,
                        Size = UDim2.new(0, BTN_W, 0, BTN_H)
                    }):Play()
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
                toggleCarryMode()
                setActive(speedMode)
            end
        elseif name == "Lagger1" then
            callback = function(setActive)
                toggleLaggerMode()
                setActive(laggerToggled)
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                toggleLaggerCarryMode()
                setActive(laggerCarryToggled)
            end
        elseif name == "InstaReset" then
            callback = function(setActive)
                setActive(true)
                if _G.InstaReset and _G.InstaReset.Trigger then
                    _G.InstaReset.Trigger()
                end
                task.delay(0.2, function() setActive(false) end)
            end
        elseif name == "Float" then
            callback = function(setActive)
                FloatModule.toggle()
                setActive(FloatModule.running)
                if setFloatVisual then setFloatVisual(FloatModule.running) end
                pcall(saveAllSettings)
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
        mobSetFloat = buttons.Float and buttons.Float.setActive

        local setActive = createButton(name, text, i-1, true, callback)
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
        if name == "Float" then mobSetFloat = setActive end
    end

    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end
    if buttons.Float and buttons.Float.setActive then buttons.Float.setActive(FloatModule.running) end

    if savedMobilePanelPos then
        container.Position = UDim2.new(
            savedMobilePanelPos.XScale or 0,
            savedMobilePanelPos.XOffset or -(PANEL_W + 12),
            savedMobilePanelPos.YScale or 0.5,
            savedMobilePanelPos.YOffset or -PANEL_H / 2
        )
    end

    return panel
end

function createInstaResetFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 23
    panel.Enabled = not hideButtons
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(instaResetFloatingPos.XScale or 0.5,
                                      instaResetFloatingPos.XOffset or 90,
                                      instaResetFloatingPos.YScale or 0,
                                      instaResetFloatingPos.YOffset or 10)
    else
        btnFrame.Position = UDim2.new(0.5, (menuGuiWidth or 320) / 2 + 12, 0.5, -42)
    end
    btnFrame.BackgroundTransparency = 1
    btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btnFrame.BorderSizePixel  = 0
    btnFrame.ZIndex           = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)

    local buttonBackground = Instance.new("ImageLabel", btnFrame)
    buttonBackground.Name = "FloatingButtonBackground"
    buttonBackground.Size = UDim2.new(1, 0, 1, 0)
    buttonBackground.BackgroundTransparency = 1
    buttonBackground.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
    buttonBackground.ImageTransparency = 0
    buttonBackground.ScaleType = Enum.ScaleType.Crop
    buttonBackground.ZIndex = 19
    buttonBackground.Active = false
    Instance.new("UICorner", buttonBackground).CornerRadius = UDim.new(0, 18)

    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.18, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.82, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)),
    })

    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = THEME_PURPLE
    stroke.Thickness = 1
    stroke.Transparency = 0.55

    local label = Instance.new("TextLabel", btnFrame)
    label.Name = "TextLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "INSTA\nRESET"
    label.TextColor3 = Color3.fromRGB(170, 255, 170)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.2
    label.Font = UI_FONT_HEAVY
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
        paintFloatingBtn(btnFrame, state == true)
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
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if carrySysNormalBox then carrySysNormalBox.Text = tostring(CarrySystem.normalSpeed) end
    if carrySysCarryBox then carrySysCarryBox.Text = tostring(CarrySystem.carrySpeed) end
    if carrySysLaggerBox then carrySysLaggerBox.Text = tostring(CarrySystem.laggerSpeed) end
    if carrySysLaggerCarryBox then carrySysLaggerCarryBox.Text = tostring(CarrySystem.laggerCarrySpeed) end
    if carrySystemToggleSetter then carrySystemToggleSetter(useCarrySystem) end
    refreshSpeedModeLabel()

    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end

    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5,
            savedProgressBarPos.XOffset or -140,
            savedProgressBarPos.YScale or 1,
            savedProgressBarPos.YOffset or -94
        )
    end

    local bgImg = main and main:FindFirstChild("BackgroundImage")
    if bgImg then
        bgImg.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
        bgImg.ImageTransparency = 0
    end
    if pbBackgroundImage then
        pbBackgroundImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
    end
    if miniBtn then
        local miniHeader = miniBtn:FindFirstChild("MiniHeaderImage")
        if miniHeader then
            miniHeader.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
            miniHeader.Visible = true
        end
    end

    applyFloatingButtonScale()

    if uiLocked and setLockUIVisual then setLockUIVisual(true) end

    if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(antiRagdollMode) end
    if antiRagdollMode == "v1" then
        AntiRagdollV1.start()
    elseif antiRagdollMode == "v2" then
        startAntiRagdollV2()
    end

    if jumpEnabled then
        InfiniteJump.start()
        if setJumpVisual then setJumpVisual(true) end
    else
        InfiniteJump.stop()
        if setJumpVisual then setJumpVisual(false) end
    end
    if batSkinSelectorLabel then batSkinSelectorLabel.Text = currentBatSkin end
    if medusaSkinSelectorLabel then medusaSkinSelectorLabel.Text = currentMedusaSkin end
    applyBatSkinToCharacter()

    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        AntiDieModule.start()
    else
        if setAntiDieVisual then setAntiDieVisual(false) end
    end

    if antiBatEnabled then
        startAntiBat()
    else
        stopAntiBat()
    end
    if setAntiBatVisual then setAntiBatVisual(antiBatEnabled) end

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
    if unwalkEnabled and setUnwalkVisual then
        setUnwalkVisual(true)
        task.spawn(function() task.wait(0.5); startUnwalk() end)
    end
    if setAntiLagVisual then setAntiLagVisual(antiLagEnabled == true) end
    if setPotatoGraphicsVisual then setPotatoGraphicsVisual(potatoGraphicsEnabled == true) end
    if antiLagEnabled then enableAntiLag() else disableAntiLag() end
    if potatoGraphicsEnabled then enablePotatoGraphics() else disablePotatoGraphics() end
    if espEnabled then
        toggleESP(true)
        if setESPVIsual then setESPVIsual(true) end
    else
        toggleESP(false)
        if setESPVIsual then setESPVIsual(false) end
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

    if autoBatEnabled then pcall(startAimbotAdapt) end
    if autoLeftEnabled then pcall(startAutoLeft) end
    if autoRightEnabled then pcall(startAutoRight) end
    if unwalkEnabled then pcall(startUnwalk) end
    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end

    if bodyLockEnabled and bodyLockSetVisual then
        if _blSuppressCount == 0 then
            bodyLockSetVisual(true)
            startBodyLock()
        else
            bodyLockSetVisual(false)
        end
    end

    updateProgressBarVisibility()
    startEnemySpeed()

    toggleLockUI(uiLocked)

    pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
    if outfitSelectorLabel then
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
    end
end

buildGui()

task.delay(2, function()
    local seen = {}
    for _, cfg in ipairs(OUTFITS) do
        local ids = {}
        if cfg.accessory then table.insert(ids, cfg.accessory) end
        for _, id in ipairs(cfg.items or {}) do table.insert(ids, id) end
        for _, id in ipairs(ids) do
            if not seen[id] then
                seen[id] = true
                while os.clock() < outfitPreloadPauseUntil do task.wait(0.35) end
                if not outfitAssetTemplateCache[id] then
                    local loaded = loadObjectsStd(id)
                    if loaded then
                        for _, obj in ipairs(loaded) do pcall(function() obj:Destroy() end) end
                    end
                end
                task.wait(0.35)
            end
        end
    end
end)

if loadAllSettings() then
    updateUIFromLoaded()
end
-- Si el menú inicia cerrado, su botón de apertura conserva la posición del menú.
if miniBtn and main and not savedMainMenuOpen then
    miniBtn.Position = main.Position
end

MobilePanel = createMobilePanel()
-- Insta Reset ya está integrado en MobilePanel junto a todos los botones flotantes.
instaResetFloatingButton = nil
if setHideButtonsVisual then setHideButtonsVisual(hideButtons) end
applyHideButtonsVisibility()
if savedMainMenuOpen then
    task.defer(function()
        if showGui then showGui() end
    end)
end

if useCarrySystem then
    CarrySystem:start()
    CarrySystem.speedToggled = speedMode
    if laggerCarryToggled then
        CarrySystem:setLaggerMode(2)
    elseif laggerToggled then
        CarrySystem:setLaggerMode(1)
    else
        CarrySystem:setLaggerMode(0)
    end
end

if LP.Character then
    task.wait(0.1)
    local initialCharacter = LP.Character
    if waitForCharReady(initialCharacter, 5) then
        setupMovementAndIndicators(initialCharacter)
        if currentAnimPack ~= "Off" then
            startAnimPack(currentAnimPack)
        end
        pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
        task.delay(0.5, function()
            if LP.Character ~= initialCharacter then return end
            appliedOutfitChar = nil
            appliedOutfitIndex = nil
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            scheduleBatSkinRefresh()
        end)
    end
end

-- ============================================================
-- CONEXIÓN ÚNICA DE RESPAWN (evita race conditions)
-- ============================================================
local _respawnQueue = 0
LP.CharacterAdded:Connect(function(char)
    _respawnQueue = _respawnQueue + 1
    local myId = _respawnQueue
    appliedOutfitChar = nil
    appliedOutfitIndex = nil

    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
    isStealing = false
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopMedusaCounter()
    stopUnwalk()
    stopDropBrainrot()
    if autoBatEnabled then disableAutoBat() end
    if bodyLockEnabled then stopBodyLock() end

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
    if antiBatEnabled then startAntiBat() else stopAntiBat() end

    if antiRagdollMode == "v1" then AntiRagdollV1.start()
    elseif antiRagdollMode == "v2" then startAntiRagdollV2() end

    if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
    if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end

    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then startUnwalk() end

    if currentAnimPack ~= "Off" then
        task.wait(0.3)
        startAnimPack(currentAnimPack)
    end

    updateProgressBarVisibility()
    refreshSpeedModeLabel()

    pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
    task.delay(0.5, function()
        if myId ~= _respawnQueue or LP.Character ~= char then return end
        appliedOutfitChar = nil
        appliedOutfitIndex = nil
        pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
        scheduleBatSkinRefresh()
    end)
    if outfitSelectorLabel then
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
    end
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
    if kbMatch(KB.Float, kc) then
        FloatModule.toggle()
        pcall(saveAllSettings)
        return
    end
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
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)