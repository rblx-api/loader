--[[
    skyro · ui example
    ------------------------------------------------------------------
    a standalone charcoal / purple interface demo. there is no backend:
    no http requests, no scanner, no keys and no game data. every hit in
    the feed is generated locally by a demo feed, so the filters have
    something to act on.

    tabs:   Logs · Filters · Actions · Settings
    keys:   RightShift shows / hides the window
    saves:  skyro_ui_example.json (filters + settings only, when the
            environment provides readfile / writefile)
]]

--==============================================================================
-- 01 · bootstrap
--==============================================================================

if _G.SkyroUI then
    pcall(function() _G.SkyroUI.destroy() end)
    _G.SkyroUI = nil
end

local HttpService  = game:GetService("HttpService")   -- JSON encode / decode only
local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")

local SETTINGS_FILE = "skyro_ui_example.json"

--==============================================================================
-- 02 · settings
--==============================================================================

local DEFAULTS = {
    demo      = true,   -- generate demo hits automatically
    demoRate  = 2.0,    -- seconds between demo hits (roughly)
    maxLines  = 25,
    minMps    = 0,
    fx        = true,
    overrides = {},
}

local Settings = {}
local saveQueued = false

local function num(value, fallback)
    local parsed = tonumber(value)
    if parsed == nil or parsed ~= parsed then return fallback end
    return parsed
end

-- one brainrot override = { on = bool, min = number, mut = { [mutation] = number } }
local function decodeEntry(value)
    if type(value) == "number" then
        return { on = true, min = math.max(0, math.floor(value)), mut = {} }
    end
    if type(value) ~= "table" then return nil end

    local entry = { on = value.on ~= false, min = math.max(0, num(value.min, 0)), mut = {} }
    if type(value.mut) == "table" then
        for mutation, amount in pairs(value.mut) do
            local parsed = num(amount, 0)
            if type(mutation) == "string" and parsed > 0 then entry.mut[mutation] = parsed end
        end
    end
    return entry
end

local function entryFor(name, create)
    local entry = Settings.overrides[name]

    if type(entry) == "number" then
        entry = { on = true, min = math.max(0, math.floor(entry)), mut = {} }
        Settings.overrides[name] = entry
    end

    if type(entry) ~= "table" then
        if not create then return nil end
        entry = { on = true, min = 0, mut = {} }
        Settings.overrides[name] = entry
    end

    entry.on = entry.on ~= false
    entry.min = math.max(0, num(entry.min, 0))
    if type(entry.mut) ~= "table" then entry.mut = {} end

    return entry
end

local function loadSettings()
    Settings = {}
    for key, value in pairs(DEFAULTS) do Settings[key] = value end

    local raw = nil
    if type(readfile) == "function" then
        pcall(function() raw = readfile(SETTINGS_FILE) end)
    end

    if type(raw) == "string" and #raw > 0 then
        local decoded = nil
        pcall(function() decoded = HttpService:JSONDecode(raw) end)
        if type(decoded) == "table" then
            for key, default in pairs(DEFAULTS) do
                local value = decoded[key]
                if value ~= nil and type(value) == type(default) then Settings[key] = value end
            end
            if type(decoded.overrides) == "table" then
                local map = {}
                for name, value in pairs(decoded.overrides) do
                    local entry = decodeEntry(value)
                    if type(name) == "string" and entry then map[name] = entry end
                end
                Settings.overrides = map
            end
        end
    end

    Settings.demoRate = math.clamp(num(Settings.demoRate, 2.0), 0.5, 5)
    Settings.maxLines = math.floor(math.clamp(num(Settings.maxLines, 25), 5, 80))
    Settings.minMps   = num(Settings.minMps, 0)
end

local function writeSettings()
    saveQueued = false
    if type(writefile) ~= "function" then return end
    pcall(function()
        writefile(SETTINGS_FILE, HttpService:JSONEncode(Settings))
    end)
end

local function saveSettings()
    if saveQueued then return end
    saveQueued = true
    task.delay(0.75, writeSettings)
end

--==============================================================================
-- 03 · constants
--==============================================================================

local CORE_LIST = { "OG", "Secret" }
local CORE_RARITY = { OG = true, Secret = true }

local PURPLE = Color3.fromRGB(146, 112, 255)
local LILAC  = Color3.fromRGB(196, 178, 255)
local INK    = Color3.fromRGB(236, 232, 250)
local DIM    = Color3.fromRGB(152, 144, 184)
local WHITE  = Color3.fromRGB(255, 255, 255)

local MUTATIONS = {
    { name = "Gold",        multi = 1.25 },
    { name = "Diamond",     multi = 1.5  },
    { name = "Rainbow",     multi = 10   },
    { name = "Bloodrot",    multi = 2    },
    { name = "Candy",       multi = 4    },
    { name = "Lava",        multi = 6    },
    { name = "Galaxy",      multi = 7    },
    { name = "Yin Yang",    multi = 7.5  },
    { name = "Radioactive", multi = 8.5  },
    { name = "Cursed",      multi = 9    },
    { name = "Divine",      multi = 10   },
    { name = "Cyber",       multi = 11   },
    { name = "Phantom",     multi = 12   },
    { name = "Crystal",     multi = 13   },
    { name = "Eclipse",     multi = 14   },
}

-- sample data for the demo: name, rarity and a base value per second
local SAMPLE = {
    { name = "Strawberry Elephant",        rarity = "OG",     mps = 3.5e8 },
    { name = "Meowl",                      rarity = "OG",     mps = 2.75e8 },
    { name = "Headless Horseman",          rarity = "OG",     mps = 1.75e8 },
    { name = "Dragon Cannelloni",          rarity = "Secret", mps = 2.5e8 },
    { name = "Hydra Dragon Cannelloni",    rarity = "Secret", mps = 2e8 },
    { name = "La Supreme Combinasion",     rarity = "Secret", mps = 1.6e8 },
    { name = "Garama and Madundung",       rarity = "Secret", mps = 1.2e8 },
    { name = "Ketupat Kepat",              rarity = "Secret", mps = 9e7 },
    { name = "Tictac Sahur",               rarity = "Secret", mps = 7.5e7 },
    { name = "Los Hotspotsitos",           rarity = "Secret", mps = 6e7 },
    { name = "Esok Sekolah",               rarity = "Secret", mps = 3e7 },
    { name = "Nuclearo Dinossauro",        rarity = "Secret", mps = 1.5e7 },
    { name = "Los Combinasionas",          rarity = "Secret", mps = 1.5e7 },
    { name = "Chicleteira Bicicleteira",   rarity = "Secret", mps = 3.5e6 },
    { name = "La Grande Combinasion",      rarity = "Secret", mps = 1e7 },
    { name = "Pot Hotspot",                rarity = "Secret", mps = 2.5e6 },
    { name = "Graipuss Medussi",           rarity = "Secret", mps = 1e6 },
    { name = "Los Tralaleritos",           rarity = "Secret", mps = 5e5 },
    { name = "La Vacca Saturno Saturnita", rarity = "Secret", mps = 3e5 },
}

-- 0 (or any / off / blank) means "any": no limit at all
local function parseLimit(text)
    local raw = tostring(text or ""):lower():gsub("%s", ""):gsub(",", "")
    if raw == "" or raw == "any" or raw == "off" or raw == "0" then return 0 end

    local value = tonumber(raw)
    if value == nil then
        local suffix = raw:sub(-1)
        local multipliers = { k = 1e3, m = 1e6, b = 1e9, t = 1e12 }
        if multipliers[suffix] then
            value = (tonumber(raw:sub(1, -2)) or 0) * multipliers[suffix]
        end
    end

    if value == nil or value ~= value or value <= 0 then return 0 end
    return math.floor(value)
end

local function abbreviate(value)
    local n = num(value, 0)
    if n >= 1e12 then return string.format("%.2fT", n / 1e12) end
    if n >= 1e9  then return string.format("%.2fB", n / 1e9)  end
    if n >= 1e6  then return string.format("%.2fM", n / 1e6)  end
    if n >= 1e3  then return string.format("%.1fK", n / 1e3)  end
    return string.format("%d", math.floor(n + 0.5))
end

--==============================================================================
-- 04 · state + filter logic
--==============================================================================

local State = {
    alive     = true,
    seq       = 0,
    seen      = {},
    lines     = {},
    slots     = {},
    dirty     = false,
    brainrots = {},
    stats     = { hits = 0, best = 0 },
}

local Feed = {}
local Panel = {}

-- turns any loosely shaped table into a record the filter understands
local function normalise(raw)
    if type(raw) ~= "table" then return nil end
    local name = raw.name or raw.Name
    if name == nil then return nil end

    local rawRarity = tostring(raw.rarity or raw.Rarity or "")
    local rarity = nil
    for _, candidate in ipairs(CORE_LIST) do
        if rawRarity:lower() == candidate:lower() then rarity = candidate end
    end

    return {
        id = tostring(raw.id or (tostring(name) .. "|" .. tostring(raw.mps or 0) .. "|" .. tostring(os.clock()))),
        name = tostring(name),
        mps = num(raw.mps or raw.MPS or raw.value, 0),
        rarity = rarity,
        owner = tostring(raw.owner or "?"),
        mutation = tostring(raw.mutation or ""),
        rank = tonumber(raw.rank),
    }
end

local function mutationLimit(entry, mutation)
    if type(entry) ~= "table" or type(entry.mut) ~= "table" then return 0 end
    if type(mutation) ~= "string" or #mutation == 0 then return 0 end

    local exact = num(entry.mut[mutation], 0)
    if exact > 0 then return exact end

    local needle = mutation:lower():gsub("%s", "")
    for name, value in pairs(entry.mut) do
        if type(name) == "string" and name:lower():gsub("%s", "") == needle then
            return num(value, 0)
        end
    end

    return 0
end

-- the filter: rarity -> per-brainrot on/off -> min gen -> per-mutation min gen
local function passes(record)
    if not record.rarity or not CORE_RARITY[record.rarity] then return false end

    local entry = entryFor(record.name, false)
    if entry and entry.on == false then return false end

    local threshold = num(entry and entry.min or 0, 0)
    if threshold <= 0 then threshold = num(Settings.minMps, 0) end
    if threshold > 0 and record.mps < threshold then return false end

    if entry and record.mutation and #record.mutation > 0 then
        local mutationThreshold = mutationLimit(entry, record.mutation)
        if mutationThreshold > 0 and record.mps < mutationThreshold then return false end
    end

    return true
end

local function loadBrainrots()
    State.brainrots = {}
    for _, rarity in ipairs(CORE_LIST) do
        for _, sample in ipairs(SAMPLE) do
            if sample.rarity == rarity then
                State.brainrots[#State.brainrots + 1] = sample.name
            end
        end
    end
end

-- one random demo hit, sometimes mutated
function Feed.demo()
    local pick = SAMPLE[math.random(1, #SAMPLE)]
    local mutation, multi = "Default", 1

    if math.random() < 0.4 then
        local chosen = MUTATIONS[math.random(1, #MUTATIONS)]
        mutation, multi = chosen.name, chosen.multi
    end

    return {
        id = "demo|" .. tostring(os.clock()) .. "|" .. tostring(math.random(1, 1e9)),
        name = pick.name,
        mps = math.floor(pick.mps * multi * (0.75 + math.random() * 0.7)),
        rarity = pick.rarity,
        owner = "demo",
        mutation = mutation,
        rank = math.random(1, 40),
    }
end

loadSettings()

--==============================================================================
-- 05 · interface — fluid charcoal / purple glass
--==============================================================================
--  everything visual lives here. the backdrop is a CanvasGroup (rounded clip)
--  holding drifting soft orbs, flowing light ribbons, rising sparkles and a
--  glass sheen. panels on top are frosted white glass. one Heartbeat drives
--  every animation and is disconnected in destroy().

local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local SURFACE_2 = Color3.fromRGB(36, 33, 49)
local SURFACE_3 = Color3.fromRGB(47, 43, 63)
local STROKE    = Color3.fromRGB(66, 59, 92)
local VIOLET    = Color3.fromRGB(118, 80, 240)
local ORCHID    = Color3.fromRGB(178, 124, 255)
local MIST      = Color3.fromRGB(54, 48, 76)
local BASE      = Color3.fromRGB(26, 24, 35)   -- lightish black window
local CARD      = Color3.fromRGB(40, 37, 54)   -- glass panels
local CARD_HI   = Color3.fromRGB(52, 47, 71)   -- hovered glass

local GLASS    = 0.18   -- resting card transparency over the fluid
local GLASS_HI = 0.04   -- hovered card transparency

local ACCENT_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, VIOLET),
    ColorSequenceKeypoint.new(0.55, PURPLE),
    ColorSequenceKeypoint.new(1.00, ORCHID),
})

-- violet text with a pale highlight in the middle; Offset slides it across
local SHINE_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, LILAC),
    ColorSequenceKeypoint.new(0.40, Color3.fromRGB(176, 150, 255)),
    ColorSequenceKeypoint.new(0.50, WHITE),
    ColorSequenceKeypoint.new(0.60, Color3.fromRGB(176, 150, 255)),
    ColorSequenceKeypoint.new(1.00, LILAC),
})

