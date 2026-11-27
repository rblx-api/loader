-- AkatsukiHub: codigo principal extraido del bloque Luau ofuscado.
-- Ejecutar en un entorno Roblox/Luau con las funciones del executor que utiliza el script.

do
  local z = _G
  pcall(function()
    local C = type(getfenv)
    if C == "function" then
      z = getfenv(0)
    end
  end)
  local C = z
  pcall(function()
    local b = type(getgenv)
    if b == "function" then
      C = getgenv()
    end
  end)
  if type(z) ~= "table" then
    z = _G
  end
  if type(C) ~= "table" then
    C = z
  end
  local b, D =
    rawget(z, "sethiddenproperty") or (rawget(C, "sethiddenproperty")) or (rawget(
      z,
      "set_hidden_property"
    )) or (rawget(C, "set_hidden_property")) or (rawget(z, "sethiddenprop")) or (rawget(
      C,
      "sethiddenprop"
    )),
    rawget(z, "syn") or (rawget(C, "syn"))
  if type(b) ~= "function" and type(D) == "table" then
    b = rawget(D, "sethiddenproperty") or (rawget(D, "set_hidden_property"))
  end
  if type(b) == "function" then
    pcall(function()
      rawset(z, "sethiddenproperty", b)
    end)
    pcall(function()
      rawset(C, "sethiddenproperty", b)
    end)
  end
  local b = rawget(z, "setfpscap")
    or (rawget(C, "setfpscap"))
    or (rawget(z, "set_fps_cap"))
    or (rawget(C, "set_fps_cap"))
    or (rawget(z, "setfpslimit"))
    or (rawget(C, "setfpslimit"))
  b = if type(b) ~= "function" and type(D) == "table"
    then rawget(D, "setfpscap") or (rawget(D, "set_fps_cap"))
    else b
  if type(b) == "function" then
    pcall(b, 9999)
  end
end
local z, C, b, D, R, n, Q, u, p = (function()
  local o, _ = game:GetService("Players"), game:GetService("UserInputService")
  local U = _.TouchEnabled
  pcall(function()
    local y = _:GetPlatform()
    U = _.TouchEnabled
      and (y == Enum.Platform.Android or y == Enum.Platform.IOS or not _.MouseEnabled)
  end)
  return o,
    _,
    game:GetService("TweenService"),
    game:GetService("RunService"),
    game:GetService("ReplicatedStorage"),
    game:GetService("Lighting"),
    game:GetService("HttpService"),
    o.LocalPlayer,
    U
end)()
local o = "unknown"
do
  local _ = _G
  pcall(function()
    local U = type(getgenv)
    if U == "function" then
      _ = getgenv()
    end
  end)
  if type(_) ~= "table" then
    _ = _G
  end
  local U = rawget(_, "identifyexecutor")
    or (rawget(_, "getexecutorname"))
    or type(_G) == "table" and (rawget(_G, "identifyexecutor") or (rawget(_G, "getexecutorname")))
  if type(U) == "function" then
    pcall(function()
      local _ = U()
      if _ ~= nil then
        o = tostring(_)
      end
    end)
  end
end
_G.__AkatsukiWaveSafeMode = string.find(string.lower(o), "wave", 1, true) ~= nil
do
  local o = {
    "Akatsuki_Panel",
    "AkatsukiHub",
    "AKATSUKI_Panel",
    "DashEffectGui",
    "AkatsukiAutoGrabBar",
    "AkatsukiLaggerGUI",
    "AkatsukiBypassGUI",
    "AkatsukiMobileUI",
    "AkatsukiEnemyWidget",
  }
  pcall(function()
    local _ = _G.AkatsukiBypass
    if _ then
      if _.Stop then
        _.Stop()
      else
        if _.SetAutoOnSteal then
          _.SetAutoOnSteal(false)
        end
        if _.SetBypass then
          _.SetBypass(false)
        end
      end
    end
  end)
  pcall(function()
    local _ = _G.AkatsukiLagger
    if _ then
      if _.Stop then
        _.Stop()
      else
        if _.SetEnabled then
          _.SetEnabled(false)
        end
        if _.SetLowEndEnabled then
          _.SetLowEndEnabled(false)
        end
      end
    end
  end)
  if _G.__AKATSUKI_STATE then
    _G.__AKATSUKI_STATE.alive = false
    pcall(function()
      for _, _ in ipairs(_G.__AKATSUKI_STATE.stoppers or {}) do
        pcall(_)
      end
      for _, _ in ipairs(_G.__AKATSUKI_STATE.conns or {}) do
        pcall(function()
          _:Disconnect()
        end)
      end
    end)
  end
  _G.__AKATSUKI_STATE = nil
  _G.__AkatsukiTrackConn = nil
  _G.__AkatsukiTrackStopper = nil
  pcall(function()
    if _G.__speedBoostConn then
      _G.__speedBoostConn:Disconnect()
      _G.__speedBoostConn = nil
    end
  end)
  pcall(function()
    if _G.__stopSpeedBoost then
      _G.__stopSpeedBoost()
    end
  end)
  pcall(function()
    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
  end)
  pcall(function()
    local _, U = ipairs, { game:GetService("CoreGui"), u.PlayerGui }
    for y, H in _(U) do
      for _, _ in ipairs(o) do
        while true do
          y = H:FindFirstChild(_)
          if not y then
            break
          end
          y:Destroy()
        end
      end
    end
  end)
  pcall(function()
    for o, _ in ipairs(z:GetPlayers()) do
      o = _.Character
      if o then
        for _, _ in ipairs(o:GetChildren()) do
          for o, o in ipairs(_:GetChildren()) do
            if
              o.Name == "GreenDuelsBB"
              or o.Name == "AkatsukiSpeedBill"
              or o.Name == "AkatsukiHubOverhead"
              or o.Name == "AkatsukiAimbotBodyLock"
              or o.Name == "AkatsukiAimbotBodyAttachment"
              or o.Name == "AkatsukiTPBatMarkerBodyLock"
              or o.Name == "AkatsukiTPBatMarkerAttachment"
            then
              o:Destroy()
            end
          end
        end
      end
    end
  end)
  _G.__AKATSUKI_STATE = { conns = {}, stoppers = {}, alive = true }
  function _G.__AkatsukiTrackConn(o)
    if o then
      table.insert(_G.__AKATSUKI_STATE.conns, o)
    end
    return o
  end
  function _G.__AkatsukiTrackStopper(o)
    if o then
      table.insert(_G.__AKATSUKI_STATE.stoppers, o)
    end
  end
  _G.__AkatsukiResetHooks = {}
  function _G.__AkatsukiOnNewInstance(o)
    if o then
      table.insert(_G.__AkatsukiResetHooks, o)
    end
  end
end
local o, _, U =
  _G.__AKATSUKI_STATE, {}, {
    "__AkatsukiTPBatApplyMarkerBodyLock",
    "__AkatsukiTPBatClearMarkerBodyLock",
    "__AkatsukiTPBatIsInsideMap",
    "__AkatsukiTPBatGetMarkerCFrame",
    "__AkatsukiTPBatTrackTarget",
    "__AkatsukiTPBatClearMarkerTracking",
    "__AkatsukiTPBatForceMarker",
    "__AkatsukiUpdateBatVersionButton",
    "__AkatsukiRefreshVisibleTPBatConfig",
    "__tpBatV2DistanceInput",
    "__batVersionPill",
    "AkatsukiAutoBat",
  }
for y, y in ipairs(U) do
  rawset(_G, y, nil)
end
do
  local y, H = {}
  local function a()
    if H then
      return
    end
    H = D.Heartbeat:Connect(function()
      local h = os.clock() + 8.0E-4
      while y[1] and os.clock() < h do
        local h = y[1]
        if h.cancelled or h["continue"] and not h["continue"]() then
          table.remove(y, 1)
        else
          local f = h.pending[#h.pending]
          if not f then
            table.remove(y, 1)
          else
            h.pending[#h.pending] = nil
            pcall(h.apply, f)
            local J, L = pcall(function()
              return f:GetChildren()
            end)
            if J then
              for f, f in ipairs(L) do
                h.pending[#h.pending + 1] = f
              end
            end
            if y[2] then
              table.remove(y, 1)
              y[#y + 1] = h
            end
          end
        end
      end
      if not y[1] then
        H:Disconnect()
        H = nil
      end
    end)
    _G.__AkatsukiTrackConn(H)
  end
  function _G.__AkatsukiWalkDescendantsBatched(h, f, J)
    local L = { pending = {}, apply = f, ["continue"] = J, cancelled = false }
    for f, O in ipairs((if typeof(h) == "Instance" then { h } else h) or {}) do
      if O then
        f, J = pcall(function()
          return O:GetChildren()
        end)
        if f then
          for h, h in ipairs(J) do
            L.pending[#L.pending + 1] = h
          end
        end
      end
    end
    y[#y + 1] = L
    a()
    return function()
      L.cancelled = true
    end
  end
  _G.__AkatsukiTrackStopper(function()
    for a, a in ipairs(y) do
      a.cancelled = true
    end
    y = {}
    if H then
      H:Disconnect()
      H = nil
    end
  end)
end
do
  local y, H = false, false
  _G.__AkatsukiAntiDieGuiEnabled = nil
  local a, h = {}
  local function f(J, L)
    local O = a[J]
    if O then
      if O.healthConn then
        pcall(function()
          O.healthConn:Disconnect()
        end)
      end
      if O.diedConn then
        pcall(function()
          O.diedConn:Disconnect()
        end)
      end
      if O.cleanupConn then
        pcall(function()
          O.cleanupConn:Disconnect()
        end)
      end
      a[J] = nil
    end
    if L and J and J.Parent then
      pcall(function()
        local L = J:FindFirstChildOfClass("Humanoid")
        if L then
          L.BreakJointsOnDeath = true
          L:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
      end)
    end
  end
  local function J(L)
    if not L or not L.Parent then
      return
    end
    local O = L:FindFirstChildOfClass("Humanoid")
    if not O then
      return
    end
    f(L, false)
    O.BreakJointsOnDeath = false
    O:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    local i
    i = {
      humanoid = O,
      healthConn = O:GetPropertyChangedSignal("Health"):Connect(function()
        if y and a[L] == i and O.Health <= 0 then
          O.Health = O.MaxHealth
        end
      end),
      diedConn = O.Died:Connect(function()
        task.defer(function()
          if y and a[L] == i and O and O.Parent then
            O.BreakJointsOnDeath = false
            O:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            O.Health = O.MaxHealth
          end
        end)
      end),
      cleanupConn = L.AncestryChanged:Connect(function()
        if not L.Parent then
          f(L, false)
        end
      end),
    }
    a[L] = i
  end
  local function L(O)
    O = O == true
    if O == y then
      return
    end
    y = O
    if O then
      local O = h
      if not O then
        h = u.CharacterAdded:Connect(function(i)
          task.wait(0.2)
          if y and i and i.Parent then
            J(i)
          end
        end)
      end
      O = u.Character
      if O and O.Parent and not a[O] then
        J(O)
      end
    else
      for O in pairs(a) do
        f(O, true)
      end
    end
  end
  local f = { toggle = false, autobat = false }
  local function O()
    if H then
      return
    end
    local i = f.toggle
    L(
      (if _G.__AkatsukiAntiDieGuiEnabled then _G.__AkatsukiAntiDieGuiEnabled() == true else i)
        or f.autobat
    )
  end
  function _G.__AkatsukiAntiDieSource(i, S)
    if H or f[i] == nil then
      return
    end
    f[i] = S == true
    O()
  end
  function _G.__AkatsukiAntiDieSet(i)
    _G.__AkatsukiAntiDieSource("autobat", i)
  end
  function _G.__AkatsukiAntiDieIsEnabled()
    return y
  end
  _G.__AkatsukiTrackStopper(function()
    H = true
    f.toggle = false
    f.autobat = false
    L(false)
  end)
  local f, i = false, L
  L = function(L)
    i(L)
    if h and not f then
      f = true
      _G.__AkatsukiTrackConn(h)
    end
  end
  _G.__AkatsukiTrackConn(D.Heartbeat:Connect(function()
    if H then
      return
    end
    O()
    if not y then
      return
    end
    local y = u.Character
    local H = y and y.Parent and (y:FindFirstChildOfClass("Humanoid"))
    if not H then
      return
    end
    local h = a[y]
    if not h or h.humanoid ~= H then
      J(y)
    end
    if H.BreakJointsOnDeath then
      H.BreakJointsOnDeath = false
    end
    if H:GetStateEnabled(Enum.HumanoidStateType.Dead) then
      H:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
    if H.Health <= 0 then
      H.Health = H.MaxHealth
    end
  end))
end
FeatureToggles = FeatureToggles or {}
local y, H, a, h, f =
  {}, { Aimbot = true, ["Lagger Aimbot"] = true, Autoplay = true, Lagger = true }, {
    Aimbot = true,
    Drop = true,
    ["TP Down"] = true,
    Autoplay = true,
    ["ESP Players"] = true,
    ["Player Tracers"] = true,
  }, {}, {}
for J, L in pairs(a) do
  h[J] = false
  f[J] = true
end
if featureName == "Toggle UI" then
  bindPill.Visible = true
  bindPill.Position = UDim2.new(1, -48, 0.5, -10)
end
local J, L, O, i, S, Z, Y, j, e, q, K, G, I, F, k, E, l, N =
  {
    NormalBoost = 59,
    NormalSteal = 29,
    LaggerBoost = 40,
    LaggerSteal = 20,
    DesyncBoost = 59,
    DesyncSteal = 29,
    BypassPower = 300000,
    BypassDepth = 296,
    MobileButtonScale = 1,
    FOV = 90,
    StretchIntensity = 0.75,
    CypherAimbotApproachSpeed = 55,
    AutoTPDownHeight = 20,
  }, {}, { Radius = 65, Duration = 1.3 }, "v1", "V1", "Normal", 1, 59, 30, 40, false, "v1", false, Vector3.new(0, 0, 0), {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true,
    [Enum.KeyCode.Right] = true,
  }, {
    SelectNormalMode = nil,
    SelectLaggerMode = nil,
    Drop = nil,
    Autoplay = nil,
    ["Toggle UI"] = nil,
    Aimbot = nil,
    ["Anti Bat"] = nil,
    ["Carry Speed"] = nil,
    BypassToggle = nil,
    BypassAuto = nil,
    FuckerToggle = nil,
  }
local m, s, M, d, c, T, W, w, r, x = {}, {}, {}, {}, false, FeaturePostToggle or {}
_G = _G or {}
_G.__AkatsukiDropMode = _G.__AkatsukiDropMode == "Jump Drop" and "Jump Drop" or "Stand Drop"
_G._AkatsukiHub_UI_Data = _G._AkatsukiHub_UI_Data or {}
local g, B = {}, {}
_G.__AkatsukiButtonsSize = 1
_G.__AkatsukiGuiPositionResetters = {}
_G.__AkatsukiResetButtonPositions = nil
_G.__AkatsukiGuiPositionsReset = false
function _G.__AkatsukiRoundPanelBackground(t, X)
  local A = Instance.new("CanvasGroup")
  A.Name = "RoundedBackgroundMask"
  A.Size = UDim2.fromScale(1, 1)
  A.Position = UDim2.fromOffset(0, 0)
  A.BackgroundTransparency = 1
  A.BorderSizePixel = 0
  A.GroupTransparency = 0
  A.ZIndex = t.ZIndex
  A.Parent = X
  local v = X:FindFirstChildOfClass("UICorner")
  Instance.new("UICorner", A).CornerRadius = v and v.CornerRadius or (UDim.new(0, 16))
  X = t:FindFirstChildOfClass("UICorner")
  if X then
    X:Destroy()
  end
  t.Parent = A
end
function _G.__AkatsukiFramePanelBackground(t, X, X)
  t.ScaleType = Enum.ScaleType.Crop
  if X == "Bypass" then
    t.ScaleType = Enum.ScaleType.Fit
    t.AnchorPoint = Vector2.new(0.5, 0.5)
    t.Size = UDim2.fromScale(1, 1)
    t.Position = UDim2.fromScale(0.5, 0.5)
  else
    t.AnchorPoint = Vector2.new(0, 0)
    t.Size = UDim2.fromScale(1, 1)
    t.Position = UDim2.fromScale(0, 0)
  end
end
function _G.__AkatsukiAddOriginalGui3Title(t, X)
  if t then
    t.Text = string.upper(tostring(X or "AKATSUKI"))
  end
end
local function t(X, A, v, V, P, zN, CN)
  local bN = workspace.CurrentCamera
  local DN = bN and bN.ViewportSize or (Vector2.new(1920, 1080))
  if DN.X <= 0 or DN.Y <= 0 then
    return A, V
  end
  CN = CN or 1
  P *= CN
  zN *= CN
  local CN, bN, RN, nN = -DN.X * X, DN.X * (1 - X) - P, -DN.Y * v, DN.Y * (1 - v) - zN
  return math.clamp(A, CN, if bN < CN then CN else bN),
    math.clamp(V, RN, if nN < RN then RN else nN)
end
local function X(A, v, V, P, zN, CN)
  local bN, DN = t(v, V, P, zN, A.Size.X.Offset, A.Size.Y.Offset, CN)
  A.Position = UDim2.new(v, bN, P, DN)
  return bN, DN
end
local function t()
  return false
end
local A = setmetatable({}, { __mode = "k" })
_G.__AkatsukiTrackConn(C.InputChanged:Connect(function(v)
  local V = A[v]
  if not V then
    return
  end
  if
    v.UserInputType ~= Enum.UserInputType.Touch
    and v.UserInputType ~= Enum.UserInputType.MouseMovement
  then
    return
  end
  for P, P in ipairs(V) do
    if (v.Position - P.tapStart).Magnitude > 12 then
      P.tapMoved = true
    end
  end
end))
_G.__AkatsukiTrackConn(C.InputEnded:Connect(function(v)
  local V = A[v]
  if not V then
    return
  end
  A[v] = nil
  for v, v in ipairs(V) do
    if not v.tapMoved and true then
      if
        not (
          v.scroll
          and v.scrollCanvasAtStart
          and math.abs(v.scroll.CanvasPosition.Y - v.scrollCanvasAtStart) > 5
        )
      then
        v.callback()
      end
    end
  end
end))
local function v(V, P)
  if t() then
    return
  end
  V.InputBegan:Connect(function(V)
    if
      V.UserInputType ~= Enum.UserInputType.Touch
      and V.UserInputType ~= Enum.UserInputType.MouseButton1
    then
      return
    end
    local zN, CN = Scroll, A[V]
    if not CN then
      CN = {}
      A[V] = CN
    end
    table.insert(CN, {
      tapStart = V.Position,
      tapMoved = false,
      scroll = zN,
      scrollCanvasAtStart = zN and zN.CanvasPosition.Y or nil,
      callback = P,
    })
  end)
end
local A = {
  ["245,250,255"] = Color3.fromRGB(16, 16, 19),
  ["235,245,255"] = Color3.fromRGB(24, 24, 28),
  ["210,230,250"] = Color3.fromRGB(38, 24, 28),
  ["190,220,250"] = Color3.fromRGB(68, 28, 34),
  ["140,190,240"] = Color3.fromRGB(112, 30, 38),
  ["80,160,255"] = Color3.fromRGB(205, 38, 50),
  ["50,110,190"] = Color3.fromRGB(238, 238, 242),
  ["80,130,200"] = Color3.fromRGB(255, 165, 172),
  ["40,80,150"] = Color3.fromRGB(225, 225, 230),
  ["30,90,200"] = Color3.fromRGB(225, 55, 65),
  ["60,120,200"] = Color3.fromRGB(210, 210, 216),
  ["100,140,200"] = Color3.fromRGB(198, 198, 204),
}
local function V(P, zN)
  local CN = string.format(
    "%d,%d,%d",
    math.floor(P.R * 255 + 0.5),
    math.floor(P.G * 255 + 0.5),
    math.floor(P.B * 255 + 0.5)
  )
  if A[CN] then
    return A[CN]
  end
  if P.B <= P.R + 0.05 or P.B < P.G then
    return P
  end
  CN = math.max(P.R, P.G, P.B)
  if zN == "TextColor3" then
    if CN >= 0.58 then
      return Color3.fromRGB(235, 235, 240)
    end
    return Color3.fromRGB(225, 70, 80)
  end
  if CN >= 0.68 then
    return Color3.fromRGB(225, 48, 60)
  end
  if CN >= 0.35 then
    return Color3.fromRGB(118, 30, 38)
  end
  return Color3.fromRGB(22, 22, 26)
end
local P, zN, CN, bN =
  { "BackgroundColor3", "BorderColor3" },
  { "BackgroundColor3", "TextColor3", "BorderColor3" },
  { "TextColor3", "TextStrokeColor3", "TextStrokeTransparency" },
  {
    [Enum.FontWeight.Thin] = Enum.FontWeight.ExtraLight,
    [Enum.FontWeight.ExtraLight] = Enum.FontWeight.Light,
    [Enum.FontWeight.Light] = Enum.FontWeight.Regular,
    [Enum.FontWeight.Regular] = Enum.FontWeight.Medium,
    [Enum.FontWeight.Medium] = Enum.FontWeight.SemiBold,
    [Enum.FontWeight.SemiBold] = Enum.FontWeight.Bold,
    [Enum.FontWeight.Bold] = Enum.FontWeight.ExtraBold,
  }
local function DN(RN)
  if not (RN:IsA("TextLabel") or (RN:IsA("TextButton")) or (RN:IsA("TextBox"))) then
    return
  end
  if
    RN:GetAttribute("AkatsukiSlightFontWeightApplied")
    or (RN:GetAttribute("AkatsukiSlightFontWeightPending"))
  then
    return
  end
  RN:SetAttribute("AkatsukiSlightFontWeightPending", true)
  task.defer(function()
    if not RN.Parent or (RN:GetAttribute("AkatsukiSlightFontWeightApplied")) then
      RN:SetAttribute("AkatsukiSlightFontWeightPending", nil)
      return
    end
    local nN = pcall(function()
      local QN = RN.FontFace
      local uN = bN[QN.Weight]
      if uN then
        RN.FontFace = Font.new(QN.Family, uN, QN.Style)
      end
    end)
    RN:SetAttribute("AkatsukiSlightFontWeightPending", nil)
    if nN then
      RN:SetAttribute("AkatsukiSlightFontWeightApplied", true)
    end
  end)
end
local bN
local RN = setmetatable({}, { __mode = "k" })
local function nN(QN)
  local uN = QN
  while uN and not uN:IsA("GuiButton") and not uN:GetAttribute("AkatsukiButtonThemeControl") do
    uN = uN.Parent
  end
  if not uN then
    return
  end
  uN = QN:IsA("UIStroke") and "Color"
    or QN:IsA("UIGradient") and "Color"
    or QN:IsA("GuiObject") and "BackgroundColor3"
  if not uN then
    return
  end
  local pN = RN[QN]
  if not pN then
    pN = {}
    RN[QN] = pN
    _G.__AkatsukiTrackConn(QN:GetPropertyChangedSignal(uN):Connect(function()
      nN(QN)
    end))
  end
  if pN.busy then
    return
  end
  local RN = QN[uN]
  if RN == pN.applied and pN.theme == _G.__AkatsukiGuiTheme then
    return
  end
  if RN ~= pN.applied then
    pN.original = RN
  end
  local oN = _G.__AkatsukiGuiTheme
  local function _N(UN)
    if oN ~= "GUI 2" and oN ~= "GUI 3" then
      return UN
    end
    local yN = math.max(UN.R, UN.G, UN.B)
    return Color3.fromRGB(14, 14, 17):Lerp(Color3.fromRGB(235, 52, 64), yN)
  end
  local UN = pN.original
  if QN:IsA("UIGradient") then
    if oN == "GUI 2" or oN == "GUI 3" then
      local yN = {}
      for HN, HN in ipairs(UN.Keypoints) do
        table.insert(yN, ColorSequenceKeypoint.new(HN.Time, _N(HN.Value)))
      end
      UN = (ColorSequence.new(yN))
    end
  else
    UN = (_N(UN))
  end
  pN.applied = UN
  pN.theme = oN
  if RN ~= UN then
    pN.busy = true
    QN[uN] = UN
    pN.busy = false
  end
end
bN = function(RN)
  if not RN then
    return
  end
  local QN
  if RN:IsA("TextLabel") or (RN:IsA("TextButton")) or (RN:IsA("TextBox")) then
    DN(RN)
    QN = zN
  else
    QN = if RN:IsA("GuiObject") then P else QN
  end
  if QN then
    for zN, uN in ipairs(QN) do
      zN = RN[uN]
      string.format(
        "%d,%d,%d",
        math.floor(zN.R * 255 + 0.5),
        math.floor(zN.G * 255 + 0.5),
        math.floor(zN.B * 255 + 0.5)
      )
      local pN = V(zN, uN)
      if pN ~= zN then
        RN[uN] = pN
      end
    end
  end
  if RN:IsA("UIStroke") then
    QN = RN.Color
    local V = string.format(
      "%d,%d,%d",
      math.floor(QN.R * 255 + 0.5),
      math.floor(QN.G * 255 + 0.5),
      math.floor(QN.B * 255 + 0.5)
    )
    if QN.B > QN.R + 0.05 and QN.B >= QN.G then
      RN.Color = Color3.fromRGB(92, 28, 34)
    elseif A[V] then
      RN.Color = A[V]
    end
  end
  if not _G.__AkatsukiModernGuiActive and not RN:GetAttribute("AkatsukiDarkPaletteWatched") then
    RN:SetAttribute("AkatsukiDarkPaletteWatched", true)
    local function A(V)
      _G.__AkatsukiTrackConn(RN:GetPropertyChangedSignal(V):Connect(function()
        bN(RN)
      end))
    end
    if RN:IsA("UIStroke") then
      A("Color")
    elseif RN:IsA("GuiObject") then
      for V, V in ipairs(P) do
        A(V)
      end
      if RN:IsA("TextLabel") or (RN:IsA("TextButton")) or (RN:IsA("TextBox")) then
        for V, V in ipairs(CN) do
          A(V)
        end
      end
    end
  end
  nN(RN)
end
_G.__AkatsukiThemeRoots = {}
local A = setmetatable({}, { __mode = "k" })
function _G.__AkatsukiRegisterThemeRoot(V)
  if not V then
    return
  end
  for P, P in ipairs(_G.__AkatsukiThemeRoots) do
    if P == V then
      return
    end
  end
  table.insert(_G.__AkatsukiThemeRoots, V)
  bN(V)
  if A[V] then
    A[V]()
  end
  A[V] = _G.__AkatsukiWalkDescendantsBatched(V, bN, function()
    return V.Parent ~= nil
  end)
  _G.__AkatsukiTrackConn(V.DescendantAdded:Connect(bN))
end
function _G.__AkatsukiApplyTheme()
  for V, V in ipairs(_G.__AkatsukiThemeRoots) do
    if V and V.Parent then
      bN(V)
      if A[V] then
        A[V]()
      end
      A[V] = _G.__AkatsukiWalkDescendantsBatched(V, bN, function()
        return V.Parent ~= nil
      end)
    end
  end
end
function _G.__AkatsukiAddUnifiedPanelShade(A, V, P)
  local zN = A and (A:FindFirstChild("UnifiedBackgroundShade"))
  if zN then
    zN:Destroy()
  end
  zN = A and (A:FindFirstChild("UnifiedPanelWhiteOutline"))
  if zN then
    zN:Destroy()
  end
  zN = A and (A:FindFirstChild("UnifiedPanelWhiteGlow"))
  if zN then
    zN:Destroy()
  end
  zN = Instance.new("Frame")
  zN.Name = "UnifiedBackgroundShade"
  zN.Size = UDim2.fromScale(1, 1)
  zN.Position = UDim2.fromScale(0, 0)
  zN.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  zN.BackgroundTransparency = 0.68
  zN.BorderSizePixel = 0
  zN.Active = false
  zN.ZIndex = P or 1
  zN.Parent = A
  Instance.new("UICorner", zN).CornerRadius = UDim.new(0, V or 16)
  P = Instance.new("UIGradient", zN)
  P.Rotation = 90
  P.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.28),
    NumberSequenceKeypoint.new(0.55, 0.42),
    NumberSequenceKeypoint.new(1, 0.56),
  })
  return zN
end
local A = {
  [Enum.UserInputType.Gamepad1] = true,
  [Enum.UserInputType.Gamepad2] = true,
  [Enum.UserInputType.Gamepad3] = true,
  [Enum.UserInputType.Gamepad4] = true,
  [Enum.UserInputType.Gamepad5] = true,
  [Enum.UserInputType.Gamepad6] = true,
  [Enum.UserInputType.Gamepad7] = true,
  [Enum.UserInputType.Gamepad8] = true,
}
local function V(P)
  return P
    and P.KeyCode
    and P.KeyCode ~= Enum.KeyCode.Unknown
    and (P.UserInputType == Enum.UserInputType.Keyboard or A[P.UserInputType])
end
local function P(zN)
  return zN
    and zN.UserInputType == Enum.UserInputType.Keyboard
    and zN.KeyCode == Enum.KeyCode.RightControl
end
local zN, CN = {}, { MB3 = "Mouse3" }
pcall(function()
  zN[Enum.UserInputType.MouseButton3] = "MB3"
end)
local function bN(RN)
  return RN and zN[RN.UserInputType] ~= nil
end
local function RN(nN)
  return zN[nN.UserInputType]
end
local function zN(nN)
  if not nN then
    return "-"
  end
  if type(nN) == "string" then
    return CN[nN] or nN
  end
  return tostring(nN):match("KeyCode%.(.+)") or (tostring(nN))
end
a = {
  ["Inf Jump"] = false,
  ["Anti Bat"] = false,
  ["TP Down"] = false,
  ["Auto TP Down"] = false,
  ["Anti Ragdoll"] = false,
  ["Ragdoll Counter"] = false,
  ["Medusa Counter"] = false,
  Aimbot = false,
  ["Lagger Aimbot"] = false,
  Autoplay = false,
  Drop = false,
  ["auto steal"] = false,
  ["ESP Players"] = false,
  ["Player Tracers"] = false,
  ["Show Buttons"] = false,
  ["Lock Buttons"] = false,
  ["Show FPS"] = false,
  ["FPS Boost"] = false,
  ["Anti Lag"] = false,
  Optimizer = true,
  Lagger = false,
  Bypass = false,
  ["Speed Boost"] = true,
  ["Toggle UI"] = true,
  ["Auto Steal Speed"] = false,
  ["Auto Carry Speed"] = false,
  ["Carry Speed"] = false,
  Unwalk = false,
  ["Harder Hit Anim"] = false,
  Animaciones = false,
  ["Custom FOV"] = false,
  ["Stretchz Res"] = false,
  ["Sky Changer"] = false,
  ["Skin Changer"] = false,
  ["Headless Visual"] = false,
  ["Korblox Visual"] = false,
  ["Anti Die"] = false,
}
for nN, QN in pairs(a) do
  y[nN] = QN
end
local nN, QN
local uN = 0
local function pN(oN)
  if not oN or oN == nN then
    return
  end
  pcall(writefile, "AkatsukiHub_UI_Config.txt", oN)
  nN = oN
end
local function oN()
  local _N = {}
  for UN, yN in pairs(y) do
    if not H[UN] then
      table.insert(_N, "T:" .. UN .. "=" .. tostring(yN))
    end
  end
  for UN, yN in pairs(h) do
    table.insert(_N, "S:" .. UN .. "=" .. tostring(yN))
  end
  for UN, yN in pairs(f) do
    table.insert(_N, "B:" .. UN .. "=" .. tostring(yN))
  end
  for UN, yN in pairs(J) do
    table.insert(_N, "V:" .. UN .. "=" .. tostring(yN))
  end
  for UN, yN in pairs(O) do
    table.insert(_N, "A:" .. UN .. "=" .. tostring(yN))
  end
  for UN, UN in ipairs(L) do
    table.insert(_N, "C:" .. UN.name .. "=" .. UN.boost .. "," .. UN.steal)
  end
  if _G.__AkatsukiHub_Anims then
    for UN, yN in pairs(_G.__AkatsukiHub_Anims) do
      table.insert(_N, "N:" .. UN .. "=" .. yN)
    end
  end
  table.insert(_N, "M:selectedMode=" .. Z)
  table.insert(_N, "M:optimizerMode=Normal")
  table.insert(_N, "M:autoplayMode=" .. (_G.__autoplayMode or "Full"))
  table.insert(_N, "M:skyIndex=" .. tostring(_G.__skyGetIndex and (_G.__skyGetIndex()) or 1))
  table.insert(_N, "M:skyMode=" .. tostring(_G.__AkatsukiSkyChangerMode or "blue"))
  table.insert(
    _N,
    "M:katanaIndex=" .. tostring(_G.__katanaGetIndex and (_G.__katanaGetIndex()) or 1)
  )
  table.insert(_N, "M:autoStealMode=" .. (i == "v2" and "v2" or "v1"))
  table.insert(_N, "M:carrySpeedMode=" .. (G or "v1"))
  table.insert(
    _N,
    "M:dropMode=" .. (_G.__AkatsukiDropMode == "Jump Drop" and "Jump Drop" or "Stand Drop")
  )
  table.insert(_N, "M:infJumpMode=" .. (_G.__AkatsukiInfJumpMode or "hold"))
  table.insert(_N, "M:panelVisible=" .. tostring(_G.__AkatsukiPanelVisible ~= false))
  table.insert(_N, "M:batVersion=" .. tostring(_G.__batVersion or 1))
  table.insert(_N, "M:skinChangerMode=" .. S)
  table.insert(_N, "M:buttonsSize=" .. tostring(_G.__AkatsukiButtonsSize or 1))
  table.insert(
    _N,
    "M:tpBatV2Distance=" .. tostring(math.clamp(tonumber(_G.__tpBatV2Distance) or 8, 0, 100))
  )
  if _G.__AkatsukiAnimationPreset then
    table.insert(_N, "M:animationPreset=" .. tostring(_G.__AkatsukiAnimationPreset))
  end
  table.insert(_N, "M:guiTheme=" .. tostring(_G.__AkatsukiGuiTheme or "GUI 1"))
  table.insert(_N, "M:themePrimary=" .. (_G.__AkatsukiThemePrimary or "BLACK"))
  table.insert(_N, "M:themeSecondary=" .. (_G.__AkatsukiThemeSecondary or "RED"))
  table.insert(_N, "M:autoGrabExpanded=" .. tostring(_G._AkatsukiHub_UI_AutoGrabExpanded ~= false))
  for UN, yN in pairs(E) do
    if yN then
      local HN = if type(yN) == "string"
        then yN
        else tostring(yN):match("KeyCode%.(.+)") or (tostring(yN))
      table.insert(_N, "K:" .. UN .. "=" .. HN)
    end
  end
  if _G._AkatsukiHub_UI_MenuPos then
    local UN = _G._AkatsukiHub_UI_MenuPos
    if UN.x and UN.y then
      table.insert(_N, "P:menuPos=" .. math.floor(UN.x) .. "," .. math.floor(UN.y))
    end
  end
  table.insert(_N, "M:introMusicIndex=" .. tostring(Y))
  table.insert(_N, "M:bgIndex=" .. tostring(_G._AkatsukiHub_UI_BgIndex or 1))
  if _G.__toggleBtn then
    table.insert(
      _N,
      "P:toggleBtn="
        .. math.floor(_G.__toggleBtn.Position.X.Offset)
        .. ","
        .. math.floor(_G.__toggleBtn.Position.Y.Offset)
    )
  end
  for UN, yN in pairs(g) do
    if yN.x and yN.y then
      table.insert(
        _N,
        "P:mobileBtn_"
          .. UN
          .. "="
          .. math.floor(yN.x)
          .. ","
          .. math.floor(yN.y)
          .. (if yN.xs and yN.ys then ":" .. yN.xs .. ":" .. yN.ys else "")
      )
    end
  end
  for UN, yN in pairs(B) do
    if yN.x and yN.y then
      table.insert(_N, "P:quickBtn_" .. UN .. "=" .. math.floor(yN.x) .. "," .. math.floor(yN.y))
    end
  end
  if _G._AkatsukiHub_UI_SpeedFramePos then
    local UN = _G._AkatsukiHub_UI_SpeedFramePos
    if UN.x and UN.y then
      table.insert(_N, "P:speedFrame=" .. math.floor(UN.x) .. "," .. math.floor(UN.y))
    end
  end
  if _G._AkatsukiHub_EnemyWidget_SaveHook then
    pcall(_G._AkatsukiHub_EnemyWidget_SaveHook)
  end
  if _G._AkatsukiHub_UI_EnemyWidgetPos then
    local UN = _G._AkatsukiHub_UI_EnemyWidgetPos
    if UN.x and UN.y then
      table.insert(_N, "P:enemyWidget=" .. math.floor(UN.x) .. "," .. math.floor(UN.y))
    end
  end
  if _G._AkatsukiHub_UI_AutoGrabBarPos then
    local UN = _G._AkatsukiHub_UI_AutoGrabBarPos
    if UN.x and UN.y then
      table.insert(_N, "P:autoGrabBar=" .. math.floor(UN.x) .. "," .. math.floor(UN.y))
    end
  end
  if _G._AkatsukiHub_UI_AutoGrabBarSize then
    table.insert(_N, "P:autoGrabBarSize=" .. tostring(_G._AkatsukiHub_UI_AutoGrabBarSize))
  end
  if _G._AkatsukiHub_UI_ModernMiniPos then
    local UN = _G._AkatsukiHub_UI_ModernMiniPos
    if UN.x and UN.y then
      table.insert(_N, "P:modernMini=" .. math.floor(UN.x) .. "," .. math.floor(UN.y))
    end
  end
  local UN = table.concat(_N, "\10")
  if UN == nN or UN == QN then
    return
  end
  QN = UN
  _G._AkatsukiHub_UI_Data = UN
  uN += 1
  local nN = uN
  task.delay(0.2, function()
    if nN ~= uN or QN ~= UN then
      return
    end
    QN = nil
    pN(UN)
  end)
end
_G.__AkatsukiTrackStopper(function()
  if QN then
    pN(QN)
    QN = nil
  end
end)
function FeatureToggles.BypassAuto()
  if _G.AkatsukiBypass and _G.AkatsukiBypass.SetBypass and _G.AkatsukiBypass.IsEnabled then
    local nN = _G.AkatsukiBypass.IsEnabled() == true
    pcall(_G.AkatsukiBypass.SetBypass, not nN)
    pcall(function()
      if _G.__syncBypassVisual then
        _G.__syncBypassVisual()
      end
    end)
  else
    if _G.__openBypassGUI then
      _G.__openBypassGUI()
    end
    task.spawn(function()
      for nN = 1, 20, 1 do
        task.wait(0.1)
        if _G.AkatsukiBypass and _G.AkatsukiBypass.SetBypass and _G.AkatsukiBypass.IsEnabled then
          break
        end
      end
      if _G.AkatsukiBypass and _G.AkatsukiBypass.SetBypass and _G.AkatsukiBypass.IsEnabled then
        local nN = _G.AkatsukiBypass.IsEnabled() == true
        pcall(_G.AkatsukiBypass.SetBypass, not nN)
      end
      pcall(function()
        if _G.__syncBypassVisual then
          _G.__syncBypassVisual()
        end
      end)
    end)
  end
end
local function nN(QN)
  local uN, pN = { "Aimbot", "TP Bat" }, false
  for _N, UN in ipairs(uN) do
    if UN ~= QN and UN ~= "TP Bat" and y[UN] then
      y[UN] = false
      _N = d[UN]
      if _N then
        pcall(_N, false)
      end
      if T[UN] then
        pcall(T[UN], false)
      end
      pN = true
    end
  end
  if pN then
    oN()
  end
end
function _G.__deactivateBatExclusive(QN)
  local uN, pN = { "Aimbot", "TP Bat" }, false
  for _N, UN in ipairs(uN) do
    if UN ~= QN and UN ~= "TP Bat" and y[UN] then
      y[UN] = false
      _N = d[UN]
      if _N then
        pcall(_N, false)
      end
      if T[UN] then
        pcall(T[UN], false)
      end
      pN = true
    end
  end
  if pN then
    oN()
  end
end
(function()
  local QN, uN = pcall(readfile, "AkatsukiHub_UI_Config.txt")
  local pN = if QN
      and uN
      and #uN > 0
    then uN
    else if _G._AkatsukiHub_UI_Data and #_G._AkatsukiHub_UI_Data > 0
      then _G._AkatsukiHub_UI_Data
      else nil
  if not pN then
    return
  end
  for _N in pN:gmatch("[^\10]+") do
    local pN, UN, yN = _N:sub(1, 2), _N:sub(3):match("([^=]+)=(.+)")
    if UN and yN then
      UN, yN = UN:match("^%s*(.-)%s*$"), yN:match("^%s*(.-)%s*$")
      if pN == "T:" and y[UN] ~= nil and not H[UN] then
        y[UN] = yN == "true"
      elseif pN == "S:" then
        h[UN] = yN == "true"
      elseif pN == "B:" then
        f[UN] = yN == "true"
      elseif pN == "V:" and J[UN] ~= nil then
        QN = tonumber(yN)
        if QN then
          J[UN] = QN
          if UN == "NormalBoost" then
            j = QN
          end
          if UN == "NormalSteal" then
            e = QN
          end
          if UN == "LaggerBoost" then
            q = QN
          end
        end
      elseif pN == "N:" then
        _G.__savedAnimations = _G.__savedAnimations or {}
        _G.__savedAnimations[UN] = yN
      elseif pN == "M:" then
        if UN == "introMusicIndex" then
          Y = tonumber(yN) or 2
        elseif UN == "bgIndex" then
          _G._AkatsukiHub_UI_BgIndex = tonumber(yN)
        elseif UN == "selectedMode" then
          _N = yN == "Normal" or yN == "Lagger" or yN == "Desync"
          if _N then
            Z = yN
          end
        elseif UN == "autoplayMode" then
          if yN == "Full" or yN == "Semi" then
            _G.__autoplayMode = yN
          end
        elseif UN == "skyIndex" then
          _G.__savedSkyIndex = tonumber(yN)
        elseif UN == "skyMode" then
          if yN == "day" or yN == "blue" or yN == "night" then
            _G.__AkatsukiSkyChangerMode = yN
          end
        elseif UN == "katanaIndex" then
          _G.__savedKatanaIndex = tonumber(yN)
        elseif UN == "autoStealMode" then
          if yN == "v3" then
            yN = "v1"
          end
          uN = yN == "v1" or yN == "v2"
          if uN then
            i = yN
          end
        elseif UN == "carrySpeedMode" then
          local H = yN == "v1" or yN == "v2"
          if H then
            G = yN
          end
        elseif UN == "optimizerMode" then
          if yN == "Normal" or yN == "Ultra" then
            _G.__optimizerMode = yN
          end
        elseif UN == "dropMode" then
          _G.__AkatsukiDropMode = yN == "Jump Drop" and "Jump Drop" or "Stand Drop"
        elseif UN == "infJumpMode" then
          if yN == "hold" or yN == "manual" then
            _G.__AkatsukiInfJumpMode = yN
          end
        elseif UN == "autoGrabExpanded" then
          _G._AkatsukiHub_UI_AutoGrabExpanded = yN == "true"
        elseif UN == "panelVisible" then
          _G.__AkatsukiPanelVisible = yN == "true"
          y["Toggle UI"] = _G.__AkatsukiPanelVisible
        elseif UN == "themePrimary" then
          if yN == "BLACK" or yN == "WHITE" then
            _G.__AkatsukiThemePrimary = yN
          end
        elseif UN == "themeSecondary" then
          if yN == "BLUE" or yN == "RED" or yN == "CONTRAST" then
            _G.__AkatsukiThemeSecondary = yN
          end
        elseif UN == "buttonsSize" then
          local H = tonumber(yN)
          if H and H == H and math.abs(H) < math.huge then
            _G.__AkatsukiButtonsSize = math.clamp(H, 0.5, 2)
          end
        elseif UN == "skinChangerMode" then
          S = (yN == "V2" or yN == "V3") and yN or "V1"
        elseif UN == "batVersion" then
          _G.__batVersion = tonumber(yN) == 2 and 2 or 1
          if _.versionPill then
            _.versionPill.Text = "V" .. tostring(_G.__batVersion or 1)
          end
        elseif UN == "tpBatV2Distance" then
          _G.__tpBatV2Distance = math.clamp(tonumber(yN) or 8, 0, 100)
        elseif UN == "animationPreset" then
          _G.__AkatsukiAnimationPreset = yN
        elseif UN == "guiTheme" then
          _G.__AkatsukiGuiTheme = "GUI 1"
        end
      elseif pN == "A:" and O[UN] ~= nil then
        local H = tonumber(yN)
        if H then
          O[UN] = H
        end
      elseif pN == "C:" then
        local H, h = yN:match("([^,]+),([^,]+)")
        if H and h then
          table.insert(L, { name = UN, boost = tonumber(H) or 59, steal = tonumber(h) or 29 })
        end
      elseif pN == "K:" then
        if CN[yN] then
          E[UN] = yN
        else
          local H, h = pcall(function()
            return Enum.KeyCode[yN]
          end)
          if H then
            E[UN] = h
          end
        end
      elseif pN == "P:" then
        if UN == "menuPos" then
          local H, h = yN:match("(-?%d+),(-?%d+)")
          if H and h then
            _G._AkatsukiHub_UI_MenuPos = { x = tonumber(H), y = tonumber(h) }
          end
        elseif UN == "toggleBtn" then
          local H, h = yN:match("(-?%d+),(-?%d+)")
          if H and h then
            _G._AkatsukiHub_UI_BtnPos = { x = tonumber(H), y = tonumber(h) }
          end
        elseif UN == "speedFrame" then
          local H, h = yN:match("(-?%d+),(-?%d+)")
          if H and h then
            _G._AkatsukiHub_UI_SpeedFramePos = { x = tonumber(H), y = tonumber(h) }
          end
        elseif UN == "enemyWidget" then
          local H, h = yN:match("(-?%d+),(-?%d+)")
          if H and h then
            _G._AkatsukiHub_UI_EnemyWidgetPos = { x = tonumber(H), y = tonumber(h) }
          end
        elseif UN == "autoGrabBar" then
          local H, h = yN:match("(-?%d+),(-?%d+)")
          if H and h then
            _G._AkatsukiHub_UI_AutoGrabBarPos = { x = tonumber(H), y = tonumber(h) }
          end
        elseif UN == "autoGrabBarSize" then
          local H = tonumber(yN)
          if H then
            _G._AkatsukiHub_UI_AutoGrabBarSize = H
          end
        elseif UN == "modernMini" then
          local H, h = yN:match("(-?%d+),(-?%d+)")
          if H and h then
            _G._AkatsukiHub_UI_ModernMiniPos = { x = tonumber(H), y = tonumber(h) }
          end
        else
          local H = UN:match("^quickBtn_(.+)$")
          if H then
            local h, f = yN:match("^(-?%d+),(-?%d+)")
            if h and f then
              B[H] = { x = tonumber(h), y = tonumber(f) }
            end
          else
            local H = UN:match("^mobileBtn_(.+)$")
            if H then
              local h, f = yN:match("^(-?%d+),(-?%d+)")
              if h and f then
                _G._AkatsukiHub_UI_MobileBtnPos = _G._AkatsukiHub_UI_MobileBtnPos or {}
                local Y, QN, uN =
                  { x = tonumber(h), y = tonumber(f) }, yN:match(":(-?%d+):(-?%d+)$")
                if QN and uN then
                  Y.xs = tonumber(QN)
                  Y.ys = tonumber(uN)
                end
                _G._AkatsukiHub_UI_MobileBtnPos[H] = Y
              end
            end
          end
        end
      end
    end
  end
end)()
y["Speed Boost"] = true
a = {
  "Speed Boost",
  "auto steal",
  "Auto Carry Speed",
  "Inf Jump",
  "Unwalk",
  "Auto TP Down",
  "Anti Ragdoll",
  "Ragdoll Counter",
  "Medusa Counter",
  "Anti Die",
  "Anti Lag",
  "Optimizer",
  "ESP Players",
  "Player Tracers",
  "Stretchz Res",
  "Custom FOV",
  "Sky Changer",
  "Headless Visual",
  "Korblox Visual",
  "Show Buttons",
  "Lock Buttons",
  "Skin Changer",
}
for H, H in ipairs(a) do
  E[H] = nil
end
oN()
if type(_G.__AkatsukiPanelVisible) == "boolean" then
  y["Toggle UI"] = _G.__AkatsukiPanelVisible
else
  _G.__AkatsukiPanelVisible = y["Toggle UI"] ~= false
  y["Toggle UI"] = _G.__AkatsukiPanelVisible
end
if i ~= "v1" and i ~= "v2" then
  i = "v1"
end
_G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
_G.__tpBatV2Distance = math.clamp(tonumber(_G.__tpBatV2Distance) or 8, 0, 100)
I = Z == "Lagger"
K = y["Carry Speed"]
y["TP Bat"] = false
y.Korblox = false
pcall(function()
  local H = u.Character
  if not H then
    return
  end
  for h, h in ipairs(H:GetChildren()) do
    if h.Name:find("^SkinChanger_") or h.Name == "Korblox_RightLeg" then
      h:Destroy()
    end
  end
  local h = { "RightUpperLeg", "RightLowerLeg", "RightFoot" }
  for f, Y in ipairs(h) do
    f = H:FindFirstChild(Y)
    if f and (f:IsA("BasePart")) then
      f.Transparency = 0
      f.CanCollide = true
    end
  end
end)
y.Autoplay = false
y.Lagger = false
g = _G._AkatsukiHub_UI_MobileBtnPos or {}
_G.__AkatsukiModernGuiActive = true
local H = game:GetService("CoreGui")
U = u.PlayerGui:FindFirstChild("AKATSUKI_Panel") or (H:FindFirstChild("AKATSUKI_Panel"))
if U then
  U:Destroy()
end
local h = Instance.new("ScreenGui")
h.Name = "AkatsukiHub"
h.Enabled = false
h.ResetOnSpawn = false
h.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
h.DisplayOrder = 9999999
h.IgnoreGuiInset = true
pcall(function()
  h.Parent = H
end)
if not h.Parent then
  h.Parent = u.PlayerGui
end
local H = workspace.CurrentCamera.ViewportSize
GUI_METRICS = {
  sectionPad = p and 4 or 6,
  sectionGap = p and 4 or 6,
  sectionHeaderH = p and 16 or 20,
  toggleH = p and 44 or 62,
  compactRowH = p and 30 or 36,
  compactCardH = p and 28 or 32,
  toggleTextSize = p and 9 or 10,
  bindW = p and 34 or 40,
  bindH = p and 16 or 20,
  bindTextSize = p and 8 or 9,
}
local f, Y, g =
  p and (math.clamp(math.floor(H.X * 0.42), 165, 205)) or (math.min(340, math.floor(H.X * 0.52))),
  p and (math.clamp(math.floor(H.Y * 0.52), 200, 310)) or (math.min(520, math.floor(H.Y * 0.8))),
  Instance.new("Frame")
g.Name = "Panel"
g.Active = true
g.Size = UDim2.new(0, f, 0, Y)
a = _G._AkatsukiHub_UI_MenuPos
if a then
  local QN, uN = X(g, 0, a.x, 0, a.y)
  g.Position = UDim2.new(0, QN, 0, uN)
else
  g.Position = UDim2.new(1, -f - 20, 0.5, -Y / 2)
end
g.BackgroundTransparency = 1
g.BorderSizePixel = 0
g.Visible = false
g.Parent = h
U = Instance.new("Frame")
U.Name = "LegacyHeaderStub"
U.BackgroundTransparency = 1
U.Visible = false
U.Parent = g
W = Instance.new("TextLabel")
W.BackgroundTransparency = 1
W.Visible = false
W.Parent = U
w = Instance.new("TextLabel")
w.BackgroundTransparency = 1
w.Visible = false
w.Parent = U
local QN = Instance.new("Frame")
QN.Name = "LegacyContentStub"
QN.BackgroundTransparency = 1
QN.Visible = false
QN.Parent = g
local uN, pN =
  { ((function()
    local _N
    pcall(function()
      _N = typeof(getcustomasset) == "function" and getcustomasset or typeof(getsynasset) == "function" and getsynasset
    end)
    if not _N or typeof(writefile) ~= "function" or typeof(isfile) ~= "function" then
      return "rbxassetid://114056083769059"
    end
    local UN = false
    pcall(function()
      UN = isfile("AkatsukiHub_8b7zve.png")
    end)
    if not UN then
      local UN, yN = pcall(function()
        return game:HttpGet("https://files.catbox.moe/8b7zve.png")
      end)
      if not UN or type(yN) ~= "string" or #yN < 100 then
        return "rbxassetid://114056083769059"
      end
      if not pcall(writefile, "AkatsukiHub_8b7zve.png", yN) then
        return "rbxassetid://114056083769059"
      end
    end
    local UN, yN = pcall(_N, "AkatsukiHub_8b7zve.png")
    if UN and type(yN) == "string" and yN ~= "" then
      return yN
    end
    return "rbxassetid://114056083769059"
  end)()) }, tonumber(_G._AkatsukiHub_UI_BgIndex) or 1
local _N, UN = type(pN) ~= "number" or pN < 1
if _N then
  UN = _N
else
  U = #uN
  UN = pN > U
end
if UN then
  pN = 1
end
local yN = Instance.new("ImageLabel")
yN.Name = "LegacyBackgroundStub"
yN.BackgroundTransparency = 1
yN.Image = uN[pN]
yN.Visible = false
yN.Parent = g
local HN = Instance.new("TextButton")
HN.Name = "LegacyBackgroundButtonStub"
HN.Visible = false
HN.Parent = g
do
  local aN, hN
  local fN, JN = false
  local function LN(ON)
    pcall(function()
      if _G.__AkatsukiPreserveOptimizerUI(ON) then
        return
      end
      local iN, SN = pcall(function()
        return ON:IsDescendantOf(game:GetService("Lighting"))
      end)
      if iN and SN then
        return
      end
      if
        ON:IsA("Sky")
        or (ON:IsA("Atmosphere"))
        or (ON:IsA("ColorCorrectionEffect"))
        or (ON:IsA("BloomEffect"))
        or (ON:IsA("BlurEffect"))
        or (ON:IsA("SunRaysEffect"))
        or (ON:IsA("DepthOfFieldEffect"))
      then
        return
      end
      iN, SN = pcall(function()
        local ZN = ON
        while ZN and ZN ~= workspace do
          if ZN.Name == "Headless_Headless" or (ZN.Name:find("^Korblox_")) then
            return true
          end
          ZN = ZN.Parent
        end
        return false
      end)
      if iN and SN then
        return
      end
      if ON:IsA("Accessory") or (ON:IsA("Hat")) then
        ON:Destroy()
      elseif
        ON:IsA("Shirt")
        or (ON:IsA("Pants"))
        or (ON:IsA("ShirtGraphic"))
        or (ON:IsA("BodyColors"))
        or (ON:IsA("CharacterMesh"))
      then
        ON:Destroy()
      elseif ON:IsA("BasePart") then
        ON.Material = Enum.Material.Plastic
        ON.Reflectance = 0
        ON.CastShadow = false
      elseif ON:IsA("Decal") or (ON:IsA("Texture")) then
        ON.Transparency = 1
      elseif
        ON:IsA("ParticleEmitter")
        or (ON:IsA("Trail"))
        or (ON:IsA("Beam"))
        or (ON:IsA("Fire"))
        or (ON:IsA("Smoke"))
        or (ON:IsA("Sparkles"))
      then
        ON.Enabled = false
      elseif ON:IsA("AnimationController") or (ON:IsA("Animator")) then
        iN = ON.Parent
        while iN and iN ~= workspace do
          if iN:IsA("Model") and (z:GetPlayerFromCharacter(iN)) then
            return
          end
          iN = iN.Parent
        end
        for iN, iN in ipairs(ON:GetPlayingAnimationTracks()) do
          pcall(function()
            iN:Stop(0)
          end)
        end
      end
    end)
  end
  local function ON()
    if JN then
      JN()
    end
    JN = _G.__AkatsukiWalkDescendantsBatched(workspace, LN, function()
      return fN
    end)
  end
  local function iN()
    if fN then
      return
    end
    fN = true
    if aN then
      aN:Disconnect()
    end
    aN = workspace.DescendantAdded:Connect(function(SN)
      if fN then
        LN(SN)
      end
    end)
    ON()
    if hN then
      hN:Disconnect()
    end
    hN = u.CharacterAdded:Connect(function(ON)
      task.wait(0.5)
      if fN then
        _G.__AkatsukiWalkDescendantsBatched(ON, LN, function()
          return fN
        end)
      end
    end)
  end
  local function LN()
    if not fN then
      return
    end
    fN = false
    if JN then
      JN()
      JN = nil
    end
    if aN then
      aN:Disconnect()
      aN = nil
    end
    if hN then
      hN:Disconnect()
      hN = nil
    end
  end
  _G.__refreshFPSBoost = iN
  _G.__stopFPSBoost = LN
  T["FPS Boost"] = function(aN)
    if aN then
      iN()
    else
      LN()
    end
  end
end
(function()
  local aN, hN, fN, JN, LN, ON, iN =
    false,
    0,
    {},
    setmetatable({}, { __mode = "k" }),
    {},
    setmetatable({}, { __mode = "k" }),
    setmetatable({}, { __mode = "k" })
  local SN
  local function ZN(YN, jN, eN)
    pcall(function()
      local qN = YN[jN]
      if qN == eN then
        return
      end
      YN[jN] = eN
      local eN = JN[YN]
      if not eN then
        eN = {}
        JN[YN] = eN
      end
      if not eN[jN] then
        eN[jN] = { value = qN }
      end
    end)
  end
  local function YN(jN)
    local eN = u.Character
    if eN and (jN == eN or (jN:IsDescendantOf(eN))) then
      return true
    end
    eN = jN
    while eN and eN ~= workspace do
      if eN:IsA("LayerCollector") or (eN:IsA("GuiObject")) or (eN:IsA("GuiBase2d")) then
        return true
      end
      local qN = eN.Name or ""
      if
        qN:match("^Akatsuki")
        or (qN:match("^__Akatsuki"))
        or (qN:match("^Akatsuki"))
        or (qN:match("^ESP_"))
        or (qN:match("^SkinChanger_"))
        or (qN:match("^Korblox_"))
        or qN == "Headless_Headless"
        or qN == "GreenDuelsBB"
        or qN == "PredictionSphere"
      then
        return true
      end
      eN = eN.Parent
    end
    if y["Sky Changer"] and (jN == n or (jN:IsDescendantOf(n))) then
      return true
    end
    return false
  end
  local function jN(eN)
    if ON[eN] then
      return
    end
    local qN = u.Character
    if qN and (eN:IsDescendantOf(qN)) then
      return
    end
    ON[eN] = true
    local qN = hN
    local KN, GN = pcall(function()
      return eN.AnimationPlayed:Connect(function(IN)
        if not aN or hN ~= qN then
          return
        end
        task.defer(function()
          if aN and hN == qN then
            pcall(function()
              IN:Stop(0)
            end)
          end
        end)
      end)
    end)
    if KN then
      table.insert(fN, GN)
    end
    pcall(function()
      for qN, qN in ipairs(eN:GetPlayingAnimationTracks()) do
        if qN.IsPlaying then
          iN[qN] = { animator = eN, time = qN.TimePosition, speed = qN.Speed }
          qN:Stop(0)
        end
      end
    end)
  end
  local function eN(qN)
    if not aN or (YN(qN)) then
      return
    end
    if qN:IsA("Terrain") then
      ZN(qN, "Decoration", false)
      ZN(qN, "WaterWaveSize", 0)
      ZN(qN, "WaterWaveSpeed", 0)
      ZN(qN, "WaterReflectance", 0)
      ZN(qN, "WaterTransparency", 1)
    end
    if qN:IsA("BasePart") then
      ZN(qN, "Material", Enum.Material.Plastic)
      ZN(qN, "MaterialVariant", "")
      ZN(qN, "Reflectance", 0)
      ZN(qN, "CastShadow", false)
      if qN:IsA("MeshPart") then
        ZN(qN, "TextureID", "")
        ZN(qN, "RenderFidelity", Enum.RenderFidelity.Performance)
        ZN(qN, "DoubleSided", false)
      elseif qN:IsA("PartOperation") then
        ZN(qN, "RenderFidelity", Enum.RenderFidelity.Performance)
      end
    elseif qN:IsA("SpecialMesh") then
      ZN(qN, "TextureId", "")
    elseif qN:IsA("SurfaceAppearance") then
      LN[qN] = true
      ZN(qN, "Parent", nil)
    elseif qN:IsA("Decal") or (qN:IsA("Texture")) then
      ZN(qN, "Transparency", 1)
      ZN(qN, "Texture", "")
    elseif qN:IsA("ParticleEmitter") then
      ZN(qN, "Enabled", false)
      ZN(qN, "Rate", 0)
      pcall(function()
        qN:Clear()
      end)
    elseif qN:IsA("Trail") then
      ZN(qN, "Enabled", false)
      pcall(function()
        qN:Clear()
      end)
    elseif
      qN:IsA("Beam")
      or (qN:IsA("Fire"))
      or (qN:IsA("Smoke"))
      or (qN:IsA("Sparkles"))
      or (qN:IsA("Light"))
      or (qN:IsA("PostEffect"))
      or (qN:IsA("Clouds"))
    then
      ZN(qN, "Enabled", false)
    elseif qN:IsA("Atmosphere") then
      ZN(qN, "Density", 0)
      ZN(qN, "Haze", 0)
      ZN(qN, "Glare", 0)
    elseif qN:IsA("Sky") then
      local YN = {
        "SkyboxBk",
        "SkyboxDn",
        "SkyboxFt",
        "SkyboxLf",
        "SkyboxRt",
        "SkyboxUp",
        "SunTextureId",
        "MoonTextureId",
      }
      for KN, KN in ipairs(YN) do
        ZN(qN, KN, "")
      end
      ZN(qN, "StarCount", 0)
      ZN(qN, "CelestialBodiesShown", false)
    elseif qN:IsA("Shirt") then
      ZN(qN, "ShirtTemplate", "")
    elseif qN:IsA("Pants") then
      ZN(qN, "PantsTemplate", "")
    elseif qN:IsA("ShirtGraphic") then
      ZN(qN, "Graphic", "")
    elseif qN:IsA("Animator") then
      jN(qN)
    end
  end
  local function YN()
    if y["Sky Changer"] then
      return
    end
    ZN(n, "GlobalShadows", false)
    ZN(n, "EnvironmentDiffuseScale", 0)
    ZN(n, "EnvironmentSpecularScale", 0)
    ZN(n, "FogStart", 0)
    ZN(n, "FogEnd", 10000000000)
  end
  local function jN()
    if not aN then
      return
    end
    aN = false
    hN += 1
    if SN then
      SN()
      SN = nil
    end
    for qN, qN in ipairs(fN) do
      pcall(function()
        qN:Disconnect()
      end)
    end
    fN = {}
    for qN, KN in pairs(JN) do
      for GN, IN in pairs(KN) do
        pcall(function()
          qN[GN] = IN.value
        end)
      end
    end
    JN, LN = setmetatable({}, { __mode = "k" }), {}
    ON = setmetatable({}, { __mode = "k" })
    for JN, LN in pairs(iN) do
      pcall(function()
        if LN.animator.Parent and not JN.IsPlaying then
          JN:Play(0, 1, LN.speed)
          JN.TimePosition = LN.time
        end
      end)
    end
    iN = setmetatable({}, { __mode = "k" })
  end
  T["Anti Lag"] = function(JN)
    if not JN then
      jN()
      return
    end
    if aN then
      return
    end
    aN = true
    hN += 1
    local LN = hN
    YN()
    pcall(function()
      ZN(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01)
    end)
    pcall(function()
      ZN(
        UserSettings():GetService("UserGameSettings"),
        "SavedQualityLevel",
        Enum.SavedQualitySetting.QualityLevel1
      )
    end)
    JN = { workspace, n }
    for ON, ON in ipairs(JN) do
      table.insert(
        fN,
        ON.DescendantAdded:Connect(function(JN)
          task.defer(function()
            if aN and hN == LN then
              pcall(eN, JN)
            end
          end)
        end)
      )
    end
    table.insert(
      fN,
      n.Changed:Connect(function(fN)
        if
          aN
          and (
            fN == "GlobalShadows"
            or fN == "EnvironmentDiffuseScale"
            or fN == "EnvironmentSpecularScale"
            or fN == "FogStart"
            or fN == "FogEnd"
          )
        then
          YN()
        end
      end)
    )
    if SN then
      SN()
    end
    SN = _G.__AkatsukiWalkDescendantsBatched({ workspace, n }, eN, function()
      return aN and hN == LN
    end)
  end
  _G.__AkatsukiTrackStopper(jN)
end)()
do
  local aN, hN, fN, JN = 0, 0, 0, 0
  local function LN()
    local ON, iN = pcall(function()
      return u:GetNetworkPing() * 1000
    end)
    if ON and type(iN) == "number" then
      return math.floor(iN)
    end
    return 0
  end
  local function ON()
    if W then
      W.Text = tostring(aN) .. " FPS"
    end
    if w then
      w.Text = tostring(hN) .. " MS"
    end
    if r then
      r.Text = tostring(aN) .. " FPS"
    end
    if x then
      x.Text = tostring(hN) .. " MS"
    end
  end
  fN, JN = 0, 0
  _G.__AkatsukiTrackConn(D.RenderStepped:Connect(function(iN)
    JN += 1
    fN += iN
    if fN >= 1 then
      aN, JN, fN = math.floor(JN / fN + 0.5), 0, 0
      hN = LN()
      ON()
    end
  end))
end
do
  local aN
  local hN, fN, JN = false
  local LN = _G._AkatsukiHub_UI_EnemyWidgetPos or { x = 140, y = -340 }
  function _G.__AkatsukiGuiPositionResetters.EnemyWidget()
    hN, LN = false, { x = 140, y = -340 }
    _G._AkatsukiHub_UI_EnemyWidgetPos = nil
    if aN and aN.Parent then
      aN.Position = UDim2.fromOffset(LN.x, LN.y)
    end
  end
  local ON, iN, SN = 0
  local ZN, YN, jN = false
  local eN, qN = ""
  function _G.__AkatsukiGetVisualEnemy()
    if iN and iN.Parent == z then
      return iN
    end
    return nil
  end
  local function KN()
    if aN and aN.Parent then
      return aN
    end
    aN = Instance.new("Frame", h)
    aN.Name = "AkatsukiEnemyWidget"
    aN.Size = UDim2.new(0, 140, 0, 80)
    aN.Position = UDim2.new(0, LN.x, 0, LN.y)
    _G.__enemyWidget = aN
    _G.__AkatsukiRegisterThemeRoot(aN)
    aN.BackgroundTransparency = 0.15
    aN.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    aN.ZIndex = 600
    aN.Visible = false
    Instance.new("UICorner", aN).CornerRadius = UDim.new(0, 8)
    local GN = Instance.new("UIStroke", aN)
    GN.Color = Color3.fromRGB(0, 0, 0)
    GN.Thickness = 1
    GN = Instance.new("TextLabel", aN)
    GN.Name = "EWTitle"
    GN.Size = UDim2.new(1, -10, 0, 14)
    GN.Position = UDim2.new(0, 8, 0, 4)
    GN.BackgroundTransparency = 1
    GN.Text = "RIVAL"
    GN.Font = Enum.Font.GothamBold
    GN.TextSize = 10
    GN.TextColor3 = Color3.fromRGB(180, 180, 180)
    GN.TextXAlignment = Enum.TextXAlignment.Left
    GN.ZIndex = 601
    GN = Instance.new("ImageLabel", aN)
    GN.Name = "EWAvatar"
    GN.Size = UDim2.new(0, 44, 0, 44)
    GN.Position = UDim2.new(0, 6, 0, 20)
    GN.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    GN.BorderSizePixel = 0
    GN.Image = ""
    GN.ZIndex = 601
    Instance.new("UICorner", GN).CornerRadius = UDim.new(0, 6)
    local IN = Instance.new("UIStroke", GN)
    IN.Color = Color3.fromRGB(180, 180, 180)
    IN.Thickness = 1
    GN = Instance.new("TextLabel", aN)
    GN.Name = "EWName"
    GN.Size = UDim2.new(1, -60, 0, 18)
    GN.Position = UDim2.new(0, 56, 0, 22)
    GN.BackgroundTransparency = 1
    GN.Text = "---"
    GN.Font = Enum.Font.GothamBold
    GN.TextSize = 13
    GN.TextColor3 = Color3.fromRGB(180, 180, 180)
    GN.TextXAlignment = Enum.TextXAlignment.Left
    GN.TextScaled = false
    IN = Instance.new("TextLabel", aN)
    IN.Name = "EWTimer"
    IN.Size = UDim2.new(1, -60, 0, 20)
    IN.Position = UDim2.new(0, 56, 0, 44)
    IN.BackgroundTransparency = 1
    IN.Text = ""
    IN.Font = Enum.Font.GothamBlack
    IN.TextSize = 16
    IN.TextColor3 = Color3.fromRGB(255, 221, 0)
    IN.TextXAlignment = Enum.TextXAlignment.Left
    IN.ZIndex = 601
    aN.InputBegan:Connect(function(GN)
      if
        GN.UserInputType == Enum.UserInputType.MouseButton1
        or GN.UserInputType == Enum.UserInputType.Touch
      then
        hN = true
        fN = GN.Position
        JN = aN.Position
        GN.Changed:Connect(function()
          if GN.UserInputState == Enum.UserInputState.End then
            hN = false
            LN.x = aN.Position.X.Offset
            LN.y = aN.Position.Y.Offset
            _G._AkatsukiHub_UI_EnemyWidgetPos = { x = LN.x, y = LN.y }
            oN()
          end
        end)
      end
    end)
    _G.__AkatsukiTrackConn(C.InputChanged:Connect(function(GN)
      if not hN then
        return
      end
      if
        GN.UserInputType ~= Enum.UserInputType.MouseMovement
        and GN.UserInputType ~= Enum.UserInputType.Touch
      then
        return
      end
      local hN, IN = GN.Position - fN, workspace.CurrentCamera.ViewportSize
      local fN, GN =
        math.clamp(JN.X.Offset + hN.X, 0, IN.X - aN.AbsoluteSize.X),
        math.clamp(JN.Y.Offset + hN.Y, 0, IN.Y - aN.AbsoluteSize.Y)
      aN.Position = UDim2.new(0, fN, 0, GN)
    end))
    return aN
  end
  local function hN(fN)
    local JN = KN():FindFirstChild("EWAvatar")
    if not JN then
      return
    end
    JN.Image = ""
    task.spawn(function()
      local GN, IN = pcall(function()
        return z:GetUserThumbnailAsync(
          fN,
          Enum.ThumbnailType.HeadShot,
          Enum.ThumbnailSize.Size48x48
        )
      end)
      if GN and IN and JN and JN.Parent then
        JN.Image = IN
      end
    end)
  end
  local function fN(JN)
    if JN and iN and JN.UserId == SN then
      return
    end
    if not JN and not iN then
      return
    end
    iN, ZN, jN = JN, false, nil
    local GN = KN()
    local IN = GN:FindFirstChild("EWName")
    YN = GN:FindFirstChild("EWTimer")
    if JN then
      SN = JN.UserId
      if IN then
        IN.Text = JN.Name
      end
      if YN then
        YN.Text = ""
        eN = ""
      end
      hN(JN.UserId)
      GN.Visible = true
      qN = true
    else
      SN = nil
      if IN then
        IN.Text = "---"
      end
      if YN then
        YN.Text = ""
        eN = ""
      end
      local hN = GN:FindFirstChild("EWAvatar")
      if hN then
        hN.Image = ""
      end
      GN.Visible = false
      qN = false
    end
  end
  local function hN(JN)
    local SN = ON
    if SN > 0 then
      ON = math.max(0, ON - JN)
    end
    SN = YN
    if not SN or not SN.Parent then
      return
    end
    if ON > 0 then
      JN = string.format("%.1fs", ON)
      if JN ~= eN then
        SN.Text = JN
        SN.TextColor3 = Color3.fromRGB(255, 221, 0)
        eN = JN
      end
    elseif eN ~= "" then
      SN.Text = ""
      eN = ""
    end
  end
  local JN, SN, YN = 0, p and 0.5 or 0.25, 0
  _G.__AkatsukiTrackConn(D.Heartbeat:Connect(function(eN)
    YN += eN or 0
    if iN and YN >= 0.2 then
      hN(YN)
      YN = 0
    else
      eN = not iN and YN >= 0.2
      if eN then
        YN = 0
      end
    end
    eN = os.clock()
    if eN - JN < SN then
      return
    end
    JN = eN
    eN = u.Character
    local hN = eN and (eN:FindFirstChild("HumanoidRootPart"))
    if not hN then
      return
    end
    local JN, SN, YN = hN.Position, math.huge
    for GN, IN in ipairs(z:GetPlayers()) do
      hN = IN ~= u and IN.Character
      if hN then
        eN = hN:FindFirstChild("HumanoidRootPart")
        if eN then
          GN = eN.Position
          local FN, kN, EN = JN.X - GN.X, JN.Y - GN.Y, JN.Z - GN.Z
          local GN = FN * FN + kN * kN + EN * EN
          if GN < SN then
            SN, YN = GN, IN
          end
        end
      end
    end
    if YN ~= iN then
      fN(YN)
    end
    SN = aN
    if SN and SN.Parent then
      hN = YN ~= nil
      if hN ~= qN then
        SN.Visible = hN
        qN = hN
      end
    end
    if iN then
      JN = SN and (SN:FindFirstChild("EWName"))
      if JN then
        if iN:GetAttribute("Stealing") == true then
          JN.TextColor3 = Color3.fromRGB(255, 60, 60)
        else
          JN.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
      end
    end
    if iN and iN.Character then
      eN = not jN or not jN.Parent
      if eN then
        jN = iN.Character:FindFirstChildOfClass("Humanoid")
      end
      if jN then
        SN = jN:GetState()
        YN = SN == Enum.HumanoidStateType.Physics
          or SN == Enum.HumanoidStateType.Ragdoll
          or SN == Enum.HumanoidStateType.FallingDown
        hN = YN and not ZN
        if hN then
          ON = 3
        else
          JN = YN and ON < 0.5
          if JN then
            ON = 0.5
          end
        end
        ZN = YN
      end
    end
  end))
  function _G._AkatsukiHub_EnemyWidget_SaveHook()
    if aN and aN.Parent then
      LN.x = aN.Position.X.Offset
      LN.y = aN.Position.Y.Offset
      _G._AkatsukiHub_UI_EnemyWidgetPos = { x = LN.x, y = LN.y }
    end
  end
  KN()
end
local function aN(hN, fN)
  local JN = Instance.new("Frame")
  JN.Name = (fN and (tostring(fN)) or "Section") .. "SectionStub"
  JN.BackgroundTransparency = 1
  JN.Visible = false
  JN.Parent = hN
  return JN
end
local function hN(fN, JN, LN, ON)
  local iN = Instance.new("Frame")
  iN.Name = tostring(LN or JN or "Toggle") .. "Stub"
  iN.BackgroundTransparency = 1
  iN.Visible = false
  iN.Parent = fN
  if ON then
    LN = Instance.new("TextButton")
    LN.Text = ""
    LN.Parent = iN
    JN = Instance.new("Frame")
    JN.BackgroundTransparency = 1
    JN.Parent = iN
    ON(JN)
  end
  return iN
end
local function fN(JN, LN, ON)
  local iN = Instance.new("Frame")
  iN.Name = tostring(ON or LN or "Toggle") .. "Stub"
  iN.BackgroundTransparency = 1
  iN.Visible = false
  iN.Parent = JN
  return iN
end
local function JN(LN)
  y["Speed Boost"] = true
  if _G.__refreshSpeedBoost then
    pcall(_G.__refreshSpeedBoost)
  end
  if Z == LN then
    if G == "v2" then
      K = not K
      y["Carry Speed"] = K
      if M["Carry Speed"] then
        M["Carry Speed"]()
      end
      pcall(function()
        if _G.__refreshSpeedBillboards then
          _G.__refreshSpeedBillboards()
        end
      end)
      oN()
    end
    return
  end
  if _G.__AkatsukiResetSpeedDirection then
    pcall(_G.__AkatsukiResetSpeedDirection)
  end
  Z, I = LN, if LN == "Lagger" then true else false
  for LN, LN in ipairs(_speedCardRefs) do
    if LN.updateVisual then
      pcall(LN.updateVisual)
    end
  end
  oN()
  pcall(function()
    if _G.__refreshSpeedBillboards then
      _G.__refreshSpeedBillboards()
    end
  end)
end
FeatureToggles = FeatureToggles or {}
function FeatureToggles.SelectNormalMode()
  JN("Normal")
end
function FeatureToggles.SelectLaggerMode()
  JN("Lagger")
end
function FeatureToggles.SelectDesyncMode()
  JN("Desync")
end
FeatureToggles["Toggle UI"] = function()
  if _G.__setPanelVisible then
    _G.__setPanelVisible(not g.Visible)
  else
    panelVisible = not g.Visible
    g.Visible = panelVisible
    y["Toggle UI"] = panelVisible
  end
  if M["Toggle UI"] then
    M["Toggle UI"]()
  end
  oN()
end
local function LN()
  if Z == "Lagger" or I then
    return J.LaggerBoost or q
  elseif Z == "Desync" then
    return J.DesyncBoost or j
  end
  for ON, ON in ipairs(L) do
    if Z == ON.name then
      return ON.boost
    end
  end
  return J.NormalBoost or j
end
local ON = { Enabled = false, Connection = nil, ResetCooldown = 0 }
local function iN()
  if ON.Connection then
    return
  end
  ON.Enabled = true
  ON.Connection = D.Heartbeat:Connect(function()
    if not y["Anti Ragdoll"] then
      return
    end
    local SN = u.Character
    if not SN then
      return
    end
    local ZN, YN = SN:FindFirstChildOfClass("Humanoid"), SN:FindFirstChild("HumanoidRootPart")
    if not ZN or not YN or ZN.Health <= 0 then
      return
    end
    if _G.dropActive then
      return
    end
    local jN, eN = ZN:GetState(), tick()
    if
      jN == Enum.HumanoidStateType.Physics
      or jN == Enum.HumanoidStateType.Ragdoll
      or jN == Enum.HumanoidStateType.FallingDown
    then
      if eN - ON.ResetCooldown > 0.15 then
        ON.ResetCooldown = eN
        pcall(function()
          ZN:ChangeState(Enum.HumanoidStateType.GettingUp)
          YN.Velocity = Vector3.zero
          YN.RotVelocity = Vector3.zero
          YN.AssemblyLinearVelocity = Vector3.zero
          YN.AssemblyAngularVelocity = Vector3.zero
          for YN, YN in ipairs(SN:GetDescendants()) do
            if YN:IsA("Motor6D") then
              YN.Enabled = true
            end
            if YN:IsA("Constraint") then
              YN.Enabled = true
            end
          end
          workspace.CurrentCamera.CameraSubject = ZN
          local SN = u.PlayerScripts:FindFirstChild("PlayerModule")
          if SN then
            local YN = require(SN:FindFirstChild("ControlModule"))
            if YN then
              YN:Enable()
            end
          end
          ZN.AutoRotate = true
          ZN.PlatformStand = false
          ZN.Sit = false
        end)
      end
    end
  end)
end
local function SN()
  ON.Enabled = false
  if ON.Connection then
    ON.Connection:Disconnect()
    ON.Connection = nil
  end
end
_G.__AkatsukiTrackStopper(SN)
T["Anti Ragdoll"] = function(ZN)
  if ZN then
    iN()
  else
    SN()
  end
end
_G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function(SN)
  task.wait(0.5)
  if y["Anti Ragdoll"] then
    if ON.Connection then
      ON.Connection:Disconnect()
      ON.Connection = nil
    end
    iN()
  end
end))
if y["Anti Ragdoll"] then
  iN()
end
do
  local ON = { Connection = nil, RagdollConnection = nil }
  local function iN()
    if ON.Connection then
      ON.Connection:Disconnect()
      ON.Connection = nil
    end
    if ON.RagdollConnection then
      ON.RagdollConnection:Disconnect()
      ON.RagdollConnection = nil
    end
  end
  local function SN()
    local ZN = u.Character
    local YN = ZN and (ZN:FindFirstChild("HumanoidRootPart"))
    if not YN then
      return
    end
    if ON.Connection then
      ON.Connection:Disconnect()
    end
    ON.Connection = D.Heartbeat:Connect(function()
      if not y["Anti Bat"] or not YN.Parent then
        return
      end
      local ZN = Vector3.new(YN.Velocity.X, 0, YN.Velocity.Z)
      YN.Velocity = Vector3.new(1000, YN.Velocity.Y, 1000)
      D.RenderStepped:Wait()
      if YN.Parent then
        YN.Velocity = Vector3.new(ZN.X, YN.Velocity.Y, ZN.Z)
      end
    end)
  end
  local function ZN()
    if ON.RagdollConnection then
      return
    end
    ON.RagdollConnection = D.Heartbeat:Connect(function()
      if not y["Anti Bat"] then
        return
      end
      local ON = u.Character
      if not ON then
        return
      end
      local YN, jN = ON:FindFirstChildOfClass("Humanoid"), ON:FindFirstChild("HumanoidRootPart")
      if YN then
        local eN = YN:GetState()
        if
          eN == Enum.HumanoidStateType.Physics
          or eN == Enum.HumanoidStateType.Ragdoll
          or eN == Enum.HumanoidStateType.FallingDown
        then
          YN:ChangeState(Enum.HumanoidStateType.Running)
          workspace.CurrentCamera.CameraSubject = YN
          pcall(function()
            local YN = u.PlayerScripts:FindFirstChild("PlayerModule")
            if YN then
              require(YN:FindFirstChild("ControlModule")):Enable()
            end
          end)
          if jN then
            jN.Velocity = Vector3.new(0, 0, 0)
            jN.RotVelocity = Vector3.new(0, 0, 0)
          end
        end
      end
      for YN, YN in ipairs(ON:GetDescendants()) do
        if YN:IsA("Motor6D") and not YN.Enabled then
          YN.Enabled = true
        end
      end
    end)
  end
  local function ON()
    iN()
    SN()
    ZN()
  end
  _G.__AkatsukiTrackStopper(iN)
  T["Anti Bat"] = function(SN)
    if SN then
      ON()
    else
      iN()
    end
  end
  _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function()
    task.wait(0.3)
    if y["Anti Bat"] then
      ON()
    end
  end))
  if y["Anti Bat"] then
    ON()
  end
end
local function ON()
  if Z == "Lagger" or I then
    return J.LaggerSteal or e
  elseif Z == "Desync" then
    return J.DesyncSteal or e
  end
  for I, I in ipairs(L) do
    if Z == I.name then
      return I.steal
    end
  end
  return J.NormalSteal or e
end
local function I(iN)
  return K or iN and y["Auto Carry Speed"]
end
do
  U = _G.__AkatsukiSpeedSpoofState
  if type(U) == "table" then
    U.enabled = false
  end
  local iN = _G.__AkatsukiS2SpeedState
  if type(iN) ~= "table" then
    iN = { hooked = false }
    _G.__AkatsukiS2SpeedState = iN
  end
  iN.enabled = false
  iN.root = nil
  iN.velChecked = setmetatable({}, { __mode = "k" })
  local function SN(ZN)
    iN.velChecked = setmetatable({}, { __mode = "k" })
    if not ZN then
      iN.root = nil
      return nil
    end
    local YN = ZN:WaitForChild("HumanoidRootPart", 5)
    if YN then
      iN.root = YN
      iN.velChecked[YN] = true
    end
    return YN
  end
  local function ZN(YN)
    if not YN then
      return
    end
    iN.root = YN
    iN.velChecked[YN] = true
    if iN.hooked then
      return
    end
    if
      type(getrawmetatable) ~= "function"
      or type(setreadonly) ~= "function"
      or type(newcclosure) ~= "function"
      or type(checkcaller) ~= "function"
    then
      return
    end
    pcall(function()
      local YN = getrawmetatable(game)
      if not YN then
        return
      end
      local jN = rawget(YN, "__index")
      if type(jN) ~= "function" and type(jN) ~= "table" then
        return
      end
      local eN = newcclosure(function(qN, KN)
        local GN = if type(jN) == "function" then (jN(qN, KN)) else jN[KN]
        if
          not checkcaller()
          and iN.velChecked[qN]
          and (KN == "AssemblyLinearVelocity" or KN == "Velocity")
          and typeof(GN) == "Vector3"
          and GN.Magnitude > 20
        then
          return GN.Unit * 20
        end
        return GN
      end)
      setreadonly(YN, false)
      YN.__index = eN
      iN.hooked = true
      setreadonly(YN, true)
    end)
  end
  local function YN()
    F = Vector3.zero
    iN.enabled = false
  end
  function _G.__AkatsukiResetSpeedDirection()
    F = Vector3.zero
    local jN = u.Character
    local eN, qN =
      jN and (jN:FindFirstChildOfClass("Humanoid")), jN and (jN:FindFirstChild("HumanoidRootPart"))
    if eN and qN and eN.MoveDirection.Magnitude <= 0.05 then
      qN.AssemblyLinearVelocity = Vector3.new(0, qN.AssemblyLinearVelocity.Y, 0)
    end
  end
  local function jN(eN)
    if not eN then
      return true
    end
    local qN = eN:GetState()
    return eN.PlatformStand
      or qN == Enum.HumanoidStateType.Physics
      or qN == Enum.HumanoidStateType.Ragdoll
      or qN == Enum.HumanoidStateType.FallingDown
  end
  local function eN(qN)
    if I(qN) then
      return ON()
    end
    return LN()
  end
  local function I()
    if _G.__speedBoostConn then
      _G.__speedBoostConn:Disconnect()
      _G.__speedBoostConn = nil
    end
    YN()
  end
  local function qN(KN, GN)
    local IN = u.Character
    local FN, kN =
      IN and (IN:FindFirstChildOfClass("Humanoid")), IN and (IN:FindFirstChild("HumanoidRootPart"))
    if not FN or not kN or FN.Health <= 0 then
      return
    end
    if type(GN) ~= "number" or GN ~= GN or GN <= 0 or GN == math.huge then
      return
    end
    FN = kN.AssemblyLinearVelocity.Y
    if _G._ZurichHub_MovementBlocked == true or _G._AkatsukiHub_MovementBlocked == true then
      kN.AssemblyLinearVelocity = Vector3.new(0, math.min(FN, 0), 0)
      return
    end
    if KN and KN.Magnitude > 0.05 then
      pcall(function()
        if kN.SetNetworkOwner then
          kN:SetNetworkOwner(u)
        end
      end)
      IN = KN.Unit
      kN.AssemblyLinearVelocity = Vector3.new(IN.X * GN, FN, IN.Z * GN)
    else
      kN.AssemblyLinearVelocity = Vector3.new(0, FN, 0)
    end
  end
  local function KN()
    I()
    _G.__speedBoostConn = D.RenderStepped:Connect(function()
      if not y["Speed Boost"] then
        return
      end
      local GN = u.Character
      local IN, FN =
        GN and (GN:FindFirstChildOfClass("Humanoid")),
        GN and (GN:FindFirstChild("HumanoidRootPart"))
      if not IN or not FN or IN.Health <= 0 then
        return
      end
      if
        y.Autoplay
        or y["TP Bat"]
        or y.Aimbot
        or y["Lagger Aimbot"]
        or _G.dropActive
        or _G.IsDropping
      then
        YN()
        return
      end
      if jN(IN) then
        F = Vector3.zero
        return
      end
      if iN.root ~= FN or not iN.velChecked[FN] then
        F = Vector3.zero
        SN(GN)
        ZN(FN)
      end
      iN.enabled = true
      FN = nil
      if IN.MoveDirection.Magnitude > 0 then
        F = IN.MoveDirection
        FN = IN.MoveDirection
      elseif F.Magnitude > 0 then
        for GN in pairs(k) do
          if C:IsKeyDown(GN) then
            FN = F
            break
          end
        end
      end
      qN(FN, tonumber((eN(u:GetAttribute("Stealing") == true))) or 16)
    end)
  end
  local function F()
    if not y["Speed Boost"] then
      return
    end
    local k = u.Character
    local GN = k and (k:FindFirstChildOfClass("Humanoid"))
    if not GN or GN.Health <= 0 or (jN(GN)) then
      return
    end
    qN(
      GN.MoveDirection.Magnitude > 0.05 and GN.MoveDirection or nil,
      eN(u:GetAttribute("Stealing") == true)
    )
  end
  local function k()
    y["Speed Boost"] = true
    KN()
  end
  _G.__refreshSpeedBoost = k
  _G.__stopSpeedBoost = I
  _G.__AkatsukiTrackStopper(function()
    y["Speed Boost"] = false
    I()
    iN.root = nil
    _G.__AkatsukiResetSpeedDirection = nil
  end)
  if u.Character then
    ZN((SN(u.Character)))
  end
  if y["Speed Boost"] then
    KN()
  end
  _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function(jN)
    task.wait(0.5)
    YN()
    local YN = jN:WaitForChild("HumanoidRootPart", 5)
    if YN then
      SN(jN)
      ZN(YN)
    end
    if y["Speed Boost"] then
      KN()
    end
  end))
  _G.__AkatsukiTrackConn(u.CharacterRemoving:Connect(function()
    I()
    iN.root = nil
    iN.velChecked = setmetatable({}, { __mode = "k" })
  end))
  FeatureToggles["Speed Boost"] = nil
  T["Speed Boost"] = function()
    y["Speed Boost"] = true
    KN()
  end
  FeatureToggles["Carry Speed"] = function()
    y["Carry Speed"] = not y["Carry Speed"]
    K = y["Carry Speed"]
    y["Speed Boost"] = true
    KN()
    F()
    if M["Carry Speed"] then
      M["Carry Speed"]()
    end
    pcall(function()
      if _G.__refreshSpeedBillboards then
        _G.__refreshSpeedBillboards()
      end
    end)
    oN()
  end
  T["Carry Speed"] = function(I)
    K = I
    if I or G == "v2" then
      y["Speed Boost"] = true
      KN()
      F()
    end
    pcall(function()
      if _G.__refreshSpeedBillboards then
        _G.__refreshSpeedBillboards()
      end
    end)
  end
  T["Auto Carry Speed"] = function(I)
    y["Speed Boost"] = true
    if not _G.__speedBoostConn then
      KN()
    end
    pcall(function()
      if _G.__refreshSpeedBillboards then
        _G.__refreshSpeedBillboards()
      end
    end)
  end
  local I, F, iN, SN =
    {}, setmetatable({}, { __mode = "k" }), ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 15)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(242, 242, 245)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 15)),
    }), ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 15)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(242, 242, 245)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 15)),
    })
  local function ZN(YN)
    if _G.__AkatsukiGuiTheme == "GUI 3" then
      return ColorSequence.new(Color3.fromRGB(12, 12, 15), Color3.fromRGB(242, 242, 245))
    end
    if YN then
      return _G.__AkatsukiGuiTheme == "GUI 2" and SN or iN
    end
    return ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 15)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(242, 242, 245)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 15)),
    })
  end
  local iN
  local function SN(YN)
    local jN = YN.Character
    if not jN then
      return "0"
    end
    local qN = jN:FindFirstChild("HumanoidRootPart")
    if not qN then
      return "0"
    end
    local KN = qN.AssemblyLinearVelocity
    qN = Vector3.new(KN.X, 0, KN.Z).Magnitude
    KN = qN < 0.5 and 0 or (math.floor(qN + 0.5))
    if YN == u then
      qN = u:GetAttribute("Stealing") == true
      local YN, GN = K or qN and y["Auto Carry Speed"], jN:FindFirstChildOfClass("Humanoid")
      return tostring(
        if y["Speed Boost"]
            and GN
            and GN.MoveDirection.Magnitude > 0.05
          then (math.floor(eN(qN) + 0.5))
          else KN
      ) .. " - " .. (YN and "CARRY" or "NORMAL")
    end
    return tostring(KN)
  end
  local function YN(jN, eN)
    if not jN or not jN.Parent then
      return
    end
    if I[jN] then
      return
    end
    I[jN] = true
    task.spawn(function()
      iN(jN, eN)
      I[jN] = nil
    end)
  end
  iN = function(I, iN)
    task.wait(0.3)
    local jN = I:FindFirstChild("Head")
    if not jN then
      return
    end
    local eN = jN:FindFirstChild("GreenDuelsBB")
    if eN then
      eN:Destroy()
    end
    eN = jN:FindFirstChild("AkatsukiSpeedBill")
    if eN then
      eN:Destroy()
    end
    eN = jN:FindFirstChild("AkatsukiHubOverhead")
    if eN then
      eN:Destroy()
    end
    eN = I:FindFirstChild("UpperTorso") or (I:FindFirstChild("HumanoidRootPart"))
    if eN then
      local qN = eN:FindFirstChild("GreenDuelsBB")
      if qN then
        qN:Destroy()
      end
    end
    eN = Instance.new("BillboardGui", jN)
    eN.Name = "GreenDuelsBB"
    eN:SetAttribute("AkatsukiThemeWorldAccent", true)
    eN.Size = iN and (UDim2.fromOffset(190, 60)) or (UDim2.fromOffset(130, 42))
    eN.StudsOffset = iN and (Vector3.new(0, 1.8, 0)) or (Vector3.new(0, 1.65, 0))
    eN.AlwaysOnTop = true
    eN.LightInfluence = 0
    eN.MaxDistance = 0
    local function qN(KN, GN)
      KN.Font = Enum.Font.GothamBlack
      KN.TextStrokeTransparency = 0
      if GN then
        KN.TextColor3 = Color3.fromRGB(242, 242, 245)
        local GN = Instance.new("UIStroke", KN)
        GN.Color = Color3.fromRGB(0, 0, 0)
        GN.Thickness = 1.75
        GN.Transparency = 0.2
        GN = Instance.new("UIGradient")
        GN.Name = "SpeedTextGradient"
        GN.Color = ZN(true)
        GN.Parent = KN
      else
        KN.TextColor3 = Color3.fromRGB(242, 242, 245)
        local GN = Instance.new("UIStroke", KN)
        GN.Color = Color3.fromRGB(0, 0, 0)
        GN.Thickness = 2.25
        GN.Transparency = 0.1
        GN = Instance.new("UIGradient")
        GN.Name = "SpeedTextGradient"
        GN.Color = ZN(false)
        GN.Parent = KN
      end
    end
    jN = Instance.new("TextLabel", eN)
    jN.Size = UDim2.new(1, 0, 0, iN and 28 or 22)
    jN.Position = UDim2.new(0, 0, 0, 0)
    jN.BackgroundTransparency = 1
    jN.Text = iN and ".gg/akatsukihub" or ""
    jN.Visible = iN
    jN.TextScaled = false
    jN.TextSize = iN and 19 or 15
    qN(jN, iN)
    jN.Font = Enum.Font.GothamBold
    jN.TextColor3 = Color3.fromRGB(78, 78, 84)
    local KN = jN:FindFirstChild("SpeedTextGradient")
    if KN then
      KN:Destroy()
    end
    jN = Instance.new("TextLabel", eN)
    jN.Name = "SpeedBillLbl"
    jN.Size = UDim2.new(1, 0, 0, iN and 29 or 20)
    jN.Position = UDim2.new(0, 0, 0, iN and 30 or 22)
    jN.BackgroundTransparency = 1
    KN = z:GetPlayerFromCharacter(I)
    jN.Text = KN and (SN(KN)) or "0"
    if KN then
      F[KN] = jN
    end
    jN.TextScaled = false
    jN.TextSize = iN and 22 or 16
    qN(jN, iN)
    jN.TextColor3 = Color3.fromRGB(78, 78, 84)
    iN = jN:FindFirstChild("SpeedTextGradient")
    if iN then
      iN:Destroy()
    end
    _G.__AkatsukiRegisterThemeRoot(eN)
  end
  local function I(iN)
    if iN.Character then
      YN(iN.Character, iN == u)
    end
    _G.__AkatsukiTrackConn(iN.CharacterAdded:Connect(function(jN)
      YN(jN, iN == u)
    end))
  end
  for iN, iN in ipairs(z:GetPlayers()) do
    if iN ~= u then
      I(iN)
    end
  end
  _G.__AkatsukiTrackConn(z.PlayerAdded:Connect(function(iN)
    I(iN)
  end))
  if u.Character then
    YN(u.Character, true)
  end
  _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function(I)
    K = y["Carry Speed"] == true
    task.spawn(function()
      YN(I, true)
      pcall(function()
        if _G.__refreshSpeedBillboards then
          _G.__refreshSpeedBillboards()
        end
      end)
    end)
  end))
  local I, iN, jN = 0, p and 0.5 or 0.25, {}
  _G.__AkatsukiTrackConn(D.Heartbeat:Connect(function(eN)
    I += eN or 0
    if I < iN then
      return
    end
    I = 0
    for I, iN in ipairs(z:GetPlayers()) do
      I = iN.Character
      if I then
        eN = F[iN]
        if not eN or not eN.Parent then
          F[iN] = nil
          YN(I, iN == u)
        else
          local I = SN(iN)
          if jN[iN.UserId] ~= I then
            eN.Text = I
            jN[iN.UserId] = I
          end
        end
      end
    end
  end))
  function _G.__refreshSpeedBillboards()
    for I, iN in ipairs(z:GetPlayers()) do
      I = iN.Character
      if not I then
        continue
      end
      local YN, jN =
        I:FindFirstChild("HumanoidRootPart") or (I:FindFirstChild("UpperTorso")),
        I:FindFirstChild("Head")
      local eN = I:FindFirstChild("UpperTorso") or YN
      if not YN and not jN then
        continue
      end
      I = jN and (jN:FindFirstChild("GreenDuelsBB")) or eN and (eN:FindFirstChild("GreenDuelsBB"))
      if not I then
        continue
      end
      YN = I:FindFirstChild("SpeedBillLbl")
      if not YN then
        continue
      end
      F[iN] = YN
      YN.Text = SN(iN)
      jN = ZN(iN == u)
      for F, F in ipairs(I:GetChildren()) do
        if F:IsA("TextLabel") then
          YN = F:FindFirstChild("SpeedTextGradient")
          if YN then
            YN.Color = jN
          end
        end
      end
    end
  end
  k()
  local I, F =
    {
      Vector3.new(-475.86, -7, 91.97),
      Vector3.new(-485.83, -7, 97.37),
      Vector3.new(-475.86, -7, 91.97),
      Vector3.new(-476.35, -7, 27.88),
      Vector3.new(-477.09, -7, 19.85),
    }, {
      Vector3.new(-475.84, -7, 28.81),
      Vector3.new(-486.04, -7, 23.32),
      Vector3.new(-475.51, -7, 29.01),
      Vector3.new(-476.43, -7, 91.61),
      Vector3.new(-476.27, -7, 98.86),
    }
  _G.__autoLeftWaypoints = I
  _G.__autoRightWaypoints = F
  local k, iN, SN, ZN, YN = false, "none", 1, false
  _G.__autoplayMode = _G.__autoplayMode or "Full"
  local function jN()
    local eN = workspace:FindFirstChild("Plots")
    if not eN then
      return "left"
    end
    for qN, KN in ipairs(eN:GetChildren()) do
      qN = KN:FindFirstChild("PlotSign")
      local eN = qN and (qN:FindFirstChild("YourBase"))
      if eN and eN.Enabled then
        qN = KN:FindFirstChild("AnimalTarget", true)
        local eN = qN and qN.Position
        if not eN then
          local qN = KN:FindFirstChild("DeliveryHitbox")
          eN = qN and qN.Position
        end
        if eN then
          if type(I) == "table" and type(F) == "table" and I[1] and F[1] then
            return (eN - I[1]).Magnitude <= (eN - F[1]).Magnitude and "right" or "left"
          end
        end
        do
          local eN
          if typeof(KN.GetPivot) == "function" then
            pcall(function()
              local qN = KN:GetPivot()
              if qN then
                eN = qN.Position
              end
            end)
          end
          if eN then
            return eN.Z >= 60 and "right" or "left"
          else
            return u
                and u.Character
                and (u.Character:FindFirstChild("HumanoidRootPart"))
                and u.Character:FindFirstChild("HumanoidRootPart").Position.Z >= 60
                and "right"
              or "left"
          end
        end
      end
    end
    return "left"
  end
  (function()
    if _G.__ZurichSetFullNoPlayerCollision then
      pcall(_G.__ZurichSetFullNoPlayerCollision, false)
    end
    local eN, qN, KN = false, {}, setmetatable({}, { __mode = "k" })
    local function GN(IN)
      if not IN:IsA("BasePart") then
        return
      end
      if KN[IN] == nil then
        KN[IN] = IN.CanCollide
      end
      if IN.CanCollide then
        IN.CanCollide = false
      end
    end
    local function IN(FN)
      if not FN then
        return
      end
      for kN, kN in ipairs(FN:GetDescendants()) do
        GN(kN)
      end
    end
    local function FN(kN)
      IN(kN)
      table.insert(
        qN,
        kN.DescendantAdded:Connect(function(kN)
          if eN then
            GN(kN)
          end
        end)
      )
    end
    local function GN(kN)
      if kN == u then
        return
      end
      if kN.Character then
        FN(kN.Character)
      end
      table.insert(
        qN,
        kN.CharacterAdded:Connect(function(kN)
          if eN then
            FN(kN)
          end
        end)
      )
    end
    local function FN()
      for kN, EN in pairs(KN) do
        if kN and kN.Parent then
          pcall(function()
            kN.CanCollide = EN
          end)
        end
      end
      KN = setmetatable({}, { __mode = "k" })
    end
    local function KN()
      if _G.dropActive or _G.IsDropping then
        return
      end
      local kN = u.Character
      local EN, lN =
        kN and (kN:FindFirstChild("HumanoidRootPart")),
        kN and (kN:FindFirstChildOfClass("Humanoid"))
      if not EN or not lN or lN.Health <= 0 then
        return
      end
      lN = EN.AssemblyLinearVelocity
      local NN, mN, sN =
        Vector3.new(lN.X, 0, lN.Z),
        EN.AssemblyAngularVelocity,
        y["TP Bat"] == true or y.Aimbot == true or y["Lagger Aimbot"] == true or k == true
      if (NN.Magnitude > 375 or math.abs(lN.Y) > 300 or mN.Magnitude > 110) and not sN then
        for EN, EN in ipairs(kN:GetDescendants()) do
          if EN:IsA("BasePart") then
            EN.AssemblyLinearVelocity = Vector3.zero
            EN.AssemblyAngularVelocity = Vector3.zero
          end
        end
      end
    end
    local function kN()
      if eN then
        return
      end
      eN = true
      for EN, EN in ipairs(z:GetPlayers()) do
        GN(EN)
      end
      table.insert(qN, z.PlayerAdded:Connect(GN))
      local GN = 0
      table.insert(
        qN,
        D.Stepped:Connect(function(EN, EN)
          if not eN then
            return
          end
          if p then
            GN += EN or 0
            if GN < 0.1 then
              return
            end
            GN = 0
          end
          for GN, GN in ipairs(z:GetPlayers()) do
            if GN ~= u and GN.Character then
              IN(GN.Character)
            end
          end
        end)
      )
    end
    local function GN()
      if not eN then
        return
      end
      eN = false
      for IN, IN in ipairs(qN) do
        pcall(function()
          IN:Disconnect()
        end)
      end
      qN = {}
      FN()
    end
    function _G.__ZurichSetFullNoPlayerCollision(qN)
      if qN then
        kN()
      else
        GN()
      end
    end
    _G.__setNoPlayerCollision = _G.__ZurichSetFullNoPlayerCollision
    function _G.__getNoPlayerCollision()
      return eN
    end
    function _.setCollisionsActive(eN)
      if eN then
        GN()
      else
        kN()
      end
    end
    _G.__AkatsukiTrackStopper(GN)
    _G.__AkatsukiTrackConn(D.PostSimulation:Connect(KN))
    kN()
  end)()
  local function eN(qN)
    if not qN or not qN:IsA("BasePart") then
      return
    end
    if qN.CanCollide and (qN.Transparency >= 0.9 or qN.LocalTransparencyModifier >= 0.9) then
      qN.CanCollide = false
    end
  end
  local function qN(KN, GN)
    if not KN then
      return
    end
    for IN, IN in ipairs(workspace:GetPartBoundsInRadius(KN, GN)) do
      eN(IN)
    end
  end
  _G.__killInvisibleNear = qN
  _G.__AkatsukiTrackConn(workspace.DescendantAdded:Connect(function(KN)
    if not (y["ESP Players"] or y["Player Tracers"] or y["Stretchz Res"]) then
      return
    end
    eN(KN)
  end))
  do
    local KN, GN, IN = 0, 0
    _G.__AkatsukiTrackConn(D.Heartbeat:Connect(function(FN)
      if not (y["ESP Players"] or y["Player Tracers"] or y["Stretchz Res"]) then
        return
      end
      KN += FN or 0
      GN += FN or 0
      if KN >= 2 then
        KN = 0
        FN = u.Character
        local KN = FN and (FN:FindFirstChild("HumanoidRootPart"))
        if KN then
          for kN, kN in ipairs(FN:GetDescendants()) do
            eN(kN)
          end
          local FN = KN.AssemblyLinearVelocity
          local kN = Vector3.new(FN.X, 0, FN.Z)
          FN = kN.Magnitude
          local EN = math.clamp(20 + FN * 0.2, 20, 40)
          qN(KN.Position, EN)
          if FN > 5 then
            qN(KN.Position + kN * 0.35, EN)
          end
        end
      end
      if GN >= 15 then
        GN = 0
        if IN then
          IN()
        end
        IN = _G.__AkatsukiWalkDescendantsBatched(workspace, eN, function()
          return y["ESP Players"] or y["Player Tracers"] or y["Stretchz Res"]
        end)
      end
    end))
  end
  _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function()
    awfLastRecovery = 0
  end))
  local eN = false
  local function qN(KN)
    if KN then
      if y["Auto Carry Speed"] then
        return
      end
      eN = true
    else
      if not eN then
        return
      end
      eN = false
    end
    y["Auto Carry Speed"] = KN
    local eN = d["Auto Carry Speed"]
    if eN then
      pcall(eN, KN)
    end
    eN = T["Auto Carry Speed"]
    if eN then
      pcall(eN, KN)
    end
    eN = M["Auto Carry Speed"]
    if eN then
      pcall(eN)
    end
  end
  local function eN(KN)
    y.Autoplay = KN
    local GN = d.Autoplay
    if GN then
      pcall(GN, KN)
      return
    end
    GN = M.Autoplay
    if GN then
      pcall(GN)
    end
  end
  local function KN(GN)
    if k then
      k, iN, SN, ZN = false, "none", 1, false
      if YN then
        YN:Disconnect()
        YN = nil
      end
      local IN = u.Character and (u.Character:FindFirstChild("HumanoidRootPart"))
      if IN then
        IN.Velocity = Vector3.new(0, IN.Velocity.Y, 0)
      end
    end
    qN(false)
    if GN then
      return
    end
    if y.Autoplay then
      eN(false)
      oN()
    end
  end
  _G.__stopAutoplay = KN
  _G.__AkatsukiTrackStopper(KN)
  local function eN()
    if k then
      KN(true)
    end
    nN()
    if y["TP Bat"] and _.controller then
      _.controller.SetEnabled(false)
    end
    iN, SN, ZN, k = jN(), 1, false, true
    qN(false)
    if not _G.__autoplayMode or _G.__autoplayMode ~= "Full" and _G.__autoplayMode ~= "Semi" then
      _G.__autoplayMode = "Full"
    end
    if YN then
      YN:Disconnect()
    end
    YN = D.Heartbeat:Connect(function(YN)
      if not k then
        return
      end
      local jN = iN == "left" and I or F
      local I, F = _G.__autoplayMode == "Semi" and 2 or #jN, jN[SN]
      if not F then
        return
      end
      jN = u:GetAttribute("Stealing")
      if jN == true then
        ZN = true
      end
      jN = SN > 2 and ZN
      qN(jN)
      local iN = u.Character
      if not iN then
        return
      end
      local GN = iN:FindFirstChild("HumanoidRootPart")
      if not GN then
        return
      end
      local IN, FN = GN.Position, Vector3.new(F.X, 0, F.Z)
      F = Vector3.new(IN.X, 0, IN.Z)
      IN = (FN - F).Magnitude
      if SN > 2 and not ZN then
        GN.Velocity = Vector3.new(0, GN.Velocity.Y, 0)
        return
      end
      if IN <= 1.1 then
        GN.Velocity = Vector3.new(0, GN.Velocity.Y, 0)
        if SN >= I then
          if u:GetAttribute("Stealing") ~= true then
            KN()
          end
          return
        end
        SN += 1
      else
        iN = FN - F
        iN = if iN.Magnitude > 0.001 then iN.Unit else iN
        local I = (jN and (ON()) or (LN())) + 1
        I = math.min(
          if IN < 1.5 then I * math.clamp(IN / 1.5, 0.6, 1) else I,
          IN / math.max(YN or 0.016666666666666666, 0.004166666666666667)
        )
        GN.Velocity = Vector3.new(iN.X * I, GN.Velocity.Y, iN.Z * I)
      end
    end)
  end
  _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function()
    task.wait(0.5)
    if k then
      eN()
    end
  end))
  T.Autoplay = function(I)
    if I then
      qN(true)
      _G.__checkAndAutoDrop(function()
        eN()
      end)
    else
      KN()
    end
  end
  function FeatureToggles.Autoplay()
    y.Autoplay = not y.Autoplay
    if y.Autoplay then
      qN(true)
      _G.__checkAndAutoDrop(function()
        eN()
      end)
    else
      KN()
    end
    if M.Autoplay then
      M.Autoplay()
    end
    oN()
  end
  if y.Autoplay then
    eN()
  end
  do
    local I, F, k, LN = 0, false, 0, true
    local function ON()
      k += 1
      F = false
    end
    _G.__AkatsukiTrackConn(u.CharacterRemoving:Connect(ON))
    _G.__AkatsukiTrackStopper(function()
      LN = false
      ON()
    end)
    local function iN()
      if not LN or _G.dropActive or _G.IsDropping then
        return
      end
      local LN = 0.1 - (os.clock() - I)
      if LN > 0 then
        if not F then
          F = true
          local SN, ZN = k, u.Character
          task.delay(LN, function()
            if SN ~= k or u.Character ~= ZN then
              return
            end
            F = false
            iN()
          end)
        end
        return
      end
      LN = u.Character
      if not LN then
        return
      end
      local F = LN:FindFirstChild("HumanoidRootPart")
      if not F then
        return
      end
      local k = LN:FindFirstChildOfClass("Humanoid")
      if not k or k.Health <= 0 or F.Anchored or k.Sit or k.SeatPart then
        return
      end
      I = os.clock()
      ON()
      local I, I = F.CFrame:ToEulerAnglesYXZ()
      pcall(function()
        F.CFrame = CFrame.new(F.Position.X, -7, F.Position.Z) * CFrame.Angles(0, I, 0)
        F.AssemblyLinearVelocity = Vector3.zero
      end)
    end
    _G.ExecuteTPDown = iN
    FeatureToggles["TP Down"] = iN
    do
      _G.__loadInstaReset = true
      local I, F, k = false
      local LN, ON = false, false
      local function SN()
        if I then
          return
        end
        I, LN, ON = true, false, false
        local ZN = u.Character
        local YN = ZN and (ZN:FindFirstChildOfClass("Humanoid"))
        if not ZN or not YN then
          I = false
          return
        end
        k = ZN
        F = task.spawn(function()
          local jN, eN = YN.HipHeight, 0
          while ZN and ZN.Parent and YN and YN.Health > 0 and u.Character == ZN and not ON do
            pcall(function()
              YN.HipHeight = 1.0E30
              YN.AutoRotate = true
              local qN = ZN:FindFirstChild("HumanoidRootPart")
              if qN then
                qN.CanCollide = false
              end
              for qN, qN in ipairs(ZN:GetChildren()) do
                if qN:IsA("BasePart") and qN.Name ~= "HumanoidRootPart" then
                  qN.CanCollide = false
                end
              end
            end)
            if not ZN.Parent or YN.Health <= 0 or u.Character ~= ZN then
              LN = true
              break
            end
            eN += 1
            if eN >= 40 then
              break
            end
            task.wait(0.05)
          end
          if not LN and ZN and ZN.Parent and YN.Health > 0 and u.Character == ZN then
            pcall(function()
              YN.Health = 0
            end)
            task.wait(0.1)
            eN = not ZN.Parent or YN.Health <= 0
            if eN then
              LN = true
            end
          end
          if not LN and ZN and ZN.Parent and YN then
            pcall(function()
              YN.HipHeight = jN
              local YN = ZN:FindFirstChild("HumanoidRootPart")
              if YN then
                YN.CanCollide = true
              end
              for YN, YN in ipairs(ZN:GetChildren()) do
                if YN:IsA("BasePart") and YN.Name ~= "HumanoidRootPart" then
                  YN.CanCollide = true
                end
              end
            end)
          end
          I, F, k, ON = false, nil, nil, false
        end)
      end
      local function ZN()
        ON = true
        if F then
          pcall(task.cancel, F)
          F = nil
        end
        I, k = false, nil
      end
      FeatureToggles["Insta Reset"] = SN
      _G.__AkatsukiInstaReset = SN
      _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function()
        ZN()
        LN, ON = false, false
      end))
      _G.__AkatsukiTrackConn(D.Heartbeat:Connect(function()
        if not F and not k and not I then
          return
        end
        local ON = u.Character
        local SN = ON and (ON:FindFirstChildOfClass("Humanoid"))
        if SN and SN.Health <= 0 or k and ON ~= k then
          LN = true
          if F then
            pcall(task.cancel, F)
            F = nil
          end
          I, k = false, nil
        end
      end))
      _G.__AkatsukiTrackStopper(function()
        ZN()
      end)
    end
    local I, F, k = 0, false
    local LN = RaycastParams.new()
    LN.FilterType = Enum.RaycastFilterType.Exclude
    pcall(function()
      LN.RespectCanCollide = true
    end)
    T["Auto TP Down"] = function(ON)
      if not ON then
        I, F, k = 0, false, nil
      end
    end
    _G.__AkatsukiTrackConn(D.Heartbeat:Connect(function(ON)
      if y["Auto TP Down"] ~= true then
        return
      end
      if _G.dropActive or _G.IsDropping then
        I = 0
        return
      end
      I += ON or 0
      if I < 0.1 then
        return
      end
      I = 0
      ON = u.Character
      local I, SN =
        ON and (ON:FindFirstChildOfClass("Humanoid")),
        ON and (ON:FindFirstChild("HumanoidRootPart"))
      if not SN or not I or I.Health <= 0 then
        F, k = false, nil
        return
      end
      if SN ~= k then
        k, F = SN, false
      end
      I = math.clamp(tonumber(J.AutoTPDownHeight) or 20, 1, 1000)
      LN.FilterDescendantsInstances = { ON }
      ON = workspace:Raycast(SN.Position, Vector3.new(0, -2048, 0), LN)
      local k = ON and (math.max(0, SN.Position.Y - ON.Position.Y)) or nil
      ON = k ~= nil and k >= I
      if ON and not F then
        F = true
        iN()
      elseif not ON then
        F = false
      end
    end))
  end
  do
    local I, F = false
    local function k()
      if I then
        return
      end
      local LN = u.Character
      if not LN then
        return
      end
      local ON = LN:FindFirstChild("HumanoidRootPart")
      if not ON then
        return
      end
      if F then
        F:Disconnect()
        F = nil
      end
      local iN = ON.Position.Y
      I = true
      _G.dropActive = true
      _G.IsDropping = true
      local ON = tick()
      F = D.Heartbeat:Connect(function()
        local SN = LN and (LN:FindFirstChild("HumanoidRootPart"))
        if not SN then
          F:Disconnect()
          F, I = nil, false
          _G.dropActive = false
          _G.IsDropping = false
          return
        end
        if tick() - ON >= 0.2 then
          F:Disconnect()
          F = nil
          local F, F = SN.CFrame:ToEulerAnglesYXZ()
          SN.CFrame = CFrame.new(SN.Position.X, iN, SN.Position.Z) * CFrame.Angles(0, F, 0)
          SN.AssemblyLinearVelocity = Vector3.zero
          pcall(function()
            SN.Velocity = Vector3.zero
          end)
          I = false
          _G.dropActive = false
          _G.IsDropping = false
          return
        end
        SN.AssemblyLinearVelocity =
          Vector3.new(SN.AssemblyLinearVelocity.X, 150, SN.AssemblyLinearVelocity.Z)
      end)
    end
    FeatureToggles.Drop = k
    _G.doDrop = k
  end
  function _G.__checkAndAutoDrop(I)
    c = true
    local function F()
      c = false
    end
    if u:GetAttribute("Stealing") then
      local k = u.Character
      if not k then
        if I then
          I()
        end
        F()
        return
      end
      local LN, ON = k:FindFirstChildOfClass("Humanoid"), k:FindFirstChild("HumanoidRootPart")
      if not LN or not ON then
        if I then
          I()
        end
        F()
        return
      end
      if FeatureToggles.Drop then
        FeatureToggles.Drop()
        k = tick()
        while u:GetAttribute("Stealing") and tick() - k < 5 do
          task.wait()
        end
      end
      if I then
        I()
      end
      F()
    else
      if I then
        I()
      end
      F()
    end
  end
end
local I, F = 0, { busy = false, data = {} }
do
  local k, LN, ON, iN = u, workspace:WaitForChild("Plots"), {}
  local SN, ZN, YN, jN = { caches = {}, connections = {} }, {}, {}
  local eN, qN, KN, GN = false, false, {}
  local IN, FN, kN =
    0, {
      AUTO_STEAL_ENABLED = false,
      HOLD_MIN = 1.3,
      HOLD_MAX = 2.6,
      ENTRY_DELAY = 0.01,
      COOLDOWN = 0.05,
      STEAL_RANGE = 6,
      PRIME_RANGE = math.clamp(tonumber(O.Radius) or 65, 10, 150),
    }, setmetatable({}, { __mode = "k" })
  local function EN(lN)
    if not lN then
      return nil
    end
    local NN = kN[lN]
    if
      NN
      and NN.Parent
      and (NN:IsA("ProximityPrompt"))
      and NN.ActionText
      and (NN.ActionText:find("Steal"))
    then
      return NN
    end
    NN = lN:FindFirstChild("PromptAttachment")
    for mN, mN in ipairs(NN and (NN:GetChildren()) or (lN:GetDescendants())) do
      if mN:IsA("ProximityPrompt") and mN.ActionText and (mN.ActionText:find("Steal")) then
        kN[lN] = mN
        return mN
      end
    end
    kN[lN] = nil
    return nil
  end
  local kN, lN =
    {
      active = false,
      startTime = 0,
      phase = "idle",
      label = "",
      lastResult = "",
      lastResultTime = 0,
      totalSteals = 0,
      failedSteals = 0,
    }, _G.__AkatsukiAutoStealState or { isStealing = false }
  _G.__AkatsukiAutoStealState = lN
  local function NN(mN)
    mN = mN == true
    if lN.isStealing == mN then
      return
    end
    lN.isStealing = mN
  end
  local function lN()
    if iN then
      return true
    end
    return pcall(function()
      local mN, sN = R:WaitForChild("Packages", 10), R:WaitForChild("Datas", 10)
      if not mN or not sN then
        return
      end
      ON = require(sN:WaitForChild("Animals"))
      sN = mN:WaitForChild("Synchronizer")
      iN = {
        channelFolder = sN:WaitForChild("Channel"),
        routeRemote = sN:WaitForChild("CommunicationRoute"),
        requestData = sN:FindFirstChild("RequestData"),
      }
    end) and iN ~= nil
  end
  local function R(mN)
    if typeof(mN) == "table" then
      return mN
    end
    local sN = {}
    for MN in string.gmatch(tostring(mN), "[^%.]+") do
      table.insert(sN, tonumber(MN) or MN)
    end
    return sN
  end
  local function mN(sN, MN)
    local dN, cN, TN = MN
    for MN, MN in ipairs(R(sN)) do
      dN, cN, TN = dN and dN[MN] or nil, dN, MN
    end
    return dN, cN, TN
  end
  local function R(sN, MN)
    local dN = SN.caches[sN]
    if typeof(dN) ~= "table" then
      return
    end
    local sN, cN, TN, WN = MN[1], MN[2], MN[3], MN[4]
    local MN, wN, rN = mN(sN, dN)
    if cN == "Changed" then
      if wN ~= nil then
        wN[rN] = TN
      end
    elseif cN == "ArrayInsert" then
      if MN ~= nil then
        table.insert(MN, WN, TN)
      end
    elseif cN == "ArrayRemoved" then
      if MN ~= nil then
        table.remove(MN, WN)
      end
    elseif cN == "DictionaryInsert" then
      if MN ~= nil then
        MN[WN] = TN
      end
    elseif cN == "DictionaryRemoved" then
      if MN ~= nil then
        MN[WN] = nil
      end
    end
  end
  local function mN(sN)
    if not iN or SN.connections[sN] then
      return
    end
    local MN = tostring(sN.Name)
    if not LN:FindFirstChild(MN) then
      return
    end
    if iN.requestData and SN.caches[MN] == nil then
      local dN, cN = pcall(function()
        return iN.requestData:InvokeServer(MN)
      end)
      SN.caches[MN] = dN and typeof(cN) == "table" and cN or {}
    elseif SN.caches[MN] == nil then
      SN.caches[MN] = {}
    end
    SN.connections[sN] = sN.OnClientEvent:Connect(function(sN)
      for dN, dN in ipairs(sN) do
        R(MN, dN)
      end
    end)
  end
  local function R(sN)
    for MN, dN in pairs(SN.connections) do
      if tostring(MN.Name) == tostring(sN) then
        dN:Disconnect()
        SN.connections[MN] = nil
        SN.caches[tostring(sN)] = nil
        break
      end
    end
  end
  local function sN()
    if eN then
      return true
    end
    if not lN() then
      return false
    end
    if not iN or not iN.channelFolder then
      return false
    end
    for lN, lN in ipairs(iN.channelFolder:GetChildren()) do
      if lN:IsA("RemoteEvent") then
        mN(lN)
      end
    end
    iN.channelFolder.ChildAdded:Connect(function(lN)
      if lN:IsA("RemoteEvent") then
        mN(lN)
      end
    end)
    iN.routeRemote.OnClientEvent:Connect(function(lN)
      for MN, MN in ipairs(lN) do
        local lN, dN = MN[1], tostring(MN[2])
        if LN:FindFirstChild(dN) then
          if lN == "ListenerAdded" then
            MN = iN.channelFolder:FindFirstChild(dN)
            if MN and (MN:IsA("RemoteEvent")) then
              mN(MN)
            end
          elseif lN == "ListenerRemoved" then
            R(dN)
          end
        end
      end
    end)
    eN = true
    return true
  end
  local function R(iN)
    return SN.caches[iN]
  end
  local function iN(SN)
    local eN = LN:FindFirstChild(SN.plot)
    local lN = eN and (eN:FindFirstChild("AnimalPodiums"))
    eN = lN and (lN:FindFirstChild(SN.slot))
    return eN and eN:GetPivot().Position
  end
  local function SN(eN)
    local lN = u.Character
    local mN = lN and (lN:FindFirstChild("HumanoidRootPart") or (lN:FindFirstChild("UpperTorso")))
    if not mN then
      return math.huge
    end
    lN = iN(eN)
    if not lN then
      return math.huge
    end
    return (mN.Position - lN).Magnitude
  end
  local function iN()
    if not LN then
      return {}
    end
    local eN = {}
    for lN, mN in ipairs(LN:GetChildren()) do
      lN = R(mN.Name)
      local R = lN and lN.AnimalList
      if typeof(R) == "table" then
        for MN, dN in pairs(R) do
          if type(dN) == "table" then
            lN = dN.Index
            local R = ON[lN]
            if R then
              table.insert(eN, {
                name = R.DisplayName or lN,
                plot = mN.Name,
                slot = tostring(MN),
                uid = mN.Name .. "_" .. tostring(MN),
              })
            end
          end
        end
      end
    end
    ZN = eN
    return #ZN
  end
  local function R(ON)
    if YN[ON] then
      return
    end
    local ZN, eN, lN = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }, false
    if getconnections then
      eN, lN = pcall(getconnections, ON.PromptButtonHoldBegan)
    end
    if eN and type(lN) == "table" then
      for mN, mN in ipairs(lN) do
        if type(mN.Function) == "function" then
          table.insert(ZN.holdCallbacks, mN.Function)
        end
      end
    end
    lN, eN = false
    if getconnections then
      lN, eN = pcall(getconnections, ON.Triggered)
    end
    if lN and type(eN) == "table" then
      for lN, lN in ipairs(eN) do
        if type(lN.Function) == "function" then
          table.insert(ZN.triggerCallbacks, lN.Function)
        end
      end
    end
    if #ZN.holdCallbacks > 0 or #ZN.triggerCallbacks > 0 then
      YN[ON] = ZN
    end
  end
  local function ON(ZN, eN)
    local lN = YN[ZN]
    if not lN or not lN.ready then
      return false
    end
    lN.ready = false
    local mN = eN and eN.name or "Animal"
    kN.active = true
    kN.startTime = tick()
    kN.phase = "holding"
    kN.label = mN
    NN(false)
    I = 0
    local MN = IN
    task.spawn(function()
      FN.HOLD_MIN = O.Duration or FN.HOLD_MIN
      FN.HOLD_MAX = FN.HOLD_MIN + 1.3
      for dN, dN in ipairs(lN.holdCallbacks) do
        task.spawn(dN)
      end
      while tick() - kN.startTime < FN.HOLD_MIN do
        if MN ~= IN then
          lN.ready = true
          return
        end
        if not FN.AUTO_STEAL_ENABLED or not ZN.Parent then
          break
        end
        local dN = tick() - kN.startTime
        I = math.clamp(dN / FN.HOLD_MAX, 0, 1)
        task.wait(0.05)
      end
      kN.phase = "waitingRange"
      local dN, cN = eN and SN(eN) <= FN.STEAL_RANGE, false
      while MN == IN and FN.AUTO_STEAL_ENABLED and ZN.Parent do
        local ZN = tick() - kN.startTime
        I = math.clamp(ZN / FN.HOLD_MAX, 0, 1)
        if ZN > FN.HOLD_MAX then
          break
        end
        if eN and SN(eN) <= FN.STEAL_RANGE then
          if not dN then
            task.wait(FN.ENTRY_DELAY)
          end
          for SN, SN in ipairs(lN.triggerCallbacks) do
            task.spawn(SN)
          end
          cN = true
          break
        end
        task.wait(0.05)
      end
      if MN ~= IN then
        lN.ready = true
        return
      end
      if cN then
        kN.totalSteals = kN.totalSteals + 1
        kN.lastResult = "Stole " .. mN
        kN.phase = "success"
        NN(true)
      else
        kN.failedSteals = kN.failedSteals + 1
        kN.lastResult = "Missed window: " .. mN
        kN.phase = "failed"
      end
      kN.active = false
      kN.lastResultTime = tick()
      I = 1
      task.wait(FN.COOLDOWN)
      I = 0
      lN.ready = true
    end)
    return true
  end
  local function SN(ZN, eN)
    if not ZN or not ZN.Parent then
      return false
    end
    R(ZN)
    return ON(ZN, eN)
  end
  local R, ON, ZN =
    {
      busy = false,
      active = false,
      progress = 0,
      isStealing = false,
      currentTarget = nil,
      totalSteals = 0,
      failedSteals = 0,
      lastResult = "",
      generation = 0,
      phase = "idle",
      startTime = 0,
      data = {},
    }, {
      RADIUS = 65,
      HOLD_MIN = 1.3,
      HOLD_MAX = 2.6,
      NEAR_TARGET_RANGE = 20,
      ENTRY_DELAY = 0.3,
      FIRE_RANGE = 12,
      COOLDOWN = 0.45,
    }, { prompt = nil, radius = 0, expiresAt = 0 }
  local function eN(lN)
    local mN = math.max(0, tonumber(lN) or ON.RADIUS)
    if ZN.expiresAt > tick() and ZN.radius == mN and ZN.prompt and ZN.prompt.Parent then
      return ZN.prompt
    end
    lN = u.Character
    local MN = lN
      and (
        lN:FindFirstChild("HumanoidRootPart")
        or (lN:FindFirstChild("UpperTorso"))
        or (lN:FindFirstChild("Torso"))
      )
    if not MN then
      return nil
    end
    local dN, cN, TN = math.huge, mN * mN
    for WN, wN in ipairs(LN:GetChildren()) do
      WN = wN:FindFirstChild("PlotSign")
      lN = WN and (WN:FindFirstChild("YourBase"))
      if wN:IsA("Model") and not (lN and (lN:IsA("BillboardGui")) and lN.Enabled) then
        WN = wN:FindFirstChild("AnimalPodiums")
        if WN then
          for lN, wN in ipairs(WN:GetChildren()) do
            lN = wN:FindFirstChild("Base") and (wN.Base:FindFirstChild("Spawn"))
            if lN then
              wN = lN.Position - MN.Position
              local MN = wN:Dot(wN)
              if MN <= cN and MN < dN then
                local cN = EN(lN)
                if cN then
                  dN, TN = MN, cN
                end
              end
            end
          end
        end
      end
    end
    ZN.prompt = TN
    ZN.radius = mN
    ZN.expiresAt = tick() + 0.12
    return TN
  end
  function _G.__AkatsukiAutoGrabTargetInRadius(ZN)
    return eN(ZN or 65) ~= nil
  end
  local function ZN(EN)
    local lN = u.Character
    local mN = lN
      and (
        lN:FindFirstChild("HumanoidRootPart")
        or (lN:FindFirstChild("UpperTorso"))
        or (lN:FindFirstChild("Torso"))
      )
    if not mN then
      return math.huge
    end
    lN = EN.Parent
    lN = if lN and (lN:IsA("Attachment")) then lN.Parent else lN
    if lN and (lN:IsA("BasePart")) then
      return (lN.Position - mN.Position).Magnitude
    end
    local lN, MN = pcall(function()
      return EN.Parent and EN.Parent.WorldPosition
    end)
    if lN and MN then
      return (MN - mN.Position).Magnitude
    end
    return math.huge
  end
  local function EN(lN)
    local mN = R.data[lN]
    if mN then
      return mN
    end
    mN = { hold = {}, trigger = {}, ready = true }
    if getconnections then
      for MN, MN in ipairs(getconnections(lN.PromptButtonHoldBegan)) do
        if MN.Function then
          table.insert(mN.hold, MN.Function)
        end
      end
      for MN, MN in ipairs(getconnections(lN.Triggered)) do
        if MN.Function then
          table.insert(mN.trigger, MN.Function)
        end
      end
    end
    R.data[lN] = mN
    return mN
  end
  local function lN(mN, MN)
    if not mN or not mN.Parent then
      return false
    end
    if u:GetAttribute("Stealing") == true then
      return false
    end
    local dN = false
    for cN, cN in ipairs(MN.trigger) do
      dN = if pcall(cN) then true else dN
    end
    dN = if not dN
        and u:GetAttribute("Stealing") ~= true
        and typeof(fireproximityprompt) == "function"
      then pcall(fireproximityprompt, mN) or dN
      else dN
    return if not dN and u:GetAttribute("Stealing") ~= true
      then (pcall(function()
        mN:InputHoldBegin()
        task.wait(0.05)
        mN:InputHoldEnd()
      end))
      else dN
  end
  local function mN(MN)
    if R.busy or not MN or not MN.Parent then
      return
    end
    if u:GetAttribute("Stealing") == true then
      return
    end
    local dN = EN(MN)
    if #dN.trigger == 0 then
      R.data[MN] = nil
      dN = EN(MN)
    end
    if not dN.ready then
      return
    end
    dN.ready = false
    R.busy = true
    R.active = true
    R.isStealing = true
    R.startTime = tick()
    R.progress = 0
    R.phase = "holding"
    R.generation = R.generation + 1
    local EN = R.generation
    NN(true)
    task.spawn(function()
      for cN, cN in ipairs(dN.hold) do
        task.spawn(cN)
      end
      local cN = tick()
      while R.busy and tick() - cN < ON.HOLD_MIN do
        if EN ~= R.generation then
          return
        end
        R.progress = math.clamp((tick() - cN) / ON.HOLD_MIN, 0, 1)
        I = R.progress
        task.wait(0.05)
      end
      if EN ~= R.generation then
        return
      end
      R.progress = 1
      I = 1
      R.phase = "waiting"
      local TN, WN = ZN(MN) <= ON.FIRE_RANGE, false
      while
        EN == R.generation
        and MN.Parent
        and FN.AUTO_STEAL_ENABLED
        and u:GetAttribute("Stealing") ~= true
      do
        R.progress = 1
        I = 1
        local wN = ZN(MN)
        if wN > ON.NEAR_TARGET_RANGE and tick() - cN > ON.HOLD_MAX then
          break
        end
        if wN <= ON.FIRE_RANGE then
          if not TN then
            task.wait(ON.ENTRY_DELAY)
            if EN ~= R.generation or not MN.Parent or ZN(MN) > ON.FIRE_RANGE then
              task.wait(0.05)
              continue
            end
          end
          R.phase = "triggering"
          if not lN(MN, dN) then
            R.phase = "waiting"
            task.wait(0.05)
            continue
          end
          R.totalSteals = R.totalSteals + 1
          kN.totalSteals = kN.totalSteals + 1
          R.lastResult = "[OK] ROBADO!"
          kN.lastResult = "Stole"
          R.isStealing = true
          R.phase = "success"
          WN = true
          break
        end
        task.wait(0.05)
      end
      if EN ~= R.generation then
        return
      end
      R.active = false
      R.isStealing = false
      R.busy = false
      dN.ready = true
      NN(false)
      if not WN then
        R.failedSteals = R.failedSteals + 1
        R.lastResult = "[X] FALLO"
        R.phase = "failed"
      end
      R.lastResultTime = tick()
      kN.lastResultTime = tick()
      task.wait(ON.COOLDOWN)
      if EN ~= R.generation then
        return
      end
      R.progress = 0
      I = 0
      R.phase = "idle"
    end)
  end
  local ON, EN =
    {
      busy = false,
      active = false,
      progress = 0,
      paused = false,
      pauseTime = nil,
      totalSteals = 0,
      failedSteals = 0,
      lastResult = "",
      generation = 0,
      phase = "idle",
      data = {},
    }, { STEAL_DURATION = 1.3, HOLD_TARGET = 0.8, TRIGGER_RADIUS = 10, PAUSE_TIMEOUT = 1.3, COOLDOWN = 0.05 }
  local function lN(MN)
    local dN = ON.data[MN]
    if dN then
      return dN
    end
    dN = { hold = {}, trigger = {}, ready = true }
    if getconnections then
      pcall(function()
        for cN, cN in ipairs(getconnections(MN.PromptButtonHoldBegan)) do
          if cN.Function then
            table.insert(dN.hold, cN.Function)
          end
        end
        for cN, cN in ipairs(getconnections(MN.Triggered)) do
          if cN.Function then
            table.insert(dN.trigger, cN.Function)
          end
        end
      end)
    end
    ON.data[MN] = dN
    return dN
  end
  local function MN(dN)
    if ON.busy or not dN or not dN.Parent then
      return
    end
    if u:GetAttribute("Stealing") == true then
      return
    end
    local cN = lN(dN)
    if not cN.ready then
      return
    end
    cN.ready = false
    ON.busy = true
    ON.active = true
    ON.progress = 0
    ON.paused = false
    ON.pauseTime = nil
    ON.phase = "holding"
    ON.generation = ON.generation + 1
    local lN, TN, WN, wN = ON.generation, tick(), true, false
    kN.active = true
    kN.startTime = TN
    kN.phase = "holding"
    I = 0
    NN(true)
    task.spawn(function()
      for rN, rN in ipairs(cN.hold) do
        task.spawn(function()
          pcall(rN)
        end)
      end
      while
        lN == ON.generation
        and FN.AUTO_STEAL_ENABLED
        and i == "v2"
        and u:GetAttribute("Stealing") ~= true
        and dN.Parent
      do
        if ON.paused then
          if ZN(dN) <= EN.TRIGGER_RADIUS then
            ON.paused = false
            ON.pauseTime = nil
            ON.phase = "finishing"
            TN = tick() - EN.HOLD_TARGET * EN.STEAL_DURATION
          else
            if not ON.pauseTime then
              ON.pauseTime = tick()
            elseif tick() - ON.pauseTime >= EN.PAUSE_TIMEOUT then
              break
            end
            ON.progress = EN.HOLD_TARGET
            I = ON.progress
            kN.label = "80%"
            task.wait(0.05)
            continue
          end
        end
        local ZN = math.clamp((tick() - TN) / EN.STEAL_DURATION, 0, 1)
        ON.progress = ZN
        I = ZN
        kN.label = math.floor(ZN * 100 + 0.5) .. "%"
        if WN and ZN >= EN.HOLD_TARGET then
          WN = false
          ON.paused = true
          ON.pauseTime = tick()
          ON.progress = EN.HOLD_TARGET
          I = ON.progress
          ON.phase = "waitingRange"
          kN.phase = "waitingRange"
        elseif ZN >= 1 then
          ON.phase = "triggering"
          for ZN, ZN in ipairs(cN.trigger) do
            task.spawn(function()
              pcall(ZN)
            end)
          end
          wN = true
          break
        end
        task.wait(0.05)
      end
      if lN ~= ON.generation then
        return
      end
      ON.active = false
      ON.busy = false
      ON.paused = false
      ON.pauseTime = nil
      cN.ready = true
      kN.active = false
      kN.lastResultTime = tick()
      NN(false)
      if wN then
        ON.totalSteals = ON.totalSteals + 1
        ON.lastResult = "Stole"
        ON.phase = "success"
        kN.totalSteals = kN.totalSteals + 1
        kN.lastResult = "Stole"
      else
        ON.failedSteals = ON.failedSteals + 1
        ON.lastResult = "Missed window"
        ON.phase = "failed"
        kN.failedSteals = kN.failedSteals + 1
        kN.lastResult = "Missed window"
      end
      task.wait(EN.COOLDOWN)
      if lN == ON.generation then
        ON.progress = 0
        I = 0
        ON.phase = "idle"
      end
    end)
  end
  local function ZN()
    if jN then
      return
    end
    local EN = 0
    jN = D.Heartbeat:Connect(function(lN)
      EN += lN or 0
      if EN < 0.15 then
        return
      end
      EN = 0
      if not FN.AUTO_STEAL_ENABLED then
        return
      end
      if u:GetAttribute("Stealing") == true then
        return
      end
      if _G.__AkatsukiAutoGrabRagdollBlocked == true then
        return
      end
      if kN.active or F.busy or R.busy or ON.busy then
        return
      end
      if i == "v2" then
        lN = eN(O.Radius)
        if lN then
          MN(lN)
        end
        return
      end
      if i == "v1" then
        lN = eN(O.Radius)
        if lN then
          mN(lN)
        end
        return
      end
    end)
  end
  function _G.AkatsukiAutoStealRunCycle(eN, EN)
    return SN(eN, EN)
  end
  local function SN()
    if KN then
      for eN, eN in ipairs(KN) do
        pcall(function()
          eN:Disconnect()
        end)
      end
    end
    KN = {}
    if GN then
      task.cancel(GN)
      GN = nil
    end
  end
  local function eN(EN)
    SN()
    local SN = EN and (EN:FindFirstChildOfClass("Humanoid"))
    if not SN then
      return
    end
    table.insert(
      KN,
      SN:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        NN(SN.WalkSpeed < 22)
      end)
    )
    local function SN(lN)
      if not lN:IsA("ProximityPrompt") then
        return
      end
      table.insert(
        KN,
        lN.PromptButtonHoldBegan:Connect(function(mN)
          if mN ~= k then
            return
          end
          NN(true)
          if GN then
            task.cancel(GN)
          end
          GN = task.delay(FN.HOLD_MAX + 0.5, function()
            NN(false)
          end)
        end)
      )
      table.insert(
        KN,
        lN.Triggered:Connect(function(GN)
          if GN ~= k then
            return
          end
          task.delay(0.2, function()
            NN(false)
          end)
        end)
      )
    end
    table.insert(
      KN,
      workspace.DescendantAdded:Connect(function(k)
        task.defer(SN, k)
      end)
    )
    _G.__AkatsukiWalkDescendantsBatched(LN, SN, function()
      return EN.Parent ~= nil
    end)
  end
  local function k()
    if qN then
      return
    end
    qN = true
    task.spawn(function()
      if sN() then
        if FN.AUTO_STEAL_ENABLED then
          iN()
        end
        while o.alive do
          task.wait(5)
          if not o.alive then
            break
          end
          if FN.AUTO_STEAL_ENABLED then
            iN()
          end
        end
      end
    end)
  end
  k()
  if u.Character then
    task.defer(eN, u.Character)
  end
  _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function(LN)
    task.wait(0.5)
    eN(LN)
    if y["auto steal"] then
      FN.AUTO_STEAL_ENABLED = false
      if jN then
        jN:Disconnect()
        jN = nil
      end
      FN.AUTO_STEAL_ENABLED = true
      iN()
      ZN()
    end
  end))
  _G.AkatsukiAutoGrab = {
    GetMode = function()
      return i
    end,
    SetMode = function(LN)
      if LN ~= "v1" and LN ~= "v2" then
        return false
      end
      i = LN
      oN()
      return true
    end,
  }
  local function LN()
    k()
    iN()
    FN.AUTO_STEAL_ENABLED = true
    ZN()
  end
  local function k()
    IN += 1
    if jN then
      jN:Disconnect()
      jN = nil
    end
    FN.AUTO_STEAL_ENABLED = false
    kN.active = false
    kN.phase = "idle"
    NN(false)
    I, YN = 0, {}
    F.busy = false
    F.data = {}
    if R then
      R.generation = R.generation + 1
      R.busy = false
      R.active = false
      R.isStealing = false
      R.progress = 0
      R.phase = "idle"
      R.data = {}
    end
    if ON then
      ON.generation = ON.generation + 1
      ON.busy = false
      ON.active = false
      ON.paused = false
      ON.pauseTime = nil
      ON.progress = 0
      ON.phase = "idle"
      ON.data = {}
    end
  end
  autoStealDisableInternal = k
  _G.__AkatsukiTrackConn(u.CharacterRemoving:Connect(k))
  _G.__AkatsukiTrackStopper(k);
  (function()
    local R, ON, iN, SN = 0
    local ZN, YN, jN = false, false, 0
    local function eN(qN, KN)
      return qN.PlatformStand
        or KN == Enum.HumanoidStateType.Physics
        or KN == Enum.HumanoidStateType.Ragdoll
        or KN == Enum.HumanoidStateType.FallingDown
    end
    local function qN(KN)
      if not KN then
        return false
      end
      for GN, IN in ipairs(KN:GetDescendants()) do
        if not IN:FindFirstAncestorOfClass("Tool") then
          GN = IN.Name:lower()
          if
            GN:find("medusa")
            or (GN:find("petrif"))
            or (GN:find("gorgon"))
            or (GN:find("stone"))
          then
            return true
          end
          for KN, GN in pairs(IN:GetAttributes()) do
            local IN = tostring(KN):lower()
            if
              GN
              and (
                IN:find("medusa")
                or (IN:find("petrif"))
                or (IN:find("gorgon"))
                or (IN:find("stone"))
              )
            then
              return true
            end
          end
        end
      end
      return false
    end
    local function KN(GN)
      R += 1
      local GN = R
      _G.__AkatsukiAutoGrabRagdollBlocked = true
      YN = true
      k()
      task.delay(1, function()
        if GN ~= R then
          return
        end
        YN = false
        if not y["auto steal"] then
          return
        end
        _G.__AkatsukiAutoGrabRagdollBlocked = false
        if not FN.AUTO_STEAL_ENABLED then
          LN()
        end
        pcall(function()
          if
            _G.AkatsukiBypass
            and _G.AkatsukiBypass.IsAutoOnSteal
            and (_G.AkatsukiBypass.IsAutoOnSteal())
            and _G.AkatsukiBypass.SetAutoOnSteal
          then
            pcall(_G.AkatsukiBypass.SetAutoOnSteal, true)
          end
        end)
      end)
    end
    local function GN(IN)
      if ON then
        ON:Disconnect()
        ON = nil
      end
      if iN then
        iN:Disconnect()
        iN = nil
      end
      if SN then
        SN:Disconnect()
        SN = nil
      end
      ZN, jN = false, 0
      local kN = IN and (IN:FindFirstChildOfClass("Humanoid") or (IN:WaitForChild("Humanoid", 5)))
      if not kN then
        return
      end
      local EN = qN
      if EN(IN) then
        jN = tick() + 5
      end
      SN = IN.DescendantAdded:Connect(function(SN)
        if SN:FindFirstAncestorOfClass("Tool") then
          return
        end
        local EN = SN.Name:lower()
        SN = EN:find("medusa") or (EN:find("petrif")) or (EN:find("gorgon")) or (EN:find("stone"))
        if SN then
          jN = tick() + 5
        end
      end)
      local function SN(EN)
        local lN = qN
        if lN(IN) then
          jN = tick() + 5
        end
        lN = eN(kN, EN)
        if lN and not ZN then
          ZN = true
          KN(tick() <= jN)
        elseif not lN then
          ZN = false
          if not YN then
            _G.__AkatsukiAutoGrabRagdollBlocked = false
            if y["auto steal"] and not FN.AUTO_STEAL_ENABLED then
              LN()
            end
          end
        end
      end
      ON = kN.StateChanged:Connect(function(ON, ON)
        SN(ON)
      end)
      iN = kN:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        SN(kN:GetState())
      end)
    end
    if u.Character then
      task.defer(GN, u.Character)
    end
    _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function(ON)
      R += 1
      YN = false
      _G.__AkatsukiAutoGrabRagdollBlocked = false
      GN(ON)
    end))
  end)()
  T["auto steal"] = function(R)
    if R then
      if _G.__AkatsukiAutoGrabRagdollBlocked ~= true then
        LN()
      end
    else
      k()
    end
  end
  if y["auto steal"] then
    LN()
  end
end
do
  do
    local function R(k, LN)
      if y[k] == LN then
        return
      end
      y[k] = LN
      if T[k] then
        T[k](LN)
      end
      if M[k] then
        M[k]()
      end
      oN()
    end
    local function k()
      R("Autoplay", false)
    end
    local function R(LN)
      if not LN then
        return
      end
      local ON = os.clock()
      if _G._AkatsukiHitCountdownLast and ON - _G._AkatsukiHitCountdownLast < 0.15 then
        return
      end
      _G._AkatsukiHitCountdownLast = ON
      local iN = (_G._AkatsukiHitCountdownGen or 0) + 1
      _G._AkatsukiHitCountdownGen = iN
      _G._AkatsukiHitCountdownActive = true
      if _G._AkatsukiHitCountdownBB then
        pcall(function()
          _G._AkatsukiHitCountdownBB:Destroy()
        end)
        _G._AkatsukiHitCountdownBB = nil
      end
      pcall(function()
        _G._AkatsukiShowStealCountdown = R
      end)
      ON = LN:FindFirstChild("LowerTorso")
        or (LN:FindFirstChild("Torso"))
        or (LN:FindFirstChild("UpperTorso"))
        or (LN:FindFirstChild("HumanoidRootPart"))
      if not ON then
        _G._AkatsukiHitCountdownActive = false
        return
      end
      local SN = Instance.new("BillboardGui")
      SN.Name = "AkatsukiHitCountdown"
      SN.Adornee = ON
      SN.Size = UDim2.new(0, 120, 0, 56)
      SN.StudsOffset = Vector3.new(0, 0.6, 0)
      SN.AlwaysOnTop = true
      SN.LightInfluence = 0
      SN.Parent = u and (u:FindFirstChildOfClass("PlayerGui") or (game:GetService("CoreGui")))
        or (game:GetService("CoreGui"))
      _G._AkatsukiHitCountdownBB = SN
      LN = Instance.new("Frame", SN)
      LN.Size = UDim2.new(1, 0, 1, 0)
      LN.BackgroundTransparency = 1
      LN.BorderSizePixel = 0
      local ON = Instance.new("TextLabel", LN)
      ON.Size = UDim2.new(1, 0, 1, 0)
      ON.Position = UDim2.new(0, 0, 0, 6)
      ON.BackgroundTransparency = 1
      ON.Text = "3"
      ON.TextScaled = false
      ON.TextSize = 28
      ON.Font = Enum.Font.GothamBlack
      ON.TextColor3 = Color3.fromRGB(175, 180, 185)
      ON.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      ON.TextStrokeTransparency = 0
      ON.ZIndex = 10
      ON.TextTransparency = 1
      local function LN(ZN, YN)
        ON.Text = ZN
        if YN then
          ON.TextColor3 = YN
        end
        YN = ZN == "STEAL!" and 1 or 0.76
        for ZN = 0, 6, 1 do
          ON.TextTransparency = 1 - ZN / 6
          task.wait(0.02)
          if _G._AkatsukiHitCountdownGen ~= iN then
            return false
          end
        end
        task.wait(YN)
        if _G._AkatsukiHitCountdownGen ~= iN then
          return false
        end
        for ZN = 0, 6, 1 do
          ON.TextTransparency = ZN / 6
          task.wait(0.02)
          if _G._AkatsukiHitCountdownGen ~= iN then
            return false
          end
        end
        return true
      end
      task.spawn(function()
        pcall(function()
          ON.TextStrokeTransparency = 0
          ON.TextColor3 = Color3.fromRGB(175, 180, 185)
          for ZN = 0, 24, 1 do
            local YN = 2.4 - 2.4 * ZN / 24
            ON.Text = YN <= 0.05 and "0" or (string.format("%.1f", YN))
            ON.TextTransparency = 0
            for ZN = 0, 2, 1 do
              ON.TextTransparency = 0.18 * ZN
              task.wait(0.02)
              if _G._AkatsukiHitCountdownGen ~= iN then
                return
              end
            end
            if _G._AkatsukiHitCountdownGen ~= iN then
              return
            end
            task.wait(0.08)
            if _G._AkatsukiHitCountdownGen ~= iN then
              return
            end
          end
          if not LN("STEAL!", Color3.fromRGB(175, 180, 185)) then
            return
          end
        end)
        if _G._AkatsukiHitCountdownGen == iN then
          pcall(function()
            SN:Destroy()
          end)
          if _G._AkatsukiHitCountdownBB == SN then
            _G._AkatsukiHitCountdownBB = nil
          end
          _G._AkatsukiHitCountdownActive = false
        end
      end)
    end
    local function LN(ON)
      local iN = ON:FindFirstChildOfClass("Humanoid")
      if not iN then
        return
      end
      local SN = iN.Health
      iN.HealthChanged:Connect(function(ZN)
        if ZN < SN then
          k()
          pcall(function()
            R(ON)
          end)
        end
        SN = ZN
      end)
      if iN.StateChanged then
        iN.StateChanged:Connect(function(SN, SN)
          if
            SN == Enum.HumanoidStateType.Physics
            or SN == Enum.HumanoidStateType.Ragdoll
            or SN == Enum.HumanoidStateType.FallingDown
          then
            pcall(function()
              R(ON)
            end)
          end
        end)
      end
      pcall(function()
        iN:GetPropertyChangedSignal("PlatformStand"):Connect(function()
          if iN.PlatformStand then
            pcall(function()
              R(ON)
            end)
          end
        end)
      end)
      iN.Died:Connect(function()
        k()
      end)
    end
    if u.Character then
      LN(u.Character)
    end
    _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function(R)
      if R:WaitForChild("Humanoid", 5) then
        k()
        LN(R)
      else
        task.wait(0.5)
        k()
        LN(R)
      end
    end))
  end
  do
    local R = { generation = 0, animationConn = nil, animate = nil, disabledByUs = false }
    local function k()
      R.generation = R.generation + 1
      if R.animationConn then
        R.animationConn:Disconnect()
        R.animationConn = nil
      end
    end
    local function LN(ON)
      local iN, SN = R.animate, R.disabledByUs
      R.animate = nil
      R.disabledByUs = false
      if iN and iN.Parent and SN and (ON or not y.Unwalk) then
        pcall(function()
          iN.Disabled = false
        end)
      end
    end
    local function ON(iN)
      local SN, ZN = R.animate, R.disabledByUs
      k()
      if not y.Unwalk or iN ~= u.Character then
        return
      end
      local YN, jN, eN =
        R.generation,
        iN:FindFirstChildOfClass("Humanoid") or (iN:WaitForChild("Humanoid", 5)),
        iN:FindFirstChild("Animate") or (iN:WaitForChild("Animate", 5))
      if not jN or not eN or YN ~= R.generation or not y.Unwalk then
        return
      end
      R.animate = eN
      R.disabledByUs = SN == eN and ZN or eN:IsA("LocalScript") and not eN.Disabled
      if eN:IsA("LocalScript") then
        eN.Disabled = true
      end
      local function SN()
        if YN ~= R.generation or not y.Unwalk or iN ~= u.Character or jN.Parent ~= iN then
          return
        end
        for iN, iN in ipairs(jN:GetPlayingAnimationTracks()) do
          pcall(function()
            iN:Stop(0)
          end)
        end
      end
      R.animationConn = jN.AnimationPlayed:Connect(function(iN)
        if YN ~= R.generation or not y.Unwalk then
          return
        end
        pcall(function()
          iN:Stop(0)
        end)
      end)
      SN()
    end
    T.Unwalk = function(R)
      if R then
        ON(u.Character)
      else
        k()
        LN(false)
      end
    end
    _G.__AkatsukiTrackStopper(function()
      k()
      LN(true)
    end)
    _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function(R)
      if not y.Unwalk then
        return
      end
      task.defer(function()
        ON(R)
      end)
    end))
    if y.Unwalk then
      task.defer(function()
        ON(u.Character)
      end)
    end
  end
  do
    local R
    local k = false
    local function LN()
      local ON = u.Character
      if not ON then
        return nil
      end
      local iN = ON:FindFirstChildOfClass("Tool")
      if iN and (iN.Name:lower():find("bat")) then
        return iN
      end
      iN = u:FindFirstChild("Backpack")
      if iN then
        local SN = ON:FindFirstChildOfClass("Humanoid")
        for ZN, ZN in ipairs(iN:GetChildren()) do
          if ZN:IsA("Tool") and (ZN.Name:lower():find("bat")) then
            if SN then
              pcall(function()
                SN:EquipTool(ZN)
              end)
            end
            return ON:FindFirstChild(ZN.Name) or ZN
          end
        end
      end
      return nil
    end
    local function ON(iN)
      local SN, ZN = math.huge
      for YN, jN in ipairs(z:GetPlayers()) do
        if jN ~= u and jN.Character then
          local eN, qN =
            jN.Character:FindFirstChild("HumanoidRootPart"),
            jN.Character:FindFirstChildOfClass("Humanoid")
          if eN and qN and qN.Health > 0 then
            YN = (iN.Position - eN.Position).Magnitude
            if YN < SN then
              SN, ZN = YN, eN
            end
          end
        end
      end
      return ZN, SN
    end
    local function iN()
      if c or not y["Ragdoll Counter"] then
        return
      end
      local SN = u.Character
      local ZN, YN =
        SN and (SN:FindFirstChildOfClass("Humanoid")),
        SN and (SN:FindFirstChild("HumanoidRootPart"))
      if not SN or not ZN or not YN or ZN.Health <= 0 then
        return
      end
      local SN, jN = ON(YN)
      if SN and jN <= 4 then
        local ON = Vector3.new(SN.Position.X, YN.Position.Y, SN.Position.Z)
        if (ON - YN.Position).Magnitude > 0.01 then
          pcall(function()
            ZN.AutoRotate = false
            YN.CFrame = CFrame.lookAt(YN.Position, ON)
          end)
        end
      end
      local ON = LN()
      if ON then
        pcall(function()
          ON:Activate()
        end)
        local LN = ON:FindFirstChildWhichIsA("RemoteEvent", true)
        if LN then
          pcall(function()
            LN:FireServer()
          end)
        end
      end
      task.defer(function()
        if ZN.Parent then
          ZN.AutoRotate = true
        end
      end)
    end
    local function LN()
      if R then
        return
      end
      local ON = u.Character
      if not ON then
        return
      end
      local SN, ZN = ON:FindFirstChildOfClass("Humanoid"), ON:FindFirstChild("HumanoidRootPart")
      if not SN or not ZN then
        return
      end
      R = {}
      ON, ZN = pcall(function()
        return SN.StateChanged:Connect(function(YN, jN)
          if c or not y["Ragdoll Counter"] then
            return
          end
          YN = jN == Enum.HumanoidStateType.Physics
            or jN == Enum.HumanoidStateType.Ragdoll
            or jN == Enum.HumanoidStateType.FallingDown
          if YN and not k then
            k = true
            pcall(function()
              iN()
            end)
          else
            jN = not YN and k
            if jN then
              k = false
            end
          end
        end)
      end)
      if ON and ZN then
        table.insert(R, ZN)
      end
      ON, ZN = pcall(function()
        return SN:GetPropertyChangedSignal("PlatformStand"):Connect(function()
          if c or not y["Ragdoll Counter"] then
            return
          end
          if SN.PlatformStand and not k then
            k = true
            pcall(function()
              iN()
            end)
          else
            local c = SN.PlatformStand
            if not c then
              k = false
            end
          end
        end)
      end)
      if ON and ZN then
        table.insert(R, ZN)
      end
    end
    local function c()
      if R then
        for ON, ON in ipairs(R) do
          pcall(function()
            ON:Disconnect()
          end)
        end
        R = nil
      end
      k = false
    end
    T["Ragdoll Counter"] = function(R)
      if R then
        LN()
      else
        c()
      end
    end
    _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function()
      task.wait(0.5)
      k = false
      if y["Ragdoll Counter"] then
        c()
        LN()
      end
    end))
    if y["Ragdoll Counter"] then
      LN()
    end
  end
  do
    local R, k, c, LN = false, 0, false, {}
    local function ON()
      local iN = u.Character
      if not iN then
        return nil
      end
      for SN, SN in ipairs(iN:GetChildren()) do
        if
          SN:IsA("Tool")
          and (
            SN.Name:lower():find("medusa")
            or (SN.Name:lower():find("head"))
            or (SN.Name:lower():find("stone"))
          )
        then
          return SN
        end
      end
      iN = u:FindFirstChild("Backpack")
      if iN then
        for SN, SN in ipairs(iN:GetChildren()) do
          if
            SN:IsA("Tool")
            and (
              SN.Name:lower():find("medusa")
              or (SN.Name:lower():find("head"))
              or (SN.Name:lower():find("stone"))
            )
          then
            return SN
          end
        end
      end
      return nil
    end
    local function iN()
      if not c then
        return
      end
      if R then
        return
      end
      if tick() - k < 25 then
        return
      end
      local SN = u.Character
      if not SN then
        return
      end
      R = true
      local ZN = ON()
      if not ZN then
        R = false
        return
      end
      if ZN.Parent ~= SN then
        local ON = SN:FindFirstChildOfClass("Humanoid")
        if ON then
          pcall(function()
            ON:EquipTool(ZN)
          end)
        end
        task.wait(0.05)
      end
      pcall(function()
        ZN:Activate()
      end)
      k, R = tick(), false
    end
    local function R(k)
      return k:GetPropertyChangedSignal("Anchored"):Connect(function()
        if c and k.Anchored and k.Transparency == 1 then
          iN()
        end
      end)
    end
    local function k(ON)
      for iN, iN in pairs(LN) do
        pcall(function()
          iN:Disconnect()
        end)
      end
      LN = {}
      if not ON then
        return
      end
      for iN, iN in ipairs(ON:GetDescendants()) do
        if iN:IsA("BasePart") then
          table.insert(LN, R(iN))
        end
      end
      table.insert(
        LN,
        ON.DescendantAdded:Connect(function(ON)
          if ON:IsA("BasePart") then
            table.insert(LN, R(ON))
          end
        end)
      )
    end
    local function R()
      c = true
      if u.Character then
        k(u.Character)
      end
    end
    local function ON()
      c = false
      for iN, iN in pairs(LN) do
        pcall(function()
          iN:Disconnect()
        end)
      end
      LN = {}
    end
    _G.__AkatsukiTrackStopper(ON)
    T["Medusa Counter"] = function(LN)
      if LN then
        R()
      else
        ON()
      end
    end
    _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function(LN)
      task.wait(0.5)
      if c then
        k(LN)
      end
    end))
    if y["Medusa Counter"] then
      R()
    end
  end
  do
    local R = u
    local function k()
      local c = R.Character
      if c then
        local LN = c:FindFirstChildOfClass("Tool")
        if LN then
          local c = LN.Name:lower()
          if c:find("bat", 1, true) or (c:find("slap", 1, true)) then
            return LN
          end
        end
        LN = R:FindFirstChildOfClass("Backpack")
        if LN then
          for R, c in ipairs(LN:GetChildren()) do
            if c:IsA("Tool") then
              R = c.Name:lower()
              if R:find("bat", 1, true) or (R:find("slap", 1, true)) then
                return c
              end
            end
          end
        end
      end
      return nil
    end
    local R
    _G.__AkatsukiAceNormalAimbot = _G.__AkatsukiAceNormalAimbot
      or { target = nil, swingCooldown = false, nextSwingAt = 0 }
    local function c(LN)
      if not LN then
        return nil
      end
      local ON, iN, SN = LN.CFrame, pcall(LN.GetRenderCFrame, LN)
      return if iN and SN then SN else ON
    end
    function _cypherStartFollowing(LN)
      LN = LN or u.Character
      local ON, iN =
        LN and (LN:FindFirstChildOfClass("Humanoid")),
        LN and (LN:FindFirstChild("HumanoidRootPart"))
      if not ON or not iN then
        return
      end
      if R then
        R:Disconnect()
        R = nil
      end
      _G.__AkatsukiAceNormalAimbot.nextSwingAt = 0
      _G.__AkatsukiAceNormalAimbot.swingCooldown = false
      ON.AutoRotate = false
      iN = LN:FindFirstChildOfClass("Tool") or (k())
      if iN and iN.Parent ~= LN then
        pcall(ON.EquipTool, ON, iN)
      end
      R = D.RenderStepped:Connect(function()
        if not y.Aimbot then
          return
        end
        local LN = u.Character
        if not LN then
          return
        end
        local ON, iN = LN:FindFirstChild("HumanoidRootPart"), LN:FindFirstChildOfClass("Humanoid")
        if not ON or not iN then
          return
        end
        if iN.AutoRotate then
          iN.AutoRotate = false
        end
        local SN = LN:FindFirstChildOfClass("Tool") or (k())
        if SN and SN.Parent ~= LN then
          pcall(iN.EquipTool, iN, SN)
        end
        LN = nil
        if _.getMarkerCFrame then
          local ZN, YN = pcall(_.getMarkerCFrame)
          LN = if ZN then YN else LN
        end
        local ZN, YN
        iN = _G.__AkatsukiGetVisualEnemy and (_G.__AkatsukiGetVisualEnemy())
        if iN and iN ~= u and iN.Character then
          local jN, eN =
            iN.Character:FindFirstChild("HumanoidRootPart"),
            iN.Character:FindFirstChildOfClass("Humanoid")
          if jN and eN and eN.Health > 0 then
            ZN, YN = jN, (c(jN))
          end
        end
        if not LN and (not ZN or not YN) then
          return
        end
        _G.__AkatsukiAceNormalAimbot.target = LN or ZN
        iN, ZN = ON.Position, (LN or YN).Position
        LN = ZN - iN
        local c, jN, eN =
          Vector3.new(LN.X, 0, LN.Z),
          y["Lagger Aimbot"] and 34 or (Z == "Lagger" and 40 or 58),
          Vector3.zero
        eN = if c.Magnitude >= 0.01 then c.Unit * jN else eN
        jN = (ZN.Y - iN.Y) * 19.5
        jN = math.clamp(jN, -70, 110)
        ON.AssemblyLinearVelocity = Vector3.new(eN.X, jN, eN.Z)
        if (ZN - iN).Magnitude > 0.1 then
          c = CFrame.lookAt(iN, ZN)
          YN, LN, jN = (ON.CFrame:Inverse() * c):ToEulerAnglesXYZ()
          YN, LN, jN =
            math.clamp(YN, -2.5, 2.5), math.clamp(LN, -2.5, 2.5), math.clamp(jN, -2.5, 2.5)
          ON.AssemblyAngularVelocity =
            ON.CFrame:VectorToWorldSpace(Vector3.new(YN * 42, LN * 42, jN * 42))
        end
        c = tick()
        if SN and c >= (_G.__AkatsukiAceNormalAimbot.nextSwingAt or 0) then
          _G.__AkatsukiAceNormalAimbot.nextSwingAt = c + 0.08
          pcall(SN.Activate, SN)
        end
      end)
    end
    function _cypherStop()
      if R then
        R:Disconnect()
        R = nil
      end
      if _G.__AkatsukiAceNormalAimbot then
        _G.__AkatsukiAceNormalAimbot.target = nil
        _G.__AkatsukiAceNormalAimbot.swingCooldown = false
        _G.__AkatsukiAceNormalAimbot.nextSwingAt = 0
      end
      local R = u.Character
      local c = R and (R:FindFirstChild("HumanoidRootPart"))
      if c then
        c.AssemblyLinearVelocity = Vector3.zero
        c.AssemblyAngularVelocity = Vector3.zero
      end
      c = R and (R:FindFirstChildOfClass("Humanoid"))
      if c then
        c.AutoRotate = true
      end
    end
    _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function(R)
      task.wait(0.5)
      if y.Aimbot then
        _cypherStartFollowing(R)
      end
    end))
    T.Aimbot = function(R)
      if R then
        if _G.__stopSpeedBoost then
          _G.__stopSpeedBoost()
        end
        if autoplayActive or y.Autoplay then
          _G.__stopAutoplay()
        end
        nN("Aimbot")
        if _G.__deactivateBatExclusive then
          _G.__deactivateBatExclusive("Aimbot")
        end
        _G.__checkAndAutoDrop(function()
          local R = u.Character
          if R then
            _cypherStartFollowing(R)
          end
        end)
      else
        _cypherStop()
        if _G.__refreshSpeedBoost then
          _G.__refreshSpeedBoost()
        end
      end
    end
    do
      pcall(function()
        local R = workspace:FindFirstChild("PredictionSphere")
        if R then
          R:Destroy()
        end
      end)
      local R, c, LN =
        {
          targetPlayer = nil,
          lastTargetPos = nil,
          targetVelocity = Vector3.zero,
          smoothedVelocity = Vector3.zero,
          velocityHistory = {},
          accelerationHistory = {},
          aerialVelocityHistory = {},
          verticalVelocityHistory = {},
          previousDirection = nil,
          lastDirectionChangeTime = 0,
          airborneTime = 0,
          lastYVelocity = 0,
          lastJumpTime = 0,
          lastActivationTime = 0,
          currentPing = 0.1,
          realPingMs = 0,
        }, {
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
          AERIAL_VELOCITY_DECAY = 0.95,
          MIN_AIRBORNE_TIME = 0.08,
          FALLING_SPEED_THRESHOLD = -15,
        }
      local function ON(iN)
        if #iN == 0 then
          return Vector3.zero
        end
        local SN = Vector3.zero
        for ZN, ZN in ipairs(iN) do
          SN += ZN
        end
        return SN / #iN
      end
      local function iN(SN, ZN, YN)
        table.insert(SN, ZN)
        if #SN > YN then
          table.remove(SN, 1)
        end
      end
      local function SN()
        R.targetPlayer = nil
        R.lastTargetPos = nil
        R.targetVelocity = Vector3.zero
        R.smoothedVelocity = Vector3.zero
        R.velocityHistory = {}
        R.accelerationHistory = {}
        R.aerialVelocityHistory = {}
        R.verticalVelocityHistory = {}
        R.previousDirection = nil
        R.airborneTime = 0
        R.lastYVelocity = 0
      end
      local function ZN(YN)
        local jN, eN = math.huge
        for qN, KN in ipairs(z:GetPlayers()) do
          if KN ~= u and KN.Character then
            local GN, IN =
              KN.Character:FindFirstChild("HumanoidRootPart"),
              KN.Character:FindFirstChildOfClass("Humanoid")
            if GN and IN and IN.Health > 0 then
              qN = (YN.Position - GN.Position).Magnitude
              if qN < jN then
                jN, eN = qN, KN
              end
            end
          end
        end
        return eN
      end
      local function YN(jN, eN)
        if eN.Magnitude < 0.01 then
          return
        end
        local qN = jN.CFrame.LookVector:Cross(eN.Unit)
        eN = math.asin(math.clamp(qN.Magnitude, -1, 1))
        jN.AssemblyAngularVelocity = qN.Magnitude > 0.01 and qN.Unit * eN * 80 or Vector3.zero
      end
      local function jN()
        local eN, qN = pcall(function()
          return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if eN and type(qN) == "number" then
          R.realPingMs = math.floor(qN)
        end
        R.currentPing =
          math.clamp(R.realPingMs / 1000, c.MIN_PING_COMPENSATION, c.MAX_PING_COMPENSATION)
      end
      task.spawn(function()
        while _G.__AKATSUKI_STATE == o do
          pcall(jN)
          task.wait(0.5)
        end
      end)
      local function jN()
        if LN then
          LN:Disconnect()
          LN = nil
        end
        local eN = u.Character
        local qN, KN =
          eN and (eN:FindFirstChildOfClass("Humanoid")),
          eN and (eN:FindFirstChild("HumanoidRootPart"))
        if qN then
          qN.AutoRotate = true
        end
        if KN then
          KN.AssemblyAngularVelocity = Vector3.zero
        end
        SN()
        R.lastActivationTime = 0
      end
      local function eN(qN)
        qN = qN or u.Character
        local KN, GN =
          qN and (qN:FindFirstChildOfClass("Humanoid")),
          qN and (qN:FindFirstChild("HumanoidRootPart"))
        if not KN or not GN then
          return
        end
        jN()
        KN.AutoRotate = false
        local IN = k()
        if IN and IN.Parent ~= qN then
          pcall(KN.EquipTool, KN, IN)
        end
        LN = D.RenderStepped:Connect(function(LN)
          if not y.Aimbot then
            jN()
            return
          end
          local qN = u.Character
          local FN, kN =
            qN and (qN:FindFirstChild("HumanoidRootPart")),
            qN and (qN:FindFirstChildOfClass("Humanoid"))
          if not FN or not kN or kN.Health <= 0 then
            return
          end
          kN.AutoRotate = false
          GN, KN = FN, kN
          IN = qN:FindFirstChildOfClass("Tool") or (k())
          if IN and IN.Parent ~= qN then
            pcall(kN.EquipTool, kN, IN)
          end
          kN = nil
          if _.getMarkerCFrame then
            qN, FN = pcall(_.getMarkerCFrame)
            kN = if qN then FN else kN
          end
          if kN then
            FN = kN.Position - GN.Position
            if FN.Magnitude > 0.1 then
              YN(GN, FN)
            end
            if FN.Magnitude > c.MIN_FOLLOW_DISTANCE then
              qN = tonumber(J.CypherAimbotApproachSpeed) or c.FOLLOW_SPEED
              GN.AssemblyLinearVelocity = FN.Unit * math.clamp(qN, 1, 120)
            else
              GN.AssemblyLinearVelocity = Vector3.zero
            end
            return
          end
          R.targetPlayer = ZN(GN)
          kN = R.targetPlayer and R.targetPlayer.Character
          FN, qN =
            kN and (kN:FindFirstChild("HumanoidRootPart")),
            kN and (kN:FindFirstChildOfClass("Humanoid"))
          if not FN or not qN or qN.Health <= 0 then
            SN()
            return
          end
          local k, SN = FN.Position, math.max(LN, 0.004166666666666667)
          if R.lastTargetPos then
            kN = (k - R.lastTargetPos) / SN
            FN = kN - R.targetVelocity
            kN = if FN.Magnitude > c.MAX_VELOCITY_CHANGE
              then R.targetVelocity + FN.Unit * c.MAX_VELOCITY_CHANGE
              else kN
            LN = Vector3.new(kN.X, 0, kN.Z)
            if LN.Magnitude > c.MAX_HORIZONTAL_VELOCITY then
              LN = LN.Unit * c.MAX_HORIZONTAL_VELOCITY
              kN = (Vector3.new(LN.X, kN.Y, LN.Z))
            end
            iN(R.accelerationHistory, (kN - R.targetVelocity) / SN, 4)
            iN(R.velocityHistory, kN, 8)
            iN(R.verticalVelocityHistory, kN.Y, 5)
            R.targetVelocity = kN
            R.smoothedVelocity = R.smoothedVelocity:Lerp(kN, c.VELOCITY_SMOOTHING)
          end
          R.lastTargetPos = k
          FN = qN.FloorMaterial == Enum.Material.Air
          R.airborneTime = FN and R.airborneTime + SN or 0
          if FN and R.airborneTime >= c.MIN_AIRBORNE_TIME then
            iN(R.aerialVelocityHistory, R.targetVelocity, 6)
          elseif not FN then
            R.aerialVelocityHistory = {}
          end
          qN = R.smoothedVelocity
          if FN and #R.aerialVelocityHistory > 0 then
            kN = ON(R.aerialVelocityHistory)
            qN = Vector3.new(kN.X, R.targetVelocity.Y, kN.Z) * c.AIR_CONTROL_FACTOR
          end
          LN, kN = false, Vector3.new(R.targetVelocity.X, 0, R.targetVelocity.Z)
          if kN.Magnitude > 5 then
            SN = kN.Unit
            if R.previousDirection and R.previousDirection:Dot(SN) < 0.5 then
              LN = tick() - R.lastDirectionChangeTime < c.DIRECTION_CHANGE_DETECTION_TIME
              R.lastDirectionChangeTime = tick()
            end
            R.previousDirection = SN
          end
          SN = R.currentPing + c.SERVER_TICKRATE
          local iN, ZN =
            k + qN * (if LN then SN * c.QUICK_DIRECTION_CHANGE_MULTIPLIER else SN) + ON(
              R.accelerationHistory
            ) * c.ACCELERATION_PREDICTION_WEIGHT * ((if LN
              then SN * c.QUICK_DIRECTION_CHANGE_MULTIPLIER
              else SN) * (if LN then SN * c.QUICK_DIRECTION_CHANGE_MULTIPLIER else SN) * 0.5),
            c.PREDICTION_TIME * 1.1
          iN = if FN
            then iN + qN * ZN + Vector3.new(0, -0.5 * c.GRAVITY * ZN * ZN, 0)
            else iN + qN * ZN
          LN = Vector3.new(qN.X, 0, qN.Z)
          ZN = (if LN.Magnitude > 1 then iN + LN.Unit * c.PREDICT_AHEAD else iN) - GN.Position
          YN(GN, ZN)
          if
            (k - GN.Position).Magnitude <= c.ACTIVATE_DISTANCE
            and tick() - R.lastActivationTime >= 0.3
          then
            if IN then
              pcall(IN.Activate, IN)
            end
            R.lastActivationTime = tick()
          end
          if ZN.Magnitude > c.MIN_FOLLOW_DISTANCE then
            iN = math.clamp(tonumber(J.CypherAimbotApproachSpeed) or c.FOLLOW_SPEED, 1, 120)
            GN.AssemblyLinearVelocity = ZN.Unit * iN
          else
            GN.AssemblyLinearVelocity = Vector3.new(0, GN.AssemblyLinearVelocity.Y * 0.5, 0)
          end
        end)
      end
      _cypherStartFollowing = eN
      _cypherStop = jN
      T.Aimbot = function(R)
        if R then
          if _G.__stopSpeedBoost then
            _G.__stopSpeedBoost()
          end
          if autoplayActive or y.Autoplay then
            _G.__stopAutoplay()
          end
          nN("Aimbot")
          if _G.__deactivateBatExclusive then
            _G.__deactivateBatExclusive("Aimbot")
          end
          _G.__checkAndAutoDrop(function()
            eN(u.Character)
          end)
        else
          jN()
          if _G.__refreshSpeedBoost then
            _G.__refreshSpeedBoost()
          end
        end
      end
      _G.__AkatsukiTrackStopper(jN)
    end
    T["Lagger Aimbot"] = function(R)
      if R then
        _G.__AkatsukiLaggerAimbotPreviousMode = Z
        _G.__AkatsukiLaggerAimbotPreviousAimbot = y.Aimbot == true
        _G.__AkatsukiLaggerAimbotPreviousLagger = nil
        if Z ~= "Lagger" then
          JN("Lagger")
        end
        if _G.AkatsukiLagger and _G.AkatsukiLagger.SetEnabled and _G.AkatsukiLagger.IsEnabled then
          _G.__AkatsukiLaggerAimbotPreviousLagger = _G.AkatsukiLagger.IsEnabled() == true
          pcall(_G.AkatsukiLagger.SetEnabled, true)
        else
          if _G.__openLaggerGUI then
            pcall(_G.__openLaggerGUI, false)
          end
          task.spawn(function()
            for R = 1, 30, 1 do
              if not y["Lagger Aimbot"] then
                return
              end
              if
                _G.AkatsukiLagger
                and _G.AkatsukiLagger.SetEnabled
                and _G.AkatsukiLagger.IsEnabled
              then
                _G.__AkatsukiLaggerAimbotPreviousLagger = _G.AkatsukiLagger.IsEnabled() == true
                pcall(_G.AkatsukiLagger.SetEnabled, true)
                return
              end
              task.wait(0.1)
            end
          end)
        end
        if not y.Aimbot then
          y.Aimbot = true
          if M.Aimbot then
            pcall(M.Aimbot)
          end
          if T.Aimbot then
            pcall(T.Aimbot, true)
          end
        end
      else
        if
          Z == "Lagger"
          and _G.__AkatsukiLaggerAimbotPreviousMode
          and _G.__AkatsukiLaggerAimbotPreviousMode ~= "Lagger"
        then
          JN(_G.__AkatsukiLaggerAimbotPreviousMode)
        end
        if not _G.__AkatsukiLaggerAimbotPreviousAimbot and y.Aimbot then
          y.Aimbot = false
          if M.Aimbot then
            pcall(M.Aimbot)
          end
          if T.Aimbot then
            pcall(T.Aimbot, false)
          end
        end
        if
          _G.__AkatsukiLaggerAimbotPreviousLagger == false
          and _G.AkatsukiLagger
          and _G.AkatsukiLagger.SetEnabled
        then
          pcall(_G.AkatsukiLagger.SetEnabled, false)
        end
        _G.__AkatsukiLaggerAimbotPreviousMode = nil
        _G.__AkatsukiLaggerAimbotPreviousAimbot = nil
        _G.__AkatsukiLaggerAimbotPreviousLagger = nil
      end
    end
    if y.Aimbot then
      task.defer(function()
        if y.Aimbot and T.Aimbot then
          T.Aimbot(true)
        end
      end)
    end
  end
  do
    local R, k, c = false, {}
    local LN, ON, iN =
      workspace.CurrentCamera, Color3.fromRGB(235, 50, 62), Color3.fromRGB(72, 12, 18)
    local function SN(ZN)
      if _G.__AkatsukiGuiTheme == "GUI 3" then
        return Color3.fromRGB(255, 45, 45), Color3.fromRGB(255, 45, 45)
      end
      if _G.__AkatsukiGuiTheme == "GUI 2" then
        return ON, ON
      end
      return ZN or _G.__AkatsukiThemeAccent or (Color3.fromRGB(245, 245, 250)),
        Color3.fromRGB(0, 0, 0)
    end
    local function ZN()
      local YN, jN = SN()
      local eN = { Tracer = Drawing.new("Line"), Highlight = Instance.new("Highlight"), Lines = {} }
      eN.Tracer.Color = jN
      eN.Tracer.Thickness = 3
      eN.Tracer.Transparency = 1
      eN.Tracer.ZIndex = 2
      eN.Highlight.Name = "ESP_Highlight"
      eN.Highlight.FillColor = YN
      eN.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
      eN.Highlight.FillTransparency = 0.12
      eN.Highlight.OutlineTransparency = 0.18
      eN.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
      local qN
      local KN, GN = pcall(function()
        return game:GetService("CoreGui"):FindFirstChild("RobloxGui")
      end)
      if KN and GN then
        qN = GN
      else
        qN = u:FindFirstChildOfClass("PlayerGui")
      end
      if not qN then
        qN = game:GetService("CoreGui")
      end
      pcall(function()
        eN.Highlight.Parent = qN
      end)
      YN = Instance.new("BillboardGui")
      YN.Name = "ESP_Name"
      YN.Size = UDim2.new(0, 170, 0, 28)
      YN.StudsOffset = Vector3.new(0, 1.3, 0)
      YN.AlwaysOnTop = true
      YN.Parent = qN
      GN = Instance.new("TextLabel")
      GN.Size = UDim2.new(0, 170, 0, 28)
      GN.AnchorPoint = Vector2.new(0.5, 0)
      GN.Position = UDim2.new(0.5, 0, 0, 2)
      GN.BackgroundTransparency = 1
      GN.Text = tostring(currentPresetName or "")
      GN.TextColor3 = _G.__AkatsukiGuiTheme == "GUI 3" and (Color3.fromRGB(255, 45, 45))
        or (_G.__AkatsukiGuiTheme == "GUI 2" and ON or (Color3.fromRGB(245, 245, 255)))
      GN.TextSize = 15
      GN.Font = Enum.Font.GothamBold
      GN.TextStrokeColor3 = _G.__AkatsukiGuiTheme == "GUI 2" and iN or (Color3.fromRGB(0, 0, 0))
      GN.TextStrokeTransparency = 0
      GN.TextXAlignment = Enum.TextXAlignment.Center
      GN.TextYAlignment = Enum.TextYAlignment.Center
      GN.ZIndex = 5
      GN.Parent = YN
      KN = Instance.new("UIStroke")
      KN.Color = _G.__AkatsukiGuiTheme == "GUI 2" and iN or (Color3.fromRGB(0, 0, 0))
      KN.Thickness = 2.2
      KN.Transparency = 0.12
      KN.Parent = GN
      for qN = 1, 14, 1 do
        qN = Drawing.new("Line")
        qN.Color = jN
        qN.Thickness = 2
        qN.Transparency = 1
        qN.ZIndex = 3
        table.insert(eN.Lines, qN)
      end
      eN.NameTag = YN
      eN.NameLabel = GN
      eN.NameOutline = KN
      return eN
    end
    function _G.__AkatsukiRefreshESPTheme(YN, jN)
      local jN, eN = SN(YN)
      for YN, YN in pairs(k) do
        if type(YN) == "table" and YN.esp then
          local qN = YN.esp
          if qN.Tracer then
            pcall(function()
              qN.Tracer.Color = eN
            end)
          end
          if qN.Highlight then
            qN.Highlight.FillColor = jN
            qN.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
          end
          if qN.NameLabel then
            qN.NameLabel.TextColor3 = _G.__AkatsukiGuiTheme == "GUI 3"
                and (Color3.fromRGB(255, 45, 45))
              or (_G.__AkatsukiGuiTheme == "GUI 2" and ON or (Color3.fromRGB(245, 245, 255)))
            qN.NameLabel.TextStrokeColor3 = _G.__AkatsukiGuiTheme == "GUI 2" and iN
              or (Color3.fromRGB(0, 0, 0))
          end
          if qN.NameOutline then
            qN.NameOutline.Color = _G.__AkatsukiGuiTheme == "GUI 2" and iN
              or (Color3.fromRGB(0, 0, 0))
          end
          for YN, YN in ipairs(qN.Lines or {}) do
            pcall(function()
              YN.Color = eN
            end)
          end
        end
      end
    end
    local function YN(jN)
      local eN = k[jN]
      if eN then
        if eN.esp.Tracer then
          pcall(function()
            eN.esp.Tracer:Remove()
          end)
        end
        if eN.esp.Highlight then
          pcall(function()
            eN.esp.Highlight:Destroy()
          end)
        end
        if eN.esp.NameTag then
          pcall(function()
            eN.esp.NameTag:Destroy()
          end)
        end
        for qN, qN in ipairs(eN.esp.Lines) do
          pcall(function()
            qN:Remove()
          end)
        end
        if eN.loopConn then
          pcall(function()
            eN.loopConn:Disconnect()
          end)
        end
        k[jN] = nil
      end
    end
    local function jN(eN, qN)
      if not R then
        qN.Tracer.Visible = false
        qN.Highlight.Enabled = false
        for KN, KN in ipairs(qN.Lines) do
          KN.Visible = false
        end
        return
      end
      local KN = eN.Character
      local GN, IN =
        KN and (KN:FindFirstChildOfClass("Humanoid")),
        KN and (KN:FindFirstChild("HumanoidRootPart") or KN.PrimaryPart or (KN:FindFirstChild(
          "UpperTorso"
        )) or (KN:FindFirstChild("Torso")) or (KN:FindFirstChild("Head")))
      if KN and IN and (not GN or GN.Health > 0) then
        qN.Highlight.Adornee = KN
        qN.Highlight.Enabled = y["ESP Players"] or false
        local KN, KN = LN:WorldToViewportPoint(IN.Position)
        if KN then
          qN.Tracer.Visible = false
        else
          for LN, LN in ipairs(qN.Lines) do
            LN.Visible = false
          end
        end
        if qN.NameTag and qN.NameLabel then
          pcall(function()
            qN.NameTag.Adornee = IN
            qN.NameTag.Enabled = y["ESP Players"] or false
            qN.NameLabel.Text = eN.Name or eN.DisplayName or ""
            local LN = _G.__AkatsukiGuiTheme == "GUI 2"
            qN.NameLabel.TextColor3 = _G.__AkatsukiGuiTheme == "GUI 3"
                and (Color3.fromRGB(255, 45, 45))
              or (LN and ON or (Color3.fromRGB(245, 245, 255)))
            qN.NameLabel.TextStrokeColor3 = LN and iN or (Color3.fromRGB(0, 0, 0))
            if qN.NameOutline then
              qN.NameOutline.Color = LN and iN or (Color3.fromRGB(0, 0, 0))
            end
          end)
        end
      else
        qN.Tracer.Visible = false
        qN.Highlight.Enabled = false
        qN.Highlight.Adornee = nil
        for LN, LN in ipairs(qN.Lines) do
          LN.Visible = false
        end
        if qN.NameTag and qN.NameLabel then
          pcall(function()
            qN.NameTag.Enabled = false
          end)
        end
      end
    end
    local function LN(ON)
      if ON == u then
        return
      end
      if k[ON] and k[ON].esp then
        if k[ON].esp.NameTag then
          pcall(function()
            k[ON].esp.NameTag.Enabled = y["ESP Players"] or false
          end)
        end
        return
      end
      YN(ON)
      k[ON] = { esp = ZN() }
    end
    local function ON()
      if R then
        return
      end
      R = true
      for iN, iN in pairs(z:GetPlayers()) do
        if iN ~= u then
          task.spawn(function()
            LN(iN)
          end)
        end
      end
      local iN = 0
      if c then
        c:Disconnect()
      end
      c = D.Heartbeat:Connect(function(ZN)
        iN += ZN or 0
        if iN < 0.5 then
          return
        end
        iN = 0
        for iN, ZN in pairs(k) do
          if typeof(iN) == "Instance" and (iN:IsA("Player")) and ZN and ZN.esp then
            pcall(function()
              jN(iN, ZN.esp)
            end)
          end
        end
      end)
      local iN, ZN =
        z.PlayerAdded:Connect(function(jN)
          if not R or jN == u then
            return
          end
          task.wait(0.3)
          LN(jN)
        end), z.PlayerRemoving:Connect(function(LN)
          YN(LN)
        end)
      k._joinConn = iN
      k._leaveConn = ZN
    end
    local function LN()
      R = false
      if c then
        c:Disconnect()
        c = nil
      end
      if k._joinConn then
        pcall(function()
          k._joinConn:Disconnect()
        end)
        k._joinConn = nil
      end
      if k._leaveConn then
        pcall(function()
          k._leaveConn:Disconnect()
        end)
        k._leaveConn = nil
      end
      for R in pairs(k) do
        if typeof(R) == "Instance" and (R:IsA("Player")) and R ~= u then
          YN(R)
        end
      end
    end
    _G.__AkatsukiTrackStopper(LN)
    T["ESP Players"] = function(R)
      if R then
        ON()
      else
        LN()
      end
    end
    if y["ESP Players"] then
      ON()
    end
    local R = _G.__AkatsukiPlayerTracerLine
    if R then
      pcall(function()
        R:Remove()
      end)
    end
    local R = Instance.new("ScreenGui")
    R.Name = "AkatsukiPlayerTracerOverlay"
    R.IgnoreGuiInset = true
    R.ResetOnSpawn = false
    R.DisplayOrder = 1000
    R.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    R.Parent = u:WaitForChild("PlayerGui")
    local k = Instance.new("Frame")
    k.Name = "ESPLine"
    k.AnchorPoint = Vector2.new(0.5, 0.5)
    k.BorderSizePixel = 0
    k.Active = false
    k.Visible = false
    k.ZIndex = 1
    k.Parent = R
    _N = Instance.new("UIStroke", k)
    _N.Color = Color3.fromRGB(255, 255, 255)
    _N.Thickness = 0.7
    _N.Transparency = 0.45
    _G.__AkatsukiPlayerTracerLine = {
      Remove = function()
        R:Destroy()
      end,
    }
    _G.__AkatsukiTrackStopper(function()
      R:Destroy()
    end)
    local R = { scanElapsed = math.huge, targetRoot = nil }
    _G.__AkatsukiTrackConn(D.RenderStepped:Connect(function(c)
      if not y["Player Tracers"] then
        if k.Visible then
          k.Visible = false
        end
        R.targetRoot = nil
        R.scanElapsed = math.huge
        return
      end
      if
        not pcall(function()
          local _N, LN = workspace.CurrentCamera, u.Character
          local ON = LN
            and (
              LN:FindFirstChild("LowerTorso")
              or (LN:FindFirstChild("HumanoidRootPart"))
              or (LN:FindFirstChild("Torso"))
            )
          if not _N or not ON then
            k.Visible = false
            return
          end
          LN = ON.Position
          R.scanElapsed = R.scanElapsed + (c or 0)
          local c = R.targetRoot
          local iN = c and c.Parent
          local ZN = iN and (iN:FindFirstChildOfClass("Humanoid"))
          iN = c and c.Parent and (not ZN or ZN.Health > 0)
          if R.scanElapsed >= 0.12 or not iN then
            R.scanElapsed = 0
            ZN, c = math.huge
            for YN, jN in ipairs(z:GetPlayers()) do
              if jN ~= u then
                YN = jN.Character
                local jN, eN =
                  YN and (YN:FindFirstChildOfClass("Humanoid")),
                  YN
                    and (
                      YN:FindFirstChild("HumanoidRootPart")
                      or (YN:FindFirstChild("LowerTorso"))
                      or (YN:FindFirstChild("Torso"))
                    )
                if eN and (eN:IsA("BasePart")) and (not jN or jN.Health > 0) then
                  local YN = eN.Position - LN
                  local jN = YN:Dot(YN)
                  if jN < ZN then
                    ZN, c = jN, eN
                  end
                end
              end
            end
            R.targetRoot = c
          end
          c = R.targetRoot
          if not c or not c.Parent then
            k.Visible = false
            return
          end
          ZN, iN = c.Position, _N:WorldToViewportPoint(LN - Vector3.new(0, ON.Size.Y * 0.35, 0))
          c, LN = _N:WorldToViewportPoint(ZN)
          local R, YN, jN = _N.ViewportSize, Vector2.new(iN.X, iN.Y), Vector2.new(c.X, c.Y)
          if not LN or c.Z <= 0 then
            ON = R * 0.5
            _N = jN - ON
            _N = if (if c.Z <= 0 then -_N else _N).Magnitude < 0.001
              then (Vector2.new(0, -1))
              else if c.Z <= 0 then -_N else _N
            ZN = Vector2.new(math.max(8, ON.X - 8), math.max(8, ON.Y - 8))
            local c, LN =
              ZN.X / math.max(math.abs(_N.X), 0.001), ZN.Y / math.max(math.abs(_N.Y), 0.001)
            jN = ON + _N * math.min(c, LN)
          end
          YN = if iN.Z <= 0
              or YN.X < 0
              or YN.X > R.X
              or YN.Y < 0
              or YN.Y > R.Y
            then (Vector2.new(R.X * 0.5, R.Y - 8))
            else YN
          R, ON = jN - YN, (YN + jN) * 0.5
          k.Position = UDim2.fromOffset(ON.X, ON.Y)
          k.Size = UDim2.fromOffset(math.max(R.Magnitude, 1), 2)
          k.Rotation = math.deg(math.atan2(R.Y, R.X))
          ON, iN = SN()
          k.BackgroundColor3 = iN
          k.Visible = true
        end)
      then
        pcall(function()
          k.Visible = false
        end)
      end
    end))
  end
  local function R(k, c, _N)
    local LN = Instance.new("Frame")
    LN.Name = tostring(_N or c or "Input") .. "Stub"
    LN.BackgroundTransparency = 1
    LN.Visible = false
    LN.Parent = k
    return {
      container = LN,
      input = nil,
      activeRef = function()
        return y[_N] == true
      end,
    }
  end
  local k, c = {}, { "Movement", "Combat", "Visuals", "Animations" }
  local function _N(LN)
    local ON = Instance.new("ScrollingFrame", QN)
    ON.Name = LN .. "PageStub"
    ON.BackgroundTransparency = 1
    ON.BorderSizePixel = 0
    ON.ScrollBarThickness = 0
    ON.Visible = false
    k[LN] = ON
  end
  for QN, QN in ipairs(c) do
    _N(QN)
  end
  (function(QN)
    if not k[QN] then
      return
    end
    for LN, ON in pairs(k) do
      ON.Visible = LN == QN
    end
  end)("Movement")
  _speedCardRefs = _speedCardRefs or {}
  local function QN(LN, ON, iN, SN, SN, ZN)
    SN = Instance.new("Frame")
    SN.Name = tostring(iN or ON or "Speed") .. "SpeedStub"
    SN.BackgroundTransparency = 1
    SN.Visible = false
    SN.Parent = LN
    if ZN then
      FeatureToggles[ZN] = function()
        JN(iN)
      end
    end
    return SN
  end
  local LN = aN(k.Movement, "SPEED")
  QN(LN, "Normal Speed", "Normal", "NormalBoost", "NormalSteal", "SelectNormalMode")
  QN(LN, "Lagger Speed", "Lagger", "LaggerBoost", "LaggerSteal", "SelectLaggerMode")
  local function ON(iN)
    local SN, ZN, YN =
      "SelectCustomMode_" .. iN.name, "CustomBoost_" .. iN.name, "CustomSteal_" .. iN.name
    J[ZN] = iN.boost
    J[YN] = iN.steal
    FeatureToggles[SN] = function()
      JN(iN.name)
    end
    local jN = QN(LN, iN.name, iN.name, ZN, YN, SN)
    YN = Instance.new("TextButton", jN)
    YN.Size = UDim2.new(0, 18, 0, 18)
    YN.AnchorPoint = Vector2.new(1, 1)
    YN.Position = UDim2.new(1, -8, 1, -8)
    YN.ZIndex = 30
    YN.BackgroundColor3 = Color3.fromRGB(240, 200, 200)
    YN.BorderSizePixel = 0
    YN.Text = "x"
    YN.TextColor3 = Color3.fromRGB(180, 60, 60)
    YN.TextSize = 11
    YN.Font = Enum.Font.GothamBold
    YN.AutoButtonColor = false
    YN.TextXAlignment = Enum.TextXAlignment.Center
    YN.TextYAlignment = Enum.TextYAlignment.Center
    Instance.new("UICorner", YN).CornerRadius = UDim.new(0, 4)
    v(YN, function()
      for QN = #L, 1, -1 do
        if L[QN].name == iN.name then
          table.remove(L, QN)
          break
        end
      end
      if Z == iN.name then
        JN("Normal")
      end
      pcall(function()
        jN:Destroy()
      end)
      oN()
    end)
    return jN
  end
  for QN, QN in ipairs(L) do
    pcall(function()
      ON(QN)
    end)
  end
  do
    c = Instance.new("TextButton", LN)
    c.Size = UDim2.new(1, -2, 0, 28)
    c.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
    c.BackgroundTransparency = 0.55
    c.BorderSizePixel = 0
    c.Text = "+ Add Custom Speed"
    c.TextColor3 = Color3.fromRGB(235, 70, 80)
    c.TextSize = 11
    c.Font = Enum.Font.GothamBold
    c.AutoButtonColor = false
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 6)
    UN = Instance.new("UIStroke", c)
    UN.Color = Color3.fromRGB(0, 0, 0)
    UN.Thickness = 1
    UN.Transparency = 0.3
    local QN
    v(c, function()
      if QN then
        pcall(function()
          QN:Destroy()
        end)
        QN = nil
        return
      end
      QN = Instance.new("Frame", LN)
      QN.Size = UDim2.new(1, -2, 0, 96)
      QN.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
      QN.BorderSizePixel = 0
      Instance.new("UICorner", QN).CornerRadius = UDim.new(0, 6)
      local UN = Instance.new("UIStroke", QN)
      UN.Color = Color3.fromRGB(0, 0, 0)
      UN.Thickness = 1
      UN = Instance.new("TextLabel", QN)
      UN.Size = UDim2.new(0, 40, 0, 14)
      UN.Position = UDim2.new(0, 8, 0, 6)
      UN.BackgroundTransparency = 1
      UN.Text = "Name"
      UN.TextColor3 = Color3.fromRGB(168, 168, 176)
      UN.TextSize = 9
      UN.Font = Enum.Font.GothamBold
      UN.TextXAlignment = Enum.TextXAlignment.Left
      local LN = Instance.new("TextBox", QN)
      LN.Size = UDim2.new(0, 120, 0, 20)
      LN.Position = UDim2.new(0, 8, 0, 21)
      LN.BackgroundColor3 = Color3.fromRGB(38, 38, 43)
      LN.BorderSizePixel = 0
      LN.Text = ""
      LN.PlaceholderText = "My Speed"
      LN.Font = Enum.Font.GothamBold
      LN.TextSize = 11
      LN.TextColor3 = Color3.fromRGB(205, 42, 54)
      LN.ClearTextOnFocus = false
      Instance.new("UICorner", LN).CornerRadius = UDim.new(0, 4)
      UN = Instance.new("UIStroke", LN)
      UN.Color = Color3.fromRGB(0, 0, 0)
      UN.Thickness = 1
      UN = Instance.new("TextLabel", QN)
      UN.Size = UDim2.new(0, 50, 0, 14)
      UN.Position = UDim2.new(0, 140, 0, 6)
      UN.BackgroundTransparency = 1
      UN.Text = "Boost"
      UN.TextColor3 = Color3.fromRGB(168, 168, 176)
      UN.TextSize = 9
      UN.Font = Enum.Font.GothamBold
      UN.TextXAlignment = Enum.TextXAlignment.Left
      local iN = Instance.new("TextBox", QN)
      iN.Size = UDim2.new(0, 56, 0, 20)
      iN.Position = UDim2.new(0, 140, 0, 21)
      iN.BackgroundColor3 = Color3.fromRGB(34, 34, 39)
      iN.BorderSizePixel = 0
      iN.Text = "59"
      iN.Font = Enum.Font.GothamBold
      iN.TextSize = 12
      iN.TextColor3 = Color3.fromRGB(205, 42, 54)
      iN.TextXAlignment = Enum.TextXAlignment.Center
      iN.ClearTextOnFocus = false
      Instance.new("UICorner", iN).CornerRadius = UDim.new(0, 5)
      UN = Instance.new("UIStroke", iN)
      UN.Color = Color3.fromRGB(0, 0, 0)
      UN.Thickness = 1
      UN = Instance.new("TextLabel", QN)
      UN.Size = UDim2.new(0, 50, 0, 14)
      UN.Position = UDim2.new(0, 204, 0, 6)
      UN.BackgroundTransparency = 1
      UN.Text = "Steal"
      UN.TextColor3 = Color3.fromRGB(168, 168, 176)
      UN.TextSize = 9
      UN.Font = Enum.Font.GothamBold
      UN.TextXAlignment = Enum.TextXAlignment.Left
      local SN = Instance.new("TextBox", QN)
      SN.Size = UDim2.new(0, 56, 0, 20)
      SN.Position = UDim2.new(0, 204, 0, 21)
      SN.BackgroundColor3 = Color3.fromRGB(34, 34, 39)
      SN.BorderSizePixel = 0
      SN.Text = "29"
      SN.Font = Enum.Font.GothamBold
      SN.TextSize = 12
      SN.TextColor3 = Color3.fromRGB(205, 42, 54)
      SN.TextXAlignment = Enum.TextXAlignment.Center
      SN.ClearTextOnFocus = false
      Instance.new("UICorner", SN).CornerRadius = UDim.new(0, 5)
      UN = Instance.new("UIStroke", SN)
      UN.Color = Color3.fromRGB(0, 0, 0)
      UN.Thickness = 1
      iN.InputChanged:Connect(function(ZN)
        if ZN.UserInputType == Enum.UserInputType.TextInput then
          iN.Text = iN.Text:gsub("[^0-9]", "")
        end
      end)
      SN.InputChanged:Connect(function(ZN)
        if ZN.UserInputType == Enum.UserInputType.TextInput then
          SN.Text = SN.Text:gsub("[^0-9]", "")
        end
      end)
      UN = Instance.new("TextButton", QN)
      UN.Size = UDim2.new(1, -16, 0, 24)
      UN.Position = UDim2.new(0, 8, 0, 50)
      UN.BackgroundColor3 = Color3.fromRGB(210, 42, 52)
      UN.BorderSizePixel = 0
      UN.Text = "Add Speed"
      UN.TextColor3 = Color3.fromRGB(255, 255, 255)
      UN.TextSize = 11
      UN.Font = Enum.Font.GothamBold
      UN.AutoButtonColor = false
      Instance.new("UICorner", UN).CornerRadius = UDim.new(0, 5)
      local ZN = Instance.new("TextLabel", QN)
      ZN.Size = UDim2.new(1, -16, 0, 14)
      ZN.Position = UDim2.new(0, 8, 0, 78)
      ZN.BackgroundTransparency = 1
      ZN.Text = ""
      ZN.TextColor3 = Color3.fromRGB(200, 60, 60)
      ZN.TextSize = 9
      ZN.Font = Enum.Font.GothamBold
      ZN.TextXAlignment = Enum.TextXAlignment.Left
      v(UN, function()
        local UN, YN, jN = LN.Text:match("^%s*(.-)%s*$"), tonumber(iN.Text), tonumber(SN.Text)
        if not UN or #UN < 1 then
          ZN.Text = "Enter a name"
          return
        end
        if not YN or YN < 1 or YN > 200 then
          ZN.Text = "Boost: 1-200"
          return
        end
        if not jN or jN < 1 or jN > 200 then
          ZN.Text = "Steal: 1-200"
          return
        end
        for LN, LN in ipairs(L) do
          if LN.name == UN then
            ZN.Text = "Name already exists"
            return
          end
        end
        if UN == "Normal" or UN == "Lagger" or UN == "Desync" then
          ZN.Text = "Reserved name"
          return
        end
        local LN = { name = UN, boost = YN, steal = jN }
        table.insert(L, LN)
        pcall(function()
          ON(LN)
        end)
        pcall(function()
          QN:Destroy()
        end)
        QN = nil
        oN()
      end)
    end)
  end
  for QN, QN in ipairs(_speedCardRefs) do
    if QN.updateVisual then
      pcall(QN.updateVisual)
    end
  end
  U = aN(k.Movement, "MOVEMENT")
  c = nil
  for QN, QN in ipairs(hN(U, "Auto Play", "Autoplay"):GetChildren()) do
    if QN:IsA("TextButton") then
      c = QN
      break
    end
  end
  if c then
    _N = Instance.new("TextButton", c)
    _N.Name = "AutoplayModeButton"
    _N.Size = UDim2.new(0, 56, 0, 20)
    _N.Position = UDim2.new(1, -120, 0.5, -10)
    _N.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    _N.BorderSizePixel = 0
    _N.Text = string.upper(_G.__autoplayMode or "Full")
    _N.TextColor3 = Color3.fromRGB(238, 238, 242)
    _N.TextSize = 10
    _N.Font = Enum.Font.GothamBold
    _N.AutoButtonColor = false
    _N.ZIndex = 10
    Instance.new("UICorner", _N).CornerRadius = UDim.new(0, 4)
    local QN = Instance.new("UIStroke", _N)
    QN.Color = Color3.fromRGB(255, 255, 255)
    QN.Thickness = 1
    QN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    t()
  end
  fN(U, "Auto Carry Speed", "Auto Carry Speed")
  do
    local QN = hN(U, "Carry Speed", "Carry Speed")
    local UN
    for LN, LN in ipairs(QN:GetChildren()) do
      if LN:IsA("TextButton") then
        UN = LN
        break
      end
    end
    pcall(function()
      styleSmallToggle(QN)
    end)
    if UN then
      local QN = Instance.new("TextButton", UN)
      QN.Size = UDim2.new(0, 56, 0, 20)
      QN.Position = UDim2.new(1, -120, 0.5, -10)
      QN.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
      QN.BorderSizePixel = 0
      QN.Text = "V1"
      QN.TextColor3 = Color3.fromRGB(238, 238, 242)
      QN.TextSize = 10
      QN.Font = Enum.Font.GothamBold
      QN.AutoButtonColor = false
      QN.ZIndex = 10
      Instance.new("UICorner", QN).CornerRadius = UDim.new(0, 4)
      _N = Instance.new("UIStroke", QN)
      _N.Color = Color3.fromRGB(255, 255, 255)
      _N.Thickness = 1
      _N.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      local function LN()
        for ON, ON in ipairs(UN:GetChildren()) do
          if
            ON:IsA("TextButton")
            and ON ~= QN
            and ON.Size.X.Offset == 48
            and ON.Position.X.Scale == 1
            and ON.Position.X.Offset == -54
          then
            return ON
          end
        end
        return nil
      end
      local function UN()
        G = "v1"
        QN.Text = "V1"
        QN.TextColor3 = Color3.fromRGB(238, 238, 242)
        QN.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        QN.Position = UDim2.new(1, -120, 0.5, -10)
        local ON = LN()
        if ON then
          ON.Visible = true
        end
      end
      local function ON()
        G = "v2"
        QN.Text = "V2"
        QN.TextColor3 = Color3.fromRGB(238, 238, 242)
        QN.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        QN.Position = UDim2.new(1, -120, 0.5, -10)
        local QN = LN()
        if QN then
          QN.Visible = true
        end
      end
      if G == "v2" then
        ON()
      else
        UN()
      end
      t()
    end
  end
  pcall(function()
    if _G and _G.__setNoPlayerCollision then
      _G.__setNoPlayerCollision(true)
    end
  end)
  local function t(QN)
    if not QN then
      return
    end
    pcall(function()
      QN.Size = UDim2.new(1, -2, 0, GUI_METRICS.compactCardH)
      for UN, LN in ipairs(QN:GetChildren()) do
        if LN:IsA("TextButton") then
          LN.Size = UDim2.new(1, 0, 0, GUI_METRICS.compactCardH)
          LN.BackgroundColor3 = Color3.fromRGB(25, 25, 29)
          LN.BackgroundTransparency = 0.35
          LN.BorderSizePixel = 0
          LN.ZIndex = 21
          UN = LN:FindFirstChildOfClass("UICorner")
          if UN then
            UN.CornerRadius = UDim.new(0, 5)
          else
            Instance.new("UICorner", LN).CornerRadius = UDim.new(0, 5)
          end
          local QN = LN:FindFirstChildOfClass("UIStroke")
          if QN then
            QN.Color = Color3.fromRGB(0, 0, 0)
            QN.Thickness = 1
            QN.Transparency = 0
          end
          break
        end
      end
    end)
  end
  pcall(function()
    local QN = s and s.Autoplay
    if QN and QN.card and QN.card.Parent then
      t(QN.card.Parent)
    end
  end)
  pcall(function()
    local QN = s and s["Carry Speed"]
    if QN and QN.card and QN.card.Parent then
      t(QN.card.Parent)
    end
  end)
  pcall(function()
    local QN = s and s["TP Bat"]
    if QN and QN.card and QN.card.Parent then
      t(QN.card.Parent)
    end
  end)
  _G.__AkatsukiInfJumpMode = _G.__AkatsukiInfJumpMode or "hold"
  fN(U, "Unwalk", "Unwalk")
  _N = fN(U, "Inf Jump", "Inf Jump")
  if _N then
    local QN = Instance.new("TextButton", _N)
    QN.Name = "InfJumpModeBtn"
    QN.Size = UDim2.new(0, 66, 0, 20)
    QN.Position = UDim2.new(1, -74, 0.5, -10)
    QN.AnchorPoint = Vector2.new(0, 0)
    QN.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    QN.BorderSizePixel = 0
    QN.Text = _G.__AkatsukiInfJumpMode == "hold" and "HOLD" or "MANUAL"
    QN.TextColor3 = Color3.fromRGB(238, 238, 242)
    QN.Font = Enum.Font.GothamBold
    QN.TextSize = 10
    QN.AutoButtonColor = false
    QN.ZIndex = 30
    Instance.new("UICorner", QN).CornerRadius = UDim.new(0, 4)
    local UN = Instance.new("UIStroke", QN)
    UN.Color = Color3.fromRGB(255, 255, 255)
    UN.Thickness = 1
    UN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local function LN()
      QN.Text = _G.__AkatsukiInfJumpMode == "hold" and "HOLD" or "MANUAL"
      QN.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
      QN.TextColor3 = Color3.fromRGB(238, 238, 242)
      UN.Color = Color3.fromRGB(255, 255, 255)
      UN.Thickness = 1
      QN.TextStrokeTransparency = 1
    end
    LN()
    v(QN, function()
      _G.__AkatsukiInfJumpMode = _G.__AkatsukiInfJumpMode == "hold" and "manual" or "hold"
      LN()
      if y["Inf Jump"] then
        if _G.__AkatsukiInfJumpMode == "hold" then
          startInfJump()
        else
          stopInfJump()
        end
      end
    end)
  end
  local QN = hN(U, "TP Down", "TP Down")
  pcall(function()
    t(QN)
  end)
  R(U, "Auto TP Down", "Auto TP Down")
  _N = aN(k.Combat, "COMBAT")
  hN(_N, "Anti Bat", "Anti Bat")
  fN(_N, "Anti Ragdoll", "Anti Ragdoll")
  fN(_N, "Ragdoll Counter", "Ragdoll Counter")
  fN(_N, "Medusa Counter", "Medusa Counter")
  function _G.__AkatsukiAntiDieGuiEnabled()
    return y["Anti Die"] == true
  end
  T["Anti Die"] = function(U)
    pcall(function()
      if _G.__AkatsukiAntiDieSource then
        _G.__AkatsukiAntiDieSource("toggle", U)
      end
    end)
  end
  fN(_N, "Anti Die", "Anti Die")
  T["Anti Die"](y["Anti Die"] == true)
  do
    local U = hN(_N, "Aimbot", "Aimbot")
    pcall(function()
      t(U)
    end)
  end
  pcall(t, (hN(_N, "Lagger Aimbot", "Lagger Aimbot")))
  do
    local U = hN(_N, "TP Bat", "TP Bat", function(QN)
      local UN = QN.Parent
      local LN = UN and (UN:FindFirstChildOfClass("TextButton"))
      if not LN then
        return 28
      end
      local ON = Instance.new("TextButton", LN)
      ON.Name = "BatVersionToggle"
      ON.Size = UDim2.new(0, 64, 0, 22)
      ON.Position = UDim2.new(1, -118, 0.5, -11)
      ON.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
      ON.BorderSizePixel = 0
      ON.Text = "V" .. tostring(_G.__batVersion or 1)
      ON.TextColor3 = Color3.fromRGB(238, 238, 242)
      ON.Font = Enum.Font.GothamBold
      ON.TextSize = 10
      ON.AutoButtonColor = false
      ON.Active = false
      ON.Selectable = false
      ON.Visible = false
      ON.ZIndex = 30
      Instance.new("UICorner", ON).CornerRadius = UDim.new(0, 4)
      local iN = Instance.new("UIStroke", ON)
      iN.Color = Color3.fromRGB(255, 255, 255)
      iN.Thickness = 1
      iN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      local SN = Instance.new("TextButton", LN)
      SN.Name = "BatConfigToggle"
      SN.Size = UDim2.new(0, p and 50 or 64, 0, p and 18 or 22)
      SN.Position = UDim2.new(1, p and -88 or -118, 0.5, p and -9 or -11)
      SN.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
      SN.BorderSizePixel = 0
      SN.Text = ""
      SN.AutoButtonColor = false
      SN.ZIndex = 30
      Instance.new("UICorner", SN).CornerRadius = UDim.new(0, 4)
      local ZN = Instance.new("UIStroke", SN)
      ZN.Color = Color3.fromRGB(180, 180, 186)
      ZN.Thickness = 1
      ZN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      LN = Instance.new("TextLabel", SN)
      LN.Size = UDim2.new(0, 30, 1, 0)
      LN.Position = UDim2.new(0, 5, 0, 0)
      LN.BackgroundTransparency = 1
      LN.Text = "GUI"
      LN.TextColor3 = Color3.fromRGB(235, 240, 250)
      LN.Font = Enum.Font.GothamBold
      LN.TextSize = 8
      LN.TextXAlignment = Enum.TextXAlignment.Left
      LN.ZIndex = 31
      local YN = Instance.new("Frame", SN)
      YN.Size = UDim2.new(0, 24, 0, 12)
      YN.Position = UDim2.new(1, -29, 0.5, -6)
      YN.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
      YN.BorderSizePixel = 0
      YN.ZIndex = 31
      Instance.new("UICorner", YN).CornerRadius = UDim.new(1, 0)
      local jN = Instance.new("Frame", YN)
      jN.Size = UDim2.new(0, 8, 0, 8)
      jN.Position = UDim2.new(0, 2, 0.5, -4)
      jN.BackgroundColor3 = Color3.fromRGB(170, 170, 176)
      jN.BorderSizePixel = 0
      jN.ZIndex = 32
      Instance.new("UICorner", jN).CornerRadius = UDim.new(1, 0)
      LN = Instance.new("Frame", QN)
      LN.Name = "BatV2DistanceConfig"
      LN.Size = UDim2.new(1, -2, 0, 78)
      LN.Position = UDim2.new(0, 1, 0, 4)
      LN.BackgroundColor3 = Color3.fromRGB(25, 25, 29)
      LN.BackgroundTransparency = 0.2
      LN.BorderSizePixel = 0
      LN.ZIndex = 22
      Instance.new("UICorner", LN).CornerRadius = UDim.new(0, 6)
      local eN = Instance.new("UIStroke", LN)
      eN.Color = Color3.fromRGB(88, 34, 40)
      eN.Transparency = 0.25
      eN.Thickness = 1
      eN = Instance.new("TextLabel", LN)
      eN.Size = UDim2.new(1, -92, 0, 38)
      eN.Position = UDim2.new(0, 10, 0, 0)
      eN.BackgroundTransparency = 1
      eN.Text = "DISTANCIA TP (STUDS)"
      eN.TextColor3 = Color3.fromRGB(198, 198, 205)
      eN.Font = Enum.Font.GothamBold
      eN.TextSize = 10
      eN.TextXAlignment = Enum.TextXAlignment.Left
      eN.ZIndex = 23
      local qN = Instance.new("TextBox", LN)
      qN.Name = "BatV2DistanceInput"
      qN.Size = UDim2.new(0, 70, 0, 26)
      qN.Position = UDim2.new(1, -80, 0, 6)
      qN.BackgroundColor3 = Color3.fromRGB(15, 20, 29)
      qN.BackgroundTransparency = 0.05
      qN.BorderSizePixel = 0
      qN.ClearTextOnFocus = false
      qN.Text = tostring(_G.__tpBatV2Distance or 8)
      qN.TextColor3 = Color3.fromRGB(245, 248, 255)
      qN.Font = Enum.Font.GothamBold
      qN.TextSize = 11
      qN.TextXAlignment = Enum.TextXAlignment.Center
      qN.ZIndex = 24
      Instance.new("UICorner", qN).CornerRadius = UDim.new(0, 4)
      eN = Instance.new("UIStroke", qN)
      eN.Color = Color3.fromRGB(185, 58, 66)
      eN.Transparency = 0.2
      eN.Thickness = 1
      _.distanceInput = qN
      eN = Instance.new("TextLabel", LN)
      eN.Size = UDim2.new(1, -92, 0, 34)
      eN.Position = UDim2.new(0, 10, 0, 40)
      eN.BackgroundTransparency = 1
      eN.Text = "VERSION TP BAT"
      eN.TextColor3 = Color3.fromRGB(198, 198, 205)
      eN.Font = Enum.Font.GothamBold
      eN.TextSize = 10
      eN.TextXAlignment = Enum.TextXAlignment.Left
      eN.ZIndex = 23
      eN.Visible = true
      local eN = Instance.new("TextButton", LN)
      eN.Name = "BatVersionInsideConfig"
      eN.Size = UDim2.new(0, 70, 0, 26)
      eN.Position = UDim2.new(1, -80, 0, 44)
      eN.BackgroundColor3 = Color3.fromRGB(118, 30, 38)
      eN.BorderSizePixel = 0
      eN.Text = "V" .. tostring(_G.__batVersion or 1)
      eN.TextColor3 = Color3.fromRGB(245, 248, 255)
      eN.Font = Enum.Font.GothamBold
      eN.TextSize = 11
      eN.AutoButtonColor = false
      eN.Active = true
      eN.Visible = true
      eN.ZIndex = 24
      Instance.new("UICorner", eN).CornerRadius = UDim.new(0, 4)
      local LN = Instance.new("UIStroke", eN)
      LN.Color = Color3.fromRGB(245, 88, 98)
      LN.Transparency = 0.15
      LN.Thickness = 1
      local KN = false
      local function GN()
        local IN = KN
        SN.Visible = true
        SN.BackgroundColor3 = IN and (Color3.fromRGB(118, 30, 38)) or (Color3.fromRGB(45, 48, 58))
        ZN.Color = IN and (Color3.fromRGB(245, 88, 98)) or (Color3.fromRGB(180, 180, 186))
        YN.BackgroundColor3 = IN and (Color3.fromRGB(195, 36, 48)) or (Color3.fromRGB(25, 27, 33))
        jN.BackgroundColor3 = IN and (Color3.fromRGB(245, 248, 255))
          or (Color3.fromRGB(170, 170, 176))
        jN.Position = IN and (UDim2.new(1, -10, 0.5, -4)) or (UDim2.new(0, 2, 0.5, -4))
        QN.Visible = IN
        QN.Size = UDim2.new(1, 0, 0, IN and 86 or 0)
        UN.Size = UDim2.new(1, -2, 0, IN and GUI_METRICS.toggleH + 86 or GUI_METRICS.toggleH)
      end
      v(SN, function()
        KN = not KN
        GN()
      end)
      qN.FocusLost:Connect(function()
        _.controller.SetV2Distance(qN.Text)
      end)
      _.versionPill = ON
      _G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
      local function SN()
        _G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
        ON.Text = "V" .. tostring(_G.__batVersion or 1)
        ON.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
        ON.TextColor3 = Color3.fromRGB(245, 248, 255)
        iN.Color = Color3.fromRGB(220, 225, 235)
        eN.Text = "V" .. tostring(_G.__batVersion or 1)
        eN.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
        LN.Color = Color3.fromRGB(220, 225, 235)
        qN.TextEditable = true
        qN.Text = tostring(_G.__tpBatV2Distance or 8)
        qN.BackgroundTransparency = 0.05
        qN.TextColor3 = Color3.fromRGB(245, 248, 255)
        GN()
      end
      _.updateVersionButton = SN
      SN()
      v(ON, function()
        _.controller.SetVersion(_G.__batVersion == 1 and 2 or 1)
      end)
      v(eN, function()
        _.controller.SetVersion(_G.__batVersion == 1 and 2 or 1)
      end)
      QN.Size = UDim2.new(1, 0, 0, 0)
      QN.Visible = false
      UN.Size = UDim2.new(1, -2, 0, GUI_METRICS.toggleH)
      task.defer(GN)
      return 0
    end)
    pcall(function()
      t(U)
    end)
  end
  (function()
    pcall(function()
      local U = workspace:FindFirstChild("AkatsukiTPBatLastPosition")
      if U then
        U:Destroy()
      end
    end)
    local U = {
      enabled = false,
      heartbeat = nil,
      target = nil,
      samples = {},
      swingLocked = false,
      nextSwingAt = 0,
      lastSafeCFrame = nil,
      lastPosition = nil,
      lastSampleTime = 0,
      recoverUntil = 0,
      physicsPauseUntil = 0,
      previousAutoRotate = nil,
      lastTargetMarker = nil,
      markerLocked = false,
      markerTarget = nil,
      markerBodyLock = nil,
      markerBodyAttachment = nil,
    }
    _G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
    local function QN()
      local UN = u.Character
      if not UN then
        return nil, nil, nil
      end
      return UN, UN:FindFirstChild("HumanoidRootPart"), UN:FindFirstChildOfClass("Humanoid")
    end
    local function UN(LN)
      return LN ~= nil
        and LN.X == LN.X
        and LN.Y == LN.Y
        and LN.Z == LN.Z
        and math.abs(LN.X) < 10000000
        and math.abs(LN.Y) < 10000000
        and math.abs(LN.Z) < 10000000
    end
    local function LN(ON, iN, SN, ZN)
      local YN = Vector3.new(iN.X - ON.X, 0, iN.Z - ON.Z)
      if YN.Magnitude > 0.05 then
        return CFrame.lookAt(ON, ON + YN.Unit)
      end
      iN = SN and (Vector3.new(SN.X, 0, SN.Z)) or nil
      if iN and iN.Magnitude >= 0.01 then
        return CFrame.lookAt(ON, ON + iN.Unit)
      end
      if ZN then
        iN, SN = ZN:ToEulerAnglesYXZ()
        return CFrame.new(ON) * CFrame.Angles(0, SN, 0)
      end
      return CFrame.new(ON)
    end
    local function ON(iN, SN)
      if not iN or not SN then
        return nil
      end
      local ZN = SN.Position
      local YN = Vector3.new(iN.Position.X - ZN.X, 0, iN.Position.Z - ZN.Z)
      if YN.Magnitude <= 0.05 then
        local jN = SN.CFrame.LookVector
        YN = (Vector3.new(-jN.X, 0, -jN.Z))
      end
      return LN(
        ZN + (if YN.Magnitude <= 0.05 then (Vector3.new(0, 0, 1)) else YN).Unit * 3,
        ZN,
        SN.CFrame.LookVector,
        iN.CFrame
      )
    end
    local function LN()
      if U.markerBodyLock then
        pcall(function()
          U.markerBodyLock:Destroy()
        end)
        U.markerBodyLock = nil
      end
      if U.markerBodyAttachment then
        pcall(function()
          U.markerBodyAttachment:Destroy()
        end)
        U.markerBodyAttachment = nil
      end
    end
    local function iN(SN, SN)
      LN()
    end
    _.applyMarkerBodyLock = iN
    _.clearMarkerBodyLock = LN
    local function SN(ZN, YN)
      if not ZN or not YN then
        return false
      end
      local jN = U and U.lastTargetMarker
      if jN and jN.Parent and jN.Transparency and jN.Transparency < 1 then
        return false
      end
      return (
        pcall(function()
          ZN.AssemblyLinearVelocity = Vector3.zero
          ZN.AssemblyAngularVelocity = Vector3.zero
          ZN.CFrame = YN
          ZN.AssemblyLinearVelocity = Vector3.zero
          ZN.AssemblyAngularVelocity = Vector3.zero
        end)
      )
    end
    local ZN, YN, jN, eN, qN, KN = -536.2, -422, -10, 75, -71.8, 192.9
    local function GN(IN)
      if not IN then
        return false
      end
      return IN.X >= ZN and IN.X <= YN and IN.Y >= jN and IN.Y <= eN and IN.Z >= qN and IN.Z <= KN
    end
    _.isInsideMap = GN
    local function ZN(YN)
      if U.markerLocked then
        return
      end
      local jN = U.markerTarget
      local eN = jN and jN.Parent == z and jN.Character
      local qN, KN =
        eN and (eN:FindFirstChild("HumanoidRootPart")),
        eN and (eN:FindFirstChildOfClass("Humanoid"))
      if not qN or not KN or KN.Health <= 0 or not UN(qN.Position) or (GN(qN.Position)) then
        return
      end
      if not YN or not GN(YN.Position) then
        return
      end
      jN, KN = CFrame.new(YN.Position.X, -7, YN.Position.Z) * YN.Rotation, U.lastTargetMarker
      if not KN or not KN.Parent then
        KN = Instance.new("Part")
        KN.Name = "AkatsukiTPBatLastPosition"
        KN.Shape = Enum.PartType.Ball
        KN.Size = Vector3.new(3, 3, 3)
        KN.Color = Color3.fromRGB(220, 30, 45)
        KN.Material = Enum.Material.Neon
        KN.Anchored = true
        KN.CanCollide = false
        KN.CanTouch = false
        KN.CanQuery = false
        KN.CastShadow = false
        KN.Parent = workspace
        qN = Instance.new("SphereHandleAdornment")
        qN.Name = "AlwaysOnTopSphere"
        qN.Adornee = KN
        qN.Radius = 1.55
        qN.Color3 = Color3.fromRGB(235, 40, 55)
        qN.Transparency = 0.05
        qN.AlwaysOnTop = true
        qN.Visible = true
        qN.ZIndex = 10
        qN.Parent = KN
        eN = Instance.new("Highlight")
        eN.Name = "LastPositionHighlight"
        eN.Adornee = KN
        eN.FillColor = Color3.fromRGB(220, 30, 45)
        eN.FillTransparency = 0.15
        eN.OutlineColor = Color3.fromRGB(255, 135, 145)
        eN.OutlineTransparency = 0
        eN.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        eN.Enabled = true
        eN.Parent = KN
        YN = Instance.new("BillboardGui")
        YN.Name = "LastPositionLabel"
        YN.Size = UDim2.new(0, 110, 0, 20)
        YN.StudsOffset = Vector3.new(0, 2.1, 0)
        YN.AlwaysOnTop = true
        YN.Adornee = KN
        YN.Parent = KN
        local eN = Instance.new("TextLabel")
        eN.Name = "Text"
        eN.Size = UDim2.fromScale(1, 1)
        eN.BackgroundTransparency = 1
        eN.Text = "ultima posicion"
        eN.TextColor3 = Color3.fromRGB(238, 230, 232)
        eN.TextStrokeColor3 = Color3.fromRGB(62, 8, 14)
        eN.TextStrokeTransparency = 0.25
        eN.TextSize = 11
        eN.Font = Enum.Font.GothamMedium
        eN.Parent = YN
        U.lastTargetMarker = KN
      end
      KN.Transparency = 0
      local YN = KN:FindFirstChild("AlwaysOnTopSphere")
      if YN then
        YN.Visible = true
      end
      YN = KN:FindFirstChild("LastPositionHighlight")
      if YN then
        YN.Enabled = true
      end
      YN = KN:FindFirstChild("LastPositionLabel")
      if YN then
        YN.Enabled = true
      end
      KN.CFrame = jN
      U.markerLocked = true
    end
    local function YN()
      U.markerLocked = false
      LN()
      if U.lastTargetMarker then
        pcall(function()
          U.lastTargetMarker.Transparency = 1
          local jN = U.lastTargetMarker:FindFirstChild("AlwaysOnTopSphere")
          if jN then
            jN.Visible = false
          end
          jN = U.lastTargetMarker:FindFirstChild("LastPositionHighlight")
          if jN then
            jN.Enabled = false
          end
          jN = U.lastTargetMarker:FindFirstChild("LastPositionLabel")
          if jN then
            jN.Enabled = false
          end
        end)
      end
    end
    function _.getMarkerCFrame()
      local jN = U.lastTargetMarker
      if U.markerLocked and jN and jN.Parent and jN.Transparency < 1 then
        local eN = U.markerTarget
        local qN = eN and eN.Character and (eN.Character:FindFirstChild("HumanoidRootPart"))
        if qN and (GN(qN.Position)) then
          YN()
          return nil
        end
        eN, qN = QN()
        return ON(qN, jN) or jN.CFrame
      end
      return nil
    end
    function _.trackTarget(ON)
      if U.markerLocked then
        return U.markerTarget
      end
      local jN = U.markerTarget
      local eN = jN and jN.Parent == z and jN.Character
      local qN, KN, IN =
        eN and (eN:FindFirstChildOfClass("Humanoid")),
        eN and (eN:FindFirstChild("HumanoidRootPart")),
        jN and U.samples[jN]
      if jN and jN.Parent == z then
        if qN and qN.Health > 0 and (KN and (GN(KN.Position)) or IN and IN.safeCFrame) then
          return jN
        end
        if not qN and IN and IN.safeCFrame then
          return jN
        end
      end
      if ON and ON ~= u and ON.Parent == z then
        U.markerTarget = ON
        return ON
      end
      return U.markerTarget
    end
    function _.clearMarkerTracking()
      U.target = nil
    end
    local function ON(jN, eN)
      if not jN or jN.Parent ~= z or not jN.Character then
        return false
      end
      local eN, qN =
        jN.Character:FindFirstChild("HumanoidRootPart"),
        jN.Character:FindFirstChildOfClass("Humanoid")
      if not eN or not qN or qN.Health <= 0 or not GN(eN.Position) then
        return false
      end
      return true
    end
    local function jN(eN, qN)
      if not eN or not eN.history or #eN.history == 0 then
        return nil
      end
      local KN, IN = qN - 0.2
      for qN, qN in ipairs(eN.history) do
        if not (qN.time <= KN) then
          break
        end
        IN = qN
      end
      return IN or eN.history[1]
    end
    function _.forceMarker(eN, qN)
      if eN and eN.Parent == z then
        U.markerTarget = eN
      end
      local KN = eN and U.samples[eN]
      eN = jN(KN, tick())
      local IN = eN and eN.safeCFrame or KN and KN.safeCFrame
      IN = if not IN and qN and (GN(qN.Position)) then qN else IN
      if IN then
        ZN(IN)
      end
      return _.getMarkerCFrame()
    end
    local function eN()
      local qN, qN = QN()
      if not qN then
        return
      end
      local QN = U.markerTarget
      if QN and QN.Parent == z then
        local KN, IN, FN =
          QN.Character and (QN.Character:FindFirstChild("HumanoidRootPart")),
          QN.Character and (QN.Character:FindFirstChildOfClass("Humanoid")),
          U.samples[QN] or {}
        U.samples[QN] = FN
        if KN and IN and IN.Health > 0 and (UN(KN.Position)) then
          if GN(KN.Position) then
            local UN = tick()
            if U.markerLocked then
              FN.history = {}
            end
            FN.history = FN.history or {}
            table.insert(
              FN.history,
              { time = UN, safePosition = KN.Position, safeCFrame = KN.CFrame }
            )
            while FN.history[1] and UN - FN.history[1].time > 0.45 do
              table.remove(FN.history, 1)
            end
            FN.safePosition = KN.Position
            FN.safeCFrame = KN.CFrame
            YN()
          else
            local UN = jN(FN, tick())
            ZN(UN and UN.safeCFrame or FN.safeCFrame)
          end
        end
        if IN and IN.Health <= 0 or not KN and not FN.safeCFrame then
          U.markerTarget = nil
          YN()
        else
          return
        end
      end
      local UN, ZN = math.huge
      for jN, KN in ipairs(z:GetPlayers()) do
        if KN ~= u and (ON(KN)) then
          QN = KN.Character:FindFirstChild("HumanoidRootPart").Position - qN.Position
          jN = QN:Dot(QN)
          if jN < UN then
            UN, ZN = jN, KN
          end
        end
      end
      if ZN then
        U.markerTarget = ZN
        qN, UN = ZN.Character:FindFirstChild("HumanoidRootPart"), U.samples[ZN] or {}
        U.samples[ZN] = UN
        UN.safePosition = qN.Position
        UN.safeCFrame = qN.CFrame
        UN.history = { { time = tick(), safePosition = qN.Position, safeCFrame = qN.CFrame } }
      end
    end
    local QN = 0
    local UN = D.Heartbeat:Connect(function(ON)
      QN += ON or 0
      ON = p
          and ((y["TP Bat"] == true or y.Aimbot == true or y["Lagger Aimbot"] == true) and 0.03333333333333333 or 0.25)
        or 0.016666666666666666
      if QN < ON then
        return
      end
      QN %= ON
      eN()
    end)
    _G.__AkatsukiTrackConn(UN)
    local function QN(UN)
      local ON = _.getMarkerCFrame()
      if not ON then
        LN()
        return false
      end
      pcall(function()
        UN.AssemblyLinearVelocity = Vector3.zero
        UN.AssemblyAngularVelocity = Vector3.zero
        UN.CFrame = ON
        UN.AssemblyLinearVelocity = Vector3.zero
        UN.AssemblyAngularVelocity = Vector3.zero
      end)
      local ON = U.lastTargetMarker
      if ON then
        iN(UN, ON)
      end
      return true
    end
    _G.__AkatsukiTrackStopper(function()
      pcall(YN)
    end)
    do
      local U = {
        enabled = false,
        heartbeat = nil,
        target = nil,
        samples = {},
        swingLocked = false,
        nextSwingAt = 0,
        lastSafeCFrame = nil,
        lastPosition = nil,
        lastSampleTime = 0,
        recoverUntil = 0,
        physicsPauseUntil = 0,
        previousAutoRotate = nil,
        lastTargetMarker = nil,
        markerLocked = false,
        markerTarget = nil,
      }
      _G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
      local function UN()
        local ON = u.Character
        if not ON then
          return nil, nil, nil
        end
        return ON, ON:FindFirstChild("HumanoidRootPart"), ON:FindFirstChildOfClass("Humanoid")
      end
      local function ON(iN)
        return iN.X == iN.X
          and iN.Y == iN.Y
          and iN.Z == iN.Z
          and math.abs(iN.X) < 10000000
          and math.abs(iN.Y) < 10000000
          and math.abs(iN.Z) < 10000000
      end
      local function iN(ZN, YN, jN, eN)
        local qN = Vector3.new(YN.X - ZN.X, 0, YN.Z - ZN.Z)
        if qN.Magnitude > 0.05 then
          return CFrame.lookAt(ZN, ZN + qN.Unit)
        end
        qN = jN and (Vector3.new(jN.X, 0, jN.Z)) or nil
        if qN and qN.Magnitude >= 0.01 then
          return CFrame.lookAt(ZN, ZN + qN.Unit)
        end
        if eN then
          jN, YN = eN:ToEulerAnglesYXZ()
          return CFrame.new(ZN) * CFrame.Angles(0, YN, 0)
        end
        return CFrame.new(ZN)
      end
      local function ZN(YN)
        return YN ~= nil
      end
      local function YN() end
      local function jN(eN)
        if not eN or eN.Parent ~= z or not eN.Character then
          return false
        end
        local qN, KN =
          eN.Character:FindFirstChild("HumanoidRootPart"),
          eN.Character:FindFirstChildOfClass("Humanoid")
        if not qN or not KN or KN.Health <= 0 or not ON(qN.Position) then
          return false
        end
        KN = U.samples[eN]
        return _.isInsideMap(qN.Position) or KN ~= nil and KN.safeCFrame ~= nil
      end
      local function eN(qN, KN)
        local GN = qN and U.samples[qN]
        qN = GN and GN.safeCFrame
        if qN and (ZN(qN.Position)) and (not KN or (ZN(qN.Position))) then
          return qN
        end
        return nil
      end
      local function ZN(qN)
        local KN = _.trackTarget(U.target)
        if jN(KN) then
          U.target = KN
          return KN
        end
        if jN(U.target) then
          return U.target
        end
        local GN, IN = math.huge
        for FN, kN in ipairs(z:GetPlayers()) do
          if kN ~= u and (jN(kN)) then
            FN = kN.Character:FindFirstChild("HumanoidRootPart")
            if FN then
              KN = (FN.Position - qN.Position).Magnitude
              if KN < GN then
                GN, IN = KN, kN
              end
            end
          end
        end
        if IN then
          U.target = IN
          _.trackTarget(IN)
        end
        return IN
      end
      local function jN()
        local qN = tonumber(_G.__tpBatV2Distance)
        if not qN or qN ~= qN then
          return 8
        end
        return math.clamp(qN, 0, 100)
      end
      local function qN()
        local KN = u.Character
        if not KN then
          return nil
        end
        local GN = KN:FindFirstChild("Bat")
        if GN and (GN:IsA("Tool")) then
          return GN
        end
        local IN = u:FindFirstChildOfClass("Backpack")
        GN = IN and (IN:FindFirstChild("Bat")) or nil
        if GN and (GN:IsA("Tool")) then
          GN.Parent = KN
          return GN
        end
        return nil
      end
      local function KN()
        local GN = tick()
        if U.swingLocked or GN < U.nextSwingAt then
          return
        end
        U.swingLocked = true
        U.nextSwingAt = GN + 0.014925373134328358
        pcall(function()
          local GN = qN()
          if not GN then
            return
          end
          GN:Activate()
          local qN = GN:FindFirstChildWhichIsA("RemoteEvent")
          if qN then
            qN:FireServer()
          end
        end)
        task.delay(0.014925373134328358, function()
          U.swingLocked = false
        end)
      end
      local function qN(GN)
        if not GN then
          return
        end
        pcall(function()
          GN.AssemblyLinearVelocity = Vector3.zero
          GN.AssemblyAngularVelocity = Vector3.zero
        end)
      end
      local function GN()
        if not U.enabled then
          return
        end
        local IN, FN, kN = UN()
        if not IN or not FN or not kN or kN.Health <= 0 then
          return
        end
        if QN(FN) then
          KN()
          return
        end
        if U.previousAutoRotate == nil then
          U.previousAutoRotate = kN.AutoRotate
        end
        kN.AutoRotate = false
        IN = ZN(FN)
        if IN then
          local EN, lN =
            IN.Character and (IN.Character:FindFirstChild("HumanoidRootPart")), eN(IN, FN)
          if not EN or not ON(EN.Position) then
            return
          end
          if not _.isInsideMap(EN.Position) then
            _.forceMarker(IN, lN)
            if QN(FN) then
              KN()
            end
            return
          end
          local lN, NN = EN.CFrame, U.samples[IN] or {}
          U.samples[IN] = NN
          NN.safeCFrame = EN.CFrame
          NN.safePosition = EN.Position
          EN, kN = lN.Position + Vector3.new(0, 0.9, 0), lN.LookVector
          if (FN.Position - EN).Magnitude > jN() then
            SN(FN, iN(EN, lN.Position, kN, FN.CFrame))
          else
            SN(FN, iN(FN.Position, lN.Position, kN, FN.CFrame))
          end
          local IN = workspace.CurrentCamera
          if IN then
            pcall(function()
              IN.CFrame = CFrame.new(IN.CFrame.Position, lN.Position)
            end)
          end
          KN()
        end
      end
      local function IN()
        if not U.enabled then
          return
        end
        local FN, kN, EN = UN()
        if not FN or not kN or not EN or EN.Health <= 0 then
          return
        end
        if QN(kN) then
          KN()
          return
        end
        if U.previousAutoRotate == nil then
          U.previousAutoRotate = EN.AutoRotate
        end
        EN.AutoRotate = false
        EN = ZN(kN)
        if not EN then
          return
        end
        local ZN, lN =
          EN.Character and (EN.Character:FindFirstChild("HumanoidRootPart")), eN(EN, kN)
        local eN, NN, mN = ZN and ZN.CFrame or lN, not ZN, false
        if ZN then
          FN = U.samples[EN] or {}
          U.samples[EN] = FN
          mN = ZN.Position.Y < -9 or not _.isInsideMap(ZN.Position) or not ON(ZN.Position)
          if ON(ZN.Position) and (_.isInsideMap(ZN.Position)) then
            FN.safeCFrame = ZN.CFrame
            FN.safePosition = ZN.Position
          else
            eN, NN = lN, true
          end
        end
        if not eN then
          return
        end
        if NN and mN then
          _.forceMarker(EN, eN)
          if QN(kN) then
            KN()
            return
          end
        end
        FN = eN.Position
        FN = if not NN then FN + Vector3.new(0, 0.9, 0) else FN
        SN(
          kN,
          if (kN.Position - FN).Magnitude > jN()
            then (iN(FN, eN.Position, eN.LookVector, kN.CFrame))
            else (iN(kN.Position, eN.Position, eN.LookVector, kN.CFrame))
        )
        local QN = workspace.CurrentCamera
        if QN then
          pcall(function()
            QN.CFrame = CFrame.new(QN.CFrame.Position, eN.Position)
          end)
        end
        KN()
      end
      local function QN()
        if _G.__batVersion == 2 then
          return IN()
        end
        return GN()
      end
      local function ON()
        local iN, SN = U.enabled, U.returnGeneration
        LN()
        U.enabled = false
        if o.alive and _G.__AKATSUKI_STATE == o then
          _.setCollisionsActive(false)
        end
        if U.heartbeat then
          U.heartbeat:Disconnect()
          U.heartbeat = nil
        end
        U.target = nil
        U.samples = {}
        U.swingLocked = false
        local LN, LN, ZN = UN()
        if LN then
          LN.AssemblyLinearVelocity = Vector3.zero
          LN.AssemblyAngularVelocity = Vector3.zero
          qN(LN)
        end
        if ZN then
          ZN.AutoRotate = U.previousAutoRotate == nil and true or U.previousAutoRotate
          pcall(function()
            ZN.PlatformStand = false
            ZN.Sit = false
            local eN = ZN:GetState()
            if
              eN == Enum.HumanoidStateType.Physics
              or eN == Enum.HumanoidStateType.Ragdoll
              or eN == Enum.HumanoidStateType.FallingDown
            then
              ZN:ChangeState(Enum.HumanoidStateType.GettingUp)
              ZN:ChangeState(Enum.HumanoidStateType.Running)
            end
            eN = workspace.CurrentCamera
            if eN then
              eN.CameraSubject = ZN
            end
          end)
        end
        U.previousAutoRotate = nil
        if iN and LN then
          task.spawn(function()
            for ZN = 1, 12, 1 do
              D.Heartbeat:Wait()
              if U.enabled or U.returnGeneration ~= SN then
                return
              end
              if _G.__AKATSUKI_STATE ~= o then
                return
              end
              local ZN, ZN, eN = UN()
              if ZN ~= LN or not eN or eN.Health <= 0 then
                return
              end
              ZN.AssemblyLinearVelocity = Vector3.zero
              ZN.AssemblyAngularVelocity = Vector3.zero
              qN(ZN)
            end
          end)
        end
        if iN then
          task.delay(0.4, function()
            if U.enabled or U.returnGeneration ~= SN then
              return
            end
            if _G.__AKATSUKI_STATE ~= o then
              return
            end
            pcall(function()
              if _G.__AkatsukiAntiDieSet then
                _G.__AkatsukiAntiDieSet(false)
              end
            end)
          end)
        else
          pcall(function()
            if _G.__AkatsukiAntiDieSet then
              _G.__AkatsukiAntiDieSet(false)
            end
          end)
        end
      end
      local function LN()
        if U.enabled then
          return
        end
        U.returnGeneration = (U.returnGeneration or 0) + 1
        if y.Autoplay and _G.__stopAutoplay then
          _G.__stopAutoplay()
        end
        _.setCollisionsActive(true)
        U.enabled = true
        pcall(function()
          if _G.__AkatsukiAntiDieSet then
            _G.__AkatsukiAntiDieSet(true)
          end
        end)
        U.target = nil
        U.samples = {}
        U.swingLocked = false
        U.nextSwingAt = 0
        U.lastPosition = nil
        U.lastSampleTime = tick()
        U.recoverUntil = 0
        U.physicsPauseUntil = 0
        U.startingUntil = tick() + 0.35
        local iN, iN, SN = UN()
        if iN then
          qN(iN)
          if iN.Position.Y > -30 then
            U.lastSafeCFrame = iN.CFrame
          end
        end
        if SN then
          U.previousAutoRotate = SN.AutoRotate
        end
        if U.heartbeat then
          U.heartbeat:Disconnect()
        end
        U.heartbeat = D.Heartbeat:Connect(QN)
        task.spawn(function()
          pcall(QN)
        end)
      end
      T["TP Bat"] = function(iN)
        if iN then
          nN("TP Bat")
          _G.__deactivateBatExclusive("TP Bat")
          LN()
        else
          ON()
        end
      end
      _G.__AkatsukiTrackStopper(function()
        pcall(ON)
        pcall(YN)
      end)
      _.controller = {
        GetVersion = function()
          return _G.__batVersion or 1
        end,
        SetVersion = function(nN)
          _G.__batVersion = tonumber(nN) == 2 and 2 or 1
          U.samples = {}
          U.lastPosition = nil
          U.lastSampleTime = tick()
          U.recoverUntil = 0
          U.physicsPauseUntil = 0
          if _.versionPill then
            _.versionPill.Text = "V" .. tostring(_G.__batVersion)
          end
          if _.updateVersionButton then
            _.updateVersionButton()
          end
          if _.refreshVisibleConfig then
            _.refreshVisibleConfig()
          end
          oN()
          if U.enabled then
            local nN, nN = UN()
            if nN then
              qN(nN)
            end
            QN()
          end
          return _G.__batVersion
        end,
        GetV2Distance = jN,
        SetV2Distance = function(nN)
          local UN = tonumber((tostring(nN):gsub(",", ".")))
          nN = UN and UN == UN and math.abs(UN) < math.huge
          if nN then
            _G.__tpBatV2Distance = math.floor(math.clamp(UN, 0, 100) * 100 + 0.5) / 100
          end
          if _.updateVersionButton then
            _.updateVersionButton()
          end
          if _.refreshVisibleConfig then
            _.refreshVisibleConfig()
          end
          if nN then
            oN()
            if U.enabled then
              QN()
            end
          end
          return jN()
        end,
        SetEnabled = function(nN)
          nN = nN == true
          y["TP Bat"] = nN
          if d["TP Bat"] then
            pcall(d["TP Bat"], nN)
          end
          T["TP Bat"](nN)
          if M["TP Bat"] then
            pcall(M["TP Bat"])
          end
          oN()
          return U.enabled
        end,
        Toggle = function()
          return _.controller.SetEnabled(not (y["TP Bat"] == true))
        end,
        Stop = function()
          pcall(ON)
        end,
      }
    end
  end)()
  local U = hN(_N, "Drop", "Drop")
  pcall(function()
    t(U)
  end)
  local U = hN(_N, "Auto Grab", "auto steal")
  pcall(function()
    t(U)
  end)
  do
    local U = Instance.new("Frame", h)
    U.Name = "AkatsukiAutoGrabBar"
    U.AnchorPoint = Vector2.new(0, 0)
    local t, nN = p and 230 or 310, p and 205 or 280
    local QN, UN, hN =
      math.floor((t + nN) / 2),
      _G._AkatsukiHub_UI_AutoGrabBarSize,
      _G._AkatsukiHub_UI_AutoGrabExpanded ~= nil and _G._AkatsukiHub_UI_AutoGrabExpanded or true
    c = tonumber(UN)
    local LN = (if c and c < nN then nil else c)
        and (math.clamp(if c and c < nN then nil else c, nN, t))
      or t
    if UN and (tonumber(UN)) and tonumber(UN) <= nN then
      hN = false
    end
    _G._AkatsukiHub_UI_AutoGrabExpanded = hN
    U.Size = UDim2.new(0, LN, 0, p and 50 or 58)
    UN = _G._AkatsukiHub_UI_AutoGrabBarPos
    if UN and UN.x and UN.y then
      U.Position = UDim2.fromOffset(UN.x, UN.y)
    else
      U.Position = UDim2.new(0.5, -LN / 2, 0.8, 0)
    end
    U.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
    U.BackgroundTransparency = 0
    U.BorderSizePixel = 0
    U.ZIndex = 500
    U.Active = true
    U.Draggable = false
    U.Visible = false
    Instance.new("UICorner", U).CornerRadius = UDim.new(0, 5)
    local ON = Instance.new("UIStroke", U)
    ON.Color = Color3.fromRGB(92, 34, 40)
    ON.Thickness = 1.5
    ON.Transparency = 0.08
    ON.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    _N = Instance.new("UIGradient", U)
    _N.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 34, 38)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 17)),
    })
    _N.Rotation = 90
    nN = Instance.new("Frame", U)
    nN.Size = UDim2.new(0, p and 70 or 82, 1, -4)
    nN.Position = UDim2.new(1, p and -72 or -84, 0, 2)
    nN.BackgroundTransparency = 1
    nN.Visible = true
    nN.ZIndex = 504
    UN = Instance.new("Frame", nN)
    UN.Name = "Divider"
    UN.Size = UDim2.new(0, 1, 1, -10)
    UN.Position = UDim2.new(0, 0, 0, 5)
    UN.BorderSizePixel = 0
    UN.BackgroundColor3 = Color3.fromRGB(92, 34, 40)
    UN.BackgroundTransparency = 0.25
    UN.ZIndex = 505
    r = Instance.new("TextLabel", nN)
    r.Size = UDim2.new(1, -10, 0, 14)
    r.Position = UDim2.new(0, p and 7 or 9, 0, p and 6 or 9)
    r.BackgroundTransparency = 1
    r.TextColor3 = Color3.fromRGB(235, 235, 240)
    r.Font = Enum.Font.GothamBold
    r.TextSize = p and 8 or 9
    r.TextXAlignment = Enum.TextXAlignment.Left
    r.ZIndex = 506
    r.Visible = true
    x = Instance.new("TextLabel", nN)
    x.Size = UDim2.new(1, -10, 0, 14)
    x.Position = UDim2.new(0, p and 7 or 9, 0, p and 23 or 27)
    x.BackgroundTransparency = 1
    x.TextColor3 = Color3.fromRGB(235, 235, 240)
    x.Font = Enum.Font.GothamBold
    x.TextSize = p and 8 or 9
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.ZIndex = 506
    x.Visible = true
    local r = Instance.new("TextLabel", nN)
    r.Size = UDim2.new(0, 54, 1, 0)
    r.Position = UDim2.new(1, -84, 0, 0)
    r.BackgroundTransparency = 1
    r.TextColor3 = Color3.fromRGB(235, 235, 240)
    r.Font = Enum.Font.GothamBold
    r.TextSize = 11
    r.TextXAlignment = Enum.TextXAlignment.Right
    r.ZIndex = 502
    r.Visible = false
    local x = Instance.new("TextButton", U)
    x.Size = UDim2.new(0, 16, 0, 16)
    x.Position = UDim2.new(1, -22, 0, 3)
    x.AnchorPoint = Vector2.new(0, 0)
    x.BackgroundTransparency = 0.2
    x.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
    x.TextColor3 = Color3.fromRGB(235, 240, 245)
    x.Font = Enum.Font.GothamBold
    x.TextSize = 10
    x.Text = hN and "-" or "+"
    x.Visible = false
    Instance.new("UICorner", x).CornerRadius = UDim.new(1, 0)
    x.ZIndex = 510
    local UN
    local function iN(SN)
      if not SN or tonumber(SN) == nil then
        return
      end
      if
        pcall(function()
          if U and U.Size and U.Size.Y then
            local ZN = U.Size.Y.Offset or (p and 50 or 58)
            U.Size = UDim2.new(0, tonumber(SN), 0, ZN)
          end
          if UN and UN.Size then
            UN.Size = UDim2.new(1, p and -84 or -96, 0, p and 6 or 7)
          end
        end)
      then
        _G._AkatsukiHub_UI_AutoGrabBarSize = tonumber(SN)
        pcall(oN)
      end
    end
    if not hN then
      iN(QN)
    end
    x.MouseButton1Click:Connect(function()
      hN = not hN
      _G._AkatsukiHub_UI_AutoGrabExpanded = hN
      if hN then
        iN(t)
        x.Text = "-"
      else
        iN(QN)
        x.Text = "+"
      end
    end)
    UN = Instance.new("Frame", U)
    UN.Size = UDim2.new(1, p and -84 or -96, 0, p and 6 or 7)
    UN.Position = UDim2.new(0, 8, 0, p and 31 or 36)
    UN.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
    UN.BorderSizePixel = 0
    UN.ZIndex = 500
    Instance.new("UICorner", UN).CornerRadius = UDim.new(0, 2)
    local x = Instance.new("Frame", UN)
    x.Size = UDim2.new(0, 0, 1, 0)
    x.Position = UDim2.new(0, 0, 0, 0)
    x.BorderSizePixel = 0
    x.BackgroundColor3 = Color3.fromRGB(118, 30, 38)
    x.ClipsDescendants = true
    x.ZIndex = 502
    Instance.new("UICorner", x).CornerRadius = UDim.new(0, 2)
    local t, QN = Instance.new("UIGradient", x), Color3.fromRGB(215, 40, 52)
    local function hN(iN)
      QN = Color3.fromRGB(215, 40, 52)
      t.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 105, 116)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 22, 34)),
      })
      x.BackgroundColor3 = QN
    end
    _G.__AkatsukiApplyAutoStealBarTheme = hN
    hN(_G.__AkatsukiGuiTheme or "GUI 1")
    local t = Instance.new("TextLabel", U)
    t.Size = UDim2.new(1, p and -76 or -88, 1, 0)
    t.Position = UDim2.new(0, 0, 0, 0)
    t.BackgroundTransparency = 1
    t.Text = "AUTO STEAL  0%"
    t.TextColor3 = Color3.fromRGB(248, 248, 250)
    t.TextStrokeTransparency = 1
    t.TextSize = p and 10 or 12
    t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Center
    t.ZIndex = 503
    t.Visible = false
    nN = Instance.new("TextLabel", U)
    nN.Size = UDim2.new(0, 120, 0, 15)
    nN.Position = UDim2.new(0, 15, 0, 29)
    nN.BackgroundTransparency = 1
    nN.Text = ""
    nN.TextColor3 = Color3.fromRGB(220, 220, 225)
    nN.TextSize = 9
    nN.Font = Enum.Font.GothamBold
    nN.TextXAlignment = Enum.TextXAlignment.Left
    nN.ZIndex = 503
    nN.Visible = false
    local nN = Instance.new("TextLabel", U)
    nN.Size = UDim2.new(0, 48, 0, 18)
    nN.Position = UDim2.new(1, p and -116 or -132, 0, 4)
    nN.BackgroundTransparency = 1
    nN.Text = "0%"
    nN.TextColor3 = Color3.fromRGB(248, 248, 250)
    nN.TextStrokeTransparency = 1
    nN.TextSize = 11
    nN.Font = Enum.Font.GothamBold
    nN.TextXAlignment = Enum.TextXAlignment.Right
    nN.ZIndex = 504
    nN.Visible = true
    local hN = Instance.new("TextLabel", U)
    hN.Size = UDim2.new(1, p and -126 or -142, 0, p and 22 or 24)
    hN.Position = UDim2.new(0, 8, 0, 3)
    hN.BackgroundTransparency = 1
    hN.Text = "Akatsuki Auto Steal"
    hN.TextColor3 = Color3.fromRGB(242, 242, 245)
    hN.Font = Enum.Font.GothamBold
    hN.TextSize = 11
    hN.TextXAlignment = Enum.TextXAlignment.Left
    hN.ZIndex = 504
    hN.Visible = true
    local iN, SN, ZN = false
    function _G.__AkatsukiGuiPositionResetters.AutoGrab()
      iN, SN, ZN = false, nil, nil
      U.AnchorPoint = Vector2.new(0, 0)
      U.Position = UDim2.new(0.5, -LN / 2, 0.8, 0)
      _G._AkatsukiHub_UI_AutoGrabBarPos = nil
    end
    U.InputBegan:Connect(function(LN)
      if
        LN.UserInputType == Enum.UserInputType.MouseButton1
        or LN.UserInputType == Enum.UserInputType.Touch
      then
        iN = true
        SN = { pointer = LN.Position, position = U.AbsolutePosition }
        local YN, jN = LN.UserInputType, Enum.UserInputType.Touch
        if YN == jN then
          ZN = LN
        end
      end
    end)
    U.InputChanged:Connect(function(LN)
      local YN = LN.UserInputType == Enum.UserInputType.MouseMovement
        or LN.UserInputType == Enum.UserInputType.Touch
      if YN then
        ZN = LN
      end
    end)
    _G.__AkatsukiTrackConn(C.InputChanged:Connect(function(LN)
      if not iN or not SN or LN ~= ZN then
        return
      end
      if
        LN.UserInputType ~= Enum.UserInputType.MouseMovement
        and LN.UserInputType ~= Enum.UserInputType.Touch
      then
        return
      end
      local YN = LN.Position - SN.pointer
      local LN, jN = SN.position.X + YN.X, SN.position.Y + YN.Y
      U.Position = UDim2.fromOffset(LN, jN)
    end))
    _G.__AkatsukiTrackConn(C.InputEnded:Connect(function(LN)
      if
        iN
        and (
          LN.UserInputType == Enum.UserInputType.MouseButton1
          or LN.UserInputType == Enum.UserInputType.Touch
        )
      then
        iN = false
        local LN = U.AbsolutePosition
        U.AnchorPoint = Vector2.new(0, 0)
        U.Position = UDim2.fromOffset(LN.X, LN.Y)
        _G._AkatsukiHub_UI_AutoGrabBarPos = { x = LN.X, y = LN.Y }
        SN, ZN = nil, nil
        oN()
      end
    end))
    local LN = {
      displayProgress = 0,
      radiusProgress = 0,
      targetInRadius = false,
      radiusCheckElapsed = 0,
      uiElapsed = 0,
      lastVisible = nil,
      lastPercent = nil,
      lastActive = nil,
    }
    _G.__AkatsukiTrackConn(D.Heartbeat:Connect(function(iN)
      LN.uiElapsed = LN.uiElapsed + (iN or 0)
      if LN.uiElapsed < 0.016666666666666666 then
        return
      end
      iN = LN.uiElapsed
      LN.uiElapsed = LN.uiElapsed % 0.016666666666666666
      if y["auto steal"] ~= true and (I or 0) <= 0 and LN.displayProgress <= 0.001 then
        if LN.lastVisible ~= false then
          U.Visible = false
          LN.lastVisible = false
        end
        return
      end
      LN.radiusCheckElapsed = LN.radiusCheckElapsed + (iN or 0)
      local SN = _G.__AkatsukiAutoGrabRagdollBlocked == true
      if SN then
        LN.targetInRadius = false
        LN.radiusProgress = 0
      end
      if LN.radiusCheckElapsed >= 0.25 then
        LN.radiusCheckElapsed = 0
        LN.targetInRadius = false
        local ZN = StealState and StealState.active
          or F and F.busy
          or V3New and V3New.busy
          or V2Grab and V2Grab.busy
        if
          not SN
          and not ZN
          and y["auto steal"] == true
          and _G.__AkatsukiAutoGrabTargetInRadius
        then
          local F = math.clamp(tonumber(O.Radius) or 65, 10, 150)
          local ZN, YN = pcall(_G.__AkatsukiAutoGrabTargetInRadius, F)
          LN.targetInRadius = ZN and YN == true
        end
      end
      local F = SN and 0 or (math.clamp(I or 0, 0, 1))
      if LN.targetInRadius then
        if F > 0 then
          LN.radiusProgress = F
        else
          SN = math.max(0.1, tonumber(O.Duration) or 1.3)
          LN.radiusProgress = LN.radiusProgress + (iN or 0) / SN
          if LN.radiusProgress >= 1 then
            LN.radiusProgress = 0
          end
        end
      else
        LN.radiusProgress = 0
      end
      local I, SN = math.max(F, LN.radiusProgress), UN.AbsoluteSize.X
      SN = if (if SN <= 0 then U.AbsoluteSize.X - (p and 76 or 88) else SN) <= 0
        then p and 192 or 222
        else if SN <= 0 then U.AbsoluteSize.X - (p and 76 or 88) else SN
      local F, UN, ZN =
        math.clamp(I * SN, 0, SN), LN.displayProgress * SN, I > LN.displayProgress and 18 or 22
      UN += (F - UN) * math.min(ZN * iN, 1)
      UN = if math.abs(UN - F) < 0.5 then F else UN
      LN.displayProgress = SN > 0 and (math.clamp(UN / SN, 0, 1)) or 0
      x.Size = UDim2.new(0, UN, 1, 0)
      ZN = y["auto steal"] == true or I > 0
      if ZN ~= LN.lastVisible then
        U.Visible = ZN
        LN.lastVisible = ZN
      end
      UN = math.floor(I * 100)
      UN = math.clamp(UN, 0, 100)
      if UN ~= LN.lastPercent then
        r.Text = tostring(UN) .. "%"
        nN.Text = tostring(UN) .. "%"
        t.Text = "AUTO STEAL  " .. tostring(UN) .. "%"
        LN.lastPercent = UN
      end
      F = I > 0
      if F and LN.lastActive ~= true then
        x.BackgroundColor3 = QN
        ON.Color = Color3.fromRGB(92, 94, 100)
        ON.Transparency = 0.08
        hN.TextColor3 = Color3.fromRGB(255, 255, 255)
      end
      LN.lastActive = F
    end))
  end
  _N = aN(k.Visuals, "VISUALS")
  fN(_N, "anti lag", "Anti Lag")
  _G.__visualSection = _N
  fN(_N, "ESP Players", "ESP Players")
  fN(_N, "Player Tracers", "Player Tracers")
  local U, I
  local F = _G.__optimizerMode == "Ultra" and "Ultra" or "Normal"
  _G.__optimizerMode = F
  c = fN(_N, "Optimizer", "Optimizer")
  local r = c and (c:FindFirstChildOfClass("TextButton"))
  if r then
    local x = Instance.new("TextButton", r)
    x.Size = UDim2.new(0, 66, 0, 20)
    x.Position = UDim2.new(1, -74, 0.5, -10)
    x.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    x.BorderSizePixel = 0
    x.TextColor3 = Color3.fromRGB(238, 238, 242)
    x.TextSize = 10
    x.Font = Enum.Font.GothamBold
    x.AutoButtonColor = false
    x.ZIndex = 30
    Instance.new("UICorner", x).CornerRadius = UDim.new(0, 4)
    c = Instance.new("UIStroke", x)
    c.Color = Color3.fromRGB(255, 255, 255)
    c.Thickness = 1
    c.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local function t()
      x.Text = string.upper(F)
    end
    t()
    v(x, function()
      F = F == "Normal" and "Ultra" or "Normal"
      _G.__optimizerMode = F
      t()
      oN()
      if y.Optimizer and T.Optimizer then
        T.Optimizer(false)
        T.Optimizer(true)
      end
    end)
  end
  do
    local x, t, nN, QN, UN = false
    local hN, LN, ON, iN, SN, ZN, YN =
      0, {}, {}, 0, 0, false, {
        { "DFIntConnectionMTUSize", "1400" },
        { "DFIntRakNetResendBufferArrayLength", "1024" },
        { "DFIntRaknetNakResendDelayMsMax", "1" },
        { "DFIntClusterSenderMaxJoinBandwidthBps", "2100000000" },
        { "DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000" },
        { "DFIntServerFramesBetweenJoins", "1" },
        { "DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000" },
        { "DFIntWaitOnUpdateNetworkLoopEndedMS", "100" },
        { "DFIntWaitOnRecvFromLoopEndedMS", "100" },
        { "DFIntLargePacketQueueSizeCutoffMB", "1000" },
        { "DFIntSendRakNetStatsInterval", "2147483647" },
        { "DFIntRakNetLoopMs", "1" },
        { "DFIntRakNetSelectTimeoutMs", "1" },
        { "DFIntNetworkClusterPacketCacheNumParallelTasks", "8" },
        { "DFIntReplicationDataCacheNumParallelTasks", "8" },
        { "DFIntMegaReplicatorNumParallelTasks", "16" },
        { "DFIntMegaReplicatorNetworkQualityProcessorUnit", "10" },
        { "DFIntMaxProcessPacketsStepsPerCyclic", "512" },
        { "DFIntMaxProcessPacketsStepsAccumulated", "0" },
        { "DFIntMaxProcessPacketsJobScaling", "1000" },
        { "DFIntClientPacketMaxFrameMicroseconds", "200000" },
        { "DFIntClientPacketExcessMicroseconds", "10000" },
        { "DFIntClientPacketMinMicroseconds", "1" },
        { "DFIntClientPacketMaxDelayMs", "1" },
        { "DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1" },
        { "DFIntMaxFrameBufferSize", "4" },
        { "DFIntBufferCompressionThreshold", "100" },
        { "DFIntOverrideISRReplicatorStepBandwidthBytes", "131072" },
        { "DFIntTaskSchedulerJobInGameThreads", "8" },
        { "FIntTaskSchedulerAutoThreadLimit", "16" },
        { "DFIntTaskSchedulerJobInitThreads", "8" },
        { "DFIntTaskSchedulerAsyncTasksMinimumThreadCount", "4" },
        { "DFIntRuntimeConcurrency", "16" },
        { "FIntSimWorldTaskQueueParallelTasks", "20" },
        { "DFIntHttpBatchLimit", "256" },
        { "DFIntHttpCurlConnectionCacheSize", "512" },
        { "FIntDefaultMeshCacheSizeMB", "512" },
        { "DFIntMemCacheMaxCapacityMB", "256" },
        { "DFIntNumAssetsMaxToPreload", "1" },
        { "DFFlagEnableSoundPreloading", "false" },
        { "FFlagSlimContentProvider", "true" },
        { "DFIntTextureQualityOverride", "0" },
        { "FIntDebugTextureManagerSkipMips", "7" },
        { "DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8" },
        { "FFlagTM2SkipMipsForUnstreamable2", "true" },
        { "DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true" },
        { "FFlagRenderUseTextureManager224", "false" },
        { "DFIntDebugFRMQualityLevelOverride", "1" },
        { "DFFlagDebugSkipMeshVoxelizer", "true" },
        { "DFFlagDebugPauseVoxelizer", "true" },
        { "FFlagFastGPULightCulling3", "true" },
        { "FIntRenderLocalLightFadeInMs", "0" },
        { "FIntRenderLocalLightUpdatesMax", "1" },
        { "FIntRenderShadowmapBias", "0" },
        { "FIntSSAOMipLevels", "0" },
        { "FIntDebugForceMSAASamples", "1" },
        { "FIntDebugFRMOptionalMSAALevelOverride", "0" },
        { "FIntRobloxGuiBlurIntensity", "0" },
        { "FIntFRMMinGrassDistance", "0" },
        { "FIntFRMMaxGrassDistance", "0" },
        { "DFFlagCoreScriptTelemetry2", "false" },
        { "DFFlagBrowserTrackerIdTelemetryEnabled", "false" },
        { "FFlagPerfDataOnTelemetryV2", "false" },
        { "FFlagSendRenderFidelityTelemetry2", "false" },
        { "FFlagEnableTelemetryServiceMemoryCPUInfo", "false" },
        { "DFIntTelemetryProfilerHundredthsPercentage", "0" },
        { "FIntTelemetryProfilerFrequency", "0" },
        { "FIntPerformanceTelemetryQueueProcessLimit", "0" },
        { "DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0" },
      }
    function _G.__AkatsukiPreserveOptimizerUI(jN)
      if not jN then
        return false
      end
      local eN = jN
      while eN and eN ~= workspace and eN ~= game do
        if
          eN:IsA("BillboardGui")
          or (eN:IsA("SurfaceGui"))
          or (eN:IsA("ScreenGui"))
          or (eN:IsA("GuiObject"))
          or (eN:IsA("UIComponent"))
        then
          return true
        end
        eN = eN.Parent
      end
      return false
    end
    local function jN(eN)
      local qN = type(getgenv) == "function" and (getgenv()) or _G
      local KN, GN =
        rawget(qN, "setfflag") or (rawget(_G, "set_fflag")),
        rawget(qN, "getfflag") or (rawget(_G, "get_fflag"))
      if type(KN) ~= "function" then
        return
      end
      for IN, FN in ipairs(YN) do
        if not x or eN ~= SN then
          return
        end
        qN = true
        if type(GN) == "function" then
          local YN, eN = pcall(GN, FN[1])
          qN = YN and eN ~= nil
        end
        if qN then
          pcall(KN, FN[1], FN[2])
        end
        if IN % 8 == 0 then
          D.Heartbeat:Wait()
        end
      end
    end
    local function YN(eN)
      pcall(function()
        if _G.__AkatsukiPreserveOptimizerUI(eN) then
          return
        end
        local qN = u.Character
        if qN and (eN == qN or (eN:IsDescendantOf(qN))) then
          return
        end
        if eN:IsDescendantOf(n) then
          return
        end
        if
          eN:IsA("Sky")
          or (eN:IsA("Atmosphere"))
          or (eN:IsA("ColorCorrectionEffect"))
          or (eN:IsA("BloomEffect"))
          or (eN:IsA("BlurEffect"))
          or (eN:IsA("Sparkles"))
          or (eN:IsA("PostEffect"))
        then
          return
        end
        if not (F == "Ultra") then
          if
            eN:IsA("ParticleEmitter")
            or (eN:IsA("Trail"))
            or (eN:IsA("Smoke"))
            or (eN:IsA("Fire"))
            or (eN:IsA("Sparkles"))
            or (eN:IsA("PostEffect"))
          then
            eN.Enabled = false
          end
          if tick() <= iN and (eN:IsA("Decal") or (eN:IsA("Texture"))) then
            eN.Transparency = 1
          end
          return
        end
        if
          eN:IsA("Accessory")
          or (eN:IsA("Hat"))
          or (eN:IsA("Clothing"))
          or (eN:IsA("Shirt"))
          or (eN:IsA("Pants"))
          or (eN:IsA("ShirtGraphic"))
        then
          eN:Destroy()
        elseif eN:IsA("BasePart") then
          eN.Material = Enum.Material.Plastic
          eN.Reflectance = 0
          eN.CastShadow = false
        elseif eN:IsA("Decal") or (eN:IsA("Texture")) then
          eN.Transparency = 1
        elseif
          eN:IsA("ParticleEmitter")
          or (eN:IsA("Trail"))
          or (eN:IsA("Beam"))
          or (eN:IsA("Fire"))
          or (eN:IsA("Smoke"))
          or (eN:IsA("Sparkles"))
        then
          eN.Enabled = false
        elseif eN:IsA("AnimationController") or (eN:IsA("Animator")) then
          for qN, qN in ipairs(eN:GetPlayingAnimationTracks()) do
            pcall(function()
              qN:Stop(0)
            end)
          end
        end
      end)
    end
    local function eN(qN)
      if UN then
        UN()
      end
      local KN = F == "Ultra" and { workspace } or { workspace, n }
      UN = _G.__AkatsukiWalkDescendantsBatched(KN, YN, function()
        return x and qN == hN
      end)
    end
    local function qN()
      if LN.Brightness == nil then
        LN.Brightness, LN.ClockTime, LN.OutdoorAmbient = n.Brightness, n.ClockTime, n.OutdoorAmbient
      end
      if ON.Decoration == nil then
        local KN = workspace:FindFirstChildOfClass("Terrain")
        if KN then
          ON = {
            terrain = KN,
            Decoration = KN.Decoration,
            WaterWaveSize = KN.WaterWaveSize,
            WaterWaveSpeed = KN.WaterWaveSpeed,
            WaterReflectance = KN.WaterReflectance,
          }
        end
      end
      if F == "Normal" then
        pcall(function()
          settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        pcall(function()
          n.GlobalShadows = false
          n.EnvironmentDiffuseScale = 0
          n.EnvironmentSpecularScale = 0
        end)
      else
        pcall(function()
          n.GlobalShadows = false
          n.FogEnd = 10000000000
          n.Brightness = 1
          n.EnvironmentDiffuseScale = 0
          n.EnvironmentSpecularScale = 0
        end)
      end
      local KN = ON.terrain
      if KN then
        pcall(function()
          KN.Decoration = false
          KN.WaterWaveSize = 0
          KN.WaterWaveSpeed = 0
          KN.WaterReflectance = 0
        end)
      end
      for KN, KN in ipairs(n:GetChildren()) do
        if KN:IsA("PostEffect") then
          pcall(function()
            KN.Enabled = false
          end)
        end
      end
    end
    local function KN()
      pcall(function()
        if LN.Brightness ~= nil then
          n.Brightness = LN.Brightness
          n.ClockTime = LN.ClockTime
          n.OutdoorAmbient = LN.OutdoorAmbient
        end
        n.ExposureCompensation = 0
        n.GlobalShadows = true
        n.FogEnd = 100000
        n.EnvironmentDiffuseScale = 1
        n.EnvironmentSpecularScale = 1
      end)
      local LN = ON.terrain
      if LN then
        pcall(function()
          LN.Decoration = ON.Decoration
          LN.WaterWaveSize = ON.WaterWaveSize
          LN.WaterWaveSpeed = ON.WaterWaveSpeed
          LN.WaterReflectance = ON.WaterReflectance
        end)
      end
    end
    local function LN()
      if not x then
        return
      end
      x, ZN = false, false
      hN += 1
      SN += 1
      if UN then
        UN()
        UN = nil
      end
      if t then
        t:Disconnect()
        t = nil
      end
      if nN then
        nN:Disconnect()
        nN = nil
      end
      if QN then
        QN:Disconnect()
        QN = nil
      end
      KN()
    end
    local function UN()
      if x then
        return
      end
      x, ZN = true, true
      hN += 1
      local ON = hN
      if F == "Normal" then
        iN = tick() + 1
        SN += 1
        local F = SN
        task.spawn(function()
          jN(F)
        end)
      end
      qN()
      eN(ON)
      t = workspace.DescendantAdded:Connect(function(F)
        if x and ON == hN then
          YN(F)
        end
      end)
      nN = n.DescendantAdded:Connect(function(F)
        if x and ON == hN then
          YN(F)
        end
      end)
      QN = u.CharacterAdded:Connect(function(F)
        task.delay(0.5, function()
          if x and ON == hN then
            eN(ON)
          end
        end)
      end)
      task.spawn(function()
        while x and ON == hN do
          task.wait(20)
          if x and ON == hN then
            eN(ON)
          end
        end
      end)
    end
    T.Optimizer = function(F)
      if F then
        UN()
      else
        LN()
      end
    end
    _G.__AkatsukiTrackStopper(LN)
  end
  R(_N, "FOV", "Custom FOV")
  do
    local F, x, t = false
    local function nN()
      if F then
        return
      end
      F = true
      y["Custom FOV"] = true
      if x then
        x:Disconnect()
      end
      local QN = workspace.CurrentCamera
      local UN = QN and t == nil
      if UN then
        t = QN.FieldOfView
      end
      x = D.RenderStepped:Connect(function()
        if not F then
          return
        end
        local UN, hN = workspace.CurrentCamera, J.FOV or 90
        if UN and math.abs(UN.FieldOfView - hN) > 0.01 then
          UN.FieldOfView = hN
        end
      end)
      if QN then
        QN.FieldOfView = J.FOV or 90
      end
      task.defer(oN)
    end
    local function QN()
      if not F then
        return
      end
      F = false
      y["Custom FOV"] = false
      if x then
        x:Disconnect()
        x = nil
      end
      local F = workspace.CurrentCamera
      if F then
        F.FieldOfView = t or 90
      end
      t = nil
      task.defer(oN)
    end
    T["Custom FOV"] = function(F)
      if F then
        nN()
      else
        QN()
      end
    end
    _G.__AkatsukiTrackStopper(QN)
    if y["Custom FOV"] then
      task.defer(nN)
    end
  end
  fN(_N, "Stretchz Res", "Stretchz Res")
  do
    local F, x = false
    local function t(nN)
      local QN = workspace.CurrentCamera
      if QN then
        pcall(function()
          QN.FieldOfView = nN
        end)
      end
    end
    local function nN()
      if F then
        return
      end
      F = true
      y["Stretchz Res"] = true
      local QN = workspace.CurrentCamera
      if not QN then
        return
      end
      if x then
        x:Disconnect()
      end
      x = D.RenderStepped:Connect(function()
        if not F then
          return
        end
        t(90)
        pcall(function()
          QN.CFrame = QN.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1)
        end)
      end)
      t(90)
      task.defer(oN)
    end
    local function t()
      F = false
      y["Stretchz Res"] = false
      if x then
        x:Disconnect()
        x = nil
      end
      local F = workspace.CurrentCamera
      if F then
        pcall(function()
          F.FieldOfView = 90
        end)
      end
      task.defer(oN)
    end
    T["Stretchz Res"] = function(F)
      if F then
        nN()
      else
        t()
      end
    end
    _G.__AkatsukiTrackStopper(t)
    if y["Stretchz Res"] then
      task.defer(nN)
    end
  end
  do
    local F = _G.__AkatsukiSkinChangerState
    if type(F) ~= "table" or F.version ~= 2 then
      if type(F) == "table" and u.Character then
        local x, t =
          F.originals and F.originals[u.Character], u.Character:FindFirstChildOfClass("Humanoid")
        if typeof(x) == "Instance" and t then
          pcall(function()
            t:ApplyDescription(x:Clone())
          end)
        end
      end
      F = { version = 2, originals = setmetatable({}, { __mode = "k" }), templates = {} }
      _G.__AkatsukiSkinChangerState = F
    end
    F.isHair = function(x)
      if not x:IsA("Accessory") then
        return false
      end
      local t, nN = pcall(function()
        return x.AccessoryType == Enum.AccessoryType.Hair
      end)
      return t and nN or x:FindFirstChild("HairAttachment", true) ~= nil
    end
    F.resolveTemplate = function(x, t, nN)
      local QN = t .. ":" .. tostring(x)
      if F.templates[QN] then
        return F.templates[QN]
      end
      local UN = "rbxassetid://" .. tostring(x)
      local hN, LN = pcall(function()
        return game:GetObjects(UN)
      end)
      if hN and LN and LN[1] then
        local hN = LN[1]
        x = hN:IsA(t) and hN or (hN:FindFirstChildWhichIsA(t, true))
        if x and x[nN] ~= "" then
          UN = x[nN]
        end
        pcall(function()
          hN:Destroy()
        end)
      end
      F.templates[QN] = UN
      return UN
    end
    F.removeChanged = function(x)
      for t, t in ipairs(x:GetChildren()) do
        if
          t:IsA("Shirt")
          or (t:IsA("Pants"))
          or t.Name == "AkatsukiSkinChanger_Hair"
          or (F.isHair(t))
        then
          pcall(function()
            t:Destroy()
          end)
        end
      end
    end
    F.capture = function(x)
      if F.originals[x] then
        return
      end
      local t = { items = {} }
      for nN, nN in ipairs(x:GetChildren()) do
        if nN:IsA("Shirt") or (nN:IsA("Pants")) or (F.isHair(nN)) then
          table.insert(t.items, nN:Clone())
        end
      end
      F.originals[x] = t
    end
    F.presets = {
      V1 = { shirt = 74707712629633, pants = 12405320750, hair = 140188532534398 },
      V2 = { shirt = 101796619834594, pants = 18975891159, hair = 115520061093937 },
      V3 = { shirt = 18552805597, pants = 5414143509, hair = 84008082880128 },
    }
    F.attachHair = function(x, t, nN, QN)
      local UN, hN = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(nN))
      end)
      if not UN or not hN or not hN[1] then
        warn("[Skin Changer] No se pudo cargar el pelo " .. tostring(nN) .. ": " .. tostring(hN))
        return false
      end
      local nN = hN[1]
      UN = nN:IsA("Accessory") and nN or (nN:FindFirstChildWhichIsA("Accessory", true))
      if not UN then
        nN:Destroy()
        warn("[Skin Changer] El asset de pelo no contiene un Accessory")
        return false
      end
      local hN = UN:Clone()
      hN.Name = "AkatsukiSkinChanger_Hair"
      pcall(function()
        nN:Destroy()
      end)
      local nN, LN = x:FindFirstChild("Head"), hN:FindFirstChild("Handle")
      if not nN or not LN or not LN:IsA("BasePart") then
        hN:Destroy()
        warn("[Skin Changer] Falta Head o Handle para colocar el pelo")
        return false
      end
      if not y["Skin Changer"] or u.Character ~= x or F.generation ~= QN then
        hN:Destroy()
        return false
      end
      UN, QN = pcall(function()
        for ON, ON in ipairs(hN:GetDescendants()) do
          if ON:IsA("BasePart") then
            ON.Anchored = false
            ON.CanCollide = false
            ON.Massless = true
            ON.LocalTransparencyModifier = 0
          end
        end
        LN.Transparency = 0
        pcall(function()
          t:AddAccessory(hN)
        end)
        hN.Parent = x
        local x, t
        for ON, iN in ipairs(LN:GetChildren()) do
          if iN:IsA("Attachment") then
            ON = nN:FindFirstChild(iN.Name)
            if ON and (ON:IsA("Attachment")) then
              x, t = iN, ON
              break
            end
          end
        end
        local ON, iN, SN =
          x and x.CFrame or hN.AttachmentPoint,
          t and t.CFrame or (CFrame.new(0, nN.Size.Y / 2, 0)),
          LN:FindFirstChild("AccessoryWeld")
        if SN then
          SN:Destroy()
        end
        LN.CFrame = nN.CFrame * iN * ON:Inverse()
        SN = Instance.new("Weld")
        SN.Name = "AccessoryWeld"
        SN.Part0 = LN
        SN.Part1 = nN
        SN.C0 = ON
        SN.C1 = iN
        SN.Parent = LN
      end)
      if not UN then
        hN:Destroy()
        warn("[Skin Changer] No se pudo colocar el pelo: " .. tostring(QN))
      end
      return UN
    end
    F.apply = function(x, t)
      F.generation = (F.generation or 0) + 1
      local nN = F.generation
      t = t or u.Character
      if not t then
        return false
      end
      local QN = t:FindFirstChildOfClass("Humanoid") or (t:WaitForChild("Humanoid", 10))
      if not QN then
        return false
      end
      if nN ~= F.generation then
        return false
      end
      if x then
        local x = F.presets[S] or F.presets.V1
        local UN, hN =
          F.resolveTemplate(x.shirt, "Shirt", "ShirtTemplate"),
          F.resolveTemplate(x.pants, "Pants", "PantsTemplate")
        if nN ~= F.generation or not y["Skin Changer"] or u.Character ~= t then
          return false
        end
        F.capture(t)
        F.removeChanged(t)
        local LN = Instance.new("Shirt")
        LN.Name = "AkatsukiSkinChanger_Shirt"
        LN.ShirtTemplate = UN
        LN.Parent = t
        LN = Instance.new("Pants")
        LN.Name = "AkatsukiSkinChanger_Pants"
        LN.PantsTemplate = hN
        LN.Parent = t
        return F.attachHair(t, QN, x.hair, nN)
      end
      nN = F.originals[t]
      F.removeChanged(t)
      if not nN then
        return false
      end
      for x, x in ipairs(nN.items) do
        local nN = x:Clone()
        if nN:IsA("Accessory") then
          pcall(function()
            QN:AddAccessory(nN)
          end)
        else
          nN.Parent = t
        end
      end
      return true
    end
    T["Skin Changer"] = function(x)
      task.spawn(function()
        if x ~= (y["Skin Changer"] == true) then
          return
        end
        F.apply(x == true, u.Character)
      end)
    end
    _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function(x)
      if not y["Skin Changer"] then
        return
      end
      task.wait(0.75)
      if y["Skin Changer"] then
        F.apply(true, x)
      end
    end))
    if y["Skin Changer"] then
      task.delay(0.5, F.apply, true, u.Character)
    end
  end
  do
    local F = _G.__AkatsukiVisualAppearanceState
    if type(F) ~= "table" or F.version ~= 2 then
      F = {
        version = 2,
        headless = setmetatable({}, { __mode = "k" }),
        korblox = setmetatable({}, { __mode = "k" }),
      }
      _G.__AkatsukiVisualAppearanceState = F
    end
    F.setHeadless = function(x, t)
      t = t or u.Character
      local nN = t and (t:FindFirstChild("Head"))
      if not nN or not nN:IsA("BasePart") then
        return false
      end
      if x then
        if not F.headless[t] then
          local QN = {
            headTransparency = nN.Transparency,
            headLocalTransparency = nN.LocalTransparencyModifier,
            faces = {},
          }
          for UN, UN in ipairs(nN:GetChildren()) do
            if UN:IsA("Decal") or (UN:IsA("Texture")) then
              table.insert(QN.faces, { item = UN, transparency = UN.Transparency })
            end
          end
          F.headless[t] = QN
        end
        nN.Transparency = 1
        nN.LocalTransparencyModifier = 1
        for QN, QN in ipairs(nN:GetChildren()) do
          if QN:IsA("Decal") or (QN:IsA("Texture")) then
            QN.Transparency = 1
          end
        end
        return true
      end
      x = F.headless[t]
      if not x then
        return false
      end
      nN.Transparency = x.headTransparency
      nN.LocalTransparencyModifier = x.headLocalTransparency
      for t, t in ipairs(x.faces) do
        if t.item and t.item.Parent then
          t.item.Transparency = t.transparency
        end
      end
      return true
    end
    F.setKorblox = function(x, t)
      t = t or u.Character
      if not t then
        return false
      end
      local nN = F.korblox[t]
      if not x then
        local QN = t:FindFirstChild("AkatsukiVisual_Korblox")
        if QN then
          pcall(function()
            QN:Destroy()
          end)
        end
        for QN, QN in ipairs(t:GetChildren()) do
          if QN:IsA("CharacterMesh") and QN.Name == "AkatsukiVisual_KorbloxCharacterMesh" then
            pcall(function()
              QN:Destroy()
            end)
          end
        end
        if not nN then
          return false
        end
        for QN, QN in ipairs(nN.parts) do
          if QN.part and QN.part.Parent then
            QN.part.Transparency = QN.transparency
            QN.part.LocalTransparencyModifier = QN.localTransparency
          end
        end
        return true
      end
      x = t:FindFirstChild("LeftUpperLeg") or (t:FindFirstChild("Left Leg"))
      if not x or not x:IsA("BasePart") then
        return false
      end
      local QN, UN = pcall(function()
        return game:GetObjects("rbxassetid://139607673")
      end)
      if not QN or not UN or not UN[1] then
        warn("Akatsuki Korblox: no se pudo cargar el asset 139607673")
        return false
      end
      local hN = t:FindFirstChild("AkatsukiVisual_Korblox")
      if hN then
        pcall(function()
          hN:Destroy()
        end)
      end
      for hN, hN in ipairs(t:GetChildren()) do
        if hN:IsA("CharacterMesh") and hN.Name == "AkatsukiVisual_KorbloxCharacterMesh" then
          pcall(function()
            hN:Destroy()
          end)
        end
      end
      QN = Instance.new("Model")
      QN.Name = "AkatsukiVisual_Korblox"
      for hN, hN in ipairs(UN) do
        hN.Parent = QN
      end
      UN = {}
      for hN, hN in ipairs(QN:GetDescendants()) do
        if hN:IsA("BasePart") then
          table.insert(UN, hN)
        end
      end
      local hN = {}
      for LN, LN in ipairs(QN:GetDescendants()) do
        if LN:IsA("CharacterMesh") then
          table.insert(hN, LN)
        end
      end
      if #UN == 0 and #hN == 0 then
        QN:Destroy()
        warn("Akatsuki Korblox: el asset 139607673 no contiene piezas compatibles")
        return false
      end
      if not nN then
        nN = { parts = {} }
        local LN = { "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg" }
        for ON, iN in ipairs(LN) do
          ON = t:FindFirstChild(iN)
          if ON and (ON:IsA("BasePart")) then
            table.insert(nN.parts, {
              part = ON,
              transparency = ON.Transparency,
              localTransparency = ON.LocalTransparencyModifier,
            })
          end
        end
        F.korblox[t] = nN
      end
      QN.Parent = t
      if t:FindFirstChild("LeftUpperLeg") ~= nil then
        for LN, LN in ipairs(nN.parts) do
          if LN.part and LN.part.Parent then
            LN.part.Transparency = 1
            LN.part.LocalTransparencyModifier = 1
          end
        end
      end
      for nN, LN in ipairs(UN) do
        QN = t:FindFirstChild(LN.Name)
        QN = if not QN or not QN:IsA("BasePart") then x else QN
        LN.Anchored = false
        LN.CanCollide = false
        LN.Massless = true
        LN.CFrame = QN.CFrame
        nN = Instance.new("WeldConstraint")
        nN.Part0 = QN
        nN.Part1 = LN
        nN.Parent = LN
      end
      for x, x in ipairs(hN) do
        x.Name = "AkatsukiVisual_KorbloxCharacterMesh"
        x.Parent = t
      end
      return true
    end
    T["Headless Visual"] = function(x)
      F.setHeadless(x == true, u.Character)
    end
    T["Korblox Visual"] = function(x)
      task.spawn(F.setKorblox, x == true, u.Character)
    end
    _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function(x)
      task.wait(0.75)
      if y["Headless Visual"] then
        F.setHeadless(true, x)
      end
      if y["Korblox Visual"] then
        F.setKorblox(true, x)
      end
    end))
    if y["Headless Visual"] then
      task.delay(0.5, F.setHeadless, true, u.Character)
    end
    if y["Korblox Visual"] then
      task.delay(0.5, F.setKorblox, true, u.Character)
    end
  end
  do
    local F, x = {
      Ambient = n.Ambient,
      Brightness = n.Brightness,
      ClockTime = n.ClockTime,
      FogColor = n.FogColor,
      FogEnd = n.FogEnd,
      GlobalShadows = n.GlobalShadows,
      EnvironmentDiffuseScale = n.EnvironmentDiffuseScale,
      EnvironmentSpecularScale = n.EnvironmentSpecularScale,
      OutdoorAmbient = n.OutdoorAmbient,
    }
    I = _G.__AkatsukiSkyChangerMode or "blue"
    local function t()
      if x then
        pcall(function()
          x:Destroy()
        end)
        x = nil
      end
    end
    local function nN()
      t()
      pcall(function()
        n.Ambient = F.Ambient
        n.Brightness = F.Brightness
        n.ClockTime = F.ClockTime
        n.FogColor = F.FogColor
        n.FogEnd = F.FogEnd
        n.GlobalShadows = F.GlobalShadows
        n.EnvironmentDiffuseScale = F.EnvironmentDiffuseScale
        n.EnvironmentSpecularScale = F.EnvironmentSpecularScale
        n.OutdoorAmbient = F.OutdoorAmbient
      end)
    end
    U = function(F)
      if F == nil or F == "none" then
        nN()
        return
      end
      t()
      local t = Instance.new("ColorCorrectionEffect")
      t.Parent = n
      x = t
      if F == "blue" then
        n.Ambient = Color3.fromRGB(30, 60, 120)
        n.FogColor = Color3.fromRGB(40, 80, 160)
        t.TintColor = Color3.fromRGB(140, 180, 255)
        t.Saturation = 0.4
        t.Contrast = 0.1
      elseif F == "night" then
        n.ClockTime = 0
        n.Brightness = 0.2
        n.Ambient = Color3.fromRGB(20, 20, 35)
        t.TintColor = Color3.fromRGB(180, 180, 220)
        t.Saturation = -0.2
        t.Contrast = 0.1
      elseif F == "day" then
        n.ClockTime = 14
        n.Brightness = 2
        n.Ambient = Color3.fromRGB(140, 140, 140)
        t.TintColor = Color3.fromRGB(255, 255, 255)
        t.Saturation = 0.1
        t.Contrast = 0
      end
    end
    T["Sky Changer"] = function(n)
      if n then
        U(I)
      else
        nN()
      end
    end
    R = fN(_N, "Sky Changer", "Sky Changer")
    if R then
      local n = Instance.new("TextButton", R)
      n.Name = "SkyModeBtn"
      n.Size = UDim2.new(0, 66, 0, 20)
      n.Position = UDim2.new(1, -74, 0.5, -10)
      n.AnchorPoint = Vector2.new(0, 0)
      n.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
      n.BorderSizePixel = 0
      n.Text = "BLUE"
      n.TextColor3 = Color3.fromRGB(238, 238, 242)
      n.Font = Enum.Font.GothamBold
      n.TextSize = 10
      n.AutoButtonColor = false
      n.ZIndex = 30
      Instance.new("UICorner", n).CornerRadius = UDim.new(0, 4)
      local F = Instance.new("UIStroke", n)
      F.Color = Color3.fromRGB(255, 255, 255)
      F.Thickness = 1
      F.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      local function x()
        n.Text = I == "day" and "DAY" or I == "night" and "NIGHT" or "BLUE"
        n.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        n.TextColor3 = Color3.fromRGB(238, 238, 242)
        F.Color = Color3.fromRGB(255, 255, 255)
        F.Thickness = 1
        n.TextStrokeTransparency = 1
      end
      x()
      v(n, function()
        I = if I == "day" then "blue" else if I == "blue" then "night" else "day"
        _G.__AkatsukiSkyChangerMode = I
        oN()
        x()
        if y["Sky Changer"] then
          U(I)
        end
      end)
    end
    if y["Sky Changer"] then
      task.delay(0.2, function()
        U(I)
      end)
    end
  end
  fN(_N, "Show Buttons", "Show Buttons")
  fN(_N, "Lock Buttons", "Lock Buttons")
  do
    c = Instance.new("Frame", _N)
    c.Name = "MainThemesBtnContainer"
    c.Visible = false
    c.Size = UDim2.new(1, 0, 0, 30)
    c.BackgroundTransparency = 1
    c.BorderSizePixel = 0
    c.ZIndex = 12
    R = Instance.new("TextButton", c)
    R.Name = "MainThemesBtn"
    R.AnchorPoint = Vector2.new(0.5, 0)
    R.Size = UDim2.new(0, 150, 0, 30)
    R.Position = UDim2.new(0.5, 0, 0, 0)
    R.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    R.BackgroundTransparency = 0.12
    R.AutoButtonColor = false
    R.Font = Enum.Font.GothamBold
    R.Text = "Themes"
    R.TextColor3 = Color3.fromRGB(235, 240, 245)
    R.TextSize = 11
    R.ZIndex = 12
    R.TextXAlignment = Enum.TextXAlignment.Center
    R.TextYAlignment = Enum.TextYAlignment.Center
    Instance.new("UICorner", R).CornerRadius = UDim.new(0, 8)
    r = Instance.new("UIStroke", R)
    r.Color = Color3.fromRGB(255, 255, 255)
    r.Thickness = 1.2
    r.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    r.Transparency = 0.15
    local n = Instance.new("Frame")
    n.Name = "MainThemesPanel"
    n.Size = UDim2.fromOffset(260, 268)
    n.BackgroundColor3 = Color3.fromRGB(50, 24, 28)
    n.BorderSizePixel = 0
    n.Visible = false
    n.ZIndex = 20
    n.Parent = h
    local F = Instance.new("UIGradient", n)
    F.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 20, 24)),
      ColorSequenceKeypoint.new(0.48, Color3.fromRGB(72, 30, 36)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(36, 19, 23)),
    })
    F.Rotation = 35
    local function x()
      if g then
        local t = g.Position.X.Offset + g.Size.X.Offset
        n.Position =
          UDim2.new(g.Position.X.Scale, t + 24, g.Position.Y.Scale, g.Position.Y.Offset + 6)
      end
    end
    if g then
      g:GetPropertyChangedSignal("Position"):Connect(function()
        if _G.__AkatsukiModernGuiActive or not n.Parent then
          return
        end
        if n.Visible then
          x()
        end
      end)
      g:GetPropertyChangedSignal("Size"):Connect(function()
        if _G.__AkatsukiModernGuiActive or not n.Parent then
          return
        end
        if n.Visible then
          x()
        end
      end)
      local t = false
      g:GetPropertyChangedSignal("Visible"):Connect(function()
        if _G.__AkatsukiModernGuiActive or not n.Parent then
          return
        end
        if not g.Visible then
          if n.Visible then
            t = true
            n.Visible = false
          else
            t = false
          end
        elseif t then
          x()
          n.Visible = true
        end
      end)
    end
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 12)
    F = Instance.new("UIStroke", n)
    F.Color = Color3.fromRGB(0, 0, 0)
    F.Thickness = 0
    F.Transparency = 1
    local t, nN = pN or 1, {}
    local function QN()
      for UN, hN in ipairs(nN) do
        local LN, ON, iN, SN, ZN, YN, jN, eN =
          UN == t, hN.card, hN.image, hN.stroke, hN.baseX, hN.baseY, hN.baseW, hN.baseH
        SN.Color = Color3.fromRGB(255, 255, 255)
        SN.Thickness = LN and 2 or 1.5
        SN.Transparency = LN and 0.25 or 0.7
        SN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ON.Size = LN and (UDim2.fromOffset(math.max(4, jN - 6), math.max(4, eN - 6)))
          or (UDim2.fromOffset(jN, eN))
        ON.Position = LN and (UDim2.new(0, ZN + 3, 0, YN + 3)) or (UDim2.new(0, ZN, 0, YN))
        ON.BackgroundTransparency = 1
        iN.Size = UDim2.new(1, 0, 1, 0)
        iN.Position = UDim2.new(0, 0, 0, 0)
        iN.BackgroundTransparency = 1
      end
    end
    local function UN()
      if not n or not nN then
        return
      end
      local hN, LN =
        n.AbsoluteSize.X > 0 and n.AbsoluteSize.X or n.Size.X.Offset,
        n.AbsoluteSize.Y > 0 and n.AbsoluteSize.Y or n.Size.Y.Offset
      local ON, iN = math.max(0, hN - 24), math.max(0, LN - 36 - 24)
      hN, LN = math.floor((ON - 10) / 2), math.floor((iN - 10) / 2)
      for SN, ZN in ipairs(nN) do
        ON, iN = (SN - 1) % 2, math.floor((SN - 1) / 2)
        local SN, YN = 12 + ON * (hN + 10), 12 + iN * (LN + 10)
        ZN.baseX = SN
        ZN.baseY = YN
        ZN.baseW = hN
        ZN.baseH = LN
        ZN.card.Size = UDim2.fromOffset(hN, LN)
        ZN.card.Position = UDim2.new(0, SN, 0, YN)
        ZN.image.Size = UDim2.new(1, 0, 1, 0)
        ZN.image.Position = UDim2.new(0, 0, 0, 0)
      end
    end
    for hN, LN in ipairs(uN) do
      F = Instance.new("TextButton", n)
      F.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
      F.BackgroundTransparency = 1
      F.BorderSizePixel = 0
      F.Text = ""
      F.AutoButtonColor = false
      F.ZIndex = 21
      Instance.new("UICorner", F).CornerRadius = UDim.new(0, 7)
      local ON = Instance.new("ImageLabel", F)
      ON.BackgroundTransparency = 1
      ON.Image = LN
      ON.ScaleType = Enum.ScaleType.Crop
      ON.ZIndex = 21
      Instance.new("UICorner", ON).CornerRadius = UDim.new(0, 7)
      LN = Instance.new("TextLabel", F)
      LN.Size = UDim2.new(1, -12, 0, 12)
      LN.Position = UDim2.new(0, 6, 1, -14)
      LN.BackgroundTransparency = 1
      LN.Text = "GUI " .. tostring(hN)
      LN.TextColor3 = Color3.fromRGB(235, 240, 245)
      LN.TextSize = 8
      LN.Font = Enum.Font.GothamBold
      LN.ZIndex = 23
      LN.TextStrokeColor3 = Color3.fromRGB(6, 6, 9)
      LN.TextStrokeTransparency = 0.25
      LN = Instance.new("UIStroke", F)
      LN.Color = Color3.fromRGB(255, 255, 255)
      LN.Thickness = 0
      LN.Transparency = 1
      LN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      table.insert(
        nN,
        { card = F, image = ON, stroke = LN, baseX = 0, baseY = 0, baseW = 0, baseH = 0 }
      )
      F.Activated:Connect(function()
        t = hN
        QN()
      end)
    end
    F = Instance.new("TextButton", n)
    F.Size = UDim2.new(1, -24, 0, 28)
    F.Position = UDim2.new(0, 12, 1, -44)
    pcall(function()
      UN()
    end)
    n:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
      pcall(UN)
    end)
    F.BackgroundColor3 = Color3.fromRGB(190, 42, 52)
    F.BorderSizePixel = 0
    F.Text = "Save Theme"
    F.TextColor3 = Color3.fromRGB(235, 240, 245)
    F.TextSize = 11
    F.Font = Enum.Font.GothamBold
    F.ZIndex = 21
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 7)
    F.Activated:Connect(function()
      pN = t
      if yN then
        yN.Image = uN[pN]
      end
      n.Visible = false
      if HN then
        pcall(function()
          HN.Text = tostring(pN) .. "/" .. tostring(#uN)
        end)
      end
      _G._AkatsukiHub_UI_BgIndex = pN
      oN()
    end)
    R.Activated:Connect(function()
      t = pN
      x()
      n.Visible = not n.Visible
      QN()
    end)
    if HN then
      pcall(function()
        HN.Visible = false
      end)
    end
  end
  do
    local n = _G.__AkatsukiQuickButtonsFrame
    if n then
      pcall(function()
        n:Destroy()
      end)
    end
    local n = Instance.new("Frame")
    n.Name = "AkatsukiQuickButtons"
    n.Size = UDim2.new(1, 0, 1, 0)
    n.Position = UDim2.new(0, 0, 0, 0)
    n.BackgroundTransparency = 1
    n.BorderSizePixel = 0
    n.Active = false
    n.ZIndex = 750
    n.Visible = y["Show Buttons"] == true
    n.Parent = h
    _G.__AkatsukiQuickButtonsFrame = n
    local function F(x, t)
      local nN = Instance.new("TextButton")
      nN.Name = x:gsub("%s+", "") .. "Button"
      local QN = Instance.new("UIScale", nN)
      QN.Name = "QuickButtonSizeScale"
      QN.Scale = _G.__AkatsukiButtonsSize or 1
      QN = p and 48 or 50
      nN.Size = UDim2.new(0, QN, 0, QN)
      local UN, yN = p and 72 or 81, p and 12 or 16
      if t <= 3 then
        nN.Position = UDim2.new(0, yN, 0, UN + (t - 1) * (QN + 8))
      else
        local HN = t - 4
        nN.Position = UDim2.new(0, yN + QN + 8, 0, UN + HN * (QN + 8))
      end
      nN.LayoutOrder = t
      nN:SetAttribute("OriginalPosition", nN.Position)
      nN.BackgroundColor3 = Color3.fromRGB(28, 32, 40)
      nN.BackgroundTransparency = 0.18
      nN.BorderSizePixel = 0
      nN.AutoButtonColor = false
      nN.Active = true
      nN.Draggable = false
      nN.Font = Enum.Font.GothamBold
      nN.Text = x
      nN.TextScaled = true
      nN.TextWrapped = true
      nN.TextColor3 = Color3.fromRGB(225, 225, 232)
      nN.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      nN.TextStrokeTransparency = 0
      nN.ZIndex = 751
      nN.Parent = n
      Instance.new("UICorner", nN).CornerRadius = UDim.new(0, p and 10 or 12)
      yN = Instance.new("UITextSizeConstraint")
      yN.MinTextSize = p and 7 or 8
      yN.MaxTextSize = p and 9 or 10
      yN.Parent = nN
      QN = Instance.new("UIAspectRatioConstraint")
      QN.AspectRatio = 1
      QN.Parent = nN
      UN = Instance.new("UIStroke")
      UN.Color = Color3.fromRGB(0, 0, 0)
      UN.Thickness = 1
      UN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      UN.Transparency = 0.15
      UN.Parent = nN
      return nN, UN
    end
    local x, t = F("AIMBOT", 1)
    local nN, QN = F("BAT TP", 2)
    local UN, yN = F("TP DOWN", 3)
    local HN, hN = F("DROP", 4)
    local LN, ON = F("CARRY SPEED", 5)
    local iN, SN = F("LAGGER SPEED", 6)
    local ZN, YN = F("AUTO PLAY", 7)
    local jN = { custom = {} }
    R = jN.custom
    R.button, jN.custom.stroke = F("CUSTOM SPEED", 8)
    jN.custom.button.Visible = true
    jN.custom.getByName = function(F)
      for eN, eN in ipairs(L) do
        if eN.name == F then
          return eN
        end
      end
      return nil
    end
    jN.custom.getSelected = function()
      local F = jN.custom.getByName(Z)
      if F then
        jN.custom.lastName = F.name
        return F
      end
      return jN.custom.getByName(jN.custom.lastName) or L[1]
    end
    local function F(eN, qN, KN)
      eN.BackgroundColor3 = KN and (Color3.fromRGB(215, 220, 225)) or (Color3.fromRGB(28, 32, 40))
      eN.TextColor3 = KN and (Color3.fromRGB(255, 255, 255)) or (Color3.fromRGB(225, 225, 232))
      eN.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      eN.TextStrokeTransparency = 0
      qN.Color = Color3.fromRGB(0, 0, 0)
      qN.Thickness = KN and 1.5 or 1
      qN.Transparency = 0.15
    end
    local function eN(qN)
      local KN = not (y[qN] == true)
      if
        KN
        and ({})[qN]
        and u:GetAttribute("Stealing") == true
        and not (_G._AkatsukiHub_BypassAuto == true)
      then
        return
      end
      y[qN] = KN
      if d[qN] then
        pcall(d[qN], KN)
      end
      if T[qN] then
        pcall(T[qN], KN)
      end
      oN()
    end
    local d = { x, nN, UN, HN, LN, iN, ZN, jN.custom.button }
    task.defer(function()
      for qN, KN in ipairs(d) do
        qN = B[KN.Name]
        if qN and qN.x and qN.y then
          local GN, IN = X(KN, 0, qN.x, 0, qN.y, _G.__AkatsukiButtonsSize or 1)
          KN.Position = UDim2.new(0, GN, 0, IN)
          B[KN.Name] = { x = GN, y = IN }
        else
          local qN = KN.Position
          X(KN, qN.X.Scale, qN.X.Offset, qN.Y.Scale, qN.Y.Offset, _G.__AkatsukiButtonsSize or 1)
        end
      end
    end)
    local qN, KN, GN, IN
    local FN = false
    function _G.__AkatsukiSetButtonsSize(kN)
      local EN = tonumber((tostring(kN):gsub(",", ".")))
      if not EN or EN ~= EN or math.abs(EN) == math.huge then
        return _G.__AkatsukiButtonsSize
      end
      EN = math.floor(math.clamp(EN, 0.5, 2) * 100 + 0.5) / 100
      _G.__AkatsukiButtonsSize = EN
      qN, KN, GN, IN, FN = nil, nil, nil, nil, false
      for kN, lN in ipairs(d) do
        lN.QuickButtonSizeScale.Scale = EN
        kN = lN.Position
        local NN, mN = X(lN, kN.X.Scale, kN.X.Offset, kN.Y.Scale, kN.Y.Offset, EN)
        if B[lN.Name] then
          B[lN.Name] = { x = NN, y = mN }
        end
      end
      oN()
      return EN
    end
    jN.resetPositions = function()
      if qN then
        local kN = qN
        jN[kN] = true
        task.delay(0.2, function()
          jN[kN] = nil
        end)
      end
      qN, KN, GN, IN, FN = nil, nil, nil, nil, false
      table.clear(B)
      for kN, EN in ipairs(d) do
        kN = EN:GetAttribute("OriginalPosition")
        X(EN, kN.X.Scale, kN.X.Offset, kN.Y.Scale, kN.Y.Offset, _G.__AkatsukiButtonsSize or 1)
      end
      _G.__AkatsukiGuiPositionsReset = true
      for kN, kN in pairs(_G.__AkatsukiGuiPositionResetters) do
        kN()
      end
      oN()
    end
    _G.__AkatsukiResetButtonPositions = jN.resetPositions
    local function kN()
      return y["Lock Buttons"] == true
    end
    local function EN(lN)
      if not qN or not KN or not GN then
        return
      end
      local NN = lN.Position - KN
      lN = NN.Magnitude
      if lN > 6 then
        FN = true
      end
      local lN, mN =
        workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or (Vector2.new(0, 0)),
        qN.AbsoluteSize
      local sN, MN =
        math.clamp(GN.X.Offset + NN.X, 0, math.max(0, lN.X - mN.X)),
        math.clamp(GN.Y.Offset + NN.Y, 0, math.max(0, lN.Y - mN.Y))
      qN.Position = UDim2.new(0, sN, 0, MN)
    end
    for lN, lN in ipairs(d) do
      lN.InputBegan:Connect(function(d)
        if kN() then
          return
        end
        if
          d.UserInputType == Enum.UserInputType.MouseButton1
          or d.UserInputType == Enum.UserInputType.Touch
        then
          qN = lN
          KN = d.Position
          GN, IN, FN = lN.Position, d, false
        end
      end)
    end
    _G.__AkatsukiTrackConn(C.InputChanged:Connect(function(d)
      if not qN or (kN()) then
        return
      end
      if d.UserInputType == Enum.UserInputType.MouseMovement or d == IN then
        EN(d)
      end
    end))
    _G.__AkatsukiTrackConn(C.InputEnded:Connect(function(d)
      local kN = IN
        and IN.UserInputType == Enum.UserInputType.MouseButton1
        and d.UserInputType == Enum.UserInputType.MouseButton1
      if qN and (d == IN or kN) then
        local d = qN
        local kN = d
        qN, KN, GN, IN = nil, nil, nil, nil
        if FN then
          B[kN.Name] = { x = kN.Position.X.Offset, y = kN.Position.Y.Offset }
          oN()
          jN[kN] = true
          task.delay(0.2, function()
            jN[d] = nil
          end)
        end
      end
    end))
    local function d(B, qN)
      B.Activated:Connect(function()
        if jN[B] then
          jN[B] = nil
          return
        end
        qN()
      end)
    end
    d(x, function()
      eN("Aimbot")
    end)
    d(nN, function()
      if _.controller and _.controller.Toggle then
        pcall(_.controller.Toggle)
      else
        eN("TP Bat")
      end
    end)
    d(UN, function()
      if FeatureToggles["TP Down"] then
        pcall(FeatureToggles["TP Down"])
      end
    end)
    d(HN, function()
      if FeatureToggles.Drop then
        pcall(FeatureToggles.Drop, "button")
      end
    end)
    d(LN, function()
      if G == "v2" then
        K = not K
        y["Carry Speed"] = K
        y["Speed Boost"] = true
        if _G.__refreshSpeedBoost then
          pcall(_G.__refreshSpeedBoost)
        end
        if M["Carry Speed"] then
          M["Carry Speed"]()
        end
        pcall(function()
          if _G.__refreshSpeedBillboards then
            _G.__refreshSpeedBillboards()
          end
        end)
        oN()
      elseif FeatureToggles["Carry Speed"] then
        pcall(FeatureToggles["Carry Speed"])
      else
        eN("Carry Speed")
      end
    end)
    d(iN, function()
      if Z == "Lagger" then
        if FeatureToggles.SelectNormalMode then
          pcall(FeatureToggles.SelectNormalMode)
        end
      elseif FeatureToggles.SelectLaggerMode then
        pcall(FeatureToggles.SelectLaggerMode)
      end
    end)
    d(ZN, function()
      if FeatureToggles.Autoplay then
        pcall(FeatureToggles.Autoplay)
      end
    end)
    d(jN.custom.button, function()
      local d = jN.custom.getSelected()
      if d and Z ~= d.name then
        JN(d.name)
      end
    end)
    local d, B = 0, {}
    _G.__AkatsukiTrackConn(D.Heartbeat:Connect(function(eN)
      d += eN or 0
      if d < 0.4 then
        return
      end
      d = 0
      eN = y["Show Buttons"] == true
      if B.show ~= eN then
        n.Visible = eN
        B.show = eN
      end
      if not eN then
        return
      end
      local n, d, qN, KN, GN =
        y.Aimbot == true,
        y["TP Bat"] == true,
        y["Carry Speed"] == true,
        y.Autoplay == true,
        jN.custom.getByName(Z)
      eN = GN or (jN.custom.getSelected())
      if B.carryVisible ~= true then
        LN.Visible = true
        B.carryVisible = true
      end
      if B.aimbot ~= n then
        F(x, t, n)
        B.aimbot = n
      end
      if B.autoBat ~= d then
        F(nN, QN, d)
        B.autoBat = d
      end
      if B.carry ~= qN then
        F(LN, ON, qN)
        B.carry = qN
      end
      if B.autoplay ~= KN then
        F(ZN, YN, KN)
        B.autoplay = KN
      end
      KN = eN and eN.name or nil
      if B.customName ~= KN or B.customActive ~= (GN ~= nil) then
        jN.custom.button.Text = KN and "CUSTOM\10" .. string.upper(KN) or "NO CUSTOM"
        F(jN.custom.button, jN.custom.stroke, GN ~= nil)
        B.customName = KN
        B.customActive = GN ~= nil
      end
      n = Z == "Lagger"
      if B.lagger ~= n then
        iN.Text = n and "NORMAL SPEED" or "LAGGER SPEED"
        F(iN, SN, n)
        B.lagger = n
      end
      if B.actionsInitialized ~= true then
        F(UN, yN, false)
        F(HN, hN, false)
        B.actionsInitialized = true
      end
    end))
  end
  do
    _N = aN(k.Visuals, "PANELS")
    r = Instance.new("Frame", _N)
    r.Size = UDim2.new(1, -10, 0, 104)
    r.Position = UDim2.new(0, 5, 0, 28)
    r.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
    r.BackgroundTransparency = 0.12
    r.BorderSizePixel = 0
    Instance.new("UICorner", r).CornerRadius = UDim.new(0, 8)
    R = Instance.new("UIStroke", r)
    R.Color = Color3.fromRGB(0, 0, 0)
    R.Thickness = 1.2
    R.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    R.Transparency = 0.15
    c = Instance.new("Frame", r)
    c.Size = UDim2.new(1, -18, 0, 30)
    c.Position = UDim2.new(0, 9, 0, 10)
    c.BackgroundTransparency = 1
    local n = Instance.new("TextButton", c)
    n.Size = UDim2.new(0.5, -4, 1, 0)
    n.Position = UDim2.new(0, 0, 0, 0)
    n.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    n.BackgroundTransparency = 0.15
    n.BorderSizePixel = 0
    n.Text = "BYPASS"
    n.TextColor3 = Color3.fromRGB(205, 205, 212)
    n.TextSize = 11
    n.Font = Enum.Font.GothamBold
    n.AutoButtonColor = false
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 6)
    local F = Instance.new("UIStroke", n)
    F.Color = Color3.fromRGB(0, 0, 0)
    F.Thickness = 1
    F.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local d = Instance.new("TextButton", c)
    d.Size = UDim2.new(0.5, -4, 1, 0)
    d.Position = UDim2.new(0.5, 4, 0, 0)
    d.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    d.BackgroundTransparency = 0.15
    d.BorderSizePixel = 0
    d.Text = "LAGGER"
    d.TextColor3 = Color3.fromRGB(205, 205, 212)
    d.TextSize = 11
    d.Font = Enum.Font.GothamBold
    d.AutoButtonColor = false
    Instance.new("UICorner", d).CornerRadius = UDim.new(0, 6)
    local c = Instance.new("UIStroke", d)
    c.Color = Color3.fromRGB(0, 0, 0)
    c.Thickness = 1
    c.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local x = false
    local function B()
      d.BackgroundColor3 = x and (Color3.fromRGB(210, 38, 50)) or (Color3.fromRGB(28, 28, 32))
      d.TextColor3 = x and (Color3.fromRGB(248, 248, 250)) or (Color3.fromRGB(205, 205, 212))
      c.Color = x and (Color3.fromRGB(255, 165, 172)) or (Color3.fromRGB(88, 34, 40))
      c.Thickness = x and 1.5 or 1
    end
    (function()
      local c, t, nN =
        {
          Cartoon = {
            RunAnim = 742638842,
            WalkAnim = 742640026,
            JumpAnim = 742637942,
            FallAnim = 742637151,
            Swim = 742639220,
            SwimIdle = 742639812,
            ClimbAnim = 742636889,
            Idle = { 742637544, 742638445, 885477856 },
          },
          ["Adidas Community"] = {
            WalkAnim = 122150855457006,
            RunAnim = 82598234841035,
            JumpAnim = 75290611992385,
            FallAnim = 98600215928904,
            SwimIdle = 109346520324160,
            Swim = 133308483266208,
            Animation1 = 122257458498464,
            Animation2 = 102357151005774,
            ClimbAnim = 88763136693023,
          },
          ["Adidas Aura"] = {
            WalkAnim = 83842218823011,
            RunAnim = 118320322718866,
            JumpAnim = 109996626521204,
            FallAnim = 95603166884636,
            SwimIdle = 94922130551805,
            Swim = 134530128383903,
            Animation1 = 110211186840347,
            Animation2 = 114191137265065,
            ClimbAnim = 97824616490448,
          },
          Zombie = {
            WalkAnim = 10921355261,
            RunAnim = 616163682,
            JumpAnim = 10921351278,
            FallAnim = 10921350320,
            SwimIdle = 10921353442,
            Swim = 10921352344,
            Animation1 = 10921344533,
            Animation2 = 10921345304,
            ClimbAnim = 10921343576,
          },
          ["Catwalk Glam"] = {
            WalkAnim = 109168724482748,
            RunAnim = 81024476153754,
            JumpAnim = 116936326516985,
            FallAnim = 92294537340807,
            SwimIdle = 98854111361360,
            Swim = 134591743181628,
            ClimbAnim = 119377220967554,
            Animation1 = 133806214992291,
            Animation2 = 94970088341563,
          },
          Toy = {
            WalkAnim = 10921312010,
            RunAnim = 10921306285,
            JumpAnim = 10921308158,
            FallAnim = 10921307241,
            SwimIdle = 10921310341,
            Swim = 10921309319,
            ClimbAnim = 10921300839,
            Animation1 = 10921301576,
          },
          ["Amazon Unboxed"] = {
            WalkAnim = 90478085024465,
            RunAnim = 134824450619865,
            JumpAnim = 121454505477205,
            FallAnim = 94788218468396,
            SwimIdle = 129126268464847,
            Swim = 105962919001086,
            ClimbAnim = 121145883950231,
            Animation1 = 98281136301627,
          },
          Vampire = {
            WalkAnim = 10921326949,
            RunAnim = 10921320299,
            JumpAnim = 10921322186,
            FallAnim = 10921321317,
            SwimIdle = 10921325443,
            Swim = 10921324408,
            ClimbAnim = 10921314188,
            Animation1 = 10921315373,
          },
          Ninja = {
            RunAnim = 656118852,
            WalkAnim = 656121766,
            JumpAnim = 656117878,
            FallAnim = 656115606,
            Swim = 656119721,
            SwimIdle = 656121397,
            ClimbAnim = 656114359,
            Idle = { 656117400, 656118341, 886742569 },
          },
        }, {
          "Cartoon",
          "Adidas Community",
          "Adidas Aura",
          "Zombie",
          "Catwalk Glam",
          "Toy",
          "Amazon Unboxed",
          "Vampire",
          "Ninja",
        }, 1
      local QN = t[1]
      local function UN(yN)
        if not yN then
          return nil
        end
        if type(yN) == "number" then
          return "rbxassetid://" .. tostring(yN)
        end
        if type(yN) == "string" then
          if string.sub(yN, 1, 11) == "rbxassetid://" then
            return yN
          end
          if string.match(yN, "^%d+$") then
            return "rbxassetid://" .. yN
          end
          return yN
        end
        return nil
      end
      local function yN(HN)
        local hN = HN and HN.Idle
        return {
          idle1 = UN(HN and (HN.Animation1 or hN and hN[1])),
          idle2 = UN(HN and (HN.Animation2 or hN and hN[2])),
          walk = UN(HN and (HN.WalkAnim or HN.Walk)),
          run = UN(HN and (HN.RunAnim or HN.Run)),
          jump = UN(HN and (HN.JumpAnim or HN.Jump)),
          fall = UN(HN and (HN.FallAnim or HN.Fall)),
          climb = UN(HN and (HN.ClimbAnim or HN.Climb)),
          swim = UN(HN and (HN.Swim or HN.SwimAnim)),
          swimidle = UN(HN and (HN.SwimIdle or HN.SwimIdleAnim)),
        }
      end
      local function UN(HN, hN)
        if not HN or not hN then
          return false
        end
        local LN = HN:FindFirstChild("Animate")
        if not LN then
          LN = Instance.new("Animation")
          LN.Name = "Animate"
          LN.Parent = HN
        end
        _G.__ZurichHub_OriginalAnims = _G.__ZurichHub_OriginalAnims or {}
        local ON = tostring(u.UserId or "local")
        if not _G.__ZurichHub_OriginalAnims[ON] then
          local iN, SN = {}, { "idle", "walk", "run", "jump", "fall", "climb", "swim", "swimidle" }
          for ZN, YN in ipairs(SN) do
            ZN = LN:FindFirstChild(YN)
            if ZN then
              for SN, SN in ipairs(ZN:GetChildren()) do
                pcall(function()
                  iN[YN .. "." .. SN.Name] = SN.AnimationId
                end)
              end
            end
          end
          _G.__ZurichHub_OriginalAnims[ON] = iN
        end
        local function ON(iN, SN)
          local ZN = iN:FindFirstChild(SN)
          if not ZN then
            ZN = Instance.new("Animation")
            ZN.Name = SN
            ZN.Parent = iN
          end
          return ZN
        end
        local function iN(SN, ZN, YN)
          if not YN then
            return
          end
          local jN = SN:FindFirstChild(ZN)
          if not jN then
            jN = Instance.new("Animation")
            jN.Name = ZN
            jN.Parent = SN
          end
          jN.AnimationId = YN
        end
        local SN, ZN, YN, jN, eN, qN, KN, GN =
          ON(LN, "idle"),
          ON(LN, "walk"),
          ON(LN, "run"),
          ON(LN, "jump"),
          ON(LN, "fall"),
          ON(LN, "climb"),
          ON(LN, "swim"),
          ON(LN, "swimidle")
        iN(SN, "Animation1", hN.idle1)
        iN(SN, "Animation2", hN.idle2)
        iN(ZN, "WalkAnim", hN.walk)
        iN(YN, "RunAnim", hN.run)
        iN(jN, "JumpAnim", hN.jump)
        iN(eN, "FallAnim", hN.fall)
        iN(qN, "ClimbAnim", hN.climb)
        iN(KN, "Swim", hN.swim)
        iN(GN, "SwimIdle", hN.swimidle)
        _G.__ZurichHub_Anims = _G.__ZurichHub_Anims or {}
        for LN, iN in pairs(hN) do
          if iN then
            _G.__ZurichHub_Anims[LN] = iN
          end
        end
        ON = HN:FindFirstChildOfClass("Humanoid")
        if ON then
          for HN, HN in ipairs(ON:GetPlayingAnimationTracks()) do
            pcall(function()
              HN:Stop(0)
            end)
          end
        end
        return true
      end
      local function HN(hN)
        if not hN then
          return false
        end
        local LN = tostring(u.UserId or "local")
        local ON = _G.__ZurichHub_OriginalAnims and _G.__ZurichHub_OriginalAnims[LN]
        if not ON then
          return false
        end
        LN = hN:FindFirstChild("Animate")
        if not LN then
          return false
        end
        for iN, SN in pairs(ON) do
          hN = string.find(iN, "%.")
          if hN then
            local ON, ZN = string.sub(iN, 1, hN - 1), string.sub(iN, hN + 1)
            local hN = LN:FindFirstChild(ON)
            if not hN then
              hN = Instance.new("Animation")
              hN.Name = ON
              hN.Parent = LN
            end
            local LN = hN:FindFirstChild(ZN)
            if not LN then
              LN = Instance.new("Animation")
              LN.Name = ZN
              LN.Parent = hN
            end
            pcall(function()
              LN.AnimationId = SN
            end)
          end
        end
        return true
      end
      local function hN(LN)
        local ON = c[LN]
        if not ON then
          return false
        end
        local iN, SN = yN(ON), u.Character
        if SN then
          return UN(SN, iN)
        else
          QN = LN
          _G.__pendingAnimationPreset = LN
          return true
        end
      end
      local LN = false
      local function ON()
        local iN = QN or t[nN] or "Cartoon"
        local SN = { presetIndex = nN, presetName = iN, enabled = LN }
        local iN, ZN = pcall(function()
          return Q:JSONEncode(SN)
        end)
        if iN then
          pcall(function()
            writefile("AnimationSelector_Config.txt", ZN)
          end)
        end
      end
      local function iN()
        local SN, ZN = pcall(function()
          return isfile("AnimationSelector_Config.txt")
        end)
        if not SN or not ZN then
          return false
        end
        local YN, jN = pcall(function()
          return readfile("AnimationSelector_Config.txt")
        end)
        if not YN or not jN or jN == "" then
          return false
        end
        ZN, SN = pcall(function()
          return Q:JSONDecode(jN)
        end)
        if not ZN or not SN then
          return false
        end
        if SN.presetName and c[SN.presetName] then
          QN = SN.presetName
          for YN, jN in ipairs(t) do
            if jN == SN.presetName then
              nN = YN
              break
            end
          end
        elseif SN.presetIndex and SN.presetIndex >= 1 and SN.presetIndex <= #t then
          nN = SN.presetIndex
          QN = t[nN]
        end
        ZN = QN
        if ZN == nil then
          QN = t[nN or 1]
        end
        LN = false
        return true
      end
      pcall(iN)
      if LN and QN and c[QN] then
        pcall(function()
          hN(QN)
        end)
      end
      if LN and QN and u.Character then
        pcall(function()
          hN(QN)
        end)
      end
      local SN = aN(k.Visuals, "ANIMATION PACK")
      local ZN = SN and SN.Parent
      if ZN then
        for YN, jN in ipairs(ZN:GetChildren()) do
          if jN:IsA("Frame") then
            YN = jN:FindFirstChildOfClass("TextLabel")
            if YN and YN.Text == "ANIMATION PACK" then
              for YN, YN in ipairs(jN:GetChildren()) do
                if YN:IsA("Frame") and YN.Size and YN.Size.Y and YN.Size.Y.Offset == 1 then
                  YN:Destroy()
                  break
                end
              end
              break
            end
          end
        end
      end
      ZN = Instance.new("Frame", SN)
      ZN.Size = UDim2.new(1, -10, 0, 68)
      ZN.Position = UDim2.new(0, 5, 0, 30)
      ZN.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
      ZN.BackgroundTransparency = 0.12
      ZN.BorderSizePixel = 0
      ZN.Parent = SN
      Instance.new("UICorner", ZN).CornerRadius = UDim.new(0, 8)
      SN = Instance.new("UIStroke", ZN)
      SN.Color = Color3.fromRGB(0, 0, 0)
      SN.Thickness = 1.2
      SN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      SN.Transparency = 0.15
      SN = Instance.new("Frame", ZN)
      SN.Size = UDim2.new(0, 72, 1, -10)
      SN.Position = UDim2.new(0, 6, 0, 5)
      SN.BackgroundColor3 = Color3.fromRGB(32, 35, 42)
      SN.BackgroundTransparency = 0.08
      SN.BorderSizePixel = 0
      Instance.new("UICorner", SN).CornerRadius = UDim.new(0, 7)
      pcall(iN)
      if LN and QN and c[QN] then
        pcall(function()
          hN(QN)
        end)
      end
      local iN = Instance.new("TextButton", SN)
      iN.Size = UDim2.new(1, -8, 1, -8)
      iN.Position = UDim2.new(0, 4, 0, 4)
      iN.BackgroundColor3 = Color3.fromRGB(50, 55, 64)
      iN.BorderSizePixel = 0
      iN.Text = "OFF"
      iN.TextColor3 = Color3.fromRGB(38, 38, 43)
      iN.TextSize = 10
      iN.Font = Enum.Font.GothamBold
      iN.AutoButtonColor = false
      iN.TextWrapped = false
      iN.ZIndex = 6
      Instance.new("UICorner", iN).CornerRadius = UDim.new(0, 5)
      pcall(function(YN)
        local jN = Instance.new("UIStroke", YN)
        jN.Color = Color3.fromRGB(255, 255, 255)
        jN.Thickness = 0.8
        jN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      end, iN)
      local function YN()
        iN.Text = LN and "ON" or "OFF"
        iN.BackgroundColor3 = LN and (Color3.fromRGB(190, 45, 55)) or (Color3.fromRGB(54, 54, 60))
        iN.TextColor3 = Color3.fromRGB(255, 255, 255)
        iN.Font = Enum.Font.GothamBold
      end
      iN.Activated:Connect(function()
        LN = not LN
        YN()
        if LN then
          hN(QN)
        elseif u.Character then
          HN(u.Character)
        end
        ON()
      end)
      local iN = Instance.new("TextButton")
      iN.Size = UDim2.new(0, 32, 0, 32)
      iN.Position = UDim2.new(0, 88, 0.5, -16)
      iN.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
      iN.BackgroundTransparency = 0.15
      iN.BorderSizePixel = 0
      iN.Text = "<"
      iN.TextColor3 = Color3.fromRGB(240, 245, 255)
      iN.TextSize = 20
      iN.Font = Enum.Font.GothamBold
      iN.AutoButtonColor = false
      iN.ZIndex = 5
      iN.Parent = ZN
      pcall(function(jN)
        Instance.new("UICorner", jN).CornerRadius = UDim.new(0, 5)
        local eN = Instance.new("UIStroke", jN)
        eN.Color = Color3.fromRGB(255, 255, 255)
        eN.Thickness = 0.8
        eN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      end, iN)
      SN = Instance.new("Frame")
      SN.Name = "AnimationPackSelector"
      SN.Size = UDim2.new(1, -122, 0, 30)
      SN.Position = UDim2.new(0, 108, 0, 19)
      SN.BackgroundTransparency = 1
      SN.Parent = ZN
      local ZN = Instance.new("TextLabel")
      ZN.Size = UDim2.new(1, -36, 1, 0)
      ZN.BackgroundTransparency = 1
      ZN.Text = tostring(QN or "")
      ZN.TextColor3 = Color3.fromRGB(240, 245, 255)
      ZN.TextSize = 12
      ZN.Font = Enum.Font.GothamBold
      ZN.TextXAlignment = Enum.TextXAlignment.Center
      ZN.TextYAlignment = Enum.TextYAlignment.Center
      ZN.ZIndex = 5
      ZN.Parent = SN
      ZN.AnchorPoint = Vector2.new(0.5, 0.5)
      ZN.Position = UDim2.new(0.5, 0, 0.5, 4)
      pcall(function(jN)
        local eN = Instance.new("UIStroke", jN)
        eN.Color = Color3.fromRGB(255, 255, 255)
        eN.Thickness = 0.8
        eN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        eN.Transparency = 1
      end, ZN)
      local jN = Instance.new("TextButton")
      jN.Size = UDim2.new(0, 32, 0, 32)
      jN.Position = UDim2.new(1, -32, 0.5, -16)
      jN.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
      jN.BackgroundTransparency = 0.15
      jN.BorderSizePixel = 0
      jN.Text = ">"
      jN.TextColor3 = Color3.fromRGB(240, 245, 255)
      jN.TextSize = 20
      jN.Font = Enum.Font.GothamBold
      jN.AutoButtonColor = false
      jN.ZIndex = 5
      jN.Parent = SN
      pcall(function(eN)
        Instance.new("UICorner", eN).CornerRadius = UDim.new(0, 5)
        local qN = Instance.new("UIStroke", eN)
        qN.Color = Color3.fromRGB(255, 255, 255)
        qN.Thickness = 0.8
        qN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      end, jN)
      local function eN(qN, KN)
        KN = KN or "next"
        ZN.Text = tostring(qN or "")
        ZN.TextTransparency = 1
        ZN.Position = UDim2.new(0.5, KN == "next" and -90 or 90, 0.5, 0)
        b:Create(
          ZN,
          TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
          { Position = UDim2.new(0.5, 0, 0.5, 0), TextTransparency = 0 }
        ):Play()
      end
      local function qN(KN)
        local GN = nN + (KN == "next" and 1 or -1)
        nN = if (if GN < 1 then #t else GN) > #t then 1 else if GN < 1 then #t else GN
        QN = t[nN]
        eN(QN, KN)
        if LN then
          hN(QN)
        elseif u.Character then
          HN(u.Character)
        end
        ON()
        local t = KN == "next" and jN or iN
        b:Create(t, TweenInfo.new(0.08), { BackgroundColor3 = Color3.fromRGB(180, 25, 38) }):Play()
        task.delay(0.08, function()
          b:Create(t, TweenInfo.new(0.08), { BackgroundColor3 = Color3.fromRGB(30, 30, 38) }):Play()
        end)
      end
      iN.MouseButton1Click:Connect(function()
        qN("prev")
      end)
      jN.MouseButton1Click:Connect(function()
        qN("next")
      end)
      iN.Parent = SN
      jN.Parent = SN
      ZN.Parent = SN
      YN()
      if LN and QN then
        pcall(function()
          hN(QN)
        end)
      end
      iN.Position = UDim2.new(0, -8, 0.5, -12)
      jN.Position = UDim2.new(1, -24, 0.5, -12)
      iN.MouseEnter:Connect(function()
        b:Create(
          iN,
          TweenInfo.new(0.15),
          { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255) }
        ):Play()
      end)
      iN.MouseLeave:Connect(function()
        b:Create(
          iN,
          TweenInfo.new(0.15),
          { BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(240, 245, 255) }
        ):Play()
      end)
      jN.MouseEnter:Connect(function()
        b:Create(
          jN,
          TweenInfo.new(0.15),
          { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255) }
        ):Play()
      end)
      jN.MouseLeave:Connect(function()
        b:Create(
          jN,
          TweenInfo.new(0.15),
          { BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(240, 245, 255) }
        ):Play()
      end)
      _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function(t)
        task.wait(0.5)
        if LN then
          UN(t, (yN(c[QN])))
        end
      end))
      task.spawn(function()
        task.wait(0.5)
        if u.Character and LN then
          local t = yN(c[QN])
          UN(u.Character, t)
        end
      end)
    end)()
    function _G.__AkatsukiReadSavedPanelVisibility(c)
      if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then
        return false, false
      end
      local t, nN = pcall(function()
        if not isfile(c) then
          return nil
        end
        return Q:JSONDecode(readfile(c))
      end)
      if not t or type(nN) ~= "table" then
        return false, false
      end
      return true, nN.visible == true
    end
    local function c(t)
      if t == nil then
        t = true
      end
      if t and _G.AkatsukiBypass and _G.AkatsukiBypass.SetVisible then
        pcall(_G.AkatsukiBypass.SetVisible, false)
      end
      local nN = game:GetService("Players").LocalPlayer
      local QN = nN and (nN:FindFirstChild("PlayerGui"))
      if QN and (QN:FindFirstChild("AkatsukiLaggerGUI")) then
        nN = QN:FindFirstChild("AkatsukiLaggerGUI")
        if nN and t then
          nN.Visible = true
        end
        if _G.AkatsukiLagger and _G.AkatsukiLagger.SetVisible then
          _G.AkatsukiLagger.SetVisible(t)
        end
        return
      end
      if _G._AkatsukiLaggerGUILoaded then
        _G._AkatsukiLaggerGUILoaded = false
      end
      _G._AkatsukiLaggerGUILoaded = true
      _G.__openLaggerGUI = c
      task.spawn(function()
        pcall(function()
          local nN = z.LocalPlayer:WaitForChild("PlayerGui")
          local QN = nN:FindFirstChild("AkatsukiLaggerGUI")
          if QN then
            QN:Destroy()
          end
          local UN, yN, HN, hN, LN =
            {
              TableIncrease = 270,
              Tries = 1,
              LoopWaitTime = 0.3,
              LowEndTableIncrease = 265,
              LowEndLoopWaitTime = 0.8,
            }, { Main = false, LowEnd = false }, { Main = nil, LowEnd = nil }
          local function ON(iN)
            local SN, ZN = {}, { {} }
            local YN = ZN[1]
            for jN = 1, iN, 1 do
              jN = {}
              table.insert(YN, jN)
              YN = jN
            end
            for YN = 1, math.min(499999 / (iN + 2), 1500), 1 do
              table.insert(SN, ZN)
            end
            return SN
          end
          local function iN(SN)
            if hN ~= SN or not LN then
              hN = SN
              LN = ON(SN)
            end
            pcall(function()
              game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(LN)
            end)
          end
          local function hN()
            if HN.Main then
              return
            end
            HN.Main = task.spawn(function()
              while yN.Main do
                local LN, ON, SN =
                  p and 25000 or math.huge,
                  p and (math.min(UN.TableIncrease, UN.LowEndTableIncrease)) or UN.TableIncrease,
                  p and UN.LowEndLoopWaitTime or UN.LoopWaitTime
                pcall(function()
                  game:GetService("NetworkClient"):SetOutgoingKBPSLimit(LN)
                end)
                iN(ON)
                task.wait(SN)
              end
            end)
          end
          local function LN()
            if HN.LowEnd then
              return
            end
            HN.LowEnd = task.spawn(function()
              while yN.LowEnd do
                pcall(function()
                  game:GetService("NetworkClient"):SetOutgoingKBPSLimit(25000)
                end)
                iN(UN.LowEndTableIncrease)
                task.wait(UN.LowEndLoopWaitTime)
              end
            end)
          end
          local function ON(iN)
            if HN[iN] then
              task.cancel(HN[iN])
              HN[iN] = nil
            end
          end
          local function iN()
            yN.Main = false
            yN.LowEnd = false
            ON("Main")
            ON("LowEnd")
            HN.Payload = nil
            HN.PayloadAmount = nil
            HN.Remote = nil
            pcall(function()
              game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
            end)
          end
          _G.__AkatsukiTrackStopper(iN)
          local function HN()
            yN.Main = not yN.Main
            if yN.Main then
              if yN.LowEnd then
                yN.LowEnd = false
                ON("LowEnd")
                if _G.__updateSmallLaggerVisual then
                  _G.__updateSmallLaggerVisual()
                end
              end
              hN()
            else
              ON("Main")
              if not yN.LowEnd then
                pcall(function()
                  game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
                end)
              end
            end
            return yN.Main
          end
          local function SN()
            yN.LowEnd = not yN.LowEnd
            if yN.LowEnd then
              if yN.Main then
                yN.Main = false
                ON("Main")
              end
              LN()
            else
              ON("LowEnd")
              if not yN.Main then
                pcall(function()
                  game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
                end)
              end
            end
            return yN.LowEnd
          end
          local function ZN(YN)
            if type(YN) ~= "string" or #YN < 16 then
              return false
            end
            local jN, eN, qN =
              YN:sub(1, 8) == "\137PNG\13\10\26\10",
              YN:sub(1, 2) == "\255\216" or YN:find("JFIF", 1, true) ~= nil or YN:find(
                "Exif",
                1,
                true
              ) ~= nil,
              YN:sub(1, 4) == "RIFF" and YN:sub(9, 12) == "WEBP"
            return jN or eN or qN
          end
          local function YN()
            local jN
            pcall(function()
              jN = typeof(getcustomasset) == "function" and getcustomasset
                or typeof(getsynasset) == "function" and getsynasset
            end)
            if typeof(writefile) ~= "function" or typeof(isfile) ~= "function" then
              return "https://files.catbox.moe/8b7zve.png"
            end
            local eN = false
            pcall(function()
              eN = isfile("AkatsukiHub_8b7zve.png")
            end)
            if not eN then
              local eN, qN = pcall(function()
                return game:HttpGet("https://files.catbox.moe/8b7zve.png")
              end)
              if not eN or not ZN(qN) then
                warn("Akatsuki Lagger: no se pudo cargar la imagen compartida 8b7zve")
                return "rbxassetid://114056083769059"
              end
              if not pcall(writefile, "AkatsukiHub_8b7zve.png", qN) then
                return "https://files.catbox.moe/8b7zve.png"
              end
            end
            if jN then
              local ZN, eN = pcall(jN, "AkatsukiHub_8b7zve.png")
              if ZN and type(eN) == "string" and eN ~= "" then
                return eN
              end
            end
            return "https://files.catbox.moe/8b7zve.png"
          end
          local ZN, jN, eN, qN, KN, GN = Color3.fromRGB(245, 245, 248), Enum.KeyCode.V, false
          local IN, FN, kN, EN, lN, NN, mN, sN, MN, dN, cN, TN, WN, wN = false
          local rN = false
          local function xN()
            return typeof(writefile) == "function"
              and typeof(readfile) == "function"
              and typeof(isfile) == "function"
          end
          local function gN()
            if not xN() or not FN then
              return
            end
            local BN = {
              engineVersion = "legacy",
              mainEnabled = yN.Main,
              lowEndEnabled = yN.LowEnd,
              power = UN.TableIncrease,
              keybind = jN and jN.Name or "V",
              visible = FN.Visible,
              minimized = rN,
              position = {
                xScale = FN.Position.X.Scale,
                xOffset = FN.Position.X.Offset,
                yScale = FN.Position.Y.Scale,
                yOffset = FN.Position.Y.Offset,
              },
            }
            pcall(function()
              writefile("AkatsukiLagger_Settings.json", Q:JSONEncode(BN))
            end)
          end
          local function BN()
            if not xN() then
              return nil
            end
            local xN, tN = pcall(function()
              if isfile("AkatsukiLagger_Settings.json") then
                return Q:JSONDecode(readfile("AkatsukiLagger_Settings.json"))
              end
              return nil
            end)
            return xN and tN or nil
          end
          local xN = {
            ButtonA = "PAD A",
            ButtonB = "PAD B",
            ButtonX = "PAD X",
            ButtonY = "PAD Y",
            ButtonL1 = "PAD L1",
            ButtonR1 = "PAD R1",
            ButtonL2 = "PAD L2",
            ButtonR2 = "PAD R2",
            ButtonL3 = "PAD L3",
            ButtonR3 = "PAD R3",
            ButtonStart = "PAD START",
            ButtonSelect = "PAD SELECT",
            DPadUp = "DPAD UP",
            DPadDown = "DPAD DOWN",
            DPadLeft = "DPAD LEFT",
            DPadRight = "DPAD RIGHT",
          }
          local function tN(XN)
            return XN and XN.UserInputType and XN.UserInputType.Name:match("^Gamepad%d+$") ~= nil
          end
          local function XN(AN)
            return xN[AN.Name] or AN.Name
          end
          local function xN()
            if KN then
              KN.Text = XN(jN)
              KN.TextColor3 = ZN
              KN.BackgroundTransparency = 0.2
            end
            if GN then
              GN.Color = Color3.fromRGB(0, 0, 0)
            end
          end
          local function AN()
            eN, IN = false, false
            if qN then
              qN:Disconnect()
              qN = nil
            end
            xN()
          end
          QN = Instance.new("ScreenGui")
          QN.Name = "AkatsukiLaggerGUI"
          QN.ResetOnSpawn = false
          QN.IgnoreGuiInset = true
          QN.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
          QN.Parent = nN
          _G.__AkatsukiTrackConn(QN.DescendantAdded:Connect(function(vN)
            DN(vN)
          end))
          FN = Instance.new("Frame")
          FN.Name = "MainFrame"
          FN.Size = UDim2.fromOffset(320, 328)
          FN.Position = UDim2.new(0.5, -160, 0.5, -164)
          FN.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
          FN.BackgroundTransparency = 0.22
          FN.BorderSizePixel = 0
          FN.ClipsDescendants = true
          FN.Active = true
          FN.Parent = QN
          FN.Visible = false
          Instance.new("UICorner", FN).CornerRadius = UDim.new(0, 18)
          local DN, vN =
            {
              bgDark = Color3.fromRGB(8, 8, 10),
              bgCard = Color3.fromRGB(18, 18, 21),
              stroke = Color3.fromRGB(88, 34, 40),
              accent = Color3.fromRGB(210, 38, 50),
              accentHover = Color3.fromRGB(245, 68, 78),
              accentDim = Color3.fromRGB(92, 28, 35),
              text = Color3.fromRGB(240, 240, 244),
              textMuted = Color3.fromRGB(178, 178, 184),
              white = Color3.fromRGB(248, 248, 250),
              toggleOff = Color3.fromRGB(28, 28, 32),
              toggleOn = Color3.fromRGB(210, 38, 50),
            }, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
          local function VN(PN, zf)
            Instance.new("UICorner", PN).CornerRadius = UDim.new(0, zf or 10)
          end
          local function PN(zf, Cf, bf)
            local Df = Instance.new("UIStroke", zf)
            Df.Color = Cf or DN.stroke
            Df.Thickness = bf or 1
            Df.Transparency = 0.32
            Df.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Df.LineJoinMode = Enum.LineJoinMode.Round
            bf = Instance.new("UIGradient", Df)
            bf.Rotation = 90
            bf.Color = ColorSequence.new({
              ColorSequenceKeypoint.new(0, Color3.fromRGB(242, 242, 245)),
              ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 15)),
            })
            return Df
          end
          local function zf(Cf, bf, Df)
            Cf.MouseEnter:Connect(function()
              b:Create(Cf, vN, { BackgroundColor3 = Df }):Play()
            end)
            Cf.MouseLeave:Connect(function()
              b:Create(Cf, vN, { BackgroundColor3 = bf }):Play()
            end)
          end
          nN = Instance.new("Frame")
          nN.Name = "Header"
          nN.Size = UDim2.new(1, 0, 0, 42)
          nN.BackgroundColor3 = DN.bgDark
          nN.BackgroundTransparency = 0.16
          nN.BorderSizePixel = 0
          nN.ZIndex = 3
          nN.Parent = FN
          VN(nN, 18)
          local Cf = Instance.new("ImageLabel", nN)
          Cf.Name = "Logo"
          Cf.Size = UDim2.fromOffset(24, 24)
          Cf.Position = UDim2.new(0, 12, 0.5, -12)
          Cf.BackgroundTransparency = 1
          Cf.Image = YN()
          Cf.ScaleType = Enum.ScaleType.Fit
          Cf.ZIndex = 4
          VN(Cf, 6)
          kN = Instance.new("TextLabel", nN)
          kN.Name = "Title"
          kN.Size = UDim2.fromOffset(140, 16)
          kN.Position = UDim2.fromOffset(42, 6)
          kN.BackgroundTransparency = 1
          kN.Font = Enum.Font.GothamBold
          kN.TextSize = 13
          kN.TextColor3 = DN.text
          kN.TextXAlignment = Enum.TextXAlignment.Left
          kN.Text = "AKATSUKI"
          kN.ZIndex = 4
          EN = Instance.new("TextLabel", nN)
          EN.Name = "LaggerLabel"
          EN.Size = UDim2.fromOffset(140, 12)
          EN.Position = UDim2.fromOffset(42, 22)
          EN.BackgroundTransparency = 1
          EN.Font = Enum.Font.Gotham
          EN.TextSize = 10
          EN.TextColor3 = DN.textMuted
          EN.TextXAlignment = Enum.TextXAlignment.Left
          EN.Text = "Lagger Panel"
          EN.ZIndex = 4
          lN = Instance.new("TextButton", nN)
          lN.Name = "Minimize"
          lN.Size = UDim2.fromOffset(24, 24)
          lN.Position = UDim2.new(1, -56, 0.5, -12)
          lN.BackgroundColor3 = DN.bgCard
          lN.BorderSizePixel = 0
          lN.Font = Enum.Font.GothamBold
          lN.TextSize = 14
          lN.TextColor3 = DN.text
          lN.Text = "-"
          lN.AutoButtonColor = false
          lN.ZIndex = 4
          VN(lN, 6)
          zf(lN, DN.bgCard, DN.accentDim)
          YN = Instance.new("TextButton", nN)
          YN.Name = "Close"
          YN.Size = UDim2.fromOffset(24, 24)
          YN.Position = UDim2.new(1, -28, 0.5, -12)
          YN.BackgroundColor3 = DN.bgCard
          YN.BorderSizePixel = 0
          YN.Font = Enum.Font.GothamBold
          YN.TextSize = 12
          YN.TextColor3 = DN.text
          YN.Text = "X"
          YN.AutoButtonColor = false
          YN.ZIndex = 4
          VN(YN, 6)
          zf(YN, DN.bgCard, DN.accentHover)
          local bf = Instance.new("Frame", FN)
          bf.Name = "TabBar"
          bf.Size = UDim2.new(1, -24, 0, 32)
          bf.Position = UDim2.fromOffset(12, 50)
          bf.BackgroundColor3 = DN.bgDark
          bf.BackgroundTransparency = 0.14
          bf.BorderSizePixel = 0
          bf.ZIndex = 3
          VN(bf, 10)
          local Df = Instance.new("UIPadding", bf)
          Df.PaddingLeft = UDim.new(0, 4)
          Df.PaddingRight = UDim.new(0, 4)
          Df.PaddingTop = UDim.new(0, 4)
          Df.PaddingBottom = UDim.new(0, 4)
          Df = Instance.new("UIListLayout", bf)
          Df.FillDirection = Enum.FillDirection.Horizontal
          Df.HorizontalAlignment = Enum.HorizontalAlignment.Center
          Df.VerticalAlignment = Enum.VerticalAlignment.Center
          Df.Padding = UDim.new(0, 4)
          local Rf = Instance.new("Frame", FN)
          Rf.Name = "Content"
          Rf.Size = UDim2.new(1, -24, 1, -140)
          Rf.Position = UDim2.fromOffset(12, 90)
          Rf.BackgroundTransparency = 1
          Rf.ZIndex = 3
          local nf, Qf = {}, {}
          local function uf(pf)
            local of = Instance.new("TextButton", bf)
            of.Size = UDim2.new(0.33, -4, 1, 0)
            of.BackgroundColor3 = DN.bgDark
            of.BorderSizePixel = 0
            of.Font = Enum.Font.GothamBold
            of.TextSize = 11
            of.TextColor3 = DN.textMuted
            of.Text = pf
            of.AutoButtonColor = false
            of.ZIndex = 4
            VN(of, 6)
            Qf[pf] = of
            return of
          end
          local pf, of, _f, Uf = uf("Main"), uf("Keybind"), uf("Settings"), "Main"
          local function yf(Hf)
            Uf = Hf
            for af, hf in pairs(Qf) do
              local Qf = af == Hf
              b:Create(hf, vN, {
                BackgroundColor3 = Qf and DN.accent or DN.bgDark,
                TextColor3 = Qf and DN.white or DN.textMuted,
              }):Play()
            end
            for vN, Qf in pairs(nf) do
              Qf.Visible = vN == Hf
            end
          end
          pf.Activated:Connect(function()
            yf("Main")
          end)
          of.Activated:Connect(function()
            yf("Keybind")
          end)
          _f.Activated:Connect(function()
            yf("Settings")
          end)
          local function vN(Qf)
            local Hf = Instance.new("Frame", Rf)
            Hf.Name = Qf .. "Page"
            Hf.Size = UDim2.fromScale(1, 1)
            Hf.BackgroundTransparency = 1
            Hf.ZIndex = 3
            nf[Qf] = Hf
            return Hf
          end
          _f, pf, uf = vN("Main"), vN("Keybind"), vN("Settings")
          vN = Instance.new("UIListLayout", _f)
          vN.Padding = UDim.new(0, 10)
          vN.SortOrder = Enum.SortOrder.LayoutOrder
          local function nf(Qf, Hf, af)
            local hf = Instance.new("Frame", Qf)
            hf.Size = UDim2.new(1, 0, 0, Hf)
            hf.BackgroundColor3 = DN.bgCard
            hf.BackgroundTransparency = 0.2
            hf.BorderSizePixel = 0
            hf.LayoutOrder = af or 1
            hf.ZIndex = 3
            VN(hf, 12)
            PN(hf)
            return hf
          end
          local function Qf(Hf, af)
            local hf = Instance.new("TextLabel", Hf)
            hf.Size = UDim2.new(0.48, 0, 1, 0)
            hf.Position = UDim2.fromOffset(14, 0)
            hf.BackgroundTransparency = 1
            hf.Font = Enum.Font.GothamMedium
            hf.TextSize = 12
            hf.TextColor3 = DN.text
            hf.TextXAlignment = Enum.TextXAlignment.Left
            hf.Text = af
            hf.ZIndex = 4
            return hf
          end
          of = nf(_f, 40, 1)
          Qf(of, "Device")
          vN = Instance.new("TextLabel", of)
          vN.Size = UDim2.fromOffset(90, 26)
          vN.Position = UDim2.new(1, -104, 0.5, -13)
          vN.BackgroundColor3 = DN.bgDark
          vN.Font = Enum.Font.GothamBold
          vN.TextSize = 11
          vN.TextColor3 = DN.text
          vN.Text = p and "Mobile" or "PC"
          vN.ZIndex = 4
          VN(vN, 6)
          of = nf(_f, 40, 2)
          Qf(of, "Intensity")
          local Hf, af = {}, { { "LOW", 120 }, { "MID", 210 }, { "HARD", 270 } }
          for hf, ff in ipairs(af) do
            vN = Instance.new("TextButton", of)
            vN.Size = UDim2.fromOffset(50, 26)
            vN.Position = UDim2.new(1, -170 + (hf - 1) * 56, 0.5, -13)
            vN.BackgroundColor3 = ff[1] == "HARD" and DN.accent or DN.bgDark
            vN.BorderSizePixel = 0
            vN.Font = Enum.Font.GothamBold
            vN.TextSize = 10
            vN.TextColor3 = ff[1] == "HARD" and DN.white or DN.textMuted
            vN.Text = ff[1]
            vN.AutoButtonColor = false
            vN.ZIndex = 4
            VN(vN, 6)
            Hf[ff[1]] = { button = vN, power = ff[2] }
          end
          dN = Instance.new("TextButton", _f)
          dN.Name = "ActivateButton"
          dN.Size = UDim2.new(1, 0, 0, 44)
          dN.BackgroundColor3 = DN.accent
          dN.BorderSizePixel = 0
          dN.Font = Enum.Font.GothamBold
          dN.TextSize = 15
          dN.TextColor3 = DN.white
          dN.Text = "ACTIVATE"
          dN.AutoButtonColor = false
          dN.LayoutOrder = 3
          dN.ZIndex = 4
          VN(dN, 12)
          zf(dN, DN.accent, DN.accentHover)
          af = nf(_f, 34, 4)
          Qf(af, "Status")
          mN = Instance.new("TextLabel", af)
          mN.Size = UDim2.fromOffset(92, 24)
          mN.Position = UDim2.new(1, -106, 0.5, -12)
          mN.BackgroundTransparency = 1
          mN.Font = Enum.Font.GothamBold
          mN.TextSize = 10
          mN.TextColor3 = DN.textMuted
          mN.Text = "LAGGER: OFF"
          mN.ZIndex = 4
          sN = Instance.new("Frame", af)
          sN.Size = UDim2.fromOffset(34, 18)
          sN.Position = UDim2.new(1, -48, 0.5, -9)
          sN.BackgroundColor3 = DN.toggleOff
          sN.BorderSizePixel = 0
          sN.ZIndex = 4
          VN(sN, 9)
          MN = Instance.new("Frame", sN)
          MN.Size = UDim2.fromOffset(12, 12)
          MN.Position = UDim2.new(0, 3, 0.5, -6)
          MN.BackgroundColor3 = DN.white
          MN.BorderSizePixel = 0
          MN.ZIndex = 5
          VN(MN, 6)
          _f = Instance.new("TextLabel", pf)
          _f.Size = UDim2.new(1, 0, 0, 30)
          _f.BackgroundTransparency = 1
          _f.Font = Enum.Font.GothamMedium
          _f.TextSize = 12
          _f.TextColor3 = DN.textMuted
          _f.Text = "Press a key to set activate bind"
          _f.ZIndex = 4
          KN = Instance.new("TextButton", pf)
          KN.Name = "KeybindButton"
          KN.Size = UDim2.new(1, 0, 0, 44)
          KN.Position = UDim2.fromOffset(0, 40)
          KN.BackgroundColor3 = DN.bgCard
          KN.BackgroundTransparency = 0.2
          KN.BorderSizePixel = 0
          KN.Font = Enum.Font.GothamBold
          KN.TextSize = 14
          KN.TextColor3 = DN.text
          KN.Text = XN(jN)
          KN.AutoButtonColor = false
          KN.ZIndex = 4
          VN(KN, 12)
          GN = PN(KN)
          Df = Instance.new("UIListLayout", uf)
          Df.Padding = UDim.new(0, 8)
          Df.SortOrder = Enum.SortOrder.LayoutOrder
          vN = nf(uf, 48, 1)
          vN.Name = "PowerControl"
          Qf(vN, "Power").Size = UDim2.new(1, -28, 0, 20)
          cN = Instance.new("TextLabel", vN)
          cN.Size = UDim2.fromOffset(80, 20)
          cN.Position = UDim2.new(1, -94, 0, 0)
          cN.BackgroundTransparency = 1
          cN.Font = Enum.Font.GothamBold
          cN.TextColor3 = DN.text
          cN.TextSize = 10
          cN.TextXAlignment = Enum.TextXAlignment.Right
          cN.ZIndex = 4
          TN = Instance.new("Frame", vN)
          TN.Name = "Bar"
          TN.Size = UDim2.new(1, -28, 0, 8)
          TN.Position = UDim2.new(0, 14, 1, -16)
          TN.BackgroundColor3 = DN.bgDark
          TN.BorderSizePixel = 0
          TN.ZIndex = 4
          VN(TN, 4)
          WN = Instance.new("Frame", TN)
          WN.Name = "Fill"
          WN.Size = UDim2.fromScale(0, 1)
          WN.BackgroundColor3 = DN.accent
          WN.BorderSizePixel = 0
          WN.ZIndex = 5
          VN(WN, 4)
          wN = Instance.new("Frame", TN)
          wN.Name = "Knob"
          wN.AnchorPoint = Vector2.new(0.5, 0.5)
          wN.Size = UDim2.fromOffset(14, 14)
          wN.BackgroundColor3 = DN.white
          wN.BorderSizePixel = 0
          wN.ZIndex = 6
          VN(wN, 7)
          of = Instance.new("TextButton", TN)
          of.Name = "PowerSlider"
          of.Size = UDim2.new(1, 12, 0, 24)
          of.Position = UDim2.new(0, -6, 0.5, -12)
          of.BackgroundTransparency = 1
          of.Text = ""
          of.ZIndex = 7
          local XN, _f, af = Instance.new("UIScale", FN), 100, nf(uf, 36, 2)
          Qf(af, "GUI Size")
          local hf = Instance.new("TextLabel", af)
          hf.Size = UDim2.fromOffset(50, 26)
          hf.Position = UDim2.new(1, -86, 0.5, -13)
          hf.BackgroundTransparency = 1
          hf.Font = Enum.Font.GothamBold
          hf.TextSize = 12
          hf.TextColor3 = DN.text
          hf.Text = "100%"
          hf.ZIndex = 4
          vN = Instance.new("TextButton", af)
          vN.Size = UDim2.fromOffset(28, 26)
          vN.Position = UDim2.new(1, -118, 0.5, -13)
          vN.BackgroundColor3 = DN.bgDark
          vN.TextColor3 = DN.text
          vN.Text = "-"
          vN.ZIndex = 4
          VN(vN, 6)
          Df = Instance.new("TextButton", af)
          Df.Size = UDim2.fromOffset(28, 26)
          Df.Position = UDim2.new(1, -34, 0.5, -13)
          Df.BackgroundColor3 = DN.bgDark
          Df.TextColor3 = DN.text
          Df.Text = "+"
          Df.ZIndex = 4
          VN(Df, 6)
          local function ff(Jf)
            _f = math.clamp(_f + Jf, 60, 140)
            hf.Text = tostring(_f) .. "%"
            XN.Scale = _f / 100
          end
          vN.Activated:Connect(function()
            ff(-10)
          end)
          Df.Activated:Connect(function()
            ff(10)
          end)
          af = nf(uf, 36, 3)
          Qf(af, "Reset Position")
          Qf = Instance.new("TextButton", af)
          Qf.Size = UDim2.fromOffset(70, 26)
          Qf.Position = UDim2.new(1, -84, 0.5, -13)
          Qf.BackgroundColor3 = DN.accent
          Qf.BorderSizePixel = 0
          Qf.Font = Enum.Font.GothamBold
          Qf.TextSize = 11
          Qf.TextColor3 = DN.white
          Qf.Text = "RESET"
          Qf.AutoButtonColor = false
          Qf.ZIndex = 4
          VN(Qf, 6)
          zf(Qf, DN.accent, DN.accentHover)
          Qf.Activated:Connect(function()
            FN.Position = UDim2.new(0.5, -160, 0.5, -164)
            gN()
          end)
          local XN = Instance.new("Frame", FN)
          XN.Name = "Footer"
          XN.Size = UDim2.new(1, 0, 0, 36)
          XN.Position = UDim2.new(0, 0, 1, -36)
          XN.BackgroundColor3 = DN.bgDark
          XN.BackgroundTransparency = 0.16
          XN.BorderSizePixel = 0
          XN.ZIndex = 3
          pf = Instance.new("TextLabel", XN)
          pf.Size = UDim2.new(1, -28, 1, 0)
          pf.Position = UDim2.fromOffset(14, 0)
          pf.BackgroundTransparency = 1
          pf.Font = Enum.Font.GothamBold
          pf.TextSize = 11
          pf.TextColor3 = Color3.fromRGB(78, 78, 84)
          pf.TextXAlignment = Enum.TextXAlignment.Left
          pf.Text = "discord.gg/akatsukihub"
          pf.ZIndex = 4
          NN = Instance.new("TextButton", nN)
          NN.Name = "MinimizedToggle"
          NN.Size = UDim2.fromOffset(72, 24)
          NN.Position = UDim2.new(1, -136, 0.5, -12)
          NN.BackgroundColor3 = DN.bgCard
          NN.BorderSizePixel = 0
          NN.Font = Enum.Font.GothamBold
          NN.TextSize = 11
          NN.TextColor3 = DN.text
          NN.Text = "LAG: OFF"
          NN.Visible = false
          NN.ZIndex = 4
          VN(NN, 6)
          PN(NN)
          for vN, vN in ipairs(FN:GetDescendants()) do
            if vN:IsA("GuiObject") then
              vN.BorderSizePixel = 0
              if
                (
                  vN:IsA("Frame")
                  or (vN:IsA("TextLabel"))
                  or (vN:IsA("TextButton"))
                  or (vN:IsA("TextBox"))
                  or (vN:IsA("ImageLabel"))
                )
                and vN.BackgroundTransparency < 1
                and not vN:FindFirstChildOfClass("UICorner")
              then
                VN(vN, 10)
              end
            end
          end
          yf("Main")
          local vN = false
          local function VN(PN, zf)
            PN = math.clamp(math.floor((tonumber(PN) or 0) + 0.5), 0, 290)
            UN.TableIncrease = PN
            local Df = PN / 290
            WN.Size = UDim2.fromScale(Df, 1)
            wN.Position = UDim2.new(Df, 0, 0.5, 0)
            cN.Text = "POWER: " .. tostring(PN)
            Df = PN <= 165 and "LOW" or (PN <= 240 and "MID" or "HARD")
            for cN, WN in pairs(Hf) do
              PN = cN == Df
              WN.button.BackgroundColor3 = PN and DN.accent or DN.bgDark
              WN.button.TextColor3 = PN and DN.white or DN.textMuted
            end
            if zf then
              gN()
            end
          end
          local function cN(WN)
            local wN = TN.AbsoluteSize.X
            if wN <= 0 then
              return
            end
            VN(math.clamp((WN.Position.X - TN.AbsolutePosition.X) / wN, 0, 1) * 290, false)
          end
          VN(UN.TableIncrease, false)
          for TN, TN in pairs(Hf) do
            TN.button.Activated:Connect(function()
              VN(TN.power, true)
            end)
          end
          of.InputBegan:Connect(function(TN)
            if
              TN.UserInputType == Enum.UserInputType.MouseButton1
              or TN.UserInputType == Enum.UserInputType.Touch
            then
              vN = true
              cN(TN)
            end
          end)
          _G.__AkatsukiTrackConn(C.InputChanged:Connect(function(TN)
            if
              vN
              and (
                TN.UserInputType == Enum.UserInputType.MouseMovement
                or TN.UserInputType == Enum.UserInputType.Touch
              )
            then
              cN(TN)
            end
          end))
          _G.__AkatsukiTrackConn(C.InputEnded:Connect(function(cN)
            if
              vN
              and (
                cN.UserInputType == Enum.UserInputType.MouseButton1
                or cN.UserInputType == Enum.UserInputType.Touch
              )
            then
              vN = false
              VN(UN.TableIncrease, true)
            end
          end))
          KN.Activated:Connect(function()
            if eN then
              return
            end
            eN = true
            KN.Text = "..."
            KN.TextColor3 = ZN
            KN.BackgroundTransparency = 0.6
            if GN then
              GN.Color = Color3.fromRGB(0, 0, 0)
            end
            qN = C.InputBegan:Connect(function(ZN)
              if not eN then
                return
              end
              local KN = ZN.UserInputType == Enum.UserInputType.Keyboard
              if KN or tN(ZN) then
                if ZN.KeyCode == Enum.KeyCode.Unknown then
                  return
                end
                if KN and ZN.KeyCode == Enum.KeyCode.Escape then
                  AN()
                  return
                end
                jN, eN, IN = ZN.KeyCode, false, true
                if qN then
                  qN:Disconnect()
                  qN = nil
                end
                xN()
                gN()
                task.delay(0.3, function()
                  IN = false
                end)
              end
            end)
            task.delay(5, function()
              if eN then
                AN()
              end
            end)
          end)
          local function ZN(qN, KN)
            local GN = qN and (UDim2.new(1, -17, 0.5, -6)) or (UDim2.new(0, 3, 0.5, -6))
            if KN then
              b:Create(MN, TweenInfo.new(0.15), { Position = GN }):Play()
            else
              MN.Position = GN
            end
            mN.Text = qN and "LAGGER: ON" or "LAGGER: OFF"
            mN.TextColor3 = qN and DN.white or DN.textMuted
            sN.BackgroundColor3 = qN and DN.toggleOn or DN.toggleOff
            dN.Text = qN and "DEACTIVATE" or "ACTIVATE"
            NN.Text = qN and "LAG: ON" or "LAG: OFF"
            NN.BackgroundColor3 = qN and DN.accent or DN.bgCard
            NN.TextColor3 = DN.white
          end
          dN.MouseButton1Click:Connect(function()
            ZN(HN(), true)
            gN()
          end)
          NN.Activated:Connect(function()
            ZN(HN(), true)
            gN()
          end)
          YN.MouseButton1Click:Connect(function()
            FN.Visible = false
            x = false
            B()
            gN()
          end)
          local DN, YN = UDim2.fromOffset(320, 328), UDim2.fromOffset(320, 42)
          local function qN(KN, GN)
            rN = KN == true
            lN.Text = rN and "+" or "-"
            NN.Visible = rN
            Cf.Visible = not rN
            kN.Visible = not rN
            EN.Visible = not rN
            bf.Visible = not rN
            Rf.Visible = not rN
            XN.Visible = not rN
            KN = rN and YN or DN
            if GN then
              b:Create(
                FN,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Size = KN }
              ):Play()
            else
              FN.Size = KN
            end
            if not rN then
              yf(Uf)
            end
          end
          lN.Activated:Connect(function()
            qN(not rN, true)
            gN()
          end)
          _G.__AkatsukiTrackConn(C.InputBegan:Connect(function(DN, YN)
            if eN then
              return
            end
            if IN then
              return
            end
            local eN = tN(DN)
            if YN and not eN then
              return
            end
            if DN.UserInputType ~= Enum.UserInputType.Keyboard and not eN then
              return
            end
            if DN.KeyCode ~= jN then
              return
            end
            ZN(HN(), true)
            gN()
          end))
          local DN = 0
          FN:GetPropertyChangedSignal("Position"):Connect(function()
            DN += 1
            local YN = DN
            task.delay(0.3, function()
              if YN == DN then
                gN()
              end
            end)
          end)
          local DN, YN, eN = false
          nN.InputBegan:Connect(function(nN)
            if
              nN.UserInputType == Enum.UserInputType.MouseButton1
              or nN.UserInputType == Enum.UserInputType.Touch
            then
              DN = true
              YN = nN.Position
              eN = FN.Position
            end
          end)
          _G.__AkatsukiTrackConn(C.InputChanged:Connect(function(nN)
            if not DN then
              return
            end
            if
              nN.UserInputType ~= Enum.UserInputType.MouseMovement
              and nN.UserInputType ~= Enum.UserInputType.Touch
            then
              return
            end
            local KN = nN.Position - YN
            FN.Position = UDim2.new(eN.X.Scale, eN.X.Offset + KN.X, eN.Y.Scale, eN.Y.Offset + KN.Y)
          end))
          _G.__AkatsukiTrackConn(C.InputEnded:Connect(function(nN)
            local YN = nN.UserInputType == Enum.UserInputType.MouseButton1
              or nN.UserInputType == Enum.UserInputType.Touch
            if YN then
              DN = false
            end
          end))
          local function nN()
            local YN = BN()
            if not YN then
              ZN(false, false)
              xN()
              FN.Visible = t == true
              x = FN.Visible
              B()
              gN()
              return
            end
            if YN.keybind then
              local eN = Enum.KeyCode[YN.keybind]
              if eN then
                jN = eN
              end
            end
            if YN.power ~= nil then
              local eN = tonumber(YN.power)
              VN(
                (if YN.engineVersion ~= "legacy" and eN == 90 then 270 else eN) or UN.TableIncrease,
                false
              )
            end
            xN()
            if YN.mainEnabled ~= nil then
              yN.Main = YN.mainEnabled == true and not p
              if yN.Main then
                hN()
              end
              ZN(yN.Main, false)
            end
            if YN.lowEndEnabled ~= nil then
              yN.LowEnd = YN.lowEndEnabled == true and not p
              if yN.LowEnd then
                LN()
              end
            end
            if YN.position and not _G.__AkatsukiGuiPositionsReset then
              pcall(function()
                FN.Position = UDim2.new(
                  YN.position.xScale,
                  YN.position.xOffset,
                  YN.position.yScale,
                  YN.position.yOffset
                )
              end)
            end
            qN(YN.minimized == true, false)
            if YN.visible ~= nil then
              FN.Visible = t == true and true or YN.visible and true or false
            else
              FN.Visible = t == true
            end
            x = FN.Visible
            B()
            gN()
          end
          for t, t in ipairs(QN:GetDescendants()) do
            if t:IsA("TextLabel") or (t:IsA("TextButton")) or (t:IsA("TextBox")) then
              t:SetAttribute("AkatsukiKeepBlackText", true)
              t.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
              t.TextStrokeTransparency = 0.2
            end
          end
          nN()
          gN()
          _G.AkatsukiLagger = {
            Stop = function()
              iN()
            end,
            ResetPosition = function()
              DN = false
              FN.Position = UDim2.new(0.5, -160, 0.5, -164)
              gN()
            end,
            IsEnabled = function()
              return yN.Main
            end,
            IsLowEndEnabled = function()
              return yN.LowEnd
            end,
            Toggle = function()
              local t = HN()
              ZN(t, true)
              gN()
              return t
            end,
            ToggleLowEnd = function()
              local t = SN()
              gN()
              return t
            end,
            SetEnabled = function(t)
              if yN.Main ~= t then
                yN.Main = t
                if t then
                  if yN.LowEnd then
                    yN.LowEnd = false
                    ON("LowEnd")
                  end
                  hN()
                else
                  ON("Main")
                end
                ZN(yN.Main, true)
                gN()
              end
            end,
            SetLowEndEnabled = function(t)
              if yN.LowEnd ~= t then
                yN.LowEnd = t
                if t then
                  if yN.Main then
                    yN.Main = false
                    ON("Main")
                    ZN(false, true)
                  end
                  LN()
                else
                  ON("LowEnd")
                end
                gN()
              end
            end,
            GetPower = function()
              return UN.TableIncrease
            end,
            SetPower = function(t)
              VN(t, true)
            end,
            GetKeybind = function()
              return jN
            end,
            SetKeybind = function(t)
              local DN = if typeof(t) == "string"
                then Enum.KeyCode[t]
                else if typeof(t) == "EnumItem" and t.EnumType == Enum.KeyCode then t else nil
              if DN then
                jN = DN
                xN()
                gN()
              end
            end,
            SetBackground = function() end,
            GetBackground = function()
              return 1
            end,
            SetVisible = function(t)
              if FN then
                local DN = t and true or false
                FN.Visible = DN
                x = DN
                B()
                gN()
              end
            end,
            SaveSettings = function()
              gN()
            end,
          }
        end)
      end)
    end
    _G.__openLaggerGUI = c
    local function t()
      x = false
      B()
      if _G.AkatsukiLagger and _G.AkatsukiLagger.SetVisible then
        _G.AkatsukiLagger.SetVisible(false)
      end
      if _G.AkatsukiLagger and _G.AkatsukiLagger.SaveSettings then
        _G.AkatsukiLagger.SaveSettings()
      end
    end
    v(d, function()
      x = not x
      B()
      if x then
        if _G._AkatsukiLaggerGUILoaded then
          if _G.AkatsukiLagger and _G.AkatsukiLagger.SetVisible then
            _G.AkatsukiLagger.SetVisible(true)
          end
          if _G.AkatsukiLagger and _G.AkatsukiLagger.SaveSettings then
            _G.AkatsukiLagger.SaveSettings()
          end
        else
          c(true)
        end
      else
        t()
      end
    end)
    local d, t = _G.__AkatsukiReadSavedPanelVisibility("AkatsukiLagger_Settings.json")
    x = d and t or false
    B()
    if d then
      c(false)
    end
    local c = false
    local function x()
      n.BackgroundColor3 = c and (Color3.fromRGB(210, 38, 50)) or (Color3.fromRGB(28, 28, 32))
      n.TextColor3 = c and (Color3.fromRGB(248, 248, 250)) or (Color3.fromRGB(205, 205, 212))
      F.Color = c and (Color3.fromRGB(255, 165, 172)) or (Color3.fromRGB(88, 34, 40))
      F.Thickness = c and 1.5 or 1
    end
    function _G.__syncBypassVisual()
      x()
    end
    local function F(B)
      if B == nil then
        B = true
      end
      if B and _G.AkatsukiLagger and _G.AkatsukiLagger.SetVisible then
        pcall(_G.AkatsukiLagger.SetVisible, false)
      end
      local DN = game:GetService("Players").LocalPlayer
      local nN = DN and (DN:FindFirstChild("PlayerGui"))
      if nN and (nN:FindFirstChild("AkatsukiBypassGUI")) then
        if B then
          pcall(function()
            if _G.AkatsukiBypass and _G.AkatsukiBypass.SetVisible then
              _G.AkatsukiBypass.SetVisible(true)
            end
          end)
        end
        return
      end
      if _G._AkatsukiBypassGUILoaded then
        _G._AkatsukiBypassGUILoaded = false
      end
      _G._AkatsukiBypassGUILoaded = true
      task.spawn(function()
        pcall(function()
          if not o.alive then
            return
          end
          local DN, nN = game:GetService("NetworkClient"), z.LocalPlayer
          local z = nN:WaitForChild("PlayerGui")
          local QN = z:FindFirstChild("AkatsukiBypassGUI")
          if QN then
            QN:Destroy()
          end
          local UN, yN, HN, hN =
            {
              Power = 97000,
              PCPower = 97000,
              MobilePower = 72000,
              Mode = "PC",
              SpamDelay = 0.12,
              Version = "V1",
              DropPaused = false,
            }, false
          local function LN(ON)
            local iN, SN = {}, { {} }
            local ZN = SN[1]
            for YN = 1, 186, 1 do
              YN = {}
              table.insert(ZN, YN)
              ZN = YN
            end
            for ZN = 1, math.floor(ON / 188), 1 do
              table.insert(iN, SN)
            end
            return iN
          end
          local function ON(iN)
            local SN, ZN = {}, { {} }
            local YN = ZN[1]
            for jN = 1, 296, 1 do
              jN = {}
              table.insert(YN, jN)
              YN = jN
            end
            for YN = 1, math.floor(iN / 298), 1 do
              table.insert(SN, ZN)
            end
            return SN
          end
          local function iN(SN)
            return UN.Version == "V1" and (LN(SN)) or (ON(SN))
          end
          local function LN()
            if yN then
              return true
            end
            yN = true
            pcall(function()
              DN:SetOutgoingKBPSLimit(math.huge)
            end)
            HN = iN(UN.Power)
            local ON = game:FindFirstChild("RobloxReplicatedStorage")
            local iN = ON and (ON:FindFirstChild("SetPlayerBlockList"))
            if not iN then
              yN = false
              return
            end
            hN = task.spawn(function()
              while yN do
                if HN then
                  pcall(function()
                    iN:FireServer(HN)
                  end)
                end
                task.wait(UN.SpamDelay)
              end
            end)
            return true
          end
          local function ON(iN)
            yN = false
            if hN then
              pcall(function()
                task.cancel(hN)
                hN = nil
              end)
            end
            HN = nil
            if not iN then
              pcall(function()
                DN:SetOutgoingKBPSLimit(math.huge)
              end)
            end
          end
          local function DN(HN)
            local hN = UN.Mode == "PC" and 150000 or 100000
            UN.Power = math.clamp(HN, 10000, hN)
            if UN.Mode == "PC" then
              UN.PCPower = UN.Power
            else
              UN.MobilePower = UN.Power
            end
            if yN then
              ON()
              task.wait(0.05)
              LN()
            end
          end
          local function HN(hN)
            if hN ~= "V1" and hN ~= "V2" then
              return
            end
            UN.Version = hN
            UN.Power = hN == "V1" and 97000 or 100000
            if UN.Mode == "PC" then
              UN.PCPower = UN.Power
            else
              UN.MobilePower = UN.Power
            end
            if powerBox then
              powerBox.Text = tostring(UN.Power)
            end
            if yN then
              ON()
              task.wait(0.05)
              LN()
            end
          end
          local function hN(iN)
            if type(iN) ~= "string" or #iN < 16 then
              return false
            end
            local SN, ZN, YN =
              iN:sub(1, 8) == "\137PNG\13\10\26\10",
              iN:sub(1, 2) == "\255\216" or iN:find("JFIF", 1, true) ~= nil or iN:find(
                "Exif",
                1,
                true
              ) ~= nil,
              iN:sub(1, 4) == "RIFF" and iN:sub(9, 12) == "WEBP"
            return SN or ZN or YN
          end
          local iN, SN, ZN =
            { ((function()
              local YN
              pcall(function()
                YN = typeof(getcustomasset) == "function" and getcustomasset or typeof(getsynasset) == "function" and getsynasset
              end)
              if typeof(writefile) ~= "function" or typeof(isfile) ~= "function" then
                return "https://files.catbox.moe/qkghc6.png"
              end
              local jN = false
              pcall(function()
                jN = isfile("AkatsukiBypass_qkghc6.png")
              end)
              if not jN then
                local jN, eN = pcall(function()
                  return game:HttpGet("https://files.catbox.moe/qkghc6.png")
                end)
                if not jN or not hN(eN) then
                  warn("Akatsuki Bypass: no se pudo descargar el fondo qkghc6")
                  return "rbxassetid://94763047376005"
                end
                if not pcall(writefile, "AkatsukiBypass_qkghc6.png", eN) then
                  return "https://files.catbox.moe/qkghc6.png"
                end
              end
              if YN then
                local hN, jN = pcall(YN, "AkatsukiBypass_qkghc6.png")
                if hN and type(jN) == "string" and jN ~= "" then
                  return jN
                end
              end
              return "https://files.catbox.moe/qkghc6.png"
            end)()) }, Color3.fromRGB(255, 165, 172), Color3.fromRGB(72, 20, 28)
          local hN, YN, jN, eN, qN, KN, GN, IN, FN, kN, EN, lN, NN
          local mN, sN, MN, dN, cN = false, 1, false, {}, Enum.UserInputType.Keyboard
          dN.inputType = cN
          QN = Enum.KeyCode.Five
          dN.keyCode = QN
          local TN = false
          local function WN()
            return typeof(writefile) == "function"
              and typeof(readfile) == "function"
              and typeof(isfile) == "function"
          end
          local function wN()
            if not WN() or not GN then
              return
            end
            local rN = dN and { inputType = dN.inputType.Name, keyCode = dN.keyCode.Name } or nil
            local xN = {
              power = hN and hN.Text or "97000",
              pcPower = UN.PCPower,
              mobilePower = UN.MobilePower,
              mode = UN.Mode,
              autoOnSteal = MN or false,
              keybind = rN,
              background = sN or 1,
              visible = GN.Visible,
              minimized = mN,
              position = {
                xScale = GN.Position.X.Scale,
                xOffset = GN.Position.X.Offset,
                yScale = GN.Position.Y.Scale,
                yOffset = GN.Position.Y.Offset,
              },
              bypassEnabled = yN or false,
              manualOverride = TN or false,
              bypassVersion = UN.Version or "V1",
            }
            pcall(function()
              writefile("AkatsukiBypass_Settings.json", Q:JSONEncode(xN))
            end)
          end
          local function rN()
            if not WN() then
              return nil
            end
            local WN, xN = pcall(function()
              if isfile("AkatsukiBypass_Settings.json") then
                return Q:JSONDecode(readfile("AkatsukiBypass_Settings.json"))
              end
              return nil
            end)
            return WN and xN or nil
          end
          local Q = Instance.new("ScreenGui")
          Q.Name = "AkatsukiBypassGUI"
          Q.ResetOnSpawn = false
          Q.IgnoreGuiInset = true
          Q.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
          if not o.alive then
            Q:Destroy()
            return
          end
          Q.Parent = z
          _G.__AkatsukiRegisterThemeRoot(Q)
          GN = Instance.new("Frame")
          GN.Name = "MainFrame"
          GN.Size = UDim2.new(0, 320, 0, 216)
          GN.Position = UDim2.new(0.5, -160, 0.5, -108)
          GN.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
          GN.BackgroundTransparency = 0
          GN.BorderSizePixel = 0
          GN.ClipsDescendants = true
          GN.Active = true
          GN.Draggable = false
          GN.Parent = Q
          GN.Visible = false
          local WN = Instance.new("UIAspectRatioConstraint")
          WN.AspectRatio = 1.4814814814814814
          WN.Parent = GN
          if p then
            QN = Instance.new("UIScale")
            QN.Name = "MobilePanelScale"
            QN.Scale = 0.82
            QN.Parent = GN
          end
          Instance.new("UICorner", GN).CornerRadius = UDim.new(0, 16)
          local xN = Instance.new("UIStroke", GN)
          xN.Color = Color3.fromRGB(181, 181, 181)
          xN.Thickness = 1.5
          xN.Transparency = 1
          xN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          IN = Instance.new("ImageLabel")
          IN.Name = "BgImageLabel"
          IN.Size = UDim2.new(1, 0, 1, 0)
          IN.BackgroundTransparency = 1
          IN.Image = iN[1]
          IN.ImageTransparency = 0
          IN.ScaleType = Enum.ScaleType.Crop
          IN.ZIndex = 0
          IN.Parent = GN
          IN.Visible = true
          Instance.new("UICorner", IN).CornerRadius = UDim.new(0, 16)
          _G.__AkatsukiRoundPanelBackground(IN, GN)
          _G.__AkatsukiFramePanelBackground(IN, 1, "Bypass")
          _G.__AkatsukiAddUnifiedPanelShade(GN, 16, 1)
          local gN = Instance.new("UIStroke", GN)
          gN.Name = "Glow"
          gN.Color = Color3.fromRGB(191, 191, 191)
          gN.Thickness = 4
          gN.Transparency = 1
          gN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          local BN = Instance.new("UIStroke", GN)
          BN.Name = "Glow2"
          BN.Color = Color3.fromRGB(255, 255, 255)
          BN.Thickness = 6
          BN.Transparency = 1
          BN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          local tN = Instance.new("Frame")
          tN.Size = UDim2.new(1, 0, 1, 0)
          tN.BackgroundTransparency = 1
          tN.ZIndex = 3
          tN.Parent = GN
          local XN = Instance.new("TextButton")
          XN.Name = "Minimize"
          XN.Size = UDim2.fromOffset(28, 28)
          XN.Position = UDim2.new(1, -36, 0, 8)
          XN.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
          XN.BackgroundTransparency = 0.08
          XN.BorderSizePixel = 0
          XN.AutoButtonColor = false
          XN.Text = "-"
          XN.TextColor3 = SN
          XN.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
          XN.TextStrokeTransparency = 0.15
          XN.TextSize = 18
          XN.Font = Enum.Font.GothamBlack
          XN.ZIndex = 12
          XN.Parent = GN
          Instance.new("UICorner", XN).CornerRadius = UDim.new(0, 7)
          cN = Instance.new("UIStroke", XN)
          cN.Color = Color3.fromRGB(0, 0, 0)
          cN.Thickness = 1
          local AN = Instance.new("TextButton")
          AN.Name = "MinimizedToggle"
          AN.Size = UDim2.new(1, -54, 0, 30)
          AN.Position = UDim2.fromOffset(8, 7)
          AN.BackgroundColor3 = Color3.fromRGB(92, 28, 35)
          AN.BackgroundTransparency = 0.08
          AN.BorderSizePixel = 0
          AN.AutoButtonColor = false
          AN.Text = "ACTIVATE BYPASS"
          AN.TextColor3 = SN
          AN.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
          AN.TextStrokeTransparency = 0.15
          AN.TextSize = 11
          AN.Font = Enum.Font.GothamBold
          AN.Visible = false
          AN.ZIndex = 12
          AN.Parent = GN
          Instance.new("UICorner", AN).CornerRadius = UDim.new(0, 7)
          QN = Instance.new("UIStroke", AN)
          QN.Color = Color3.fromRGB(0, 0, 0)
          QN.Thickness = 1
          local vN, VN = UDim2.fromOffset(320, 216), UDim2.fromOffset(310, 44)
          local function PN()
            AN.Text = yN and "DEACTIVATE BYPASS" or "ACTIVATE BYPASS"
            AN.BackgroundColor3 = yN and (Color3.fromRGB(210, 38, 50))
              or (Color3.fromRGB(92, 28, 35))
            AN.TextColor3 = SN
          end
          local function zf(Cf, bf)
            mN = Cf == true
            XN.Text = mN and "+" or "-"
            tN.Visible = not mN
            AN.Visible = mN
            if mN and FN then
              FN.Visible = false
            end
            WN.Parent = mN and nil or GN
            Cf = mN and VN or vN
            if bf then
              b:Create(
                GN,
                TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Size = Cf }
              ):Play()
            else
              GN.Size = Cf
            end
          end
          XN.Activated:Connect(function()
            zf(not mN, true)
            wN()
          end)
          local mN = Instance.new("TextLabel")
          mN.Size = UDim2.new(0, 110, 0, 20)
          mN.Position = UDim2.new(0, 16, 0, 7)
          mN.BackgroundTransparency = 1
          mN.Font = Enum.Font.GothamBlack
          mN.Text = ""
          mN.TextColor3 = SN
          mN.TextSize = 16
          mN.TextXAlignment = Enum.TextXAlignment.Left
          mN.ZIndex = 3
          mN.Parent = tN
          z = Instance.new("UIStroke", mN)
          z.Color = Color3.fromRGB(0, 0, 0)
          z.Thickness = 1.5
          z.Transparency = 0.2
          cN = Instance.new("UIGradient")
          cN.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(245, 155, 164)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(245, 155, 164)),
          })
          cN.Parent = mN
          cN.Enabled = false
          z = Instance.new("TextLabel")
          z.Name = "BypassLabel"
          z.Position = UDim2.new(0, 16, 0, 27)
          z.Size = UDim2.new(0, 110, 0, 18)
          z.BackgroundTransparency = 1
          z.Text = ""
          z.TextColor3 = SN
          z.TextSize = 13
          z.Font = Enum.Font.GothamBold
          z.TextXAlignment = Enum.TextXAlignment.Left
          z.ZIndex = 3
          z.Parent = tN
          mN.AnchorPoint = Vector2.new(0.5, 0)
          mN.Position = UDim2.new(0.5, 0, 0, 44)
          mN.Size = UDim2.fromOffset(224, 26)
          _G.__AkatsukiAddOriginalGui3Title(mN, "Bypass")
          mN.Visible = false
          local WN = Instance.new("TextLabel")
          WN.Name = "TitleShadow"
          WN.Size = UDim2.new(1, 0, 0, 50)
          WN.Position = UDim2.new(0, -7, 0, 1)
          WN.BackgroundTransparency = 1
          WN.Font = Enum.Font.GothamBlack
          WN.Text = ""
          WN.TextColor3 = Color3.fromRGB(68, 22, 28)
          WN.TextSize = 18
          WN.TextXAlignment = Enum.TextXAlignment.Center
          WN.ZIndex = 2
          WN.Parent = tN
          WN.Visible = false
          KN = Instance.new("TextButton")
          KN.AnchorPoint = Vector2.new(0.5, 0)
          KN.Size = UDim2.new(0, 90, 0, 20)
          KN.Position = UDim2.new(0.5, 0, 0, 38)
          KN.BackgroundColor3 = SN
          KN.BackgroundTransparency = 0.55
          KN.AutoButtonColor = false
          KN.Font = Enum.Font.GothamBold
          KN.Text = "Themes"
          KN.Visible = true
          KN.TextWrapped = false
          KN.TextXAlignment = Enum.TextXAlignment.Center
          KN.TextColor3 = ZN
          KN.TextSize = 10
          KN.Parent = tN
          KN.Visible = false
          Instance.new("UICorner", KN).CornerRadius = UDim.new(0, 6)
          QN = Instance.new("UIStroke", KN)
          QN.Color = Color3.fromRGB(0, 0, 0)
          QN.Thickness = 1
          QN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          FN = Instance.new("Frame")
          FN.Name = "ThemesPanel"
          FN.Size = UDim2.fromOffset(220, 180)
          FN.BackgroundColor3 = Color3.fromRGB(210, 38, 50)
          FN.BorderSizePixel = 0
          FN.Visible = false
          FN.ZIndex = 20
          FN.Parent = Q
          z = Instance.new("UIGradient", FN)
          z.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 58, 58)),
            ColorSequenceKeypoint.new(0.48, Color3.fromRGB(92, 92, 92)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 52, 52)),
          })
          z.Rotation = 35
          local function XN()
            FN.Position = UDim2.new(
              GN.Position.X.Scale,
              GN.Position.X.Offset + GN.Size.X.Offset + 12,
              GN.Position.Y.Scale,
              GN.Position.Y.Offset
            )
          end
          Instance.new("UICorner", FN).CornerRadius = UDim.new(0, 12)
          QN = Instance.new("UIStroke", FN)
          QN.Color = xN.Color
          QN.Thickness = xN.Thickness
          local vN, VN = sN, {}
          local function Cf()
            for bf, Df in ipairs(VN) do
              local Rf = bf == vN
              Df.stroke.Color = SN
              Df.stroke.Thickness = Rf and 2 or 1.5
              Df.stroke.Transparency = Rf and 0.25 or 0.7
              Df.stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
              local bf, nf, Qf, uf =
                Df.baseX or Df.Position.X.Offset,
                Df.baseY or Df.Position.Y.Offset,
                Df.baseW or Df.Size.X.Offset,
                Df.baseH or Df.Size.Y.Offset
              Df.card.Size = Rf and (UDim2.fromOffset(math.max(4, Qf - 6), math.max(4, uf - 6)))
                or (UDim2.fromOffset(Qf, uf))
              Df.card.Position = Rf and (UDim2.new(0, bf + 3, 0, nf + 3))
                or (UDim2.new(0, bf, 0, nf))
              Df.image.Size = UDim2.new(1, 0, 1, 0)
              Df.image.Position = UDim2.new(0, 0, 0, 0)
            end
          end
          for bf, Df in ipairs(iN) do
            QN, z, cN =
              Instance.new("TextButton", FN),
              12 + (bf - 1) % 2 * 98,
              12 + math.floor((bf - 1) / 2) * 62
            QN.Size = UDim2.fromOffset(88, 56)
            QN.Position = UDim2.new(0, z, 0, cN)
            QN.BackgroundColor3 = SN
            QN.BorderSizePixel = 0
            QN.Text = ""
            QN.AutoButtonColor = false
            QN.ZIndex = 21
            Instance.new("UICorner", QN).CornerRadius = UDim.new(0, 7)
            local Rf = Instance.new("ImageLabel", QN)
            Rf.Size = UDim2.new(1, 0, 1, 0)
            Rf.BackgroundTransparency = 1
            Rf.Image = Df
            Rf.ScaleType = Enum.ScaleType.Crop
            Rf.ZIndex = 21
            Instance.new("UICorner", Rf).CornerRadius = UDim.new(0, 7)
            Df = Instance.new("TextLabel", QN)
            Df.Size = UDim2.new(1, -6, 0, 14)
            Df.Position = UDim2.new(0, 3, 1, -16)
            Df.BackgroundTransparency = 1
            Df.Text = "GUI " .. tostring(bf)
            Df.TextColor3 = SN
            Df.TextSize = 8
            Df.Font = Enum.Font.GothamBold
            Df.ZIndex = 23
            Df.TextStrokeColor3 = Color3.fromRGB(6, 6, 9)
            Df.TextStrokeTransparency = 0.25
            Df = Instance.new("UIStroke", QN)
            Df.Color = Color3.fromRGB(0, 0, 0)
            Df.Thickness = 1
            Df.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            table.insert(
              VN,
              { card = QN, stroke = Df, image = Rf, baseX = z, baseY = cN, baseW = 88, baseH = 56 }
            )
            QN.Activated:Connect(function()
              vN = bf
              Cf()
            end)
          end
          z = Instance.new("TextButton", FN)
          z.Size = UDim2.new(1, -24, 0, 28)
          z.Position = UDim2.new(0, 12, 1, -44)
          z.BackgroundColor3 = Color3.fromRGB(92, 28, 35)
          z.BorderSizePixel = 0
          z.Text = "Save Theme"
          z.TextColor3 = SN
          z.TextSize = 11
          z.Font = Enum.Font.GothamBold
          z.ZIndex = 21
          Instance.new("UICorner", z).CornerRadius = UDim.new(0, 7)
          z.Activated:Connect(function()
            sN = vN
            IN.Image = iN[sN]
            _G.__AkatsukiFramePanelBackground(IN, sN, "Bypass")
            xN.Transparency = sN == 1 and 1 or 0.448
            gN.Transparency = sN == 1 and 1 or 0.782
            BN.Transparency = sN == 1 and 1 or 0.891
            if NN then
              NN()
            end
            FN.Visible = false
            wN()
          end)
          KN.Activated:Connect(function()
            vN = sN
            XN()
            FN.Visible = not FN.Visible
            Cf()
          end)
          qN = Instance.new("TextButton")
          qN.AnchorPoint = Vector2.new(0, 0)
          qN.Size = UDim2.new(0, 44, 0, 22)
          qN.Position = UDim2.new(0, 16, 0, 13)
          qN.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
          qN.BackgroundTransparency = 0
          qN.AutoButtonColor = false
          qN.Font = Enum.Font.GothamBold
          qN.Text = "V1"
          qN.TextColor3 = ZN
          qN.TextSize = 10
          qN.Parent = tN
          Instance.new("UICorner", qN).CornerRadius = UDim.new(0, 6)
          cN = Instance.new("UIGradient", qN)
          cN.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 15)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(242, 242, 245)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 15)),
          })
          cN.Rotation = 0
          local vN = Instance.new("UIStroke", qN)
          vN.Color = Color3.fromRGB(255, 165, 172)
          vN.Thickness = 1
          vN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          local function VN()
            qN.Text = UN.Version
            qN.TextColor3 = SN
            vN.Color = Color3.fromRGB(255, 165, 172)
          end
          qN.Activated:Connect(function()
            HN(UN.Version == "V1" and "V2" or "V1")
            VN()
            wN()
          end)
          z = Instance.new("Frame")
          z.Name = "PCToggleFrame"
          z.AnchorPoint = Vector2.new(0.5, 0)
          z.Position = UDim2.new(0.5, 0, 0, 13)
          z.Size = UDim2.new(0, 100, 0, 22)
          z.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
          z.BackgroundTransparency = 0.4
          z.Parent = tN
          Instance.new("UICorner", z).CornerRadius = UDim.new(0, 6)
          QN = Instance.new("UIStroke", z)
          QN.Color = Color3.fromRGB(88, 34, 40)
          QN.Transparency = 0.3
          kN = Instance.new("TextButton")
          kN.Position = UDim2.new(0, 2, 0, 2)
          kN.Size = UDim2.new(0.5, -2, 1, -4)
          kN.BackgroundTransparency = 0.4
          kN.Text = "PC"
          kN.TextSize = 9
          kN.Font = Enum.Font.GothamBold
          kN.AutoButtonColor = false
          kN.Parent = z
          Instance.new("UICorner", kN).CornerRadius = UDim.new(0, 5)
          EN = Instance.new("TextButton")
          EN.Position = UDim2.new(0.5, 2, 0, 2)
          EN.Size = UDim2.new(0.5, -2, 1, -4)
          EN.BackgroundTransparency = 0.4
          EN.Text = "Mobile"
          EN.TextSize = 9
          EN.Font = Enum.Font.GothamBold
          EN.AutoButtonColor = false
          EN.Parent = z
          Instance.new("UICorner", EN).CornerRadius = UDim.new(0, 5)
          z = Instance.new("Frame")
          z.Name = "PowerRow"
          z.Position = UDim2.new(0, 22, 0, 74)
          z.Size = UDim2.new(1, -44, 0, 40)
          z.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
          z.BackgroundTransparency = 0.4
          z.Parent = tN
          Instance.new("UICorner", z).CornerRadius = UDim.new(0, 10)
          cN = Instance.new("UIStroke", z)
          cN.Color = Color3.fromRGB(88, 34, 40)
          cN.Transparency = 0.3
          cN = Instance.new("TextLabel")
          cN.Size = UDim2.new(0, 38, 1, 0)
          cN.Position = UDim2.new(0, 8, 0, 0)
          cN.BackgroundTransparency = 1
          cN.Text = "POWER"
          cN.TextColor3 = SN
          cN.TextTransparency = 0
          cN.TextSize = 8
          cN.Font = Enum.Font.GothamBold
          cN.TextXAlignment = Enum.TextXAlignment.Left
          cN.Parent = z
          hN = Instance.new("TextBox")
          hN.Size = UDim2.new(0, 60, 0, 24)
          hN.Position = UDim2.new(0, 46, 0, 8)
          hN.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
          hN.BackgroundTransparency = 0.4
          hN.Font = Enum.Font.GothamBold
          hN.Text = "97000"
          hN.PlaceholderText = "97000"
          hN.TextColor3 = SN
          hN.TextSize = 10
          hN.ClearTextOnFocus = false
          hN.ZIndex = 4
          hN.Parent = z
          Instance.new("UICorner", hN).CornerRadius = UDim.new(0, 6)
          cN = Instance.new("UIStroke", hN)
          cN.Color = Color3.fromRGB(0, 0, 0)
          cN.Thickness = 1.2
          cN.Transparency = 0.2
          hN:GetPropertyChangedSignal("Text"):Connect(function()
            local vN = hN.Text:gsub("%D", "")
            if vN ~= hN.Text then
              hN.Text = vN
            end
          end)
          hN.FocusLost:Connect(function()
            local vN = tonumber(hN.Text)
            if vN then
              local Cf = UN.Mode == "PC" and 150000 or 100000
              local bf = math.clamp(vN, 10000, Cf)
              hN.Text = tostring(bf)
              DN(bf)
            else
              hN.Text = tostring(UN.Power)
            end
            wN()
          end)
          QN = Instance.new("TextLabel")
          QN.Size = UDim2.new(0.8, 0, 0, 20)
          QN.Position = UDim2.new(0.1, 0, 0, 135)
          QN.BackgroundTransparency = 1
          QN.Text = "KEYBIND"
          QN.TextColor3 = SN
          QN.TextTransparency = 0.25
          QN.TextSize = 10
          QN.Font = Enum.Font.Gotham
          QN.TextXAlignment = Enum.TextXAlignment.Left
          QN.Parent = tN
          QN.Visible = false
          YN = Instance.new("TextButton")
          YN.Size = UDim2.new(0, 30, 0, 24)
          YN.Position = UDim2.new(1, -34, 0, 8)
          YN.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
          YN.BackgroundTransparency = 0.4
          YN.AutoButtonColor = false
          YN.Font = Enum.Font.GothamBold
          YN.Text = "5"
          YN.TextColor3 = SN
          YN.TextSize = 10
          YN.ZIndex = 4
          YN.Parent = z
          Instance.new("UICorner", YN).CornerRadius = UDim.new(0, 6)
          cN = Instance.new("UIStroke", YN)
          cN.Color = Color3.fromRGB(0, 0, 0)
          cN.Thickness = 1.2
          cN.Transparency = 0.2
          jN = Instance.new("TextButton")
          jN.AnchorPoint = Vector2.new(0, 0)
          jN.Size = UDim2.new(1, -150, 0, 32)
          jN.Position = UDim2.new(0, 112, 0, 4)
          jN.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
          jN.BackgroundTransparency = 0.1
          jN.AutoButtonColor = false
          jN.Font = Enum.Font.GothamBold
          jN.Text = "ACTIVATE BYPASS"
          jN.TextColor3 = SN
          jN.TextSize = 9
          jN.Parent = z
          Instance.new("UICorner", jN).CornerRadius = UDim.new(0, 8)
          local vN = Instance.new("UIStroke", jN)
          vN.Color = Color3.fromRGB(0, 0, 0)
          vN.Thickness = 1.2
          vN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          local Cf = Instance.new("UIGradient")
          Cf.Color = ColorSequence.new(Color3.fromRGB(118, 30, 38), Color3.fromRGB(92, 28, 35))
          Cf.Rotation = 90
          Cf.Parent = jN
          Cf.Enabled = false
          local bf = Instance.new("UIScale", jN)
          bf.Scale = 1
          cN = Instance.new("Frame")
          cN.Size = UDim2.new(1, -44, 0, 24)
          cN.Position = UDim2.new(0, 22, 0, 118)
          cN.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
          cN.BackgroundTransparency = 0.4
          cN.Parent = tN
          Instance.new("UICorner", cN).CornerRadius = UDim.new(0, 8)
          z = Instance.new("UIStroke", cN)
          z.Color = Color3.fromRGB(88, 34, 40)
          z.Transparency = 0.3
          eN = Instance.new("TextButton")
          eN.Size = UDim2.new(0, 28, 0, 14)
          eN.Position = UDim2.new(1, -38, 0.5, -7)
          eN.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
          eN.BackgroundTransparency = 0.4
          eN.AutoButtonColor = false
          eN.Text = ""
          eN.Parent = cN
          Instance.new("UICorner", eN).CornerRadius = UDim.new(1, 0)
          local z = Instance.new("UIStroke", eN)
          z.Color = Color3.fromRGB(0, 0, 0)
          z.Thickness = 1.2
          local tN = Instance.new("Frame")
          tN.Size = UDim2.new(0, 10, 0, 10)
          tN.Position = UDim2.new(0, 2, 0.5, -5)
          tN.BackgroundColor3 = Color3.fromRGB(245, 68, 78)
          tN.BorderSizePixel = 0
          tN.Parent = eN
          Instance.new("UICorner", tN).CornerRadius = UDim.new(1, 0)
          local Df = Instance.new("TextLabel")
          Df.Size = UDim2.new(0.5, 0, 1, 0)
          Df.Position = UDim2.new(0, 10, 0, 0)
          Df.BackgroundTransparency = 1
          Df.Font = Enum.Font.GothamBold
          Df.Text = "Auto On Steal"
          Df.TextColor3 = ZN
          Df.TextSize = 9
          Df.TextXAlignment = Enum.TextXAlignment.Left
          Df.TextYAlignment = Enum.TextYAlignment.Center
          Df.Parent = cN
          lN = function()
            local cN = UN.Mode == "PC"
            kN.BackgroundColor3 = cN and (Color3.fromRGB(210, 38, 50)) or (Color3.fromRGB(8, 8, 10))
            kN.TextColor3 = cN and SN or (Color3.fromRGB(188, 188, 194))
            EN.BackgroundColor3 = cN and (Color3.fromRGB(8, 8, 10)) or (Color3.fromRGB(210, 38, 50))
            EN.TextColor3 = cN and (Color3.fromRGB(188, 188, 194)) or SN
            YN.Visible = cN
            hN.Size = UDim2.new(0, 60, 0, 24)
          end
          local function cN(Rf)
            if Rf ~= "PC" and Rf ~= "Mobile" then
              return
            end
            if UN.Mode == Rf then
              return
            end
            local nf = yN
            if nf then
              ON()
            end
            UN.Mode = Rf
            UN.Power = Rf == "PC" and UN.PCPower or UN.MobilePower
            hN.Text = tostring(UN.Power)
            lN()
            if nf then
              LN()
            end
            wN()
          end
          kN.Activated:Connect(function()
            cN("PC")
          end)
          EN.Activated:Connect(function()
            cN("Mobile")
          end)
          lN()
          NN = function()
            mN.Visible = false
            KN.TextColor3 = SN or ZN
            mN.TextColor3 = SN
            WN.TextColor3 = SN or (Color3.fromRGB(68, 22, 28))
            qN.TextColor3 = SN or ZN
            jN.TextColor3 = SN
            Df.TextColor3 = SN or ZN
          end
          NN()
          local ZN, KN = false, false
          local function kN(EN, mN)
            EN = EN == true
            if yN == EN then
              PN()
              return
            end
            if EN then
              if not LN() then
                return
              end
              jN.Text = "DEACTIVATE BYPASS"
              jN.TextColor3 = SN
              Cf.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(225, 225, 225)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(195, 195, 195)),
              })
              if mN then
                b:Create(jN, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(210, 38, 50) })
                  :Play()
                b
                  :Create(
                    vN,
                    TweenInfo.new(0.2),
                    { Color = Color3.fromRGB(255, 165, 172), Thickness = 1.8, Transparency = 0 }
                  )
                  :Play()
              else
                jN.BackgroundColor3 = Color3.fromRGB(210, 38, 50)
                vN.Color = Color3.fromRGB(255, 165, 172)
                vN.Thickness = 1.8
              end
            else
              ON()
              jN.Text = "ACTIVATE BYPASS"
              jN.TextColor3 = SN
              Cf.Color = ColorSequence.new(Color3.fromRGB(118, 30, 38), Color3.fromRGB(92, 28, 35))
              if mN then
                b:Create(jN, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(28, 28, 32) })
                  :Play()
                b
                  :Create(
                    vN,
                    TweenInfo.new(0.2),
                    { Color = Color3.fromRGB(0, 0, 0), Thickness = 1.2, Transparency = 0 }
                  )
                  :Play()
              else
                jN.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
                vN.Color = Color3.fromRGB(0, 0, 0)
                vN.Thickness = 1.2
              end
            end
            bf.Scale = 0.94
            b:Create(
              bf,
              TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
              { Scale = 1 }
            ):Play()
            PN()
            wN()
          end
          local function SN(EN)
            local mN, WN, vN, PN =
              MN and (Color3.fromRGB(210, 38, 50)) or (Color3.fromRGB(28, 28, 32)),
              MN and (UDim2.new(0, 16, 0.5, -5)) or (UDim2.new(0, 2, 0.5, -5)),
              MN and (Color3.fromRGB(255, 165, 172)) or (Color3.fromRGB(88, 34, 40)),
              MN and 1.6 or 1.2
            if EN then
              b:Create(eN, TweenInfo.new(0.2), { BackgroundColor3 = mN }):Play()
              b:Create(tN, TweenInfo.new(0.2), {
                Position = WN,
                BackgroundColor3 = MN and (Color3.fromRGB(45, 45, 45))
                  or (Color3.fromRGB(245, 68, 78)),
              }):Play()
              b:Create(z, TweenInfo.new(0.2), { Color = vN, Thickness = PN }):Play()
            else
              eN.BackgroundColor3 = mN
              tN.Position = WN
              tN.BackgroundColor3 = MN and (Color3.fromRGB(45, 45, 45))
                or (Color3.fromRGB(245, 68, 78))
              z.Color = vN
              z.Thickness = PN
            end
          end
          local function z()
            if not nN then
              return false
            end
            return nN:GetAttribute("Stealing") == true
          end
          local function EN(mN)
            local WN = z()
            ZN = WN
            if MN and not TN and WN ~= yN then
              kN(WN, mN)
            end
          end
          _G.__AkatsukiTrackConn(nN:GetAttributeChangedSignal("Stealing"):Connect(function()
            local z = nN:GetAttribute("Stealing")
            if z == true then
              TN = false
            end
            EN(true)
          end))
          task.spawn(function()
            while Q.Parent do
              EN(false)
              task.wait(1)
            end
          end)
          local z = {
            [Enum.UserInputType.Gamepad1] = true,
            [Enum.UserInputType.Gamepad2] = true,
            [Enum.UserInputType.Gamepad3] = true,
            [Enum.UserInputType.Gamepad4] = true,
          }
          local function nN(mN)
            local WN = mN.UserInputType
            return WN == Enum.UserInputType.Keyboard
              or WN == Enum.UserInputType.MouseButton3
              or z[WN] == true
          end
          local function z(mN)
            if mN.UserInputType == Enum.UserInputType.MouseButton3 then
              return "Mouse3"
            end
            return ({
              Zero = "0",
              One = "1",
              Two = "2",
              Three = "3",
              Four = "4",
              Five = "5",
              Six = "6",
              Seven = "7",
              Eight = "8",
              Nine = "9",
            })[mN.KeyCode.Name] or mN.KeyCode.Name
          end
          local function mN(WN)
            KN = WN
            YN.Text = WN and "..."
              or (dN and (z({ UserInputType = dN.inputType, KeyCode = dN.keyCode })) or "None")
          end
          YN.Activated:Connect(function()
            mN(true)
          end)
          local function WN()
            TN = true
            kN(not yN, true)
            wN()
          end
          jN.Activated:Connect(function()
            WN()
          end)
          AN.Activated:Connect(function()
            WN()
          end)
          jN.MouseEnter:Connect(function()
            if not yN then
              b:Create(jN, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(35, 35, 35) })
                :Play()
            end
          end)
          jN.MouseLeave:Connect(function()
            if not yN then
              b:Create(jN, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(28, 28, 32) })
                :Play()
            end
          end)
          _G.__AkatsukiTrackConn(C.InputBegan:Connect(function(jN, tN)
            if KN then
              if jN.UserInputType == Enum.UserInputType.MouseButton1 then
                mN(false)
                return
              end
              if nN(jN) then
                dN = { inputType = jN.UserInputType, keyCode = jN.KeyCode }
                YN.Text = z(jN)
                KN = false
                wN()
              end
              return
            end
            if tN then
              return
            end
            if dN and jN.UserInputType == dN.inputType and jN.KeyCode == dN.keyCode then
              WN()
            end
          end))
          eN.Activated:Connect(function()
            MN = not MN
            _G._AkatsukiHub_BypassAuto = MN
            SN(true)
            if MN then
              TN = false
              EN(true)
            end
            wN()
          end)
          local nN, jN, eN, KN = false
          local function mN(WN)
            local tN, AN = GN.AbsolutePosition, GN.AbsoluteSize
            return WN.X >= tN.X and WN.X <= tN.X + AN.X and WN.Y >= tN.Y and WN.Y <= tN.Y + 48
          end
          _G.__AkatsukiTrackConn(C.InputBegan:Connect(function(WN)
            if
              WN.UserInputType ~= Enum.UserInputType.MouseButton1
              and WN.UserInputType ~= Enum.UserInputType.Touch
            then
              return
            end
            if not GN.Visible or not mN(WN.Position) then
              return
            end
            nN = true
            jN = WN.Position
            eN, KN = GN.AbsolutePosition, WN
          end))
          _G.__AkatsukiTrackConn(C.InputChanged:Connect(function(mN)
            if not nN then
              return
            end
            if
              mN.UserInputType ~= Enum.UserInputType.MouseMovement
              and mN.UserInputType ~= Enum.UserInputType.Touch
            then
              return
            end
            local WN = mN.Position - jN
            local jN, mN = eN.X + WN.X, eN.Y + WN.Y
            GN.Position = UDim2.new(0, jN, 0, mN)
          end))
          _G.__AkatsukiTrackConn(C.InputEnded:Connect(function(jN)
            local eN = KN
              and KN.UserInputType == Enum.UserInputType.MouseButton1
              and jN.UserInputType == Enum.UserInputType.MouseButton1
            if not nN or jN ~= KN and not eN then
              return
            end
            nN, KN = false, nil
            wN()
          end))
          for jN, jN in ipairs(Q:GetDescendants()) do
            if jN:IsA("TextLabel") or (jN:IsA("TextButton")) or (jN:IsA("TextBox")) then
              jN:SetAttribute("AkatsukiKeepBlackText", true)
              jN.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
              jN.TextStrokeTransparency = 0.2
            end
          end
          if NN then
            NN()
          end
          local jN = rN()
          if jN then
            if jN.visible ~= nil then
              GN.Visible = jN.visible
            end
            if jN.bypassVersion then
              UN.Version = jN.bypassVersion
              VN()
            else
              UN.Version = "V1"
              VN()
            end
            UN.Mode = jN.mode == "Mobile" and "Mobile" or "PC"
            QN = tonumber(jN.power)
            UN.PCPower =
              math.clamp(tonumber(jN.pcPower) or UN.Mode == "PC" and QN or 97000, 10000, 150000)
            UN.MobilePower = math.clamp(
              tonumber(jN.mobilePower) or UN.Mode == "Mobile" and QN or 72000,
              10000,
              150000
            )
            UN.Power = UN.Mode == "PC" and UN.PCPower or UN.MobilePower
            hN.Text = tostring(UN.Power)
            lN()
            if jN.autoOnSteal ~= nil then
              MN = jN.autoOnSteal == true
              _G._AkatsukiHub_BypassAuto = MN
              SN(false)
            end
            if jN.keybind and jN.keybind.inputType and jN.keybind.keyCode then
              pcall(function()
                local QN, eN =
                  Enum.UserInputType[jN.keybind.inputType], Enum.KeyCode[jN.keybind.keyCode]
                if QN and eN then
                  dN = { inputType = QN, keyCode = eN }
                  YN.Text = z({ UserInputType = QN, KeyCode = eN })
                end
              end)
            end
            if jN.background then
              sN = math.clamp(jN.background, 1, #iN)
              IN.Image = iN[sN]
              _G.__AkatsukiFramePanelBackground(IN, sN, "Bypass")
              xN.Transparency = sN == 1 and 1 or 0.448
              gN.Transparency = sN == 1 and 1 or 0.782
              BN.Transparency = sN == 1 and 1 or 0.891
            end
            if NN then
              NN()
            end
            if jN.position and not _G.__AkatsukiGuiPositionsReset then
              pcall(function()
                GN.Position = UDim2.new(
                  jN.position.xScale,
                  jN.position.xOffset,
                  jN.position.yScale,
                  jN.position.yOffset
                )
              end)
            end
            zf(jN.minimized == true, false)
            if jN.manualOverride ~= nil then
              TN = jN.manualOverride
            end
            if MN then
              EN(false)
            end
          else
            UN.Version = "V1"
            UN.Mode = "PC"
            UN.PCPower = 97000
            UN.MobilePower = 72000
            UN.Power = 97000
            hN.Text = "97000"
            qN.Text = "V1"
            VN()
            lN()
            wN()
          end
          sN = 1
          IN.Image = iN[sN]
          _G.__AkatsukiFramePanelBackground(IN, sN, "Bypass")
          xN.Transparency = sN == 1 and 1 or 0.448
          gN.Transparency = sN == 1 and 1 or 0.782
          BN.Transparency = sN == 1 and 1 or 0.891
          if NN then
            NN()
          end
          wN()
          local z = 0
          GN:GetPropertyChangedSignal("Position"):Connect(function()
            if FN.Visible then
              XN()
            end
            z += 1
            local QN = z
            task.delay(0.4, function()
              if QN == z then
                wN()
              end
            end)
          end)
          _G.AkatsukiBypass = {
            ResetPosition = function()
              nN, KN = false, nil
              GN.Position = UDim2.new(0.5, -160, 0.5, -108)
              wN()
            end,
            GetPower = function()
              return UN.Power
            end,
            GetKeybind = function()
              return dN
            end,
            IsEnabled = function()
              return yN
            end,
            IsAutoOnSteal = function()
              return MN
            end,
            IsStealing = function()
              return ZN
            end,
            PauseForDrop = function()
              if UN.DropPaused then
                return true
              end
              UN.DropPaused = yN == true
              if UN.DropPaused then
                ON(true)
              end
              return UN.DropPaused
            end,
            ResumeAfterDrop = function()
              if not UN.DropPaused then
                return false
              end
              UN.DropPaused = false
              return LN()
            end,
            GetBackground = function()
              return sN
            end,
            GetVersion = function()
              return UN.Version
            end,
            GetMode = function()
              return UN.Mode
            end,
            GetPosition = function()
              return { x = GN.Position.X.Offset, y = GN.Position.Y.Offset }
            end,
            SetBackground = function(z)
              sN = math.clamp(z, 1, #iN)
              IN.Image = iN[sN]
              _G.__AkatsukiFramePanelBackground(IN, sN, "Bypass")
              xN.Transparency = sN == 1 and 1 or 0.448
              gN.Transparency = sN == 1 and 1 or 0.782
              BN.Transparency = sN == 1 and 1 or 0.891
              if NN then
                NN()
              end
              wN()
            end,
            SetBypass = function(z)
              TN = true
              kN(z, true)
              wN()
            end,
            SetPower = function(z)
              local nN = UN.Mode == "PC" and 150000 or 100000
              local QN = math.clamp(z, 10000, nN)
              hN.Text = tostring(QN)
              DN(QN)
              wN()
            end,
            SetMode = function(z)
              cN(z)
            end,
            SetAutoOnSteal = function(z)
              MN = z == true
              _G._AkatsukiHub_BypassAuto = MN
              SN(true)
              if MN then
                TN = false
                EN(true)
              end
              wN()
            end,
            SetVisible = function(z)
              if GN then
                local DN = z and true or false
                GN.Visible = DN
                c = DN
                x()
                if not DN and FN then
                  FN.Visible = false
                end
                wN()
              end
            end,
            SetVersion = function(z)
              if z ~= "V1" and z ~= "V2" then
                return
              end
              HN(z)
              VN()
              wN()
            end,
            SetPosition = function(z, DN)
              pcall(function()
                GN.Position = UDim2.new(GN.Position.X.Scale, z, GN.Position.Y.Scale, DN)
                wN()
              end)
            end,
            Stop = function()
              ON()
            end,
          }
          if not o.alive then
            ON()
            pcall(function()
              Q:Destroy()
            end)
            return
          end
          _G.__AkatsukiTrackStopper(function()
            ON()
            pcall(function()
              if Q and Q.Parent then
                Q:Destroy()
              end
            end)
            _G.AkatsukiBypass = nil
            _G._AkatsukiBypassGUILoaded = false
          end)
          function _G.__setBypassAuto(z)
            pcall(function()
              MN = z and true or false
              _G._AkatsukiHub_BypassAuto = MN
              SN(true)
              wN()
              if MN then
                TN = false
                EN(true)
              end
            end)
          end
          pcall(function()
            if B and GN and not GN.Visible then
              GN.Visible = true
              wN()
            end
          end)
        end)
      end)
    end
    _G.__openBypassGUI = F
    local function z()
      c = not c
      x()
      if c then
        if _G._AkatsukiBypassGUILoaded then
          if _G.AkatsukiBypass and _G.AkatsukiBypass.SetVisible then
            _G.AkatsukiBypass.SetVisible(true)
          end
          if _G.AkatsukiBypass and _G.AkatsukiBypass.SaveSettings then
            _G.AkatsukiBypass.SaveSettings()
          end
        else
          F(true)
        end
      else
        if _G.AkatsukiBypass and _G.AkatsukiBypass.SetVisible then
          _G.AkatsukiBypass.SetVisible(false)
        end
        if _G.AkatsukiBypass and _G.AkatsukiBypass.SaveSettings then
          _G.AkatsukiBypass.SaveSettings()
        end
      end
      if _G.AkatsukiBypass and _G.AkatsukiBypass.SetVisible then
        _G.AkatsukiBypass.SetVisible(c)
      end
    end
    n.Activated:Connect(function()
      pcall(function()
        if _G.AkatsukiBypass and _G.AkatsukiBypass.SetBypass and _G.AkatsukiBypass.IsEnabled then
          local n = _G.AkatsukiBypass.IsEnabled() == true
          _G.AkatsukiBypass.SetBypass(not n)
          if _G.__syncBypassVisual then
            pcall(_G.__syncBypassVisual)
          end
        end
      end)
      z()
    end)
    x()
    t, d = _G.__AkatsukiReadSavedPanelVisibility("AkatsukiBypass_Settings.json")
    c = t and d or false
    x()
    if t then
      F(false)
    end
    _G.__AkatsukiReadSavedPanelVisibility = nil
    d = Instance.new("Frame", r)
    d.Size = UDim2.new(1, -18, 0, 28)
    d.Position = UDim2.new(0, 9, 0, 68)
    d.BackgroundTransparency = 1
    d.Visible = true
    t = Instance.new("TextLabel", d)
    t.Size = UDim2.new(1, -50, 0, 32)
    t.Position = UDim2.new(0, 0, 0, 2)
    t.BackgroundTransparency = 1
    t.Text = "Toggle UI"
    t.TextColor3 = Color3.fromRGB(105, 30, 38)
    t.TextSize = 10
    t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    local z = Instance.new("TextButton", d)
    z.Size = UDim2.new(0, 40, 0, 20)
    z.Position = UDim2.new(1, -48, 0.5, -10)
    z.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    z.BackgroundTransparency = 0.15
    z.BorderSizePixel = 0
    z.Text = E["Toggle UI"] and (zN(E["Toggle UI"])) or "-"
    z.TextColor3 = Color3.fromRGB(238, 238, 242)
    z.TextSize = 9
    z.Font = Enum.Font.GothamBold
    z.AutoButtonColor = false
    Instance.new("UICorner", z).CornerRadius = UDim.new(0, 4)
    t = Instance.new("UIStroke", z)
    t.Color = Color3.fromRGB(255, 255, 255)
    t.Thickness = 1
    t.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    v(z, function()
      if l then
        l.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        l.BackgroundTransparency = 1
        l.Text = "-"
      end
      l, N = z, "Toggle UI"
      z.Text = "..."
      z.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
      z.BackgroundTransparency = 0
    end)
    table.insert(m, z)
    if M["Toggle UI"] == nil then
      M["Toggle UI"] = function()
        z.Text = E["Toggle UI"] and (zN(E["Toggle UI"])) or "-"
        z.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        z.BackgroundTransparency = 0.15
        z.TextColor3 = Color3.fromRGB(238, 238, 242)
      end
    end
  end
  local z, n, Q, o, F =
    aN(k.Animations, "ANIMATIONS"), {
      "Adidas Sports",
      "Adidas Community",
      "Adidas Aura",
      "Wicked Popular",
      "Elder",
      "Zombie",
      "Mage",
      "Catwalk Glam",
      "Astronaut",
      'Wicked "Dancing Through Life"',
      "Werewolf",
      "Superhero",
      "Toy",
      "No Boundaries",
      "NFL",
      "Amazon Unboxed",
      "Vampire",
      "Ninja",
      "Robot",
      "Levitation",
      "Stylish",
      "Bubbly",
      "Cartoon",
    }, {
      ["Adidas Sports"] = {
        WalkAnim = 18537392113,
        RunAnim = 18537384940,
        JumpAnim = 18537380791,
        FallAnim = 18537367238,
        SwimIdle = 18537387180,
        Swim = 18537389531,
        Animation1 = 18537376492,
        Animation2 = 18537371272,
        ClimbAnim = 18537363391,
      },
      ["Adidas Community"] = {
        WalkAnim = 122150855457006,
        RunAnim = 82598234841035,
        JumpAnim = 75290611992385,
        FallAnim = 98600215928904,
        SwimIdle = 109346520324160,
        Swim = 133308483266208,
        Animation1 = 122257458498464,
        Animation2 = 102357151005774,
        ClimbAnim = 88763136693023,
      },
      ["Adidas Aura"] = {
        WalkAnim = 83842218823011,
        RunAnim = 118320322718866,
        JumpAnim = 109996626521204,
        FallAnim = 95603166884636,
        SwimIdle = 94922130551805,
        Swim = 134530128383903,
        Animation1 = 110211186840347,
        Animation2 = 114191137265065,
        ClimbAnim = 97824616490448,
      },
      ["Wicked Popular"] = {
        WalkAnim = 92072849924640,
        RunAnim = 72301599441680,
        JumpAnim = 104325245285198,
        FallAnim = 121152442762481,
        Animation1 = 118832222982049,
        ClimbAnim = 131326830509784,
        SwimIdle = 113199415118199,
        Swim = 99384245425157,
        Animation2 = 76049494037641,
      },
      Elder = {
        WalkAnim = 10921111375,
        RunAnim = 10921104374,
        JumpAnim = 10921107367,
        FallAnim = 10921105765,
        SwimIdle = 10921110146,
        Swim = 10921108971,
        ClimbAnim = 10921100400,
        Animation1 = 10921101664,
        Animation2 = 10921102574,
      },
      Zombie = {
        WalkAnim = 10921355261,
        RunAnim = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
      },
      Mage = {
        WalkAnim = 10921152678,
        RunAnim = 10921148209,
        JumpAnim = 10921149743,
        FallAnim = 10921148939,
        SwimIdle = 10921151661,
        Swim = 10921150788,
        ClimbAnim = 10921143404,
        Animation1 = 10921144709,
        Animation2 = 10921145797,
      },
      ["Catwalk Glam"] = {
        WalkAnim = 109168724482748,
        RunAnim = 81024476153754,
        JumpAnim = 116936326516985,
        FallAnim = 92294537340807,
        SwimIdle = 98854111361360,
        Swim = 134591743181628,
        ClimbAnim = 119377220967554,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
      },
      Astronaut = {
        WalkAnim = 10921046031,
        RunAnim = 10921039308,
        JumpAnim = 10921042494,
        FallAnim = 10921040576,
        SwimIdle = 10921045006,
        Swim = 10921044000,
        ClimbAnim = 10921032124,
        Animation1 = 10921034824,
        Animation2 = 10921036806,
      },
      ['Wicked "Dancing Through Life"'] = {
        WalkAnim = 73718308412641,
        RunAnim = 135515454877967,
        JumpAnim = 78508480717326,
        FallAnim = 78147885297412,
        SwimIdle = 129183123083281,
        Swim = 110657013921774,
        ClimbAnim = 129447497744818,
        Animation1 = 92849173543269,
        Animation2 = 132238900951109,
      },
      Werewolf = {
        WalkAnim = 10921342074,
        RunAnim = 10921336997,
        FallAnim = 10921337907,
        SwimIdle = 10921341319,
        Swim = 10921340419,
        ClimbAnim = 10921329322,
        Animation1 = 10921330408,
        Animation2 = 10921333667,
      },
      Superhero = {
        WalkAnim = 10921298616,
        RunAnim = 10921291831,
        JumpAnim = 10921294559,
        FallAnim = 10921293373,
        SwimIdle = 10921297391,
        Swim = 10921295495,
        ClimbAnim = 10921286911,
        Animation1 = 10921288909,
        Animation2 = 10921290167,
      },
      Toy = {
        WalkAnim = 10921312010,
        RunAnim = 10921306285,
        JumpAnim = 10921308158,
        FallAnim = 10921307241,
        SwimIdle = 10921310341,
        Swim = 10921309319,
        ClimbAnim = 10921300839,
        Animation1 = 10921301576,
      },
      ["No Boundaries"] = {
        WalkAnim = 18747074203,
        RunAnim = 18747070484,
        JumpAnim = 18747069148,
        FallAnim = 18747062535,
        SwimIdle = 18747071682,
        Swim = 18747073181,
        ClimbAnim = 18747060903,
        Animation1 = 18747067405,
        Animation2 = 18747063918,
      },
      NFL = {
        WalkAnim = 110358958299415,
        RunAnim = 117333533048078,
        JumpAnim = 119846112151352,
        FallAnim = 129773241321032,
        SwimIdle = 79090109939093,
        Swim = 132697394189921,
        ClimbAnim = 134630013742019,
        Animation1 = 92080889861410,
        Animation2 = 74451233229259,
      },
      ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
      },
      Vampire = {
        WalkAnim = 10921326949,
        RunAnim = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
      },
      Ninja = {
        RunAnim = 656118852,
        WalkAnim = 656121766,
        JumpAnim = 656117878,
        FallAnim = 656115606,
        Swim = 656119721,
        SwimIdle = 656121397,
        ClimbAnim = 656114359,
        Idle = { 656117400, 656118341, 886742569 },
      },
      Robot = {
        RunAnim = 616091570,
        WalkAnim = 616095330,
        JumpAnim = 616090535,
        FallAnim = 616087089,
        Swim = 616092998,
        SwimIdle = 616094091,
        ClimbAnim = 616086039,
        Idle = { 616088211, 616089559, 885531463 },
      },
      Levitation = {
        RunAnim = 616010382,
        WalkAnim = 616013216,
        JumpAnim = 616008936,
        FallAnim = 616005863,
        Swim = 616011509,
        SwimIdle = 616012453,
        ClimbAnim = 616003713,
        Idle = { 616006778, 616008087, 886862142 },
      },
      Stylish = {
        RunAnim = 616140816,
        WalkAnim = 616146177,
        JumpAnim = 616139451,
        FallAnim = 616134815,
        Swim = 616143378,
        SwimIdle = 616144772,
        ClimbAnim = 616133594,
        Idle = { 616136790, 616138447, 886888594 },
      },
      Bubbly = {
        RunAnim = 910025107,
        WalkAnim = 910034870,
        JumpAnim = 910016857,
        FallAnim = 910001910,
        Swim = 910028158,
        SwimIdle = 910030921,
        ClimbAnim = 909997997,
        Idle = { 910004836, 910009958, 1018536639 },
      },
      Cartoon = {
        RunAnim = 742638842,
        WalkAnim = 742640026,
        JumpAnim = 742637942,
        FallAnim = 742637151,
        Swim = 742639220,
        SwimIdle = 742639812,
        ClimbAnim = 742636889,
        Idle = { 742637544, 742638445, 885477856 },
      },
    }, { "idle1", "idle2", "walk", "run", "jump", "fall", "climb", "swim", "swimidle" }, {
      idle1 = "Idle 1",
      idle2 = "Idle 2",
      walk = "Walk",
      run = "Run",
      jump = "Jump",
      fall = "Fall",
      climb = "Climb",
      swim = "Swim",
      swimidle = "Swim Idle",
    }
  local function k(d)
    if not d then
      return nil
    end
    if type(d) == "number" then
      return "rbxassetid://" .. tostring(d)
    end
    if type(d) == "string" then
      local c = string.gsub(d, "^%s+", "")
      c = string.gsub(c, "%s+$", "")
      if c == "" then
        return nil
      end
      if string.sub(c, 1, 11) == "rbxassetid://" then
        return c
      end
      if string.match(c, "^%d+$") then
        return "rbxassetid://" .. c
      end
      return c
    end
    return nil
  end
  local function d(c)
    local x = c and c.Idle
    return {
      idle1 = k(c and (c.Animation1 or x and x[1])),
      idle2 = k(c and (c.Animation2 or x and x[2])),
      walk = k(c and (c.WalkAnim or c.Walk)),
      run = k(c and (c.RunAnim or c.Run)),
      jump = k(c and (c.JumpAnim or c.Jump)),
      fall = k(c and (c.FallAnim or c.Fall)),
      climb = k(c and (c.ClimbAnim or c.Climb)),
      swim = k(c and (c.Swim or c.SwimAnim)),
      swimidle = k(c and (c.SwimIdle or c.SwimIdleAnim)),
    }
  end
  local k, c =
    {}, {
      idle1 = "rbxassetid://133806214992291",
      idle2 = "rbxassetid://94970088341563",
      walk = "rbxassetid://707897309",
      run = "rbxassetid://707861613",
      jump = "rbxassetid://116936326516985",
      fall = "rbxassetid://116936326516985",
      climb = "rbxassetid://116936326516985",
      swim = "rbxassetid://116936326516985",
      swimidle = "rbxassetid://116936326516985",
    }
  _G.__AkatsukiHub_Anims = c
  local x, B = {}, {}
  for t, DN in pairs(Q) do
    _N = d(DN)
    for DN, nN in ipairs(o) do
      DN = _N[nN]
      if DN then
        R = t .. " " .. F[nN]
        if not B[R] then
          B[R] = DN
          x[DN] = R
        end
      end
    end
  end
  local function t(DN)
    if not DN then
      return ""
    end
    if DN == "rbxassetid://" then
      return "Custom"
    end
    return x[DN] or DN
  end
  local x = {}
  for DN, DN in ipairs(o) do
    x[DN] = {}
  end
  for DN, nN in ipairs(n) do
    B = Q[nN]
    if B then
      DN = d(B)
      for nN, nN in ipairs(o) do
        _N = DN[nN]
        if _N and not table.find(x[nN], _N) then
          table.insert(x[nN], _N)
        end
      end
    end
  end
  local function DN(nN, QN)
    local UN = x[nN]
    if not UN or not QN then
      return
    end
    local x, yN = c[nN], 1
    for HN, aN in ipairs(UN) do
      if aN == x then
        yN = HN % #UN + 1
        break
      end
    end
    c[nN] = UN[yN]
    QN.Text = t(UN[yN])
    oN()
    if y["Harder Hit Anim"] and saveOriginalAnims then
      x = u.Character
      if x then
        saveOriginalAnims(x)
        applyAnimPack(x)
      end
    end
  end
  local x = n[1]
  local function nN(QN)
    local UN = Q[QN]
    if not UN then
      return
    end
    local yN = d(UN)
    x = QN
    c.idle1 = yN.idle1 or c.idle1
    c.idle2 = yN.idle2 or c.idle2
    c.walk = yN.walk or c.walk
    c.run = yN.run or c.run
    c.jump = yN.jump or c.jump
    c.fall = yN.fall or c.fall
    c.climb = yN.climb or c.climb
    c.swim = yN.swim or c.swim
    c.swimidle = yN.swimidle or c.swimidle
    if y["Harder Hit Anim"] and saveOriginalAnims and applyAnimPack then
      UN = u.Character
      if UN then
        saveOriginalAnims(UN)
        applyAnimPack(UN)
      end
    end
  end
  local function QN(UN)
    local yN = Q[UN]
    if not yN then
      return
    end
    local HN = d(yN)
    for d, d in ipairs(o) do
      yN = k[d]
      if yN then
        yN.Text = t(HN[d] or "")
      end
    end
    nN(UN)
  end
  fN(z, "Animaciones (Master)", "Animaciones")
  T.Animaciones = function(d)
    if y["Harder Hit Anim"] == d then
      return
    end
    y["Harder Hit Anim"] = d
    if T["Harder Hit Anim"] then
      T["Harder Hit Anim"](d)
    end
    if M["Harder Hit Anim"] then
      M["Harder Hit Anim"]()
    end
    oN()
  end
  local d = Instance.new("TextButton", z)
  d.Size = UDim2.new(1, 0, 0, 34)
  d.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
  d.BorderSizePixel = 0
  d.Text = "Preset: " .. x
  d.TextColor3 = Color3.fromRGB(255, 255, 255)
  d.TextSize = 11
  d.Font = Enum.Font.GothamBold
  d.AutoButtonColor = false
  Instance.new("UICorner", d).CornerRadius = UDim.new(0, 8)
  v(d, function()
    local v = 1
    for nN, UN in ipairs(n) do
      if UN == x then
        v = nN
        break
      end
    end
    local nN = v + 1
    v = n[if nN > #n then 1 else nN]
    d.Text = "Preset: " .. v
    QN(v)
    oN()
  end)
  local d = Instance.new("Frame", z)
  d.Size = UDim2.new(1, -2, 0, 0)
  d.BackgroundTransparency = 1
  d.ClipsDescendants = false
  local v = Instance.new("UIListLayout", d)
  v.Padding = UDim.new(0, 6)
  v.SortOrder = Enum.SortOrder.LayoutOrder
  v:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    d.Size = UDim2.new(1, -2, 0, v.AbsoluteContentSize.Y)
  end)
  for v, v in ipairs(o) do
    R = Instance.new("Frame", d)
    R.Size = UDim2.new(1, 0, 0, 30)
    R.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    R.BackgroundTransparency = 0.25
    R.BorderSizePixel = 0
    Instance.new("UICorner", R).CornerRadius = UDim.new(0, 8)
    r = Instance.new("TextLabel", R)
    r.Size = UDim2.new(0.48, 0, 1, 0)
    r.Position = UDim2.new(0, 8, 0, 0)
    r.BackgroundTransparency = 1
    r.Text = F[v]
    r.TextColor3 = Color3.fromRGB(220, 220, 230)
    r.TextSize = 11
    r.Font = Enum.Font.GothamBold
    r.TextXAlignment = Enum.TextXAlignment.Left
    local o = Instance.new("TextButton", R)
    o.Size = UDim2.new(0.5, -10, 0, 20)
    o.Position = UDim2.new(0.5, 0, 0.5, -10)
    o.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    o.BorderSizePixel = 0
    o.Text = ""
    o.TextColor3 = Color3.fromRGB(255, 255, 255)
    o.TextSize = 10
    o.Font = Enum.Font.Gotham
    o.AutoButtonColor = false
    Instance.new("UICorner", o).CornerRadius = UDim.new(0, 6)
    o.Activated:Connect(function()
      DN(v, o)
    end)
    k[v] = o
  end
  R = Instance.new("TextLabel", z)
  R.Size = UDim2.new(1, 0, 0, 24)
  R.BackgroundTransparency = 1
  R.Text = "Master: activa/desactiva todas. Toca una animacion para pasar a la siguiente."
  R.TextColor3 = Color3.fromRGB(188, 188, 195)
  R.TextSize = 10
  R.Font = Enum.Font.Gotham
  R.TextXAlignment = Enum.TextXAlignment.Left
  QN(x)
  if _G.__savedAnimations then
    for o, F in pairs(_G.__savedAnimations) do
      if c[o] ~= nil then
        c[o] = F
        R = k[o]
        if R then
          R.Text = t(F)
        end
      end
    end
    _G.__savedAnimations = nil
  end
  local o
  _G.__toggleBtn = nil
  local F = Instance.new("UIScale", g)
  F.Scale = 1
  local k = y["Toggle UI"] ~= false
  if type(_G.__AkatsukiPanelVisible) == "boolean" then
    k = _G.__AkatsukiPanelVisible
  end
  if y["Toggle UI"] ~= k then
    y["Toggle UI"] = k
  end
  if M["Toggle UI"] then
    M["Toggle UI"]()
  end
  local d, c, t, v = false, false
  function setPanelVisible(DN)
    DN = DN == true
    _G.__AkatsukiPanelVisible = DN
    y["Toggle UI"] = DN
    if g.Visible == DN then
      k = DN
      if t then
        t.Visible = not DN
      end
      if v then
        v.Visible = not DN
      end
      oN()
      return
    end
    if d or c then
      return
    end
    c = true
    task.delay(0.3, function()
      c = false
    end)
    k = DN
    if DN then
      g.Visible = true
      if t then
        t.Visible = false
      end
      if v then
        v.Visible = false
      end
      F.Scale = 0.92
      g.BackgroundTransparency = 0.2
      b:Create(
        F,
        TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Scale = 1 }
      ):Play()
      b:Create(g, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.2 })
        :Play()
    else
      d = true
      b:Create(
        F,
        TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        { Scale = 0.9 }
      ):Play()
      b:Create(g, TweenInfo.new(0.16, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.8 })
        :Play()
      task.delay(0.16, function()
        g.Visible = false
        if t then
          t.Visible = true
        end
        if v then
          v.Visible = true
        end
        F.Scale = 1
        g.BackgroundTransparency = 0.95
        d = false
      end)
    end
    if M["Toggle UI"] then
      M["Toggle UI"]()
    end
    oN()
  end
  g.Visible = false
  _G.__setPanelVisible = setPanelVisible
  FeatureToggles["Toggle UI"] = function()
    setPanelVisible(not g.Visible)
  end
  a = _G._AkatsukiHub_UI_MenuPos
  if a then
    _N, r, R = Vector2.new, X(g, 0, a.x, 0, a.y)
    z = _N(r, R)
    g.Position = UDim2.new(0, z.X, 0, z.Y)
  else
    g.Position = UDim2.new(1, -f - 20, 0.5, -Y / 2)
  end
  g.Visible = false
  y["Toggle UI"] = k
  _G.__AkatsukiPanelVisible = k
  if t then
    R = not k
    t.Visible = R
  end
  if v then
    B = not k
    v.Visible = B
  end
  (function()
    _G.__AkatsukiModernGuiActive = true
    local z = h:FindFirstChild("MainThemesPanel")
    if z then
      z:Destroy()
    end
    if W then
      W.Parent = h
    end
    if w then
      w.Parent = h
    end
    for R, R in ipairs(g:GetChildren()) do
      if R ~= F then
        R:Destroy()
      end
    end
    if F then
      F.Scale = 1
    end
    if o then
      o:Destroy()
      o = nil
      _G.__toggleBtn = nil
    end
    if t then
      pcall(function()
        t:Destroy()
      end)
      t, v = nil, nil
    end
    g.Name = "AkatsukiModernPanel"
    local R, o =
      {
        headerH = p and 46 or 54,
        pageGap = p and 3 or 5,
        sectionH = p and 22 or 24,
        inputH = p and 28 or 34,
        toggleH = p and 28 or 34,
        toggleBindH = p and 38 or 46,
        actionH = p and 30 or 38,
        textSize = p and 9 or 11,
        categoryH = p and 28 or 36,
      }, workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or H
    local H, a =
      p and (math.clamp(math.floor(o.X * 0.58), 240, 330)) or 430,
      p and (math.clamp(math.floor(o.Y * 0.58), 260, 390)) or 500
    g.Size = UDim2.new(0, H, 0, a)
    z = _G._AkatsukiHub_UI_MenuPos
    if z and z.x ~= nil and z.y ~= nil then
      g.Position = UDim2.new(z.xs or 0, z.x, z.ys or 0, z.y)
    else
      g.Position = UDim2.new(0, 6, 0, 54)
    end
    g.BackgroundTransparency = 1
    g.BorderSizePixel = 0
    g.ClipsDescendants = false
    g.Visible = k
    local f = {
      bg = Color3.fromRGB(16, 16, 19),
      bgDark = Color3.fromRGB(8, 8, 10),
      row = Color3.fromRGB(26, 26, 30),
      accent = Color3.fromRGB(235, 48, 60),
      accentDim = Color3.fromRGB(118, 30, 38),
      text = Color3.fromRGB(242, 242, 245),
      textDim = Color3.fromRGB(198, 198, 204),
      textMuted = Color3.fromRGB(148, 148, 156),
      divider = Color3.fromRGB(82, 36, 42),
    }
    local function Y(F, k)
      local d, c = Instance.new("UICorner"), k or 5
      d.CornerRadius = UDim.new(0, if c < 20 then (math.min(c, 6)) else c)
      d.Parent = F
      return d
    end
    local function F(k, d, c)
      local r = Instance.new("UIStroke")
      r.Color = d or f.divider
      r.Thickness = c or 1
      r.Parent = k
      return r
    end
    local k = setmetatable({}, { __mode = "k" })
    local function d(c, r, B, t, v)
      if not c or not c.Parent then
        return nil
      end
      local DN = k[c]
      if DN then
        pcall(function()
          DN:Cancel()
        end)
      end
      local DN = b:Create(
        c,
        TweenInfo.new(B or 0.16, t or Enum.EasingStyle.Quart, v or Enum.EasingDirection.Out),
        r
      )
      k[c] = DN
      DN:Play()
      return DN
    end
    local function k(c, r)
      local B, t, v, DN = false
      c.Active = true
      _G.__AkatsukiGuiPositionResetters[r.Name] = function()
        B, t, v, DN = false, nil, nil, nil
        r.Position = UDim2.fromOffset(6, 54)
        if r == g then
          _G._AkatsukiHub_UI_MenuPos = nil
        else
          _G._AkatsukiHub_UI_ModernMiniPos = nil
        end
      end
      c.InputBegan:Connect(function(nN)
        if
          nN.UserInputType == Enum.UserInputType.MouseButton1
          or nN.UserInputType == Enum.UserInputType.Touch
        then
          if B then
            return
          end
          t, B = nN, true
          v = nN.Position
          DN = r.Position
          nN.Changed:Connect(function()
            if nN.UserInputState == Enum.UserInputState.End then
              B = false
              if r == g then
                _G._AkatsukiHub_UI_MenuPos = {
                  x = r.Position.X.Offset,
                  y = r.Position.Y.Offset,
                  xs = r.Position.X.Scale,
                  ys = r.Position.Y.Scale,
                }
                pcall(oN)
              elseif r.Name == "AkatsukiRestoreButton" then
                _G._AkatsukiHub_UI_ModernMiniPos =
                  { x = r.Position.X.Offset, y = r.Position.Y.Offset }
                pcall(oN)
              end
            end
          end)
        end
      end)
      c.InputChanged:Connect(function(c)
        local nN = B
          and t.UserInputType ~= Enum.UserInputType.Touch
          and c.UserInputType == Enum.UserInputType.MouseMovement
        if nN then
          t = c
        end
      end)
      _G.__AkatsukiTrackConn(C.InputChanged:Connect(function(c)
        if B and c == t then
          local B = c.Position - v
          X(r, DN.X.Scale, DN.X.Offset + B.X, DN.Y.Scale, DN.Y.Offset + B.Y)
        end
      end))
    end
    local c = Instance.new("Frame")
    c.Name = "Inner"
    c.Size = UDim2.new(1, 0, 1, 0)
    c.BackgroundColor3 = f.bgDark
    c.BackgroundTransparency = 0.18
    c.BorderSizePixel = 0
    c.Parent = g
    Y(c, 7)
    H = Instance.new("ImageLabel")
    H.Name = "AkatsukiHubBackground"
    H.Size = UDim2.fromScale(1, 1)
    H.Position = UDim2.fromScale(0, 0)
    H.BackgroundTransparency = 1
    H.Image = uN[pN]
    H.ImageTransparency = 0.18
    H.ScaleType = Enum.ScaleType.Crop
    H.ZIndex = 0
    H.Parent = c
    Y(H, 7)
    local r, B, t, v = F(c, f.accentDim, 1.25), { ["GUI 1"] = true }, { ["GUI 1"] = 1 }, "GUI 1"
    _G.__AkatsukiGuiTheme = v
    local DN
    local function nN(QN)
      local uN = t[QN] or 1
      pcall(function()
        if _G.AkatsukiLagger and _G.AkatsukiLagger.SetBackground then
          _G.AkatsukiLagger.SetBackground(uN)
        end
      end)
      pcall(function()
        if _G.AkatsukiBypass and _G.AkatsukiBypass.SetBackground then
          _G.AkatsukiBypass.SetBackground(uN)
        end
      end)
    end
    _G.__AkatsukiAddUnifiedPanelShade(c, 7, 1);
    (function(t)
      t = if not B[t] then "GUI 1" else t
      v = t
      _G.__AkatsukiGuiTheme = t
      if _G.__AkatsukiApplyTheme then
        _G.__AkatsukiApplyTheme()
      end
      c.BackgroundColor3 = f.bgDark
      c.BackgroundTransparency = 0.18
      local B = c:FindFirstChild("UnifiedBackgroundShade")
      if B then
        B.Visible = false
      end
      r.Transparency = 0.12
      nN(t)
      if _G.__AkatsukiApplyAutoStealBarTheme then
        pcall(_G.__AkatsukiApplyAutoStealBarTheme, t)
      end
      if _G.__AkatsukiRefreshESPTheme then
        pcall(_G.__AkatsukiRefreshESPTheme, _G.__AkatsukiThemeAccent, Color3.fromRGB(0, 0, 0))
      end
      if _G.__refreshSpeedBillboards then
        pcall(_G.__refreshSpeedBillboards)
      end
      if DN then
        DN()
      end
    end)(v)
    o = Instance.new("Frame")
    o.Name = "HeaderFrame"
    o.Size = UDim2.new(1, 0, 0, R.headerH)
    o.BackgroundTransparency = 1
    o.ZIndex = 10
    o.Parent = c
    k(o, g)
    a = Instance.new("Frame")
    a.Name = "HeaderStats"
    a.Position = UDim2.new(0, 14, 0, 8)
    a.Size = UDim2.new(0, 78, 0, 40)
    a.BackgroundColor3 = f.bgDark
    a.BackgroundTransparency = 0.35
    a.BorderSizePixel = 0
    a.ZIndex = 12
    a.Parent = o
    a.Visible = false
    Y(a, 8)
    F(a, Color3.fromRGB(45, 45, 45), 1)
    if W then
      W.Parent = a
      W.Position = UDim2.new(0, 7, 0, 3)
      W.Size = UDim2.new(1, -14, 0, 16)
      W.BackgroundTransparency = 1
      W.TextColor3 = f.text
      W.TextSize = 9
      W.Font = Enum.Font.GothamBold
      W.TextXAlignment = Enum.TextXAlignment.Left
      W.TextTransparency = 0
      W.Visible = false
      W.ZIndex = 13
    end
    if w then
      w.Parent = a
      w.Position = UDim2.new(0, 7, 0, 20)
      w.Size = UDim2.new(1, -14, 0, 16)
      w.BackgroundTransparency = 1
      w.TextColor3 = f.textDim
      w.TextSize = 9
      w.Font = Enum.Font.GothamBold
      w.TextXAlignment = Enum.TextXAlignment.Left
      w.TextTransparency = 0
      w.Visible = false
      w.ZIndex = 13
    end
    a = Instance.new("Frame")
    a.Name = "AkatsukiHubTitleBackground"
    a.Size = UDim2.fromOffset(p and 132 or 150, 28)
    a.Position = UDim2.new(0, 14, 0, (R.headerH - 28) / 2)
    a.BackgroundColor3 = f.bgDark
    a.BackgroundTransparency = 1
    a.BorderSizePixel = 0
    a.ZIndex = 19
    a.Parent = c
    Y(a, 8)
    z = Instance.new("TextLabel")
    z.Name = "HubTitle"
    z:SetAttribute("AkatsukiKeepBlackText", true)
    z.AnchorPoint = Vector2.new(0, 0)
    z.Position = UDim2.new(0, 0, 0, 0)
    z.Size = UDim2.new(1, 0, 1, 0)
    z.BackgroundTransparency = 1
    z.BorderSizePixel = 0
    z.Text = "Akatsuki Hub"
    z.TextColor3 = f.accent
    z.TextTransparency = 0
    z.TextStrokeTransparency = 1
    z.TextSize = p and 13 or 15
    z.Font = Enum.Font.GothamBold
    z.TextXAlignment = Enum.TextXAlignment.Left
    z.TextYAlignment = Enum.TextYAlignment.Center
    z.Visible = true
    z.ZIndex = 20
    z.Parent = a
    a = Instance.new("TextButton")
    a.Size = UDim2.new(0, 28, 0, 28)
    a.Position = UDim2.new(1, -38, 0, 8)
    a.BackgroundColor3 = f.bgDark
    a.BorderSizePixel = 0
    a.Text = "-"
    a.TextColor3 = f.textMuted
    a.Font = Enum.Font.GothamBlack
    a.TextSize = 22
    a.ZIndex = 12
    a.Parent = o
    Y(a, 7)
    F(a, Color3.fromRGB(45, 45, 45), 1)
    o = Instance.new("Frame")
    o.Position = UDim2.new(0, 14, 0, R.headerH)
    o.Size = UDim2.new(1, -28, 0, 1)
    o.BackgroundColor3 = f.accent
    o.BackgroundTransparency = 0.7
    o.BorderSizePixel = 0
    o.ZIndex = 9
    o.Parent = c
    H = Instance.new("Frame")
    H.Name = "LeftPanel"
    H.Size = UDim2.new(0, 85, 1, -78)
    H.Position = UDim2.new(1, -85, 0, 68)
    H.BackgroundColor3 = f.bgDark
    H.BackgroundTransparency = 0.5
    H.BorderSizePixel = 0
    H.ZIndex = 5
    H.Parent = c
    Y(H, 12)
    H.Visible = false
    local W = Instance.new("Frame")
    W.Size = UDim2.new(1, -16, 0, R.categoryH + 8)
    W.Position = UDim2.new(0, 8, 1, -(R.categoryH + 12))
    W.BackgroundColor3 = f.bgDark
    W.BackgroundTransparency = 0.18
    W.BorderSizePixel = 0
    W.ZIndex = 12
    W.Parent = c
    Y(W, 11)
    F(W, f.divider, 1)
    o = Instance.new("UIListLayout", W)
    o.SortOrder = Enum.SortOrder.LayoutOrder
    o.FillDirection = Enum.FillDirection.Horizontal
    o.HorizontalAlignment = Enum.HorizontalAlignment.Center
    o.VerticalAlignment = Enum.VerticalAlignment.Center
    o.Padding = UDim.new(0, p and 2 or 4)
    H = Instance.new("UIPadding", W)
    H.PaddingLeft = UDim.new(0, 4)
    H.PaddingRight = UDim.new(0, 4)
    H.PaddingTop = UDim.new(0, 4)
    H.PaddingBottom = UDim.new(0, 4)
    local w = Instance.new("Frame")
    w.Name = "ContentFrame"
    w.Size = UDim2.new(1, -12, 1, -(R.headerH + R.categoryH + 24))
    w.Position = UDim2.new(0, 6, 0, R.headerH + 6)
    w.BackgroundTransparency = 1
    w.ClipsDescendants = true
    w.ZIndex = 4
    w.Parent = c
    local function r(B)
      B:SetAttribute("AkatsukiKeepBlackText", true)
      B.TextStrokeTransparency = 1
      return B
    end
    for B, B in ipairs(c:GetDescendants()) do
      if B:IsA("TextLabel") or (B:IsA("TextButton")) or (B:IsA("TextBox")) then
        r(B)
      end
    end
    a.TextColor3 = f.textMuted
    local c = {}
    z.TextColor3 = f.accent
    z.TextTransparency = 0
    local function B(t)
      local v = Instance.new("ScrollingFrame")
      v.Name = t .. "Page"
      v.Size = UDim2.new(1, 0, 1, 0)
      v.BackgroundTransparency = 1
      v.BorderSizePixel = 0
      v.ScrollBarThickness = 2
      v.ScrollBarImageColor3 = f.accent
      v.ScrollBarImageTransparency = 0.28
      v.ElasticBehavior = Enum.ElasticBehavior.Always
      v.ScrollingDirection = Enum.ScrollingDirection.Y
      v.AutomaticCanvasSize = Enum.AutomaticSize.Y
      v.CanvasSize = UDim2.new(0, 0, 0, 0)
      v.Visible = t == "Movement"
      v.ZIndex = 5
      v.Parent = w
      local w = Instance.new("UIScale")
      w.Name = "PageTransitionScale"
      w.Scale = 1
      w.Parent = v
      c[t] = w
      w = Instance.new("UIListLayout", v)
      w.SortOrder = Enum.SortOrder.LayoutOrder
      w.Padding = UDim.new(0, R.pageGap)
      w = Instance.new("UIPadding", v)
      w.PaddingLeft = UDim.new(0, 4)
      w.PaddingRight = UDim.new(0, 4)
      w.PaddingTop = UDim.new(0, p and 4 or 6)
      w.PaddingBottom = UDim.new(0, p and 4 or 6)
      return v
    end
    local w = {
      Movement = B("Movement"),
      Combat = B("Combat"),
      Visual = B("Visual"),
      Animations = B("Animations"),
      Keybinds = B("Keybinds"),
    }
    local function t(v, nN)
      if y[v] == true == nN then
        return
      end
      local QN = FeatureToggles[v]
      if QN then
        pcall(QN)
      end
      if y[v] ~= nN then
        y[v] = nN
        QN = T[v]
        if QN then
          pcall(QN, nN)
        end
      end
      nN = M[v]
      if nN then
        pcall(nN)
      end
      pcall(oN)
    end
    local function v(nN, QN)
      if l then
        l.Text = "-"
      end
      l, N = nN, QN
      nN.Text = "..."
    end
    local function nN(QN, uN, pN)
      local _N = Instance.new("Frame")
      _N.Size = UDim2.new(1, 0, 0, R.sectionH)
      _N.BackgroundColor3 = f.bgDark
      _N.BackgroundTransparency = 0.28
      _N.BorderSizePixel = 0
      _N.LayoutOrder = pN
      _N.Parent = QN
      Y(_N, 8)
      F(_N, f.divider, 1)
      QN = Instance.new("Frame")
      QN.Name = "SectionAccent"
      QN.Size = UDim2.new(0, 3, 0, p and 12 or 16)
      QN.Position = UDim2.new(0, 6, 0.5, p and -6 or -8)
      QN.BackgroundColor3 = f.accent
      QN.BackgroundTransparency = 0.2
      QN.BorderSizePixel = 0
      QN.Parent = _N
      Y(QN, 2)
      QN = r(Instance.new("TextLabel"))
      QN.Size = UDim2.new(0.58, -16, 1, 0)
      QN.Position = UDim2.new(0, 15, 0, 0)
      QN.BackgroundTransparency = 1
      QN.Text = uN
      QN.TextColor3 = f.textDim
      QN.TextSize = p and 8 or 10
      QN.Font = Enum.Font.GothamBold
      QN.TextXAlignment = Enum.TextXAlignment.Left
      QN.Parent = _N
      pN = Instance.new("Frame")
      pN.Name = "SectionLine"
      pN.Size = UDim2.new(0.42, -14, 0, 1)
      pN.Position = UDim2.new(0.58, 4, 0.5, 0)
      pN.BackgroundColor3 = f.textMuted
      pN.BackgroundTransparency = 0.35
      pN.BorderSizePixel = 0
      pN.Parent = _N
    end
    local function QN(uN, pN, _N)
      local UN = r(Instance.new("TextButton"))
      UN.Name = "ModeKeybind"
      UN.Size = UDim2.fromOffset(p and 38 or 44, p and 16 or 20)
      UN.Position = _N
      UN.BackgroundColor3 = f.accentDim
      UN.BackgroundTransparency = 0.25
      UN.BorderSizePixel = 0
      UN.TextColor3 = f.text
      UN.TextSize = p and 8 or 9
      UN.Font = Enum.Font.GothamBold
      UN.Text = E[pN] and (zN(E[pN])) or "-"
      UN.ZIndex = 8
      UN.Parent = uN
      Y(UN, 5)
      F(UN, Color3.fromRGB(55, 55, 60), 1)
      UN.MouseButton1Click:Connect(function()
        v(UN, pN)
      end)
      table.insert(m, UN)
      local uN = M[pN]
      M[pN] = function()
        if uN then
          pcall(uN)
        end
        local uN = E[pN]
        UN.Text = uN and (zN(uN)) or "-"
        UN.BackgroundColor3 = f.accentDim
        UN.BackgroundTransparency = 0.25
        UN.TextColor3 = f.text
      end
      return UN
    end
    local function uN(pN, _N, UN, yN, HN, aN)
      local hN = Instance.new("Frame")
      hN.Size = UDim2.new(1, 0, 0, R.inputH)
      hN.BackgroundColor3 = f.row
      hN.BackgroundTransparency = 0.5
      hN.BorderSizePixel = 0
      hN.LayoutOrder = yN
      hN.Parent = pN
      Y(hN, 10)
      F(hN, f.divider, 1)
      pN = r(Instance.new("TextLabel"))
      pN.Size = aN and (UDim2.new(1, p and -116 or -142, 1, 0)) or (UDim2.new(0.65, 0, 1, 0))
      pN.Position = UDim2.new(0, p and 8 or 12, 0, 0)
      pN.BackgroundTransparency = 1
      pN.Text = _N
      pN.TextColor3 = f.text
      pN.TextSize = R.textSize
      pN.Font = Enum.Font.GothamBold
      pN.TextXAlignment = Enum.TextXAlignment.Left
      pN.Parent = hN
      if aN then
        QN(hN, aN, UDim2.new(1, p and -94 or -116, 0.5, p and -8 or -10))
      end
      aN = Instance.new("Frame")
      aN.Size = UDim2.new(0, p and 44 or 54, 0, p and 18 or 22)
      aN.Position = UDim2.new(1, p and -51 or -64, 0.5, p and -9 or -11)
      aN.BackgroundColor3 = f.row
      aN.BackgroundTransparency = 0.15
      aN.BorderSizePixel = 0
      aN.Parent = hN
      Y(aN, 6)
      F(aN, Color3.fromRGB(55, 55, 60), 1)
      local pN = r(Instance.new("TextBox"))
      pN.Size = UDim2.new(1, 0, 1, 0)
      pN.BackgroundTransparency = 1
      pN.Text = tostring(UN)
      pN.TextColor3 = f.text
      pN.TextSize = p and 9 or 11
      pN.Font = Enum.Font.GothamBold
      pN.ClearTextOnFocus = false
      pN.Parent = aN
      pN.FocusLost:Connect(function()
        local _N = tonumber(pN.Text)
        if _N then
          HN(_N)
          pN.Text = tostring(_N)
        else
          pN.Text = tostring(UN)
        end
      end)
    end
    local function pN(_N, UN, yN)
      local HN = Instance.new("Frame")
      HN.Name = "CustomSpeed_" .. UN.name
      HN.Size = UDim2.new(1, 0, 0, 58)
      HN.BackgroundColor3 = f.row
      HN.BackgroundTransparency = 0.5
      HN.BorderSizePixel = 0
      HN.LayoutOrder = yN
      HN.Parent = _N
      Y(HN, 10)
      F(HN, f.divider, 1)
      local yN = Instance.new("Frame")
      yN.Size = UDim2.new(0, 3, 0, 36)
      yN.Position = UDim2.new(0, 4, 0.5, -18)
      yN.BackgroundColor3 = f.accent
      yN.BorderSizePixel = 0
      yN.Parent = HN
      Y(yN, 2)
      _N = r(Instance.new("TextLabel"))
      _N.Size = UDim2.new(0, 126, 0, 20)
      _N.Position = UDim2.new(0, 12, 0, 4)
      _N.BackgroundColor3 = f.accent
      _N.BackgroundTransparency = 1
      _N.BorderSizePixel = 0
      _N.Text = UN.name
      _N.TextColor3 = f.text
      _N.TextSize = 11
      _N.Font = Enum.Font.GothamBold
      _N.TextXAlignment = Enum.TextXAlignment.Left
      _N.Parent = HN
      local _N = "SelectCustomMode_" .. UN.name
      QN(HN, _N, UDim2.new(0, 12, 0, 29))
      local function QN(aN, hN, fN, LN)
        local ON = r(Instance.new("TextLabel"))
        ON.Size = UDim2.fromOffset(54, 14)
        ON.Position = UDim2.fromOffset(fN, 5)
        ON.BackgroundTransparency = 1
        ON.Text = aN
        ON.TextColor3 = f.textMuted
        ON.TextSize = 8
        ON.Font = Enum.Font.GothamBold
        ON.TextXAlignment = Enum.TextXAlignment.Left
        ON.Parent = HN
        local aN = r(Instance.new("TextBox"))
        aN.Size = UDim2.fromOffset(54, 22)
        aN.Position = UDim2.fromOffset(fN, 24)
        aN.BackgroundColor3 = f.bgDark
        aN.BorderSizePixel = 0
        aN.Text = tostring(hN)
        aN.TextColor3 = f.text
        aN.TextSize = 10
        aN.Font = Enum.Font.GothamBold
        aN.ClearTextOnFocus = false
        aN.Parent = HN
        Y(aN, 5)
        F(aN, Color3.fromRGB(55, 55, 60), 1)
        aN.FocusLost:Connect(function()
          local fN = tonumber(aN.Text)
          if not fN then
            aN.Text = tostring(hN)
            return
          end
          fN = math.clamp(math.floor(fN + 0.5), 1, 200)
          hN = fN
          aN.Text = tostring(fN)
          LN(fN)
        end)
        return aN
      end
      QN("NORMAL", UN.boost, 158, function(aN)
        UN.boost = aN
        J["CustomBoost_" .. UN.name] = aN
        oN()
        pcall(function()
          if _G.__refreshSpeedBillboards then
            _G.__refreshSpeedBillboards()
          end
        end)
      end)
      QN("CARRY", UN.steal, 224, function(aN)
        UN.steal = aN
        J["CustomSteal_" .. UN.name] = aN
        oN()
        pcall(function()
          if _G.__refreshSpeedBillboards then
            _G.__refreshSpeedBillboards()
          end
        end)
      end)
      QN = r(Instance.new("TextButton"))
      QN.Size = UDim2.fromOffset(30, 24)
      QN.Position = UDim2.new(1, -40, 0.5, -12)
      QN.BackgroundColor3 = Color3.fromRGB(72, 34, 34)
      QN.BorderSizePixel = 0
      QN.Text = "X"
      QN.TextColor3 = Color3.fromRGB(255, 180, 180)
      QN.TextSize = 10
      QN.Font = Enum.Font.GothamBold
      QN.Parent = HN
      Y(QN, 5)
      local function aN()
        local hN = Z == UN.name
        HN.BackgroundTransparency = hN and 0.28 or 0.5
        yN.Visible = hN
      end
      QN.MouseButton1Click:Connect(function()
        for QN = #L, 1, -1 do
          if L[QN] == UN then
            table.remove(L, QN)
            break
          end
        end
        J["CustomBoost_" .. UN.name] = nil
        J["CustomSteal_" .. UN.name] = nil
        E[_N] = nil
        FeatureToggles[_N] = nil
        M[_N] = nil
        if Z == UN.name then
          JN("Normal")
        end
        HN:Destroy()
        oN()
      end)
      FeatureToggles[_N] = function()
        JN(UN.name)
      end
      table.insert(_speedCardRefs, { modeName = UN.name, updateVisual = aN })
      aN()
      return HN
    end
    local function QN(_N, UN, yN)
      local HN = Instance.new("Frame")
      HN.Name = "CustomSpeedForm"
      HN.Size = UDim2.new(1, 0, 0, 112)
      HN.BackgroundColor3 = f.row
      HN.BackgroundTransparency = 0.2
      HN.BorderSizePixel = 0
      HN.LayoutOrder = UN
      HN.Parent = _N
      Y(HN, 10)
      F(HN, f.divider, 1)
      local function _N(UN, aN, hN)
        local fN = r(Instance.new("TextLabel"))
        fN.Size = UDim2.fromOffset(hN, 14)
        fN.Position = UDim2.fromOffset(aN, 8)
        fN.BackgroundTransparency = 1
        fN.Text = UN
        fN.TextColor3 = f.textMuted
        fN.TextSize = 8
        fN.Font = Enum.Font.GothamBold
        fN.TextXAlignment = Enum.TextXAlignment.Left
        fN.Parent = HN
      end
      local function UN(aN, hN, fN)
        local LN = r(Instance.new("TextBox"))
        LN.Size = UDim2.fromOffset(fN, 24)
        LN.Position = UDim2.fromOffset(hN, 24)
        LN.BackgroundColor3 = f.bgDark
        LN.BorderSizePixel = 0
        LN.Text = aN
        LN.TextColor3 = f.text
        LN.TextSize = 10
        LN.Font = Enum.Font.GothamBold
        LN.ClearTextOnFocus = false
        LN.Parent = HN
        Y(LN, 5)
        F(LN, Color3.fromRGB(55, 55, 60), 1)
        return LN
      end
      _N("NAME", 12, 150)
      _N("NORMAL", 174, 70)
      _N("CARRY", 256, 70)
      local aN, hN, fN, LN =
        UN("Custom " .. tostring(#L + 1), 12, 150),
        UN("59", 174, 70),
        UN("29", 256, 70),
        r(Instance.new("TextLabel"))
      LN.Size = UDim2.new(1, -24, 0, 14)
      LN.Position = UDim2.new(0, 12, 1, -20)
      LN.BackgroundTransparency = 1
      LN.Text = ""
      LN.TextColor3 = Color3.fromRGB(255, 150, 150)
      LN.TextSize = 8
      LN.Font = Enum.Font.GothamBold
      LN.TextXAlignment = Enum.TextXAlignment.Left
      LN.Parent = HN
      _N = r(Instance.new("TextButton"))
      _N.Size = UDim2.new(1, -24, 0, 26)
      _N.Position = UDim2.new(0, 12, 0, 62)
      _N.BackgroundColor3 = f.accentDim
      _N.BorderSizePixel = 0
      _N.Text = "CREATE CUSTOM SPEED"
      _N.TextColor3 = f.text
      _N.TextSize = 10
      _N.Font = Enum.Font.GothamBold
      _N.Parent = HN
      Y(_N, 6)
      _N.MouseButton1Click:Connect(function()
        local _N, UN, ON = aN.Text:match("^%s*(.-)%s*$"), tonumber(hN.Text), tonumber(fN.Text)
        if not _N or #_N < 1 then
          LN.Text = "Escribe un nombre."
          return
        end
        if _N:find("[:,=]") then
          LN.Text = "El nombre no puede contener : , o =."
          return
        end
        if _N == "Normal" or _N == "Lagger" or _N == "Desync" then
          LN.Text = "Ese nombre esta reservado."
          return
        end
        for aN, aN in ipairs(L) do
          if aN.name == _N then
            LN.Text = "Ese nombre ya existe."
            return
          end
        end
        if not UN or UN < 1 or UN > 200 then
          LN.Text = "Normal: elige un valor entre 1 y 200."
          return
        end
        if not ON or ON < 1 or ON > 200 then
          LN.Text = "Carry: elige un valor entre 1 y 200."
          return
        end
        local aN = { name = _N, boost = math.floor(UN + 0.5), steal = math.floor(ON + 0.5) }
        table.insert(L, aN)
        J["CustomBoost_" .. _N] = aN.boost
        J["CustomSteal_" .. _N] = aN.steal
        oN()
        HN:Destroy()
        yN(aN)
      end)
      return HN
    end
    local function _N(UN, yN, HN, aN, hN, fN, LN, ON)
      local iN = Instance.new("Frame")
      iN:SetAttribute("AkatsukiButtonThemeControl", true)
      iN.Size = UDim2.new(1, 0, 0, fN and R.toggleBindH or R.toggleH)
      iN.BackgroundColor3 = f.row
      iN.BackgroundTransparency = 0.5
      iN.BorderSizePixel = 0
      iN.LayoutOrder = hN
      iN.Parent = UN
      Y(iN, 10)
      F(iN, f.divider, 1)
      local hN = Instance.new("UIScale", iN)
      hN.Scale = 1
      local SN = r(Instance.new("TextLabel"))
      SN.Size = UDim2.new(1, p and -62 or -72, 0, fN and (p and 16 or 20) or R.toggleH)
      SN.Position = UDim2.new(0, p and 50 or 58, 0, fN and (p and 2 or 3) or 0)
      SN.BackgroundTransparency = 1
      SN.Text = yN
      SN.TextColor3 = f.text
      SN.TextSize = R.textSize
      SN.Font = Enum.Font.GothamBold
      SN.TextXAlignment = Enum.TextXAlignment.Left
      SN.Parent = iN
      local yN = r(Instance.new("TextButton"))
      yN.Name = "ActiveMarker"
      yN.Size = UDim2.fromOffset(p and 34 or 38, p and 18 or 20)
      yN.Position = UDim2.new(0, p and 8 or 10, 0.5, p and -9 or -10)
      yN.BackgroundColor3 = f.bgDark
      yN.BackgroundTransparency = 0.08
      yN.BorderSizePixel = 0
      yN.Text = ""
      yN.TextColor3 = f.bgDark
      yN.TextSize = p and 12 or 14
      yN.Font = Enum.Font.GothamBold
      yN.AutoButtonColor = false
      yN.ZIndex = 9
      yN.Parent = iN
      Y(yN, 999)
      F(yN, f.textDim, 1)
      local ZN = Instance.new("Frame")
      ZN.Name = "ToggleKnob"
      local YN = p and 12 or 14
      ZN.Size = UDim2.fromOffset(YN, YN)
      ZN.AnchorPoint = Vector2.new(0, 0.5)
      ZN.Position = UDim2.new(0, 3, 0.5, 0)
      ZN.BackgroundColor3 = f.text
      ZN.BorderSizePixel = 0
      ZN.ZIndex = 10
      ZN.Parent = yN
      Y(ZN, 999)
      local jN = ON or HN
      if fN and jN then
        local fN = r(Instance.new("TextButton"))
        fN.Size = UDim2.new(0, p and 36 or 42, 0, p and 14 or 17)
        fN.Position = UDim2.new(0, p and 8 or 12, 1, p and -17 or -21)
        fN.BackgroundColor3 = f.accentDim
        fN.BackgroundTransparency = 0.35
        fN.BorderSizePixel = 0
        UN = E[jN]
        fN.Text = UN and (zN(UN)) or "-"
        fN.TextColor3 = f.text
        fN.TextSize = p and 8 or 9
        fN.Font = Enum.Font.GothamBold
        fN.Parent = iN
        Y(fN, 5)
        fN.MouseButton1Click:Connect(function()
          v(fN, jN)
        end)
        table.insert(m, fN)
      end
      local UN, fN = aN == true, false
      local function aN(ON)
        UN = ON == true
        local ON, jN = UN and (Color3.fromRGB(28, 28, 30)) or f.row, UN and 0.22 or 0.5
        SN.TextColor3 = f.text
        local SN, eN =
          UN and (UDim2.new(1, -YN - 3, 0.5, 0)) or (UDim2.new(0, 3, 0.5, 0)),
          UN and f.bgDark or f.text
        if fN then
          d(iN, { BackgroundColor3 = ON, BackgroundTransparency = jN }, 0.18)
          d(yN, {
            BackgroundColor3 = UN and f.accent or f.bgDark,
            BackgroundTransparency = UN and 0.02 or 0.08,
          }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
          d(
            ZN,
            { Position = SN, BackgroundColor3 = eN },
            0.2,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
          )
        else
          iN.BackgroundColor3 = ON
          iN.BackgroundTransparency = jN
          yN.BackgroundColor3 = UN and f.accent or f.bgDark
          yN.BackgroundTransparency = UN and 0.02 or 0.08
          ZN.Position = SN
          ZN.BackgroundColor3 = eN
          fN = true
        end
      end
      aN(UN)
      yN.MouseButton1Click:Connect(function()
        hN.Scale = 0.985
        d(hN, { Scale = 1 }, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local yN = not UN
        LN(yN)
        aN(HN and y[HN] == true or yN)
      end)
      if HN then
        local UN = M[HN]
        M[HN] = function()
          if UN then
            pcall(UN)
          end
          aN(y[HN] == true)
        end
      end
      return aN, iN
    end
    local function UN(yN, HN, aN)
      local hN = r(Instance.new("TextButton"))
      hN.Size = UDim2.new(0, p and 46 or 56, 0, p and 16 or 20)
      hN.Position = UDim2.new(1, p and -54 or -68, 0.5, p and -8 or -10)
      hN.BackgroundColor3 = f.accentDim
      hN.BackgroundTransparency = 0.25
      hN.BorderSizePixel = 0
      hN.Text = HN
      hN.TextColor3 = f.text
      hN.TextSize = p and 8 or 9
      hN.Font = Enum.Font.GothamBold
      hN.ZIndex = 8
      hN.Parent = yN
      Y(hN, 5)
      F(hN, Color3.fromRGB(45, 45, 45), 1)
      local yN = Instance.new("UIScale", hN)
      yN.Scale = 1
      hN.MouseButton1Click:Connect(function()
        yN.Scale = 0.92
        d(yN, { Scale = 1 }, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local yN = aN()
        if yN then
          hN.Text = tostring(yN)
        end
      end)
      return hN
    end
    local function yN(HN, aN, hN, fN, LN, ON)
      hN = Instance.new("Frame")
      hN:SetAttribute("AkatsukiButtonThemeControl", true)
      hN.Size = UDim2.new(1, 0, 0, R.actionH)
      hN.BackgroundColor3 = f.row
      hN.BackgroundTransparency = 0.5
      hN.BorderSizePixel = 0
      hN.LayoutOrder = fN
      hN.Parent = HN
      Y(hN, 10)
      F(hN, f.divider, 1)
      local HN = Instance.new("UIScale", hN)
      HN.Scale = 1
      fN = r(Instance.new(ON == false and "TextLabel" or "TextButton"))
      fN.Size = UDim2.new(1, -24, 1, 0)
      fN.Position = UDim2.new(0, p and 8 or 12, 0, 0)
      fN.BackgroundTransparency = 1
      fN.Text = aN
      fN.TextColor3 = f.text
      fN.TextSize = R.textSize
      fN.Font = Enum.Font.GothamBold
      fN.TextXAlignment = Enum.TextXAlignment.Left
      fN.Parent = hN
      if ON ~= false then
        fN.Name = "ActionButton"
        fN.AutoButtonColor = false
        fN.MouseButton1Click:Connect(function()
          HN.Scale = 0.985
          d(HN, { Scale = 1 }, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
          LN()
        end)
      end
      return hN
    end
    local HN = w.Movement
    nN(HN, "SPEED CONFIGURATION", 0)
    uN(HN, "Normal Speed", J.NormalBoost, 1, function(aN)
      J.NormalBoost = math.max(1, math.floor(aN))
      j = J.NormalBoost
      oN()
    end, "SelectNormalMode")
    uN(HN, "Carry Speed", J.NormalSteal, 2, function(j)
      J.NormalSteal = math.max(1, math.floor(j))
      e = J.NormalSteal
      oN()
    end, "Carry Speed")
    nN(HN, "LAGGER SPEED", 3)
    uN(HN, "Lagger Normal", J.LaggerBoost, 4, function(j)
      J.LaggerBoost = math.max(1, math.floor(j))
      q = J.LaggerBoost
      oN()
    end, "SelectLaggerMode")
    uN(HN, "Lagger Carry", J.LaggerSteal, 5, function(j)
      J.LaggerSteal = math.max(1, math.floor(j))
      oN()
    end)
    nN(HN, "CUSTOM SPEEDS", 6)
    local j = {}
    local function e(q)
      local aN = pN(HN, q, 10 + #j)
      table.insert(j, aN)
      return aN
    end
    for j, j in ipairs(L) do
      e(j)
    end
    H = r(Instance.new("TextButton"))
    H.Size = UDim2.new(1, 0, 0, 38)
    H.BackgroundColor3 = f.row
    H.BackgroundTransparency = 0.3
    H.BorderSizePixel = 0
    H.LayoutOrder = 50
    H.Text = "+  ADD CUSTOM SPEED"
    H.TextColor3 = f.text
    H.TextSize = 10
    H.Font = Enum.Font.GothamBold
    H.Parent = HN
    Y(H, 10)
    F(H, f.divider, 1)
    local L
    H.MouseButton1Click:Connect(function()
      if L and L.Parent then
        L:Destroy()
        L = nil
        return
      end
      L = QN(HN, 51, function(j)
        L = nil
        e(j)
        JN(j.name)
      end)
    end)
    nN(HN, "CONTROLS", 60)
    B, o = _N(HN, "Auto Play", "Autoplay", y.Autoplay, 61, false, function(L)
      t("Autoplay", L)
    end)
    UN(o, string.upper(_G.__autoplayMode or "Full"), function()
      _G.__autoplayMode = _G.__autoplayMode == "Semi" and "Full" or "Semi"
      oN()
      return string.upper(_G.__autoplayMode)
    end)
    _N(HN, "Auto Carry Speed", "Auto Carry Speed", y["Auto Carry Speed"], 62, false, function(L)
      t("Auto Carry Speed", L)
    end)
    z, o = _N(HN, "Carry Mode", "Carry Speed", y["Carry Speed"], 63, false, function(z)
      t("Carry Speed", z)
    end)
    UN(o, string.upper(G or "v1"), function()
      G = G == "v1" and "v2" or "v1"
      oN()
      return string.upper(G)
    end)
    nN(HN, "MOVEMENT SETTINGS", 70)
    H, o = _N(HN, "Infinite Jump", "Inf Jump", y["Inf Jump"], 71, false, function(z)
      t("Inf Jump", z)
    end)
    UN(o, string.upper(_G.__AkatsukiInfJumpMode or "hold"), function()
      _G.__AkatsukiInfJumpMode = (_G.__AkatsukiInfJumpMode or "hold") == "hold" and "manual"
        or "hold"
      if y["Inf Jump"] then
        if _G.__AkatsukiInfJumpMode == "hold" and startInfJump then
          pcall(startInfJump)
        elseif stopInfJump then
          pcall(stopInfJump)
        end
      end
      oN()
      return string.upper(_G.__AkatsukiInfJumpMode)
    end)
    _N(HN, "Unwalk", "Unwalk", y.Unwalk, 72, false, function(z)
      t("Unwalk", z)
    end)
    nN(HN, "TP DOWN", 73)
    _N(HN, "Auto TP Down", "Auto TP Down", y["Auto TP Down"], 75, false, function(z)
      t("Auto TP Down", z)
    end)
    uN(HN, "Height (studs)", J.AutoTPDownHeight, 76, function(z)
      J.AutoTPDownHeight = math.clamp(math.floor(z + 0.5), 1, 1000)
      oN()
    end)
    o = w.Combat
    nN(o, "BAT CONTROLS", 0)
    _N(o, "Bat Aimbot", "Aimbot", y.Aimbot, 1, false, function(z)
      t("Aimbot", z)
    end)
    _N(o, "Lagger Aimbot", "Lagger Aimbot", y["Lagger Aimbot"], 2, false, function(z)
      t("Lagger Aimbot", z)
    end)
    _N(o, "Anti Bat", "Anti Bat", y["Anti Bat"], 3, false, function(z)
      t("Anti Bat", z)
    end)
    _N(o, "Ragdoll Counter", "Ragdoll Counter", y["Ragdoll Counter"], 4, false, function(z)
      t("Ragdoll Counter", z)
    end)
    nN(o, "RAGDOLL", 5)
    _N(o, "Anti Ragdoll", "Anti Ragdoll", y["Anti Ragdoll"], 6, false, function(z)
      t("Anti Ragdoll", z)
    end)
    _N(o, "Medusa Counter", "Medusa Counter", y["Medusa Counter"], 7, false, function(z)
      t("Medusa Counter", z)
    end)
    _N(o, "Anti Die", "Anti Die", y["Anti Die"], 8, false, function(z)
      t("Anti Die", z)
    end)
    nN(o, "TP BAT", 9)
    local z, z = _N(o, "TP Bat", "TP Bat", y["TP Bat"], 10, false, function(H)
      t("TP Bat", H)
    end)
    z.ClipsDescendants = true
    local H = r(Instance.new("TextButton"))
    H.Name = "TPBatConfigToggle"
    H.Size = UDim2.new(0, p and 52 or 64, 0, p and 18 or 22)
    H.Position = UDim2.new(1, p and -60 or -76, 0, p and 5 or 7)
    H.BackgroundColor3 = f.accentDim
    H.BackgroundTransparency = 0.2
    H.BorderSizePixel = 0
    H.Text = ""
    H.AutoButtonColor = false
    H.ZIndex = 12
    H.Parent = z
    Y(H, 6)
    F(H, Color3.fromRGB(70, 75, 84), 1)
    local L = r(Instance.new("TextLabel"))
    L.Size = UDim2.new(0, 30, 1, 0)
    L.Position = UDim2.new(0, 5, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = "GUI"
    L.TextColor3 = f.text
    L.TextSize = 8
    L.Font = Enum.Font.GothamBold
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = 13
    L.Parent = H
    local j = Instance.new("Frame")
    j.Size = UDim2.new(0, 24, 0, 12)
    j.Position = UDim2.new(1, -29, 0.5, -6)
    j.BackgroundColor3 = Color3.fromRGB(30, 31, 35)
    j.BorderSizePixel = 0
    j.ZIndex = 13
    j.Parent = H
    Y(j, 20)
    local e = Instance.new("Frame")
    e.Size = UDim2.new(0, 8, 0, 8)
    e.Position = UDim2.new(0, 2, 0.5, -4)
    e.BackgroundColor3 = Color3.fromRGB(170, 170, 176)
    e.BorderSizePixel = 0
    e.ZIndex = 14
    e.Parent = j
    Y(e, 20)
    local q = Instance.new("Frame")
    q.Name = "TPBatConfigPanel"
    q.Size = UDim2.new(1, -16, 0, 78)
    q.Position = UDim2.new(0, 8, 0, p and 42 or 54)
    q.BackgroundColor3 = f.bgDark
    q.BackgroundTransparency = 0.16
    q.BorderSizePixel = 0
    q.Visible = false
    q.ZIndex = 8
    q.Parent = z
    Y(q, 8)
    F(q, f.divider, 1)
    local function G(B, QN)
      local pN = r(Instance.new("TextLabel"))
      pN.Size = UDim2.new(1, -100, 0, 34)
      pN.Position = UDim2.new(0, 10, 0, QN)
      pN.BackgroundTransparency = 1
      pN.Text = B
      pN.TextColor3 = f.textMuted
      pN.TextSize = 9
      pN.Font = Enum.Font.GothamBold
      pN.TextXAlignment = Enum.TextXAlignment.Left
      pN.ZIndex = 9
      pN.Parent = q
      return pN
    end
    G("DISTANCIA TP (STUDS)", 2)
    G("VERSION TP BAT", 40)
    local B = r(Instance.new("TextBox"))
    B.Size = UDim2.new(0, 72, 0, 26)
    B.Position = UDim2.new(1, -82, 0, 6)
    B.BackgroundColor3 = f.row
    B.BorderSizePixel = 0
    B.ClearTextOnFocus = false
    B.Text = tostring(_G.__tpBatV2Distance or 8)
    B.TextColor3 = f.text
    B.TextSize = 10
    B.Font = Enum.Font.GothamBold
    B.TextXAlignment = Enum.TextXAlignment.Center
    B.ZIndex = 10
    B.Parent = q
    Y(B, 5)
    F(B, Color3.fromRGB(72, 58, 62), 1)
    local QN = r(Instance.new("TextButton"))
    QN.Size = UDim2.new(0, 72, 0, 26)
    QN.Position = UDim2.new(1, -82, 0, 44)
    QN.BackgroundColor3 = f.accentDim
    QN.BorderSizePixel = 0
    QN.TextColor3 = f.text
    QN.TextSize = 10
    QN.Font = Enum.Font.GothamBold
    QN.ZIndex = 10
    QN.Parent = q
    QN.Visible = true
    Y(QN, 5)
    F(QN, Color3.fromRGB(72, 58, 62), 1)
    local function pN()
      _G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
      QN.Text = "V" .. tostring(_G.__batVersion or 1)
      QN.BackgroundColor3 = f.accentDim
      B.TextEditable = true
      B.Text = tostring(_G.__tpBatV2Distance or 8)
      B.BackgroundTransparency = 0
      B.TextColor3 = f.text
    end
    _.refreshVisibleConfig = pN
    pN()
    local HN = false
    local function aN(hN)
      HN = hN == true
      q.Visible = HN
      z.Size = UDim2.new(1, 0, 0, HN and (p and 124 or 140) or R.toggleH)
      H.BackgroundColor3 = HN and f.accent or f.accentDim
      j.BackgroundColor3 = HN and f.accent or (Color3.fromRGB(30, 31, 35))
      e.BackgroundColor3 = HN and (Color3.fromRGB(245, 248, 255)) or (Color3.fromRGB(170, 170, 176))
      e.Position = HN and (UDim2.new(1, -10, 0.5, -4)) or (UDim2.new(0, 2, 0.5, -4))
    end
    H.MouseButton1Click:Connect(function()
      aN(not HN)
    end)
    B.FocusLost:Connect(function()
      _.controller.SetV2Distance(B.Text)
    end)
    QN.MouseButton1Click:Connect(function()
      _.controller.SetVersion(_G.__batVersion == 1 and 2 or 1)
      pN()
    end)
    nN(o, "AUTO STEAL", 15)
    G, L = _N(o, "Auto Steal", "auto steal", y["auto steal"], 16, false, function(z)
      t("auto steal", z)
    end)
    UN(L, string.upper(i), function()
      i = i == "v2" and "v1" or "v2"
      if y["auto steal"] and T["auto steal"] then
        pcall(T["auto steal"], false)
        pcall(T["auto steal"], true)
      end
      oN()
      return string.upper(i)
    end)
    uN(o, "Steal Radius", O.Radius, 17, function(z)
      O.Radius = math.clamp(math.floor(z), 10, 150)
      oN()
    end)
    local z = w.Visual
    nN(z, "VISUAL", -2)
    _N(z, "anti lag", "Anti Lag", y["Anti Lag"], -1, false, function(_)
      t("Anti Lag", _)
    end)
    _N(z, "ESP Players", "ESP Players", y["ESP Players"], 1, false, function(_)
      t("ESP Players", _)
    end)
    _N(z, "ESP Line", "Player Tracers", y["Player Tracers"], 2, false, function(_)
      t("Player Tracers", _)
    end)
    _N(z, "Optimizer", "Optimizer", y.Optimizer, 3, false, function(_)
      t("Optimizer", _)
    end)
    _N(z, "Stretch Rez", "Stretchz Res", y["Stretchz Res"], 4, false, function(_)
      t("Stretchz Res", _)
    end)
    nN(z, "FOV", 5)
    _N(z, "Custom FOV", "Custom FOV", y["Custom FOV"], 6, false, function(_)
      t("Custom FOV", _)
    end)
    uN(z, "FOV", J.FOV, 7, function(_)
      J.FOV = math.clamp(math.floor(_), 30, 120)
      t("Custom FOV", true)
      if T["Custom FOV"] then
        pcall(T["Custom FOV"], true)
      end
      _ = workspace.CurrentCamera
      if _ then
        _.FieldOfView = J.FOV
      end
      oN()
    end)
    nN(z, "SKY", 8)
    L, o = _N(z, "Sky Themes", "Sky Changer", y["Sky Changer"], 9, false, function(_)
      t("Sky Changer", _)
    end)
    UN(o, string.upper(I or "blue"), function()
      I = if I == "day" then "blue" else if I == "blue" then "night" else "day"
      _G.__AkatsukiSkyChangerMode = I
      if y["Sky Changer"] then
        U(I)
      end
      oN()
      return string.upper(I)
    end)
    nN(z, "SKIN CHANGER", 10)
    do
      local _ = {}
      _.update, _.row = _N(
        z,
        "Skin Changer",
        "Skin Changer",
        y["Skin Changer"],
        11,
        false,
        function(U)
          t("Skin Changer", U)
        end
      )
      _.button = UN(_.row, S, function()
        S = S == "V1" and "V2" or (S == "V2" and "V3" or "V1")
        oN()
        if y["Skin Changer"] then
          T["Skin Changer"](true)
        end
        return S
      end)
      _.refresh = function()
        _.update(y["Skin Changer"] == true)
        _.button.Text = S
      end
      M["Skin Changer"] = _.refresh
      _.refresh()
    end
    uN = {
      add = function(_, U, H)
        local J = {}
        J.update, J.row = _N(z, _, U, y[U], H, false, function(_)
          t(U, _)
        end)
        J.refresh = function()
          J.update(y[U] == true)
        end
        M[U] = J.refresh
        J.refresh()
      end,
    }
    uN.add("Headless", "Headless Visual", 12)
    uN.add("Korblox", "Korblox Visual", 13)
    nN(z, "GUI", 14)
    _N(z, "Quick Buttons", "Show Buttons", y["Show Buttons"], 16, false, function(_)
      t("Show Buttons", _)
    end)
    do
      local _, U =
        yN(z, "Buttons Size", nil, 16.5, function() end, false), r(Instance.new("TextBox"))
      U.Name = "ButtonsSizeInput"
      U.Size = UDim2.fromOffset(64, p and 22 or 26)
      U.AnchorPoint = Vector2.new(1, 0.5)
      U.Position = UDim2.new(1, -10, 0.5, 0)
      U.BackgroundColor3 = f.accentDim
      U.BorderSizePixel = 0
      U.TextColor3 = f.text
      U.Font = Enum.Font.GothamBold
      U.TextSize = 12
      U.Text = tostring(_G.__AkatsukiButtonsSize or 1)
      U.PlaceholderText = "0.5 - 2"
      U.ClearTextOnFocus = false
      U.ZIndex = 8
      U.Parent = _
      Y(U, 5)
      U.FocusLost:Connect(function()
        U.Text = tostring(_G.__AkatsukiSetButtonsSize(U.Text))
      end)
    end
    yN(z, "reset butons pos.", nil, 17, function()
      _G.__AkatsukiResetButtonPositions()
      if _G.AkatsukiLagger and _G.AkatsukiLagger.ResetPosition then
        _G.AkatsukiLagger.ResetPosition()
      end
      if _G.AkatsukiBypass and _G.AkatsukiBypass.ResetPosition then
        _G.AkatsukiBypass.ResetPosition()
      end
    end)
    _N(z, "Lock Buttons", "Lock Buttons", y["Lock Buttons"], 18, false, function(_)
      t("Lock Buttons", _)
    end)
    yN(z, "Hide GUI Key", "Toggle UI", 19, function()
      g.Visible = false
    end)
    nN(z, "PANELS", 20)
    yN(z, "Open Lagger", nil, 21, function()
      local _ = u:FindFirstChild("PlayerGui") and (u.PlayerGui:FindFirstChild("AkatsukiLaggerGUI"))
      local U = _ and (_:FindFirstChild("MainFrame"))
      if U then
        _ = not U.Visible
        if _G.AkatsukiLagger and _G.AkatsukiLagger.SetVisible then
          pcall(_G.AkatsukiLagger.SetVisible, _)
        else
          U.Visible = _
        end
      elseif _G.__openLaggerGUI then
        pcall(_G.__openLaggerGUI, true)
      end
    end)
    yN(z, "Open Bypass", nil, 22, function()
      local z = u:FindFirstChild("PlayerGui") and (u.PlayerGui:FindFirstChild("AkatsukiBypassGUI"))
      local _ = z and (z:FindFirstChild("MainFrame"))
      if _ then
        z = not _.Visible
        if _G.AkatsukiBypass and _G.AkatsukiBypass.SetVisible then
          pcall(_G.AkatsukiBypass.SetVisible, z)
        else
          _.Visible = z
        end
      elseif _G.__openBypassGUI then
        pcall(_G.__openBypassGUI, true)
      end
    end)
    yN = w.Animations
    nN(yN, "ANIMATION SOURCE", 0)
    local z = _G.__AkatsukiAnimationPreset
    if not z or not Q[z] then
      z = x or n[1]
    end
    uN = Instance.new("Frame")
    uN.Size = UDim2.new(1, 0, 0, 42)
    uN.BackgroundColor3 = f.row
    uN.BackgroundTransparency = 0.5
    uN.BorderSizePixel = 0
    uN.LayoutOrder = 1
    uN.Parent = yN
    Y(uN, 10)
    F(uN, f.divider, 1)
    o = r(Instance.new("TextButton"))
    o.Size = UDim2.new(0, 42, 1, -8)
    o.Position = UDim2.new(0, 4, 0, 4)
    o.BackgroundColor3 = f.accentDim
    o.BackgroundTransparency = 0.2
    o.BorderSizePixel = 0
    o.Text = "<"
    o.TextColor3 = f.text
    o.TextSize = 18
    o.Font = Enum.Font.GothamBlack
    o.Parent = uN
    Y(o, 7)
    local _ = r(Instance.new("TextLabel"))
    _.Size = UDim2.new(1, -100, 1, 0)
    _.Position = UDim2.new(0, 50, 0, 0)
    _.BackgroundTransparency = 1
    _.TextColor3 = f.text
    _.TextSize = 10
    _.TextWrapped = true
    _.Font = Enum.Font.GothamBold
    _.Parent = uN
    local U = r(Instance.new("TextButton"))
    U.Size = UDim2.new(0, 42, 1, -8)
    U.Position = UDim2.new(1, -46, 0, 4)
    U.BackgroundColor3 = f.accentDim
    U.BackgroundTransparency = 0.2
    U.BorderSizePixel = 0
    U.Text = ">"
    U.TextColor3 = f.text
    U.TextSize = 18
    U.Font = Enum.Font.GothamBlack
    U.Parent = uN
    Y(U, 7)
    local function H()
      _.Text = tostring(z)
    end
    local function _(J)
      local L = 1
      for O, i in ipairs(n) do
        if i == z then
          L = O
          break
        end
      end
      L += J
      z = n[if (if L < 1 then #n else L) > #n then 1 else if L < 1 then #n else L]
      H()
      _G.__AkatsukiAnimationPreset = z
      if y.Animaciones then
        T.Animaciones(true)
      else
        t("Animaciones", true)
      end
      pcall(oN)
    end
    o.MouseButton1Click:Connect(function()
      _(-1)
    end)
    U.MouseButton1Click:Connect(function()
      _(1)
    end)
    H()
    local function n(o)
      if type(o) == "number" then
        return "rbxassetid://" .. tostring(o)
      end
      if type(o) == "string" and (string.match(o, "^%d+$")) then
        return "rbxassetid://" .. o
      end
      return o
    end
    local o = _G.__AkatsukiOriginalAnimations
    if type(o) ~= "table" then
      o = setmetatable({}, { __mode = "k" })
      _G.__AkatsukiOriginalAnimations = o
    end
    local function _(U, H, J)
      J = J or {}
      if next(J) == nil then
        for L, O in pairs(H) do
          if O then
            J[L] = O.AnimationId
          end
        end
      end
      local L = U:FindFirstChildOfClass("Humanoid")
      local U, O = pcall(function()
        return L and (L:GetAppliedDescription())
      end)
      if U and O then
        local function U(L, i)
          local S = tonumber(O[i])
          if S and S > 0 and H[L] then
            J[L] = "rbxassetid://" .. tostring(S)
          end
        end
        U("idle1", "IdleAnimation")
        U("idle2", "IdleAnimation")
        U("walk", "WalkAnimation")
        U("run", "RunAnimation")
        U("jump", "JumpAnimation")
        U("fall", "FallAnimation")
        U("climb", "ClimbAnimation")
        U("swim", "SwimAnimation")
        U("swimidle", "SwimAnimation")
      end
      return J
    end
    local function U(H, J)
      local L = u.Character
      local O = L and (L:FindFirstChild("Animate") or (L:WaitForChild("Animate", 3)))
      if not O then
        return false
      end
      local i = {
        idle1 = O:FindFirstChild("idle") and (O.idle:FindFirstChild("Animation1")),
        idle2 = O:FindFirstChild("idle") and (O.idle:FindFirstChild("Animation2")),
        walk = O:FindFirstChild("walk") and (O.walk:FindFirstChild("WalkAnim")),
        run = O:FindFirstChild("run") and (O.run:FindFirstChild("RunAnim")),
        jump = O:FindFirstChild("jump") and (O.jump:FindFirstChild("JumpAnim")),
        fall = O:FindFirstChild("fall") and (O.fall:FindFirstChild("FallAnim")),
        climb = O:FindFirstChild("climb") and (O.climb:FindFirstChild("ClimbAnim")),
        swim = O:FindFirstChild("swim") and (O.swim:FindFirstChild("Swim")),
        swimidle = O:FindFirstChild("swimidle") and (O.swimidle:FindFirstChild("SwimIdle")),
      }
      if J then
        O = o[L]
        if not O then
          return false
        end
        for J, S in pairs(O) do
          if i[J] then
            i[J].AnimationId = S
          end
        end
      else
        local J = Q[H]
        if not J then
          return false
        end
        o[L] = _(L, i, o[L])
        local Q = J.Idle or {}
        local o = {
          idle1 = J.Animation1 or Q[1],
          idle2 = J.Animation2 or Q[2],
          walk = J.WalkAnim,
          run = J.RunAnim,
          jump = J.JumpAnim,
          fall = J.FallAnim,
          climb = J.ClimbAnim,
          swim = J.Swim,
          swimidle = J.SwimIdle,
        }
        for Q, _ in pairs(o) do
          if i[Q] and _ then
            i[Q].AnimationId = n(_)
          end
        end
      end
      O = L:FindFirstChildOfClass("Humanoid")
      if O then
        for n, n in ipairs(O:GetPlayingAnimationTracks()) do
          pcall(function()
            n:Stop(0)
          end)
        end
      end
      return true
    end
    function T.Animaciones(n)
      y["Harder Hit Anim"] = false
      if n then
        _G.__AkatsukiAnimationPreset = z
        pcall(U, z, false)
      else
        pcall(U, nil, true)
      end
      if M["Harder Hit Anim"] then
        pcall(M["Harder Hit Anim"])
      end
    end
    local z, n = _N(yN, "Animaciones", "Animaciones", y.Animaciones, 2, false, function(Q)
      t("Animaciones", Q)
    end)
    n.Name = "AnimationsMasterToggle"
    n.Visible = true
    n.ZIndex = 8
    local Q = UN(n, y.Animaciones and "ON" or "OFF", function()
      t("Animaciones", not y.Animaciones)
      return y.Animaciones and "ON" or "OFF"
    end)
    local function o()
      z(y.Animaciones == true)
      Q.Text = y.Animaciones and "ON" or "OFF"
    end
    M.Animaciones = o
    o()
    _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function()
      if not y.Animaciones or not _G.__AkatsukiAnimationPreset then
        return
      end
      task.wait(0.75)
      pcall(U, _G.__AkatsukiAnimationPreset, false)
    end))
    if y.Animaciones and _G.__AkatsukiAnimationPreset then
      task.defer(function()
        task.wait(0.5)
        pcall(U, _G.__AkatsukiAnimationPreset, false)
      end)
    end
    UN = r(Instance.new("TextLabel"))
    UN.Size = UDim2.new(1, -8, 0, 30)
    UN.BackgroundTransparency = 1
    UN.LayoutOrder = 4
    UN.Text =
      "Usa < y > para aplicar y guardar automaticamente. El toggle permite activar o desactivar."
    UN.TextColor3 = f.textDim
    UN.TextSize = 10
    UN.Font = Enum.Font.Gotham
    UN.TextWrapped = true
    UN.TextXAlignment = Enum.TextXAlignment.Left
    UN.Parent = yN
    local z, Q, _ = w.Keybinds, {}, 0
    local function U(H, J, L, O)
      if Q[J] then
        return Q[J]
      end
      _ += 1
      L = Instance.new("Frame")
      L.Name = "Keybind_" .. string.gsub(J, "[^%w_]", "_")
      L.Size = UDim2.new(1, 0, 0, p and 36 or 42)
      L.BackgroundColor3 = f.row
      L.BackgroundTransparency = 0.5
      L.BorderSizePixel = 0
      L.LayoutOrder = _
      L.Parent = O or z
      Y(L, 10)
      F(L, f.divider, 1)
      O = r(Instance.new("TextLabel"))
      O.Size = UDim2.new(1, p and -108 or -132, 1, 0)
      O.Position = UDim2.new(0, p and 8 or 12, 0, 0)
      O.BackgroundTransparency = 1
      O.Text = H
      O.TextColor3 = f.text
      O.TextSize = R.textSize
      O.Font = Enum.Font.GothamBold
      O.TextXAlignment = Enum.TextXAlignment.Left
      O.TextTruncate = Enum.TextTruncate.AtEnd
      O.Parent = L
      local _ = r(Instance.new("TextButton"))
      _.Name = "BindButton"
      _.Size = UDim2.fromOffset(p and 82 or 98, p and 24 or 28)
      _.Position = UDim2.new(1, p and -90 or -106, 0.5, p and -12 or -14)
      _.BackgroundColor3 = f.accent
      _.BackgroundTransparency = 0.06
      _.BorderSizePixel = 0
      _.TextColor3 = f.bgDark
      _.TextSize = p and 9 or 10
      _.Font = Enum.Font.GothamBold
      _.AutoButtonColor = false
      _.Parent = L
      Y(_, 7)
      F(_, f.textDim, 1)
      local function H()
        local O = E[J]
        _.Text = O and (zN(O)) or "BIND"
        _.BackgroundColor3 = f.accent
        _.TextColor3 = f.bgDark
      end
      _.MouseButton1Click:Connect(function()
        v(_, J)
      end)
      table.insert(m, _)
      local _ = M[J]
      M[J] = function()
        if _ then
          pcall(_)
        end
        H()
      end
      Q[J] = L
      H()
      return L
    end
    nN(z, "KEYBINDS", -100)
    yN = {
      { "Bat Aimbot", "Aimbot" },
      { "TP Bat", "TP Bat" },
      { "Auto Play", "Autoplay" },
      { "Lagger Aimbot", "Lagger Aimbot" },
      { "Anti Bat", "Anti Bat" },
      { "Drop Brainrot", "Drop", true },
      { "TP Down", "TP Down", true },
      { "Insta Reset", "Insta Reset", true },
      { "Toggle UI", "Toggle UI" },
    }
    for z, z in ipairs(yN) do
      U(z[1], z[2], z[3] == true)
    end
    local z, Q, _ =
      "Movement", {
        Movement = "MAIN",
        Combat = "COMBAT",
        Visual = "VISUALS",
        Animations = "CONFIG",
        Keybinds = "KEYBINDS",
      }, { "Movement", "Combat", "Visual", "Animations", "Keybinds" }
    for U, H in ipairs(_) do
      local _ = r(Instance.new("TextButton"))
      _.Name = H .. "Button"
      _.Size = UDim2.new(0.2, p and -3 or -5, 0, R.categoryH)
      _.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
      _.BackgroundTransparency = H == z and 0.2 or 0.3
      _.BorderSizePixel = 0
      _.Text = Q[H] or (string.upper(H))
      _.TextColor3 = f.text
      _.TextSize = p and 8 or 10
      _.Font = Enum.Font.GothamBold
      _.LayoutOrder = U
      _.Parent = W
      Y(_, 6)
      n = Instance.new("Frame")
      n.Name = "Indicator"
      n.Size = UDim2.new(0, 18, 0, 2)
      n.Position = UDim2.new(0.5, -9, 1, -2)
      n.BackgroundColor3 = f.accent
      n.BackgroundTransparency = H == z and 0.3 or 1
      n.BorderSizePixel = 0
      n.Parent = _
      _.MouseButton1Click:Connect(function()
        if z == H then
          return
        end
        z = H
        for R, n in pairs(w) do
          local Q = R == H
          n.Visible = Q
          if Q then
            n = c[R]
            if n then
              n.Scale = 0.975
              d(n, { Scale = 1 }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            end
          end
        end
        for R, n in ipairs(W:GetChildren()) do
          if n:IsA("TextButton") then
            R = n.Name == H .. "Button"
            d(n, { TextColor3 = f.text, BackgroundTransparency = R and 0.16 or 0.3 }, 0.18)
            local Q = n:FindFirstChild("Indicator")
            if Q then
              d(Q, {
                BackgroundTransparency = R and 0.15 or 1,
                Size = UDim2.new(0, R and 28 or 12, 0, 2),
                Position = UDim2.new(0.5, R and -14 or -6, 1, -2),
              }, 0.2)
            end
          end
        end
      end)
      _.MouseEnter:Connect(function()
        if z ~= H then
          d(_, { TextColor3 = f.text, BackgroundTransparency = 0.25 })
        end
      end)
      _.MouseLeave:Connect(function()
        if z ~= H then
          d(_, { TextColor3 = f.text, BackgroundTransparency = 0.3 })
        end
      end)
    end
    DN = function()
      for z, z in ipairs(W:GetChildren()) do
        if z:IsA("TextButton") then
          z.TextColor3 = f.text
        end
      end
    end
    DN()
    local z = Instance.new("TextButton")
    r(z)
    z.Name = "AkatsukiRestoreButton"
    z.Size = UDim2.new(0, 120, 0, 30)
    o = _G._AkatsukiHub_UI_ModernMiniPos
    z.Position = o and (UDim2.fromOffset(o.x or 6, o.y or 54)) or (UDim2.new(0, 6, 0, 54))
    z.BackgroundColor3 = f.bgDark
    z.BorderSizePixel = 0
    z.Text = "Akatsuki Hub"
    z.TextColor3 = f.text
    z.TextSize = 11
    z.Font = Enum.Font.GothamBlack
    z.Visible = not g.Visible
    z.ZIndex = 900
    z.Parent = h
    Y(z, 8)
    F(z, Color3.fromRGB(45, 45, 45), 1.2)
    k(z, z)
    a.MouseButton1Click:Connect(function()
      if _G.__setPanelVisible then
        _G.__setPanelVisible(false)
      else
        g.Visible = false
      end
    end)
    z.MouseButton1Click:Connect(function()
      if _G.__setPanelVisible then
        _G.__setPanelVisible(true)
      else
        g.Visible = true
      end
    end)
    g:GetPropertyChangedSignal("Visible"):Connect(function()
      _G.__AkatsukiPanelVisible = g.Visible
      y["Toggle UI"] = g.Visible
      z.Visible = not g.Visible
      oN()
    end)
    local function R()
      local n = workspace.CurrentCamera
      if not n then
        return
      end
      local Q = n.ViewportSize
      if Q.X <= 0 or Q.Y <= 0 then
        return
      end
      local n, o = math.max(1, Q.X - 12), math.max(1, Q.Y - 60)
      if p then
        g.Size = UDim2.new(
          0,
          math.min(n, math.clamp(math.floor(Q.X * 0.58), 240, 330)),
          0,
          math.min(o, math.clamp(math.floor(Q.Y * 0.58), 260, 390))
        )
      else
        g.Size = UDim2.new(0, math.min(430, n), 0, math.min(500, o))
      end
      o = { g, z }
      for z, n in ipairs(o) do
        z = n.Position
        X(n, z.X.Scale, z.X.Offset, z.Y.Scale, z.Y.Offset)
      end
    end
    R()
    local z
    local function n()
      if z then
        z:Disconnect()
        z = nil
      end
      local Q = workspace.CurrentCamera
      if Q then
        z = _G.__AkatsukiTrackConn(Q:GetPropertyChangedSignal("ViewportSize"):Connect(function()
          task.defer(R)
        end))
      end
      task.defer(R)
    end
    _G.__AkatsukiTrackConn(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(n))
    n()
  end)()
  _G.__AkatsukiRegisterThemeRoot(h)
  task.spawn(function()
    local z = Instance.new("Frame")
    z.Size = UDim2.new(1, 0, 1, 0)
    z.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    z.BackgroundTransparency = 1
    z.BorderSizePixel = 0
    z.ZIndex = 10000
    z.Parent = h
    b:Create(z, TweenInfo.new(0.08, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.45 })
      :Play()
    task.wait(0.12)
    b:Create(z, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 }):Play()
    task.wait(0.3)
    pcall(function()
      z:Destroy()
    end)
  end);
  (function()
    local function z(b)
      if not b then
        return "..."
      end
      return zN(b)
    end
    _G.__AkatsukiTrackConn(C.InputBegan:Connect(function(b, R)
      if l and N then
        local n, Q =
          N,
          b.UserInputType == Enum.UserInputType.Touch
            or b.UserInputType == Enum.UserInputType.MouseButton1
        if V(b) or Q or (bN(b)) then
          if Q or b.KeyCode == Enum.KeyCode.Escape or P(b) and n ~= "Toggle UI" then
            E[n] = nil
            local Q = (l.Size.X.Offset == 42 or (l:GetAttribute("MiniUIBind"))) and "-" or "BIND"
            l.Text = Q
          elseif bN(b) then
            local Q = RN(b)
            E[n] = Q
            l.Text = CN[Q] or Q
          else
            E[n] = b.KeyCode
            l.Text = z(b.KeyCode)
          end
          l.BackgroundColor3 = Color3.fromRGB(50, 24, 29)
          l.TextColor3 = Color3.fromRGB(225, 70, 80)
          l, N = nil, nil
          oN()
          if n and M[n] then
            M[n]()
          end
          local Q = s[n]
          if Q and Q.bindCircle then
            local p = E[n]
            Q.bindCircle.Text = p and (z(p)) or "-"
          end
          return
        end
      end
      if C:GetFocusedTextBox() then
        return
      end
      local z = E["Carry Speed"]
      local n, Q =
        z ~= nil and (V(b) and b.KeyCode == z or bN(b) and RN(b) == z), E.SelectNormalMode
      if Q ~= nil and (V(b) and b.KeyCode == Q or bN(b) and RN(b) == Q) and Z ~= "Normal" then
        if FeatureToggles.SelectNormalMode then
          FeatureToggles.SelectNormalMode()
        end
        pcall(function()
          if _G.__refreshSpeedBoost then
            _G.__refreshSpeedBoost()
          end
        end)
        pcall(function()
          if _G.__refreshSpeedBillboards then
            _G.__refreshSpeedBillboards()
          end
        end)
        oN()
        return
      end
      if n then
        if FeatureToggles["Carry Speed"] then
          FeatureToggles["Carry Speed"]()
        else
          z = not y["Carry Speed"]
          y["Carry Speed"] = z
          K = z
          if T["Carry Speed"] then
            T["Carry Speed"](z)
          end
          if M["Carry Speed"] then
            M["Carry Speed"]()
          end
          oN()
        end
        return
      end
      n = E.Drop
      if n ~= nil and (V(b) and b.KeyCode == n or bN(b) and RN(b) == n) then
        if FeatureToggles.Drop then
          FeatureToggles.Drop("keybind")
        end
        return
      end
      if R and not A[b.UserInputType] then
        return
      end
      if V(b) then
        for n, p in pairs(E) do
          if b.KeyCode == p then
            if FeatureToggles[n] then
              if n == "Drop" then
                FeatureToggles[n]("keybind")
              else
                FeatureToggles[n]()
              end
            else
              Q = not y[n]
              y[n] = Q
              oN()
              if T[n] then
                T[n](Q)
              end
              if M[n] then
                M[n]()
              end
            end
          end
        end
      end
      if bN(b) then
        Q = RN(b)
        for n, p in pairs(E) do
          if p == Q then
            if FeatureToggles[n] then
              if n == "Drop" then
                FeatureToggles[n]("keybind")
              else
                FeatureToggles[n]()
              end
            else
              z = not y[n]
              y[n] = z
              oN()
              if T[n] then
                T[n](z)
              end
              if M[n] then
                M[n]()
              end
            end
          end
        end
      end
      if not R and not C:GetFocusedTextBox() then
        if bN(b) then
          if RN(b) == E.BypassAuto then
            if FeatureToggles.BypassAuto then
              FeatureToggles.BypassAuto()
            end
            return
          end
        else
          Q = E.BypassAuto
          if Q and b.KeyCode == Q then
            if FeatureToggles.BypassAuto then
              FeatureToggles.BypassAuto()
            end
            return
          end
        end
      end
    end))
  end)();
  (function()
    local z = _G.__AkatsukiInfJumpState or {}
    _G.__AkatsukiInfJumpState = z
    z.conn = z.conn or nil
    z.lastJumpTime = z.lastJumpTime or 0
    z.manualLock = false
    local function b()
      return false
    end
    local function R()
      if (_G.__AkatsukiInfJumpMode or "hold") ~= "manual" or z.manualLock then
        return
      end
      z.manualLock = true
      local n = u.Character
      local Q, p =
        n and (n:FindFirstChildOfClass("Humanoid")), n and (n:FindFirstChild("HumanoidRootPart"))
      if not Q or not p then
        z.manualLock = false
        return
      end
      n = tick()
      if n - z.lastJumpTime < 0.08 then
        z.manualLock = false
        return
      end
      z.lastJumpTime = n
      p.Velocity = Vector3.new(p.Velocity.X, 55, p.Velocity.Z)
      task.delay(0.14, function()
        z.manualLock = false
      end)
    end
    _G.__AkatsukiTrackConn(C.InputBegan:Connect(function(n, Q)
      if Q then
        return
      end
      if n.KeyCode == Enum.KeyCode.Space or n.KeyCode == Enum.KeyCode.ButtonA then
        if (_G.__AkatsukiInfJumpMode or "hold") == "manual" then
          R()
          return
        end
        if not b() then
          z.lastJumpTime = tick() - 0.08
        end
      end
    end))
    function startInfJump()
      if z.conn then
        z.conn:Disconnect()
        z.conn = nil
      end
      z.conn = D.Heartbeat:Connect(function()
        if not y["Inf Jump"] or (_G.__AkatsukiInfJumpMode or "hold") ~= "hold" then
          return
        end
        if b() then
          return
        end
        pcall(function()
          local b = u.Character
          if not b then
            return
          end
          local D = b:FindFirstChildOfClass("Humanoid")
          if not D then
            return
          end
          local R = b:FindFirstChild("HumanoidRootPart")
          if not R then
            return
          end
          b = tick()
          if
            (
              C:IsKeyDown(Enum.KeyCode.Space)
              or (C:IsKeyDown(Enum.KeyCode.ButtonA))
              or D.Jump == true
            ) and b - z.lastJumpTime >= 0.08
          then
            z.lastJumpTime = b
            local C = R.Velocity
            R.Velocity = Vector3.new(C.X, 55, C.Z)
          end
        end)
      end)
    end
    function stopInfJump()
      if z.conn then
        z.conn:Disconnect()
        z.conn = nil
      end
    end
    _G.__AkatsukiTrackStopper(stopInfJump)
    T["Inf Jump"] = function(z)
      if z and (_G.__AkatsukiInfJumpMode or "hold") == "hold" then
        startInfJump()
      else
        stopInfJump()
      end
    end
    if y["Inf Jump"] and (_G.__AkatsukiInfJumpMode or "hold") == "hold" then
      startInfJump()
    end
    _G.__AkatsukiTrackConn(u.CharacterAdded:Connect(function()
      if y["Inf Jump"] and (_G.__AkatsukiInfJumpMode or "hold") == "hold" then
        task.wait(0.5)
        stopInfJump()
        startInfJump()
      end
    end))
  end)()
  h.Enabled = true
  task.defer(function()
    local z = { "FPS Boost", "Anti Lag", "Optimizer" }
    for C, C in ipairs(z) do
      if y[C] and T[C] then
        pcall(function()
          T[C](true)
        end)
      end
    end
  end)
end