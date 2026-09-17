-- SNIPER DUELS — LEAKED BY OZ.V8
print("[SniperDuels] Loading step 1 - init")

local Keys = {
    circle       = Enum.KeyCode.E, speed = Enum.KeyCode.Q, carryMode = Enum.KeyCode.C,
    laggerToggle = Enum.KeyCode.K, dropBrainrot = Enum.KeyCode.H, tpDown = Enum.KeyCode.T,
    autoLeft     = Enum.KeyCode.J, autoRight = Enum.KeyCode.L, batDesyncTp = Enum.KeyCode.X,
    instantReset = Enum.KeyCode.R, tpBat = Enum.KeyCode.V, antiDie = Enum.KeyCode.Y,
}

local THEME = {
    Pink      = Color3.fromRGB(255, 20, 147),
    PinkDark  = Color3.fromRGB(180, 10, 100),
    PinkGlow  = Color3.fromRGB(255, 105, 180),
    Black     = Color3.fromRGB(10, 10, 10),
    BlackSoft = Color3.fromRGB(18, 18, 20),
    Grey      = Color3.fromRGB(60, 60, 62),
}

local ANIMATION_PACKS = {
    ["Adidas Sports"]={WalkAnim=18537392113,RunAnim=18537384940,JumpAnim=18537380791,FallAnim=18537367238,SwimIdle=18537387180,Swim=18537389531,Animation1=18537376492,Animation2=18537371272,ClimbAnim=18537363391},
    ["Adidas Community"]={WalkAnim=122150855457006,RunAnim=82598234841035,JumpAnim=75290611992385,FallAnim=98600215928904,SwimIdle=109346520324160,Swim=133308483266208,Animation1=122257458498464,Animation2=102357151005774,ClimbAnim=88763136693023},
    ["Adidas Aura"]={WalkAnim=83842218823011,RunAnim=118320322718866,JumpAnim=109996626521204,FallAnim=95603166884636,SwimIdle=94922130551805,Swim=134530128383903,Animation1=110211186840347,Animation2=114191137265065,ClimbAnim=97824616490448},
    ["Wicked Popular"]={WalkAnim=92072849924640,RunAnim=72301599441680,JumpAnim=104325245285198,FallAnim=121152442762481,Animation1=118832222982049,ClimbAnim=131326830509784,SwimIdle=113199415118199,Swim=99384245425157,Animation2=76049494037641},
    ["Elder"]={WalkAnim=10921111375,RunAnim=10921104374,JumpAnim=10921107367,FallAnim=10921105765,SwimIdle=10921110146,Swim=10921108971,ClimbAnim=10921100400,Animation1=10921101664,Animation2=10921102574},
    ["Zombie"]={WalkAnim=10921355261,RunAnim=616163682,JumpAnim=10921351278,FallAnim=10921350320,SwimIdle=10921353442,Swim=10921352344,Animation1=10921344533,Animation2=10921345304,ClimbAnim=10921343576},
    ["Mage"]={WalkAnim=10921152678,RunAnim=10921148209,JumpAnim=10921149743,FallAnim=10921148939,SwimIdle=10921151661,Swim=10921150788,ClimbAnim=10921143404,Animation1=10921144709,Animation2=10921145797},
    ["Catwalk Glam"]={WalkAnim=109168724482748,RunAnim=81024476153754,JumpAnim=116936326516985,FallAnim=92294537340807,SwimIdle=98854111361360,Swim=134591743181628,ClimbAnim=119377220967554,Animation1=133806214992291,Animation2=94970088341563},
    ["Astronaut"]={WalkAnim=10921046031,RunAnim=10921039308,JumpAnim=10921042494,FallAnim=10921040576,SwimIdle=10921045006,Swim=10921044000,ClimbAnim=10921032124,Animation1=10921034824,Animation2=10921036806},
    ['Wicked "Dancing Through Life"']={WalkAnim=73718308412641,RunAnim=135515454877967,JumpAnim=78508480717326,FallAnim=78147885297412,SwimIdle=129183123083281,Swim=110657013921774,ClimbAnim=129447497744818,Animation1=92849173543269,Animation2=132238900951109},
    ["Werewolf"]={WalkAnim=10921342074,RunAnim=10921336997,FallAnim=10921337907,SwimIdle=10921341319,Swim=10921340419,ClimbAnim=10921329322,Animation1=10921330408,Animation2=10921333667},
    ["Superhero"]={WalkAnim=10921298616,RunAnim=10921291831,JumpAnim=10921294559,FallAnim=10921293373,SwimIdle=10921297391,Swim=10921295495,ClimbAnim=10921286911,Animation1=10921288909,Animation2=10921290167},
    ["Toy"]={WalkAnim=10921312010,RunAnim=10921306285,JumpAnim=10921308158,FallAnim=10921307341,SwimIdle=10921310341,Swim=10921309319,ClimbAnim=10921300839,Animation1=10921301576},
    ["No Boundaries"]={WalkAnim=18747074203,RunAnim=18747070484,JumpAnim=18747069148,FallAnim=18747062535,SwimIdle=18747071682,Swim=18747073181,ClimbAnim=18747060903,Animation1=18747067405,Animation2=18747063918},
    ["NFL"]={WalkAnim=110358958299415,RunAnim=117333533048078,JumpAnim=119846112151352,FallAnim=129773241321032,SwimIdle=79090109939093,Swim=132697394189921,ClimbAnim=134630013742019,Animation1=92080889861410,Animation2=74451233229259},
    ["Amazon Unboxed"]={WalkAnim=90478085024465,RunAnim=134824450619865,JumpAnim=121454505477205,FallAnim=94788218468396,SwimIdle=129126268464847,Swim=105962919001086,ClimbAnim=121145883950231,Animation1=98281136301627},
    ["Vampire"]={WalkAnim=10921326949,RunAnim=10921320299,JumpAnim=10921322186,FallAnim=10921321317,SwimIdle=10921325443,Swim=10921324408,ClimbAnim=10921314188,Animation1=10921315373},
    ["Ninja"]={Run=656118852,Walk=656121766,Jump=656117878,Fall=656115606,Swim=656119721,SwimIdle=656121397,Climb=656114359,Idle={656117400,656118341,886742569}},
    ["Robot"]={Run=616091570,Walk=616095330,Jump=616090535,Fall=616087089,Swim=616092998,SwimIdle=616094091,Climb=616086039,Idle={616088211,616089559,885531463}},
    ["Levitation"]={Run=616010382,Walk=616013216,Jump=616008936,Fall=616005863,Swim=616011509,SwimIdle=616012453,Climb=616003713,Idle={616006778,616008087,886862142}},
    ["Stylish"]={Run=616140816,Walk=616146177,Jump=616139451,Fall=616134815,Swim=616143378,SwimIdle=616144772,Climb=616133594,Idle={616136790,616138447,886888594}},
    ["Bubbly"]={Run=910025107,Walk=910034870,Jump=910016857,Fall=910001910,Swim=910028158,SwimIdle=910030921,Climb=909997997,Idle={910004836,910009958,1018536639}},
    ["Cartoon"]={Run=742638842,Walk=742640026,Jump=742637942,Fall=742637151,Swim=742639220,SwimIdle=742639812,Climb=742636889,Idle={742637544,742638445,885477856}},
}
local _animPackNames = {}
for name in pairs(ANIMATION_PACKS) do table.insert(_animPackNames, name) end
table.sort(_animPackNames)

math.randomseed(math.floor(tick() * 1e7) % (2^31))
local _INSTANCE_TOKEN = string.format("%08x-%08x-%08x",
    math.floor(tick() * 1e4) % 0x100000000,
    math.floor(os.clock() * 1e6) % 0x100000000,
    math.random(0, 0x7FFFFFFF))
local _instDead = false
if _G._SNIPER_DUELS_KILL and typeof(_G._SNIPER_DUELS_KILL) == "Instance" then
    pcall(function() _G._SNIPER_DUELS_KILL:Fire() end)
    task.defer(function() pcall(function() _G._SNIPER_DUELS_KILL:Destroy() end) end)
end
_G._SNIPER_DUELS_TOKEN = _INSTANCE_TOKEN
local function isAlive() return not _instDead and _G._SNIPER_DUELS_TOKEN == _INSTANCE_TOKEN end

local _rawConns = {}
local function rawConn(signal, fn)
    local conn
    conn = signal:Connect(function(...)
        if not isAlive() then pcall(function() conn:Disconnect() end); return end
        fn(...)
    end)
    table.insert(_rawConns, conn)
    return conn
end

print("[SniperDuels] Loading step 2 - wait game")
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game:IsLoaded()
print("[SniperDuels] Loading step 3 - services")

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local PGui = LP:WaitForChild("PlayerGui")

local function _cleanOldGuis()
    local EXACT = {
        ["SNIPER DUELS"]=true, SniperDuels=true, SniperDuels_HUD=true,
        SniperHub=true, sniperUI=true, AutoStealBar=true, sniper=true,
        AdaptStealBarHUD=true, SniperDuels_AdaptBar=true, SniperDuels_QB=true,
        TPBat_Button=true, SniperDuels_Toast=true,
        AntiDieUI=true, VioletteTPBat=true, AntiDieBillboard=true,
        SniperDuels_AntiDieBillboard=true,
    }
    for _, container in ipairs({PGui, game:GetService("CoreGui")}) do
        for _, child in ipairs(container:GetChildren()) do
            local n = child.Name
            if EXACT[n] or n:sub(1, 6):lower() == "sniper" or n:sub(1,5):lower() == "adapt" or n:sub(1,5):lower() == "tpbat" or n:sub(1,6):lower() == "antidi" then
                pcall(function() child:Destroy() end)
            end
        end
    end
end
_cleanOldGuis()
print("[SniperDuels] Loading step 4 - helpers")

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local _AK = {MENU_MIN_W=280,MENU_MAX_W=600,MENU_MIN_H=320,MENU_MAX_H=700}

