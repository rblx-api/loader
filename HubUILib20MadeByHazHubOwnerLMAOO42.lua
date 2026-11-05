--[[
    glass hub ui // made by hazhub. open source
    usage:

    local Hub = loadstring(game:HttpGet("https://raw.githubusercontent.com/rblx-api-loader/main/HubUILib%20%MadeByHazHubOwnerLMAOO42"))()

    local Window = Hub:CreateWindow({
        Title = "private",
        Size = UDim2.new(0, 560, 0, 400),
        ToggleKey = Enum.KeyCode.RightShift
    })

    local Tab = Window:AddTab("Main")
    local Group = Tab:AddGroup("Player")

    Group:AddToggle("Fly", {
        Text = "Fly",
        Default = false,
        Callback = function(v) print(v) end
    })
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Library = {
    Toggles = {},
    Options = {},
    Flags = {},
    Connections = {},
    Unloaded = false,
}

-- glass theme
local Theme = {
    Base        = Color3.fromRGB(26, 24, 35),
    Surface     = Color3.fromRGB(40, 37, 54),
    SurfaceHi   = Color3.fromRGB(52, 47, 71),
    Surface2    = Color3.fromRGB(36, 33, 49),
    Stroke      = Color3.fromRGB(66, 59, 92),
    Violet      = Color3.fromRGB(118, 80, 240),
    Purple      = Color3.fromRGB(146, 112, 255),
    Orchid      = Color3.fromRGB(178, 124, 255),
    Lilac       = Color3.fromRGB(196, 178, 255),
    Ink         = Color3.fromRGB(236, 232, 250),
    Dim         = Color3.fromRGB(152, 144, 184),
    White       = Color3.fromRGB(255, 255, 255),
    Success     = Color3.fromRGB(72, 199, 142),
    Danger      = Color3.fromRGB(255, 92, 110),
}

local ACCENT_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Theme.Violet),
    ColorSequenceKeypoint.new(0.55, Theme.Purple),
    ColorSequenceKeypoint.new(1.00, Theme.Orchid),
})

local function tween(obj, props, time, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.22, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

local function protect(gui)
    if syn and syn.protect_gui then
        pcall(syn.protect_gui, gui)
        gui.Parent = CoreGui
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = CoreGui
    end
end

local function corner(parent, r)
    return create("UICorner", {CornerRadius = UDim.new(0, r or 12), Parent = parent})
end

local function stroke(parent, color, thickness, trans)
    return create("UIStroke", {
        Color = color or Theme.Stroke,
        Thickness = thickness or 1,
        Transparency = trans or 0.3,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function gradient(parent, colors, rotation)
    return create("UIGradient", {
        Color = colors or ACCENT_GRADIENT,
        Rotation = rotation or 0,
        Parent = parent
    })
end

local function give(conn)
    table.insert(Library.Connections, conn)
    return conn
end

local function softOrb(parent, color, size, strength)
    local holder = create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(size, size),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = parent,
    })
    for i = 1, 7 do
        local scale = (i / 7) ^ 0.75
        local ring = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(scale, scale),
            BackgroundColor3 = color,
            BackgroundTransparency = 1 - (strength * (1 - (i-1)/7) * 0.7),
            Parent = holder,
        })
        create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ring})
    end
    return holder
end

