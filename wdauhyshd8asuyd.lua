local print = function() end
local warn  = function() end
do
    local HS = game:GetService("HttpService")
    local FILE = "HazHub.json"
    local data
    local function load()
        if data then return data end
        data = {}
        if readfile then
            pcall(function()
                local raw = readfile(FILE)
                local t = HS:JSONDecode(raw)
                if type(t) == "table" then data = t end
            end)
        end
        return data
    end
    _G.HubCfg = {
        get = function(section)
            local d = load()
            if type(d[section]) ~= "table" then d[section] = {} end
            return d[section]
        end,
        save = function()
            if not writefile then return end
            pcall(function() writefile(FILE, HS:JSONEncode(load())) end)
        end,
    }
end

if not _G.HazhubUI then
    local UI = {}
    local _Players = game:GetService("Players")
    local _UIS = game:GetService("UserInputService")
    local _TS = game:GetService("TweenService")
    local _RS = game:GetService("RunService")

    UI.C = {
        BG      = Color3.fromRGB(16, 8, 28),
        PANEL   = Color3.fromRGB(24, 12, 40),
        ROW     = Color3.fromRGB(36, 18, 55),
        ROW_HI  = Color3.fromRGB(48, 24, 72),
        BTN     = Color3.fromRGB(42, 20, 65),
        BTN_ON  = Color3.fromRGB(148, 64, 255),
        ACCENT  = Color3.fromRGB(148, 64, 255),
        ACCENT2 = Color3.fromRGB(200, 120, 255),
        TRACK   = Color3.fromRGB(40, 20, 60),
        TEXT    = Color3.fromRGB(240, 230, 255),
        MUTED   = Color3.fromRGB(170, 140, 200),
        DANGER  = Color3.fromRGB(230, 70, 90),
        STROKE  = Color3.fromRGB(80, 40, 120),
    }
    UI.FONT  = Enum.Font.GothamMedium
    UI.FONTB = Enum.Font.GothamBold
    UI.FONTK = Enum.Font.GothamBlack
    UI.ROW_H = 44
    UI.BTN_H = 26
    UI.PAD   = 8

    function UI.corner(inst, r)
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = inst; return c
    end
    function UI.stroke(inst, color, t)
        local s = Instance.new("UIStroke"); s.Color = color or UI.C.STROKE; s.Thickness = t or 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = inst; return s
    end

    function UI.screen(name, displayOrder)
        local parent = (gethui and gethui()) or game:GetService("CoreGui") or _Players.LocalPlayer:WaitForChild("PlayerGui")
        pcall(function()
            local old = parent:FindFirstChild(name); if old then old:Destroy() end
            local pg = _Players.LocalPlayer:FindFirstChild("PlayerGui")
            local old2 = pg and pg:FindFirstChild(name); if old2 then old2:Destroy() end
        end)
        local sg = Instance.new("ScreenGui")
        sg.Name = name; sg.ResetOnSpawn = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.DisplayOrder = displayOrder or 999999
        sg.IgnoreGuiInset = true
        pcall(function() sg.Parent = parent end)
        if not sg.Parent then sg.Parent = _Players.LocalPlayer:WaitForChild("PlayerGui") end
        return sg
    end

    function UI.drag(handle, target, onDrop)
        local dragging, dStart, pStart
        handle.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dStart = i.Position; pStart = target.Position
            end
        end)
        handle.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if dragging and onDrop then pcall(onDrop, target) end
                dragging = false
            end
        end)
        _UIS.InputChanged:Connect(function(i)
            if not dragging then return end
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                local d = i.Position - dStart
                target.Position = UDim2.new(pStart.X.Scale, pStart.X.Offset + d.X, pStart.Y.Scale, pStart.Y.Offset + d.Y)
            end
        end)
    end

    function UI.panel(opts)
        local f = Instance.new("Frame")
        f.Name = opts.name or "Panel"; f.Active = true; f.BorderSizePixel = 0
        f.Size = UDim2.fromOffset(opts.w or 260, opts.h or 300)
        f.Position = UDim2.fromOffset(opts.x or 200, opts.y or 200)
        f.BackgroundColor3 = UI.C.PANEL
        UI.corner(f, 10); UI.stroke(f)
        f.Parent = opts.parent

        local t = Instance.new("TextButton", f)
        t.Size = UDim2.new(1, 0, 0, 32); t.BackgroundTransparency = 1
        t.Text = opts.title or ""; t.Font = UI.FONTK; t.TextSize = 13
        t.TextColor3 = UI.C.TEXT; t.AutoButtonColor = false; t.Active = true

        local bar = Instance.new("Frame", f)
        bar.Size = UDim2.new(0, 34, 0, 2); bar.Position = UDim2.new(0.5, -17, 0, 30)
        bar.BackgroundColor3 = UI.C.ACCENT; bar.BorderSizePixel = 0
        UI.corner(bar, 2)

        if opts.closable then
            local x = Instance.new("TextButton", f)
            x.Size = UDim2.fromOffset(22, 22); x.Position = UDim2.new(1, -27, 0, 5)
            x.BackgroundColor3 = UI.C.BTN; x.Text = "x"; x.Font = UI.FONTB; x.TextSize = 12
            x.TextColor3 = UI.C.MUTED; x.AutoButtonColor = false
            UI.corner(x, 6)
            x.MouseButton1Click:Connect(function()
                if opts.onClose then opts.onClose() else f.Visible = false end
            end)
        end

        local body = Instance.new("Frame", f)
        body.Name = "Body"; body.BackgroundTransparency = 1; body.BorderSizePixel = 0
        body.Position = UDim2.new(0, 0, 0, 36); body.Size = UDim2.new(1, 0, 1, -36)

        UI.drag(t, f, opts.onDrop)
        return f, body, t
    end

    function UI.button(opts)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -2 * UI.PAD, 0, opts.h or UI.BTN_H)
        b.Position = UDim2.fromOffset(UI.PAD, opts.y or 0)
        b.BackgroundColor3 = opts.accent and UI.C.ACCENT or UI.C.BTN
        b.Text = opts.text or ""; b.Font = UI.FONTB; b.TextSize = 11
        b.TextColor3 = UI.C.TEXT; b.BorderSizePixel = 0; b.AutoButtonColor = false
        UI.corner(b, 7)
        b.Parent = opts.parent
        local function setOn(on)
            b.BackgroundColor3 = on and UI.C.BTN_ON or UI.C.BTN
        end
        if opts.on ~= nil then setOn(opts.on) end
        b.MouseEnter:Connect(function() _TS:Create(b, TweenInfo.new(0.08), { BackgroundTransparency = 0.15 }):Play() end)
        b.MouseLeave:Connect(function() _TS:Create(b, TweenInfo.new(0.08), { BackgroundTransparency = 0 }):Play() end)
        if opts.onClick then b.MouseButton1Click:Connect(opts.onClick) end
        return b, setOn
    end

    function UI.smallButton(opts)
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(opts.w or 28, opts.h or 18)
        b.Position = opts.pos or UDim2.fromOffset(opts.x or 0, opts.y or 0)
        b.BackgroundColor3 = UI.C.BTN; b.Text = opts.text or ""
        b.Font = UI.FONTB; b.TextSize = opts.textSize or 12
        b.TextColor3 = UI.C.TEXT; b.BorderSizePixel = 0; b.AutoButtonColor = false
        UI.corner(b, 6)
        b.Parent = opts.parent
        if opts.onClick then b.MouseButton1Click:Connect(opts.onClick) end
        return b
    end

    function UI.label(opts)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1; l.BorderSizePixel = 0
        l.Size = opts.size2 or UDim2.new(1, -(opts.w and 0 or 2 * UI.PAD), 0, opts.h or 18)
        if opts.w then l.Size = UDim2.fromOffset(opts.w, opts.h or 18) end
        l.Position = opts.pos or UDim2.fromOffset(opts.x or UI.PAD, opts.y or 0)
        l.Text = opts.text or ""; l.Font = opts.bold and UI.FONTB or UI.FONT
        l.TextSize = opts.size or 11
        l.TextColor3 = opts.color or (opts.muted and UI.C.MUTED or UI.C.TEXT)
        l.TextXAlignment = opts.align or Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.Parent = opts.parent
        return l
    end

    function UI.row(opts)
        local r = Instance.new("Frame")
        r.Size = UDim2.new(1, -2 * UI.PAD, 0, opts.h or UI.ROW_H)
        r.Position = UDim2.fromOffset(UI.PAD, opts.y or 0)
        r.BackgroundColor3 = UI.C.ROW; r.BorderSizePixel = 0
        UI.corner(r, 7)
        local st = UI.stroke(r, UI.C.ROW, 1)
        r.Parent = opts.parent
        local function setSelected(on)
            r.BackgroundColor3 = on and UI.C.ROW_HI or UI.C.ROW
            st.Color = on and UI.C.ACCENT or UI.C.ROW
        end
        if opts.selected then setSelected(true) end
        return r, setSelected
    end

    function UI.scroll(opts)
        local s = Instance.new("ScrollingFrame")
        s.BackgroundColor3 = UI.C.BG; s.BorderSizePixel = 0
        s.Position = UDim2.new(0, UI.PAD - 2, 0, opts.y or 0)
        s.Size = UDim2.new(1, -2 * (UI.PAD - 2), 1, -((opts.y or 0) + (opts.bottom or 6)))
        s.ScrollBarThickness = 3; s.ScrollBarImageColor3 = UI.C.ACCENT
        s.CanvasSize = UDim2.new(0, 0, 0, 0)
        s.AutomaticCanvasSize = Enum.AutomaticSize.Y
        UI.corner(s, 8)
        s.Parent = opts.parent
        return s
    end

    function UI.slider(opts)
        local min, max, step = opts.min, opts.max, opts.step or 1
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -2 * UI.PAD, 0, 42); row.Position = UDim2.fromOffset(UI.PAD, opts.y or 0)
        row.BackgroundTransparency = 1; row.BorderSizePixel = 0
        row.Parent = opts.parent

        local lbl = UI.label({ parent = row, x = 2, y = 0, h = 18, bold = true, size = 11 })
        lbl.Size = UDim2.new(1, -80, 0, 18)

        local track = Instance.new("TextButton", row)
        track.Size = UDim2.new(1, -4, 0, 10); track.Position = UDim2.fromOffset(2, 26)
        track.BackgroundColor3 = UI.C.TRACK; track.Text = ""; track.AutoButtonColor = false
        track.BorderSizePixel = 0; track.Active = true
        UI.corner(track, 5)
        local fill = Instance.new("Frame", track)
        fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = UI.C.ACCENT; fill.BorderSizePixel = 0
        UI.corner(fill, 5)
        local knob = Instance.new("Frame", track)
        knob.Size = UDim2.fromOffset(14, 14); knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.BackgroundColor3 = UI.C.TEXT; knob.BorderSizePixel = 0
        UI.corner(knob, 7)

        local function fmt(v)
            if step < 1 then return string.format("%.2f", v) end
            return tostring(math.floor(v + 0.5))
        end
        local function refresh()
            local v = math.clamp(tonumber(opts.get()) or min, min, max)
            local rel = (v - min) / math.max(max - min, 1e-6)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            lbl.Text = opts.label .. "  " .. fmt(v)
        end
        local function applyAt(x, final)
            local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            local v = min + (max - min) * rel
            v = math.clamp(math.floor(v / step + 0.5) * step, min, max)
            opts.set(v); refresh()
            if opts.onChange then opts.onChange(v, final) end
        end
        local sliding = false
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                sliding = true; applyAt(i.Position.X, false)
            end
        end)
        _UIS.InputChanged:Connect(function(i)
            if not sliding then return end
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                applyAt(i.Position.X, false)
            end
        end)
        _UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if sliding then
                    sliding = false
                    local v = tonumber(opts.get()) or min
                    if opts.onChange then opts.onChange(v, true) end
                end
            end
        end)
        local function bump(dir)
            local v = math.clamp((tonumber(opts.get()) or min) + dir * step, min, max)
            opts.set(v); refresh()
            if opts.onChange then opts.onChange(v, true) end
        end
        UI.smallButton({ parent = row, pos = UDim2.new(1, -62, 0, 0), w = 28, h = 18, text = "-", onClick = function() bump(-1) end })
        UI.smallButton({ parent = row, pos = UDim2.new(1, -30, 0, 0), w = 28, h = 18, text = "+", onClick = function() bump(1) end })
        refresh()
        return row, refresh
    end

    function UI.textbox(opts)
        local tb = Instance.new("TextBox")
        tb.Size = opts.size2 or UDim2.new(1, -2 * UI.PAD, 0, opts.h or 26)
        tb.Position = opts.pos or UDim2.fromOffset(opts.x or UI.PAD, opts.y or 0)
        tb.BackgroundColor3 = UI.C.BG; tb.BorderSizePixel = 0
        tb.Font = UI.FONT; tb.TextSize = 11; tb.TextColor3 = UI.C.TEXT
        tb.PlaceholderText = opts.placeholder or ""; tb.PlaceholderColor3 = UI.C.MUTED
        tb.Text = opts.text or ""; tb.ClearTextOnFocus = false
        tb.TextXAlignment = Enum.TextXAlignment.Left
        UI.corner(tb, 7); UI.stroke(tb)
        local pad = Instance.new("UIPadding", tb); pad.PaddingLeft = UDim.new(0, 8)
        tb.Parent = opts.parent
        return tb
    end

    do
        local sg, holder
        local function ensure()
            if sg and sg.Parent then return end
            sg = UI.screen("HazhubNotif", 1000000)
            holder = Instance.new("Frame", sg)
            holder.BackgroundTransparency = 1; holder.BorderSizePixel = 0
            holder.AnchorPoint = Vector2.new(1, 1)
            holder.Position = UDim2.new(1, -16, 1, -16); holder.Size = UDim2.fromOffset(260, 300)
            local lay = Instance.new("UIListLayout", holder)
            lay.SortOrder = Enum.SortOrder.LayoutOrder
            lay.VerticalAlignment = Enum.VerticalAlignment.Bottom
            lay.HorizontalAlignment = Enum.HorizontalAlignment.Right
            lay.Padding = UDim.new(0, 6)
        end
        local order = 0
        function UI.notify(title, text, isError)
            ensure()
            if #holder:GetChildren() > 6 then
                for _, c in ipairs(holder:GetChildren()) do
                    if c:IsA("Frame") then c:Destroy(); break end
                end
            end
            order += 1
            local card = Instance.new("Frame")
            card.Size = UDim2.fromOffset(260, 46); card.BackgroundColor3 = UI.C.PANEL
            card.BorderSizePixel = 0; card.LayoutOrder = order; card.BackgroundTransparency = 1
            UI.corner(card, 8); UI.stroke(card, isError and UI.C.DANGER or UI.C.STROKE)
            local bar = Instance.new("Frame", card)
            bar.Size = UDim2.new(0, 3, 1, -12); bar.Position = UDim2.fromOffset(6, 6)
            bar.BackgroundColor3 = isError and UI.C.DANGER or UI.C.ACCENT; bar.BorderSizePixel = 0
            UI.corner(bar, 2)
            local a = UI.label({ parent = card, x = 16, y = 6, h = 16, bold = true, size = 11, text = tostring(title or "") })
            a.Size = UDim2.new(1, -22, 0, 16)
            local b = UI.label({ parent = card, x = 16, y = 23, h = 16, size = 11, muted = true, text = tostring(text or "") })
            b.Size = UDim2.new(1, -22, 0, 16)
            card.Parent = holder
            _TS:Create(card, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
            task.delay(3, function()
                if not card.Parent then return end
                local tw = _TS:Create(card, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
                tw:Play(); tw.Completed:Wait()
                if card.Parent then card:Destroy() end
            end)
        end
    end

    _G.HazhubUI = UI
end
local UI = _G.HazhubUI

local __stgN = 0
local function stagSpawn(fn)
    __stgN = __stgN + 1
    local n = __stgN
    task.spawn(function()

        task.wait(6)
        for _ = 1, n do task.wait() end

        local Players = game:GetService("Players")
        while not Players.LocalPlayer do task.wait() end
        fn()
    end)
end

local function nowSpawn(fn)
    task.spawn(function()
        local Players = game:GetService("Players")
        while not Players.LocalPlayer do task.wait() end
        fn()
    end)
end

nowSpawn(function()
    task.wait(4)
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local HS         = game:GetService("HttpService")
    local LP         = Players.LocalPlayer
    local PG         = LP:WaitForChild("PlayerGui")

    local cfg = _G.HubCfg.get("invis")
    local function saveCfg()
        cfg.angle  = _G.InvisStealAngle
        cfg.depth  = _G.SinkSliderValue
        cfg.ws     = _G.HazhubWSValue
        cfg.wsOn   = _G.HazhubWSEnabled
        cfg.aInv   = _G.AutoInvisDuringSteal
        cfg.aRec   = _G.AutoRecoverLagback
        cfg.panelX = _G.InvisPanelX
        cfg.panelY = _G.InvisPanelY
        _G.HubCfg.save()
    end

    if _G.InvisStealAngle     == nil then _G.InvisStealAngle     = 225   end
    if _G.SinkSliderValue     == nil then _G.SinkSliderValue     = 8     end
    if _G.HazhubWSValue       == nil then _G.HazhubWSValue       = 28    end
    if _G.HazhubWSEnabled     == nil then _G.HazhubWSEnabled     = true  end
    if _G.AutoInvisDuringSteal== nil then _G.AutoInvisDuringSteal= false end
    if _G.AutoRecoverLagback  == nil then _G.AutoRecoverLagback  = true  end
    do
        if tonumber(cfg.angle) then _G.InvisStealAngle = tonumber(cfg.angle) end
        if tonumber(cfg.depth) then _G.SinkSliderValue = tonumber(cfg.depth) end
        if tonumber(cfg.ws)    then _G.HazhubWSValue   = tonumber(cfg.ws) end
        if type(cfg.wsOn) == "boolean" then _G.HazhubWSEnabled      = cfg.wsOn end
        if type(cfg.aInv) == "boolean" then _G.AutoInvisDuringSteal = cfg.aInv end
        if type(cfg.aRec) == "boolean" then _G.AutoRecoverLagback   = cfg.aRec end
        if tonumber(cfg.panelX) then _G.InvisPanelX = tonumber(cfg.panelX) end
        if tonumber(cfg.panelY) then _G.InvisPanelY = tonumber(cfg.panelY) end
    end
    _G.invisibleStealEnabled = false

    local animPlaying      = false
    local tracks           = {}
    local folderConns      = {}
    local serverGhosts     = {}
    local ghostEnabled     = true
    local lagbackCallCount = 0
    local lagbackWindow    = 0
    local lastLagback      = 0
    local errorOrbActive   = false
    local errorOrb, errorOrbConn
    local oldRoot, cloneRoot, hip, conn
    local refreshUI

    local function clearErrorOrb()
        if errorOrb and errorOrb.Parent then errorOrb:Destroy() end
        errorOrb = nil; errorOrbActive = false
        if errorOrbConn then errorOrbConn:Disconnect(); errorOrbConn = nil end
    end

    local function createErrorOrb()
        if errorOrbActive then return end
        errorOrbActive = true
        for _, g in pairs(serverGhosts) do if g and g.Parent then g:Destroy() end end
        serverGhosts = {}
    end

    local function clearAllGhosts()
        for _, g in pairs(serverGhosts) do
            pcall(function() if g and g.Parent then g:Destroy() end end)
        end
        serverGhosts = {}; clearErrorOrb()
        lagbackCallCount = 0; lastLagback = 0
        pcall(function()
            if workspace.CurrentCamera then
                for _, c in pairs(workspace.CurrentCamera:GetChildren()) do
                    if c.Name == "LagbackGhost" then c:Destroy() end
                end
            end
        end)
    end

    local function createServerGhost(pos)
        if not ghostEnabled or errorOrbActive then return end
        local now = tick()
        if now - lastLagback < 0.05 then return end
        lastLagback = now
        if now - lagbackWindow > 1 then lagbackCallCount = 0; lagbackWindow = now end
        lagbackCallCount = lagbackCallCount + 1
        if lagbackCallCount >= 7 then createErrorOrb(); return end
        for _, g in pairs(serverGhosts) do if g and g.Parent then g:Destroy() end end
        serverGhosts = {}
        local g = Instance.new("Part")
        g.Name = "LagbackGhost"; g.Shape = Enum.PartType.Ball
        g.Size = Vector3.new(3, 3, 3); g.Color = Color3.fromRGB(255, 0, 0)
        g.Material = Enum.Material.Glass; g.Transparency = 0.3
        g.CanCollide = false; g.Anchored = true; g.CastShadow = false
        g.Position = pos + Vector3.new(0, 5, 0)
        g.Parent = workspace.CurrentCamera
        serverGhosts[#serverGhosts + 1] = g
    end

    local WS = { enabled = false, conn = nil }
    local function setWalkSpeedEnabled(en)
        WS.enabled = en
        if WS.conn then WS.conn:Disconnect(); WS.conn = nil end
        if refreshUI then refreshUI() end
        if not en then return end
        WS.conn = RunService.Heartbeat:Connect(function(dt)
            if _G.FlingActive then return end
            local c = LP.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if not hum or not root or hum.Health <= 0 then return end

            local target = tonumber(_G.HazhubWSValue) or 28
            if hum.MoveDirection.Magnitude > 0 and target > hum.WalkSpeed then
                root.CFrame = root.CFrame + (hum.MoveDirection * (target - hum.WalkSpeed) * dt)
            end
        end)
    end
    _G.setWalkSpeedEnabled = setWalkSpeedEnabled

    local function setWalkSpeedValue(v)
        v = math.clamp(math.floor((tonumber(v) or 28) + 0.5), 15, 29)
        _G.HazhubWSValue = v
        return v
    end
    _G.setWalkSpeedValue = setWalkSpeedValue
    setWalkSpeedValue(_G.HazhubWSValue)

    local function removeFolders()
        local pf = workspace:FindFirstChild(LP.Name)
        if not pf then return end
        local dr = pf:FindFirstChild("DoubleRig")
        if dr then
            local rr = dr:FindFirstChild("HumanoidRootPart") or dr:FindFirstChildWhichIsA("BasePart")
            if rr and ghostEnabled then createServerGhost(rr.Position) end
            dr:Destroy()
        end
        local cs = pf:FindFirstChild("Constraints")
        if cs then cs:Destroy() end
        folderConns[#folderConns + 1] = pf.ChildAdded:Connect(function(child)
            if child.Name == "DoubleRig" then
                task.defer(function()
                    if not child or not child.Parent then return end
                    local rr = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChildWhichIsA("BasePart")
                    if rr and ghostEnabled then createServerGhost(rr.Position) end
                    child:Destroy()
                end)
            elseif child.Name == "Constraints" then
                child:Destroy()
            end
        end)
    end

    if not _G._xenFixRig then
        local _rigBusy = false
        local _R = {
            {"Root","HumanoidRootPart","LowerTorso"},{"Waist","LowerTorso","UpperTorso"},
            {"Neck","UpperTorso","Head"},
            {"LeftShoulder","UpperTorso","LeftUpperArm"},{"LeftElbow","LeftUpperArm","LeftLowerArm"},
            {"LeftWrist","LeftLowerArm","LeftHand"},
            {"RightShoulder","UpperTorso","RightUpperArm"},{"RightElbow","RightUpperArm","RightLowerArm"},
            {"RightWrist","RightLowerArm","RightHand"},
            {"LeftHip","LowerTorso","LeftUpperLeg"},{"LeftKnee","LeftUpperLeg","LeftLowerLeg"},
            {"LeftAnkle","LeftLowerLeg","LeftFoot"},
            {"RightHip","LowerTorso","RightUpperLeg"},{"RightKnee","RightUpperLeg","RightLowerLeg"},
            {"RightAnkle","RightLowerLeg","RightFoot"},
        }
        local function _fix()
            local _ch = LP.Character
            if not _ch then return end
            local _h = _ch:FindFirstChildOfClass("Humanoid")
            if not _h or _h.RigType ~= Enum.HumanoidRigType.R15 or _h.Health <= 0 then return end
            for _, j in ipairs(_R) do
                local p, c = _ch:FindFirstChild(j[2]), _ch:FindFirstChild(j[3])
                if p and c then
                    local have = false
                    for _, d in ipairs(c:GetChildren()) do
                        if d:IsA("Motor6D") and d.Name == j[1] then have = true break end
                    end
                    if not have then
                        local a0 = p:FindFirstChild(j[1] .. "RigAttachment")
                        local a1 = c:FindFirstChild(j[1] .. "RigAttachment")
                        if a0 and a1 then
                            for _, d in ipairs(c:GetChildren()) do
                                if d:IsA("AnimationConstraint") and d.Name == j[1] then
                                    pcall(function() d.Enabled = false end)
                                end
                            end
                            pcall(function()
                                local m = Instance.new("Motor6D")
                                m.Name, m.Part0, m.Part1, m.C0, m.C1 = j[1], p, c, a0.CFrame, a1.CFrame
                                m.Parent = c
                            end)
                        end
                    end
                end
            end
        end
        _G._xenFixRig = function()
            if _rigBusy then return false end
            _rigBusy = true
            local ok = pcall(_fix)
            _rigBusy = false
            return ok
        end
    end

    local function invisClone()
        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        hip = hum.HipHeight
        oldRoot = c:FindFirstChild("HumanoidRootPart")
        if not oldRoot or not oldRoot.Parent then return false end
        for _, x in pairs(oldRoot:GetChildren()) do
            if x:IsA("Attachment") and (x.Name:find("Beam") or x.Name:find("Attach")) then x:Destroy() end
        end
        for _, x in pairs(oldRoot:GetChildren()) do
            if x:IsA("Beam") then x:Destroy() end
        end
        local tmp = Instance.new("Model"); tmp.Parent = game
        c.Parent = tmp
        cloneRoot = oldRoot:Clone(); cloneRoot.Parent = c
        oldRoot.Parent = workspace.CurrentCamera
        cloneRoot.CFrame = oldRoot.CFrame; c.PrimaryPart = cloneRoot
        c.Parent = workspace
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == oldRoot then v.Part0 = cloneRoot end
                if v.Part1 == oldRoot then v.Part1 = cloneRoot end
            end
        end
        tmp:Destroy()
        task.defer(function() if _G._xenFixRig then _G._xenFixRig() end end)
        return true
    end

    local function invisRevert()
        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not oldRoot or not oldRoot:IsDescendantOf(workspace) or not hum or hum.Health <= 0 then return end
        local tmp = Instance.new("Model"); tmp.Parent = game
        c.Parent = tmp
        oldRoot.Parent = c; c.PrimaryPart = oldRoot
        c.Parent = workspace; oldRoot.CanCollide = true
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == cloneRoot then v.Part0 = oldRoot end
                if v.Part1 == cloneRoot then v.Part1 = oldRoot end
            end
        end
        tmp:Destroy()
        if cloneRoot then
            local p = cloneRoot.CFrame
            cloneRoot:Destroy(); cloneRoot = nil
            oldRoot.CFrame = p
        end
        oldRoot = nil
        if hip then hum.HipHeight = hip end
        task.defer(function() if _G._xenFixRig then _G._xenFixRig() end end)
        clearAllGhosts()
    end

    local function animationTrickery()
        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local a = Instance.new("Animation")
        a.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
        local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
        local tr = animator:LoadAnimation(a)
        tr.Priority = Enum.AnimationPriority.Action4
        tr:Play(0, 1, 0); a:Destroy()
        tracks[#tracks + 1] = tr
        tr.Stopped:Connect(function() if animPlaying then animationTrickery() end end)
        task.defer(function()
            tr.TimePosition = 0.7
            task.delay(0.3, function() pcall(function() tr:AdjustSpeed(math.huge) end) end)
        end)
    end

    local invisCooldown = 0

    local function invisTurnOff()
        clearAllGhosts()
        if not animPlaying then return end
        animPlaying = false; _G.invisibleStealEnabled = false
        for _, t in pairs(tracks) do pcall(function() t:Stop(0) end) end
        tracks = {}
        if conn then conn:Disconnect(); conn = nil end
        for _, x in ipairs(folderConns) do pcall(function() x:Disconnect() end) end
        folderConns = {}
        invisRevert(); clearAllGhosts()
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                local animator = hum:FindFirstChildOfClass("Animator")
                if animator then
                    for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
                        if t.Priority == Enum.AnimationPriority.Action4
                        or t.Priority == Enum.AnimationPriority.Action3 then t:Stop(0) end
                    end
                end
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                task.defer(function()
                    if hum and hum.Parent then hum:ChangeState(Enum.HumanoidStateType.Running) end
                end)
            end)
        end

        if WS.enabled and _G.HazhubWSEnabled then setWalkSpeedEnabled(false) end
        invisCooldown = tick()
        if refreshUI then refreshUI() end
    end

    local function invisTurnOn()
        if animPlaying then return end
        local c = LP.Character
        if not c or not c:FindFirstChildOfClass("Humanoid") then return end
        animPlaying = true; _G.invisibleStealEnabled = true
        tracks = {}; removeFolders()
        if not invisClone() then
            animPlaying = false; _G.invisibleStealEnabled = false
            if refreshUI then refreshUI() end
            return
        end
        task.wait(0.05); animationTrickery()
        task.delay(1, function()
            if _G.invisibleStealEnabled and _G.HazhubWSEnabled and not WS.enabled then
                setWalkSpeedEnabled(true)
            end
        end)
        local lastSetPosition, skipFrames = nil, 5
        conn = RunService.PreSimulation:Connect(function()
            local ch = LP.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 or not oldRoot then return end
            local root = ch.PrimaryPart or ch:FindFirstChild("HumanoidRootPart")
            if not root then return end

            if skipFrames > 0 then
                skipFrames = skipFrames - 1; lastSetPosition = nil
            elseif lastSetPosition and ghostEnabled then
                local cur = oldRoot.Position
                if (cur - lastSetPosition).Magnitude > 6
                   and not _G.RecoveryInProgress and LP:GetAttribute("Stealing") then
                    lastSetPosition = nil
                    createServerGhost(cur)
                    if _G.AutoRecoverLagback and _G._forceInvisToggle then
                        _G.RecoveryInProgress = true
                        task.spawn(function()
                            pcall(_G._forceInvisToggle); task.wait(0.6)
                            if LP:GetAttribute("Stealing") then pcall(_G._forceInvisToggle) end
                            _G.RecoveryInProgress = false
                        end)
                    end
                end
            end
            if cloneRoot then cloneRoot.CanCollide = true end
            if oldRoot and oldRoot.Parent then
                for _, x in pairs(oldRoot:GetChildren()) do
                    if x:IsA("Attachment") or x:IsA("Beam") then x:Destroy() end
                end
                local sink = (tonumber(_G.SinkSliderValue) or 8) * 0.5
                oldRoot.CFrame = (root.CFrame - Vector3.new(0, sink, 0))
                    * CFrame.Angles(math.rad(tonumber(_G.InvisStealAngle) or 180), 0, 0)
                oldRoot.AssemblyLinearVelocity = root.AssemblyLinearVelocity
                oldRoot.CanCollide = false
                lastSetPosition = oldRoot.Position
            end
        end)
        if refreshUI then refreshUI() end
    end

    _G.toggleInvisibleSteal = function()
        if (tick() - invisCooldown) < 0.3 then return end
        if animPlaying then invisTurnOff() else invisTurnOn() end
    end

    _G._forceInvisToggle = function()
        if animPlaying then invisTurnOff() else invisTurnOn() end
    end

    local function setupDeathListener()
        local ch = LP.Character
        local h = ch and ch:FindFirstChildOfClass("Humanoid")
        if h then
            h.Died:Connect(function()
                clearErrorOrb(); clearAllGhosts(); lagbackCallCount = 0
            end)
        end
    end
    setupDeathListener()

    LP.CharacterAdded:Connect(function(newChar)
        task.wait(0.1)
        clearErrorOrb(); clearAllGhosts(); lagbackCallCount = 0
        pcall(function()
            for _, x in pairs(workspace.CurrentCamera:GetChildren()) do
                if x:IsA("BasePart") and x.Name == "HumanoidRootPart" then x:Destroy() end
            end
        end)
        if oldRoot   then pcall(function() oldRoot:Destroy() end);   oldRoot = nil end
        if cloneRoot then pcall(function() cloneRoot:Destroy() end); cloneRoot = nil end
        animPlaying = false; _G.invisibleStealEnabled = false
        if conn then conn:Disconnect(); conn = nil end
        setupDeathListener()
        if refreshUI then refreshUI() end
        task.wait(0.2)
        local cam = workspace.CurrentCamera
        local h = newChar and newChar:FindFirstChildOfClass("Humanoid")
        if cam and h then cam.CameraSubject = h; cam.CameraType = Enum.CameraType.Custom end
    end)

    task.spawn(function()
        local wasStealing, autoEnabled = false, false
        task.wait(1)
        while task.wait(0.15) do
            if not _G.AutoInvisDuringSteal then
                wasStealing = false; autoEnabled = false
            else
                local isStealing = LP:GetAttribute("Stealing")
                if isStealing and not wasStealing and not _G.invisibleStealEnabled then

                    task.spawn(function()
                        task.wait(0.5)
                        if LP:GetAttribute("Stealing") and not _G.invisibleStealEnabled then
                            pcall(_G._forceInvisToggle); autoEnabled = true
                        end
                    end)
                end
                if not isStealing and autoEnabled and _G.invisibleStealEnabled then
                    task.wait(0.3)
                    if not LP:GetAttribute("Stealing") then
                        pcall(_G._forceInvisToggle); autoEnabled = false
                    end
                end
                wasStealing = isStealing
            end
        end
    end)

    local guiParent = (gethui and gethui()) or game:GetService("CoreGui") or PG
    pcall(function()
        local old = guiParent:FindFirstChild("InvisStealUI")
        if old then old:Destroy() end
    end)
    local sg = Instance.new("ScreenGui")
    sg.Name = "HazhubInvisUI"; sg.ResetOnSpawn = false; sg.DisplayOrder = 131
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = PG end

    local f, body = UI.panel({
        name = "Panel", title = "HAZHUB INVIS", w = 206, h = 36 + 312 + 8,
        x = tonumber(_G.InvisPanelX) or 14, y = tonumber(_G.InvisPanelY) or 400,
        parent = sg,
        onDrop = function(fr)
            _G.InvisPanelX = fr.AbsolutePosition.X
            _G.InvisPanelY = fr.AbsolutePosition.Y
            saveCfg()
        end,
    })

    local ups = {}
    local function mkBtn(y, label, get, set)
        local b, setOn
        local function up()
            local on = get()
            b.Text = label .. (on and ": ON" or ": OFF")
            setOn(on)
        end
        b, setOn = UI.button({ parent = body, y = y, onClick = function() set(); up(); saveCfg() end })
        up(); ups[#ups + 1] = up
    end

    local function mkRow(y, label, min, max, step, get, set)
        local _, refresh = UI.slider({ parent = body, y = y, label = label, min = min, max = max, step = step,
            get = get, set = set,
            onChange = function(v, final) if final then saveCfg() end end })
        return refresh
    end

    mkBtn(0,  "INVIS",       function() return animPlaying end,
                             function() _G.toggleInvisibleSteal() end)
    mkBtn(30, "WALKSPEED",   function() return WS.enabled end,
                             function()
                                 _G.HazhubWSEnabled = not WS.enabled
                                 setWalkSpeedEnabled(_G.HazhubWSEnabled)
                             end)
    mkBtn(60, "AUTO INVIS",  function() return _G.AutoInvisDuringSteal end,
                             function() _G.AutoInvisDuringSteal = not _G.AutoInvisDuringSteal end)
    mkBtn(90, "AUTO RECOVER", function() return _G.AutoRecoverLagback end,
                             function() _G.AutoRecoverLagback = not _G.AutoRecoverLagback end)

    refreshUI = function() for _, u in ipairs(ups) do pcall(u) end end

    local refreshAngleBtns, refreshWsBtns
    local refreshRot = mkRow(122, "Rotation",  0,  360, 5,
        function() return _G.InvisStealAngle end,
        function(v) _G.InvisStealAngle = v; if refreshAngleBtns then refreshAngleBtns() end end)
    mkRow(166, "Depth",     0,  18,  0.1, function() return _G.SinkSliderValue end, function(v) _G.SinkSliderValue = v end)
    local refreshWs = mkRow(210, "WalkSpeed", 15, 29,  1,
        function() return _G.HazhubWSValue end,
        function(v) _G.setWalkSpeedValue(v); if refreshWsBtns then refreshWsBtns() end end)

    do
        local b180, b220
        refreshAngleBtns = function()
            local a = tonumber(_G.InvisStealAngle) or 180
            if b180 then b180.BackgroundColor3 = (math.abs(a - 180) < 0.5) and UI.C.BTN_ON or UI.C.BTN end
            if b220 then b220.BackgroundColor3 = (math.abs(a - 220) < 0.5) and UI.C.BTN_ON or UI.C.BTN end
        end
        local function mkAngleBtn(x, deg, label)
            return UI.smallButton({ parent = body, x = x, y = 256, w = 91, h = 24, text = label, textSize = 11,
                onClick = function()
                    _G.InvisStealAngle = deg
                    if refreshRot then refreshRot() end
                    refreshAngleBtns(); saveCfg()
                end })
        end
        b180 = mkAngleBtn(8, 180, "180\u{00B0}")
        b220 = mkAngleBtn(107, 220, "220\u{00B0}")
        refreshAngleBtns(); ups[#ups + 1] = refreshAngleBtns
    end

    do
        local b20, b27
        refreshWsBtns = function()
            local w = tonumber(_G.HazhubWSValue) or 20
            if b20 then b20.BackgroundColor3 = (math.abs(w - 20) < 0.5) and UI.C.BTN_ON or UI.C.BTN end
            if b27 then b27.BackgroundColor3 = (math.abs(w - 27) < 0.5) and UI.C.BTN_ON or UI.C.BTN end
        end
        local function mkWsBtn(x, val, label)
            return UI.smallButton({ parent = body, x = x, y = 286, w = 91, h = 24, text = label, textSize = 11,
                onClick = function()
                    _G.setWalkSpeedValue(val)
                    if refreshWs then refreshWs() end
                    refreshWsBtns(); saveCfg()
                end })
        end
        b20 = mkWsBtn(8, 20, "20")
        b27 = mkWsBtn(107, 27, "27")
        refreshWsBtns(); ups[#ups + 1] = refreshWsBtns
    end

    if _G.HazhubWSEnabled then
        task.defer(function() setWalkSpeedEnabled(true) end)
    else
        refreshUI()
    end
end)

nowSpawn(function()
    task.wait(4)
local okXR, errXR = pcall(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    if type(_G.setXRay) == "function" then
        warn("[XRAY] un autre X-Ray est deja actif -> celui-ci ne s applique pas (anti-cumul)")
        return
    end

    _G.XRayEnabled = true
    if _G.XRayAlpha == nil then
        local saved
        pcall(function()
            if _G.HubCfg then saved = tonumber(_G.HubCfg.get("carpet").xrayAlpha) end
        end)
        _G.XRayAlpha = math.clamp(saved or 0.60, 0, 1)
    end

    local origT = setmetatable({}, { __mode = "k" })
    local conns = {}
    local loopId = 0

    local function setTargetTransparency(instance, alpha, id)
        if not instance then return end
        if id and id ~= loopId then return end

        local function apply(obj)

            local laser = _G.__laser
            if laser and laser.IsLaserObject and laser.IsLaserObject(obj) then
                local plot = laser.GetPlotFromObject and laser.GetPlotFromObject(obj)
                if plot and laser.IsPlotBaseOpen and laser.IsPlotBaseOpen(plot) then
                    if laser.SaveLaserOriginal then laser.SaveLaserOriginal(obj) end
                    if laser.HideLaserObject then laser.HideLaserObject(obj) end
                end
                return
            end
            if obj:IsA("BasePart") then
                if origT[obj] == nil then
                    if obj.Transparency == alpha then origT[obj] = 0
                    else origT[obj] = obj.Transparency end
                end
                local o = origT[obj]
                if o < 1 then
                    local target = o + (1 - o) * alpha
                    if math.abs(obj.Transparency - target) > 0.01 then obj.Transparency = target end
                end
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if origT[obj] == nil then
                    local t, b = obj.TextTransparency, obj.BackgroundTransparency
                    if t == alpha then t = 0 end
                    if b == alpha then b = 0 end
                    origT[obj] = { text = t, bg = b }
                end
                local o = origT[obj]
                if o.text < 1 then
                    local tt = o.text + (1 - o.text) * alpha
                    if math.abs(obj.TextTransparency - tt) > 0.01 then obj.TextTransparency = tt end
                end
                if o.bg < 1 then
                    local tb = o.bg + (1 - o.bg) * alpha
                    if math.abs(obj.BackgroundTransparency - tb) > 0.01 then obj.BackgroundTransparency = tb end
                end
            elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                if origT[obj] == nil then
                    if obj.BackgroundTransparency == alpha then origT[obj] = 0
                    else origT[obj] = obj.BackgroundTransparency end
                end
                local o = origT[obj]
                if o < 1 then
                    local target = o + (1 - o) * alpha
                    if math.abs(obj.BackgroundTransparency - target) > 0.01 then obj.BackgroundTransparency = target end
                end
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                if origT[obj] == nil then
                    local i, b = obj.ImageTransparency, obj.BackgroundTransparency
                    if i == alpha then i = 0 end
                    if b == alpha then b = 0 end
                    origT[obj] = { img = i, bg = b }
                end
                local o = origT[obj]
                if o.img < 1 then
                    local ti = o.img + (1 - o.img) * alpha
                    if math.abs(obj.ImageTransparency - ti) > 0.01 then obj.ImageTransparency = ti end
                end
                if o.bg < 1 then
                    local tb = o.bg + (1 - o.bg) * alpha
                    if math.abs(obj.BackgroundTransparency - tb) > 0.01 then obj.BackgroundTransparency = tb end
                end
            end
        end

        apply(instance)
        local desc = instance:GetDescendants()
        for i, child in ipairs(desc) do
            apply(child)
            if i % 300 == 0 then
                task.wait()
                if id and id ~= loopId then return end
            end
        end
    end

    local XRAY_FOLDERS = { "Base", "PlotSign", "FriendPanel", "Cash",
                           "Decorations", "Skin", "Unlock", "Purchases" }

    local function trackSubtree(root, alpha, id)
        if not root then return end
        if id ~= loopId then return end
        setTargetTransparency(root, alpha, id)
        if id ~= loopId then return end
        conns[#conns + 1] = root.DescendantAdded:Connect(function(obj)
            if id ~= loopId then return end
            setTargetTransparency(obj, alpha, id)
        end)
    end

    local function processPlot(plot, alpha, id)
        if not plot then return end
        if id ~= loopId then return end
        for _, fname in ipairs(XRAY_FOLDERS) do
            if id ~= loopId then return end
            trackSubtree(plot:FindFirstChild(fname), alpha, id)
        end
        if id ~= loopId then return end
        conns[#conns + 1] = plot.ChildAdded:Connect(function(child)
            if id ~= loopId then return end
            for _, fname in ipairs(XRAY_FOLDERS) do
                if child.Name == fname then trackSubtree(child, alpha, id); break end
            end
        end)

        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            local function processPodium(podium)
                for _, child in ipairs(podium:GetChildren()) do
                    if child.Name == "Claim" then
                        trackSubtree(child, alpha, id)
                    elseif child.Name == "Base" then
                        trackSubtree(child:FindFirstChild("Decorations"), alpha, id)
                    elseif child:IsA("Model") and child.Name ~= "Decorations" then
                        trackSubtree(child, alpha, id)
                    end
                end
            end
            for _, podium in ipairs(podiums:GetChildren()) do processPodium(podium) end
            conns[#conns + 1] = podiums.ChildAdded:Connect(function(podium)
                if id ~= loopId then return end
                task.wait(0.1)
                if id ~= loopId then return end
                processPodium(podium)
            end)
        end
    end

    local function applyAllPlots(alpha, id)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        for _, plot in ipairs(plots:GetChildren()) do
            if id ~= loopId then return end
            processPlot(plot, alpha, id)

        end
        conns[#conns + 1] = plots.ChildAdded:Connect(function(plot)
            if id ~= loopId then return end
            task.wait(0.2)
            processPlot(plot, alpha, id)
        end)
    end

    local function setXRay(enabled)
        _G.XRayEnabled = enabled

        for _, c in ipairs(conns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        conns = {}

        loopId = loopId + 1
        local id = loopId

        if enabled then
            local alpha = math.clamp(tonumber(_G.XRayAlpha) or 0.60, 0, 1)
            task.spawn(function()
                while id == loopId and not workspace:FindFirstChild("Plots") do
                    task.wait()
                end
                if id ~= loopId then return end
                pcall(applyAllPlots, alpha, id)
            end)
        else

            local snap = origT
            origT = setmetatable({}, { __mode = "k" })
            for obj, o in pairs(snap) do
                pcall(function()
                    if obj:IsA("BasePart") then
                        obj.Transparency = o
                    elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                        obj.TextTransparency = o.text
                        obj.BackgroundTransparency = o.bg
                    elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                        obj.BackgroundTransparency = o
                    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                        obj.ImageTransparency = o.img
                        obj.BackgroundTransparency = o.bg
                    end
                end)
            end

            local fps = _G.OriginalTransparency
            if type(fps) == "table" then
                for part, data in pairs(fps) do
                    if part and part.Parent and typeof(data) == "table" and data.trans then
                        pcall(function() part.Transparency = data.trans end)
                    end
                end
            end
            local laser = _G.__laser
            if laser and laser.RefreshAllPlotLasers then
                pcall(laser.RefreshAllPlotLasers)
            end
        end
    end
    _G.setXRay = setXRay
    _G.toggleXRay = function() setXRay(not _G.XRayEnabled) end

    local _xrReapplyPending = false
    Players.PlayerAdded:Connect(function()
        if not _G.XRayEnabled then return end
        if _xrReapplyPending then return end
        _xrReapplyPending = true
        task.spawn(function()
            task.wait(0.5)
            _xrReapplyPending = false
            if _G.XRayEnabled then pcall(setXRay, true) end
        end)
    end)

    task.spawn(function() setXRay(true) end)
end)

if not okXR then
    warn("[XRAY] BLOC EN ERREUR: " .. tostring(errXR))
    pcall(UI.notify, "X-RAY", "ERREUR: " .. tostring(errXR), true)
end
end)

nowSpawn(function()
    task.wait(4)
local okIJ, errIJ = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS        = game:GetService("UserInputService")
    local LP         = Players.LocalPlayer

    _G.InfiniteJumpEnabled = true
    local lastJump, conn = 0, nil

    local function setInfiniteJump(en)
        _G.InfiniteJumpEnabled = en
        if conn then conn:Disconnect(); conn = nil end
        if not en then return end
        conn = RunService.Heartbeat:Connect(function()
            if not _G.InfiniteJumpEnabled then return end
            if not UIS:IsKeyDown(Enum.KeyCode.Space) then return end
            local now = tick()
            if now - lastJump < 0.1 then return end
            local c = LP.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            lastJump = now
            hrp.AssemblyLinearVelocity =
                Vector3.new(hrp.AssemblyLinearVelocity.X, 55, hrp.AssemblyLinearVelocity.Z)
        end)
    end
    _G.setInfiniteJump = setInfiniteJump

    setInfiniteJump(true)
end)

if not okIJ then warn("[INFJUMP] BLOC EN ERREUR: " .. tostring(errIJ)) end
end)

nowSpawn(function()
local okAR, errAR = pcall(function()
    local Players           = game:GetService("Players")
    local RunService        = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace         = workspace
    local player            = Players.LocalPlayer
    while not player do task.wait(); player = Players.LocalPlayer end

    local Config = { AntiRagdoll = false }
    local function setToggle() end
    local function saveConfig() end

    do
        local antiRagdollConnections = {}
        local antiRagdollCharacter, antiRagdollHumanoid, antiRagdollRootPart, antiRagdollAnimator
        local lastVelocity = Vector3.new(0, 0, 0)
        local velocityChangeThreshold = 40
        local velocityMagnitudeThreshold = 25
        local maxVelocity = 15

        local function isFlyingCarpetActive()
            if not antiRagdollCharacter then return false end
            local tool = antiRagdollCharacter:FindFirstChildWhichIsA("Tool")
            if not tool then return false end
            local hrp = antiRagdollCharacter:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in ipairs(hrp:GetChildren()) do
                    if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                        return true
                    end
                end
            end
            return false
        end

        local function isRagdolled()
            if not antiRagdollHumanoid then return false end
            local state = antiRagdollHumanoid:GetState()
            return state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown
                or state == Enum.HumanoidStateType.GettingUp
        end

        local function enableAntiRagdollControls()
            pcall(function()
                local PlayerModule = player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10)
                require(PlayerModule):GetControls():Enable()
            end)
        end

        local function cleanupRagdoll()
            if not antiRagdollCharacter then return end
            local carpetEquipped = isFlyingCarpetActive()

            local function processChildren(parent)
                for _, obj in ipairs(parent:GetChildren()) do
                    if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint")
                        or (obj:IsA("Attachment") and (obj.Name == "A" or obj.Name == "B")) then
                        obj:Destroy()
                    elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                        if not carpetEquipped then obj:Destroy() end
                    elseif obj:IsA("Motor6D") then
                        obj.Enabled = true
                    elseif obj:IsA("BasePart") then
                        for _, child in ipairs(obj:GetChildren()) do
                            if child:IsA("BallSocketConstraint") or child:IsA("NoCollisionConstraint") or child:IsA("HingeConstraint") or child:IsA("Motor6D") then
                                if child:IsA("Motor6D") then
                                    child.Enabled = true
                                else
                                    child:Destroy()
                                end
                            elseif child:IsA("Attachment") and (child.Name == "A" or child.Name == "B") then
                                child:Destroy()
                            end
                        end
                    end
                end
            end

            pcall(function() processChildren(antiRagdollCharacter) end)

            if antiRagdollAnimator then
                for _, track in pairs(antiRagdollAnimator:GetPlayingAnimationTracks()) do
                    local animName = track.Animation and track.Animation.Name:lower() or ""
                    if animName:find("rag") or animName:find("fall") or animName:find("hurt") or animName:find("down") then
                        track:Stop(0)
                    end
                end
            end
        end

        local function setupAntiRagdollCharacter(char)
            antiRagdollCharacter = char
            antiRagdollHumanoid = char:WaitForChild("Humanoid", 10)
            antiRagdollRootPart = char:WaitForChild("HumanoidRootPart", 10)
            antiRagdollAnimator = antiRagdollHumanoid and antiRagdollHumanoid:WaitForChild("Animator", 10)
            lastVelocity = Vector3.new(0, 0, 0)
        end

        local function clearAntiRagdollConnections()
            for _, c in pairs(antiRagdollConnections) do
                pcall(function() c:Disconnect() end)
            end
            antiRagdollConnections = {}
        end

        local function setupAntiRagdollConnections()
            clearAntiRagdollConnections()
            if not antiRagdollHumanoid or not antiRagdollRootPart then return end

            table.insert(antiRagdollConnections, antiRagdollHumanoid.StateChanged:Connect(function()
                if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and isRagdolled() then
                    if not isFlyingCarpetActive() then
                        antiRagdollHumanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                    cleanupRagdoll()
                    pcall(function() Workspace.CurrentCamera.CameraSubject = antiRagdollHumanoid end)
                    enableAntiRagdollControls()
                end
            end))

            pcall(function()
                local impulse
                if _G.HazhubGetRemote then
                    impulse = _G.HazhubGetRemote("RemoteEvent", "CombatService/ApplyImpulse")
                end
                if not impulse then
                    local pkgs = ReplicatedStorage:FindFirstChild("Packages")
                    local net  = pkgs and pkgs:FindFirstChild("Net")
                    impulse = net and net:FindFirstChild("RE/CombatService/ApplyImpulse")
                end
                if impulse then
                    table.insert(antiRagdollConnections, impulse.OnClientEvent:Connect(function()
                        if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and isRagdolled() then
                            antiRagdollRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        end
                    end))
                end
            end)

            table.insert(antiRagdollConnections, antiRagdollCharacter.DescendantAdded:Connect(function()
                if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and isRagdolled() then
                    cleanupRagdoll()
                end
            end))

            table.insert(antiRagdollConnections, RunService.Heartbeat:Connect(function()
                if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and isRagdolled() then

                    if _G.HazhubStealHold then return end
                    if antiRagdollRootPart.AssemblyLinearVelocity.Magnitude > 60 then
                        lastVelocity = antiRagdollRootPart.AssemblyLinearVelocity
                        return
                    end
                    cleanupRagdoll()
                    local velocity = antiRagdollRootPart.AssemblyLinearVelocity
                    if (velocity - lastVelocity).Magnitude > velocityChangeThreshold
                        and velocity.Magnitude > velocityMagnitudeThreshold then
                        antiRagdollRootPart.AssemblyLinearVelocity = velocity.Unit * math.min(velocity.Magnitude, maxVelocity)
                    end
                    lastVelocity = velocity
                end
            end))

            enableAntiRagdollControls()
            cleanupRagdoll()
        end

        local function startAntiRagdoll()
            _G.AntiRagdollEnabled = true
            _G.antiKnockbackEnabled = true
            Config.AntiRagdoll = true; setToggle("Anti Ragdoll", true); saveConfig()
            if player.Character then
                setupAntiRagdollCharacter(player.Character)
                setupAntiRagdollConnections()
            end
        end

        local function stopAntiRagdoll()
            _G.AntiRagdollEnabled = false
            _G.antiKnockbackEnabled = false
            Config.AntiRagdoll = false; setToggle("Anti Ragdoll", false); saveConfig()
            clearAntiRagdollConnections()
        end

        _G.toggleAntiRagdoll = function(enabled)
            if enabled then startAntiRagdoll() else stopAntiRagdoll() end
        end
        _G.enableAntiKnockback = function() startAntiRagdoll() end
        _G.disableAntiKnockback = function() stopAntiRagdoll() end

        player.CharacterAdded:Connect(function(char)
            clearAntiRagdollConnections()
            antiRagdollCharacter = nil; antiRagdollHumanoid = nil; antiRagdollRootPart = nil; antiRagdollAnimator = nil
            local humanoid = char:WaitForChild("Humanoid", 10)
            local rootPart = char:WaitForChild("HumanoidRootPart", 10)
            if not humanoid or not rootPart then return end
            task.wait(0.2)
            setupAntiRagdollCharacter(char)
            if _G.AntiRagdollEnabled or _G.antiKnockbackEnabled then
                setupAntiRagdollConnections()
            end
        end)

        if player.Character then
            setupAntiRagdollCharacter(player.Character)
            if _G.AntiRagdollEnabled or _G.antiKnockbackEnabled then
                setupAntiRagdollConnections()
            end
        end
    end

    if _G.toggleAntiRagdoll then _G.toggleAntiRagdoll(true) end
end)

if not okAR then warn("[ANTIRAGDOLL] BLOC EN ERREUR: " .. tostring(errAR)) end
end)

nowSpawn(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return end

    local NO_COLLIDE_GROUP = "PlayerNoCollision"

    local function applyChar(char)
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 10)
        if not hrp then return end
        local function setPart(part)
            if part:IsA("BasePart") and part.Name ~= "__HITBOX" then
                pcall(function() part.CollisionGroup = NO_COLLIDE_GROUP end)
            end
        end
        for _, part in ipairs(char:GetDescendants()) do setPart(part) end
        char.DescendantAdded:Connect(setPart)
    end

    if LocalPlayer.Character then task.spawn(applyChar, LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(applyChar)
end)

nowSpawn(function()
local okAG, errAG = pcall(function()
    local cloneref = (type(cloneref) == "function" and cloneref) or function(o) return o end
    local Players   = cloneref(game:GetService("Players"))
    local Workspace = cloneref(game:GetService("Workspace"))
    local Player    = Players.LocalPlayer

    local antiGummy = true
    local antiGummyRespawnGraceUntil = 0

    Player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        antiGummyRespawnGraceUntil = tick() + 1.5
    end)

    local function clearGummyToolBlockState(char)
        for _, inst in ipairs({ Player, char }) do
            if inst then
                if inst:GetAttribute("BlockTools") ~= nil and inst:GetAttribute("BlockTools") ~= false then
                    inst:SetAttribute("BlockTools", false)
                end
                if inst:GetAttribute("Web") ~= nil and inst:GetAttribute("Web") ~= false then
                    inst:SetAttribute("Web", false)
                end
            end
        end
        if char and char:GetAttribute("BackpackReady") == false then
            char:SetAttribute("BackpackReady", true)
        end
    end

    local function deleteGummyBears()
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "GummyBear" then
                pcall(function() obj:Destroy() end)
            end
        end
    end

    Workspace.ChildAdded:Connect(function(child)
        if antiGummy and child.Name == "GummyBear" then
            pcall(function() child:Destroy() end)
        end
    end)

    task.spawn(function()
        while task.wait(0.1) do
            if not antiGummy then continue end
            local char = Player.Character
            if not char then continue end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then continue end
            if tick() >= antiGummyRespawnGraceUntil then
                clearGummyToolBlockState(char)
            end
        end
    end)

    deleteGummyBears()

    _G.AntiGummy = {
        set = function(on)
            antiGummy = on and true or false
            if antiGummy then deleteGummyBears() end
        end,
    }
end)
if not okAG then warn("[ANTI-GUMMY] BLOC EN ERREUR: " .. tostring(errAG)) end
end)

stagSpawn(function()
    _G.CleanErrorGUIs = true
    local GS
    if cloneref then
        pcall(function() GS = cloneref(game:GetService("GuiService")) end)
    end
    GS = GS or game:GetService("GuiService")
    task.spawn(function()
        while true do
            if _G.CleanErrorGUIs then pcall(function() GS:ClearError() end) end
            task.wait(1)
        end
    end)
end)

nowSpawn(function()
local okCC, errCC = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS        = game:GetService("UserInputService")
    local HS         = game:GetService("HttpService")
    local LP         = Players.LocalPlayer
    local PG         = LP:WaitForChild("PlayerGui")
    local guiParent  = (gethui and gethui()) or game:GetService("CoreGui") or PG

    local SPEED_BOOST_TOOL_NAMES = {
        ["Flying Carpet"] = true, ["Carpet"] = true, ["Cloud"] = true,
        ["Witch's Broom"] = true, ["Cupid's Wings"] = true, ["Santa's Sleigh"] = true,
        ["Magic Carpet"] = true, ["Waverider"] = true,
    }

    local carpetOn, carpetConn, toolConn = false, nil, nil
    local refreshUI

    local function preferredTool()
        local t = _G.HazhubCarpetTool
        if type(t) == "string" and t ~= "" then return t end
        return "Flying Carpet"
    end

    local function isSpeedBoostTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        if SPEED_BOOST_TOOL_NAMES[tool.Name] then return true end
        return tool.Name == preferredTool()
    end

    local function getEquippedTool(char)
        if not char then return nil end
        return char:FindFirstChildWhichIsA("Tool")
    end

    local function equipSpeedBoostToolOnce(c, hum)
        if not c or not hum then return nil end
        local bp = LP:FindFirstChild("Backpack")
        local pref = preferredTool()
        if c:FindFirstChild(pref) then return pref end
        local tb = bp and bp:FindFirstChild(pref)
        if tb then pcall(function() hum:EquipTool(tb) end); return pref end
        for name in pairs(SPEED_BOOST_TOOL_NAMES) do
            if c:FindFirstChild(name) then return name end
            local t = bp and bp:FindFirstChild(name)
            if t then pcall(function() hum:EquipTool(t) end); return name end
        end
        return nil
    end

    local function isCarpetSpeedBlocked()
        if _G._isTpMoving then return true end
        if _G.HazhubStealHold then return true end
        if LP:GetAttribute("Stealing") then return true end
        return false
    end
    _G.isCarpetSpeedBlocked = isCarpetSpeedBlocked

    local setCarpetSpeed
    setCarpetSpeed = function(en)
        if en and isCarpetSpeedBlocked() then return end
        carpetOn = en
        if refreshUI then refreshUI() end
        if carpetConn then carpetConn:Disconnect(); carpetConn = nil end
        if not en then return end

        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if c and hum then equipSpeedBoostToolOnce(c, hum) end

        carpetConn = RunService.Heartbeat:Connect(function()
            local ch = LP.Character
            if not ch then return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if isCarpetSpeedBlocked() then
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                end
                return
            end
            local hm = ch:FindFirstChildOfClass("Humanoid")
            if not hm or not hrp then return end
            local equipped = getEquippedTool(ch)

            if equipped and not isSpeedBoostTool(equipped) then
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                setCarpetSpeed(false)
                return
            end
            if equipped and isSpeedBoostTool(equipped) then
                local md = hm.MoveDirection
                if md.Magnitude > 0 then
                    hrp.AssemblyLinearVelocity =
                        Vector3.new(md.X * 140, hrp.AssemblyLinearVelocity.Y, md.Z * 140)
                else
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                end
            end
        end)
    end
    _G.setCarpetSpeed = setCarpetSpeed
    _G.toggleCarpetSpeed = function() setCarpetSpeed(not carpetOn) end

    local function stopFromToolSwitch(char)
        if not carpetOn or not char then return end
        local equipped = getEquippedTool(char)
        if equipped and not isSpeedBoostTool(equipped) then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0) end
            setCarpetSpeed(false)
        end
    end
    local function bindToolWatch(char)
        if toolConn then pcall(function() toolConn:Disconnect() end); toolConn = nil end
        if not char then return end
        toolConn = char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.defer(function() stopFromToolSwitch(char) end)
            end
        end)
    end

    LP.CharacterAdded:Connect(function(char)
        bindToolWatch(char)
        if carpetOn then
            task.defer(function()
                local hum = char:WaitForChild("Humanoid", 10)
                if hum and carpetOn then equipSpeedBoostToolOnce(char, hum) end
            end)
        end
    end)
    if LP.Character then bindToolWatch(LP.Character) end

    local function instantClone()
        local c = LP.Character
        if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return end
        local bp = LP:FindFirstChild("Backpack")
        local cl = (bp and bp:FindFirstChild("Quantum Cloner")) or c:FindFirstChild("Quantum Cloner")
        if not cl then return end
        pcall(function() h:UnequipTools() end); task.wait()
        if cl.Parent ~= c then pcall(function() h:EquipTool(cl) end); task.wait() end
        local tf = PG:FindFirstChild("ToolsFrames")
        local qc = tf and tf:FindFirstChild("QuantumCloner")
        local tb = qc and qc:FindFirstChild("TeleportToClone")
        if not tb then return end
        _G.isCloning = true
        pcall(function() cl:Activate() end)
        task.wait(0.05)
        tb.Visible = true
        pcall(function() firesignal(tb.MouseButton1Click) end)
        pcall(function() firesignal(tb.MouseButton1Up) end)
        pcall(function() firesignal(tb.Activated) end)
        task.delay(0.55, function() _G.isCloning = false end)
    end
    _G.instantClone = instantClone

    local floatOn, floatPart, floatConn = false, nil, nil

    local function removeFloatPlatform()
        if floatConn then floatConn:Disconnect(); floatConn = nil end
        if floatPart then pcall(function() floatPart:Destroy() end); floatPart = nil end
    end

    local function createFloatPlatform()
        removeFloatPlatform()
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local p = Instance.new("Part")
        p.Size = Vector3.new(7, 1, 7)
        p.Anchored = true; p.CanCollide = true
        p.CanTouch = false; p.CanQuery = false
        p.Transparency = 1; p.CastShadow = false
        p.CFrame = CFrame.new(hrp.Position - Vector3.new(0, 3.35, 0))
        p.Parent = workspace
        floatPart = p
        floatConn = RunService.Heartbeat:Connect(function()
            if not floatOn then return end
            local ch = LP.Character
            local h = ch and ch:FindFirstChild("HumanoidRootPart")
            if h and floatPart then
                floatPart.CFrame = CFrame.new(h.Position - Vector3.new(0, 3.35, 0))
            end
        end)
    end

    local function setFloat(on)

        if on and LP:GetAttribute("Stealing") then
            if refreshUI then refreshUI() end
            return
        end
        floatOn = on
        if on then createFloatPlatform() else removeFloatPlatform() end
        if refreshUI then refreshUI() end
    end
    _G.setFloat = setFloat
    _G.toggleFloat = function() setFloat(not floatOn) end

    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        if floatOn and LP:GetAttribute("Stealing") then setFloat(false) end
    end)

    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if floatOn then removeFloatPlatform(); createFloatPlatform() end
    end)

    local kbCfg = _G.HubCfg.get("carpet")
    local panelFrame
    local binds = {
        { id = "carpet", label = "Carpet Speed",
          key = (type(_G.HazhubCarpetSpeedKeyName) == "string" and _G.HazhubCarpetSpeedKeyName) or "Q",
          run = function() setCarpetSpeed(not carpetOn) end },
        { id = "clone",  label = "Instant Clone",
          key = (type(_G.HazhubCloneKeyName) == "string" and _G.HazhubCloneKeyName) or "V",
          run = function() task.spawn(instantClone) end },
        { id = "float",  label = "Float", key = "Z",
          run = function() setFloat(not floatOn) end },

        { id = "reset",  label = "Fling Up", key = "X",
          run = function() if _G.FlingUp then task.spawn(_G.FlingUp) end end },
        { id = "invis",  label = "Invisible Steal", key = "U",
          run = function() if _G.toggleInvisibleSteal then pcall(_G.toggleInvisibleSteal) end end },
        { id = "walkspeed", label = "WalkSpeed", key = "H",
          run = function()
              if _G.setWalkSpeedEnabled then
                  _G.HazhubWSEnabled = not _G.HazhubWSEnabled
                  _G.setWalkSpeedEnabled(_G.HazhubWSEnabled)
              end
          end },
        { id = "drop",   label = "Drop Brainrot", key = "G",
          run = function() if _G.HazhubDropBrainrot then pcall(_G.HazhubDropBrainrot) end end },
        { id = "faceaway", label = "Face Away", key = "F",
          run = function() if _G.HazhubToggleFaceAway then pcall(_G.HazhubToggleFaceAway) end end },
        { id = "kick",   label = "Kick", key = "Y",
          run = function() if _G.HazhubKick then pcall(_G.HazhubKick) end end },
        { id = "autobuy", label = "Auto Buy", key = "K",
          run = function() if _G.HazhubToggleAutoBuy then pcall(_G.HazhubToggleAutoBuy) end end },

        { id = "joinqueue", label = "Join Queue", key = "J",
          run = function()
              if _G.HazhubToggleJoinQueue then pcall(_G.HazhubToggleJoinQueue) end
              if _G.HazhubRefreshJoinQueueBtn then pcall(_G.HazhubRefreshJoinQueueBtn) end
          end },

        { id = "flashtp", label = "Flash TP", key = "T",
          run = function()
              task.spawn(function()
                  local Players = game:GetService("Players")
                  local LP = Players.LocalPlayer
                  local char = LP.Character
                  local hum = char and char:FindFirstChildOfClass("Humanoid")
                  if not char or not hum then return end
                  local TOOL_NAME = _G.HazhubFlashTPTool or "Flash Teleport"
                  local tool = char:FindFirstChild(TOOL_NAME)
                      or (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild(TOOL_NAME))
                  if not tool or not tool:IsA("Tool") then return end
                  if tool.Parent ~= char then
                      pcall(function() hum:EquipTool(tool) end)
                      task.wait(0.05)
                  end
                  pcall(function() tool:Activate() end)
              end)
          end },
        { id = "menu",   label = "Main Menu", key = "LeftControl",
          run = function() if panelFrame then panelFrame.Visible = not panelFrame.Visible end end },
    }
    local panelX, panelY = 240, 120

    do
        for _, b in ipairs(binds) do
            if type(kbCfg[b.id]) == "string" and #kbCfg[b.id] > 0 then b.key = kbCfg[b.id] end
        end

        if tonumber(kbCfg.x) then panelX = tonumber(kbCfg.x) end
        if tonumber(kbCfg.y) then panelY = tonumber(kbCfg.y) end

        if tonumber(kbCfg.buyRange) then
            local r = math.clamp(math.floor(tonumber(kbCfg.buyRange)), 5, 150)
            _G.HazhubAutoBuyFireRange = r
            _G.HazhubAutoBuyRange     = r
        end
    end
    local function saveKb()
        kbCfg.x = panelX; kbCfg.y = panelY
        for _, b in ipairs(binds) do kbCfg[b.id] = b.key end
        _G.HubCfg.save()
    end

    local capturing = nil

    local VK_XBUTTON1, VK_XBUTTON2 = 0x05, 0x06
    local function _norm(s)
        if type(s) ~= "string" or s == "" then return nil end
        if string.find(s, ":", 1, true) then return s end
        return "Key:" .. s
    end
    local function _bindPretty(s)
        local n = _norm(s); if not n then return "NONE" end
        local kind, name = string.match(n, "^([^:]+):(.+)$")
        if kind == "Mouse" then
            local map = { MouseButton1="MB1", MouseButton2="MB2", MouseButton3="MB3",
                          MouseButton4="MB4", XButton1="MB4", MouseButton5="MB5", XButton2="MB5" }
            return map[name] or name
        end
        return name or n
    end
    local function _isMouseBtn(input)
        local nm = input.UserInputType and input.UserInputType.Name
        return nm == "MouseButton1" or nm == "MouseButton2" or nm == "MouseButton3"
            or nm == "MouseButton4" or nm == "MouseButton5"
    end
    local function _inputMatches(input, bind)
        bind = _norm(bind); if not bind then return false end
        local kind, name = string.match(bind, "^([^:]+):(.+)$")
        if kind == "Key" then
            return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == name
        elseif kind == "Mouse" then
            return input.UserInputType.Name == name
        end
        return false
    end
    local function _vkDown(vk)
        for _, fn in ipairs({ iskeydown, iskeypressed }) do
            if typeof(fn) == "function" then local ok, r = pcall(fn, vk); if ok and r then return true end end
        end
        if typeof(getkeystate) == "function" then
            local ok, r = pcall(getkeystate, vk)
            if ok then
                if r == true then return true end
                if type(r) == "number" and (r < 0 or (bit32 and bit32.band(r, 0x8000) ~= 0)) then return true end
            end
        end
        return false
    end
    local function _sideDown(side)
        local name = "MouseButton" .. tostring(side)
        local ok, uit = pcall(function() return Enum.UserInputType[name] end)
        if ok and uit then local ok2, p = pcall(function() return UIS:IsMouseButtonPressed(uit) end); if ok2 and p then return true end end
        local okk, kc = pcall(function() return Enum.KeyCode[name] end)
        if okk and kc then
            local ok2, p = pcall(function() return UIS:IsKeyDown(kc) end); if ok2 and p then return true end
            if typeof(iskeydown) == "function" then local ok3, p3 = pcall(iskeydown, kc); if ok3 and p3 then return true end end
        end
        return _vkDown(side == 5 and VK_XBUTTON2 or VK_XBUTTON1)
    end
    local function _bindIsSide(bind, side)
        bind = _norm(bind); if not bind then return false end
        local want = "Mouse:MouseButton" .. tostring(side)
        if bind == want then return true end
        if side == 4 and (bind == "Mouse:XButton1" or bind == "Mouse:MB4") then return true end
        if side == 5 and (bind == "Mouse:XButton2" or bind == "Mouse:MB5") then return true end
        return false
    end

    local function _onSide(side)
        if capturing then
            local b = capturing; capturing = nil
            b.key = "Mouse:MouseButton" .. tostring(side); saveKb()
            if b.refresh then b.refresh() end
            return
        end
        for _, b in ipairs(binds) do
            if _bindIsSide(b.key, side) then b.run(); return end
        end
    end

    UIS.InputBegan:Connect(function(input, gameProcessed)

        if capturing then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local b = capturing; capturing = nil
                local nm = input.KeyCode.Name
                if nm ~= "Escape" then b.key = "Key:" .. nm; saveKb() end
                if b.refresh then b.refresh() end
            elseif _isMouseBtn(input) and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                local b = capturing; capturing = nil
                b.key = "Mouse:" .. input.UserInputType.Name; saveKb()
                if b.refresh then b.refresh() end
            end
            return
        end

        for _, b in ipairs(binds) do
            if not (_bindIsSide(b.key, 4) or _bindIsSide(b.key, 5)) and _inputMatches(input, b.key) then

                if b.id ~= "reset" and b.id ~= "menu" and gameProcessed then return end
                b.run()
                return
            end
        end
    end)

    do
        local prev4, prev5 = false, false
        game:GetService("RunService").Heartbeat:Connect(function()
            local need = capturing ~= nil
            if not need then
                for _, b in ipairs(binds) do
                    if _bindIsSide(b.key, 4) or _bindIsSide(b.key, 5) then need = true; break end
                end
            end
            if not need then prev4, prev5 = false, false; return end
            local d4, d5 = _sideDown(4), _sideDown(5)
            if d4 and not prev4 then _onSide(4) end
            if d5 and not prev5 then _onSide(5) end
            prev4, prev5 = d4, d5
        end)
    end

    pcall(function()
        local old = guiParent:FindFirstChild("CarpetCloneUI")
        if old then old:Destroy() end
    end)
    local sg = Instance.new("ScreenGui")
    sg.Name = "HazhubKeybindsUI"; sg.ResetOnSpawn = false; sg.DisplayOrder = 129
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = PG end

    local ROWH = 28
    local ay = #binds * ROWH + 6
    local f, body = UI.panel({
        name = "Panel", title = "HAZHUB KEYBINDS", w = 214,
        h = 36 + ay + 3 * 44 + 6,
        x = panelX, y = panelY, parent = sg,
        onDrop = function(fr)
            panelX, panelY = fr.AbsolutePosition.X, fr.AbsolutePosition.Y
            saveKb()
        end,
    })
    panelFrame = f
    f.Visible = false

    do
        local gearGui = Instance.new("ScreenGui")
        gearGui.Name = "HazhubGearIcon"; gearGui.ResetOnSpawn = false
        gearGui.IgnoreGuiInset = true; gearGui.DisplayOrder = 130
        pcall(function() gearGui.Parent = guiParent end)
        if not gearGui.Parent then gearGui.Parent = PG end
        local gear = UI.smallButton({ parent = gearGui, w = 34, h = 34, text = "\u{2699}", textSize = 20,
            onClick = function()
                if panelFrame then panelFrame.Visible = not panelFrame.Visible end
            end })
        gear.Position = UDim2.new(1, -44, 0, 10)

        gear.BackgroundTransparency = 1
        gear.TextTransparency = 1
        gear.AutoButtonColor = false
        for _, c in ipairs(gear:GetChildren()) do
            if c:IsA("UIStroke") then c:Destroy() end
        end
    end

    for i, b in ipairs(binds) do
        local y = (i - 1) * ROWH
        local row = UI.row({ parent = body, y = y, h = 24 })
        UI.label({ parent = row, x = 8, y = 0, w = 110, h = 24, text = b.label, size = 11 })

        local kb = UI.smallButton({ parent = row, pos = UDim2.new(1, -78, 0, 3), w = 72, h = 18, textSize = 11 })

        b.refresh = function()
            kb.Text = _bindPretty(b.key)

            local on = (b.id == "carpet" and carpetOn) or (b.id == "float" and floatOn)
                or (b.id == "faceaway" and _G.HazhubFaceAwayOn == true)
            kb.BackgroundColor3 = on and UI.C.BTN_ON or UI.C.BTN
        end
        b.refresh()

        kb.MouseButton1Click:Connect(function()
            if capturing and capturing.refresh then capturing.refresh() end
            capturing = b
            kb.Text = "..."
            kb.BackgroundColor3 = UI.C.ACCENT2
        end)
    end

    UI.slider({ parent = body, y = ay, label = "FOV", min = 50, max = 120, step = 5,
        get = function() return tonumber(_G.HazhubFOV) or 70 end,
        set = function(v) if _G.setFOV then _G.setFOV(v) end end,
        onChange = function(v, final) if final then saveKb() end end })

    do
        local AB_MIN, AB_MAX = 5, 150
        local R0 = tonumber(kbCfg.buyRange)
        if not R0 then R0 = 60 end
        R0 = math.clamp(math.floor(R0), AB_MIN, AB_MAX)

        local function apply(v, persist)
            v = math.clamp(math.floor(v + 0.5), AB_MIN, AB_MAX)
            _G.HazhubAutoBuyFireRange = v
            _G.HazhubAutoBuyRange     = v
            if persist then kbCfg.buyRange = v; pcall(_G.HubCfg.save) end
        end
        apply(R0, false)

        UI.slider({ parent = body, y = ay + 44, label = "Buy Range (studs)", min = AB_MIN, max = AB_MAX, step = 1,
            get = function() return tonumber(_G.HazhubAutoBuyFireRange) or R0 end,
            set = function(v) apply(v, false) end,

            onChange = function(v, final) if final then apply(v, true) end end })
    end

    do
        local XR_MIN, XR_MAX = 0, 100

        local a0 = tonumber(kbCfg.xrayAlpha)
        if not a0 then a0 = tonumber(_G.XRayAlpha) or 0.60 end
        local P0 = math.clamp(math.floor(a0 * 100 + 0.5), XR_MIN, XR_MAX)

        local reapplyPending = false
        local function scheduleReapply()
            if reapplyPending then return end
            reapplyPending = true
            task.delay(0.12, function()
                reapplyPending = false
                if type(_G.setXRay) == "function" and _G.XRayEnabled then
                    pcall(_G.setXRay, true)
                end
            end)
        end

        local function apply(p, persist)
            p = math.clamp(math.floor(p + 0.5), XR_MIN, XR_MAX)
            _G.XRayAlpha = p / 100
            scheduleReapply()
            if persist then kbCfg.xrayAlpha = _G.XRayAlpha; pcall(_G.HubCfg.save) end
        end

        _G.XRayAlpha = P0 / 100
        scheduleReapply()

        UI.slider({ parent = body, y = ay + 88, label = "X-Ray %", min = XR_MIN, max = XR_MAX, step = 1,
            get = function() return math.floor((tonumber(_G.XRayAlpha) or 0.60) * 100 + 0.5) end,
            set = function(p) apply(p, false) end,
            onChange = function(p, final) if final then apply(p, true) end end })
    end

    refreshUI = function()
        for _, b in ipairs(binds) do if b.refresh then pcall(b.refresh) end end
    end

end)