local function tween(obj, props, t, style, dir)
    TS:Create(obj, TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end
local function addCorner(parent, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 10); c.Parent = parent; return c
end
local function addStroke(parent, col, thick, trans)
    local s = Instance.new("UIStroke")
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = col or THEME.PinkDark
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    s.Parent = parent
    return s
end

-- ===== CONFIG =====
local CONFIG_FILE = "SniperDuels.json"
local XOR_KEY = {0x53, 0x6E, 0x69, 0x70, 0x65, 0x72, 0x44, 0x75}

local function _toBytes(str)
    local t = {}
    for i = 1, #str do t[i] = string.byte(str, i) end
    return t
end
local function _bytesToString(bytes)
    local chunks = {}
    for i = 1, #bytes, 2000 do
        local slice = {}
        for j = i, math.min(i + 1999, #bytes) do slice[#slice + 1] = bytes[j] end
        table.insert(chunks, string.char(table.unpack(slice)))
    end
    return table.concat(chunks)
end
local function _compress(bytes)
    local n = #bytes
    local out = {}
    if n < 15 then
        table.insert(out, n * 16)
    else
        table.insert(out, 0xF0)
        local rem = n - 15
        while rem >= 255 do table.insert(out, 255); rem = rem - 255 end
        table.insert(out, rem)
    end
    for i = 1, n do table.insert(out, bytes[i]) end
    return out
end
local function _decompress(bytes)
    local out = {}
    local i, n = 1, #bytes
    while i <= n do
        local ctrl = bytes[i]; i = i + 1
        local count = math.floor(ctrl / 16)
        if count == 15 then
            local b = bytes[i]; i = i + 1; count = count + b
            while b == 255 do b = bytes[i]; i = i + 1; count = count + b end
        end
        if count > 0 then
            for _ = 1, count do
                if i > n then break end
                table.insert(out, bytes[i]); i = i + 1
            end
        end
        if i > n then break end
        if i + 1 > n then break end
        local off = bytes[i] + bytes[i+1] * 256
        i = i + 2
        local copy_count = (ctrl % 16) + 4
        if copy_count == 19 then
            local b = bytes[i]; i = i + 1; copy_count = copy_count + b
            while b == 255 do b = bytes[i]; i = i + 1; copy_count = copy_count + b end
        end
        local base = #out - off + 1
        for j = 0, copy_count - 1 do table.insert(out, out[base + j]) end
    end
    return out
end
local function _xorBytes(bytes, key)
    local out = {}
    local klen = #key
    for i = 1, #bytes do out[i] = bit32.bxor(bytes[i], key[((i - 1) % klen) + 1]) end
    return out
end
local function _toHex(bytes)
    local out = {}
    for i = 1, #bytes do out[i] = string.format("%02X", bytes[i]) end
    return table.concat(out)
end
local function _fromHex(str)
    local out = {}
    str = str:gsub("%s+", ""):gsub("[^0-9A-Fa-f]", "")
    for i = 1, #str, 2 do
        local byte = tonumber(str:sub(i, i+1), 16)
        if byte then table.insert(out, byte) end
    end
    return out
end
local function _sanitizeState(state)
    local clean = {}
    for k, v in pairs(state) do
        local tv = type(v)
        if tv == "string" or tv == "number" or tv == "boolean" then clean[k] = v
        elseif tv == "table" then
            local sub, ok = {}, true
            for sk, sv in pairs(v) do
                local stv = type(sv)
                if stv == "string" or stv == "number" or stv == "boolean" then sub[sk] = sv
                else ok = false end
            end
            if ok then clean[k] = sub end
        end
    end
    return clean
end
local function _writeRaw(content)
    if type(writefile) == "function" then
        local ok = pcall(writefile, CONFIG_FILE, content)
        if ok then return true end
    end
    if syn and syn.write_file then
        local ok = pcall(syn.write_file, CONFIG_FILE, content)
        if ok then return true end
    end
    if fluxus and fluxus.writefile then
        local ok = pcall(fluxus.writefile, CONFIG_FILE, content)
        if ok then return true end
    end
    return false
end
local function saveConfigNow(state)
    local clean = _sanitizeState(state or {})
    local okEnc, json = pcall(function() return HS:JSONEncode(clean) end)
    if not okEnc or not json then return false, "encode failed" end
    local hexOk, hexRes = pcall(function()
        local jb = _toBytes(json)
        local comp = _compress(jb)
        local enc = _xorBytes(comp, XOR_KEY)
        local payload = {}
        local size = #jb
        payload[1] = size % 256
        payload[2] = math.floor(size / 256) % 256
        payload[3] = math.floor(size / 65536) % 256
        payload[4] = math.floor(size / 16777216) % 256
        payload[5] = #XOR_KEY
        for i = 1, #XOR_KEY do payload[5 + i] = XOR_KEY[i] end
        for i = 1, #enc do payload[5 + #XOR_KEY + i] = enc[i] end
        return _writeRaw(_toHex(payload))
    end)
    if hexOk and hexRes then return true, "hex" end
    if _writeRaw(json) then return true, "json" end
    return false, "no writefile available"
end
local function loadConfig()
    if not (isfile and readfile) then return {} end
    local okE, ex = pcall(isfile, CONFIG_FILE)
    if not okE or not ex then return {} end
    local ok, raw = pcall(readfile, CONFIG_FILE)
    if not ok or not raw or raw == "" then return {} end
    local trimmed = raw:gsub("^%s+", ""):gsub("%s+$", "")
    if trimmed:sub(1, 1) == "{" then
        local ok2, data = pcall(function() return HS:JSONDecode(trimmed) end)
        if ok2 and type(data) == "table" then return data end
    end
    local ok3, result = pcall(function()
        local payload = _fromHex(raw)
        if #payload < 5 then error("short") end
        local keylen = payload[5]
        if #payload < 5 + keylen then error("keylen") end
        local key = {}
        for i = 1, keylen do key[i] = payload[5 + i] end
        local enc = {}
        for i = 6 + keylen, #payload do table.insert(enc, payload[i]) end
        local comp = _xorBytes(enc, key)
        local dec = _decompress(comp)
        return HS:JSONDecode(_bytesToString(dec))
    end)
    if ok3 and type(result) == "table" then return result end
    return {}
end
local _configState = loadConfig()
local _configSaveTimer = nil
local function _autoSaveConfig()
    if _configSaveTimer then task.cancel(_configSaveTimer) end
    _configSaveTimer = task.delay(0.5, function()
        local ok, err = saveConfigNow(_configState)
        if not ok then warn("[SniperDuels] Auto-save failed: " .. tostring(err)) end
    end)
end

-- ===== TOAST =====
local _toastSG
local function showToast(text, isSuccess)
    if not _toastSG or not _toastSG.Parent then
        _toastSG = Instance.new("ScreenGui")
        _toastSG.Name = "SniperDuels_Toast"
        _toastSG.ResetOnSpawn = false
        _toastSG.IgnoreGuiInset = true
        _toastSG.DisplayOrder = 500
        local ok = pcall(function() _toastSG.Parent = CoreGui end)
        if not ok or not _toastSG.Parent then _toastSG.Parent = PGui end
    end
    local sg = _toastSG
    if not sg then return end
    local old = sg:FindFirstChild("Toast")
    if old then old:Destroy() end
    local color = isSuccess and THEME.Pink or Color3.fromRGB(255, 90, 90)
    local toast = Instance.new("Frame", sg)
    toast.Name = "Toast"
    toast.AnchorPoint = Vector2.new(0.5, 0)
    toast.Position = UDim2.new(0.5, 0, 0, 40)
    toast.Size = UDim2.new(0, 280, 0, 48)
    toast.BackgroundColor3 = THEME.Black
    toast.BackgroundTransparency = 1
    toast.BorderSizePixel = 0
    toast.ZIndex = 10
    addCorner(toast, 12)
    local stroke = Instance.new("UIStroke", toast)
    stroke.Color = color; stroke.Thickness = 2; stroke.Transparency = 1
    local dot = Instance.new("Frame", toast)
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, 14, 0.5, -4)
    dot.BackgroundColor3 = color; dot.BackgroundTransparency = 1; dot.BorderSizePixel = 0; dot.ZIndex = 11
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local lbl = Instance.new("TextLabel", toast)
    lbl.Size = UDim2.new(1, -40, 1, 0); lbl.Position = UDim2.new(0, 30, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = color
    lbl.TextTransparency = 1; lbl.TextSize = 13; lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 11
    local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TS:Create(toast, ti, { BackgroundTransparency = 0.05 }):Play()
    TS:Create(stroke, ti, { Transparency = 0.2 }):Play()
    TS:Create(dot, ti, { BackgroundTransparency = 0 }):Play()
    TS:Create(lbl, ti, { TextTransparency = 0 }):Play()
    task.delay(1.8, function()
        local to = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TS:Create(toast, to, { BackgroundTransparency = 1 }):Play()
        TS:Create(stroke, to, { Transparency = 1 }):Play()
        TS:Create(dot, to, { BackgroundTransparency = 1 }):Play()
        TS:Create(lbl, to, { TextTransparency = 1 }):Play()
        task.delay(0.4, function() pcall(function() toast:Destroy() end) end)
    end)
end
_AK.showToast = showToast

local DragLocked = false
local mobileButtonsLocked = false

print("[SniperDuels] Loading step 5 - feature globals")

-- ===== FEATURE GLOBALS =====
local _toggleRegistry = {}
local NS, CS = 60, 30
local LAGGER_SPEED, LAGGER_CARRY_SPEED = 45, 20
local speedMode = false
local laggerToggled = false
local laggerPhase = 0
local lastMoveDir = Vector3.new(0,0,0)
local autoTPEnabled = false; local autoTPHeight = 20; local autoTPConn = nil
local autoLeftEnabled, autoRightEnabled = false, false
local alConn, arConn = nil, nil; local alPhase, arPhase = 1, 1
local _alBypassPart, _alBypassWeld = nil, nil
local dropActive = false
local dropMode = "v1"
local infJumpEnabled = false; local infJumpMode = "manual"
local antiRagdollEnabled = false
local autoBatEnabled = false
local autoBatEquippedThisRun = false; local _autoBatTarget = nil; local _autoBatLastScan = 0
local AUTO_BAT = {SPEED=58,SPEED_NORMAL=60}
local batCounterEnabled = false
local unwalkEnabled = false; local unwalkSavedAnimate = nil
local BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local _abBypassPart, _abBypassWeld = nil, nil
local _Flags = { batCounterDebounce=false, holdJumpActive=false, vampireAnimEnabled=false }
local tpBatEnabled = false
local tpBatHittingCooldown = false
local _tpBat_h, _tpBat_hrp = nil, nil
local _TP_RANGE, _TP_LEAD = 3.5, 0.08
local selectedAnimPack = nil
local _animOrig = {}

local antiDieEnabled = false
local _antiDieConn, _antiDieHeart, _antiDieCharAdded = nil, nil, nil

-- Steal
local Steal = {AutoStealEnabled=false,StealRadius=60,StealDuration=1.3,Mode=4,Data={}}
local isStealing = false
local stealStartTime = nil
local Conns = { autoSteal = nil, antiRag = nil, batCounter = nil }
local progressFill, progressPct, progressStatusLbl

local startAutoSteal, stopAutoSteal

print("[SniperDuels] Loading step 6 - main menu")

local Container
local ShowBtn, _showBtnDragged
local pages = {}
local tabButtons = {}

do
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SNIPER DUELS"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = PGui

    ShowBtn = Instance.new("TextButton")
    ShowBtn.Size = UDim2.new(0, 130, 0, 36)
    ShowBtn.Position = UDim2.new(0, 10, 0, 10)
    ShowBtn.BackgroundColor3 = THEME.Black
    ShowBtn.BackgroundTransparency = 0.2
    ShowBtn.BorderSizePixel = 0
    ShowBtn.Text = "SNIPER DUELS"
    ShowBtn.TextColor3 = THEME.Pink
    ShowBtn.TextSize = 12
    ShowBtn.Font = Enum.Font.GothamBold
    ShowBtn.Visible = false
    ShowBtn.ZIndex = 20
    ShowBtn.Parent = ScreenGui
    addCorner(ShowBtn, 6)
    addStroke(ShowBtn, THEME.PinkDark, 1)

    Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(0, 380, 0, 440)
    Container.Position = UDim2.new(0, 20, 0.5, -220)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.Active = true
    Container.ZIndex = 2
    Container.Parent = ScreenGui

    -- ===== VIEWPORT CLAMP =====
    -- Keeps the entire GUI fully visible on any screen size / orientation.
    local GUI_MARGIN = 8
    local function _clampGuiToViewport()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        if vp.X <= 0 or vp.Y <= 0 then return end

        local maxW = math.max(240, vp.X - GUI_MARGIN * 2)
        local maxH = math.max(280, vp.Y - GUI_MARGIN * 2)
        local newW = math.clamp(Container.Size.X.Offset, _AK.MENU_MIN_W, math.min(_AK.MENU_MAX_W, maxW))
        local newH = math.clamp(Container.Size.Y.Offset, _AK.MENU_MIN_H, math.min(_AK.MENU_MAX_H, maxH))
        if newW ~= Container.Size.X.Offset or newH ~= Container.Size.Y.Offset then
            Container.Size = UDim2.new(0, newW, 0, newH)
        end

        local posX = Container.Position.X.Scale * vp.X + Container.Position.X.Offset
        local posY = Container.Position.Y.Scale * vp.Y + Container.Position.Y.Offset
        local minX, minY = GUI_MARGIN, GUI_MARGIN
        local maxX = math.max(minX, vp.X - newW - GUI_MARGIN)
        local maxY = math.max(minY, vp.Y - newH - GUI_MARGIN)
        local clampedX = math.clamp(posX, minX, maxX)
        local clampedY = math.clamp(posY, minY, maxY)
        if clampedX ~= posX or clampedY ~= posY then
            Container.Position = UDim2.new(0, clampedX, 0, clampedY)
        end
    end
    _AK.clampGui = _clampGuiToViewport

    _clampGuiToViewport()
    pcall(function()
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(_clampGuiToViewport)
    end)

    local Panel = Instance.new("Frame")
    Panel.Size = UDim2.new(1, 0, 1, 0)
    Panel.BackgroundColor3 = THEME.Black
    Panel.BorderSizePixel = 0
    Panel.ClipsDescendants = true
    Panel.ZIndex = 2
    Panel.Parent = Container
    addCorner(Panel, 22)
    addStroke(Panel, THEME.PinkDark, 2, 0)

    local bgOverlay = Instance.new("Frame", Panel)
    bgOverlay.Size = UDim2.new(1,0,1,0)
    bgOverlay.BackgroundColor3 = THEME.Black
    bgOverlay.BorderSizePixel = 0
    bgOverlay.ZIndex = 1
    addCorner(bgOverlay, 22)

    local bgGrad = Instance.new("UIGradient", bgOverlay)
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 5, 20)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 5, 12)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 0, 15)),
    })
    bgGrad.Rotation = 135

    local BgImage = Instance.new("ImageLabel", Panel)
    BgImage.Size = UDim2.new(1, 0, 1, 0)
    BgImage.BackgroundTransparency = 1
    BgImage.Image = "rbxassetid://137692455767789"
    BgImage.ImageTransparency = 0.55
    BgImage.ScaleType = Enum.ScaleType.Crop
    BgImage.ZIndex = 2
    BgImage.BorderSizePixel = 0
    addCorner(BgImage, 22)

    local HeaderFrame = Instance.new("Frame", Panel)
    HeaderFrame.Size = UDim2.new(1,0,0,96)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Active = true
    HeaderFrame.ZIndex = 5

    do
        local dragging, dragStart, startPos
        HeaderFrame.InputBegan:Connect(function(input)
            if DragLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = Container.Position
            end
        end)
        rawConn(UIS.InputChanged, function(input)
            if not dragging then return end
            if DragLocked then dragging = false; return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = input.Position - dragStart
            Container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end)
        rawConn(UIS.InputEnded, function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not dragging then return end
            dragging = false
            if _AK.clampGui then _AK.clampGui() end
            _configState["menuXScale"] = Container.Position.X.Scale
            _configState["menuXOffset"] = Container.Position.X.Offset
            _configState["menuYScale"] = Container.Position.Y.Scale
            _configState["menuYOffset"] = Container.Position.Y.Offset
            _autoSaveConfig()
        end)
    end

    local TitleMain = Instance.new("TextLabel", HeaderFrame)
    TitleMain.Position = UDim2.new(0, 18, 0, 8)
    TitleMain.Size = UDim2.new(1, -36, 0, 48)
    TitleMain.BackgroundTransparency = 1
    TitleMain.Text = "SNIPER"
    TitleMain.TextColor3 = THEME.Pink
    TitleMain.TextSize = 54
    TitleMain.Font = Enum.Font.GothamBlack
    TitleMain.TextXAlignment = Enum.TextXAlignment.Left
    TitleMain.TextYAlignment = Enum.TextYAlignment.Center
    TitleMain.ZIndex = 6

    local DiscordLink = Instance.new("TextLabel", HeaderFrame)
    DiscordLink.Position = UDim2.new(0, 18, 0, 56)
    DiscordLink.Size = UDim2.new(1, -36, 0, 16)
    DiscordLink.BackgroundTransparency = 1
    DiscordLink.Text = "discord.gg/sniperduels"
    DiscordLink.TextColor3 = THEME.PinkGlow
    DiscordLink.TextSize = 11
    DiscordLink.Font = Enum.Font.GothamBold
    DiscordLink.TextXAlignment = Enum.TextXAlignment.Left
    DiscordLink.ZIndex = 6

    local DividerLine = Instance.new("Frame", HeaderFrame)
    DividerLine.Size = UDim2.new(1,-24,0,1)
    DividerLine.Position = UDim2.new(0,12,0,92)
    DividerLine.BackgroundColor3 = THEME.Pink
    DividerLine.BackgroundTransparency = 0.3
    DividerLine.BorderSizePixel = 0
    DividerLine.ZIndex = 7

    local MinimizeBtn = Instance.new("TextButton", HeaderFrame)
    MinimizeBtn.Size = UDim2.new(0,26,0,26)
    MinimizeBtn.Position = UDim2.new(1,-34,0,10)
    MinimizeBtn.BackgroundColor3 = THEME.BlackSoft
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = THEME.PinkGlow
    MinimizeBtn.TextSize = 16
    MinimizeBtn.Font = Enum.Font.GothamBlack
    MinimizeBtn.ZIndex = 9
    addCorner(MinimizeBtn, 6)
    addStroke(MinimizeBtn, THEME.PinkDark, 1)
    MinimizeBtn.MouseButton1Click:Connect(function()
        Container.Visible = false
        ShowBtn.Visible = true
    end)
    ShowBtn.MouseButton1Click:Connect(function()
        if _showBtnDragged then _showBtnDragged = false; return end
        Container.Visible = true
        ShowBtn.Visible = false
        if _AK.clampGui then _AK.clampGui() end
    end)

    local TabBar = Instance.new("Frame", Panel)
    TabBar.Size = UDim2.new(1, 0, 0, 30)
    TabBar.Position = UDim2.new(0, 0, 0, 98)
    TabBar.BackgroundTransparency = 1
    TabBar.ZIndex = 8

    local TabList = Instance.new("UIListLayout", TabBar)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 2)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.VerticalAlignment = Enum.VerticalAlignment.Center
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    local PagesHolder = Instance.new("Frame", Panel)
    PagesHolder.Size = UDim2.new(1, 0, 1, -132)
    PagesHolder.Position = UDim2.new(0, 0, 0, 132)
    PagesHolder.BackgroundTransparency = 1
    PagesHolder.ZIndex = 10

    local function createPage(name)
        local page = Instance.new("ScrollingFrame", PagesHolder)
        page.Name = name .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = THEME.Pink
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false
        page.ZIndex = 10
        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 4)
        local pad = Instance.new("UIPadding", page)
        pad.PaddingLeft = UDim.new(0, 10); pad.PaddingRight = UDim.new(0, 10)
        pad.PaddingTop = UDim.new(0, 8); pad.PaddingBottom = UDim.new(0, 8)
        pages[name] = page
        return page
    end

    local function setActive(name)
        if not pages[name] then return end
        for n, p in pairs(pages) do p.Visible = (n == name) end
        for n, btn in pairs(tabButtons) do
            if n == name then
                btn.BackgroundColor3 = THEME.Pink; btn.TextColor3 = Color3.new(0,0,0)
            else
                btn.BackgroundColor3 = THEME.BlackSoft; btn.TextColor3 = THEME.PinkGlow
            end
        end
        _configState["activeTab"] = name
        _autoSaveConfig()
    end
    _AK.setActiveTab = setActive

    local function createTabButton(name, order)
        local btn = Instance.new("TextButton", TabBar)
        btn.Size = UDim2.new(0, 48, 0, 24)
        btn.BackgroundColor3 = THEME.BlackSoft
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = THEME.PinkGlow
        btn.TextSize = 9
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.LayoutOrder = order
        btn.ZIndex = 9
        addCorner(btn, 6)
        addStroke(btn, THEME.PinkDark, 1)
        btn.MouseButton1Click:Connect(function() setActive(name) end)
        tabButtons[name] = btn
    end

    createTabButton("SPEED", 1); createTabButton("MECH", 2); createTabButton("ANIM", 3)
    createTabButton("UTILS", 4); createTabButton("MENU", 5); createTabButton("CONFIG", 6); createTabButton("KEYS", 7)
    createPage("SPEED"); createPage("MECH"); createPage("ANIM"); createPage("UTILS"); createPage("MENU"); createPage("CONFIG"); createPage("KEYS")

    local savedTab = _configState["activeTab"] or "SPEED"
    if not pages[savedTab] then savedTab = "SPEED" end
    setActive(savedTab)
