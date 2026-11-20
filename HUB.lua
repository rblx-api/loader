-- ============================================================
-- FAST LOADER (ported from Elysium Hub)
--  1. early optimizer: starts before game.Loaded / data init.  Mode "aa" (Elysium's
--     default) leaves the map alone; "default" = shadows off (+ materials pass if
--     OPTIMIZER_MATERIALS = true). Mode is read from the config file key "optimizerMode".
--  2. waits for game.Loaded
--  3. streaming: asks the server to stream in every plot right away
--  4. fps cap 9999 after 1.5s
--  5. boot wait: auto-TP waits (0.3s min, 6s max) until your carpet/grapple is in the backpack
-- ============================================================
local OPTIMIZER_MODE      = nil     -- nil = use the saved config / "aa"; or force "aa" / "default"
local OPTIMIZER_MATERIALS = false   -- Elysium's materials pass (opt-in: touches every part)
do
    local env = type(getgenv) == "function" and getgenv() or _G
    local prior = env.EclipseEarlyOptimizer
    if not prior or prior.game ~= game or prior.world ~= workspace then
        local api = { game = game, world = workspace, mode = "aa", saved = setmetatable({}, { __mode = "k" }) }
        env.EclipseEarlyOptimizer, _G.EclipseEarlyOptimizer = api, api
        local function set(object, property, value)
            local values = api.saved[object]
            if not values then values = {} api.saved[object] = values end
            if values[property] == nil then values[property] = { object[property] } end
            object[property] = value
        end
        local function characterPart(object)
            local node = object
            while node and node ~= workspace do
                if node:IsA("Tool") or node:FindFirstChildOfClass("Humanoid") then return true end
                node = node.Parent
            end
            return false
        end
        local function materialsOn()
            return OPTIMIZER_MATERIALS == true or env.EclipseOptimizerMaterials == true
        end
        local function applyObject(object)
            if api.mode ~= "default" or not materialsOn() then return end
            if object:IsA("BasePart") and not characterPart(object) then
                set(object, "CastShadow", false)
                set(object, "Reflectance", 0)
                set(object, "Material", Enum.Material.SmoothPlastic)
            elseif object:IsA("Decal") or object:IsA("Texture") then
                if not characterPart(object) then set(object, "Transparency", 1) end
            elseif object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam") then
                if not characterPart(object) then set(object, "Enabled", false) end
            end
        end
        function api.Apply(mode)
            api.mode = mode == "default" and "default" or "aa"
            local pass = (api.pass or 0) + 1
            api.pass = pass
            local canYield = coroutine.isyieldable() and api.started == true
            local budget = 0
            local function tick()
                if not canYield then return true end
                budget = budget + 1
                if budget >= 2500 then
                    budget = 0
                    task.wait()
                    if api.pass ~= pass then return false end
                end
                return true
            end
            if api.mode == "default" then
                set(game:GetService("Lighting"), "GlobalShadows", false)
                if materialsOn() then
                    for _, object in ipairs(workspace:GetDescendants()) do
                        pcall(applyObject, object)
                        if not tick() then return end
                    end
                end
            else
                for object, values in pairs(api.saved) do
                    for property, value in pairs(values) do pcall(function() object[property] = value[1] end) end
                    if not tick() then return end
                end
            end
            api.started = true
        end
        workspace.DescendantAdded:Connect(function(object) pcall(applyObject, object) end)
        local mode = OPTIMIZER_MODE or "aa"
        if not OPTIMIZER_MODE and type(readfile) == "function" then
            local ok, cfg = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile("TPToBestByOwnyx.json"))
            end)
            if ok and type(cfg) == "table" and cfg.optimizerMode then mode = cfg.optimizerMode end
        end
        api.Apply(mode)
    end
end

if not game:IsLoaded() then game.Loaded:Wait() end

-- fps cap (Elysium: 1.5s after load)
task.spawn(function()
    task.wait(1.5)
    pcall(function() if setfpscap then setfpscap(9999) end end)
end)

-- streaming: request every plot as soon as Plots exists
task.spawn(function()
    local ws = game:GetService("Workspace")
    if not ws.StreamingEnabled then return end
    local hb = game:GetService("RunService")
    local me = game:GetService("Players").LocalPlayer
    local area, limit = nil, os.clock() + 15
    repeat
        area = ws:FindFirstChild("Plots")
        if not area then hb.Heartbeat:Wait() end
    until area or os.clock() > limit
    if not area then return end
    local function pivotOf(plot)
        local ok, pv = pcall(function() return plot:GetPivot().Position end)
        if ok and pv and pv.Magnitude > 1 then return pv end
        if plot.PrimaryPart then return plot.PrimaryPart.Position end
        local bp = plot:FindFirstChildWhichIsA("BasePart", true)
        return bp and bp.Position or nil
    end
    for _, plot in ipairs(area:GetChildren()) do
        local where = pivotOf(plot)
        if where then
            task.spawn(function() pcall(function() me:RequestStreamAroundAsync(where) end) end)
        end
    end
end)

-- boot wait: hold the on-load auto TP until the gear is in (0.3s min, 6s max)
do
    local since = os.clock()
    local GEAR = { ["Flying Carpet"] = true, ["Waverider"] = true, ["Santa's Sleigh"] = true,
        ["Witch's Broom"] = true, ["Cupid's Wings"] = true, ["Grapple Hook"] = true }
    local function inBox(box)
        if not box then return false end
        for _, t in ipairs(box:GetChildren()) do
            if t:IsA("Tool") and GEAR[t.Name] then return true end
        end
        return false
    end
    _G.EclipseBootWait = function()
        local t0 = os.clock()
        while true do
            local plr = game:GetService("Players").LocalPlayer
            local ok, ready = pcall(function() return inBox(plr.Character) or inBox(plr:FindFirstChild("Backpack")) end)
            if ok and ready and os.clock() - since >= 0.3 then return end
            if os.clock() - t0 >= 6 then return end
            task.wait(0.03)
        end
    end
end

local Players           = game:GetService("Players")
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local CFG_FILE = "TPToBestByOwnyx.json"
local CFG = { auto = false, pos = nil }
pcall(function()
    if isfile and isfile(CFG_FILE) then
        local d = HttpService:JSONDecode(readfile(CFG_FILE))
        if type(d) == "table" then for k, v in pairs(d) do CFG[k] = v end end
    end
end)
local function saveCfg()
    pcall(function() if writefile then writefile(CFG_FILE, HttpService:JSONEncode(CFG)) end end)
end

local REMOVE_MODELS = { "FuseMachine", "EventBoard", "EclipseSpinWheel", "JumpLTMMachine", "IncubatorMachine",
    "DiggingMachine", "TradePlazaPortal", "RobuxShop", "Shop" }
do

    local kill = {}
    for _, n in ipairs(REMOVE_MODELS) do kill[n] = true end
    local removed = 0
    local function check(m)
        if kill[m.Name] and (m:IsA("Model") or m:IsA("Folder") or m:IsA("BasePart")) then
            if pcall(function() m:Destroy() end) then removed = removed + 1 end
        end
    end
    for _, m in ipairs(Workspace:GetDescendants()) do if m.Parent then check(m) end end
    Workspace.DescendantAdded:Connect(function(m) task.defer(check, m) end)
    print("[Eclipse] removed " .. removed .. " map models (watching for more)")
end
local ENV = (type(getgenv) == "function" and getgenv()) or _G
if ENV.__EclipseBestUnload then pcall(ENV.__EclipseBestUnload) end

local REFRESH = 0
local UI_SCALE = 0.8

local FLY_TOOL     = "Flying Carpet"
local FLASH_TOOL   = "Flash Teleport"
local FLY_SPEED    = 50
local ARRIVE_RANGE = 3
local GRAPPLE_TOOL   = "Grapple Hook"
local GRAPPLE_REMOTE = 223
local GRAPPLE_ARG    = 0.18203736941019694
local GRAPPLE_AFTER  = 0.25
local GRAPPLE_DELAY  = 0.01
local FLY_HEIGHT   = 10
local SNAP_DELAY   = 0
local ARRIVE_WAIT  = 0.1
local CAM_HOLD     = 0.01
local FLASH_RETRY  = 0.05   -- retry the flash this often
local FLASH_RETRIES = 11   -- retry the flash at most this many times
local FLASH_DELAY  = 0.08
local FLY_TIMEOUT  = 20
local ANTI_RAGDOLL = true
local HITBOX_NAME  = "StealHitbox"
local LIFT_SLOT_MIN = 19
local LIFT_SLOT_MAX = 29
local LIFT_DEPTH    = 8
local LIFT_SPEED    = 3
local LIFT_EXTRA    = 6
local LIFT_GAIN     = 12
local TILT_AFTER    = 0.01
local TILT_RATE     = math.rad(90) / 0.05
local LIFT_TIME     = 5
local HITBOX_FLY_SPEED = 45   -- inside the StealHitbox: fly to the brainrot (or under it) at this speed
local HITBOX_DELAY = 0.13   -- inside the StealHitbox: wait this long, then fly to the brainrot

-- HEATSEEKER ROCKET MODE (replaces the grapple + carpet flight when the Heatseeker remote is captured)
local HEAT_TOOL     = "Heatseeker"
local POTION_TOOL   = "Giant Potion"
local HEAT_PRE_WAIT = 0.05   -- detection: after equipping, before activating
local HEAT_SPY      = 0.3    -- detection: max time to watch for the remote (stops the moment it is caught)
local MISSILE_NAME  = "Missle_" .. LP.Name
local MISSILE_WAIT  = 2      -- give up if your missile doesn't show up within this
local HEAT_BACKUP_AFTER = 0.25 -- no missile this long after the fire: also use the tool directly
local GIANT_AFTER_FIRE = 0.05 -- start sequence: Giant Potion this long after firing the rocket
local POTION_WAIT   = 0.05   -- after the tp to the flash spot, wait this long, then Giant Potion

local SPOTS = {
    { pos = Vector3.new(-348.437, -6.724, 179.646),
      low  = CFrame.new(-357.489, -4.538, 171.053, -0.6885, 0.0409, -0.7241, 0.0000, 0.9984, 0.0564, 0.7253, 0.0388, -0.6874),
      high = CFrame.new(-356.671, -9.826, 171.432, -0.7063, -0.2595, -0.6587, 0.0000, 0.9304, -0.3666, 0.7080, -0.2589, -0.6571) },
    { pos = Vector3.new(-346.832, -6.724, 77.120),
      low  = CFrame.new(-356.846, -4.433, 69.683, -0.5963, 0.0521, -0.8011, 0.0000, 0.9979, 0.0649, 0.8028, 0.0387, -0.5950),
      high = CFrame.new(-353.585, -9.984, 71.021, -0.6703, -0.3429, -0.6582, 0.0000, 0.8869, -0.4620, 0.7421, -0.3097, -0.5944) },
    { pos = Vector3.new(-346.538, -6.724, 45.368),
      low  = CFrame.new(-355.344, -4.085, 54.164, 0.7067, 0.0656, -0.7045, 0.0000, 0.9957, 0.0927, 0.7075, -0.0655, 0.7037),
      high = CFrame.new(-353.915, -9.977, 53.003, 0.7191, -0.2829, -0.6346, 0.0000, 0.9133, -0.4072, 0.6949, 0.2928, 0.6568) },
    { pos = Vector3.new(-347.976, -6.724, -62.479),
      low  = CFrame.new(-357.472, -4.683, -54.369, 0.6494, 0.0341, -0.7596, 0.0000, 0.9990, 0.0448, 0.7604, -0.0291, 0.6488),
      high = CFrame.new(-357.345, -9.706, -55.511, 0.5968, -0.2864, -0.7495, 0.0000, 0.9341, -0.3570, 0.8024, 0.2130, 0.5575) },
    { pos = Vector3.new(-465.476, -6.724, -64.630),
      low  = CFrame.new(-454.471, -4.003, -58.832, 0.4661, -0.0878, 0.8804, 0.0000, 0.9951, 0.0993, -0.8847, -0.0463, 0.4638),
      high = CFrame.new(-455.291, -9.788, -58.984, 0.4848, 0.3180, 0.8148, 0.0000, 0.9316, -0.3636, -0.8746, 0.1763, 0.4516) },
    { pos = Vector3.new(-469.619, -6.724, 42.207),
      low  = CFrame.new(-459.252, -3.447, 48.955, 0.5456, -0.1204, 0.8294, 0.0000, 0.9896, 0.1437, -0.8381, -0.0784, 0.5399),
      high = CFrame.new(-460.541, -9.976, 48.162, 0.5485, 0.3341, 0.7665, 0.0000, 0.9167, -0.3996, -0.8361, 0.2192, 0.5028) },
    { pos = Vector3.new(-472.122, -6.724, 72.241),
      low  = CFrame.new(-463.998, -4.625, 62.761, -0.7593, -0.0322, 0.6499, 0.0000, 0.9988, 0.0495, -0.6507, 0.0376, -0.7584),
      high = CFrame.new(-464.311, -9.724, 63.571, -0.7430, 0.2399, 0.6249, 0.0000, 0.9335, -0.3585, -0.6693, -0.2663, -0.6936) },
    { pos = Vector3.new(-471.094, -6.724, 182.006),
      low  = CFrame.new(-461.291, -3.728, 174.400, -0.6130, -0.0958, 0.7842, 0.0000, 0.9926, 0.1212, -0.7901, 0.0743, -0.6085),
      high = CFrame.new(-462.354, -9.973, 174.501, -0.6515, 0.2881, 0.7018, 0.0000, 0.9251, -0.3798, -0.7587, -0.2474, -0.6027) },
}

local HIGH_Y    = 5
local HIGH_TILT = 20
local AIM_SPOTS = {
    { pos = Vector3.new(-316.143, -5.199, 220.091) },
    { pos = Vector3.new(-318.590, 12.801, 220.195) },
    { pos = Vector3.new(-315.499, -7.161, 113.671) },
    { pos = Vector3.new(-315.581, 12.755, 115.133) },
    { pos = Vector3.new(-316.726, -6.160, 6.693) },
    { pos = Vector3.new(-321.052, 12.467, 6.837) },
    { pos = Vector3.new(-314.855, -5.726, -99.987) },
    { pos = Vector3.new(-319.558, 15.193, -100.374) },
    { pos = Vector3.new(-505.711, -5.879, -100.526) },
    { pos = Vector3.new(-503.885, 15.268, -99.407) },
    { pos = Vector3.new(-504.838, -4.549, 6.632) },
    { pos = Vector3.new(-505.402, 13.908, 6.970) },
    { pos = Vector3.new(-503.728, -5.637, 113.837) },
    { pos = Vector3.new(-501.663, 14.250, 112.524) },
    { pos = Vector3.new(-509.781, -5.716, 221.509) },
    { pos = Vector3.new(-503.178, 12.110, 219.263) },
}

local ANIMALS = {}
pcall(function() ANIMALS = require(ReplicatedStorage.Datas.Animals) end)

