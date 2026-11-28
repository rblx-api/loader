local cloneref        = cloneref or function(x) return x end
local getgenv         = getgenv or function() return _G end
local getconnections  = getconnections
local gethui          = gethui

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = cloneref(game:GetService("TweenService"))
local UserInputService  = cloneref(game:GetService("UserInputService"))
local LocalPlayer       = Players.LocalPlayer

local print, next, pcall, tostring, type, pairs, ipairs
    = print, next, pcall, tostring, type, pairs, ipairs
local table_remove  = table.remove
local table_concat  = table.concat
local table_pack    = table.pack or function(...)
    return { n = select("#", ...), ... }
end
local table_unpack  = table.unpack
local string_sub    = string.sub
local string_gsub   = string.gsub
local string_format = string.format
local math_floor    = math.floor
local math_random   = math.random
local math_min      = math.min
local os_clock      = os.clock
local os_date       = os.date
local tick          = tick
local task_wait     = (task and task.wait) or wait
local task_spawn    = (task and task.spawn) or spawn
local task_delay    = (task and task.delay) or function(t, f)
    task_spawn(function() task_wait(t) f() end)
end

local Config = {
    Enabled        = false,
    AutoTypeCodes  = false,
    AutoSubmit     = false,
    AIRiddles      = false,
    AIAutoSubmit   = false,
    SubmitAfter    = 1,
    MinFragment    = 1,
    MaxFragWords   = 60,
    ForceOpenCodes = true,

    Debug          = true,
    DebugToConsole = true,

    SavedPos = {
        XScale  = 1,
        XOffset = -16,
        YScale  = 0,
        YOffset = 20,
    },
}

local SAVE_FILE = "AuroraRedeemer.cfg"

local function saveConfig()
    if type(writefile) ~= "function" then return end
    local lines = {
        "Enabled="      .. tostring(Config.Enabled),
        "AutoTypeCodes=".. tostring(Config.AutoTypeCodes),
        "AutoSubmit="   .. tostring(Config.AutoSubmit),
        "AIRiddles="    .. tostring(Config.AIRiddles),
        "AIAutoSubmit=" .. tostring(Config.AIAutoSubmit),
        "SubmitAfter="  .. tostring(Config.SubmitAfter),
        "PosXScale="    .. tostring(Config.SavedPos.XScale),
        "PosXOffset="   .. tostring(Config.SavedPos.XOffset),
        "PosYScale="    .. tostring(Config.SavedPos.YScale),
        "PosYOffset="   .. tostring(Config.SavedPos.YOffset),
    }
    pcall(writefile, SAVE_FILE, table_concat(lines, "\n"))
end

local function loadConfig()
    if type(readfile) == "function" then
        local ok, contents = pcall(readfile, SAVE_FILE)
        if ok and type(contents) == "string" and contents ~= "" then
            for line in contents:gmatch("[^\r\n]+") do
                local key, val = line:match("^([%w_]+)=(.*)$")
                if key then
                    if key == "Enabled" then
                        Config.Enabled = (val == "true")
                    elseif key == "AutoTypeCodes" then
                        Config.AutoTypeCodes = (val == "true")
                    elseif key == "AutoSubmit" then
                        Config.AutoSubmit = (val == "true")
                    elseif key == "AIRiddles" then
                        Config.AIRiddles = (val == "true")
                    elseif key == "AIAutoSubmit" then
                        Config.AIAutoSubmit = (val == "true")
                    elseif key == "SubmitAfter" then
                        Config.SubmitAfter = math.clamp(tonumber(val) or 1, 1, 10)
                    elseif key == "PosXScale" then
                        Config.SavedPos.XScale = tonumber(val) or 1
                    elseif key == "PosXOffset" then
                        Config.SavedPos.XOffset = tonumber(val) or -16
                    elseif key == "PosYScale" then
                        Config.SavedPos.YScale = tonumber(val) or 0
                    elseif key == "PosYOffset" then
                        Config.SavedPos.YOffset = tonumber(val) or 20
                    end
                end
            end
            return
        end
    end
    saveConfig()
end

loadConfig()

local State = {
    typedCount   = 0,
    buffer       = {},
    solvedCount  = 0,
    lastSeen     = nil,
    lastSeenAt   = 0,
    unloaded     = false,
    connections  = {},
    minimized    = false,
}

print("Remake By CRYONHUSH ezz deobf")
getgenv().__aurora_fixed = "aurora-fixed-2026"

local Debug = (function()
    local function stamp()
        return os_date("%H:%M:%S")
    end
    local function push(level, msg)
        if not Config.Debug then return end
        local line = string_format("[%s] %s %s", stamp(), level, msg)
        if Config.DebugToConsole then print(line) end
    end
    local api = {}
    api.log   = function(msg) push("INFO ", tostring(msg)) end
    api.warn  = function(msg) push("WARN ", tostring(msg)) end
    api.error = function(msg) push("ERROR", tostring(msg)) end
    return api
end)()

local function try(label, fn, ...)
    local results = table_pack(xpcall(function(...)
        return fn(...)
    end, function(e)
        return tostring(e) .. "\n" .. debug.traceback("", 2)
    end, ...))

    local ok = results[1]
    if not ok then
        Debug.error(label .. " failed: " .. tostring(results[2]))
        return nil, results[2]
    end
    if results.n == 1 then return true end
    if results.n == 2 then return results[2] end
    return table_unpack(results, 2, results.n)
end

local IGNORE_EXPIRED = {
    "expired", "doesn't exist", "does not exist",
    "wrong", "incorrect", "no longer", "invalid",
}
local IGNORE_REDEEMED = { "redeemed", "claimed", "already" }