local COLORS = {
    up     = Color3.fromRGB(72, 199, 142),
    down   = Color3.fromRGB(255, 92, 110),
    middle = Color3.fromRGB(255, 168, 64),
}

local Fx = {
    enabled     = Settings.fx ~= false,
    clock       = 0,
    flow        = 0,     -- fluid time; runs faster while energy is high
    energy      = 0,     -- 0..1, raised by mouse motion, clicks and hits
    flash       = 0,     -- 0..1, the wash that blooms on a new hit
    order       = 0,
    connections = {},
    animators   = {},
    shines      = {},
}

local function bind(signal, fn)
    local connection = signal:Connect(fn)
    table.insert(Fx.connections, connection)
    return connection
end

-- animator(t, dt) runs every frame; returning true removes it
local function animate(fn)
    table.insert(Fx.animators, fn)
    return fn
end

local function nextOrder()
    Fx.order = Fx.order + 1
    return Fx.order
end

local function tween(object, time, props, style, direction)
    local playing = nil
    pcall(function()
        playing = TweenService:Create(object, TweenInfo.new(time or 0.22,
            style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), props)
        playing:Play()
    end)
    return playing
end

local function corner(parent, radius)
    local item = Instance.new("UICorner")
    item.CornerRadius = (typeof(radius) == "UDim") and radius or UDim.new(0, radius or 12)
    item.Parent = parent
    return item
end

local function round(parent)
    return corner(parent, UDim.new(1, 0))
end

local function outline(parent, color, thickness, transparency)
    local item = Instance.new("UIStroke")
    item.Color = color or STROKE
    item.Thickness = thickness or 1
    item.Transparency = transparency or 0
    item.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    item.Parent = parent
    return item
end

local function gradient(parent, colors, rotation, transparency)
    local item = Instance.new("UIGradient")
    item.Color = colors or ACCENT_GRADIENT
    item.Rotation = rotation or 0
    if transparency then item.Transparency = transparency end
    item.Parent = parent
    return item
end

-- fade({ {0, 1}, {0.5, 0.4}, {1, 1} }) -> NumberSequence
local function fade(points)
    local keys = {}
    for index, point in ipairs(points) do
        keys[index] = NumberSequenceKeypoint.new(point[1], point[2])
    end
    return NumberSequence.new(keys)
end

local function pad(parent, left, right, top, bottom)
    local item = Instance.new("UIPadding")
    item.PaddingLeft = UDim.new(0, left or 0)
    item.PaddingRight = UDim.new(0, right or 0)
    item.PaddingTop = UDim.new(0, top or 0)
    item.PaddingBottom = UDim.new(0, bottom or 0)
    item.Parent = parent
    return item
end

local function frame(parent, props)
    local item = Instance.new("Frame")
    item.BorderSizePixel = 0
    item.BackgroundColor3 = WHITE
    for key, value in pairs(props or {}) do item[key] = value end
    item.Parent = parent
    return item
end

-- weight: nil = medium, true = bold, "black" = black
local function label(parent, size, weight, color)
    local item = Instance.new("TextLabel")
    item.BackgroundTransparency = 1
    if weight == "black" then
        item.Font = Enum.Font.GothamBlack
    elseif weight then
        item.Font = Enum.Font.GothamBold
    else
        item.Font = Enum.Font.GothamMedium
    end
    item.TextSize = size or 12
    item.TextColor3 = color or INK
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.Text = ""
    item.Parent = parent
    return item
end

-- radial soft glow without image assets: stacked translucent discs.
-- the centre is covered by every layer, the rim by one, giving a smooth falloff.
local function softOrb(parent, color, diameter, strength)
    local holder = frame(parent, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(diameter, diameter),
    })

    local layers = 9
    local alpha = 1 - (1 - math.clamp(strength, 0, 0.99)) ^ (1 / layers)

    for index = 1, layers do
        local scale = (index / layers) ^ 0.8
        local ring = frame(holder, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(scale, scale),
            BackgroundColor3 = color,
            BackgroundTransparency = 1 - alpha,
        })
        round(ring)
    end

    return holder
end

-- purple focus ring for text boxes
local function focusRing(box, stroke, host)
    box.Focused:Connect(function()
        tween(stroke, 0.2, { Color = PURPLE, Thickness = 1.5 })
        tween(box, 0.2, { BackgroundTransparency = 0 })
        if host then tween(host, 0.2, { BackgroundTransparency = GLASS_HI }) end
    end)
    box.FocusLost:Connect(function()
        tween(stroke, 0.25, { Color = STROKE, Thickness = 1 })
        tween(box, 0.25, { BackgroundTransparency = 0.15 })
        if host then tween(host, 0.25, { BackgroundTransparency = GLASS }) end
    end)
end

-- screen gui ----------------------------------------------------------------
local guiParent = CoreGui
pcall(function()
    if type(gethui) == "function" then guiParent = gethui() end
end)

do
    local previous = guiParent:FindFirstChild("skyro")
    if previous then pcall(function() previous:Destroy() end) end
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "skyro"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder = 100000
Gui.Parent = guiParent

local WIDTH, HEIGHT = 600, 452

local Screen = frame(Gui, { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })

-- layered purple bloom behind the window (follows it every frame)
local Glow = frame(Screen, {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(WIDTH, HEIGHT),
    BackgroundTransparency = 1,
    ZIndex = 0,
})

local GlowLayers = {}
for index = 1, 7 do
    local spread = index * 6
    local layer = frame(Glow, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 4 + index * 1.5),
        Size = UDim2.new(1, spread * 2, 1, spread * 2),
        BackgroundColor3 = (index <= 2) and LILAC or PURPLE,
        BackgroundTransparency = 0.9,
    })
    corner(layer, 22 + spread)
    GlowLayers[index] = layer
end

local Window = frame(Screen, {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(WIDTH, HEIGHT),
    BackgroundTransparency = 1,
    ZIndex = 1,
})

local WindowScale = Instance.new("UIScale")
WindowScale.Scale = 0.86
WindowScale.Parent = Window

-- fluid backdrop -------------------------------------------------------------
local Backdrop = nil
do
    local ok = pcall(function() Backdrop = Instance.new("CanvasGroup") end)
    if not ok or not Backdrop then
        Backdrop = Instance.new("Frame")
        Backdrop.ClipsDescendants = true
    end
end
Backdrop.Name = "Fluid"
Backdrop.Size = UDim2.fromScale(1, 1)
Backdrop.BackgroundColor3 = BASE
Backdrop.BorderSizePixel = 0
Backdrop.ZIndex = 0
Backdrop.Parent = Window
corner(Backdrop, 22)

do
    local base = frame(Backdrop, { Size = UDim2.fromScale(1, 1), ZIndex = 1 })
    local baseGradient = gradient(base, ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(42, 38, 58)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(30, 28, 41)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(22, 20, 31)),
    }), 120)

    -- soft pastel blobs. depth = how far each one leans toward the cursor
    local ORBS = {
        { color = PURPLE, size = 360, strength = 0.24, cx = 0.12, cy = 0.18, ax = 0.16, ay = 0.14, fx = 0.21, fy = 0.17, phase = 0.0, depth = 0.10 },
        { color = ORCHID, size = 330, strength = 0.20, cx = 0.88, cy = 0.22, ax = 0.14, ay = 0.18, fx = 0.15, fy = 0.23, phase = 1.7, depth = -0.08 },
        { color = VIOLET, size = 280, strength = 0.26, cx = 0.72, cy = 0.95, ax = 0.20, ay = 0.10, fx = 0.19, fy = 0.13, phase = 3.1, depth = 0.06 },
        { color = Color3.fromRGB(96, 56, 210), size = 400, strength = 0.24, cx = 0.30, cy = 0.88, ax = 0.18, ay = 0.12, fx = 0.12, fy = 0.18, phase = 4.4, depth = -0.05 },
        { color = LILAC,  size = 340, strength = 0.07, cx = 0.50, cy = 0.42, ax = 0.24, ay = 0.18, fx = 0.17, fy = 0.11, phase = 2.2, depth = 0.03 },
        { color = ORCHID, size = 210, strength = 0.14, cx = 0.55, cy = 0.10, ax = 0.30, ay = 0.06, fx = 0.09, fy = 0.21, phase = 5.3, depth = 0.14 },
    }

    local orbs = {}
    for index, spec in ipairs(ORBS) do
        local blob = softOrb(Backdrop, spec.color, spec.size, spec.strength)
        blob.ZIndex = 2
        blob.Position = UDim2.fromScale(spec.cx, spec.cy)
        orbs[index] = { blob = blob, spec = spec }
    end

    -- light that follows the cursor around inside the window
    local cursorLight = frame(Backdrop, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        ZIndex = 3,
    })
    do
        local halo = softOrb(cursorLight, PURPLE, 10, 0.2)
        halo.Position = UDim2.fromScale(0.5, 0.5)
        halo.Size = UDim2.fromScale(1, 1)
        local core = softOrb(cursorLight, LILAC, 10, 0.16)
        core.Position = UDim2.fromScale(0.5, 0.5)
        core.Size = UDim2.fromScale(0.45, 0.45)
        core.ZIndex = 2
    end

    -- faint flowing ribbons
    local RIBBON = fade({
        { 0, 1 }, { 0.36, 1 }, { 0.46, 0.95 }, { 0.5, 0.91 }, { 0.54, 0.95 }, { 0.64, 1 }, { 1, 1 },
    })
    local BANDS = {
        { rotation = 24,  speed = 0.09, phase = 0.0, color = ColorSequence.new(ORCHID, LILAC) },
        { rotation = -32, speed = 0.07, phase = 2.4, color = ColorSequence.new(LILAC, LILAC) },
        { rotation = 64,  speed = 0.05, phase = 4.1, color = ColorSequence.new(LILAC, ORCHID) },
    }

    local bands = {}
    for index, spec in ipairs(BANDS) do
        local band = frame(Backdrop, { Size = UDim2.fromScale(1, 1), ZIndex = 4 })
        bands[index] = { gradient = gradient(band, spec.color, spec.rotation, RIBBON), spec = spec }
    end

    -- sparkles that drift up and get pushed away by the cursor
    local rng = Random.new()
    local sparks = {}
    for index = 1, 22 do
        local size = rng:NextInteger(2, 4)
        local dot = frame(Backdrop, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(size, size),
            BackgroundColor3 = (index % 3 == 0) and LILAC or WHITE,
            ZIndex = 5,
        })
        round(dot)
        sparks[index] = {
            dot = dot,
            x = rng:NextNumber(),
            y = rng:NextNumber(),
            ox = 0,
            oy = 0,
            speed = rng:NextNumber(0.012, 0.035),
            drift = rng:NextNumber(0.3, 1.2),
            phase = rng:NextNumber(0, math.pi * 2),
        }
    end

    -- soft wash that blooms when a hit lands
    local flash = frame(Backdrop, {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = ORCHID,
        BackgroundTransparency = 1,
        ZIndex = 6,
    })

    -- glass sheen on top, barely-there lilac floor
    local sheen = frame(Backdrop, { Size = UDim2.fromScale(1, 0.45), ZIndex = 7 })
    gradient(sheen, ColorSequence.new(WHITE), 90, fade({ { 0, 0.93 }, { 0.6, 0.985 }, { 1, 1 } }))

    local floor = frame(Backdrop, {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.fromScale(1, 0.3),
        BackgroundColor3 = PURPLE,
        ZIndex = 7,
    })
    gradient(floor, ColorSequence.new(WHITE), 90, fade({ { 0, 1 }, { 1, 0.86 } }))

    -- reactions --------------------------------------------------------
    function Fx.pulse()
        Fx.energy = 1
        Fx.flash = 1
    end

    function Fx.shock(rx, ry)
        local ring = frame(Backdrop, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(rx, ry),
            Size = UDim2.fromOffset(8, 8),
            BackgroundColor3 = ORCHID,
            BackgroundTransparency = 0.85,
            ZIndex = 5,
        })
        round(ring)
        local stroke = outline(ring, LILAC, 1.5, 0.4)

        tween(ring, 0.9, { Size = UDim2.fromOffset(230, 230), BackgroundTransparency = 1 }, Enum.EasingStyle.Quart)
        tween(stroke, 0.9, { Transparency = 1, Thickness = 0.5 }, Enum.EasingStyle.Quart)
        task.delay(0.95, function() pcall(function() ring:Destroy() end) end)
    end

    local pointer = Vector2.new(0.5, 0.5)
    local presence = 0
    local lastMouse = nil

    local function relative(position)
        local origin, size = Backdrop.AbsolutePosition, Backdrop.AbsoluteSize
        local rx = (position.X - origin.X) / math.max(size.X, 1)
        local ry = (position.Y - origin.Y) / math.max(size.Y, 1)
        return rx, ry, (rx >= 0 and rx <= 1 and ry >= 0 and ry <= 1)
    end

    bind(UserInputService.InputBegan, function(input)
        if not (Fx.enabled and Window.Visible) then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            local rx, ry, inside = relative(UserInputService:GetMouseLocation())
            if inside then
                Fx.shock(rx, ry)
                Fx.energy = math.min(1, Fx.energy + 0.3)
            end
        end
    end)

    animate(function(_, dt)
        if not Window.Visible or not Fx.enabled then return end

        local mouse = UserInputService:GetMouseLocation()
        local rx, ry, inside = relative(mouse)

        -- moving the mouse stirs the fluid
        if lastMouse and inside then
            local speed = (mouse - lastMouse).Magnitude / math.max(dt, 1 / 240)
            Fx.energy = math.min(1, Fx.energy + speed * 0.000012)
        end
        lastMouse = mouse

        if inside then pointer = pointer:Lerp(Vector2.new(rx, ry), math.min(1, dt * 6)) end
        presence = presence + ((inside and 1 or 0) - presence) * math.min(1, dt * 4)
        Fx.energy = Fx.energy * math.exp(-dt * 1.3)
        Fx.flash = Fx.flash * math.exp(-dt * 2.6)

        -- energy speeds the flow up, then it settles back down
        Fx.flow = Fx.flow + dt * (1 + Fx.energy * 3.5)
        local t = Fx.flow

        baseGradient.Rotation = 120 + math.sin(t * 0.13) * 30

        local lean = (pointer - Vector2.new(0.5, 0.5)) * presence
        for _, orb in ipairs(orbs) do
            local spec = orb.spec
            local x = spec.cx + math.sin(t * spec.fx + spec.phase) * spec.ax + lean.X * spec.depth
            local y = spec.cy + math.cos(t * spec.fy + spec.phase * 1.3) * spec.ay + lean.Y * spec.depth
            local breathe = spec.size * (1 + math.sin(t * 0.5 + spec.phase) * 0.12 + Fx.energy * 0.1)
            orb.blob.Position = UDim2.fromScale(x, y)
            orb.blob.Size = UDim2.fromOffset(breathe, breathe)
        end

        local lightSize = 280 * presence * (1 + Fx.energy * 0.3)
        cursorLight.Position = UDim2.fromScale(pointer.X, pointer.Y)
        cursorLight.Size = UDim2.fromOffset(lightSize, lightSize)

        for _, band in ipairs(bands) do
            local spec = band.spec
            band.gradient.Offset = Vector2.new(math.sin(t * spec.speed + spec.phase) * 0.55, 0)
            band.gradient.Rotation = spec.rotation + math.sin(t * spec.speed * 0.8 + spec.phase) * 14
        end

        local area = Backdrop.AbsoluteSize
        local scale = math.max(WindowScale.Scale, 0.01)
        local decay = math.min(1, dt * 2.5)

        for _, spark in ipairs(sparks) do
            spark.y = spark.y - spark.speed * dt * (1 + Fx.energy * 2)
            if spark.y < -0.04 then
                spark.y = 1.04
                spark.x = rng:NextNumber()
                spark.ox, spark.oy = 0, 0
            end

            -- push away from the cursor (pixel space)
            if presence > 0.05 then
                local dx = (spark.x - pointer.X) * area.X / scale + spark.ox
                local dy = (spark.y - pointer.Y) * area.Y / scale + spark.oy
                local distance = math.sqrt(dx * dx + dy * dy)
                if distance < 90 and distance > 0.001 then
                    local push = (90 - distance) * dt * 5 * presence
                    spark.ox = spark.ox + dx / distance * push
                    spark.oy = spark.oy + dy / distance * push
                end
            end
            spark.ox = spark.ox - spark.ox * decay * 0.4
            spark.oy = spark.oy - spark.oy * decay * 0.4

            spark.dot.Position = UDim2.new(
                spark.x + math.sin(t * spark.drift + spark.phase) * 0.02, spark.ox,
                spark.y, spark.oy
            )
            spark.dot.BackgroundTransparency = 0.25 + 0.65 * (0.5 + 0.5 * math.sin(t * 2.2 + spark.phase))
        end

        flash.BackgroundTransparency = 1 - Fx.flash * 0.16
    end)
