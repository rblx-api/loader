--[[
    dark hub ui
    usage:

    local Hub = loadstring(game:HttpGet("YOUR_RAW"))()

    local Window = Hub:CreateWindow({
        Title = "private",
        Size = UDim2.new(0, 520, 0, 380),
        ToggleKey = Enum.KeyCode.LeftControl
    })

    local Tab = Window:AddTab("Main")
    local Group = Tab:AddGroup("Player")

    Group:AddToggle("Fly", {
        Text = "Fly",
        Default = false,
        Callback = function(v) print(v) end
    })

    Group:AddSlider("Speed", {
        Text = "Speed",
        Min = 16,
        Max = 200,
        Default = 16,
        Callback = function(v) print(v) end
    })

    Group:AddButton("Kill", function() print("yuh") end)
    Group:AddLabel("info text")

    Group:AddDropdown("Mode", {
        Text = "Mode",
        Values = {"A", "B", "C"},
        Default = "A",
        Callback = function(v) print(v) end
    })

    local Settings = Window:AddSettingsTab()
    local SGroup = Settings:AddGroup("Config")
    SGroup:AddToggle("Save", {Text = "Auto Save", Default = true})
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Library = {
    Toggles = {},
    Options = {},
    Flags = {},
    Connections = {},
    Unloaded = false,
}

local Theme = {
    Background  = Color3.fromRGB(12, 12, 18),
    Surface     = Color3.fromRGB(22, 22, 30),
    SurfaceAlt  = Color3.fromRGB(28, 28, 38),
    Accent      = Color3.fromRGB(99, 102, 241),
    AccentHover = Color3.fromRGB(120, 123, 255),
    Text        = Color3.fromRGB(240, 240, 250),
    TextDim     = Color3.fromRGB(160, 160, 185),
    TextMuted   = Color3.fromRGB(110, 110, 130),
    Border      = Color3.fromRGB(40, 40, 55),
    Success     = Color3.fromRGB(100, 220, 140),
    Danger      = Color3.fromRGB(248, 113, 113),
}

local function tween(obj, props, time, style)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.18, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
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
    return create("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = parent})
end

local function stroke(parent, color, thickness, trans)
    return create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = trans or 0.5,
        Parent = parent
    })
end

local function give(conn)
    table.insert(Library.Connections, conn)
    return conn
end

function Library:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "hub"
    local size = cfg.Size or UDim2.new(0, 520, 0, 380)
    local toggleKey = cfg.ToggleKey or Enum.KeyCode.LeftControl

    local ScreenGui = create("ScreenGui", {
        Name = "HubUI_" .. math.random(10000, 99999),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    protect(ScreenGui)
    Library.ScreenGui = ScreenGui

    local Main = create("Frame", {
        Name = "Main",
        Size = size,
        Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Active = true,
        Parent = ScreenGui,
    })
    corner(Main, 12)
    stroke(Main, Theme.Border, 1, 0.35)

    local TitleBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = Main,
    })
    corner(TitleBar, 12)
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = TitleBar,
    })

    local TitleLabel = create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar,
    })

    local CloseBtn = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -38, 0.5, -15),
        BackgroundColor3 = Theme.SurfaceAlt,
        Text = "×",
        TextColor3 = Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Parent = TitleBar,
    })
    corner(CloseBtn, 7)

    CloseBtn.MouseEnter:Connect(function()
        tween(CloseBtn, {BackgroundColor3 = Theme.Danger})
    end)
    CloseBtn.MouseLeave:Connect(function()
        tween(CloseBtn, {BackgroundColor3 = Theme.SurfaceAlt})
    end)

    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
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
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))

    local TabList = create("ScrollingFrame", {
        Size = UDim2.new(0, 130, 1, -54),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = Main,
    })
    local TabLayout = create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabList,
    })
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 8)
    end)

    local Content = create("Frame", {
        Size = UDim2.new(1, -152, 1, -58),
        Position = UDim2.new(0, 144, 0, 50),
        BackgroundTransparency = 1,
        Parent = Main,
    })

    local Window = {
        Main = Main,
        ScreenGui = ScreenGui,
        Tabs = {},
        ActiveTab = nil,
        Visible = true,
    }

    function Window:Toggle(vis)
        if vis == nil then vis = not self.Visible end
        self.Visible = vis
        Main.Visible = vis
    end

    CloseBtn.MouseButton1Click:Connect(function()
        Window:Toggle(false)
    end)

    give(UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            Window:Toggle()
        end
    end))

    function Window:AddTab(name)
        local TabBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Theme.Surface,
            Text = name,
            TextColor3 = Theme.TextDim,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Parent = TabList,
        })
        corner(TabBtn, 7)

        local Page = create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = Content,
        })
        local PageLayout = create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Page,
        })
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 16)
        end)

        local Tab = {
            Name = name,
            Button = TabBtn,
            Page = Page,
            Groups = {},
        }

        local function select()
            for _, t in ipairs(Window.Tabs) do
                t.Page.Visible = false
                tween(t.Button, {BackgroundColor3 = Theme.Surface, TextColor3 = Theme.TextDim})
            end
            Page.Visible = true
            tween(TabBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text})
            Window.ActiveTab = Tab
        end

        TabBtn.MouseButton1Click:Connect(select)
        TabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                tween(TabBtn, {BackgroundColor3 = Theme.SurfaceAlt})
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                tween(TabBtn, {BackgroundColor3 = Theme.Surface})
            end
        end)

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then select() end

        function Tab:AddGroup(title)
            local Card = create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = Page,
            })
            corner(Card, 9)
            stroke(Card, Theme.Border, 1, 0.55)

            local Header = create("TextLabel", {
                Size = UDim2.new(1, -16, 0, 28),
                Position = UDim2.new(0, 12, 0, 4),
                BackgroundTransparency = 1,
                Text = title or "Group",
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Card,
            })

            local Body = create("Frame", {
                Size = UDim2.new(1, -16, 0, 0),
                Position = UDim2.new(0, 8, 0, 32),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = Card,
            })
            local BodyLayout = create("UIListLayout", {
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Body,
            })
            create("UIPadding", {
                PaddingBottom = UDim.new(0, 10),
                Parent = Body,
            })

            local Group = {
                Card = Card,
                Body = Body,
                Elements = {},
            }

            function Group:AddLabel(text)
                local L = create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = text or "",
                    TextColor3 = Theme.TextMuted,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Parent = Body,
                })
                return L
            end

            function Group:AddButton(text, callback)
                if type(text) == "table" then
                    callback = text.Callback or text.Func
                    text = text.Text
                end
                local Btn = create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Theme.SurfaceAlt,
                    Text = text or "Button",
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Parent = Body,
                })
                corner(Btn, 7)

                Btn.MouseEnter:Connect(function()
                    tween(Btn, {BackgroundColor3 = Theme.Accent})
                end)
                Btn.MouseLeave:Connect(function()
                    tween(Btn, {BackgroundColor3 = Theme.SurfaceAlt})
                end)
                Btn.MouseButton1Click:Connect(function()
                    if callback then
                        task.spawn(callback)
                    end
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
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Theme.SurfaceAlt,
                    BorderSizePixel = 0,
                    Parent = Body,
                })
                corner(Holder, 7)

                local Label = create("TextLabel", {
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1,
                    Text = opts.Text or flag,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Holder,
                })

                local Switch = create("Frame", {
                    Size = UDim2.new(0, 34, 0, 18),
                    Position = UDim2.new(1, -42, 0.5, -9),
                    BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 65),
                    BorderSizePixel = 0,
                    Parent = Holder,
                })
                corner(Switch, 9)

                local Knob = create("Frame", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                    BackgroundColor3 = Theme.Text,
                    BorderSizePixel = 0,
                    Parent = Switch,
                })
                corner(Knob, 7)

                local function set(v)
                    state = v
                    Library.Flags[flag] = v
                    tween(Switch, {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 65)})
                    tween(Knob, {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
                    if opts.Callback then
                        task.spawn(opts.Callback, state)
                    end
                end

                Holder.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        set(not state)
                    end
                end)

                local Toggle = {
                    Value = state,
                    Set = set,
                    Get = function() return state end,
                }
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
                    Size = UDim2.new(1, 0, 0, 46),
                    BackgroundColor3 = Theme.SurfaceAlt,
                    BorderSizePixel = 0,
                    Parent = Body,
                })
                corner(Holder, 7)

                local Label = create("TextLabel", {
                    Size = UDim2.new(1, -60, 0, 18),
                    Position = UDim2.new(0, 12, 0, 6),
                    BackgroundTransparency = 1,
                    Text = opts.Text or flag,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Holder,
                })

                local ValueLabel = create("TextLabel", {
                    Size = UDim2.new(0, 50, 0, 18),
                    Position = UDim2.new(1, -58, 0, 6),
                    BackgroundTransparency = 1,
                    Text = tostring(value),
                    TextColor3 = Theme.Accent,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = Holder,
                })

                local BarBG = create("Frame", {
                    Size = UDim2.new(1, -24, 0, 5),
                    Position = UDim2.new(0, 12, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(40, 40, 55),
                    BorderSizePixel = 0,
                    Parent = Holder,
                })
                corner(BarBG, 3)

                local Fill = create("Frame", {
                    Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0,
                    Parent = BarBG,
                })
                corner(Fill, 3)

                local sliding = false
                local function update(input)
                    local rel = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * rel + 0.5)
                    Library.Flags[flag] = value
                    Fill.Size = UDim2.new(rel, 0, 1, 0)
                    ValueLabel.Text = tostring(value)
                    if opts.Callback then
                        task.spawn(opts.Callback, value)
                    end
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
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Theme.SurfaceAlt,
                    BorderSizePixel = 0,
                    Parent = Body,
                })
                corner(Holder, 7)

                local Label = create("TextLabel", {
                    Size = UDim2.new(0.45, 0, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1,
                    Text = opts.Text or flag,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Holder,
                })

                local DropBtn = create("TextButton", {
                    Size = UDim2.new(0.5, -8, 0, 22),
                    Position = UDim2.new(0.5, 0, 0.5, -11),
                    BackgroundColor3 = Theme.Surface,
                    Text = tostring(current) .. " ▼",
                    TextColor3 = Theme.TextDim,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Parent = Holder,
                })
                corner(DropBtn, 6)

                local open = false
                local DropFrame = create("Frame", {
                    Size = UDim2.new(0.5, -8, 0, 0),
                    Position = UDim2.new(0.5, 0, 1, 4),
                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel = 0,
                    Visible = false,
                    ZIndex = 20,
                    Parent = Holder,
                })
                corner(DropFrame, 7)
                stroke(DropFrame, Theme.Border, 1, 0.4)
                local DropLayout = create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    Parent = DropFrame,
                })

                local function close()
                    open = false
                    DropFrame.Visible = false
                    DropBtn.Text = tostring(current) .. " ▼"
                end

                for _, v in ipairs(values) do
                    local Opt = create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 24),
                        BackgroundColor3 = Theme.Surface,
                        Text = tostring(v),
                        TextColor3 = Theme.TextDim,
                        TextSize = 12,
                        Font = Enum.Font.GothamBold,
                        BorderSizePixel = 0,
                        AutoButtonColor = false,
                        ZIndex = 21,
                        Parent = DropFrame,
                    })
                    Opt.MouseEnter:Connect(function()
                        tween(Opt, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text})
                    end)
                    Opt.MouseLeave:Connect(function()
                        tween(Opt, {BackgroundColor3 = Theme.Surface, TextColor3 = Theme.TextDim})
                    end)
                    Opt.MouseButton1Click:Connect(function()
                        current = v
                        Library.Flags[flag] = v
                        close()
                        if opts.Callback then
                            task.spawn(opts.Callback, current)
                        end
                    end)
                end

                DropBtn.MouseButton1Click:Connect(function()
                    open = not open
                    DropFrame.Visible = open
                    DropFrame.Size = UDim2.new(0.5, -8, 0, #values * 26)
                    DropBtn.Text = tostring(current) .. (open and " ▲" or " ▼")
                end)

                local Dropdown = {
                    Value = current,
                    Set = function(v)
                        current = v
                        Library.Flags[flag] = v
                        DropBtn.Text = tostring(v) .. " ▼"
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

    function Window:AddSettingsTab()
        local SettingsTab = self:AddTab("Settings")

        function SettingsTab:AddGroup(title)
            return self:AddGroup(title)
        end

        local Appearance = SettingsTab:AddGroup("Appearance")
        Appearance:AddLabel("theme controls coming soon")

        local Keybinds = SettingsTab:AddGroup("Keybinds")
        Keybinds:AddLabel("menu key: " .. (toggleKey and toggleKey.Name or "LeftControl"))

        local Config = SettingsTab:AddGroup("Config")
        Config:AddButton("Unload", function()
            Library:Unload()
        end)

        return SettingsTab
    end

    Window.Frame = Main
    return Window
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

function Library:Notify(opts)
    opts = opts or {}
    print("[hub]", opts.Title or "", opts.Description or "")
end

return Library