local function initializeModule()
local ctx = {
[100] = bit32.bnot,
[115] = bit32.rshift,
[120] = table.move,
[16] = function(i, I, I, I)
  return function(I, I)
    return function()
      do
        local I = _G
        pcall(function()
          local D = type(getfenv) == "function"
          if D then
            I = getfenv(0)
          end
        end)
        local D = I
        pcall(function()
          local c = type(getgenv) == "function"
          if c then
            D = getgenv()
          end
        end)
        local c = type(I) ~= "table"
        if c then
          I = _G
        else
        end
        c = type(D) ~= "table"
        if c then
          D = I
        else
        end
        local s = ((((rawget(I, "sethiddenproperty") or rawget(D, "sethiddenproperty")) or rawget(I, "set_hidden_property")) or rawget(D, "set_hidden_property")) or rawget(I, "sethiddenprop")) or rawget(D, "sethiddenprop")
        c = rawget(I, "syn") or rawget(D, "syn")
        if (type(s) ~= "function") and (type(c) == "table") then
          s = rawget(c, "sethiddenproperty") or rawget(c, "set_hidden_property")
        else
        end
        local y = type(s) == "function"
        if y then
          pcall(function()
            local o = I
            rawset(o, "sethiddenproperty", s)
          end)
          pcall(function()
            local o = D
            rawset(o, "sethiddenproperty", s)
          end)
        end
        y = ((((rawget(I, "setfpscap") or rawget(D, "setfpscap")) or rawget(I, "set_fps_cap")) or rawget(D, "set_fps_cap")) or rawget(I, "setfpslimit")) or rawget(D, "setfpslimit")
        y = if (type(y) ~= "function") and (type(c) == "table") then rawget(c, "setfpscap") or rawget(c, "set_fps_cap") else y
        if type(y) == "function" then
          pcall(y, 9999)
        end
      end
      local I, D, c, s, y, o, O, F, M = (function()
        local b = i[48](222631286, 0)
        local w = b
        local G
        G, b = game, i[48](w, 326093885)
        w = G:GetService("Players")
        b = i:rQ((i:HQ(2071895466, b) + i:HQ(2071895466, 411528599)) + (i:HQ(151176364, (i[79](b, 411528599))) + i:HQ(2071895467, (i[48](b, 411528599)))))
        local b = game:GetService("UserInputService")
        local G = b.TouchEnabled
        pcall(function()
          local T = b:GetPlatform()
          local h = b.TouchEnabled and (((T == Enum.Platform.Android) or (T == Enum.Platform.IOS)) or not b.MouseEnabled)
          G = h
        end)
        local T, h, u, U, p, W, n, Q = b, game:GetService("TweenService"), game:GetService("RunService"), game:GetService("ReplicatedStorage"), game:GetService("Lighting"), game:GetService("HttpService"), w.LocalPlayer, G
        return w, T, h, u, U, p, W, n, Q
      end)()
      local b = "unknown"
      do
        local w = _G
        pcall(function()
          local G = type(getgenv) == "function"
          if G then
            w = getgenv()
          end
        end)
        local G = type(w) ~= "table"
        if G then
          w = _G
        else
        end
        local T = (rawget(w, "identifyexecutor") or rawget(w, "getexecutorname")) or ((type(_G) == "table") and (rawget(_G, "identifyexecutor") or rawget(_G, "getexecutorname")))
        G = type(T) == "function"
        if G then
          pcall(function()
            local w = T()
            local G = w ~= nil
            if G then
              b = tostring(w)
            end
          end)
        end
      end
      local w, G = string.find, string.lower
      local T = w(G(b), "wave", 1, true)
      _G.__CrystalWaveSafeMode = T ~= nil
      do
        local b = {"Eclipse_Panel", "EclipseHub", "CRYSTAL_Panel", "DashEffectGui", "CrystalAutoGrabBar", "CrystalLaggerGUI", "CrystalMobileUI", "CrystalEnemyWidget"}
        pcall(function()
          local h = _G.CrystalLagger
          if h then
            if h.Stop then
              h.Stop()
            else
              if h.SetEnabled then
                h.SetEnabled(false)
              end
              if h.SetLowEndEnabled then
                h.SetLowEndEnabled(false)
              end
            end
          end
        end)
        if _G.__CRYSTAL_STATE then
          _G.__CRYSTAL_STATE.alive = false
          pcall(function()
            for h, h in ipairs(_G.__CRYSTAL_STATE.stoppers or {}) do
              pcall(h)
            end
            for h, u in ipairs(_G.__CRYSTAL_STATE.conns or {}) do
              local U = i[48](155694778, 0)
              h = U
              local p
              p, U = pcall, i:rQ(h + 71948380)
              p(function()
                u:Disconnect()
              end)
            end
          end)
        end
        _G.__CRYSTAL_STATE = nil
        _G.__CrystalTrackConn = nil
        _G.__CrystalTrackStopper = nil
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
          local h, u = ipairs, {game:GetService("CoreGui"), F.PlayerGui}
          for U, p in h(u) do
            for h, h in ipairs(b) do
              while true do
                U = p:FindFirstChild(h)
                if not U then
                  break
                end
                U:Destroy()
              end
            end
          end
        end)
        pcall(function()
          for b, h in ipairs(I:GetPlayers()) do
            b = h.Character
            if b then
              for h, h in ipairs(b:GetChildren()) do
                for b, b in ipairs(h:GetChildren()) do
                  if ((((((b.Name == "GreenDuelsBB") or (b.Name == "CrystalSpeedBill")) or (b.Name == "CrystalHubOverhead")) or (b.Name == "CrystalAimbotBodyLock")) or (b.Name == "CrystalAimbotBodyAttachment")) or (b.Name == "CrystalTPBatMarkerBodyLock")) or (b.Name == "CrystalTPBatMarkerAttachment") then
                    b:Destroy()
                  end
                end
              end
            end
          end
        end)
        _G.__CRYSTAL_STATE = {conns = {}, stoppers = {}, alive = true}
        function _G.__CrystalTrackConn(b)
          if b then
            table.insert(_G.__CRYSTAL_STATE.conns, b)
          end
          return b
        end
        function _G.__CrystalTrackStopper(b)
          if b then
            table.insert(_G.__CRYSTAL_STATE.stoppers, b)
          end
        end
        _G.__CrystalResetHooks = {}
        function _G.__CrystalOnNewInstance(b)
          if b then
            table.insert(_G.__CrystalResetHooks, b)
          end
        end
      end
      local b = _G.__CRYSTAL_STATE
      do
        local h, u = {}
        local function U()
          local p = i[48](237435195, 0)
          local W = p
          local n = u
          if n then
            return
          end
          p = i:rQ((i:HQ(732206254, W) + i:HQ(732206254, 524353427)) + (i:HQ(2830554788, (i[79](W, 524353427))) + i:HQ(732206255, (i[48](W, 524353427)))))
          p = i[48](p, 508783668)
          u = s.Heartbeat:Connect(function()
            local p = os.clock() + 0.0008
            while true do
              local W = h[1]
              if not (W and (os.clock() < p)) then
                break
              end
              W = h[1]
              local n = W.cancelled or (W["continue"] and not W["continue"]())
              if n then
                table.remove(h, 1)
              else
                local n = W.pending[#W.pending]
                local Q = not n
                if Q then
                  table.remove(h, 1)
                else
                  local Q = i[48](245158866, 0)
                  local j = Q
                  Q = i:rQ((i:HQ(4220550848, j) + i:HQ(4220550848, 454046921)) + (i:HQ(74416447, (i[89](j, 454046921))) + i:HQ(74416449, (i[79](454046921, j)))))
                  W.pending[#W.pending] = nil
                  j = nil
                  j, Q = pcall, i[48](Q, 445915474)
                  j(W.apply, n)
                  local Q, j = pcall(function()
                    return n:GetChildren()
                  end)
                  if Q then
                    for n, n in ipairs(j) do
                      W.pending[#W.pending + 1] = n
                    end
                  end
                  Q = h[2]
                  if Q then
                    table.remove(h, 1)
                    j = h
                    j[#j + 1] = W
                  end
                end
              end
            end
            p = not h[1]
            if p then
              u:Disconnect()
              u = nil
            end
          end)
          _G.__CrystalTrackConn(u)
        end
        local function p(W, n, Q)
          local j, r = i[48](67879261, 0), {pending = {}, apply = n}
          j = i[48](j, 72738685)
          r["continue"] = Q
          r.cancelled = false
          for j, j in ipairs((if typeof(W) == "Instance" then {W} else W) or {}) do
            if j then
              local W = i[48](407619081, 0)
              Q = W
              n = nil
              n, W = pcall, i:rQ(Q + 102272977)
              local W, J = n(function()
                return j:GetChildren()
              end)
              if W then
                for W, W in ipairs(J) do
                  r.pending[#r.pending + 1] = W
                end
              end
            end
          end
          Q = h
          Q[#Q + 1] = r
          U()
          return function()
            r.cancelled = true
          end
        end
        _G.__CrystalWalkDescendantsBatched = p
        _G.__CrystalTrackStopper(function()
          local U = h
          for p, p in ipairs(U) do
            p.cancelled = true
          end
          h = {}
          U = u
          if U then
            u:Disconnect()
            u = nil
          end
        end)
      end
      do
        local h, u = false, false
        _G.__CrystalAntiDieGuiEnabled = nil
        local U, p = {}
        local function W(n, Q)
          local j = U[n]
          if j then
            if j.healthConn then
              pcall(function()
                j.healthConn:Disconnect()
              end)
            end
            if j.diedConn then
              local r = i[48](323994366, 0)
              local J = r
              local q
              q, r = pcall, i:rQ(J + 146111369)
              q(function()
                j.diedConn:Disconnect()
              end)
            end
            if j.cleanupConn then
              local r = i[48](347479709, 0)
              local J
              J, r = pcall, i:rQ(r + 292777001)
              J(function()
                j.cleanupConn:Disconnect()
              end)
            end
            U[n] = nil
          end
          if (Q and n) and n.Parent then
            pcall(function()
              local Q = n:FindFirstChildOfClass("Humanoid")
              if Q then
                Q.BreakJointsOnDeath = true
                Q:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
              end
            end)
          end
        end
        local function n(Q)
          local j = i[48](335861623, 0)
          local r = j
          if not Q or not Q.Parent then
            return
          end
          local J = Q:FindFirstChildOfClass("Humanoid")
          if not J then
            return
          end
          W(Q, false)
          j = i:rQ((i:HQ(437779604, r) + i:HQ(437779604, 13984648)) + (i:HQ(3419408088, (i[79](r, 13984648))) + i:HQ(437779605, (i[48](r, 13984648)))))
          J.BreakJointsOnDeath = false
          j = i[48](j, 465888758)
          J:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
          local j
          j = {humanoid = J, healthConn = J:GetPropertyChangedSignal("Health"):Connect(function()
            local r = (h and (U[Q] == j)) and (J.Health <= 0)
            if r then
              J.Health = J.MaxHealth
            end
          end), diedConn = J.Died:Connect(function()
            local r = i[48](327055965, 0)
            local q = r
            local _ = task
            r = i:rQ(q + 464649136)
            r = i:rQ(r + 17911218)
            _.defer(function()
              local r = ((h and (U[Q] == j)) and J) and J.Parent
              if r then
                J.BreakJointsOnDeath = false
                J:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                J.Health = J.MaxHealth
              end
            end)
          end), cleanupConn = Q.AncestryChanged:Connect(function()
            if not Q.Parent then
              W(Q, false)
            end
          end)}
          U[Q] = j
        end
        local function Q(j)
          j = j == true
          local r = h
          if j == r then
            return
          end
          h = j
          if j then
            r = not p
            if r then
              local j = i[48](30243997, 0)
              local r = j
              j = i:rQ(r + 23859202)
              r = nil
              r, j = F.CharacterAdded, i:rQ(j + 486402124)
              p = r:Connect(function(j)
                task.wait(0.2)
                local r = (h and j) and j.Parent
                if r then
                  n(j)
                end
              end)
            end
            local j = F.Character
            if (j and j.Parent) and not U[j] then
              n(j)
            end
          else
            for j in pairs(U) do
              W(j, true)
            end
          end
        end
        local W = {toggle = false, autobat = false}
        local function j()
          local r = u
          if r then
            return
          end
          r = W.toggle
          Q((if _G.__CrystalAntiDieGuiEnabled then _G.__CrystalAntiDieGuiEnabled() == true else r) or W.autobat)
        end
        local function r(J, q)
          local _ = u or (W[J] == nil)
          if _ then
            return
          end
          W[J] = q == true
          j()
        end
        _G.__CrystalAntiDieSource = r
        function _G.__CrystalAntiDieSet(r)
          _G.__CrystalAntiDieSource("autobat", r)
        end
        function _G.__CrystalAntiDieIsEnabled()
          local r = h
          return r
        end
        _G.__CrystalTrackStopper(function()
          u = true
          W.toggle = false
          W.autobat = false
          Q(false)
        end)
        local W, r = false, Q
        Q = function(Q)
          r(Q)
          Q = p and not W
          if Q then
            W = true
            _G.__CrystalTrackConn(p)
          end
        end
        _G.__CrystalTrackConn(s.Heartbeat:Connect(function()
          local p = u
          if p then
            return
          end
          j()
          p = h
          if not p then
            return
          end
          p = F.Character
          local h = (p and p.Parent) and p:FindFirstChildOfClass("Humanoid")
          if not h then
            return
          end
          local u = U[p]
          if not u or (u.humanoid ~= h) then
            n(p)
          end
          if h.BreakJointsOnDeath then
            h.BreakJointsOnDeath = false
          end
          u = Enum.HumanoidStateType.Dead
          if h:GetStateEnabled(u) then
            h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
          end
          if h.Health <= 0 then
            h.Health = h.MaxHealth
          end
        end))
      end
      FeatureToggles = FeatureToggles or {}
      local h, u, U, p, W = {}, {Aimbot = true, Autoplay = true, Lagger = true}, {Aimbot = true, Drop = true, ["TP Down"] = true, Autoplay = true, ["ESP Players"] = true, ["Player Tracers"] = true}, {}, {}
      for n, Q in pairs(U) do
        p[n] = false
        W[n] = true
      end
      if featureName == "Toggle UI" then
        bindPill.Visible = true
        bindPill.Position = UDim2.new(1, -48, 0.5, -10)
      end
      local n, Q, j, r, J, q, _, z, K, k, e, X, C = {NormalBoost = 59, NormalSteal = 29, LaggerBoost = 40, LaggerSteal = 20, DesyncBoost = 59, DesyncSteal = 29, MobileButtonScale = 1, FOV = 90, StretchIntensity = 0.75, CypherAimbotApproachSpeed = 59, AimbotSpeed = 59, AimbotSpeedLagger = 40, AimbotSpeedCustom = 59, AutoTPDownHeight = 20}, {}, {Radius = 65, Duration = 1.3}, "v1", "Normal", "1", 1, 59, 30, 40, false, "v2", false
      local a = Vector3.new(0, 0, 0)
      local A, g, R, S = {[Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true, [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true}, {SelectNormalMode = nil, SelectLaggerMode = nil, Drop = nil, Autoplay = nil, ["Toggle UI"] = nil, ["Speed Boost"] = nil, Aimbot = nil, ["Anti Bat"] = nil, ["Carry Speed"] = nil, ["TP Bat"] = nil, FuckerToggle = nil}
      local Z, f, Y, V, v = {}, {}, {}, {}, false
      local l, m, P, x, H = FeaturePostToggle or {}
      _G = _G or {}
      _G.__CrystalDropMode = ((_G.__CrystalDropMode == "Jump Drop") and "Jump Drop") or "Stand Drop"
      _G._CrystalHub_UI_Data = _G._CrystalHub_UI_Data or {}
      local E, N = {}, {}
      _G.__CrystalButtonsSize = 1
      _G.__CrystalGuiPositionResetters = {}
      _G.__CrystalResetButtonPositions = nil
      _G.__CrystalGuiPositionsReset = false
      function _G.__CrystalRoundPanelBackground(d, B)
        local L = Instance.new("CanvasGroup")
        L.Name = "RoundedBackgroundMask"
        L.Size = UDim2.fromScale(1, 1)
        L.Position = UDim2.fromOffset(0, 0)
        L.BackgroundTransparency = 1
        L.BorderSizePixel = 0
        L.GroupTransparency = 0
        L.ZIndex = d.ZIndex
        L.Parent = B
        local t = B:FindFirstChildOfClass("UICorner")
        Instance.new("UICorner", L).CornerRadius = (t and t.CornerRadius) or UDim.new(0, 16)
        t = d:FindFirstChildOfClass("UICorner")
        if t then
          t:Destroy()
        end
        d.Parent = L
      end
      function _G.__CrystalFramePanelBackground(d, B, B)
        d.ScaleType = Enum.ScaleType.Crop
        d.Size = UDim2.fromScale(1, 1)
        d.Position = UDim2.fromScale(0, 0)
      end
      function _G.__EclipseAddOriginalGui3Title(d, B)
        if d then
          d.Text = string.upper(tostring(B or "VLESS HUB"))
        end
      end
      local function d(B, L, t, i7, I7, D7, c7)
        local s7 = workspace.CurrentCamera
        local y7 = (s7 and s7.ViewportSize) or Vector2.new(1920, 1080)
        if (y7.X <= 0) or (y7.Y <= 0) then
          return L, i7
        end
        c7 = c7 or 1
        I7 *= c7
        D7 *= c7
        local c7, s7, o7, O7 = -y7.X * B, (y7.X * (1 - B)) - I7, -y7.Y * t, (y7.Y * (1 - t)) - D7
        return math.clamp(L, c7, if s7 < c7 then c7 else s7), math.clamp(i7, o7, if O7 < o7 then o7 else O7)
      end
      local function B(L, t, i7, I7, D7, c7)
        local s7, y7 = L.Size.X.Offset, L.Size.Y.Offset
        local o7, O7 = d(t, i7, I7, D7, s7, y7, c7)
        L.Position = UDim2.new(t, o7, I7, O7)
        return o7, O7
      end
      local function d()
        return false
      end
      G, U = setmetatable, {__mode = "k"}
      local L = G({}, U)
      _G.__CrystalTrackConn(D.InputChanged:Connect(function(t)
        local i7 = L[t]
        if not i7 then
          return
        end
        if (t.UserInputType ~= Enum.UserInputType.Touch) and (t.UserInputType ~= Enum.UserInputType.MouseMovement) then
          return
        end
        for I7, I7 in ipairs(i7) do
          if (t.Position - I7.tapStart).Magnitude > 12 then
            I7.tapMoved = true
          end
        end
      end))
      _G.__CrystalTrackConn(D.InputEnded:Connect(function(t)
        local i7 = L[t]
        if not i7 then
          return
        end
        L[t] = nil
        for t, t in ipairs(i7) do
          if not t.tapMoved and true then
            if not ((t.scroll and t.scrollCanvasAtStart) and (math.abs(t.scroll.CanvasPosition.Y - t.scrollCanvasAtStart) > 5)) then
              t.callback()
            end
          end
        end
      end))
      local function t(i7, I7)
        local D7 = i[48](15014586, 0)
        local c7 = D7
        local s7
        D7, s7 = i:rQ((i:HQ(180940350, c7) + i:HQ(180940350, 321569164)) + (i:HQ(4114026947, (i[79](c7, 321569164))) + i:HQ(4114026945, (i[89](c7, 321569164))))), d()
        D7 = i[48](D7, 346401013)
        if s7 then
          return
        end
        local function D7(c7)
          if (c7.UserInputType ~= Enum.UserInputType.Touch) and (c7.UserInputType ~= Enum.UserInputType.MouseButton1) then
            return
          end
          local s7, y7 = Scroll, L[c7]
          if not y7 then
            y7 = {}
            L[c7] = y7
          else
          end
          local L, o7 = table.insert, {tapStart = c7.Position, tapMoved = false, scroll = s7}
          o7.scrollCanvasAtStart, o7.callback = (s7 and s7.CanvasPosition.Y) or nil, I7
          L(y7, o7)
        end
        i7.InputBegan:Connect(D7)
      end
      local L, i7, I7, D7, c7 = {["245,250,255"] = Color3.fromRGB(25, 31, 42), ["235,245,255"] = Color3.fromRGB(31, 49, 70), ["210,230,250"] = Color3.fromRGB(35, 57, 82), ["190,220,250"] = Color3.fromRGB(55, 105, 160), ["140,190,240"] = Color3.fromRGB(60, 135, 205), ["80,160,255"] = Color3.fromRGB(38, 112, 205), ["50,110,190"] = Color3.fromRGB(160, 205, 255), ["80,130,200"] = Color3.fromRGB(165, 210, 255), ["40,80,150"] = Color3.fromRGB(150, 200, 255), ["30,90,200"] = Color3.fromRGB(130, 190, 255), ["60,120,200"] = Color3.fromRGB(150, 205, 255), ["100,140,200"] = Color3.fromRGB(165, 210, 255)}, {"BackgroundColor3", "BorderColor3"}, {"BackgroundColor3", "TextColor3", "BorderColor3"}, {"TextColor3", "TextStrokeColor3", "TextStrokeTransparency"}
      w, T = setmetatable, {__mode = "k"}
      local s7 = w({}, T)
      local function y7(o7)
        local O7, F7 = i[48](377970419, 0), o7
        while (F7 and not F7:IsA("GuiButton")) and not F7:GetAttribute("CrystalButtonThemeControl") do
          F7 = F7.Parent
        end
        if not F7 then
          return
        end
        local F7
        F7, O7 = o7:IsA("UIStroke"), i[48](O7, 103949823)
        local M7 = ((F7 and "Color") or (o7:IsA("UIGradient") and "Color")) or (o7:IsA("GuiObject") and "BackgroundColor3")
        F7 = not M7
        O7 = i[48](O7, 419253938)
        if F7 then
          return
        end
        F7 = s7[o7]
        if not F7 then
          local O7 = i[48](531020613, 0)
          F7 = {}
          s7[o7] = F7
          local s7 = _G
          O7 = i[48](O7, 328879983)
          local b7 = s7.__CrystalTrackConn
          O7 = i:rQ((i:HQ(133961651, O7) + i:HQ(133961651, 200573201)) + (i:HQ(4027043994, (i[79](O7, 200573201))) + i:HQ(133961652, (i[48](O7, 200573201)))))
          local function s7()
            y7(o7)
          end
          b7(o7:GetPropertyChangedSignal(M7):Connect(s7))
        else
        end
        if F7.busy then
          return
        end
        local s7 = o7[M7]
        if (s7 == F7.applied) and (F7.theme == _G.__CrystalGuiTheme) then
          return
        end
        if s7 ~= F7.applied then
          F7.original = s7
        end
        local O7 = _G.__CrystalGuiTheme
        local function b7(w7)
          if (O7 ~= "GUI 2") and (O7 ~= "GUI 3") then
            return w7
          end
          local G7, T7, h7 = math.max(w7.R, w7.G, w7.B), ((O7 == "GUI 2") and Color3.fromRGB(29, 16, 43)) or Color3.fromRGB(43, 13, 17), ((O7 == "GUI 2") and Color3.fromRGB(177, 108, 248)) or Color3.fromRGB(246, 65, 77)
          return T7:Lerp(h7, G7)
        end
        local w7 = F7.original
        if o7:IsA("UIGradient") then
          if (O7 == "GUI 2") or (O7 == "GUI 3") then
            local G7 = {}
            for T7, T7 in ipairs(w7.Keypoints) do
              table.insert(G7, ColorSequenceKeypoint.new(T7.Time, b7(T7.Value)))
            end
            w7 = ColorSequence.new(G7)
          else
          end
        else
          w7 = (b7(w7))
        end
        F7.applied = w7
        F7.theme = O7
        if s7 ~= w7 then
          F7.busy = true
          o7[M7] = w7
          F7.busy = false
        end
      end
      c7 = function(s7)
        if not s7 then
          return
        end
        local o7 = if (s7:IsA("TextLabel") or s7:IsA("TextButton")) or s7:IsA("TextBox") then I7 else if s7:IsA("GuiObject") then i7 else nil
        if o7 then
          for I7, O7 in ipairs(o7) do
            I7 = s7[O7]
            local o7 = string.format("%d,%d,%d", math.floor((I7.R * 255) + 0.5), math.floor((I7.G * 255) + 0.5), math.floor((I7.B * 255) + 0.5))
            if L[o7] then
              s7[O7] = L[o7]
            end
          end
        end
        if s7:IsA("UIStroke") then
          local I7 = s7.Color
          local o7 = string.format("%d,%d,%d", math.floor((I7.R * 255) + 0.5), math.floor((I7.G * 255) + 0.5), math.floor((I7.B * 255) + 0.5))
          if (I7.B > (I7.R + 12)) and (I7.B >= I7.G) then
            s7.Color = Color3.fromRGB(0, 0, 0)
          elseif L[o7] then
            s7.Color = L[o7]
          end
        end
        if not _G.__CrystalModernGuiActive and not s7:GetAttribute("CrystalDarkPaletteWatched") then
          local L = i[48](270820298, 0)
          local I7 = L
          s7:SetAttribute("CrystalDarkPaletteWatched", true)
          L = i:rQ((i:HQ(1483531916, I7) + i:HQ(1483531916, 435933127)) + (i:HQ(2811435381, (i[79](I7, 435933127))) + i:HQ(2811435379, (i[89](I7, 435933127)))))
          local function L(I7)
            local o7 = i[48](110876053, 0)
            local O7 = o7
            local F7 = _G
            o7 = i[48](O7, 316625894)
            O7 = F7.__CrystalTrackConn
            o7 = i:rQ((i:HQ(109043813, o7) + i:HQ(109043813, 205030961)) + (i:HQ(4185923484, (i[79](o7, 205030961))) + i:HQ(4185923482, (i[89](o7, 205030961)))))
            local function o7()
              c7(s7)
            end
            O7(s7:GetPropertyChangedSignal(I7):Connect(o7))
          end
          if s7:IsA("UIStroke") then
            L("Color")
          elseif s7:IsA("GuiObject") then
            for I7, I7 in ipairs(i7) do
              L(I7)
            end
            if (s7:IsA("TextLabel") or s7:IsA("TextButton")) or s7:IsA("TextBox") then
              for i7, i7 in ipairs(D7) do
                L(i7)
              end
            end
          end
        end
        y7(s7)
      end
      _G.__CrystalThemeRoots = {}
      U, w = setmetatable, {__mode = "k"}
      local L = U({}, w)
      function _G.__CrystalRegisterThemeRoot(i7)
        local I7 = i[48](378096444, 0)
        local D7 = I7
        if not i7 then
          return
        end
        for s7, s7 in ipairs(_G.__CrystalThemeRoots) do
          if s7 == i7 then
            return
          end
        end
        table.insert(_G.__CrystalThemeRoots, i7)
        I7 = i[48](D7, 399545820)
        c7(i7)
        if L[i7] then
          L[i7]()
        end
        D7 = nil
        D7, I7 = _G, i:rQ((i:HQ(442675748, I7) + i:HQ(442675748, 237963379)) + (i:HQ(3409615800, (i[79](I7, 237963379))) + i:HQ(442675749, (i[48](I7, 237963379)))))
        L[i7] = D7.__CrystalWalkDescendantsBatched(i7, c7, function()
          return i7.Parent ~= nil
        end)
        _G.__CrystalTrackConn(i7.DescendantAdded:Connect(c7))
      end
      function _G.__CrystalApplyTheme()
        for i7, I7 in ipairs(_G.__CrystalThemeRoots) do
          if I7 and I7.Parent then
            local D7 = i[48](78691891, 0)
            i7 = D7
            c7(I7)
            D7 = i:rQ(i7 + 146587757)
            if L[I7] then
              L[I7]()
            end
            local i7
            i7, D7 = _G.__CrystalWalkDescendantsBatched, i:rQ(D7 + 32253084)
            L[I7] = i7(I7, c7, function()
              return I7.Parent ~= nil
            end)
          end
        end
      end
      function _G.__CrystalAddUnifiedPanelShade(L, i7, I7)
        local D7 = L and (L:FindFirstChild("UnifiedBackgroundShade"))
        if D7 then
          D7:Destroy()
        end
        D7 = L and (L:FindFirstChild("UnifiedPanelWhiteOutline"))
        if D7 then
          D7:Destroy()
        end
        D7 = L and (L:FindFirstChild("UnifiedPanelWhiteGlow"))
        if D7 then
          D7:Destroy()
        end
        D7 = Instance.new("Frame")
        D7.Name = "UnifiedBackgroundShade"
        D7.Size = UDim2.fromScale(1, 1)
        D7.Position = UDim2.fromScale(0, 0)
        D7.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        D7.BackgroundTransparency = 0.68
        D7.BorderSizePixel = 0
        D7.Active = false
        D7.ZIndex = I7 or 1
        D7.Parent = L
        Instance.new("UICorner", D7).CornerRadius = UDim.new(0, i7 or 16)
        I7 = Instance.new("UIGradient", D7)
        I7.Rotation = 90
        I7.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.28), NumberSequenceKeypoint.new(0.55, 0.42), NumberSequenceKeypoint.new(1, 0.56)})
        I7 = Instance.new("UIStroke")
        I7.Name = "UnifiedPanelWhiteOutline"
        I7.Color = Color3.fromRGB(255, 255, 255)
        I7.Thickness = 1.5
        I7.Transparency = 0.28
        I7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        I7.LineJoinMode = Enum.LineJoinMode.Round
        I7.Parent = L
        i7 = Instance.new("UIGradient", I7)
        i7.Rotation = 90
        i7.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(165, 165, 165))})
        i7 = Instance.new("UIStroke")
        i7.Name = "UnifiedPanelWhiteGlow"
        i7.Color = Color3.fromRGB(255, 255, 255)
        i7.Thickness = 4.5
        i7.Transparency = 0.72
        i7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        i7.LineJoinMode = Enum.LineJoinMode.Round
        i7.Parent = L
        L = Instance.new("UIGradient", i7)
        L.Rotation = 90
        L.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.08), NumberSequenceKeypoint.new(0.55, 0.22), NumberSequenceKeypoint.new(1, 0.38)})
        return D7
      end
      local L = {[Enum.UserInputType.Gamepad1] = true, [Enum.UserInputType.Gamepad2] = true, [Enum.UserInputType.Gamepad3] = true, [Enum.UserInputType.Gamepad4] = true, [Enum.UserInputType.Gamepad5] = true, [Enum.UserInputType.Gamepad6] = true, [Enum.UserInputType.Gamepad7] = true, [Enum.UserInputType.Gamepad8] = true}
      local function i7(I7)
        return ((I7 and I7.KeyCode) and (I7.KeyCode ~= Enum.KeyCode.Unknown)) and ((I7.UserInputType == Enum.UserInputType.Keyboard) or L[I7.UserInputType])
      end
      local function I7(D7)
        return (D7 and (D7.UserInputType == Enum.UserInputType.Keyboard)) and (D7.KeyCode == Enum.KeyCode.RightControl)
      end
      local D7, c7 = {}, {MB3 = "Mouse3"}
      pcall(function()
        D7[Enum.UserInputType.MouseButton3] = "MB3"
      end)
      local function s7(y7)
        return y7 and (D7[y7.UserInputType] ~= nil)
      end
      local function y7(o7)
        return D7[o7.UserInputType]
      end
      local function D7(o7)
        if not o7 then
          return "-"
        end
        if type(o7) == "string" then
          return c7[o7] or o7
        end
        return tostring(o7):match("KeyCode%.(.+)") or tostring(o7)
      end
      local o7 = {["1"] = {displayName = "1", hats = "1744060292,439945661,1125510,1029025", hair = "", headless = true, korblox = "Right", accessories = {1744060292, 439945661, 1125510, 1029025, 11748356, 8465506143, 11444217173}, clothing = {7424637509, 7689651773}}, ["2"] = {displayName = "2", hats = "74891470", hair = "16630147,6346833550,6594911228,6594919952,6823338112,7097747842", headless = true, korblox = "Right", accessories = {74891470, 16630147, 6346833550, 6594911228, 6594919952, 6823338112, 7097747842}, clothing = {18423061209, 18423154566}}, ["3"] = {displayName = "3", hats = "215718515,439945661", hair = "7183785281", headless = true, korblox = "Right", accessories = {215718515, 439945661, 7183785281}, clothing = {15998365201, 7689651773}}, ["4"] = {displayName = "4", hats = "10159600649,439946249,17798262442,92482095662016", hair = "139101716417676", headless = true, korblox = "Right", accessories = {10159600649, 439946249, 17798262442, 92482095662016, 139101716417676, 12490213797}, clothing = {18766106994, 13925390578}}, ["5"] = {displayName = "5", hats = "553970961,1744060292", hair = "93268856876777", headless = true, korblox = "Right", accessories = {553970961, 1744060292, 93268856876777}, clothing = {9478068776, 6348682339}}, ["6"] = {hats = "74891470,215718515,439945661,1016143686,1744060292,10159600649,89012651581593,88365652378427", hair = "126447390530523", headless = true, korblox = "Right", accessories = {74891470, 215718515, 439945661, 1016143686, 1744060292, 10159600649, 89012651581593, 126447390530523}, clothing = {88032876921227, 108259950755140}, displayName = "6"}, ["7"] = {hats = "", hair = "111149505826763", headless = false, korblox = "Off", accessories = {111149505826763}, clothing = {9733132546, 101481154733615}, displayName = "7"}, ["8"] = {hats = "", hair = "111149505826763", headless = false, korblox = "Off", accessories = {111149505826763}, clothing = {10796276786, 101481154733615}, displayName = "8"}, ["9"] = {hats = "", hair = "111149505826763", headless = false, korblox = "Off", accessories = {111149505826763}, clothing = {8844377623, 101481154733615}, displayName = "9"}, ["10"] = {hats = "", hair = "111149505826763", headless = false, korblox = "Off", accessories = {111149505826763}, clothing = {16107371158, 101481154733615}, displayName = "10"}, ["11"] = {hats = "", hair = "111149505826763", headless = false, korblox = "Off", accessories = {111149505826763}, clothing = {15970848598, 101481154733615}, displayName = "11"}, ["12"] = {hats = "", hair = "111149505826763", headless = false, korblox = "Off", accessories = {111149505826763}, clothing = {8844377623, 101481154733615}, displayName = "12"}, ["13"] = {hats = "17274218093", hair = "", headless = false, korblox = "Off", accessories = {111553288808103, 17274218093, 17387240647}, clothing = {130666125397672, 91321960147976}, displayName = "13"}, ["14"] = {hats = "127788745429250", hair = "", headless = false, korblox = "Off", accessories = {127788745429250, 143803235928952}, clothing = {77038549270215, 16717004839}, displayName = "14"}, ["15"] = {hats = "8261840689", hair = "", headless = true, korblox = "Right", accessories = {8261840689}, clothing = {7884186381, 13063157758}, displayName = "15"}, ["16"] = {hats = "91950080535908", hair = "96954292222783", headless = true, korblox = "Right", accessories = {91950080535908, 96954292222783, 17309352545, 132404403424262}, clothing = {9683332649, 13063157758}, displayName = "16"}, ["17"] = {hats = "10997283529", hair = "", headless = true, korblox = "Off", accessories = {10997283529, 125085889448130, 115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, clothing = {}, displayName = "17"}, ["18"] = {hats = "125157548394108", hair = "", headless = false, korblox = "Off", accessories = {125157548394108, 123231522991173, 74827642361405, 115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, clothing = {}, displayName = "18"}, ["19"] = {hats = "136644276218918", hair = "", headless = false, korblox = "Off", accessories = {136644276218918, 132022106987543, 131740907052260, 115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, clothing = {}, displayName = "19"}, ["20"] = {hats = "119331031817124", hair = "", headless = true, korblox = "Off", accessories = {119331031817124, 84952305140948, 115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, clothing = {}, displayName = "20"}, ["21"] = {hats = "18902416696", hair = "", headless = true, korblox = "Off", accessories = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702, 115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, clothing = {}, displayName = "21"}, ["22"] = {hats = "13935333090", hair = "", headless = false, korblox = "Off", accessories = {13935333090, 16110951997, 10632503818}, clothing = {}, displayName = "22"}, ["23"] = {hats = "74891470", hair = "", headless = true, korblox = "Off", accessories = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424}, clothing = {}, displayName = "23"}, ["24"] = {hats = "76479271580913", hair = "", headless = true, korblox = "Right", accessories = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718}, clothing = {}, displayName = "24"}, ["25"] = {hats = "", hair = "", headless = false, korblox = "Both", accessories = {70414871864071, 14863917259, 133498027006138, 82277826177074}, clothing = {}, displayName = "25"}, ["26"] = {displayName = "Halloween 1", hats = "", hair = "137816489423089", head = 92670829478194, headless = false, korblox = "Off", accessories = {137816489423089}, clothing = {11411687887, 18509017923}}}
      _G._KawatanSkinSets = o7
      _G._KawatanSkinSetOrder = {}
      for O7 = 1, 26, 1 do
        table.insert(_G._KawatanSkinSetOrder, tostring(O7))
      end
      _G._KawatanSkinColor = _G._KawatanSkinColor or "1"
      do
        local O7 = {[11] = "Shirt", [12] = "Pants", [2] = "GraphicTShirt", [8] = "HatAccessory", [41] = "HairAccessory", [42] = "FaceAccessory", [43] = "NeckAccessory", [44] = "ShouldersAccessory", [45] = "FrontAccessory", [46] = "BackAccessory", [47] = "WaistAccessory", [64] = "TShirtAccessory", [65] = "ShirtAccessory", [66] = "PantsAccessory", [67] = "JacketAccessory", [68] = "SweaterAccessory", [69] = "ShortsAccessory", [70] = "LeftShoeAccessory", [71] = "RightShoeAccessory", [72] = "DressSkirtAccessory"}
        local function F7(M7, b7)
          local w7 = i[48](229123816, 0)
          local G7
          G7, w7 = pcall, i:rQ(w7 + 215628618)
          local w7, T7 = G7(function()
            local h7, u7 = game:GetService("MarketplaceService"), Enum.InfoType.Asset
            return h7:GetProductInfo(b7, u7)
          end)
          if not w7 or not T7 then
            return
          end
          local h7 = O7[tonumber(T7.AssetTypeId)]
          if not h7 then
            return
          end
          G7 = ((h7 == "Shirt") or (h7 == "Pants")) or (h7 == "GraphicTShirt")
          if G7 then
            local O7 = i[48](94085640, 0)
            w7 = O7
            T7 = nil
            T7, O7 = pcall, i:rQ((i:HQ(417410582, w7) + i:HQ(417410582, 32579472)) + (i:HQ(3460146132, (i[79](w7, 32579472))) + i:HQ(417410583, (i[48](w7, 32579472)))))
            T7(function()
              M7[h7] = b7
            end)
          else
            local O7 = ""
            pcall(function()
              O7 = tostring(M7[h7] or "")
            end)
            pcall(function()
              M7[h7] = ((O7 == "") and tostring(b7)) or (O7 .. ("," .. tostring(b7)))
            end)
          end
        end
        local function O7(M7)
          local b7, w7 = i[48](66315092, 0), tostring
          local G7 = b7
          b7 = i:rQ((i:HQ(410826144, G7) + i:HQ(410826144, 308813853)) + (i:HQ(3473315008, (i[79](G7, 308813853))) + i:HQ(410826145, (i[48](G7, 308813853)))))
          G7 = w7(M7)
          b7 = i[48](b7, 80526141)
          local M7 = o7[G7]
          if not M7 then
            return nil
          end
          local b7
          pcall(function()
            local G7 = F.Character and F.Character:FindFirstChildOfClass("Humanoid")
            if G7 then
              b7 = G7:GetAppliedDescription()
            end
          end)
          local G7, T7 = (b7 and b7:Clone()) or Instance.new("HumanoidDescription"), {"HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory", "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory", "SweaterAccessory", "ShortsAccessory", "TShirtAccessory", "DressSkirtAccessory"}
          for b7, b7 in ipairs(T7) do
            local T7 = i[48](229150711, 0)
            w7 = nil
            w7, T7 = pcall, i[48](T7, 535319071)
            w7(function()
              G7[b7] = ""
            end)
          end
          pcall(function()
            G7.Shirt = 0
            G7.Pants = 0
            G7.GraphicTShirt = 0
          end)
          pcall(function()
            G7.HatAccessory = M7.hats or ""
            G7.HairAccessory = M7.hair or ""
            if M7.head then
              G7.Head = M7.head
            end
          end)
          for b7, b7 in ipairs(M7.accessories or {}) do
            F7(G7, b7)
          end
          for b7, b7 in ipairs(M7.clothing or {}) do
            F7(G7, b7)
          end
          return G7
        end
        _G._KawatanBuildSetDescription = O7
      end
      U = {["Inf Jump"] = false, ["Anti Bat"] = false, ["TP Down"] = false, ["Auto TP Down"] = false, ["Mirror TP Down"] = false, ["Anti Ragdoll"] = false, ["Ragdoll Counter"] = false, ["Medusa Counter"] = false, Aimbot = false, Autoplay = false, Drop = false, ["auto steal"] = false, ["Steal Bar"] = true, ["ESP Players"] = false, ["Player Tracers"] = false, ["Show Buttons"] = false, ["Lock Buttons"] = false, ["Hide Status Bar"] = false, ["Show FPS"] = false, ["FPS Boost"] = false, ["Anti Lag"] = false, Optimizer = true, Lagger = false, ["Speed Boost"] = false, ["Toggle UI"] = true, ["Auto Steal Speed"] = false, ["Auto Carry Speed"] = false, ["Carry Speed"] = false, Unwalk = false, ["Harder Hit Anim"] = false, Animaciones = false, ["Custom FOV"] = false, ["Stretchz Res"] = false, ["Sky Changer"] = false, ["Violette Custom Skins"] = false, ["Headless Visual"] = false, ["Korblox Visual"] = false, ["Halloween Mode"] = false, ["Anti Die"] = false}
      for O7, F7 in pairs(U) do
        h[O7] = F7
      end
      local O7, F7
      local M7 = 0
      local function b7(w7)
        local G7 = not w7 or (w7 == O7)
        if G7 then
          return
        end
        pcall(writefile, "CrystalHub_UI_Config.txt", w7)
        O7 = w7
      end
      local function w7()
        local G7 = i[48](124161703, 0)
        local T7 = G7
        local h7 = {}
        for u7, U7 in pairs(h) do
          if not u[u7] then
            table.insert(h7, "T:" .. (u7 .. ("=" .. tostring(U7))))
          end
        end
        for u7, U7 in pairs(p) do
          table.insert(h7, "S:" .. (u7 .. ("=" .. tostring(U7))))
        end
        for u7, U7 in pairs(W) do
          table.insert(h7, "B:" .. (u7 .. ("=" .. tostring(U7))))
        end
        for u7, U7 in pairs(n) do
          table.insert(h7, "V:" .. (u7 .. ("=" .. tostring(U7))))
        end
        for u7, U7 in pairs(j) do
          table.insert(h7, "A:" .. (u7 .. ("=" .. tostring(U7))))
        end
        for u7, u7 in ipairs(Q) do
          table.insert(h7, "C:" .. (u7.name .. ("=" .. (u7.boost .. ("," .. u7.steal)))))
        end
        if _G.__CrystalHub_Anims then
          for u7, U7 in pairs(_G.__CrystalHub_Anims) do
            table.insert(h7, "N:" .. (u7 .. ("=" .. U7)))
          end
        end
        table.insert(h7, "M:selectedMode=" .. J)
        table.insert(h7, "M:optimizerMode=" .. tostring(_G.__optimizerMode or "Ultra"))
        table.insert(h7, "M:autoplayMode=" .. (_G.__autoplayMode or "Full"))
        table.insert(h7, "M:skyIndex=" .. tostring((_G.__skyGetIndex and _G.__skyGetIndex()) or 1))
        table.insert(h7, "M:skyMode=" .. tostring(_G.__CrystalSkyChangerMode or "blue"))
        table.insert(h7, "M:violetteSkinMode=" .. tostring(q))
        table.insert(h7, "M:katanaIndex=" .. tostring((_G.__katanaGetIndex and _G.__katanaGetIndex()) or 1))
        table.insert(h7, "M:autoStealMode=" .. (((r == "v2") and "v2") or "v1"))
        table.insert(h7, "M:carrySpeedMode=v2")
        table.insert(h7, "M:dropMode=" .. (((_G.__CrystalDropMode == "Jump Drop") and "Jump Drop") or "Stand Drop"))
        table.insert(h7, "M:infJumpMode=" .. (_G.__CrystalInfJumpMode or "hold"))
        table.insert(h7, "M:panelVisible=" .. tostring(_G.__CrystalPanelVisible ~= false))
        table.insert(h7, "M:tabPosition=" .. tostring(_G.__CrystalTabPosition or "Down"))
        local u7, U7, p7, W7 = table.insert, tostring, _G.__batVersion
        W7, G7 = "M:batVersion=" .. U7(p7 or 1), i:rQ(T7 + 375565518)
        u7(h7, W7)
        table.insert(h7, "M:aimbotMode=" .. (((_G.__aimbotMode == "bypass") and "bypass") or "normal"))
        W7, U7, u7 = table.insert, tostring, ((_G.__aimbotMode == "bypass") and 2) or 1
        W7(h7, "M:aimbotVersion=" .. U7(u7))
        table.insert(h7, "M:buttonsSize=" .. tostring(_G.__CrystalButtonsSize or 1))
        table.insert(h7, "M:tpBatV2Distance=" .. tostring(math.clamp(tonumber(_G.__tpBatV2Distance) or 8, 0, 100)))
        if _G.__CrystalAnimationPreset then
          table.insert(h7, "M:animationPreset=" .. tostring(_G.__CrystalAnimationPreset))
        end
        table.insert(h7, "M:guiTheme=" .. tostring(_G.__CrystalGuiTheme or "GUI 1"))
        table.insert(h7, "M:customFont=" .. tostring(_G.CrystalFontChoice or "Default"))
        table.insert(h7, "M:themePrimary=" .. (_G.__CrystalThemePrimary or "BLACK"))
        table.insert(h7, "M:themeSecondary=" .. (_G.__CrystalThemeSecondary or "BLUE"))
        table.insert(h7, "M:autoGrabExpanded=" .. tostring(_G._CrystalHub_UI_AutoGrabExpanded ~= false))
        table.insert(h7, "M:keybindResetVersion=1")
        for n7, Q7 in pairs(g) do
          if Q7 then
            U7 = if type(Q7) == "string" then Q7 else tostring(Q7):match("KeyCode%.(.+)") or tostring(Q7)
            table.insert(h7, "K:" .. (n7 .. ("=" .. U7)))
          end
        end
        if _G._CrystalHub_UI_MenuPos then
          U7 = _G._CrystalHub_UI_MenuPos
          if U7.x and U7.y then
            table.insert(h7, "P:menuPos=" .. (math.floor(U7.x) .. ("," .. math.floor(U7.y))))
          end
        end
        T7, W7, U7, p7 = table.insert, tostring, _, i:rQ(u7)
        G7 = i:rQ((i:HQ(707134206, 4294967295) + G7) + (i:HQ(3521140418, p7) + i:HQ(3521140418, (i[100](p7)))))
        T7(h7, "M:introMusicIndex=" .. W7(U7))
        table.insert(h7, "M:bgIndex=" .. tostring(_G._CrystalHub_UI_BgIndex or 1))
        if _G.__toggleBtn then
          table.insert(h7, "P:toggleBtn=" .. (math.floor(_G.__toggleBtn.Position.X.Offset) .. ("," .. math.floor(_G.__toggleBtn.Position.Y.Offset))))
        end
        for n7, Q7 in pairs(E) do
          if Q7.x and Q7.y then
            table.insert(h7, "P:mobileBtn_" .. (n7 .. ("=" .. (math.floor(Q7.x) .. ("," .. (math.floor(Q7.y) .. (if Q7.xs and Q7.ys then ":" .. (Q7.xs .. (":" .. Q7.ys)) else "")))))))
          end
        end
        for n7, Q7 in pairs(N) do
          if Q7.x and Q7.y then
            table.insert(h7, "P:quickBtn_" .. (n7 .. ("=" .. (math.floor(Q7.x) .. ("," .. math.floor(Q7.y))))))
          end
        end
        if _G._CrystalHub_UI_SpeedFramePos then
          W7 = _G._CrystalHub_UI_SpeedFramePos
          if W7.x and W7.y then
            table.insert(h7, "P:speedFrame=" .. (math.floor(W7.x) .. ("," .. math.floor(W7.y))))
          end
        end
        if _G._CrystalHub_EnemyWidget_SaveHook then
          pcall(_G._CrystalHub_EnemyWidget_SaveHook)
        end
        if _G._CrystalHub_UI_EnemyWidgetPos then
          T7 = _G._CrystalHub_UI_EnemyWidgetPos
          if T7.x and T7.y then
            p7, W7, u7, U7 = table.insert, math.floor
            u7, U7, G7 = W7(T7.x), math, i:rQ(G7 - 428591228)
            p7(h7, "P:enemyWidget=" .. (u7 .. ("," .. U7.floor(T7.y))))
            G7 = i:rQ(G7 + 428591228)
          else
          end
        else
        end
        if _G._CrystalHub_UI_StatusBarPos then
          u7 = _G._CrystalHub_UI_StatusBarPos
          if u7.x and u7.y then
            table.insert(h7, "P:statusBar=" .. (math.floor(u7.x) .. ("," .. math.floor(u7.y))))
          end
        end
        if _G._CrystalHub_UI_AutoGrabBarPos then
          p7 = _G._CrystalHub_UI_AutoGrabBarPos
          if p7.x and p7.y then
            table.insert(h7, "P:autoGrabBar=" .. (math.floor(p7.x) .. ("," .. math.floor(p7.y))))
          end
        end
        if _G._CrystalHub_UI_AutoGrabBarSize then
          table.insert(h7, "P:autoGrabBarSize=" .. tostring(_G._CrystalHub_UI_AutoGrabBarSize))
        end
        if _G._CrystalHub_UI_ModernMiniPos then
          W7 = _G._CrystalHub_UI_ModernMiniPos
          if W7.x and W7.y then
            table.insert(h7, "P:modernMini=" .. (math.floor(W7.x) .. ("," .. math.floor(W7.y))))
          end
        end
        local G7 = table.concat(h7, "\n")
        p7 = (G7 == O7) or (G7 == F7)
        if p7 then
          return
        end
        F7 = G7
        _G._CrystalHub_UI_Data = G7
        M7 += 1
        local O7 = M7
        u7 = task.delay
        local function T7()
          local h7 = (O7 ~= M7) or (F7 ~= G7)
          if h7 then
            return
          end
          F7 = nil
          b7(G7)
        end
        u7(0.2, T7)
      end
      _G.__CrystalTrackStopper(function()
        local O7 = F7
        if O7 then
          b7(F7)
          F7 = nil
        end
      end)
      local function O7(F7)
        local M7, b7 = {"Aimbot", "TP Bat"}, false
        for G7, T7 in ipairs(M7) do
          if ((T7 ~= F7) and (T7 ~= "TP Bat")) and h[T7] then
            h[T7] = false
            G7 = V[T7]
            if G7 then
              pcall(G7, false)
            end
            if l[T7] then
              pcall(l[T7], false)
            end
            b7 = true
          else
          end
        end
        if b7 then
          w7()
        end
      end
      function _G.__deactivateBatExclusive(F7)
        local M7, b7 = {"Aimbot", "TP Bat"}, false
        for G7, T7 in ipairs(M7) do
          if ((T7 ~= F7) and (T7 ~= "TP Bat")) and h[T7] then
            h[T7] = false
            G7 = V[T7]
            if G7 then
              pcall(G7, false)
            end
            if l[T7] then
              pcall(l[T7], false)
            end
            b7 = true
          else
          end
        end
        if b7 then
          w7()
        end
      end
      local function F7()
        local M7, b7 = pcall(readfile, "CrystalHub_UI_Config.txt")
        local G7 = if (M7 and b7) and (#b7 > 0) then b7 else if _G._CrystalHub_UI_Data and (#_G._CrystalHub_UI_Data > 0) then _G._CrystalHub_UI_Data else nil
        if not G7 then
          return
        end
        b7 = false
        for T7 in G7:gmatch("[^\n]+") do
          if T7:match("^M:keybindResetVersion=%s*1%s*$") then
            b7 = true
            break
          end
        end
        for T7 in G7:gmatch("[^\n]+") do
          local G7, h7 = T7:sub(1, 2), T7:sub(3)
          local u7, U7 = h7:match("([^=]+)=(.+)")
          M7 = u7 and U7
          if M7 then
            u7, U7 = u7:match("^%s*(.-)%s*$"), U7:match("^%s*(.-)%s*$")
            h7 = ((G7 == "T:") and (h[u7] ~= nil)) and not u[u7]
            if h7 then
              h[u7] = U7 == "true"
            else
              T7 = G7 == "S:"
              if T7 then
                p[u7] = U7 == "true"
              else
                local u = G7 == "B:"
                if u then
                  W[u7] = U7 == "true"
                else
                  local u = (G7 == "V:") and (n[u7] ~= nil)
                  if u then
                    local u = tonumber(U7)
                    if u then
                      n[u7] = u
                      local p = u7 == "NormalBoost"
                      if p then
                        z = u
                      end
                      p = u7 == "NormalSteal"
                      if p then
                        K = u
                      end
                      p = u7 == "LaggerBoost"
                      if p then
                        k = u
                      end
                    end
                  else
                    local u = G7 == "N:"
                    if u then
                      _G.__savedAnimations = _G.__savedAnimations or {}
                      _G.__savedAnimations[u7] = U7
                    else
                      local u = G7 == "M:"
                      if u then
                        local u = u7 == "introMusicIndex"
                        if u then
                          _, U7 = tonumber(U7) or 2, U7
                        else
                          local u = u7 == "bgIndex"
                          if u then
                            _G._CrystalHub_UI_BgIndex = tonumber(U7)
                          else
                            local u = u7 == "selectedMode"
                            if u then
                              local u = ((U7 == "Normal") or (U7 == "Lagger")) or (U7 == "Desync")
                              if u then
                                J = U7
                              end
                            else
                              local u = u7 == "autoplayMode"
                              if u then
                                if (U7 == "Full") or (U7 == "Semi") then
                                  _G.__autoplayMode = U7
                                end
                              else
                                local u = u7 == "skyIndex"
                                if u then
                                  _G.__savedSkyIndex = tonumber(U7)
                                else
                                  local u = u7 == "skyMode"
                                  if u then
                                    if ((U7 == "day") or (U7 == "blue")) or (U7 == "night") then
                                      _G.__CrystalSkyChangerMode = U7
                                    end
                                  else
                                    local u = u7 == "katanaIndex"
                                    if u then
                                      _G.__savedKatanaIndex = tonumber(U7)
                                    else
                                      local u = u7 == "autoStealMode"
                                      if u then
                                        if U7 == "v3" then
                                          U7 = "v1"
                                        else
                                        end
                                        local u = (U7 == "v1") or (U7 == "v2")
                                        if u then
                                          r = U7
                                        end
                                      else
                                        local u = u7 == "carrySpeedMode"
                                        if u then
                                          X = "v2"
                                        else
                                          local u = u7 == "optimizerMode"
                                          if u then
                                            if (U7 == "Normal") or (U7 == "Ultra") then
                                              _G.__optimizerMode = U7
                                            end
                                          else
                                            local u = u7 == "dropMode"
                                            if u then
                                              _G.__CrystalDropMode = ((U7 == "Jump Drop") and "Jump Drop") or "Stand Drop"
                                            else
                                              local u = u7 == "infJumpMode"
                                              if u then
                                                if (U7 == "hold") or (U7 == "manual") then
                                                  _G.__CrystalInfJumpMode = U7
                                                end
                                              else
                                                local u = u7 == "autoGrabExpanded"
                                                if u then
                                                  _G._CrystalHub_UI_AutoGrabExpanded = U7 == "true"
                                                else
                                                  local u = u7 == "panelVisible"
                                                  if u then
                                                    _G.__CrystalPanelVisible = U7 == "true"
                                                    h["Toggle UI"] = _G.__CrystalPanelVisible
                                                  else
                                                    local u = u7 == "tabPosition"
                                                    if u then
                                                      if (U7 == "Left") or (U7 == "Down") then
                                                        _G.__CrystalTabPosition = U7
                                                      end
                                                    else
                                                      local u = u7 == "themePrimary"
                                                      if u then
                                                        if (U7 == "BLACK") or (U7 == "WHITE") then
                                                          _G.__CrystalThemePrimary = U7
                                                        end
                                                      else
                                                        local u = u7 == "themeSecondary"
                                                        if u then
                                                          if ((U7 == "BLUE") or (U7 == "RED")) or (U7 == "CONTRAST") then
                                                            _G.__CrystalThemeSecondary = U7
                                                          end
                                                        else
                                                          local u = u7 == "buttonsSize"
                                                          if u then
                                                            local u = tonumber(U7)
                                                            if (u and (u == u)) and (math.abs(u) < math.huge) then
                                                              _G.__CrystalButtonsSize = math.clamp(u, 0.5, 2)
                                                            end
                                                          else
                                                            local u = u7 == "violetteSkinMode"
                                                            if u then
                                                              q = (o7[U7] and U7) or "1"
                                                            elseif u7 == "batVersion" then
                                                              _G.__batVersion = ((tonumber(U7) == 2) and 2) or 1
                                                              if _G.__batVersionPill then
                                                                _G.__batVersionPill.Text = "V" .. tostring(_G.__batVersion or 1)
                                                              end
                                                            elseif u7 == "aimbotMode" then
                                                              _G.__aimbotMode = (((U7 == "bypass") or (U7 == "old")) and "bypass") or "normal"
                                                              _G.__aimbotVersion = ((_G.__aimbotMode == "bypass") and 2) or 1
                                                            elseif u7 == "aimbotVersion" then
                                                              if not _G.__aimbotMode then
                                                                _G.__aimbotMode = ((tonumber(U7) == 2) and "bypass") or "normal"
                                                              end
                                                              _G.__aimbotVersion = ((tonumber(U7) == 2) and 2) or 1
                                                            elseif u7 == "tpBatV2Distance" then
                                                              _G.__tpBatV2Distance = math.clamp(tonumber(U7) or 8, 0, 100)
                                                            elseif u7 == "animationPreset" then
                                                              _G.__CrystalAnimationPreset = U7
                                                            elseif u7 == "customFont" then
                                                              _G.CrystalFontChoice = tostring(U7 or "Default")
                                                            elseif u7 == "guiTheme" then
                                                              _G.__CrystalGuiTheme = "GUI 1"
                                                            end
                                                          end
                                                        end
                                                      end
                                                    end
                                                  end
                                                end
                                              end
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      else
                        if (G7 == "A:") and (j[u7] ~= nil) then
                          local u = tonumber(U7)
                          if u then
                            j[u7] = u
                          end
                        elseif G7 == "C:" then
                          local u, p = U7:match("([^,]+),([^,]+)")
                          if u and p then
                            table.insert(Q, {name = u7, boost = tonumber(u) or 59, steal = tonumber(p) or 29})
                          end
                        elseif (G7 == "K:") and b7 then
                          if c7[U7] then
                            g[u7] = U7
                          else
                            local u = i[48](229215870, 0)
                            local p = u
                            local W = pcall
                            u = i:rQ((i:HQ(1211955827, p) + i:HQ(1211955827, 9258918)) + (i:HQ(1871055642, (i[79](p, 9258918))) + i:HQ(1211955828, (i[48](p, 9258918)))))
                            local function u()
                              return Enum.KeyCode[U7]
                            end
                            local p, _ = W(u)
                            if p then
                              g[u7] = _
                            end
                          end
                        elseif G7 == "P:" then
                          if u7 == "menuPos" then
                            local u, p = U7:match("(-?%d+),(-?%d+)")
                            if u and p then
                              _G._CrystalHub_UI_MenuPos = {x = tonumber(u), y = tonumber(p)}
                            end
                          elseif u7 == "toggleBtn" then
                            local u, p = U7:match("(-?%d+),(-?%d+)")
                            if u and p then
                              _G._CrystalHub_UI_BtnPos = {x = tonumber(u), y = tonumber(p)}
                            end
                          elseif u7 == "speedFrame" then
                            local u, p = U7:match("(-?%d+),(-?%d+)")
                            if u and p then
                              _G._CrystalHub_UI_SpeedFramePos = {x = tonumber(u), y = tonumber(p)}
                            end
                          elseif u7 == "enemyWidget" then
                            local u, p = U7:match("(-?%d+),(-?%d+)")
                            if u and p then
                              _G._CrystalHub_UI_EnemyWidgetPos = {x = tonumber(u), y = tonumber(p)}
                            end
                          elseif u7 == "statusBar" then
                            local u, p = U7:match("(-?%d+),(-?%d+)")
                            if u and p then
                              _G._CrystalHub_UI_StatusBarPos = {x = tonumber(u), y = tonumber(p)}
                            end
                          elseif u7 == "autoGrabBar" then
                            local u, p = U7:match("(-?%d+),(-?%d+)")
                            if u and p then
                              _G._CrystalHub_UI_AutoGrabBarPos = {x = tonumber(u), y = tonumber(p)}
                            end
                          elseif u7 == "autoGrabBarSize" then
                            local u = tonumber(U7)
                            if u then
                              _G._CrystalHub_UI_AutoGrabBarSize = u
                            end
                          elseif u7 == "modernMini" then
                            local u, p = U7:match("(-?%d+),(-?%d+)")
                            if u and p then
                              _G._CrystalHub_UI_ModernMiniPos = {x = tonumber(u), y = tonumber(p)}
                            end
                          else
                            local u = u7:match("^quickBtn_(.+)$")
                            if u then
                              local p, W = U7:match("^(-?%d+),(-?%d+)")
                              if p and W then
                                N[u] = {x = tonumber(p), y = tonumber(W)}
                              end
                            else
                              local u = u7:match("^mobileBtn_(.+)$")
                              if u then
                                local p, W = U7:match("^(-?%d+),(-?%d+)")
                                if p and W then
                                  _G._CrystalHub_UI_MobileBtnPos = _G._CrystalHub_UI_MobileBtnPos or {}
                                  local _, M7, b7 = {x = tonumber(p), y = tonumber(W)}, U7:match(":(-?%d+):(-?%d+)$")
                                  if M7 and b7 then
                                    _.xs = tonumber(M7)
                                    _.ys = tonumber(b7)
                                  end
                                  _G._CrystalHub_UI_MobileBtnPos[u] = _
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          else
          end
        end
      end
      F7()
      w7()
      if type(_G.__CrystalPanelVisible) == "boolean" then
        h["Toggle UI"] = _G.__CrystalPanelVisible
      else
        _G.__CrystalPanelVisible = h["Toggle UI"] ~= false
        h["Toggle UI"] = _G.__CrystalPanelVisible
      end
      U = (r ~= "v1") and (r ~= "v2")
      if U then
        r = "v1"
      else
      end
      X = "v2"
      _G.__batVersion = ((tonumber(_G.__batVersion) == 2) and 2) or 1
      _G.__tpBatV2Distance = math.clamp(tonumber(_G.__tpBatV2Distance) or 8, 0, 100)
      C = J == "Lagger"
      e = h["Carry Speed"]
      h["TP Bat"] = false
      h["Steal Bar"] = true
      h.Korblox = false
      pcall(function()
        local u = F.Character
        if not u then
          return
        end
        for p, p in ipairs(u:GetChildren()) do
          if p.Name == "Korblox_RightLeg" then
            p:Destroy()
          end
        end
        local p = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}
        for W, _ in ipairs(p) do
          W = u:FindFirstChild(_)
          if W and (W:IsA("BasePart")) then
            W.Transparency = 0
            W.CanCollide = true
          end
        end
      end)
      h.Autoplay = false
      h.Lagger = false
      E = _G._CrystalHub_UI_MobileBtnPos or {}
      _G.__CrystalModernGuiActive = true
      local u = game:GetService("CoreGui")
      U = F.PlayerGui:FindFirstChild("CRYSTAL_Panel") or u:FindFirstChild("CRYSTAL_Panel")
      if U then
        U:Destroy()
      end
      local p = Instance.new("ScreenGui")
      p.Name = "EclipseHub"
      p.Enabled = false
      p.ResetOnSpawn = false
      p.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
      p.DisplayOrder = 9999999
      p.IgnoreGuiInset = true
      pcall(function()
        p.Parent = u
      end)
      if not p.Parent then
        p.Parent = F.PlayerGui
      end
      local u = workspace.CurrentCamera.ViewportSize
      T, F7 = {sectionPad = (M and 4) or 6, sectionGap = (M and 4) or 6, sectionHeaderH = (M and 16) or 20, toggleH = (M and 44) or 62, compactRowH = (M and 30) or 36, compactCardH = (M and 28) or 32, toggleTextSize = (M and 9) or 10, bindW = (M and 34) or 40, bindH = (M and 16) or 20}, (M and 8) or 9
      T.bindTextSize = F7
      GUI_METRICS = T
      local W, _, E = (M and math.clamp(math.floor(u.X * 0.42), 165, 205)) or math.min(340, math.floor(u.X * 0.52)), (M and math.clamp(math.floor(u.Y * 0.52), 200, 310)) or math.min(520, math.floor(u.Y * 0.8)), Instance.new("Frame")
      E.Name = "Panel"
      E.Active = true
      E.Size = UDim2.new(0, W, 0, _)
      G = _G._CrystalHub_UI_MenuPos
      if G then
        U, T = B(E, 0, G.x, 0, G.y)
        E.Position = UDim2.new(0, U, 0, T)
      else
        E.Position = UDim2.new(1, -W - 20, 0.5, -_ / 2)
      end
      E.BackgroundTransparency = 1
      E.BorderSizePixel = 0
      E.Visible = false
      E.Parent = p
      U = Instance.new("Frame")
      U.Name = "LegacyHeaderStub"
      U.BackgroundTransparency = 1
      U.Visible = false
      U.Parent = E
      m = Instance.new("TextLabel")
      m.BackgroundTransparency = 1
      m.Visible = false
      m.Parent = U
      P = Instance.new("TextLabel")
      P.BackgroundTransparency = 1
      P.Visible = false
      P.Parent = U
      local M7 = Instance.new("Frame")
      M7.Name = "LegacyContentStub"
      M7.BackgroundTransparency = 1
      M7.Visible = false
      M7.Parent = E
      local b7 = {"rbxassetid://124223551386461", "rbxassetid://135684639881388", "rbxassetid://84591930675801"}
      local G7 = tonumber(_G._CrystalHub_UI_BgIndex) or 1
      w = ((type(G7) ~= "number") or (G7 < 1)) or (G7 > #b7)
      if w then
        G7 = 1
      else
      end
      local T7 = Instance.new("ImageLabel")
      T7.Name = "LegacyBackgroundStub"
      T7.BackgroundTransparency = 1
      T7.Image = b7[G7]
      T7.Visible = false
      T7.Parent = E
      local h7 = Instance.new("TextButton")
      h7.Name = "LegacyBackgroundButtonStub"
      h7.Visible = false
      h7.Parent = E
      do
        local u7, U7
        local p7, W7 = false
        local function n7(Q7)
          local j7 = i[48](61167976, 0)
          local r7
          r7, j7 = pcall, i:rQ(j7 + 39229618)
          r7(function()
            local j7 = i[48](355385585, 0)
            local r7
            r7, j7 = _G, i[48](j7, 402146945)
            local J7 = r7.__CrystalPreserveOptimizerUI
            j7 = i:rQ((i:HQ(1366055314, j7) + i:HQ(1366055314, 60810822)) + (i:HQ(2928911983, (i[79](j7, 60810822))) + i:HQ(2928911981, (i[89](j7, 60810822)))))
            if J7(Q7) then
              return
            end
            r7, J7 = pcall(function()
              local j7 = i[93](game:GetService("Lighting"))
              return Q7:IsDescendantOf(i:gQ(j7))
            end)
            if r7 and J7 then
              return
            end
            if (((((Q7:IsA("Sky") or Q7:IsA("Atmosphere")) or Q7:IsA("ColorCorrectionEffect")) or Q7:IsA("BloomEffect")) or Q7:IsA("BlurEffect")) or Q7:IsA("SunRaysEffect")) or Q7:IsA("DepthOfFieldEffect") then
              return
            end
            r7, J7 = pcall(function()
              local j7 = Q7
              while j7 and (j7 ~= workspace) do
                if (j7.Name == "Headless_Headless") or j7.Name:find("^Korblox_") then
                  return true
                end
                j7 = j7.Parent
              end
              return false
            end)
            if r7 and J7 then
              return
            end
            if Q7:IsA("Accessory") or Q7:IsA("Hat") then
              Q7:Destroy()
            elseif (((Q7:IsA("Shirt") or Q7:IsA("Pants")) or Q7:IsA("ShirtGraphic")) or Q7:IsA("BodyColors")) or Q7:IsA("CharacterMesh") then
              Q7:Destroy()
            elseif Q7:IsA("BasePart") then
              Q7.Material = Enum.Material.Plastic
              Q7.Reflectance = 0
              Q7.CastShadow = false
            elseif Q7:IsA("Decal") or Q7:IsA("Texture") then
              Q7.Transparency = 1
            elseif ((((Q7:IsA("ParticleEmitter") or Q7:IsA("Trail")) or Q7:IsA("Beam")) or Q7:IsA("Fire")) or Q7:IsA("Smoke")) or Q7:IsA("Sparkles") then
              Q7.Enabled = false
            elseif Q7:IsA("AnimationController") or Q7:IsA("Animator") then
              J7 = Q7.Parent
              while J7 and (J7 ~= workspace) do
                if J7:IsA("Model") and I:GetPlayerFromCharacter(J7) then
                  return
                end
                J7 = J7.Parent
              end
              for j7, j7 in ipairs(Q7:GetPlayingAnimationTracks()) do
                local Q7 = i[48](279724227, 0)
                r7 = nil
                r7, Q7 = pcall, i:rQ(Q7 + 13085944)
                r7(function()
                  j7:Stop(0)
                end)
              end
            end
          end)
        end
        local function Q7()
          local j7 = i[48](255821789, 0)
          local r7 = j7
          local J7 = W7
          if J7 then
            W7()
          end
          J7 = _G
          j7 = i[48](r7, 141186211)
          r7 = J7.__CrystalWalkDescendantsBatched
          j7 = i:rQ((i:HQ(391311586, j7) + i:HQ(4294967295, 237131405)) + (i:HQ(2, (i[79](j7, 237131405))) + (i:HQ(3903655709, 4294967295) + i:HQ(391311587, (i[100](j7))))))
          W7 = r7(workspace, n7, function()
            local j7 = p7
            return j7
          end)
        end
        local function j7()
          local r7 = i[48](141002857, 0)
          local J7 = r7
          local q7 = p7
          if q7 then
            return
          end
          r7, p7 = i[48](J7, 398720426), true
          J7 = u7
          r7 = i:rQ((i:HQ(812494907, r7) + i:HQ(812494907, 467752204)) + (i:HQ(3482472390, (i[79](r7, 467752204))) + i:HQ(3482472388, (i[89](r7, 467752204)))))
          if J7 then
            u7:Disconnect()
          end
          u7 = workspace.DescendantAdded:Connect(function(r7)
            local J7 = p7
            if J7 then
              n7(r7)
            end
          end)
          Q7()
          q7 = U7
          if q7 then
            U7:Disconnect()
          end
          U7 = F.CharacterAdded:Connect(function(Q7)
            task.wait(0.5)
            local r7 = p7
            if r7 then
              local r7 = i[48](468998842, 0)
              local J7 = r7
              local q7 = _G.__CrystalWalkDescendantsBatched
              r7 = i:rQ((i:HQ(868137636, J7) + i:HQ(868137636, 182033005)) + (i:HQ(3426829661, (i[79](J7, 182033005))) + i:HQ(3426829659, (i[89](J7, 182033005)))))
              J7 = n7
              r7 = i[48](r7, 440453725)
              q7(Q7, J7, function()
                local n7 = p7
                return n7
              end)
            end
          end)
        end
        local function n7()
          local Q7 = p7
          if not Q7 then
            return
          end
          p7 = false
          Q7 = W7
          if Q7 then
            W7()
            W7 = nil
          end
          Q7 = u7
          if Q7 then
            u7:Disconnect()
            u7 = nil
          end
          Q7 = U7
          if Q7 then
            U7:Disconnect()
            U7 = nil
          end
        end
        _G.__refreshFPSBoost = j7
        _G.__stopFPSBoost = n7
        l["FPS Boost"] = function(u7)
          if u7 then
            j7()
          else
            n7()
          end
        end
      end
      ;(function()
        local u7 = i[48](45415820, 0)
        local U7 = u7
        local p7, W7, n7, Q7, j7 = false, 0, {}, setmetatable, {__mode = "k"}
        local r7, J7, q7 = Q7({}, j7), {}, setmetatable
        u7 = i[48](U7, 323198575)
        u7 = i:rQ((i:HQ(392639624, u7) + i:HQ(392639624, 140564469)) + (i:HQ(3509688048, (i[79](u7, 140564469))) + i:HQ(392639625, (i[48](u7, 140564469)))))
        local u7, U7, Q7 = q7({}, {__mode = "k"}), setmetatable, {__mode = "k"}
        local j7 = U7({}, Q7)
        local U7
        local function Q7(q7, _7, z7)
          local K7 = i[48](41667355, 0)
          local k7
          k7, K7 = pcall, i:rQ((i:HQ(571760649, K7) + i:HQ(571760649, 327395442)) + (i:HQ(3723206648, (i[79](K7, 327395442))) + i:HQ(3723206646, (i[89](K7, 327395442)))))
          k7(function()
            local K7 = q7[_7]
            if K7 == z7 then
              return
            end
            q7[_7] = z7
            local z7 = r7[q7]
            local k7 = not z7
            if k7 then
              z7 = {}
              r7[q7] = z7
            else
            end
            if not z7[_7] then
              z7[_7] = {value = K7}
            end
          end)
        end
        local function q7(_7)
          local z7 = F.Character
          if z7 and ((_7 == z7) or _7:IsDescendantOf(z7)) then
            return true
          end
          z7 = _7
          while z7 and (z7 ~= workspace) do
            if (z7:IsA("LayerCollector") or z7:IsA("GuiObject")) or z7:IsA("GuiBase2d") then
              return true
            end
            local K7 = z7.Name or ""
            if ((((((K7:match("^Crystal") or K7:match("^__Crystal")) or K7:match("^Eclipse")) or K7:match("^ESP_")) or K7:match("^Korblox_")) or (K7 == "Headless_Headless")) or (K7 == "GreenDuelsBB")) or (K7 == "PredictionSphere") then
              return true
            end
            z7 = z7.Parent
          end
          if h["Sky Changer"] and ((_7 == o) or _7:IsDescendantOf(o)) then
            return true
          end
          return false
        end
        local function _7(z7)
          local K7 = i[48](32847579, 0)
          local k7 = K7
          local e7 = u7[z7]
          K7 = i[48](k7, 233756588)
          if e7 then
            return
          end
          k7 = F.Character
          if k7 and (z7:IsDescendantOf(k7)) then
            return
          end
          e7 = nil
          e7, K7 = u7, i:rQ((i:HQ(178017712, K7) + i:HQ(178017712, 128597876)) + (i:HQ(4116949585, (i[79](K7, 128597876))) + i:HQ(4116949583, (i[89](K7, 128597876)))))
          e7[z7] = true
          local K7 = W7
          k7, e7 = pcall(function()
            local X7 = i[48](245900079, 0)
            local C7 = X7
            X7 = i:rQ(C7 + 103074380)
            C7 = z7.AnimationPlayed
            X7 = i:rQ(X7 + 373932588)
            local function X7(a7)
              local A7 = i[48](224206171, 0)
              local g7 = A7
              local R7
              R7, A7 = p7, i[48](g7, 280645000)
              g7 = not R7 or (W7 ~= K7)
              if g7 then
                return
              end
              R7 = nil
              R7, A7 = task.defer, i:rQ((i:HQ(1357810316, A7) + i:HQ(1357810316, 386887754)) + (i:HQ(1579346664, (i[79](A7, 386887754))) + i:HQ(1357810317, (i[48](A7, 386887754)))))
              R7(function()
                local A7 = p7 and (W7 == K7)
                if A7 then
                  local K7 = i[48](30614112, 0)
                  local A7 = K7
                  local g7
                  g7, K7 = pcall, i:rQ((i:HQ(2288219609, A7) + i:HQ(2288219609, 62693095)) + (i:HQ(2006747688, (i[79](A7, 62693095))) + i:HQ(2006747686, (i[89](A7, 62693095)))))
                  g7(function()
                    a7:Stop(0)
                  end)
                end
              end)
            end
            return C7:Connect(X7)
          end)
          if k7 then
            table.insert(n7, e7)
          end
          local function K7()
            local k7, e7 = ipairs, i[93](z7:GetPlayingAnimationTracks())
            for X7, C7 in k7(i:gQ(e7)) do
              X7 = C7.IsPlaying
              if X7 then
                local k7 = j7
                k7[C7] = {animator = z7, time = C7.TimePosition, speed = C7.Speed}
                C7:Stop(0)
              end
            end
          end
          pcall(K7)
        end
        local function z7(K7)
          local k7 = not p7 or q7(K7)
          if k7 then
            return
          end
          if K7:IsA("Terrain") then
            Q7(K7, "Decoration", false)
            Q7(K7, "WaterWaveSize", 0)
            Q7(K7, "WaterWaveSpeed", 0)
            Q7(K7, "WaterReflectance", 0)
            Q7(K7, "WaterTransparency", 1)
          end
          k7 = K7:IsA("BasePart")
          if k7 then
            Q7(K7, "Material", Enum.Material.Plastic)
            Q7(K7, "MaterialVariant", "")
            Q7(K7, "Reflectance", 0)
            Q7(K7, "CastShadow", false)
            if K7:IsA("MeshPart") then
              Q7(K7, "TextureID", "")
              Q7(K7, "RenderFidelity", Enum.RenderFidelity.Performance)
              Q7(K7, "DoubleSided", false)
            elseif K7:IsA("PartOperation") then
              Q7(K7, "RenderFidelity", Enum.RenderFidelity.Performance)
            end
          else
            local q7 = K7:IsA("SpecialMesh")
            if q7 then
              Q7(K7, "TextureId", "")
            else
              local q7 = K7:IsA("SurfaceAppearance")
              if q7 then
                J7[K7] = true
                Q7(K7, "Parent", nil)
              elseif K7:IsA("Decal") or K7:IsA("Texture") then
                Q7(K7, "Transparency", 1)
                Q7(K7, "Texture", "")
              elseif K7:IsA("ParticleEmitter") then
                local q7 = i[48](155770577, 0)
                local k7 = q7
                Q7(K7, "Enabled", false)
                q7 = i[48](k7, 143803157)
                q7 = i:rQ((i:HQ(2142026073, q7) + i:HQ(2142026073, 228807224)) + (i:HQ(10915150, (i[79](q7, 228807224))) + i:HQ(2142026074, (i[48](q7, 228807224)))))
                Q7(K7, "Rate", 0)
                pcall(function()
                  K7:Clear()
                end)
              elseif K7:IsA("Trail") then
                local q7 = i[48](459567295, 0)
                q7 = i:rQ(q7 + 444401952)
                Q7(K7, "Enabled", false)
                pcall(function()
                  K7:Clear()
                end)
              elseif (((((K7:IsA("Beam") or K7:IsA("Fire")) or K7:IsA("Smoke")) or K7:IsA("Sparkles")) or K7:IsA("Light")) or K7:IsA("PostEffect")) or K7:IsA("Clouds") then
                Q7(K7, "Enabled", false)
              elseif K7:IsA("Atmosphere") then
                Q7(K7, "Density", 0)
                Q7(K7, "Haze", 0)
                Q7(K7, "Glare", 0)
              elseif K7:IsA("Sky") then
                local q7 = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp", "SunTextureId", "MoonTextureId"}
                for k7, k7 in ipairs(q7) do
                  Q7(K7, k7, "")
                end
                Q7(K7, "StarCount", 0)
                Q7(K7, "CelestialBodiesShown", false)
              elseif K7:IsA("Shirt") then
                Q7(K7, "ShirtTemplate", "")
              elseif K7:IsA("Pants") then
                Q7(K7, "PantsTemplate", "")
              elseif K7:IsA("ShirtGraphic") then
                Q7(K7, "Graphic", "")
              elseif K7:IsA("Animator") then
                _7(K7)
              end
            end
          end
        end
        local function q7()
          if h["Sky Changer"] then
            return
          end
          Q7(o, "GlobalShadows", false)
          Q7(o, "EnvironmentDiffuseScale", 0)
          Q7(o, "EnvironmentSpecularScale", 0)
          Q7(o, "FogStart", 0)
          Q7(o, "FogEnd", 10000000000)
        end
        local function _7()
          local K7 = p7
          if not K7 then
            return
          end
          p7 = false
          W7 += 1
          K7 = U7
          if K7 then
            U7()
            U7 = nil
          end
          K7 = n7
          for k7, e7 in ipairs(K7) do
            local X7 = i[48](503853119, 0)
            k7 = X7
            local C7
            C7, X7 = pcall, i:rQ(k7 + 37062820)
            C7(function()
              e7:Disconnect()
            end)
          end
          n7 = {}
          K7 = r7
          for k7, e7 in pairs(K7) do
            for X7, C7 in pairs(e7) do
              local e7 = i[48](430544913, 0)
              local a7
              a7, e7 = pcall, i:rQ(e7 + 111883901)
              a7(function()
                k7[X7] = C7.value
              end)
            end
          end
          local k7, e7 = setmetatable, {__mode = "k"}
          r7, J7 = k7({}, e7), {}
          e7, K7 = setmetatable, {__mode = "k"}
          u7 = e7({}, K7)
          K7 = j7
          for u7, r7 in pairs(K7) do
            pcall(function()
              if r7.animator.Parent and not u7.IsPlaying then
                u7:Play(0, 1, r7.speed)
                u7.TimePosition = r7.time
              end
            end)
          end
          e7, k7 = setmetatable, {__mode = "k"}
          j7 = e7({}, k7)
        end
        l["Anti Lag"] = function(u7)
          local j7 = i[48](233381400, 0)
          local r7 = j7
          if not u7 then
            _7()
            return
          end
          u7 = p7
          if u7 then
            return
          end
          p7 = true
          u7 = W7
          j7 = i[48](r7, 155721665)
          j7 = i:rQ((i:HQ(3258408215, j7) + i:HQ(3258408215, 438896176)) + (i:HQ(2073118162, (i[79](j7, 438896176))) + i:HQ(3258408216, (i[48](j7, 438896176)))))
          W7 = u7 + 1
          local j7 = W7
          q7()
          pcall(function()
            Q7(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01)
          end)
          pcall(function()
            Q7(UserSettings():GetService("UserGameSettings"), "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
          end)
          u7 = {workspace, o}
          for Q7, Q7 in ipairs(u7) do
            table.insert(n7, Q7.DescendantAdded:Connect(function(u7)
              local Q7 = i[48](411403325, 0)
              local J7 = Q7
              local K7 = task
              Q7 = i:rQ(J7 + 478269748)
              J7 = K7.defer
              Q7 = i:rQ(Q7 - 375053691)
              J7(function()
                local Q7 = p7 and (W7 == j7)
                if Q7 then
                  pcall(z7, u7)
                end
              end)
            end))
          end
          table.insert(n7, o.Changed:Connect(function(u7)
            local n7 = p7 and (((((u7 == "GlobalShadows") or (u7 == "EnvironmentDiffuseScale")) or (u7 == "EnvironmentSpecularScale")) or (u7 == "FogStart")) or (u7 == "FogEnd"))
            if n7 then
              q7()
            end
          end))
          r7 = U7
          if r7 then
            U7()
          end
          U7 = _G.__CrystalWalkDescendantsBatched({workspace, o}, z7, function()
            local u7 = p7 and (W7 == j7)
            return u7
          end)
        end
        _G.__CrystalTrackStopper(_7)
      end)()
      do
        local u7, U7, p7, W7 = 0, 0, 0, 0
        local function n7()
          local Q7 = i[48](330791653, 0)
          local j7 = Q7
          local r7
          r7, Q7 = pcall, i:rQ((i:HQ(3315738104, j7) + i:HQ(3315738104, 478325548)) + (i:HQ(979229193, (i[79](j7, 478325548))) + i:HQ(979229191, (i[89](j7, 478325548)))))
          local Q7, j7 = r7(function()
            return F:GetNetworkPing() * 1000
          end)
          if Q7 and (type(j7) == "number") then
            return math.floor(j7)
          end
          return 0
        end
        local function Q7()
          if m then
            m.Text = tostring(u7) .. " FPS"
          end
          if P then
            P.Text = tostring(U7) .. " MS"
          end
          if x then
            x.Text = "FPS: " .. tostring(u7)
          end
          if H then
            H.Text = "PING: " .. (tostring(U7) .. "ms")
          end
        end
        p7, W7 = 0, 0
        _G.__CrystalTrackConn(s.RenderStepped:Connect(function(j7)
          W7 += 1
          p7 += j7
          j7 = p7 >= 1
          if j7 then
            u7, W7, p7 = math.floor((W7 / p7) + 0.5), 0, 0
            U7 = n7()
            Q7()
          end
        end))
      end
      do
        local u7
        local U7, p7, W7 = false
        local n7 = _G._CrystalHub_UI_EnemyWidgetPos or {x = 140, y = -340}
        function _G.__CrystalGuiPositionResetters.EnemyWidget()
          U7, n7 = false, {x = 140, y = -340}
          _G._CrystalHub_UI_EnemyWidgetPos = nil
          local Q7 = u7 and u7.Parent
          if Q7 then
            local Q7 = u7
            Q7.Position = UDim2.fromOffset(n7.x, n7.y)
          end
        end
        local Q7, j7, r7 = 0
        local J7, q7, _7 = false
        local z7, K7 = ""
        function _G.__CrystalGetVisualEnemy()
          local k7 = j7 and (j7.Parent == I)
          if k7 then
            local k7 = j7
            return k7
          end
          return nil
        end
        local function k7()
          local e7 = i[48](536051740, 0)
          local X7 = e7
          local C7 = u7 and u7.Parent
          if C7 then
            local a7 = u7
            return a7
          end
          u7 = Instance.new("Frame", p)
          u7.Name = "CrystalEnemyWidget"
          C7 = u7
          C7.Size = UDim2.new(0, 140, 0, 80)
          local a7, A7
          a7, A7, e7 = u7, UDim2.new, i:rQ(X7 + 79321026)
          a7.Position = A7(0, n7.x, 0, n7.y)
          _G.__enemyWidget = u7
          _G.__CrystalRegisterThemeRoot(u7)
          u7.BackgroundTransparency = 0.15
          C7 = u7
          C7.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
          u7.ZIndex = 600
          u7.Visible = false
          Instance.new("UICorner", u7).CornerRadius = UDim.new(0, 8)
          A7 = Instance.new("UIStroke", u7)
          A7.Color = Color3.fromRGB(0, 0, 0)
          A7.Thickness = 1
          X7 = Instance.new("TextLabel", u7)
          X7.Name = "EWTitle"
          X7.Size = UDim2.new(1, -10, 0, 14)
          X7.Position = UDim2.new(0, 8, 0, 4)
          X7.BackgroundTransparency = 1
          X7.Text = "RIVAL"
          X7.Font = Enum.Font.GothamBold
          X7.TextSize = 10
          X7.TextColor3 = Color3.fromRGB(180, 180, 180)
          X7.TextXAlignment = Enum.TextXAlignment.Left
          X7.ZIndex = 601
          X7 = Instance.new("ImageLabel", u7)
          X7.Name = "EWAvatar"
          X7.Size = UDim2.new(0, 44, 0, 44)
          X7.Position = UDim2.new(0, 6, 0, 20)
          X7.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
          X7.BorderSizePixel = 0
          X7.Image = ""
          X7.ZIndex = 601
          Instance.new("UICorner", X7).CornerRadius = UDim.new(0, 6)
          A7 = Instance.new("UIStroke", X7)
          A7.Color = Color3.fromRGB(180, 180, 180)
          A7.Thickness = 1
          A7 = Instance.new("TextLabel", u7)
          A7.Name = "EWName"
          A7.Size = UDim2.new(1, -60, 0, 18)
          A7.Position = UDim2.new(0, 56, 0, 22)
          A7.BackgroundTransparency = 1
          A7.Text = "---"
          A7.Font = Enum.Font.GothamBold
          A7.TextSize = 13
          A7.TextColor3 = Color3.fromRGB(180, 180, 180)
          A7.TextXAlignment = Enum.TextXAlignment.Left
          A7.TextScaled = false
          C7 = Instance.new("TextLabel", u7)
          C7.Name = "EWTimer"
          C7.Size = UDim2.new(1, -60, 0, 20)
          C7.Position = UDim2.new(0, 56, 0, 44)
          C7.BackgroundTransparency = 1
          C7.Text = ""
          C7.Font = Enum.Font.GothamBlack
          C7.TextSize = 16
          C7.TextColor3 = Color3.fromRGB(255, 221, 0)
          C7.TextXAlignment = Enum.TextXAlignment.Left
          C7.ZIndex = 601
          u7.InputBegan:Connect(function(e7)
            local C7 = (e7.UserInputType == Enum.UserInputType.MouseButton1) or (e7.UserInputType == Enum.UserInputType.Touch)
            if C7 then
              local C7 = i[48](366333873, 0)
              local A7 = C7
              U7 = true
              p7 = e7.Position
              C7 = i:rQ(A7 + 381248489)
              W7 = u7.Position
              C7 = i:rQ(C7 - 263151958)
              e7.Changed:Connect(function()
                local C7 = e7.UserInputState == Enum.UserInputState.End
                if C7 then
                  U7 = false
                  local e7 = n7
                  e7.x = u7.Position.X.Offset
                  e7 = n7
                  e7.y = u7.Position.Y.Offset
                  _G._CrystalHub_UI_EnemyWidgetPos = {x = n7.x, y = n7.y}
                  w7()
                end
              end)
            end
          end)
          a7, X7 = _G.__CrystalTrackConn, D.InputChanged
          local function e7(C7)
            local A7 = U7
            if not A7 then
              return
            end
            if (C7.UserInputType ~= Enum.UserInputType.MouseMovement) and (C7.UserInputType ~= Enum.UserInputType.Touch) then
              return
            end
            local U7, A7 = C7.Position - p7, workspace.CurrentCamera.ViewportSize
            local p7, C7, g7 = math.clamp(W7.X.Offset + U7.X, 0, A7.X - u7.AbsoluteSize.X), math.clamp(W7.Y.Offset + U7.Y, 0, A7.Y - u7.AbsoluteSize.Y), u7
            g7.Position = UDim2.new(0, p7, 0, C7)
          end
          a7(X7:Connect(e7))
          a7 = u7
          return a7
        end
        local function U7(p7)
          local W7 = i[48](172406103, 0)
          local e7 = W7
          local X7 = k7()
          W7 = i:rQ(e7 + 375434066)
          local C7 = X7:FindFirstChild("EWAvatar")
          e7 = not C7
          W7 = i:rQ(W7 - 35867590)
          if e7 then
            return
          end
          C7.Image = ""
          task.spawn(function()
            local W7 = i[48](129252867, 0)
            local e7 = W7
            local X7
            X7, W7 = pcall, i:rQ(e7 + 214540897)
            local W7, e7 = X7(function()
              local X7, a7 = Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48
              return I:GetUserThumbnailAsync(p7, X7, a7)
            end)
            if ((W7 and e7) and C7) and C7.Parent then
              C7.Image = e7
            end
          end)
        end
        local function p7(W7)
          local e7 = (W7 and j7) and (W7.UserId == r7)
          if e7 then
            return
          end
          e7 = not W7 and not j7
          if e7 then
            return
          end
          j7, J7, _7 = W7, false, nil
          e7 = k7()
          local X7 = e7:FindFirstChild("EWName")
          q7 = e7:FindFirstChild("EWTimer")
          if W7 then
            r7 = W7.UserId
            if X7 then
              X7.Text = W7.Name
            end
            local C7 = q7
            if C7 then
              q7.Text = ""
              z7 = ""
            end
            U7(W7.UserId)
            e7.Visible = true
            K7 = true
          else
            r7 = nil
            if X7 then
              X7.Text = "---"
            end
            local U7 = q7
            if U7 then
              q7.Text = ""
              z7 = ""
            end
            U7 = e7:FindFirstChild("EWAvatar")
            if U7 then
              U7.Image = ""
            end
            e7.Visible = false
            K7 = false
          end
        end
        local function U7(W7)
          local r7 = Q7 > 0
          if r7 then
            Q7 = math.max(0, Q7 - W7)
          end
          r7 = q7
          if not r7 or not r7.Parent then
            return
          end
          W7 = Q7 > 0
          if W7 then
            local W7 = string.format("%.1fs", Q7)
            local q7 = W7 ~= z7
            if q7 then
              r7.Text = W7
              r7.TextColor3 = Color3.fromRGB(255, 221, 0)
              z7 = W7
            end
          else
            local W7 = z7 ~= ""
            if W7 then
              r7.Text = ""
              z7 = ""
            end
          end
        end
        local W7, r7 = 0, 0
        _G.__CrystalTrackConn(s.Heartbeat:Connect(function(q7)
          r7 += q7 or 0
          q7 = j7 and (r7 >= 0.2)
          if q7 then
            U7(r7)
            r7 = 0
          else
            local U7 = not j7 and (r7 >= 0.2)
            if U7 then
              r7 = 0
            end
          end
          q7 = os.clock()
          local U7 = q7 - W7
          if U7 < 0.25 then
            return
          end
          W7 = q7
          q7 = F.Character
          U7 = q7 and (q7:FindFirstChild("HumanoidRootPart"))
          if not U7 then
            return
          end
          local W7, r7, z7 = U7.Position, math.huge
          for e7, X7 in ipairs(I:GetPlayers()) do
            q7 = (X7 ~= F) and X7.Character
            if q7 then
              e7 = q7:FindFirstChild("HumanoidRootPart")
              if e7 then
                U7 = e7.Position
                local e7, C7, a7 = W7.X - U7.X, W7.Y - U7.Y, W7.Z - U7.Z
                local A7 = ((e7 * e7) + (C7 * C7)) + (a7 * a7)
                if A7 < r7 then
                  r7, z7 = A7, X7
                else
                end
              else
              end
            else
            end
          end
          W7 = j7
          if z7 ~= W7 then
            p7(z7)
          end
          U7 = u7
          q7 = U7 and U7.Parent
          if q7 then
            W7 = z7 ~= nil
            local p7 = W7 ~= K7
            if p7 then
              U7.Visible = W7
              K7 = W7
            end
          end
          q7 = j7
          if q7 then
            W7 = U7 and (U7:FindFirstChild("EWName"))
            if W7 then
              local p7 = j7:GetAttribute("Stealing")
              if p7 == true then
                W7.TextColor3 = Color3.fromRGB(255, 60, 60)
              else
                W7.TextColor3 = Color3.fromRGB(180, 180, 180)
              end
            end
          end
          W7 = j7 and j7.Character
          if W7 then
            q7 = not _7 or not _7.Parent
            if q7 then
              _7 = j7.Character:FindFirstChildOfClass("Humanoid")
            end
            U7 = _7
            if U7 then
              local U7 = _7:GetState()
              local p7 = ((U7 == Enum.HumanoidStateType.Physics) or (U7 == Enum.HumanoidStateType.Ragdoll)) or (U7 == Enum.HumanoidStateType.FallingDown)
              U7 = p7 and not J7
              if U7 then
                Q7 = 3
              else
                local U7 = p7 and (Q7 < 0.5)
                if U7 then
                  Q7 = 0.5
                end
              end
              J7 = p7
            end
          end
        end))
        function _G._CrystalHub_EnemyWidget_SaveHook()
          local U7 = u7 and u7.Parent
          if U7 then
            local U7 = n7
            U7.x = u7.Position.X.Offset
            U7 = n7
            U7.y = u7.Position.Y.Offset
            _G._CrystalHub_UI_EnemyWidgetPos = {x = n7.x, y = n7.y}
          end
        end
        k7()
      end
      local function u7(U7, p7)
        local W7 = Instance.new("Frame")
        W7.Name = ((p7 and tostring(p7)) or "Section") .. "SectionStub"
        W7.BackgroundTransparency = 1
        W7.Visible = false
        W7.Parent = U7
        return W7
      end
      local function U7(p7, W7, n7, Q7)
        local j7 = Instance.new("Frame")
        j7.Name = tostring((n7 or W7) or "Toggle") .. "Stub"
        j7.BackgroundTransparency = 1
        j7.Visible = false
        j7.Parent = p7
        if Q7 then
          n7 = Instance.new("TextButton")
          n7.Text = ""
          n7.Parent = j7
          p7 = Instance.new("Frame")
          p7.BackgroundTransparency = 1
          p7.Parent = j7
          Q7(p7)
        end
        return j7
      end
      local function p7(W7, n7, Q7)
        local j7 = Instance.new("Frame")
        j7.Name = tostring((Q7 or n7) or "Toggle") .. "Stub"
        j7.BackgroundTransparency = 1
        j7.Visible = false
        j7.Parent = W7
        return j7
      end
      local function W7(n7)
        local Q7 = i[48](496169581, 0)
        Q7 = i:rQ(Q7 + 171130197)
        h["Speed Boost"] = true
        if _G.__refreshSpeedBoost then
          pcall(_G.__refreshSpeedBoost)
        end
        local j7 = J == n7
        if j7 then
          local r7 = X == "v2"
          if r7 then
            local r7 = i[48](198916571, 0)
            e = not e
            r7 = i:rQ(r7 + 52272897)
            h["Carry Speed"] = e
            r7 = i:rQ(r7 + 129156443)
            if Y["Carry Speed"] then
              Y["Carry Speed"]()
            end
            pcall(function()
              if _G.__refreshSpeedBillboards then
                _G.__refreshSpeedBillboards()
              end
            end)
            pcall(function()
              if _G.__refreshSpeedBoost then
                _G.__refreshSpeedBoost()
              end
            end)
            w7()
          end
          return
        end
        j7 = _G.__CrystalResetSpeedDirection
        Q7 = i:rQ(Q7 + 5720843)
        if j7 then
          pcall(_G.__CrystalResetSpeedDirection)
        end
        J, C = n7, if n7 == "Lagger" then true else false
        for n7, n7 in ipairs(_speedCardRefs) do
          if n7.updateVisual then
            pcall(n7.updateVisual)
          end
        end
        w7()
        pcall(function()
          if _G.__refreshSpeedBillboards then
            _G.__refreshSpeedBillboards()
          end
        end)
      end
      FeatureToggles = FeatureToggles or {}
      function FeatureToggles.SelectNormalMode()
        W7("Normal")
      end
      function FeatureToggles.SelectLaggerMode()
        W7("Lagger")
      end
      function FeatureToggles.SelectDesyncMode()
        W7("Desync")
      end
      FeatureToggles["Toggle UI"] = function()
        if _G.__setPanelVisible then
          _G.__setPanelVisible(not E.Visible)
        else
          panelVisible = not E.Visible
          E.Visible = panelVisible
          h["Toggle UI"] = panelVisible
        end
        if Y["Toggle UI"] then
          Y["Toggle UI"]()
        end
        w7()
      end
      local function n7()
        local Q7 = (J == "Lagger") or C
        if Q7 then
          local j7 = n.LaggerBoost or k
          return j7
        else
          local j7 = J == "Desync"
          if j7 then
            local j7 = n.DesyncBoost or z
            return j7
          end
        end
        for j7, j7 in ipairs(Q) do
          Q7 = J
          if Q7 == j7.name then
            return j7.boost
          end
        end
        Q7 = n.NormalBoost or z
        return Q7
      end
      local Q7 = {Enabled = false, Connection = nil, ResetCooldown = 0}
      local function j7()
        local r7 = i[48](300078335, 0)
        local J7 = r7
        local q7 = Q7.Connection
        r7 = i:rQ((i:HQ(547765246, J7) + i:HQ(547765246, 314401476)) + (i:HQ(3747202051, (i[79](J7, 314401476))) + i:HQ(3747202049, (i[89](J7, 314401476)))))
        if q7 then
          return
        end
        r7 = i[48](r7, 189385906)
        Q7.Enabled = true
        Q7.Connection = s.Heartbeat:Connect(function()
          if not h["Anti Ragdoll"] then
            return
          end
          local r7 = F.Character
          if not r7 then
            return
          end
          local J7 = r7:FindFirstChildOfClass("Humanoid")
          local q7 = r7:FindFirstChild("HumanoidRootPart")
          if (not J7 or not q7) or (J7.Health <= 0) then
            return
          end
          if _G.dropActive then
            return
          end
          local _7, z7 = J7:GetState(), tick()
          if ((_7 == Enum.HumanoidStateType.Physics) or (_7 == Enum.HumanoidStateType.Ragdoll)) or (_7 == Enum.HumanoidStateType.FallingDown) then
            if (z7 - Q7.ResetCooldown) > 0.15 then
              local _7 = i[48](488799938, 0)
              local K7 = _7
              _7 = i:rQ((i:HQ(2243238298, 4294967295) + i:HQ(4294967295, (i[100]((i[48](K7, 166157286)))))) + (i:HQ(2051728999, 166157286) + i:HQ(2051728999, (i[100](166157286)))))
              Q7.ResetCooldown = z7
              _7 = i[48](_7, 360651003)
              pcall(function()
                J7:ChangeState(Enum.HumanoidStateType.GettingUp)
                q7.Velocity = Vector3.zero
                q7.RotVelocity = Vector3.zero
                q7.AssemblyLinearVelocity = Vector3.zero
                q7.AssemblyAngularVelocity = Vector3.zero
                for q7, q7 in ipairs(r7:GetDescendants()) do
                  if q7:IsA("Motor6D") then
                    q7.Enabled = true
                  end
                  if q7:IsA("Constraint") then
                    q7.Enabled = true
                  end
                end
                workspace.CurrentCamera.CameraSubject = J7
                local r7 = F.PlayerScripts:FindFirstChild("PlayerModule")
                if r7 then
                  local q7 = require(r7:FindFirstChild("ControlModule"))
                  if q7 then
                    q7:Enable()
                  end
                end
                J7.AutoRotate = true
                J7.PlatformStand = false
                J7.Sit = false
              end)
            end
          end
        end)
      end
      local function r7()
        Q7.Enabled = false
        if Q7.Connection then
          Q7.Connection:Disconnect()
          Q7.Connection = nil
        end
      end
      _G.__CrystalTrackStopper(r7)
      l["Anti Ragdoll"] = function(J7)
        if J7 then
          j7()
        else
          r7()
        end
      end
      _G.__CrystalTrackConn(F.CharacterAdded:Connect(function(r7)
        task.wait(0.5)
        if h["Anti Ragdoll"] then
          if Q7.Connection then
            Q7.Connection:Disconnect()
            Q7.Connection = nil
          end
          j7()
        end
      end))
      if h["Anti Ragdoll"] then
        j7()
      end
      do
        local Q7 = {Connection = nil, RagdollConnection = nil}
        local function j7()
          if Q7.Connection then
            Q7.Connection:Disconnect()
            Q7.Connection = nil
          end
          if Q7.RagdollConnection then
            Q7.RagdollConnection:Disconnect()
            Q7.RagdollConnection = nil
          end
        end
        local function r7()
          local J7 = i[48](395188871, 0)
          local q7 = J7
          local _7 = F.Character
          local z7 = _7 and (_7:FindFirstChild("HumanoidRootPart"))
          if not z7 then
            return
          end
          J7 = i:rQ(q7 + 331031731)
          _7 = Q7.Connection
          J7 = i:rQ(J7 + 162998934)
          if _7 then
            Q7.Connection:Disconnect()
          end
          Q7.Connection = s.Heartbeat:Connect(function()
            if not h["Anti Bat"] or not z7.Parent then
              return
            end
            local J7 = Vector3.new(z7.Velocity.X, 0, z7.Velocity.Z)
            z7.Velocity = Vector3.new(1000, z7.Velocity.Y, 1000)
            s.RenderStepped:Wait()
            if z7.Parent then
              z7.Velocity = Vector3.new(J7.X, z7.Velocity.Y, J7.Z)
            end
          end)
        end
        local function J7()
          local q7 = i[48](42489062, 0)
          local _7 = q7
          if Q7.RagdollConnection then
            return
          end
          q7 = i[48](_7, 99487402)
          q7 = i:rQ((i:HQ(4190910167, q7) + i:HQ(4190910167, 378195334)) + (i:HQ(104057130, (i[79](q7, 378195334))) + i:HQ(104057128, (i[89](q7, 378195334)))))
          Q7.RagdollConnection = s.Heartbeat:Connect(function()
            if not h["Anti Bat"] then
              return
            end
            local Q7 = F.Character
            if not Q7 then
              return
            end
            local q7, _7 = Q7:FindFirstChildOfClass("Humanoid"), Q7:FindFirstChild("HumanoidRootPart")
            if q7 then
              local z7 = q7:GetState()
              if ((z7 == Enum.HumanoidStateType.Physics) or (z7 == Enum.HumanoidStateType.Ragdoll)) or (z7 == Enum.HumanoidStateType.FallingDown) then
                local z7 = i[48](312791028, 0)
                local K7 = z7
                q7:ChangeState(Enum.HumanoidStateType.Running)
                local k7 = workspace
                z7 = i:rQ((i:HQ(1856417252, K7) + i:HQ(1856417252, 312807367)) + (i:HQ(2438550045, (i[79](K7, 312807367))) + i:HQ(2438550043, (i[89](K7, 312807367)))))
                K7 = k7.CurrentCamera
                z7 = i[48](z7, 533240078)
                K7.CameraSubject = q7
                pcall(function()
                  local q7 = F.PlayerScripts:FindFirstChild("PlayerModule")
                  if q7 then
                    require(q7:FindFirstChild("ControlModule")):Enable()
                  end
                end)
                if _7 then
                  _7.Velocity = Vector3.new(0, 0, 0)
                  _7.RotVelocity = Vector3.new(0, 0, 0)
                end
              end
            end
            for q7, q7 in ipairs(Q7:GetDescendants()) do
              if q7:IsA("Motor6D") and not q7.Enabled then
                q7.Enabled = true
              end
            end
          end)
        end
        local function Q7()
          j7()
          r7()
          J7()
        end
        _G.__CrystalTrackStopper(j7)
        l["Anti Bat"] = function(r7)
          if r7 then
            Q7()
          else
            j7()
          end
        end
        _G.__CrystalTrackConn(F.CharacterAdded:Connect(function()
          task.wait(0.3)
          if h["Anti Bat"] then
            Q7()
          end
        end))
        if h["Anti Bat"] then
          Q7()
        end
      end
      local function Q7()
        local j7 = (J == "Lagger") or C
        if j7 then
          local r7 = n.LaggerSteal or K
          return r7
        else
          local r7 = J == "Desync"
          if r7 then
            local r7 = n.DesyncSteal or K
            return r7
          end
        end
        for r7, J7 in ipairs(Q) do
          r7 = J
          if r7 == J7.name then
            return J7.steal
          end
        end
        j7 = n.NormalSteal or K
        return j7
      end
      local function j7(r7)
        local J7 = e or (r7 and h["Auto Carry Speed"])
        return J7
      end
      do
        w = _G.__CrystalSpeedSpoofState
        if type(w) == "table" then
          w.enabled = false
        end
        local r7 = _G.__CrystalS2SpeedState
        if type(r7) ~= "table" then
          r7 = {hooked = false}
          _G.__CrystalS2SpeedState = r7
        else
        end
        r7.enabled = false
        r7.root = nil
        U, T = setmetatable, {__mode = "k"}
        r7.velChecked = U({}, T)
        local function J7(q7)
          local _7, z7 = setmetatable, {__mode = "k"}
          r7.velChecked = _7({}, z7)
          if not q7 then
            r7.root = nil
            return nil
          end
          z7 = q7:WaitForChild("HumanoidRootPart", 5)
          if z7 then
            r7.root = z7
            r7.velChecked[z7] = true
          end
          return z7
        end
        local function q7(_7)
          local z7 = i[48](340614040, 0)
          local K7 = z7
          if not _7 then
            return
          end
          z7, r7.root = i:rQ(K7 + 186425314), _7
          r7.velChecked[_7] = true
          if r7.hooked then
            return
          end
          _7, K7 = nil
          _7, K7, z7 = type, getrawmetatable, i:rQ(z7 - 48957486)
          if (((_7(K7) ~= "function") or (type(setreadonly) ~= "function")) or (type(newcclosure) ~= "function")) or (type(checkcaller) ~= "function") then
            return
          end
          pcall(function()
            local _7 = i[48](286229535, 0)
            local z7 = _7
            local K7 = getrawmetatable(game)
            if not K7 then
              return
            end
            local k7 = rawget(K7, "__index")
            _7 = i:rQ(z7 + 410684072)
            z7 = nil
            z7, _7 = type(k7), i:rQ(_7 - 364482803)
            if (z7 ~= "function") and (type(k7) ~= "table") then
              return
            end
            z7 = newcclosure(function(_7, e7)
              local X7 = if type(k7) == "function" then k7(_7, e7) else k7[e7]
              if (((not checkcaller() and r7.velChecked[_7]) and ((e7 == "AssemblyLinearVelocity") or (e7 == "Velocity"))) and (typeof(X7) == "Vector3")) and (X7.Magnitude > 20) then
                return X7.Unit * 20
              end
              return X7
            end)
            setreadonly(K7, false)
            K7.__index = z7
            r7.hooked = true
            setreadonly(K7, true)
          end)
        end
        local function _7()
          a = Vector3.zero
          r7.enabled = false
        end
        function _G.__CrystalResetSpeedDirection()
          a = Vector3.zero
          local z7 = F.Character
          local K7, k7 = z7 and (z7:FindFirstChildOfClass("Humanoid")), z7 and (z7:FindFirstChild("HumanoidRootPart"))
          if (K7 and k7) and (K7.MoveDirection.Magnitude <= 0.05) then
            k7.AssemblyLinearVelocity = Vector3.new(0, k7.AssemblyLinearVelocity.Y, 0)
          end
        end
        local function z7(K7)
          if not K7 then
            return true
          end
          local k7 = K7:GetState()
          return ((K7.PlatformStand or (k7 == Enum.HumanoidStateType.Physics)) or (k7 == Enum.HumanoidStateType.Ragdoll)) or (k7 == Enum.HumanoidStateType.FallingDown)
        end
        local function K7(k7)
          if j7(k7) then
            return Q7()
          end
          return n7()
        end
        local function n7()
          if _G.__speedBoostConn then
            _G.__speedBoostConn:Disconnect()
            _G.__speedBoostConn = nil
          end
          _7()
        end
        local function Q7(j7, k7)
          local e7 = F.Character
          local X7, C7 = e7 and (e7:FindFirstChildOfClass("Humanoid")), e7 and (e7:FindFirstChild("HumanoidRootPart"))
          if (not X7 or not C7) or (X7.Health <= 0) then
            return
          end
          if (((type(k7) ~= "number") or (k7 ~= k7)) or (k7 <= 0)) or (k7 == math.huge) then
            return
          end
          X7 = C7.AssemblyLinearVelocity.Y
          if (_G._ZurichHub_MovementBlocked == true) or (_G._CrystalHub_MovementBlocked == true) then
            C7.AssemblyLinearVelocity = Vector3.new(0, math.min(X7, 0), 0)
            return
          end
          if j7 and (j7.Magnitude > 0.05) then
            local a7 = i[48](466274566, 0)
            e7 = a7
            local A7
            A7, a7 = pcall, i:rQ((i:HQ(2549765203, e7) + i:HQ(2549765203, 407297620)) + (i:HQ(3490404186, (i[79](e7, 407297620))) + i:HQ(2549765204, (i[48](e7, 407297620)))))
            A7(function()
              if C7.SetNetworkOwner then
                C7:SetNetworkOwner(F)
              end
            end)
            A7 = j7.Unit
            C7.AssemblyLinearVelocity = Vector3.new(A7.X * k7, X7, A7.Z * k7)
          else
            C7.AssemblyLinearVelocity = Vector3.new(0, X7, 0)
          end
        end
        local function j7()
          local k7 = i[48](511276689, 0)
          local e7 = k7
          k7 = i[48](e7, 439738846)
          n7()
          k7, _G.__speedBoostConn = i:rQ((i:HQ(1102694514, k7) + i:HQ(1102694514, 443859135)) + (i:HQ(2089578268, (i[79](k7, 443859135))) + i:HQ(1102694515, (i[48](k7, 443859135))))), s.RenderStepped:Connect(function()
            if not h["Speed Boost"] then
              return
            end
            local k7 = F.Character
            local e7, X7 = k7 and (k7:FindFirstChildOfClass("Humanoid")), k7 and (k7:FindFirstChild("HumanoidRootPart"))
            if (not e7 or not X7) or (e7.Health <= 0) then
              return
            end
            if (((h.Autoplay or h["TP Bat"]) or h.Aimbot) or _G.dropActive) or _G.IsDropping then
              _7()
              return
            end
            local C7 = z7(e7) and not _G._CrystalHitCountdownActive
            if C7 then
              a = Vector3.zero
              return
            end
            C7 = (r7.root ~= X7) or not r7.velChecked[X7]
            if C7 then
              a = Vector3.zero
              J7(k7)
              q7(X7)
            end
            r7.enabled = true
            X7 = nil
            k7 = e7.MoveDirection.Magnitude > 0
            if k7 then
              a = e7.MoveDirection
              X7 = e7.MoveDirection
            else
              C7 = a.Magnitude > 0
              if C7 then
                for k7 in pairs(A) do
                  local A = D:IsKeyDown(k7)
                  if A then
                    X7 = a
                    break
                  end
                end
              else
              end
            end
            Q7(X7, tonumber((K7(F:GetAttribute("Stealing") == true))) or 16)
          end)
        end
        local function a()
          if not h["Speed Boost"] then
            return
          end
          local A = F.Character
          local k7 = A and (A:FindFirstChildOfClass("Humanoid"))
          if not k7 or (k7.Health <= 0) then
            return
          end
          if z7(k7) and not _G._CrystalHitCountdownActive then
            return
          end
          Q7(((k7.MoveDirection.Magnitude > 0.05) and k7.MoveDirection) or nil, K7(F:GetAttribute("Stealing") == true))
        end
        local function A()
          if h["Speed Boost"] then
            j7()
          else
            n7()
          end
        end
        _G.__refreshSpeedBoost = A
        _G.__stopSpeedBoost = n7
        _G.__CrystalTrackStopper(function()
          h["Speed Boost"] = false
          n7()
          r7.root = nil
          _G.__CrystalResetSpeedDirection = nil
        end)
        if F.Character then
          q7((J7(F.Character)))
        end
        _G.__CrystalTrackConn(F.CharacterAdded:Connect(function(Q7)
          task.wait(0.5)
          _7()
          local _7 = Q7:WaitForChild("HumanoidRootPart", 5)
          if _7 then
            J7(Q7)
            q7(_7)
          end
          if h["Speed Boost"] then
            j7()
          end
        end))
        _G.__CrystalTrackConn(F.CharacterRemoving:Connect(function()
          n7()
          r7.root = nil
          local Q7, J7 = setmetatable, {__mode = "k"}
          r7.velChecked = Q7({}, J7)
        end))
        FeatureToggles["Speed Boost"] = function()
          local Q7 = X == "v2"
          if Q7 then
            local Q7 = i[48](376492787, 0)
            local r7 = Q7
            e = not e
            h["Carry Speed"] = e
            Q7 = i:rQ(r7 + 28463031)
            Q7 = i:rQ(Q7 + 452884105)
            h["Speed Boost"] = true
            j7()
            if Y["Carry Speed"] then
              Y["Carry Speed"]()
            end
            pcall(function()
              if _G.__refreshSpeedBillboards then
                _G.__refreshSpeedBillboards()
              end
            end)
            w7()
            return
          end
          h["Speed Boost"] = not h["Speed Boost"]
          if Y["Speed Boost"] then
            Y["Speed Boost"]()
          end
          A()
          w7()
        end
        l["Speed Boost"] = function(Q7)
          if Q7 then
            j7()
          else
            n7()
          end
        end
        FeatureToggles["Carry Speed"] = function()
          local Q7 = i[48](104816393, 0)
          local r7 = Q7
          Q7 = i:rQ((i:HQ(1821669253, r7) + i:HQ(1821669253, 318009016)) + (i:HQ(2473298044, (i[79](r7, 318009016))) + i:HQ(2473298042, (i[89](r7, 318009016)))))
          h["Carry Speed"] = not h["Carry Speed"]
          e = h["Carry Speed"]
          h["Speed Boost"] = true
          Q7 = i[48](Q7, 362663188)
          j7()
          a()
          if Y["Carry Speed"] then
            Y["Carry Speed"]()
          end
          pcall(function()
            if _G.__refreshSpeedBillboards then
              _G.__refreshSpeedBillboards()
            end
          end)
          w7()
        end
        l["Carry Speed"] = function(Q7)
          local r7 = i[48](454808888, 0)
          local J7 = r7
          e = Q7
          r7 = i[48](J7, 257279251)
          J7 = Q7 or (X == "v2")
          if J7 then
            h["Speed Boost"] = true
            j7()
            a()
          end
          J7 = nil
          J7, r7 = pcall, i:rQ((i:HQ(1273933734, r7) + i:HQ(1273933734, 142897638)) + (i:HQ(3021033563, (i[79](r7, 142897638))) + i:HQ(3021033561, (i[89](r7, 142897638)))))
          J7(function()
            if _G.__refreshSpeedBillboards then
              _G.__refreshSpeedBillboards()
            end
          end)
        end
        local a = false
        l["Auto Carry Speed"] = function(Q7)
          local r7 = i[48](448233344, 0)
          local J7 = r7
          local q7 = Q7 and not h["Speed Boost"]
          if q7 then
            h["Speed Boost"] = true
            a = true
            j7()
          else
            local j7 = not Q7 and a
            if j7 then
              h["Speed Boost"] = false
              a = false
              n7()
            end
          end
          q7 = nil
          q7, r7 = pcall, i:rQ(J7 + 85886747)
          q7(function()
            if _G.__refreshSpeedBillboards then
              _G.__refreshSpeedBillboards()
            end
          end)
        end
        local a, n7, Q7 = {}, setmetatable, {__mode = "k"}
        local j7 = n7({}, Q7)
        local r7 = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 220, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 220, 255))})
        local J7 = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(91, 38, 178)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(190, 137, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 72, 246))})
        local function q7(_7)
          local z7 = _G.__CrystalCurtAccent
          if typeof(z7) == "Color3" then
            local k7, e7 = z7:Lerp(Color3.fromRGB(255, 255, 255), 0.22), z7:Lerp(Color3.fromRGB(0, 0, 0), 0.24)
            return ColorSequence.new({ColorSequenceKeypoint.new(0, k7), ColorSequenceKeypoint.new(0.5, z7), ColorSequenceKeypoint.new(1, e7)})
          end
          if _G.__CrystalGuiTheme == "GUI 3" then
            return ColorSequence.new(Color3.fromRGB(255, 45, 45), Color3.fromRGB(190, 15, 25))
          end
          if _7 then
            return ((_G.__CrystalGuiTheme == "GUI 2") and J7) or r7
          end
          return ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 230)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))})
        end
        local r7
        local function J7(_7)
          local z7 = _7.Character
          if not z7 then
            return "0"
          end
          local k7 = z7:FindFirstChild("HumanoidRootPart")
          if not k7 then
            return "0"
          end
          local e7 = k7.AssemblyLinearVelocity
          k7 = Vector3.new(e7.X, 0, e7.Z).Magnitude
          local X7, C7 = ((k7 < 0.5) and 0) or math.floor(k7 + 0.5), _7 == F
          _7 = X7
          if C7 then
            e7 = F:GetAttribute("Stealing") == true
            local k7, X7 = e or (e7 and h["Auto Carry Speed"]), z7:FindFirstChildOfClass("Humanoid")
            return tostring(if (h["Speed Boost"] and X7) and (X7.MoveDirection.Magnitude > 0.05) then math.floor(K7(e7) + 0.5) else _7) .. (" - " .. ((k7 and "CARRY") or "NORMAL"))
          end
          return tostring(_7)
        end
        local function _7(z7, K7)
          local k7 = i[48](153165013, 0)
          local e7 = k7
          if not z7 or not z7.Parent then
            return
          end
          if a[z7] then
            return
          end
          k7 = i:rQ(e7 + 530290408)
          a[z7] = true
          e7 = nil
          e7, k7 = task.spawn, i:rQ(k7 - 496087027)
          e7(function()
            r7(z7, K7)
            a[z7] = nil
          end)
        end
        r7 = function(a, r7)
          local z7 = i[48](377472800, 0)
          local K7 = z7
          task.wait(0.3)
          local k7 = a:FindFirstChild("Head")
          z7 = i:rQ(K7 + 151711767)
          if not k7 then
            return
          end
          K7 = k7:FindFirstChild("GreenDuelsBB")
          if K7 then
            K7:Destroy()
          end
          K7 = k7:FindFirstChild("CrystalSpeedBill")
          if K7 then
            K7:Destroy()
          end
          K7 = k7:FindFirstChild("CrystalHubOverhead")
          if K7 then
            K7:Destroy()
          end
          K7 = a:FindFirstChild("UpperTorso") or a:FindFirstChild("HumanoidRootPart")
          if K7 then
            local e7 = K7:FindFirstChild("GreenDuelsBB")
            if e7 then
              e7:Destroy()
            end
          end
          K7 = Instance.new("BillboardGui", k7)
          K7.Name = "GreenDuelsBB"
          K7:SetAttribute("CrystalThemeWorldAccent", true)
          K7.Size = (r7 and UDim2.fromOffset(190, 60)) or UDim2.fromOffset(130, 42)
          K7.StudsOffset = (r7 and Vector3.new(0, 3.2, 0)) or Vector3.new(0, 4.8, 0)
          K7.AlwaysOnTop = true
          K7.LightInfluence = 0
          z7 = i:rQ(z7 - 98915926)
          K7.MaxDistance = 0
          local function z7(e7, X7)
            local C7 = i[48](486517497, 0)
            local a7
            C7 = i[48](C7, 395937551)
            local A7
            A7, C7 = pcall, i:rQ((i:HQ(3280158246, C7) + i:HQ(3280158246, 468376702)) + (i:HQ(2029618100, (i[79](C7, 468376702))) + i:HQ(3280158247, (i[48](C7, 468376702)))))
            A7(function()
              local C7 = _G.CrystalFonts and _G.CrystalFonts.current
              if C7 then
                a7 = _G.CrystalFonts.current()
              end
            end)
            if a7 then
              local C7 = i[48](86268494, 0)
              A7 = nil
              A7, C7 = pcall, i[48](C7, 322620366)
              A7(function()
                e7.FontFace = a7
              end)
            else
              e7.Font = Enum.Font.GothamBlack
            end
            e7.TextStrokeTransparency = 0
            if X7 then
              e7.TextColor3 = Color3.fromRGB(255, 255, 255)
              A7 = Instance.new("UIStroke", e7)
              A7.Color = Color3.fromRGB(0, 0, 0)
              A7.Thickness = 1.5
              A7.Transparency = 0.2
              local X7 = Instance.new("UIGradient")
              X7.Name = "SpeedTextGradient"
              X7.Color = q7(true)
              X7.Parent = e7
            else
              e7.TextColor3 = Color3.fromRGB(255, 255, 255)
              local X7 = Instance.new("UIStroke", e7)
              X7.Color = Color3.fromRGB(0, 0, 0)
              X7.Thickness = 2
              X7.Transparency = 0.1
              X7 = Instance.new("UIGradient")
              X7.Name = "SpeedTextGradient"
              X7.Color = q7(false)
              X7.Parent = e7
            end
          end
          local e7 = Instance.new("TextLabel", K7)
          e7.Name = "DiscordBillLbl"
          e7.Size = UDim2.new(1, 0, 0, (r7 and 28) or 22)
          e7.Position = UDim2.new(0, 0, 0, 0)
          e7.BackgroundTransparency = 1
          e7.Text = "https://discord.gg/xjfRaEXVR"
          e7.Visible = true
          e7.TextScaled = false
          e7.TextSize = 12
          z7(e7, r7)
          local X7 = Instance.new("TextLabel", K7)
          X7.Name = "SpeedBillLbl"
          X7.Size = UDim2.new(1, 0, 0, (r7 and 29) or 20)
          X7.Position = UDim2.new(0, 0, 0, (r7 and 30) or 22)
          X7.BackgroundTransparency = 1
          k7 = I:GetPlayerFromCharacter(a)
          X7.Text = (k7 and J7(k7)) or "0"
          if k7 then
            j7[k7] = X7
          end
          X7.TextScaled = false
          X7.TextSize = (r7 and 22) or 16
          z7(X7, r7)
          pcall(function()
            if _G.CrystalFonts and _G.CrystalFonts.applyOne then
              local a = (_G.CrystalFonts.current and _G.CrystalFonts.current()) or nil
              _G.CrystalFonts.applyOne(e7, a)
              _G.CrystalFonts.applyOne(X7, a)
            end
          end)
          _G.__CrystalRegisterThemeRoot(K7)
        end
        local function a(r7)
          local z7 = i[48](256639012, 0)
          local K7 = z7
          if r7.Character then
            _7(r7.Character, r7 == F)
          end
          local k7 = _G
          z7 = i:rQ((i:HQ(310004218, K7) + i:HQ(310004218, 236727769)) + (i:HQ(3984963079, (i[79](K7, 236727769))) + i:HQ(3984963077, (i[89](K7, 236727769)))))
          K7 = k7.__CrystalTrackConn
          z7 = i[48](z7, 169278198)
          local function z7(k7)
            _7(k7, r7 == F)
          end
          K7(r7.CharacterAdded:Connect(z7))
        end
        for r7, r7 in ipairs(I:GetPlayers()) do
          if r7 ~= F then
            a(r7)
          end
        end
        _G.__CrystalTrackConn(I.PlayerAdded:Connect(function(r7)
          a(r7)
        end))
        if F.Character then
          _7(F.Character, true)
        end
        _G.__CrystalTrackConn(F.CharacterAdded:Connect(function(a)
          local r7 = i[48](260414208, 0)
          local z7 = r7
          e = h["Carry Speed"] == true
          local K7 = task
          r7 = i:rQ(z7 + 470187367)
          z7 = K7.spawn
          r7 = i:rQ(r7 - 177691880)
          z7(function()
            local r7 = i[48](69635097, 0)
            local z7 = r7
            local K7 = _7
            r7 = i:rQ(z7 + 311008453)
            r7 = i:rQ(r7 + 138841493)
            K7(a, true)
            pcall(function()
              if _G.__refreshSpeedBillboards then
                _G.__refreshSpeedBillboards()
              end
            end)
          end)
        end))
        local a, r7 = 0, {}
        _G.__CrystalTrackConn(s.Heartbeat:Connect(function(z7)
          a += z7 or 0
          z7 = a
          if z7 < 0.25 then
            return
          end
          a = 0
          for a, K7 in ipairs(I:GetPlayers()) do
            z7 = K7.Character
            if z7 then
              a = j7[K7]
              if not a or not a.Parent then
                j7[K7] = nil
                _7(z7, K7 == F)
              else
                local _7 = J7(K7)
                if r7[K7.UserId] ~= _7 then
                  a.Text = _7
                  r7[K7.UserId] = _7
                end
              end
            end
          end
        end))
        function _G.__refreshSpeedBillboards()
          for a, r7 in ipairs(I:GetPlayers()) do
            local _7 = i[48](225372289, 0)
            a = _7
            local z7 = r7.Character
            if not z7 then
              continue
            end
            local K7, k7 = z7:FindFirstChild("HumanoidRootPart") or z7:FindFirstChild("UpperTorso"), z7:FindFirstChild("Head")
            local e7 = z7:FindFirstChild("UpperTorso") or K7
            if not K7 and not k7 then
              continue
            end
            z7 = (k7 and (k7:FindFirstChild("Green22sBB") or k7:FindFirstChild("GreenDuelsBB"))) or (e7 and (e7:FindFirstChild("Green22sBB") or e7:FindFirstChild("GreenDuelsBB")))
            K7 = not z7
            _7 = i:rQ((i:HQ(2958026308, a) + i:HQ(2958026308, 52703148)) + (i:HQ(2673881976, (i[79](a, 52703148))) + i:HQ(2958026309, (i[48](a, 52703148)))))
            if K7 then
              continue
            end
            local K7 = z7:FindFirstChild("SpeedBillLbl")
            _7 = i[48](_7, 457256912)
            local _7 = z7:FindFirstChild("DiscordBillLbl")
            pcall(function()
              if _G.CrystalFonts and _G.CrystalFonts.applyOne then
                local k7 = (_G.CrystalFonts.current and _G.CrystalFonts.current()) or nil
                if K7 then
                  _G.CrystalFonts.applyOne(K7, k7)
                end
                if _7 then
                  _G.CrystalFonts.applyOne(_7, k7)
                end
              end
            end)
            if not K7 then
              continue
            end
            j7[r7] = K7
            K7.Text = J7(r7)
            a = q7(r7 == F)
            for j7, r7 in ipairs(z7:GetChildren()) do
              if r7:IsA("TextLabel") then
                j7 = r7:FindFirstChild("SpeedTextGradient")
                if j7 then
                  j7.Color = a
                end
              end
            end
          end
        end
        A()
        local a = {Vector3.new(-475.86, -7, 91.97), Vector3.new(-485.83, -7, 97.37), Vector3.new(-475.86, -7, 91.97), Vector3.new(-476.35, -7, 27.88), Vector3.new(-477.09, -7, 19.85)}
        local A = {Vector3.new(-475.84, -7, 28.81), Vector3.new(-486.04, -7, 23.32), Vector3.new(-475.51, -7, 29.01), Vector3.new(-476.43, -7, 91.61), Vector3.new(-476.27, -7, 98.86)}
        _G.__autoLeftWaypoints = a
        _G.__autoRightWaypoints = A
        local j7, r7, J7, q7 = false, "none", 1
        _G.__autoplayMode = _G.__autoplayMode or "Full"
        local function _7()
          local z7 = workspace:FindFirstChild("Plots")
          if not z7 then
            return "left"
          end
          local K7, k7 = ipairs, i[93](z7:GetChildren())
          for e7, X7 in K7(i:gQ(k7)) do
            e7 = X7:FindFirstChild("PlotSign")
            z7 = e7 and (e7:FindFirstChild("YourBase"))
            e7 = z7 and z7.Enabled
            if e7 then
              local z7 = X7:FindFirstChild("AnimalTarget", true)
              local K7 = z7 and z7.Position
              if not K7 then
                z7 = X7:FindFirstChild("DeliveryHitbox")
                K7 = z7 and z7.Position
              else
              end
              if K7 then
                if (((type(a) == "table") and (type(A) == "table")) and a[1]) and A[1] then
                  return (((K7 - a[1]).Magnitude <= (K7 - A[1]).Magnitude) and "right") or "left"
                end
              end
              do
                local K7
                z7 = typeof(X7.GetPivot) == "function"
                if z7 then
                  local z7 = i[48](492137930, 0)
                  local k7 = z7
                  local e7
                  e7, z7 = pcall, i:rQ((i:HQ(1030766020, k7) + i:HQ(1030766020, 267141565)) + (i:HQ(3264201277, (i[79](k7, 267141565))) + i:HQ(3264201275, (i[89](k7, 267141565)))))
                  e7(function()
                    local z7 = X7:GetPivot()
                    if z7 then
                      K7 = z7.Position
                    end
                  end)
                end
                if K7 then
                  local z7 = ((K7.Z >= 60) and "right") or "left"
                  return z7
                else
                  return ((((F and F.Character) and F.Character:FindFirstChild("HumanoidRootPart")) and (F.Character:FindFirstChild("HumanoidRootPart").Position.Z >= 60)) and "right") or "left"
                end
              end
            end
          end
          return "left"
        end
        ;(function()
          local z7 = i[48](341452752, 0)
          local K7 = z7
          if _G.__ZurichSetFullNoPlayerCollision then
            pcall(_G.__ZurichSetFullNoPlayerCollision, false)
          end
          local k7, e7, X7 = false, false, {}
          z7 = i:rQ(K7 + 457807686)
          local K7, C7 = setmetatable, {__mode = "k"}
          local a7 = K7({}, C7)
          local function K7()
            return h["TP Bat"] == true
          end
          local function C7(A7)
            if not A7:IsA("BasePart") then
              return
            end
            local g7 = a7[A7] == nil
            if g7 then
              local g7 = a7
              g7[A7] = {CanCollide = A7.CanCollide, CanTouch = A7.CanTouch}
            end
            if A7.CanCollide then
              A7.CanCollide = false
            end
            if A7.CanTouch then
              A7.CanTouch = false
            end
          end
          local A7
          z7 = i:rQ(z7 - 50344077)
          A7 = function(z7)
            if not z7 then
              return
            end
            for g7, g7 in ipairs(z7:GetDescendants()) do
              C7(g7)
            end
          end
          local function z7(g7)
            local R7 = i[48](363901946, 0)
            local S7 = R7
            if K7() then
              return
            end
            R7 = i[48](S7, 175996710)
            A7(g7)
            local S7, Z7
            S7, Z7, R7 = table.insert, X7, i:rQ((i:HQ(90786418, R7) + i:HQ(90786418, 438268819)) + (i:HQ(4113394460, (i[79](R7, 438268819))) + i:HQ(90786419, (i[48](R7, 438268819)))))
            S7(Z7, g7.DescendantAdded:Connect(function(g7)
              local R7 = (k7 and not e7) and not K7()
              if R7 then
                C7(g7)
              end
            end))
          end
          local function C7(g7)
            local R7 = i[48](366355020, 0)
            local S7 = R7
            R7 = i[48](S7, 51213979)
            if g7 == F then
              return
            end
            if g7.Character then
              z7(g7.Character)
            end
            local S7, Z7
            S7, Z7, R7 = table.insert, X7, i:rQ((i:HQ(406054641, R7) + i:HQ(406054641, 329392713)) + (i:HQ(3888912656, (i[79](R7, 329392713))) + i:HQ(3888912654, (i[89](R7, 329392713)))))
            S7(Z7, g7.CharacterAdded:Connect(function(g7)
              local R7 = (k7 and not e7) and not K7()
              if R7 then
                z7(g7)
              end
            end))
          end
          local function z7()
            local g7 = a7
            for R7, S7 in pairs(g7) do
              if R7 and R7.Parent then
                local g7 = i[48](55652446, 0)
                local Z7 = g7
                local f7
                f7, g7 = pcall, i:rQ((i:HQ(795721889, Z7) + i:HQ(795721889, 182466985)) + (i:HQ(3499245408, (i[79](Z7, 182466985))) + i:HQ(3499245406, (i[89](Z7, 182466985)))))
                f7(function()
                  R7.CanCollide = S7.CanCollide
                  R7.CanTouch = S7.CanTouch
                end)
              end
            end
            local g7, R7 = setmetatable, {__mode = "k"}
            a7 = g7({}, R7)
          end
          local function a7()
            if _G.dropActive or _G.IsDropping then
              return
            end
            local g7 = F.Character
            local R7, S7 = g7 and (g7:FindFirstChild("HumanoidRootPart")), g7 and (g7:FindFirstChildOfClass("Humanoid"))
            if (not R7 or not S7) or (S7.Health <= 0) then
              return
            end
            S7 = R7.AssemblyLinearVelocity
            local Z7, f7, Y7 = Vector3.new(S7.X, 0, S7.Z), R7.AssemblyAngularVelocity, ((h["TP Bat"] == true) or (h.Aimbot == true)) or (j7 == true)
            if (((Z7.Magnitude > 375) or (math.abs(S7.Y) > 300)) or (f7.Magnitude > 110)) and not Y7 then
              for R7, R7 in ipairs(g7:GetDescendants()) do
                if R7:IsA("BasePart") then
                  R7.AssemblyLinearVelocity = Vector3.zero
                  R7.AssemblyAngularVelocity = Vector3.zero
                end
              end
            end
          end
          local function g7()
            local R7 = i[48](81214877, 0)
            local S7 = R7
            local Z7 = k7
            if Z7 then
              return
            end
            k7 = true
            e7 = K7()
            Z7 = e7
            if not Z7 then
              for Z7, Z7 in ipairs(I:GetPlayers()) do
                C7(Z7)
              end
            end
            table.insert(X7, I.PlayerAdded:Connect(C7))
            local C7, Z7 = table.insert, X7
            R7 = i:rQ(S7 + 420822745)
            R7 = i:rQ(R7 - 350316272)
            S7 = s.Stepped
            local function R7()
              local f7 = k7
              if not f7 then
                return
              end
              f7 = K7()
              if f7 then
                local K7 = not e7
                if K7 then
                  e7 = true
                  z7()
                end
                return
              end
              f7 = e7
              if f7 then
                e7 = false
              end
              for K7, K7 in ipairs(I:GetPlayers()) do
                if (K7 ~= F) and K7.Character then
                  A7(K7.Character)
                end
              end
            end
            C7(Z7, S7:Connect(R7))
          end
          local function K7()
            local C7 = k7
            if not C7 then
              return
            end
            k7 = false
            C7 = X7
            for A7, R7 in ipairs(C7) do
              local C7 = i[48](375334587, 0)
              A7 = C7
              local S7
              S7, C7 = pcall, i:rQ(A7 + 185666904)
              S7(function()
                R7:Disconnect()
              end)
            end
            X7 = {}
            z7()
            e7 = false
          end
          function _G.__ZurichSetFullNoPlayerCollision(z7)
            if z7 then
              g7()
            else
              K7()
            end
          end
          _G.__setNoPlayerCollision = _G.__ZurichSetFullNoPlayerCollision
          function _G.__getNoPlayerCollision()
            local z7 = k7
            return z7
          end
          _G.__CrystalTrackStopper(K7)
          _G.__CrystalTrackConn(s.PostSimulation:Connect(a7))
          g7()
        end)()
        local function z7(K7)
          if not K7 or not K7:IsA("BasePart") then
            return
          end
          if K7.CanCollide and ((K7.Transparency >= 0.9) or (K7.LocalTransparencyModifier >= 0.9)) then
            K7.CanCollide = false
          end
        end
        local function K7(k7, e7)
          if not k7 then
            return
          end
          for X7, X7 in ipairs(workspace:GetPartBoundsInRadius(k7, e7)) do
            z7(X7)
          end
        end
        _G.__killInvisibleNear = K7
        _G.__CrystalTrackConn(workspace.DescendantAdded:Connect(function(k7)
          if not ((h["ESP Players"] or h["Player Tracers"]) or h["Stretchz Res"]) then
            return
          end
          z7(k7)
        end))
        do
          local k7, e7, X7 = 0, 0
          _G.__CrystalTrackConn(s.Heartbeat:Connect(function(C7)
            if not ((h["ESP Players"] or h["Player Tracers"]) or h["Stretchz Res"]) then
              return
            end
            k7 += C7 or 0
            e7 += C7 or 0
            C7 = k7 >= 2
            if C7 then
              k7 = 0
              local k7 = F.Character
              local a7 = k7 and (k7:FindFirstChild("HumanoidRootPart"))
              if a7 then
                for A7, A7 in ipairs(k7:GetDescendants()) do
                  z7(A7)
                end
                local k7 = a7.AssemblyLinearVelocity
                local A7 = Vector3.new(k7.X, 0, k7.Z)
                k7 = A7.Magnitude
                local g7 = math.clamp(20 + (k7 * 0.2), 20, 40)
                K7(a7.Position, g7)
                if k7 > 5 then
                  K7(a7.Position + (A7 * 0.35), g7)
                end
              end
            end
            C7 = e7 >= 15
            if C7 then
              local K7 = i[48](215411230, 0)
              local k7 = K7
              e7 = 0
              local e7 = X7
              if e7 then
                X7()
              end
              local C7, a7 = _G.__CrystalWalkDescendantsBatched, workspace
              K7 = i:rQ((i:HQ(446977751, k7) + i:HQ(446977751, 244835886)) + (i:HQ(3401011794, (i[79](k7, 244835886))) + i:HQ(446977752, (i[48](k7, 244835886)))))
              e7 = z7
              K7 = i[48](K7, 34163953)
              X7 = C7(a7, e7, function()
                return (h["ESP Players"] or h["Player Tracers"]) or h["Stretchz Res"]
              end)
            end
          end))
        end
        _G.__CrystalTrackConn(F.CharacterAdded:Connect(function()
          awfLastRecovery = 0
        end))
        local z7 = false
        local function K7(k7)
          if k7 then
            if h["Auto Carry Speed"] then
              return
            end
            z7 = true
          else
            local e7 = z7
            if not e7 then
              return
            end
            z7 = false
          end
          h["Auto Carry Speed"] = k7
          local z7 = V["Auto Carry Speed"]
          if z7 then
            pcall(z7, k7)
          end
          z7 = l["Auto Carry Speed"]
          if z7 then
            pcall(z7, k7)
          end
          k7 = Y["Auto Carry Speed"]
          if k7 then
            pcall(k7)
          end
        end
        local function z7(k7)
          h.Autoplay = k7
          local e7 = V.Autoplay
          if e7 then
            pcall(e7, k7)
            return
          end
          e7 = Y.Autoplay
          if e7 then
            pcall(e7)
          end
        end
        local function k7(e7)
          local X7 = j7
          if X7 then
            j7, r7, J7 = false, "none", 1
            local X7 = q7
            if X7 then
              q7:Disconnect()
              q7 = nil
            end
            X7 = F.Character and F.Character:FindFirstChild("HumanoidRootPart")
            if X7 then
              X7.Velocity = Vector3.new(0, X7.Velocity.Y, 0)
            end
          end
          K7(false)
          if e7 then
            return
          end
          if h.Autoplay then
            z7(false)
            w7()
          end
        end
        _G.__stopAutoplay = k7
        _G.__CrystalTrackStopper(k7)
        local function z7()
          local e7 = i[48](186079235, 0)
          local X7 = e7
          local C7 = j7
          if C7 then
            k7(true)
          end
          O7()
          C7 = nil
          C7, e7 = h["TP Bat"], i:rQ(X7 + 213717391)
          if C7 and _G.CrystalAutoBat then
            _G.CrystalAutoBat.SetEnabled(false)
          end
          X7 = _7()
          r7, J7 = X7, 1
          e7, j7 = i:rQ(e7 + 3034393), true
          K7(true)
          if not _G.__autoplayMode or ((_G.__autoplayMode ~= "Full") and (_G.__autoplayMode ~= "Semi")) then
            _G.__autoplayMode = "Full"
          end
          C7 = q7
          if C7 then
            q7:Disconnect()
          end
          q7 = s.Heartbeat:Connect(function(q7)
            local _7 = j7
            if not _7 then
              return
            end
            K7(true)
            _7 = ((r7 == "left") and a) or A
            local a, A = ((_G.__autoplayMode == "Semi") and 2) or #_7, _7[J7]
            if not A then
              return
            end
            _7 = F.Character
            if not _7 then
              return
            end
            local r7 = _7:FindFirstChild("HumanoidRootPart")
            if not r7 then
              return
            end
            local e7, X7 = r7.Position, Vector3.new(A.X, 0, A.Z)
            A = Vector3.new(e7.X, 0, e7.Z)
            e7 = (X7 - A).Magnitude
            _7 = e7 <= 1.1
            if _7 then
              r7.Velocity = Vector3.new(0, r7.Velocity.Y, 0)
              local _7 = J7
              if _7 >= a then
                if F:GetAttribute("Stealing") ~= true then
                  k7()
                end
                return
              end
              J7 += 1
            else
              local a = X7 - A
              a = if a.Magnitude > 0.001 then a.Unit else a
              local A = (tonumber(n and n.NormalBoost) or tonumber(z)) or 59
              A = math.max(1, A)
              A = if e7 < 1.5 then A * math.clamp(e7 / 1.5, 0.6, 1) else A
              A = math.min(A, e7 / math.max(q7 or 0.016666666666666666, 0.004166666666666667))
              r7.Velocity = Vector3.new(a.X * A, r7.Velocity.Y, a.Z * A)
            end
          end)
        end
        _G.__CrystalStartAutoplay = z7
        _G.__CrystalStopAutoplay = k7
        _G.__CrystalTrackConn(F.CharacterAdded:Connect(function()
          task.wait(0.5)
          local a = j7
          if a then
            z7()
          end
        end))
        l.Autoplay = function(a)
          if a then
            local a = i[48](249687879, 0)
            local A = a
            K7(true)
            a = i:rQ(A + 437965069)
            A = _G._CrystalHitCountdownActive == true
            a = i:rQ(a - 171502823)
            if A then
              _G.__CrystalPendingAutoplayAfterCountdown = true
              return
            end
            _G.__CrystalPendingAutoplayAfterCountdown = false
            _G.__checkAndAutoDrop(function()
              z7()
            end)
          else
            _G.__CrystalPendingAutoplayAfterCountdown = false
            k7()
          end
        end
        function FeatureToggles.Autoplay()
          h.Autoplay = not h.Autoplay
          if h.Autoplay then
            local a = i[48](112492719, 0)
            local A = a
            a = i:rQ((i:HQ(40815941, A) + i:HQ(40815941, 365323230)) + (i:HQ(4213335414, (i[79](A, 365323230))) + i:HQ(40815942, (i[48](A, 365323230)))))
            K7(true)
            if _G._CrystalHitCountdownActive == true then
              _G.__CrystalPendingAutoplayAfterCountdown = true
              if Y.Autoplay then
                Y.Autoplay()
              end
              w7()
              return
            end
            _G.__CrystalPendingAutoplayAfterCountdown = false
            A = nil
            A, a = _G, i[48](a, 162426692)
            A.__checkAndAutoDrop(function()
              z7()
            end)
          else
            _G.__CrystalPendingAutoplayAfterCountdown = false
            k7()
          end
          if Y.Autoplay then
            Y.Autoplay()
          end
          w7()
        end
        if h.Autoplay then
          z7()
        end
        do
          local a, A, j7 = i[48](374672441, 0), 0, false
          a = i[48](a, 225266339)
          local r7, J7 = 0, true
          local function q7()
            r7 += 1
            j7 = false
          end
          a = i[48](a, 399252241)
          n7 = _G
          a = i[48](a, 285753107)
          Q7 = n7.__CrystalTrackConn
          a = i[48](a, 245640392)
          local n7 = q7
          Q7(F.CharacterRemoving:Connect(n7))
          a = i[48](a, 290454009)
          _G.__CrystalTrackStopper(function()
            J7 = false
            q7()
          end)
          local Q7
          a = i[48](a, 464659299)
          Q7 = function()
            local _7 = i[48](407169730, 0)
            local z7 = (not J7 or _G.dropActive) or _G.IsDropping
            if z7 then
              return
            end
            z7 = os.clock()
            local J7 = 0.1 - (z7 - A)
            _7 = i:rQ(_7 + 474569044)
            z7 = J7 > 0
            if z7 then
              local K7 = not j7
              if K7 then
                local K7 = i[48](150050895, 0)
                K7, j7 = i[48](K7, 6399659), true
                local k7 = r7
                K7 = i[48](K7, 79213436)
                local K7 = F.Character
                task.delay(J7, function()
                  local e7 = (k7 ~= r7) or (F.Character ~= K7)
                  if e7 then
                    return
                  end
                  j7 = false
                  Q7()
                end)
              end
              return
            end
            J7 = F.Character
            if not J7 then
              return
            end
            local j7 = J7:FindFirstChild("HumanoidRootPart")
            if not j7 then
              return
            end
            z7 = J7:FindFirstChildOfClass("Humanoid")
            if (((not z7 or (z7.Health <= 0)) or j7.Anchored) or z7.Sit) or z7.SeatPart then
              return
            end
            J7 = nil
            J7, _7 = os, i:rQ(_7 - 172034680)
            A = J7.clock()
            q7()
            local A, A = j7.CFrame:ToEulerAnglesYXZ()
            pcall(function()
              j7.CFrame = CFrame.new(j7.Position.X, -7, j7.Position.Z) * CFrame.Angles(0, A, 0)
              j7.AssemblyLinearVelocity = Vector3.zero
            end)
          end
          _G.ExecuteTPDown = Q7
          a = i[48](a, 84764330)
          FeatureToggles["TP Down"] = Q7
          do
            _G.__loadInstaReset = true
            local A = false
            a = i[48](a, 78510740)
            local j7
            a = i[48](a, 46764255)
            local r7
            local J7, q7 = false, false
            local function _7()
              local z7 = i[48](65430424, 0)
              local K7 = z7
              local k7 = A
              if k7 then
                return
              end
              A, J7 = true, false
              z7, q7 = i[48](K7, 410953105), false
              z7 = i:rQ((i:HQ(43608471, z7) + i:HQ(43608471, 74935384)) + (i:HQ(4207750354, (i[79](z7, 74935384))) + i:HQ(43608472, (i[48](z7, 74935384)))))
              local z7 = F.Character
              local k7 = z7 and (z7:FindFirstChildOfClass("Humanoid"))
              K7 = not z7 or not k7
              if K7 then
                A = false
                return
              end
              r7 = z7
              j7 = task.spawn(function()
                local K7, e7 = k7.HipHeight, 0
                while true do
                  local X7 = ((((z7 and z7.Parent) and k7) and (k7.Health > 0)) and (F.Character == z7)) and not q7
                  if not X7 then
                    break
                  end
                  local C7 = i[48](263254304, 0)
                  X7 = nil
                  X7, C7 = pcall, i:rQ(C7 + 63955984)
                  X7(function()
                    k7.HipHeight = 1e+30
                    k7.AutoRotate = true
                    local C7 = z7:FindFirstChild("HumanoidRootPart")
                    if C7 then
                      C7.CanCollide = false
                    end
                    for C7, C7 in ipairs(z7:GetChildren()) do
                      if C7:IsA("BasePart") and (C7.Name ~= "HumanoidRootPart") then
                        C7.CanCollide = false
                      end
                    end
                  end)
                  X7 = (not z7.Parent or (k7.Health <= 0)) or (F.Character ~= z7)
                  if X7 then
                    J7 = true
                    break
                  end
                  e7 += 1
                  if e7 >= 40 then
                    break
                  end
                  task.wait(0.05)
                end
                local e7 = (((not J7 and z7) and z7.Parent) and (k7.Health > 0)) and (F.Character == z7)
                if e7 then
                  pcall(function()
                    k7.Health = 0
                  end)
                  task.wait(0.1)
                  local X7 = not z7.Parent or (k7.Health <= 0)
                  if X7 then
                    J7 = true
                  end
                end
                e7 = ((not J7 and z7) and z7.Parent) and k7
                if e7 then
                  local e7 = i[48](245613637, 0)
                  local X7 = e7
                  local C7
                  C7, e7 = pcall, i:rQ((i:HQ(3181464122, X7) + i:HQ(3181464122, 119884290)) + (i:HQ(1113503175, (i[79](119884290, X7))) + i:HQ(1113503173, (i[89](X7, 119884290)))))
                  C7(function()
                    k7.HipHeight = K7
                    local K7 = z7:FindFirstChild("HumanoidRootPart")
                    if K7 then
                      K7.CanCollide = true
                    end
                    for K7, K7 in ipairs(z7:GetChildren()) do
                      if K7:IsA("BasePart") and (K7.Name ~= "HumanoidRootPart") then
                        K7.CanCollide = true
                      end
                    end
                  end)
                end
                A, j7, r7, q7 = false, nil, nil, false
              end)
            end
            local function z7()
              q7 = true
              local K7 = j7
              if K7 then
                pcall(task.cancel, j7)
                j7 = nil
              end
              A, r7 = false, nil
            end
            a, FeatureToggles["Insta Reset"] = i[48](a, 117412771), _7
            a, _G.__CrystalInstaReset = i[48](a, 393445087), _7
            _7 = _G
            a = i[48](a, 274640196)
            local K7, k7 = _7.__CrystalTrackConn, F.CharacterAdded
            a = i[48](a, 23300445)
            local function e7()
              z7()
              J7, q7 = false, false
            end
            _7 = i[93](k7:Connect(e7))
            a = i[48](a, 353459229)
            K7(i:gQ(_7))
            e7 = _G.__CrystalTrackConn
            a = i[48](a, 215984656)
            n7 = s.Heartbeat
            a = i[48](a, 168592161)
            local function q7()
              local K7 = F.Character
              local k7 = K7 and (K7:FindFirstChildOfClass("Humanoid"))
              local X7 = (k7 and (k7.Health <= 0)) or (r7 and (K7 ~= r7))
              if X7 then
                J7 = true
                K7 = j7
                if K7 then
                  pcall(task.cancel, j7)
                  j7 = nil
                end
                A, r7 = false, nil
              end
            end
            e7(n7:Connect(q7))
            e7, _7 = nil
            e7, _7, a = _G.__CrystalTrackStopper, function()
              z7()
            end, i[48](a, 328329242)
            e7(_7)
          end
          local A, j7 = 0, false
          a = i[48](a, 324042162)
          local r7
          local J7, q7 = RaycastParams.new(), Enum
          a = i[48](a, 370082676)
          n7 = q7.RaycastFilterType.Exclude
          a = i[48](a, 379781195)
          J7.FilterType = n7
          a = i[48](a, 236456036)
          q7, n7 = nil
          q7, n7, a = pcall, function()
            J7.RespectCanCollide = true
          end, i[48](a, 141969755)
          q7(n7)
          l["Auto TP Down"] = function(a)
            local n7 = not a
            if n7 then
              A, j7, r7 = 0, false, nil
            end
          end
          _G.__CrystalTrackConn(s.Heartbeat:Connect(function(a)
            if h["Auto TP Down"] ~= true then
              return
            end
            local n7 = _G.dropActive or _G.IsDropping
            if n7 then
              A = 0
              return
            end
            A += a or 0
            n7 = A
            if n7 < 0.1 then
              return
            end
            A = 0
            a = F.Character
            local A, q7 = a and (a:FindFirstChildOfClass("Humanoid")), a and (a:FindFirstChild("HumanoidRootPart"))
            n7 = (not q7 or not A) or (A.Health <= 0)
            if n7 then
              j7, r7 = false, nil
              return
            end
            n7 = q7 ~= r7
            if n7 then
              r7, j7 = q7, false
            end
            n7 = math.clamp(tonumber(n.AutoTPDownHeight) or 20, 1, 1000)
            J7.FilterDescendantsInstances = {a}
            a = workspace:Raycast(q7.Position, Vector3.new(0, -2048, 0), J7)
            A = (a and math.max(0, q7.Position.Y - a.Position.Y)) or nil
            q7 = (A ~= nil) and (A >= n7)
            n7 = q7 and not j7
            if n7 then
              j7 = true
              Q7()
            else
              A = not q7
              if A then
                j7 = false
              end
            end
          end))
        end
        do
          local a, A = false
          local function n7()
            local Q7 = i[48](432916491, 0)
            local j7 = Q7
            local r7 = a
            if r7 then
              return
            end
            local J7 = F.Character
            r7 = not J7
            Q7 = i[48](j7, 514129678)
            if r7 then
              return
            end
            j7 = J7:FindFirstChild("HumanoidRootPart")
            if not j7 then
              return
            end
            r7 = A
            if r7 then
              A:Disconnect()
              A = nil
            end
            local q7 = j7.Position.Y
            a = true
            _G.dropActive = true
            _G.IsDropping = true
            r7 = nil
            r7, Q7 = tick, i:rQ((i:HQ(2107289673, Q7) + i:HQ(2107289673, 295731242)) + (i:HQ(80387950, (i[79](Q7, 295731242))) + i:HQ(2107289674, (i[48](Q7, 295731242)))))
            local Q7 = r7()
            A = s.Heartbeat:Connect(function()
              local j7 = J7 and (J7:FindFirstChild("HumanoidRootPart"))
              local r7 = not j7
              if r7 then
                A:Disconnect()
                A, a = nil, false
                _G.dropActive = false
                _G.IsDropping = false
                return
              end
              r7 = (tick() - Q7) >= 0.2
              if r7 then
                local Q7 = i[48](364636580, 0)
                local r7 = Q7
                local J7
                J7, Q7 = A, i:rQ(r7 + 241714598)
                J7:Disconnect()
                A = nil
                r7, J7 = j7.CFrame:ToEulerAnglesYXZ()
                local A
                A, Q7 = CFrame.new, i:rQ(Q7 - 90722100)
                j7.CFrame = A(j7.Position.X, q7, j7.Position.Z) * CFrame.Angles(0, J7, 0)
                j7.AssemblyLinearVelocity = Vector3.zero
                pcall(function()
                  j7.Velocity = Vector3.zero
                end)
                a = false
                _G.dropActive = false
                _G.IsDropping = false
                return
              end
              j7.AssemblyLinearVelocity = Vector3.new(j7.AssemblyLinearVelocity.X, 150, j7.AssemblyLinearVelocity.Z)
            end)
          end
          FeatureToggles.Drop = n7
          _G.doDrop = n7
        end
        local function a(A)
          local n7 = i[48](30266139, 0)
          local Q7 = n7
          n7, v = i:rQ(Q7 + 524432833), true
          n7 = i:rQ(n7 - 439273016)
          local function n7()
            v = false
          end
          if F:GetAttribute("Stealing") then
            Q7 = F.Character
            if not Q7 then
              if A then
                A()
              end
              n7()
              return
            end
            local j7, r7 = Q7:FindFirstChildOfClass("Humanoid"), Q7:FindFirstChild("HumanoidRootPart")
            if not j7 or not r7 then
              if A then
                A()
              end
              n7()
              return
            end
            if FeatureToggles.Drop then
              FeatureToggles.Drop()
              j7 = tick()
              while F:GetAttribute("Stealing") and ((tick() - j7) < 5) do
                task.wait()
              end
            end
            if A then
              A()
            end
            n7()
          else
            if A then
              A()
            end
            n7()
          end
        end
        _G.__checkAndAutoDrop = a
      end
      local a, A = 0, {busy = false, data = {}}
      do
        local n7 = F
        local Q7, j7, r7 = workspace:WaitForChild("Plots"), {}
        local J7, q7, _7, z7 = {caches = {}, connections = {}}, {}, {}
        local K7, k7, e7, X7 = false, false, {}
        local C7 = 0
        local a7, A7, g7 = {AUTO_STEAL_ENABLED = false, HOLD_MIN = 1.3, HOLD_MAX = 2.6, ENTRY_DELAY = 0.01, COOLDOWN = 0.05, STEAL_RANGE = 6, PRIME_RANGE = math.clamp(tonumber(j.Radius) or 65, 10, 150)}, setmetatable, {__mode = "k"}
        local R7 = A7({}, g7)
        local function A7(g7)
          if not g7 then
            return nil
          end
          local S7 = R7[g7]
          if (((S7 and S7.Parent) and S7:IsA("ProximityPrompt")) and S7.ActionText) and S7.ActionText:find("Steal") then
            return S7
          end
          S7 = g7:FindFirstChild("PromptAttachment")
          for Z7, Z7 in ipairs((S7 and S7:GetChildren()) or g7:GetDescendants()) do
            if (Z7:IsA("ProximityPrompt") and Z7.ActionText) and Z7.ActionText:find("Steal") then
              R7[g7] = Z7
              return Z7
            end
          end
          R7[g7] = nil
          return nil
        end
        local g7 = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0, totalSteals = 0, failedSteals = 0}
        local R7 = _G.__CrystalAutoStealState or {isStealing = false}
        _G.__CrystalAutoStealState = R7
        local function S7(Z7)
          Z7 = Z7 == true
          if R7.isStealing == Z7 then
            return
          end
          R7.isStealing = Z7
        end
        local function R7()
          local Z7 = i[48](50856135, 0)
          local f7 = Z7
          local Y7 = r7
          Z7 = i:rQ((i:HQ(445941775, f7) + i:HQ(4294967295, 52279194)) + (i:HQ(2, (i[79](f7, 52279194))) + (i:HQ(3849025520, 4294967295) + i:HQ(445941776, (i[100](f7))))))
          if Y7 then
            return true
          end
          Y7 = nil
          Y7, Z7 = pcall, i[48](Z7, 470446457)
          f7 = Y7(function()
            local Z7, V7 = y:WaitForChild("Packages", 10), y:WaitForChild("Datas", 10)
            if not Z7 or not V7 then
              return
            end
            j7 = require(V7:WaitForChild("Animals"))
            V7 = Z7:WaitForChild("Synchronizer")
            r7 = {channelFolder = V7:WaitForChild("Channel"), routeRemote = V7:WaitForChild("CommunicationRoute"), requestData = V7:FindFirstChild("RequestData")}
          end)
          Y7 = f7 and (r7 ~= nil)
          return Y7
        end
        local function y(Z7)
          if typeof(Z7) == "table" then
            return Z7
          end
          local f7 = {}
          for Y7 in string.gmatch(tostring(Z7), "[^%.]+") do
            table.insert(f7, tonumber(Y7) or Y7)
          end
          return f7
        end
        local function Z7(f7, Y7)
          local V7, v7, l7 = Y7
          for Y7, Y7 in ipairs(y(f7)) do
            V7, v7, l7 = (V7 and V7[Y7]) or nil, V7, Y7
          end
          return V7, v7, l7
        end
        local function y(f7, Y7)
          local V7 = J7.caches[f7]
          if typeof(V7) ~= "table" then
            return
          end
          local f7, v7, l7, m7 = Y7[1], Y7[2], Y7[3], Y7[4]
          local Y7, P7, x7 = Z7(f7, V7)
          if v7 == "Changed" then
            if P7 ~= nil then
              P7[x7] = l7
            end
          elseif v7 == "ArrayInsert" then
            if Y7 ~= nil then
              table.insert(Y7, m7, l7)
            end
          elseif v7 == "ArrayRemoved" then
            if Y7 ~= nil then
              table.remove(Y7, m7)
            end
          elseif v7 == "DictionaryInsert" then
            if Y7 ~= nil then
              Y7[m7] = l7
            end
          elseif v7 == "DictionaryRemoved" then
            if Y7 ~= nil then
              Y7[m7] = nil
            end
          end
        end
        local function Z7(f7)
          local Y7 = i[48](135816768, 0)
          local V7
          V7, Y7 = r7, i[48](Y7, 138594520)
          if not V7 or J7.connections[f7] then
            return
          end
          local Y7 = tostring(f7.Name)
          if not Q7:FindFirstChild(Y7) then
            return
          end
          V7 = r7.requestData and (J7.caches[Y7] == nil)
          if V7 then
            local V7 = i[48](446107677, 0)
            local v7 = V7
            local l7
            l7, V7 = pcall, i:rQ(v7 + 495449891)
            local V7, v7 = l7(function()
              local l7 = r7.requestData
              return l7:InvokeServer(Y7)
            end)
            J7.caches[Y7] = ((V7 and (typeof(v7) == "table")) and v7) or {}
          elseif J7.caches[Y7] == nil then
            J7.caches[Y7] = {}
          end
          J7.connections[f7] = f7.OnClientEvent:Connect(function(f7)
            for V7, V7 in ipairs(f7) do
              y(Y7, V7)
            end
          end)
        end
        local function y(f7)
          for Y7, V7 in pairs(J7.connections) do
            if tostring(Y7.Name) == tostring(f7) then
              V7:Disconnect()
              J7.connections[Y7] = nil
              J7.caches[tostring(f7)] = nil
              break
            end
          end
        end
        local function f7()
          local Y7 = i[48](133339189, 0)
          local V7 = Y7
          local v7 = K7
          if v7 then
            return true
          end
          if not R7() then
            return false
          end
          v7 = not r7 or not r7.channelFolder
          if v7 then
            return false
          end
          local R7, l7 = ipairs, r7
          Y7 = i:rQ((i:HQ(3856438295, V7) + i:HQ(3856438295, 29303905)) + (i:HQ(877058002, (i[79](V7, 29303905))) + i:HQ(3856438296, (i[48](V7, 29303905)))))
          for V7, V7 in R7(l7.channelFolder:GetChildren()) do
            if V7:IsA("RemoteEvent") then
              Z7(V7)
            end
          end
          v7 = nil
          v7, Y7 = r7, i[48](Y7, 312739093)
          R7, l7 = v7.channelFolder, function(Y7)
            if Y7:IsA("RemoteEvent") then
              Z7(Y7)
            end
          end
          R7.ChildAdded:Connect(l7)
          r7.routeRemote.OnClientEvent:Connect(function(R7)
            for Y7, V7 in ipairs(R7) do
              local R7, v7 = V7[1], tostring(V7[2])
              V7 = Q7:FindFirstChild(v7)
              if V7 then
                Y7 = R7 == "ListenerAdded"
                if Y7 then
                  local Y7 = r7.channelFolder:FindFirstChild(v7)
                  if Y7 and (Y7:IsA("RemoteEvent")) then
                    Z7(Y7)
                  end
                elseif R7 == "ListenerRemoved" then
                  y(v7)
                end
              end
            end
          end)
          K7 = true
          return true
        end
        local function y(r7)
          return J7.caches[r7]
        end
        local function r7(J7)
          local K7 = Q7:FindFirstChild(J7.plot)
          local R7 = K7 and (K7:FindFirstChild("AnimalPodiums"))
          K7 = R7 and R7:FindFirstChild(J7.slot)
          return K7 and K7:GetPivot().Position
        end
        local function J7(K7)
          local R7 = F.Character
          local Z7 = R7 and (R7:FindFirstChild("HumanoidRootPart") or R7:FindFirstChild("UpperTorso"))
          if not Z7 then
            return math.huge
          end
          R7 = r7(K7)
          if not R7 then
            return math.huge
          end
          return (Z7.Position - R7).Magnitude
        end
        local function r7()
          if not Q7 then
            return {}
          end
          local K7, R7, Z7 = {}, ipairs, i[93](Q7:GetChildren())
          for Y7, V7 in R7(i:gQ(Z7)) do
            Y7 = y(V7.Name)
            local y = Y7 and Y7.AnimalList
            Y7 = typeof(y) == "table"
            if Y7 then
              for Z7, Y7 in pairs(y) do
                local y = type(Y7) == "table"
                if y then
                  local y = Y7.Index
                  local Y7 = j7[y]
                  if Y7 then
                    table.insert(K7, {name = Y7.DisplayName or y, plot = V7.Name, slot = tostring(Z7), uid = V7.Name .. ("_" .. tostring(Z7))})
                  end
                end
              end
            end
          end
          q7 = K7
          R7 = q7
          return #R7
        end
        local function y(j7)
          local q7 = _7
          if q7[j7] then
            return
          end
          local K7, R7, Z7 = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}, false
          if getconnections then
            R7, Z7 = pcall(getconnections, j7.PromptButtonHoldBegan)
          else
          end
          if R7 and (type(Z7) == "table") then
            for R7, R7 in ipairs(Z7) do
              if type(R7.Function) == "function" then
                table.insert(K7.holdCallbacks, R7.Function)
              end
            end
          end
          local R7, Z7 = false
          if getconnections then
            R7, Z7 = pcall(getconnections, j7.Triggered)
          else
          end
          if R7 and (type(Z7) == "table") then
            for R7, R7 in ipairs(Z7) do
              if type(R7.Function) == "function" then
                table.insert(K7.triggerCallbacks, R7.Function)
              end
            end
          end
          q7 = (#K7.holdCallbacks > 0) or (#K7.triggerCallbacks > 0)
          if q7 then
            _7[j7] = K7
          end
        end
        local function j7(q7, K7)
          local R7 = i[48](72079176, 0)
          local Z7 = R7
          local Y7 = _7[q7]
          if not Y7 or not Y7.ready then
            return false
          end
          Y7.ready = false
          local V7 = (K7 and K7.name) or "Animal"
          g7.active = true
          g7.startTime = tick()
          g7.phase = "holding"
          g7.label = V7
          S7(false)
          R7, a = i:rQ((i:HQ(475981910, Z7) + i:HQ(475981910, 469746770)) + (i:HQ(3343003476, (i[79](Z7, 469746770))) + i:HQ(475981911, (i[48](Z7, 469746770))))), 0
          local Z7, v7 = C7
          v7, R7 = task, i[48](R7, 386982765)
          v7.spawn(function()
            a7.HOLD_MIN = j.Duration or a7.HOLD_MIN
            a7.HOLD_MAX = a7.HOLD_MIN + 1.3
            for R7, R7 in ipairs(Y7.holdCallbacks) do
              task.spawn(R7)
            end
            while true do
              local R7, v7 = tick() - g7.startTime, a7.HOLD_MIN
              if not (R7 < v7) then
                break
              end
              R7 = C7
              if Z7 ~= R7 then
                Y7.ready = true
                return
              end
              if not a7.AUTO_STEAL_ENABLED or not q7.Parent then
                break
              end
              v7 = tick() - g7.startTime
              a = math.clamp(v7 / a7.HOLD_MAX, 0, 1)
              task.wait(0.05)
            end
            g7.phase = "waitingRange"
            local R7, v7 = K7 and (J7(K7) <= a7.STEAL_RANGE), false
            while true do
              local l7 = (Z7 == C7) and a7.AUTO_STEAL_ENABLED
              if not (l7 and q7.Parent) then
                break
              end
              l7 = tick() - g7.startTime
              a = math.clamp(l7 / a7.HOLD_MAX, 0, 1)
              if l7 > a7.HOLD_MAX then
                break
              end
              if K7 and (J7(K7) <= a7.STEAL_RANGE) then
                if not R7 then
                  task.wait(a7.ENTRY_DELAY)
                end
                for J7, J7 in ipairs(Y7.triggerCallbacks) do
                  task.spawn(J7)
                end
                v7 = true
                break
              end
              task.wait(0.05)
            end
            R7 = C7
            if Z7 ~= R7 then
              Y7.ready = true
              return
            end
            if v7 then
              g7.totalSteals = g7.totalSteals + 1
              g7.lastResult = "Stole " .. V7
              g7.phase = "success"
              S7(true)
            else
              g7.failedSteals = g7.failedSteals + 1
              g7.lastResult = "Missed window: " .. V7
              g7.phase = "failed"
            end
            g7.active = false
            g7.lastResultTime = tick()
            a = 1
            task.wait(a7.COOLDOWN)
            a = 0
            Y7.ready = true
          end)
          return true
        end
        local function J7(q7, K7)
          if not q7 or not q7.Parent then
            return false
          end
          y(q7)
          return j7(q7, K7)
        end
        local y, j7, q7 = {busy = false, active = false, progress = 0, isStealing = false, currentTarget = nil, totalSteals = 0, failedSteals = 0, lastResult = "", generation = 0, phase = "idle", startTime = 0, data = {}}, {RADIUS = 65, HOLD_MIN = 1.3, HOLD_MAX = 2.6, NEAR_TARGET_RANGE = 20, ENTRY_DELAY = 0.3, FIRE_RANGE = 12, COOLDOWN = 0.45}, {prompt = nil, radius = 0, expiresAt = 0}
        local function K7(R7)
          local Z7 = math.max(0, tonumber(R7) or j7.RADIUS)
          if (((q7.expiresAt > tick()) and (q7.radius == Z7)) and q7.prompt) and q7.prompt.Parent then
            return q7.prompt
          end
          R7 = F.Character
          local Y7 = R7 and ((R7:FindFirstChild("HumanoidRootPart") or R7:FindFirstChild("UpperTorso")) or R7:FindFirstChild("Torso"))
          if not Y7 then
            return nil
          end
          local V7, v7 = math.huge, Z7 * Z7
          R7 = nil
          for l7, m7 in ipairs(Q7:GetChildren()) do
            l7 = m7:FindFirstChild("PlotSign")
            local P7 = l7 and (l7:FindFirstChild("YourBase"))
            if m7:IsA("Model") and not ((P7 and P7:IsA("BillboardGui")) and P7.Enabled) then
              l7 = m7:FindFirstChild("AnimalPodiums")
              if l7 then
                for m7, P7 in ipairs(l7:GetChildren()) do
                  m7 = P7:FindFirstChild("Base") and P7.Base:FindFirstChild("Spawn")
                  if m7 then
                    P7 = m7.Position - Y7.Position
                    local Y7 = P7:Dot(P7)
                    if (Y7 <= v7) and (Y7 < V7) then
                      local v7 = A7(m7)
                      if v7 then
                        V7, R7 = Y7, v7
                      else
                      end
                    else
                    end
                  else
                  end
                end
              else
              end
            else
            end
          end
          q7.prompt = R7
          q7.radius = Z7
          q7.expiresAt = tick() + 0.12
          return R7
        end
        function _G.__CrystalAutoGrabTargetInRadius(q7)
          return K7(q7 or 65) ~= nil
        end
        local function q7(A7)
          local R7 = i[48](174457579, 0)
          local Z7 = R7
          local Y7 = F.Character
          R7 = i[48](Z7, 216601337)
          Z7 = Y7 and ((Y7:FindFirstChild("HumanoidRootPart") or Y7:FindFirstChild("UpperTorso")) or Y7:FindFirstChild("Torso"))
          if not Z7 then
            return math.huge
          end
          R7 = i:rQ((i:HQ(1001710522, R7) + i:HQ(1001710522, 285540182)) + (i:HQ(3293256775, (i[79](R7, 285540182))) + i:HQ(3293256773, (i[89](R7, 285540182)))))
          Y7 = A7.Parent
          Y7 = if Y7 and Y7:IsA("Attachment") then Y7.Parent else Y7
          if Y7 and (Y7:IsA("BasePart")) then
            return (Y7.Position - Z7.Position).Magnitude
          end
          local R7, Y7 = pcall(function()
            return A7.Parent and A7.Parent.WorldPosition
          end)
          if R7 and Y7 then
            return (Y7 - Z7.Position).Magnitude
          end
          return math.huge
        end
        local function A7(R7)
          local Z7 = y.data[R7]
          if Z7 then
            return Z7
          end
          Z7 = {hold = {}, trigger = {}, ready = true}
          if getconnections then
            for Y7, Y7 in ipairs(getconnections(R7.PromptButtonHoldBegan)) do
              if Y7.Function then
                table.insert(Z7.hold, Y7.Function)
              end
            end
            for Y7, Y7 in ipairs(getconnections(R7.Triggered)) do
              if Y7.Function then
                table.insert(Z7.trigger, Y7.Function)
              end
            end
          end
          y.data[R7] = Z7
          return Z7
        end
        local function R7(Z7, Y7)
          if not Z7 or not Z7.Parent then
            return false
          end
          if F:GetAttribute("Stealing") == true then
            return false
          end
          local V7 = false
          for v7, v7 in ipairs(Y7.trigger) do
            V7 = if pcall(v7) then true else V7
          end
          V7 = if (not V7 and (F:GetAttribute("Stealing") ~= true)) and (typeof(fireproximityprompt) == "function") then pcall(fireproximityprompt, Z7) or V7 else V7
          if not V7 and (F:GetAttribute("Stealing") ~= true) then
            local v7 = i[48](153573357, 0)
            Y7 = v7
            local l7, m7 = pcall, i:HQ(143274916, Y7) + i:HQ(143274916, 128779297)
            v7, V7 = i:rQ(m7 + (i:HQ(4151692381, (i[79](Y7, 128779297))) + i:HQ(4151692379, (i[89](Y7, 128779297))))), l7(function()
              Z7:InputHoldBegin()
              task.wait(0.05)
              Z7:InputHoldEnd()
            end)
          else
          end
          return V7
        end
        local function Z7(Y7)
          local V7 = i[48](166203923, 0)
          local v7 = V7
          if (y.busy or not Y7) or not Y7.Parent then
            return
          end
          if F:GetAttribute("Stealing") == true then
            return
          end
          local l7 = A7(Y7)
          if #l7.trigger == 0 then
            y.data[Y7] = nil
            l7 = A7(Y7)
          else
          end
          if not l7.ready then
            return
          end
          l7.ready = false
          y.busy = true
          y.active = true
          y.isStealing = true
          y.startTime = tick()
          y.progress = 0
          y.phase = "holding"
          V7 = i:rQ((i:HQ(369135322, v7) + i:HQ(369135322, 152499606)) + (i:HQ(3556696652, (i[89](v7, 152499606))) + i:HQ(3925831975, (i[48](v7, 152499606)))))
          v7 = nil
          v7, V7 = y.generation + 1, i[48](V7, 351710061)
          y.generation = v7
          local A7 = y.generation
          S7(true)
          task.spawn(function()
            for V7, V7 in ipairs(l7.hold) do
              task.spawn(V7)
            end
            local V7 = tick()
            while y.busy and ((tick() - V7) < j7.HOLD_MIN) do
              if A7 ~= y.generation then
                return
              end
              y.progress = math.clamp((tick() - V7) / j7.HOLD_MIN, 0, 1)
              a = y.progress
              task.wait(0.05)
            end
            if A7 ~= y.generation then
              return
            end
            y.progress = 1
            a = 1
            y.phase = "waiting"
            local v7, m7 = q7(Y7) <= j7.FIRE_RANGE, false
            while (((A7 == y.generation) and Y7.Parent) and a7.AUTO_STEAL_ENABLED) and (F:GetAttribute("Stealing") ~= true) do
              y.progress = 1
              a = 1
              local P7 = q7(Y7)
              if (P7 > j7.NEAR_TARGET_RANGE) and ((tick() - V7) > j7.HOLD_MAX) then
                break
              end
              if P7 <= j7.FIRE_RANGE then
                if not v7 then
                  task.wait(j7.ENTRY_DELAY)
                  if ((A7 ~= y.generation) or not Y7.Parent) or (q7(Y7) > j7.FIRE_RANGE) then
                    task.wait(0.05)
                    continue
                  end
                end
                y.phase = "triggering"
                if not R7(Y7, l7) then
                  y.phase = "waiting"
                  task.wait(0.05)
                  continue
                end
                y.totalSteals = y.totalSteals + 1
                g7.totalSteals = g7.totalSteals + 1
                y.lastResult = "\226\156\133 ROBADO!"
                g7.lastResult = "Stole"
                y.isStealing = true
                y.phase = "success"
                m7 = true
                break
              end
              task.wait(0.05)
            end
            if A7 ~= y.generation then
              return
            end
            y.active = false
            y.isStealing = false
            y.busy = false
            l7.ready = true
            S7(false)
            if not m7 then
              y.failedSteals = y.failedSteals + 1
              y.lastResult = "\226\157\140 FALL\195\147"
              y.phase = "failed"
            end
            y.lastResultTime = tick()
            g7.lastResultTime = tick()
            task.wait(j7.COOLDOWN)
            if A7 ~= y.generation then
              return
            end
            y.progress = 0
            a = 0
            y.phase = "idle"
          end)
        end
        local j7, A7 = {busy = false, active = false, progress = 0, paused = false, pauseTime = nil, totalSteals = 0, failedSteals = 0, lastResult = "", generation = 0, phase = "idle", data = {}}, {STEAL_DURATION = 1.3, HOLD_TARGET = 0.8, TRIGGER_RADIUS = 10, PAUSE_TIMEOUT = 1.3, COOLDOWN = 0.05}
        local function R7(Y7)
          local V7 = j7.data[Y7]
          if V7 then
            return V7
          end
          V7 = {hold = {}, trigger = {}, ready = true}
          if getconnections then
            local v7 = i[48](295702766, 0)
            local l7 = v7
            local m7
            m7, v7 = pcall, i:rQ((i:HQ(872996564, l7) + i:HQ(872996564, 414695508)) + (i:HQ(3421970733, (i[79](l7, 414695508))) + i:HQ(3421970731, (i[89](l7, 414695508)))))
            m7(function()
              for v7, v7 in ipairs(getconnections(Y7.PromptButtonHoldBegan)) do
                if v7.Function then
                  table.insert(V7.hold, v7.Function)
                end
              end
              for v7, v7 in ipairs(getconnections(Y7.Triggered)) do
                if v7.Function then
                  table.insert(V7.trigger, v7.Function)
                end
              end
            end)
          end
          j7.data[Y7] = V7
          return V7
        end
        local function Y7(V7)
          local v7 = i[48](348259527, 0)
          local l7 = v7
          if (j7.busy or not V7) or not V7.Parent then
            return
          end
          if F:GetAttribute("Stealing") == true then
            return
          end
          local m7 = R7(V7)
          if not m7.ready then
            return
          end
          m7.ready = false
          j7.busy = true
          v7 = i:rQ((i:HQ(447170755, l7) + i:HQ(447170755, 262425574)) + (i:HQ(3400625786, (i[79](l7, 262425574))) + i:HQ(447170756, (i[48](l7, 262425574)))))
          j7.active = true
          j7.progress = 0
          v7 = i[48](v7, 48412346)
          j7.paused = false
          j7.pauseTime = nil
          j7.phase = "holding"
          j7.generation = j7.generation + 1
          local R7 = j7.generation
          local v7, l7, P7 = tick(), true, false
          g7.active = true
          g7.startTime = v7
          g7.phase = "holding"
          a = 0
          S7(true)
          task.spawn(function()
            for x7, H7 in ipairs(m7.hold) do
              local E7 = i[48](222012910, 0)
              x7 = E7
              local N7 = task
              E7 = i:rQ((i:HQ(280617060, x7) + i:HQ(280617060, 459014733)) + (i:HQ(4014350237, (i[79](x7, 459014733))) + i:HQ(4014350235, (i[89](x7, 459014733)))))
              E7 = i[48](E7, 206294475)
              N7.spawn(function()
                pcall(H7)
              end)
            end
            while true do
              local x7 = (((R7 == j7.generation) and a7.AUTO_STEAL_ENABLED) and (r == "v2")) and (F:GetAttribute("Stealing") ~= true)
              if not (x7 and V7.Parent) then
                break
              end
              x7 = j7.paused
              if x7 then
                local H7 = q7(V7) <= A7.TRIGGER_RADIUS
                if H7 then
                  j7.paused = false
                  j7.pauseTime = nil
                  j7.phase = "finishing"
                  v7 = tick() - (A7.HOLD_TARGET * A7.STEAL_DURATION)
                else
                  if not j7.pauseTime then
                    j7.pauseTime = tick()
                  elseif (tick() - j7.pauseTime) >= A7.PAUSE_TIMEOUT then
                    break
                  end
                  j7.progress = A7.HOLD_TARGET
                  a = j7.progress
                  g7.label = "80%"
                  task.wait(0.05)
                  continue
                end
              end
              x7 = math.clamp((tick() - v7) / A7.STEAL_DURATION, 0, 1)
              j7.progress = x7
              a = x7
              g7.label = math.floor((x7 * 100) + 0.5) .. "%"
              local q7 = l7 and (x7 >= A7.HOLD_TARGET)
              if q7 then
                l7 = false
                j7.paused = true
                j7.pauseTime = tick()
                j7.progress = A7.HOLD_TARGET
                a = j7.progress
                j7.phase = "waitingRange"
                g7.phase = "waitingRange"
              else
                local q7 = x7 >= 1
                if q7 then
                  j7.phase = "triggering"
                  for q7, V7 in ipairs(m7.trigger) do
                    local v7 = i[48](272759914, 0)
                    q7 = nil
                    q7, v7 = task, i[48](v7, 434630204)
                    q7.spawn(function()
                      pcall(V7)
                    end)
                  end
                  P7 = true
                  break
                end
              end
              task.wait(0.05)
            end
            if R7 ~= j7.generation then
              return
            end
            j7.active = false
            j7.busy = false
            j7.paused = false
            j7.pauseTime = nil
            m7.ready = true
            g7.active = false
            g7.lastResultTime = tick()
            S7(false)
            local q7 = P7
            if q7 then
              j7.totalSteals = j7.totalSteals + 1
              j7.lastResult = "Stole"
              j7.phase = "success"
              g7.totalSteals = g7.totalSteals + 1
              g7.lastResult = "Stole"
            else
              j7.failedSteals = j7.failedSteals + 1
              j7.lastResult = "Missed window"
              j7.phase = "failed"
              g7.failedSteals = g7.failedSteals + 1
              g7.lastResult = "Missed window"
            end
            task.wait(A7.COOLDOWN)
            q7 = R7 == j7.generation
            if q7 then
              j7.progress = 0
              a = 0
              j7.phase = "idle"
            end
          end)
        end
        local function q7()
          local A7 = i[48](117557437, 0)
          local R7 = A7
          local V7 = z7
          if V7 then
            return
          end
          local V7 = 0
          A7 = i:rQ(R7 + 469239268)
          R7 = nil
          R7, A7 = s.Heartbeat, i:rQ(A7 - 264987365)
          z7 = R7:Connect(function(A7)
            V7 += A7 or 0
            A7 = V7
            if A7 < 0.15 then
              return
            end
            V7 = 0
            if not a7.AUTO_STEAL_ENABLED then
              return
            end
            if F:GetAttribute("Stealing") == true then
              return
            end
            if _G.__CrystalAutoGrabRagdollBlocked == true then
              return
            end
            if ((g7.active or A.busy) or y.busy) or j7.busy then
              return
            end
            A7 = r
            if A7 == "v2" then
              local R7 = K7(j.Radius)
              if R7 then
                Y7(R7)
              end
              return
            end
            A7 = r
            if A7 == "v1" then
              local A7 = K7(j.Radius)
              if A7 then
                Z7(A7)
              end
              return
            end
          end)
        end
        function _G.CrystalAutoStealRunCycle(K7, A7)
          return J7(K7, A7)
        end
        local function J7()
          local K7 = e7
          if K7 then
            local A7 = e7
            for R7, Z7 in ipairs(A7) do
              local A7 = i[48](40689934, 0)
              R7 = A7
              local Y7
              Y7, A7 = pcall, i:rQ((i:HQ(648286404, R7) + i:HQ(648286404, 504765376)) + (i:HQ(3646680893, (i[79](R7, 504765376))) + i:HQ(3646680891, (i[89](R7, 504765376)))))
              Y7(function()
                Z7:Disconnect()
              end)
            end
          end
          e7 = {}
          K7 = X7
          if K7 then
            task.cancel(X7)
            X7 = nil
          end
        end
        local function K7(A7)
          local R7 = i[48](375481034, 0)
          local Z7 = R7
          J7()
          local J7 = A7 and (A7:FindFirstChildOfClass("Humanoid"))
          local Y7 = not J7
          R7 = i[48](Z7, 455170478)
          if Y7 then
            return
          end
          local Z7, Y7, V7
          Z7, Y7, V7, R7 = table.insert, e7, J7:GetPropertyChangedSignal("WalkSpeed"), i:rQ((i:HQ(1037351737, R7) + i:HQ(1037351737, 343826247)) + (i:HQ(3257615560, (i[79](R7, 343826247))) + i:HQ(3257615558, (i[89](R7, 343826247)))))
          Z7(Y7, V7:Connect(function()
            S7(J7.WalkSpeed < 22)
          end))
          local function J7(R7)
            local Z7 = i[48](346976849, 0)
            local Y7 = Z7
            if not R7:IsA("ProximityPrompt") then
              return
            end
            local V7 = table
            Z7 = i:rQ(Y7 + 358245727)
            Z7 = i:rQ(Z7 - 119092660)
            local Z7, Y7, v7 = V7.insert, e7, R7.PromptButtonHoldBegan
            local function V7(l7)
              local m7 = i[48](324533836, 0)
              local P7 = m7
              if l7 ~= n7 then
                return
              end
              S7(true)
              l7 = X7
              if l7 then
                task.cancel(X7)
              end
              l7 = task.delay
              m7 = i:rQ(P7 + 320032863)
              P7 = a7.HOLD_MAX + 0.5
              m7 = i:rQ(m7 - 313830455)
              X7 = l7(P7, function()
                S7(false)
              end)
            end
            Z7(Y7, v7:Connect(V7))
            table.insert(e7, R7.Triggered:Connect(function(X7)
              local R7 = i[48](168031449, 0)
              local Z7 = R7
              R7 = i:rQ(Z7 + 460069701)
              if X7 ~= n7 then
                return
              end
              Z7 = nil
              Z7, R7 = task.delay, i:rQ(R7 - 399025925)
              Z7(0.2, function()
                S7(false)
              end)
            end))
          end
          table.insert(e7, workspace.DescendantAdded:Connect(function(n7)
            task.defer(J7, n7)
          end))
          _G.__CrystalWalkDescendantsBatched(Q7, J7, function()
            return A7.Parent ~= nil
          end)
        end
        local function n7()
          local Q7 = i[48](420008770, 0)
          local J7 = Q7
          local e7 = k7
          if e7 then
            return
          end
          k7 = true
          e7 = task
          Q7 = i[48](J7, 323930456)
          J7 = e7.spawn
          Q7 = i:rQ((i:HQ(1170770608, Q7) + i:HQ(1170770608, 475832308)) + (i:HQ(3124196689, (i[79](Q7, 475832308))) + i:HQ(3124196687, (i[89](Q7, 475832308)))))
          J7(function()
            if f7() then
              if a7.AUTO_STEAL_ENABLED then
                r7()
              end
              while b.alive do
                task.wait(5)
                if not b.alive then
                  break
                end
                if a7.AUTO_STEAL_ENABLED then
                  r7()
                end
              end
            end
          end)
        end
        n7()
        if F.Character then
          task.defer(K7, F.Character)
        end
        _G.__CrystalTrackConn(F.CharacterAdded:Connect(function(Q7)
          task.wait(0.5)
          K7(Q7)
          Q7 = h["auto steal"]
          if Q7 then
            a7.AUTO_STEAL_ENABLED = false
            local Q7 = z7
            if Q7 then
              z7:Disconnect()
              z7 = nil
            end
            a7.AUTO_STEAL_ENABLED = true
            r7()
            q7()
          end
        end))
        w, U = _G, {GetMode = function()
          local Q7 = r
          return Q7
        end}
        U.SetMode, w.CrystalAutoGrab = function(Q7)
          if (Q7 ~= "v1") and (Q7 ~= "v2") then
            return false
          end
          r = Q7
          w7()
          return true
        end, U
        local function Q7()
          n7()
          r7()
          a7.AUTO_STEAL_ENABLED = true
          q7()
        end
        local function n7()
          C7 += 1
          local r7 = z7
          if r7 then
            z7:Disconnect()
            z7 = nil
          end
          a7.AUTO_STEAL_ENABLED = false
          g7.active = false
          g7.phase = "idle"
          S7(false)
          a, _7 = 0, {}
          A.busy = false
          A.data = {}
          if y then
            y.generation = y.generation + 1
            y.busy = false
            y.active = false
            y.isStealing = false
            y.progress = 0
            y.phase = "idle"
            y.data = {}
          end
          if j7 then
            j7.generation = j7.generation + 1
            j7.busy = false
            j7.active = false
            j7.paused = false
            j7.pauseTime = nil
            j7.progress = 0
            j7.phase = "idle"
            j7.data = {}
          end
        end
        autoStealDisableInternal = n7
        _G.__CrystalTrackConn(F.CharacterRemoving:Connect(n7))
        _G.__CrystalTrackStopper(n7)
        ;(function()
          local y = i[48](312585778, 0)
          local j7 = y
          local r7, J7, q7 = 0
          y = i:rQ(j7 + 296717440)
          local j7
          local _7, z7, K7, k7 = false, false, 0
          y = i:rQ(y - 63016584)
          k7 = function(y, e7)
            return ((y.PlatformStand or (e7 == Enum.HumanoidStateType.Physics)) or (e7 == Enum.HumanoidStateType.Ragdoll)) or (e7 == Enum.HumanoidStateType.FallingDown)
          end
          local function y(e7)
            if not e7 then
              return false
            end
            for X7, C7 in ipairs(e7:GetDescendants()) do
              if not C7:FindFirstAncestorOfClass("Tool") then
                X7 = C7.Name:lower()
                if ((X7:find("medusa") or X7:find("petrif")) or X7:find("gorgon")) or X7:find("stone") then
                  return true
                end
                for e7, X7 in pairs(C7:GetAttributes()) do
                  local C7 = tostring(e7):lower()
                  if X7 and (((C7:find("medusa") or C7:find("petrif")) or C7:find("gorgon")) or C7:find("stone")) then
                    return true
                  end
                end
              end
            end
            return false
          end
          local function e7(X7)
            local C7 = i[48](235122301, 0)
            X7 = C7
            r7 += 1
            local A7 = r7
            _G.__CrystalAutoGrabRagdollBlocked = true
            C7, z7 = i:rQ(X7 + 315970719), true
            n7()
            X7 = nil
            X7, C7 = task.delay, i:rQ(C7 - 271650709)
            X7(1, function()
              local X7 = r7
              if A7 ~= X7 then
                return
              end
              z7 = false
              if not h["auto steal"] then
                return
              end
              _G.__CrystalAutoGrabRagdollBlocked = false
              if not a7.AUTO_STEAL_ENABLED then
                Q7()
              end
            end)
          end
          local function X7(C7)
            local A7 = i[48](234351679, 0)
            local g7 = A7
            local R7 = J7
            if R7 then
              J7:Disconnect()
              J7 = nil
            end
            R7 = q7
            if R7 then
              q7:Disconnect()
              q7 = nil
            end
            R7 = j7
            if R7 then
              j7:Disconnect()
              j7 = nil
            end
            _7 = false
            A7, K7 = i:rQ(g7 + 12580786), 0
            local R7 = C7 and (C7:FindFirstChildOfClass("Humanoid") or C7:WaitForChild("Humanoid", 5))
            if not R7 then
              return
            end
            g7 = nil
            A7, g7 = i:rQ(A7 + 500542914), y(C7)
            if g7 then
              K7 = tick() + 5
            end
            j7 = C7.DescendantAdded:Connect(function(j7)
              if j7:FindFirstAncestorOfClass("Tool") then
                return
              end
              local A7 = j7.Name:lower()
              j7 = ((A7:find("medusa") or A7:find("petrif")) or A7:find("gorgon")) or A7:find("stone")
              if j7 then
                K7 = tick() + 5
              end
            end)
            local function j7(A7)
              local g7 = y(C7)
              if g7 then
                K7 = tick() + 5
              end
              g7 = k7(R7, A7)
              A7 = g7 and not _7
              if A7 then
                _7 = true
                e7(tick() <= K7)
              else
                local y = not g7
                if y then
                  _7 = false
                  local y = z7
                  if not y then
                    _G.__CrystalAutoGrabRagdollBlocked = false
                    if h["auto steal"] and not a7.AUTO_STEAL_ENABLED then
                      Q7()
                    end
                  end
                end
              end
            end
            J7 = R7.StateChanged:Connect(function(y, y)
              j7(y)
            end)
            q7 = R7:GetPropertyChangedSignal("PlatformStand"):Connect(function()
              j7(R7:GetState())
            end)
          end
          if F.Character then
            task.defer(X7, F.Character)
          end
          _G.__CrystalTrackConn(F.CharacterAdded:Connect(function(y)
            r7 += 1
            z7 = false
            _G.__CrystalAutoGrabRagdollBlocked = false
            X7(y)
          end))
        end)()
        l["auto steal"] = function(y)
          if y then
            if _G.__CrystalAutoGrabRagdollBlocked ~= true then
              Q7()
            end
          else
            n7()
          end
        end
        if h["auto steal"] then
          Q7()
        end
      end
      do
        do
          local function y(n7, Q7)
            if h[n7] == Q7 then
              return
            end
            h[n7] = Q7
            if l[n7] then
              l[n7](Q7)
            end
            if Y[n7] then
              Y[n7]()
            end
            w7()
          end
          local function n7()
            y("Autoplay", false)
          end
          local function y(Q7)
            local j7 = i[48](31388797, 0)
            local r7 = not Q7
            j7 = i:rQ(j7 + 263124515)
            if r7 then
              return
            end
            r7 = nil
            r7, j7 = os, i:rQ(j7 + 137801608)
            local j7 = r7.clock()
            if _G._CrystalHitCountdownLast and ((j7 - _G._CrystalHitCountdownLast) < 0.15) then
              return
            end
            _G._CrystalHitCountdownLast = j7
            local j7 = (_G._CrystalHitCountdownGen or 0) + 1
            _G._CrystalHitCountdownGen = j7
            _G._CrystalHitCountdownActive = true
            if _G._CrystalHitCountdownBB then
              local J7 = i[48](388795399, 0)
              r7 = nil
              r7, J7 = pcall, i:rQ(J7 + 486031702)
              r7(function()
                _G._CrystalHitCountdownBB:Destroy()
              end)
              _G._CrystalHitCountdownBB = nil
            end
            pcall(function()
              _G._CrystalShowStealCountdown = y
            end)
            r7 = ((Q7:FindFirstChild("LowerTorso") or Q7:FindFirstChild("Torso")) or Q7:FindFirstChild("UpperTorso")) or Q7:FindFirstChild("HumanoidRootPart")
            if not r7 then
              _G._CrystalHitCountdownActive = false
              return
            end
            local Q7 = Instance.new("BillboardGui")
            Q7.Name = "CrystalHitCountdown"
            Q7.Adornee = r7
            Q7.Size = UDim2.new(0, 120, 0, 56)
            Q7.StudsOffset = Vector3.new(0, 0.6, 0)
            Q7.AlwaysOnTop = true
            Q7.LightInfluence = 0
            Q7.Parent = (F and (F:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui"))) or game:GetService("CoreGui")
            _G._CrystalHitCountdownBB = Q7
            r7 = Instance.new("Frame", Q7)
            r7.Size = UDim2.new(1, 0, 1, 0)
            r7.BackgroundTransparency = 1
            r7.BorderSizePixel = 0
            local J7 = Instance.new("TextLabel", r7)
            J7.Size = UDim2.new(1, 0, 1, 0)
            J7.Position = UDim2.new(0, 0, 0, 6)
            J7.BackgroundTransparency = 1
            J7.Text = "3"
            J7.TextScaled = false
            J7.TextSize = 28
            J7.Font = Enum.Font.GothamBlack
            J7.TextColor3 = Color3.fromRGB(175, 180, 185)
            J7.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            J7.TextStrokeTransparency = 0
            J7.ZIndex = 10
            J7.TextTransparency = 1
            local function r7(q7, _7)
              J7.Text = q7
              if _7 then
                J7.TextColor3 = _7
              end
              _7 = ((q7 == "STEAL!") and 1) or 0.76
              for q7 = 0, 6, 1 do
                J7.TextTransparency = 1 - (q7 / 6)
                task.wait(0.02)
                if _G._CrystalHitCountdownGen ~= j7 then
                  return false
                end
              end
              task.wait(_7)
              if _G._CrystalHitCountdownGen ~= j7 then
                return false
              end
              for q7 = 0, 6, 1 do
                J7.TextTransparency = q7 / 6
                task.wait(0.02)
                if _G._CrystalHitCountdownGen ~= j7 then
                  return false
                end
              end
              return true
            end
            task.spawn(function()
              pcall(function()
                J7.TextStrokeTransparency = 0
                J7.TextColor3 = Color3.fromRGB(175, 180, 185)
                for q7 = 0, 24, 1 do
                  local _7 = 2.4 - ((2.4 * q7) / 24)
                  J7.Text = ((_7 <= 0.05) and "0") or string.format("%.1f", _7)
                  J7.TextTransparency = 0
                  for q7 = 0, 2, 1 do
                    J7.TextTransparency = 0.18 * q7
                    task.wait(0.02)
                    if _G._CrystalHitCountdownGen ~= j7 then
                      return
                    end
                  end
                  if _G._CrystalHitCountdownGen ~= j7 then
                    return
                  end
                  task.wait(0.08)
                  if _G._CrystalHitCountdownGen ~= j7 then
                    return
                  end
                end
                if not r7("STEAL!", Color3.fromRGB(175, 180, 185)) then
                  return
                end
              end)
              if _G._CrystalHitCountdownGen == j7 then
                local j7 = i[48](66341330, 0)
                local r7
                r7, j7 = pcall, i[48](j7, 485995424)
                r7(function()
                  Q7:Destroy()
                end)
                if _G._CrystalHitCountdownBB == Q7 then
                  _G._CrystalHitCountdownBB = nil
                end
                _G._CrystalHitCountdownActive = false
                r7 = (_G.__CrystalPendingAutoplayAfterCountdown == true) or (h.Autoplay == true)
                _G.__CrystalPendingAutoplayAfterCountdown = false
                if r7 and (h.Autoplay == true) then
                  local Q7, j7 = i[48](321849639, 0), task
                  local r7 = Q7
                  Q7 = i:rQ((i:HQ(598437070, r7) + i:HQ(598437070, 58578845)) + (i:HQ(3098093156, (i[79](r7, 58578845))) + i:HQ(598437071, (i[48](r7, 58578845)))))
                  r7 = j7.defer
                  Q7 = i[48](Q7, 526254318)
                  r7(function()
                    local Q7 = i[48](440222602, 0)
                    local j7 = Q7
                    if h.Autoplay ~= true then
                      return
                    end
                    local r7 = F:GetAttribute("Stealing")
                    Q7 = i:rQ((i:HQ(1490850597, j7) + i:HQ(1490850597, 222504991)) + (i:HQ(1313266102, (i[79](j7, 222504991))) + i:HQ(1490850598, (i[48](j7, 222504991)))))
                    if r7 == true then
                      return
                    end
                    j7 = nil
                    j7, Q7 = pcall, i[48](Q7, 366702697)
                    j7(function()
                      if type(_G.__CrystalStartAutoplay) == "function" then
                        _G.__CrystalStartAutoplay()
                      elseif l and (type(l.Autoplay) == "function") then
                        l.Autoplay(true)
                      end
                    end)
                  end)
                end
              end
            end)
          end
          local function Q7(j7)
            local r7 = i[48](413690002, 0)
            local J7 = j7:FindFirstChildOfClass("Humanoid")
            r7 = i:rQ(r7 + 216936038)
            if not J7 then
              return
            end
            local q7 = J7.Health
            r7 = i:rQ(r7 - 47514652)
            J7.HealthChanged:Connect(function(r7)
              local _7 = q7
              if r7 < _7 then
                local _7 = i[48](200093908, 0)
                local z7 = _7
                _7 = i:rQ(z7 + 79351568)
                n7()
                z7 = nil
                z7, _7 = pcall, i:rQ(_7 + 330710645)
                z7(function()
                  y(j7)
                end)
              end
              q7 = r7
            end)
            if J7.StateChanged then
              local r7 = i[48](56850016, 0)
              r7 = i[48](r7, 260792596)
              local q7
              q7, r7 = J7.StateChanged, i[48](r7, 436972097)
              q7:Connect(function(r7, q7)
                if ((q7 == Enum.HumanoidStateType.Physics) or (q7 == Enum.HumanoidStateType.Ragdoll)) or (q7 == Enum.HumanoidStateType.FallingDown) then
                  local q7 = i[48](70110080, 0)
                  r7 = q7
                  local _7
                  _7, q7 = pcall, i:rQ(r7 + 101702252)
                  _7(function()
                    y(j7)
                  end)
                end
              end)
            end
            pcall(function()
              local r7 = i[48](315944967, 0)
              local q7 = r7
              r7 = i:rQ(q7 + 105968442)
              q7 = nil
              q7, r7 = J7:GetPropertyChangedSignal("PlatformStand"), i:rQ(r7 + 129013836)
              q7:Connect(function()
                if J7.PlatformStand then
                  local r7 = i[48](508447481, 0)
                  local q7 = r7
                  local _7
                  _7, r7 = pcall, i:rQ((i:HQ(13906005, q7) + i:HQ(13906005, 63527602)) + (i:HQ(4267155286, (i[79](q7, 63527602))) + i:HQ(13906006, (i[48](q7, 63527602)))))
                  _7(function()
                    y(j7)
                  end)
                end
              end)
            end)
            local function y()
              n7()
            end
            J7.Died:Connect(y)
          end
          if F.Character then
            Q7(F.Character)
          end
          _G.__CrystalTrackConn(F.CharacterAdded:Connect(function(y)
            if y:WaitForChild("Humanoid", 5) then
              n7()
              Q7(y)
            else
              task.wait(0.5)
              n7()
              Q7(y)
            end
          end))
        end
        do
          local y = {generation = 0, animationConn = nil, animate = nil, disabledByUs = false}
          local function n7()
            y.generation = y.generation + 1
            if y.animationConn then
              y.animationConn:Disconnect()
              y.animationConn = nil
            end
          end
          local function Q7(j7)
            local r7 = y.animate
            local J7 = y.disabledByUs
            y.animate = nil
            y.disabledByUs = false
            if ((r7 and r7.Parent) and J7) and (j7 or not h.Unwalk) then
              local j7 = i[48](217342350, 0)
              local J7 = j7
              local q7
              q7, j7 = pcall, i:rQ(J7 + 253000219)
              q7(function()
                r7.Disabled = false
              end)
            end
          end
          local function j7(r7)
            local J7 = i[48](454500190, 0)
            local q7 = J7
            J7 = i:rQ(q7 + 245981876)
            local _7, z7 = y.animate, y.disabledByUs
            J7 = i:rQ(J7 + 58238396)
            n7()
            if not h.Unwalk or (r7 ~= F.Character) then
              return
            end
            local J7 = y.generation
            local K7 = r7:FindFirstChildOfClass("Humanoid") or r7:WaitForChild("Humanoid", 5)
            q7 = r7:FindFirstChild("Animate") or r7:WaitForChild("Animate", 5)
            if ((not K7 or not q7) or (J7 ~= y.generation)) or not h.Unwalk then
              return
            end
            y.animate = q7
            y.disabledByUs = ((_7 == q7) and z7) or (q7:IsA("LocalScript") and not q7.Disabled)
            if q7:IsA("LocalScript") then
              q7.Disabled = true
            end
            local function q7()
              if (((J7 ~= y.generation) or not h.Unwalk) or (r7 ~= F.Character)) or (K7.Parent ~= r7) then
                return
              end
              for r7, _7 in ipairs(K7:GetPlayingAnimationTracks()) do
                local z7 = i[48](183497008, 0)
                r7 = z7
                local k7
                k7, z7 = pcall, i:rQ((i:HQ(472289962, r7) + i:HQ(472289962, 515331566)) + (i:HQ(3822677335, (i[79](r7, 515331566))) + i:HQ(3822677333, (i[89](r7, 515331566)))))
                k7(function()
                  _7:Stop(0)
                end)
              end
            end
            y.animationConn = K7.AnimationPlayed:Connect(function(r7)
              local _7 = i[48](99906252, 0)
              local z7 = _7
              _7 = i[48](z7, 224131213)
              if (J7 ~= y.generation) or not h.Unwalk then
                return
              end
              z7 = nil
              z7, _7 = pcall, i:rQ((i:HQ(506778086, _7) + i:HQ(506778086, 302949513)) + (i:HQ(3281411124, (i[79](_7, 302949513))) + i:HQ(506778087, (i[48](_7, 302949513)))))
              z7(function()
                r7:Stop(0)
              end)
            end)
            q7()
          end
          l.Unwalk = function(y)
            if y then
              j7(F.Character)
            else
              n7()
              Q7(false)
            end
          end
          _G.__CrystalTrackStopper(function()
            n7()
            Q7(true)
          end)
          _G.__CrystalTrackConn(F.CharacterAdded:Connect(function(y)
            local n7 = i[48](253552596, 0)
            local Q7 = n7
            local r7 = h.Unwalk
            n7 = i:rQ((i:HQ(547300054, Q7) + i:HQ(547300054, 472296860)) + (i:HQ(3747667243, (i[79](Q7, 472296860))) + i:HQ(3747667241, (i[89](Q7, 472296860)))))
            if not r7 then
              return
            end
            Q7 = nil
            Q7, n7 = task, i[48](n7, 402665081)
            Q7.defer(function()
              j7(y)
            end)
          end))
          if h.Unwalk then
            task.defer(function()
              j7(F.Character)
            end)
          end
        end
        do
          local y
          local n7 = false
          local function Q7()
            local j7 = F.Character
            if not j7 then
              return nil
            end
            local r7 = j7:FindFirstChildOfClass("Tool")
            if r7 and r7.Name:lower():find("bat") then
              return r7
            end
            r7 = F:FindFirstChild("Backpack")
            if r7 then
              local J7 = j7:FindFirstChildOfClass("Humanoid")
              for q7, _7 in ipairs(r7:GetChildren()) do
                if _7:IsA("Tool") and _7.Name:lower():find("bat") then
                  if J7 then
                    local r7 = i[48](28423805, 0)
                    q7 = r7
                    local z7
                    z7, r7 = pcall, i:rQ((i:HQ(403337938, q7) + i:HQ(403337938, 40567350)) + (i:HQ(3891629359, (i[79](q7, 40567350))) + i:HQ(3891629357, (i[89](q7, 40567350)))))
                    z7(function()
                      J7:EquipTool(_7)
                    end)
                  end
                  return j7:FindFirstChild(_7.Name) or _7
                end
              end
            end
            return nil
          end
          local function j7(r7)
            local J7, q7 = math.huge
            for _7, z7 in ipairs(I:GetPlayers()) do
              if (z7 ~= F) and z7.Character then
                local K7, k7 = z7.Character:FindFirstChild("HumanoidRootPart"), z7.Character:FindFirstChildOfClass("Humanoid")
                if (K7 and k7) and (k7.Health > 0) then
                  _7 = (r7.Position - K7.Position).Magnitude
                  if _7 < J7 then
                    J7, q7 = _7, K7
                  else
                  end
                else
                end
              else
              end
            end
            return q7, J7
          end
          local function r7()
            local J7 = v or not h["Ragdoll Counter"]
            if J7 then
              return
            end
            J7 = F.Character
            local q7 = J7 and (J7:FindFirstChildOfClass("Humanoid"))
            local _7 = J7 and (J7:FindFirstChild("HumanoidRootPart"))
            if ((not J7 or not q7) or not _7) or (q7.Health <= 0) then
              return
            end
            local z7, K7 = j7(_7)
            if z7 and (K7 <= 4) then
              local j7 = Vector3.new(z7.Position.X, _7.Position.Y, z7.Position.Z)
              J7 = (j7 - _7.Position).Magnitude
              if J7 > 0.01 then
                local z7 = i[48](510912132, 0)
                local K7 = z7
                local k7, e7 = pcall, i:rQ(J7)
                z7 = i:rQ((i:HQ(236204589, 4294967295) + K7) + (i:HQ(3668840992, e7) + i:HQ(3668840992, (i[100](e7)))))
                k7(function()
                  q7.AutoRotate = false
                  _7.CFrame = CFrame.lookAt(_7.Position, j7)
                end)
              end
            end
            local j7 = Q7()
            if j7 then
              pcall(function()
                j7:Activate()
              end)
              local Q7 = j7:FindFirstChildWhichIsA("RemoteEvent", true)
              if Q7 then
                local j7 = i[48](460049140, 0)
                J7 = nil
                J7, j7 = pcall, i[48](j7, 80117864)
                J7(function()
                  Q7:FireServer()
                end)
              end
            end
            task.defer(function()
              if q7.Parent then
                q7.AutoRotate = true
              end
            end)
          end
          local function Q7()
            local j7 = i[48](103668838, 0)
            local J7 = j7
            local q7 = y
            if q7 then
              return
            end
            j7 = i[48](J7, 114411207)
            J7 = F.Character
            j7 = i:rQ((i:HQ(49260120, j7) + i:HQ(49260120, 436190550)) + (i:HQ(4196447056, (i[79](j7, 436190550))) + i:HQ(49260121, (i[48](j7, 436190550)))))
            if not J7 then
              return
            end
            local j7 = J7:FindFirstChildOfClass("Humanoid")
            q7 = J7:FindFirstChild("HumanoidRootPart")
            if not j7 or not q7 then
              return
            end
            y = {}
            J7, q7 = pcall(function()
              local _7 = i[48](54084361, 0)
              local z7 = _7
              _7 = i[48](z7, 294685789)
              z7 = j7.StateChanged
              _7 = i:rQ((i:HQ(102138636, _7) + i:HQ(102138636, 339044703)) + (i:HQ(4090690024, (i[79](_7, 339044703))) + i:HQ(102138637, (i[48](_7, 339044703)))))
              local function _7(K7, k7)
                K7 = v or not h["Ragdoll Counter"]
                if K7 then
                  return
                end
                K7 = ((k7 == Enum.HumanoidStateType.Physics) or (k7 == Enum.HumanoidStateType.Ragdoll)) or (k7 == Enum.HumanoidStateType.FallingDown)
                k7 = K7 and not n7
                if k7 then
                  local k7 = i[48](169871705, 0)
                  local e7 = k7
                  k7, n7 = i[48](e7, 63733605), true
                  e7 = nil
                  e7, k7 = pcall, i:rQ((i:HQ(470504289, k7) + i:HQ(470504289, 13006845)) + (i:HQ(3353958718, (i[79](k7, 13006845))) + i:HQ(470504290, (i[48](k7, 13006845)))))
                  e7(function()
                    r7()
                  end)
                else
                  local k7 = not K7 and n7
                  if k7 then
                    n7 = false
                  end
                end
              end
              return z7:Connect(_7)
            end)
            local _7 = J7 and q7
            if _7 then
              table.insert(y, q7)
            end
            J7, q7 = pcall(function()
              local z7 = i[48](97215207, 0)
              local K7 = z7
              z7 = i:rQ(K7 + 622997)
              K7 = j7:GetPropertyChangedSignal("PlatformStand")
              z7 = i:rQ(z7 + 75624631)
              local function z7()
                local k7 = v or not h["Ragdoll Counter"]
                if k7 then
                  return
                end
                k7 = j7.PlatformStand and not n7
                if k7 then
                  local v = i[48](381965991, 0)
                  local k7 = v
                  v, n7 = i:rQ((i:HQ(961062056, k7) + i:HQ(961062056, 112971292)) + (i:HQ(3333905241, (i[79](k7, 112971292))) + i:HQ(3333905239, (i[89](k7, 112971292))))), true
                  v = i[48](v, 196036834)
                  pcall(function()
                    r7()
                  end)
                else
                  local v = not j7.PlatformStand
                  if v then
                    n7 = false
                  end
                end
              end
              return K7:Connect(z7)
            end)
            _7 = J7 and q7
            if _7 then
              table.insert(y, q7)
            end
          end
          local function v()
            local j7 = y
            if j7 then
              local j7 = y
              for r7, J7 in ipairs(j7) do
                local j7 = i[48](186398649, 0)
                r7 = j7
                local q7
                q7, j7 = pcall, i:rQ(r7 + 441993419)
                q7(function()
                  J7:Disconnect()
                end)
              end
              y = nil
            end
            n7 = false
          end
          l["Ragdoll Counter"] = function(y)
            if y then
              Q7()
            else
              v()
            end
          end
          _G.__CrystalTrackConn(F.CharacterAdded:Connect(function()
            task.wait(0.5)
            n7 = false
            if h["Ragdoll Counter"] then
              v()
              Q7()
            end
          end))
          if h["Ragdoll Counter"] then
            Q7()
          end
        end
        do
          local y, v, n7, Q7 = false, 0, false, {}
          local function j7()
            local r7 = F.Character
            if not r7 then
              return nil
            end
            for J7, J7 in ipairs(r7:GetChildren()) do
              if J7:IsA("Tool") and ((J7.Name:lower():find("medusa") or J7.Name:lower():find("head")) or J7.Name:lower():find("stone")) then
                return J7
              end
            end
            r7 = F:FindFirstChild("Backpack")
            if r7 then
              for J7, J7 in ipairs(r7:GetChildren()) do
                if J7:IsA("Tool") and ((J7.Name:lower():find("medusa") or J7.Name:lower():find("head")) or J7.Name:lower():find("stone")) then
                  return J7
                end
              end
            end
            return nil
          end
          local function r7()
            local J7, q7 = i[48](317233711, 0), n7
            if not q7 then
              return
            end
            q7 = y
            if q7 then
              return
            end
            q7 = tick() - v
            if q7 < 25 then
              return
            end
            q7 = F.Character
            J7 = i:rQ(J7 + 222273681)
            if not q7 then
              return
            end
            y = true
            local J7 = j7()
            local j7 = not J7
            if j7 then
              y = false
              return
            end
            if J7.Parent ~= q7 then
              local _7 = q7:FindFirstChildOfClass("Humanoid")
              if _7 then
                local q7 = i[48](413610977, 0)
                j7 = q7
                local z7
                z7, q7 = pcall, i:rQ((i:HQ(2347055570, j7) + i:HQ(2347055570, 535045032)) + (i:HQ(3895823452, (i[79](j7, 535045032))) + i:HQ(2347055571, (i[48](j7, 535045032)))))
                z7(function()
                  _7:EquipTool(J7)
                end)
              end
              task.wait(0.05)
            end
            pcall(function()
              J7:Activate()
            end)
            v, y = tick(), false
          end
          local function y(v)
            local j7 = i[48](106759697, 0)
            local J7 = j7
            local q7 = v:GetPropertyChangedSignal("Anchored")
            j7 = i:rQ(J7 + 20999757)
            local function j7()
              local J7 = (n7 and v.Anchored) and (v.Transparency == 1)
              if J7 then
                r7()
              end
            end
            return q7:Connect(j7)
          end
          local function v(j7)
            local r7, J7 = i[48](73958033, 0), pairs
            r7 = i:rQ((i:HQ(1982932081, r7) + i:HQ(1982932081, 239324942)) + (i:HQ(2312035216, (i[79](r7, 239324942))) + i:HQ(2312035214, (i[89](r7, 239324942)))))
            local q7 = Q7
            for _7, z7 in J7(q7) do
              local K7 = i[48](343685641, 0)
              _7 = nil
              _7, K7 = pcall, i[48](K7, 128585586)
              _7(function()
                z7:Disconnect()
              end)
            end
            Q7 = {}
            if not j7 then
              return
            end
            q7, J7 = ipairs, i[93](j7:GetDescendants())
            r7 = i[48](r7, 510205045)
            for r7, _7 in q7(i:gQ(J7)) do
              r7 = _7:IsA("BasePart")
              if r7 then
                table.insert(Q7, y(_7))
              end
            end
            table.insert(Q7, j7.DescendantAdded:Connect(function(j7)
              local r7 = j7:IsA("BasePart")
              if r7 then
                table.insert(Q7, y(j7))
              end
            end))
          end
          local function y()
            n7 = true
            if F.Character then
              v(F.Character)
            end
          end
          local function j7()
            n7 = false
            local r7 = Q7
            for J7, q7 in pairs(r7) do
              local r7 = i[48](377571753, 0)
              J7 = r7
              local _7
              _7, r7 = pcall, i:rQ((i:HQ(130175599, J7) + i:HQ(130175599, 486819076)) + (i:HQ(4164791698, (i[79](J7, 486819076))) + i:HQ(4164791696, (i[89](J7, 486819076)))))
              _7(function()
                q7:Disconnect()
              end)
            end
            Q7 = {}
          end
          _G.__CrystalTrackStopper(j7)
          l["Medusa Counter"] = function(Q7)
            if Q7 then
              y()
            else
              j7()
            end
          end
          _G.__CrystalTrackConn(F.CharacterAdded:Connect(function(Q7)
            task.wait(0.5)
            local j7 = n7
            if j7 then
              v(Q7)
            end
          end))
          if h["Medusa Counter"] then
            y()
          end
        end
        do
          local y = F
          local function v()
            local n7 = y.Character
            if n7 then
              local Q7 = n7:FindFirstChildOfClass("Tool")
              if Q7 then
                local n7 = Q7.Name:lower()
                if n7:find("bat", 1, true) or n7:find("slap", 1, true) then
                  return Q7
                end
              end
              Q7 = y:FindFirstChildOfClass("Backpack")
              if Q7 then
                for y, n7 in ipairs(Q7:GetChildren()) do
                  if n7:IsA("Tool") then
                    y = n7.Name:lower()
                    if y:find("bat", 1, true) or y:find("slap", 1, true) then
                      return n7
                    end
                  end
                end
              end
            end
            return nil
          end
          local y
          _G.__CrystalAceNormalAimbot = _G.__CrystalAceNormalAimbot or {target = nil, swingCooldown = false, nextSwingAt = 0}
          local function n7(Q7)
            if not Q7 then
              return nil
            end
            local j7, r7, J7 = Q7.CFrame, pcall(Q7.GetRenderCFrame, Q7)
            return if r7 and J7 then J7 else j7
          end
          function _cypherStartFollowing(Q7)
            local j7 = i[48](131968412, 0)
            local r7 = j7
            Q7 = Q7 or F.Character
            local J7, q7 = Q7 and (Q7:FindFirstChildOfClass("Humanoid")), Q7 and (Q7:FindFirstChild("HumanoidRootPart"))
            if not J7 or not q7 then
              return
            end
            q7 = y
            if q7 then
              y:Disconnect()
              y = nil
            end
            q7 = _G
            j7 = i:rQ((i:HQ(2657977919, r7) + i:HQ(2657977919, 6557264)) + (i:HQ(1636989378, (i[79](r7, 6557264))) + i:HQ(1636989376, (i[89](r7, 6557264)))))
            q7.__CrystalAceNormalAimbot.nextSwingAt = 0
            _G.__CrystalAceNormalAimbot.swingCooldown = false
            j7 = i[48](j7, 288017711)
            J7.AutoRotate = false
            q7 = Q7:FindFirstChildOfClass("Tool") or v()
            if q7 and (q7.Parent ~= Q7) then
              pcall(J7.EquipTool, J7, q7)
            end
            y = s.RenderStepped:Connect(function()
              if not h.Aimbot then
                return
              end
              local Q7 = F.Character
              if not Q7 then
                return
              end
              local j7, r7 = Q7:FindFirstChild("HumanoidRootPart"), Q7:FindFirstChildOfClass("Humanoid")
              if not j7 or not r7 then
                return
              end
              if r7.AutoRotate then
                r7.AutoRotate = false
              end
              local J7 = Q7:FindFirstChildOfClass("Tool") or v()
              if J7 and (J7.Parent ~= Q7) then
                pcall(r7.EquipTool, r7, J7)
              end
              Q7 = nil
              if _G.__CrystalTPBatGetMarkerCFrame then
                local q7, _7 = pcall(_G.__CrystalTPBatGetMarkerCFrame)
                Q7 = if q7 then _7 else Q7
              else
              end
              local q7, _7
              r7 = _G.__CrystalGetVisualEnemy and _G.__CrystalGetVisualEnemy()
              if (r7 and (r7 ~= F)) and r7.Character then
                local z7, K7 = r7.Character:FindFirstChild("HumanoidRootPart"), r7.Character:FindFirstChildOfClass("Humanoid")
                if (z7 and K7) and (K7.Health > 0) then
                  q7, _7 = z7, n7(z7)
                else
                end
              else
              end
              if not Q7 and (not q7 or not _7) then
                return
              end
              _G.__CrystalAceNormalAimbot.target = Q7 or q7
              local n7, q7 = j7.Position, (Q7 or _7).Position
              Q7 = q7 - n7
              local _7, z7, K7 = Vector3.new(Q7.X, 0, Q7.Z), tonumber(n.CypherAimbotApproachSpeed) or 59, Vector3.zero
              K7 = if _7.Magnitude >= 0.01 then _7.Unit * z7 else K7
              Q7 = (q7.Y - n7.Y) * 19.5
              Q7 = math.clamp(Q7, -70, 110)
              j7.AssemblyLinearVelocity = Vector3.new(K7.X, Q7, K7.Z)
              if (q7 - n7).Magnitude > 0.1 then
                Q7 = CFrame.lookAt(n7, q7)
                r7 = j7.CFrame:Inverse() * Q7
                local n7, Q7, q7 = r7:ToEulerAnglesXYZ()
                n7, Q7, q7 = math.clamp(n7, -2.5, 2.5), math.clamp(Q7, -2.5, 2.5), math.clamp(q7, -2.5, 2.5)
                j7.AssemblyAngularVelocity = j7.CFrame:VectorToWorldSpace(Vector3.new(n7 * 42, Q7 * 42, q7 * 42))
              end
              r7 = tick()
              if J7 and (r7 >= (_G.__CrystalAceNormalAimbot.nextSwingAt or 0)) then
                _G.__CrystalAceNormalAimbot.nextSwingAt = r7 + 0.08
                pcall(J7.Activate, J7)
              end
            end)
          end
          function _cypherStop()
            local n7 = y
            if n7 then
              y:Disconnect()
              y = nil
            end
            if _G.__CrystalAceNormalAimbot then
              _G.__CrystalAceNormalAimbot.target = nil
              _G.__CrystalAceNormalAimbot.swingCooldown = false
              _G.__CrystalAceNormalAimbot.nextSwingAt = 0
            end
            n7 = F.Character
            local y = n7 and (n7:FindFirstChild("HumanoidRootPart"))
            if y then
              y.AssemblyLinearVelocity = Vector3.zero
              y.AssemblyAngularVelocity = Vector3.zero
            end
            y = n7 and (n7:FindFirstChildOfClass("Humanoid"))
            if y then
              y.AutoRotate = true
            end
          end
          _G.__CrystalTrackConn(F.CharacterAdded:Connect(function(y)
            task.wait(0.5)
            if h.Aimbot then
              _cypherStartFollowing(y)
            end
          end))
          l.Aimbot = function(y)
            if y then
              local y = i[48](9093254, 0)
              local n7 = y
              local Q7
              Q7, y = _G, i[48](n7, 243010339)
              n7 = Q7.__stopSpeedBoost
              y = i:rQ((i:HQ(303550798, y) + i:HQ(303550798, 226715972)) + (i:HQ(3687865700, (i[79](y, 226715972))) + i:HQ(303550799, (i[48](y, 226715972)))))
              if n7 then
                _G.__stopSpeedBoost()
              end
              if autoplayActive or h.Autoplay then
                _G.__stopAutoplay()
              end
              O7("Aimbot")
              if _G.__deactivateBatExclusive then
                _G.__deactivateBatExclusive("Aimbot")
              end
              _G.__checkAndAutoDrop(function()
                local y = F.Character
                if y then
                  _cypherStartFollowing(y)
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
              local y = workspace:FindFirstChild("PredictionSphere")
              if y then
                y:Destroy()
              end
            end)
            local y, n7, Q7 = {targetPlayer = nil, lastTargetPos = nil, targetVelocity = Vector3.zero, smoothedVelocity = Vector3.zero, velocityHistory = {}, accelerationHistory = {}, aerialVelocityHistory = {}, verticalVelocityHistory = {}, previousDirection = nil, lastDirectionChangeTime = 0, airborneTime = 0, lastYVelocity = 0, lastJumpTime = 0, lastActivationTime = 0, currentPing = 0.1, realPingMs = 0}, {FOLLOW_SPEED = 59, ACTIVATE_DISTANCE = 13, MIN_FOLLOW_DISTANCE = 1, PREDICTION_TIME = 0.22, PREDICT_AHEAD = 3, MAX_VELOCITY_CHANGE = 150, VELOCITY_SMOOTHING = 0.2, MAX_HORIZONTAL_VELOCITY = 80, SERVER_TICKRATE = 0.016666666666666666, MIN_PING_COMPENSATION = 0.03, MAX_PING_COMPENSATION = 0.25, ACCELERATION_PREDICTION_WEIGHT = 0.3, DIRECTION_CHANGE_DETECTION_TIME = 0.12, QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5, GRAVITY = 196.2, AIR_CONTROL_FACTOR = 0.8, AERIAL_VELOCITY_DECAY = 0.95, MIN_AIRBORNE_TIME = 0.08, FALLING_SPEED_THRESHOLD = -15}
            local function j7(r7)
              if #r7 == 0 then
                return Vector3.zero
              end
              local J7 = Vector3.zero
              for q7, q7 in ipairs(r7) do
                J7 += q7
              end
              return J7 / #r7
            end
            local function r7(J7, q7, _7)
              table.insert(J7, q7)
              if #J7 > _7 then
                table.remove(J7, 1)
              end
            end
            local function J7()
              y.targetPlayer = nil
              y.lastTargetPos = nil
              y.targetVelocity = Vector3.zero
              y.smoothedVelocity = Vector3.zero
              y.velocityHistory = {}
              y.accelerationHistory = {}
              y.aerialVelocityHistory = {}
              y.verticalVelocityHistory = {}
              y.previousDirection = nil
              y.airborneTime = 0
              y.lastYVelocity = 0
            end
            local function q7(_7)
              local z7, K7 = math.huge
              for k7, e7 in ipairs(I:GetPlayers()) do
                if (e7 ~= F) and e7.Character then
                  local X7, C7 = e7.Character:FindFirstChild("HumanoidRootPart"), e7.Character:FindFirstChildOfClass("Humanoid")
                  if (X7 and C7) and (C7.Health > 0) then
                    k7 = (_7.Position - X7.Position).Magnitude
                    if k7 < z7 then
                      z7, K7 = k7, e7
                    else
                    end
                  else
                  end
                else
                end
              end
              return K7
            end
            local function _7(z7, K7)
              if K7.Magnitude < 0.01 then
                return
              end
              local k7 = z7.CFrame.LookVector:Cross(K7.Unit)
              K7 = math.asin(math.clamp(k7.Magnitude, -1, 1))
              z7.AssemblyAngularVelocity = ((k7.Magnitude > 0.01) and ((k7.Unit * K7) * 80)) or Vector3.zero
            end
            local function z7()
              local K7 = _G.__AkatsukiTPBatGetMarkerCFrame or _G.__CrystalTPBatGetMarkerCFrame
              if type(K7) ~= "function" then
                return nil
              end
              local k7, e7 = pcall(K7)
              return (k7 and e7) or nil
            end
            local function K7()
              local k7 = i[48](181068788, 0)
              local e7 = k7
              local X7
              X7, k7 = pcall, i:rQ(e7 + 463772152)
              local k7, e7 = X7(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
              end)
              if k7 and (type(e7) == "number") then
                y.realPingMs = math.floor(e7)
              end
              y.currentPing = math.clamp(y.realPingMs / 1000, n7.MIN_PING_COMPENSATION, n7.MAX_PING_COMPENSATION)
            end
            task.spawn(function()
              while _G.__CRYSTAL_STATE == b do
                pcall(K7)
                task.wait(0.5)
              end
            end)
            local function K7()
              local k7 = Q7
              if k7 then
                Q7:Disconnect()
                Q7 = nil
              end
              k7 = F.Character
              local e7, X7 = k7 and (k7:FindFirstChildOfClass("Humanoid")), k7 and (k7:FindFirstChild("HumanoidRootPart"))
              if e7 then
                e7.AutoRotate = true
              end
              if X7 then
                X7.AssemblyAngularVelocity = Vector3.zero
              end
              J7()
              y.lastActivationTime = 0
            end
            local function k7(e7)
              local X7 = i[48](139703105, 0)
              local C7 = X7
              e7 = e7 or F.Character
              local a7 = e7 and (e7:FindFirstChildOfClass("Humanoid"))
              local A7 = e7 and (e7:FindFirstChild("HumanoidRootPart"))
              local g7 = not a7 or not A7
              if g7 then
                return
              end
              K7()
              X7 = i:rQ(C7 + 40833408)
              a7.AutoRotate = false
              local g7 = v()
              C7 = g7 and (g7.Parent ~= e7)
              if C7 then
                pcall(a7.EquipTool, a7, g7)
              end
              X7 = i:rQ(X7 + 24096660)
              Q7 = s.RenderStepped:Connect(function(Q7)
                if not h.Aimbot then
                  K7()
                  return
                end
                local e7 = F.Character
                local X7, C7 = e7 and (e7:FindFirstChild("HumanoidRootPart")), e7 and (e7:FindFirstChildOfClass("Humanoid"))
                if (not X7 or not C7) or (C7.Health <= 0) then
                  return
                end
                C7.AutoRotate = false
                A7, a7 = X7, C7
                g7 = e7:FindFirstChildOfClass("Tool") or v()
                X7 = g7 and (g7.Parent ~= e7)
                if X7 then
                  pcall(C7.EquipTool, C7, g7)
                end
                e7 = z7()
                if e7 then
                  X7 = e7.Position - A7.Position
                  C7 = X7.Magnitude > 0.1
                  if C7 then
                    _7(A7, X7)
                  end
                  local v = X7.Magnitude > n7.MIN_FOLLOW_DISTANCE
                  if v then
                    local v, z7 = tonumber(n.CypherAimbotApproachSpeed) or n7.FOLLOW_SPEED, A7
                    z7.AssemblyLinearVelocity = X7.Unit * math.clamp(v, 1, 120)
                  else
                    local v = A7
                    v.AssemblyLinearVelocity = Vector3.zero
                  end
                  return
                end
                y.targetPlayer = q7(A7)
                C7 = y.targetPlayer and y.targetPlayer.Character
                X7, e7 = C7 and (C7:FindFirstChild("HumanoidRootPart")), C7 and (C7:FindFirstChildOfClass("Humanoid"))
                if (not X7 or not e7) or (e7.Health <= 0) then
                  J7()
                  return
                end
                local v, J7 = X7.Position, math.max(Q7, 0.004166666666666667)
                if y.lastTargetPos then
                  C7 = (v - y.lastTargetPos) / J7
                  X7 = C7 - y.targetVelocity
                  C7 = if X7.Magnitude > n7.MAX_VELOCITY_CHANGE then y.targetVelocity + (X7.Unit * n7.MAX_VELOCITY_CHANGE) else C7
                  Q7 = Vector3.new(C7.X, 0, C7.Z)
                  if Q7.Magnitude > n7.MAX_HORIZONTAL_VELOCITY then
                    Q7 = Q7.Unit * n7.MAX_HORIZONTAL_VELOCITY
                    C7 = Vector3.new(Q7.X, C7.Y, Q7.Z)
                  else
                  end
                  r7(y.accelerationHistory, (C7 - y.targetVelocity) / J7, 4)
                  r7(y.velocityHistory, C7, 8)
                  r7(y.verticalVelocityHistory, C7.Y, 5)
                  y.targetVelocity = C7
                  y.smoothedVelocity = y.smoothedVelocity:Lerp(C7, n7.VELOCITY_SMOOTHING)
                end
                y.lastTargetPos = v
                X7 = e7.FloorMaterial == Enum.Material.Air
                y.airborneTime = (X7 and (y.airborneTime + J7)) or 0
                if X7 and (y.airborneTime >= n7.MIN_AIRBORNE_TIME) then
                  r7(y.aerialVelocityHistory, y.targetVelocity, 6)
                elseif not X7 then
                  y.aerialVelocityHistory = {}
                end
                e7 = y.smoothedVelocity
                if X7 and (#y.aerialVelocityHistory > 0) then
                  C7 = j7(y.aerialVelocityHistory)
                  e7 = Vector3.new(C7.X, y.targetVelocity.Y, C7.Z) * n7.AIR_CONTROL_FACTOR
                else
                end
                C7, Q7 = false, Vector3.new(y.targetVelocity.X, 0, y.targetVelocity.Z)
                if Q7.Magnitude > 5 then
                  J7 = Q7.Unit
                  if y.previousDirection and (y.previousDirection:Dot(J7) < 0.5) then
                    C7 = (tick() - y.lastDirectionChangeTime) < n7.DIRECTION_CHANGE_DETECTION_TIME
                    y.lastDirectionChangeTime = tick()
                  else
                  end
                  y.previousDirection = J7
                else
                end
                J7 = y.currentPing + n7.SERVER_TICKRATE
                J7 = if C7 then J7 * n7.QUICK_DIRECTION_CHANGE_MULTIPLIER else J7
                Q7, C7 = (v + (e7 * J7)) + ((j7(y.accelerationHistory) * n7.ACCELERATION_PREDICTION_WEIGHT) * ((J7 * J7) * 0.5)), n7.PREDICTION_TIME * 1.1
                Q7 = if X7 then (Q7 + (e7 * C7)) + Vector3.new(0, ((-0.5 * n7.GRAVITY) * C7) * C7, 0) else Q7 + (e7 * C7)
                C7 = Vector3.new(e7.X, 0, e7.Z)
                J7 = (if C7.Magnitude > 1 then Q7 + (C7.Unit * n7.PREDICT_AHEAD) else Q7) - A7.Position
                _7(A7, J7)
                X7 = ((v - A7.Position).Magnitude <= n7.ACTIVATE_DISTANCE) and ((tick() - y.lastActivationTime) >= 0.3)
                if X7 then
                  Q7 = g7
                  if Q7 then
                    pcall(g7.Activate, g7)
                  end
                  y.lastActivationTime = tick()
                end
                Q7 = J7.Magnitude > n7.MIN_FOLLOW_DISTANCE
                if Q7 then
                  X7, e7 = math.clamp((tonumber(n.CypherAimbotApproachSpeed) or n7.FOLLOW_SPEED) or 59, 1, 120), A7
                  e7.AssemblyLinearVelocity = J7.Unit * X7
                else
                  C7 = A7
                  C7.AssemblyLinearVelocity = Vector3.new(0, A7.AssemblyLinearVelocity.Y * 0.5, 0)
                end
              end)
            end
            _cypherStartFollowing = k7
            _cypherStop = K7
            l.Aimbot = function(y)
              if y then
                local y = i[48](99703389, 0)
                local v = y
                if _G.__stopSpeedBoost then
                  _G.__stopSpeedBoost()
                end
                if autoplayActive or h.Autoplay then
                  _G.__stopAutoplay()
                end
                O7("Aimbot")
                if _G.__deactivateBatExclusive then
                  _G.__deactivateBatExclusive("Aimbot")
                end
                local n7 = _G
                y = i[48](v, 435104951)
                v = n7.__checkAndAutoDrop
                y = i:rQ((i:HQ(458891821, y) + i:HQ(458891821, 11143589)) + (i:HQ(3377183654, (i[79](y, 11143589))) + i:HQ(458891822, (i[48](y, 11143589)))))
                v(function()
                  k7(F.Character)
                end)
              else
                K7()
                if _G.__refreshSpeedBoost then
                  _G.__refreshSpeedBoost()
                end
              end
            end
            _G.__CrystalTrackStopper(K7)
          end
          if h.Aimbot then
            task.defer(function()
              if h.Aimbot and l.Aimbot then
                l.Aimbot(true)
              end
            end)
          end
        end
        _G.__aimbotMode = ((_G.__aimbotMode == "bypass") and "bypass") or "normal"
        T, U = _G, ((_G.__aimbotMode == "bypass") and 2) or 1
        T.__aimbotVersion = U
        do
          local y, T = {}, {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}
          local function v()
            local n7 = F.Character
            if not n7 then
              return nil
            end
            for Q7, j7 in ipairs(T) do
              Q7 = n7:FindFirstChild(j7)
              if Q7 and (Q7:IsA("Tool")) then
                return Q7
              end
            end
            local Q7 = F:FindFirstChildOfClass("Backpack")
            if Q7 then
              for j7, r7 in ipairs(T) do
                local T = Q7:FindFirstChild(r7)
                if T and (T:IsA("Tool")) then
                  local J7 = n7:FindFirstChildOfClass("Humanoid")
                  if J7 then
                    local q7 = i[48](164162660, 0)
                    r7 = q7
                    j7 = nil
                    j7, q7 = pcall, i:rQ(r7 + 40063882)
                    j7(function()
                      J7:EquipTool(T)
                    end)
                  end
                  return T
                end
              end
            end
            for T, j7 in ipairs(n7:GetChildren()) do
              if j7:IsA("Tool") then
                T = j7.Name:lower()
                if T:find("bat", 1, true) or T:find("slap", 1, true) then
                  return j7
                end
              end
            end
            if Q7 then
              for T, n7 in ipairs(Q7:GetChildren()) do
                if n7:IsA("Tool") then
                  T = n7.Name:lower()
                  if T:find("bat", 1, true) or T:find("slap", 1, true) then
                    return n7
                  end
                end
              end
            end
            return nil
          end
          local T = false
          local function n7()
            local Q7 = i[48](201724694, 0)
            local j7 = Q7
            local r7 = T
            Q7 = i:rQ(j7 + 299747369)
            if r7 then
              return
            end
            T = true
            Q7 = i:rQ(Q7 + 122223618)
            pcall(function()
              local Q7 = i[48](174512867, 0)
              Q7 = i:rQ(Q7 + 535724436)
              local j7 = F.Character
              if not j7 then
                return
              end
              local r7 = v()
              if not r7 then
                return
              end
              local J7 = r7.Parent
              Q7 = i:rQ(Q7 - 531769278)
              if J7 ~= j7 then
                local Q7 = j7:FindFirstChildOfClass("Humanoid")
                if Q7 then
                  pcall(function()
                    Q7:EquipTool(r7)
                  end)
                end
              end
              pcall(function()
                r7:Activate()
              end)
              local Q7 = r7:FindFirstChild("Handle")
              if not (Q7 and firetouchinterest) then
                return
              end
              J7 = j7:FindFirstChild("HumanoidRootPart")
              if not J7 then
                return
              end
              for r7, q7 in ipairs(I:GetPlayers()) do
                if (q7 ~= F) and q7.Character then
                  j7 = q7.Character:FindFirstChild("HumanoidRootPart")
                  if j7 and ((j7.Position - J7.Position).Magnitude <= 8) then
                    for j7, j7 in ipairs(q7.Character:GetChildren()) do
                      if j7:IsA("BasePart") then
                        local J7 = i[48](507849404, 0)
                        r7 = nil
                        r7, J7 = pcall, i[48](J7, 129201202)
                        r7(function()
                          firetouchinterest(Q7, j7, 0)
                          firetouchinterest(Q7, j7, 1)
                        end)
                      end
                    end
                  end
                end
              end
            end)
            task.delay(0.15, function()
              T = false
            end)
          end
          local T
          local Q7 = Vector3.zero
          local function j7()
            T = nil
            Q7 = Vector3.zero
          end
          local function r7()
            local J7 = F.Character and F.Character:FindFirstChild("HumanoidRootPart")
            if not J7 then
              j7()
              return nil, math.huge
            end
            local q7, _7, z7 = math.huge, ipairs, i[93](I:GetPlayers())
            local K7
            local k7
            for e7, X7 in _7(i:gQ(z7)) do
              e7 = (X7 ~= F) and X7.Character
              if e7 then
                local z7, e7 = X7.Character:FindFirstChild("HumanoidRootPart"), X7.Character:FindFirstChildOfClass("Humanoid")
                local X7 = (z7 and e7) and (e7.Health > 0)
                if X7 then
                  e7 = (z7.Position - J7.Position).Magnitude
                  K7 = if z7 == T then e7 else K7
                  if e7 < q7 then
                    q7, k7 = e7, z7
                  else
                  end
                else
                end
              else
              end
            end
            _7 = K7 and (q7 >= (K7 - math.max(2, K7 * 0.2)))
            if _7 then
              k7, q7 = T, K7
            else
            end
            _7 = k7 ~= T
            if _7 then
              Q7, T = Vector3.zero, k7
            end
            return k7, q7
          end
          local function T()
            local J7 = F.Character and F.Character:FindFirstChild("HumanoidRootPart")
            if not J7 then
              return nil
            end
            local q7, _7 = math.huge
            for z7, K7 in ipairs(I:GetPlayers()) do
              if (K7 ~= F) and K7.Character then
                local k7, e7 = K7.Character:FindFirstChild("HumanoidRootPart"), K7.Character:FindFirstChildOfClass("Humanoid")
                if (k7 and e7) and (e7.Health > 0) then
                  z7 = (k7.Position - J7.Position).Magnitude
                  if z7 < q7 then
                    q7, _7 = z7, k7
                  else
                  end
                else
                end
              else
              end
            end
            return _7
          end
          local function J7(q7, _7)
            local z7 = q7.AssemblyLinearVelocity
            local K7 = Vector3.new(z7.X, 0, z7.Z)
            local k7 = Vector3.new((if K7.Magnitude > 100 then K7.Unit * 100 else K7).X, math.clamp(z7.Y, -70, 70), (if K7.Magnitude > 100 then K7.Unit * 100 else K7).Z)
            z7 = Q7:Dot(k7) < 0
            if z7 then
              Q7 = k7
            end
            z7 = Q7
            Q7 = z7:Lerp(k7, 1 - math.exp(-18 * math.max(_7, 0)))
            _7 = Q7 * 0.08
            return q7.Position + (if _7.Magnitude > 5 then _7.Unit * 5 else _7)
          end
          local function Q7(q7, _7, z7)
            local K7 = _7 - q7.Position
            _7 = Vector3.new(K7.X, 0, K7.Z)
            if _7.Magnitude <= 0.01 then
              q7.AssemblyAngularVelocity = Vector3.zero
              return
            end
            K7 = q7.CFrame.LookVector
            local k7, e7 = math.atan2(-K7.X, -K7.Z), math.atan2(-_7.X, -_7.Z)
            _7, K7 = math.atan2(math.sin(e7 - k7), math.cos(e7 - k7)), math.min(16, 1 / math.max(z7, 0.004166666666666667))
            q7.AssemblyAngularVelocity = Vector3.new(0, math.clamp(_7 * K7, -28, 28), 0)
          end
          local function q7(_7, z7, K7, k7)
            local e7 = z7 - _7.Position
            z7 = Vector3.new(e7.X, 0, e7.Z)
            e7 = math.max(0, z7.Magnitude - 2.8)
            _7 = math.min(math.clamp(K7, 1, 200), e7 * 9, e7 / math.max(k7, 0.004166666666666667))
            return ((z7.Magnitude > 0.01) and (z7.Unit * _7)) or Vector3.zero
          end
          local function _7(z7, K7)
            K7.AutoRotate = true
            z7.AssemblyAngularVelocity = Vector3.zero
            z7.AssemblyLinearVelocity = Vector3.new(0, z7.AssemblyLinearVelocity.Y, 0)
            K7:Move(Vector3.zero, false)
          end
          local function z7(K7)
            local k7 = K7 and (K7:FindFirstChild("CrystalAimbotMoveVelocity"))
            if k7 and (k7:IsA("LinearVelocity")) then
              k7:Destroy()
            end
            k7 = K7 and (K7:FindFirstChild("CrystalAimbotMoveAttachment"))
            if k7 and (k7:IsA("Attachment")) then
              k7:Destroy()
            end
          end
          function _G._CrystalClearAimbotMover()
            local K7 = F.Character
            z7(K7 and K7:FindFirstChild("HumanoidRootPart"))
          end
          local function K7()
            local k7 = (J == "Lagger") or C
            if k7 then
              return (tonumber(n and n.AimbotSpeedLagger) or tonumber(n and n.LaggerBoost)) or 40
            end
            k7 = (J == "Desync") or (((type(J) == "string") and (J ~= "Normal")) and (J ~= "Lagger"))
            if k7 then
              local C = tonumber(n and n.AimbotSpeedCustom)
              if C then
                return C
              end
            end
            return (tonumber(n and n.AimbotSpeed) or tonumber(n and n.CypherAimbotApproachSpeed)) or 59
          end
          local function C()
            return h.Aimbot == true
          end
          local function k7()
            return _G.__aimbotMode == "bypass"
          end
          local function e7()
            local X7 = i[48](274467391, 0)
            local C7 = X7
            j7()
            X7 = i:rQ((i:HQ(1166951306, C7) + i:HQ(1166951306, 496347816)) + (i:HQ(3128015991, (i[79](C7, 496347816))) + i:HQ(3128015989, (i[89](C7, 496347816)))))
            if y.aimbot then
              y.aimbot:Disconnect()
              y.aimbot = nil
            end
            X7 = i[48](X7, 129263664)
            if y.aimbotNew then
              y.aimbotNew:Disconnect()
              y.aimbotNew = nil
            end
            _G.__CrystalNormalAimbot = _G.__CrystalNormalAimbot or {target = nil, swingCooldown = false}
            local X7 = _G.__CrystalNormalAimbot
            X7.target = nil
            X7.swingCooldown = false
            X7.equipped = false
            C7 = F.Character and F.Character:FindFirstChildOfClass("Humanoid")
            if C7 then
              C7.AutoRotate = false
            end
            y.aimbot = s.RenderStepped:Connect(function()
              if not C() or k7() then
                return
              end
              local C7 = F.Character
              local a7 = C7 and (C7:FindFirstChildOfClass("Humanoid"))
              local A7 = C7 and (C7:FindFirstChild("HumanoidRootPart"))
              if (not A7 or not a7) or (a7.Health <= 0) then
                return
              end
              if not X7.equipped then
                X7.equipped = true
                if not C7:FindFirstChildOfClass("Tool") then
                  local g7 = v()
                  if g7 then
                    local R7 = i[48](238247055, 0)
                    local S7
                    S7, R7 = pcall, i:rQ(R7 + 173480904)
                    S7(function()
                      a7:EquipTool(g7)
                    end)
                  end
                end
              end
              local g7 = T()
              X7.target = g7
              if not g7 then
                a7.AutoRotate = true
                return
              end
              local T = g7.AssemblyLinearVelocity or Vector3.zero
              local R7 = (g7.Position + (T * math.clamp(T.Magnitude / 130, 0.05, 0.15))) + Vector3.new(0, 1, 0)
              a7.AutoRotate = false
              T = R7 - A7.Position
              g7 = Vector3.new(T.X, 0, T.Z)
              if (T.Magnitude > 0.01) and (g7.Magnitude > 0.01) then
                local T = (((math.deg(math.atan2(-g7.X, -g7.Z)) - A7.Orientation.Y) + 180) % 360) - 180
                local S7 = math.clamp(math.rad(T) * 285, -28, 28)
                A7.AssemblyAngularVelocity = Vector3.new(0, S7, 0)
                T = ((R7 + (g7.Unit * -2.8)) + Vector3.new(0, 4.75, 0)) - A7.Position
                local g7 = Vector3.new(T.X, 0, T.Z)
                S7 = K7() or 59
                local Z7, f7 = ((g7.Magnitude > 0.2) and (g7.Unit * S7)) or Vector3.zero, math.clamp(T.Y * 2.5, -52, 52)
                A7.AssemblyLinearVelocity = Vector3.new(Z7.X, f7, Z7.Z)
                if g7.Magnitude > 0.5 then
                  pcall(function()
                    a7:Move(g7.Unit, false)
                  end)
                end
              end
              local T = C7:FindFirstChildOfClass("Tool") or v()
              if (T and (T.Parent == C7)) and not X7.swingCooldown then
                local C7 = i[48](532174919, 0)
                X7.swingCooldown = true
                C7 = i:rQ(C7 + 108758388)
                R7 = nil
                R7, C7 = pcall, i:rQ(C7 + 132581365)
                R7(function()
                  T:Activate()
                end)
                task.delay(0.08, function()
                  if _G.__CrystalNormalAimbot == X7 then
                    X7.swingCooldown = false
                  end
                end)
              end
            end)
            y.aimbotNew = s.RenderStepped:Connect(function(T)
              if not C() or not k7() then
                return
              end
              local k7 = F.Character
              if not k7 then
                return
              end
              local C7, a7 = k7:FindFirstChild("HumanoidRootPart"), k7:FindFirstChildOfClass("Humanoid")
              if (not C7 or not a7) or (a7.Health <= 0) then
                return
              end
              if not k7:FindFirstChildOfClass("Tool") then
                local A7 = v()
                if A7 then
                  local v = i[48](422548340, 0)
                  local g7 = v
                  local R7
                  R7, v = pcall, i:rQ(g7 + 286407018)
                  R7(function()
                    a7:EquipTool(A7)
                  end)
                end
              end
              local v, A7 = r7()
              X7.target = v
              if not v then
                _7(C7, a7)
                return
              end
              a7.AutoRotate = false
              k7 = J7(v, T)
              local r7, J7 = q7(C7, k7, K7() or 59, T), (k7.Y + 3.7) - C7.Position.Y
              v = math.clamp(J7 * 8, -60, 80)
              C7.AssemblyLinearVelocity = Vector3.new(r7.X, v, r7.Z)
              Q7(C7, k7, T)
              a7:Move(Vector3.zero, false)
              if A7 <= 8 then
                n7()
              end
            end)
          end
          local function T()
            j7()
            if y.aimbot then
              y.aimbot:Disconnect()
              y.aimbot = nil
            end
            if y.aimbotNew then
              y.aimbotNew:Disconnect()
              y.aimbotNew = nil
            end
            if _G.__CrystalNormalAimbot then
              _G.__CrystalNormalAimbot.target = nil
              _G.__CrystalNormalAimbot.swingCooldown = false
              _G.__CrystalNormalAimbot.equipped = false
            end
            local y = F.Character
            if not y then
              return
            end
            local v, n7 = y:FindFirstChild("HumanoidRootPart"), y:FindFirstChildOfClass("Humanoid")
            if n7 then
              local Q7 = i[48](90066026, 0)
              y = Q7
              n7.AutoRotate = true
              n7.PlatformStand = false
              Q7 = i:rQ(y + 314158669)
              local j7
              j7, Q7 = pcall, i:rQ(Q7 - 146044430)
              j7(function()
                n7:Move(Vector3.zero, false)
              end)
            end
            if v then
              z7(v)
              v.AssemblyLinearVelocity = Vector3.zero
              v.AssemblyAngularVelocity = Vector3.zero
              y = v.CFrame.LookVector
              local n7 = Vector3.new(y.X, 0, y.Z)
              n7 = if n7.Magnitude < 0.01 then Vector3.new(0, 0, -1) else n7.Unit
              v.CFrame = CFrame.lookAt(v.Position, v.Position + n7)
            end
          end
          local y, v = {}, 0
          local function n7()
            local Q7 = i[48](308648208, 0)
            local j7 = Q7
            local r7 = F.Character
            local J7 = r7 and (r7:FindFirstChild("HumanoidRootPart"))
            local q7 = r7 and (r7:FindFirstChildOfClass("Humanoid"))
            if (not J7 or not q7) or (q7.Health <= 0) then
              return
            end
            q7 = tick()
            r7 = q7 - v
            if r7 < 0.08 then
              return
            end
            v = q7
            r7, q7 = J7.CFrame:ToEulerAnglesYXZ()
            Q7 = i[48](j7, 90296634)
            j7 = nil
            j7, Q7 = CFrame.new(J7.Position.X, -7, J7.Position.Z) * CFrame.Angles(0, q7, 0), i:rQ((i:HQ(345364359, Q7) + i:HQ(345364359, 313947031)) + (i:HQ(3949602938, (i[79](Q7, 313947031))) + i:HQ(3949602936, (i[89](Q7, 313947031)))))
            J7.CFrame = j7
            pcall(function()
              J7.AssemblyLinearVelocity = Vector3.zero
            end)
            pcall(function()
              J7.Velocity = Vector3.zero
            end)
          end
          local v = 0
          _G.__CrystalTrackConn(s.Heartbeat:Connect(function()
            local Q7, j7 = tick(), v
            if Q7 < j7 then
              return
            end
            v = Q7 + 0.1
            if h["Mirror TP Down"] ~= true then
              table.clear(y)
              return
            end
            if not C() then
              table.clear(y)
              return
            end
            Q7 = F.Character
            j7 = Q7 and (Q7:FindFirstChild("HumanoidRootPart"))
            if not j7 then
              return
            end
            for C, v in ipairs(I:GetPlayers()) do
              if (v ~= F) and v.Character then
                Q7, C = v.Character:FindFirstChild("HumanoidRootPart"), v.Character:FindFirstChildOfClass("Humanoid")
                if (Q7 and C) and (C.Health > 0) then
                  local C, r7 = Q7.Position.X - j7.Position.X, Q7.Position.Z - j7.Position.Z
                  if ((C * C) + (r7 * r7)) <= 64 then
                    local C, j7 = Q7.Position.Y, y[v.UserId]
                    if j7 and ((j7 - C) >= 3) then
                      pcall(n7)
                      table.clear(y)
                    end
                    y[v.UserId] = C
                  else
                    y[v.UserId] = nil
                  end
                end
              end
            end
          end))
          function _G.__CrystalSetAimbotMode(y)
            local C, v = ((tostring(y):lower() == "bypass") and "bypass") or "normal", h.Aimbot == true
            if v then
              T()
            end
            _G.__aimbotMode = C
            _G.__aimbotVersion = ((C == "bypass") and 2) or 1
            if type(_G.__CrystalRefreshAimbotModeUI) == "function" then
              pcall(_G.__CrystalRefreshAimbotModeUI, C)
            end
            if v then
              e7()
            end
            if w7 then
              pcall(w7)
            end
            return C
          end
          function _G.__CrystalGetAimbotMode()
            return ((_G.__aimbotMode == "bypass") and "bypass") or "normal"
          end
          function _G.__CrystalSetAimbotVersion(y)
            return _G.__CrystalSetAimbotMode(((tonumber(y) == 2) and "bypass") or "normal")
          end
          function _G.__CrystalGetAimbotVersion()
            return ((_G.__aimbotMode == "bypass") and 2) or 1
          end
          _cypherStartFollowing = e7
          _cypherStop = T
          l.Aimbot = function(y)
            if y then
              if _G.__stopSpeedBoost then
                _G.__stopSpeedBoost()
              end
              if autoplayActive or h.Autoplay then
                if _G.__stopAutoplay then
                  pcall(_G.__stopAutoplay)
                end
              end
              O7("Aimbot")
              if _G.__deactivateBatExclusive then
                _G.__deactivateBatExclusive("Aimbot")
              end
              if _G.__checkAndAutoDrop then
                local y = i[48](59208690, 0)
                local C = y
                local v = _G
                y = i:rQ((i:HQ(618295624, C) + i:HQ(618295624, 17137881)) + (i:HQ(3058376048, (i[79](C, 17137881))) + i:HQ(618295625, (i[48](C, 17137881)))))
                C = v.__checkAndAutoDrop
                y = i[48](y, 55743658)
                C(function()
                  e7()
                end)
              else
                e7()
              end
            else
              T()
              if _G.__refreshSpeedBoost then
                _G.__refreshSpeedBoost()
              end
            end
          end
          l["Mirror TP Down"] = function()
          end
          _G.__CrystalTrackStopper(T)
          _G.__CrystalTrackConn(F.CharacterAdded:Connect(function()
            task.wait(0.5)
            if h.Aimbot then
              e7()
            end
          end))
        end
        do
          local y, T, C = false, {}
          local v = workspace.CurrentCamera
          local n7 = Color3.fromRGB(139, 72, 246)
          local Q7 = Color3.fromRGB(48, 16, 92)
          local function j7(r7)
            if _G.__CrystalGuiTheme == "GUI 3" then
              return Color3.fromRGB(255, 45, 45), Color3.fromRGB(255, 45, 45)
            end
            if _G.__CrystalGuiTheme == "GUI 2" then
              return n7, n7
            end
            return (r7 or _G.__CrystalThemeAccent) or Color3.fromRGB(245, 245, 250), Color3.fromRGB(0, 0, 0)
          end
          local function r7()
            local J7 = i[48](266203057, 0)
            local q7 = J7
            local _7, z7 = j7()
            local K7 = {Tracer = Drawing.new("Line"), Highlight = Instance.new("Highlight"), Lines = {}}
            K7.Tracer.Color = z7
            K7.Tracer.Thickness = 3
            K7.Tracer.Transparency = 1
            K7.Tracer.ZIndex = 2
            K7.Highlight.Name = "ESP_Highlight"
            J7, K7.Highlight.FillColor = i:rQ(q7 + 370441027), _7
            K7.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
            K7.Highlight.FillTransparency = 0.12
            K7.Highlight.OutlineTransparency = 0.18
            K7.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            local J7
            q7, _7 = pcall(function()
              return game:GetService("CoreGui"):FindFirstChild("RobloxGui")
            end)
            if q7 and _7 then
              J7 = _7
            else
              J7 = F:FindFirstChildOfClass("PlayerGui")
            end
            if not J7 then
              J7 = game:GetService("CoreGui")
            else
            end
            q7 = pcall
            local function k7()
              K7.Highlight.Parent = J7
            end
            q7(k7)
            k7 = Instance.new("BillboardGui")
            k7.Name = "ESP_Name"
            k7.Size = UDim2.new(0, 170, 0, 28)
            k7.StudsOffset = Vector3.new(0, 1.3, 0)
            k7.AlwaysOnTop = true
            k7.Parent = J7
            q7 = Instance.new("TextLabel")
            q7.Size = UDim2.new(0, 170, 0, 28)
            q7.AnchorPoint = Vector2.new(0.5, 0)
            q7.Position = UDim2.new(0.5, 0, 0, 2)
            q7.BackgroundTransparency = 1
            q7.Text = tostring(currentPresetName or "")
            q7.TextColor3 = ((_G.__CrystalGuiTheme == "GUI 3") and Color3.fromRGB(255, 45, 45)) or (((_G.__CrystalGuiTheme == "GUI 2") and n7) or Color3.fromRGB(245, 245, 255))
            q7.TextSize = 15
            q7.Font = Enum.Font.GothamBold
            q7.TextStrokeColor3 = ((_G.__CrystalGuiTheme == "GUI 2") and Q7) or Color3.fromRGB(0, 0, 0)
            q7.TextStrokeTransparency = 0
            q7.TextXAlignment = Enum.TextXAlignment.Center
            q7.TextYAlignment = Enum.TextYAlignment.Center
            q7.ZIndex = 5
            q7.Parent = k7
            _7 = Instance.new("UIStroke")
            _7.Color = ((_G.__CrystalGuiTheme == "GUI 2") and Q7) or Color3.fromRGB(0, 0, 0)
            _7.Thickness = 2.2
            _7.Transparency = 0.12
            _7.Parent = q7
            for J7 = 1, 14, 1 do
              J7 = Drawing.new("Line")
              J7.Color = z7
              J7.Thickness = 2
              J7.Transparency = 1
              J7.ZIndex = 3
              table.insert(K7.Lines, J7)
            end
            K7.NameTag = k7
            K7.NameLabel = q7
            K7.NameOutline = _7
            return K7
          end
          function _G.__CrystalRefreshESPTheme(J7, q7)
            local _7, z7 = j7(J7)
            for K7, k7 in pairs(T) do
              if (type(k7) == "table") and k7.esp then
                local e7 = k7.esp
                if e7.Tracer then
                  local k7 = i[48](50944497, 0)
                  J7 = nil
                  J7, k7 = pcall, i:rQ(k7 + 478562160)
                  J7(function()
                    e7.Tracer.Color = z7
                  end)
                end
                if e7.Highlight then
                  e7.Highlight.FillColor = _7
                  e7.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
                end
                if e7.NameLabel then
                  K7, q7 = e7.NameLabel, ((_G.__CrystalGuiTheme == "GUI 3") and Color3.fromRGB(255, 45, 45)) or (((_G.__CrystalGuiTheme == "GUI 2") and n7) or Color3.fromRGB(245, 245, 255))
                  K7.TextColor3 = q7
                  e7.NameLabel.TextStrokeColor3 = ((_G.__CrystalGuiTheme == "GUI 2") and Q7) or Color3.fromRGB(0, 0, 0)
                end
                if e7.NameOutline then
                  e7.NameOutline.Color = ((_G.__CrystalGuiTheme == "GUI 2") and Q7) or Color3.fromRGB(0, 0, 0)
                end
                for J7, q7 in ipairs(e7.Lines or {}) do
                  local _7 = i[48](52613341, 0)
                  J7 = _7
                  local K7
                  K7, _7 = pcall, i:rQ(J7 + 233825270)
                  K7(function()
                    q7.Color = z7
                  end)
                end
              end
            end
          end
          local function J7(q7)
            local _7 = T[q7]
            if _7 then
              if _7.esp.Tracer then
                local z7 = i[48](438796299, 0)
                local K7
                K7, z7 = pcall, i:rQ(z7 + 486189829)
                K7(function()
                  _7.esp.Tracer:Remove()
                end)
              end
              if _7.esp.Highlight then
                local z7 = i[48](321004435, 0)
                local K7 = z7
                local k7
                k7, z7 = pcall, i:rQ((i:HQ(2497594669, K7) + i:HQ(2497594669, 90249776)) + (i:HQ(3594745254, (i[79](K7, 90249776))) + i:HQ(2497594670, (i[48](K7, 90249776)))))
                k7(function()
                  _7.esp.Highlight:Destroy()
                end)
              end
              if _7.esp.NameTag then
                pcall(function()
                  _7.esp.NameTag:Destroy()
                end)
              end
              for z7, z7 in ipairs(_7.esp.Lines) do
                pcall(function()
                  z7:Remove()
                end)
              end
              if _7.loopConn then
                pcall(function()
                  _7.loopConn:Disconnect()
                end)
              end
              T[q7] = nil
            end
          end
          local function q7(_7, z7)
            local K7 = y
            if not K7 then
              z7.Tracer.Visible = false
              z7.Highlight.Enabled = false
              for k7, k7 in ipairs(z7.Lines) do
                k7.Visible = false
              end
              return
            end
            K7 = _7.Character
            local k7, e7 = K7 and (K7:FindFirstChildOfClass("Humanoid")), K7 and ((((K7:FindFirstChild("HumanoidRootPart") or K7.PrimaryPart) or K7:FindFirstChild("UpperTorso")) or K7:FindFirstChild("Torso")) or K7:FindFirstChild("Head"))
            if (K7 and e7) and (not k7 or (k7.Health > 0)) then
              z7.Highlight.Adornee = K7
              z7.Highlight.Enabled = h["ESP Players"] or false
              local K7, K7 = v:WorldToViewportPoint(e7.Position)
              if K7 then
                z7.Tracer.Visible = false
              else
                for v, v in ipairs(z7.Lines) do
                  v.Visible = false
                end
              end
              if z7.NameTag and z7.NameLabel then
                local v = i[48](376807143, 0)
                K7 = nil
                K7, v = pcall, i:rQ(v + 101531815)
                K7(function()
                  z7.NameTag.Adornee = e7
                  z7.NameTag.Enabled = h["ESP Players"] or false
                  z7.NameLabel.Text = (_7.Name or _7.DisplayName) or ""
                  local v = _G.__CrystalGuiTheme == "GUI 2"
                  local _7, K7 = z7.NameLabel, ((_G.__CrystalGuiTheme == "GUI 3") and Color3.fromRGB(255, 45, 45)) or ((v and n7) or Color3.fromRGB(245, 245, 255))
                  _7.TextColor3 = K7
                  z7.NameLabel.TextStrokeColor3 = (v and Q7) or Color3.fromRGB(0, 0, 0)
                  if z7.NameOutline then
                    z7.NameOutline.Color = (v and Q7) or Color3.fromRGB(0, 0, 0)
                  end
                end)
              end
            else
              z7.Tracer.Visible = false
              z7.Highlight.Enabled = false
              z7.Highlight.Adornee = nil
              for v, v in ipairs(z7.Lines) do
                v.Visible = false
              end
              if z7.NameTag and z7.NameLabel then
                local v = i[48](432525465, 0)
                local n7 = v
                local Q7
                Q7, v = pcall, i:rQ((i:HQ(854455063, n7) + i:HQ(854455063, 500375415)) + (i:HQ(3440512234, (i[79](n7, 500375415))) + i:HQ(3440512232, (i[89](n7, 500375415)))))
                Q7(function()
                  z7.NameTag.Enabled = false
                end)
              end
            end
          end
          local function v(n7)
            if n7 == F then
              return
            end
            if T[n7] and T[n7].esp then
              if T[n7].esp.NameTag then
                local Q7 = i[48](55767553, 0)
                local _7 = Q7
                local z7
                z7, Q7 = pcall, i:rQ((i:HQ(2572575162, _7) + i:HQ(2572575162, 261357631)) + (i:HQ(3444784268, (i[79](_7, 261357631))) + i:HQ(2572575163, (i[48](_7, 261357631)))))
                z7(function()
                  T[n7].esp.NameTag.Enabled = h["ESP Players"] or false
                end)
              end
              return
            end
            J7(n7)
            T[n7] = {esp = r7()}
          end
          local function n7()
            local Q7, r7 = i[48](266504808, 0), y
            Q7 = i[48](Q7, 391716174)
            if r7 then
              return
            end
            y = true
            for _7, z7 in pairs(I:GetPlayers()) do
              if z7 ~= F then
                local K7, k7 = i[48](18162862, 0), task
                _7 = K7
                K7 = i:rQ((i:HQ(19195914, _7) + i:HQ(19195914, 70591908)) + (i:HQ(4275771383, (i[79](_7, 70591908))) + i:HQ(4275771381, (i[89](_7, 70591908)))))
                K7 = i[48](K7, 116904479)
                k7.spawn(function()
                  v(z7)
                end)
              end
            end
            local _7, z7 = 0, C
            if z7 then
              C:Disconnect()
            end
            r7 = nil
            r7, Q7 = s.Heartbeat, i[48](Q7, 500260233)
            C = r7:Connect(function(Q7)
              _7 += Q7 or 0
              Q7 = _7
              if Q7 < 0.5 then
                return
              end
              _7 = 0
              for _7, K7 in pairs(T) do
                if (((typeof(_7) == "Instance") and _7:IsA("Player")) and K7) and K7.esp then
                  local k7 = i[48](15149475, 0)
                  Q7 = k7
                  local e7
                  e7, k7 = pcall, i:rQ((i:HQ(1132175194, Q7) + i:HQ(1132175194, 238837222)) + (i:HQ(3162792103, (i[79](Q7, 238837222))) + i:HQ(3162792101, (i[89](Q7, 238837222)))))
                  e7(function()
                    q7(_7, K7.esp)
                  end)
                end
              end
            end)
            z7 = I.PlayerAdded:Connect(function(Q7)
              local q7 = not y or (Q7 == F)
              if q7 then
                return
              end
              task.wait(0.3)
              v(Q7)
            end)
            local function v(Q7)
              J7(Q7)
            end
            r7 = I.PlayerRemoving:Connect(v)
            T._joinConn = z7
            T._leaveConn = r7
          end
          local function v()
            y = false
            local y = C
            if y then
              C:Disconnect()
              C = nil
            end
            if T._joinConn then
              local C = i[48](79456344, 0)
              y = nil
              y, C = pcall, i[48](C, 17822682)
              y(function()
                T._joinConn:Disconnect()
              end)
              T._joinConn = nil
            end
            if T._leaveConn then
              local C = i[48](270530456, 0)
              y = C
              local Q7
              Q7, C = pcall, i:rQ(y + 131963119)
              Q7(function()
                T._leaveConn:Disconnect()
              end)
              T._leaveConn = nil
            end
            for y in pairs(T) do
              if ((typeof(y) == "Instance") and y:IsA("Player")) and (y ~= F) then
                J7(y)
              end
            end
          end
          _G.__CrystalTrackStopper(v)
          l["ESP Players"] = function(y)
            if y then
              n7()
            else
              v()
            end
          end
          if h["ESP Players"] then
            n7()
          end
          local y = _G.__CrystalPlayerTracerLine
          if y then
            pcall(function()
              y:Remove()
            end)
          end
          local y = Instance.new("ScreenGui")
          y.Name = "CrystalPlayerTracerOverlay"
          y.IgnoreGuiInset = true
          y.ResetOnSpawn = false
          y.DisplayOrder = 1000
          y.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
          y.Parent = F:WaitForChild("PlayerGui")
          local T = Instance.new("Frame")
          T.Name = "ESPLine"
          T.AnchorPoint = Vector2.new(0.5, 0.5)
          T.BorderSizePixel = 0
          T.Active = false
          T.Visible = false
          T.ZIndex = 1
          T.Parent = y
          w = Instance.new("UIStroke", T)
          w.Color = Color3.fromRGB(255, 255, 255)
          w.Thickness = 0.7
          w.Transparency = 0.45
          _G.__CrystalPlayerTracerLine = {Remove = function()
            y:Destroy()
          end}
          _G.__CrystalTrackStopper(function()
            y:Destroy()
          end)
          local y = {scanElapsed = math.huge, targetRoot = nil}
          _G.__CrystalTrackConn(s.RenderStepped:Connect(function(w)
            local C = i[48](140775929, 0)
            local v = not h["Player Tracers"]
            C = i[48](C, 178337645)
            if v then
              if T.Visible then
                T.Visible = false
              end
              y.targetRoot = nil
              y.scanElapsed = math.huge
              return
            end
            if not pcall(function()
              local C, n7 = workspace.CurrentCamera, F.Character
              local Q7 = n7 and ((n7:FindFirstChild("LowerTorso") or n7:FindFirstChild("HumanoidRootPart")) or n7:FindFirstChild("Torso"))
              if not C or not Q7 then
                T.Visible = false
                return
              end
              n7 = Q7.Position
              y.scanElapsed = y.scanElapsed + (w or 0)
              local w = y.targetRoot
              local r7 = w and w.Parent
              local J7 = r7 and (r7:FindFirstChildOfClass("Humanoid"))
              r7 = (w and w.Parent) and (not J7 or (J7.Health > 0))
              if (y.scanElapsed >= 0.12) or not r7 then
                y.scanElapsed = 0
                w, J7 = math.huge
                for q7, _7 in ipairs(I:GetPlayers()) do
                  if _7 ~= F then
                    q7 = _7.Character
                    local _7, z7 = q7 and (q7:FindFirstChildOfClass("Humanoid")), q7 and ((q7:FindFirstChild("HumanoidRootPart") or q7:FindFirstChild("LowerTorso")) or q7:FindFirstChild("Torso"))
                    if (z7 and z7:IsA("BasePart")) and (not _7 or (_7.Health > 0)) then
                      local q7 = z7.Position - n7
                      local _7 = q7:Dot(q7)
                      if _7 < w then
                        w, J7 = _7, z7
                      else
                      end
                    else
                    end
                  else
                  end
                end
                y.targetRoot = J7
              end
              J7 = y.targetRoot
              if not J7 or not J7.Parent then
                T.Visible = false
                return
              end
              w, r7 = J7.Position, C:WorldToViewportPoint(n7 - Vector3.new(0, Q7.Size.Y * 0.35, 0))
              J7, n7 = C:WorldToViewportPoint(w)
              local y, Q7, q7 = C.ViewportSize, Vector2.new(r7.X, r7.Y), Vector2.new(J7.X, J7.Y)
              if not n7 or (J7.Z <= 0) then
                w = y * 0.5
                C = q7 - w
                C = if (if J7.Z <= 0 then -C else C).Magnitude < 0.001 then Vector2.new(0, -1) else if J7.Z <= 0 then -C else C
                local n7 = Vector2.new(math.max(8, w.X - 8), math.max(8, w.Y - 8))
                local _7, z7 = n7.X / math.max(math.abs(C.X), 0.001), n7.Y / math.max(math.abs(C.Y), 0.001)
                q7 = w + (C * math.min(_7, z7))
              else
              end
              Q7 = if ((((r7.Z <= 0) or (Q7.X < 0)) or (Q7.X > y.X)) or (Q7.Y < 0)) or (Q7.Y > y.Y) then Vector2.new(y.X * 0.5, y.Y - 8) else Q7
              r7, w = q7 - Q7, (Q7 + q7) * 0.5
              T.Position = UDim2.fromOffset(w.X, w.Y)
              T.Size = UDim2.fromOffset(math.max(r7.Magnitude, 1), 2)
              T.Rotation = math.deg(math.atan2(r7.Y, r7.X))
              J7, r7 = j7()
              T.BackgroundColor3 = r7
              T.Visible = true
            end) then
              local y = i[48](448871397, 0)
              v = y
              local w
              w, y = pcall, i:rQ((i:HQ(2710365126, v) + i:HQ(2710365126, 489894656)) + (i:HQ(3169204340, (i[79](v, 489894656))) + i:HQ(2710365127, (i[48](v, 489894656)))))
              w(function()
                T.Visible = false
              end)
            end
          end))
        end
        local function y(w, T, C)
          local v = i[48](23377669, 0)
          local n7 = v
          local Q7, j7, r7 = Instance.new, i:HQ(155417783, n7) + i:HQ(155417783, 527437002)
          v, r7 = i:rQ(j7 + (i:HQ(3984131730, (i[79](n7, 527437002))) + i:HQ(155417784, (i[48](n7, 527437002))))), Q7("Frame")
          n7, j7, Q7 = tostring, C or T
          Q7, v = n7(j7 or "Input"), i[48](v, 311395841)
          r7.Name = Q7 .. "Stub"
          r7.BackgroundTransparency = 1
          r7.Visible = false
          r7.Parent = w
          return {container = r7, input = nil, activeRef = function()
            return h[C] == true
          end}
        end
        local w, T = {}, {"Movement", "Combat", "Visuals", "Animations"}
        local function C(v)
          local n7 = Instance.new("ScrollingFrame", M7)
          n7.Name = v .. "PageStub"
          n7.BackgroundTransparency = 1
          n7.BorderSizePixel = 0
          n7.ScrollBarThickness = 0
          n7.Visible = false
          w[v] = n7
        end
        for v, v in ipairs(T) do
          C(v)
        end
        ;(function(v)
          if not w[v] then
            return
          end
          for M7, n7 in pairs(w) do
            n7.Visible = M7 == v
          end
        end)("Movement")
        _speedCardRefs = _speedCardRefs or {}
        local function v(M7, n7, Q7, j7, r7, J7)
          r7 = Instance.new("Frame")
          r7.Name = tostring((Q7 or n7) or "Speed") .. "SpeedStub"
          r7.BackgroundTransparency = 1
          r7.Visible = false
          r7.Parent = M7
          if J7 then
            local M7 = i[48](46122316, 0)
            j7 = M7
            M7, FeatureToggles[J7] = i:rQ(j7 + 13284226), function()
              W7(Q7)
            end
          end
          return r7
        end
        local M7 = u7(w.Movement, "SPEED")
        v(M7, "Normal Speed", "Normal", "NormalBoost", "NormalSteal", "SelectNormalMode")
        v(M7, "Lagger Speed", "Lagger", "LaggerBoost", "LaggerSteal", "SelectLaggerMode")
        local function n7(Q7)
          local j7 = i[48](269766478, 0)
          local r7 = j7
          j7 = i:rQ((i:HQ(1303384696, r7) + i:HQ(1303384696, 459191946)) + (i:HQ(1688197904, (i[79](r7, 459191946))) + i:HQ(1303384697, (i[48](r7, 459191946)))))
          local r7, J7, q7 = "SelectCustomMode_" .. Q7.name, "CustomBoost_" .. Q7.name, "CustomSteal_" .. Q7.name
          j7 = i[48](j7, 335264713)
          n[J7] = Q7.boost
          n[q7] = Q7.steal
          FeatureToggles[r7] = function()
            W7(Q7.name)
          end
          local j7 = v(M7, Q7.name, Q7.name, J7, q7, r7)
          J7 = Instance.new("TextButton", j7)
          J7.Size = UDim2.new(0, 18, 0, 18)
          J7.AnchorPoint = Vector2.new(1, 1)
          J7.Position = UDim2.new(1, -8, 1, -8)
          J7.ZIndex = 30
          J7.BackgroundColor3 = Color3.fromRGB(240, 200, 200)
          J7.BorderSizePixel = 0
          J7.Text = "x"
          J7.TextColor3 = Color3.fromRGB(180, 60, 60)
          J7.TextSize = 11
          J7.Font = Enum.Font.GothamBold
          J7.AutoButtonColor = false
          J7.TextXAlignment = Enum.TextXAlignment.Center
          J7.TextYAlignment = Enum.TextYAlignment.Center
          Instance.new("UICorner", J7).CornerRadius = UDim.new(0, 4)
          t(J7, function()
            local v = i[48](152366901, 0)
            local r7 = v
            v = i:rQ(r7 + 41519638)
            r7 = #Q
            v = i:rQ(v + 378752130)
            for v = r7, 1, -1 do
              if Q[v].name == Q7.name then
                table.remove(Q, v)
                break
              end
            end
            r7 = J
            if r7 == Q7.name then
              W7("Normal")
            end
            pcall(function()
              j7:Destroy()
            end)
            w7()
          end)
          return j7
        end
        for v, v in ipairs(Q) do
          pcall(function()
            n7(v)
          end)
        end
        do
          C = Instance.new("TextButton", M7)
          C.Size = UDim2.new(1, -2, 0, 28)
          C.BackgroundColor3 = Color3.fromRGB(235, 240, 245)
          C.BackgroundTransparency = 0.55
          C.BorderSizePixel = 0
          C.Text = "+ Add Custom Speed"
          C.TextColor3 = Color3.fromRGB(100, 140, 200)
          C.TextSize = 11
          C.Font = Enum.Font.GothamBold
          C.AutoButtonColor = false
          Instance.new("UICorner", C).CornerRadius = UDim.new(0, 6)
          T = Instance.new("UIStroke", C)
          T.Color = Color3.fromRGB(0, 0, 0)
          T.Thickness = 1
          T.Transparency = 0.3
          local v
          t(C, function()
            local Q7, j7 = i[48](531982391, 0), v
            if j7 then
              local r7 = i[48](83056611, 0)
              local J7 = r7
              local q7 = pcall
              r7 = i:rQ(J7 + 527446599)
              local function r7()
                v:Destroy()
              end
              q7(r7)
              v = nil
              return
            end
            v = Instance.new("Frame", M7)
            j7 = v
            j7.Size = UDim2.new(1, -2, 0, 96)
            j7 = v
            j7.BackgroundColor3 = Color3.fromRGB(230, 238, 245)
            v.BorderSizePixel = 0
            Instance.new("UICorner", v).CornerRadius = UDim.new(0, 6)
            j7 = Instance.new("UIStroke", v)
            local M7
            M7, Q7 = Color3.fromRGB(0, 0, 0), i[48](Q7, 135334064)
            j7.Color = M7
            j7.Thickness = 1
            j7 = Instance.new("TextLabel", v)
            j7.Size = UDim2.new(0, 40, 0, 14)
            j7.Position = UDim2.new(0, 8, 0, 6)
            j7.BackgroundTransparency = 1
            j7.Text = "Name"
            j7.TextColor3 = Color3.fromRGB(100, 140, 190)
            j7.TextSize = 9
            j7.Font = Enum.Font.GothamBold
            j7.TextXAlignment = Enum.TextXAlignment.Left
            local r7 = Instance.new("TextBox", v)
            r7.Size = UDim2.new(0, 120, 0, 20)
            r7.Position = UDim2.new(0, 8, 0, 21)
            r7.BackgroundColor3 = Color3.fromRGB(245, 247, 250)
            r7.BorderSizePixel = 0
            r7.Text = ""
            r7.PlaceholderText = "My Speed"
            r7.Font = Enum.Font.GothamBold
            r7.TextSize = 11
            r7.TextColor3 = Color3.fromRGB(30, 90, 200)
            r7.ClearTextOnFocus = false
            Instance.new("UICorner", r7).CornerRadius = UDim.new(0, 4)
            j7 = Instance.new("UIStroke", r7)
            j7.Color = Color3.fromRGB(0, 0, 0)
            j7.Thickness = 1
            j7 = Instance.new("TextLabel", v)
            j7.Size = UDim2.new(0, 50, 0, 14)
            j7.Position = UDim2.new(0, 140, 0, 6)
            j7.BackgroundTransparency = 1
            j7.Text = "Boost"
            j7.TextColor3 = Color3.fromRGB(100, 140, 190)
            j7.TextSize = 9
            j7.Font = Enum.Font.GothamBold
            j7.TextXAlignment = Enum.TextXAlignment.Left
            local J7 = Instance.new("TextBox", v)
            Q7 = i[48](Q7, 186067007)
            J7.Size = UDim2.new(0, 56, 0, 20)
            J7.Position = UDim2.new(0, 140, 0, 21)
            J7.BackgroundColor3 = Color3.fromRGB(220, 238, 255)
            J7.BorderSizePixel = 0
            J7.Text = "59"
            J7.Font = Enum.Font.GothamBold
            J7.TextSize = 12
            Q7 = i[48](Q7, 255544135)
            J7.TextColor3 = Color3.fromRGB(30, 90, 200)
            J7.TextXAlignment = Enum.TextXAlignment.Center
            J7.ClearTextOnFocus = false
            Instance.new("UICorner", J7).CornerRadius = UDim.new(0, 5)
            M7 = Instance.new("UIStroke", J7)
            M7.Color = Color3.fromRGB(0, 0, 0)
            M7.Thickness = 1
            M7 = Instance.new("TextLabel", v)
            M7.Size = UDim2.new(0, 50, 0, 14)
            M7.Position = UDim2.new(0, 204, 0, 6)
            M7.BackgroundTransparency = 1
            M7.Text = "Steal"
            M7.TextColor3 = Color3.fromRGB(100, 140, 190)
            M7.TextSize = 9
            M7.Font = Enum.Font.GothamBold
            M7.TextXAlignment = Enum.TextXAlignment.Left
            local q7 = Instance.new("TextBox", v)
            q7.Size = UDim2.new(0, 56, 0, 20)
            q7.Position = UDim2.new(0, 204, 0, 21)
            j7 = nil
            j7, Q7 = Color3.fromRGB, i[48](Q7, 162621170)
            q7.BackgroundColor3 = j7(220, 238, 255)
            q7.BorderSizePixel = 0
            q7.Text = "29"
            q7.Font = Enum.Font.GothamBold
            q7.TextSize = 12
            q7.TextColor3 = Color3.fromRGB(30, 90, 200)
            q7.TextXAlignment = Enum.TextXAlignment.Center
            q7.ClearTextOnFocus = false
            Instance.new("UICorner", q7).CornerRadius = UDim.new(0, 5)
            M7 = Instance.new("UIStroke", q7)
            M7.Color = Color3.fromRGB(0, 0, 0)
            M7.Thickness = 1
            local function Q7(j7)
              if j7.UserInputType == Enum.UserInputType.TextInput then
                J7.Text = J7.Text:gsub("[^0-9]", "")
              end
            end
            J7.InputChanged:Connect(Q7)
            local function Q7(j7)
              if j7.UserInputType == Enum.UserInputType.TextInput then
                q7.Text = q7.Text:gsub("[^0-9]", "")
              end
            end
            q7.InputChanged:Connect(Q7)
            M7 = Instance.new("TextButton", v)
            M7.Size = UDim2.new(1, -16, 0, 24)
            M7.Position = UDim2.new(0, 8, 0, 50)
            M7.BackgroundColor3 = Color3.fromRGB(50, 130, 255)
            M7.BorderSizePixel = 0
            M7.Text = "Add Speed"
            M7.TextColor3 = Color3.fromRGB(255, 255, 255)
            M7.TextSize = 11
            M7.Font = Enum.Font.GothamBold
            M7.AutoButtonColor = false
            Instance.new("UICorner", M7).CornerRadius = UDim.new(0, 5)
            local j7 = Instance.new("TextLabel", v)
            j7.Size = UDim2.new(1, -16, 0, 14)
            j7.Position = UDim2.new(0, 8, 0, 78)
            j7.BackgroundTransparency = 1
            j7.Text = ""
            j7.TextColor3 = Color3.fromRGB(200, 60, 60)
            j7.TextSize = 9
            j7.Font = Enum.Font.GothamBold
            j7.TextXAlignment = Enum.TextXAlignment.Left
            Q7 = t
            local function _7()
              local z7 = i[48](260895443, 0)
              local K7 = z7
              local k7, e7, X7 = r7.Text:match("^%s*(.-)%s*$"), tonumber(J7.Text), tonumber(q7.Text)
              if not k7 or (#k7 < 1) then
                j7.Text = "Enter a name"
                return
              end
              if (not e7 or (e7 < 1)) or (e7 > 200) then
                j7.Text = "Boost: 1-200"
                return
              end
              if (not X7 or (X7 < 1)) or (X7 > 200) then
                j7.Text = "Steal: 1-200"
                return
              end
              local r7 = ipairs
              z7 = i[48](K7, 222463338)
              for J7, J7 in r7(Q) do
                if J7.name == k7 then
                  j7.Text = "Name already exists"
                  return
                end
              end
              if ((k7 == "Normal") or (k7 == "Lagger")) or (k7 == "Desync") then
                j7.Text = "Reserved name"
                return
              end
              local j7, r7 = {name = k7, boost = e7, steal = X7}
              r7, z7 = table.insert, i:rQ((i:HQ(313834363, z7) + i:HQ(313834363, 312927622)) + (i:HQ(3667298570, (i[79](z7, 312927622))) + i:HQ(313834364, (i[48](z7, 312927622)))))
              r7(Q, j7)
              pcall(function()
                n7(j7)
              end)
              pcall(function()
                v:Destroy()
              end)
              v = nil
              w7()
            end
            Q7(M7, _7)
          end)
        end
        for v, v in ipairs(_speedCardRefs) do
          if v.updateVisual then
            pcall(v.updateVisual)
          end
        end
        C = u7(w.Movement, "MOVEMENT")
        T = nil
        for v, v in ipairs(U7(C, "Auto Play", "Autoplay"):GetChildren()) do
          if v:IsA("TextButton") then
            T = v
            break
          end
        end
        if T then
          local v = Instance.new("TextButton", T)
          v.Name = "AutoplayModeButton"
          v.Size = UDim2.new(0, 56, 0, 20)
          v.Position = UDim2.new(1, -120, 0.5, -10)
          v.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
          v.BorderSizePixel = 0
          v.Text = string.upper(_G.__autoplayMode or "Full")
          v.TextColor3 = Color3.fromRGB(225, 238, 255)
          v.TextSize = 10
          v.Font = Enum.Font.GothamBold
          v.AutoButtonColor = false
          v.ZIndex = 10
          Instance.new("UICorner", v).CornerRadius = UDim.new(0, 4)
          local M7 = Instance.new("UIStroke", v)
          M7.Color = Color3.fromRGB(255, 255, 255)
          M7.Thickness = 1
          M7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          d()
        end
        p7(C, "Auto Carry Speed", "Auto Carry Speed")
        do
          local v = U7(C, "Carry Speed", "Carry Speed")
          local d
          local M7, n7 = ipairs, i[93](v:GetChildren())
          for Q7, Q7 in M7(i:gQ(n7)) do
            if Q7:IsA("TextButton") then
              d = Q7
              break
            end
          end
          pcall(function()
            styleSmallToggle(v)
          end)
          if d then
            local v = Instance.new("TextButton", d)
            v.Size = UDim2.new(0, 56, 0, 20)
            v.Position = UDim2.new(1, -120, 0.5, -10)
            v.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            v.BorderSizePixel = 0
            v.Text = "V2"
            v.TextColor3 = Color3.fromRGB(225, 238, 255)
            v.TextSize = 10
            v.Font = Enum.Font.GothamBold
            v.AutoButtonColor = false
            v.ZIndex = 10
            Instance.new("UICorner", v).CornerRadius = UDim.new(0, 4)
            n7 = Instance.new("UIStroke", v)
            n7.Color = Color3.fromRGB(255, 255, 255)
            n7.Thickness = 1
            n7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local function M7()
              for n7, n7 in ipairs(d:GetChildren()) do
                if (((n7:IsA("TextButton") and (n7 ~= v)) and (n7.Size.X.Offset == 48)) and (n7.Position.X.Scale == 1)) and (n7.Position.X.Offset == -54) then
                  return n7
                end
              end
              return nil
            end
            local function d()
              X = "v2"
              v.Text = "V2"
              v.TextColor3 = Color3.fromRGB(225, 238, 255)
              v.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
              v.Position = UDim2.new(1, -120, 0.5, -10)
              local n7 = M7()
              if n7 then
                n7.Visible = true
              end
            end
            d()
            v.Visible = false
          end
        end
        pcall(function()
          if _G and _G.__setNoPlayerCollision then
            _G.__setNoPlayerCollision(true)
          end
        end)
        local function v(d)
          local M7 = i[48](523797790, 0)
          local n7 = M7
          local Q7 = not d
          M7 = i:rQ(n7 + 313420410)
          if Q7 then
            return
          end
          pcall(function()
            d.Size = UDim2.new(1, -2, 0, GUI_METRICS.compactCardH)
            for M7, n7 in ipairs(d:GetChildren()) do
              if n7:IsA("TextButton") then
                n7.Size = UDim2.new(1, 0, 0, GUI_METRICS.compactCardH)
                n7.BackgroundColor3 = Color3.fromRGB(25, 31, 42)
                n7.BackgroundTransparency = 0.35
                n7.BorderSizePixel = 0
                n7.ZIndex = 21
                M7 = n7:FindFirstChildOfClass("UICorner")
                if M7 then
                  M7.CornerRadius = UDim.new(0, 5)
                else
                  Instance.new("UICorner", n7).CornerRadius = UDim.new(0, 5)
                end
                local d = n7:FindFirstChildOfClass("UIStroke")
                if d then
                  d.Color = Color3.fromRGB(0, 0, 0)
                  d.Thickness = 1
                  d.Transparency = 0
                end
                break
              end
            end
          end)
        end
        pcall(function()
          local d = f and f.Autoplay
          if (d and d.card) and d.card.Parent then
            v(d.card.Parent)
          end
        end)
        pcall(function()
          local d = f and f["Carry Speed"]
          if (d and d.card) and d.card.Parent then
            v(d.card.Parent)
          end
        end)
        pcall(function()
          local d = f and f["TP Bat"]
          if (d and d.card) and d.card.Parent then
            v(d.card.Parent)
          end
        end)
        _G.__CrystalInfJumpMode = _G.__CrystalInfJumpMode or "hold"
        p7(C, "Unwalk", "Unwalk")
        T = p7(C, "Inf Jump", "Inf Jump")
        if T then
          local d = Instance.new("TextButton", T)
          d.Name = "InfJumpModeBtn"
          d.Size = UDim2.new(0, 66, 0, 20)
          d.Position = UDim2.new(1, -74, 0.5, -10)
          d.AnchorPoint = Vector2.new(0, 0)
          d.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
          d.BorderSizePixel = 0
          d.Text = ((_G.__CrystalInfJumpMode == "hold") and "HOLD") or "MANUAL"
          d.TextColor3 = Color3.fromRGB(225, 238, 255)
          d.Font = Enum.Font.GothamBold
          d.TextSize = 10
          d.AutoButtonColor = false
          d.ZIndex = 30
          Instance.new("UICorner", d).CornerRadius = UDim.new(0, 4)
          local M7 = Instance.new("UIStroke", d)
          M7.Color = Color3.fromRGB(255, 255, 255)
          M7.Thickness = 1
          M7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          local function n7()
            d.Text = ((_G.__CrystalInfJumpMode == "hold") and "HOLD") or "MANUAL"
            d.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            d.TextColor3 = Color3.fromRGB(225, 238, 255)
            M7.Color = Color3.fromRGB(255, 255, 255)
            M7.Thickness = 1
            d.TextStrokeTransparency = 1
          end
          n7()
          t(d, function()
            _G.__CrystalInfJumpMode = ((_G.__CrystalInfJumpMode == "hold") and "manual") or "hold"
            n7()
            if h["Inf Jump"] then
              if _G.__CrystalInfJumpMode == "hold" then
                startInfJump()
              else
                stopInfJump()
              end
            end
          end)
        end
        local d = U7(C, "TP Down", "TP Down")
        pcall(function()
          v(d)
        end)
        y(C, "Auto TP Down", "Auto TP Down")
        C = u7(w.Combat, "COMBAT")
        U7(C, "Anti Bat", "Anti Bat")
        p7(C, "Anti Ragdoll", "Anti Ragdoll")
        p7(C, "Ragdoll Counter", "Ragdoll Counter")
        p7(C, "Medusa Counter", "Medusa Counter")
        function _G.__CrystalAntiDieGuiEnabled()
          return h["Anti Die"] == true
        end
        l["Anti Die"] = function(d)
          local M7 = i[48](325370091, 0)
          local n7
          n7, M7 = pcall, i:rQ((i:HQ(189372939, M7) + i:HQ(189372939, 130785480)) + (i:HQ(4105594358, (i[79](M7, 130785480))) + i:HQ(4105594356, (i[89](M7, 130785480)))))
          n7(function()
            if _G.__CrystalAntiDieSource then
              _G.__CrystalAntiDieSource("toggle", d)
            end
          end)
        end
        p7(C, "Anti Die", "Anti Die")
        l["Anti Die"](h["Anti Die"] == true)
        do
          local d = U7(C, "Aimbot", "Aimbot")
          pcall(function()
            v(d)
          end)
        end
        do
          local d = U7(C, "TP Bat", "TP Bat", function(M7)
            local n7 = i[48](141515358, 0)
            local Q7 = n7
            local j7 = M7.Parent
            local r7 = j7 and (j7:FindFirstChildOfClass("TextButton"))
            if not r7 then
              return 28
            end
            local J7 = Instance.new("TextButton", r7)
            J7.Name = "BatVersionToggle"
            J7.Size = UDim2.new(0, 64, 0, 22)
            J7.Position = UDim2.new(1, -118, 0.5, -11)
            J7.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            J7.BorderSizePixel = 0
            J7.Text = "V" .. tostring(_G.__batVersion or 1)
            J7.TextColor3 = Color3.fromRGB(225, 238, 255)
            J7.Font = Enum.Font.GothamBold
            J7.TextSize = 10
            J7.AutoButtonColor = false
            J7.Active = false
            J7.Selectable = false
            J7.Visible = false
            J7.ZIndex = 30
            Instance.new("UICorner", J7).CornerRadius = UDim.new(0, 4)
            local q7 = Instance.new("UIStroke", J7)
            q7.Color = Color3.fromRGB(255, 255, 255)
            q7.Thickness = 1
            q7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local _7 = Instance.new("TextButton", r7)
            _7.Name = "BatConfigToggle"
            local z7, K7, k7 = UDim2.new, (M and 50) or 64
            if M then
              n7 = i[48](Q7, 396770977)
              n7 = i[48](n7, 396770977)
              k7 = 18
            else
              k7, n7 = M, Q7
            end
            _7.Size = z7(0, K7, 0, k7 or 22)
            _7.Position = UDim2.new(1, (M and -88) or -118, 0.5, (M and -9) or -11)
            _7.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
            _7.BorderSizePixel = 0
            _7.Text = ""
            _7.AutoButtonColor = false
            _7.ZIndex = 30
            Instance.new("UICorner", _7).CornerRadius = UDim.new(0, 4)
            local e7 = Instance.new("UIStroke", _7)
            e7.Color = Color3.fromRGB(160, 175, 195)
            e7.Thickness = 1
            e7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Q7 = Instance.new("TextLabel", _7)
            Q7.Size = UDim2.new(0, 30, 1, 0)
            Q7.Position = UDim2.new(0, 5, 0, 0)
            Q7.BackgroundTransparency = 1
            Q7.Text = "GUI"
            Q7.TextColor3 = Color3.fromRGB(235, 240, 250)
            Q7.Font = Enum.Font.GothamBold
            Q7.TextSize = 8
            Q7.TextXAlignment = Enum.TextXAlignment.Left
            Q7.ZIndex = 31
            r7 = nil
            r7, n7 = Instance.new, i[48](n7, 101989985)
            local X7 = r7("Frame", _7)
            X7.Size = UDim2.new(0, 24, 0, 12)
            X7.Position = UDim2.new(1, -29, 0.5, -6)
            X7.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
            X7.BorderSizePixel = 0
            X7.ZIndex = 31
            n7, Instance.new("UICorner", X7).CornerRadius = i[48](n7, 143063915), UDim.new(1, 0)
            K7 = nil
            K7, n7 = Instance.new, i[48](n7, 172773509)
            local r7 = K7("Frame", X7)
            r7.Size = UDim2.new(0, 8, 0, 8)
            r7.Position = UDim2.new(0, 2, 0.5, -4)
            r7.BackgroundColor3 = Color3.fromRGB(155, 165, 180)
            r7.BorderSizePixel = 0
            r7.ZIndex = 32
            Instance.new("UICorner", r7).CornerRadius = UDim.new(1, 0)
            local C7 = Instance.new("Frame", M7)
            C7.Name = "BatV2DistanceConfig"
            C7.Size = UDim2.new(1, -2, 0, 78)
            C7.Position = UDim2.new(0, 1, 0, 4)
            C7.BackgroundColor3 = Color3.fromRGB(25, 31, 42)
            C7.BackgroundTransparency = 0.2
            C7.BorderSizePixel = 0
            C7.ZIndex = 22
            Instance.new("UICorner", C7).CornerRadius = UDim.new(0, 6)
            k7 = Instance.new("UIStroke", C7)
            k7.Color = Color3.fromRGB(90, 130, 185)
            k7.Transparency = 0.25
            k7.Thickness = 1
            z7 = Instance.new("TextLabel", C7)
            z7.Size = UDim2.new(1, -92, 0, 38)
            z7.Position = UDim2.new(0, 10, 0, 0)
            z7.BackgroundTransparency = 1
            z7.Text = "DISTANCIA TP (STUDS)"
            z7.TextColor3 = Color3.fromRGB(190, 210, 238)
            z7.Font = Enum.Font.GothamBold
            z7.TextSize = 10
            z7.TextXAlignment = Enum.TextXAlignment.Left
            z7.ZIndex = 23
            local z7 = Instance.new("TextBox", C7)
            n7 = i:rQ((n7 + i:HQ(3660390223, 191535887)) + (i:HQ(4294967294, (i[89](n7, 191535887))) + (i:HQ(634577074, 4294967295) + i:HQ(3660390222, (i[100](191535887))))))
            z7.Name = "BatV2DistanceInput"
            z7.Size = UDim2.new(0, 70, 0, 26)
            z7.Position = UDim2.new(1, -80, 0, 6)
            z7.BackgroundColor3 = Color3.fromRGB(15, 20, 29)
            n7 = i:rQ((i:HQ(441121974, n7) + i:HQ(441121974, 22980002)) + (i:HQ(3412723348, (i[89](22980002, n7))) + i:HQ(3853845323, (i[48](n7, 22980002)))))
            z7.BackgroundTransparency = 0.05
            z7.BorderSizePixel = 0
            z7.ClearTextOnFocus = false
            z7.Text = tostring(_G.__tpBatV2Distance or 8)
            z7.TextColor3 = Color3.fromRGB(245, 248, 255)
            z7.Font = Enum.Font.GothamBold
            z7.TextSize = 11
            z7.TextXAlignment = Enum.TextXAlignment.Center
            z7.ZIndex = 24
            Instance.new("UICorner", z7).CornerRadius = UDim.new(0, 4)
            k7 = Instance.new("UIStroke", z7)
            k7.Color = Color3.fromRGB(125, 170, 225)
            k7.Transparency = 0.2
            k7.Thickness = 1
            _G.__tpBatV2DistanceInput = z7
            Q7 = Instance.new("TextLabel", C7)
            Q7.Size = UDim2.new(1, -92, 0, 34)
            Q7.Position = UDim2.new(0, 10, 0, 40)
            Q7.BackgroundTransparency = 1
            Q7.Text = "VERSION TP BAT"
            Q7.TextColor3 = Color3.fromRGB(190, 210, 238)
            Q7.Font = Enum.Font.GothamBold
            Q7.TextSize = 10
            Q7.TextXAlignment = Enum.TextXAlignment.Left
            Q7.ZIndex = 23
            Q7.Visible = true
            local k7 = Instance.new("TextButton", C7)
            k7.Name = "BatVersionInsideConfig"
            k7.Size = UDim2.new(0, 70, 0, 26)
            K7 = nil
            K7, n7 = UDim2, i[48](n7, 225329021)
            k7.Position = K7.new(1, -80, 0, 44)
            k7.BackgroundColor3 = Color3.fromRGB(28, 92, 165)
            k7.BorderSizePixel = 0
            k7.Text = "V" .. tostring(_G.__batVersion or 1)
            k7.TextColor3 = Color3.fromRGB(245, 248, 255)
            k7.Font = Enum.Font.GothamBold
            k7.TextSize = 11
            k7.AutoButtonColor = false
            k7.Active = true
            k7.Visible = true
            k7.ZIndex = 24
            Instance.new("UICorner", k7).CornerRadius = UDim.new(0, 4)
            local n7 = Instance.new("UIStroke", k7)
            n7.Color = Color3.fromRGB(110, 190, 255)
            n7.Transparency = 0.15
            n7.Thickness = 1
            local K7 = false
            local function a7()
              local A7 = K7
              _7.Visible = true
              _7.BackgroundColor3 = (A7 and Color3.fromRGB(28, 92, 165)) or Color3.fromRGB(45, 48, 58)
              e7.Color = (A7 and Color3.fromRGB(110, 190, 255)) or Color3.fromRGB(160, 175, 195)
              X7.BackgroundColor3 = (A7 and Color3.fromRGB(45, 135, 225)) or Color3.fromRGB(25, 27, 33)
              r7.BackgroundColor3 = (A7 and Color3.fromRGB(245, 248, 255)) or Color3.fromRGB(155, 165, 180)
              r7.Position = (A7 and UDim2.new(1, -10, 0.5, -4)) or UDim2.new(0, 2, 0.5, -4)
              M7.Visible = A7
              M7.Size = UDim2.new(1, 0, 0, (A7 and 86) or 0)
              j7.Size = UDim2.new(1, -2, 0, (A7 and (GUI_METRICS.toggleH + 86)) or GUI_METRICS.toggleH)
            end
            t(_7, function()
              K7 = not K7
              a7()
            end)
            local function r7()
              _G.CrystalAutoBat.SetV2Distance(z7.Text)
            end
            z7.FocusLost:Connect(r7)
            _G.__batVersionPill = J7
            _G.__batVersion = ((tonumber(_G.__batVersion) == 2) and 2) or 1
            local function r7()
              _G.__batVersion = ((tonumber(_G.__batVersion) == 2) and 2) or 1
              J7.Text = "V" .. tostring(_G.__batVersion or 1)
              J7.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
              J7.TextColor3 = Color3.fromRGB(245, 248, 255)
              q7.Color = Color3.fromRGB(220, 225, 235)
              k7.Text = "V" .. tostring(_G.__batVersion or 1)
              k7.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
              n7.Color = Color3.fromRGB(220, 225, 235)
              z7.TextEditable = true
              z7.Text = tostring(_G.__tpBatV2Distance or 8)
              z7.BackgroundTransparency = 0.05
              z7.TextColor3 = Color3.fromRGB(245, 248, 255)
              a7()
            end
            _G.__CrystalUpdateBatVersionButton = r7
            r7()
            t(J7, function()
              _G.CrystalAutoBat.SetVersion(((_G.__batVersion == 1) and 2) or 1)
            end)
            t(k7, function()
              _G.CrystalAutoBat.SetVersion(((_G.__batVersion == 1) and 2) or 1)
            end)
            M7.Size = UDim2.new(1, 0, 0, 0)
            M7.Visible = false
            j7.Size = UDim2.new(1, -2, 0, GUI_METRICS.toggleH)
            _G.__batVersionPill = nil
            function _G.__CrystalUpdateBatVersionButton()
            end
            pcall(function()
              J7:Destroy()
            end)
            pcall(function()
              _7:Destroy()
            end)
            Q7 = pcall
            local function M7()
              C7:Destroy()
            end
            Q7(M7)
            return 0
          end)
          pcall(function()
            v(d)
          end)
        end
        ;(function()
          local d = i[48](292934942, 0)
          pcall(function()
            local M7 = workspace:FindFirstChild("CrystalTPBatLastPosition")
            if M7 then
              M7:Destroy()
            end
          end)
          local M7 = {enabled = false, heartbeat = nil, target = nil, samples = {}, swingLocked = false}
          d = i:rQ(d + 142223749)
          M7.nextSwingAt = 0
          M7.lastSafeCFrame = nil
          M7.lastPosition = nil
          M7.lastSampleTime = 0
          M7.recoverUntil = 0
          M7.physicsPauseUntil = 0
          M7.previousAutoRotate = nil
          M7.lastTargetMarker = nil
          M7.markerLocked = false
          M7.markerTarget = nil
          M7.markerBodyLock = nil
          M7.markerBodyAttachment = nil
          _G.__batVersion = ((tonumber(_G.__batVersion) == 2) and 2) or 1
          local function n7()
            local Q7 = F.Character
            if not Q7 then
              return nil, nil, nil
            end
            return Q7, Q7:FindFirstChild("HumanoidRootPart"), Q7:FindFirstChildOfClass("Humanoid")
          end
          local function Q7(j7)
            return ((((((j7 ~= nil) and (j7.X == j7.X)) and (j7.Y == j7.Y)) and (j7.Z == j7.Z)) and (math.abs(j7.X) < 10000000)) and (math.abs(j7.Y) < 10000000)) and (math.abs(j7.Z) < 10000000)
          end
          local function j7(r7, J7, q7, _7)
            local z7 = Vector3.new(J7.X - r7.X, 0, J7.Z - r7.Z)
            if z7.Magnitude > 0.05 then
              return CFrame.lookAt(r7, r7 + z7.Unit)
            end
            J7 = (q7 and Vector3.new(q7.X, 0, q7.Z)) or nil
            if J7 and (J7.Magnitude >= 0.01) then
              return CFrame.lookAt(r7, r7 + J7.Unit)
            end
            if _7 then
              z7, J7 = _7:ToEulerAnglesYXZ()
              return CFrame.new(r7) * CFrame.Angles(0, J7, 0)
            end
            return CFrame.new(r7)
          end
          local function r7(J7, q7)
            if not J7 or not q7 then
              return nil
            end
            local _7 = q7.Position
            local z7 = Vector3.new(J7.Position.X - _7.X, 0, J7.Position.Z - _7.Z)
            if z7.Magnitude <= 0.05 then
              local K7 = q7.CFrame.LookVector
              z7 = Vector3.new(-K7.X, 0, -K7.Z)
            else
            end
            return j7(_7 + ((if z7.Magnitude <= 0.05 then Vector3.new(0, 0, 1) else z7).Unit * 3), _7, q7.CFrame.LookVector, J7.CFrame)
          end
          d = i:rQ(d + 333867612)
          local function d()
            if M7.markerBodyLock then
              local j7 = i[48](263339071, 0)
              local J7
              J7, j7 = pcall, i:rQ(j7 + 74783574)
              J7(function()
                M7.markerBodyLock:Destroy()
              end)
              M7.markerBodyLock = nil
            end
            if M7.markerBodyAttachment then
              local j7 = i[48](524552897, 0)
              local J7 = j7
              local q7
              q7, j7 = pcall, i:rQ(J7 + 6478741)
              q7(function()
                M7.markerBodyAttachment:Destroy()
              end)
              M7.markerBodyAttachment = nil
            end
          end
          local function j7(J7, J7)
            d()
          end
          _G.__CrystalTPBatApplyMarkerBodyLock = j7
          _G.__CrystalTPBatClearMarkerBodyLock = d
          local function J7(q7, _7)
            local z7 = i[48](159452092, 0)
            local K7 = z7
            local k7
            z7, k7 = i[48](K7, 152223901), not q7 or not _7
            if k7 then
              return false
            end
            z7 = i:rQ((i:HQ(789325973, z7) + i:HQ(789325973, 163269275)) + (i:HQ(2716315350, (i[79](z7, 163269275))) + i:HQ(789325974, (i[48](z7, 163269275)))))
            K7 = M7 and M7.lastTargetMarker
            if ((K7 and K7.Parent) and K7.Transparency) and (K7.Transparency < 1) then
              return false
            end
            return (pcall(function()
              q7.AssemblyLinearVelocity = Vector3.zero
              q7.AssemblyAngularVelocity = Vector3.zero
              q7.CFrame = _7
              q7.AssemblyLinearVelocity = Vector3.zero
              q7.AssemblyAngularVelocity = Vector3.zero
            end))
          end
          local q7 = -536.2
          local _7 = -422
          local z7, K7 = -10, 75
          local k7, e7 = -71.8, 192.9
          local function X7(C7)
            if not C7 then
              return false
            end
            return (((((C7.X >= q7) and (C7.X <= _7)) and (C7.Y >= z7)) and (C7.Y <= K7)) and (C7.Z >= k7)) and (C7.Z <= e7)
          end
          _G.__CrystalTPBatIsInsideMap = X7
          local function q7(_7)
            if M7.markerLocked then
              return
            end
            local K7 = M7.markerTarget
            local k7 = (K7 and (K7.Parent == I)) and K7.Character
            local e7, C7 = k7 and (k7:FindFirstChild("HumanoidRootPart")), k7 and (k7:FindFirstChildOfClass("Humanoid"))
            if (((not e7 or not C7) or (C7.Health <= 0)) or not Q7(e7.Position)) or X7(e7.Position) then
              return
            end
            if not _7 or not X7(_7.Position) then
              return
            end
            K7, e7 = CFrame.new(_7.Position.X, -7, _7.Position.Z) * _7.Rotation, M7.lastTargetMarker
            if not e7 or not e7.Parent then
              e7 = Instance.new("Part")
              e7.Name = "CrystalTPBatLastPosition"
              e7.Shape = Enum.PartType.Ball
              e7.Size = Vector3.new(3, 3, 3)
              e7.Color = Color3.fromRGB(0, 110, 255)
              e7.Material = Enum.Material.Neon
              e7.Anchored = true
              e7.CanCollide = false
              e7.CanTouch = false
              e7.CanQuery = false
              e7.CastShadow = false
              e7.Parent = workspace
              _7 = Instance.new("SphereHandleAdornment")
              _7.Name = "AlwaysOnTopSphere"
              _7.Adornee = e7
              _7.Radius = 1.55
              _7.Color3 = Color3.fromRGB(0, 125, 255)
              _7.Transparency = 0.05
              _7.AlwaysOnTop = true
              _7.Visible = true
              _7.ZIndex = 10
              _7.Parent = e7
              C7 = Instance.new("Highlight")
              C7.Name = "LastPositionHighlight"
              C7.Adornee = e7
              C7.FillColor = Color3.fromRGB(0, 110, 255)
              C7.FillTransparency = 0.15
              C7.OutlineColor = Color3.fromRGB(120, 200, 255)
              C7.OutlineTransparency = 0
              C7.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
              C7.Enabled = true
              C7.Parent = e7
              k7 = Instance.new("BillboardGui")
              k7.Name = "LastPositionLabel"
              k7.Size = UDim2.new(0, 110, 0, 20)
              k7.StudsOffset = Vector3.new(0, 2.1, 0)
              k7.AlwaysOnTop = true
              k7.Adornee = e7
              k7.Parent = e7
              local _7 = Instance.new("TextLabel")
              _7.Name = "Text"
              _7.Size = UDim2.fromScale(1, 1)
              _7.BackgroundTransparency = 1
              _7.Text = "ultima posicion"
              _7.TextColor3 = Color3.fromRGB(220, 235, 255)
              _7.TextStrokeColor3 = Color3.fromRGB(0, 35, 90)
              _7.TextStrokeTransparency = 0.25
              _7.TextSize = 11
              _7.Font = Enum.Font.GothamMedium
              _7.Parent = k7
              M7.lastTargetMarker = e7
            else
            end
            e7.Transparency = 0
            local _7 = e7:FindFirstChild("AlwaysOnTopSphere")
            if _7 then
              _7.Visible = true
            end
            _7 = e7:FindFirstChild("LastPositionHighlight")
            if _7 then
              _7.Enabled = true
            end
            _7 = e7:FindFirstChild("LastPositionLabel")
            if _7 then
              _7.Enabled = true
            end
            e7.CFrame = K7
            M7.markerLocked = true
          end
          local function _7()
            M7.markerLocked = false
            d()
            if M7.lastTargetMarker then
              local K7 = i[48](462173876, 0)
              local k7 = K7
              local e7
              e7, K7 = pcall, i:rQ(k7 + 524590620)
              e7(function()
                M7.lastTargetMarker.Transparency = 1
                local K7 = M7.lastTargetMarker:FindFirstChild("AlwaysOnTopSphere")
                if K7 then
                  K7.Visible = false
                end
                K7 = M7.lastTargetMarker:FindFirstChild("LastPositionHighlight")
                if K7 then
                  K7.Enabled = false
                end
                K7 = M7.lastTargetMarker:FindFirstChild("LastPositionLabel")
                if K7 then
                  K7.Enabled = false
                end
              end)
            end
          end
          function _G.__CrystalTPBatGetMarkerCFrame()
            local K7 = M7.lastTargetMarker
            if ((M7.markerLocked and K7) and K7.Parent) and (K7.Transparency < 1) then
              local k7 = M7.markerTarget
              local e7 = (k7 and k7.Character) and k7.Character:FindFirstChild("HumanoidRootPart")
              if e7 and X7(e7.Position) then
                _7()
                return nil
              end
              e7, k7 = n7()
              return r7(k7, K7) or K7.CFrame
            end
            return nil
          end
          function _G.__CrystalTPBatTrackTarget(r7)
            if M7.markerLocked then
              return M7.markerTarget
            end
            local K7 = M7.markerTarget
            local k7 = (K7 and (K7.Parent == I)) and K7.Character
            local e7, C7, a7 = k7 and (k7:FindFirstChildOfClass("Humanoid")), k7 and (k7:FindFirstChild("HumanoidRootPart")), K7 and M7.samples[K7]
            if K7 and (K7.Parent == I) then
              if (e7 and (e7.Health > 0)) and ((C7 and X7(C7.Position)) or (a7 and a7.safeCFrame)) then
                return K7
              end
              if (not e7 and a7) and a7.safeCFrame then
                return K7
              end
            end
            if (r7 and (r7 ~= F)) and (r7.Parent == I) then
              M7.markerTarget = r7
              return r7
            end
            return M7.markerTarget
          end
          function _G.__CrystalTPBatClearMarkerTracking()
            M7.target = nil
          end
          local function r7(K7, k7)
            if (not K7 or (K7.Parent ~= I)) or not K7.Character then
              return false
            end
            local k7, e7 = K7.Character:FindFirstChild("HumanoidRootPart"), K7.Character:FindFirstChildOfClass("Humanoid")
            if ((not k7 or not e7) or (e7.Health <= 0)) or not X7(k7.Position) then
              return false
            end
            return true
          end
          local function K7(k7, e7)
            if (not k7 or not k7.history) or (#k7.history == 0) then
              return nil
            end
            local C7, a7 = e7 - 0.2
            for e7, e7 in ipairs(k7.history) do
              if not (e7.time <= C7) then
                break
              end
              a7 = e7
            end
            return a7 or k7.history[1]
          end
          function _G.__CrystalTPBatForceMarker(k7, e7)
            if k7 and (k7.Parent == I) then
              M7.markerTarget = k7
            end
            local C7 = k7 and M7.samples[k7]
            k7 = K7(C7, tick())
            local a7 = (k7 and k7.safeCFrame) or (C7 and C7.safeCFrame)
            a7 = if (not a7 and e7) and X7(e7.Position) then e7 else a7
            if a7 then
              q7(a7)
            end
            return _G.__CrystalTPBatGetMarkerCFrame()
          end
          local function k7()
            local e7, e7 = n7()
            if not e7 then
              return
            end
            local n7 = M7.markerTarget
            if n7 and (n7.Parent == I) then
              local C7, a7, A7 = n7.Character and n7.Character:FindFirstChild("HumanoidRootPart"), n7.Character and n7.Character:FindFirstChildOfClass("Humanoid"), M7.samples[n7] or {}
              M7.samples[n7] = A7
              if ((C7 and a7) and (a7.Health > 0)) and Q7(C7.Position) then
                if X7(C7.Position) then
                  local Q7 = tick()
                  if M7.markerLocked then
                    A7.history = {}
                  end
                  A7.history = A7.history or {}
                  table.insert(A7.history, {time = Q7, safePosition = C7.Position, safeCFrame = C7.CFrame})
                  while A7.history[1] and ((Q7 - A7.history[1].time) > 0.45) do
                    table.remove(A7.history, 1)
                  end
                  A7.safePosition = C7.Position
                  A7.safeCFrame = C7.CFrame
                  _7()
                else
                  local Q7 = K7(A7, tick())
                  q7((Q7 and Q7.safeCFrame) or A7.safeCFrame)
                end
              end
              if (a7 and (a7.Health <= 0)) or (not C7 and not A7.safeCFrame) then
                M7.markerTarget = nil
                _7()
              else
                return
              end
            end
            local Q7, q7 = math.huge
            for K7, X7 in ipairs(I:GetPlayers()) do
              if (X7 ~= F) and r7(X7) then
                n7 = X7.Character:FindFirstChild("HumanoidRootPart").Position - e7.Position
                K7 = n7:Dot(n7)
                if K7 < Q7 then
                  Q7, q7 = K7, X7
                else
                end
              else
              end
            end
            if q7 then
              M7.markerTarget = q7
              e7, n7 = q7.Character:FindFirstChild("HumanoidRootPart"), M7.samples[q7] or {}
              M7.samples[q7] = n7
              n7.safePosition = e7.Position
              n7.safeCFrame = e7.CFrame
              n7.history = {{time = tick(), safePosition = e7.Position, safeCFrame = e7.CFrame}}
            end
          end
          local n7 = 0
          local Q7 = s.Heartbeat:Connect(function(r7)
            n7 += r7 or 0
            r7 = n7
            if r7 < 0.016666666666666666 then
              return
            end
            n7 %= 0.016666666666666666
            k7()
          end)
          _G.__CrystalTrackConn(Q7)
          local function n7(r7)
            local q7 = i[48](518345562, 0)
            local K7 = q7
            local k7 = _G
            q7 = i[48](K7, 512099040)
            K7 = k7.__CrystalTPBatGetMarkerCFrame
            q7 = i:rQ((i:HQ(1381522771, q7) + i:HQ(1381522771, 66065359)) + (i:HQ(2913444526, (i[79](q7, 66065359))) + i:HQ(2913444524, (i[89](q7, 66065359)))))
            local q7 = K7()
            if not q7 then
              d()
              return false
            end
            pcall(function()
              r7.AssemblyLinearVelocity = Vector3.zero
              r7.AssemblyAngularVelocity = Vector3.zero
              r7.CFrame = q7
              r7.AssemblyLinearVelocity = Vector3.zero
              r7.AssemblyAngularVelocity = Vector3.zero
            end)
            k7 = M7.lastTargetMarker
            if k7 then
              j7(r7, k7)
            end
            return true
          end
          _G.__CrystalTrackStopper(function()
            pcall(_7)
          end)
          do
            local M7, j7 = i[48](507212530, 0), {enabled = false, heartbeat = nil, target = nil, samples = {}, swingLocked = false, nextSwingAt = 0}
            M7 = i:rQ(M7 + 311681704)
            j7.lastSafeCFrame = nil
            j7.lastPosition = nil
            Q7 = i:rQ(z7)
            M7 = i:rQ((i:HQ(277490722, 4294967295) + M7) + (i:HQ(4065952893, Q7) + i:HQ(4065952893, (i[100](Q7)))))
            j7.lastSampleTime = 0
            j7.recoverUntil = 0
            j7.physicsPauseUntil = 0
            j7.previousAutoRotate = nil
            j7.lastTargetMarker = nil
            j7.markerLocked = false
            j7.markerTarget = nil
            _G.__batVersion = ((tonumber(_G.__batVersion) == 2) and 2) or 1
            local M7 = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}
            local function Q7()
              local r7 = F.Character
              if not r7 then
                return nil, nil, nil
              end
              return r7, r7:FindFirstChild("HumanoidRootPart"), r7:FindFirstChildOfClass("Humanoid")
            end
            local function r7(q7)
              local _7, z7, z7 = Q7()
              if not _7 then
                return nil
              end
              for K7, k7 in ipairs(M7) do
                K7 = _7:FindFirstChild(k7)
                if K7 and (K7:IsA("Tool")) then
                  return K7
                end
              end
              for K7, k7 in ipairs(_7:GetChildren()) do
                if k7:IsA("Tool") then
                  K7 = k7.Name:lower()
                  if K7:find("bat", 1, true) or K7:find("slap", 1, true) then
                    return k7
                  end
                end
              end
              _7 = F:FindFirstChildOfClass("Backpack")
              if _7 then
                local K7
                for k7, e7 in ipairs(M7) do
                  k7 = _7:FindFirstChild(e7)
                  if k7 and (k7:IsA("Tool")) then
                    K7 = k7
                    break
                  end
                end
                if not K7 then
                  local M7, k7 = ipairs, i[93](_7:GetChildren())
                  for _7, e7 in M7(i:gQ(k7)) do
                    if e7:IsA("Tool") then
                      _7 = e7.Name:lower()
                      if _7:find("bat", 1, true) or _7:find("slap", 1, true) then
                        K7 = e7
                        break
                      end
                    end
                  end
                else
                end
                if (K7 and q7) and z7 then
                  local M7 = i[48](402288685, 0)
                  local q7 = M7
                  local _7
                  _7, M7 = pcall, i:rQ(q7 + 115515143)
                  _7(function()
                    z7:EquipTool(K7)
                  end)
                end
                return K7
              end
              return nil
            end
            local function M7(q7)
              return (((((q7.X == q7.X) and (q7.Y == q7.Y)) and (q7.Z == q7.Z)) and (math.abs(q7.X) < 10000000)) and (math.abs(q7.Y) < 10000000)) and (math.abs(q7.Z) < 10000000)
            end
            local function q7(_7, z7, K7, k7)
              local e7 = Vector3.new(z7.X - _7.X, 0, z7.Z - _7.Z)
              if e7.Magnitude > 0.05 then
                return CFrame.lookAt(_7, _7 + e7.Unit)
              end
              z7 = (K7 and Vector3.new(K7.X, 0, K7.Z)) or nil
              if z7 and (z7.Magnitude >= 0.01) then
                return CFrame.lookAt(_7, _7 + z7.Unit)
              end
              if k7 then
                z7, K7 = k7:ToEulerAnglesYXZ()
                return CFrame.new(_7) * CFrame.Angles(0, K7, 0)
              end
              return CFrame.new(_7)
            end
            local function _7(z7)
              return z7 ~= nil
            end
            local function z7()
            end
            local function K7(k7)
              if (not k7 or (k7.Parent ~= I)) or not k7.Character then
                return false
              end
              local e7, X7 = k7.Character:FindFirstChild("HumanoidRootPart"), k7.Character:FindFirstChildOfClass("Humanoid")
              if ((not e7 or not X7) or (X7.Health <= 0)) or not M7(e7.Position) then
                return false
              end
              X7 = j7.samples[k7]
              return _G.__CrystalTPBatIsInsideMap(e7.Position) or ((X7 ~= nil) and (X7.safeCFrame ~= nil))
            end
            local function k7(e7, X7)
              local C7 = e7 and j7.samples[e7]
              e7 = C7 and C7.safeCFrame
              if (e7 and _7(e7.Position)) and (not X7 or _7(e7.Position)) then
                return e7
              end
              return nil
            end
            local function _7(e7)
              local X7 = _G.__CrystalTPBatTrackTarget(j7.target)
              if K7(X7) then
                j7.target = X7
                return X7
              end
              if K7(j7.target) then
                return j7.target
              end
              local C7, a7 = math.huge
              for A7, g7 in ipairs(I:GetPlayers()) do
                if (g7 ~= F) and K7(g7) then
                  X7 = g7.Character:FindFirstChild("HumanoidRootPart")
                  if X7 then
                    A7 = (X7.Position - e7.Position).Magnitude
                    if A7 < C7 then
                      C7, a7 = A7, g7
                    else
                    end
                  else
                  end
                else
                end
              end
              if a7 then
                j7.target = a7
                _G.__CrystalTPBatTrackTarget(a7)
              end
              return a7
            end
            local function K7()
              local e7 = tonumber(_G.__tpBatV2Distance)
              if not e7 or (e7 ~= e7) then
                return 8
              end
              return math.clamp(e7, 0, 100)
            end
            local function e7()
              local X7 = i[48](162214498, 0)
              local C7 = X7
              local a7 = tick()
              if j7.swingLocked or (a7 < j7.nextSwingAt) then
                return
              end
              X7 = i:rQ(C7 + 407664872)
              j7.swingLocked = true
              C7 = nil
              C7, X7 = a7 + 0.014925373134328358, i:rQ(X7 - 151934590)
              j7.nextSwingAt = C7
              pcall(function()
                local X7 = F.Character
                if not X7 then
                  return
                end
                local C7 = r7(true)
                if not C7 then
                  return
                end
                if C7.Parent ~= X7 then
                  local a7 = X7:FindFirstChildOfClass("Humanoid")
                  if a7 then
                    a7:EquipTool(C7)
                  end
                end
                C7:Activate()
                local a7 = C7:FindFirstChildWhichIsA("RemoteEvent", true)
                if a7 then
                  local A7 = i[48](101429829, 0)
                  C7 = A7
                  X7 = nil
                  X7, A7 = pcall, i:rQ((i:HQ(3465020692, C7) + i:HQ(3465020692, 145314894)) + (i:HQ(829946605, (i[79](C7, 145314894))) + i:HQ(829946603, (i[89](C7, 145314894)))))
                  X7(function()
                    a7:FireServer()
                  end)
                end
              end)
              task.delay(0.014925373134328358, function()
                j7.swingLocked = false
              end)
            end
            local function X7(C7)
              if sethiddenproperty then
                local a7 = i[48](322847803, 0)
                local A7 = a7
                local g7
                g7, a7 = pcall, i:rQ(A7 + 160933506)
                g7(function()
                  sethiddenproperty(C7, "PhysicsRepRootPart", C7)
                end)
              end
            end
            local function C7()
              if not j7.enabled then
                return
              end
              local a7, A7, g7 = Q7()
              if ((not a7 or not A7) or not g7) or (g7.Health <= 0) then
                return
              end
              if n7(A7) then
                e7()
                return
              end
              if j7.previousAutoRotate == nil then
                j7.previousAutoRotate = g7.AutoRotate
              end
              g7.AutoRotate = false
              r7(true)
              a7 = _7(A7)
              if a7 then
                local r7 = a7.Character and a7.Character:FindFirstChild("HumanoidRootPart")
                g7 = k7(a7, A7)
                if not r7 or not M7(r7.Position) then
                  return
                end
                if not _G.__CrystalTPBatIsInsideMap(r7.Position) then
                  _G.__CrystalTPBatForceMarker(a7, g7)
                  if n7(A7) then
                    e7()
                  end
                  return
                end
                local g7 = r7.CFrame
                local R7 = j7.samples[a7] or {}
                j7.samples[a7] = R7
                R7.safeCFrame = r7.CFrame
                R7.safePosition = r7.Position
                local a7, S7 = g7.Position + Vector3.new(0, 0.9, 0), g7.LookVector
                if (A7.Position - a7).Magnitude > K7() then
                  J7(A7, q7(a7, g7.Position, S7, A7.CFrame))
                else
                  J7(A7, q7(A7.Position, g7.Position, S7, A7.CFrame))
                end
                if sethiddenproperty then
                  local a7 = i[48](222424815, 0)
                  S7 = a7
                  R7 = nil
                  R7, a7 = pcall, i:rQ(S7 + 344439415)
                  R7(function()
                    if r7 then
                      sethiddenproperty(A7, "PhysicsRepRootPart", r7)
                    end
                  end)
                end
                local r7 = workspace.CurrentCamera
                if r7 then
                  local a7 = i[48](265396938, 0)
                  S7 = nil
                  S7, a7 = pcall, i[48](a7, 375661184)
                  S7(function()
                    r7.CFrame = CFrame.new(r7.CFrame.Position, g7.Position)
                  end)
                end
                e7()
              end
            end
            local function r7()
              if not j7.enabled then
                return
              end
              local a7, A7, g7 = Q7()
              if ((not a7 or not A7) or not g7) or (g7.Health <= 0) then
                return
              end
              if n7(A7) then
                e7()
                return
              end
              if j7.previousAutoRotate == nil then
                j7.previousAutoRotate = g7.AutoRotate
              end
              g7.AutoRotate = false
              a7 = _7(A7)
              if not a7 then
                return
              end
              local _7 = a7.Character and a7.Character:FindFirstChild("HumanoidRootPart")
              g7 = k7(a7, A7)
              local k7 = (_7 and _7.CFrame) or g7
              local R7, S7 = not _7, false
              if _7 then
                local Z7 = j7.samples[a7] or {}
                j7.samples[a7] = Z7
                S7 = ((_7.Position.Y < -9) or not _G.__CrystalTPBatIsInsideMap(_7.Position)) or not M7(_7.Position)
                if M7(_7.Position) and _G.__CrystalTPBatIsInsideMap(_7.Position) then
                  Z7.safeCFrame = _7.CFrame
                  Z7.safePosition = _7.Position
                else
                  k7 = g7
                  R7 = true
                end
              else
              end
              if not k7 then
                return
              end
              if R7 and S7 then
                _G.__CrystalTPBatForceMarker(a7, k7)
                if n7(A7) then
                  e7()
                  return
                end
              end
              g7 = k7.Position
              g7 = if not R7 then g7 + Vector3.new(0, 0.9, 0) else g7
              J7(A7, if (A7.Position - g7).Magnitude > K7() then q7(g7, k7.Position, k7.LookVector, A7.CFrame) else q7(A7.Position, k7.Position, k7.LookVector, A7.CFrame))
              if sethiddenproperty then
                local M7 = i[48](302811568, 0)
                a7 = nil
                a7, M7 = pcall, i[48](M7, 202207135)
                a7(function()
                  if _7 then
                    sethiddenproperty(A7, "PhysicsRepRootPart", _7)
                  end
                end)
              end
              local M7 = workspace.CurrentCamera
              if M7 then
                local n7 = i[48](80045345, 0)
                a7 = n7
                g7 = nil
                g7, n7 = pcall, i:rQ((i:HQ(496652920, a7) + i:HQ(496652920, 31870281)) + (i:HQ(3301661456, (i[79](a7, 31870281))) + i:HQ(496652921, (i[48](a7, 31870281)))))
                g7(function()
                  M7.CFrame = CFrame.new(M7.CFrame.Position, k7.Position)
                end)
              end
              e7()
            end
            local function M7()
              if _G.__batVersion == 2 then
                return r7()
              end
              return C7()
            end
            local function n7()
              local r7, J7 = j7.enabled, j7.returnGeneration
              d()
              j7.enabled = false
              if j7.heartbeat then
                j7.heartbeat:Disconnect()
                j7.heartbeat = nil
              end
              j7.target = nil
              j7.samples = {}
              j7.swingLocked = false
              local d, d, q7 = Q7()
              if d then
                local _7 = d.AssemblyLinearVelocity
                local k7 = Vector3.new(_7.X, 0, _7.Z)
                d.AssemblyLinearVelocity = Vector3.new((if k7.Magnitude > 120 then k7.Unit * 120 else k7).X, math.clamp(_7.Y, -50, 50), (if k7.Magnitude > 120 then k7.Unit * 120 else k7).Z)
                d.AssemblyAngularVelocity = Vector3.zero
                X7(d)
              end
              if q7 then
                q7.AutoRotate = ((j7.previousAutoRotate == nil) and true) or j7.previousAutoRotate
                pcall(function()
                  q7.PlatformStand = false
                  q7.Sit = false
                  local _7 = q7:GetState()
                  if ((_7 == Enum.HumanoidStateType.Physics) or (_7 == Enum.HumanoidStateType.Ragdoll)) or (_7 == Enum.HumanoidStateType.FallingDown) then
                    q7:ChangeState(Enum.HumanoidStateType.GettingUp)
                    q7:ChangeState(Enum.HumanoidStateType.Running)
                  end
                  _7 = workspace.CurrentCamera
                  if _7 then
                    _7.CameraSubject = q7
                  end
                end)
              end
              j7.previousAutoRotate = nil
              if r7 and d then
                task.spawn(function()
                  for q7 = 1, 12, 1 do
                    s.Heartbeat:Wait()
                    if j7.enabled or (j7.returnGeneration ~= J7) then
                      return
                    end
                    if _G.__CRYSTAL_STATE ~= b then
                      return
                    end
                    local _7, _7, k7 = Q7()
                    if ((_7 ~= d) or not k7) or (k7.Health <= 0) then
                      return
                    end
                    k7 = _7.AssemblyLinearVelocity
                    q7 = Vector3.new(k7.X, 0, k7.Z)
                    _7.AssemblyLinearVelocity = Vector3.new((if q7.Magnitude > 120 then q7.Unit * 120 else q7).X, math.clamp(k7.Y, -50, 50), (if q7.Magnitude > 120 then q7.Unit * 120 else q7).Z)
                    _7.AssemblyAngularVelocity = Vector3.zero
                    X7(_7)
                  end
                end)
              end
              if r7 then
                local d = i[48](325003311, 0)
                local r7
                r7, d = task, i:rQ(d + 24798093)
                r7.delay(0.4, function()
                  local d = i[48](426975203, 0)
                  local r7 = d
                  if j7.enabled or (j7.returnGeneration ~= J7) then
                    return
                  end
                  local J7, q7, _7 = _G, i:HQ(1606103500, r7) + i:HQ(1606103500, 505147092)
                  d, _7 = i:rQ(q7 + (i:HQ(2688863797, (i[79](r7, 505147092))) + i:HQ(2688863795, (i[89](r7, 505147092))))), J7.__CRYSTAL_STATE
                  d = i[48](d, 385634493)
                  if _7 ~= b then
                    return
                  end
                  pcall(function()
                    if _G.__CrystalAntiDieSet then
                      _G.__CrystalAntiDieSet(false)
                    end
                  end)
                end)
              else
                local b = i[48](191227310, 0)
                local d = b
                local r7
                r7, b = pcall, i:rQ((i:HQ(876841462, d) + i:HQ(876841462, 118563747)) + (i:HQ(2541284372, (i[79](d, 118563747))) + i:HQ(876841463, (i[48](d, 118563747)))))
                r7(function()
                  if _G.__CrystalAntiDieSet then
                    _G.__CrystalAntiDieSet(false)
                  end
                end)
              end
            end
            local b = {enabled = false, connection = nil, hitCooldown = false, antiDieConnections = {}}
            local function d()
              for r7, J7 in ipairs(b.antiDieConnections) do
                local q7 = i[48](339911237, 0)
                r7 = q7
                local _7
                _7, q7 = pcall, i:rQ((i:HQ(143753358, r7) + i:HQ(143753358, 423620792)) + (i:HQ(4007460580, (i[79](r7, 423620792))) + i:HQ(143753359, (i[48](r7, 423620792)))))
                _7(function()
                  J7:Disconnect()
                end)
              end
              b.antiDieConnections = {}
            end
            local function r7(J7)
              local q7 = i[48](65672623, 0)
              local _7 = q7
              d()
              q7 = i:rQ(_7 + 324783485)
              _7 = nil
              _7, q7 = not b.enabled, i:rQ(q7 + 195830508)
              if _7 or not J7 then
                return
              end
              local q7 = J7:FindFirstChildOfClass("Humanoid")
              if not q7 then
                return
              end
              pcall(function()
                q7.BreakJointsOnDeath = false
                q7:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                q7:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
              end)
              b.antiDieConnections[#b.antiDieConnections + 1] = q7:GetPropertyChangedSignal("Health"):Connect(function()
                if (b.enabled and q7.Parent) and (q7.Health <= 0) then
                  local J7 = i[48](139259338, 0)
                  local _7 = J7
                  local k7
                  k7, J7 = pcall, i:rQ((i:HQ(153413854, _7) + i:HQ(153413854, 445890551)) + (i:HQ(3988139588, (i[79](_7, 445890551))) + i:HQ(153413855, (i[48](_7, 445890551)))))
                  k7(function()
                    q7.Health = q7.MaxHealth
                    q7:ChangeState(Enum.HumanoidStateType.Running)
                  end)
                end
              end)
            end
            local function J7()
              local q7 = i[48](304825169, 0)
              q7 = i:rQ((i:HQ(42957357, q7) + i:HQ(42957357, 453891092)) + (i:HQ(4209052582, (i[79](q7, 453891092))) + i:HQ(42957358, (i[48](q7, 453891092)))))
              local _7 = F.Character
              local k7 = not _7
              q7 = i[48](q7, 433603192)
              if k7 then
                return nil
              end
              local function q7(e7)
                local C7 = e7.Name:lower()
                return e7:IsA("Tool") and (C7:find("bat") or C7:find("slap"))
              end
              for e7, e7 in ipairs(_7:GetChildren()) do
                if q7(e7) then
                  return e7
                end
              end
              k7 = F:FindFirstChildOfClass("Backpack")
              if k7 then
                for e7, C7 in ipairs(k7:GetChildren()) do
                  if q7(C7) then
                    local q7 = _7:FindFirstChildOfClass("Humanoid")
                    if q7 then
                      local _7 = i[48](144228562, 0)
                      e7 = nil
                      e7, _7 = pcall, i[48](_7, 475144993)
                      e7(function()
                        q7:EquipTool(C7)
                      end)
                    end
                    return C7
                  end
                end
              end
              return nil
            end
            local function q7(_7)
              local k7, e7 = math.huge
              for C7, a7 in ipairs(I:GetPlayers()) do
                C7 = (a7 ~= F) and a7.Character
                local A7, g7 = C7 and (C7:FindFirstChild("HumanoidRootPart")), C7 and (C7:FindFirstChildOfClass("Humanoid"))
                if (A7 and g7) and (g7.Health > 0) then
                  C7 = (_7.Position - A7.Position).Magnitude
                  if C7 < k7 then
                    k7, e7 = C7, a7
                  else
                  end
                else
                end
              end
              return e7, k7
            end
            local function _7()
              local k7 = i[48](40041754, 0)
              local e7 = k7
              if b.hitCooldown then
                return
              end
              k7 = i[48](e7, 451341446)
              b.hitCooldown = true
              e7 = nil
              e7, k7 = pcall, i:rQ((i:HQ(1728074483, k7) + i:HQ(1728074483, 469745906)) + (i:HQ(838818330, (i[79](k7, 469745906))) + i:HQ(1728074484, (i[48](k7, 469745906)))))
              e7(function()
                local k7 = J7()
                if not k7 then
                  return
                end
                k7:Activate()
                local e7 = k7:FindFirstChildWhichIsA("RemoteEvent")
                if e7 then
                  e7:FireServer()
                end
              end)
              task.delay(0.08, function()
                b.hitCooldown = false
              end)
            end
            local function k7()
              if not b.enabled then
                return
              end
              local e7 = F.Character
              local C7, a7 = e7 and (e7:FindFirstChild("HumanoidRootPart")), e7 and (e7:FindFirstChildOfClass("Humanoid"))
              if (not C7 or not a7) or (a7.Health <= 0) then
                return
              end
              local A7 = J7()
              if A7 and (A7.Parent ~= e7) then
                local J7 = i[48](225514836, 0)
                local g7 = J7
                local R7
                R7, J7 = pcall, i:rQ(g7 + 397204926)
                R7(function()
                  a7:EquipTool(A7)
                end)
              end
              local J7, a7 = q7(C7)
              local q7 = (J7 and J7.Character) and J7.Character:FindFirstChild("HumanoidRootPart")
              if not q7 or (a7 > 100) then
                return
              end
              C7.CFrame = CFrame.new(q7.Position + Vector3.new(0, 0.9, 0))
              C7.AssemblyLinearVelocity = q7.AssemblyLinearVelocity
              C7 = workspace.CurrentCamera
              if C7 then
                C7.CFrame = CFrame.new(C7.CFrame.Position, q7.Position)
              end
              _7()
              for J7, J7 in ipairs(e7:GetDescendants()) do
                if J7:IsA("BasePart") then
                  J7.CanCollide = false
                end
              end
            end
            local function J7(q7)
              q7 = q7 == true
              b.enabled = q7
              if b.connection then
                b.connection:Disconnect()
                b.connection = nil
              end
              d()
              if q7 then
                r7(F.Character)
                b.connection = s.Heartbeat:Connect(k7)
              end
              return b.enabled
            end
            _G.__CrystalTrackConn(F.CharacterAdded:Connect(function(d)
              if b.enabled then
                task.wait(0.1)
                r7(d)
              end
            end))
            l["TP Bat"] = function(d)
              if d then
                O7("TP Bat")
                _G.__deactivateBatExclusive("TP Bat")
              end
              return J7(d)
            end
            _G.__CrystalTrackStopper(function()
              pcall(J7, false)
              pcall(n7)
              pcall(z7)
            end)
            _G.CrystalAutoBat = {GetVersion = function()
              return _G.__batVersion or 1
            end, SetVersion = function(d)
              _G.__batVersion = ((tonumber(d) == 2) and 2) or 1
              j7.samples = {}
              j7.lastPosition = nil
              j7.lastSampleTime = tick()
              j7.recoverUntil = 0
              j7.physicsPauseUntil = 0
              if _G.__batVersionPill then
                _G.__batVersionPill.Text = "V" .. tostring(_G.__batVersion)
              end
              if _G.__CrystalUpdateBatVersionButton then
                _G.__CrystalUpdateBatVersionButton()
              end
              if _G.__CrystalRefreshVisibleTPBatConfig then
                _G.__CrystalRefreshVisibleTPBatConfig()
              end
              w7()
              if j7.enabled then
                local d, d = Q7()
                if d then
                  X7(d)
                end
                M7()
              end
              return _G.__batVersion
            end, GetV2Distance = K7, SetV2Distance = function(d)
              local O7 = tonumber((tostring(d):gsub(",", ".")))
              d = (O7 and (O7 == O7)) and (math.abs(O7) < math.huge)
              if d then
                _G.__tpBatV2Distance = math.floor((math.clamp(O7, 0, 100) * 100) + 0.5) / 100
              end
              if _G.__CrystalUpdateBatVersionButton then
                _G.__CrystalUpdateBatVersionButton()
              end
              if _G.__CrystalRefreshVisibleTPBatConfig then
                _G.__CrystalRefreshVisibleTPBatConfig()
              end
              if d then
                w7()
                if j7.enabled then
                  M7()
                end
              end
              return K7()
            end, SetEnabled = function(d)
              d = d == true
              h["TP Bat"] = d
              if V["TP Bat"] then
                pcall(V["TP Bat"], d)
              end
              l["TP Bat"](d)
              if Y["TP Bat"] then
                pcall(Y["TP Bat"])
              end
              w7()
              return b.enabled
            end, Toggle = function()
              return _G.CrystalAutoBat.SetEnabled(not (h["TP Bat"] == true))
            end, Stop = function()
              pcall(J7, false)
            end}
          end
        end)()
        local b = U7(C, "Drop", "Drop")
        pcall(function()
          v(b)
        end)
        local b = U7(C, "Auto Grab", "auto steal")
        pcall(function()
          v(b)
        end)
        do
          local b = Instance.new("Frame", p)
          b.Name = "CrystalAutoGrabBar"
          b.AnchorPoint = Vector2.new(0, 0)
          local v = (M and 270) or 360
          T = (M and 240) or 320
          local d = math.floor((v + T) / 2)
          local O7, M7 = _G._CrystalHub_UI_AutoGrabBarSize, ((_G._CrystalHub_UI_AutoGrabExpanded ~= nil) and _G._CrystalHub_UI_AutoGrabExpanded) or true
          C = tonumber(O7)
          local U7 = ((if C and (C < T) then nil else C) and math.clamp(if C and (C < T) then nil else C, T, v)) or v
          local n7 = (O7 and tonumber(O7)) and (tonumber(O7) <= T)
          if n7 then
            M7 = false
          else
          end
          _G._CrystalHub_UI_AutoGrabExpanded = M7
          b.Size = UDim2.new(0, U7, 0, (M and 52) or 64)
          O7 = _G._CrystalHub_UI_AutoGrabBarPos
          if (O7 and O7.x) and O7.y then
            b.Position = UDim2.fromOffset(O7.x, O7.y)
          else
            b.Position = UDim2.new(0.5, -U7 / 2, 0.8, 0)
          end
          b.BackgroundColor3 = Color3.fromRGB(4, 4, 6)
          b.BackgroundTransparency = 0
          b.BorderSizePixel = 0
          b.ZIndex = 500
          b.Active = true
          b.Draggable = false
          b.Visible = h["Steal Bar"] == true
          b.ClipsDescendants = true
          Instance.new("UICorner", b).CornerRadius = UDim.new(0, (M and 11) or 13)
          local Q7 = Instance.new("UIStroke", b)
          Q7.Color = Color3.fromRGB(55, 55, 60)
          Q7.Thickness = 1.2
          Q7.Transparency = 0.18
          Q7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          O7 = Instance.new("UIGradient", b)
          O7.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(13, 13, 17)), ColorSequenceKeypoint.new(0.55, Color3.fromRGB(5, 5, 8)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))})
          O7.Rotation = 90
          n7 = Instance.new("Frame", b)
          n7.Size = UDim2.new(0, (M and 70) or 82, 1, -4)
          n7.Position = UDim2.new(1, (M and -72) or -84, 0, 2)
          n7.BackgroundTransparency = 1
          n7.Visible = false
          n7.ZIndex = 504
          local j7 = Instance.new("Frame", n7)
          j7.Name = "Divider"
          j7.Size = UDim2.new(0, 1, 1, -10)
          j7.Position = UDim2.new(0, 0, 0, 5)
          j7.BorderSizePixel = 0
          j7.BackgroundColor3 = Color3.fromRGB(58, 58, 64)
          j7.BackgroundTransparency = 0.25
          j7.ZIndex = 505
          x = Instance.new("TextLabel", n7)
          x.Size = UDim2.new(1, -10, 0, 14)
          x.Position = UDim2.new(0, (M and 7) or 9, 0, (M and 6) or 9)
          x.BackgroundTransparency = 1
          x.TextColor3 = Color3.fromRGB(245, 245, 248)
          x.Font = Enum.Font.GothamBold
          x.TextSize = (M and 8) or 9
          x.TextXAlignment = Enum.TextXAlignment.Left
          x.ZIndex = 506
          x.Visible = false
          H = Instance.new("TextLabel", n7)
          H.Size = UDim2.new(1, -10, 0, 14)
          H.Position = UDim2.new(0, (M and 7) or 9, 0, (M and 23) or 27)
          H.BackgroundTransparency = 1
          H.TextColor3 = Color3.fromRGB(200, 200, 208)
          H.Font = Enum.Font.GothamBold
          H.TextSize = (M and 8) or 9
          H.TextXAlignment = Enum.TextXAlignment.Left
          H.ZIndex = 506
          H.Visible = false
          local x = Instance.new("TextLabel", n7)
          x.Size = UDim2.new(0, 54, 1, 0)
          x.Position = UDim2.new(1, -84, 0, 0)
          x.BackgroundTransparency = 1
          x.TextColor3 = Color3.fromRGB(255, 255, 255)
          x.Font = Enum.Font.GothamBold
          x.TextSize = 11
          x.TextXAlignment = Enum.TextXAlignment.Right
          x.ZIndex = 502
          x.Visible = false
          local r7 = Instance.new("TextButton", b)
          r7.Size = UDim2.new(0, 16, 0, 16)
          r7.Position = UDim2.new(1, -22, 0, 3)
          r7.AnchorPoint = Vector2.new(0, 0)
          r7.BackgroundTransparency = 0.2
          r7.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
          r7.TextColor3 = Color3.fromRGB(235, 240, 245)
          r7.Font = Enum.Font.GothamBold
          r7.TextSize = 10
          r7.Text = (M7 and "-") or "+"
          r7.Visible = false
          Instance.new("UICorner", r7).CornerRadius = UDim.new(1, 0)
          r7.ZIndex = 510
          local J7
          local function q7(_7)
            local z7 = i[48](150449318, 0)
            local K7 = z7
            local k7
            z7, k7 = i:rQ(K7 + 340627620), not _7 or (tonumber(_7) == nil)
            if k7 then
              return
            end
            K7 = pcall
            z7 = i:rQ(z7 - 76133145)
            if K7(function()
              if (b and b.Size) and b.Size.Y then
                local z7 = b.Size.Y.Offset or ((M and 52) or 64)
                b.Size = UDim2.new(0, tonumber(_7), 0, z7)
              end
              if J7 and J7.Size then
                J7.Size = UDim2.new(1, (M and -76) or -88, 1, -4)
              end
            end) then
              _G._CrystalHub_UI_AutoGrabBarSize = tonumber(_7)
              pcall(w7)
            end
          end
          n7 = not M7
          if n7 then
            q7(d)
          end
          r7.MouseButton1Click:Connect(function()
            M7 = not M7
            _G._CrystalHub_UI_AutoGrabExpanded = M7
            local _7 = M7
            if _7 then
              q7(v)
              r7.Text = "-"
            else
              q7(d)
              r7.Text = "+"
            end
          end)
          b.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
          O7.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 28)), ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12))})
          Q7.Color = Color3.fromRGB(55, 55, 65)
          Q7.Thickness = 1.4
          Q7.Transparency = 0.25
          local v = Instance.new("ImageLabel", b)
          v.Name = "StealBarIcon"
          v.Size = UDim2.new(1, 0, 1, 0)
          v.Position = UDim2.new(0, 0, 0, 0)
          v.BackgroundTransparency = 1
          v.BorderSizePixel = 0
          v.Image = "rbxassetid://76726910160327"
          v.ScaleType = Enum.ScaleType.Crop
          v.ImageTransparency = 0.1
          v.ZIndex = 501
          v.ClipsDescendants = true
          Instance.new("UICorner", v).CornerRadius = UDim.new(0, (M and 11) or 13)
          local d = Instance.new("TextButton", b)
          d.Size = UDim2.new(0, 28, 0, 16)
          d.Position = UDim2.new(0, 12, 0, (M and 8) or 10)
          d.BackgroundColor3 = Color3.fromRGB(140, 90, 220)
          d.BorderSizePixel = 0
          d.Text = "V1"
          d.Font = Enum.Font.GothamBlack
          d.TextSize = 9
          d.TextColor3 = Color3.fromRGB(255, 255, 255)
          d.ZIndex = 506
          d.AutoButtonColor = false
          Instance.new("UICorner", d).CornerRadius = UDim.new(0, 5)
          O7 = Instance.new("TextLabel", b)
          O7.Size = UDim2.new(1, -90, 0, 18)
          O7.Position = UDim2.new(0, 46, 0, (M and 7) or 9)
          O7.BackgroundTransparency = 1
          O7.Text = "AUTO GRAB"
          O7.Font = Enum.Font.GothamBlack
          O7.TextSize = (M and 11) or 12
          O7.TextColor3 = Color3.fromRGB(245, 245, 250)
          O7.TextXAlignment = Enum.TextXAlignment.Left
          O7.ZIndex = 506
          local M7 = Instance.new("TextLabel", b)
          M7.Size = UDim2.new(0, 52, 0, 18)
          M7.Position = UDim2.new(1, -60, 0, (M and 7) or 9)
          M7.BackgroundTransparency = 1
          M7.Text = "0%"
          M7.Font = Enum.Font.GothamBlack
          M7.TextSize = (M and 14) or 16
          M7.TextColor3 = Color3.fromRGB(245, 245, 250)
          M7.TextXAlignment = Enum.TextXAlignment.Right
          M7.ZIndex = 506
          J7 = Instance.new("Frame", b)
          J7.Size = UDim2.new(1, (M and -20) or -24, 0, 11)
          J7.Position = UDim2.new(0, (M and 10) or 12, 1, (M and -18) or -20)
          J7.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
          J7.BorderSizePixel = 0
          J7.ZIndex = 504
          Instance.new("UICorner", J7).CornerRadius = UDim.new(1, 0)
          Instance.new("UIStroke", J7).Transparency = 1
          local r7 = Instance.new("Frame", J7)
          r7.Size = UDim2.new(0, 0, 1, 0)
          r7.Position = UDim2.new(0, 0, 0, 0)
          r7.BorderSizePixel = 0
          r7.BackgroundColor3 = Color3.fromRGB(255, 90, 160)
          r7.ClipsDescendants = true
          r7.ZIndex = 505
          Instance.new("UICorner", r7).CornerRadius = UDim.new(1, 0)
          local q7 = Instance.new("UIGradient", r7)
          local _7 = Instance.new("Frame")
          _7.Name = "ProgressInsetGlow"
          _7.Size = UDim2.new(0, (M and 54) or 72, 1, -2)
          _7.AnchorPoint = Vector2.new(0.5, 0.5)
          _7.Position = UDim2.new(1, (M and -39) or -52, 0.5, 0)
          _7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
          _7.BackgroundTransparency = 0.25
          _7.BorderSizePixel = 0
          _7.ZIndex = 505
          _7.Parent = r7
          Instance.new("UICorner", _7).CornerRadius = UDim.new(1, 0)
          O7 = Instance.new("UIStroke")
          O7.Color = Color3.fromRGB(255, 255, 255)
          O7.Thickness = (M and 2) or 3
          O7.Transparency = 0.42
          O7.Parent = _7
          n7 = Instance.new("UIGradient")
          n7.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.52, 0.02), NumberSequenceKeypoint.new(1, 1)})
          n7.Parent = _7
          local z7 = Instance.new("Frame")
          z7.Name = "ProgressInsetShine"
          z7.Size = UDim2.new(0, (M and 32) or 42, 1, -4)
          z7.AnchorPoint = Vector2.new(0.5, 0.5)
          z7.Position = UDim2.new(1, (M and -28) or -37, 0.5, 0)
          z7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
          z7.BackgroundTransparency = 0.06
          z7.BorderSizePixel = 0
          z7.ZIndex = 506
          z7.Parent = r7
          Instance.new("UICorner", z7).CornerRadius = UDim.new(1, 0)
          O7 = Instance.new("UIGradient")
          O7.Rotation = 0
          O7.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.42, 0.05), NumberSequenceKeypoint.new(1, 1)})
          O7.Parent = z7
          task.spawn(function()
            while _7.Parent and z7.Parent do
              local K7, k7 = c:Create(_7, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.02}), c:Create(z7, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
              K7:Play()
              k7:Play()
              K7.Completed:Wait()
              if not _7.Parent or not z7.Parent then
                break
              end
              k7, K7 = c:Create(_7, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0.32}), c:Create(z7, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0.16})
              k7:Play()
              K7:Play()
              k7.Completed:Wait()
            end
          end)
          local _7 = Color3.fromRGB(255, 90, 160)
          local function z7()
            if typeof(_G.__CrystalCurtAccent) == "Color3" then
              return _G.__CrystalCurtAccent
            end
            if typeof(_G.__CrystalThemeAccent) == "Color3" then
              return _G.__CrystalThemeAccent
            end
            local K7 = tonumber(_G._CrystalHub_UI_BgIndex) or 1
            if K7 == 2 then
              return Color3.fromRGB(255, 120, 214)
            end
            if K7 == 3 then
              return Color3.fromRGB(89, 176, 255)
            end
            return Color3.fromRGB(255, 90, 160)
          end
          x = p:FindFirstChild("KYejuTopStatus")
          if x then
            x:Destroy()
          end
          local K7 = Instance.new("Frame")
          K7.Name = "KYejuTopStatus"
          K7.AnchorPoint = Vector2.new(0.5, 0)
          K7.Position = UDim2.new(0.5, 0, 0, (M and 36) or 56)
          K7.Size = UDim2.fromOffset((M and 390) or 620, (M and 46) or 54)
          K7.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
          K7.BackgroundTransparency = 0.08
          K7.BorderSizePixel = 0
          K7.ClipsDescendants = true
          K7.ZIndex = 750
          K7.Parent = p
          Instance.new("UICorner", K7).CornerRadius = UDim.new(1, 0)
          local k7 = Instance.new("UIStroke")
          k7.Color = Color3.fromRGB(255, 90, 160)
          k7.Thickness = (M and 1.3) or 1.6
          k7.Transparency = 0.22
          k7.Parent = K7
          local e7 = Instance.new("ImageLabel")
          e7.Name = "ThemeImage"
          e7.Size = UDim2.fromScale(1, 1)
          e7.BackgroundTransparency = 1
          e7.BorderSizePixel = 0
          e7.Image = "rbxassetid://76726910160327"
          e7.ImageTransparency = 0.58
          e7.ScaleType = Enum.ScaleType.Crop
          e7.ZIndex = 751
          e7.Parent = K7
          Instance.new("UICorner", e7).CornerRadius = UDim.new(1, 0)
          O7 = Instance.new("Frame")
          O7.Size = UDim2.fromScale(1, 1)
          O7.BackgroundColor3 = Color3.fromRGB(3, 3, 5)
          O7.BackgroundTransparency = 0.24
          O7.BorderSizePixel = 0
          O7.ZIndex = 752
          O7.Parent = K7
          Instance.new("UICorner", O7).CornerRadius = UDim.new(1, 0)
          local X7 = Instance.new("TextLabel")
          X7.Name = "Brand"
          X7.Size = UDim2.new(0, (M and 118) or 166, 1, 0)
          X7.Position = UDim2.new(0, (M and 18) or 28, 0, 0)
          X7.BackgroundTransparency = 1
          X7.Text = "vless hub"
          X7.Font = Enum.Font.GothamBlack
          X7.TextSize = (M and 15) or 20
          X7.TextColor3 = Color3.fromRGB(255, 255, 255)
          X7.TextXAlignment = Enum.TextXAlignment.Left
          X7.ZIndex = 753
          X7.Parent = K7
          local C7 = Instance.new("Frame")
          C7.Size = UDim2.new(0, 1, 0, (M and 24) or 34)
          C7.Position = UDim2.new(0, (M and 145) or 205, 0.5, (M and -12) or -17)
          C7.BackgroundColor3 = Color3.fromRGB(255, 90, 160)
          C7.BackgroundTransparency = 0.35
          C7.BorderSizePixel = 0
          C7.ZIndex = 753
          C7.Parent = K7
          local a7 = Instance.new("TextLabel")
          a7.Size = UDim2.new(0, (M and 70) or 90, 0, (M and 28) or 34)
          a7.Position = UDim2.new(0, (M and 167) or 230, 0, (M and 11) or 12)
          a7.BackgroundTransparency = 1
          a7.Text = "FPS\n--"
          a7.Font = Enum.Font.GothamBold
          a7.TextSize = (M and 11) or 13
          a7.TextColor3 = Color3.fromRGB(255, 255, 255)
          a7.TextXAlignment = Enum.TextXAlignment.Center
          a7.TextYAlignment = Enum.TextYAlignment.Center
          a7.RichText = true
          a7.ZIndex = 753
          a7.Parent = K7
          local A7 = Instance.new("TextLabel")
          A7.Size = UDim2.new(0, (M and 78) or 100, 0, (M and 28) or 34)
          A7.Position = UDim2.new(0, (M and 248) or 335, 0, (M and 11) or 12)
          A7.BackgroundTransparency = 1
          A7.Text = "PING\n--ms"
          A7.Font = Enum.Font.GothamBold
          A7.TextSize = (M and 11) or 13
          A7.TextColor3 = Color3.fromRGB(255, 255, 255)
          A7.TextXAlignment = Enum.TextXAlignment.Center
          A7.TextYAlignment = Enum.TextYAlignment.Center
          A7.RichText = true
          A7.ZIndex = 753
          A7.Parent = K7
          local g7 = Instance.new("TextLabel")
          g7.Size = UDim2.new(0, (M and 44) or 105, 1, 0)
          g7.Position = UDim2.new(1, (M and -58) or -130, 0, 0)
          g7.BackgroundTransparency = 1
          g7.Text = "vless hub"
          g7.Font = Enum.Font.GothamBlack
          g7.TextSize = (M and 10) or 13
          g7.TextColor3 = Color3.fromRGB(255, 255, 255)
          g7.TextXAlignment = Enum.TextXAlignment.Right
          g7.ZIndex = 753
          g7.Parent = K7
          local R7, S7 = 0, 0
          _G.__CrystalTrackConn(s.RenderStepped:Connect(function(Z7)
            local f7 = i[48](221349022, 0)
            local Y7 = f7
            R7 += 1
            S7 += Z7 or 0
            Z7 = S7 < 0.5
            f7 = i[48](Y7, 531930806)
            if Z7 then
              return
            end
            local Z7, Y7, V7, v7 = math.max, math.floor, i:HQ(955138452, f7) + i:HQ(955138452, 343216110)
            f7, v7 = i:rQ(V7 + (i:HQ(2384690392, (i[79](f7, 343216110))) + i:HQ(955138453, (i[48](f7, 343216110))))), Z7(0, Y7((R7 / S7) + 0.5))
            local Z7 = 0
            pcall(function()
              Z7 = math.max(0, math.floor((F:GetNetworkPing() * 1000) + 0.5))
            end)
            a7.Text = "FPS\n" .. tostring(v7)
            A7.Text = "PING\n" .. (tostring(Z7) .. "ms")
            R7, S7 = 0, 0
          end))
          function _G.__CrystalApplyKYejuTopHudTheme(a7)
            local A7, R7 = (_G.__CrystalHalloweenMode == true) or (h and (h["Halloween Mode"] == true)), (tonumber(a7) or tonumber(_G._CrystalHub_UI_BgIndex)) or 1
            if A7 then
              e7.Image = "rbxassetid://137243658623567"
            elseif R7 == 3 then
              e7.Image = "rbxassetid://83731025274455"
            elseif R7 == 2 then
              e7.Image = "rbxassetid://72278286257412"
            else
              e7.Image = "rbxassetid://76726910160327"
            end
            a7 = z7()
            k7.Color = a7:Lerp(Color3.fromRGB(255, 255, 255), 0.15)
            C7.BackgroundColor3 = a7
            X7.TextColor3 = a7:Lerp(Color3.fromRGB(255, 255, 255), 0.35)
            g7.TextColor3 = a7:Lerp(Color3.fromRGB(255, 255, 255), 0.35)
          end
          K7.Active = true
          do
            local k7, X7, C7 = false
            local function a7()
              return h["Lock Buttons"] == true
            end
            local function A7()
              K7.Visible = not (h["Hide Status Bar"] == true)
            end
            function _G.__CrystalSetStatusBarVisible(g7)
              h["Hide Status Bar"] = not (g7 == true)
              A7()
              if Y["Hide Status Bar"] then
                pcall(Y["Hide Status Bar"])
              end
              if w7 then
                pcall(w7)
              end
            end
            l["Hide Status Bar"] = function(g7)
              A7()
            end
            n7 = _G._CrystalHub_UI_StatusBarPos
            if ((type(n7) == "table") and (n7.x ~= nil)) and (n7.y ~= nil) then
              K7.AnchorPoint = Vector2.new(0.5, 0)
              O7, x = UDim2.new, tonumber
              local g7, R7 = x(n7.x) or 0, tonumber(n7.y) or ((M and 36) or 56)
              K7.Position = O7(0.5, g7, 0, R7)
            end
            function _G.__CrystalGuiPositionResetters.KYejuTopStatus()
              k7 = false
              K7.AnchorPoint = Vector2.new(0.5, 0)
              K7.Position = UDim2.new(0.5, 0, 0, (M and 36) or 56)
              _G._CrystalHub_UI_StatusBarPos = nil
            end
            K7.InputBegan:Connect(function(x)
              local n7 = i[48](271678675, 0)
              local g7 = n7
              if a7() then
                return
              end
              local R7, S7
              R7, S7, n7 = x.UserInputType, Enum.UserInputType.MouseButton1, i:rQ(g7 + 141970448)
              if (R7 ~= S7) and (x.UserInputType ~= Enum.UserInputType.Touch) then
                return
              end
              k7 = true
              X7 = x.Position
              C7 = K7.Position
              g7 = nil
              g7, n7 = x.Changed, i:rQ(n7 + 357930110)
              g7:Connect(function()
                local n7 = x.UserInputState == Enum.UserInputState.End
                if n7 then
                  local x = k7
                  if x then
                    k7 = false
                    _G._CrystalHub_UI_StatusBarPos = {x = K7.Position.X.Offset, y = K7.Position.Y.Offset}
                    if w7 then
                      pcall(w7)
                    end
                  end
                end
              end)
            end)
            _G.__CrystalTrackConn(D.InputChanged:Connect(function(x)
              local n7 = not k7 or a7()
              if n7 then
                return
              end
              if (x.UserInputType ~= Enum.UserInputType.MouseMovement) and (x.UserInputType ~= Enum.UserInputType.Touch) then
                return
              end
              local n7, k7, a7, g7 = x.Position - X7, (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1920, 1080), K7.AbsoluteSize.X, K7.AbsoluteSize.Y
              local x, X7, R7, S7, Z7 = C7.X.Offset + n7.X, C7.Y.Offset + n7.Y, (-k7.X * 0.5) + (a7 * 0.5), (k7.X * 0.5) - (a7 * 0.5), math.max(0, k7.Y - g7)
              x, X7 = math.clamp(x, R7, S7), math.clamp(X7, 0, Z7)
              K7.Position = UDim2.new(0.5, x, 0, X7)
            end))
            A7()
            task.defer(A7)
          end
          local function x(n7)
            _7 = z7()
            local z7, K7, k7, X7, C7 = ColorSequence.new, {}, ColorSequenceKeypoint.new, _7, Color3
            local a7, A7, g7, R7, S7 = k7(0, X7:Lerp(C7.fromRGB(255, 255, 255), 0.25)), ColorSequenceKeypoint.new(0.5, _7), ColorSequenceKeypoint.new, _7, Color3.fromRGB
            i:yQ(K7, 0, a7, A7, g7(1, R7:Lerp(S7(40, 0, 40), 0.2)))
            q7.Color = z7(K7)
            r7.BackgroundColor3 = _7
            R7 = _7
            d.BackgroundColor3 = R7:Lerp(Color3.fromRGB(80, 40, 160), 0.35)
            C7 = _7
            Q7.Color = C7:Lerp(Color3.fromRGB(255, 255, 255), 0.15)
            Q7.Transparency = 0.35
            if M7 then
              M7.TextColor3 = Color3.fromRGB(245, 245, 250)
            end
            if H then
              A7 = _7
              H.TextColor3 = A7:Lerp(Color3.fromRGB(255, 255, 255), 0.28)
            end
            if j7 then
              C7 = _7
              j7.BackgroundColor3 = C7:Lerp(Color3.fromRGB(0, 0, 0), 0.55)
            end
            if v then
              k7, g7 = (_G.__CrystalHalloweenMode == true) or (h and (h["Halloween Mode"] == true)), tonumber(_G._CrystalHub_UI_BgIndex) or 1
              if k7 then
                v.Image = "rbxassetid://137243658623567"
              elseif g7 == 3 then
                v.Image = "rbxassetid://83731025274455"
              elseif g7 == 2 then
                v.Image = "rbxassetid://72278286257412"
              else
                v.Image = "rbxassetid://76726910160327"
              end
              v.Visible = true
              v.ScaleType = Enum.ScaleType.Crop
              v.Size = UDim2.new(1, 0, 1, 0)
              v.Position = UDim2.new(0, 0, 0, 0)
            end
            if e7 and v then
              e7.Image = v.Image
            end
            if type(_G.__CrystalApplyKYejuTopHudTheme) == "function" then
              pcall(_G.__CrystalApplyKYejuTopHudTheme, n7)
            end
            K7 = (tonumber(n7) or tonumber(_G._CrystalHub_UI_BgIndex)) or 1
            if type(_G.__CrystalSetStealBarParticles) == "function" then
              pcall(_G.__CrystalSetStealBarParticles, K7 == 2, K7)
            elseif type(setThemeParticles) == "function" then
              pcall(setThemeParticles, K7 == 2, K7)
            end
          end
          local v = Instance.new("Frame", b)
          v.Name = "ThemeParticles"
          v.Size = UDim2.new(1, 0, 1, 0)
          v.BackgroundTransparency = 1
          v.ZIndex = 520
          v.ClipsDescendants = true
          v.Visible = false
          local H, n7 = false
          local j7 = 0
          local function q7()
            for z7, K7 in ipairs(v:GetChildren()) do
              local k7 = i[48](438146890, 0)
              z7 = k7
              local e7
              e7, k7 = pcall, i:rQ(z7 + 262460425)
              e7(function()
                K7:Destroy()
              end)
            end
          end
          local function z7()
            H = false
            v.Visible = false
            local K7 = n7
            if K7 then
              local K7 = i[48](263503749, 0)
              local k7 = K7
              local e7
              e7, K7 = pcall, i:rQ(k7 + 263097321)
              e7(function()
                n7:Disconnect()
              end)
              n7 = nil
            end
            q7()
          end
          local function q7()
            local K7 = i[48](158550307, 0)
            local k7 = K7
            local e7 = H and n7
            if e7 then
              v.Visible = true
              return
            end
            z7()
            K7, H = i:rQ(k7 + 122078156), true
            K7 = i:rQ(K7 + 148154242)
            v.Visible = true
            j7 = 0
            n7 = s.Heartbeat:Connect(function(K7)
              local k7 = H
              if not k7 then
                return
              end
              if not b.Parent or (b.Visible == false) then
                return
              end
              j7 += K7 or 0
              k7, K7 = math.max(1, b.AbsoluteSize.X), math.max(1, b.AbsoluteSize.Y)
              while true do
                local H = j7
                if not (H >= 0.055) then
                  break
                end
                local e7 = i[48](42675068, 0)
                H = e7
                j7 -= 0.055
                local j7 = #v:GetChildren()
                if j7 >= 36 then
                  break
                end
                local X7 = Instance.new("Frame")
                e7 = i:rQ(H + 265810997)
                local H = math.random(3, 6)
                X7.Size = UDim2.fromOffset(H, H)
                X7.Position = UDim2.fromOffset(math.random(0, math.floor(k7)), -H)
                X7.BackgroundColor3 = Color3.fromRGB(255, math.random(80, 170), math.random(180, 240))
                X7.BackgroundTransparency = math.random(5, 25) / 100
                X7.BorderSizePixel = 0
                X7.ZIndex = 521
                local k7, C7, a7 = Instance.new("UICorner", X7), UDim.new, i:rQ(j7)
                e7, k7.CornerRadius = i:rQ((i:HQ(439734093, 4294967295) + e7) + (i:HQ(3618724170, a7) + i:HQ(3618724170, (i[100](a7))))), C7(1, 0)
                X7.Parent = v
                local v = math.random(32, 62)
                local j7, k7 = math.random(-14, 14), 0
                local e7 = math.max(8, K7 * 0.55)
                local C7 = math.max(e7 + 6, K7 * 0.92)
                local K7
                K7 = s.Heartbeat:Connect(function(a7)
                  if not X7.Parent then
                    if K7 then
                      K7:Disconnect()
                    end
                    return
                  end
                  k7 += a7 or 0
                  local A7, g7 = k7 * v, X7.Position.X.Offset + (j7 * (a7 or 0))
                  X7.Position = UDim2.fromOffset(g7, A7 - H)
                  if A7 >= C7 then
                    if K7 then
                      K7:Disconnect()
                    end
                    X7:Destroy()
                    return
                  elseif A7 >= e7 then
                    a7 = (A7 - e7) / math.max(1, C7 - e7)
                    X7.BackgroundTransparency = math.clamp(0.08 + (a7 * 0.92), 0, 1)
                  else
                    X7.BackgroundTransparency = 0.08
                  end
                end)
              end
            end)
            _G.__CrystalTrackConn(n7)
          end
          local function v(H, n7)
            H = (tonumber(n7) or tonumber(_G._CrystalHub_UI_BgIndex)) or 1
            if not ((_G.__CrystalHalloweenMode == true) or (h and (h["Halloween Mode"] == true))) and (H == 2) then
              q7()
            else
              z7()
            end
          end
          _G.__CrystalApplyAutoStealBarTheme = x
          _G.__CrystalSetStealBarParticles = v
          x(_G.__CrystalGuiTheme or "GUI 1")
          O7 = tonumber(_G._CrystalHub_UI_BgIndex) or 1
          v(O7 == 2, O7)
          local v, x = M7, {v1 = "V1", v2 = "V2"}
          local function H(O7)
            return x[O7] or "V1"
          end
          local x = d
          x.Text = H(r)
          local function O7()
            d.Text = string.upper(tostring(r or "v1"))
          end
          O7()
          local function n7()
            r = ((r == "v2") and "v1") or "v2"
            O7()
            if h["auto steal"] and l["auto steal"] then
              pcall(l["auto steal"], false)
              pcall(l["auto steal"], true)
            end
            local j7 = _G.CrystalAutoGrab and _G.CrystalAutoGrab.SetMode
            if j7 then
              pcall(_G.CrystalAutoGrab.SetMode, r)
            end
            j7 = type(_G.__CrystalRefreshAutoStealModeUI) == "function"
            if j7 then
              pcall(_G.__CrystalRefreshAutoStealModeUI, r)
            end
            w7()
            j7 = r
            return j7
          end
          _G.__CrystalSwitchAutoStealVersion = n7
          _G.__CrystalRefreshStealBarModePill = O7
          local function O7()
            n7()
          end
          d.MouseButton1Click:Connect(O7)
          local O7, n7, j7 = false
          function _G.__CrystalGuiPositionResetters.AutoGrab()
            O7, n7, j7 = false, nil, nil
            b.AnchorPoint = Vector2.new(0, 0)
            b.Position = UDim2.new(0.5, -U7 / 2, 0.8, 0)
            _G._CrystalHub_UI_AutoGrabBarPos = nil
          end
          b.InputBegan:Connect(function(U7)
            local q7 = (U7.UserInputType == Enum.UserInputType.MouseButton1) or (U7.UserInputType == Enum.UserInputType.Touch)
            if q7 then
              O7 = true
              n7 = {pointer = U7.Position, position = b.AbsolutePosition}
              local q7 = U7.UserInputType == Enum.UserInputType.Touch
              if q7 then
                j7 = U7
              end
            end
          end)
          b.InputChanged:Connect(function(U7)
            local q7 = (U7.UserInputType == Enum.UserInputType.MouseMovement) or (U7.UserInputType == Enum.UserInputType.Touch)
            if q7 then
              j7 = U7
            end
          end)
          _G.__CrystalTrackConn(D.InputChanged:Connect(function(U7)
            local q7 = (not O7 or not n7) or (U7 ~= j7)
            if q7 then
              return
            end
            if (U7.UserInputType ~= Enum.UserInputType.MouseMovement) and (U7.UserInputType ~= Enum.UserInputType.Touch) then
              return
            end
            q7 = U7.Position - n7.pointer
            local U7, z7 = n7.position.X + q7.X, n7.position.Y + q7.Y
            b.Position = UDim2.fromOffset(U7, z7)
          end))
          _G.__CrystalTrackConn(D.InputEnded:Connect(function(U7)
            local q7 = O7 and ((U7.UserInputType == Enum.UserInputType.MouseButton1) or (U7.UserInputType == Enum.UserInputType.Touch))
            if q7 then
              O7 = false
              U7 = b.AbsolutePosition
              b.AnchorPoint = Vector2.new(0, 0)
              b.Position = UDim2.fromOffset(U7.X, U7.Y)
              _G._CrystalHub_UI_AutoGrabBarPos = {x = U7.X, y = U7.Y}
              n7, j7 = nil, nil
              w7()
            end
          end))
          local O7 = {displayProgress = 0, radiusProgress = 0, targetInRadius = false, radiusCheckElapsed = 0, uiElapsed = 0, lastVisible = nil, lastPercent = nil, lastActive = nil, lastMode = nil}
          l["Steal Bar"] = function(U7)
            local n7 = U7 == true
            b.Visible = n7
            O7.lastVisible = n7
          end
          _G.__CrystalTrackConn(s.Heartbeat:Connect(function(U7)
            O7.uiElapsed = O7.uiElapsed + (U7 or 0)
            if O7.uiElapsed < 0.05 then
              return
            end
            U7 = O7.uiElapsed
            O7.uiElapsed = 0
            local n7 = O7.lastMode ~= r
            if n7 then
              O7.lastMode = r
              if d then
                d.Text = H(r)
              end
            end
            if h["Steal Bar"] ~= true then
              if O7.lastVisible ~= false then
                b.Visible = false
                O7.lastVisible = false
              end
              return
            end
            O7.radiusCheckElapsed = O7.radiusCheckElapsed + (U7 or 0)
            n7 = _G.__CrystalAutoGrabRagdollBlocked == true
            if n7 then
              O7.targetInRadius = false
              O7.radiusProgress = 0
            end
            if O7.radiusCheckElapsed >= 0.25 then
              O7.radiusCheckElapsed = 0
              O7.targetInRadius = false
              local H = (((StealState and StealState.active) or (A and A.busy)) or (V3New and V3New.busy)) or (V2Grab and V2Grab.busy)
              if ((not n7 and not H) and (h["auto steal"] == true)) and _G.__CrystalAutoGrabTargetInRadius then
                local A = math.clamp(tonumber(j.Radius) or 65, 10, 150)
                local H, d = pcall(_G.__CrystalAutoGrabTargetInRadius, A)
                O7.targetInRadius = H and (d == true)
              end
            end
            local A = (n7 and 0) or math.clamp(a or 0, 0, 1)
            if O7.targetInRadius then
              if A > 0 then
                O7.radiusProgress = A
              else
                n7 = math.max(0.1, tonumber(j.Duration) or 1.3)
                O7.radiusProgress = O7.radiusProgress + ((U7 or 0) / n7)
                if O7.radiusProgress >= 1 then
                  O7.radiusProgress = 0
                end
              end
            else
              O7.radiusProgress = 0
            end
            local a, H = math.max(A, O7.radiusProgress), J7.AbsoluteSize.X
            H = if H <= 0 then b.AbsoluteSize.X - ((M and 76) or 88) else H
            H = if H <= 0 then (M and 192) or 222 else H
            local d, n7, j7 = math.clamp(a * H, 0, H), O7.displayProgress * H, ((a > O7.displayProgress) and 18) or 22
            n7 += (d - n7) * math.min(j7 * U7, 1)
            n7 = if math.abs(n7 - d) < 0.5 then d else n7
            O7.displayProgress = ((H > 0) and math.clamp(n7 / H, 0, 1)) or 0
            r7.Size = UDim2.new(0, n7, 1, 0)
            d = h["Steal Bar"] == true
            if d ~= O7.lastVisible then
              b.Visible = d
              O7.lastVisible = d
            end
            j7 = math.floor(a * 100)
            j7 = math.clamp(j7, 0, 100)
            if j7 ~= O7.lastPercent then
              M7.Text = tostring(j7) .. "%"
              if v then
                v.Text = tostring(j7) .. "%"
              end
              O7.lastPercent = j7
            end
            A = a > 0
            a = A and (O7.lastActive ~= true)
            if a then
              r7.BackgroundColor3 = _7
              j7 = _7
              Q7.Color = j7:Lerp(Color3.fromRGB(255, 255, 255), 0.12)
              Q7.Transparency = 0.12
              x.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
            O7.lastActive = A
          end))
        end
        T = u7(w.Visuals, "VISUALS")
        p7(T, "anti lag", "Anti Lag")
        _G.__visualSection = T
        p7(T, "ESP Players", "ESP Players")
        p7(T, "Player Tracers", "Player Tracers")
        local b, a, A, v = "Ultra", {}
        local function x()
          for H, H in ipairs(a) do
            pcall(H, b)
          end
        end
        local function H(d)
          d = if (d ~= "Normal") and (d ~= "Ultra") then "Normal" else d
          b = d
          _G.__optimizerMode = d
          x()
          pcall(w7)
          if h.Optimizer and l.Optimizer then
            l.Optimizer(false)
            l.Optimizer(true)
          end
        end
        C = (_G.__optimizerMode == "Normal") or (_G.__optimizerMode == "Ultra")
        if C then
          b = _G.__optimizerMode
        else
          _G.__optimizerMode = b
        end
        C = nil
        for x, x in ipairs(p7(T, "Optimizer", "Optimizer"):GetChildren()) do
          if x:IsA("TextButton") then
            C = x
            break
          end
        end
        if C then
          local x = Instance.new("TextButton", C)
          x.Size = UDim2.new(0, 66, 0, 20)
          x.Position = UDim2.new(1, -74, 0.5, -10)
          x.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
          x.BorderSizePixel = 0
          x.TextColor3 = Color3.fromRGB(225, 238, 255)
          x.TextSize = 10
          x.Font = Enum.Font.GothamBold
          x.AutoButtonColor = false
          x.ZIndex = 10
          Instance.new("UICorner", x).CornerRadius = UDim.new(0, 4)
          local d = Instance.new("UIStroke", x)
          d.Color = Color3.fromRGB(255, 255, 255)
          d.Thickness = 1
          d.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          local function d()
            x.Text = string.upper(b)
          end
          table.insert(a, d)
          t(x, function()
            H(((b == "Normal") and "Ultra") or "Normal")
            d()
          end)
          d()
        end
        do
          local x, d, O7, M7, U7, n7, Q7, j7 = false
          local r7, J7, q7, _7 = false, 0, 0, {}
          local function z7(K7, k7)
            local e7 = _7[K7] == nil
            if e7 then
              _7[K7] = k7
            end
          end
          local function K7()
            local k7 = _7
            for e7, X7 in pairs(k7) do
              local k7 = i[48](13059400, 0)
              local C7 = k7
              local a7
              a7, k7 = pcall, i:rQ((i:HQ(673438474, C7) + i:HQ(673438474, 452623751)) + (i:HQ(2948090348, (i[79](C7, 452623751))) + i:HQ(673438475, (i[48](C7, 452623751)))))
              a7(function()
                if ((X7.Parent ~= nil) and (e7.Parent == nil)) and (X7.Parent.Parent ~= nil) then
                  e7.Parent = X7.Parent
                end
                if e7.Parent ~= nil then
                  if X7.Material ~= nil then
                    e7.Material = X7.Material
                  end
                  if X7.Reflectance ~= nil then
                    e7.Reflectance = X7.Reflectance
                  end
                  if X7.CastShadow ~= nil then
                    e7.CastShadow = X7.CastShadow
                  end
                  if X7.Transparency ~= nil then
                    e7.Transparency = X7.Transparency
                  end
                  if X7.Enabled ~= nil then
                    e7.Enabled = X7.Enabled
                  end
                end
              end)
            end
            _7 = {}
          end
          local _7 = {{"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"}, {"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"}, {"DFIntServerFramesBetweenJoins", "1"}, {"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"}, {"DFIntConnectionMTUSize", "1400"}, {"FIntRakNetResendBufferArrayLength", "1024"}, {"DFIntRakNetNakResendDelayMsMax", "1"}, {"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"}, {"DFIntWaitOnRecvFromLoopEndedMS", "100"}, {"DFIntLargePacketQueueSizeCutoffMB", "1000"}, {"DFIntSendRakNetStatsInterval", "2147483647"}, {"DFIntRakNetLoopMs", "1"}, {"DFIntRakNetSelectTimeoutMs", "1"}, {"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"}, {"DFIntReplicationDataCacheNumParallelTasks", "8"}, {"DFIntMegaReplicatorNumParallelTasks", "16"}, {"DFIntMegaReplicatorNetworkQualityProcessorUnit", "10"}, {"DFIntMaxProcessPacketsStepsPerCyclic", "512"}, {"DFIntMaxProcessPacketsStepsAccumulated", "0"}, {"DFIntMaxProcessPacketsJobScaling", "1000"}, {"DFIntClientPacketMaxFrameMicroseconds", "200000"}, {"DFIntClientPacketExcessMicroseconds", "10000"}, {"DFIntClientPacketMinMicroseconds", "1"}, {"DFIntClientPacketMaxDelayMs", "1"}, {"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"}, {"DFIntMaxFrameBufferSize", "4"}, {"DFIntBufferCompressionThreshold", "100"}, {"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"}, {"DFIntTaskSchedulerJobInitThreads", "8"}, {"DFIntTaskSchedulerJobInGameThreads", "8"}, {"FIntTaskSchedulerAutoThreadLimit", "16"}, {"FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"}, {"DFIntRuntimeConcurrency", "16"}, {"FIntSimWorldTaskQueueParallelTasks", "20"}, {"DFIntHttpBatchLimit", "256"}, {"FIntHttpBatchLimit", "256"}, {"DFIntHttpCurlConnectionCacheSize", "512"}, {"FIntDefaultMeshCacheSizeMB", "512"}, {"DFIntMemCacheMaxCapacityMB", "256"}, {"DFIntNumAssetsMaxToPreload", "1"}, {"DFFlagEnableSoundPreloading", "false"}, {"FFlagSlimContentProvider", "true"}, {"DFFlagDebugSkipMeshVoxelizer", "true"}, {"DFFlagTextureQualityOverrideEnabled", "true"}, {"DFIntTextureQualityOverride", "0"}, {"FIntDebugTextureManagerSkipMips", "7"}, {"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"}, {"FFlagTM2SkipMipsForUnstreamable2", "true"}, {"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"}, {"FFlagRenderUseTextureManager224", "false"}, {"DFIntDebugFRMQualityLevelOverride", "1"}, {"DFFlagDebugPauseVoxelizer", "true"}, {"FFlagFastGPULightCulling3", "true"}, {"FIntRenderLocalLightFadeInMs", "0"}, {"FIntRenderLocalLightUpdatesMax", "1"}, {"FIntRenderShadowmapBias", "0"}, {"FIntSSAOMipLevels", "0"}, {"FIntDebugForceMSAASamples", "1"}, {"FIntDebugFRMOptionalMSAALevelOverride", "0"}, {"FIntRobloxGuiBlurIntensity", "0"}, {"FIntFRMMinGrassDistance", "0"}, {"FIntFRMMaxGrassDistance", "0"}, {"DFFlagCoreScriptTelemetry2", "false"}, {"DFFlagBrowserTrackerIdTelemetryEnabled", "false"}, {"FFlagPerfDataOnTelemetryV2", "false"}, {"FFlagSendRenderFidelityTelemetry2", "false"}, {"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"}, {"DFIntTelemetryProfilerHundredthsPercentage", "0"}, {"FIntTelemetryProfilerFrequency", "0"}, {"FIntPerformanceTelemetryQueueProcessLimit", "0"}, {"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"}}
          local function k7()
            local e7 = (getgenv and getgenv()) or _G
            local X7, C7 = rawget(e7, "setfflag") or rawget(_G, "set_fflag"), rawget(e7, "getfflag") or rawget(_G, "get_fflag")
            if type(X7) ~= "function" then
              return
            end
            for a7, a7 in ipairs(_7) do
              e7 = true
              if type(C7) == "function" then
                local _7, A7 = pcall(C7, a7[1])
                e7 = _7 and (A7 ~= nil)
              else
              end
              if e7 then
                pcall(X7, a7[1], tostring(a7[2]))
              end
            end
          end
          local function _7()
            local e7 = i[48](441625306, 0)
            local X7 = e7
            local C7
            C7, e7 = pcall, i:rQ((i:HQ(191336508, X7) + i:HQ(191336508, 426345146)) + (i:HQ(4103630789, (i[79](X7, 426345146))) + i:HQ(4103630787, (i[89](X7, 426345146)))))
            C7(function()
              settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)
            pcall(function()
              UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
            end)
            pcall(function()
              o.GlobalShadows = false
              o.EnvironmentDiffuseScale = 0
              o.EnvironmentSpecularScale = 0
            end)
            pcall(function()
              local e7 = o:FindFirstChildOfClass("Atmosphere")
              if e7 then
                e7.Density = 0
                e7.Glare = 0
                e7.Haze = 0
              end
            end)
            pcall(function()
              local e7 = workspace:FindFirstChildOfClass("Terrain")
              if e7 then
                e7.Decoration = false
                e7.WaterWaveSize = 0
                e7.WaterWaveSpeed = 0
                e7.WaterReflectance = 0
                local X7 = e7:FindFirstChildOfClass("Clouds")
                if X7 then
                  X7.Enabled = false
                end
              end
            end)
          end
          local function e7(X7)
            local C7 = i[48](456775906, 0)
            local a7
            a7, C7 = pcall, i:rQ((i:HQ(1561779874, C7) + i:HQ(1561779874, 358919226)) + (i:HQ(1171407548, (i[79](C7, 358919226))) + i:HQ(1561779875, (i[48](C7, 358919226)))))
            a7(function()
              if _G.__CrystalPreserveOptimizerUI(X7) then
                return
              end
              local C7 = b ~= "Ultra"
              if C7 then
                if ((((X7:IsA("ParticleEmitter") or X7:IsA("Trail")) or X7:IsA("Smoke")) or X7:IsA("Fire")) or X7:IsA("Sparkles")) or X7:IsA("PostEffect") then
                  X7.Enabled = false
                end
                local a7, A7 = tick(), J7
                if a7 <= A7 then
                  if X7:IsA("Decal") or X7:IsA("Texture") then
                    X7.Transparency = 1
                  end
                end
                return
              end
              C7 = X7.Name
              if X7.Parent then
                local C7 = X7.Parent.Name
              end
              if X7.Parent and X7.Parent.Parent then
                local C7 = X7.Parent.Parent.Name
              end
              if ((((X7:IsA("Accessory") or X7:IsA("Hat")) or X7:IsA("Clothing")) or X7:IsA("Shirt")) or X7:IsA("Pants")) or X7:IsA("ShirtGraphic") then
                z7(X7, {Parent = X7.Parent})
                X7.Parent = nil
              elseif X7:IsA("BasePart") then
                z7(X7, {Material = X7.Material, Reflectance = X7.Reflectance, CastShadow = X7.CastShadow})
                X7.Material = Enum.Material.Plastic
                X7.Reflectance = 0
                X7.CastShadow = false
              elseif X7:IsA("Decal") or X7:IsA("Texture") then
                z7(X7, {Transparency = X7.Transparency})
                X7.Transparency = 1
              elseif ((((X7:IsA("ParticleEmitter") or X7:IsA("Trail")) or X7:IsA("Beam")) or X7:IsA("Fire")) or X7:IsA("Smoke")) or X7:IsA("Sparkles") then
                z7(X7, {Enabled = X7.Enabled})
                X7.Enabled = false
              elseif X7:IsA("AnimationController") or X7:IsA("Animator") then
                for z7, C7 in ipairs(X7:GetPlayingAnimationTracks()) do
                  local X7 = i[48](103715104, 0)
                  z7 = X7
                  local a7
                  a7, X7 = pcall, i:rQ(z7 + 468753867)
                  a7(function()
                    C7:Stop(0)
                  end)
                end
              end
            end)
          end
          local function z7()
            local X7 = i[48](452309709, 0)
            local C7 = X7
            local a7
            a7, X7 = b == "Ultra", i:rQ(C7 + 509867360)
            local C7, A7 = (a7 and {workspace}) or {workspace, o}, U7
            if A7 then
              U7()
            end
            A7 = nil
            A7, X7 = _G, i:rQ(X7 - 147468992)
            U7 = A7.__CrystalWalkDescendantsBatched(C7, e7, function()
              local X7 = x
              return X7
            end)
          end
          local function X7()
            n7 = n7 or o.Brightness
            Q7 = Q7 or o.ClockTime
            j7 = j7 or o.OutdoorAmbient
            local C7 = b
            if C7 ~= "Ultra" then
              _7()
              return
            end
            o.GlobalShadows = false
            o.FogEnd = 10000000000
            o.Brightness = 1
            o.EnvironmentDiffuseScale = 0
            o.EnvironmentSpecularScale = 0
            for _7, a7 in ipairs(o:GetChildren()) do
              local A7 = i[48](401987746, 0)
              _7 = A7
              C7 = nil
              C7, A7 = pcall, i:rQ((i:HQ(40878491, _7) + i:HQ(40878491, 270025452)) + (i:HQ(4213210314, (i[79](_7, 270025452))) + i:HQ(40878492, (i[48](_7, 270025452)))))
              C7(function()
                if (((a7:IsA("BlurEffect") or a7:IsA("SunRaysEffect")) or a7:IsA("ColorCorrectionEffect")) or a7:IsA("BloomEffect")) or a7:IsA("DepthOfFieldEffect") then
                  a7.Enabled = false
                end
              end)
            end
          end
          local function _7()
            local C7 = i[48](405195149, 0)
            local a7
            a7, C7 = pcall, i:rQ((i:HQ(2767231011, C7) + i:HQ(2767231011, 196816501)) + (i:HQ(1527736286, (i[79](C7, 196816501))) + i:HQ(1527736284, (i[89](C7, 196816501)))))
            a7(function()
              local C7 = n7
              if C7 then
                o.Brightness = n7
              end
              C7 = Q7
              if C7 then
                o.ClockTime = Q7
              end
              C7 = j7
              if C7 then
                o.OutdoorAmbient = j7
              end
              o.ExposureCompensation = 0
              o.GlobalShadows = true
              o.FogEnd = 100000
              o.EnvironmentDiffuseScale = 1
              o.EnvironmentSpecularScale = 1
            end)
          end
          l.Optimizer = function(n7)
            if n7 then
              local n7, Q7 = i[48](42150628, 0), x
              if Q7 then
                return
              end
              r7, x = true, true
              Q7 = nil
              Q7, n7 = b, i:rQ((i:HQ(356715727, n7) + i:HQ(356715727, 355952887)) + (i:HQ(3581535842, (i[79](n7, 355952887))) + i:HQ(356715728, (i[48](n7, 355952887)))))
              local j7 = Q7 ~= "Ultra"
              if j7 then
                local C7 = i[48](511057269, 0)
                J7 = tick() + 1
                q7 += 1
                local J7 = q7
                k7()
                local a7, A7 = ipairs, {2, 6, 12, 20}
                C7 = i:rQ(C7 + 23693461)
                for g7, g7 in a7(A7) do
                  task.delay(g7, function()
                    local a7 = (x and (b ~= "Ultra")) and (J7 == q7)
                    if a7 then
                      k7()
                    end
                  end)
                end
                A7 = nil
                A7, C7 = pcall, i:rQ(C7 + 368180531)
                A7(function()
                  game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()
                end)
              end
              X7()
              j7 = h["Sky Changer"]
              if j7 then
                A(v)
              end
              z7()
              n7 = i[48](n7, 464509180)
              j7 = d
              if j7 then
                d:Disconnect()
              end
              d = workspace.DescendantAdded:Connect(function(n7)
                local J7 = r7
                if J7 then
                  e7(n7)
                end
              end)
              Q7 = O7
              if Q7 then
                O7:Disconnect()
              end
              O7 = o.DescendantAdded:Connect(function(n7)
                local Q7 = r7
                if Q7 then
                  e7(n7)
                end
              end)
              j7 = M7
              if j7 then
                M7:Disconnect()
              end
              M7 = F.CharacterAdded:Connect(function(n7)
                local Q7 = i[48](485635157, 0)
                local j7 = Q7
                local J7
                J7, Q7 = task.wait, i:rQ(j7 + 387470971)
                J7(0.5)
                J7 = nil
                J7, Q7 = _G.__CrystalWalkDescendantsBatched, i:rQ(Q7 - 174759495)
                J7(n7, e7, function()
                  local n7 = x
                  return n7
                end)
              end)
              print("[Optimizer] Anti Lag ACTIVADO - Modo " .. b)
            else
              local n7 = x
              if not n7 then
                return
              end
              r7, x = false, false
              n7 = U7
              if n7 then
                U7()
                U7 = nil
              end
              q7 += 1
              K7()
              n7 = d
              if n7 then
                d:Disconnect()
                d = nil
              end
              n7 = O7
              if n7 then
                O7:Disconnect()
                O7 = nil
              end
              n7 = M7
              if n7 then
                M7:Disconnect()
                M7 = nil
              end
              n7 = h["Sky Changer"]
              if n7 then
                A(v)
              else
                _7()
              end
              print("[Optimizer] Anti Lag DESACTIVADO")
            end
          end
        end
        _G.__CrystalTrackStopper(function()
          if optimizerActive and l.Optimizer then
            l.Optimizer(false)
          end
        end)
        y(T, "FOV", "Custom FOV")
        do
          local x, d, O7 = false
          local function M7()
            local U7 = i[48](481080473, 0)
            local n7 = U7
            local Q7 = x
            if Q7 then
              return
            end
            x = true
            U7 = i:rQ(n7 + 354062143)
            h["Custom FOV"] = true
            Q7 = d
            if Q7 then
              d:Disconnect()
            end
            n7 = nil
            n7, U7 = workspace, i:rQ(U7 - 9209710)
            Q7 = n7.CurrentCamera
            n7 = Q7 and (O7 == nil)
            if n7 then
              O7 = Q7.FieldOfView
            end
            d = s.RenderStepped:Connect(function()
              local U7 = x
              if not U7 then
                return
              end
              local U7, n7 = workspace.CurrentCamera, n.FOV or 90
              if U7 and (math.abs(U7.FieldOfView - n7) > 0.01) then
                U7.FieldOfView = n7
              end
            end)
            if Q7 then
              Q7.FieldOfView = n.FOV or 90
            end
            task.defer(w7)
          end
          local function U7()
            local n7 = x
            if not n7 then
              return
            end
            x = false
            h["Custom FOV"] = false
            n7 = d
            if n7 then
              d:Disconnect()
              d = nil
            end
            n7 = workspace.CurrentCamera
            if n7 then
              n7.FieldOfView = O7 or 90
            end
            O7 = nil
            task.defer(w7)
          end
          l["Custom FOV"] = function(x)
            if x then
              M7()
            else
              U7()
            end
          end
          _G.__CrystalTrackStopper(U7)
          if h["Custom FOV"] then
            task.defer(M7)
          end
        end
        p7(T, "Stretchz Res", "Stretchz Res")
        do
          local x, d = false
          local function O7(M7)
            local U7 = workspace.CurrentCamera
            if U7 then
              local n7 = i[48](80632686, 0)
              local Q7 = n7
              local j7
              j7, n7 = pcall, i:rQ((i:HQ(2607113092, Q7) + i:HQ(2607113092, 278683063)) + (i:HQ(1687854205, (i[79](Q7, 278683063))) + i:HQ(1687854203, (i[89](Q7, 278683063)))))
              j7(function()
                U7.FieldOfView = M7
              end)
            end
          end
          local function M7()
            local U7 = i[48](361905982, 0)
            local n7 = U7
            local Q7 = x
            if Q7 then
              return
            end
            x = true
            U7 = i:rQ(n7 + 13927030)
            h["Stretchz Res"] = true
            local Q7 = workspace.CurrentCamera
            U7 = i:rQ(U7 + 26808934)
            if not Q7 then
              return
            end
            n7 = d
            if n7 then
              d:Disconnect()
            end
            d = s.RenderStepped:Connect(function()
              local U7 = i[48](234988611, 0)
              local n7 = U7
              local j7 = x
              U7 = i:rQ(n7 + 268989657)
              if not j7 then
                return
              end
              O7(90)
              n7 = nil
              n7, U7 = pcall, i:rQ(U7 - 168502387)
              n7(function()
                Q7.CFrame = Q7.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1)
              end)
            end)
            O7(90)
            task.defer(w7)
          end
          local function O7()
            x = false
            h["Stretchz Res"] = false
            local x = d
            if x then
              d:Disconnect()
              d = nil
            end
            local d = workspace.CurrentCamera
            if d then
              local U7 = i[48](308128572, 0)
              x = U7
              local n7
              n7, U7 = pcall, i:rQ(x + 203357163)
              n7(function()
                d.FieldOfView = 90
              end)
            end
            task.defer(w7)
          end
          l["Stretchz Res"] = function(x)
            if x then
              M7()
            else
              O7()
            end
          end
          _G.__CrystalTrackStopper(O7)
          if h["Stretchz Res"] then
            task.defer(M7)
          end
        end
        do
          y, C = setmetatable, {__mode = "k"}
          local x, d, O7 = y({}, C), 0, false
          local function M7(U7)
            local n7 = i[48](287299960, 0)
            local Q7
            Q7, n7 = pcall, i:rQ((i:HQ(3298579265, n7) + i:HQ(3298579265, 5048578)) + (i:HQ(1992776062, (i[79](n7, 5048578))) + i:HQ(3298579266, (i[48](n7, 5048578)))))
            Q7(function()
              U7:SetAttribute("_CrystalVioletteSkin", true)
            end)
            return U7
          end
          local function U7(n7)
            if not n7 then
              return
            end
            for Q7, j7 in ipairs(n7:GetDescendants()) do
              if j7:GetAttribute("_CrystalVioletteSkin") then
                local n7 = i[48](234199608, 0)
                Q7 = n7
                local r7
                r7, n7 = pcall, i:rQ((i:HQ(638240020, Q7) + i:HQ(638240020, 96119658)) + (i:HQ(3018487256, (i[79](Q7, 96119658))) + i:HQ(638240021, (i[48](Q7, 96119658)))))
                r7(function()
                  j7:Destroy()
                end)
              end
            end
          end
          local function n7(Q7)
            if not Q7 then
              return
            end
            for j7, r7 in ipairs(Q7:GetChildren()) do
              if r7:IsA("Accessory") or r7:IsA("Accoutrement") then
                local Q7 = i[48](292509949, 0)
                j7 = Q7
                local J7
                J7, Q7 = pcall, i:rQ((i:HQ(340552483, j7) + i:HQ(340552483, 145701763)) + (i:HQ(3613862330, (i[79](j7, 145701763))) + i:HQ(340552484, (i[48](j7, 145701763)))))
                J7(function()
                  r7:Destroy()
                end)
              end
            end
          end
          local function Q7(j7, r7, J7)
            local q7 = i[48](463498831, 0)
            local _7 = q7
            if not J7 or not J7:IsA("Accessory") then
              return false
            end
            local z7 = M7
            q7 = i:rQ((i:HQ(1174960506, _7) + i:HQ(1174960506, 384752154)) + (i:HQ(3120006791, (i[79](_7, 384752154))) + i:HQ(3120006789, (i[89](_7, 384752154)))))
            _7 = J7
            q7 = i[48](q7, 496781155)
            z7(_7)
            pcall(function()
              r7:AddAccessory(J7)
            end)
            if J7.Parent ~= j7 then
              J7.Parent = j7
            end
            _7 = J7:FindFirstChild("Handle")
            if not _7 or not _7:IsA("BasePart") then
              return J7.Parent == j7
            end
            z7 = _7:FindFirstChildWhichIsA("Attachment")
            if not z7 then
              return J7.Parent == j7
            end
            local r7
            for q7, q7 in ipairs(j7:GetDescendants()) do
              if (q7:IsA("Attachment") and (q7.Name == z7.Name)) and not q7:IsDescendantOf(J7) then
                r7 = q7
                break
              end
            end
            j7 = r7 and r7.Parent
            if j7 and (j7:IsA("BasePart")) then
              _7.Anchored = false
              _7.CanCollide = false
              _7.CanTouch = false
              _7.CanQuery = false
              _7.Massless = true
              _7.CFrame = (j7.CFrame * r7.CFrame) * z7.CFrame:Inverse()
              local r7 = Instance.new("WeldConstraint")
              r7.Name = "CrystalVioletteAccessoryWeld"
              r7.Part0 = j7
              r7.Part1 = _7
              r7.Parent = _7
            end
            return true
          end
          local function j7(r7, J7, q7)
            local _7, z7 = pcall(function()
              local K7, k7 = game, "rbxassetid://" .. tostring(q7)
              return K7:GetObjects(k7)
            end)
            local K7 = (not _7 or (type(z7) ~= "table")) or (#z7 == 0)
            if K7 then
              local k7 = i[48](209860657, 0)
              local e7
              k7 = i[48](k7, 90020658)
              _7 = nil
              _7, k7 = pcall, i[48](k7, 175504832)
              local k7 = _7(function()
                e7 = game:GetService("InsertService"):LoadAsset(q7)
              end)
              local q7 = k7 and e7
              if q7 then
                z7 = {e7}
              else
                return false
              end
            else
            end
            K7 = false
            for q7, _7 in ipairs(z7) do
              local z7, k7 = i[48](268709284, 0), {}
              z7 = i[48](z7, 91869035)
              if ((_7:IsA("Accessory") or _7:IsA("Shirt")) or _7:IsA("Pants")) or _7:IsA("ShirtGraphic") then
                k7 = {_7}
              else
                for e7, e7 in ipairs(_7:GetDescendants()) do
                  if ((e7:IsA("Accessory") or e7:IsA("Shirt")) or e7:IsA("Pants")) or e7:IsA("ShirtGraphic") then
                    table.insert(k7, e7)
                  end
                end
              end
              for e7, e7 in ipairs(k7) do
                q7 = M7(e7:Clone())
                if q7:IsA("Accessory") then
                  Q7(r7, J7, q7)
                else
                  for M7, M7 in ipairs(r7:GetChildren()) do
                    if M7.ClassName == q7.ClassName then
                      M7:Destroy()
                    end
                  end
                  q7.Parent = r7
                end
                K7 = true
              end
              q7 = nil
              q7, z7 = pcall, i:rQ((i:HQ(1161515197, z7) + i:HQ(1161515197, 157400048)) + (i:HQ(3133452100, (i[79](z7, 157400048))) + i:HQ(3133452098, (i[89](z7, 157400048)))))
              q7(function()
                _7:Destroy()
              end)
            end
            return K7
          end
          local function M7(Q7, r7)
            local J7 = Q7 and (Q7:FindFirstChild("Head"))
            if not J7 then
              return
            end
            Q7 = (r7 and 1) or 0
            J7.Transparency = Q7
            J7.LocalTransparencyModifier = Q7
            for r7, r7 in ipairs(J7:GetChildren()) do
              if r7:IsA("Decal") or r7:IsA("Texture") then
                r7.Transparency = Q7
              end
            end
          end
          local function Q7(r7)
            local J7 = i[48](287554004, 0)
            local q7 = r7 and (r7:FindFirstChildOfClass("Humanoid"))
            if not q7 then
              return false
            end
            local _7
            _7, J7 = d, i:rQ(J7 + 48387191)
            d = _7 + 1
            _7 = d
            U7(r7)
            J7 = i:rQ(J7 + 54900976)
            local J7
            pcall(function()
              J7 = q7:GetAppliedDescription()
            end)
            local z7 = J7 and not x[r7]
            if z7 then
              x[r7] = J7:Clone()
            end
            n7(r7)
            if J7 then
              local n7 = i[48](393225937, 0)
              local K7 = J7:Clone()
              n7 = i:rQ(n7 + 214136432)
              local J7, k7 = ipairs, {}
              n7 = i:rQ(n7 + 275358877)
              i:yQ(k7, 0, "HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory", "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory", "SweaterAccessory", "ShortsAccessory", "TShirtAccessory", "DressSkirtAccessory")
              for n7, n7 in J7(k7) do
                pcall(function()
                  K7[n7] = ""
                end)
              end
              pcall(function()
                K7.Shirt = 0
                K7.Pants = 0
                K7.GraphicTShirt = 0
              end)
              local n7 = o7[q] or o7["1"]
              pcall(function()
                K7.HatAccessory = n7.hats or ""
                K7.HairAccessory = n7.hair or ""
                if n7.head then
                  K7.Head = n7.head
                end
                q7:ApplyDescription(K7)
              end)
              K7:Destroy()
            end
            task.wait()
            z7 = (not O7 or (_7 ~= d)) or not r7.Parent
            if z7 then
              return false
            end
            z7 = o7[q] or o7["1"]
            for n7, n7 in ipairs(z7.accessories or {}) do
              j7(r7, q7, n7)
            end
            for n7, n7 in ipairs(z7.clothing or {}) do
              j7(r7, q7, n7)
            end
            M7(r7, z7.headless == true)
            return true
          end
          local function n7(j7)
            d += 1
            j7 = j7 or F.Character
            if not j7 then
              return
            end
            U7(j7)
            local d = j7:FindFirstChildOfClass("Humanoid")
            local U7 = x[j7]
            if d and U7 then
              local x = i[48](211910592, 0)
              local r7 = x
              local J7
              J7, x = pcall, i:rQ((i:HQ(1383622381, r7) + i:HQ(1383622381, 366977529)) + (i:HQ(1527722534, (i[79](r7, 366977529))) + i:HQ(1383622382, (i[48](r7, 366977529)))))
              J7(function()
                d:ApplyDescription(U7:Clone())
              end)
            else
              M7(j7, false)
            end
          end
          l["Violette Custom Skins"] = function(x)
            O7 = x == true
            x = O7
            if x then
              task.spawn(Q7, F.Character)
            else
              n7(F.Character)
            end
          end
          _G._KawatanSkinColor = q
          local function x(d)
            d = tostring(d)
            local M7 = not o7[d]
            if M7 then
              local U7 = q
              return U7
            end
            q = d
            _G._KawatanSkinColor = d
            M7 = O7
            if M7 then
              task.spawn(Q7, F.Character)
            end
            w7()
            return d
          end
          _G.__CrystalVioletteSkinSet = x
          _G.__CrystalTrackConn(F.CharacterAdded:Connect(function(q)
            local d = O7
            if d then
              task.wait(0.75)
              local d = O7
              if d then
                task.spawn(Q7, q)
              end
            end
          end))
          _G.__CrystalTrackStopper(function()
            O7 = false
            n7(F.Character)
          end)
          x = h["Violette Custom Skins"]
          if x then
            O7 = true
            task.defer(Q7, F.Character)
          else
          end
        end
        function _G._CrystalCustomSkinPicked(q)
          q = tostring(q)
          if not o7[q] then
            return
          end
          _G.__CrystalVioletteSkinSet(q)
          if not h["Violette Custom Skins"] then
            h["Violette Custom Skins"] = true
            l["Violette Custom Skins"](true)
          end
          local q = V["Violette Custom Skins"]
          if q then
            q(true)
          end
          q = Y["Violette Custom Skins"]
          if q then
            q()
          end
          w7()
        end
        ;(function()
          local q = i[48](60234485, 0)
          local x = q
          local d, o7, O7 = F, D
          O7, q = _G, i[48](x, 194717711)
          x = O7._CrystalCustomSkinsGalleryRuntime
          q = i:rQ((i:HQ(196249639, q) + i:HQ(196249639, 382198980)) + (i:HQ(4098717658, (i[79](q, 382198980))) + i:HQ(4098717656, (i[89](q, 382198980)))))
          if x and _G._CrystalCustomSkinsGalleryRuntime.Destroy then
            pcall(_G._CrystalCustomSkinsGalleryRuntime.Destroy)
          end
          local q = {}
          local function M7(U7, n7)
            local Q7, j7 = U7:Connect(n7), q
            j7[#j7 + 1] = Q7
            return Q7
          end
          ;(function()
            local U7 = i[48](131729578, 0)
            local n7 = U7
            local function Q7(j7, r7, J7)
              local q7 = Instance.new(j7)
              for j7, _7 in pairs(r7 or {}) do
                q7[j7] = _7
              end
              for j7, j7 in ipairs(J7 or {}) do
                j7.Parent = q7
              end
              return q7
            end
            local function j7(r7)
              return Q7("UICorner", {CornerRadius = UDim.new(0, r7)})
            end
            local function r7(J7, q7, _7)
              return Q7("UIStroke", {Color = J7, Thickness = q7 or 1, Transparency = _7 or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
            end
            local J7 = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local function q7(_7, z7, K7)
              if typeof(_7) ~= "Instance" then
                return
              end
              c:Create(_7, z7, K7):Play()
            end
            local _7 = Color3.fromRGB(254, 254, 254)
            local z7, K7, k7, e7 = Color3.fromRGB(18, 18, 18), Color3.fromRGB(32, 32, 32), Color3.fromRGB(10, 10, 10), Color3.fromRGB(28, 28, 34)
            local X7 = Color3.fromRGB(48, 48, 56)
            local C7, a7 = Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 255, 255)
            local A7 = Color3.fromRGB(150, 150, 155)
            local function g7()
              local R7 = _G._VioletteAccent
              return ((typeof(R7) == "Color3") and R7) or _7
            end
            local _7, R7 = ipairs, {game:GetService("CoreGui"), d:FindFirstChild("PlayerGui")}
            for S7, Z7 in _7(R7) do
              if Z7 then
                local f7 = Z7:FindFirstChild("CrystalCustomSkinsGallery")
                if f7 then
                  local Z7 = i[48](9103063, 0)
                  S7 = Z7
                  local Y7 = pcall
                  Z7 = i[48](S7, 419679172)
                  local function S7()
                    f7:Destroy()
                  end
                  Y7(S7)
                end
              end
            end
            local S7 = Q7("ScreenGui", {Name = "CrystalCustomSkinsGallery", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100001})
            pcall(function()
              S7.Parent = (gethui and gethui()) or game:GetService("CoreGui")
            end)
            if not S7.Parent then
              S7.Parent = d:WaitForChild("PlayerGui")
            end
            S7.Archivable = false
            pcall(function()
              S7:SetAttribute("_VlonEProtected", true)
            end)
            _7 = o7.TouchEnabled and not o7.KeyboardEnabled
            local d, Z7, f7, Y7, V7, v7, l7, m7 = (_7 and 424) or 616, (_7 and 456) or 632, (_7 and 126) or 190, (_7 and 184) or 272, (_7 and 2) or 5, (_7 and 3) or 6, 9.6, 0.5
            local P7 = Q7("TextButton", {Parent = S7, Name = "CatalogBackdrop", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, BorderSizePixel = 0, Visible = false, ZIndex = 200})
            local S7 = Q7("Frame", {Parent = P7, Name = "CatalogPanel", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(d, Z7), BackgroundColor3 = z7, BorderSizePixel = 0, Active = true, ZIndex = 201}, {j7(14)})
            local x7 = r7(g7(), 1.2, 0.55)
            x7.Parent = S7
            local H7 = Q7("UIScale", {Parent = S7, Scale = 1})
            Q7("UIGradient", {Parent = S7, Rotation = 35, Color = ColorSequence.new(z7, K7)})
            K7 = Q7("Frame", {Parent = S7, BackgroundTransparency = 1, Active = true, Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -28, 0, 46), ZIndex = 202})
            Q7("TextLabel", {Parent = K7, Size = UDim2.new(1, -40, 0, 22), Position = UDim2.fromOffset(0, 2), BackgroundTransparency = 1, Text = "CUSTOM SKINS", Font = Enum.Font.GothamBlack, TextSize = (_7 and 16) or 18, TextColor3 = a7, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 203})
            local E7 = Q7("TextLabel", {Parent = K7, Size = UDim2.new(1, -40, 0, 12), Position = UDim2.fromOffset(0, 24), BackgroundTransparency = 1, Text = "PICK A SKIN", Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = g7(), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 203})
            R7, z7, d, _7 = Q7("TextButton", {Parent = K7, Name = "CloseCatalog", BackgroundTransparency = 1, Text = "\195\151", TextSize = 20, TextColor3 = a7, Font = Enum.Font.GothamMedium, AutoButtonColor = false, Position = UDim2.new(1, -30, 0, 2), Size = UDim2.fromOffset(30, 30), ZIndex = 204}), Q7, {Parent = S7, Name = "SetCards", BackgroundTransparency = 1, BorderSizePixel = 0}, UDim2.fromOffset
            U7 = i:rQ((i[48](n7, 61507576) + i:HQ(899004470, 4294967295)) + (i:HQ(3395962826, n7) + i:HQ(3395962826, (i[100](n7)))))
            d.Position = _7(14, 58)
            d.Size = UDim2.new(1, -28, 1, -72)
            d.CanvasSize = UDim2.new()
            d.ScrollBarThickness = 0
            d.ZIndex = 202
            local n7 = z7("ScrollingFrame", d)
            Q7("UIPadding", {Parent = n7, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4)})
            Z7, _7, d = Q7, {Parent = n7, CellSize = UDim2.fromOffset(f7, Y7), CellPadding = UDim2.fromOffset(V7, v7)}, Enum.HorizontalAlignment
            U7 = i:rQ((i:HQ(1170749512, U7) + i:HQ(1170749512, 133401629)) + (i:HQ(1953468272, (i[89](U7, 133401629))) + i:HQ(3124217785, (i[48](U7, 133401629)))))
            _7.HorizontalAlignment = d.Center
            _7.SortOrder = Enum.SortOrder.LayoutOrder
            local d = Z7("UIGridLayout", _7)
            local function U7()
              n7.CanvasSize = UDim2.fromOffset(0, d.AbsoluteContentSize.Y + 12)
            end
            d:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(U7)
            local d, z7, Z7, f7, V7, v7, N7 = {}, {}, false, false, false, 0
            local function d7(B7, L7)
              B7.PrimaryPart = B7:FindFirstChild("HumanoidRootPart") or B7.PrimaryPart
              for t7, t7 in ipairs(B7:GetDescendants()) do
                if t7:IsA("BasePart") then
                  t7.CanCollide = false
                  t7.CastShadow = false
                elseif t7:IsA("Script") or t7:IsA("LocalScript") then
                  t7:Destroy()
                end
              end
              if L7.headless ~= false then
                local t7 = B7:FindFirstChild("Head")
                if t7 then
                  t7.Transparency = 1
                  for i0, i0 in ipairs(t7:GetChildren()) do
                    if i0:IsA("Decal") or i0:IsA("Texture") then
                      i0.Transparency = 1
                    end
                  end
                end
              end
              local t7, i0 = L7.korblox or "Off", {{"Left", "Left Leg"}, {"Right", "Right Leg"}}
              for I0, D0 in ipairs(i0) do
                if (t7 == "Both") or (t7 == D0[1]) then
                  local t7 = _G._RaVeKorbloxAssets and _G._RaVeKorbloxAssets[D0[2]]
                  I0 = t7 and B7:FindFirstChild(t7.targetBodyPart)
                  if I0 then
                    local i0, D0 = i[48](391427640, 0), ipairs
                    L7 = t7.partsToHide
                    i0 = i[48](i0, 278182637)
                    i0 = i:rQ((i:HQ(1502370387, i0) + i:HQ(1502370387, 497993448)) + (i:HQ(2792596910, (i[79](i0, 497993448))) + i:HQ(2792596908, (i[89](i0, 497993448)))))
                    for i0, c0 in D0(L7) do
                      i0 = B7:FindFirstChild(c0)
                      if i0 and (i0:IsA("BasePart")) then
                        i0.Transparency = 1
                      end
                    end
                    local L7, i0 = pcall(function()
                      local D0, c0 = game, t7.id
                      return D0:GetObjects(c0)
                    end)
                    local D0 = (L7 and i0) and i0[1]
                    L7 = D0 and ((D0:IsA("BasePart") and D0) or D0:FindFirstChildWhichIsA("BasePart", true))
                    if L7 then
                      L7.CanCollide = false
                      L7.CastShadow = false
                      L7.CFrame = I0.CFrame * (t7.offset or CFrame.new())
                      i0 = Instance.new("WeldConstraint")
                      i0.Part0 = I0
                      i0.Part1 = L7
                      i0.Parent = L7
                      L7.Parent = B7
                    end
                    if (D0 and (D0 ~= L7)) and (D0.Parent ~= B7) then
                      local B7 = i[48](91407875, 0)
                      i0 = nil
                      i0, B7 = pcall, i[48](B7, 431937547)
                      i0(function()
                        D0:Destroy()
                      end)
                    end
                  end
                end
              end
            end
            local function B7(L7)
              local t7 = L7:FindFirstChild("HumanoidRootPart")
              if not t7 then
                return
              end
              for i0, I0 in ipairs(L7:GetChildren()) do
                if I0:IsA("Accessory") then
                  local D0 = i[48](12738401, 0)
                  i0 = D0
                  local c0
                  c0, D0 = pcall, i:rQ((i:HQ(720583042, i0) + i:HQ(720583042, 111894538)) + (i:HQ(3574384255, (i[79](i0, 111894538))) + i:HQ(3574384253, (i[89](i0, 111894538)))))
                  c0(function()
                    local i0 = I0:FindFirstChild("Handle")
                    if not (i0 and (i0:IsA("BasePart"))) then
                      return
                    end
                    if (i0.Position - t7.Position).Magnitude <= 8 then
                      return
                    end
                    local t7 = i0:FindFirstChildWhichIsA("Attachment")
                    local D0
                    if t7 then
                      for c0, c0 in ipairs(L7:GetDescendants()) do
                        if (c0:IsA("Attachment") and (c0.Name == t7.Name)) and not c0:IsDescendantOf(I0) then
                          D0 = c0
                          break
                        end
                      end
                    else
                    end
                    local I0 = D0 and D0.Parent
                    if I0 and (I0:IsA("BasePart")) then
                      i0.CFrame = (I0.CFrame * D0.CFrame) * t7.CFrame:Inverse()
                    else
                      local t7 = L7:FindFirstChild("Head")
                      if t7 then
                        i0.CFrame = t7.CFrame
                      end
                    end
                  end)
                end
              end
            end
            local function L7(t7, i0)
              local I0 = i[48](76377290, 0)
              local D0 = I0
              local c0 = task
              I0 = i:rQ(D0 + 416100939)
              D0 = c0.spawn
              I0 = i:rQ(I0 - 56677038)
              local function I0()
                local c0 = i[48](211160393, 0)
                local s0
                s0, c0 = _G._KawatanBuildSetDescription, i:rQ((i:HQ(498451339, c0) + i:HQ(498451339, 200407079)) + (i:HQ(3298064618, (i[79](c0, 200407079))) + i:HQ(498451340, (i[48](c0, 200407079)))))
                local y0 = s0 and _G._KawatanBuildSetDescription(t7)
                if not y0 then
                  i0.loading.Text = "N/A"
                  return
                end
                local o0, O0
                O0, c0 = pcall, i[48](c0, 90836494)
                s0 = not O0(function()
                  o0 = I:CreateHumanoidModelFromDescriptionAsync(y0, Enum.HumanoidRigType.R15)
                end) or not o0
                if s0 then
                  local c0 = i[48](124287903, 0)
                  O0 = nil
                  O0, c0 = pcall, i[48](c0, 262601603)
                  O0(function()
                    o0 = I:CreateHumanoidModelFromDescription(y0, Enum.HumanoidRigType.R15)
                  end)
                end
                pcall(function()
                  y0:Destroy()
                end)
                s0 = not o0 or not (o0:FindFirstChild("UpperTorso") or o0:FindFirstChild("Torso"))
                if s0 then
                  if o0 then
                    pcall(function()
                      o0:Destroy()
                    end)
                  end
                  i0.loading.Text = "N/A"
                  return
                end
                pcall(d7, o0, _G._KawatanSkinSets[t7])
                o0.Parent = i0.world
                task.wait()
                pcall(B7, o0)
                O0, s0 = ipairs, i[93](o0:GetDescendants())
                for d7, d7 in O0(i:gQ(s0)) do
                  if d7:IsA("BasePart") then
                    d7.Anchored = true
                  end
                end
                pcall(function()
                  local d7 = o0
                  d7:PivotTo(CFrame.new())
                end)
                i0.shot.rig = o0
                i0.loading.Visible = false
              end
              D0(I0)
            end
            local function d7(B7)
              _G._KawatanSkinColor = B7
              if _G._CrystalCustomSkinPicked then
                pcall(_G._CrystalCustomSkinPicked, B7)
              end
              if N7 then
                N7()
              end
            end
            for B7, t7 in ipairs(_G._KawatanSkinSetOrder or {}) do
              local i0, I0 = Q7("TextButton", {Parent = n7, Name = t7 .. "Preview", LayoutOrder = B7, BackgroundColor3 = k7, BackgroundTransparency = 0, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 203}, {j7(10)}), r7(e7, 1, 0)
              I0.Parent = i0
              U7 = Q7("ViewportFrame", {Parent = i0, Name = "AvatarPreview", BackgroundColor3 = C7, BackgroundTransparency = 0, BorderSizePixel = 0, Position = UDim2.fromOffset(7, 7), Size = UDim2.new(1, -14, 1, -34), Ambient = Color3.fromRGB(255, 255, 255), LightColor = Color3.fromRGB(255, 255, 255), LightDirection = Vector3.new(-0.25, -0.5, -0.83), ZIndex = 204}, {j7(8)})
              _7, Y7 = Q7("WorldModel", {Parent = U7}), Q7("Camera", {Parent = U7, FieldOfView = 42, CFrame = CFrame.lookAt(Vector3.new(0, m7, l7), Vector3.new(0, m7, 0))})
              U7.CurrentCamera = Y7
              local n7, j7 = Q7("TextLabel", {Parent = U7, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "LOADING", Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = A7, ZIndex = 205}), Q7("TextLabel", {Parent = i0, Position = UDim2.new(0, 8, 1, -24), Size = UDim2.new(1, -16, 0, 19), BackgroundTransparency = 1, Text = ((_G._KawatanSkinSets or {})[t7] or {}).displayName or tostring(t7):gsub("_", " "), Font = Enum.Font.GothamBlack, TextSize = 10, TextColor3 = A7, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 204})
              local Q7 = {camera = Y7, rig = nil, phase = B7 * 0.47, distance = l7, current = l7, target = l7}
              z7[#z7 + 1] = Q7
              local function r7()
                d7(t7)
              end
              i0.Activated:Connect(r7)
              local function r7()
                Q7.target = Q7.distance * 0.86
                if _G._KawatanSkinColor ~= t7 then
                  q7(I0, J7, {Color = X7, Transparency = 0})
                  q7(j7, J7, {TextColor3 = a7})
                end
              end
              i0.MouseEnter:Connect(r7)
              local function r7()
                Q7.target = Q7.distance
                if N7 then
                  N7()
                end
              end
              i0.MouseLeave:Connect(r7)
              d[t7] = {card = i0, stroke = I0, viewport = U7, world = _7, camera = Y7, label = j7, loading = n7, shot = Q7}
            end
            N7 = function()
              local U7 = g7()
              x7.Color = U7
              E7.TextColor3 = U7
              for n7, Q7 in pairs(d) do
                local j7 = n7 == _G._KawatanSkinColor
                q7(Q7.stroke, J7, {Color = (j7 and U7) or e7, Thickness = (j7 and 2) or 1, Transparency = 0})
                local U7, n7 = Q7.label, {}
                n7.TextColor3 = (j7 and a7) or A7
                q7(U7, J7, n7)
              end
            end
            N7()
            _G._KawatanRefreshGalleryCards = N7
            local U7 = 0
            M7(s.RenderStepped, function(n7)
              local Q7 = f7
              if not Q7 then
                return
              end
              U7 += n7
              Q7 = math.min(n7 * 9, 1)
              for j7, r7 in ipairs(z7) do
                n7 = r7.rig and r7.rig.Parent
                if n7 then
                  local n7 = i[48](276123176, 0)
                  j7 = n7
                  local k7, e7 = math.cos, U7 * 3
                  n7 = i:rQ((i:HQ(406708163, j7) + i:HQ(406708163, 318114587)) + (i:HQ(3888259134, (i[79](j7, 318114587))) + i:HQ(3888259132, (i[89](j7, 318114587)))))
                  local j7 = r7.phase
                  n7 = i[48](n7, 254774878)
                  local n7 = k7(e7 + j7) * 0.035
                  pcall(function()
                    r7.rig:PivotTo(CFrame.new(0, n7, 0) * CFrame.Angles(0, (3.141592653589793 + (U7 * 0.8)) + r7.phase, 0))
                  end)
                end
                if r7.camera.Parent then
                  r7.current = r7.current + ((r7.target - r7.current) * Q7)
                  r7.camera.CFrame = CFrame.lookAt(Vector3.new(0, m7, r7.current), Vector3.new(0, m7, 0))
                end
              end
            end)
            local function U7()
              local n7 = i[48](57444371, 0)
              local Q7 = n7
              f7 = false
              n7 = i:rQ(Q7 + 35612068)
              q7(P7, J7, {BackgroundTransparency = 1})
              local Q7, j7 = TweenInfo.new, Enum
              local r7, J7, k7, e7 = j7.EasingStyle.Quad, Enum.EasingDirection
              k7, e7, n7 = Q7(0.14, r7, J7.In), {}, i:rQ(n7 + 393096488)
              e7.Scale = 0.9
              q7(H7, k7, e7)
              task.delay(0.16, function()
                local n7 = f7
                if not n7 then
                  P7.Visible = false
                end
              end)
            end
            _7 = _G
            local function n7()
              local Q7 = i[48](115668441, 0)
              local j7 = Q7
              f7 = true
              N7()
              for r7, r7 in ipairs(z7) do
                r7.target = r7.distance
              end
              P7.Visible = true
              P7.BackgroundTransparency = 1
              H7.Scale = 0.9
              q7(P7, TweenInfo.new(0.2), {BackgroundTransparency = 0.42})
              local r7, J7 = q7, TweenInfo.new
              Q7 = i:rQ(j7 + 310014218)
              Q7 = i:rQ(Q7 - 113624241)
              r7(H7, J7(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
              j7 = Z7
              if j7 then
                return
              end
              Z7 = true
              task.spawn(function()
                for Q7, j7 in ipairs(_G._KawatanSkinSetOrder or {}) do
                  Q7 = d[j7]
                  if Q7 then
                    L7(j7, Q7)
                  end
                  task.wait(0.12)
                end
              end)
            end
            _7._KawatanOpenSkinGallery = n7
            _G._KawatanCloseSkinGallery = U7
            R7.Activated:Connect(U7)
            P7.MouseButton1Click:Connect(function()
              local d = V7 or ((os.clock() - v7) < 0.25)
              if d then
                return
              end
              U7()
            end)
            do
              local d, U7, n7
              K7.InputBegan:Connect(function(Q7)
                if (Q7.UserInputType ~= Enum.UserInputType.MouseButton1) and (Q7.UserInputType ~= Enum.UserInputType.Touch) then
                  return
                end
                local j7, r7
                j7, r7, V7 = Q7.Position, S7.Position, true
                d, U7, n7 = j7, r7, Q7
              end)
              K7.InputChanged:Connect(function(Q7)
                local j7 = (Q7.UserInputType == Enum.UserInputType.MouseMovement) or (Q7.UserInputType == Enum.UserInputType.Touch)
                if j7 then
                  n7 = Q7
                end
              end)
              M7(o7.InputChanged, function(Q7)
                local j7 = V7
                if not j7 then
                  return
                end
                j7 = (Q7 ~= n7) and (Q7.UserInputType ~= Enum.UserInputType.MouseMovement)
                if j7 then
                  return
                end
                j7 = Q7.Position - d
                S7.Position = UDim2.new(U7.X.Scale, U7.X.Offset + j7.X, U7.Y.Scale, U7.Y.Offset + j7.Y)
              end)
              M7(o7.InputEnded, function(d)
                local o7 = V7
                if not o7 then
                  return
                end
                o7 = ((d == n7) or (d.UserInputType == Enum.UserInputType.MouseButton1)) or (d.UserInputType == Enum.UserInputType.Touch)
                if o7 then
                  V7, n7 = false, nil
                  v7 = os.clock()
                end
              end)
            end
          end)()
          x, O7 = _G, {}
          O7.Destroy, x._CrystalCustomSkinsGalleryRuntime = function()
            local x, d = i[48](263207167, 0), q
            for o7, M7 in ipairs(d) do
              local d = i[48](364546993, 0)
              o7 = d
              local U7
              U7, d = pcall, i:rQ((i:HQ(1487435776, o7) + i:HQ(1487435776, 173112119)) + (i:HQ(2807531521, (i[79](o7, 173112119))) + i:HQ(2807531519, (i[89](o7, 173112119)))))
              U7(function()
                M7:Disconnect()
              end)
            end
            x, q = i[48](x, 78442175), {}
            pcall(function()
              gui:Destroy()
            end)
            _G._CrystalCustomSkinsGalleryRuntime = nil
          end, O7
        end)()
        do
          local q = _G.__CrystalVisualAppearanceState
          if (type(q) ~= "table") or (q.version ~= 2) then
            q = {version = 2}
            y, C = setmetatable, {__mode = "k"}
            q.headless = y({}, C)
            local x, d = setmetatable, {__mode = "k"}
            q.korblox = x({}, d)
            _G.__CrystalVisualAppearanceState = q
          else
          end
          q.setHeadless = function(x, d)
            d = d or F.Character
            local o7 = d and (d:FindFirstChild("Head"))
            if not o7 or not o7:IsA("BasePart") then
              return false
            end
            if x then
              if not q.headless[d] then
                local O7 = {headTransparency = o7.Transparency, headLocalTransparency = o7.LocalTransparencyModifier, faces = {}}
                for M7, M7 in ipairs(o7:GetChildren()) do
                  if M7:IsA("Decal") or M7:IsA("Texture") then
                    table.insert(O7.faces, {item = M7, transparency = M7.Transparency})
                  end
                end
                q.headless[d] = O7
              end
              o7.Transparency = 1
              o7.LocalTransparencyModifier = 1
              for O7, O7 in ipairs(o7:GetChildren()) do
                if O7:IsA("Decal") or O7:IsA("Texture") then
                  O7.Transparency = 1
                end
              end
              return true
            end
            x = q.headless[d]
            if not x then
              return false
            end
            o7.Transparency = x.headTransparency
            o7.LocalTransparencyModifier = x.headLocalTransparency
            for d, d in ipairs(x.faces) do
              if d.item and d.item.Parent then
                d.item.Transparency = d.transparency
              end
            end
            return true
          end
          q.setKorblox = function(x, d)
            d = d or F.Character
            if not d then
              return false
            end
            local o7 = q.korblox[d]
            if not x then
              local O7 = d:FindFirstChild("CrystalVisual_Korblox")
              if O7 then
                local M7 = i[48](69959912, 0)
                local U7
                U7, M7 = pcall, i:rQ(M7 + 1918982)
                U7(function()
                  O7:Destroy()
                end)
              end
              for O7, O7 in ipairs(d:GetChildren()) do
                if O7:IsA("CharacterMesh") and (O7.Name == "CrystalVisual_KorbloxCharacterMesh") then
                  pcall(function()
                    O7:Destroy()
                  end)
                end
              end
              if not o7 then
                return false
              end
              for O7, O7 in ipairs(o7.parts) do
                if O7.part and O7.part.Parent then
                  O7.part.Transparency = O7.transparency
                  O7.part.LocalTransparencyModifier = O7.localTransparency
                end
              end
              return true
            end
            x = d:FindFirstChild("LeftUpperLeg") or d:FindFirstChild("Left Leg")
            if not x or not x:IsA("BasePart") then
              return false
            end
            local O7, M7 = pcall(function()
              return game:GetObjects("rbxassetid://139607673")
            end)
            if (not O7 or not M7) or not M7[1] then
              warn("Crystal Korblox: no se pudo cargar el asset 139607673")
              return false
            end
            local U7 = d:FindFirstChild("CrystalVisual_Korblox")
            if U7 then
              pcall(function()
                U7:Destroy()
              end)
            end
            for U7, n7 in ipairs(d:GetChildren()) do
              if n7:IsA("CharacterMesh") and (n7.Name == "CrystalVisual_KorbloxCharacterMesh") then
                local Q7 = i[48](74563662, 0)
                O7 = Q7
                U7 = nil
                U7, Q7 = pcall, i:rQ((i:HQ(1389458241, O7) + i:HQ(1389458241, 318157005)) + (i:HQ(1516050814, (i[79](O7, 318157005))) + i:HQ(1389458242, (i[48](O7, 318157005)))))
                U7(function()
                  n7:Destroy()
                end)
              end
            end
            O7 = Instance.new("Model")
            O7.Name = "CrystalVisual_Korblox"
            for U7, U7 in ipairs(M7) do
              U7.Parent = O7
            end
            M7 = {}
            for U7, U7 in ipairs(O7:GetDescendants()) do
              if U7:IsA("BasePart") then
                table.insert(M7, U7)
              end
            end
            local U7 = {}
            for n7, n7 in ipairs(O7:GetDescendants()) do
              if n7:IsA("CharacterMesh") then
                table.insert(U7, n7)
              end
            end
            if (#M7 == 0) and (#U7 == 0) then
              O7:Destroy()
              warn("Crystal Korblox: el asset 139607673 no contiene piezas compatibles")
              return false
            end
            if not o7 then
              o7 = {parts = {}}
              local n7 = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}
              for Q7, j7 in ipairs(n7) do
                Q7 = d:FindFirstChild(j7)
                if Q7 and (Q7:IsA("BasePart")) then
                  table.insert(o7.parts, {part = Q7, transparency = Q7.Transparency, localTransparency = Q7.LocalTransparencyModifier})
                end
              end
              q.korblox[d] = o7
            else
            end
            O7.Parent = d
            if d:FindFirstChild("LeftUpperLeg") ~= nil then
              for n7, n7 in ipairs(o7.parts) do
                if n7.part and n7.part.Parent then
                  n7.part.Transparency = 1
                  n7.part.LocalTransparencyModifier = 1
                end
              end
            end
            for o7, n7 in ipairs(M7) do
              O7 = d:FindFirstChild(n7.Name)
              O7 = if not O7 or not O7:IsA("BasePart") then x else O7
              n7.Anchored = false
              n7.CanCollide = false
              n7.Massless = true
              n7.CFrame = O7.CFrame
              o7 = Instance.new("WeldConstraint")
              o7.Part0 = O7
              o7.Part1 = n7
              o7.Parent = n7
            end
            for x, x in ipairs(U7) do
              x.Name = "CrystalVisual_KorbloxCharacterMesh"
              x.Parent = d
            end
            return true
          end
          l["Headless Visual"] = function(x)
            q.setHeadless(x == true, F.Character)
          end
          l["Korblox Visual"] = function(x)
            task.spawn(q.setKorblox, x == true, F.Character)
          end
          _G.__CrystalTrackConn(F.CharacterAdded:Connect(function(x)
            task.wait(0.75)
            if h["Headless Visual"] then
              q.setHeadless(true, x)
            end
            if h["Korblox Visual"] then
              q.setKorblox(true, x)
            end
          end))
          if h["Headless Visual"] then
            task.delay(0.5, q.setHeadless, true, F.Character)
          end
          if h["Korblox Visual"] then
            task.delay(0.5, q.setKorblox, true, F.Character)
          end
        end
        do
          local q, x = {Ambient = o.Ambient, Brightness = o.Brightness, ClockTime = o.ClockTime, FogColor = o.FogColor, FogEnd = o.FogEnd, GlobalShadows = o.GlobalShadows, EnvironmentDiffuseScale = o.EnvironmentDiffuseScale, EnvironmentSpecularScale = o.EnvironmentSpecularScale, OutdoorAmbient = o.OutdoorAmbient}
          v = _G.__CrystalSkyChangerMode or "blue"
          local function d()
            local o7 = x
            if o7 then
              local o7 = i[48](193111067, 0)
              local O7 = o7
              local M7
              M7, o7 = pcall, i:rQ((i:HQ(824824855, O7) + i:HQ(824824855, 247223562)) + (i:HQ(2645317586, (i[79](O7, 247223562))) + i:HQ(824824856, (i[48](O7, 247223562)))))
              M7(function()
                x:Destroy()
              end)
              x = nil
            end
          end
          local function o7()
            local O7 = i[48](375236532, 0)
            local M7 = O7
            d()
            O7 = i:rQ(M7 + 530727071)
            M7 = nil
            M7, O7 = pcall, i:rQ(O7 - 368320319)
            M7(function()
              o.Ambient = q.Ambient
              o.Brightness = q.Brightness
              o.ClockTime = q.ClockTime
              o.FogColor = q.FogColor
              o.FogEnd = q.FogEnd
              o.GlobalShadows = q.GlobalShadows
              o.EnvironmentDiffuseScale = q.EnvironmentDiffuseScale
              o.EnvironmentSpecularScale = q.EnvironmentSpecularScale
              o.OutdoorAmbient = q.OutdoorAmbient
            end)
          end
          A = function(q)
            if (q == nil) or (q == "none") then
              o7()
              return
            end
            d()
            local d = Instance.new("ColorCorrectionEffect")
            d.Parent = o
            x = d
            if q == "blue" then
              o.Ambient = Color3.fromRGB(30, 60, 120)
              o.FogColor = Color3.fromRGB(40, 80, 160)
              d.TintColor = Color3.fromRGB(140, 180, 255)
              d.Saturation = 0.4
              d.Contrast = 0.1
            elseif q == "night" then
              o.ClockTime = 0
              o.Brightness = 0.2
              o.Ambient = Color3.fromRGB(20, 20, 35)
              d.TintColor = Color3.fromRGB(180, 180, 220)
              d.Saturation = -0.2
              d.Contrast = 0.1
            elseif q == "day" then
              o.ClockTime = 14
              o.Brightness = 2
              o.Ambient = Color3.fromRGB(140, 140, 140)
              d.TintColor = Color3.fromRGB(255, 255, 255)
              d.Saturation = 0.1
              d.Contrast = 0
            end
          end
          l["Sky Changer"] = function(o)
            if o then
              A(v)
            else
              o7()
            end
          end
          C = p7(T, "Sky Changer", "Sky Changer")
          if C then
            local o = Instance.new("TextButton", C)
            o.Name = "SkyModeBtn"
            o.Size = UDim2.new(0, 66, 0, 20)
            o.Position = UDim2.new(1, -74, 0.5, -10)
            o.AnchorPoint = Vector2.new(0, 0)
            o.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            o.BorderSizePixel = 0
            o.Text = "BLUE"
            o.TextColor3 = Color3.fromRGB(225, 238, 255)
            o.Font = Enum.Font.GothamBold
            o.TextSize = 10
            o.AutoButtonColor = false
            o.ZIndex = 30
            Instance.new("UICorner", o).CornerRadius = UDim.new(0, 4)
            local q = Instance.new("UIStroke", o)
            q.Color = Color3.fromRGB(255, 255, 255)
            q.Thickness = 1
            q.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local function x()
              local d = ((v == "day") and "DAY") or ((v == "night") and "NIGHT")
              o.Text = d or "BLUE"
              o.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
              o.TextColor3 = Color3.fromRGB(225, 238, 255)
              q.Color = Color3.fromRGB(255, 255, 255)
              q.Thickness = 1
              o.TextStrokeTransparency = 1
            end
            x()
            t(o, function()
              v = if v == "day" then "blue" else if v == "blue" then "night" else "day"
              _G.__CrystalSkyChangerMode = v
              w7()
              x()
              local o = h["Sky Changer"]
              if o then
                A(v)
              end
            end)
          end
          y = h["Sky Changer"]
          if y then
            task.delay(0.2, function()
              A(v)
            end)
          end
        end
        p7(T, "Show Buttons", "Show Buttons")
        p7(T, "Lock Buttons", "Lock Buttons")
        do
          C = Instance.new("Frame", T)
          C.Name = "MainThemesBtnContainer"
          C.Visible = true
          C.Size = UDim2.new(1, 0, 0, 30)
          C.BackgroundTransparency = 1
          C.BorderSizePixel = 0
          C.ZIndex = 12
          C.LayoutOrder = 20
          y = Instance.new("TextButton", C)
          y.Name = "MainThemesBtn"
          y.AnchorPoint = Vector2.new(0.5, 0)
          y.Size = UDim2.new(0, 150, 0, 30)
          y.Position = UDim2.new(0.5, 0, 0, 0)
          y.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
          y.BackgroundTransparency = 0.12
          y.AutoButtonColor = false
          y.Font = Enum.Font.GothamBold
          y.Text = "Colors"
          y.TextColor3 = Color3.fromRGB(235, 240, 245)
          y.TextSize = 11
          y.ZIndex = 12
          y.TextXAlignment = Enum.TextXAlignment.Center
          y.TextYAlignment = Enum.TextYAlignment.Center
          Instance.new("UICorner", y).CornerRadius = UDim.new(0, 8)
          local o = Instance.new("UIStroke", y)
          o.Color = Color3.fromRGB(255, 255, 255)
          o.Thickness = 1.2
          o.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          o.Transparency = 0.15
          local q = Instance.new("Frame")
          q.Name = "MainThemesPanel"
          q.Size = UDim2.fromOffset(260, 268)
          q.BackgroundColor3 = Color3.fromRGB(48, 92, 138)
          q.BorderSizePixel = 0
          q.Visible = false
          q.ZIndex = 20
          q.Parent = p
          o = Instance.new("UIGradient", q)
          o.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 75, 118)), ColorSequenceKeypoint.new(0.48, Color3.fromRGB(67, 120, 174)), ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 67, 108))})
          o.Rotation = 35
          local function x()
            if E then
              local d = E.Position.X.Offset + E.Size.X.Offset
              q.Position = UDim2.new(E.Position.X.Scale, d + 24, E.Position.Y.Scale, E.Position.Y.Offset + 6)
            end
          end
          if E then
            local function d()
              if _G.__CrystalModernGuiActive or not q.Parent then
                return
              end
              if q.Visible then
                x()
              end
            end
            E:GetPropertyChangedSignal("Position"):Connect(d)
            local function d()
              if _G.__CrystalModernGuiActive or not q.Parent then
                return
              end
              if q.Visible then
                x()
              end
            end
            E:GetPropertyChangedSignal("Size"):Connect(d)
            local d = false
            E:GetPropertyChangedSignal("Visible"):Connect(function()
              if _G.__CrystalModernGuiActive or not q.Parent then
                return
              end
              local o7 = not E.Visible
              if o7 then
                local o7 = q.Visible
                if o7 then
                  d = true
                  q.Visible = false
                else
                  d = false
                end
              else
                local o7 = d
                if o7 then
                  x()
                  q.Visible = true
                end
              end
            end)
          end
          Instance.new("UICorner", q).CornerRadius = UDim.new(0, 12)
          o = Instance.new("UIStroke", q)
          o.Color = Color3.fromRGB(0, 0, 0)
          o.Thickness = 0
          o.Transparency = 1
          local d, o7 = G7 or 1, {}
          local function O7()
            for M7, U7 in ipairs(o7) do
              local n7, Q7, j7, r7, J7, q7, _7, z7 = M7 == d, U7.card, U7.image, U7.stroke, U7.baseX, U7.baseY, U7.baseW, U7.baseH
              r7.Color = Color3.fromRGB(255, 255, 255)
              r7.Thickness = (n7 and 2) or 1.5
              r7.Transparency = (n7 and 0.25) or 0.7
              r7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
              Q7.Size = (n7 and UDim2.fromOffset(math.max(4, _7 - 6), math.max(4, z7 - 6))) or UDim2.fromOffset(_7, z7)
              Q7.Position = (n7 and UDim2.new(0, J7 + 3, 0, q7 + 3)) or UDim2.new(0, J7, 0, q7)
              Q7.BackgroundTransparency = 1
              j7.Size = UDim2.new(1, 0, 1, 0)
              j7.Position = UDim2.new(0, 0, 0, 0)
              j7.BackgroundTransparency = 1
            end
          end
          local function M7()
            if not q or not o7 then
              return
            end
            local U7, n7 = ((q.AbsoluteSize.X > 0) and q.AbsoluteSize.X) or q.Size.X.Offset, ((q.AbsoluteSize.Y > 0) and q.AbsoluteSize.Y) or q.Size.Y.Offset
            local Q7, j7 = math.max(0, U7 - 24), math.max(0, (n7 - 36) - 24)
            U7, n7 = math.floor((Q7 - 10) / 2), math.floor((j7 - 10) / 2)
            for r7, J7 in ipairs(o7) do
              j7, Q7 = (r7 - 1) % 2, math.floor((r7 - 1) / 2)
              local r7, q7 = 12 + (j7 * (U7 + 10)), 12 + (Q7 * (n7 + 10))
              J7.baseX = r7
              J7.baseY = q7
              J7.baseW = U7
              J7.baseH = n7
              J7.card.Size = UDim2.fromOffset(U7, n7)
              J7.card.Position = UDim2.new(0, r7, 0, q7)
              J7.image.Size = UDim2.new(1, 0, 1, 0)
              J7.image.Position = UDim2.new(0, 0, 0, 0)
            end
          end
          for U7, n7 in ipairs(b7) do
            o = Instance.new("TextButton", q)
            o.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            o.BackgroundTransparency = 1
            o.BorderSizePixel = 0
            o.Text = ""
            o.AutoButtonColor = false
            o.ZIndex = 21
            Instance.new("UICorner", o).CornerRadius = UDim.new(0, 7)
            local Q7 = Instance.new("ImageLabel", o)
            Q7.BackgroundTransparency = 1
            Q7.Image = n7
            Q7.ScaleType = Enum.ScaleType.Crop
            Q7.ZIndex = 21
            Instance.new("UICorner", Q7).CornerRadius = UDim.new(0, 7)
            n7 = Instance.new("TextLabel", o)
            n7.Size = UDim2.new(1, -12, 0, 12)
            n7.Position = UDim2.new(0, 6, 1, -14)
            n7.BackgroundTransparency = 1
            n7.Text = "GUI " .. tostring(U7)
            n7.TextColor3 = Color3.fromRGB(235, 240, 245)
            n7.TextSize = 8
            n7.Font = Enum.Font.GothamBold
            n7.ZIndex = 23
            n7.TextStrokeColor3 = Color3.fromRGB(5, 12, 25)
            n7.TextStrokeTransparency = 0.25
            n7 = Instance.new("UIStroke", o)
            n7.Color = Color3.fromRGB(255, 255, 255)
            n7.Thickness = 0
            n7.Transparency = 1
            n7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            table.insert(o7, {card = o, image = Q7, stroke = n7, baseX = 0, baseY = 0, baseW = 0, baseH = 0})
            o.Activated:Connect(function()
              d = U7
              O7()
            end)
          end
          o = Instance.new("TextButton", q)
          o.Size = UDim2.new(1, -24, 0, 28)
          o.Position = UDim2.new(0, 12, 1, -44)
          pcall(function()
            M7()
          end)
          local function o7()
            pcall(M7)
          end
          q:GetPropertyChangedSignal("AbsoluteSize"):Connect(o7)
          o.BackgroundColor3 = Color3.fromRGB(120, 180, 240)
          o.BorderSizePixel = 0
          o.Text = "Apply Color"
          o.TextColor3 = Color3.fromRGB(235, 240, 245)
          o.TextSize = 11
          o.Font = Enum.Font.GothamBold
          o.ZIndex = 21
          Instance.new("UICorner", o).CornerRadius = UDim.new(0, 7)
          o.Activated:Connect(function()
            G7 = d
            if T7 then
              T7.Image = b7[G7]
            end
            q.Visible = false
            if h7 then
              local o = i[48](55189205, 0)
              local o7 = o
              local M7
              M7, o = pcall, i:rQ(o7 + 162500498)
              M7(function()
                h7.Text = tostring(G7) .. ("/" .. tostring(#b7))
              end)
            end
            _G._CrystalHub_UI_BgIndex = G7
            local o = _G.__CrystalApplyCurtVisualTheme
            if o then
              pcall(_G.__CrystalApplyCurtVisualTheme, G7)
            end
            w7()
          end)
          y.Activated:Connect(function()
            d = G7
            x()
            q.Visible = not q.Visible
            O7()
          end)
          if h7 then
            pcall(function()
              h7.Visible = false
            end)
          end
        end
        do
          local o = i[48](149698058, 0)
          local q = _G.__CrystalQuickButtonsFrame
          o = i:rQ(o + 205340868)
          if q then
            pcall(function()
              q:Destroy()
            end)
          end
          T = nil
          T, o = Instance.new, i:rQ(o + 326119336)
          local q = T("Frame")
          o = i:rQ(o - 333214767)
          q.Name = "CrystalQuickButtons"
          o = i:rQ(o - 54005284)
          o = i:rQ(o + 130942071)
          C, y = UDim2.new, i:rQ(F7)
          o, q.Size = i:rQ((i:HQ(571640004, 4294967295) + o) + (i:HQ(3684359906, y) + i:HQ(3684359906, (i[100](y))))), C(1, 0, 1, 0)
          local x, d = UDim2, i:rQ(U)
          o = i:rQ((i:HQ(3996798296, 4294967295) + o) + (i:HQ(136252633, d) + i:HQ(136252633, (i[100](d)))))
          d = i:rQ(F7)
          o = i:rQ((i:HQ(3234847336, 4294967295) + o) + (i:HQ(1012161028, d) + i:HQ(1012161028, (i[100](d)))))
          d = x.new
          o = i:rQ(o - 143841405)
          q.Position = d(0, 0, 0, 0)
          q.BackgroundTransparency = 1
          o = i:rQ(o + 152643987)
          q.BorderSizePixel = 0
          x = i:rQ(U)
          o = i:rQ((i:HQ(826532104, 4294967295) + o) + (i:HQ(3687886544, x) + i:HQ(3687886544, (i[100](x)))))
          q.Active = false
          q.ZIndex = 750
          d = i:rQ(F7)
          o = i:rQ((i:HQ(2688680667, 4294967295) + o) + (i:HQ(1801505655, d) + i:HQ(1801505655, (i[100](d)))))
          q.Visible = h["Show Buttons"] == true
          q.Parent = p
          x, d = _G, i:rQ(F7)
          o = i:rQ((i:HQ(473648934, 4294967295) + o) + (i:HQ(3812923702, d) + i:HQ(3812923702, (i[100](d)))))
          o = i:rQ(o + 370916508)
          x.__CrystalQuickButtonsFrame = q
          d = i:rQ(U)
          o = i:rQ((i:HQ(1109375392, 4294967295) + o) + (i:HQ(3479879862, d) + i:HQ(3479879862, (i[100](d)))))
          local function o7(O7, F7)
            local M7 = Instance.new("TextButton")
            M7.Name = O7:gsub("%s+", "") .. "Button"
            local h7 = Instance.new("UIScale", M7)
            h7.Name = "QuickButtonSizeScale"
            h7.Scale = _G.__CrystalButtonsSize or 1
            M7.Size = UDim2.new(0, 72, 0, 58)
            local U7, n7 = (M and 72) or 81, (M and 12) or 16
            if F7 <= 3 then
              M7.Position = UDim2.new(0, n7, 0, U7 + ((F7 - 1) * 65))
            else
              h7 = F7 - 4
              M7.Position = UDim2.new(0, (n7 + 72) + 7, 0, U7 + (h7 * 65))
            end
            M7.LayoutOrder = F7
            M7:SetAttribute("OriginalPosition", M7.Position)
            M7.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            M7.BackgroundTransparency = 0
            M7.BorderSizePixel = 0
            M7.AutoButtonColor = false
            M7.Active = true
            M7.Draggable = false
            M7.Font = Enum.Font.GothamBold
            M7.Text = O7
            M7.TextScaled = true
            M7.TextWrapped = true
            M7.TextColor3 = Color3.fromRGB(255, 255, 255)
            M7.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            M7.TextStrokeTransparency = 0.35
            M7.ZIndex = 751
            M7.Parent = q
            Instance.new("UICorner", M7).CornerRadius = UDim.new(0, 12)
            n7 = Instance.new("UITextSizeConstraint")
            n7.MinTextSize = 11
            n7.MaxTextSize = 15
            n7.Parent = M7
            n7 = Instance.new("UIStroke")
            n7.Color = Color3.fromRGB(0, 0, 0)
            n7.Thickness = 1.2
            n7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            n7.Transparency = 0.2
            n7.Parent = M7
            return M7, n7
          end
          o = i:rQ(o + 15577768)
          local O7, F7 = o7("AIMBOT", 1)
          d = i:rQ(U)
          o = i:rQ((i:HQ(41059986, 4294967295) + i:HQ(1735001512, o)) + (i:HQ(1735001511, (i[100](o))) + (i:HQ(2607104272, d) + i:HQ(2607104272, (i[100](d))))))
          local M7, h7 = o7("BAT TP", 2)
          local U7, n7 = o7("TP DOWN", 3)
          local Q7, j7 = o7("DROP", 4)
          o = i:rQ(o + 18282651)
          local r7, J7 = o7("CARRY SPEED", 5)
          local q7, _7 = o7("LAGGER SPEED", 6)
          local z7, K7 = o7("AUTO PLAY", 7)
          o = i:rQ(o + 270316089)
          local k7 = {}
          o = i:rQ(o + 5802072)
          k7.custom = {}
          local e7, X7, C7 = k7.custom, k7.custom, i:rQ(U)
          o = i:rQ((i:HQ(3752743090, 4294967295) + o) + (i:HQ(758031038, C7) + i:HQ(758031038, (i[100](C7)))))
          o = i:rQ(o + 207924090)
          o = i:rQ(o - 94380703)
          d, C7 = o7("CUSTOM SPEED", 8)
          e7.button = d
          x = i:rQ(U)
          o = i:rQ((i:HQ(1751094823, 4294967295) + o) + (i:HQ(2376880272, x) + i:HQ(2376880272, (i[100](x)))))
          X7.stroke = C7
          d = k7.custom
          o = i:rQ(o - 368158526)
          x = d.button
          o = i:rQ(o + 316819222)
          x.Visible = true
          k7.custom.getByName = function(o)
            for U, U in ipairs(Q) do
              if U.name == o then
                return U
              end
            end
            return nil
          end
          k7.custom.getSelected = function()
            local o = k7.custom.getByName(J)
            if o then
              k7.custom.lastName = o.name
              return o
            end
            return k7.custom.getByName(k7.custom.lastName) or Q[1]
          end
          local function o(U, x, d)
            if d then
              local d = ((typeof(_G.__CrystalCurtAccent) == "Color3") and _G.__CrystalCurtAccent) or Color3.fromRGB(220, 70, 70)
              U.BackgroundColor3 = d
              U.BackgroundTransparency = 0
              U.TextColor3 = Color3.fromRGB(20, 6, 2)
              U.TextStrokeTransparency = 0.5
              x.Color = d:Lerp(Color3.fromRGB(255, 255, 255), 0.24)
              x.Thickness = 1.6
              x.Transparency = 0.1
            else
              U.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
              U.BackgroundTransparency = 0
              U.TextColor3 = Color3.fromRGB(255, 255, 255)
              U.TextStrokeTransparency = 0.35
              x.Color = Color3.fromRGB(0, 0, 0)
              x.Thickness = 1.2
              x.Transparency = 0.2
            end
          end
          local function U(x)
            local d = not (h[x] == true)
            if (d and ({})[x]) and (F:GetAttribute("Stealing") == true) then
              return
            end
            h[x] = d
            if V[x] then
              pcall(V[x], d)
            end
            if l[x] then
              pcall(l[x], d)
            end
            w7()
          end
          local V = {O7, M7, U7, Q7, r7, q7, z7, k7.custom.button}
          task.defer(function()
            for x, d in ipairs(V) do
              x = N[d.Name]
              if (x and x.x) and x.y then
                local o7, e7 = B(d, 0, x.x, 0, x.y, _G.__CrystalButtonsSize or 1)
                d.Position = UDim2.new(0, o7, 0, e7)
                N[d.Name] = {x = o7, y = e7}
              else
                local x = d.Position
                B(d, x.X.Scale, x.X.Offset, x.Y.Scale, x.Y.Offset, _G.__CrystalButtonsSize or 1)
              end
            end
          end)
          local x, d, o7, e7
          local X7 = false
          local function C7(a7)
            local A7 = tonumber((tostring(a7):gsub(",", ".")))
            if (not A7 or (A7 ~= A7)) or (math.abs(A7) == math.huge) then
              return _G.__CrystalButtonsSize
            end
            A7 = math.floor((math.clamp(A7, 0.5, 2) * 100) + 0.5) / 100
            _G.__CrystalButtonsSize = A7
            x, d, o7, e7, X7 = nil, nil, nil, nil, false
            for g7, g7 in ipairs(V) do
              g7.QuickButtonSizeScale.Scale = A7
              a7 = g7.Position
              local R7, S7 = B(g7, a7.X.Scale, a7.X.Offset, a7.Y.Scale, a7.Y.Offset, A7)
              if N[g7.Name] then
                N[g7.Name] = {x = R7, y = S7}
              end
            end
            w7()
            return A7
          end
          _G.__CrystalSetButtonsSize = C7
          k7.resetPositions = function()
            local C7 = x
            if C7 then
              local a7 = i[48](405972224, 0)
              local A7 = a7
              local g7 = x
              a7 = i:rQ((i:HQ(94281221, A7) + i:HQ(94281221, 36342515)) + (i:HQ(4106404854, (i[79](A7, 36342515))) + i:HQ(94281222, (i[48](A7, 36342515)))))
              k7[g7] = true
              A7 = nil
              A7, a7 = task.delay, i[48](a7, 263729468)
              A7(0.2, function()
                k7[g7] = nil
              end)
            end
            x, d, o7, e7, X7 = nil, nil, nil, nil, false
            table.clear(N)
            for a7, a7 in ipairs(V) do
              C7 = a7:GetAttribute("OriginalPosition")
              B(a7, C7.X.Scale, C7.X.Offset, C7.Y.Scale, C7.Y.Offset, _G.__CrystalButtonsSize or 1)
            end
            _G.__CrystalGuiPositionsReset = true
            for C7, C7 in pairs(_G.__CrystalGuiPositionResetters) do
              C7()
            end
            w7()
          end
          _G.__CrystalResetButtonPositions = k7.resetPositions
          local function C7()
            return h["Lock Buttons"] == true
          end
          local function a7(A7)
            local g7 = (not x or not d) or not o7
            if g7 then
              return
            end
            g7 = A7.Position - d
            A7 = g7.Magnitude > 6
            if A7 then
              X7 = true
            end
            local A7, R7 = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(0, 0), x.AbsoluteSize
            local S7, Z7, f7 = math.clamp(o7.X.Offset + g7.X, 0, math.max(0, A7.X - R7.X)), math.clamp(o7.Y.Offset + g7.Y, 0, math.max(0, A7.Y - R7.Y)), x
            f7.Position = UDim2.new(0, S7, 0, Z7)
          end
          for A7, A7 in ipairs(V) do
            A7.InputBegan:Connect(function(V)
              if C7() then
                return
              end
              local g7 = (V.UserInputType == Enum.UserInputType.MouseButton1) or (V.UserInputType == Enum.UserInputType.Touch)
              if g7 then
                x = A7
                d = V.Position
                o7, e7, X7 = A7.Position, V, false
              end
            end)
          end
          _G.__CrystalTrackConn(D.InputChanged:Connect(function(V)
            local A7 = not x or C7()
            if A7 then
              return
            end
            A7 = (V.UserInputType == Enum.UserInputType.MouseMovement) or (V == e7)
            if A7 then
              a7(V)
            end
          end))
          _G.__CrystalTrackConn(D.InputEnded:Connect(function(V)
            local C7 = (e7 and (e7.UserInputType == Enum.UserInputType.MouseButton1)) and (V.UserInputType == Enum.UserInputType.MouseButton1)
            C7 = x and ((V == e7) or C7)
            if C7 then
              local C7 = x
              V = C7
              x, d, o7, e7 = nil, nil, nil, nil
              local x = X7
              if x then
                local x = i[48](387784738, 0)
                local d = x
                N[V.Name] = {x = V.Position.X.Offset, y = V.Position.Y.Offset}
                x = i[48](d, 524783512)
                w7()
                x = i:rQ((i:HQ(1608720459, x) + i:HQ(1608720459, 292924775)) + (i:HQ(1077526378, (i[79](x, 292924775))) + i:HQ(1608720460, (i[48](x, 292924775)))))
                k7[V] = true
                task.delay(0.2, function()
                  k7[C7] = nil
                end)
              end
            end
          end))
          local function V(x, N)
            local d = i[48](8720289, 0)
            local o7 = d
            d = i:rQ(o7 + 485406890)
            o7 = nil
            o7, d = x.Activated, i:rQ(d - 63974473)
            o7:Connect(function()
              if k7[x] then
                k7[x] = nil
                return
              end
              N()
            end)
          end
          V(O7, function()
            U("Aimbot")
          end)
          V(M7, function()
            if _G.CrystalAutoBat and _G.CrystalAutoBat.Toggle then
              pcall(_G.CrystalAutoBat.Toggle)
            else
              U("TP Bat")
            end
          end)
          V(U7, function()
            if FeatureToggles["TP Down"] then
              pcall(FeatureToggles["TP Down"])
            end
          end)
          V(Q7, function()
            if FeatureToggles.Drop then
              pcall(FeatureToggles.Drop, "button")
            end
          end)
          V(r7, function()
            local x = X == "v2"
            if x then
              local X = i[48](509448366, 0)
              local x = X
              e = not e
              X = i:rQ(x + 182765981)
              h["Carry Speed"] = e
              h["Speed Boost"] = true
              x = _G
              X = i:rQ(X + 248959447)
              if x.__refreshSpeedBoost then
                pcall(_G.__refreshSpeedBoost)
              end
              if Y["Carry Speed"] then
                Y["Carry Speed"]()
              end
              pcall(function()
                if _G.__refreshSpeedBillboards then
                  _G.__refreshSpeedBillboards()
                end
              end)
              w7()
            elseif FeatureToggles["Carry Speed"] then
              pcall(FeatureToggles["Carry Speed"])
            else
              U("Carry Speed")
            end
          end)
          V(q7, function()
            local U = J
            if U == "Lagger" then
              if FeatureToggles.SelectNormalMode then
                pcall(FeatureToggles.SelectNormalMode)
              end
            elseif FeatureToggles.SelectLaggerMode then
              pcall(FeatureToggles.SelectLaggerMode)
            end
          end)
          V(z7, function()
            if FeatureToggles.Autoplay then
              pcall(FeatureToggles.Autoplay)
            end
          end)
          V(k7.custom.button, function()
            local U = k7.custom.getSelected()
            local X
            if U then
              local V = J
              X = V ~= U.name
            else
              X = U
            end
            if X then
              W7(U.name)
            end
          end)
          local U, X = 0, {}
          function _G.__CrystalRefreshQuickButtonTheme()
            X = {}
          end
          _G.__CrystalTrackConn(s.Heartbeat:Connect(function(V)
            U += V or 0
            V = U
            if V < 0.4 then
              return
            end
            U = 0
            V = h["Show Buttons"] == true
            local U = X.show ~= V
            if U then
              q.Visible = V
              X.show = V
            end
            if not V then
              return
            end
            local q, x, N, d, o7 = h.Aimbot == true, h["TP Bat"] == true, h["Carry Speed"] == true, h.Autoplay == true, k7.custom.getByName(J)
            V, U = o7 or k7.custom.getSelected(), X.carryVisible ~= true
            if U then
              r7.Visible = true
              X.carryVisible = true
            end
            U = X.aimbot ~= q
            if U then
              o(O7, F7, q)
              X.aimbot = q
            end
            q = X.autoBat ~= x
            if q then
              o(M7, h7, x)
              X.autoBat = x
            end
            x = X.carry ~= N
            if x then
              o(r7, J7, N)
              X.carry = N
            end
            x = X.autoplay ~= d
            if x then
              o(z7, K7, d)
              X.autoplay = d
            end
            x = (V and V.name) or nil
            q = (X.customName ~= x) or (X.customActive ~= (o7 ~= nil))
            if q then
              k7.custom.button.Text = (x and ("CUSTOM\n" .. string.upper(x))) or "NO CUSTOM"
              o(k7.custom.button, k7.custom.stroke, o7 ~= nil)
              X.customName = x
              d = X
              d.customActive = o7 ~= nil
            end
            o7 = J == "Lagger"
            V = X.lagger ~= o7
            if V then
              q7.Text = (o7 and "NORMAL SPEED") or "LAGGER SPEED"
              o(q7, _7, o7)
              X.lagger = o7
            end
            U = X.actionsInitialized ~= true
            if U then
              o(U7, n7, false)
              o(Q7, j7, false)
              X.actionsInitialized = true
            end
          end))
        end
        do
          y = u7(w.Visuals, "PANELS")
          T = Instance.new("Frame", y)
          T.Size = UDim2.new(1, -10, 0, 104)
          T.Position = UDim2.new(0, 5, 0, 28)
          T.BackgroundColor3 = Color3.fromRGB(20, 22, 31)
          T.BackgroundTransparency = 0.12
          T.BorderSizePixel = 0
          Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)
          C = Instance.new("UIStroke", T)
          C.Color = Color3.fromRGB(0, 0, 0)
          C.Thickness = 1.2
          C.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          C.Transparency = 0.15
          local o = Instance.new("Frame", T)
          o.Size = UDim2.new(1, -18, 0, 30)
          o.Position = UDim2.new(0, 9, 0, 10)
          o.BackgroundTransparency = 1
          local U = Instance.new("TextButton", o)
          U.Size = UDim2.new(1, 0, 1, 0)
          U.Position = UDim2.new(0, 0, 0, 0)
          U.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
          U.BackgroundTransparency = 0.15
          U.BorderSizePixel = 0
          U.Text = "LAGGER"
          U.TextColor3 = Color3.fromRGB(50, 110, 190)
          U.TextSize = 11
          U.Font = Enum.Font.GothamBold
          U.AutoButtonColor = false
          Instance.new("UICorner", U).CornerRadius = UDim.new(0, 6)
          local o = Instance.new("UIStroke", U)
          o.Color = Color3.fromRGB(0, 0, 0)
          o.Thickness = 1
          o.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          local q = false
          local function X()
            U.BackgroundColor3 = (q and Color3.fromRGB(80, 160, 255)) or Color3.fromRGB(30, 30, 38)
            U.TextColor3 = (q and Color3.fromRGB(255, 255, 255)) or Color3.fromRGB(50, 110, 190)
            o.Color = (q and Color3.fromRGB(255, 255, 255)) or Color3.fromRGB(0, 0, 0)
            o.Thickness = (q and 1.5) or 1
          end
          ;(function()
            local o = i[48](497452100, 0)
            local V = o
            local x, N = {Cartoon = {RunAnim = 742638842, WalkAnim = 742640026, JumpAnim = 742637942, FallAnim = 742637151, Swim = 742639220, SwimIdle = 742639812, ClimbAnim = 742636889, Idle = {742637544, 742638445, 885477856}}, ["Adidas Community"] = {WalkAnim = 122150855457006, RunAnim = 82598234841035, JumpAnim = 75290611992385, FallAnim = 98600215928904, SwimIdle = 109346520324160, Swim = 133308483266208, Animation1 = 122257458498464, Animation2 = 102357151005774, ClimbAnim = 88763136693023}, ["Adidas Aura"] = {WalkAnim = 83842218823011, RunAnim = 118320322718866, JumpAnim = 109996626521204, FallAnim = 95603166884636, SwimIdle = 94922130551805, Swim = 134530128383903, Animation1 = 110211186840347, Animation2 = 114191137265065, ClimbAnim = 97824616490448}, Zombie = {WalkAnim = 10921355261, RunAnim = 616163682, JumpAnim = 10921351278, FallAnim = 10921350320, SwimIdle = 10921353442, Swim = 10921352344, Animation1 = 10921344533, Animation2 = 10921345304, ClimbAnim = 10921343576}, ["Catwalk Glam"] = {WalkAnim = 109168724482748, RunAnim = 81024476153754, JumpAnim = 116936326516985, FallAnim = 92294537340807, SwimIdle = 98854111361360, Swim = 134591743181628, ClimbAnim = 119377220967554, Animation1 = 133806214992291, Animation2 = 94970088341563}, Toy = {WalkAnim = 10921312010, RunAnim = 10921306285, JumpAnim = 10921308158, FallAnim = 10921307241, SwimIdle = 10921310341, Swim = 10921309319, ClimbAnim = 10921300839, Animation1 = 10921301576}, ["Amazon Unboxed"] = {WalkAnim = 90478085024465, RunAnim = 134824450619865, JumpAnim = 121454505477205, FallAnim = 94788218468396, SwimIdle = 129126268464847, Swim = 105962919001086, ClimbAnim = 121145883950231, Animation1 = 98281136301627}, Vampire = {WalkAnim = 10921326949, RunAnim = 10921320299, JumpAnim = 10921322186, FallAnim = 10921321317, SwimIdle = 10921325443, Swim = 10921324408, ClimbAnim = 10921314188, Animation1 = 10921315373}}, {}
            o = i:rQ((i:HQ(833588056, V) + i:HQ(4294967295, 423411349)) + (i:HQ(2, (i[79](V, 423411349))) + (i:HQ(3461379239, 4294967295) + i:HQ(833588057, (i[100](V))))))
            N.RunAnim = 656118852
            N.WalkAnim = 656121766
            N.JumpAnim = 656117878
            N.FallAnim = 656115606
            N.Swim = 656119721
            N.SwimIdle = 656121397
            N.ClimbAnim = 656114359
            N.Idle = {656117400, 656118341, 886742569}
            x.Ninja = N
            local o, d = {"Cartoon", "Adidas Community", "Adidas Aura", "Zombie", "Catwalk Glam", "Toy", "Amazon Unboxed", "Vampire", "Ninja"}, 1
            local o7 = o[1]
            local function O7(F7)
              if not F7 then
                return nil
              end
              if type(F7) == "number" then
                return "rbxassetid://" .. tostring(F7)
              end
              if type(F7) == "string" then
                if string.sub(F7, 1, 11) == "rbxassetid://" then
                  return F7
                end
                if string.match(F7, "^%d+$") then
                  return "rbxassetid://" .. F7
                end
                return F7
              end
              return nil
            end
            local function F7(M7)
              local h7 = M7 and M7.Idle
              return {idle1 = O7(M7 and (M7.Animation1 or (h7 and h7[1]))), idle2 = O7(M7 and (M7.Animation2 or (h7 and h7[2]))), walk = O7(M7 and (M7.WalkAnim or M7.Walk)), run = O7(M7 and (M7.RunAnim or M7.Run)), jump = O7(M7 and (M7.JumpAnim or M7.Jump)), fall = O7(M7 and (M7.FallAnim or M7.Fall)), climb = O7(M7 and (M7.ClimbAnim or M7.Climb)), swim = O7(M7 and (M7.Swim or M7.SwimAnim)), swimidle = O7(M7 and (M7.SwimIdle or M7.SwimIdleAnim))}
            end
            local function O7(M7, h7)
              local U7 = i[48](484325324, 0)
              if not M7 or not h7 then
                return false
              end
              local n7 = M7:FindFirstChild("Animate")
              if not n7 then
                n7 = Instance.new("Animation")
                n7.Name = "Animate"
                n7.Parent = M7
              else
              end
              U7, _G.__ZurichHub_OriginalAnims = i:rQ(U7 + 353106001), _G.__ZurichHub_OriginalAnims or {}
              local Q7
              Q7, U7 = tostring, i:rQ(U7 - 29410090)
              local U7 = Q7(F.UserId or "local")
              if not _G.__ZurichHub_OriginalAnims[U7] then
                local j7, r7 = {}, {"idle", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}
                for J7, J7 in ipairs(r7) do
                  Q7 = n7:FindFirstChild(J7)
                  if Q7 then
                    for r7, r7 in ipairs(Q7:GetChildren()) do
                      pcall(function()
                        j7[J7 .. ("." .. r7.Name)] = r7.AnimationId
                      end)
                    end
                  end
                end
                _G.__ZurichHub_OriginalAnims[U7] = j7
              end
              local function U7(Q7, j7)
                local r7 = Q7:FindFirstChild(j7)
                if not r7 then
                  r7 = Instance.new("Animation")
                  r7.Name = j7
                  r7.Parent = Q7
                else
                end
                return r7
              end
              local function Q7(j7, r7, J7)
                if not J7 then
                  return
                end
                local q7 = j7:FindFirstChild(r7)
                if not q7 then
                  q7 = Instance.new("Animation")
                  q7.Name = r7
                  q7.Parent = j7
                else
                end
                q7.AnimationId = J7
              end
              local j7, r7, J7, q7, _7, z7, K7, k7 = U7(n7, "idle"), U7(n7, "walk"), U7(n7, "run"), U7(n7, "jump"), U7(n7, "fall"), U7(n7, "climb"), U7(n7, "swim"), U7(n7, "swimidle")
              Q7(j7, "Animation1", h7.idle1)
              Q7(j7, "Animation2", h7.idle2)
              Q7(r7, "WalkAnim", h7.walk)
              Q7(J7, "RunAnim", h7.run)
              Q7(q7, "JumpAnim", h7.jump)
              Q7(_7, "FallAnim", h7.fall)
              Q7(z7, "ClimbAnim", h7.climb)
              Q7(K7, "Swim", h7.swim)
              Q7(k7, "SwimIdle", h7.swimidle)
              _G.__ZurichHub_Anims = _G.__ZurichHub_Anims or {}
              for U7, n7 in pairs(h7) do
                if n7 then
                  _G.__ZurichHub_Anims[U7] = n7
                end
              end
              j7 = M7:FindFirstChildOfClass("Humanoid")
              if j7 then
                for M7, M7 in ipairs(j7:GetPlayingAnimationTracks()) do
                  local h7 = i[48](92159011, 0)
                  _7 = nil
                  _7, h7 = pcall, i:rQ(h7 + 161261160)
                  _7(function()
                    M7:Stop(0)
                  end)
                end
              end
              return true
            end
            local function M7(h7)
              if not h7 then
                return false
              end
              local U7 = tostring(F.UserId or "local")
              local n7 = _G.__ZurichHub_OriginalAnims and _G.__ZurichHub_OriginalAnims[U7]
              if not n7 then
                return false
              end
              U7 = h7:FindFirstChild("Animate")
              if not U7 then
                return false
              end
              for Q7, j7 in pairs(n7) do
                h7 = string.find(Q7, "%.")
                if h7 then
                  local n7 = i[48](312339599, 0)
                  local r7 = n7
                  local J7, q7, _7, z7, K7 = string.sub(Q7, 1, h7 - 1), string.sub, h7 + 1, i:HQ(1303615376, r7) + i:HQ(1303615376, 336979037)
                  n7, K7 = i:rQ(z7 + (i:HQ(1687736544, (i[79](r7, 336979037))) + i:HQ(1303615377, (i[48](r7, 336979037))))), q7(Q7, _7)
                  z7 = U7:FindFirstChild(J7)
                  if not z7 then
                    z7 = Instance.new("Animation")
                    z7.Name = J7
                    z7.Parent = U7
                  else
                  end
                  local h7 = z7:FindFirstChild(K7)
                  if not h7 then
                    h7 = Instance.new("Animation")
                    h7.Name = K7
                    h7.Parent = z7
                  else
                  end
                  J7 = nil
                  J7, n7 = pcall, i[48](n7, 343141476)
                  J7(function()
                    h7.AnimationId = j7
                  end)
                end
              end
              return true
            end
            local function h7(U7)
              local n7 = x[U7]
              if not n7 then
                return false
              end
              local Q7, j7 = F7(n7), F.Character
              if j7 then
                return O7(j7, Q7)
              else
                o7 = U7
                _G.__pendingAnimationPreset = U7
                return true
              end
            end
            local U7 = false
            local function n7()
              local Q7 = i[48](383849756, 0)
              local j7
              j7, Q7 = o7, i:rQ((i:HQ(1954149227, Q7) + i:HQ(1954149227, 522699968)) + (i:HQ(2340818070, (i[79](Q7, 522699968))) + i:HQ(2340818068, (i[89](Q7, 522699968)))))
              local r7 = (j7 or o[d]) or "Cartoon"
              local J7 = {presetIndex = d, presetName = r7}
              Q7 = i[48](Q7, 20578372)
              J7.enabled = U7
              local Q7, r7 = pcall(function()
                return O:JSONEncode(J7)
              end)
              if Q7 then
                local Q7 = i[48](212571375, 0)
                j7 = nil
                j7, Q7 = pcall, i[48](Q7, 21864623)
                j7(function()
                  writefile("AnimationSelector_Config.txt", r7)
                end)
              end
            end
            local function Q7()
              local j7 = i[48](92961986, 0)
              local r7 = j7
              local J7
              J7, j7 = pcall, i:rQ(r7 + 425703297)
              local j7, q7 = J7(function()
                return isfile("AnimationSelector_Config.txt")
              end)
              if not j7 or not q7 then
                return false
              end
              local _7, z7 = pcall(function()
                return readfile("AnimationSelector_Config.txt")
              end)
              if (not _7 or not z7) or (z7 == "") then
                return false
              end
              r7, _7 = pcall(function()
                return O:JSONDecode(z7)
              end)
              if not r7 or not _7 then
                return false
              end
              q7 = _7.presetName and x[_7.presetName]
              if q7 then
                o7 = _7.presetName
                for q7, z7 in ipairs(o) do
                  J7 = z7 == _7.presetName
                  if J7 then
                    d = q7
                    break
                  end
                end
              else
                j7 = (_7.presetIndex and (_7.presetIndex >= 1)) and (_7.presetIndex <= #o)
                if j7 then
                  d = _7.presetIndex
                  o7 = o[d]
                end
              end
              r7 = o7 == nil
              if r7 then
                o7 = o[d or 1]
              end
              U7 = false
              return true
            end
            pcall(Q7)
            N = (U7 and o7) and x[o7]
            if N then
              pcall(function()
                h7(o7)
              end)
            end
            N = (U7 and o7) and F.Character
            if N then
              pcall(function()
                h7(o7)
              end)
            end
            V = u7(w.Visuals, "ANIMATION PACK")
            N = V and V.Parent
            if N then
              for j7, r7 in ipairs(N:GetChildren()) do
                if r7:IsA("Frame") then
                  j7 = r7:FindFirstChildOfClass("TextLabel")
                  if j7 and (j7.Text == "ANIMATION PACK") then
                    for j7, j7 in ipairs(r7:GetChildren()) do
                      if ((j7:IsA("Frame") and j7.Size) and j7.Size.Y) and (j7.Size.Y.Offset == 1) then
                        j7:Destroy()
                        break
                      end
                    end
                    break
                  end
                end
              end
            end
            N = Instance.new("Frame", V)
            N.Size = UDim2.new(1, -10, 0, 68)
            N.Position = UDim2.new(0, 5, 0, 30)
            N.BackgroundColor3 = Color3.fromRGB(20, 22, 31)
            N.BackgroundTransparency = 0.12
            N.BorderSizePixel = 0
            N.Parent = V
            Instance.new("UICorner", N).CornerRadius = UDim.new(0, 8)
            V = Instance.new("UIStroke", N)
            V.Color = Color3.fromRGB(0, 0, 0)
            V.Thickness = 1.2
            V.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            V.Transparency = 0.15
            V = Instance.new("Frame", N)
            V.Size = UDim2.new(0, 72, 1, -10)
            V.Position = UDim2.new(0, 6, 0, 5)
            V.BackgroundColor3 = Color3.fromRGB(32, 35, 42)
            V.BackgroundTransparency = 0.08
            V.BorderSizePixel = 0
            Instance.new("UICorner", V).CornerRadius = UDim.new(0, 7)
            pcall(Q7)
            Q7 = (U7 and o7) and x[o7]
            if Q7 then
              pcall(function()
                h7(o7)
              end)
            end
            local j7 = Instance.new("TextButton", V)
            j7.Size = UDim2.new(1, -8, 1, -8)
            j7.Position = UDim2.new(0, 4, 0, 4)
            j7.BackgroundColor3 = Color3.fromRGB(50, 55, 64)
            j7.BorderSizePixel = 0
            j7.Text = "OFF"
            j7.TextColor3 = Color3.fromRGB(245, 247, 250)
            j7.TextSize = 10
            j7.Font = Enum.Font.GothamBold
            j7.AutoButtonColor = false
            j7.TextWrapped = false
            j7.ZIndex = 6
            Instance.new("UICorner", j7).CornerRadius = UDim.new(0, 5)
            pcall(function(r7)
              local J7 = Instance.new("UIStroke", r7)
              J7.Color = Color3.fromRGB(255, 255, 255)
              J7.Thickness = 0.8
              J7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            end, j7)
            local function r7()
              j7.Text = (U7 and "ON") or "OFF"
              j7.BackgroundColor3 = (U7 and Color3.fromRGB(82, 140, 220)) or Color3.fromRGB(52, 58, 68)
              j7.TextColor3 = Color3.fromRGB(255, 255, 255)
              j7.Font = Enum.Font.GothamBold
            end
            j7.Activated:Connect(function()
              U7 = not U7
              r7()
              local j7 = U7
              if j7 then
                h7(o7)
              elseif F.Character then
                M7(F.Character)
              end
              n7()
            end)
            local j7 = Instance.new("TextButton")
            j7.Size = UDim2.new(0, 32, 0, 32)
            j7.Position = UDim2.new(0, 88, 0.5, -16)
            j7.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            j7.BackgroundTransparency = 0.15
            j7.BorderSizePixel = 0
            j7.Text = "\226\151\132"
            j7.TextColor3 = Color3.fromRGB(240, 245, 255)
            j7.TextSize = 20
            j7.Font = Enum.Font.GothamBold
            j7.AutoButtonColor = false
            j7.ZIndex = 5
            j7.Parent = N
            pcall(function(J7)
              Instance.new("UICorner", J7).CornerRadius = UDim.new(0, 5)
              local q7 = Instance.new("UIStroke", J7)
              q7.Color = Color3.fromRGB(255, 255, 255)
              q7.Thickness = 0.8
              q7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            end, j7)
            V = Instance.new("Frame")
            V.Name = "AnimationPackSelector"
            V.Size = UDim2.new(1, -122, 0, 30)
            V.Position = UDim2.new(0, 108, 0, 19)
            V.BackgroundTransparency = 1
            V.Parent = N
            local J7 = Instance.new("TextLabel")
            J7.Size = UDim2.new(1, -36, 1, 0)
            J7.BackgroundTransparency = 1
            J7.Text = tostring(o7 or "")
            J7.TextColor3 = Color3.fromRGB(240, 245, 255)
            J7.TextSize = 12
            J7.Font = Enum.Font.GothamBold
            J7.TextXAlignment = Enum.TextXAlignment.Center
            J7.TextYAlignment = Enum.TextYAlignment.Center
            J7.ZIndex = 5
            J7.Parent = V
            J7.AnchorPoint = Vector2.new(0.5, 0.5)
            J7.Position = UDim2.new(0.5, 0, 0.5, 4)
            pcall(function(q7)
              local _7 = Instance.new("UIStroke", q7)
              _7.Color = Color3.fromRGB(255, 255, 255)
              _7.Thickness = 0.8
              _7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
              _7.Transparency = 1
            end, J7)
            local q7 = Instance.new("TextButton")
            q7.Size = UDim2.new(0, 32, 0, 32)
            q7.Position = UDim2.new(1, -32, 0.5, -16)
            q7.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            q7.BackgroundTransparency = 0.15
            q7.BorderSizePixel = 0
            q7.Text = "\226\150\186"
            q7.TextColor3 = Color3.fromRGB(240, 245, 255)
            q7.TextSize = 20
            q7.Font = Enum.Font.GothamBold
            q7.AutoButtonColor = false
            q7.ZIndex = 5
            q7.Parent = V
            pcall(function(_7)
              Instance.new("UICorner", _7).CornerRadius = UDim.new(0, 5)
              local z7 = Instance.new("UIStroke", _7)
              z7.Color = Color3.fromRGB(255, 255, 255)
              z7.Thickness = 0.8
              z7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            end, q7)
            local function _7(z7, K7)
              K7 = K7 or "next"
              J7.Text = tostring(z7 or "")
              J7.TextTransparency = 1
              J7.Position = UDim2.new(0.5, ((K7 == "next") and -90) or 90, 0.5, 0)
              local K7, k7 = TweenInfo.new, Enum
              local e7, X7 = k7.EasingStyle.Quad, Enum.EasingDirection
              z7, k7 = K7(0.18, e7, X7.Out), {}
              k7.Position, k7.TextTransparency = UDim2.new(0.5, 0, 0.5, 0), 0
              c:Create(J7, z7, k7):Play()
            end
            local function z7(K7)
              local k7 = i[48](360042259, 0)
              local e7 = k7
              local X7 = d
              local C7 = X7 + (((K7 == "next") and 1) or -1)
              C7 = if C7 < 1 then #o else C7
              C7 = if C7 > #o then 1 else C7
              d = C7
              o7 = o[d]
              _7(o7, K7)
              X7 = U7
              if X7 then
                h7(o7)
              elseif F.Character then
                M7(F.Character)
              end
              n7()
              X7 = nil
              X7, k7 = K7 == "next", i:rQ(e7 + 406828565)
              local o = (X7 and q7) or j7
              K7, e7 = TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(0, 80, 180)}
              local d, M7 = c:Create(o, K7, e7), i:rQ(C7)
              k7 = i:rQ((i:HQ(1181810405, 4294967295) + k7) + (i:HQ(3147685811, M7) + i:HQ(3147685811, (i[100](M7)))))
              d:Play()
              task.delay(0.08, function()
                local d, M7 = TweenInfo.new(0.08), {}
                M7.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
                c:Create(o, d, M7):Play()
              end)
            end
            local function o()
              z7("prev")
            end
            j7.MouseButton1Click:Connect(o)
            local function d()
              z7("next")
            end
            q7.MouseButton1Click:Connect(d)
            j7.Parent = V
            q7.Parent = V
            J7.Parent = V
            r7()
            N = U7 and o7
            if N then
              local V = i[48](469033968, 0)
              o = V
              Q7 = pcall
              V = i:rQ((i:HQ(308534774, o) + i:HQ(308534774, 69531779)) + (i:HQ(3986432523, (i[79](o, 69531779))) + i:HQ(3986432521, (i[89](o, 69531779)))))
              local function o()
                h7(o7)
              end
              Q7(o)
            end
            j7.Position = UDim2.new(0, -8, 0.5, -12)
            q7.Position = UDim2.new(1, -24, 0.5, -12)
            local function o()
              local V, d = TweenInfo.new(0.15), {BackgroundTransparency = 0}
              d.TextColor3 = Color3.fromRGB(255, 255, 255)
              c:Create(j7, V, d):Play()
            end
            j7.MouseEnter:Connect(o)
            local function o()
              local V, d = TweenInfo.new(0.15), {BackgroundTransparency = 0.15}
              d.TextColor3 = Color3.fromRGB(240, 245, 255)
              c:Create(j7, V, d):Play()
            end
            j7.MouseLeave:Connect(o)
            local function o()
              local V, d = TweenInfo.new(0.15), {BackgroundTransparency = 0}
              d.TextColor3 = Color3.fromRGB(255, 255, 255)
              c:Create(q7, V, d):Play()
            end
            q7.MouseEnter:Connect(o)
            local function o()
              local V, d = TweenInfo.new(0.15), {BackgroundTransparency = 0.15}
              d.TextColor3 = Color3.fromRGB(240, 245, 255)
              c:Create(q7, V, d):Play()
            end
            q7.MouseLeave:Connect(o)
            Q7, N = _G.__CrystalTrackConn, F.CharacterAdded
            local function o(V)
              task.wait(0.5)
              local d = U7
              if d then
                O7(V, (F7(x[o7])))
              end
            end
            Q7(N:Connect(o))
            task.spawn(function()
              task.wait(0.5)
              local o = F.Character and U7
              if o then
                local o = F7(x[o7])
                O7(F.Character, o)
              end
            end)
          end)()
          function _G.__CrystalReadSavedPanelVisibility(o)
            local V = i[48](3077280, 0)
            local x = V
            local N
            N, V = typeof(readfile), i:rQ(x + 206497759)
            if (N ~= "function") or (typeof(isfile) ~= "function") then
              return false, false
            end
            x = nil
            x, V = pcall, i:rQ(V + 327388463)
            local V, N = x(function()
              if not isfile(o) then
                return nil
              end
              local x = i[93](readfile(o))
              return O:JSONDecode(i:gQ(x))
            end)
            if not V or (type(N) ~= "table") then
              return false, false
            end
            return true, N.visible == true
          end
          local function o(V)
            local x = i[48](5705484, 0)
            local N = x
            if V == nil then
              V = true
            else
            end
            local d = game:GetService("Players").LocalPlayer
            x = i:rQ(N + 466468960)
            N = d and (d:FindFirstChild("PlayerGui"))
            if N and (N:FindFirstChild("CrystalLaggerGUI")) then
              d = N:FindFirstChild("CrystalLaggerGUI")
              if d and V then
                d.Visible = true
              end
              if _G.CrystalLagger and _G.CrystalLagger.SetVisible then
                _G.CrystalLagger.SetVisible(V)
              end
              return
            end
            if _G._CrystalLaggerGUILoaded then
              _G._CrystalLaggerGUILoaded = false
            end
            _G._CrystalLaggerGUILoaded = true
            _G.__openLaggerGUI = o
            N = nil
            N, x = task.spawn, i:rQ(x - 224860614)
            N(function()
              local x = i[48](373553752, 0)
              local N
              N, x = pcall, i:rQ((i:HQ(284299578, x) + i:HQ(284299578, 104438794)) + (i:HQ(4010667719, (i[79](x, 104438794))) + i:HQ(4010667717, (i[89](x, 104438794)))))
              N(function()
                local x = i[48](426899822, 0)
                local N = x
                local d = I.LocalPlayer:WaitForChild("PlayerGui")
                local I = d:FindFirstChild("CrystalLaggerGUI")
                if I then
                  I:Destroy()
                end
                local o7, O7, F7, M7, h7 = {TableIncrease = 270, Tries = 1, LoopWaitTime = 0.3, LowEndTableIncrease = 265, LowEndLoopWaitTime = 0.8}, {Main = false, LowEnd = false}, {Main = nil, LowEnd = nil}
                local function U7(n7)
                  local Q7, j7 = {}, {{}}
                  local r7 = j7[1]
                  for J7 = 1, n7, 1 do
                    J7 = {}
                    table.insert(r7, J7)
                    r7 = J7
                  end
                  for r7 = 1, math.min(499999 / (n7 + 2), 1500), 1 do
                    table.insert(Q7, j7)
                  end
                  return Q7
                end
                local function n7(Q7)
                  local j7 = i[48](225099916, 0)
                  local r7 = j7
                  local J7 = M7
                  j7 = i:rQ(r7 + 346960508)
                  r7 = J7 ~= Q7
                  j7 = i:rQ(j7 - 234869899)
                  J7 = r7 or not h7
                  if J7 then
                    M7 = Q7
                    h7 = U7(Q7)
                  end
                  pcall(function()
                    game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(h7)
                  end)
                end
                local function M7()
                  local h7 = i[48](267788203, 0)
                  local U7 = h7
                  if F7.Main then
                    return
                  end
                  h7 = i:rQ(U7 + 510083303)
                  U7 = nil
                  U7, h7 = task.spawn, i:rQ(h7 - 361108605)
                  F7.Main = U7(function()
                    while O7.Main do
                      local h7 = i[48](229652679, 0)
                      local U7 = h7
                      local Q7
                      Q7, h7 = pcall, i:rQ(U7 + 429831995)
                      Q7(function()
                        game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
                      end)
                      n7(o7.TableIncrease)
                      task.wait(o7.LoopWaitTime)
                    end
                  end)
                end
                local function h7()
                  local U7 = i[48](511710440, 0)
                  local Q7 = U7
                  U7 = i[48](Q7, 311069057)
                  if F7.LowEnd then
                    return
                  end
                  U7 = i:rQ((i:HQ(476865672, U7) + i:HQ(476865672, 37455939)) + (i:HQ(3341235952, (i[79](U7, 37455939))) + i:HQ(476865673, (i[48](U7, 37455939)))))
                  F7.LowEnd = task.spawn(function()
                    while O7.LowEnd do
                      local U7 = i[48](419016271, 0)
                      local Q7 = U7
                      local j7
                      j7, U7 = pcall, i:rQ((i:HQ(1169371141, Q7) + i:HQ(1169371141, 113945091)) + (i:HQ(3125596156, (i[79](Q7, 113945091))) + i:HQ(3125596154, (i[89](Q7, 113945091)))))
                      j7(function()
                        game:GetService("NetworkClient"):SetOutgoingKBPSLimit(25000)
                      end)
                      n7(o7.LowEndTableIncrease)
                      task.wait(o7.LowEndLoopWaitTime)
                    end
                  end)
                end
                local function U7(n7)
                  if F7[n7] then
                    task.cancel(F7[n7])
                    F7[n7] = nil
                  end
                end
                local function n7()
                  local Q7 = i[48](497082815, 0)
                  local j7 = Q7
                  Q7 = i:rQ((i:HQ(1603257065, j7) + i:HQ(1603257065, 53326382)) + (i:HQ(1088453166, (i[79](j7, 53326382))) + i:HQ(1603257066, (i[48](j7, 53326382)))))
                  O7.Main = false
                  O7.LowEnd = false
                  U7("Main")
                  U7("LowEnd")
                  Q7 = i[48](Q7, 458645057)
                  F7.Payload = nil
                  F7.PayloadAmount = nil
                  F7.Remote = nil
                  pcall(function()
                    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
                  end)
                end
                _G.__CrystalTrackStopper(n7)
                local function F7()
                  O7.Main = not O7.Main
                  if O7.Main then
                    if O7.LowEnd then
                      O7.LowEnd = false
                      U7("LowEnd")
                      if _G.__updateSmallLaggerVisual then
                        _G.__updateSmallLaggerVisual()
                      end
                    end
                    M7()
                  else
                    U7("Main")
                    if not O7.LowEnd then
                      local Q7 = i[48](456537581, 0)
                      local j7 = Q7
                      local r7
                      r7, Q7 = pcall, i:rQ(j7 + 200544340)
                      r7(function()
                        game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
                      end)
                    end
                  end
                  return O7.Main
                end
                local function Q7()
                  O7.LowEnd = not O7.LowEnd
                  if O7.LowEnd then
                    if O7.Main then
                      O7.Main = false
                      U7("Main")
                    end
                    h7()
                  else
                    U7("LowEnd")
                    if not O7.Main then
                      local j7 = i[48](395247608, 0)
                      local r7 = j7
                      local J7
                      J7, j7 = pcall, i:rQ(r7 + 353637913)
                      J7(function()
                        game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
                      end)
                    end
                  end
                  return O7.LowEnd
                end
                local j7, r7 = {"rbxassetid://128167124865101"}, 1
                local J7 = Color3.fromRGB(235, 240, 245)
                local q7, _7, z7, K7, k7 = Enum.KeyCode.V, false
                local e7, X7, C7 = false
                local a7, A7 = false
                local function g7()
                  return ((typeof(writefile) == "function") and (typeof(readfile) == "function")) and (typeof(isfile) == "function")
                end
                local function R7()
                  local S7 = i[48](468247702, 0)
                  local Z7 = S7
                  if not g7() or not X7 then
                    return
                  end
                  local f7 = {engineVersion = "legacy", mainEnabled = O7.Main, lowEndEnabled = O7.LowEnd, power = o7.TableIncrease, background = r7, keybind = (q7 and q7.Name) or "V"}
                  S7, f7.visible = i:rQ((i:HQ(1398379565, Z7) + i:HQ(1398379565, 208486129)) + (i:HQ(1498208166, (i[79](Z7, 208486129))) + i:HQ(1398379566, (i[48](Z7, 208486129))))), X7.Visible
                  f7.minimized = a7
                  Z7 = {}
                  S7, Z7.xScale = i[48](S7, 5130920), X7.Position.X.Scale
                  Z7.xOffset = X7.Position.X.Offset
                  Z7.yScale = X7.Position.Y.Scale
                  Z7.yOffset = X7.Position.Y.Offset
                  f7.position = Z7
                  pcall(function()
                    writefile("CrystalLagger_Settings.json", O:JSONEncode(f7))
                  end)
                end
                local function S7()
                  local Z7 = i[48](253812201, 0)
                  local f7 = Z7
                  local Y7
                  Y7, Z7 = not g7(), i:rQ((i:HQ(534654808, f7) + i:HQ(534654808, 320616480)) + (i:HQ(3760312489, (i[79](f7, 320616480))) + i:HQ(3760312487, (i[89](f7, 320616480)))))
                  Z7 = i[48](Z7, 454225246)
                  if Y7 then
                    return nil
                  end
                  Y7, f7 = pcall(function()
                    if isfile("CrystalLagger_Settings.json") then
                      local g7 = i[93](readfile("CrystalLagger_Settings.json"))
                      return O:JSONDecode(i:gQ(g7))
                    end
                    return nil
                  end)
                  return (Y7 and f7) or nil
                end
                local O = {ButtonA = "PAD A", ButtonB = "PAD B", ButtonX = "PAD X", ButtonY = "PAD Y", ButtonL1 = "PAD L1", ButtonR1 = "PAD R1", ButtonL2 = "PAD L2", ButtonR2 = "PAD R2", ButtonL3 = "PAD L3", ButtonR3 = "PAD R3", ButtonStart = "PAD START", ButtonSelect = "PAD SELECT", DPadUp = "DPAD UP", DPadDown = "DPAD DOWN", DPadLeft = "DPAD LEFT", DPadRight = "DPAD RIGHT"}
                local function g7(Z7)
                  return (Z7 and Z7.UserInputType) and (Z7.UserInputType.Name:match("^Gamepad%d+$") ~= nil)
                end
                local function Z7(f7)
                  return O[f7.Name] or f7.Name
                end
                local function O()
                  if K7 then
                    K7.Text = Z7(q7)
                    K7.TextColor3 = J7
                    K7.BackgroundTransparency = 0.2
                  end
                  if k7 then
                    k7.Color = Color3.fromRGB(0, 0, 0)
                  end
                end
                local function f7()
                  _7, e7 = false, false
                  local Y7 = z7
                  if Y7 then
                    z7:Disconnect()
                    z7 = nil
                  end
                  O()
                end
                I = Instance.new("ScreenGui")
                I.Name = "CrystalLaggerGUI"
                I.ResetOnSpawn = false
                I.IgnoreGuiInset = true
                local Y7
                Y7, x = Enum.ZIndexBehavior, i:rQ(N + 382564067)
                I.ZIndexBehavior = Y7.Sibling
                I.Parent = d
                _G.__CrystalRegisterThemeRoot(I)
                X7 = Instance.new("Frame")
                x = i:rQ(x + 153156116)
                X7.Name = "MainFrame"
                X7.Size = UDim2.fromOffset(270, 116)
                X7.Position = UDim2.new(0.5, -135, 0.5, -58)
                X7.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
                X7.BackgroundTransparency = 0
                X7.BorderSizePixel = 0
                X7.ClipsDescendants = true
                X7.Active = true
                X7.Parent = I
                X7.Visible = false
                Instance.new("UICorner", X7).CornerRadius = UDim.new(0, 16)
                N = nil
                N, x = Instance.new, i:rQ(x - 459286920)
                local V7 = N("UIStroke", X7)
                V7.Color = Color3.fromRGB(30, 30, 30)
                V7.Thickness = 1
                x = i:rQ(x + 391583172)
                V7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                V7.Transparency = 1
                C7 = Instance.new("ImageLabel")
                C7.Name = "BackgroundImage"
                Y7 = nil
                Y7, x = UDim2, i:rQ(x - 102821138)
                C7.Size = Y7.new(1, 0, 1, 0)
                C7.Position = UDim2.new(0, 0, 0, 0)
                C7.BackgroundTransparency = 1
                C7.Image = j7[1]
                C7.ScaleType = Enum.ScaleType.Crop
                C7.ImageTransparency = 0
                C7.ZIndex = 0
                C7.Parent = X7
                C7.Visible = true
                Instance.new("UICorner", C7).CornerRadius = UDim.new(0, 16)
                _G.__CrystalRoundPanelBackground(C7, X7)
                _G.__CrystalAddUnifiedPanelShade(X7, 16, 1)
                Y7 = Instance.new("Frame")
                Y7.Name = "Header"
                Y7.Size = UDim2.new(1, -12, 0, 30)
                Y7.Position = UDim2.fromOffset(6, 6)
                Y7.BackgroundTransparency = 1
                Y7.ZIndex = 2
                Y7.Parent = X7
                local v7 = Instance.new("TextLabel")
                v7.Name = "Title"
                v7.Text = ""
                v7.Font = Enum.Font.GothamBlack
                v7.TextColor3 = Color3.fromRGB(255, 255, 255)
                v7.TextSize = 16
                v7.BackgroundTransparency = 1
                N = nil
                N, x = UDim2.fromOffset(10, 0), i:rQ(x - 352126491)
                v7.Position = N
                v7.Size = UDim2.fromOffset(62, 20)
                v7.TextXAlignment = Enum.TextXAlignment.Left
                v7.ZIndex = 3
                v7.Parent = Y7
                d = Instance.new("TextLabel")
                d.Name = "LaggerLabel"
                d.Text = ""
                d.Font = Enum.Font.GothamBold
                d.TextColor3 = Color3.fromRGB(255, 255, 255)
                d.TextSize = 13
                d.BackgroundTransparency = 1
                d.Position = UDim2.fromOffset(70, 1)
                N = nil
                N, x = UDim2.fromOffset(58, 18), i:rQ(x + 233911442)
                d.Size = N
                d.TextXAlignment = Enum.TextXAlignment.Left
                d.ZIndex = 3
                d.Parent = Y7
                v7.AnchorPoint = Vector2.new(0.5, 0)
                v7.Position = UDim2.new(0.5, 0, 0, 12)
                v7.Size = UDim2.fromOffset(194, 26)
                _G.__EclipseAddOriginalGui3Title(v7, "Lagger")
                A7 = function()
                  v7.Visible = false
                end
                A7()
                d = Instance.new("TextButton")
                d.Name = "Close"
                d.Text = "X"
                d.Font = Enum.Font.GothamBold
                N = nil
                N, x = Color3.fromRGB, i:rQ(x + 224017660)
                d.TextColor3 = N(255, 255, 255)
                x = i:rQ(x - 342036166)
                d.TextSize = 14
                d.BackgroundTransparency = 1
                d.Size = UDim2.fromOffset(20, 20)
                d.Position = UDim2.new(1, -20, 0, 0)
                d.ZIndex = 3
                x = i:rQ(x + 402190527)
                d.Parent = Y7
                local v7 = Instance.new("TextButton")
                v7.Name = "Minimize"
                v7.Text = "-"
                v7.Font = Enum.Font.GothamBlack
                v7.TextColor3 = Color3.fromRGB(255, 255, 255)
                v7.TextSize = 16
                v7.BackgroundTransparency = 1
                v7.Size = UDim2.fromOffset(20, 20)
                v7.Position = UDim2.new(1, -44, 0, 0)
                v7.ZIndex = 3
                v7.Parent = Y7
                local l7 = Instance.new("TextButton")
                l7.Name = "MinimizedToggle"
                l7.Text = "LAG: OFF"
                l7.Font = Enum.Font.GothamBold
                l7.TextColor3 = Color3.fromRGB(235, 240, 245)
                l7.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l7.TextStrokeTransparency = 1
                l7.TextSize = 11
                l7.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                l7.BackgroundTransparency = 0.1
                l7.BorderSizePixel = 0
                l7.AutoButtonColor = false
                N = nil
                N, x = UDim2.fromOffset, i:rQ(x - 45716863)
                l7.Size = N(72, 22)
                l7.Position = UDim2.new(1, -120, 0, -1)
                l7.Visible = false
                l7.ZIndex = 5
                l7.Parent = Y7
                Instance.new("UICorner", l7).CornerRadius = UDim.new(0, 7)
                Y7 = Instance.new("UIStroke", l7)
                Y7.Color = Color3.fromRGB(0, 0, 0)
                Y7.Thickness = 1
                local m7 = Instance.new("Frame")
                m7.Name = "Controls"
                m7.Size = UDim2.new(1, -12, 0, 35)
                Y7 = UDim2.fromOffset
                x = i:rQ(x + 46656619)
                N = Y7(6, 73)
                x = i:rQ(x - 323863525)
                m7.Position = N
                Y7 = nil
                Y7, x = Color3.fromRGB, i:rQ(x + 29104982)
                m7.BackgroundColor3 = Y7(20, 20, 20)
                m7.BackgroundTransparency = 0.5
                m7.BorderSizePixel = 0
                m7.ZIndex = 2
                m7.Parent = X7
                Instance.new("UICorner", m7).CornerRadius = UDim.new(0, 10)
                K7 = Instance.new("TextButton")
                K7.Name = "KeybindButton"
                K7.Size = UDim2.fromOffset(32, 27)
                K7.Position = UDim2.new(0, 6, 0.5, -13.5)
                x = i:rQ(x + 255940773)
                K7.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                K7.BackgroundTransparency = 0
                K7.AutoButtonColor = false
                K7.Font = Enum.Font.GothamBold
                x = i:rQ(x - 422993395)
                K7.Text = Z7(q7)
                K7.TextColor3 = J7
                K7.TextSize = 10
                K7.ZIndex = 3
                K7.Parent = m7
                Instance.new("UICorner", K7).CornerRadius = UDim.new(0, 6)
                k7 = Instance.new("UIStroke", K7)
                k7.Color = Color3.fromRGB(50, 50, 50)
                k7.Thickness = 1
                k7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                local Z7 = Instance.new("TextLabel")
                Z7.Name = "Status"
                Z7.Text = "LAGGER: OFF"
                Z7.Font = Enum.Font.GothamBold
                Z7.TextColor3 = J7
                Z7.TextSize = 9
                Z7.BackgroundTransparency = 1
                Z7.Position = UDim2.fromScale(0, 0)
                Z7.Size = UDim2.fromScale(1, 1)
                Z7.TextXAlignment = Enum.TextXAlignment.Center
                Z7.ZIndex = 3
                Z7.Parent = m7
                N = Instance.new("Frame")
                N.Name = "Switch"
                N.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                N.BorderSizePixel = 0
                N.Size = UDim2.fromOffset(32, 18)
                Y7 = nil
                Y7, x = UDim2.new, i:rQ(x - 51128469)
                N.Position = Y7(1, -38, 0.5, -9)
                N.ZIndex = 3
                N.Parent = m7
                local P7, x7
                P7, x7, x = Instance.new("UICorner", N), UDim, i:rQ(x + 282392803)
                P7.CornerRadius = x7.new(1, 0)
                local H7 = Instance.new("Frame")
                H7.Name = "Knob"
                H7.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                H7.BorderSizePixel = 0
                H7.Size = UDim2.fromOffset(12, 12)
                H7.Position = UDim2.new(0, 3, 0.5, -6)
                H7.ZIndex = 4
                H7.Parent = N
                Instance.new("UICorner", H7).CornerRadius = UDim.new(1, 0)
                P7 = Instance.new("TextButton")
                P7.Name = "ToggleButton"
                P7.Text = ""
                P7.BackgroundTransparency = 1
                P7.Position = UDim2.fromOffset(44, 0)
                P7.Size = UDim2.new(1, -44, 1, 0)
                P7.ZIndex = 5
                P7.Parent = m7
                local E7
                local N7 = Instance.new("Frame")
                N7.Name = "PowerControl"
                N7.Size = UDim2.new(1, -12, 0, 43)
                N7.Position = UDim2.fromOffset(6, 80)
                N7.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                N7.BackgroundTransparency = 0.5
                N7.BorderSizePixel = 0
                N7.ZIndex = 2
                N7.Parent = X7
                N7.Visible = false
                Instance.new("UICorner", N7).CornerRadius = UDim.new(0, 10)
                local d7 = Instance.new("TextLabel")
                d7.Name = "PowerValue"
                d7.Size = UDim2.new(1, -12, 0, 16)
                d7.Position = UDim2.fromOffset(6, 2)
                d7.BackgroundTransparency = 1
                d7.Font = Enum.Font.GothamBold
                d7.TextColor3 = J7
                d7.TextSize = 10
                d7.TextXAlignment = Enum.TextXAlignment.Left
                d7.ZIndex = 3
                d7.Parent = N7
                local B7 = Instance.new("Frame")
                B7.Name = "Bar"
                B7.Size = UDim2.new(1, -12, 0, 8)
                B7.Position = UDim2.new(0, 6, 1, -15)
                B7.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
                B7.BorderSizePixel = 0
                B7.ZIndex = 3
                B7.Parent = N7
                Instance.new("UICorner", B7).CornerRadius = UDim.new(1, 0)
                local L7 = Instance.new("Frame")
                L7.Name = "Fill"
                Y7 = nil
                Y7, x = UDim2.fromScale, i:rQ(x + 173504300)
                L7.Size = Y7(0, 1)
                L7.BackgroundColor3 = Color3.fromRGB(235, 240, 245)
                L7.BorderSizePixel = 0
                L7.ZIndex = 4
                L7.Parent = B7
                Instance.new("UICorner", L7).CornerRadius = UDim.new(1, 0)
                local t7 = Instance.new("Frame")
                t7.Name = "Knob"
                t7.AnchorPoint = Vector2.new(0.5, 0.5)
                t7.Size = UDim2.fromOffset(14, 14)
                N = nil
                N, x = UDim2.new, i:rQ(x - 208715414)
                t7.Position = N(0, 0, 0.5, 0)
                x7 = nil
                x7, x = Color3.fromRGB, i:rQ(x - 126095173)
                t7.BackgroundColor3 = x7(255, 255, 255)
                t7.BorderSizePixel = 0
                t7.ZIndex = 5
                t7.Parent = B7
                Instance.new("UICorner", t7).CornerRadius = UDim.new(1, 0)
                Y7 = Instance.new("TextButton")
                Y7.Name = "PowerSlider"
                Y7.Size = UDim2.new(1, 12, 0, 24)
                Y7.Position = UDim2.new(0, -6, 0.5, -12)
                Y7.BackgroundTransparency = 1
                Y7.Text = ""
                Y7.Active = true
                Y7.ZIndex = 6
                Y7.Parent = B7
                local x = false
                local function N(x7, i0)
                  x7 = math.clamp(math.floor((tonumber(x7) or 0) + 0.5), 0, 290)
                  o7.TableIncrease = x7
                  local I0 = x7 / 290
                  L7.Size = UDim2.fromScale(I0, 1)
                  t7.Position = UDim2.new(I0, 0, 0.5, 0)
                  d7.Text = "POWER: " .. tostring(x7)
                  if i0 then
                    R7()
                  end
                end
                local function x7(d7)
                  local L7 = B7.AbsoluteSize.X
                  if L7 <= 0 then
                    return
                  end
                  N(math.clamp((d7.Position.X - B7.AbsolutePosition.X) / L7, 0, 1) * 290, false)
                end
                N(o7.TableIncrease, false)
                Y7.InputBegan:Connect(function(Y7)
                  local d7 = (Y7.UserInputType == Enum.UserInputType.MouseButton1) or (Y7.UserInputType == Enum.UserInputType.Touch)
                  if d7 then
                    x = true
                    x7(Y7)
                  end
                end)
                _G.__CrystalTrackConn(D.InputChanged:Connect(function(Y7)
                  local d7 = x and ((Y7.UserInputType == Enum.UserInputType.MouseMovement) or (Y7.UserInputType == Enum.UserInputType.Touch))
                  if d7 then
                    x7(Y7)
                  end
                end))
                _G.__CrystalTrackConn(D.InputEnded:Connect(function(Y7)
                  local x7 = x and ((Y7.UserInputType == Enum.UserInputType.MouseButton1) or (Y7.UserInputType == Enum.UserInputType.Touch))
                  if x7 then
                    x = false
                    N(o7.TableIncrease, true)
                  end
                end))
                K7.Activated:Connect(function()
                  local x = i[48](195632501, 0)
                  local Y7 = x
                  local x7 = _7
                  if x7 then
                    return
                  end
                  _7 = true
                  x, K7.Text = i:rQ(Y7 + 396990378), "..."
                  K7.TextColor3 = J7
                  K7.BackgroundTransparency = 0.6
                  x = i:rQ(x - 336842189)
                  if k7 then
                    k7.Color = Color3.fromRGB(0, 0, 0)
                  end
                  z7 = D.InputBegan:Connect(function(x)
                    local J7 = _7
                    if not J7 then
                      return
                    end
                    J7 = x.UserInputType == Enum.UserInputType.Keyboard
                    local K7 = J7 or g7(x)
                    if K7 then
                      local K7 = i[48](299122488, 0)
                      local k7 = K7
                      local Y7, x7 = x.KeyCode, Enum.KeyCode.Unknown
                      K7 = i:rQ(k7 + 255812265)
                      if Y7 == x7 then
                        return
                      end
                      if J7 and (x.KeyCode == Enum.KeyCode.Escape) then
                        f7()
                        return
                      end
                      q7, _7 = x.KeyCode, false
                      K7, e7 = i:rQ(K7 + 14921290), true
                      x7 = z7
                      if x7 then
                        z7:Disconnect()
                        z7 = nil
                      end
                      O()
                      R7()
                      task.delay(0.3, function()
                        e7 = false
                      end)
                    end
                  end)
                  task.delay(5, function()
                    local x = _7
                    if x then
                      f7()
                    end
                  end)
                end)
                local function x(J7, z7)
                  local K7 = (J7 and UDim2.new(1, -17, 0.5, -6)) or UDim2.new(0, 3, 0.5, -6)
                  if z7 then
                    c:Create(H7, TweenInfo.new(0.15), {Position = K7}):Play()
                  else
                    H7.Position = K7
                  end
                  Z7.Text = (J7 and "LAGGER: ON") or "LAGGER: OFF"
                  l7.Text = (J7 and "LAG: ON") or "LAG: OFF"
                  l7.BackgroundColor3 = (J7 and Color3.fromRGB(205, 210, 215)) or Color3.fromRGB(35, 35, 35)
                  l7.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
                local function J7()
                  x(F7(), true)
                  R7()
                end
                P7.MouseButton1Click:Connect(J7)
                local function J7()
                  x(F7(), true)
                  R7()
                end
                l7.Activated:Connect(J7)
                d.MouseButton1Click:Connect(function()
                  X7.Visible = false
                  q = false
                  X()
                  R7()
                end)
                local d = UDim2.fromOffset(270, 116)
                local J7 = UDim2.fromOffset(270, 30)
                local function z7(K7, k7)
                  a7 = K7 == true
                  v7.Text = (a7 and "+") or "-"
                  l7.Visible = a7
                  m7.Visible = not a7
                  N7.Visible = false
                  K7 = (a7 and J7) or d
                  if k7 then
                    c:Create(X7, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = K7}):Play()
                  else
                    X7.Size = K7
                  end
                end
                v7.Activated:Connect(function()
                  z7(not a7, true)
                  R7()
                end)
                _G.__CrystalTrackConn(D.InputBegan:Connect(function(d, J7)
                  local K7 = _7
                  if K7 then
                    return
                  end
                  K7 = e7
                  if K7 then
                    return
                  end
                  K7 = g7(d)
                  if J7 and not K7 then
                    return
                  end
                  if (d.UserInputType ~= Enum.UserInputType.Keyboard) and not K7 then
                    return
                  end
                  K7, J7 = d.KeyCode, q7
                  if K7 ~= J7 then
                    return
                  end
                  x(F7(), true)
                  R7()
                end))
                local d = 0
                X7:GetPropertyChangedSignal("Position"):Connect(function()
                  local J7 = i[48](249612562, 0)
                  local _7 = J7
                  d += 1
                  local K7, k7 = d, task
                  J7 = i:rQ(_7 + 207520170)
                  _7 = k7.delay
                  J7 = i:rQ(J7 - 121159138)
                  _7(0.3, function()
                    local J7 = d
                    if K7 == J7 then
                      R7()
                    end
                  end)
                end)
                local d, J7, _7 = false
                X7.InputBegan:Connect(function(K7)
                  local k7 = (K7.UserInputType == Enum.UserInputType.MouseButton1) or (K7.UserInputType == Enum.UserInputType.Touch)
                  if k7 then
                    d = true
                    J7 = K7.Position
                    _7 = X7.Position
                  end
                end)
                _G.__CrystalTrackConn(D.InputChanged:Connect(function(K7)
                  local k7 = d
                  if not k7 then
                    return
                  end
                  if (K7.UserInputType ~= Enum.UserInputType.MouseMovement) and (K7.UserInputType ~= Enum.UserInputType.Touch) then
                    return
                  end
                  k7 = K7.Position - J7
                  X7.Position = UDim2.new(_7.X.Scale, _7.X.Offset + k7.X, _7.Y.Scale, _7.Y.Offset + k7.Y)
                end))
                _G.__CrystalTrackConn(D.InputEnded:Connect(function(J7)
                  local _7 = (J7.UserInputType == Enum.UserInputType.MouseButton1) or (J7.UserInputType == Enum.UserInputType.Touch)
                  if _7 then
                    d = false
                  end
                end))
                local function J7()
                  local _7 = S7()
                  local K7 = not _7
                  if K7 then
                    x(false, false)
                    O()
                    X7.Visible = V == true
                    q = X7.Visible
                    X()
                    R7()
                    return
                  end
                  K7 = _7.keybind
                  if K7 then
                    local k7 = Enum.KeyCode[_7.keybind]
                    if k7 then
                      q7 = k7
                    end
                  end
                  if _7.power ~= nil then
                    K7 = tonumber(_7.power)
                    N((if (_7.engineVersion ~= "legacy") and (K7 == 90) then 270 else K7) or o7.TableIncrease, false)
                  end
                  O()
                  if _7.mainEnabled ~= nil then
                    O7.Main = (_7.mainEnabled == true) and not M
                    if O7.Main then
                      M7()
                    end
                    x(O7.Main, false)
                  end
                  if _7.lowEndEnabled ~= nil then
                    O7.LowEnd = (_7.lowEndEnabled == true) and not M
                    if O7.LowEnd then
                      h7()
                    end
                  end
                  K7 = _7.background
                  if K7 then
                    r7 = 1
                    C7.Image = j7[r7]
                    _G.__CrystalFramePanelBackground(C7, r7, "Lagger")
                    V7.Transparency = ((r7 == 1) and 1) or 0
                  end
                  if A7 then
                    A7()
                  end
                  if _7.position and not _G.__CrystalGuiPositionsReset then
                    local k7 = i[48](67578373, 0)
                    K7 = k7
                    local e7
                    e7, k7 = pcall, i:rQ((i:HQ(551921064, K7) + i:HQ(551921064, 164391130)) + (i:HQ(3743046233, (i[79](K7, 164391130))) + i:HQ(3743046231, (i[89](K7, 164391130)))))
                    e7(function()
                      X7.Position = UDim2.new(_7.position.xScale, _7.position.xOffset, _7.position.yScale, _7.position.yOffset)
                    end)
                  end
                  z7(_7.minimized == true, false)
                  if _7.visible ~= nil then
                    X7.Visible = (((V == true) and true) or (_7.visible and true)) or false
                  else
                    X7.Visible = V == true
                  end
                  q = X7.Visible
                  X()
                  R7()
                end
                for V, V in ipairs(I:GetDescendants()) do
                  if (V:IsA("TextLabel") or V:IsA("TextButton")) or V:IsA("TextBox") then
                    V:SetAttribute("EclipseKeepBlackText", true)
                    V.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    V.TextStrokeTransparency = 0.2
                  end
                end
                if A7 then
                  A7()
                end
                J7()
                r7 = 1
                C7.Image = j7[r7]
                _G.__CrystalFramePanelBackground(C7, r7, "Lagger")
                V7.Transparency = ((r7 == 1) and 1) or 0
                if A7 then
                  A7()
                end
                R7()
                local I, V = _G, {Stop = function()
                  n7()
                end, ResetPosition = function()
                  d = false
                  X7.Position = UDim2.new(0.5, -135, 0.5, -58)
                  R7()
                end, IsEnabled = function()
                  return O7.Main
                end, IsLowEndEnabled = function()
                  return O7.LowEnd
                end, Toggle = function()
                  local d = F7()
                  x(d, true)
                  R7()
                  return d
                end, ToggleLowEnd = function()
                  local d = Q7()
                  R7()
                  return d
                end, SetEnabled = function(d)
                  if O7.Main ~= d then
                    O7.Main = d
                    if d then
                      if O7.LowEnd then
                        O7.LowEnd = false
                        U7("LowEnd")
                      end
                      M7()
                    else
                      U7("Main")
                    end
                    x(O7.Main, true)
                    R7()
                  end
                end, SetLowEndEnabled = function(d)
                  if O7.LowEnd ~= d then
                    O7.LowEnd = d
                    if d then
                      if O7.Main then
                        O7.Main = false
                        U7("Main")
                        x(false, true)
                      end
                      h7()
                    else
                      U7("LowEnd")
                    end
                    R7()
                  end
                end, GetPower = function()
                  return o7.TableIncrease
                end, SetPower = function(x)
                  N(x, true)
                end}
                local function x()
                  local N = q7
                  return N
                end
                V.GetKeybind = x
                V.SetKeybind = function(x)
                  local N = if typeof(x) == "string" then Enum.KeyCode[x] else if (typeof(x) == "EnumItem") and (x.EnumType == Enum.KeyCode) then x else nil
                  if N then
                    q7 = N
                    O()
                    R7()
                  end
                end
                V.SetBackground = function(O)
                  r7 = 1
                  C7.Image = j7[r7]
                  _G.__CrystalFramePanelBackground(C7, r7, "Lagger")
                  V7.Transparency = ((r7 == 1) and 1) or 0
                  if A7 then
                    A7()
                  end
                  R7()
                end
                V.GetBackground = function()
                  local O = r7
                  return O
                end
                V.SetVisible = function(O)
                  if X7 then
                    local x = (O and true) or false
                    X7.Visible = x
                    q = x
                    X()
                    if not x and nil then
                      E7.Visible = false
                    end
                    R7()
                  end
                end
                V.SaveSettings = function()
                  R7()
                end
                I.CrystalLagger = V
              end)
            end)
          end
          _G.__openLaggerGUI = o
          local function I()
            q = false
            X()
            if _G.CrystalLagger and _G.CrystalLagger.SetVisible then
              _G.CrystalLagger.SetVisible(false)
            end
            if _G.CrystalLagger and _G.CrystalLagger.SaveSettings then
              _G.CrystalLagger.SaveSettings()
            end
          end
          t(U, function()
            q = not q
            X()
            local O = q
            if O then
              if _G._CrystalLaggerGUILoaded then
                if _G.CrystalLagger and _G.CrystalLagger.SetVisible then
                  _G.CrystalLagger.SetVisible(true)
                end
                if _G.CrystalLagger and _G.CrystalLagger.SaveSettings then
                  _G.CrystalLagger.SaveSettings()
                end
              else
                o(true)
              end
            else
              I()
            end
          end)
          local I, O = _G.__CrystalReadSavedPanelVisibility("CrystalLagger_Settings.json")
          q = (I and O) or false
          X()
          if I then
            o(false)
          end
          _G.__CrystalReadSavedPanelVisibility = nil
          O = Instance.new("Frame", T)
          O.Size = UDim2.new(1, -18, 0, 28)
          O.Position = UDim2.new(0, 9, 0, 68)
          O.BackgroundTransparency = 1
          O.Visible = true
          I = Instance.new("TextLabel", O)
          I.Size = UDim2.new(1, -50, 0, 32)
          I.Position = UDim2.new(0, 0, 0, 2)
          I.BackgroundTransparency = 1
          I.Text = "Toggle UI"
          I.TextColor3 = Color3.fromRGB(40, 80, 150)
          I.TextSize = 10
          I.Font = Enum.Font.GothamBold
          I.TextXAlignment = Enum.TextXAlignment.Left
          I.TextYAlignment = Enum.TextYAlignment.Center
          local I = Instance.new("TextButton", O)
          I.Size = UDim2.new(0, 40, 0, 20)
          I.Position = UDim2.new(1, -48, 0.5, -10)
          I.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
          I.BackgroundTransparency = 0.15
          I.BorderSizePixel = 0
          I.Text = (g["Toggle UI"] and D7(g["Toggle UI"])) or "-"
          I.TextColor3 = Color3.fromRGB(225, 238, 255)
          I.TextSize = 9
          I.Font = Enum.Font.GothamBold
          I.AutoButtonColor = false
          Instance.new("UICorner", I).CornerRadius = UDim.new(0, 4)
          O = Instance.new("UIStroke", I)
          O.Color = Color3.fromRGB(255, 255, 255)
          O.Thickness = 1
          O.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          t(I, function()
            local o = R
            if o then
              local o = R
              o.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
              R.BackgroundTransparency = 1
              R.Text = "-"
            end
            R, S = I, "Toggle UI"
            I.Text = "..."
            I.BackgroundColor3 = Color3.fromRGB(4, 18, 42)
            I.BackgroundTransparency = 0
          end)
          table.insert(Z, I)
          if Y["Toggle UI"] == nil then
            Y["Toggle UI"] = function()
              I.Text = (g["Toggle UI"] and D7(g["Toggle UI"])) or "-"
              I.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
              I.BackgroundTransparency = 0.15
              I.TextColor3 = Color3.fromRGB(225, 238, 255)
            end
          end
        end
        local I, o, O, U, q = u7(w.Animations, "ANIMATIONS"), {"Adidas Sports", "Adidas Community", "Adidas Aura", "Wicked Popular", "Elder", "Zombie", "Mage", "Catwalk Glam", "Astronaut", "Wicked \"Dancing Through Life\"", "Werewolf", "Superhero", "Toy", "No Boundaries", "NFL", "Amazon Unboxed", "Vampire", "Ninja", "Robot", "Levitation", "Stylish", "Bubbly", "Cartoon"}, {["Adidas Sports"] = {WalkAnim = 18537392113, RunAnim = 18537384940, JumpAnim = 18537380791, FallAnim = 18537367238, SwimIdle = 18537387180, Swim = 18537389531, Animation1 = 18537376492, Animation2 = 18537371272, ClimbAnim = 18537363391}, ["Adidas Community"] = {WalkAnim = 122150855457006, RunAnim = 82598234841035, JumpAnim = 75290611992385, FallAnim = 98600215928904, SwimIdle = 109346520324160, Swim = 133308483266208, Animation1 = 122257458498464, Animation2 = 102357151005774, ClimbAnim = 88763136693023}, ["Adidas Aura"] = {WalkAnim = 83842218823011, RunAnim = 118320322718866, JumpAnim = 109996626521204, FallAnim = 95603166884636, SwimIdle = 94922130551805, Swim = 134530128383903, Animation1 = 110211186840347, Animation2 = 114191137265065, ClimbAnim = 97824616490448}, ["Wicked Popular"] = {WalkAnim = 92072849924640, RunAnim = 72301599441680, JumpAnim = 104325245285198, FallAnim = 121152442762481, Animation1 = 118832222982049, ClimbAnim = 131326830509784, SwimIdle = 113199415118199, Swim = 99384245425157, Animation2 = 76049494037641}, Elder = {WalkAnim = 10921111375, RunAnim = 10921104374, JumpAnim = 10921107367, FallAnim = 10921105765, SwimIdle = 10921110146, Swim = 10921108971, ClimbAnim = 10921100400, Animation1 = 10921101664, Animation2 = 10921102574}, Zombie = {WalkAnim = 10921355261, RunAnim = 616163682, JumpAnim = 10921351278, FallAnim = 10921350320, SwimIdle = 10921353442, Swim = 10921352344, Animation1 = 10921344533, Animation2 = 10921345304, ClimbAnim = 10921343576}, Mage = {WalkAnim = 10921152678, RunAnim = 10921148209, JumpAnim = 10921149743, FallAnim = 10921148939, SwimIdle = 10921151661, Swim = 10921150788, ClimbAnim = 10921143404, Animation1 = 10921144709, Animation2 = 10921145797}, ["Catwalk Glam"] = {WalkAnim = 109168724482748, RunAnim = 81024476153754, JumpAnim = 116936326516985, FallAnim = 92294537340807, SwimIdle = 98854111361360, Swim = 134591743181628, ClimbAnim = 119377220967554, Animation1 = 133806214992291, Animation2 = 94970088341563}, Astronaut = {WalkAnim = 10921046031, RunAnim = 10921039308, JumpAnim = 10921042494, FallAnim = 10921040576, SwimIdle = 10921045006, Swim = 10921044000, ClimbAnim = 10921032124, Animation1 = 10921034824, Animation2 = 10921036806}, ["Wicked \"Dancing Through Life\""] = {WalkAnim = 73718308412641, RunAnim = 135515454877967, JumpAnim = 78508480717326, FallAnim = 78147885297412, SwimIdle = 129183123083281, Swim = 110657013921774, ClimbAnim = 129447497744818, Animation1 = 92849173543269, Animation2 = 132238900951109}, Werewolf = {WalkAnim = 10921342074, RunAnim = 10921336997, FallAnim = 10921337907, SwimIdle = 10921341319, Swim = 10921340419, ClimbAnim = 10921329322, Animation1 = 10921330408, Animation2 = 10921333667}, Superhero = {WalkAnim = 10921298616, RunAnim = 10921291831, JumpAnim = 10921294559, FallAnim = 10921293373, SwimIdle = 10921297391, Swim = 10921295495, ClimbAnim = 10921286911, Animation1 = 10921288909, Animation2 = 10921290167}, Toy = {WalkAnim = 10921312010, RunAnim = 10921306285, JumpAnim = 10921308158, FallAnim = 10921307241, SwimIdle = 10921310341, Swim = 10921309319, ClimbAnim = 10921300839, Animation1 = 10921301576}, ["No Boundaries"] = {WalkAnim = 18747074203, RunAnim = 18747070484, JumpAnim = 18747069148, FallAnim = 18747062535, SwimIdle = 18747071682, Swim = 18747073181, ClimbAnim = 18747060903, Animation1 = 18747067405, Animation2 = 18747063918}, NFL = {WalkAnim = 110358958299415, RunAnim = 117333533048078, JumpAnim = 119846112151352, FallAnim = 129773241321032, SwimIdle = 79090109939093, Swim = 132697394189921, ClimbAnim = 134630013742019, Animation1 = 92080889861410, Animation2 = 74451233229259}, ["Amazon Unboxed"] = {WalkAnim = 90478085024465, RunAnim = 134824450619865, JumpAnim = 121454505477205, FallAnim = 94788218468396, SwimIdle = 129126268464847, Swim = 105962919001086, ClimbAnim = 121145883950231, Animation1 = 98281136301627}, Vampire = {WalkAnim = 10921326949, RunAnim = 10921320299, JumpAnim = 10921322186, FallAnim = 10921321317, SwimIdle = 10921325443, Swim = 10921324408, ClimbAnim = 10921314188, Animation1 = 10921315373}, Ninja = {RunAnim = 656118852, WalkAnim = 656121766, JumpAnim = 656117878, FallAnim = 656115606, Swim = 656119721, SwimIdle = 656121397, ClimbAnim = 656114359, Idle = {656117400, 656118341, 886742569}}, Robot = {RunAnim = 616091570, WalkAnim = 616095330, JumpAnim = 616090535, FallAnim = 616087089, Swim = 616092998, SwimIdle = 616094091, ClimbAnim = 616086039, Idle = {616088211, 616089559, 885531463}}, Levitation = {RunAnim = 616010382, WalkAnim = 616013216, JumpAnim = 616008936, FallAnim = 616005863, Swim = 616011509, SwimIdle = 616012453, ClimbAnim = 616003713, Idle = {616006778, 616008087, 886862142}}, Stylish = {RunAnim = 616140816, WalkAnim = 616146177, JumpAnim = 616139451, FallAnim = 616134815, Swim = 616143378, SwimIdle = 616144772, ClimbAnim = 616133594, Idle = {616136790, 616138447, 886888594}}, Bubbly = {RunAnim = 910025107, WalkAnim = 910034870, JumpAnim = 910016857, FallAnim = 910001910, Swim = 910028158, SwimIdle = 910030921, ClimbAnim = 909997997, Idle = {910004836, 910009958, 1018536639}}, Cartoon = {RunAnim = 742638842, WalkAnim = 742640026, JumpAnim = 742637942, FallAnim = 742637151, Swim = 742639220, SwimIdle = 742639812, ClimbAnim = 742636889, Idle = {742637544, 742638445, 885477856}}}, {"idle1", "idle2", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}, {idle1 = "Idle 1", idle2 = "Idle 2", walk = "Walk", run = "Run", jump = "Jump", fall = "Fall", climb = "Climb", swim = "Swim", swimidle = "Swim Idle"}
        local function w(X)
          if not X then
            return nil
          end
          if type(X) == "number" then
            return "rbxassetid://" .. tostring(X)
          end
          if type(X) == "string" then
            local V = string.gsub(X, "^%s+", "")
            V = string.gsub(V, "%s+$", "")
            if V == "" then
              return nil
            end
            if string.sub(V, 1, 11) == "rbxassetid://" then
              return V
            end
            if string.match(V, "^%d+$") then
              return "rbxassetid://" .. V
            end
            return V
          end
          return nil
        end
        local function X(V)
          local x = V and V.Idle
          return {idle1 = w(V and (V.Animation1 or (x and x[1]))), idle2 = w(V and (V.Animation2 or (x and x[2]))), walk = w(V and (V.WalkAnim or V.Walk)), run = w(V and (V.RunAnim or V.Run)), jump = w(V and (V.JumpAnim or V.Jump)), fall = w(V and (V.FallAnim or V.Fall)), climb = w(V and (V.ClimbAnim or V.Climb)), swim = w(V and (V.Swim or V.SwimAnim)), swimidle = w(V and (V.SwimIdle or V.SwimIdleAnim))}
        end
        local w, V = {}, {idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563", walk = "rbxassetid://707897309", run = "rbxassetid://707861613", jump = "rbxassetid://116936326516985", fall = "rbxassetid://116936326516985", climb = "rbxassetid://116936326516985", swim = "rbxassetid://116936326516985", swimidle = "rbxassetid://116936326516985"}
        _G.__CrystalHub_Anims = V
        local x, N = {}, {}
        for d, o7 in pairs(O) do
          y = X(o7)
          for o7, o7 in ipairs(U) do
            T = y[o7]
            if T then
              C = d .. (" " .. q[o7])
              if not N[C] then
                N[C] = T
                x[T] = C
              end
            end
          end
        end
        local function d(o7)
          if not o7 then
            return ""
          end
          if o7 == "rbxassetid://" then
            return "Custom"
          end
          return x[o7] or o7
        end
        local x = {}
        for o7, o7 in ipairs(U) do
          x[o7] = {}
        end
        for o7, O7 in ipairs(o) do
          y = O[O7]
          if y then
            N = X(y)
            for O7, O7 in ipairs(U) do
              o7 = N[O7]
              if o7 and not table.find(x[O7], o7) then
                table.insert(x[O7], o7)
              end
            end
          end
        end
        local function N(o7, O7)
          local F7 = x[o7]
          if not F7 or not O7 then
            return
          end
          local x, M7 = V[o7], 1
          for h7, u7 in ipairs(F7) do
            if u7 == x then
              M7 = (h7 % #F7) + 1
              break
            end
          end
          V[o7] = F7[M7]
          O7.Text = d(F7[M7])
          w7()
          if h["Harder Hit Anim"] and saveOriginalAnims then
            x = F.Character
            if x then
              saveOriginalAnims(x)
              applyAnimPack(x)
            end
          end
        end
        local x = o[1]
        local function o7(O7)
          local F7 = O[O7]
          if not F7 then
            return
          end
          local M7 = X(F7)
          x = O7
          V.idle1 = M7.idle1 or V.idle1
          V.idle2 = M7.idle2 or V.idle2
          V.walk = M7.walk or V.walk
          V.run = M7.run or V.run
          V.jump = M7.jump or V.jump
          V.fall = M7.fall or V.fall
          V.climb = M7.climb or V.climb
          V.swim = M7.swim or V.swim
          V.swimidle = M7.swimidle or V.swimidle
          if (h["Harder Hit Anim"] and saveOriginalAnims) and applyAnimPack then
            O7 = F.Character
            if O7 then
              saveOriginalAnims(O7)
              applyAnimPack(O7)
            end
          end
        end
        local function O7(F7)
          local M7 = O[F7]
          if not M7 then
            return
          end
          local h7 = X(M7)
          for X, X in ipairs(U) do
            M7 = w[X]
            if M7 then
              M7.Text = d(h7[X] or "")
            end
          end
          o7(F7)
        end
        p7(I, "Animaciones (Master)", "Animaciones")
        l.Animaciones = function(X)
          if h["Harder Hit Anim"] == X then
            return
          end
          h["Harder Hit Anim"] = X
          if l["Harder Hit Anim"] then
            l["Harder Hit Anim"](X)
          end
          if Y["Harder Hit Anim"] then
            Y["Harder Hit Anim"]()
          end
          w7()
        end
        local X = Instance.new("TextButton", I)
        X.Size = UDim2.new(1, 0, 0, 34)
        X.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        X.BorderSizePixel = 0
        X.Text = "Preset: " .. x
        X.TextColor3 = Color3.fromRGB(255, 255, 255)
        X.TextSize = 11
        X.Font = Enum.Font.GothamBold
        X.AutoButtonColor = false
        Instance.new("UICorner", X).CornerRadius = UDim.new(0, 8)
        t(X, function()
          local t = 1
          for o7, F7 in ipairs(o) do
            local M7 = x
            if F7 == M7 then
              t = o7
              break
            end
          end
          local o7 = t + 1
          local t = o[if o7 > #o then 1 else o7]
          X.Text = "Preset: " .. t
          O7(t)
          w7()
        end)
        local X = Instance.new("Frame", I)
        X.Size = UDim2.new(1, -2, 0, 0)
        X.BackgroundTransparency = 1
        X.ClipsDescendants = false
        local t = Instance.new("UIListLayout", X)
        t.Padding = UDim.new(0, 6)
        t.SortOrder = Enum.SortOrder.LayoutOrder
        local function o7()
          X.Size = UDim2.new(1, -2, 0, t.AbsoluteContentSize.Y)
        end
        t:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(o7)
        for t, t in ipairs(U) do
          o7 = Instance.new("Frame", X)
          o7.Size = UDim2.new(1, 0, 0, 30)
          o7.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
          o7.BackgroundTransparency = 0.25
          o7.BorderSizePixel = 0
          Instance.new("UICorner", o7).CornerRadius = UDim.new(0, 8)
          C = Instance.new("TextLabel", o7)
          C.Size = UDim2.new(0.48, 0, 1, 0)
          C.Position = UDim2.new(0, 8, 0, 0)
          C.BackgroundTransparency = 1
          C.Text = q[t]
          C.TextColor3 = Color3.fromRGB(220, 220, 230)
          C.TextSize = 11
          C.Font = Enum.Font.GothamBold
          C.TextXAlignment = Enum.TextXAlignment.Left
          local U = Instance.new("TextButton", o7)
          U.Size = UDim2.new(0.5, -10, 0, 20)
          U.Position = UDim2.new(0.5, 0, 0.5, -10)
          U.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
          U.BorderSizePixel = 0
          U.Text = ""
          U.TextColor3 = Color3.fromRGB(255, 255, 255)
          U.TextSize = 10
          U.Font = Enum.Font.Gotham
          U.AutoButtonColor = false
          Instance.new("UICorner", U).CornerRadius = UDim.new(0, 6)
          local function X()
            N(t, U)
          end
          U.Activated:Connect(X)
          w[t] = U
        end
        y = Instance.new("TextLabel", I)
        y.Size = UDim2.new(1, 0, 0, 24)
        y.BackgroundTransparency = 1
        y.Text = "Master: activa/desactiva todas. Toca una animacion para pasar a la siguiente."
        y.TextColor3 = Color3.fromRGB(140, 180, 220)
        y.TextSize = 10
        y.Font = Enum.Font.Gotham
        y.TextXAlignment = Enum.TextXAlignment.Left
        O7(x)
        if _G.__savedAnimations then
          for U, X in pairs(_G.__savedAnimations) do
            if V[U] ~= nil then
              V[U] = X
              I = w[U]
              if I then
                I.Text = d(X)
              end
            end
          end
          _G.__savedAnimations = nil
        end
        local w
        _G.__toggleBtn = nil
        local U = Instance.new("UIScale", E)
        U.Scale = 1
        local X = h["Toggle UI"] ~= false
        q = type(_G.__CrystalPanelVisible) == "boolean"
        if q then
          X = _G.__CrystalPanelVisible
        else
        end
        C = h["Toggle UI"] ~= X
        if C then
          h["Toggle UI"] = X
        end
        if Y["Toggle UI"] then
          Y["Toggle UI"]()
        end
        local q, V, N, d = false, false
        function setPanelVisible(t)
          local o7 = i[48](53436544, 0)
          t = t == true
          o7, _G.__CrystalPanelVisible = i:rQ(o7 + 369663103), t
          h["Toggle UI"] = t
          local O7 = E.Visible == t
          if O7 then
            X = t
            local F7 = N
            if F7 then
              N.Visible = not t
            end
            F7 = d
            if F7 then
              d.Visible = not t
            end
            w7()
            return
          end
          O7 = q or V
          if O7 then
            return
          end
          V = true
          O7 = nil
          O7, o7 = task.delay, i:rQ(o7 - 323763668)
          O7(0.3, function()
            V = false
          end)
          X = t
          if t then
            E.Visible = true
            O7 = N
            if O7 then
              N.Visible = false
            end
            local V = d
            if V then
              d.Visible = false
            end
            U.Scale = 0.92
            E.BackgroundTransparency = 0.2
            c:Create(U, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            c:Create(E, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2}):Play()
          else
            local V = i[48](85649489, 0)
            q = true
            V = i:rQ(V + 109635649)
            c:Create(U, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.9}):Play()
            c:Create(E, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.8}):Play()
            local t
            t, V = task, i:rQ(V - 10376271)
            t.delay(0.16, function()
              E.Visible = false
              local V = N
              if V then
                N.Visible = true
              end
              V = d
              if V then
                d.Visible = true
              end
              U.Scale = 1
              E.BackgroundTransparency = 0.95
              q = false
            end)
          end
          if Y["Toggle UI"] then
            Y["Toggle UI"]()
          end
          w7()
        end
        E.Visible = false
        _G.__setPanelVisible = setPanelVisible
        FeatureToggles["Toggle UI"] = function()
          setPanelVisible(not E.Visible)
        end
        G = _G._CrystalHub_UI_MenuPos
        if G then
          T, y, C = Vector2.new, B(E, 0, G.x, 0, G.y)
          I = T(y, C)
          E.Position = UDim2.new(0, I.X, 0, I.Y)
        else
          E.Position = UDim2.new(1, -W - 20, 0.5, -_ / 2)
        end
        E.Visible = false
        h["Toggle UI"] = X
        _G.__CrystalPanelVisible = X
        if N then
          N.Visible = not X
        end
        if d then
          d.Visible = not X
        end
        ;(function()
          local G = i[48](152213189, 0)
          local W = G
          _G.__CrystalModernGuiActive = true
          local q = p:FindFirstChild("MainThemesPanel")
          if q then
            q:Destroy()
          end
          if m then
            m.Parent = p
          end
          q = P
          G = i[48](W, 186033340)
          if q then
            P.Parent = p
          end
          for _, _ in ipairs(E:GetChildren()) do
            if _ ~= U then
              _:Destroy()
            end
          end
          if U then
            U.Scale = 1
          end
          q = w
          if q then
            w:Destroy()
            w = nil
            _G.__toggleBtn = nil
          end
          q = N
          if q then
            pcall(function()
              N:Destroy()
            end)
            N, d = nil, nil
          end
          E.Name = "EclipseModernPanel"
          local w = {headerH = (M and 72) or 84, pageGap = (M and 4) or 6, sectionH = (M and 18) or 22, inputH = (M and 30) or 36}
          q, W = M and 30
          if q then
            W = q
          else
            G = i:rQ((i:HQ(1812481221, G) + i:HQ(1812481221, 25051082)) + (i:HQ(670004854, (i[79](G, 25051082))) + i:HQ(1812481222, (i[48](G, 25051082)))))
            G = i[48](G, 25051082)
            W = 38
          end
          w.toggleH = W
          w.toggleBindH = (M and 40) or 50
          w.actionH = (M and 34) or 42
          w.textSize = (M and 9) or 11
          w.categoryH = (M and 28) or 34
          q = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or u
          local u, U = (M and math.clamp(math.floor(q.X * 0.52), 205, 255)) or 310, (M and math.clamp(math.floor(q.Y * 0.82), 420, 560)) or 620
          G = i[48](G, 398440087)
          E.Size = UDim2.new(0, u, 0, U)
          q = _G._CrystalHub_UI_MenuPos
          if (q and (q.x ~= nil)) and (q.y ~= nil) then
            E.Position = UDim2.new(q.xs or 0, q.x, q.ys or 0, q.y)
          else
            E.Position = UDim2.new(1, -u - 12, 0.5, -U / 2)
          end
          E.BackgroundTransparency = 1
          E.BorderSizePixel = 0
          E.ClipsDescendants = false
          E.Visible = X
          local _ = {[1] = {bg = Color3.fromRGB(8, 4, 4), bgDark = Color3.fromRGB(0, 0, 0), row = Color3.fromRGB(18, 8, 9), accent = Color3.fromRGB(255, 79, 79), accentDim = Color3.fromRGB(108, 26, 34), activeRow = Color3.fromRGB(76, 18, 24), text = Color3.fromRGB(255, 255, 255), textDim = Color3.fromRGB(255, 196, 196), textMuted = Color3.fromRGB(188, 112, 112), divider = Color3.fromRGB(58, 22, 24)}}
          q, u = {bg = Color3.fromRGB(8, 4, 8), bgDark = Color3.fromRGB(0, 0, 0), row = Color3.fromRGB(18, 8, 18), accent = Color3.fromRGB(255, 120, 214), accentDim = Color3.fromRGB(121, 36, 98)}
          u, G = Color3.fromRGB, i[48](G, 146942332)
          q.activeRow = u(88, 24, 74)
          U = Color3
          G = i[48](G, 297567180)
          W = U.fromRGB(255, 255, 255)
          G = i[48](G, 388242854)
          q.text = W
          q.textDim = Color3.fromRGB(255, 205, 238)
          q.textMuted = Color3.fromRGB(192, 124, 166)
          q.divider = Color3.fromRGB(60, 22, 52)
          _[2] = q
          W, u = {bg = Color3.fromRGB(4, 7, 12)}
          u, G = Color3.fromRGB(0, 0, 0), i[48](G, 365286488)
          W.bgDark = u
          G = i[48](G, 314314295)
          W.row = Color3.fromRGB(8, 14, 22)
          W.accent = Color3.fromRGB(89, 176, 255)
          W.accentDim = Color3.fromRGB(28, 74, 118)
          W.activeRow = Color3.fromRGB(18, 54, 88)
          W.text = Color3.fromRGB(255, 255, 255)
          q = Color3.fromRGB
          G = i:rQ((i:HQ(4217742661, G) + i:HQ(4217742661, 421817091)) + (i:HQ(154449270, (i[79](421817091, G))) + i:HQ(4217742662, (i[48](G, 421817091)))))
          G = i[48](G, 516907511)
          W.textDim = q(198, 228, 255)
          W.textMuted = Color3.fromRGB(116, 154, 196)
          W.divider = Color3.fromRGB(24, 44, 66)
          _[3] = W
          local X = {bg = Color3.fromRGB(10, 5, 1), bgDark = Color3.fromRGB(0, 0, 0), row = Color3.fromRGB(26, 12, 3), accent = Color3.fromRGB(255, 126, 26), accentDim = Color3.fromRGB(132, 54, 8), activeRow = Color3.fromRGB(102, 39, 4), text = Color3.fromRGB(255, 246, 226), textDim = Color3.fromRGB(255, 191, 112), textMuted = Color3.fromRGB(196, 126, 62), divider = Color3.fromRGB(82, 35, 8)}
          local function V(N)
            return _[tonumber(N) or 1] or _[1]
          end
          q = V(G7)
          local _ = {bg = q.bg, bgDark = q.bgDark, row = q.row, accent = q.accent, accentDim = q.accentDim}
          G = i[48](G, 170696651)
          _.activeRow = q.activeRow
          _.text = q.text
          _.textDim = q.textDim
          _.textMuted = q.textMuted
          _.divider = q.divider
          local function N(d, t)
            local o7 = Instance.new("UICorner")
            o7.CornerRadius = UDim.new(0, t or 10)
            o7.Parent = d
            return o7
          end
          local function d(t, o7, O7)
            local F7 = Instance.new("UIStroke")
            F7.Color = o7 or _.divider
            F7.Thickness = O7 or 1
            F7.Parent = t
            return F7
          end
          W, U = setmetatable, {__mode = "k"}
          local t = W({}, U)
          local function o7(O7, F7, M7, h7, u7)
            if not O7 or not O7.Parent then
              return nil
            end
            local U7 = t[O7]
            if U7 then
              local p7 = i[48](54794222, 0)
              local n7 = p7
              local Q7
              Q7, p7 = pcall, i:rQ((i:HQ(945382629, n7) + i:HQ(945382629, 525069525)) + (i:HQ(2404202038, (i[79](n7, 525069525))) + i:HQ(945382630, (i[48](n7, 525069525)))))
              Q7(function()
                U7:Cancel()
              end)
            end
            local U7 = c:Create(O7, TweenInfo.new(M7 or 0.16, h7 or Enum.EasingStyle.Quart, u7 or Enum.EasingDirection.Out), F7)
            t[O7] = U7
            U7:Play()
            return U7
          end
          local function t(O7, F7)
            local M7 = i[48](147673024, 0)
            local h7 = M7
            local u7, U7, p7, n7 = false
            M7 = i:rQ(h7 + 248800875)
            O7.Active = true
            h7 = _G
            M7 = i:rQ(M7 + 141865319)
            h7.__CrystalGuiPositionResetters[F7.Name] = function()
              u7, U7, p7, n7 = false, nil, nil, nil
              F7.Position = UDim2.fromOffset(6, 54)
              if F7 == E then
                _G._CrystalHub_UI_MenuPos = nil
              else
                _G._CrystalHub_UI_ModernMiniPos = nil
              end
            end
            O7.InputBegan:Connect(function(M7)
              local h7 = (M7.UserInputType == Enum.UserInputType.MouseButton1) or (M7.UserInputType == Enum.UserInputType.Touch)
              if h7 then
                local h7 = i[48](347861495, 0)
                local Q7 = h7
                local j7 = u7
                if j7 then
                  return
                end
                U7, u7 = M7, true
                p7 = M7.Position
                h7 = i[48](Q7, 202438289)
                n7 = F7.Position
                h7 = i:rQ((i:HQ(27989950, h7) + i:HQ(27989950, 501658153)) + (i:HQ(4266977347, (i[79](h7, 501658153))) + i:HQ(4266977345, (i[89](h7, 501658153)))))
                M7.Changed:Connect(function()
                  local h7 = M7.UserInputState == Enum.UserInputState.End
                  if h7 then
                    u7 = false
                    if F7 == E then
                      _G._CrystalHub_UI_MenuPos = {x = F7.Position.X.Offset, y = F7.Position.Y.Offset, xs = F7.Position.X.Scale, ys = F7.Position.Y.Scale}
                      pcall(w7)
                    elseif F7.Name == "EclipseRestoreButton" then
                      _G._CrystalHub_UI_ModernMiniPos = {x = F7.Position.X.Offset, y = F7.Position.Y.Offset}
                      pcall(w7)
                    end
                  end
                end)
              end
            end)
            O7.InputChanged:Connect(function(O7)
              local M7 = (u7 and (U7.UserInputType ~= Enum.UserInputType.Touch)) and (O7.UserInputType == Enum.UserInputType.MouseMovement)
              if M7 then
                U7 = O7
              end
            end)
            _G.__CrystalTrackConn(D.InputChanged:Connect(function(O7)
              local M7 = u7 and (O7 == U7)
              if M7 then
                local M7 = O7.Position - p7
                B(F7, n7.X.Scale, n7.X.Offset + M7.X, n7.Y.Scale, n7.Y.Offset + M7.Y)
              end
            end))
          end
          local O7 = Instance.new("Frame")
          O7.Name = "Inner"
          G = i[48](G, 500406403)
          O7.Size = UDim2.new(1, 0, 1, 0)
          O7.BackgroundColor3 = _.bg
          O7.BorderSizePixel = 0
          O7.ClipsDescendants = true
          O7.Parent = E
          N(O7, 12)
          local F7 = d(O7, Color3.fromRGB(45, 45, 45), 0)
          local M7 = Instance.new("ImageLabel")
          M7.Name = "BackgroundImage"
          M7.Size = UDim2.new(1, -2, 1, -2)
          M7.Position = UDim2.fromOffset(1, 1)
          M7.BackgroundTransparency = 1
          local h7, u7, U7 = {["GUI 1"] = "rbxassetid://128167124865101"}, {["GUI 1"] = 1, ["GUI 2"] = 1}, "GUI 2"
          _G.__CrystalGuiTheme = U7
          local p7
          local function n7(Q7)
            local j7 = i[48](349159392, 0)
            local r7 = j7
            local J7
            J7, j7 = u7[Q7], i:rQ(r7 + 391992297)
            local u7, Q7 = J7 or 1
            Q7, j7 = pcall, i:rQ(j7 + 25720413)
            Q7(function()
              if _G.CrystalLagger and _G.CrystalLagger.SetBackground then
                _G.CrystalLagger.SetBackground(u7)
              end
            end)
          end
          local u7, Q7 = _G.__CrystalAddUnifiedPanelShade(O7, 12, 1), {"UnifiedPanelWhiteOutline", "UnifiedPanelWhiteGlow"}
          for j7, j7 in ipairs(Q7) do
            W = O7:FindFirstChild(j7)
            if W then
              W:Destroy()
            end
          end
          if u7 then
            u7.Position = UDim2.fromOffset(1, 1)
            u7.Size = UDim2.new(1, -2, 1, -2)
            W = u7:FindFirstChildOfClass("UICorner")
            if W then
              W.CornerRadius = UDim.new(0, 11)
            end
          end
          local function j7(r7)
            r7 = if not h7[r7] then "GUI 1" else r7
            U7 = r7
            _G.__CrystalGuiTheme = r7
            if _G.__CrystalApplyTheme then
              _G.__CrystalApplyTheme()
            end
            M7.Image = h7[r7]
            local h7 = O7:FindFirstChild("UnifiedBackgroundShade")
            if h7 then
              h7.Visible = r7 ~= "GUI 1"
            end
            F7.Transparency = 1
            n7(r7)
            if _G.__CrystalApplyAutoStealBarTheme then
              pcall(_G.__CrystalApplyAutoStealBarTheme, r7)
            end
            if _G.__CrystalRefreshESPTheme then
              pcall(_G.__CrystalRefreshESPTheme, _G.__CrystalThemeAccent, Color3.fromRGB(0, 0, 0))
            end
            if _G.__refreshSpeedBillboards then
              pcall(_G.__refreshSpeedBillboards)
            end
            if p7 then
              p7()
            end
          end
          j7(U7)
          M7.ImageTransparency = 0
          u = nil
          u, G = Enum.ScaleType, i[48](G, 431686617)
          M7.ScaleType = u.Crop
          M7.ZIndex = 0
          M7.Parent = O7
          M7.Visible = true
          N(M7, 11)
          q = Instance.new("Frame")
          q.Name = "HeaderFrame"
          G = i[48](G, 330324927)
          q.Size = UDim2.new(1, 0, 0, w.headerH)
          q.BackgroundTransparency = 1
          q.ZIndex = 10
          q.Parent = O7
          t(q, E)
          local h7 = Instance.new("Frame")
          h7.Name = "HeaderStats"
          h7.Position = UDim2.new(0, 14, 0, 8)
          h7.Size = UDim2.new(0, 78, 0, 40)
          h7.BackgroundColor3 = _.bgDark
          h7:SetAttribute("CurtThemeRole", "BgDark")
          h7.BackgroundTransparency = 0.35
          h7.BorderSizePixel = 0
          h7.ZIndex = 12
          h7.Parent = q
          h7.Visible = false
          N(h7, 8)
          d(h7, Color3.fromRGB(45, 45, 45), 1)
          if m then
            m.Parent = h7
            m.Position = UDim2.new(0, 7, 0, 3)
            j7 = nil
            j7, G = UDim2.new, i[48](G, 168581925)
            m.Size = j7(1, -14, 0, 16)
            m.BackgroundTransparency = 1
            m.TextColor3 = _.text
            m.TextSize = 9
            m.Font = Enum.Font.GothamBold
            m.TextXAlignment = Enum.TextXAlignment.Left
            m.TextTransparency = 0
            m.Visible = false
            m.ZIndex = 13
            G = i[48](G, 168581925)
          else
          end
          if P then
            G, P.Parent = i[48](G, 198643637), h7
            P.Position = UDim2.new(0, 7, 0, 20)
            P.Size = UDim2.new(1, -14, 0, 16)
            P.BackgroundTransparency = 1
            P.TextColor3 = _.textDim
            P.TextSize = 9
            P.Font = Enum.Font.GothamBold
            P.TextXAlignment = Enum.TextXAlignment.Left
            P.TextTransparency = 0
            P.Visible = false
            P.ZIndex = 13
            G = i[48](G, 198643637)
          else
          end
          U = Instance.new("TextLabel")
          U.Position = UDim2.new(0, 98, 0, 8)
          U.Size = UDim2.new(1, -146, 0, 22)
          U.BackgroundTransparency = 1
          U.Text = "vless hub"
          U.TextColor3 = _.text
          U.TextSize = 17
          U.Font = Enum.Font.GothamBlack
          U.TextXAlignment = Enum.TextXAlignment.Center
          U.ZIndex = 11
          U.Parent = q
          u = Instance.new("TextLabel")
          u.Position = UDim2.new(0, 98, 0, 32)
          u.Size = UDim2.new(1, -146, 0, 14)
          u.BackgroundTransparency = 1
          u.Text = ""
          u.TextColor3 = _.textDim
          u.TextSize = 10
          u.Font = Enum.Font.GothamBold
          u.TextXAlignment = Enum.TextXAlignment.Center
          u.ZIndex = 11
          u.Parent = q
          G = i[48](G, 531527062)
          u.Visible = false
          local n7 = Instance.new("ImageLabel")
          n7.Name = "CurtWordMark"
          n7.AnchorPoint = Vector2.new(0.5, 0)
          n7.Position = UDim2.new(0.5, 0, 0, (M and 10) or 12)
          W, j7 = UDim2.fromOffset
          if M then
            G = i:rQ((i:HQ(550166646, G) + i:HQ(550166646, 244017694)) + (i:HQ(3744800651, (i[79](G, 244017694))) + i:HQ(3744800649, (i[89](244017694, G)))))
            G = i[48](G, 244017694)
            j7 = 170
          else
            j7 = M
          end
          n7.Size = W(j7 or 210, (M and 46) or 54)
          n7.BackgroundTransparency = 1
          n7.Image = "rbxassetid://80570867410850"
          n7.ScaleType = Enum.ScaleType.Fit
          n7.ImageColor3 = _.accent
          n7.ZIndex = 13
          n7.Parent = q
          local r7 = Instance.new("ImageLabel")
          r7.Name = "CurtWordGlow"
          r7.AnchorPoint = Vector2.new(0.5, 0)
          r7.Position = n7.Position
          Q7, j7 = UDim2.fromOffset, M and 186
          local J7, q7, _7 = j7 or 228, M and 52
          _7, G = Q7(J7, q7 or 60), i[48](G, 210920401)
          r7.Size = _7
          r7.BackgroundTransparency = 1
          r7.Image = "rbxassetid://80570867410850"
          r7.ImageTransparency = 0.74
          r7.ScaleType = Enum.ScaleType.Fit
          r7.ZIndex = 12
          r7.Parent = q
          local z7 = Instance.new("TextButton")
          z7.Size = UDim2.new(0, 28, 0, 28)
          z7.Position = UDim2.new(1, -38, 0, 8)
          z7.BackgroundColor3 = _.bgDark
          z7:SetAttribute("CurtThemeRole", "BgDark")
          z7.BorderSizePixel = 0
          z7.Text = "-"
          z7.TextColor3 = _.textMuted
          z7.Font = Enum.Font.GothamBlack
          z7.TextSize = 22
          z7.ZIndex = 12
          z7.Parent = q
          N(z7, 6)
          d(z7, Color3.fromRGB(45, 45, 45), 1)
          local K7 = Instance.new("Frame")
          K7.Position = UDim2.new(0, 14, 0, w.headerH)
          q7 = nil
          q7, G = UDim2.new, i[48](G, 256054280)
          K7.Size = q7(1, -28, 0, 1)
          K7.BackgroundColor3 = _.accent
          K7:SetAttribute("CurtThemeRole", "Accent")
          K7.BackgroundTransparency = 0.7
          K7.BorderSizePixel = 0
          K7.ZIndex = 9
          K7.Parent = O7
          j7 = Instance.new("Frame")
          j7.Name = "LeftPanel"
          q = nil
          q, G = UDim2, i[48](G, 243331475)
          j7.Size = q.new(0, 85, 1, -78)
          Q7 = nil
          Q7, G = UDim2.new, i[48](G, 302940653)
          j7.Position = Q7(1, -85, 0, 68)
          j7.BackgroundColor3 = _.bgDark
          j7:SetAttribute("CurtThemeRole", "BgDark")
          j7.BackgroundTransparency = 0.5
          j7.BorderSizePixel = 0
          j7.ZIndex = 5
          j7.Parent = O7
          G = i:rQ((i:HQ(601810730, G) + i:HQ(601810730, 449372847)) + (i:HQ(3091345836, (i[79](G, 449372847))) + i:HQ(601810731, (i[48](G, 449372847)))))
          N(j7, 12)
          j7.Visible = false
          U.Text = ""
          G = i[48](G, 504250616)
          U.Visible = false
          local k7 = (M and 34) or 40
          local e7 = Instance.new("Frame")
          e7.Name = "BottomTabs"
          e7.Size = UDim2.new(1, -12, 0, k7)
          G = i[48](G, 516197826)
          e7.Position = UDim2.new(0, 6, 1, -(k7 + 6))
          e7.BackgroundColor3 = _.bgDark
          e7:SetAttribute("CurtThemeRole", "BgDark")
          e7.BackgroundTransparency = 0.3
          e7.BorderSizePixel = 0
          e7.ZIndex = 10
          e7.Parent = O7
          N(e7, 8)
          local X7 = d(e7, _.divider, 1)
          local C7 = Instance.new("Frame")
          C7.Size = UDim2.new(1, -12, 1, -8)
          C7.Position = UDim2.new(0, 6, 0, 4)
          C7.BackgroundTransparency = 1
          C7.ZIndex = 12
          C7.Parent = e7
          local a7 = Instance.new("UIListLayout", C7)
          a7.SortOrder = Enum.SortOrder.LayoutOrder
          a7.FillDirection = Enum.FillDirection.Horizontal
          a7.HorizontalAlignment = Enum.HorizontalAlignment.Center
          a7.VerticalAlignment = Enum.VerticalAlignment.Center
          a7.Padding = UDim.new(0, (M and 2) or 4)
          q = Instance.new("UIPadding", C7)
          q.PaddingLeft = UDim.new(0, 0)
          j7 = nil
          j7, G = UDim, i[48](G, 120247966)
          q.PaddingRight = j7.new(0, 0)
          q.PaddingTop = UDim.new(0, 0)
          local A7 = Instance.new("Frame")
          A7.Name = "ContentFrame"
          A7.Size = UDim2.new(1, -12, 1, -((w.headerH + k7) + 20))
          q7 = nil
          q7, G = UDim2, i[48](G, 489935091)
          A7.Position = q7.new(0, 6, 0, w.headerH + 8)
          A7.BackgroundTransparency = 1
          A7.ClipsDescendants = true
          A7.ZIndex = 4
          A7.Parent = O7
          local function g7(R7)
            R7 = ((R7 == "Left") and "Left") or "Down"
            _G.__CrystalTabPosition = R7
            local S7 = R7 == "Left"
            if S7 then
              e7.Size = UDim2.new(0, (M and 90) or 106, 1, -(w.headerH + 14))
              e7.Position = UDim2.new(0, 6, 0, w.headerH + 8)
              e7.BackgroundTransparency = 0.82
              X7.Transparency = 0.82
              C7.Size = UDim2.new(1, -8, 1, -8)
              C7.Position = UDim2.new(0, 4, 0, -8)
              a7.FillDirection = Enum.FillDirection.Vertical
              a7.HorizontalAlignment = Enum.HorizontalAlignment.Center
              a7.VerticalAlignment = Enum.VerticalAlignment.Center
              a7.Padding = UDim.new(0, (M and 3) or 4)
              A7.Size = UDim2.new(1, -((M and 108) or 124), 1, -(w.headerH + 14))
              A7.Position = UDim2.new(0, (M and 102) or 118, 0, w.headerH + 8)
            else
              e7.Size = UDim2.new(1, -12, 0, k7)
              e7.Position = UDim2.new(0, 6, 1, -(k7 + 6))
              e7.BackgroundTransparency = 0.3
              X7.Transparency = 0
              C7.Size = UDim2.new(1, -12, 1, -8)
              C7.Position = UDim2.new(0, 6, 0, 4)
              a7.FillDirection = Enum.FillDirection.Horizontal
              a7.HorizontalAlignment = Enum.HorizontalAlignment.Center
              a7.VerticalAlignment = Enum.VerticalAlignment.Center
              a7.Padding = UDim.new(0, (M and 2) or 4)
              A7.Size = UDim2.new(1, -12, 1, -((w.headerH + k7) + 20))
              A7.Position = UDim2.new(0, 6, 0, w.headerH + 8)
            end
            for k7, k7 in ipairs(C7:GetChildren()) do
              if k7:IsA("TextButton") then
                k7.Size = (S7 and UDim2.new(1, -4, 0, (M and 34) or 38)) or UDim2.new(0.25, (M and -2) or -4, 0, w.categoryH)
                k7.TextWrapped = S7
              end
            end
            pcall(w7)
            return R7
          end
          _G.__CrystalSetTabPosition = g7
          local function k7(X7)
            X7:SetAttribute("EclipseKeepBlackText", true)
            X7.TextStrokeTransparency = 1
            return X7
          end
          for X7, X7 in ipairs(O7:GetDescendants()) do
            if (X7:IsA("TextLabel") or X7:IsA("TextButton")) or X7:IsA("TextBox") then
              k7(X7)
            end
          end
          U.TextColor3 = _.text
          u.TextColor3 = _.textDim
          z7.TextColor3 = _.textMuted
          local X7 = {}
          local function a7(R7)
            local S7 = Instance.new("ScrollingFrame")
            S7.Name = R7 .. "Page"
            S7.Size = UDim2.new(1, 0, 1, 0)
            S7.BackgroundTransparency = 1
            S7.BorderSizePixel = 0
            S7.ScrollBarThickness = 2
            S7.ScrollBarImageColor3 = _.accent
            S7.ScrollBarImageTransparency = 0.28
            S7.ElasticBehavior = Enum.ElasticBehavior.Always
            S7.ScrollingDirection = Enum.ScrollingDirection.Y
            S7.AutomaticCanvasSize = Enum.AutomaticSize.Y
            S7.CanvasSize = UDim2.new(0, 0, 0, 0)
            S7.Visible = R7 == "Movement"
            S7.ZIndex = 5
            S7.Parent = A7
            local A7 = Instance.new("UIScale")
            A7.Name = "PageTransitionScale"
            A7.Scale = 1
            A7.Parent = S7
            X7[R7] = A7
            A7 = Instance.new("UIListLayout", S7)
            A7.SortOrder = Enum.SortOrder.LayoutOrder
            A7.Padding = UDim.new(0, w.pageGap)
            A7 = Instance.new("UIPadding", S7)
            A7.PaddingLeft = UDim.new(0, 4)
            A7.PaddingRight = UDim.new(0, 4)
            A7.PaddingTop = UDim.new(0, (M and 4) or 6)
            A7.PaddingBottom = UDim.new(0, (M and 4) or 6)
            return S7
          end
          local A7 = {Movement = a7("Movement"), Combat = a7("Combat"), Visual = a7("Visual"), Animations = a7("Animations")}
          local function R7(S7, Z7)
            if (h[S7] == true) == Z7 then
              return
            end
            local f7 = FeatureToggles[S7]
            if f7 then
              pcall(f7)
            end
            if h[S7] ~= Z7 then
              h[S7] = Z7
              f7 = l[S7]
              if f7 then
                pcall(f7, Z7)
              end
            end
            Z7 = Y[S7]
            if Z7 then
              pcall(Z7)
            end
            pcall(w7)
          end
          local function S7(Z7, f7)
            local Y7 = R
            if Y7 then
              R.Text = "-"
            end
            R, S = Z7, f7
            Z7.Text = "..."
          end
          local function Z7(f7, Y7, V7)
            local v7 = Instance.new("Frame")
            v7.Size = UDim2.new(1, 0, 0, w.sectionH)
            v7.BackgroundTransparency = 1
            v7.LayoutOrder = V7
            v7.Parent = f7
            V7 = k7(Instance.new("TextLabel"))
            V7.Size = UDim2.new(1, 0, 0, (M and 14) or 16)
            V7.BackgroundTransparency = 1
            V7.Text = Y7
            V7.TextColor3 = _.textDim
            V7.TextSize = (M and 8) or 10
            V7.Font = Enum.Font.GothamBold
            V7.TextXAlignment = Enum.TextXAlignment.Left
            V7.Parent = v7
          end
          local function f7(Y7, V7, v7)
            local l7 = i[48](242406447, 0)
            local m7 = l7
            local P7 = k7(Instance.new("TextButton"))
            P7.Name = "ModeKeybind"
            P7.Size = UDim2.fromOffset((M and 38) or 44, (M and 16) or 20)
            P7.Position = v7
            P7.BackgroundColor3 = _.accentDim
            P7:SetAttribute("CurtThemeRole", "AccentDim")
            P7.BackgroundTransparency = 0.25
            P7.BorderSizePixel = 0
            v7 = nil
            v7, l7 = _.text, i:rQ((i:HQ(2147483649, 4294967295) + i:HQ(2147483648, m7)) + (i:HQ(2147483648, 443409023) + i:HQ(2147483647, (i[100]((i[48](m7, 443409023)))))))
            P7.TextColor3 = v7
            P7.TextSize = (M and 8) or 9
            P7.Font = Enum.Font.GothamBold
            P7.Text = (g[V7] and D7(g[V7])) or "-"
            P7.ZIndex = 8
            P7.Parent = Y7
            N(P7, 5)
            Y7 = nil
            Y7, l7 = Color3.fromRGB, i[48](l7, 49544013)
            d(P7, Y7(55, 55, 60), 1)
            local function Y7()
              S7(P7, V7)
            end
            P7.MouseButton1Click:Connect(Y7)
            table.insert(Z, P7)
            local Y7 = Y[V7]
            Y[V7] = function()
              if Y7 then
                pcall(Y7)
              end
              local Y7 = g[V7]
              P7.Text = (Y7 and D7(Y7)) or "-"
              P7.BackgroundColor3 = _.accentDim
              P7:SetAttribute("CurtThemeRole", "AccentDim")
              P7.BackgroundTransparency = 0.25
              P7.TextColor3 = _.text
            end
            return P7
          end
          local function Y7(V7, v7, l7, m7, P7, x7)
            local H7 = i[48](194794906, 0)
            local E7 = H7
            local N7 = Instance.new("Frame")
            N7.Size = UDim2.new(1, 0, 0, w.inputH)
            N7.BackgroundColor3 = _.row
            N7:SetAttribute("CurtThemeRole", "Row")
            N7.BackgroundTransparency = 0.5
            N7.BorderSizePixel = 0
            N7.LayoutOrder = m7
            N7.Parent = V7
            N(N7, 8)
            d(N7, _.divider, 1)
            m7 = k7(Instance.new("TextLabel"))
            m7.Size = (x7 and UDim2.new(1, (M and -116) or -142, 1, 0)) or UDim2.new(0.65, 0, 1, 0)
            m7.Position = UDim2.new(0, (M and 8) or 12, 0, 0)
            m7.BackgroundTransparency = 1
            m7.Text = v7
            m7.TextColor3 = _.text
            m7.TextSize = w.textSize
            m7.Font = Enum.Font.GothamBold
            m7.TextXAlignment = Enum.TextXAlignment.Left
            m7.Parent = N7
            if x7 then
              f7(N7, x7, UDim2.new(1, (M and -94) or -116, 0.5, (M and -8) or -10))
            end
            x7 = Instance.new("Frame")
            x7.Size = UDim2.new(0, (M and 44) or 54, 0, (M and 18) or 22)
            x7.Position = UDim2.new(1, (M and -51) or -64, 0.5, (M and -9) or -11)
            x7.BackgroundColor3 = _.row
            x7:SetAttribute("CurtThemeRole", "Row")
            x7.BackgroundTransparency = 0.15
            x7.BorderSizePixel = 0
            x7.Parent = N7
            N(x7, 6)
            d(x7, Color3.fromRGB(55, 55, 60), 1)
            local V7
            H7, V7 = i:rQ((i:HQ(64882848, E7) + i:HQ(64882848, 260632301)) + (i:HQ(4165201600, (i[79](260632301, E7))) + i:HQ(64882849, (i[48](E7, 260632301))))), k7(Instance.new("TextBox"))
            V7.Size = UDim2.new(1, 0, 1, 0)
            V7.BackgroundTransparency = 1
            m7 = nil
            m7, H7 = tostring, i[48](H7, 249407403)
            V7.Text = m7(l7)
            V7.TextColor3 = _.text
            V7.TextSize = (M and 9) or 11
            V7.Font = Enum.Font.GothamBold
            V7.ClearTextOnFocus = false
            V7.Parent = x7
            local function v7()
              local m7 = tonumber(V7.Text)
              if m7 then
                P7(m7)
                V7.Text = tostring(m7)
              else
                V7.Text = tostring(l7)
              end
            end
            V7.FocusLost:Connect(v7)
          end
          local function V7(v7, l7, m7)
            local P7 = i[48](194631104, 0)
            local x7 = P7
            local H7 = Instance.new("Frame")
            H7.Name = "CustomSpeed_" .. l7.name
            H7.Size = UDim2.new(1, 0, 0, 58)
            H7.BackgroundColor3 = _.row
            H7:SetAttribute("CurtThemeRole", "Row")
            H7.BackgroundTransparency = 0.5
            H7.BorderSizePixel = 0
            H7.LayoutOrder = m7
            H7.Parent = v7
            N(H7, 8)
            d(H7, _.divider, 1)
            local m7 = Instance.new("Frame")
            m7.Size = UDim2.new(0, 3, 0, 36)
            m7.Position = UDim2.new(0, 4, 0.5, -18)
            m7.BackgroundColor3 = _.accent
            m7:SetAttribute("CurtThemeRole", "Accent")
            m7.BorderSizePixel = 0
            m7.Parent = H7
            N(m7, 2)
            v7 = k7(Instance.new("TextButton"))
            v7.Size = UDim2.new(0, 88, 1, 0)
            v7.Position = UDim2.new(0, 12, 0, 0)
            v7.BackgroundTransparency = 1
            v7.Text = l7.name
            v7.TextColor3 = _.text
            v7.TextSize = 11
            v7.Font = Enum.Font.GothamBold
            v7.TextXAlignment = Enum.TextXAlignment.Left
            v7.Parent = H7
            local E7, N7 = "SelectCustomMode_" .. l7.name
            N7, P7 = UDim2, i:rQ((i:HQ(18313820, x7) + i:HQ(18313820, 161690523)) + (i:HQ(4258339656, (i[79](x7, 161690523))) + i:HQ(18313821, (i[48](x7, 161690523)))))
            f7(H7, E7, N7.fromOffset(106, 19))
            local function f7(P7, N7, d7, B7)
              local L7 = i[48](446958519, 0)
              local t7 = L7
              local i0, I0 = Instance, i:rQ(d7)
              local D0
              L7, D0 = i:rQ((i:HQ(971579924, 4294967295) + t7) + (i:HQ(2960073265, I0) + i:HQ(2960073265, (i[100](I0))))), k7(i0.new("TextLabel"))
              D0.Size = UDim2.fromOffset(54, 14)
              D0.Position = UDim2.fromOffset(d7, 5)
              D0.BackgroundTransparency = 1
              D0.Text = P7
              D0.TextColor3 = _.textMuted
              D0.TextSize = 8
              D0.Font = Enum.Font.GothamBold
              D0.TextXAlignment = Enum.TextXAlignment.Left
              D0.Parent = H7
              local P7 = k7(Instance.new("TextBox"))
              P7.Size = UDim2.fromOffset(54, 22)
              P7.Position = UDim2.fromOffset(d7, 24)
              P7.BackgroundColor3 = _.bgDark
              P7:SetAttribute("CurtThemeRole", "BgDark")
              P7.BorderSizePixel = 0
              P7.Text = tostring(N7)
              P7.TextColor3 = _.text
              P7.TextSize = 10
              P7.Font = Enum.Font.GothamBold
              P7.ClearTextOnFocus = false
              P7.Parent = H7
              N(P7, 5)
              t7 = nil
              t7, L7 = Color3.fromRGB(55, 55, 60), i:rQ(L7 + 15171611)
              d(P7, t7, 1)
              P7.FocusLost:Connect(function()
                local d7 = tonumber(P7.Text)
                local L7 = not d7
                if L7 then
                  P7.Text = tostring(N7)
                  return
                end
                d7 = math.clamp(math.floor(d7 + 0.5), 1, 200)
                N7 = d7
                P7.Text = tostring(d7)
                B7(d7)
              end)
              return P7
            end
            f7("NORMAL", l7.boost, 158, function(P7)
              local N7 = i[48](398496490, 0)
              local d7 = N7
              l7.boost = P7
              N7 = i:rQ(d7 + 415877432)
              d7 = l7.name
              N7 = i:rQ(N7 - 334284595)
              n["CustomBoost_" .. d7] = P7
              w7()
              pcall(function()
                if _G.__refreshSpeedBillboards then
                  _G.__refreshSpeedBillboards()
                end
              end)
            end)
            f7("CARRY", l7.steal, 224, function(f7)
              local P7 = i[48](222019773, 0)
              local N7 = P7
              l7.steal = f7
              P7 = i:rQ((i:HQ(1336038854, N7) + i:HQ(1336038854, 297554554)) + (i:HQ(2958928443, (i[79](N7, 297554554))) + i:HQ(2958928441, (i[89](N7, 297554554)))))
              P7 = i[48](P7, 148432007)
              n["CustomSteal_" .. l7.name] = f7
              w7()
              pcall(function()
                if _G.__refreshSpeedBillboards then
                  _G.__refreshSpeedBillboards()
                end
              end)
            end)
            x7 = k7(Instance.new("TextButton"))
            x7.Size = UDim2.fromOffset(30, 24)
            x7.Position = UDim2.new(1, -40, 0.5, -12)
            x7.BackgroundColor3 = Color3.fromRGB(72, 34, 34)
            x7.BorderSizePixel = 0
            x7.Text = "X"
            x7.TextColor3 = Color3.fromRGB(255, 180, 180)
            x7.TextSize = 10
            x7.Font = Enum.Font.GothamBold
            x7.Parent = H7
            N(x7, 5)
            local function f7()
              local P7 = J
              local N7 = P7 == l7.name
              H7.BackgroundTransparency = (N7 and 0.28) or 0.5
              m7.Visible = N7
            end
            local function m7()
              W7(l7.name)
            end
            v7.MouseButton1Click:Connect(m7)
            x7.MouseButton1Click:Connect(function()
              for v7 = #Q, 1, -1 do
                if Q[v7] == l7 then
                  table.remove(Q, v7)
                  break
                end
              end
              n["CustomBoost_" .. l7.name] = nil
              n["CustomSteal_" .. l7.name] = nil
              g[E7] = nil
              FeatureToggles[E7] = nil
              local v7 = J
              if v7 == l7.name then
                W7("Normal")
              end
              H7:Destroy()
              w7()
            end)
            x7 = FeatureToggles
            local function v7()
              W7(l7.name)
            end
            x7[E7] = v7
            table.insert(_speedCardRefs, {modeName = l7.name, updateVisual = f7})
            f7()
            return H7
          end
          local f7
          G = i[48](G, 316354844)
          f7 = function(v7, l7, m7)
            local P7 = i[48](437577877, 0)
            local x7 = P7
            local H7
            H7, P7 = Instance.new, i:rQ((i:HQ(179823037, x7) + i:HQ(179823037, 242450697)) + (i:HQ(3935321222, (i[79](x7, 242450697))) + i:HQ(179823038, (i[48](x7, 242450697)))))
            local E7 = H7("Frame")
            E7.Name = "CustomSpeedForm"
            x7 = nil
            x7, P7 = UDim2, i[48](P7, 11158970)
            E7.Size = x7.new(1, 0, 0, 112)
            E7.BackgroundColor3 = _.row
            E7:SetAttribute("CurtThemeRole", "Row")
            E7.BackgroundTransparency = 0.2
            E7.BorderSizePixel = 0
            E7.LayoutOrder = l7
            E7.Parent = v7
            N(E7, 8)
            d(E7, _.divider, 1)
            local function l7(P7, x7, H7)
              local N7 = k7(Instance.new("TextLabel"))
              N7.Size = UDim2.fromOffset(H7, 14)
              N7.Position = UDim2.fromOffset(x7, 8)
              N7.BackgroundTransparency = 1
              N7.Text = P7
              N7.TextColor3 = _.textMuted
              N7.TextSize = 8
              N7.Font = Enum.Font.GothamBold
              N7.TextXAlignment = Enum.TextXAlignment.Left
              N7.Parent = E7
            end
            local function P7(x7, H7, N7)
              local d7 = k7(Instance.new("TextBox"))
              d7.Size = UDim2.fromOffset(N7, 24)
              d7.Position = UDim2.fromOffset(H7, 24)
              d7.BackgroundColor3 = _.bgDark
              d7:SetAttribute("CurtThemeRole", "BgDark")
              d7.BorderSizePixel = 0
              d7.Text = x7
              d7.TextColor3 = _.text
              d7.TextSize = 10
              d7.Font = Enum.Font.GothamBold
              d7.ClearTextOnFocus = false
              d7.Parent = E7
              N(d7, 5)
              d(d7, Color3.fromRGB(55, 55, 60), 1)
              return d7
            end
            l7("NAME", 12, 150)
            l7("NORMAL", 174, 70)
            l7("CARRY", 256, 70)
            local l7 = P7("Custom " .. tostring(#Q + 1), 12, 150)
            local x7 = P7("59", 174, 70)
            local H7 = P7("29", 256, 70)
            local P7 = k7(Instance.new("TextLabel"))
            P7.Size = UDim2.new(1, -24, 0, 14)
            P7.Position = UDim2.new(0, 12, 1, -20)
            P7.BackgroundTransparency = 1
            P7.Text = ""
            P7.TextColor3 = Color3.fromRGB(255, 150, 150)
            P7.TextSize = 8
            P7.Font = Enum.Font.GothamBold
            P7.TextXAlignment = Enum.TextXAlignment.Left
            P7.Parent = E7
            v7 = k7(Instance.new("TextButton"))
            v7.Size = UDim2.new(1, -24, 0, 26)
            v7.Position = UDim2.new(0, 12, 0, 62)
            v7.BackgroundColor3 = _.accentDim
            v7:SetAttribute("CurtThemeRole", "AccentDim")
            v7.BorderSizePixel = 0
            v7.Text = "CREATE CUSTOM SPEED"
            v7.TextColor3 = _.text
            v7.TextSize = 10
            v7.Font = Enum.Font.GothamBold
            v7.Parent = E7
            N(v7, 6)
            local function N7()
              local d7, B7, L7 = l7.Text:match("^%s*(.-)%s*$"), tonumber(x7.Text), tonumber(H7.Text)
              if not d7 or (#d7 < 1) then
                P7.Text = "Escribe un nombre."
                return
              end
              if d7:find("[:,=]") then
                P7.Text = "El nombre no puede contener : , o =."
                return
              end
              if ((d7 == "Normal") or (d7 == "Lagger")) or (d7 == "Desync") then
                P7.Text = "Ese nombre est\195\161 reservado."
                return
              end
              for l7, l7 in ipairs(Q) do
                if l7.name == d7 then
                  P7.Text = "Ese nombre ya existe."
                  return
                end
              end
              if (not B7 or (B7 < 1)) or (B7 > 200) then
                P7.Text = "Normal: elige un valor entre 1 y 200."
                return
              end
              if (not L7 or (L7 < 1)) or (L7 > 200) then
                P7.Text = "Carry: elige un valor entre 1 y 200."
                return
              end
              local l7 = {name = d7, boost = math.floor(B7 + 0.5), steal = math.floor(L7 + 0.5)}
              table.insert(Q, l7)
              n["CustomBoost_" .. d7] = l7.boost
              n["CustomSteal_" .. d7] = l7.steal
              w7()
              E7:Destroy()
              m7(l7)
            end
            v7.MouseButton1Click:Connect(N7)
            return E7
          end
          local function v7(l7, m7, P7, x7, H7, E7, N7, d7)
            local B7 = i[48](320353926, 0)
            local L7 = Instance.new("Frame")
            L7:SetAttribute("CrystalButtonThemeControl", true)
            L7.Size = UDim2.new(1, 0, 0, (E7 and w.toggleBindH) or w.toggleH)
            L7.BackgroundColor3 = _.row
            L7:SetAttribute("CurtThemeRole", "Row")
            L7.BackgroundTransparency = 0.5
            L7.BorderSizePixel = 0
            L7.LayoutOrder = H7
            L7.Parent = l7
            N(L7, 8)
            d(L7, _.divider, 1)
            local t7 = Instance.new("UIScale", L7)
            t7.Scale = 1
            local i0, I0, D0 = k7(Instance.new("TextLabel")), UDim2.new, E7 and ((M and 16) or 20)
            i0.Size = I0(1, -70, 0, D0 or w.toggleH)
            H7, I0 = UDim2.new, M and 8
            l7, D0 = I0 or 12, E7 and ((M and 2) or 3)
            i0.Position = H7(0, l7, 0, D0 or 0)
            i0.BackgroundTransparency = 1
            i0.Text = m7
            i0.TextColor3 = _.text
            i0.TextSize = w.textSize
            i0.Font = Enum.Font.GothamBold
            i0.TextXAlignment = Enum.TextXAlignment.Left
            i0.Parent = L7
            local l7 = Instance.new("Frame")
            l7.Name = "ActiveMarker"
            l7.Size = UDim2.new(0, 3, 0, (M and 18) or 24)
            l7.Position = UDim2.new(0, 4, 0.5, (M and -9) or -12)
            l7.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            l7.BorderSizePixel = 0
            l7.Visible = false
            l7.Parent = L7
            N(l7, 2)
            local m7 = Instance.new("Frame")
            B7 = i[48](B7, 76264135)
            m7.Name = "ToggleSwitch"
            m7.Size = UDim2.new(0, (M and 34) or 40, 0, (M and 16) or 20)
            m7.Position = UDim2.new(1, (M and -42) or -50, 0.5, (M and -8) or -10)
            m7.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
            m7:SetAttribute("CurtThemeRole", "BgDark")
            m7.BorderSizePixel = 0
            m7.ZIndex = 8
            m7.Parent = L7
            N(m7, 20)
            d(m7, _.divider, 1)
            local B7 = Instance.new("Frame")
            B7.Name = "Knob"
            B7.Size = UDim2.new(0, (M and 12) or 16, 0, (M and 12) or 16)
            B7.Position = UDim2.new(0, 2, 0.5, (M and -6) or -8)
            B7.BackgroundColor3 = Color3.fromRGB(210, 210, 215)
            B7:SetAttribute("CurtThemeRole", "SwitchKnob")
            B7.BorderSizePixel = 0
            B7.ZIndex = 9
            B7.Parent = m7
            N(B7, 20)
            local i0 = d7 or P7
            if E7 and i0 then
              local d7 = k7(Instance.new("TextButton"))
              d7.Size = UDim2.new(0, (M and 36) or 42, 0, (M and 14) or 17)
              d7.Position = UDim2.new(0, (M and 8) or 12, 1, (M and -17) or -21)
              d7.BackgroundColor3 = _.accentDim
              d7:SetAttribute("CurtThemeRole", "AccentDim")
              d7.BackgroundTransparency = 0.35
              d7.BorderSizePixel = 0
              D0 = g[i0]
              d7.Text = (D0 and D7(D0)) or "-"
              d7.TextColor3 = _.text
              d7.TextSize = (M and 8) or 9
              d7.Font = Enum.Font.GothamBold
              d7.Parent = L7
              N(d7, 5)
              local function I0()
                S7(d7, i0)
              end
              d7.MouseButton1Click:Connect(I0)
              table.insert(Z, d7)
            end
            local d7, i0 = x7 == true, false
            local function x7(I0)
              d7 = I0 == true
              I0 = _.row
              l7.Visible = false
              local l7 = (d7 and _.accent) or Color3.fromRGB(42, 42, 48)
              m7:SetAttribute("SwitchActive", d7)
              m7:SetAttribute("CurtThemeRole", (d7 and "Accent") or "BgDark")
              local c0, s0 = (d7 and UDim2.new(1, (M and -14) or -18, 0.5, (M and -6) or -8)) or UDim2.new(0, 2, 0.5, (M and -6) or -8), i0
              if s0 then
                o7(L7, {BackgroundColor3 = I0, BackgroundTransparency = 0.5}, 0.18)
                o7(m7, {BackgroundColor3 = l7}, 0.18)
                o7(B7, {Position = c0}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
              else
                L7.BackgroundColor3 = I0
                L7.BackgroundTransparency = 0.5
                m7.BackgroundColor3 = l7
                B7.Position = c0
                i0 = true
              end
            end
            x7(d7)
            H7 = Instance.new("TextButton")
            k7(H7)
            H7.Size = UDim2.new(1, 0, 1, 0)
            H7.Position = UDim2.new(0, 0, 0, 0)
            H7.BackgroundTransparency = 1
            H7.Text = ""
            H7.ZIndex = 0
            H7.Parent = L7
            D0 = H7.MouseButton1Click
            local function l7()
              t7.Scale = 0.985
              o7(t7, {Scale = 1}, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
              local m7 = not d7
              N7(m7)
              x7((P7 and (h[P7] == true)) or m7)
            end
            D0:Connect(l7)
            if P7 then
              local l7 = i[48](480248398, 0)
              E7 = l7
              l7 = i:rQ((i:HQ(3656099062, E7) + i:HQ(3656099062, 531436165)) + (i:HQ(1277736468, (i[79](E7, 531436165))) + i:HQ(3656099063, (i[48](E7, 531436165)))))
              local function l7()
                x7(h[P7] == true)
              end
              Y[P7] = l7
            end
            return x7, L7
          end
          local function l7(m7, P7, x7)
            local H7 = i[48](64543658, 0)
            local E7 = H7
            local N7 = k7(Instance.new("TextButton"))
            local d7 = m7:FindFirstChild("ToggleSwitch") ~= nil
            N7.Size = UDim2.new(0, (M and 42) or 52, 0, (M and 16) or 20)
            N7.Position = (d7 and UDim2.new(1, (M and -92) or -112, 0.5, (M and -8) or -10)) or UDim2.new(1, (M and -54) or -68, 0.5, (M and -8) or -10)
            N7.BackgroundColor3 = _.accentDim
            N7:SetAttribute("CurtThemeRole", "AccentDim")
            N7.BackgroundTransparency = 0.25
            N7.BorderSizePixel = 0
            N7.Text = P7
            N7.TextColor3 = _.text
            P7 = (M and 8) or 9
            N7.TextSize = P7
            N7.Font = Enum.Font.GothamBold
            N7.ZIndex = 8
            H7 = i:rQ(E7 + 447740357)
            N7.Parent = m7
            N(N7, 5)
            d(N7, Color3.fromRGB(45, 45, 45), 1)
            d7, m7 = Instance.new, i:rQ(P7)
            local P7
            H7, P7 = i:rQ((i:HQ(418862378, 4294967295) + H7) + (i:HQ(3890210469, m7) + i:HQ(3890210469, (i[100](m7))))), d7("UIScale", N7)
            P7.Scale = 1
            local function m7()
              P7.Scale = 0.92
              o7(P7, {Scale = 1}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
              local P7 = x7()
              if P7 then
                N7.Text = tostring(P7)
              end
            end
            N7.MouseButton1Click:Connect(m7)
            return N7
          end
          local function m7(P7, x7, H7, E7, N7)
            local d7 = i[48](165402592, 0)
            local B7 = Instance.new("Frame")
            B7:SetAttribute("CrystalButtonThemeControl", true)
            B7.Size = UDim2.new(1, 0, 0, w.actionH)
            B7.BackgroundColor3 = _.row
            B7:SetAttribute("CurtThemeRole", "Row")
            B7.BackgroundTransparency = 0.5
            B7.BorderSizePixel = 0
            B7.LayoutOrder = E7
            B7.Parent = P7
            N(B7, 8)
            d(B7, _.divider, 1)
            local L7 = Instance.new("UIScale", B7)
            L7.Scale = 1
            E7 = k7(Instance.new("TextButton"))
            E7.Size = UDim2.new(1, (H7 and -64) or -24, 1, 0)
            P7 = nil
            P7, d7 = UDim2, i[48](d7, 346704096)
            E7.Position = P7.new(0, (M and 8) or 12, 0, 0)
            E7.BackgroundTransparency = 1
            E7.Text = x7
            E7.TextColor3 = _.text
            d7 = i[48](d7, 304596277)
            E7.TextSize = w.textSize
            E7.Font = Enum.Font.GothamBold
            E7.TextXAlignment = Enum.TextXAlignment.Left
            E7.Parent = B7
            local function x7()
              L7.Scale = 0.985
              o7(L7, {Scale = 1}, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
              N7()
            end
            E7.MouseButton1Click:Connect(x7)
            if H7 then
              local E7 = i[48](338850582, 0)
              P7 = nil
              P7, E7 = Instance.new, i[48](E7, 439656024)
              local N7 = k7(P7("TextButton"))
              N7.Size = UDim2.new(0, (M and 38) or 44, 0, (M and 18) or 22)
              N7.Position = UDim2.new(1, (M and -45) or -54, 0.5, (M and -9) or -11)
              N7.BackgroundColor3 = _.accentDim
              N7:SetAttribute("CurtThemeRole", "AccentDim")
              N7.BackgroundTransparency = 0.35
              N7.BorderSizePixel = 0
              x7 = g[H7]
              N7.Text = (x7 and D7(x7)) or "-"
              N7.TextColor3 = _.text
              E7 = i:rQ((i:HQ(1211786674, E7) + i:HQ(1211786674, 413057047)) + (i:HQ(1871393948, (i[79](E7, 413057047))) + i:HQ(1211786675, (i[48](E7, 413057047)))))
              N7.TextSize = (M and 8) or 9
              N7.Font = Enum.Font.GothamBold
              N7.Parent = B7
              N(N7, 5)
              local function P7()
                S7(N7, H7)
              end
              N7.MouseButton1Click:Connect(P7)
              table.insert(Z, N7)
            end
            return B7
          end
          local P7 = A7.Movement
          Z7(P7, "SPEED CONFIGURATION", 0)
          Y7(P7, "Normal Speed", n.NormalBoost, 1, function(x7)
            local H7 = i[48](74816296, 0)
            local E7 = H7
            n.NormalBoost = math.max(1, math.floor(x7))
            H7 = i[48](E7, 401958440)
            H7 = i:rQ((i:HQ(278791262, H7) + i:HQ(278791262, 495530841)) + (i:HQ(3737384772, (i[79](H7, 495530841))) + i:HQ(278791263, (i[48](H7, 495530841)))))
            z = n.NormalBoost
            pcall(function()
              if _G.__refreshSpeedBoost then
                _G.__refreshSpeedBoost()
              end
            end)
            w7()
          end, "SelectNormalMode")
          Y7(P7, "Carry Speed", n.NormalSteal, 2, function(z)
            local x7 = i[48](364273855, 0)
            local H7 = x7
            local E7 = math.max
            x7 = i[48](H7, 435336858)
            H7 = i[93](math.floor(z))
            x7 = i:rQ((i:HQ(2452258828, x7) + i:HQ(2452258828, 231930140)) + (i:HQ(3685416936, (i[79](x7, 231930140))) + i:HQ(2452258829, (i[48](x7, 231930140)))))
            n.NormalSteal = E7(1, i:gQ(H7))
            K = n.NormalSteal
            pcall(function()
              if _G.__refreshSpeedBoost then
                _G.__refreshSpeedBoost()
              end
            end)
            w7()
          end)
          Z7(P7, "LAGGER SPEED", 3)
          Y7(P7, "Lagger Normal", n.LaggerBoost, 4, function(z)
            n.LaggerBoost = math.max(1, math.floor(z))
            k = n.LaggerBoost
            w7()
          end, "SelectLaggerMode")
          Y7(P7, "Lagger Carry", n.LaggerSteal, 5, function(z)
            n.LaggerSteal = math.max(1, math.floor(z))
            w7()
          end)
          Z7(P7, "CUSTOM SPEEDS", 6)
          local z = {}
          local function K(k)
            local x7 = V7(P7, k, 10 + #z)
            table.insert(z, x7)
            return x7
          end
          for z, z in ipairs(Q) do
            K(z)
          end
          U = k7(Instance.new("TextButton"))
          U.Size = UDim2.new(1, 0, 0, 38)
          U.BackgroundColor3 = _.row
          U:SetAttribute("CurtThemeRole", "Row")
          U.BackgroundTransparency = 0.3
          U.BorderSizePixel = 0
          G = i[48](G, 421911103)
          U.LayoutOrder = 50
          U.Text = "+  ADD CUSTOM SPEED"
          U.TextColor3 = _.text
          U.TextSize = 10
          U.Font = Enum.Font.GothamBold
          U.Parent = P7
          N(U, 10)
          d(U, _.divider, 1)
          local Q
          U.MouseButton1Click:Connect(function()
            local z = i[48](12988925, 0)
            local k = z
            local V7 = Q and Q.Parent
            if V7 then
              Q:Destroy()
              Q = nil
              return
            end
            V7 = f7
            z = i:rQ(k + 298616419)
            z = i:rQ(z + 173803231)
            local function z(k)
              Q = nil
              K(k)
              W7(k.name)
            end
            Q = V7(P7, 51, z)
          end)
          Z7(P7, "CONTROLS", 60)
          _7, a7 = v7(P7, "Auto Play", "Autoplay", h.Autoplay, 61, true, function(Q)
            R7("Autoplay", Q)
          end)
          l7(a7, string.upper(_G.__autoplayMode or "Full"), function()
            _G.__autoplayMode = ((_G.__autoplayMode == "Semi") and "Full") or "Semi"
            w7()
            return string.upper(_G.__autoplayMode)
          end)
          v7(P7, "Auto Carry Speed", "Auto Carry Speed", h["Auto Carry Speed"], 62, false, function(Q)
            R7("Auto Carry Speed", Q)
          end)
          v7(P7, "Carry Speed", "Carry Speed", h["Carry Speed"], 63, true, function(Q)
            R7("Carry Speed", Q)
          end)
          Z7(P7, "MOVEMENT SETTINGS", 70)
          J7, j7 = nil
          G, J7, j7 = i[48](G, 458193385), v7(P7, "Infinite Jump", "Inf Jump", h["Inf Jump"], 71, false, function(Q)
            R7("Inf Jump", Q)
          end)
          l7(j7, string.upper(_G.__CrystalInfJumpMode or "hold"), function()
            _G.__CrystalInfJumpMode = (((_G.__CrystalInfJumpMode or "hold") == "hold") and "manual") or "hold"
            if h["Inf Jump"] then
              if (_G.__CrystalInfJumpMode == "hold") and startInfJump then
                pcall(startInfJump)
              elseif stopInfJump then
                pcall(stopInfJump)
              end
            end
            w7()
            return string.upper(_G.__CrystalInfJumpMode)
          end)
          v7(P7, "Unwalk", "Unwalk", h.Unwalk, 72, false, function(Q)
            R7("Unwalk", Q)
          end)
          Z7(P7, "TP DOWN", 73)
          m7(P7, "TP Down", "TP Down", 74, function()
            if FeatureToggles["TP Down"] then
              pcall(FeatureToggles["TP Down"])
            end
          end)
          v7(P7, "Auto TP Down", "Auto TP Down", h["Auto TP Down"], 75, false, function(Q)
            R7("Auto TP Down", Q)
          end)
          Y7(P7, "Height (studs)", n.AutoTPDownHeight, 76, function(Q)
            n.AutoTPDownHeight = math.clamp(math.floor(Q + 0.5), 1, 1000)
            w7()
          end)
          q = A7.Combat
          Z7(q, "BAT CONTROLS", 0)
          u, Q7 = v7(q, "Bat Aimbot", "Aimbot", h.Aimbot, 1, true, function(u)
            R7("Aimbot", u)
          end)
          local function u()
            return ((_G.__aimbotMode == "bypass") and "BYPASS") or "NORMAL"
          end
          local Q = l7(Q7, u(), function()
            local z = ((_G.__aimbotMode == "bypass") and "normal") or "bypass"
            if _G.__CrystalSetAimbotMode then
              pcall(_G.__CrystalSetAimbotMode, z)
            else
              _G.__aimbotMode = z
            end
            w7()
            return u()
          end)
          function _G.__CrystalRefreshAimbotModeUI(u)
            if Q and Q.Parent then
              Q.Text = ((((u == "bypass") or (u == 2)) or (u == "2")) and "BYPASS") or "NORMAL"
            end
          end
          v7(q, "Mirror TP Down", "Mirror TP Down", h["Mirror TP Down"], 1.5, false, function(u)
            R7("Mirror TP Down", u)
          end)
          Z7(q, "AIMBOT SPEED", 1.6)
          Y7(q, "Normal Aimbot", n.AimbotSpeed or 59, 1.7, function(u)
            n.AimbotSpeed = math.clamp(math.floor(u + 0.5), 1, 200)
            n.CypherAimbotApproachSpeed = n.AimbotSpeed
            w7()
          end)
          Y7(q, "Lagger Mode Spd", n.AimbotSpeedLagger or 40, 1.8, function(u)
            n.AimbotSpeedLagger = math.clamp(math.floor(u + 0.5), 1, 200)
            w7()
          end)
          Y7(q, "Custom Aimbot Spd", n.AimbotSpeedCustom or 59, 1.9, function(u)
            n.AimbotSpeedCustom = math.clamp(math.floor(u + 0.5), 1, 200)
            w7()
          end)
          G = i[48](G, 475158344)
          G = i[48](G, 14160258)
          v7(q, "Anti Bat", "Anti Bat", h["Anti Bat"], 3, true, function(u)
            R7("Anti Bat", u)
          end)
          v7(q, "Ragdoll Counter", "Ragdoll Counter", h["Ragdoll Counter"], 4, false, function(u)
            R7("Ragdoll Counter", u)
          end)
          Z7(q, "RAGDOLL", 5)
          v7(q, "Anti Ragdoll", "Anti Ragdoll", h["Anti Ragdoll"], 6, false, function(u)
            R7("Anti Ragdoll", u)
          end)
          v7(q, "Medusa Counter", "Medusa Counter", h["Medusa Counter"], 7, false, function(u)
            R7("Medusa Counter", u)
          end)
          v7(q, "Anti Die", "Anti Die", h["Anti Die"], 8, false, function(u)
            R7("Anti Die", u)
          end)
          Z7(q, "TP BAT", 9)
          local u, u = v7(q, "TP Bat", "TP Bat", h["TP Bat"], 10, false, function(Q)
            R7("TP Bat", Q)
          end)
          u.ClipsDescendants = true
          local Q
          G, Q = i[48](G, 508279422), k7(Instance.new("TextButton"))
          Q.Name = "TPBatConfigToggle"
          Q.Size = UDim2.new(0, (M and 52) or 64, 0, (M and 18) or 22)
          W, J7 = UDim2.new, M and -60
          Q7, j7 = J7 or -76, (M and 5) or 7
          Q.Position = W(1, Q7, 0, j7)
          Q.BackgroundColor3 = _.accentDim
          Q:SetAttribute("CurtThemeRole", "AccentDim")
          Q.BackgroundTransparency = 0.2
          Q.BorderSizePixel = 0
          Q.Text = ""
          G = i:rQ((i:HQ(2147483649, 4294967295) + i:HQ(2147483648, G)) + (i:HQ(2147483648, 31296893) + i:HQ(2147483647, (i[100]((i[48](G, 31296893)))))))
          Q.AutoButtonColor = false
          Q.ZIndex = 12
          Q.Parent = u
          N(Q, 6)
          d(Q, Color3.fromRGB(70, 75, 84), 1)
          U = k7(Instance.new("TextLabel"))
          q7 = nil
          q7, G = UDim2.new(0, 30, 1, 0), i[48](G, 259212372)
          U.Size = q7
          U.Position = UDim2.new(0, 5, 0, 0)
          G = i:rQ((i:HQ(2810645779, G) + i:HQ(2810645779, 140714166)) + (i:HQ(2968643034, (i[89](G, 140714166))) + i:HQ(1484321518, (i[48](G, 140714166)))))
          U.BackgroundTransparency = 1
          U.Text = "GUI"
          Q7 = i:rQ(j7)
          G = i:rQ((i:HQ(187499596, 4294967295) + i:HQ(2987967160, (i[100]((i[48](G, 49794765)))))) + (i:HQ(2987967161, (i[48](G, 49794765))) + (i:HQ(1119500540, Q7) + i:HQ(1119500540, (i[100](Q7))))))
          U.TextColor3 = _.text
          U.TextSize = 8
          U.Font = Enum.Font.GothamBold
          U.TextXAlignment = Enum.TextXAlignment.Left
          U.ZIndex = 13
          U.Parent = Q
          local z = Instance.new("Frame")
          z.Size = UDim2.new(0, 24, 0, 12)
          z.Position = UDim2.new(1, -29, 0.5, -6)
          z.BackgroundColor3 = Color3.fromRGB(30, 31, 35)
          z.BorderSizePixel = 0
          z.ZIndex = 13
          z.Parent = Q
          N(z, 20)
          local K = Instance.new("Frame")
          a7 = nil
          a7, G = UDim2, i:rQ((i:HQ(1012746846, G) + i:HQ(1012746846, 473239297)) + (i:HQ(2269473604, (i[89](473239297, G))) + i:HQ(3282220451, (i[48](G, 473239297)))))
          K.Size = a7.new(0, 8, 0, 8)
          K.Position = UDim2.new(0, 2, 0.5, -4)
          K.BackgroundColor3 = Color3.fromRGB(155, 165, 180)
          K.BorderSizePixel = 0
          K.ZIndex = 14
          K.Parent = z
          N(K, 20)
          local k = k7(Instance.new("TextButton"))
          k.Name = "TPBatInlineKeybind"
          k:SetAttribute("MiniUIBind", true)
          k.Size = UDim2.new(0, (M and 36) or 42, 0, (M and 18) or 22)
          q7 = nil
          q7, G = UDim2, i[48](G, 245016605)
          k.Position = q7.new(1, (M and -102) or -124, 0, (M and 5) or 7)
          k.BackgroundColor3 = _.accentDim
          k:SetAttribute("CurtThemeRole", "AccentDim")
          k.BackgroundTransparency = 0.25
          k.BorderSizePixel = 0
          k.Text = (g["TP Bat"] and D7(g["TP Bat"])) or "-"
          k.TextColor3 = _.text
          W = nil
          if M then
            G = i[48](G, 417358451)
            G = i[48](G, 417358451)
            W = 8
          else
            W = M
          end
          k.TextSize = W or 9
          k.Font = Enum.Font.GothamBold
          k.AutoButtonColor = false
          k.ZIndex = 12
          k.Parent = u
          N(k, 5)
          d(k, Color3.fromRGB(55, 55, 60), 1)
          local function W7()
            S7(k, "TP Bat")
          end
          k.MouseButton1Click:Connect(W7)
          table.insert(Z, k)
          local Z = Y["TP Bat"]
          Y["TP Bat"] = function()
            if Z then
              pcall(Z)
            end
            local Z = g["TP Bat"]
            k.Text = (Z and D7(Z)) or "-"
            k.BackgroundColor3 = _.accentDim
            k:SetAttribute("CurtThemeRole", "AccentDim")
            k.BackgroundTransparency = 0.25
            k.TextColor3 = _.text
          end
          local k = Instance.new("Frame")
          k.Name = "TPBatConfigPanel"
          k.Size = UDim2.new(1, -16, 0, 78)
          k.Position = UDim2.new(0, 8, 0, (M and 42) or 54)
          k.BackgroundColor3 = _.bgDark
          k:SetAttribute("CurtThemeRole", "BgDark")
          G = i:rQ((i:HQ(944969862, 4294967295) + i:HQ(3349997435, G)) + (i:HQ(2147483648, 243558143) + (i:HQ(2147483647, (i[100]((i[48](G, 243558143))))) + i:HQ(1202513787, (i[100](G))))))
          k.BackgroundTransparency = 0.16
          k.BorderSizePixel = 0
          k.Visible = false
          k.ZIndex = 8
          k.Parent = u
          N(k, 8)
          d(k, _.divider, 1)
          local function Z(J7, _7)
            local S7 = k7(Instance.new("TextLabel"))
            S7.Size = UDim2.new(1, -100, 0, 34)
            S7.Position = UDim2.new(0, 10, 0, _7)
            S7.BackgroundTransparency = 1
            S7.Text = J7
            S7.TextColor3 = _.textMuted
            S7.TextSize = 9
            S7.Font = Enum.Font.GothamBold
            S7.TextXAlignment = Enum.TextXAlignment.Left
            S7.ZIndex = 9
            S7.Parent = k
            return S7
          end
          Z("DISTANCIA TP (STUDS)", 2)
          Z("VERSION TP BAT", 40)
          local J7 = k7(Instance.new("TextBox"))
          J7.Size = UDim2.new(0, 72, 0, 26)
          J7.Position = UDim2.new(1, -82, 0, 6)
          J7.BackgroundColor3 = _.row
          J7:SetAttribute("CurtThemeRole", "Row")
          J7.BorderSizePixel = 0
          J7.ClearTextOnFocus = false
          J7.Text = tostring(_G.__tpBatV2Distance or 8)
          G = i[48](G, 310769302)
          J7.TextColor3 = _.text
          J7.TextSize = 10
          J7.Font = Enum.Font.GothamBold
          J7.TextXAlignment = Enum.TextXAlignment.Center
          J7.ZIndex = 10
          J7.Parent = k
          N(J7, 5)
          G = i[48](G, 536265158)
          d(J7, Color3.fromRGB(70, 85, 105), 1)
          local _7 = k7(Instance.new("TextButton"))
          _7.Size = UDim2.new(0, 72, 0, 26)
          _7.Position = UDim2.new(1, -82, 0, 44)
          U = nil
          U, G = _.accentDim, i[48](G, 68540887)
          _7.BackgroundColor3 = U
          _7:SetAttribute("CurtThemeRole", "AccentDim")
          _7.BorderSizePixel = 0
          _7.TextColor3 = _.text
          _7.TextSize = 10
          _7.Font = Enum.Font.GothamBold
          _7.ZIndex = 10
          _7.Parent = k
          _7.Visible = true
          N(_7, 5)
          d(_7, Color3.fromRGB(70, 85, 105), 1)
          local function G()
            _G.__batVersion = ((tonumber(_G.__batVersion) == 2) and 2) or 1
            _7.Text = "V" .. tostring(_G.__batVersion or 1)
            _7.BackgroundColor3 = _.accentDim
            _7:SetAttribute("CurtThemeRole", "AccentDim")
            J7.TextEditable = true
            J7.Text = tostring(_G.__tpBatV2Distance or 8)
            J7.BackgroundTransparency = 0
            J7.TextColor3 = _.text
          end
          _G.__CrystalRefreshVisibleTPBatConfig = G
          G()
          local S7 = false
          local function f7(V7)
            S7 = V7 == true
            k.Visible = S7
            local V7, P7 = UDim2.new, S7 and ((M and 124) or 140)
            u.Size = V7(1, 0, 0, P7 or w.toggleH)
            Q.BackgroundColor3 = (S7 and _.accent) or _.accentDim
            z.BackgroundColor3 = (S7 and _.accent) or Color3.fromRGB(30, 31, 35)
            K.BackgroundColor3 = (S7 and Color3.fromRGB(245, 248, 255)) or Color3.fromRGB(155, 165, 180)
            K.Position = (S7 and UDim2.new(1, -10, 0.5, -4)) or UDim2.new(0, 2, 0.5, -4)
          end
          Q.MouseButton1Click:Connect(function()
            f7(not S7)
          end)
          local function z()
            _G.CrystalAutoBat.SetV2Distance(J7.Text)
          end
          J7.FocusLost:Connect(z)
          local function z()
            _G.CrystalAutoBat.SetVersion(((_G.__batVersion == 1) and 2) or 1)
            G()
          end
          _7.MouseButton1Click:Connect(z)
          function _G.__CrystalRefreshVisibleTPBatConfig()
          end
          u.Size = UDim2.new(1, 0, 0, w.toggleH)
          pcall(function()
            Q:Destroy()
          end)
          pcall(function()
            k:Destroy()
          end)
          v7(q, "Steal Bar", "Steal Bar", true, 11, false, function(G)
            R7("Steal Bar", G)
          end)
          Z7(q, "ACTIONS", 12)
          m7(q, "Drop Brainrot", "Drop", 13, function()
            if FeatureToggles.Drop then
              pcall(FeatureToggles.Drop, "button")
            end
          end)
          m7(q, "TP Down", "TP Down", 14, function()
            if FeatureToggles["TP Down"] then
              pcall(FeatureToggles["TP Down"])
            end
          end)
          m7(q, "Insta Reset", "Insta Reset", 15, function()
            if FeatureToggles["Insta Reset"] then
              pcall(FeatureToggles["Insta Reset"])
            end
          end)
          Z7(q, "AUTO STEAL", 16)
          q7, z = v7(q, "Auto Steal", "auto steal", h["auto steal"], 17, false, function(G)
            R7("auto steal", G)
          end)
          local G = l7(z, string.upper(r), function()
            r = ((r == "v2") and "v1") or "v2"
            if h["auto steal"] and l["auto steal"] then
              pcall(l["auto steal"], false)
              pcall(l["auto steal"], true)
            end
            if type(_G.__CrystalRefreshStealBarModePill) == "function" then
              pcall(_G.__CrystalRefreshStealBarModePill)
            end
            w7()
            local u, Q = string.upper, r
            return u(Q)
          end)
          local function u(Q)
            local K = G and G.Parent
            if K then
              G.Text = string.upper(tostring((Q or r) or "v1"))
            end
          end
          _G.__CrystalRefreshAutoStealModeUI = u
          Y7(q, "Steal Radius", j.Radius, 18, function(G)
            j.Radius = math.clamp(math.floor(G), 10, 150)
            w7()
          end)
          local G = A7.Visual
          Z7(G, "VISUAL", -2)
          v7(G, "anti lag", "Anti Lag", h["Anti Lag"], -1, false, function(Q)
            R7("Anti Lag", Q)
          end)
          v7(G, "ESP Players", "ESP Players", h["ESP Players"], 1, false, function(Q)
            R7("ESP Players", Q)
          end)
          v7(G, "ESP Line", "Player Tracers", h["Player Tracers"], 2, false, function(Q)
            R7("Player Tracers", Q)
          end)
          q, Z = v7(G, "Optimizer", "Optimizer", h.Optimizer, 3, false, function(Q)
            R7("Optimizer", Q)
          end)
          local Q = l7(Z, string.upper(b or "Ultra"), function()
            local j = ((b == "Ultra") and "Normal") or "Ultra"
            H(j)
            return string.upper(j)
          end)
          table.insert(a, function(b)
            if Q and Q.Parent then
              Q.Text = string.upper(b)
            end
          end)
          v7(G, "Stretch Rez", "Stretchz Res", h["Stretchz Res"], 4, false, function(b)
            R7("Stretchz Res", b)
          end)
          Z7(G, "FOV", 5)
          v7(G, "Custom FOV", "Custom FOV", h["Custom FOV"], 6, false, function(b)
            R7("Custom FOV", b)
          end)
          Y7(G, "FOV", n.FOV, 7, function(b)
            n.FOV = math.clamp(math.floor(b), 30, 120)
            R7("Custom FOV", true)
            if l["Custom FOV"] then
              pcall(l["Custom FOV"], true)
            end
            b = workspace.CurrentCamera
            if b then
              b.FieldOfView = n.FOV
            end
            w7()
          end)
          Z7(G, "SKY", 8)
          a7, Y7 = v7(G, "Sky Themes", "Sky Changer", h["Sky Changer"], 9, false, function(b)
            R7("Sky Changer", b)
          end)
          l7(Y7, string.upper(v or "blue"), function()
            v = if v == "day" then "blue" else if v == "blue" then "night" else "day"
            _G.__CrystalSkyChangerMode = v
            local b = h["Sky Changer"]
            if b then
              A(v)
            end
            w7()
            local b, n = string.upper, v
            return b(n)
          end)
          Z7(G, "APPEARANCE", 10)
          Y7 = {add = function(b, n, Q)
            local j = i[48](391663680, 0)
            local r = j
            local q = {}
            j = i:rQ((i:HQ(1084357942, r) + i:HQ(1084357942, 374389501)) + (i:HQ(2126251412, (i[79](r, 374389501))) + i:HQ(1084357943, (i[48](r, 374389501)))))
            r = nil
            r, j = h[n], i[48](j, 378263402)
            q.update, q.row = v7(G, b, n, r, Q, false, function(b)
              R7(n, b)
            end)
            q.button = l7(q.row, (h[n] and "ON") or "OFF", function()
              R7(n, not h[n])
              return (h[n] and "ON") or "OFF"
            end)
            q.refresh = function()
              q.update(h[n] == true)
              q.button.Text = (h[n] and "ON") or "OFF"
            end
            Y[n] = q.refresh
            q.refresh()
          end}
          m7(G, "Custom Skins", nil, 12, function()
            if _G._KawatanOpenSkinGallery then
              pcall(_G._KawatanOpenSkinGallery)
            end
          end)
          Y7.add("Headless", "Headless Visual", 13)
          Y7.add("Korblox", "Korblox Visual", 14)
          Z7(G, "GUI", 15)
          do
            local b = {"RED", "PINK", "BLUE"}
            U = m7(G, "Script Color", nil, 15, function()
            end)
            l7(U, b[G7] or "RED", function()
              G7 = (tonumber(G7) or 1) + 1
              local U = G7
              local n = U > #b7
              if n then
                G7 = 1
              end
              _G._CrystalHub_UI_BgIndex = G7
              if T7 then
                T7.Image = b7[G7]
              end
              if M7 then
                M7.Image = b7[G7]
              end
              U = _G.__CrystalApplyCurtVisualTheme
              if U then
                pcall(_G.__CrystalApplyCurtVisualTheme, G7)
              end
              n = type(_G.__CrystalSetStealBarParticles) == "function"
              if n then
                pcall(_G.__CrystalSetStealBarParticles, G7 == 2, G7)
              end
              n = type(_G.__CrystalApplyAutoStealBarTheme) == "function"
              if n then
                pcall(_G.__CrystalApplyAutoStealBarTheme, G7)
              end
              w7()
              n = G7
              return b[n]
            end).Name = "ScriptColorMode"
          end
          do
            u = m7(G, "Custom Font", nil, 15.1, function()
            end)
            local b
            local function U()
              local n = b and b.Parent
              if n then
                local n = b:FindFirstChild("Frame")
                if n then
                  local Q = i[48](440102717, 0)
                  local j = c:Create(n, TweenInfo.new(0.18), {BackgroundTransparency = 1})
                  j:Play()
                  Q = i:rQ(Q + 516561078)
                  local n
                  n, Q = j.Completed, i:rQ(Q - 281070485)
                  n:Connect(function()
                    local n = i[48](479269074, 0)
                    local Q = n
                    local j
                    j, n = pcall, i:rQ((i:HQ(263743273, Q) + i:HQ(263743273, 522072182)) + (i:HQ(4031224024, (i[79](Q, 522072182))) + i:HQ(4031224022, (i[89](Q, 522072182)))))
                    j(function()
                      local n = b
                      if n then
                        b:Destroy()
                      end
                    end)
                    b = nil
                  end)
                else
                  local n = i[48](464650154, 0)
                  local Q
                  Q, n = pcall, i:rQ(n + 270308722)
                  Q(function()
                    b:Destroy()
                  end)
                  b = nil
                end
              end
            end
            _G.__CrystalFontPickerClose = U
            l7(u, "PICK", function()
              local n = i[48](65730429, 0)
              local Q = b and b.Parent
              if Q then
                U()
                return "PICK"
              end
              n = i:rQ(n + 287756220)
              b = Instance.new("ScreenGui")
              b.Name = "CrystalHubFontPicker"
              b.ResetOnSpawn = false
              b.IgnoreGuiInset = true
              Q = b
              Q.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
              b.DisplayOrder = 100000
              Q = b
              Q.Parent = p.Parent or p
              Q = Instance.new("TextButton")
              Q.Name = "Backdrop"
              Q.Size = UDim2.new(1, 0, 1, 0)
              Q.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
              n = i:rQ(n - 129656098)
              Q.BackgroundTransparency = 0.45
              Q.BorderSizePixel = 0
              Q.Text = ""
              Q.ZIndex = 1
              Q.Parent = b
              Q.MouseButton1Click:Connect(U)
              Q = Instance.new("Frame")
              Q.Name = "Frame"
              Q.Size = UDim2.new(0, 380, 0, 520)
              Q.Position = UDim2.new(0.5, -190, 0.5, -260)
              Q.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
              Q.BorderSizePixel = 0
              Q.ZIndex = 2
              Q.Parent = b
              Instance.new("UICorner", Q).CornerRadius = UDim.new(0, 16)
              local b = Instance.new("UIStroke", Q)
              b.Color = ((typeof(_) == "table") and _.accent) or Color3.fromRGB(220, 40, 40)
              b.Thickness = 1.4
              b.Transparency = 0.25
              b = Instance.new("Frame")
              b.Size = UDim2.new(1, 0, 0, 48)
              b.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
              b.BorderSizePixel = 0
              b.ZIndex = 3
              b.Parent = Q
              Instance.new("UICorner", b).CornerRadius = UDim.new(0, 16)
              local j = Instance.new("TextLabel")
              j.Size = UDim2.new(1, -60, 1, 0)
              j.Position = UDim2.new(0, 16, 0, 0)
              j.BackgroundTransparency = 1
              j.Text = "CUSTOM FONTS"
              j.TextColor3 = Color3.fromRGB(245, 245, 250)
              n = i:rQ(n + 271494995)
              j.Font = Enum.Font.GothamBlack
              j.TextSize = 15
              j.TextXAlignment = Enum.TextXAlignment.Left
              j.ZIndex = 4
              n = i:rQ(n - 310921360)
              j.Parent = b
              j:SetAttribute("CrystalFontLock", true)
              j = Instance.new("TextButton")
              j.Size = UDim2.new(0, 32, 0, 32)
              j.Position = UDim2.new(1, -40, 0.5, -16)
              j.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
              j.BorderSizePixel = 0
              j.Text = "X"
              j.TextColor3 = Color3.fromRGB(255, 255, 255)
              j.Font = Enum.Font.GothamBlack
              n = i:rQ(n + 286693284)
              j.TextSize = 14
              j.ZIndex = 5
              j.Parent = b
              Instance.new("UICorner", j).CornerRadius = UDim.new(0, 8)
              j:SetAttribute("CrystalFontLock", true)
              j.MouseButton1Click:Connect(U)
              local U = Instance.new("ScrollingFrame")
              U.Size = UDim2.new(1, -16, 1, -60)
              U.Position = UDim2.new(0, 8, 0, 52)
              U.BackgroundTransparency = 1
              U.BorderSizePixel = 0
              U.ScrollBarThickness = 4
              U.ScrollBarImageColor3 = ((typeof(_) == "table") and _.accent) or Color3.fromRGB(220, 40, 40)
              U.CanvasSize = UDim2.new(0, 0, 0, 0)
              U.ZIndex = 3
              U.Parent = Q
              local n, r, q, K = 3, 110, 118, {}
              pcall(function()
                local k = _G.CrystalFonts and _G.CrystalFonts.list
                if k then
                  K = _G.CrystalFonts.list()
                end
              end)
              j = (type(K) ~= "table") or (#K == 0)
              if j then
                K = {{key = "Default", label = "Default", font = nil}}
              else
              end
              b = math.ceil(#K / n)
              U.CanvasSize = UDim2.new(0, 0, 0, 16 + (b * q))
              local k = {}
              local function a(A)
                local v = A:GetAttribute("FontIdx")
                A = (v and K[v]) or nil
                return A
              end
              local function A()
                for v, H in ipairs(k) do
                  v = a(H)
                  local J7, q7 = v and (_G.CrystalFontChoice == v.key), H:FindFirstChildOfClass("UIStroke")
                  if q7 then
                    q7.Color = (J7 and (((typeof(_) == "table") and _.accent) or Color3.fromRGB(220, 40, 40))) or Color3.fromRGB(60, 60, 70)
                    q7.Transparency = (J7 and 0) or 0.45
                    q7.Thickness = (J7 and 2.2) or 1.1
                  end
                end
              end
              local function v(H, J7)
                local q7 = K[J7]
                if not q7 then
                  H:SetAttribute("FontIdx", nil)
                  H.Visible = false
                  return
                end
                local K, _7 = math.floor((J7 - 1) / n), (J7 - 1) % n
                H.Position = UDim2.new(0, 6 + (_7 * q), 0, 6 + (K * q))
                H:SetAttribute("FontIdx", J7)
                local _7 = H:FindFirstChild("Preview")
                if _7 then
                  if q7.font then
                    local a7 = i[48](489978805, 0)
                    K = a7
                    J7 = nil
                    J7, a7 = pcall, i:rQ((i:HQ(1956142604, K) + i:HQ(1956142604, 510890001)) + (i:HQ(382682088, (i[89](510890001, K))) + i:HQ(2338824693, (i[48](K, 510890001)))))
                    J7(function()
                      _7.FontFace = q7.font
                    end)
                  else
                    _7.Font = Enum.Font.GothamBlack
                  end
                end
                K = H:FindFirstChild("FontName")
                if K then
                  K.Text = q7.label
                end
                H.Visible = true
              end
              for K = 1, (math.ceil(456 / q) + 2) * n, 1 do
                local H = i[48](5347767, 0)
                j = H
                local J7 = Instance.new("TextButton")
                J7.Name = "FontCard_" .. tostring(K)
                J7.Size = UDim2.new(0, r, 0, r)
                J7.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
                J7.BorderSizePixel = 0
                b = i:rQ(K)
                H = i:rQ((i:HQ(66777693, 4294967295) + j) + (i:HQ(3693197575, b) + i:HQ(3693197575, (i[100](b)))))
                J7.Text = ""
                J7.AutoButtonColor = false
                J7.Visible = false
                J7.ZIndex = 4
                J7.ClipsDescendants = true
                J7.Parent = U
                Instance.new("UICorner", J7).CornerRadius = UDim.new(0, 12)
                local b = Instance.new("UIStroke", J7)
                b.Color = Color3.fromRGB(60, 60, 70)
                b.Thickness = 1.1
                b.Transparency = 0.45
                b = Instance.new("TextLabel")
                b.Name = "Preview"
                b.Size = UDim2.new(1, -8, 0, 48)
                b.Position = UDim2.new(0, 4, 0, 10)
                b.BackgroundTransparency = 1
                b.Text = "Aa"
                b.TextColor3 = Color3.fromRGB(245, 245, 250)
                b.Font = Enum.Font.GothamBlack
                b.TextSize = 34
                b.ZIndex = 5
                b.Parent = J7
                b:SetAttribute("CrystalFontLock", true)
                b = Instance.new("TextLabel")
                b.Name = "FontName"
                b.Size = UDim2.new(1, -8, 0, 28)
                local j, r = UDim2, i:rQ(K)
                H, b.Position = i:rQ((i:HQ(1681323863, 4294967295) + H) + (i:HQ(2963570507, r) + i:HQ(2963570507, (i[100](r))))), j.new(0, 4, 1, -32)
                b.BackgroundTransparency = 1
                b.Text = ""
                b.TextColor3 = Color3.fromRGB(180, 180, 190)
                b.Font = Enum.Font.GothamBold
                b.TextSize = 9
                b.TextWrapped = true
                b.ZIndex = 5
                b.Parent = J7
                b:SetAttribute("CrystalFontLock", true)
                j = J7.MouseButton1Click
                local function b()
                  local r = i[48](339963272, 0)
                  local K = r
                  local H
                  r, H = i:rQ((i:HQ(1043827143, K) + i:HQ(1043827143, 392815756)) + (i:HQ(2207313010, (i[79](K, 392815756))) + i:HQ(1043827144, (i[48](K, 392815756))))), a(J7)
                  if not H then
                    return
                  end
                  K = nil
                  K, r = _G, i[48](r, 174751082)
                  if K.CrystalFonts and _G.CrystalFonts.set then
                    pcall(_G.CrystalFonts.set, H.key)
                  else
                    _G.CrystalFontChoice = H.key
                  end
                  pcall(function()
                    if w7 then
                      w7()
                    end
                  end)
                  A()
                end
                j:Connect(b)
                k[#k + 1] = J7
              end
              local b = -1
              local function j()
                local r, K = math.max(0, math.floor((U.CanvasPosition.Y - 6) / q) - 1), b
                if r == K then
                  return
                end
                b = r
                for b, q in ipairs(k) do
                  v(q, (r * n) + b)
                end
                A()
              end
              U:GetPropertyChangedSignal("CanvasPosition"):Connect(j)
              j()
              Q.Size = UDim2.fromOffset(0, 0)
              Q.Position = UDim2.new(0.5, 0, 0.5, 0)
              c:Create(Q, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(380, 520), Position = UDim2.new(0.5, -190, 0.5, -260)}):Play()
              return "PICK"
            end).Name = "CustomFontMode"
            task.defer(function()
              task.wait(0.6)
              if ((_G.CrystalFonts and _G.CrystalFonts.set) and _G.CrystalFontChoice) and (_G.CrystalFontChoice ~= "Default") then
                pcall(_G.CrystalFonts.set, _G.CrystalFontChoice, true)
              end
            end)
          end
          l7(m7(G, "Tabs Position", nil, 15.25, function()
          end), ((_G.__CrystalTabPosition == "Left") and "LEFT") or "DOWN", function()
            local b = ((_G.__CrystalTabPosition == "Left") and "Down") or "Left"
            _G.__CrystalSetTabPosition(b)
            return string.upper(b)
          end).Name = "TabsPositionMode"
          z, W = v7(G, "\240\159\142\131 Halloween Mode \240\159\142\131", "Halloween Mode", h["Halloween Mode"], 15.5, false, function(b)
            R7("Halloween Mode", b)
            b = _G.__CrystalApplyCurtVisualTheme
            if b then
              pcall(_G.__CrystalApplyCurtVisualTheme, G7)
            end
          end)
          W.Name = "HalloweenModeRow"
          for b, b in ipairs(W:GetChildren()) do
            if b:IsA("TextLabel") then
              b.Name = "HalloweenModeLabel"
              b.Text = "\240\159\142\131 Halloween Mode \240\159\142\131"
              b.TextColor3 = Color3.fromRGB(255, 145, 35)
              b.TextStrokeColor3 = Color3.fromRGB(70, 24, 0)
              b.TextStrokeTransparency = 0.55
              b.TextSize = w.textSize + 1
              break
            end
          end
          v7(G, "Quick Buttons", "Show Buttons", h["Show Buttons"], 16, false, function(b)
            R7("Show Buttons", b)
          end)
          do
            local b, U = m7(G, "Buttons Size", nil, 16.5, function()
            end), k7(Instance.new("TextBox"))
            U.Name = "ButtonsSizeInput"
            U.Size = UDim2.fromOffset(64, (M and 22) or 26)
            U.AnchorPoint = Vector2.new(1, 0.5)
            U.Position = UDim2.new(1, -10, 0.5, 0)
            U.BackgroundColor3 = _.accentDim
            U:SetAttribute("CurtThemeRole", "AccentDim")
            U:SetAttribute("CurtThemeAccentInput", true)
            U.BorderSizePixel = 0
            U.TextColor3 = _.text
            U.Font = Enum.Font.GothamBold
            U.TextSize = 12
            U.Text = tostring(_G.__CrystalButtonsSize or 1)
            U.PlaceholderText = "0.5 - 2"
            U.ClearTextOnFocus = false
            U.ZIndex = 8
            U.Parent = b
            N(U, 5)
            local function b()
              U.Text = tostring(_G.__CrystalSetButtonsSize(U.Text))
            end
            U.FocusLost:Connect(b)
          end
          m7(G, "reset butons pos.", nil, 17, function()
            _G.__CrystalResetButtonPositions()
            if _G.CrystalLagger and _G.CrystalLagger.ResetPosition then
              _G.CrystalLagger.ResetPosition()
            end
          end)
          v7(G, "Lock Buttons", "Lock Buttons", h["Lock Buttons"], 18, false, function(b)
            R7("Lock Buttons", b)
          end)
          v7(G, "Hide Status Bar", "Hide Status Bar", h["Hide Status Bar"], 18.5, false, function(b)
            R7("Hide Status Bar", b)
          end)
          m7(G, "Hide GUI Key", "Toggle UI", 19, function()
            E.Visible = false
          end)
          Z7(G, "PANELS", 20)
          m7(G, "Open Lagger", nil, 21, function()
            local b = F:FindFirstChild("PlayerGui") and F.PlayerGui:FindFirstChild("CrystalLaggerGUI")
            local G = b and (b:FindFirstChild("MainFrame"))
            if G then
              b = not G.Visible
              if _G.CrystalLagger and _G.CrystalLagger.SetVisible then
                pcall(_G.CrystalLagger.SetVisible, b)
              else
                G.Visible = b
              end
            elseif _G.__openLaggerGUI then
              pcall(_G.__openLaggerGUI, true)
            end
          end)
          Y7 = A7.Animations
          Z7(Y7, "ANIMATION SOURCE", 0)
          local b = _G.__CrystalAnimationPreset
          Z = not b or not O[b]
          if Z then
            b = x or o[1]
          else
          end
          j7 = Instance.new("Frame")
          j7.Size = UDim2.new(1, 0, 0, 42)
          j7.BackgroundColor3 = _.row
          j7:SetAttribute("CurtThemeRole", "Row")
          j7.BackgroundTransparency = 0.5
          j7.BorderSizePixel = 0
          j7.LayoutOrder = 1
          j7.Parent = Y7
          N(j7, 10)
          d(j7, _.divider, 1)
          Z = k7(Instance.new("TextButton"))
          Z.Size = UDim2.new(0, 42, 1, -8)
          Z.Position = UDim2.new(0, 4, 0, 4)
          Z.BackgroundColor3 = _.accentDim
          Z:SetAttribute("CurtThemeRole", "AccentDim")
          Z.BackgroundTransparency = 0.2
          Z.BorderSizePixel = 0
          Z.Text = "<"
          Z.TextColor3 = _.text
          Z.TextSize = 18
          Z.Font = Enum.Font.GothamBlack
          Z.Parent = j7
          N(Z, 7)
          local G = k7(Instance.new("TextLabel"))
          G.Size = UDim2.new(1, -100, 1, 0)
          G.Position = UDim2.new(0, 50, 0, 0)
          G.BackgroundTransparency = 1
          G.TextColor3 = _.text
          G.TextSize = 10
          G.TextWrapped = true
          G.Font = Enum.Font.GothamBold
          G.Parent = j7
          Q7 = k7(Instance.new("TextButton"))
          Q7.Size = UDim2.new(0, 42, 1, -8)
          Q7.Position = UDim2.new(1, -46, 0, 4)
          Q7.BackgroundColor3 = _.accentDim
          Q7:SetAttribute("CurtThemeRole", "AccentDim")
          Q7.BackgroundTransparency = 0.2
          Q7.BorderSizePixel = 0
          Q7.Text = ">"
          Q7.TextColor3 = _.text
          Q7.TextSize = 18
          Q7.Font = Enum.Font.GothamBlack
          Q7.Parent = j7
          N(Q7, 7)
          local function U()
            G.Text = tostring(b)
          end
          local function G(n)
            local Q = 1
            for j, r in ipairs(o) do
              local q = b
              if r == q then
                Q = j
                break
              end
            end
            Q += n
            Q = if Q < 1 then #o else Q
            b = o[if Q > #o then 1 else Q]
            U()
            _G.__CrystalAnimationPreset = b
            if h.Animaciones then
              l.Animaciones(true)
            else
              R7("Animaciones", true)
            end
            pcall(w7)
          end
          local function o()
            G(-1)
          end
          Z.MouseButton1Click:Connect(o)
          local function o()
            G(1)
          end
          Q7.MouseButton1Click:Connect(o)
          U()
          local function o(G)
            if type(G) == "number" then
              return "rbxassetid://" .. tostring(G)
            end
            if (type(G) == "string") and string.match(G, "^%d+$") then
              return "rbxassetid://" .. G
            end
            return G
          end
          local G = _G.__CrystalOriginalAnimations
          if type(G) ~= "table" then
            u, Z7 = setmetatable, {__mode = "k"}
            G = u({}, Z7)
            _G.__CrystalOriginalAnimations = G
          else
          end
          local function u(U, n, Q)
            local j = i[48](531501022, 0)
            Q = Q or {}
            if next(Q) == nil then
              for r, q in pairs(n) do
                if q then
                  Q[r] = q.AnimationId
                end
              end
            end
            local r = U:FindFirstChildOfClass("Humanoid")
            U = nil
            U, j = pcall, i:rQ(j + 302484540)
            local j, q = U(function()
              return r and (r:GetAppliedDescription())
            end)
            if j and q then
              local j = i[48](270297953, 0)
              U = j
              j = i:rQ(U + 340026305)
              local function U(j, r)
                local z = tonumber(q[r])
                if (z and (z > 0)) and n[j] then
                  Q[j] = "rbxassetid://" .. tostring(z)
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
            return Q
          end
          local function U(n, Q)
            local j = F.Character
            local r = j and (j:FindFirstChild("Animate") or j:WaitForChild("Animate", 3))
            if not r then
              return false
            end
            local q = {idle1 = r:FindFirstChild("idle") and r.idle:FindFirstChild("Animation1"), idle2 = r:FindFirstChild("idle") and r.idle:FindFirstChild("Animation2"), walk = r:FindFirstChild("walk") and r.walk:FindFirstChild("WalkAnim"), run = r:FindFirstChild("run") and r.run:FindFirstChild("RunAnim"), jump = r:FindFirstChild("jump") and r.jump:FindFirstChild("JumpAnim"), fall = r:FindFirstChild("fall") and r.fall:FindFirstChild("FallAnim"), climb = r:FindFirstChild("climb") and r.climb:FindFirstChild("ClimbAnim"), swim = r:FindFirstChild("swim") and r.swim:FindFirstChild("Swim"), swimidle = r:FindFirstChild("swimidle") and r.swimidle:FindFirstChild("SwimIdle")}
            if Q then
              local r = G[j]
              if not r then
                return false
              end
              for z, K in pairs(r) do
                if q[z] then
                  q[z].AnimationId = K
                end
              end
            else
              local r = O[n]
              if not r then
                return false
              end
              G[j] = u(j, q, G[j])
              local O = r.Idle or {}
              local G = {idle1 = r.Animation1 or O[1], idle2 = r.Animation2 or O[2], walk = r.WalkAnim, run = r.RunAnim, jump = r.JumpAnim, fall = r.FallAnim, climb = r.ClimbAnim, swim = r.Swim, swimidle = r.SwimIdle}
              for O, u in pairs(G) do
                if q[O] and u then
                  q[O].AnimationId = o(u)
                end
              end
            end
            Q = j:FindFirstChildOfClass("Humanoid")
            if Q then
              for o, O in ipairs(Q:GetPlayingAnimationTracks()) do
                local G = i[48](275723080, 0)
                j = G
                o = nil
                o, G = pcall, i:rQ((i:HQ(1088911887, j) + i:HQ(1088911887, 237159085)) + (i:HQ(2117143522, (i[79](j, 237159085))) + i:HQ(1088911888, (i[48](j, 237159085)))))
                o(function()
                  O:Stop(0)
                end)
              end
            end
            return true
          end
          function l.Animaciones(o)
            h["Harder Hit Anim"] = false
            if o then
              _G.__CrystalAnimationPreset = b
              pcall(U, b, false)
            else
              pcall(U, nil, true)
            end
            if Y["Harder Hit Anim"] then
              pcall(Y["Harder Hit Anim"])
            end
          end
          local o, O = v7(Y7, "Animaciones", "Animaciones", h.Animaciones, 2, false, function(b)
            R7("Animaciones", b)
          end)
          O.Name = "AnimationsMasterToggle"
          O.Visible = true
          O.ZIndex = 8
          local b = l7(O, (h.Animaciones and "ON") or "OFF", function()
            R7("Animaciones", not h.Animaciones)
            return (h.Animaciones and "ON") or "OFF"
          end)
          local function O()
            o(h.Animaciones == true)
            b.Text = (h.Animaciones and "ON") or "OFF"
          end
          Y.Animaciones = O
          O()
          _G.__CrystalTrackConn(F.CharacterAdded:Connect(function()
            if not h.Animaciones or not _G.__CrystalAnimationPreset then
              return
            end
            task.wait(0.75)
            pcall(U, _G.__CrystalAnimationPreset, false)
          end))
          if h.Animaciones and _G.__CrystalAnimationPreset then
            task.defer(function()
              task.wait(0.5)
              pcall(U, _G.__CrystalAnimationPreset, false)
            end)
          end
          W7 = k7(Instance.new("TextLabel"))
          W7.Size = UDim2.new(1, -8, 0, 30)
          W7.BackgroundTransparency = 1
          W7.LayoutOrder = 4
          W7.Text = "Usa < y > para aplicar y guardar automaticamente. El toggle permite activar o desactivar."
          W7.TextColor3 = _.textDim
          W7.TextSize = 10
          W7.Font = Enum.Font.Gotham
          W7.TextWrapped = true
          W7.TextXAlignment = Enum.TextXAlignment.Left
          W7.Parent = Y7
          local o, O = "Movement", {"Movement", "Combat", "Visual", "Animations"}
          for b, G in ipairs(O) do
            local O = k7(Instance.new("TextButton"))
            O.Name = G .. "Button"
            O.Size = UDim2.new(0.25, (M and -2) or -4, 0, w.categoryH)
            O.BackgroundColor3 = _.accentDim
            O:SetAttribute("CurtThemeRole", "AccentDim")
            O.BackgroundTransparency = ((G == o) and 0.18) or 0.32
            O.BorderSizePixel = 0
            O.Text = G
            O.TextColor3 = _.text
            O.TextSize = (M and 8) or 10
            O.Font = Enum.Font.GothamBold
            O.LayoutOrder = b
            O.Parent = C7
            N(O, 5)
            W = Instance.new("Frame")
            W.Name = "Indicator"
            W.Size = UDim2.new(0, 18, 0, 2)
            W.Position = UDim2.new(0.5, -9, 1, -2)
            W.BackgroundColor3 = _.accent
            W:SetAttribute("CurtThemeRole", "Accent")
            W.BackgroundTransparency = ((G == o) and 0.3) or 1
            W.BorderSizePixel = 0
            W.Parent = O
            O.MouseButton1Click:Connect(function()
              local b = o
              if b == G then
                return
              end
              o = G
              for w, u in pairs(A7) do
                b = w == G
                u.Visible = b
                if b then
                  u = X7[w]
                  if u then
                    u.Scale = 0.975
                    o7(u, {Scale = 1}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                  end
                end
              end
              for w, u in ipairs(C7:GetChildren()) do
                if u:IsA("TextButton") then
                  w = u.Name == (G .. "Button")
                  o7(u, {TextColor3 = _.text, BackgroundTransparency = (w and 0.16) or 0.3}, 0.18)
                  b = u:FindFirstChild("Indicator")
                  if b then
                    o7(b, {BackgroundTransparency = (w and 0.15) or 1, Size = UDim2.new(0, (w and 28) or 12, 0, 2), Position = UDim2.new(0.5, (w and -14) or -6, 1, -2)}, 0.2)
                  end
                end
              end
            end)
            O.MouseEnter:Connect(function()
              local b = o
              if b ~= G then
                o7(O, {TextColor3 = _.text, BackgroundTransparency = 0.25})
              end
            end)
            O.MouseLeave:Connect(function()
              local b = o
              if b ~= G then
                o7(O, {TextColor3 = _.text, BackgroundTransparency = 0.3})
              end
            end)
          end
          p7 = function()
            for o, o in ipairs(C7:GetChildren()) do
              if o:IsA("TextButton") then
                o.TextColor3 = _.text
              end
            end
          end
          p7()
          g7(_G.__CrystalTabPosition)
          g7 = _G.__CrystalApplyCurtVisualTheme
          if g7 then
            pcall(_G.__CrystalApplyCurtVisualTheme, G7)
          end
          local o = Instance.new("TextButton")
          k7(o)
          o.Name = "EclipseRestoreButton"
          o.Size = UDim2.new(0, 120, 0, 30)
          Z7 = _G._CrystalHub_UI_ModernMiniPos
          o.Position = (Z7 and UDim2.fromOffset(Z7.x or 6, Z7.y or 54)) or UDim2.new(0, 6, 0, 54)
          o.BackgroundColor3 = _.bgDark
          o:SetAttribute("CurtThemeRole", "BgDark")
          o.BorderSizePixel = 0
          o.Text = "vless hub"
          o.TextColor3 = _.text
          o.TextSize = 11
          o.Font = Enum.Font.GothamBlack
          o.Visible = not E.Visible
          o.ZIndex = 900
          o.Parent = p
          N(o, 8)
          d(o, Color3.fromRGB(45, 45, 45), 1.2)
          local function O(b)
            for w, w in pairs(A7) do
              if w and w.Parent then
                for G, G in ipairs(w:GetChildren()) do
                  if G:IsA("Frame") and (G:GetAttribute("CurtThemeRole") == "Row") then
                    for w, u in ipairs(G:GetChildren()) do
                      if ((u:IsA("TextLabel") or u:IsA("TextButton")) and (u.TextXAlignment == Enum.TextXAlignment.Left)) and (u.Text ~= "") then
                        if G.Name == "HalloweenModeRow" then
                          u.Text = "\240\159\142\131 Halloween Mode \240\159\142\131"
                          u:SetAttribute("HalloweenBaseText", nil)
                        else
                          w = u:GetAttribute("HalloweenBaseText")
                          if b then
                            if not w then
                              w = u.Text
                              u:SetAttribute("HalloweenBaseText", w)
                            else
                            end
                            u.Text = "\240\159\142\131 " .. tostring(w)
                          elseif w then
                            u.Text = tostring(w)
                            u:SetAttribute("HalloweenBaseText", nil)
                          end
                        end
                        break
                      end
                    end
                  end
                end
              end
            end
          end
          local function b(w)
            local G = h["Halloween Mode"] == true
            for u, U in pairs((G and X) or V(w)) do
              _[u] = U
            end
            _G.__CrystalHalloweenMode = G
            _G.__CrystalCurtAccent = _.accent
            _G.__CrystalThemeAccent = _.accent
            if _G.__CrystalApplyAutoStealBarTheme then
              pcall(_G.__CrystalApplyAutoStealBarTheme, w)
            end
            O7.BackgroundColor3 = _.bg
            local u = (G and "rbxassetid://97760254196945") or (b7[tonumber(w) or 1] or b7[1])
            M7.Image = u
            if T7 then
              T7.Image = u
            end
            w = M7:FindFirstChildOfClass("UICorner")
            if G then
              M7.Size = UDim2.fromScale(1, 1)
              M7.Position = UDim2.fromOffset(0, 0)
              if w then
                w.CornerRadius = UDim.new(0, 12)
              end
              F7.Transparency = 1
              if u7 then
                u7.Visible = false
              end
            else
              M7.Size = UDim2.new(1, -2, 1, -2)
              M7.Position = UDim2.fromOffset(1, 1)
              if w then
                w.CornerRadius = UDim.new(0, 11)
              end
              F7.Transparency = 1
              if u7 then
                u7.Visible = U7 ~= "GUI 1"
              end
            end
            h7.BackgroundColor3 = _.bgDark
            h7:SetAttribute("CurtThemeRole", "BgDark")
            z7.BackgroundColor3 = _.bgDark
            z7:SetAttribute("CurtThemeRole", "BgDark")
            o.BackgroundColor3 = _.bgDark
            o:SetAttribute("CurtThemeRole", "BgDark")
            K7.BackgroundColor3 = _.accent
            K7:SetAttribute("CurtThemeRole", "Accent")
            e7.BackgroundColor3 = _.bgDark
            e7:SetAttribute("CurtThemeRole", "BgDark")
            w = {"UnifiedPanelWhiteOutline", "UnifiedPanelWhiteGlow"}
            for U, W in ipairs(w) do
              U = O7:FindFirstChild(W)
              if U then
                U:Destroy()
              end
            end
            if n7 then
              n7.ImageColor3 = _.accent
            end
            if r7 then
              r7.ImageColor3 = _.accent
            end
            for U, W in ipairs(O7:GetDescendants()) do
              if W:IsA("GuiObject") then
                U = W:GetAttribute("CurtThemeRole")
                if U == "AccentDim" then
                  W.BackgroundColor3 = _.accentDim
                elseif U == "Accent" then
                  W.BackgroundColor3 = _.accent
                elseif U == "Row" then
                  W.BackgroundColor3 = _.row
                elseif U == "BgDark" then
                  W.BackgroundColor3 = _.bgDark
                elseif U == "SwitchKnob" then
                  W.BackgroundColor3 = _.text
                end
              end
              if (W:IsA("TextLabel") or W:IsA("TextButton")) or W:IsA("TextBox") then
                if (W == m) or (W == P) then
                  W.TextColor3 = ((W == m) and _.text) or _.textDim
                elseif W ~= z7 then
                  local U, n = i[48](281701876, 0), pcall
                  U = i[48](U, 504697786)
                  local function U()
                    W.TextColor3 = _.text
                  end
                  n(U)
                end
                if W.Name == "SectionLabel" then
                  local U = i[48](405807548, 0)
                  w = U
                  u = pcall
                  U = i:rQ((i:HQ(3939998420, w) + i:HQ(3939998420, 233123011)) + (i:HQ(709937752, (i[79](w, 233123011))) + i:HQ(3939998421, (i[48](w, 233123011)))))
                  local function w()
                    W.TextColor3 = _.textDim
                  end
                  u(w)
                end
                if W:IsA("TextBox") and W:GetAttribute("CurtThemeAccentInput") then
                  W.BackgroundColor3 = _.accentDim
                  W:SetAttribute("CurtThemeRole", "AccentDim")
                end
              end
              if W:IsA("Frame") then
                if (W.Name == "Indicator") or (W.Name == "ActiveMarker") then
                  W.BackgroundColor3 = _.accent
                  W:SetAttribute("CurtThemeRole", "Accent")
                elseif W:GetAttribute("CrystalButtonThemeControl") then
                  W.BackgroundColor3 = _.row
                  W:SetAttribute("CurtThemeRole", "Row")
                elseif W.Name == "BottomTabs" then
                  W.BackgroundColor3 = _.bgDark
                  W:SetAttribute("CurtThemeRole", "BgDark")
                end
              end
              if W:IsA("TextButton") then
                if W.Parent == C7 then
                  W.BackgroundColor3 = _.accentDim
                  W:SetAttribute("CurtThemeRole", "AccentDim")
                elseif ((W ~= z7) and (W ~= o)) and (W.Text ~= "") then
                  if W.BackgroundTransparency < 0.95 then
                    W.BackgroundColor3 = (W:GetAttribute("CrystalButtonThemeControl") and _.row) or _.accentDim
                  end
                end
              end
              if W:IsA("UIStroke") then
                if W.Parent and (W.Parent.Name == "BottomTabs") then
                  W.Color = _.divider
                elseif W.Parent and W.Parent:IsA("GuiObject") then
                  if W.Parent:GetAttribute("CrystalButtonThemeControl") then
                    W.Color = _.divider
                  elseif ((W.Parent == z7) or (W.Parent == o)) or (W.Parent == h7) then
                    W.Color = _.divider
                  else
                    W.Color = _.accentDim
                  end
                end
              end
            end
            for w, w in pairs(Y) do
              pcall(w)
            end
            O(G)
            u = O7:FindFirstChild("HalloweenModeLabel", true)
            if u then
              u.Text = "\240\159\142\131 Halloween Mode \240\159\142\131"
              u.TextColor3 = (G and Color3.fromRGB(255, 174, 56)) or Color3.fromRGB(255, 145, 35)
              u.TextStrokeColor3 = Color3.fromRGB(70, 24, 0)
              u.TextStrokeTransparency = (G and 0.35) or 0.55
            end
            if p7 then
              p7()
            end
            if _G.__refreshSpeedBillboards then
              pcall(_G.__refreshSpeedBillboards)
            end
            if _G.__CrystalRefreshQuickButtonTheme then
              pcall(_G.__CrystalRefreshQuickButtonTheme)
            end
          end
          _G.__CrystalApplyCurtVisualTheme = b
          b(G7)
          t(o, o)
          local function O()
            if _G.__setPanelVisible then
              _G.__setPanelVisible(false)
            else
              E.Visible = false
            end
          end
          z7.MouseButton1Click:Connect(O)
          local function O()
            if _G.__setPanelVisible then
              _G.__setPanelVisible(true)
            else
              E.Visible = true
            end
          end
          o.MouseButton1Click:Connect(O)
          local function O()
            _G.__CrystalPanelVisible = E.Visible
            h["Toggle UI"] = E.Visible
            o.Visible = not E.Visible
            w7()
          end
          E:GetPropertyChangedSignal("Visible"):Connect(O)
          local function O()
            local b = workspace.CurrentCamera
            if not b then
              return
            end
            local w = b.ViewportSize
            if (w.X <= 0) or (w.Y <= 0) then
              return
            end
            local G, u = math.max(1, w.X - 12), math.max(1, w.Y - 60)
            if M then
              E.Size = UDim2.new(0, math.min(G, math.clamp(math.floor(w.X * 0.52), 205, 255)), 0, math.min(u, math.clamp(math.floor(w.Y * 0.82), 420, 560)))
            else
              E.Size = UDim2.new(0, math.min(310, G), 0, math.min(620, u))
            end
            G = {E, o}
            for o, o in ipairs(G) do
              b = o.Position
              B(o, b.X.Scale, b.X.Offset, b.Y.Scale, b.Y.Offset)
            end
          end
          O()
          local o
          local function M()
            local b = o
            if b then
              o:Disconnect()
              o = nil
            end
            b = workspace.CurrentCamera
            if b then
              local w = i[48](284386491, 0)
              local G = w
              local u = _G
              w = i[48](G, 371395044)
              local G, U = u.__CrystalTrackConn, b:GetPropertyChangedSignal("ViewportSize")
              w = i:rQ((i:HQ(1871641592, w) + i:HQ(1871641592, 37886055)) + (i:HQ(551684112, (i[79](w, 37886055))) + i:HQ(1871641593, (i[48](w, 37886055)))))
              local function b()
                task.defer(O)
              end
              o = G(U:Connect(b))
            end
            task.defer(O)
          end
          _G.__CrystalTrackConn(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(M))
          M()
        end)()
        _G.__CrystalRegisterThemeRoot(p)
        task.spawn(function()
          local o = i[48](532128025, 0)
          local O = o
          local M
          M, o = Instance.new, i[48](O, 478189319)
          local O = M("Frame")
          O.Size = UDim2.new(1, 0, 1, 0)
          O.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
          O.BackgroundTransparency = 1
          O.BorderSizePixel = 0
          o = i:rQ((i:HQ(285160522, o) + i:HQ(285160522, 467763385)) + (i:HQ(3724646252, (i[79](o, 467763385))) + i:HQ(285160523, (i[48](o, 467763385)))))
          O.ZIndex = 10000
          O.Parent = p
          c:Create(O, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.45}):Play()
          task.wait(0.12)
          c:Create(O, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
          task.wait(0.3)
          pcall(function()
            O:Destroy()
          end)
        end)
        ;(function()
          local c = i[48](188392094, 0)
          local o = c
          local O
          c = i:rQ((i:HQ(395786935, o) + i:HQ(395786935, 496029600)) + (i:HQ(3503393426, (i[79](o, 496029600))) + i:HQ(395786936, (i[48](o, 496029600)))))
          O = function(c)
            if not c then
              return "..."
            end
            return D7(c)
          end
          local function c(o, M)
            local b = R and S
            if b then
              local w, G = S, (o.UserInputType == Enum.UserInputType.Touch) or (o.UserInputType == Enum.UserInputType.MouseButton1)
              local u = (i7(o) or G) or s7(o)
              if u then
                local u = (G or (o.KeyCode == Enum.KeyCode.Escape)) or (I7(o) and (w ~= "Toggle UI"))
                if u then
                  g[w] = nil
                  local G = (((R.Size.X.Offset == 42) or R:GetAttribute("MiniUIBind")) and "-") or "BIND"
                  R.Text = G
                else
                  local G = s7(o)
                  if G then
                    local G = y7(o)
                    g[w] = G
                    local U = R
                    U.Text = c7[G] or G
                  else
                    g[w] = o.KeyCode
                    local G = R
                    G.Text = O(o.KeyCode)
                  end
                end
                u = R
                u.BackgroundColor3 = Color3.fromRGB(210, 230, 250)
                u = R
                u.TextColor3 = Color3.fromRGB(80, 130, 200)
                R, S = nil, nil
                w7()
                if w and Y[w] then
                  Y[w]()
                end
                u = f[w]
                if u and u.bindCircle then
                  local G = g[w]
                  u.bindCircle.Text = (G and O(G)) or "-"
                end
                return
              end
            end
            if D:GetFocusedTextBox() then
              return
            end
            b = g["Carry Speed"]
            local O, w = (b ~= nil) and ((i7(o) and (o.KeyCode == b)) or (s7(o) and (y7(o) == b))), g.SelectNormalMode
            b = (w ~= nil) and ((i7(o) and (o.KeyCode == w)) or (s7(o) and (y7(o) == w)))
            w = b and (J ~= "Normal")
            if w then
              local G = i[48](312077527, 0)
              b = G
              local u = FeatureToggles.SelectNormalMode
              G = i:rQ((i:HQ(1510168296, b) + i:HQ(1510168296, 253509964)) + (i:HQ(1274630704, (i[79](b, 253509964))) + i:HQ(1510168297, (i[48](b, 253509964)))))
              if u then
                FeatureToggles.SelectNormalMode()
              end
              pcall(function()
                if _G.__refreshSpeedBoost then
                  _G.__refreshSpeedBoost()
                end
              end)
              u = pcall
              local function G()
                if _G.__refreshSpeedBillboards then
                  _G.__refreshSpeedBillboards()
                end
              end
              u(G)
              w7()
              return
            end
            if O then
              w = FeatureToggles["Carry Speed"]
              if w then
                FeatureToggles["Carry Speed"]()
              else
                b = not h["Carry Speed"]
                h["Carry Speed"] = b
                e = b
                if l["Carry Speed"] then
                  l["Carry Speed"](b)
                end
                if Y["Carry Speed"] then
                  Y["Carry Speed"]()
                end
                w7()
              end
              return
            end
            b = g.Drop
            if (b ~= nil) and ((i7(o) and (o.KeyCode == b)) or (s7(o) and (y7(o) == b))) then
              if FeatureToggles.Drop then
                FeatureToggles.Drop("keybind")
              end
              return
            end
            if M and not L[o.UserInputType] then
              return
            end
            if i7(o) then
              for O, w in pairs(g) do
                if o.KeyCode == w then
                  if FeatureToggles[O] then
                    if O == "Drop" then
                      FeatureToggles[O]("keybind")
                    else
                      FeatureToggles[O]()
                    end
                  else
                    b = not h[O]
                    h[O] = b
                    w7()
                    if l[O] then
                      l[O](b)
                    end
                    if Y[O] then
                      Y[O]()
                    end
                  end
                end
              end
            end
            if s7(o) then
              b = y7(o)
              for o, O in pairs(g) do
                if O == b then
                  if FeatureToggles[o] then
                    if o == "Drop" then
                      FeatureToggles[o]("keybind")
                    else
                      FeatureToggles[o]()
                    end
                  else
                    M = not h[o]
                    h[o] = M
                    w7()
                    if l[o] then
                      l[o](M)
                    end
                    if Y[o] then
                      Y[o]()
                    end
                  end
                end
              end
            end
          end
          _G.__CrystalTrackConn(D.InputBegan:Connect(c))
        end)()
        ;(function()
          local c = i[48](287613493, 0)
          local o = c
          local O = _G.__CrystalInfJumpState or {}
          _G.__CrystalInfJumpState = O
          O.conn = O.conn or nil
          O.lastJumpTime = O.lastJumpTime or 0
          O.manualLock = false
          c = i:rQ((i:HQ(828862996, o) + i:HQ(828862996, 219482506)) + (i:HQ(2637241304, (i[79](o, 219482506))) + i:HQ(828862997, (i[48](o, 219482506)))))
          local function o()
            return false
          end
          local M
          c = i[48](c, 19314724)
          M = function()
            local c = i[48](366076986, 0)
            local b = c
            if ((_G.__CrystalInfJumpMode or "hold") ~= "manual") or O.manualLock then
              return
            end
            c = i[48](b, 196574867)
            O.manualLock = true
            b = F.Character
            local w, G = b and (b:FindFirstChildOfClass("Humanoid")), b and (b:FindFirstChild("HumanoidRootPart"))
            if not w or not G then
              O.manualLock = false
              return
            end
            b = tick()
            if (b - O.lastJumpTime) < 0.08 then
              O.manualLock = false
              return
            end
            O.lastJumpTime = b
            local b, w, u
            b, w, u, c = Vector3.new, G.Velocity.X, G.Velocity, i:rQ((i:HQ(362346448, c) + i:HQ(362346448, 72878589)) + (i:HQ(3570274400, (i[79](c, 72878589))) + i:HQ(362346449, (i[48](c, 72878589)))))
            G.Velocity = b(w, 55, u.Z)
            task.delay(0.14, function()
              O.manualLock = false
            end)
          end
          _G.__CrystalTrackConn(D.InputBegan:Connect(function(c, b)
            if b then
              return
            end
            if (c.KeyCode == Enum.KeyCode.Space) or (c.KeyCode == Enum.KeyCode.ButtonA) then
              if (_G.__CrystalInfJumpMode or "hold") == "manual" then
                M()
                return
              end
              if not o() then
                O.lastJumpTime = tick() - 0.08
              end
            end
          end))
          function startInfJump()
            local c = i[48](517361535, 0)
            local M = c
            c = i:rQ(M + 456562747)
            if O.conn then
              O.conn:Disconnect()
              O.conn = nil
            end
            M = nil
            M, c = s.Heartbeat, i:rQ(c - 290619315)
            O.conn = M:Connect(function()
              local c = i[48](222230189, 0)
              local s = c
              c = i:rQ(s + 365822608)
              if not h["Inf Jump"] or ((_G.__CrystalInfJumpMode or "hold") ~= "hold") then
                return
              end
              s = o()
              c = i:rQ(c - 218791554)
              if s then
                return
              end
              pcall(function()
                local c = F.Character
                if not c then
                  return
                end
                local s = c:FindFirstChildOfClass("Humanoid")
                if not s then
                  return
                end
                local o = c:FindFirstChild("HumanoidRootPart")
                if not o then
                  return
                end
                c = tick()
                if ((D:IsKeyDown(Enum.KeyCode.Space) or D:IsKeyDown(Enum.KeyCode.ButtonA)) or (s.Jump == true)) and ((c - O.lastJumpTime) >= 0.08) then
                  O.lastJumpTime = c
                  local D = o.Velocity
                  o.Velocity = Vector3.new(D.X, 55, D.Z)
                end
              end)
            end)
          end
          function stopInfJump()
            if O.conn then
              O.conn:Disconnect()
              O.conn = nil
            end
          end
          _G.__CrystalTrackStopper(stopInfJump)
          l["Inf Jump"] = function(D)
            if D and ((_G.__CrystalInfJumpMode or "hold") == "hold") then
              startInfJump()
            else
              stopInfJump()
            end
          end
          if h["Inf Jump"] and ((_G.__CrystalInfJumpMode or "hold") == "hold") then
            startInfJump()
          end
          _G.__CrystalTrackConn(F.CharacterAdded:Connect(function()
            if h["Inf Jump"] and ((_G.__CrystalInfJumpMode or "hold") == "hold") then
              task.wait(0.5)
              stopInfJump()
              startInfJump()
            end
          end))
        end)()
        _G.CrystalFonts = _G.CrystalFonts or {}
        _G.CrystalFonts.orig = _G.CrystalFonts.orig or {}
        _G.CrystalFonts.conns = _G.CrystalFonts.conns or {}
        _G.CrystalFonts.size = _G.CrystalFonts.size or {}
        _G.CrystalFontChoice = _G.CrystalFontChoice or "Default"
        _G.CrystalFonts.WEIGHT_LABEL = {Thin = "Thin", ExtraLight = "ExLight", Light = "Light", Regular = "", Medium = "Medium", SemiBold = "SemiBold", Bold = "Bold", ExtraBold = "ExBold", Heavy = "Heavy"}
        local function D()
          local c = _G.CrystalFonts
          if c.cache then
            return c.cache
          end
          local s, o, O = {{key = "Default", label = "Default", font = nil}}, {}, {}
          for M, b in ipairs(Enum.Font:GetEnumItems()) do
            if b.Name ~= "Unknown" then
              local w = i[48](392221020, 0)
              M = w
              local G
              G, w = pcall, i:rQ(M + 2782265)
              local M, w = G(function()
                return Font.fromEnum(b)
              end)
              if ((M and w) and w.Family) and not o[w.Family] then
                o[w.Family] = true
                G = (tostring(w.Family):match("([^/\\]+)%.json$") or tostring(w.Family):match("([^/\\]+)$")) or b.Name
                O[#O + 1] = {family = w.Family, nice = G}
              end
            end
          end
          for M, b in ipairs(O) do
            for O, w in ipairs(Enum.FontWeight:GetEnumItems()) do
              M = {false, true}
              for G, u in ipairs(M) do
                local M = i[48](89952004, 0)
                o = nil
                o, M = pcall, i[48](M, 409442186)
                O, G = o(function()
                  return Font.new(b.family, w, (u and Enum.FontStyle.Italic) or Enum.FontStyle.Normal)
                end)
                if O and G then
                  local o, O = c.WEIGHT_LABEL[w.Name] or w.Name, b.nice
                  O = if u then (if o ~= "" then O .. (" " .. o) else O) .. " Italic" else if o ~= "" then O .. (" " .. o) else O
                  local o, M = #s + 1, {}
                  M.key, M.label, M.font, s[o] = b.family .. ("|" .. (w.Name .. ("|" .. ((u and "i") or "n")))), O, G, M
                end
              end
            end
          end
          c.cache = s
          return s
        end
        _G.CrystalFonts.list = D
        local function c(s)
          for o, o in ipairs(_G.CrystalFonts.list()) do
            if o.key == s then
              return o
            end
          end
          return nil
        end
        _G.CrystalFonts.byKey = c
        local function s()
          local o, O = {}, ipairs
          local M = {game:GetService("CoreGui"), F.PlayerGui}
          for b, w in O(M) do
            local G = i[48](113221329, 0)
            b = G
            local u
            u, G = pcall, i:rQ((i:HQ(589007346, b) + i:HQ(589007346, 490381590)) + (i:HQ(3705959951, (i[79](b, 490381590))) + i:HQ(3705959949, (i[89](b, 490381590)))))
            u(function()
              local b = w:FindFirstChild("EclipseHub")
              if b then
                o[#o + 1] = b
              end
            end)
          end
          M = F.Character
          O = M and (M:FindFirstChild("Head"))
          if O then
            M = {"Green22sBB", "22sSpeedBill", "CrystalHubOverhead", "22sHubOverhead"}
            for b, w in ipairs(M) do
              b = O:FindFirstChild(w)
              if b then
                o[#o + 1] = b
              end
            end
          end
          return o
        end
        _G.CrystalFonts.roots = s
        local function o(O)
          local M = i[48](433175923, 0)
          local b = M
          local w = O.Text
          if w == nil then
            return false
          end
          O = string.match(w, "%w")
          M = i[48](b, 466916765)
          if O then
            return false
          end
          O = nil
          O, M = pcall, i:rQ((i:HQ(1444362813, M) + i:HQ(1444362813, 208871579)) + (i:HQ(1406241670, (i[79](M, 208871579))) + i:HQ(1444362814, (i[48](M, 208871579)))))
          local M, b = O(function()
            return utf8.len(w)
          end)
          return (M and (b ~= nil)) and (b <= 1)
        end
        _G.CrystalFonts.isGlyph = o
        local function O(M, b)
          local w = i[48](167281286, 0)
          local G = w
          local u
          u, w = M:IsA("TextLabel"), i[48](G, 218724481)
          if not ((u or M:IsA("TextButton")) or M:IsA("TextBox")) then
            return
          end
          if M:GetAttribute("CrystalFontLock") then
            return
          end
          local G = _G.CrystalFonts
          w = i:rQ((i:HQ(273322478, w) + i:HQ(273322478, 407460901)) + (i:HQ(4021644819, (i[79](w, 407460901))) + i:HQ(4021644817, (i[89](w, 407460901)))))
          if G.orig[M] == nil then
            G.orig[M] = M.FontFace
            G.size[M] = M.TextSize
          end
          if G.isGlyph(M) then
            b = nil
          else
          end
          pcall(function()
            M.FontFace = b or G.orig[M]
            if G.size[M] then
              M.TextSize = G.size[M]
            end
          end)
        end
        _G.CrystalFonts.applyOne = O
        _G.CrystalFonts.MIN_SIZE = 7
        _G.CrystalFonts.MARGIN = 8
        _G.CrystalFonts.MAX_GROW = 1.35
        o, C, O = _G.CrystalFonts, _G.CrystalFonts.tconns
        if C then
          O = C
        else
          D, c = setmetatable, {__mode = "k"}
          O = D({}, c)
        end
        o.tconns = O
        s, T, C = _G.CrystalFonts, _G.CrystalFonts.lastLen
        if T then
          C = T
        else
          o, I = setmetatable, {__mode = "k"}
          C = o({}, I)
        end
        s.lastLen = C
        local function c()
          local o = _G.CrystalFonts
          if o.gtbp == nil then
            local M = i[48](326570683, 0)
            local b = M
            local w
            w, M = pcall, i:rQ((i:HQ(477352163, b) + i:HQ(477352163, 147586597)) + (i:HQ(3340262970, (i[79](b, 147586597))) + i:HQ(477352164, (i[48](b, 147586597)))))
            local M, b = w(function()
              return Instance.new("GetTextBoundsParams")
            end)
            o.gtbp = (M and b) or false
          end
          return o.gtbp or nil
        end
        _G.CrystalFonts.params = c
        I, c, s = _G.CrystalFonts, _G.CrystalFonts.m
        if c then
          s = c
        else
          T, y = setmetatable, {__mode = "k"}
          s = T({}, y)
        end
        I.m = s
        D, y, T = _G.CrystalFonts, _G.CrystalFonts.aconns
        if y then
          T = y
        else
          O, s = setmetatable, {__mode = "k"}
          T = O({}, s)
        end
        D.aconns = T
        _G.CrystalFonts.stamp = _G.CrystalFonts.stamp or 0
        local function I(D)
          local c = _G.CrystalFonts
          local s = c.m[D]
          if not s then
            return
          end
          if c.isGlyph(D) then
            if D.TextSize ~= s.base then
              D.TextSize = s.base
            end
            return
          end
          local y, o = s.s0, D.AbsoluteSize
          if (o.X > 1) and (o.Y > 1) then
            local O = D.AutomaticSize
            y = if not ((O == Enum.AutomaticSize.Y) or (O == Enum.AutomaticSize.XY)) then math.min(y, math.max(o.Y - 2, 1) / s.by) else y
            y = if not (((O == Enum.AutomaticSize.X) or (O == Enum.AutomaticSize.XY)) or s.wrapped) then math.min(y, math.max(o.X - math.min(c.MARGIN, o.X * 0.08), 1) / s.bx) else y
          else
          end
          o = math.floor((s.base * y) + 0.5)
          o = if o < c.MIN_SIZE then c.MIN_SIZE else o
          if D.TextSize ~= o then
            D.TextSize = o
          end
        end
        _G.CrystalFonts.reclamp = I
        local function I(D)
          local c = i[48](36590387, 0)
          local s
          s, c = _G, i[48](c, 146582765)
          local y = s.CrystalFonts
          s = y.current()
          if not s then
            return false
          end
          local o = y.params()
          if not o then
            return false
          end
          local O
          O, c = y.tsvc, i[48](c, 296225953)
          y.tsvc = O or game:GetService("TextService")
          O = y.size[D]
          if not O then
            O = D.TextSize
            y.size[D] = O
          else
          end
          local c = D.Text
          if (c == nil) or (c == "") then
            y.m[D] = {base = O, bx = 1, by = 1, s0 = 1, stamp = y.stamp, text = c}
            return true
          end
          local M = D.TextWrapped and (D.AbsoluteSize.X > 1)
          o.Text = c
          o.Size = O
          o.Width = (M and D.AbsoluteSize.X) or 0
          o.Font = s
          local b, w = pcall(function()
            return y.tsvc:GetTextBoundsAsync(o)
          end)
          if not (((b and w) and (w.X > 0)) and (w.Y > 0)) then
            return false
          end
          s, b = 1, y.orig[D]
          if b then
            local G = i[48](404039832, 0)
            o.Font = b
            G = i:rQ((i:HQ(2281643095, G) + i:HQ(2281643095, 364713319)) + (i:HQ(4026648402, (i[79](G, 364713319))) + i:HQ(2281643096, (i[48](G, 364713319)))))
            local b
            b, G = pcall, i[48](G, 474397211)
            local G, T = b(function()
              return y.tsvc:GetTextBoundsAsync(o)
            end)
            s = if ((G and T) and (T.X > 0)) and (T.Y > 0) then (M and (T.Y / w.Y)) or (T.X / w.X) else s
          else
          end
          s = if s > y.MAX_GROW then y.MAX_GROW else s
          y.m[D] = {base = O, bx = w.X, by = w.Y, s0 = s, wrapped = M, stamp = y.stamp, text = c}
          return true
        end
        _G.CrystalFonts.measure = I
        local function I(D)
          local c = _G.CrystalFonts
          if not c.current() then
            return
          end
          if D:GetAttribute("CrystalFontLock") then
            return
          end
          if not ((D:IsA("TextLabel") or D:IsA("TextButton")) or D:IsA("TextBox")) then
            return
          end
          if D.TextScaled then
            return
          end
          if c.isGlyph(D) then
            return true
          end
          local s = c.m[D]
          if not ((s and (s.stamp == c.stamp)) and (s.text == D.Text)) then
            if not c.measure(D) then
              return false
            end
          end
          c.reclamp(D)
          return true
        end
        _G.CrystalFonts.fitOne = I
        local function I(D)
          local c = i[48](86586189, 0)
          local s = c
          local y = _G.CrystalFonts
          local o = y.aconns
          c = i:rQ(s + 102634131)
          if o[D] then
            return
          end
          c = i:rQ(c - 99985492)
          y.aconns[D] = D:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            local c = _G.CrystalFonts
            if not c.current() then
              return
            end
            if c.m[D] then
              c.reclamp(D)
            else
              pcall(c.fitOne, D)
            end
          end)
          if y.tconns[D] then
            return
          end
          y.tconns[D] = D:GetPropertyChangedSignal("Text"):Connect(function()
            local c = _G.CrystalFonts
            if not c.current() then
              return
            end
            if c.lastLen[D] == #D.Text then
              return
            end
            c.lastLen[D] = #D.Text
            pcall(c.applyOne, D, c.current())
            pcall(c.fitOne, D)
          end)
        end
        _G.CrystalFonts.watch = I
        local function I(D)
          local c = i[48](351160704, 0)
          local s = c
          local y, o = _G.CrystalFonts
          o, c = (y.fitToken or 0) + 1, i:rQ(s + 469442596)
          y.fitToken = o
          local o = y.fitToken
          if not y.current() then
            return
          end
          y.tsvc = y.tsvc or game:GetService("TextService")
          s = nil
          s, c = task, i:rQ(c - 402456670)
          s.spawn(function()
            local c = {}
            for s, s in ipairs(y.roots()) do
              for O, O in ipairs(s:GetDescendants()) do
                if (((O:IsA("TextLabel") or O:IsA("TextButton")) or O:IsA("TextBox")) and not O.TextScaled) and not O:GetAttribute("CrystalFontLock") then
                  c[#c + 1] = O
                end
              end
            end
            for s, s in ipairs(c) do
              if y.fitToken ~= o then
                return
              end
              if s.Parent then
                y.fitOne(s)
                y.lastLen[s] = #s.Text
                y.watch(s)
              end
            end
            D = (tonumber(D) or 0) + 1
            c = D < 3
            if c then
              local c = i[48](236198229, 0)
              local s = c
              local O = task.delay
              c = i:rQ((i:HQ(1348814969, s) + i:HQ(1348814969, 358369785)) + (i:HQ(2946152328, (i[79](358369785, s))) + i:HQ(2946152326, (i[89](358369785, s)))))
              s = D == 1
              c = i[48](c, 19898869)
              O((s and 0.35) or 1.5, function()
                if y.fitToken ~= o then
                  return
                end
                y.stamp = y.stamp + 1
                y.fit(D)
              end)
            end
          end)
        end
        _G.CrystalFonts.fit = I
        local function I()
          local D = _G.CrystalFontChoice
          if not D or (D == "Default") then
            return nil
          end
          local c = _G.CrystalFonts.byKey(D)
          return (c and c.font) or nil
        end
        _G.CrystalFonts.current = I
        local function I()
          local D = _G.CrystalFonts
          local c = D.current()
          for s, s in ipairs(D.roots()) do
            D.applyOne(s, c)
            for y, y in ipairs(s:GetDescendants()) do
              D.applyOne(y, c)
            end
          end
          D.fit()
        end
        _G.CrystalFonts.applyAll = I
        local function I()
          local D = _G.CrystalFonts
          for c, s in ipairs(D.conns) do
            local y = i[48](534171114, 0)
            c = y
            local o
            o, y = pcall, i:rQ((i:HQ(3923120234, c) + i:HQ(3923120234, 21377779)) + (i:HQ(743694124, (i[79](c, 21377779))) + i:HQ(3923120235, (i[48](c, 21377779)))))
            o(function()
              s:Disconnect()
            end)
          end
          D.conns = {}
          for c, c in ipairs(D.roots()) do
            local s = i[48](55894888, 0)
            local y, o = D.conns, D.conns
            s = i:rQ(s + 254802357)
            local function s(O)
              if _G.CrystalFontChoice == "Default" then
                return
              end
              D.applyOne(O, D.current())
              pcall(D.fitOne, O)
              pcall(D.watch, O)
            end
            y[#o + 1] = c.DescendantAdded:Connect(s)
          end
        end
        _G.CrystalFonts.hook = I
        local function I(D, c)
          local s = i[48](268622761, 0)
          local y = s
          _G.CrystalFontChoice = D or "Default"
          local D, o
          D, o, s = _G.CrystalFonts, _G.CrystalFonts, i:rQ(y + 289061652)
          D.stamp = (o.stamp or 0) + 1
          D = nil
          D, s = _G.CrystalFonts.applyAll, i:rQ(s + 17709382)
          D()
          _G.CrystalFonts.hook()
          pcall(function()
            if type(_G.__refreshSpeedBillboards) == "function" then
              local D = _G.CrystalFonts
              local s = (D.current and D.current()) or nil
              for y, o in ipairs(game:GetService("Players"):GetPlayers()) do
                y = o.Character
                o = y and (y:FindFirstChild("Head"))
                if o then
                  y = {"Green22sBB", "GreenDuelsBB", "22sSpeedBill"}
                  for O, M in ipairs(y) do
                    O = o:FindFirstChild(M)
                    if O then
                      for y, y in ipairs(O:GetChildren()) do
                        if y:IsA("TextLabel") then
                          D.applyOne(y, s)
                        end
                      end
                    end
                  end
                end
              end
            end
          end)
          if not c and w7 then
            pcall(w7)
          end
        end
        _G.CrystalFonts.set = I
        task.spawn(function()
          pcall(_G.CrystalFonts.list)
        end)
        if not _G.CrystalFonts.charConn then
          _G.CrystalFonts.charConn = F.CharacterAdded:Connect(function()
            local I = i[48](219322208, 0)
            local D = I
            local c = task
            I = i:rQ(D + 263773725)
            D = c.delay
            I = i:rQ(I + 99992970)
            D(1.5, function()
              if _G.CrystalFontChoice == "Default" then
                return
              end
              pcall(_G.CrystalFonts.applyAll)
              pcall(_G.CrystalFonts.hook)
            end)
          end)
        end
        p.Enabled = true
        task.defer(function()
          local I = {"FPS Boost", "Anti Lag", "Optimizer"}
          for D, c in ipairs(I) do
            if h[c] and l[c] then
              local I = i[48](434455339, 0)
              D = I
              local s
              s, I = pcall, i:rQ((i:HQ(82207982, D) + i:HQ(82207982, 127930954)) + (i:HQ(4212759315, (i[79](D, 127930954))) + i:HQ(4212759313, (i[89](D, 127930954)))))
              s(function()
                l[c](true)
              end)
            end
          end
        end)
      end
    end
  end
end,
[48] = bit32.bxor,
[79] = bit32.bor,
[89] = bit32.band,
[92] = unpack,
[93] = table.pack,
[98] = bit32.lshift,
["HQ"] = function(i, I, D)
  local c = i[89]
  I, D = c(I, 4294967295), c(D, 4294967295)
  local s, y = c(I, 65535), i[115]
  local o, O, F = y(I, 16), c(D, 65535), y(D, 16)
  y = c((s * O) + i[98](c((s * F) + (o * O), 65535), 16), 4294967295)
  o = nil
  repeat
    s = y % 4294967296
    if s ~= s then
      o = 0
      break
    end
    o = s - (s % 1)
  until true
  return o
end,
["gQ"] = function(i, I)
  return i[92](I, 1, I.n)
end,
["rQ"] = function(i, i)
  i %= 4294967296
  if i ~= i then
    return 0
  end
  return i - (i % 1)
end,
["yQ"] = function(i, I, D, ...)
  local c = i[93](...)
  i[120](c, 1, c.n, D + 1, I)
end,
}
return ctx[16](ctx)({}, {})

end
return initializeModule()()