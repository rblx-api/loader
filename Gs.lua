--!nocheck
--[[════════════════════════════════════════════════════════════════════════════

    XAVI GUI COPIER  v1.0
    A GUI decompiler / serializer for Roblox.

    Discord: https://discord.gg/QhWDwSHvK

    Scans every ScreenGui / BillboardGui / SurfaceGui reachable from PlayerGui,
    CoreGui and StarterGui, then rebuilds any of them as clean, runnable Luau
    source that recreates the interface instance-for-instance.

    Features
      • Explorer     - searchable, sortable, filterable list of every GUI found
      • Inspector    - browse the instance tree, grab any single sub-branch
      • Output       - live code preview with stats, copy or save
      • Picker       - click an element on screen to jump straight to it
      • Highlighter  - non-destructive overlay outlines (never touches the target)
      • Auto-detect  - toasts when a new GUI appears while you play
      • Settings     - persisted to disk, tweak output format and keybinds

    Controls (rebindable in Settings)
      G              toggle the window
      R              rescan
      P              element picker

    Executor requirements
      writefile / readfile  - optional, needed only to save files & settings
      setclipboard          - optional, needed only for "Copy"
      gethui / cloneref     - optional, used for stealth if present

════════════════════════════════════════════════════════════════════════════]]

local VERSION = "1.0.0"
local DISCORD = "https://discord.gg/QhWDwSHvK"

-- ═══════════════════════════════════════════════════════════════════════════
--  Environment
-- ═══════════════════════════════════════════════════════════════════════════

local cloneref = cloneref or function(o) return o end