if not okCC then warn("[CARPET/CLONE] BLOC EN ERREUR: " .. tostring(errCC)) end
end)

stagSpawn(function()
local okZ, errZ = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    _G.UnlockZoom = true

    local _zoomLast = 0
    RunService.RenderStepped:Connect(function()
        if not _G.UnlockZoom then return end

        local now = os.clock()
        if now - _zoomLast < 0.4 then return end
        _zoomLast = now
        pcall(function()
            if LP.CameraMaxZoomDistance ~= 128 then
                LP.CameraMaxZoomDistance = 128
            end
            if LP.CameraMinZoomDistance > 0.5 then
                LP.CameraMinZoomDistance = 0.5
            end
            if LP.DevCameraOcclusionMode ~= Enum.DevCameraOcclusionMode.Invisicam then
                LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
            end
        end)
    end)
end)

if not okZ then warn("[ZOOM] BLOC EN ERREUR: " .. tostring(errZ)) end
end)

nowSpawn(function()
    task.wait(4)
local okAK, errAK = pcall(function()
    local Players         = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")
    local HS              = game:GetService("HttpService")
    local LP              = Players.LocalPlayer
    local PG              = LP:WaitForChild("PlayerGui")
    local guiParent       = (gethui and gethui()) or game:GetService("CoreGui") or PG

    local cfg = _G.HubCfg.get("autokick")
    if _G.AutoKickOnSteal == nil then _G.AutoKickOnSteal = true end
    if _G.AutoKickKeyword == nil then _G.AutoKickKeyword = "you stole" end
    if _G.HazhubPrivateCode == nil then _G.HazhubPrivateCode = "" end

    _G.HazhubKickAfterBuy = true
    local panelX, panelY = 240, 300
    do
        if type(cfg.on) == "boolean" then _G.AutoKickOnSteal = cfg.on end
        if tonumber(cfg.x) then panelX = tonumber(cfg.x) end
        if tonumber(cfg.y) then panelY = tonumber(cfg.y) end
        if type(cfg.psCode) == "string" then _G.HazhubPrivateCode = cfg.psCode end
    end
    local function saveCfg()
        cfg.on = _G.AutoKickOnSteal; cfg.x = panelX; cfg.y = panelY
        cfg.psCode = _G.HazhubPrivateCode
        _G.HubCfg.save()
    end

    local fired = false
    local function doKick()
        if fired then return end
        fired = true

        local code = _G.HazhubPrivateCode
        if type(code) == "string" and code ~= "" then
            task.delay(0.2, function()
                pcall(function()
                    game:GetService("ExperienceService"):LaunchExperience({
                        placeId = game.PlaceId,
                        linkCode = code,
                    })
                end)
            end)
            return
        end
        pcall(function() game:Shutdown() end)
        pcall(function() LP:Kick("\nAuto Kick") end)
    end

    _G.HazhubDoAutoKick = doKick

    local function check(txt)
        if not _G.AutoKickOnSteal then return end
        if type(txt) ~= "string" or txt == "" then return end
        local kw = tostring(_G.AutoKickKeyword or "you stole")
        if string.find(string.lower(txt), kw, 1, true) then doKick() end
    end

    local hooked = setmetatable({}, { __mode = "k" })
    local function hookObj(obj)
        if hooked[obj] then return end
        hooked[obj] = true
        check(obj.Text)
        obj:GetPropertyChangedSignal("Text"):Connect(function() check(obj.Text) end)
    end

    local function isText(o)
        return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")
    end

    local function watchRoot(root)
        for _, obj in ipairs(root:GetDescendants()) do
            if isText(obj) then hookObj(obj) end
        end
        root.DescendantAdded:Connect(function(desc)
            if isText(desc) then hookObj(desc) end
        end)
    end

    for _, g in ipairs(PG:GetChildren()) do pcall(watchRoot, g) end
    PG.ChildAdded:Connect(function(g) pcall(watchRoot, g) end)

    local function rejoin()
        local jobId = game.JobId
        task.spawn(function()
            if not jobId or jobId == "" then return end
            for _ = 1, 4 do
                local ok = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LP)
                end)
                if ok then break end
                task.wait(1.5)
            end
        end)
    end
    _G.Rejoin = rejoin

    pcall(function()
        local old = guiParent:FindFirstChild("AutoKickUI")
        if old then old:Destroy() end
    end)
    local sg = Instance.new("ScreenGui")
    sg.Name = "HazhubUtilityUI"; sg.ResetOnSpawn = false; sg.DisplayOrder = 131
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = PG end

    local f, body = UI.panel({
        name = "Panel", title = "HAZHUB UTILITY", w = 180, h = 160,
        x = panelX, y = panelY, parent = sg,
        onDrop = function(fr)
            panelX, panelY = fr.AbsolutePosition.X, fr.AbsolutePosition.Y
            saveCfg()
        end,
    })

    local b, setOnAK = UI.button({ parent = body, y = 0 })
    b.Size = UDim2.new(1, -44, 0, UI.BTN_H)
    local function refresh()
        b.Text = "AUTO KICK" .. (_G.AutoKickOnSteal and ": ON" or ": OFF")
        setOnAK(_G.AutoKickOnSteal)
    end
    b.MouseButton1Click:Connect(function()
        _G.AutoKickOnSteal = not _G.AutoKickOnSteal
        refresh(); saveCfg()
    end)
    refresh()

    local rb
    rb = UI.button({ parent = body, y = 30, text = "REJOIN", onClick = function()
        rb.Text = "REJOIN..."
        rejoin()
    end })

    local jq, setOnJQ = UI.button({ parent = body, y = 60, text = "JOIN QUEUE: OFF" })
    local function refreshJQ()
        local on = _G.HazhubJoinQueueEnabled == true
        jq.Text = "JOIN QUEUE" .. (on and ": ON" or ": OFF")
        setOnJQ(on)
    end
    refreshJQ()
    _G.HazhubRefreshJoinQueueBtn = refreshJQ
    jq.MouseButton1Click:Connect(function()
        if _G.HazhubToggleJoinQueue then pcall(_G.HazhubToggleJoinQueue) end
        refreshJQ()
    end)

    local jqTok = 0
    _G.HazhubJoinQueueStatus = function(text, isError)
        jqTok = jqTok + 1
        local myTok = jqTok
        jq.Text = tostring(text)
        task.delay(2.5, function()
            if jqTok == myTok then refreshJQ() end
        end)
    end

    local kb = UI.button({ parent = body, y = 90, text = "KICK", onClick = function()
        pcall(function() LP:Kick("\nHazhub") end)
    end })
    kb.Size = UDim2.new(0.5, -UI.PAD - 2, 0, UI.BTN_H)
    kb.TextColor3 = UI.C.DANGER
    kb.BackgroundColor3 = UI.C.BG

    local AJ_FILE = "EXEC_AJ_SCRIPT.txt"
    local function ajLoad()
        if readfile then
            local ok, src = pcall(readfile, AJ_FILE)
            if ok and type(src) == "string" and src:match("%S") then return src end
        end
        return ""
    end
    local function ajSave(src)
        if not writefile then return false end
        return pcall(writefile, AJ_FILE, src)
    end
    local ajScript = ajLoad()
    local ajBusy, ajActive = false, false
    local aj
    aj = UI.button({ parent = body, y = 90, text = "AJ", onClick = function()
        if ajBusy or ajActive then return end
        ajBusy = true
        aj.Text = "LOADING..."
        task.spawn(function()
            local ok, err = pcall(function()
                if type(ajScript) ~= "string" or not ajScript:match("%S") then
                    error("no saved script (gear -> AJ SCRIPT)")
                end
                local chunk, cerr = loadstring(ajScript)
                if not chunk then error(cerr or "compile error") end
                chunk()
            end)
            ajBusy = false
            if ok then
                ajActive = true
                aj.Text = "AJ: ACTIVE"
                aj.BackgroundColor3 = UI.C.BTN_ON
            else
                aj.Text = "AJ: RETRY"
                aj.BackgroundColor3 = UI.C.DANGER
                UI.notify("AJ", tostring(err), true)
                task.delay(1.5, function()
                    if not ajActive and aj.Parent then
                        aj.Text = "AJ"; aj.BackgroundColor3 = UI.C.BTN
                    end
                end)
            end
        end)
    end })
    aj.Size = UDim2.new(0.5, -UI.PAD - 2, 0, UI.BTN_H)
    aj.Position = UDim2.new(0.5, 2, 0, 90)

    local pop = Instance.new("Frame", f)
    pop.Size = UDim2.fromOffset(180, 196)
    pop.Position = UDim2.fromOffset(0, 164)
    pop.BackgroundColor3 = UI.C.PANEL
    pop.BorderSizePixel = 0; pop.Active = true; pop.Visible = false
    UI.corner(pop, 10); UI.stroke(pop)

    local pt = UI.label({ parent = pop, x = 0, y = 4, h = 20, bold = true, size = 11,
        text = "PRIVATE SERVER CODE", align = Enum.TextXAlignment.Center })
    pt.Size = UDim2.new(1, 0, 0, 20)

    local tb = Instance.new("TextBox", pop)
    tb.Size = UDim2.fromOffset(134, 24); tb.Position = UDim2.fromOffset(8, 26)
    tb.BackgroundColor3 = UI.C.BG
    tb.TextColor3 = UI.C.TEXT; tb.BorderSizePixel = 0
    tb.Font = UI.FONT; tb.TextSize = 11
    tb.ClearTextOnFocus = false
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.PlaceholderText = "A219012DJF"
    tb.PlaceholderColor3 = UI.C.MUTED
    tb.Text = _G.HazhubPrivateCode or ""
    UI.corner(tb, 6); UI.stroke(tb)
    do
        local p = Instance.new("UIPadding", tb)
        p.PaddingLeft = UDim.new(0, 6); p.PaddingRight = UDim.new(0, 6)
    end

    local reveal = false
    local dots = Instance.new("TextLabel", pop)
    dots.Size = tb.Size; dots.Position = tb.Position
    dots.BackgroundTransparency = 1
    dots.Font = tb.Font; dots.TextSize = tb.TextSize
    dots.TextColor3 = tb.TextColor3
    dots.TextXAlignment = Enum.TextXAlignment.Left
    dots.Text = ""
    do
        local p = Instance.new("UIPadding", dots)
        p.PaddingLeft = UDim.new(0, 6); p.PaddingRight = UDim.new(0, 6)
    end

    local function renderMask()
        local has = #tb.Text > 0
        if reveal or not has then
            tb.TextTransparency = 0
            dots.Visible = false
        else
            tb.TextTransparency = 1
            dots.Visible = true
            dots.Text = string.rep("\u{2022}", #tb.Text)
        end
    end
    tb:GetPropertyChangedSignal("Text"):Connect(renderMask)
    renderMask()

    local eye = UI.smallButton({ parent = pop, x = 146, y = 26, w = 26, h = 24, text = "\u{1F441}", textSize = 13 })
    eye.MouseButton1Click:Connect(function()
        reveal = not reveal
        eye.BackgroundColor3 = reveal and UI.C.BTN_ON or UI.C.BTN
        renderMask()
    end)

    tb.FocusLost:Connect(function()
        _G.HazhubPrivateCode = tb.Text
        saveCfg()
    end)

    local sep = Instance.new("Frame", pop)
    sep.Size = UDim2.new(1, -16, 0, 1); sep.Position = UDim2.fromOffset(8, 58)
    sep.BackgroundColor3 = UI.C.STROKE; sep.BorderSizePixel = 0

    local at = UI.label({ parent = pop, x = 0, y = 62, h = 20, bold = true, size = 11,
        text = "AJ SCRIPT", align = Enum.TextXAlignment.Center })
    at.Size = UDim2.new(1, 0, 0, 20)

    local ajBox = UI.textbox({ parent = pop, x = 8, y = 84, h = 72, placeholder = "paste your script / key here...",
        text = ajScript })
    ajBox.Size = UDim2.fromOffset(164, 72)
    ajBox.MultiLine = true; ajBox.TextWrapped = true
    ajBox.TextYAlignment = Enum.TextYAlignment.Top
    ajBox.Font = Enum.Font.Code; ajBox.TextSize = 10
    do
        local p = ajBox:FindFirstChildOfClass("UIPadding")
        if p then p.PaddingTop = UDim.new(0, 5); p.PaddingRight = UDim.new(0, 6) end
    end

    UI.smallButton({ parent = pop, x = 8, y = 162, w = 164, h = 24, text = "SAVE", textSize = 11,
        onClick = function()
            local src = tostring(ajBox.Text or "")
            if not src:match("%S") then
                UI.notify("AJ", "script is empty", true)
                return
            end
            if ajSave(src) then
                ajScript = src
                UI.notify("AJ", "saved")
            else
                UI.notify("AJ", "save error", true)
            end
        end })

    UI.smallButton({ parent = body, x = 148, y = 0, w = 24, h = UI.BTN_H, text = "⚙️", textSize = 14,
        onClick = function() pop.Visible = not pop.Visible end })
end)