end

local ROW_ALPHA = 0.92

local function hoverRow(row, baseAlpha)
    local hit = Instance.new("TextButton", row)
    hit.Size = UDim2.new(1,0,1,0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.ZIndex = 0
    hit.MouseEnter:Connect(function() tween(row, { BackgroundTransparency = baseAlpha - 0.06 }) end)
    hit.MouseLeave:Connect(function() tween(row, { BackgroundTransparency = baseAlpha }) end)
    return hit
end

local function sectionLabel(parent, text, order)
    local wrap = Instance.new("Frame", parent)
    wrap.Size = UDim2.new(1,0,0,26)
    wrap.BackgroundTransparency = 1
    wrap.LayoutOrder = order
    local lbl = Instance.new("TextLabel", wrap)
    lbl.Size = UDim2.new(1,0,0,16)
    lbl.Position = UDim2.new(0,4,0,2)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = THEME.PinkGlow
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 4
    local underline = Instance.new("Frame", wrap)
    underline.Size = UDim2.new(0, math.min(#text * 5.5, 220), 0, 1)
    underline.Position = UDim2.new(0,4,0,22)
    underline.BackgroundColor3 = THEME.Pink
    underline.BorderSizePixel = 0
    addCorner(underline, 1)
end

local function toggleRow(parent, labelText, startOn, order, onToggle)
    local Row = Instance.new("Frame", parent)
    Row.Size = UDim2.new(1,0,0,38)
    Row.BackgroundColor3 = THEME.Pink
    Row.BackgroundTransparency = ROW_ALPHA
    Row.BorderSizePixel = 0
    Row.LayoutOrder = order
    addCorner(Row, 10)
    local _rowStroke = addStroke(Row, startOn and THEME.Pink or THEME.Grey, startOn and 1.5 or 1)
    local rowLabel = Instance.new("TextLabel", Row)
    rowLabel.Size = UDim2.new(0.65,0,0,16); rowLabel.Position = UDim2.new(0,12,0,7)
    rowLabel.BackgroundTransparency = 1; rowLabel.Text = labelText
    rowLabel.TextColor3 = Color3.fromRGB(255,255,255); rowLabel.TextSize = 11
    rowLabel.Font = Enum.Font.GothamBold; rowLabel.TextXAlignment = Enum.TextXAlignment.Left; rowLabel.ZIndex = 5
    local Track = Instance.new("Frame", Row)
    Track.Size = UDim2.new(0,36,0,18); Track.Position = UDim2.new(1,-46,0.5,-9)
    Track.BackgroundColor3 = startOn and THEME.Pink or THEME.Grey
    Track.BackgroundTransparency = startOn and 0 or 0.4; Track.BorderSizePixel = 0; Track.ZIndex = 5
    addCorner(Track, 9)
    local Knob = Instance.new("Frame", Track)
    Knob.Size = UDim2.new(0,14,0,14)
    Knob.Position = startOn and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)
    Knob.BackgroundColor3 = startOn and THEME.Black or Color3.fromRGB(200,200,200)
    Knob.BackgroundTransparency = startOn and 0 or 0.4; Knob.BorderSizePixel = 0; Knob.ZIndex = 6
    addCorner(Knob, 7)
    local state = startOn
    local function setState(on)
        state = on
        tween(Track, { BackgroundColor3 = on and THEME.Pink or THEME.Grey, BackgroundTransparency = on and 0 or 0.4 })
        tween(Knob, { Position = on and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7), BackgroundColor3 = on and THEME.Black or Color3.fromRGB(200,200,200), BackgroundTransparency = on and 0 or 0.4 })
        tween(_rowStroke, { Color = on and THEME.Pink or THEME.Grey, Thickness = on and 1.5 or 1 })
        if onToggle then onToggle(on) end
    end
    local tapBtn = Instance.new("TextButton", Row)
    tapBtn.Size = UDim2.new(0,36,0,18); tapBtn.Position = UDim2.new(1,-46,0.5,-9)
    tapBtn.BackgroundTransparency = 1; tapBtn.Text = ""; tapBtn.ZIndex = 7
    tapBtn.MouseButton1Click:Connect(function() setState(not state) end)
    hoverRow(Row, ROW_ALPHA)
    return Row, setState
end

local function _regToggle(parent, label, startOn, order, key, onToggle)
    local row, setState = toggleRow(parent, label, startOn, order, function(on)
        _configState[key] = on
        if onToggle then onToggle(on) end
        _autoSaveConfig()
    end)
    table.insert(_toggleRegistry, { setState = setState, key = key, callback = onToggle })
    return row, setState
end

local function inputRow(parent, labelText, startVal, order, onChange)
    local Row = Instance.new("Frame", parent)
    Row.Size = UDim2.new(1,0,0,38)
    Row.BackgroundColor3 = THEME.Pink
    Row.BackgroundTransparency = ROW_ALPHA
    Row.BorderSizePixel = 0
    Row.LayoutOrder = order
    addCorner(Row, 10)
    addStroke(Row, THEME.PinkDark, 1)
    local rowLabel = Instance.new("TextLabel", Row)
    rowLabel.Size = UDim2.new(0.6,0,0,16); rowLabel.Position = UDim2.new(0,12,0,7)
    rowLabel.BackgroundTransparency = 1; rowLabel.Text = labelText
    rowLabel.TextColor3 = Color3.fromRGB(255,255,255); rowLabel.TextSize = 11
    rowLabel.Font = Enum.Font.GothamBold; rowLabel.TextXAlignment = Enum.TextXAlignment.Left; rowLabel.ZIndex = 5
    local boxBg = Instance.new("Frame", Row)
    boxBg.Size = UDim2.new(0,56,0,22); boxBg.Position = UDim2.new(1,-64,0.5,-11)
    boxBg.BackgroundColor3 = THEME.BlackSoft; boxBg.BorderSizePixel = 0; boxBg.ZIndex = 6
    addCorner(boxBg, 6); addStroke(boxBg, THEME.PinkDark, 1)
    local box = Instance.new("TextBox", boxBg)
    box.Size = UDim2.new(1,0,1,0); box.BackgroundTransparency = 1
    box.Text = tostring(startVal); box.TextColor3 = THEME.PinkGlow
    box.TextSize = 11; box.Font = Enum.Font.GothamBold; box.ClearTextOnFocus = false; box.ZIndex = 7
    local lastGood = startVal
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n and n > 0 then lastGood = n; if onChange then onChange(n) end
        else box.Text = tostring(lastGood) end
    end)
    hoverRow(Row, ROW_ALPHA)
    local function setValue(n) box.Text = tostring(n); lastGood = n end
    return Row, box, setValue
end

local function actionRow(parent, labelText, order, onAction)
    local Row = Instance.new("Frame", parent)
    Row.Size = UDim2.new(1,0,0,38)
    Row.BackgroundColor3 = THEME.Pink
    Row.BackgroundTransparency = ROW_ALPHA
    Row.BorderSizePixel = 0
    Row.LayoutOrder = order
    addCorner(Row, 10)
    addStroke(Row, THEME.PinkDark, 1)
    local rowLabel = Instance.new("TextLabel", Row)
    rowLabel.Size = UDim2.new(0.75,0,0,16); rowLabel.Position = UDim2.new(0,12,0,7)
    rowLabel.BackgroundTransparency = 1; rowLabel.Text = labelText
    rowLabel.TextColor3 = Color3.fromRGB(255,255,255); rowLabel.TextSize = 11
    rowLabel.Font = Enum.Font.GothamBold; rowLabel.TextXAlignment = Enum.TextXAlignment.Left; rowLabel.ZIndex = 5
    local chevron = Instance.new("TextLabel", Row)
    chevron.Size = UDim2.new(0,14,0,16); chevron.Position = UDim2.new(1,-22,0.5,-8)
    chevron.BackgroundTransparency = 1; chevron.Text = ">"
    chevron.TextColor3 = THEME.PinkGlow; chevron.TextSize = 16
    chevron.Font = Enum.Font.GothamBold; chevron.ZIndex = 5
    local hit = hoverRow(Row, ROW_ALPHA)
    hit.ZIndex = 6
    if onAction then hit.MouseButton1Click:Connect(onAction) end
    return Row
end

