local Plrs = game:GetService("Players")
local RS   = game:GetService("ReplicatedStorage")
local TS   = game:GetService("TweenService")
local UIS  = game:GetService("UserInputService")
local HS   = game:GetService("HttpService")

local LP = Plrs.LocalPlayer
local PG = LP:WaitForChild("PlayerGui", 10)

local R_NEW, R_CLAIM, R_TRADE, R_SEARCH
local UUID_T = "afb005f9-6e81-4e0a-8bb0-3555938a9658"
local UUID_S = "792baf13-54a1-4663-92c4-1edd9da1e3e2"

local function scanRemotes()
    local ok, Net = pcall(function()
        return RS:WaitForChild("Packages",8):WaitForChild("Net",8)
    end)
    if not ok or not Net then return end
    local ch = Net:GetChildren()
    for i = 1, #ch - 1 do
        local a, b = ch[i], ch[i+1]
        if a and b then
            local n = a.Name
            if n:find("Liveboard") and n:find("NewEntry")   then R_NEW    = b end
            if n:find("Liveboard") and n:find("ClaimEntry") then R_CLAIM  = b end
            if n:find("TradeService") and n:find("Invite")  then R_TRADE  = b end
            if n:find("TradeService") and n:find("Search")  then R_SEARCH = b end
        end
    end
end
task.defer(scanRemotes)

local Animals = {}
pcall(function()
    local mod = RS:FindFirstChild("Datas") and RS.Datas:FindFirstChild("Animals")
    if mod then local ok2,r = pcall(require,mod); if ok2 and type(r)=="table" then Animals=r end end
end)

-- ── WEBHOOKS ─────────────────────────────────────────────────
local WEBHOOKS = {
    ["Skibidi Toilet"]       = "https://discord.com/api/webhooks/1503071541259141292/XUkMm9D8NuPj7pZ2f50t3T9tveMib8G2faENKXLbcXHpqIPpLrKbOQq6jDbHtfxQRvQa",
    ["John Pork"]            = "https://discord.com/api/webhooks/1503071643600421015/reseE0-qHm7zwbuhohRkO8hF-wsNj8bb9ZV0NihG3FsDQEjJBIBXeq1iho6jixa1sUjV",
    ["Meowl"]                = "https://discord.com/api/webhooks/1503071687711658009/HyMsTDmyLVeOqrWGsKXWFLrQiJunjwDUb3Z7lg3al7LgDSUMhjenMfawbo9FJhKHBXdE",
    ["Strawberry Elephant"]  = "https://discord.com/api/webhooks/1503071732246904872/HW6ffWuhxdRpSFJaCm4Tkws-OOFM9ivFetBX-8jvh3PjXNwO1amBrD062G__qOrj7KTI",
}
local webhookSent = {}

local function sendWebhook(ogName, username, userId, mutation, isLocalServer)
    local url = WEBHOOKS[ogName]
    if not url then return end
    local key = ogName .. tostring(userId)
    if webhookSent[key] then return end
    webhookSent[key] = true

    local profileUrl = "https://www.roblox.com/users/" .. tostring(userId) .. "/profile"
    local mutStr     = (mutation and mutation ~= "Default" and mutation ~= "Normal") and mutation or "Normal"
    local serverStr  = isLocalServer and "Same server as you" or "Different server"

    local embed = {
        title       = "OG SNIPED — " .. ogName,
        description = "**" .. username .. "** just claimed a **" .. ogName .. "**\n"
                   .. "[View Profile & Add Friend](" .. profileUrl .. ")",
        color       = 0xFF6EB4,
        fields = {
            { name = "Player",   value = "[" .. username .. "](" .. profileUrl .. ")", inline = true  },
            { name = "Mutation", value = mutStr,    inline = true  },
            { name = "Server",   value = serverStr, inline = true  },
            { name = "User ID",  value = tostring(userId),         inline = true  },
            { name = "Profile",  value = "[Click to view / add friend](" .. profileUrl .. ")", inline = false },
        },
        footer    = { text = "🌸 TRACED • " .. os.date("%H:%M:%S") },
        thumbnail = { url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(userId) .. "&width=150&height=150&format=png" },
    }

    task.spawn(function()
        local body = HS:JSONEncode({ content = "@everyone", embeds = { embed }, username = "TRACED" })
        local reqFn = (syn and syn.request) or (http and http.request) or (request) or (http_request) or nil
        if reqFn then
            pcall(reqFn, {
                Url     = url,
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = body,
            })
        end
    end)
end

-- ── CLIPBOARD ────────────────────────────────────────────────
local function copyText(s)
    if type(s) ~= "string" then return false end
    local env = (getfenv and getfenv(0)) or {}
    local names = { "setclipboard","toclipboard","Clipboard","clipboard","copy","Set_Clipboard" }
    for _, name in ipairs(names) do
        local fn = env[name]
        if type(fn) == "function" then if pcall(fn, s) then return true end end
    end
    for _, name in ipairs(names) do
        local fn = rawget(_G, name)
        if type(fn) == "function" then if pcall(fn, s) then return true end end
    end
    if syn and type(syn.write_clipboard) == "function" then
        if pcall(syn.write_clipboard, s) then return true end
    end
    for k, v in pairs(_G) do
        if type(k)=="string" and k:lower():find("clip") and type(v)=="function" then
            if pcall(v, s) then return true end
        end
    end
    return false
end

-- ── SOUNDS ───────────────────────────────────────────────────
local SndFolder
local function getSndFolder()
    if SndFolder and SndFolder.Parent then return SndFolder end
    local char = LP.Character or LP.CharacterAdded:Wait()
    SndFolder = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart") or char
    return SndFolder
end
local function mkSnd(id, vol, pitch)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://"..id; s.Volume = vol or 0.8
    s.PlaybackSpeed = pitch or 1; s.RollOffMaxDistance = 0
    s.Parent = getSndFolder(); return s
end
local SND = {
    og   = mkSnd("9119713951", 1,    1.3),
    norm = mkSnd("9119713951", 0.7,  0.95),
    log  = mkSnd("9119713951", 0.75, 1.08),
    tr   = mkSnd("9119713951", 0.65, 1.0),
}
local function psnd(s) pcall(function() s:Stop(); s:Play() end) end

-- ── HOST GUI ─────────────────────────────────────────────────
local HostGui
local function getHostGui()
    if HostGui and HostGui.Parent then return HostGui end
    local sg = Instance.new("ScreenGui")
    sg.Name = LP.Name.."_TRACED"; sg.ResetOnSpawn = false
    sg.DisplayOrder = 99; sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = PG; HostGui = sg; return sg
end