local function moneyText(n)
    n = tonumber(n) or 0
    for _, u in ipairs({ { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }) do
        if n >= u[1] then return string.format("$%.1f%s/s", n / u[1], u[2]):gsub("%.0([KMBT])", "%1") end
    end
    return "$" .. math.floor(n) .. "/s"
end
local function moneyValue(text)
    local n, u = tostring(text):match("%$([%d%.]+)([KMBT]?)/s")
    n = tonumber(n) or 0
    return n * (({ K = 1e3, M = 1e6, B = 1e9, T = 1e12 })[u] or 1)
end

local function incomeOf(model)
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("TextLabel") and d.Text:match("^%$[%d%.]+[KMBT]?/s$") then return moneyValue(d.Text), d.Text end
    end
    local data = ANIMALS[model.Name]
    local g = data and tonumber(data.Generation) or 0
    return g, moneyText(g)
end

local function signText(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local sg = sign and sign:FindFirstChild("SurfaceGui")
    local fr = sg and sg:FindFirstChild("Frame")
    local l = fr and fr:FindFirstChild("TextLabel")
    return l and l:IsA("TextLabel") and l.Text or ""
end
local function isMine(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local yb = sign and sign:FindFirstChild("YourBase")
    if yb and yb:IsA("BillboardGui") and yb.Enabled then return true end
    local t = signText(plot)
    return t == LP.Name .. "'s Base" or t == LP.DisplayName .. "'s Base"
end
local function ownerName(plot)
    return (signText(plot):gsub("'s [Bb]ase$", ""))
end

local brYes = setmetatable({}, { __mode = "k" })   -- models already known to be brainrots
local brNo = setmetatable({}, { __mode = "k" })    -- models known NOT to be (re-checked every 0.5s)
local function isBrainrot(m)
    if brYes[m] then return true end
    if not m:IsA("Model") then return false end
    if ANIMALS[m.Name] then brYes[m] = true return true end
    local last = brNo[m]
    if last and os.clock() - last < 0.5 then return false end
    for _, d in ipairs(m:GetDescendants()) do
        if d:IsA("TextLabel") and d.Text:match("^%$[%d%.]+[KMBT]?/s$") then brYes[m] = true brNo[m] = nil return true end
    end
    brNo[m] = os.clock()
    return false
end

local function slotOf(plot, pos)
    local pods = plot:FindFirstChild("AnimalPodiums")
    local best, bd = nil, 14
    for _, pod in ipairs(pods and pods:GetChildren() or {}) do
        local base = pod:FindFirstChild("Base")
        local sp = base and base:FindFirstChild("Spawn")
        if sp and sp:IsA("BasePart") then
            local d = (sp.Position - pos).Magnitude
            if d < bd then best, bd = pod.Name, d end
        end
    end
    return best
end

local function describe(e)
    local ok, pos = pcall(function() return e.model:GetPivot().Position end)
    e.pos = ok and pos or nil
    e.slot = ok and slotOf(e.plot, pos) or nil
    e.owner = ownerName(e.plot)
    local data = ANIMALS[e.name]
    e.rarity = data and data.Rarity or nil
    e.display = data and data.DisplayName or e.name
    return e
end

local function allBrainrots()
    local out = {}
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return out end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMine(plot) then
            for _, m in ipairs(plot:GetChildren()) do
                if isBrainrot(m) then
                    local inc, txt = incomeOf(m)
                    out[#out + 1] = describe({ model = m, plot = plot, income = inc, incomeText = txt, name = m.Name })
                end
            end
        end
    end
    table.sort(out, function(x, y) return x.income > y.income end)
    return out
end

local function findBest()
    return allBrainrots()[1]
end

local C = {
    WIN = Color3.fromRGB(10, 10, 10), TOP = Color3.fromRGB(26, 26, 26), CARD = Color3.fromRGB(20, 20, 20),
    ELEM = Color3.fromRGB(34, 34, 34), SEP = Color3.fromRGB(48, 48, 48), FAINT = Color3.fromRGB(85, 85, 85),
    DIM = Color3.fromRGB(150, 150, 150), TEXT = Color3.fromRGB(240, 240, 240), WHITE = Color3.new(1, 1, 1),
}
local FAMILY = "rbxasset://fonts/families/GothamSSm.json"
pcall(function() FAMILY = Font.fromEnum(Enum.Font.BuilderSans).Family end)
local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end
local function round(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function stroke(o, color, t) return new("UIStroke", { Color = color or C.SEP, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o) end
local function text(parent, str, size, weight, color, xa)
    return new("TextLabel", { BackgroundTransparency = 1, Text = str or "", TextSize = size, TextColor3 = color or C.TEXT,
        TextXAlignment = xa or Enum.TextXAlignment.Left, FontFace = Font.new(FAMILY, weight or Enum.FontWeight.Medium),
        TextTruncate = Enum.TextTruncate.AtEnd }, parent)
end

-- UI overlay (Elysium method): one ScreenGui on gethui() (falls back to CoreGui),
-- above the game's UI, old copy destroyed first.
local GUIHOST = (gethui and gethui()) or game:GetService("CoreGui")
pcall(function()
    for _, par in ipairs({ GUIHOST, LP:FindFirstChildOfClass("PlayerGui") }) do
        local old = par and par:FindFirstChild("EclipseBest")
        if old then old:Destroy() end
    end
end)
local gui = new("ScreenGui", { Name = "EclipseBest", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999998,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
pcall(function() gui.Parent = GUIHOST end)
if not gui.Parent then
    pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
end

local frame = new("Frame", { Size = UDim2.fromOffset(270, 226), Position = (type(CFG.pos) == "table" and #CFG.pos == 4) and UDim2.new(CFG.pos[1], CFG.pos[2], CFG.pos[3], CFG.pos[4]) or UDim2.new(0.5, -135, 0, 70), BackgroundColor3 = C.WHITE,
    BackgroundTransparency = 0.28, BorderSizePixel = 0, Active = true }, gui)
round(frame, 14)
new("UIGradient", { Rotation = 90, Color = ColorSequence.new(C.TOP, C.WIN) }, frame)
local outline = stroke(frame, C.WHITE, 1.4)
local shine = new("UIGradient", { Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, C.SEP), ColorSequenceKeypoint.new(0.4, C.SEP),
    ColorSequenceKeypoint.new(0.5, C.WHITE), ColorSequenceKeypoint.new(0.6, C.SEP), ColorSequenceKeypoint.new(1, C.SEP) }) }, outline)
local scale = new("UIScale", {}, frame)
local invFrame
local resetFrame

local function fit()
    local cam = Workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local mobile = UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled or math.min(vp.X, vp.Y) < 600)
    scale.Scale = (mobile and math.clamp(vp.Y / 520, 0.7, 1) or math.clamp(vp.Y / 960, 0.85, 1.3)) * UI_SCALE
end
fit()

local title = text(frame, "BEST BRAINROT", 11, Enum.FontWeight.Bold, C.DIM)
title.Position = UDim2.fromOffset(14, 9) title.Size = UDim2.new(1, -28, 0, 14)
new("Frame", { Position = UDim2.new(0, 12, 0, 28), Size = UDim2.new(1, -24, 0, 1), BackgroundColor3 = C.SEP, BorderSizePixel = 0 }, frame)

local nameL = text(frame, "Searching...", 17, Enum.FontWeight.Bold, C.WHITE)
nameL.Position = UDim2.fromOffset(14, 34) nameL.Size = UDim2.new(1, -28, 0, 22)
local incomeL = text(frame, "", 13, Enum.FontWeight.Bold, C.TEXT)
incomeL.Position = UDim2.fromOffset(14, 57) incomeL.Size = UDim2.new(0.55, -14, 0, 17)
local rarityL = text(frame, "", 11, Enum.FontWeight.Medium, C.DIM, Enum.TextXAlignment.Right)
rarityL.AnchorPoint = Vector2.new(1, 0) rarityL.Position = UDim2.new(1, -14, 0, 58) rarityL.Size = UDim2.new(0.45, -14, 0, 16)
local ownerL = text(frame, "", 11, Enum.FontWeight.Medium, C.DIM)
ownerL.Position = UDim2.fromOffset(14, 76) ownerL.Size = UDim2.new(1, -28, 0, 15)

local pill = new("Frame", { Position = UDim2.new(0, 12, 0, 96), Size = UDim2.new(1, -24, 0, 26), BackgroundColor3 = C.ELEM,
    BackgroundTransparency = 0.2, BorderSizePixel = 0 }, frame)
round(pill, 8)
stroke(pill)
local distL = text(pill, "— studs", 14, Enum.FontWeight.Bold, C.WHITE, Enum.TextXAlignment.Center)
distL.Size = UDim2.fromScale(1, 1)

local tpBtn = new("TextButton", { Position = UDim2.new(0, 12, 0, 128), Size = UDim2.new(0.62, -16, 0, 32), BackgroundColor3 = C.WHITE,
    BackgroundTransparency = 0.05, BorderSizePixel = 0, AutoButtonColor = false, Text = "TELEPORT", TextSize = 14,
    TextColor3 = C.WIN, FontFace = Font.new(FAMILY, Enum.FontWeight.Bold) }, frame)
round(tpBtn, 9)
local tpScale = new("UIScale", {}, tpBtn)
tpBtn.MouseEnter:Connect(function() TweenService:Create(tpBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.25 }):Play() end)
tpBtn.MouseLeave:Connect(function() TweenService:Create(tpBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.05 }):Play() end)
local listBtn = new("TextButton", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 128), Size = UDim2.new(0.38, -4, 0, 32),
    BackgroundColor3 = C.ELEM, BackgroundTransparency = 0.1, BorderSizePixel = 0, AutoButtonColor = false, Text = "LIST  ▾", TextSize = 13,
    TextColor3 = C.WHITE, FontFace = Font.new(FAMILY, Enum.FontWeight.Bold) }, frame)
round(listBtn, 9)
stroke(listBtn)

local autoRow = new("TextButton", { Position = UDim2.new(0, 12, 0, 166), Size = UDim2.new(1, -24, 0, 30), BackgroundColor3 = C.ELEM,
    BackgroundTransparency = 0.2, BorderSizePixel = 0, AutoButtonColor = false, Text = "" }, frame)
round(autoRow, 9)
stroke(autoRow)
local autoL = text(autoRow, "AUTO", 13, Enum.FontWeight.Bold, C.WHITE)
autoL.Position = UDim2.fromOffset(12, 0) autoL.Size = UDim2.new(1, -70, 1, 0)
local autoTrack = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(38, 20),
    BackgroundColor3 = C.SEP, BorderSizePixel = 0 }, autoRow)
round(autoTrack, 10)
local autoKnob = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(14, 14),
    BackgroundColor3 = C.DIM, BorderSizePixel = 0 }, autoTrack)
round(autoKnob, 7)
local function paintAuto(instant)
    local on = CFG.auto == true
    local ti = TweenInfo.new(instant and 0 or 0.18, Enum.EasingStyle.Quint)
    TweenService:Create(autoTrack, ti, { BackgroundColor3 = on and C.WHITE or C.SEP }):Play()
    TweenService:Create(autoKnob, ti, { Position = on and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        BackgroundColor3 = on and C.WIN or C.DIM }):Play()
    autoL.Text = on and "AUTO  ·  ON" or "AUTO  ·  OFF"
end
paintAuto(true)
autoRow.MouseButton1Click:Connect(function()
    CFG.auto = not CFG.auto
    paintAuto(false)
    saveCfg()
end)

local statusL = text(frame, "Ready", 11, Enum.FontWeight.Medium, C.DIM, Enum.TextXAlignment.Center)
statusL.Position = UDim2.new(0, 12, 0, 202) statusL.Size = UDim2.new(1, -24, 0, 16)

local listPanel   -- created further down (the brainrot list); declared here for the drag guard
frame.InputBegan:Connect(function(i)
    if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
    if listPanel.Visible then
        local p, a, z = i.Position, listPanel.AbsolutePosition, listPanel.AbsoluteSize
        if p.X >= a.X and p.X <= a.X + z.X and p.Y >= a.Y and p.Y <= a.Y + z.Y then return end
    end
    local start, pos = i.Position, frame.Position
    local mv = UserInputService.InputChanged:Connect(function(j)
        if j.UserInputType == Enum.UserInputType.MouseMovement or j == i then
            local d = (j.Position - start) / math.max(scale.Scale, 0.01)
            frame.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
        end
    end)
    local ec
    ec = i.Changed:Connect(function()
        if i.UserInputState == Enum.UserInputState.End then
            mv:Disconnect() ec:Disconnect()
            local p = frame.Position
            CFG.pos = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
            saveCfg()
        end
    end)
end)

local outlineHL = new("Highlight", { FillTransparency = 1, OutlineColor = C.WHITE, OutlineTransparency = 0,
    DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Enabled = false }, gui)
local tag = new("BillboardGui", { Size = UDim2.fromOffset(150, 30), StudsOffset = Vector3.new(0, 4.5, 0), AlwaysOnTop = true,
    LightInfluence = 0, MaxDistance = 100000, Enabled = false }, gui)
local tagPill = new("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.fromScale(0.5, 1), Size = UDim2.new(),
    AutomaticSize = Enum.AutomaticSize.XY, BackgroundColor3 = C.WIN, BackgroundTransparency = 0.25, BorderSizePixel = 0 }, tag)
round(tagPill, 8)
stroke(tagPill)
new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 4) }, tagPill)
local tagL = new("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(), AutomaticSize = Enum.AutomaticSize.XY, Text = "",
    TextSize = 13, TextColor3 = C.WHITE, FontFace = Font.new(FAMILY, Enum.FontWeight.Bold) }, tagPill)

local alive = true
local current
local conns = {}
local function on(sig, fn) conns[#conns + 1] = sig:Connect(fn) end

local selected = nil
listPanel = new("Frame", { Size = UDim2.fromOffset(270, 260), AnchorPoint = Vector2.new(0, 0), Position = UDim2.new(0, 0, 1, 8),
    BackgroundColor3 = C.WHITE, BackgroundTransparency = 0.28, BorderSizePixel = 0, Visible = false, Active = true }, frame)
round(listPanel, 14)
new("UIGradient", { Rotation = 90, Color = ColorSequence.new(C.TOP, C.WIN) }, listPanel)
stroke(listPanel, C.FAINT, 1.2)
local listTitle = text(listPanel, "CHOOSE A BRAINROT", 11, Enum.FontWeight.Bold, C.DIM)
listTitle.Position = UDim2.fromOffset(14, 8) listTitle.Size = UDim2.new(1, -28, 0, 14)
local listScroll = new("ScrollingFrame", { Position = UDim2.fromOffset(8, 28), Size = UDim2.new(1, -16, 1, -36), BackgroundTransparency = 1,
    BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = C.DIM, CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y }, listPanel)
new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, listScroll)
new("UIPadding", { PaddingRight = UDim.new(0, 4) }, listScroll)

local refreshCurrent
local function isSel(e) return selected and e and selected.model == e.model end
local function rowButton(order, top, sub, right, on)
    local r = new("TextButton", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = on and C.WHITE or C.CARD,
        BackgroundTransparency = on and 0.05 or 0.35, BorderSizePixel = 0, AutoButtonColor = false, Text = "", LayoutOrder = order }, listScroll)
    round(r, 8)
    stroke(r)
    local fg = on and C.WIN or C.TEXT
    local a = text(r, top, 13, Enum.FontWeight.Bold, fg)
    a.Position = UDim2.fromOffset(10, 4) a.Size = UDim2.new(1, -90, 0, 17)
    local b2 = text(r, sub, 10, Enum.FontWeight.Medium, on and C.ELEM or C.DIM)
    b2.Position = UDim2.fromOffset(10, 21) b2.Size = UDim2.new(1, -90, 0, 14)
    local c = text(r, right, 12, Enum.FontWeight.Bold, fg, Enum.TextXAlignment.Right)
    c.AnchorPoint = Vector2.new(1, 0) c.Position = UDim2.new(1, -10, 0, 4) c.Size = UDim2.fromOffset(80, 32)
    c.TextTruncate = Enum.TextTruncate.None c.TextYAlignment = Enum.TextYAlignment.Top
    r.MouseEnter:Connect(function() if not on then TweenService:Create(r, TweenInfo.new(0.12), { BackgroundTransparency = 0.15 }):Play() end end)
    r.MouseLeave:Connect(function() if not on then TweenService:Create(r, TweenInfo.new(0.12), { BackgroundTransparency = 0.35 }):Play() end end)
    return r, c