-- ===== HELPERS =====
local MOVE_KEYS = {
    [Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true,
}
local function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand == true or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end
local function getActiveMoveSpeed()
    local laggerOn = laggerToggled == true
    if speedMode and not laggerOn then return tonumber(CS) or 30 end
    if laggerOn then
        if laggerPhase == 2 then return tonumber(LAGGER_CARRY_SPEED) or 20 end
        return tonumber(LAGGER_SPEED) or 45
    end
    return tonumber(NS) or 60
end
local function getAutoPathSpeed()
    if laggerToggled then return LAGGER_SPEED end
    return NS
end

-- ===== SPEED ENGINE =====
local _linVel, _linVelAtt0, _linVelAtt1, _linVelChar = nil, nil, nil, nil
local spoofedVelocity = Vector3.zero
local function destroyLinVel()
    if _linVel then pcall(function() _linVel:Destroy() end) end
    if _linVelAtt0 then pcall(function() _linVelAtt0:Destroy() end) end
    if _linVelAtt1 then pcall(function() _linVelAtt1:Destroy() end) end
    _linVel, _linVelAtt0, _linVelAtt1, _linVelChar = nil, nil, nil, nil
end
local function setupLinearVelocity(char)
    destroyLinVel()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        local ok, res = pcall(function() return char:WaitForChild("HumanoidRootPart", 5) end)
        if ok then hrp = res end
    end
    if not hrp then return end
    local att0 = Instance.new("Attachment"); att0.Name = "OrvynLinVelAtt0"; att0.Parent = hrp
    local att1 = Instance.new("Attachment"); att1.Name = "OrvynLinVelAtt1"; att1.Parent = hrp
    local lv = Instance.new("LinearVelocity")
    lv.Name = "OrvynLinVel"; lv.Attachment0 = att0; lv.Attachment1 = att1
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis = Vector3.new(1, 0, 0); lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
    lv.RelativeTo = Enum.ActuatorRelativeTo.World; lv.MaxForce = 1e6
    lv.PlaneVelocity = Vector2.new(0, 0); lv.Enabled = true; lv.Parent = hrp
    _linVel, _linVelAtt0, _linVelAtt1, _linVelChar = lv, att0, att1, char
end
local function setLinVelXZ(x, z)
    if _linVel and _linVel.Parent then pcall(function() _linVel.PlaneVelocity = Vector2.new(x, z) end) end
end
local function clearLinVel()
    if _linVel and _linVel.Parent then pcall(function() _linVel.PlaneVelocity = Vector2.new(0, 0) end) end
end
local function disableLinVel() if _linVel and _linVel.Parent and _linVel.Enabled then pcall(function() _linVel.Enabled = false end) end end
local function enableLinVel() if _linVel and _linVel.Parent and not _linVel.Enabled then pcall(function() _linVel.Enabled = true end) end end
local function ensureLinVel()
    local char = LP.Character
    if not char then return false end
    if _linVel and _linVel.Parent and _linVelChar == char then return true end
    setupLinearVelocity(char)
    return _linVel ~= nil and _linVel.Parent ~= nil
end

pcall(function()
    if not (getrawmetatable and setreadonly and newcclosure) then return end
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldIndex = mt.__index
    mt.__index = newcclosure(function(self, key)
        if key == "AssemblyLinearVelocity" or key == "Velocity" then
            if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart"
                and LP.Character and self:IsDescendantOf(LP.Character) then
                return spoofedVelocity
            end
        end
        return oldIndex(self, key)
    end)
    setreadonly(mt, true)
end)
RunService.Heartbeat:Connect(function() spoofedVelocity = Vector3.zero end)

rawConn(RunService.RenderStepped, function()
    local char = LP.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if isRagdollState(hum) then lastMoveDir = Vector3.zero; disableLinVel(); return end
    if autoBatEnabled or autoLeftEnabled or autoRightEnabled or tpBatEnabled then
        disableLinVel(); lastMoveDir = Vector3.zero; return
    end
    ensureLinVel(); enableLinVel()
    local md = hum.MoveDirection
    local spd = getActiveMoveSpeed()
    if md.Magnitude > 0 then
        lastMoveDir = md
        setLinVelXZ(md.X * spd, md.Z * spd)
    elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
        local anyHeld = false
        for key in pairs(MOVE_KEYS) do
            if UIS:IsKeyDown(key) then anyHeld = true; break end
        end
        if anyHeld then setLinVelXZ(lastMoveDir.X * spd, lastMoveDir.Z * spd)
        else clearLinVel() end
    else
        clearLinVel()
    end
end)

LP.CharacterAdded:Connect(function(char) task.wait(0.5); pcall(setupLinearVelocity, char) end)
task.defer(function() if LP.Character then task.wait(0.3); pcall(setupLinearVelocity, LP.Character) end end)

-- ===== ANTI DIE =====
local function _antiDieProtectChar(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 5); if not hum then return end
    pcall(function()
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end)
    if _antiDieConn then _antiDieConn:Disconnect() end
    _antiDieConn = hum.StateChanged:Connect(function(_, new)
        if not antiDieEnabled then return end
        if new == Enum.HumanoidStateType.Dead then
            pcall(function() hum.Health = math.huge; hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        end
    end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
    if _antiDieHeart then _antiDieHeart:Disconnect() end
    _antiDieHeart = RunService.Heartbeat:Connect(function()
        if not antiDieEnabled then return end
        if hum and hum.Parent and hum.Health < hum.MaxHealth then
            pcall(function() hum.Health = math.huge end)
        end
    end)
end
local function startAntiDie()
    if _antiDieConn then _antiDieConn:Disconnect(); _antiDieConn = nil end
    if _antiDieHeart then _antiDieHeart:Disconnect(); _antiDieHeart = nil end
    if _antiDieCharAdded then _antiDieCharAdded:Disconnect(); _antiDieCharAdded = nil end
    antiDieEnabled = true
    _antiDieProtectChar(LP.Character)
    _antiDieCharAdded = LP.CharacterAdded:Connect(function(c)
        if not antiDieEnabled then return end
        task.wait(0.1); _antiDieProtectChar(c)
    end)
end
local function stopAntiDie()
    antiDieEnabled = false
    if _antiDieConn then _antiDieConn:Disconnect(); _antiDieConn = nil end
    if _antiDieHeart then _antiDieHeart:Disconnect(); _antiDieHeart = nil end
    if _antiDieCharAdded then _antiDieCharAdded:Disconnect(); _antiDieCharAdded = nil end
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true); hum.MaxHealth = 100; hum.Health = 100 end) end
    end
end
_AK.startAntiDie = startAntiDie
_AK.stopAntiDie = stopAntiDie

-- ===== ANIMATION =====
local function _animSetId(anim, path, animId)
    local cur = anim
    for _, p in ipairs(path) do cur = cur:FindFirstChild(p); if not cur then return end end
    if cur:IsA("Animation") then cur.AnimationId = "rbxassetid://" .. tostring(animId) end
end
local function _animSaveOriginals(anim)
    if next(_animOrig) then return end
    local function get(p1, p2)
        local a = anim:FindFirstChild(p1); if not a then return nil end
        local b = a:FindFirstChild(p2 or "AnimationId")
        if b and b:IsA("Animation") then return b.AnimationId end
    end
    _animOrig = { walk=get("walk","WalkAnim"),run=get("run","RunAnim"),jump=get("jump","JumpAnim"),
        fall=get("fall","FallAnim"),climb=get("climb","ClimbAnim"),swim=get("swim","Swim"),
        swimidle=get("swimidle","SwimIdle"),idle1=get("idle","Animation1"),idle2=get("idle","Animation2") }
end
local function applyAnimPack(name)
    local char = LP.Character; if not char then return end
    local anim = char:FindFirstChild("Animate"); if not anim then return end
    local pack = ANIMATION_PACKS[name]; if not pack then return end
    _animSaveOriginals(anim)
    if pack.WalkAnim or pack.Walk then _animSetId(anim,{"walk","WalkAnim"},pack.WalkAnim or pack.Walk) end
    if pack.RunAnim or pack.Run then _animSetId(anim,{"run","RunAnim"},pack.RunAnim or pack.Run) end
    if pack.JumpAnim or pack.Jump then _animSetId(anim,{"jump","JumpAnim"},pack.JumpAnim or pack.Jump) end
    if pack.FallAnim or pack.Fall then _animSetId(anim,{"fall","FallAnim"},pack.FallAnim or pack.Fall) end
    if pack.ClimbAnim or pack.Climb then _animSetId(anim,{"climb","ClimbAnim"},pack.ClimbAnim or pack.Climb) end
    if pack.Swim then _animSetId(anim,{"swim","Swim"},pack.Swim) end
    if pack.SwimIdle then _animSetId(anim,{"swimidle","SwimIdle"},pack.SwimIdle) end
    if pack.Animation1 then _animSetId(anim,{"idle","Animation1"},pack.Animation1) end
    if pack.Animation2 then _animSetId(anim,{"idle","Animation2"},pack.Animation2) end
    if pack.Idle then
        if pack.Idle[1] then _animSetId(anim,{"idle","Animation1"},pack.Idle[1]) end
        if pack.Idle[2] then _animSetId(anim,{"idle","Animation2"},pack.Idle[2]) end
    end
    pcall(function()
        for _, t in ipairs(char:GetDescendants()) do
            if t:IsA("Animator") then
                for _, track in ipairs(t:GetPlayingAnimationTracks()) do
                    pcall(function() track:Stop(0) end)
                end
            end
        end
    end)
    selectedAnimPack = name
    _configState["animPack"] = name
    _autoSaveConfig()
end
local function clearAnimPack()
    local char = LP.Character; if not char then return end
    local anim = char:FindFirstChild("Animate"); if not anim then return end
    for k, v in pairs(_animOrig) do
        if v then
            local id = v:gsub("rbxassetid://","")
            if k=="walk" then _animSetId(anim,{"walk","WalkAnim"},id) end
            if k=="run" then _animSetId(anim,{"run","RunAnim"},id) end
            if k=="jump" then _animSetId(anim,{"jump","JumpAnim"},id) end
            if k=="fall" then _animSetId(anim,{"fall","FallAnim"},id) end
            if k=="climb" then _animSetId(anim,{"climb","ClimbAnim"},id) end
            if k=="swim" then _animSetId(anim,{"swim","Swim"},id) end
            if k=="swimidle" then _animSetId(anim,{"swimidle","SwimIdle"},id) end
            if k=="idle1" then _animSetId(anim,{"idle","Animation1"},id) end
            if k=="idle2" then _animSetId(anim,{"idle","Animation2"},id) end
        end
    end
    selectedAnimPack = nil
    _configState["animPack"] = nil
    _autoSaveConfig()
end

-- ===== TP BAT =====
local function _tpBatGetBat()
    local char = LP.Character; if not char then return nil end
    local tool = char:FindFirstChild("Bat"); if tool then return tool end
    local bp = LP:FindFirstChild("Backpack")
    if bp then tool = bp:FindFirstChild("Bat"); if tool then tool.Parent = char; return tool end end
    return nil
end
local function _tpBatTryHit()
    if tpBatHittingCooldown then return end
    tpBatHittingCooldown = true
    pcall(function()
        local bat = _tpBatGetBat()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer(); ev:FireServer() end
        end
    end)
    task.delay(0.06 + math.random() * 0.05, function() tpBatHittingCooldown = false end)
end
local function _tpBatGetClosest()
    if not _tpBat_hrp then return nil, math.huge end
    local cp, cd = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr and hum and hum.Health > 0 then
                local d = (_tpBat_hrp.Position - tr.Position).Magnitude
                if d < cd then cd = d; cp = p end
            end
        end
    end
    return cp, cd
end
local function _tpBatSetupChar(char)
    task.wait(0.1)
    _tpBat_h = char:WaitForChild("Humanoid", 5)
    _tpBat_hrp = char:WaitForChild("HumanoidRootPart", 5)
end
rawConn(RunService.Heartbeat, function()
    if not (tpBatEnabled and _tpBat_h and _tpBat_hrp) then return end
    local target = _tpBatGetClosest()
    if not (target and target.Character) then return end
    local tr = target.Character:FindFirstChild("HumanoidRootPart"); if not tr then return end
    local vel = tr.AssemblyLinearVelocity
    local future = tr.Position + Vector3.new(vel.X * _TP_LEAD, 0, vel.Z * _TP_LEAD)
    local aimPos = future + Vector3.new(0, 0.9, 0)
    if (_tpBat_hrp.Position - aimPos).Magnitude > _TP_RANGE then
        local lookDir = (tr.Position - aimPos)
        local facing = lookDir.Magnitude > 0.01 and CFrame.lookAt(aimPos, tr.Position) or CFrame.new(aimPos)
        _tpBat_hrp.CFrame = facing
    end
    pcall(function() if sethiddenproperty then sethiddenproperty(_tpBat_hrp, "PhysicsRepRootPart", tr) end end)
    local cam = workspace.CurrentCamera
    cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
    _tpBatTryHit()
end)
local function startTpBat()
    tpBatEnabled = true
    disableLinVel()
    local char = LP.Character; if char then _tpBatSetupChar(char) end
end
local function stopTpBat() tpBatEnabled = false end
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5); _tpBatSetupChar(char)
    if selectedAnimPack then task.wait(0.5); applyAnimPack(selectedAnimPack) end
end)
if LP.Character then task.spawn(function() _tpBatSetupChar(LP.Character) end) end

print("[SniperDuels] Loading step 7 - tabs")

-- ===== TAB: SPEED =====
do
    local p = pages["SPEED"]
    sectionLabel(p, "SPEED", 0)
    local _,_,_setNS = inputRow(p, "NORMAL SPEED", NS, 1, function(v) NS = v; _configState["normalSpeed"] = v; _autoSaveConfig() end)
    local _,_,_setCS = inputRow(p, "NORMAL CARRY", CS, 2, function(v) CS = v; _configState["carrySpeed_val"] = v; _autoSaveConfig() end)
    local _,_,_setLS = inputRow(p, "LAGGER SPEED", LAGGER_SPEED, 3, function(v) LAGGER_SPEED = v; _configState["laggerSpeed"] = v; _autoSaveConfig() end)
    local _,_,_setLCS = inputRow(p, "LAGGER CARRY", LAGGER_CARRY_SPEED, 4, function(v) LAGGER_CARRY_SPEED = v; _configState["laggerCarrySpeed"] = v; _autoSaveConfig() end)
    _AK._speedSetters = { ns=_setNS, cs=_setCS, ls=_setLS, lcs=_setLCS }
    _regToggle(p, "LAGGER MODE", false, 5, "LAGMODE", function(on)
        laggerToggled = on
        if on then laggerPhase = speedMode and 2 or 1; speedMode = false
        else laggerPhase = 0 end
    end)
end

-- ===== TAB: MECHANICS =====
do
    local p = pages["MECH"]
    sectionLabel(p, "MECHANICS", 0)
    _regToggle(p, "AUTO STEAL", false, 1, "AUTOSTEAL", function(on)
        Steal.AutoStealEnabled = on
        if on then
            if startAutoSteal then startAutoSteal() end
        else
            if stopAutoSteal then stopAutoSteal() end
        end
    end)
    local savedCR = loadConfig()
    local _initV1R = (savedCR["v1Radius"] and type(savedCR["v1Radius"])=="number") and savedCR["v1Radius"] or 60
    Steal.StealRadius = _initV1R
    local _,_,_setStealR = inputRow(p, "AUTO STEAL RADIUS", _initV1R, 2, function(v)
        Steal.StealRadius = math.max(1, v); _configState["v1Radius"] = Steal.StealRadius; _autoSaveConfig()
    end)
    _AK._mechSetters = { stealR = _setStealR }
    _regToggle(p, "AUTO TP DOWN", false, 3, "AUTOTP", function(on)
        autoTPEnabled = on
        if on then
            if autoTPConn then task.cancel(autoTPConn) end
            autoTPConn = task.spawn(function()
                while autoTPEnabled do
                    task.wait(0.1)
                    pcall(function()
                        local char=LP.Character; if not char then return end
                        local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
                        local h=char:FindFirstChildOfClass("Humanoid"); if not h then return end
                        if h.FloorMaterial == Enum.Material.Air and hrp.Position.Y >= autoTPHeight then
                            hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
                        end
                    end)
                end
            end)
        else
            if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
        end
    end)
    local _,_,_setTPH = inputRow(p, "AUTO TP HEIGHT", autoTPHeight, 4, function(v)
        autoTPHeight = v; _configState["tpHeight"] = v; _autoSaveConfig()
    end)
    _AK._mechSetters.tph = _setTPH
    local _,_,_setBatNormal = inputRow(p, "BAT SPEED", AUTO_BAT.SPEED_NORMAL, 5, function(v)
        AUTO_BAT.SPEED_NORMAL = math.clamp(math.floor(v), 1, 300)
        _configState["batSpeedNormal"] = AUTO_BAT.SPEED_NORMAL; _autoSaveConfig()
    end)
    _AK._batSpeedSetters = { normal = _setBatNormal }
    _regToggle(p, "TP BAT", false, 6, "TPBAT", function(on)
        if on then startTpBat() else stopTpBat() end
        if _AK._setTPBatVisual then _AK._setTPBatVisual(on) end
    end)
    local Row = Instance.new("Frame", p)
    Row.Size = UDim2.new(1,0,0,38); Row.BackgroundColor3 = THEME.Pink
    Row.BackgroundTransparency = ROW_ALPHA; Row.BorderSizePixel = 0; Row.LayoutOrder = 7
    addCorner(Row, 10); addStroke(Row, THEME.PinkDark, 1)
    local lbl = Instance.new("TextLabel", Row)
    lbl.Size = UDim2.new(0.5,0,0,16); lbl.Position = UDim2.new(0,12,0,7)
    lbl.BackgroundTransparency = 1; lbl.Text = "DROP METHOD"
    lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 5
    local function makeDChip(label, xOff)
        local chip = Instance.new("TextButton", Row)
        chip.AnchorPoint = Vector2.new(0, 0.5); chip.Position = UDim2.new(1, xOff, 0.5, 0)
        chip.Size = UDim2.new(0, 56, 0, 22); chip.BackgroundColor3 = THEME.BlackSoft
        chip.BorderSizePixel = 0; chip.Text = label; chip.TextColor3 = THEME.PinkGlow
        chip.Font = Enum.Font.GothamBold; chip.TextSize = 10; chip.AutoButtonColor = false; chip.ZIndex = 6
        addCorner(chip, 8); return chip
    end
    local v1Chip = makeDChip("JUMP", -122); local v2Chip = makeDChip("FLING", -62)
    local function refreshDropMode()
        local isV1 = (dropMode == "v1")
        v1Chip.BackgroundColor3 = isV1 and THEME.Pink or THEME.BlackSoft
        v1Chip.TextColor3 = isV1 and Color3.new(0,0,0) or THEME.PinkGlow
        v2Chip.BackgroundColor3 = (not isV1) and THEME.Pink or THEME.BlackSoft
        v2Chip.TextColor3 = (not isV1) and Color3.new(0,0,0) or THEME.PinkGlow
    end
    refreshDropMode(); _AK._refreshDropModeChips = refreshDropMode
    v1Chip.MouseButton1Click:Connect(function() dropMode = "v1"; _configState["dropMode"] = "v1"; _autoSaveConfig(); refreshDropMode() end)
    v2Chip.MouseButton1Click:Connect(function() dropMode = "v2"; _configState["dropMode"] = "v2"; _autoSaveConfig(); refreshDropMode() end)
    hoverRow(Row, ROW_ALPHA)
end

