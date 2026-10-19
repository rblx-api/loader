-- https://discord.gg/7Ar8QGZB2j

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
_G.__ZDuelsWaveSafeMode = string.find(string.lower(o), "wave", 1, true) ~= nil
do
  local o = {
    "ZDuels_Panel",
    "ZDuelsHub",
    "ZDUELS_Panel",
    "DashEffectGui",
    "ZDuelsAutoGrabBar",
    "ZDuelsLaggerGUI",
    "ZDuelsBypassGUI",
    "ZDuelsMobileUI",
    "ZDuelsEnemyWidget",
  }
  pcall(function()
    local _ = _G.ZDuelsBypass
    if _ then
      if _.IsVisible and _.IsVisible() then
        _G.__ZDuelsBypassWasOpen = true
        _G._ZDuelsBypassOpen = true
      elseif _G._ZDuelsBypassOpen == true then
        _G.__ZDuelsBypassWasOpen = true
      end
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
    local _ = _G.ZDuelsLagger
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
  if _G.__ZDUELS_STATE then
    _G.__ZDUELS_STATE.alive = false
    pcall(function()
      for _, _ in ipairs(_G.__ZDUELS_STATE.stoppers or {}) do
        pcall(_)
      end
      for _, _ in ipairs(_G.__ZDUELS_STATE.conns or {}) do
        pcall(function()
          _:Disconnect()
        end)
      end
    end)
  end
  _G.__ZDUELS_STATE = nil
  _G.__ZDuelsTrackConn = nil
  _G.__ZDuelsTrackStopper = nil
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
              or o.Name == "ZDuelsSpeedBill"
              or o.Name == "ZDuelsHubOverhead"
              or o.Name == "ZDuelsAimbotBodyLock"
              or o.Name == "ZDuelsAimbotBodyAttachment"
              or o.Name == "ZDuelsTPBatMarkerBodyLock"
              or o.Name == "ZDuelsTPBatMarkerAttachment"
            then
              o:Destroy()
            end
          end
        end
      end
    end
  end)
  _G.__ZDUELS_STATE = { conns = {}, stoppers = {}, alive = true }
  function _G.__ZDuelsTrackConn(o)
    if o then
      table.insert(_G.__ZDUELS_STATE.conns, o)
    end
    return o
  end
  function _G.__ZDuelsTrackStopper(o)
    if o then
      table.insert(_G.__ZDUELS_STATE.stoppers, o)
    end
  end
  _G.__ZDuelsResetHooks = {}
  function _G.__ZDuelsOnNewInstance(o)
    if o then
      table.insert(_G.__ZDuelsResetHooks, o)
    end
  end