if not okAK then warn("[AUTOKICK] BLOC EN ERREUR: " .. tostring(errAK)) end
end)

nowSpawn(function()
    task.wait(4)
local okJQ, errJQ = pcall(function()
    local TeleportService = game:GetService("TeleportService")
    local Players         = game:GetService("Players")
    local hasES, ExperienceService = pcall(function() return game:GetService("ExperienceService") end)
    if not hasES then ExperienceService = nil end

    local MAX_ATTEMPTS = 5
    local RETRY_DELAY  = 3
    local MIN_INTERVAL = 3
    local RAW_INTERVAL = 2

    local enabled = false
    local hooked  = false
    local bypass  = false
    local launchGen = 0
    local activeJobId = nil
    local lastAttemptAt = 0
    local lastRawAt = 0
    local oldNamecall
    local oldTeleportToPlaceInstance

    local function setStatus(text, isError)
        if type(_G.HazhubJoinQueueStatus) == "function" then
            pcall(_G.HazhubJoinQueueStatus, tostring(text), isError and true or false)
        end
    end

    local function cleanJobId(jobId)
        jobId = tostring(jobId or "")
        return (jobId:gsub("[%s\"'{}%[%]]", ""))
    end

    local function shouldDropRaw()
        if os.clock() - lastRawAt < RAW_INTERVAL then return true end
        lastRawAt = os.clock()
        return false
    end

    local function rawTeleport(placeId, jobId)
        bypass = true
        local ok, err = pcall(function()
            if oldTeleportToPlaceInstance then
                oldTeleportToPlaceInstance(TeleportService, placeId, jobId, Players.LocalPlayer)
            else
                TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
            end
        end)
        bypass = false
        return ok, err
    end

    local function attemptOnce(placeId, jobId)
        if ExperienceService then
            return pcall(function()
                return ExperienceService:LaunchExperience({ placeId = placeId, gameInstanceId = jobId })
            end)
        end
        return rawTeleport(placeId, jobId)
    end

    local function launch(placeId, jobId)
        placeId = tonumber(placeId)
        jobId = cleanJobId(jobId)
        if not placeId or placeId == 0 then placeId = game.PlaceId end
        if jobId == "" then setStatus("No JobId given", true); return false end

        if jobId == activeJobId then return true end
        activeJobId = jobId
        launchGen = launchGen + 1
        local myGen = launchGen
        task.spawn(function()
            for attempt = 1, MAX_ATTEMPTS do
                if launchGen ~= myGen then return end
                local cool = MIN_INTERVAL - (os.clock() - lastAttemptAt)
                if cool > 0 then task.wait(cool) end
                if launchGen ~= myGen then return end
                lastAttemptAt = os.clock()
                setStatus(("Launching... (%d/%d)"):format(attempt, MAX_ATTEMPTS), false)
                local ok, err = attemptOnce(placeId, jobId)
                if ok then setStatus("Queued / launching", false); return end
                warn("[JoinQueue] attempt " .. attempt .. " failed: " .. tostring(err))
                setStatus(tostring(err), true)
                task.wait(RETRY_DELAY)
            end
            if launchGen ~= myGen then return end
            setStatus("Gave up, waiting next id", true)
            activeJobId = nil
        end)
        return true
    end

    TeleportService.TeleportInitFailed:Connect(function(_, result, message)
        warn("[JoinQueue] teleport failed: " .. tostring(result) .. " - " .. tostring(message))
        setStatus(tostring(result) .. ": " .. tostring(message), true)
    end)

    local function installHook()
        if hooked then return end
        hooked = true
        if hookfunction then
            oldTeleportToPlaceInstance = hookfunction(
                TeleportService.TeleportToPlaceInstance,
                newcclosure(function(self, placeId, jobId, ...)

                    if enabled and not bypass then launch(placeId, jobId); return end
                    return oldTeleportToPlaceInstance(self, placeId, jobId, ...)
                end)
            )
        end
        if hookmetamethod and getnamecallmethod then
            oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if enabled and not bypass and self == TeleportService
                    and (method == "TeleportToPlaceInstance" or method == "TeleportAsync") then
                    local args = { ... }
                    if method == "TeleportToPlaceInstance" then
                        launch(args[1], args[2]); return
                    end
                    local options = args[3]
                    local jobId = options and options.ServerInstanceId
                    if jobId and jobId ~= "" then launch(args[1], jobId); return end
                end
                return oldNamecall(self, ...)
            end))
        end
    end

    _G.HazhubJoinQueueEnabled = false
    local function setEnabled(state)
        enabled = state and true or false
        _G.HazhubJoinQueueEnabled = enabled
        if enabled then

            installHook()
        else
            launchGen = launchGen + 1; activeJobId = nil
        end
    end
    _G.HazhubSetJoinQueue = setEnabled
    _G.HazhubToggleJoinQueue = function() setEnabled(not enabled); return enabled end