-- ===== TAB: ANIMATION =====
do
    local p = pages["ANIM"]
    sectionLabel(p, "ANIMATION PACKS", 0)
    local _animUpdaters = {}
    actionRow(p, "CLEAR ANIMATION", 1, function()
        clearAnimPack()
        for _, updater in pairs(_animUpdaters) do pcall(updater) end
    end)
    for i, name in ipairs(_animPackNames) do
        local Row = Instance.new("Frame", p)
        Row.Size = UDim2.new(1,0,0,34); Row.BackgroundColor3 = THEME.Pink
        Row.BackgroundTransparency = ROW_ALPHA; Row.BorderSizePixel = 0; Row.LayoutOrder = i + 10
        addCorner(Row, 10); local _rowStroke = addStroke(Row, THEME.PinkDark, 1)
        local lbl = Instance.new("TextLabel", Row)
        lbl.Size = UDim2.new(0.75,0,1,0); lbl.Position = UDim2.new(0,12,0,0)
        lbl.BackgroundTransparency = 1; lbl.Text = name
        lbl.TextColor3 = Color3.new(1,1,1); lbl.TextSize = 10
        lbl.Font = Enum.Font.GothamBold; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 5
        local check = Instance.new("TextLabel", Row)
        check.Size = UDim2.new(0, 24, 1, 0); check.Position = UDim2.new(1, -30, 0, 0)
        check.BackgroundTransparency = 1; check.Text = ""
        check.TextColor3 = THEME.Pink; check.TextSize = 16
        check.Font = Enum.Font.GothamBlack; check.ZIndex = 6
        local hit = hoverRow(Row, ROW_ALPHA)
        hit.ZIndex = 5
        hit.MouseButton1Click:Connect(function()
            if selectedAnimPack == name then clearAnimPack() else applyAnimPack(name) end
            for _, updater in pairs(_animUpdaters) do pcall(updater) end
        end)
        _animUpdaters[name] = function()
            if selectedAnimPack == name then
                check.Text = "check"; _rowStroke.Color = THEME.Pink; _rowStroke.Thickness = 2
            else
                check.Text = ""; _rowStroke.Color = THEME.PinkDark; _rowStroke.Thickness = 1
            end
        end
    end
    for _, updater in pairs(_animUpdaters) do pcall(updater) end
    _AK._refreshAnimRows = function() for _, u in pairs(_animUpdaters) do pcall(u) end end
end

-- ===== TAB: UTILS =====
do
    local p = pages["UTILS"]
    sectionLabel(p, "UTILS", 0)
    _regToggle(p, "ANTI DIE", false, 1, "ANTIDIE", function(on)
        if on then startAntiDie() else stopAntiDie() end
    end)
    _regToggle(p, "VAMPIRE ANIM", false, 2, "VAMPIREANM", function(on) _Flags.vampireAnimEnabled = on end)
    _regToggle(p, "FOV (120)", false, 3, "FOV120", function(on)
        local cam = workspace.CurrentCamera; if not cam then return end
        cam.FieldOfView = on and 120 or 70
    end)
    _regToggle(p, "BAT COUNTER", false, 4, "BATCOUNTER", function(on)
        batCounterEnabled = on
    end)
    _regToggle(p, "ANTI RAGDOLL", false, 5, "ANTIRAGDOLL", function(on)
        antiRagdollEnabled = on
    end)
    _regToggle(p, "UNWALK", false, 6, "UNWALK", function(on)
        unwalkEnabled = on
    end)
    _regToggle(p, "INFINITY JUMP", false, 7, "INFJUMP", function(on) infJumpEnabled = on end)
    local Row = Instance.new("Frame", p)
    Row.Size = UDim2.new(1,0,0,38); Row.BackgroundColor3 = THEME.Pink
    Row.BackgroundTransparency = ROW_ALPHA; Row.BorderSizePixel = 0; Row.LayoutOrder = 8
    addCorner(Row, 10); addStroke(Row, THEME.PinkDark, 1)
    local lbl = Instance.new("TextLabel", Row)
    lbl.Size = UDim2.new(0.5,0,0,16); lbl.Position = UDim2.new(0,12,0,7)
    lbl.BackgroundTransparency = 1; lbl.Text = "JUMP MODE"
    lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 5
    local cont = Instance.new("Frame", Row)
    cont.AnchorPoint = Vector2.new(1, 0.5); cont.Position = UDim2.new(1, -10, 0.5, 0)
    cont.Size = UDim2.new(0, 118, 0, 24); cont.BackgroundColor3 = THEME.BlackSoft
    cont.BorderSizePixel = 0; cont.ZIndex = 5; addCorner(cont, 5); addStroke(cont, THEME.PinkDark, 1)
    local manBtn = Instance.new("TextButton", cont)
    manBtn.Size = UDim2.new(0.5, 0, 1, 0)
    manBtn.BackgroundColor3 = infJumpMode == "manual" and THEME.Pink or THEME.BlackSoft
    manBtn.BorderSizePixel = 0; manBtn.Text = "MANUAL"
    manBtn.TextColor3 = infJumpMode == "manual" and Color3.new(0,0,0) or THEME.PinkGlow
    manBtn.Font = Enum.Font.GothamBold; manBtn.TextSize = 9; manBtn.ZIndex = 6; addCorner(manBtn, 5)
    local holdBtn = Instance.new("TextButton", cont)
    holdBtn.Size = UDim2.new(0.5, 0, 1, 0); holdBtn.Position = UDim2.new(0.5, 0, 0, 0)
    holdBtn.BackgroundColor3 = infJumpMode == "hold" and THEME.Pink or THEME.BlackSoft
    holdBtn.BorderSizePixel = 0; holdBtn.Text = "HOLD"
    holdBtn.TextColor3 = infJumpMode == "hold" and Color3.new(0,0,0) or THEME.PinkGlow
    holdBtn.Font = Enum.Font.GothamBold; holdBtn.TextSize = 9; holdBtn.ZIndex = 6; addCorner(holdBtn, 5)
    local function updateJumpModeUI(mode)
        infJumpMode = mode; _configState["infJumpMode"] = mode; _autoSaveConfig()
        TS:Create(manBtn, TweenInfo.new(0.15), { BackgroundColor3 = mode == "manual" and THEME.Pink or THEME.BlackSoft, TextColor3 = mode == "manual" and Color3.new(0,0,0) or THEME.PinkGlow }):Play()
        TS:Create(holdBtn, TweenInfo.new(0.15), { BackgroundColor3 = mode == "hold" and THEME.Pink or THEME.BlackSoft, TextColor3 = mode == "hold" and Color3.new(0,0,0) or THEME.PinkGlow }):Play()
    end
    manBtn.MouseButton1Click:Connect(function() updateJumpModeUI("manual") end)
    holdBtn.MouseButton1Click:Connect(function() updateJumpModeUI("hold") end)
    _AK.updateJumpModeUI = updateJumpModeUI
end

-- ===== TAB: MENU =====
do
    local p = pages["MENU"]
    sectionLabel(p, "MENU", 0)
    local saved = loadConfig()
    local _, _, _setMenuW = inputRow(p, "MENU WIDTH", (saved["menuW"] and math.clamp(saved["menuW"], 280, 600)) or 380, 1, function(v)
        local w = math.clamp(math.floor(v), 280, 600)
        Container.Size = UDim2.new(0, w, 0, Container.Size.Y.Offset)
        _configState["menuW"] = w
        if _AK.clampGui then _AK.clampGui() end
        _autoSaveConfig()
    end)
    _AK.setMenuW = _setMenuW
    local _, _, _setMenuH = inputRow(p, "MENU HEIGHT", (saved["menuH"] and math.clamp(saved["menuH"], 320, 700)) or 440, 2, function(v)
        local h = math.clamp(math.floor(v), 320, 700)
        Container.Size = UDim2.new(0, Container.Size.X.Offset, 0, h)
        _configState["menuH"] = h
        if _AK.clampGui then _AK.clampGui() end
        _autoSaveConfig()
    end)
    _AK.setMenuH = _setMenuH
    local lockOn = saved["dragLocked"] == true
    DragLocked = lockOn
    toggleRow(p, "LOCK GUI", lockOn, 3, function(on)
        DragLocked = on; _configState["dragLocked"] = on; _autoSaveConfig()
    end)
end

-- ===== TAB: CONFIG =====
do
    local p = pages["CONFIG"]
    sectionLabel(p, "CONFIG", 0)
    actionRow(p, "SAVE CONFIG", 1, function()
        local ok, err = saveConfigNow(_configState)
        if _AK.showToast then
            if ok then _AK.showToast("Config Saved (" .. tostring(err) .. ")", true)
            else _AK.showToast("Save failed: " .. tostring(err), false) end
        end
    end)
    actionRow(p, "RESET CONFIG", 2, function()
        for _, entry in ipairs(_toggleRegistry) do
            entry.setState(false); _configState[entry.key] = false
            if entry.callback then pcall(entry.callback, false) end
        end
        NS=60; CS=30; LAGGER_SPEED=45; LAGGER_CARRY_SPEED=20
        laggerPhase=0; speedMode=false; laggerToggled=false
        _configState["normalSpeed"] = 60; _configState["carrySpeed_val"] = 30
        _configState["laggerSpeed"] = 45; _configState["laggerCarrySpeed"] = 20
        if _AK._speedSetters then
            _AK._speedSetters.ns(60); _AK._speedSetters.cs(30)
            _AK._speedSetters.ls(45); _AK._speedSetters.lcs(20)
        end
        Steal.StealRadius = 60; _configState["v1Radius"] = 60
        if _AK._mechSetters and _AK._mechSetters.stealR then _AK._mechSetters.stealR(60) end
        autoTPHeight = 20; _configState["tpHeight"] = 20
        if _AK._mechSetters and _AK._mechSetters.tph then _AK._mechSetters.tph(20) end
        clearAnimPack()
        if _AK._refreshAnimRows then _AK._refreshAnimRows() end
        saveConfigNow(_configState)
        if _AK.showToast then _AK.showToast("Config Reset", true) end
    end)
end

-- ===== TAB: KEYS =====
do
    local p = pages["KEYS"]
    sectionLabel(p, "KEYBINDS (click to rebind)", 0)
    local _keybindMeta = {
        {label="Bat Aimbot", key="circle"},{label="Speed Toggle", key="speed"},
        {label="Carry Mode", key="carryMode"},{label="Lagger Mode", key="laggerToggle"},
        {label="Drop Brainrot", key="dropBrainrot"},{label="TP Down", key="tpDown"},
        {label="Auto Left", key="autoLeft"},{label="Auto Right", key="autoRight"},
        {label="Bat Desync TP", key="batDesyncTp"},{label="Instant Reset", key="instantReset"},
        {label="TP Bat", key="tpBat"},{label="Anti Die", key="antiDie"},
    }
    local _kbRows = {}; _AK._kbRows = _kbRows
    local _listeningFor = nil
    local function _keybindRow(labelText, keyName, order)
        local Row = Instance.new("Frame", p)
        Row.Size = UDim2.new(1,0,0,34); Row.BackgroundColor3 = THEME.Pink
        Row.BackgroundTransparency = ROW_ALPHA; Row.BorderSizePixel = 0; Row.LayoutOrder = order
        addCorner(Row, 10); local _rowStroke = addStroke(Row, THEME.PinkDark, 1)
        local lbl = Instance.new("TextLabel", Row)
        lbl.Size = UDim2.new(0.7,0,1,0); lbl.Position = UDim2.new(0,12,0,0)
        lbl.BackgroundTransparency = 1; lbl.Text = labelText
        lbl.TextColor3 = Color3.new(1,1,1); lbl.TextSize = 10
        lbl.Font = Enum.Font.GothamBold; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 5
        local keyBtn = Instance.new("TextButton", Row)
        keyBtn.Size = UDim2.new(0, 78, 0, 22); keyBtn.Position = UDim2.new(1, -88, 0.5, -11)
        keyBtn.BackgroundColor3 = THEME.BlackSoft; keyBtn.BorderSizePixel = 0
        keyBtn.Text = Keys[keyName].Name; keyBtn.TextColor3 = THEME.PinkGlow
        keyBtn.TextSize = 10; keyBtn.Font = Enum.Font.GothamBold; keyBtn.AutoButtonColor = false; keyBtn.ZIndex = 6
        addCorner(keyBtn, 6); addStroke(keyBtn, THEME.PinkDark, 1)
        hoverRow(Row, ROW_ALPHA)
        local function refresh()
            keyBtn.Text = Keys[keyName].Name; keyBtn.BackgroundColor3 = THEME.BlackSoft
            keyBtn.TextColor3 = THEME.PinkGlow
            _rowStroke.Color = THEME.PinkDark; _rowStroke.Thickness = 1
        end
        keyBtn.MouseButton1Click:Connect(function()
            if _listeningFor and _listeningFor ~= keyName then
                if _kbRows[_listeningFor] and _kbRows[_listeningFor].refresh then _kbRows[_listeningFor].refresh() end
            end
            _listeningFor = keyName
            keyBtn.Text = "Press..."
            keyBtn.BackgroundColor3 = THEME.Pink; keyBtn.TextColor3 = THEME.Black
            _rowStroke.Color = THEME.Pink; _rowStroke.Thickness = 2
        end)
        _kbRows[keyName] = { refresh = refresh, btn = keyBtn }
    end
    for i, meta in ipairs(_keybindMeta) do _keybindRow(meta.label, meta.key, i) end
    rawConn(UIS.InputBegan, function(input, gpe)
        if gpe then return end
        if not _listeningFor then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local kc = input.KeyCode; local name = _listeningFor
        if kc == Enum.KeyCode.Escape then
            if _kbRows[name] and _kbRows[name].refresh then _kbRows[name].refresh() end
            _listeningFor = nil; return
        end
        if kc == Enum.KeyCode.Unknown then return end
        Keys[name] = kc; _configState["kb_" .. name] = kc.Name; saveConfigNow(_configState)
        if _kbRows[name] and _kbRows[name].refresh then _kbRows[name].refresh() end
        _listeningFor = nil
    end)
end

-- ===== ANTI RAGDOLL =====
local antiRagResetCooldown = 0
local antiRagConnection = nil
function forceReset()
    local char = LP.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end
        workspace.CurrentCamera.CameraSubject = hum
        local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then local CM = require(PM:FindFirstChild("ControlModule")); if CM then CM:Enable() end end
        hum.AutoRotate = true; hum.PlatformStand = false; hum.Sit = false
    end)
end
function startAntiRagdoll()
    if antiRagConnection then return end
    antiRagdollEnabled = true
    antiRagConnection = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            local now = tick()
            if now - antiRagResetCooldown > 0.15 then antiRagResetCooldown = now; forceReset() end
        end
    end)
end
function stopAntiRagdoll()
    antiRagdollEnabled = false
    if antiRagConnection then antiRagConnection:Disconnect(); antiRagConnection = nil end