end

-- light that travels around the window edge
do
    local rim = frame(Window, { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 1 })
    corner(rim, 22)
    local stroke = outline(rim, WHITE, 1.5, 0)
    local rimGradient = gradient(stroke, ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, LILAC),
        ColorSequenceKeypoint.new(0.50, ORCHID),
        ColorSequenceKeypoint.new(1.00, PURPLE),
    }), 0, fade({ { 0, 0.35 }, { 0.5, 0.8 }, { 1, 0.5 } }))

    animate(function(t)
        if Fx.enabled and Window.Visible then rimGradient.Rotation = (t * 36) % 360 end
    end)
end

-- header ----------------------------------------------------------------------
local Header = frame(Window, {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 64),
    Active = true,
    ZIndex = 2,
})

do
    local halo = softOrb(Header, PURPLE, 70, 0.28)
    halo.Position = UDim2.fromOffset(33, 32)

    local logo = frame(Header, { Position = UDim2.fromOffset(16, 15), Size = UDim2.fromOffset(34, 34), ZIndex = 2 })
    corner(logo, 11)
    local logoGradient = gradient(logo, ACCENT_GRADIENT, 45)

    local gloss = frame(logo, { Size = UDim2.new(1, 0, 0.5, 0), BackgroundTransparency = 0.6 })
    corner(gloss, 11)
    gradient(gloss, ColorSequence.new(WHITE), 90, fade({ { 0, 0.2 }, { 1, 1 } }))

    local glyph = label(logo, 17, "black", WHITE)
    glyph.Size = UDim2.fromScale(1, 1)
    glyph.TextXAlignment = Enum.TextXAlignment.Center
    glyph.Text = "S"
    glyph.ZIndex = 2

    local title = label(Header, 17, "black", WHITE)
    title.Position = UDim2.fromOffset(60, 13)
    title.Size = UDim2.fromOffset(0, 20)
    title.AutomaticSize = Enum.AutomaticSize.X
    title.Text = "skyro"
    table.insert(Fx.shines, gradient(title, SHINE_GRADIENT, 0))

    local subtitle = label(Header, 10, false, DIM)
    subtitle.Position = UDim2.fromOffset(60, 34)
    subtitle.Size = UDim2.fromOffset(240, 14)
    subtitle.Text = "ui example"

    animate(function(t)
        if not Window.Visible then return end
        logoGradient.Rotation = (t * 45) % 360
        local pulse = 70 + math.sin(t * 2.1) * 8
        halo.Size = UDim2.fromOffset(pulse, pulse)
    end)
end

local Pill = frame(Header, {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -88, 0, 19),
    Size = UDim2.fromOffset(118, 26),
    BackgroundColor3 = SURFACE_3,
    BackgroundTransparency = 0.15,
})
round(Pill)
outline(Pill, STROKE, 1, 0)

local PillPulse = frame(Pill, {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(15, 13),
    Size = UDim2.fromOffset(7, 7),
    BackgroundColor3 = COLORS.down,
})
round(PillPulse)

local PillDot = frame(Pill, {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(15, 13),
    Size = UDim2.fromOffset(7, 7),
    BackgroundColor3 = COLORS.down,
    ZIndex = 2,
})
round(PillDot)

local PillText = label(Pill, 9, true, DIM)
PillText.Position = UDim2.fromOffset(27, 0)
PillText.Size = UDim2.new(1, -34, 1, 0)
PillText.TextTruncate = Enum.TextTruncate.AtEnd
PillText.Text = "DOWN"

animate(function(t)
    if not Window.Visible then return end
    local phase = (t * 0.8) % 1
    local size = 7 + phase * 14
    PillPulse.Size = UDim2.fromOffset(size, size)
    PillPulse.BackgroundTransparency = 0.35 + phase * 0.65
end)

local function headerButton(glyph, offsetX, callback)
    local button = Instance.new("TextButton")
    button.AnchorPoint = Vector2.new(1, 0)
    button.Position = UDim2.new(1, offsetX, 0, 19)
    button.Size = UDim2.fromOffset(26, 26)
    button.BackgroundColor3 = SURFACE_3
    button.BackgroundTransparency = 0.15
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = DIM
    button.Text = glyph
    button.Parent = Header
    round(button)
    outline(button, STROKE, 1, 0)

    local scale = Instance.new("UIScale")
    scale.Parent = button

    button.MouseEnter:Connect(function()
        tween(button, 0.18, { BackgroundColor3 = PURPLE, BackgroundTransparency = 0, TextColor3 = WHITE })
        tween(scale, 0.3, { Scale = 1.1 }, Enum.EasingStyle.Back)
    end)
    button.MouseLeave:Connect(function()
        tween(button, 0.22, { BackgroundColor3 = SURFACE_3, BackgroundTransparency = 0.15, TextColor3 = DIM })
        tween(scale, 0.22, { Scale = 1 })
    end)
    button.MouseButton1Down:Connect(function() tween(scale, 0.1, { Scale = 0.9 }) end)
    button.MouseButton1Up:Connect(function() tween(scale, 0.3, { Scale = 1.1 }, Enum.EasingStyle.Back) end)
    button.MouseButton1Click:Connect(callback)

    return button
end

do
    local divider = frame(Window, {
        Position = UDim2.fromOffset(18, 64),
        Size = UDim2.new(1, -36, 0, 1),
        ZIndex = 2,
    })
    local dividerGradient = gradient(divider, ACCENT_GRADIENT, 0, fade({ { 0, 1 }, { 0.5, 0.6 }, { 1, 1 } }))

    animate(function(t)
        if Fx.enabled and Window.Visible then
            dividerGradient.Offset = Vector2.new(math.sin(t * 0.6) * 0.35, 0)
        end
    end)
end

-- navigation ------------------------------------------------------------------
local Sidebar = frame(Window, {
    Position = UDim2.fromOffset(16, 76),
    Size = UDim2.new(0, 140, 1, -92),
    BackgroundColor3 = CARD,
    BackgroundTransparency = 0.3,
    ZIndex = 2,
})
corner(Sidebar, 16)
outline(Sidebar, STROKE, 1, 0)

-- one gradient pill that glides between tabs
local Indicator = frame(Sidebar, {
    Position = UDim2.fromOffset(8, 8),
    Size = UDim2.new(1, -16, 0, 36),
    BackgroundTransparency = 1,
    ZIndex = 2,
})

do
    local bloom = frame(Indicator, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 3),
        Size = UDim2.new(1, 8, 1, 8),
        BackgroundColor3 = PURPLE,
        BackgroundTransparency = 0.84,
        ZIndex = 1,
    })
    corner(bloom, 14)

    local pill = frame(Indicator, { Size = UDim2.fromScale(1, 1), ZIndex = 2 })
    corner(pill, 11)
    local pillGradient = gradient(pill, ACCENT_GRADIENT, 0)

    local gloss = frame(pill, { Size = UDim2.new(1, 0, 0.5, 0), BackgroundTransparency = 0.82 })
    corner(gloss, 11)

    animate(function(t)
        if not (Fx.enabled and Window.Visible) then return end
        pillGradient.Rotation = math.sin(t * 0.7) * 25
        bloom.BackgroundTransparency = 0.9 + math.sin(t * 2) * 0.03
    end)
end