end
local listRows, listSig = {}, nil
local rebuildList
-- the list only rebuilds when the brainrots / selection actually change; otherwise only the
-- distance text is updated in place, so the buttons stay put and clicks register
local function distText(e, hrp)
    local ok, pos = pcall(function() return e.model:GetPivot().Position end)
    return (hrp and ok and pos) and (math.floor((pos - hrp.Position).Magnitude + 0.5) .. "m") or ""
end
local function buildRows(list)
    for _, c in ipairs(listScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    table.clear(listRows)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local auto = rowButton(0, "★  Best (auto)", list[1] and (list[1].display .. "  ·  " .. list[1].incomeText) or "nothing on the map", "", selected == nil)
    auto.MouseButton1Click:Connect(function()
        selected = nil
        pcall(refreshCurrent)
        rebuildList(true)
    end)
    for i, e in ipairs(list) do
        local sub = (e.owner ~= "" and e.owner or "?") .. (e.slot and ("  ·  slot " .. e.slot) or "") .. (e.rarity and ("  ·  " .. e.rarity) or "")
        local r, c = rowButton(i, e.display, sub, e.incomeText .. "\n" .. distText(e, hrp), isSel(e))
        listRows[#listRows + 1] = { e = e, c = c }
        r.MouseButton1Click:Connect(function()
            if not (e.model.Parent and e.plot.Parent) then rebuildList(true) return end
            selected = { model = e.model, plot = e.plot }
            pcall(refreshCurrent)
            rebuildList(true)
            setStatus("Target: " .. e.display)
        end)
    end
end
rebuildList = function(force)
    local list = allBrainrots()
    local parts = { selected and tostring(selected.model) or "auto" }
    for _, e in ipairs(list) do parts[#parts + 1] = tostring(e.model) .. "|" .. e.incomeText .. "|" .. tostring(e.slot) end
    local sig = table.concat(parts, ";")
    if force or sig ~= listSig then
        listSig = sig
        buildRows(list)
        return
    end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    for _, row in ipairs(listRows) do
        if row.c.Parent then row.c.Text = row.e.incomeText .. "\n" .. distText(row.e, hrp) end
    end
end
listBtn.MouseButton1Click:Connect(function()
    listPanel.Visible = not listPanel.Visible
    listBtn.Text = listPanel.Visible and "LIST  ▴" or "LIST  ▾"
    if listPanel.Visible then rebuildList(true) end
end)

local function show(b)
    current = b
    if not b then
        nameL.Text = "No brainrots found"
        incomeL.Text, rarityL.Text, ownerL.Text = "", "", ""
        distL.Text = "— studs"
        outlineHL.Enabled, tag.Enabled = false, false
        return
    end
    nameL.Text = b.display
    incomeL.Text = b.incomeText
    rarityL.Text = b.rarity or ""
    ownerL.Text = (b.owner ~= "" and (b.owner .. "'s base") or "Base") .. (b.slot and ("  ·  slot " .. b.slot) or "")
    outlineHL.Adornee = b.model
    outlineHL.Enabled = true
    tag.Adornee = b.model.PrimaryPart or b.model:FindFirstChildWhichIsA("BasePart", true)
    tag.Enabled = tag.Adornee ~= nil
end

function refreshCurrent()
    local b
    if selected then
        if selected.model.Parent and selected.plot.Parent then
            local inc, txt = incomeOf(selected.model)
            b = describe({ model = selected.model, plot = selected.plot, income = inc, incomeText = txt, name = selected.model.Name })
        else
            selected = nil
        end
    end
    if not b then b = findBest() end
    title.Text = selected and "SELECTED BRAINROT" or "BEST BRAINROT"
    if not (b and current and b.model == current.model) then show(b) else
        current.income, current.incomeText = b.income, b.incomeText
        incomeL.Text = b.incomeText
    end
end

pcall(refreshCurrent)
do
    local queued = false
    local function bump()
        if queued then return end
        queued = true
        task.defer(function() queued = false pcall(refreshCurrent) end)
    end
    task.spawn(function()
        local plots = Workspace:FindFirstChild("Plots") or Workspace:WaitForChild("Plots", 30)
        if plots then
            on(plots.DescendantAdded, bump)
            on(plots.DescendantRemoving, bump)
            bump()
        end
    end)
end
task.spawn(function()
    local lastList = 0
    while alive do
        pcall(refreshCurrent)
        -- refresh the open list twice a second, never while a mouse button is held (mid-click / scroll)
        if listPanel.Visible and os.clock() - lastList >= 0.5
            and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            lastList = os.clock()
            pcall(rebuildList)
        end
        if REFRESH > 0 then task.wait(REFRESH) else RunService.Heartbeat:Wait() end
    end
end)

on(RunService.RenderStepped, function()
    shine.Offset = Vector2.new(((os.clock() * 0.35) % 2) - 1, 0)
    local b = current
    if not (b and b.model.Parent) then return end
    local ch = LP.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local ok, pos = pcall(function() return b.model:GetPivot().Position end)
    if hrp and ok then
        local d = (pos - hrp.Position).Magnitude
        distL.Text = string.format("%d studs away", math.floor(d + 0.5))
        tagL.Text = string.format("%s  ·  %s  ·  %dm", selected and "TARGET" or "BEST", b.incomeText, math.floor(d + 0.5))
    else
        distL.Text = "— studs"
    end
end)

on(UserInputService.InputBegan, function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then frame.Visible = not frame.Visible if invFrame then invFrame.Visible = frame.Visible end if resetFrame then resetFrame.Visible = frame.Visible end end
end)
local cam = Workspace.CurrentCamera
if cam then on(cam:GetPropertyChangedSignal("ViewportSize"), fit) end

local tpRunning, tpToken = false, 0
local function setStatus(t) statusL.Text = t end

local function equip(name)
    local ch = LP.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    local tool = ch:FindFirstChild(name)
    if tool and tool:IsA("Tool") then return tool end
    local bp = LP:FindFirstChild("Backpack")
    tool = bp and bp:FindFirstChild(name)
    if not (tool and tool:IsA("Tool")) then return nil end
    pcall(function() hum:EquipTool(tool) end)
    return tool
end

local UNDER_DEPTH   = 11.5   -- studs under the brainrot (slots 19-29)
local UPPER_GRAB_WAIT = 1.3
local HITBOX_ARM_FOR = 6

local function isStealPrompt(p)
    if not p or not p.Parent or not p:IsA("ProximityPrompt") or not p.Enabled then return false end
    local st = p:GetAttribute("State")
    return st == "Steal" or st == "Grab" or p.ActionText == "Steal" or p.ActionText == "Grab"
end
local function podiumPrompt(plot, slot)
    local pods = plot and plot:FindFirstChild("AnimalPodiums")
    local podium = pods and slot and pods:FindFirstChild(tostring(slot))
    if not podium then return nil, nil end
    local base = podium:FindFirstChild("Base") or podium
    local sp = base:FindFirstChild("Spawn")
    local att = sp and sp:FindFirstChild("PromptAttachment")
    for _, c in ipairs(att and att:GetChildren() or {}) do
        if isStealPrompt(c) then return c, podium end
    end
    return nil, podium
end
local function promptPos(p)
    local par = p and p.Parent
    if not par then return nil end
    if par:IsA("Attachment") then return par.WorldPosition end
    if par:IsA("BasePart") then return par.Position end
end
-- grab state shared with the TP / hitbox code (the grab itself is the Elysium engine below)
local grabGen = 0
local function cancelGrabLoop() grabGen = grabGen + 1 end
local tpLanded = nil       -- os.clock() when the StealHitbox tp puts you under / onto the brainrot
local grabBarFill = nil    -- the grab progress bar fill (created with the ACTIONS panel)
local tpGrab               -- TP auto grab      (ELYSIUM AUTO GRAB block)
local manualOn = false
local manualGrabLoop       -- MANUAL GRAB toggle (ELYSIUM AUTO GRAB block)
local function stealingNow()
    local ch = LP.Character
    local a = LP:GetAttribute("Stealing")
    if a == nil and ch then a = ch:GetAttribute("Stealing") end
    return a ~= nil and a ~= false
end

local liftActive = false
local pending = nil
local function cancelGrab() pending = nil end

local function basePosition(plot)
    local ok, p = pcall(function() return plot:GetPivot().Position end)
    if ok and p then return p end
    local part = plot:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position
end

local function closestSpot(pos)
    local best, bd
    for _, s in ipairs(SPOTS) do
        local d = (Vector3.new(s.pos.X, 0, s.pos.Z) - Vector3.new(pos.X, 0, pos.Z)).Magnitude
        if not bd or d < bd then best, bd = s, d end
    end
    return best
end

local function stopTp(msg)
    tpRunning = false
    tpToken = tpToken + 1
    tpBtn.Text = "TELEPORT"
    if msg then setStatus(msg) end
end

local SXEGrapple = {}
do
    local band, bor, bxor, bnot = bit32.band, bit32.bor, bit32.bxor, bit32.bnot
    local rrot, rsh, lsh = bit32.rrotate, bit32.rshift, bit32.lshift
    local K = {
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2,
    }
    local function sha256(msg)
        local h0,h1,h2,h3,h4,h5,h6,h7 =
            0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19
        local len = #msg
        msg = msg .. "\128"
        while #msg % 64 ~= 56 do msg = msg .. "\0" end
        local bits = len * 8
        msg = msg .. string.char(
            band(rsh(bits,56),0xff), band(rsh(bits,48),0xff), band(rsh(bits,40),0xff), band(rsh(bits,32),0xff),
            band(rsh(bits,24),0xff), band(rsh(bits,16),0xff), band(rsh(bits,8),0xff), band(bits,0xff))
        for chunk = 1, #msg, 64 do
            local w = {}
            for i = 0, 15 do
                local a,b,c,d = msg:byte(chunk + i*4, chunk + i*4 + 3)
                w[i] = bor(lsh(a,24), lsh(b,16), lsh(c,8), d)
            end
            for i = 16, 63 do
                local s0 = bxor(rrot(w[i-15],7), rrot(w[i-15],18), rsh(w[i-15],3))
                local s1 = bxor(rrot(w[i-2],17), rrot(w[i-2],19), rsh(w[i-2],10))
                w[i] = (w[i-16] + s0 + w[i-7] + s1) % 4294967296
            end
            local a,b,c,d,e,f,g,h = h0,h1,h2,h3,h4,h5,h6,h7
            for i = 0, 63 do
                local S1 = bxor(rrot(e,6), rrot(e,11), rrot(e,25))
                local ch = bxor(band(e,f), band(bnot(e),g))
                local t1 = (h + S1 + ch + K[i+1] + w[i]) % 4294967296
                local S0 = bxor(rrot(a,2), rrot(a,13), rrot(a,22))
                local maj = bxor(band(a,b), band(a,c), band(b,c))
                local t2 = (S0 + maj) % 4294967296
                h=g; g=f; f=e; e=(d+t1)%4294967296; d=c; c=b; b=a; a=(t1+t2)%4294967296
            end
            h0=(h0+a)%4294967296; h1=(h1+b)%4294967296; h2=(h2+c)%4294967296; h3=(h3+d)%4294967296
            h4=(h4+e)%4294967296; h5=(h5+f)%4294967296; h6=(h6+g)%4294967296; h7=(h7+h)%4294967296
        end
        return string.format("%08x%08x%08x%08x%08x%08x%08x%08x", h0,h1,h2,h3,h4,h5,h6,h7)
    end
    local function encode(name, jobId)
        if jobId == "" then jobId = "00000000-0000-0000-0000-000000000000" end
        local t, n = {}, 0
        for i = 1, #name do
            local b = string.byte(name, i)
            if b == 47 then
                t[i] = "/"
            else
                t[i] = string.char((b - 32 + string.byte(jobId, (n) % #jobId + 1)) % 95 + 32)
                n = n + 1
            end
        end
        return table.concat(t)
    end
    local SALT = "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7"
    local cache = {}
    -- resolve a remote by its real uuid name, exactly like SXE
    function SXEGrapple.resolve(uuid)
        if cache[uuid] and cache[uuid].Parent then return cache[uuid] end
        local ok, re = pcall(function()
            local jobId = game.JobId
            local net = ReplicatedStorage:FindFirstChild("Packages")
            net = net and net:FindFirstChild("Net")
            if not net then return nil end
            local hash = sha256(encode(uuid, jobId) .. SALT .. jobId)
            return net:FindFirstChild("RE/" .. hash) or net:FindFirstChild("RF/" .. hash) or net:FindFirstChild("URE/" .. hash)
        end)
        local r = ok and re or nil
        if r then cache[uuid] = r end
        return r
    end
end

------------------------------------------------------------
-- ELYSIUM AUTO GRAB (ported from Elysium Hub's priority / source-steal engine)
--  * waits until you are next to the target's Steal prompt (<= 12 studs, or the
--    prompt's own MaxActivationDistance if smaller)
--  * QUICK GRAB: fires the Begin remote with a timestamp backdated 1.6s, then the
--    Grab remote 0.55s later (plot + slot) -- up to 2 tries
--  * if that doesn't take: one full hold through the game's own prompt callbacks
--    (HoldBegan -> wait HoldDuration + 0.1 -> Triggered) -- up to 2 tries
--  * still nothing: fireproximityprompt spam (3x every 0.12s) for 4s, then repeat
--  * stops the moment you are Stealing
------------------------------------------------------------
do
local EG = {
    RANGE        = 12,    -- grab range (studs) to the Steal prompt
    SPOOF_DELAY  = 0.55,  -- Begin -> Grab delay of the quick grab
    BACKDATE     = 1.6,   -- Begin timestamp is sent this far in the past
    GRAB_OFFSET  = 2.1,   -- Grab timestamp = begin stamp + this
    MAX_SPOOFS   = 2,     -- quick grabs per target before falling back to a real hold
    MAX_HOLDS    = 2,     -- real holds before falling back to FPP spam
    HOLD_MARGIN  = 0.1,   -- added to the prompt's HoldDuration
    HOLD_DEFAULT = 1.3,   -- used when the prompt has no HoldDuration
    FPP_FOR      = 4,     -- FPP-only window after the quick grab / holds fail
    FPP_EVERY    = 0.12,
    FPP_COUNT    = 3,
    TIMEOUT      = 30,    -- give up on the target after this long (covers the fly + clone)
    -- Eclipse puts you UNDER the floor for slots 19-29 (25 studs below the prompt).
    -- true = once the script itself has snapped you onto/under the target, ignore the range check.
    TRUST_SNAP   = true,
    START_RANGE  = 4,     -- TP auto grab: start within this many studs of the brainrot (or once landed on it)
}
local EG_BUILDS = {
    {
        Begin = "b77dde61-dd74-4f18-b329-2ac7f7e48f0b",
        Grab  = "0c1792e6-3df9-46fd-8b46-be6e4e6df08f",
        BeginArgs = { { 79, "94fa9dee-cfa2-4cc2-ac2a-0659e5169fac" }, { 79, "173cd914-bfdd-4c77-80bc-86864bd1ecb4" } },
        GrabArgs  = { { 141, "859270da-f6e7-4110-af2e-4c58fa259c75" }, { 141, "b231811b-fa22-4265-81fe-424ea71ddb92" } },
    },
    {
        Begin = "f1a4d3a5-b97a-4622-8fd6-232663ff697e",
        Grab  = "f5f26af9-cb1b-4588-bcc9-12fd78f64599",
        BeginArgs = { { 50, "ba10cc43-8b93-4b7d-93b8-e1935730ebe3" }, { 50, "ed327974-0c39-423a-b9c7-467b8fdac46d" } },
        GrabArgs  = { { 16, "7aae3e74-d52e-433a-83b1-9d5a507d2e80" }, { 16, "c3eb316e-a4cc-4dc9-8b0e-1a770a7d99fd" } },
    },
}

-- steal remotes, Elysium getRemote: require the game's Packages.Net and ask it for the
-- remote from INSIDE one of the game's own Heartbeat functions (hookfunction on it),
-- so the lookup runs on the game's thread. Nothing is fired and no namecall is spied on.
local EGNet = {}
do
    local prev = ENV.__EclipseNet
    if prev and prev.game == game then
        EGNet = prev
    else
        EGNet.game = game
        local net, hooked, original = nil, false, nil
        local queue, cache = {}, {}
        local function getNet()
            if net then return net end
            local pk = ReplicatedStorage:FindFirstChild("Packages") or ReplicatedStorage:WaitForChild("Packages", 10)
            local dir = pk and (pk:FindFirstChild("Net") or pk:WaitForChild("Net", 10))
            if not dir then return nil end
            local ok, m = pcall(require, dir)
            if ok and type(m) == "table" then net = m end
            return net
        end
        local function host()
            if type(getconnections) ~= "function" or type(islclosure) ~= "function" then return nil end
            for _, sig in ipairs({ RunService.Heartbeat, RunService.RenderStepped, RunService.PostSimulation }) do
                local ok, conns = pcall(getconnections, sig)
                if ok then
                    for _, c in ipairs(conns) do
                        local f = c.Function
                        if f and islclosure(f) and not (type(isexecutorclosure) == "function" and isexecutorclosure(f)) then
                            local s = select(2, pcall(debug.info, f, "s"))
                            if type(s) == "string" and s:find("^ReplicatedStorage%.") and not s:find("ReplicatedFirst") then
                                return f
                            end
                        end
                    end
                end
            end
        end
        local function install()
            if hooked then return true end
            if type(hookfunction) ~= "function" or not getNet() then return false end
            local h = host()
            if not h then return false end
            local w = function(...)
                local job = table.remove(queue, 1)
                if job then
                    local ok, r = pcall(net[job.kind], net, job.name)
                    job.result = (ok and typeof(r) == "Instance") and r or nil
                    job.done = true
                end
                return original(...)
            end
            local ok, env = pcall(getfenv, h)
            if ok and type(env) == "table" then pcall(setfenv, w, env) end
            original = hookfunction(h, w)
            hooked = true
            return true
        end
        function EGNet.get(name, kind)
            kind = kind or "RemoteEvent"
            if type(name) ~= "string" or name == "" then return nil end
            local logical = name:match("^R[EF]/(.+)$") or name:match("^URE/(.+)$") or name
            local ck = kind .. "|" .. logical
            local hit = cache[ck]
            if hit and hit.Parent then return hit end
            cache[ck] = nil
            if not getNet() or not install() then return nil end
            local job = { kind = kind, name = logical }
            table.insert(queue, job)
            local t = os.clock() + 5
            while not job.done and os.clock() < t do RunService.Heartbeat:Wait() end
            if job.result and job.result.Parent then
                cache[ck] = job.result
                return job.result
            end
            return nil
        end
        ENV.__EclipseNet = EGNet
    end
end

-- resolvePriorityTransport: look the Begin/Grab pair up in the background (getRemote can
-- yield); retry every 5s. Hashed-name lookup is only used if the executor can't hook.
local egTransportSel, egResolving, egRetryAt = nil, false, 0
local function egResolve()
    if egResolving or os.clock() < egRetryAt then return end
    egResolving = true
    task.spawn(function()
        pcall(function()
            for _, build in ipairs(EG_BUILDS) do
                local begin = EGNet.get(build.Begin) or SXEGrapple.resolve(build.Begin)
                local grab = begin and (EGNet.get(build.Grab) or SXEGrapple.resolve(build.Grab))
                if begin and grab then
                    egTransportSel = { Build = build, Begin = begin, Grab = grab }
                    print("[Eclipse] steal remotes ready: " .. begin.Name .. " / " .. grab.Name)
                    break
                end
            end
        end)
        egResolving = false
        egRetryAt = os.clock() + 5
    end)
end
local function egTransport()
    local t = egTransportSel
    if t and t.Begin.Parent and t.Grab.Parent then return t end
    egTransportSel = nil
    egResolve()
    return nil
end

-- the target's Steal prompt: the podium's PromptAttachment first, then (like Elysium)
-- any enabled "Steal" prompt in the plot sitting right above that slot's spawn
local function egPrompt(b)
    if not (b and b.plot and b.plot.Parent and b.slot) then return nil end
    local p, podium = podiumPrompt(b.plot, b.slot)
    if p then return p end
    local base = podium and (podium:FindFirstChild("Base") or podium)
    local sp = base and (base:FindFirstChild("Spawn") or base:FindFirstChildWhichIsA("BasePart"))
    if not (sp and sp:IsA("BasePart")) then return nil end
    local best, bestDy
    for _, d in ipairs(b.plot:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d.Enabled and d.ActionText == "Steal" then
            local at = promptPos(d)
            if at then
                local flat = Vector2.new(at.X - sp.Position.X, at.Z - sp.Position.Z).Magnitude
                local dy = at.Y - sp.Position.Y
                if flat < 5 and dy > 0 and (not bestDy or dy < bestDy) then best, bestDy = d, dy end
            end
        end
    end
    return best
end

local function egClose(prompt, trusted)
    local ch = LP.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local at = promptPos(prompt)
    if not (hrp and at) then return false end
    if trusted then return true end
    local reach = tonumber(prompt.MaxActivationDistance) or 0
    reach = math.min(EG.RANGE, reach > 0 and reach or 10)
    return (hrp.Position - at).Magnitude <= reach
end

local function egCallbacks(prompt)
    if type(getconnections) ~= "function" then return nil end
    local found = { began = {}, triggered = {}, ended = {} }
    for field, sig in pairs({ began = prompt.PromptButtonHoldBegan, triggered = prompt.Triggered, ended = prompt.PromptButtonHoldEnded }) do
        local ok, list = pcall(getconnections, sig)
        if ok and type(list) == "table" then
            for _, c in ipairs(list) do
                local ok2, f = pcall(function() return c.Function end)
                if ok2 and type(f) == "function" then found[field][#found[field] + 1] = f end
            end
        end
    end
    return found
end

local function egBar(seconds)
    if not grabBarFill then return end
    pcall(function()
        grabBarFill.Size = UDim2.new(0, 0, 1, 0)
        TweenService:Create(grabBarFill, TweenInfo.new(math.max(seconds, 0.05), Enum.EasingStyle.Linear),
            { Size = UDim2.new(1, 0, 1, 0) }):Play()
    end)
end

-- quick grab: Begin with a timestamp 1.6s in the past, Grab 0.55s later.
-- Returns true only when the Begin was actually sent.
local function egSpoof(prompt, plotName, slot, stillFn, trustedFn)
    local t = egTransport()
    if not t then return false end
    local slotArg = tonumber(slot) or slot
    local started = Workspace:GetServerTimeNow() - EG.BACKDATE
    local function fire(remote, args, stamp, ...)
        for _, a in ipairs(args) do remote:FireServer(stamp + a[1], a[2], ...) end
    end
    if not pcall(fire, t.Begin, t.Build.BeginArgs, started) then return false end
    task.delay(EG.SPOOF_DELAY, function()
        if not stillFn() or stealingNow() or not prompt.Parent then return end
        if not egClose(prompt, trustedFn()) then return end
        pcall(fire, t.Grab, t.Build.GrabArgs, started + EG.GRAB_OFFSET, plotName, slotArg)
    end)
    return true
end

-- ONE shared loop (Elysium Tick): `pick()` returns the target each tick, `still()` says
-- whether to keep going, `trustedFn()` says the script itself snapped you onto the target.
-- Quick-grab / hold counters reset whenever the target changes (Elysium resets them per uid).
local function egLoop(pick, still, trustedFn, timeout, onStolen, startFn)
    local q = { uid = nil, untilAt = 0, spoofs = 0, holds = 0, offUntil = 0 }
    local hold = nil
    local holdSerial = 0
    local lastFpp = 0
    local t0 = os.clock()
    local function cancelHold()
        local h = hold
        hold = nil
        holdSerial = holdSerial + 1
        if h then for _, f in ipairs(h.cb.ended) do task.spawn(pcall, f) end end
    end
    local stillNow = function() return alive and still() end
    while stillNow() do
        local now = os.clock()
        if stealingNow() then
            hold = nil
            if onStolen and onStolen() == false then return end
            RunService.Heartbeat:Wait()
            continue
        end
        if timeout and now - t0 > timeout then setStatus("Auto grab timed out") break end
        local b = pick()
        if not (b and b.model and b.model.Parent and b.plot and b.plot.Parent) then
            cancelHold()
            if timeout then setStatus("Target is gone") break end
            setStatus("Manual grab: no brainrot nearby")
            task.wait(0.1)
            continue
        end
        local uid = b.plot.Name .. "_" .. tostring(b.slot)
        if q.uid ~= uid then
            cancelHold()
            q.uid, q.untilAt, q.spoofs, q.holds, q.offUntil = uid, 0, 0, 0, 0
        end

        local prompt = egPrompt(b)
        local close = false
        if prompt ~= nil and prompt.Enabled then
            if startFn then close = startFn(b) else close = egClose(prompt, trustedFn()) end
        end
        if hold and hold.prompt ~= prompt then cancelHold() end

        if close and now >= q.offUntil then
            if now >= q.untilAt and not hold then
                if q.spoofs < EG.MAX_SPOOFS and egSpoof(prompt, b.plot.Name, b.slot, stillNow, trustedFn) then
                    q.spoofs = q.spoofs + 1
                    q.untilAt = now + EG.SPOOF_DELAY + 0.8
                    egBar(EG.SPOOF_DELAY)
                    setStatus(string.format("Quick grab %d/%d — %s", q.spoofs, EG.MAX_SPOOFS, b.display))
                else
                    local cb = egCallbacks(prompt)
                    if not cb or #cb.began == 0 or #cb.triggered == 0 or q.holds >= EG.MAX_HOLDS then
                        q.offUntil = now + EG.FPP_FOR
                        q.holds, q.untilAt = 0, 0
                    else
                        local length = tonumber(prompt.HoldDuration) or 0
                        if length <= 0 then length = EG.HOLD_DEFAULT end
                        length = length + EG.HOLD_MARGIN
                        q.holds = q.holds + 1
                        q.untilAt = now + length + 0.35
                        holdSerial = holdSerial + 1
                        local token = holdSerial
                        hold = { prompt = prompt, cb = cb }
                        for _, f in ipairs(cb.began) do task.spawn(pcall, f) end
                        egBar(length)
                        setStatus(string.format("Holding %d/%d — %s", q.holds, EG.MAX_HOLDS, b.display))
                        task.delay(length, function()
                            if not stillNow() or holdSerial ~= token then return end
                            hold = nil
                            if stealingNow() or not (prompt.Parent and prompt.Enabled) then return end
                            if not egClose(prompt, trustedFn()) then return end
                            for _, f in ipairs(cb.triggered) do task.spawn(pcall, f) end
                        end)
                    end
                end
            end
        else
            if hold and now < q.untilAt and not close then
                cancelHold()
                q.untilAt = 0
            end
            if close and type(fireproximityprompt) == "function" and now - lastFpp >= EG.FPP_EVERY then
                lastFpp = now
                for _ = 1, EG.FPP_COUNT do pcall(fireproximityprompt, prompt, 0) end
                setStatus("Grabbing (prompt) — " .. b.display)
            elseif not close and not hold then
                setStatus("Waiting for range — " .. b.display)
            end
        end
        RunService.Heartbeat:Wait()
    end
    cancelHold()
end

-- TP AUTO GRAB: locked onto the selected / best brainrot
-- TP auto grab starts only when you are within EG.START_RANGE (4) studs of the brainrot,
-- or the moment the hitbox flight lands you on / under it
local function nearBrainrot(b)
    if tpLanded ~= nil then return true end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local ok, pos = pcall(function() return b.model:GetPivot().Position end)
    return hrp ~= nil and ok and pos ~= nil and (pos - hrp.Position).Magnitude <= EG.START_RANGE
end

tpGrab = function(b)
    cancelGrabLoop()
    local my = grabGen
    tpLanded = nil
    task.spawn(egTransport)   -- warm the remote lookup up while we fly
    setStatus("Auto grab armed — " .. b.display)
    task.spawn(egLoop,
        function() return b end,
        function() return grabGen == my end,
        function() return nearBrainrot(b) end,
        EG.TIMEOUT,
        function() setStatus("✔ Stealing " .. b.display) return false end,
        nearBrainrot)
end

-- MANUAL GRAB toggle: Elysium "Nearest" mode -- keeps grabbing the nearest brainrot
-- (other people's bases) with the same quick grab / hold / FPP sequence, until turned off.
local manualGen = 0
manualGrabLoop = function()
    manualGen = manualGen + 1
    local my = manualGen
    task.spawn(egTransport)
    local list, lastScan = {}, -math.huge
    local function nearest()
        if os.clock() - lastScan >= 0.5 then     -- Elysium rescans every 0.5s
            lastScan = os.clock()
            local ok, l = pcall(allBrainrots)
            list = ok and l or {}
        end
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local best, bd
        for _, e in ipairs(list) do
            if e.model.Parent and e.slot then
                local ok, pos = pcall(function() return e.model:GetPivot().Position end)
                local d = ok and (pos - hrp.Position).Magnitude
                if d and (not bd or d < bd) then best, bd = e, d end
            end
        end
        return best
    end
    task.spawn(egLoop,
        nearest,
        function() return manualOn and manualGen == my end,
        function() return false end,
        nil,
        function() setStatus("✔ Stealing (manual grab)") return true end)
end
    egResolve()
end   -- ELYSIUM AUTO GRAB

local GRAPPLE_UUID = "75c9466d-e4c0-4b02-b26a-c3615fcc1e42"
-- Grapple (SXE method): equip until it's in your hand, resolve the grapple remote by its hashed name, fire 3x 0.33.
-- `alive_` is a check that returns false if we should stop. Returns false if stopped.
local function grappleFire(alive_)
    local grapple = equip(GRAPPLE_TOOL)
    if not grapple then setStatus("No " .. GRAPPLE_TOOL .. " — skipping") end
    local e0 = os.clock()
    while grapple and grapple.Parent ~= LP.Character and os.clock() - e0 < 0.5 do
        if not alive_() then return false end
        RunService.Heartbeat:Wait()
        grapple = equip(GRAPPLE_TOOL) or grapple
    end
    if not alive_() then return false end
    local fired = pcall(function()
        local r = SXEGrapple.resolve(GRAPPLE_UUID)
        if not r then
            local net = ReplicatedStorage:FindFirstChild("Packages")
            net = net and net:FindFirstChild("Net")
            r = net and net:GetChildren()[GRAPPLE_REMOTE]
        end
        if r then for _ = 1, 3 do r:FireServer(0.33) end end
    end)
    if not fired then setStatus("Grapple remote failed — continuing") end
    return true
end

------------------------------------------------------------
-- HEATSEEKER: detect its remote on load, then fire it + ride the missile
------------------------------------------------------------
local heat = { state = "pending", remote = nil, method = nil }
local function detectHeat()
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function" then heat.state = "failed" return end
    local tool = equip(HEAT_TOOL)
    if not tool then heat.state = "failed" print("[Eclipse] no " .. HEAT_TOOL .. " — using the grapple + carpet flight") return end
    task.wait(HEAT_PRE_WAIT)
    local captured
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    local firstAny
    mt.__namecall = (newcclosure or function(f) return f end)(function(self, ...)
        if not captured then
            local m = getnamecallmethod()
            if (m == "FireServer" or m == "InvokeServer") and typeof(self) == "Instance" then
                local a1 = ...
                if typeof(a1) == "Instance" and a1:IsA("Player") then
                    captured = { remote = self, method = m }      -- the Heatseeker fires with a Player arg
                elseif not firstAny then
                    firstAny = { remote = self, method = m }      -- kept only as a last resort
                end
            end
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
    pcall(function() tool:Activate() end)
    local t0 = os.clock()
    while not captured and os.clock() - t0 < HEAT_SPY do RunService.Heartbeat:Wait() end
    if not captured then captured = firstAny end
    setreadonly(mt, false)
    mt.__namecall = old
    setreadonly(mt, true)
    pcall(function() local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h then h:UnequipTools() end end)
    if captured then
        heat.remote, heat.method, heat.state = captured.remote, captured.method, "ready"
        print("[Eclipse] Heatseeker remote: " .. captured.remote.Name .. " (" .. captured.method .. ")")
    else
        heat.state = "failed"
        print("[Eclipse] Heatseeker remote not seen — using the grapple + carpet flight")
    end
end
local function heatReady() return heat.state == "ready" and heat.remote and heat.remote.Parent ~= nil end

-- equip Heatseeker, fire its remote instantly, then teleport your missile onto you every heartbeat.
-- Returns true the heartbeat the missile disappears; false if cancelled / it never showed up.
-- hold the Giant Potion and use it (returns true if it was found)
local function useGiant()
    local pot = equip(POTION_TOOL)
    if not pot then return false end
    if pot.Parent ~= LP.Character then pcall(function() pot.Parent = LP.Character end) end
    pcall(function() pot:Activate() end)
    return true
end

local function rideMissile(stillOk)
    local ch = LP.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local parts = {}
    local function consider(d)
        if d.Name == MISSILE_NAME and d:IsA("BasePart") then parts[d] = true end
    end
    local watch = Workspace.DescendantAdded:Connect(function(d)
        consider(d)
        if not parts[d] and d:IsA("BasePart") then task.defer(consider, d) end   -- named right after spawning
    end)
    local tool = equip(HEAT_TOOL)
    if heat.method == "InvokeServer" then
        task.spawn(function() pcall(function() heat.remote:InvokeServer(LP) end) end)
    else
        pcall(function() heat.remote:FireServer(LP) end)
    end
    local backupDone = false
    setStatus("Rocket fired — riding the missile")
    task.spawn(function()                 -- start sequence: wait, hold Giant Potion, wait, use it, wait, hold carpet
        task.wait(GIANT_AFTER_FIRE)
        if not stillOk() then return end
        local pot = equip(POTION_TOOL)
        task.wait(0.05)
        if not stillOk() then return end
        if pot then
            if pot.Parent ~= LP.Character then pcall(function() pot.Parent = LP.Character end) end
            pcall(function() pot:Activate() end)
        end
        task.wait(0.05)
        if stillOk() then equip(FLY_TOOL) end
    end)
    local t0, seen = os.clock(), false
    while true do
        if not stillOk() then watch:Disconnect() return false end
        local found = false
        for p in pairs(parts) do
            if p.Parent and p:IsDescendantOf(Workspace) then
                found = true
                if hrp.Parent then pcall(function() p.CFrame = hrp.CFrame end) end
            else
                parts[p] = nil
            end
        end
        if found then seen = true end
        if not seen and not backupDone and os.clock() - t0 > HEAT_BACKUP_AFTER then
            -- no missile yet: use the Heatseeker itself (the game's own fire path) and do one full scan
            backupDone = true
            if tool then
                if tool.Parent ~= LP.Character then equip(HEAT_TOOL) end
                pcall(function() tool:Activate() end)
            end
            for _, d in ipairs(Workspace:GetDescendants()) do consider(d) end
        end
        if seen and not found then watch:Disconnect() return true end
        if not seen and os.clock() - t0 > MISSILE_WAIT then watch:Disconnect() return false end
        RunService.Heartbeat:Wait()
    end
end

------------------------------------------------------------
-- CLONE SPOTS: where you go after the missile. Left side faces world-left (-X), right side world-right (+X).
------------------------------------------------------------
local LEFT, RIGHT = Vector3.new(-1, 0, 0), Vector3.new(1, 0, 0)
local CLONE_HIGH = {
    { pos = Vector3.new(-479.779, 20.048, 222.593), dir = LEFT },
    { pos = Vector3.new(-479.100, 20.041, 113.336), dir = LEFT },
    { pos = Vector3.new(-479.488, 20.102, 5.876),   dir = LEFT },
    { pos = Vector3.new(-480.002, 20.025, -99.477), dir = LEFT },
    { pos = Vector3.new(-338.870, 20.025, -100.643), dir = RIGHT },
    { pos = Vector3.new(-339.737, 19.925, 5.836),    dir = RIGHT },
    { pos = Vector3.new(-340.012, 17.039, 112.921),  dir = RIGHT },
    { pos = Vector3.new(-340.094, 19.756, 221.856),  dir = RIGHT },
}
-- LOW: two stops each. fly to `first`, then straight on to `pos`, then the cloner. All face world-backward (+Z).
local FORWARD = Vector3.new(0, 0, 1)
local LOW_STEP_WAIT = 0.1
local CLONE_LOW = {
    { first = Vector3.new(-471.391, -7.098, 186.084),  pos = Vector3.new(-486.759, -3.699, 196.624),  dir = FORWARD },
    { first = Vector3.new(-470.383, -7.098, 73.033),   pos = Vector3.new(-487.635, -3.699, 89.588),   dir = FORWARD },
    { first = Vector3.new(-469.804, -7.098, -34.003),  pos = Vector3.new(-487.776, -3.699, -17.357),  dir = FORWARD },
    { first = Vector3.new(-469.461, -7.098, -137.430), pos = Vector3.new(-486.777, -3.633, -124.378), dir = FORWARD },
    { first = Vector3.new(-346.809, -7.098, 184.799),  pos = Vector3.new(-331.894, -3.699, 196.613),  dir = FORWARD },
    { first = Vector3.new(-347.508, -7.098, 77.025),   pos = Vector3.new(-331.417, -3.699, 89.589),   dir = FORWARD },
    { first = Vector3.new(-348.473, -7.098, -26.797),  pos = Vector3.new(-331.582, -3.699, -17.359),  dir = FORWARD },
    { first = Vector3.new(-347.132, -7.098, -137.404), pos = Vector3.new(-332.131, -3.633, -124.410), dir = FORWARD },
}
local CLONER_TOOL     = "Quantum Cloner"
local MISSILE_GONE_WAIT = 0.1   -- after the missile disappears: wait this long before activating the carpet
local FLY_LIFT        = 10      -- tp this far up after activating the carpet, and fly this far above each stop
local CLONE_FLY_SPEED = 160     -- fly to the clone spot at this speed
local CLONE_FLY_TIMEOUT = 10    -- give up the fly-to-spot after this many seconds
local CLONER_WAIT     = 0.4     -- at the clone spot (after the tp down): wait, then hold the Quantum Cloner
local CLONER_USE_WAIT = 0.05    -- holding the cloner: wait, then use it
local CLONE_ARM_FOR   = 20      -- after cloning, keep watching this long for you to enter the StealHitbox
local CLONE_BTN_WAIT  = 0.05    -- after using it: wait, then press the game's "Teleport To Clone" button
local CLONE_TRIES     = 3       -- if you didn't move, put you back and try the clone again (up to this many times)
local CLONE_MOVE_WAIT = 3       -- how long to wait for the clone teleport to move you before retrying

-- press PlayerGui.ToolsFrames.QuantumCloner.TeleportToClone the way the game does (its own handler fires
-- the clone remote with the right args). Returns false if the button isn't there.
local function pressTeleportToClone()
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    local tf = pg and pg:FindFirstChild("ToolsFrames")
    local qc = tf and tf:FindFirstChild("QuantumCloner")
    local tb = qc and qc:FindFirstChild("TeleportToClone")
    if not tb then return false end
    pcall(function() tb.Visible = true end)
    if type(firesignal) == "function" then
        pcall(function() firesignal(tb.MouseButton1Click) end)
        pcall(function() firesignal(tb.MouseButton1Up) end)
        pcall(function() firesignal(tb.Activated) end)
    elseif type(getconnections) == "function" then
        for _, sig in ipairs({ tb.MouseButton1Click, tb.MouseButton1Up, tb.Activated }) do
            pcall(function() for _, c in ipairs(getconnections(sig)) do pcall(function() c:Fire() end) end end)
        end
    else
        return false
    end
    return true
end

-- high or low floor (same test the flash used: nearest aim spot to the brainrot), then the nearest clone spot
local function pickCloneSpot(b, fallback)
    local brPos
    pcall(function() brPos = b.model:GetPivot().Position end)
    local ref = brPos or fallback
    local aim, ad
    for _, a in ipairs(AIM_SPOTS) do
        local d = (a.pos - ref).Magnitude
        if not ad or d < ad then aim, ad = a, d end
    end
    local high = aim ~= nil and aim.pos.Y > HIGH_Y
    local target = aim and aim.pos or ref
    local best, bd
    for _, c in ipairs(high and CLONE_HIGH or CLONE_LOW) do
        local d = (Vector3.new(c.pos.X, 0, c.pos.Z) - Vector3.new(target.X, 0, target.Z)).Magnitude
        if not bd or d < bd then best, bd = c, d end
    end
    return best, high
end

-- runs the instant the missile is gone: wait 0.5s → activate the Flying Carpet → fly to the clone spot at 600 speed,
-- then cloner + clone remote. From there the StealHitbox watcher takes over (slot detection, under-depth, platform,
-- carpet, grab).
local function cloneSequence(b, my, hrp, bpos)
    local ok = function() return alive and tpRunning and tpToken == my and hrp.Parent ~= nil end
    local c, high = pickCloneSpot(b, bpos)

    -- fly to the clone spot (carpet already held + activated by the lead-in).
    -- LOW floor = two stops: fly to `first`, and the instant it is reached keep flying to `pos`.
    -- every stop is flown FLY_LIFT studs above it; at the last one we tp straight down onto the spot
    local up = Vector3.new(0, FLY_LIFT, 0)
    local route = {}
    if c.first then route[#route + 1] = c.first + up end
    route[#route + 1] = c.pos + up
    local t0 = os.clock()
    for leg, target in ipairs(route) do
        local last = leg == #route
        while ok() do
            if not hrp.Parent then return end
            if os.clock() - t0 > CLONE_FLY_TIMEOUT then break end
            local delta = target - hrp.Position
            local d = delta.Magnitude
            if d <= 3 then break end
            local dt = RunService.Heartbeat:Wait()
            if d <= CLONE_FLY_SPEED * dt then break end
            hrp.AssemblyLinearVelocity = delta.Unit * CLONE_FLY_SPEED
            setStatus(string.format("Flying %s  %d studs left", #route > 1 and ("(" .. leg .. "/" .. #route .. ")") or "", math.floor(d)))
        end
        if not ok() then return end
        if not last then
            -- reached the first stop (10 up): put us exactly on it and go straight on to the next one
            pcall(function() hrp.CFrame = CFrame.new(target) * (hrp.CFrame - hrp.CFrame.Position) end)
        end
    end
    if not ok() then return end

    -- reached the last stop (10 up): tp DOWN onto the clone spot with the correct facing
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = CFrame.lookAt(c.pos, c.pos + c.dir)
    end)
    setStatus((high and "High" or "Low") .. " clone spot (" .. (c.dir == LEFT and "left" or c.dir == RIGHT and "right" or "backward") .. ")")
    task.wait(CLONER_WAIT)
    if not ok() then return end

    local cl = equip(CLONER_TOOL)
    if not cl then stopTp("No " .. CLONER_TOOL .. " in your backpack") return end
    tpGrab(b)                                  -- auto grab starts the moment the cloner is in your hand
    local myPend = { b = b, t = os.clock(), armFor = CLONE_ARM_FOR }
    pending = myPend                           -- arm the StealHitbox watcher (under-brainrot / platform logic)
    task.wait(CLONER_USE_WAIT)
    if not ok() then return end
    local spotCF = CFrame.lookAt(c.pos, c.pos + c.dir)
    local cloned = false
    for attempt = 1, CLONE_TRIES do
        if cl.Parent ~= LP.Character then equip(CLONER_TOOL) end
        pcall(function() cl:Activate() end)
        task.wait(CLONE_BTN_WAIT)
        if not ok() then return end
        local startPos = hrp.Position
        if not pressTeleportToClone() then stopTp("No Teleport To Clone button found") return end
        setStatus(attempt == 1 and "Cloning..." or ("Cloning... retry " .. attempt))
        -- worked = the clone teleport moved you
        local t1 = os.clock()
        while os.clock() - t1 < CLONE_MOVE_WAIT do
            if not ok() then return end
            if (hrp.Position - startPos).Magnitude >= 0.35 then cloned = true break end
            RunService.Heartbeat:Wait()
        end
        if cloned then break end
        if attempt < CLONE_TRIES then              -- didn't move: back on the spot and try again
            task.wait(0.1)
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = spotCF
            end)
        end
    end
    if pending == myPend then myPend.t = os.clock() end   -- restart the window from the clone, not the equip
    stopTp(cloned and "Cloned — waiting for the StealHitbox" or "Clone didn't move you (tried " .. CLONE_TRIES .. "x)")
end

local function teleport()
    if tpRunning then stopTp("Cancelled") cancelGrab() cancelGrabLoop() return end
    cancelGrab() cancelGrabLoop()
    local b = current
    if not (b and b.plot and b.plot.Parent) then setStatus("No brainrot to teleport to") return end
    local bpos = basePosition(b.plot)
    if not bpos then setStatus("Couldn't find that base") return end
    local spot = closestSpot(bpos)

    local ch = LP.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp) or hum.Health <= 0 then setStatus("No character") return end

    tpRunning = true
    tpToken = tpToken + 1
    local my = tpToken
    tpBtn.Text = "CANCEL"
    task.spawn(function()
        local ok = function() return tpRunning and tpToken == my and hrp.Parent ~= nil end
        -- hold the carpet (wait until it is actually in your hand), activate it, wait 0.15s, then fly
        local flyTool = equip(FLY_TOOL)
        local e0 = os.clock()
        while flyTool and flyTool.Parent ~= LP.Character and os.clock() - e0 < 0.5 do
            RunService.Heartbeat:Wait()
            if not ok() then return end
            flyTool = equip(FLY_TOOL) or flyTool
        end
        if not ok() then return end
        if flyTool then pcall(function() flyTool:Activate() end) end
        setStatus("Carpet up — flying")
        task.wait(0.15)
        if not ok() then return end
        -- tp FLY_LIFT studs straight up, then fly the whole route at that height
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = hrp.CFrame + Vector3.new(0, FLY_LIFT, 0)
        end)
        cloneSequence(b, my, hrp, bpos)                       -- fly at CLONE_FLY_SPEED to the clone spot, then the cloner
    end)
end

local hbCache = setmetatable({}, { __mode = "k" })
local function hitboxOf(plot)
    local h = hbCache[plot]
    if h and h.Parent then return h end
    h = plot:FindFirstChild(HITBOX_NAME, true)
    if h and h:IsA("BasePart") then hbCache[plot] = h return h end
    return nil
end
local function inside(part, pos)
    local p = part.CFrame:PointToObjectSpace(pos)
    local hs = part.Size * 0.5
    return math.abs(p.X) <= hs.X and math.abs(p.Y) <= hs.Y and math.abs(p.Z) <= hs.Z
end

local function landingOn(model, ch)
    local pivot = model:GetPivot().Position
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local stand = ((hum and hum.HipHeight) or 2) + ((hrp and hrp.Size.Y) or 2) * 0.5
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { model, ch }
    local hit = Workspace:Raycast(pivot + Vector3.new(0, 3, 0), Vector3.new(0, -40, 0), params)
    local groundY = hit and hit.Position.Y or (pivot.Y - 1)
    return Vector3.new(pivot.X, groundY + stand, pivot.Z)
end

on(RunService.Heartbeat, function()
    local pd = pending
    if not pd then return end
    if os.clock() - pd.t > (pd.armFor or HITBOX_ARM_FOR) then pending = nil setStatus("Didn't reach the StealHitbox") return end
    local b = pd.b
    local ch = LP.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not (b.model.Parent and b.plot.Parent) then pending = nil setStatus(b.display .. " is gone") return end
    if not (hrp and hum and hum.Health > 0) then return end
    local hb = hitboxOf(b.plot)
    if not (hb and inside(hb, hrp.Position)) then return end
    pending = nil
    if tpRunning then stopTp() end
    equip(FLY_TOOL)
    setStatus("In hitbox — flying to " .. b.display)
    task.delay(HITBOX_DELAY, function()
        if not (alive and hrp.Parent and hum.Health > 0 and b.model.Parent) then return end
        local ok, dest = pcall(landingOn, b.model, LP.Character)
        if not (ok and dest) then return end
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        local look = hrp.CFrame.LookVector
        look = Vector3.new(look.X, 0, look.Z)
        if look.Magnitude < 0.01 then look = Vector3.new(0, 0, -1) end

        -- fly (not tp) at HITBOX_FLY_SPEED to `target`; noclip while flying so it can go
        -- through the floor to the under-brainrot spot; lands exactly on it, facing `look`
        local function flyTo(target)
            local ch = LP.Character
            local saved = {}   -- each part's ORIGINAL CanCollide, restored exactly after the flight
            local noclip = RunService.Stepped:Connect(function()
                if not ch then return end
                for _, p in ipairs(ch:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then
                        if saved[p] == nil then saved[p] = true end
                        p.CanCollide = false
                    end
                end
            end)
            liftActive = true   -- keeps CARPET SPEED / anti-fling from touching our velocity
            local limit = os.clock() + (target - hrp.Position).Magnitude / HITBOX_FLY_SPEED + 2
            while alive and hrp.Parent and hum.Health > 0 and os.clock() < limit do
                local delta = target - hrp.Position
                local d = delta.Magnitude
                if d <= 1 then break end
                hrp.AssemblyAngularVelocity = Vector3.zero
                hrp.AssemblyLinearVelocity = delta.Unit * math.min(HITBOX_FLY_SPEED, d * 30)
                setStatus(string.format("Flying to %s  %d studs", b.display, math.floor(d)))
                RunService.Heartbeat:Wait()
            end
            noclip:Disconnect()
            liftActive = false
            if not (alive and hrp.Parent) then return false end
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.lookAt(target, target + look.Unit)
            -- put back only what was colliding before (legs/arms/accessories stay non-colliding)
            for p in pairs(saved) do
                if p.Parent and p.Name ~= "Head" then pcall(function() p.CanCollide = true end) end
            end
            return true
        end

        local slotN = tonumber(b.slot)
        if slotN and slotN >= LIFT_SLOT_MIN and slotN <= LIFT_SLOT_MAX then

            local spot = dest - Vector3.new(0, UNDER_DEPTH, 0)
            if not flyTo(spot) then return end

            task.delay(0.01, function()
                if not (alive and hrp.Parent) then return end
                local hum2 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                local pos = hrp.Position
                local land = Instance.new("Part")
                land.Name = "EclipseLandPlatform"
                land.Size = Vector3.new(14, 1, 14)
                land.Anchored = true
                land.CanCollide = true
                land.Transparency = 1
                land.CFrame = CFrame.new(pos.X, pos.Y - 3.15, pos.Z)
                land.Parent = Workspace
                tpLanded = os.clock()   -- platform started: the grab may now fire from under the floor
                local v = hrp.AssemblyLinearVelocity
                if v.Y < 0 then hrp.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z) end
                if hum2 then
                    pcall(function()
                        hum2:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        hum2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                        hum2:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                    end)
                end
                local t0 = os.clock()
                while alive and land.Parent and os.clock() - t0 < LIFT_TIME do
                    if LP:GetAttribute("Stealing") == true then break end
                    RunService.Heartbeat:Wait()
                end
                pcall(function() land:Destroy() end)
                if hum2 then
                    pcall(function()
                        hum2:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                        hum2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                        hum2:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                    end)
                end
            end)
            setStatus("On " .. b.display .. " — grabbing")
            return
        end
        if not flyTo(dest) then return end
        tpLanded = os.clock()   -- flew ONTO the brainrot
        setStatus("On " .. b.display .. " — grabbing")
    end)
end)

do
    local AR = { conns = {}, acs = nil, acsChar = nil, rootAC = nil }
    local function holdingCarpet(ch)
        if not ch then return false end
        for _, t in ipairs(ch:GetChildren()) do
            if t:IsA("Tool") and (t.Name == FLY_TOOL or t.Name:find("Carpet") or t.Name:find("Broom") or t.Name:find("Wings")
                or t.Name:find("Sleigh") or t.Name:find("Waverider")) then return true end
        end
        return false
    end
    local function busy() return tpRunning or liftActive or pending ~= nil end

    local function anyACDisabled(ch)
        if not ch then return false end
        if AR.acsChar ~= ch or not AR.acs then
            AR.acsChar, AR.acs, AR.rootAC = ch, {}, nil
            for _, d in ipairs(ch:GetDescendants()) do
                if d:IsA("AnimationConstraint") then
                    table.insert(AR.acs, d)
                    if d.Name == "Root" then AR.rootAC = d end
                end
            end
        end
        for _, ac in ipairs(AR.acs) do
            if ac.Parent and not ac.Enabled then return true end
        end
        return false
    end
    local LAUNCH = {
        BodyVelocity = true, BodyForce = true, BodyThrust = true, BodyGyro = true,
        BodyAngularVelocity = true, VectorForce = true, AngularVelocity = true, RocketPropulsion = true,
    }
    local function considerLaunch(d)
        if not d or not d.Parent then return false end
        local ch = LP.Character
        if busy() or holdingCarpet(ch) then return false end
        local cn = d.ClassName
        local launch = LAUNCH[cn] == true or cn == "LinearVelocity"
        if not launch and (cn:find("Force") or cn:find("Velocity") or cn:find("Body") or cn:find("Propulsion")) then
            if d.Name:find("Impulse") or d.Name:find("Knockback") or d.Name:find("Launch") then launch = true end
        end
        if launch then pcall(function() d:Destroy() end) return true end
        return false
    end
    local function stripLaunchForces(ch)
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, d in ipairs(root:GetChildren()) do considerLaunch(d) end
    end
    local function controls(enable)
        pcall(function()
            local ps = LP:FindFirstChild("PlayerScripts")
            local pm = ps and ps:FindFirstChild("PlayerModule")
            if pm then
                local c = require(pm):GetControls()
                if enable then c:Enable() else c:Disable() end
            end
        end)
    end
    local function cleanRagdoll(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        pcall(function()
            if hum then
                hum.PlatformStand = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
                local st = hum:GetState()
                if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
                    or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.PlatformStanding then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end)
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BallSocketConstraint") then
                pcall(function() d:Destroy() end)
            elseif d:IsA("AnimationConstraint") and not d.Enabled then
                pcall(function() d.Enabled = true end)
            end
        end
        local rootAC = AR.rootAC
        if rootAC and rootAC.Parent and (rootAC.Attachment0 == nil or not rootAC.Attachment0.Parent) then
            local rra = hrp and hrp:FindFirstChild("RootRigAttachment")
            if rra then pcall(function() rootAC.Attachment0 = rra end) end
        end
        stripLaunchForces(char)
        if hrp then pcall(function() hrp.AssemblyAngularVelocity = Vector3.zero end) end
        controls(true)
        pcall(function() LP:SetAttribute("RagdollEndTime", nil) end)
    end

    local function killSource()
        if typeof(getconnections) ~= "function" then return end
        pcall(function()
            local pkg = ReplicatedStorage:FindFirstChild("Packages")
            local net = pkg and pkg:FindFirstChild("Net")
            local re = net and net:FindFirstChild("RE/Ragdoll")
            if not re then
                local rag = pkg and pkg:FindFirstChild("Ragdoll")
                re = rag and rag:FindFirstChild("Ragdoll")
            end
            if re and re:IsA("RemoteEvent") then
                for _, c in ipairs(getconnections(re.OnClientEvent)) do
                    if not pcall(function() c:Disable() end) then pcall(function() c:Disconnect() end) end
                end
            end
        end)
    end
    local function unhook()
        for _, c in ipairs(AR.conns) do pcall(function() c:Disconnect() end) end
        AR.conns = {}
    end
    local function hook(char)
        if not (ANTI_RAGDOLL and char) then return end
        unhook()
        killSource()
        cleanRagdoll(char)
        table.insert(AR.conns, LP:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
            local et = LP:GetAttribute("RagdollEndTime")
            if et and (et - Workspace:GetServerTimeNow()) > 0 then cleanRagdoll(LP.Character) end
        end))
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            table.insert(AR.conns, hum.StateChanged:Connect(function(_, s)
                if s == Enum.HumanoidStateType.Physics or s == Enum.HumanoidStateType.Ragdoll
                    or s == Enum.HumanoidStateType.FallingDown or s == Enum.HumanoidStateType.PlatformStanding then
                    cleanRagdoll(char)
                end
            end))
        end
        table.insert(AR.conns, char.DescendantAdded:Connect(function(d)
            if d:IsA("BallSocketConstraint") then
                task.defer(function() pcall(function() d:Destroy() end) end)
            elseif d:IsA("AnimationConstraint") then
                AR.acs = nil
            else
                task.defer(function() considerLaunch(d) end)
            end
        end))
    end

    if ANTI_RAGDOLL then
        if LP.Character then task.spawn(hook, LP.Character) end
        on(LP.CharacterAdded, function(ch)
            pcall(function() ch:WaitForChild("Humanoid", 10) end)
            hook(ch)
            task.spawn(function()
                for _ = 1, 12 do task.wait(0.25) if alive then killSource() else break end end
            end)
        end)
        local lastScan, lastVel = 0, Vector3.zero
        on(RunService.Heartbeat, function()
            local ch = LP.Character
            if not ch then return end
            local et = LP:GetAttribute("RagdollEndTime")
            local ragdolled = et ~= nil and (et - Workspace:GetServerTimeNow()) > 0
            if not ragdolled then
                local hum = ch:FindFirstChildOfClass("Humanoid")
                if hum then
                    local s = hum:GetState()
                    ragdolled = s == Enum.HumanoidStateType.Physics or s == Enum.HumanoidStateType.Ragdoll
                        or s == Enum.HumanoidStateType.PlatformStanding or hum.PlatformStand == true
                end
            end
            if not ragdolled then ragdolled = anyACDisabled(ch) end
            local r = AR.rootAC
            if r and r.Parent and (r.Attachment0 == nil or not r.Attachment0.Parent) then
                local h = ch:FindFirstChild("HumanoidRootPart")
                local rra = h and h:FindFirstChild("RootRigAttachment")
                if rra then pcall(function() r.Attachment0 = rra end) end
            end
            if not ragdolled and tick() - lastScan > 0.2 then
                lastScan = tick()
                ragdolled = ch:FindFirstChildWhichIsA("BallSocketConstraint", true) ~= nil
            end
            if ragdolled then cleanRagdoll(ch) end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp and ragdolled and not busy() and not holdingCarpet(ch) then
                local v = hrp.AssemblyLinearVelocity
                if (v - lastVel).Magnitude > 110 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    v = Vector3.zero
                end
                lastVel = v
            elseif hrp then
                lastVel = hrp.AssemblyLinearVelocity
            end
        end)
    end
end

on(RunService.Stepped, function()
    local ch = LP.Character
    local head = ch and ch:FindFirstChild("Head")
    if head and head:IsA("BasePart") and head.CanCollide then head.CanCollide = false end
end)

do
    local animConns = {}
    local function strip(ch)
        for _, c in ipairs(animConns) do pcall(function() c:Disconnect() end) end
        table.clear(animConns)
        if not ch then return end
        local function kill(o)
            if o.Name == "Animate" and (o:IsA("LocalScript") or o:IsA("Script")) then
                pcall(function() o.Disabled = true end)
                pcall(function() o:Destroy() end)
            end
        end
        for _, o in ipairs(ch:GetChildren()) do kill(o) end
        animConns[#animConns + 1] = ch.ChildAdded:Connect(kill)
        local function hookAnimator(an)
            if not (an and an:IsA("Animator")) then return end
            pcall(function() for _, t in ipairs(an:GetPlayingAnimationTracks()) do t:Stop(0) end end)
            animConns[#animConns + 1] = an.AnimationPlayed:Connect(function(t) pcall(function() t:Stop(0) end) end)
        end
        local hum = ch:FindFirstChildOfClass("Humanoid") or ch:WaitForChild("Humanoid", 5)
        if hum then
            hookAnimator(hum:FindFirstChildOfClass("Animator"))
            animConns[#animConns + 1] = hum.ChildAdded:Connect(hookAnimator)
        end
    end
    task.spawn(strip, LP.Character)
    on(LP.CharacterAdded, function(ch) task.spawn(strip, ch) end)
    conns[#conns + 1] = { Disconnect = function() for _, c in ipairs(animConns) do pcall(function() c:Disconnect() end) end end }
end

tpBtn.MouseButton1Click:Connect(function()
    tpScale.Scale = 0.94
    TweenService:Create(tpScale, TweenInfo.new(0.2, Enum.EasingStyle.Back), { Scale = 1 }):Play()
    teleport()
end)

ENV.__EclipseBestUnload = function()
    alive = false
    tpRunning = false
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    pcall(function() gui:Destroy() end)
end

local function holdGrappleNow()
    task.spawn(function()
        local t0 = os.clock()
        while alive and os.clock() - t0 < 10 do
            if equip(GRAPPLE_TOOL) then return end
            RunService.Heartbeat:Wait()
        end
    end)
end
on(LP.CharacterAdded, function() holdGrappleNow() end)

-- ON LOAD: detect the Heatseeker remote first, then the instant the best brainrot is detected run the
-- TP sequence (rocket mode if the Heatseeker remote was captured, otherwise grapple + carpet)
local giantOnLoad = false
task.spawn(function()
    pcall(_G.EclipseBootWait)   -- Elysium boot wait: gear in the backpack first
    local t0 = os.clock()
    while alive and os.clock() - t0 < 30 do
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            pcall(refreshCurrent)
            if current then
                if not tpRunning then teleport() end
                return
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

if _G.EliteInvisDepth == nil then _G.EliteInvisDepth = tonumber(_G.eliteInvisDepth) or 10 end
if _G.EliteInvisAngle == nil then _G.EliteInvisAngle = tonumber(_G.eliteInvisAngle) or 220 end
_G.EliteInvisDepth = 10
_G.EliteInvisAngle = 220
if _G.EliteInvisAutoDelay == nil then _G.EliteInvisAutoDelay = 0.5 end
_G.EliteInvisAutoDelay = 0.5
if _G.EliteAntiCollisionTP == nil then _G.EliteAntiCollisionTP = true end
if _G.EliteAutoFailover == nil then _G.EliteAutoFailover = true end
if _G.EliteFailoverAttempts == nil then _G.EliteFailoverAttempts = 2 end
if _G.EliteInvisRestartDist == nil then _G.EliteInvisRestartDist = 2.25 end
if _G.EliteInvisRestartWait == nil then _G.EliteInvisRestartWait = 0.5 end
if _G.EliteInvisAutoRecover == nil then _G.EliteInvisAutoRecover = true end
if _G.EliteVoidRecover == nil then _G.EliteVoidRecover = true end
if _G.EliteVoidRecoverDelay == nil then _G.EliteVoidRecoverDelay = 0 end
_G.EliteInvisActive = false
_G.EliteInvisAuto = false
do
local LP = game:GetService("Players").LocalPlayer
local active, conns = false, {}
local realHRP, cloneHRP, track, hip, origT
local stuck, restarting = false, false
local start, stop
local function depth()
return 0.01 + (math.clamp(tonumber(_G.EliteInvisDepth) or 4.2, 0, 10) / 10) * 0.19
end
local function angle()
return math.clamp(tonumber(_G.EliteInvisAngle) or 180, 0, 360)
end
local function add(c) conns[#conns + 1] = c end
local function rewire(char, from, to)
for _, v in ipairs(char:GetDescendants()) do
if v:IsA("Weld") or v:IsA("Motor6D") then
if v.Part0 == from then v.Part0 = to end
if v.Part1 == from then v.Part1 = to end
end
end
end
stop = function()
active, stuck = false, false
for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
conns = {}
if origT then
for p, v in pairs(origT) do
if p and p.Parent then pcall(function() p.LocalTransparencyModifier = v end) end
end
origT = nil
end
if track then
pcall(function() track:AdjustSpeed(1) track:Stop(0) track:Destroy() end)
track = nil
end
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if realHRP and realHRP:IsDescendantOf(game) and hum then
local tmp = Instance.new("Model")
tmp.Parent = game
char.Parent = tmp
realHRP.Parent = char
char.PrimaryPart = realHRP
char.Parent = workspace
realHRP.CanCollide = true
rewire(char, cloneHRP, realHRP)
if cloneHRP then
local at = cloneHRP.CFrame
cloneHRP:Destroy()
cloneHRP = nil
realHRP.CFrame = at
end
hum.HipHeight = hip or 0
tmp:Destroy()
end
realHRP, cloneHRP = nil, nil
_G.EliteInvisActive = false
end
local function animTrick(char, hum)
if not (char and hum and hum.Health > 0) then return end
local a = Instance.new("Animation")
a.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
track = animator:LoadAnimation(a)
track.Priority = Enum.AnimationPriority.Action4
track.Looped = true
track:Play(0, 1, 0)
a:Destroy()
add(track.Stopped:Connect(function()
if active then animTrick(char, hum) end
end))
task.defer(function()
if not track then return end
track.TimePosition = 0.7
task.delay(0.1, function() if track then track:AdjustSpeed(math.huge) end end)
end)
end
start = function()
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not hum or active then return false end
local folder = workspace:FindFirstChild(LP.Name)
if folder then
for _, n in ipairs({ "DoubleRig", "Constraints" }) do
local x = folder:FindFirstChild(n)
if x then x:Destroy() end
end
add(folder.ChildAdded:Connect(function(c)
if c.Name == "DoubleRig" or c.Name == "Constraints" then c:Destroy() end
end))
end
for _, s in ipairs({ "Dead", "FallingDown", "Ragdoll" }) do
hum:SetStateEnabled(Enum.HumanoidStateType[s], false)
end
hip = hum.HipHeight
realHRP = char:FindFirstChild("HumanoidRootPart")
if not (realHRP and realHRP.Parent) then return false end
local tmp = Instance.new("Model")
tmp.Parent = game
char.Parent = tmp
cloneHRP = realHRP:Clone()
cloneHRP.Parent = char
realHRP.Parent = workspace.CurrentCamera
cloneHRP.CFrame = realHRP.CFrame
char.PrimaryPart = cloneHRP
char.Parent = workspace
rewire(char, realHRP, cloneHRP)
tmp:Destroy()
active = true
animTrick(char, hum)
origT = {}
for _, p in ipairs(char:GetDescendants()) do
if p:IsA("BasePart") then
origT[p] = p.LocalTransparencyModifier
p.LocalTransparencyModifier = 1
end
end
add(char.DescendantAdded:Connect(function(d)
if not (active and d:IsA("BasePart")) then return end
if origT and origT[d] == nil then origT[d] = d.LocalTransparencyModifier end
pcall(function() d.LocalTransparencyModifier = 1 end)
end))
add(RunService.Heartbeat:Connect(function()
if not active or not hum.Parent then return end
hum.Health = hum.MaxHealth
hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
local st = hum:GetState()
if st == Enum.HumanoidStateType.Dead or st == Enum.HumanoidStateType.FallingDown
or st == Enum.HumanoidStateType.Ragdoll then
hum:ChangeState(Enum.HumanoidStateType.Running)
end
end))
local lastTarget, grace = nil, 60
add(RunService.PreSimulation:Connect(function()
if not (active and realHRP and hum.Health > 0) then return end
local base = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
if not base then return end
if grace > 0 then
grace = grace - 1
elseif _G.EliteInvisAutoRecover ~= false and not stuck and lastTarget
and (realHRP.Position - lastTarget).Magnitude
> (tonumber(_G.EliteInvisRestartDist) or 2.25) then
stuck = true
if not restarting then
task.spawn(function()
restarting = true
stop()
task.wait(tonumber(_G.EliteInvisRestartWait) or 0.5)
restarting = false
start()
end)
end
end
local cf = base.CFrame
- Vector3.new(0, hum.HipHeight + (base.Size.Y / 2) - 1 + depth(), 0)
realHRP.CFrame = cf * CFrame.Angles(math.rad(angle()), 0, 0)
realHRP.AssemblyLinearVelocity = base.AssemblyLinearVelocity
realHRP.CanCollide = false
if realHRP.Parent ~= workspace.CurrentCamera then
realHRP.Parent = workspace.CurrentCamera
end
lastTarget = cf.Position
end))
add(LP.CharacterAdded:Connect(function() if active then stop() end end))
_G.EliteInvisActive = true
return true
end
_G.EliteInvisStart = function() return start() end
_G.EliteInvisStop = function() return stop() end
_G.EliteInvisToggle = function()
if active then stop() else start() end
return active
end
local armed, autoOn = false, false
local function syncAuto()
local want = (_G.EliteInvisAuto == true) and (LP:GetAttribute("Stealing") == true)
if not want then
armed = false
if active and autoOn then autoOn = false pcall(stop) end
return
end
if active or armed then return end
armed = true
task.delay(tonumber(_G.EliteInvisAutoDelay) or 1.5, function()
armed = false
if _G.EliteInvisAuto == true and not active
and LP:GetAttribute("Stealing") == true then
autoOn = true
pcall(start)
end
end)
end
_G.EliteInvisSync = syncAuto
LP:GetAttributeChangedSignal("Stealing"):Connect(syncAuto)
end
_G.Elite_InvStealSet = function(on)
_G.EliteInvisAuto = on and true or false
if _G.EliteInvisSync then pcall(_G.EliteInvisSync) end
end

do
    _G.EliteInvisAngle = tonumber(CFG.invAngle) or 220
    _G.EliteInvisDepth = tonumber(CFG.invDepth) or 10

    invFrame = new("Frame", { Name = "InvisPanel", Size = UDim2.fromOffset(190, 184),
        Position = (type(CFG.invPos) == "table" and #CFG.invPos == 4) and UDim2.new(CFG.invPos[1], CFG.invPos[2], CFG.invPos[3], CFG.invPos[4])
            or UDim2.new(0, 16, 0, 90), BackgroundColor3 = C.WHITE, BackgroundTransparency = 0.28,
        BorderSizePixel = 0, Active = true }, gui)
    round(invFrame, 12)
    new("UIGradient", { Rotation = 90, Color = ColorSequence.new(C.TOP, C.WIN) }, invFrame)
    stroke(invFrame, C.WHITE, 1.2)
    local invScale = new("UIScale", { Scale = scale.Scale }, invFrame)

    local it = text(invFrame, "INVIS", 11, Enum.FontWeight.Bold, C.DIM)
    it.Position = UDim2.fromOffset(12, 8) it.Size = UDim2.new(1, -24, 0, 12)
    new("Frame", { Position = UDim2.new(0, 10, 0, 24), Size = UDim2.new(1, -20, 0, 1), BackgroundColor3 = C.SEP, BorderSizePixel = 0 }, invFrame)

    local row = new("TextButton", { Position = UDim2.new(0, 10, 0, 32), Size = UDim2.new(1, -20, 0, 28), BackgroundColor3 = C.ELEM,
        BackgroundTransparency = 0.2, BorderSizePixel = 0, AutoButtonColor = false, Text = "" }, invFrame)
    round(row, 8) stroke(row)
    local rl = text(row, "INV STEAL", 12, Enum.FontWeight.Bold, C.WHITE)
    rl.Position = UDim2.fromOffset(10, 0) rl.Size = UDim2.new(1, -60, 1, 0)
    local track = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(34, 18),
        BackgroundColor3 = C.SEP, BorderSizePixel = 0 }, row)
    round(track, 9)
    local knob = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = C.WHITE, BorderSizePixel = 0 }, track)
    round(knob, 6)
    local invOn = false
    local function setInv(v, save)
        invOn = v
        pcall(function() _G.Elite_InvStealSet(invOn) end)
        TweenService:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = invOn and C.WHITE or C.SEP }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), { Position = UDim2.new(0, invOn and 19 or 3, 0.5, 0),
            BackgroundColor3 = invOn and C.WIN or C.WHITE }):Play()
        if save then CFG.invis = invOn saveCfg() end
    end
    setInv(CFG.invis == true, false)
    row.MouseButton1Click:Connect(function() setInv(not invOn, true) end)

    local sliders = {}
    local function mkSlider(y, label, minV, maxV, get, set, fmt)
        local holder = new("Frame", { Position = UDim2.new(0, 10, 0, y), Size = UDim2.new(1, -20, 0, 30), BackgroundTransparency = 1 }, invFrame)
        local lab = text(holder, "", 11, Enum.FontWeight.Bold, C.TEXT)
        lab.Size = UDim2.new(1, 0, 0, 14)
        local bar = new("Frame", { Position = UDim2.fromOffset(0, 19), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = C.ELEM,
            BorderSizePixel = 0 }, holder)
        round(bar, 3)
        local fill = new("Frame", { Size = UDim2.new(0.5, 0, 1, 0), BackgroundColor3 = C.WHITE, BorderSizePixel = 0 }, bar)
        round(fill, 3)
        local s = { dragging = false, bar = bar, minV = minV, maxV = maxV }
        function s.apply(v, save)
            v = math.clamp(tonumber(v) or minV, minV, maxV)
            set(v, save)
            fill.Size = UDim2.new((v - minV) / (maxV - minV), 0, 1, 0)
            lab.Text = label .. ":  " .. fmt(v)
        end
        function s.fromX(x, save)
            local rel = math.clamp((x - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
            s.apply(minV + (maxV - minV) * rel, save)
        end
        bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                s.dragging = true
                s.fromX(i.Position.X, false)
            end
        end)
        s.apply(get(), false)
        sliders[#sliders + 1] = s
        return s
    end
    local rot = mkSlider(66, "Rotation", 0, 360, function() return _G.EliteInvisAngle end, function(v, save)
        _G.EliteInvisAngle = v
        if save then CFG.invAngle = v saveCfg() end
    end, function(v) return tostring(math.floor(v + 0.5)) end)
    mkSlider(100, "Depth", 0, 10, function() return _G.EliteInvisDepth end, function(v, save)
        _G.EliteInvisDepth = v
        if save then CFG.invDepth = v saveCfg() end
    end, function(v) return string.format("%.1f", v) end)

    local function preset(x, deg)
        local b = new("TextButton", { Position = UDim2.new(0, x, 0, 138), Size = UDim2.new(0.5, -15, 0, 26), BackgroundColor3 = C.ELEM,
            BackgroundTransparency = 0.2, BorderSizePixel = 0, AutoButtonColor = false, Text = tostring(deg), TextSize = 12,
            TextColor3 = C.WHITE, FontFace = Font.new(FAMILY, Enum.FontWeight.Bold) }, invFrame)
        round(b, 8) stroke(b)
        b.MouseButton1Click:Connect(function() rot.apply(deg, true) end)
    end
    preset(10, 180)
    do
        local b2 = new("TextButton", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 138), Size = UDim2.new(0.5, -15, 0, 26),
            BackgroundColor3 = C.ELEM, BackgroundTransparency = 0.2, BorderSizePixel = 0, AutoButtonColor = false, Text = "220",
            TextSize = 12, TextColor3 = C.WHITE, FontFace = Font.new(FAMILY, Enum.FontWeight.Bold) }, invFrame)
        round(b2, 8) stroke(b2)
        b2.MouseButton1Click:Connect(function() rot.apply(220, true) end)
    end
    local hint = text(invFrame, "I = manual invis", 9, Enum.FontWeight.Medium, C.FAINT)
    hint.Position = UDim2.fromOffset(12, 168) hint.Size = UDim2.new(1, -24, 0, 12)

    UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            for _, s in ipairs(sliders) do if s.dragging then s.fromX(i.Position.X, false) end end
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            for _, s in ipairs(sliders) do
                if s.dragging then
                    s.dragging = false
                    s.fromX(i.Position.X, true)
                end
            end
        end
    end)

    on(UserInputService.InputBegan, function(i, gp)
        if gp then return end
        if i.KeyCode == Enum.KeyCode.I then pcall(function() _G.EliteInvisToggle() end) end
    end)

    local dragging, startP, startPos
    invFrame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            for _, s in ipairs(sliders) do if s.dragging then return end end
            dragging, startP, startPos = true, i.Position, invFrame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End and dragging then
                    dragging = false
                    local p = invFrame.Position
                    CFG.invPos = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
                    saveCfg()
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = (i.Position - startP) / math.max(invScale.Scale, 0.01)
            invFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

do
    local flyingLoop
    local function stopFlying()
        if flyingLoop then pcall(function() flyingLoop:Disconnect() end) flyingLoop = nil end
    end
    on(LP.CharacterAdded, function() stopFlying() end)

    local function hasCeilingAbove()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { char }
        params.IgnoreWater = true
        return Workspace:Raycast(hrp.Position + Vector3.new(0, 2, 0), Vector3.new(0, 30, 0), params) ~= nil
    end
    local RESET_FLY_SPEED = 2974384
    local function startInfiniteFly()
        stopFlying()
        flyingLoop = RunService.Heartbeat:Connect(function()
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, RESET_FLY_SPEED, 0) end) end
        end)
    end
    local function teleportUp()
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 200000, 0)
    end
    local function destroyCharacterBody(char)
        if not char then return end
        for _, child in ipairs(char:GetDescendants()) do pcall(function() child:Destroy() end) end
        pcall(function() char.Parent = nil end)
    end
    local function fireRespawnRemotes()
        for _, name in ipairs({ "PlayerRespawn", "Respawn", "ResetCharacter", "Reset", "ForceRespawn", "CharacterRespawn" }) do
            local r = ReplicatedStorage:FindFirstChild(name)
            if r and r:IsA("RemoteEvent") then pcall(function() r:FireServer() end) end
        end
    end
    local function ultimateRespawn()
        fireRespawnRemotes()
        destroyCharacterBody(LP.Character)
        if pcall(function() LP:LoadCharacter() end) then return end
        local t0 = tick()
        while tick() - t0 < 10 do
            task.wait(0.5)
            if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then return end
            pcall(function() LP:LoadCharacter() end)
            fireRespawnRemotes()
        end
    end
    local function doReset()
        if tpRunning then stopTp("Reset") end
        cancelGrab() cancelGrabLoop()
        pcall(function() if _G.EliteInvisStop then _G.EliteInvisStop() end end)
        equip(FLY_TOOL)
        if hasCeilingAbove() then
            startInfiniteFly()
        else
            teleportUp()
            task.wait(0.20)
            ultimateRespawn()
        end
    end

    local rf = new("Frame", { Name = "ActionsPanel", Size = UDim2.fromOffset(190, 194),
        Position = (type(CFG.resetPos) == "table" and #CFG.resetPos == 4) and UDim2.new(CFG.resetPos[1], CFG.resetPos[2], CFG.resetPos[3], CFG.resetPos[4])
            or UDim2.new(invFrame.Position.X.Scale, invFrame.Position.X.Offset, invFrame.Position.Y.Scale,
                invFrame.Position.Y.Offset + math.floor(184 * scale.Scale) + 8), BackgroundColor3 = C.WHITE, BackgroundTransparency = 0.28,
        BorderSizePixel = 0, Active = true }, gui)
    resetFrame = rf
    round(rf, 12)
    new("UIGradient", { Rotation = 90, Color = ColorSequence.new(C.TOP, C.WIN) }, rf)
    stroke(rf, C.WHITE, 1.2)
    local rScale = new("UIScale", { Scale = scale.Scale }, rf)
    local at = text(rf, "ACTIONS", 11, Enum.FontWeight.Bold, C.DIM)
    at.Position = UDim2.fromOffset(12, 8) at.Size = UDim2.new(1, -24, 0, 12)
    new("Frame", { Position = UDim2.new(0, 10, 0, 24), Size = UDim2.new(1, -20, 0, 1), BackgroundColor3 = C.SEP, BorderSizePixel = 0 }, rf)
    local btn = new("TextButton", { Position = UDim2.fromOffset(10, 32), Size = UDim2.new(1, -20, 0, 32), BackgroundColor3 = C.WHITE,
        BackgroundTransparency = 0.05, BorderSizePixel = 0, AutoButtonColor = false, Text = "RESET", TextSize = 14,
        TextColor3 = C.WIN, FontFace = Font.new(FAMILY, Enum.FontWeight.Bold) }, rf)
    round(btn, 9)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.25 }):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.05 }):Play() end)
    btn.MouseButton1Click:Connect(function() task.spawn(doReset) end)

    -- MANUAL GRAB toggle: while on, keeps grabbing the nearest brainrot (start -> 0.55 -> end)
    local gRow = new("TextButton", { Position = UDim2.fromOffset(10, 70), Size = UDim2.new(1, -20, 0, 30), BackgroundColor3 = C.ELEM,
        BackgroundTransparency = 0.2, BorderSizePixel = 0, AutoButtonColor = false, Text = "" }, rf)
    round(gRow, 9) stroke(gRow)
    local gL = text(gRow, "MANUAL GRAB", 12, Enum.FontWeight.Bold, C.WHITE)
    gL.Position = UDim2.fromOffset(10, 0) gL.Size = UDim2.new(1, -60, 1, 0)
    local gTrack = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(34, 18),
        BackgroundColor3 = C.SEP, BorderSizePixel = 0 }, gRow)
    round(gTrack, 9)
    local gKnob = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = C.WHITE, BorderSizePixel = 0 }, gTrack)
    round(gKnob, 6)
    gRow.MouseButton1Click:Connect(function()
        manualOn = not manualOn
        gL.Text = manualOn and "MANUAL GRAB  ON" or "MANUAL GRAB"
        TweenService:Create(gTrack, TweenInfo.new(0.15), { BackgroundColor3 = manualOn and C.WHITE or C.SEP }):Play()
        TweenService:Create(gKnob, TweenInfo.new(0.15), { Position = UDim2.new(0, manualOn and 19 or 3, 0.5, 0),
            BackgroundColor3 = manualOn and C.WIN or C.WHITE }):Play()
        if manualOn then manualGrabLoop() end
    end)

    -- manual-grab progress bar (fills over the 0.55s, Aurora-style)
    local barBg = new("Frame", { Position = UDim2.fromOffset(10, 104), Size = UDim2.new(1, -20, 0, 8),
        BackgroundColor3 = C.ELEM, BackgroundTransparency = 0.2, BorderSizePixel = 0 }, rf)
    round(barBg, 4) stroke(barBg)
    grabBarFill = new("Frame", { Position = UDim2.fromOffset(0, 0), Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = C.WHITE, BorderSizePixel = 0 }, barBg)
    round(grabBarFill, 4)

    -- CARPET SPEED (Aurora): while you hold a carpet and aren't stealing, you move at CARPET_SPEED
    local CARPET_SPEED = tonumber(CFG.carpetSpeed) or 130
    local CARPETS = { [FLY_TOOL] = true, ["Flying Carpet"] = true, ["Cupid's Wings"] = true, ["Witch's Broom"] = true,
        ["Waverider"] = true, ["Santa's Sleigh"] = true, ["Carpet"] = true }
    local carpetOn = CFG.carpet == true
    local cRow = new("TextButton", { Position = UDim2.fromOffset(10, 120), Size = UDim2.new(1, -20, 0, 30), BackgroundColor3 = C.ELEM,
        BackgroundTransparency = 0.2, BorderSizePixel = 0, AutoButtonColor = false, Text = "" }, rf)
    round(cRow, 9) stroke(cRow)
    local cL = text(cRow, "CARPET SPEED", 12, Enum.FontWeight.Bold, C.WHITE)
    cL.Position = UDim2.fromOffset(10, 0) cL.Size = UDim2.new(1, -60, 1, 0)
    local cTrack = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(34, 18),
        BackgroundColor3 = C.SEP, BorderSizePixel = 0 }, cRow)
    round(cTrack, 9)
    local cKnob = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = C.WHITE, BorderSizePixel = 0 }, cTrack)
    round(cKnob, 6)
    local function paintCarpet()
        cL.Text = carpetOn and ("CARPET SPEED  " .. CARPET_SPEED) or "CARPET SPEED"
        TweenService:Create(cTrack, TweenInfo.new(0.15), { BackgroundColor3 = carpetOn and C.WHITE or C.SEP }):Play()
        TweenService:Create(cKnob, TweenInfo.new(0.15), { Position = UDim2.new(0, carpetOn and 19 or 3, 0.5, 0),
            BackgroundColor3 = carpetOn and C.WIN or C.WHITE }):Play()
    end
    paintCarpet()
    cRow.MouseButton1Click:Connect(function()
        carpetOn = not carpetOn
        CFG.carpet = carpetOn saveCfg()
        paintCarpet()
    end)

    -- ── CARPET BYPASS ─────────────────────────────────────────────
    -- activates the Flying Carpet the instant it lands in the character,
    -- then strips its own FlightHold / FlightPower / FlightSpin forces
    -- so the script keeps full control of HRP velocity.
    local CARPET_TOOL_NAMES  = { [FLY_TOOL] = true, ["Flying Carpet"] = true }
    local CARPET_FORCE_NAMES = { FlightHold = true, FlightPower = true, FlightSpin = true }

    local function sweepCarpetHRP(hrp)
        if not hrp then return end
        for _, o in ipairs(hrp:GetChildren()) do
            if CARPET_FORCE_NAMES[o.Name] then pcall(function() o:Destroy() end) end
        end
    end
    local function killSit(hum)
        if not hum then return end
        pcall(function()
            for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
                if t.Name:lower():find("sit") then pcall(function() t:Stop(0) end) end
            end
        end)
    end
    local function tryActivateCarpet(tool)
        if not (tool and tool:IsA("Tool") and CARPET_TOOL_NAMES[tool.Name]) then return end
        local ch = LP.Character
        if ch then
            sweepCarpetHRP(ch:FindFirstChild("HumanoidRootPart"))
            killSit(ch:FindFirstChildOfClass("Humanoid"))
        end
        pcall(function() tool:Activate() end)   -- instant, once per equip
    end
    local function watchCarpetChar(ch)
        if not ch then return end
        local cur = ch:FindFirstChildWhichIsA("Tool")
        if cur then task.defer(tryActivateCarpet, cur) end
        conns[#conns + 1] = ch.ChildAdded:Connect(function(o)   -- tracked: unload disconnects it
            if o:IsA("Tool") then task.defer(tryActivateCarpet, o) end
        end)
    end
    -- auto-activate on equip DISABLED: equipping the carpet no longer activates it.
    -- (The TP sequence still activates it itself: hold -> activate -> 0.15s -> fly.)
    local AUTO_ACTIVATE_CARPET = false
    -- kill the auto-activate listener a PREVIOUS run of this script left on your character
    -- (old versions never disconnected it, so it survived re-executing until you respawned)
    local function killOldCarpetActivators(ch)
        if not (ch and type(getconnections) == "function" and debug and type(debug.getupvalues) == "function") then return end
        local function activates(fn)
            if type(fn) ~= "function" then return false end
            local ok, ups = pcall(debug.getupvalues, fn)
            if not ok or type(ups) ~= "table" then return false end
            for _, v in pairs(ups) do
                if type(v) == "table" and v[1] == nil and v.Flying == nil then
                    -- CARPET_TOOL_NAMES = { ["Flying Carpet"] = true }
                    if rawget(v, FLY_TOOL) == true or rawget(v, "Flying Carpet") == true then return true end
                end
                if type(v) == "function" and v ~= fn then
                    local ok2, ups2 = pcall(debug.getupvalues, v)
                    if ok2 and type(ups2) == "table" then
                        for _, w in pairs(ups2) do
                            if type(w) == "table" and (rawget(w, "Flying Carpet") == true and rawget(w, "FlightHold") == nil) then
                                return true
                            end
                        end
                    end
                end
            end
            return false
        end
        local ok, list = pcall(getconnections, ch.ChildAdded)
        if not ok or type(list) ~= "table" then return end
        local killed = 0
        for _, c in ipairs(list) do
            local okf, f = pcall(function() return c.Function end)
            local exec = okf and type(f) == "function" and (type(isexecutorclosure) ~= "function" or isexecutorclosure(f))
            if exec and activates(f) then
                if pcall(function() c:Disconnect() end) or pcall(function() c:Disable() end) then killed = killed + 1 end
            end
        end
        if killed > 0 then print("[Eclipse] removed " .. killed .. " old carpet auto-activate listener(s)") end
    end
    pcall(killOldCarpetActivators, LP.Character)
    if AUTO_ACTIVATE_CARPET then
        on(LP.CharacterAdded, watchCarpetChar)
        if LP.Character then task.spawn(watchCarpetChar, LP.Character) end
    end

    on(RunService.Heartbeat, function()
        local ch = LP.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not (hum and hrp and hum.Health > 0) then return end

        -- do we currently hold a carpet?
        local held = false
        for _, t in ipairs(ch:GetChildren()) do
            if t:IsA("Tool") and CARPETS[t.Name] then held = true break end
        end
        if not held then return end

        -- always strip the carpet's own flight forces + sit animation
        sweepCarpetHRP(hrp)
        killSit(hum)

        -- steady speed only when the toggle is ON and the script isn't running a tp/lift/grab
        if not carpetOn or tpRunning or liftActive or pending ~= nil then return end
        if LP:GetAttribute("Stealing") ~= nil then return end

        local v = hrp.AssemblyLinearVelocity
        local md = hum.MoveDirection
        if md.Magnitude > 0 then
            local u = md.Unit
            hrp.AssemblyLinearVelocity = Vector3.new(u.X * CARPET_SPEED, v.Y, u.Z * CARPET_SPEED)
        else
            local st = hum:GetState()
            if st ~= Enum.HumanoidStateType.Freefall and st ~= Enum.HumanoidStateType.Jumping then
                hrp.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
            end
        end
    end)

    -- CLONE (SXE instant clone): equip Quantum Cloner, use it, then press its "Teleport To Clone" button
    local cloneBtn = new("TextButton", { Position = UDim2.fromOffset(10, 156), Size = UDim2.new(1, -20, 0, 30), BackgroundColor3 = C.ELEM,
        BackgroundTransparency = 0.15, BorderSizePixel = 0, AutoButtonColor = false, Text = "CLONE", TextSize = 13,
        TextColor3 = C.WHITE, FontFace = Font.new(FAMILY, Enum.FontWeight.Bold) }, rf)
    round(cloneBtn, 9) stroke(cloneBtn)
    local cloning = false
    local function doClone()
        if cloning then return end
        local ch = LP.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local bp = LP:FindFirstChildOfClass("Backpack")
        local tool = (bp and bp:FindFirstChild("Quantum Cloner")) or ch:FindFirstChild("Quantum Cloner")
        if not tool then setStatus("No Quantum Cloner") return end
        cloning = true
        pcall(function() hum:UnequipTools() end)
        task.wait()
        if tool.Parent ~= ch then pcall(function() hum:EquipTool(tool) end) task.wait() end
        local pg = LP:FindFirstChildOfClass("PlayerGui")
        local tf = pg and pg:FindFirstChild("ToolsFrames")
        local qc = tf and tf:FindFirstChild("QuantumCloner")
        local tpc = qc and qc:FindFirstChild("TeleportToClone")
        pcall(function() tool:Activate() end)
        task.wait(0.05)
        if tpc then
            pcall(function() tpc.Visible = true end)
            if type(firesignal) == "function" then
                pcall(function() firesignal(tpc.MouseButton1Click) end)
                pcall(function() firesignal(tpc.MouseButton1Up) end)
                pcall(function() firesignal(tpc.Activated) end)
            elseif type(getconnections) == "function" then
                for _, sig in ipairs({ tpc.MouseButton1Click, tpc.Activated }) do
                    pcall(function() for _, c in ipairs(getconnections(sig)) do pcall(function() c:Fire() end) end end)
                end
            end
            setStatus("Cloned")
        else
            setStatus("Cloner used (no Teleport To Clone button found)")
        end
        task.delay(0.55, function() cloning = false end)
    end
    cloneBtn.MouseButton1Click:Connect(function() task.spawn(doClone) end)


    local dragging, startP, startPos
    rf.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, startP, startPos = true, i.Position, rf.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End and dragging then
                    dragging = false
                    local p = rf.Position
                    CFG.resetPos = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
                    saveCfg()
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = (i.Position - startP) / math.max(rScale.Scale, 0.01)
            rf.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

task.defer(function()
    local cam = Workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    for _, f in ipairs({ invFrame, resetFrame }) do
        if f then
            local p, sz = f.AbsolutePosition, f.AbsoluteSize
            if p.X < 0 or p.Y < 0 or p.X + sz.X > vp.X or p.Y + sz.Y > vp.Y then
                f.Position = UDim2.fromOffset(math.clamp(p.X, 4, math.max(4, vp.X - sz.X - 4)), math.clamp(p.Y, 4, math.max(4, vp.Y - sz.Y - 4)))
            end
        end
    end
end)

print("[Eclipse] best brainrot tracker + teleport + StealHitbox snap loaded — RightCtrl hides it")