end
task.spawn(function()
    repeat task.wait() until isAlive() and game:IsLoaded() and LP and LP.Character
    if isAlive() then startAntiRagdoll() end
end)

-- ===== AUTO LEFT / RIGHT =====
local function _alCleanupProxy()
    if _alBypassPart then pcall(function() _alBypassPart:Destroy() end) end
    if _alBypassWeld then pcall(function() _alBypassWeld:Destroy() end) end
    _alBypassPart, _alBypassWeld = nil, nil
end
local function _alCreateProxy()
    _alCleanupProxy()
    local c = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    _alBypassPart = Instance.new("Part"); _alBypassPart.Name="SniperAutoLRProxy"
    _alBypassPart.Size=Vector3.new(1,1,1); _alBypassPart.Transparency=1
    _alBypassPart.CanCollide=false; _alBypassPart.Massless=true; _alBypassPart.Parent=c
    _alBypassWeld = Instance.new("Weld"); _alBypassWeld.Part0=hrp; _alBypassWeld.Part1=_alBypassPart
    _alBypassWeld.C0=CFrame.new(0,0,0); _alBypassWeld.Parent=_alBypassPart
end
local function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn=nil end
    alPhase=1
    local char=LP.Character
    if char then local h=char:FindFirstChildOfClass("Humanoid"); if h then h:Move(Vector3.zero,false) end end
    if _alBypassPart then _alBypassPart.AssemblyLinearVelocity=Vector3.zero end
    _alCleanupProxy()
end
local function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn=nil end
    arPhase=1
    local char=LP.Character
    if char then local h=char:FindFirstChildOfClass("Humanoid"); if h then h:Move(Vector3.zero,false) end end
    if _alBypassPart then _alBypassPart.AssemblyLinearVelocity=Vector3.zero end
    _alCleanupProxy()
end
local function startAutoLeft()
    local AP_L1=Vector3.new(-476.48,-6.28,92.73)
    local AP_L2=Vector3.new(-483.12,-4.95,94.80)
    local AP_L_FACE=Vector3.new(-482.25,-4.96,92.09)
    if alConn then alConn:Disconnect() end
    alPhase=1
    disableLinVel()
    alConn=RunService.Heartbeat:Connect(function()
        if not isAlive() then alConn:Disconnect(); alConn=nil; return end
        if not autoLeftEnabled then return end
        local char=LP.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false); return end
        if not _alBypassPart or _alBypassPart.Parent~=char then _alCreateProxy() end
        local spd=getAutoPathSpeed()
        if alPhase==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                alPhase=2
                local d=AP_L2-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false)
                if _alBypassPart then _alBypassPart.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) end
                return
            end
            local d=AP_L1-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false)
            if _alBypassPart then _alBypassPart.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) end
        elseif alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false)
                if _alBypassPart then _alBypassPart.AssemblyLinearVelocity=Vector3.zero end
                _alCleanupProxy()
                local _fd=Vector3.new(AP_L_FACE.X-hrp.Position.X,0,AP_L_FACE.Z-hrp.Position.Z)
                if _fd.Magnitude>0.01 then hrp.CFrame=CFrame.new(hrp.Position,hrp.Position+_fd) end
                autoLeftEnabled=false
                if alConn then alConn:Disconnect(); alConn=nil end
                alPhase=1
                return
            end
            local d=AP_L2-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false)
            if _alBypassPart then _alBypassPart.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) end
        end
    end)
end
local function startAutoRight()
    local AP_R1=Vector3.new(-476.16,-6.52,25.62)
    local AP_R2=Vector3.new(-483.06,-5.03,25.48)
    local AP_R_FACE=Vector3.new(-482.06,-6.93,35.47)
    if arConn then arConn:Disconnect() end
    arPhase=1
    disableLinVel()
    arConn=RunService.Heartbeat:Connect(function()
        if not isAlive() then arConn:Disconnect(); arConn=nil; return end
        if not autoRightEnabled then return end
        local char=LP.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false); return end
        if not _alBypassPart or _alBypassPart.Parent~=char then _alCreateProxy() end
        local spd=getAutoPathSpeed()
        if arPhase==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                arPhase=2
                local d=AP_R2-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false)
                if _alBypassPart then _alBypassPart.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) end
                return
            end
            local d=AP_R1-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false)
            if _alBypassPart then _alBypassPart.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) end
        elseif arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false)
                if _alBypassPart then _alBypassPart.AssemblyLinearVelocity=Vector3.zero end
                _alCleanupProxy()
                local _fd=Vector3.new(AP_R_FACE.X-hrp.Position.X,0,AP_R_FACE.Z-hrp.Position.Z)
                if _fd.Magnitude>0.01 then hrp.CFrame=CFrame.new(hrp.Position,hrp.Position+_fd) end
                autoRightEnabled=false
                if arConn then arConn:Disconnect(); arConn=nil end
                arPhase=1
                return
            end
            local d=AP_R2-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false)
            if _alBypassPart then _alBypassPart.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) end
        end
    end)
end

-- ===== DROPS =====
local function runDropV1()
    if dropActive then return end
    local char=LP.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
    dropActive=true
    local t0=tick()
    local dc
    dc=RunService.Heartbeat:Connect(function()
        local r=char and char:FindFirstChild("HumanoidRootPart")
        if not r then dc:Disconnect(); dropActive=false; return end
        if tick()-t0>=0.2 then
            dc:Disconnect()
            local rp=RaycastParams.new(); rp.FilterDescendantsInstances={char}; rp.FilterType=Enum.RaycastFilterType.Exclude
            local rr=workspace:Raycast(r.Position,Vector3.new(0,-2000,0),rp)
            if rr then
                local hum2=char:FindFirstChildOfClass("Humanoid")
                local off=(hum2 and hum2.HipHeight or 2)+(r.Size.Y/2)
                r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z)
                r.AssemblyLinearVelocity=Vector3.new(0,0,0)
            end
            dropActive=false; return
        end
        r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,150,r.AssemblyLinearVelocity.Z)
    end)
end
local function runDropV2()
    if dropActive then return end
    local char=LP.Character; if not char then return end
    if not char:FindFirstChild("HumanoidRootPart") then return end
    dropActive=true
    local colConn=RunService.Stepped:Connect(function()
        if not dropActive then return end
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LP and plr.Character then
                for _,part in ipairs(plr.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide=false end
                end
            end
        end
    end)
    local flingThread = coroutine.create(function()
        while dropActive do
            RunService.Heartbeat:Wait()
            local c = LP.Character
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if not r then break end
            local vel = r.Velocity
            r.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            if r and r.Parent then r.Velocity = vel end
            RunService.Stepped:Wait()
            if r and r.Parent then r.Velocity = vel + Vector3.new(0, 0.1, 0) end
        end
    end)
    coroutine.resume(flingThread)
    task.delay(0.1, function()
        dropActive = false
        if colConn then colConn:Disconnect() end
        pcall(coroutine.close, flingThread)
    end)
end
local function runDrop()
    if dropMode == "v2" then runDropV2() else runDropV1() end
end

function startUnwalk()
    local c=LP.Character; if not c then return end
    local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate")
    if anim then unwalkSavedAnimate=anim:Clone(); anim:Destroy() end
end
function stopUnwalk()
    local c=LP.Character
    if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c; unwalkSavedAnimate=nil end
end

rawConn(UIS.JumpRequest, function()
    if not infJumpEnabled then return end
    if infJumpMode~="manual" then return end
    local char=LP.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
end)
rawConn(RunService.Heartbeat, function()
    if not infJumpEnabled then return end
    if infJumpMode~="hold" then return end
    local char=LP.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local hum2=char:FindFirstChildOfClass("Humanoid")
    local jumpHeld = _Flags.holdJumpActive or (hum2 and hum2.Jump==true)
    if jumpHeld and root.Velocity.Y<30 then
        root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z)
    end
end)

-- ===== AUTO BAT =====
local _autoBatHittingCooldown=false
local function _autoBatSwing(char)
    if _autoBatHittingCooldown then return end
    _autoBatHittingCooldown = true
    task.spawn(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        local bat = char:FindFirstChildOfClass("Tool")
        if not bat then
            local bp = LP:FindFirstChild("Backpack")
            if bp then
                for _, t in ipairs(bp:GetChildren()) do
                    local n = t.Name:lower()
                    if n:find("bat") or n:find("slap") then bat = t; break end
                end
            end
        end
        if bat then
            if bat.Parent ~= char and hum then pcall(function() hum:EquipTool(bat) end); task.wait(0.05) end
            local remote = nil
            for _, d in ipairs(bat:GetDescendants()) do if d:IsA("RemoteEvent") then remote = d; break end end
            if remote then
                pcall(function() remote:FireServer() end); task.wait(0.12)
                pcall(function() remote:FireServer() end)
            else
                pcall(function() bat:Activate() end); task.wait(0.12)
                pcall(function() bat:Activate() end)
            end
        end
        task.delay(0.08, function() _autoBatHittingCooldown = false end)
    end)
end
local function _abCleanupProxy()
    if _abBypassPart then pcall(function() _abBypassPart:Destroy() end) end
    if _abBypassWeld then pcall(function() _abBypassWeld:Destroy() end) end
    _abBypassPart, _abBypassWeld = nil, nil
end
local function _abCreateProxy()
    _abCleanupProxy()
    local c=LP.Character
    local hrp=c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    _abBypassPart=Instance.new("Part"); _abBypassPart.Name="SniperBatProxy"
    _abBypassPart.Size=Vector3.new(1,1,1); _abBypassPart.Transparency=1
    _abBypassPart.CanCollide=false; _abBypassPart.Massless=true; _abBypassPart.Parent=c
    _abBypassWeld=Instance.new("Weld"); _abBypassWeld.Part0=hrp; _abBypassWeld.Part1=_abBypassPart
    _abBypassWeld.C0=CFrame.new(0,0,0); _abBypassWeld.Parent=_abBypassPart
end
local function getAutoBatTarget()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now=tick()
    if now-_autoBatLastScan<=0.1 and _autoBatTarget and _autoBatTarget.Parent then
        local hum=_autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health>0 then return _autoBatTarget end
    end
    _autoBatLastScan=now
    _autoBatTarget=nil
    local closest,minDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart")
            local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then
                local dist=(tRoot.Position-root.Position).Magnitude
                if dist<minDist then minDist=dist; closest=tRoot end
            end
        end
    end
    _autoBatTarget=closest
    return _autoBatTarget
end
local function enableAutoBat()
    if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false; stopAutoRight() end
    autoBatEquippedThisRun=false
    autoBatEnabled=true
    disableLinVel()
end
local function disableAutoBat()
    autoBatEnabled=false
    autoBatEquippedThisRun=false
    if _abBypassPart then _abBypassPart.AssemblyLinearVelocity=Vector3.zero end
    _abCleanupProxy()
    local char=LP.Character
    if char then local hum2=char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2.AutoRotate=true end end
    _autoBatTarget=nil
end
rawConn(RunService.RenderStepped, function()
    if not autoBatEnabled then return end
    local char = LP.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            for _,pt in ipairs(p.Character:GetDescendants()) do
                if pt:IsA("BasePart") then pt.CanCollide = false end
            end
        end
    end
    if not _abBypassPart or _abBypassPart.Parent ~= char then _abCreateProxy() end
    if autoBatEnabled and not autoBatEquippedThisRun then
        autoBatEquippedThisRun = true
        if not char:FindFirstChildOfClass("Tool") then
            local bp = LP:FindFirstChildOfClass("Backpack")
            if bp then
                for _,t in ipairs(bp:GetChildren()) do
                    local n=t.Name:lower()
                    if n:find("bat") or n:find("slap") then pcall(function() hum:EquipTool(t) end); break end
                end
            end
        end
    end
    local target = getAutoBatTarget()
    if not target then hum.AutoRotate=true; root.AssemblyAngularVelocity=Vector3.zero; return end
    local myPos = root.Position
    local targetPos = target.Position
    hum.AutoRotate = false
    local CHASE_SPEED = AUTO_BAT.SPEED_NORMAL or 58
    local VERT_SPEED = 52; local FOLLOW_DIST = -2; local HEIGHT_OFFSET = 1.6
    local VERT_OFFSET = 1; local TURN_SPEED = 285; local MAX_TURN_RATE = 40; local MIN_FOLLOW_DIST = 1
    local targetVel = target.AssemblyLinearVelocity
    local aimTargetPos = targetPos + (targetVel * math.clamp(targetVel.Magnitude / 130, 0.05, 0.15)) + Vector3.new(0, VERT_OFFSET, 0)
    local look = aimTargetPos - myPos
    local flatLook = Vector3.new(look.X, 0, look.Z)
    if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
        local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
        local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
        local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
        local pitchDelta = (targetPitch - root.Orientation.X + 180) % 360 - 180
        local yawRate = math.clamp(math.rad(yawDelta) * TURN_SPEED, -MAX_TURN_RATE, MAX_TURN_RATE)
        local pitchRate = math.clamp(math.rad(pitchDelta) * TURN_SPEED, -MAX_TURN_RATE, MAX_TURN_RATE)
        local yawRad = math.rad(root.Orientation.Y)
        local rightAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
        root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0) + (rightAxis * pitchRate)
    else
        root.AssemblyAngularVelocity = Vector3.zero
    end
    local followDist = math.max(math.abs(FOLLOW_DIST), MIN_FOLLOW_DIST)
    local dir = look.Magnitude > 0.01 and look.Unit or Vector3.new(1, 0, 0)
    local standPos = aimTargetPos - (dir * followDist) + Vector3.new(0, HEIGHT_OFFSET, 0)
    local moveDir = standPos - root.Position
    local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
    local hVel = hDir.Magnitude > 0.1 and hDir.Unit * CHASE_SPEED or Vector3.zero
    local vVel = math.abs(moveDir.Y) > 0.1 and Vector3.new(0, math.sign(moveDir.Y) * VERT_SPEED, 0) or Vector3.new(0, -2, 0)
    root.AssemblyLinearVelocity = hVel + vVel
    if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end
    if (targetPos - myPos).Magnitude < 6 then _autoBatSwing(char) end
end)

-- ===== BAT COUNTER =====
local function findBatForCounter()
    local c=LP.Character; if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    for _,ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _,ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    return nil
end
local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then
        if hum2 then pcall(function() hum2:EquipTool(bat) end) end
        task.wait(0.05)
    end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.15)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end); task.wait(0.15)
        pcall(function() bat:Activate() end)
    end
end
startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not isAlive() then Conns.batCounter:Disconnect(); Conns.batCounter=nil; return end
        if not batCounterEnabled then return end
        if _Flags.batCounterDebounce then return end
        local char=LP.Character; if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            _Flags.batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter()
                if bat then swingBatForCounter(bat,char) end
                task.wait(0.5)
                _Flags.batCounterDebounce=false
            end)
        end
    end)
end
stopBatCounter=function()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
    _Flags.batCounterDebounce=false
end