-- hit counter at the bottom of the sidebar
local Side = {}
do
    local foot = frame(Sidebar, {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 8, 1, -8),
        Size = UDim2.new(1, -16, 0, 70),
        BackgroundColor3 = SURFACE_2,
        BackgroundTransparency = 0.1,
        ZIndex = 2,
    })
    corner(foot, 12)
    outline(foot, STROKE, 1, 0)

    local caption = label(foot, 9, true, DIM)
    caption.Position = UDim2.fromOffset(12, 10)
    caption.Size = UDim2.new(1, -24, 0, 12)
    caption.Text = "TOTAL HITS"

    local value = label(foot, 22, "black", WHITE)
    value.Position = UDim2.fromOffset(12, 22)
    value.Size = UDim2.new(1, -24, 0, 26)
    value.Text = "0"
    table.insert(Fx.shines, gradient(value, SHINE_GRADIENT, 0))

    local best = label(foot, 9, false, DIM)
    best.Position = UDim2.fromOffset(12, 48)
    best.Size = UDim2.new(1, -24, 0, 12)
    best.TextTruncate = Enum.TextTruncate.AtEnd
    best.Text = "best —"

    Side.hits = value
    Side.best = best
end

local Content = frame(Window, {
    Position = UDim2.fromOffset(168, 76),
    Size = UDim2.new(1, -184, 1, -92),
    BackgroundColor3 = CARD,
    BackgroundTransparency = 0.3,
    ZIndex = 2,
})
corner(Content, 16)
outline(Content, STROKE, 1, 0)

-- hit toast: slides in at the top right when a new hit passes the filter
local Toast = { serial = 0 }
do
    local holder = nil
    local ok = pcall(function() holder = Instance.new("CanvasGroup") end)
    if not ok or not holder then holder = Instance.new("Frame") end
    holder.AnchorPoint = Vector2.new(1, 0)
    holder.Position = UDim2.new(1, -18, 0, 78)
    holder.Size = UDim2.fromOffset(240, 54)
    holder.BackgroundColor3 = SURFACE_2
    holder.BorderSizePixel = 0
    holder.Visible = false
    holder.ZIndex = 20
    holder.Parent = Window
    corner(holder, 14)
    outline(holder, PURPLE, 1, 0.45)

    local icon = frame(holder, { Position = UDim2.fromOffset(11, 11), Size = UDim2.fromOffset(32, 32) })
    corner(icon, 10)
    gradient(icon, ACCENT_GRADIENT, 45)

    local iconText = label(icon, 10, "black", WHITE)
    iconText.Size = UDim2.fromScale(1, 1)
    iconText.TextXAlignment = Enum.TextXAlignment.Center

    local heading = label(holder, 9, true, LILAC)
    heading.Position = UDim2.fromOffset(53, 11)
    heading.Size = UDim2.new(1, -64, 0, 12)

    local body = label(holder, 11, true, INK)
    body.Position = UDim2.fromOffset(53, 25)
    body.Size = UDim2.new(1, -64, 0, 16)
    body.TextTruncate = Enum.TextTruncate.AtEnd

    local progress = frame(holder, { Position = UDim2.new(0, 12, 1, -5), Size = UDim2.new(1, -24, 0, 2) })
    round(progress)
    gradient(progress, ACCENT_GRADIENT, 0)

    local SHOWN_AT, HIDDEN_AT = UDim2.new(1, -18, 0, 78), UDim2.new(1, 0, 0, 78)

    function Toast.show(headingText, bodyText, badge)
        if not Window.Visible or not Content.Visible then return end

        Toast.serial = Toast.serial + 1
        local serial = Toast.serial

        heading.Text = string.upper(headingText or "")
        body.Text = bodyText or ""
        iconText.Text = badge or "!"

        if not holder.Visible then
            holder.Position = HIDDEN_AT
            pcall(function() holder.GroupTransparency = 1 end)
        end
        holder.Visible = true
        tween(holder, 0.5, { Position = SHOWN_AT }, Enum.EasingStyle.Back)
        tween(holder, 0.3, { GroupTransparency = 0 })

        progress.Size = UDim2.new(1, -24, 0, 2)
        tween(progress, 2.8, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)

        task.delay(2.9, function()
            if serial ~= Toast.serial then return end
            tween(holder, 0.3, { Position = HIDDEN_AT }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            tween(holder, 0.25, { GroupTransparency = 1 })
            task.delay(0.32, function()
                if serial == Toast.serial then holder.Visible = false end
            end)
        end)
    end
end

local Pages = {}
local Tabs = {}
local currentTab = nil
local activate = nil

local TAB_HEIGHT, TAB_GAP = 36, 6

local function newPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Position = UDim2.fromOffset(10, 10)
    page.Size = UDim2.new(1, -20, 1, -20)
    page.CanvasSize = UDim2.new()
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = PURPLE
    page.ScrollBarImageTransparency = 0.45
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.Visible = false
    page.Parent = Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    pad(page, 1, 8, 1, 10)

    Pages[name] = page
    return page
end

local function newTab(name, order)
    local y = 8 + (order - 1) * (TAB_HEIGHT + TAB_GAP)

    local button = Instance.new("TextButton")
    button.Name = name
    button.Position = UDim2.fromOffset(8, y)
    button.Size = UDim2.new(1, -16, 0, TAB_HEIGHT)
    button.BackgroundColor3 = SURFACE_3
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Text = ""
    button.ZIndex = 3
    button.Parent = Sidebar
    corner(button, 11)

    local marker = frame(button, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 16, 0.5, 0),
        Size = UDim2.fromOffset(6, 6),
        BackgroundColor3 = LILAC,
    })
    round(marker)

    local text = label(button, 12, false, DIM)
    text.Position = UDim2.fromOffset(30, 0)
    text.Size = UDim2.new(1, -36, 1, 0)
    text.Text = name

    Tabs[name] = { button = button, marker = marker, text = text, y = y, page = newPage(name) }

    button.MouseEnter:Connect(function()
        if currentTab == name then return end
        tween(button, 0.18, { BackgroundTransparency = 0.45 })
        tween(text, 0.18, { TextColor3 = LILAC, Position = UDim2.fromOffset(33, 0) })
    end)
    button.MouseLeave:Connect(function()
        if currentTab == name then return end
        tween(button, 0.22, { BackgroundTransparency = 1 })
        tween(text, 0.22, { TextColor3 = DIM, Position = UDim2.fromOffset(30, 0) })
    end)
    button.MouseButton1Click:Connect(function()
        if activate then activate(name) end
    end)

    return Tabs[name].page
end

activate = function(name)
    local previousTab = currentTab
    currentTab = name

    for key, tab in pairs(Tabs) do
        local active = (key == name)
        tab.page.Visible = active
        tab.text.Font = active and Enum.Font.GothamBold or Enum.Font.GothamMedium

        tween(tab.button, 0.2, { BackgroundTransparency = 1 })
        tween(tab.text, 0.25, {
            TextColor3 = active and WHITE or DIM,
            Position = UDim2.fromOffset(active and 32 or 30, 0),
        })
        tween(tab.marker, 0.35, {
            BackgroundColor3 = active and WHITE or LILAC,
            Size = active and UDim2.fromOffset(8, 8) or UDim2.fromOffset(6, 6),
        }, Enum.EasingStyle.Back)

        if active then
            tween(Indicator, 0.45, { Position = UDim2.fromOffset(8, tab.y) })
            if previousTab ~= name then
                tab.page.Position = UDim2.fromOffset(10, 26)
                tween(tab.page, 0.45, { Position = UDim2.fromOffset(10, 10) })
            end
        end
    end
end

-- components ------------------------------------------------------------------
local UI = {}

-- expanding circle from the cursor (or the centre) inside a clipping host
local function ripple(host, color, centred)
    pcall(function()
        local origin, size = host.AbsolutePosition, host.AbsoluteSize
        local x, y = size.X / 2, size.Y / 2

        if not centred then
            local mouse = UserInputService:GetMouseLocation()
            local mx, my = mouse.X - origin.X, mouse.Y - origin.Y
            if mx >= 0 and my >= 0 and mx <= size.X and my <= size.Y then x, y = mx, my end
        end

        local scale = math.max(WindowScale.Scale, 0.01)
        local diameter = math.max(size.X, size.Y) * 2.4 / scale

        local dot = frame(host, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(x / scale, y / scale),
            Size = UDim2.fromOffset(0, 0),
            BackgroundColor3 = color or PURPLE,
            BackgroundTransparency = 0.75,
            ZIndex = 0,
        })
        round(dot)

        tween(dot, 0.6, { Size = UDim2.fromOffset(diameter, diameter), BackgroundTransparency = 1 },
            Enum.EasingStyle.Quad)
        task.delay(0.65, function() pcall(function() dot:Destroy() end) end)
    end)
end

local function card(page, height)
    local item = frame(page, {
        Size = UDim2.new(1, -2, 0, height),
        BackgroundColor3 = CARD,
        BackgroundTransparency = GLASS,
        ClipsDescendants = true,
        LayoutOrder = nextOrder(),
    })
    corner(item, 13)

    local stroke = outline(item, WHITE, 1, 0)
    gradient(stroke, ColorSequence.new(Color3.fromRGB(98, 86, 138), STROKE), 90)

    return item, stroke
end

local function hoverable(row, hit, stroke)
    hit.MouseEnter:Connect(function()
        tween(row, 0.18, { BackgroundTransparency = GLASS_HI, BackgroundColor3 = CARD_HI })
        if stroke then tween(stroke, 0.18, { Color = LILAC }) end
    end)
    hit.MouseLeave:Connect(function()
        tween(row, 0.3, { BackgroundTransparency = GLASS, BackgroundColor3 = CARD })
        if stroke then tween(stroke, 0.3, { Color = WHITE }) end
    end)
end

function UI.section(page, titleText)
    local holder = frame(page, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -2, 0, 22),
        LayoutOrder = nextOrder(),
    })

    local dot = frame(holder, {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 3, 0.5, 0),
        Size = UDim2.fromOffset(6, 6),
    })
    round(dot)
    gradient(dot, ACCENT_GRADIENT, 45)

    local text = label(holder, 10, true, LILAC)
    text.Position = UDim2.fromOffset(16, 0)
    text.Size = UDim2.new(0, 0, 1, 0)
    text.AutomaticSize = Enum.AutomaticSize.X
    text.Text = string.upper(titleText)

    local line = frame(holder, {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -4, 0.5, 0),
        Size = UDim2.new(1, -120, 0, 1),
    })
    gradient(line, ACCENT_GRADIENT, 0, fade({ { 0, 0.55 }, { 1, 1 } }))

    local function fit()
        line.Size = UDim2.new(1, -(text.AbsoluteSize.X / math.max(WindowScale.Scale, 0.01) + 30), 0, 1)
    end
    text:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
    task.defer(fit)

    return holder
end

function UI.button(page, opt)
    local hasDesc = opt.desc ~= nil and opt.desc ~= ""
    local row, stroke = card(page, hasDesc and 52 or 40)

    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1
    hit.Size = UDim2.fromScale(1, 1)
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.ZIndex = 3
    hit.Parent = row

    local title = label(row, 12, true, INK)
    title.Position = UDim2.fromOffset(14, hasDesc and 10 or 0)
    title.Size = UDim2.new(1, -56, 0, hasDesc and 16 or 40)
    title.Text = opt.name

    if hasDesc then
        local desc = label(row, 10, false, DIM)
        desc.Position = UDim2.fromOffset(14, 28)
        desc.Size = UDim2.new(1, -56, 0, 14)
        desc.TextTruncate = Enum.TextTruncate.AtEnd
        desc.Text = opt.desc
    end

    local badge = frame(row, {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(26, 26),
        BackgroundColor3 = MIST,
    })
    round(badge)

    local chevron = label(badge, 15, true, LILAC)
    chevron.Size = UDim2.fromScale(1, 1)
    chevron.Position = UDim2.fromOffset(1, -1)
    chevron.TextXAlignment = Enum.TextXAlignment.Center
    chevron.Text = "›"

    hoverable(row, hit, stroke)
    hit.MouseEnter:Connect(function()
        tween(badge, 0.25, { BackgroundColor3 = PURPLE, Position = UDim2.new(1, -9, 0.5, 0) })
        tween(chevron, 0.25, { TextColor3 = WHITE })
    end)
    hit.MouseLeave:Connect(function()
        tween(badge, 0.3, { BackgroundColor3 = MIST, Position = UDim2.new(1, -12, 0.5, 0) })
        tween(chevron, 0.3, { TextColor3 = LILAC })
    end)

    hit.MouseButton1Click:Connect(function()
        ripple(row, PURPLE)
        if opt.callback then pcall(opt.callback) end
    end)

    return row
end

