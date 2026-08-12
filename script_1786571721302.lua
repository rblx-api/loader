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
    else twB(Main,.32,{Siz