local function containsAny(s, list)
    for _, w in ipairs(list) do
        if s:find(w, 1, true) then return true end
    end
    return false
end

local function cleanText(s)
    return (s:gsub("@@%u+@@%d+@@", ""):gsub("@@[%w]+@@", ""):gsub("@@", ""))
end

local FRAGMENT_BLACKLIST = {
    ["top"] = true,
}

local function isBlacklisted(tok)
    return FRAGMENT_BLACKLIST[tok:lower()] == true
end

local function extractFragment(raw)
    if type(raw) ~= "string" then return nil end

    local cleaned = raw:gsub("<[^>]->", " ")
    cleaned = cleaned:gsub("%s+", " ")
    cleaned = cleaned:gsub("^%s*(.-)%s*$", "%1")
    if cleaned == "" then return nil end

    for tok in cleaned:gmatch("%S+") do
        local bare = tok:gsub("[%p]+$", ""):gsub("^[%p]+", "")
        if bare ~= "" and bare:match("^[%w]+$") and not isBlacklisted(bare) then
            return bare
        end
    end
    return nil
end

local function isOwnUI(inst)
    local node = inst
    for _ = 1, 10 do
        if not node then break end
        if node.Name == "AuroraRedeemer" then return true end
        node = node.Parent
    end
    return false
end

local function isVisibleChain(inst)
    local node = inst
    while node do
        if node:IsA("GuiObject") and not node.Visible then return false end
        if node:IsA("ScreenGui") then return node.Enabled end
        node = node.Parent
    end
    return true
end

local function forceOpenCodes()
    if not Config.ForceOpenCodes then return end
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return end

    local codes = pg:FindFirstChild("Codes")
    if not codes then return end

    if codes:IsA("ScreenGui") then
        pcall(function() codes.Enabled = true end)
    end

    local codes2 = codes:FindFirstChild("Codes") or codes
    if codes2:IsA("GuiObject") then
        pcall(function() codes2.Visible = true end)
    end

    local node = codes2
    while node and node ~= codes do
        if node:IsA("GuiObject") then
            pcall(function() node.Visible = true end)
        end
        node = node.Parent
    end

    node = codes.Parent
    while node do
        if node:IsA("GuiObject") then
            pcall(function() node.Visible = true end)
        end
        if node:IsA("ScreenGui") then
            pcall(function() node.Enabled = true end)
        end
        node = node.Parent
    end
end