function UI.label(page, value, muted)
    local holder = frame(page, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -2, 0, 16),
        LayoutOrder = nextOrder(),
    })

    local text = label(holder, 10, false, muted and DIM or INK)
    text.Position = UDim2.fromOffset(4, 0)
    text.Size = UDim2.new(1, -8, 1, 0)
    text.Text = value

    return text
end

-- one log line: accent bar, title, detail and a rarity chip
function UI.entry(page)
    local row, stroke = card(page, 52)
    hoverable(row, row, stroke)

    local bar = frame(row, {
        Position = UDim2.fromOffset(9, 11),
        Size = UDim2.new(0, 3, 1, -22),
    })
    round(bar)
    gradient(bar, ACCENT_GRADIENT, 90)

    local title = label(row, 12, true, INK)
    title.Position = UDim2.fromOffset(22, 9)
    title.Size = UDim2.new(1, -100, 0, 16)
    title.TextTruncate = Enum.TextTruncate.AtEnd

    local body = label(row, 10, false, DIM)
    body.Position = UDim2.fromOffset(22, 27)
    body.Size = UDim2.new(1, -100, 0, 14)
    body.TextTruncate = Enum.TextTruncate.AtEnd

    local chip = frame(row, {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(60, 20),
        Visible = false,
    })
    round(chip)
    local chipGradient = gradient(chip, ACCENT_GRADIENT, 0)
    local chipStroke = outline(chip, PURPLE, 1, 0.5)

    local chipText = label(chip, 9, true, WHITE)
    chipText.Size = UDim2.fromScale(1, 1)
    chipText.TextXAlignment = Enum.TextXAlignment.Center

    local entry = { frame = row }

    function entry.Set(_, data)
        pcall(function()
            title.Text = data.Title or ""
            body.Text = data.Text or ""

            local rarity = data.Rarity
            chip.Visible = type(rarity) == "string" and #rarity > 0
            if rarity == "Secret" then
                chipGradient.Enabled = true
                chip.BackgroundColor3 = WHITE
                chipText.TextColor3 = WHITE
                chipStroke.Transparency = 1
            else
                chipGradient.Enabled = false
                chip.BackgroundColor3 = MIST
                chipText.TextColor3 = LILAC
                chipStroke.Transparency = 0.5
            end
            chipText.Text = string.upper(tostring(rarity or ""))
        end)
    end

    -- bright pulse when a new hit lands in this slot
    function entry.Flash()
        pcall(function()
            row.BackgroundColor3 = Color3.fromRGB(74, 60, 112)
            row.BackgroundTransparency = 0
            tween(row, 1.1, { BackgroundColor3 = CARD, BackgroundTransparency = GLASS }, Enum.EasingStyle.Quad)
            bar.Size = UDim2.new(0, 3, 0, 0)
            tween(bar, 0.5, { Size = UDim2.new(0, 3, 1, -22) }, Enum.EasingStyle.Back)
            ripple(row, ORCHID, true)
        end)
    end

    function entry.Destroy()
        pcall(function() row:Destroy() end)
    end

    return entry
end

function UI.toggle(page, opt)
    local row, stroke = card(page, 52)

    local title = label(row, 12, true, INK)
    title.Position = UDim2.fromOffset(14, opt.desc and 10 or 0)
    title.Size = UDim2.new(1, -84, 0, opt.desc and 16 or 52)
    title.Text = opt.name

    if opt.desc then
        local desc = label(row, 10, false, DIM)
        desc.Position = UDim2.fromOffset(14, 28)
        desc.Size = UDim2.new(1, -84, 0, 14)
        desc.TextTruncate = Enum.TextTruncate.AtEnd
        desc.Text = opt.desc
    end

    local track = frame(row, {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(46, 26),
        BackgroundColor3 = MIST,
    })
    round(track)

    local fill = frame(track, { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })
    round(fill)
    gradient(fill, ACCENT_GRADIENT, 0)

    local knob = frame(track, {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 3, 0.5, 0),
        Size = UDim2.fromOffset(20, 20),
        ZIndex = 2,
    })
    round(knob)
    outline(knob, STROKE, 1, 0)

    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1
    hit.Size = UDim2.fromScale(1, 1)
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.ZIndex = 3
    hit.Parent = row

    hoverable(row, hit, stroke)

    local on = opt.value and true or false

    local function paint()
        tween(fill, 0.25, { BackgroundTransparency = on and 0 or 1 })
        tween(knob, 0.4, { Position = on and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) },
            Enum.EasingStyle.Back)
    end

    paint()

    hit.MouseButton1Click:Connect(function()
        on = not on
        paint()
        ripple(row, PURPLE)
        if opt.callback then pcall(opt.callback, on) end
    end)

    return {
        Set = function(_, value)
            on = value and true or false
            paint()
        end,
        Get = function() return on end,
    }
end

function UI.slider(page, opt)
    local row, stroke = card(page, 62)

    local title = label(row, 12, true, INK)
    title.Position = UDim2.fromOffset(14, 11)
    title.Size = UDim2.new(1, -110, 0, 16)
    title.Text = opt.name

    local valuePill = frame(row, {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -14, 0, 9),
        Size = UDim2.fromOffset(72, 20),
        BackgroundColor3 = MIST,
    })
    round(valuePill)

    local valueLabel = label(valuePill, 10, true, LILAC)
    valueLabel.Size = UDim2.fromScale(1, 1)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center

    local track = frame(row, {
        Position = UDim2.fromOffset(16, 42),
        Size = UDim2.new(1, -32, 0, 6),
        BackgroundColor3 = MIST,
    })
    round(track)

    local fill = frame(track, { Size = UDim2.new(0, 0, 1, 0) })
    round(fill)
    gradient(fill, ACCENT_GRADIENT, 0)

    local knob = frame(track, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(16, 16),
        ZIndex = 2,
    })
    round(knob)
    outline(knob, PURPLE, 2, 0)

    local knobScale = Instance.new("UIScale")
    knobScale.Parent = knob

    -- larger invisible hit strip so the thin track is easy to grab
    local grab = frame(row, {
        Position = UDim2.fromOffset(8, 32),
        Size = UDim2.new(1, -16, 0, 26),
        BackgroundTransparency = 1,
        Active = true,
        ZIndex = 3,
    })

    hoverable(row, row, stroke)

    local minimum, maximum = opt.min, opt.max
    local value = math.clamp(opt.value or minimum, minimum, maximum)
    local dragging = false

    local function paint()
        local alpha = (maximum == minimum) and 0 or (value - minimum) / (maximum - minimum)
        alpha = math.clamp(alpha, 0, 1)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        valueLabel.Text = opt.format and opt.format(value) or tostring(value)
    end

    local function applyFromX(x)
        local alpha = (x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1)
        alpha = math.clamp(alpha, 0, 1)

        local raw = minimum + (maximum - minimum) * alpha
        if opt.increment and opt.increment > 0 then
            raw = math.floor(raw / opt.increment + 0.5) * opt.increment
        end

        local nextValue = math.clamp(raw, minimum, maximum)
        if nextValue ~= value then
            value = nextValue
            paint()
            if opt.callback then pcall(opt.callback, value) end
        end
    end

    grab.MouseEnter:Connect(function()
        if not dragging then tween(knobScale, 0.25, { Scale = 1.18 }, Enum.EasingStyle.Back) end
    end)
    grab.MouseLeave:Connect(function()
        if not dragging then tween(knobScale, 0.25, { Scale = 1 }) end
    end)

    grab.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            tween(knobScale, 0.25, { Scale = 1.35 }, Enum.EasingStyle.Back)
            tween(valuePill, 0.2, { BackgroundColor3 = PURPLE })
            tween(valueLabel, 0.2, { TextColor3 = WHITE })
            applyFromX(input.Position.X)
        end
    end)

    bind(UserInputService.InputChanged, function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            applyFromX(input.Position.X)
        end
    end)

    bind(UserInputService.InputEnded, function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            tween(knobScale, 0.3, { Scale = 1 })
            tween(valuePill, 0.3, { BackgroundColor3 = MIST })
            tween(valueLabel, 0.3, { TextColor3 = LILAC })
        end
    end)

    paint()

    return {
        Set = function(_, newValue)
            value = math.clamp(newValue, minimum, maximum)
            paint()
        end,
    }
end

function UI.input(page, opt)
    local row = card(page, 56)

    local title = label(row, 12, true, INK)
    title.Position = UDim2.fromOffset(14, 10)
    title.Size = UDim2.new(1, -160, 0, 16)
    title.Text = opt.name

    local desc = label(row, 10, false, DIM)
    desc.Position = UDim2.fromOffset(14, 28)
    desc.Size = UDim2.new(1, -160, 0, 14)
    desc.TextTruncate = Enum.TextTruncate.AtEnd
    desc.Text = opt.desc or ""

    local box = Instance.new("TextBox")
    box.AnchorPoint = Vector2.new(1, 0.5)
    box.Position = UDim2.new(1, -12, 0.5, 0)
    box.Size = UDim2.fromOffset(128, 32)
    box.BackgroundColor3 = SURFACE_2
    box.BackgroundTransparency = 0.15
    box.BorderSizePixel = 0
    box.Font = Enum.Font.GothamBold
    box.TextSize = 11
    box.TextColor3 = LILAC
    box.PlaceholderText = opt.placeholder or ""
    box.PlaceholderColor3 = DIM
    box.Text = opt.value or ""
    box.ClearTextOnFocus = false
    box.Parent = row
    corner(box, 10)
    pad(box, 10, 10)

    focusRing(box, outline(box, STROKE, 1, 0), row)

    box.FocusLost:Connect(function()
        if opt.callback then pcall(opt.callback, box.Text) end
    end)

    return {
        Set = function(_, value) box.Text = value end,
        Get = function() return box.Text end,
    }
end

-- pages -------------------------------------------------------------------
local LogsPage     = newTab("Logs", 1)
local FiltersPage  = newTab("Filters", 2)
local ActionsPage  = newTab("Actions", 3)
local SettingsPage = newTab("Settings", 4)

local function setStatus(state, value)
    local color = COLORS[state] or COLORS.down
    local text = string.upper(value or state)
    if PillText.Text == text and PillDot.BackgroundColor3 == color then return end

    pcall(function()
        PillText.Text = text
        tween(PillText, 0.3, { TextColor3 = color })
        tween(PillDot, 0.3, { BackgroundColor3 = color })
        PillPulse.BackgroundColor3 = color
    end)
end

-- logs --------------------------------------------------------------------
UI.section(LogsPage, "overview")

local Stats = { lastTop = nil }
do
    local strip = frame(LogsPage, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -2, 0, 62),
        LayoutOrder = nextOrder(),
    })

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = strip

    local TILES = {
        { key = "hits",  caption = "HITS" },
        { key = "best",  caption = "BEST / S" },
        { key = "shown", caption = "SHOWING" },
    }

    for index, spec in ipairs(TILES) do
        local tile = frame(strip, {
            LayoutOrder = index,
            Size = UDim2.new(1 / 3, -6, 1, 0),
            BackgroundColor3 = CARD,
            BackgroundTransparency = GLASS,
        })
        corner(tile, 13)
        gradient(outline(tile, WHITE, 1, 0), ColorSequence.new(Color3.fromRGB(98, 86, 138), STROKE), 90)

        local caption = label(tile, 9, true, DIM)
        caption.Position = UDim2.fromOffset(12, 10)
        caption.Size = UDim2.new(1, -24, 0, 12)
        caption.Text = spec.caption

        local value = label(tile, 20, "black", WHITE)
        value.Position = UDim2.fromOffset(12, 25)
        value.Size = UDim2.new(1, -24, 0, 26)
        value.TextTruncate = Enum.TextTruncate.AtEnd
        value.Text = (spec.key == "best") and "—" or "0"
        table.insert(Fx.shines, gradient(value, SHINE_GRADIENT, 0))

        Stats[spec.key] = value
    end
end

UI.section(LogsPage, "secrets & ogs")

local emptyEntry = UI.entry(LogsPage)
emptyEntry:Set({ Title = "listening for hits…", Text = "demo hits will show up here" })

do
    -- scanning shimmer inside the empty state
    local scan = frame(emptyEntry.frame, {
        Position = UDim2.new(0, 22, 1, -7),
        Size = UDim2.new(1, -44, 0, 2),
    })
    round(scan)
    local scanGradient = gradient(scan, ACCENT_GRADIENT, 0, fade({
        { 0, 1 }, { 0.4, 1 }, { 0.5, 0.1 }, { 0.6, 1 }, { 1, 1 },
    }))

    animate(function(t)
        if not scan.Parent then return true end
        if emptyEntry.frame.Visible and Window.Visible then
            scanGradient.Offset = Vector2.new(((t * 0.6) % 2) - 1, 0)
        end
    end)