end)
if not okJQ then warn("[JOINQUEUE] BLOC EN ERREUR: " .. tostring(errJQ)) end
end)

stagSpawn(function()
local okUL, errUL = pcall(function()
    local Players = game:GetService("Players")
    local LP      = Players.LocalPlayer

    if _G.AutoUnlockOnSteal == nil then _G.AutoUnlockOnSteal = true end

    local function getUnlockHRP()
        local c = LP.Character
        if not c then return end
        return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")
    end

    local function smartInteract(number)
        local hrp = getUnlockHRP()
        if not hrp then return end
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        local closestPlot, minDistance = nil, 40
        for _, plot in pairs(plots:GetChildren()) do
            local ok, plotPos = pcall(function()
                if plot:IsA("Model") then
                    return plot.PrimaryPart and plot.PrimaryPart.Position or plot:GetPivot().Position
                else
                    return plot.Position
                end
            end)
            if ok and plotPos then
                local dist = (hrp.Position - plotPos).Magnitude
                if dist < minDistance then
                    closestPlot = plot; minDistance = dist
                end
            end
        end
        if closestPlot and closestPlot:FindFirstChild("Unlock") then
            local items = {}
            for _, item in pairs(closestPlot.Unlock:GetChildren()) do
                local pos = item:IsA("Model") and item:GetPivot().Position or item.Position
                table.insert(items, { Obj = item, Y = pos.Y })
            end
            table.sort(items, function(a, b) return a.Y < b.Y end)
            if items[number] then
                for _, pr in pairs(items[number].Obj:GetDescendants()) do
                    if pr:IsA("ProximityPrompt") then
                        pcall(function() fireproximityprompt(pr) end)
                    end
                end
            end
        end
    end

    local function getCurrentUnlockFloor()
        local hrp = getUnlockHRP()
        if not hrp then return 1 end
        return (hrp.Position.Y < 12) and 1 or 2
    end

    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        if not _G.AutoUnlockOnSteal then return end
        if LP:GetAttribute("Stealing") ~= true then return end
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local floor = getCurrentUnlockFloor()
        task.spawn(function()
            task.wait(0.1)
            pcall(smartInteract, floor)
        end)
    end)
end)

