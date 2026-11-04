local print = function() end
local warn  = function() end
pcall(function() if setthreadidentity then setthreadidentity(8) end end)
if not game:IsLoaded() then game.Loaded:Wait() end
local Instance = Instance
_G.CVN_X = _G.CVN_X or {}
do
    local X = _G.CVN_X
    local TS = game:GetService("TweenService")
    local RED   = Color3.fromRGB(222, 28, 44)
    local SNOW  = Color3.fromRGB(255, 255, 255)
    local GREEN = Color3.fromRGB(26, 160, 78)
    local GOLD  = Color3.fromRGB(255, 204, 72)
    X.RED, X.SNOW, X.GREEN, X.GOLD = RED, SNOW, GREEN, GOLD
    X.anims = {}
    X.done  = setmetatable({}, { __mode = "k" })

    local function seq(list)
        local kp = {}
        for i, c in ipairs(list) do kp[i] = ColorSequenceKeypoint.new((i - 1) / (#list - 1), c) end
        return ColorSequence.new(kp)
    end
    X.seq = seq
    X.RING  = seq({ RED, GOLD, SNOW, GREEN, SNOW, RED })
    X.SHINE = seq({ RED, SNOW, GREEN, SNOW, GOLD, SNOW, RED })

    -- hard-edged stripes, phase-shifted so they scroll (max 18 keypoints)
    function X.candySeq(n, phase, c1, c2)
        local cuts = {}
        for k = 0, n - 1 do cuts[#cuts + 1] = { t = (k / n + phase) % 1, c = (k % 2 == 0) and c1 or c2 } end
        table.sort(cuts, function(a, b) return a.t < b.t end)
        local wrapC = cuts[#cuts].c
        local kp, last, prevC = { ColorSequenceKeypoint.new(0, wrapC) }, 0, wrapC
        for _, cut in ipairs(cuts) do
            local t0, t1 = cut.t - 0.002, cut.t
            if t0 > last + 0.0005 and t1 < 0.999 then
                kp[#kp + 1] = ColorSequenceKeypoint.new(t0, prevC)
                kp[#kp + 1] = ColorSequenceKeypoint.new(t1, cut.c)
                last = t1
            end
            prevC = cut.c
        end
        kp[#kp + 1] = ColorSequenceKeypoint.new(1, prevC)
        return ColorSequence.new(kp)
    end

    function X.add(g, kind, speed, owner)
        X.anims[#X.anims + 1] = { g = g, k = kind, s = speed or 1, o = owner }
        return g
    end

    function X.grad(parent, colorSeq, kind, speed, rot)
        local g = Instance.new("UIGradient")
        g.Color = colorSeq; g.Rotation = rot or 0; g.Parent = parent
        return X.add(g, kind, speed)
    end

    -- gate (optional): a Frame -> only animates while it's visible (BackgroundTransparency < 1),
    -- a BillboardGui/ScreenGui -> only while Enabled. Keeps hidden stripes from costing anything.
    function X.candy(target, gate)
        local g = Instance.new("UIGradient")
        g.Rotation = 32
        g.Color = X.candySeq(8, 0, RED, SNOW)
        g.Parent = target
        return X.add(g, "candy", 0.35, gate)
    end
    local function gateOpen(o)
        if not o then return true end
        if o:IsA("LayerCollector") then return o.Enabled end
        if o:IsA("GuiObject") then return o.BackgroundTransparency < 0.99 end
        return true
    end

    _G.__CVN_ENGINE = (_G.__CVN_ENGINE or 0) + 1
    local engineToken = _G.__CVN_ENGINE
    task.spawn(function()
        while _G.__CVN_ENGINE == engineToken do
            local t, a = os.clock(), X.anims
            for i = #a, 1, -1 do
                local e = a[i]
                local g = e.g
                if not g.Parent then
                    table.remove(a, i)
                elseif g.Enabled then pcall(function()
                    if e.k == "rot" then
                        g.Rotation = (t * 60 * e.s) % 360
                    elseif e.k == "sweep" then
                        g.Offset = Vector2.new(((t * 0.3 * e.s) % 2) - 1, 0)
                    elseif e.k == "candy" then
                        if gateOpen(e.o) then
                            g.Color = X.candySeq(8, (t * e.s) % 1, RED, SNOW)
                        end
                    end
                end) end
            end
            task.wait(1 / 30)
        end
    end)

    local function bubble(b)
        if X.done[b] then return end
        X.done[b] = true
        if b.BackgroundTransparency >= 0.9 then return end
        local c = b:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
        c.CornerRadius = UDim.new(1, 0); c.Parent = b
        local shine = Instance.new("Frame")
        shine.Name = "Shine"; shine.Active = false
        shine.AnchorPoint = Vector2.new(0.5, 0)
        shine.Position = UDim2.new(0.5, 0, 0, 2); shine.Size = UDim2.new(1, -10, 0.38, 0)
        shine.BackgroundColor3 = SNOW; shine.BackgroundTransparency = 0.84
        shine.BorderSizePixel = 0; shine.ZIndex = b.ZIndex
        local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(1, 0); sc.Parent = shine
        shine.Parent = b
        if b:FindFirstChildOfClass("UIScale") then return end
        local us = Instance.new("UIScale"); us.Parent = b
        local down = TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local up   = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        b.MouseButton1Down:Connect(function() TS:Create(us, down, { Scale = 0.9 }):Play() end)
        b.MouseButton1Up:Connect(function() TS:Create(us, up, { Scale = 1 }):Play() end)
        b.MouseLeave:Connect(function() TS:Create(us, up, { Scale = 1 }):Play() end)
        b.MouseEnter:Connect(function() TS:Create(us, up, { Scale = 1.04 }):Play() end)
    end
    X.bubble = bubble

    local function ring(stroke)
        if X.done[stroke] then return end
        X.done[stroke] = true
        stroke.Color = SNOW
        stroke.Transparency = math.min(stroke.Transparency, 0.1)
        stroke.Thickness = math.max(stroke.Thickness, 1.6)
        X.grad(stroke, X.RING, "rot", 1)
    end

    local function touch(gui, d)
        if not d.Parent then return end
        if gui.Name == "SlcConvToast" then return end   -- the toast fades in on its own, leave it alone
        if d:IsA("TextButton") then
            bubble(d)
        elseif d:IsA("UIStroke") and d.Parent:IsA("Frame") and d.Parent.Parent == gui then
            ring(d)
        end
    end

    function X.reg(gui)
        gui.DescendantAdded:Connect(function(d)
            task.defer(touch, gui, d)
        end)
    end

    local _IN = Instance.new
    Instance = { new = function(className, parent)
        local o = _IN(className, parent)
        if className == "ScreenGui" then X.reg(o) end
        return o
    end }
end

_G.CVN_xmasTitle = function(lbl)
    local X = _G.CVN_X
    X.grad(lbl, X.SHINE, "sweep", 1, 0)
    lbl.TextStrokeColor3 = Color3.fromRGB(8, 32, 18)
    lbl.TextStrokeTransparency = 0.35
    task.defer(function() lbl.TextColor3 = Color3.fromRGB(255, 255, 255) end)
end
do
    local missing = {}
    local checks = {
        { name="fireproximityprompt", fn=fireproximityprompt },
        { name="firesignal", fn=firesignal },
        { name="request (http)", fn=((syn and syn.request) or (http and http.request) or http_request or request) },
    }
    for _, c in ipairs(checks) do
        if type(c.fn) ~= "function" then missing[#missing+1] = c.name end
    end
    local okInst = pcall(function() return game:GetService("ReplicatedStorage").Packages end)
    if not okInst then missing[#missing+1] = "Instance access (identity too low)" end
    if #missing > 0 then
        local msg = "[IDONTLOG CONVINCER] Your executor is missing: "..table.concat(missing, ", ")..
            ". Some features (trade list / invites / chat) may not work. Use a better executor (Wave, Solara, etc)."
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Idontlog Convincer — Executor Warning",
                Text = "Missing: "..table.concat(missing, ", ").." — some features may not work.",
                Duration = 12,
            })
        end)
    end
end
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local HttpService       = game:GetService("HttpService")
local LocalPlayer       = Players.LocalPlayer
local IS_TOUCH = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
local DEVICE = "desktop"
do
    if IS_TOUCH then
        local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
        local shortSide = math.min(vp.X, vp.Y)
        DEVICE = (shortSide < 600) and "phone" or "tablet"
    end
end
local UI_SCALE = (DEVICE=="phone") and 0.62 or (DEVICE=="tablet") and 0.82 or 1
local function applyUIScale(f)
    local s=Instance.new("UIScale", f); s.Scale=UI_SCALE; return s
end
_G.__IdontlogConvincerSession = (_G.__IdontlogConvincerSession or 0) + 1
local SESSION = _G.__IdontlogConvincerSession
local function alive() return _G.__IdontlogConvincerSession == SESSION end
local gethui = gethui or function() return game:GetService("CoreGui") end
local httprequest = (syn and syn.request) or (http and http.request) or http_request or request
local setclipboard = setclipboard or toclipboard or (function() end)
local TRANSLATE_ENDPOINT = ""   -- no third-party relay, translation goes straight to the translate service
local C = {
    BG=Color3.fromRGB(11,27,19), SURF=Color3.fromRGB(12,31,21), SURF2=Color3.fromRGB(18,46,31),
    TEXT=Color3.fromRGB(246,250,255), DIM=Color3.fromRGB(150,186,166),
    ACCENT=Color3.fromRGB(240,32,44), ACCENT2=Color3.fromRGB(190,27,38), STROKE=Color3.fromRGB(220,30,42),
    GREEN1=Color3.fromRGB(20,92,48), GREEN2=Color3.fromRGB(30,128,64), GREEN_STROKE=Color3.fromRGB(96,214,128),
    OFF_BG=Color3.fromRGB(21,53,36), OFF_TEXT=Color3.fromRGB(150,186,166),
    BLUE=Color3.fromRGB(90,150,235),
}
local FOLDER="IdontlogConvincer"; local CFG_FILE=FOLDER.."/config.json"; local HOPS_FILE=FOLDER.."/hops.json"
local OLD_CFG_FILE="SlicedzConvincer/config.json"; local OLD_HOPS_FILE="SlicedzConvincer/hops.json"
local function ensureFolder()
    pcall(function()
        if type(makefolder)=="function" then
            if type(isfolder)=="function" then
                if not isfolder(FOLDER) then makefolder(FOLDER) end
            else
                makefolder(FOLDER)
            end
        end
    end)
end
ensureFolder()
local Config = {
    myLang="en", theirLang="auto", presets={}, translatorOn=true, pos={x=0.03,y=0.12},
    priorityList={}, autoHop=false, hopTier="Normal", hopDelay=2, alertSound=true,
    alertSoundId="rbxassetid://6518811702", showAvatars=true, beamToBase=true,
}
pcall(function()
    local src = (type(isfile)=="function") and ((isfile(CFG_FILE) and CFG_FILE) or (isfile(OLD_CFG_FILE) and OLD_CFG_FILE)) or nil
    if src then
        local ok,d=pcall(function() return HttpService:JSONDecode(readfile(src)) end)
        if ok and type(d)=="table" then for k,v in pairs(d) do Config[k]=v end end
    end
end)
local function saveConfig()
    if type(writefile)~="function" then return end
    ensureFolder()
    local ok,err = pcall(function() writefile(CFG_FILE, HttpService:JSONEncode(Config)) end)
    local _ = ok
end
local HopData = { hoppedServers={} }
local function saveHops() end
pcall(function() if type(isfile)=="function" and type(delfile)=="function" then for _,f in ipairs({HOPS_FILE, OLD_HOPS_FILE}) do if isfile(f) then delfile(f) end end end end)
local LANGS = {
    {code="en", name="English"}, {code="es", name="Spanish"}, {code="pt", name="Portuguese"},
    {code="fr", name="French"},  {code="de", name="German"},  {code="it", name="Italian"},
    {code="ru", name="Russian"}, {code="tr", name="Turkish"}, {code="pl", name="Polish"},
    {code="nl", name="Dutch"},   {code="ar", name="Arabic"},  {code="id", name="Indonesian"},
    {code="vi", name="Vietnamese"}, {code="th", name="Thai"}, {code="ja", name="Japanese"},
    {code="ko", name="Korean"},  {code="zh-CN", name="Chinese (Simplified)"}, {code="zh-TW", name="Chinese (Traditional)"},
    {code="hi", name="Hindi"}, {code="bn", name="Bengali"}, {code="ur", name="Urdu"},
    {code="pa", name="Punjabi"}, {code="ta", name="Tamil"}, {code="te", name="Telugu"},
    {code="mr", name="Marathi"}, {code="gu", name="Gujarati"}, {code="ml", name="Malayalam"},
    {code="kn", name="Kannada"}, {code="fil", name="Filipino"}, {code="ms", name="Malay"},
    {code="fa", name="Persian"}, {code="ro", name="Romanian"}, {code="uk", name="Ukrainian"},
    {code="sv", name="Swedish"}, {code="no", name="Norwegian"}, {code="da", name="Danish"},
    {code="fi", name="Finnish"}, {code="cs", name="Czech"}, {code="sk", name="Slovak"},
    {code="el", name="Greek"}, {code="he", name="Hebrew"}, {code="hu", name="Hungarian"},
    {code="bg", name="Bulgarian"}, {code="hr", name="Croatian"}, {code="sr", name="Serbian"},
    {code="sl", name="Slovenian"}, {code="lt", name="Lithuanian"}, {code="lv", name="Latvian"},
    {code="et", name="Estonian"}, {code="af", name="Afrikaans"}, {code="sw", name="Swahili"},
    {code="ca", name="Catalan"}, {code="gl", name="Galician"}, {code="is", name="Icelandic"},
    {code="ga", name="Irish"}, {code="cy", name="Welsh"}, {code="sq", name="Albanian"},
    {code="mk", name="Macedonian"}, {code="az", name="Azerbaijani"}, {code="ka", name="Georgian"},
    {code="hy", name="Armenian"}, {code="kk", name="Kazakh"}, {code="uz", name="Uzbek"},
    {code="mn", name="Mongolian"}, {code="ne", name="Nepali"}, {code="si", name="Sinhala"},
    {code="km", name="Khmer"}, {code="lo", name="Lao"}, {code="my", name="Burmese"},
    {code="am", name="Amharic"}, {code="yo", name="Yoruba"}, {code="ig", name="Igbo"},
    {code="ha", name="Hausa"}, {code="zu", name="Zulu"}, {code="haw", name="Hawaiian"},
    {code="mi", name="Maori"}, {code="la", name="Latin"}, {code="eo", name="Esperanto"},
    {code="be", name="Belarusian"}, {code="bs", name="Bosnian"}, {code="eu", name="Basque"},
    {code="ceb", name="Cebuano"}, {code="ny", name="Chichewa"}, {code="co", name="Corsican"},
    {code="fy", name="Frisian"}, {code="gd", name="Scots Gaelic"}, {code="ht", name="Haitian Creole"},
    {code="hmn", name="Hmong"}, {code="jw", name="Javanese"},
    {code="ku", name="Kurdish"}, {code="ky", name="Kyrgyz"}, {code="lb", name="Luxembourgish"},
    {code="mg", name="Malagasy"}, {code="mt", name="Maltese"}, {code="or", name="Odia"},
    {code="ps", name="Pashto"}, {code="sm", name="Samoan"}, {code="sn", name="Shona"},
    {code="sd", name="Sindhi"}, {code="so", name="Somali"}, {code="st", name="Sesotho"},
    {code="su", name="Sundanese"}, {code="tg", name="Tajik"}, {code="tt", name="Tatar"},
    {code="tk", name="Turkmen"}, {code="ug", name="Uyghur"}, {code="xh", name="Xhosa"},
    {code="yi", name="Yiddish"}, {code="as", name="Assamese"}, {code="ay", name="Aymara"},
    {code="bm", name="Bambara"}, {code="bho", name="Bhojpuri"}, {code="dv", name="Dhivehi"},
    {code="doi", name="Dogri"}, {code="ee", name="Ewe"}, {code="gn", name="Guarani"},
    {code="ilo", name="Ilocano"}, {code="rw", name="Kinyarwanda"}, {code="gom", name="Konkani"},
    {code="kri", name="Krio"}, {code="ckb", name="Kurdish (Sorani)"}, {code="ln", name="Lingala"},
    {code="lg", name="Luganda"}, {code="mai", name="Maithili"}, {code="mni-Mtei", name="Meiteilon"},
    {code="lus", name="Mizo"}, {code="om", name="Oromo"}, {code="qu", name="Quechua"},
    {code="sa", name="Sanskrit"}, {code="nso", name="Sepedi"}, {code="ti", name="Tigrinya"},
    {code="ts", name="Tsonga"}, {code="ak", name="Twi"},
}
local LANG_NAME = {}
for _, l in ipairs(LANGS) do LANG_NAME[l.code] = l.name end
local function langName(code)
    if not code or code=="" or code=="auto" then return "—" end
    return LANG_NAME[code] or code:upper()
end
local SLOT_LAYOUT = {
    [1]={-18.954,-2.509,-21.346,-90}, [2]={-18.954,-2.509,-28.846,-90}, [3]={-18.954,-2.509,-36.346,-90},
    [4]={-18.954,-2.509,-43.846,-90}, [5]={-18.954,-2.509,-51.346,-90},
    [6]={18.081,-2.509,-51.346,90}, [7]={18.081,-2.509,-43.846,90}, [8]={18.081,-2.509,-36.346,90},
    [9]={18.081,-2.509,-28.846,90}, [10]={18.081,-2.509,-21.346,90},
    [11]={-18.954,15.491,-21.346,-90}, [12]={-18.954,15.491,-28.846,-90}, [13]={-18.954,15.491,-36.346,-90},
    [14]={-18.954,15.491,-43.846,-90}, [15]={-18.954,15.491,-51.346,-90},
    [16]={17.926,15.491,-21.37,90}, [17]={17.926,15.491,-28.87,90}, [18]={17.926,15.491,-36.37,90},
    [19]={-18.954,32.491,-23.346,-90}, [20]={-18.954,32.491,-30.846,-90}, [21]={-18.954,32.491,-38.346,-90},
    [22]={-18.954,32.491,-45.846,-90}, [23]={-18.954,32.491,-53.346,-90},
    [24]={18.017,32.491,-23.321,90}, [25]={18.017,32.491,-30.821,90}, [26]={18.017,32.491,-38.321,90},
    [27]={18.017,32.491,-45.821,90}, [28]={18.017,32.491,-53.321,90},
}
local PODIUM_PLATES = {
    { size=Vector3.new(4,0.25,4), color=Color3.fromRGB(104,108,121), yOff=-1.62, top=Enum.SurfaceType.Smooth },
    { size=Vector3.new(6,0.25,6), color=Color3.fromRGB(69,71,80),   yOff=-1.88, top=Enum.SurfaceType.Studs },
}
local SLOT_FLOOR_Y = { [1]=-2.509, [2]=15.491, [3]=32.491 }
local function slotFloorNum(slot) return slot<=10 and 1 or slot<=18 and 2 or 3 end
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
local Animals   = require(ReplicatedStorage.Datas.Animals)
local Mutations = (function() local ok,m=pcall(require,ReplicatedStorage.Datas.Mutations); return ok and m or {} end)()
local Traits    = (function() local ok,t=pcall(require,ReplicatedStorage.Datas.Traits); return ok and t or {} end)()
local GameData  = (function() local ok,g=pcall(require,ReplicatedStorage.Datas.Game); return ok and g or nil end)()
local function computeGeneration(index, mutation, traits)
    local a = Animals and Animals[index]
    if not a then return 0 end
    local base = a.Generation or (a.Price * (GameData and GameData.Game and GameData.Game.AnimalGanerationModifier or 0))
    local traitMult = 1
    local sleepy = false
    if traits then
        for _,t in pairs(traits) do
            local td = Traits[t]
            if td then
                if t ~= "Sleepy" then traitMult = traitMult + (td.MultiplierModifier or 0)
                else sleepy = true end
            end
        end
    end
    local mutMult = (mutation and Mutations[mutation]) and (1 + (Mutations[mutation].Modifier or 0)) or 1
    local gen = base * mutMult * traitMult
    if sleepy then gen = gen * 0.5 end
    return math.round(gen)
end
local SHOW_RARITIES = { Secret=true, OG=true }
local function genOf(e)
    local info=Animals[e.Index]; if not info or not info.Generation then return 0 end
    local mult=1
    if e.Mutation and e.Mutation~="None" and e.Mutation~="" then
        local m=Mutations[e.Mutation]; if m and m.Modifier then mult=mult+m.Modifier end
    end
    if type(e.Traits)=="table" then for _,tr in ipairs(e.Traits) do
        local t=Traits[tr]; if t and t.MultiplierModifier then mult=mult+t.MultiplierModifier end
    end end
    return (tonumber(info.Generation) or 0)*mult
end
local function fmtGen(n)
    n=tonumber(n) or 0
    if n>=1e12 then return string.format("%.1fT",n/1e12) elseif n>=1e9 then return string.format("%.1fB",n/1e9)
    elseif n>=1e6 then return string.format("%.1fM",n/1e6) elseif n>=1e3 then return string.format("%.1fK",n/1e3)
    else return tostring(math.floor(n)) end
end
local BrainrotAssets = (function() local ok,b=pcall(require,ReplicatedStorage.Shared.BrainrotAssets); return ok and b or nil end)()
local AssetCache = (function()
    local asc = ReplicatedStorage:FindFirstChild("Controllers")
    asc = asc and asc:FindFirstChild("AssetStreamController")
    return asc and asc:FindFirstChild("AssetCache") or nil
end)()
local SharedModels = (function()
    local m = ReplicatedStorage:FindFirstChild("Models")
    return m and m:FindFirstChild("Animals") or nil
end)()
local MutationsData_ = (function() local ok,m=pcall(require,ReplicatedStorage.Datas.Mutations); return ok and m or {} end)()
local function applyMutationSafe(model, mutation)
    if not mutation or mutation=="None" or mutation=="" then return end
    local mdata = MutationsData_[mutation]
    if not mdata or not mdata.Palettes then return end
    local paletteIdx = model:GetAttribute(mutation.."Palette") or model:GetAttribute("Palette") or 1
    paletteIdx = tonumber(paletteIdx) or 1
    local palette = mdata.Palettes[paletteIdx] or mdata.Palettes[1]
    if not palette then return end
    pcall(function()
        for _,p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") then
                for _,ex in ipairs(p:GetChildren()) do if ex:IsA("SurfaceAppearance") then ex:Destroy() end end
                if mutation~="Rainbow" then
                    local ci = p:GetAttribute(mutation.."Color") or p:GetAttribute("Color") or 1
                    ci = tonumber(ci) or 1
                    local col = palette[ci] or palette[math.clamp(ci,1,#palette)]
                    if typeof(col)=="Color3" then p.Color=col end
                    if p:GetAttribute("Neon") then p.Material=Enum.Material.Neon end
                end
            end
        end
    end)
end
local function getGameModel(index, mutation, traits)
    local result, fromGame = nil, false
    if SharedAnimals and SharedAnimals.GetAnimatedModel then
        local ok, model = pcall(function()
            return SharedAnimals:GetAnimatedModel(index, mutation, traits or {})
        end)
        if ok and typeof(model)=="Instance" then result, fromGame = model, true end
    end
    if setthreadidentity then pcall(setthreadidentity, 8) end
    return result, fromGame
end
local function getBrainrotClone(index)
    local src = (AssetCache and AssetCache:FindFirstChild(index)) or (SharedModels and SharedModels:FindFirstChild(index))
    if src and src:IsA("Model") then
        local ok, cl = pcall(function() return src:Clone() end)
        if ok then return cl end
    end
    return nil
end
local MutationSurfaces = ReplicatedStorage:FindFirstChild("MutationSurfaces")
local SharedAnimals = (function() local ok,a=pcall(require,ReplicatedStorage.Shared.Animals); return ok and a or nil end)()
local Rarities = (function() local ok,r=pcall(require,ReplicatedStorage.Datas.Rarities); return ok and r or {} end)()
local Gradients = (function() local ok,g=pcall(require,ReplicatedStorage.Packages.Gradients); return ok and g or nil end)()
local AnimalOverheadCtrl = (function() local ok,a=pcall(require,ReplicatedStorage.Controllers.AnimalOverheadController); return ok and a or nil end)()
local OverheadTemplate = (function() local o=ReplicatedStorage:FindFirstChild("Overheads"); return o and o:FindFirstChild("AnimalOverhead") end)()
local Trove = (function() local ok,t=pcall(require,ReplicatedStorage.Packages.Trove); return ok and t or nil end)()
local GradientEffects = {}
local function loadGradientEffects()
    pcall(function()
        local pk = ReplicatedStorage:FindFirstChild("Packages")
        local grad = pk and pk:FindFirstChild("Gradients")
        local eff = grad and grad:FindFirstChild("Effects")
        if eff then
            for _, m in ipairs(eff:GetChildren()) do
                local ok, mod = pcall(require, m)
                if ok and type(mod)=="table" and type(mod.simulate)=="function" then
                    GradientEffects[m.Name] = mod
                end
            end
        end
    end)
end
loadGradientEffects()
if not next(GradientEffects) then
    task.spawn(function()
        for _=1,10 do
            task.wait(1)
            loadGradientEffects()
            if next(GradientEffects) then break end
        end
    end)
end
local labelOverlay
local function applyGradient(label, presetName)
    if not Gradients or type(Gradients.apply)~="function" then return end
    pcall(function() Gradients.apply(label, presetName) end)
end
local MUTATION_GRADIENTS = { Crystal="Crystal", Phantom="Phantom", Rainbow="Rainbow", Christmas="SlowGreenRed" }
local MUTATION_BOLD = { Phantom=true }
local NumberUtils = (function() local ok,n=pcall(require,ReplicatedStorage.Utils.NumberUtils); return ok and n or nil end)()
local BrainrotCard = (function() local ok,b=pcall(require,ReplicatedStorage.Shared.BrainrotCard); return ok and b or nil end)()
local TraitsData = (function() local ok,t=pcall(require,ReplicatedStorage.Datas.Traits); return ok and t or {} end)()
local MutationsData = (function() local ok,m=pcall(require,ReplicatedStorage.Datas.Mutations); return ok and m or {} end)()
local function resolveDisplayName(index, traits)
    local info = Animals and Animals[index]
    local name = (info and info.DisplayName) or index
    if traits then
        for _, tr in ipairs(traits) do
            local td = TraitsData[tr]
            if td and td.OverheadDisplayName then
                local ok, res = pcall(td.OverheadDisplayName, name)
                if ok and type(res)=="string" then name = res end
            end
        end
    end
    return name
end
local OverheadTemplate = (function()
    local ov=ReplicatedStorage:FindFirstChild("Overheads")
    ov=ov and ov:FindFirstChild("AnimalOverhead")
    return ov
end)()
local function cloneLiveModel(index, uuid, plotInst)
    if not plotInst then return nil end
    for _,m in ipairs(plotInst:GetChildren()) do
        if m:IsA("Model") and m.Name==index then
            if not uuid or m:GetAttribute("UUID")==uuid or m:GetAttribute("Uuid")==uuid then
                local ok,cl=pcall(function() return m:Clone() end)
                if ok then return cl end
            end
        end
    end
    local m=plotInst:FindFirstChild(index)
    if m and m:IsA("Model") then local ok,cl=pcall(function() return m:Clone() end); if ok then return cl end end
    return nil
end
local function plotChannelForOwner(ownerName)
    local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
    for _,plot in ipairs(plots:GetChildren()) do
        local ok,data=pcall(function() return Synchronizer:GetTableFromChannel(plot.Name) end)
        if ok and type(data)=="table" and data.Owner then
            local on=(typeof(data.Owner)=="Instance" and data.Owner.Name) or tostring(data.Owner)
            if on==ownerName then return plot.Name, data end
        end
    end
    return nil
end
local function readBaseSlots(ownerName)
    local chan, data = plotChannelForOwner(ownerName)
    if not chan then return nil end
    local plots=workspace:FindFirstChild("Plots")
    local plotInst=plots and plots:FindFirstChild(chan)
    if not plotInst then
        local list={}
        if data and type(data.AnimalList)=="table" then
            for i,a in ipairs(data.AnimalList) do
                local info=Animals[a.Index]
                list[#list+1]={slot=i, floor=1, index=a.Index, mutation=(a.Mutation and a.Mutation~="None") and a.Mutation or nil,
                    traits=a.Traits, uuid=a.UUID,
                    gen=genOf(a), rarity=info and tostring(info.Rarity) or "?"}
            end
        end
        return list, false
    end
    local podiums=plotInst:FindFirstChild("AnimalPodiums")
    local slotPos={}
    if podiums then
        for _,pod in ipairs(podiums:GetChildren()) do
            local base=pod:FindFirstChild("Base")
            local pp = base and (base:IsA("Model") and base.PrimaryPart or base:FindFirstChildWhichIsA("BasePart",true))
            if pp then slotPos[pod.Name]=pp.Position end
        end
    end
    local function floorOfY(y)
        if y <= -13 then return 1 elseif y <= -8 then return 2 else return 3 end
    end
    local floorsPresent={}
    for _,pos in pairs(slotPos) do floorsPresent[floorOfY(pos.Y)]=true end
    local slots={}
    for _,m in ipairs(plotInst:GetChildren()) do
        if m:IsA("Model") and Animals[m.Name] then
            local pp=m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
            if pp then
                local bestSlot,bestPos,bestD=nil,nil,math.huge
                for sn,pos in pairs(slotPos) do
                    local d=(pos-pp.Position).Magnitude
                    if d<bestD then bestD=d; bestSlot=sn; bestPos=pos end
                end
                local mut=m:GetAttribute("Mutation") or m:GetAttribute("__mutation")
                local info=Animals[m.Name]
                local traitList=nil
                local tf=m:FindFirstChild("Traits")
                if tf then traitList={}; for _,tc in ipairs(tf:GetChildren()) do traitList[#traitList+1]=tc.Name end end
                slots[#slots+1]={slot=tonumber(bestSlot) or 999, floor=bestPos and floorOfY(bestPos.Y) or 1,
                    index=m.Name, mutation=(mut and mut~="None") and mut or nil, traits=traitList,
                    uuid=m:GetAttribute("UUID") or m:GetAttribute("Uuid"),
                    gen=info and info.Generation or 0, rarity=info and tostring(info.Rarity) or "?"}
            end
        end
    end
    table.sort(slots,function(a,b) return a.slot<b.slot end)
    return slots, true, floorsPresent
end
local function collectBrainrots()
    local result={}; local plots=workspace:FindFirstChild("Plots"); if not plots then return result end
    for _,plot in ipairs(plots:GetChildren()) do
        local ok,data=pcall(function() return Synchronizer:GetTableFromChannel(plot.Name) end)
        if ok and type(data)=="table" and type(data.AnimalList)=="table" then
            local owner=data.Owner; local on=(typeof(owner)=="Instance" and owner.Name) or tostring(owner)
            if on~=LocalPlayer.Name and on~=LocalPlayer.DisplayName then
                for _,a in ipairs(data.AnimalList) do
                    local info=Animals[a.Index]
                    if info and SHOW_RARITIES[tostring(info.Rarity)] then
                        result[#result+1]={player=on,
                            playerObj=(typeof(owner)=="Instance" and owner) or Players:FindFirstChild(on),
                            index=a.Index, mutation=(a.Mutation and a.Mutation~="None") and a.Mutation or nil,
                            gen=genOf(a), uuid=a.UUID, rarity=tostring(info.Rarity)}
                    end
                end
            end
        end
    end
    table.sort(result,function(a,b) return a.gen>b.gen end)
    return result
end
local function collectByPlayer()
    local flat=collectBrainrots()
    local byPlayer={}
    for _,b in ipairs(flat) do
        local p=byPlayer[b.player]
        if not p then p={player=b.player, playerObj=b.playerObj, items={}, topGen=0, totalGen=0}; byPlayer[b.player]=p end
        p.items[#p.items+1]=b
        if b.gen>p.topGen then p.topGen=b.gen end
        p.totalGen=p.totalGen+b.gen
    end
    local list={}
    for _,p in pairs(byPlayer) do
        table.sort(p.items,function(a,b) return a.gen>b.gen end)
        list[#list+1]=p
    end
    table.sort(list,function(a,b) return a.totalGen>b.totalGen end)
    return list
end
local function stripRich(t) return (tostring(t):gsub("<[^>]+>","")) end
local function watchNotification(window, callback)
    local pg=LocalPlayer:FindFirstChild("PlayerGui")
    local notif=pg and pg:FindFirstChild("Notification")
    local container=notif and notif:FindFirstChild("Notification")
    if not container then callback(nil); return end
    local done=false
    local conn
    local function consider(ch)
        if done or not ch:IsA("TextLabel") then return end
        local raw=ch.Text
        if type(raw)~="string" then return end
        local t=stripRich(raw)
        if #t>1 and t~="NOTIFICATION TEMPLATE" then
            done=true; if conn then conn:Disconnect() end
            callback(t)
        end
    end
    conn=container.ChildAdded:Connect(function(ch) task.wait(0.05); consider(ch) end)
    task.delay(window, function()
        if not done then done=true; if conn then conn:Disconnect() end; callback(nil) end
    end)
end
local function getTradePrompt(ownerName)
    local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
    for _,plot in ipairs(plots:GetChildren()) do
        local ok,data=pcall(function() return Synchronizer:GetTableFromChannel(plot.Name) end)
        if ok and type(data)=="table" and data.Owner then
            local on=(typeof(data.Owner)=="Instance" and data.Owner.Name) or tostring(data.Owner)
            if on==ownerName then
                for _,pp in ipairs(plot:GetDescendants()) do
                    if pp:IsA("ProximityPrompt") and pp.ActionText=="SEND TRADE" then return pp end
                end
            end
        end
    end
    return nil
end
local function sendTradeInvite(p, onResult)
    onResult = onResult or function() end
    local name = (typeof(p)=="Instance" and p.Name) or (type(p)=="table" and p.Name) or tostring(p)
    local prompt = getTradePrompt(name)
    if not prompt then return onResult("error", "not in server") end
    if not prompt.Enabled then return onResult("error", "unavailable") end
    if type(fireproximityprompt) ~= "function" then return onResult("no_remote", "executor missing fireproximityprompt") end
    local ok = pcall(function() fireproximityprompt(prompt) end)
    if not ok then return onResult("error", "failed") end
    local reported=false
    watchNotification(1.5, function(notifText)
        if reported then return end; reported=true
        if not notifText then return onResult("sent", nil) end
        local low = notifText:lower()
        if low:find("request sent") or low:find("sent to") or low:find("trade request") then
            onResult("sent", nil)
        else
            onResult("error", notifText)
        end
    end)
end
local function sendChatMessage(text)
    if not text or text=="" then return false end
    local pg=LocalPlayer:FindFirstChild("PlayerGui"); if not pg then return false end
    local tlt=pg:FindFirstChild("TradeLiveTrade"); local inner=tlt and tlt:FindFirstChild("TradeLiveTrade")
    local chat=inner and inner:FindFirstChild("Chat")
    local tb
    for _,sub in ipairs({"NormalChat","RestrictedChat"}) do
        local nc=chat and chat:FindFirstChild(sub)
        local box=nc and nc:FindFirstChild("ChatBox")
        local t=box and box:FindFirstChildWhichIsA("TextBox")
        if t then tb=t; break end
    end
    if not tb then return false end
    local ok=pcall(function()
        tb.Text = text
        if type(firesignal)=="function" then
            firesignal(tb.FocusLost, true, Enum.KeyCode.Return)
        else
            tb:CaptureFocus()
            local VIM=game:GetService("VirtualInputManager")
            VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end
    end)
    return ok
end
local function translateDirect(text,toLang,fromLang)
    if not text or text=="" or not httprequest then return text end
    fromLang=fromLang or "auto"
    local url=("https://clients5.google.com/translate_a/t?client=dict-chrome-ex&sl=%s&tl=%s&q=%s")
        :format(fromLang,toLang,HttpService:UrlEncode(text))
    local ok,res=pcall(function() return httprequest({Url=url,Method="GET",Headers={["User-Agent"]="Mozilla/5.0"}}) end)
    if not ok or not res then return text end
    local body=res.Body or res.body
    if not body then return text end
    local ok2,dec=pcall(function() return HttpService:JSONDecode(body) end)
    if not ok2 or type(dec)~="table" then return text end
    local first=dec[1]
    if type(first)=="table" then
        return (type(first[1])=="string" and first[1]~="" and first[1] or text), (type(first[2])=="string" and first[2] or fromLang)
    elseif type(first)=="string" then return first, fromLang end
    return text, fromLang
end
local function translateVia(text, toLang, fromLang, romanize)
    if not text or text=="" or not httprequest then return text, fromLang end
    fromLang = fromLang or "auto"
    if not TRANSLATE_ENDPOINT or TRANSLATE_ENDPOINT=="" or TRANSLATE_ENDPOINT:find("YOUR%-WORKER") or TRANSLATE_ENDPOINT:find("YOUR%-PROJECT") then
        return translateDirect(text, toLang, fromLang)
    end
    local base=TRANSLATE_ENDPOINT:gsub("/+$","")
    local payload=HttpService:JSONEncode({q=text, sl=fromLang, tl=toLang, rm=romanize and "1" or "0"})
    local ok,res=pcall(function() return httprequest({
        Url=base, Method="POST",
        Headers={["Content-Type"]="application/json"},
        Body=payload,
    }) end)
    if not ok or not res then return translateDirect(text, toLang, fromLang) end
    local body=res.Body or res.body
    if not body then return translateDirect(text, toLang, fromLang) end
    local ok2,dec=pcall(function() return HttpService:JSONDecode(body) end)
    if not ok2 or type(dec)~="table" or not dec.t then return translateDirect(text, toLang, fromLang) end
    return dec.t, (dec.d or fromLang)
end
local function translate(text,toLang,fromLang)
    return translateVia(text, toLang, fromLang, false)
end
local function translateRomanized(text,toLang,fromLang)
    local out = translateVia(text, toLang, fromLang, true)
    return out
end
local function round(o,r) local c=Instance.new("UICorner",o); c.CornerRadius=UDim.new(0,r or 8); return c end
local function strk(o,col,th,tr) local s=Instance.new("UIStroke",o); s.Color=col or C.STROKE; s.Thickness=th or 1; s.Transparency=tr or 0.4; return s end
local function tw(o,t,p) TweenService:Create(o,TweenInfo.new(t or 0.14,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p):Play() end
local function shadow(parent)
    local s=Instance.new("ImageLabel",parent); s.AnchorPoint=Vector2.new(0.5,0.5); s.Position=UDim2.new(0.5,0,0.5,2)
    s.Size=UDim2.new(1,26,1,26); s.BackgroundTransparency=1; s.Image="rbxassetid://6014261993"
    s.ImageColor3=Color3.new(0,0,0); s.ImageTransparency=0.72; s.ScaleType=Enum.ScaleType.Slice
    s.SliceCenter=Rect.new(49,49,450,450); s.ZIndex=0; return s
end
local function makeBtn(parent, text, opts)
    opts = opts or {}
    local base = opts.color or C.ACCENT2
    local pressCol = opts.press or C.ACCENT
    local strokeCol = opts.stroke or C.ACCENT
    local b = Instance.new("TextButton", parent)
    b.AutoButtonColor=false; b.BackgroundColor3=base; b.BorderSizePixel=0
    b.Text=text; b.Font=Enum.Font.FredokaOne; b.TextSize=opts.textSize or 11; b.TextColor3=C.TEXT
    round(b, opts.radius or 8)
    local s = strk(b, strokeCol, 1, opts.strokeT or 0.35)
    b.MouseButton1Down:Connect(function() tw(b,0.08,{BackgroundColor3=pressCol}) end)
    b.MouseButton1Up:Connect(function() tw(b,0.14,{BackgroundColor3=base}) end)
    return b, s
end
local hui=gethui()
local function showToast(title, text, holdTime)
    if setthreadidentity then pcall(setthreadidentity, 8) end
    pcall(function()
        local existing = hui:FindFirstChild("SlcConvToast")
        if existing then existing:Destroy() end
        local sg=Instance.new("ScreenGui"); sg.Name="SlcConvToast"; sg.ResetOnSpawn=false; sg.DisplayOrder=1000000; sg.Parent=hui
        local f=Instance.new("Frame",sg); f.Size=UDim2.new(0,300,0,56); f.Position=UDim2.new(0.5,-150,0,80)
        f.BackgroundColor3=Color3.fromRGB(8,22,15); f.BackgroundTransparency=1; f.BorderSizePixel=0
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,9)
        local stroke=Instance.new("UIStroke",f); stroke.Thickness=1; stroke.Color=C.ACCENT; stroke.Transparency=1
        local bar=Instance.new("Frame",f); bar.Size=UDim2.new(0,3,1,-12); bar.Position=UDim2.new(0,5,0,6)
        bar.BackgroundColor3=C.ACCENT; bar.BorderSizePixel=0; bar.BackgroundTransparency=1
        Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
        local t1=Instance.new("TextLabel",f); t1.Size=UDim2.new(1,-22,0,18); t1.Position=UDim2.new(0,16,0,8)
        t1.BackgroundTransparency=1; t1.Text=tostring(title):upper(); t1.Font=Enum.Font.FredokaOne; t1.TextSize=12
        t1.TextColor3=C.ACCENT; t1.TextXAlignment=Enum.TextXAlignment.Left; t1.TextTransparency=1
        local t2=Instance.new("TextLabel",f); t2.Size=UDim2.new(1,-22,0,16); t2.Position=UDim2.new(0,16,0,29)
        t2.BackgroundTransparency=1; t2.Text=tostring(text); t2.Font=Enum.Font.GothamMedium; t2.TextSize=11
        t2.TextColor3=C.DIM; t2.TextXAlignment=Enum.TextXAlignment.Left; t2.TextTransparency=1
        local fi=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
        TweenService:Create(f,fi,{BackgroundTransparency=0.05}):Play()
        TweenService:Create(stroke,fi,{Transparency=0.3}):Play()
        TweenService:Create(bar,fi,{BackgroundTransparency=0}):Play()
        TweenService:Create(t1,fi,{TextTransparency=0}):Play()
        TweenService:Create(t2,fi,{TextTransparency=0}):Play()
        task.delay(holdTime or 2.5, function()
            if not sg.Parent then return end
            local fo=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
            TweenService:Create(f,fo,{BackgroundTransparency=1}):Play()
            TweenService:Create(stroke,fo,{Transparency=1}):Play()
            TweenService:Create(bar,fo,{BackgroundTransparency=1}):Play()
            TweenService:Create(t1,fo,{TextTransparency=1}):Play()
            local last=TweenService:Create(t2,fo,{TextTransparency=1}); last:Play(); last.Completed:Wait()
            if sg.Parent then sg:Destroy() end
        end)
    end)
end
local function playAlertSound()
    if not Config.alertSound then return end
    pcall(function()
        local s=Instance.new("Sound"); s.SoundId=Config.alertSoundId or "rbxassetid://6518811702"
        s.Volume=0.5; s.Parent=hui; s:Play()
        game:GetService("Debris"):AddItem(s,4)
    end)
end
local function scanForPriority()
    if not Config.priorityList or #Config.priorityList==0 then return nil end
    local want={}
    for _,n in ipairs(Config.priorityList) do want[tostring(n):lower()]=true end
    local plots=workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _,plot in ipairs(plots:GetChildren()) do
        local ok,data=pcall(function() return Synchronizer:GetTableFromChannel(plot.Name) end)
        if ok and type(data)=="table" and type(data.AnimalList)=="table" then
            for _,e in ipairs(data.AnimalList) do
                if type(e)=="table" and e.Index and e.Index~="Empty" then
                    if want[tostring(e.Index):lower()] then
                        local owner=(typeof(data.Owner)=="Instance" and data.Owner.Name) or tostring(data.Owner)
                        return owner, e.Index
                    end
                end
            end
        end
    end
    return nil
end
local ServerData_ = (function() local ok,s=pcall(require,ReplicatedStorage.Datas.ServerData); return ok and s or nil end)()
local function tierPlaceId(tier)
    if not ServerData_ then return game.PlaceId end
    if tier=="Pro" then return ServerData_.TradePlazaProPlaceId
    elseif tier=="OG" then return ServerData_.TradePlazaOgPlaceId
    else return ServerData_.TradePlazaPlaceId end
end
local function readBrowserServers()
    local list={}
    local pg=LocalPlayer:FindFirstChild("PlayerGui")
    local browser=pg and pg:FindFirstChild("TradePlazaServerBrowser")
    local rows=browser and browser:FindFirstChild("List", true)
    if not rows then return list end
    for _,row in ipairs(rows:GetChildren()) do
        if row:IsA("GuiObject") and #row.Name>=30 then
            local jid=row.Name
            local onCd = HopData.hoppedServers[jid] and (os.time()-HopData.hoppedServers[jid] < 600)
            if jid~=tostring(game.JobId) and not onCd then
                local playersTxt = row:FindFirstChild("Bottom") and row.Bottom:FindFirstChild("Players") and row.Bottom.Players.Text
                local cur, mx = 0, 28
                if playersTxt then cur = tonumber(playersTxt:match("(%d+)")) or 0; mx = tonumber(playersTxt:match("/(%d+)")) or 28 end
                list[#list+1] = { jobId=jid, players=cur, maxPlayers=mx }
            end
        end
    end
    return list
end
local function serverHop(tier)
    tier = tier or Config.hopTier or "Normal"
    local placeId = tierPlaceId(tier)
    if not placeId or placeId==0 then showToast("HOP FAILED", tier.." tier unavailable"); return false end
    pcall(function() HopData.hoppedServers[tostring(game.JobId)] = os.time() end)
    saveHops()
    local TeleportService = game:GetService("TeleportService")
    local servers = readBrowserServers()
    if #servers > 0 then
        table.sort(servers, function(a,b) return a.players < b.players end)
        for _,s in ipairs(servers) do
            if s.players < s.maxPlayers then
                showToast("HOPPING", "joining a new server...", 3)
                local ok = pcall(function() TeleportService:TeleportToPlaceInstance(placeId, s.jobId, LocalPlayer) end)
                if ok then return true end
                HopData.hoppedServers[s.jobId]=os.time()
            end
        end
        saveHops()
    end
    showToast("HOPPING", "joining a new "..tier.." server...", 3)
    local ok, err = pcall(function() TeleportService:Teleport(placeId, LocalPlayer) end)
    if not ok then showToast("HOP FAILED", tostring(err):sub(1,40)); return false end
    return true
end
local refreshBeamRows
local _beamState = { owner=nil, hl=nil, beam=nil, att0=nil, att1=nil, conn=nil }
local function clearBeam()
    if _beamState.conn then _beamState.conn:Disconnect(); _beamState.conn=nil end
    for _,k in ipairs({"hl","beam","att0","att1"}) do
        if _beamState[k] then pcall(function() _beamState[k]:Destroy() end); _beamState[k]=nil end
    end
    _beamState.owner=nil
end
local function beamToTraderBase(ownerName)
    if not Config.beamToBase then showToast("BEAM","enable Beam to base in settings"); return false end
    if _beamState.owner==ownerName then clearBeam(); return false end
    clearBeam()
    local chan = plotChannelForOwner and plotChannelForOwner(ownerName)
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and chan and plots:FindFirstChild(chan)
    if not plot then showToast("BEAM", "base not in this server"); return false end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    if setthreadidentity then pcall(setthreadidentity, 8) end
    _beamState.owner=ownerName
    local hl=Instance.new("Highlight"); hl.FillColor=C.ACCENT; hl.FillTransparency=0.85
    hl.OutlineColor=C.ACCENT; hl.OutlineTransparency=0.15; hl.Adornee=plot; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent=plot; _beamState.hl=hl
    local plotSpawn = plot:FindFirstChild("Spawn") or plot:FindFirstChildWhichIsA("BasePart", true)
    if plotSpawn then
        local att0=Instance.new("Attachment"); att0.Parent=plotSpawn; att0.WorldPosition=plotSpawn.Position+Vector3.new(0,4,0)
        local att1=Instance.new("Attachment"); att1.Parent=hrp
        local beam=Instance.new("Beam"); beam.Attachment0=att0; beam.Attachment1=att1
        beam.Color=ColorSequence.new(C.ACCENT)
        beam.Width0=1.4; beam.Width1=0.7; beam.FaceCamera=true; beam.LightEmission=1
        beam.Transparency=NumberSequence.new(0.15)
        beam.Parent=att0
        _beamState.att0=att0; _beamState.att1=att1; _beamState.beam=beam
    end
    _beamState.conn = plot.AncestryChanged:Connect(function()
        if not plot:IsDescendantOf(workspace) then clearBeam(); if refreshBeamRows then refreshBeamRows() end end
    end)
    showToast("BEAM", "tracking "..ownerName.."'s base", 2)
    return true
end
pcall(function() local o=hui:FindFirstChild("IdontlogConvincer"); if o then o:Destroy() end end)
pcall(function() local pg=game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui"); local o=pg and pg:FindFirstChild("IdontlogConvincerBase"); if o then o:Destroy() end end)
local screen=Instance.new("ScreenGui"); screen.Name="IdontlogConvincer"; screen.ResetOnSpawn=false
screen.IgnoreGuiInset=true; screen.DisplayOrder=999999; screen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; screen.Parent=hui
local frame=Instance.new("Frame",screen)
frame.Size=UDim2.fromOffset(370,510); frame.Position=UDim2.new(Config.pos.x,0,Config.pos.y,0)
applyUIScale(frame)
frame.BackgroundColor3=C.BG; frame.BorderSizePixel=0
round(frame,16); strk(frame,C.STROKE,1.4,0.38); shadow(frame)
do
    local g=Instance.new("UIGradient",frame)
    g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(15,40,28)),ColorSequenceKeypoint.new(1,Color3.fromRGB(7,20,14))})
    g.Rotation=90
end
local header, dot, tl, pages, currentTab, selectTab, makeTab, tabButtons
do
header=Instance.new("Frame",frame); header.Size=UDim2.new(1,0,0,48); header.BackgroundTransparency=1; header.ZIndex=2
dot=Instance.new("Frame",header); dot.Size=UDim2.fromOffset(8,8); dot.Position=UDim2.fromOffset(16,20)
dot.BackgroundTransparency=1; dot.BorderSizePixel=0; dot.ZIndex=2; dot.Size=UDim2.fromOffset(20,20); dot.Position=UDim2.fromOffset(12,14)
do local tree=Instance.new("TextLabel",dot); tree.Size=UDim2.fromScale(1,1); tree.BackgroundTransparency=1; tree.Text="🎄"; tree.TextSize=18; tree.ZIndex=2 end
local title=Instance.new("TextLabel",header); title.Size=UDim2.new(1,-40,0,26); title.Position=UDim2.fromOffset(36,12)
title.BackgroundTransparency=1; title.Font=Enum.Font.FredokaOne; title.Text="IDONTLOG CONVINCER"; title.TextSize=17
title.TextColor3=C.TEXT; title.TextXAlignment=Enum.TextXAlignment.Left; title.ZIndex=2; _G.CVN_xmasTitle(title)
local titleLine=Instance.new("Frame",header); titleLine.Position=UDim2.fromOffset(32,40); titleLine.Size=UDim2.fromOffset(150,2)
titleLine.BackgroundColor3=Color3.new(1,1,1); titleLine.BorderSizePixel=0; titleLine.ZIndex=2; round(titleLine,1); _G.CVN_X.grad(titleLine,_G.CVN_X.SHINE,"sweep",1,0)
do
    local dragging,si,sp
    header.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true; si=i.Position; sp=frame.Position
        i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false
            Config.pos={x=frame.Position.X.Scale,y=frame.Position.Y.Scale}; saveConfig() end end)
    end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-si; frame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y) end end)
end
local tabBar=Instance.new("Frame",frame); tabBar.Size=UDim2.new(1,-24,0,36); tabBar.Position=UDim2.fromOffset(12,54)
tabBar.BackgroundColor3=C.SURF; tabBar.BorderSizePixel=0; tabBar.ZIndex=2; round(tabBar,10); strk(tabBar,C.STROKE,1,0.55)
tl=Instance.new("UIListLayout",tabBar); tl.FillDirection=Enum.FillDirection.Horizontal; tl.SortOrder=Enum.SortOrder.LayoutOrder
local tp=Instance.new("UIPadding",tabBar); tp.PaddingLeft=UDim.new(0,4); tp.PaddingRight=UDim.new(0,4); tp.PaddingTop=UDim.new(0,4); tp.PaddingBottom=UDim.new(0,4)
pages,tabButtons={},{}
currentTab="list"
function selectTab(name)
    currentTab=name
    for n,pg in pairs(pages) do pg.Visible=(n==name) end
    for n,b in pairs(tabButtons) do
        tw(b,0.14,{BackgroundColor3=(n==name) and C.ACCENT2 or C.SURF})
        b.TextColor3=(n==name) and C.TEXT or C.OFF_TEXT
    end
end
function makeTab(name,label,order)
    local b=Instance.new("TextButton",tabBar); b.Size=UDim2.new(1/4,-3,1,0); b.LayoutOrder=order
    b.AutoButtonColor=false; b.BackgroundColor3=C.SURF; b.Text=label; b.Font=Enum.Font.FredokaOne
    b.TextSize=10; b.TextColor3=C.OFF_TEXT; b.ZIndex=3; round(b,8)
    b.MouseButton1Click:Connect(function() selectTab(name) end)
    tabButtons[name]=b
end
makeTab("list","TRADE",1); makeTab("chat","TRANSLATE",2); makeTab("presets","PRESETS",3); makeTab("settings","SETTINGS",4)
end
local body=Instance.new("Frame",frame); body.Size=UDim2.new(1,-24,1,-126); body.Position=UDim2.fromOffset(12,98)
do
    local footer=Instance.new("TextLabel",frame); footer.Name="IdontlogSig"
    footer.AnchorPoint=Vector2.new(0.5,1); footer.Position=UDim2.new(0.5,0,1,-7)
    footer.Size=UDim2.new(1,-24,0,22); footer.BackgroundTransparency=1
    footer.Font=Enum.Font.FredokaOne; footer.Text="discord.gg/xpubmethod"; footer.TextSize=17
    footer.TextColor3=Color3.new(1,1,1); footer.ZIndex=3
    footer.TextStrokeColor3=Color3.fromRGB(8,32,18); footer.TextStrokeTransparency=0.35
    local sigGrad=Instance.new("UIGradient",footer); sigGrad.Rotation=0
    sigGrad.Color=_G.CVN_X.SHINE
    task.spawn(function()
        local t0=tick()
        while footer and footer.Parent and alive() do
            local t=tick()-t0
            sigGrad.Offset=Vector2.new(((t*0.45)%2)-1, 0)
            task.wait()
        end
    end)
end
body.BackgroundTransparency=1; body.ZIndex=2
local listPage=Instance.new("Frame",body); listPage.Size=UDim2.fromScale(1,1); listPage.BackgroundTransparency=1; pages.list=listPage
local countLbl=Instance.new("TextLabel",listPage); countLbl.Visible=false; countLbl.Text="0"
local searchBox=Instance.new("TextBox",listPage); searchBox.Size=UDim2.new(1,0,0,30); searchBox.Position=UDim2.fromOffset(0,0)
searchBox.BackgroundColor3=C.SURF; searchBox.Text=""; searchBox.PlaceholderText="search player or brainrot…"
searchBox.PlaceholderColor3=C.OFF_TEXT; searchBox.Font=Enum.Font.GothamMedium; searchBox.TextSize=12; searchBox.TextColor3=C.TEXT
searchBox.TextXAlignment=Enum.TextXAlignment.Left; searchBox.ClearTextOnFocus=false; searchBox.ZIndex=3
round(searchBox,9); strk(searchBox,C.STROKE,1,0.5)
local sbPad=Instance.new("UIPadding",searchBox); sbPad.PaddingLeft=UDim.new(0,10); sbPad.PaddingRight=UDim.new(0,30)
local sbIcon=Instance.new("ImageLabel",searchBox); sbIcon.Size=UDim2.fromOffset(15,15); sbIcon.Position=UDim2.new(1,-24,0.5,-7)
sbIcon.BackgroundTransparency=1; sbIcon.Image="rbxassetid://3926305904"; sbIcon.ImageRectOffset=Vector2.new(964,324)
sbIcon.ImageRectSize=Vector2.new(36,36); sbIcon.ImageColor3=C.DIM; sbIcon.ZIndex=4
local _searchTerm=""
local scroll=Instance.new("ScrollingFrame",listPage); scroll.Size=UDim2.new(1,0,1,-38); scroll.Position=UDim2.fromOffset(0,38)
scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0; scroll.ScrollBarThickness=4; scroll.ScrollBarImageColor3=C.ACCENT
scroll.CanvasSize=UDim2.new(0,0,0,0); scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
local scrollPad=Instance.new("UIPadding",scroll); scrollPad.PaddingLeft=UDim.new(0,2); scrollPad.PaddingRight=UDim.new(0,8); scrollPad.PaddingTop=UDim.new(0,1)
local sL=Instance.new("UIListLayout",scroll); sL.Padding=UDim.new(0,7); sL.SortOrder=Enum.SortOrder.LayoutOrder
local function mutColor(mut)
    local m=Mutations[mut]
    if m and m.MainColor then local ok,c=pcall(function()
        local p={} for n in tostring(m.MainColor):gmatch("[%d%.]+") do p[#p+1]=tonumber(n) end
        if #p>=3 then return Color3.new(p[1],p[2],p[3]) end end); if ok and c then return c end end
    return C.DIM
end
local _lastKey=""
refreshBeamRows = function() _lastKey="" end
local function doTradeBtn(tb, player, playerObj)
    local _busy=false
    tb.MouseButton1Click:Connect(function()
        if _busy then return end
        _busy=true; tb.Text="..."; tw(tb,0.1,{BackgroundColor3=C.ACCENT2})
        task.spawn(function()
            local target = playerObj or Players:FindFirstChild(player)
            sendTradeInvite(target, function(status, msg)
                if setthreadidentity then pcall(setthreadidentity, 8) end
                local label,color
                if status=="sent" then label="SENT"; color=Color3.fromRGB(40,190,110)
                elseif status=="no_remote" then label="RETRY"; color=Color3.fromRGB(120,80,30)
                else label="FAILED"; color=Color3.fromRGB(120,40,40) end
                pcall(function() tb.Text=label; tw(tb,0.1,{BackgroundColor3=color}) end)
            end)
            task.delay(2.2,function() if tb.Parent and tb.Text~="GOT IT" then tb.Text="TRADE"; tw(tb,0.1,{BackgroundColor3=C.ACCENT}) end; _busy=false end)
        end)
    end)
end
local openBasePanel
local function buildList()
    local players=collectByPlayer()
    local term=(_searchTerm or ""):lower():gsub("^%s+",""):gsub("%s+$","")
    if term~="" then
        local filtered={}
        for _,p in ipairs(players) do
            local match=p.player:lower():find(term,1,true)~=nil
            if not match then
                for _,b in ipairs(p.items) do
                    if b.index:lower():find(term,1,true) or (b.mutation and b.mutation:lower():find(term,1,true)) or b.rarity:lower():find(term,1,true) then match=true; break end
                end
            end
            if match then filtered[#filtered+1]=p end
        end
        players=filtered
    end
    if setthreadidentity then pcall(setthreadidentity, 8) end
    local key=term.."~"
    for _,p in ipairs(players) do key=key..p.player..#p.items..math.floor(p.totalGen).."|" end
    if key==_lastKey then countLbl.Text=tostring(#players); return end
    _lastKey=key
    for _,ch in ipairs(scroll:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
    if #players==0 then
        local empty=Instance.new("Frame",scroll); empty.Size=UDim2.new(1,0,0,80); empty.BackgroundTransparency=1
        local el=Instance.new("TextLabel",empty); el.Size=UDim2.fromScale(1,1); el.BackgroundTransparency=1
        el.Font=Enum.Font.GothamMedium; el.TextSize=12; el.TextColor3=C.OFF_TEXT; el.TextWrapped=true
        el.Text = (term~="") and ("no matches for \""..term.."\"") or "no Secret/OG traders found.\nif this stays empty, your executor may not support reading game data."
        countLbl.Text="0"; return
    end
    local ITEM_H=48
    for pi,p in ipairs(players) do
        local container=Instance.new("Frame",scroll); container.Size=UDim2.new(1,0,0,54); container.BackgroundTransparency=1
        container.BorderSizePixel=0; container.LayoutOrder=pi; container.ClipsDescendants=true; container.Name="P_"..pi
        local prow=Instance.new("Frame",container); prow.Size=UDim2.new(1,-4,0,52); prow.Position=UDim2.fromOffset(2,1)
        prow.BackgroundColor3=C.SURF; prow.BorderSizePixel=0; round(prow,10); local prs=strk(prow,C.STROKE,1,0.6)
        local rank=Instance.new("TextLabel",prow); rank.Size=UDim2.fromOffset(20,54); rank.Position=UDim2.fromOffset(2,0)
        rank.BackgroundTransparency=1; rank.Font=Enum.Font.FredokaOne; rank.Text="#"..pi; rank.TextSize=10; rank.TextColor3=C.ACCENT
        local textX = 34
        if Config.showAvatars then
            local av=Instance.new("ImageLabel",prow); av.Size=UDim2.fromOffset(36,36); av.Position=UDim2.fromOffset(24,8)
            av.BackgroundColor3=C.SURF2; av.BorderSizePixel=0; round(av,18); av.ZIndex=3
            task.spawn(function()
                local uid
                if p.playerObj and p.playerObj.UserId then uid=p.playerObj.UserId
                else pcall(function() uid=Players:GetUserIdFromNameAsync(p.player) end) end
                if uid then
                    local ok,url=pcall(function()
                        return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                    end)
                    if ok and url and av.Parent then av.Image=url end
                end
            end)
            textX = 66
        end
        local nameL=Instance.new("TextLabel",prow); nameL.Size=UDim2.new(1,-(textX+116),0,18); nameL.Position=UDim2.fromOffset(textX,8)
        nameL.BackgroundTransparency=1; nameL.Font=Enum.Font.FredokaOne; nameL.Text=p.player; nameL.TextSize=13; nameL.TextColor3=C.TEXT
        nameL.TextXAlignment=Enum.TextXAlignment.Left; nameL.TextTruncate=Enum.TextTruncate.AtEnd
        local selectBtn=Instance.new("TextButton",prow); selectBtn.Size=UDim2.new(1,-118,1,0); selectBtn.Position=UDim2.fromOffset(0,0)
        selectBtn.BackgroundTransparency=1; selectBtn.Text=""; selectBtn.ZIndex=1; selectBtn.AutoButtonColor=false
        local function applySel(on)
            if prs then tw(prs,0.15,{Transparency=on and 0.15 or 0.6, Color=on and C.ACCENT or C.STROKE}) end
        end
        applySel(_beamState and _beamState.owner==p.player)
        selectBtn.MouseButton1Click:Connect(function()
            local selected = beamToTraderBase and beamToTraderBase(p.player)
            applySel(selected)
        end)
        local subL=Instance.new("TextLabel",prow); subL.Size=UDim2.new(1,-(textX+116),0,14); subL.Position=UDim2.fromOffset(textX,29)
        subL.BackgroundTransparency=1; subL.Font=Enum.Font.FredokaOne; subL.Text=(#p.items).." • total $"..fmtGen(p.totalGen).."/s"
        subL.TextSize=10; subL.TextColor3=C.GREEN_STROKE; subL.TextXAlignment=Enum.TextXAlignment.Left
        local tb=makeBtn(prow,"TRADE",{textSize=11}); tb.Size=UDim2.fromOffset(62,34); tb.Position=UDim2.new(1,-114,0.5,-17)
        doTradeBtn(tb, p.player, p.playerObj)
        local arrowBtn=makeBtn(prow,"v",{color=C.SURF2,press=C.ACCENT2,stroke=C.STROKE,strokeT=0.5,textSize=13})
        arrowBtn.Size=UDim2.fromOffset(40,34); arrowBtn.Position=UDim2.new(1,-46,0.5,-17)
        local content=Instance.new("Frame",container); content.Size=UDim2.new(1,0,0,0); content.Position=UDim2.fromOffset(0,54)
        content.BackgroundTransparency=1; content.BorderSizePixel=0; content.ClipsDescendants=true
        local clist=Instance.new("UIListLayout",content); clist.Padding=UDim.new(0,6); clist.SortOrder=Enum.SortOrder.LayoutOrder
        local cpad=Instance.new("UIPadding",content); cpad.PaddingTop=UDim.new(0,6); cpad.PaddingLeft=UDim.new(0,16); cpad.PaddingRight=UDim.new(0,2)
        for ii,b in ipairs(p.items) do
            local irow=Instance.new("Frame",content); irow.Size=UDim2.new(1,0,0,42); irow.LayoutOrder=ii
            irow.BackgroundColor3=C.SURF2; irow.BorderSizePixel=0; round(irow,8); strk(irow,C.STROKE,1,0.7)
            local inm=Instance.new("TextLabel",irow); inm.Size=UDim2.new(1,-14,0,18); inm.Position=UDim2.fromOffset(10,4)
            inm.BackgroundTransparency=1; inm.Font=Enum.Font.FredokaOne; inm.RichText=true
            local mtag=b.mutation and ('  <font color="#%s">%s</font>'):format(mutColor(b.mutation):ToHex(),b.mutation) or ""
            inm.Text=b.index..mtag; inm.TextSize=12; inm.TextColor3=C.TEXT
            inm.TextXAlignment=Enum.TextXAlignment.Left; inm.TextTruncate=Enum.TextTruncate.AtEnd
            local isub=Instance.new("TextLabel",irow); isub.Size=UDim2.new(1,-14,0,14); isub.Position=UDim2.fromOffset(10,23)
            isub.BackgroundTransparency=1; isub.Font=Enum.Font.FredokaOne; isub.Text="$"..fmtGen(b.gen).."/s  •  "..b.rarity
            isub.TextSize=10; isub.TextColor3=C.GREEN_STROKE; isub.TextXAlignment=Enum.TextXAlignment.Left
        end
        local fullH = #p.items*(42+6) + 6 + 6
        local expanded=false
        local function setExpanded(on, instant)
            expanded=on
            arrowBtn.Text = on and "^" or "v"
            local targetContent = on and fullH or 0
            local targetContainer = 54 + targetContent
            if instant then
                content.Size=UDim2.new(1,0,0,targetContent); container.Size=UDim2.new(1,0,0,targetContainer); return
            end
            TweenService:Create(content, TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,0,targetContent)}):Play()
            TweenService:Create(container, TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,0,targetContainer)}):Play()
        end
        arrowBtn.MouseButton1Click:Connect(function() setExpanded(not expanded) end)
        prow.MouseEnter:Connect(function() tw(prow,0.12,{BackgroundColor3=Color3.fromRGB(16,44,30)}) end)
        prow.MouseLeave:Connect(function() tw(prow,0.12,{BackgroundColor3=C.SURF}) end)
    end
    countLbl.Text=tostring(#players)
end
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    _searchTerm=searchBox.Text
    _lastKey=""
    pcall(buildList)
end)
task.spawn(function() while screen.Parent and alive() do pcall(buildList); task.wait(2) end end)
local theirLbl, _feedOrder, _msgHighestIdx, _resetLangVotes, clearFeed, addFeedMsg, replyBox, previewBox, pvTag, pvPlaceholder, _translatedOut
do
local chatPage=Instance.new("Frame",body); chatPage.Size=UDim2.fromScale(1,1); chatPage.BackgroundTransparency=1; chatPage.Visible=false; pages.chat=chatPage
local topRow=Instance.new("Frame",chatPage); topRow.Size=UDim2.new(1,0,0,44); topRow.BackgroundTransparency=1; topRow.ZIndex=5
local myCard=Instance.new("TextButton",topRow); myCard.Size=UDim2.new(0.5,-5,1,0); myCard.AutoButtonColor=false
myCard.BackgroundColor3=C.SURF2; myCard.Text=""; myCard.ZIndex=6; round(myCard,10); local myCardS=strk(myCard,C.STROKE,1,0.5)
local myCaption=Instance.new("TextLabel",myCard); myCaption.Size=UDim2.new(1,-16,0,14); myCaption.Position=UDim2.fromOffset(12,6)
myCaption.BackgroundTransparency=1; myCaption.Font=Enum.Font.FredokaOne; myCaption.Text="MY LANGUAGE"; myCaption.TextSize=9
myCaption.TextColor3=C.DIM; myCaption.TextXAlignment=Enum.TextXAlignment.Left; myCaption.ZIndex=6
local myTag=Instance.new("TextLabel",myCard); myTag.Size=UDim2.new(1,-30,0,18); myTag.Position=UDim2.fromOffset(12,21)
myTag.BackgroundTransparency=1; myTag.Font=Enum.Font.FredokaOne; myTag.Text=langName(Config.myLang); myTag.TextSize=13
myTag.TextColor3=C.TEXT; myTag.TextXAlignment=Enum.TextXAlignment.Left; myTag.ZIndex=6
local myArrow=Instance.new("TextLabel",myCard); myArrow.Size=UDim2.new(0,18,1,0); myArrow.Position=UDim2.new(1,-22,0,0)
myArrow.BackgroundTransparency=1; myArrow.Font=Enum.Font.FredokaOne; myArrow.Text="v"; myArrow.TextSize=12; myArrow.TextColor3=C.DIM; myArrow.ZIndex=6
myCard.MouseEnter:Connect(function() tw(myCard,0.12,{BackgroundColor3=Color3.fromRGB(24,64,44)}) end)
myCard.MouseLeave:Connect(function() tw(myCard,0.12,{BackgroundColor3=C.SURF2}) end)
local themCard=Instance.new("Frame",topRow); themCard.Size=UDim2.new(0.5,-5,1,0); themCard.Position=UDim2.new(0.5,5,0,0)
themCard.BackgroundColor3=C.SURF; themCard.ZIndex=5; round(themCard,10); strk(themCard,C.STROKE,1,0.6)
local themCaption=Instance.new("TextLabel",themCard); themCaption.Size=UDim2.new(1,-16,0,14); themCaption.Position=UDim2.fromOffset(12,6)
themCaption.BackgroundTransparency=1; themCaption.Font=Enum.Font.FredokaOne; themCaption.Text="THEIR LANGUAGE"; themCaption.TextSize=9
themCaption.TextColor3=C.DIM; themCaption.TextXAlignment=Enum.TextXAlignment.Left; themCaption.ZIndex=5
theirLbl=Instance.new("TextLabel",themCard); theirLbl.Size=UDim2.new(1,-24,0,18); theirLbl.Position=UDim2.fromOffset(12,21)
theirLbl.BackgroundTransparency=1; theirLbl.Font=Enum.Font.FredokaOne; theirLbl.Text=langName(Config.theirLang); theirLbl.TextSize=13
theirLbl.TextColor3=C.TEXT; theirLbl.TextXAlignment=Enum.TextXAlignment.Left; theirLbl.ZIndex=5
local autoTag=Instance.new("TextLabel",themCard); autoTag.Size=UDim2.new(0,40,0,14); autoTag.Position=UDim2.new(1,-46,0,6)
autoTag.BackgroundTransparency=1; autoTag.Font=Enum.Font.FredokaOne; autoTag.Text="AUTO"; autoTag.TextSize=8
autoTag.TextColor3=C.GREEN_STROKE; autoTag.TextXAlignment=Enum.TextXAlignment.Right; autoTag.ZIndex=5
local transToggle=Instance.new("TextButton",chatPage); transToggle.Size=UDim2.new(1,0,0,28); transToggle.Position=UDim2.fromOffset(0,50)
transToggle.BackgroundColor3=Config.translatorOn and C.GREEN1 or C.SURF2; transToggle.AutoButtonColor=false
transToggle.Text=Config.translatorOn and "AUTO-TRANSLATE INCOMING  •  ON" or "AUTO-TRANSLATE INCOMING  •  OFF"
transToggle.Font=Enum.Font.FredokaOne; transToggle.TextSize=11; transToggle.TextColor3=Config.translatorOn and C.TEXT or C.OFF_TEXT
transToggle.ZIndex=5; round(transToggle,10); local ttS=strk(transToggle,Config.translatorOn and C.GREEN_STROKE or C.STROKE,1,0.5)
transToggle.MouseButton1Click:Connect(function()
    Config.translatorOn=not Config.translatorOn; saveConfig()
    transToggle.Text=Config.translatorOn and "AUTO-TRANSLATE INCOMING  •  ON" or "AUTO-TRANSLATE INCOMING  •  OFF"
    tw(transToggle,0.12,{BackgroundColor3=Config.translatorOn and C.GREEN1 or C.SURF2})
    transToggle.TextColor3=Config.translatorOn and C.TEXT or C.OFF_TEXT
    ttS.Color=Config.translatorOn and C.GREEN_STROKE or C.STROKE
end)
local dropOpen=false
local dropMenu=Instance.new("Frame",chatPage); dropMenu.Size=UDim2.new(0.5,-5,0,0); dropMenu.Position=UDim2.fromOffset(0,46)
dropMenu.BackgroundColor3=C.SURF; dropMenu.BorderSizePixel=0; dropMenu.Visible=false; dropMenu.ClipsDescendants=true; dropMenu.ZIndex=30
round(dropMenu,10); strk(dropMenu,C.STROKE,1,0.35)
local dmScroll=Instance.new("ScrollingFrame",dropMenu); dmScroll.Size=UDim2.fromScale(1,1); dmScroll.BackgroundTransparency=1
dmScroll.BorderSizePixel=0; dmScroll.ScrollBarThickness=3; dmScroll.ScrollBarImageColor3=C.ACCENT
dmScroll.CanvasSize=UDim2.new(0,0,0,0); dmScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; dmScroll.ZIndex=31
local dmL=Instance.new("UIListLayout",dmScroll); dmL.Padding=UDim.new(0,3); dmL.SortOrder=Enum.SortOrder.LayoutOrder
local dmp=Instance.new("UIPadding",dmScroll); dmp.PaddingTop=UDim.new(0,4); dmp.PaddingBottom=UDim.new(0,4); dmp.PaddingLeft=UDim.new(0,4); dmp.PaddingRight=UDim.new(0,4)
for i,l in ipairs(LANGS) do
    local opt=Instance.new("TextButton",dmScroll); opt.Size=UDim2.new(1,-2,0,28); opt.LayoutOrder=i
    opt.AutoButtonColor=false; opt.BackgroundColor3=C.SURF2; opt.Text=""
    opt.ZIndex=32; round(opt,8)
    local ol=Instance.new("TextLabel",opt); ol.Size=UDim2.new(1,-20,1,0); ol.Position=UDim2.fromOffset(12,0)
    ol.BackgroundTransparency=1; ol.Font=Enum.Font.GothamMedium; ol.Text=l.name; ol.TextSize=12; ol.TextColor3=C.TEXT
    ol.TextXAlignment=Enum.TextXAlignment.Left; ol.ZIndex=32
    if l.code==Config.myLang then local chk=Instance.new("TextLabel",opt); chk.Size=UDim2.new(0,20,1,0); chk.Position=UDim2.new(1,-24,0,0)
        chk.BackgroundTransparency=1; chk.Font=Enum.Font.FredokaOne; chk.Text="•"; chk.TextSize=16; chk.TextColor3=C.ACCENT; chk.ZIndex=32 end
    opt.MouseEnter:Connect(function() tw(opt,0.1,{BackgroundColor3=C.ACCENT2}) end)
    opt.MouseLeave:Connect(function() tw(opt,0.1,{BackgroundColor3=C.SURF2}) end)
    opt.MouseButton1Click:Connect(function()
        Config.myLang=l.code; saveConfig(); myTag.Text=l.name
        dropOpen=false; dropMenu.Visible=false; myArrow.Text="v"
    end)
end
local function toggleDrop()
    dropOpen=not dropOpen
    if dropOpen then
        dropMenu.Visible=true; myArrow.Text="^"; dropMenu.Size=UDim2.new(0.5,-5,0,0)
        tw(dropMenu,0.16,{Size=UDim2.new(0.5,-5,0,190)})
    else
        myArrow.Text="v"
        local t=TweenService:Create(dropMenu,TweenInfo.new(0.14,Enum.EasingStyle.Quad),{Size=UDim2.new(0.5,-5,0,0)})
        t:Play(); t.Completed:Connect(function() if not dropOpen then dropMenu.Visible=false end end)
    end
end
myCard.MouseButton1Click:Connect(toggleDrop)
local feed=Instance.new("ScrollingFrame",chatPage); feed.Size=UDim2.new(1,0,1,-232); feed.Position=UDim2.fromOffset(0,86)
feed.BackgroundColor3=C.SURF; feed.BorderSizePixel=0; feed.ScrollBarThickness=4; feed.ScrollBarImageColor3=C.ACCENT
feed.CanvasSize=UDim2.new(0,0,0,0); feed.AutomaticCanvasSize=Enum.AutomaticSize.Y; round(feed,10); strk(feed,C.STROKE,1,0.6)
local feedPad=Instance.new("UIPadding",feed); feedPad.PaddingLeft=UDim.new(0,8); feedPad.PaddingRight=UDim.new(0,8); feedPad.PaddingTop=UDim.new(0,8); feedPad.PaddingBottom=UDim.new(0,8)
local feedL=Instance.new("UIListLayout",feed); feedL.Padding=UDim.new(0,6); feedL.SortOrder=Enum.SortOrder.LayoutOrder
local feedEmpty=Instance.new("TextLabel",feed); feedEmpty.Size=UDim2.new(1,0,0,40); feedEmpty.BackgroundTransparency=1
feedEmpty.Font=Enum.Font.Gotham; feedEmpty.Text="their messages appear here, translated"; feedEmpty.TextSize=11
feedEmpty.TextColor3=C.OFF_TEXT; feedEmpty.TextWrapped=true
_feedOrder=0
_msgHighestIdx=0
_resetLangVotes=false
function clearFeed()
    for _,ch in ipairs(feed:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
    feedEmpty.Visible=true
    _feedOrder=0
    Config.theirLang="auto"
    theirLbl.Text=langName("auto")
    _msgHighestIdx=0
    _resetLangVotes=true
end
function addFeedMsg(original, translated)
    feedEmpty.Visible=false
    _feedOrder=_feedOrder+1
    local row=Instance.new("Frame",feed); row.Size=UDim2.new(1,0,0,0); row.AutomaticSize=Enum.AutomaticSize.Y
    row.BackgroundColor3=C.SURF2; row.BorderSizePixel=0; row.LayoutOrder=_feedOrder; round(row,8); strk(row,C.STROKE,1,0.7)
    local rp=Instance.new("UIPadding",row); rp.PaddingLeft=UDim.new(0,8); rp.PaddingRight=UDim.new(0,8); rp.PaddingTop=UDim.new(0,6); rp.PaddingBottom=UDim.new(0,6)
    local ll=Instance.new("UIListLayout",row); ll.Padding=UDim.new(0,2); ll.SortOrder=Enum.SortOrder.LayoutOrder
    local tr=Instance.new("TextLabel",row); tr.Size=UDim2.new(1,0,0,0); tr.AutomaticSize=Enum.AutomaticSize.Y
    tr.BackgroundTransparency=1; tr.Font=Enum.Font.FredokaOne; tr.Text=translated; tr.TextSize=13; tr.TextColor3=C.TEXT
    tr.TextXAlignment=Enum.TextXAlignment.Left; tr.TextWrapped=true; tr.LayoutOrder=1
    local og=Instance.new("TextLabel",row); og.Size=UDim2.new(1,0,0,0); og.AutomaticSize=Enum.AutomaticSize.Y
    og.BackgroundTransparency=1; og.Font=Enum.Font.Gotham; og.Text=original; og.TextSize=10; og.TextColor3=C.OFF_TEXT
    og.TextXAlignment=Enum.TextXAlignment.Left; og.TextWrapped=true; og.LayoutOrder=2
    task.defer(function() feed.CanvasPosition=Vector2.new(0,feed.AbsoluteCanvasSize.Y) end)
end
local compose=Instance.new("Frame",chatPage); compose.Size=UDim2.new(1,0,0,138); compose.Position=UDim2.new(0,0,1,-138)
compose.BackgroundTransparency=1
replyBox=Instance.new("TextBox",compose); replyBox.Size=UDim2.new(1,0,0,42); replyBox.Position=UDim2.fromOffset(0,0)
replyBox.BackgroundColor3=C.SURF; replyBox.Text=""; replyBox.PlaceholderText="type your reply…"
replyBox.PlaceholderColor3=C.OFF_TEXT; replyBox.Font=Enum.Font.Gotham; replyBox.TextSize=12; replyBox.TextColor3=C.TEXT
replyBox.TextWrapped=true; replyBox.MultiLine=true; replyBox.TextXAlignment=Enum.TextXAlignment.Left; replyBox.TextYAlignment=Enum.TextYAlignment.Top
replyBox.ClearTextOnFocus=false; replyBox.ClipsDescendants=true; round(replyBox,10); strk(replyBox,C.STROKE,1,0.55)
local rbp=Instance.new("UIPadding",replyBox); rbp.PaddingLeft=UDim.new(0,10); rbp.PaddingTop=UDim.new(0,7); rbp.PaddingRight=UDim.new(0,10); rbp.PaddingBottom=UDim.new(0,6)
previewBox=Instance.new("TextLabel",compose); previewBox.Size=UDim2.new(1,0,0,42); previewBox.Position=UDim2.fromOffset(0,48)
previewBox.BackgroundColor3=C.SURF2; previewBox.Text=""; previewBox.Font=Enum.Font.GothamMedium; previewBox.TextSize=11
previewBox.TextColor3=C.TEXT; previewBox.TextWrapped=true; previewBox.TextXAlignment=Enum.TextXAlignment.Left
previewBox.TextYAlignment=Enum.TextYAlignment.Top
round(previewBox,10); strk(previewBox,C.STROKE,1,0.6)
local pvp=Instance.new("UIPadding",previewBox); pvp.PaddingLeft=UDim.new(0,10); pvp.PaddingRight=UDim.new(0,10); pvp.PaddingTop=UDim.new(0,6); pvp.PaddingBottom=UDim.new(0,6)
pvTag=Instance.new("TextLabel",previewBox); pvTag.Size=UDim2.new(0,90,0,12); pvTag.Position=UDim2.new(1,-96,0,4)
pvTag.BackgroundTransparency=1; pvTag.Font=Enum.Font.FredokaOne; pvTag.Text="WILL SEND"; pvTag.TextSize=8
pvTag.TextColor3=C.GREEN_STROKE; pvTag.TextXAlignment=Enum.TextXAlignment.Right; pvTag.Visible=false
pvPlaceholder=Instance.new("TextLabel",previewBox); pvPlaceholder.Size=UDim2.fromScale(1,1); pvPlaceholder.BackgroundTransparency=1
pvPlaceholder.Font=Enum.Font.Gotham; pvPlaceholder.Text="translated preview appears here…"; pvPlaceholder.TextSize=11; pvPlaceholder.TextColor3=C.OFF_TEXT
pvPlaceholder.TextXAlignment=Enum.TextXAlignment.Left; pvPlaceholder.TextYAlignment=Enum.TextYAlignment.Top
_translatedOut=""
local cbRow=Instance.new("Frame",compose); cbRow.Size=UDim2.new(1,0,0,32); cbRow.Position=UDim2.fromOffset(0,96); cbRow.BackgroundTransparency=1
local cbL=Instance.new("UIListLayout",cbRow); cbL.FillDirection=Enum.FillDirection.Horizontal; cbL.Padding=UDim.new(0,6); cbL.SortOrder=Enum.SortOrder.LayoutOrder
local translateBtn=makeBtn(cbRow,"TRANSLATE",{textSize=12}); translateBtn.Size=UDim2.new(0.4,-4,1,0); translateBtn.LayoutOrder=1
local copyReplyBtn=makeBtn(cbRow,"COPY",{color=C.SURF2,press=C.ACCENT2,stroke=C.STROKE,strokeT=0.5,textSize=12}); copyReplyBtn.Size=UDim2.new(0.3,-4,1,0); copyReplyBtn.LayoutOrder=2
local sendBtn=makeBtn(cbRow,"SEND",{textSize=12}); sendBtn.Size=UDim2.new(0.3,-4,1,0); sendBtn.LayoutOrder=3
translateBtn.MouseButton1Click:Connect(function()
    local msg=replyBox.Text; if msg=="" then return end
    translateBtn.Text="..."
    task.spawn(function()
        local out=msg
        if Config.theirLang and Config.theirLang~="" and Config.theirLang~="auto" then
            out=translateRomanized(msg,Config.theirLang,Config.myLang) or msg
        end
        _translatedOut=out; pvPlaceholder.Visible=false; pvTag.Visible=true; previewBox.Text=out
        translateBtn.Text="TRANSLATE"
    end)
end)
copyReplyBtn.MouseButton1Click:Connect(function()
    local t=(_translatedOut~="" and _translatedOut) or replyBox.Text; if t=="" then return end
    pcall(function() setclipboard(t) end)
    copyReplyBtn.Text="OK"; task.delay(1,function() if copyReplyBtn.Parent then copyReplyBtn.Text="COPY" end end)
end)
sendBtn.MouseButton1Click:Connect(function()
    local t=(_translatedOut~="" and _translatedOut) or replyBox.Text; if t=="" then return end
    sendBtn.Text="..."
    task.spawn(function()
        local ok=sendChatMessage(t)
        sendBtn.Text=ok and "SENT" or "FAIL"
        if ok then replyBox.Text=""; previewBox.Text=""; pvPlaceholder.Visible=true; pvTag.Visible=false; _translatedOut="" end
        task.delay(1.5,function() if sendBtn.Parent then sendBtn.Text="SEND" end end)
    end)
end)
end
do
local presetPage=Instance.new("Frame",body); presetPage.Size=UDim2.fromScale(1,1); presetPage.BackgroundTransparency=1; presetPage.Visible=false; pages.presets=presetPage
local newBox=Instance.new("TextBox",presetPage); newBox.Size=UDim2.new(1,0,0,42); newBox.Position=UDim2.fromOffset(0,0)
newBox.BackgroundColor3=C.SURF; newBox.Text=""; newBox.PlaceholderText="write a preset message…"; newBox.PlaceholderColor3=C.OFF_TEXT
newBox.Font=Enum.Font.Gotham; newBox.TextSize=12; newBox.TextColor3=C.TEXT; newBox.TextWrapped=true
newBox.TextXAlignment=Enum.TextXAlignment.Left; newBox.TextYAlignment=Enum.TextYAlignment.Top; newBox.ClearTextOnFocus=false
round(newBox,10); strk(newBox,C.STROKE,1,0.55)
local nbp=Instance.new("UIPadding",newBox); nbp.PaddingLeft=UDim.new(0,10); nbp.PaddingTop=UDim.new(0,6); nbp.PaddingRight=UDim.new(0,10)
local addBtn=makeBtn(presetPage,"+ ADD PRESET",{textSize=12}); addBtn.Size=UDim2.new(1,0,0,28); addBtn.Position=UDim2.fromOffset(0,48)
local presetScroll=Instance.new("ScrollingFrame",presetPage); presetScroll.Size=UDim2.new(1,0,1,-86); presetScroll.Position=UDim2.fromOffset(0,84)
presetScroll.BackgroundTransparency=1; presetScroll.BorderSizePixel=0; presetScroll.ScrollBarThickness=4; presetScroll.ScrollBarImageColor3=C.ACCENT
presetScroll.CanvasSize=UDim2.new(0,0,0,0); presetScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
local psPad=Instance.new("UIPadding",presetScroll); psPad.PaddingRight=UDim.new(0,8); psPad.PaddingTop=UDim.new(0,1)
local psL=Instance.new("UIListLayout",presetScroll); psL.Padding=UDim.new(0,8); psL.SortOrder=Enum.SortOrder.LayoutOrder
local editingIndex=nil
local buildPresets
buildPresets=function()
    for _,ch in ipairs(presetScroll:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
    for i,msg in ipairs(Config.presets) do
        local row=Instance.new("Frame",presetScroll); row.Size=UDim2.new(1,0,0,64); row.BackgroundColor3=C.SURF
        row.BorderSizePixel=0; row.LayoutOrder=i; round(row,11); strk(row,C.STROKE,1,0.55)
        local inner=Instance.new("Frame",row); inner.Size=UDim2.new(1,-20,1,-16); inner.Position=UDim2.fromOffset(10,8)
        inner.BackgroundTransparency=1
        local txt=Instance.new("TextLabel",inner); txt.Size=UDim2.new(1,0,0,22); txt.Position=UDim2.fromOffset(0,0)
        txt.BackgroundTransparency=1; txt.Font=Enum.Font.GothamMedium; txt.Text=msg; txt.TextSize=12; txt.TextColor3=C.TEXT
        txt.TextXAlignment=Enum.TextXAlignment.Left; txt.TextTruncate=Enum.TextTruncate.AtEnd
        local btnHolder=Instance.new("Frame",inner); btnHolder.Size=UDim2.new(1,0,0,20); btnHolder.Position=UDim2.new(0,0,1,-20)
        btnHolder.BackgroundTransparency=1
        local bl=Instance.new("UIListLayout",btnHolder); bl.FillDirection=Enum.FillDirection.Horizontal
        bl.Padding=UDim.new(0,6); bl.SortOrder=Enum.SortOrder.LayoutOrder
        local function mk(label,order,opts)
            opts = opts or { color=C.SURF2, press=C.ACCENT2, stroke=C.STROKE, strokeT=0.5 }
            local b=makeBtn(btnHolder,label,{color=opts.color,press=opts.press,stroke=opts.stroke,strokeT=opts.strokeT,radius=6,textSize=10})
            b.Size=UDim2.new(0.25,-4.5,1,0); b.LayoutOrder=order
            return b
        end
        local sendB=mk("SEND",1,{color=C.ACCENT2,press=C.ACCENT,stroke=C.ACCENT,strokeT=0.35})
        local copyB=mk("COPY",2)
        local editB=mk("EDIT",3)
        local delB=mk("DEL",4,{color=Color3.fromRGB(90,28,28),press=Color3.fromRGB(120,40,40),stroke=Color3.fromRGB(160,60,60),strokeT=0.4})
        sendB.MouseButton1Click:Connect(function()
            task.spawn(function()
                local out=msg
                if Config.theirLang and Config.theirLang~="" and Config.theirLang~="auto" and Config.theirLang~=Config.myLang then
                    local tr=translateRomanized(msg,Config.theirLang,Config.myLang)
                    if tr and tr~="" then out=tr end
                end
                if not out or out=="" then out=msg end
                local ok=sendChatMessage(out)
                sendB.Text=ok and "SENT" or "FAIL"; task.delay(1,function() if sendB.Parent then sendB.Text="SEND" end end)
            end)
        end)
        copyB.MouseButton1Click:Connect(function() pcall(function() setclipboard(msg) end)
            copyB.Text="OK"; task.delay(1,function() if copyB.Parent then copyB.Text="COPY" end end) end)
        editB.MouseButton1Click:Connect(function() newBox.Text=msg; editingIndex=i; addBtn.Text="SAVE EDIT" end)
        delB.MouseButton1Click:Connect(function() table.remove(Config.presets,i); saveConfig(); buildPresets() end)
    end
end
addBtn.MouseButton1Click:Connect(function()
    local msg=newBox.Text; if msg=="" then return end
    if editingIndex then Config.presets[editingIndex]=msg; editingIndex=nil; addBtn.Text="+ ADD PRESET"
    else table.insert(Config.presets,msg) end
    newBox.Text=""; saveConfig(); buildPresets()
end)
buildPresets()
end
selectTab("list")
local settingsRefresh
do
    local settingsPage=Instance.new("Frame",body); settingsPage.Size=UDim2.fromScale(1,1)
    settingsPage.BackgroundTransparency=1; settingsPage.Visible=false; pages.settings=settingsPage
    local scroll=Instance.new("ScrollingFrame",settingsPage); scroll.Size=UDim2.fromScale(1,1); scroll.BackgroundTransparency=1
    scroll.BorderSizePixel=0; scroll.ScrollBarThickness=4; scroll.ScrollBarImageColor3=C.ACCENT
    scroll.CanvasSize=UDim2.new(0,0,0,0); scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local sPad=Instance.new("UIPadding",scroll); sPad.PaddingRight=UDim.new(0,6); sPad.PaddingBottom=UDim.new(0,12)
    local slist=Instance.new("UIListLayout",scroll); slist.Padding=UDim.new(0,7); slist.SortOrder=Enum.SortOrder.LayoutOrder
    local function sectionLabel(text,order,firstSection)
        local wrap=Instance.new("Frame",scroll); wrap.Size=UDim2.new(1,0,0,firstSection and 24 or 34); wrap.LayoutOrder=order
        wrap.BackgroundTransparency=1
        local l=Instance.new("TextLabel",wrap); l.Size=UDim2.new(1,0,0,16); l.Position=UDim2.new(0,2,1,-18)
        l.BackgroundTransparency=1; l.Text=text; l.Font=Enum.Font.FredokaOne; l.TextSize=11
        l.TextColor3=C.ACCENT; l.TextXAlignment=Enum.TextXAlignment.Left; _G.CVN_xmasTitle(l)
        local div=Instance.new("Frame",wrap); div.Size=UDim2.new(1,0,0,1); div.Position=UDim2.new(0,0,1,-1)
        div.BackgroundColor3=C.STROKE; div.BackgroundTransparency=0.6; div.BorderSizePixel=0
    end
    local function toggleRow(label, key, order, onChange)
        local row=Instance.new("TextButton",scroll); row.Size=UDim2.new(1,0,0,36); row.LayoutOrder=order
        row.AutoButtonColor=false; row.BackgroundColor3=C.SURF; row.Text=""; row.ZIndex=5; round(row,9); strk(row,C.STROKE,1,0.55)
        local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(1,-64,1,0); lbl.Position=UDim2.fromOffset(14,0)
        lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=Enum.Font.GothamMedium; lbl.TextSize=12
        lbl.TextColor3=C.TEXT; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=6
        local pill=Instance.new("Frame",row); pill.Size=UDim2.fromOffset(42,22); pill.Position=UDim2.new(1,-54,0.5,-11)
        pill.BackgroundColor3=Config[key] and C.GREEN1 or C.SURF2; pill.ZIndex=6; round(pill,11)
        local stripes=Instance.new("Frame",pill); stripes.Size=UDim2.fromScale(1,1); stripes.BackgroundColor3=Color3.new(1,1,1)
        stripes.BorderSizePixel=0; stripes.ZIndex=6; round(stripes,11); stripes.BackgroundTransparency=Config[key] and 0 or 1
        _G.CVN_X.candy(stripes, stripes)
        local pst=Instance.new("UIStroke",pill); pst.Color=Color3.new(1,1,1); pst.Thickness=1.4; pst.Transparency=Config[key] and 0.1 or 1
        local knob=Instance.new("Frame",pill); knob.Size=UDim2.fromOffset(16,16); knob.ZIndex=7; round(knob,8)
        knob.BackgroundColor3=Config[key] and C.GREEN_STROKE or C.OFF_TEXT
        knob.Position=Config[key] and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
        row.MouseButton1Click:Connect(function()
            Config[key]=not Config[key]
            tw(pill,0.12,{BackgroundColor3=Config[key] and C.GREEN1 or C.SURF2})
            tw(stripes,0.12,{BackgroundTransparency=Config[key] and 0 or 1}); tw(pst,0.12,{Transparency=Config[key] and 0.1 or 1})
            tw(knob,0.12,{Position=Config[key] and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),BackgroundColor3=Config[key] and C.GREEN_STROKE or C.OFF_TEXT})
            saveConfig(); if onChange then onChange() end
        end)
        return row
    end
    sectionLabel("SERVER HOPPING", 1, true)
    toggleRow("Auto-hop until priority", "autoHop", 2)
    local tierLbl=Instance.new("TextLabel",scroll); tierLbl.Size=UDim2.new(1,0,0,14); tierLbl.LayoutOrder=3
    tierLbl.BackgroundTransparency=1; tierLbl.Text="Hop tier"; tierLbl.Font=Enum.Font.GothamMedium; tierLbl.TextSize=11
    tierLbl.TextColor3=C.OFF_TEXT; tierLbl.TextXAlignment=Enum.TextXAlignment.Left
    local tierRow=Instance.new("Frame",scroll); tierRow.Size=UDim2.new(1,0,0,30); tierRow.LayoutOrder=4; tierRow.BackgroundTransparency=1
    local trL=Instance.new("UIListLayout",tierRow); trL.FillDirection=Enum.FillDirection.Horizontal
    trL.Padding=UDim.new(0,6); trL.SortOrder=Enum.SortOrder.LayoutOrder
    local tiers={"Normal","Pro","OG"}
    local tierBtns={}
    for i,t in ipairs(tiers) do
        local b=Instance.new("TextButton",tierRow); b.Size=UDim2.new(1/3,-4,1,0); b.LayoutOrder=i
        b.AutoButtonColor=false; b.Text=t; b.Font=Enum.Font.FredokaOne; b.TextSize=12; round(b,8)
        b.BackgroundColor3=(Config.hopTier==t) and C.ACCENT2 or C.SURF2; b.TextColor3=(Config.hopTier==t) and C.TEXT or C.OFF_TEXT
        strk(b,(Config.hopTier==t) and C.ACCENT or C.STROKE,1,0.5)
        tierBtns[t]=b
        b.MouseButton1Click:Connect(function()
            Config.hopTier=t; saveConfig()
            for tt,bb in pairs(tierBtns) do
                tw(bb,0.1,{BackgroundColor3=(tt==t) and C.ACCENT2 or C.SURF2}); bb.TextColor3=(tt==t) and C.TEXT or C.OFF_TEXT
                local s=bb:FindFirstChildWhichIsA("UIStroke"); if s then s.Color=(tt==t) and C.ACCENT or C.STROKE end
            end
        end)
    end
    local hopBtn=makeBtn(scroll,"HOP NOW",{textSize=12}); hopBtn.Size=UDim2.new(1,0,0,34); hopBtn.LayoutOrder=5
    hopBtn.MouseButton1Click:Connect(function() serverHop(Config.hopTier) end)
    sectionLabel("ALERTS", 10)
    toggleRow("Alert sound on priority", "alertSound", 11)
    sectionLabel("DISPLAY", 20)
    toggleRow("Show player avatars", "showAvatars", 21, function() _lastKey="" end)
    toggleRow("Beam to trader's base", "beamToBase", 22)
    sectionLabel("PRIORITY BRAINROTS", 30)
    local pSearch=Instance.new("TextBox",scroll); pSearch.Size=UDim2.new(1,0,0,34); pSearch.LayoutOrder=31
    pSearch.BackgroundColor3=C.SURF; pSearch.Text=""; pSearch.PlaceholderText="search a brainrot to add..."
    pSearch.PlaceholderColor3=C.OFF_TEXT; pSearch.Font=Enum.Font.GothamMedium; pSearch.TextSize=12; pSearch.TextColor3=C.TEXT
    pSearch.TextXAlignment=Enum.TextXAlignment.Left; pSearch.ClearTextOnFocus=false; round(pSearch,9); strk(pSearch,C.STROKE,1,0.5)
    local pPad=Instance.new("UIPadding",pSearch); pPad.PaddingLeft=UDim.new(0,12)
    local resultsFrame=Instance.new("Frame",scroll); resultsFrame.Size=UDim2.new(1,0,0,0); resultsFrame.LayoutOrder=32
    resultsFrame.BackgroundTransparency=1; resultsFrame.AutomaticSize=Enum.AutomaticSize.Y
    local rList=Instance.new("UIListLayout",resultsFrame); rList.Padding=UDim.new(0,4)
    local currentLabel=Instance.new("TextLabel",scroll); currentLabel.Size=UDim2.new(1,0,0,16); currentLabel.LayoutOrder=33
    currentLabel.BackgroundTransparency=1; currentLabel.Text="YOUR LIST"; currentLabel.Font=Enum.Font.FredokaOne
    currentLabel.TextSize=10; currentLabel.TextColor3=C.OFF_TEXT; currentLabel.TextXAlignment=Enum.TextXAlignment.Left
    local currentFrame=Instance.new("Frame",scroll); currentFrame.Size=UDim2.new(1,0,0,0); currentFrame.LayoutOrder=34
    currentFrame.BackgroundTransparency=1; currentFrame.AutomaticSize=Enum.AutomaticSize.Y
    local cList=Instance.new("UIListLayout",currentFrame); cList.Padding=UDim.new(0,4)
    local function inPriority(name)
        for _,n in ipairs(Config.priorityList) do if n==name then return true end end
        return false
    end
    local function rebuildCurrent()
        currentLabel.Text = "YOUR LIST  ("..#Config.priorityList..")"
        for _,ch in ipairs(currentFrame:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
        for i,name in ipairs(Config.priorityList) do
            local row=Instance.new("Frame",currentFrame); row.Size=UDim2.new(1,0,0,30); row.BackgroundColor3=C.SURF2; round(row,8); strk(row,C.STROKE,1,0.7)
            local l=Instance.new("TextLabel",row); l.Size=UDim2.new(1,-30,1,0); l.Position=UDim2.fromOffset(8,0); l.BackgroundTransparency=1
            l.Text=name; l.Font=Enum.Font.GothamMedium; l.TextSize=11; l.TextColor3=C.TEXT; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextTruncate=Enum.TextTruncate.AtEnd
            local x=Instance.new("TextButton",row); x.Size=UDim2.fromOffset(22,22); x.Position=UDim2.new(1,-25,0.5,-11); x.AutoButtonColor=false
            x.BackgroundColor3=C.ACCENT2; x.Text="x"; x.Font=Enum.Font.FredokaOne; x.TextSize=12; x.TextColor3=C.TEXT; round(x,6)
            x.MouseButton1Click:Connect(function()
                table.remove(Config.priorityList, i); saveConfig(); rebuildCurrent()
            end)
        end
    end
    local function doSearch()
        for _,ch in ipairs(resultsFrame:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
        local term=pSearch.Text:lower():gsub("^%s+",""):gsub("%s+$","")
        if term=="" then return end
        local shown=0
        for name,info in pairs(Animals) do
            if type(info)=="table" and info.Rarity and not inPriority(name) then
                if name:lower():find(term,1,true) then
                    shown=shown+1
                    local b=Instance.new("TextButton",resultsFrame); b.Size=UDim2.new(1,0,0,30); b.AutoButtonColor=false
                    b.BackgroundColor3=C.SURF; b.Text="+ "..name.."  ("..info.Rarity..")"; b.Font=Enum.Font.GothamMedium
                    b.TextSize=11; b.TextColor3=C.TEXT; b.TextXAlignment=Enum.TextXAlignment.Left; round(b,6)
                    local bp=Instance.new("UIPadding",b); bp.PaddingLeft=UDim.new(0,8)
                    b.MouseButton1Click:Connect(function()
                        table.insert(Config.priorityList, name); saveConfig(); pSearch.Text=""; doSearch(); rebuildCurrent()
                    end)
                    if shown>=8 then break end
                end
            end
        end
    end
    pSearch:GetPropertyChangedSignal("Text"):Connect(doSearch)
    rebuildCurrent()
    settingsRefresh = function()
    end
end
task.spawn(function()
    task.wait(4)
    while screen.Parent and alive() do
        if Config.autoHop and Config.priorityList and #Config.priorityList>0 then
            local owner, brainrot = scanForPriority()
            if brainrot then
                showToast("PRIORITY FOUND", brainrot..(owner and (" @ "..owner) or ""), 8)
                playAlertSound()
                Config.autoHop = false
                saveConfig()
                if settingsRefresh then pcall(settingsRefresh) end
                if owner and beamToTraderBase and Config.beamToBase then
                    task.wait(0.3); pcall(function() beamToTraderBase(owner) end)
                    if refreshBeamRows then refreshBeamRows() end
                end
                break
            else
                for jid,t in pairs(HopData.hoppedServers) do
                    if os.time()-t > 600 then HopData.hoppedServers[jid]=nil end
                end
                saveHops()
                showToast("HOPPING", "no priority here — searching...", 2)
                task.wait(Config.hopDelay or 2)
                serverHop(Config.hopTier)
                task.wait(6)
            end
        end
        task.wait(3)
    end
end)
task.spawn(function()
    if not alive() then return end
    local pg=LocalPlayer:WaitForChild("PlayerGui",30); if not pg then return end
    local myId = LocalPlayer.UserId
    local function isTheirs(rowFrame)
        local pi=rowFrame:FindFirstChild("PlayerImage")
        local hs=pi and pi:FindFirstChild("Headshot")
        local img=hs and hs.Image
        if type(img)=="string" then
            local id=img:match("id=(%d+)")
            if id then return tonumber(id)~=myId end
        end
        return true
    end
    local langVotes = {}
    local function considerLang(det, weight)
        if _resetLangVotes then langVotes={}; _resetLangVotes=false end
        if not det or det=="auto" or det=="" then return end
        langVotes[det]=(langVotes[det] or 0)+weight
        local best,bestW=nil,0
        for lang,w in pairs(langVotes) do
            if lang~="en" and w>bestW then best=lang; bestW=w end
        end
        if not best then
            for lang,w in pairs(langVotes) do if w>bestW then best=lang; bestW=w end end
        end
        if best and Config.theirLang~=best then
            Config.theirLang=best; theirLbl.Text=langName(best); saveConfig()
        end
    end
    local function handleMsg(t)
        if type(t)~="string" or #t<2 or t=="Template" then return end
        if not alive() or not Config.translatorOn then return end
        task.spawn(function()
            local tr,det=translate(t,Config.myLang,"auto")
            local words=0; for _ in tostring(t):gmatch("%S+") do words=words+1 end
            local weight = math.clamp(words, 1, 8)
            considerLang(det, weight)
            addFeedMsg(t, (tr and tr~=t) and tr or t)
        end)
    end
    local function isMsgRow(c)
        return c:IsA("Frame") and c.Name:find("^Message")
    end
    local function readTheirMessages(sf)
        local rows={}
        for _,c in ipairs(sf:GetChildren()) do
            if isMsgRow(c) then rows[#rows+1]=c end
        end
        table.sort(rows,function(a,b) return (a.LayoutOrder or 0)<(b.LayoutOrder or 0) end)
        local msgs={}
        for _,r in ipairs(rows) do
            local lbl=r:FindFirstChild("Label",true)
            local t=lbl and lbl.Text
            if type(t)=="string" and #t>=2 and t~="Template" then
                msgs[#msgs+1]={text=t, theirs=isTheirs(r)}
            end
        end
        return msgs
    end
    local function watchScroll(sf)
        local shownCount=0
        local function scan()
            local msgs=readTheirMessages(sf)
            if #msgs<shownCount then shownCount=0; _msgHighestIdx=0 end
            for i=shownCount+1,#msgs do
                local m=msgs[i]
                if m.theirs then handleMsg(m.text) end
            end
            shownCount=#msgs
        end
        scan()
        sf.ChildAdded:Connect(function() task.defer(scan) end)
        sf.ChildRemoved:Connect(function() task.defer(function()
            local msgs=readTheirMessages(sf); if #msgs<shownCount then shownCount=#msgs end
        end) end)
    end
    local function hookTradeGui(tradeGui)
        task.spawn(function()
            local inner=tradeGui:WaitForChild("TradeLiveTrade",5) or tradeGui
            local chat=inner:FindFirstChild("Chat")
            if not chat then
                inner.ChildAdded:Connect(function(ch) if ch.Name=="Chat" then
                    for _,sub in ipairs({"NormalChat","RestrictedChat"}) do
                        local nc=ch:WaitForChild(sub,5); local sf=nc and nc:WaitForChild("ScrollingFrame",5)
                        if sf then watchScroll(sf) end
                    end
                end end)
                return
            end
            for _,sub in ipairs({"NormalChat","RestrictedChat"}) do
                local nc=chat:FindFirstChild(sub); local sf=nc and nc:FindFirstChild("ScrollingFrame")
                if sf then watchScroll(sf) end
            end
        end)
    end
    local existing=pg:FindFirstChild("TradeLiveTrade")
    if existing then hookTradeGui(existing) end
    pg.ChildAdded:Connect(function(g) if g.Name=="TradeLiveTrade" then task.defer(function() hookTradeGui(g) end) end end)
end)
local showBaseBtn=nil
local _showBaseClick=nil
local baseScreen=Instance.new("ScreenGui"); baseScreen.Name="IdontlogConvincerBase"
baseScreen.ResetOnSpawn=false; baseScreen.IgnoreGuiInset=true; baseScreen.DisplayOrder=999998
baseScreen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
baseScreen.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or hui
local basePanel=Instance.new("Frame",baseScreen); basePanel.Name="BasePanel"
basePanel.Size=UDim2.fromOffset(680,620); basePanel.AnchorPoint=Vector2.new(0.5,0.5); basePanel.Position=UDim2.fromScale(0.5,0.5)
basePanel.BackgroundColor3=C.BG; basePanel.BorderSizePixel=0; basePanel.Visible=false; basePanel.ZIndex=60
round(basePanel,16); strk(basePanel,C.STROKE,1.4,0.38); shadow(basePanel)
local BASE_UI_SCALE = (DEVICE=="phone") and 0.52 or (DEVICE=="tablet") and 0.75 or 1
do
    local bs=Instance.new("UIScale", basePanel)
    bs.Scale = BASE_UI_SCALE
end
local bpHeader=Instance.new("Frame",basePanel); bpHeader.Size=UDim2.new(1,0,0,44); bpHeader.BackgroundTransparency=1; bpHeader.ZIndex=61
local bpTitle=Instance.new("TextLabel",bpHeader); bpTitle.Size=UDim2.new(1,-56,0,28); bpTitle.Position=UDim2.fromOffset(18,12)
bpTitle.BackgroundTransparency=1; bpTitle.Font=Enum.Font.FredokaOne; bpTitle.Text="THEIR BASE"; bpTitle.TextSize=20; bpTitle.TextColor3=C.TEXT
bpTitle.TextXAlignment=Enum.TextXAlignment.Left; bpTitle.ZIndex=61
local bpLine=Instance.new("Frame",bpHeader); bpLine.Position=UDim2.fromOffset(18,40); bpLine.Size=UDim2.fromOffset(130,3)
bpLine.BackgroundColor3=C.ACCENT; bpLine.BorderSizePixel=0; bpLine.ZIndex=61; round(bpLine,1)
local bpClose=makeBtn(bpHeader,"X",{color=C.SURF2,press=C.ACCENT2,stroke=C.STROKE,strokeT=0.5,textSize=13})
bpClose.Size=UDim2.fromOffset(36,36); bpClose.Position=UDim2.new(1,-46,0,8); bpClose.ZIndex=61
bpClose.MouseButton1Click:Connect(function() basePanel.Visible=false end)
local resetCamera
local setView
local viewBar=Instance.new("Frame",basePanel); viewBar.Name="ViewBar"
viewBar.AnchorPoint=Vector2.new(0.5,1); viewBar.Position=UDim2.new(0.5,-14,1,-12)
viewBar.Size=UDim2.new(1,-96,0,34); viewBar.BackgroundTransparency=1; viewBar.ZIndex=62
local vbL=Instance.new("UIListLayout",viewBar); vbL.FillDirection=Enum.FillDirection.Horizontal
vbL.Padding=UDim.new(0,8); vbL.HorizontalAlignment=Enum.HorizontalAlignment.Center; vbL.SortOrder=Enum.SortOrder.LayoutOrder
local viewBtns={}
local function makeViewBtn(label, viewName, order)
    local b=makeBtn(viewBar,label,{color=C.SURF2,press=C.ACCENT2,stroke=C.STROKE,strokeT=0.45,textSize=13})
    b.Size=UDim2.new(0,120,1,0); b.LayoutOrder=order; b.ZIndex=62
    b.MouseButton1Click:Connect(function()
        if setView then setView(viewName) end
        for n,vb in pairs(viewBtns) do
            tw(vb,0.12,{BackgroundColor3=(n==viewName) and C.ACCENT2 or C.SURF2})
            vb.TextColor3=(n==viewName) and C.TEXT or C.OFF_TEXT
        end
    end)
    viewBtns[viewName]=b
    return b
end
makeViewBtn("FRONT","front",1); makeViewBtn("LEFT","left",2); makeViewBtn("RIGHT","right",3)
do local fb=viewBtns.front; if fb then fb.BackgroundColor3=C.ACCENT2; fb.TextColor3=C.TEXT end end
do
    local dragging,si,sp
    bpHeader.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; si=i.Position; sp=basePanel.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-si
            basePanel.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
end
local vpHolder=Instance.new("Frame",basePanel); vpHolder.Size=UDim2.new(1,-84,1,-104); vpHolder.Position=UDim2.fromOffset(14,52)
vpHolder.BackgroundColor3=Color3.fromRGB(160,205,245); vpHolder.BorderSizePixel=0; vpHolder.ClipsDescendants=true; vpHolder.ZIndex=61
round(vpHolder,12); strk(vpHolder,C.STROKE,1,0.5)
do
    local sg=Instance.new("UIGradient",vpHolder)
    sg.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(135,190,240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(205,230,250)),
    })
    sg.Rotation=90
end
local vp=Instance.new("ViewportFrame",vpHolder); vp.Size=UDim2.fromScale(1,1); vp.BackgroundTransparency=1; vp.ZIndex=61
vp.Ambient=Color3.fromRGB(200,215,255); vp.LightColor=Color3.fromRGB(255,250,235); vp.LightDirection=Vector3.new(-0.3,-1,-0.4)
local vpWorld=Instance.new("WorldModel")
vpWorld.Parent = vp
local vpCam=Instance.new("Camera",vp); vp.CurrentCamera=vpCam
labelOverlay=Instance.new("Frame",vpHolder); labelOverlay.Size=UDim2.fromScale(1,1)
labelOverlay.BackgroundTransparency=1; labelOverlay.ZIndex=63; labelOverlay.ClipsDescendants=true
local floorLbl=Instance.new("TextLabel",vpHolder); floorLbl.Size=UDim2.fromOffset(150,34); floorLbl.Position=UDim2.fromOffset(14,14)
floorLbl.BackgroundColor3=Color3.fromRGB(8,22,15); floorLbl.BackgroundTransparency=0.25; floorLbl.Font=Enum.Font.FredokaOne
floorLbl.Text="FLOOR 1"; floorLbl.TextSize=17; floorLbl.TextColor3=C.TEXT; floorLbl.ZIndex=62; round(floorLbl,9); strk(floorLbl,C.ACCENT,1.4,0.3)
local hoverLbl=Instance.new("TextLabel",vpHolder); hoverLbl.Size=UDim2.new(1,-20,0,22); hoverLbl.Position=UDim2.new(0,10,1,-30)
hoverLbl.BackgroundTransparency=1; hoverLbl.Font=Enum.Font.FredokaOne; hoverLbl.Text=""; hoverLbl.TextSize=12; hoverLbl.TextColor3=C.TEXT
hoverLbl.ZIndex=62
local sliderTrack=Instance.new("Frame",basePanel); sliderTrack.Size=UDim2.new(0,10,1,-110)
sliderTrack.Position=UDim2.new(1,-42,0,70); sliderTrack.BackgroundColor3=C.SURF2; sliderTrack.BorderSizePixel=0; sliderTrack.ZIndex=61
round(sliderTrack,5); strk(sliderTrack,C.STROKE,1,0.7)
local sliderFill=Instance.new("Frame",sliderTrack); sliderFill.AnchorPoint=Vector2.new(0.5,1); sliderFill.Position=UDim2.new(0.5,0,1,0)
sliderFill.Size=UDim2.new(1,0,0,0); sliderFill.BackgroundColor3=C.ACCENT; sliderFill.BorderSizePixel=0; sliderFill.ZIndex=61; round(sliderFill,5)
local baseState = { slots={}, floorsPresent={}, selected=1, camPos=Vector3.new(0,32,8), camTarget=Vector3.new(0,4,-37), plotInst=nil, built={}, labels={}, animalList={} }
local floorDots={}
local function makeFloorDot(fnum, yScale)
    local d=Instance.new("TextButton",basePanel); d.Size=UDim2.fromOffset(40,40)
    d.AnchorPoint=Vector2.new(0.5,0.5); d.Position=UDim2.new(1,-37,yScale,0)
    d.BackgroundColor3=C.SURF2; d.Text=tostring(fnum); d.Font=Enum.Font.FredokaOne; d.TextSize=18; d.TextColor3=C.OFF_TEXT
    d.AutoButtonColor=false; d.ZIndex=62; round(d,20); strk(d,C.STROKE,1.4,0.4)
    d.MouseEnter:Connect(function() if d.TextColor3~=C.TEXT then tw(d,0.1,{BackgroundColor3=Color3.fromRGB(30,78,54)}) end end)
    d.MouseLeave:Connect(function() if baseState.selected~=fnum then tw(d,0.1,{BackgroundColor3=C.SURF2}) end end)
    floorDots[fnum]=d
    return d
end
makeFloorDot(3,0.16); makeFloorDot(2,0.5); makeFloorDot(1,0.84)
local function layoutFloorSelector(present)
    local n=#present
    if n<=1 then
        sliderTrack.Visible=false
        for _,d in pairs(floorDots) do d.Visible=false end
        vpHolder.Size=UDim2.new(1,-28,1,-104)
        return
    end
    sliderTrack.Visible=true
    vpHolder.Size=UDim2.new(1,-84,1,-104)
    local order={}
    for i=#present,1,-1 do order[#order+1]=present[i] end
    for i,f in ipairs(order) do
        local yScale
        if n==2 then yScale = (i==1) and 0.20 or 0.80
        else yScale = (i==1) and 0.16 or (i==2) and 0.5 or 0.84 end
        local d=floorDots[f]
        if d then
            d.Visible=true
            d.Position=UDim2.new(1,-37,yScale,0)
            d.TextColor3=C.OFF_TEXT; d.BackgroundColor3=C.SURF2
        end
    end
    for f,d in pairs(floorDots) do
        local has=false; for _,pf in ipairs(present) do if pf==f then has=true break end end
        if not has then d.Visible=false end
    end
end
local function updateSliderFill()
    local present=baseState.presentList or {}
    local n=#present
    if n<=1 then return end
    local idx=1
    for i,f in ipairs(present) do if f==baseState.selected then idx=i break end end
    local fs = (n==2) and ((idx==1) and 0.2 or 0.8) or ((idx==1) and 0.16 or (idx==2) and 0.5 or 0.84)
    tw(sliderFill,0.25,{Size=UDim2.new(1,0,fs,0)})
end
local updateLabels, buildLabelObjs
local _keepOldWorld = false
local _inTransition = false
local _transitionOldWorld = nil
local function buildFloorScene(fnum)
    local oldWorld = vpWorld
    vpWorld = Instance.new("WorldModel")
    baseState.built={}
    baseState.labels={}
    if buildLabelObjs then for _,l in ipairs(labelOverlay:GetChildren()) do if l:IsA("Frame") then l:Destroy() end end end
    local animalList = baseState.animalList or {}
    local floorBaseY = SLOT_FLOOR_Y[fnum] or 0
    do
        local FLOOR_SLABS = {
            [1] = {
                { size=Vector3.new(45,2,16), pos=Vector3.new(-14.95,-5.51,-37.32), rot=CFrame.Angles(0,math.rad(-90),0) },
                { size=Vector3.new(45,2,16), pos=Vector3.new(14.05,-5.51,-37.32),  rot=CFrame.Angles(0,math.rad(-90),0) },
                { size=Vector3.new(5,11,1),  pos=Vector3.new(-0.45,-6.01,-12.32), rot=CFrame.Angles(math.rad(90),0,math.rad(-90)), carpet=true },
                { size=Vector3.new(48,11,2), pos=Vector3.new(-0.45,-5.51,-35.82), rot=CFrame.Angles(math.rad(90),0,math.rad(-90)), carpet=true },
                { size=Vector3.new(50,1,2), pos=Vector3.new(-6.45,-5.51,-36.82), rot=CFrame.Angles(math.rad(90),0,math.rad(-90)), studFloor=true },
                { size=Vector3.new(50,1,2), pos=Vector3.new(5.55,-5.51,-36.82),  rot=CFrame.Angles(math.rad(90),0,math.rad(-90)), studFloor=true },
            },
            [2] = {
                { size=Vector3.new(45,45,2), pos=Vector3.new(-0.45,12.49,-37.32), rot=CFrame.Angles(math.rad(90),0,math.rad(-90)) },
            },
            [3] = {
                { size=Vector3.new(45,17,2), pos=Vector3.new(-14.45,29.49,-37.32), rot=CFrame.Angles(math.rad(90),0,math.rad(-90)) },
                { size=Vector3.new(45,17,2), pos=Vector3.new(13.55,29.49,-37.32),  rot=CFrame.Angles(math.rad(90),0,math.rad(-90)) },
                { size=Vector3.new(31,11,2), pos=Vector3.new(-0.45,29.49,-30.32),  rot=CFrame.Angles(math.rad(90),0,math.rad(-90)) },
            },
        }
        local realFloorY = SLOT_FLOOR_Y[fnum] or 0
        for _,s in ipairs(FLOOR_SLABS[fnum] or {}) do
            local part=Instance.new("Part"); part.Anchored=true; part.CanCollide=false
            part.CanQuery=false; part.CanTouch=false; part.CastShadow=false
            part.Material=Enum.Material.SmoothPlastic
            part.Color = s.carpet and Color3.fromRGB(196,40,28) or s.studFloor and Color3.fromRGB(91,93,105) or Color3.fromRGB(99,95,98)
            part.Size = s.size
            local flatY = s.pos.Y - realFloorY
            part.CFrame = CFrame.new(s.pos.X, flatY, s.pos.Z) * s.rot
            part.Parent = vpWorld
        end
    end
    for slot, sl in pairs(SLOT_LAYOUT) do
        if slotFloorNum(slot)==fnum then
            local sx, sy, sz, syaw = sl[1], sl[2], sl[3], sl[4]
            local spawnCF = CFrame.new(sx, sy-floorBaseY, sz) * CFrame.Angles(0, math.rad(syaw), 0)
            for _,plate in ipairs(PODIUM_PLATES) do
                local part=Instance.new("Part"); part.Anchored=true; part.CanCollide=false; part.CanQuery=false
                part.CanTouch=false; part.CastShadow=false; part.Material=Enum.Material.Plastic
                part.Size=plate.size; part.Color=plate.color
                part.TopSurface=plate.top or Enum.SurfaceType.Smooth
                part.CFrame=spawnCF * CFrame.new(0, plate.yOff, 0)
                part.Parent=vpWorld
            end
            baseState.labels[#baseState.labels+1] = {
                world = (spawnCF*CFrame.new(0,-0.6,0)).Position, kind="slot", text=tostring(slot),
            }
            local entry=animalList[slot]
            local isEmpty=(entry=="Empty") or (type(entry)=="table" and entry.Index=="Empty") or (type(entry)~="table")
            if entry and not isEmpty then
                local index=entry.Index
                local mut=(entry.Mutation and entry.Mutation~="None" and entry.Mutation~="") and entry.Mutation or nil
                local mm, fromGame = getGameModel(index, mut, entry.Traits)
                if not mm then mm=getBrainrotClone(index) end
                if setthreadidentity then pcall(setthreadidentity, 8) end
                if mm then
                    do
                        for _,d in ipairs(mm:GetDescendants()) do if d:IsA("Script") or d:IsA("LocalScript") then d:Destroy() end end
                        if mut and not fromGame then applyMutationSafe(mm, mut) end
                        local placeCF = spawnCF * CFrame.new(0, -1.50, 0)
                        for _,d in ipairs(mm:GetDescendants()) do if d:IsA("BasePart") then d.Anchored=true end end
                        pcall(function() mm:PivotTo(placeCF) end)
                        mm.Parent=vpWorld
                        if mm then
                        pcall(function()
                            local aR=ReplicatedStorage:FindFirstChild("Animations"); aR=aR and aR:FindFirstChild("Animals")
                            local set=aR and aR:FindFirstChild(mm.Name)
                            local idle=set and (set:FindFirstChild("Idle") or set:FindFirstChildWhichIsA("Animation"))
                            if idle and idle:IsA("Animation") then
                                local an=mm:FindFirstChildWhichIsA("Animator", true)
                                if not an then
                                    local ac=mm:FindFirstChildWhichIsA("AnimationController") or Instance.new("AnimationController", mm)
                                    an=Instance.new("Animator", ac)
                                end
                                for _,d in ipairs(mm:GetDescendants()) do if d:IsA("BasePart") then d.Anchored=false end end
                                if mm.PrimaryPart then mm.PrimaryPart.Anchored=true end
                                local tr=an:LoadAnimation(idle)
                                tr.Looped=true
                                tr.Priority=Enum.AnimationPriority.Idle
                                tr:Play(0.2)
                                tr:AdjustSpeed(0.9)
                            end
                        end)
                        local info=Animals[index]
                        local _,msz=mm:GetBoundingBox()
                        local rar=info and tostring(info.Rarity) or nil
                        local rarData=rar and Rarities[rar]
                        local rarCol=rarData and rarData.Color or Color3.new(1,1,1)
                        local rarGradient=rarData and rarData.GradientPreset
                        local rarStroke=rarData and rarData.StrokeColor
                        local _info = Animals and Animals[index]
                        local _ohAtt = mm:FindFirstChild("OVERHEAD_ATTACHMENT", true)
                        local _ohY = msz.Y * 0.75 * ((_info and _info.OverheadYOffsetModifier) or 1)
                        local _ohWorld
                        if _ohAtt and _ohAtt:IsA("Attachment") then
                            _ohWorld = _ohAtt.WorldPosition + Vector3.new(0, 1.2, 0)
                        else
                            _ohWorld = (mm:GetPivot()*CFrame.new(0,_ohY,0)).Position
                        end
                        baseState.labels[#baseState.labels+1] = {
                            track = mm, trackYOffset = _ohY, trackAttachment = _ohAtt,
                            world=_ohWorld, kind="overhead",
                            name=resolveDisplayName(index, entry.Traits),
                            gen="$"..fmtGen(computeGeneration(index, mut, entry.Traits)).."/s",
                            mutation=mut, rarity=rar, rarityColor=rarCol,
                            rarityGradient=rarGradient, rarityStroke=rarStroke,
                            index=index, traits=entry.Traits,
                        }
                        end
                    end
                end
            end
        end
    end
    vpWorld.Parent = vp
    if oldWorld then
        if _keepOldWorld then _transitionOldWorld = oldWorld
        else pcall(function() oldWorld:Destroy() end) end
    end
    floorLbl.Text="FLOOR "..fnum
    if buildLabelObjs and not _inTransition then buildLabelObjs() end
end
local function updateCamera()
    vpCam.CFrame = CFrame.lookAt(baseState.camPos, baseState.camTarget)
    vpCam.FieldOfView = 60
    if updateLabels then pcall(updateLabels) end
end
local VIEWS = {
    front = { pos=Vector3.new(0,31,10),  tgt=Vector3.new(0,4,-37) },
    left  = { pos=Vector3.new(14,9,-36), tgt=Vector3.new(-19,6,-36) },
    right = { pos=Vector3.new(-14,9,-36),tgt=Vector3.new(18,6,-36) },
}
local _curView="front"
setView = function(name)
    local v=VIEWS[name] or VIEWS.front
    _curView=name
    baseState.camPos=v.pos; baseState.camTarget=v.tgt
    updateCamera()
end
resetCamera = function() setView("front") end
local _labelObjs={}
function buildLabelObjs()
    for _,o in ipairs(labelOverlay:GetChildren()) do if o:IsA("Frame") then o:Destroy() end end
    _labelObjs={}
    for _,L in ipairs(baseState.labels) do
        local holder=Instance.new("Frame",labelOverlay); holder.BackgroundTransparency=1; holder.ZIndex=63
        holder.AnchorPoint=Vector2.new(0.5,1)
        local _baseSize
        if L.kind=="slot" then
            holder.Size=UDim2.fromOffset(34,34); _baseSize=Vector2.new(34,34)
            local panel=Instance.new("Frame",holder); panel.Size=UDim2.fromScale(1,1)
            panel.BackgroundColor3=Color3.fromRGB(8,8,12); panel.BackgroundTransparency=0.4; panel.BorderSizePixel=0; panel.ZIndex=63
            round(panel,8); local g=Instance.new("UIStroke",panel); g.Color=C.ACCENT; g.Thickness=2; g.Transparency=0.4
            local num=Instance.new("TextLabel",panel); num.Size=UDim2.fromScale(1,1); num.BackgroundTransparency=1
            num.Text=L.text; num.Font=Enum.Font.FredokaOne; num.TextSize=15; num.TextColor3=Color3.new(1,1,1); num.ZIndex=64
            local ns=Instance.new("UIStroke",num); ns.Color=C.ACCENT; ns.Thickness=1.5
        else
            holder.Size=UDim2.fromOffset(150,66); _baseSize=Vector2.new(150,66)
            local built=false
            if OverheadTemplate and AnimalOverheadCtrl and Trove then
                local ok=pcall(function()
                    local ov=OverheadTemplate:Clone()
                    AnimalOverheadCtrl:Populate({
                        Overhead=ov, Index=L.index, Traits=L.traits, Mutation=L.mutation,
                        Player=LocalPlayer, Trove=Trove.new(), HidePrice=true, HideRarity=false,
                    })
                    if setthreadidentity then pcall(setthreadidentity, 8) end
                    local genLbl = ov:FindFirstChild("Generation", true)
                    if genLbl and genLbl:IsA("TextLabel") then genLbl.Text = L.gen; genLbl.Visible = true end
                    for _,ch in ipairs(ov:GetChildren()) do ch.Parent=holder end
                    ov:Destroy()
                    built=true
                end)
                if not ok then built=false end
            end
            if not built then
                local list=Instance.new("UIListLayout",holder); list.SortOrder=Enum.SortOrder.LayoutOrder
                list.HorizontalAlignment=Enum.HorizontalAlignment.Center; list.VerticalAlignment=Enum.VerticalAlignment.Bottom
                local function line(text,order,sz,col)
                    local t=Instance.new("TextLabel",holder); t.Size=UDim2.new(1,0,0,sz or 14); t.BackgroundTransparency=1
                    t.Font=Enum.Font.FredokaOne; t.Text=text; t.TextSize=sz or 14; t.TextColor3=col or Color3.new(1,1,1); t.LayoutOrder=order
                    Instance.new("UIStroke",t)
                end
                if L.mutation then line(L.mutation, 0, 13, mutColor(L.mutation)) end
                line(L.name, 1, 16, Color3.new(1,1,1))
                if L.rarity then line(L.rarity, 2, 13, L.rarityColor or Color3.new(1,1,1)) end
                line(L.gen, 3, 14, Color3.fromRGB(255,247,0))
            end
        end
        _labelObjs[#_labelObjs+1]={obj=holder, world=L.world, track=L.track, trackYOffset=L.trackYOffset, trackAttachment=L.trackAttachment, baseSize=_baseSize or Vector2.new(holder.Size.X.Offset, holder.Size.Y.Offset)}
    end
end
local function projectToViewportZ(worldPos, camCF, fov, viewSize)
    if viewSize.X<1 or viewSize.Y<1 then return nil end
    local rel=camCF:PointToObjectSpace(worldPos); if rel.Z>=0 then return nil end
    local aspect=viewSize.X/viewSize.Y; local tanHalf=math.tan(math.rad(fov)/2)
    local ndcX=(rel.X/-rel.Z)/(tanHalf*aspect); local ndcY=(rel.Y/-rel.Z)/tanHalf
    return Vector2.new((ndcX*0.5+0.5)*viewSize.X, (1-(ndcY*0.5+0.5))*viewSize.Y), -rel.Z
end
local function projectToViewport(worldPos, camCF, fov, viewSize)
    if viewSize.X < 1 or viewSize.Y < 1 then return nil end
    local rel = camCF:PointToObjectSpace(worldPos)
    if rel.Z >= 0 then return nil end
    local aspect = viewSize.X / viewSize.Y
    local tanHalf = math.tan(math.rad(fov)/2)
    local ndcX = (rel.X / -rel.Z) / (tanHalf * aspect)
    local ndcY = (rel.Y / -rel.Z) / tanHalf
    local sx = (ndcX * 0.5 + 0.5) * viewSize.X
    local sy = (1 - (ndcY * 0.5 + 0.5)) * viewSize.Y
    return Vector2.new(sx, sy)
end
function updateLabels()
  pcall(function()
    if #_labelObjs==0 then return end
    local vs = vpHolder.AbsoluteSize
    local camCF = vpCam.CFrame
    local fov = vpCam.FieldOfView
    for _,e in ipairs(_labelObjs) do
        local worldPos = e.world
        if e.trackAttachment and e.trackAttachment.Parent then
            local ok, wp = pcall(function() return e.trackAttachment.WorldPosition end)
            if ok then worldPos = wp + Vector3.new(0, 1.2, 0) end
        elseif e.track and e.track.Parent then
            local ok, piv = pcall(function() return e.track:GetPivot() end)
            if ok then worldPos = (piv * CFrame.new(0, e.trackYOffset or 0, 0)).Position end
        end
        local p, depth = projectToViewportZ(worldPos, camCF, fov, vs)
        if p and depth then
            e.obj.Visible=true
            local inv = 1 / (BASE_UI_SCALE > 0 and BASE_UI_SCALE or 1)
            e.obj.Position=UDim2.fromOffset(p.X*inv, p.Y*inv)
            local scale = math.clamp(45/depth, 0.3, 1.3)
            if e.baseSize then
                e.obj.Size = UDim2.fromOffset(math.floor(e.baseSize.X*scale), math.floor(e.baseSize.Y*scale))
            end
        else
            e.obj.Visible=false
        end
    end
  end)
end
do
    UserInputService.InputChanged:Connect(function(i)
        if not (basePanel and basePanel.Visible) then return end
        if i.UserInputType==Enum.UserInputType.MouseWheel then
            local m=UserInputService:GetMouseLocation()
            local ap,as=vpHolder.AbsolutePosition, vpHolder.AbsoluteSize
            if m.X>=ap.X and m.X<=ap.X+as.X and m.Y>=ap.Y and m.Y<=ap.Y+as.Y then
                local dir=(baseState.camPos-baseState.camTarget)
                local dist=dir.Magnitude
                if dist>0 then
                    dir=dir.Unit
                    local newDist=math.clamp(dist - i.Position.Z*4, 14, 90)
                    baseState.camPos=baseState.camTarget + dir*newDist
                    updateCamera()
                end
            end
        end
    end)
    RunService.RenderStepped:Connect(function()
        if not (basePanel and basePanel.Visible and alive()) then return end
        if updateLabels then updateLabels() end
    end)
end
local _switching=false
local function switchFloor(fnum)
    if _switching or fnum==baseState.selected then return end
    if not baseState.floorsPresent[fnum] then return end
    local prevFloor = baseState.selected
    _switching=true
    baseState.selected=fnum
    for f,d in pairs(floorDots) do
        if d.Visible then
            d.TextColor3 = (f==fnum) and C.TEXT or C.OFF_TEXT
            tw(d,0.14,{BackgroundColor3=(f==fnum) and C.ACCENT2 or C.SURF2})
        end
    end
    updateSliderFill()
    task.spawn(function()
        local goingUp = fnum > prevFloor
        local TRAVEL = 90
        local dir = goingUp and -1 or 1
        if labelOverlay then labelOverlay.Visible=false end
        _inTransition = true
        _keepOldWorld = true
        buildFloorScene(fnum)
        _keepOldWorld = false
        local oldWorld = _transitionOldWorld
        _transitionOldWorld = nil
        local newInsts = {}
        for _,inst in ipairs(vpWorld:GetChildren()) do newInsts[#newInsts+1]=inst end
        local oldInsts = {}
        if oldWorld then for _,inst in ipairs(oldWorld:GetChildren()) do oldInsts[#oldInsts+1]=inst end end
        for _,inst in ipairs(newInsts) do
            pcall(function() inst:PivotTo(inst:GetPivot()+Vector3.new(0, -dir*TRAVEL, 0)) end)
        end
        local steps=22
        local function ease(t) return 1-(1-t)^3 end
        for s=1,steps do
            local moved = (ease(s/steps)-ease((s-1)/steps)) * TRAVEL
            for _,inst in ipairs(oldInsts) do pcall(function() inst:PivotTo(inst:GetPivot()+Vector3.new(0, dir*moved, 0)) end) end
            for _,inst in ipairs(newInsts) do pcall(function() inst:PivotTo(inst:GetPivot()+Vector3.new(0, dir*moved, 0)) end) end
            task.wait()
        end
        if oldWorld then pcall(function() oldWorld:Destroy() end) end
        _inTransition = false
        if buildLabelObjs then pcall(buildLabelObjs) end
        if labelOverlay then labelOverlay.Visible=true end
        _switching=false
    end)
end
for fnum,d in pairs(floorDots) do d.MouseButton1Click:Connect(function() switchFloor(fnum) end) end
function openBasePanel(ownerName)
    local chan, data = plotChannelForOwner(ownerName)
    local plots=workspace:FindFirstChild("Plots")
    baseState.plotInst = plots and chan and plots:FindFirstChild(chan) or nil
    baseState.animalList = (type(data)=="table" and type(data.AnimalList)=="table") and data.AnimalList or {}
    bpTitle.Text = ownerName and ownerName:upper() or "THEIR BASE"
    baseState.floorsPresent={}
    if baseState.plotInst then
        local podiums=baseState.plotInst:FindFirstChild("AnimalPodiums")
        if podiums then
            for _,pod in ipairs(podiums:GetChildren()) do
                local n=tonumber(pod.Name)
                if n then baseState.floorsPresent[n<=10 and 1 or n<=18 and 2 or 3]=true end
            end
        end
    end
    for slot=1,28 do
        local e=baseState.animalList[slot]
        if type(e)=="table" and e.Index and e.Index~="Empty" then
            baseState.floorsPresent[slot<=10 and 1 or slot<=18 and 2 or 3]=true
        end
    end
    local present={}
    for f=1,3 do if baseState.floorsPresent[f] then present[#present+1]=f end end
    baseState.presentList=present
    layoutFloorSelector(present)
    baseState.selected = present[1] or 1
    baseState.camPos=Vector3.new(0,32,8); baseState.camTarget=Vector3.new(0,4,-37)
    buildFloorScene(baseState.selected)
    updateCamera()
    for _,f in ipairs(present) do
        local d=floorDots[f]
        if d then d.TextColor3 = (f==baseState.selected) and C.TEXT or C.OFF_TEXT
            d.BackgroundColor3 = (f==baseState.selected) and C.ACCENT2 or C.SURF2 end
    end
    updateSliderFill()
    basePanel.Visible=true
end
local _partnerName=nil
local function parsePartner()
    local pg=LocalPlayer:FindFirstChild("PlayerGui"); if not pg then return nil end
    local tlt=pg:FindFirstChild("TradeLiveTrade"); if not tlt then return nil end
    local u=tlt:FindFirstChild("TradeLiveTrade")
    local other=u and u:FindFirstChild("Other")
    local un=other and other:FindFirstChild("Username")
    if un and un:IsA("TextLabel") then return tostring(un.Text):match("@([%w_]+)") end
    return nil
end
local function styleHeaderBtn(b, label, baseCol, pressCol)
    b.AutoButtonColor=false; b.Image="rbxasset://textures/ui/GuiImagePlaceholder.png"; b.ImageTransparency=1
    b.BackgroundColor3=baseCol; b.BackgroundTransparency=0; b.BorderSizePixel=0
    local us=Instance.new("UIStroke",b); us.Color=Color3.new(0,0,0); us.Thickness=1.41; us.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local txt=Instance.new("TextLabel",b); txt.Name="Txt"; txt.BackgroundTransparency=1
    txt.Size=UDim2.new(0.92,0,0.72,0); txt.AnchorPoint=Vector2.new(0.5,0.5); txt.Position=UDim2.fromScale(0.5,0.5)
    txt.Font=Enum.Font.FredokaOne; txt.Text=label; txt.TextScaled=true; txt.TextColor3=Color3.new(1,1,1); txt.ZIndex=b.ZIndex+1
    local ts=Instance.new("UIStroke",txt); ts.Color=Color3.new(0,0,0); ts.Thickness=1.41
    b.MouseButton1Down:Connect(function() tw(b,0.08,{BackgroundColor3=pressCol}) end)
    b.MouseButton1Up:Connect(function() tw(b,0.12,{BackgroundColor3=baseCol}) end)
    return txt
end
local _friendConn=nil
local function attachShowBaseButton()
    if setthreadidentity then pcall(setthreadidentity, 8) end
    local pg=LocalPlayer:FindFirstChild("PlayerGui"); if not pg then return end
    local tlt=pg:FindFirstChild("TradeLiveTrade"); if not tlt then return end
    local inner=tlt:FindFirstChild("TradeLiveTrade"); if not inner then return end
    local header=inner:FindFirstChild("Header"); if not header then return end
    local old=header:FindFirstChild("IdontlogShowBase"); if old then old:Destroy() end
    local oldF=header:FindFirstChild("IdontlogFriend"); if oldF then oldF:Destroy() end
    local baseCol=Color3.fromRGB(64,120,196); local basePress=Color3.fromRGB(46,92,158)
    local b=Instance.new("ImageButton",header); b.Name="IdontlogShowBase"
    b.AnchorPoint=Vector2.new(1,0.5); b.Size=UDim2.new(0.155,0,0.62,0); b.Position=UDim2.new(0.775,0,0.5,0)
    b.ZIndex=(header.ZIndex or 1)+5
    styleHeaderBtn(b,"SHOW BASE",baseCol,basePress)
    b.MouseButton1Click:Connect(function()
        if not _partnerName then return end
        if basePanel.Visible then basePanel.Visible=false
        else openBasePanel(_partnerName) end
    end)
    showBaseBtn=b
    local partnerPlayer = _partnerName and Players:FindFirstChild(_partnerName)
    if partnerPlayer then
        local fCol=Color3.fromRGB(70,170,90); local fPress=Color3.fromRGB(52,130,68)
        local fb=Instance.new("ImageButton",header); fb.Name="IdontlogFriend"
        fb.AnchorPoint=Vector2.new(1,0.5); fb.Size=UDim2.new(0.12,0,0.62,0); fb.Position=UDim2.new(0.905,0,0.5,0)
        fb.ZIndex=(header.ZIndex or 1)+5
        local ftxt=styleHeaderBtn(fb,"FRIEND",fCol,fPress)
        local function applyStatus(status)
            if setthreadidentity then pcall(setthreadidentity, 8) end
            pcall(function()
                if status==Enum.FriendStatus.Friend then fb.Visible=false
                elseif status==Enum.FriendStatus.FriendRequestSent then ftxt.Text="SENT"; fb.BackgroundColor3=Color3.fromRGB(120,120,120)
                elseif status==Enum.FriendStatus.FriendRequestReceived then ftxt.Text="ACCEPT"; fb.BackgroundColor3=fCol
                else ftxt.Text="FRIEND"; fb.BackgroundColor3=fCol; fb.Visible=true end
            end)
        end
        local ok0,status0=pcall(function() return LocalPlayer:GetFriendStatus(partnerPlayer) end)
        if ok0 then applyStatus(status0) end
        if _friendConn then pcall(function() _friendConn:Disconnect() end) end
        _friendConn = LocalPlayer.FriendStatusChanged:Connect(function(plr, status)
            if plr==partnerPlayer and fb and fb.Parent then applyStatus(status) end
        end)
        fb.MouseButton1Click:Connect(function()
            local ok,status=pcall(function() return LocalPlayer:GetFriendStatus(partnerPlayer) end)
            if ok and status==Enum.FriendStatus.Friend then return end
            pcall(function() LocalPlayer:RequestFriendship(partnerPlayer) end)
        end)
    end
    return b
end
local function removeShowBaseButton()
    local pg=LocalPlayer:FindFirstChild("PlayerGui"); if not pg then return end
    local tlt=pg:FindFirstChild("TradeLiveTrade"); local inner=tlt and tlt:FindFirstChild("TradeLiveTrade")
    local header=inner and inner:FindFirstChild("Header")
    if header then
        local o1=header:FindFirstChild("IdontlogShowBase"); if o1 then o1:Destroy() end
        local o2=header:FindFirstChild("IdontlogFriend"); if o2 then o2:Destroy() end
    end
    if _friendConn then pcall(function() _friendConn:Disconnect() end); _friendConn=nil end
    showBaseBtn=nil
end
task.spawn(function()
    local pg=LocalPlayer:WaitForChild("PlayerGui",30); if not pg then return end
    local wasActive=false
    local function isTradeActive()
        local tlt=pg:FindFirstChild("TradeLiveTrade")
        if not tlt then return false end
        if tlt.Enabled==false then return false end
        local inner=tlt:FindFirstChild("TradeLiveTrade")
        if inner and inner:IsA("GuiObject") then return inner.Visible end
        return tlt.Enabled
    end
    while screen.Parent and alive() do
        local active=isTradeActive()
        if active and not wasActive then
            pcall(clearFeed)
            replyBox.Text=""; previewBox.Text=""; pvPlaceholder.Visible=true; pvTag.Visible=false; _translatedOut=""
            _partnerName=parsePartner()
            if _partnerName and plotChannelForOwner(_partnerName) then
                pcall(attachShowBaseButton)
            end
        elseif not active and wasActive then
            pcall(clearFeed)
            replyBox.Text=""; previewBox.Text=""; pvPlaceholder.Visible=true; pvTag.Visible=false; _translatedOut=""
            _partnerName=nil; pcall(removeShowBaseButton); basePanel.Visible=false
        end
        if active then
            _partnerName=parsePartner()
            if _partnerName and not showBaseBtn and plotChannelForOwner(_partnerName) then
                pcall(attachShowBaseButton)
            end
        end
        wasActive=active
        task.wait(0.5)
    end
end)