-- HAZ SETTINGS UI (restored features + bigger PC + bottom-right opener)

do
    local UIS = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local Workspace = game:GetService("Workspace")
    local LP = Players.LocalPlayer

    -- ========== EXECUTOR DEVICE FORCE ==========
    local execName = (tostring(_G.RENZO_EXECUTOR or _G.HAZ_EXECUTOR or (identifyexecutor and identifyexecutor()) or "unknown")):lower()
    local isDelta = execName:find("delta", 1, true) ~= nil
    local isPCExec = execName:find("real",1,true) or execName:find("xeno",1,true)
        or execName:find("madium",1,true) or execName:find("solara",1,true)
        or execName:find("potassium",1,true) or execName:find("volt",1,true)
        or execName:find("nexomia",1,true)

    local function classifyDevice()
        if isDelta then return "tablet" end
        if isPCExec then return "pc" end
        local touch, kbd, mouse = false, false, false
        pcall(function()
            touch = UIS.TouchEnabled
            kbd = UIS.KeyboardEnabled
            mouse = UIS.MouseEnabled
        end)
        if kbd and mouse then return "pc" end
        if touch then
            local vp = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize) or Vector2.new(390,760)
            return (math.min(vp.X, vp.Y) >= 600) and "tablet" or "phone"
        end
        return "pc"
    end

    local device = classifyDevice()
    _G.HAZ_Device = device
    _G.HAZ_IsTouch = (device == "phone" or device == "tablet")
    _G.HAZ_IsPhone = (device == "phone")
    _G.HAZ_IsTablet = (device == "tablet")
    _G.HAZ_IsPC = (device == "pc")

    local IS_TOUCH = _G.HAZ_IsTouch
    local MIN_TAP = IS_TOUCH and 42 or 0

    -- ========== WINDOW SIZE (PC actually big now) ==========
    local function viewport()
        local cam = Workspace.CurrentCamera
        return (cam and cam.ViewportSize) or Vector2.new(1280, 720)
    end

    local function windowSize()
        local vp = viewport()
        if _G.HAZ_IsPC then
            return UDim2.fromOffset(560, 420)          -- proper desktop size
        end
        if _G.HAZ_IsTablet then
            local w = math.clamp(vp.X * 0.58, 360, 460)
            local h = math.clamp(vp.Y * 0.58, 280, 340)
            return UDim2.fromOffset(math.floor(w), math.floor(h))
        end
        -- phone
        local w = math.clamp(vp.X - 28, 270, 340)
        local h = math.clamp(vp.Y - 110, 230, 290)
        return UDim2.fromOffset(math.floor(w), math.floor(h))
    end

    -- ========== THEME ==========
    local Theme = {
        MainBackground = Color3.fromRGB(12, 20, 29),
        Background     = Color3.fromRGB(17, 31, 43),
        Panel          = Color3.fromRGB(22, 39, 50),
        Row            = Color3.fromRGB(19, 35, 45),
        RowHover       = Color3.fromRGB(34, 61, 70),
        Accent         = Color3.fromRGB(91, 151, 177),
        AccentLight    = Color3.fromRGB(112, 174, 184),
        Text           = Color3.fromRGB(255,255,255),
        Dim            = Color3.fromRGB(170,180,200),
        Stroke         = Color3.fromRGB(38, 59, 77),
        SoftButton     = Color3.fromRGB(19, 35, 45),
        SoftAccent     = Color3.fromRGB(22, 39, 50),
        ToggleOff      = Color3.fromRGB(36,44,66),
        InputBg        = Color3.fromRGB(14,18,32),
        SliderBg       = Color3.fromRGB(44,54,80),
    }

    -- ========== TOGGLE STATE ==========
    local ToggleState = {}
    local function regToggle(name, default)
        if not ToggleState[name] then ToggleState[name] = {value = default or false, listeners = {}} end
    end
    local function getToggle(name) return ToggleState[name] and ToggleState[name].value or false end
    local function setToggle(name, val, skipNotify)
        regToggle(name)
        ToggleState[name].value = val
        if not skipNotify then
            for _, fn in ipairs(ToggleState[name].listeners) do pcall(fn, val) end
        end
    end
    local function onToggleChanged(name, fn)
        regToggle(name)
        table.insert(ToggleState[name].listeners, fn)
    end

    local Config = _G.HAZ_Config or {
        FPSBoost = false, FPSBoostUltra = false, XRay = false, FOV = 70,
        AntiBeeDisco = false, AutoInvisDuringSteal = false, AutoUnlockOnSteal = false,
        AutoKickOnSteal = false, KickToPrivateServer = false, ClickToAP = false,
        PrioritySoundAlert = false, PrioritySoundID = "", DiscordId = "",
        UIScale = 1, MinGenForGrab = "",
        InstantClone = true, AntiRagdoll = false, InfiniteJump = false,
        Unwalk = false, InvisibleSteal = false, Float = false, CarpetSpeed = false,
        OpenBase = false, ShowBrand = true,
        keybinds = {["Open Menu"] = "LeftControl", ["Job ID"] = "K", ["Proximity"] = "P", ["Carpet Boost"] = "Q"},
    }
    _G.HAZ_Config = Config

    local function saveConfig()
        pcall(function()
            if writefile then
                writefile("HAZ_config.json", game:GetService("HttpService"):JSONEncode(Config))
            end
        end)
    end

    -- ========== HELPERS ==========
    local function corner(o, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r or 4)
        c.Parent = o
        return c
    end
    local function stroke(o, col, th, tr)
        local s = Instance.new("UIStroke")
        s.Color = col or Theme.Stroke
        s.Thickness = th or 1
        s.Transparency = tr or 0
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = o
        return s
    end
    local function tw(o, p, t)
        TweenService:Create(o, TweenInfo.new(t or 0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p):Play()
    end

    -- ========== GUI ROOT ==========
    local old = (gethui and gethui()):FindFirstChild("HAZ_SETTINGS")
    if old then old:Destroy() end

    local gui_sg = Instance.new("ScreenGui")
    gui_sg.Name = "HAZ_SETTINGS"
    gui_sg.ResetOnSpawn = false
    gui_sg.IgnoreGuiInset = true
    gui_sg.DisplayOrder = 9999999
    gui_sg.Parent = (gethui and gethui()) or game:GetService("CoreGui")

    -- ========== BOTTOM-RIGHT OPENER ==========
    local openBtn = Instance.new("TextButton")
    openBtn.Name = "HAZ_Open"
    openBtn.AnchorPoint = Vector2.new(1, 1)
    openBtn.Position = UDim2.new(1, -18, 1, -18)
    openBtn.Size = UDim2.fromOffset(132, 34)
    openBtn.BackgroundColor3 = Color3.fromRGB(14, 22, 32)
    openBtn.BackgroundTransparency = 0.12
    openBtn.BorderSizePixel = 0
    openBtn.Text = "Settings"
    openBtn.Font = Enum.Font.GothamMedium
    openBtn.TextSize = 13
    openBtn.TextColor3 = Color3.fromRGB(200, 220, 235)
    openBtn.AutoButtonColor = false
    openBtn.ZIndex = 50
    openBtn.Parent = gui_sg
    corner(openBtn, 8)
    local openStroke = stroke(openBtn, Color3.fromRGB(60, 90, 115), 1, 0.35)

    openBtn.MouseEnter:Connect(function()
        tw(openBtn, {BackgroundColor3 = Color3.fromRGB(22, 36, 52), BackgroundTransparency = 0}, 0.12)
        tw(openStroke, {Color = Theme.Accent, Transparency = 0.1}, 0.12)
    end)
    openBtn.MouseLeave:Connect(function()
        tw(openBtn, {BackgroundColor3 = Color3.fromRGB(14, 22, 32), BackgroundTransparency = 0.12}, 0.14)
        tw(openStroke, {Color = Color3.fromRGB(60, 90, 115), Transparency = 0.35}, 0.14)
    end)

    -- ========== MAIN WINDOW ==========
    local main = Instance.new("Frame")
    main.Name = "HAZMain"
    main.Size = windowSize()
    main.Position = UDim2.fromOffset(60, 80)
    main.BackgroundColor3 = Theme.MainBackground
    main.BackgroundTransparency = 0.12
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Active = true
    main.Visible = false
    main.Parent = gui_sg
    corner(main, 11)
    stroke(main, Theme.Stroke, 1, 0.4)

    -- header
    local head = Instance.new("Frame")
    head.Name = "Header"
    head.Size = UDim2.new(1, 0, 0, 42)
    head.BackgroundTransparency = 1
    head.Active = true
    head.ZIndex = 21
    head.Parent = main

    local brand = Instance.new("TextLabel")
    brand.Position = UDim2.fromOffset(16, 11)
    brand.Size = UDim2.fromOffset(80, 20)
    brand.BackgroundTransparency = 1
    brand.Text = "HAZ"
    brand.Font = Enum.Font.GothamBold
    brand.TextSize = 17
    brand.TextColor3 = Theme.Accent
    brand.TextXAlignment = Enum.TextXAlignment.Left
    brand.ZIndex = 22
    brand.Parent = head

    local pageTitle = Instance.new("TextLabel")
    pageTitle.Name = "PageTitle"
    pageTitle.Position = UDim2.fromOffset(110, 0)
    pageTitle.Size = UDim2.new(1, -170, 1, 0)
    pageTitle.BackgroundTransparency = 1
    pageTitle.Text = "Misc"
    pageTitle.Font = Enum.Font.GothamMedium
    pageTitle.TextSize = 14
    pageTitle.TextColor3 = Theme.Text
    pageTitle.TextXAlignment = Enum.TextXAlignment.Left
    pageTitle.ZIndex = 22
    pageTitle.Parent = head

    local closeB = Instance.new("TextButton")
    closeB.Position = UDim2.new(1, -34, 0, 9)
    closeB.Size = UDim2.fromOffset(24, 24)
    closeB.BackgroundColor3 = Theme.Row
    closeB.BackgroundTransparency = 0.45
    closeB.BorderSizePixel = 0
    closeB.Text = "×"
    closeB.Font = Enum.Font.GothamBold
    closeB.TextSize = 16
    closeB.TextColor3 = Theme.Text
    closeB.AutoButtonColor = false
    closeB.ZIndex = 23
    closeB.Parent = head
    corner(closeB, 6)
    closeB.MouseButton1Click:Connect(function() main.Visible = false end)

    -- drag
    local dragging, dragStart, startPos = false, nil, nil
    head.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = i.Position - dragStart
        main.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- side + body
    local sideDiv = Instance.new("Frame")
    sideDiv.Position = UDim2.fromOffset(108, 0)
    sideDiv.Size = UDim2.new(0, 1, 1, 0)
    sideDiv.BackgroundColor3 = Theme.Stroke
    sideDiv.BackgroundTransparency = 0.35
    sideDiv.BorderSizePixel = 0
    sideDiv.ZIndex = 20
    sideDiv.Parent = main

    local nav = Instance.new("Frame")
    nav.Name = "TabRail"
    nav.BackgroundTransparency = 1
    nav.Position = UDim2.fromOffset(6, 50)
    nav.Size = UDim2.fromOffset(96, 280)
    nav.ZIndex = 21
    nav.Parent = main

    local mainBody = Instance.new("ScrollingFrame")
    mainBody.Name = "Body"
    mainBody.Position = UDim2.fromOffset(116, 50)
    mainBody.Size = UDim2.new(1, -126, 1, -60)
    mainBody.BackgroundTransparency = 1
    mainBody.BorderSizePixel = 0
    mainBody.ScrollBarThickness = IS_TOUCH and 0 or 4
    mainBody.ScrollBarImageColor3 = Theme.Accent
    mainBody.CanvasSize = UDim2.new(0, 0, 0, 0)
    mainBody.AutomaticCanvasSize = Enum.AutomaticSize.Y
    mainBody.ZIndex = 20
    mainBody.Parent = main

    local list = Instance.new("UIListLayout", mainBody)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 5)
    local pad = Instance.new("UIPadding", mainBody)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 3)
    pad.PaddingRight = UDim.new(0, 6)

    -- ========== CARD BUILDERS ==========
    local BoundToggles = {}

    local function cardToggle(parent, text, getState, onPress)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -4, 0, math.max(30, MIN_TAP - 6))
        card.BackgroundColor3 = Theme.Row
        card.BackgroundTransparency = 0.28
        card.BorderSizePixel = 0
        card.Parent = parent
        corner(card, 7)
        stroke(card, Theme.Stroke, 1, 0.65)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -56, 1, 0)
        lbl.Position = UDim2.fromOffset(12, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextColor3 = Theme.Text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = card

        local sw = Instance.new("Frame")
        sw.Size = UDim2.fromOffset(36, 19)
        sw.Position = UDim2.new(1, -46, 0.5, -9.5)
        sw.BackgroundColor3 = Theme.ToggleOff
        sw.BorderSizePixel = 0
        sw.Parent = card
        corner(sw, 10)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(15, 15)
        knob.Position = UDim2.fromOffset(2, 2)
        knob.BackgroundColor3 = Color3.fromRGB(230, 238, 245)
        knob.BorderSizePixel = 0
        knob.Parent = sw
        corner(knob, 8)

        local function paint(on)
            tw(sw, {BackgroundColor3 = on and Theme.Accent or Theme.ToggleOff}, 0.13)
            tw(knob, {Position = on and UDim2.fromOffset(19, 2) or UDim2.fromOffset(2, 2)}, 0.13)
        end
        paint(getState())

        local hit = Instance.new("TextButton")
        hit.Size = UDim2.new(1, 0, 1, 0)
        hit.BackgroundTransparency = 1
        hit.Text = ""
        hit.AutoButtonColor = false
        hit.Parent = card
        hit.MouseButton1Click:Connect(function()
            onPress()
            paint(getState())
        end)
        hit.MouseEnter:Connect(function() tw(card, {BackgroundColor3 = Theme.RowHover}, 0.1) end)
        hit.MouseLeave:Connect(function() tw(card, {BackgroundColor3 = Theme.Row}, 0.12) end)

        return paint
    end

    local function makeSyncMainToggle(parent, text, toggleName, callback)
        regToggle(toggleName, getToggle(toggleName) or Config[toggleName:gsub(" ", "")] or false)
        local paint = cardToggle(parent, text, function() return getToggle(toggleName) end, function()
            local nv = not getToggle(toggleName)
            setToggle(toggleName, nv)
            if callback then callback(nv) end
        end)
        onToggleChanged(toggleName, function(val) paint(val) end)
        BoundToggles[text] = function(ns, fire)
            if typeof(ns) == "boolean" then
                setToggle(toggleName, ns)
                if fire ~= false and callback then callback(ns) end
            end
        end
        return BoundToggles[text]
    end

    local function makeMainToggle(parent, text, enabled, callback)
        local state = enabled
        local paint
        local function setState(ns, fire)
            state = ns
            paint(state)
            if fire ~= false and callback then callback(state) end
        end
        paint = cardToggle(parent, text, function() return state end, function() setState(not state, true) end)
        BoundToggles[text] = function(ns, fire)
            if typeof(ns) == "boolean" then setState(ns, fire) else setState(not state, true) end
        end
        return BoundToggles[text]
    end

    local function makeQuickSlider(parent, text, min, max, default, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -4, 0, 46)
        row.BackgroundColor3 = Theme.Row
        row.BackgroundTransparency = 0.32
        row.BorderSizePixel = 0
        row.Parent = parent
        corner(row, 7)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.55, 0, 0, 18)
        lbl.Position = UDim2.fromOffset(12, 5)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextColor3 = Theme.Text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0.4, 0, 0, 18)
        valLbl.Position = UDim2.new(0.55, 0, 0, 5)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(default)
        valLbl.Font = Enum.Font.GothamMedium
        valLbl.TextSize = 12
        valLbl.TextColor3 = Theme.Accent
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.Parent = row

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -24, 0, IS_TOUCH and 11 or 7)
        bar.Position = UDim2.fromOffset(12, 30)
        bar.BackgroundColor3 = Theme.SliderBg
        bar.BorderSizePixel = 0
        bar.Parent = row
        corner(bar, 4)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Theme.Accent
        fill.BorderSizePixel = 0
        fill.Parent = bar
        corner(fill, 4)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(IS_TOUCH and 18 or 13, IS_TOUCH and 18 or 13)
        knob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
        knob.BackgroundColor3 = Color3.fromRGB(245, 248, 255)
        knob.BorderSizePixel = 0
        knob.Parent = bar
        corner(knob, 9)

        local dragging = false
        local function update(px)
            local a = math.clamp((px - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
            local v = math.floor(min + a * (max - min) + 0.5)
            fill.Size = UDim2.new(a, 0, 1, 0)
            knob.Position = UDim2.new(a, -6, 0.5, -6)
            valLbl.Text = tostring(v)
            if callback then callback(v) end
        end

        bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(i.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                update(i.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    local function makeMainTextBox(parent, text, default, placeholder, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -4, 0, 54)
        row.BackgroundColor3 = Theme.Row
        row.BackgroundTransparency = 0.32
        row.BorderSizePixel = 0
        row.Parent = parent
        corner(row, 7)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -14, 0, 16)
        lbl.Position = UDim2.fromOffset(12, 5)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 11
        lbl.TextColor3 = Theme.Dim
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -18, 0, 26)
        box.Position = UDim2.fromOffset(9, 23)
        box.BackgroundColor3 = Theme.InputBg
        box.BorderSizePixel = 0
        box.Text = tostring(default or "")
        box.PlaceholderText = placeholder or ""
        box.Font = Enum.Font.Gotham
        box.TextSize = 13
        box.TextColor3 = Theme.Text
        box.PlaceholderColor3 = Theme.Dim
        box.ClearTextOnFocus = false
        box.Parent = row
        corner(box, 6)
        stroke(box, Theme.Stroke, 1, 0.55)

        box.FocusLost:Connect(function()
            if callback then callback(box.Text) end
        end)
    end

    local function clearBody()
        for _, c in ipairs(mainBody:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
                c:Destroy()
            end
        end
    end

    -- ========== TABS ==========
    local tabs = {"Keybinds", "ESP", "UI", "Misc", "Priority"}
    local tabIcons = {
        ["Keybinds"] = "KEYBINDS",
        ["ESP"] = "ESP",
        ["UI"] = "MAIN",
        ["Misc"] = "MISC",
        ["Priority"] = "ADMIN PANEL"
    }
    local tabButtons = {}

    local function lineIcon(parent, kind)
        local icon = Instance.new("Frame")
        icon.Name = "LineIcon"
        icon.Position = UDim2.new(0, 9, 0.5, -7)
        icon.Size = UDim2.fromOffset(14, 14)
        icon.BackgroundTransparency = 1
        icon.ZIndex = 24
        icon.Parent = parent
        local color = Theme.Dim
        local function line(x1, y1, x2, y2)
            local dx, dy = x2 - x1, y2 - y1
            local part = Instance.new("Frame")
            part.AnchorPoint = Vector2.new(0.5, 0.5)
            part.Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2)
            part.Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), 1)
            part.Rotation = math.deg(math.atan2(dy, dx))
            part.BackgroundColor3 = color
            part.BorderSizePixel = 0
            part.ZIndex = 24
            part.Parent = icon
        end
        local function ring(x, y, w, h)
            local r = Instance.new("Frame")
            r.Position = UDim2.fromOffset(x, y)
            r.Size = UDim2.fromOffset(w, h)
            r.BackgroundTransparency = 1
            r.ZIndex = 24
            r.Parent = icon
            corner(r, 100)
            stroke(r, color, 1, 0)
        end
        if kind == "MAIN" then
            ring(4, 1, 6, 6); line(2, 13, 3, 10); line(3, 10, 7, 8); line(7, 8, 11, 10); line(11, 10, 12, 13)
        elseif kind == "ESP" then
            ring(1, 4, 12, 7); ring(5, 5, 4, 4)
        elseif kind == "MISC" then
            line(3, 1, 3, 13); line(7, 1, 7, 13); line(11, 1, 11, 13); line(1, 4, 5, 4); line(5, 10, 9, 10); line(9, 6, 13, 6)
        elseif kind == "ADMIN PANEL" then
            line(7, 1, 12, 3); line(12, 3, 11, 10); line(11, 10, 7, 13); line(7, 13, 3, 10); line(3, 10, 2, 3); line(2, 3, 7, 1)
        else
            line(1, 3, 13, 3); line(13, 3, 13, 11); line(13, 11, 1, 11); line(1, 11, 1, 3); line(4, 6, 4, 7); line(7, 6, 7, 7); line(10, 6, 10, 7); line(4, 9, 10, 9)
        end
    end

    for i, name in ipairs(tabs) do
        local b = Instance.new("TextButton")
        b.Position = UDim2.fromOffset(0, (i - 1) * 30)
        b.Size = UDim2.new(1, 0, 0, 28)
        b.BackgroundColor3 = Theme.Panel
        b.BackgroundTransparency = 1
        b.BorderSizePixel = 0
        b.Text = ""
        b.AutoButtonColor = false
        b.ZIndex = 22
        b.Parent = nav
        corner(b, 6)

        lineIcon(b, tabIcons[name])
        local lb = Instance.new("TextLabel")
        lb.Name = "TabLabel"
        lb.Position = UDim2.fromOffset(28, 0)
        lb.Size = UDim2.new(1, -32, 1, 0)
        lb.BackgroundTransparency = 1
        lb.Text = name
        lb.Font = Enum.Font.Gotham
        lb.TextSize = 12
        lb.TextColor3 = Theme.Dim
        lb.TextXAlignment = Enum.TextXAlignment.Left
        lb.ZIndex = 24
        lb.Parent = b

        tabButtons[name] = b
        b.MouseButton1Click:Connect(function()
            loadTab(name)
        end)
    end

    -- ========== LOAD TAB ==========
    function loadTab(tabName)
        clearBody()
        pageTitle.Text = tabName

        for name, btn in pairs(tabButtons) do
            local act = (name == tabName)
            btn.BackgroundTransparency = act and 0 or 1
            btn.BackgroundColor3 = act and Theme.Accent or Theme.Panel
            local lb = btn:FindFirstChild("TabLabel")
            if lb then lb.TextColor3 = act and Color3.fromRGB(10, 16, 24) or Theme.Dim end
        end

        if tabName == "Misc" then
            makeMainToggle(mainBody, "Instant Clone", Config.InstantClone, function(on)
                Config.InstantClone = on; saveConfig()
            end)
            makeMainToggle(mainBody, "Auto Invisible During Steal", Config.AutoInvisDuringSteal, function(on)
                Config.AutoInvisDuringSteal = on; _G.AutoInvisDuringSteal = on; saveConfig()
            end)
            makeMainToggle(mainBody, "Auto Unlock During Steal", Config.AutoUnlockOnSteal, function(on)
                Config.AutoUnlockOnSteal = on; saveConfig()
            end)
            makeSyncMainToggle(mainBody, "Anti Ragdoll", "AntiRagdoll", function(on)
                Config.AntiRagdoll = on; saveConfig()
                if on and _G.startAntiRagdoll then pcall(_G.startAntiRagdoll) end
                if not on and _G.stopAntiRagdoll then pcall(_G.stopAntiRagdoll) end
            end)
            makeSyncMainToggle(mainBody, "Infinite Jump", "InfiniteJump", function(on)
                Config.InfiniteJump = on; saveConfig()
                if _G.setInfiniteJump then pcall(_G.setInfiniteJump, on) end
            end)
            makeMainToggle(mainBody, "Auto Kick On Steal", Config.AutoKickOnSteal, function(on)
                Config.AutoKickOnSteal = on; saveConfig()
            end)
            makeMainToggle(mainBody, "Kick to Private Server", Config.KickToPrivateServer, function(on)
                Config.KickToPrivateServer = on; saveConfig()
            end)
            makeSyncMainToggle(mainBody, "Unwalk", "Unwalk", function(on)
                Config.Unwalk = on; saveConfig()
                if _G.setUnwalk then pcall(_G.setUnwalk, on) end
            end)
            makeSyncMainToggle(mainBody, "Invisible Steal", "InvisibleSteal", function(on)
                Config.InvisibleSteal = on; saveConfig()
                if _G.toggleInvisibleSteal then pcall(_G.toggleInvisibleSteal) end
            end)
            makeSyncMainToggle(mainBody, "Float", "Float", function(on)
                Config.Float = on; saveConfig()
                if _G.setFloat then pcall(_G.setFloat, on) end
            end)
            makeSyncMainToggle(mainBody, "Carpet Speed", "CarpetSpeed", function(on)
                Config.CarpetSpeed = on; saveConfig()
                if _G.setCarpetSpeed then pcall(_G.setCarpetSpeed, on) end
            end)
            makeSyncMainToggle(mainBody, "Click to AP", "ClickToAP", function(on)
                Config.ClickToAP = on; saveConfig()
            end)
            makeSyncMainToggle(mainBody, "Open Base", "OpenBase", function(on)
                Config.OpenBase = on; saveConfig()
                if _G.setOpenBaseButtons then pcall(_G.setOpenBaseButtons, on) end
            end)
            makeSyncMainToggle(mainBody, "FPS Boost", "FPSBoost", function(on)
                Config.FPSBoost = on; saveConfig()
                if _G.setFPSBoost then pcall(_G.setFPSBoost, on) end
            end)
            makeSyncMainToggle(mainBody, "FPS Boost Ultra", "FPSBoostUltra", function(on)
                Config.FPSBoostUltra = on; saveConfig()
                if _G.setFPSBoostUltra then pcall(_G.setFPSBoostUltra, on) end
            end)
            makeSyncMainToggle(mainBody, "Xray", "XRay", function(on)
                Config.XRay = on; saveConfig()
                if _G.setXRay then pcall(_G.setXRay, on) end
            end)
            makeQuickSlider(mainBody, "FOV", 50, 120, Config.FOV or 70, function(v)
                Config.FOV = v; saveConfig()
                pcall(function() Workspace.CurrentCamera.FieldOfView = v end)
            end)
            makeSyncMainToggle(mainBody, "Anti-Bee & Anti-Disco", "AntiBeeDisco", function(on)
                Config.AntiBeeDisco = on; saveConfig()
            end)
            makeMainTextBox(mainBody, "Min Gen for Nearest Grab", Config.MinGenForGrab or "", "e.g. 10k, 500k, 1m", function(v)
                Config.MinGenForGrab = v; saveConfig()
            end)
            makeMainTextBox(mainBody, "Steal Ping Discord ID", Config.DiscordId or "", "e.g. 123456789012345678", function(v)
                Config.DiscordId = tostring(v or ""):gsub("[^%d]", ""); saveConfig()
            end)

        elseif tabName == "UI" then
            makeQuickSlider(mainBody, "UI Scale", 50, 200, (Config.UIScale or 1) * 100, function(v)
                local s = v / 100
                Config.UIScale = s; saveConfig()
                if _G.RenzoSetUIScale then pcall(_G.RenzoSetUIScale, s) end
            end)
            makeMainToggle(mainBody, "Show Brand", Config.ShowBrand, function(on)
                Config.ShowBrand = on; saveConfig()
            end)

        elseif tabName == "Keybinds" then
            local binds = {
                {"Open Menu", Config.keybinds["Open Menu"] or "LeftControl"},
                {"Job ID", Config.keybinds["Job ID"] or "K"},
                {"Proximity", Config.keybinds["Proximity"] or "P"},
                {"Carpet Boost", Config.keybinds["Carpet Boost"] or "Q"},
            }
            for _, b in ipairs(binds) do
                makeMainTextBox(mainBody, b[1], b[2], "key name", function(v)
                    Config.keybinds[b[1]] = v; saveConfig()
                end)
            end

        elseif tabName == "ESP" then
            makeMainToggle(mainBody, "Player ESP", false, function() end)
            makeMainToggle(mainBody, "Pet ESP", false, function() end)
            makeMainToggle(mainBody, "Base ESP", false, function() end)
            makeMainToggle(mainBody, "Name Tags", true, function() end)
            makeMainToggle(mainBody, "Distance", true, function() end)
            makeMainToggle(mainBody, "Health Bars", false, function() end)

        elseif tabName == "Priority" then
            makeMainToggle(mainBody, "Priority Sound Alert", Config.PrioritySoundAlert, function(on)
                Config.PrioritySoundAlert = on; saveConfig()
            end)
            makeMainTextBox(mainBody, "Custom Sound ID", Config.PrioritySoundID or "", "e.g. 123456789", function(v)
                Config.PrioritySoundID = v; saveConfig()
            end)
            makeMainToggle(mainBody, "ADMIN PANEL COMMANDS", true, function() end)
            makeMainToggle(mainBody, "CLICK TO AP COMMANDS", Config.ClickToAP, function(on)
                Config.ClickToAP = on; saveConfig()
            end)
            makeMainToggle(mainBody, "SPAM BASE OWNER COMMANDS", false, function() end)
        end
    end

    -- default
    loadTab("Misc")

    -- open / close
    local function toggleMenu()
        main.Visible = not main.Visible
    end

    openBtn.MouseButton1Click:Connect(toggleMenu)

    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.LeftControl then
            toggleMenu()
        end
    end)

    -- resize on viewport
    local cam = Workspace.CurrentCamera
    if cam then
        cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            main.Size = windowSize()
        end)
    end

    _G.HAZ_ToggleMenu = toggleMenu

    print("[HAZ] settings online | device:", device, "| size:", tostring(windowSize()))
end