if not okUL then warn("[AUTOUNLOCK] BLOC EN ERREUR: " .. tostring(errUL)) end
end)

stagSpawn(function()
local okESP, errESP = pcall(function()

    if _G.SubspaceMineESP == nil then _G.SubspaceMineESP = true end
    local mineData = {}

    local function refreshMineESP()
        local tools = workspace:FindFirstChild("ToolsAdds")
        if not tools then return end
        local current = {}
        for _, obj in ipairs(tools:GetChildren()) do
            if obj:IsA("BasePart") and obj.Name:match("SubspaceTripmine") then
                current[obj] = true
                if not mineData[obj] then
                    local owner = obj.Name:match("SubspaceTripmine(.+)") or "Unknown"
                    local sel = Instance.new("SelectionBox", obj)
                    sel.Color3 = Color3.fromRGB(180, 100, 255)
                    sel.LineThickness = 0.05
                    local bb = Instance.new("BillboardGui", obj)
                    bb.Size = UDim2.new(0, 250, 0, 50)
                    bb.StudsOffset = Vector3.new(0, 2.5, 0)
                    bb.AlwaysOnTop = false
                    local lbl = Instance.new("TextLabel", bb)
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = owner .. "'s Subspace Mine"
                    lbl.TextColor3 = Color3.fromRGB(180, 100, 255)
                    lbl.TextStrokeTransparency = 0
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 16
                    mineData[obj] = { sel = sel, bb = bb }
                end
            end
        end

        for obj, d in pairs(mineData) do
            if not current[obj] or not obj.Parent then
                pcall(function() d.sel:Destroy() end)
                pcall(function() d.bb:Destroy() end)
                mineData[obj] = nil
            end
        end
    end

    local function clearMineESP()
        for obj, d in pairs(mineData) do
            pcall(function() d.sel:Destroy() end)
            pcall(function() d.bb:Destroy() end)
            mineData[obj] = nil
        end
    end

    if _G.TimerESP == nil then _G.TimerESP = true end
    local TIMER_COLOR = Color3.fromRGB(255, 215, 0)

    local function clearTimerESP()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        for _, plot in ipairs(plots:GetChildren()) do
            for _, desc in ipairs(plot:GetDescendants()) do
                if desc.Name == "TimerESP" and desc:IsA("BillboardGui") then
                    pcall(function() desc:Destroy() end)
                end
            end
        end
    end
    _G.clearTimerESP = clearTimerESP

    local function refreshTimerESP()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        for _, plot in ipairs(plots:GetChildren()) do

            local found, minY = {}, math.huge
            for _, g in ipairs(plot:GetDescendants()) do
                if g:IsA("BillboardGui") and g:FindFirstChild("RemainingTime") then
                    local base = g.Adornee or g.Parent
                    if base and base:IsA("BasePart") then
                        found[#found + 1] = { g = g, base = base, y = base.Position.Y }
                        if base.Position.Y < minY then minY = base.Position.Y end
                    end
                end
            end
            for _, item in ipairs(found) do
                local base, g = item.base, item.g
                local existing = base:FindFirstChild("TimerESP")
                if item.y <= minY + 4 then
                    local rt = g:FindFirstChild("RemainingTime")
                    if rt then
                        if not existing then
                            local bb = Instance.new("BillboardGui")
                            bb.Name = "TimerESP"
                            bb.Adornee = base
                            bb.Size = UDim2.new(0, 98, 0, 26)
                            bb.AlwaysOnTop = true
                            bb.StudsOffsetWorldSpace = Vector3.new(0, 1.6, 0)
                            local lbl = Instance.new("TextLabel", bb)
                            lbl.Size = UDim2.new(1, 0, 1, 0)
                            lbl.BackgroundTransparency = 1
                            lbl.Text = rt.Text
                            lbl.Font = Enum.Font.GothamBold
                            lbl.TextSize = 15

                            lbl.TextColor3 = TIMER_COLOR
                            lbl.TextStrokeTransparency = 0
                            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            bb.Parent = base
                        else
                            local l = existing:FindFirstChildOfClass("TextLabel")
                            if l then
                                l.Text = rt.Text

                                if l.TextColor3 ~= TIMER_COLOR then
                                    l.TextColor3 = TIMER_COLOR
                                    l.TextStrokeTransparency = 0
                                end
                            end
                        end
                    end
                elseif existing then
                    pcall(function() existing:Destroy() end)
                end
            end
        end
    end

    task.spawn(function()
        while true do

            if not (_G._isTpMoving or _G.HazhubStealHold) then
                if _G.TimerESP then pcall(refreshTimerESP) else pcall(clearTimerESP) end
                if _G.SubspaceMineESP then pcall(refreshMineESP) else pcall(clearMineESP) end
            end
            task.wait(6)
        end
    end)
end)

if not okESP then warn("[ESP] BLOC EN ERREUR: " .. tostring(errESP)) end
end)

nowSpawn(function()
local okRS, errRS = pcall(function()
    local Players = game:GetService("Players")
    local LP      = Players.LocalPlayer
    local PG      = LP:WaitForChild("PlayerGui")

    local RUN = game:GetService("RunService")
    local RESET_TOKEN = "randomstring"
    local resetRemote, flooding = nil, false

    pcall(function() Players.RespawnTime = 0 end)

    local function resolveByName(name)
        if type(name) ~= "string" or name == "" then return nil end
        local Net = _G.Net
        if not Net then return nil end
        local ok, r = pcall(function() return Net:RemoteEvent(name) end)
        if ok and typeof(r) == "Instance" and r:IsA("RemoteEvent") then return r end
        return nil
    end
    local function looksLikeResetName(s)
        if type(s) ~= "string" then return false end
        local low = s:lower()
        return (low:find("activ") or low:find("reset") or low:find("respawn")
            or low:find("ragdoll") or low:find("balloon")) ~= nil
    end
    local function isResetRemote(v)
        return typeof(v) == "Instance" and v:IsA("RemoteEvent")
            and type(v.Name) == "string" and v.Name:match("^RE/%x") ~= nil
    end
    local function sourceName(f)
        local dd = debug or {}
        local src
        if dd.info then local ok, s = pcall(dd.info, f, "s"); if ok and type(s) == "string" then src = s end end
        if (not src) and dd.getinfo then local ok, info = pcall(dd.getinfo, f); if ok and type(info) == "table" then src = info.short_src or info.source end end
        if not src then
            local env; pcall(function() env = getfenv(f) end)
            if type(env) == "table" then local s2; pcall(function() s2 = env.script end); if typeof(s2) == "Instance" then src = s2.Name end end
        end
        if type(src) == "string" then return src:match("[%.>/\\]([%w_ ]+)$") or src end
        return nil
    end
    local function isToolCtrl(name)
        if type(name) ~= "string" then return false end
        return name == "ToolActivationController" or name:find("ToolActiv") ~= nil
            or name:find("Activation") ~= nil or name:find("ToolController") ~= nil
    end
    local function nameShaped(s)
        return type(s) == "string" and #s >= 2 and #s <= 60 and s:match("^[%w_/]+$") ~= nil
    end

    local _lastScan = -1e9
    local function findResetRemote(force)
        local ov = resolveByName(_G.hazhubResetRemoteName)
        if ov then _G.hazhubResetRemoteFoundName = _G.hazhubResetRemoteName; return ov end
        if not getgc then return nil end
        if (not force) and (os.clock() - _lastScan) < 5 then return nil end
        _lastScan = os.clock()
        local dd = debug or {}
        local getconsts, getups = dd.getconstants, dd.getupvalues
        local directRemote
        local nameSet = {}
        pcall(function()
            local gc = getgc(true)
            for i = 1, #gc do
                local f = gc[i]
                if type(f) == "function" and (not iscclosure or not iscclosure(f)) then
                    local src = sourceName(f)
                    if isToolCtrl(src) then
                        if getconsts then
                            local cs; pcall(function() cs = getconsts(f) end)
                            if type(cs) == "table" then
                                for _, c in pairs(cs) do
                                    if nameShaped(c) and looksLikeResetName(c) then nameSet[c] = true end
                                end
                            end
                        end
                        if getups and not directRemote then
                            local ups; pcall(function() ups = getups(f) end)
                            if type(ups) == "table" then
                                for _, u in pairs(ups) do
                                    if isResetRemote(u) then directRemote = u; break end
                                    if type(u) == "table" then
                                        local n = 0
                                        for _, vv in pairs(u) do
                                            if isResetRemote(vv) then directRemote = vv; break end
                                            n = n + 1; if n >= 200 then break end
                                        end
                                        if directRemote then break end
                                    end
                                end
                            end
                        end
                    end
                end
                if (i % 2000) == 0 then RUN.Heartbeat:Wait() end
            end
        end)
        if directRemote then _G.hazhubResetRemoteFoundName = directRemote.Name; return directRemote end
        local tryNames = {}
        for nm in pairs(nameSet) do tryNames[#tryNames + 1] = nm end
        table.sort(tryNames)
        for _, nm in ipairs(tryNames) do
            local r = resolveByName(nm)
            if r then _G.hazhubResetRemoteFoundName = nm; return r end
        end
        return nil
    end

    task.spawn(function()

        local tries = 0
        while not resetRemote do
            local r = findResetRemote(true)
            if r then resetRemote = r; break end
            tries = tries + 1
            task.wait(tries < 8 and 3 or 30)
        end
    end)

    local function voidDropReset(oldChar)
        local t0 = os.clock()
        local destroyY = tonumber(workspace.FallenPartsDestroyHeight) or -500
        while LP.Character == oldChar and (os.clock() - t0) < 6 do
            local h = oldChar and oldChar:FindFirstChild("HumanoidRootPart")
            if not h or not h.Parent then break end
            pcall(function()
                h.Anchored = false
                h.CFrame = CFrame.new(h.Position.X, destroyY - 60, h.Position.Z)
                h.AssemblyLinearVelocity = Vector3.new(0, -400, 0)
            end)
            task.wait()
        end
    end

    local function instantReset()
        if flooding then return end
        local plr = LP
        if not plr then return end
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        flooding = true
        _G.hazhubResetAt = os.clock()
        local prevAD = _G.AntiDieDisabled
        _G.AntiDieDisabled = true
        pcall(function() hum.BreakJointsOnDeath = true end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
        pcall(function() hum.Health = 0 end)
        task.spawn(function()
            local added = false
            local ac
            ac = plr.CharacterAdded:Connect(function()
                added = true
                if ac then ac:Disconnect() ac = nil end
            end)
            local t0 = os.clock()
            while not added and os.clock() - t0 < 5 do task.wait(0.05) end
            if ac then ac:Disconnect() ac = nil end
            _G.AntiDieDisabled = prevAD
            flooding = false
        end)
    end
    _G.InstantReset = instantReset
    _G.hazhubInstaReset = instantReset

    if _G.ResetFlingsUp == nil then _G.ResetFlingsUp = false end
    local FLING_POWER   = 99999999
    local FLING_SUSTAIN = 0.15
    local function flingUp()
        local RS = game:GetService("RunService")
        local char = LP.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")

        local hrp  = char and (char.PrimaryPart or char:FindFirstChild("HumanoidRootPart"))
        if not hrp or not hum or hum.Health <= 0 then return end

        _G.FlingActive = true

        pcall(function()
            hum.Sit = false
            hum.PlatformStand = true
            if hrp.Anchored then hrp.Anchored = false end
        end)

        local up = Vector3.new(0, FLING_POWER, 0)
        local t0 = os.clock()
        while os.clock() - t0 < FLING_SUSTAIN do
            char = LP.Character
            hum  = char and char:FindFirstChildOfClass("Humanoid")
            hrp  = char and (char.PrimaryPart or char:FindFirstChild("HumanoidRootPart"))
            if not hrp or not hum or hum.Health <= 0 then break end
            if hrp.Anchored then hrp.Anchored = false end
            hrp.AssemblyLinearVelocity = up
            hrp.Velocity = up
            RS.Heartbeat:Wait()
        end

        pcall(function()
            if hum and hum.Parent then
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
        _G.FlingActive = false
    end
    _G.FlingUp = flingUp

    local be = Instance.new("BindableEvent")
    be.Event:Connect(function()
        if _G.ResetFlingsUp then
            pcall(flingUp)
        else
            pcall(instantReset)
        end
    end)
    task.spawn(function()
        for _ = 1, 12 do
            local ok = pcall(function()
                game:GetService("StarterGui"):SetCore("ResetButtonCallback", be)
            end)
            if ok then break end
            task.wait(1)
        end
    end)

    local lastBalloonResetTime = 0
    local function executeReset(isBalloon)
        if isBalloon then
            if tick() - lastBalloonResetTime < 20 then return end
            lastBalloonResetTime = tick()
        end
        instantReset()
    end
    _G.executeReset = executeReset

    if _G.AutoResetBalloon == nil then _G.AutoResetBalloon = true end
    do
        local cfg = _G.HubCfg.get("reset")
        if type(cfg.balloon) == "boolean" then _G.AutoResetBalloon = cfg.balloon end
    end
    _G.setAutoResetBalloon = function(on)
        _G.AutoResetBalloon = on and true or false
        local cfg = _G.HubCfg.get("reset")
        cfg.balloon = _G.AutoResetBalloon
        _G.HubCfg.save()
    end
    task.spawn(function()
        while true do
            task.wait(6)
            if _G.AutoResetBalloon and not (_G._isTpMoving or _G.HazhubStealHold) then
                pcall(function()
                    for _, g in ipairs(PG:GetDescendants()) do
                        if g:IsA("TextLabel") or g:IsA("TextButton") then
                            local t = g.Text
                            if t and string.find(t, 'ran "balloon" on you', 1, true) then
                                executeReset(true)
                                break
                            end
                        end
                    end
                end)
            end
        end
    end)
end)

if not okRS then warn("[RESET] BLOC EN ERREUR: " .. tostring(errRS)) end
end)

stagSpawn(function()
local okLB, errLB = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    local BEAM_NAME  = "PlotBeam"
    local ATT0_NAME  = "PlotBeamAttach_Player"
    local ATT1_NAME  = "PlotBeamAttach_Plot"
    local BEAM_COLOR = Color3.fromRGB(255, 255, 255)

    if _G.LineToBase == nil then _G.LineToBase = true end

    local plotBeam, plotAtt0, plotAtt1

    local beamAnchor, lastPlotPos

    local function _anchorHolder()
        local h = workspace:FindFirstChild("HazhubBeamHolder")
        if not h or not h:IsA("Folder") then
            if h then pcall(function() h:Destroy() end) end
            h = Instance.new("Folder")
            h.Name = "HazhubBeamHolder"
            h.Parent = workspace
        end
        return h
    end
    local function ensureAnchor()
        if beamAnchor and beamAnchor.Parent then return beamAnchor end
        if beamAnchor then pcall(function() beamAnchor:Destroy() end) end
        local p = Instance.new("Part")
        p.Name = "PlotBeamAnchor"; p.Anchored = true
        p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
        p.Transparency = 1; p.CastShadow = false; p.Size = Vector3.new(1, 1, 1)
        p.Parent = _anchorHolder()
        beamAnchor = p
        return p
    end

    local function applyStyle(beam)
        if not beam then return end
        beam.FaceCamera    = true
        beam.LightEmission = 1
        beam.Color         = ColorSequence.new(BEAM_COLOR)
        beam.Transparency  = NumberSequence.new(0)
        beam.Width0        = 0.45
        beam.Width1        = 0.45
        beam.TextureMode   = Enum.TextureMode.Wrap
        beam.TextureSpeed  = 0
        beam.Enabled       = true
    end

    local function destroyBeam()
        if plotBeam then pcall(function() plotBeam:Destroy() end) end
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local old = hrp:FindFirstChild("PlotBeamGlow")
            if old then pcall(function() old:Destroy() end) end
        end
        if plotAtt0 then pcall(function() plotAtt0:Destroy() end) end
        if plotAtt1 then pcall(function() plotAtt1:Destroy() end) end
        if beamAnchor then pcall(function() beamAnchor:Destroy() end) end
        plotBeam, plotAtt0, plotAtt1, beamAnchor, lastPlotPos = nil, nil, nil, nil, nil
    end

    local _myPlotCache, _myPlotCacheT = nil, 0
    local function _scanMyPlot()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local yb = sign:FindFirstChild("YourBase")
                if yb and yb:IsA("BillboardGui") and yb.Enabled then return plot end
                local sg = sign:FindFirstChildWhichIsA("SurfaceGui", true)
                if sg then
                    local label = sg:FindFirstChildWhichIsA("TextLabel", true)
                    if label and label.Text then
                        local t = label.Text:lower()
                        if t:find(LP.DisplayName:lower(), 1, true)
                           or t:find(LP.Name:lower(), 1, true) then
                            return plot
                        end
                    end
                end
            end
        end
        return nil
    end

    local function findMyPlot()
        if _myPlotCache and _myPlotCache.Parent and (os.clock() - _myPlotCacheT) < 1.5 then
            return _myPlotCache
        end
        _myPlotCache = _scanMyPlot()
        _myPlotCacheT = os.clock()
        return _myPlotCache
    end

    _G.HazhubFindMyPlot = findMyPlot

    local function getAnchorPart(plot)
        if not plot then return nil end
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            if sign:IsA("BasePart") then return sign end
            local part = sign:FindFirstChildWhichIsA("BasePart", true)
            if part then return part end
        end
        local main = plot:FindFirstChild("MainRootPart")
        if main and main:IsA("BasePart") then return main end
        return plot:FindFirstChildWhichIsA("BasePart")
    end

    local function ensureBeam(hrp, plotPos)
        if not hrp or not hrp.Parent or not plotPos then return end
        ensureAnchor()
        beamAnchor.Position = plotPos

        if not plotAtt0 or not plotAtt0.Parent or plotAtt0.Parent ~= hrp then
            if plotAtt0 then pcall(function() plotAtt0:Destroy() end) end
            plotAtt0 = Instance.new("Attachment")
            plotAtt0.Name = ATT0_NAME
            plotAtt0.Parent = hrp
        end

        if not plotAtt1 or not plotAtt1.Parent or plotAtt1.Parent ~= beamAnchor then
            if plotAtt1 then pcall(function() plotAtt1:Destroy() end) end
            plotAtt1 = Instance.new("Attachment")
            plotAtt1.Name = ATT1_NAME
            plotAtt1.Position = Vector3.new(0, 4, 0)
            plotAtt1.Parent = beamAnchor
        end

        if not plotBeam or not plotBeam.Parent then
            if plotBeam then pcall(function() plotBeam:Destroy() end) end
            local oldGlow = hrp:FindFirstChild("PlotBeamGlow")
            if oldGlow then pcall(function() oldGlow:Destroy() end) end
            plotBeam = Instance.new("Beam")
            plotBeam.Name = BEAM_NAME
            applyStyle(plotBeam)
            plotBeam.Parent = hrp
        end
        plotBeam.Attachment0 = plotAtt0
        plotBeam.Attachment1 = plotAtt1
    end

    local check = 10
    RunService.Heartbeat:Connect(function()
        if not _G.LineToBase then
            if plotBeam or plotAtt0 or plotAtt1 or beamAnchor then destroyBeam() end
            return
        end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then

            if plotBeam then pcall(function() plotBeam:Destroy() end); plotBeam = nil end
            if plotAtt0 then pcall(function() plotAtt0:Destroy() end); plotAtt0 = nil end
            return
        end

        check = check + 1
        if check >= 10 then
            check = 0
            local myPlot = findMyPlot()
            if myPlot then
                local plotPart = getAnchorPart(myPlot)
                if plotPart and plotPart.Parent then
                    lastPlotPos = plotPart.Position
                end
            end
        end

        if lastPlotPos then
            pcall(ensureBeam, hrp, lastPlotPos)
        end
    end)

    LP.CharacterAdded:Connect(function()
        plotBeam, plotAtt0 = nil, nil
        check = 10
    end)

    _G.toggleLineToBase = function(on)
        _G.LineToBase = (on == nil) and (not _G.LineToBase) or (on and true or false)
        if not _G.LineToBase then destroyBeam() end
    end
end)

if not okLB then warn("[LINETOBASE] BLOC EN ERREUR: " .. tostring(errLB)) end
end)

nowSpawn(function()
local okER, errER = pcall(function()
    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local Lighting    = game:GetService("Lighting")
    local LocalPlayer = Players.LocalPlayer

    if _G.EffetsRemover == nil then _G.EffetsRemover = true end

    local AB = {
        running              = false,
        connections          = {},
        originalMoveFunction = nil,
        controlsProtected    = false,

        badLightingNames = { Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true },

        killClasses = {
            BlurEffect            = true,
            BloomEffect           = true,
            SunRaysEffect         = true,
            ColorCorrectionEffect = true,
            DepthOfFieldEffect    = true,
        },
    }

    AB.nuke = function(obj)
        if not obj or not obj.Parent then return end
        if AB.badLightingNames[obj.Name] then
            pcall(function() obj:Destroy() end)
            return
        end
        if AB.killClasses[obj.ClassName] then
            pcall(function() obj.Enabled = false end)
        end
    end

    AB.disconnectAll = function()
        for _, conn in ipairs(AB.connections) do
            if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
        end
        AB.connections = {}
    end

    AB.protectControls = function()
        if AB.controlsProtected then return end

        task.spawn(function()
            local ps = LocalPlayer:WaitForChild("PlayerScripts", 60)
            local pm = ps and ps:WaitForChild("PlayerModule", 60)
            if not pm then return end
            local Controls
            for _ = 1, 300 do
                local ok, c = pcall(function() return require(pm):GetControls() end)
                if ok and c and type(c.moveFunction) == "function" then Controls = c break end
                task.wait(0.1)
            end
            if not Controls or AB.controlsProtected then return end

            if not AB.originalMoveFunction then AB.originalMoveFunction = Controls.moveFunction end
            local function protectedMoveFunction(self, moveVector, relativeToCamera)
                if AB.originalMoveFunction then AB.originalMoveFunction(self, moveVector, relativeToCamera) end
            end

            table.insert(AB.connections, RunService.Heartbeat:Connect(function()
                if not AB.running or not _G.EffetsRemover then return end
                if _G._isTpMoving then return end
                if Controls.moveFunction ~= protectedMoveFunction then
                    Controls.moveFunction = protectedMoveFunction
                end
            end))
            Controls.moveFunction = protectedMoveFunction
            AB.controlsProtected = true
        end)
    end

    AB.restoreControls = function()
        if not AB.controlsProtected then return end
        pcall(function()
            local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
            local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")
            if not PlayerModule then return end
            local Controls = require(PlayerModule):GetControls()
            if Controls and AB.originalMoveFunction then
                Controls.moveFunction = AB.originalMoveFunction
                AB.controlsProtected = false
            end
        end)
    end

    AB.blockBuzzingSound = function()
        pcall(function()
            local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
            local beeScript = PlayerScripts and PlayerScripts:FindFirstChild("Bee", true)
            if beeScript then
                local buzzing = beeScript:FindFirstChild("Buzzing")
                if buzzing and buzzing:IsA("Sound") then
                    buzzing:Stop()
                    buzzing.Volume = 0
                end
            end
        end)
    end

    AB.Enable = function()
        if AB.running then return end
        AB.running = true
        _G.EffetsRemover = true

        for _, inst in ipairs(Lighting:GetDescendants()) do AB.nuke(inst) end

        table.insert(AB.connections, Lighting.DescendantAdded:Connect(function(obj)
            if not AB.running or not _G.EffetsRemover then return end
            AB.nuke(obj)
        end))
        AB.protectControls()

        table.insert(AB.connections, RunService.Heartbeat:Connect(function()
            if not AB.running or not _G.EffetsRemover then return end
            AB.blockBuzzingSound()
        end))
    end

    AB.Disable = function()
        if not AB.running then return end
        AB.running = false
        _G.EffetsRemover = false
        AB.restoreControls()
        AB.disconnectAll()
    end

    _G.ANTI_BEE_DISCO = AB

    _G.setEffetsRemover = function(on)
        if on then AB.Enable() else AB.Disable() end
    end

    if _G.EffetsRemover then AB.Enable() end
end)

if not okER then warn("[ANTIBEEDISCO] BLOC EN ERREUR: " .. tostring(errER)) end
end)

nowSpawn(function()
local okAC, errAC = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS        = game:GetService("UserInputService")
    local LP         = Players.LocalPlayer
    local PG         = LP:WaitForChild("PlayerGui")
    local guiParent  = (gethui and gethui()) or game:GetService("CoreGui") or PG

    local MINV, MAXV, DEFV = 50, 120, 70
    local cfg = _G.HubCfg.get("actions")
    if _G.HazhubFOV        == nil then _G.HazhubFOV        = DEFV end
    if _G.HazhubFOVEnabled == nil then _G.HazhubFOVEnabled = true end
    local panelX, panelY = 240, 470
    do
        if tonumber(cfg.fov) then _G.HazhubFOV = math.clamp(tonumber(cfg.fov), MINV, MAXV) end
        if tonumber(cfg.x)   then panelX = tonumber(cfg.x) end
        if tonumber(cfg.y)   then panelY = tonumber(cfg.y) end
    end
    local function saveCfg()
        cfg.fov = _G.HazhubFOV
        cfg.x = panelX; cfg.y = panelY
        _G.HubCfg.save()
    end

    local function setFOVValue(v)
        v = math.clamp(math.floor((tonumber(v) or DEFV) + 0.5), MINV, MAXV)
        _G.HazhubFOV = v
        pcall(function() cfg.fov = v; _G.HubCfg.save() end)
        return v
    end
    _G.setFOV = setFOVValue
    setFOVValue(_G.HazhubFOV)

    RunService.RenderStepped:Connect(function()
        if not _G.HazhubFOVEnabled then return end
        local cam = workspace.CurrentCamera
        if cam then
            local target = tonumber(_G.HazhubFOV) or DEFV
            if math.abs(cam.FieldOfView - target) > 0.01 then
                cam.FieldOfView = target
            end
        end
    end)

end)

if not okAC then warn("[ACTIONS] BLOC EN ERREUR: " .. tostring(errAC)) end
end)

stagSpawn(function()
local okESP2, errESP2 = pcall(function()
    local Players    = game:GetService("Players")
    local LP         = Players.LocalPlayer
    local guiParent  = (gethui and gethui()) or game:GetService("CoreGui")

    local cfg = _G.HubCfg.get("esp")
    if _G.HazhubPlayerESP    == nil then _G.HazhubPlayerESP    = true end
    if _G.HazhubBaseOwnerESP == nil then _G.HazhubBaseOwnerESP = true end
    do
        if type(cfg.player) == "boolean" then _G.HazhubPlayerESP    = cfg.player end
        if type(cfg.owner)  == "boolean" then _G.HazhubBaseOwnerESP = cfg.owner end
    end
    local function saveCfg()
        cfg.player = _G.HazhubPlayerESP
        cfg.owner  = _G.HazhubBaseOwnerESP
        _G.HubCfg.save()
    end

    local function getPlotAtPosition(pos)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        local closestPlot, minDistance = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            local plotPos
            if plot:IsA("Model") then
                plotPos = plot.PrimaryPart and plot.PrimaryPart.Position or plot:GetPivot().Position
            else
                plotPos = plot.Position
            end
            if plotPos then
                local distH = math.sqrt((pos.X - plotPos.X)^2 + (pos.Z - plotPos.Z)^2)
                if distH < minDistance then minDistance = distH; closestPlot = plot end
            end
        end
        if closestPlot and minDistance < 72 then return closestPlot end
        return nil
    end

    local function getPlotOwner(plot)
        if not plot then return nil end
        local sign = plot:FindFirstChild("PlotSign")
        local textLabel = sign
            and sign:FindFirstChild("SurfaceGui")
            and sign.SurfaceGui:FindFirstChild("Frame")
            and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
        if textLabel then
            local baseText = textLabel.Text
            local nickname = (baseText and baseText:match("^(.-)'")) or baseText
            if nickname and nickname ~= "" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if (p.DisplayName == nickname) or (p.Name == nickname) then return p end
                end
            end
        end
        return nil
    end

    local playerBillboards = {}
    local DANGER_TOOLS = { ["Boogie Bomb"]=true, ["Medusa's Head"]=true, ["Body Swap Potion"]=true,
        ["Laser Cape"]=true, ["Rainbowrath Sword"]=true, ["Gummy Bear"]=true }
    local function getHeldTool(p)
        local c = p.Character; if not c then return nil end
        for _, o in ipairs(c:GetChildren()) do if o:IsA("Tool") then return o.Name end end
        return nil
    end
    local function makePlayerBillboard(plr)
        local bb = Instance.new("BillboardGui")
        bb.Name = "PlayerESP_" .. tostring(plr.UserId); bb.Size = UDim2.new(0, 170, 0, 48)
        bb.StudsOffsetWorldSpace = Vector3.new(0, 2.8, 0); bb.AlwaysOnTop = true
        bb.LightInfluence = 0; bb.ResetOnSpawn = false
        local nameLbl = Instance.new("TextLabel", bb); nameLbl.Size = UDim2.new(1, 0, 0, 18)
        nameLbl.BackgroundTransparency = 1; nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 14
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255); nameLbl.TextStrokeTransparency = 0.4
        nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); nameLbl.Text = plr.Name
        local toolLbl = Instance.new("TextLabel", bb); toolLbl.Name = "ToolLabel"
        toolLbl.Size = UDim2.new(1, 0, 0, 13); toolLbl.Position = UDim2.new(0, 0, 0, 18)
        toolLbl.BackgroundTransparency = 1; toolLbl.Font = Enum.Font.GothamMedium; toolLbl.TextSize = 11
        toolLbl.TextColor3 = Color3.fromRGB(100, 220, 255); toolLbl.TextStrokeTransparency = 0.4
        toolLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); toolLbl.Text = getHeldTool(plr) or ""
        local stealLbl = Instance.new("TextLabel", bb); stealLbl.Name = "StealLabel"
        stealLbl.Size = UDim2.new(1, 0, 0, 13); stealLbl.Position = UDim2.new(0, 0, 0, 31)
        stealLbl.BackgroundTransparency = 1; stealLbl.Font = Enum.Font.GothamBold; stealLbl.TextSize = 11
        stealLbl.TextColor3 = Color3.fromRGB(255, 60, 60); stealLbl.TextStrokeTransparency = 0.4
        stealLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); stealLbl.Text = ""
        return bb, nameLbl
    end
    local function createOrRefreshPlayerESP(plr)
        if plr == LP then return end
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = plr.Character:FindFirstChild("Humanoid")
        if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
        local uid = plr.UserId; local entry = playerBillboards[uid]
        if not entry or not entry.bb or not entry.bb.Parent then
            if entry and entry.bb then pcall(function() entry.bb:Destroy() end) end
            local bb, nameLbl = makePlayerBillboard(plr)
            bb.Adornee = hrp; bb.Parent = hrp
            playerBillboards[uid] = { bb = bb, nameLbl = nameLbl, player = plr }
        elseif entry.bb.Adornee ~= hrp then
            entry.bb.Adornee = hrp; entry.bb.Parent = hrp
        end
    end
    local function clearPlayerESP()
        for uid, entry in pairs(playerBillboards) do
            if entry.bb then pcall(entry.bb.Destroy, entry.bb) end
            playerBillboards[uid] = nil
        end
    end
    _G.setPlayerESP = function(on)
        _G.HazhubPlayerESP = on and true or false
        if not _G.HazhubPlayerESP then clearPlayerESP() end
        saveCfg()
    end

    task.spawn(function()
        while true do
            task.wait(6)
            if _G._isTpMoving or _G.HazhubStealHold then continue end
            if _G.HazhubPlayerESP then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP then pcall(createOrRefreshPlayerESP, plr) end
                end
                for _, entry in pairs(playerBillboards) do
                    if entry.bb and entry.bb.Parent then
                        pcall(function()
                            local tl = entry.bb:FindFirstChild("ToolLabel")
                            if tl then
                                local ht = getHeldTool(entry.player)
                                tl.Text = ht or ""
                                if entry.nameLbl then
                                    entry.nameLbl.TextColor3 = (ht and DANGER_TOOLS[ht])
                                        and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(255, 255, 255)
                                end
                            end
                        end)
                        pcall(function()
                            local sl = entry.bb:FindFirstChild("StealLabel")
                            if sl then
                                sl.Text = entry.player:GetAttribute("Stealing") and "Stealing..." or ""
                            end
                        end)
                    end
                end
            else
                clearPlayerESP()
            end
        end
    end)

    local entries = {}
    local function destroyEntry(e)
        if not e then return end
        if e.hl then pcall(function() e.hl:Destroy() end) end
        if e.bb then pcall(function() e.bb:Destroy() end) end
    end
    local function clearAllOwner()
        for uid, e in pairs(entries) do destroyEntry(e); entries[uid] = nil end
    end
    local function makeTag()
        local bb = Instance.new("BillboardGui")
        bb.Name = "BaseOwnerTag"; bb.Size = UDim2.new(0, 160, 0, 34)
        bb.StudsOffsetWorldSpace = Vector3.new(0, 3.6, 0); bb.AlwaysOnTop = true; bb.LightInfluence = 0
        local lbl = Instance.new("TextLabel", bb)
        lbl.Size = UDim2.fromScale(1, 1); lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBlack; lbl.TextSize = 18
        lbl.TextColor3 = Color3.fromRGB(255, 60, 60)
        lbl.TextStrokeTransparency = 0; lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.Text = "BASE OWNER"
        return bb
    end
    local function setOwnerTarget(plr)
        for uid, e in pairs(entries) do
            if not plr or uid ~= plr.UserId then destroyEntry(e); entries[uid] = nil end
        end
        if not plr or not plr.Character then return end
        local uid = plr.UserId
        local e = entries[uid]; if not e then e = {}; entries[uid] = e end
        if not e.hl or not e.hl.Parent then
            if e.hl then pcall(function() e.hl:Destroy() end) end
            local hl = Instance.new("Highlight")
            hl.Name = "BaseOwnerESP"
            hl.FillColor = Color3.fromRGB(255, 0, 0); hl.FillTransparency = 0.6
            hl.OutlineColor = Color3.fromRGB(255, 0, 0); hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = guiParent
            e.hl = hl
        end
        if e.hl.Adornee ~= plr.Character then e.hl.Adornee = plr.Character end
        if not e.bb or not e.bb.Parent then
            if e.bb then pcall(function() e.bb:Destroy() end) end
            e.bb = makeTag(); e.bb.Parent = guiParent
        end
        local head = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
        if head and e.bb.Adornee ~= head then e.bb.Adornee = head end
    end
    local function refreshOwner()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then setOwnerTarget(nil); return end
        local plot = getPlotAtPosition(hrp.Position)
        local owner = plot and getPlotOwner(plot)
        if owner == LP then owner = nil end
        setOwnerTarget(owner)
    end
    _G.setBaseOwnerESP = function(on)
        _G.HazhubBaseOwnerESP = on and true or false
        if _G.HazhubBaseOwnerESP then pcall(refreshOwner) else clearAllOwner() end
        saveCfg()
    end
    _G.clearBaseOwnerESP = clearAllOwner

    task.spawn(function()
        while true do
            task.wait(6)
            if _G.HazhubBaseOwnerESP and not (_G._isTpMoving or _G.HazhubStealHold) then pcall(refreshOwner)
            elseif next(entries) then clearAllOwner() end
        end
    end)