-- ── RAINBOW ──────────────────────────────────────────────────
local RBC = {
    Color3.fromRGB(255,80,80),  Color3.fromRGB(255,180,40),
    Color3.fromRGB(80,255,100), Color3.fromRGB(40,180,255),
    Color3.fromRGB(180,80,255), Color3.fromRGB(255,80,200),
}
local rbBg = {}
task.spawn(function()
    local i = 0
    while true do
        task.wait(); i = (i + 0.023) % #RBC
        local idx = math.floor(i)+1; local nxt = (idx % #RBC)+1
        local c = RBC[idx]:Lerp(RBC[nxt], i - math.floor(i))
        for k = #rbBg, 1, -1 do
            local f = rbBg[k]
            if f and f.Parent then f.BackgroundColor3 = c else table.remove(rbBg, k) end
        end
    end
end)

-- ── SAKURA PALETTE ───────────────────────────────────────────
local K = {
    bg    = Color3.fromRGB(14,  5,  12),
    bg1   = Color3.fromRGB(22,  8,  18),
    bg2   = Color3.fromRGB(30,  11, 24),
    bg3   = Color3.fromRGB(42,  15, 34),
    bg4   = Color3.fromRGB(58,  20, 46),
    bg5   = Color3.fromRGB(72,  26, 58),
    line  = Color3.fromRGB(65,  22, 50),
    bdr   = Color3.fromRGB(65,  22, 50),
    bdr2  = Color3.fromRGB(110, 45, 85),
    txt   = Color3.fromRGB(255, 240, 248),
    txt2  = Color3.fromRGB(200, 155, 185),
    txt3  = Color3.fromRGB(115, 65,  95),
    white = Color3.fromRGB(255, 240, 248),
    black = Color3.fromRGB(14,  5,  12),
    gold  = Color3.fromRGB(255, 210, 100),
    ok    = Color3.fromRGB(100, 215, 130),
    err   = Color3.fromRGB(255, 90,  110),
    acc   = Color3.fromRGB(255, 100, 160),
    pink  = Color3.fromRGB(255, 140, 190),
    pinkd = Color3.fromRGB(180, 50,  110),
    pinkl = Color3.fromRGB(255, 185, 220),
    send  = Color3.fromRGB(100, 215, 130),
}

-- ── TRADE ────────────────────────────────────────────────────
local tradeQueue    = {}
local tradeActive   = false
local autoSendEnabled = false

local function processQueue()
    if tradeActive then return end
    tradeActive = true
    task.spawn(function()
        while #tradeQueue > 0 do
            local item = table.remove(tradeQueue, 1)
            local uid, btn = item.uid, item.btn
            if btn and btn.Parent then btn.Text = "…" end
            if R_TRADE then
                local ok, res = pcall(function() return R_TRADE:InvokeServer(UUID_T, uid) end)
                psnd(SND.tr)
                if btn and btn.Parent then
                    if ok and res then
                        btn.Text = "SENT"
                        btn.BackgroundColor3 = Color3.fromRGB(40,185,80)
                        btn.TextColor3 = Color3.new(1,1,1)
                        task.delay(2, function()
                            if btn and btn.Parent then
                                btn.Text = "SEND"
                                btn.BackgroundColor3 = Color3.fromRGB(28,8,22)
                                btn.TextColor3 = K.pinkl
                            end
                        end)
                    else
                        btn.Text = "✗"
                        task.delay(2, function()
                            if btn and btn.Parent and btn.Text == "✗" then
                                btn.Text = "SEND"
                                btn.BackgroundColor3 = Color3.fromRGB(28,8,22)
                                btn.TextColor3 = K.pinkl
                            end
                        end)
                    end
                end
            else
                if btn and btn.Parent then btn.Text = "SEND" end
            end
        end
        tradeActive = false
    end)
end

local function doTrade(uid, name, btn)
    if not uid then return end
    table.insert(tradeQueue, {uid=uid, name=name, btn=btn})
    processQueue()
end

-- ── DATA ─────────────────────────────────────────────────────
local RARITY_STRIP = {
    Common=Color3.fromRGB(100,100,100),   Uncommon=Color3.fromRGB(34,197,94),
    Rare=Color3.fromRGB(59,130,246),      Epic=Color3.fromRGB(168,85,247),
    Legendary=Color3.fromRGB(234,179,8),  Mythical=Color3.fromRGB(239,68,68),
    OG=Color3.fromRGB(255,140,190),       Unknown=Color3.fromRGB(70,70,70),
}
local RARITY_C = {
    Common=Color3.fromRGB(140,140,140),   Uncommon=Color3.fromRGB(74,222,128),
    Rare=Color3.fromRGB(96,165,250),      Epic=Color3.fromRGB(192,132,252),
    Legendary=Color3.fromRGB(234,179,8),  Mythical=Color3.fromRGB(248,113,113),
    OG=Color3.fromRGB(255,150,210),       Unknown=Color3.fromRGB(120,120,120),
}
local MUTS = {
    Default     = {c=Color3.fromRGB(180,180,180),  l="DEFAULT",    rb=false},
    Gold        = {c=Color3.fromRGB(234,179,8),    l="GOLD",       rb=false},
    Diamond     = {c=Color3.fromRGB(147,197,253),  l="DIAMOND",    rb=false},
    Rainbow     = {c=Color3.fromRGB(255,80,220),   l="RAINBOW",    rb=true},
    Bloodrot    = {c=Color3.fromRGB(185,28,28),    l="BLOODROT",   rb=false},
    Candy       = {c=Color3.fromRGB(244,114,182),  l="CANDY",      rb=false},
    Celestial   = {c=Color3.fromRGB(196,181,253),  l="CELESTIAL",  rb=false},
    Lava        = {c=Color3.fromRGB(249,115,22),   l="LAVA",       rb=false},
    Galaxy      = {c=Color3.fromRGB(139,92,246),   l="GALAXY",     rb=false},
    YinYang     = {c=Color3.fromRGB(210,210,210),  l="YIN YANG",   rb=false},
    Radioactive = {c=Color3.fromRGB(132,204,22),   l="RADIOACT",   rb=false},
    Cursed      = {c=Color3.fromRGB(88,28,135),    l="CURSED",     rb=false},
    Divine      = {c=Color3.fromRGB(254,240,138),  l="DIVINE",     rb=false},
    Cyber       = {c=Color3.fromRGB(34,211,238),   l="CYBER",      rb=false},
    Strawberry  = {c=Color3.fromRGB(244,63,94),    l="STRAWBERRY", rb=false},
    Crystal     = {c=Color3.fromRGB(186,230,253),  l="CRYSTAL",    rb=false},
    Shadow      = {c=Color3.fromRGB(124,58,237),   l="SHADOW",     rb=false},
    Inferno     = {c=Color3.fromRGB(249,115,22),   l="INFERNO",    rb=false},
    Void        = {c=Color3.fromRGB(67,20,160),    l="VOID",       rb=false},
    Neon        = {c=Color3.fromRGB(0,255,120),    l="NEON",       rb=false},
    Ice         = {c=Color3.fromRGB(186,230,253),  l="ICE",        rb=false},
}
local MUT0 = {c=Color3.fromRGB(115,65,95), l="NORMAL", rb=false}

local OGS = {
    {k="Skibidi Toilet",      l="SKIBIDI", i="🚽", c=Color3.fromRGB(56,189,248)},
    {k="John Pork",           l="J.PORK",  i="🐷", c=Color3.fromRGB(251,146,60)},
    {k="Strawberry Elephant", l="S.ELEPH", i="🍓", c=Color3.fromRGB(244,114,182)},
    {k="Meowl",               l="MEOWL",   i="🦉", c=Color3.fromRGB(192,132,252)},
}
local PRIO = {
    ["Strawberry Elephant"]=100, ["John Pork"]=95,
    ["Meowl"]=90, ["Skibidi Toilet"]=80, ["Strawberry"]=100,
}
local ogLogs = {}
for _, s in ipairs(OGS) do ogLogs[s.k] = {} end

-- ── HELPERS ──────────────────────────────────────────────────
local function grar(n) local a = Animals[n]; return a and a.Rarity or "Common" end
local function gmut(m) return (m and MUTS[m]) or MUT0 end
local function ft() return os.date("%H:%M:%S", os.time()) end
local function tw(o,t,g)  TS:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),g):Play() end
local function twB(o,t,g) TS:Create(o,TweenInfo.new(t,Enum.EasingStyle.Back,Enum.EasingDirection.Out),g):Play() end
local function mk(cls,p) local o=Instance.new(cls); if p then o.Parent=p end; return o end
local function corner(r,p) Instance.new("UICorner",p).CornerRadius = UDim.new(0,r) end
local function stroke(p, col, thick, trans)
    local s = Instance.new("UIStroke",p)
    s.Color=col or K.bdr; s.Thickness=thick or 1; s.Transparency=trans or 0; return s
end
local function label(txt, size, font, col, xalign, par)
    local l = mk("TextLabel",par); l.BackgroundTransparency=1; l.Text=txt or ""
    l.TextSize=size or 11; l.Font=font or Enum.Font.Gotham
    l.TextColor3=col or K.txt; l.TextXAlignment=xalign or Enum.TextXAlignment.Left; return l
end
local function pad(p,top,bot,left,right)
    local u = mk("UIPadding",p)
    u.PaddingTop=UDim.new(0,top or 0); u.PaddingBottom=UDim.new(0,bot or top or 0)
    u.PaddingLeft=UDim.new(0,left or top or 0); u.PaddingRight=UDim.new(0,right or left or top or 0)
end

local SG = getHostGui()