end

local function ensureSlot(index)
    local slot = State.slots[index]
    if slot then return slot end
    slot = UI.entry(LogsPage)
    State.slots[index] = slot
    return slot
end

local function render()
    local count = math.min(#State.lines, Settings.maxLines)

    for index = 1, count do
        local line = State.lines[index]
        local slot = ensureSlot(index)
        slot.frame.Visible = true
        slot:Set({ Title = line.title, Text = line.text, Rarity = line.rarity })
    end

    for index = count + 1, #State.slots do
        State.slots[index].frame.Visible = false
    end

    emptyEntry.frame.Visible = (count == 0)

    local top = State.lines[1]
    if top and top ~= Stats.lastTop and State.slots[1] then
        State.slots[1].Flash()
        if Fx.pulse then Fx.pulse() end
        Toast.show(
            "new " .. string.lower(tostring(top.rarity or "hit")),
            top.title,
            (top.rarity == "Secret") and "S" or "OG"
        )
    end
    Stats.lastTop = top

    pcall(function()
        local best = (State.stats.best > 0) and abbreviate(State.stats.best) or "—"
        Stats.hits.Text = tostring(State.stats.hits)
        Stats.best.Text = best
        Stats.shown.Text = tostring(count)
        Side.hits.Text = tostring(State.stats.hits)
        Side.best.Text = (State.stats.best > 0) and ("best " .. best .. "/s") or "best —"
    end)
end

task.spawn(function()
    while State.alive do
        if State.dirty then
            State.dirty = false
            pcall(render)
        end
        task.wait(0.25)
    end
end)

-- filters -----------------------------------------------------------------
UI.section(FiltersPage, "global")

UI.input(FiltersPage, {
    name = "min gen",
    desc = "0 or any = no limit",
    placeholder = "1b · 250m · 0",
    value = (Settings.minMps > 0) and abbreviate(Settings.minMps) or "any",
    callback = function(text)
        Settings.minMps = parseLimit(text)
        saveSettings()
    end,
})

UI.section(FiltersPage, "brainrots")

local function entryOn(entry)
    return not (type(entry) == "table" and entry.on == false)
end

local function entryMutations(entry)
    local count = 0
    if type(entry) == "table" and type(entry.mut) == "table" then
        for _, value in pairs(entry.mut) do
            if num(value, 0) > 0 then count = count + 1 end
        end
    end
    return count
end

local BrainrotCard = card(FiltersPage, 336)

local Search = Instance.new("TextBox")
Search.Position = UDim2.fromOffset(12, 12)
Search.Size = UDim2.new(1, -24, 0, 32)
Search.BackgroundColor3 = SURFACE_2
Search.BackgroundTransparency = 0.15
Search.BorderSizePixel = 0
Search.Font = Enum.Font.GothamMedium
Search.TextSize = 11
Search.TextColor3 = INK
Search.TextXAlignment = Enum.TextXAlignment.Left
Search.PlaceholderText = "search brainrots…"
Search.PlaceholderColor3 = DIM
Search.Text = ""
Search.ClearTextOnFocus = false
Search.Parent = BrainrotCard
corner(Search, 10)
pad(Search, 12, 34)
focusRing(Search, outline(Search, STROKE, 1, 0))

do
    -- clear button inside the search box
    local clear = Instance.new("TextButton")
    clear.AnchorPoint = Vector2.new(1, 0.5)
    clear.Position = UDim2.new(1, -18, 0, 28)
    clear.Size = UDim2.fromOffset(20, 20)
    clear.BackgroundColor3 = MIST
    clear.BorderSizePixel = 0
    clear.AutoButtonColor = false
    clear.Font = Enum.Font.GothamBold
    clear.TextSize = 12
    clear.TextColor3 = LILAC
    clear.Text = "×"
    clear.Visible = false
    clear.ZIndex = 2
    clear.Parent = BrainrotCard
    round(clear)

    clear.MouseEnter:Connect(function() tween(clear, 0.15, { BackgroundColor3 = PURPLE, TextColor3 = WHITE }) end)
    clear.MouseLeave:Connect(function() tween(clear, 0.2, { BackgroundColor3 = MIST, TextColor3 = LILAC }) end)
    clear.MouseButton1Click:Connect(function() Search.Text = "" end)
    Search:GetPropertyChangedSignal("Text"):Connect(function()
        clear.Visible = Search.Text ~= ""
    end)
end

-- segmented all / on / off with a gliding pill
local ChipHolder = frame(BrainrotCard, {
    Position = UDim2.fromOffset(12, 52),
    Size = UDim2.fromOffset(170, 24),
    BackgroundColor3 = MIST,
    BackgroundTransparency = 0.15,
})
round(ChipHolder)

local ChipIndicator = frame(ChipHolder, {
    Position = UDim2.fromOffset(2, 2),
    Size = UDim2.fromOffset(54, 20),
})
round(ChipIndicator)
gradient(ChipIndicator, ACCENT_GRADIENT, 0)

Panel.mode       = "all"
Panel.query      = ""
Panel.rows       = {}
Panel.shown      = 0
Panel.editorName = nil

local chips = {}

local function paintChips()
    for key, chip in pairs(chips) do
        local active = (Panel.mode == key)
        tween(chip, 0.22, { TextColor3 = active and WHITE or DIM })
        if active then
            tween(ChipIndicator, 0.4, { Position = UDim2.fromOffset(chip.Position.X.Offset, 2) })
        end
    end
end

for index, key in ipairs({ "all", "on", "off" }) do
    local chip = Instance.new("TextButton")
    chip.Position = UDim2.fromOffset(2 + (index - 1) * 56, 2)
    chip.Size = UDim2.fromOffset(54, 20)
    chip.BackgroundTransparency = 1
    chip.BorderSizePixel = 0
    chip.AutoButtonColor = false
    chip.Font = Enum.Font.GothamBold
    chip.TextSize = 10
    chip.TextColor3 = DIM
    chip.Text = key
    chip.ZIndex = 2
    chip.Parent = ChipHolder

    chip.MouseButton1Click:Connect(function()
        Panel.mode = key
        paintChips()
        if Panel.rebuild then Panel.rebuild() end
    end)

    chips[key] = chip
end

local Bulk = frame(BrainrotCard, {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(12, 84),
    Size = UDim2.new(1, -24, 0, 24),
})

local function bulkButton(value, x, callback)
    local button = Instance.new("TextButton")
    button.Position = UDim2.fromOffset(x, 0)
    button.Size = UDim2.fromOffset(86, 24)
    button.BackgroundColor3 = SURFACE_2
    button.BackgroundTransparency = 0.2
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.ClipsDescendants = true
    button.Font = Enum.Font.GothamBold
    button.TextSize = 10
    button.TextColor3 = LILAC
    button.Text = value
    button.Parent = Bulk
    round(button)
    local stroke = outline(button, STROKE, 1, 0)

    button.MouseEnter:Connect(function()
        tween(button, 0.18, { BackgroundColor3 = PURPLE, BackgroundTransparency = 0, TextColor3 = WHITE })
        tween(stroke, 0.18, { Transparency = 1 })
    end)
    button.MouseLeave:Connect(function()
        tween(button, 0.25, { BackgroundColor3 = SURFACE_2, BackgroundTransparency = 0.2, TextColor3 = LILAC })
        tween(stroke, 0.25, { Transparency = 0 })
    end)
    button.MouseButton1Click:Connect(function()
        ripple(button, WHITE)
        callback()
    end)

    return button
end

do
    local bulkNote = label(Bulk, 9, false, DIM)
    bulkNote.Position = UDim2.fromOffset(186, 0)
    bulkNote.Size = UDim2.new(1, -186, 1, 0)
    bulkNote.TextXAlignment = Enum.TextXAlignment.Right
    bulkNote.TextTruncate = Enum.TextTruncate.AtEnd
    bulkNote.Text = "right click or ••• = edit"
end

local List = Instance.new("ScrollingFrame")
List.Position = UDim2.fromOffset(12, 116)
List.Size = UDim2.new(1, -24, 1, -144)
List.BackgroundTransparency = 1
List.BorderSizePixel = 0
List.CanvasSize = UDim2.new()
List.AutomaticCanvasSize = Enum.AutomaticSize.Y
List.ScrollBarThickness = 3
List.ScrollBarImageColor3 = PURPLE
List.ScrollBarImageTransparency = 0.45
List.ScrollingDirection = Enum.ScrollingDirection.Y
List.Parent = BrainrotCard

do
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = List
    pad(List, 1, 0, 1, 2)
end

local Hint = label(BrainrotCard, 9, false, DIM)
Hint.Position = UDim2.new(0, 14, 1, -20)
Hint.Size = UDim2.new(1, -28, 0, 12)
Hint.Text = ""

Panel.list = List
Panel.hint = Hint

local function createRow(slot)
    local row = frame(List, {
        Size = UDim2.new(1, -6, 0, 32),
        BackgroundColor3 = SURFACE_2,
        BackgroundTransparency = 0.2,
        LayoutOrder = slot,
        Active = true,
    })
    corner(row, 10)
    local stroke = outline(row, STROKE, 1, 0)

    local nameLabel = label(row, 11, false, INK)
    nameLabel.Position = UDim2.fromOffset(12, 0)
    nameLabel.Size = UDim2.new(1, -170, 1, 0)
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Active = true

    local amount = label(row, 9, true, LILAC)
    amount.AnchorPoint = Vector2.new(1, 0)
    amount.Position = UDim2.new(1, -84, 0, 0)
    amount.Size = UDim2.fromOffset(72, 32)
    amount.TextXAlignment = Enum.TextXAlignment.Right
    amount.Active = true

    -- mini switch
    local switch = Instance.new("TextButton")
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.Position = UDim2.new(1, -40, 0.5, 0)
    switch.Size = UDim2.fromOffset(36, 20)
    switch.BackgroundColor3 = MIST
    switch.BorderSizePixel = 0
    switch.AutoButtonColor = false
    switch.Text = ""
    switch.Parent = row
    round(switch)

    local fill = frame(switch, { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })
    round(fill)
    gradient(fill, ACCENT_GRADIENT, 0)

    local knob = frame(switch, {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 3, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        ZIndex = 2,
    })
    round(knob)
    outline(knob, STROKE, 1, 0.2)

    local edit = Instance.new("TextButton")
    edit.AnchorPoint = Vector2.new(1, 0.5)
    edit.Position = UDim2.new(1, -8, 0.5, 0)
    edit.Size = UDim2.fromOffset(26, 22)
    edit.BackgroundColor3 = PURPLE
    edit.BackgroundTransparency = 1
    edit.BorderSizePixel = 0
    edit.AutoButtonColor = false
    edit.Font = Enum.Font.GothamBold
    edit.TextSize = 10
    edit.TextColor3 = LILAC
    edit.Text = "•••"
    edit.Parent = row
    round(edit)

    local cell = { name = nil }

    local function paint(animated)
        if not cell.name then return end

        local entry = Settings.overrides[cell.name]
        local on = entryOn(entry)
        local minimum = (type(entry) == "table") and num(entry.min, 0) or 0
        local mutations = entryMutations(entry)
        local knobPosition = on and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)

        if animated then
            tween(fill, 0.25, { BackgroundTransparency = on and 0 or 1 })
            tween(knob, 0.35, { Position = knobPosition }, Enum.EasingStyle.Back)
            tween(nameLabel, 0.25, { TextColor3 = on and INK or DIM })
        else
            fill.BackgroundTransparency = on and 0 or 1
            knob.Position = knobPosition
            nameLabel.TextColor3 = on and INK or DIM
        end

        local text = (minimum > 0) and abbreviate(minimum) or ""
        if mutations > 0 then
            text = (text ~= "") and (text .. " +" .. mutations) or ("+" .. mutations)
        end
        amount.Text = text
    end

    row.MouseEnter:Connect(function()
        tween(row, 0.15, { BackgroundTransparency = 0.02, BackgroundColor3 = SURFACE_3 })
        tween(stroke, 0.15, { Color = LILAC })
        tween(edit, 0.15, { TextColor3 = PURPLE })
    end)
    row.MouseLeave:Connect(function()
        tween(row, 0.25, { BackgroundTransparency = 0.2, BackgroundColor3 = SURFACE_2 })
        tween(stroke, 0.25, { Color = STROKE })
        tween(edit, 0.25, { TextColor3 = LILAC })
    end)

    edit.MouseEnter:Connect(function() tween(edit, 0.15, { BackgroundTransparency = 0.85 }) end)
    edit.MouseLeave:Connect(function() tween(edit, 0.2, { BackgroundTransparency = 1 }) end)
    edit.MouseButton1Click:Connect(function()
        if cell.name and Panel.openEditor then Panel.openEditor(cell.name) end
    end)

    switch.MouseButton1Click:Connect(function()
        if not cell.name then return end
        local entry = entryFor(cell.name, true)
        entry.on = not entryOn(entry)
        saveSettings()
        paint(true)
        if Panel.refreshHint then Panel.refreshHint() end
    end)

    local function bindRightClick(target)
        target.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 and cell.name then
                if Panel.openEditor then Panel.openEditor(cell.name) end
            end
        end)
    end

    bindRightClick(row)
    bindRightClick(nameLabel)
    bindRightClick(amount)
    bindRightClick(switch)

    return {
        frame = row,
        set = function(name)
            cell.name = name
            nameLabel.Text = name
            paint(false)
        end,
    }