function Library:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "hub"
    local size = cfg.Size or UDim2.new(0, 560, 0, 400)
    local toggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift

    local ScreenGui = create("ScreenGui", {
        Name = "GlassHub_" .. math.random(10000, 99999),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 100,
    })
    protect(ScreenGui)
    Library.ScreenGui = ScreenGui

    local Screen = create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Parent = ScreenGui,
    })

    -- outer glow
    local Glow = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = size,
        BackgroundTransparency = 1,
        ZIndex = 0,
        Parent = Screen,
    })
    for i = 1, 5 do
        local layer = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 3 + i),
            Size = UDim2.new(1, i * 10, 1, i * 10),
            BackgroundColor3 = (i <= 2) and Theme.Lilac or Theme.Purple,
            BackgroundTransparency = 0.92 + i * 0.01,
            Parent = Glow,
        })
        corner(layer, 24 + i * 4)
    end

    local Window = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = size,
        BackgroundTransparency = 1,
        ZIndex = 1,
        Parent = Screen,
    })

    local WindowScale = create("UIScale", {Scale = 0.92, Parent = Window})
    tween(WindowScale, {Scale = 1}, 0.45, Enum.EasingStyle.Back)

    -- glass body
    local Body = create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.Base,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = Window,
    })
    corner(Body, 20)
    stroke(Body, Theme.Stroke, 1.2, 0.4)

    -- fluid backdrop orbs
    local orbs = {
        {color = Theme.Purple, size = 280, strength = 0.22, x = 0.15, y = 0.2},
        {color = Theme.Orchid, size = 240, strength = 0.18, x = 0.85, y = 0.25},
        {color = Theme.Violet, size = 220, strength = 0.2,  x = 0.7,  y = 0.9},
        {color = Theme.Lilac,  size = 300, strength = 0.1,  x = 0.4,  y = 0.5},
    }
    for _, spec in ipairs(orbs) do
        local orb = softOrb(Body, spec.color, spec.size, spec.strength)
        orb.Position = UDim2.fromScale(spec.x, spec.y)
        orb.ZIndex = 1
    end

    -- top sheen
    local sheen = create("Frame", {
        Size = UDim2.new(1, 0, 0, 80),
        BackgroundColor3 = Theme.White,
        BackgroundTransparency = 0.97,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Body,
    })
    create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.7),
            NumberSequenceKeypoint.new(0.6, 0.95),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Rotation = 90,
        Parent = sheen,
    })

    -- title bar
    local TitleBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = Body,
    })

    local TitleLabel = create("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 18, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Ink,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = TitleBar,
    })

    local CloseBtn = create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -40, 0.5, -14),
        BackgroundColor3 = Theme.White,
        BackgroundTransparency = 0.85,
        Text = "×",
        TextColor3 = Theme.White,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 6,
        Parent = TitleBar,
    })
    corner(CloseBtn, 8)

    CloseBtn.MouseEnter:Connect(function()
        tween(CloseBtn, {BackgroundTransparency = 0.55, BackgroundColor3 = Theme.Danger})
    end)
    CloseBtn.MouseLeave:Connect(function()
        tween(CloseBtn, {BackgroundTransparency = 0.85, BackgroundColor3 = Theme.White})
    end)

    -- drag
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    give(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            Glow.Position = Window.Position
        end
    end))

    -- left sidebar tabs
    local Sidebar = create("Frame", {
        Size = UDim2.new(0, 140, 1, -60),
        Position = UDim2.new(0, 12, 0, 52),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = Body,
    })
    local TabList = create("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Purple,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = Sidebar,
    })
    local TabLayout = create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabList,
    })
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
    end)

    -- content
    local Content = create("Frame", {
        Size = UDim2.new(1, -168, 1, -64),
        Position = UDim2.new(0, 156, 0, 52),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = Body,
    })

    local Win = {
        Main = Window,
        Body = Body,
        ScreenGui = ScreenGui,
        Tabs = {},
        ActiveTab = nil,
        Visible = true,
    }

    function Win:Toggle(vis)
        if vis == nil then vis = not self.Visible end
        self.Visible = vis
        if vis then
            Window.Visible = true
            Glow.Visible = true
            WindowScale.Scale = 0.9
            tween(WindowScale, {Scale = 1}, 0.4, Enum.EasingStyle.Back)
        else
            tween(WindowScale, {Scale = 0.9}, 0.18)
            task.delay(0.18, function()
                if not self.Visible then
                    Window.Visible = false
                    Glow.Visible = false
                end
            end)
        end
    end

    CloseBtn.MouseButton1Click:Connect(function()
        Win:Toggle(false)
    end)

    give(UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            Win:Toggle()
        end
    end))

    function Win:AddTab(name)
        local TabBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Theme.Surface,
            BackgroundTransparency = 0.4,
            Text = "",
            BorderSizePixel = 0,
            AutoButtonColor = false,
            ZIndex = 6,
            Parent = TabList,
        })
        corner(TabBtn, 10)
        stroke(TabBtn, Theme.Stroke, 1, 0.5)

        local TabLabel = create("TextLabel", {
            Size = UDim2.new(1, -16, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Theme.Dim,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 7,
            Parent = TabBtn,
        })

        local Page = create("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Purple,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            ZIndex = 6,
            Parent = Content,
        })
        local PageLayout = create("UIListLayout", {
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Page,
        })
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        local Tab = {
            Name = name,
            Button = TabBtn,
            Label = TabLabel,
            Page = Page,
            Groups = {},
        }

        local function select()
            for _, t in ipairs(Win.Tabs) do
                t.Page.Visible = false
                tween(t.Button, {BackgroundTransparency = 0.4, BackgroundColor3 = Theme.Surface})
                tween(t.Label, {TextColor3 = Theme.Dim})
            end
            Page.Visible = true
            tween(TabBtn, {BackgroundTransparency = 0.1, BackgroundColor3 = Theme.Purple})
            tween(TabLabel, {TextColor3 = Theme.White})
            Win.ActiveTab = Tab
        end

        TabBtn.MouseButton1Click:Connect(select)
        TabBtn.MouseEnter:Connect(function()
            if Win.ActiveTab ~= Tab then
                tween(TabBtn, {BackgroundTransparency = 0.25})
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if Win.ActiveTab ~= Tab then
                tween(TabBtn, {BackgroundTransparency = 0.4})
            end
        end)

        table.insert(Win.Tabs, Tab)
        if #Win.Tabs == 1 then select() end

        function Tab:AddGroup(title)
            local Card = create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.25,
                BorderSizePixel = 0,
                ZIndex = 7,
                Parent = Page,
            })
            corner(Card, 14)
            stroke(Card, Theme.Stroke, 1, 0.45)

            local Header = create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 14, 0, 6),
                BackgroundTransparency = 1,
                Text = title or "Group",
                TextColor3 = Theme.Lilac,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 8,
                Parent = Card,
            })

            local Body = create("Frame", {
                Size = UDim2.new(1, -16, 0, 0),
                Position = UDim2.new(0, 8, 0, 36),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ZIndex = 8,
                Parent = Card,
            })
            create("UIListLayout", {
                Padding = UDim.new(0, 7),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Body,
            })
            create("UIPadding", {
                PaddingBottom = UDim.new(0, 12),
                Parent = Body,
            })

            local Group = { Card = Card, Body = Body }

            function Group:AddLabel(text)
                return create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = text or "",
                    TextColor3 = Theme.Dim,
                    TextSize = 12,
                    Font = Enum.Font.GothamMedium,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    ZIndex = 9,
                    Parent = Body,
                })
            end

            function Group:AddButton(text, callback)
                if type(text) == "table" then
                    callback = text.Callback or text.Func
                    text = text.Text
                end
                local Btn = create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Theme.SurfaceHi,
                    BackgroundTransparency = 0.3,
                    Text = text or "Button",
                    TextColor3 = Theme.Ink,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    ZIndex = 9,
                    Parent = Body,
                })
                corner(Btn, 9)
                stroke(Btn, Theme.Stroke, 1, 0.5)

                Btn.MouseEnter:Connect(function()
                    tween(Btn, {BackgroundColor3 = Theme.Purple, BackgroundTransparency = 0.15})
                end)
                Btn.MouseLeave:Connect(function()
                    tween(Btn, {BackgroundColor3 = Theme.SurfaceHi, BackgroundTransparency = 0.3})
                end)
                Btn.MouseButton1Click:Connect(function()
                    if callback then task.spawn(callback) end
                end)
                return Btn
            end

            function Group:AddToggle(flag, opts)
                opts = opts or {}
                if type(flag) == "table" then
                    opts = flag
                    flag = opts.Flag or opts.Text
                end
                local state = opts.Default or false
                Library.Flags[flag] = state

                local Holder = create("Frame", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Theme.SurfaceHi,
                    BackgroundTransparency = 0.35,
                    BorderSizePixel = 0,
                    ZIndex = 9,
                    Parent = Body,
                })
                corner(Holder, 9)

                create("TextLabel", {
                    Size = UDim2.new(1, -52, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1,
                    Text = opts.Text or flag,
                    TextColor3 = Theme.Ink,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 10,
                    Parent = Holder,
                })

                local Switch = create("Frame", {
                    Size = UDim2.new(0, 36, 0, 20),
                    Position = UDim2.new(1, -44, 0.5, -10),
                    BackgroundColor3 = state and Theme.Purple or Color3.fromRGB(50, 46, 68),
                    BorderSizePixel = 0,
                    ZIndex = 10,
                    Parent = Holder,
                })
                corner(Switch, 10)

                local Knob = create("Frame", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    BackgroundColor3 = Theme.White,
                    BorderSizePixel = 0,
                    ZIndex = 11,
                    Parent = Switch,
                })
                corner(Knob, 8)

                local function set(v)
                    state = v
                    Library.Flags[flag] = v
                    tween(Switch, {BackgroundColor3 = state and Theme.Purple or Color3.fromRGB(50, 46, 68)})
                    tween(Knob, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                    if opts.Callback then task.spawn(opts.Callback, state) end
                end

                Holder.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        set(not state)
                    end
                end)

                local Toggle = { Value = state, Set = set, Get = function() return state end }
                Library.Toggles[flag] = Toggle
                return Toggle
            end

            function Group:AddSlider(flag, opts)
                opts = opts or {}
                if type(flag) == "table" then
                    opts = flag
                    flag = opts.Flag or opts.Text
                end
                local min = opts.Min or 0
                local max = opts.Max or 100
                local value = opts.Default or min
                Library.Flags[flag] = value

                local Holder = create("Frame", {
                    Size = UDim2.new(1, 0, 0, 48),
                    BackgroundColor3 = Theme.SurfaceHi,
                    BackgroundTransparency = 0.35,
                    BorderSizePixel = 0,
                    ZIndex = 9,
                    Parent = Body,
                })
                corner(Holder, 9)

                create("TextLabel", {
                    Size = UDim2.new(1, -60, 0, 18),
                    Position = UDim2.new(0, 12, 0, 6),
                    BackgroundTransparency = 1,
                    Text = opts.Text or flag,
                    TextColor3 = Theme.Ink,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 10,
                    Parent = Holder,
                })

                local ValueLabel = create("TextLabel", {
                    Size = UDim2.new(0, 50, 0, 18),
                    Position = UDim2.new(1, -58, 0, 6),
                    BackgroundTransparency = 1,
                    Text = tostring(value),
                    TextColor3 = Theme.Lilac,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 10,
                    Parent = Holder,
                })

                local BarBG = create("Frame", {
                    Size = UDim2.new(1, -24, 0, 6),
                    Position = UDim2.new(0, 12, 0, 32),
                    BackgroundColor3 = Color3.fromRGB(45, 40, 62),
                    BorderSizePixel = 0,
                    ZIndex = 10,
                    Parent = Holder,
                })
                corner(BarBG, 3)

                local Fill = create("Frame", {
                    Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0),
                    BackgroundColor3 = Theme.Purple,
                    BorderSizePixel = 0,
                    ZIndex = 11,
                    Parent = BarBG,
                })
                corner(Fill, 3)
                gradient(Fill, ACCENT_GRADIENT, 0)

                local sliding = false
                local function update(input)
                    local rel = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * rel + 0.5)
                    Library.Flags[flag] = value
                    Fill.Size = UDim2.new(rel, 0, 1, 0)
                    ValueLabel.Text = tostring(value)
                    if opts.Callback then task.spawn(opts.Callback, value) end
                end

                BarBG.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        update(input)
                    end
                end)
                give(UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        update(input)
                    end
                end))
                give(UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end))

                local Slider = {
                    Value = value,
                    Set = function(v)
                        value = math.clamp(v, min, max)
                        Library.Flags[flag] = value
                        local rel = (value - min) / math.max(max - min, 1)
                        Fill.Size = UDim2.new(rel, 0, 1, 0)
                        ValueLabel.Text = tostring(value)
                    end,
                    Get = function() return value end,
                }
                Library.Options[flag] = Slider
                return Slider
            end

            function Group:AddDropdown(flag, opts)
                opts = opts or {}
                if type(flag) == "table" then
                    opts = flag
                    flag = opts.Flag or opts.Text
                end
                local values = opts.Values or {}
                local current = opts.Default or values[1]
                Library.Flags[flag] = current

                local Holder = create("Frame", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Theme.SurfaceHi,
                    BackgroundTransparency = 0.35,
                    BorderSizePixel = 0,
                    ZIndex = 9,
                    Parent = Body,
                })
                corner(Holder, 9)

                create("TextLabel", {
                    Size = UDim2.new(0.42, 0, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1,
                    Text = opts.Text or flag,
                    TextColor3 = Theme.Ink,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 10,
                    Parent = Holder,
                })

                local DropBtn = create("TextButton", {
                    Size = UDim2.new(0.52, -8, 0, 24),
                    Position = UDim2.new(0.48, 0, 0.5, -12),
                    BackgroundColor3 = Theme.Surface2,
                    Text = tostring(current) .. "  ▼",
                    TextColor3 = Theme.Lilac,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    ZIndex = 10,
                    Parent = Holder,
                })
                corner(DropBtn, 7)

                local open = false
                local DropFrame = create("Frame", {
                    Size = UDim2.new(0.52, -8, 0, 0),
                    Position = UDim2.new(0.48, 0, 1, 6),
                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel = 0,
                    Visible = false,
                    ZIndex = 30,
                    Parent = Holder,
                })
                corner(DropFrame, 9)
                stroke(DropFrame, Theme.Stroke, 1, 0.3)
                create("UIListLayout", {Padding = UDim.new(0, 2), Parent = DropFrame})

                local function close()
                    open = false
                    DropFrame.Visible = false
                    DropBtn.Text = tostring(current) .. "  ▼"
                end

                for _, v in ipairs(values) do
                    local Opt = create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 26),
                        BackgroundColor3 = Theme.Surface,
                        Text = tostring(v),
                        TextColor3 = Theme.Dim,
                        TextSize = 12,
                        Font = Enum.Font.GothamBold,
                        BorderSizePixel = 0,
                        AutoButtonColor = false,
                        ZIndex = 31,
                        Parent = DropFrame,
                    })
                    Opt.MouseEnter:Connect(function()
                        tween(Opt, {BackgroundColor3 = Theme.Purple, TextColor3 = Theme.White})
                    end)
                    Opt.MouseLeave:Connect(function()
                        tween(Opt, {BackgroundColor3 = Theme.Surface, TextColor3 = Theme.Dim})
                    end)
                    Opt.MouseButton1Click:Connect(function()
                        current = v
                        Library.Flags[flag] = v
                        close()
                        if opts.Callback then task.spawn(opts.Callback, current) end
                    end)
                end

                DropBtn.MouseButton1Click:Connect(function()
                    open = not open
                    DropFrame.Visible = open
                    DropFrame.Size = UDim2.new(0.52, -8, 0, #values * 28)
                    DropBtn.Text = tostring(current) .. (open and "  ▲" or "  ▼")
                end)

                local Dropdown = {
                    Value = current,
                    Set = function(v)
                        current = v
                        Library.Flags[flag] = v
                        DropBtn.Text = tostring(v) .. "  ▼"
                    end,
                    Get = function() return current end,
                }
                Library.Options[flag] = Dropdown
                return Dropdown
            end

            table.insert(Tab.Groups, Group)
            return Group
        end

        return Tab
    end

    function Win:AddSettingsTab()
        local SettingsTab = self:AddTab("Settings")
        function SettingsTab:AddGroup(title)
            return self:AddGroup(title)
        end

        local Config = SettingsTab:AddGroup("Config")
        Config:AddButton("Unload", function()
            Library:Unload()
        end)

        local Info = SettingsTab:AddGroup("Info")
        Info:AddLabel("RightShift to toggle menu")

        return SettingsTab
    end

    Win.Frame = Window
    return Win
end

function Library:Unload()
    if Library.Unloaded then return end
    Library.Unloaded = true
    for _, c in ipairs(Library.Connections) do
        pcall(function() c:Disconnect() end)
    end
    if Library.ScreenGui then
        Library.ScreenGui:Destroy()
    end
end

return Library