-- ── WATERMARK ────────────────────────────────────────────────
local WM = mk("Frame", SG)
WM.Size=UDim2.new(0,260,0,40); WM.Position=UDim2.new(0.5,-130,0,10)
WM.BackgroundColor3=K.bg1; WM.BorderSizePixel=0; WM.ZIndex=100; corner(22,WM)
local wmGrad = Instance.new("UIGradient",WM)
wmGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,  Color3.fromRGB(22,8,18)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(42,15,34)),
    ColorSequenceKeypoint.new(1,  Color3.fromRGB(22,8,18)),
}
wmGrad.Rotation = 90
local wmStroke = Instance.new("UIStroke",WM)
wmStroke.Thickness=1.5; wmStroke.Color=K.pink; wmStroke.Transparency=0.3
local wmGradStroke = Instance.new("UIGradient",wmStroke)
wmGradStroke.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,  Color3.fromRGB(60,5,40)),
    ColorSequenceKeypoint.new(0.4,Color3.fromRGB(200,70,130)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,140,190)),
    ColorSequenceKeypoint.new(0.6,Color3.fromRGB(200,70,130)),
    ColorSequenceKeypoint.new(1,  Color3.fromRGB(60,5,40)),
}
task.spawn(function()
    local r = 0
    while WM and WM.Parent do task.wait(0.025); r=(r+1.2)%360; wmGradStroke.Rotation=r end
end)
-- blossom dot
local wmDot = mk("Frame",WM)
wmDot.Size=UDim2.new(0,8,0,8); wmDot.AnchorPoint=Vector2.new(0,0.5)
wmDot.Position=UDim2.new(0,14,0.5,0); wmDot.BackgroundColor3=K.pink
wmDot.BorderSizePixel=0; wmDot.ZIndex=101; corner(4,wmDot)
task.spawn(function()
    while wmDot and wmDot.Parent do
        tw(wmDot,0.8,{BackgroundTransparency=0.6}); task.wait(0.9)
        tw(wmDot,0.8,{BackgroundTransparency=0});   task.wait(0.9)
    end
end)
local wmTitle = label("🌸 TRACED",13,Enum.Font.GothamBlack,K.pinkl,Enum.TextXAlignment.Center,WM)
wmTitle.Size=UDim2.new(1,-48,1,0); wmTitle.Position=UDim2.new(0,30,0,0); wmTitle.ZIndex=102
local wmVer = mk("Frame",WM)
wmVer.Size=UDim2.new(0,24,0,18); wmVer.AnchorPoint=Vector2.new(1,0.5)
wmVer.Position=UDim2.new(1,-8,0.5,0); wmVer.BackgroundColor3=K.bg3
wmVer.BorderSizePixel=0; wmVer.ZIndex=102; corner(10,wmVer); stroke(wmVer,K.bdr2,1,0)
local wmVerL = label("v2",8,Enum.Font.GothamBold,K.txt3,Enum.TextXAlignment.Center,wmVer)
wmVerL.Size=UDim2.new(1,0,1,0); wmVerL.ZIndex=103

-- ── MAIN WINDOW ──────────────────────────────────────────────
-- reduced size for "smaller and less fat"
local PW, PH   = 380, 500
local TOPBAR_H = 50
local TOPNAV_H = 46

local Main = mk("Frame",SG)
Main.Name="TRACED_MAIN"; Main.Size=UDim2.new(0,PW,0,PH)
Main.Position=UDim2.new(0,20,0.5,-PH/2)
Main.BackgroundColor3=K.bg; Main.BorderSizePixel=0
Main.ClipsDescendants=true; Main.ZIndex=10; corner(28,Main)

local mainStroke = Instance.new("UIStroke",Main)
mainStroke.Thickness=1.5; mainStroke.Color=K.pink; mainStroke.Transparency=0
local borderGrad = Instance.new("UIGradient",mainStroke)
borderGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(40,5,30)),
    ColorSequenceKeypoint.new(0.25,Color3.fromRGB(170,50,110)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,140,190)),
    ColorSequenceKeypoint.new(0.75,Color3.fromRGB(170,50,110)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(40,5,30)),
}
task.spawn(function()
    local rot = 0
    while Main and Main.Parent do task.wait(0.03); rot=(rot+0.8)%360; borderGrad.Rotation=rot end
end)

local panelGrad = Instance.new("UIGradient",Main)
panelGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(28,10,22)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(18,7,15)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(14,5,12)),
}
panelGrad.Rotation = 135

-- TOP BAR
local TopBar = mk("Frame",Main)
TopBar.Size=UDim2.new(1,0,0,TOPBAR_H); TopBar.BackgroundColor3=K.bg1
TopBar.BorderSizePixel=0; TopBar.ZIndex=11; corner(28,TopBar)
local tbGrad = Instance.new("UIGradient",TopBar)
tbGrad.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(26,9,20)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(14,5,12)),
}
tbGrad.Rotation=90

local TitleL = label("",15,Enum.Font.GothamBlack,K.pinkl,nil,TopBar)
TitleL.Size=UDim2.new(1,-120,0,22); TitleL.Position=UDim2.new(0,18,0,9); TitleL.ZIndex=12
task.spawn(function()
    local full = "🌸 TRACED"
    for i=1,#full do TitleL.Text=full:sub(1,i); task.wait(0.06) end
end)
local SubL = label("realtime og tracker",9,Enum.Font.Gotham,K.txt3,nil,TopBar)
SubL.Size=UDim2.new(1,-120,0,12); SubL.Position=UDim2.new(0,18,0,33); SubL.ZIndex=12

local CntPill = mk("Frame",TopBar)
CntPill.Size=UDim2.new(0,76,0,24); CntPill.AnchorPoint=Vector2.new(1,0.5)
CntPill.Position=UDim2.new(1,-50,0.5,0); CntPill.BackgroundColor3=K.bg3
CntPill.BorderSizePixel=0; CntPill.ZIndex=12; corner(14,CntPill); stroke(CntPill,K.bdr2,1,0)
local CntL = label("0 caught",9,Enum.Font.GothamBold,K.txt2,Enum.TextXAlignment.Center,CntPill)
CntL.Size=UDim2.new(1,0,1,0); CntL.ZIndex=13

local MinB = mk("TextButton",TopBar)
MinB.Size=UDim2.new(0,28,0,28); MinB.AnchorPoint=Vector2.new(1,0.5)
MinB.Position=UDim2.new(1,-14,0.5,0); MinB.BackgroundColor3=K.bg3
MinB.TextColor3=K.txt3; MinB.TextSize=18; MinB.Font=Enum.Font.GothamBold
MinB.Text="−"; MinB.BorderSizePixel=0; MinB.AutoButtonColor=false; MinB.ZIndex=12
corner(16,MinB); stroke(MinB,K.bdr2,1,0)
MinB.MouseEnter:Connect(function() tw(MinB,.1,{BackgroundColor3=K.bg5,TextColor3=K.pinkl}) end)
MinB.MouseLeave:Connect(function() tw(MinB,.1,{BackgroundColor3=K.bg3,TextColor3=K.txt3}) end)
local isMin = false
MinB.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then tw(Main,.2,{Size=UDim2.new(0,PW,0,TOPBAR_H)}); MinB.Text="+"
    else twB(Main,.32,{Size=UDim2.new(0,PW,0,PH)}); MinB.Text="−" end
end)

-- ── DRAG (mouse + touch) for TopBar ──────────────────────
do
    local dragging, ds, sp, dragObject = false, nil, nil, nil
    local function startDrag(input, object)
        dragging = true
        ds = input.Position
        sp = object.Position
        dragObject = object
    end
    local function updateDrag(input)
        if dragging and dragObject then
            local d = input.Position - ds
            dragObject.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end
    local function endDrag()
        dragging = false
        dragObject = nil
    end
    -- Mouse
    TopBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            startDrag(i, Main)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then
            updateDrag(i)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag()
        end
    end)
    -- Touch
    TopBar.TouchTap:Connect(function() end) -- placeholder to enable touch events
    TopBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            startDrag(i, Main)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            updateDrag(i)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)
end

-- ── DRAG for Watermark (mouse + touch) ────────────────────
do
    local dragging, ds, sp = false, nil, nil
    local function startDrag(input)
        dragging = true; ds = input.Position; sp = WM.Position
    end
    local function updateDrag(input)
        if dragging then
            local d = input.Position - ds
            WM.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end
    local function endDrag() dragging = false end
    WM.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            startDrag(i)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            updateDrag(i)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)
end

local TopDiv = mk("Frame",Main)
TopDiv.Size=UDim2.new(1,0,0,1); TopDiv.Position=UDim2.new(0,0,0,TOPBAR_H)
TopDiv.BackgroundColor3=K.line; TopDiv.BorderSizePixel=0; TopDiv.ZIndex=11