local Players            = cloneref(game:GetService("Players"))
local UserInputService    = cloneref(game:GetService("UserInputService"))
local TweenService        = cloneref(game:GetService("TweenService"))
local RunService          = cloneref(game:GetService("RunService"))
local HttpService         = cloneref(game:GetService("HttpService"))
local CoreGui             = cloneref(game:GetService("CoreGui"))
local StarterGui          = cloneref(game:GetService("StarterGui"))
local GuiService          = cloneref(game:GetService("GuiService"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- Optional executor functions. Everything degrades gracefully when missing.
-- Referencing an undefined global is nil, so this is safe on every executor.
local ENV = {
    writefile    = writefile,
    readfile     = readfile,
    isfile       = isfile,
    isfolder     = isfolder,
    makefolder   = makefolder,
    setclipboard = setclipboard or toclipboard or (Clipboard and Clipboard.set),
    gethui       = gethui,
    protectgui   = (syn and syn.protect_gui) or protectgui,
}

local function has(fn) return type(ENV[fn]) == "function" end

local EXECUTOR = "Unknown"
pcall(function()
    if identifyexecutor then EXECUTOR = tostring((identifyexecutor()))
    elseif getexecutorname then EXECUTOR = tostring(getexecutorname()) end
end)

-- ═══════════════════════════════════════════════════════════════════════════
--  Theme :: Baby Blue (geen paars)
-- ═══════════════════════════════════════════════════════════════════════════

local Theme = {
    Base       = Color3.fromRGB(173, 216, 230),
    Surface    = Color3.fromRGB(200, 230, 245),
    Elevated   = Color3.fromRGB(220, 240, 250),
    Hover      = Color3.fromRGB(160, 205, 225),
    Line       = Color3.fromRGB(120, 170, 200),

    Accent     = Color3.fromRGB(70, 140, 200),
    AccentSoft = Color3.fromRGB(180, 215, 235),
    Success    = Color3.fromRGB(60, 170, 110),
    Warning    = Color3.fromRGB(220, 160, 50),
    Danger     = Color3.fromRGB(210, 70, 70),
    Violet     = Color3.fromRGB(80, 150, 210),

    Text       = Color3.fromRGB(0, 0, 0),
    TextDim    = Color3.fromRGB(30, 40, 55),
    TextFaint  = Color3.fromRGB(60, 80, 100),
    OnAccent   = Color3.fromRGB(0, 0, 0),
}

local FONT      = Enum.Font.Gotham
local FONT_MED  = Enum.Font.GothamMedium
local FONT_BOLD = Enum.Font.GothamBold
local FONT_MONO = Enum.Font.Code

-- ═══════════════════════════════════════════════════════════════════════════
--  Settings (persisted)
-- ═══════════════════════════════════════════════════════════════════════════

local FOLDER       = "xavi"
local OUT_FOLDER   = FOLDER .. "/output"
local SETTINGS_FILE= FOLDER .. "/settings.json"

local Settings = {
    includeAttributes = true,
    includeNonGui     = true,
    includeComments   = true,
    minify            = false,
    fileExtension     = "lua",
    parentTarget      = "PlayerGui",
    autoDetect        = true,
    highlightOnSelect = true,
    scanCoreGui       = true,
    scanStarterGui    = true,
    toggleKey         = "G",
    refreshKey        = "R",
    pickKey           = "P",
}

local function ensureFolders()
    if not (has("makefolder") and has("isfolder")) then return false end
    local ok = pcall(function()
        if not ENV.isfolder(FOLDER) then ENV.makefolder(FOLDER) end
        if not ENV.isfolder(OUT_FOLDER) then ENV.makefolder(OUT_FOLDER) end
    end)
    return ok
end

local function loadSettings()
    if not (has("readfile") and has("isfile")) then return end
    pcall(function()
        if not ENV.isfile(SETTINGS_FILE) then return end
        local data = HttpService:JSONDecode(ENV.readfile(SETTINGS_FILE))
        for k, v in pairs(data) do
            if Settings[k] ~= nil and type(v) == type(Settings[k]) then
                Settings[k] = v
            end
        end
    end)
end

local function saveSettings()
    if not has("writefile") then return end
    ensureFolders()
    pcall(function()
        ENV.writefile(SETTINGS_FILE, HttpService:JSONEncode(Settings))
    end)
end

loadSettings()

-- ═══════════════════════════════════════════════════════════════════════════
--  Serializer :: class model
-- ═══════════════════════════════════════════════════════════════════════════

local ClassDefs = {
    Instance   = { props = {} },

    GuiBase2d  = { base = "Instance", props = { "AutoLocalize", "RootLocalizationTable", "SelectionBehaviorDown", "SelectionBehaviorLeft", "SelectionBehaviorRight", "SelectionBehaviorUp", "SelectionGroup" } },

    LayerCollector = { base = "GuiBase2d", props = { "Enabled", "ResetOnSpawn", "DisplayOrder", "IgnoreGuiInset", "ZIndexBehavior", "ClipToDeviceSafeArea", "SafeAreaCompatibility", "ScreenInsets", "OnTopOfCoreBlur" } },
    ScreenGui      = { base = "LayerCollector", props = {} },
    GuiMain        = { base = "ScreenGui", props = {} },
    BillboardGui   = { base = "LayerCollector", props = { "Active", "Adornee", "AlwaysOnTop", "Brightness", "ClipsDescendants", "DistanceLowerLimit", "DistanceStep", "DistanceUpperLimit", "ExtentsOffset", "ExtentsOffsetWorldSpace", "LightInfluence", "MaxDistance", "PlayerToHideFrom", "Size", "SizeOffset", "StudsOffset", "StudsOffsetWorldSpace" } },
    SurfaceGui     = { base = "LayerCollector", props = { "Active", "Adornee", "AlwaysOnTop", "Brightness", "CanvasSize", "ClipsDescendants", "Face", "LightInfluence", "MaxDistance", "PixelsPerStud", "SizingMode", "ToolPunchThroughDistance", "ZOffset" } },

    GuiObject = { base = "GuiBase2d", props = {
        "Active", "AnchorPoint", "AutomaticSize", "BackgroundColor3", "BackgroundTransparency",
        "BorderColor3", "BorderMode", "BorderSizePixel", "ClipsDescendants", "Interactable",
        "LayoutOrder", "NextSelectionDown", "NextSelectionLeft", "NextSelectionRight",
        "NextSelectionUp", "Position", "Rotation", "Selectable", "SelectionImageObject",
        "SelectionOrder", "Size", "SizeConstraint", "Visible", "ZIndex",
    } },

    GuiButton = { base = "GuiObject", props = { "AutoButtonColor", "Modal", "Selected", "Style" } },

    Frame          = { base = "GuiObject", props = { "Style" } },
    CanvasGroup    = { base = "GuiObject", props = { "GroupColor3", "GroupTransparency" } },
    ScrollingFrame = { base = "GuiObject", props = {
        "AutomaticCanvasSize", "BottomImage", "CanvasPosition", "CanvasSize", "ElasticBehavior",
        "HorizontalScrollBarInset", "MidImage", "ScrollBarImageColor3", "ScrollBarImageTransparency",
        "ScrollBarThickness", "ScrollingDirection", "ScrollingEnabled", "TopImage",
        "VerticalScrollBarInset", "VerticalScrollBarPosition",
    } },
    ViewportFrame  = { base = "GuiObject", props = { "Ambient", "CurrentCamera", "ImageColor3", "ImageTransparency", "LightColor", "LightDirection" } },
    VideoFrame     = { base = "GuiObject", props = { "Looped", "Playing", "TimePosition", "Video", "Volume" } },

    TextLabel  = { base = "GuiObject", props = { "@text" } },
    TextButton = { base = "GuiButton", props = { "@text" } },
    TextBox    = { base = "GuiObject", props = { "@text",
        "ClearTextOnFocus", "MultiLine", "PlaceholderColor3", "PlaceholderText",
        "ShowNativeInput", "TextEditable",
    } },

    ImageLabel  = { base = "GuiObject", props = { "@image" } },
    ImageButton = { base = "GuiButton", props = { "@image", "HoverImage", "PressedImage" } },

    UICorner    = { base = "Instance", props = { "CornerRadius" } },
    UIPadding   = { base = "Instance", props = { "PaddingBottom", "PaddingLeft", "PaddingRight", "PaddingTop" } },
    UIScale     = { base = "Instance", props = { "Scale" } },
    UIStroke    = { base = "Instance", props = { "ApplyStrokeMode", "Color", "Enabled", "LineJoinMode", "Thickness", "Transparency" } },
    UIGradient  = { base = "Instance", props = { "Color", "Enabled", "Offset", "Rotation", "Transparency" } },
    UIFlexItem  = { base = "Instance", props = { "FlexMode", "GrowRatio", "ItemLineAlignment", "ShrinkRatio" } },

    UIListLayout = { base = "Instance", props = {
        "FillDirection", "HorizontalAlignment", "HorizontalFlex", "ItemLineAlignment",
        "Padding", "SortOrder", "VerticalAlignment", "VerticalFlex", "Wraps",
    } },
    UIGridLayout = { base = "Instance", props = {
        "CellPadding", "CellSize", "FillDirection", "FillDirectionMaxCells",
        "HorizontalAlignment", "SortOrder", "StartCorner", "VerticalAlignment",
    } },
    UITableLayout = { base = "Instance", props = {
        "FillDirection", "FillEmptySpaceColumns", "FillEmptySpaceRows",
        "HorizontalAlignment", "MajorAxis", "Padding", "SortOrder", "VerticalAlignment",
    } },
    UIPageLayout = { base = "Instance", props = {
        "Animated", "Circular", "EasingDirection", "EasingStyle", "FillDirection",
        "GamepadInputEnabled", "HorizontalAlignment", "Padding", "ScrollWheelInputEnabled",
        "SortOrder", "TouchInputEnabled", "TweenTime", "VerticalAlignment",
    } },

    UIAspectRatioConstraint = { base = "Instance", props = { "AspectRatio", "AspectType", "DominantAxis" } },
    UISizeConstraint        = { base = "Instance", props = { "MaxSize", "MinSize" } },
    UITextSizeConstraint    = { base = "Instance", props = { "MaxTextSize", "MinTextSize" } },

    Folder        = { base = "Instance", props = {} },
    Configuration = { base = "Instance", props = {} },
    StringValue   = { base = "Instance", props = { "Value" } },
    IntValue      = { base = "Instance", props = { "Value" } },
    NumberValue   = { base = "Instance", props = { "Value" } },
    BoolValue     = { base = "Instance", props = { "Value" } },
    ObjectValue   = { base = "Instance", props = { "Value" } },
    Color3Value   = { base = "Instance", props = { "Value" } },
    Vector3Value  = { base = "Instance", props = { "Value" } },
    CFrameValue   = { base = "Instance", props = { "Value" } },
    BrickColorValue = { base = "Instance", props = { "Value" } },
}

local PropGroups = {
    text = {
        "Font", "FontFace", "LineHeight", "MaxVisibleGraphemes", "RichText", "Text",
        "TextColor3", "TextDirection", "TextScaled", "TextSize", "TextStrokeColor3",
        "TextStrokeTransparency", "TextTransparency", "TextTruncate", "TextWrapped",
        "TextXAlignment", "TextYAlignment",
    },
    image = {
        "Image", "ImageColor3", "ImageRectOffset", "ImageRectSize", "ImageTransparency",
        "ResampleMode", "ScaleType", "SliceCenter", "SliceScale", "TileSize",
    },
}

local ClassProps = {}
do
    local function resolve(name, seen)
        if ClassProps[name] then return ClassProps[name] end
        local def = ClassDefs[name]
        if not def then return {} end
        seen = seen or {}
        if seen[name] then return {} end
        seen[name] = true

        local out, added = {}, {}
        local function push(p)
            if not added[p] then added[p] = true; out[#out + 1] = p end
        end
        if def.base then
            for _, p in ipairs(resolve(def.base, seen)) do push(p) end
        end
        for _, p in ipairs(def.props) do
            local group = p:match("^@(%w+)")
            if group then
                for _, g in ipairs(PropGroups[group] or {}) do push(g) end
            else
                push(p)
            end
        end
        ClassProps[name] = out
        return out
    end
    for name in pairs(ClassDefs) do resolve(name) end
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Serializer :: value formatting
-- ═══════════════════════════════════════════════════════════════════════════

local function fmtNumber(n)
    if n ~= n then return "0/0" end
    if n == math.huge then return "math.huge" end
    if n == -math.huge then return "-math.huge" end
    if n % 1 == 0 and math.abs(n) < 1e15 then return string.format("%d", n) end
    for _, spec in ipairs({ "%.4g", "%.7g", "%.10g", "%.17g" }) do
        local s = string.format(spec, n)
        if tonumber(s) == n then return s end
    end
    return string.format("%.17g", n)
end

local ESCAPES = { ["\\"] = "\\\\", ['"'] = '\\"', ["\n"] = "\\n", ["\r"] = "\\r", ["\t"] = "\\t" }
local function fmtString(s)
    return '"' .. (s:gsub('[%c\\"]', function(c)
        return ESCAPES[c] or string.format("\\%d", string.byte(c))
    end)) .. '"'
end

local function fmtColor3(c)
    local r, g, b = c.R * 255, c.G * 255, c.B * 255
    local ri, gi, bi = math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5)
    if math.abs(r - ri) < 1e-3 and math.abs(g - gi) < 1e-3 and math.abs(b - bi) < 1e-3 then
        return string.format("Color3.fromRGB(%d, %d, %d)", ri, gi, bi)
    end
    return string.format("Color3.new(%s, %s, %s)", fmtNumber(c.R), fmtNumber(c.G), fmtNumber(c.B))
end

local function instancePath(inst)
    if inst == game then return "game" end
    if inst == workspace then return "workspace" end

    local chain, node = {}, inst
    while node and node ~= game do
        table.insert(chain, 1, node)
        node = node.Parent
    end
    if node ~= game or #chain == 0 then return nil end

    local out, startIndex
    if chain[1] == Players and chain[2] == LocalPlayer then
        out, startIndex = 'game:GetService("Players").LocalPlayer', 3
    else
        out, startIndex = string.format("game:GetService(%s)", fmtString(chain[1].ClassName)), 2
    end
    for i = startIndex, #chain do
        out = out .. string.format(":FindFirstChild(%s)", fmtString(chain[i].Name))
    end
    return out
end

local function fmtValue(v, resolveRef)
    local t = typeof(v)

    if t == "string"  then return fmtString(v) end
    if t == "number"  then return fmtNumber(v) end
    if t == "boolean" then return tostring(v) end
    if t == "nil"     then return "nil" end
    if t == "EnumItem" then return "Enum." .. tostring(v.EnumType) .. "." .. v.Name end
    if t == "Color3"  then return fmtColor3(v) end

    if t == "UDim" then
        return string.format("UDim.new(%s, %s)", fmtNumber(v.Scale), fmtNumber(v.Offset))
    end
    if t == "UDim2" then
        return string.format("UDim2.new(%s, %s, %s, %s)",
            fmtNumber(v.X.Scale), fmtNumber(v.X.Offset),
            fmtNumber(v.Y.Scale), fmtNumber(v.Y.Offset))
    end
    if t == "Vector2" then
        return string.format("Vector2.new(%s, %s)", fmtNumber(v.X), fmtNumber(v.Y))
    end
    if t == "Vector3" then
        return string.format("Vector3.new(%s, %s, %s)", fmtNumber(v.X), fmtNumber(v.Y), fmtNumber(v.Z))
    end
    if t == "Rect" then
        return string.format("Rect.new(%s, %s, %s, %s)",
            fmtNumber(v.Min.X), fmtNumber(v.Min.Y), fmtNumber(v.Max.X), fmtNumber(v.Max.Y))
    end
    if t == "NumberRange" then
        return string.format("NumberRange.new(%s, %s)", fmtNumber(v.Min), fmtNumber(v.Max))
    end
    if t == "BrickColor" then
        return string.format("BrickColor.new(%s)", fmtString(v.Name))
    end
    if t == "CFrame" then
        local c = { v:GetComponents() }
        for i, n in ipairs(c) do c[i] = fmtNumber(n) end
        return "CFrame.new(" .. table.concat(c, ", ") .. ")"
    end
    if t == "Font" then
        return string.format("Font.new(%s, Enum.FontWeight.%s, Enum.FontStyle.%s)",
            fmtString(v.Family), v.Weight.Name, v.Style.Name)
    end
    if t == "ColorSequence" then
        local parts = {}
        for _, kp in ipairs(v.Keypoints) do
            parts[#parts + 1] = string.format("ColorSequenceKeypoint.new(%s, %s)",
                fmtNumber(kp.Time), fmtColor3(kp.Value))
        end
        return "ColorSequence.new({" .. table.concat(parts, ", ") .. "})"
    end
    if t == "NumberSequence" then
        local parts = {}
        for _, kp in ipairs(v.Keypoints) do
            parts[#parts + 1] = string.format("NumberSequenceKeypoint.new(%s, %s, %s)",
                fmtNumber(kp.Time), fmtNumber(kp.Value), fmtNumber(kp.Envelope))
        end
        return "NumberSequence.new({" .. table.concat(parts, ", ") .. "})"
    end
    if t == "Instance" then
        local inside = resolveRef and resolveRef(v)
        if inside then return inside end
        return instancePath(v) or ("nil --[[ " .. v.ClassName .. " outside tree ]]")
    end

    return "nil --[[ unsupported " .. t .. " ]]"
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Serializer :: identifiers
-- ═══════════════════════════════════════════════════════════════════════════

local RESERVED = {}
for word in ("and break do else elseif end false for function if in local nil not or " ..
             "repeat return then true until while continue export type game workspace " ..
             "script self _G shared Enum Instance Color3 UDim UDim2 Vector2 Vector3"):gmatch("%S+") do
    RESERVED[word] = true
end

local function makeIdentifier(name, taken)
    local base = name:gsub("[^%w_]", "")
    if base == "" then base = "Object" end
    if base:match("^%d") then base = "_" .. base end
    if RESERVED[base] then base = base .. "_" end
    if #base > 48 then base = base:sub(1, 48) end

    local id, n = base, 1
    while taken[id] do
        n += 1
        id = base .. "_" .. n
    end
    taken[id] = true
    return id
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Serializer :: main pass
-- ═══════════════════════════════════════════════════════════════════════════

local LOCAL_LIMIT = 170
local YIELD_BUDGET = 1 / 90

local defaultCache = {}
local function defaultsFor(className)
    local cached = defaultCache[className]
    if cached ~= nil then return cached or nil end
    local ok, inst = pcall(Instance.new, className)
    defaultCache[className] = ok and inst or false
    return ok and inst or nil
end

local function isGuiIsh(inst)
    return inst:IsA("GuiObject") or inst:IsA("UIBase") or inst:IsA("LayerCollector")
end

local function collectTree(root, includeNonGui, onProgress)
    local list, skipped = {}, 0
    local deadline = os.clock() + YIELD_BUDGET

    local function visit(inst)
        if os.clock() > deadline then
            task.wait()
            deadline = os.clock() + YIELD_BUDGET
            if onProgress then onProgress(#list) end
        end

        local okClass, className = pcall(function() return inst.ClassName end)
        if not okClass then skipped += 1 return end

        if inst ~= root then
            if not includeNonGui and not isGuiIsh(inst) then skipped += 1 return end
            if not defaultsFor(className) then skipped += 1 return end
        end

        list[#list + 1] = inst
        local okKids, kids = pcall(function() return inst:GetChildren() end)
        if okKids then
            for _, child in ipairs(kids) do visit(child) end
        end
    end

    visit(root)
    return list, skipped
end

local PARENT_EXPR = {
    PlayerGui = 'game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")',
    CoreGui   = 'game:GetService("CoreGui")',
    gethui    = '(gethui and gethui() or game:GetService("CoreGui"))',
}

local function serialize(root, opts, onProgress)
    opts = opts or Settings
    local started = os.clock()

    local comments = opts.includeComments and not opts.minify
    local instances, skipped = collectTree(root, opts.includeNonGui, function(n)
        if onProgress then onProgress("Walking tree", n, 0) end
    end)

    local count = #instances
    local useLocals = count <= LOCAL_LIMIT

    local taken, ids = {}, {}
    for i, inst in ipairs(instances) do
        local name = inst.Name
        if opts.minify then
            ids[inst] = "v" .. i
            taken["v" .. i] = true
        else
            ids[inst] = makeIdentifier(name ~= "" and name or inst.ClassName, taken)
        end
    end

    local function ref(inst)
        local id = ids[inst]
        if not id then return nil end
        return useLocals and id or ("G." .. id)
    end
    local declPrefix = useLocals and "local " or ""

    local out, deferred = {}, {}
    local function line(s) out[#out + 1] = s end
    local function blank() if not opts.minify then out[#out + 1] = "" end end

    local stats = {
        instances = count, properties = 0, attributes = 0,
        skipped = skipped, partial = 0, classes = {},
    }

    if comments then
        line("--[[")
        line(string.format("    %s  (%s)", root.Name, root.ClassName))
        line(string.format("    Grabbed by Xavi GUI Copier v%s on %s", VERSION, os.date("%Y-%m-%d %H:%M:%S")))
        line(string.format("    Discord: %s", DISCORD))
        line(string.format("    %d instance%s%s", count, count == 1 and "" or "s",
            skipped > 0 and (", " .. skipped .. " skipped") or ""))
        line("]]")
        line("")
    end

    if not useLocals then
        line("local G = {}")
        blank()
    end

    local needsHost = not root:IsA("LayerCollector")
    local targetExpr = PARENT_EXPR[opts.parentTarget] or PARENT_EXPR.PlayerGui

    local deadline = os.clock() + YIELD_BUDGET
    for index, inst in ipairs(instances) do
        if os.clock() > deadline then
            task.wait()
            deadline = os.clock() + YIELD_BUDGET
            if onProgress then onProgress("Serializing", index, count) end
        end

        local className = inst.ClassName
        stats.classes[className] = (stats.classes[className] or 0) + 1

        local id = ref(inst)
        local props = ClassProps[className]
        if not props then
            props = {}
            stats.partial += 1
        end

        if comments then
            line(string.format("-- %s (%s)", ids[inst], className))
        end
        line(string.format("%s%s = Instance.new(%s)", declPrefix, id, fmtString(className)))

        local default = defaultsFor(className)
        if inst.Name ~= className then
            line(string.format("%s.Name = %s", id, fmtString(inst.Name)))
            stats.properties += 1
        end

        local skipFont = false
        if default then
            local okFF, ff = pcall(function() return inst.FontFace end)
            local okDF, df = pcall(function() return default.FontFace end)
            skipFont = okFF and okDF and ff ~= df
        end

        for _, prop in ipairs(props) do
            if not (prop == "Font" and skipFont) then
                local okVal, value = pcall(function() return inst[prop] end)
                local okDef, defValue = pcall(function() return default and default[prop] end)
                if okVal and okDef and value ~= defValue then
                    if typeof(value) == "Instance" and not ids[value] then
                        line(string.format("%s.%s = %s", id, prop, fmtValue(value, ref)))
                        stats.properties += 1
                    elseif typeof(value) == "Instance" then
                        deferred[#deferred + 1] = string.format("%s.%s = %s", id, prop, ref(value))
                        stats.properties += 1
                    else
                        line(string.format("%s.%s = %s", id, prop, fmtValue(value, ref)))
                        stats.properties += 1
                    end
                end
            end
        end

        if opts.includeAttributes then
            local okAttrs, attrs = pcall(function() return inst:GetAttributes() end)
            if okAttrs and attrs then
                local keys = {}
                for k in pairs(attrs) do keys[#keys + 1] = k end
                table.sort(keys)
                for _, k in ipairs(keys) do
                    line(string.format("%s:SetAttribute(%s, %s)", id, fmtString(k), fmtValue(attrs[k], ref)))
                    stats.attributes += 1
                end
            end
        end

        if inst == root then
            if needsHost then
                blank()
                line('local _host = Instance.new("ScreenGui")')
                line("_host.Name = " .. fmtString(root.Name .. "_Host"))
                line("_host.ResetOnSpawn = false")
                line("_host.ZIndexBehavior = Enum.ZIndexBehavior.Sibling")
                line(string.format("%s.Parent = _host", id))
            end
        else
            line(string.format("%s.Parent = %s", id, ref(inst.Parent)))
        end
        blank()
    end

    if #deferred > 0 then
        if comments then line("-- deferred instance references") end
        for _, l in ipairs(deferred) do line(l) end
        blank()
    end

    if comments then line("-- mount") end
    if needsHost then
        line("_host.Parent = " .. targetExpr)
    else
        line(string.format("%s.Parent = %s", ref(root), targetExpr))
    end
    blank()
    line("return " .. (needsHost and "_host" or ref(root)))

    local code = table.concat(out, "\n")
    if opts.minify then
        code = code:gsub("\n\n+", "\n")
    end

    stats.elapsed = os.clock() - started
    stats.bytes = #code
    return code, stats
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Scanner
-- ═══════════════════════════════════════════════════════════════════════════

local RootGui
local Overlay

local function countDescendants(inst)
    local ok, n = pcall(function() return #inst:GetDescendants() end)
    return ok and n or 0
end

local function scanContainers()
    local found, seen = {}, {}

    local function sweep(container, label)
        if not container then return end
        local ok, children = pcall(function() return container:GetChildren() end)
        if not ok then return end
        for _, child in ipairs(children) do
            local okIs, isCollector = pcall(function() return child:IsA("LayerCollector") end)
            if okIs and isCollector and not seen[child] and child ~= RootGui and child ~= Overlay then
                seen[child] = true
                found[#found + 1] = {
                    gui    = child,
                    name   = child.Name,
                    class  = child.ClassName,
                    source = label,
                    count  = countDescendants(child),
                }
            end
        end
    end

    sweep(PlayerGui, "PlayerGui")
    if Settings.scanCoreGui then
        sweep(CoreGui, "CoreGui")
        pcall(function() if ENV.gethui then sweep(ENV.gethui(), "Hidden") end end)
    end
    if Settings.scanStarterGui then sweep(StarterGui, "StarterGui") end

    return found
end

local function sanitizeFileName(name)
    local clean = name:gsub("[^%w%-_ ]", "_"):gsub("%s+", "_"):gsub("_+", "_")
    clean = clean:gsub("^_+", ""):gsub("_+$", "")
    if clean == "" then clean = "Gui" end
    return clean:sub(1, 60)
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Highlighter
-- ═══════════════════════════════════════════════════════════════════════════

local Highlight = {
    target = nil,
    boxes  = {},
    conn   = nil,
    MAX    = 400,
}

function Highlight.clear()
    if Highlight.conn then Highlight.conn:Disconnect(); Highlight.conn = nil end
    for _, box in pairs(Highlight.boxes) do pcall(function() box:Destroy() end) end
    Highlight.boxes = {}
    Highlight.target = nil
end

function Highlight.set(root, color)
    Highlight.clear()
    if not root then return end
    Highlight.target = root
    color = color or Theme.Accent

    local targets = {}
    if root:IsA("GuiObject") then targets[#targets + 1] = root end
    for _, desc in ipairs(root:GetDescendants()) do
        if #targets >= Highlight.MAX then break end
        if desc:IsA("GuiObject") then targets[#targets + 1] = desc end
    end

    for _, obj in ipairs(targets) do
        local box = Instance.new("Frame")
        box.BackgroundTransparency = 1
        box.BorderSizePixel = 0
        box.ZIndex = 1
        local stroke = Instance.new("UIStroke")
        stroke.Color = color
        stroke.Thickness = 1
        stroke.Transparency = 0.35
        stroke.Parent = box
        box.Parent = Overlay
        Highlight.boxes[obj] = box
    end

    local function refresh()
        for obj, box in pairs(Highlight.boxes) do
            if obj.Parent then
                local pos, size = obj.AbsolutePosition, obj.AbsoluteSize
                box.Position = UDim2.fromOffset(pos.X, pos.Y)
                box.Size = UDim2.fromOffset(size.X, size.Y)
                box.Visible = obj.Visible and size.X > 0 and size.Y > 0
            else
                box.Visible = false
            end
        end
    end
    refresh()
    Highlight.conn = RunService.RenderStepped:Connect(refresh)
end

function Highlight.toggle(root, color)
    if Highlight.target == root then
        Highlight.clear()
        return false
    end
    Highlight.set(root, color)
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Element picker
-- ═══════════════════════════════════════════════════════════════════════════

local Picker = { active = false, onPick = nil }

local PickerBox, PickerLabel

local function pickerCandidateAt()
    local mouse = UserInputService:GetMouseLocation()
    local inset = GuiService:GetGuiInset()

    for _, y in ipairs({ mouse.Y - inset.Y, mouse.Y }) do
        local ok, objects = pcall(function()
            return PlayerGui:GetGuiObjectsAtPosition(mouse.X, y)
        end)
        if ok and objects then
            for _, obj in ipairs(objects) do
                local collector = obj:FindFirstAncestorWhichIsA("LayerCollector")
                if collector ~= RootGui and collector ~= Overlay then
                    return obj
                end
            end
        end
    end
    return nil
end

function Picker.finish(target)
    if not Picker.active then return end
    Picker.active = false
    local callback = Picker.onPick
    Picker.onPick = nil
    if PickerBox then PickerBox.Visible = false end
    if Picker.moveConn then Picker.moveConn:Disconnect(); Picker.moveConn = nil end
    if Picker.clickConn then Picker.clickConn:Disconnect(); Picker.clickConn = nil end
    if callback then task.defer(callback, target) end
end

function Picker.stop()
    Picker.finish(nil)
end

function Picker.start(callback)
    if Picker.active then Picker.stop() return end
    Picker.active = true
    Picker.onPick = callback

    local hovered = nil

    local function update()
        local obj = pickerCandidateAt()
        hovered = obj
        if obj then
            PickerBox.Visible = true
            PickerBox.Position = UDim2.fromOffset(obj.AbsolutePosition.X, obj.AbsolutePosition.Y)
            PickerBox.Size = UDim2.fromOffset(obj.AbsoluteSize.X, obj.AbsoluteSize.Y)
            local collector = obj:FindFirstAncestorWhichIsA("LayerCollector")
            PickerLabel.Text = string.format("  %s  |  %s  ", obj.Name, collector and collector.Name or obj.ClassName)
        else
            PickerBox.Visible = false
        end
    end

    Picker.moveConn = RunService.RenderStepped:Connect(update)
    Picker.clickConn = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            Picker.finish(hovered)
        elseif input.KeyCode == Enum.KeyCode.Escape then
            Picker.finish(nil)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
--  UI primitives
-- ═══════════════════════════════════════════════════════════════════════════

local function New(className, props, children)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    for _, child in ipairs(children or {}) do child.Parent = inst end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Corner(radius, parent)
    return New("UICorner", { CornerRadius = UDim.new(0, radius), Parent = parent })
end

local function Stroke(color, thickness, transparency, parent)
    return New("UIStroke", {
        Color = color, Thickness = thickness or 1, Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent,
    })
end

local function Pad(parent, t, r, b, l)
    return New("UIPadding", {
        PaddingTop = UDim.new(0, t), PaddingRight = UDim.new(0, r or t),
        PaddingBottom = UDim.new(0, b or t), PaddingLeft = UDim.new(0, l or r or t),
        Parent = parent,
    })
end

local function ListLayout(parent, padding, direction)
    return New("UIListLayout", {
        Padding = UDim.new(0, padding or 0),
        FillDirection = direction or Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = parent,
    })
end

local Connections = {}
local function track(conn)
    Connections[#Connections + 1] = conn
    return conn
end

local QUICK = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local SMOOTH = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function tween(inst, info, goal)
    local t = TweenService:Create(inst, info, goal)
    t:Play()
    return t
end

local Glyph = {}

function Glyph.cross(parent, size, color, thickness)
    local holder = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, Parent = parent,
    })
    for _, rotation in ipairs({ 45, -45 }) do
        New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(size, thickness or 1.5), Rotation = rotation,
            BackgroundColor3 = color, BorderSizePixel = 0, Parent = holder,
        })
    end
    return holder
end

function Glyph.bar(parent, width, color, thickness)
    return New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(width, thickness or 1.5),
        BackgroundColor3 = color, BorderSizePixel = 0, Parent = parent,
    })
end

function Glyph.box(parent, size, color)
    local box = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, Parent = parent,
    })
    Corner(2, box)
    Stroke(color, 1.5, 0, box)
    return box
end

function Glyph.search(parent, color)
    local holder = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(13, 13), BackgroundTransparency = 1, Parent = parent,
    })
    local ring = New("Frame", {
        Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(9, 9),
        BackgroundTransparency = 1, Parent = holder,
    })
    Corner(5, ring)
    Stroke(color, 1.25, 0, ring)
    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(10, 10),
        Size = UDim2.fromOffset(5, 1.25), Rotation = 45,
        BackgroundColor3 = color, BorderSizePixel = 0, Parent = holder,
    })
    return holder