end

-- per-brainrot editor overlay ---------------------------------------------
local Editor = frame(BrainrotCard, {
    Position = UDim2.fromOffset(8, 8),
    Size = UDim2.new(1, -16, 1, -16),
    BackgroundColor3 = SURFACE_2,
    BackgroundTransparency = 0.02,
    Visible = false,
    Active = true,
    ZIndex = 5,
})
corner(Editor, 12)
outline(Editor, PURPLE, 1, 0.55)

local EditorScale = Instance.new("UIScale")
EditorScale.Parent = Editor

local editorTitle = nil
do
    local bar = frame(Editor, { Size = UDim2.new(1, 0, 0, 34) })
    corner(bar, 12)
    gradient(bar, ACCENT_GRADIENT, 0)

    -- square off the bottom of the rounded bar
    local barBase = frame(bar, { Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0.5, 0) })
    gradient(barBase, ACCENT_GRADIENT, 0)

    local gloss = frame(bar, { Size = UDim2.new(1, 0, 0.5, 0), BackgroundTransparency = 0.85, ZIndex = 2 })
    corner(gloss, 12)

    editorTitle = label(bar, 11, true, WHITE)
    editorTitle.Position = UDim2.fromOffset(14, 0)
    editorTitle.Size = UDim2.new(1, -48, 1, 0)
    editorTitle.TextTruncate = Enum.TextTruncate.AtEnd
    editorTitle.ZIndex = 3
end

local function closeEditor()
    tween(EditorScale, 0.14, { Scale = 0.95 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    task.delay(0.14, function() Editor.Visible = false end)
end

do
    local close = Instance.new("TextButton")
    close.AnchorPoint = Vector2.new(1, 0.5)
    close.Position = UDim2.new(1, -10, 0, 17)
    close.Size = UDim2.fromOffset(22, 22)
    close.BackgroundColor3 = WHITE
    close.BackgroundTransparency = 0.8
    close.BorderSizePixel = 0
    close.AutoButtonColor = false
    close.Font = Enum.Font.GothamBold
    close.TextSize = 13
    close.TextColor3 = WHITE
    close.Text = "×"
    close.ZIndex = 4
    close.Parent = Editor
    round(close)

    close.MouseEnter:Connect(function() tween(close, 0.15, { BackgroundTransparency = 0.55 }) end)
    close.MouseLeave:Connect(function() tween(close, 0.2, { BackgroundTransparency = 0.8 }) end)
    close.MouseButton1Click:Connect(closeEditor)

    local baseLabel = label(Editor, 11, true, INK)
    baseLabel.Position = UDim2.fromOffset(14, 44)
    baseLabel.Size = UDim2.new(1, -110, 0, 26)
    baseLabel.Text = "min gen"

    local baseHint = label(Editor, 9, false, DIM)
    baseHint.Position = UDim2.fromOffset(68, 44)
    baseHint.Size = UDim2.new(1, -170, 0, 26)
    baseHint.Text = "0 = any"

    local mutationLabel = label(Editor, 9, true, LILAC)
    mutationLabel.Position = UDim2.fromOffset(14, 78)
    mutationLabel.Size = UDim2.new(1, -28, 0, 12)
    mutationLabel.Text = "BY MUTATION"
end

local function makeBox(parent, height)
    local box = Instance.new("TextBox")
    box.Size = UDim2.fromOffset(76, height or 26)
    box.BackgroundColor3 = SURFACE_2
    box.BackgroundTransparency = 0.15
    box.BorderSizePixel = 0
    box.Font = Enum.Font.GothamBold
    box.TextSize = 10
    box.TextColor3 = LILAC
    box.Text = "any"
    box.ClearTextOnFocus = false
    box.Parent = parent
    corner(box, 8)
    pad(box, 8, 8)
    focusRing(box, outline(box, STROKE, 1, 0))
    return box
end

local baseBox = makeBox(Editor)
baseBox.AnchorPoint = Vector2.new(1, 0)
baseBox.Position = UDim2.new(1, -12, 0, 44)

local MutationList = Instance.new("ScrollingFrame")
MutationList.Position = UDim2.fromOffset(8, 96)
MutationList.Size = UDim2.new(1, -16, 1, -138)
MutationList.BackgroundTransparency = 1
MutationList.BorderSizePixel = 0
MutationList.CanvasSize = UDim2.new()
MutationList.AutomaticCanvasSize = Enum.AutomaticSize.Y
MutationList.ScrollBarThickness = 3
MutationList.ScrollBarImageColor3 = PURPLE
MutationList.ScrollBarImageTransparency = 0.45
MutationList.ScrollingDirection = Enum.ScrollingDirection.Y
MutationList.Parent = Editor

do
    local mutationLayout = Instance.new("UIListLayout")
    mutationLayout.Padding = UDim.new(0, 4)
    mutationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    mutationLayout.Parent = MutationList
    pad(MutationList, 1, 0, 1, 2)
end

local mutationRows = {}

for index, info in ipairs(MUTATIONS) do
    local row = frame(MutationList, {
        Size = UDim2.new(1, -6, 0, 28),
        BackgroundColor3 = SURFACE_3,
        LayoutOrder = index,
    })
    corner(row, 9)
    local stroke = outline(row, STROKE, 1, 0.4)

    local dot = frame(row, {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.fromOffset(5, 5),
        BackgroundColor3 = LILAC,
    })
    round(dot)

    local nameLabel = label(row, 10, false, INK)
    nameLabel.Position = UDim2.fromOffset(22, 0)
    nameLabel.Size = UDim2.new(1, -110, 1, 0)
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.RichText = true
    nameLabel.Text = string.format('%s  <font color="#8A82AA">×%s</font>', info.name, tostring(info.multi))

    local box = makeBox(row, 22)
    box.AnchorPoint = Vector2.new(1, 0.5)
    box.Position = UDim2.new(1, -4, 0.5, 0)
    box.Size = UDim2.fromOffset(70, 22)

    row.MouseEnter:Connect(function()
        tween(row, 0.15, { BackgroundColor3 = Color3.fromRGB(58, 52, 82) })
        tween(stroke, 0.15, { Color = LILAC })
    end)
    row.MouseLeave:Connect(function()
        tween(row, 0.2, { BackgroundColor3 = SURFACE_3 })
        tween(stroke, 0.2, { Color = STROKE })
    end)

    box.FocusLost:Connect(function()
        if not Panel.editorName then return end
        local entry = entryFor(Panel.editorName, true)
        local value = parseLimit(box.Text)
        if value > 0 then
            entry.mut[info.name] = value
            box.Text = abbreviate(value)
        else
            entry.mut[info.name] = nil
            box.Text = "any"
        end
        tween(dot, 0.25, { BackgroundColor3 = (value > 0) and PURPLE or LILAC })
        saveSettings()
        if Panel.rebuild then Panel.rebuild() end
    end)

    mutationRows[#mutationRows + 1] = { mutation = info.name, box = box, dot = dot }
end

do
    local resetButton = Instance.new("TextButton")
    resetButton.AnchorPoint = Vector2.new(0, 1)
    resetButton.Position = UDim2.new(0, 12, 1, -10)
    resetButton.Size = UDim2.fromOffset(84, 24)
    resetButton.BackgroundColor3 = SURFACE_3
    resetButton.BorderSizePixel = 0
    resetButton.AutoButtonColor = false
    resetButton.ClipsDescendants = true
    resetButton.Font = Enum.Font.GothamBold
    resetButton.TextSize = 10
    resetButton.TextColor3 = LILAC
    resetButton.Text = "reset all"
    resetButton.Parent = Editor
    round(resetButton)
    local stroke = outline(resetButton, STROKE, 1, 0)

    resetButton.MouseEnter:Connect(function()
        tween(resetButton, 0.18, { BackgroundColor3 = PURPLE, TextColor3 = WHITE })
        tween(stroke, 0.18, { Transparency = 1 })
    end)
    resetButton.MouseLeave:Connect(function()
        tween(resetButton, 0.25, { BackgroundColor3 = SURFACE_3, TextColor3 = LILAC })
        tween(stroke, 0.25, { Transparency = 0 })
    end)

    resetButton.MouseButton1Click:Connect(function()
        ripple(resetButton, WHITE)
        if Panel.editorName then Settings.overrides[Panel.editorName] = nil end
        saveSettings()
        if Panel.rebuild then Panel.rebuild() end
        if Panel.editorName and Panel.openEditor then Panel.openEditor(Panel.editorName) end
    end)
end

baseBox.FocusLost:Connect(function()
    if not Panel.editorName then return end
    local entry = entryFor(Panel.editorName, true)
    entry.min = parseLimit(baseBox.Text)
    baseBox.Text = (entry.min > 0) and abbreviate(entry.min) or "any"
    saveSettings()
    if Panel.rebuild then Panel.rebuild() end
end)

function Panel.openEditor(name)
    if type(name) ~= "string" or #name == 0 then return end

    Panel.editorName = name
    local entry = entryFor(name, true)

    editorTitle.Text = name
    baseBox.Text = (num(entry.min, 0) > 0) and abbreviate(entry.min) or "any"

    for _, row in ipairs(mutationRows) do
        local value = num(entry.mut[row.mutation], 0)
        row.box.Text = (value > 0) and abbreviate(value) or "any"
        row.dot.BackgroundColor3 = (value > 0) and PURPLE or LILAC
    end

    if not Editor.Visible then
        EditorScale.Scale = 0.92
        Editor.Visible = true
        tween(EditorScale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
    end
end

function Panel.refreshHint()
    local on, total = 0, #State.brainrots
    for _, name in ipairs(State.brainrots) do
        if entryOn(Settings.overrides[name]) then on = on + 1 end
    end

    pcall(function()
        Hint.Text = string.format("%d shown  ·  %d / %d on", Panel.shown or 0, on, total)
    end)
end

local function eachShown(fn)
    local needle = tostring(Panel.query or ""):lower()

    for _, name in ipairs(State.brainrots) do
        local on = entryOn(Settings.overrides[name])
        local visible = Panel.mode == "all"
            or (Panel.mode == "on" and on)
            or (Panel.mode == "off" and not on)

        if visible and (needle == "" or name:lower():find(needle, 1, true)) then
            fn(name)
        end
    end
end

bulkButton("enable all", 0, function()
    eachShown(function(name) entryFor(name, true).on = true end)
    saveSettings()
    Panel.rebuild()
end)

bulkButton("disable all", 92, function()
    eachShown(function(name) entryFor(name, true).on = false end)
    saveSettings()
    Panel.rebuild()
end)

function Panel.rebuild()
    if not List then return end

    local shown = 0

    eachShown(function(name)
        shown = shown + 1

        local row = Panel.rows[shown]
        if not row then
            row = createRow(shown)
            Panel.rows[shown] = row
        end

        row.frame.Visible = true
        row.set(name)
    end)

    for index = shown + 1, #Panel.rows do
        Panel.rows[index].frame.Visible = false
    end

    Panel.shown = shown
    Panel.refreshHint()
end

Search:GetPropertyChangedSignal("Text"):Connect(function()
    Panel.query = Search.Text
    Panel.rebuild()
end)

paintChips()

-- actions -----------------------------------------------------------------
UI.section(ActionsPage, "feed")

UI.button(ActionsPage, {
    name = "clear feed",
    desc = "wipe the log lines and hit counter",
    callback = function()
        State.lines = {}
        State.seen = {}
        State.stats = { hits = 0, best = 0 }
        State.dirty = true
    end,
})

UI.section(ActionsPage, "demo")

UI.button(ActionsPage, {
    name = "demo hit",
    desc = "push one random sample hit through the filter",
    callback = function()
        Feed.push(Feed.demo())
    end,
})

UI.button(ActionsPage, {
    name = "burst",
    desc = "push eight sample hits in quick succession",
    callback = function()
        task.spawn(function()
            for _ = 1, 8 do
                if not State.alive then return end
                Feed.push(Feed.demo())
                task.wait(0.18)
            end
        end)
    end,
})

UI.section(ActionsPage, "settings")

UI.button(ActionsPage, {
    name = "clear overrides",
    desc = "forget every on/off and min gen",
    callback = function()
        Settings.overrides = {}
        saveSettings()
        if Panel.rebuild then Panel.rebuild() end
    end,
})

UI.button(ActionsPage, {
    name = "save settings",
    desc = "write " .. SETTINGS_FILE .. " now",
    callback = function() writeSettings() end,
})

-- settings ----------------------------------------------------------------
UI.section(SettingsPage, "demo feed")

UI.toggle(SettingsPage, {
    name = "auto demo hits",
    desc = "generate sample hits on a timer",
    value = Settings.demo,
    callback = function(on)
        Settings.demo = on
        saveSettings()
    end,
})

UI.slider(SettingsPage, {
    name = "demo interval",
    min = 0.5,
    max = 5,
    increment = 0.5,
    value = Settings.demoRate,
    format = function(value) return string.format("%.1fs", value) end,
    callback = function(value)
        Settings.demoRate = math.clamp(num(value, 2.0), 0.5, 5)
        saveSettings()
    end,
})

UI.section(SettingsPage, "feed")

UI.slider(SettingsPage, {
    name = "entries",
    min = 5,
    max = 80,
    increment = 5,
    value = Settings.maxLines,
    format = function(value) return string.format("%d lines", value) end,
    callback = function(value)
        Settings.maxLines = math.floor(num(value, 25))
        saveSettings()
        State.dirty = true
    end,
})

UI.section(SettingsPage, "visuals")

UI.toggle(SettingsPage, {
    name = "fluid motion",
    desc = "animated backdrop, glow and shimmer",
    value = Fx.enabled,
    callback = function(on)
        Fx.enabled = on
        Settings.fx = on
        saveSettings()
    end,
})

UI.label(SettingsPage, "RightShift shows / hides the window", true)

-- window controls ---------------------------------------------------------
local UIState = { shown = true, minimized = false, width = WIDTH, height = HEIGHT }

-- drag with a smoothed follow so the window glides behind the cursor
local Drag = { active = false, start = nil, origin = nil, target = nil }

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        Drag.active = true
        Drag.start = input.Position
        Drag.origin = Drag.target or Window.Position
        Drag.target = Drag.origin

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Drag.active = false
            end
        end)
    end
end)

bind(UserInputService.InputChanged, function(input)
    if not Drag.active or not Drag.start or not Drag.origin then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - Drag.start
        Drag.target = UDim2.new(
            Drag.origin.X.Scale, Drag.origin.X.Offset + delta.X,
            Drag.origin.Y.Scale, Drag.origin.Y.Offset + delta.Y
        )
    end
end)

animate(function(_, dt)
    if not Drag.target then return end
    local current = Window.Position
    Window.Position = current:Lerp(Drag.target, math.min(1, dt * 20))

    if not Drag.active
        and math.abs(Window.Position.X.Offset - Drag.target.X.Offset) < 0.5
        and math.abs(Window.Position.Y.Offset - Drag.target.Y.Offset) < 0.5 then
        Window.Position = Drag.target
        Drag.target = nil
    end
end)

-- glow follows the window, breathing gently
animate(function(t)
    Glow.Visible = Window.Visible
    if not Window.Visible then return end

    local scale = WindowScale.Scale
    Glow.Position = Window.Position
    Glow.Size = UDim2.fromOffset(Window.Size.X.Offset * scale, Window.Size.Y.Offset * scale)

    local pulse = Fx.enabled and math.sin(t * 1.6) * 0.012 or 0
    for index, layer in ipairs(GlowLayers) do
        layer.BackgroundTransparency = 0.935 + index * 0.008 - pulse - Fx.energy * 0.02
    end
end)

-- every gradient-text shine slides together
animate(function(t)
    if not Window.Visible or not Fx.enabled then return end
    local offset = ((t * 0.32) % 2.6) - 1.3
    for _, shine in ipairs(Fx.shines) do
        shine.Offset = Vector2.new(offset, 0)
    end
end)

-- resize grip in the bottom-right corner (top-left edge stays put)
local Grip = Instance.new("TextButton")
Grip.AnchorPoint = Vector2.new(1, 1)
Grip.Position = UDim2.new(1, -5, 1, -5)
Grip.Size = UDim2.fromOffset(18, 18)
Grip.BackgroundTransparency = 1
Grip.AutoButtonColor = false
Grip.Text = ""
Grip.ZIndex = 8
Grip.Parent = Window

do
    local dots = {}
    for index, spot in ipairs({ { 14, 14 }, { 9, 14 }, { 14, 9 }, { 4, 14 }, { 9, 9 }, { 14, 4 } }) do
        local dot = frame(Grip, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(spot[1], spot[2]),
            Size = UDim2.fromOffset(3, 3),
            BackgroundColor3 = LILAC,
        })
        round(dot)
        dots[index] = dot
    end

    local function paintDots(color)
        for _, dot in ipairs(dots) do tween(dot, 0.18, { BackgroundColor3 = color }) end
    end

    local Resize = { active = false }

    Grip.MouseEnter:Connect(function() paintDots(PURPLE) end)
    Grip.MouseLeave:Connect(function() if not Resize.active then paintDots(LILAC) end end)

    Grip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            Resize.active = true
            Resize.start = input.Position
            Resize.size = Vector2.new(Window.Size.X.Offset, Window.Size.Y.Offset)
            Resize.origin = Drag.target or Window.Position
            Drag.target = nil
            Window.Position = Resize.origin
        end
    end)

    bind(UserInputService.InputChanged, function(input)
        if not Resize.active then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - Resize.start
            local width = math.clamp(Resize.size.X + delta.X, 520, 980)
            local height = math.clamp(Resize.size.Y + delta.Y, 400, 760)

            Window.Size = UDim2.fromOffset(width, height)
            Window.Position = UDim2.new(
                Resize.origin.X.Scale, Resize.origin.X.Offset + (width - Resize.size.X) / 2,
                Resize.origin.Y.Scale, Resize.origin.Y.Offset + (height - Resize.size.Y) / 2
            )
            UIState.width, UIState.height = width, height
        end
    end)

    bind(UserInputService.InputEnded, function(input)
        if not Resize.active then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            Resize.active = false
            paintDots(LILAC)
        end
    end)