end
local o, _, U =
  _G.__ZDUELS_STATE, {}, {
    "__ZDuelsTPBatApplyMarkerBodyLock",
    "__ZDuelsTPBatClearMarkerBodyLock",
    "__ZDuelsTPBatIsInsideMap",
    "__ZDuelsTPBatGetMarkerCFrame",
    "__ZDuelsTPBatTrackTarget",
    "__ZDuelsTPBatClearMarkerTracking",
    "__ZDuelsTPBatForceMarker",
    "__ZDuelsUpdateBatVersionButton",
    "__ZDuelsRefreshVisibleTPBatConfig",
    "__tpBatV2DistanceInput",
    "__batVersionPill",
    "ZDuelsAutoBat",
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
    _G.__ZDuelsTrackConn(H)
  end
  function _G.__ZDuelsWalkDescendantsBatched(h, f, J)
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
  _G.__ZDuelsTrackStopper(function()
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
  _G.__ZDuelsAntiDieGuiEnabled = nil
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
      (if _G.__ZDuelsAntiDieGuiEnabled then _G.__ZDuelsAntiDieGuiEnabled() == true else i)
        or f.autobat
    )
  end
  function _G.__ZDuelsAntiDieSource(i, S)
    if H or f[i] == nil then
      return
    end
    f[i] = S == true
    O()
  end
  function _G.__ZDuelsAntiDieSet(i)
    _G.__ZDuelsAntiDieSource("autobat", i)
  end
  function _G.__ZDuelsAntiDieIsEnabled()
    return y
  end
  _G.__ZDuelsTrackStopper(function()
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
      _G.__ZDuelsTrackConn(h)
    end
  end
  _G.__ZDuelsTrackConn(D.Heartbeat:Connect(function()
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
  {}, { Aimbot = true, Autoplay = true, Lagger = true }, {
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
_G.__ZDuelsDropMode = _G.__ZDuelsDropMode == "Jump Drop" and "Jump Drop" or "Stand Drop"
_G.__ZDuelsAimbotVersion = (_G.__ZDuelsAimbotVersion == "Clean Hub" or _G.__ZDuelsAimbotVersion == "Bypass" or _G.__ZDuelsAimbotVersion == "Bypass V2") and _G.__ZDuelsAimbotVersion or "Original"
_G.__ZDuelsTabPos = (_G.__ZDuelsTabPos == "Top" or _G.__ZDuelsTabPos == "Left" or _G.__ZDuelsTabPos == "Right") and _G.__ZDuelsTabPos or "Bottom"
_G._ZDuelsHub_UI_Data = _G._ZDuelsHub_UI_Data or {}
local g, B = {}, {}
_G.__ZDuelsButtonsSize = 1
_G.__ZDuelsGuiPositionResetters = {}
_G.__ZDuelsResetButtonPositions = nil
_G.__ZDuelsGuiPositionsReset = false
function _G.__ZDuelsRoundPanelBackground(t, X)
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
function _G.__ZDuelsFramePanelBackground(t, X, X)
  t.BackgroundColor3 = Color3.fromRGB(71, 71, 71)
  t.BackgroundTransparency = 1
  t.ImageTransparency = 1
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
function _G.__ZDuelsAddOriginalGui3Title(t, X)
  if t then
    t.Text = string.upper(tostring(X or "Z DUELS"))
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
_G.__ZDuelsTrackConn(C.InputChanged:Connect(function(v)
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
_G.__ZDuelsTrackConn(C.InputEnded:Connect(function(v)
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
  ["245,250,255"] = Color3.fromRGB(16, 16, 16),
  ["235,245,255"] = Color3.fromRGB(24, 24, 24),
  ["210,230,250"] = Color3.fromRGB(29, 29, 29),
  ["190,220,250"] = Color3.fromRGB(69, 69, 69),
  ["140,190,240"] = Color3.fromRGB(97, 97, 97),
  ["80,160,255"] = Color3.fromRGB(157, 157, 157),
  ["50,110,190"] = Color3.fromRGB(238, 238, 238),
  ["80,130,200"] = Color3.fromRGB(193, 193, 193),
  ["40,80,150"] = Color3.fromRGB(226, 226, 226),
  ["30,90,200"] = Color3.fromRGB(170, 170, 170),
  ["60,120,200"] = Color3.fromRGB(211, 211, 211),
  ["100,140,200"] = Color3.fromRGB(199, 199, 199),
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
      return Color3.fromRGB(236, 236, 236)
    end
    return Color3.fromRGB(170, 170, 170)
  end
  if CN >= 0.68 then
    return Color3.fromRGB(170, 170, 170)
  end
  if CN >= 0.35 then
    return Color3.fromRGB(101, 101, 101)
  end
  return Color3.fromRGB(22, 22, 22)
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
    RN:GetAttribute("ZDuelsSlightFontWeightApplied")
    or (RN:GetAttribute("ZDuelsSlightFontWeightPending"))
  then
    return
  end
  RN:SetAttribute("ZDuelsSlightFontWeightPending", true)
  task.defer(function()
    if not RN.Parent or (RN:GetAttribute("ZDuelsSlightFontWeightApplied")) then
      RN:SetAttribute("ZDuelsSlightFontWeightPending", nil)
      return
    end
    local nN = pcall(function()
      local QN = RN.FontFace
      local uN = bN[QN.Weight]
      if uN then
        RN.FontFace = Font.new(QN.Family, uN, QN.Style)
      end
    end)
    RN:SetAttribute("ZDuelsSlightFontWeightPending", nil)
    if nN then
      RN:SetAttribute("ZDuelsSlightFontWeightApplied", true)
    end
  end)
end
local bN
local RN = setmetatable({}, { __mode = "k" })
local function nN(QN)
  local uN = QN
  while uN and not uN:IsA("GuiButton") and not uN:GetAttribute("ZDuelsButtonThemeControl") do
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
    _G.__ZDuelsTrackConn(QN:GetPropertyChangedSignal(uN):Connect(function()
      nN(QN)
    end))
  end
  if pN.busy then
    return
  end
  local RN = QN[uN]
  if RN == pN.applied and pN.theme == _G.__ZDuelsGuiTheme then
    return
  end
  if RN ~= pN.applied then
    pN.original = RN
  end
  local oN = _G.__ZDuelsGuiTheme
  local function _N(UN)
    if oN ~= "GUI 2" and oN ~= "GUI 3" then
      return UN
    end
    local yN = math.max(UN.R, UN.G, UN.B)
    return Color3.fromRGB(14, 14, 14):Lerp(Color3.fromRGB(176, 176, 176), yN)
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
      RN.Color = Color3.fromRGB(84, 84, 84)
    elseif A[V] then
      RN.Color = A[V]
    end
  end
  if not _G.__ZDuelsModernGuiActive and not RN:GetAttribute("ZDuelsDarkPaletteWatched") then
    RN:SetAttribute("ZDuelsDarkPaletteWatched", true)
    local function A(V)
      _G.__ZDuelsTrackConn(RN:GetPropertyChangedSignal(V):Connect(function()
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
_G.__ZDuelsThemeRoots = {}
local A = setmetatable({}, { __mode = "k" })
function _G.__ZDuelsRegisterThemeRoot(V)
  if not V then
    return
  end
  for P, P in ipairs(_G.__ZDuelsThemeRoots) do
    if P == V then
      return
    end
  end
  table.insert(_G.__ZDuelsThemeRoots, V)
  bN(V)
  if A[V] then
    A[V]()
  end
  A[V] = _G.__ZDuelsWalkDescendantsBatched(V, bN, function()
    return V.Parent ~= nil
  end)
  _G.__ZDuelsTrackConn(V.DescendantAdded:Connect(bN))
end
function _G.__ZDuelsApplyTheme()
  for V, V in ipairs(_G.__ZDuelsThemeRoots) do
    if V and V.Parent then
      bN(V)
      if A[V] then
        A[V]()
      end
      A[V] = _G.__ZDuelsWalkDescendantsBatched(V, bN, function()
        return V.Parent ~= nil
      end)
    end
  end
end
function _G.__ZDuelsAddUnifiedPanelShade(A, V, P)
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
  zN.BackgroundTransparency = 1
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
  ["Halloween Mode"] = false,
  ["Starborn Font"] = false,
  ["Mirror TP Down"] = false,
  ["Custom Tools"] = false,
  ["Auto Bat"] = false,
  ["Custom Sounds"] = false,
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
  if _G.__ZDuelsHub_Anims then
    for UN, yN in pairs(_G.__ZDuelsHub_Anims) do
      table.insert(_N, "N:" .. UN .. "=" .. yN)
    end
  end
  table.insert(_N, "M:selectedMode=" .. Z)
  table.insert(_N, "M:optimizerMode=Normal")
  table.insert(_N, "M:aimbotVersion=" .. ((_G.__ZDuelsAimbotVersion == "Clean Hub" or _G.__ZDuelsAimbotVersion == "Bypass" or _G.__ZDuelsAimbotVersion == "Bypass V2") and _G.__ZDuelsAimbotVersion or "Original"))
  table.insert(_N, "M:tabPos=" .. tostring(_G.__ZDuelsTabPos or "Bottom"))
  table.insert(_N, "M:customFont=" .. tostring(_G.__ZDuelsFontChoice or "Default"))
  table.insert(_N, "M:aimbotSpeed=" .. tostring(_G.__ZDuelsAimbotSpeedNormal or 58))
  table.insert(_N, "M:aimbotSpeedLagger=" .. tostring(_G.__ZDuelsAimbotSpeedLagger or 58))
  table.insert(_N, "M:aimbotSpeedCustom=" .. tostring(_G.__ZDuelsAimbotSpeedCustom or 58))
  table.insert(_N, "M:aimbotSpeedDefaults=" .. tostring(_G.__ZDuelsAimbotSpeedDefaults or 0))
  table.insert(_N, "M:ctSkinBat=" .. tostring(_G.__ZDuelsCTSkinBat or "DiamondSword"))
  table.insert(_N, "M:ctSkinMedusa=" .. tostring(_G.__ZDuelsCTSkinMedusa or "GoldenDesertEagle"))
  table.insert(_N, "M:csMode=" .. tostring(_G.__ZDuelsCSMode or "Both"))
  table.insert(_N, "M:autoplayMode=" .. (_G.__autoplayMode or "Full"))
  table.insert(_N, "M:skyIndex=" .. tostring(_G.__skyGetIndex and (_G.__skyGetIndex()) or 1))
  table.insert(_N, "M:skyMode=" .. tostring(_G.__ZDuelsSkyChangerMode or "blue"))
  table.insert(
    _N,
    "M:katanaIndex=" .. tostring(_G.__katanaGetIndex and (_G.__katanaGetIndex()) or 1)
  )
  table.insert(_N, "M:autoStealMode=" .. (i == "v2" and "v2" or "v1"))
  table.insert(_N, "M:carrySpeedMode=" .. (G or "v1"))
  table.insert(
    _N,
    "M:dropMode=" .. (_G.__ZDuelsDropMode == "Jump Drop" and "Jump Drop" or "Stand Drop")
  )
  table.insert(_N, "M:infJumpMode=" .. (_G.__ZDuelsInfJumpMode or "hold"))
  table.insert(_N, "M:panelVisible=" .. tostring(_G.__ZDuelsPanelVisible ~= false))
  table.insert(_N, "M:batVersion=" .. tostring(_G.__batVersion or 1))
  table.insert(_N, "M:skinChangerMode=" .. S)
  table.insert(_N, "M:buttonsSize=" .. tostring(_G.__ZDuelsButtonsSize or 1))
  table.insert(
    _N,
    "M:tpBatV2Distance=" .. tostring(math.clamp(tonumber(_G.__tpBatV2Distance) or 8, 0, 100))
  )
  if _G.__ZDuelsAnimationPreset then
    table.insert(_N, "M:animationPreset=" .. tostring(_G.__ZDuelsAnimationPreset))
  end
  table.insert(_N, "M:guiTheme=" .. tostring(_G.__ZDuelsGuiTheme or "GUI 1"))
  table.insert(_N, "M:themePrimary=" .. (_G.__ZDuelsThemePrimary or "BLACK"))
  table.insert(_N, "M:themeSecondary=" .. (_G.__ZDuelsThemeSecondary or "RED"))
  table.insert(_N, "M:autoGrabExpanded=" .. tostring(_G._ZDuelsHub_UI_AutoGrabExpanded ~= false))
  for UN, yN in pairs(E) do
    if yN then
      local HN = if type(yN) == "string"
        then yN
        else tostring(yN):match("KeyCode%.(.+)") or (tostring(yN))
      table.insert(_N, "K:" .. UN .. "=" .. HN)
    end
  end
  if _G._ZDuelsHub_UI_MenuPos then
    local UN = _G._ZDuelsHub_UI_MenuPos
    if UN.x and UN.y then
      table.insert(_N, "P:menuPos=" .. math.floor(UN.x) .. "," .. math.floor(UN.y))
    end
  end
  table.insert(_N, "M:introMusicIndex=" .. tostring(Y))
  table.insert(_N, "M:bgIndex=" .. tostring(_G._ZDuelsHub_UI_BgIndex or 1))
  table.insert(_N, "M:bypassOpen=" .. tostring(_G._ZDuelsBypassOpen == true))
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
  if _G._ZDuelsHub_UI_SpeedFramePos then
    local UN = _G._ZDuelsHub_UI_SpeedFramePos
    if UN.x and UN.y then
      table.insert(_N, "P:speedFrame=" .. math.floor(UN.x) .. "," .. math.floor(UN.y))
    end
  end
  if _G._ZDuelsHub_EnemyWidget_SaveHook then
    pcall(_G._ZDuelsHub_EnemyWidget_SaveHook)
  end
  if _G._ZDuelsHub_UI_EnemyWidgetPos then
    local UN = _G._ZDuelsHub_UI_EnemyWidgetPos
    if UN.x and UN.y then
      table.insert(_N, "P:enemyWidget=" .. math.floor(UN.x) .. "," .. math.floor(UN.y))
    end
  end
  if _G._ZDuelsHub_UI_AutoGrabBarPos then
    local UN = _G._ZDuelsHub_UI_AutoGrabBarPos
    if UN.x ~= nil and UN.y ~= nil then
      if UN.xs or UN.ys then
        table.insert(_N, "P:autoGrabBar=" .. math.floor(UN.x) .. "," .. math.floor(UN.y) .. "," .. tostring(UN.xs or 0) .. "," .. tostring(UN.ys or 0))
      else
        table.insert(_N, "P:autoGrabBar=" .. math.floor(UN.x) .. "," .. math.floor(UN.y))
      end
    end
  end
  if _G._ZDuelsHub_UI_AutoGrabBarSize then
    table.insert(_N, "P:autoGrabBarSize=" .. tostring(_G._ZDuelsHub_UI_AutoGrabBarSize))
  end
  if _G._ZDuelsHub_UI_ModernMiniPos then
    local UN = _G._ZDuelsHub_UI_ModernMiniPos
    if UN.x and UN.y then
      table.insert(_N, "P:modernMini=" .. math.floor(UN.x) .. "," .. math.floor(UN.y))
    end
  end
  local UN = table.concat(_N, "\10")
  if UN == nN or UN == QN then
    return
  end
  QN = UN
  _G._ZDuelsHub_UI_Data = UN
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
_G.__ZDuelsTrackStopper(function()
  if QN then
    pN(QN)
    QN = nil
  end
end)
function FeatureToggles.BypassAuto()
  if _G.ZDuelsBypass and _G.ZDuelsBypass.SetBypass and _G.ZDuelsBypass.IsEnabled then
    local nN = _G.ZDuelsBypass.IsEnabled() == true
    pcall(_G.ZDuelsBypass.SetBypass, not nN)
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
        if _G.ZDuelsBypass and _G.ZDuelsBypass.SetBypass and _G.ZDuelsBypass.IsEnabled then
          break
        end
      end
      if _G.ZDuelsBypass and _G.ZDuelsBypass.SetBypass and _G.ZDuelsBypass.IsEnabled then
        local nN = _G.ZDuelsBypass.IsEnabled() == true
        pcall(_G.ZDuelsBypass.SetBypass, not nN)
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
    else if _G._ZDuelsHub_UI_Data and #_G._ZDuelsHub_UI_Data > 0
      then _G._ZDuelsHub_UI_Data
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
          _G._ZDuelsHub_UI_BgIndex = tonumber(yN)
          _G._ZDuelsHub_BgIndexRef = tonumber(yN)
        elseif UN == "bypassOpen" then
          _G._ZDuelsBypassOpen = yN == "true"
          _G.__ZDuelsBypassWasOpen = yN == "true"
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
            _G.__ZDuelsSkyChangerMode = yN
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
        elseif UN == "aimbotVersion" then
          _G.__ZDuelsAimbotVersion = (yN == "Clean Hub" or yN == "Bypass" or yN == "Bypass V2") and yN or "Original"
        elseif UN == "customFont" then
          _G.__ZDuelsFontChoice = yN
        elseif UN == "aimbotSpeed" then
          _G.__ZDuelsAimbotSpeedNormal = tonumber(yN)
        elseif UN == "aimbotSpeedLagger" then
          _G.__ZDuelsAimbotSpeedLagger = tonumber(yN)
        elseif UN == "aimbotSpeedCustom" then
          _G.__ZDuelsAimbotSpeedCustom = tonumber(yN)
        elseif UN == "aimbotSpeedDefaults" then
          _G.__ZDuelsAimbotSpeedDefaults = tonumber(yN)
        elseif UN == "ctSkinBat" then
          _G.__ZDuelsCTSkinBat = yN
        elseif UN == "ctSkinMedusa" then
          _G.__ZDuelsCTSkinMedusa = yN
        elseif UN == "csMode" then
          _G.__ZDuelsCSMode = yN
        elseif UN == "tabPos" then
          _G.__ZDuelsTabPos = (yN == "Top" or yN == "Left" or yN == "Right") and yN or "Bottom"
        elseif UN == "dropMode" then
          _G.__ZDuelsDropMode = yN == "Jump Drop" and "Jump Drop" or "Stand Drop"
        elseif UN == "infJumpMode" then
          if yN == "hold" or yN == "manual" then
            _G.__ZDuelsInfJumpMode = yN
          end
        elseif UN == "autoGrabExpanded" then
          _G._ZDuelsHub_UI_AutoGrabExpanded = yN == "true"
        elseif UN == "panelVisible" then
          _G.__ZDuelsPanelVisible = yN == "true"
          y["Toggle UI"] = _G.__ZDuelsPanelVisible
        elseif UN == "themePrimary" then
          if yN == "BLACK" or yN == "WHITE" then
            _G.__ZDuelsThemePrimary = yN
          end
        elseif UN == "themeSecondary" then
          if yN == "BLUE" or yN == "RED" or yN == "CONTRAST" then
            _G.__ZDuelsThemeSecondary = yN
          end
        elseif UN == "buttonsSize" then
          local H = tonumber(yN)
          if H and H == H and math.abs(H) < math.huge then
            _G.__ZDuelsButtonsSize = math.clamp(H, 0.5, 2)
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
          _G.__ZDuelsAnimationPreset = yN
        elseif UN == "guiTheme" then
          _G.__ZDuelsGuiTheme = "GUI 1"
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
            _G._ZDuelsHub_UI_MenuPos = { x = tonumber(H), y = tonumber(h) }
          end
        elseif UN == "toggleBtn" then
          local H, h = yN:match("(-?%d+),(-?%d+)")
          if H and h then
            _G._ZDuelsHub_UI_BtnPos = { x = tonumber(H), y = tonumber(h) }
          end
        elseif UN == "speedFrame" then
          local H, h = yN:match("(-?%d+),(-?%d+)")
          if H and h then
            _G._ZDuelsHub_UI_SpeedFramePos = { x = tonumber(H), y = tonumber(h) }
          end
        elseif UN == "enemyWidget" then
          local H, h = yN:match("(-?%d+),(-?%d+)")
          if H and h then
            _G._ZDuelsHub_UI_EnemyWidgetPos = { x = tonumber(H), y = tonumber(h) }
          end
        elseif UN == "autoGrabBar" then
          local H, h, xs, ys = yN:match("(-?%d+),(-?%d+),([%d%.%-]+),([%d%.%-]+)")
          if H and h then
            _G._ZDuelsHub_UI_AutoGrabBarPos = { x = tonumber(H), y = tonumber(h), xs = tonumber(xs), ys = tonumber(ys) }
          else
            local H2, h2 = yN:match("(-?%d+),(-?%d+)")
            if H2 and h2 then
              _G._ZDuelsHub_UI_AutoGrabBarPos = { x = tonumber(H2), y = tonumber(h2) }
            end
          end
        elseif UN == "autoGrabBarSize" then
          local H = tonumber(yN)
          if H then
            _G._ZDuelsHub_UI_AutoGrabBarSize = H
          end
        elseif UN == "modernMini" then
          local H, h = yN:match("(-?%d+),(-?%d+)")
          if H and h then
            _G._ZDuelsHub_UI_ModernMiniPos = { x = tonumber(H), y = tonumber(h) }
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
                _G._ZDuelsHub_UI_MobileBtnPos = _G._ZDuelsHub_UI_MobileBtnPos or {}
                local Y, QN, uN =
                  { x = tonumber(h), y = tonumber(f) }, yN:match(":(-?%d+):(-?%d+)$")
                if QN and uN then
                  Y.xs = tonumber(QN)
                  Y.ys = tonumber(uN)
                end
                _G._ZDuelsHub_UI_MobileBtnPos[H] = Y
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
if type(_G.__ZDuelsPanelVisible) == "boolean" then
  y["Toggle UI"] = _G.__ZDuelsPanelVisible
else
  _G.__ZDuelsPanelVisible = y["Toggle UI"] ~= false
  y["Toggle UI"] = _G.__ZDuelsPanelVisible
end
if i ~= "v1" and i ~= "v2" then
  i = "v1"
end
_G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
_G.__tpBatV2Distance = math.clamp(tonumber(_G.__tpBatV2Distance) or 8, 0, 100)
I = Z == "Lagger"
_G.__ZDuelsAimbotSpeedNormal = math.clamp(tonumber(_G.__ZDuelsAimbotSpeedNormal) or 58, 1, 150)
_G.__ZDuelsAimbotSpeedLagger = math.clamp(tonumber(_G.__ZDuelsAimbotSpeedLagger) or 58, 1, 150)
_G.__ZDuelsAimbotSpeedCustom = math.clamp(tonumber(_G.__ZDuelsAimbotSpeedCustom) or 58, 1, 150)
if _G.__ZDuelsAimbotSpeedDefaults ~= 58 then
  _G.__ZDuelsAimbotSpeedNormal, _G.__ZDuelsAimbotSpeedLagger, _G.__ZDuelsAimbotSpeedCustom = 58, 58, 58
  _G.__ZDuelsAimbotSpeedDefaults = 58
end
function _G.__ZDuelsGetAimbotSpeed()
  if Z == "Lagger" then
    return tonumber(_G.__ZDuelsAimbotSpeedLagger) or 58
  end
  if Z ~= nil and Z ~= "Normal" and Z ~= "Desync" then
    return tonumber(_G.__ZDuelsAimbotSpeedCustom) or 58
  end
  return tonumber(_G.__ZDuelsAimbotSpeedNormal) or 58
end
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
g = _G._ZDuelsHub_UI_MobileBtnPos or {}
_G.__ZDuelsModernGuiActive = true
local H = game:GetService("CoreGui")
U = u.PlayerGui:FindFirstChild("ZDUELS_Panel") or (H:FindFirstChild("ZDUELS_Panel"))
if U then
  U:Destroy()
end
local h = Instance.new("ScreenGui")
h.Name = "ZDuelsHub"
_G.__ZDuelsHalloweenRoot = h
_G.__ZDuelsHExtra = _G.__ZDuelsHExtra or setmetatable({}, { __mode = "k" })
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
  p and (math.clamp(math.floor(H.X * 0.34), 145, 175)) or (math.min(230, math.floor(H.X * 0.36))),
  p and (math.clamp(math.floor(H.Y * 0.52), 200, 310)) or (math.min(520, math.floor(H.Y * 0.8))),
  Instance.new("Frame")
g.Name = "Panel"
g.Active = true
g.Size = UDim2.new(0, f, 0, Y)
a = _G._ZDuelsHub_UI_MenuPos
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
  {
    "rbxassetid://106198980844513",
    "rbxassetid://133480996347048",
    "rbxassetid://130445102143088",
    "rbxassetid://93606486246798",
  }, tonumber(_G._ZDuelsHub_UI_BgIndex) or 1
_G.__ZDuelsBgLists = { uN }
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
yN.AnchorPoint = Vector2.new(.5,.5)
yN.Position = UDim2.fromScale(.5,.5)
yN.Size = UDim2.fromScale(1,1)
yN.BackgroundTransparency = 1
yN.Image = uN[pN]
yN.ScaleType = Enum.ScaleType.Crop
yN.ZIndex = 0
yN.Visible = true
yN.Parent = g
Instance.new("UICorner",yN).CornerRadius = UDim.new(0,12)
_G._ZDuelsHub_BgImageRef = yN
_G._ZDuelsHub_BgImages = uN
_G._ZDuelsHub_BgIndexRef = pN
local HN = Instance.new("TextButton")
HN.Name = "LegacyBackgroundButtonStub"
HN.Visible = false
HN.Parent = g
do
  local aN, hN
  local fN, JN = false
  local function LN(ON)
    pcall(function()
      if _G.__ZDuelsPreserveOptimizerUI(ON) then
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
    JN = _G.__ZDuelsWalkDescendantsBatched(workspace, LN, function()
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
        _G.__ZDuelsWalkDescendantsBatched(ON, LN, function()
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
        qN:match("^ZDuels")
        or (qN:match("^__ZDuels"))
        or (qN:match("^ZDuels"))
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
    SN = _G.__ZDuelsWalkDescendantsBatched({ workspace, n }, eN, function()
      return aN and hN == LN
    end)
  end
  _G.__ZDuelsTrackStopper(jN)
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
  _G.__ZDuelsTrackConn(D.RenderStepped:Connect(function(iN)
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
  local LN = _G._ZDuelsHub_UI_EnemyWidgetPos or { x = 140, y = -340 }
  function _G.__ZDuelsGuiPositionResetters.EnemyWidget()
    hN, LN = false, { x = 140, y = -340 }
    _G._ZDuelsHub_UI_EnemyWidgetPos = nil
    if aN and aN.Parent then
      aN.Position = UDim2.fromOffset(LN.x, LN.y)
    end
  end
  local ON, iN, SN = 0
  local ZN, YN, jN = false
  local eN, qN = ""
  function _G.__ZDuelsGetVisualEnemy()
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
    aN.Name = "ZDuelsEnemyWidget"
    aN.Size = UDim2.new(0, 140, 0, 80)
    aN.Position = UDim2.new(0, LN.x, 0, LN.y)
    _G.__enemyWidget = aN
    _G.__ZDuelsRegisterThemeRoot(aN)
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
    IN.TextColor3 = Color3.fromRGB(206, 206, 206)
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
            _G._ZDuelsHub_UI_EnemyWidgetPos = { x = LN.x, y = LN.y }
            oN()
          end
        end)
      end
    end)
    _G.__ZDuelsTrackConn(C.InputChanged:Connect(function(GN)
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
        SN.TextColor3 = Color3.fromRGB(206, 206, 206)
        eN = JN
      end
    elseif eN ~= "" then
      SN.Text = ""
      eN = ""
    end
  end
  local JN, SN, YN = 0, p and 0.5 or 0.25, 0
  _G.__ZDuelsTrackConn(D.Heartbeat:Connect(function(eN)
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
          JN.TextColor3 = Color3.fromRGB(176, 176, 176)
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
  function _G._ZDuelsHub_EnemyWidget_SaveHook()
    if aN and aN.Parent then
      LN.x = aN.Position.X.Offset
      LN.y = aN.Position.Y.Offset
      _G._ZDuelsHub_UI_EnemyWidgetPos = { x = LN.x, y = LN.y }
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
  if _G.__ZDuelsResetSpeedDirection then
    pcall(_G.__ZDuelsResetSpeedDirection)
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
_G.__ZDuelsTrackStopper(SN)
T["Anti Ragdoll"] = function(ZN)
  if ZN then
    iN()
  else
    SN()
  end
end
_G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(SN)
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
    _G._VenomAntiBatSpiking = false
    _G._VenomAntiBatDesiredXZ = nil
  end
  local venom = { amp = 10000, phase = 0, dir = 1 }
  local function SN()
    local ZN = u.Character
    local YN = ZN and (ZN:FindFirstChild("HumanoidRootPart"))
    if not YN then
      return
    end
    if ON.Connection then
      ON.Connection:Disconnect()
    end
    venom.amp, venom.phase, venom.dir = 10000, 0, 1
    ON.Connection = D.Heartbeat:Connect(function()
      if not y["Anti Bat"] then
        return
      end
      local ch = u.Character
      local root = ch and ch:FindFirstChild("HumanoidRootPart")
      if not root or not root.Parent then
        return
      end
      local savedXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
      venom.amp = venom.amp + 500 * venom.dir
      if venom.amp >= 20000 then
        venom.amp = 10000
        venom.dir = -1
      elseif venom.amp <= 10000 then
        venom.amp = 10000
        venom.dir = 1
      end
      venom.phase = venom.phase + math.random() * 0.5
      local magnitude = venom.amp + math.random(-5000, 5000)
      _G._VenomAntiBatSpiking = true
      root.Velocity = Vector3.new(math.cos(venom.phase) * magnitude, root.Velocity.Y, math.sin(venom.phase) * magnitude)
      D.RenderStepped:Wait()
      if root.Parent then
        local desired = _G._VenomAntiBatDesiredXZ
        if desired then
          root.Velocity = Vector3.new(desired.X, root.Velocity.Y, desired.Z)
        else
          root.Velocity = Vector3.new(savedXZ.X, root.Velocity.Y, savedXZ.Z)
        end
      end
      _G._VenomAntiBatSpiking = false
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
  _G.__ZDuelsTrackStopper(iN)
  T["Anti Bat"] = function(SN)
    if SN then
      ON()
    else
      iN()
    end
  end
  _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function()
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
  U = _G.__ZDuelsSpeedSpoofState
  if type(U) == "table" then
    U.enabled = false
  end
  local iN = _G.__ZDuelsS2SpeedState
  if type(iN) ~= "table" then
    iN = { hooked = false }
    _G.__ZDuelsS2SpeedState = iN
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
  function _G.__ZDuelsResetSpeedDirection()
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
    if _G._ZurichHub_MovementBlocked == true or _G._ZDuelsHub_MovementBlocked == true then
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
  _G.__ZDuelsTrackStopper(function()
    y["Speed Boost"] = false
    I()
    iN.root = nil
    _G.__ZDuelsResetSpeedDirection = nil
  end)
  if u.Character then
    ZN((SN(u.Character)))
  end
  if y["Speed Boost"] then
    KN()
  end
  _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(jN)
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
  _G.__ZDuelsTrackConn(u.CharacterRemoving:Connect(function()
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
      ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 12)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(242, 242, 242)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12)),
    }), ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 12)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(242, 242, 242)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12)),
    })
  local function ZN(YN)
    if _G.__ZDuelsGuiTheme == "GUI 3" then
      return ColorSequence.new(Color3.fromRGB(12, 12, 12), Color3.fromRGB(242, 242, 242))
    end
    if YN then
      return _G.__ZDuelsGuiTheme == "GUI 2" and SN or iN
    end
    return ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 12)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(242, 242, 242)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12)),
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
    eN = jN:FindFirstChild("ZDuelsSpeedBill")
    if eN then
      eN:Destroy()
    end
    eN = jN:FindFirstChild("ZDuelsHubOverhead")
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
    eN:SetAttribute("ZDuelsThemeWorldAccent", true)
    eN.Size = iN and (UDim2.fromOffset(190, 60)) or (UDim2.fromOffset(130, 42))
    eN.StudsOffset = iN and (Vector3.new(0, 1.8, 0)) or (Vector3.new(0, 1.65, 0))
    eN.AlwaysOnTop = true
    eN.LightInfluence = 0
    eN.MaxDistance = 0
    local function qN(KN, GN)
      KN.Font = Enum.Font.GothamBlack
      KN.TextStrokeTransparency = 0
      if GN then
        KN.TextColor3 = Color3.fromRGB(242, 242, 242)
        local GN = Instance.new("UIStroke", KN)
        GN.Color = Color3.fromRGB(0, 0, 0)
        GN.Thickness = 1.75
        GN.Transparency = 0.2
        GN = Instance.new("UIGradient")
        GN.Name = "SpeedTextGradient"
        GN.Color = ZN(true)
        GN.Parent = KN
      else
        KN.TextColor3 = Color3.fromRGB(242, 242, 242)
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
    jN.Text = iN and ".gg/z-duels" or ""
    jN.Visible = iN
    jN.TextScaled = false
    jN.TextSize = iN and 19 or 15
    qN(jN, iN)
    jN.Font = Enum.Font.GothamBold
    jN.TextColor3 = Color3.fromRGB(79, 79, 79)
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
    jN.TextColor3 = Color3.fromRGB(79, 79, 79)
    iN = jN:FindFirstChild("SpeedTextGradient")
    if iN then
      iN:Destroy()
    end
    _G.__ZDuelsRegisterThemeRoot(eN)
  end
  local function I(iN)
    if iN.Character then
      YN(iN.Character, iN == u)
    end
    _G.__ZDuelsTrackConn(iN.CharacterAdded:Connect(function(jN)
      YN(jN, iN == u)
    end))
  end
  for iN, iN in ipairs(z:GetPlayers()) do
    if iN ~= u then
      I(iN)
    end
  end
  _G.__ZDuelsTrackConn(z.PlayerAdded:Connect(function(iN)
    I(iN)
  end))
  if u.Character then
    YN(u.Character, true)
  end
  _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(I)
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
  _G.__ZDuelsTrackConn(D.Heartbeat:Connect(function(eN)
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
    _G.__ZDuelsTrackStopper(GN)
    _G.__ZDuelsTrackConn(D.PostSimulation:Connect(KN))
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
  _G.__ZDuelsTrackConn(workspace.DescendantAdded:Connect(function(KN)
    if not (y["ESP Players"] or y["Player Tracers"] or y["Stretchz Res"]) then
      return
    end
    eN(KN)
  end))
  do
    local KN, GN, IN = 0, 0
    _G.__ZDuelsTrackConn(D.Heartbeat:Connect(function(FN)
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
        IN = _G.__ZDuelsWalkDescendantsBatched(workspace, eN, function()
          return y["ESP Players"] or y["Player Tracers"] or y["Stretchz Res"]
        end)
      end
    end))
  end
  _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function()
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
  _G.__ZDuelsTrackStopper(KN)
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
  _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(cN)
    pcall(function()
      cN:WaitForChild("HumanoidRootPart", 5)
    end)
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
    _G.__ZDuelsTrackConn(u.CharacterRemoving:Connect(ON))
    _G.__ZDuelsTrackStopper(function()
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
      _G.__ZDuelsInstaReset = SN
      _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function()
        ZN()
        LN, ON = false, false
      end))
      _G.__ZDuelsTrackConn(D.Heartbeat:Connect(function()
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
      _G.__ZDuelsTrackStopper(function()
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
    _G.__ZDuelsTrackConn(D.Heartbeat:Connect(function(ON)
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
    }, _G.__ZDuelsAutoStealState or { isStealing = false }
  _G.__ZDuelsAutoStealState = lN
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
  function _G.__ZDuelsAutoGrabTargetInRadius(ZN)
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
      if _G.__ZDuelsAutoGrabRagdollBlocked == true then
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
  function _G.ZDuelsAutoStealRunCycle(eN, EN)
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
    _G.__ZDuelsWalkDescendantsBatched(LN, SN, function()
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
  _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(LN)
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
  _G.ZDuelsAutoGrab = {
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
  _G.__ZDuelsTrackConn(u.CharacterRemoving:Connect(k))
  _G.__ZDuelsTrackStopper(k);
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
      _G.__ZDuelsAutoGrabRagdollBlocked = true
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
        _G.__ZDuelsAutoGrabRagdollBlocked = false
        if not FN.AUTO_STEAL_ENABLED then
          LN()
        end
        pcall(function()
          if
            _G.ZDuelsBypass
            and _G.ZDuelsBypass.IsAutoOnSteal
            and (_G.ZDuelsBypass.IsAutoOnSteal())
            and _G.ZDuelsBypass.SetAutoOnSteal
          then
            pcall(_G.ZDuelsBypass.SetAutoOnSteal, true)
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
            _G.__ZDuelsAutoGrabRagdollBlocked = false
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
    _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(ON)
      R += 1
      YN = false
      _G.__ZDuelsAutoGrabRagdollBlocked = false
      GN(ON)
    end))
  end)()
  T["auto steal"] = function(R)
    if R then
      if _G.__ZDuelsAutoGrabRagdollBlocked ~= true then
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
      if _G._ZDuelsHitCountdownLast and ON - _G._ZDuelsHitCountdownLast < 0.15 then
        return
      end
      _G._ZDuelsHitCountdownLast = ON
      local iN = (_G._ZDuelsHitCountdownGen or 0) + 1
      _G._ZDuelsHitCountdownGen = iN
      _G._ZDuelsHitCountdownActive = true
      if _G._ZDuelsHitCountdownBB then
        pcall(function()
          _G._ZDuelsHitCountdownBB:Destroy()
        end)
        _G._ZDuelsHitCountdownBB = nil
      end
      pcall(function()
        _G._ZDuelsShowStealCountdown = R
      end)
      ON = LN:FindFirstChild("LowerTorso")
        or (LN:FindFirstChild("Torso"))
        or (LN:FindFirstChild("UpperTorso"))
        or (LN:FindFirstChild("HumanoidRootPart"))
      if not ON then
        _G._ZDuelsHitCountdownActive = false
        return
      end
      local SN = Instance.new("BillboardGui")
      SN.Name = "ZDuelsHitCountdown"
      SN.Adornee = ON
      SN.Size = UDim2.new(0, 120, 0, 56)
      SN.StudsOffset = Vector3.new(0, 0.6, 0)
      SN.AlwaysOnTop = true
      SN.LightInfluence = 0
      SN.Parent = u and (u:FindFirstChildOfClass("PlayerGui") or (game:GetService("CoreGui")))
        or (game:GetService("CoreGui"))
      _G._ZDuelsHitCountdownBB = SN
      if _G.__ZDuelsHExtra then _G.__ZDuelsHExtra[SN] = true end
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
      ON.TextColor3 = Color3.fromRGB(179, 179, 179)
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
          if _G._ZDuelsHitCountdownGen ~= iN then
            return false
          end
        end
        task.wait(YN)
        if _G._ZDuelsHitCountdownGen ~= iN then
          return false
        end
        for ZN = 0, 6, 1 do
          ON.TextTransparency = ZN / 6
          task.wait(0.02)
          if _G._ZDuelsHitCountdownGen ~= iN then
            return false
          end
        end
        return true
      end
      task.spawn(function()
        pcall(function()
          ON.TextStrokeTransparency = 0
          ON.TextColor3 = Color3.fromRGB(179, 179, 179)
          for ZN = 0, 24, 1 do
            local YN = 2.4 - 2.4 * ZN / 24
            ON.Text = YN <= 0.05 and "0" or (string.format("%.1f", YN))
            ON.TextTransparency = 0
            for ZN = 0, 2, 1 do
              ON.TextTransparency = 0.18 * ZN
              task.wait(0.02)
              if _G._ZDuelsHitCountdownGen ~= iN then
                return
              end
            end
            if _G._ZDuelsHitCountdownGen ~= iN then
              return
            end
            task.wait(0.08)
            if _G._ZDuelsHitCountdownGen ~= iN then
              return
            end
          end
          if not LN("STEAL!", Color3.fromRGB(179, 179, 179)) then
            return
          end
        end)
        if _G._ZDuelsHitCountdownGen == iN then
          pcall(function()
            SN:Destroy()
          end)
          if _G._ZDuelsHitCountdownBB == SN then
            _G._ZDuelsHitCountdownBB = nil
          end
          _G._ZDuelsHitCountdownActive = false
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
    _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(R)
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
    _G.__ZDuelsTrackStopper(function()
      k()
      LN(true)
    end)
    _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(R)
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
    _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function()
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
    _G.__ZDuelsTrackStopper(ON)
    T["Medusa Counter"] = function(LN)
      if LN then
        R()
      else
        ON()
      end
    end
    _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(LN)
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
    _G.__ZDuelsAceNormalAimbot = _G.__ZDuelsAceNormalAimbot
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
      _G.__ZDuelsAceNormalAimbot.nextSwingAt = 0
      _G.__ZDuelsAceNormalAimbot.swingCooldown = false
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
        iN = _G.__ZDuelsGetVisualEnemy and (_G.__ZDuelsGetVisualEnemy())
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
        _G.__ZDuelsAceNormalAimbot.target = LN or ZN
        iN, ZN = ON.Position, (LN or YN).Position
        LN = ZN - iN
        local c, jN, eN =
          Vector3.new(LN.X, 0, LN.Z),
          _G.__ZDuelsGetAimbotSpeed(),
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
        if y["Auto Bat"] == true and SN and c >= (_G.__ZDuelsAceNormalAimbot.nextSwingAt or 0) then
          _G.__ZDuelsAceNormalAimbot.nextSwingAt = c + 0.08
          pcall(SN.Activate, SN)
        end
      end)
    end
    function _cypherStop()
      if R then
        R:Disconnect()
        R = nil
      end
      if _G.__ZDuelsAceNormalAimbot then
        _G.__ZDuelsAceNormalAimbot.target = nil
        _G.__ZDuelsAceNormalAimbot.swingCooldown = false
        _G.__ZDuelsAceNormalAimbot.nextSwingAt = 0
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
    _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(R)
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
        while _G.__ZDUELS_STATE == o do
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
              qN = _G.__ZDuelsGetAimbotSpeed()
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
            if IN and y["Auto Bat"] == true then
              pcall(IN.Activate, IN)
            end
            R.lastActivationTime = tick()
          end
          if ZN.Magnitude > c.MIN_FOLLOW_DISTANCE then
            iN = math.clamp(_G.__ZDuelsGetAimbotSpeed(), 1, 120)
            GN.AssemblyLinearVelocity = ZN.Unit * iN
          else
            GN.AssemblyLinearVelocity = Vector3.new(0, GN.AssemblyLinearVelocity.Y * 0.5, 0)
          end
        end)
      end
      local chConn, chPrevAutoRotate
      local function chIsBat(t)
        local n = t.Name:lower()
        return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
      end
      local function chFindBat()
        local ch = u.Character
        if ch then
          local t = ch:FindFirstChildOfClass("Tool")
          if t and chIsBat(t) then
            return t
          end
        end
        local bp = u:FindFirstChildOfClass("Backpack")
        if bp then
          for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and chIsBat(t) then
              return t
            end
          end
        end
        return nil
      end
      local function chClosest()
        local ch = u.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if not root then
          return nil
        end
        local best, minD = nil, math.huge
        for _, p in ipairs(z:GetPlayers()) do
          if p ~= u then
            local c2 = p.Character
            local tr = c2 and c2:FindFirstChild("HumanoidRootPart")
            local hm = c2 and c2:FindFirstChildOfClass("Humanoid")
            if tr and hm and hm.Health > 0 then
              local d = (tr.Position - root.Position).Magnitude
              if d < minD then
                minD, best = d, tr
              end
            end
          end
        end
        return best
      end
      local function chStop()
        if chConn then
          pcall(function()
            chConn:Disconnect()
          end)
          chConn = nil
        end
        local ch = u.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        local hm = ch and ch:FindFirstChildOfClass("Humanoid")
        if hm and chPrevAutoRotate ~= nil then
          hm.AutoRotate = chPrevAutoRotate
          hm.PlatformStand = false
          pcall(function()
            hm:ChangeState(Enum.HumanoidStateType.Running)
          end)
        end
        if root and chPrevAutoRotate ~= nil then
          root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
          root.AssemblyAngularVelocity = Vector3.zero
        end
        chPrevAutoRotate = nil
      end
      local chb = {
        CFG = {
          FOLLOW_SPEED = 60,
          ACTIVATE_DISTANCE = 13,
          MIN_FOLLOW_DISTANCE = 1,
          PREDICTION_TIME = 0.22,
          PREDICT_AHEAD = 3,
          MAX_VELOCITY_CHANGE = 150,
          VELOCITY_SMOOTHING = 0.2,
          MAX_HORIZONTAL_VELOCITY = 80,
          SERVER_TICKRATE = 1 / 60,
          MIN_PING_COMPENSATION = 0.03,
          MAX_PING_COMPENSATION = 0.25,
          ACCELERATION_PREDICTION_WEIGHT = 0.3,
          DIRECTION_CHANGE_DETECTION_TIME = 0.12,
          QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
          GRAVITY = 196.2,
          AIR_CONTROL_FACTOR = 0.8,
          MIN_AIRBORNE_TIME = 0.08,
        },
        Z = {},
        lastPing = 0,
      }
      function chb.reset()
        local zz = chb.Z
        zz.lastTargetPos = nil
        zz.targetVelocity = Vector3.zero
        zz.smoothedVelocity = Vector3.zero
        zz.velocityHistory = {}
        zz.accelerationHistory = {}
        zz.aerialVelocityHistory = {}
        zz.previousDirection = nil
        zz.airborneTime = 0
        zz.currentPing = zz.currentPing or 0.1
        zz.realPingMs = zz.realPingMs or 0
        zz.lastDirectionChangeTime = zz.lastDirectionChangeTime or 0
        zz.lastActivationTime = zz.lastActivationTime or 0
      end
      chb.reset()
      function chb.avg(history)
        if #history == 0 then
          return Vector3.zero
        end
        local total = Vector3.zero
        for _, v in ipairs(history) do
          total = total + v
        end
        return total / #history
      end
      function chb.push(history, value, maximum)
        table.insert(history, value)
        if #history > maximum then
          table.remove(history, 1)
        end
      end
      function chb.nearest(root)
        local best, bestD = nil, math.huge
        for _, pl in ipairs(z:GetPlayers()) do
          if pl ~= u and pl.Character then
            local tr = pl.Character:FindFirstChild("HumanoidRootPart")
            local th = pl.Character:FindFirstChildOfClass("Humanoid")
            if tr and th and th.Health > 0 then
              local dd = (root.Position - tr.Position).Magnitude
              if dd < bestD then
                best, bestD = pl, dd
              end
            end
          end
        end
        return best
      end
      function chb.rotate(root, direction)
        if direction.Magnitude < 0.01 then
          return
        end
        local axis = root.CFrame.LookVector:Cross(direction.Unit)
        local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
        root.AssemblyAngularVelocity = axis.Magnitude > 0.01 and axis.Unit * angle * 80 or Vector3.zero
      end
      function chb.samplePing()
        local ok, value = pcall(function()
          return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        local zz = chb.Z
        if ok and type(value) == "number" then
          zz.realPingMs = math.floor(value)
        end
        zz.currentPing = math.clamp(zz.realPingMs / 1000, chb.CFG.MIN_PING_COMPENSATION, chb.CFG.MAX_PING_COMPENSATION)
      end
      local function chStart()
        if chConn then
          return
        end
        local hm0 = u.Character and u.Character:FindFirstChildOfClass("Humanoid")
        if hm0 then
          if chPrevAutoRotate == nil then
            chPrevAutoRotate = hm0.AutoRotate
          end
          hm0.AutoRotate = false
        end
        chb.reset()
        chb.lastPing = 0
        chConn = D.RenderStepped:Connect(function(dt)
          if not y.Aimbot then
            return
          end
          local zz, CFG = chb.Z, chb.CFG
          CFG.FOLLOW_SPEED = _G.__ZDuelsGetAimbotSpeed()
          local now = os.clock()
          if now - chb.lastPing >= 0.5 then
            chb.lastPing = now
            chb.samplePing()
          end
          local ch = u.Character
          local root = ch and ch:FindFirstChild("HumanoidRootPart")
          local hm = ch and ch:FindFirstChildOfClass("Humanoid")
          if not root or not hm or hm.Health <= 0 then
            return
          end
          hm.AutoRotate = false
          local bat = ch:FindFirstChildOfClass("Tool") or chFindBat()
          if bat and bat.Parent ~= ch then
            pcall(hm.EquipTool, hm, bat)
          end
          local targetPlayer = chb.nearest(root)
          local targetChar = targetPlayer and targetPlayer.Character
          local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
          local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
          if not targetRoot or not targetHum or targetHum.Health <= 0 then
            chb.reset()
            return
          end
          local targetPos = targetRoot.Position
          local safeDt = math.max(dt, 1 / 240)
          if zz.lastTargetPos then
            local rawVelocity = (targetPos - zz.lastTargetPos) / safeDt
            local velocityDelta = rawVelocity - zz.targetVelocity
            if velocityDelta.Magnitude > CFG.MAX_VELOCITY_CHANGE then
              rawVelocity = zz.targetVelocity + velocityDelta.Unit * CFG.MAX_VELOCITY_CHANGE
            end
            local horizontal = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
            if horizontal.Magnitude > CFG.MAX_HORIZONTAL_VELOCITY then
              horizontal = horizontal.Unit * CFG.MAX_HORIZONTAL_VELOCITY
              rawVelocity = Vector3.new(horizontal.X, rawVelocity.Y, horizontal.Z)
            end
            chb.push(zz.accelerationHistory, (rawVelocity - zz.targetVelocity) / safeDt, 4)
            chb.push(zz.velocityHistory, rawVelocity, 8)
            zz.targetVelocity = rawVelocity
            zz.smoothedVelocity = zz.smoothedVelocity:Lerp(rawVelocity, CFG.VELOCITY_SMOOTHING)
          end
          zz.lastTargetPos = targetPos
          local airborne = targetHum.FloorMaterial == Enum.Material.Air
          zz.airborneTime = airborne and (zz.airborneTime + safeDt) or 0
          if airborne and zz.airborneTime >= CFG.MIN_AIRBORNE_TIME then
            chb.push(zz.aerialVelocityHistory, zz.targetVelocity, 6)
          elseif not airborne then
            zz.aerialVelocityHistory = {}
          end
          local predictionVelocity = zz.smoothedVelocity
          if airborne and #zz.aerialVelocityHistory > 0 then
            local aerial = chb.avg(zz.aerialVelocityHistory)
            predictionVelocity = Vector3.new(aerial.X, zz.targetVelocity.Y, aerial.Z) * CFG.AIR_CONTROL_FACTOR
          end
          local quickTurn = false
          local horizontalVelocity = Vector3.new(zz.targetVelocity.X, 0, zz.targetVelocity.Z)
          if horizontalVelocity.Magnitude > 5 then
            local direction = horizontalVelocity.Unit
            if zz.previousDirection and zz.previousDirection:Dot(direction) < 0.5 then
              quickTurn = tick() - zz.lastDirectionChangeTime < CFG.DIRECTION_CHANGE_DETECTION_TIME
              zz.lastDirectionChangeTime = tick()
            end
            zz.previousDirection = direction
          end
          local serverDelay = zz.currentPing + CFG.SERVER_TICKRATE
          if quickTurn then
            serverDelay = serverDelay * CFG.QUICK_DIRECTION_CHANGE_MULTIPLIER
          end
          local predicted = targetPos + predictionVelocity * serverDelay
          local acceleration = chb.avg(zz.accelerationHistory)
          predicted = predicted + acceleration * CFG.ACCELERATION_PREDICTION_WEIGHT * (serverDelay * serverDelay * 0.5)
          local predictionTime = CFG.PREDICTION_TIME * 1.1
          if airborne then
            predicted = predicted + predictionVelocity * predictionTime
            predicted = predicted + Vector3.new(0, -0.5 * CFG.GRAVITY * predictionTime * predictionTime, 0)
          else
            predicted = predicted + predictionVelocity * predictionTime
          end
          local flatPrediction = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
          if flatPrediction.Magnitude > 1 then
            predicted = predicted + flatPrediction.Unit * CFG.PREDICT_AHEAD
          end
          local toTarget = predicted - root.Position
          chb.rotate(root, toTarget)
          if (targetPos - root.Position).Magnitude <= CFG.ACTIVATE_DISTANCE and tick() - zz.lastActivationTime >= 0.3 then
            if bat and y["Auto Bat"] == true then
              pcall(bat.Activate, bat)
            end
            zz.lastActivationTime = tick()
          end
          if toTarget.Magnitude > CFG.MIN_FOLLOW_DISTANCE then
            root.AssemblyLinearVelocity = toTarget.Unit * CFG.FOLLOW_SPEED
          else
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
          end
        end)
      end
      local bp = { v2 = false }
      function bp.dirTo(from, goal)
        local now = os.clock()
        local st = bp.path
        if st and st.goal and (st.goal - goal).Magnitude > 4 then
          st = nil
        end
        if not st then
          st = { goal = goal, wp = nil, i = 1, computing = false, last = 0 }
          bp.path = st
        end
        if not st.computing and (not st.wp or (now - st.last) > 0.35) then
          st.computing = true
          st.last = now
          st.goal = goal
          local origin = from
          task.spawn(function()
            local ok, path = pcall(function()
              local pth = game:GetService("PathfindingService"):CreatePath({
                AgentRadius = 2.5,
                AgentHeight = 5,
                AgentCanJump = true,
                WaypointSpacing = 6,
              })
              pth:ComputeAsync(origin, goal)
              return pth
            end)
            if bp.path ~= st then
              return
            end
            st.computing = false
            if ok and path and path.Status == Enum.PathStatus.Success then
              local pts = path:GetWaypoints()
              st.wp = pts
              st.i = math.min(2, #pts)
            else
              st.wp = nil
            end
          end)
        end
        local wp = st.wp
        if not wp or #wp == 0 then
          return nil
        end
        while st.i <= #wp do
          local wpPos = wp[st.i].Position
          local dv = Vector3.new(wpPos.X - from.X, 0, wpPos.Z - from.Z)
          if dv.Magnitude > 4 then
            if dv.Magnitude < 0.01 then
              return nil
            end
            return dv.Unit
          end
          st.i = st.i + 1
        end
        return nil
      end
      function bp.stop()
        if bp.conn then
          pcall(function()
            bp.conn:Disconnect()
          end)
          bp.conn = nil
        end
        bp.path = nil
        bp.cd = false
        local ch = u.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        local hm = ch and ch:FindFirstChildOfClass("Humanoid")
        if hm and bp.prev ~= nil then
          hm.AutoRotate = bp.prev
          hm.PlatformStand = false
          pcall(function()
            hm:ChangeState(Enum.HumanoidStateType.Running)
          end)
        end
        if root and bp.prev ~= nil then
          root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
          root.AssemblyAngularVelocity = Vector3.zero
        end
        bp.prev = nil
      end
      function bp.start()
        if bp.conn then
          return
        end
        local hm0 = u.Character and u.Character:FindFirstChildOfClass("Humanoid")
        if hm0 then
          if bp.prev == nil then
            bp.prev = hm0.AutoRotate
          end
          hm0.AutoRotate = false
        end
        bp.conn = D.RenderStepped:Connect(function()
          if not y.Aimbot then
            return
          end
          local ch = u.Character
          if not ch then
            return
          end
          local root = ch:FindFirstChild("HumanoidRootPart")
          local hm = ch:FindFirstChildOfClass("Humanoid")
          if not root or not hm then
            return
          end
          local bat = ch:FindFirstChildOfClass("Tool")
          if not bat then
            bat = chFindBat()
            if bat then
              pcall(hm.EquipTool, hm, bat)
            end
          end
          local target = chClosest()
          if not target then
            return
          end
          local myPos = root.Position
          local targetPos = target.Position
          local direction = targetPos - myPos
          local flatDir = Vector3.new(direction.X, 0, direction.Z)
          if flatDir.Magnitude > 0 then
            flatDir = flatDir.Unit
          else
            flatDir = Vector3.zero
          end
          if flatDir.Magnitude > 0 then
            local pd = bp.dirTo(myPos, targetPos)
            if pd then
              flatDir = pd
            end
          end
          local spd = _G.__ZDuelsGetAimbotSpeed()
          local desiredHeight = targetPos.Y + (bp.v2 and 0 or 3.7)
          local yVel = (desiredHeight - myPos.Y) * 19.5
          if not bp.v2 and hm.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
          end
          yVel = math.clamp(yVel, -70, 110)
          local desiredVel = Vector3.new(flatDir.X * spd, yVel, flatDir.Z * spd)
          root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
          if direction.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, targetPos)
            local rx, ry, rz = (root.CFrame:Inverse() * goalCF):ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity =
              root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
          end
          if y["Auto Bat"] == true and bat and chIsBat(bat) and bat.Parent == ch and not bp.cd then
            bp.cd = true
            pcall(bat.Activate, bat)
            task.delay(0.08, function()
              bp.cd = false
            end)
          end
        end)
      end
      _cypherStartFollowing = function(ch)
        if _G.__ZDuelsAimbotVersion == "Clean Hub" then
          chStart()
        elseif _G.__ZDuelsAimbotVersion == "Bypass" then
          bp.v2 = false
          bp.start()
        elseif _G.__ZDuelsAimbotVersion == "Bypass V2" then
          bp.v2 = true
          bp.start()
        else
          eN(ch)
        end
      end
      _cypherStop = function()
        jN()
        chStop()
        bp.stop()
      end
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
            _cypherStartFollowing(u.Character)
          end)
        else
          _cypherStop()
          if _G.__refreshSpeedBoost then
            _G.__refreshSpeedBoost()
          end
        end
      end
      _G.__ZDuelsTrackStopper(_cypherStop)
    end
    T["Lagger Aimbot"] = function()
      y["Lagger Aimbot"] = false
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
      workspace.CurrentCamera, Color3.fromRGB(176, 176, 176), Color3.fromRGB(71, 71, 71)
    local function SN(ZN)
      if _G.__ZDuelsGuiTheme == "GUI 3" then
        return Color3.fromRGB(176, 176, 176), Color3.fromRGB(176, 176, 176)
      end
      if _G.__ZDuelsGuiTheme == "GUI 2" then
        return ON, ON
      end
      return ZN or _G.__ZDuelsThemeAccent or (Color3.fromRGB(246, 246, 246)),
        Color3.fromRGB(0, 0, 0)
    end
    local function ZN()
      local YN, jN = SN()
      local eN = { Tracer = Drawing.new("Line"), Highlight = Instance.new("Highlight"), Lines = {} }
      eN.Tracer.Color = Color3.fromRGB(176, 176, 176)
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
      GN.TextColor3 = _G.__ZDuelsGuiTheme == "GUI 3" and (Color3.fromRGB(176, 176, 176))
        or (_G.__ZDuelsGuiTheme == "GUI 2" and ON or (_G.__ZDuelsHalloween and (Color3.fromRGB(255, 140, 0)) or (Color3.fromRGB(246, 246, 246))))
      GN.TextSize = 15
      GN.Font = Enum.Font.GothamBold
      GN.TextStrokeColor3 = _G.__ZDuelsGuiTheme == "GUI 2" and iN or (Color3.fromRGB(0, 0, 0))
      GN.TextStrokeTransparency = 0
      GN.TextXAlignment = Enum.TextXAlignment.Center
      GN.TextYAlignment = Enum.TextYAlignment.Center
      GN.ZIndex = 5
      GN.Parent = YN
      KN = Instance.new("UIStroke")
      KN.Color = _G.__ZDuelsGuiTheme == "GUI 2" and iN or (Color3.fromRGB(0, 0, 0))
      KN.Thickness = 2.2
      KN.Transparency = 0.12
      KN.Parent = GN
      for qN = 1, 14, 1 do
        qN = Drawing.new("Line")
        qN.Color = Color3.fromRGB(176, 176, 176)
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
    function _G.__ZDuelsRefreshESPTheme(YN, jN)
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
            qN.NameLabel.TextColor3 = _G.__ZDuelsGuiTheme == "GUI 3"
                and (Color3.fromRGB(176, 176, 176))
              or (_G.__ZDuelsGuiTheme == "GUI 2" and ON or (_G.__ZDuelsHalloween and (Color3.fromRGB(255, 140, 0)) or (Color3.fromRGB(246, 246, 246))))
            qN.NameLabel.TextStrokeColor3 = _G.__ZDuelsGuiTheme == "GUI 2" and iN
              or (Color3.fromRGB(0, 0, 0))
          end
          if qN.NameOutline then
            qN.NameOutline.Color = _G.__ZDuelsGuiTheme == "GUI 2" and iN
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
            local LN = _G.__ZDuelsGuiTheme == "GUI 2"
            qN.NameLabel.TextColor3 = _G.__ZDuelsGuiTheme == "GUI 3"
                and (Color3.fromRGB(176, 176, 176))
              or (LN and ON or (_G.__ZDuelsHalloween and (Color3.fromRGB(255, 140, 0)) or (Color3.fromRGB(246, 246, 246))))
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
    _G.__ZDuelsTrackStopper(LN)
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
    local R = _G.__ZDuelsPlayerTracerLine
    if R then
      pcall(function()
        R:Remove()
      end)
    end
    local R = Instance.new("ScreenGui")
    R.Name = "ZDuelsPlayerTracerOverlay"
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
    _G.__ZDuelsPlayerTracerLine = {
      Remove = function()
        R:Destroy()
      end,
    }
    _G.__ZDuelsTrackStopper(function()
      R:Destroy()
    end)
    local R = { scanElapsed = math.huge, targetRoot = nil }
    _G.__ZDuelsTrackConn(D.RenderStepped:Connect(function(c)
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
    YN.BackgroundColor3 = Color3.fromRGB(212, 212, 212)
    YN.BorderSizePixel = 0
    YN.Text = "x"
    YN.TextColor3 = Color3.fromRGB(141, 141, 141)
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
    c.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    c.BackgroundTransparency = 0.55
    c.BorderSizePixel = 0
    c.Text = "+ Add Custom Speed"
    c.TextColor3 = Color3.fromRGB(176, 176, 176)
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
      QN.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
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
      UN.TextColor3 = Color3.fromRGB(169, 169, 169)
      UN.TextSize = 9
      UN.Font = Enum.Font.GothamBold
      UN.TextXAlignment = Enum.TextXAlignment.Left
      local LN = Instance.new("TextBox", QN)
      LN.Size = UDim2.new(0, 120, 0, 20)
      LN.Position = UDim2.new(0, 8, 0, 21)
      LN.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
      LN.BorderSizePixel = 0
      LN.Text = ""
      LN.PlaceholderText = "My Speed"
      LN.Font = Enum.Font.GothamBold
      LN.TextSize = 11
      LN.TextColor3 = Color3.fromRGB(157, 157, 157)
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
      UN.TextColor3 = Color3.fromRGB(169, 169, 169)
      UN.TextSize = 9
      UN.Font = Enum.Font.GothamBold
      UN.TextXAlignment = Enum.TextXAlignment.Left
      local iN = Instance.new("TextBox", QN)
      iN.Size = UDim2.new(0, 56, 0, 20)
      iN.Position = UDim2.new(0, 140, 0, 21)
      iN.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
      iN.BorderSizePixel = 0
      iN.Text = "59"
      iN.Font = Enum.Font.GothamBold
      iN.TextSize = 12
      iN.TextColor3 = Color3.fromRGB(157, 157, 157)
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
      UN.TextColor3 = Color3.fromRGB(169, 169, 169)
      UN.TextSize = 9
      UN.Font = Enum.Font.GothamBold
      UN.TextXAlignment = Enum.TextXAlignment.Left
      local SN = Instance.new("TextBox", QN)
      SN.Size = UDim2.new(0, 56, 0, 20)
      SN.Position = UDim2.new(0, 204, 0, 21)
      SN.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
      SN.BorderSizePixel = 0
      SN.Text = "29"
      SN.Font = Enum.Font.GothamBold
      SN.TextSize = 12
      SN.TextColor3 = Color3.fromRGB(157, 157, 157)
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
      UN.BackgroundColor3 = Color3.fromRGB(176, 176, 176)
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
      ZN.TextColor3 = Color3.fromRGB(154, 154, 154)
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
    _N.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    _N.BorderSizePixel = 0
    _N.Text = string.upper(_G.__autoplayMode or "Full")
    _N.TextColor3 = Color3.fromRGB(238, 238, 238)
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
      QN.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
      QN.BorderSizePixel = 0
      QN.Text = "V1"
      QN.TextColor3 = Color3.fromRGB(238, 238, 238)
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
        QN.TextColor3 = Color3.fromRGB(238, 238, 238)
        QN.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
        QN.Position = UDim2.new(1, -120, 0.5, -10)
        local ON = LN()
        if ON then
          ON.Visible = true
        end
      end
      local function ON()
        G = "v2"
        QN.Text = "V2"
        QN.TextColor3 = Color3.fromRGB(238, 238, 238)
        QN.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
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
          LN.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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
  _G.__ZDuelsInfJumpMode = _G.__ZDuelsInfJumpMode or "hold"
  fN(U, "Unwalk", "Unwalk")
  _N = fN(U, "Inf Jump", "Inf Jump")
  if _N then
    local QN = Instance.new("TextButton", _N)
    QN.Name = "InfJumpModeBtn"
    QN.Size = UDim2.new(0, 66, 0, 20)
    QN.Position = UDim2.new(1, -74, 0.5, -10)
    QN.AnchorPoint = Vector2.new(0, 0)
    QN.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    QN.BorderSizePixel = 0
    QN.Text = _G.__ZDuelsInfJumpMode == "hold" and "HOLD" or "MANUAL"
    QN.TextColor3 = Color3.fromRGB(238, 238, 238)
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
      QN.Text = _G.__ZDuelsInfJumpMode == "hold" and "HOLD" or "MANUAL"
      QN.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
      QN.TextColor3 = Color3.fromRGB(238, 238, 238)
      UN.Color = Color3.fromRGB(255, 255, 255)
      UN.Thickness = 1
      QN.TextStrokeTransparency = 1
    end
    LN()
    v(QN, function()
      _G.__ZDuelsInfJumpMode = _G.__ZDuelsInfJumpMode == "hold" and "manual" or "hold"
      LN()
      if y["Inf Jump"] then
        if _G.__ZDuelsInfJumpMode == "hold" then
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
  function _G.__ZDuelsAntiDieGuiEnabled()
    return y["Anti Die"] == true
  end
  T["Anti Die"] = function(U)
    pcall(function()
      if _G.__ZDuelsAntiDieSource then
        _G.__ZDuelsAntiDieSource("toggle", U)
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
      ON.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
      ON.BorderSizePixel = 0
      ON.Text = "V" .. tostring(_G.__batVersion or 1)
      ON.TextColor3 = Color3.fromRGB(238, 238, 238)
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
      SN.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
      SN.BorderSizePixel = 0
      SN.Text = ""
      SN.AutoButtonColor = false
      SN.ZIndex = 30
      Instance.new("UICorner", SN).CornerRadius = UDim.new(0, 4)
      local ZN = Instance.new("UIStroke", SN)
      ZN.Color = Color3.fromRGB(181, 181, 181)
      ZN.Thickness = 1
      ZN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      LN = Instance.new("TextLabel", SN)
      LN.Size = UDim2.new(0, 30, 1, 0)
      LN.Position = UDim2.new(0, 5, 0, 0)
      LN.BackgroundTransparency = 1
      LN.Text = "GUI"
      LN.TextColor3 = Color3.fromRGB(240, 240, 240)
      LN.Font = Enum.Font.GothamBold
      LN.TextSize = 8
      LN.TextXAlignment = Enum.TextXAlignment.Left
      LN.ZIndex = 31
      local YN = Instance.new("Frame", SN)
      YN.Size = UDim2.new(0, 24, 0, 12)
      YN.Position = UDim2.new(1, -29, 0.5, -6)
      YN.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
      YN.BorderSizePixel = 0
      YN.ZIndex = 31
      Instance.new("UICorner", YN).CornerRadius = UDim.new(1, 0)
      local jN = Instance.new("Frame", YN)
      jN.Size = UDim2.new(0, 8, 0, 8)
      jN.Position = UDim2.new(0, 2, 0.5, -4)
      jN.BackgroundColor3 = Color3.fromRGB(171, 171, 171)
      jN.BorderSizePixel = 0
      jN.ZIndex = 32
      Instance.new("UICorner", jN).CornerRadius = UDim.new(1, 0)
      LN = Instance.new("Frame", QN)
      LN.Name = "BatV2DistanceConfig"
      LN.Size = UDim2.new(1, -2, 0, 78)
      LN.Position = UDim2.new(0, 1, 0, 4)
      LN.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
      LN.BackgroundTransparency = 0.2
      LN.BorderSizePixel = 0
      LN.ZIndex = 22
      Instance.new("UICorner", LN).CornerRadius = UDim.new(0, 6)
      local eN = Instance.new("UIStroke", LN)
      eN.Color = Color3.fromRGB(82, 82, 82)
      eN.Transparency = 0.25
      eN.Thickness = 1
      eN = Instance.new("TextLabel", LN)
      eN.Size = UDim2.new(1, -92, 0, 38)
      eN.Position = UDim2.new(0, 10, 0, 0)
      eN.BackgroundTransparency = 1
      eN.Text = "DISTANCIA TP (STUDS)"
      eN.TextColor3 = Color3.fromRGB(199, 199, 199)
      eN.Font = Enum.Font.GothamBold
      eN.TextSize = 10
      eN.TextXAlignment = Enum.TextXAlignment.Left
      eN.ZIndex = 23
      local qN = Instance.new("TextBox", LN)
      qN.Name = "BatV2DistanceInput"
      qN.Size = UDim2.new(0, 70, 0, 26)
      qN.Position = UDim2.new(1, -80, 0, 6)
      qN.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
      qN.BackgroundTransparency = 0.05
      qN.BorderSizePixel = 0
      qN.ClearTextOnFocus = false
      qN.Text = tostring(_G.__tpBatV2Distance or 8)
      qN.TextColor3 = Color3.fromRGB(248, 248, 248)
      qN.Font = Enum.Font.GothamBold
      qN.TextSize = 11
      qN.TextXAlignment = Enum.TextXAlignment.Center
      qN.ZIndex = 24
      Instance.new("UICorner", qN).CornerRadius = UDim.new(0, 4)
      eN = Instance.new("UIStroke", qN)
      eN.Color = Color3.fromRGB(144, 144, 144)
      eN.Transparency = 0.2
      eN.Thickness = 1
      _.distanceInput = qN
      eN = Instance.new("TextLabel", LN)
      eN.Size = UDim2.new(1, -92, 0, 34)
      eN.Position = UDim2.new(0, 10, 0, 40)
      eN.BackgroundTransparency = 1
      eN.Text = "VERSION TP BAT"
      eN.TextColor3 = Color3.fromRGB(199, 199, 199)
      eN.Font = Enum.Font.GothamBold
      eN.TextSize = 10
      eN.TextXAlignment = Enum.TextXAlignment.Left
      eN.ZIndex = 23
      eN.Visible = true
      local eN = Instance.new("TextButton", LN)
      eN.Name = "BatVersionInsideConfig"
      eN.Size = UDim2.new(0, 70, 0, 26)
      eN.Position = UDim2.new(1, -80, 0, 44)
      eN.BackgroundColor3 = Color3.fromRGB(101, 101, 101)
      eN.BorderSizePixel = 0
      eN.Text = "V" .. tostring(_G.__batVersion or 1)
      eN.TextColor3 = Color3.fromRGB(248, 248, 248)
      eN.Font = Enum.Font.GothamBold
      eN.TextSize = 11
      eN.AutoButtonColor = false
      eN.Active = true
      eN.Visible = true
      eN.ZIndex = 24
      Instance.new("UICorner", eN).CornerRadius = UDim.new(0, 4)
      local LN = Instance.new("UIStroke", eN)
      LN.Color = Color3.fromRGB(176, 176, 176)
      LN.Transparency = 0.15
      LN.Thickness = 1
      local KN = false
      local function GN()
        local IN = KN
        SN.Visible = true
        SN.BackgroundColor3 = IN and (Color3.fromRGB(101, 101, 101)) or (Color3.fromRGB(48, 48, 48))
        ZN.Color = IN and (Color3.fromRGB(176, 176, 176)) or (Color3.fromRGB(181, 181, 181))
        YN.BackgroundColor3 = IN and (Color3.fromRGB(151, 151, 151)) or (Color3.fromRGB(27, 27, 27))
        jN.BackgroundColor3 = IN and (Color3.fromRGB(248, 248, 248))
          or (Color3.fromRGB(171, 171, 171))
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
        ON.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
        ON.TextColor3 = Color3.fromRGB(248, 248, 248)
        iN.Color = Color3.fromRGB(225, 225, 225)
        eN.Text = "V" .. tostring(_G.__batVersion or 1)
        eN.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
        LN.Color = Color3.fromRGB(225, 225, 225)
        qN.TextEditable = true
        qN.Text = tostring(_G.__tpBatV2Distance or 8)
        qN.BackgroundTransparency = 0.05
        qN.TextColor3 = Color3.fromRGB(248, 248, 248)
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
      local U = workspace:FindFirstChild("ZDuelsTPBatLastPosition")
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
        KN.Name = "ZDuelsTPBatLastPosition"
        KN.Shape = Enum.PartType.Ball
        KN.Size = Vector3.new(3, 3, 3)
        KN.Color = Color3.fromRGB(167, 167, 167)
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
        qN.Color3 = Color3.fromRGB(176, 176, 176)
        qN.Transparency = 0.05
        qN.AlwaysOnTop = true
        qN.Visible = true
        qN.ZIndex = 10
        qN.Parent = KN
        eN = Instance.new("Highlight")
        eN.Name = "LastPositionHighlight"
        eN.Adornee = KN
        eN.FillColor = Color3.fromRGB(167, 167, 167)
        eN.FillTransparency = 0.15
        eN.OutlineColor = Color3.fromRGB(176, 176, 176)
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
        eN.TextColor3 = Color3.fromRGB(233, 233, 233)
        eN.TextStrokeColor3 = Color3.fromRGB(65, 65, 65)
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
    _G.__ZDuelsTrackConn(UN)
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
    _G.__ZDuelsTrackStopper(function()
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
        if o.alive and _G.__ZDUELS_STATE == o then
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
              if _G.__ZDUELS_STATE ~= o then
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
            if _G.__ZDUELS_STATE ~= o then
              return
            end
            pcall(function()
              if _G.__ZDuelsAntiDieSet then
                _G.__ZDuelsAntiDieSet(false)
              end
            end)
          end)
        else
          pcall(function()
            if _G.__ZDuelsAntiDieSet then
              _G.__ZDuelsAntiDieSet(false)
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
          if _G.__ZDuelsAntiDieSet then
            _G.__ZDuelsAntiDieSet(true)
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
      _G.__ZDuelsTrackStopper(function()
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
    local barW_full = 260
    local barH = 52
    local pbFrame = Instance.new("Frame", h)
    pbFrame.Name = "ZDuelsAutoGrabBar"
    pbFrame.AnchorPoint = Vector2.new(0, 0)
    local savedPos = _G._ZDuelsHub_UI_AutoGrabBarPos
    if savedPos and savedPos.x ~= nil and savedPos.y ~= nil then
      pbFrame.Position = UDim2.new(savedPos.xs or 0, savedPos.x, savedPos.ys or 0, savedPos.y)
    else
      pbFrame.Position = UDim2.new(0.5, -barW_full / 2, 1, -75)
    end
    pbFrame.Size = UDim2.fromOffset(barW_full, barH)
    pbFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 16)
    pbFrame.BackgroundTransparency = 0.05
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    pbFrame.Visible = true
    pbFrame.ZIndex = 300
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 14)
    local pbStroke = Instance.new("UIStroke", pbFrame)
    pbStroke.Name = "PBStroke"
    pbStroke.Color = Color3.fromRGB(85, 35, 120)
    pbStroke.Thickness = 1.2
    pbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local pbScale = Instance.new("UIScale", pbFrame)
    pbScale.Scale = 1

    local bgImg = Instance.new("ImageLabel", pbFrame)
    bgImg.Name = "StealBarBackground"
    bgImg.Size = UDim2.fromScale(1, 1)
    bgImg.BackgroundTransparency = 1
    bgImg.BorderSizePixel = 0
    bgImg.ScaleType = Enum.ScaleType.Crop
    bgImg.ImageTransparency = 0
    bgImg.ZIndex = 301
    Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 14)
    local bgShade = Instance.new("Frame", pbFrame)
    bgShade.Name = "StealBarImageShade"
    bgShade.Size = UDim2.fromScale(1, 1)
    bgShade.BackgroundColor3 = Color3.fromRGB(12, 10, 16)
    bgShade.BackgroundTransparency = 0.7
    bgShade.BorderSizePixel = 0
    bgShade.ZIndex = 301
    Instance.new("UICorner", bgShade).CornerRadius = UDim.new(0, 14)
    _G._ZDuelsHub_AutoGrabBgSync = function(idx)
      pcall(function()
        local imgs = _G._ZDuelsHub_BgImages
        local i = math.clamp(tonumber(idx) or tonumber(_G._ZDuelsHub_UI_BgIndex) or 1, 1, 4)
        local asset = (_G.__ZDuelsHalloween and _G.__ZDuelsHalloweenImg) or (imgs and imgs[i]) or ""
        if bgImg and bgImg.Parent then
          bgImg.Image = asset
          bgImg.Visible = asset ~= ""
          bgShade.Visible = asset ~= ""
        end
      end)
    end
    _G._ZDuelsHub_AutoGrabBgSync()
    _G.__ZDuelsApplyAutoStealBarTheme = function() end

    local progressPct = Instance.new("TextLabel", pbFrame)
    progressPct.Name = "ProgressPct"
    progressPct.Size = UDim2.new(0, 70, 0, 18)
    progressPct.Position = UDim2.new(0, 14, 0, 6)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextSize = 14
    progressPct.TextXAlignment = Enum.TextXAlignment.Left
    progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    progressPct.TextStrokeTransparency = 0.35
    progressPct.ZIndex = 305
    local fpsLbl = Instance.new("TextLabel", pbFrame)
    fpsLbl.Name = "FPSNeon"
    fpsLbl.Size = UDim2.new(0, 150, 0, 18)
    fpsLbl.Position = UDim2.new(1, -164, 0, 6)
    fpsLbl.BackgroundTransparency = 1
    fpsLbl.Text = "FPS --  PING --ms"
    fpsLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    fpsLbl.Font = Enum.Font.GothamBold
    fpsLbl.TextSize = 12
    fpsLbl.TextXAlignment = Enum.TextXAlignment.Right
    fpsLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    fpsLbl.TextStrokeTransparency = 0.35
    fpsLbl.ZIndex = 305

    local progressRow = Instance.new("Frame", pbFrame)
    progressRow.Name = "ProgressRow"
    progressRow.Size = UDim2.new(1, -28, 0, 12)
    progressRow.Position = UDim2.new(0, 14, 0, 30)
    progressRow.BackgroundTransparency = 1
    progressRow.ZIndex = 302
    local fillRegion = Instance.new("Frame", progressRow)
    fillRegion.Name = "FillRegion"
    fillRegion.Size = UDim2.new(1, 0, 1, 0)
    fillRegion.BackgroundColor3 = Color3.fromRGB(18, 14, 22)
    fillRegion.BackgroundTransparency = 0.1
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    fillRegion.ZIndex = 303
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(1, 0)
    local trackStroke = Instance.new("UIStroke", fillRegion)
    trackStroke.Name = "UIStroke"
    trackStroke.Color = Color3.fromRGB(50, 25, 75)
    trackStroke.Thickness = 1
    local progressFill = Instance.new("Frame", fillRegion)
    progressFill.Name = "StealFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(140, 50, 250)
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 304
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient", progressFill)
    fillGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 35, 240)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 60, 255)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(185, 95, 255)),
    })
    fillGrad.Rotation = 0

    local dragging, dragStart, startPos = false, nil, nil
    pbFrame.InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = pbFrame.Position
      end
    end)
    _G.__ZDuelsTrackConn(C.InputChanged:Connect(function(input)
      if not dragging or not dragStart or not startPos then return end
      if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
      local d = input.Position - dragStart
      pbFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + d.X,
        startPos.Y.Scale,
        startPos.Y.Offset + d.Y
      )
    end))
    _G.__ZDuelsTrackConn(C.InputEnded:Connect(function(input)
      if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = false
        dragStart, startPos = nil, nil
        local pos = pbFrame.Position
        _G._ZDuelsHub_UI_AutoGrabBarPos = {
          x = pos.X.Offset,
          y = pos.Y.Offset,
          xs = pos.X.Scale,
          ys = pos.Y.Scale,
        }
        pcall(oN)
      end
    end))

    function _G.__ZDuelsGuiPositionResetters.AutoGrab()
      pbFrame.Position = UDim2.new(0.5, -barW_full / 2, 1, -75)
      _G._ZDuelsHub_UI_AutoGrabBarPos = nil
    end

    do
      local frames, acc = 0, 0
      _G.__ZDuelsTrackConn(D.RenderStepped:Connect(function(dt)
        if not pbFrame.Visible then
          frames, acc = 0, 0
          return
        end
        frames += 1
        acc += dt
        if acc >= 0.5 then
          local fps = math.floor(frames / acc + 0.5)
          frames, acc = 0, 0
          local ping = 0
          pcall(function() ping = u:GetNetworkPing() * 1000 end)
          if fpsLbl and fpsLbl.Parent then
            fpsLbl.Text = string.format("FPS %d  PING %dms", fps, math.floor(ping + 0.5))
          end
        end
      end))
    end

    local st = {
      displayProgress = 0,
      radiusProgress = 0,
      targetInRadius = false,
      radiusElapsed = 0,
      uiElapsed = 0,
      lastVisible = nil,
      lastPercent = nil,
    }
    _G.__ZDuelsTrackConn(D.Heartbeat:Connect(function(dt)
      st.uiElapsed = st.uiElapsed + (dt or 0)
      if st.uiElapsed < 1/60 then return end
      local step = st.uiElapsed
      st.uiElapsed = 0
      local autoOn = y["auto steal"] == true
      if not autoOn and (I or 0) <= 0 and st.displayProgress <= 0.001 then
        if st.lastVisible ~= false then
          pbFrame.Visible = false
          st.lastVisible = false
        end
        return
      end
      st.radiusElapsed = st.radiusElapsed + step
      local blocked = _G.__ZDuelsAutoGrabRagdollBlocked == true
      if blocked then
        st.targetInRadius = false
        st.radiusProgress = 0
      end
      if st.radiusElapsed >= 0.25 then
        st.radiusElapsed = 0
        st.targetInRadius = false
        local busy = StealState and StealState.active or F and F.busy or V3New and V3New.busy or V2Grab and V2Grab.busy
        if not blocked and not busy and autoOn and _G.__ZDuelsAutoGrabTargetInRadius then
          local radius = math.clamp(tonumber(O.Radius) or 65, 10, 150)
          local ok, res = pcall(_G.__ZDuelsAutoGrabTargetInRadius, radius)
          st.targetInRadius = ok and res == true
        end
      end
      local stealPct = blocked and 0 or math.clamp(I or 0, 0, 1)
      if st.targetInRadius then
        if stealPct > 0 then
          st.radiusProgress = stealPct
        else
          local dur = math.max(0.1, tonumber(O.Duration) or 1.3)
          st.radiusProgress = st.radiusProgress + step / dur
          if st.radiusProgress >= 1 then st.radiusProgress = 0 end
        end
      else
        st.radiusProgress = 0
      end
      local target = math.max(stealPct, st.radiusProgress)
      st.displayProgress = st.displayProgress + (target - st.displayProgress) * math.min(12 * step, 1)
      if math.abs(st.displayProgress - target) < 0.005 then st.displayProgress = target end
      progressFill.Size = UDim2.new(math.clamp(st.displayProgress, 0, 1), 0, 1, 0)
      local visible = autoOn or target > 0
      if visible ~= st.lastVisible then
        pbFrame.Visible = visible
        st.lastVisible = visible
      end
      local pct = math.clamp(math.floor(target * 100), 0, 100)
      if pct ~= st.lastPercent then
        progressPct.Text = tostring(pct) .. "%"
        st.lastPercent = pct
      end
    end))
  end
  _N = aN(k.Visuals, "VISUALS")
  fN(_N, "Anti Lag", "Anti Lag")
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
    x.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    x.BorderSizePixel = 0
    x.TextColor3 = Color3.fromRGB(238, 238, 238)
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
    function _G.__ZDuelsPreserveOptimizerUI(jN)
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
        if _G.__ZDuelsPreserveOptimizerUI(eN) then
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
      UN = _G.__ZDuelsWalkDescendantsBatched(KN, YN, function()
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
    _G.__ZDuelsTrackStopper(LN)
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
    _G.__ZDuelsTrackStopper(QN)
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
    _G.__ZDuelsTrackStopper(t)
    if y["Stretchz Res"] then
      task.defer(nN)
    end
  end
  do
    local F = _G.__ZDuelsSkinChangerState
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
      _G.__ZDuelsSkinChangerState = F
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
          or t.Name == "ZDuelsSkinChanger_Hair"
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
      hN.Name = "ZDuelsSkinChanger_Hair"
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
        LN.Name = "ZDuelsSkinChanger_Shirt"
        LN.ShirtTemplate = UN
        LN.Parent = t
        LN = Instance.new("Pants")
        LN.Name = "ZDuelsSkinChanger_Pants"
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
    _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(x)
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
    local F = _G.__ZDuelsVisualAppearanceState
    if type(F) ~= "table" or F.version ~= 2 then
      F = {
        version = 2,
        headless = setmetatable({}, { __mode = "k" }),
        korblox = setmetatable({}, { __mode = "k" }),
      }
      _G.__ZDuelsVisualAppearanceState = F
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
        local QN = t:FindFirstChild("ZDuelsVisual_Korblox")
        if QN then
          pcall(function()
            QN:Destroy()
          end)
        end
        for QN, QN in ipairs(t:GetChildren()) do
          if QN:IsA("CharacterMesh") and QN.Name == "ZDuelsVisual_KorbloxCharacterMesh" then
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
        warn("Z Duels Korblox: no se pudo cargar el asset 139607673")
        return false
      end
      local hN = t:FindFirstChild("ZDuelsVisual_Korblox")
      if hN then
        pcall(function()
          hN:Destroy()
        end)
      end
      for hN, hN in ipairs(t:GetChildren()) do
        if hN:IsA("CharacterMesh") and hN.Name == "ZDuelsVisual_KorbloxCharacterMesh" then
          pcall(function()
            hN:Destroy()
          end)
        end
      end
      QN = Instance.new("Model")
      QN.Name = "ZDuelsVisual_Korblox"
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
        warn("Z Duels Korblox: el asset 139607673 no contiene piezas compatibles")
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
        x.Name = "ZDuelsVisual_KorbloxCharacterMesh"
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
    _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(x)
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
    I = _G.__ZDuelsSkyChangerMode or "blue"
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
        n.Ambient = Color3.fromRGB(58, 58, 58)
        n.FogColor = Color3.fromRGB(77, 77, 77)
        t.TintColor = Color3.fromRGB(177, 177, 177)
        t.Saturation = 0.4
        t.Contrast = 0.1
      elseif F == "night" then
        n.ClockTime = 0
        n.Brightness = 0.2
        n.Ambient = Color3.fromRGB(22, 22, 22)
        t.TintColor = Color3.fromRGB(185, 185, 185)
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
      n.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
      n.BorderSizePixel = 0
      n.Text = "BLUE"
      n.TextColor3 = Color3.fromRGB(238, 238, 238)
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
        n.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
        n.TextColor3 = Color3.fromRGB(238, 238, 238)
        F.Color = Color3.fromRGB(255, 255, 255)
        F.Thickness = 1
        n.TextStrokeTransparency = 1
      end
      x()
      v(n, function()
        I = if I == "day" then "blue" else if I == "blue" then "night" else "day"
        _G.__ZDuelsSkyChangerMode = I
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
    R.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    R.BackgroundTransparency = 0.12
    R.AutoButtonColor = false
    R.Font = Enum.Font.GothamBold
    R.Text = "Themes"
    R.TextColor3 = Color3.fromRGB(239, 239, 239)
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
    n.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    n.BorderSizePixel = 0
    n.Visible = false
    n.ZIndex = 20
    n.Parent = h
    local F = Instance.new("UIGradient", n)
    F.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 26)),
      ColorSequenceKeypoint.new(0.48, Color3.fromRGB(71, 71, 71)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25)),
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
        if _G.__ZDuelsModernGuiActive or not n.Parent then
          return
        end
        if n.Visible then
          x()
        end
      end)
      g:GetPropertyChangedSignal("Size"):Connect(function()
        if _G.__ZDuelsModernGuiActive or not n.Parent then
          return
        end
        if n.Visible then
          x()
        end
      end)
      local t = false
      g:GetPropertyChangedSignal("Visible"):Connect(function()
        if _G.__ZDuelsModernGuiActive or not n.Parent then
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
      F.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
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
      LN.Text = "BG " .. tostring(hN)
      LN.TextColor3 = Color3.fromRGB(239, 239, 239)
      LN.TextSize = 8
      LN.Font = Enum.Font.GothamBold
      LN.ZIndex = 23
      LN.TextStrokeColor3 = Color3.fromRGB(6, 6, 6)
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
        if _G._ZDuelsHub_BgImageRef and _G._ZDuelsHub_BgImages then
          pcall(function() _G._ZDuelsHub_BgImageRef.Image = _G._ZDuelsHub_BgImages[hN] end)
        end
        if _G._ZDuelsHub_AutoGrabBgSync then
          pcall(_G._ZDuelsHub_AutoGrabBgSync, hN)
        end
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
    F.BackgroundColor3 = Color3.fromRGB(148, 148, 148)
    F.BorderSizePixel = 0
    F.Text = "Save Theme"
    F.TextColor3 = Color3.fromRGB(239, 239, 239)
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
      _G._ZDuelsHub_UI_BgIndex = pN
      _G._ZDuelsHub_BgIndexRef = pN
      if _G._ZDuelsHub_AutoGrabBgSync then
        pcall(_G._ZDuelsHub_AutoGrabBgSync, pN)
      end
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
    local n = _G.__ZDuelsQuickButtonsFrame
    if n then
      pcall(function()
        n:Destroy()
      end)
    end
    local n = Instance.new("Frame")
    n.Name = "ZDuelsQuickButtons"
    n.Size = UDim2.new(1, 0, 1, 0)
    n.Position = UDim2.new(0, 0, 0, 0)
    n.BackgroundTransparency = 1
    n.BorderSizePixel = 0
    n.Active = false
    n.ZIndex = 750
    n.Visible = y["Show Buttons"] == true
    n.Parent = h
    _G.__ZDuelsQuickButtonsFrame = n
    local function F(x, t)
      local nN = Instance.new("TextButton")
      nN.Name = x:gsub("%s+", "") .. "Button"
      local QN = Instance.new("UIScale", nN)
      QN.Name = "QuickButtonSizeScale"
      QN.Scale = _G.__ZDuelsButtonsSize or 1
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
      nN.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
      nN.BackgroundTransparency = 0.18
      nN.BorderSizePixel = 0
      nN.AutoButtonColor = false
      nN.Active = true
      nN.Draggable = false
      nN.Font = Enum.Font.GothamBold
      nN.Text = x
      nN.TextScaled = true
      nN.TextWrapped = true
      nN.TextColor3 = Color3.fromRGB(226, 226, 226)
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
      eN.BackgroundColor3 = KN and (Color3.fromRGB(255, 255, 255)) or (Color3.fromRGB(32, 32, 32))
      eN.BackgroundTransparency = KN and 0 or 0.18
      eN.TextColor3 = KN and (Color3.fromRGB(0, 0, 0)) or (Color3.fromRGB(226, 226, 226))
      eN.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      eN.TextStrokeTransparency = KN and 1 or 0
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
        and not (_G._ZDuelsHub_BypassAuto == true)
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
          local GN, IN = X(KN, 0, qN.x, 0, qN.y, _G.__ZDuelsButtonsSize or 1)
          KN.Position = UDim2.new(0, GN, 0, IN)
          B[KN.Name] = { x = GN, y = IN }
        else
          local qN = KN.Position
          X(KN, qN.X.Scale, qN.X.Offset, qN.Y.Scale, qN.Y.Offset, _G.__ZDuelsButtonsSize or 1)
        end
      end
    end)
    local qN, KN, GN, IN
    local FN = false
    function _G.__ZDuelsSetButtonsSize(kN)
      local EN = tonumber((tostring(kN):gsub(",", ".")))
      if not EN or EN ~= EN or math.abs(EN) == math.huge then
        return _G.__ZDuelsButtonsSize
      end
      EN = math.floor(math.clamp(EN, 0.5, 2) * 100 + 0.5) / 100
      _G.__ZDuelsButtonsSize = EN
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
        X(EN, kN.X.Scale, kN.X.Offset, kN.Y.Scale, kN.Y.Offset, _G.__ZDuelsButtonsSize or 1)
      end
      _G.__ZDuelsGuiPositionsReset = true
      for kN, kN in pairs(_G.__ZDuelsGuiPositionResetters) do
        kN()
      end
      oN()
    end
    _G.__ZDuelsResetButtonPositions = jN.resetPositions
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
    _G.__ZDuelsTrackConn(C.InputChanged:Connect(function(d)
      if not qN or (kN()) then
        return
      end
      if d.UserInputType == Enum.UserInputType.MouseMovement or d == IN then
        EN(d)
      end
    end))
    _G.__ZDuelsTrackConn(C.InputEnded:Connect(function(d)
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
    local refreshButtons
    local function d(B, qN)
      local pressAt = -10
      B.InputBegan:Connect(function(inp)
        if
          kN()
          and (
            inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch
          )
        then
          pressAt = os.clock()
          qN()
          if refreshButtons then
            refreshButtons()
          end
        end
      end)
      B.Activated:Connect(function()
        if os.clock() - pressAt < 1.5 then
          pressAt = -10
          return
        end
        if jN[B] then
          jN[B] = nil
          return
        end
        qN()
        if refreshButtons then
          refreshButtons()
        end
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
    refreshButtons = function()
      local eN = y["Show Buttons"] == true
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
    end
    _G.__ZDuelsTrackConn(D.RenderStepped:Connect(function()
      refreshButtons()
    end))
  end
  do
    _N = aN(k.Visuals, "PANELS")
    r = Instance.new("Frame", _N)
    r.Size = UDim2.new(1, -10, 0, 104)
    r.Position = UDim2.new(0, 5, 0, 28)
    r.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
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
    n.Size = UDim2.new(1, 0, 1, 0)
    n.Position = UDim2.new(0, 0, 0, 0)
    n.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    n.BackgroundTransparency = 0.15
    n.BorderSizePixel = 0
    n.Text = "BYPASS"
    n.TextColor3 = Color3.fromRGB(206, 206, 206)
    n.TextSize = 11
    n.Font = Enum.Font.GothamBold
    n.AutoButtonColor = false
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 6)
    local F = Instance.new("UIStroke", n)
    F.Color = Color3.fromRGB(0, 0, 0)
    F.Thickness = 1
    F.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local d, x, t = nil, false, nil
    local function B() end
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
      ZN.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
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
      SN.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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
      iN.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
      iN.BorderSizePixel = 0
      iN.Text = "OFF"
      iN.TextColor3 = Color3.fromRGB(39, 39, 39)
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
        iN.BackgroundColor3 = LN and (Color3.fromRGB(148, 148, 148)) or (Color3.fromRGB(55, 55, 55))
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
      iN.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
      iN.BackgroundTransparency = 0.15
      iN.BorderSizePixel = 0
      iN.Text = "<"
      iN.TextColor3 = Color3.fromRGB(245, 245, 245)
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
      ZN.TextColor3 = Color3.fromRGB(245, 245, 245)
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
      jN.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
      jN.BackgroundTransparency = 0.15
      jN.BorderSizePixel = 0
      jN.Text = ">"
      jN.TextColor3 = Color3.fromRGB(245, 245, 245)
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
        b:Create(t, TweenInfo.new(0.08), { BackgroundColor3 = Color3.fromRGB(141, 141, 141) }):Play()
        task.delay(0.08, function()
          b:Create(t, TweenInfo.new(0.08), { BackgroundColor3 = Color3.fromRGB(31, 31, 31) }):Play()
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
          { BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(245, 245, 245) }
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
          { BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(245, 245, 245) }
        ):Play()
      end)
      _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function(t)
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
    function _G.__ZDuelsReadSavedPanelVisibility(c)
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
    local c = false
    local function x()
      n.BackgroundColor3 = c and (Color3.fromRGB(160, 160, 160)) or (Color3.fromRGB(28, 28, 28))
      n.TextColor3 = c and (Color3.fromRGB(248, 248, 248)) or (Color3.fromRGB(206, 206, 206))
      F.Color = c and (Color3.fromRGB(193, 193, 193)) or (Color3.fromRGB(82, 82, 82))
      F.Thickness = c and 1.5 or 1
    end
    function _G.__syncBypassVisual()
      x()
    end
    local BYPASS_SOURCE = [=[
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("ZBypass") then
    PlayerGui.ZBypass:Destroy()
end

local MIN_POWER = 60000
local MAX_POWER = 400000
local DEFAULT_POWER = 100000
local STEP = 5000
local SAVE_FILE = "hyejuSpeedBypass.json"
local MIN_GUI = 0.6
local MAX_GUI = 1.6
local DEFAULT_GUI = 0.7
local GUI_STEP = 0.1
local BG_ID = "rbxassetid://9870623314"

local PALETTE = {
    Accent = Color3.fromRGB(255, 255, 255),
    AccentDim = Color3.fromRGB(110, 110, 110),
    Text = Color3.fromRGB(240, 240, 240),
    PanelLight = Color3.fromRGB(12, 12, 12),
    Track = Color3.fromRGB(30, 30, 30),
    Idle = Color3.fromRGB(90, 90, 90)
}

local State = {
    Enabled = false,
    Mode = "V2",
    BackgroundIndex = 1,
    Keybind = nil,
    Listening = false,
    StartTime = 0,
    Power = DEFAULT_POWER,
    GuiSize = DEFAULT_GUI
}

local remote, payload, loopTask
local saveTimer = 0
local saveInterval = 10
local KeybindButton, PowerLabel, PowerInput, SliderFill, SliderKnob, SliderTrack
local BGImage
local updateAccentTheme

local Theme = {
    Background = Color3.fromRGB(0, 0, 0),
    Panel = Color3.fromRGB(0, 0, 0),
    PanelLight = PALETTE.PanelLight,
    Accent = PALETTE.Accent,
    AccentDim = PALETTE.AccentDim,
    Text = PALETTE.Text,
    SubText = Color3.fromRGB(200, 200, 200),
    Track = PALETTE.Track,
    Idle = PALETTE.Idle
}

local function snapPower(value)
    local steps = math.floor((value - MIN_POWER) / STEP + 0.5)
    return math.clamp(MIN_POWER + steps * STEP, MIN_POWER, MAX_POWER)
end

local function snapGui(value)
    local steps = math.floor((value - MIN_GUI) / GUI_STEP + 0.5)
    return math.clamp(MIN_GUI + steps * GUI_STEP, MIN_GUI, MAX_GUI)
end

local function saveData()
    pcall(function()
        local data = {
            Mode = State.Mode,
            BackgroundIndex = State.BackgroundIndex,
            Power = State.Power,
            Keybind = State.Keybind and State.Keybind.Name or nil,
            GuiSize = State.GuiSize,
            PosX = State.PosX,
            PosY = State.PosY,
            Visible = ScreenGui and ScreenGui.Enabled == true and MainFrame and MainFrame.Visible == true
        }
        writefile(SAVE_FILE, HttpService:JSONEncode(data))
        pcall(function()
            writefile("ZBypass.json", HttpService:JSONEncode(data))
        end)
    end)
end

local function loadData()
    if not isfile(SAVE_FILE) then return false end
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(SAVE_FILE))
    end)
    if success and data then
        State.Mode = "V2"
        if data.BackgroundIndex ~= nil then
            State.BackgroundIndex = math.clamp(tonumber(data.BackgroundIndex) or 1, 1, 1)
        end
        if data.Power then State.Power = snapPower(data.Power) end
        if data.Keybind then
            local key = Enum.KeyCode[data.Keybind]
            if key then State.Keybind = key end
        end
        if data.GuiSize then
            State.GuiSize = snapGui(tonumber(data.GuiSize) or DEFAULT_GUI)
        end
        if data.PosX and data.PosY then
            State.PosX = tonumber(data.PosX)
            State.PosY = tonumber(data.PosY)
        end
        if data.Visible ~= nil then
            State.WantVisible = data.Visible == true
        end
        return true
    end
    return false
end

local function corner(radius, parent)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function stroke(color, thickness, transparency, parent)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = 1
    s.Parent = parent
    return s
end

local function formatK(value)
    return string.format("%.1fK", value / 1000)
end

local function findRemote()
    local storage = game:FindFirstChild("RobloxReplicatedStorage")
    if not storage then return nil end
    local names = {"SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList"}
    for _, name in ipairs(names) do
        local r = storage:FindFirstChild(name)
        if r and r:IsA("RemoteEvent") then return r end
    end
    for _, child in ipairs(storage:GetChildren()) do
        if child:IsA("RemoteEvent") and child.Name:find("Block") then return child end
    end
    return nil
end

local function buildPayload()
    local main = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 296 do
        local new = {}
        table.insert(current, new)
        current = new
    end
    local maxRep = math.min(math.floor(State.Power / 298), 10000)
    for _ = 1, maxRep do
        table.insert(main, nested)
    end
    return main
end

local function startV2()
    if not remote then
        remote = findRemote()
        if not remote then return end
    end
    payload = buildPayload()
    if loopTask then task.cancel(loopTask) loopTask = nil end
    loopTask = task.spawn(function()
        while State.Enabled do
            if not remote then
                remote = findRemote()
                task.wait(1)
            else
                pcall(function() remote:FireServer(payload) end)
                task.wait(0.125)
            end
        end
    end)
end

local function stopV2()
    if loopTask then task.cancel(loopTask) loopTask = nil end
end

local function startBypass()
    startV2()
end

local function stopBypass()
    stopV2()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZBypass"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 440, 0, 298)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui
corner(14, MainFrame)
local MainStroke = stroke(Theme.AccentDim, 1.5, 0.2, MainFrame)

local GuiScale = Instance.new("UIScale")
GuiScale.Scale = State.GuiSize
GuiScale.Parent = MainFrame

BGImage = Instance.new("ImageLabel")
BGImage.Name = "BG"
BGImage.Size = UDim2.new(1, 0, 1, 0)
BGImage.Position = UDim2.new(0, 0, 0, 0)
BGImage.BackgroundTransparency = 1
BGImage.Image = BG_ID
BGImage.ScaleType = Enum.ScaleType.Crop
BGImage.ImageTransparency = 0
BGImage.BorderSizePixel = 0
BGImage.Active = false
BGImage.Selectable = false
BGImage.ZIndex = 1
BGImage.Parent = MainFrame
corner(14, BGImage)

local BGTransition = Instance.new("ImageLabel")
BGTransition.Name = "BGTransition"
BGTransition.Size = UDim2.new(1, 0, 1, 0)
BGTransition.Position = UDim2.new(0, 0, 0, 0)
BGTransition.BackgroundTransparency = 1
BGTransition.ImageTransparency = 1
BGTransition.ScaleType = Enum.ScaleType.Crop
BGTransition.BorderSizePixel = 0
BGTransition.Active = false
BGTransition.Selectable = false
BGTransition.ZIndex = 1
BGTransition.Parent = MainFrame
corner(14, BGTransition)

local BGTransitionTween
local BackgroundIds = {
    "rbxassetid://9870623314"
}

local function setBackground(index)
    State.BackgroundIndex = ((index - 1) % #BackgroundIds) + 1
    local imageId = BackgroundIds[State.BackgroundIndex]

    if BGImage.Image ~= imageId then
        if BGTransitionTween then
            BGTransitionTween:Cancel()
        end

        BGTransition.Image = imageId
        BGTransition.ImageTransparency = 1
        BGTransitionTween = TweenService:Create(
            BGTransition,
            TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { ImageTransparency = BGImage.ImageTransparency }
        )
        BGTransitionTween.Completed:Connect(function(playbackState)
            if playbackState == Enum.PlaybackState.Completed then
                BGImage.Image = imageId
                BGTransition.ImageTransparency = 1
            end
        end)
        BGTransitionTween:Play()
    end


    local previousAccent = Theme.Accent
    local previousAccentDim = Theme.AccentDim
    Theme.Accent = PALETTE.Accent
    Theme.AccentDim = PALETTE.AccentDim
    if updateAccentTheme then
        updateAccentTheme(previousAccent, previousAccentDim)
    end

    saveData()
end

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 48)
TitleBar.BackgroundColor3 = Theme.Panel
TitleBar.BackgroundTransparency = 0.4
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
TitleBar.Parent = MainFrame
corner(14, TitleBar)

local TitleBarFix = Instance.new("Frame")
TitleBarFix.Size = UDim2.new(1, 0, 0, 14)
TitleBarFix.Position = UDim2.new(0, 0, 1, -14)
TitleBarFix.BackgroundColor3 = Theme.Panel
TitleBarFix.BackgroundTransparency = 0.4
TitleBarFix.BorderSizePixel = 0
TitleBarFix.ZIndex = 2
TitleBarFix.Parent = TitleBar

local AccentBar = Instance.new("Frame")
AccentBar.Size = UDim2.new(0, 3, 0, 26)
AccentBar.Position = UDim2.new(0, 12, 0, 11)
AccentBar.BackgroundColor3 = Theme.Accent
AccentBar.BorderSizePixel = 0
AccentBar.ZIndex = 3
AccentBar.Parent = TitleBar
corner(2, AccentBar)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -170, 0, 22)
TitleLabel.Position = UDim2.new(0, 22, 0, 6)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Z Bypass"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 17
TitleLabel.TextColor3 = Theme.Accent
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3
TitleLabel.Parent = TitleBar

local ScaleHolder = Instance.new("Frame")
ScaleHolder.Size = UDim2.new(0, 120, 0, 28)
ScaleHolder.AnchorPoint = Vector2.new(1, 0.5)
ScaleHolder.Position = UDim2.new(1, -12, 0.5, 0)
ScaleHolder.BackgroundColor3 = Theme.PanelLight
ScaleHolder.BackgroundTransparency = 0.62
ScaleHolder.BorderSizePixel = 0
ScaleHolder.ZIndex = 3
ScaleHolder.Parent = TitleBar
corner(14, ScaleHolder)
local ScaleStroke = stroke(Theme.AccentDim, 1, 0.4, ScaleHolder)

local SizeMinus = Instance.new("TextButton")
SizeMinus.Size = UDim2.new(0, 24, 1, 0)
SizeMinus.Position = UDim2.new(0, 0, 0, 0)
SizeMinus.BackgroundTransparency = 1
SizeMinus.Text = "-"
SizeMinus.Font = Enum.Font.GothamBold
SizeMinus.TextSize = 14
SizeMinus.TextColor3 = Theme.Text
SizeMinus.AutoButtonColor = false
SizeMinus.ZIndex = 4
SizeMinus.Parent = ScaleHolder

local SizeLabel = Instance.new("TextLabel")
SizeLabel.Size = UDim2.new(0, 72, 1, 0)
SizeLabel.Position = UDim2.new(0, 24, 0, 0)
SizeLabel.BackgroundTransparency = 1
SizeLabel.Text = "70%"
SizeLabel.Font = Enum.Font.GothamBold
SizeLabel.TextSize = 11
SizeLabel.TextColor3 = Theme.Text
SizeLabel.TextXAlignment = Enum.TextXAlignment.Center
SizeLabel.ZIndex = 4
SizeLabel.Parent = ScaleHolder

local SizePlus = Instance.new("TextButton")
SizePlus.Size = UDim2.new(0, 24, 1, 0)
SizePlus.Position = UDim2.new(1, -24, 0, 0)
SizePlus.BackgroundTransparency = 1
SizePlus.Text = "+"
SizePlus.Font = Enum.Font.GothamBold
SizePlus.TextSize = 14
SizePlus.TextColor3 = Theme.Text
SizePlus.AutoButtonColor = false
SizePlus.ZIndex = 4
SizePlus.Parent = ScaleHolder

local function updateSizeLabel()
    SizeLabel.Text = tostring(math.floor(State.GuiSize * 100 + 0.5)) .. "%"
end

local function setGuiSize(value)
    State.GuiSize = snapGui(value)
    GuiScale.Scale = State.GuiSize
    updateSizeLabel()
    saveData()
end

SizeMinus.MouseButton1Click:Connect(function() setGuiSize(State.GuiSize - GUI_STEP) end)
SizePlus.MouseButton1Click:Connect(function() setGuiSize(State.GuiSize + GUI_STEP) end)

local Body = Instance.new("Frame")
Body.Name = "Body"
Body.Size = UDim2.new(1, -24, 1, -64)
Body.Position = UDim2.new(0, 12, 0, 56)
Body.BackgroundTransparency = 1
Body.ClipsDescendants = true
Body.ZIndex = 2
Body.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.FillDirection = Enum.FillDirection.Vertical
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Body

local PowerCard = Instance.new("Frame")
PowerCard.Size = UDim2.new(1, 0, 0, 70)
PowerCard.BackgroundColor3 = Theme.Panel
PowerCard.BackgroundTransparency = 0.4
PowerCard.BorderSizePixel = 0
PowerCard.LayoutOrder = 1
PowerCard.Parent = Body
corner(8, PowerCard)
local PowerCardStroke = stroke(Theme.AccentDim, 1, 0.6, PowerCard)

local PowerTitle = Instance.new("TextLabel")
PowerTitle.Size = UDim2.new(0, 100, 0, 14)
PowerTitle.Position = UDim2.new(0, 12, 0, 8)
PowerTitle.BackgroundTransparency = 1
PowerTitle.Text = "POWER"
PowerTitle.Font = Enum.Font.GothamBold
PowerTitle.TextSize = 10
PowerTitle.TextColor3 = Theme.SubText
PowerTitle.TextXAlignment = Enum.TextXAlignment.Left
PowerTitle.Parent = PowerCard

PowerLabel = Instance.new("TextLabel")
PowerLabel.Size = UDim2.new(0, 100, 0, 22)
PowerLabel.Position = UDim2.new(0, 12, 0, 22)
PowerLabel.BackgroundTransparency = 1
PowerLabel.Text = formatK(DEFAULT_POWER)
PowerLabel.Font = Enum.Font.GothamBold
PowerLabel.TextSize = 18
PowerLabel.TextColor3 = Theme.Accent
PowerLabel.TextXAlignment = Enum.TextXAlignment.Left
PowerLabel.Parent = PowerCard

PowerInput = Instance.new("TextBox")
PowerInput.Size = UDim2.new(0, 80, 0, 28)
PowerInput.Position = UDim2.new(1, -92, 0, 22)
PowerInput.BackgroundColor3 = Theme.PanelLight
PowerInput.BackgroundTransparency = 0.62
PowerInput.Text = tostring(DEFAULT_POWER)
PowerInput.Font = Enum.Font.GothamBold
PowerInput.TextSize = 12
PowerInput.TextColor3 = Theme.Text
PowerInput.ClearTextOnFocus = false
PowerInput.Parent = PowerCard
corner(6, PowerInput)
local PowerInputStroke = stroke(Theme.AccentDim, 1, 0.4, PowerInput)

SliderTrack = Instance.new("Frame")
SliderTrack.Size = UDim2.new(1, -24, 0, 6)
SliderTrack.Position = UDim2.new(0, 12, 1, -18)
SliderTrack.BackgroundColor3 = Theme.Track
SliderTrack.BackgroundTransparency = 0.55
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = PowerCard
corner(3, SliderTrack)

SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Theme.Accent
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderTrack
corner(3, SliderFill)

SliderKnob = Instance.new("Frame")
SliderKnob.Size = UDim2.new(0, 16, 0, 16)
SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
SliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
SliderKnob.BackgroundColor3 = Theme.Text
SliderKnob.BorderSizePixel = 0
SliderKnob.ZIndex = 2
SliderKnob.Parent = SliderTrack
corner(8, SliderKnob)
local SliderKnobStroke = stroke(Theme.Accent, 2, 0, SliderKnob)

local function powerToAlpha(power)
    return (power - MIN_POWER) / (MAX_POWER - MIN_POWER)
end

local function updateSliderVisual()
    local alpha = powerToAlpha(State.Power)
    SliderFill.Size = UDim2.new(alpha, 0, 1, 0)
    SliderKnob.Position = UDim2.new(alpha, 0, 0.5, 0)
    PowerLabel.Text = formatK(State.Power)
end

local function setPower(value, skipTextbox)
    value = snapPower(value)
    State.Power = value
    updateSliderVisual()
    if not skipTextbox then PowerInput.Text = tostring(value) end
    saveData()
    if State.Enabled and State.Mode == "V2" then
        payload = buildPayload()
    end
end

do
    local dragging = false
    local function updateFromInputPosition(inputPos)
        local trackPos = SliderTrack.AbsolutePosition.X
        local trackSize = SliderTrack.AbsoluteSize.X
        local alpha = math.clamp((inputPos - trackPos) / trackSize, 0, 1)
        setPower(MIN_POWER + alpha * (MAX_POWER - MIN_POWER))
    end

    SliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInputPosition(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInputPosition(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

PowerInput.FocusLost:Connect(function()
    local num = tonumber((PowerInput.Text:gsub(",", "")))
    if num then setPower(num) else PowerInput.Text = tostring(State.Power) end
end)

local StatusRow = Instance.new("Frame")
StatusRow.Size = UDim2.new(1, 0, 0, 40)
StatusRow.BackgroundColor3 = Theme.Panel
StatusRow.BackgroundTransparency = 0.4
StatusRow.BorderSizePixel = 0
StatusRow.LayoutOrder = 2
StatusRow.Parent = Body
corner(8, StatusRow)
local StatusRowStroke = stroke(Theme.AccentDim, 1, 0.6, StatusRow)

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 10, 0, 10)
StatusDot.Position = UDim2.new(0, 12, 0.5, -5)
StatusDot.BackgroundColor3 = Theme.Idle
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusRow
corner(5, StatusDot)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 70, 1, 0)
StatusLabel.Position = UDim2.new(0, 28, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "IDLE"
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 12
StatusLabel.TextColor3 = Theme.SubText
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusRow

KeybindButton = Instance.new("TextButton")
KeybindButton.Size = UDim2.new(0, 46, 0, 26)
KeybindButton.Position = UDim2.new(1, -58, 0.5, -13)
KeybindButton.BackgroundColor3 = Theme.PanelLight
KeybindButton.BackgroundTransparency = 0.62
KeybindButton.Text = "?"
KeybindButton.Font = Enum.Font.GothamBold
KeybindButton.TextSize = 11
KeybindButton.TextColor3 = Theme.Text
KeybindButton.AutoButtonColor = false
KeybindButton.Parent = StatusRow
corner(6, KeybindButton)
local KeybindStroke = stroke(Theme.AccentDim, 1, 0.4, KeybindButton)

KeybindButton.MouseButton1Click:Connect(function()
    if State.Listening then return end
    State.Listening = true
    KeybindButton.Text = "..."
end)

local function applyStatusVisual()
    StatusDot.BackgroundColor3 = State.Enabled and Theme.Accent or Theme.Idle
    StatusLabel.Text = State.Enabled and "ACTIVE" or "IDLE"
    StatusLabel.TextColor3 = State.Enabled and Theme.Accent or Theme.SubText
end

local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(1, 0, 0, 44)
StartButton.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
StartButton.BackgroundTransparency = 0.15
StartButton.Text = "START"
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 15
StartButton.TextColor3 = Theme.Text
StartButton.AutoButtonColor = false
StartButton.LayoutOrder = 3
StartButton.Parent = Body
corner(8, StartButton)
local StartStroke = stroke(Color3.fromRGB(140, 140, 140), 1.5, 0.3, StartButton)

local function applyStartVisual()
    if State.Enabled then
        StartButton.BackgroundColor3 = Theme.PanelLight
        StartButton.Text = "STOP"
        StartButton.TextColor3 = Theme.Accent
        StartStroke.Color = Color3.fromRGB(140, 140, 140)
    else
        StartButton.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
        StartButton.Text = "START"
        StartButton.TextColor3 = Theme.Text
        StartStroke.Color = Color3.fromRGB(140, 140, 140)
    end
end

local function setEnabled(value)
    if State.Enabled == value then return end
    State.Enabled = value
    if State.Enabled then
        startBypass()
    else
        stopBypass()
    end
    applyStatusVisual()
    applyStartVisual()
end

local function toggleEnabled()
    setEnabled(not State.Enabled)
end

StartButton.MouseButton1Click:Connect(toggleEnabled)

do
    local dragging = false
    local dragStart, startPos

    local function startDrag(input)
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end

    local function updateDrag(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end

    local function endDrag()
        dragging = false
        State.PosX = MainFrame.Position.X.Offset
        State.PosY = MainFrame.Position.Y.Offset
        saveData()
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)

    UserInputService.InputChanged:Connect(updateDrag)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)
end

local function autoSave()
    saveTimer = saveTimer + 1
    if saveTimer >= saveInterval then
        saveTimer = 0
        saveData()
    end
end

RunService.Heartbeat:Connect(function()
    autoSave()
    if State.Mode == "V2" and not remote then
        remote = findRemote()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if State.Listening then
        if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.Gamepad1 then
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                State.Keybind = input.KeyCode
                if KeybindButton then KeybindButton.Text = input.KeyCode.Name end
                State.Listening = false
                saveData()
            end
        end
        return
    end
    if gameProcessed then return end
    local panelOpen = ScreenGui and ScreenGui.Enabled == true and MainFrame and MainFrame.Visible == true
    if not panelOpen then
        return
    end
    if State.Keybind and input.KeyCode == State.Keybind then
        toggleEnabled()
    end
end)

updateAccentTheme = function(previousAccent, previousAccentDim)
    for _, object in ipairs(MainFrame:GetDescendants()) do
        if object:IsA("UIStroke") then
            if object.Color == previousAccent then
                object.Color = Theme.Accent
            elseif object.Color == previousAccentDim then
                object.Color = Theme.AccentDim
            end
        elseif object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
            if object.TextColor3 == previousAccent then
                object.TextColor3 = Theme.Accent
            end
        elseif object:IsA("GuiObject") then
            if object.BackgroundColor3 == previousAccent then
                object.BackgroundColor3 = Theme.Accent
            elseif object.BackgroundColor3 == previousAccentDim then
                object.BackgroundColor3 = Theme.AccentDim
            end
        end
    end

    applyStatusVisual()
    applyStartVisual()
end

loadData()
if State.PosX and State.PosY then
    MainFrame.Position = UDim2.new(0.5, State.PosX, 0.5, State.PosY)
end
setBackground(State.BackgroundIndex)
GuiScale.Scale = State.GuiSize
updateSizeLabel()
applyStatusVisual()
applyStartVisual()
updateSliderVisual()
PowerInput.Text = tostring(State.Power)
if State.Keybind and KeybindButton then
    KeybindButton.Text = State.Keybind.Name
end

_G._ZDuelsBypassOpen = ScreenGui.Enabled
_G.ZDuelsBypass = {
  SetVisible = function(v)
    v = v == true
    ScreenGui.Enabled = v
    MainFrame.Visible = v
    _G._ZDuelsBypassOpen = v
    State.WantVisible = v
    pcall(saveData)
  end,
  IsVisible = function()
    return ScreenGui.Enabled == true and MainFrame.Visible == true
  end,
  SetBypass = function(v)
    setEnabled(v == true)
  end,
  IsEnabled = function()
    return State.Enabled == true
  end,
  SetAutoOnSteal = function() end,
  IsAutoOnSteal = function() return false end,
  Stop = function()
    setEnabled(false)
  end,
  SetBackground = function(idx)
    local imgs = (_G._ZDuelsHub_BgImages)
      or (_G._ZDuelsHub_MainBgImages)
      or {
        "rbxassetid://106198980844513",
        "rbxassetid://133480996347048",
        "rbxassetid://130445102143088",
        "rbxassetid://93606486246798",
      }
    local i = math.clamp(tonumber(idx) or tonumber(_G._ZDuelsHub_UI_BgIndex) or 1, 1, #imgs)
    local asset
    if _G.__ZDuelsHalloween then
      asset = _G.__ZDuelsHalloweenImg or "rbxassetid://114005874982706"
    else
      asset = imgs[i] or imgs[1]
    end
    if BGImage and asset and asset ~= "" then
      BGImage.Image = asset
      BGImage.ScaleType = Enum.ScaleType.Crop
      BGImage.ImageTransparency = 0
    end
    if _G.__ZDuelsHalloween then
      pcall(function()
        if _G.ZDuelsBypass and _G.ZDuelsBypass.SetHalloweenStyle then
          _G.ZDuelsBypass.SetHalloweenStyle(true)
        end
      end)
    else
      pcall(function()
        if _G.ZDuelsBypass and _G.ZDuelsBypass.SetHalloweenStyle then
          _G.ZDuelsBypass.SetHalloweenStyle(false)
        end
      end)
    end
    State.BackgroundIndex = i
    pcall(saveData)
  end,
  SetHalloweenStyle = function(on)
    on = on == true
    local orange = Color3.fromRGB(255, 125, 0)
    local orangeDim = Color3.fromRGB(180, 90, 0)
    local white = Color3.fromRGB(255, 255, 255)
    local whiteDim = Color3.fromRGB(110, 110, 110)
    local prevA, prevD = Theme.Accent, Theme.AccentDim
    if on then
      Theme.Accent = orange
      Theme.AccentDim = orangeDim
      PALETTE.Accent = orange
      PALETTE.AccentDim = orangeDim
    else
      Theme.Accent = white
      Theme.AccentDim = whiteDim
      PALETTE.Accent = white
      PALETTE.AccentDim = whiteDim
    end
    if updateAccentTheme then
      updateAccentTheme(prevA, prevD)
    end
    if AccentBar then AccentBar.BackgroundColor3 = Theme.Accent end
    if TitleLabel then TitleLabel.TextColor3 = Theme.Accent end
    if PowerLabel then PowerLabel.TextColor3 = Theme.Accent end
    if SliderFill then SliderFill.BackgroundColor3 = Theme.Accent end
    if SliderKnobStroke then SliderKnobStroke.Color = Theme.Accent end
    if MainStroke then MainStroke.Color = Theme.AccentDim end
    applyStatusVisual()
    applyStartVisual()
    local imgs = _G._ZDuelsHub_BgImages or {
      "rbxassetid://106198980844513",
      "rbxassetid://133480996347048",
      "rbxassetid://130445102143088",
      "rbxassetid://93606486246798",
    }
    if on then
      local spooky = _G.__ZDuelsHalloweenImg or "rbxassetid://114005874982706"
      if BGImage then BGImage.Image = spooky end
    else
      local i = math.clamp(tonumber(_G._ZDuelsHub_UI_BgIndex) or State.BackgroundIndex or 1, 1, #imgs)
      if BGImage then BGImage.Image = imgs[i] or imgs[1] end
    end
  end,
  ResetPosition = function()
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
  end,
}
_G._ZDuelsHub_BypassBgRef = BGImage
local _wantOpen = State.WantVisible == true
    or _G._ZDuelsBypassOpen == true
    or _G.__ZDuelsBypassWasOpen == true
ScreenGui.Enabled = _wantOpen
MainFrame.Visible = _wantOpen
_G._ZDuelsBypassOpen = _wantOpen
State.WantVisible = _wantOpen
pcall(saveData)
task.defer(function()
  pcall(function()
    if _G.ZDuelsBypass and _G.ZDuelsBypass.SetBackground then
      _G.ZDuelsBypass.SetBackground(tonumber(_G._ZDuelsHub_UI_BgIndex) or 1)
    end
    if _G.__ZDuelsHalloween and _G.ZDuelsBypass and _G.ZDuelsBypass.SetHalloweenStyle then
      _G.ZDuelsBypass.SetHalloweenStyle(true)
    end
    if State.WantVisible == true or _G.__ZDuelsBypassWasOpen == true then
      ScreenGui.Enabled = true
      MainFrame.Visible = true
      _G._ZDuelsBypassOpen = true
    end
  end)
end)

]=]
    local function F(B)
      B = B ~= false
      _G._ZDuelsBypassOpen = B
      if _G.ZDuelsBypass and _G.ZDuelsBypass.SetVisible then
        pcall(_G.ZDuelsBypass.SetVisible, B)
        return
      end
      local loader = loadstring or load
      if type(loader) ~= "function" then return end
      local ok, fn = pcall(loader, BYPASS_SOURCE)
      if ok and type(fn) == "function" then
        pcall(fn)
        if _G.ZDuelsBypass and _G.ZDuelsBypass.SetVisible then
          pcall(_G.ZDuelsBypass.SetVisible, B)
        end
      end
    end
    _G.__openBypassGUI = F
    task.defer(function()
      local shouldOpen = _G._ZDuelsBypassOpen == true or _G.__ZDuelsBypassWasOpen == true
      pcall(function()
        if typeof(isfile) == "function" and typeof(readfile) == "function" then
          local files = { "hyejuSpeedBypass.json", "ZBypass.json" }
          for _, fname in ipairs(files) do
            if isfile(fname) then
              local raw = readfile(fname)
              local data = game:GetService("HttpService"):JSONDecode(raw)
              if type(data) == "table" and data.Visible == true then
                shouldOpen = true
                break
              elseif type(data) == "table" and data.Visible == false then
              end
            end
          end
        end
      end)
      if shouldOpen and _G.__openBypassGUI then
        pcall(_G.__openBypassGUI, true)
      end
    end)
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
    t.TextColor3 = Color3.fromRGB(93, 93, 93)
    t.TextSize = 10
    t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    local z = Instance.new("TextButton", d)
    z.Size = UDim2.new(0, 40, 0, 20)
    z.Position = UDim2.new(1, -48, 0.5, -10)
    z.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    z.BackgroundTransparency = 0.15
    z.BorderSizePixel = 0
    z.Text = E["Toggle UI"] and (zN(E["Toggle UI"])) or "-"
    z.TextColor3 = Color3.fromRGB(238, 238, 238)
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
        l.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        l.BackgroundTransparency = 1
        l.Text = "-"
      end
      l, N = z, "Toggle UI"
      z.Text = "..."
      z.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
      z.BackgroundTransparency = 0
    end)
    table.insert(m, z)
    if M["Toggle UI"] == nil then
      M["Toggle UI"] = function()
        z.Text = E["Toggle UI"] and (zN(E["Toggle UI"])) or "-"
        z.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
        z.BackgroundTransparency = 0.15
        z.TextColor3 = Color3.fromRGB(238, 238, 238)
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
  _G.__ZDuelsHub_Anims = c
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
  d.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
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
    R.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    R.BackgroundTransparency = 0.25
    R.BorderSizePixel = 0
    Instance.new("UICorner", R).CornerRadius = UDim.new(0, 8)
    r = Instance.new("TextLabel", R)
    r.Size = UDim2.new(0.48, 0, 1, 0)
    r.Position = UDim2.new(0, 8, 0, 0)
    r.BackgroundTransparency = 1
    r.Text = F[v]
    r.TextColor3 = Color3.fromRGB(221, 221, 221)
    r.TextSize = 11
    r.Font = Enum.Font.GothamBold
    r.TextXAlignment = Enum.TextXAlignment.Left
    local o = Instance.new("TextButton", R)
    o.Size = UDim2.new(0.5, -10, 0, 20)
    o.Position = UDim2.new(0.5, 0, 0.5, -10)
    o.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
  R.TextColor3 = Color3.fromRGB(189, 189, 189)
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
  if type(_G.__ZDuelsPanelVisible) == "boolean" then
    k = _G.__ZDuelsPanelVisible
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
    _G.__ZDuelsPanelVisible = DN
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
  _G.__ZDuelsAllUIHidden = false
  FeatureToggles["Hide UI"] = function()
    _G.__ZDuelsAllUIHidden = not _G.__ZDuelsAllUIHidden
    local hide = _G.__ZDuelsAllUIHidden
    pcall(function()
      h.Enabled = not hide
    end)
    local bg = _G.__ZDuelsBypassGui
    if bg and bg.Parent then
      pcall(function()
        bg.Enabled = not hide
      end)
    end
  end
  a = _G._ZDuelsHub_UI_MenuPos
  if a then
    _N, r, R = Vector2.new, X(g, 0, a.x, 0, a.y)
    z = _N(r, R)
    g.Position = UDim2.new(0, z.X, 0, z.Y)
  else
    g.Position = UDim2.new(1, -f - 20, 0.5, -Y / 2)
  end
  g.Visible = false
  y["Toggle UI"] = k
  _G.__ZDuelsPanelVisible = k
  if t then
    R = not k
    t.Visible = R
  end
  if v then
    B = not k
    v.Visible = B
  end
  (function()
    _G.__ZDuelsModernGuiActive = true
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
    g.Name = "ZDuelsModernPanel"
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
      p and (math.clamp(math.floor(o.X * 0.437), 184, 242)) or 265,
      p and (math.clamp(math.floor(o.Y * 0.72), 300, 460)) or 640
    g.Size = UDim2.new(0, H, 0, a)
    z = _G._ZDuelsHub_UI_MenuPos
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
      bg = Color3.fromRGB(16, 16, 16),
      bgDark = Color3.fromRGB(8, 8, 8),
      row = Color3.fromRGB(26, 26, 26),
      accent = Color3.fromRGB(176, 176, 176),
      accentDim = Color3.fromRGB(74, 74, 74),
      text = Color3.fromRGB(242, 242, 242),
      textDim = Color3.fromRGB(199, 199, 199),
      textMuted = Color3.fromRGB(149, 149, 149),
      divider = Color3.fromRGB(95, 95, 95),
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
      _G.__ZDuelsGuiPositionResetters[r.Name] = function()
        B, t, v, DN = false, nil, nil, nil
        r.Position = UDim2.fromOffset(6, 54)
        if r == g then
          _G._ZDuelsHub_UI_MenuPos = nil
        else
          _G._ZDuelsHub_UI_ModernMiniPos = nil
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
                _G._ZDuelsHub_UI_MenuPos = {
                  x = r.Position.X.Offset,
                  y = r.Position.Y.Offset,
                  xs = r.Position.X.Scale,
                  ys = r.Position.Y.Scale,
                }
                pcall(oN)
              elseif r.Name == "ZDuelsRestoreButton" then
                _G._ZDuelsHub_UI_ModernMiniPos =
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
      _G.__ZDuelsTrackConn(C.InputChanged:Connect(function(c)
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
    c.BackgroundTransparency = 1
    c.BorderSizePixel = 0
    c.Parent = g
    Y(c, 7)
    H = Instance.new("ImageLabel")
    H.Name = "ZDuelsHubBackground"
    H.Size = UDim2.fromScale(1, 1)
    H.Position = UDim2.fromScale(0, 0)
    H.BackgroundTransparency = 1
    local bgCandidates = { "rbxassetid://128795422851954", "rbxthumb://type=Asset&id=128795422851954&w=768&h=432" }
    H.Image = bgCandidates[1]
    H.ImageTransparency = 0
    H.ScaleType = Enum.ScaleType.Crop
    H.ZIndex = 0
    H.Parent = c
    do
      local _bgImgsMod = {
        "rbxassetid://106198980844513",
        "rbxassetid://133480996347048",
        "rbxassetid://130445102143088",
        "rbxassetid://93606486246798",
      }
      table.insert(_G.__ZDuelsBgLists, _bgImgsMod)
      local _bgIdxNow = math.clamp(tonumber(_G._ZDuelsHub_UI_BgIndex) or 1, 1, 4)
      H.Image = _bgImgsMod[_bgIdxNow]
      H.ImageTransparency = 0
      _G._ZDuelsHub_MainBgRef = H
      _G._ZDuelsHub_MainBgImages = _bgImgsMod
    end
    Y(H, 7)
    local r, B, t, v = F(c, f.accentDim, 1.25), { ["GUI 1"] = true }, { ["GUI 1"] = 1 }, "GUI 1"
    _G.__ZDuelsGuiTheme = v
    local DN
    local function nN(QN)
      local uN = t[QN] or 1
      pcall(function()
        if _G.ZDuelsBypass and _G.ZDuelsBypass.SetBackground then
          _G.ZDuelsBypass.SetBackground(uN)
        end
      end)
    end
    _G.__ZDuelsAddUnifiedPanelShade(c, 7, 1);
    (function(t)
      t = if not B[t] then "GUI 1" else t
      v = t
      _G.__ZDuelsGuiTheme = t
      if _G.__ZDuelsApplyTheme then
        _G.__ZDuelsApplyTheme()
      end
      c.BackgroundColor3 = f.bgDark
      c.BackgroundTransparency = 0.18
      local B = c:FindFirstChild("UnifiedBackgroundShade")
      if B then
        B.Visible = false
      end
      r.Transparency = 0.12
      nN(t)
      if _G.__ZDuelsApplyAutoStealBarTheme then
        pcall(_G.__ZDuelsApplyAutoStealBarTheme, t)
      end
      if _G.__ZDuelsRefreshESPTheme then
        pcall(_G.__ZDuelsRefreshESPTheme, _G.__ZDuelsThemeAccent, Color3.fromRGB(0, 0, 0))
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
    a.BackgroundTransparency = 0.6
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
    a.Name = "ZDuelsHubTitleBackground"
    a.Size = UDim2.fromOffset(p and 200 or 240, 36)
    a.Position = UDim2.new(0, 14, 0, (R.headerH - 28) / 2)
    a.BackgroundColor3 = f.bgDark
    a.BackgroundTransparency = 1
    a.BorderSizePixel = 0
    a.ZIndex = 19
    a.Parent = c
    Y(a, 8)
    z = Instance.new("TextLabel")
    z.Name = "HubTitle"
    z:SetAttribute("ZDuelsKeepBlackText", true)
    z.AnchorPoint = Vector2.new(0, 0)
    z.Position = UDim2.new(0, 0, 0, 0)
    z.Size = UDim2.new(1, 0, 1, 0)
    z.BackgroundTransparency = 1
    z.BorderSizePixel = 0
    z.Text = "Z Duels"
    z.TextColor3 = Color3.fromRGB(255, 255, 255)
    z.TextTransparency = 0
    z.TextStrokeTransparency = 1
    z.TextSize = p and 20 or 24
    z.Font = Enum.Font.GothamBold
    z.TextXAlignment = Enum.TextXAlignment.Left
    z.TextYAlignment = Enum.TextYAlignment.Center
    z.Visible = true
    z.ZIndex = 20
    local rbGrad = Instance.new("UIGradient", z)
    rbGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    z.TextColor3 = Color3.fromRGB(255, 255, 255)
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
    local _tabBarH = p and 34 or 38
    W.Size = UDim2.new(1, 0, 0, _tabBarH)
    W.Position = UDim2.new(0, 0, 1, -_tabBarH)
    W.BackgroundColor3 = f.bgDark
    W.BackgroundTransparency = 0.5
    W.BorderSizePixel = 0
    W.ZIndex = 12
    W.Parent = c
    Y(W, 0)  
    F(W, f.divider, 1)
    o = Instance.new("UIListLayout", W)
    o.SortOrder = Enum.SortOrder.LayoutOrder
    o.FillDirection = Enum.FillDirection.Horizontal
    o.HorizontalAlignment = Enum.HorizontalAlignment.Center
    o.VerticalAlignment = Enum.VerticalAlignment.Center
    o.Padding = UDim.new(0, 2)
    H = Instance.new("UIPadding", W)
    H.PaddingLeft = UDim.new(0, 4)
    H.PaddingRight = UDim.new(0, 4)
    H.PaddingTop = UDim.new(0, 3)
    H.PaddingBottom = UDim.new(0, 3)
    local w = Instance.new("Frame")
    w.Name = "ContentFrame"
    w.Size = UDim2.new(1, -16, 1, -(R.headerH + 6 + _tabBarH + 10))
    w.Position = UDim2.new(0, 8, 0, R.headerH + 6)
    w.BackgroundTransparency = 1
    w.ClipsDescendants = true
    w.ZIndex = 4
    w.Parent = c
    local function r(B)
      B:SetAttribute("ZDuelsKeepBlackText", true)
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
      _N.BackgroundTransparency = 0.74
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
      F(UN, Color3.fromRGB(56, 56, 56), 1)
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
      hN.BackgroundTransparency = 0.74
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
      F(aN, Color3.fromRGB(56, 56, 56), 1)
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
      HN.Size = UDim2.new(1, 0, 0, 64)
      HN.BackgroundColor3 = f.row
      HN.BackgroundTransparency = 0.74
      HN.BorderSizePixel = 0
      HN.LayoutOrder = yN
      HN.Parent = _N
      Y(HN, 10)
      F(HN, f.divider, 1)
      local yN = Instance.new("Frame")
      yN.Size = UDim2.new(0, 3, 0, 40)
      yN.Position = UDim2.new(0, 4, 0.5, -20)
      yN.BackgroundColor3 = f.accent
      yN.BorderSizePixel = 0
      yN.Parent = HN
      Y(yN, 2)
      _N = r(Instance.new("TextLabel"))
      _N.Size = UDim2.new(1, -50, 0, 20)
      _N.Position = UDim2.new(0, 12, 0, 4)
      _N.TextTruncate = Enum.TextTruncate.AtEnd
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
      QN(HN, _N, UDim2.new(0, 12, 0, 35))
      local function QN(aN, hN, fN, LN)
        local ON = r(Instance.new("TextLabel"))
        ON.AnchorPoint = Vector2.new(1, 0)
        ON.Size = UDim2.fromOffset(44, 10)
        ON.Position = UDim2.new(1, -fN, 0, 22)
        ON.BackgroundTransparency = 1
        ON.Text = aN
        ON.TextColor3 = f.textMuted
        ON.TextSize = 8
        ON.Font = Enum.Font.GothamBold
        ON.TextXAlignment = Enum.TextXAlignment.Left
        ON.Parent = HN
        local aN = r(Instance.new("TextBox"))
        aN.AnchorPoint = Vector2.new(1, 0)
        aN.Size = UDim2.fromOffset(44, 22)
        aN.Position = UDim2.new(1, -fN, 0, 33)
        aN.BackgroundColor3 = f.bgDark
        aN.BorderSizePixel = 0
        aN.Text = tostring(hN)
        aN.TextColor3 = f.text
        aN.TextSize = 10
        aN.Font = Enum.Font.GothamBold
        aN.ClearTextOnFocus = false
        aN.Parent = HN
        Y(aN, 5)
        F(aN, Color3.fromRGB(56, 56, 56), 1)
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
      QN("NORMAL", UN.boost, 58, function(aN)
        UN.boost = aN
        J["CustomBoost_" .. UN.name] = aN
        oN()
        pcall(function()
          if _G.__refreshSpeedBillboards then
            _G.__refreshSpeedBillboards()
          end
        end)
      end)
      QN("CARRY", UN.steal, 8, function(aN)
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
      QN.Size = UDim2.fromOffset(22, 18)
      QN.Position = UDim2.new(1, -30, 0, 4)
      QN.BackgroundColor3 = Color3.fromRGB(71, 71, 71)
      QN.BorderSizePixel = 0
      QN.Text = "X"
      QN.TextColor3 = Color3.fromRGB(202, 202, 202)
      QN.TextSize = 10
      QN.Font = Enum.Font.GothamBold
      QN.Parent = HN
      Y(QN, 5)
      local function aN()
        local hN = Z == UN.name
        HN.BackgroundTransparency = hN and 0.5 or 0.74
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
        fN.Size = UDim2.new(hN[1], hN[2], 0, 14)
        fN.Position = UDim2.new(aN[1], aN[2], 0, 8)
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
        LN.Size = UDim2.new(fN[1], fN[2], 0, 24)
        LN.Position = UDim2.new(hN[1], hN[2], 0, 24)
        LN.BackgroundColor3 = f.bgDark
        LN.BorderSizePixel = 0
        LN.Text = aN
        LN.TextColor3 = f.text
        LN.TextSize = 10
        LN.Font = Enum.Font.GothamBold
        LN.ClearTextOnFocus = false
        LN.Parent = HN
        Y(LN, 5)
        F(LN, Color3.fromRGB(56, 56, 56), 1)
        return LN
      end
      _N("NAME", { 0, 12 }, { 0.42, -10 })
      _N("NORMAL", { 0.42, 4 }, { 0.29, -6 })
      _N("CARRY", { 0.71, 2 }, { 0.29, -12 })
      local aN, hN, fN, LN =
        UN("Custom " .. tostring(#L + 1), { 0, 12 }, { 0.42, -10 }),
        UN("59", { 0.42, 4 }, { 0.29, -6 }),
        UN("29", { 0.71, 2 }, { 0.29, -12 }),
        r(Instance.new("TextLabel"))
      LN.Size = UDim2.new(1, -24, 0, 14)
      LN.Position = UDim2.new(0, 12, 1, -20)
      LN.BackgroundTransparency = 1
      LN.Text = ""
      LN.TextColor3 = Color3.fromRGB(176, 176, 176)
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
      iN:SetAttribute("ZDuelsButtonThemeControl", true)
      iN.Size = UDim2.new(1, 0, 0, fN and R.toggleBindH or R.toggleH)
      iN.BackgroundColor3 = f.row
      iN.BackgroundTransparency = 0.74
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
        local ON, jN = UN and (Color3.fromRGB(28, 28, 28)) or f.row, UN and 0.45 or 0.74
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
      hN:SetAttribute("ZDuelsButtonThemeControl", true)
      hN.Size = UDim2.new(1, 0, 0, R.actionH)
      hN.BackgroundColor3 = f.row
      hN.BackgroundTransparency = 0.74
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
    UN(o, string.upper(_G.__ZDuelsInfJumpMode or "hold"), function()
      _G.__ZDuelsInfJumpMode = (_G.__ZDuelsInfJumpMode or "hold") == "hold" and "manual"
        or "hold"
      if y["Inf Jump"] then
        if _G.__ZDuelsInfJumpMode == "hold" and startInfJump then
          pcall(startInfJump)
        elseif stopInfJump then
          pcall(stopInfJump)
        end
      end
      oN()
      return string.upper(_G.__ZDuelsInfJumpMode)
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
    local aimG, aimRow = _N(o, "Bat Aimbot", "Aimbot", y.Aimbot, 1, false, function(z)
      t("Aimbot", z)
    end)
    _G.__ZDuelsAimVerLabel = function()
      local v = _G.__ZDuelsAimbotVersion
      return v == "Bypass V2" and "V4" or (v == "Bypass" and "V3" or (v == "Clean Hub" and "V2" or "V1"))
    end
    UN(aimRow, _G.__ZDuelsAimVerLabel(), function()
      if _G.__ZDuelsAimbotVersion == "Original" then
        _G.__ZDuelsAimbotVersion = "Clean Hub"
      elseif _G.__ZDuelsAimbotVersion == "Clean Hub" then
        _G.__ZDuelsAimbotVersion = "Bypass"
      elseif _G.__ZDuelsAimbotVersion == "Bypass" then
        _G.__ZDuelsAimbotVersion = "Bypass V2"
      else
        _G.__ZDuelsAimbotVersion = "Original"
      end
      if y.Aimbot and _cypherStop and _cypherStartFollowing then
        pcall(_cypherStop)
        pcall(_cypherStartFollowing, u.Character)
      end
      oN()
      return _G.__ZDuelsAimVerLabel()
    end)
    _N(o, "Auto Bat", "Auto Bat", y["Auto Bat"], 3, false, function(z)
      t("Auto Bat", z)
    end)
    do
      local function aimSpeedRow(order, label, globalName, default)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, R.toggleH)
        row.BackgroundColor3 = f.row
        row.BackgroundTransparency = 0.74
        row.BorderSizePixel = 0
        row.LayoutOrder = order
        row.Parent = o
        Y(row, 10)
        F(row, f.divider, 1)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -90, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = f.text
        lbl.TextSize = R.textSize
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row
        local box = Instance.new("TextBox")
        box.Name = "AimbotSpeedInput"
        box.Size = UDim2.fromOffset(64, p and 22 or 26)
        box.AnchorPoint = Vector2.new(1, 0.5)
        box.Position = UDim2.new(1, -10, 0.5, 0)
        box.BackgroundColor3 = f.accentDim
        box.BorderSizePixel = 0
        box.TextColor3 = f.text
        box.Font = Enum.Font.GothamBold
        box.TextSize = 12
        box.Text = tostring(_G[globalName])
        box.PlaceholderText = tostring(default)
        box.ClearTextOnFocus = false
        box.Parent = row
        Y(box, 5)
        box.FocusLost:Connect(function()
          local n = tonumber((box.Text:gsub(",", ".")))
          if n and n == n then
            _G[globalName] = math.clamp(math.floor(n * 100 + 0.5) / 100, 1, 150)
            oN()
          end
          box.Text = tostring(_G[globalName])
        end)
      end
      aimSpeedRow(4, "Aimbot Speed", "__ZDuelsAimbotSpeedNormal", 58)
      aimSpeedRow(6, "Custom Aimbot Speed", "__ZDuelsAimbotSpeedCustom", 58)
    end
    _N(o, "Anti Bat", "Anti Bat", y["Anti Bat"], 7, false, function(z)
      t("Anti Bat", z)
    end)
    _N(o, "Ragdoll Counter", "Ragdoll Counter", y["Ragdoll Counter"], 8, false, function(z)
      t("Ragdoll Counter", z)
    end)
    nN(o, "RAGDOLL", 9)
    _N(o, "Anti Ragdoll", "Anti Ragdoll", y["Anti Ragdoll"], 10, false, function(z)
      t("Anti Ragdoll", z)
    end)
    _N(o, "Medusa Counter", "Medusa Counter", y["Medusa Counter"], 11, false, function(z)
      t("Medusa Counter", z)
    end)
    _N(o, "Anti Die", "Anti Die", y["Anti Die"], 12, false, function(z)
      t("Anti Die", z)
    end)
    nN(o, "TP BAT", 13)
    local z, z = _N(o, "TP Bat", "TP Bat", y["TP Bat"], 14, false, function(H)
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
    F(H, Color3.fromRGB(75, 75, 75), 1)
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
    j.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    j.BorderSizePixel = 0
    j.ZIndex = 13
    j.Parent = H
    Y(j, 20)
    local e = Instance.new("Frame")
    e.Size = UDim2.new(0, 8, 0, 8)
    e.Position = UDim2.new(0, 2, 0.5, -4)
    e.BackgroundColor3 = Color3.fromRGB(171, 171, 171)
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
    F(B, Color3.fromRGB(63, 63, 63), 1)
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
    F(QN, Color3.fromRGB(63, 63, 63), 1)
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
      j.BackgroundColor3 = HN and f.accent or (Color3.fromRGB(31, 31, 31))
      e.BackgroundColor3 = HN and (Color3.fromRGB(248, 248, 248)) or (Color3.fromRGB(171, 171, 171))
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
    nN(o, "MIRROR TP", 15)
    _N(o, "Mirror TP Down", "Mirror TP Down", y["Mirror TP Down"], 16, false, function(z)
      t("Mirror TP Down", z)
    end)
    do
      if _G.__ZDuelsMirrorConn then
        pcall(function()
          _G.__ZDuelsMirrorConn:Disconnect()
        end)
      end
      local mPrev, mLast = {}, 0
      local RS = game:GetService("RunService")
      local PL = game:GetService("Players")
      _G.__ZDuelsMirrorConn = RS.Heartbeat:Connect(function()
        if y["Mirror TP Down"] ~= true or not (y.Aimbot == true or y["TP Bat"] == true) then
          if next(mPrev) ~= nil then
            table.clear(mPrev)
          end
          return
        end
        local lp = PL.LocalPlayer
        for _, pl in ipairs(PL:GetPlayers()) do
          if pl ~= lp and pl.Character then
            local rr = pl.Character:FindFirstChild("HumanoidRootPart")
            if rr then
              local cy = rr.Position.Y
              local py = mPrev[pl.UserId]
              if py and py - cy >= 3 then
                pcall(function()
                  local ch = lp.Character
                  local root = ch and ch:FindFirstChild("HumanoidRootPart")
                  local hm = ch and ch:FindFirstChildOfClass("Humanoid")
                  if not root or not hm or hm.Health <= 0 then
                    return
                  end
                  local now = tick()
                  if now - mLast < 0.08 then
                    return
                  end
                  mLast = now
                  local _, yaw = root.CFrame:ToEulerAnglesYXZ()
                  root.CFrame = CFrame.new(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, yaw, 0)
                  root.AssemblyLinearVelocity = Vector3.zero
                end)
                table.clear(mPrev)
                return
              end
              mPrev[pl.UserId] = cy
            end
          end
        end
      end)
      pcall(_G.__ZDuelsTrackConn, _G.__ZDuelsMirrorConn)
    end
    nN(o, "AUTO STEAL", 19)
    G, L = _N(o, "Auto Steal", "auto steal", y["auto steal"], 20, false, function(z)
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
    uN(o, "Steal Radius", O.Radius, 21, function(z)
      O.Radius = math.clamp(math.floor(z), 10, 150)
      oN()
    end)
    local z = w.Visual
    nN(z, "VISUAL", -2)
    _N(z, "Anti Lag", "Anti Lag", y["Anti Lag"], -1, false, function(_)
      t("Anti Lag", _)
    end)
    _N(z, "ESP Players", "ESP Players", y["ESP Players"], 1, false, function(_)
      t("ESP Players", _)
    end)
    _N(z, "ESP Line", "Player Tracers", y["Player Tracers"], 2, false, function(_)
      t("Player Tracers", _)
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
      _G.__ZDuelsSkyChangerMode = I
      if y["Sky Changer"] then
        U(I)
      end
      oN()
      return string.upper(I)
    end)
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
      U.Text = tostring(_G.__ZDuelsButtonsSize or 1)
      U.PlaceholderText = "0.5 - 2"
      U.ClearTextOnFocus = false
      U.ZIndex = 8
      U.Parent = _
      Y(U, 5)
      U.FocusLost:Connect(function()
        U.Text = tostring(_G.__ZDuelsSetButtonsSize(U.Text))
      end)
    end
    yN(z, "reset butons pos.", nil, 17, function()
      _G.__ZDuelsResetButtonPositions()
      if _G.ZDuelsBypass and _G.ZDuelsBypass.ResetPosition then
        _G.ZDuelsBypass.ResetPosition()
      end
    end)
    _N(z, "Lock Buttons", "Lock Buttons", y["Lock Buttons"], 18, false, function(_)
      t("Lock Buttons", _)
    end)
    yN(z, "Hide GUI Key", "Toggle UI", 19, function()
      g.Visible = false
    end)
    nN(z, "PANELS", 20)
    yN(z, "Open Bypass", nil, 22, function()
      local visible = _G._ZDuelsBypassOpen == true
      if _G.ZDuelsBypass and _G.ZDuelsBypass.SetVisible then
        pcall(_G.ZDuelsBypass.SetVisible, not visible)
      elseif _G.__openBypassGUI then
        pcall(_G.__openBypassGUI, not visible)
      end
    end)
    do
      local HALLOWEEN_ORANGE = Color3.fromRGB(255, 125, 0)
      _G.__ZDuelsHalloweenImg = "rbxassetid://114005874982706"
      _G.__ZDuelsHalloween = y["Halloween Mode"] == true

      local _bgImages = {
        "rbxassetid://106198980844513",
        "rbxassetid://133480996347048",
        "rbxassetid://130445102143088",
        "rbxassetid://93606486246798",
      }
      table.insert(_G.__ZDuelsBgLists, _bgImages)
      local _bgNames = { "Style 1", "Style 2", "Style 3", "Style 4" }
      local _curBgIdx = math.clamp(tonumber(_G._ZDuelsHub_UI_BgIndex) or 1, 1, 4)

      local function _bgFor(idx)
        if _G.__ZDuelsHalloween then
          return _G.__ZDuelsHalloweenImg
        end
        return _bgImages[idx]
      end

      local function _applyBg(idx)
        _curBgIdx = math.clamp(idx, 1, 4)
        _G._ZDuelsHub_UI_BgIndex = _curBgIdx
        _G._ZDuelsHub_BgIndexRef = _curBgIdx
        local asset = _bgFor(_curBgIdx)
        if _G._ZDuelsHub_BgImageRef then
          pcall(function() _G._ZDuelsHub_BgImageRef.Image = asset end)
        end
        if _G._ZDuelsHub_AutoGrabBgSync then
          pcall(_G._ZDuelsHub_AutoGrabBgSync, _curBgIdx)
        end
        if _G.ZDuelsBypass then
          if _G.ZDuelsBypass.SetHalloweenStyle then
            pcall(_G.ZDuelsBypass.SetHalloweenStyle, _G.__ZDuelsHalloween == true)
          end
          if _G.ZDuelsBypass.SetBackground then
            pcall(_G.ZDuelsBypass.SetBackground, _curBgIdx)
          end
        end
        if _G._ZDuelsHub_BypassBgRef then
          pcall(function() _G._ZDuelsHub_BypassBgRef.Image = asset end)
        end
        if _G._ZDuelsHub_MainBgRef and _G._ZDuelsHub_MainBgRef.Parent then
          pcall(function() _G._ZDuelsHub_MainBgRef.Image = asset; _G._ZDuelsHub_MainBgRef.ImageTransparency = 0 end)
        end
        local legBg = g:FindFirstChild("LegacyBackgroundStub")
        if legBg then
          pcall(function() legBg.Image = asset; legBg.Visible = true end)
        end
        oN()  
      end

      local _setHalloween
      do
      local _hFwd, _hInv = {}, {}
      local function _hKey(rr, gg, bb) return rr * 65536 + gg * 256 + bb end
      local function _hInts(c)
        return math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)
      end
      for k = 60, 204 do
        local ko = math.min(255, math.floor(k * 1.25 + 0.5))
        local go = math.floor(ko * 0.52 + 0.5)
        local bo = math.floor(ko * 0.06 + 0.5)
        _hFwd[k] = Color3.fromRGB(ko, go, bo)
        _hInv[_hKey(ko, go, bo)] = Color3.fromRGB(k, k, k)
      end
      local _hFwdL = {}
      for k = 205, 255 do
        local dd = k - 205
        local go, bo = 120 + dd, 20 + math.floor(dd / 3)
        _hFwdL[k] = Color3.fromRGB(255, go, bo)
        _hInv[_hKey(255, go, bo)] = Color3.fromRGB(k, k, k)
      end
      local function _hMapFwd(c, allowLight)
        local rr, gg, bb = _hInts(c)
        if rr == gg and gg == bb then
          local o = _hFwd[rr]
          if o then return o, true end
          if allowLight then
            o = _hFwdL[rr]
            if o then return o, true end
          end
          return nil
        end
        local hh, ss, vv = c:ToHSV()
        if ss > 0.25 and vv > 0.3 and hh > 0.5 and hh < 0.9 then
          return Color3.fromHSV(0.075, math.max(ss, 0.85), vv), false
        end
        if ss <= 0.25 and vv >= 0.24 and (allowLight or vv < 0.8) then
          return Color3.fromHSV(0.075, 0.9, math.min(1, vv * 1.25)), false
        end
        return nil
      end
      local function _hLight(o, prop)
        if prop == "TextColor3" then return true end
        if o:IsA("UIStroke") then return true end
        if o:IsA("UIGradient") then
          local par = o.Parent
          return not (par and (par:IsA("ImageLabel") or par:IsA("ImageButton")))
        end
        return false
      end
      local function _hMapInv(c)
        return _hInv[_hKey(_hInts(c))]
      end

      local _pBG = { "BackgroundColor3" }
      local _pText = { "BackgroundColor3", "TextColor3" }
      local _pImage = { "BackgroundColor3", "ImageColor3" }
      local _pScroll = { "BackgroundColor3", "ScrollBarImageColor3" }
      local _pColor = { "Color" }
      local _hClassCache = {}
      local function _hPropsRaw(o)
        if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
          return _pText
        elseif o:IsA("ImageLabel") or o:IsA("ImageButton") then
          return _pImage
        elseif o:IsA("ScrollingFrame") then
          return _pScroll
        elseif o:IsA("GuiObject") then
          return _pBG
        elseif o:IsA("UIStroke") or o:IsA("UIGradient") then
          return _pColor
        end
        return nil
      end
      local function _hProps(o)
        local cn = o.ClassName
        local cached = _hClassCache[cn]
        if cached == nil then
          cached = _hPropsRaw(o) or false
          _hClassCache[cn] = cached
        end
        return cached or nil
      end
      local function _hGet(o, prop) return o[prop] end
      local function _hSet(o, prop, v) o[prop] = v end

      local _hRec = setmetatable({}, { __mode = "k" })
      local function _hRecFor(o)
        local rec = _hRec[o]
        if not rec then
          rec = {}
          _hRec[o] = rec
        end
        return rec
      end

      local function _hApply(o, forward)
        local props = _hProps(o)
        if not props then return end
        for _, prop in ipairs(props) do
          local ok, cur = pcall(_hGet, o, prop)
          if ok and cur ~= nil then
            if typeof(cur) == "Color3" then
              if forward then
                local nc, neutral = _hMapFwd(cur, _hLight(o, prop))
                if nc then
                  if not neutral then
                    _hRecFor(o)[prop] = { orig = cur, mappedKey = _hKey(_hInts(nc)) }
                  end
                  pcall(_hSet, o, prop, nc)
                end
              else
                local rec = _hRec[o] and _hRec[o][prop]
                if rec and _hKey(_hInts(cur)) == rec.mappedKey then
                  pcall(_hSet, o, prop, rec.orig)
                  _hRec[o][prop] = nil
                else
                  local oc = _hMapInv(cur)
                  if oc then pcall(_hSet, o, prop, oc) end
                end
              end
            elseif typeof(cur) == "ColorSequence" then
              if forward then
                local kps, changed = {}, false
                for _, kp in ipairs(cur.Keypoints) do
                  local nc = _hMapFwd(kp.Value, _hLight(o, prop))
                  if nc then changed = true end
                  table.insert(kps, ColorSequenceKeypoint.new(kp.Time, nc or kp.Value))
                end
                if changed then
                  _hRecFor(o)[prop] = { orig = cur }
                  pcall(_hSet, o, prop, ColorSequence.new(kps))
                end
              else
                local rec = _hRec[o] and _hRec[o][prop]
                if rec and rec.orig then
                  pcall(_hSet, o, prop, rec.orig)
                  _hRec[o][prop] = nil
                else
                  local kps, changed = {}, false
                  for _, kp in ipairs(cur.Keypoints) do
                    local oc = _hMapInv(kp.Value)
                    if oc then changed = true end
                    table.insert(kps, ColorSequenceKeypoint.new(kp.Time, oc or kp.Value))
                  end
                  if changed then pcall(_hSet, o, prop, ColorSequence.new(kps)) end
                end
              end
            end
          end
        end
      end

      local _hSavedF = nil
      local function _hSweep(forward, gen)
        local roots, seen = {}, {}
        local mainRoot = _G.__ZDuelsHalloweenRoot
        local bypassRoot = _G.__ZDuelsBypassGui
        local function addRoot(r)
          if not r or seen[r] or not r.Parent then return end
          if r ~= mainRoot and r ~= bypassRoot then
            if (mainRoot and r:IsDescendantOf(mainRoot)) or (bypassRoot and r:IsDescendantOf(bypassRoot)) then
              return
            end
          end
          seen[r] = true
          table.insert(roots, r)
        end
        addRoot(mainRoot)
        addRoot(bypassRoot)
        for _, r in ipairs(_G.__ZDuelsThemeRoots or {}) do addRoot(r) end
        for r in pairs(_G.__ZDuelsHExtra or {}) do addRoot(r) end
        for _, root in ipairs(roots) do
          local list = root:GetDescendants()
          for i, o in ipairs(list) do
            if gen ~= _G.__ZDuelsHalloweenGen then return end
            _hApply(o, forward)
            if i % 400 == 0 then task.wait() end
          end
        end
      end

      function _setHalloween(on)
        on = on == true
        _G.__ZDuelsHalloween = on
        _G.__ZDuelsHalloweenGen = (_G.__ZDuelsHalloweenGen or 0) + 1
        local gen = _G.__ZDuelsHalloweenGen
        pcall(function()
          if _G.ZDuelsBypass and _G.ZDuelsBypass.SetHalloweenStyle then
            _G.ZDuelsBypass.SetHalloweenStyle(on)
          elseif _G.ZDuelsBypass and _G.ZDuelsBypass.SetBackground then
            _G.ZDuelsBypass.SetBackground(tonumber(_G._ZDuelsHub_UI_BgIndex) or 1)
          end
        end)
        if on then
          if not _hSavedF then
            _hSavedF = {
              accent = f.accent,
              accentDim = f.accentDim,
              divider = f.divider,
              textMuted = f.textMuted,
              textDim = f.textDim,
            }
          end
          for key, col in pairs(_hSavedF) do
            local nc = _hMapFwd(col)
            if nc then f[key] = nc end
          end
          _G.__ZDuelsThemeAccent = HALLOWEEN_ORANGE
        else
          if _hSavedF then
            for key, col in pairs(_hSavedF) do f[key] = col end
            _hSavedF = nil
          end
          _G.__ZDuelsThemeAccent = nil
        end
        if _G.__ZDuelsRefreshESPTheme then
          pcall(_G.__ZDuelsRefreshESPTheme, _G.__ZDuelsThemeAccent, Color3.fromRGB(0, 0, 0))
        end
        pcall(_applyBg, _curBgIdx)
        task.spawn(function()
          _hSweep(on, gen)
          while on and gen == _G.__ZDuelsHalloweenGen do
            task.wait(0.75)
            if gen ~= _G.__ZDuelsHalloweenGen then break end
            _hSweep(true, gen)
          end
        end)
      end
      T["Halloween Mode"] = _setHalloween
      end 

      nN(z, "HALLOWEEN MODE \u{1F383}", 23)
      for _, ch in ipairs(z:GetChildren()) do
        if ch:IsA("Frame") and ch.LayoutOrder == 23 then
          for _, d in ipairs(ch:GetChildren()) do
            if d:IsA("TextLabel") then
              d.TextColor3 = HALLOWEEN_ORANGE
              d.Size = UDim2.new(1, -20, 1, 0)
            elseif d.Name == "SectionAccent" then
              d.BackgroundColor3 = HALLOWEEN_ORANGE
            elseif d.Name == "SectionLine" then
              d.Visible = false
            end
          end
        end
      end
      _N(z, "Halloween Mode \u{1F383}", "Halloween Mode", y["Halloween Mode"], 24, false, function(_)
        t("Halloween Mode", _)
      end)

      nN(z, "BACKGROUND", 25)

      local bgRowFrame = Instance.new("Frame")
      bgRowFrame.Name = "BgPickerRow"
      bgRowFrame.Size = UDim2.new(1, 0, 0, p and 50 or 58)
      bgRowFrame.BackgroundTransparency = 1
      bgRowFrame.BorderSizePixel = 0
      bgRowFrame.LayoutOrder = 26
      bgRowFrame.Parent = z

      local listL = Instance.new("UIListLayout", bgRowFrame)
      listL.FillDirection = Enum.FillDirection.Horizontal
      listL.SortOrder = Enum.SortOrder.LayoutOrder
      listL.HorizontalAlignment = Enum.HorizontalAlignment.Center
      listL.VerticalAlignment = Enum.VerticalAlignment.Center
      listL.Padding = UDim.new(0, 6)

      local _bgBtnRefs = {}
      local _thumbH = p and 38 or 46

      local function _refreshBgHighlight()
        for i, btn in ipairs(_bgBtnRefs) do
          local stroke = btn:FindFirstChildWhichIsA("UIStroke")
          if stroke then
            stroke.Transparency = (i == _curBgIdx) and 0 or 0.75
            stroke.Thickness = (i == _curBgIdx) and 2 or 1
            stroke.Color = (i == _curBgIdx) and f.accent or f.divider
          end
        end
      end

      for i = 1, 4 do
        local btn = Instance.new("TextButton")
        btn.Name = "BgThumb" .. i
        btn.Size = UDim2.new(0.25, -5, 0, _thumbH)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 6
        btn.LayoutOrder = i
        btn.Parent = bgRowFrame
        local sizeLimit = Instance.new("UISizeConstraint", btn)
        sizeLimit.MaxSize = Vector2.new(64, _thumbH)
        Y(btn, 6)
        local img = Instance.new("ImageLabel", btn)
        img.Size = UDim2.new(1, 0, 1, 0)
        img.BackgroundTransparency = 1
        img.Image = _bgImages[i]
        img.ScaleType = Enum.ScaleType.Crop
        img.ZIndex = 7
        Y(img, 6)
        local lbl = Instance.new("TextLabel", btn)
        lbl.Size = UDim2.new(1, 0, 0, 11)
        lbl.Position = UDim2.new(0, 0, 1, -11)
        lbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        lbl.BackgroundTransparency = 0.35
        lbl.BorderSizePixel = 0
        lbl.Text = _bgNames[i]
        lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
        lbl.TextSize = p and 6 or 8
        lbl.Font = Enum.Font.GothamBold
        lbl.ZIndex = 8
        local stroke = Instance.new("UIStroke", btn)
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        table.insert(_bgBtnRefs, btn)
        btn.MouseButton1Click:Connect(function()
          _applyBg(i)
          _refreshBgHighlight()
        end)
      end

      _refreshBgHighlight()

      do 
      nN(z, "TAB POSITION", 27)
      local tpRow = Instance.new("Frame")
      tpRow.Name = "TabPosRow"
      tpRow.Size = UDim2.new(1, 0, 0, p and 30 or 34)
      tpRow.BackgroundTransparency = 1
      tpRow.BorderSizePixel = 0
      tpRow.LayoutOrder = 28
      tpRow.Parent = z
      local tpList = Instance.new("UIListLayout", tpRow)
      tpList.FillDirection = Enum.FillDirection.Horizontal
      tpList.SortOrder = Enum.SortOrder.LayoutOrder
      tpList.HorizontalAlignment = Enum.HorizontalAlignment.Center
      tpList.VerticalAlignment = Enum.VerticalAlignment.Center
      tpList.Padding = UDim.new(0, 6)
      local tpBtns = {}
      local function tpRefresh()
        for key, b in pairs(tpBtns) do
          local on = (_G.__ZDuelsTabPos == key)
          b.BackgroundColor3 = on and f.accentDim or f.row
          b.BackgroundTransparency = on and 0.1 or 0.45
          local st = b:FindFirstChildWhichIsA("UIStroke")
          if st then
            st.Color = on and f.accent or f.divider
            st.Transparency = on and 0 or 0.7
          end
        end
      end
      for i, key in ipairs({ "Bottom", "Top", "Left", "Right" }) do
        local b = Instance.new("TextButton")
        b.Name = "TabPos" .. key
        b.Size = UDim2.new(0.25, -5, 0, p and 24 or 28)
        b.BackgroundColor3 = f.row
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Text = key
        b.TextColor3 = f.text
        b.TextSize = p and 8 or 10
        b.Font = Enum.Font.GothamBold
        b.LayoutOrder = i
        b.Parent = tpRow
        Y(b, 6)
        F(b, f.divider, 1)
        tpBtns[key] = b
        b.MouseButton1Click:Connect(function()
          if _G.__ZDuelsApplyTabPos then
            pcall(_G.__ZDuelsApplyTabPos, key)
          else
            _G.__ZDuelsTabPos = key
          end
          tpRefresh()
          oN()
        end)
      end
      tpRefresh()
      end 

      do 
      local ZF = _G.ZDFonts or {}
      _G.ZDFonts = ZF
      ZF.orig = ZF.orig or {}
      ZF.size = ZF.size or {}
      ZF.m = ZF.m or setmetatable({}, { __mode = "k" })
      ZF.aconns = ZF.aconns or setmetatable({}, { __mode = "k" })
      ZF.tconns = ZF.tconns or setmetatable({}, { __mode = "k" })
      ZF.lastLen = ZF.lastLen or setmetatable({}, { __mode = "k" })
      ZF.hooked = ZF.hooked or setmetatable({}, { __mode = "k" })
      ZF.conns = ZF.conns or {}
      ZF.stamp = ZF.stamp or 0
      ZF.MIN_SIZE = 7
      ZF.MARGIN = 8
      ZF.MAX_GROW = 1.35
      ZF.WEIGHT_LABEL = {
        Thin = "Thin", ExtraLight = "ExLight", Light = "Light", Regular = "",
        Medium = "Medium", SemiBold = "SemiBold", Bold = "Bold", ExtraBold = "ExBold", Heavy = "Heavy",
      }
      _G.__ZDuelsFontChoice = _G.__ZDuelsFontChoice or "Default"

      function ZF.list()
        if ZF.cache then
          return ZF.cache
        end
        local out = { { key = "Default", label = "Default", font = nil } }
        local seen, families = {}, {}
        for _, item in ipairs(Enum.Font:GetEnumItems()) do
          if item.Name ~= "Unknown" then
            local ok, fnt = pcall(Font.fromEnum, item)
            if ok and fnt and fnt.Family and not seen[fnt.Family] then
              seen[fnt.Family] = true
              local nice = tostring(fnt.Family):match("([^/\\]+)%.json$")
                or tostring(fnt.Family):match("([^/\\]+)$")
                or item.Name
              families[#families + 1] = { family = fnt.Family, nice = nice }
            end
          end
        end
        for _, fam in ipairs(families) do
          for _, w in ipairs(Enum.FontWeight:GetEnumItems()) do
            for _, italic in ipairs({ false, true }) do
              local ok, fnt = pcall(Font.new, fam.family, w, italic and Enum.FontStyle.Italic or Enum.FontStyle.Normal)
              if ok and fnt then
                local wl = ZF.WEIGHT_LABEL[w.Name] or w.Name
                local label = fam.nice
                if wl ~= "" then
                  label = label .. " " .. wl
                end
                if italic then
                  label = label .. " Italic"
                end
                out[#out + 1] = {
                  key = tostring(fam.family) .. "|" .. w.Name .. "|" .. (italic and "i" or "n"),
                  label = label,
                  font = fnt,
                }
              end
            end
          end
        end
        ZF.cache = out
        return out
      end

      function ZF.byKey(key)
        for _, e in ipairs(ZF.list()) do
          if e.key == key then
            return e
          end
        end
        return nil
      end

      function ZF.ensureStarborn()
        if ZF.starborn then
          return ZF.starborn
        end
        if type(isfile) ~= "function" or type(writefile) ~= "function" or type(getcustomasset) ~= "function" then
          return nil
        end
        local ok = pcall(function()
          if not isfile("starborn.ttf") then
            local okh, data = pcall(game.HttpGet, game, "https://files.catbox.moe/pwgdui.ttf")
            if not okh or not data or #data < 1000 then
              error("download failed")
            end
            writefile("starborn.ttf", data)
          end
          if not isfile("starborn.json") then
            writefile("starborn.json", game:GetService("HttpService"):JSONEncode({
              name = "Starborn",
              faces = { { name = "Regular", weight = 400, style = "normal", assetId = getcustomasset("starborn.ttf") } },
            }))
          end
          ZF.starborn = Font.new(getcustomasset("starborn.json"))
        end)
        return ok and ZF.starborn or nil
      end

      function ZF.current()
        if y["Starborn Font"] == true and ZF.starborn then
          return ZF.starborn
        end
        local key = _G.__ZDuelsFontChoice
        if not key or key == "Default" then
          return nil
        end
        local e = ZF.byKey(key)
        return e and e.font or nil
      end

      function ZF.roots()
        local list, seen = {}, {}
        local mainRoot = _G.__ZDuelsHalloweenRoot
        local bypassRoot = _G.__ZDuelsBypassGui
        local function add(r)
          if not r or seen[r] or not r.Parent then
            return
          end
          if r ~= mainRoot and r ~= bypassRoot then
            if (mainRoot and r:IsDescendantOf(mainRoot)) or (bypassRoot and r:IsDescendantOf(bypassRoot)) then
              return
            end
          end
          seen[r] = true
          list[#list + 1] = r
        end
        add(mainRoot)
        add(bypassRoot)
        for _, r in ipairs(_G.__ZDuelsThemeRoots or {}) do
          add(r)
        end
        for r in pairs(_G.__ZDuelsHExtra or {}) do
          add(r)
        end
        return list
      end

      function ZF.isGlyph(obj)
        local t = obj.Text
        if t == nil then
          return false
        end
        if string.match(t, "%w") then
          return false
        end
        local ok, n = pcall(utf8.len, t)
        return ok and n ~= nil and n <= 1
      end

      local function isTextObj(o)
        return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")
      end

      function ZF.applyOne(obj, font)
        if not isTextObj(obj) then
          return
        end
        if obj:GetAttribute("ZDFontLock") then
          return
        end
        if ZF.orig[obj] == nil then
          ZF.orig[obj] = obj.FontFace
          ZF.size[obj] = obj.TextSize
        end
        if ZF.isGlyph(obj) then
          font = nil
        end
        pcall(function()
          obj.FontFace = font or ZF.orig[obj]
          if ZF.size[obj] then
            obj.TextSize = ZF.size[obj]
          end
        end)
      end

      function ZF.params()
        if ZF.gtbp == nil then
          local ok, prm = pcall(Instance.new, "GetTextBoundsParams")
          ZF.gtbp = (ok and prm) or false
        end
        return ZF.gtbp or nil
      end

      function ZF.reclamp(obj)
        local c = ZF.m[obj]
        if not c then
          return
        end
        if ZF.isGlyph(obj) then
          if obj.TextSize ~= c.base then
            obj.TextSize = c.base
          end
          return
        end
        local sc = c.s0
        local box = obj.AbsoluteSize
        if box.X > 1 and box.Y > 1 then
          local auto = obj.AutomaticSize
          local freeX = (auto == Enum.AutomaticSize.X or auto == Enum.AutomaticSize.XY)
          local freeY = (auto == Enum.AutomaticSize.Y or auto == Enum.AutomaticSize.XY)
          if not freeY then
            sc = math.min(sc, math.max(box.Y - 2, 1) / c.by)
          end
          if not (freeX or c.wrapped) then
            sc = math.min(sc, math.max(box.X - math.min(ZF.MARGIN, box.X * 0.08), 1) / c.bx)
          end
        end
        local want = math.floor(c.base * sc + 0.5)
        if want < ZF.MIN_SIZE then
          want = ZF.MIN_SIZE
        end
        if obj.TextSize ~= want then
          obj.TextSize = want
        end
      end

      function ZF.measure(obj)
        local font = ZF.current()
        if not font then
          return false
        end
        local prm = ZF.params()
        if not prm then
          return false
        end
        ZF.tsvc = ZF.tsvc or game:GetService("TextService")
        local base = ZF.size[obj]
        if not base then
          base = obj.TextSize
          ZF.size[obj] = base
        end
        local txt = obj.Text
        if txt == nil or txt == "" then
          ZF.m[obj] = { base = base, bx = 1, by = 1, s0 = 1, stamp = ZF.stamp, text = txt }
          return true
        end
        local wrapped = obj.TextWrapped and obj.AbsoluteSize.X > 1
        prm.Text = txt
        prm.Size = base
        prm.Width = wrapped and obj.AbsoluteSize.X or 0
        prm.Font = font
        local ok, b = pcall(function()
          return ZF.tsvc:GetTextBoundsAsync(prm)
        end)
        if not (ok and b and b.X > 0 and b.Y > 0) then
          return false
        end
        local s0 = 1
        local of = ZF.orig[obj]
        if of then
          prm.Font = of
          local ok2, b2 = pcall(function()
            return ZF.tsvc:GetTextBoundsAsync(prm)
          end)
          if ok2 and b2 and b2.X > 0 and b2.Y > 0 then
            s0 = wrapped and (b2.Y / b.Y) or (b2.X / b.X)
          end
        end
        if s0 > ZF.MAX_GROW then
          s0 = ZF.MAX_GROW
        end
        ZF.m[obj] = { base = base, bx = b.X, by = b.Y, s0 = s0, wrapped = wrapped, stamp = ZF.stamp, text = txt }
        return true
      end

      function ZF.fitOne(obj)
        if not ZF.current() then
          return
        end
        if obj:GetAttribute("ZDFontLock") or not isTextObj(obj) or obj.TextScaled then
          return
        end
        if ZF.isGlyph(obj) then
          return true
        end
        local c = ZF.m[obj]
        if not (c and c.stamp == ZF.stamp and c.text == obj.Text) then
          if not ZF.measure(obj) then
            return false
          end
        end
        ZF.reclamp(obj)
        return true
      end

      function ZF.watch(obj)
        if ZF.aconns[obj] then
          return
        end
        ZF.aconns[obj] = obj:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
          if not ZF.current() then
            return
          end
          if ZF.m[obj] then
            ZF.reclamp(obj)
          else
            pcall(ZF.fitOne, obj)
          end
        end)
        if ZF.tconns[obj] then
          return
        end
        ZF.tconns[obj] = obj:GetPropertyChangedSignal("Text"):Connect(function()
          if not ZF.current() then
            return
          end
          if ZF.lastLen[obj] == #obj.Text then
            return
          end
          ZF.lastLen[obj] = #obj.Text
          pcall(ZF.applyOne, obj, ZF.current())
          pcall(ZF.fitOne, obj)
        end)
      end

      function ZF.fit(pass)
        ZF.fitToken = (ZF.fitToken or 0) + 1
        local myToken = ZF.fitToken
        if not ZF.current() then
          return
        end
        ZF.tsvc = ZF.tsvc or game:GetService("TextService")
        task.spawn(function()
          local list = {}
          for _, root in ipairs(ZF.roots()) do
            for _, d in ipairs(root:GetDescendants()) do
              if isTextObj(d) and not d.TextScaled and not d:GetAttribute("ZDFontLock") then
                list[#list + 1] = d
              end
            end
          end
          for i, o in ipairs(list) do
            if ZF.fitToken ~= myToken then
              return
            end
            if o.Parent then
              ZF.fitOne(o)
              ZF.lastLen[o] = #o.Text
              ZF.watch(o)
            end
            if i % 150 == 0 then
              task.wait()
            end
          end
          pass = (tonumber(pass) or 0) + 1
          if pass < 3 then
            task.delay(pass == 1 and 0.35 or 1.5, function()
              if ZF.fitToken ~= myToken then
                return
              end
              ZF.stamp = ZF.stamp + 1
              ZF.fit(pass)
            end)
          end
        end)
      end

      function ZF.applyAll()
        local font = ZF.current()
        for _, root in ipairs(ZF.roots()) do
          ZF.applyOne(root, font)
          for _, d in ipairs(root:GetDescendants()) do
            ZF.applyOne(d, font)
          end
        end
        ZF.fit()
      end

      function ZF.hook()
        for _, c in ipairs(ZF.conns) do
          pcall(function()
            c:Disconnect()
          end)
        end
        ZF.conns = {}
        ZF.hooked = setmetatable({}, { __mode = "k" })
        for _, root in ipairs(ZF.roots()) do
          ZF.hooked[root] = true
          ZF.conns[#ZF.conns + 1] = root.DescendantAdded:Connect(function(d)
            if not ZF.current() then
              return
            end
            ZF.applyOne(d, ZF.current())
            pcall(ZF.fitOne, d)
            pcall(ZF.watch, d)
          end)
        end
        ZF.guardToken = (ZF.guardToken or 0) + 1
        local gt = ZF.guardToken
        task.spawn(function()
          while gt == ZF.guardToken and ZF.current() do
            task.wait(1.5)
            if gt ~= ZF.guardToken or not ZF.current() then
              break
            end
            for _, root in ipairs(ZF.roots()) do
              if not ZF.hooked[root] then
                ZF.hooked[root] = true
                local font = ZF.current()
                ZF.applyOne(root, font)
                for _, d in ipairs(root:GetDescendants()) do
                  ZF.applyOne(d, font)
                end
                ZF.fit()
                ZF.conns[#ZF.conns + 1] = root.DescendantAdded:Connect(function(d)
                  if not ZF.current() then
                    return
                  end
                  ZF.applyOne(d, ZF.current())
                  pcall(ZF.fitOne, d)
                  pcall(ZF.watch, d)
                end)
              end
            end
          end
        end)
      end

      function ZF.set(key)
        _G.__ZDuelsFontChoice = key or "Default"
        ZF.stamp = ZF.stamp + 1
        ZF.applyAll()
        ZF.hook()
        oN()
      end

      T["Starborn Font"] = function(on)
        if on then
          task.spawn(function()
            if not ZF.ensureStarborn() then
              y["Starborn Font"] = false
              if M["Starborn Font"] then
                pcall(M["Starborn Font"])
              end
              return
            end
            ZF.stamp = ZF.stamp + 1
            ZF.applyAll()
            ZF.hook()
          end)
        else
          ZF.stamp = ZF.stamp + 1
          ZF.applyAll()
          ZF.hook()
        end
      end

      nN(z, "CUSTOM FONT", 29)
      local fontRow = Instance.new("Frame")
      fontRow.Name = "FontRow"
      fontRow.Size = UDim2.new(1, 0, 0, p and 34 or 38)
      fontRow.BackgroundColor3 = f.row
      fontRow.BackgroundTransparency = 0.74
      fontRow.BorderSizePixel = 0
      fontRow.LayoutOrder = 30
      fontRow.Parent = z
      Y(fontRow, 8)
      local fontLabel = Instance.new("TextLabel")
      fontLabel.Size = UDim2.new(1, -78, 1, 0)
      fontLabel.Position = UDim2.new(0, 10, 0, 0)
      fontLabel.BackgroundTransparency = 1
      fontLabel.TextColor3 = f.text
      fontLabel.TextSize = p and 9 or 11
      fontLabel.Font = Enum.Font.GothamBold
      fontLabel.TextXAlignment = Enum.TextXAlignment.Left
      fontLabel.TextTruncate = Enum.TextTruncate.AtEnd
      fontLabel.Parent = fontRow
      local function fontLabelRefresh()
        local e = ZF.byKey(_G.__ZDuelsFontChoice or "Default")
        fontLabel.Text = "Font: " .. (e and e.label or "Default")
      end
      fontLabelRefresh()
      local pickBtn = Instance.new("TextButton")
      pickBtn.Name = "FontPick"
      pickBtn.Size = UDim2.new(0, 56, 0, p and 22 or 24)
      pickBtn.Position = UDim2.new(1, -64, 0.5, p and -11 or -12)
      pickBtn.BackgroundColor3 = f.accentDim
      pickBtn.BackgroundTransparency = 0.15
      pickBtn.BorderSizePixel = 0
      pickBtn.AutoButtonColor = false
      pickBtn.Text = "PICK"
      pickBtn.TextColor3 = f.text
      pickBtn.TextSize = p and 9 or 10
      pickBtn.Font = Enum.Font.GothamBlack
      pickBtn.Parent = fontRow
      Y(pickBtn, 6)
      F(pickBtn, f.divider, 1)

      local fontPopup = Instance.new("Frame")
      fontPopup.Name = "FontPopup"
      fontPopup.Size = UDim2.new(1, -12, 1, -12)
      fontPopup.Position = UDim2.new(0, 6, 0, 6)
      fontPopup.BackgroundColor3 = f.bgDark
      fontPopup.BackgroundTransparency = 0.04
      fontPopup.BorderSizePixel = 0
      fontPopup.Visible = false
      fontPopup.ZIndex = 200
      fontPopup.Active = true
      fontPopup.Parent = g
      Y(fontPopup, 10)
      F(fontPopup, f.divider, 1)
      local popTitle = Instance.new("TextLabel")
      popTitle.Size = UDim2.new(1, -44, 0, 28)
      popTitle.Position = UDim2.new(0, 10, 0, 4)
      popTitle.BackgroundTransparency = 1
      popTitle.Text = "CUSTOM FONT"
      popTitle.TextColor3 = f.text
      popTitle.TextSize = p and 11 or 13
      popTitle.Font = Enum.Font.GothamBlack
      popTitle.TextXAlignment = Enum.TextXAlignment.Left
      popTitle.ZIndex = 201
      popTitle.Parent = fontPopup
      local popClose = Instance.new("TextButton")
      popClose.Size = UDim2.new(0, 26, 0, 26)
      popClose.Position = UDim2.new(1, -32, 0, 5)
      popClose.BackgroundColor3 = f.row
      popClose.BackgroundTransparency = 0.3
      popClose.BorderSizePixel = 0
      popClose.AutoButtonColor = false
      popClose.Text = "X"
      popClose.TextColor3 = f.text
      popClose.TextSize = 12
      popClose.Font = Enum.Font.GothamBlack
      popClose.ZIndex = 202
      popClose.Parent = fontPopup
      Y(popClose, 6)
      local popList = Instance.new("ScrollingFrame")
      popList.Size = UDim2.new(1, -12, 1, -42)
      popList.Position = UDim2.new(0, 6, 0, 36)
      popList.BackgroundTransparency = 1
      popList.BorderSizePixel = 0
      popList.ScrollBarThickness = 3
      popList.ScrollBarImageColor3 = f.accent
      popList.AutomaticCanvasSize = Enum.AutomaticSize.Y
      popList.CanvasSize = UDim2.new(0, 0, 0, 0)
      popList.ZIndex = 201
      popList.Parent = fontPopup
      local popLay = Instance.new("UIListLayout", popList)
      popLay.SortOrder = Enum.SortOrder.LayoutOrder
      popLay.Padding = UDim.new(0, 4)
      local popCards = {}
      local popBuilt = false
      local function popRefresh()
        for key, card in pairs(popCards) do
          local on = (_G.__ZDuelsFontChoice == key)
          local st = card:FindFirstChildWhichIsA("UIStroke")
          if st then
            st.Color = on and f.accent or f.divider
            st.Thickness = on and 2 or 1
            st.Transparency = on and 0 or 0.7
          end
        end
      end
      local function popBuild()
        if popBuilt then
          return
        end
        popBuilt = true
        task.spawn(function()
          for i, e in ipairs(ZF.list()) do
            if not fontPopup.Parent then
              return
            end
            local card = Instance.new("TextButton")
            card:SetAttribute("ZDFontLock", true)
            card.Name = "FontCard"
            card.Size = UDim2.new(1, -6, 0, p and 28 or 32)
            card.BackgroundColor3 = f.row
            card.BackgroundTransparency = 0.5
            card.BorderSizePixel = 0
            card.AutoButtonColor = false
            card.Text = e.label
            card.TextColor3 = f.text
            card.TextSize = p and 13 or 15
            card.TextXAlignment = Enum.TextXAlignment.Left
            card.LayoutOrder = i
            card.ZIndex = 202
            if e.font then
              card.FontFace = e.font
            else
              card.Font = Enum.Font.GothamBold
            end
            local pad = Instance.new("UIPadding", card)
            pad.PaddingLeft = UDim.new(0, 10)
            Y(card, 6)
            F(card, f.divider, 1)
            card.Parent = popList
            popCards[e.key] = card
            card.MouseButton1Click:Connect(function()
              ZF.set(e.key)
              fontLabelRefresh()
              popRefresh()
            end)
            if i % 25 == 0 then
              popRefresh()
              task.wait()
            end
          end
          popRefresh()
        end)
      end
      pickBtn.MouseButton1Click:Connect(function()
        fontPopup.Visible = true
        popBuild()
        popRefresh()
      end)
      popClose.MouseButton1Click:Connect(function()
        fontPopup.Visible = false
      end)

      _N(z, "Starborn Font", "Starborn Font", y["Starborn Font"], 31, false, function(_)
        t("Starborn Font", _)
      end)

      task.spawn(function()
        task.wait(0.6)
        if y["Starborn Font"] == true and not ZF.ensureStarborn() then
          y["Starborn Font"] = false
        end
        if ZF.current() then
          ZF.stamp = ZF.stamp + 1
          ZF.applyAll()
          ZF.hook()
        end
      end)
      end 

      do 
        if _G.ZDCustomTools and _G.ZDCustomTools.shutdown then
          pcall(_G.ZDCustomTools.shutdown)
        end
        local LP = game:GetService("Players").LocalPlayer
        local ASSETS = {
          DiamondSword = {
            cat = "Bat", label = "Diamond Sword",
            mesh = "rbxassetid://8827558932", tex = "rbxassetid://8827558969",
            scale = Vector3.new(0.2, 0.2, 0.2),
            c0 = CFrame.new(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), 300),
          },
          Katana = {
            cat = "Bat", label = "Katana",
            mesh = "rbxassetid://13528902482", tex = "rbxassetid://13528902373",
            scale = Vector3.new(1.4, 1.4, 1.4),
            c0 = CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)),
          },
          Skull = {
            cat = "Medusa", label = "Skull",
            mesh = "rbxassetid://2050312704", tex = "rbxassetid://2050313393",
            scale = Vector3.new(1, 1, 1),
            c0 = CFrame.new(0, 0.65, -0.4) * CFrame.Angles(math.rad(330), 0, 0),
          },
          GoldenDesertEagle = {
            cat = "Medusa", label = "Gold Eagle",
            mesh = "rbxassetid://430251413", tex = "rbxassetid://435840335",
            scale = Vector3.new(0.01, 0.01, 0.01),
            c0 = CFrame.new(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0),
          },
        }
        local SOUNDS = {
          Bat = { id = "rbxassetid://5713085119", skip = 0.2 },
          Medusa = { id = "rbxassetid://3102797479", doublePlay = true, delay = 0.5 },
        }
        local skins = {
          Bat = _G.__ZDuelsCTSkinBat or "DiamondSword",
          Medusa = _G.__ZDuelsCTSkinMedusa or "GoldenDesertEagle",
        }
        if not (ASSETS[skins.Bat] and ASSETS[skins.Bat].cat == "Bat") then
          skins.Bat = "DiamondSword"
        end
        if not (ASSETS[skins.Medusa] and ASSETS[skins.Medusa].cat == "Medusa") then
          skins.Medusa = "GoldenDesertEagle"
        end
        _G.__ZDuelsCTSkinBat, _G.__ZDuelsCTSkinMedusa = skins.Bat, skins.Medusa
        _G.__ZDuelsCSMode = (_G.__ZDuelsCSMode == "Bat" or _G.__ZDuelsCSMode == "Medusa") and _G.__ZDuelsCSMode or "Both"

        local ctTracked = setmetatable({}, { __mode = "k" })
        local csTracked = setmetatable({}, { __mode = "k" })
        local csHooked = setmetatable({}, { __mode = "k" })
        local ctOn, csOn = y["Custom Tools"] == true, y["Custom Sounds"] == true
        local alive = true

        local function catOf(tool)
          local n = tool.Name:lower()
          if n:find("bat", 1, true) or n:find("slap", 1, true) then
            return "Bat"
          end
          if n:find("medusa", 1, true) then
            return "Medusa"
          end
          return nil
        end
        local function isReplica(d)
          return d.Name == "LocalReplica" or d:FindFirstAncestor("LocalReplica") ~= nil
        end

        local function buildReplica(handle, key)
          local old = handle:FindFirstChild("LocalReplica")
          if old then
            old:Destroy()
          end
          local data = ASSETS[key] or ASSETS.DiamondSword
          local m = Instance.new("Model")
          m.Name = "LocalReplica"
          local part = Instance.new("Part")
          part.Name = "MainPart"
          part.CanCollide = false
          part.CanQuery = false
          part.CanTouch = false
          part.Massless = true
          part.Size = Vector3.new(1, 1, 1)
          part.Transparency = 0
          part.Anchored = false
          part.Parent = m
          local mesh = Instance.new("SpecialMesh")
          mesh.MeshType = Enum.MeshType.FileMesh
          mesh.MeshId = data.mesh
          mesh.TextureId = data.tex
          mesh.Scale = data.scale
          mesh.Parent = part
          local w = Instance.new("Motor6D")
          w.Part0 = handle
          w.Part1 = part
          w.C0 = data.c0
          w.Parent = part
          m.Parent = handle
        end
        local function hidePass(tool, entry)
          for _, d in ipairs(tool:GetDescendants()) do
            if (d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture")) and not isReplica(d) then
              if entry.hidden[d] == nil then
                entry.hidden[d] = d.Transparency
              end
              if d.Transparency ~= 1 then
                d.Transparency = 1
              end
            end
          end
        end
        local function ctEnsure(tool, cat)
          local handle = tool:FindFirstChild("Handle")
          if not handle then
            return
          end
          local entry = ctTracked[tool]
          if not entry then
            entry = { hidden = {} }
            ctTracked[tool] = entry
          end
          local rep = handle:FindFirstChild("LocalReplica")
          local mp = rep and rep:FindFirstChild("MainPart")
          local motor = mp and mp:FindFirstChildOfClass("Motor6D")
          if not rep or not mp or not motor or motor.Part0 ~= handle or entry.skin ~= skins[cat] then
            buildReplica(handle, skins[cat])
            entry.skin = skins[cat]
          end
          hidePass(tool, entry)
        end
        local function ctTeardown(tool)
          local entry = ctTracked[tool]
          if not entry then
            return
          end
          local handle = tool:FindFirstChild("Handle")
          local rep = handle and handle:FindFirstChild("LocalReplica")
          if rep then
            pcall(function()
              rep:Destroy()
            end)
          end
          for d, tr in pairs(entry.hidden) do
            if d.Parent then
              pcall(function()
                d.Transparency = tr
              end)
            end
          end
          ctTracked[tool] = nil
        end

        local function csPlay(entry)
          local cs = entry.sound
          if not cs or not cs.Parent then
            return
          end
          local d = entry.data
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
              if not entry.alive then
                return
              end
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
        local function csHook(entry, snd)
          if not snd:IsA("Sound") or snd.Name == "CustomSound" or csHooked[snd] or entry.muted[snd] ~= nil then
            return
          end
          entry.muted[snd] = snd.Volume
          csHooked[snd] = true
          local function trigger()
            if not entry.alive then
              return
            end
            if snd.Playing or snd.TimePosition > 0 then
              pcall(function()
                snd.Volume = 0
                snd:Stop()
              end)
              csPlay(entry)
            end
          end
          local c1 = snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
          local c2 = snd:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
          table.insert(entry.conns, c1)
          table.insert(entry.conns, c2)
          local c3
          c3 = snd.AncestryChanged:Connect(function(_, parent)
            if parent then
              return
            end
            pcall(function()
              c1:Disconnect()
            end)
            pcall(function()
              c2:Disconnect()
            end)
            pcall(function()
              c3:Disconnect()
            end)
            csHooked[snd] = nil
            entry.muted[snd] = nil
          end)
          table.insert(entry.conns, c3)
          if snd.Playing then
            trigger()
          end
        end
        local function csEnsure(tool, cat)
          local entry = csTracked[tool]
          if not entry then
            local handle = tool:FindFirstChild("Handle")
            if not handle then
              return
            end
            local data = SOUNDS[cat]
            local old = handle:FindFirstChild("CustomSound")
            if old then
              pcall(function()
                old:Destroy()
              end)
            end
            local cs = Instance.new("Sound")
            cs.Name = "CustomSound"
            cs.SoundId = data.id
            cs.Volume = 1
            cs.Looped = false
            cs.RollOffMode = Enum.RollOffMode.Inverse
            cs.MaxDistance = 1000
            cs.MinDistance = 1000
            cs.Parent = handle
            entry = { sound = cs, data = data, conns = {}, muted = {}, alive = true }
            csTracked[tool] = entry
          end
          for _, d in ipairs(tool:GetDescendants()) do
            csHook(entry, d)
          end
        end
        local function csTeardown(tool)
          local entry = csTracked[tool]
          if not entry then
            return
          end
          entry.alive = false
          if entry.timer then
            pcall(task.cancel, entry.timer)
            entry.timer = nil
          end
          for _, c in ipairs(entry.conns) do
            pcall(function()
              c:Disconnect()
            end)
          end
          if entry.sound then
            pcall(function()
              entry.sound:Destroy()
            end)
          end
          for snd, vol in pairs(entry.muted) do
            csHooked[snd] = nil
            if snd and snd.Parent then
              pcall(function()
                snd.Volume = vol
              end)
            end
          end
          csTracked[tool] = nil
        end

        local function soundAllowed(cat)
          local m = _G.__ZDuelsCSMode
          return m == "Both" or m == cat
        end
        local function scan()
          local seen = {}
          for _, c in ipairs({ LP:FindFirstChildOfClass("Backpack"), LP.Character }) do
            if c then
              for _, tool in ipairs(c:GetChildren()) do
                if tool:IsA("Tool") then
                  local cat = catOf(tool)
                  if cat then
                    seen[tool] = true
                    if ctOn then
                      pcall(ctEnsure, tool, cat)
                    elseif ctTracked[tool] then
                      ctTeardown(tool)
                    end
                    if csOn and soundAllowed(cat) then
                      pcall(csEnsure, tool, cat)
                    elseif csTracked[tool] then
                      csTeardown(tool)
                    end
                  end
                end
              end
            end
          end
          for tool in pairs(ctTracked) do
            if not seen[tool] or not tool.Parent then
              ctTeardown(tool)
            end
          end
          for tool in pairs(csTracked) do
            if not seen[tool] or not tool.Parent then
              csTeardown(tool)
            end
          end
        end

        local api = {}
        function api.setTools(on)
          ctOn = on == true
          pcall(scan)
        end
        function api.setSounds(on)
          csOn = on == true
          pcall(scan)
        end
        function api.setSkin(cat, key)
          if ASSETS[key] and ASSETS[key].cat == cat then
            skins[cat] = key
            if cat == "Bat" then
              _G.__ZDuelsCTSkinBat = key
            else
              _G.__ZDuelsCTSkinMedusa = key
            end
            pcall(scan)
            oN()
          end
        end
        function api.setSoundMode(mode)
          _G.__ZDuelsCSMode = (mode == "Bat" or mode == "Medusa") and mode or "Both"
          pcall(scan)
          oN()
        end
        function api.shutdown()
          alive = false
          ctOn, csOn = false, false
          pcall(scan)
        end
        _G.ZDCustomTools = api
        T["Custom Tools"] = api.setTools
        T["Custom Sounds"] = api.setSounds
        task.spawn(function()
          while alive do
            task.wait(0.4)
            if ctOn or csOn or next(ctTracked) ~= nil or next(csTracked) ~= nil then
              pcall(scan)
            end
          end
        end)

        local function choiceRow(order, caption, options, getter, setter)
          local rowH = p and 34 or 38
          local row = Instance.new("Frame")
          row.Size = UDim2.new(1, 0, 0, rowH)
          row.BackgroundColor3 = f.row
          row.BackgroundTransparency = 0.74
          row.BorderSizePixel = 0
          row.LayoutOrder = order
          row.Parent = z
          Y(row, 8)
          local capW = p and 46 or 54
          local cap = Instance.new("TextLabel")
          cap.Size = UDim2.new(0, capW, 1, 0)
          cap.Position = UDim2.new(0, 8, 0, 0)
          cap.BackgroundTransparency = 1
          cap.Text = caption
          cap.TextColor3 = f.text
          cap.TextSize = p and 9 or 11
          cap.Font = Enum.Font.GothamBold
          cap.TextXAlignment = Enum.TextXAlignment.Left
          cap.Parent = row
          local holder = Instance.new("Frame")
          holder.Size = UDim2.new(1, -(capW + 18), 0, rowH - 10)
          holder.Position = UDim2.new(0, capW + 12, 0.5, -(rowH - 10) / 2)
          holder.BackgroundTransparency = 1
          holder.Parent = row
          local lay = Instance.new("UIListLayout", holder)
          lay.FillDirection = Enum.FillDirection.Horizontal
          lay.SortOrder = Enum.SortOrder.LayoutOrder
          lay.VerticalAlignment = Enum.VerticalAlignment.Center
          lay.Padding = UDim.new(0, 4)
          local btns = {}
          local function refresh()
            for key, b in pairs(btns) do
              local on = getter() == key
              b.BackgroundColor3 = on and f.accentDim or f.row
              b.BackgroundTransparency = on and 0.1 or 0.45
              local st = b:FindFirstChildWhichIsA("UIStroke")
              if st then
                st.Color = on and f.accent or f.divider
                st.Transparency = on and 0 or 0.7
              end
            end
          end
          for i, opt in ipairs(options) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1 / #options, -4, 1, 0)
            b.BackgroundColor3 = f.row
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.Text = opt.label
            b.TextColor3 = f.text
            b.TextScaled = true
            b.Font = Enum.Font.GothamBold
            b.LayoutOrder = i
            b.Parent = holder
            local tsc = Instance.new("UITextSizeConstraint", b)
            tsc.MaxTextSize = p and 9 or 11
            tsc.MinTextSize = 5
            Y(b, 6)
            F(b, f.divider, 1)
            btns[opt.key] = b
            b.MouseButton1Click:Connect(function()
              setter(opt.key)
              refresh()
            end)
          end
          refresh()
        end

        nN(z, "CUSTOM TOOLS", 32)
        _N(z, "Custom Tools", "Custom Tools", y["Custom Tools"], 33, false, function(_)
          t("Custom Tools", _)
        end)
        choiceRow(34, "Bat", {
          { key = "DiamondSword", label = "Diamond Sword" },
          { key = "Katana", label = "Katana" },
        }, function()
          return skins.Bat
        end, function(key)
          api.setSkin("Bat", key)
        end)
        choiceRow(35, "Medusa", {
          { key = "GoldenDesertEagle", label = "Gold Eagle" },
          { key = "Skull", label = "Skull" },
        }, function()
          return skins.Medusa
        end, function(key)
          api.setSkin("Medusa", key)
        end)

        nN(z, "CUSTOM SOUNDS", 36)
        _N(z, "Custom Sounds", "Custom Sounds", y["Custom Sounds"], 37, false, function(_)
          t("Custom Sounds", _)
        end)
        choiceRow(38, "Sound", {
          { key = "Both", label = "Both" },
          { key = "Bat", label = "Bat only" },
          { key = "Medusa", label = "Medusa only" },
        }, function()
          return _G.__ZDuelsCSMode
        end, function(key)
          api.setSoundMode(key)
        end)

        if ctOn or csOn then
          task.defer(function()
            pcall(scan)
          end)
        end
      end 

      _applyBg(_curBgIdx)
      if _G.__ZDuelsHalloween then
        _setHalloween(true)
      end
    end
    yN = w.Animations
    nN(yN, "ANIMATION SOURCE", 0)
    local z = _G.__ZDuelsAnimationPreset
    if not z or not Q[z] then
      z = x or n[1]
    end
    uN = Instance.new("Frame")
    uN.Size = UDim2.new(1, 0, 0, 42)
    uN.BackgroundColor3 = f.row
    uN.BackgroundTransparency = 0.74
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
      _G.__ZDuelsAnimationPreset = z
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
    local o = _G.__ZDuelsOriginalAnimations
    if type(o) ~= "table" then
      o = setmetatable({}, { __mode = "k" })
      _G.__ZDuelsOriginalAnimations = o
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
        _G.__ZDuelsAnimationPreset = z
        pcall(U, z, false)
      else
        pcall(U, nil, true)
      end
      if M["Harder Hit Anim"] then
        pcall(M["Harder Hit Anim"])
      end
    end
    local z, n = _N(yN, "Animations", "Animaciones", y.Animaciones, 2, false, function(Q)
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
    _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function()
      if not y.Animaciones or not _G.__ZDuelsAnimationPreset then
        return
      end
      task.wait(0.75)
      pcall(U, _G.__ZDuelsAnimationPreset, false)
    end))
    if y.Animaciones and _G.__ZDuelsAnimationPreset then
      task.defer(function()
        task.wait(0.5)
        pcall(U, _G.__ZDuelsAnimationPreset, false)
      end)
    end
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
      { "Anti Bat", "Anti Bat" },
      { "Drop Brainrot", "Drop", true },
      { "TP Down", "TP Down", true },
      { "Insta Reset", "Insta Reset", true },
      { "Toggle UI", "Toggle UI" },
      { "Hide UI", "Hide UI", true },
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
      _.Size = UDim2.new(1 / 5, -3, 0, p and 28 or 30)
      _.TextScaled = true
      do
        local tsc = Instance.new("UITextSizeConstraint", _)
        tsc.MaxTextSize = p and 9 or 10
        tsc.MinTextSize = 5
      end
      _.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
      _.BackgroundTransparency = H == z and 0.2 or 0.3
      _.BorderSizePixel = 0
      _.Text = Q[H] or (string.upper(H))
      _.TextColor3 = f.text
      _.TextSize = p and 9 or 10
      _.Font = Enum.Font.GothamBold
      _.LayoutOrder = U
      _.Parent = W
      Y(_, 6)
      n = Instance.new("Frame")
      n.Name = "Indicator"
      n.Size = UDim2.new(0.6, 0, 0, 2)
      n.Position = UDim2.new(0.2, 0, 0, 0)
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
    z.Name = "ZDuelsRestoreButton"
    z.Size = UDim2.new(0, 120, 0, 30)
    o = _G._ZDuelsHub_UI_ModernMiniPos
    z.Position = o and (UDim2.fromOffset(o.x or 6, o.y or 54)) or (UDim2.new(0, 6, 0, 54))
    z.BackgroundColor3 = f.bgDark
    z.BorderSizePixel = 0
    z.Text = "Z Duels"
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
      _G.__ZDuelsPanelVisible = g.Visible
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
      local sideEx = (_G.__ZDuelsTabPos == "Left" or _G.__ZDuelsTabPos == "Right") and (p and 52 or 62) or 0
      if p then
        g.Size = UDim2.new(
          0,
          math.min(n, math.clamp(math.floor(Q.X * 0.46), 196, 265) + sideEx),
          0,
          math.min(o, math.clamp(math.floor(Q.Y * 0.70), 300, 440))
        )
      else
        g.Size = UDim2.new(0, math.min(265 + sideEx, n), 0, math.min(640, o))
      end
      o = { g, z }
      for z, n in ipairs(o) do
        z = n.Position
        X(n, z.X.Scale, z.X.Offset, z.Y.Scale, z.Y.Offset)
      end
    end
    local function applyTabPos(pos)
      if pos ~= "Top" and pos ~= "Left" and pos ~= "Right" then
        pos = "Bottom"
      end
      _G.__ZDuelsTabPos = pos
      local panel = W.Parent
      if not panel then
        return
      end
      local header = panel:FindFirstChild("HeaderFrame")
      local hH = header and header.Size.Y.Offset or 56
      local content = panel:FindFirstChild("ContentFrame")
      if not content then
        return
      end
      local barH = p and 34 or 38
      local sideW = p and 52 or 62
      local horizontal = (pos == "Bottom" or pos == "Top")
      local layout = W:FindFirstChildOfClass("UIListLayout")
      if layout then
        layout.FillDirection = horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, horizontal and 2 or 5)
      end
      local corner = W:FindFirstChildOfClass("UICorner")
      if corner then
        corner.CornerRadius = UDim.new(0, horizontal and 0 or 10)
      end
      if pos == "Bottom" then
        W.Size = UDim2.new(1, 0, 0, barH)
        W.Position = UDim2.new(0, 0, 1, -barH)
        content.Position = UDim2.new(0, 8, 0, hH + 6)
        content.Size = UDim2.new(1, -16, 1, -(hH + 6 + barH + 10))
      elseif pos == "Top" then
        W.Size = UDim2.new(1, 0, 0, barH)
        W.Position = UDim2.new(0, 0, 0, hH + 4)
        content.Position = UDim2.new(0, 8, 0, hH + 4 + barH + 6)
        content.Size = UDim2.new(1, -16, 1, -(hH + 4 + barH + 6 + 10))
      elseif pos == "Left" then
        W.Size = UDim2.new(0, sideW, 1, -(hH + 6 + 10))
        W.Position = UDim2.new(0, 6, 0, hH + 6)
        content.Position = UDim2.new(0, sideW + 12, 0, hH + 6)
        content.Size = UDim2.new(1, -(sideW + 12 + 8), 1, -(hH + 6 + 10))
      else
        W.Size = UDim2.new(0, sideW, 1, -(hH + 6 + 10))
        W.Position = UDim2.new(1, -(sideW + 6), 0, hH + 6)
        content.Position = UDim2.new(0, 8, 0, hH + 6)
        content.Size = UDim2.new(1, -(sideW + 12 + 8), 1, -(hH + 6 + 10))
      end
      for _, tb in ipairs(W:GetChildren()) do
        if tb:IsA("TextButton") then
          if horizontal then
            tb.Size = UDim2.new(1 / 5, -3, 0, p and 28 or 30)
          else
            tb.Size = UDim2.new(1, -8, 0, p and 30 or 34)
          end
        end
      end
      pcall(R)
    end
    _G.__ZDuelsApplyTabPos = applyTabPos
    applyTabPos(_G.__ZDuelsTabPos)
    R()
    local z
    local function n()
      if z then
        z:Disconnect()
        z = nil
      end
      local Q = workspace.CurrentCamera
      if Q then
        z = _G.__ZDuelsTrackConn(Q:GetPropertyChangedSignal("ViewportSize"):Connect(function()
          task.defer(R)
        end))
      end
      task.defer(R)
    end
    _G.__ZDuelsTrackConn(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(n))
    n()
  end)()
  _G.__ZDuelsRegisterThemeRoot(h)
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
    _G.__ZDuelsTrackConn(C.InputBegan:Connect(function(b, R)
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
          l.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
          l.TextColor3 = Color3.fromRGB(170, 170, 170)
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
    local z = _G.__ZDuelsInfJumpState or {}
    _G.__ZDuelsInfJumpState = z
    z.conn = z.conn or nil
    z.lastJumpTime = z.lastJumpTime or 0
    z.manualLock = false
    local function b()
      return false
    end
    local function R()
      if (_G.__ZDuelsInfJumpMode or "hold") ~= "manual" or z.manualLock then
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
    _G.__ZDuelsTrackConn(C.InputBegan:Connect(function(n, Q)
      if Q then
        return
      end
      if n.KeyCode == Enum.KeyCode.Space or n.KeyCode == Enum.KeyCode.ButtonA then
        if (_G.__ZDuelsInfJumpMode or "hold") == "manual" then
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
        if not y["Inf Jump"] or (_G.__ZDuelsInfJumpMode or "hold") ~= "hold" then
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
    _G.__ZDuelsTrackStopper(stopInfJump)
    T["Inf Jump"] = function(z)
      if z and (_G.__ZDuelsInfJumpMode or "hold") == "hold" then
        startInfJump()
      else
        stopInfJump()
      end
    end
    if y["Inf Jump"] and (_G.__ZDuelsInfJumpMode or "hold") == "hold" then
      startInfJump()
    end
    _G.__ZDuelsTrackConn(u.CharacterAdded:Connect(function()
      if y["Inf Jump"] and (_G.__ZDuelsInfJumpMode or "hold") == "hold" then
        task.wait(0.5)
        stopInfJump()
        startInfJump()
      end
    end))
  end)()
  h.Enabled = true
  task.spawn(function()
    local CP = game:GetService("ContentProvider")
    local fix = {}
    _G.__ZDuelsBgFix = fix
    local pending = 0
    for _, id in ipairs({ "106198980844513", "133480996347048", "130445102143088", "93606486246798" }) do
      pending += 1
      task.spawn(function()
        local old = "rbxassetid://" .. id
        local probe = Instance.new("ImageLabel")
        probe.Image = old
        pcall(function()
          CP:PreloadAsync({ probe })
        end)
        local ok = false
        pcall(function()
          ok = probe.IsLoaded
        end)
        probe:Destroy()
        if not ok then
          fix[old] = "rbxthumb://type=Asset&id=" .. id .. "&w=768&h=432"
        end
        pending -= 1
      end)
    end
    local t0 = os.clock()
    while pending > 0 and os.clock() - t0 < 8 do
      task.wait(0.1)
    end
    if next(fix) == nil then
      return
    end
    for _, list in ipairs(_G.__ZDuelsBgLists or {}) do
      for i, v in ipairs(list) do
        if fix[v] then
          list[i] = fix[v]
        end
      end
    end
    local function patch(o)
      if o and typeof(o) == "Instance" and fix[o.Image] then
        o.Image = fix[o.Image]
      end
    end
    for _, o in ipairs(h:GetDescendants()) do
      if o:IsA("ImageLabel") or o:IsA("ImageButton") then
        patch(o)
      end
    end
    patch(_G._ZDuelsHub_MainBgRef)
    patch(_G._ZDuelsHub_BypassBgRef)
  end)
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