-- NAV ROW
local NavRow = mk("Frame",Main)
NavRow.Size=UDim2.new(1,0,0,TOPNAV_H); NavRow.Position=UDim2.new(0,0,0,TOPBAR_H+1)
NavRow.BackgroundColor3=K.bg1; NavRow.BorderSizePixel=0; NavRow.ZIndex=11
local NavLL = mk("UIListLayout",NavRow)
NavLL.FillDirection=Enum.FillDirection.Horizontal; NavLL.SortOrder=Enum.SortOrder.LayoutOrder
NavLL.HorizontalAlignment=Enum.HorizontalAlignment.Left; NavLL.VerticalAlignment=Enum.VerticalAlignment.Center
pad(NavRow,6,6,8,8); NavLL.Padding=UDim.new(0,4)
local NavDiv = mk("Frame",Main)
NavDiv.Size=UDim2.new(1,0,0,1); NavDiv.Position=UDim2.new(0,0,0,TOPBAR_H+1+TOPNAV_H)
NavDiv.BackgroundColor3=K.line; NavDiv.BorderSizePixel=0; NavDiv.ZIndex=11

local PAGE_Y = TOPBAR_H+1+TOPNAV_H+1
local PageArea = mk("Frame",Main)
PageArea.Size=UDim2.new(1,0,1,-PAGE_Y); PageArea.Position=UDim2.new(0,0,0,PAGE_Y)
PageArea.BackgroundTransparency=1; PageArea.BorderSizePixel=0; PageArea.ZIndex=10

local function mkPage()
    local f=mk("Frame",PageArea); f.Size=UDim2.new(1,0,1,0)
    f.BackgroundTransparency=1; f.BorderSizePixel=0; f.Visible=false; f.ZIndex=11; return f
end
local function mkScroll(par, offY)
    offY=offY or 0
    local sf=mk("ScrollingFrame",par)
    sf.Size=UDim2.new(1,0,1,-offY); sf.Position=UDim2.new(0,0,0,offY)
    sf.BackgroundTransparency=1; sf.BorderSizePixel=0; sf.ScrollBarThickness=3
    sf.ScrollBarImageColor3=K.pinkd; sf.ScrollBarImageTransparency=0.3
    sf.CanvasSize=UDim2.new(0,0,0,0); sf.AutomaticCanvasSize=Enum.AutomaticSize.Y; sf.ZIndex=12
    return sf
end
local function mkEmpty(par, txt)
    local f=mk("Frame",par); f.Size=UDim2.new(1,0,0,80)
    f.BackgroundTransparency=1; f.LayoutOrder=999999; f.ZIndex=13
    local l=label(txt,11,Enum.Font.Gotham,K.txt3,Enum.TextXAlignment.Center,f)
    l.Size=UDim2.new(1,0,1,0); l.ZIndex=14; return f
end
local function mkSubBar(par)
    local b=mk("Frame",par); b.Size=UDim2.new(1,0,0,36); b.BackgroundColor3=K.bg1
    b.BorderSizePixel=0; b.ZIndex=13
    local sep=mk("Frame",par); sep.Size=UDim2.new(1,0,0,1); sep.Position=UDim2.new(0,0,0,36)
    sep.BackgroundColor3=K.line; sep.BorderSizePixel=0; sep.ZIndex=13; return b
end

local SnipPage  = mkPage()
local LogsPage  = mkPage()
local OGPage    = mkPage()
local TradePage = mkPage()

-- NAV TABS
local TABS = {
    {id="snip", label="LIVE", lo=1},{id="logs",label="LOGS",lo=2},
    {id="og",   label="OG",   lo=3},{id="trade",label="FIND",lo=4},
}
local navBtns = {}; local activeTab = nil
local function switchTab(id)
    if activeTab==id then return end; activeTab=id
    local pages={snip=SnipPage,logs=LogsPage,og=OGPage,trade=TradePage}
    for k,f in pairs(pages) do f.Visible=(k==id) end
    for k,b in pairs(navBtns) do
        local on=(k==id)
        tw(b,.15,{BackgroundColor3=on and K.bg4 or K.bg2, TextColor3=on and K.pinkl or K.txt3})
        local ul=b:FindFirstChild("UL"); if ul then tw(ul,.15,{BackgroundTransparency=on and 0 or 1}) end
    end
end
for _,def in ipairs(TABS) do
    local b=mk("TextButton",NavRow); b.Name=def.id
    b.Size=UDim2.new(0,62,0,32); b.LayoutOrder=def.lo
    b.BackgroundColor3=K.bg2; b.TextColor3=K.txt3; b.TextSize=9
    b.Font=Enum.Font.GothamBold; b.Text=def.label; b.BorderSizePixel=0
    b.AutoButtonColor=false; b.ZIndex=12; corner(14,b); stroke(b,K.bdr,1,0.4)
    local ul=mk("Frame",b); ul.Name="UL"; ul.Size=UDim2.new(0.7,0,0,2)
    ul.AnchorPoint=Vector2.new(0.5,1); ul.Position=UDim2.new(0.5,0,1,-2)
    ul.BackgroundColor3=K.pink; ul.BackgroundTransparency=1; ul.BorderSizePixel=0; ul.ZIndex=13; corner(1,ul)
    b.MouseEnter:Connect(function() if activeTab~=def.id then tw(b,.1,{BackgroundColor3=K.bg3,TextColor3=K.txt2}) end end)
    b.MouseLeave:Connect(function() if activeTab~=def.id then tw(b,.1,{BackgroundColor3=K.bg2,TextColor3=K.txt3}) end end)
    b.MouseButton1Click:Connect(function() switchTab(def.id) end)
    navBtns[def.id]=b
end

-- ── SEND BUTTON ──────────────────────────────────────────────
local SEND_W = 68
local function mkSendBtn(par, uid, name)
    local sep=mk("Frame",par); sep.Size=UDim2.new(0,1,0.6,0)
    sep.AnchorPoint=Vector2.new(1,0.5); sep.Position=UDim2.new(1,-SEND_W,0.5,0)
    sep.BackgroundColor3=K.line; sep.BorderSizePixel=0; sep.ZIndex=15
    local b=mk("TextButton",par); b.Name="SEND_B"
    b.Size=UDim2.new(0,56,0,34)
    b.AnchorPoint=Vector2.new(1,0.5); b.Position=UDim2.new(1,-6,0.5,0)
    b.BackgroundColor3=Color3.fromRGB(28,8,22)
    b.TextColor3=K.pinkl; b.TextSize=10; b.Font=Enum.Font.GothamBold; b.Text="SEND"
    b.AutoButtonColor=false; b.ZIndex=15; b.BorderSizePixel=0
    corner(18,b); stroke(b,K.pinkd,1,0.3)
    b.MouseEnter:Connect(function()
        if b.Text=="SEND" then tw(b,.1,{BackgroundColor3=K.bg4,TextColor3=K.pink}) end
    end)
    b.MouseLeave:Connect(function()
        if b.Text=="SEND" then tw(b,.1,{BackgroundColor3=Color3.fromRGB(28,8,22),TextColor3=K.pinkl}) end
    end)
    if uid then
        b.MouseButton1Click:Connect(function()
            if b.Text~="SEND" then return end
            table.insert(tradeQueue,{uid=uid,name=name,btn=b}); processQueue()
        end)
    else
        b.Active=false; b.TextTransparency=0.5; b.BackgroundTransparency=0.5
    end
    return b
end

