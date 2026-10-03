-- leak by FS│https://discord.gg/TBBAUZu8cW

local print = function() end
local warn  = function() end
_G.MynxxInvisAuto = false
_G.MynxxAutoKickOnSteal = false
_G.MynxxAutoBuy = false
if _G.MynxxStealMode == nil then _G.MynxxStealMode = "priority" end
if _G.MynxxAutoTP == nil then _G.MynxxAutoTP = true end

if not game:IsLoaded() then game.Loaded:Wait() end

_G.MynxxPriVersion = _G.MynxxPriVersion or 0
if type(_G.MynxxPriorityDefault) ~= "table" then _G.MynxxPriorityDefault = {} end
if type(_G.SHARED_PRIORITY_ITEMS) ~= "table" then _G.SHARED_PRIORITY_ITEMS = {} end

_G.MynxxMutVersion = _G.MynxxMutVersion or 0
if type(_G.MynxxMutationDefault) ~= "table" then
    _G.MynxxMutationDefault = {
        "Crystal", "Phantom", "Cyber", "Rainbow", "Divine", "Cursed",
        "Radioactive", "Yinyang", "Galaxy", "Lava", "Candy", "Bloodrot",
        "Diamond", "Gold", "Normal",
    }
end
if type(_G.SHARED_MUTATION_ITEMS) ~= "table" then
    _G.SHARED_MUTATION_ITEMS = {}
    for i = 1, #_G.MynxxMutationDefault do _G.SHARED_MUTATION_ITEMS[i] = _G.MynxxMutationDefault[i] end
end

if LPH_OBFUSCATED == nil then
    local env = getfenv()
    env["LPH_NO_" .. "VIRTUALIZE"] = function(...) return ... end
    env["LPH_JIT_" .. "MAX"]       = function(...) return ... end
end

    local _HS = game:GetService("HttpService")
    local _TS = game:GetService("TeleportService")
    local fileData, tpData
        pcall(function()
            local raw = readfile("SideTP.json")
            if type(raw) == "string" and #raw > 0 then fileData = _HS:JSONDecode(raw) end
        end)
    end
    pcall(function()
        local td = _TS:GetLocalPlayerTeleportData()
        if td and td.SideTP then tpData = td.SideTP end
    end)
    local merged = {}
    if type(tpData) == "table" then for k, v in pairs(tpData) do merged[k] = v end end
    if type(fileData) == "table" then for k, v in pairs(fileData) do merged[k] = v end end

    if type(merged.tpDelay) == "number" then _G._stp_tpDelay = merged.tpDelay end
    if type(merged.tpVelocity) == "number" then _G.TPVelocity = math.clamp(merged.tpVelocity, 200, 750) end
    if type(merged.climbSpeed) == "number" then _G.MynxxClimb = math.clamp(merged.climbSpeed, 100, 250) end
    if type(merged.cframeSpeed) == "number" then _G.MynxxCFrameSpeed = math.clamp(merged.cframeSpeed, 100, 900) end
    if type(merged.walkSpeed) == "number" then _G.MynxxWalkSpeed = math.clamp(merged.walkSpeed, 16, 27) end
    if type(merged.carpetTool) == "string" then _G.MynxxCarpetTool = merged.carpetTool end
    if type(merged.landingDelay) == "number" then _G.LandingDelay = math.clamp(merged.landingDelay, 0.05, 0.75) end
    if type(merged.closeSpeed) == "number" then _G.MynxxCloseSpeed = math.clamp(merged.closeSpeed, 20, 400) end
    if type(merged.tpKey) == "string" then _G._stp_tpKeyName = merged.tpKey end
    if type(merged.nearestKey) == "string" then _G.MynxxNearestKey = merged.nearestKey end
    if type(merged.prioritySoundID) == "string" then _G.MynxxPrioritySoundID = merged.prioritySoundID end
    
    
    _G.MynxxStealMode = "priority"
    _G._stealUserOff = false
    
    
    if type(merged.priorityList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.priorityList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_PRIORITY_ITEMS
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
            _G.MynxxPriVersion = _G.MynxxPriVersion + 1
        end
    end
    
    if type(merged.priorityDefault) == "table" then
        local d = {}
        for _, v in ipairs(merged.priorityDefault) do
            if type(v) == "string" and v ~= "" then d[#d + 1] = v end
        end
        if #d > 0 then _G.MynxxPriorityDefault = d end
    end
    
    if type(merged.mutationList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.mutationList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_MUTATION_ITEMS
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
            _G.MynxxMutVersion = _G.MynxxMutVersion + 1
        end
    end
    if type(merged.mutationDefault) == "table" then
        local d = {}
        for _, v in ipairs(merged.mutationDefault) do
            if type(v) == "string" and v ~= "" then d[#d + 1] = v end
        end
        if #d > 0 then _G.MynxxMutationDefault = d end
    end
    if type(merged.invisAuto) == "boolean" then _G.MynxxInvisAuto = merged.invisAuto end
    if type(merged.invisDepth) == "number" then _G.MynxxInvisDepth = math.clamp(merged.invisDepth, 0, 10) end
    if type(merged.invisAngle) == "number" then _G.MynxxInvisAngle = math.clamp(merged.invisAngle, 0, 360) end
    if type(merged.autoTp) == "boolean" then _G.MynxxAutoTP = merged.autoTp end
    if type(merged.autoBuy) == "boolean" then _G.MynxxAutoBuy = merged.autoBuy end
    if type(merged.autoBuyRange) == "number" then _G.MynxxAutoBuyRange = math.clamp(merged.autoBuyRange, 5, 40) end
    if type(merged.panelX) == "number" then _G._stp_panelX = merged.panelX end
    if type(merged.panelY) == "number" then _G._stp_panelY = merged.panelY end
    if type(merged.panelPos) == "table" then _G._stp_pos = merged.panelPos end
    if type(merged.autoKickOnSteal) == "boolean" then _G.MynxxAutoKickOnSteal     = merged.autoKickOnSteal end
    if type(merged.resetKey)        == "string"  then _G.MynxxResetKeyName        = merged.resetKey end
    if type(merged.cloneKey)        == "string"  then _G.MynxxCloneKeyName        = merged.cloneKey end
    if type(merged.carpetSpeedKey)  == "string"  then _G.MynxxCarpetSpeedKeyName  = merged.carpetSpeedKey end

    
    _G.MynxxAutoTP = true
        pcall(function()
            local t = type(fileData) == "table" and fileData or {}
            t.autoTp = true
            writefile("SideTP.json", _HS:JSONEncode(t))
        end)
    end
end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local RS         = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

_G.MynxxIsMobile = (UIS.TouchEnabled == true)

local _XU = {
    bg       = Color3.fromRGB(8, 12, 20),
    bgSoft   = Color3.fromRGB(14, 20, 32),
    bgBtn    = Color3.fromRGB(24, 32, 48),
    bgBtnOn  = Color3.fromRGB(45, 130, 255),
    bgBtnOff = Color3.fromRGB(32, 40, 55),
    stroke   = Color3.fromRGB(90, 170, 255),
    strokeDim= Color3.fromRGB(60, 80, 110),
    text     = Color3.fromRGB(245, 248, 255),
    muted    = Color3.fromRGB(160, 175, 200),
    accent   = Color3.fromRGB(70, 150, 255),
    header   = Color3.fromRGB(120, 190, 255),
}
_G.XyntrixUI = _XU

local function _xuEnsureCorner(inst, r)
    local c = inst:FindFirstChildOfClass("UICorner")
        c = Instance.new("UICorner")
        c.Parent = inst
    end
    c.CornerRadius = UDim.new(0, r or 12)
end

local function _xuEnsureStroke(inst, color, thick, trans)
    local s = inst:FindFirstChildOfClass("UIStroke")
        s = Instance.new("UIStroke")
        s.Parent = inst
    end
    s.Color = color or _XU.stroke
    s.Thickness = thick or 1.2
    s.Transparency = trans or 0.35
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local function _xuLooksOn(c)
    
    if c.B > 0.55 and c.R < 0.45 and c.G < 0.65 then return true end
    
    if c.R > 0.55 and c.G < 0.45 then return true end
end

_G.XyntrixStylePanel = function(frame)
    if not frame or not frame:IsA("GuiObject") then return end
    pcall(function()
        frame.BackgroundColor3 = _XU.bg
        frame.BackgroundTransparency = 0
        frame.BorderSizePixel = 0
        _xuEnsureCorner(frame, 14)
        _xuEnsureStroke(frame, _XU.stroke, 1.4, 0.4)
        local bar = frame:FindFirstChild("_XynAccent")
            bar = Instance.new("Frame")
            bar.Name = "_XynAccent"
            bar.Size = UDim2.new(1, 0, 0, 3)
            bar.Position = UDim2.new(0, 0, 0, 0)
            bar.BorderSizePixel = 0
            bar.BackgroundColor3 = _XU.accent
            bar.ZIndex = (frame.ZIndex or 1) + 2
            bar.Active = false
            bar.Parent = frame
            _xuEnsureCorner(bar, 2)
            local g = Instance.new("UIGradient")
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 120, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 190, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 240, 255)),
            })
            g.Parent = bar
        end
        
        local sh = frame:FindFirstChild("_XynShadow")
            sh = Instance.new("ImageLabel")
            sh.Name = "_XynShadow"
            sh.BackgroundTransparency = 1
            sh.Image = "rbxassetid://6014261993"
            sh.ImageColor3 = Color3.fromRGB(0, 0, 0)
            sh.ImageTransparency = 0.6
            sh.ScaleType = Enum.ScaleType.Slice
            sh.SliceCenter = Rect.new(49, 49, 450, 450)
            sh.Size = UDim2.new(1, 20, 1, 20)
            sh.Position = UDim2.new(0, -10, 0, -8)
            sh.ZIndex = math.max(0, (frame.ZIndex or 1) - 1)
            sh.Active = false
            sh.Selectable = false
            sh.Parent = frame
        end
    end)
end

_G.XyntrixStyleTitle = function(lbl)
    pcall(function()
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = math.max(lbl.TextSize or 13, 13)
        lbl.TextColor3 = _XU.text
        lbl.TextStrokeTransparency = 0.7
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        if lbl:IsA("TextButton") then
            lbl.AutoButtonColor = false
            lbl.BackgroundTransparency = 1
        end
    end)
end

_G.XyntrixStyleBtn = function(btn, isOn)
    if not btn or not btn:IsA("GuiButton") then return end
    pcall(function()
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = _XU.text
        btn.TextSize = math.clamp(btn.TextSize or 11, 10, 13)
        _xuEnsureCorner(btn, 8)
        if isOn == true or (isOn == nil and _xuLooksOn(btn.BackgroundColor3)) then
            btn.BackgroundColor3 = _XU.bgBtnOn
            _xuEnsureStroke(btn, Color3.fromRGB(140, 200, 255), 1, 0.45)
        elseif isOn == false then
            btn.BackgroundColor3 = _XU.bgBtnOff
            _xuEnsureStroke(btn, _XU.strokeDim, 1, 0.55)
            if btn.BackgroundTransparency >= 0.9 then return end
            btn.BackgroundColor3 = _XU.bgBtn
            _xuEnsureStroke(btn, _XU.strokeDim, 1, 0.6)
        end
    end)
end

_G.XyntrixPolish = function(root)
    pcall(function()
        if root:GetAttribute("_XynPolished") then
            
            if root:IsA("Frame") then _G.XyntrixStylePanel(root) end
            return
        end
        root:SetAttribute("_XynPolished", true)
        if root:IsA("Frame") or root:IsA("ScrollingFrame") then
            _G.XyntrixStylePanel(root)
        end
        for _, d in ipairs(root:GetDescendants()) do
            if d.Name == "_XynAccent" or d.Name == "_XynShadow" then
                
            elseif d:IsA("TextButton") then
                if d.Size.Y.Offset >= 22 and d.Size.Y.Offset <= 34
                   and d.Position.Y.Offset <= 4
                   and (d.BackgroundTransparency or 0) > 0.5 then
                    _G.XyntrixStyleTitle(d)
                elseif d.BackgroundTransparency < 0.9 then
                    _G.XyntrixStyleBtn(d, nil)
                end
            elseif d:IsA("TextLabel") then
                if d.Font == Enum.Font.GothamBlack or (d.TextSize or 0) >= 12 then
                    d.TextColor3 = _XU.text
                end
            elseif d:IsA("TextBox") then
                d.BackgroundColor3 = _XU.bgSoft
                d.TextColor3 = _XU.text
                d.PlaceholderColor3 = _XU.muted
                d.BorderSizePixel = 0
                _xuEnsureCorner(d, 8)
                _xuEnsureStroke(d, _XU.strokeDim, 1, 0.5)
            elseif d:IsA("ScrollingFrame") then
                d.BackgroundColor3 = _XU.bgSoft
                d.BorderSizePixel = 0
                d.ScrollBarImageColor3 = _XU.accent
                _xuEnsureCorner(d, 8)
            end
        end
    end)
end

_G.MynxxCenterPanel = function(frame, mobileW, mobileH)
    pcall(_G.XyntrixStylePanel, frame)
    pcall(function()
        local cam = workspace.CurrentCamera
        local vw = (cam and cam.ViewportSize.X) or 390
        local vh = (cam and cam.ViewportSize.Y) or 700
        if _G.MynxxIsMobile then
            local maxW = math.max(160, math.floor(vw * 0.86))
            local maxH = math.max(140, math.floor(vh * 0.70))
            if type(mobileW) == "number" and type(mobileH) == "number" then
                frame.Size = UDim2.fromOffset(math.min(mobileW, maxW), math.min(mobileH, maxH))
                local w = frame.Size.X.Offset
                local h = frame.Size.Y.Offset
                if w > 0 and h > 0 then
                    local nw = math.min(math.floor(w * 0.88), maxW)
                    local nh = math.min(math.floor(h * 0.90), maxH)
                    if nw < 160 then nw = math.min(w, maxW) end
                    if nh < 120 then nh = math.min(h, maxH) end
                    frame.Size = UDim2.fromOffset(nw, nh)
                end
            end
        end
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        frame:SetAttribute("_XynCentered", true)
    end)
end

_G.XyntrixDragStart = function(target)
    if not target then return 0, 0 end
    return target.Position.X.Offset, target.Position.Y.Offset
end
_G.XyntrixDragTo = function(target, startX, startY, dx, dy)
    local ox, oy = startX + dx, startY + dy
    if target:GetAttribute("_XynCentered") or (target.AnchorPoint.X > 0.4 and target.AnchorPoint.Y > 0.4) then
        target.AnchorPoint = Vector2.new(0.5, 0.5)
        target.Position = UDim2.new(0.5, ox, 0.5, oy)
        target.Position = UDim2.fromOffset(ox, oy)
    end
end

task.spawn(function()
    local names = {
        TPStealTestUI = true, MynxxStealTargetUI = true, InvisStealUI = true,
        CarpetCloneUI = true, AutoKickUI = true, FlasherUI = true,
        MynxxWatermark = true,
    }
    local done = {}
    local function tryPolish(inst)
        if not inst or not inst:IsA("ScreenGui") or not names[inst.Name] then return end
        if done[inst] then return end
        for _, ch in ipairs(inst:GetChildren()) do
            if ch:IsA("Frame") and not ch:GetAttribute("_XynPolished") then
                pcall(_G.XyntrixPolish, ch)
            end
        end
        
        local all = true
        for _, ch in ipairs(inst:GetChildren()) do
            if ch:IsA("Frame") and not ch:GetAttribute("_XynPolished") then all = false; break end
        end
        if all then done[inst] = true end
    end
    for _ = 1, 24 do
        local parents = {}
        pcall(function() if gethui then parents[#parents + 1] = gethui() end end)
        pcall(function() parents[#parents + 1] = game:GetService("CoreGui") end)
        pcall(function()
            local lp = game:GetService("Players").LocalPlayer
            if lp then parents[#parents + 1] = lp:FindFirstChild("PlayerGui") end
        end)
        for _, p in ipairs(parents) do
            if p then for _, ch in ipairs(p:GetChildren()) do tryPolish(ch) end end
        end
        task.wait(0.35)
    end
end)

_G.XyntrixLogSteal = function() end
_G.XyntrixArmStealLog = function() end
_G.MynxxLog = function() end
_G.LogSteal = function() end

local _BLOCKING_MACHINE_TYPES = {
    Fuse     = true,
    Duel     = true,
    Trade    = true,
    Crafting = true,
}
local function _MynxxIsFusing(animalData)
    if type(animalData) ~= "table" then return false end
    local m = animalData.Machine
    if type(m) ~= "table" then return false end
    return _BLOCKING_MACHINE_TYPES[m.Type] == true
end

local _nf=game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net")
local function _xnGetNet()
local ok,mod=pcall(require,_nf)
if ok and type(mod)=="table" then _xnNetMod=mod end
end
local _xnGetUps=debug.getupvalues or getupvalues
local _XNGUID="^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
local function _xnFindSecret()
local Net=_xnGetNet()
local seen,found={},nil
local job=game.JobId
local function walk(t,depth)
if depth>4 or found or seen[t] then return end
seen[t]=true
for _,v in pairs(t) do
local tv=typeof(v)
if tv=="string" and #v==36 and v~=job and v:match(_XNGUID) then
found=v
return
elseif tv=="table" then
walk(v,depth+1)
elseif tv=="function" then
local ok,u=pcall(_xnGetUps,v)
if ok and type(u)=="table" then walk(u,depth+1) end
end
end
end
for _,k in ipairs({"RemoteEvent","RemoteFunction","UnreliableRemoteEvent"}) do
local f=rawget(Net,k)
if type(f)=="function" then
local ok,u=pcall(_xnGetUps,f)
if ok and type(u)=="table" then walk(u,0) end
end
end
end
local function _xnEncode(name)
local job=game.JobId
local out,idx={},1
for i=1,#name do
local ch=name:byte(i)
if ch==0x2F then
out[#out+1]="/"
local s=job:byte(((idx-1)%36)+1)%95
out[#out+1]=string.char(((ch-0x20+s)%95)+0x20)
idx=idx+1
end
end
return table.concat(out)
end
local bit=bit32
local band,bor,bxor,bnot,rrotate,rshift,lshift=bit.band,bit.bor,bit.bxor,bit.bnot,bit.rrotate,bit.rshift,bit.lshift
local K={
0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
local function m32(x) return band(x,0xFFFFFFFF) end
local function _bin(msg)
local h={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
local len=#msg
msg=msg.."\128"
while #msg%64~=56 do msg=msg.."\0" end
local bl=len*8
local lb={}
for i=8,1,-1 do lb[i]=string.char(bl%256) bl=math.floor(bl/256) end
msg=msg..table.concat(lb)
for cs=1,#msg,64 do
local w={}
for i=0,15 do
local a,b,c,d=string.byte(msg,cs+i*4,cs+i*4+3)
w[i]=bor(lshift(a,24),lshift(b,16),lshift(c,8),d)
end
for i=16,63 do
local x=w[i-15]
local s0=bxor(rrotate(x,7),rrotate(x,18),rshift(x,3))
local y=w[i-2]
local s1=bxor(rrotate(y,17),rrotate(y,19),rshift(y,10))
w[i]=m32(w[i-16]+s0+w[i-7]+s1)
end
local a,b,c,d,e,f,g,hh=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]
for i=0,63 do
local S1=bxor(rrotate(e,6),rrotate(e,11),rrotate(e,25))
local ch=bxor(band(e,f),band(bnot(e),g))
local t1=m32(hh+S1+ch+K[i+1]+w[i])
local S0=bxor(rrotate(a,2),rrotate(a,13),rrotate(a,22))
local maj=bxor(band(a,b),band(a,c),band(b,c))
local t2=m32(S0+maj)
hh=g g=f f=e e=m32(d+t1) d=c c=b b=a a=m32(t1+t2)
end
h[1]=m32(h[1]+a) h[2]=m32(h[2]+b) h[3]=m32(h[3]+c) h[4]=m32(h[4]+d)
h[5]=m32(h[5]+e) h[6]=m32(h[6]+f) h[7]=m32(h[7]+g) h[8]=m32(h[8]+hh)
end
local out={}
for i=1,8 do
local x=h[i]
out[i]=string.char(band(rshift(x,24),255),band(rshift(x,16),255),band(rshift(x,8),255),band(x,255))
end
return table.concat(out)
end
local _memo={}
_xnSha256=function(s)
local c=_memo[s]
local ok,b=pcall(_bin,s)
if not ok or type(b)~="string" then return nil end
local hex=(b:gsub(".",function(ch) return string.format("%02x",string.byte(ch)) end))
_memo[s]=hex
end
end
local function _xnHash(name)
return _xnSha256(_xnEncode(name).._xnSecret..game.JobId)
end
_xnSecret=_xnFindSecret()
local _xnCache={}
local function _get(name,kind)
kind=(kind=="RemoteFunction" and "RemoteFunction")or(kind=="UnreliableRemoteEvent" and "UnreliableRemoteEvent")or"RemoteEvent"
if type(name)~="string" or name=="" then return nil end
local logical=name:match("^R[EF]/(.+)$")or name:match("^URE/(.+)$")or name
local ck=kind.."|"..logical
local hit=_xnCache[ck]
if hit and hit.Parent then return hit end
_xnCache[ck]=nil
if not _xnSecret then _xnSecret=_xnFindSecret() end
local h=_xnHash(logical)
local p=(kind=="RemoteFunction" and "RF/")or(kind=="UnreliableRemoteEvent" and "URE/")or"RE/"
local inst=_nf:FindFirstChild(p..h)
_xnCache[ck]=inst
end
end
_G.XenNet={
RemoteEvent=function(_,name)return _get(name,"RemoteEvent")end,
RemoteFunction=function(_,name)return _get(name,"RemoteFunction")end,
UnreliableRemoteEvent=function(_,name)return _get(name,"UnreliableRemoteEvent")end,
}
_G.XenGetRemote=_get
_G.Resolve=_get
_G.HashOf=_xnHash
_G.NetSecret=function()return _xnSecret end
_G.__secureGetRemote=function(method,name) return _get(name,method) end
local _xnDummy=Instance.new("RemoteEvent")
local _xnRawFire=clonefunction(_xnDummy.FireServer)
_G.RawFire=function(name,...)
local r=_get(name)
_xnRawFire(r,...)
end
end
task.spawn(function()
task.wait(10)
if not(_xnSecret and _get("UseItem")) then
_xnSecret=_xnFindSecret()
_xnCache={}
end
end
end)
end

local _lastSweep = 0
local _dirty = true
local SWEEP_GAP = 0.5

local function _classTable()
    local ok, c = pcall(function()
        return require(game:GetService("ReplicatedStorage")
            :WaitForChild("Packages")
            :WaitForChild("Synchronizer")
            :WaitForChild("Channel"))
    end)
    if ok and type(c) == "table" then _class = c end
end

local function _sweep()
    local cls = _classTable()
    if not cls or type(getgc) ~= "function" then
        _G.MynxxSyncDiag = cls and "getgc unavailable" or "Channel class not found"
        return
    end
    _lastSweep = os.clock()
    _dirty = false
    local reg, n = {}, 0
    local gc = getgc(true)
    for i = 1, #gc do
        local v = gc[i]
        if type(v) == "table" and getmetatable(v) == cls then
            local idx = rawget(v, "Index")
            if idx ~= nil then reg[idx] = v; n = n + 1 end
        end
    end
    _xchan = reg
    _G.MynxxSyncDiag = string.format("heap identity - %d channels", n)
end

local function _needsSweep()
    local pl = workspace:FindFirstChild("Plots")
        for _, p in ipairs(pl:GetChildren()) do
            if _xchan[p.Name] == nil then return true end
        end
    end
end

    local pl = workspace:FindFirstChild("Plots")
        pl.ChildAdded:Connect(function() _dirty = true end)
        pl.ChildRemoved:Connect(function() _dirty = true end)
    end
end

local function _chans()
    if _needsSweep() and (os.clock() - _lastSweep) > SWEEP_GAP then _sweep() end
end
_G.__secureChans = _chans

_G.MynxxSyncAll=function()return _chans()end
_G.MynxxSyncGet=function(idx)
local t=_chans()
if not t or idx==nil then return nil end
local ok,cd=pcall(rawget,t,idx)
if ok and type(cd)=="table" then return cd end
local ok2,cd2=pcall(function() return t[idx] end)
if ok2 and type(cd2)=="table" then return cd2 end
end

_G.sProp=function(ch,key)
if type(ch)~="table" or key==nil then return nil end
local ct=rawget(ch,"CacheTable")
if type(ct)~="table" then
local okC,c2=pcall(function() return ch.CacheTable end)
if okC and type(c2)=="table" then ct=c2 end
end
if type(ct)~="table" then return nil end
local v=rawget(ct,key)
if v~=nil then return v end
local okV,v2=pcall(function() return ct[key] end)
end
_G._mynxxRawCT=function(plotName)
local c=_G.MynxxSyncGet(plotName)
return rawget(c,"CacheTable")
end
local _AD,_MD,_TD
local function _data()
local ok=pcall(function()
local d=game:GetService("ReplicatedStorage"):WaitForChild("Datas")
_AD=require(d:WaitForChild("Animals"))
_MD=require(d:WaitForChild("Mutations"))
_TD=require(d:WaitForChild("Traits"))
end)
return ok and _AD~=nil
end
_G._mynxxGen=function(index,mutation,traits)
if not _data() then return 0 end
local info=_AD[index]
if not info or not info.Generation then return 0 end
local mult=1
if mutation and mutation~="None" and mutation~="" then
local m=_MD[mutation]
if m and m.Modifier then mult=mult+m.Modifier end
end
if type(traits)=="table" then
for _,tr in ipairs(traits)do
local t=_TD[tr]
if t and t.MultiplierModifier then mult=mult+t.MultiplierModifier end
end
end
return info.Generation*mult
end
_G._mynxxAnimShim=setmetatable({GetGeneration=function(_,index,mutation,traits)return _G._mynxxGen(index,mutation,traits)end},{
__index=function(_,k)
local ok,real=pcall(function()return require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Animals"))end)
if ok and type(real)=="table" then return rawget(real,k) end
end})
_G.Mynxx_GetPlotChannel=function(plotName)return _G.MynxxSyncGet(plotName)end
_G.Mynxx_GetAllPlots=function()return _G.MynxxSyncAll() or {} end
_G.Mynxx_GetPlotAnimalList=function(plotName)
local ct=_G._mynxxRawCT(plotName)
local al=ct and ct.AnimalList
return type(al)=="table" and al or nil
end
end

_G.MynxxSyncAll  = _G.MynxxSyncAll
_G.MynxxSyncGet  = _G.MynxxSyncGet
_G.MynxxRawCT    = _G._mynxxRawCT
_G.MynxxGen      = _G._mynxxGen
_G.MynxxAnimShim = _G._mynxxAnimShim

_G.stealthGet    = function(n) return _G.MynxxSyncGet(n) end
_G.SyncInt       = {_cache={},_data=nil}

task.spawn(function()
    for _ = 1, 150 do
        local t = _G.MynxxSyncAll()
        if type(t) == "table" then
            local hit = false
            for _, v in next, t do
                if type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                    hit = true
                    break
                end
            end
        end
        task.wait(0.03)
    end
end)

_G.MynxxGetSyncData = _G.MynxxGetSyncData or function(plot)
    local plotName = type(plot) == "string" and plot or (plot and plot.Name)
    local Pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
    local Sync = Pkgs and Pkgs:FindFirstChild("Synchronizer")
    local okMod, mod = pcall(require, Sync)
    if not okMod or type(mod) ~= "table" then return nil end

    local okT, data = pcall(function() return _G.MynxxRawCT(plotName) end)
    if okT and type(data) == "table" then return data end

    local okC, ch = pcall(function() return _G.MynxxSyncGet(plotName) end)
        local synth = { __channel = ch }
        
        pcall(function() local ct = rawget(ch, "CacheTable"); if type(ct)=="table" then synth.AnimalList = ct.AnimalList; synth.Owner = ct.Owner end end)
    end
end

local Synchronizer, AnimalsData, AnimalsShared, NumberUtils

local function loadModules()
    local ok = pcall(function()
        local Packages = RS:WaitForChild("Packages", 5)
        local Datas = RS:WaitForChild("Datas", 5)
        local Shared = RS:WaitForChild("Shared", 5)
        local Utils = RS:WaitForChild("Utils", 5)
        Synchronizer = require(Packages:WaitForChild("Synchronizer"))
        AnimalsData = require(Datas:WaitForChild("Animals"))
        AnimalsShared = _G.MynxxAnimShim
        NumberUtils = require(Utils:WaitForChild("NumberUtils"))
    end)
    return ok and Synchronizer ~= nil
end

    local function _scanResetRemotes()
        _G.MynxxResetRemoteList = _G.MynxxResetRemoteList or {}
        local roots = { RS, workspace, game:GetService("ReplicatedFirst") }
        for _, root in ipairs(roots) do
            pcall(function()
                for _, d in ipairs(root:GetDescendants()) do
                    if d:IsA("RemoteEvent") and d.Name:sub(1, 3) == "RE/" then
                        if not _G.MynxxResetRemote then _G.MynxxResetRemote = d end
                        _G.MynxxResetRemoteList[d] = true
                    end
                end
            end)
        end
    end
    task.spawn(function()
        for _ = 1, 6 do
            _scanResetRemotes()
            task.wait(1)
        end
    end)
    _G.MynxxScanResetRemotes = _scanResetRemotes
end

local function loadNet() return false end

local function getRemote(method, name)
    
    return _G.__secureGetRemote(method, name)
end
_G.MynxxGetRemote = getRemote

local GRAPPLE_ARG = 0.8
_G.XenFireGrapple2 = function()
pcall(function()

local _nfx=game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net")
local _r=_nfx:GetChildren()[tonumber(_G.XenUseItemIndex) or 6]
if _r and _r:IsA("RemoteEvent") then _r:FireServer(0.8) end
end)
end

local function fireGrapple()
    local char = LP.Character
    if not char:FindFirstChild("Grapple Hook") then
        local bp = LP:FindFirstChild("Backpack")
        local tool = bp and bp:FindFirstChild("Grapple Hook")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if tool and hum then pcall(function() hum:EquipTool(tool) end) end
    end
    if not char:FindFirstChild("Grapple Hook") then return end
    return _G.XenFireGrapple2()
end
_G.MynxxFireGrapple = fireGrapple

local CARPET_SPEED = 280
local INBASE_SPEED = 450
local SKY_CLONE_WAIT = 0.35
local CARPET_NAMES = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }
local function findTool(name)
    local char = LP.Character
    local bp = LP:FindFirstChild("Backpack")
    return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
end
local GRAPPLE_NAMES = { "Grapple Hook", "Grappling Hook", "Grapple", "Hook", "Web Slinger", "Grapple Gun", "GrappleHook" }
local function findGrapple()
    for _, n in ipairs(GRAPPLE_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then return t, n end
    end
end
local function listTools()
    local out, char, bp = {}, LP.Character, LP:FindFirstChild("Backpack")
    if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then out[#out + 1] = t.Name end end end
    if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then out[#out + 1] = t.Name end end end
    return table.concat(out, ", ")
end

local _lastCarpetEquipTry = 0
local function equipCarpet()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    for _, n in ipairs(CARPET_NAMES) do
        local t = char:FindFirstChild(n)
        if t and t:IsA("Tool") then return n end
    end
    local now = os.clock()
    if now - _lastCarpetEquipTry < 0.3 then return nil end
    _lastCarpetEquipTry = now
    for _, n in ipairs(CARPET_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then
            if t.Parent ~= char then pcall(function() hum:EquipTool(t) end) end
        end
    end
end

if _G.MynxxTPDebug == nil then _G.MynxxTPDebug = false end
if _G.MynxxWallHug == nil then _G.MynxxWallHug = false end
local function setCarpetTool(name)
    if type(name) ~= "string" or name == "" then return end
    _G.MynxxCarpetTool = name
    for i = #CARPET_NAMES, 1, -1 do
        if CARPET_NAMES[i] == name then table.remove(CARPET_NAMES, i) end
    end
    table.insert(CARPET_NAMES, 1, name)
end
_G.MynxxSetCarpetTool = setCarpetTool
if type(_G.MynxxCarpetTool) == "string" and _G.MynxxCarpetTool ~= "" then
    setCarpetTool(_G.MynxxCarpetTool)
end
local _carpetEngaging = false
local function carpetEngage(force)
        local c = LP.Character
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then
                    _G.TPEngage = "carpet=" .. tostring(n)
                end
            end
        end
    end
        local _tw = os.clock()
        repeat RunService.Heartbeat:Wait() until (not _carpetEngaging) or os.clock() - _tw > 6
        local c = LP.Character
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then return n end
            end
        end
    end
    _carpetEngaging = true
    local _t0 = os.clock()
    while not findTool("Grapple Hook") and os.clock() - _t0 < 5 do
        RunService.Heartbeat:Wait()
    end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then _carpetEngaging = false; return nil end
    if not char:FindFirstChild("Grapple Hook") then
        local g = findTool("Grapple Hook")
        if g then pcall(function() hum:EquipTool(g) end) end
    end
    task.wait(0.01)
    if LP.Character and LP.Character:FindFirstChild("Grapple Hook") then
        for _ = 1, 3 do
            _G.XenFireGrapple2()
            task.wait(0.05)
        end
    end
    task.wait(0.05)
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h:UnequipTools() end) end
    task.wait(0.05)
    local _tc = os.clock()
        cn = equipCarpet()
        local c = LP.Character
        if cn and c and c:FindFirstChild(cn) then break end
        RunService.Heartbeat:Wait()
    until os.clock() - _tc > 1
    _G.TPEngage = "carpet=" .. tostring(cn)
    _carpetEngaging = false
end

local PET_PRIORITY_TIERS = {
    [1] = { pets = {"Headless Horseman"}, threshold = 0 },
    [2] = { pets = {"Signore Carapace"}, threshold = 0 },
    [3] = { pets = {"John Pork"}, threshold = 0 },
    [4] = { pets = {"Strawberry Elephant"}, threshold = 0 },
    [5] = { pets = {"Arcadragon"}, threshold = 5e9 },
    [6] = { pets = {"Elefanto Frigo"}, threshold = 10e9 },
    [7] = { pets = {"Meowl"}, threshold = 5e9 },
    [8] = { pets = {"Skibidi Toilet"}, threshold = 5e9 },
    [9] = { pets = {"Love Love Bear"}, threshold = 0 },
    [10] = { pets = {"Antonio"}, threshold = 0 },
    [11] = { pets = {"Pancake and Syrup"}, threshold = 0 },
    [12] = { pets = {"Griffin"}, threshold = 0 },
    [13] = { pets = {"Globa Steppa","La Supreme Combinasion","Fishino Clownino","Dragon Gingerini","Tirilikalika Tirilikalako"}, threshold = 5e9 },
    [14] = { pets = {"Ginger Gerat","Pet"}, threshold = 10e9 },
    [15] = { pets = {"Hydra Bunny","Digi Narwhal","Kalika Bros"}, threshold = 3e9 },
    [16] = { pets = {"Hydra Dragon Cannelloni","Dragon Cannelloni","Bunny and Eggy"}, threshold = 3e9 },
    [17] = { pets = {"Ketupat Bros","Rosey and Teddy","La Casa Boo","Fragola la la"}, threshold = 3e9 },
    [18] = { pets = {"Fragola La La La","Cerberus","Guest 666","Los Hackers"}, threshold = 1e9 },
    [19] = { pets = {"Garama and Madunung","Spooky and Pumpky","Reinito Sleighito","Burguro And Fryuro","Cooki and Milki","Fragrama and Chocrama","La Food Combinasion","Los Amigos","Foxini Lanternini","Capitano Moby","Fortunu and Cashuru","Los Sekolahs","Celestial Pegasus"}, threshold = 750e6 },
    [20] = { pets = {"La Secret Combinasion","Sammyni Fattini","Cloverat Clapat","Popcuru and Fizzuru"}, threshold = 1e9 },
}

local TIER_LOOKUP = {}
for tier, data in pairs(PET_PRIORITY_TIERS) do
    for _, name in ipairs(data.pets) do TIER_LOOKUP[name] = tier end
end

local LOCKED_TIERS = { [1]=true, [2]=true, [3]=true, [4]=true }

local DIRECT_THRESHOLDS = {
    [3] = { [4] = 10e9 },
    [4] = {},
    [5] = { [6] = math.huge },
    [6] = { [9] = math.huge, [10] = math.huge, [12] = 15e9 },
    [10] = { [12] = 20e9 },
    [11] = { [12] = 10e9 },
}

local MUTATION_PRIORITY = {
    ["Galaxy"]=1,["Candy"]=1,["Yin Yang"]=1,["YinYang"]=1,["Divine"]=1,
    ["Cursed"]=1,["Lava"]=1,["Radioactive"]=1,["Cyber"]=1,["Rainbow"]=1,["Bloodrot"]=2,
}

local MUTATED_BEATS_GRIFFIN = {
    ["Fishino Clownino"]=true,["Globa Steppa"]=true,
    ["La Supreme Combinasion"]=true,["Tirilikalika Tirilikalako"]=true,
}

local function getMutPrio(m)
    if not m or m == "" or m == "None" then return 0 end
    if MUTATION_PRIORITY[m] then return MUTATION_PRIORITY[m] end
    local n = tostring(m):lower():gsub("[%s%-_]","")
    if n == "bloodrot" then return 2 end
    if n == "yinyang" or n == "galaxy" or n == "candy" or n == "divine"
        or n == "cursed" or n == "lava" or n == "radioactive" or n == "cyber"
        or n == "rainbow" then return 1 end
    return 0
end

local function getCumThreshold(hi, lo)
    if DIRECT_THRESHOLDS[hi] and DIRECT_THRESHOLDS[hi][lo] then return DIRECT_THRESHOLDS[hi][lo] end
    if LOCKED_TIERS[hi] then return math.huge end
    local total = 0
    for t = hi + 1, lo do
        local td = PET_PRIORITY_TIERS[t]
        if td and td.threshold > 0 then total = total + td.threshold end
    end
end

local function _normName(s)
    return tostring(s):lower():gsub("[%s%-_'%.]", "")
end

local _priCacheVer, _priCache = -1, {}
local function _priLookup()
    local ver = _G.MynxxPriVersion or 0
    if _priCacheVer ~= ver then
        table.clear(_priCache)
        local plist = _G.SHARED_PRIORITY_ITEMS
        if type(plist) == "table" then
            
            for i = #plist, 1, -1 do _priCache[_normName(plist[i])] = i end
        end
        _priCacheVer = ver
    end
end
_G.MynxxPriLookup = _priLookup
local function _priIndexOf(name)
    return _priLookup()[_normName(name)]
end

local _mutCacheVer, _mutCache = -1, {}
local function _mutLookup()
    local ver = _G.MynxxMutVersion or 0
    if _mutCacheVer ~= ver then
        table.clear(_mutCache)
        local mlist = _G.SHARED_MUTATION_ITEMS
        if type(mlist) == "table" then
            for i = #mlist, 1, -1 do _mutCache[_normName(mlist[i])] = i end
        end
        _mutCacheVer = ver
    end
end
_G.MynxxMutLookup = _mutLookup

local function _mutRank(mut)
    local lk = _mutLookup()
    local normalRank = lk[_normName("Normal")] or math.huge
    if not mut or mut == "" or mut == "None" then return normalRank end
    return lk[_normName(mut)] or normalRank
end
_G.MynxxMutRank = _mutRank

local function petOutranks(aName, bName, aMut, bMut, aMPS, bMPS)
    local iA = _priIndexOf(aName)
    local iB = _priIndexOf(bName)
    if iA ~= nil and iB ~= nil then return iA < iB end
    if (iA ~= nil) ~= (iB ~= nil) then return iA ~= nil end
    return (aMPS or 0) > (bMPS or 0)
end

local function getPlotChannel(plotName)
    pcall(function() channel = _G.MynxxSyncGet(plotName) end)
end

local function channelGet(channel, key)
    pcall(function() local ct = rawget(channel, "CacheTable"); if type(ct) == "table" then v = ct[key] end end)
end

local function resolveOwner(owner)
    if owner == nil then return nil end
    pcall(function()
        if typeof(owner) == "Instance" then
            plr = owner:IsA("Player") and owner or Players:FindFirstChild(owner.Name)
        elseif type(owner) == "number" then
            plr = Players:GetPlayerByUserId(owner)
        elseif type(owner) == "string" then
            if tonumber(owner) then plr = Players:GetPlayerByUserId(tonumber(owner)) end
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Name:lower() == owner:lower() or p.DisplayName:lower() == owner:lower() then
                        plr = p; break
                    end
                end
            end
        elseif type(owner) == "table" then
            if owner.UserId then plr = Players:GetPlayerByUserId(owner.UserId) end
            if not plr and owner.Name then plr = Players:FindFirstChild(tostring(owner.Name)) end
        end
    end)
end

local function isMyPlot(channel)
    local owner = channelGet(channel, "Owner")
    local plr = resolveOwner(owner)
    if plr then return plr.UserId == LP.UserId end
    if type(owner) == "string" then
        local o = owner:lower()
        return o == LP.Name:lower() or o == LP.DisplayName:lower()
    end
end

local function ownerInGame(channel)
    local owner = channelGet(channel, "Owner")
    if resolveOwner(owner) then return true end
    
    
    
    if typeof(owner) == "Instance" or type(owner) == "number"
       or (type(owner) == "table" and (owner.UserId or owner.Name)) then
    end
end

local function getPetPosition(plot, slot)
    
    
    _G.__PetPosCache = _G.__PetPosCache or {}
    local _cache = _G.__PetPosCache
    local _key = plot.Name .. "|" .. tostring(slot)
    local _hit = _cache[_key]
    local _now = os.clock()
    if _hit and _now < _hit.exp then return _hit.pos end
    local function compute()
        local podiums = plot:FindFirstChild("AnimalPodiums")
        local podium = podiums:FindFirstChild(tostring(slot))
        for _, desc in ipairs(podium:GetDescendants()) do
            if desc:IsA("Model") and desc.Name ~= "Claim" and desc.Name ~= "Base" and desc.Name ~= "Decorations" then
                local hasMesh = false
                for _, c in ipairs(desc:GetDescendants()) do
                    if c:IsA("MeshPart") then hasMesh = true; break end
                end
                    local ok, cf = pcall(function() return desc:GetBoundingBox() end)
                    if ok then return cf.Position end
                end
            end
        end
        local ok, cf = pcall(function() return podium:GetPivot() end)
        if ok then return cf.Position end
        return podium.Position
    end
    local _pos = compute()
    if _pos then _cache[_key] = { pos = _pos, exp = _now + 12 + math.random() * 8 } end
end

_G.XyntrixListMyAnimals = function()
    local out = {}
    pcall(function()
        if not loadModules() then return end
        local Plots = workspace:FindFirstChild("Plots")
        for _, plot in ipairs(Plots:GetChildren()) do
            local channel = getPlotChannel(plot.Name)
            if not channel or not isMyPlot(channel) then continue end
            local animalList = channelGet(channel, "AnimalList")
            if type(animalList) ~= "table" then continue end
            for slot, animalData in pairs(animalList) do
                if type(animalData) ~= "table" then continue end
                local animalName = animalData.Index
                local mutation = animalData.Mutation or "None"
                local genValue = 0
                pcall(function()
                        genValue = AnimalsShared:GetGeneration(animalName, animalData.Mutation, animalData.Traits, nil)
                    end
                end)
                local displayName = animalName
                pcall(function()
                    if AnimalsData and AnimalsData[animalName] then
                        displayName = AnimalsData[animalName].DisplayName or animalName
                    end
                end)
                out[#out + 1] = {
                    name = displayName,
                    index = animalName,
                    mps = genValue,
                    mutation = mutation,
                    slot = tostring(slot),
                    plot = plot.Name,
                }
            end
        end
    end)
end

local function scanAllPets()
    local pets = {}
    if not loadModules() then return pets end

    local Plots = workspace:FindFirstChild("Plots")

    for _, plot in ipairs(Plots:GetChildren()) do
        local channel = getPlotChannel(plot.Name)
        if isMyPlot(channel) then continue end
        if not ownerInGame(channel) then continue end

        local animalList = channelGet(channel, "AnimalList")

        for slot, animalData in pairs(animalList) do
            if type(animalData) ~= "table" then continue end
            local animalName = animalData.Index
            local animalInfo = AnimalsData and AnimalsData[animalName]
            if _MynxxIsFusing(animalData) then continue end

            local mutation = animalData.Mutation or "None"
            local genValue = 0
            pcall(function()
                genValue = AnimalsShared:GetGeneration(animalName, animalData.Mutation, animalData.Traits, nil)
            end)

            local displayName = (animalInfo and animalInfo.DisplayName) or animalName

            local pos = getPetPosition(plot, slot)

                table.insert(pets, {
                    name = displayName,
                    index = animalName,
                    mps = genValue,
                    mutation = mutation,
                    position = pos,
                    plot = plot.Name,
                    slot = tostring(slot),
                })
            end
        end
    end

    local _priLk = _priLookup()
    local anyPri = false
    for _, p in ipairs(pets) do
        p._pri = _priLk[_normName(p.name)] or (p.index and _priLk[_normName(p.index)]) or nil
        p._mut = _mutRank(p.mutation)
        if p._pri ~= nil then anyPri = true end
    end

    local mode = _G.MynxxStealMode
    
    
    
    if mode == "highest" or not anyPri then
        table.sort(pets, function(a, b) return (a.mps or 0) > (b.mps or 0) end)
    end

    
    
    table.sort(pets, function(a, b)
        local ia, ib = a._pri, b._pri
        
        if (ia ~= nil) ~= (ib ~= nil) then return ia ~= nil end
        if ia and ib and ia ~= ib then return ia < ib end
        
        local ma, mb = a._mut or math.huge, b._mut or math.huge
        if ma ~= mb then return ma < mb end
        
        return (a.mps or 0) > (b.mps or 0)
    end)

end

local function scanForTP()
    if _G.MynxxScanTiered then
        local ok, pets = pcall(_G.MynxxScanTiered)
        if ok and type(pets) == "table" then return pets end
    end
    return scanAllPets()
end

local function _petUid(p)
    return tostring(p.plot) .. "_" .. tostring(p.slot)
end
local function _pickPetOnFoot(pets, myPos)
    if not pets or #pets == 0 then return nil end
    if _G.MynxxStealMode == "nearest" and myPos then
        local bestD = math.huge
        for _, p in ipairs(pets) do
            if not p.conveyor and p.position then
                local d = (p.position - myPos).Magnitude
                if d < bestD then bestD = d; best = p end
            end
        end
        for _, p in ipairs(pets) do
            if not p.conveyor then best = p; break end
        end
    end
    return best or pets[1]
end
local function _findTPSyncedPet(pets)
    local uid = _G.MynxxStealTargetUID
    if type(uid) ~= "string" or uid == "" then return nil end
    for _, p in ipairs(pets) do
        if _petUid(p) == uid then return p end
    end
end
local function _clearTPSync()
    _G.MynxxTPSyncActive = false
    _G.MynxxStealTargetUID = nil
    _G.MynxxStealTarget = nil
end
local function _armTPSync(pet)
    _G.MynxxStealTargetUID = _petUid(pet)
    _G.MynxxStealTarget = pet
    _G.MynxxTPSyncActive = true
    local gen = (_G._MynxxTPSyncGen or 0) + 1
    _G._MynxxTPSyncGen = gen
    task.delay(12, function()
        if _G._MynxxTPSyncGen == gen then _clearTPSync() end
    end)
end
_G.MynxxClearTPSync = _clearTPSync

local function _findStealTarget(pets)
    if not _G.MynxxTPSyncActive then return nil end
    return _findTPSyncedPet(pets)
end
local function _publishStealTarget(pet)
    _G.MynxxStealTargetUID = _petUid(pet)
    _G.MynxxStealTarget = pet
end

local UPPER = {
    B = {{coord=Vector3.new(-487.921448,16.850713,-75.768013),facing="NORTH"},{coord=Vector3.new(-332.379730,16.850722,-75.762100),facing="NORTH"},{coord=Vector3.new(-487.134918,16.850713,-18.094154),facing="SOUTH"},{coord=Vector3.new(-316.300171,16.850713,-17.845898),facing="SOUTH"}},
    C = {{coord=Vector3.new(-330.765381,16.850713,31.424425),facing="NORTH"},{coord=Vector3.new(-502.989349,16.850713,31.172430),facing="NORTH"},{coord=Vector3.new(-489.077087,16.850713,89.010147),facing="SOUTH"},{coord=Vector3.new(-330.908936,16.850713,88.930145),facing="SOUTH"}},
    D = {{coord=Vector3.new(-331.264893,16.850713,138.209167),facing="NORTH"},{coord=Vector3.new(-487.935181,16.850713,138.026321),facing="NORTH"},{coord=Vector3.new(-487.774933,16.850713,195.882538),facing="SOUTH"},{coord=Vector3.new(-330.799133,16.850575,196.022354),facing="SOUTH"}},
}
local LOWER = {
    B = {{coord=Vector3.new(-335.725586,-3.048217,-74.984589),facing="NORTH"},{coord=Vector3.new(-503.214233,-3.048217,-75.043137),facing="NORTH"},{coord=Vector3.new(-483.619385,-3.718430,-18.844337),facing="SOUTH"},{coord=Vector3.new(-316.147095,-3.048218,-18.818844),facing="SOUTH"}},
    C = {{coord=Vector3.new(-335.985413,-3.048218,32.051426),facing="NORTH"},{coord=Vector3.new(-503.277008,-3.048217,31.956175),facing="NORTH"},{coord=Vector3.new(-483.749390,-3.048218,88.147003),facing="SOUTH"},{coord=Vector3.new(-315.793823,-3.048217,88.163979),facing="SOUTH"}},
    D = {{coord=Vector3.new(-335.476654,-3.048218,139.001083),facing="NORTH"},{coord=Vector3.new(-503.710083,-3.048218,138.989883),facing="NORTH"},{coord=Vector3.new(-315.654938,-3.048218,195.302444),facing="SOUTH"},{coord=Vector3.new(-483.859253,-3.048218,195.269043),facing="SOUTH"}},
}
local UPPER_Y_THRESHOLD = 7
local TALL_PETS = { ["La Secret Combinasion"]=true, ["La Jolly Grande"]=true }
local TALL_OFFSET = 3

local BASES_LOW = {
    [1] = Vector3.new(-476.52, -2, 220.94090270996094),
    [2] = Vector3.new(-476.52, -2, 113.77315521240234),
    [3] = Vector3.new(-476.52, -2, 6.178487777709961),
    [4] = Vector3.new(-476.52, -2, -101.07275390625),
    [5] = Vector3.new(-342.66, -2, 221.44737243652344),
    [6] = Vector3.new(-342.66, -2, 113.41409301757812),
    [7] = Vector3.new(-342.66, -2, 6.249461650848389),
    [8] = Vector3.new(-342.66, -2, -99.73458862304688),
}
local BASES_HIGH = {
    [1] = Vector3.new(-479.51, 18, 220.94090270996094),
    [2] = Vector3.new(-479.51, 18, 113.77315521240234),
    [3] = Vector3.new(-479.51, 18, 6.178487777709961),
    [4] = Vector3.new(-479.51, 18, -101.07275390625),
    [5] = Vector3.new(-339.48, 18, 221.44737243652344),
    [6] = Vector3.new(-339.48, 18, 113.41409301757812),
    [7] = Vector3.new(-339.48, 18, 6.249461650848389),
    [8] = Vector3.new(-339.48, 18, -99.73458862304688),
}
local FRONT_Y_LOW   = -3.048217
local FRONT_Y_HIGH  = 16.850713
local COLUMN_SPLIT_X = -410
local FRONT_Z_CLAMP  = 18
local SIDE_NEAR_Z    = 45

local function getClosestBaseIdx(pos)
    local closest, dist = 1, math.huge
    for i = 1, 8 do
        local b = BASES_LOW[i]
        local d = (pos.X - b.X)^2 + (pos.Z - b.Z)^2
        if d < dist then dist = d; closest = i end
    end
end

local function buildFrontCandidate(idx, isUpper, playerZ)
    local base = isUpper and BASES_HIGH[idx] or BASES_LOW[idx]
    local frontY = isUpper and FRONT_Y_HIGH or FRONT_Y_LOW
    local frontZ = math.clamp(playerZ - base.Z, -FRONT_Z_CLAMP, FRONT_Z_CLAMP) + base.Z
    local coord = Vector3.new(base.X, frontY, frontZ)
    local faceDir = (idx <= 4) and Vector3.new(-1, 0, 0) or Vector3.new(1, 0, 0)
    return coord, faceDir
end

local function plotSides(coordTable, idx)
    local base = BASES_LOW[idx]
    local isWest = idx <= 4
    local out = {}
    for _, coords in pairs(coordTable) do
        for _, data in ipairs(coords) do
            if ((data.coord.X < COLUMN_SPLIT_X) == isWest)
               and math.abs(data.coord.Z - base.Z) < SIDE_NEAR_Z then
                out[#out + 1] = data
            end
        end
    end
end

local function _floor1LaserSolid(plotName)
    local solid = false
    pcall(function()
        local Plots = workspace:FindFirstChild("Plots")
        local plot = Plots and Plots:FindFirstChild(plotName)
        for _, d in ipairs(plot:GetDescendants()) do
            if d:IsA("BasePart") and (d.Name == "LaserHitbox" or d.Name == "Laser")
                and d.CanCollide and d.Position.Y <= 9 then
                solid = true
                break
            end
        end
    end)
end

local function isPlotUnlocked(plotName)
    local ok, res = pcall(function()
        local channel = getPlotChannel(plotName)
        if channelGet(channel, "BlockEndTimeFirstFloor") ~= nil then return false end
        return not _floor1LaserSolid(plotName)
    end)
    return ok and (res == true)
end

local function findClosest(petPos, coordTable)
    local best, bestKey, bestDist = nil, nil, math.huge
    for skyKey, coords in pairs(coordTable) do
        for _, data in ipairs(coords) do
            local c = data.coord
            local d = math.sqrt((petPos.X - c.X)^2 + (petPos.Z - c.Z)^2)
            if d < bestDist then bestDist = d; best = data; bestKey = skyKey end
        end
    end
    return best, bestKey
end

local _vizGen, clearViz, vizPath
local _vizParts = {}
_vizGen = 0
local _vizFolder, _vizAnchor
local function _vizEnsure()
    if _vizFolder and _vizFolder.Parent then return end
    _vizFolder = Instance.new("Folder")
    _vizFolder.Name = "MynxxPathViz"
    _vizFolder.Parent = workspace
    _vizAnchor = Instance.new("Part")
    _vizAnchor.Name = "Anchor"
    _vizAnchor.Anchored = true; _vizAnchor.CanCollide = false; _vizAnchor.CanQuery = false
    _vizAnchor.CanTouch = false; _vizAnchor.Transparency = 1; _vizAnchor.Size = Vector3.one
    _vizAnchor.CFrame = CFrame.new()
    _vizAnchor.Parent = _vizFolder
end
clearViz = function()
    if _vizFolder then pcall(function() _vizFolder:Destroy() end) end
    _vizFolder, _vizAnchor = nil, nil
    table.clear(_vizParts)
end
local function _ghost(cf, size, color, op)
    _vizEnsure()
    local a = Instance.new("BoxHandleAdornment")
    a.Adornee = _vizAnchor
    a.AlwaysOnTop = true
    a.ZIndex = 0
    pcall(function() a.Shading = Enum.AdornShading.XRayShaded end)
    a.Color3 = color
    a.Transparency = 1 - op
    a.Size = size
    a.CFrame = cf
    a.Parent = _vizAnchor
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()
local function _neon(cf, size, color, ball)
    _vizEnsure()
    local p = Instance.new("Part")
    p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
    p.Material = Enum.Material.Neon; p.Color = color
    if ball then p.Shape = Enum.PartType.Ball end
    p.Size = size; p.CFrame = cf; p.Parent = _vizFolder
end

local function vizLine(a, b, color)
    local d = b - a
    if d.Magnitude < 0.05 then return end
    _neon(CFrame.lookAt((a + b) * 0.5, b), Vector3.new(0.35, 0.35, d.Magnitude), color, false)
end
local function vizDot(pos, color, sz)
    _neon(CFrame.new(pos), Vector3.new(sz, sz, sz), color, true)
end
vizPath = function(fromPos, waypoints)
    
    if _G.MynxxShowPath == false then return end
    if #waypoints == 0 then return end
    
    
    local YELLOW = Color3.fromRGB(255, 220, 70)
    local CYAN   = Color3.fromRGB(90, 255, 235)
    vizDot(fromPos, YELLOW, 2.4)
    local prev, n = fromPos, #waypoints
    for i, wp in ipairs(waypoints) do
        vizLine(prev, wp, CYAN)
        
        
        if i < n and (wp - prev).Magnitude > 12 then
            vizDot(wp, YELLOW, 1.4)
        end
        prev = wp
    end
    vizDot(waypoints[n], YELLOW, 2.6)
end
end

local SPEED = 125
local ARRIVE = 3
local _STRIP_OK = (type(getconnections) == "function")
local function _climbCap()
    local v = math.clamp(tonumber(_G.MynxxClimb) or 200, 100, 250)
    if not _STRIP_OK then v = 55 end
end

local function vZero(hrp)
    if hrp then hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero end
end

local function velMoveThrough(hrp, waypoints, speedOverride, allowJump, quickStart)
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    local _runSpeed = speedOverride or (_G.TPVelocity and math.clamp(_G.TPVelocity, 200, 750)) or CARPET_SPEED
    vizPath(hrp.Position, waypoints)
    local wpIdx = 1
    local done = false
    local function finish()
        done = true
        if hrp and hrp.Parent then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            local _, y = hrp.CFrame:ToEulerAnglesYXZ()
            hrp.CFrame = CFrame.new(waypoints[#waypoints]) * CFrame.Angles(0, y, 0)
        end
        if conn then conn:Disconnect() end
    end
    local lastDist, stall = math.huge, 0

    local _stStart = os.clock()

    local _ = quickStart

    conn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if not hrp or not hrp.Parent or done then
            if conn then conn:Disconnect() end
            return
        end
        if _G.MynxxTPStop then finish() return end
        equipCarpet()
        local target = waypoints[wpIdx]
        local diff = target - hrp.Position
        local mag = diff.Magnitude
        local _spd = _runSpeed
            local el = os.clock() - _stStart
            local cyc = math.floor(el / 0.5)
            if (el - cyc * 0.5) < 0.15 then
                _spd = math.max(60, _runSpeed - (50 + cyc * 10))
            end
        end
        if wpIdx < #waypoints and mag < 26 then
            local nxt = waypoints[wpIdx + 1]
            local b = nxt - target
            if mag > 0.1 and b.Magnitude > 0.1 and diff.Unit:Dot(b.Unit) < 0.9 then
                _spd = math.min(_spd, 240)
            end
        end
        local _arr = math.max(ARRIVE, _spd / 60 * 1.25)
        if mag < _arr then
            wpIdx = wpIdx + 1
            if wpIdx > #waypoints then finish() return end
            lastDist, stall = math.huge, 0
            target = waypoints[wpIdx]
            diff = target - hrp.Position
            mag = diff.Magnitude
        end

        if mag > lastDist - 0.05 then stall = stall + 1 else stall = 0 end
        lastDist = mag
        if stall >= 18 then
            finish() return
        end
        if mag >= 0.1 then
            local dir = diff.Unit
            if (allowJump or diff.Y > 10) and diff.Y > 5 and wpIdx < #waypoints then
                local hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                    local st = hum:GetState()
                    if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() hum.Jump = true end)
                    end
                end
            end
            local _sp = _spd
            local _mc = _climbCap()
            if dir.Y > 0 and dir.Y * _sp > _mc then
                _sp = _mc / dir.Y
            end
            hrp.Velocity = Vector3.new(dir.X * _sp, dir.Y * _sp, dir.Z * _sp)
        end
    end))
    local totalDist = 0
    local prev = hrp.Position
    for _, wp in ipairs(waypoints) do
        totalDist = totalDist + (prev - wp).Magnitude
        prev = wp
    end
    local timeout = totalDist / math.min(SPEED, _runSpeed) + 2
    local elapsed = 0
    while not done and elapsed < timeout do
        task.wait(0.05)
        elapsed = elapsed + 0.05
    end
    finish()
    vZero(hrp)
end

local _OTHER_CLONES = {}
    local _MY_CLONE = tostring(LP.UserId) .. "_Clone"
    local _seen = {}
    local function _isOtherClone(n)
        return type(n) == "string" and n ~= _MY_CLONE and n:match("^%d+_Clone$") ~= nil
    end
    local function _neutralize(inst)
        if not inst or _seen[inst] then return end
        _seen[inst] = true
        _OTHER_CLONES[#_OTHER_CLONES + 1] = inst
        local function declaw(d)
            if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
        end
        for _, d in ipairs(inst:GetDescendants()) do declaw(d) end
        inst.DescendantAdded:Connect(declaw)
        inst.Destroying:Connect(function()
            _seen[inst] = nil
            for i = #_OTHER_CLONES, 1, -1 do
                if _OTHER_CLONES[i] == inst then table.remove(_OTHER_CLONES, i); break end
            end
        end)
    end
    local function _scan(inst)
        if _isOtherClone(inst.Name) then _neutralize(inst) end
    end
    for _, c in ipairs(workspace:GetChildren()) do _scan(c) end
    workspace.ChildAdded:Connect(function(c)
        _scan(c)
        task.defer(function() if c and c.Parent == workspace then _scan(c) end end)
    end)
end

    local _pSeen = setmetatable({}, { __mode = "k" })
    local function _declaw(d)
        if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
    end
    local function _declawChar(char)
        for _, d in ipairs(char:GetDescendants()) do _declaw(d) end
        if not _pSeen[char] then
            _pSeen[char] = true
            char.DescendantAdded:Connect(_declaw)
        end
    end
    local function _hookPlayer(pl)
        if pl == LP then return end
        if pl.Character then _declawChar(pl.Character) end
        pl.CharacterAdded:Connect(function(c) task.wait(0.15); _declawChar(c) end)
    end
    for _, pl in ipairs(Players:GetPlayers()) do _hookPlayer(pl) end
    Players.PlayerAdded:Connect(_hookPlayer)
    
    task.spawn(function()
            task.wait(5)
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= LP and pl.Character then
                    for _, d in ipairs(pl.Character:GetDescendants()) do _declaw(d) end
                end
            end
        end
    end)
end

local computeRoute, _len
local _DIRS = { Vector3.new(1,0,0), Vector3.new(-1,0,0), Vector3.new(0,0,1), Vector3.new(0,0,-1) }
local _STRUCT = { ["structure base home"] = true, ["Wall"] = true, ["Floor"] = true, ["Roof"] = true }
local _SKIP_NAME = { ["DeliveryHitbox"]=true, ["StealHitbox"]=true, ["LaserHitbox"]=true,
    ["AnimalTarget"]=true, ["Multiplier"]=true, ["Laser"]=true, ["Hitbox"]=true,
    ["Spawn"]=true, ["MainRoot"]=true, ["SecondFloor"]=true, ["ThirdFloor"]=true, ["Slope"]=true }
local function _blocks(inst)
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    if _STRUCT[inst.Name] then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 150 then return true end
end
local function _blocksWide(inst)
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    if _STRUCT[inst.Name] then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 30 then return true end
end
local function _block(origin, target, blockFn)
    blockFn = blockFn or _blocks
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    local o = origin
    for _ = 1, 16 do
        rp.FilterDescendantsInstances = skip
        local d = target - o
        if d.Magnitude < 0.05 then return nil end
        local res = workspace:Raycast(o, d, rp)
        if blockFn(res.Instance) then return res end
        skip[#skip + 1] = res.Instance
        o = res.Position + d.Unit * 0.3
    end
end
local function _clear(a, b) return _block(a, b) == nil end
local function _clearDist(origin, dir, maxD)
    local res = _block(origin, origin + dir.Unit * maxD)
    return (res.Position - origin).Magnitude
end
function _len(pts)
    local s, prev = 0, pts[1]
    for k = 2, #pts do s = s + (pts[k] - prev).Magnitude; prev = pts[k] end
end
local function _pull(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    while i < #pts do
        local j = #pts
        while j > i + 1 and not _clear(out[#out], pts[j]) do j = j - 1 end
        out[#out + 1] = pts[j]
        i = j
    end
end
local function _stages(toPos)
    local st = {}
    for _, dr in ipairs(_DIRS) do
        local cd = _clearDist(toPos, dr, 46)
        if cd >= 12 then st[#st + 1] = toPos + dr * math.min(cd - 5, 38) end
    end
end
local function _routeClear(pts)
    for i = 1, #pts - 1 do
        if not _clear(pts[i], pts[i + 1]) then return false end
    end
end
local function _peakY(pts)
    local m = -math.huge
    for _, p in ipairs(pts) do if p.Y > m then m = p.Y end end
end
local function _starts(fromPos)
    local pts = { fromPos }
    if _block(fromPos, fromPos + Vector3.new(0, 40, 0)) then
        for _, dr in ipairs(_DIRS) do
            local cd = _clearDist(fromPos, dr, 40)
            if cd >= 12 then pts[#pts + 1] = fromPos + dr * math.min(cd - 5, 34) end
        end
    end
end

local function _candidates(sp, stage, toPos)
    local list = {}
    local function add(mid)
        if mid then list[#list + 1] = { sp, mid, stage, toPos }
        else list[#list + 1] = { sp, stage, toPos } end
    end
    add(nil)
    add(Vector3.new(stage.X, sp.Y, stage.Z))
    add(Vector3.new(sp.X, stage.Y, sp.Z))
    local dir = Vector3.new(stage.X - sp.X, 0, stage.Z - sp.Z)
    if dir.Magnitude > 0.1 then
        dir = dir.Unit
        local perp = Vector3.new(-dir.Z, 0, dir.X)
        for _, off in ipairs({ 20, -20, 40, -40 }) do
            add(sp + perp * off)
        end
    end
end

local PathfindingService = game:GetService("PathfindingService")
local _CLEARANCE = 16
local function _clearWideRay(a, b)
    return _block(a, b, _blocksWide) == nil
end

local _SWEEP_R = 4
local _ENDPOINT_SLACK = 6
local _canSphere = nil
local function _sweepBlockFn(inst)
    if _G.MynxxStrictSweep == false then return _blocks(inst) end
    return _blocksWide(inst)
end
local function _sweepDir(a, b)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    local o = a
    for _ = 1, 24 do
        rp.FilterDescendantsInstances = skip
        local d = b - o
        if d.Magnitude < 0.05 then return false end
        local ok = pcall(function() res = workspace:Spherecast(o, _SWEEP_R, d, rp) end)
        if not ok then _canSphere = false; return nil end
        if _sweepBlockFn(res.Instance) then return true end
        skip[#skip + 1] = res.Instance
        local adv = (res.Distance or 0) - 0.05
        if adv > 0 then o = o + d.Unit * math.min(adv, d.Magnitude) end
    end
end
local function _sweepBlocked(a, b, slackA, slackB)
    if _canSphere == nil then
        _canSphere = pcall(function()
            workspace:Spherecast(Vector3.new(0, 10000, 0), 1, Vector3.new(0, -1, 0), RaycastParams.new())
        end)
    end
    local d = b - a
    local len = d.Magnitude
    if len < 0.1 then return false end
    local u = d / len
    local a2 = a + u * math.min(slackA or _ENDPOINT_SLACK, len * 0.4)
    local b2 = b - u * math.min(slackB or _ENDPOINT_SLACK, len * 0.4)
    local fwd = _sweepDir(a2, b2)
    if fwd == nil then return nil end
    local rev = _sweepDir(b2, a2)
    if rev == nil then return nil end
end

local function _clearWide(a, b, slackA, slackB)
    if not _clear(a, b) then return false end
    local sw = _sweepBlocked(a, b, slackA, slackB)
    if sw ~= nil then return not sw end
    local d = Vector3.new(b.X - a.X, 0, b.Z - a.Z)
    if d.Magnitude < 0.1 then
        local ox = Vector3.new(_CLEARANCE, 0, 0)
        local oz = Vector3.new(0, 0, _CLEARANCE)
        return _clearWideRay(a + ox, b + ox) and _clearWideRay(a - ox, b - ox)
            and _clearWideRay(a + oz, b + oz) and _clearWideRay(a - oz, b - oz)
    end
    local perp = Vector3.new(-d.Z, 0, d.X).Unit * _CLEARANCE
    local up = Vector3.new(0, _CLEARANCE, 0)
    return _clearWideRay(a + perp, b + perp)
        and _clearWideRay(a - perp, b - perp)
        and _clearWideRay(a + up, b + up)
        and _clearWideRay(a - up, b - up)
end

local function _pullWide(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    local n = #pts
    while i < n do
        local j = n
        while j > i + 1 do
            local a, b = out[#out], pts[j]
            local sA = (i == 1) and _ENDPOINT_SLACK or 0
            local sB = (j == n) and _ENDPOINT_SLACK or 0
            if _clearWide(a, b, sA, sB) then break end
            j = j - 1
        end
        out[#out + 1] = pts[j]
        i = j
    end
end

local function _pushOffWalls(pts)
    if #pts <= 2 then return pts end
    local MARGIN = 8
    local MAX_PUSH = 12
    local out = { pts[1] }
    for i = 2, #pts - 1 do
        local p = pts[i]
        local shift = Vector3.zero
        for _, dr in ipairs(_DIRS) do
            local res = _block(p, p + dr * MARGIN, _blocks)
                local dist = (res.Position - p).Magnitude
                if dist < MARGIN then
                    shift = shift - dr * (MARGIN - dist)
                end
            end
        end
            local resUp = _block(p, p + Vector3.new(0, MARGIN, 0), _blocks)
                local dist = (resUp.Position - p).Magnitude
                if dist < 4 then shift = shift + Vector3.new(0, -(4 - dist), 0) end
            end
        end
        if shift.Magnitude > 0.1 then
            if shift.Magnitude > MAX_PUSH then shift = shift.Unit * MAX_PUSH end
            local moved = p + shift
            if _clear(out[#out], moved) then
                out[#out + 1] = moved
                out[#out + 1] = p
            end
            out[#out + 1] = p
        end
    end
    out[#out + 1] = pts[#pts]
end

local _vxFloor, _vxSqrt = math.floor, math.sqrt
local _vxMin, _vxMax = math.min, math.max
local function _vxAbs(n) return n < 0 and -n or n end

local _vxOverlap = OverlapParams.new()
_vxOverlap.FilterType = Enum.RaycastFilterType.Exclude
_vxOverlap.RespectCanCollide = true

local _vxCast = RaycastParams.new()
_vxCast.FilterType = Enum.RaycastFilterType.Exclude
_vxCast.RespectCanCollide = true
_vxCast.IgnoreWater = true

local _vxDimX, _vxDimY, _vxDimZ = 0, 0, 0
local _vxSz, _vxInflate = 4, 2.5
local _vxSolid = {}
local _vxHeight = 5

local function _vxWorld(sz, x, y, z)
    local h = sz * 0.5
    return Vector3.new(_vxOrigin.X + x * sz + h, _vxOrigin.Y + y * sz + h, _vxOrigin.Z + z * sz + h)
end
local function _vxKey(x, y, z) return x + y * 1024 + z * 1048576 end

local function _vxIsSolid(x, y, z)
    if x < 0 or y < 0 or z < 0 or x >= _vxDimX or y >= _vxDimY or z >= _vxDimZ then return true end
    local k = _vxKey(x, y, z)
    local c = _vxSolid[k]
    if c ~= nil then return c end
    local h = _vxSz * 0.5
    local cx = _vxOrigin.X + x * _vxSz + h
    local cy = _vxOrigin.Y + y * _vxSz + h
    local cz = _vxOrigin.Z + z * _vxSz + h
    local sxz = _vxSz + _vxInflate
    local vy = _vxHeight > _vxSz and _vxHeight or _vxSz
    local vcy = cy - h + vy * 0.5
    local parts = workspace:GetPartBoundsInBox(CFrame.new(cx, vcy, cz), Vector3.new(sxz, vy, sxz), _vxOverlap)
    local solid = #parts > 0
    _vxSolid[k] = solid
end

local function _vxSegClear(from, to, radius, height, sample)
    local dir = to - from
    local mag = dir.Magnitude
    if mag < 0.05 then return true end
    if workspace:Raycast(from, dir, _vxCast) then return false end
    local r = radius > 1 and radius or 1
    if workspace:Blockcast(CFrame.new(from), Vector3.new(r * 2, height, r * 2), dir, _vxCast) ~= nil then return false end
    local n = _vxFloor(mag)
    if sample ~= false and n >= 2 then
        local step = dir / n
        local torso = Vector3.new(r * 2, 3, r * 2)
        for i = 1, n - 1 do
            local pt = from + step * i
            if #workspace:GetPartBoundsInBox(CFrame.new(pt), torso, _vxOverlap) > 0 then return false end
        end
    end
end

local _vxNeigh = {}
    for dx = -1, 1 do
        for dy = -1, 1 do
            for dz = -1, 1 do
                if dx ~= 0 or dy ~= 0 or dz ~= 0 then
                    local nz = (dx ~= 0 and 1 or 0) + (dy ~= 0 and 1 or 0) + (dz ~= 0 and 1 or 0)
                    local kd = dx + dy * 1024 + dz * 1048576
                    _vxNeigh[#_vxNeigh + 1] = { dx, dy, dz, _vxSqrt(dx * dx + dy * dy + dz * dz), nz, kd }
                end
            end
        end
    end
end

local function _vxNoCorner(cx, cy, cz, off)
    if off[5] < 2 then return true end
    if off[1] ~= 0 and _vxIsSolid(cx + off[1], cy, cz) then return false end
    if off[2] ~= 0 and _vxIsSolid(cx, cy + off[2], cz) then return false end
    if off[3] ~= 0 and _vxIsSolid(cx, cy, cz + off[3]) then return false end
end

local function _vxSnapGoal(goalPos, x, y, z)
    if not _vxIsSolid(x, y, z) then return x, y, z end
    for r = 1, 16 do
        for dx = -r, r do
            for dy = -r, r do
                for dz = -r, r do
                    if _vxMax(_vxAbs(dx), _vxAbs(dy), _vxAbs(dz)) == r then
                        local nx, ny, nz = x + dx, y + dy, z + dz
                        if not _vxIsSolid(nx, ny, nz) and (_vxWorld(_vxSz, nx, ny, nz) - goalPos).Magnitude <= 8 then
                            return nx, ny, nz
                        end
                    end
                end
            end
        end
    end
    return x, y, z
end
local function _vxSnapStart(pos, x, y, z)
    if not _vxIsSolid(x, y, z) then return x, y, z end
    for r = 1, 16 do
        for dx = -r, r do
            for dy = -r, r do
                for dz = -r, r do
                    if _vxMax(_vxAbs(dx), _vxAbs(dy), _vxAbs(dz)) == r then
                        local nx, ny, nz = x + dx, y + dy, z + dz
                        if not _vxIsSolid(nx, ny, nz) and not workspace:Raycast(pos, _vxWorld(_vxSz, nx, ny, nz) - pos, _vxCast) then
                            return nx, ny, nz
                        end
                    end
                end
            end
        end
    end
    return x, y, z
end

local function _vxPush(h, f, key)
    local i = #h + 1
    h[i] = { f, key }
    while i > 1 do
        local p = _vxFloor(i * 0.5)
        if h[p][1] <= h[i][1] then break end
        h[p], h[i] = h[i], h[p]
        i = p
    end
end
local function _vxPop(h)
    local n = #h
    if n == 0 then return nil end
    local top = h[1]
    h[1] = h[n]
    h[n] = nil
    n -= 1
    local i = 1
        local l, r, s = i + i, i + i + 1, i
        if l <= n and h[l][1] < h[s][1] then s = l end
        if r <= n and h[r][1] < h[s][1] then s = r end
        if s == i then break end
        h[i], h[s] = h[s], h[i]
        i = s
    end
    return top[2]
end

local _vxHeurW = 2
local function _vxAStar(sz, startCell, goalCell, startPos, goalPos)
    local sx, sy, sz2 = _vxSnapStart(startPos, startCell.x, startCell.y, startCell.z)
    local gx, gy, gz = _vxSnapGoal(goalPos, goalCell.x, goalCell.y, goalCell.z)
    local goalKey = _vxKey(gx, gy, gz)
    local startKey = _vxKey(sx, sy, sz2)

    local nodes = { [startKey] = { x = sx, y = sy, z = sz2, g = 0, parent = nil } }
    local closed = {}
    local heap = {}
    _vxPush(heap, 0, startKey)

    local function Heur(x, y, z)
        local ax, ay, az = x - gx, y - gy, z - gz
        return _vxSqrt(ax * ax + ay * ay + az * az)
    end

    local pops = 0
    while #heap > 0 do
        local curKey = _vxPop(heap)
        if closed[curKey] then continue end
        closed[curKey] = true
        pops += 1
        if pops > 300000 then break end

        local cur = nodes[curKey]
        if curKey == goalKey then
            local path = {}
            local n = cur
                path[#path + 1] = _vxWorld(sz, n.x, n.y, n.z)
                n = n.parent and nodes[n.parent]
            end
            local rev = {}
            for i = #path, 1, -1 do rev[#rev + 1] = path[i] end
        end

        local cx, cy, cz = cur.x, cur.y, cur.z
        local cg = cur.g
        for _, off in _vxNeigh do
            local nk = curKey + off[6]
            if closed[nk] then continue end
            local nx, ny, nz = cx + off[1], cy + off[2], cz + off[3]
            if _vxIsSolid(nx, ny, nz) then continue end
            if not _vxNoCorner(cx, cy, cz, off) then continue end
            local tg = cg + off[4]
            local ex = nodes[nk]
            if not ex or tg < ex.g then
                    ex.g, ex.parent, ex.x, ex.y, ex.z = tg, curKey, nx, ny, nz
                    nodes[nk] = { x = nx, y = ny, z = nz, g = tg, parent = curKey }
                end
                _vxPush(heap, tg + _vxHeurW * Heur(nx, ny, nz), nk)
            end
        end
    end
end

local function _vxSimplify(path, radius, height)
    if not path or #path < 3 then return path end
    local out = { path[1] }
    local anchor = 1
    local i = 2
    while i <= #path do
        if not _vxSegClear(path[anchor], path[i + 1] or path[i], radius, height, false) then
            out[#out + 1] = path[i]
            anchor = i
        end
        i += 1
    end
    out[#out + 1] = path[#path]
end

voxelRoute = function(fromPos, toPos)
    local char = LP.Character
    local _flt = char and { char } or {}
    for _, cl in ipairs(_OTHER_CLONES) do _flt[#_flt + 1] = cl end
    _vxOverlap.FilterDescendantsInstances = _flt
    _vxCast.FilterDescendantsInstances = _flt

    local sz      = tonumber(_G.MynxxPathCell)   or 4
    local inflate = tonumber(_G.MynxxPathRadius) or 2.5
    local height  = tonumber(_G.MynxxPathHeight) or 5
    local pad     = tonumber(_G.MynxxPathPad)    or 40

    _vxSz, _vxInflate, _vxHeight = sz, inflate, height
    table.clear(_vxSolid)

    local mn = Vector3.new(_vxMin(fromPos.X, toPos.X), _vxMin(fromPos.Y, toPos.Y), _vxMin(fromPos.Z, toPos.Z)) - Vector3.new(pad, pad, pad)
    local mx = Vector3.new(_vxMax(fromPos.X, toPos.X), _vxMax(fromPos.Y, toPos.Y), _vxMax(fromPos.Z, toPos.Z)) + Vector3.new(pad, pad, pad)
    _vxOrigin = mn
    local size = mx - mn
    _vxDimX = _vxFloor(size.X / sz) + 1
    _vxDimY = _vxFloor(size.Y / sz) + 1
    _vxDimZ = _vxFloor(size.Z / sz) + 1
    if _vxDimX * _vxDimY * _vxDimZ > 200000 then return nil end

    local startCell = {
        x = _vxFloor((fromPos.X - _vxOrigin.X) / sz),
        y = _vxFloor((fromPos.Y - _vxOrigin.Y) / sz),
        z = _vxFloor((fromPos.Z - _vxOrigin.Z) / sz),
    }
    local goalCell = {
        x = _vxFloor((toPos.X - _vxOrigin.X) / sz),
        y = _vxFloor((toPos.Y - _vxOrigin.Y) / sz),
        z = _vxFloor((toPos.Z - _vxOrigin.Z) / sz),
    }

    local path = _vxAStar(sz, startCell, goalCell, fromPos, toPos)
    path = _vxSimplify(path, inflate, height)
    if not path or #path == 0 then return nil end

    local route = {}
    for idx = 2, #path do route[#route + 1] = path[idx] end
    if #route == 0 or (route[#route] - toPos).Magnitude > 0.5 then
        route[#route + 1] = toPos
    end
end

end

_G.MynxxVoxelRoute = voxelRoute

local _MAP_CENTER = { minX = -458, maxX = -362, minZ = -40, maxZ = 185 }
local _BYPASS_Z_NORTH, _BYPASS_Z_SOUTH = 205, -95
local _BYPASS_X_WEST,  _BYPASS_X_EAST  = -525, -295

local function _inCenterZone(x, z)
    return x >= _MAP_CENTER.minX and x <= _MAP_CENTER.maxX
       and z >= _MAP_CENTER.minZ and z <= _MAP_CENTER.maxZ
end

local function _segmentCrossesCenter(a, b)
    if _inCenterZone(a.X, a.Z) or _inCenterZone(b.X, b.Z) then return true end
    for i = 1, 10 do
        local t = i / 11
        if _inCenterZone(a.X + (b.X - a.X) * t, a.Z + (b.Z - a.Z) * t) then return true end
    end
end

local function _findBestCenterDetour(fromPos, toPos, y)
    local candidates = {
        { Vector3.new(fromPos.X, y, _BYPASS_Z_NORTH), Vector3.new(toPos.X, y, _BYPASS_Z_NORTH) },
        { Vector3.new(fromPos.X, y, _BYPASS_Z_SOUTH), Vector3.new(toPos.X, y, _BYPASS_Z_SOUTH) },
        { Vector3.new(_BYPASS_X_WEST, y, fromPos.Z), Vector3.new(_BYPASS_X_WEST, y, toPos.Z) },
        { Vector3.new(_BYPASS_X_EAST, y, fromPos.Z), Vector3.new(_BYPASS_X_EAST, y, toPos.Z) },
    }
    local best, bestLen = nil, math.huge
    for _, pair in ipairs(candidates) do
        local w1, w2 = pair[1], pair[2]
        if _clearWide(fromPos, w1) and _clearWide(w1, w2) and _clearWide(w2, toPos) then
            local len = (fromPos - w1).Magnitude + (w1 - w2).Magnitude + (w2 - toPos).Magnitude
            if len < bestLen then bestLen = len; best = { w1, w2 } end
        end
    end
end
_G.MynxxSegmentCrossesCenter = _segmentCrossesCenter
_G.MynxxFindCenterDetour     = _findBestCenterDetour

local function _rowBoxX() return tonumber(_G.MynxxRowBoxX) or 26 end
local function _rowBoxZ() return tonumber(_G.MynxxRowBoxZ) or 30 end
local function _rowLane() return tonumber(_G.MynxxRowLane) or 30 end

local function _nearestBase(p)
    local bi, bd = nil, math.huge
    for i = 1, 8 do
        local b = BASES_LOW[i]
        local d = (p.X - b.X) ^ 2 + (p.Z - b.Z) ^ 2
        if d < bd then bd = d; bi = i end
    end
    if bd > 70 * 70 then return nil end
end

local function _segmentHitsOtherBase(a, b, ignA, ignB)
    local hx, hz = _rowBoxX(), _rowBoxZ()
    for i = 0, 24 do
        local t = i / 24
        local px = a.X + (b.X - a.X) * t
        local pz = a.Z + (b.Z - a.Z) * t
        for k = 1, 8 do
            if k ~= ignA and k ~= ignB then
                local bs = BASES_LOW[k]
                if math.abs(px - bs.X) <= hx and math.abs(pz - bs.Z) <= hz then
                end
            end
        end
    end
end

local function _findRowDetour(fromPos, toPos, y)
    local iFrom, iTo = _nearestBase(fromPos), _nearestBase(toPos)
    if not _segmentHitsOtherBase(fromPos, toPos, iFrom, iTo) then return nil end

    
    local colX = BASES_LOW[iTo or 1].X
    local off  = _rowLane()
    local lanes = {}
    
    
    local outer = (colX < COLUMN_SPLIT_X) and (colX - off) or (colX + off)
    lanes[#lanes + 1] = outer
    
    
    local inner = (colX < COLUMN_SPLIT_X) and (colX + off) or (colX - off)
    if not _inCenterZone(inner, (fromPos.Z + toPos.Z) * 0.5) then
        lanes[#lanes + 1] = inner
    end

    local best, bestLen = nil, math.huge
    for _, laneX in ipairs(lanes) do
        local w1 = Vector3.new(laneX, y, fromPos.Z)
        local w2 = Vector3.new(laneX, y, toPos.Z)
        if _clearWide(fromPos, w1) and _clearWide(w1, w2) and _clearWide(w2, toPos)
           and not _segmentHitsOtherBase(w1, w2, iFrom, iTo) then
            local len = (fromPos - w1).Magnitude + (w1 - w2).Magnitude + (w2 - toPos).Magnitude
            if len < bestLen then bestLen = len; best = { w1, w2 } end
        end
    end
end
_G.MynxxFindRowDetour = _findRowDetour

local function _centerSpanT(a, b)
    local t0, t1 = nil, nil
    for i = 0, 40 do
        local t = i / 40
        local x = a.X + (b.X - a.X) * t
        local z = a.Z + (b.Z - a.Z) * t
        if _inCenterZone(x, z) then
            if not t0 then t0 = t end
            t1 = t
        end
    end
    return t0, t1
end

local function _hitSpanT(a, b)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    rp.FilterDescendantsInstances = skip
    local t0, t1 = nil, nil
    local n, edge = 28, 0.1
    for i = 0, n - 1 do
        local tA, tB = i / n, (i + 1) / n
        if tB > edge and tA < (1 - edge) then
            local pA, pB = a:Lerp(b, tA), a:Lerp(b, tB)
            local d = pB - pA
            if d.Magnitude > 0.05 then
                local hit = workspace:Raycast(pA, d, rp)
                if hit and _blocksWide(hit.Instance) then
                    if not t0 then t0 = math.max(tA, edge) end
                    t1 = math.min(tB, 1 - edge)
                end
            end
        end
    end
    return t0, t1
end

local function _localHopOver(fromPos, toPos, tBlock0, tBlock1)
    local lift = tonumber(_G.MynxxCenterFly) or 10
    local pad = tonumber(_G.MynxxHopPad) or 0.12
    local t0 = math.clamp(tBlock0 or 0.35, 0.08, 0.85)
    local t1 = math.clamp(tBlock1 or 0.65, t0 + 0.04, 0.92)
    local tRise0 = math.max(0.04, t0 - pad)
    local tRise1, tFall0, tFall1 = t0, t1, math.min(0.94, t1 + pad)
    local function at(t, yAdd)
        local p = fromPos:Lerp(toPos, t)
        local gy = fromPos.Y + (toPos.Y - fromPos.Y) * t
        return Vector3.new(p.X, gy + (yAdd or 0), p.Z)
    end
    local route = { fromPos }
    local function push(p)
        if (route[#route] - p).Magnitude > 0.6 then route[#route + 1] = p end
    end
    push(at(tRise0, 0))
    push(at((tRise0 + tRise1) * 0.5, lift * 0.5))
    push(at(tRise1, lift))
    push(at((tRise1 + tFall0) * 0.5, lift))
    push(at(tFall0, lift))
    push(at((tFall0 + tFall1) * 0.5, lift * 0.5))
    push(at(tFall1, 0))
    push(toPos)
end

function computeRoute(fromPos, toPos, facingDir, maxLift, preferCrest)
    local _ = maxLift

    
    
    
    if _clearWide(fromPos, toPos) then return { toPos } end

    
    if _segmentCrossesCenter(fromPos, toPos) then
        local c0, c1 = _centerSpanT(fromPos, toPos)
        local h0, h1 = _hitSpanT(fromPos, toPos)
        if c0 and h0 and h1 and h1 >= c0 and h0 <= (c1 or 1) then
            local t0 = math.max(h0, c0)
            local t1 = math.min(h1, c1 or h1)
            if (t1 - t0) > 0.02 then
                return _localHopOver(fromPos, toPos, t0, t1)
            end
        end
    end

    
    local centerPatch = nil
    local rowPatch = _findRowDetour(fromPos, toPos, fromPos.Y)
    if rowPatch and #rowPatch > 0 then
        fromPos = rowPatch[#rowPatch]
    end

    local function _withPatch(route)
        if (not centerPatch or #centerPatch == 0)
           and (not rowPatch or #rowPatch == 0) then return route end
        local merged = {}
        if centerPatch then for _, p in ipairs(centerPatch) do merged[#merged + 1] = p end end
        if rowPatch    then for _, p in ipairs(rowPatch)    do merged[#merged + 1] = p end end
        for _, p in ipairs(route) do merged[#merged + 1] = p end
    end

    if _clearWide(fromPos, toPos) then return _withPatch({ toPos }) end

        local cruiseY = math.max(fromPos.Y, toPos.Y, 26) + 12
        local up   = Vector3.new(fromPos.X, cruiseY, fromPos.Z)
        local over = Vector3.new(toPos.X,   cruiseY, toPos.Z)
        local crest = { fromPos, up, over, toPos }
        local ok = true
        for i = 1, #crest - 1 do
            local a, b = crest[i], crest[i + 1]
            if (a - b).Magnitude > 0.5 then
                local sA = (i == 1) and _ENDPOINT_SLACK or 0
                local sB = (i == #crest - 1) and _ENDPOINT_SLACK or 0
                if not _clearWide(a, b, sA, sB) then ok = false; break end
            end
        end
        if ok then return _withPatch(crest) end
    end

        local vr = voxelRoute(fromPos, toPos)
        if vr and #vr > 0 then return _withPatch(vr) end
    end

    local entry = facingDir and (toPos - facingDir * 14) or toPos

    local best, bestLen = nil, math.huge
    local function consider(pts)
        if not pts or #pts < 2 then return end
        local n = #pts
        for i = 1, n - 1 do
            local a, b = pts[i], pts[i + 1]
            if (a - b).Magnitude > 0.5 then
                local sA = (i == 1) and _ENDPOINT_SLACK or 0
                local sB = (i == n - 1) and _ENDPOINT_SLACK or 0
                if not _clearWide(a, b, sA, sB) then return end
            end
        end
        local pulled = _pullWide(pts)
        local L = _len(pulled)
        if L < bestLen then best, bestLen = pulled, L end
    end

        local dirF = Vector3.new(entry.X - fromPos.X, 0, entry.Z - fromPos.Z)
        if dirF.Magnitude > 0.1 then
            dirF = dirF.Unit
            local perp = Vector3.new(-dirF.Z, 0, dirF.X)
            local midBase = (fromPos + entry) * 0.5
            for _, off in ipairs({ 14, -14, 24, -24, 38, -38, 56, -56, 76, -76 }) do
                consider({ fromPos, midBase + perp * off, entry })
                consider({ fromPos, fromPos + perp * off, entry + perp * off, entry })
            end
        end
    end

        local groundTo = Vector3.new(entry.X, fromPos.Y, entry.Z)
        local path = PathfindingService:CreatePath({
            AgentRadius = 16, AgentHeight = 5, AgentCanJump = true, AgentJumpHeight = 10, AgentMaxSlope = 89,
        })
        local FLOAT = 5
        local nav = { fromPos }
        local ok = pcall(function()
            path:ComputeAsync(Vector3.new(fromPos.X, fromPos.Y, fromPos.Z), groundTo)
        end)
        if ok and path.Status == Enum.PathStatus.Success then
            local last = fromPos
            for _, wp in ipairs(path:GetWaypoints()) do
                if (wp.Position - last).Magnitude >= 8 then
                    nav[#nav + 1] = wp.Position + Vector3.new(0, FLOAT, 0)
                    last = wp.Position
                end
            end
        end
        nav[#nav + 1] = entry + Vector3.new(0, FLOAT, 0)
        nav = _pushOffWalls(nav)
        navRaw = nav
        consider(nav)
    end

    local route = best
    if not route and _clear(fromPos, toPos) then route = { toPos } end
    if not route and navRaw then route = _pullWide(navRaw) end
    if not route then route = { toPos } end
    if (route[#route] - toPos).Magnitude > 0.5 then
        route[#route + 1] = toPos
    end
    return _withPatch(route)
end
end

local function equipTool(name)
    local char = LP.Character
    if not char or char:FindFirstChild(name) then return char ~= nil end
    local bp = LP:FindFirstChild("Backpack")
    local tool = bp:FindFirstChild(name)
    if tool and tool:IsA("Tool") then tool.Parent = char; return true end
end

local function unequipAll()
    local char, bp = LP.Character, LP.Backpack
    for _, t in pairs(char:GetChildren()) do
        if t:IsA("Tool") then t.Parent = bp end
    end
end

local function doClone()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    local cloner = (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild("Quantum Cloner"))
                or char:FindFirstChild("Quantum Cloner")

    if cloner.Parent ~= char then
        pcall(function() hum:EquipTool(cloner) end)
        task.wait()
    end

    pcall(function() hum:UnequipTools() end)
    task.wait()
    if cloner.Parent ~= char then
        pcall(function() hum:EquipTool(cloner) end)
        task.wait()
    end

    local pg = LP:FindFirstChild("PlayerGui")
    local tf = pg and pg:FindFirstChild("ToolsFrames")
    local qc = tf and tf:FindFirstChild("QuantumCloner")
    local tb = qc and qc:FindFirstChild("TeleportToClone")

    _G.isCloning = true
    pcall(function() cloner:Activate() end)
    task.wait(0.05)

    local fired = false
    if tb and type(firesignal) == "function" then
        pcall(function() tb.Visible = true end)
        pcall(function() firesignal(tb.MouseButton1Click) end)
        pcall(function() firesignal(tb.MouseButton1Up) end)
        pcall(function() firesignal(tb.Activated) end)
        fired = true
        
        local useItem = getRemote("RemoteEvent", "UseItem")
        local onTel   = getRemote("RemoteEvent", "QuantumCloner/OnTeleport")
            pcall(function() useItem:FireServer() end)
            task.wait(0.05)
            pcall(function() onTel:FireServer() end)
            fired = true
        end
    end

    task.delay(0.55, function() _G.isCloning = false end)
end

local _TweenTS = game:GetService("TweenService")
local function mynxxTween(rootPart, hum, targetPos, lookDir)
    if not rootPart or not rootPart.Parent then return end
    local STEP = 20
    local speed = (_G.TPTravelSpeed or 100)
    local hasLook = lookDir ~= nil and lookDir.Magnitude > 0.001
    local prevAnchored = rootPart.Anchored
    rootPart.AssemblyLinearVelocity = Vector3.zero
    rootPart.AssemblyAngularVelocity = Vector3.zero
    pcall(function() rootPart.Anchored = true end)
    local deadline = os.clock() + 12
    while rootPart and rootPart.Parent and os.clock() < deadline do
        local pos = rootPart.Position
        local toTarget = targetPos - pos
        local d = toTarget.Magnitude
        if d < 0.5 then break end
        local stepDist = math.min(STEP, d)
        local stepGoal = pos + toTarget.Unit * stepDist
            stepCF = CFrame.lookAt(stepGoal, stepGoal + lookDir)
            stepCF = (rootPart.CFrame - rootPart.CFrame.Position) + stepGoal
        end
        local dur = math.clamp(stepDist / speed, 0.02, 1)
        local tw = _TweenTS:Create(rootPart, TweenInfo.new(dur, Enum.EasingStyle.Linear), { CFrame = stepCF })
        tw:Play()
        tw.Completed:Wait()
    end
    pcall(function() rootPart.Anchored = prevAnchored end)
    if rootPart and rootPart.Parent then rootPart.AssemblyLinearVelocity = Vector3.zero end
end

local function _makeOneWay(plat)
    local lastY = nil
    rsConn = RunService.Stepped:Connect(function()
        if not plat or not plat.Parent then
            if rsConn then rsConn:Disconnect() end
            return
        end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local currentY = hrp.Position.Y
            if not lastY then lastY = currentY end
            local deltaY = currentY - lastY
            local isMovingUp = (hrp.AssemblyLinearVelocity.Y > 1) or (deltaY > 0.01 and deltaY < 5)
                plat.CanCollide = false
                plat.CanCollide = (currentY > plat.Position.Y + 0.1)
            end
            lastY = currentY
        end
    end)
end

if _G.MynxxApproachF2From1 == nil then _G.MynxxApproachF2From1 = true end

local function goToBrainrot(petPos, slot)
    local char, hrp
    local _t0 = os.clock()
        char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        RunService.Heartbeat:Wait()
    until os.clock() - _t0 > 2
    pcall(function() hrp.Anchored = false end)
    equipCarpet()

    local h = petPos.Y
    local _slot = tonumber(slot)
    local targetY = hrp.Position.Y
    local _isFloor1 = false
    if _slot and _slot >= 1 and _slot < 11 then
        targetY = -4
        _isFloor1 = true
    elseif _slot and _slot >= 19 then
        targetY = 21
    elseif _slot and _slot >= 11 then
        targetY = 14.5
    elseif h > 23.15 then
        targetY = 21
    elseif h >= 11 and h <= 23.15 then
        targetY = 14.5
    elseif h >= -6.9 and h <= 8.9 then
        targetY = -4
        _isFloor1 = true
    end
    
    local _f2FromF1 = (not _isFloor1) and _G.MynxxApproachF2From1
        and ((_slot and _slot >= 11 and _slot < 19) or (h > 10 and h <= 23.15))
    if _f2FromF1 then targetY = h - 8 end
    local _to = Vector3.new(petPos.X, targetY, petPos.Z)
    
    if (not _isFloor1) and ((_slot and _slot >= 19) or (not _slot and h > 23.15)) then
        local _plat = Instance.new("Part")
        _plat.Name = "MynxxHubTempPlatform"
        _plat.Size = Vector3.new(3, 1, 3)
        _plat.Position = _to - Vector3.new(0, 5, 0)
        _plat.Anchored = true
        _plat.CanCollide = true
        _plat.Transparency = 1
        _plat.Material = Enum.Material.SmoothPlastic
        _plat.Parent = workspace
        task.spawn(function()
            local _s = tick()
            while tick() - _s < 20 do
                if LP:GetAttribute("Stealing") or _G.MynxxTPStop then break end
                task.wait(0.1)
            end
            if _plat and _plat.Parent then _plat:Destroy() end
        end)
        local plat = Instance.new("Part")
        plat.Name = "XiTempPlatform"
        plat.Size = Vector3.new(6, 1.5, 6)
        plat.Position = _to - Vector3.new(0, 3, 0)
        plat.Color = Color3.fromRGB(240, 240, 240)
        plat.Material = Enum.Material.Neon
        plat.Anchored = true
        plat.CanCollide = false; pcall(_makeOneWay, plat)
        plat.Transparency = 1
        plat.Parent = workspace
        task.spawn(function()
            local _s = tick()
            while tick() - _s < 20 do
                if LP:GetAttribute("Stealing") or _G.MynxxTPStop then break end
                task.wait(0.1)
            end
            if plat and plat.Parent then plat:Destroy() end
        end)
    end
    if not (LP:GetAttribute("Stealing") or _G.MynxxTPStop) then
        
        for _i = 1, 6 do
            if LP:GetAttribute("Stealing") or _G.MynxxTPStop then break end
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            if _i == 1 or (hrp.Position - _to).Magnitude > 2 then
                hrp.CFrame = CFrame.new(_to)
            end
            task.wait(0.05)
        end
    end
    
        local goal = _to
        local stable, t0 = 0, os.clock()
        while os.clock() - t0 < 2.5 do
            if not hrp or not hrp.Parent then break end
            if LP:GetAttribute("Stealing") or _G.MynxxTPStop then break end
            equipCarpet()
            local diff = goal - hrp.Position
            local flat = Vector3.new(diff.X, 0, diff.Z).Magnitude
            local dy   = math.abs(diff.Y)
            if flat <= 2.5 and dy <= 3 then
                hrp.AssemblyLinearVelocity = Vector3.zero
                stable = stable + 1
                if stable >= 5 then break end
                stable = 0
                if diff.Y > 8 then
                    local _hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                        local st = _hum:GetState()
                        if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                            pcall(function() _hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                            pcall(function() _hum.Jump = true end)
                        end
                    end
                end
                local spd = math.clamp(diff.Magnitude * 5, 40, 250)
                hrp.Velocity = diff.Unit * spd
            end
            hrp.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end
    end
    if hrp and hrp.Parent then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
end

local _Stats = game:GetService("Stats")
local function _pingMs()
    local ok, p = pcall(function() return LP:GetNetworkPing() * 1000 end)
    if ok and type(p) == "number" and p > 0 then return p end
    local ok2, p2 = pcall(function()
        return _Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok2 and type(p2) == "number" and p2 > 0 then return p2 end
    return 0
end
_G.MynxxPingMs = _pingMs
local function _pingAdjustSpeed(spd)
    local thresh = tonumber(_G.MynxxPingThresh) or 170
    local capped = tonumber(_G.MynxxHighPingSpeed) or 400
    if _pingMs() >= thresh and spd > capped then return capped end
end

local function _inVoid(hrp)
    if not hrp or not hrp.Parent then return true end
    local voidY = tonumber(_G.MynxxVoidY) or -50
    return hrp.Position.Y < voidY
end
local function _waitOutOfVoid(timeout)
    local t0 = os.clock()
    local good = 0
    while os.clock() - t0 < (timeout or 12) do
        if _G.MynxxTPStop then return false end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Parent and not _inVoid(hrp) and math.abs(hrp.AssemblyLinearVelocity.Y) < 12 then
            good += 1
            if good >= 4 then return true end
            good = 0
        end
        RunService.Heartbeat:Wait()
    end
end

    local lastSafe = nil
    local recovering = false
    local _lastVoidCheck = 0
    RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if _G.MynxxVoidRecover == false then return end
        local now = os.clock()
        if now - _lastVoidCheck < 0.1 then return end
        _lastVoidCheck = now
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return end
        local voidY = tonumber(_G.MynxxVoidY) or -50
        if hrp.Position.Y >= voidY then
            if math.abs(hrp.AssemblyLinearVelocity.Y) < 40 then
                lastSafe = hrp.Position
            end
            return
        end
        recovering = true
        task.spawn(function()
            local delay = tonumber(_G.MynxxVoidRecoverDelay) or 1
            task.wait(delay)
            local vy = tonumber(_G.MynxxVoidY) or -50
            local tries = 0
            while tries < 80 do
                local c = LP.Character
                local h = c and c:FindFirstChild("HumanoidRootPart")
                if not h or not h.Parent then break end
                if h.Position.Y >= vy and math.abs(h.AssemblyLinearVelocity.Y) < 18 then
                    break
                end
                    pcall(function()
                        h.AssemblyLinearVelocity = Vector3.zero
                        h.AssemblyAngularVelocity = Vector3.zero
                        h.CFrame = CFrame.new(lastSafe + Vector3.new(0, 5, 0))
                    end)
                end
                tries = tries + 1
                RunService.Heartbeat:Wait()
            end
            recovering = false
        end)
    end))
end

local isTeleporting = false

local function cframeStepThrough(hrp, waypoints, stepSize)
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    stepSize = stepSize or 24
    local lockY = hrp.Position.Y
    vizPath(hrp.Position, waypoints)
    local wpIdx = 1
    local deadline = os.clock() + 10
    local _lastFire = 0
    while hrp and hrp.Parent and os.clock() < deadline do
        if _G.MynxxTPStop then break end
            local char = hrp.Parent
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and char and not char:FindFirstChild("Grapple Hook") then
                local g = findGrapple()
                if g then pcall(function() hum:EquipTool(g) end) end
            end
            if os.clock() - _lastFire > 0.3 then
                _lastFire = os.clock()
                if char and char:FindFirstChild("Grapple Hook") then
                    _G.XenFireGrapple2()
                end
            end
        end
        local target = waypoints[wpIdx]
        local flat = Vector3.new(target.X - hrp.Position.X, 0, target.Z - hrp.Position.Z)
        local mag = flat.Magnitude
        if mag < 2 then
            wpIdx = wpIdx + 1
            if wpIdx > #waypoints then break end
            RunService.Heartbeat:Wait()
            local hop = math.min(stepSize, mag)
            local nextPos = hrp.Position + flat.Unit * hop
            local _, y = hrp.CFrame:ToEulerAnglesYXZ()
            hrp.CFrame = CFrame.new(Vector3.new(nextPos.X, lockY, nextPos.Z)) * CFrame.Angles(0, y, 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            task.wait(hop / math.clamp(tonumber(_G.MynxxCFrameSpeed) or 450, 60, 900))
        end
    end
        local hum = hrp and hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:UnequipTools() end) end
        task.wait(0.05)
        equipCarpet()
    end
    if hrp and hrp.Parent then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
end

local function doVelocityTP(forceGrapple)
    isTeleporting = true
    _G.MynxxTPStop = false
    clearViz()
    if not NetModule then pcall(loadNet) end

    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then isTeleporting = false; return end

    if _inVoid(hrp) or hrp.AssemblyLinearVelocity.Y < -40 then
        _waitOutOfVoid(12)
        if _G.MynxxTPStop then isTeleporting = false; return end
        char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then isTeleporting = false; return end
    end

    local allPets = scanForTP()
    if #allPets == 0 then
        local _t0 = os.clock()
        while #allPets == 0 and os.clock() - _t0 < 4 do
            task.wait(0.05)
            allPets = scanForTP()
        end
    end
    if #allPets == 0 then isTeleporting = false; return end

    if type(_G.MynxxStealTargetUID) == "string" and _G.MynxxStealTargetUID ~= "" then
        pet = _findStealTarget(allPets)
        if not pet then isTeleporting = false; return end
        
        
        local prio, best
        for _, p in ipairs(allPets) do
            if not p.conveyor then
                if p._pri and (not prio or p._pri < prio._pri) then prio = p end
                if not best or (p.mps or 0) > (best.mps or 0) then best = p end
            end
        end
        pet = prio or best or allPets[1]
    end
    local petPos = pet.position
    local petName = pet.name

    _G.MynxxStealHold = true
    task.delay(15, function() _G.MynxxStealHold = false end)

    local adjY = petPos.Y
    if TALL_PETS[petName] then adjY = petPos.Y - TALL_OFFSET end
    local coordTable = adjY > 23.15 and UPPER or LOWER

    if petPos.Y <= 8.9 and isPlotUnlocked(pet.plot) then
        carpetEngage(forceGrapple)
        vZero(hrp)
        local _to = Vector3.new(petPos.X, -4, petPos.Z)
        local route = computeRoute(hrp.Position, _to, nil)
        if not route or #route == 0 then route = { _to } end
        local _obSpeed = math.clamp(tonumber(_G.TPVelocity) or 400, 200, 750)
            local _len, _prev = 0, hrp.Position
            for _, wp in ipairs(route) do _len = _len + (wp - _prev).Magnitude; _prev = wp end
            
            
            
            if _len < 100 then
                _obSpeed = math.clamp(tonumber(_G.MynxxCloseSpeed) or 80, 20, 400)
            end
        end
        _obSpeed = _pingAdjustSpeed(_obSpeed)
        
        velMoveThrough(hrp, route, _obSpeed, true, true)
        if hrp and hrp.Parent then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        _G.MynxxStealHold = false
        isTeleporting = false
        if _G.MynxxTPStop then return end
        return
    end

    local closestData, skyKey = findClosest(petPos, coordTable)
    if not closestData or not skyKey then _G.MynxxStealHold = false; isTeleporting = false; return end

    local destPos = closestData.coord

    local _carpet = carpetEngage(forceGrapple)
    vZero(hrp)

    local facingDir = closestData.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)

    local _frontApproach = false
        local isUpper = (coordTable == UPPER)
        local idx = getClosestBaseIdx(petPos)
        local frontCoord, frontFace = buildFrontCandidate(idx, isUpper, hrp.Position.Z)
        local bestCoord, bestFace = frontCoord, frontFace
        local bestDist = (hrp.Position - frontCoord).Magnitude
        local pickedFront = true

        
        
        
        
        
        local _tb = BASES_LOW[idx]
        local _isWest = idx <= 4
        local _rowBlocked = false
        
        
        
        local _dx, _dz = hrp.Position.X - _tb.X, hrp.Position.Z - _tb.Z
        local _distToBase = math.sqrt(_dx * _dx + _dz * _dz)
        local _sideRange = tonumber(_G.MynxxSideTPRange) or 100
        if _G.MynxxPreferFrontOnRow ~= false and _distToBase > _sideRange then
            for i = 1, 8 do
                if i ~= idx and (i <= 4) == _isWest then
                    local bz = BASES_LOW[i].Z
                    if (bz - hrp.Position.Z) * (bz - _tb.Z) < 0 then _rowBlocked = true; break end
                end
            end
        end

            for _, d in ipairs(plotSides(coordTable, idx)) do
                local dd = (hrp.Position - d.coord).Magnitude
                if dd < bestDist then
                    bestDist = dd
                    bestCoord = d.coord
                    bestFace = d.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)
                    pickedFront = false
                end
            end
        end
        destPos = bestCoord
        facingDir = bestFace
        _frontApproach = pickedFront
    end

    if facingDir and facingDir.Magnitude > 0.1 then
        local axis = facingDir.Unit
        local toPlayer = hrp.Position - destPos
        local sign = (axis:Dot(toPlayer) >= 0) and 1 or -1
        destPos = destPos + axis * sign * (tonumber(_G.MynxxCloneBackoff) or 0.5)
    end

    
    
    
    
    
        local _holdReleaseStuds = tonumber(_G.StealHoldReleaseStuds) or 16
        task.spawn(function()
            while _G.MynxxStealHold do
                local _wh = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if _wh and _wh.Parent and (_wh.Position - destPos).Magnitude <= _holdReleaseStuds then
                    _G.MynxxStealHold = false
                    break
                end
                RunService.Heartbeat:Wait()
            end
        end)
    end

    local _route = computeRoute(hrp.Position, destPos, facingDir, nil, true)

    local ASCEND_STEP = 10
    local _stepped = {}
        local prev = hrp.Position
        for _, wp in ipairs(_route) do
            local dy = wp.Y - prev.Y
            if dy > ASCEND_STEP * 1.5 then
                local n = math.ceil(dy / ASCEND_STEP)
                for s = 1, n - 1 do
                    local t = s / n
                    _stepped[#_stepped + 1] = Vector3.new(
                        prev.X + (wp.X - prev.X) * t,
                        prev.Y + dy * t,
                        prev.Z + (wp.Z - prev.Z) * t
                    )
                end
            end
            _stepped[#_stepped + 1] = wp
            prev = wp
        end
    end
    local _mainSpeed = math.clamp(tonumber(_G.TPVelocity) or 400, 200, 750)
        local _len, _prev = 0, hrp.Position
        for _, wp in ipairs(_route) do _len = _len + (wp - _prev).Magnitude; _prev = wp end
        
        if _len < 100 then
            _mainSpeed = math.clamp(tonumber(_G.MynxxCloseSpeed) or 80, 20, 400)
        end
    end
    _mainSpeed = _pingAdjustSpeed(_mainSpeed)
    
    velMoveThrough(hrp, _stepped, _mainSpeed, true, true)
    if _G.MynxxTPStop then
        if hrp and hrp.Parent then vZero(hrp) end
        _G.MynxxStealHold = false
        isTeleporting = false
        return
    end

        local above = destPos + Vector3.new(0, 16, 0)
        local _t0 = os.clock()
        while os.clock() - _t0 < 1.5 do
            if not hrp or not hrp.Parent then break end
            if LP:GetAttribute("Stealing") or _G.MynxxTPStop then break end
            equipCarpet()
            local d = above - hrp.Position
            local flat = Vector3.new(d.X, 0, d.Z).Magnitude
            if flat <= 3 and hrp.Position.Y >= destPos.Y then break end
            if d.Y > 3 then
                local _hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                    local st = _hum:GetState()
                    if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() _hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() _hum.Jump = true end)
                    end
                end
            end
            hrp.Velocity = d.Unit * math.min(math.max(d.Magnitude * 8, 55), 320)
            hrp.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end
    end

        local _runCap = _frontApproach and (tonumber(_G.MynxxFrontRunIn) or 130) or 400
        local _t0 = os.clock()
        local _bestMag, _bestT = math.huge, os.clock()
        while os.clock() - _t0 < 4 do
            if not hrp or not hrp.Parent then break end
            if LP:GetAttribute("Stealing") or _G.MynxxTPStop then break end
            equipCarpet()
            local diff = destPos - hrp.Position
            local mag = diff.Magnitude
            if mag <= 3 then break end
            
            
            
            
            if mag < _bestMag - 0.5 then _bestMag = mag; _bestT = os.clock()
            elseif os.clock() - _bestT > 0.6 then break end
            if diff.Y > 3 then
                local _hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                    local st = _hum:GetState()
                    if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() _hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() _hum.Jump = true end)
                    end
                end
            end
            
            
            hrp.Velocity = diff.Unit * math.min(math.max(mag * 8, 55), _runCap)
            hrp.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end
    end

    if hrp and hrp.Parent and not _G.MynxxTPStop then
        local _flatOff = Vector3.new(destPos.X - hrp.Position.X, 0, destPos.Z - hrp.Position.Z).Magnitude
        if _flatOff > 10 then
            
            local CRUISE_Y = math.max(destPos.Y, hrp.Position.Y) + 40
            local function _airborne()
                local _hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                    local st = _hum:GetState()
                    if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() _hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() _hum.Jump = true end)
                    end
                end
            end
            local _t0 = os.clock()
            while os.clock() - _t0 < 2 do
                if not hrp or not hrp.Parent or _G.MynxxTPStop or LP:GetAttribute("Stealing") then break end
                equipCarpet()
                local dy = CRUISE_Y - hrp.Position.Y
                if dy <= 2 then break end
                _airborne()
                hrp.Velocity = Vector3.new(0, math.min(240, dy * 8), 0)
                hrp.AssemblyAngularVelocity = Vector3.zero
                RunService.Heartbeat:Wait()
            end
            _t0 = os.clock()
            while os.clock() - _t0 < 3 do
                if not hrp or not hrp.Parent or _G.MynxxTPStop or LP:GetAttribute("Stealing") then break end
                equipCarpet()
                local d = Vector3.new(destPos.X - hrp.Position.X, 0, destPos.Z - hrp.Position.Z)
                if d.Magnitude <= 2.5 then break end
                _airborne()
                local lift = math.max(0, CRUISE_Y - hrp.Position.Y) * 4
                hrp.Velocity = d.Unit * math.min(400, d.Magnitude * 8) + Vector3.new(0, lift, 0)
                hrp.AssemblyAngularVelocity = Vector3.zero
                RunService.Heartbeat:Wait()
            end
            _t0 = os.clock()
            while os.clock() - _t0 < 2.5 do
                if not hrp or not hrp.Parent or _G.MynxxTPStop or LP:GetAttribute("Stealing") then break end
                equipCarpet()
                local d = destPos - hrp.Position
                if d.Magnitude <= 3 then break end
                hrp.Velocity = d.Unit * math.min(200, d.Magnitude * 6)
                hrp.AssemblyAngularVelocity = Vector3.zero
                RunService.Heartbeat:Wait()
            end
            if hrp and hrp.Parent then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end

    if hrp and hrp.Parent then
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + facingDir)
    end
    vZero(hrp)

    local syncFrames = 5
    syncConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if not hrp or not hrp.Parent then syncConn:Disconnect(); return end
        syncFrames = syncFrames - 1
        hrp.CFrame = CFrame.new(destPos, destPos + facingDir)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if syncFrames <= 0 then syncConn:Disconnect() end
    end))

    for _ = 1, 20 do
        task.wait(0.05)
        if hum.FloorMaterial ~= Enum.Material.Air then break end
    end

    
    
    

        
        local stable = 0
        for _ = 1, 50 do
            if _G.MynxxTPStop then break end
            local _hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not _hrp or not _hrp.Parent then break end
            local flat = (Vector3.new(_hrp.Position.X, 0, _hrp.Position.Z) - Vector3.new(destPos.X, 0, destPos.Z)).Magnitude
            if flat <= 3.5 and math.abs(_hrp.Position.Y - destPos.Y) <= 4 then
                stable = stable + 1
                if stable >= 4 then break end
                stable = 0
                pcall(function() _hrp.CFrame = CFrame.new(destPos, destPos + facingDir) end)
                _hrp.AssemblyLinearVelocity = Vector3.zero
                _hrp.AssemblyAngularVelocity = Vector3.zero
            end
            RunService.Heartbeat:Wait()
        end
    end
    local _ahrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local _clonePos = (_ahrp and _ahrp.Parent and _ahrp.Position) or destPos

    local _clonePlat = Instance.new("Part")
    _clonePlat.Name = "MynxxHubClonePlatform"
    _clonePlat.Size = Vector3.new(12, 1, 12)
    _clonePlat.Position = Vector3.new(_clonePos.X, _clonePos.Y - 3, _clonePos.Z)
    _clonePlat.Anchored = true
    _clonePlat.CanCollide = true
    _clonePlat.Transparency = 1
    _clonePlat.Material = Enum.Material.SmoothPlastic
    _clonePlat.Parent = workspace

    if _ahrp and _ahrp.Parent then
        _ahrp.AssemblyLinearVelocity = Vector3.zero
        _ahrp.AssemblyAngularVelocity = Vector3.zero
    end

    local _preClonePos, _preCloneChar
        _preCloneChar = LP.Character
        local _h = _preCloneChar and _preCloneChar:FindFirstChild("HumanoidRootPart")
        _preClonePos = _h and _h.Position or destPos
    end
    local _charAdded = false
    local _caConn = LP.CharacterAdded:Connect(function() _charAdded = true end)

    _G.MynxxStealHold = false

    task.wait(tonumber(_G.TPCloneDelay) or tonumber(_G.LandingDelay) or 0.1)

    if facingDir and facingDir.Magnitude > 0.1 then
        local _pinHum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if _pinHum then pcall(function() _pinHum.AutoRotate = false end) end
        for _ = 1, 4 do
            local _h = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not _h or not _h.Parent then break end
            pcall(function()
                _h.CFrame = CFrame.new(_h.Position, _h.Position + facingDir)
                _h.AssemblyLinearVelocity = Vector3.zero
                _h.AssemblyAngularVelocity = Vector3.zero
            end)
            RunService.Heartbeat:Wait()
        end
    end

    local _cloneOk = doClone()
    if _clonePlat then pcall(function() _clonePlat:Destroy() end); _clonePlat = nil end
        local _t0 = os.clock()
            if LP.Character ~= _preCloneChar then break end
            local _h = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                local _dx = _h.Position.X - _preClonePos.X
                local _dz = _h.Position.Z - _preClonePos.Z
                if (_dx * _dx + _dz * _dz) > 4 then break end
            end
            RunService.Heartbeat:Wait()
        until os.clock() - _t0 > 3
    end
    if _caConn then _caConn:Disconnect() end

    pcall(function()
        local _rh = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if _rh then _rh.AutoRotate = true end
    end)

    goToBrainrot(petPos, pet and pet.slot)
    
    
    
    
    isTeleporting = false
    if _G.MynxxTPStop then return end
    if _G.MynxxArmSteal then pcall(_G.MynxxArmSteal, pet) end
end

local _manualTPBusy = false
local function manualFullTP()
    _manualTPBusy = true
    local okAll = pcall(function()
        local function _allChannelsReady()
            local Plots = workspace:FindFirstChild("Plots")
            local kids = Plots:GetChildren()
            if #kids == 0 then return false end
            for _, plot in ipairs(kids) do
                if not getPlotChannel(plot.Name) then return false end
            end
        end
        local _t0 = os.clock()
        local _lastN, _lastTop = -1, nil
            if _allChannelsReady() then
                local ok, pets = pcall(scanForTP)
                if ok and pets and #pets > 0 then
                    local top = tostring(pets[1].plot) .. "_" .. tostring(pets[1].slot)
                    if #pets == _lastN and top == _lastTop then break end
                    _lastN, _lastTop = #pets, top
                    task.wait(0.15)
                    task.wait(0.05)
                end
                task.wait(0.05)
            end
        until os.clock() - _t0 > 12
        doVelocityTP(true)
    end)
    _manualTPBusy = false
end
_G.MynxxStartSideTP = manualFullTP

    local VK_XBUTTON1, VK_XBUTTON2 = 0x05, 0x06
    local function _norm(s)
        if type(s) ~= "string" or s == "" then return nil end
        if string.find(s, ":", 1, true) then return s end
        return "Key:" .. s
    end
    _G._stpNormBind = _norm
    _G._stpBindPretty = function(s)
        local n = _norm(s); if not n then return "NONE" end
        local kind, name = string.match(n, "^([^:]+):(.+)$")
        if kind == "Mouse" then
            local map = { MouseButton1="MB1", MouseButton2="MB2", MouseButton3="MB3",
                          MouseButton4="MB4", XButton1="MB4", MouseButton5="MB5", XButton2="MB5" }
            return map[name] or name
        end
    end
    local function _isMouseBtn(input)
        local nm = input.UserInputType and input.UserInputType.Name
        return nm == "MouseButton1" or nm == "MouseButton2" or nm == "MouseButton3"
            or nm == "MouseButton4" or nm == "MouseButton5"
    end
    _G._stpIsMouseBtn = _isMouseBtn
    _G._stpInputMatches = function(input, bind)
        bind = _norm(bind); if not bind then return false end
        local kind, name = string.match(bind, "^([^:]+):(.+)$")
        if kind == "Key" then
            return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == name
        elseif kind == "Mouse" then
            return input.UserInputType.Name == name
        end
    end
    local function _vkDown(vk)
        for _, fn in ipairs({ iskeydown, iskeypressed }) do
            if typeof(fn) == "function" then local ok, r = pcall(fn, vk); if ok and r then return true end end
        end
        if typeof(getkeystate) == "function" then
            local ok, r = pcall(getkeystate, vk)
                if r == true then return true end
                if type(r) == "number" and (r < 0 or (bit32 and bit32.band(r, 0x8000) ~= 0)) then return true end
            end
        end
    end
    local function _sideDown(side)
        local name = "MouseButton" .. tostring(side)
        local ok, uit = pcall(function() return Enum.UserInputType[name] end)
        if ok and uit then local ok2, p = pcall(function() return UIS:IsMouseButtonPressed(uit) end); if ok2 and p then return true end end
        local okk, kc = pcall(function() return Enum.KeyCode[name] end)
            local ok2, p = pcall(function() return UIS:IsKeyDown(kc) end); if ok2 and p then return true end
            if typeof(iskeydown) == "function" then local ok3, p3 = pcall(iskeydown, kc); if ok3 and p3 then return true end end
        end
        return _vkDown(side == 5 and VK_XBUTTON2 or VK_XBUTTON1)
    end
    _G._stpSideDown = _sideDown
    _G._stpBindIsSide = function(bind, side)
        bind = _norm(bind); if not bind then return false end
        local want = "Mouse:MouseButton" .. tostring(side)
        if bind == want then return true end
        if side == 4 and (bind == "Mouse:XButton1" or bind == "Mouse:MB4") then return true end
        if side == 5 and (bind == "Mouse:XButton2" or bind == "Mouse:MB5") then return true end
    end

    
    local prev4, prev5 = false, false
    local function _onSide(side)
        if _G._stp_listening then return end
        if _G._stpBindIsSide(_norm(_G._stp_tpKeyName) or "Key:T", side) then
            task.spawn(function() pcall(manualFullTP) end)
        end
        if _G.MynxxNearestKey and _G._stpBindIsSide(_G.MynxxNearestKey, side) and _G._stpFireNearKey then
            pcall(_G._stpFireNearKey)
        end
    end
    RunService.Heartbeat:Connect(function()
        
        
        local tp = _norm(_G._stp_tpKeyName) or "Key:T"
        local nk = _G.MynxxNearestKey
        local n4 = _G._stpBindIsSide(tp, 4) or (nk ~= nil and _G._stpBindIsSide(nk, 4))
        local n5 = _G._stpBindIsSide(tp, 5) or (nk ~= nil and _G._stpBindIsSide(nk, 5))
        if not (n4 or n5) then prev4, prev5 = false, false; return end
        local d4 = n4 and _sideDown(4) or false
        local d5 = n5 and _sideDown(5) or false
        if d4 and not prev4 then _onSide(4) end
        if d5 and not prev5 then _onSide(5) end
        prev4, prev5 = d4, d5
    end)

    
    
    _G._stpListenBind = function(setBind, onDone)
        if _G._stp_listening then return end
        _G._stp_listening = true
        task.spawn(function()
            while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton3)
                or _sideDown(4) or _sideDown(5) do task.wait() end
            local done = false
            local function finish(b)
                done = true; _G._stp_listening = false
                if b then setBind(b) end
                if onDone then pcall(onDone, b) end
            end
            conn = UIS.InputBegan:Connect(function(input, gp)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local nm = input.KeyCode.Name
                    if conn then conn:Disconnect() end
                    if nm == "Escape" then finish(nil) else finish("Key:" .. nm) end
                elseif _isMouseBtn(input) then
                    if conn then conn:Disconnect() end
                    finish("Mouse:" .. input.UserInputType.Name)
                end
            end)
            local p4, p5 = _sideDown(4), _sideDown(5)
            while not done and _G._stp_listening do
                local d4, d5 = _sideDown(4), _sideDown(5)
                if d4 and not p4 then if conn then conn:Disconnect() end; finish("Mouse:MouseButton4"); break end
                if d5 and not p5 then if conn then conn:Disconnect() end; finish("Mouse:MouseButton5"); break end
                p4, p5 = d4, d5
                task.wait()
            end
            if conn then pcall(function() conn:Disconnect() end) end
        end)
    end

    
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if _G._stp_listening then return end
        local want = _norm(_G._stp_tpKeyName) or "Key:T"
        if _G._stpBindIsSide(want, 4) or _G._stpBindIsSide(want, 5) then return end
        if _G._stpInputMatches(input, want) then
            task.spawn(function() pcall(manualFullTP) end)
        end
    end)
end

task.spawn(function() pcall(loadModules) pcall(loadNet) end)

_G.MynxxChannelsReady = false
task.spawn(function()
    local _t0 = os.clock()
        pcall(loadModules)
        local Plots = workspace:FindFirstChild("Plots")
            local kids = Plots:GetChildren()
            if #kids > 0 then
                local all = true
                for _, p in ipairs(kids) do
                    if not getPlotChannel(p.Name) then all = false break end
                end
                if all then _G.MynxxChannelsReady = true return end
            end
        end
        RunService.Heartbeat:Wait()
    until os.clock() - _t0 > 25
end)

task.spawn(function()
    local char = LP.Character or LP.CharacterAdded:Wait()
    char:WaitForChild("HumanoidRootPart", 10)
    char:WaitForChild("Humanoid", 10)
    pcall(loadModules); pcall(loadNet)
    if _G.MynxxAutoTP ~= false then
        task.spawn(function()
            local _tw = os.clock()
            while os.clock() - _tw < 12 do
                for _, n in ipairs(CARPET_NAMES) do
                    if findTool(n) then pcall(carpetEngage) return end
                end
                task.wait(0.05)
            end
        end)
    end
    local function _allChannelsReady()
        local Plots = workspace:FindFirstChild("Plots")
        local kids = Plots:GetChildren()
        if #kids == 0 then return false end
        for _, plot in ipairs(kids) do
            if not getPlotChannel(plot.Name) then return false end
        end
    end
    local _t0 = os.clock()
    local _lastN, _lastTop = -1, nil
        if _allChannelsReady() then
            local ok, pets = pcall(scanAllPets)
            if ok and pets and #pets > 0 then
                local top = tostring(pets[1].plot) .. "_" .. tostring(pets[1].slot)
                if #pets == _lastN and top == _lastTop then break end
                _lastN, _lastTop = #pets, top
                task.wait(tonumber(_G.MynxxScanSettle) or 0.06)
                RunService.Heartbeat:Wait()
            end
            RunService.Heartbeat:Wait()
        end
    until os.clock() - _t0 > 12
        local _d = tonumber(_G._stp_tpDelay) or tonumber(_G.TPDelay) or 0
        if _d > 0 then task.wait(_d) end
    end
    if _G.MynxxAutoTP == false then return end
        local _tw = os.clock()
        local function _carpetEquipped()
            local c = LP.Character
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then return true end
            end
        end
        while not _carpetEquipped() and os.clock() - _tw < 12 do
            task.wait(0.05)
        end
    end
    pcall(doVelocityTP)
end)

task.spawn(function()
    local Players = game:GetService("Players")
    while not Players.LocalPlayer do task.wait() end
    local t0 = os.clock()
        task.wait(0.5)
        local ok, r = pcall(scanAllPets)
        if ok and type(r) == "table" then pets = r end
    until (pets and #pets > 0) or os.clock() - t0 > 25
    local hasPrio = false
    for _, p in ipairs(pets) do if p._pri then hasPrio = true break end end
    local sid = tostring(_G.MynxxPrioritySoundID or ""):match("%d+")
    pcall(function()
        local snd = Instance.new("Sound")
        snd.SoundId = "rbxassetid://" .. sid
        snd.Volume = 1
        snd.Parent = game:GetService("SoundService")
        snd:Play()
        game:GetService("Debris"):AddItem(snd, 6)
    end)
end)

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer
    local PG = LP:WaitForChild("PlayerGui")

    local function notify(t, m)
        local old = PG:FindFirstChild("TPTestNotif"); if old then old:Destroy() end
        local sg = Instance.new("ScreenGui"); sg.Name="TPTestNotif"; sg.ResetOnSpawn=false; sg.Parent=PG
        local f = Instance.new("Frame", sg); f.Size=UDim2.new(0,300,0,54); f.Position=UDim2.new(0.5,-150,0,70)
        f.BackgroundColor3=Color3.fromRGB(10,10,10); Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
        local a=Instance.new("TextLabel",f); a.Size=UDim2.new(1,-16,0,18); a.Position=UDim2.new(0,8,0,6)
        a.BackgroundTransparency=1; a.Text=tostring(t); a.Font=Enum.Font.GothamBold; a.TextSize=12; a.TextColor3=Color3.new(1,1,1); a.TextXAlignment=Enum.TextXAlignment.Left
        local b=Instance.new("TextLabel",f); b.Size=UDim2.new(1,-16,0,18); b.Position=UDim2.new(0,8,0,28)
        b.BackgroundTransparency=1; b.Text=tostring(m); b.Font=Enum.Font.Gotham; b.TextSize=11; b.TextColor3=Color3.fromRGB(180,180,180); b.TextXAlignment=Enum.TextXAlignment.Left
        task.delay(3, function() if sg.Parent then sg:Destroy() end end)
    end

    local function diag()
        pcall(loadModules)
        local Plots = workspace:FindFirstChild("Plots")
        local nPlots = Plots and #Plots:GetChildren() or 0
        local nCh, nOwn, nAl = 0,0,0
            for _, plot in ipairs(Plots:GetChildren()) do
                local ch = getPlotChannel(plot.Name)
                    nCh = nCh + 1
                    if ownerInGame(ch) then nOwn = nOwn + 1 end
                    if channelGet(ch, "AnimalList") then nAl = nAl + 1 end
                end
            end
        end
        local ok, pets = pcall(scanAllPets)
        local nPets = (ok and pets and #pets) or 0
        local msg = string.format("plots=%d ch=%d owner=%d animals=%d PETS=%d", nPlots, nCh, nOwn, nAl, nPets)
        notify("SCAN DIAG", msg)
        if nPets > 0 and pets[1] then
        end
    end

    local function findStealPrompt(pet)
        if pet.plot and pet.slot then
            local plots = workspace:FindFirstChild("Plots")
            local plot = plots and plots:FindFirstChild(pet.plot)
            local podiums = plot and plot:FindFirstChild("AnimalPodiums")
            local podium = podiums and podiums:FindFirstChild(tostring(pet.slot))
                local base = podium:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                local attach = spawn and spawn:FindFirstChild("PromptAttachment")
                    for _, p in ipairs(attach:GetChildren()) do
                        if p:IsA("ProximityPrompt") then return p end
                    end
                end
                for _, d in ipairs(podium:GetDescendants()) do
                    if d:IsA("ProximityPrompt") then return d end
                end
            end
        end
    end

    
    loadstring(game:HttpGet(""))()
    local InternalStealCache = {}
    local STEAL_HOLD_DURATION = 1.3
    local STEAL_PROXIMITY = 57
    local _stealHoldStart, _stealHoldActive = 0, false
    local _stealHoldGen = 0
    local _holdPrompt, _holdTargetUid = nil, nil
    local _stealTarget, _stealArmedAt = nil, 0
    local _stealLastScan, _autoLastScan = 0, 0
    
    
    local _lastTargetPick, _lastPickUid = 0, nil

    local function _promptWorldPos(prompt)
        local pp = prompt.Parent
        if pp and pp:IsA("BasePart") then return pp.Position end
        if pp and pp.Parent and pp.Parent:IsA("BasePart") then return pp.Parent.Position end
    end

    
    local function _nearestDist(pet, myPos)
        if not pet or not myPos then return math.huge end
        local pos = pet.position
            pos = _promptWorldPos(findStealPrompt(pet))
        end
        if not pos then return math.huge end
        local dx, dz = pos.X - myPos.X, pos.Z - myPos.Z
        return math.sqrt(dx * dx + dz * dz)
    end

    local function abortStealHold()
        _stealHoldGen += 1
        _stealHoldActive = false
        local prompt = _holdPrompt
        _holdPrompt, _holdTargetUid = nil, nil
        if prompt and InternalStealCache[prompt] then
            local data = InternalStealCache[prompt]
            for _, fn in ipairs(data.holdEndCallbacks or {}) do
                task.spawn(fn)
            end
            data.ready = true
        end
    end

    
    
    
    local stealBarSg, stealBarFill, stealBarTitle, stealBarPct
    
    
    local _currentTargetName = nil
    local function ensureStealBar()
        if stealBarSg and stealBarSg.Parent then return end
        local old = PG:FindFirstChild("LeanStealBar")
        if old then old:Destroy() end
        stealBarSg = Instance.new("ScreenGui")
        stealBarSg.Name = "LeanStealBar"
        stealBarSg.ResetOnSpawn = false
        stealBarSg.IgnoreGuiInset = true
        stealBarSg.DisplayOrder = 120
        stealBarSg.Parent = PG
        local wrap = Instance.new("Frame", stealBarSg)
        wrap.Name = "Wrap"
        wrap.AnchorPoint = Vector2.new(0.5, 1)
        
        wrap.Position = UDim2.new(0.5, 0, 1, -90)
        wrap.Size = UDim2.new(0, 340, 0, 46)
        wrap.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        wrap.BorderSizePixel = 0
        Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 8)
        stealBarTitle = Instance.new("TextLabel", wrap)
        stealBarTitle.BackgroundTransparency = 1
        stealBarTitle.Position = UDim2.new(0, 10, 0, 4)
        stealBarTitle.Size = UDim2.new(1, -70, 0, 16)
        stealBarTitle.Font = Enum.Font.GothamBold
        stealBarTitle.TextSize = 12
        stealBarTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
        stealBarTitle.TextXAlignment = Enum.TextXAlignment.Left
        stealBarTitle.Text = "STEAL"
        stealBarPct = Instance.new("TextLabel", wrap)
        stealBarPct.BackgroundTransparency = 1
        stealBarPct.Position = UDim2.new(1, -60, 0, 4)
        stealBarPct.Size = UDim2.new(0, 50, 0, 16)
        stealBarPct.Font = Enum.Font.GothamBold
        stealBarPct.TextSize = 12
        stealBarPct.TextColor3 = Color3.fromRGB(180, 220, 255)
        stealBarPct.TextXAlignment = Enum.TextXAlignment.Right
        stealBarPct.Text = "0%"
        local track = Instance.new("Frame", wrap)
        track.Position = UDim2.new(0, 10, 0, 26)
        track.Size = UDim2.new(1, -20, 0, 10)
        track.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
        track.BorderSizePixel = 0
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
        stealBarFill = Instance.new("Frame", track)
        stealBarFill.Size = UDim2.new(0, 0, 1, 0)
        stealBarFill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        stealBarFill.BorderSizePixel = 0
        Instance.new("UICorner", stealBarFill).CornerRadius = UDim.new(1, 0)
        stealBarSg.Enabled = true
    end
    local function showStealBar(name, pct)
        pcall(function()
            ensureStealBar()
            pct = math.clamp(tonumber(pct) or 0, 0, 1)
            stealBarSg.Enabled = true
            stealBarTitle.Text = "STEAL  " .. tostring(name or "")
            stealBarPct.Text = tostring(math.floor(pct * 100 + 0.5)) .. "%"
            stealBarFill.Size = UDim2.new(pct, 0, 1, 0)
        end)
    end
    local function setStealBarPct(pct)
        if not stealBarSg or not stealBarSg.Enabled then return end
        pcall(function()
            pct = math.clamp(tonumber(pct) or 0, 0, 1)
            stealBarPct.Text = tostring(math.floor(pct * 100 + 0.5)) .. "%"
            stealBarFill.Size = UDim2.new(pct, 0, 1, 0)
        end)
    end
    
    
    local function hideStealBar()
        pcall(function()
            ensureStealBar()
            stealBarSg.Enabled = true
            stealBarTitle.Text = _currentTargetName and ("STEAL  " .. _currentTargetName) or "STEAL"
            stealBarPct.Text = "0%"
            stealBarFill.Size = UDim2.new(0, 0, 1, 0)
        end)
    end
    
    task.defer(hideStealBar)

    
    
    
    
    
    
    
    
        local RAGBAR_STATES = {
            [Enum.HumanoidStateType.Physics]     = true,
            [Enum.HumanoidStateType.Ragdoll]     = true,
            [Enum.HumanoidStateType.FallingDown] = true,
            [Enum.HumanoidStateType.GettingUp]   = true,
        }
        local RAG_RED     = Color3.fromRGB(255, 60, 60)
        local RAG_ORANGE  = Color3.fromRGB(255, 160, 60)
        local STEAL_GREEN = Color3.fromRGB(50, 150, 255)
        local PCT_GREEN   = Color3.fromRGB(180, 220, 255)
        local ragBarOn, ragLastEnd, ragTotal = false, nil, nil
        RunService.RenderStepped:Connect(function()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            local endTime = hum and LP:GetAttribute("RagdollEndTime")
            local left = endTime and (endTime - workspace:GetServerTimeNow()) or nil
            local isRag = hum and (RAGBAR_STATES[hum:GetState()] or (left and left > 0))
                ensureStealBar()
                ragBarOn = true
                stealBarSg.Enabled = true
                stealBarFill.BackgroundColor3 = RAG_RED
                stealBarPct.TextColor3 = RAG_ORANGE
                if left and left > 0 then
                    
                    if endTime ~= ragLastEnd then ragLastEnd = endTime; ragTotal = left end
                    local p = math.clamp(left / math.max(ragTotal or left, 0.1), 0, 1)
                    stealBarTitle.Text = string.format("RAGDOLL - %.1fs", left)
                    stealBarPct.Text   = string.format("%.1fs", left)
                    stealBarFill.Size  = UDim2.new(p, 0, 1, 0)
                    stealBarTitle.Text = "RAGDOLL"
                    stealBarPct.Text   = "..."
                    stealBarFill.Size  = UDim2.new(1, 0, 1, 0)
                end
                
                ragBarOn, ragLastEnd, ragTotal = false, nil, nil
                stealBarFill.BackgroundColor3 = STEAL_GREEN
                stealBarPct.TextColor3 = PCT_GREEN
                if not _stealHoldActive then hideStealBar() end
            end
        end)
    end

    local function buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then return end
        if not prompt or not prompt.Parent then return end
        local data = { holdCallbacks = {}, triggerCallbacks = {}, holdEndCallbacks = {}, ready = true }
        local function grab(sig, into)
            local ok, conns = pcall(getconnections, sig)
            if ok and type(conns) == "table" then
                for _, c in ipairs(conns) do
                    if type(c.Function) == "function" then table.insert(into, c.Function) end
                end
            end
        end
        grab(prompt.PromptButtonHoldBegan, data.holdCallbacks)
        grab(prompt.Triggered, data.triggerCallbacks)
        grab(prompt.PromptButtonHoldEnded, data.holdEndCallbacks)
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 or #data.holdEndCallbacks > 0 then
            InternalStealCache[prompt] = data
        end
    end

    
    
    
    local function executeStealAsync(prompt, petName, targetUid)
        local data = InternalStealCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        _stealHoldStart = tick()
        _stealHoldActive = true
        _holdPrompt = prompt
        _holdTargetUid = targetUid
        local gen = _stealHoldGen
        showStealBar(petName, 0)
        task.spawn(function()
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
            pcall(function()
                local _st = prompt:GetAttribute("State")
                if _st ~= nil and _st ~= "Steal" then
                    if not _G._mynxxStealRemote and _G.MynxxGetRemote then
                        _G._mynxxStealRemote = _G.MynxxGetRemote("RemoteEvent", "f40f7d9e-2f0d-4167-b250-899273f46874")
                    end
                    local r = _G._mynxxStealRemote
                        local _t = workspace:GetServerTimeNow() + 124
                        r:FireServer(_t, "68c86eb7-eb7e-4b4d-96ae-cf7cd847c5b0")
                        r:FireServer(_t, "07b9cc25-2a1f-4a26-a0ec-f2fab578d8bd")
                    end
                end
            end)
            local hold = STEAL_HOLD_DURATION
            pcall(function()
                local hd = prompt.HoldDuration
                if type(hd) == "number" and hd > 0 then
                    hold = math.min(STEAL_HOLD_DURATION, hd + 0.03)
                end
            end)
            
            
            
                if gen ~= _stealHoldGen then
                    
                    data.ready = true
                    return
                end
                local el = tick() - _stealHoldStart
                
                
                
                
                
                local ragLeft = 0
                if _G.MynxxStealDuringRagdoll ~= false then
                    local rt = LP:GetAttribute("RagdollEndTime")
                    if rt then ragLeft = rt - workspace:GetServerTimeNow() end
                end
                if el >= hold and (ragLeft <= 0 or el > hold + 40) then break end
                setStealBarPct(math.min(el / hold, 1))
                RunService.Heartbeat:Wait()
            end
            if gen ~= _stealHoldGen then
                data.ready = true
                return
            end
            setStealBarPct(1)
            if prompt and prompt.Parent then
                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
            end
            for _, fn in ipairs(data.holdEndCallbacks) do task.spawn(fn) end

            if gen == _stealHoldGen then
                _stealHoldActive = false
                _holdPrompt, _holdTargetUid = nil, nil
            end
            task.wait(0.05)
            data.ready = true
            task.wait(0.2)
            if gen == _stealHoldGen then hideStealBar() end
        end)
        
        task.delay(STEAL_HOLD_DURATION + 0.6, function()
            if gen == _stealHoldGen then hideStealBar() end
        end)
    end

    local function timeUntilCanSteal()
        
        
        
        
        if LP:GetAttribute("Stealing") or LP:GetAttribute("IsTrading")
            or LP:GetAttribute("IsDuelSelecting") then
            return -1
        end
        local ragdoll = LP:GetAttribute("RagdollEndTime")
            local r = ragdoll - workspace:GetServerTimeNow()
            if r > 0 then return r end
        end
        return 0
    end

    local stealOn = (_G.MynxxStealMode ~= nil)
    RunService.Heartbeat:Connect(function()
        local now = os.clock()
        
        
        
        
        local _lockUid = _G.MynxxStealTargetUID
        local _lockChanged = (type(_lockUid) == "string" and _lockUid ~= "" and _lockUid ~= _lastPickUid)
        
        
        
        local _pickInterval = (_G.MynxxStealMode == "nearest") and 0.08 or 1.5
        local _needPick = (not _stealTarget) or _lockChanged or (now - _lastTargetPick) >= _pickInterval
        
        if _stealHoldActive and _G.MynxxStealMode ~= "nearest" and not _lockChanged then
            _needPick = false
        end
        if not LP:GetAttribute("Stealing") and _needPick and (now - _autoLastScan) >= 0.05 then
            _autoLastScan = now
            _lastTargetPick = now
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local ok, pets = pcall(scanAllPets)
                if ok and pets and #pets > 0 then
                    
                    
                    
                    
                    if type(_lockUid) == "string" and _lockUid ~= "" then
                        for _, p in ipairs(pets) do
                            if not p.conveyor and _petUid(p) == _lockUid then best = p; break end
                        end
                    end
                    if not best and _G.MynxxStealMode == "nearest" then
                        local myPos = hrp.Position
                        local bestD = math.huge
                        for _, p in ipairs(pets) do
                            if not p.conveyor then
                                local d = _nearestDist(p, myPos)
                                if d < bestD then bestD = d; best = p end
                            end
                        end
                        for _, p in ipairs(pets) do if not p.conveyor then best = p; break end end
                    end
                    best = best or pets[1]
                        local newUid = _petUid(best)
                        local oldUid = _stealTarget and _petUid(_stealTarget)
                        local targetChanged = (type(newUid) == "string" and newUid ~= "" and newUid ~= oldUid)
                            or (type(newUid) == "string" and newUid ~= "" and _holdTargetUid and newUid ~= _holdTargetUid)
                        
                        
                            abortStealHold()
                        end
                        _stealTarget = best
                        _stealArmedAt = now
                        _lastPickUid = _lockUid
                        
                        
                        
                        if type(best.name) == "string" and best.name ~= "" then _currentTargetName = best.name end
                        if not _stealHoldActive then hideStealBar() end
                    end
                end
            end
        end
        local pet = _stealTarget
        if _G.MynxxStealHold then return end
        
        
        if now - _stealLastScan < 0.067 then return end
        _stealLastScan = now
        local t = timeUntilCanSteal()
        if t == -1 then return end
        
        
        
        
        
        
        
        
        if _G.MynxxStealDuringRagdoll == false then
            if t > 0 and t > STEAL_HOLD_DURATION then return end
        end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local prompt = findStealPrompt(pet)
        if not prompt or not prompt.Parent then return end
        local ppPos = _promptWorldPos(prompt)
        if ppPos and (hrp.Position - ppPos).Magnitude > STEAL_PROXIMITY then return end
        pcall(function() oldMax = prompt.MaxActivationDistance end)
        pcall(function() prompt.MaxActivationDistance = math.huge end)
        buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then
            executeStealAsync(prompt, pet.name, _petUid(pet))
            showStealBar(pet.name, 1)
            pcall(function() fireproximityprompt(prompt) end)
            task.delay(0.4, hideStealBar)
        end
        pcall(function() if oldMax ~= nil then prompt.MaxActivationDistance = oldMax end end)
    end)

    
        local ESP_COLOR = Color3.fromRGB(210, 150, 255)
        local _espFolder, _espHl, _espBill, _espBeam, _espAtt0, _espAtt1
        local _espUid = nil

        local function clearStealEsp()
            if _espHl then pcall(function() _espHl:Destroy() end) end
            if _espBill then pcall(function() _espBill:Destroy() end) end
            if _espBeam then pcall(function() _espBeam:Destroy() end) end
            if _espAtt0 then pcall(function() _espAtt0:Destroy() end) end
            if _espAtt1 then pcall(function() _espAtt1:Destroy() end) end
            _espHl, _espBill, _espBeam, _espAtt0, _espAtt1 = nil, nil, nil, nil, nil
            _espUid = nil
        end

        local function ensureEspFolder()
            if _espFolder and _espFolder.Parent then return _espFolder end
            local old = workspace:FindFirstChild("MynxxStealESP")
            if old then old:Destroy() end
            _espFolder = Instance.new("Folder")
            _espFolder.Name = "MynxxStealESP"
            _espFolder.Parent = workspace
        end

        local function findEspAdornee(pet)
            if not pet or not pet.plot or not pet.slot then return nil, nil end
            local plots = workspace:FindFirstChild("Plots")
            local plot = plots and plots:FindFirstChild(pet.plot)
            local podiums = plot and plot:FindFirstChild("AnimalPodiums")
            local podium = podiums and podiums:FindFirstChild(tostring(pet.slot))
            if not podium then return nil, nil end
            for _, desc in ipairs(podium:GetDescendants()) do
                if desc:IsA("Model") and desc.Name ~= "Claim" and desc.Name ~= "Base" and desc.Name ~= "Decorations" then
                    local hasMesh = false
                    for _, c in ipairs(desc:GetDescendants()) do
                        if c:IsA("MeshPart") then hasMesh = true; break end
                    end
                        local part = desc.PrimaryPart or desc:FindFirstChildWhichIsA("BasePart", true)
                        if part then return desc, part end
                    end
                end
            end
            local base = podium:FindFirstChild("Base")
            local spawn = base and base:FindFirstChild("Spawn")
            if spawn and spawn:IsA("BasePart") then return podium, spawn end
            local part = podium:FindFirstChildWhichIsA("BasePart", true)
            return podium, part
        end

        local function syncStealEsp()
            if not stealOn or _G.MynxxStealMode == nil then
                clearStealEsp()
                return
            end
            local pet = _stealTarget
                clearStealEsp()
                return
            end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                clearStealEsp()
                return
            end
            local model, part = findEspAdornee(pet)
            if not part or not part.Parent then
                clearStealEsp()
                return
            end
            local uid = _petUid(pet)
            local name = (type(pet.name) == "string" and pet.name ~= "" and pet.name)
                or "TARGET"
            local function fmtMps(v)
                v = tonumber(v) or 0
                if v >= 1e9 then return string.format("$%.1fB/s", v / 1e9) end
                if v >= 1e6 then return string.format("$%.1fM/s", v / 1e6) end
                if v >= 1e3 then return string.format("$%.1fK/s", v / 1e3) end
                return "$" .. tostring(math.floor(v)) .. "/s"
            end
            local moneyTxt = fmtMps(pet.mps)
            if _espUid ~= uid or not _espHl or not _espHl.Parent then
                clearStealEsp()
                _espUid = uid
                local folder = ensureEspFolder()

                local hl = Instance.new("Highlight")
                hl.Name = "StealESP"
                hl.Adornee = model or part
                hl.FillColor = ESP_COLOR
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.6
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = folder
                _espHl = hl

                local bill = Instance.new("BillboardGui")
                bill.Name = "StealESPName"
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 240, 0, 52)
                bill.StudsOffset = Vector3.new(0, 5.5, 0)
                bill.MaxDistance = 500
                bill.Adornee = part
                bill.Parent = folder
                local tl = Instance.new("TextLabel")
                tl.Name = "Title"
                tl.BackgroundTransparency = 1
                tl.Position = UDim2.new(0, 0, 0, 0)
                tl.Size = UDim2.new(1, 0, 0, 26)
                tl.Font = Enum.Font.GothamBold
                tl.TextSize = 20
                tl.TextColor3 = ESP_COLOR
                tl.TextStrokeColor3 = Color3.fromRGB(20, 10, 30)
                tl.TextStrokeTransparency = 0.35
                tl.Text = name
                tl.Parent = bill
                local ml = Instance.new("TextLabel")
                ml.Name = "Money"
                ml.BackgroundTransparency = 1
                ml.Position = UDim2.new(0, 0, 0, 26)
                ml.Size = UDim2.new(1, 0, 0, 24)
                ml.Font = Enum.Font.GothamBold
                ml.TextSize = 16
                ml.TextColor3 = ESP_COLOR
                ml.TextStrokeColor3 = Color3.fromRGB(20, 10, 30)
                ml.TextStrokeTransparency = 0.35
                ml.Text = moneyTxt
                ml.Parent = bill
                _espBill = bill

                local a0 = Instance.new("Attachment")
                a0.Name = "MynxxStealESP_A0"
                a0.Parent = hrp
                local a1 = Instance.new("Attachment")
                a1.Name = "MynxxStealESP_A1"
                a1.Parent = part
                local beam = Instance.new("Beam")
                beam.Name = "StealESP_Line"
                beam.Attachment0 = a0
                beam.Attachment1 = a1
                beam.Color = ColorSequence.new(ESP_COLOR)
                beam.Width0 = 0.18
                beam.Width1 = 0.12
                beam.FaceCamera = true
                beam.LightEmission = 0.85
                beam.Transparency = NumberSequence.new(0.15)
                beam.Segments = 10
                beam.Parent = folder
                _espAtt0, _espAtt1, _espBeam = a0, a1, beam
                if _espAtt0 and _espAtt0.Parent ~= hrp then
                    _espAtt0.Parent = hrp
                end
                if _espAtt1 and _espAtt1.Parent ~= part then
                    _espAtt1.Parent = part
                    if _espBill then _espBill.Adornee = part end
                    if _espHl then _espHl.Adornee = model or part end
                end
                local title = _espBill and _espBill:FindFirstChild("Title")
                if title then title.Text = name end
                local money = _espBill and _espBill:FindFirstChild("Money")
                if money then money.Text = moneyTxt end
            end
        end

        RunService.Heartbeat:Connect(function()
            syncStealEsp()
        end)
    end

    
        local function applyUnwalkAlways(char)
            local hum = char:FindFirstChildOfClass("Humanoid")
            local animator = hum and hum:FindFirstChildOfClass("Animator")
            local animate = char:FindFirstChild("Animate")
            if animate then animate.Disabled = true end
                local ok, tracks = pcall(function() return animator:GetPlayingAnimationTracks() end)
                if ok and tracks then for _, t in ipairs(tracks) do pcall(function() t:Stop(0) end) end end
            end
        end
        local function hook(char)
            task.spawn(function()
                char:WaitForChild("Humanoid", 10); task.wait(0.05)
                for i = 1, 8 do
                    if LP.Character ~= char then break end
                    applyUnwalkAlways(char); task.wait(0.25)
                end
            end)
        end
        if LP.Character then hook(LP.Character) end
        LP.CharacterAdded:Connect(hook)
        local _unwalkLast = 0
        RunService.Heartbeat:Connect(function()
            local now = os.clock()
            if now - _unwalkLast < 1.5 then return end
            _unwalkLast = now
            if LP.Character then applyUnwalkAlways(LP.Character) end
        end)
    end

    local HS = game:GetService("HttpService")
    local UIS = game:GetService("UserInputService")
    local CFG_FILE = "SideTP.json"

    local function loadCfgTable()
        local t = {}
            pcall(function()
                local raw = readfile(CFG_FILE)
                if type(raw) == "string" and #raw > 0 then
                    local ok, d = pcall(HS.JSONDecode, HS, raw)
                    if ok and type(d) == "table" then t = d end
                end
            end)
        end
    end

    local function saveTpSettings()
        local t = loadCfgTable()
        t.tpVelocity = tonumber(_G.TPVelocity) or 400
        t.climbSpeed = tonumber(_G.MynxxClimb) or 160
        t.cframeSpeed = tonumber(_G.MynxxCFrameSpeed) or 450
        t.walkSpeed = tonumber(_G.MynxxWalkSpeed) or 20
        t.landingDelay = tonumber(_G.LandingDelay) or 0.35
        t.closeSpeed = tonumber(_G.MynxxCloseSpeed) or 80
        t.autoTp = _G.MynxxAutoTP ~= false
        t.autoSteal = stealOn
        t.stealMode = _G.MynxxStealMode
        t.nearestKey = _G.MynxxNearestKey
        t.tpKey = _G._stp_tpKeyName
        t.prioritySoundID = _G.MynxxPrioritySoundID
        t.priorityList = _G.SHARED_PRIORITY_ITEMS
        t.priorityDefault = _G.MynxxPriorityDefault
        t.mutationList = _G.SHARED_MUTATION_ITEMS
        t.mutationDefault = _G.MynxxMutationDefault
        t.carpetTool = _G.MynxxCarpetTool

        t.panelX = tonumber(_G._stp_panelX)
        t.panelY = tonumber(_G._stp_panelY)
        t.panelPos = _G._stp_pos
        pcall(function() writefile(CFG_FILE, HS:JSONEncode(t)) end)
    end

    if _G.TPVelocity == nil then _G.TPVelocity = 400 end
    if _G.MynxxClimb == nil then _G.MynxxClimb = 160 end
    if _G.MynxxCFrameSpeed == nil then _G.MynxxCFrameSpeed = 450 end
    if _G.MynxxWalkSpeed == nil then _G.MynxxWalkSpeed = 20 end
    if _G.LandingDelay == nil then _G.LandingDelay = 0.1 end
    if _G.MynxxCloseSpeed == nil then _G.MynxxCloseSpeed = 80 end

    local guiParent = (gethui and gethui()) or game:GetService("CoreGui") or PG
    pcall(function()
        local old = guiParent:FindFirstChild("TPStealTestUI")
        if old then old:Destroy() end
        local old2 = PG:FindFirstChild("TPStealTestUI")
        if old2 then old2:Destroy() end
    end)

    local sg = Instance.new("ScreenGui")
    sg.Name = "TPStealTestUI"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999999
    sg.IgnoreGuiInset = true
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = PG end

    
    
    _G._stp_pos = _G._stp_pos or {}
    local function _storePos(savePos, target)
        
        
        if savePos == true then
            _G._stp_panelX = target.Position.X.Offset
            _G._stp_panelY = target.Position.Y.Offset
        elseif type(savePos) == "string" then
            _G._stp_pos[savePos] = {
                x = target.Position.X.Offset,
                y = target.Position.Y.Offset,
            }
            return
        end
        saveTpSettings()
    end
    
    
    local function _restorePos(key, target, dx, dy)
        
        _G.MynxxCenterPanel(target)
    end

    local function makeDraggable(handle, target, savePos)
        handle.Active = true
        local dragging, dragStart, startX, startY
        handle.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging = true
            dragStart = input.Position
            
            startX = target.Position.X.Offset
            startY = target.Position.Y.Offset
        end)
        handle.InputEnded:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging = false
            _storePos(savePos, target)
        end)
        UIS.InputChanged:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = input.Position - dragStart
            if _G.XyntrixDragTo then
                _G.XyntrixDragTo(target, startX, startY, d.X, d.Y)
                target.Position = UDim2.fromOffset(startX + d.X, startY + d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    _storePos(savePos, target)
                end
            end
        end)
    end

    local f = Instance.new("Frame", sg)
    f.Name = "Main"
    f.Active = true
    f.Size = UDim2.fromOffset(250, 180)
    f.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        _G.MynxxCenterPanel(f, 200, 168)
    end

    
    local title = Instance.new("TextButton", f)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "Xyntrix · Teleport"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 14
    title.TextColor3 = Color3.new(1, 1, 1)
    title.AutoButtonColor = false
    title.Active = true
    pcall(_G.XyntrixStylePanel, f)
    pcall(_G.XyntrixStyleTitle, title)
    task.defer(_G.XyntrixPolish, f)
    makeDraggable(title, f, true)
    
    
    
    makeDraggable(f, f, true)

    local function btn(txt, y, parent, fn)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, -20, 0, 28)
        b.Position = UDim2.new(0, 10, 0, y)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.Text = txt
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.Active = true
        b.AutoButtonColor = true
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(fn)
    end

    local manualBtn = btn("MANUAL TP", 38, f, function()
        task.spawn(function()
            local n = diag()
            if n == 0 then notify("TP FAIL", "0 pets - sync?"); return end
            if _G.MynxxStartSideTP then pcall(_G.MynxxStartSideTP)
            else pcall(doVelocityTP, true) end
        end)
    end)
    
    
        if type(_G._stp_tpKeyName) ~= "string" or _G._stp_tpKeyName == "" then _G._stp_tpKeyName = "Key:T" end
        manualBtn.Size = UDim2.new(1, -60, 0, 28)
        local keyBtn = Instance.new("TextButton", f)
        keyBtn.Size = UDim2.new(0, 34, 0, 28)
        keyBtn.Position = UDim2.new(1, -44, 0, 38)
        keyBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        keyBtn.TextColor3 = Color3.new(1, 1, 1)
        keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 10
        keyBtn.Text = (_G._stpBindPretty and _G._stpBindPretty(_G._stp_tpKeyName)) or _G._stp_tpKeyName
        keyBtn.AutoButtonColor = true
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)
        keyBtn.MouseButton1Click:Connect(function()
            if not _G._stpListenBind then return end
            keyBtn.Text = "..."; keyBtn.BackgroundColor3 = Color3.fromRGB(120, 90, 30)
            _G._stpListenBind(
                function(b) _G._stp_tpKeyName = b end,
                function()
                    keyBtn.Text = _G._stpBindPretty(_G._stp_tpKeyName)
                    keyBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                    pcall(saveTpSettings)
                end)
        end)
    end
    local priBtn, nearBtn, openPriorityEditor
    local function _refreshStealBtns()
        local m = stealOn and _G.MynxxStealMode or nil
            priBtn.Text = "PRIORITY: " .. (m == "priority" and "ON" or "OFF")
            priBtn.BackgroundColor3 = (m == "priority") and Color3.fromRGB(45, 130, 255) or Color3.fromRGB(40, 40, 40)
        end
            nearBtn.Text = "NEAREST: " .. (m == "nearest" and "ON" or "OFF")
            nearBtn.BackgroundColor3 = (m == "nearest") and Color3.fromRGB(45, 130, 255) or Color3.fromRGB(40, 40, 40)
        end
    end
    local function _setStealMode(mode)
        if mode == "nearest" then
            
            
            if stealOn and _G.MynxxStealMode == "nearest" then
                stealOn = true
                _G.MynxxStealMode = "priority"
                stealOn = true
                _G.MynxxStealMode = "nearest"
            end
            
            if stealOn and _G.MynxxStealMode == mode then
                stealOn = false
                _G.MynxxStealMode = nil
                stealOn = true
                _G.MynxxStealMode = mode
            end
        end
        _refreshStealBtns()
        saveTpSettings()
        notify("AUTO STEAL", stealOn and string.upper(_G.MynxxStealMode) or "OFF")
    end
    priBtn = btn("PRIORITY: OFF", 72, f, function() _setStealMode("priority") end)
    
        priBtn.Size = UDim2.new(1, -60, 0, 28)
        local gear = Instance.new("TextButton", f)
        gear.Size = UDim2.fromOffset(34, 28)
        gear.Position = UDim2.new(1, -44, 0, 72)
        gear.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
        gear.Text = "\u{2699}"
        gear.TextColor3 = Color3.new(1, 1, 1)
        gear.Font = Enum.Font.GothamBold
        gear.TextSize = 16
        gear.AutoButtonColor = true
        Instance.new("UICorner", gear).CornerRadius = UDim.new(0, 6)
        gear.MouseButton1Click:Connect(function()
            if openPriorityEditor then openPriorityEditor() end
        end)
    end
    nearBtn = btn("NEAREST: OFF", 106, f, function() _setStealMode("nearest") end)
    
    
        _G._stpFireNearKey = function() _setStealMode("nearest") end
        if type(_G.MynxxNearestKey) ~= "string" or _G.MynxxNearestKey == "" then _G.MynxxNearestKey = "Key:N" end
        nearBtn.Size = UDim2.new(1, -60, 0, 28)
        local keyBtn = Instance.new("TextButton", f)
        keyBtn.Size = UDim2.new(0, 34, 0, 28)
        keyBtn.Position = UDim2.new(1, -44, 0, 106)
        keyBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        keyBtn.TextColor3 = Color3.new(1, 1, 1)
        keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 10
        keyBtn.Text = (_G._stpBindPretty and _G._stpBindPretty(_G.MynxxNearestKey)) or _G.MynxxNearestKey
        keyBtn.AutoButtonColor = true
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)
        
        keyBtn.MouseButton1Click:Connect(function()
            if not _G._stpListenBind then return end
            keyBtn.Text = "..."; keyBtn.BackgroundColor3 = Color3.fromRGB(120, 90, 30)
            _G._stpListenBind(
                function(b) _G.MynxxNearestKey = b end,
                function()
                    keyBtn.Text = _G._stpBindPretty(_G.MynxxNearestKey)
                    keyBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                    pcall(saveTpSettings)
                end)
        end)
        
        UIS.InputBegan:Connect(function(input, gp)
            if gp or _G._stp_listening then return end
            local nk = _G.MynxxNearestKey
            if not nk or _G._stpBindIsSide(nk, 4) or _G._stpBindIsSide(nk, 5) then return end
            if _G._stpInputMatches(input, nk) then _setStealMode("nearest") end
        end)
    end
    _refreshStealBtns()

    local function makeSettingRow(parent, label, y, min, max, getV, setV, step)
        step = step or 1
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, -16, 0, 44)
        row.Position = UDim2.new(0, 8, 0, y)
        row.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        row.Active = true
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -90, 0, 18)
        lbl.Position = UDim2.new(0, 8, 0, 2)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local hit = Instance.new("TextButton", row)
        hit.Size = UDim2.new(1, -16, 0, 16)
        hit.Position = UDim2.new(0, 8, 0, 22)
        hit.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        hit.Text = ""
        hit.AutoButtonColor = false
        hit.Active = true
        Instance.new("UICorner", hit).CornerRadius = UDim.new(0, 4)

        local fill = Instance.new("Frame", hit)
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

        local function fmt(v)
            if step < 1 then return string.format("%.2f", v) end
            return tostring(math.floor(v + 0.5))
        end

        local function refresh()
            local v = math.clamp(tonumber(getV()) or min, min, max)
            local rel = (v - min) / math.max(max - min, 1e-6)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            lbl.Text = label .. ": " .. fmt(v)
        end

        local function applyAt(x)
            local rel = math.clamp((x - hit.AbsolutePosition.X) / math.max(hit.AbsoluteSize.X, 1), 0, 1)
            local v = min + (max - min) * rel
            v = math.floor(v / step + 0.5) * step
            v = math.clamp(v, min, max)
            setV(v)
            refresh()
        end

        local sliding = false
        hit.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                applyAt(input.Position.X)
            end
        end)
        hit.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                if sliding then sliding = false; saveTpSettings(); notify(label, fmt(getV())) end
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                applyAt(input.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                if sliding then sliding = false; saveTpSettings() end
            end
        end)

        local minus = Instance.new("TextButton", row)
        minus.Size = UDim2.fromOffset(28, 18)
        minus.Position = UDim2.new(1, -68, 0, 2)
        minus.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        minus.Text = "-"
        minus.TextColor3 = Color3.new(1, 1, 1)
        minus.Font = Enum.Font.GothamBold
        minus.TextSize = 14
        Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 4)
        minus.MouseButton1Click:Connect(function()
            local v = math.clamp((tonumber(getV()) or min) - step, min, max)
            setV(v); refresh(); saveTpSettings(); notify(label, fmt(v))
        end)

        local plus = Instance.new("TextButton", row)
        plus.Size = UDim2.fromOffset(28, 18)
        plus.Position = UDim2.new(1, -34, 0, 2)
        plus.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        plus.Text = "+"
        plus.TextColor3 = Color3.new(1, 1, 1)
        plus.Font = Enum.Font.GothamBold
        plus.TextSize = 14
        Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 4)
        plus.MouseButton1Click:Connect(function()
            local v = math.clamp((tonumber(getV()) or min) + step, min, max)
            setV(v); refresh(); saveTpSettings(); notify(label, fmt(v))
        end)

        refresh()
    end

    local function openSettings()
        if settingsPanel and settingsPanel.Parent then
            settingsPanel.Visible = not settingsPanel.Visible
            
            
            if settingsPanel.Visible then
                _G.MynxxCenterPanel(settingsPanel, 220, 320)
            end
            return
        end
        settingsPanel = Instance.new("Frame", sg)
        settingsPanel.Name = "TPSettings"
        settingsPanel.Active = true
        settingsPanel.Size = UDim2.fromOffset(_G.MynxxIsMobile and 220 or 270, _G.MynxxIsMobile and 320 or 400)
        settingsPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
        settingsPanel.BorderSizePixel = 0
        Instance.new("UICorner", settingsPanel).CornerRadius = UDim.new(0, 10)
        _restorePos("settings", settingsPanel,
            f.AbsolutePosition.X + f.AbsoluteSize.X + 10, f.AbsolutePosition.Y)
        pcall(_G.XyntrixStylePanel, settingsPanel)

        
        local st = Instance.new("TextButton", settingsPanel)
        st.Size = UDim2.new(1, 0, 0, 30)
        st.BackgroundTransparency = 1
        st.Text = "Xyntrix · TP Settings"
        st.Font = Enum.Font.GothamBlack
        pcall(_G.XyntrixStyleTitle, st)
        task.defer(_G.XyntrixPolish, settingsPanel)
        st.TextSize = 13
        st.TextColor3 = Color3.new(1, 1, 1)
        st.AutoButtonColor = false
        st.Active = true
        makeDraggable(st, settingsPanel, "settings")

        makeSettingRow(settingsPanel, "TP Velocity", 38, 200, 750,
            function() return _G.TPVelocity end, function(v) _G.TPVelocity = v end, 5)
        makeSettingRow(settingsPanel, "Climb Speed", 86, 100, 250,
            function() return _G.MynxxClimb end, function(v) _G.MynxxClimb = v end, 5)
        makeSettingRow(settingsPanel, "CFrame Speed", 134, 100, 900,
            function() return _G.MynxxCFrameSpeed end, function(v) _G.MynxxCFrameSpeed = v end, 10)
        makeSettingRow(settingsPanel, "Clone Delay", 182, 0.05, 0.75,
            function() return _G.LandingDelay end, function(v) _G.LandingDelay = v end, 0.05)
        
        makeSettingRow(settingsPanel, "100 Studs Base Speed", 230, 20, 400,
            function() return _G.MynxxCloseSpeed end, function(v) _G.MynxxCloseSpeed = v end, 5)

        autoBtn = btn("AUTO TP: " .. ((_G.MynxxAutoTP ~= false) and "ON" or "OFF"), 278, settingsPanel, function()
            _G.MynxxAutoTP = not (_G.MynxxAutoTP ~= false)
            autoBtn.Text = "AUTO TP: " .. ((_G.MynxxAutoTP ~= false) and "ON" or "OFF")
            saveTpSettings()
            notify("AUTO TP", (_G.MynxxAutoTP ~= false) and "ON" or "OFF")
        end)

        
        
        
        
        local TP_TOOLS = { "Flying Carpet", "Cupid's Wings", "Santa's Sleigh", "Witch's Broom", "Waverider" }
        local function _curTPTool()
            local c = _G.MynxxCarpetTool
            if type(c) == "string" and c ~= "" then return c end
            return TP_TOOLS[1]
        end
        toolBtn = btn("TP TOOL: " .. _curTPTool(), 314, settingsPanel, function()
            local cur, idx = _curTPTool(), 1
            for i, n in ipairs(TP_TOOLS) do if n == cur then idx = i; break end end
            local nextTool = TP_TOOLS[(idx % #TP_TOOLS) + 1]
            if _G.MynxxSetCarpetTool then pcall(_G.MynxxSetCarpetTool, nextTool)
            else _G.MynxxCarpetTool = nextTool end
            toolBtn.Text = "TP TOOL: " .. nextTool
            saveTpSettings()
            notify("TP TOOL", nextTool)
        end)

        
        
        local soundBox = Instance.new("TextBox", settingsPanel)
        soundBox.Size = UDim2.new(1, -20, 0, 28)
        soundBox.Position = UDim2.new(0, 10, 0, 350)
        soundBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        soundBox.TextColor3 = Color3.new(1, 1, 1)
        soundBox.PlaceholderText = "Priority Sound ID..."
        soundBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        soundBox.Text = tostring(_G.MynxxPrioritySoundID or "")
        soundBox.Font = Enum.Font.Gotham
        soundBox.TextSize = 12
        soundBox.ClearTextOnFocus = false
        Instance.new("UICorner", soundBox).CornerRadius = UDim.new(0, 6)
        local sbpad = Instance.new("UIPadding", soundBox)
        sbpad.PaddingLeft = UDim.new(0, 8); sbpad.PaddingRight = UDim.new(0, 8)
        soundBox.FocusLost:Connect(function()
            _G.MynxxPrioritySoundID = soundBox.Text
            saveTpSettings()
            notify("SOUND ID", (soundBox.Text ~= "" and soundBox.Text) or "cleared")
        end)
    end

    
    
    
    
    
    
        pcall(function()
            local _old = guiParent:FindFirstChild("MynxxStealTargetUI")
            if _old then _old:Destroy() end
        end)
        local stg = Instance.new("ScreenGui")
        stg.Name = "MynxxStealTargetUI"
        stg.ResetOnSpawn = false
        stg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() stg.Parent = guiParent end)

        local stealTargetPanel = Instance.new("Frame", stg)
        stealTargetPanel.Name = "StealTarget"
        stealTargetPanel.Active = true
        stealTargetPanel.Size = UDim2.fromOffset(_G.MynxxIsMobile and 220 or 262, _G.MynxxIsMobile and 300 or 360)
        stealTargetPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
        stealTargetPanel.BorderSizePixel = 0
        Instance.new("UICorner", stealTargetPanel).CornerRadius = UDim.new(0, 10)
        _restorePos("stealtarget", stealTargetPanel, 300, 200)
        pcall(_G.XyntrixStylePanel, stealTargetPanel)

        local pt = Instance.new("TextButton", stealTargetPanel)
        pt.Size = UDim2.new(1, 0, 0, 30)
        pt.BackgroundTransparency = 1
        pt.Text = "Xyntrix · Steal Target"
        pcall(_G.XyntrixStyleTitle, pt)
        task.defer(_G.XyntrixPolish, stealTargetPanel)
        pt.Font = Enum.Font.GothamBlack
        pt.TextSize = 13
        pt.TextColor3 = Color3.new(1, 1, 1)
        pt.AutoButtonColor = false
        pt.Active = true
        makeDraggable(pt, stealTargetPanel, "stealtarget")
        makeDraggable(stealTargetPanel, stealTargetPanel, "stealtarget")

        local scroll = Instance.new("ScrollingFrame", stealTargetPanel)
        scroll.Size = UDim2.new(1, -12, 1, -42)
        scroll.Position = UDim2.new(0, 6, 0, 36)
        scroll.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 5
        scroll.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 90)
        scroll.CanvasSize = UDim2.new()
        Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)
        local layout = Instance.new("UIListLayout", scroll)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 3)
        local spad = Instance.new("UIPadding", scroll)
        spad.PaddingTop = UDim.new(0, 4); spad.PaddingBottom = UDim.new(0, 4)
        spad.PaddingLeft = UDim.new(0, 4); spad.PaddingRight = UDim.new(0, 4)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
        end)

        local function fmtVal(v)
            v = tonumber(v) or 0
            if v >= 1e9 then return string.format("%.1fB", v / 1e9) end
            if v >= 1e6 then return string.format("%.1fM", v / 1e6) end
            if v >= 1e3 then return string.format("%.1fK", v / 1e3) end
            return tostring(math.floor(v))
        end

        
        
        
        
        local rowByUid, lastSig = {}, nil

        local function applyHighlight()
            local locked = _G.MynxxStealTargetUID
            for uid, row in pairs(rowByUid) do
                if row.Parent then
                    row.BackgroundColor3 = (uid == locked) and Color3.fromRGB(30, 70, 45) or Color3.fromRGB(28, 28, 28)
                end
            end
        end

        local function rebuild(pets)
            for _, c in ipairs(scroll:GetChildren()) do
                if c:IsA("Frame") then c:Destroy() end
            end
            rowByUid = {}
            for i, p in ipairs(pets) do
                local uid = _petUid(p)
                local row = Instance.new("Frame", scroll)
                row.Size = UDim2.new(1, -4, 0, 32)
                row.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                row.BorderSizePixel = 0
                row.LayoutOrder = i
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
                rowByUid[uid] = row

                local rank = Instance.new("TextLabel", row)
                rank.Size = UDim2.fromOffset(30, 32)
                rank.BackgroundTransparency = 1
                rank.Font = Enum.Font.GothamBold
                rank.TextSize = 10
                rank.TextColor3 = p._pri and Color3.fromRGB(255, 120, 140) or Color3.fromRGB(120, 200, 140)
                rank.Text = "#" .. i

                local nm = Instance.new("TextLabel", row)
                nm.Size = UDim2.new(1, -36, 0, 16)
                nm.Position = UDim2.fromOffset(34, 3)
                nm.BackgroundTransparency = 1
                nm.Font = Enum.Font.GothamBold
                nm.TextSize = 12
                nm.TextColor3 = Color3.new(1, 1, 1)
                nm.TextXAlignment = Enum.TextXAlignment.Left
                nm.TextTruncate = Enum.TextTruncate.AtEnd
                nm.Text = p.name or "?"

                local sub = Instance.new("TextLabel", row)
                sub.Size = UDim2.new(1, -36, 0, 12)
                sub.Position = UDim2.fromOffset(34, 18)
                sub.BackgroundTransparency = 1
                sub.Font = Enum.Font.Gotham
                sub.TextSize = 11
                sub.TextColor3 = Color3.fromRGB(120, 210, 150)
                sub.TextXAlignment = Enum.TextXAlignment.Left
                sub.Text = fmtVal(p.mps) .. "/s" .. ((p.mutation and p.mutation ~= "None") and ("  " .. p.mutation) or "")

                local click = Instance.new("TextButton", row)
                click.Size = UDim2.new(1, 0, 1, 0)
                click.BackgroundTransparency = 1
                click.Text = ""
                click.MouseButton1Click:Connect(function()
                    if _G.MynxxStealTargetUID == uid then
                        _clearTPSync()
                        notify("TARGET", "cleared")
                        _G.MynxxStealTargetUID = uid
                        _G.MynxxStealTarget = p
                        _G.MynxxTPSyncActive = true
                        notify("TARGET", p.name or "?")
                    end
                    applyHighlight()
                end)
            end
        end

        local function refresh()
            if not (stealTargetPanel and stealTargetPanel.Visible) then return end
            local ok, pets = pcall(scanAllPets)
            if not ok or type(pets) ~= "table" then return end
            local locked, stillThere, sig = _G.MynxxStealTargetUID, false, ""
            for _, p in ipairs(pets) do
                local u = _petUid(p)
                sig = sig .. u .. "|"
                if u == locked then stillThere = true end
            end
            
            if locked and locked ~= "" and not stillThere then _clearTPSync() end
            if sig ~= lastSig then lastSig = sig; rebuild(pets) end
            applyHighlight()
        end

        task.spawn(function()
            while stealTargetPanel and stealTargetPanel.Parent do
                pcall(refresh)
                task.wait(0.4)
            end
        end)
    end

    
    
    
    
    
    
    openPriorityEditor = function()
        if priorityPanel and priorityPanel.Parent then
            priorityPanel.Visible = not priorityPanel.Visible
            if priorityPanel.Visible then
                _G.MynxxCenterPanel(priorityPanel, 220, 300)
            end
            return
        end

        local function _pnorm(s) return tostring(s):lower():gsub("[%s%-_'%.]", "") end

        
        
        local currentTab = "brainrot"
        local function activeShared()
            if currentTab == "mutation" then
                if type(_G.SHARED_MUTATION_ITEMS) ~= "table" then _G.SHARED_MUTATION_ITEMS = {} end
                return _G.SHARED_MUTATION_ITEMS
            end
            if type(_G.SHARED_PRIORITY_ITEMS) ~= "table" then _G.SHARED_PRIORITY_ITEMS = {} end
            return _G.SHARED_PRIORITY_ITEMS
        end
        local function activeDefault()
            if currentTab == "mutation" then return _G.MynxxMutationDefault or {} end
            return _G.MynxxPriorityDefault or {}
        end

        
        local function getList()
            local L = activeShared()
            if #L == 0 then
                local d = activeDefault()
                for i = 1, #d do L[i] = d[i] end
            end
        end
        local function commit()
            if currentTab == "mutation" then
                _G.MynxxMutVersion = (_G.MynxxMutVersion or 0) + 1
                _G.MynxxPriVersion = (_G.MynxxPriVersion or 0) + 1
            end
            saveTpSettings()
        end
        
        
        local function setList(newList, alsoDefault)
            local L = getList()
            table.clear(L)
            local seen = {}
            for _, v in ipairs(newList) do
                if type(v) == "string" then
                    local s = v:gsub("^%s+", ""):gsub("%s+$", ""):lower()
                    local k = _pnorm(s)
                    if s ~= "" and not seen[k] then seen[k] = true; L[#L + 1] = s end
                end
            end
                local d = {}
                for i = 1, #L do d[i] = L[i] end
                if currentTab == "mutation" then _G.MynxxMutationDefault = d
                else _G.MynxxPriorityDefault = d end
            end
            commit()
        end
        
        local function parseList(text)
            if type(text) ~= "string" or text == "" then return nil end
            local out = {}
            local ok, dec = pcall(function() return HS:JSONDecode(text) end)
            if ok and type(dec) == "table" then
                for _, v in ipairs(dec) do
                    if type(v) == "string" and v ~= "" then out[#out + 1] = v end
                end
                if #out > 0 then return out end
            end
            for s in text:gmatch('"([^"]*)"') do
                if s ~= "" then out[#out + 1] = s end
            end
            if #out > 0 then return out end
            for s in text:gmatch("[^,\r\n]+") do
                s = s:gsub("^%s+", ""):gsub("%s+$", "")
                if s ~= "" then out[#out + 1] = s end
            end
            return (#out > 0) and out or nil
        end
        local function getClip()
            for _, fn in ipairs({ getclipboard, get_clipboard, getrbxclipboard }) do
                if type(fn) == "function" then
                    local ok, r = pcall(fn)
                    if ok and type(r) == "string" and r ~= "" then return r end
                end
            end
        end
        
        
        local _suggCache = {}
        local function suggestions()
            if _suggCache[currentTab] then return _suggCache[currentTab] end
            local set, out = {}, {}
            local function add(n)
                if type(n) == "string" and n ~= "" then
                    local k = n:lower()
                    if not set[k] then set[k] = true; out[#out + 1] = k end
                end
            end
            if currentTab == "mutation" then
                
                for _, n in ipairs(_G.MynxxMutationDefault or {}) do add(n) end
                for _, n in ipairs(_G.MynxxPriorityDefault or {}) do add(n) end
                pcall(function()
                    local Datas = RS:FindFirstChild("Datas")
                    local A = Datas and Datas:FindFirstChild("Animals")
                    local data = require(A)
                    if type(data) ~= "table" then return end
                    for key, info in pairs(data) do
                        if type(info) == "table" then add(info.DisplayName or key)
                        elseif type(key) == "string" then add(key) end
                    end
                end)
            end
            table.sort(out)
            _suggCache[currentTab] = out
        end

        
        local rebuild, addItem, refreshSuggestions, hideSuggestions
        local switchTab, refreshTabs
        local tabBrainrot, tabMutation

        priorityPanel = Instance.new("Frame", sg)
        priorityPanel.Name = "PriorityList"
        priorityPanel.Active = true
        priorityPanel.Size = UDim2.fromOffset(_G.MynxxIsMobile and 220 or 262, _G.MynxxIsMobile and 300 or 360)
        priorityPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
        priorityPanel.BorderSizePixel = 0
        Instance.new("UICorner", priorityPanel).CornerRadius = UDim.new(0, 10)
        _restorePos("priority", priorityPanel,
            f.AbsolutePosition.X + f.AbsoluteSize.X + 10, f.AbsolutePosition.Y)
        pcall(_G.XyntrixStylePanel, priorityPanel)
        task.defer(_G.XyntrixPolish, priorityPanel)

        
        local pt = Instance.new("TextButton", priorityPanel)
        pt.Size = UDim2.new(1, 0, 0, 30)
        pt.BackgroundTransparency = 1
        pt.Text = "Xyntrix · Priority"
        pt.Font = Enum.Font.GothamBlack
        pt.TextSize = 13
        pt.TextColor3 = Color3.new(1, 1, 1)
        pt.AutoButtonColor = false
        pt.Active = true
        makeDraggable(pt, priorityPanel, "priority")
        
        
        makeDraggable(priorityPanel, priorityPanel, "priority")

        
        tabBrainrot = Instance.new("TextButton", priorityPanel)
        tabBrainrot.Size = UDim2.new(0.5, -10, 0, 22)
        tabBrainrot.Position = UDim2.fromOffset(8, 32)
        tabBrainrot.Font = Enum.Font.GothamBold; tabBrainrot.TextSize = 11
        tabBrainrot.TextColor3 = Color3.new(1, 1, 1); tabBrainrot.BorderSizePixel = 0
        tabBrainrot.Text = "BRAINROT"
        Instance.new("UICorner", tabBrainrot).CornerRadius = UDim.new(0, 5)
        tabMutation = Instance.new("TextButton", priorityPanel)
        tabMutation.Size = UDim2.new(0.5, -10, 0, 22)
        tabMutation.Position = UDim2.new(0.5, 2, 0, 32)
        tabMutation.Font = Enum.Font.GothamBold; tabMutation.TextSize = 11
        tabMutation.TextColor3 = Color3.new(1, 1, 1); tabMutation.BorderSizePixel = 0
        tabMutation.Text = "MUTATIONS"
        Instance.new("UICorner", tabMutation).CornerRadius = UDim.new(0, 5)
        refreshTabs = function()
            tabBrainrot.BackgroundColor3 = (currentTab == "brainrot") and Color3.fromRGB(45, 130, 255) or Color3.fromRGB(40, 40, 40)
            tabMutation.BackgroundColor3 = (currentTab == "mutation") and Color3.fromRGB(45, 130, 255) or Color3.fromRGB(40, 40, 40)
        end

        
        local box = Instance.new("TextBox", priorityPanel)
        box.Size = UDim2.new(1, -74, 0, 26)
        box.Position = UDim2.new(0, 8, 0, 62)
        box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        box.TextColor3 = Color3.new(1, 1, 1)
        box.PlaceholderText = "add a brainrot..."
        box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        box.Text = ""
        box.Font = Enum.Font.Gotham
        box.TextSize = 12
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.ClearTextOnFocus = false
        box.ClipsDescendants = true
        box.ZIndex = 3
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        local bpad = Instance.new("UIPadding", box)
        bpad.PaddingLeft = UDim.new(0, 6); bpad.PaddingRight = UDim.new(0, 6)

        local addBtn = Instance.new("TextButton", priorityPanel)
        addBtn.Size = UDim2.fromOffset(56, 26)
        addBtn.Position = UDim2.new(1, -64, 0, 62)
        addBtn.BackgroundColor3 = Color3.fromRGB(30, 90, 45)
        addBtn.Text = "ADD"
        addBtn.TextColor3 = Color3.new(1, 1, 1)
        addBtn.Font = Enum.Font.GothamBold
        addBtn.TextSize = 12
        addBtn.ZIndex = 3
        Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 6)

        
        local sugFrame = Instance.new("Frame", priorityPanel)
        sugFrame.Position = UDim2.new(0, 8, 0, 90)
        sugFrame.Size = UDim2.new(1, -74, 0, 0)
        sugFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        sugFrame.BorderSizePixel = 0
        sugFrame.Visible = false
        sugFrame.ZIndex = 5
        sugFrame.ClipsDescendants = true
        Instance.new("UICorner", sugFrame).CornerRadius = UDim.new(0, 6)
        local sugLayout = Instance.new("UIListLayout", sugFrame)
        sugLayout.SortOrder = Enum.SortOrder.LayoutOrder

        hideSuggestions = function()
            sugFrame.Visible = false
            for _, c in ipairs(sugFrame:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
        end
        refreshSuggestions = function()
            for _, c in ipairs(sugFrame:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            local q = _pnorm(box.Text)
            if q == "" then sugFrame.Visible = false; return end
            local src = suggestions()
            local n, MAX = 0, 6
            for _, name in ipairs(src) do
                if _pnorm(name):find(q, 1, true) then
                    n = n + 1
                    local b = Instance.new("TextButton", sugFrame)
                    b.Size = UDim2.new(1, 0, 0, 22)
                    b.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                    b.AutoButtonColor = true
                    b.Text = "  " .. name
                    b.TextXAlignment = Enum.TextXAlignment.Left
                    b.TextColor3 = Color3.fromRGB(220, 220, 220)
                    b.Font = Enum.Font.Gotham
                    b.TextSize = 12
                    b.ZIndex = 6
                    b.LayoutOrder = n
                    b.MouseButton1Click:Connect(function()
                        box.Text = name
                        hideSuggestions()
                        addItem()
                    end)
                    if n >= MAX then break end
                end
            end
            if n == 0 then sugFrame.Visible = false
            else sugFrame.Visible = true; sugFrame.Size = UDim2.new(1, -74, 0, n * 22) end
        end

        
        local countLbl = Instance.new("TextLabel", priorityPanel)
        countLbl.Size = UDim2.new(0, 60, 0, 24)
        countLbl.Position = UDim2.new(0, 10, 1, -30)
        countLbl.BackgroundTransparency = 1
        countLbl.Font = Enum.Font.Gotham
        countLbl.TextSize = 11
        countLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
        countLbl.TextXAlignment = Enum.TextXAlignment.Left

        local importBtn = Instance.new("TextButton", priorityPanel)
        importBtn.Size = UDim2.fromOffset(78, 24)
        importBtn.Position = UDim2.new(1, -162, 1, -30)
        importBtn.BackgroundColor3 = Color3.fromRGB(40, 70, 110)
        importBtn.Text = "IMPORT"
        importBtn.TextColor3 = Color3.new(1, 1, 1)
        importBtn.Font = Enum.Font.GothamBold
        importBtn.TextSize = 11
        Instance.new("UICorner", importBtn).CornerRadius = UDim.new(0, 6)

        local resetBtn = Instance.new("TextButton", priorityPanel)
        resetBtn.Size = UDim2.fromOffset(72, 24)
        resetBtn.Position = UDim2.new(1, -80, 1, -30)
        resetBtn.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
        resetBtn.Text = "RESET"
        resetBtn.TextColor3 = Color3.new(1, 1, 1)
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 11
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)

        local scroll = Instance.new("ScrollingFrame", priorityPanel)
        scroll.Size = UDim2.new(1, -12, 1, -132)
        scroll.Position = UDim2.new(0, 6, 0, 94)
        scroll.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 5
        scroll.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 90)
        scroll.CanvasSize = UDim2.new()
        Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)
        local layout = Instance.new("UIListLayout", scroll)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 3)
        local spad = Instance.new("UIPadding", scroll)
        spad.PaddingTop = UDim.new(0, 4); spad.PaddingBottom = UDim.new(0, 4)
        spad.PaddingLeft = UDim.new(0, 4); spad.PaddingRight = UDim.new(0, 4)
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
        end)

        rebuild = function()
            for _, c in ipairs(scroll:GetChildren()) do
                if c:IsA("Frame") then c:Destroy() end
            end
            local list = getList()
            countLbl.Text = #list .. " items"
            for i, name in ipairs(list) do
                local row = Instance.new("Frame", scroll)
                row.Size = UDim2.new(1, -4, 0, 26)
                row.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                row.BorderSizePixel = 0
                row.LayoutOrder = i
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

                local rank = Instance.new("TextLabel", row)
                rank.Size = UDim2.fromOffset(26, 26)
                rank.BackgroundTransparency = 1
                rank.Font = Enum.Font.GothamBold
                rank.TextSize = 10
                rank.TextColor3 = Color3.fromRGB(120, 200, 140)
                rank.Text = tostring(i)

                local nm = Instance.new("TextLabel", row)
                nm.Size = UDim2.new(1, -112, 1, 0)
                nm.Position = UDim2.fromOffset(28, 0)
                nm.BackgroundTransparency = 1
                nm.Font = Enum.Font.Gotham
                nm.TextSize = 11
                nm.TextColor3 = Color3.new(1, 1, 1)
                nm.TextXAlignment = Enum.TextXAlignment.Left
                nm.TextTruncate = Enum.TextTruncate.AtEnd
                nm.Text = name

                local function miniBtn(txt, xoff, col)
                    local b = Instance.new("TextButton", row)
                    b.Size = UDim2.fromOffset(24, 20)
                    b.Position = UDim2.new(1, xoff, 0.5, -10)
                    b.BackgroundColor3 = col
                    b.Text = txt
                    b.TextColor3 = Color3.new(1, 1, 1)
                    b.Font = Enum.Font.GothamBold
                    b.TextSize = 13
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                end
                local up = miniBtn("\u{25B2}", -82, Color3.fromRGB(45, 45, 45))
                local dn = miniBtn("\u{25BC}", -56, Color3.fromRGB(45, 45, 45))
                local rm = miniBtn("\u{00D7}", -28, Color3.fromRGB(95, 40, 40))
                rm.TextSize = 18

                up.MouseButton1Click:Connect(function()
                    if i > 1 then
                        list[i], list[i - 1] = list[i - 1], list[i]
                        commit(); rebuild()
                    end
                end)
                dn.MouseButton1Click:Connect(function()
                    if i < #list then
                        list[i], list[i + 1] = list[i + 1], list[i]
                        commit(); rebuild()
                    end
                end)
                rm.MouseButton1Click:Connect(function()
                    table.remove(list, i)
                    commit(); rebuild()
                end)
            end
        end

        addItem = function()
            local v = box.Text
            if type(v) ~= "string" then return end
            v = v:gsub("^%s+", ""):gsub("%s+$", "")
            if v == "" then return end
            local list = getList()
            local key = _pnorm(v)
            for _, e in ipairs(list) do
                if _pnorm(e) == key then
                    notify("PRIORITY", "already in list"); box.Text = ""; hideSuggestions(); return
                end
            end
            list[#list + 1] = v:lower()
            box.Text = ""
            hideSuggestions()
            commit(); rebuild()
            notify("PRIORITY", "+ " .. v)
        end
        addBtn.MouseButton1Click:Connect(addItem)
        box:GetPropertyChangedSignal("Text"):Connect(refreshSuggestions)
        box.FocusLost:Connect(function(enterPressed)
            if enterPressed then addItem() end
            
            task.delay(0.15, function() if hideSuggestions then hideSuggestions() end end)
        end)

        resetBtn.MouseButton1Click:Connect(function()
            local list = getList()
            table.clear(list)
            for i = 1, #(_G.MynxxPriorityDefault or {}) do list[i] = _G.MynxxPriorityDefault[i] end
            commit(); rebuild()
            notify("PRIORITY", "default list")
        end)

        
        
        
        importBtn.MouseButton1Click:Connect(function()
            local ov = Instance.new("Frame", priorityPanel)
            ov.Size = UDim2.new(1, -12, 1, -76)
            ov.Position = UDim2.new(0, 6, 0, 70)
            ov.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            ov.BorderSizePixel = 0
            ov.ZIndex = 10
            Instance.new("UICorner", ov).CornerRadius = UDim.new(0, 6)

            local ib = Instance.new("TextBox", ov)
            ib.Size = UDim2.new(1, -12, 1, -44)
            ib.Position = UDim2.new(0, 6, 0, 6)
            ib.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            ib.TextColor3 = Color3.new(1, 1, 1)
            ib.PlaceholderText = 'paste JSON: ["headless horseman", ...]'
            ib.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
            ib.MultiLine = true
            ib.ClearTextOnFocus = false
            ib.TextXAlignment = Enum.TextXAlignment.Left
            ib.TextYAlignment = Enum.TextYAlignment.Top
            ib.TextWrapped = true
            ib.Font = Enum.Font.Code
            ib.TextSize = 11
            ib.ZIndex = 11
            ib.Text = getClip() or ""
            Instance.new("UICorner", ib).CornerRadius = UDim.new(0, 6)
            local ibp = Instance.new("UIPadding", ib)
            ibp.PaddingLeft = UDim.new(0, 6); ibp.PaddingRight = UDim.new(0, 6)
            ibp.PaddingTop = UDim.new(0, 4)

            local function mkBtn(txt, xoff, col)
                local b = Instance.new("TextButton", ov)
                b.Size = UDim2.fromOffset(112, 30)
                b.Position = UDim2.new(0, xoff, 1, -36)
                b.BackgroundColor3 = col
                b.Text = txt
                b.TextColor3 = Color3.new(1, 1, 1)
                b.Font = Enum.Font.GothamBold
                b.TextSize = 12
                b.ZIndex = 11
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            end
            local loadB = mkBtn("IMPORT", 6, Color3.fromRGB(30, 90, 45))
            local cancelB = mkBtn("CANCEL", 122, Color3.fromRGB(70, 70, 70))

            loadB.MouseButton1Click:Connect(function()
                local parsed = parseList(ib.Text)
                if not parsed or #parsed == 0 then
                    notify("IMPORT", "no valid names"); return
                end
                setList(parsed, true)
                rebuild()
                ov:Destroy()
                notify("IMPORT", #getList() .. " items loaded")
            end)
            cancelB.MouseButton1Click:Connect(function() ov:Destroy() end)
        end)

        switchTab = function(tab)
            if tab == currentTab then return end
            currentTab = tab
            box.Text = ""
            box.PlaceholderText = (tab == "mutation") and "add a mutation..." or "add a brainrot..."
            if hideSuggestions then hideSuggestions() end
            refreshTabs()
            rebuild()
        end
        tabBrainrot.MouseButton1Click:Connect(function() switchTab("brainrot") end)
        tabMutation.MouseButton1Click:Connect(function() switchTab("mutation") end)
        refreshTabs()

        rebuild()
    end

    btn("TP SETTINGS", 140, f, function()
        openSettings()
        notify("SETTINGS", "ouvre le panneau a droite")
    end)

    task.delay(1.5, function()
        notify("GUI", "drag le titre | TP SETTINGS pour les sliders")
        diag()
    end)
end

local print = function() end
local warn  = function() end
    local HS = game:GetService("HttpService")
    local FILE = "MynxxHub.json"
    local function load()
        data = {}
            pcall(function()
                local raw = readfile(FILE)
                local t = HS:JSONDecode(raw)
                if type(t) == "table" then data = t end
            end)
        end
    end
    _G.HubCfg = {
        get = function(section)
            local d = load()
            if type(d[section]) ~= "table" then d[section] = {} end
            return d[section]
        end,
        save = function()
            pcall(function() writefile(FILE, HS:JSONEncode(load())) end)
        end,
    }

    
    _G.XyntrixSaveConfig = function()
        local sec = _G.HubCfg.get("xyntrix")
        sec.autoTp = _G.MynxxAutoTP and true or false
        sec.autoBuy = _G.MynxxAutoBuy and true or false
        sec.stealMode = _G.MynxxStealMode
        sec.fov = tonumber(_G.MynxxFOV) or 70
        sec.autoKick = _G.AutoKickOnSteal and true or false
        sec.faceAway = _G.MynxxFaceAwayOn and true or false
        sec.invisAuto = _G.MynxxInvisAuto and true or false
        sec.invisDepth = tonumber(_G.MynxxInvisDepth)
        sec.invisAngle = tonumber(_G.MynxxInvisAngle)
        sec.walkspeed = _G.MynxxWSEnabled and true or false
        sec.wsValue = tonumber(_G.MynxxWalkSpeed)
        sec.buyRange = tonumber(_G.MynxxAutoBuyRange)
        sec.xrayAlpha = tonumber(_G.XRayAlpha)
        sec.carpetTool = _G.MynxxCarpetTool
        sec.guiHidden = {}
        if type(_G.XyntrixGuiHidden) == "table" then
            for id, v in pairs(_G.XyntrixGuiHidden) do
                sec.guiHidden[id] = v and true or false
            end
        end
        sec.hideGuis = nil
        sec.infJump = _G.XyntrixInfJump and true or false
        sec.autoUnlockOnSteal = _G.AutoUnlockOnSteal and true or false
        sec.savedAt = os.date("!%Y-%m-%d %H:%M:%S UTC")
        _G.HubCfg.save()
        
        pcall(function()
            if type(saveTpSettings) == "function" then saveTpSettings() end
        end)
        pcall(function()
                local raw = ""
                pcall(function() raw = readfile("SideTP.json") end)
                local t = {}
                pcall(function() t = HS:JSONDecode(raw) or {} end)
                if type(t) ~= "table" then t = {} end
                t.autoTp = _G.MynxxAutoTP
                t.autoBuy = _G.MynxxAutoBuy
                t.stealMode = _G.MynxxStealMode
                t.fov = _G.MynxxFOV
                writefile("SideTP.json", HS:JSONEncode(t))
            end
        end)
    end

    
    
    local _GUI_MAP = {
        teleport    = "TPStealTestUI",
        stealtarget = "MynxxStealTargetUI",
        invis       = "InvisStealUI",
        keybinds    = "CarpetCloneUI",
        autokick    = "AutoKickUI",
        faceaway    = "FlasherUI",
        watermark   = "MynxxWatermark",
        stealbar    = "LeanStealBar",
    }
    local _GUI_LABELS = {
        teleport    = "Teleport",
        stealtarget = "Steal Target",
        invis       = "Invis",
        keybinds    = "Keybinds",
        autokick    = "Auto Kick",
        faceaway    = "Face Away",
        watermark   = "Watermark",
        stealbar    = "Steal Bar",
    }
    
    _G.XyntrixGuiHidden = _G.XyntrixGuiHidden or {}
    for id in pairs(_GUI_MAP) do
        if _G.XyntrixGuiHidden[id] == nil then _G.XyntrixGuiHidden[id] = false end
    end

    local function _guiParents()
        local parents = {}
        pcall(function() if gethui then parents[#parents + 1] = gethui() end end)
        pcall(function() parents[#parents + 1] = game:GetService("CoreGui") end)
        pcall(function()
            local lp = game:GetService("Players").LocalPlayer
            if lp then parents[#parents + 1] = lp:FindFirstChild("PlayerGui") end
        end)
    end

    _G.XyntrixApplyGuiVisibility = function()
        local parents = _guiParents()
        for id, sgName in pairs(_GUI_MAP) do
            local hide = _G.XyntrixGuiHidden[id] == true
            for _, p in ipairs(parents) do
                local ch = p:FindFirstChild(sgName)
                if ch and ch:IsA("ScreenGui") then
                    ch.Enabled = not hide
                        
                        for _, fr in ipairs(ch:GetChildren()) do
                            if fr:IsA("GuiObject") then
                                fr.Visible = true
                            end
                        end
                    end
                end
            end
        end
        for _, p in ipairs(parents) do
            local g = p:FindFirstChild("MynxxGearIcon")
            if g and g:IsA("ScreenGui") then g.Enabled = true end
            local h = p:FindFirstChild("XyntrixHideGuiUI")
            if h and h:IsA("ScreenGui") then
                h.Enabled = true
                for _, fr in ipairs(h:GetChildren()) do
                    if fr:IsA("GuiObject") then fr.Visible = true end
                end
            end
        end
    end

    
    _G.XyntrixReopenGui = function(id)
        if not _GUI_MAP[id] then return false end
        _G.XyntrixGuiHidden[id] = false
        _G.XyntrixApplyGuiVisibility()
        local sgName = _GUI_MAP[id]
        for _, p in ipairs(_guiParents()) do
            local sg = p and p:FindFirstChild(sgName)
            if sg and sg:IsA("ScreenGui") then
                sg.Enabled = true
                for _, fr in ipairs(sg:GetChildren()) do
                    if fr:IsA("GuiObject") then fr.Visible = true end
                end
            end
        end
        if id == "keybinds" and _G.XyntrixKeybindPanel then
            _G.XyntrixKeybindPanel.Visible = true
        end
        pcall(function()
            if not _G.HubCfg then return end
            local sec = _G.HubCfg.get("xyntrix")
            sec.guiHidden = sec.guiHidden or {}
            sec.guiHidden[id] = false
            _G.HubCfg.save()
        end)
    end

    _G.XyntrixToggleGui = function(id)
        if not _GUI_MAP[id] then return end
        local willHide = not (_G.XyntrixGuiHidden[id] == true)
            _G.XyntrixGuiHidden[id] = true
            _G.XyntrixApplyGuiVisibility()
            if _G.XyntrixReopenGui then
                _G.XyntrixReopenGui(id)
                _G.XyntrixGuiHidden[id] = false
                _G.XyntrixApplyGuiVisibility()
            end
        end
        pcall(function()
            if not _G.HubCfg then return end
            local sec = _G.HubCfg.get("xyntrix")
            sec.guiHidden = sec.guiHidden or {}
            sec.guiHidden[id] = _G.XyntrixGuiHidden[id] == true
            sec.hideGuis = nil
            _G.HubCfg.save()
        end)
        return _G.XyntrixGuiHidden[id]
    end

    _G.XyntrixSetGuiHidden = function(id, hide)
        if not _GUI_MAP[id] then return end
        _G.XyntrixGuiHidden[id] = hide and true or false
        _G.XyntrixApplyGuiVisibility()
        pcall(function()
            if not _G.HubCfg then return end
            local sec = _G.HubCfg.get("xyntrix")
            sec.guiHidden = sec.guiHidden or {}
            sec.guiHidden[id] = _G.XyntrixGuiHidden[id]
            _G.HubCfg.save()
        end)
    end

    
    _G.XyntrixShowGui = function(id)
        if not _GUI_MAP[id] then return end
        _G.XyntrixGuiHidden[id] = false
        _G.XyntrixApplyGuiVisibility()
        pcall(function()
            if not _G.HubCfg then return end
            local sec = _G.HubCfg.get("xyntrix")
            sec.guiHidden = sec.guiHidden or {}
            sec.guiHidden[id] = false
            _G.HubCfg.save()
        end)
    end

    
    _G.XyntrixOpenMainMenu = function(forceOpen)
        
        if _G.XyntrixReopenGui then
            
            if forceOpen == false then
                _G.XyntrixGuiHidden["keybinds"] = false
                local pf0 = _G.XyntrixKeybindPanel
                if pf0 then pf0.Visible = false end
            end
        end
        _G.XyntrixReopenGui("keybinds")
        local pf = _G.XyntrixKeybindPanel
            for _, p in ipairs(_guiParents()) do
                local sg = p and p:FindFirstChild("CarpetCloneUI")
                    sg.Enabled = true
                    for _, ch in ipairs(sg:GetChildren()) do
                        if ch:IsA("Frame") then pf = ch; break end
                    end
                end
            end
            if pf then _G.XyntrixKeybindPanel = pf end
        end
        local sg = pf.Parent
        local fullyOpen = pf.Visible and (not sg or sg.Enabled)
        if forceOpen == true then
            if sg then sg.Enabled = true end
            pf.Visible = true
        elseif forceOpen == false then
            pf.Visible = false
            
                pf.Visible = false
                if sg then sg.Enabled = true end
                pf.Visible = true
            end
        end
        return pf.Visible
    end

    
    _G.XyntrixOpenHideGuiPanel = function()
        local guiParent = (gethui and gethui()) or game:GetService("CoreGui")
        pcall(function()
            local old = guiParent:FindFirstChild("XyntrixHideGuiUI")
            if old then old:Destroy() end
        end)
        local sg = Instance.new("ScreenGui")
        sg.Name = "XyntrixHideGuiUI"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 140
        pcall(function() sg.Parent = guiParent end)
        if not sg.Parent then
            local lp = game:GetService("Players").LocalPlayer
            sg.Parent = lp and lp:FindFirstChild("PlayerGui")
        end

        local order = {
            "teleport", "stealtarget", "invis", "keybinds",
            "autokick", "faceaway", "watermark", "stealbar",
        }
        local f = Instance.new("Frame", sg)
        f.Size = UDim2.fromOffset(210, 28 + #order * 28 + 68)
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.Position = UDim2.new(0.5, 0, 0.5, 0)
        f.BackgroundColor3 = Color3.fromRGB(8, 12, 20)
        f.BackgroundTransparency = 0
        f.BorderSizePixel = 0
        f.Active = true
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
        local st = Instance.new("UIStroke", f)
        st.Color = Color3.fromRGB(90, 170, 255)
        st.Thickness = 1.3
        st.Transparency = 0.35

        local ttl = Instance.new("TextLabel", f)
        ttl.Size = UDim2.new(1, -36, 0, 24)
        ttl.Position = UDim2.fromOffset(10, 4)
        ttl.BackgroundTransparency = 1
        ttl.Font = Enum.Font.GothamBlack
        ttl.TextSize = 13
        ttl.TextColor3 = Color3.fromRGB(245, 248, 255)
        ttl.TextXAlignment = Enum.TextXAlignment.Left
        ttl.Text = "Xyntrix · Hide GUIs"

        local close = Instance.new("TextButton", f)
        close.Size = UDim2.fromOffset(24, 24)
        close.Position = UDim2.new(1, -28, 0, 4)
        close.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        close.Text = "X"
        close.TextColor3 = Color3.new(1, 1, 1)
        close.Font = Enum.Font.GothamBold
        close.TextSize = 12
        close.BorderSizePixel = 0
        Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
        close.MouseButton1Click:Connect(function() sg:Destroy() end)

        for i, id in ipairs(order) do
            local y = 28 + (i - 1) * 28
            local row = Instance.new("TextButton", f)
            row.Size = UDim2.new(1, -16, 0, 24)
            row.Position = UDim2.fromOffset(8, y)
            row.BorderSizePixel = 0
            row.Font = Enum.Font.GothamBold
            row.TextSize = 11
            row.TextXAlignment = Enum.TextXAlignment.Left
            row.AutoButtonColor = true
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

            local function paint()
                local hid = _G.XyntrixGuiHidden[id] == true
                row.BackgroundColor3 = hid and Color3.fromRGB(60, 40, 40) or Color3.fromRGB(24, 32, 48)
                row.TextColor3 = Color3.fromRGB(245, 248, 255)
                row.Text = "  " .. (_GUI_LABELS[id] or id) .. (hid and "  · HIDDEN" or "  · SHOWN")
            end
            paint()
            row.MouseButton1Click:Connect(function()
                local hid = _G.XyntrixGuiHidden[id] == true
                    
                    if _G.XyntrixReopenGui then _G.XyntrixReopenGui(id)
                    else _G.XyntrixToggleGui(id) end
                    
                    _G.XyntrixToggleGui(id)
                end
                paint()
            end)
        end

        local reopen = Instance.new("TextButton", f)
        reopen.Size = UDim2.new(1, -16, 0, 24)
        reopen.Position = UDim2.new(0, 8, 1, -60)
        reopen.BackgroundColor3 = Color3.fromRGB(45, 130, 255)
        reopen.TextColor3 = Color3.new(1, 1, 1)
        reopen.Font = Enum.Font.GothamBold
        reopen.TextSize = 11
        reopen.BorderSizePixel = 0
        reopen.Text = "Reopen Main Menu"
        Instance.new("UICorner", reopen).CornerRadius = UDim.new(0, 6)
        reopen.MouseButton1Click:Connect(function()
            if _G.XyntrixOpenMainMenu then pcall(_G.XyntrixOpenMainMenu, true) end
            for _, ch in ipairs(f:GetChildren()) do
                if ch:IsA("TextButton") and type(ch.Text) == "string" and string.find(ch.Text, "Keybinds") then
                    ch.BackgroundColor3 = Color3.fromRGB(24, 32, 48)
                    ch.Text = "  Keybinds  · SHOWN"
                end
            end
        end)

        local tip = Instance.new("TextLabel", f)
        tip.Size = UDim2.new(1, -16, 0, 28)
        tip.Position = UDim2.new(0, 8, 1, -32)
        tip.BackgroundTransparency = 1
        tip.Font = Enum.Font.Gotham
        tip.TextSize = 10
        tip.TextColor3 = Color3.fromRGB(160, 175, 200)
        tip.TextXAlignment = Enum.TextXAlignment.Left
        tip.TextWrapped = true
        tip.Text = "Clic = hide/show. Engrenage / Reopen = menu principal."

        if _G.MynxxCenterPanel then pcall(_G.MynxxCenterPanel, f, 200, 28 + #order * 28 + 68) end
        if _G.XyntrixStylePanel then pcall(_G.XyntrixStylePanel, f) end
    end

    
    _G.XyntrixToggleHideGuis = function()
        if _G.XyntrixOpenHideGuiPanel then _G.XyntrixOpenHideGuiPanel() end
    end

    _G.XyntrixGuiMap = _GUI_MAP
    _G.XyntrixGuiLabels = _GUI_LABELS
end

task.defer(function()
    pcall(function()
        if not _G.HubCfg then return end
        local sec = _G.HubCfg.get("xyntrix")
        if type(sec.guiHidden) == "table" then
            _G.XyntrixGuiHidden = _G.XyntrixGuiHidden or {}
            for id, v in pairs(sec.guiHidden) do
                _G.XyntrixGuiHidden[id] = v and true or false
            end
        end
        task.wait(2.5)
        if _G.XyntrixApplyGuiVisibility then _G.XyntrixApplyGuiVisibility() end
    end)
end)

local __stgN = 0
local function stagSpawn(fn)
    __stgN = __stgN + 1
    local n = __stgN
    task.spawn(function()
        
        
        task.wait(6)
        for _ = 1, n do task.wait() end
        
        
        local Players = game:GetService("Players")
        while not Players.LocalPlayer do task.wait() end
        fn()
    end)
end

local function nowSpawn(fn)
    task.spawn(function()
        local Players = game:GetService("Players")
        while not Players.LocalPlayer do task.wait() end
        fn()
    end)
end

nowSpawn(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local HS         = game:GetService("HttpService")
    local LP         = Players.LocalPlayer
    local PG         = LP:WaitForChild("PlayerGui")

    
    
    
    
    local cfg = _G.HubCfg.get("invis")
    local function saveCfg()
        cfg.angle  = _G.InvisStealAngle
        cfg.depth  = _G.SinkSliderValue
        cfg.ws     = _G.MynxxWSValue
        cfg.wsOn   = _G.MynxxWSEnabled
        cfg.aInv   = _G.AutoInvisDuringSteal
        cfg.aRec   = _G.AutoRecoverLagback
        cfg.panelX = _G.InvisPanelX
        cfg.panelY = _G.InvisPanelY
        _G.HubCfg.save()
    end

    if _G.InvisStealAngle     == nil then _G.InvisStealAngle     = 225   end
    if _G.SinkSliderValue     == nil then _G.SinkSliderValue     = 8     end
    if _G.MynxxWSValue       == nil then _G.MynxxWSValue       = 28    end
    if _G.MynxxWSEnabled     == nil then _G.MynxxWSEnabled     = true  end
    if _G.AutoInvisDuringSteal== nil then _G.AutoInvisDuringSteal= false end
    if _G.AutoRecoverLagback  == nil then _G.AutoRecoverLagback  = true  end
        if tonumber(cfg.angle) then _G.InvisStealAngle = tonumber(cfg.angle) end
        if tonumber(cfg.depth) then _G.SinkSliderValue = tonumber(cfg.depth) end
        if tonumber(cfg.ws)    then _G.MynxxWSValue   = tonumber(cfg.ws) end
        if type(cfg.wsOn) == "boolean" then _G.MynxxWSEnabled      = cfg.wsOn end
        if type(cfg.aInv) == "boolean" then _G.AutoInvisDuringSteal = cfg.aInv end
        if type(cfg.aRec) == "boolean" then _G.AutoRecoverLagback   = cfg.aRec end
        if tonumber(cfg.panelX) then _G.InvisPanelX = tonumber(cfg.panelX) end
        if tonumber(cfg.panelY) then _G.InvisPanelY = tonumber(cfg.panelY) end
    end
    _G.invisibleStealEnabled = false

    
    
    
    local animPlaying      = false
    local tracks           = {}
    local folderConns      = {}
    local serverGhosts     = {}
    local ghostEnabled     = true
    local lagbackCallCount = 0
    local lagbackWindow    = 0
    local lastLagback      = 0
    local errorOrbActive   = false
    local errorOrb, errorOrbConn
    local oldRoot, cloneRoot, hip, conn

    
    
    
    
    
    
    local function clearErrorOrb()
        if errorOrb and errorOrb.Parent then errorOrb:Destroy() end
        errorOrb = nil; errorOrbActive = false
        if errorOrbConn then errorOrbConn:Disconnect(); errorOrbConn = nil end
    end

    local function createErrorOrb()
        errorOrbActive = true
        for _, g in pairs(serverGhosts) do if g and g.Parent then g:Destroy() end end
        serverGhosts = {}
    end

    local function clearAllGhosts()
        for _, g in pairs(serverGhosts) do
            pcall(function() if g and g.Parent then g:Destroy() end end)
        end
        serverGhosts = {}; clearErrorOrb()
        lagbackCallCount = 0; lastLagback = 0
        pcall(function()
            if workspace.CurrentCamera then
                for _, c in pairs(workspace.CurrentCamera:GetChildren()) do
                    if c.Name == "LagbackGhost" then c:Destroy() end
                end
            end
        end)
    end

    local function createServerGhost(pos)
        local now = tick()
        if now - lastLagback < 0.05 then return end
        lastLagback = now
        if now - lagbackWindow > 1 then lagbackCallCount = 0; lagbackWindow = now end
        lagbackCallCount = lagbackCallCount + 1
        if lagbackCallCount >= 7 then createErrorOrb(); return end
        for _, g in pairs(serverGhosts) do if g and g.Parent then g:Destroy() end end
        serverGhosts = {}
        local g = Instance.new("Part")
        g.Name = "LagbackGhost"; g.Shape = Enum.PartType.Ball
        g.Size = Vector3.new(3, 3, 3); g.Color = Color3.fromRGB(255, 0, 0)
        g.Material = Enum.Material.Glass; g.Transparency = 0.3
        g.CanCollide = false; g.Anchored = true; g.CastShadow = false
        g.Position = pos + Vector3.new(0, 5, 0)
        g.Parent = workspace.CurrentCamera
        serverGhosts[#serverGhosts + 1] = g
    end

    
    
    
    
    
    
    
    
    
    
    
    local WS = { enabled = false, conn = nil }
    local function setWalkSpeedEnabled(en)
        WS.enabled = en
        if WS.conn then WS.conn:Disconnect(); WS.conn = nil end
        if refreshUI then refreshUI() end
        WS.conn = RunService.Heartbeat:Connect(function(dt)
            if _G.FlingActive then return end
            local c = LP.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if not hum or not root or hum.Health <= 0 then return end
            
            
            local target = tonumber(_G.MynxxWSValue) or 28
            if hum.MoveDirection.Magnitude > 0 and target > hum.WalkSpeed then
                root.CFrame = root.CFrame + (hum.MoveDirection * (target - hum.WalkSpeed) * dt)
            end
        end)
    end
    _G.setWalkSpeedEnabled = setWalkSpeedEnabled

    
    
    local function setWalkSpeedValue(v)
        v = math.clamp(math.floor((tonumber(v) or 28) + 0.5), 15, 29)
        _G.MynxxWSValue = v
    end
    _G.setWalkSpeedValue = setWalkSpeedValue
    setWalkSpeedValue(_G.MynxxWSValue)

    
    
    
    local function removeFolders()
        local pf = workspace:FindFirstChild(LP.Name)
        local dr = pf:FindFirstChild("DoubleRig")
            local rr = dr:FindFirstChild("HumanoidRootPart") or dr:FindFirstChildWhichIsA("BasePart")
            if rr and ghostEnabled then createServerGhost(rr.Position) end
            dr:Destroy()
        end
        local cs = pf:FindFirstChild("Constraints")
        if cs then cs:Destroy() end
        folderConns[#folderConns + 1] = pf.ChildAdded:Connect(function(child)
            if child.Name == "DoubleRig" then
                task.defer(function()
                    if not child or not child.Parent then return end
                    local rr = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChildWhichIsA("BasePart")
                    if rr and ghostEnabled then createServerGhost(rr.Position) end
                    child:Destroy()
                end)
            elseif child.Name == "Constraints" then
                child:Destroy()
            end
        end)
    end

    if not _G._xenFixRig then
        local _rigBusy = false
        local _R = {
            {"Root","HumanoidRootPart","LowerTorso"},{"Waist","LowerTorso","UpperTorso"},
            {"Neck","UpperTorso","Head"},
            {"LeftShoulder","UpperTorso","LeftUpperArm"},{"LeftElbow","LeftUpperArm","LeftLowerArm"},
            {"LeftWrist","LeftLowerArm","LeftHand"},
            {"RightShoulder","UpperTorso","RightUpperArm"},{"RightElbow","RightUpperArm","RightLowerArm"},
            {"RightWrist","RightLowerArm","RightHand"},
            {"LeftHip","LowerTorso","LeftUpperLeg"},{"LeftKnee","LeftUpperLeg","LeftLowerLeg"},
            {"LeftAnkle","LeftLowerLeg","LeftFoot"},
            {"RightHip","LowerTorso","RightUpperLeg"},{"RightKnee","RightUpperLeg","RightLowerLeg"},
            {"RightAnkle","RightLowerLeg","RightFoot"},
        }
        local function _fix()
            local _ch = LP.Character
            local _h = _ch:FindFirstChildOfClass("Humanoid")
            if not _h or _h.RigType ~= Enum.HumanoidRigType.R15 or _h.Health <= 0 then return end
            for _, j in ipairs(_R) do
                local p, c = _ch:FindFirstChild(j[2]), _ch:FindFirstChild(j[3])
                    local have = false
                    for _, d in ipairs(c:GetChildren()) do
                        if d:IsA("Motor6D") and d.Name == j[1] then have = true break end
                    end
                        local a0 = p:FindFirstChild(j[1] .. "RigAttachment")
                        local a1 = c:FindFirstChild(j[1] .. "RigAttachment")
                            for _, d in ipairs(c:GetChildren()) do
                                if d:IsA("AnimationConstraint") and d.Name == j[1] then
                                    pcall(function() d.Enabled = false end)
                                end
                            end
                            pcall(function()
                                local m = Instance.new("Motor6D")
                                m.Name, m.Part0, m.Part1, m.C0, m.C1 = j[1], p, c, a0.CFrame, a1.CFrame
                                m.Parent = c
                            end)
                        end
                    end
                end
            end
        end
        _G._xenFixRig = function()
            _rigBusy = true
            local ok = pcall(_fix)
            _rigBusy = false
        end
    end

    local function invisClone()
        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        hip = hum.HipHeight
        oldRoot = c:FindFirstChild("HumanoidRootPart")
        if not oldRoot or not oldRoot.Parent then return false end
        for _, x in pairs(oldRoot:GetChildren()) do
            if x:IsA("Attachment") and (x.Name:find("Beam") or x.Name:find("Attach")) then x:Destroy() end
        end
        for _, x in pairs(oldRoot:GetChildren()) do
            if x:IsA("Beam") then x:Destroy() end
        end
        local tmp = Instance.new("Model"); tmp.Parent = game
        c.Parent = tmp
        cloneRoot = oldRoot:Clone(); cloneRoot.Parent = c
        oldRoot.Parent = workspace.CurrentCamera
        cloneRoot.CFrame = oldRoot.CFrame; c.PrimaryPart = cloneRoot
        c.Parent = workspace
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == oldRoot then v.Part0 = cloneRoot end
                if v.Part1 == oldRoot then v.Part1 = cloneRoot end
            end
        end
        tmp:Destroy()
        task.defer(function() if _G._xenFixRig then _G._xenFixRig() end end)
    end

    local function invisRevert()
        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not oldRoot or not oldRoot:IsDescendantOf(workspace) or not hum or hum.Health <= 0 then return end
        local tmp = Instance.new("Model"); tmp.Parent = game
        c.Parent = tmp
        oldRoot.Parent = c; c.PrimaryPart = oldRoot
        c.Parent = workspace; oldRoot.CanCollide = true
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == cloneRoot then v.Part0 = oldRoot end
                if v.Part1 == cloneRoot then v.Part1 = oldRoot end
            end
        end
        tmp:Destroy()
            local p = cloneRoot.CFrame
            cloneRoot:Destroy(); cloneRoot = nil
            oldRoot.CFrame = p
        end
        oldRoot = nil
        if hip then hum.HipHeight = hip end
        task.defer(function() if _G._xenFixRig then _G._xenFixRig() end end)
        clearAllGhosts()
    end

    local function animationTrickery()
        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local a = Instance.new("Animation")
        a.AnimationId = ""
        local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
        local tr = animator:LoadAnimation(a)
        tr.Priority = Enum.AnimationPriority.Action4
        tr:Play(0, 1, 0); a:Destroy()
        tracks[#tracks + 1] = tr
        tr.Stopped:Connect(function() if animPlaying then animationTrickery() end end)
        task.defer(function()
            tr.TimePosition = 0.7
            task.delay(0.3, function() pcall(function() tr:AdjustSpeed(math.huge) end) end)
        end)
    end

    
    
    
    local invisCooldown = 0

    local function invisTurnOff()
        clearAllGhosts()
        animPlaying = false; _G.invisibleStealEnabled = false
        for _, t in pairs(tracks) do pcall(function() t:Stop(0) end) end
        tracks = {}
        if conn then conn:Disconnect(); conn = nil end
        for _, x in ipairs(folderConns) do pcall(function() x:Disconnect() end) end
        folderConns = {}
        invisRevert(); clearAllGhosts()
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            pcall(function()
                local animator = hum:FindFirstChildOfClass("Animator")
                    for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
                        if t.Priority == Enum.AnimationPriority.Action4
                        or t.Priority == Enum.AnimationPriority.Action3 then t:Stop(0) end
                    end
                end
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                task.defer(function()
                    if hum and hum.Parent then hum:ChangeState(Enum.HumanoidStateType.Running) end
                end)
            end)
        end
        
        if WS.enabled and _G.MynxxWSEnabled then setWalkSpeedEnabled(false) end
        invisCooldown = tick()
        if refreshUI then refreshUI() end
    end

    local function invisTurnOn()
        local c = LP.Character
        if not c or not c:FindFirstChildOfClass("Humanoid") then return end
        animPlaying = true; _G.invisibleStealEnabled = true
        tracks = {}; removeFolders()
        if not invisClone() then
            animPlaying = false; _G.invisibleStealEnabled = false
            if refreshUI then refreshUI() end
            return
        end
        task.wait(0.05); animationTrickery()
        task.delay(1, function()
            if _G.invisibleStealEnabled and _G.MynxxWSEnabled and not WS.enabled then
                setWalkSpeedEnabled(true)
            end
        end)
        local lastSetPosition, skipFrames = nil, 5
        conn = RunService.PreSimulation:Connect(function()
            local ch = LP.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 or not oldRoot then return end
            local root = ch.PrimaryPart or ch:FindFirstChild("HumanoidRootPart")
            
            
            
            if skipFrames > 0 then
                skipFrames = skipFrames - 1; lastSetPosition = nil
                local cur = oldRoot.Position
                if (cur - lastSetPosition).Magnitude > 6
                   and not _G.RecoveryInProgress and LP:GetAttribute("Stealing") then
                    lastSetPosition = nil
                    createServerGhost(cur)
                    if _G.AutoRecoverLagback and _G._forceInvisToggle then
                        _G.RecoveryInProgress = true
                        task.spawn(function()
                            pcall(_G._forceInvisToggle); task.wait(0.6)
                            if LP:GetAttribute("Stealing") then pcall(_G._forceInvisToggle) end
                            _G.RecoveryInProgress = false
                        end)
                    end
                end
            end
            if cloneRoot then cloneRoot.CanCollide = true end
            if oldRoot and oldRoot.Parent then
                for _, x in pairs(oldRoot:GetChildren()) do
                    if x:IsA("Attachment") or x:IsA("Beam") then x:Destroy() end
                end
                local sink = (tonumber(_G.SinkSliderValue) or 8) * 0.5
                oldRoot.CFrame = (root.CFrame - Vector3.new(0, sink, 0))
                    * CFrame.Angles(math.rad(tonumber(_G.InvisStealAngle) or 180), 0, 0)
                oldRoot.AssemblyLinearVelocity = root.AssemblyLinearVelocity
                oldRoot.CanCollide = false
                lastSetPosition = oldRoot.Position
            end
        end)
        if refreshUI then refreshUI() end
    end

    _G.toggleInvisibleSteal = function()
        if (tick() - invisCooldown) < 0.3 then return end
        if animPlaying then invisTurnOff() else invisTurnOn() end
    end
    
    _G._forceInvisToggle = function()
        if animPlaying then invisTurnOff() else invisTurnOn() end
    end

    
    
    
    local function setupDeathListener()
        local ch = LP.Character
        local h = ch and ch:FindFirstChildOfClass("Humanoid")
            h.Died:Connect(function()
                clearErrorOrb(); clearAllGhosts(); lagbackCallCount = 0
            end)
        end
    end
    setupDeathListener()

    LP.CharacterAdded:Connect(function(newChar)
        task.wait(0.1)
        clearErrorOrb(); clearAllGhosts(); lagbackCallCount = 0
        pcall(function()
            for _, x in pairs(workspace.CurrentCamera:GetChildren()) do
                if x:IsA("BasePart") and x.Name == "HumanoidRootPart" then x:Destroy() end
            end
        end)
        if oldRoot   then pcall(function() oldRoot:Destroy() end);   oldRoot = nil end
        if cloneRoot then pcall(function() cloneRoot:Destroy() end); cloneRoot = nil end
        animPlaying = false; _G.invisibleStealEnabled = false
        if conn then conn:Disconnect(); conn = nil end
        setupDeathListener()
        if refreshUI then refreshUI() end
        task.wait(0.2)
        local cam = workspace.CurrentCamera
        local h = newChar and newChar:FindFirstChildOfClass("Humanoid")
        if cam and h then cam.CameraSubject = h; cam.CameraType = Enum.CameraType.Custom end
    end)

    
    
    
    task.spawn(function()
        local wasStealing, autoEnabled = false, false
        task.wait(1)
        while task.wait(0.15) do
            if not _G.AutoInvisDuringSteal then
                wasStealing = false; autoEnabled = false
                local isStealing = LP:GetAttribute("Stealing")
                if isStealing and not wasStealing and not _G.invisibleStealEnabled then
                    
                    
                    
                    task.spawn(function()
                        task.wait(0.5)
                        if LP:GetAttribute("Stealing") and not _G.invisibleStealEnabled then
                            pcall(_G._forceInvisToggle); autoEnabled = true
                        end
                    end)
                end
                if not isStealing and autoEnabled and _G.invisibleStealEnabled then
                    task.wait(0.3)
                    if not LP:GetAttribute("Stealing") then
                        pcall(_G._forceInvisToggle); autoEnabled = false
                    end
                end
                wasStealing = isStealing
            end
        end
    end)

    
    
    
    
    
    local guiParent = (gethui and gethui()) or game:GetService("CoreGui") or PG
    pcall(function()
        local old = guiParent:FindFirstChild("InvisStealUI")
        if old then old:Destroy() end
    end)
    local sg = Instance.new("ScreenGui")
    sg.Name = "InvisStealUI"; sg.ResetOnSpawn = false; sg.DisplayOrder = 131
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = PG end

    local f = Instance.new("Frame", sg)
    f.Size = UDim2.fromOffset(206, 264)
    
    _G.MynxxCenterPanel(f, 176, 230)
    f.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    f.BorderSizePixel = 0; f.Active = true; f.Draggable = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    
    
    
        local pending = false
        f:GetPropertyChangedSignal("Position"):Connect(function()
            pending = true
            task.delay(0.5, function()
                pending = false
                _G.InvisPanelX = f.AbsolutePosition.X
                _G.InvisPanelY = f.AbsolutePosition.Y
                saveCfg()
            end)
        end)
    end

    local ttl = Instance.new("TextLabel", f)
    ttl.Size = UDim2.new(1, 0, 0, 22); ttl.BackgroundTransparency = 1
    ttl.Text = "Xyntrix · Invis"; ttl.Font = Enum.Font.GothamBlack
    ttl.TextSize = 13; ttl.TextColor3 = Color3.new(1, 1, 1)
    pcall(_G.XyntrixStylePanel, f); pcall(_G.XyntrixStyleTitle, ttl); task.defer(_G.XyntrixPolish, f)

    local ups = {}
    local function mkBtn(y, label, get, set)
        local b = Instance.new("TextButton", f)
        b.Size = UDim2.new(1, -16, 0, 22); b.Position = UDim2.fromOffset(8, y)
        b.Font = Enum.Font.GothamBold; b.TextSize = 11
        b.TextColor3 = Color3.new(1, 1, 1); b.BorderSizePixel = 0
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        local function up()
            local on = get()
            b.Text = label .. (on and ": ON" or ": OFF")
            b.BackgroundColor3 = on and Color3.fromRGB(45, 130, 255) or Color3.fromRGB(45, 45, 45)
        end
        b.MouseButton1Click:Connect(function() set(); up(); saveCfg() end)
        up(); ups[#ups + 1] = up
    end

    
    local function mkRow(y, label, min, max, step, dec, get, set)
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency = 1; l.Position = UDim2.fromOffset(8, y)
        l.Size = UDim2.fromOffset(126, 18)
        l.Font = Enum.Font.Gotham; l.TextSize = 11
        l.TextColor3 = Color3.fromRGB(210, 210, 210)
        l.TextXAlignment = Enum.TextXAlignment.Left
        local function txt()
            l.Text = label .. ": " .. string.format("%." .. dec .. "f", tonumber(get()) or min)
        end
        local function mk(px, d, sym)
            local b = Instance.new("TextButton", f)
            b.Size = UDim2.fromOffset(24, 16); b.Position = UDim2.fromOffset(px, y + 1)
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.Text = sym
            b.BorderSizePixel = 0
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
            b.MouseButton1Click:Connect(function()
                local v = (tonumber(get()) or min) + d * step
                
                v = math.clamp(math.floor(v / step + 0.5) * step, min, max)
                set(v); txt(); saveCfg()
            end)
        end
        mk(140, -1, "-"); mk(170, 1, "+"); txt()
    end

    mkBtn(26, "INVIS",       function() return animPlaying end,
                             function() _G.toggleInvisibleSteal() end)
    mkBtn(52, "WALKSPEED",   function() return WS.enabled end,
                             function()
                                 _G.MynxxWSEnabled = not WS.enabled
                                 setWalkSpeedEnabled(_G.MynxxWSEnabled)
                             end)
    mkBtn(78, "AUTO INVIS",  function() return _G.AutoInvisDuringSteal end,
                             function() _G.AutoInvisDuringSteal = not _G.AutoInvisDuringSteal end)
    mkBtn(104, "AUTO RECOVER", function() return _G.AutoRecoverLagback end,
                             function() _G.AutoRecoverLagback = not _G.AutoRecoverLagback end)

    refreshUI = function() for _, u in ipairs(ups) do pcall(u) end end

    local refreshAngleBtns, refreshWsBtns
    local refreshRot = mkRow(136, "Rotation",  0,  360, 5,   0,
        function() return _G.InvisStealAngle end,
        function(v) _G.InvisStealAngle = v; if refreshAngleBtns then refreshAngleBtns() end end)
    mkRow(160, "Depth",     0,  18,  0.1, 1, function() return _G.SinkSliderValue end, function(v) _G.SinkSliderValue = v end)
    local refreshWs = mkRow(184, "WalkSpeed", 15, 29,  1,   0,
        function() return _G.MynxxWSValue end,
        function(v) _G.setWalkSpeedValue(v); if refreshWsBtns then refreshWsBtns() end end)

    
        local b180, b220
        refreshAngleBtns = function()
            local a = tonumber(_G.InvisStealAngle) or 180
            if b180 then b180.BackgroundColor3 = (math.abs(a - 180) < 0.5) and Color3.fromRGB(45, 130, 255) or Color3.fromRGB(45, 45, 45) end
            if b220 then b220.BackgroundColor3 = (math.abs(a - 220) < 0.5) and Color3.fromRGB(45, 130, 255) or Color3.fromRGB(45, 45, 45) end
        end
        local function mkAngleBtn(x, deg, label)
            local b = Instance.new("TextButton", f)
            b.Size = UDim2.fromOffset(91, 22); b.Position = UDim2.fromOffset(x, 208)
            b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.GothamBold; b.TextSize = 11; b.Text = label; b.BorderSizePixel = 0
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
            b.MouseButton1Click:Connect(function()
                _G.InvisStealAngle = deg
                if refreshRot then refreshRot() end
                refreshAngleBtns(); saveCfg()
            end)
        end
        b180 = mkAngleBtn(8, 180, "180\u{00B0}")
        b220 = mkAngleBtn(99, 220, "220\u{00B0}")
        refreshAngleBtns(); ups[#ups + 1] = refreshAngleBtns
    end

    
        local b20, b27
        refreshWsBtns = function()
            local w = tonumber(_G.MynxxWSValue) or 20
            if b20 then b20.BackgroundColor3 = (math.abs(w - 20) < 0.5) and Color3.fromRGB(45, 130, 255) or Color3.fromRGB(45, 45, 45) end
            if b27 then b27.BackgroundColor3 = (math.abs(w - 27) < 0.5) and Color3.fromRGB(45, 130, 255) or Color3.fromRGB(45, 45, 45) end
        end
        local function mkWsBtn(x, val, label)
            local b = Instance.new("TextButton", f)
            b.Size = UDim2.fromOffset(91, 22); b.Position = UDim2.fromOffset(x, 234)
            b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.GothamBold; b.TextSize = 11; b.Text = label; b.BorderSizePixel = 0
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
            b.MouseButton1Click:Connect(function()
                _G.setWalkSpeedValue(val)
                if refreshWs then refreshWs() end
                refreshWsBtns(); saveCfg()
            end)
        end
        b20 = mkWsBtn(8, 20, "20")
        b27 = mkWsBtn(99, 27, "27")
        refreshWsBtns(); ups[#ups + 1] = refreshWsBtns
    end

    
    
    
    
    if _G.MynxxWSEnabled then
        task.defer(function() setWalkSpeedEnabled(true) end)
        refreshUI()
    end
end)

nowSpawn(function()
local okXR, errXR = pcall(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    
    
    
    
    
    
    if type(_G.setXRay) == "function" then
        warn("[XRAY] un autre X-Ray est deja actif -> celui-ci ne s applique pas (anti-cumul)")
        return
    end

    
    
    
    
    _G.XRayEnabled = true
    if _G.XRayAlpha == nil then
        pcall(function()
            if _G.HubCfg then saved = tonumber(_G.HubCfg.get("carpet").xrayAlpha) end
        end)
        _G.XRayAlpha = math.clamp(saved or 0.60, 0, 1)
    end

    local origT = setmetatable({}, { __mode = "k" })
    local conns = {}
    local loopId = 0

    local function setTargetTransparency(instance, alpha, id)
        if id and id ~= loopId then return end

        local function apply(obj)
            
            
            local laser = _G.__laser
            if laser and laser.IsLaserObject and laser.IsLaserObject(obj) then
                local plot = laser.GetPlotFromObject and laser.GetPlotFromObject(obj)
                if plot and laser.IsPlotBaseOpen and laser.IsPlotBaseOpen(plot) then
                    if laser.SaveLaserOriginal then laser.SaveLaserOriginal(obj) end
                    if laser.HideLaserObject then laser.HideLaserObject(obj) end
                end
                return
            end
            if obj:IsA("BasePart") then
                if origT[obj] == nil then
                    if obj.Transparency == alpha then origT[obj] = 0
                    else origT[obj] = obj.Transparency end
                end
                local o = origT[obj]
                if o < 1 then
                    local target = o + (1 - o) * alpha
                    if math.abs(obj.Transparency - target) > 0.01 then obj.Transparency = target end
                end
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if origT[obj] == nil then
                    local t, b = obj.TextTransparency, obj.BackgroundTransparency
                    if t == alpha then t = 0 end
                    if b == alpha then b = 0 end
                    origT[obj] = { text = t, bg = b }
                end
                local o = origT[obj]
                if o.text < 1 then
                    local tt = o.text + (1 - o.text) * alpha
                    if math.abs(obj.TextTransparency - tt) > 0.01 then obj.TextTransparency = tt end
                end
                if o.bg < 1 then
                    local tb = o.bg + (1 - o.bg) * alpha
                    if math.abs(obj.BackgroundTransparency - tb) > 0.01 then obj.BackgroundTransparency = tb end
                end
            elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                if origT[obj] == nil then
                    if obj.BackgroundTransparency == alpha then origT[obj] = 0
                    else origT[obj] = obj.BackgroundTransparency end
                end
                local o = origT[obj]
                if o < 1 then
                    local target = o + (1 - o) * alpha
                    if math.abs(obj.BackgroundTransparency - target) > 0.01 then obj.BackgroundTransparency = target end
                end
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                if origT[obj] == nil then
                    local i, b = obj.ImageTransparency, obj.BackgroundTransparency
                    if i == alpha then i = 0 end
                    if b == alpha then b = 0 end
                    origT[obj] = { img = i, bg = b }
                end
                local o = origT[obj]
                if o.img < 1 then
                    local ti = o.img + (1 - o.img) * alpha
                    if math.abs(obj.ImageTransparency - ti) > 0.01 then obj.ImageTransparency = ti end
                end
                if o.bg < 1 then
                    local tb = o.bg + (1 - o.bg) * alpha
                    if math.abs(obj.BackgroundTransparency - tb) > 0.01 then obj.BackgroundTransparency = tb end
                end
            end
        end

        apply(instance)
        local desc = instance:GetDescendants()
        for i, child in ipairs(desc) do
            apply(child)
            if i % 300 == 0 then
                task.wait()
                if id and id ~= loopId then return end
            end
        end
    end

    local XRAY_FOLDERS = { "Base", "PlotSign", "FriendPanel", "Cash",
                           "Decorations", "Skin", "Unlock", "Purchases" }

    local function trackSubtree(root, alpha, id)
        if id ~= loopId then return end
        setTargetTransparency(root, alpha, id)
        if id ~= loopId then return end
        conns[#conns + 1] = root.DescendantAdded:Connect(function(obj)
            if id ~= loopId then return end
            setTargetTransparency(obj, alpha, id)
        end)
    end

    local function processPlot(plot, alpha, id)
        if id ~= loopId then return end
        for _, fname in ipairs(XRAY_FOLDERS) do
            if id ~= loopId then return end
            trackSubtree(plot:FindFirstChild(fname), alpha, id)
        end
        if id ~= loopId then return end
        conns[#conns + 1] = plot.ChildAdded:Connect(function(child)
            if id ~= loopId then return end
            for _, fname in ipairs(XRAY_FOLDERS) do
                if child.Name == fname then trackSubtree(child, alpha, id); break end
            end
        end)

        local podiums = plot:FindFirstChild("AnimalPodiums")
            local function processPodium(podium)
                for _, child in ipairs(podium:GetChildren()) do
                    if child.Name == "Claim" then
                        trackSubtree(child, alpha, id)
                    elseif child.Name == "Base" then
                        trackSubtree(child:FindFirstChild("Decorations"), alpha, id)
                    elseif child:IsA("Model") and child.Name ~= "Decorations" then
                        trackSubtree(child, alpha, id)
                    end
                end
            end
            for _, podium in ipairs(podiums:GetChildren()) do processPodium(podium) end
            conns[#conns + 1] = podiums.ChildAdded:Connect(function(podium)
                if id ~= loopId then return end
                task.wait(0.1)
                if id ~= loopId then return end
                processPodium(podium)
            end)
        end
    end

    local function applyAllPlots(alpha, id)
        local plots = workspace:FindFirstChild("Plots")
        for _, plot in ipairs(plots:GetChildren()) do
            if id ~= loopId then return end
            processPlot(plot, alpha, id)
            
            
            
        end
        conns[#conns + 1] = plots.ChildAdded:Connect(function(plot)
            if id ~= loopId then return end
            task.wait(0.2)
            processPlot(plot, alpha, id)
        end)
    end

    local function setXRay(enabled)
        _G.XRayEnabled = enabled

        for _, c in ipairs(conns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        conns = {}

        loopId = loopId + 1
        local id = loopId

            local alpha = math.clamp(tonumber(_G.XRayAlpha) or 0.60, 0, 1)
            task.spawn(function()
                while id == loopId and not workspace:FindFirstChild("Plots") do
                    task.wait()
                end
                if id ~= loopId then return end
                pcall(applyAllPlots, alpha, id)
            end)
            
            
            
            
            local snap = origT
            origT = setmetatable({}, { __mode = "k" })
            for obj, o in pairs(snap) do
                pcall(function()
                    if obj:IsA("BasePart") then
                        obj.Transparency = o
                    elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                        obj.TextTransparency = o.text
                        obj.BackgroundTransparency = o.bg
                    elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                        obj.BackgroundTransparency = o
                    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                        obj.ImageTransparency = o.img
                        obj.BackgroundTransparency = o.bg
                    end
                end)
            end
            
            
            local fps = _G.OriginalTransparency
            if type(fps) == "table" then
                for part, data in pairs(fps) do
                    if part and part.Parent and typeof(data) == "table" and data.trans then
                        pcall(function() part.Transparency = data.trans end)
                    end
                end
            end
            local laser = _G.__laser
            if laser and laser.RefreshAllPlotLasers then
                pcall(laser.RefreshAllPlotLasers)
            end
        end
    end
    _G.setXRay = setXRay
    _G.toggleXRay = function() setXRay(not _G.XRayEnabled) end

    
    
    
    
    
    
    local _xrReapplyPending = false
    Players.PlayerAdded:Connect(function()
        if not _G.XRayEnabled then return end
        _xrReapplyPending = true
        task.spawn(function()
            task.wait(0.5)
            _xrReapplyPending = false
            if _G.XRayEnabled then pcall(setXRay, true) end
        end)
    end)

    
    task.spawn(function() setXRay(true) end)
end)

    warn("[XRAY] BLOC EN ERREUR: " .. tostring(errXR))
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "XRayError"; sg.ResetOnSpawn = false
        sg.Parent = (gethui and gethui()) or game:GetService("CoreGui")
        local t = Instance.new("TextLabel", sg)
        t.Size = UDim2.new(0, 460, 0, 44); t.Position = UDim2.new(0.5, -230, 0, 60)
        t.BackgroundColor3 = Color3.fromRGB(70, 12, 12)
        t.TextColor3 = Color3.new(1, 1, 1)
        t.Font = Enum.Font.GothamBold; t.TextSize = 11; t.TextWrapped = true
        t.Text = "XRAY ERREUR: " .. tostring(errXR)
    end)
end
end)

stagSpawn(function()
local okIJ, errIJ = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS        = game:GetService("UserInputService")
    local LP         = Players.LocalPlayer

    _G.InfiniteJumpEnabled = true
    local lastJump, conn = 0, nil

    local function setInfiniteJump(en)
        _G.InfiniteJumpEnabled = en
        if conn then conn:Disconnect(); conn = nil end
        conn = RunService.Heartbeat:Connect(function()
            if not _G.InfiniteJumpEnabled then return end
            if not UIS:IsKeyDown(Enum.KeyCode.Space) then return end
            local now = tick()
            if now - lastJump < 0.1 then return end
            local c = LP.Character
            local hrp = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            lastJump = now
            hrp.AssemblyLinearVelocity =
                Vector3.new(hrp.AssemblyLinearVelocity.X, 55, hrp.AssemblyLinearVelocity.Z)
        end)
    end
    _G.setInfiniteJump = setInfiniteJump

    setInfiniteJump(true)
end)

if not okIJ then warn("[INFJUMP] BLOC EN ERREUR: " .. tostring(errIJ)) end
end)

nowSpawn(function()
local okAR, errAR = pcall(function()
    local Players           = game:GetService("Players")
    local RunService        = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace         = workspace
    local player            = Players.LocalPlayer
    while not player do task.wait(); player = Players.LocalPlayer end

    
    local Config = { AntiRagdoll = false }
    local function setToggle() end
    local function saveConfig() end

    
    
        local antiRagdollConnections = {}
        local antiRagdollCharacter, antiRagdollHumanoid, antiRagdollRootPart, antiRagdollAnimator
        local lastVelocity = Vector3.new(0, 0, 0)
        local velocityChangeThreshold = 40
        local velocityMagnitudeThreshold = 25
        local maxVelocity = 15

        local function isFlyingCarpetActive()
            local tool = antiRagdollCharacter:FindFirstChildWhichIsA("Tool")
            local hrp = antiRagdollCharacter:FindFirstChild("HumanoidRootPart")
                for _, obj in ipairs(hrp:GetChildren()) do
                    if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                    end
                end
            end
        end

        local function isRagdolled()
            local state = antiRagdollHumanoid:GetState()
            return state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown
                or state == Enum.HumanoidStateType.GettingUp
        end

        local function enableAntiRagdollControls()
            pcall(function()
                local PlayerModule = player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10)
                require(PlayerModule):GetControls():Enable()
            end)
        end

        local function cleanupRagdoll()
            local carpetEquipped = isFlyingCarpetActive()

            local function processChildren(parent)
                for _, obj in ipairs(parent:GetChildren()) do
                    if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint")
                        or (obj:IsA("Attachment") and (obj.Name == "A" or obj.Name == "B")) then
                        obj:Destroy()
                    elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                        if not carpetEquipped then obj:Destroy() end
                    elseif obj:IsA("Motor6D") then
                        obj.Enabled = true
                    elseif obj:IsA("BasePart") then
                        for _, child in ipairs(obj:GetChildren()) do
                            if child:IsA("BallSocketConstraint") or child:IsA("NoCollisionConstraint") or child:IsA("HingeConstraint") or child:IsA("Motor6D") then
                                if child:IsA("Motor6D") then
                                    child.Enabled = true
                                    child:Destroy()
                                end
                            elseif child:IsA("Attachment") and (child.Name == "A" or child.Name == "B") then
                                child:Destroy()
                            end
                        end
                    end
                end
            end

            pcall(function() processChildren(antiRagdollCharacter) end)

                for _, track in pairs(antiRagdollAnimator:GetPlayingAnimationTracks()) do
                    local animName = track.Animation and track.Animation.Name:lower() or ""
                    if animName:find("rag") or animName:find("fall") or animName:find("hurt") or animName:find("down") then
                        track:Stop(0)
                    end
                end
            end
        end

        local function setupAntiRagdollCharacter(char)
            antiRagdollCharacter = char
            antiRagdollHumanoid = char:WaitForChild("Humanoid", 10)
            antiRagdollRootPart = char:WaitForChild("HumanoidRootPart", 10)
            antiRagdollAnimator = antiRagdollHumanoid and antiRagdollHumanoid:WaitForChild("Animator", 10)
            lastVelocity = Vector3.new(0, 0, 0)
        end

        local function clearAntiRagdollConnections()
            for _, c in pairs(antiRagdollConnections) do
                pcall(function() c:Disconnect() end)
            end
            antiRagdollConnections = {}
        end

        local function setupAntiRagdollConnections()
            clearAntiRagdollConnections()

            table.insert(antiRagdollConnections, antiRagdollHumanoid.StateChanged:Connect(function()
                if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and isRagdolled() then
                    if not isFlyingCarpetActive() then
                        antiRagdollHumanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                    cleanupRagdoll()
                    pcall(function() Workspace.CurrentCamera.CameraSubject = antiRagdollHumanoid end)
                    enableAntiRagdollControls()
                end
            end))

            
            pcall(function()
                if _G.MynxxGetRemote then
                    impulse = _G.MynxxGetRemote("RemoteEvent", "CombatService/ApplyImpulse")
                end
                    local pkgs = ReplicatedStorage:FindFirstChild("Packages")
                    local net  = pkgs and pkgs:FindFirstChild("Net")
                    impulse = net and net:FindFirstChild("RE/CombatService/ApplyImpulse")
                end
                    table.insert(antiRagdollConnections, impulse.OnClientEvent:Connect(function()
                        if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and isRagdolled() then
                            antiRagdollRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        end
                    end))
                end
            end)

            table.insert(antiRagdollConnections, antiRagdollCharacter.DescendantAdded:Connect(function()
                if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and isRagdolled() then
                    cleanupRagdoll()
                end
            end))

            table.insert(antiRagdollConnections, RunService.Heartbeat:Connect(function()
                if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and isRagdolled() then
                    
                    
                    if _G.MynxxStealHold then return end
                    if antiRagdollRootPart.AssemblyLinearVelocity.Magnitude > 60 then
                        lastVelocity = antiRagdollRootPart.AssemblyLinearVelocity
                        return
                    end
                    cleanupRagdoll()
                    local velocity = antiRagdollRootPart.AssemblyLinearVelocity
                    if (velocity - lastVelocity).Magnitude > velocityChangeThreshold
                        and velocity.Magnitude > velocityMagnitudeThreshold then
                        antiRagdollRootPart.AssemblyLinearVelocity = velocity.Unit * math.min(velocity.Magnitude, maxVelocity)
                    end
                    lastVelocity = velocity
                end
            end))

            enableAntiRagdollControls()
            cleanupRagdoll()
        end

        local function startAntiRagdoll()
            _G.AntiRagdollEnabled = true
            _G.antiKnockbackEnabled = true
            Config.AntiRagdoll = true; setToggle("Anti Ragdoll", true); saveConfig()
            if player.Character then
                setupAntiRagdollCharacter(player.Character)
                setupAntiRagdollConnections()
            end
        end

        local function stopAntiRagdoll()
            _G.AntiRagdollEnabled = false
            _G.antiKnockbackEnabled = false
            Config.AntiRagdoll = false; setToggle("Anti Ragdoll", false); saveConfig()
            clearAntiRagdollConnections()
        end

        _G.toggleAntiRagdoll = function(enabled)
            if enabled then startAntiRagdoll() else stopAntiRagdoll() end
        end
        _G.enableAntiKnockback = function() startAntiRagdoll() end
        _G.disableAntiKnockback = function() stopAntiRagdoll() end

        player.CharacterAdded:Connect(function(char)
            clearAntiRagdollConnections()
            antiRagdollCharacter = nil; antiRagdollHumanoid = nil; antiRagdollRootPart = nil; antiRagdollAnimator = nil
            local humanoid = char:WaitForChild("Humanoid", 10)
            local rootPart = char:WaitForChild("HumanoidRootPart", 10)
            task.wait(0.2)
            setupAntiRagdollCharacter(char)
            if _G.AntiRagdollEnabled or _G.antiKnockbackEnabled then
                setupAntiRagdollConnections()
            end
        end)

        if player.Character then
            setupAntiRagdollCharacter(player.Character)
            if _G.AntiRagdollEnabled or _G.antiKnockbackEnabled then
                setupAntiRagdollConnections()
            end
        end
    end

    
    if _G.toggleAntiRagdoll then _G.toggleAntiRagdoll(true) end
end)

if not okAR then warn("[ANTIRAGDOLL] BLOC EN ERREUR: " .. tostring(errAR)) end
end)

nowSpawn(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local NO_COLLIDE_GROUP = "PlayerNoCollision"

    local function applyChar(char)
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 10)
        local function setPart(part)
            if part:IsA("BasePart") and part.Name ~= "__HITBOX" then
                pcall(function() part.CollisionGroup = NO_COLLIDE_GROUP end)
            end
        end
        for _, part in ipairs(char:GetDescendants()) do setPart(part) end
        char.DescendantAdded:Connect(setPart)
    end

    if LocalPlayer.Character then task.spawn(applyChar, LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(applyChar)
end)

nowSpawn(function()
local okAG, errAG = pcall(function()
    local cloneref = (type(cloneref) == "function" and cloneref) or function(o) return o end
    local Players   = cloneref(game:GetService("Players"))
    local Workspace = cloneref(game:GetService("Workspace"))
    local Player    = Players.LocalPlayer

    local antiGummy = true
    local antiGummyRespawnGraceUntil = 0

    Player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        antiGummyRespawnGraceUntil = tick() + 1.5
    end)

    local function clearGummyToolBlockState(char)
        for _, inst in ipairs({ Player, char }) do
                if inst:GetAttribute("BlockTools") ~= nil and inst:GetAttribute("BlockTools") ~= false then
                    inst:SetAttribute("BlockTools", false)
                end
                if inst:GetAttribute("Web") ~= nil and inst:GetAttribute("Web") ~= false then
                    inst:SetAttribute("Web", false)
                end
            end
        end
        if char and char:GetAttribute("BackpackReady") == false then
            char:SetAttribute("BackpackReady", true)
        end
    end

    local function deleteGummyBears()
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "GummyBear" then
                pcall(function() obj:Destroy() end)
            end
        end
    end

    Workspace.ChildAdded:Connect(function(child)
        if antiGummy and child.Name == "GummyBear" then
            pcall(function() child:Destroy() end)
        end
    end)

    task.spawn(function()
        while task.wait(0.1) do
            local char = Player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if tick() >= antiGummyRespawnGraceUntil then
                clearGummyToolBlockState(char)
            end
        end
    end)

    deleteGummyBears()

    _G.AntiGummy = {
        set = function(on)
            antiGummy = on and true or false
            if antiGummy then deleteGummyBears() end
        end,
    }
end)
if not okAG then warn("[ANTI-GUMMY] BLOC EN ERREUR: " .. tostring(errAG)) end
end)

stagSpawn(function()
    _G.CleanErrorGUIs = true
        pcall(function() GS = cloneref(game:GetService("GuiService")) end)
    end
    GS = GS or game:GetService("GuiService")
    task.spawn(function()
            if _G.CleanErrorGUIs then pcall(function() GS:ClearError() end) end
            task.wait(1)
        end
    end)
end)

nowSpawn(function()
local okCC, errCC = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS        = game:GetService("UserInputService")
    local HS         = game:GetService("HttpService")
    local LP         = Players.LocalPlayer
    local PG         = LP:WaitForChild("PlayerGui")
    local guiParent  = (gethui and gethui()) or game:GetService("CoreGui") or PG

    
    
    
    local SPEED_BOOST_TOOL_NAMES = {
        ["Flying Carpet"] = true, ["Carpet"] = true, ["Cloud"] = true,
        ["Witch's Broom"] = true, ["Cupid's Wings"] = true, ["Santa's Sleigh"] = true,
        ["Magic Carpet"] = true, ["Waverider"] = true,
    }

    
    local carpetOn, carpetConn, toolConn = false, nil, nil

    local function preferredTool()
        local t = _G.MynxxCarpetTool
        if type(t) == "string" and t ~= "" then return t end
        return "Flying Carpet"
    end

    local function isSpeedBoostTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        if SPEED_BOOST_TOOL_NAMES[tool.Name] then return true end
        return tool.Name == preferredTool()
    end

    local function getEquippedTool(char)
        return char:FindFirstChildWhichIsA("Tool")
    end

    local function equipSpeedBoostToolOnce(c, hum)
        local bp = LP:FindFirstChild("Backpack")
        local pref = preferredTool()
        if c:FindFirstChild(pref) then return pref end
        local tb = bp and bp:FindFirstChild(pref)
        if tb then pcall(function() hum:EquipTool(tb) end); return pref end
        for name in pairs(SPEED_BOOST_TOOL_NAMES) do
            if c:FindFirstChild(name) then return name end
            local t = bp and bp:FindFirstChild(name)
            if t then pcall(function() hum:EquipTool(t) end); return name end
        end
    end

    
    
    local function isCarpetSpeedBlocked()
        if _G._isTpMoving then return true end
        if _G.MynxxStealHold then return true end
        if LP:GetAttribute("Stealing") then return true end
    end
    _G.isCarpetSpeedBlocked = isCarpetSpeedBlocked

    setCarpetSpeed = function(en)
        if en and isCarpetSpeedBlocked() then return end
        carpetOn = en
        if refreshUI then refreshUI() end
        if carpetConn then carpetConn:Disconnect(); carpetConn = nil end

        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if c and hum then equipSpeedBoostToolOnce(c, hum) end

        carpetConn = RunService.Heartbeat:Connect(function()
            local ch = LP.Character
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if isCarpetSpeedBlocked() then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                end
                return
            end
            local hm = ch:FindFirstChildOfClass("Humanoid")
            local equipped = getEquippedTool(ch)
            
            if equipped and not isSpeedBoostTool(equipped) then
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                setCarpetSpeed(false)
                return
            end
            if equipped and isSpeedBoostTool(equipped) then
                local md = hm.MoveDirection
                if md.Magnitude > 0 then
                    hrp.AssemblyLinearVelocity =
                        Vector3.new(md.X * 140, hrp.AssemblyLinearVelocity.Y, md.Z * 140)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                end
            end
        end)
    end
    _G.setCarpetSpeed = setCarpetSpeed
    _G.toggleCarpetSpeed = function() setCarpetSpeed(not carpetOn) end

    local function stopFromToolSwitch(char)
        local equipped = getEquippedTool(char)
        if equipped and not isSpeedBoostTool(equipped) then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0) end
            setCarpetSpeed(false)
        end
    end
    local function bindToolWatch(char)
        if toolConn then pcall(function() toolConn:Disconnect() end); toolConn = nil end
        toolConn = char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.defer(function() stopFromToolSwitch(char) end)
            end
        end)
    end

    LP.CharacterAdded:Connect(function(char)
        bindToolWatch(char)
            task.defer(function()
                local hum = char:WaitForChild("Humanoid", 10)
                if hum and carpetOn then equipSpeedBoostToolOnce(char, hum) end
            end)
        end
    end)
    if LP.Character then bindToolWatch(LP.Character) end

    
    
    
    local function instantClone()
        local c = LP.Character
        local h = c:FindFirstChildOfClass("Humanoid")
        local bp = LP:FindFirstChild("Backpack")
        local cl = (bp and bp:FindFirstChild("Quantum Cloner")) or c:FindFirstChild("Quantum Cloner")
        pcall(function() h:UnequipTools() end); task.wait()
        if cl.Parent ~= c then pcall(function() h:EquipTool(cl) end); task.wait() end
        local tf = PG:FindFirstChild("ToolsFrames")
        local qc = tf and tf:FindFirstChild("QuantumCloner")
        local tb = qc and qc:FindFirstChild("TeleportToClone")
        _G.isCloning = true
        pcall(function() cl:Activate() end)
        task.wait(0.05)
        tb.Visible = true
        pcall(function() firesignal(tb.MouseButton1Click) end)
        pcall(function() firesignal(tb.MouseButton1Up) end)
        pcall(function() firesignal(tb.Activated) end)
        task.delay(0.55, function() _G.isCloning = false end)
    end
    _G.instantClone = instantClone

    
    
    
    
    
    
    
    local floatOn, floatPart, floatConn = false, nil, nil

    local function removeFloatPlatform()
        if floatConn then floatConn:Disconnect(); floatConn = nil end
        if floatPart then pcall(function() floatPart:Destroy() end); floatPart = nil end
    end

    local function createFloatPlatform()
        removeFloatPlatform()
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local p = Instance.new("Part")
        p.Size = Vector3.new(7, 1, 7)
        p.Anchored = true; p.CanCollide = true
        p.CanTouch = false; p.CanQuery = false
        p.Transparency = 1; p.CastShadow = false
        p.CFrame = CFrame.new(hrp.Position - Vector3.new(0, 3.35, 0))
        p.Parent = workspace
        floatPart = p
        floatConn = RunService.Heartbeat:Connect(function()
            local ch = LP.Character
            local h = ch and ch:FindFirstChild("HumanoidRootPart")
                floatPart.CFrame = CFrame.new(h.Position - Vector3.new(0, 3.35, 0))
            end
        end)
    end

    local function setFloat(on)
        
        if on and LP:GetAttribute("Stealing") then
            if refreshUI then refreshUI() end
            return
        end
        floatOn = on
        if on then createFloatPlatform() else removeFloatPlatform() end
        if refreshUI then refreshUI() end
    end
    _G.setFloat = setFloat
    _G.toggleFloat = function() setFloat(not floatOn) end

    
    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        if floatOn and LP:GetAttribute("Stealing") then setFloat(false) end
    end)
    
    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if floatOn then removeFloatPlatform(); createFloatPlatform() end
    end)

    
    
    
    local kbCfg = _G.HubCfg.get("carpet")
    local binds = {
        { id = "carpet", label = "Carpet Speed",
          key = (type(_G.MynxxCarpetSpeedKeyName) == "string" and _G.MynxxCarpetSpeedKeyName) or "Q",
          run = function() setCarpetSpeed(not carpetOn) end },
        { id = "instreset", label = "Instant Reset",
          key = (type(_G.MynxxResetKeyName) == "string" and _G.MynxxResetKeyName ~= "" and _G.MynxxResetKeyName) or "R",
          run = function() if _G.InstantReset then task.spawn(_G.InstantReset) end end },
        { id = "clone",  label = "Instant Clone",
          key = (type(_G.MynxxCloneKeyName) == "string" and _G.MynxxCloneKeyName) or "V",
          run = function() task.spawn(instantClone) end },
        { id = "float",  label = "Float", key = "Z",
          run = function() setFloat(not floatOn) end },
        
        
        
        { id = "reset",  label = "Fling Up", key = "X",
          run = function() if _G.FlingUp then task.spawn(_G.FlingUp) end end },
        { id = "invis",  label = "Invisible Steal", key = "U",
          run = function() if _G.toggleInvisibleSteal then pcall(_G.toggleInvisibleSteal) end end },
        { id = "walkspeed", label = "WalkSpeed", key = "H",
          run = function()
              if _G.setWalkSpeedEnabled then
                  _G.MynxxWSEnabled = not _G.MynxxWSEnabled
                  _G.setWalkSpeedEnabled(_G.MynxxWSEnabled)
              end
          end },
        { id = "drop",   label = "Drop Brainrot", key = "G",
          run = function() if _G.MynxxDropBrainrot then pcall(_G.MynxxDropBrainrot) end end },
        { id = "faceaway", label = "Face Away", key = "F",
          run = function() if _G.MynxxToggleFaceAway then pcall(_G.MynxxToggleFaceAway) end end },
        { id = "kick",   label = "Leave Game", key = "Y",
          run = function() if _G.MynxxKick then pcall(_G.MynxxKick) end end },
        { id = "autobuy", label = "Auto Buy", key = "K",
          run = function() if _G.MynxxToggleAutoBuy then pcall(_G.MynxxToggleAutoBuy) end end },
        { id = "menu",   label = "Main Menu", key = "LeftControl",
          run = function()
              if _G.XyntrixOpenMainMenu then pcall(_G.XyntrixOpenMainMenu)
              elseif panelFrame then panelFrame.Visible = not panelFrame.Visible end
          end },
        { id = "hidegui", label = "Hide GUIs…", key = "RightControl",
          run = function() if _G.XyntrixOpenHideGuiPanel then pcall(_G.XyntrixOpenHideGuiPanel) elseif _G.XyntrixToggleHideGuis then pcall(_G.XyntrixToggleHideGuis) end end },
        { id = "savecfg", label = "Save Config", key = "P",
          run = function() if _G.XyntrixSaveConfig then pcall(_G.XyntrixSaveConfig) end end },
        { id = "infjump", label = "Inf Jump", key = "J",
          run = function()
              _G.XyntrixInfJump = not _G.XyntrixInfJump
              if _G.XyntrixSetInfJump then pcall(_G.XyntrixSetInfJump, _G.XyntrixInfJump) end
          end },
        { id = "opendoor", label = "Open Door", key = "O",
          run = function()
              _G.AutoUnlockOnSteal = not _G.AutoUnlockOnSteal
              pcall(function()
                  if _G.HubCfg then
                      local sec = _G.HubCfg.get("xyntrix")
                      sec.autoUnlockOnSteal = _G.AutoUnlockOnSteal
                      _G.HubCfg.save()
                  end
              end)
          end },
    }
    local panelX, panelY = 240, 120

        for _, b in ipairs(binds) do
            if type(kbCfg[b.id]) == "string" and #kbCfg[b.id] > 0 then b.key = kbCfg[b.id] end
        end
        
        
        if tonumber(kbCfg.x) then panelX = tonumber(kbCfg.x) end
        if tonumber(kbCfg.y) then panelY = tonumber(kbCfg.y) end
        
        if tonumber(kbCfg.buyRange) then
            local r = math.clamp(math.floor(tonumber(kbCfg.buyRange)), 5, 150)
            _G.MynxxAutoBuyFireRange = r
            _G.MynxxAutoBuyRange     = r
        end
    end
    local function saveKb()
        kbCfg.x = panelX; kbCfg.y = panelY
        for _, b in ipairs(binds) do kbCfg[b.id] = b.key end
        _G.HubCfg.save()
    end

    local capturing = nil

    
    
    
    
    
    
    local VK_XBUTTON1, VK_XBUTTON2 = 0x05, 0x06
    local function _norm(s)
        if type(s) ~= "string" or s == "" then return nil end
        if string.find(s, ":", 1, true) then return s end
        return "Key:" .. s
    end
    local function _bindPretty(s)
        local n = _norm(s); if not n then return "NONE" end
        local kind, name = string.match(n, "^([^:]+):(.+)$")
        if kind == "Mouse" then
            local map = { MouseButton1="MB1", MouseButton2="MB2", MouseButton3="MB3",
                          MouseButton4="MB4", XButton1="MB4", MouseButton5="MB5", XButton2="MB5" }
            return map[name] or name
        end
    end
    local function _isMouseBtn(input)
        local nm = input.UserInputType and input.UserInputType.Name
        return nm == "MouseButton1" or nm == "MouseButton2" or nm == "MouseButton3"
            or nm == "MouseButton4" or nm == "MouseButton5"
    end
    local function _inputMatches(input, bind)
        bind = _norm(bind); if not bind then return false end
        local kind, name = string.match(bind, "^([^:]+):(.+)$")
        if kind == "Key" then
            return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == name
        elseif kind == "Mouse" then
            return input.UserInputType.Name == name
        end
    end
    local function _vkDown(vk)
        for _, fn in ipairs({ iskeydown, iskeypressed }) do
            if typeof(fn) == "function" then local ok, r = pcall(fn, vk); if ok and r then return true end end
        end
        if typeof(getkeystate) == "function" then
            local ok, r = pcall(getkeystate, vk)
                if r == true then return true end
                if type(r) == "number" and (r < 0 or (bit32 and bit32.band(r, 0x8000) ~= 0)) then return true end
            end
        end
    end
    local function _sideDown(side)
        local name = "MouseButton" .. tostring(side)
        local ok, uit = pcall(function() return Enum.UserInputType[name] end)
        if ok and uit then local ok2, p = pcall(function() return UIS:IsMouseButtonPressed(uit) end); if ok2 and p then return true end end
        local okk, kc = pcall(function() return Enum.KeyCode[name] end)
            local ok2, p = pcall(function() return UIS:IsKeyDown(kc) end); if ok2 and p then return true end
            if typeof(iskeydown) == "function" then local ok3, p3 = pcall(iskeydown, kc); if ok3 and p3 then return true end end
        end
        return _vkDown(side == 5 and VK_XBUTTON2 or VK_XBUTTON1)
    end
    local function _bindIsSide(bind, side)
        bind = _norm(bind); if not bind then return false end
        local want = "Mouse:MouseButton" .. tostring(side)
        if bind == want then return true end
        if side == 4 and (bind == "Mouse:XButton1" or bind == "Mouse:MB4") then return true end
        if side == 5 and (bind == "Mouse:XButton2" or bind == "Mouse:MB5") then return true end
    end
    
    local function _onSide(side)
            local b = capturing; capturing = nil
            b.key = "Mouse:MouseButton" .. tostring(side); saveKb()
            if b.refresh then b.refresh() end
            return
        end
        for _, b in ipairs(binds) do
            if _bindIsSide(b.key, side) then b.run(); if b.refresh then b.refresh() end; return end
        end
    end

    UIS.InputBegan:Connect(function(input, gameProcessed)
        
        
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local b = capturing; capturing = nil
                local nm = input.KeyCode.Name
                if nm ~= "Escape" then b.key = "Key:" .. nm; saveKb() end
                if b.refresh then b.refresh() end
            elseif _isMouseBtn(input) and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                local b = capturing; capturing = nil
                b.key = "Mouse:" .. input.UserInputType.Name; saveKb()
                if b.refresh then b.refresh() end
            end
            return
        end
        
        for _, b in ipairs(binds) do
            if not (_bindIsSide(b.key, 4) or _bindIsSide(b.key, 5)) and _inputMatches(input, b.key) then
                
                
                if b.id ~= "reset" and b.id ~= "menu" and gameProcessed then return end
                b.run()
                return
            end
        end
    end)

    
    
        local prev4, prev5 = false, false
        game:GetService("RunService").Heartbeat:Connect(function()
            local need = capturing ~= nil
                for _, b in ipairs(binds) do
                    if _bindIsSide(b.key, 4) or _bindIsSide(b.key, 5) then need = true; break end
                end
            end
            if not need then prev4, prev5 = false, false; return end
            local d4, d5 = _sideDown(4), _sideDown(5)
            if d4 and not prev4 then _onSide(4) end
            if d5 and not prev5 then _onSide(5) end
            prev4, prev5 = d4, d5
        end)
    end

    
    pcall(function()
        local old = guiParent:FindFirstChild("CarpetCloneUI")
        if old then old:Destroy() end
    end)
    local sg = Instance.new("ScreenGui")
    sg.Name = "CarpetCloneUI"; sg.ResetOnSpawn = false; sg.DisplayOrder = 129
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = PG end

    local f = Instance.new("Frame", sg)
    local _kbH = 26 + #binds * 28 + 130
    f.Size = UDim2.fromOffset(236, math.min(_kbH, 440))
    _G.MynxxCenterPanel(f, 220, math.min(_kbH, 400))
    panelFrame = f
    _G.XyntrixKeybindPanel = f
    f.Visible = false

    
        local gearGui = Instance.new("ScreenGui")
        gearGui.Name = "MynxxGearIcon"; gearGui.ResetOnSpawn = false
        gearGui.IgnoreGuiInset = true; gearGui.DisplayOrder = 130
        pcall(function() gearGui.Parent = guiParent end)
        if not gearGui.Parent then gearGui.Parent = PG end
        local gear = Instance.new("TextButton", gearGui)
        gear.Size = UDim2.fromOffset(34, 34)
                gear.Position = UDim2.new(1, -44, 0, 10)
        gear.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
        gear.BackgroundTransparency = 0.05
        gear.Text = "\u{2699}"
        gear.TextColor3 = Color3.fromRGB(160, 210, 255)
        gear.Font = Enum.Font.GothamBold; gear.TextSize = 20
        gear.AutoButtonColor = true; gear.BorderSizePixel = 0
        Instance.new("UICorner", gear).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", gear)
        st.Color = Color3.fromRGB(90, 170, 255); st.Transparency = 0.3; st.Thickness = 1.3
gear.MouseButton1Click:Connect(function()
            
            if _G.XyntrixOpenMainMenu then
                pcall(_G.XyntrixOpenMainMenu)
                panelFrame.Visible = not panelFrame.Visible
            end
        end)
    end
    f.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    f.BorderSizePixel = 0; f.Active = true; f.Draggable = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local pending = false
        f:GetPropertyChangedSignal("Position"):Connect(function()
            pending = true
            task.delay(0.5, function()
                pending = false
                panelX, panelY = f.AbsolutePosition.X, f.AbsolutePosition.Y
                saveKb()
            end)
        end)
    end

    local ttl = Instance.new("TextLabel", f)
    ttl.Size = UDim2.new(1, 0, 0, 22); ttl.BackgroundTransparency = 1
    ttl.Text = "Xyntrix · Keybinds"; ttl.Font = Enum.Font.GothamBlack
    pcall(_G.XyntrixStylePanel, f); pcall(_G.XyntrixStyleTitle, ttl); task.defer(_G.XyntrixPolish, f)
    ttl.TextSize = 12; ttl.TextColor3 = Color3.new(1, 1, 1)
    ttl.ZIndex = 2

    
    local scroll = Instance.new("ScrollingFrame", f)
    scroll.Name = "BindsScroll"
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Position = UDim2.fromOffset(4, 24)
    scroll.Size = UDim2.new(1, -8, 1, -108)
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = Color3.fromRGB(90, 170, 255)
    scroll.CanvasSize = UDim2.fromOffset(0, #binds * 28 + 8)
    scroll.ZIndex = 2

    for i, b in ipairs(binds) do
        local y = 4 + (i - 1) * 28
        
        local act = Instance.new("TextButton", scroll)
        act.BackgroundColor3 = Color3.fromRGB(24, 32, 48)
        act.Position = UDim2.fromOffset(4, y)
        act.Size = UDim2.new(1, -84, 0, 24)
        act.Font = Enum.Font.GothamBold
        act.TextSize = 11
        act.TextColor3 = Color3.fromRGB(245, 248, 255)
        act.TextXAlignment = Enum.TextXAlignment.Left
        act.Text = "  " .. b.label
        act.BorderSizePixel = 0
        act.AutoButtonColor = true
        act.ZIndex = 3
        Instance.new("UICorner", act).CornerRadius = UDim.new(0, 6)

        
        local kb = Instance.new("TextButton", scroll)
        kb.Size = UDim2.fromOffset(68, 24)
        kb.Position = UDim2.new(1, -76, 0, y)
        kb.TextColor3 = Color3.new(1, 1, 1)
        kb.Font = Enum.Font.GothamBold
        kb.TextSize = 11
        kb.BorderSizePixel = 0
        kb.ZIndex = 3
        Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 6)

        b.refresh = function()
            kb.Text = _bindPretty(b.key)
            local on = (b.id == "carpet" and carpetOn) or (b.id == "float" and floatOn)
                or (b.id == "faceaway" and _G.MynxxFaceAwayOn == true)
                or (b.id == "infjump" and _G.XyntrixInfJump == true)
                or (b.id == "opendoor" and _G.AutoUnlockOnSteal == true)
            kb.BackgroundColor3 = on and Color3.fromRGB(45, 130, 255) or Color3.fromRGB(32, 40, 55)
            act.BackgroundColor3 = on and Color3.fromRGB(30, 70, 140) or Color3.fromRGB(24, 32, 48)
            act.Text = "  " .. b.label .. (on and "  · ON" or "")
        end
        b.refresh()

        act.MouseButton1Click:Connect(function()
            pcall(b.run)
            for _, bb in ipairs(binds) do if bb.refresh then bb.refresh() end end
        end)

        kb.MouseButton1Click:Connect(function()
            if capturing and capturing.refresh then capturing.refresh() end
            capturing = b
            kb.Text = "..."
            kb.BackgroundColor3 = Color3.fromRGB(120, 90, 30)
        end)
    end

    
    
    
    local ay = 26 + #binds * 26 + 6

    
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency = 1
        l.AnchorPoint = Vector2.new(0, 1)
        l.Position = UDim2.new(0, 10, 1, -96)
        l.Size = UDim2.fromOffset(118, 20)
        l.Font = Enum.Font.Gotham; l.TextSize = 11
        l.TextColor3 = Color3.fromRGB(210, 210, 210)
        l.TextXAlignment = Enum.TextXAlignment.Left
        local function txt() l.Text = "FOV: " .. tostring(math.floor((tonumber(_G.MynxxFOV) or 70) + 0.5)) end
        local function mk(px, d, sym)
            local b = Instance.new("TextButton", f)
            b.Size = UDim2.fromOffset(24, 20)
            b.AnchorPoint = Vector2.new(0, 1)
            b.Position = UDim2.new(0, px, 1, -96)
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 50); b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.GothamBold; b.TextSize = 14; b.Text = sym; b.BorderSizePixel = 0
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
            b.MouseButton1Click:Connect(function()
                if _G.setFOV then _G.setFOV((tonumber(_G.MynxxFOV) or 70) + d * 5) end
                txt(); saveKb()
            end)
        end
        mk(132, -1, "-"); mk(180, 1, "+"); txt()
    end

    
    
    
    
    
    
        local AB_MIN, AB_MAX = 5, 150
        local R0 = tonumber(kbCfg.buyRange)
        if not R0 then R0 = 60 end
        R0 = math.clamp(math.floor(R0), AB_MIN, AB_MAX)

        local lbl = Instance.new("TextLabel", f)
        lbl.BackgroundTransparency = 1
        lbl.AnchorPoint = Vector2.new(0, 1)
        lbl.Position = UDim2.new(0, 10, 1, -68)
        lbl.Size = UDim2.fromOffset(194, 16)
        lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11
        lbl.TextColor3 = Color3.fromRGB(210, 210, 210)
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        
        
        local hit = Instance.new("TextButton", f)
        hit.Text = ""; hit.AutoButtonColor = false; hit.BackgroundTransparency = 1
        hit.AnchorPoint = Vector2.new(0, 1)
        hit.Position = UDim2.new(0, 10, 1, -48)
        hit.Size = UDim2.fromOffset(194, 20)
        hit.BorderSizePixel = 0

        local bar = Instance.new("Frame", hit)
        bar.AnchorPoint = Vector2.new(0, 0.5)
        bar.Position = UDim2.new(0, 0, 0.5, 0); bar.Size = UDim2.fromOffset(194, 6)
        bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45); bar.BorderSizePixel = 0
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", bar)
        fill.BackgroundColor3 = Color3.fromRGB(45, 130, 255); fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame", bar)
        knob.Size = UDim2.fromOffset(12, 12); knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.BackgroundColor3 = Color3.fromRGB(235, 235, 240); knob.BorderSizePixel = 0
        knob.ZIndex = 2
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local function paint(v)
            local pct = (v - AB_MIN) / (AB_MAX - AB_MIN)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.Position = UDim2.new(pct, 0, 0.5, 0)
            lbl.Text = "Buy Range: " .. v .. " studs"
        end
        local function apply(v, persist)
            v = math.clamp(math.floor(v + 0.5), AB_MIN, AB_MAX)
            _G.MynxxAutoBuyFireRange = v
            _G.MynxxAutoBuyRange     = v
            paint(v)
            if persist then kbCfg.buyRange = v; pcall(_G.HubCfg.save) end
        end
        apply(R0, false)

        local dragging = false
        local function fromX(px)
            local rel = (px - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1)
            apply(AB_MIN + math.clamp(rel, 0, 1) * (AB_MAX - AB_MIN), true)
        end
        hit.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; fromX(input.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                fromX(input.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    
    
    
        local XR_MIN, XR_MAX = 0, 100
        
        local a0 = tonumber(kbCfg.xrayAlpha)
        if not a0 then a0 = tonumber(_G.XRayAlpha) or 0.60 end
        local P0 = math.clamp(math.floor(a0 * 100 + 0.5), XR_MIN, XR_MAX)

        local lbl = Instance.new("TextLabel", f)
        lbl.BackgroundTransparency = 1
        lbl.AnchorPoint = Vector2.new(0, 1)
        lbl.Position = UDim2.new(0, 10, 1, -32)
        lbl.Size = UDim2.fromOffset(194, 16)
        lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11
        lbl.TextColor3 = Color3.fromRGB(210, 210, 210)
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local hit = Instance.new("TextButton", f)
        hit.Text = ""; hit.AutoButtonColor = false; hit.BackgroundTransparency = 1
        hit.AnchorPoint = Vector2.new(0, 1)
        hit.Position = UDim2.new(0, 10, 1, -12)
        hit.Size = UDim2.fromOffset(194, 20)
        hit.BorderSizePixel = 0

        local bar = Instance.new("Frame", hit)
        bar.AnchorPoint = Vector2.new(0, 0.5)
        bar.Position = UDim2.new(0, 0, 0.5, 0); bar.Size = UDim2.fromOffset(194, 6)
        bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45); bar.BorderSizePixel = 0
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", bar)
        fill.BackgroundColor3 = Color3.fromRGB(45, 130, 255); fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame", bar)
        knob.Size = UDim2.fromOffset(12, 12); knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.BackgroundColor3 = Color3.fromRGB(235, 235, 240); knob.BorderSizePixel = 0
        knob.ZIndex = 2
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local function paint(p)
            local pct = (p - XR_MIN) / (XR_MAX - XR_MIN)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.Position = UDim2.new(pct, 0, 0.5, 0)
            lbl.Text = "X-Ray: " .. p .. "%"
        end

        
        local reapplyPending = false
        local function scheduleReapply()
            reapplyPending = true
            task.delay(0.12, function()
                reapplyPending = false
                if type(_G.setXRay) == "function" and _G.XRayEnabled then
                    pcall(_G.setXRay, true)
                end
            end)
        end

        local function apply(p, persist)
            p = math.clamp(math.floor(p + 0.5), XR_MIN, XR_MAX)
            _G.XRayAlpha = p / 100
            paint(p)
            scheduleReapply()
            if persist then kbCfg.xrayAlpha = _G.XRayAlpha; pcall(_G.HubCfg.save) end
        end
        
        
        _G.XRayAlpha = P0 / 100
        paint(P0)
        scheduleReapply()

        local dragging = false
        local function fromX(px)
            local rel = (px - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1)
            apply(XR_MIN + math.clamp(rel, 0, 1) * (XR_MAX - XR_MIN), true)
        end
        hit.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; fromX(input.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                fromX(input.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    refreshUI = function()
        for _, b in ipairs(binds) do if b.refresh then pcall(b.refresh) end end
    end

end)

if not okCC then warn("[CARPET/CLONE] BLOC EN ERREUR: " .. tostring(errCC)) end
end)

stagSpawn(function()
local okZ, errZ = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    _G.UnlockZoom = true

    local _zoomLast = 0
    RunService.RenderStepped:Connect(function()
        if not _G.UnlockZoom then return end
        
        
        local now = os.clock()
        if now - _zoomLast < 0.4 then return end
        _zoomLast = now
        pcall(function()
            if LP.CameraMaxZoomDistance ~= 128 then
                LP.CameraMaxZoomDistance = 128
            end
            if LP.CameraMinZoomDistance > 0.5 then
                LP.CameraMinZoomDistance = 0.5
            end
            if LP.DevCameraOcclusionMode ~= Enum.DevCameraOcclusionMode.Invisicam then
                LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
            end
        end)
    end)
end)

if not okZ then warn("[ZOOM] BLOC EN ERREUR: " .. tostring(errZ)) end
end)

stagSpawn(function()
local okAK, errAK = pcall(function()
    local Players         = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")
    local HS              = game:GetService("HttpService")
    local LP              = Players.LocalPlayer
    local PG              = LP:WaitForChild("PlayerGui")
    local guiParent       = (gethui and gethui()) or game:GetService("CoreGui") or PG

    local cfg = _G.HubCfg.get("autokick")
    if _G.AutoKickOnSteal == nil then _G.AutoKickOnSteal = true end
    if _G.AutoKickKeyword == nil then _G.AutoKickKeyword = "you stole" end
    if _G.MynxxPrivateCode == nil then _G.MynxxPrivateCode = "" end
    
    
    _G.MynxxKickAfterBuy = true
    local panelX, panelY = 240, 300
        if type(cfg.on) == "boolean" then _G.AutoKickOnSteal = cfg.on end
        if tonumber(cfg.x) then panelX = tonumber(cfg.x) end
        if tonumber(cfg.y) then panelY = tonumber(cfg.y) end
        if type(cfg.psCode) == "string" then _G.MynxxPrivateCode = cfg.psCode end
    end
    local function saveCfg()
        cfg.on = _G.AutoKickOnSteal; cfg.x = panelX; cfg.y = panelY
        cfg.psCode = _G.MynxxPrivateCode
        _G.HubCfg.save()
    end

    
    
    
    local fired = false
    local function doKick()
        fired = true
        
        
        local code = _G.MynxxPrivateCode
        if type(code) == "string" and code ~= "" then
            task.delay(0.2, function()
                pcall(function()
                    game:GetService("ExperienceService"):LaunchExperience({
                        placeId = game.PlaceId,
                        linkCode = code,
                    })
                end)
            end)
            return
        end
        if _G.MynxxKick then
            pcall(_G.MynxxKick)
            pcall(function() _G.AntiDieDisabled = true end)
            pcall(function() game:Shutdown() end)
            pcall(function() LP:Kick("") end)
        end
    end
    
    _G.MynxxDoAutoKick = doKick

    local function check(txt)
        if not _G.AutoKickOnSteal then return end
        if type(txt) ~= "string" or txt == "" then return end
        local kw = tostring(_G.AutoKickKeyword or "you stole")
        if string.find(string.lower(txt), kw, 1, true) then doKick() end
    end

    local hooked = setmetatable({}, { __mode = "k" })
    local function hookObj(obj)
        if hooked[obj] then return end
        hooked[obj] = true
        check(obj.Text)
        obj:GetPropertyChangedSignal("Text"):Connect(function() check(obj.Text) end)
    end

    local function isText(o)
        return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")
    end

    local function watchRoot(root)
        for _, obj in ipairs(root:GetDescendants()) do
            if isText(obj) then hookObj(obj) end
        end
        root.DescendantAdded:Connect(function(desc)
            if isText(desc) then hookObj(desc) end
        end)
    end

    for _, g in ipairs(PG:GetChildren()) do pcall(watchRoot, g) end
    PG.ChildAdded:Connect(function(g) pcall(watchRoot, g) end)

    
    
    
    local function rejoin()
        local jobId = game.JobId
        task.spawn(function()
            if not jobId or jobId == "" then return end
            for _ = 1, 4 do
                local ok = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LP)
                end)
                task.wait(1.5)
            end
        end)
    end
    _G.Rejoin = rejoin

    
    
    
    pcall(function()
        local old = guiParent:FindFirstChild("AutoKickUI")
        if old then old:Destroy() end
    end)
    local sg = Instance.new("ScreenGui")
    sg.Name = "AutoKickUI"; sg.ResetOnSpawn = false; sg.DisplayOrder = 131
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = PG end

    local f = Instance.new("Frame", sg)
    f.Size = UDim2.fromOffset(180, 148)
    _G.MynxxCenterPanel(f, 160, 136)
    f.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    f.BorderSizePixel = 0; f.Active = true; f.Draggable = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local pending = false
        f:GetPropertyChangedSignal("Position"):Connect(function()
            pending = true
            task.delay(0.5, function()
                pending = false
                panelX, panelY = f.AbsolutePosition.X, f.AbsolutePosition.Y
                saveCfg()
            end)
        end)
    end

    local ttl = Instance.new("TextLabel", f)
    ttl.Size = UDim2.new(1, 0, 0, 22); ttl.BackgroundTransparency = 1
    ttl.Text = "Xyntrix · Auto Kick"; ttl.Font = Enum.Font.GothamBlack
    ttl.TextSize = 12; ttl.TextColor3 = Color3.new(1, 1, 1)
    pcall(_G.XyntrixStylePanel, f); pcall(_G.XyntrixStyleTitle, ttl); task.defer(_G.XyntrixPolish, f)

    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(1, -44, 0, 24); b.Position = UDim2.fromOffset(8, 26)
    b.Font = Enum.Font.GothamBold; b.TextSize = 11
    b.TextColor3 = Color3.new(1, 1, 1); b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    local function refresh()
        b.Text = "AUTO KICK" .. (_G.AutoKickOnSteal and ": ON" or ": OFF")
        b.BackgroundColor3 = _G.AutoKickOnSteal and Color3.fromRGB(45, 130, 255)
                                                 or Color3.fromRGB(45, 45, 45)
    end
    b.MouseButton1Click:Connect(function()
        _G.AutoKickOnSteal = not _G.AutoKickOnSteal
        refresh(); saveCfg()
    end)
    refresh()

    local rb = Instance.new("TextButton", f)
    rb.Size = UDim2.new(1, -16, 0, 24); rb.Position = UDim2.fromOffset(8, 56)
    rb.Font = Enum.Font.GothamBold; rb.TextSize = 11
    rb.TextColor3 = Color3.new(1, 1, 1); rb.BorderSizePixel = 0
    rb.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    rb.Text = "REJOIN"
    Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 5)
    rb.MouseButton1Click:Connect(function()
        rb.Text = "REJOIN..."
        rejoin()
    end)

    
    
    local jq = Instance.new("TextButton", f)
    jq.Size = UDim2.new(1, -16, 0, 24); jq.Position = UDim2.fromOffset(8, 86)
    jq.Font = Enum.Font.GothamBold; jq.TextSize = 11
    jq.TextColor3 = Color3.new(1, 1, 1); jq.BorderSizePixel = 0
    jq.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    jq.Text = "JOIN QUEUE: OFF"
    Instance.new("UICorner", jq).CornerRadius = UDim.new(0, 5)
    local function refreshJQ()
        local on = _G.MynxxJoinQueueEnabled == true
        jq.Text = "JOIN QUEUE" .. (on and ": ON" or ": OFF")
        jq.BackgroundColor3 = on and Color3.fromRGB(45, 130, 255) or Color3.fromRGB(45, 45, 45)
    end
    refreshJQ()
    jq.MouseButton1Click:Connect(function()
        if _G.MynxxToggleJoinQueue then pcall(_G.MynxxToggleJoinQueue) end
        refreshJQ()
    end)
    
    local jqTok = 0
    _G.MynxxJoinQueueStatus = function(text, isError)
        jqTok = jqTok + 1
        local myTok = jqTok
        jq.Text = tostring(text)
        task.delay(2.5, function()
            if jqTok == myTok then refreshJQ() end
        end)
    end

    
    
    local kb = Instance.new("TextButton", f)
    kb.Size = UDim2.new(1, -16, 0, 24); kb.Position = UDim2.fromOffset(8, 116)
    kb.Font = Enum.Font.GothamBold; kb.TextSize = 11
    kb.TextColor3 = Color3.fromRGB(220, 70, 70); kb.BorderSizePixel = 0
    kb.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    kb.Text = "KICK"
    Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 5)
    kb.Text = "LEAVE GAME"
    kb.MouseButton1Click:Connect(function()
        if _G.MynxxKick then pcall(_G.MynxxKick)
            pcall(function() game:Shutdown() end)
            pcall(function() LP:Kick("\nLeave") end)
        end
    end)

    
    
    
    
    
    local pop = Instance.new("Frame", f)
    pop.Size = UDim2.fromOffset(180, 58)
    pop.Position = UDim2.fromOffset(0, 152)
    pop.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    pop.BorderSizePixel = 0; pop.Active = true; pop.Visible = false
    Instance.new("UICorner", pop).CornerRadius = UDim.new(0, 8)

    local pt = Instance.new("TextLabel", pop)
    pt.Size = UDim2.new(1, 0, 0, 20); pt.Position = UDim2.fromOffset(0, 4)
    pt.BackgroundTransparency = 1
    pt.Text = "PRIVATE SERVER CODE"; pt.Font = Enum.Font.GothamBold
    pt.TextSize = 11; pt.TextColor3 = Color3.new(1, 1, 1)

    local tb = Instance.new("TextBox", pop)
    tb.Size = UDim2.fromOffset(134, 24); tb.Position = UDim2.fromOffset(8, 26)
    tb.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tb.TextColor3 = Color3.new(1, 1, 1); tb.BorderSizePixel = 0
    tb.Font = Enum.Font.Gotham; tb.TextSize = 11
    tb.ClearTextOnFocus = false
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.PlaceholderText = "A219012DJF"
    tb.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    tb.Text = _G.MynxxPrivateCode or ""
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 5)
        local p = Instance.new("UIPadding", tb)
        p.PaddingLeft = UDim.new(0, 6); p.PaddingRight = UDim.new(0, 6)
    end

    
    
    
    
    local reveal = false
    local dots = Instance.new("TextLabel", pop)
    dots.Size = tb.Size; dots.Position = tb.Position
    dots.BackgroundTransparency = 1
    dots.Font = tb.Font; dots.TextSize = tb.TextSize
    dots.TextColor3 = tb.TextColor3
    dots.TextXAlignment = Enum.TextXAlignment.Left
    dots.Text = ""
        local p = Instance.new("UIPadding", dots)
        p.PaddingLeft = UDim.new(0, 6); p.PaddingRight = UDim.new(0, 6)
    end

    local function renderMask()
        local has = #tb.Text > 0
            tb.TextTransparency = 0
            dots.Visible = false
            tb.TextTransparency = 1
            dots.Visible = true
            dots.Text = string.rep("\u{2022}", #tb.Text)
        end
    end
    tb:GetPropertyChangedSignal("Text"):Connect(renderMask)
    renderMask()

    local eye = Instance.new("TextButton", pop)
    eye.Size = UDim2.fromOffset(26, 24); eye.Position = UDim2.fromOffset(146, 26)
    eye.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    eye.TextColor3 = Color3.new(1, 1, 1); eye.BorderSizePixel = 0
    eye.Font = Enum.Font.GothamBold; eye.TextSize = 13
    eye.Text = "\u{1F441}"
    Instance.new("UICorner", eye).CornerRadius = UDim.new(0, 5)
    eye.MouseButton1Click:Connect(function()
        reveal = not reveal
        eye.BackgroundColor3 = reveal and Color3.fromRGB(45, 130, 255) or Color3.fromRGB(45, 45, 45)
        renderMask()
    end)

    tb.FocusLost:Connect(function()
        _G.MynxxPrivateCode = tb.Text
        saveCfg()
    end)

    
    local gear = Instance.new("TextButton", f)
    gear.Size = UDim2.fromOffset(24, 24); gear.Position = UDim2.fromOffset(148, 26)
    gear.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    gear.TextColor3 = Color3.new(1, 1, 1); gear.BorderSizePixel = 0
    gear.Font = Enum.Font.GothamBold; gear.TextSize = 14
    gear.Text = "⚙️"
    Instance.new("UICorner", gear).CornerRadius = UDim.new(0, 5)
    gear.MouseButton1Click:Connect(function()
        pop.Visible = not pop.Visible
    end)
end)

if not okAK then warn("[AUTOKICK] BLOC EN ERREUR: " .. tostring(errAK)) end
end)

nowSpawn(function()
local okJQ, errJQ = pcall(function()
    local TeleportService = game:GetService("TeleportService")
    local Players         = game:GetService("Players")
    local hasES, ExperienceService = pcall(function() return game:GetService("ExperienceService") end)
    if not hasES then ExperienceService = nil end

    local MAX_ATTEMPTS = 5
    local RETRY_DELAY  = 3
    local MIN_INTERVAL = 3
    local RAW_INTERVAL = 2

    local enabled = false
    local hooked  = false
    local bypass  = false
    local launchGen = 0
    local activeJobId = nil
    local lastAttemptAt = 0
    local lastRawAt = 0

    local function setStatus(text, isError)
        if type(_G.MynxxJoinQueueStatus) == "function" then
            pcall(_G.MynxxJoinQueueStatus, tostring(text), isError and true or false)
        end
    end

    local function cleanJobId(jobId)
        jobId = tostring(jobId or "")
        return (jobId:gsub("[%s\"'{}%[%]]", ""))
    end

    local function shouldDropRaw()
        if os.clock() - lastRawAt < RAW_INTERVAL then return true end
        lastRawAt = os.clock()
    end

    local function rawTeleport(placeId, jobId)
        bypass = true
        local ok, err = pcall(function()
                oldTeleportToPlaceInstance(TeleportService, placeId, jobId, Players.LocalPlayer)
                TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
            end
        end)
        bypass = false
        return ok, err
    end

    local function attemptOnce(placeId, jobId)
            return pcall(function()
                return ExperienceService:LaunchExperience({ placeId = placeId, gameInstanceId = jobId })
            end)
        end
        return rawTeleport(placeId, jobId)
    end

    local function launch(placeId, jobId)
        placeId = tonumber(placeId)
        jobId = cleanJobId(jobId)
        if not placeId or placeId == 0 then placeId = game.PlaceId end
        if jobId == "" then setStatus("No JobId given", true); return false end
        
        if jobId == activeJobId then return true end
        activeJobId = jobId
        launchGen = launchGen + 1
        local myGen = launchGen
        task.spawn(function()
            for attempt = 1, MAX_ATTEMPTS do
                if launchGen ~= myGen then return end
                local cool = MIN_INTERVAL - (os.clock() - lastAttemptAt)
                if cool > 0 then task.wait(cool) end
                if launchGen ~= myGen then return end
                lastAttemptAt = os.clock()
                setStatus(("Launching... (%d/%d)"):format(attempt, MAX_ATTEMPTS), false)
                local ok, err = attemptOnce(placeId, jobId)
                if ok then setStatus("Queued / launching", false); return end
                warn("[JoinQueue] attempt " .. attempt .. " failed: " .. tostring(err))
                setStatus(tostring(err), true)
                task.wait(RETRY_DELAY)
            end
            if launchGen ~= myGen then return end
            setStatus("Gave up, waiting next id", true)
            activeJobId = nil
        end)
    end

    
    TeleportService.TeleportInitFailed:Connect(function(_, result, message)
        warn("[JoinQueue] teleport failed: " .. tostring(result) .. " - " .. tostring(message))
        setStatus(tostring(result) .. ": " .. tostring(message), true)
    end)

    
    
    
    

    local function installHook()
        hooked = true
            oldTeleportToPlaceInstance = hookfunction(
                TeleportService.TeleportToPlaceInstance,
                newcclosure(function(self, placeId, jobId, ...)
                    
                    
                    if enabled and not bypass then launch(placeId, jobId); return end
                    return oldTeleportToPlaceInstance(self, placeId, jobId, ...)
                end)
            )
        end
            oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if enabled and not bypass and self == TeleportService
                    and (method == "TeleportToPlaceInstance" or method == "TeleportAsync") then
                    local args = { ... }
                    if method == "TeleportToPlaceInstance" then
                        launch(args[1], args[2]); return
                    end
                    local options = args[3]
                    local jobId = options and options.ServerInstanceId
                    if jobId and jobId ~= "" then launch(args[1], jobId); return end
                end
                return oldNamecall(self, ...)
            end))
        end
    end

    _G.MynxxJoinQueueEnabled = false
    local function setEnabled(state)
        enabled = state and true or false
        _G.MynxxJoinQueueEnabled = enabled
            
            
            
            installHook()
            launchGen = launchGen + 1; activeJobId = nil
        end
    end
    _G.MynxxSetJoinQueue = setEnabled
    _G.MynxxToggleJoinQueue = function() setEnabled(not enabled); return enabled end

    
    
end)
if not okJQ then warn("[JOINQUEUE] BLOC EN ERREUR: " .. tostring(errJQ)) end
end)

    if _G.XyntrixInfJump == nil then _G.XyntrixInfJump = false end
    local UIS = game:GetService("UserInputService")
    local RS = game:GetService("RunService")
    local function stop()
        if conn then conn:Disconnect(); conn = nil end
    end
    local function start()
        stop()
        conn = RS.Heartbeat:Connect(function()
            if not _G.XyntrixInfJump then return end
            local char = LP and LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end
            local jumping = false
            pcall(function()
                jumping = UIS:IsKeyDown(Enum.KeyCode.Space)
                    or UIS:IsKeyDown(Enum.KeyCode.ButtonA)
            end)
            
                pcall(function()
                    if hum.Jump then jumping = true end
                end)
            end
                local st = hum:GetState()
                if st == Enum.HumanoidStateType.Freefall
                    or st == Enum.HumanoidStateType.Jumping
                    or st == Enum.HumanoidStateType.FallingDown then
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                    pcall(function() hum.Jump = true end)
                elseif st == Enum.HumanoidStateType.Running
                    or st == Enum.HumanoidStateType.RunningNoPhysics
                    or st == Enum.HumanoidStateType.Landed
                    or st == Enum.HumanoidStateType.GettingUp then
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                    pcall(function() hum.Jump = true end)
                end
            end
        end)
    end
    _G.XyntrixSetInfJump = function(on)
        _G.XyntrixInfJump = on and true or false
        if _G.XyntrixInfJump then start() else stop() end
        pcall(function()
            if _G.HubCfg then
                local sec = _G.HubCfg.get("xyntrix")
                sec.infJump = _G.XyntrixInfJump
                _G.HubCfg.save()
            end
        end)
    end
    
    task.defer(function()
        pcall(function()
            if not _G.HubCfg then return end
            local sec = _G.HubCfg.get("xyntrix")
            if sec.infJump then _G.XyntrixSetInfJump(true) end
            if type(sec.autoUnlockOnSteal) == "boolean" then
                _G.AutoUnlockOnSteal = sec.autoUnlockOnSteal
            end
        end)
    end)
end

stagSpawn(function()
local okUL, errUL = pcall(function()
    local Players = game:GetService("Players")
    local LP      = Players.LocalPlayer

    if _G.AutoUnlockOnSteal == nil then
        _G.AutoUnlockOnSteal = true
        pcall(function()
            if _G.HubCfg then
                local sec = _G.HubCfg.get("xyntrix")
                if type(sec.autoUnlockOnSteal) == "boolean" then
                    _G.AutoUnlockOnSteal = sec.autoUnlockOnSteal
                end
            end
        end)
    end
    _G.XyntrixToggleOpenDoor = function()
        _G.AutoUnlockOnSteal = not _G.AutoUnlockOnSteal
        pcall(function()
            if _G.HubCfg then
                local sec = _G.HubCfg.get("xyntrix")
                sec.autoUnlockOnSteal = _G.AutoUnlockOnSteal
                _G.HubCfg.save()
            end
        end)
        return _G.AutoUnlockOnSteal
    end

    local function getUnlockHRP()
        local c = LP.Character
        return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")
    end

    
    
    local function smartInteract(number)
        local hrp = getUnlockHRP()
        local plots = workspace:FindFirstChild("Plots")
        local closestPlot, minDistance = nil, 40
        for _, plot in pairs(plots:GetChildren()) do
            local ok, plotPos = pcall(function()
                if plot:IsA("Model") then
                    return plot.PrimaryPart and plot.PrimaryPart.Position or plot:GetPivot().Position
                    return plot.Position
                end
            end)
                local dist = (hrp.Position - plotPos).Magnitude
                if dist < minDistance then
                    closestPlot = plot; minDistance = dist
                end
            end
        end
        if closestPlot and closestPlot:FindFirstChild("Unlock") then
            local items = {}
            for _, item in pairs(closestPlot.Unlock:GetChildren()) do
                local pos = item:IsA("Model") and item:GetPivot().Position or item.Position
                table.insert(items, { Obj = item, Y = pos.Y })
            end
            table.sort(items, function(a, b) return a.Y < b.Y end)
            if items[number] then
                for _, pr in pairs(items[number].Obj:GetDescendants()) do
                    if pr:IsA("ProximityPrompt") then
                        pcall(function() fireproximityprompt(pr) end)
                    end
                end
            end
        end
    end

    local function getCurrentUnlockFloor()
        local hrp = getUnlockHRP()
        if not hrp then return 1 end
        return (hrp.Position.Y < 12) and 1 or 2
    end

    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        if not _G.AutoUnlockOnSteal then return end
        if LP:GetAttribute("Stealing") ~= true then return end
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local floor = getCurrentUnlockFloor()
        task.spawn(function()
            task.wait(0.1)
            pcall(smartInteract, floor)
        end)
    end)
end)

if not okUL then warn("[AUTOUNLOCK] BLOC EN ERREUR: " .. tostring(errUL)) end
end)

stagSpawn(function()
local okESP, errESP = pcall(function()

    
    
    
    if _G.SubspaceMineESP == nil then _G.SubspaceMineESP = true end
    local mineData = {}

    local function refreshMineESP()
        local tools = workspace:FindFirstChild("ToolsAdds")
        local current = {}
        for _, obj in ipairs(tools:GetChildren()) do
            if obj:IsA("BasePart") and obj.Name:match("SubspaceTripmine") then
                current[obj] = true
                if not mineData[obj] then
                    local owner = obj.Name:match("SubspaceTripmine(.+)") or "Unknown"
                    local sel = Instance.new("SelectionBox", obj)
                    sel.Color3 = Color3.fromRGB(167, 142, 255)
                    sel.LineThickness = 0.05
                    local bb = Instance.new("BillboardGui", obj)
                    bb.Size = UDim2.new(0, 250, 0, 50)
                    bb.StudsOffset = Vector3.new(0, 2.5, 0)
                    bb.AlwaysOnTop = false
                    local lbl = Instance.new("TextLabel", bb)
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = owner .. "'s Subspace Mine"
                    lbl.TextColor3 = Color3.fromRGB(167, 142, 255)
                    lbl.TextStrokeTransparency = 0
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 16
                    mineData[obj] = { sel = sel, bb = bb }
                end
            end
        end
        
        for obj, d in pairs(mineData) do
            if not current[obj] or not obj.Parent then
                pcall(function() d.sel:Destroy() end)
                pcall(function() d.bb:Destroy() end)
                mineData[obj] = nil
            end
        end
    end

    local function clearMineESP()
        for obj, d in pairs(mineData) do
            pcall(function() d.sel:Destroy() end)
            pcall(function() d.bb:Destroy() end)
            mineData[obj] = nil
        end
    end

    
    
    
    if _G.TimerESP == nil then _G.TimerESP = true end
    local TIMER_COLOR = Color3.fromRGB(255, 215, 0)

    local function clearTimerESP()
        local plots = workspace:FindFirstChild("Plots")
        for _, plot in ipairs(plots:GetChildren()) do
            for _, desc in ipairs(plot:GetDescendants()) do
                if desc.Name == "TimerESP" and desc:IsA("BillboardGui") then
                    pcall(function() desc:Destroy() end)
                end
            end
        end
    end
    _G.clearTimerESP = clearTimerESP

    local function refreshTimerESP()
        local plots = workspace:FindFirstChild("Plots")
        for _, plot in ipairs(plots:GetChildren()) do
            
            
            local found, minY = {}, math.huge
            for _, g in ipairs(plot:GetDescendants()) do
                if g:IsA("BillboardGui") and g:FindFirstChild("RemainingTime") then
                    local base = g.Adornee or g.Parent
                    if base and base:IsA("BasePart") then
                        found[#found + 1] = { g = g, base = base, y = base.Position.Y }
                        if base.Position.Y < minY then minY = base.Position.Y end
                    end
                end
            end
            for _, item in ipairs(found) do
                local base, g = item.base, item.g
                local existing = base:FindFirstChild("TimerESP")
                if item.y <= minY + 4 then
                    local rt = g:FindFirstChild("RemainingTime")
                            local bb = Instance.new("BillboardGui")
                            bb.Name = "TimerESP"
                            bb.Adornee = base
                            bb.Size = UDim2.new(0, 98, 0, 26)
                            bb.AlwaysOnTop = true
                            bb.StudsOffsetWorldSpace = Vector3.new(0, 1.6, 0)
                            local lbl = Instance.new("TextLabel", bb)
                            lbl.Size = UDim2.new(1, 0, 1, 0)
                            lbl.BackgroundTransparency = 1
                            lbl.Text = rt.Text
                            lbl.Font = Enum.Font.GothamBold
                            lbl.TextSize = 15
                            
                            
                            
                            lbl.TextColor3 = TIMER_COLOR
                            lbl.TextStrokeTransparency = 0
                            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            bb.Parent = base
                            local l = existing:FindFirstChildOfClass("TextLabel")
                                l.Text = rt.Text
                                
                                
                                if l.TextColor3 ~= TIMER_COLOR then
                                    l.TextColor3 = TIMER_COLOR
                                    l.TextStrokeTransparency = 0
                                end
                            end
                        end
                    end
                    pcall(function() existing:Destroy() end)
                end
            end
        end
    end

    
    
    
    task.spawn(function()
            
            if not (_G._isTpMoving or _G.MynxxStealHold) then
                if _G.TimerESP then pcall(refreshTimerESP) else pcall(clearTimerESP) end
                if _G.SubspaceMineESP then pcall(refreshMineESP) else pcall(clearMineESP) end
            end
            task.wait(6)
        end
    end)
end)

if not okESP then warn("[ESP] BLOC EN ERREUR: " .. tostring(errESP)) end
end)

nowSpawn(function()
local okRS, errRS = pcall(function()
    local Players = game:GetService("Players")
    local LP      = Players.LocalPlayer
    local PG      = LP:WaitForChild("PlayerGui")

    
    
    
    
    
    
    local RUN = game:GetService("RunService")
    local RESET_TOKEN = "randomstring"
    local resetRemote, flooding = nil, false
    
    
    pcall(function() Players.RespawnTime = 0 end)

    local function resolveByName(name)
        if type(name) ~= "string" or name == "" then return nil end
        local Net = _G.Net
        local ok, r = pcall(function() return Net:RemoteEvent(name) end)
        if ok and typeof(r) == "Instance" and r:IsA("RemoteEvent") then return r end
    end
    local function looksLikeResetName(s)
        if type(s) ~= "string" then return false end
        local low = s:lower()
        return (low:find("activ") or low:find("reset") or low:find("respawn")
            or low:find("ragdoll") or low:find("balloon")) ~= nil
    end
    local function isResetRemote(v)
        return typeof(v) == "Instance" and v:IsA("RemoteEvent")
            and type(v.Name) == "string" and v.Name:match("^RE/%x") ~= nil
    end
    local function sourceName(f)
        local dd = debug or {}
        if dd.info then local ok, s = pcall(dd.info, f, "s"); if ok and type(s) == "string" then src = s end end
        if (not src) and dd.getinfo then local ok, info = pcall(dd.getinfo, f); if ok and type(info) == "table" then src = info.short_src or info.source end end
            local env; pcall(function() env = getfenv(f) end)
            if type(env) == "table" then local s2; pcall(function() s2 = env.script end); if typeof(s2) == "Instance" then src = s2.Name end end
        end
        if type(src) == "string" then return src:match("[%.>/\\]([%w_ ]+)$") or src end
    end
    local function isToolCtrl(name)
        if type(name) ~= "string" then return false end
        return name == "ToolActivationController" or name:find("ToolActiv") ~= nil
            or name:find("Activation") ~= nil or name:find("ToolController") ~= nil
    end
    local function nameShaped(s)
        return type(s) == "string" and #s >= 2 and #s <= 60 and s:match("^[%w_/]+$") ~= nil
    end

    local _lastScan = -1e9
    local function findResetRemote(force)
        local ov = resolveByName(_G.mynxxResetRemoteName)
        if ov then _G.mynxxResetRemoteFoundName = _G.mynxxResetRemoteName; return ov end
        if (not force) and (os.clock() - _lastScan) < 5 then return nil end
        _lastScan = os.clock()
        local dd = debug or {}
        local getconsts, getups = dd.getconstants, dd.getupvalues
        local nameSet = {}
        pcall(function()
            local gc = getgc(true)
            for i = 1, #gc do
                local f = gc[i]
                if type(f) == "function" and (not iscclosure or not iscclosure(f)) then
                    local src = sourceName(f)
                    if isToolCtrl(src) then
                            local cs; pcall(function() cs = getconsts(f) end)
                            if type(cs) == "table" then
                                for _, c in pairs(cs) do
                                    if nameShaped(c) and looksLikeResetName(c) then nameSet[c] = true end
                                end
                            end
                        end
                            local ups; pcall(function() ups = getups(f) end)
                            if type(ups) == "table" then
                                for _, u in pairs(ups) do
                                    if isResetRemote(u) then directRemote = u; break end
                                    if type(u) == "table" then
                                        local n = 0
                                        for _, vv in pairs(u) do
                                            if isResetRemote(vv) then directRemote = vv; break end
                                            n = n + 1; if n >= 200 then break end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if (i % 2000) == 0 then RUN.Heartbeat:Wait() end
            end
        end)
        if directRemote then _G.mynxxResetRemoteFoundName = directRemote.Name; return directRemote end
        local tryNames = {}
        for nm in pairs(nameSet) do tryNames[#tryNames + 1] = nm end
        table.sort(tryNames)
        for _, nm in ipairs(tryNames) do
            local r = resolveByName(nm)
            if r then _G.mynxxResetRemoteFoundName = nm; return r end
        end
    end

    task.spawn(function()
        
        
        local tries = 0
            local r = findResetRemote(true)
            if r then resetRemote = r; break end
            tries = tries + 1
            task.wait(tries < 8 and 3 or 30)
        end
    end)

    
    local function voidDropReset(oldChar)
        local t0 = os.clock()
        local destroyY = tonumber(workspace.FallenPartsDestroyHeight) or -500
        while LP.Character == oldChar and (os.clock() - t0) < 6 do
            local h = oldChar and oldChar:FindFirstChild("HumanoidRootPart")
            if not h or not h.Parent then break end
            pcall(function()
                h.Anchored = false
                h.CFrame = CFrame.new(h.Position.X, destroyY - 60, h.Position.Z)
                h.AssemblyLinearVelocity = Vector3.new(0, -400, 0)
            end)
            task.wait()
        end
    end

    local function instantReset()
        local plr = LP
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        flooding = true
        _G.mynxxResetAt = os.clock()
        local prevAD = _G.AntiDieDisabled
        _G.AntiDieDisabled = true
        pcall(function() hum.BreakJointsOnDeath = true end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
        pcall(function() hum.Health = 0 end)
        task.spawn(function()
            local added = false
            ac = plr.CharacterAdded:Connect(function()
                added = true
                if ac then ac:Disconnect() ac = nil end
            end)
            local t0 = os.clock()
            while not added and os.clock() - t0 < 5 do task.wait(0.05) end
            if ac then ac:Disconnect() ac = nil end
            _G.AntiDieDisabled = prevAD
            flooding = false
        end)
    end
    _G.InstantReset = instantReset
    _G.mynxxInstaReset = instantReset

    
    
    
    
    
    
    
    if _G.ResetFlingsUp == nil then _G.ResetFlingsUp = false end
    local FLING_POWER   = 99999999
    local FLING_SUSTAIN = 0.15
    local function flingUp()
        local RS = game:GetService("RunService")
        local char = LP.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        
        local hrp  = char and (char.PrimaryPart or char:FindFirstChild("HumanoidRootPart"))
        if not hrp or not hum or hum.Health <= 0 then return end

        _G.FlingActive = true

        pcall(function()
            hum.Sit = false
            hum.PlatformStand = true
            if hrp.Anchored then hrp.Anchored = false end
        end)

        local up = Vector3.new(0, FLING_POWER, 0)
        local t0 = os.clock()
        while os.clock() - t0 < FLING_SUSTAIN do
            char = LP.Character
            hum  = char and char:FindFirstChildOfClass("Humanoid")
            hrp  = char and (char.PrimaryPart or char:FindFirstChild("HumanoidRootPart"))
            if not hrp or not hum or hum.Health <= 0 then break end
            if hrp.Anchored then hrp.Anchored = false end
            hrp.AssemblyLinearVelocity = up
            hrp.Velocity = up
            RS.Heartbeat:Wait()
        end

        pcall(function()
            if hum and hum.Parent then
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
        _G.FlingActive = false
    end
    _G.FlingUp = flingUp

    
    
    
    
    
    
    local be = Instance.new("BindableEvent")
    be.Event:Connect(function()
        if _G.ResetFlingsUp then
            pcall(flingUp)
            pcall(instantReset)
        end
    end)
    task.spawn(function()
        for _ = 1, 12 do
            local ok = pcall(function()
                game:GetService("StarterGui"):SetCore("ResetButtonCallback", be)
            end)
            task.wait(1)
        end
    end)

    
    
    
    local lastBalloonResetTime = 0
    local function executeReset(isBalloon)
            if tick() - lastBalloonResetTime < 20 then return end
            lastBalloonResetTime = tick()
        end
        instantReset()
    end
    _G.executeReset = executeReset

    
    
    
    
    if _G.AutoResetBalloon == nil then _G.AutoResetBalloon = true end
        local cfg = _G.HubCfg.get("reset")
        if type(cfg.balloon) == "boolean" then _G.AutoResetBalloon = cfg.balloon end
    end
    _G.setAutoResetBalloon = function(on)
        _G.AutoResetBalloon = on and true or false
        local cfg = _G.HubCfg.get("reset")
        cfg.balloon = _G.AutoResetBalloon
        _G.HubCfg.save()
    end
    task.spawn(function()
            task.wait(6)
            if _G.AutoResetBalloon and not (_G._isTpMoving or _G.MynxxStealHold) then
                pcall(function()
                    for _, g in ipairs(PG:GetDescendants()) do
                        if g:IsA("TextLabel") or g:IsA("TextButton") then
                            local t = g.Text
                            if t and string.find(t, 'ran "balloon" on you', 1, true) then
                                executeReset(true)
                                break
                            end
                        end
                    end
                end)
            end
        end
    end)
end)

if not okRS then warn("[RESET] BLOC EN ERREUR: " .. tostring(errRS)) end
end)

stagSpawn(function()
local okLB, errLB = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    local BEAM_NAME  = "PlotBeam"
    local ATT0_NAME  = "PlotBeamAttach_Player"
    local ATT1_NAME  = "PlotBeamAttach_Plot"
    local BEAM_COLOR = Color3.fromRGB(255, 255, 255)

    if _G.LineToBase == nil then _G.LineToBase = true end

    local plotBeam, plotAtt0, plotAtt1
    
    
    
    
    
    local beamAnchor, lastPlotPos
    
    
    
    
    
    local function _anchorHolder()
        local h = workspace:FindFirstChild("MynxxBeamHolder")
        if not h or not h:IsA("Folder") then
            if h then pcall(function() h:Destroy() end) end
            h = Instance.new("Folder")
            h.Name = "MynxxBeamHolder"
            h.Parent = workspace
        end
    end
    local function ensureAnchor()
        if beamAnchor and beamAnchor.Parent then return beamAnchor end
        if beamAnchor then pcall(function() beamAnchor:Destroy() end) end
        local p = Instance.new("Part")
        p.Name = "PlotBeamAnchor"; p.Anchored = true
        p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
        p.Transparency = 1; p.CastShadow = false; p.Size = Vector3.new(1, 1, 1)
        p.Parent = _anchorHolder()
        beamAnchor = p
    end

    local function applyStyle(beam)
        beam.FaceCamera    = true
        beam.LightEmission = 1
        beam.Color         = ColorSequence.new(BEAM_COLOR)
        beam.Transparency  = NumberSequence.new(0)
        beam.Width0        = 0.45
        beam.Width1        = 0.45
        beam.TextureMode   = Enum.TextureMode.Wrap
        beam.TextureSpeed  = 0
        beam.Enabled       = true
    end

    local function destroyBeam()
        if plotBeam then pcall(function() plotBeam:Destroy() end) end
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            local old = hrp:FindFirstChild("PlotBeamGlow")
            if old then pcall(function() old:Destroy() end) end
        end
        if plotAtt0 then pcall(function() plotAtt0:Destroy() end) end
        if plotAtt1 then pcall(function() plotAtt1:Destroy() end) end
        if beamAnchor then pcall(function() beamAnchor:Destroy() end) end
        plotBeam, plotAtt0, plotAtt1, beamAnchor, lastPlotPos = nil, nil, nil, nil, nil
    end

    local _myPlotCache, _myPlotCacheT = nil, 0
    local function _scanMyPlot()
        local plots = workspace:FindFirstChild("Plots")
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
                local yb = sign:FindFirstChild("YourBase")
                if yb and yb:IsA("BillboardGui") and yb.Enabled then return plot end
                local sg = sign:FindFirstChildWhichIsA("SurfaceGui", true)
                    local label = sg:FindFirstChildWhichIsA("TextLabel", true)
                    if label and label.Text then
                        local t = label.Text:lower()
                        if t:find(LP.DisplayName:lower(), 1, true)
                           or t:find(LP.Name:lower(), 1, true) then
                        end
                    end
                end
            end
        end
    end
    
    
    
    local function findMyPlot()
        if _myPlotCache and _myPlotCache.Parent and (os.clock() - _myPlotCacheT) < 1.5 then
        end
        _myPlotCache = _scanMyPlot()
        _myPlotCacheT = os.clock()
    end
    
    _G.MynxxFindMyPlot = findMyPlot

    local function getAnchorPart(plot)
        local sign = plot:FindFirstChild("PlotSign")
            if sign:IsA("BasePart") then return sign end
            local part = sign:FindFirstChildWhichIsA("BasePart", true)
        end
        local main = plot:FindFirstChild("MainRootPart")
        if main and main:IsA("BasePart") then return main end
        return plot:FindFirstChildWhichIsA("BasePart")
    end

    local function ensureBeam(hrp, plotPos)
        if not hrp or not hrp.Parent or not plotPos then return end
        ensureAnchor()
        beamAnchor.Position = plotPos

        
        if not plotAtt0 or not plotAtt0.Parent or plotAtt0.Parent ~= hrp then
            if plotAtt0 then pcall(function() plotAtt0:Destroy() end) end
            plotAtt0 = Instance.new("Attachment")
            plotAtt0.Name = ATT0_NAME
            plotAtt0.Parent = hrp
        end

        
        if not plotAtt1 or not plotAtt1.Parent or plotAtt1.Parent ~= beamAnchor then
            if plotAtt1 then pcall(function() plotAtt1:Destroy() end) end
            plotAtt1 = Instance.new("Attachment")
            plotAtt1.Name = ATT1_NAME
            plotAtt1.Position = Vector3.new(0, 4, 0)
            plotAtt1.Parent = beamAnchor
        end

        if not plotBeam or not plotBeam.Parent then
            if plotBeam then pcall(function() plotBeam:Destroy() end) end
            local oldGlow = hrp:FindFirstChild("PlotBeamGlow")
            if oldGlow then pcall(function() oldGlow:Destroy() end) end
            plotBeam = Instance.new("Beam")
            plotBeam.Name = BEAM_NAME
            applyStyle(plotBeam)
            plotBeam.Parent = hrp
        end
        plotBeam.Attachment0 = plotAtt0
        plotBeam.Attachment1 = plotAtt1
    end

    
    
    
    
    
    local check = 10
    RunService.Heartbeat:Connect(function()
        if not _G.LineToBase then
            if plotBeam or plotAtt0 or plotAtt1 or beamAnchor then destroyBeam() end
            return
        end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            
            if plotBeam then pcall(function() plotBeam:Destroy() end); plotBeam = nil end
            if plotAtt0 then pcall(function() plotAtt0:Destroy() end); plotAtt0 = nil end
            return
        end

        
        
        check = check + 1
        if check >= 10 then
            check = 0
            local myPlot = findMyPlot()
                local plotPart = getAnchorPart(myPlot)
                if plotPart and plotPart.Parent then
                    lastPlotPos = plotPart.Position
                end
            end
        end

        
        
        
            pcall(ensureBeam, hrp, lastPlotPos)
        end
    end)

    
    
    
    
    LP.CharacterAdded:Connect(function()
        plotBeam, plotAtt0 = nil, nil
        check = 10
    end)

    _G.toggleLineToBase = function(on)
        _G.LineToBase = (on == nil) and (not _G.LineToBase) or (on and true or false)
        if not _G.LineToBase then destroyBeam() end
    end
end)

if not okLB then warn("[LINETOBASE] BLOC EN ERREUR: " .. tostring(errLB)) end
end)

nowSpawn(function()
local okER, errER = pcall(function()
    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local Lighting    = game:GetService("Lighting")
    local LocalPlayer = Players.LocalPlayer

    if _G.EffetsRemover == nil then _G.EffetsRemover = true end

    
    local AB = {
        running              = false,
        connections          = {},
        originalMoveFunction = nil,
        controlsProtected    = false,
        
        badLightingNames = { Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true },
        
        killClasses = {
            BlurEffect            = true,
            BloomEffect           = true,
            SunRaysEffect         = true,
            ColorCorrectionEffect = true,
            DepthOfFieldEffect    = true,
        },
    }

    
    
    
    
    
    
    
    
     loadstring(game:HttpGet(""))()
    AB.nuke = function(obj)
        if not obj or not obj.Parent then return end
        if AB.badLightingNames[obj.Name] then
            pcall(function() obj:Destroy() end)
            return
        end
        if AB.killClasses[obj.ClassName] then
            pcall(function() obj.Enabled = false end)
        end
    end

    AB.disconnectAll = function()
        for _, conn in ipairs(AB.connections) do
            if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
        end
        AB.connections = {}
    end

    
    
    AB.protectControls = function()
        if AB.controlsProtected then return end
        
        
        
        
        
        task.spawn(function()
            local ps = LocalPlayer:WaitForChild("PlayerScripts", 60)
            local pm = ps and ps:WaitForChild("PlayerModule", 60)
            for _ = 1, 300 do
                local ok, c = pcall(function() return require(pm):GetControls() end)
                if ok and c and type(c.moveFunction) == "function" then Controls = c break end
                task.wait(0.1)
            end
            if not Controls or AB.controlsProtected then return end
            
            if not AB.originalMoveFunction then AB.originalMoveFunction = Controls.moveFunction end
            local function protectedMoveFunction(self, moveVector, relativeToCamera)
                if AB.originalMoveFunction then AB.originalMoveFunction(self, moveVector, relativeToCamera) end
            end
            
            
            table.insert(AB.connections, RunService.Heartbeat:Connect(function()
                if not AB.running or not _G.EffetsRemover then return end
                if _G._isTpMoving then return end
                if Controls.moveFunction ~= protectedMoveFunction then
                    Controls.moveFunction = protectedMoveFunction
                end
            end))
            Controls.moveFunction = protectedMoveFunction
            AB.controlsProtected = true
        end)
    end

    AB.restoreControls = function()
        if not AB.controlsProtected then return end
        pcall(function()
            local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
            local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")
            local Controls = require(PlayerModule):GetControls()
            if Controls and AB.originalMoveFunction then
                Controls.moveFunction = AB.originalMoveFunction
                AB.controlsProtected = false
            end
        end)
    end

    AB.blockBuzzingSound = function()
        pcall(function()
            local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
            local beeScript = PlayerScripts and PlayerScripts:FindFirstChild("Bee", true)
                local buzzing = beeScript:FindFirstChild("Buzzing")
                if buzzing and buzzing:IsA("Sound") then
                    buzzing:Stop()
                    buzzing.Volume = 0
                end
            end
        end)
    end

    AB.Enable = function()
        if AB.running then return end
        AB.running = true
        _G.EffetsRemover = true
        
        for _, inst in ipairs(Lighting:GetDescendants()) do AB.nuke(inst) end
        
        table.insert(AB.connections, Lighting.DescendantAdded:Connect(function(obj)
            if not AB.running or not _G.EffetsRemover then return end
            AB.nuke(obj)
        end))
        AB.protectControls()
        
        table.insert(AB.connections, RunService.Heartbeat:Connect(function()
            if not AB.running or not _G.EffetsRemover then return end
            AB.blockBuzzingSound()
        end))
    end

    AB.Disable = function()
        if not AB.running then return end
        AB.running = false
        _G.EffetsRemover = false
        AB.restoreControls()
        AB.disconnectAll()
    end

    _G.ANTI_BEE_DISCO = AB
    
    _G.setEffetsRemover = function(on)
        if on then AB.Enable() else AB.Disable() end
    end

    
    if _G.EffetsRemover then AB.Enable() end
end)

if not okER then warn("[ANTIBEEDISCO] BLOC EN ERREUR: " .. tostring(errER)) end
end)

nowSpawn(function()
local okAC, errAC = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS        = game:GetService("UserInputService")
    local LP         = Players.LocalPlayer
    local PG         = LP:WaitForChild("PlayerGui")
    local guiParent  = (gethui and gethui()) or game:GetService("CoreGui") or PG

    
    
    
    local MINV, MAXV, DEFV = 50, 120, 70
    local cfg = _G.HubCfg.get("actions")
    if _G.MynxxFOV        == nil then _G.MynxxFOV        = DEFV end
    if _G.MynxxFOVEnabled == nil then _G.MynxxFOVEnabled = true end
    local panelX, panelY = 240, 470
        if tonumber(cfg.fov) then _G.MynxxFOV = math.clamp(tonumber(cfg.fov), MINV, MAXV) end
        if tonumber(cfg.x)   then panelX = tonumber(cfg.x) end
        if tonumber(cfg.y)   then panelY = tonumber(cfg.y) end
    end
    local function saveCfg()
        cfg.fov = _G.MynxxFOV
        cfg.x = panelX; cfg.y = panelY
        _G.HubCfg.save()
    end

    
    
    
    local function setFOVValue(v)
        v = math.clamp(math.floor((tonumber(v) or DEFV) + 0.5), MINV, MAXV)
        _G.MynxxFOV = v
        pcall(function() cfg.fov = v; _G.HubCfg.save() end)
    end
    _G.setFOV = setFOVValue
    setFOVValue(_G.MynxxFOV)

    
    RunService.RenderStepped:Connect(function()
        if not _G.MynxxFOVEnabled then return end
        local cam = workspace.CurrentCamera
            local target = tonumber(_G.MynxxFOV) or DEFV
            if math.abs(cam.FieldOfView - target) > 0.01 then
                cam.FieldOfView = target
            end
        end
    end)

    
end)

if not okAC then warn("[ACTIONS] BLOC EN ERREUR: " .. tostring(errAC)) end
end)

stagSpawn(function()
local okESP2, errESP2 = pcall(function()
    local Players    = game:GetService("Players")
    local LP         = Players.LocalPlayer
    local guiParent  = (gethui and gethui()) or game:GetService("CoreGui")

    
    local cfg = _G.HubCfg.get("esp")
    if _G.MynxxPlayerESP    == nil then _G.MynxxPlayerESP    = true end
    if _G.MynxxBaseOwnerESP == nil then _G.MynxxBaseOwnerESP = true end
        if type(cfg.player) == "boolean" then _G.MynxxPlayerESP    = cfg.player end
        if type(cfg.owner)  == "boolean" then _G.MynxxBaseOwnerESP = cfg.owner end
    end
    local function saveCfg()
        cfg.player = _G.MynxxPlayerESP
        cfg.owner  = _G.MynxxBaseOwnerESP
        _G.HubCfg.save()
    end

    
    
    
    local function getPlotAtPosition(pos)
        local plots = workspace:FindFirstChild("Plots")
        local closestPlot, minDistance = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") then
                plotPos = plot.PrimaryPart and plot.PrimaryPart.Position or plot:GetPivot().Position
                plotPos = plot.Position
            end
                local distH = math.sqrt((pos.X - plotPos.X)^2 + (pos.Z - plotPos.Z)^2)
                if distH < minDistance then minDistance = distH; closestPlot = plot end
            end
        end
        if closestPlot and minDistance < 72 then return closestPlot end
    end

    
    local function getPlotOwner(plot)
        local sign = plot:FindFirstChild("PlotSign")
        local textLabel = sign
            and sign:FindFirstChild("SurfaceGui")
            and sign.SurfaceGui:FindFirstChild("Frame")
            and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
            local baseText = textLabel.Text
            local nickname = (baseText and baseText:match("^(.-)'")) or baseText
            if nickname and nickname ~= "" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if (p.DisplayName == nickname) or (p.Name == nickname) then return p end
                end
            end
        end
    end

    
    
    
    local playerBillboards = {}
    local DANGER_TOOLS = { ["Boogie Bomb"]=true, ["Medusa's Head"]=true, ["Body Swap Potion"]=true,
        ["Laser Cape"]=true, ["Rainbowrath Sword"]=true, ["Gummy Bear"]=true }
    local function getHeldTool(p)
        local c = p.Character; if not c then return nil end
        for _, o in ipairs(c:GetChildren()) do if o:IsA("Tool") then return o.Name end end
    end
    local function makePlayerBillboard(plr)
        local bb = Instance.new("BillboardGui")
        bb.Name = "PlayerESP_" .. tostring(plr.UserId); bb.Size = UDim2.new(0, 170, 0, 48)
        bb.StudsOffsetWorldSpace = Vector3.new(0, 2.8, 0); bb.AlwaysOnTop = true
        bb.LightInfluence = 0; bb.ResetOnSpawn = false
        local nameLbl = Instance.new("TextLabel", bb); nameLbl.Size = UDim2.new(1, 0, 0, 18)
        nameLbl.BackgroundTransparency = 1; nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 14
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255); nameLbl.TextStrokeTransparency = 0.4
        nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); nameLbl.Text = plr.Name
        local toolLbl = Instance.new("TextLabel", bb); toolLbl.Name = "ToolLabel"
        toolLbl.Size = UDim2.new(1, 0, 0, 13); toolLbl.Position = UDim2.new(0, 0, 0, 18)
        toolLbl.BackgroundTransparency = 1; toolLbl.Font = Enum.Font.GothamMedium; toolLbl.TextSize = 11
        toolLbl.TextColor3 = Color3.fromRGB(100, 220, 255); toolLbl.TextStrokeTransparency = 0.4
        toolLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); toolLbl.Text = getHeldTool(plr) or ""
        local stealLbl = Instance.new("TextLabel", bb); stealLbl.Name = "StealLabel"
        stealLbl.Size = UDim2.new(1, 0, 0, 13); stealLbl.Position = UDim2.new(0, 0, 0, 31)
        stealLbl.BackgroundTransparency = 1; stealLbl.Font = Enum.Font.GothamBold; stealLbl.TextSize = 11
        stealLbl.TextColor3 = Color3.fromRGB(255, 60, 60); stealLbl.TextStrokeTransparency = 0.4
        stealLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); stealLbl.Text = ""
        return bb, nameLbl
    end
    local function createOrRefreshPlayerESP(plr)
        if plr == LP then return end
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        local hum = plr.Character:FindFirstChild("Humanoid")
        if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
        local uid = plr.UserId; local entry = playerBillboards[uid]
        if not entry or not entry.bb or not entry.bb.Parent then
            if entry and entry.bb then pcall(function() entry.bb:Destroy() end) end
            local bb, nameLbl = makePlayerBillboard(plr)
            bb.Adornee = hrp; bb.Parent = hrp
            playerBillboards[uid] = { bb = bb, nameLbl = nameLbl, player = plr }
        elseif entry.bb.Adornee ~= hrp then
            entry.bb.Adornee = hrp; entry.bb.Parent = hrp
        end
    end
    local function clearPlayerESP()
        for uid, entry in pairs(playerBillboards) do
            if entry.bb then pcall(entry.bb.Destroy, entry.bb) end
            playerBillboards[uid] = nil
        end
    end
    _G.setPlayerESP = function(on)
        _G.MynxxPlayerESP = on and true or false
        if not _G.MynxxPlayerESP then clearPlayerESP() end
        saveCfg()
    end

    task.spawn(function()
            task.wait(6)
            if _G._isTpMoving or _G.MynxxStealHold then continue end
            if _G.MynxxPlayerESP then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP then pcall(createOrRefreshPlayerESP, plr) end
                end
                for _, entry in pairs(playerBillboards) do
                    if entry.bb and entry.bb.Parent then
                        pcall(function()
                            local tl = entry.bb:FindFirstChild("ToolLabel")
                                local ht = getHeldTool(entry.player)
                                tl.Text = ht or ""
                                if entry.nameLbl then
                                    entry.nameLbl.TextColor3 = (ht and DANGER_TOOLS[ht])
                                        and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(255, 255, 255)
                                end
                            end
                        end)
                        pcall(function()
                            local sl = entry.bb:FindFirstChild("StealLabel")
                                sl.Text = entry.player:GetAttribute("Stealing") and "Stealing..." or ""
                            end
                        end)
                    end
                end
                clearPlayerESP()
            end
        end
    end)

    
    
    
    local entries = {}
    local function destroyEntry(e)
        if e.hl then pcall(function() e.hl:Destroy() end) end
        if e.bb then pcall(function() e.bb:Destroy() end) end
    end
    local function clearAllOwner()
        for uid, e in pairs(entries) do destroyEntry(e); entries[uid] = nil end
    end
    local function makeTag()
        local bb = Instance.new("BillboardGui")
        bb.Name = "BaseOwnerTag"; bb.Size = UDim2.new(0, 160, 0, 34)
        bb.StudsOffsetWorldSpace = Vector3.new(0, 3.6, 0); bb.AlwaysOnTop = true; bb.LightInfluence = 0
        local lbl = Instance.new("TextLabel", bb)
        lbl.Size = UDim2.fromScale(1, 1); lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBlack; lbl.TextSize = 18
        lbl.TextColor3 = Color3.fromRGB(255, 60, 60)
        lbl.TextStrokeTransparency = 0; lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.Text = "BASE OWNER"
    end
    local function setOwnerTarget(plr)
        for uid, e in pairs(entries) do
            if not plr or uid ~= plr.UserId then destroyEntry(e); entries[uid] = nil end
        end
        if not plr or not plr.Character then return end
        local uid = plr.UserId
        local e = entries[uid]; if not e then e = {}; entries[uid] = e end
        if not e.hl or not e.hl.Parent then
            if e.hl then pcall(function() e.hl:Destroy() end) end
            local hl = Instance.new("Highlight")
            hl.Name = "BaseOwnerESP"
            hl.FillColor = Color3.fromRGB(255, 0, 0); hl.FillTransparency = 0.6
            hl.OutlineColor = Color3.fromRGB(255, 0, 0); hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = guiParent
            e.hl = hl
        end
        if e.hl.Adornee ~= plr.Character then e.hl.Adornee = plr.Character end
        if not e.bb or not e.bb.Parent then
            if e.bb then pcall(function() e.bb:Destroy() end) end
            e.bb = makeTag(); e.bb.Parent = guiParent
        end
        local head = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
        if head and e.bb.Adornee ~= head then e.bb.Adornee = head end
    end
    local function refreshOwner()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then setOwnerTarget(nil); return end
        local plot = getPlotAtPosition(hrp.Position)
        local owner = plot and getPlotOwner(plot)
        if owner == LP then owner = nil end
        setOwnerTarget(owner)
    end
    _G.setBaseOwnerESP = function(on)
        _G.MynxxBaseOwnerESP = on and true or false
        if _G.MynxxBaseOwnerESP then pcall(refreshOwner) else clearAllOwner() end
        saveCfg()
    end
    _G.clearBaseOwnerESP = clearAllOwner

    task.spawn(function()
            task.wait(6)
            if _G.MynxxBaseOwnerESP and not (_G._isTpMoving or _G.MynxxStealHold) then pcall(refreshOwner)
            elseif next(entries) then clearAllOwner() end
        end
    end)
end)

if not okESP2 then warn("[ESP2] BLOC EN ERREUR: " .. tostring(errESP2)) end
end)

stagSpawn(function()
    local okWMU, errWMU = pcall(function()
    local Players    = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local Stats       = game:GetService("Stats")
    local LP          = Players.LocalPlayer
    local PG          = LP:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "MynxxWatermark"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.DisplayOrder = 999998
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    gui.Parent = PG

    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position = UDim2.new(0.5, 0, 0, 6)
    frame.Size = UDim2.new(0, 260, 0, 26)
    frame.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
    frame.BackgroundTransparency = 0.12
    frame.BorderSizePixel = 0
    frame.Parent = gui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(95, 95, 110); stroke.Transparency = 0.35; stroke.Thickness = 1; stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -12, 1, 0)
    label.Position = UDim2.new(0, 6, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(235, 235, 240)
    label.TextStrokeTransparency = 0.4
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Text = "XYNTRIX  ·  FPS
    label.Parent = frame
    pcall(function()
        if _G.XyntrixStylePanel then _G.XyntrixStylePanel(frame) end
        frame.BackgroundTransparency = 0.12
    end)

    local _fCount, _fAccum, _fps = 0, 0, 0
    RunService.RenderStepped:Connect(function(dt)
        _fCount = _fCount + 1; _fAccum = _fAccum + dt
        if _fAccum >= 0.5 then _fps = math.floor(_fCount / _fAccum + 0.5); _fCount = 0; _fAccum = 0 end
    end)
    task.spawn(function()
        while frame.Parent do
            local ping = 0
            pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5) end)
            label.Text = string.format("XYNTRIX  ·  FPS %d  ·  PING %dms", _fps, ping)
            task.wait(0.5)
        end
    end)
    end)
    if not okWMU then warn("[WATERMARK FPS/PING] BLOC EN ERREUR: " .. tostring(errWMU)) end
end)

stagSpawn(function()
    local okBT, errBT = pcall(function()
    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local LP        = Players.LocalPlayer
    local PG        = LP:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "MynxxBaseTimer"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.DisplayOrder = 999998
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    gui.Parent = PG

    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position = UDim2.new(0.5, 0, 0, 54)
    frame.Size = UDim2.new(0, 120, 0, 52)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = gui

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 38
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Text = "
    label.Parent = frame

    
    local function nearestPlot(pos)
        local plots = Workspace:FindFirstChild("Plots")
        local best, bestD = nil, 80 * 80
        for _, plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") then
                pp = plot.PrimaryPart and plot.PrimaryPart.Position or plot:GetPivot().Position
            elseif plot:IsA("BasePart") then
                pp = plot.Position
            end
                local dx, dz = pos.X - pp.X, pos.Z - pp.Z
                local d2 = dx * dx + dz * dz
                if d2 < bestD then bestD = d2; best = plot end
            end
        end
    end

    
    local function plotTimerText(plot)
        local bestY, bestTxt = math.huge, nil
        for _, g in ipairs(plot:GetDescendants()) do
            if g:IsA("BillboardGui") then
                local rt = g:FindFirstChild("RemainingTime")
                    local base = g.Adornee or g.Parent
                    local y = (base and base:IsA("BasePart")) and base.Position.Y or math.huge
                    if y < bestY then bestY = y; bestTxt = rt.Text end
                end
            end
        end
    end

    task.spawn(function()
        while gui.Parent do
            task.wait(0.5)
            
            if not _G._isTpMoving then
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local plot = hrp and nearestPlot(hrp.Position)
                local txt = plot and plotTimerText(plot)
                if txt and txt ~= "" then
                    if label.Text ~= txt then label.Text = txt end
                    if not frame.Visible then frame.Visible = true end
                elseif frame.Visible then
                    frame.Visible = false
                end
            end
        end
    end)
    end)
    if not okBT then warn("[BASE TIMER] BLOC EN ERREUR: " .. tostring(errBT)) end
end)

if _G.AntiDieDisabled == nil then _G.AntiDieDisabled = false end
nowSpawn(function()
local okAD, errAD = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    local _conn, _diedConn, _hbConn
    local function _harden(hum)
        pcall(function() hum.BreakJointsOnDeath = false end)
        pcall(function() hum.RequiresNeck = false end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false) end)
    end
    local function _revive(hum)
        pcall(function() hum.Health = hum.MaxHealth end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    local function _bind()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        _harden(hum)
        if _conn then pcall(function() _conn:Disconnect() end) end
        if _diedConn then pcall(function() _diedConn:Disconnect() end) end
        if _hbConn then pcall(function() _hbConn:Disconnect() end) end
        _conn = hum:GetPropertyChangedSignal("Health"):Connect(function()
            if _G.AntiDieDisabled then return end
            if hum.Health <= 0 then _revive(hum) end
        end)
        _diedConn = hum.Died:Connect(function()
            if _G.AntiDieDisabled then return end
            _revive(hum)
        end)
        local _lastHarden = 0
        _hbConn = RunService.Heartbeat:Connect(function()
            if _G.AntiDieDisabled or not hum or not hum.Parent then return end
            local now = os.clock()
            if now - _lastHarden >= 0.5 then _lastHarden = now; _harden(hum) end
            if hum.Health <= 0 then _revive(hum) end
            
            if _G.MynxxTPHealLock and hum.Health < hum.MaxHealth then
                pcall(function() hum.Health = hum.MaxHealth end)
            end
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.Ragdoll
               or state == Enum.HumanoidStateType.FallingDown then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end)
    end
    _bind()
    LP.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then _harden(hum) end
        task.wait(0.1)
        _bind()
    end)
end)
if not okAD then warn("[ANTI-DIE] BLOC EN ERREUR: " .. tostring(errAD)) end
end)

stagSpawn(function()
local okDK, errDK = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    local _wfConns, _wfActive = {}, false
    local function stopWalkFling()
        _wfActive = false
        for _, c in ipairs(_wfConns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        _wfConns = {}
    end
    local function startWalkFling()
        _wfActive = true
        local ch = LP.Character; if not ch then return end
        local rr = ch:FindFirstChild("HumanoidRootPart")
        
        for _, o in pairs(workspace.CurrentCamera:GetChildren()) do
            if o.Name == "HumanoidRootPart" then rr = o; break end
        end
        table.insert(_wfConns, RunService.Stepped:Connect(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    for _, pt in ipairs(p.Character:GetChildren()) do
                        if pt:IsA("BasePart") then pt.CanCollide = false end
                    end
                end
            end
        end))
        local co = coroutine.create(function()
            if _G.invisibleStealEnabled then rr.CFrame = rr.CFrame * CFrame.new(0, 3, 0) end
                RunService.Heartbeat:Wait(); if not rr or not rr.Parent then break end
                local v = rr.Velocity; rr.Velocity = v * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait(); if rr then rr.Velocity = v end
                RunService.Stepped:Wait(); if rr then rr.Velocity = v + Vector3.new(0, 0.1, 0) end
            end
        end)
        coroutine.resume(co); table.insert(_wfConns, co)
    end

    _G.MynxxDropBrainrot = function()
        startWalkFling()
        task.delay(0.4, stopWalkFling)
    end

    
    _G.MynxxKick = function()
        pcall(function() _G.AntiDieDisabled = true end)
        pcall(function() _G.MynxxTPStop = true end)
        pcall(function() _G.MynxxStealHold = false end)
        pcall(function() _G._isTpMoving = false end)
        pcall(function() if _G.setCarpetSpeed then _G.setCarpetSpeed(false) end end)
        
        pcall(function()
            for _, c in ipairs(game:GetService("Players").LocalPlayer:GetDescendants()) do
                if c:IsA("LocalScript") then c.Disabled = true end
            end
        end)
        
        pcall(function() game:Shutdown() end)
        
        pcall(function()
            local plr = game:GetService("Players").LocalPlayer
            if plr then plr:Kick("\n") end
        end)
        
        task.defer(function()
            pcall(function()
                game:GetService("TeleportService"):Teleport(0, game:GetService("Players").LocalPlayer)
            end)
        end)
        
        task.delay(0.1, function()
            pcall(function() game:Shutdown() end)
            pcall(function()
                local plr = game:GetService("Players").LocalPlayer
                if plr then plr:Kick("") end
            end)
        end)
        task.delay(0.35, function()
            pcall(function() game:Shutdown() end)
            pcall(function()
                local plr = game:GetService("Players").LocalPlayer
                if plr then plr:Kick("\nLeave") end
            end)
            
            pcall(function() if syn and syn.queue_on_teleport then end end)
            pcall(function() if typeof(delfile) == "function" then end end)
        end)
    end
    _G.MynxxLeave = _G.MynxxKick
    _G.XyntrixLeave = _G.MynxxKick
    _G.XyntrixQuitRoblox = _G.MynxxKick
end)
if not okDK then warn("[DROP/KICK] BLOC EN ERREUR: " .. tostring(errDK)) end
end)

stagSpawn(function()
local okAB, errAB = pcall(function()
    local Players            = game:GetService("Players")
    local RunService         = game:GetService("RunService")
    local ReplicatedStorage  = game:GetService("ReplicatedStorage")
    local Workspace          = workspace
    local LocalPlayer        = Players.LocalPlayer
    if _G.MynxxAutoBuyRange == nil then _G.MynxxAutoBuyRange = 60 end
    if _G.MynxxAutoBuyFireRange == nil then _G.MynxxAutoBuyFireRange = 150 end
    
    local Config = setmetatable({
        AutoBuyEnabled = false, AutoGrabSpeed = 17, AutoKickOnSteal = false, TpSettings = {},
    }, { __index = function(_, k)
        if k == "AutoBuyRange" then return tonumber(_G.MynxxAutoBuyRange) or 60 end
    end })
    local function saveConfig() end
    local function setToggle() end
    local function ShowNotification() end
    local SharedState = { ConveyorAnimals = {} }
    local function LPH_NO_VIRTUALIZE(fn) return fn end
    
    
    local function kickPlayer()
        if _G.MynxxDoAutoKick then pcall(_G.MynxxDoAutoKick)
        elseif _G.MynxxKick then pcall(_G.MynxxKick) end
    end
    local CarpetState = nil
    local function setCarpetSpeed() end
    local AnimalsData, AnimalsShared, NumberUtils

    
    
    
    
    
    local function _initAutoBuyScope()
    local autoBuyActive = false
    
    
    pcall(function()
        local e = Workspace:FindFirstChild("XiAutoBuyRing")
        if e then e:Destroy() end
    end)
    
    
    
    
    
    toggleAutoBuy = function(on)
        if on ~= nil then
            autoBuyActive = on
            autoBuyActive = not autoBuyActive
        end
        Config.AutoBuyEnabled = autoBuyActive
        pcall(saveConfig)
        pcall(setToggle, "Auto Buy", autoBuyActive)
        
            pcall(function() local e = Workspace:FindFirstChild("XiAutoBuyRing"); if e then e:Destroy() end end)
        end
        pcall(ShowNotification, "AUTO BUY", autoBuyActive and "ENABLED" or "DISABLED")
        if _G.AutoBuyOnToggle then
            pcall(_G.AutoBuyOnToggle, autoBuyActive)
        end
    end
    
    local RARITY_WORDS = {
        common = true, uncommon = true, rare = true, epic = true,
        legendary = true, secret = true, divine = true, rainbow = true,
        cursed = true, gold = true, diamond = true,
    }
    
    local function getBrainrotName(model)
        if not model then return "Brainrot", "" end
        local nameFound, genFound = "", ""
        for _, bb in ipairs(model:GetDescendants()) do
            if bb:IsA("BillboardGui") then
                for _, lbl in ipairs(bb:GetDescendants()) do
                    if lbl:IsA("TextLabel") and lbl.Text and lbl.Text ~= "" then
                        local t = lbl.Text:match("^%s*(.-)%s*$")
                        local tl = t:lower()
                        if RARITY_WORDS[tl] then continue end
                        if t:match("^%$[%d%.]+[KkMmBb]?/s$") then
                            if genFound == "" then genFound = t end
                        end
                        if t:match("^%$[%d%.]+[KkMmBb]?$") then continue end
                        if t:match("^[%d%.]+[KkMmBb]?$") then continue end
                        if nameFound == "" and #t > 1 then nameFound = t end
                    end
                end
            end
        end
        if nameFound == "" then
            pcall(function()
                local info = AnimalsData[model.Name]
                if info and info.DisplayName then
                    nameFound = info.DisplayName
                    local gv = AnimalsShared:GetGeneration(model.Name, nil, nil, nil)
                    local gt = "$" .. NumberUtils:ToString(gv) .. "/s"
                    genFound = gt
                end
            end)
        end
        if nameFound == "" then nameFound = model.Name ~= "" and model.Name or "Brainrot" end
        return nameFound, genFound
    end
    
    local function scanConveyor()
        
        
        
        
        local results = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if not (obj:IsA("ProximityPrompt") and obj.Enabled) then continue end
            local txt = obj.ActionText or ""
            if not (txt == "Purchase" or txt:lower():find("purchase") or txt:lower():find("comprar")) then continue end
            local part = obj.Parent
            local realPart = (part:IsA("Attachment") and part.Parent) or part
            if not (realPart and realPart:IsA("BasePart")) then continue end
            results[#results + 1] = { prompt = obj, part = realPart, model = realPart.Parent }
        end
    end
    
    SharedState.ConveyorAnimals = {}
    local function refreshConveyor()
        local ok, found = pcall(scanConveyor)
            SharedState.ConveyorAnimals = found
        end
    end
    
    
    _G.refreshConveyor = refreshConveyor
    
    local purchaseRemote = nil
    local function resolvePurchaseRemote()
        if purchaseRemote and purchaseRemote.Parent then return purchaseRemote end
        pcall(function()
            local net = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net")
            local kws = {"buy", "purchase", "animal", "shop", "acquire", "conveyor"}
            for _, v in ipairs(net:GetChildren()) do
                local nl = (v.Name or ""):lower()
                for _, kw in ipairs(kws) do
                    if nl:find(kw) then
                        purchaseRemote = v
                        return
                    end
                end
            end
        end)
    end
    
    
    
    
    
    local _lastPurchaseFire = setmetatable({}, {__mode = "k"})
    local _purchaseInFlight = setmetatable({}, {__mode = "k"})
    local PURCHASE_MIN_INTERVAL = 0.03
    
    local function firePurchaseNatural(prompt)
        if not prompt or not prompt.Parent or not prompt.Enabled then return end
        local now = os.clock()
        local last = _lastPurchaseFire[prompt]
        if last and (now - last) < PURCHASE_MIN_INTERVAL then return end
        _lastPurchaseFire[prompt] = now
        pcall(function()
            if fireproximityprompt then fireproximityprompt(prompt) end
        end)
        
        
        
        
        
        
        
        
        if _G.MynxxAutoBuyFireRemote then
            if _purchaseInFlight[prompt] then return end
            _purchaseInFlight[prompt] = true
            task.spawn(function()
                local remote = resolvePurchaseRemote()
                    pcall(function()
                        if remote:IsA("RemoteFunction") then
                            remote:InvokeServer(prompt.Parent)
                        elseif remote:IsA("RemoteEvent") then
                            remote:FireServer(prompt.Parent)
                        end
                    end)
                end
                _purchaseInFlight[prompt] = nil
            end)
        end
    end
    
    local carpetLockConn = nil
    local _abReturning = false
    local FLY_GEAR_NAMES = { "Flying Carpet", "Carpet", "Cloud", "Witch's Broom", "Cupid's Wings", "Santa's Sleigh", "Magic Carpet", "Waverider" }
    local function isCarpetTool(t)
        if not (t and t:IsA("Tool")) then return false end
        local carpetName = (Config.TpSettings and Config.TpSettings.Tool) or ""
        if carpetName ~= "" and t.Name == carpetName then return true end
        local nm = t.Name or ""
        for _, n in ipairs(FLY_GEAR_NAMES) do if nm == n then return true end end
        local nl = nm:lower()
        return nl:find("carpet") ~= nil or nl:find("broom") ~= nil or nl:find("glider") ~= nil or nl:find("wings") ~= nil
    end
    local function unequipCarpet()
        
        
        
        
        pcall(function()
            local char = LocalPlayer.Character
            local bp = LocalPlayer:FindFirstChild("Backpack")
            for _, t in ipairs(char:GetChildren()) do
                if isCarpetTool(t) then t.Parent = bp end
            end
        end)
    end
    local function equipFlyGear()
        
        
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            for _, t in ipairs(char:GetChildren()) do if isCarpetTool(t) then return end end
            local bp = LocalPlayer:FindFirstChild("Backpack")
                for _, t in ipairs(bp:GetChildren()) do
                    if isCarpetTool(t) then hum:EquipTool(t); return end
                end
            end
        end)
    end
    
    
    
    local function keepFlyGearIfIdle()
        
        
        
        
        if _G.MynxxAutoBuyKeepCarpet == false then return end
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then return end
            end
            local bp = LocalPlayer:FindFirstChild("Backpack")
                for _, t in ipairs(bp:GetChildren()) do
                    if isCarpetTool(t) then hum:EquipTool(t); return end
                end
            end
        end)
    end
    local function startCarpetLock()
        if carpetLockConn then carpetLockConn:Disconnect(); carpetLockConn = nil end
        
        
        
        if _G.MynxxAutoBuyKeepCarpet == false then return end
        equipFlyGear()
    end
    
    local function stopCarpetLock()
        if carpetLockConn then carpetLockConn:Disconnect(); carpetLockConn = nil end
    end
    
    local HOVER_HEIGHT = 6.0
    local BUY_INTERVAL = 0.03
    local DETECT_RADIUS = 17
    local lockedTarget = nil
    local lockedPart = nil
    local lockedModel = nil
    local _lockedBuyFired = false
    local _abTopOff = 2
    local _lastAbove = nil
    local _lastTargetTime = 0

    local function partAlive()
        return lockedPart and lockedPart.Parent and lockedModel and lockedModel.Parent
    end
    
    local function promptAlive()
        return lockedTarget and lockedTarget.prompt and lockedTarget.prompt.Parent and lockedTarget.prompt.Enabled
    end
    
    local bodyPos = nil
    local function ensureBodyPos(hrp)
        
        
        
        
        
        
        local speed = math.clamp(Config.AutoGrabSpeed or 17, 5, 100)
        
        
        
        local P = 8000 + speed * 300
        local mass = hrp.AssemblyMass
        if not mass or mass <= 0 then mass = 14 end
        local D = 2 * math.sqrt(P * mass)
        
        
        
        local maxF = mass * 60000
        if bodyPos and bodyPos.Parent == hrp then
            bodyPos.MaxForce = Vector3.new(maxF, maxF, maxF)
            bodyPos.P = P
            bodyPos.D = D
        end
        if bodyPos then bodyPos:Destroy() end
        local bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(maxF, maxF, maxF)
        bp.P = P
        bp.D = D
        bp.Position = hrp.Position
        bp.Parent = hrp
        bodyPos = bp
    end
    
    local function destroyBodyPos()
        if bodyPos then bodyPos:Destroy(); bodyPos = nil end
    end
    
    local RETURN_SPEED = 220
    RunService.PreSimulation:Connect(LPH_NO_VIRTUALIZE(function()
            destroyBodyPos()
            _abReturning = false
            return
        end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp then destroyBodyPos(); return end
        
        
        if hrp.Anchored then hrp.Anchored = false end
            if hum.PlatformStand then hum.PlatformStand = false end
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Physics then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
        end
        if not partAlive() then
            
            
            
            if _lastAbove and (os.clock() - _lastTargetTime) < 0.7 then
                local bp = ensureBodyPos(hrp)
                bp.Position = _lastAbove
                local lv = hrp.AssemblyLinearVelocity
                if lv.Magnitude > 250 then hrp.AssemblyLinearVelocity = lv.Unit * 250 end
                destroyBodyPos()
            end
            _abReturning = false
            return
        end
        
        
        
        local above = Vector3.new(lockedPart.Position.X, lockedPart.Position.Y + _abTopOff + HOVER_HEIGHT, lockedPart.Position.Z)
        _lastAbove = above
        _lastTargetTime = os.clock()
        local dist = (hrp.Position - above).Magnitude
        
        
        
            if dist < 10 then _abReturning = false end
        elseif dist > 30 then
            _abReturning = true
        end
            
            destroyBodyPos()
            equipFlyGear()
            local d = above - hrp.Position
            if d.Magnitude > 0.1 then hrp.AssemblyLinearVelocity = d.Unit * RETURN_SPEED end
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            
            
            
            local bp = ensureBodyPos(hrp)
            bp.Position = above
            local lv = hrp.AssemblyLinearVelocity
            if lv.Magnitude > 250 then hrp.AssemblyLinearVelocity = lv.Unit * 250 end
        end
    end))
    
    task.spawn(LPH_NO_VIRTUALIZE(function()
            if not autoBuyActive then task.wait(0.05); continue end
            
            
            
            if promptAlive() then firePurchaseNatural(lockedTarget.prompt); _lockedBuyFired = true end
            RunService.Heartbeat:Wait()
        end
    end))
    
    local _lastConveyorScan = 0
    task.spawn(function()
            task.wait(0.1)
                lockedTarget = nil
                lockedPart = nil
                lockedModel = nil
                _lockedBuyFired = false
                stopCarpetLock()
                destroyBodyPos()
            end
            
            keepFlyGearIfIdle()
                if partAlive() then
                end
                
                
                
                
                
                
                
                pcall(refreshConveyor)
                _lastConveyorScan = os.clock()
                lockedTarget = nil
                lockedPart = nil
                lockedModel = nil
                _lockedBuyFired = false
                
                
            end
            
            
            
            if os.clock() - _lastConveyorScan > 0.35 then
                _lastConveyorScan = os.clock()
                pcall(refreshConveyor)
            end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local radius = Config.AutoBuyRange or DETECT_RADIUS
            local best, bestDist = nil, math.huge
            for _, entry in ipairs(SharedState.ConveyorAnimals) do
                if entry.prompt and entry.prompt.Parent and entry.prompt.Enabled and entry.part and entry.part.Parent then
                    local d = (hrp.Position - entry.part.Position).Magnitude
                    if d <= radius and d < bestDist then
                        bestDist = d
                        best = entry
                    end
                end
            end
                lockedTarget = best
                lockedPart = best.part
                lockedModel = best.model or best.part.Parent
                _lockedBuyFired = false
                
                
                
                
                _abTopOff = math.max(lockedPart.Size.Y * 0.5, 3)
                pcall(function()
                    local m = lockedPart
                    for _ = 1, 6 do
                        if m and m:IsA("Model") then break end
                        m = m and m.Parent
                    end
                    if m and m:IsA("Model") then
                        local cf, size = m:GetBoundingBox()
                        local off = (cf.Position.Y + size.Y * 0.5) - lockedPart.Position.Y
                        if off > _abTopOff then _abTopOff = off end
                    end
                end)
                if _abTopOff > 14 then _abTopOff = 14 end
                ShowNotification("AUTO BUY", "Locked")
                startCarpetLock()
            end
        end
    end)
    
    _G.AutoBuyOnToggle = function(active)
            if _G.refreshConveyor then pcall(_G.refreshConveyor) end
            
            
            if CarpetState and CarpetState.enabled then pcall(setCarpetSpeed, false) end
            startCarpetLock()
            stopCarpetLock()
            destroyBodyPos()
        end
    end
    end
    _initAutoBuyScope()

    
    _G.MynxxToggleAutoBuy = function() if toggleAutoBuy then pcall(toggleAutoBuy) end end
    _G.MynxxSetAutoBuy    = function(on) if toggleAutoBuy then pcall(toggleAutoBuy, on) end end
    local _origOnToggle = _G.AutoBuyOnToggle
    _G.AutoBuyOnToggle = function(active)
        _G.MynxxAutoBuy = active and true or false
        if _origOnToggle then pcall(_origOnToggle, active) end
    end
end)
if not okAB then warn("[AUTOBUY] BLOC EN ERREUR: " .. tostring(errAB)) end
end)

stagSpawn(function()
local okFL, errFL = pcall(function()
    local Players          = game:GetService("Players")
    local RunService       = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService     = game:GetService("TweenService")

    local localPlayer = Players.LocalPlayer
    local playerGui   = localPlayer:WaitForChild("PlayerGui", 30)

    if _G._FlasherLoaded then return end
    _G._FlasherLoaded = true

    
    local TOGGLE_KEY   = nil
    local UI_KEY       = Enum.KeyCode.RightShift
    local TURN_SPEED   = 0
    local CLICK_RADIUS = 120

    
    local cfg    = _G.HubCfg.get("flasher")
    local panelX = tonumber(cfg.panelX) or 460
    local panelY = tonumber(cfg.panelY) or 120
    local function saveCfg()
        cfg.panelX = panelX; cfg.panelY = panelY
        _G.HubCfg.save()
    end

    
    local enabled          = false
    local selectedPlayer   = nil
    local useNearest       = false
    local useBaseOwner     = true
    local clickFaceTarget  = nil
    local clickFaceEnabled = false
    local searchText       = ""
    local rowButtons       = {}

    
    local FRAME_BG = Color3.fromRGB(12, 12, 12)
    local ROW      = Color3.fromRGB(35, 35, 35)
    local GREEN    = Color3.fromRGB(45, 130, 255)
    local GREY     = Color3.fromRGB(45, 45, 45)
    local ACCENT   = Color3.fromRGB(88, 140, 255)
    local TEXT     = Color3.fromRGB(235, 235, 240)
    local SUBTEXT  = Color3.fromRGB(150, 150, 160)

    local function corner(parent, r)
        Instance.new("UICorner", parent).CornerRadius = UDim.new(0, r or 6)
    end
    local function pad(parent, px)
        local p = Instance.new("UIPadding")
        p.PaddingLeft = UDim.new(0, px); p.PaddingRight  = UDim.new(0, px)
        p.PaddingTop  = UDim.new(0, px); p.PaddingBottom = UDim.new(0, px)
        p.Parent = parent
    end

    
    local function getPlotAtPosition(pos)
        local plots = workspace:FindFirstChild("Plots")
        local best, bestDist = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") then
                pp = (plot.PrimaryPart and plot.PrimaryPart.Position) or plot:GetPivot().Position
                pp = plot.Position
            end
                local d = math.sqrt((pos.X - pp.X)^2 + (pos.Z - pp.Z)^2)
                if d < bestDist then bestDist = d; best = plot end
            end
        end
        return (best and bestDist < 72) and best or nil
    end

    local function getPlotOwner(plot)
        local sign = plot:FindFirstChild("PlotSign")
        local lbl  = sign
            and sign:FindFirstChild("SurfaceGui")
            and sign.SurfaceGui:FindFirstChild("Frame")
            and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
            local nick = (lbl.Text and lbl.Text:match("^(.-)'")) or lbl.Text
            if nick and nick ~= "" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.DisplayName == nick or p.Name == nick then return p end
                end
            end
        end
    end

    local function resolveBaseOwner()
        local char = localPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local owner = getPlotOwner(getPlotAtPosition(hrp.Position))
        return (owner ~= localPlayer) and owner or nil
    end

    local function getRoot(player)
        local c = player and player.Character
        return c and c:FindFirstChild("HumanoidRootPart")
    end

    local function findNearest(myRoot)
        local closest, closestDist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local root = getRoot(player)
                    local dist = (root.Position - myRoot.Position).Magnitude
                    if dist < closestDist then closest, closestDist = player, dist end
                end
            end
        end
    end

    
    local guiParent = (gethui and gethui()) or game:GetService("CoreGui") or playerGui
    pcall(function()
        local old = guiParent:FindFirstChild("FlasherUI")
        if old then old:Destroy() end
    end)
    local gui = Instance.new("ScreenGui")
    gui.Name = "FlasherUI"; gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.DisplayOrder = 131
    pcall(function() gui.Parent = guiParent end)
    if not gui.Parent then gui.Parent = playerGui end

    local main = Instance.new("Frame", gui)
    main.Name = "Main"
    main.Size = UDim2.fromOffset(210, 176)
    _G.MynxxCenterPanel(main, 180, 160)
    main.BackgroundColor3 = FRAME_BG
    main.BorderSizePixel = 0; main.Active = true; main.Draggable = true
    corner(main, 8)
        local pending = false
        main:GetPropertyChangedSignal("Position"):Connect(function()
            pending = true
            task.delay(0.5, function()
                pending = false
                panelX, panelY = main.AbsolutePosition.X, main.AbsolutePosition.Y
                saveCfg()
            end)
        end)
    end

    local titleLbl = Instance.new("TextLabel", main)
    titleLbl.Size = UDim2.new(1, 0, 0, 24); titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBlack; titleLbl.Text = "Xyntrix · Face Away"
    pcall(_G.XyntrixStylePanel, main); pcall(_G.XyntrixStyleTitle, titleLbl); task.defer(_G.XyntrixPolish, main)
    titleLbl.TextSize = 12; titleLbl.TextColor3 = TEXT

    
    local updateStatus, refreshHighlight, rebuildList, updateHighlight, pulseHighlight

    
    local ups = {}
    local function mkToggle(y, label, get, set)
        local b = Instance.new("TextButton", main)
        b.Size = UDim2.new(1, -16, 0, 24); b.Position = UDim2.fromOffset(8, y)
        b.Font = Enum.Font.GothamBold; b.TextSize = 11
        b.TextColor3 = TEXT; b.BorderSizePixel = 0; b.AutoButtonColor = true
        corner(b, 5)
        local function up()
            local on = get()
            b.Text = label .. (on and ": ON" or ": OFF")
            b.BackgroundColor3 = on and GREEN or GREY
        end
        b.MouseButton1Click:Connect(function() set(); up() end)
        up(); ups[#ups + 1] = up
    end
    local function refreshToggles() for _, u in ipairs(ups) do pcall(u) end end

    local function setEnabled(state)
        enabled = state
        _G.MynxxFaceAwayOn = enabled
        local char = localPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = not enabled end
        refreshToggles()
        if updateStatus then updateStatus() end
    end
    
    _G.MynxxToggleFaceAway = function() setEnabled(not enabled) end

    local function setClickFace(state)
        clickFaceEnabled = state
            clickFaceTarget = nil
            if refreshHighlight then refreshHighlight() end
            if updateStatus then updateStatus() end
        end
        refreshToggles()
    end

    
    mkToggle(30, "Face Away",
        function() return enabled end,
        function() setEnabled(not enabled) end)

    mkToggle(58, "BASE OWNER",
        function() return useBaseOwner end,
        function()
            clickFaceTarget = nil
            useBaseOwner = true; useNearest = false; selectedPlayer = nil
            refreshToggles()
            if refreshHighlight then refreshHighlight() end
            if updateStatus then updateStatus() end
        end)

    mkToggle(86, "NEAREST",
        function() return useNearest end,
        function()
            clickFaceTarget = nil
            useBaseOwner = false; useNearest = true; selectedPlayer = nil
            refreshToggles()
            if refreshHighlight then refreshHighlight() end
            if updateStatus then updateStatus() end
        end)

    mkToggle(114, "CLICK-TO-FACE",
        function() return clickFaceEnabled end,
        function() setClickFace(not clickFaceEnabled) end)

    
    

    local status = Instance.new("TextLabel", main)
    status.Size = UDim2.new(1, -16, 0, 24); status.Position = UDim2.new(0, 8, 1, -30)
    status.BackgroundTransparency = 1; status.Font = Enum.Font.Gotham
    status.TextSize = 11; status.TextColor3 = SUBTEXT
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextTruncate = Enum.TextTruncate.AtEnd

    
    function updateStatus()
        if clickFaceTarget and clickFaceTarget.Parent then
            status.Text = "Target: " .. clickFaceTarget.DisplayName .. " (click)"
            local owner = resolveBaseOwner()
            status.Text = owner
                and ("Target: base owner (" .. owner.DisplayName .. ")")
                or  "Target: base owner (searching...)"
            local myRoot  = getRoot(localPlayer)
            local nearest = myRoot and findNearest(myRoot)
            status.Text = nearest
                and ("Target: nearest (" .. nearest.DisplayName .. ")")
                or  "Target: nearest player"
        elseif selectedPlayer and selectedPlayer.Parent then
            status.Text = "Target: " .. selectedPlayer.DisplayName .. " (@" .. selectedPlayer.Name .. ")"
            status.Text = "Target: none"
        end
    end

    function refreshHighlight()
        for key, button in pairs(rowButtons) do
            local sel = (not useNearest and not useBaseOwner and not clickFaceTarget
                and key == selectedPlayer)
            button.BackgroundColor3 = sel and GREEN or ROW
        end
    end

    
    
    function rebuildList()
        refreshHighlight()
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == TOGGLE_KEY then setEnabled(not enabled)
        elseif input.KeyCode == UI_KEY  then main.Visible = not main.Visible end
    end)

    Players.PlayerAdded:Connect(function() task.defer(rebuildList) end)
    Players.PlayerRemoving:Connect(function(player)
        if player == selectedPlayer then selectedPlayer = nil; useBaseOwner = true end
        if player == clickFaceTarget then clickFaceTarget = nil end
        task.defer(rebuildList); task.defer(updateStatus)
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.2); setEnabled(enabled)
    end)

    
    task.spawn(function()
        local wasStealing, autoEnabled = false, false
        task.wait(1)
        while task.wait(0.15) do
            local isStealing = localPlayer:GetAttribute("Stealing")
                task.spawn(function()
                    task.wait(0.5)
                    if localPlayer:GetAttribute("Stealing") and not enabled then
                        setEnabled(true); autoEnabled = true
                    end
                end)
            end
                task.spawn(function()
                    task.wait(0.3)
                    if not localPlayer:GetAttribute("Stealing") and autoEnabled then
                        setEnabled(false); autoEnabled = false
                    end
                end)
            end
            wasStealing = isStealing
        end
    end)

    task.spawn(function()
        while task.wait(1) do
            if useBaseOwner or useNearest or clickFaceTarget then updateStatus() end
        end
    end)

    
    local CLICK_COLOR = Color3.fromRGB(255, 170, 60)
    local targetHighlight = Instance.new("Highlight")
    targetHighlight.Name                = "FlasherTargetHighlight"
    targetHighlight.FillTransparency    = 0.6
    targetHighlight.OutlineTransparency = 0
    targetHighlight.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    targetHighlight.Enabled             = false
    targetHighlight.Parent              = gui

    function updateHighlight(targetPlayer)
        local char = targetPlayer and targetPlayer.Character
        if char and (enabled or clickFaceTarget) then
            local color = (targetPlayer == clickFaceTarget) and CLICK_COLOR or ACCENT
            if targetHighlight.Adornee ~= char then targetHighlight.Adornee = char end
            targetHighlight.FillColor    = color
            targetHighlight.OutlineColor = color
            targetHighlight.Enabled      = true
            targetHighlight.Enabled = false
            targetHighlight.Adornee = nil
        end
    end

    function pulseHighlight()
        targetHighlight.FillTransparency = 0.05
        TweenService:Create(targetHighlight,
            TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { FillTransparency = 0.6 }):Play()
    end

    
    local function playerAtCursor()
        local camera = workspace.CurrentCamera
        local mousePos = UserInputService:GetMouseLocation()
        local best, bestDist = nil, CLICK_RADIUS
        for _, player in ipairs(Players:GetPlayers()) do
            local char = player ~= localPlayer and player.Character
                for _, partName in ipairs({ "HumanoidRootPart", "Head" }) do
                    local part = char:FindFirstChild(partName)
                        local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                            local d = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if d < bestDist then best, bestDist = player, d end
                        end
                    end
                end
            end
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
        local hitPlayer = playerAtCursor()
        if clickFaceTarget == hitPlayer then
            clickFaceTarget = nil
            clickFaceTarget = hitPlayer
            updateHighlight(clickFaceTarget)
            pulseHighlight()
        end
        refreshHighlight()
        updateStatus()
    end)

    
    local function resolveTarget(myRoot)
        if clickFaceTarget and clickFaceTarget.Parent then return clickFaceTarget end
        if useBaseOwner then return resolveBaseOwner() end
        return findNearest(myRoot)
    end

    local function flasherStep(dt)
        local myRoot = getRoot(localPlayer)
        local target = myRoot and resolveTarget(myRoot) or clickFaceTarget
        updateHighlight(target)

        local char = localPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.AutoRotate then hum.AutoRotate = false end

        local targetRoot = getRoot(target)

        local flat = Vector3.new(
            targetRoot.Position.X - myRoot.Position.X,
            0,
            targetRoot.Position.Z - myRoot.Position.Z
        )
        if flat.Magnitude < 0.05 then return end

        local goal = CFrame.lookAt(myRoot.Position, myRoot.Position - flat.Unit)
        if TURN_SPEED <= 0 then
            myRoot.CFrame = goal
            myRoot.CFrame = myRoot.CFrame:Lerp(goal, 1 - math.exp(-TURN_SPEED * dt))
        end

        local av = myRoot.AssemblyAngularVelocity
        if av.Y ~= 0 then
            myRoot.AssemblyAngularVelocity = Vector3.new(av.X, 0, av.Z)
        end
    end

    RunService.RenderStepped:Connect(flasherStep)
    RunService.Heartbeat:Connect(flasherStep)

    
    rebuildList()
    updateStatus()
    setEnabled(false)
end)
if not okFL then warn("[FLASHER] BLOC EN ERREUR: " .. tostring(errFL)) end
end)