end

function Glyph.grip(parent, color)
    local holder = New("Frame", {
        AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1),
        Size = UDim2.fromOffset(11, 11), BackgroundTransparency = 1, Parent = parent,
    })
    for _, spot in ipairs({ { 8, 0 }, { 8, 4 }, { 4, 4 }, { 8, 8 }, { 4, 8 }, { 0, 8 } }) do
        New("Frame", {
            Position = UDim2.fromOffset(spot[1], spot[2]), Size = UDim2.fromOffset(2, 2),
            BackgroundColor3 = color, BackgroundTransparency = 0.35,
            BorderSizePixel = 0, Parent = holder,
        })
    end
    return holder
end

local function hoverable(button, base, hover, press)
    button.AutoButtonColor = false
    local down = false
    button.MouseEnter:Connect(function()
        if not down then tween(button, QUICK, { BackgroundColor3 = hover }) end
    end)
    button.MouseLeave:Connect(function()
        down = false
        tween(button, QUICK, { BackgroundColor3 = base })
    end)
    button.MouseButton1Down:Connect(function()
        down = true
        tween(button, QUICK, { BackgroundColor3 = press or hover })
    end)
    button.MouseButton1Up:Connect(function()
        down = false
        tween(button, QUICK, { BackgroundColor3 = hover })
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Mount our interface
-- ═══════════════════════════════════════════════════════════════════════════

for _, container in ipairs({ CoreGui, PlayerGui }) do
    pcall(function()
        for _, child in ipairs(container:GetChildren()) do
            if child.Name == "xavi_Root" or child.Name == "xavi_Overlay" then
                child:Destroy()
            end
        end
    end)
end
pcall(function()
    if ENV.gethui then
        for _, child in ipairs(ENV.gethui():GetChildren()) do
            if child.Name == "xavi_Root" or child.Name == "xavi_Overlay" then
                child:Destroy()
            end
        end
    end
end)

local function mount(gui)
    local ok = pcall(function()
        if ENV.protectgui then
            ENV.protectgui(gui)
            gui.Parent = CoreGui
        elseif ENV.gethui then
            gui.Parent = ENV.gethui()
        else
            gui.Parent = CoreGui
        end
    end)
    if not ok or not gui.Parent then
        gui.Parent = PlayerGui
    end
end

RootGui = New("ScreenGui", {
    Name = "xavi_Root",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999998,
})
mount(RootGui)

Overlay = New("ScreenGui", {
    Name = "xavi_Overlay",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999997,
})
mount(Overlay)

PickerBox = New("Frame", {
    Name = "PickerBox",
    BackgroundColor3 = Theme.Accent,
    BackgroundTransparency = 0.85,
    BorderSizePixel = 0,
    Visible = false,
    Parent = Overlay,
})
Stroke(Theme.Accent, 2, 0, PickerBox)

PickerLabel = New("TextLabel", {
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 0, 0, -4),
    Size = UDim2.new(0, 0, 0, 20),
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    Font = FONT_MED,
    TextSize = 12,
    TextColor3 = Theme.Text,
    Text = "",
    Parent = PickerBox,
})
Corner(4, PickerLabel)