print("[SniperDuels] Loading step 9 - steal bar")

-- ===== STEAL BAR =====
do
    local AdaptStealBarHUD = Instance.new("ScreenGui")
    AdaptStealBarHUD.Name = "SniperDuels_AdaptBar"
    AdaptStealBarHUD.IgnoreGuiInset = true
    AdaptStealBarHUD.ResetOnSpawn = false
    AdaptStealBarHUD.DisplayOrder = 50
    AdaptStealBarHUD.Parent = PGui

    local StealBar = Instance.new("Frame", AdaptStealBarHUD)
    StealBar.Name = "StealBar"
    StealBar.Active = true
    StealBar.ZIndex = 50
    StealBar.Position = UDim2.new(0.5, -170, 1, -75)
    StealBar.Size = UDim2.new(0, 360, 0, 64)
    StealBar.BackgroundColor3 = THEME.Black
    StealBar.BorderSizePixel = 0
    StealBar.ClipsDescendants = true

    local StealBgImage = Instance.new("ImageLabel", StealBar)
    StealBgImage.Name = "BgImage"
    StealBgImage.Size = UDim2.new(1, 0, 1, 0)
    StealBgImage.BackgroundTransparency = 1
    StealBgImage.Image = "rbxassetid://137692455767789"
    StealBgImage.ImageTransparency = 0.45
    StealBgImage.ScaleType = Enum.ScaleType.Crop
    StealBgImage.ZIndex = 51
    StealBgImage.BorderSizePixel = 0

    local StealBarScale = Instance.new("UIScale", StealBar)
    StealBarScale.Scale = 0.7

    local DragHandle = Instance.new("Frame", StealBar)
    DragHandle.Size = UDim2.new(1, 0, 1, 0)
    DragHandle.BackgroundTransparency = 1
    DragHandle.ZIndex = 60

    local StatusIndicator = Instance.new("Frame", StealBar)
    StatusIndicator.Size = UDim2.new(0, 9, 0, 9)
    StatusIndicator.Position = UDim2.new(0, 12, 0, 13)
    StatusIndicator.BackgroundColor3 = THEME.Pink
    StatusIndicator.BorderSizePixel = 0
    StatusIndicator.ZIndex = 55
    addCorner(StatusIndicator, 4)

    Instance.new("UICorner", StealBar).CornerRadius = UDim.new(0, 14)
    addCorner(StealBgImage, 14)
    local _sbStroke = Instance.new("UIStroke", StealBar)
    _sbStroke.Color = THEME.PinkDark
    _sbStroke.Transparency = 0.35

    local PctLbl = Instance.new("TextLabel", StealBar)
    PctLbl.ZIndex = 61; PctLbl.Position = UDim2.new(0, 12, 0, 6)
    PctLbl.Size = UDim2.new(0, 90, 0, 20); PctLbl.BackgroundTransparency = 1
    PctLbl.Text = "0%"; PctLbl.TextColor3 = THEME.Pink
    PctLbl.TextSize = 12; PctLbl.Font = Enum.Font.GothamBold
    PctLbl.TextXAlignment = Enum.TextXAlignment.Left

    local FpsPingLbl = Instance.new("TextLabel", StealBar)
    FpsPingLbl.ZIndex = 61; FpsPingLbl.Position = UDim2.new(1, -155, 0, 6)
    FpsPingLbl.Size = UDim2.new(0, 145, 0, 20); FpsPingLbl.BackgroundTransparency = 1
    FpsPingLbl.Text = "FPS 60   PING 0ms"; FpsPingLbl.TextColor3 = THEME.PinkGlow
    FpsPingLbl.TextSize = 12; FpsPingLbl.Font = Enum.Font.GothamBold
    FpsPingLbl.TextXAlignment = Enum.TextXAlignment.Right

    local DiscordLbl = Instance.new("TextLabel", StealBar)
    DiscordLbl.ZIndex = 61; DiscordLbl.Position = UDim2.new(0, 12, 0, 28)
    DiscordLbl.Size = UDim2.new(1, -24, 0, 12); DiscordLbl.BackgroundTransparency = 1
    DiscordLbl.Text = "discord.gg/sniperduels"; DiscordLbl.TextColor3 = THEME.PinkGlow
    DiscordLbl.TextSize = 10; DiscordLbl.Font = Enum.Font.GothamMedium

    local Track = Instance.new("Frame", StealBar)
    Track.ZIndex = 61; Track.ClipsDescendants = true
    Track.Position = UDim2.new(0, 12, 1, -18); Track.Size = UDim2.new(1, -24, 0, 13)
    Track.BackgroundColor3 = Color3.fromRGB(35, 35, 38); Track.BorderSizePixel = 0
    addCorner(Track, 6)

    local Fill = Instance.new("Frame", Track)
    Fill.ZIndex = 62; Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = THEME.Pink; Fill.BorderSizePixel = 0
    addCorner(Fill, 6)

    progressFill = Fill; progressPct = PctLbl; progressStatusLbl = DiscordLbl

    local dragging, dragStartMouse, dragStartPos = false, nil, nil
    local dragConn, dragEndConn = nil, nil
    DragHandle.InputBegan:Connect(function(input)
        if DragLocked or mobileButtonsLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStartMouse = input.Position; dragStartPos = StealBar.Position
            if dragConn then dragConn:Disconnect() end
            if dragEndConn then dragEndConn:Disconnect() end
            dragConn = UIS.InputChanged:Connect(function(inp)
                if not dragging then return end
                if DragLocked or mobileButtonsLocked then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    local delta = inp.Position - dragStartMouse
                    StealBar.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
                end
            end)
            dragEndConn = UIS.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    if dragConn then dragConn:Disconnect(); dragConn = nil end
                    if dragEndConn then dragEndConn:Disconnect(); dragEndConn = nil end
                    _configState["stealBarXScale"] = StealBar.Position.X.Scale
                    _configState["stealBarXOffset"] = StealBar.Position.X.Offset
                    _configState["stealBarYScale"] = StealBar.Position.Y.Scale
                    _configState["stealBarYOffset"] = StealBar.Position.Y.Offset
                    saveConfigNow(_configState)
                end
            end)
        end
    end)
    local saved = loadConfig()
    if saved["stealBarXOffset"] and saved["stealBarYOffset"] then
        StealBar.Position = UDim2.new(saved["stealBarXScale"] or 0.5, saved["stealBarXOffset"], saved["stealBarYScale"] or 1, saved["stealBarYOffset"])
    end
    RunService.Heartbeat:Connect(function()
        if not isAlive() then return end
        local on = Steal.AutoStealEnabled
        local col = on and THEME.Pink or Color3.fromRGB(255, 0, 0)
        if StatusIndicator.BackgroundColor3 ~= col then StatusIndicator.BackgroundColor3 = col end
    end)
    _AK._fpsPingLbl = FpsPingLbl
end

;(function()
    local _lbl = _AK._fpsPingLbl
    local _fpsAcc, _fpsFrames = 0, 0
    local _elapsed = 0
    rawConn(RunService.Heartbeat, function(dt)
        _fpsAcc = _fpsAcc + dt; _fpsFrames = _fpsFrames + 1; _elapsed = _elapsed + dt
        if _elapsed < 0.8 then return end
        _elapsed = 0
        local fps = math.floor(_fpsFrames / _fpsAcc); _fpsAcc, _fpsFrames = 0, 0
        local ping = 0
        pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        if _lbl and _lbl.Parent then
            local col = THEME.PinkGlow
            if ping >= 150 then col = Color3.fromRGB(255, 90, 90)
            elseif ping >= 80 then col = Color3.fromRGB(255, 220, 80) end
            _lbl.Text = string.format("FPS %d   PING %dms", fps, ping)
            _lbl.TextColor3 = col
        end
    end)
end)()

print("[SniperDuels] Loading step 10 - auto steal logic")

-- ===== AUTO STEAL LOGIC =====
local STEAL_MODE_CFG = {
    [1]={threshold=0.90,nearDist=14},[2]={threshold=0.85,nearDist=12},
    [3]={threshold=0.80,nearDist=11},[4]={threshold=0.75,nearDist=10},
}
local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    local yb = sign and sign:FindFirstChild("YourBase")
    return yb and yb:IsA("BillboardGui") and yb.Enabled
end
local function getPromptPosition(prompt)
    if not prompt then return nil end
    local p = prompt.Parent
    while p and p ~= workspace do
        if p:IsA("BasePart") then return p.Position end
        p = p.Parent
    end
    return nil
end
local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            local base = pod:FindFirstChild("Base")
            if not base then continue end
            local spawn = base:FindFirstChild("Spawn")
            if not spawn then continue end
            local d = (spawn.Position - root.Position).Magnitude
            if d <= Steal.StealRadius and d < dist then
                local att = spawn:FindFirstChild("PromptAttachment")
                if att then
                    for _, p in ipairs(att:GetChildren()) do
                        if p:IsA("ProximityPrompt") and p.ActionText and p.ActionText:find("Steal") then
                            nearest, dist = p, d
                        end
                    end
                end
            end
        end
    end
    return nearest
end
local function setBar(p)
    p = math.clamp(p or 0, 0, 1)
    if progressFill and progressFill.Parent then
        progressFill.Size = UDim2.new(p, 0, 1, 0)
    end
    if progressPct then progressPct.Text = math.floor(p * 100) .. "%" end
end
local function executeSteal(prompt)
    if isStealing or not Steal.AutoStealEnabled then return end
    if not prompt or not prompt.Parent then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        if getconnections then
            local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
            if ok1 and conns1 then
                for _, c in ipairs(conns1) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
            end
            local ok2, conns2 = pcall(getconnections, prompt.Triggered)
            if ok2 and conns2 then
                for _, c in ipairs(conns2) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    stealStartTime = tick()
    task.spawn(function()
        for _, f in ipairs(data.hold) do pcall(f) end
    end)
    local cfg = STEAL_MODE_CFG[Steal.Mode] or STEAL_MODE_CFG[4]
    local threshold = cfg.threshold
    local nearDist = cfg.nearDist
    local totalTime = tonumber(Steal.StealDuration) or 1.3
    local timeToThreshold = totalTime * threshold
    local timeAfterThreshold = totalTime - timeToThreshold
    local startTime = tick()
    while tick() - startTime < timeToThreshold do
        if not Steal.AutoStealEnabled then
            isStealing = false; data.ready = true; setBar(0); return
        end
        setBar(math.clamp((tick() - startTime) / totalTime, 0, threshold))
        task.wait()
    end
    setBar(threshold)
    local stillNear = false
    local hrp = LP.Character and (LP.Character:FindFirstChild("HumanoidRootPart") or LP.Character:FindFirstChild("UpperTorso"))
    if hrp then
        local targetPos = getPromptPosition(prompt)
        if targetPos and (targetPos - hrp.Position).Magnitude <= nearDist then stillNear = true end
    end
    if not stillNear then
        local holdStart = tick()
        while tick() - holdStart < 4 do
            if not Steal.AutoStealEnabled then
                isStealing = false; data.ready = true; setBar(0); return
            end
            setBar(threshold)
            local hrp2 = LP.Character and (LP.Character:FindFirstChild("HumanoidRootPart") or LP.Character:FindFirstChild("UpperTorso"))
            if hrp2 then
                local tp = getPromptPosition(prompt)
                if tp and (tp - hrp2.Position).Magnitude <= nearDist then stillNear = true; break end
            end
            task.wait()
        end
        if not stillNear then
            isStealing = false; data.ready = true; setBar(0); return
        end
    end
    local resumeTime = tick()
    while tick() - resumeTime < timeAfterThreshold do
        if not Steal.AutoStealEnabled then
            isStealing = false; data.ready = true; setBar(0); return
        end
        local fin = (tick() - resumeTime) / math.max(timeAfterThreshold, 0.01)
        setBar(threshold + fin * (1 - threshold))
        task.wait()
    end
    setBar(1)
    for _, f in ipairs(data.trigger) do pcall(f) end
    task.wait(0.05)
    data.ready = true
    isStealing = false
    setBar(0)
end
startAutoSteal = function()
    if Conns.autoSteal then return end
    Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not isAlive() then Conns.autoSteal:Disconnect(); Conns.autoSteal = nil; return end
        if isStealing or not Steal.AutoStealEnabled then return end
        local ok, prompt = pcall(findNearestPrompt)
        if ok and prompt then pcall(executeSteal, prompt) end
    end)
end
stopAutoSteal = function()
    if Conns.autoSteal then Conns.autoSteal:Disconnect(); Conns.autoSteal = nil end
    isStealing = false
    setBar(0)
end
if Steal.AutoStealEnabled then startAutoSteal() end

print("[SniperDuels] Loading step 11 - floating buttons")