end)

if not okESP2 then warn("[ESP2] BLOC EN ERREUR: " .. tostring(errESP2)) end
end)

nowSpawn(function()
    task.wait(4)
    local okWMU, errWMU = pcall(function()
    local Players    = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local Stats       = game:GetService("Stats")
    local LP          = Players.LocalPlayer
    local PG          = LP:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "HazhubWatermark"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.DisplayOrder = 999998
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    gui.Parent = PG

    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position = UDim2.new(0.5, 0, 0, 6)
    frame.Size = UDim2.new(0, 190, 0, 24)
    frame.BackgroundColor3 = UI.C.PANEL
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = gui
    UI.corner(frame, 8)
    UI.stroke(frame).Transparency = 0.35
    local accent = Instance.new("Frame", frame)
    accent.Size = UDim2.new(0, 3, 1, -8); accent.Position = UDim2.fromOffset(5, 4)
    accent.BackgroundColor3 = UI.C.ACCENT; accent.BorderSizePixel = 0
    UI.corner(accent, 2)

    local label = UI.label({ parent = frame, bold = true, size = 12,
        align = Enum.TextXAlignment.Center, text = "FPS: --  |  PING: --" })
    label.Size = UDim2.new(1, -18, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.TextStrokeTransparency = 0.4
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

    local _fCount, _fAccum, _fps = 0, 0, 0
    RunService.RenderStepped:Connect(function(dt)
        _fCount = _fCount + 1; _fAccum = _fAccum + dt
        if _fAccum >= 0.5 then _fps = math.floor(_fCount / _fAccum + 0.5); _fCount = 0; _fAccum = 0 end
    end)
    task.spawn(function()
        while frame.Parent do
            local ping = 0
            pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5) end)
            local s = string.format("FPS: %d  |  PING: %dms", _fps, ping)
            if label.Text ~= s then label.Text = s end
            task.wait(0.5)
        end
    end)
    end)
    if not okWMU then warn("[WATERMARK FPS/PING] BLOC EN ERREUR: " .. tostring(errWMU)) end
