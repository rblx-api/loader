local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

local S = {
    myPlot = nil,
    flying = false,
    tpBusy = false,
    isCloning = false,
    goingToPet = false,
    flyPre = nil,
    flyHb = nil,
}

local conns = {}
local function bind(signal, fn)
    local c = signal:Connect(fn)
    conns[#conns + 1] = c
    return c
end

-- ── HELPERS ──────────────────────────────
local function hrpOf()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart"),
           c and c:FindFirstChildOfClass("Humanoid"),
           c
end

local function isStealing()
    return LP:GetAttribute("Stealing") == true
end

local function cheapPos(inst)
    if not inst then return nil end
    if inst:IsA("BasePart") then return inst.Position end
    local pp = inst:IsA("Model") and inst.PrimaryPart
    if pp then return pp.Position end
    local p = inst:FindFirstChildWhichIsA("BasePart")
    return p and p.Position or nil
end

local function findPlot(name)
    local plots = workspace:FindFirstChild("Plots")
    return plots and name and plots:FindFirstChild(tostring(name)) or nil
end

local function petPodium(pet)
    local plot = findPlot(pet.plot)
    local pods = plot and plot:FindFirstChild("AnimalPodiums")
    return pods and pods:FindFirstChild(tostring(pet.slot)) or nil
end

local function petPos(pet)
    if not pet then return nil end
    if pet.position then return pet.position end
    local pod = petPodium(pet)
    if pod then
        local base = pod:FindFirstChild("Base")
        local p = cheapPos(base and base:FindFirstChild("Spawn"))
                or cheapPos(base)
                or cheapPos(pod)
        if p then
            pet.position = p
            return p
        end
    end
    local plot = findPlot(pet.plot)
    pet.plotHint = plot and (cheapPos(plot:FindFirstChild("MainRoot")) or cheapPos(plot)) or pet.plotHint
    return pet.plotHint
end

local function adMut(ad)
    local m = ad.Mutation or ad.mutation or ad.Mut
    if type(m) == "table" then m = m.Name or m.Index or m.Type or m[1] end
    return type(m) == "string" and m or ""
end

local function isFusing(ad)
    local m = ad.Machine
    if type(m) ~= "table" or m.Active ~= true then return false end
    return m.Type == "Fuse" or m.Type == "Duel" or m.Type == "Trade" or m.Type == "Crafting"
end

-- ── CHANNEL HELPERS ───────────────────────
local chans, chanGet, isMyPlot
do
    local cached, mod
    chans = function()
        if cached then return cached end
        local pk = ReplicatedStorage:FindFirstChild("Packages")
        local syn = pk and pk:FindFirstChild("Synchronizer")
        if not syn then return nil end
        if type(mod) ~= "table" then
            local req = (getrenv and getrenv().require) or require
            local ok, m = pcall(req, syn)
            if ok and type(m) == "table" then mod = m end
        end
        local get = type(mod) == "table" and rawget(mod, "Get")
        if type(get) ~= "function" then return nil end
        local gf = getfenv or (debug and debug.getfenv)
        if type(gf) == "function" then
            local ok, env = pcall(gf, get)
            local ch = ok and type(env) == "table" and rawget(env, "Channels")
            if type(ch) == "table" then cached = ch end
        end
        if not cached and debug and debug.getupvalues then
            local ok, ups = pcall(debug.getupvalues, get)
            for _, v in pairs(ok and ups or {}) do
                if type(v) == "table" then
                    for _, c in pairs(v) do
                        if type(c) == "table" and rawget(c, "CacheTable") ~= nil then
                            cached = v
                            break
                        end
                    end
                end
                if cached then break end
            end
        end
        return cached
    end

    chanGet = function(ch, key)
        if type(ch) ~= "table" then return nil end
        local ct = rawget(ch, "CacheTable")
        if type(ct) ~= "table" then
            local ok, c2 = pcall(function() return ch.CacheTable end)
            ct = ok and c2 or nil
        end
        if type(ct) ~= "table" then return nil end
        local v = rawget(ct, key)
        if v ~= nil then return v end
        local ok, v2 = pcall(function() return ct[key] end)
        return ok and v2 or nil
    end

    local mine = setmetatable({}, { __mode = "k" })
    isMyPlot = function(ch)
        if type(ch) ~= "table" then return false end
        if mine[ch] then return true end
        local owner = chanGet(ch, "Owner")
        local yes = false
        pcall(function()
            if typeof(owner) == "Instance" then
                yes = owner == LP or (owner:IsA("Player") and owner.UserId == LP.UserId)
            elseif type(owner) == "table" and owner.UserId then
                yes = owner.UserId == LP.UserId
            elseif type(owner) == "number" then
                yes = owner == LP.UserId
            end
        end)
        if yes then mine[ch] = true end
        return yes
    end
end

local function isPlotKey(k)
    return type(k) == "string" and #k >= 32 and string.find(k, "-", 1, true) ~= nil
end

-- ── REMOTE HASH ───────────────────────────
local remoteByHash
do
    local band, bxor, bnot, rrot, rsh = bit32.band, bit32.bxor, bit32.bnot, bit32.rrotate, bit32.rshift
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
        local H = {0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
        local bits = #msg * 8
        msg = msg.."\128"..string.rep("\0",(55-#msg)%64)
            ..string.pack(">I4I4",math.floor(bits/4294967296),bits%4294967296)
        local w = {}
        for c = 1,#msg,64 do
            for i = 1,16 do w[i] = string.unpack(">I4",msg,c+(i-1)*4) end
            for i = 17,64 do
                local x,y = w[i-15],w[i-2]
                w[i] = (w[i-16]+bxor(rrot(x,7),rrot(x,18),rsh(x,3))+w[i-7]
                    +bxor(rrot(y,17),rrot(y,19),rsh(y,10)))%4294967296
            end
            local a,b,cc,d,e,f,g,h = H[1],H[2],H[3],H[4],H[5],H[6],H[7],H[8]
            for i = 1,64 do
                local t1=(h+bxor(rrot(e,6),rrot(e,11),rrot(e,25))+bxor(band(e,f),band(bnot(e),g))+K[i]+w[i])%4294967296
                local t2=(bxor(rrot(a,2),rrot(a,13),rrot(a,22))+bxor(band(a,b),band(a,cc),band(b,cc)))%4294967296
                h,g,f,e,d,cc,b,a = g,f,e,(d+t1)%4294967296,cc,b,a,(t1+t2)%4294967296
            end
            H[1],H[2],H[3],H[4] = (H[1]+a)%4294967296,(H[2]+b)%4294967296,(H[3]+cc)%4294967296,(H[4]+d)%4294967296
            H[5],H[6],H[7],H[8] = (H[5]+e)%4294967296,(H[6]+f)%4294967296,(H[7]+g)%4294967296,(H[8]+h)%4294967296
        end
        return string.format(string.rep("%08x",8),table.unpack(H))
    end
    local function cipher(name,jobId)
        local out,pos = {},0
        for i = 1,#name do
            local c = string.byte(name,i)
            if c == 47 then out[i]="/"
            else
                pos+=1
                local k = string.byte(jobId,(pos-1)%#jobId+1)
                out[i] = string.char(((c-32+k)%95)+32)
            end
        end
        return table.concat(out)
    end
    local SECRET = "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7"
    local cache = {}
    remoteByHash = function(name)
        local hit = cache[name]
        if hit and hit.Parent then return hit end
        local pk = ReplicatedStorage:FindFirstChild("Packages")
        local Net = pk and pk:FindFirstChild("Net")
        local jobId = game.JobId
        if not Net or type(jobId)~="string" or jobId=="" then return nil end
        local ok,h = pcall(sha256,cipher(name,jobId)..SECRET..jobId)
        if not ok then return nil end
        local r = Net:FindFirstChild("RE/"..h) or Net:FindFirstChild("RF/"..h) or Net:FindFirstChild("URE/"..h)
        if r then cache[name]=r end
        return r
    end
end

-- ── STEAL BAR UI ──────────────────────────
local bar = {}
do
    local gui = Instance.new("ScreenGui")
    gui.Name = "StealBar"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 220
    local hud = Instance.new("Frame")
    hud.AnchorPoint = Vector2.new(0.5,1)
    hud.Size = UDim2.new(0,230,0,46)
    hud.Position = UDim2.new(0.5,0,1,-135)
    hud.BackgroundColor3 = Color3.fromRGB(15,15,15)
    hud.BackgroundTransparency = 0.4
    hud.BorderSizePixel = 0
    hud.Parent = gui
    Instance.new("UICorner",hud).CornerRadius = UDim.new(0,12)
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1,-12,0,13)
    name.Position = UDim2.fromOffset(6,3)
    name.BackgroundTransparency = 1
    name.Font = Enum.Font.GothamBold
    name.TextSize = 11
    name.TextColor3 = Color3.new(1,1,1)
    name.TextTruncate = Enum.TextTruncate.AtEnd
    name.Text = "Searching..."
    name.Parent = hud
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1,-10,0,18)
    track.Position = UDim2.fromOffset(5,18)
    track.BackgroundColor3 = Color3.fromRGB(35,35,38)
    track.BorderSizePixel = 0
    track.Parent = hud
    Instance.new("UICorner",track).CornerRadius = UDim.new(0,8)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale(0,1)
    fill.BackgroundColor3 = Color3.fromRGB(167,110,247)
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner",fill).CornerRadius = UDim.new(0,8)
    local pct = Instance.new("TextLabel")
    pct.Size = UDim2.fromScale(1,1)
    pct.BackgroundTransparency = 1
    pct.Font = Enum.Font.GothamBold
    pct.TextSize = 12
    pct.TextColor3 = Color3.new(1,1,1)
    pct.TextStrokeTransparency = 0.7
    pct.Text = "0%"
    pct.ZIndex = 2
    pct.Parent = track
    bar.gui,bar.name,bar.fill,bar.pct = gui,name,fill,pct
    local pg = LP:WaitForChild("PlayerGui")
    gui.Parent = pg
end

local PURPLE = Color3.fromRGB(167,110,247)
local GREEN  = Color3.fromRGB(80,220,120)
local GREY   = Color3.fromRGB(110,110,125)

local function barShow(text, frac, color)
    frac = math.clamp(frac,0,1)
    bar.name.Text = text
    bar.fill.Size = UDim2.fromScale(frac,1)
    bar.fill.BackgroundColor3 = color
    bar.pct.Text = math.floor(frac*100).."%"
end

local function petLabel(pet)
    if type(pet)~="table" then return "-" end
    local n = tostring(pet.name or "?")
    if pet.mutation~="" and pet.mutation~="None" and pet.mutation~=nil then
        n = pet.mutation.." "..n
    end
    return n
end

-- ── CARPET / GRAPPLE ──────────────────────
local CARPETS = {"Flying Carpet","Waverider","Witch's Broom","Santa's Sleigh","Cupid's Wings"}
local Config = { Tool = "Flying Carpet", TPSpeed = 450, CloneDelay = 0.27,
                 AutoInvis = true, InvisAngle = 220, InvisDepth = 7.4, InvisSpeed = 23,
                 AutoGrab = true, StealNearest = false, AutoTP = true }

local findTool, equipCarpet, carpetHeld, pulseGrapple, carpetEngage
do
    local GRAPPLE_ID = "75c9466d-e4c0-4b02-b26a-c3615fcc1e42"
    local grappleFired = false
    local engaging = false

    findTool = function(name)
        local c,bp = LP.Character, LP:FindFirstChild("Backpack")
        return (c and c:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
    end

    local function order()
        local t = {Config.Tool}
        for _,n in ipairs(CARPETS) do if n~=Config.Tool then t[#t+1]=n end end
        return t
    end

    carpetHeld = function()
        local c = LP.Character
        if not c then return nil end
        for _,n in ipairs(order()) do
            if c:FindFirstChild(n) then return n end
        end
        return nil
    end

    equipCarpet = function()
        if S.isCloning then return nil end
        local held = carpetHeld()
        if held or not grappleFired then return held end
        local _,hum,c = hrpOf()
        if not hum then return nil end
        for _,n in ipairs(order()) do
            local t = findTool(n)
            if t and t:IsA("Tool") then
                if t.Parent~=c then pcall(function() hum:EquipTool(t) end) end
                return n
            end
        end
        return nil
    end

    local function fire(r)
        for _ = 1,3 do
            if r:IsA("RemoteFunction") then task.spawn(pcall,r.InvokeServer,r,0.33)
            else pcall(r.FireServer,r,0.33) end
        end
        grappleFired = true
    end

    pulseGrapple = function()
        local r = remoteByHash(GRAPPLE_ID)
        if not r then return false end
        fire(r)
        return true
    end

    carpetEngage = function()
        if S.isCloning then return nil end
        if engaging then
            local t = os.clock()
            repeat RunService.Heartbeat:Wait() until not engaging or os.clock()-t>6
            return carpetHeld()
        end
        engaging = true
        local held,t0 = 0,os.clock()
        while os.clock()-t0<5 do
            local _,hum,c = hrpOf()
            local g = findTool("Grapple Hook")
            if g and hum and g.Parent~=c then
                pcall(function() hum:EquipTool(g) end); held=0
            elseif c and c:FindFirstChild("Grapple Hook") then held+=1
            else held=0 end
            local r = remoteByHash(GRAPPLE_ID)
            if held>=2 and r then fire(r); task.wait(0.1); break end
            RunService.Heartbeat:Wait()
        end
        local cn
        local tc = os.clock()
        repeat
            cn = equipCarpet()
            if cn and LP.Character and LP.Character:FindFirstChild(cn) then break end
            RunService.Heartbeat:Wait()
        until os.clock()-tc>0.4
        engaging = false
        return cn
    end
end

-- ── STEAL LOGIC ───────────────────────────
local armSteal, disarmSteal
do
    local GRAB_RANGE  = 90
    local COMMIT_RANGE= 10
    local HOLD        = 1.3
    local SERVER_HOLD = 1.3
    local HOLD_MAX    = 2.5
    local TAKEN_RANGE = 60

    local target, prompt, promptFor = nil, nil, nil
    local holding, abort = false, false
    local retryAt, lastTick = 0, 0
    local bankAt = 0

    local holdShown = false
    local function barHide() holdShown = false end

    local function barSet(frac, close, taken)
        holdShown = true
        local note = taken and "  |  taken, waiting" or (close and "" or "  |  get closer")
        barShow(petLabel(target)..note, frac,
            frac>=1 and GREEN or ((close and not taken) and PURPLE or GREY))
    end

    task.spawn(function()
        while true do
            if not holdShown then
                if isStealing() then
                    barShow("Carrying Brainrot!",1,GREEN)
                elseif not Config.AutoGrab then
                    barShow("Auto Grab off",0,PURPLE)
                elseif target then
                    local hrp,pos = hrpOf(),petPos(target)
                    local dd = hrp and pos and math.floor((hrp.Position-pos).Magnitude) or nil
                    barShow(petLabel(target)..(dd and ("  |  "..dd.." studs") or ""),0,PURPLE)
                else
                    barShow("Searching...",0,PURPLE)
                end
            end
            task.wait(0.2)
        end
    end)

    local function blocked()
        return isStealing() or LP:GetAttribute("IsTrading")
            or LP:GetAttribute("IsDuelSelecting")
            or LP:GetAttribute("Web")==true
    end

    local function promptPos(p)
        local par = p and p.Parent
        if not par then return nil end
        if par:IsA("Attachment") then par = par.Parent end
        return cheapPos(par)
    end

    local function findPrompt(pet)
        local pod = petPodium(pet)
        if prompt and promptFor==pet and pod and prompt:IsDescendantOf(pod) then return prompt end
        local found
        if pod then
            local base = pod:FindFirstChild("Base")
            local spawn = base and base:FindFirstChild("Spawn")
            local att = spawn and spawn:FindFirstChild("PromptAttachment")
            found = att and att:FindFirstChildWhichIsA("ProximityPrompt")
                or pod:FindFirstChildWhichIsA("ProximityPrompt",true)
        end
        prompt,promptFor = found,pet
        return found
    end

    local function handlers(p)
        local d = {hold={},trigger={}}
        if type(getconnections)~="function" then return d end
        for key,sig in pairs({hold=p.PromptButtonHoldBegan,trigger=p.Triggered}) do
            local ok,cs = pcall(getconnections,sig)
            for _,c in ipairs(ok and cs or {}) do
                if type(c.Function)=="function" then d[key][#d[key]+1]=c.Function end
            end
        end
        return d
    end

    local apCache = setmetatable({},{__mode="k"})
    local function promptObj(p,d)
        local ap = apCache[p]
        if ap~=nil then return ap or nil end
        if debug and debug.getupvalues then
            for _,f in ipairs(d.hold) do
                local ok,ups = pcall(debug.getupvalues,f)
                for _,v in pairs(ok and ups or {}) do
                    if type(v)=="table" and rawget(v,"State")~=nil and rawget(v,"ProximityPrompt")~=nil then
                        apCache[p]=v; return v
                    end
                end
            end
        end
        apCache[p]=false; return nil
    end

    local STEAL_RE = "f40f7d9e-2f0d-4167-b250-899273f46874"
    local function forceSteal(p)
        local st = p:GetAttribute("State")
        if st==nil or st=="Steal" then return end
        local r = remoteByHash(STEAL_RE)
        if not r then return end
        local t = workspace:GetServerTimeNow()+124
        pcall(r.FireServer,r,t,"68c86eb7-eb7e-4b4d-96ae-cf7cd847c5b0")
        pcall(r.FireServer,r,t,"07b9cc25-2a1f-4a26-a0ec-f2fab578d8bd")
        return true
    end

    local function fireHold(p,d)
        if #d.hold==0 then
            local ok,fired = pcall(forceSteal,p)
            return ok and fired==true
        end
        local ap = promptObj(p,d)
        if ap and ap.State~="Steal" then
            local old = ap.State; ap.State="Steal"
            for _,f in ipairs(d.hold) do pcall(f) end
            ap.State=old; return true
        end
        for _,f in ipairs(d.hold) do task.spawn(f) end
        if not ap then pcall(forceSteal,p) end
        return true
    end

    local function notSteal(p)
        local st = p:GetAttribute("State")
        return st~=nil and st~="Steal"
    end

    local function looseName(s) return (tostring(s):lower():gsub("%s+","")) end

    local function stolenByOther(pet)
        if not pet then return false end
        local reg = chans()
        local ch = type(reg)=="table" and rawget(reg,pet.plot)
        local list = ch and chanGet(ch,"AnimalList")
        local ad = type(list)=="table" and (list[pet.slot] or list[tonumber(pet.slot) or pet.slot])
        local uid = type(ad)=="table" and ad.Steal
        if type(uid)=="number" and uid~=LP.UserId then
            local plr = Players:GetPlayerByUserId(uid)
            if plr and plr:GetAttribute("Stealing")==true then return true end
        end
        local pos = petPos(pet)
        local want = looseName(pet.name)
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LP and plr:GetAttribute("Stealing")==true then
                local idx = plr:GetAttribute("StealingIndex")
                local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                local near = root and pos and (root.Position-pos).Magnitude
                if idx~=nil and idx~="" and looseName(idx)==want then
                    if not near or near<=80 then return true end
                elseif idx==nil and near and near<=15 then
                    return true
                end
            end
        end
        return false
    end

    local function fireTrigger(p,d)
        if type(fireproximityprompt)=="function" then pcall(fireproximityprompt,p); return end
        for _,f in ipairs(d.trigger) do task.spawn(f) end
    end

    local function dist(p)
        local hrp = hrpOf()
        local pos = promptPos(p)
        return hrp and pos and (hrp.Position-pos).Magnitude or nil
    end

    local function stillThere(pet)
        local reg = chans()
        local ch = type(reg)=="table" and rawget(reg,pet.plot)
        local list = ch and chanGet(ch,"AnimalList")
        if type(list)~="table" then return false end
        local ad = list[pet.slot] or list[tonumber(pet.slot) or pet.slot]
        return type(ad)=="table" and ad.Index==pet.name
    end

    local function executeSteal(p)
        if holding or not p.Parent or isStealing() then return end
        local d0 = dist(p)
        if d0 and d0>GRAB_RANGE then return end
        local d = handlers(p)
        if #d.hold==0 and #d.trigger==0 and type(fireproximityprompt)~="function" then return end
        holding,abort = true,false
        task.spawn(function()
            pcall(function()
                local oldDur = p.HoldDuration
                pcall(function()
                    p.HoldDuration=0
                    p.MaxActivationDistance=math.huge
                end)
                local beginT,t0
                if p.Enabled~=false and bankAt>0 and tick()-bankAt<=1.25 then
                    beginT,t0 = bankAt,bankAt
                else
                    local held = fireHold(p,d)
                    if not held then for _,f in ipairs(d.hold) do task.spawn(f) end end
                    beginT = (held or p.Enabled~=false) and tick() or 0
                    t0 = tick()
                    if beginT>0 and #d.hold>0 then bankAt=beginT end
                end
                local started = tick()
                local committed,commitAt,inSince = false,0,0
                local wasOff = p.Enabled==false
                local everTaken = wasOff
                local lastCheck,otherAt,other = 0,0,false
                local takenSeen,recapAt,recap = tick(),0,0
                while p.Parent and not abort do
                    if LP:GetAttribute("IsTrading") or LP:GetAttribute("IsDuelSelecting") then break end
                    local _,hum = hrpOf()
                    if not (hum and hum.Health>0) then break end
                    local dd = dist(p)
                    if dd and dd>GRAB_RANGE then break end
                    if #d.hold==0 and (recap<40 or (wasOff and tick()-recapAt>0.25)) then
                        recap+=1; recapAt=tick()
                        d = handlers(p)
                        if #d.hold>0 then fireHold(p,d); beginT,t0=tick(),tick() end
                    end
                    local now = tick()
                    if now-otherAt>0.25 then otherAt=now; other=stolenByOther(target) end
                    if p.Enabled==false or other or notSteal(p) then
                        wasOff,everTaken = true,true
                    elseif wasOff then
                        wasOff=false
                        if now-t0>HOLD then t0=now-HOLD end
                        if now-beginT>2.3 and fireHold(p,d) then beginT=tick() end
                    end
                    if not committed then
                        local due = t0+HOLD
                        if (beginT==0 or now-beginT>HOLD_MAX-0.1
                            or (now<due and now>=due-1.5 and due-beginT>HOLD_MAX-0.1))
                            and fireHold(p,d) then
                            beginT=tick()
                        end
                    end
                    local close = dd~=nil and dd<=COMMIT_RANGE
                    if close then if inSince==0 then inSince=now end
                    else inSince=0 end
                    local taken = p.Enabled==false or other or notSteal(p)
                    if prompt~=p then break end
                    if taken and now-lastCheck>0.25 then
                        lastCheck=now
                        if target and (other or notSteal(p) or stillThere(target)) then
                            takenSeen=now
                        elseif now-takenSeen>3 then break end
                    end
                    barSet(committed and 1 or (now-t0)/HOLD, close, taken)
                    local age = beginT>0 and now-beginT or 0
                    local ready = age>=SERVER_HOLD and age<=HOLD_MAX
                    local nearTaken = dd~=nil and dd<=TAKEN_RANGE
                    if not committed and taken then
                        if now-t0>=HOLD then
                            if nearTaken and ready then fireTrigger(p,d) end
                            if fireHold(p,d) then beginT=tick() end
                            t0=tick()
                        end
                    elseif not committed and ready then
                        if now-t0>=HOLD and ((close and inSince>0 and now-inSince>=0.3)
                            or (everTaken and nearTaken)) then
                            committed,commitAt = true,now
                            fireTrigger(p,d)
                        end
                    end
                    if committed and now-commitAt>=0.4 then break end
                    if not committed and not taken and now-t0>=HOLD+1 then break end
                    if now-started>20 and not taken then break end
                    task.wait(0.03)
                end
                if p.Parent then pcall(function() p.HoldDuration=oldDur end) end
            end)
            holding=false; barHide()
            retryAt = os.clock()+0.4
        end)
    end

    armSteal = function(pet)
        if not pet then return end
        target=pet; S.target=pet
        findPrompt(pet)
    end

    disarmSteal = function()
        target,S.target = nil,nil
        abort,holding = true,false
        prompt,promptFor = nil,nil
        barHide()
    end

    bind(LP:GetAttributeChangedSignal("Stealing"), function()
        if not isStealing() then return end
        if not holding then barHide() end
    end)

    bind(LP.CharacterAdded, function()
        abort,holding = true,false
        barHide()
    end)

    local lastScan = 0
    bind(RunService.Heartbeat, function()
        if not Config.AutoGrab or holding or blocked() then return end
        local now = os.clock()
        if now<retryAt or now-lastTick<0.067 then return end
        lastTick = now
        if now-lastScan>=0.1 then
            lastScan = now
            if target and not stillThere(target) and not stolenByOther(target) then
                disarmSteal()
            end
            if not target then
                -- pick nearest from channels
                local reg = chans()
                if type(reg)=="table" then
                    local best,bd
                    for plotName,ch in next,reg do
                        if isPlotKey(plotName) and type(ch)=="table" and not isMyPlot(ch) then
                            local list = chanGet(ch,"AnimalList")
                            if type(list)=="table" then
                                for slot,ad in pairs(list) do
                                    if type(ad)=="table" and type(ad.Index)=="string" and not isFusing(ad) then
                                        local pet = {name=ad.Index,mutation=adMut(ad),
                                                    plot=tostring(plotName),slot=tostring(slot)}
                                        local pos = petPos(pet)
                                        local hrp = hrpOf()
                                        local d = pos and hrp and (pos-hrp.Position).Magnitude
                                        if d and (not bd or d<bd) then best,bd=pet,d end
                                    end
                                end
                            end
                        end
                    end
                    if best then armSteal(best) end
                end
            end
        end
        if not target then return end
        local p = findPrompt(target)
        if p and p.Parent then
            local dd = dist(p)
            if dd and dd<=GRAB_RANGE then executeSteal(p) end
        end
    end)
end

-- ── BASE CAMP UI + LOGIC ──────────────────
do
    local RC = {active=false,target=nil,plotName=nil,arrived=false}
    S.camp = RC

    local COL = {
        bg     = Color3.fromRGB(14,14,17),
        row    = Color3.fromRGB(30,30,35),
        accent = Color3.fromRGB(167,110,247),
        on     = Color3.fromRGB(80,220,120),
        text   = Color3.fromRGB(240,240,244),
        dim    = Color3.fromRGB(140,140,152),
        stand  = Color3.fromRGB(80,200,255),
        grab   = Color3.fromRGB(80,230,120),
        steal  = Color3.fromRGB(255,90,90),
        stealBg= Color3.fromRGB(70,22,26),
    }

    local function notify(text)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification",
                {Title="Base Camp",Text=text,Duration=4})
        end)
    end

    local function plotOwner(plot)
        if not plot then return nil end
        local reg = chans()
        local ch = type(reg)=="table" and rawget(reg,plot.Name)
        local o = ch and chanGet(ch,"Owner")
        if typeof(o)=="Instance" and o:IsA("Player") then return o end
        if type(o)=="table" and o.UserId then return Players:GetPlayerByUserId(o.UserId) end
        if type(o)=="number" then return Players:GetPlayerByUserId(o) end
        return nil
    end

    local function findPlotFor(plr)
        local plots = workspace:FindFirstChild("Plots")
        if not (plots and plr) then return nil end
        for _,plot in ipairs(plots:GetChildren()) do
            if plotOwner(plot)==plr then return plot end
        end
        return nil
    end

    local function campPlot()
        return RC.plotName and findPlot(RC.plotName) or nil
    end

    local function slotSpawn(slot)
        local base = slot:FindFirstChild("Base")
        return base and base:FindFirstChild("Spawn")
    end

    local function slotPrompt(slot)
        local spawn = slotSpawn(slot)
        local att = spawn and spawn:FindFirstChild("PromptAttachment")
        for _,p in ipairs(att and att:GetChildren() or {}) do
            if p:IsA("ProximityPrompt") and p.Enabled and p.ActionText=="Steal" then return p end
        end
        for _,d in ipairs(slot:GetDescendants()) do
            if d:IsA("ProximityPrompt") and d.Enabled and d.ActionText=="Steal" then return d end
        end
        return nil
    end

    local function sortedSlots(plot)
        local pods = plot and plot:FindFirstChild("AnimalPodiums")
        local slots = {}
        for _,s in ipairs(pods and pods:GetChildren() or {}) do
            local spawn = slotSpawn(s)
            if spawn and spawn:IsA("BasePart") then slots[#slots+1]=s end
        end
        table.sort(slots,function(a,b)
            local na,nb = tonumber(a.Name:match("%d+")),tonumber(b.Name:match("%d+"))
            if na and nb then return na<nb end
            return a.Name<b.Name
        end)
        return slots
    end

    -- build screen gui
    local root
    pcall(function() root = gethui and gethui() end)
    if not root then pcall(function() root = game:GetService("CoreGui") end) end
    local sg = Instance.new("ScreenGui")
    sg.Name = "BaseCamp"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 197
    if not pcall(function() sg.Parent=root end) or not sg.Parent then
        sg.Parent = LP:WaitForChild("PlayerGui")
    end

    local W,H = 230,310
    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(W,H)
    frame.Position = UDim2.new(1,-W-20,0.5,-H/2)
    frame.BackgroundColor3 = COL.bg
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = sg
    Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)
    do
        local st = Instance.new("UIStroke",frame)
        st.Color=COL.accent; st.Transparency=0.6
    end

    local bar2 = Instance.new("Frame",frame)
    bar2.Size = UDim2.new(1,0,0,28)
    bar2.BackgroundTransparency = 1
    local title = Instance.new("TextLabel",bar2)
    title.Size = UDim2.new(1,-40,1,0)
    title.Position = UDim2.fromOffset(20,0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 12
    title.TextColor3 = COL.accent
    title.Text = "BASE CAMP"

    local body = Instance.new("Frame",frame)
    body.Size = UDim2.new(1,0,1,-28)
    body.Position = UDim2.fromOffset(0,28)
    body.BackgroundTransparency = 1

    local toggle = Instance.new("TextButton",body)
    toggle.Size = UDim2.new(1,-66,0,30)
    toggle.Position = UDim2.fromOffset(8,2)
    toggle.BorderSizePixel = 0
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 13
    toggle.AutoButtonColor = false
    toggle.TextTruncate = Enum.TextTruncate.AtEnd
    Instance.new("UICorner",toggle).CornerRadius = UDim.new(0,8)

    local tpBtn = Instance.new("TextButton",body)
    tpBtn.Size = UDim2.fromOffset(46,30)
    tpBtn.Position = UDim2.new(1,-54,0,2)
    tpBtn.BorderSizePixel = 0
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 13
    tpBtn.Text = "TP"
    tpBtn.TextColor3 = COL.text
    tpBtn.BackgroundColor3 = COL.row
    Instance.new("UICorner",tpBtn).CornerRadius = UDim.new(0,8)

    local status = Instance.new("TextLabel",body)
    status.Size = UDim2.new(1,-16,0,56)
    status.Position = UDim2.fromOffset(8,36)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 11
    status.TextColor3 = COL.dim
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextYAlignment = Enum.TextYAlignment.Top
    status.TextWrapped = true
    status.RichText = true

    local listLbl = Instance.new("TextLabel",body)
    listLbl.Size = UDim2.new(1,-16,0,14)
    listLbl.Position = UDim2.fromOffset(8,96)
    listLbl.BackgroundTransparency = 1
    listLbl.Font = Enum.Font.GothamBold
    listLbl.TextSize = 10
    listLbl.TextColor3 = COL.dim
    listLbl.TextXAlignment = Enum.TextXAlignment.Left
    listLbl.Text = "PICK A PLAYER"

    local list = Instance.new("ScrollingFrame",body)
    list.Size = UDim2.new(1,-16,1,-114)
    list.Position = UDim2.fromOffset(8,112)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 3
    list.ScrollBarImageColor3 = COL.accent
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.CanvasSize = UDim2.new()
    local layout = Instance.new("UIListLayout",list)
    layout.Padding = UDim.new(0,4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- dragging
    do
        local dragging,from,start
        bar2.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1
                or i.UserInputType==Enum.UserInputType.Touch then
                dragging,from,start=true,i.Position,frame.Position
            end
        end)
        bind(UIS.InputChanged,function(i)
            if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement
                or i.UserInputType==Enum.UserInputType.Touch) then
                local d=i.Position-from
                frame.Position=UDim2.new(start.X.Scale,start.X.Offset+d.X,start.Y.Scale,start.Y.Offset+d.Y)
            end
        end)
        bind(UIS.InputEnded,function(i)
            if dragging and (i.UserInputType==Enum.UserInputType.MouseButton1
                or i.UserInputType==Enum.UserInputType.Touch) then dragging=false end
        end)
    end

    local selected = nil
    local rows = {}

    local function refreshToggle()
        toggle.Text = RC.active and ("CAMP: ON  -  "..tostring(RC.target)) or "CAMP: OFF"
        toggle.BackgroundColor3 = RC.active and COL.on or COL.row
        toggle.TextColor3 = RC.active and Color3.fromRGB(10,10,12) or COL.text
    end

    local function slotNum(slot)
        return slot and (slot.Name:match("%d+") or slot.Name) or "-"
    end

    -- camp TP
    local tpGen = 0
    local function tpToCampSlot(plot)
        if not plot then return false,"base not found" end
        if isStealing() then return false,"you are stealing" end
        local hrp,hum = hrpOf()
        if not (hrp and hum and hum.Health>0) then return false,"no character" end
        local pods = plot:FindFirstChild("AnimalPodiums")
        local slots = sortedSlots(plot)
        local stand = slots[1]
        local slot = stand
        local spawn = slot and slotSpawn(slot)
        if not spawn then return false,"no slots" end
        tpGen+=1; local my=tpGen
        RC.arrived=false
        task.spawn(function()
            local t0=os.clock()
            while S.tpBusy and os.clock()-t0<5 do task.wait(0.1) end
            if my~=tpGen then return end
            local h = hrpOf()
            if h and spawn.Parent then
                h.AssemblyLinearVelocity=Vector3.zero
                h.AssemblyAngularVelocity=Vector3.zero
                LP.Character:PivotTo(CFrame.new(spawn.Position+Vector3.new(0,3,0)))
            end
            RC.arrived=true
        end)
        return true,"slot "..(slot.Name:match("%d+") or slot.Name)
    end

    RC.start = function(name)
        local plr = name and Players:FindFirstChild(name)
        if not plr or plr==LP then return false,"player not found" end
        disarmSteal()
        RC.target,RC.active,RC.arrived = plr.Name,true,false
        local plot = findPlotFor(plr)
        RC.plotName = plot and plot.Name or nil
        refreshToggle()
        local want = plr.Name
        task.spawn(function()
            local t0=os.clock()
            while RC.active and RC.target==want and not RC.plotName and os.clock()-t0<5 do
                task.wait(0.2)
                local p=findPlotFor(plr)
                if p then RC.plotName=p.Name end
            end
            if not (RC.active and RC.target==want) then return end
            local ok,why = tpToCampSlot(campPlot() or findPlotFor(plr))
            notify(ok and ("TP to "..want.."'s "..(why or "")) or ("TP failed: "..tostring(why)))
        end)
        return true
    end

    RC.stop = function()
        tpGen+=1
        RC.active,RC.plotName,RC.arrived = false,nil,false
        disarmSteal()
        refreshToggle()
    end

    toggle.MouseButton1Click:Connect(function()
        if RC.active then RC.stop()
        elseif selected then
            local ok,why = RC.start(selected)
            if not ok then notify(why) end
        else notify("Pick a player first") end
    end)

    tpBtn.MouseButton1Click:Connect(function()
        local name = (RC.active and RC.target) or selected
        if not name then notify("Pick a player first"); return end
        local ok,why = tpToCampSlot(findPlotFor(Players:FindFirstChild(name)))
        notify(ok and ("TP to "..name.."'s "..(why or "")) or ("TP failed: "..tostring(why)))
    end)

    local function refreshRows()
        for _,b in pairs(rows) do
            local on = b.Name==selected
            b.BackgroundColor3 = on and COL.accent or COL.row
            b.TextColor3 = on and Color3.fromRGB(10,10,12) or COL.text
        end
    end

    local function addRow(plr)
        if plr==LP or rows[plr.Name] then return end
        local b = Instance.new("TextButton")
        b.Name = plr.Name
        b.Size = UDim2.new(1,-4,0,24)
        b.BorderSizePixel = 0
        b.Font = Enum.Font.Gotham
        b.TextSize = 11
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.AutoButtonColor = false
        b.Text = "  "..plr.DisplayName.."  (@"..plr.Name..")"
        b.TextTruncate = Enum.TextTruncate.AtEnd
        b.Parent = list
        Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)
        rows[plr.Name]=b
        b.MouseButton1Click:Connect(function()
            selected=plr.Name
            refreshRows()
            if RC.active and RC.target~=plr.Name then RC.start(plr.Name) end
        end)
        refreshRows()
    end

    for _,p in ipairs(Players:GetPlayers()) do addRow(p) end
    bind(Players.PlayerAdded,addRow)
    bind(Players.PlayerRemoving,function(p)
        local b=rows[p.Name]
        if b then b:Destroy(); rows[p.Name]=nil end
        if selected==p.Name then selected=nil end
        if RC.active and RC.target==p.Name then
            notify(p.Name.." left — camp off")
            RC.stop()
        end
    end)

    refreshToggle()

    -- status updater
    task.spawn(function()
        while true do
            pcall(function()
                if not RC.active then
                    status.Text = selected and ("Selected: <b>"..selected.."</b>\nToggle on to camp their base.")
                        or "Pick a player below, then toggle on."
                    return
                end
                local plr = Players:FindFirstChild(RC.target or "")
                if not plr then RC.stop(); return end
                local plot = campPlot()
                if not plot then
                    plot=findPlotFor(plr); RC.plotName=plot and plot.Name or nil
                end
                if not plot then
                    status.Text="Target: <b>"..RC.target.."</b>\nlooking for their base..."
                    return
                end
                local slots = sortedSlots(plot)
                local stand,grab
                for _,s in ipairs(slots) do
                    if slotPrompt(s) then grab=grab or s
                    else stand=stand or s end
                end
                status.Text = "Target: <b>"..RC.target.."</b>"
                    .."\nStand: <font color='#50c8ff'>Slot "..slotNum(stand).."</font>"
                    .."   Grab: <font color='#50e678'>Slot "..slotNum(grab).."</font>"
                    ..(grab and "\n"..tostring(grab.Name) or "\nbase is empty")
            end)
            task.wait(0.3)
        end
    end)

    -- camp auto-fire proximity prompts
    local tracked2,lastFire2,lastBurst2 = {},{},{}
    local function fire2(p,n,debounce)
        if type(fireproximityprompt)~="function" or not p.Parent or not p.Enabled then return end
        local now=os.clock()
        if lastFire2[p] and now-lastFire2[p]<debounce then return end
        lastFire2[p]=now
        local md=p.MaxActivationDistance
        pcall(function() p.MaxActivationDistance=math.huge end)
        for _=1,n do pcall(fireproximityprompt,p,0) end
        pcall(function() p.MaxActivationDistance=md end)
    end
    local function track2(p)
        if tracked2[p] then return end
        tracked2[p]=true
        bind(p:GetPropertyChangedSignal("Enabled"),function()
            if p.Enabled then
                local hrp=hrpOf()
                if hrp and RC.active and RC.arrived then fire2(p,25,0) end
            end
        end)
        bind(p.AncestryChanged,function()
            if not p:IsDescendantOf(workspace) then
                tracked2[p],lastFire2[p],lastBurst2[p]=nil,nil,nil
            end
        end)
    end
    local plots2=workspace:FindFirstChild("Plots")
    if plots2 then
        for _,plot in ipairs(plots2:GetChildren()) do
            local pods=plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _,d in ipairs(pods:GetDescendants()) do
                    if d:IsA("ProximityPrompt") then track2(d) end
                end
            end
        end
    end
    bind(workspace.DescendantAdded,function(d)
        if d:IsA("ProximityPrompt") and d:FindFirstAncestor("AnimalPodiums") then track2(d) end
    end)
    task.spawn(function()
        while true do
            task.wait(0.1)
            if RC.active and RC.arrived then
                local hrp=hrpOf()
                if hrp then
                    local plot=campPlot()
                    for p in pairs(tracked2) do
                        if p.Parent and p.Enabled then
                            local at=cheapPos(p.Parent:IsA("Attachment") and p.Parent.Parent or p.Parent)
                            if at then
                                local d=(at-hrp.Position).Magnitude
                                local inPlot = plot and p:IsDescendantOf(plot)
                                if inPlot and d<=120 then fire2(p,3,0.12) end
                            end
                        end
                    end
                end
            end
        end
    end)
end