-- ===== FLOATING BUTTONS =====
_AK._fbBtns = {}
do
    local _fbBtns = _AK._fbBtns
    local FBGui = Instance.new("ScreenGui")
    FBGui.Name = "SniperDuels_QB"
    FBGui.ResetOnSpawn = false
    FBGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    FBGui.IgnoreGuiInset = true
    FBGui.Parent = PGui
    local FB_BTN = 65
    local _fbAllBtns = {}; _AK._fbAllBtns = _fbAllBtns
    _AK._setFbSize = function(sz)
        FB_BTN = math.clamp(sz, 35, 120)
        for _, b in ipairs(_fbAllBtns) do b.Size = UDim2.new(0, FB_BTN, 0, FB_BTN) end
    end
    local function _makeFB(label, key, defXOff, defYScale, defYOff)
        local btn = Instance.new("TextButton", FBGui)
        table.insert(_fbAllBtns, btn)
        btn.AnchorPoint = Vector2.new(1,0)
        btn.Position = UDim2.new(1, defXOff, defYScale, defYOff)
        btn.Size = UDim2.new(0, FB_BTN, 0, FB_BTN)
        btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0
        btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 5

        local _bg = Instance.new("Frame", btn)
        _bg.Size = UDim2.new(1,0,1,0); _bg.BackgroundColor3 = THEME.Black
        _bg.BorderSizePixel = 0; _bg.ZIndex = 4
        _bg.ClipsDescendants = true
        addCorner(_bg, 16)

        local _bgImg = Instance.new("ImageLabel", _bg)
        _bgImg.Name = "BgImage"
        _bgImg.Size = UDim2.new(1,0,1,0); _bgImg.BackgroundTransparency = 1
        _bgImg.Image = "rbxassetid://137692455767789"
        _bgImg.ImageTransparency = 0.25
        _bgImg.ScaleType = Enum.ScaleType.Crop
        _bgImg.ZIndex = 4
        addCorner(_bgImg, 16)

        local _bgTint = Instance.new("Frame", _bg)
        _bgTint.Name = "Tint"
        _bgTint.Size = UDim2.new(1,0,1,0); _bgTint.BackgroundColor3 = THEME.Pink
        _bgTint.BackgroundTransparency = 1; _bgTint.BorderSizePixel = 0; _bgTint.ZIndex = 5
        addCorner(_bgTint, 16)

        local _stroke = Instance.new("UIStroke", _bg)
        _stroke.Color = THEME.Pink; _stroke.Thickness = 1.5; _stroke.Transparency = 0.3

        local _lbl = Instance.new("TextLabel", btn)
        _lbl.Size = UDim2.new(1,0,1,0); _lbl.BackgroundTransparency = 1
        _lbl.Text = label; _lbl.TextColor3 = THEME.PinkGlow
        _lbl.Font = Enum.Font.GothamBold; _lbl.TextSize = 11; _lbl.TextWrapped = true; _lbl.ZIndex = 6
        _lbl.TextStrokeTransparency = 0.4; _lbl.TextStrokeColor3 = Color3.new(0,0,0)

        local _fdn,_fds,_fsp,_fdDragging,_justDragged = false,nil,nil,false,false
        btn.InputBegan:Connect(function(i)
            if DragLocked or mobileButtonsLocked then return end
            if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
            _fdn=true; _fds=i.Position; _fsp=btn.Position; _fdDragging=false; _justDragged=false
        end)
        rawConn(UIS.InputEnded, function(i)
            if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
            if not _fdn then return end
            _fdn=false
            if _fdDragging then
                _configState["btnPos_"..key] = { xScale = btn.Position.X.Scale, xOff = btn.Position.X.Offset, yScale = btn.Position.Y.Scale, yOff = btn.Position.Y.Offset }
                saveConfigNow(_configState)
            end
            _fdDragging=false
        end)
        btn.InputChanged:Connect(function(i)
            if not _fdn then return end
            if DragLocked or mobileButtonsLocked then _fdn=false; return end
            if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
            local d=i.Position-_fds
            if not _fdDragging then
                if math.abs(d.X)>8 or math.abs(d.Y)>8 then _fdDragging=true else return end
            end
            local vp=(workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1920,1080)
            local rawX=_fsp.X.Scale*vp.X+_fsp.X.Offset+d.X
            local rawY=_fsp.Y.Scale*vp.Y+_fsp.Y.Offset+d.Y
            btn.Position=UDim2.new(0,math.clamp(rawX,FB_BTN,vp.X),0,math.clamp(rawY,0,vp.Y-FB_BTN))
            _justDragged=true
        end)
        local dragGuard = function() if _justDragged then _justDragged=false; return true end; return false end
        local function setOn(on)
            if on then
                TS:Create(_bgTint,TweenInfo.new(0.18),{BackgroundTransparency=0.35}):Play()
                TS:Create(_stroke,TweenInfo.new(0.18),{Transparency=0.05,Thickness=2}):Play()
                TS:Create(_lbl,TweenInfo.new(0.18),{TextColor3=Color3.new(0,0,0),TextStrokeTransparency=1}):Play()
            else
                TS:Create(_bgTint,TweenInfo.new(0.18),{BackgroundTransparency=1}):Play()
                TS:Create(_stroke,TweenInfo.new(0.18),{Transparency=0.3,Thickness=1.5}):Play()
                TS:Create(_lbl,TweenInfo.new(0.18),{TextColor3=THEME.PinkGlow,TextStrokeTransparency=0.4}):Play()
            end
        end
        return btn, setOn, dragGuard
    end
    local _setLaggerFB, _setCarryFB, _setLagFB
    local lagBtn, setLagBtnOn, lagDrag = _makeFB("LAGGER SPD","lagSpeed",-150,0,30)
    _fbBtns.lagSpeed = lagBtn; _setLaggerFB = setLagBtnOn
    lagBtn.MouseButton1Click:Connect(function()
        if lagDrag() then return end
        if laggerToggled and laggerPhase==2 then laggerPhase=0
        elseif laggerToggled and laggerPhase==0 then laggerToggled=false; speedMode=true; laggerPhase=0
        else laggerToggled=true; speedMode=false; laggerPhase=0 end
        _setLaggerFB(laggerToggled and laggerPhase==0)
        if _setCarryFB then _setCarryFB(speedMode and not laggerToggled) end
        if _setLagFB then _setLagFB(laggerToggled and laggerPhase==2) end
    end)
    local alBtn, setALOn, alDrag = _makeFB("AUTO LEFT","autoLeft",-80,0,30)
    _fbBtns.autoLeft = alBtn; setALOn(autoLeftEnabled)
    alBtn.MouseButton1Click:Connect(function()
        if alDrag() then return end
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight() end
            if autoBatEnabled then disableAutoBat() end
            startAutoLeft()
        else stopAutoLeft() end
        setALOn(autoLeftEnabled)
    end)
    local arBtn, setAROn, arDrag = _makeFB("AUTO RIGHT","autoRight",-10,0,30)
    _fbBtns.autoRight = arBtn; setAROn(autoRightEnabled)
    arBtn.MouseButton1Click:Connect(function()
        if arDrag() then return end
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft() end
            if autoBatEnabled then disableAutoBat() end
            startAutoRight()
        else stopAutoRight() end
        setAROn(autoRightEnabled)
    end)
    local lcBtn, setLCOn, lcDrag = _makeFB("LAG CARRY","lagCarry",-150,0,100)
    _fbBtns.lagCarry = lcBtn; _setLagFB = setLCOn
    lcBtn.MouseButton1Click:Connect(function()
        if lcDrag() then return end
        if not laggerToggled then laggerToggled=true; speedMode=false; laggerPhase=2
        elseif laggerPhase==2 then laggerPhase=0
        else laggerPhase=2 end
        _setLagFB(laggerToggled and laggerPhase==2)
        _setLaggerFB(laggerToggled and laggerPhase==0)
        if _setCarryFB then _setCarryFB(speedMode and not laggerToggled) end
    end)
    local dropBtn, setDropOn, dropDrag = _makeFB("DROP","drop",-80,0,100)
    _fbBtns.drop = dropBtn
    dropBtn.MouseButton1Click:Connect(function()
        if dropDrag() then return end
        runDrop(); setDropOn(true); task.delay(0.3,function() setDropOn(false) end)
    end)
    local abBtn, setABOn, abDrag = _makeFB("AUTO BAT","autoBat",-10,0,100)
    _fbBtns.autoBat = abBtn; setABOn(autoBatEnabled)
    abBtn.MouseButton1Click:Connect(function()
        if abDrag() then return end
        if not autoBatEnabled then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); setALOn(false) end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); setAROn(false) end
            enableAutoBat()
        else disableAutoBat() end
        setABOn(autoBatEnabled)
    end)
    local csBtn, setCSOn, csDrag = _makeFB("CARRY SPD","carrySpeed",-150,0,170)
    _fbBtns.carrySpeed = csBtn; _setCarryFB = setCSOn; _setCarryFB(speedMode and not laggerToggled)
    csBtn.MouseButton1Click:Connect(function()
        if csDrag() then return end
        if laggerToggled then laggerToggled=false; laggerPhase=0; speedMode=true; _setLaggerFB(false); _setLagFB(false)
        else speedMode=not speedMode end
        _setCarryFB(speedMode)
    end)
    local tpDwnBtn, setTPDOn, tpDwnDrag = _makeFB("TP DOWN","tpDown",-80,0,240)
    _fbBtns.tpDown = tpDwnBtn
    tpDwnBtn.MouseButton1Click:Connect(function()
        if tpDwnDrag() then return end
        local char=LP.Character; if char then
            local hrp=char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0) end
        end
        setTPDOn(true); task.delay(0.3,function() setTPDOn(false) end)
    end)
    local tpBatBtn, setTPBatOn, tpBatDrag = _makeFB("TP BAT","tpBat",-150,0,240)
    _fbBtns.tpBat = tpBatBtn; _AK._setTPBatVisual = setTPBatOn; setTPBatOn(tpBatEnabled)
    tpBatBtn.MouseButton1Click:Connect(function()
        if tpBatDrag() then return end
        if not tpBatEnabled then startTpBat() else stopTpBat() end
        setTPBatOn(tpBatEnabled)
        for _, e in ipairs(_toggleRegistry) do
            if e.key == "TPBAT" then e.setState(tpBatEnabled); break end
        end
    end)
    task.delay(0.1, function()
        local saved = loadConfig()
        local _visItems = {{key="autoLeft"},{key="autoRight"},{key="drop"},{key="tpDown"},{key="autoBat"},{key="carrySpeed"},{key="lagSpeed"},{key="lagCarry"},{key="tpBat"}}
        for _, entry in ipairs(_visItems) do
            local cfgKey = "btnVis_" .. entry.key
            local savedState = saved[cfgKey]
            local shouldBeVisible = true
            if savedState ~= nil then shouldBeVisible = (savedState == true or savedState == "true") end
            if _fbBtns[entry.key] and _fbBtns[entry.key].Parent then
                _fbBtns[entry.key].Visible = shouldBeVisible
                _configState[cfgKey] = shouldBeVisible
            end
        end
        for key, _ in pairs(_fbBtns) do
            local p = saved["btnPos_" .. key]
            if p and type(p) == "table" and p.xOff ~= nil and p.yOff ~= nil then
                _fbBtns[key].Position = UDim2.new(p.xScale or 0, p.xOff, p.yScale or 0, p.yOff)
            end
        end
    end)
end

print("[SniperDuels] Loading step 12 - keybinds")

-- ===== KEYBIND HANDLERS =====
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local kc = input.KeyCode
    if kc == Keys.circle then
        if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
    elseif kc == Keys.speed then
        if laggerToggled then laggerToggled = false; laggerPhase = 0
        else speedMode = not speedMode end
    elseif kc == Keys.carryMode then
        if laggerToggled then laggerPhase = laggerPhase == 2 and 0 or 2
        else speedMode = not speedMode end
    elseif kc == Keys.laggerToggle then
        laggerToggled = not laggerToggled
        if not laggerToggled then laggerPhase = 0; speedMode = true end
    elseif kc == Keys.dropBrainrot then
        runDrop()
    elseif kc == Keys.tpDown then
        local char = LP.Character
        if char then local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0) end
        end
    elseif kc == Keys.autoLeft then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
    elseif kc == Keys.autoRight then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
    elseif kc == Keys.batDesyncTp then
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local target = getAutoBatTarget()
            if target then hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0)) end
        end
    elseif kc == Keys.instantReset then
        forceReset()
    elseif kc == Keys.tpBat then
        if not tpBatEnabled then startTpBat() else stopTpBat() end
        if _AK._setTPBatVisual then _AK._setTPBatVisual(tpBatEnabled) end
        for _, e in ipairs(_toggleRegistry) do
            if e.key == "TPBAT" then e.setState(tpBatEnabled); break end
        end
    elseif kc == Keys.antiDie then
        local newState = not antiDieEnabled
        if newState then startAntiDie() else stopAntiDie() end
        for _, e in ipairs(_toggleRegistry) do
            if e.key == "ANTIDIE" then e.setState(newState); break end
        end
    end
end)

print("[SniperDuels] Loading step 13 - config")

-- ===== LOAD SAVED CONFIG =====
task.spawn(function()
    local saved = loadConfig()
    if saved["menuXOffset"] and saved["menuYOffset"] then
        Container.Position = UDim2.new(saved["menuXScale"] or 0, saved["menuXOffset"], saved["menuYScale"] or 0, saved["menuYOffset"])
    end
    task.wait(0.5)
    if not isAlive() then return end
    saved = loadConfig()
    if not next(saved) then
        if _AK.clampGui then _AK.clampGui() end
        return
    end
    for _, entry in ipairs(_toggleRegistry) do
        local on = saved[entry.key]
        if on then
            entry.setState(true)
            _configState[entry.key] = true
            if entry.callback then pcall(entry.callback, true) end
        end
    end
    if saved["dropMode"] then dropMode = saved["dropMode"]; if _AK._refreshDropModeChips then _AK._refreshDropModeChips() end end
    if saved["menuW"] and type(saved["menuW"]) == "number" then
        local w = math.clamp(saved["menuW"], _AK.MENU_MIN_W, _AK.MENU_MAX_W)
        local h = math.clamp(saved["menuH"] or 440, _AK.MENU_MIN_H, _AK.MENU_MAX_H)
        Container.Size = UDim2.new(0, w, 0, h)
    end
    if saved["infJumpMode"] then
        local mode = saved["infJumpMode"]
        if mode == "manual" or mode == "hold" then
            infJumpMode = mode
            if _AK.updateJumpModeUI then _AK.updateJumpModeUI(mode) end
        end
    end
    if saved["normalSpeed"] then NS = saved["normalSpeed"]; if _AK._speedSetters then _AK._speedSetters.ns(NS) end end
    if saved["carrySpeed_val"] then CS = saved["carrySpeed_val"]; if _AK._speedSetters then _AK._speedSetters.cs(CS) end end
    if saved["laggerSpeed"] then LAGGER_SPEED = saved["laggerSpeed"]; if _AK._speedSetters then _AK._speedSetters.ls(LAGGER_SPEED) end end
    if saved["laggerCarrySpeed"] then LAGGER_CARRY_SPEED = saved["laggerCarrySpeed"]; if _AK._speedSetters then _AK._speedSetters.lcs(LAGGER_CARRY_SPEED) end end
    if saved["v1Radius"] then Steal.StealRadius = saved["v1Radius"]; if _AK._mechSetters and _AK._mechSetters.stealR then _AK._mechSetters.stealR(saved["v1Radius"]) end end
    if saved["tpHeight"] then autoTPHeight = saved["tpHeight"]; if _AK._mechSetters and _AK._mechSetters.tph then _AK._mechSetters.tph(saved["tpHeight"]) end end
    if saved["batSpeedNormal"] then AUTO_BAT.SPEED_NORMAL = saved["batSpeedNormal"]; if _AK._batSpeedSetters then _AK._batSpeedSetters.normal(saved["batSpeedNormal"]) end end
    if saved["animPack"] and ANIMATION_PACKS[saved["animPack"]] then
        selectedAnimPack = saved["animPack"]
        task.wait(1)
        applyAnimPack(saved["animPack"])
        if _AK._refreshAnimRows then _AK._refreshAnimRows() end
    end
    for name, _ in pairs(Keys) do
        local savedName = saved["kb_" .. name]
        if savedName then
            local ok, code = pcall(function() return Enum.KeyCode[savedName] end)
            if ok and code then Keys[name] = code end
        end
    end
    if _AK._kbRows then
        for _, entry in pairs(_AK._kbRows) do
            if entry.refresh then pcall(entry.refresh) end
        end
    end
    if saved["activeTab"] and _AK.setActiveTab then pcall(_AK.setActiveTab, saved["activeTab"]) end
    if _AK.clampGui then _AK.clampGui() end
end)

print("[SniperDuels] Loaded successfully!")
print("  Tabs: SPEED / MECH / ANIM / UTILS / MENU / CONFIG / KEYS")
print("  Anti Die keybind: Y")
print("  Discord: discord.gg/sniperduels")