end)

nowSpawn(function()
    task.wait(4)
    local okBT, errBT = pcall(function()
    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local LP        = Players.LocalPlayer
    local PG        = LP:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "HazhubBaseTimer"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.DisplayOrder = 999998
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    gui.Parent = PG

    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position = UDim2.new(0.5, 0, 0, 54)
    frame.Size = UDim2.new(0, 120, 0, 52)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = gui

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Font = UI.FONTK
    label.TextSize = 38
    label.TextColor3 = UI.C.TEXT
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Text = "--"
    label.Parent = frame

    local function nearestPlot(pos)
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        local best, bestD = nil, 80 * 80
        for _, plot in ipairs(plots:GetChildren()) do
            local pp
            if plot:IsA("Model") then
                pp = plot.PrimaryPart and plot.PrimaryPart.Position or plot:GetPivot().Position
            elseif plot:IsA("BasePart") then
                pp = plot.Position
            end
            if pp then
                local dx, dz = pos.X - pp.X, pos.Z - pp.Z
                local d2 = dx * dx + dz * dz
                if d2 < bestD then bestD = d2; best = plot end
            end
        end
        return best
    end

    local function plotTimerText(plot)
        local bestY, bestTxt = math.huge, nil
        for _, g in ipairs(plot:GetDescendants()) do
            if g:IsA("BillboardGui") then
                local rt = g:FindFirstChild("RemainingTime")
                if rt then
                    local base = g.Adornee or g.Parent
                    local y = (base and base:IsA("BasePart")) and base.Position.Y or math.huge
                    if y < bestY then bestY = y; bestTxt = rt.Text end
                end
            end
        end
        return bestTxt
    end

    task.spawn(function()
        while gui.Parent do
            task.wait(0.5)

            if not _G._isTpMoving then
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local plot = hrp and nearestPlot(hrp.Position)
                local txt = plot and plotTimerText(plot)
                if txt and txt ~= "" then
                    if label.Text ~= txt then label.Text = txt end
                    if not frame.Visible then frame.Visible = true end
                elseif frame.Visible then
                    frame.Visible = false
                end
            end
        end
    end)
    end)
    if not okBT then warn("[BASE TIMER] BLOC EN ERREUR: " .. tostring(errBT)) end
end)

if _G.AntiDieDisabled == nil then _G.AntiDieDisabled = false end
nowSpawn(function()
local okAD, errAD = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    local _conn, _diedConn, _hbConn
    local function _harden(hum)
        pcall(function() hum.BreakJointsOnDeath = false end)
        pcall(function() hum.RequiresNeck = false end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false) end)
    end
    local function _revive(hum)
        pcall(function() hum.Health = hum.MaxHealth end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    local function _bind()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        _harden(hum)
        if _conn then pcall(function() _conn:Disconnect() end) end
        if _diedConn then pcall(function() _diedConn:Disconnect() end) end
        if _hbConn then pcall(function() _hbConn:Disconnect() end) end
        _conn = hum:GetPropertyChangedSignal("Health"):Connect(function()
            if _G.AntiDieDisabled then return end
            if hum.Health <= 0 then _revive(hum) end
        end)
        _diedConn = hum.Died:Connect(function()
            if _G.AntiDieDisabled then return end
            _revive(hum)
        end)
        local _lastHarden = 0
        _hbConn = RunService.Heartbeat:Connect(function()
            if _G.AntiDieDisabled or not hum or not hum.Parent then return end
            local now = os.clock()
            if now - _lastHarden >= 0.5 then _lastHarden = now; _harden(hum) end
            if hum.Health <= 0 then _revive(hum) end

            if _G.HazhubTPHealLock and hum.Health < hum.MaxHealth then
                pcall(function() hum.Health = hum.MaxHealth end)
            end
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.Ragdoll
               or state == Enum.HumanoidStateType.FallingDown then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end)
    end
    _bind()
    LP.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then _harden(hum) end
        task.wait(0.1)
        _bind()
    end)
end)
if not okAD then warn("[ANTI-DIE] BLOC EN ERREUR: " .. tostring(errAD)) end
end)

stagSpawn(function()
local okDK, errDK = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    local _wfConns, _wfActive = {}, false
    local function stopWalkFling()
        _wfActive = false
        for _, c in ipairs(_wfConns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        _wfConns = {}
    end
    local function startWalkFling()
        _wfActive = true
        local ch = LP.Character; if not ch then return end
        local rr = ch:FindFirstChild("HumanoidRootPart")

        for _, o in pairs(workspace.CurrentCamera:GetChildren()) do
            if o.Name == "HumanoidRootPart" then rr = o; break end
        end
        if not rr then return end
        table.insert(_wfConns, RunService.Stepped:Connect(function()
            if not _wfActive then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    for _, pt in ipairs(p.Character:GetChildren()) do
                        if pt:IsA("BasePart") then pt.CanCollide = false end
                    end
                end
            end
        end))
        local co = coroutine.create(function()
            if _G.invisibleStealEnabled then rr.CFrame = rr.CFrame * CFrame.new(0, 3, 0) end
            while _wfActive do
                RunService.Heartbeat:Wait(); if not rr or not rr.Parent then break end
                local v = rr.Velocity; rr.Velocity = v * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait(); if rr then rr.Velocity = v end
                RunService.Stepped:Wait(); if rr then rr.Velocity = v + Vector3.new(0, 0.1, 0) end
            end
        end)
        coroutine.resume(co); table.insert(_wfConns, co)
    end

    _G.HazhubDropBrainrot = function()
        if _wfActive then return end
        startWalkFling()
        task.delay(0.4, stopWalkFling)
    end

    _G.HazhubKick = function()
        pcall(function() game:Shutdown() end)
        pcall(function() LP:Kick("") end)
    end
end)
if not okDK then warn("[DROP/KICK] BLOC EN ERREUR: " .. tostring(errDK)) end
end)