-- ═══════════════════════════════════════════════════════════════════════════
--  Window shell
-- ═══════════════════════════════════════════════════════════════════════════

local WIN_W, WIN_H = 660, 480
local MIN_W, MIN_H = 560, 360

local Window = New("Frame", {
    Name = "Window",
    Size = UDim2.fromOffset(WIN_W, WIN_H),
    Position = UDim2.new(0.5, -WIN_W / 2, 0.5, -WIN_H / 2),
    BackgroundColor3 = Theme.Base,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = RootGui,
})
Corner(10, Window)
Stroke(Theme.Line, 1, 0, Window)

local TitleBar = New("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0,
    Parent = Window,
})
Corner(10, TitleBar)
local TitleSquareOff = New("Frame", {
    Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = Theme.Surface, BorderSizePixel = 0, Parent = TitleBar,
})
local TitleDivider = New("Frame", {
    Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = Theme.Line, BorderSizePixel = 0, ZIndex = 2, Parent = TitleBar,
})

local Logo = New("Frame", {
    Size = UDim2.fromOffset(22, 22),
    Position = UDim2.new(0, 14, 0.5, -11),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    Parent = TitleBar,
})
Corner(6, Logo)
New("UIGradient", {
    Color = ColorSequence.new(Theme.Accent, Theme.Violet),
    Rotation = 45,
    Parent = Logo,
})
New("TextLabel", {
    Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    Font = FONT_BOLD, TextSize = 10, TextColor3 = Theme.Text, Text = "XH",
    Parent = Logo,
})

New("TextLabel", {
    Position = UDim2.new(0, 46, 0, 0), Size = UDim2.new(0, 152, 1, 0),
    BackgroundTransparency = 1, Font = FONT_BOLD, TextSize = 14,
    TextColor3 = Theme.Text, Text = "Xavi GUI Copier",
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd, Parent = TitleBar,
})

local VersionChip = New("TextLabel", {
    Position = UDim2.new(0, 184, 0.5, -9), Size = UDim2.fromOffset(190, 18),
    BackgroundColor3 = Theme.Elevated, BorderSizePixel = 0,
    Font = FONT_MED, TextSize = 10, TextColor3 = Theme.TextDim,
    Text = "v" .. VERSION .. "  |  " .. DISCORD,
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = TitleBar,
})
Corner(9, VersionChip)

local function titleButton(x)
    local btn = New("TextButton", {
        Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, x, 0.5, -13),
        BackgroundColor3 = Theme.Elevated, BorderSizePixel = 0, AutoButtonColor = false,
        Text = "", Parent = TitleBar,
    })
    Corner(6, btn)
    hoverable(btn, Theme.Elevated, Theme.Hover)
    return btn
end

local CloseBtn = titleButton(-36)
Glyph.cross(CloseBtn, 9, Theme.Danger, 1.5)

local MinBtn = titleButton(-68)
local MinBar = Glyph.bar(MinBtn, 10, Theme.TextDim, 1.5)
local MinBox = Glyph.box(MinBtn, 9, Theme.TextDim)
MinBox.Visible = false

do
    local dragging, dragStart, startPos = false, nil, nil
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    track(UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
end

local Grip = New("TextButton", {
    AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3),
    Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1,
    Text = "", AutoButtonColor = false, ZIndex = 20, Parent = Window,
})
Glyph.grip(Grip, Theme.TextFaint)
do
    local resizing, startInput, startSize = false, nil, nil
    Grip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            startInput = input.Position
            startSize = Window.AbsoluteSize
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
        end
    end)
    track(UserInputService.InputChanged:Connect(function(input)
        if not resizing then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - startInput
            Window.Size = UDim2.fromOffset(
                math.max(MIN_W, startSize.X + delta.X),
                math.max(MIN_H, startSize.Y + delta.Y))
        end
    end))
end

local Body = New("Frame", {
    Position = UDim2.new(0, 0, 0, 40),
    Size = UDim2.new(1, 0, 1, -40 - 28),
    BackgroundTransparency = 1,
    Parent = Window,
})

local Sidebar = New("Frame", {
    Size = UDim2.new(0, 140, 1, 0),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0,
    Parent = Body,
})
Pad(Sidebar, 10, 10, 10, 10)
ListLayout(Sidebar, 3)

New("Frame", {
    Position = UDim2.new(0, 139, 0, 0), Size = UDim2.new(0, 1, 1, 0),
    BackgroundColor3 = Theme.Line, BorderSizePixel = 0, Parent = Body,
})

local Content = New("Frame", {
    Position = UDim2.new(0, 140, 0, 0),
    Size = UDim2.new(1, -140, 1, 0),
    BackgroundTransparency = 1,
    Parent = Body,
})

local StatusBar = New("Frame", {
    AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0),
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundColor3 = Theme.Surface, BorderSizePixel = 0,
    Parent = Window,
})
Corner(10, StatusBar)
New("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    BackgroundColor3 = Theme.Surface, BorderSizePixel = 0, Parent = StatusBar,
})
New("Frame", {
    Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.Line,
    BorderSizePixel = 0, ZIndex = 2, Parent = StatusBar,
})

local StatusDot = New("Frame", {
    Position = UDim2.new(0, 12, 0.5, -3), Size = UDim2.fromOffset(6, 6),
    BackgroundColor3 = Theme.TextFaint, BorderSizePixel = 0, Parent = StatusBar,
})
Corner(3, StatusDot)

local StatusText = New("TextLabel", {
    Position = UDim2.new(0, 26, 0, 0), Size = UDim2.new(1, -190, 1, 0),
    BackgroundTransparency = 1, Font = FONT, TextSize = 12,
    TextColor3 = Theme.TextDim, Text = "Ready", TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd, Parent = StatusBar,
})

local ProgressTrack = New("Frame", {
    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -26, 0.5, 0),
    Size = UDim2.fromOffset(140, 4), BackgroundColor3 = Theme.Elevated,
    BorderSizePixel = 0, Visible = false, Parent = StatusBar,
})
Corner(2, ProgressTrack)
local ProgressFill = New("Frame", {
    Size = UDim2.fromScale(0, 1), BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0, Parent = ProgressTrack,
})
Corner(2, ProgressFill)

local function setStatus(text, color)
    StatusText.Text = text
    StatusText.TextColor3 = color or Theme.TextDim
    tween(StatusDot, QUICK, { BackgroundColor3 = color or Theme.TextFaint })
end

local function setProgress(fraction)
    if fraction == nil then
        ProgressTrack.Visible = false
        ProgressFill.Size = UDim2.fromScale(0, 1)
        return
    end
    ProgressTrack.Visible = true
    tween(ProgressFill, QUICK, { Size = UDim2.fromScale(math.clamp(fraction, 0, 1), 1) })
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Toasts
-- ═══════════════════════════════════════════════════════════════════════════

local ToastHolder = New("Frame", {
    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 16),
    Size = UDim2.fromOffset(280, 0), AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1, Parent = RootGui,
})
ListLayout(ToastHolder, 8).VerticalAlignment = Enum.VerticalAlignment.Top