local function findCodeBox()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then
        Debug.warn("no PlayerGui")
        return nil
    end

    pcall(forceOpenCodes)

    local codes = pg:FindFirstChild("Codes")
    if codes then
        if codes:IsA("ScreenGui") then
            pcall(function() codes.Enabled = true end)
        end

        local codes2 = codes:FindFirstChild("Codes") or codes
        if codes2:IsA("GuiObject") then
            pcall(function() codes2.Visible = true end)
        end

        local parent = codes2
        while parent and parent ~= codes do
            if parent:IsA("GuiObject") then
                pcall(function() parent.Visible = true end)
            end
            parent = parent.Parent
        end
        for _, descendant in ipairs(codes2:GetDescendants()) do
            if descendant:IsA("TextBox") and not isOwnUI(descendant) then
                Debug.log("CodeBox (Codes subtree): " .. descendant:GetFullName())
                return descendant
            end
        end
        Debug.warn("Codes subtree present but no TextBox - falling through")
    else
        Debug.log("Codes subtree not found - dynamic scan")
    end

    local deadline = tick() + 2

    while tick() < deadline do
        local candidates = {}
        for _, child in ipairs(pg:GetChildren()) do
            if child:IsA("ScreenGui") and child.Enabled and not isOwnUI(child) then
                for _, d in ipairs(child:GetDescendants()) do
                    if d:IsA("TextBox") and not isOwnUI(d) then
                        candidates[#candidates + 1] = d
                    end
                end
            end
        end

        for _, tb in ipairs(candidates) do
            if isVisibleChain(tb) then
                local n = tb.Name:lower()
                local p = (tb.Parent and tb.Parent.Name or ""):lower()
                if n:find("code") or p:find("code")
                   or n:find("redeem") or p:find("redeem")
                   or n:find("input") or p:find("textbox")
                   or n:find("enter") then
                    Debug.log("CodeBox (dynamic preferred): " .. tb:GetFullName())
                    return tb
                end
            end
        end

        for _, tb in ipairs(candidates) do
            if isVisibleChain(tb) then
                Debug.log("CodeBox (dynamic fallback): " .. tb:GetFullName())
                return tb
            end
        end

        pcall(forceOpenCodes)
        task_wait(0.1)
    end

    Debug.warn("no codebox visible after 2s poll")
    return nil
end

local SUBMIT_VERBS = {
    "submit", "redeem", "claim", "confirm", "enter",
    "send", "apply", "ok", "use", "go", "check", "go!", "play",
}

local function matchesVerb(str)
    for _, v in ipairs(SUBMIT_VERBS) do
        if str:find(v, 1, true) then return true end
    end
    return false
end

local function findConfirmButton(box)
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return nil end

    local codes = pg:FindFirstChild("Codes")
    if codes then
        local codes2 = codes:FindFirstChild("Codes") or codes
        for _, descendant in ipairs(codes2:GetDescendants()) do
            if (descendant:IsA("TextButton") or descendant:IsA("ImageButton"))
               and not isOwnUI(descendant) then
                local n = descendant.Name:lower()
                local t = ""
                pcall(function() t = tostring(descendant.Text or ""):lower() end)
                if matchesVerb(n) or matchesVerb(t) then
                    return descendant
                end
            end
        end

        for _, descendant in ipairs(codes2:GetDescendants()) do
            if (descendant:IsA("TextButton") or descendant:IsA("ImageButton"))
               and not isOwnUI(descendant) then
                local n = descendant.Name:lower()
                if not n:find("close") and not n:find("toggle") and n ~= "x" then
                    return descendant
                end
            end
        end
    end

    if box then
        local parent = box.Parent
        for _ = 1, 8 do
            if not parent then break end
            for _, d in ipairs(parent:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton"))
                   and d ~= box and not isOwnUI(d) then
                    local n = d.Name:lower()
                    local t = ""
                    pcall(function() t = tostring(d.Text or ""):lower() end)
                    if matchesVerb(n) or matchesVerb(t) then return d end
                end
            end
            parent = parent.Parent
        end
    end

    return nil
end

local function fireButton(btn)
    if not btn then return false end

    local attempts = {
        function() btn.MouseButton1Click:Fire() end,
        function() btn.Activated:Fire() end,
    }

    if type(firesignal) == "function" then
        attempts[#attempts + 1] = function() firesignal(btn.MouseButton1Click) end
        attempts[#attempts + 1] = function() firesignal(btn.Activated) end
    end

    if type(getconnections) == "function" then
        attempts[#attempts + 1] = function()
            local ok, conns = pcall(getconnections, btn.MouseButton1Click)
            if ok and type(conns) == "table" then
                for _, c in ipairs(conns) do
                    pcall(function() c:Fire() end)
                end
            end
            local ok2, conns2 = pcall(getconnections, btn.Activated)
            if ok2 and type(conns2) == "table" then
                for _, c in ipairs(conns2) do
                    pcall(function() c:Fire() end)
                end
            end
        end
    end

    if type(fireclick) == "function" then
        attempts[#attempts + 1] = function() fireclick(btn) end
    end

    local fired = false
    for _, fn in ipairs(attempts) do
        local ok = pcall(fn)
        fired = fired or ok
    end
    return fired
end

local function fireFocusLost(box)
    if not box then return false end
    local fired = false

    if type(firesignal) == "function" then
        fired = pcall(firesignal, box.FocusLost, true) or fired
    end

    if type(getconnections) == "function" then
        local ok, conns = pcall(getconnections, box.FocusLost)
        if ok and type(conns) == "table" then
            for _, c in ipairs(conns) do
                local fn = nil
                pcall(function() fn = c.Function end)

                if fn
                   and type(getupvalues) == "function"
                   and type(setupvalue) == "function" then
                    local ok2, ups = pcall(getupvalues, fn)
                    if ok2 and type(ups) == "table" then
                        for k, v in pairs(ups) do
                            if type(v) == "boolean" and v == true then
                                pcall(setupvalue, fn, k, false)
                            end
                        end
                    end
                end

                local ok3 = pcall(function()
                    if c.Enabled ~= false then
                        c:Fire(true)
                    end
                end)
                fired = fired or ok3
            end
        end
    end

    return fired
end

local function submitCode(text)
    if type(text) ~= "string" or text == "" then
        return false, "empty text"
    end

    local box = findCodeBox()
    if not box then
        task_wait(0.25)
        pcall(forceOpenCodes)
        box = findCodeBox()
    end
    if not box then
        return false, "no codebox visible"
    end

    pcall(function() box:CaptureFocus() end)
    task_wait(0.02)

    pcall(function() box.Text = "" end)
    task_wait(0.02)
    local okSet = pcall(function() box.Text = text end)
    if not okSet then
        return false, "text set failed"
    end
    task_wait(0.05)

    local btn = findConfirmButton(box)
    if btn then
        fireButton(btn)
    end

    fireFocusLost(box)

    Debug.log("Typed + submitted: " .. text)
    return true, "submitted"
end

local function getHandlerSource(fn)
    if type(fn) ~= "function" then return nil end
    if type(debug) == "table" and type(debug.info) == "function" then
        local ok, src = pcall(debug.info, fn, "s")
        if ok and type(src) == "string" and #src > 0 then return src end
    end
    if type(debug) == "table" and type(debug.getinfo) == "function" then
        local ok, info = pcall(debug.getinfo, fn)
        if ok and type(info) == "table" then
            if type(info.short_src) == "string" and #info.short_src > 0 then
                return info.short_src
            end
            if type(info.source) == "string" and #info.source > 0 then
                return info.source
            end
        end
    end
    return nil
end

local function findNotificationRemote()
    if _G.PhiNotifyRemote then return _G.PhiNotifyRemote end

    if type(getconnections) ~= "function" then
        Debug.warn("getconnections unavailable")
        return nil
    end
    if type(debug) ~= "table"
       or (type(debug.getinfo) ~= "function" and type(debug.info) ~= "function") then
        Debug.warn("debug.getinfo unavailable")
        return nil
    end

    local netFolder
    local ok = pcall(function()
        local packages = ReplicatedStorage:FindFirstChild("Packages")
        if not packages then return end
        netFolder = packages:FindFirstChild("Net")
    end)
    if not ok or not netFolder then
        Debug.warn("Packages.Net not found")
        return nil
    end

    local descendants = netFolder:GetDescendants()
    Debug.log(string_format("Scanning %d descendants", #descendants))

    local scanned = 0
    for _, inst in ipairs(descendants) do
        local isRemote = false
        pcall(function() isRemote = inst:IsA("RemoteEvent") end)
        if isRemote then
            scanned = scanned + 1
            local conns
            local ok2 = pcall(function() conns = getconnections(inst.OnClientEvent) end)
            if ok2 and type(conns) == "table" then
                for _, c in ipairs(conns) do
                    local fn
                    pcall(function() fn = c.Function end)
                    if type(fn) == "function" then
                        local src = getHandlerSource(fn)
                        if type(src) == "string"
                           and src:find("NotificationController", 1, true) then
                            Debug.log("Matched: " .. inst:GetFullName())
                            _G.PhiNotifyRemote = inst
                            return inst
                        end
                    end
                end
            end
        end
    end

    Debug.warn(string_format("No match (scanned %d remotes)", scanned))
    return nil
end

local COLORS = {
    shell = Color3.fromRGB(15, 15, 18),
    surf  = Color3.fromRGB(24, 24, 28),
    sunk  = Color3.fromRGB(18, 18, 22),
    line  = Color3.fromRGB(45, 45, 50),
    hi    = Color3.fromRGB(255, 255, 255),
    md    = Color3.fromRGB(200, 200, 200),
    lo    = Color3.fromRGB(100, 100, 100),
    aur   = Color3.fromRGB(255, 120, 0),
    vio   = Color3.fromRGB(255, 80, 0),
    off   = Color3.fromRGB(90, 90, 90),
    good  = Color3.fromRGB(255, 150, 50),
    bad   = Color3.fromRGB(255, 80, 80),
}

local GLYPH = { dash = "—", minus = "−", cross = "×", tick = "✓" }

local UI = {}
local uiConnections = {}

local function trackConn(conn)
    uiConnections[#uiConnections + 1] = conn
    return conn
end

local function new(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

local function corner(inst, radius)
    new("UICorner", { CornerRadius = UDim.new(0, radius) }, inst)
    return inst
end

local function circle(inst)
    new("UICorner", { CornerRadius = UDim.new(1, 0) }, inst)
    return inst
end

local function stroke(inst, color, transparency)
    new("UIStroke", {
        Color = color,
        Thickness = 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, inst)
    return inst
end

local function tween(inst, time, props)
    TweenService:Create(inst,
        TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props):Play()
end

local function hover(button, label, idle, active)
    trackConn(button.MouseEnter:Connect(function()
        tween(label, 0.12, { TextColor3 = active })
    end))
    trackConn(button.MouseLeave:Connect(function()
        tween(label, 0.18, { TextColor3 = idle })
    end))
end

local function chevron(parent, color)
    local holder = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(16, 12),
        BackgroundTransparency = 1,
    }, parent)
    for i = 1, 2 do
        circle(new("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(i == 1 and 6 or 10, 5),
            Size = UDim2.fromOffset(7, 2),
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            Rotation = i == 1 and 45 or -45,
        }, holder))
    end
    return holder
end

local function buildUI(parent)
    Debug.log("buildUI start")

    local root = new("ScreenGui", {
        Name = "AuroraRedeemer",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 9999,
    }, parent)
    pcall(function() if protectgui then protectgui(root) end end)

    local PAD, GAP = 8, 8
    local HEADER_H = 38

    local frame = new("Frame", {
        Size = UDim2.fromOffset(316, HEADER_H),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 332, 0, 20),
        BackgroundColor3 = COLORS.shell,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true,
    }, root)
    corner(frame, 12)
    stroke(frame, COLORS.line, 0.2)

    do
        local grad = new("Frame", {
            Size = UDim2.new(1, 0, 0, 6),
            BackgroundColor3 = COLORS.vio,
            BackgroundTransparency = 0.87,
            BorderSizePixel = 0,
            ZIndex = 0,
        }, frame)
        corner(grad, 12)
        new("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
        }, grad)
    end

    local accent = new("Frame", {
        Position = UDim2.fromOffset(0, 7),
        Size = UDim2.new(0, 2, 1, -14),
        BackgroundColor3 = COLORS.aur,
        BorderSizePixel = 0,
        ZIndex = 5,
    }, frame)
    circle(accent)
    new("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0.7),
        }),
    }, accent)

    local header = new("Frame", {
        Size = UDim2.new(1, 0, 0, HEADER_H),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        ZIndex = 3,
    }, frame)

    local brand = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, PAD + 2, 0.5, 0),
        Size = UDim2.fromOffset(200, 16),
        BackgroundTransparency = 1,
    }, header)
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
    }, brand)

    new("ImageLabel", {
        LayoutOrder = 1,
        Size = UDim2.fromOffset(14, 14),
        BackgroundTransparency = 1,
        Image = "rbxassetid://133811381398870",
        ImageColor3 = COLORS.aur,
        ScaleType = Enum.ScaleType.Fit,
    }, brand)

    new("TextLabel", {
        LayoutOrder = 2,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 14),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        TextSize = 12,
        TextColor3 = COLORS.hi,
        Text = "AURORA",
    }, brand)

    new("TextLabel", {
        LayoutOrder = 3,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 14),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = COLORS.lo,
        Text = "REDEEMER",
    }, brand)

    local toggleBtn = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -60, 0.5, 0),
        Size = UDim2.fromOffset(34, 18),
        BackgroundColor3 = COLORS.sunk,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
    }, header)
    circle(toggleBtn)
    stroke(toggleBtn, COLORS.line, 0.25)

    local toggleKnob = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 2, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = COLORS.lo,
        BorderSizePixel = 0,
    }, toggleBtn)
    circle(toggleKnob)

    local minBtn = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -34, 0.5, 0),
        Size = UDim2.fromOffset(20, 20),
        BackgroundColor3 = COLORS.surf,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
    }, header)
    corner(minBtn, 6)
    stroke(minBtn, COLORS.line, 0.45)

    local minLabel = new("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = COLORS.md,
        Text = "v",                      
    }, minBtn)
    hover(minBtn, minLabel, COLORS.md, COLORS.aur)

    local closeBtn = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(20, 20),
        BackgroundColor3 = COLORS.surf,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
    }, header)
    corner(closeBtn, 6)
    stroke(closeBtn, COLORS.line, 0.45)

    local closeLabel = new("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = COLORS.md,
        Text = GLYPH.cross,
    }, closeBtn)
    hover(closeBtn, closeLabel, COLORS.md, COLORS.bad)

    local body = new("Frame", {
        Position = UDim2.fromOffset(0, HEADER_H),
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, frame)
    new("UIPadding", {
        PaddingLeft = UDim.new(0, PAD + 2),
        PaddingRight = UDim.new(0, PAD),
        PaddingTop = UDim.new(0, 2),
    }, body)
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
    }, body)

    local rows = {}
    local renderNotif

    local function row(order, height, clips)
        local r = new("Frame", {
            LayoutOrder = order,
            Size = UDim2.new(1, 0, 0, height),
            BackgroundTransparency = 1,
            ClipsDescendants = clips and true or false,
        }, body)
        local entry = { frame = r, h = height }
        rows[#rows + 1] = entry
        return r, entry
    end

    local function bodyHeight()
        local total = 0
        for _, r in ipairs(rows) do total = total + r.h end
        return total + GAP * (#rows - 1) + 2 + PAD
    end

    local statusRow = row(1, 26)
    new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 12, 0.5, 0),
        Size = UDim2.fromOffset(8, 8),
        BackgroundColor3 = COLORS.aur,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, statusRow)
    local statusInner = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 12, 0.5, 0),
        Size = UDim2.fromOffset(7, 7),
        BackgroundColor3 = COLORS.aur,
        BorderSizePixel = 0,
        ZIndex = 2,
    }, statusRow)
    circle(statusInner)

    local statusLabel = new("TextLabel", {
        Position = UDim2.fromOffset(24, 0),
        Size = UDim2.new(1, -110, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = COLORS.aur,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "READY",
    }, statusRow)

    local statusPill = new("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 16),
        BackgroundColor3 = COLORS.surf,
        BorderSizePixel = 0,
        Font = Enum.Font.RobotoMono,
        TextSize = 10,
        TextColor3 = COLORS.md,
        Text = "",
        Visible = false,
    }, statusRow)
    corner(statusPill, 6)
    stroke(statusPill, COLORS.line, 0.55)

    local notifRow = row(2, 54)
    local notifCard = new("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = COLORS.sunk,
        BorderSizePixel = 0,
    }, notifRow)
    corner(notifCard, 8)
    stroke(notifCard, COLORS.line, 0.55)

    new("TextLabel", {
        Position = UDim2.fromOffset(10, 6),
        Size = UDim2.fromOffset(110, 12),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = COLORS.lo,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "NOTIFICATION",
    }, notifCard)

    local notifCounter = new("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -10, 0, 6),
        Size = UDim2.fromOffset(120, 12),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = COLORS.lo,
        TextXAlignment = Enum.TextXAlignment.Right,
        Text = "0/4",
    }, notifCard)

    local notifText = new("TextLabel", {
        Position = UDim2.fromOffset(10, 21),
        Size = UDim2.new(1, -20, 0, 26),
        BackgroundTransparency = 1,
        Font = Enum.Font.RobotoMono,
        TextSize = 12,
        TextColor3 = COLORS.lo,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = "waiting for code",
    }, notifCard)

    renderNotif = function()
        local n = #State.buffer
        if n == 0 then
            notifText.Text = "waiting for code"
            notifText.TextColor3 = COLORS.lo
            notifCounter.Text = "0/" .. tostring(Config.SubmitAfter)
            notifCounter.TextColor3 = COLORS.lo
        else
            notifText.Text = table_concat(State.buffer)
            notifText.TextColor3 = COLORS.aur
            notifCounter.Text = tostring(n) .. "/" .. tostring(Config.SubmitAfter)
            notifCounter.TextColor3 = COLORS.aur
        end
    end

    local statRow = row(3, 54)

    local function statTile(order, label)
        local tile = new("Frame", {
            Position = UDim2.new(order, order > 0 and 4 or 0, 0, 0),
            Size = UDim2.new(0.5, -6, 1, 0),
            BackgroundColor3 = COLORS.sunk,
            BorderSizePixel = 0,
        }, statRow)
        corner(tile, 6)
        stroke(tile, COLORS.line, 0.55)

        new("TextLabel", {
            Position = UDim2.fromOffset(10, 6),
            Size = UDim2.fromOffset(80, 12),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 9,
            TextColor3 = COLORS.lo,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = label,
        }, tile)

        local value = new("TextLabel", {
            Position = UDim2.fromOffset(10, 22),
            Size = UDim2.new(1, -20, 0, 22),
            BackgroundTransparency = 1,
            Font = Enum.Font.RobotoMono,
            TextSize = 15,
            TextColor3 = COLORS.hi,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = "0",
        }, tile)

        local sub = new("TextLabel", {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -10, 0, 6),
            Size = UDim2.fromOffset(60, 12),
            BackgroundTransparency = 1,
            Font = Enum.Font.RobotoMono,
            TextSize = 10,
            TextColor3 = COLORS.good,
            TextXAlignment = Enum.TextXAlignment.Right,
            Text = "",
        }, tile)

        return tile, value, sub
    end

    local tileSolved, tileSolvedVal = statTile(0, "SOLVED")
    local tileBuffer, tileBufferVal, tileBufferSub = statTile(0.5, "BUFFER")
    tileBufferSub.Text = "PARTS"

    local settingsRow, settingsEntry = row(5, 26, true)

    local settingsBtn = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundColor3 = COLORS.surf,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 5,
    }, settingsRow)
    corner(settingsBtn, 8)
    stroke(settingsBtn, COLORS.line, 0.55)

    local settingsLabel = new("TextLabel", {
        Position = UDim2.fromOffset(10, 0),
        Size = UDim2.new(1, -40, 0, 22),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = COLORS.md,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "SETTINGS",
    }, settingsBtn)

    local settingsChevron = chevron(settingsBtn, COLORS.md)
    settingsChevron.AnchorPoint = Vector2.new(0, 0.5)
    settingsChevron.Position = UDim2.new(1, -14, 0.5, 0)
    settingsChevron.Rotation = -90
    hover(settingsBtn, settingsLabel, COLORS.md, COLORS.hi)

    local settingsBody = new("Frame", {
        Position = UDim2.fromOffset(0, 26),
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 1,
    }, settingsRow)
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, settingsBody)

    local SETTINGS_ROW_H = 26
    local SETTINGS_ROWS = 5

    local function settingFrame(order, label)
        local r = new("Frame", {
            LayoutOrder = order,
            Size = UDim2.new(1, 0, 0, SETTINGS_ROW_H),
            BackgroundTransparency = 1,
        }, settingsBody)
        local lbl = new("TextLabel", {
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(1, -84, 1, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = COLORS.md,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = label,
        }, r)
        return r, lbl
    end

    local function addToggle(order, label, get, set)
        local r, lbl = settingFrame(order, label)
        local btn = new("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(30, 16),
            BackgroundColor3 = COLORS.sunk,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Text = "",
        }, r)
        circle(btn)
        stroke(btn, COLORS.line, 0.3)

        local knob = new("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 2, 0.5, 0),
            Size = UDim2.fromOffset(12, 12),
            BackgroundColor3 = COLORS.lo,
            BorderSizePixel = 0,
        }, btn)
        circle(knob)

        local function render()
            local on = get() and true or false
            if on then
                tween(knob, 0.14, { Position = UDim2.new(0, 14, 0.5, 0), BackgroundColor3 = COLORS.aur })
            else
                tween(knob, 0.14, { Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = COLORS.lo })
            end
            lbl.TextColor3 = on and COLORS.md or COLORS.lo
        end
        render()

        trackConn(btn.MouseButton1Click:Connect(function()
            set(not get())
            render()
            saveConfig()
        end))
        return render
    end

    local function addStepper(order, label, get, set, min, max)
        local r, lbl = settingFrame(order, label)

        local value = new("TextLabel", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -26, 0.5, 0),
            Size = UDim2.fromOffset(22, 18),
            BackgroundTransparency = 1,
            Font = Enum.Font.RobotoMono,
            TextSize = 11,
            TextColor3 = COLORS.hi,
            Text = tostring(get()),
        }, r)

        local function mkBtn(x, txt)
            local b = new("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, x, 0.5, 0),
                Size = UDim2.fromOffset(16, 18),
                BackgroundColor3 = COLORS.surf,
                BackgroundTransparency = 0.35,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = COLORS.md,
                Text = txt,
            }, r)
            corner(b, 5)
            stroke(b, COLORS.line, 0.5)
            return b
        end

        local minus = mkBtn(-52, GLYPH.minus)
        local plus  = mkBtn(0, "+")

        local function render()
            local v = tonumber(get()) or min
            value.Text = tostring(v)
            minus.TextColor3 = v > min and COLORS.md or COLORS.lo
            plus.TextColor3  = v < max and COLORS.md or COLORS.lo
            lbl.TextColor3 = COLORS.md
        end
        render()

        local function step(delta)
            set(math.clamp((tonumber(get()) or min) + delta, min, max))
            render()
            saveConfig()
        end

        trackConn(minus.MouseButton1Click:Connect(function() step(-1) end))
        trackConn(plus.MouseButton1Click:Connect(function() step(1) end))
        return render
    end

    addToggle(1, "AUTO TYPE CODES", function() return Config.AutoTypeCodes end,
        function(v) Config.AutoTypeCodes = v end)
    addToggle(2, "AUTO SUBMIT", function() return Config.AutoSubmit end,
        function(v) Config.AutoSubmit = v end)
    addToggle(3, "AUTO RIDDLES", function() return Config.AIRiddles end,
        function(v) Config.AIRiddles = v end)
    addToggle(4, "AI AUTO SUBMIT", function() return Config.AIAutoSubmit end,
        function(v) Config.AIAutoSubmit = v end)

    addStepper(5, "SUBMIT AFTER",
        function() return Config.SubmitAfter end,
        function(v)
            Config.SubmitAfter = v
            if #State.buffer > 0 then
                State.buffer = {}
            end
            renderNotif()
        end, 1, 10)

    settingsBody.Size = UDim2.new(1, 0, 0, SETTINGS_ROW_H * SETTINGS_ROWS)

    local footerRow = row(6, 26)

    local resetBtn = new("TextButton", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(62, 22),
        BackgroundColor3 = COLORS.surf,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = COLORS.md,
        Text = "RESET",
    }, footerRow)
    corner(resetBtn, 7)
    stroke(resetBtn, COLORS.line, 0.5)

    local footerStatus = new("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(200, 18),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 9,
        TextColor3 = COLORS.lo,
        TextXAlignment = Enum.TextXAlignment.Right,
        Text = "",
    }, footerRow)

    local settingsExpanded = false

    local function resize(animate)
        if State.minimized then return end
        local bodyH = bodyHeight()
        local total = HEADER_H + bodyH
        local frameSize = UDim2.fromOffset(316, total)
        local bodySize  = UDim2.new(1, 0, 0, bodyH)

        if animate then
            tween(frame, 0.24, { Size = frameSize })
            tween(body, 0.24, { Size = bodySize })
        else
            frame.Size = frameSize
            body.Size  = bodySize
        end

        for _, r in ipairs(rows) do
            if r.frame.Size.Y.Offset ~= r.h then
                local s = UDim2.new(1, 0, 0, r.h)
                if animate then tween(r.frame, 0.24, { Size = s })
                else r.frame.Size = s end
            end
        end
    end

    local function flash(inst, color)
        if not inst then return end
        if inst:IsA("UIStroke") then
            inst.Color = color
            inst.Transparency = 0.05
            tween(inst, 0.7, { Transparency = 0.55 })
            task_delay(1.2, function()
                if not State.unloaded then inst.Color = COLORS.line end
            end)
        elseif inst:IsA("Frame") then
            local original = inst.BackgroundColor3
            inst.BackgroundColor3 = color
            task_delay(0.7, function()
                if not State.unloaded then inst.BackgroundColor3 = original end
            end)
        end
    end

    local function renderStatus()
        local status, color

        if not Config.Enabled then
            status, color = "DISABLED", COLORS.off
        elseif #State.buffer > 0 then
            status, color = "COLLECTING", COLORS.aur
        elseif State.typedCount > 0 then
            status, color = "TYPING", COLORS.aur
        else
            status, color = "READY", COLORS.aur
        end

        statusLabel.Text = status
        tween(statusLabel, 0.25, { TextColor3 = color })
        tween(statusInner, 0.18, { BackgroundColor3 = color })

        if Config.Enabled then
            tween(toggleKnob, 0.14, {
                Position = UDim2.new(0, 14, 0.5, 0),
                BackgroundColor3 = COLORS.aur,
            })
        else
            tween(toggleKnob, 0.14, {
                Position = UDim2.new(0, 2, 0.5, 0),
                BackgroundColor3 = COLORS.lo,
            })
        end

        renderNotif()

        tileSolvedVal.Text = tostring(State.solvedCount)
        tileBufferVal.Text = tostring(#State.buffer)
        tileBufferSub.Text = Config.AutoSubmit and "AUTO" or "MANUAL"
    end

    local function renderFooter(text)
        footerStatus.Text = text or ""
    end

    trackConn(toggleBtn.MouseButton1Click:Connect(function()
        Config.Enabled = not Config.Enabled
        Debug.log("Master switch: " .. tostring(Config.Enabled))
        renderStatus()
        saveConfig()
    end))

    trackConn(minBtn.MouseButton1Click:Connect(function()
        State.minimized = not State.minimized
        if State.minimized then
            body.Visible = false
            minLabel.Text = ">"
            tween(frame, 0.24, { Size = UDim2.fromOffset(316, HEADER_H) })
        else
            body.Visible = true
            minLabel.Text = "v"
            resize(true)
        end
    end))

    trackConn(settingsBtn.MouseButton1Click:Connect(function()
        settingsExpanded = not settingsExpanded
        settingsEntry.h = settingsExpanded and (26 + SETTINGS_ROW_H * SETTINGS_ROWS) or 26
        tween(settingsChevron, 0.2, { Rotation = settingsExpanded and 0 or -90 })
        resize(true)
    end))

    trackConn(resetBtn.MouseButton1Click:Connect(function()
        State.typedCount  = 0
        State.buffer      = {}
        State.solvedCount = 0
        local box = findCodeBox()
        if box then box.Text = "" end
        renderNotif()
        Debug.log("Reset")
        renderStatus()
    end))

    trackConn(closeBtn.MouseButton1Click:Connect(function()
        if getgenv and getgenv().__auroraRedeemer then
            local api = getgenv().__auroraRedeemer
            if type(api.unload) == "function" then
                pcall(api.unload)
            end
        else
            root:Destroy()
        end
    end))

    local dragging, dragStart, frameStart = false, nil, nil
    trackConn(frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            frameStart = frame.Position
        end
    end))
    trackConn(UserInputService.InputChanged:Connect(function(input)
        if not dragging or not dragStart then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(
                frameStart.X.Scale, frameStart.X.Offset + d.X,
                frameStart.Y.Scale, frameStart.Y.Offset + d.Y)
        end
    end))
    trackConn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                Config.SavedPos.XScale  = frame.Position.X.Scale
                Config.SavedPos.XOffset = frame.Position.X.Offset
                Config.SavedPos.YScale  = frame.Position.Y.Scale
                Config.SavedPos.YOffset = frame.Position.Y.Offset
                saveConfig()
            end
            dragging = false
        end
    end))

    settingsEntry.h = 26
    resize(false)
    renderStatus()

    frame.Position = UDim2.new(1, 332, 0, 20)
    local targetPos = UDim2.new(
        Config.SavedPos.XScale, Config.SavedPos.XOffset,
        Config.SavedPos.YScale, Config.SavedPos.YOffset)
    task_delay(0.05, function()
        tween(frame, 0.28, { Position = targetPos })
    end)

    return {
        root = root,
        frame = frame,
        resize = resize,
        renderStatus = renderStatus,
        renderNotif = renderNotif,
        renderFooter = renderFooter,
        flash = flash,
        notifText = notifText,
        notifCounter = notifCounter,
        statusPill = statusPill,
        statusInner = statusInner,
        tileSolvedVal = tileSolvedVal,
        tileBufferVal = tileBufferVal,
        tileBufferSub = tileBufferSub,
    }