nowSpawn(function()
    task.wait(4)
local okAB, errAB = pcall(function()
    local Players            = game:GetService("Players")
    local RunService         = game:GetService("RunService")
    local ReplicatedStorage  = game:GetService("ReplicatedStorage")
    local Workspace          = workspace
    local LocalPlayer        = Players.LocalPlayer
    if _G.HazhubAutoBuyRange == nil then _G.HazhubAutoBuyRange = 60 end
    if _G.HazhubAutoBuyFireRange == nil then _G.HazhubAutoBuyFireRange = 150 end

    local Config = setmetatable({
        AutoBuyEnabled = false, AutoGrabSpeed = 17, AutoKickOnSteal = false, TpSettings = {},
    }, { __index = function(_, k)
        if k == "AutoBuyRange" then return tonumber(_G.HazhubAutoBuyRange) or 60 end
        return nil
    end })
    local function saveConfig() end
    local function setToggle() end
    local function ShowNotification() end
    local SharedState = { ConveyorAnimals = {} }
    local function LPH_NO_VIRTUALIZE(fn) return fn end

    local function kickPlayer()
        if _G.HazhubDoAutoKick then pcall(_G.HazhubDoAutoKick)
        elseif _G.HazhubKick then pcall(_G.HazhubKick) end
    end
    local CarpetState = nil
    local function setCarpetSpeed() end
    local AnimalsData, AnimalsShared, NumberUtils

    local toggleAutoBuy

    local function _initAutoBuyScope()
    local autoBuyActive = false

    pcall(function()
        local e = Workspace:FindFirstChild("XiAutoBuyRing")
        if e then e:Destroy() end
    end)

    toggleAutoBuy = function(on)
        if on ~= nil then
            autoBuyActive = on
        else
            autoBuyActive = not autoBuyActive
        end
        Config.AutoBuyEnabled = autoBuyActive
        pcall(saveConfig)
        pcall(setToggle, "Auto Buy", autoBuyActive)

        if not autoBuyActive then
            pcall(function() local e = Workspace:FindFirstChild("XiAutoBuyRing"); if e then e:Destroy() end end)
        end
        pcall(ShowNotification, "AUTO BUY", autoBuyActive and "ENABLED" or "DISABLED")
        if _G.AutoBuyOnToggle then
            pcall(_G.AutoBuyOnToggle, autoBuyActive)
        end
    end

    local RARITY_WORDS = {
        common = true, uncommon = true, rare = true, epic = true,
        legendary = true, secret = true, divine = true, rainbow = true,
        cursed = true, gold = true, diamond = true,
    }

    local function getBrainrotName(model)
        if not model then return "Brainrot", "" end
        local nameFound, genFound = "", ""
        for _, bb in ipairs(model:GetDescendants()) do
            if bb:IsA("BillboardGui") then
                for _, lbl in ipairs(bb:GetDescendants()) do
                    if lbl:IsA("TextLabel") and lbl.Text and lbl.Text ~= "" then
                        local t = lbl.Text:match("^%s*(.-)%s*$")
                        local tl = t:lower()
                        if RARITY_WORDS[tl] then continue end
                        if t:match("^%$[%d%.]+[KkMmBb]?/s$") then
                            if genFound == "" then genFound = t end
                            continue
                        end
                        if t:match("^%$[%d%.]+[KkMmBb]?$") then continue end
                        if t:match("^[%d%.]+[KkMmBb]?$") then continue end
                        if nameFound == "" and #t > 1 then nameFound = t end
                    end
                end
            end
        end
        if nameFound == "" then
            pcall(function()
                local info = AnimalsData[model.Name]
                if info and info.DisplayName then
                    nameFound = info.DisplayName
                    local gv = AnimalsShared:GetGeneration(model.Name, nil, nil, nil)
                    local gt = "$" .. NumberUtils:ToString(gv) .. "/s"
                    genFound = gt
                end
            end)
        end
        if nameFound == "" then nameFound = model.Name ~= "" and model.Name or "Brainrot" end
        return nameFound, genFound
    end

    local function scanConveyor()

        local results = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if not (obj:IsA("ProximityPrompt") and obj.Enabled) then continue end
            local txt = obj.ActionText or ""
            if not (txt == "Purchase" or txt:lower():find("purchase") or txt:lower():find("comprar")) then continue end
            local part = obj.Parent
            if not part then continue end
            local realPart = (part:IsA("Attachment") and part.Parent) or part
            if not (realPart and realPart:IsA("BasePart")) then continue end
            results[#results + 1] = { prompt = obj, part = realPart, model = realPart.Parent }
        end
        return results
    end

    SharedState.ConveyorAnimals = {}
    local function refreshConveyor()
        local ok, found = pcall(scanConveyor)
        if ok and found then
            SharedState.ConveyorAnimals = found
        end
    end

    _G.refreshConveyor = refreshConveyor

    local purchaseRemote = nil
    local function resolvePurchaseRemote()
        if purchaseRemote and purchaseRemote.Parent then return purchaseRemote end
        pcall(function()
            local net = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net")
            if not net then return end
            local kws = {"buy", "purchase", "animal", "shop", "acquire", "conveyor"}
            for _, v in ipairs(net:GetChildren()) do
                local nl = (v.Name or ""):lower()
                for _, kw in ipairs(kws) do
                    if nl:find(kw) then
                        purchaseRemote = v
                        return
                    end
                end
            end
        end)
        return purchaseRemote
    end

    local _lastPurchaseFire = setmetatable({}, {__mode = "k"})
    local _purchaseInFlight = setmetatable({}, {__mode = "k"})
    local PURCHASE_MIN_INTERVAL = 0.03

    local function firePurchaseNatural(prompt)
        if not prompt or not prompt.Parent or not prompt.Enabled then return end
        local now = os.clock()
        local last = _lastPurchaseFire[prompt]
        if last and (now - last) < PURCHASE_MIN_INTERVAL then return end
        _lastPurchaseFire[prompt] = now
        pcall(function()
            if fireproximityprompt then fireproximityprompt(prompt) end
        end)

        if _G.HazhubAutoBuyFireRemote then
            if _purchaseInFlight[prompt] then return end
            _purchaseInFlight[prompt] = true
            task.spawn(function()
                local remote = resolvePurchaseRemote()
                if remote then
                    pcall(function()
                        if remote:IsA("RemoteFunction") then
                            remote:InvokeServer(prompt.Parent)
                        elseif remote:IsA("RemoteEvent") then
                            remote:FireServer(prompt.Parent)
                        end
                    end)
                end
                _purchaseInFlight[prompt] = nil
            end)
        end
    end

    local carpetLockConn = nil
    local _abReturning = false
    local FLY_GEAR_NAMES = { "Flying Carpet", "Carpet", "Cloud", "Witch's Broom", "Cupid's Wings", "Santa's Sleigh", "Magic Carpet", "Waverider" }
    local function isCarpetTool(t)
        if not (t and t:IsA("Tool")) then return false end
        local carpetName = (Config.TpSettings and Config.TpSettings.Tool) or ""
        if carpetName ~= "" and t.Name == carpetName then return true end
        local nm = t.Name or ""
        for _, n in ipairs(FLY_GEAR_NAMES) do if nm == n then return true end end
        local nl = nm:lower()
        return nl:find("carpet") ~= nil or nl:find("broom") ~= nil or nl:find("glider") ~= nil or nl:find("wings") ~= nil
    end
    local function unequipCarpet()

        pcall(function()
            local char = LocalPlayer.Character
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if not char or not bp then return end
            for _, t in ipairs(char:GetChildren()) do
                if isCarpetTool(t) then t.Parent = bp end
            end
        end)
    end
    local function equipFlyGear()

        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not char or not hum then return end
            for _, t in ipairs(char:GetChildren()) do if isCarpetTool(t) then return end end
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then
                for _, t in ipairs(bp:GetChildren()) do
                    if isCarpetTool(t) then hum:EquipTool(t); return end
                end
            end
        end)
    end

    local function keepFlyGearIfIdle()

        if _G.HazhubAutoBuyKeepCarpet == false then return end
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not char or not hum then return end
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then return end
            end
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then
                for _, t in ipairs(bp:GetChildren()) do
                    if isCarpetTool(t) then hum:EquipTool(t); return end
                end
            end
        end)
    end
    local function startCarpetLock()
        if carpetLockConn then carpetLockConn:Disconnect(); carpetLockConn = nil end

        if _G.HazhubAutoBuyKeepCarpet == false then return end
        equipFlyGear()
    end

    local function stopCarpetLock()
        if carpetLockConn then carpetLockConn:Disconnect(); carpetLockConn = nil end
    end

    local HOVER_HEIGHT = 6.0
    local BUY_INTERVAL = 0.03
    local DETECT_RADIUS = 17
    local lockedTarget = nil
    local lockedPart = nil
    local lockedModel = nil
    local _lockedBuyFired = false
    local _abTopOff = 2
    local _lastAbove = nil
    local _lastTargetTime = 0

    local function partAlive()
        return lockedPart and lockedPart.Parent and lockedModel and lockedModel.Parent
    end

    local function promptAlive()
        return lockedTarget and lockedTarget.prompt and lockedTarget.prompt.Parent and lockedTarget.prompt.Enabled
    end

    local bodyPos = nil
    local function ensureBodyPos(hrp)

        local speed = math.clamp(Config.AutoGrabSpeed or 17, 5, 100)

        local P = 8000 + speed * 300
        local mass = hrp.AssemblyMass
        if not mass or mass <= 0 then mass = 14 end
        local D = 2 * math.sqrt(P * mass)

        local maxF = mass * 60000
        if bodyPos and bodyPos.Parent == hrp then
            bodyPos.MaxForce = Vector3.new(maxF, maxF, maxF)
            bodyPos.P = P
            bodyPos.D = D
            return bodyPos
        end
        if bodyPos then bodyPos:Destroy() end
        local bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(maxF, maxF, maxF)
        bp.P = P
        bp.D = D
        bp.Position = hrp.Position
        bp.Parent = hrp
        bodyPos = bp
        return bp
    end

    local function destroyBodyPos()
        if bodyPos then bodyPos:Destroy(); bodyPos = nil end
    end

    local RETURN_SPEED = 220
    RunService.PreSimulation:Connect(LPH_NO_VIRTUALIZE(function()
        if not autoBuyActive then
            destroyBodyPos()
            _abReturning = false
            return
        end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp then destroyBodyPos(); return end

        if hrp.Anchored then hrp.Anchored = false end
        if hum then
            if hum.PlatformStand then hum.PlatformStand = false end
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Physics then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
        end
        if not partAlive() then

            if _lastAbove and (os.clock() - _lastTargetTime) < 0.7 then
                local bp = ensureBodyPos(hrp)
                bp.Position = _lastAbove
                local lv = hrp.AssemblyLinearVelocity
                if lv.Magnitude > 250 then hrp.AssemblyLinearVelocity = lv.Unit * 250 end
            else
                destroyBodyPos()
            end
            _abReturning = false
            return
        end

        local above = Vector3.new(lockedPart.Position.X, lockedPart.Position.Y + _abTopOff + HOVER_HEIGHT, lockedPart.Position.Z)
        _lastAbove = above
        _lastTargetTime = os.clock()
        local dist = (hrp.Position - above).Magnitude

        if _abReturning then
            if dist < 10 then _abReturning = false end
        elseif dist > 30 then
            _abReturning = true
        end
        if _abReturning then

            destroyBodyPos()
            equipFlyGear()
            local d = above - hrp.Position
            if d.Magnitude > 0.1 then hrp.AssemblyLinearVelocity = d.Unit * RETURN_SPEED end
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        else

            local bp = ensureBodyPos(hrp)
            bp.Position = above
            local lv = hrp.AssemblyLinearVelocity
            if lv.Magnitude > 250 then hrp.AssemblyLinearVelocity = lv.Unit * 250 end
        end
    end))

    task.spawn(LPH_NO_VIRTUALIZE(function()
        while true do
            if not autoBuyActive then task.wait(0.05); continue end

            if promptAlive() then firePurchaseNatural(lockedTarget.prompt); _lockedBuyFired = true end
            RunService.Heartbeat:Wait()
        end
    end))

    local _lastConveyorScan = 0
    task.spawn(function()
        while true do
            task.wait(0.1)
            if not autoBuyActive then
                lockedTarget = nil
                lockedPart = nil
                lockedModel = nil
                _lockedBuyFired = false
                stopCarpetLock()
                destroyBodyPos()
                continue
            end

            keepFlyGearIfIdle()
            if lockedPart or lockedModel then
                if partAlive() then
                    continue
                end

                pcall(refreshConveyor)
                _lastConveyorScan = os.clock()
                lockedTarget = nil
                lockedPart = nil
                lockedModel = nil
                _lockedBuyFired = false

            end

            if os.clock() - _lastConveyorScan > 0.35 then
                _lastConveyorScan = os.clock()
                pcall(refreshConveyor)
            end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            local radius = Config.AutoBuyRange or DETECT_RADIUS
            local best, bestDist = nil, math.huge
            for _, entry in ipairs(SharedState.ConveyorAnimals) do
                if entry.prompt and entry.prompt.Parent and entry.prompt.Enabled and entry.part and entry.part.Parent then
                    local d = (hrp.Position - entry.part.Position).Magnitude
                    if d <= radius and d < bestDist then
                        bestDist = d
                        best = entry
                    end
                end
            end
            if best then
                lockedTarget = best
                lockedPart = best.part
                lockedModel = best.model or best.part.Parent
                _lockedBuyFired = false

                _abTopOff = math.max(lockedPart.Size.Y * 0.5, 3)
                pcall(function()
                    local m = lockedPart
                    for _ = 1, 6 do
                        if m and m:IsA("Model") then break end
                        m = m and m.Parent
                    end
                    if m and m:IsA("Model") then
                        local cf, size = m:GetBoundingBox()
                        local off = (cf.Position.Y + size.Y * 0.5) - lockedPart.Position.Y
                        if off > _abTopOff then _abTopOff = off end
                    end
                end)
                if _abTopOff > 14 then _abTopOff = 14 end
                ShowNotification("AUTO BUY", "Locked")
                startCarpetLock()
            end
        end
    end)

    _G.AutoBuyOnToggle = function(active)
        if active then
            if _G.refreshConveyor then pcall(_G.refreshConveyor) end

            if CarpetState and CarpetState.enabled then pcall(setCarpetSpeed, false) end
            startCarpetLock()
        else
            stopCarpetLock()
            destroyBodyPos()
        end
    end
    end
    _initAutoBuyScope()

    _G.HazhubToggleAutoBuy = function() if toggleAutoBuy then pcall(toggleAutoBuy) end end
    _G.HazhubSetAutoBuy    = function(on) if toggleAutoBuy then pcall(toggleAutoBuy, on) end end
    local _origOnToggle = _G.AutoBuyOnToggle
    _G.AutoBuyOnToggle = function(active)
        _G.HazhubAutoBuy = active and true or false
        if _origOnToggle then pcall(_origOnToggle, active) end
    end
end)
if not okAB then warn("[AUTOBUY] BLOC EN ERREUR: " .. tostring(errAB)) end
end)

nowSpawn(function()
    task.wait(4)
local okFL, errFL = pcall(function()
    local Players          = game:GetService("Players")
    local RunService       = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService     = game:GetService("TweenService")

    local localPlayer = Players.LocalPlayer
    local playerGui   = localPlayer:WaitForChild("PlayerGui", 30)
    if not playerGui then return end

    if _G._FlasherLoaded then return end
    _G._FlasherLoaded = true

    local TOGGLE_KEY   = nil
    local UI_KEY       = Enum.KeyCode.RightShift
    local TURN_SPEED   = 0
    local CLICK_RADIUS = 120

    local cfg    = _G.HubCfg.get("flasher")
    local panelX = tonumber(cfg.panelX) or 460
    local panelY = tonumber(cfg.panelY) or 120
    local function saveCfg()
        cfg.panelX = panelX; cfg.panelY = panelY
        _G.HubCfg.save()
    end

    local enabled          = false
    local selectedPlayer   = nil
    local useNearest       = false
    local useBaseOwner     = true
    local clickFaceTarget  = nil
    local clickFaceEnabled = false
    local searchText       = ""
    local rowButtons       = {}

    local ROW      = UI.C.ROW
    local GREEN    = UI.C.BTN_ON
    local ACCENT   = Color3.fromRGB(148, 64, 255)

    local function getPlotAtPosition(pos)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        local best, bestDist = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            local pp
            if plot:IsA("Model") then
                pp = (plot.PrimaryPart and plot.PrimaryPart.Position) or plot:GetPivot().Position
            else
                pp = plot.Position
            end
            if pp then
                local d = math.sqrt((pos.X - pp.X)^2 + (pos.Z - pp.Z)^2)
                if d < bestDist then bestDist = d; best = plot end
            end
        end
        return (best and bestDist < 72) and best or nil
    end

    local function getPlotOwner(plot)
        if not plot then return nil end
        local sign = plot:FindFirstChild("PlotSign")
        local lbl  = sign
            and sign:FindFirstChild("SurfaceGui")
            and sign.SurfaceGui:FindFirstChild("Frame")
            and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
        if lbl then
            local nick = (lbl.Text and lbl.Text:match("^(.-)'")) or lbl.Text
            if nick and nick ~= "" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.DisplayName == nick or p.Name == nick then return p end
                end
            end
        end
        return nil
    end

    local function resolveBaseOwner()
        local char = localPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local owner = getPlotOwner(getPlotAtPosition(hrp.Position))
        return (owner ~= localPlayer) and owner or nil
    end

    local function getRoot(player)
        local c = player and player.Character
        return c and c:FindFirstChild("HumanoidRootPart")
    end

    local function findNearest(myRoot)
        local closest, closestDist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local root = getRoot(player)
                if root then
                    local dist = (root.Position - myRoot.Position).Magnitude
                    if dist < closestDist then closest, closestDist = player, dist end
                end
            end
        end
        return closest
    end

    local guiParent = (gethui and gethui()) or game:GetService("CoreGui") or playerGui
    pcall(function()
        local old = guiParent:FindFirstChild("FlasherUI")
        if old then old:Destroy() end
    end)
    local gui = Instance.new("ScreenGui")
    gui.Name = "HazhubFaceUI"; gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.DisplayOrder = 131
    pcall(function() gui.Parent = guiParent end)
    if not gui.Parent then gui.Parent = playerGui end

    local main, body = UI.panel({
        name = "Main", title = "HAZHUB FACE", w = 210, h = 132,
        x = panelX, y = panelY, parent = gui,
        onDrop = function(fr)
            panelX, panelY = fr.AbsolutePosition.X, fr.AbsolutePosition.Y
            saveCfg()
        end,
    })

    local updateStatus, refreshHighlight, rebuildList, updateHighlight, pulseHighlight

    local ups = {}
    local function mkToggle(y, label, get, set)
        local b, setOn
        local function up()
            local on = get()
            b.Text = label .. (on and ": ON" or ": OFF")
            setOn(on)
        end
        b, setOn = UI.button({ parent = body, y = y, onClick = function() set(); up() end })
        up(); ups[#ups + 1] = up
        return b
    end
    local function refreshToggles() for _, u in ipairs(ups) do pcall(u) end end

    local function setEnabled(state)
        enabled = state
        _G.HazhubFaceAwayOn = enabled
        local char = localPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = not enabled end
        refreshToggles()
        if updateStatus then updateStatus() end
    end

    _G.HazhubToggleFaceAway = function() setEnabled(not enabled) end

    local function setClickFace(state)
        clickFaceEnabled = state
        if not state then
            clickFaceTarget = nil
            if refreshHighlight then refreshHighlight() end
            if updateStatus then updateStatus() end
        end
        refreshToggles()
    end

    mkToggle(0, "Face Away",
        function() return enabled end,
        function() setEnabled(not enabled) end)

    mkToggle(30, "BASE OWNER",
        function() return useBaseOwner end,
        function()
            clickFaceTarget = nil
            useBaseOwner = true; useNearest = false; selectedPlayer = nil
            refreshToggles()
            if refreshHighlight then refreshHighlight() end
            if updateStatus then updateStatus() end
        end)

    mkToggle(60, "NEAREST",
        function() return useNearest end,
        function()
            clickFaceTarget = nil
            useBaseOwner = false; useNearest = true; selectedPlayer = nil
            refreshToggles()
            if refreshHighlight then refreshHighlight() end
            if updateStatus then updateStatus() end
        end)

    function updateStatus() end

    function refreshHighlight()
        for key, button in pairs(rowButtons) do
            local sel = (not useNearest and not useBaseOwner and not clickFaceTarget
                and key == selectedPlayer)
            button.BackgroundColor3 = sel and GREEN or ROW
        end
    end

    function rebuildList()
        refreshHighlight()
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == TOGGLE_KEY then setEnabled(not enabled)
        elseif input.KeyCode == UI_KEY  then main.Visible = not main.Visible end
    end)

    Players.PlayerAdded:Connect(function() task.defer(rebuildList) end)
    Players.PlayerRemoving:Connect(function(player)
        if player == selectedPlayer then selectedPlayer = nil; useBaseOwner = true end
        if player == clickFaceTarget then clickFaceTarget = nil end
        task.defer(rebuildList); task.defer(updateStatus)
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.2); setEnabled(enabled)
    end)

    local CLICK_COLOR = Color3.fromRGB(200, 120, 255)
    local targetHighlight = Instance.new("Highlight")
    targetHighlight.Name                = "FlasherTargetHighlight"
    targetHighlight.FillTransparency    = 0.6
    targetHighlight.OutlineTransparency = 0
    targetHighlight.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    targetHighlight.Enabled             = false
    targetHighlight.Parent              = gui

    function updateHighlight(targetPlayer)
        local char = targetPlayer and targetPlayer.Character
        if char and (enabled or clickFaceTarget) then
            local color = (targetPlayer == clickFaceTarget) and CLICK_COLOR or ACCENT
            if targetHighlight.Adornee ~= char then targetHighlight.Adornee = char end
            targetHighlight.FillColor    = color
            targetHighlight.OutlineColor = color
            targetHighlight.Enabled      = true
        else
            targetHighlight.Enabled = false
            targetHighlight.Adornee = nil
        end
    end

    function pulseHighlight()
        targetHighlight.FillTransparency = 0.05
        TweenService:Create(targetHighlight,
            TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { FillTransparency = 0.6 }):Play()
    end

    local function playerAtCursor()
        local camera = workspace.CurrentCamera
        if not camera then return nil end
        local mousePos = UserInputService:GetMouseLocation()
        local best, bestDist = nil, CLICK_RADIUS
        for _, player in ipairs(Players:GetPlayers()) do
            local char = player ~= localPlayer and player.Character
            if char then
                for _, partName in ipairs({ "HumanoidRootPart", "Head" }) do
                    local part = char:FindFirstChild(partName)
                    if part then
                        local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local d = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if d < bestDist then best, bestDist = player, d end
                        end
                    end
                end
            end
        end
        return best
    end

    local function resolveTarget(myRoot)
        if clickFaceTarget and clickFaceTarget.Parent then return clickFaceTarget end
        if useBaseOwner then return resolveBaseOwner() end
        if not useNearest then return selectedPlayer end
        return findNearest(myRoot)
    end

    local function flasherStep(dt)
        local myRoot = getRoot(localPlayer)
        local target = myRoot and resolveTarget(myRoot) or clickFaceTarget
        updateHighlight(target)
        if not enabled or not myRoot then return end

        local char = localPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.AutoRotate then hum.AutoRotate = false end

        local targetRoot = getRoot(target)
        if not targetRoot then return end

        local flat = Vector3.new(
            targetRoot.Position.X - myRoot.Position.X,
            0,
            targetRoot.Position.Z - myRoot.Position.Z
        )
        if flat.Magnitude < 0.05 then return end

        local goal = CFrame.lookAt(myRoot.Position, myRoot.Position - flat.Unit)
        if TURN_SPEED <= 0 then
            myRoot.CFrame = goal
        else
            myRoot.CFrame = myRoot.CFrame:Lerp(goal, 1 - math.exp(-TURN_SPEED * dt))
        end

        local av = myRoot.AssemblyAngularVelocity
        if av.Y ~= 0 then
            myRoot.AssemblyAngularVelocity = Vector3.new(av.X, 0, av.Z)
        end
    end

    RunService.RenderStepped:Connect(flasherStep)
    RunService.Heartbeat:Connect(flasherStep)

    rebuildList()
    updateStatus()
    setEnabled(false)
end)
if not okFL then warn("[FLASHER] BLOC EN ERREUR: " .. tostring(errFL)) end
end)