-- ── BADGE ────────────────────────────────────────────────────
local function mkBadge(par, txt, col, x, y, w)
    w=w or math.max(36,#txt*5+12)
    local f=mk("Frame",par); f.Size=UDim2.new(0,w,0,16); f.Position=UDim2.new(0,x,0,y)
    f.BackgroundColor3=col; f.BackgroundTransparency=0.82; f.BorderSizePixel=0; f.ZIndex=15; corner(10,f)
    local s=Instance.new("UIStroke",f); s.Color=col; s.Thickness=1; s.Transparency=0.45
    local l=label(txt,7,Enum.Font.GothamBold,col,Enum.TextXAlignment.Center,f)
    l.Size=UDim2.new(1,0,1,0); l.ZIndex=16; l.Name="BL"; return f,l
end

-- ── COPY BUTTON ──────────────────────────────────────────────
local function mkCopyBtn(par, getFn, x, y)
    local b=mk("TextButton",par); b.Size=UDim2.new(0,38,0,17); b.Position=UDim2.new(0,x,0,y)
    b.BackgroundColor3=K.bg3; b.TextColor3=K.txt3; b.TextSize=7; b.Font=Enum.Font.GothamBold
    b.Text="COPY"; b.BorderSizePixel=0; b.AutoButtonColor=false; b.ZIndex=16
    corner(10,b); stroke(b,K.bdr,1,0)
    b.MouseEnter:Connect(function() tw(b,.1,{BackgroundColor3=K.bg4,TextColor3=K.txt2}) end)
    b.MouseLeave:Connect(function() tw(b,.1,{BackgroundColor3=K.bg3,TextColor3=K.txt3}) end)
    b.MouseButton1Click:Connect(function()
        local ok=copyText(getFn())
        if ok then
            b.Text="OK!"; b.TextColor3=K.pinkl; b.BackgroundColor3=Color3.fromRGB(28,8,22)
        else
            b.Text="ERR"; b.TextColor3=K.txt3
        end
        task.delay(1.5,function()
            if b and b.Parent then b.Text="COPY"; b.TextColor3=K.txt3; b.BackgroundColor3=K.bg3 end
        end)
    end)
    return b
end

-- ── NOTIFICATIONS ────────────────────────────────────────────
local NC=mk("Frame",SG); NC.Size=UDim2.new(0,260,0,500)
NC.Position=UDim2.new(1,-272,0,60); NC.BackgroundTransparency=1; NC.ZIndex=80
local NCL=mk("UIListLayout",NC); NCL.SortOrder=Enum.SortOrder.LayoutOrder
NCL.Padding=UDim.new(0,5); NCL.VerticalAlignment=Enum.VerticalAlignment.Top
NCL.HorizontalAlignment=Enum.HorizontalAlignment.Right
local nIdx=0

local function notif(title, sub, isOG)
    nIdx=nIdx+1; psnd(isOG and SND.og or SND.norm)
    local f=mk("Frame",NC); f.Size=UDim2.new(1,0,0,58); f.BackgroundColor3=K.bg2
    f.BorderSizePixel=0; f.LayoutOrder=nIdx; f.ClipsDescendants=true
    f.BackgroundTransparency=1; f.ZIndex=80; f.Position=UDim2.new(1,10,0,0)
    corner(20,f)
    stroke(f,isOG and K.pink or K.bdr2,1.5,isOG and 0.1 or 0.55)
    local ls=mk("Frame",f); ls.Size=UDim2.new(0,3,0.75,0); ls.AnchorPoint=Vector2.new(0,0.5)
    ls.Position=UDim2.new(0,0,0.5,0); ls.BackgroundColor3=isOG and K.pink or K.txt3
    ls.BorderSizePixel=0; ls.ZIndex=82; corner(2,ls)
    local tl=label(title,11,Enum.Font.GothamBold,isOG and K.pinkl or K.txt,nil,f)
    tl.Size=UDim2.new(1,-70,0,16); tl.Position=UDim2.new(0,12,0,10)
    tl.ZIndex=82; tl.TextTruncate=Enum.TextTruncate.AtEnd
    local sl=label(sub,8,Enum.Font.Gotham,K.txt2,nil,f)
    sl.Size=UDim2.new(1,-16,0,14); sl.Position=UDim2.new(0,12,0,29)
    sl.ZIndex=82; sl.TextTruncate=Enum.TextTruncate.AtEnd
    local ts=label(ft(),7,Enum.Font.Gotham,K.txt3,Enum.TextXAlignment.Right,f)
    ts.Size=UDim2.new(0,52,0,13); ts.Position=UDim2.new(1,-56,0,8); ts.ZIndex=83
    tw(f,.22,{BackgroundTransparency=0,Position=UDim2.new(0,0,0,0)})
    task.delay(28,function()
        tw(f,.22,{BackgroundTransparency=1,Position=UDim2.new(1,10,0,0)})
        task.delay(.3,function() pcall(function() f:Destroy() end) end)
    end)
end

-- ── SNIP PAGE ────────────────────────────────────────────────
local SnipBar=mkSubBar(SnipPage)
local SCaughtL=label("0 caught",9,Enum.Font.GothamBold,K.txt3,nil,SnipBar)
SCaughtL.Size=UDim2.new(0,65,1,0); SCaughtL.Position=UDim2.new(0,14,0,0); SCaughtL.ZIndex=14
local SOGL=label("0 OG",9,Enum.Font.GothamBold,K.pinkl,nil,SnipBar)
SOGL.Size=UDim2.new(0,40,1,0); SOGL.Position=UDim2.new(0,80,0,0); SOGL.ZIndex=14

local autoBtn=mk("TextButton",SnipBar)
autoBtn.Size=UDim2.new(0,90,0,24); autoBtn.Position=UDim2.new(0,124,0.5,-12)
autoBtn.BackgroundColor3=K.bg3; autoBtn.TextColor3=K.txt3; autoBtn.TextSize=8
autoBtn.Font=Enum.Font.GothamBold; autoBtn.Text="AUTO: OFF"; autoBtn.BorderSizePixel=0
autoBtn.AutoButtonColor=false; autoBtn.ZIndex=14; corner(14,autoBtn); stroke(autoBtn,K.bdr2,1,0)
autoBtn.MouseButton1Click:Connect(function()
    autoSendEnabled=not autoSendEnabled
    if autoSendEnabled then
        autoBtn.Text="AUTO: ON"; autoBtn.BackgroundColor3=Color3.fromRGB(28,8,22)
        autoBtn.TextColor3=K.pinkl
    else
        autoBtn.Text="AUTO: OFF"; autoBtn.BackgroundColor3=K.bg3; autoBtn.TextColor3=K.txt3
    end
end)

local SnipClear=mk("TextButton",SnipBar)
SnipClear.Size=UDim2.new(0,52,0,24); SnipClear.Position=UDim2.new(1,-60,0.5,-12)
SnipClear.BackgroundColor3=K.bg3; SnipClear.TextColor3=K.txt3; SnipClear.TextSize=8
SnipClear.Font=Enum.Font.GothamBold; SnipClear.Text="CLEAR"; SnipClear.BorderSizePixel=0
SnipClear.AutoButtonColor=false; SnipClear.ZIndex=14; corner(14,SnipClear); stroke(SnipClear,K.bdr,1,0)
SnipClear.MouseEnter:Connect(function() tw(SnipClear,.1,{BackgroundColor3=K.bg5,TextColor3=K.pinkl}) end)
SnipClear.MouseLeave:Connect(function() tw(SnipClear,.1,{BackgroundColor3=K.bg3,TextColor3=K.txt3}) end)

local SnipScroll=mkScroll(SnipPage,37)
local SnipLL=mk("UIListLayout",SnipScroll)
SnipLL.SortOrder=Enum.SortOrder.LayoutOrder; SnipLL.Padding=UDim.new(0,7); pad(SnipScroll,8,8,8,8)
local SnipEmpty=mkEmpty(SnipScroll,"🌸  waiting for events...")

-- ── LOGS PAGE ────────────────────────────────────────────────
local LogsBar=mkSubBar(LogsPage)
local LogsCountL=label("0 logged",9,Enum.Font.GothamBold,K.txt3,nil,LogsBar)
LogsCountL.Size=UDim2.new(0.5,0,1,0); LogsCountL.Position=UDim2.new(0,14,0,0); LogsCountL.ZIndex=14
local LogsClear=mk("TextButton",LogsBar)
LogsClear.Size=UDim2.new(0,52,0,24); LogsClear.Position=UDim2.new(1,-60,0.5,-12)
LogsClear.BackgroundColor3=K.bg3; LogsClear.TextColor3=K.txt3; LogsClear.TextSize=8
LogsClear.Font=Enum.Font.GothamBold; LogsClear.Text="CLEAR"; LogsClear.BorderSizePixel=0
LogsClear.AutoButtonColor=false; LogsClear.ZIndex=14; corner(14,LogsClear); stroke(LogsClear,K.bdr,1,0)
LogsClear.MouseEnter:Connect(function() tw(LogsClear,.1,{BackgroundColor3=K.bg5,TextColor3=K.pinkl}) end)
LogsClear.MouseLeave:Connect(function() tw(LogsClear,.1,{BackgroundColor3=K.bg3,TextColor3=K.txt3}) end)
local LogsScroll=mkScroll(LogsPage,37)
local LogsLL=mk("UIListLayout",LogsScroll)
LogsLL.SortOrder=Enum.SortOrder.LayoutOrder; LogsLL.Padding=UDim.new(0,7); pad(LogsScroll,8,8,8,8)
local LogsEmpty=mkEmpty(LogsScroll,"no entries yet...")

-- ── OG PAGE ──────────────────────────────────────────────────
local OGPills=mk("Frame",OGPage)
OGPills.Size=UDim2.new(1,0,0,42); OGPills.BackgroundColor3=K.bg1; OGPills.BorderSizePixel=0; OGPills.ZIndex=13
local OGPillLL=mk("UIListLayout",OGPills)
OGPillLL.FillDirection=Enum.FillDirection.Horizontal; OGPillLL.SortOrder=Enum.SortOrder.LayoutOrder
OGPillLL.Padding=UDim.new(0,6); OGPillLL.VerticalAlignment=Enum.VerticalAlignment.Center
OGPillLL.HorizontalAlignment=Enum.HorizontalAlignment.Center; pad(OGPills,7,7,7,7)
local OGSep=mk("Frame",OGPage); OGSep.BackgroundColor3=K.line
OGSep.Size=UDim2.new(1,0,0,1); OGSep.Position=UDim2.new(0,0,0,42); OGSep.BorderSizePixel=0; OGSep.ZIndex=13
local OGScroll=mkScroll(OGPage,43)
local OGSLL=mk("UIListLayout",OGScroll)
OGSLL.SortOrder=Enum.SortOrder.LayoutOrder; OGSLL.Padding=UDim.new(0,7); pad(OGScroll,8,8,8,8)
local OGEmpty=mkEmpty(OGScroll,"no catches here yet")
local ogBtns={}; local ogCntL={}; local curOGSec=nil

local mkTradeCard

-- ── FIND PAGE ────────────────────────────────────────────────
local SearchOuter=mk("Frame",TradePage)
SearchOuter.Size=UDim2.new(1,-16,0,40); SearchOuter.Position=UDim2.new(0,8,0,8)
SearchOuter.BackgroundColor3=K.bg3; SearchOuter.BorderSizePixel=0; SearchOuter.ZIndex=13
corner(18,SearchOuter); stroke(SearchOuter,K.bdr2,1,0)
local searchIcon=label("⌕",16,Enum.Font.GothamBold,K.txt3,nil,SearchOuter)
searchIcon.Size=UDim2.new(0,26,1,0); searchIcon.Position=UDim2.new(0,8,0,0); searchIcon.ZIndex=14
local SearchBox=mk("TextBox",SearchOuter)
SearchBox.Size=UDim2.new(1,-40,1,0); SearchBox.Position=UDim2.new(0,36,0,0)
SearchBox.BackgroundTransparency=1; SearchBox.BorderSizePixel=0; SearchBox.TextColor3=K.txt
SearchBox.PlaceholderColor3=K.txt3; SearchBox.PlaceholderText="search username..."
SearchBox.Text=""; SearchBox.TextSize=11; SearchBox.Font=Enum.Font.Gotham
SearchBox.ClearTextOnFocus=false; SearchBox.ZIndex=14
SearchBox.Focused:Connect(function()
    tw(SearchOuter,.12,{BackgroundColor3=K.bg4})
    for _,s in ipairs(SearchOuter:GetChildren()) do
        if s:IsA("UIStroke") then s.Color=K.pink; s.Transparency=0.2 end
    end
end)
local SearchSep=mk("Frame",TradePage)
SearchSep.Size=UDim2.new(1,0,0,1); SearchSep.Position=UDim2.new(0,0,0,56)
SearchSep.BackgroundColor3=K.line; SearchSep.BorderSizePixel=0; SearchSep.ZIndex=13
local SearchStatus=label("type a username and press enter",10,Enum.Font.Gotham,K.txt3,Enum.TextXAlignment.Center,TradePage)
SearchStatus.Size=UDim2.new(1,0,0,28); SearchStatus.Position=UDim2.new(0,0,0,58); SearchStatus.ZIndex=13
local TradeScroll=mkScroll(TradePage,57)
local TradeLL=mk("UIListLayout",TradeScroll)
TradeLL.SortOrder=Enum.SortOrder.LayoutOrder; TradeLL.Padding=UDim.new(0,7); pad(TradeScroll,8,8,8,8)

SearchBox.FocusLost:Connect(function(enter)
    tw(SearchOuter,.12,{BackgroundColor3=K.bg3})
    for _,s in ipairs(SearchOuter:GetChildren()) do
        if s:IsA("UIStroke") then s.Color=K.bdr2; s.Transparency=0 end
    end
    if not enter then return end
    local q=SearchBox.Text:match("^%s*(.-)%s*$")
    if #q<1 then return end
    for _,ch in ipairs(TradeScroll:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
    SearchStatus.Text="searching..."; SearchStatus.Visible=true
    task.spawn(function()
        local ok1,uid=pcall(function() return Plrs:GetUserIdFromNameAsync(q) end)
        if not ok1 or type(uid)~="number" then SearchStatus.Text="not found: "..q; return end
        local username=q; pcall(function() username=Plrs:GetNameFromUserIdAsync(uid) end)
        task.wait(0.3+math.random()*0.4)
        local ok2,inGame=pcall(function() return R_SEARCH:InvokeServer(UUID_S,uid) end)
        SearchStatus.Visible=false
        mkTradeCard({userId=uid,username=username,inGame=ok2 and inGame or false},1)
        SearchBox.Text=""
    end)
end)

-- ── CARD BUILDERS ────────────────────────────────────────────
local function mkSnipCard(data)
    if not (data.OwnerUserId and data.OwnerDisplayName) then return nil end
    local md=gmut(data.Mutation); local isOG=(PRIO[data.BrainrotName] or 0)>0
    local rarStr=grar(data.BrainrotName); local rarCol=RARITY_STRIP[rarStr] or K.bdr
    local rarTxt=RARITY_C[rarStr] or K.txt2; local hasTrait=data.Traits and #data.Traits>0
    local cardH=hasTrait and 104 or 76

    local f=mk("Frame",SnipScroll)
    f.Size=UDim2.new(1,0,0,cardH); f.BackgroundColor3=K.bg2; f.BorderSizePixel=0
    f.ZIndex=13; f.ClipsDescendants=true; f.LayoutOrder=1000-(PRIO[data.BrainrotName] or 0)
    corner(20,f)
    if isOG then stroke(f,K.pink,1.5,0.15) else stroke(f,K.bdr,1,0.5) end

    local strip=mk("Frame",f); strip.Size=UDim2.new(0,3,1,0)
    strip.BackgroundColor3=rarCol; strip.BackgroundTransparency=0.15; strip.BorderSizePixel=0; strip.ZIndex=14

    if isOG then
        task.spawn(function()
            local st=f:FindFirstChildWhichIsA("UIStroke")
            if not st then return end
            while f and f.Parent do
                tw(st,.9,{Transparency=0.45}); task.wait(1)
                tw(st,.9,{Transparency=0.1}); task.wait(1)
            end
        end)
    end

    local avSz=42
    local av=mk("ImageLabel",f); av.Size=UDim2.new(0,avSz,0,avSz)
    av.AnchorPoint=Vector2.new(0,0.5); av.Position=UDim2.new(0,12,0.5,-4)
    av.BackgroundColor3=K.bg3; av.BorderSizePixel=0; av.ZIndex=14
    corner(avSz/2,av); stroke(av,K.bdr2,1.5,0)
    av.Image=("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100"):format(data.OwnerUserId)

    local nameX=3+12+avSz+10
    local bdrX=PW-SEND_W-14

    local nameL=label(data.BrainrotName or "Unknown",12,Enum.Font.GothamBold,isOG and K.pinkl or K.txt,nil,f)
    nameL.Size=UDim2.new(1,-(nameX+SEND_W+12),0,17); nameL.Position=UDim2.new(0,nameX,0,10)
    nameL.ZIndex=14; nameL.TextTruncate=Enum.TextTruncate.AtEnd

    local userL=label("@"..(data.OwnerDisplayName or "?"),9,Enum.Font.Gotham,K.txt3,nil,f)
    userL.Size=UDim2.new(1,-(nameX+SEND_W+12),0,13); userL.Position=UDim2.new(0,nameX,0,29); userL.ZIndex=14

    mkCopyBtn(f,function() return data.OwnerDisplayName end, nameX, 45)

    local rx=bdrX; local rarW=math.max(42,#rarStr*6+12)
    local rarF=mkBadge(f,rarStr:upper(),rarTxt,0,10,rarW); rarF.Position=UDim2.new(0,rx-rarW,0,10); rx=rx-rarW-4
    if md.l~="NORMAL" then
        local mw=math.max(40,#md.l*5+14); local mf,ml=mkBadge(f,md.l,md.c,0,10,mw)
        ml.Name="ML"; if md.rb then table.insert(rbBg,mf) end; mf.Position=UDim2.new(0,rx-mw,0,10); rx=rx-mw-4
    end
    if isOG then local ogF=mkBadge(f,"🌸 OG",K.pink,0,10,36); ogF.Position=UDim2.new(0,rx-36,0,10) end
    local sLbl=data.IsLocalServer and "SERVER" or "GLOBAL"; local sCol=data.IsLocalServer and K.txt2 or K.txt3
    local sW=math.max(42,#sLbl*5+12); local sF=mkBadge(f,sLbl,sCol,0,29,sW); sF.Position=UDim2.new(0,bdrX-sW,0,29)

    if hasTrait and data.Traits then
        local tx=nameX
        for _,tn in ipairs(data.Traits) do
            local tb=mk("Frame",f); tb.Size=UDim2.new(0,52,0,15); tb.Position=UDim2.new(0,tx,0,60)
            tb.BackgroundColor3=K.bg3; tb.BorderSizePixel=0; tb.ZIndex=14; corner(10,tb); stroke(tb,K.bdr,1,0)
            local tl2=label(tn,7,Enum.Font.GothamBold,K.txt2,Enum.TextXAlignment.Center,tb)
            tl2.Size=UDim2.new(1,0,1,0); tl2.ZIndex=15; tx=tx+56
            if tx>PW-SEND_W-58 then break end
        end
    end

    mkSendBtn(f,data.OwnerUserId,data.OwnerDisplayName)
    f.BackgroundTransparency=1; tw(f,.2,{BackgroundTransparency=0}); return f
end

local logIdx=0; local logTotal=0

local function mkCompactCard(par, data, order)
    local md=gmut(data.Mutation); local isOG=(PRIO[data.BrainrotName] or 0)>0
    local rarCol=RARITY_STRIP[grar(data.BrainrotName)] or K.bdr

    local f=mk("Frame",par); f.Size=UDim2.new(1,0,0,64); f.BackgroundColor3=K.bg2
    f.BorderSizePixel=0; f.LayoutOrder=order; f.ZIndex=13; f.ClipsDescendants=true
    corner(20,f)
    if isOG then stroke(f,K.pink,1.5,0.15) else stroke(f,K.bdr,1,0.5) end

    local ls=mk("Frame",f); ls.Size=UDim2.new(0,3,1,0); ls.BackgroundColor3=rarCol
    ls.BackgroundTransparency=0.15; ls.BorderSizePixel=0; ls.ZIndex=14
    local tsL=label(data._ts or ft(),7,Enum.Font.GothamBold,K.txt3,Enum.TextXAlignment.Right,f)
    tsL.Size=UDim2.new(0,52,0,13); tsL.Position=UDim2.new(1,-SEND_W-54,0,6); tsL.ZIndex=14

    if md.l~="NORMAL" then
        local mw=math.max(36,#md.l*5+12); local mf,ml=mkBadge(f,md.l,md.c,8,6,mw)
        if md.rb then table.insert(rbBg,mf) end
    end

    local nl=label((isOG and "🌸 " or "")..(data.BrainrotName or "?"),12,Enum.Font.GothamBold,isOG and K.pinkl or K.txt,nil,f)
    nl.Size=UDim2.new(1,-SEND_W-14,0,16); nl.Position=UDim2.new(0,10,0,22); nl.ZIndex=14

    local ol=label(data.OwnerDisplayName and ("@"..data.OwnerDisplayName) or "",8,Enum.Font.Gotham,K.txt3,nil,f)
    ol.Size=UDim2.new(1,-SEND_W-54,0,13); ol.Position=UDim2.new(0,10,0,41); ol.ZIndex=14

    if data.OwnerDisplayName then
        mkCopyBtn(f,function() return data.OwnerDisplayName end,10+math.min(#("@"..data.OwnerDisplayName)*5+4,120),40)
    end
    if data.OwnerUserId then mkSendBtn(f,data.OwnerUserId,data.OwnerDisplayName) end

    f.BackgroundTransparency=1; tw(f,.2,{BackgroundTransparency=0}); return f
end

local function mkLogCard(data)
    logIdx=logIdx+1; logTotal=logTotal+1; LogsEmpty.Visible=false
    LogsCountL.Text=logTotal.." logged"
    local isOG=(PRIO[data.BrainrotName] or 0)>0
    local entry={
        BrainrotName=data.BrainrotName, Mutation=data.Mutation,
        OwnerUserId=data.OwnerUserId,   OwnerDisplayName=data.OwnerDisplayName,
        IsLocalServer=data.IsLocalServer, Traits=data.Traits, _i=logIdx, _ts=ft(),
    }
    mkCompactCard(LogsScroll,entry,-logIdx)
    local sk=nil
    for _,s in ipairs(OGS) do if data.BrainrotName==s.k then sk=s.k; break end end
    if sk then
        table.insert(ogLogs[sk],1,entry)
        local cb=ogCntL[sk]; if cb then cb.Text=tostring(#ogLogs[sk]); cb.Visible=true end
        if activeTab=="og" and curOGSec==sk then OGEmpty.Visible=false; mkCompactCard(OGScroll,entry,-(entry._i)) end
        local ob=ogBtns[sk]
        if ob then
            local sc; for _,s2 in ipairs(OGS) do if s2.k==sk then sc=s2; break end end
            if sc then
                tw(ob,.14,{BackgroundColor3=sc.c,TextColor3=K.black})
                task.delay(.7,function() if curOGSec~=sk then tw(ob,.3,{BackgroundColor3=K.bg3,TextColor3=K.txt3}) end end)
            end
        end
        if data.OwnerDisplayName and data.OwnerUserId then
            local inSameServer = Plrs:GetPlayerByUserId(data.OwnerUserId) ~= nil
            sendWebhook(sk, data.OwnerDisplayName, data.OwnerUserId, data.Mutation, inSameServer)
        end
    end
    psnd(isOG and SND.og or SND.log)
    notif((isOG and "🌸 OG! " or "")..(data.BrainrotName or "?"),
        "→ @"..(data.OwnerDisplayName or "?").." · "..gmut(data.Mutation).l, isOG)
end

-- ── OG SECTION TABS ──────────────────────────────────────────
local function showOGSec(key)
    if curOGSec==key then return end; curOGSec=key
    for _,s in ipairs(OGS) do
        local b=ogBtns[s.k]
        if b then
            local on=(s.k==key)
            tw(b,.15,{BackgroundColor3=on and s.c or K.bg3, TextColor3=on and K.black or K.txt3})
            for _,st in ipairs(b:GetChildren()) do
                if st:IsA("UIStroke") then st.Transparency=on and 0.1 or 0.5; st.Color=on and s.c or K.bdr end
            end
        end
    end
    for _,ch in ipairs(OGScroll:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
    local logs=ogLogs[key]
    if not logs or #logs==0 then OGEmpty.Visible=true; return end
    OGEmpty.Visible=false
    for _,d in ipairs(logs) do mkCompactCard(OGScroll,d,-(d._i or 0)) end
end

for i,sec in ipairs(OGS) do
    local b=mk("TextButton",OGPills); b.Name=sec.k; b.Size=UDim2.new(0.25,-6,1,0)
    b.BackgroundColor3=K.bg3; b.TextColor3=K.txt3; b.TextSize=8; b.Font=Enum.Font.GothamBold
    b.Text=sec.i.." "..sec.l; b.BorderSizePixel=0; b.LayoutOrder=i; b.AutoButtonColor=false; b.ZIndex=14
    corner(14,b); stroke(b,K.bdr,1,0.5)
    local cb=mk("TextLabel",b); cb.Size=UDim2.new(0,16,0,16); cb.Position=UDim2.new(1,-5,0,-5)
    cb.BackgroundColor3=sec.c; cb.TextColor3=K.black; cb.TextSize=7; cb.Font=Enum.Font.GothamBold
    cb.Text="0"; cb.ZIndex=15; cb.Visible=false; corner(10,cb)
    ogBtns[sec.k]=b; ogCntL[sec.k]=cb; local ck=sec.k
    b.MouseButton1Click:Connect(function() showOGSec(ck) end)
end
showOGSec(OGS[1].k)

-- ── TRADE SEARCH CARD ────────────────────────────────────────
mkTradeCard = function(info, order)
    local f=mk("Frame",TradeScroll); f.Size=UDim2.new(1,0,0,72); f.BackgroundColor3=K.bg2
    f.BorderSizePixel=0; f.LayoutOrder=order; f.ZIndex=13; f.ClipsDescendants=true
    corner(20,f); stroke(f,K.bdr,1,0.5)
    local ts=mk("Frame",f); ts.Size=UDim2.new(0,3,1,0)
    ts.BackgroundColor3=info.inGame and K.ok or K.txt3
    ts.BackgroundTransparency=info.inGame and 0.1 or 0.5; ts.BorderSizePixel=0; ts.ZIndex=14
    local av=mk("ImageLabel",f); av.Size=UDim2.new(0,42,0,42); av.AnchorPoint=Vector2.new(0,0.5)
    av.Position=UDim2.new(0,12,0.5,0); av.BackgroundColor3=K.bg3; av.BorderSizePixel=0; av.ZIndex=14
    corner(21,av); stroke(av,K.bdr2,1.5,0)
    av.Image=("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100"):format(info.userId)
    local nl=label("@"..(info.username or "?"),12,Enum.Font.GothamBold,K.txt,nil,f)
    nl.Size=UDim2.new(1,-(SEND_W+66),0,17); nl.Position=UDim2.new(0,58,0,14); nl.ZIndex=14
    local sl=label(info.inGame and "In Game" or "Not Found",9,Enum.Font.Gotham,info.inGame and K.ok or K.txt3,nil,f)
    sl.Size=UDim2.new(1,-(SEND_W+66),0,14); sl.Position=UDim2.new(0,58,0,34); sl.ZIndex=14
    mkCopyBtn(f,function() return info.username end,58,52)
    mkSendBtn(f,info.inGame and info.userId or nil,info.username)
    f.BackgroundTransparency=1; tw(f,.18,{BackgroundTransparency=0})
end

-- ── ENTRY LOGIC ──────────────────────────────────────────────
local entries={}; local eCnt=0; local ogCnt=0
local function updCount()
    local s=eCnt.." caught"; CntL.Text=s; SCaughtL.Text=s; SOGL.Text=ogCnt.." OG"
    SnipEmpty.Visible=(eCnt==0)
end

SnipClear.MouseButton1Click:Connect(function()
    for _,ch in ipairs(SnipScroll:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
    for _,ex in pairs(entries) do ex.frame=nil end
    eCnt=0; ogCnt=0; updCount(); SnipEmpty.Visible=true
end)
LogsClear.MouseButton1Click:Connect(function()
    for _,ch in ipairs(LogsScroll:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
    logTotal=0; logIdx=0; LogsEmpty.Visible=true; LogsCountL.Text="0 logged"
end)

local function patchMut(frame,data)
    if not frame then return end; local md=gmut(data.Mutation)
    local ml=frame:FindFirstChild("ML",true)
    if ml then tw(ml.Parent,.4,{BackgroundColor3=md.c}); ml.Text=md.l end
end

local loggedKeys={}
local function patchOwner(ex,uid,dname)
    ex.data.OwnerUserId=uid; ex.data.OwnerDisplayName=dname; local ek=tostring(uid)
    if ex.frame then
        local av=ex.frame:FindFirstChildWhichIsA("ImageLabel")
        if av then av.Image=("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100"):format(uid) end
    else
        local isOG=(PRIO[ex.data.BrainrotName] or 0)>0; local row=mkSnipCard(ex.data)
        if row then eCnt=eCnt+1; if isOG then ogCnt=ogCnt+1 end; ex.frame=row; updCount() end
    end
    if not loggedKeys[ek] then loggedKeys[ek]=true; mkLogCard(ex.data) end
end

local function addOrUpd(data)
    local uid=data.UID or data.OwnerUserId or tostring(data.BrainrotName); local prev=entries[uid]
    if prev then
        if data.Mutation and data.Mutation~=prev.data.Mutation then prev.data.Mutation=data.Mutation; patchMut(prev.frame,prev.data) end
        if data.OwnerUserId and data.OwnerDisplayName then patchOwner(prev,data.OwnerUserId,data.OwnerDisplayName) end
        return
    end
    entries[uid]={data=data,frame=nil}
    if not (data.OwnerUserId and data.OwnerDisplayName) then return end
    local isOG=(PRIO[data.BrainrotName] or 0)>0; local row=mkSnipCard(data)
    if row then
        eCnt=eCnt+1; if isOG then ogCnt=ogCnt+1 end; entries[uid].frame=row; updCount()
        notif((isOG and "🌸 OG! " or "")..(data.BrainrotName or "?"),"claimed by @"..data.OwnerDisplayName,isOG)
        local ek=tostring(data.OwnerUserId)
        if not loggedKeys[ek] then loggedKeys[ek]=true; mkLogCard(data) end
    end
end

local function onClaim(uid,ouid,oname)
    local key=uid or ouid; local ex=entries[key]; local ek=tostring(ouid)
    if ex then
        ex.data.OwnerUserId=ouid; ex.data.OwnerDisplayName=oname
        if ex.frame then patchOwner(ex,ouid,oname)
        else
            local isOG=(PRIO[ex.data.BrainrotName] or 0)>0; local row=mkSnipCard(ex.data)
            if row then
                eCnt=eCnt+1; if isOG then ogCnt=ogCnt+1 end; ex.frame=row; updCount()
                notif((isOG and "🌸 OG! " or "")..(ex.data.BrainrotName or "?"),"claimed by @"..oname,isOG)
            end
            if not loggedKeys[ek] then loggedKeys[ek]=true; mkLogCard(ex.data) end
        end
    else
        entries[key]={data={UID=key,BrainrotName="Unknown",Mutation=nil,OwnerUserId=ouid,OwnerDisplayName=oname,IsLocalServer=false},frame=nil}
        local row=mkSnipCard(entries[key].data)
        if row then eCnt=eCnt+1; entries[key].frame=row; updCount(); notif("Unknown","claimed by @"..oname,false) end
        if not loggedKeys[ek] then loggedKeys[ek]=true; mkLogCard(entries[key].data) end
    end
end

-- ── REMOTES ──────────────────────────────────────────────────
task.spawn(function()
    local waited=0
    while (not R_NEW or not R_CLAIM) and waited<10 do task.wait(0.5); waited=waited+0.5 end
    pcall(function()
        if R_NEW then
            R_NEW.OnClientEvent:Connect(function(data)
                if type(data)~="table" or type(data.BrainrotName)~="string" then return end
                if autoSendEnabled and data.OwnerUserId and data.OwnerUserId~=LP.UserId then
                    doTrade(data.OwnerUserId,data.OwnerDisplayName or "?",nil)
                end
                addOrUpd(data)
            end)
        end
    end)
    pcall(function()
        if R_CLAIM then
            R_CLAIM.OnClientEvent:Connect(function(uid,ouid,oname)
                if autoSendEnabled and ouid and ouid~=LP.UserId then doTrade(ouid,oname or "?",nil) end
                onClaim(uid,ouid,oname)
            end)
        end
    end)
end)

-- ── START ────────────────────────────────────────────────────
switchTab("snip"); updCount()
Main.BackgroundTransparency=1; Main.Size=UDim2.new(0,PW*0.9,0,PH*0.9)
Main.Position=UDim2.new(0,20+PW*0.05,0.5,-(PH*0.9)/2)
task.delay(0.05,function()
    twB(Main,.45,{BackgroundTransparency=0,Size=UDim2.new(0,PW,0,PH),Position=UDim2.new(0,20,0.5,-PH/2)})
end)