local function toast(title, message, color, duration)
    color = color or Theme.Accent
    local card = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Elevated, BorderSizePixel = 0,
        BackgroundTransparency = 1, ClipsDescendants = true, Parent = ToastHolder,
    })
    Corner(8, card)
    local stroke = Stroke(Theme.Line, 1, 1, card)

    local content = New("Frame", {
        Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = card,
    })
    Pad(content, 10, 12, 10, 15)
    ListLayout(content, 3)

    New("Frame", {
        Size = UDim2.new(0, 3, 1, 0), BackgroundColor3 = color,
        BorderSizePixel = 0, ZIndex = 2, Parent = card,
    })

    local titleLabel = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, LayoutOrder = 1,
        Font = FONT_BOLD, TextSize = 12, TextColor3 = color, Text = title,
        TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, Parent = content,
    })
    local bodyLabel
    if message and message ~= "" then
        bodyLabel = New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = 2, Font = FONT, TextSize = 12,
            TextColor3 = Theme.TextDim, Text = message, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, Parent = content,
        })
    end

    tween(card, SMOOTH, { BackgroundTransparency = 0 })
    tween(stroke, SMOOTH, { Transparency = 0 })
    tween(titleLabel, SMOOTH, { TextTransparency = 0 })
    if bodyLabel then tween(bodyLabel, SMOOTH, { TextTransparency = 0 }) end

    task.delay(duration or 3.5, function()
        if not card.Parent then return end
        tween(card, SMOOTH, { BackgroundTransparency = 1 })
        tween(stroke, SMOOTH, { Transparency = 1 })
        tween(titleLabel, SMOOTH, { TextTransparency = 1 })
        if bodyLabel then tween(bodyLabel, SMOOTH, { TextTransparency = 1 }) end
        task.wait(0.3)
        pcall(function() card:Destroy() end)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Actions
-- ═══════════════════════════════════════════════════════════════════════════

local Pages = {}
local showPage
local showOutput
local showInspector

local busy = false

local function formatBytes(n)
    if n < 1024 then return n .. " B" end
    if n < 1024 * 1024 then return string.format("%.1f KB", n / 1024) end
    return string.format("%.2f MB", n / 1024 / 1024)
end

local function grab(inst)
    if busy then
        toast("Busy", "Another grab is already running.", Theme.Warning)
        return nil, "busy"
    end
    busy = true
    setStatus("Grabbing " .. inst.Name .. "...", Theme.Accent)
    setProgress(0)

    local code, stats
    local ok, err = pcall(function()
        code, stats = serialize(inst, Settings, function(phase, done, total)
            if total and total > 0 then
                setProgress(done / total)
                setStatus(string.format("%s %s - %d/%d", phase, inst.Name, done, total), Theme.Accent)
            else
                setStatus(string.format("%s %s - %d", phase, inst.Name, done), Theme.Accent)
            end
        end)
    end)

    busy = false
    setProgress(nil)

    if not ok then
        setStatus("Grab failed: " .. tostring(err), Theme.Danger)
        toast("Grab failed", tostring(err), Theme.Danger, 6)
        return nil, tostring(err)
    end
    return code, stats
end

local function statsSummary(stats)
    return string.format("%d instances | %d properties | %s | %.2fs",
        stats.instances, stats.properties, formatBytes(stats.bytes), stats.elapsed)
end

local function saveToFile(name, code)
    if not has("writefile") then
        toast("Not supported", "Your executor has no writefile. Use Copy instead.", Theme.Warning, 5)
        return nil
    end
    ensureFolders()
    local fileName = string.format("%s/%s_%s.%s",
        OUT_FOLDER, sanitizeFileName(name), os.date("%Y%m%d_%H%M%S"), Settings.fileExtension)
    local ok, err = pcall(ENV.writefile, fileName, code)
    if not ok then
        fileName = string.format("%s_%s.%s", sanitizeFileName(name), os.date("%Y%m%d_%H%M%S"), Settings.fileExtension)
        ok, err = pcall(ENV.writefile, fileName, code)
    end
    if not ok then
        toast("Write failed", tostring(err), Theme.Danger, 6)
        return nil
    end
    return fileName
end

local function copyToClipboard(code)
    if not has("setclipboard") then
        toast("Not supported", "Your executor has no setclipboard.", Theme.Warning, 5)
        return false
    end
    local ok = pcall(ENV.setclipboard, code)
    if not ok then
        toast("Copy failed", "setclipboard threw an error.", Theme.Danger)
        return false
    end
    return true
end

local LastOutput = { code = nil, stats = nil, name = nil }

local function grabAndSave(inst)
    task.spawn(function()
        local code, stats = grab(inst)
        if not code then return end
        LastOutput = { code = code, stats = stats, name = inst.Name }
        local file = saveToFile(inst.Name, code)
        if file then
            setStatus("Saved " .. file, Theme.Success)
            toast("Saved", file .. "\n" .. statsSummary(stats), Theme.Success, 5)
        else
            setStatus("Grabbed " .. inst.Name .. " (not written)", Theme.Warning)
        end
        showOutput(code, stats, inst.Name)
    end)
end

local function grabAndCopy(inst)
    task.spawn(function()
        local code, stats = grab(inst)
        if not code then return end
        LastOutput = { code = code, stats = stats, name = inst.Name }
        if copyToClipboard(code) then
            setStatus("Copied " .. inst.Name .. " to clipboard", Theme.Success)
            toast("Copied", statsSummary(stats), Theme.Success)
        end
        showOutput(code, stats, inst.Name)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Page framework
-- ═══════════════════════════════════════════════════════════════════════════

local currentPage
local navButtons = {}

local function makePage(name)
    local frame = New("Frame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = Content,
    })
    Pad(frame, 12, 12, 12, 12)
    Pages[name] = { frame = frame }
    return frame
end

local function makeNav(name, order)
    local btn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        LayoutOrder = order,
        Parent = Sidebar,
    })
    Corner(6, btn)

    local marker = New("Frame", {
        Size = UDim2.fromOffset(3, 14), Position = UDim2.new(0, 0, 0.5, -7),
        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
        BackgroundTransparency = 1, Parent = btn,
    })
    Corner(2, marker)

    local label = New("TextLabel", {
        Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1, Font = FONT_MED, TextSize = 12,
        TextColor3 = Theme.TextDim, Text = name,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = btn,
    })

    btn.MouseEnter:Connect(function()
        if currentPage ~= name then tween(btn, QUICK, { BackgroundTransparency = 0.5 }) end
    end)
    btn.MouseLeave:Connect(function()
        if currentPage ~= name then tween(btn, QUICK, { BackgroundTransparency = 1 }) end
    end)
    btn.MouseButton1Click:Connect(function() showPage(name) end)

    navButtons[name] = { button = btn, marker = marker, label = label }
    return btn
end

showPage = function(name)
    if not Pages[name] then return end
    currentPage = name
    for pageName, page in pairs(Pages) do
        page.frame.Visible = pageName == name
    end
    for navName, nav in pairs(navButtons) do
        local active = navName == name
        tween(nav.button, QUICK, { BackgroundTransparency = active and 0 or 1 })
        tween(nav.marker, QUICK, { BackgroundTransparency = active and 0 or 1 })
        tween(nav.label, QUICK, { TextColor3 = active and Theme.Text or Theme.TextDim })
    end
    local page = Pages[name]
    if page.onShow then page.onShow() end
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Widgets
-- ═══════════════════════════════════════════════════════════════════════════

local BUTTON_STYLES = {
    primary = { bg = Theme.Accent,   hover = Color3.fromRGB(90, 160, 220), text = Theme.Text },
    ghost   = { bg = Theme.Elevated, hover = Theme.Hover,                   text = Theme.Text },
    subtle  = { bg = Theme.Surface,  hover = Theme.Elevated,                text = Theme.TextDim },
    danger  = { bg = Theme.Danger,   hover = Color3.fromRGB(230, 100, 100), text = Theme.OnAccent },
}

local function Button(parent, text, opts)
    opts = opts or {}
    local style = BUTTON_STYLES[opts.style or "ghost"]
    local btn = New("TextButton", {
        Size = opts.size or UDim2.fromOffset(80, 28),
        Position = opts.position,
        AnchorPoint = opts.anchor,
        BackgroundColor3 = style.bg,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = opts.font or FONT_MED,
        TextSize = opts.textSize or 12,
        TextColor3 = opts.color or style.text,
        Text = text,
        LayoutOrder = opts.order,
        Parent = parent,
    })
    Corner(opts.radius or 6, btn)
    if opts.stroke then Stroke(Theme.Line, 1, 0, btn) end
    hoverable(btn, style.bg, style.hover)
    if opts.onClick then btn.MouseButton1Click:Connect(opts.onClick) end
    return btn
end

local function SearchBox(parent, placeholder)
    local holder = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.Elevated,
        BorderSizePixel = 0, Parent = parent,
    })
    Corner(6, holder)
    Stroke(Theme.Line, 1, 0, holder)
    Glyph.search(New("Frame", {
        Position = UDim2.new(0, 8, 0, 0), Size = UDim2.fromOffset(16, 28),
        BackgroundTransparency = 1, Parent = holder,
    }), Theme.TextFaint)
    local box = New("TextBox", {
        Position = UDim2.new(0, 26, 0, 0), Size = UDim2.new(1, -52, 1, 0),
        BackgroundTransparency = 1, Font = FONT, TextSize = 12,
        TextColor3 = Theme.Text, PlaceholderColor3 = Theme.TextFaint,
        PlaceholderText = placeholder, Text = "", ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = holder,
    })
    local clear = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0),
        Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1,
        Text = "", Visible = false, AutoButtonColor = false, Parent = holder,
    })
    Glyph.cross(clear, 8, Theme.TextFaint, 1.25)
    clear.MouseButton1Click:Connect(function() box.Text = "" end)
    box:GetPropertyChangedSignal("Text"):Connect(function()
        clear.Visible = box.Text ~= ""
    end)
    return box, holder
end

local function ScrollList(parent, props)
    props = props or {}
    local list = New("ScrollingFrame", {
        Position = props.position or UDim2.new(0, 0, 0, 0),
        Size = props.size or UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Line,
        ScrollBarImageTransparency = 0.2,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        Parent = parent,
    })
    ListLayout(list, props.padding or 6)
    New("UIPadding", { PaddingRight = UDim.new(0, 8), Parent = list })
    return list
end

local function Toggle(parent, label, description, initial, onChange, order)
    local row = New("Frame", {
        Size = UDim2.new(1, 0, 0, description and 44 or 32),
        BackgroundTransparency = 1, LayoutOrder = order, Parent = parent,
    })
    New("TextLabel", {
        Size = UDim2.new(1, -60, 0, 16), Position = UDim2.new(0, 0, 0, description and 4 or 8),
        BackgroundTransparency = 1, Font = FONT_MED, TextSize = 12,
        TextColor3 = Theme.Text, Text = label,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    if description then
        New("TextLabel", {
            Size = UDim2.new(1, -60, 0, 16), Position = UDim2.new(0, 0, 0, 22),
            BackgroundTransparency = 1, Font = FONT, TextSize = 11,
            TextColor3 = Theme.TextFaint, Text = description,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
        })
    end

    local track = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(38, 20), BackgroundColor3 = Theme.Elevated,
        BorderSizePixel = 0, AutoButtonColor = false, Text = "", Parent = row,
    })
    Corner(10, track)
    local knob = New("Frame", {
        Size = UDim2.fromOffset(14, 14), Position = UDim2.new(0, 3, 0.5, -7),
        BackgroundColor3 = Theme.TextFaint, BorderSizePixel = 0, Parent = track,
    })
    Corner(7, knob)

    local state = initial
    local function render()
        tween(track, QUICK, { BackgroundColor3 = state and Theme.Accent or Theme.Elevated })
        tween(knob, QUICK, {
            Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
            BackgroundColor3 = state and Theme.OnAccent or Theme.TextFaint,
        })
    end
    render()
    track.MouseButton1Click:Connect(function()
        state = not state
        render()
        onChange(state)
    end)
    return row
end

local function Cycle(parent, label, values, current, onChange, order)
    local row = New("Frame", {
        Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1,
        LayoutOrder = order, Parent = parent,
    })
    New("TextLabel", {
        Size = UDim2.new(1, -130, 1, 0), BackgroundTransparency = 1,
        Font = FONT_MED, TextSize = 12, TextColor3 = Theme.Text, Text = label,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    local index = table.find(values, current) or 1
    local btn = Button(row, tostring(values[index]), {
        style = "ghost", stroke = true,
        size = UDim2.fromOffset(124, 26),
        anchor = Vector2.new(1, 0.5), position = UDim2.new(1, 0, 0.5, 0),
    })
    btn.MouseButton1Click:Connect(function()
        index = index % #values + 1
        btn.Text = tostring(values[index])
        onChange(values[index])
    end)
    return row, btn
end

local function SectionLabel(parent, text, order)
    return New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = order,
        Font = FONT_BOLD, TextSize = 11, TextColor3 = Theme.TextFaint,
        Text = string.upper(text), TextXAlignment = Enum.TextXAlignment.Left,
        Parent = parent,
    })
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Page :: Explorer
-- ═══════════════════════════════════════════════════════════════════════════

makeNav("Explorer", 1)
makeNav("Inspector", 2)
makeNav("Output", 3)
makeNav("Settings", 4)
makeNav("About", 5)

local ExplorerPage = makePage("Explorer")

local Explorer = {
    entries = {},
    marks = {},
    selectors = {},
    selected = nil,
    search = "",
    sort = "Name",
    source = "All",
    known = {},
    firstScan = true,
}

local SORTS = { "Name", "Size", "Source" }
local SOURCES = { "All", "PlayerGui", "CoreGui", "StarterGui" }

local Toolbar = New("Frame", {
    Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Parent = ExplorerPage,
})

local SearchHolder = New("Frame", {
    Size = UDim2.new(1, -212, 1, 0), BackgroundTransparency = 1, Parent = Toolbar,
})
local SearchInput = SearchBox(SearchHolder, "Search GUIs...")

local RefreshBtn, PickBtn, SaveAllBtn, SortBtn
local doScan, renderEntries

SortBtn = Button(Toolbar, "Sort: Name", {
    style = "ghost", stroke = true,
    size = UDim2.fromOffset(92, 28), position = UDim2.new(1, -204, 0, 0),
    onClick = function()
        local i = (table.find(SORTS, Explorer.sort) or 1) % #SORTS + 1
        Explorer.sort = SORTS[i]
        SortBtn.Text = "Sort: " .. Explorer.sort
        renderEntries()
    end,
})