end

local function setMinimized(state)
    UIState.minimized = state
    if state then
        Sidebar.Visible = false
        Content.Visible = false
        Grip.Visible = false
        tween(Window, 0.4, { Size = UDim2.fromOffset(UIState.width, 66) })
    else
        tween(Window, 0.45, { Size = UDim2.fromOffset(UIState.width, UIState.height) })
        task.delay(0.12, function()
            if not UIState.minimized then
                Sidebar.Visible = true
                Content.Visible = true
                Grip.Visible = true
            end
        end)
    end
end

-- floating bubble shown while the window is closed
local Reopen = Instance.new("TextButton")
Reopen.AnchorPoint = Vector2.new(0.5, 0.5)
Reopen.Position = UDim2.fromOffset(42, 42)
Reopen.Size = UDim2.fromOffset(46, 46)
Reopen.BackgroundColor3 = WHITE
Reopen.BorderSizePixel = 0
Reopen.AutoButtonColor = false
Reopen.Font = Enum.Font.GothamBlack
Reopen.TextSize = 19
Reopen.TextColor3 = WHITE
Reopen.Text = "S"
Reopen.Visible = false
Reopen.ZIndex = 3
Reopen.Parent = Screen
round(Reopen)
outline(Reopen, WHITE, 1.5, 0.3)

do
    local reopenGradient = gradient(Reopen, ACCENT_GRADIENT, 45)
    local reopenScale = Instance.new("UIScale")
    reopenScale.Parent = Reopen

    local halo = softOrb(Screen, PURPLE, 96, 0.3)
    halo.Position = Reopen.Position
    halo.ZIndex = 2
    halo.Visible = false

    UIState.reopenScale = reopenScale

    Reopen.MouseEnter:Connect(function() tween(reopenScale, 0.3, { Scale = 1.1 }, Enum.EasingStyle.Back) end)
    Reopen.MouseLeave:Connect(function() tween(reopenScale, 0.25, { Scale = 1 }) end)

    animate(function(t)
        halo.Visible = Reopen.Visible
        if not Reopen.Visible then return end
        reopenGradient.Rotation = (t * 60) % 360
        local size = 92 + math.sin(t * 2.4) * 10
        halo.Size = UDim2.fromOffset(size, size)
    end)
end

local function showWindow(visible)
    UIState.shown = visible

    if visible then
        Reopen.Visible = false
        Window.Visible = true
        WindowScale.Scale = 0.9
        tween(WindowScale, 0.5, { Scale = 1 }, Enum.EasingStyle.Back)
    else
        tween(WindowScale, 0.18, { Scale = 0.9 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.18, function()
            if UIState.shown then return end
            Window.Visible = false
            Reopen.Visible = true
            UIState.reopenScale.Scale = 0.4
            tween(UIState.reopenScale, 0.45, { Scale = 1 }, Enum.EasingStyle.Back)
        end)
    end
end

headerButton("×", -16, function()
    showWindow(false)
end)

headerButton("–", -48, function()
    setMinimized(not UIState.minimized)
end)

Reopen.MouseButton1Click:Connect(function()
    showWindow(true)
end)

bind(UserInputService.InputBegan, function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        showWindow(not UIState.shown)
    end
end)

-- single frame driver for every animation
bind(RunService.Heartbeat, function(dt)
    Fx.clock = Fx.clock + dt
    local t = Fx.clock
    for index = #Fx.animators, 1, -1 do
        local ok, done = pcall(Fx.animators[index], t, dt)
        if not ok or done then table.remove(Fx.animators, index) end
    end
end)

activate("Logs")
setStatus("middle", "starting")
showWindow(true)
--==============================================================================
-- 06 · demo feed
--==============================================================================

function Feed.push(record)
    if type(record) ~= "table" or not record.id then return end
    if State.seen[record.id] then return end
    State.seen[record.id] = true

    State.seq = State.seq + 1
    State.stats.hits = State.stats.hits + 1
    if record.mps > State.stats.best then State.stats.best = record.mps end

    if not passes(record) then
        State.dirty = true
        return
    end

    local rank = record.rank and ("#" .. tostring(record.rank)) or ""
    table.insert(State.lines, 1, {
        title = string.format("%s · %s/s", record.name, abbreviate(record.mps)),
        text = string.format("%s%s · %s", (rank ~= "") and (rank .. " · ") or "",
            (record.mutation ~= "" and record.mutation ~= "Default") and record.mutation or "base",
            os.date("%H:%M:%S")),
        rarity = record.rarity,
    })

    while #State.lines > Settings.maxLines do
        State.lines[#State.lines] = nil
    end

    State.dirty = true
end

-- local generator: pushes a random sample hit every few seconds
function Feed.start()
    task.spawn(function()
        while State.alive do
            if Settings.demo then
                setStatus("up", "demo feed")
                Feed.push(Feed.demo())
            else
                setStatus("middle", "paused")
            end
            task.wait(Settings.demoRate * (0.6 + math.random() * 0.8))
        end
    end)
end

--==============================================================================
-- 07 · boot
--==============================================================================

task.spawn(function()
    loadBrainrots()
    if Panel.rebuild then Panel.rebuild() end
    State.dirty = true
    Feed.start()
end)

--==============================================================================
-- 08 · controller
--==============================================================================

local Controller = {
    state = State,
    settings = Settings,
    push = function(record) Feed.push(normalise(record)) end,
    save = writeSettings,
    destroy = function()
        State.alive = false
        pcall(writeSettings)
        for _, connection in ipairs(Fx.connections) do
            pcall(function() connection:Disconnect() end)
        end
        Fx.connections = {}
        Fx.animators = {}
        pcall(function() Gui:Destroy() end)
        _G.SkyroUI = nil
    end,
}

_G.SkyroUI = Controller
return Controller