end

local function handleNotification(raw)
    Debug.log("Notification: " .. tostring(raw):sub(1, 200))

    if type(raw) ~= "string" then return end

    local text = cleanText(raw)
    if text:gsub("%s", "") == "" then return end

    local now = os_clock()
    if text == State.lastSeen and now - State.lastSeenAt < 0.35 then return end
    State.lastSeen, State.lastSeenAt = text, now

    local lower = text:gsub("<[^>]->", " "):lower()
    if containsAny(lower, IGNORE_EXPIRED) or containsAny(lower, IGNORE_REDEEMED) then
        Debug.log("Notification marked done/expired")
        if UI and UI.renderNotif then UI.renderNotif() end
        return
    end

    if not Config.Enabled or not Config.AutoTypeCodes then
        Debug.log("Disabled - not typing")
        return
    end

    local frag = extractFragment(text)
    if not frag then
        Debug.log("No usable fragment")
        return
    end

    State.buffer[#State.buffer + 1] = frag
    Debug.log(string_format("Buffered %s (%d/%d)", frag, #State.buffer, Config.SubmitAfter))
    if UI and UI.renderNotif then UI.renderNotif() end

    if #State.buffer < Config.SubmitAfter then
        return
    end

    local joined = table_concat(State.buffer)
    State.buffer = {}
    if UI and UI.renderNotif then UI.renderNotif() end
    if UI and UI.renderStatus then UI.renderStatus() end

    Debug.log("Submitting buffer: " .. joined)
    local ok, why = submitCode(joined)

    if ok then
        State.typedCount  = State.typedCount + 1
        State.solvedCount = State.solvedCount + 1
        if UI and UI.flash then UI.flash(UI.statusInner, COLORS.aur) end
        if UI and UI.renderFooter then UI.renderFooter("") end
    else
        Debug.warn("Submit failed: " .. tostring(why))
        if UI and UI.renderFooter then UI.renderFooter("SUBMIT FAILED") end
    end

    if UI and UI.renderStatus then UI.renderStatus() end
end

local NOTIFY_PHRASES = {
    "invalid code", "code is invalid", "expired",
    "already redeemed", "already used",
    "doesn't exist", "does not exist",
    "not found", "rejected", "code is",
    "use code",
}

local function watchTextObject(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton")) then return end
    if isOwnUI(inst) then return end

    local function check()
        local t = tostring(inst.Text or ""):lower()
        for _, phrase in ipairs(NOTIFY_PHRASES) do
            if t:find(phrase, 1, true) then
                pcall(handleNotification, inst.Text)
                return
            end
        end
    end

    trackConn(inst:GetPropertyChangedSignal("Text"):Connect(check))
end

local function main()
    Debug.log("REMAKE BY CRYONHUSH ON TOP")

    if not game:IsLoaded() then
        Debug.log("Waiting for game load...")
        game.Loaded:Wait()
    end

    local parent = (gethui and gethui()) or cloneref(game:GetService("CoreGui"))
    if not parent then
        Debug.error("No UI parent available")
        return
    end

    local ui = try("buildUI", buildUI, parent)
    if not ui then
        Debug.error("buildUI failed")
        return
    end
    UI = ui
    Debug.log("UI attached")

    local remote = try("findNotificationRemote", findNotificationRemote)
    if remote then
        State.connections[#State.connections + 1] =
            remote.OnClientEvent:Connect(function(...)
                local args = table_pack(...)
                local preview = {}
                for i = 1, math_min(args.n, 5) do
                    preview[#preview + 1] = tostring(args[i])
                end
                Debug.log("[REMOTE] n=" .. args.n .. " | " .. table_concat(preview, " | "))

                local body = args[1]
                if type(body) == "string" and body ~= "" then
                    try("handleNotification", handleNotification, body)
                end
            end)
        Debug.log("Remote hooked: " .. remote:GetFullName())
    else
        Debug.warn("Remote not found - relying on TextLabel watcher")
    end

    task_spawn(function()
        local pg = LocalPlayer:WaitForChild("PlayerGui", 20)
        if not pg then return end
        for _, d in ipairs(pg:GetDescendants()) do
            watchTextObject(d)
        end
        pg.DescendantAdded:Connect(function(d)
            task_wait(0.04)
            pcall(watchTextObject, d)
        end)
        Debug.log("Text watcher active")
    end)

    task_spawn(function()
        while not State.unloaded do
            task_wait(0.5)
            pcall(function() UI.renderStatus() end)
        end
    end)

    UI.renderStatus()
    Debug.log("REMAKE BY CRYONHUSH ON TOP")

    getgenv().__auroraRedeemer = {
        unload = function()
            State.unloaded = true
            for _, c in ipairs(State.connections) do
                pcall(function() c:Disconnect() end)
            end
            for _, c in ipairs(uiConnections) do
                pcall(function() c:Disconnect() end)
            end
            pcall(function() UI.root:Destroy() end)
            getgenv().__auroraRedeemer = nil
        end,
        debug = Debug,
        config = Config,
        submit = submitCode,
        save = saveConfig,
    }
end

local ok, err = try("main", main)
if not ok then
    Debug.error("main() crashed: " .. tostring(err))
end