PickBtn = Button(Toolbar, "Pick", {
    style = "ghost", stroke = true,
    size = UDim2.fromOffset(52, 28), position = UDim2.new(1, -108, 0, 0),
})

RefreshBtn = Button(Toolbar, "Scan", {
    style = "primary", size = UDim2.fromOffset(52, 28), position = UDim2.new(1, -52, 0, 0),
    onClick = function() task.spawn(function() doScan(true) end) end,
})

local ChipRow = New("Frame", {
    Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(1, -96, 0, 24),
    BackgroundTransparency = 1, Parent = ExplorerPage,
})
ListLayout(ChipRow, 6, Enum.FillDirection.Horizontal)

local chips = {}
for i, source in ipairs(SOURCES) do
    local chip = New("TextButton", {
        Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Theme.Elevated, BorderSizePixel = 0, AutoButtonColor = false,
        Font = FONT_MED, TextSize = 11, TextColor3 = Theme.TextDim, Text = source,
        LayoutOrder = i, Parent = ChipRow,
    })
    Corner(11, chip)
    Pad(chip, 0, 10, 0, 10)
    chips[source] = chip
    chip.MouseButton1Click:Connect(function()
        Explorer.source = source
        for name, c in pairs(chips) do
            local active = name == source
            tween(c, QUICK, {
                BackgroundColor3 = active and Theme.AccentSoft or Theme.Elevated,
                TextColor3 = active and Theme.Accent or Theme.TextDim,
            })
        end
        renderEntries()
    end)
end

SaveAllBtn = Button(ChipRow, "Save all", {
    style = "ghost", stroke = true, size = UDim2.fromOffset(74, 22),
    textSize = 11, order = 90,
})
local CountLabel = New("TextLabel", {
    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 36),
    Size = UDim2.fromOffset(90, 24), BackgroundTransparency = 1,
    Font = FONT, TextSize = 11, TextColor3 = Theme.TextFaint, Text = "",
    TextXAlignment = Enum.TextXAlignment.Right, Parent = ExplorerPage,
})

local EntryList = ScrollList(ExplorerPage, {
    position = UDim2.new(0, 0, 0, 68), size = UDim2.new(1, 0, 1, -68), padding = 6,
})

local EmptyState = New("TextLabel", {
    Position = UDim2.new(0, 0, 0, 68), Size = UDim2.new(1, 0, 1, -68),
    BackgroundTransparency = 1, Font = FONT, TextSize = 12,
    TextColor3 = Theme.TextFaint, Text = "", TextWrapped = true, Visible = false,
    Parent = ExplorerPage,
})

local function makeEntry(info, isNew, order)
    local card = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        LayoutOrder = order,
        Parent = EntryList,
    })
    Corner(8, card)
    local cardStroke = Stroke(Theme.Line, 1, 0, card)

    New("TextLabel", {
        Position = UDim2.new(0, 12, 0, 9), Size = UDim2.new(1, -262, 0, 16),
        BackgroundTransparency = 1, Font = FONT_BOLD, TextSize = 12,
        TextColor3 = Theme.Text, Text = info.name,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = card,
    })

    local meta = New("Frame", {
        Position = UDim2.new(0, 12, 0, 29), Size = UDim2.new(1, -262, 0, 16),
        BackgroundTransparency = 1, Parent = card,
    })
    ListLayout(meta, 6, Enum.FillDirection.Horizontal).VerticalAlignment = Enum.VerticalAlignment.Center

    local function badge(text, color, bg, order2)
        local b = New("TextLabel", {
            Size = UDim2.fromOffset(0, 15), AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = bg, BorderSizePixel = 0, Font = FONT_MED, TextSize = 10,
            TextColor3 = color, Text = text, LayoutOrder = order2, Parent = meta,
        })
        Corner(4, b)
        Pad(b, 0, 6, 0, 6)
        return b
    end

    badge(info.source, Theme.TextDim, Theme.Elevated, 1)
    badge(info.class, Theme.Accent, Theme.Elevated, 2)
    badge(info.count .. " children", Theme.TextFaint, Theme.Elevated, 3)
    if isNew then badge("NEW", Theme.Text, Theme.Success, 0) end

    local function actionButton(x, width, text, onClick)
        local btn = New("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, x, 0.5, 0),
            Size = UDim2.fromOffset(width, 26), BackgroundColor3 = Theme.Elevated,
            BorderSizePixel = 0, AutoButtonColor = false, Font = FONT_MED,
            TextSize = 11, TextColor3 = Theme.TextDim, Text = text, Parent = card,
        })
        Corner(6, btn)
        hoverable(btn, Theme.Elevated, Theme.Hover)
        btn.MouseButton1Click:Connect(onClick)
        return btn
    end

    Button(card, "Save", {
        style = "primary", size = UDim2.fromOffset(46, 26), textSize = 11,
        anchor = Vector2.new(1, 0.5), position = UDim2.new(1, -10, 0.5, 0),
        onClick = function() grabAndSave(info.gui) end,
    })
    actionButton(-60, 42, "Copy", function() grabAndCopy(info.gui) end)
    actionButton(-106, 42, "Tree", function() showInspector(info.gui) end)

    local markBtn
    local function setMarked(on)
        markBtn.TextColor3 = on and Theme.Accent or Theme.TextDim
        tween(cardStroke, QUICK, { Color = on and Theme.Accent or Theme.Line })
    end

    markBtn = actionButton(-152, 44, "Mark", function()
        local on = Highlight.toggle(info.gui)
        for _, reset in ipairs(Explorer.marks) do reset(false) end
        setMarked(on)
        setStatus(on and ("Highlighting " .. info.name) or "Highlight cleared",
            on and Theme.Accent or Theme.TextDim)
    end)
    Explorer.marks[#Explorer.marks + 1] = setMarked

    local visBtn
    visBtn = actionButton(-200, 44, info.gui.Enabled and "Hide" or "Show", function()
        local ok = pcall(function() info.gui.Enabled = not info.gui.Enabled end)
        if ok then
            visBtn.Text = info.gui.Enabled and "Hide" or "Show"
            visBtn.TextColor3 = info.gui.Enabled and Theme.TextDim or Theme.Warning
        end
    end)

    local isSelected = false
    local function setSelected(on)
        isSelected = on
        tween(card, QUICK, { BackgroundColor3 = on and Theme.AccentSoft or Theme.Surface })
    end
    Explorer.selectors[#Explorer.selectors + 1] = setSelected
    if Explorer.selected == info.gui then setSelected(true) end

    card.MouseButton1Click:Connect(function()
        for _, reset in ipairs(Explorer.selectors) do reset(false) end
        Explorer.selected = info.gui
        setSelected(true)
        setStatus("Selected " .. info.name, Theme.Accent)
        if Settings.highlightOnSelect then
            for _, reset in ipairs(Explorer.marks) do reset(false) end
            Highlight.set(info.gui)
            setMarked(true)
        end
    end)

    card.MouseEnter:Connect(function()
        if not isSelected then tween(card, QUICK, { BackgroundColor3 = Theme.Elevated }) end
    end)
    card.MouseLeave:Connect(function()
        if not isSelected then tween(card, QUICK, { BackgroundColor3 = Theme.Surface }) end
    end)

    return card
end

renderEntries = function()
    for _, row in ipairs(EntryList:GetChildren()) do
        if row:IsA("GuiObject") then row:Destroy() end
    end
    table.clear(Explorer.marks)
    table.clear(Explorer.selectors)

    local query = Explorer.search:lower():gsub("%s", "")
    local visible = {}
    for _, info in ipairs(Explorer.entries) do
        local sourceOk = Explorer.source == "All" or info.source == Explorer.source
            or (Explorer.source == "CoreGui" and info.source == "Hidden")
        local searchOk = query == ""
            or info.name:lower():find(query, 1, true) ~= nil
            or info.class:lower():find(query, 1, true) ~= nil
        if sourceOk and searchOk then visible[#visible + 1] = info end
    end

    if Explorer.sort == "Name" then
        table.sort(visible, function(a, b) return a.name:lower() < b.name:lower() end)
    elseif Explorer.sort == "Size" then
        table.sort(visible, function(a, b) return a.count > b.count end)
    else
        table.sort(visible, function(a, b)
            if a.source == b.source then return a.name:lower() < b.name:lower() end
            return a.source < b.source
        end)
    end

    for i, info in ipairs(visible) do
        makeEntry(info, info.isNew, i)
    end

    CountLabel.Text = string.format("%d / %d", #visible, #Explorer.entries)
    EmptyState.Visible = #visible == 0
    EntryList.Visible = #visible > 0
    if #visible == 0 then
        EmptyState.Text = #Explorer.entries == 0
            and "No GUIs found yet.\nPress Scan to search."
            or "Nothing matches this filter."
    end
end

SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
    Explorer.search = SearchInput.Text
    renderEntries()
end)

doScan = function(announce)
    RefreshBtn.Text = "..."
    setStatus("Scanning...", Theme.Accent)

    local results = scanContainers()
    local newOnes = {}
    for _, info in ipairs(results) do
        local key = info.source .. "/" .. info.name
        info.isNew = not Explorer.firstScan and not Explorer.known[key]
        if info.isNew then newOnes[#newOnes + 1] = info.name end
        Explorer.known[key] = true
    end
    Explorer.entries = results
    Explorer.firstScan = false
    renderEntries()

    RefreshBtn.Text = "Scan"
    setStatus(string.format("%d GUI%s found", #results, #results == 1 and "" or "s"),
        #results > 0 and Theme.Success or Theme.Warning)

    if announce and #newOnes > 0 then
        toast("New GUIs", table.concat(newOnes, ", "), Theme.Success)
    end
    return results
end

SaveAllBtn.MouseButton1Click:Connect(function()
    if busy then return end
    task.spawn(function()
        local targets = {}
        for _, info in ipairs(Explorer.entries) do
            if Explorer.source == "All" or info.source == Explorer.source then
                targets[#targets + 1] = info
            end
        end
        if #targets == 0 then
            toast("Nothing to save", "Scan first.", Theme.Warning)
            return
        end

        local saved, failed = 0, 0
        for i, info in ipairs(targets) do
            setStatus(string.format("Saving %d/%d - %s", i, #targets, info.name), Theme.Accent)
            setProgress((i - 1) / #targets)
            local code = select(1, grab(info.gui))
            if code and saveToFile(info.name, code) then saved += 1 else failed += 1 end
            task.wait()
        end
        setProgress(nil)
        setStatus(string.format("Saved %d, failed %d", saved, failed),
            failed == 0 and Theme.Success or Theme.Warning)
        toast("Batch complete", string.format("%d saved, %d failed", saved, failed),
            failed == 0 and Theme.Success or Theme.Warning, 5)
    end)
end)

local function togglePicker()
    if Picker.active then
        Picker.finish(nil)
        return
    end

    local wasVisible = Window.Visible
    PickBtn.Text = "..."
    setStatus("Click an element, Esc to cancel", Theme.Accent)
    Window.Visible = false

    Picker.start(function(obj)
        Window.Visible = wasVisible
        PickBtn.Text = "Pick"
        if not obj then
            setStatus("Picker cancelled", Theme.TextDim)
            return
        end
        setStatus("Picked " .. obj.Name, Theme.Accent)
        showInspector(obj)
    end)
end

PickBtn.MouseButton1Click:Connect(togglePicker)

chips.All.BackgroundColor3 = Theme.AccentSoft
chips.All.TextColor3 = Theme.Accent

-- ═══════════════════════════════════════════════════════════════════════════
--  Page :: Inspector
-- ═══════════════════════════════════════════════════════════════════════════

local InspectorPage = makePage("Inspector")

local Inspector = {
    root = nil,
    expanded = {},
    selected = nil,
    MAX_ROWS = 500,
}

local InspectorHeader = New("Frame", {
    Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Parent = InspectorPage,
})

local InspectorTitle = New("TextLabel", {
    Size = UDim2.new(1, -180, 1, 0), BackgroundTransparency = 1,
    Font = FONT_BOLD, TextSize = 12, TextColor3 = Theme.Text,
    Text = "Nothing selected", TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd, Parent = InspectorHeader,
})

local renderTree

local ExpandAllBtn = Button(InspectorHeader, "Expand", {
    style = "ghost", stroke = true, size = UDim2.fromOffset(62, 28),
    position = UDim2.new(1, -170, 0, 0), textSize = 11,
})
Button(InspectorHeader, "Collapse", {
    style = "ghost", stroke = true, size = UDim2.fromOffset(68, 28),
    position = UDim2.new(1, -104, 0, 0), textSize = 11,
    onClick = function()
        Inspector.expanded = {}
        if Inspector.root then Inspector.expanded[Inspector.root] = true end
        renderTree()
    end,
})
local UpBtn = Button(InspectorHeader, "Up", {
    style = "ghost", stroke = true, size = UDim2.fromOffset(32, 28),
    position = UDim2.new(1, -32, 0, 0), textSize = 11,
    onClick = function()
        if Inspector.root and Inspector.root.Parent
        and Inspector.root.Parent ~= game and not Inspector.root:IsA("LayerCollector") then
            showInspector(Inspector.root.Parent)
        end
    end,
})

local TreeList = ScrollList(InspectorPage, {
    position = UDim2.new(0, 0, 0, 36), size = UDim2.new(1, 0, 1, -36), padding = 2,
})

local InspectorEmpty = New("TextLabel", {
    Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(1, 0, 1, -36),
    BackgroundTransparency = 1, Font = FONT, TextSize = 12, TextColor3 = Theme.TextFaint,
    Text = "Choose a GUI in Explorer, or use Pick to click one on screen.",
    TextWrapped = true, Parent = InspectorPage,
})

local CLASS_COLORS = {
    ScreenGui = Theme.Accent, BillboardGui = Theme.Accent, SurfaceGui = Theme.Accent,
    Frame = Theme.Text, ScrollingFrame = Theme.Text, CanvasGroup = Theme.Text,
    TextLabel = Theme.Success, TextButton = Theme.Success, TextBox = Theme.Success,
    ImageLabel = Theme.Warning, ImageButton = Theme.Warning, ViewportFrame = Theme.Warning,
}
local function classColor(className)
    if CLASS_COLORS[className] then return CLASS_COLORS[className] end
    if className:sub(1, 2) == "UI" then return Theme.Accent end
    return Theme.TextDim
end

local function treeRow(inst, depth, order)
    local kids = inst:GetChildren()
    local hasKids = #kids > 0
    local isSelected = Inspector.selected == inst

    local row = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundColor3 = isSelected and Theme.AccentSoft or Theme.Surface,
        BackgroundTransparency = isSelected and 0 or 1,
        BorderSizePixel = 0, AutoButtonColor = false, Text = "",
        LayoutOrder = order, Parent = TreeList,
    })
    Corner(4, row)

    local indent = 8 + depth * 14

    if hasKids then
        local arrow = New("TextButton", {
            Position = UDim2.new(0, indent - 4, 0, 0), Size = UDim2.fromOffset(16, 24),
            BackgroundTransparency = 1, AutoButtonColor = false, Font = FONT_BOLD,
            TextSize = 12, TextColor3 = Theme.TextFaint,
            Text = Inspector.expanded[inst] and "-" or "+", Parent = row,
        })
        arrow.MouseButton1Click:Connect(function()
            Inspector.expanded[inst] = not Inspector.expanded[inst]
            renderTree()
        end)
    end

    New("TextLabel", {
        Position = UDim2.new(0, indent + 14, 0, 0), Size = UDim2.new(1, -indent - 264, 1, 0),
        BackgroundTransparency = 1, Font = FONT_MED, TextSize = 11,
        TextColor3 = Theme.Text, Text = inst.Name,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
    })

    New("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -134, 0.5, 0),
        Size = UDim2.fromOffset(110, 24), BackgroundTransparency = 1,
        Font = FONT, TextSize = 10, TextColor3 = classColor(inst.ClassName),
        Text = inst.ClassName, TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
    })

    local function mini(x, text, onClick)
        local btn = New("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, x, 0.5, 0),
            Size = UDim2.fromOffset(38, 20), BackgroundColor3 = Theme.Elevated,
            BorderSizePixel = 0, AutoButtonColor = false, Font = FONT_MED,
            TextSize = 10, TextColor3 = Theme.TextDim, Text = text,
            BackgroundTransparency = 1, TextTransparency = 1, Parent = row,
        })
        Corner(4, btn)
        btn.MouseButton1Click:Connect(onClick)
        return btn
    end

    local saveMini = mini(-6, "Save", function() grabAndSave(inst) end)
    local copyMini = mini(-48, "Copy", function() grabAndCopy(inst) end)
    local viewMini = mini(-90, "Mark", function()
        Highlight.toggle(inst, Theme.Accent)
    end)
    local minis = { saveMini, copyMini, viewMini }

    row.MouseEnter:Connect(function()
        if not isSelected then tween(row, QUICK, { BackgroundTransparency = 0.35 }) end
        for _, b in ipairs(minis) do tween(b, QUICK, { BackgroundTransparency = 0, TextTransparency = 0 }) end
    end)
    row.MouseLeave:Connect(function()
        if not isSelected then tween(row, QUICK, { BackgroundTransparency = 1 }) end
        for _, b in ipairs(minis) do tween(b, QUICK, { BackgroundTransparency = 1, TextTransparency = 1 }) end
    end)
    row.MouseButton1Click:Connect(function()
        Inspector.selected = inst
        if Settings.highlightOnSelect then Highlight.set(inst, Theme.Accent) end
        setStatus(string.format("%s  |  %s  |  %d descendants",
            inst.Name, inst.ClassName, countDescendants(inst)), Theme.Accent)
        renderTree()
    end)

    return row
end

renderTree = function()
    for _, child in ipairs(TreeList:GetChildren()) do
        if child:IsA("GuiObject") then child:Destroy() end
    end

    local root = Inspector.root
    InspectorEmpty.Visible = root == nil
    TreeList.Visible = root ~= nil
    if not root then
        InspectorTitle.Text = "Nothing selected"
        return
    end

    InspectorTitle.Text = string.format("%s  |  %s  |  %d descendants",
        root.Name, root.ClassName, countDescendants(root))

    local order, truncated = 0, false
    local function walk(inst, depth)
        if order >= Inspector.MAX_ROWS then truncated = true return end
        order += 1
        treeRow(inst, depth, order)
        if Inspector.expanded[inst] then
            for _, child in ipairs(inst:GetChildren()) do walk(child, depth + 1) end
        end
    end
    walk(root, 0)

    if truncated then
        New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = 1e6,
            Font = FONT, TextSize = 11, TextColor3 = Theme.Warning,
            Text = string.format("  ... tree truncated at %d rows", Inspector.MAX_ROWS),
            TextXAlignment = Enum.TextXAlignment.Left, Parent = TreeList,
        })
    end
end

ExpandAllBtn.MouseButton1Click:Connect(function()
    if not Inspector.root then return end
    local n = 0
    local function walk(inst, depth)
        if n > Inspector.MAX_ROWS or depth > 6 then return end
        Inspector.expanded[inst] = true
        n += 1
        for _, child in ipairs(inst:GetChildren()) do walk(child, depth + 1) end
    end
    walk(Inspector.root, 0)
    renderTree()
end)

showInspector = function(inst)
    Inspector.root = inst
    Inspector.selected = inst
    Inspector.expanded = { [inst] = true }
    for _, child in ipairs(inst:GetChildren()) do
        if #child:GetChildren() > 0 and #child:GetChildren() < 12 then
            Inspector.expanded[child] = true
        end
    end
    renderTree()
    showPage("Inspector")
    if Settings.highlightOnSelect then Highlight.set(inst, Theme.Accent) end
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Page :: Output
-- ═══════════════════════════════════════════════════════════════════════════

local OutputPage = makePage("Output")

local PREVIEW_LIMIT = 40000

local OutputHeader = New("Frame", {
    Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Parent = OutputPage,
})
local OutputTitle = New("TextLabel", {
    Size = UDim2.new(1, -128, 0, 14), BackgroundTransparency = 1,
    Font = FONT_BOLD, TextSize = 12, TextColor3 = Theme.Text, Text = "No output yet",
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    Parent = OutputHeader,
})
local OutputStats = New("TextLabel", {
    Position = UDim2.new(0, 0, 0, 15), Size = UDim2.new(1, -128, 0, 12),
    BackgroundTransparency = 1, Font = FONT, TextSize = 10, TextColor3 = Theme.TextFaint,
    Text = "Grab a GUI to see its source here.",
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    Parent = OutputHeader,
})

Button(OutputHeader, "Copy", {
    style = "ghost", stroke = true, size = UDim2.fromOffset(56, 28),
    position = UDim2.new(1, -118, 0, 0),
    onClick = function()
        if not LastOutput.code then return end
        if copyToClipboard(LastOutput.code) then
            toast("Copied", formatBytes(#LastOutput.code) .. " to clipboard", Theme.Success)
        end
    end,
})
Button(OutputHeader, "Save", {
    style = "primary", size = UDim2.fromOffset(56, 28), position = UDim2.new(1, -56, 0, 0),
    onClick = function()
        if not LastOutput.code then return end
        local file = saveToFile(LastOutput.name or "Gui", LastOutput.code)
        if file then toast("Saved", file, Theme.Success, 5) end
    end,
})

local CodeHolder = New("Frame", {
    Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(1, 0, 1, -36),
    BackgroundColor3 = Theme.Surface, BorderSizePixel = 0, ClipsDescendants = true,
    Parent = OutputPage,
})
Corner(8, CodeHolder)
Stroke(Theme.Line, 1, 0, CodeHolder)

local CodeScroll = New("ScrollingFrame", {
    Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
    ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Line,
    CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.XY,
    ScrollingDirection = Enum.ScrollingDirection.XY,
    ElasticBehavior = Enum.ElasticBehavior.Never, Parent = CodeHolder,
})
Pad(CodeScroll, 10, 10, 10, 10)

local CodeBox = New("TextBox", {
    Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY,
    BackgroundTransparency = 1, Font = FONT_MONO, TextSize = 11,
    TextColor3 = Theme.TextDim, Text = "", TextEditable = false,
    ClearTextOnFocus = false, MultiLine = true, TextWrapped = false,
    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
    Parent = CodeScroll,
})

showOutput = function(code, stats, name)
    LastOutput = { code = code, stats = stats, name = name }
    OutputTitle.Text = name or "Output"

    local classList = {}
    for className, n in pairs(stats.classes) do classList[#classList + 1] = { className, n } end
    table.sort(classList, function(a, b) return a[2] > b[2] end)
    local top = {}
    for i = 1, math.min(4, #classList) do
        top[#top + 1] = classList[i][1] .. " x" .. classList[i][2]
    end

    OutputStats.Text = statsSummary(stats)
        .. (stats.skipped > 0 and (" | " .. stats.skipped .. " skipped") or "")
        .. (#top > 0 and ("   " .. table.concat(top, ", ")) or "")

    if #code > PREVIEW_LIMIT then
        CodeBox.Text = code:sub(1, PREVIEW_LIMIT)
            .. string.format("\n\n-- [ preview truncated: %s of %s shown, save or copy for the full source ]",
                formatBytes(PREVIEW_LIMIT), formatBytes(#code))
    else
        CodeBox.Text = code
    end
    showPage("Output")
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Page :: Settings
-- ═══════════════════════════════════════════════════════════════════════════

local SettingsPage = makePage("Settings")
local SettingsScroll = ScrollList(SettingsPage, { padding = 2 })

local function bindSetting(key)
    return function(value)
        Settings[key] = value
        saveSettings()
    end
end

SectionLabel(SettingsScroll, "Output", 1)
Toggle(SettingsScroll, "Include comments", "Header block and a label above each instance",
    Settings.includeComments, bindSetting("includeComments"), 2)
Toggle(SettingsScroll, "Include attributes", "Emit SetAttribute calls for custom attributes",
    Settings.includeAttributes, bindSetting("includeAttributes"), 3)
Toggle(SettingsScroll, "Include non-GUI children", "Folders, value objects and other descendants",
    Settings.includeNonGui, bindSetting("includeNonGui"), 4)
Toggle(SettingsScroll, "Minify", "Short variable names, no comments or blank lines",
    Settings.minify, bindSetting("minify"), 5)
Cycle(SettingsScroll, "File extension", { "lua", "txt", "luau" }, Settings.fileExtension,
    bindSetting("fileExtension"), 6)
Cycle(SettingsScroll, "Rebuild target", { "PlayerGui", "CoreGui", "gethui" }, Settings.parentTarget,
    bindSetting("parentTarget"), 7)

New("Frame", { Size = UDim2.new(1, 0, 0, 10), BackgroundTransparency = 1, LayoutOrder = 10, Parent = SettingsScroll })
SectionLabel(SettingsScroll, "Scanning", 11)
Toggle(SettingsScroll, "Auto-detect new GUIs", "Toast when a GUI appears while you play",
    Settings.autoDetect, bindSetting("autoDetect"), 12)
Toggle(SettingsScroll, "Scan CoreGui", "Include CoreGui and the hidden container",
    Settings.scanCoreGui, bindSetting("scanCoreGui"), 13)
Toggle(SettingsScroll, "Scan StarterGui", "Include StarterGui templates",
    Settings.scanStarterGui, bindSetting("scanStarterGui"), 14)
Toggle(SettingsScroll, "Highlight on select", "Outline a GUI when you select it in the tree",
    Settings.highlightOnSelect, bindSetting("highlightOnSelect"), 15)

New("Frame", { Size = UDim2.new(1, 0, 0, 10), BackgroundTransparency = 1, LayoutOrder = 20, Parent = SettingsScroll })
SectionLabel(SettingsScroll, "Keybinds", 21)

local listening = nil
local function KeyBind(label, key, order)
    local row = New("Frame", {
        Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = order,
        Parent = SettingsScroll,
    })
    New("TextLabel", {
        Size = UDim2.new(1, -130, 1, 0), BackgroundTransparency = 1, Font = FONT_MED,
        TextSize = 12, TextColor3 = Theme.Text, Text = label,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    local btn = Button(row, Settings[key], {
        style = "ghost", stroke = true, size = UDim2.fromOffset(124, 26),
        anchor = Vector2.new(1, 0.5), position = UDim2.new(1, 0, 0.5, 0), font = FONT_MONO,
    })
    btn.MouseButton1Click:Connect(function()
        if listening then listening.button.Text = Settings[listening.key] end
        listening = { key = key, button = btn }
        btn.Text = "press a key..."
    end)
    return row
end

KeyBind("Toggle window", "toggleKey", 22)
KeyBind("Rescan", "refreshKey", 23)
KeyBind("Element picker", "pickKey", 24)

New("Frame", { Size = UDim2.new(1, 0, 0, 10), BackgroundTransparency = 1, LayoutOrder = 30, Parent = SettingsScroll })
SectionLabel(SettingsScroll, "Maintenance", 31)

local MaintRow = New("Frame", {
    Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 32,
    Parent = SettingsScroll,
})
ListLayout(MaintRow, 8, Enum.FillDirection.Horizontal)
Button(MaintRow, "Clear highlights", {
    style = "ghost", stroke = true, size = UDim2.fromOffset(114, 28), order = 1,
    onClick = function()
        Highlight.clear()
        setStatus("Highlights cleared", Theme.TextDim)
    end,
})
Button(MaintRow, "Reset settings", {
    style = "ghost", stroke = true, size = UDim2.fromOffset(104, 28), order = 2,
    onClick = function()
        toast("Reset", "Re-run the script to load defaults.", Theme.Warning)
        if has("writefile") then pcall(ENV.writefile, SETTINGS_FILE, "{}") end
    end,
})
Button(MaintRow, "Unload", {
    style = "danger", size = UDim2.fromOffset(72, 28), order = 3,
    onClick = function()
        Highlight.clear()
        Picker.stop()
        for _, conn in ipairs(Connections) do pcall(function() conn:Disconnect() end) end
        table.clear(Connections)
        pcall(function() RootGui:Destroy() end)
        pcall(function() Overlay:Destroy() end)
    end,
})

-- ═══════════════════════════════════════════════════════════════════════════
--  Page :: About
-- ═══════════════════════════════════════════════════════════════════════════

local AboutPage = makePage("About")
local AboutScroll = ScrollList(AboutPage, { padding = 8 })

local function AboutCard(title, lines, order)
    local card = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Surface, BorderSizePixel = 0,
        LayoutOrder = order, Parent = AboutScroll,
    })
    Corner(8, card)
    Stroke(Theme.Line, 1, 0, card)
    Pad(card, 12, 12, 12, 12)
    ListLayout(card, 4)
    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = 1,
        Font = FONT_BOLD, TextSize = 12, TextColor3 = Theme.Accent, Text = title,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = card,
    })
    for i, text in ipairs(lines) do
        New("TextLabel", {
            Name = "Line" .. i,
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = i + 1, Font = FONT, TextSize = 11,
            TextColor3 = Theme.TextDim, Text = text, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = card,
        })
    end
    return card
end

AboutCard("Xavi GUI Copier v" .. VERSION, {
    "Serializes any Roblox interface back into runnable Luau source.",
    "Scan, browse the tree, then save or copy a whole GUI or a single branch.",
    "Discord: " .. DISCORD,
}, 1)

local KeybindCard = AboutCard("Keybinds", {
    "",
    "Escape cancels the picker. Drag the title bar to move, drag the corner to resize.",
}, 2)

local KeybindLine = KeybindCard:FindFirstChild("Line1")
Pages.About.onShow = function()
    KeybindLine.Text = string.format(
        "Toggle window  -  %s\nRescan  -  %s\nElement picker  -  %s",
        Settings.toggleKey, Settings.refreshKey, Settings.pickKey)
end

AboutCard("Environment", {
    "Executor: " .. EXECUTOR,
    "writefile: " .. (has("writefile") and "available" or "missing, saving disabled"),
    "setclipboard: " .. (has("setclipboard") and "available" or "missing, copying disabled"),
    "gethui: " .. (ENV.gethui and "available" or "missing, UI lives in CoreGui"),
    "Output folder: " .. OUT_FOLDER,
}, 3)

AboutCard("Notes", {
    "Highlighting draws into a separate overlay, so the GUI you are inspecting is never modified.",
    "The generated source recreates properties that differ from the class default. Images referenced by asset id are kept as ids, not downloaded.",
    "Scripts inside a GUI cannot be recovered - their source is not readable at runtime. The instances themselves are recreated empty.",
}, 4)

-- ═══════════════════════════════════════════════════════════════════════════
--  Window controls
-- ═══════════════════════════════════════════════════════════════════════════

local minimized, restoreSize = false, Window.Size

local function setMinimized(state)
    minimized = state
    if state then
        restoreSize = Window.Size
        Body.Visible = false
        StatusBar.Visible = false
        Grip.Visible = false
        TitleSquareOff.Visible = false
        TitleDivider.Visible = false
        tween(Window, SMOOTH, { Size = UDim2.fromOffset(Window.AbsoluteSize.X, 40) })
        MinBar.Visible = false
        MinBox.Visible = true
    else
        Body.Visible = true
        StatusBar.Visible = true
        Grip.Visible = true
        TitleSquareOff.Visible = true
        TitleDivider.Visible = true
        tween(Window, SMOOTH, { Size = restoreSize })
        MinBar.Visible = true
        MinBox.Visible = false
    end
end

MinBtn.MouseButton1Click:Connect(function() setMinimized(not minimized) end)

local function setWindowVisible(state)
    Window.Visible = state
    if not state then Picker.stop() end
end

CloseBtn.MouseButton1Click:Connect(function()
    setWindowVisible(false)
    toast("Hidden", "Press " .. Settings.toggleKey .. " to bring the window back.", Theme.TextDim, 4)
end)

local function fitToViewport()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize
    if not viewport or viewport.X == 0 then return end

    local size = minimized and restoreSize or Window.Size
    local w = math.clamp(size.X.Offset, MIN_W, math.max(MIN_W, viewport.X - 20))
    local h = math.clamp(size.Y.Offset, MIN_H, math.max(MIN_H, viewport.Y - 20))
    restoreSize = UDim2.fromOffset(w, h)
    if not minimized then Window.Size = restoreSize end

    local pos = Window.Position
    local x = math.clamp(pos.X.Scale * viewport.X + pos.X.Offset, 0, math.max(0, viewport.X - w))
    local y = math.clamp(pos.Y.Scale * viewport.Y + pos.Y.Offset, 0, math.max(0, viewport.Y - 40))
    Window.Position = UDim2.fromOffset(x, y)
end

if workspace.CurrentCamera then
    track(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        task.defer(fitToViewport)
    end))
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Keybinds
-- ═══════════════════════════════════════════════════════════════════════════

local function keyCodeOf(name)
    local ok, key = pcall(function() return Enum.KeyCode[name] end)
    return ok and key or nil
end

track(UserInputService.InputBegan:Connect(function(input, processed)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    if listening then
        local name = input.KeyCode.Name
        if name ~= "Unknown" then
            Settings[listening.key] = name
            listening.button.Text = name
            saveSettings()
            toast("Keybind set", name, Theme.Success, 2)
        end
        listening = nil
        return
    end

    if processed then return end

    if input.KeyCode == keyCodeOf(Settings.toggleKey) then
        setWindowVisible(not Window.Visible)
    elseif input.KeyCode == keyCodeOf(Settings.refreshKey) then
        task.spawn(function() doScan(true) end)
        if not Window.Visible then toast("Rescanned", nil, Theme.Accent, 2) end
    elseif input.KeyCode == keyCodeOf(Settings.pickKey) then
        togglePicker()
    end
end))

-- ═══════════════════════════════════════════════════════════════════════════
--  Auto-detect
-- ═══════════════════════════════════════════════════════════════════════════

do
    local pending, scheduled = {}, false

    local function noticed(child)
        if not Settings.autoDetect then return end
        if child == RootGui or child == Overlay then return end
        local ok, isCollector = pcall(function() return child:IsA("LayerCollector") end)
        if not ok or not isCollector then return end

        pending[#pending + 1] = child.Name
        if scheduled then return end
        scheduled = true

        task.delay(0.75, function()
            scheduled = false
            local names = table.concat(pending, ", ")
            local n = #pending
            pending = {}
            if n == 0 then return end
            pcall(doScan, false)
            toast(n == 1 and "New GUI detected" or (n .. " new GUIs detected"), names, Theme.Accent, 5)
        end)
    end

    track(PlayerGui.ChildAdded:Connect(noticed))
    pcall(function() track(CoreGui.ChildAdded:Connect(noticed)) end)
end

-- ═══════════════════════════════════════════════════════════════════════════
--  Startup
-- ═══════════════════════════════════════════════════════════════════════════

showPage("Explorer")
renderEntries()
fitToViewport()
ensureFolders()

task.spawn(function()
    task.wait(0.35)
    local results = doScan(false)
    toast("Xavi GUI Copier v" .. VERSION,
        string.format("%d GUI%s found. %s toggles this window.\nDiscord: %s",
            #results, #results == 1 and "" or "s", Settings.toggleKey, DISCORD),
        Theme.Accent, 6)
end)