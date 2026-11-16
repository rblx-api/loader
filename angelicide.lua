--Depresivo goat
if not game:IsLoaded() then game.Loaded:Wait() end

-- ===== GUIs cuadradas =====
_G.__SQ=function(root)
-- GUIs redondeadas: a todo Frame/Button/TextBox con fondo sin UICorner se le agrega uno
local function rd(o)
if not(o:IsA('Frame')or o:IsA('TextButton')or o:IsA('TextBox'))then return end
task.defer(function()
if not o.Parent or o:FindFirstChildOfClass('UICorner')then return end
if o.BackgroundTransparency>=1 then return end
local sz=o.Size
local h=sz.Y.Scale==0 and sz.Y.Offset or nil
local w=sz.X.Scale==0 and sz.X.Offset or nil
if(h and h<3)or(w and w<3)then return end
local r=8
if h then r=math.min(r,math.floor(h/2)) end
if w then r=math.min(r,math.floor(w/2)) end
if r<2 then return end
local c=Instance.new('UICorner')c.CornerRadius=UDim.new(0,r)c.Parent=o
end)
end
for _,d in root:GetDescendants()do rd(d)end
root.DescendantAdded:Connect(rd)
end

-- ===== AP order config (compartido: panel + ClickToAp) =====
do
local HS=game:GetService("HttpService")
local FILE="depresivini_ap_order.json"
local ALL={'tiny','rocket','inverse','jail','ragdoll','balloon','control','jumpscare','morph'}
local DEFOFF={control=true,jumpscare=true,morph=true}
local cfg={Value={},Off={},NoClick={},NoProx={},Range=15}
local had=false
pcall(function()
if isfile and isfile(FILE) then
local d=HS:JSONDecode(readfile(FILE))
if type(d)=='table' then
had=true
local seen={}
if type(d.Value)=='table' then for _,c in d.Value do if table.find(ALL,c) and not seen[c] then seen[c]=true cfg.Value[#cfg.Value+1]=c end end end
if tonumber(d.Range) then cfg.Range=math.clamp(math.floor(tonumber(d.Range)+0.5),5,50) end
if type(d.Off)=='table' then for k,v in d.Off do if table.find(ALL,k) and v then cfg.Off[k]=true end end end
if type(d.NoClick)=='table' then for k,v in d.NoClick do if table.find(ALL,k) and v then cfg.NoClick[k]=true end end end
if type(d.NoProx)=='table' then for k,v in d.NoProx do if table.find(ALL,k) and v then cfg.NoProx[k]=true end end end
end
end
end)
for _,c in ALL do if not table.find(cfg.Value,c) then cfg.Value[#cfg.Value+1]=c cfg.Off[c]=if had then true elseif DEFOFF[c] then true else nil end end
function cfg.Save() pcall(function() writefile(FILE,HS:JSONEncode({Value=cfg.Value,Off=cfg.Off,NoClick=cfg.NoClick,NoProx=cfg.NoProx,Range=cfg.Range})) end) end
_G.__APOrder=cfg
end

-- ===== ANTI ERROR (siempre prendido, sin GUI) =====
do
local _GS=(cloneref and cloneref(game:GetService("GuiService")))or game:GetService("GuiService")
getgenv().__AntiErrorGen=(getgenv().__AntiErrorGen or 0)+1
local _gen=getgenv().__AntiErrorGen
task.spawn(function()
while getgenv().__AntiErrorGen==_gen do
pcall(function()_GS:ClearError()end)
task.wait(0.005)
end
end)
end

-- ===== MOUSE BINDS: MB1 MB2 MB3 (eventos) y MB4 MB5 (iskeypressed) =====
do
local types={MB1=Enum.UserInputType.MouseButton1,MB2=Enum.UserInputType.MouseButton2,MB3=Enum.UserInputType.MouseButton3}
local vks={MB4=0x05,MB5=0x06}
local cache={}
getgenv().__MBind=function(name)
if cache[name]then return cache[name]end
if types[name]or vks[name]then cache[name]={Name=name,Type=types[name],VK=vks[name]}return cache[name]end
return nil
end
getgenv().__MBFromInput=function(input,processed)
local nm
for n,t in types do if input.UserInputType==t then nm=n end end
if not nm then return nil end
if nm=='MB1'and processed then return nil end
return getgenv().__MBind(nm)
end
getgenv().__BindHit=function(bind,input)
if bind==nil then return false end
if bind==input.KeyCode then return true end
return type(bind)=='table'and bind.Type~=nil and bind.Type==input.UserInputType
end
getgenv().__MBCaps={}
end
_G.__SE_BgList={}
_G.__SE_BgFile=nil
_G.__SE_ApplyBg=function()for _,_i in _G.__SE_BgList do pcall(function()if _G.__SE_BgFile then _i.Image=getcustomasset(_G.__SE_BgFile)_i.Visible=true else _i.Visible=false end end)end end
_G.__SE_AddBg=function(_i)table.insert(_G.__SE_BgList,_i)_G.__SE_ApplyBg()end
_G.__SE_SetBg=function(_u)if type(_u)~='string'or not _u:find'^https?://'then _G.__SE_BgFile=nil _G.__SE_ApplyBg()return end task.spawn(function()local _h=0 for _i=1,#_u do _h=(_h*31+string.byte(_u,_i))%2147483647 end local _f='SXE_TargetBg_'.._h..'.png'local _ok=pcall(function()if not(isfile and isfile(_f))then local _r=request({Url=_u,Method='GET'})if not _r or _r.StatusCode~=200 or not _r.Body or#_r.Body<100 then error('download failed')end writefile(_f,_r.Body)end end)_G.__SE_BgFile=if _ok then _f else nil _G.__SE_ApplyBg()end)end


-- ===== Auto Walkspeed on steal (del New Text Document) =====
do
task.spawn(function()
local Players=game:GetService("Players"); local RunService=game:GetService("RunService"); local HS=game:GetService("HttpService")
while not Players.LocalPlayer do task.wait() end
local LP=Players.LocalPlayer
local W={on=false, v=27}
pcall(function() if isfile and readfile and isfile("Angelicide_Walk.json") then local d=HS:JSONDecode(readfile("Angelicide_Walk.json")); if type(d)=="table" then if type(d.on)=="boolean" then W.on=d.on end if tonumber(d.v) then W.v=math.clamp(math.floor(tonumber(d.v)+0.5),16,27) end end end end)
local function save() pcall(function() writefile("Angelicide_Walk.json", HS:JSONEncode(W)) end) end
_G.AngelicideWalkApi={W=W,save=save}
local LOOSE={[Enum.HumanoidStateType.Physics]=true,[Enum.HumanoidStateType.Ragdoll]=true,[Enum.HumanoidStateType.FallingDown]=true,[Enum.HumanoidStateType.Freefall]=true,[Enum.HumanoidStateType.Jumping]=true}
local function stealing() local v=LP:GetAttribute("Stealing"); if v==nil or v==false then local c=LP.Character; v=c and c:GetAttribute("Stealing") end return v~=nil and v~=false end
local wasMoving,resumeAt,persoVu=false,0,nil
while true do
task.wait((W.on and stealing()) and 0.03 or 0.1)
pcall(function()
local char=LP.Character
if char~=persoVu then persoVu=char; wasMoving,resumeAt=false,0 end
if typeof(getgenv)=="function" and getgenv().__AuroraSpeed then return end
if not W.on or not stealing() then return end
if _G.D3FlightActive or _G._isTpMoving or _G.isCloning or _G.__AngelicideVelFlying or _G.__AngelicideTPStarted then return end
local hrp=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid")
if not(hrp and hum) or hum.Health<=0 then return end
local now=os.clock(); local md=hum.MoveDirection; local moving=md.Magnitude>=0.05
if wasMoving and not moving then resumeAt=now+0.08 end
wasMoving=moving
local vy=hrp.AssemblyLinearVelocity.Y
if now<resumeAt then hrp.AssemblyLinearVelocity=Vector3.new(0,vy,0); return end
local st=hum:GetState()
if not moving then
if st~=Enum.HumanoidStateType.Freefall and st~=Enum.HumanoidStateType.Jumping and not LOOSE[st] then hrp.AssemblyLinearVelocity=Vector3.new(0,vy,0) end
return
end
local u=md.Unit; local v=math.clamp(W.v,16,27)
hrp.AssemblyLinearVelocity=Vector3.new(u.X*v,vy,u.Z*v)
end)
end
end)
end


local __ANG
do
local a={cache={}}
do local function __modImpl()return function(b)local c=game
:FindFirstChildOfClass(b)while not c do task.wait()c=game:FindFirstChildOfClass(
b)end return c end end function a.a()local b=a.cache.a if not b then b={c=
__modImpl()}a.cache.a=b end return b.c end end do local function __modImpl()local b,c,d,e=bit32.band,bit32.bor,bit32.
bxor,bit32.bnot local f,g,h=bit32.lshift,bit32.rshift,bit32.rrotate local i,j=
string.byte,string.char local k={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,
0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,
0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,
0xfc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,
0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x6ca6351,0x14292967,
0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,
0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,
0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,
0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,
0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function Word(l)return j(b(g(l
,24),255),b(g(l,16),255),b(g(l,8),255),b(l,255))end local function Sha256(l)
local m=#l*8 local n=l..'\128'n=n..string.rep('\0',(56-#n%64)%64)..Word(math.
floor(m/4294967296))..Word(m%4294967296)local o={0x6a09e667,0xbb67ae85,
0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}local p=table.
create(64)for q=1,#n,64 do for r=0,15 do local s=q+r*4 p[r]=c(f(i(n,s),24),f(i(n
,s+1),16),f(i(n,s+2),8),i(n,s+3))end for r=16,63 do local s,t=p[r-15],p[r-2]p[r]
=b(p[r-16]+d(h(s,7),h(s,18),g(s,3))+p[r-7]+d(h(t,17),h(t,19),g(t,10)),0xffffffff
)end local r,s,t,u,v,w,x,y=o[1],o[2],o[3],o[4],o[5],o[6],o[7],o[8]for z=0,63 do
local A=b(y+d(h(v,6),h(v,11),h(v,25))+d(b(v,w),b(e(v),x))+k[z+1]+p[z],0xffffffff
)local B=b(d(h(r,2),h(r,13),h(r,22))+d(b(r,s),b(r,t),b(s,t)),0xffffffff)y,x,w,v,
u,t,s,r=x,w,v,b(u+A,0xffffffff),t,s,r,b(A+B,0xffffffff)end o[1],o[2],o[3],o[4]=
b(o[1]+r,0xffffffff),b(o[2]+s,0xffffffff),b(o[3]+t,0xffffffff),b(o[4]+u,
0xffffffff)o[5],o[6],o[7],o[8]=b(o[5]+v,0xffffffff),b(o[6]+w,0xffffffff),b(o[7]+
x,0xffffffff),b(o[8]+y,0xffffffff)end return Word(o[1])..Word(o[2])..Word(o[3])
..Word(o[4])..Word(o[5])..Word(o[6])..Word(o[7])..Word(o[8])end local function 
Hex(l)return(l:gsub('.',function(m)return string.format('%02x',i(m))end))end
return{Sha256=Sha256,Hex=Hex}end function a.c()local b=a.cache.c if not b then b
={c=__modImpl()}a.cache.c=b end return b.c end end do local function __modImpl()
local b=a.a()local c='^%x+%-%x+%-%x+%-%x+%-%x+$'local function Keys(d)if type(d)
=='table'then return d end local e={}for f in string.gmatch(tostring(d),'[^%.]+'
)do e[#e+1]=tonumber(f)or f end return e end local function Apply(d,e)local f,g,
h,i=Keys(e[1]),e[2],e[3],e[4]if#f==0 then if type(h)=='table'then table.clear(d)
for j,k in h do d[j]=k end end return end local j=d for k=1,#f-1 do local l=j[f[
k] ]if type(l)~='table'then l={}j[f[k] ]=l end j=l end local k=f[#f]if g==
'ArrayInsert'then local l=j[k]if type(l)~='table'then l={}j[k]=l end if type(i)
=='number'then table.insert(l,i,h)else table.insert(l,h)end elseif g==
'ArrayRemoved'then local l=j[k]if type(l)=='table'and type(i)=='number'then
table.remove(l,i)end elseif g=='DictionaryRemoved'then j[k]=nil else j[k]=h end
end return function()local d={}local e={}local f={}local function Notify(g)for h
,i in f do task.spawn(i,g)end end local function Fetch(g,h)for i=1,10 do local j
,k=pcall(g.InvokeServer,g,h)if j and type(k)=='table'then d[h]=k Notify(h)return
end task.wait(1)end end local function Route(g)e[g]=true local h=g.Name g.
OnClientEvent:Connect(function(i)if type(i)~='table'then return end local j=d[h]
or{}d[h]=j for k,l in i do if type(l)=='table'then pcall(Apply,j,l)end end
Notify(h)end)end task.spawn(function()local g=b'ReplicatedStorage'while true do
local h=g:FindFirstChild'Packages'local i=h and h:FindFirstChild'Synchronizer'
local j=i and i:FindFirstChild'Channel'local k=i and i:FindFirstChild
'RequestData'if j and k and k:IsA'RemoteFunction'then for l,m in j:GetChildren()
do if not e[m]and m:IsA'RemoteEvent'and m.Name:match(c)then Route(m)task.spawn(
Fetch,k,m.Name)end end end task.wait(0.100000000468)end end)return d,function(g)f[#f+1]=g
end end end function a.e()local b=a.cache.e if not b then b={c=__modImpl()}a.
cache.e=b end return b.c end end do local function __modImpl()local b=a.c()
local c='2b857474-f9cc-4ddd-a4f1-28be8b6c1b38'
-- The salt of the name hash changes when the game updates: the known one is tried first, and when no hash layout finds
-- the remote, the salt is looked up once (verified, or dug out of the game's Net module) and the lookup is retried.
local NETMOD = function()
local a = {cache = {}}
function a.a()
    return {
        Services = setmetatable({}, {__index = function(_, name) return game:GetService(name) end}),
        Require = function(module) return require(module) end,
    }
end
do local function __modImpl()local aa=a.a()
local ab=bit32.band local ac=bit32.bor local ad=bit32.bxor local ae=bit32.bnot
local af=bit32.rrotate local ag=bit32.rshift local ah=bit32.lshift local ai=
string.byte local aj=string.char local ak=string.sub local al=string.rep local
am=string.pack local an=string.format local ao=string.find local ap=table.concat
local aq=table.create local ar=task.wait local as=aa.Services.ReplicatedStorage
local at=aa.Services.RunService local au='2b857474-f9cc-4ddd-a4f1-28be8b6c1b38'
local av={}local aw local ax local ay=false local az={}local aA={1116352408,
1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,
3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,
3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,
1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,
3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,
1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,
3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,
659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,
2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298}
local aB=aq(64,0)local function Blocks(aC,aD,aE,aF)local aG,aH,aI,aJ=aC[1],aC[2]
,aC[3],aC[4]local aK,aL,aM,aN=aC[5],aC[6],aC[7],aC[8]for aO=aE,aF,64 do local aP
=aO for aQ=1,16 do local aR,aS,aT,aU=ai(aD,aP,3+aP)aB[aQ]=ac(ah(aR,24),ah(aS,16)
,ah(aT,8),aU)aP+=4 end for aQ=17,64 do local aR,aS=aB[aQ-2],aB[aQ-15]aB[aQ]=ad(
af(aR,17),af(aR,19),ag(aR,10))+aB[aQ-7]+ad(af(aS,7),af(aS,18),ag(aS,3))+aB[aQ-16
]end local aQ,aR,aS,aT=aG,aH,aI,aJ local aU,aV,aW,aX=aK,aL,aM,aN for aY=1,64 do
local aZ=aX+ad(af(aU,6),af(aU,11),af(aU,25))+ad(ab(aU,aV),ab(ae(aU),aW))+aA[aY]+
aB[aY]local a_=ad(af(aQ,2),af(aQ,13),af(aQ,22))+ad(ab(aQ,aR),ab(aQ,aS),ab(aR,aS)
)aX,aW,aV,aU,aT,aS,aR,aQ=aW,aV,aU,aT+aZ,aS,aR,aQ,aZ+a_ end aG,aH,aI,aJ=ac(aG+aQ,
0),ac(aH+aR,0),ac(aI+aS,0),ac(aJ+aT,0)aK,aL,aM,aN=ac(aK+aU,0),ac(aL+aV,0),ac(aM+
aW,0),ac(aN+aX,0)end aC[1],aC[2],aC[3],aC[4],aC[5],aC[6],aC[7],aC[8]=aG,aH,aI,aJ
,aK,aL,aM,aN end local function Sha256(aC)local aD={1779033703,3144134277,
1013904242,2773480762,1359893119,2600822924,528734635,1541459225}local aE=#aC
local aF=aE%64 if aE>=64 then Blocks(aD,aC,1,aE-aF)end local aG=ab(aF+32,
4294967232)local aH=if aF==0 then''else ak(aC,-aF)local aI=ap{aH,'\128',al('\0',
(aG-aF-9)%64),am('>L',aE*8)}Blocks(aD,aI,1,#aI)local aJ=aq(8)for aK=1,8 do aJ[aK
]=an('%08x',aD[aK])end return ap(aJ)end local function Encode(aC,aD)local aE=aq(
#aC)local aF=0 for aG=1,#aC do local aH=ak(aC,aG,aG)if aH=='/'then aE[aG]=aH
continue end aE[aG]=aj(32+((ai(aH)-32)+(ai(aD,aF%#aD+1)%95))%95)aF+=1 end return
ap(aE)end local aC={function(aC,aD,aE)return aC..aD..aE end,function(aC,aD,aE)
return aC..aE..aD end,function(aC,aD,aE)return aD..aC..aE end,function(aC,aD)
return aC..aD end}local aD={'StealService/Grab','WorldBrainrotService/Grab',
'WorldBrainrotService/Drop','InventoryService/Sort','Tools/Cooldown'}local aE=1
local function Hash(aF,aG,aH,aI)local aJ=game.JobId return aG..Sha256(aC[aI or
aE](Encode(aF,aJ),aH,aJ))end local function GetFolder()if not aw then aw=as:
WaitForChild"Packages":WaitForChild'Net'end return aw end local function Verify(
aF)if type(aF)~='string'or#aF<4 or#aF>128 then return false end local aG=
GetFolder()for aH in aC do for aI,aJ in aD do local aK=Hash(aJ,'',aF,aH)if aG:
FindFirstChild('RE/'..aK)or aG:FindFirstChild('RF/'..aK)then aE=aH return true
end end end return false end local function Resolver(aF,aG)local aH=getrenv()
local aI=setmetatable({},{__index=aH,__newindex=aH})rawset(aI,'script',aF)
rawset(aI,'shared',shared)local aJ=loadstring(
[[local Env, Module, Field, Name = ...
setfenv(0, Env)
local function Inner() return Module[Field](Module, Name) end
local function Outer() return Inner() end
return Outer()
]]
,'='..aF:GetFullName())if not aJ then return nil end setfenv(aJ,aI)return
function(aK,aL)coroutine.resume(coroutine.create(aJ),aI,aK,aG,aL)end end local
aF={[coroutine.yield]=true,[coroutine.wrap]=true,[coroutine.resume]=true,[
coroutine.create]=true,[coroutine.close]=true}local function Pools(aG)local aH={
}local aI={}local aJ for aK,aL in aG do if type(aL)~='function'then continue end
if aK=='RemoteEvent'or not aJ then aJ=aK end local aM,aN=pcall(debug.getupvalues
,aL)if not aM or type(aN)~='table'then continue end for aO,aP in aN do if type(
aP)~='table'or aI[aP]then continue end local aQ=0 for aR,aS in aP do if type(aS)
=='function'then aQ+=1 end end if aQ>=5 then aI[aP]=true table.insert(aH,aP)end
end end return aH,aJ end local function Sweep(aG,aH)local aI=as:FindFirstChild
'Controllers'local aJ=aI and aI:FindFirstChild'PlotController'if not aJ then
return false end local aK=aa.Require(GetFolder())local aL,aM=Pools(aK)if#aL==0
or not aM then return false end local aN=Resolver(aJ,aM)if not aN then return
false end local aO={}local aP=false local aQ=0 local function Scan()aQ+=1 for aR
=2,6 do local aS,aT=pcall(debug.getstack,aR)if not aS or type(aT)~='table'then
continue end for aU,aV in aT do if aH(aV)then aP=true return end if type(aV)==
'table'then for aW,aX in aV do if aH(aX)then aP=true return end end end end end
end local aR={}for aS,aT in aL do for aU,aV in aT do if type(aV)~='function'or
aF[aV]then continue end local aW=aV table.insert(aR,{aT,aU,aW})pcall(rawset,aT,
aU,function(...)if not aP then pcall(Scan)if aP or aQ>=aG then error(aO)end end
return aW(...)end)end end aN(aK,'ZzSaltProbe/'..math.random(1000000,9999999))for
aS,aT in aR do pcall(rawset,aT[1],aT[2],aT[3])end return aP end local function 
Dump()local aG=game.JobId local aH=
[[^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$]]
local aI Sweep(400,function(aJ)if type(aJ)~='string'or#aJ~=36 or aJ==aG or not
string.match(aJ,aH)then return false end aI=aJ return true end)if Verify(aI)then
return aI end for aJ,aK in{40,160}do local aL={}local aM={}Sweep(aK,function(aN)
if type(aN)~='string'or#aN<4 or#aN>128 or aN==aG or aL[aN]or ao(aN,'%c')then
return false end aL[aN]=true table.insert(aM,aN)return false end)for aN,aO in aM
do if Verify(aO)then return aO end end end return nil end local function Load()
if ax then return true end if ay then repeat at.Heartbeat:Wait()until not ay
return ax~=nil end ay=true local aG=os.clock()+3 while not Verify(au)and os.
clock()<aG do ar(0.1)end if Verify(au)then ax=au else local aH,aI=pcall(Dump)if
aH and aI then ax=aI else warn('net salt dump failed:',if aH then
'no candidate matched'else aI)end end ay=false return ax~=nil end local function 
Resolve(aG,aH)local aI=aH..aG local aJ=az[aI]if aJ~=nil then return aJ or nil
end local aK if Load()then aK=GetFolder():FindFirstChild(Hash(aG,aH,ax))end if
aK then az[aI]=aK end return aK end function av.Event(aG)return(Resolve(aG,'RE/'
))end function av.Function(aG)return(Resolve(aG,'RF/'))end function av.Salt()
Load()return ax end return av end function a.n()local aa=a.cache.n if not aa
then aa={c=__modImpl()}a.cache.n=aa end return aa.c end end
return a.n()
end

local function Encode(d,e)local f=table.create(#d)local g=0 for h=1,#d do local i=string.sub(d,h,h)if i=='/'then f[h]=i else f[h]=string.char(32+((string.byte(i)-32)+(string.byte(e,g%#e+1)%95))%95)g+=1 end end return table.concat(f)end
local d={}
local ORD={function(x,y,z)return x..y..z end,function(x,y,z)return x..z..y end,function(x,y,z)return y..x..z end,function(x,y)return x..y end}
local saltState='idle'
local function RefreshSalt()
if saltState=='done' then return end
if saltState=='running' then local t=os.clock()+25 while saltState=='running' and os.clock()<t do task.wait(0.05) end return end
saltState='running'
pcall(function()local mod=NETMOD()local s=mod and mod.Salt()if type(s)=='string' and s~='' and s~=c then c=s table.clear(d)end end)
saltState='done'
end
local function Resolve(e,f)
local g=e..f local h=d[g]if h and h.Parent then return h end
local i=game:FindFirstChildOfClass'ReplicatedStorage'local j=i and i:FindFirstChild'Packages'
local k=j and j:FindFirstChild'Net'if not k then return nil end
local l=game.JobId
local function Lookup()
local enc=Encode(f,l)
for o=1,#ORD do local m=k:FindFirstChild(e..b.Hex(b.Sha256(ORD[o](enc,c,l))))if m then return m end end
return nil
end
local m=Lookup()
if not m and saltState~='done' then RefreshSalt()m=Lookup()end
if m then d[g]=m end
return m
end
task.spawn(function()if not game:IsLoaded()then game.Loaded:Wait()end task.wait(2)pcall(RefreshSalt)end)
return{Event=function(e)return(Resolve('RE/',e))end,Function=function(e)return(Resolve('RF/',e))end,Unreliable=function(e)return(Resolve('URE/',e))end}end function a.h()local b=a.cache.h if not b then b={c=
__modImpl()}a.cache.h=b end return b.c end end
__ANG = { net = a.h(), sync = a.e() }
end
local a={cache={}}do do local function __modImpl()local b=os.clock()local c=
getgenv().Hub if c and c.Flush then pcall(c.Flush)end local d=task.delay local e
=task.cancel local f=cloneref or function(f)return f end local g=setmetatable({}
,{__index=function(g,h)local i=f(game:GetService(h))rawset(g,h,i)return i end})
local h=g.HttpService local i=g.Players local j=gethui or function()return g.
CoreGui end local k={}local l={RBXScriptConnection=function(l)l:Disconnect()end,
Instance=function(l)l:Destroy()end,['function']=function(l)l()end,thread=
function(l)task.cancel(l)end}local function Clean(m)k[#k+1]=m return m end local 
function Connect(m,n)return Clean(m:Connect(n))end local function Empty(m)for n=
#m,1,-1 do local o=m[n]local p,q=pcall(l[typeof(o)],o)if not p then warn(
'cleanup errored:',q)end end table.clear(m)end local m='hub'local n=
'depresivo hub.json'local o={}local p={}if isfile(n)then local q,r=pcall(h.
JSONDecode,h,readfile(n))if q and type(r)=='table'then p=r else warn
'config is broken, going with defaults'end end local function Accept(q,r)if
typeof(q)=='EnumItem'then return type(r)=='string'and q.EnumType:FromName(r)or q
end return if type(r)==type(q)then r else q end local function Define(q)for r,s
in q do local t=p[r]o[r]=if t==nil then s else Accept(s,t)end return o end local 
function Write()local q=table.clone(p)for r,s in o do q[r]=if typeof(s)==
'EnumItem'then s.Name else s end writefile(n,h:JSONEncode(q))end local q local r={}local function Save()for s,t
in r do t()end if q then return end q=d(0.5,function()q=nil Write()end)end local 
function Flush()if not q then return end e(q)q=nil Write()end local function 
Changed(s)r[#r+1]=s end local s={Running=true,Lite=getgenv().FastLoad==true,
LoadedAt=nil,Steal=nil,Admin=nil,Owned=(setmetatable({},{__mode='k'})),Started=b
,Services=g,LocalPlayer=i.LocalPlayer,Settings=o,Flush=Flush,GetHui=j,Define=
Define,Save=Save,Changed=Changed,Clean=Clean,Connect=Connect,Empty=Empty,
Framework=nil,Menu=nil}local t=if getrenv then getrenv()else nil local function 
Scrub()local u=t if rawget(u,'_G')~=nil then rawset(u,'_G',nil)end if rawget(u,
'shared')~=nil then rawset(u,'shared',nil)end end if t then Scrub()Connect(g.
RunService.Heartbeat,Scrub)end function s.Ready()while not i.LocalPlayer do i:
GetPropertyChangedSignal'LocalPlayer':Wait()end s.LocalPlayer=i.LocalPlayer end
local u=getloadedmodules local function IsLoaded(v)local w=v:GetFullName()for x,
y in(u)()do if y:GetFullName()==w then return true end end return false end
local function Settle(v)if not game:IsLoaded()then game.Loaded:Wait()end return
if v:IsA'ModuleScript'then require(v)else nil end function s.Cached(v)if s.Lite
then return Settle(v)end if u and not IsLoaded(v)then return nil end return
require(v)end function s.Require(v,w)if s.Lite then return Settle(v)end if u
then local x=os.clock()+(w or 30)while not IsLoaded(v)do if os.clock()>=x then
if 0==w then return nil end break end task.wait(0.05)end end return require(v)
end s.Timings={}local v=0 Connect(g.RunService.PreRender,function()v+=1 end)
function s.NextFrame()local w=v repeat g.RunService.Heartbeat:Wait()until v~=w
end local w=-math.huge local x=0.016 function s.Breathe()if os.clock()-w>x then
s.NextFrame()w=os.clock()end end local function Retire()local y=c if not y then
return end c=nil s.NextFrame()local z,A=pcall(y.Stop)if not z then warn(
'couldnt stop the old session:',A)end w=-math.huge end function s.Run(y,z)
Retire()s.Breathe()local A=os.clock()local B,C=xpcall(z,debug.traceback)table.
insert(s.Timings,{y,os.clock()-A,A-b})if not B then warn(y,'didnt load:',C)end
end function s.Stop()if not s.Running then return end s.Running=false Flush()
Empty(k)if getgenv().Hub==s then getgenv().Hub=nil end end do local y=Instance.
new"Part"y.Name='Floor'y.Anchored=true y.CanTouch=false y.Size=Vector3.new(252,
50.8750114440918,401)y.CFrame=CFrame.new(-410.4400634765625,-35.48800354003906,
59.40599822998047)y.Color=Color3.fromRGB(31,127,29)y.Material=Enum.Material.
SmoothPlastic y.TopSurface=Enum.SurfaceType.Smooth y.BottomSurface=Enum.
SurfaceType.Smooth y.Parent=g.Workspace s.Clean(y)local z=g.Workspace:
FindFirstChild'DiggingCarpetWalls'if z then z:Destroy()end Connect(g.Workspace.
ChildAdded,function(A)if A.Name=='DiggingCarpetWalls'then A:Destroy()end end)end
getgenv().Hub=s return s end function a.a()local b=a.cache.a if not b then b={c=
__modImpl()}a.cache.a=b end return b.c end end do local function __modImpl()
local b=a.a()local c=task.spawn local d=task.defer local e=math.clamp local f=b.
Services.UserInputService local g=b.Define{Modules={}}.Modules local function 
Record(h,i)if g[h]==nil and i and g[i]~=nil then g[h],g[i]=g[i],nil end local j=
g[h]if type(j)~='table'then j={}g[h]=j end if type(j.Options)~='table'then j.
Options={}end return j end local function Render(h)if h.Render then h.Render()
end end local h={}h.__index=h function h.Set(i,j)i[i.Field]=j i.Module.Record.
Options[i.Name]=if typeof(j)=='Color3'then j:ToHex()else j b.Save()Render(i)if i
.Function then c(i.Function,j)end end function h.SetValue(i,j)if i.Field==
'Value'and i.Min then j=e(j,i.Min,i.Max)end i:Set(j)end function h.Toggle(i,j)i:
Set(if j==nil then not i.Enabled else j)end function h.Change(i,j)i.List=j if
not table.find(j,i.Value)then i:Set(j[1])else Render(i)end end function h.
SetVisible(i,j)i.Visible=j if i.Root then i.Root.Visible=j end end function h.
Press(i)if i.Function then c(i.Function)end end local function AddOption(i,j,k,l
,m)local n=setmetatable(table.clone(l),h)n.Kind=j n.Module=i n.Field=k i.Options
[l.Name]=n i.List[#i.List+1]=n if not k then return n end local o=i.Record.
Options[l.Name]if typeof(m)=='Color3'then n[k]=if type(o)=='string'then Color3.
fromHex(o)else m else n[k]=if o~=nil and type(o)==type(m)then o else m end
return n end local i={}local j={Toggle=true,Always=true,Hold=true}local k={}k.
__index=k function k.Clean(l,m)l.Trash[#l.Trash+1]=m return m end function k.
Toggle(l,m)if l.Action then c(l.Function)return end local n=if m==nil then not l
.Enabled else m if n==l.Enabled then return end l.Enabled=n if not l.Fresh then
l.Record.Enabled=n b.Save()end Render(l)if not n then b.Empty(l.Trash)end c(l.
Function,n)end function k.SetBind(l,m)l.Bind=m l.Record.Bind=if m then m.Name
else''b.Save()Render(l)end function k.SetMode(l,m)l.Mode=m l.Record.Mode=m b.
Save()Render(l)if m=='Always'then l:Toggle(true)end end function k.CreateToggle(
l,m)local n=AddOption(l,'Toggle','Enabled',m,m.Default==true)if n.Enabled and n.
Function then c(n.Function,true)end return n end function k.CreateSlider(l,m)
local n=AddOption(l,'Slider','Value',m,m.Default or m.Min)n.Value=e(n.Value,m.
Min,m.Max)return n end function k.CreateDropdown(l,m)local n=AddOption(l,
'Dropdown','Value',m,m.Default or m.List[1])if not table.find(m.List,n.Value)
then n.Value=m.Default or m.List[1]end return n end function k.CreateTextBox(l,m
)return AddOption(l,'TextBox','Value',m,m.Default or"")end function k.
CreateColor(l,m)return AddOption(l,'Color','Value',m,m.Default or Color3.new(1,1
,1))end function k.CreateButton(l,m)return AddOption(l,'Button',nil,m,nil)end
function k.CreateOrder(l,m)local n=AddOption(l,'Order','Value',m,table.clone(m.
Default))local o=#n.Value==#m.Default for p,q in m.Default do if not table.find(
n.Value,q)then o=false end end if not o then n.Value=table.clone(m.Default)end
local p=l.Record.Options[m.Name..' off']n.Off={}for q,r in if o and type(p)==
'table'then p else m.Off or{}do n.Off[r]=true end return n end function h.SetOff
(l,m,n)l.Off[m]=if n then true else nil local o={}for p in l.Off do o[#o+1]=p
end l.Module.Record.Options[l.Name..' off']=o b.Save()Render(l)end local l={
"Steal",'Combat','Blatant','Render','Utility','World','Widgets','Settings'}local
m={}local n={}local o=false local function Enqueue(p)n[#n+1]=p if o then return
end o=true c(function()while#n>0 do local q=table.remove(n,1)k.Toggle(q,true)
task.wait()end o=false end)end local p={}local q=false local function Announce(r
)p[#p+1]=r if q then return end q=true d(function()while#p>0 do local s=table.
remove(p,1)for t,u in m do u(s)end b.Breathe()end q=false end)end local r={}r.
__index=r local _ALW={AutoSteal=true,Indicators=1,BaseESP=1,Fullbright=1,HomeESP=1,AntiAdmin=1,AntiDeath=1,AntiKnockback=1,AntiRagdoll=1,AntiSwap=1,NoCollide=1}
function r.CreateModule(s,t)local u=t.Name if i[u]then error('module '
..u..' already exists')end local v=Record(u,t.Was)if _ALW[u]then v.Enabled=true end if v.Enabled==nil and t.
Default==true then v.Enabled=true end local w=setmetatable({Name=u,Tooltip=t.
Tooltip,Function=t.Function,Category=s.Name,Enabled=false,Bind=if type(v.Bind)==
'string'then(if v.Bind==''then nil else(getgenv().__MBind(v.Bind)or Enum.KeyCode:FromName(v.Bind)))else t.
Bind,Unblocked=t.Unblocked==true,Fresh=t.Fresh==true,Button=t.Button,Mode=j[v.
Mode]and v.Mode or'Toggle',Options={},List={},Trash={},Record=v},k)i[u]=w if _ALW[u]or s.Name=='Utility'or u=='Auto Kick'then w.Hidden=true end  s.Modules[#s.Modules+1]=w Announce(w)if(v.Enabled and not w.Fresh)or w.Mode==
'Always'then if t.Early then d(k.Toggle,w,true)else d(Enqueue,w)end end return w
end function r.CreateAction(s,t)local u=s:CreateModule(t)u.Action=true return u
end local s={}for t,u in l do s[u]=setmetatable({Name=u,Modules={}},r)end
setmetatable(s,{__index=function(t,u)error('no category named '..u)end})b.
Connect(f.InputBegan,function(t,u)local v=f:GetFocusedTextBox()~=nil for w,x in
i do if not getgenv().__BindHit(x.Bind,t)or x.Mode=='Always'or(u and(v or not x.Unblocked))then
continue end if x.Mode=='Hold'then x:Toggle(true)else x:Toggle()end end end)b.
Connect(f.InputEnded,function(t)for u,v in i do if getgenv().__BindHit(v.Bind,t)and v.Mode
=='Hold'then v:Toggle(false)end end end)do local _rs=game:GetService('RunService')local _down={}b.Connect(_rs.Heartbeat,function()
if type(iskeypressed)~='function'then return end
if type(isrbxactive)=='function'and not isrbxactive()then return end
for nm,vk in{MB4=0x05,MB5=0x06}do
local ok,d=pcall(iskeypressed,vk)d=ok and d==true
if d and not _down[nm]then
_down[nm]=true
local used=false
for _,cap in getgenv().__MBCaps do local ok2,r=pcall(cap,nm)if ok2 and r then used=true break end end
if not used and f:GetFocusedTextBox()==nil then
for _,x in i do if type(x.Bind)=='table'and x.Bind.Name==nm and x.Mode~='Always'then if x.Mode=='Hold'then x:Toggle(true)else x:Toggle()end end end
end
elseif not d and _down[nm]then
_down[nm]=false
for _,x in i do if type(x.Bind)=='table'and x.Bind.Name==nm and x.Mode=='Hold'then x:Toggle(false)end end
end
end
end)end b.Clean(function()for t,u in i do if not
u.Enabled then continue end u.Enabled=false b.Empty(u.Trash)c(u.Function,false)
end end)local t={Categories=s,Order=(function()local _o={}for _,_n in l do if _n~='Combat'and _n~='Settings'and _n~='Utility'then  _o[#_o+1]=_n end end return _o end)(),Added=m,Modules=i}b.Framework=t return t
end function a.b()local b=a.cache.b if not b then b={c=__modImpl()}a.cache.b=b
end return b.c end end do local function __modImpl()return{Add={Hash='424cb341',
Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\0\136IDATx\218\237\214\193\t\1280\fF\225?\142!\174\212=to\227\26\241R\16\197C{h\161\250>\2329\188R4\18\0\0\248\160\136H\17\225\249\164\17\3<.{\1719\2140 n\131\204\154\204\154F\127\170\4\16@\0\1\4\16P\187\219\20y\2513\23\170\218\157\172"\192%\205\157.\214\205l\225\t=\172\146\188\199\237K\218\216F\249\140\18@\0\1\4\16\240\247\128\227\177\30\140%\175\223{>I\0\0\224\131N\130c\156\a\173\185\253\17\0\0\0\0IEND\174B`\130'
},Admin={Hash="b4a99d55",Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\2\184IDATx\218\237\153;hTA\20\134\255\137\6\130\155\24D\209 \194ZZ\196\199\226\1632\149\18S\1366\218\6A\172c\19\18\27\181SAHR\169\168\4\212*n\'6\17\31\157\154(ZD\208"j\147\205"1"&\27\151\184~6\183\144\245\222\221\185\187s\239]p\127\152\230\238\156\127\206?g\30g\206JM4\241\127\195DA\nl\144tB\210\1\239\211\148\164\1721\230[\195\206\4\208\2\28\6\238\0\203\252\139\159\192\3\224$\176\182\145\28\223\1\\\4>c\143\0280\6\236N\202\233N\160\31x\4\252\166>\188\2\6\128MI/\145z\17\221\18\3\250\128Y\226\195,\208\231\202\249\30\160H\252(\2=.\4<#9<\173\230_\139\133\134}!5\207K\26\146\212-)\229\181nI\195\146\242!\185\246\187\136@\24L\0\237\21\184\218\129\251a\b\227\0200\1\24\v>\3d\27M@\174\210\204\251pv\0y\23\2Z\28\157\180\163\198\152%\235\4\204\152\31\146F]\f\236J\192\195\152l\194g\163\150\2350e\140)\132\\\154)IK\22\2092qD\192$\21}W\2\182\199d\19\153\128\1631\217\212t\140\218\228A\243\17\29\163E\23\17X\180\232\211%i\220\246"\1474.i\139\5\239W\23\17x\23\2266\206\2\29Uf>\27\130o&\137l4\15\f\3;\129\148\215v\1\231lo\223\191\240\196\133\128\145\4\211\233\171.\246\192\243\4k\6U\199\182\217t[%\205%$`\1551f\174\174\b\24cr\146^\'\224\252T5\231%\201\246\245\127K\210\222*}\222J\154\148\244F\210\140\164/\146\190{\191uJ\218\236\189\2042\146z%\237\169\194w\219u\29h9\224\1969\15\164k\224L\3\23\2N\166%`\189\235\27y\172l\144B-\142\a\b)\148q\143DR\176\5\22\202\171\6\192\154:\139e\147e\156\139\192\198\168\242\162\179>\225\190T\a\223\21\31\190\129(\19\187V`\218g\208\161\26\184\134}x\166\129\214\168\179\211\180\207R\2\24\f\1931\232c\191\224bO\133\169\149\150|\156\184\6\180U\176k\3\174\251\216\149\128\222\184K\236\167\128U\31g\222\3G\2D\127\240\233\191\n\244\'r\207\3\199\129\149\128D\236\5p\218k/\3\250\172\0\199\148$\188\234\245\167\0262\205\143\192A5\2\128u\192e\224\151\133\227%\224F\152\'h\156B2\192\189\128wt\17\184\vd\\\142\25\213\223\172]\146\206H:\228}z,\233\1661&\175&\154h\194)\254\0HH.l)\132\28\4\0\0\0\0IEND\174B`\130'
},Arrow={Hash='c9003a9b',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\0\195IDATx\218\237\2141\14\1300\24\197q6]\153\244\2\28\132E\24\220M\b\241v\220\198\171\232(1\154\252\29\236\128\132\18\n\166~\154\247K\24\251\229=\154\22\146DDDDDD$\16\144\1\233\a\230\164@\22;|\195\203\21\168\22\204\169\220\f\128&V\248-\239\30@=cN\237\214vmb\20X\3\151%%<\225\207\192*\214.\20@;\167\132\'|\v\20\177\207\193\206S\2268\178\230\0\220{kn\192\254[7\209\228\18\230\194\135\1480\27~J\t\243\225;%JO\137\161\3[Z\253:\15\237\132\2377\31P\194~\248\145\18\191\19\190S"\aN\238\201\245\251+"""""\242o\158\t\21+\238\187`\1564\0\0\0\0IEND\174B`\130'
},Back={Hash='e07cfef0',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\2SIDATx\218\237\152=h\20A\24\134\223oc \197\129\156\152(\209B0Z\n\n\138E\26\v\255\bZ\b\129\20\n\138\b"\138V\254DH-\n""j!\150Zh\145F\237"\136\141A\197\194\20\18\197\31\204\5\209\136\226)\209\196{l\182\136q\230nO\2008\139\251v;3\239\238\243\206\206\204~wR\161B\133\154\18\208\2\236\1.\0[\243\6\159\0\215\248]\187\242\20\224\28\127j(/\240\199p\235z\30\224w\0035\a\252\4\176"v\248\30`\202\1\255\r\232\142\29~\29Pu\192O\3;b\135\239\2\2229\224k\192\222\216\225;\129\151\158M{2v\248\249\192\19\15\252\165\216\225\219\128{\30\248A\160%\246\18\225\166\a\254.\208\22#\183\205\bp^\210!\199\152\231\146\246I\2502\135\28\31%\141\155\217\228\223\206~?qh\2\184\1\236\4\202\153\222\0\176PRERkd\171\163*\233\172\1643fV\245\rJ$-\136\16^\146J\146\6$\189\0006\215\v0*\233~\196\135c\135\164[\192\17\239&\6\218\211\16+\29c\30Kz8\199\144eIK$\173\145T\239\180;af\167|\27y90\238\217\\\135\3\29\229%\160\15\24\241p\252\4\182\215\187\193*\224\147\199\216\27\248\155t4-\26g\2353\176\184\158y\0030\2330~\a6\6\254\184n\243\148\242\23\27\25\251\210Yw\165_\0298\196A\a\199\15\160\171\145\241\128g\29V\128e\129C\f98\6\178\24O{B\140\2\139\2\6\232v0<\202b4\224\170\'\1960P\n\20\192\1287\142\31V\29Y\204\173\192mO\136;\192\188@!\1748\158\1916iX,\153MI\234\1494\236\232\222"\233x\160\149\244\218\209\214\153dq\154\217WI=\146\1589\1867\5\n\240\222\209\214\158du\155\217\135t\198+\179\186\158\6\nPs\213rI3w0\179W\233\140?\1444-iPR\255\191\172\244\154\222\128f6"i},\165j\162\156\171\bP\4(\2\20\1\130\254\205\146\165-N\1e`lF!7\6\148-O\203\5X*i\127zy\217\204\222\170P\161\255\\\191\0\161\191\5\133n\22Fc\0\0\0\0IEND\174B`\130'
},Balloon={Hash='1e5b20c0',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\2MIDATx\218\237\153\191K\149Q\24\199\159#*8\181\228 \209\210\26h\129!\226\144\151\134B\132&\209.M\213\0244\1684Iw\188\160C\147J\rE\147`\162\226$\20\225\197\127\192 \145\218\26\154jpJ\196\235\167\161\19\156\174\239\239\247\156\247\158\v\239\23\238t\30\222\247\251}\238\243}\206s\206+R\162Dg\1\24\1&:\153|\147\191X\1T\167\t\152\224\127\172v\148\b@\233\204\155X\242\141d\5\168\196\136Xm\17q\219\23\242\247\rR\2431"6\140\2165_\4<1H5\129\225\136\216a#\246\200\23\1\221\192\a\131\216\187\136\216!#\238kH\204u\224%\176\a4t\233\221r-b\212 v\24\17\247\218\136\219\fX\159\5\206\184\136s\160\238\172{\1\131\198\203\190\133\196\212ZHM\198\172\a\161\234J\192+\227%[\t\200\191\141Yo\0\147\192]`\199\169\0\221B\211dv\3\232I\177\174\128\a\250\167\\\b\24O\145\217T\228\139\222\v\30\1\221\222\146\az\128{\192P\130\216\23\190\145W\192\174\209\210\22Rx\162\253e\3\140\5\180\180Z\2O\248Q\243\192rH_\174\217\242\132K\242\189\192\207\136\205\165\150\215\19EN\155\169E$\240\132\219\217\aX\'\25\178x\194\237\236\3\\\2~\147\28y<\17\132|\199O\2241\233\145\197\19a\179O>\17\192\'\178!\143\'\130\206\208\213,\228\175\26\215!\214DDy"\226\f\157I\192s\242#\177\'BDd\159B\129\207\216A\189\29\211\229\r\236\162^\180\128E\236c\193\22?\21C\190KD\190\139\200\21\219y\17\145\155J\169\131\188\15\234\138Y\1758 \255/q\0036\30\20\'\224\161\163\202\220\21\145\143\174k\191\0158\182X\247\191\244(>V\200\14140c\129\244\137\30\a\166\128\222\162\187\207NF\210M`\31x\6\\n\215\29g?p\154\146\248\23=U^+\146k\216\246=-"INI?D\228\189\136\172+\165\246}\250H\177\29\145\233c\224\rpG\239\19\254\1\152o!}\170=1\3\244\137\239\208\247\252s\250\159x\n\244K\137\18%J\184\192\31\192m\189TT+]\242\0\0\0\0IEND\174B`\130'
},Blatant={Hash='db2ba408',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\4cIDATx\218\213\154]\136Te\24\199\255\239\180;\185m\172\174vS\130k\23\22\172\186HZ\17\238N!\145\23\6E\23\n\171t\21B\228E_hJ \238F!t\209\197\138\4i`QVD\23\2148ABZ\16Ae\144"\209\199\182\139A\31+\235R\238\151\219\252\186\216w\150\241\244\158\247\1563g\231\236\244\135\185:\207\215\255\156\231\253x\158g\140\28\0\140\164\237\1466I\26\151\244\1741\230\1402\4p\175\164\173\146Z$}"\233mc\fq\20\155\129\143\185\22e\160/\195\224_\176>\171q\18h\138\163\188\0237\202@!\1397\239\b\190\130=A\249\156\195\198\182\16\219F\210\0031\131h\a\214\0\235\237o\r\208\30\147\195f\235K\177c\179i\179\23\248\22\152\na\255>\208\26\162\223\1<\v|\4\140\16\142\17\224C\224i`E\136\173\27\129\15B\244\167l\140{\230\210\t0@\t?^\1r\14g=@\209\243\201}([2\27]\155\b\176?B\191\4\24\1\219#\4\2479\28\220\4\28g~P\6\222\2\1509\252<\31\161\219+\224\136\239\205;\140\222\5\252\202\252\227"\176\193\225o\192\163s\196\'\2409\208\0280v\31\2407\245\195_v\255\15\174\207/B\228\a\4\20\0289<\t\220\0300\212\5\140Q\127\\\6V\a|\175\2&\28\169\215S\17\232\15\144\232\v\24h\5.\144\29\206\0037\4bx1\16\252\129`\174\21l:\29\2\242\129g/\145=\250\0031\228ml\3so\222s`T+\222,iP\210\245\202\22\147\146n5\198\252\230\19\202\1970\180k\1\130\151\164E\146\158\136\0182\17o\223\216\183\223\161\133\193\176\164\149\190[h\212\23X\183\128\193K\210\nIk\211\164P\183\22\30=i\b\172n\0\2\157i\bt4\0\129\149i\b\1805\0\129\1824\4L\3\16\184.\r\129K\r@\224\2074\4F\26\128\1287\134\168*\127\208\243\236\156\164\31$\181J\186[\210\226\132\129\141I\250R\210\21I\183yv\188\1934\29\130n\199%\235;\224\206\128\\\v\176\15\184\26\227\146v\213\214\223-\142B\233\156C\254\1584\4\154\129\209*c?\3K=\242\143\199 \176\211\163\191\f\248\165J\246R\172^P\4\137\190*\131\143E\221\157\128\239=\193_\176\247+\159\141\157U\242\251\231\163\209\180\4\248\195\26\236\138!\255\134\135\192\177\24\250]V\246w r]E^\167\1411\151%="iZ\210\146\24\156\219k|V\193RI3\146\182\25c\198\230\179\229W\2^\141\144\185\5\24\247|\129+\182@\242\217x\r(\213\163gY\4\254\1v\132<_\f\156\137\177\136?\5\218Bl<j}\20\235E\160\130\247\128-\182[\176\14x\n\24NP\239\14\1OZ\221U\192\131\182uYA\221\t\212\27\177\t\228\244?G\18\2\0195\216?*\233\245\26\244b\251Jr\202\253\1480\136\139\146\158\145T\214\236\168*Iq\244c\173\147\145C\192Q\1607xb\2\27\128\153\4\29\231\205U\186\155\18\180\224g\128\245\142\19~\135\141m\224?\147\162\144\153\2121\a\201\135\129\175m\239\212\135\211\192\253\129\223\233\b\157I\224+\224!\135\2237Cgv\158\153\212\144\231k\229\236\24\169\221\182\197\211\180\212+vr\30\127Ca3\187&\205\1422]\23\172\229@\222\0243\237\184^\148%\141Z\227\229\20\155H\217\0243\26\145\218yI\203C\202\221\1739\219\194\v\171E76\192N\217\237\169\139\23\229$\157\242(\31\14\27\198e\1\160C\210a\143\200\169\202\n?\233\201\211q\224\4\2402\208\233p2\156b\r\f;\236uZ_\'".\134\197\185\157\18h\178\163\203\179\1581\235\236L\170\254\4|3\187)\224\27`w\165Rk\178\139rF\210AI\a\129\179\182\169\27\247\132\220")_c\150L\'<\133\207\27c\238\136\202\187\231<\135SO\6y_\240\28z\187\227\22\242%G\240\a2\\\188\253\14\18EW\129o\194\138sI\189\246\0143!\233\29c\204g\25\239@\5]\251w\155\227\174A\199\191\155\235rQH\253(\v\0\0\0\0IEND\174B`\130'
},Check={Hash='bb27176e',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\0\245IDATx\218\237\216=\14\1A\0\134at\18\133D\173\209)\168\20Z\183\176\168\144\168\156D\226/Q\224`. \145H\20:\241\247*l\1776C\150Xf\146\239\189\192<\31f\179\145H(\165\148RJ)k\0022@\5H\187\136/\1k\238\173\128\172k\248-\143\181]\198\3\212\\\198\15\\\192\23\129\141\1?t\25?\18^x\219\240@\1\232\1\229\24\1586c \0257~\239\31v\2Z_\196Ob\197\251\135\247C\135\158\129\198\23\240\211\216\241>\160\n\\\f#<\235\241\1H\231\201\136\230\a\23v\254S|\132\17\r\235\241\17Fx\17\240\139\191\226#\140\168[\143\15\140\232\1\215\16\242\b\236\f\248\153U\248\192\136\174\225\155\176\251\147\127s\196\18H\185\240~c\26\225\6>4\226\224\223\139\145\213?\155\23#r@^\127\f)\165\148RJ\253\174\27\251\237>}\220\239\252\150\0\0\0\0IEND\174B`\130'
},Combat={Hash='6b493558',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\3\156IDATx\218\213\154[\136VU\20\199\255{.6J)\222&\248\210\145H}\200\4\a5#\152@\t\147\230Ap$SB\4i\208y\16\5E\232I\177b\158\4\163`"*_\20\137\238P\136\136\160yA+\0051\245\193\145,\240\18\154x\157\153\212\249\249\178\'>\14\2239{\157\243]\230\248\135\195\247p\214Y\251\183\206\222g\239\181\246\254\156R\n\24-\169E\210dI\5I\205\146\198\248\219\163$9I\183\138\174\171\146z%\245:\231\250Ua\185\0\236HIm\146^\150\212\234\175\2313\182\133\164\191%\157\150t\212_\191:\231\238W4"`:\176\17\216\a\244Q==\4VU\nz\28\208\t\28\6\6\169\190\250\129\165\0258G\0\139\129\177\209\27\15\168\157n\1\243S\130\207\6v\0\255\0\23\128\255\135~C\228\183\218\186!\169\2219w\220\0\253\162\164\183$\189#\233\133\162[=\2069\162\198\181\208\159\192\244\0t\179\255\254N%\248y\169\212\131\22]\2\142\0\2472\192\255\1L\n\192\23\128\139\1?\167\227\30\14\233\3\160\206\219\182\0\231S\192\159\0&\4\224\199\4\222\250\144\222\203\18\192\165!\248"\251\14#\252~\224\153\0\252(\224\23\163\191\169Y\0028R\194~\174\161\177]@c\0\190\17\248\217\b\127<\201Q\146\238\1-\17\251m\129g>\142\246Z\1376\235\128=)\134\226\134\172\1\224\199|\a0\ax?\176nt\27\166H\a|\154\2\254\17\240\\9\1X4\b\1727.L\31\166\244\253Y\200a\185\26\0\2226\194\175K\233\251\163\208p,7\128\187\192"#\252\202\20\185\214 \176\197\154kd\213\191\192\171\1986\22\167\200\185\30\2\239\166I\150\178\23220\211\232\127~\138\212<}\166\154\1\254\\tjM\240=\23\184m\244{\19h\203R\15\164\209o\192\196\20\197\2095\163\223+\192\172\172\5\141U\a|Ml\2419\217\167!\22\245\198\166\t\21\f\224{\160\201\232o\162\31f\214\30m.\183\164\f\233K\160\193\232k4\240{\165{\180\156\0\186\139K\184\208.\6p\208\b\255\157\181G-\r\191\14\236\141\204\211\230\212\192\251\168\a\1901\194\127\18\\]3\6\24240\15X\2\188\150\2269\a|a\132\239V\222\4l7\174\174kj\t5\3\248\1x6`\183\197\152\236-\171%\252r\159\164\r\213\2\133\24\187.\3\252\29`a-\225\23\149\1288\27\237\t`\133/4\146t\29xe8\198\244\214\152\170\172Pd\243y\0\254"0m8?\204\205IA\248\154vg\f\252\153\196\18\176\134Al\138\tbRB\16\199\128\241y\154"\187JTQ\253@k\137 ~\244g\n\185\155\231;K|\176\3EA\212\3\171\129z\229U1\139U_h\2073/\240\v\129\251\t{F\133\'\21>\223A\196\192\247\251\221\234\129\18[\232M\181fl\136\158\149IZ \169IR\157\164\30I\197\179\202\128\164\14\231\220O\192aI\223z[I\250\186\26\199\168i\222\2462\191\207\19\167\190hN\3\188\225{h\183\181\232\169\22|+\240_`\175\166=\225\0\174q\184\199\250W\129<\190=\239\211d\168\bo\202+\251P]\250W\130\205\181a\2538\141=\208\150\144\219o\210\147 `md\206\31\4zr\157\223(\242o\21`\138\1647%=%\233\144s\238d\222_\252c\1774\152\212f\180\147\14\0\0\0\0IEND\174B`\130'
},Control={Hash='265dd567',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\2\18IDATx\218\237\1521kSQ\20\199\12775R\209\185\136\25JL\139\31\162.\29\156\212\172\234RtS?\1298\21\165\131[\29D?\128PQth@-\184(q\233\a\16#\14m\'\209M\180\14)\254]\142\16\218\188\215s_\146\151\20\238\15\30\\^\2229\247\127\238=\231\188\251\2\137D"\145H$\198G\240>(i\30\184\r\\\0f\129SC\214\242\v\216\2\222\1\143B\b_\135\226U\210\148\164\251\146\246T\30{\146\238I\154\26T|E\210S\141\143\23\3\5!\233\174\198\207\157B5 i\6\216\6\166\199\\\167\127\128\217\16\194\143~?Vr\f\151&@<\192\t\211Bl\0\139\14\231\29\160nW\199)\168\5\212\236j9m\22\139\228\255\142#?Wz\158_q\230\244\153\30\155\154\211f\'j\a$M\219\n\29F7c<lj\166\233\0\1992\f\206\230\164W\aX\a\254\2\237\158\251m\224\129\2175\129s\25\246O$\221\178\241cg\0\21\211\244\201\155>\205\156\237\172;\236\235#h\167\205\152"n\148uD\137\160\17\147Bs9\142\222Hz\14\252\6>\134\16\218\182\234\231\129\5\224$p%BX\v\184\249?\189\128\203\0054\29H\129\r\231\182.\247\216,\23L\roW\218\24E\nU3\198\148\149B\253V\191*\169\235\\\189\207V\176u\27\23a\221V\190f\227,\186\146\170\135\22\155\157\251\191L\232\247\203\252\254\239\132\202@\197R>s\158\0268\242\0014&8\128F\218\129\163\16\192\233H\167\175\128\227!\18;\5<\139\156k\198\243\30\248\30\209\195_\246\235\205\17o\252\170\249\240\242\205\227\244m\25\226\v\6\241\218\227\240RY\226\v\4q\209\235\240a\142\147\181a\138\223\23\196Z\206\188\171\177\14\175I\250 \233\167\164]I\155\146\174K\n\163j1\146\130\164\0276\215\174\205\253^\210\213\244/p"\145H$\18\147\200?\200\194]/\164\243a\244\0\0\0\0IEND\174B`\130'
},Info={Hash='beadc1ad',Data=
"\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\2\\IDATx\218\237\153?OTA\20\197\127\23\4\n\172\128\130\184\139\149\1k\1830\26\27\252\20$|\5\n\191\130\137\5\214\26\129,\1771\241\3@\2&\154m,4&PK\180\176XV\18\2544b\194\146\144c3\219l\30\187\179;\179\239\141\186'y\213{\239\190s\222\204\157\185\247\f\f1\196\255\r\139\17D\210(\240\0X\4\238\1\v\192,p\211=r\14\28\1\a\192>P\3>\155\217U\161\234%\205Iz.\169\161\222q\232\222-\23A|F\210\154\164\166\194\209\148\244J\210t^\228\151%\157*>N$-\15\146\248\184\164M\r\30UIc\177\201OJz\167\252\176+i2\22\2491I;\202\31\31$M\196\16\176\169\226\176\17#a\139\198R_\27\153[\214\190\0023\5o\182g\192\130\153\157d\221\28\233\240\226\179@\242\219@\201]\219\1q\166\128\167=\141\128\1649\224;0\30\240\225\146\1535\\\188\18P\15\136\213\4\238\152Y\221w\4V\2\201\199\198\132\227\228\149\1847\250\172m\218\177%\169\228\174\173\b\241\234\174h\236<\133$=\2>&Z=?4\179O\221\166\208b\194\229\255c\159\28\168$,\160\226#`>a\1\243>\2f#},\214>\208\145[V\0187#-\1611\247\129\22.\205l\162\155\128K \184\03073k\139\171A\b\200\154B\231\t\231\192/\159\28\248\153\176\128#\31\1\223\18\22p\224#`/a\1\251>\2j\t\v\168\249,\163\163\192\15 \200p\26\192*\212\0n\183\187y#\25\31\190\2\222&\248\247\223dY\145\21554e\215\208\132\184\2\19754\238\193\215\129\127l\189\213\15\0k\129\177\170Y\228\1875\245Sn\217*\186\169?\5\238\246\220\212\155\217\25\240$\129\185\191r\29y\223\22\179Z\160'\180\2547[\139\239%\1971\22\156\185\187\155#\249\157h\230n\219Hl\2281m\162\219\235mB\150$\29\15\128\248q7\0314\166\136iI/%]D ~!\233\133[\182\243\133\164\178\164Ug:\245cT\173\134\30\242\197<f\189\239<\165\138s\15n\1\173D\252\r\28\186^c\207U\149_\n?f\29b\136\127\0\127\0\156\169D9\203\0177\230\0\0\0\0IEND\174B`\130"
},Inverse={Hash='bee7255f',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\1*IDATx\218\237\1521N\0031\16E\191Q\218@R\144\2q\n\162\136S\228\nI\v\'\136\210D[r\185\20p\1(p\131\20--d\165G\179E\216l*l9#\230\149[\140\255\183\198\158\239\149\28\199q\28\1670\192%0\178*~\t|\3{`e\209\192\27\191\169\172\25\216rLe\201\192\20\168\173\155\184\3v=&\158\220\196\1915\1\204\129H:\214}\235\132\140\6\162\164\155\132%\27I\147\16B}\248\241\194\250\20\207i\224ARLXo\211\221\253\191\180\199\4\24gh\187Y\246\153\0\172\129\166\205/Kk\226\171N\241w\203\226\1\158MD\137\19\226k`\154\160\246K)\241\179T\243\194\172\248\206\131\16695m\207V\252\193Zc\224:\245U\153\138\b\204sM\203\208\183\27\146>$\r\18\174\19C\b\183\214\162D\153,\212\230\141M\202\221\151\244X"\207\175z\250\249\19\184\183\244Br\19\231b"[\148(mbk\237/Z\215\196\171\185{\183=\19{\224\vX\152\28\30\192\0210\148\2278\142\227\20\230\ae\222[\154:\178\147\223\0\0\0\0IEND\174B`\130'
},Jail={Hash='a33745f2',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\1\177IDATx\218\237\153\189N\1950\20\133\207\165K\5\20\169L\188\0\176\148\129\194\192\206\ft\170`\128\247\1Z\222\3\24\000133\178\242#$\232\196\4R[!\182\143\0013\16\133\150\180!N$\31)K\172s}?\2197v\18)\200\175,\205`@YRS\210\134\164eIs\174\233E\210\141\164KI\'f\246\145\187\145\0v\128\14\195\245\fl\231)\241\18\208&\185\218@)\15\0G\140\174V\30\150MT\239\192!P\a&\129)`\5h\185\182\168\154\190\146/\199\172\249\14P\27\224Y\138\241<\185\226\207\28`/f\228k\127\240-\197\204\196\174\15\128\211H\18\135\t\188\209\162?\246\1\240\24I\162\158\192\187\26\241>\248\0\232G\146\152L\224\157\138x\251\153\239\196\0?\2\153Y\150\254oM\20\253,\20\0\n\1\0,\2\23@\239\187\234\226\214t\18\r\240\247\128s`1\149"v\129\174%U3\30\2207Ikfv?\238\f\28xH^\174\207\2534f\160\'i\218\211\18\239\153\217\204\184\0x}e\28\178?\132\199h\0\b\0\1 Vw\146\182$U\220\213p\247\188\188\251&\213-P\141\137S\5\238\198=rd\1\1769 V#m\128\255\216\200*f\214\255%VER\183\200\27\153\21\161\136\215Gl\203}\17\207\2\247E(b\220\211\166\1T\220\213\24%y_E\28N\163\225(\17\0\2@\186\0}\143\249u\211\0\184\242\b0\180\239<\127\216z\213\215\135\173\241\255\29\0\v\192\25\208\229\255\213u}\205+((h\168>\1\172r\127\243\169\237\26\153\0\0\0\0IEND\174B`\130'
},Jumpscare={Hash='a45abe9b',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\2~IDATx\218\237\152\189kSa\20\198\127\'(\165jl"\216\130\139V+\1AP\132V\170\155\nN\154\197A\232\174\155\142\142\142\234$N"NuN\'\255\4\133\212\193*Ji\181*\182 8\212\164\210"\22\218\199\229\141\132\144\230\190\185\31\185\17\239\3\239\146{\207\201s\238\249|\15d\200\240\127\195\162*\144d\192i\224<p\0068\6\28\6\246\2\5\247Z\29\216\0\190\2K\192k\224\0050gfJ\197rIc\146\30HZQx\172H\186/i\172\151\196G%=\147\180\165\248\176%iZ\210\145$\137\155\164\219\1466\148\28\214%\221ra\25+\249}\146*\234\29\158K\218\31\23\249\130\164Y\245\30\179\146\nQ\201\15\166D\190\129\170\164\193N\28s\0016<\5\198S,\243\19\192\147\176_\255\186\250\a\215\186jd\146\246\0\159\129\145>i\184\223\12813\251\229\27B7\251\136<\192!\224F7\30X\0J}6\246|\4J\173\163G\174\r\249\241>$\15p\220\205Z\129!t\177\143\135\207\v>\6Lx*[\4\174\2yw\202\238\183\164\228\0\206\250\148\207y\143\178\182 \169\216F\182(i1\1\185\6\222\251\24P\243Pt\165\131|9\1\185\6V\3\171\144\164M`w\128\157y3[\223\129H\30\248\25\179\\\3\155f6\16\148\3[)\221\242|\228\182}\146\184\30\166\26$\252\172\129\154O\14\188\138\144\196\a$}H@\238\239t\234\227\1299\143/Q\2\170.\241\242\238\148\129\170k8\205\222\172\135\144\219\to}<0\21\227\20y\215\157\1840\229S\133\134\128\239\192@\196d^\3F]\226}\1\138\17\245\253\6F\204l\173c\b\185\23fbh\251\15\205\172\230\244=\138A_\165\149|\1670:\17qmRoNVIC\146~D\208\183-\233\164\247\149\210\204\230C_\229\154\190~\139W\163x\225\177\153\189\235\170y\184\206\248\0068\26\226\15\239\181\233\'\5\224N\b]\159\128S;up\vZ\31\2/\129\225\148\198\231U\224\156\153-\134\218J\152\217\18p\25XN\129\2522p\169\19\249n6\20\195\146fz\184\133\168H:\152\196~t\178\a\228\'\19\157\28%%\186\2077\179\1748\229\248\199\145\25\1446v%\21\187\173\185\18\244<\v\161\204\128\f\0252\164\130?\150\171\r\160L\143\251v\0\0\0\0IEND\174B`\130'
},Keyboard={Hash='06243725',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\1\1IDATx\218\237\152=j\195@\20\132gR\27\131\219\236\1t\5_\209\185@|\f\'\170]\231\fI\218\1442\1\175\251I\179\133\130%\203\178\140\252\4\243\193\130xl1\239gG\240\0c\1401\198\4CR%\233ER\214\253\201\146v\146\1706\173l\19\15\224\r\192*X]\127\1\172I~4\131\15-\23\159\2\138G\209\180\185\164\3\25\192"\232tg\146\203\190\4\20\249}\146d\223\b\205\138!\t\212\0R9\245\132\241\193\22\218\197c\227N\1540\254\1431\29\152\205O\172\139\215R\153T\190\167\138\159\237\128]\200.d\23\178\v\217\133\236Bc\169\1$\14d\180\219\220p\132\18\201\239+\223[\2\240\229\17\26\201\182T\242\154\234?G\24!\187\208\173G\232\24X\239\225\146\4\246\129\19\216\207y\177\245S\22[\159g;@\242\29\192\26\192\14@\142\176\v*ZN\196\27c\1401\230\222\252\1\167\161\230\178\1967\127\21\0\0\0\0IEND\174B`\130'
},Laser={Hash='d0807c8f',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\3FIDATx\218\237Y\191O\20A\20\254\30\0304ZA\f\208\128\158\180(w6F\b`!6Xi\vt\26\233\248W\4\17\196\130\31\1816X\bQ\238P\209\136\2A= \129\195B\19\181\177\193\18\248l\198p\1423\187{\179\187\30G\248\146)vg\223\175\2177o\222{\3\28\227\136\130d\27\201wj\180\149\163\1y\30`+.9\18\163\1\252K\144H,\178*\202\221U\19\17\174\2489\0\215\0\164\212\208\231\223\3XQ\227\169\136l\31\6?\175$\217Gr\158\228>\131c\159d\150d/\201D\169\148\239 \249\129\225\177A\178\235\127*^E\242!\163\199\3\146U\177F!\146\213\0\30\3\2320L\239\1x\r`\26\192\2\128\239\0~\168\185Z\0\245\0Z\1t\3\184\f\224\132\129G\22\192\r\17\249\25\199\202W\147\\3\172\220\30\201q\146\rE\240j$9\161hu\172\169\133\138\220m\178\6a\155$[B\240M\145\2202\240\157sq\'/A&\159\207\144\172\137\128w\141\226\165c4*\229\175X\148\175\138\248\15g\f\161\182#,\227\132!Tn\147<\29\211\30\219\212d}"Y\25\134i\159a\195\182\248\208\\ y\143\228:\201_j\172\147\28"y>\192\158\2087vo\24\3\2305f\227>n0l\137,\133\v0\228\181\170$\'uwu\206m\180\244`\215\22*\149\242\179E\28Z\1796#T\136\221\213\246B\210\197\128~M\232\v\143o\135\29N\222A\15~/\181o\239\184\164\211zF9m\243y\0\183\29~r?\201f\203\220\19\31]\156\fX\176|w\203\177\174\168P\180&\232\178\210Ak\216\188\199/OZ\2326B$pk\30\251\207\134\188\177\198V\197\183\23NZ\132\237\1320`\199\194\243\148\15\221\226\145))\v\r\24\0\144\247\248\182\214\242\254k\b\249_\138\148\5\165\227\192?\6\136\200+\17i\18\5\0K\26a\157\133\225\243\16\6<\179\188\175\215\158\151\228\0M"\178\16\196\133V\180g[sj\f\192\190\131\242{\138\214\4]\214\178K\24\213\r\184n,\233DV\1\220w0`XD>Z\230\186\131\26\224\21V\147\134T\162\209\163;QL*1\227\145J\1561\164\18g]\243!\189\n\155\240i\177\f\6H\230\238\250$sSzu\22&\27\2375(\144\242\161iV\134\228\n\210\233\156R\188\217\1356mX\128\158\176\5\205j\217\0224\138qg\tK\202\246\168\4\140\149\160\168\31A\204+D\213\18I\133\224\155\246h\171T\198\225\163\182\198\214\164-\196z\132\202)K\196\202\21\211\216ri->\2\208i9Y\223\168b\228Ok\241[AjP\167N\216n\0\151,\173\197\f\128\155\177\180\0225w\26-\178\157\30\164\221>\18\185\219\248\24\210\30a{\253j\169\238\b\18\234\176\2038\\p\204\145\236\t{\193!\17\26\147\4\208\165\234\2154\128\139zJ\172\146\178e\0003"\2429\n\185\199\183\148\135\169\164\140\26\219Z\25X^Pm\154E\146oI\182\226\24G\20\191\1B\233\246\199\20\194\b_\0\0\0\0IEND\174B`\130'
},Morph={Hash='46f4d164',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\2\\IDATx\218\237\152?k\20A\24\198\127\175\28B0\b\198\202\156\138\24I\210(bmc,\132\20\254C\136`\147/`e\172\147\239`e\175\136"$g\170C\252\2\169\3*\138\4\20%MP.G\16\188{l\230`\163\153\185\219\205\206\238\29\236\3\a\1877\179\243\2063\239\159yf\160B\133\n\209 iFRCRK\135GK\210\154\164\153"\'\191\163\252\177#i\186\b\2\r\197\195j\207\142E$\208\2\198#\r\2232\179\227\177\t(\166\135\205\204\0\142\140z\161\168\bd\192:Pw\191\245\f\237\133\237\1>L&\250\2123\180+\153_1=\240s\212w\225%I\221\3\22\239\141[\217\186{N\219\190\207\3\22\153\196I\224\2p\21x\4\156\202\187\140\22\233\145\tI\27ym\197\133x\224\0\18\147\192&p"\202F\22[=\154\217w\224\137{\253\5,\3W\156\228\24w\207\203\174-\132\221\210\212\163\164\203\146\190J:\29\240\212\25I\223\2c~.M=J:&ia\128p\187\31\24\239m\175_-\241\205\\\196\240\191\158\b\163\182\164yI[\192\31O\255\0260\31\24\175\249_\18\23\165\30s\176\213\5f\205\236\211\168\138\185\23\189\201\143\162\a\218\192%3\251\146F\v\r\139z\20\176\152\156|)\234\177\143-\31\186\146\150|\217^\6\246\128\177\20a\179hf\175\179\234\247\\\213\163\179\245l\128U\239Hz.\233|0\183JJ\2261\224!p\r\184\bL\184\242\248\3\216ru\190\145\1726CE\160:\212{\b\180\3\253V\128\154y\224\138\193J*\245\24\129\192v\168j\152Y\'\16\30\29WY|\216.\226\176\241.P\17~K\186\21\248\246\182\235\211W=\230\141\218?\n\207\167H\143\2k\146\154\192*\240\193\253?\v\220\1n\244\177\211\140V\28\146\a\26\224}\132c\230>\245\24-\a\204\236#\2402\182z\140\157\aS\146\2189\158\196v\251\237\1641H\220\245\\He\17`\v\148\1I\143\15I\194\171\30\139$q/c8\237Iz0,\247\155g%=u\202p\144U\127%i\170\2009\218\128D\166\129\155\174\222\159K\220q\166V\143\21*T\200\23\127\1\199\168\147f4t\215\n\0\0\0\0IEND\174B`\130'
},Priority={Hash='a7db63d6',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\1kIDATx\218\237\1521N\195@\16E\223 \v\t!\26J\160\231,\20\161\164\226\0\225\4\156\1AC\154p\0\14\128\20\137\211 */\'\b\133\147bh\28\176\140\179\2178Y\216\141\230U\150W\150vv\254x\254\14\24\134\209\137\170>\168\234L\127\152\169\234}N\1L\2457Uj\251\220\243\172\141\129y\235\221~j\1H`6\244\251\3\17\201%\3Y`\0014d6PU\167\219\199\169\234 z\r\168\170\3N"\29\180\19\1453\147\208\n\134\128\139q\250\192\205\166\250\174rldMF\192\'\240h&\203\232\239F\131\254\203\169\187\209\5e\174nt\193iVn4eWZx6{\0\\\3\199\161^\bx\138`\'>\128\161\136L\214\173\129\23O\rT]^H\227Q\246\169\129\v\207\218k*5Px\214\154\215\199\187\198\243\27\240\188\196\v\141#\20\184\215\vI\142\215\200\181\189PK\143I\141W|\25\168<S\136\169\136\28\165\158\129\209\146F6\175\181n\24\230Fw\201\141&=\23\nin\2555\23*\0026}\14\\\182\178\229r*\230\247\182\254\187RZK\168\140\225D}\18*z\196\212)\187\218\175O\254\250\128%PBW\192!p\187J\147v\165\220\214o\180\171\145\229\214\137w\182\145m>-6\fck|\1\224\172\254\173\252\249\210\228\0\0\0\0IEND\174B`\130'
},Ragdoll={Hash='d3b25cc2',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\1\129IDATx\218\237\151\207.\3Q\20\198\127GJ$\132\132\165 \18m\23\4\15\192\194\202B<\131W\243\6\213\r\177`\165{\132\5\17\137T\2374\209\146\136?\253l\174\164)\197\140)\1578_\242\229N\230&s\191\223\157{Nf\192\229r%.IyIEI\245\224MI\2494\133\175\234\189\170\146ri\0(\170\189\ni\0\168\127\2PKz\189\158\223\230K\3\192n\204\185\174/\226\27I\217\180t\162\156\164\130\164Zp\161S\225\237\139 \243\192\np\v\28\2\199fv\215a\248A`\22\152\a\134\129\0293;\140\f i\17\216\3z\155n7\128\v\224\28\184\f.\0037@\181\201\r\224\209\204\238\195\179\6\128\190Ps#M\30\5&\130\'\129,0\213R\155O\192\178\153\149>\202\153\249d3V[\194\191\21\253t\240wv3\137\151\210\27\178\148\162v\161-\224\165\vJ\234\25\216\142[\3K\192:\176\0\204\0\253\191\20\250\0018\1\14\128\r3\219\143\5\208\2\147\1r\192\28\144\a\198\129\1770\142\3C\17C\214B\253\148\129J\24O\129#\224\204\204\158\127\220\133"v\143H\a\222\204\18Y\187\135\148\203\1\28\192\1\28\192\1\28\192\1\28\224?\3d:\245\224\214\175M%\244{\230G\200\1\28\192\1\28\192\1\28\160\141\174\155\174+1\230\255V\146\214$]\5\175E\157w\185\\\241\244\n"\248\15=\1472\205\128\0\0\0\0IEND\174B`\130'
},Remove={Hash='7c330ea6',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\0\253IDATx\218\237\152A\n\1310\16E\131\155\214\30 \30\170\27\235\170G\171\199\212U\t\133\223ES\144\210\128\198\0253\129\255\182\194\228\255I\198L\1989B\b!\132T\4\128\14@\171\16\183\5\208i\139\31\241a\2\208\v\198\237\1\2041\246\168\153\249%\1\192 \16w\136\177\150x\r\3\151\152y1\19\t\241\147\198\17]nu\1440\145\16\31$\143fj\225+\128\231\207\194/\0w\1\241\183\163\254D\217&\138\139\223c\194\140\248\28\19\230\196o1aV\252\26\19\230\197\175\200r\208\184\0\143\220\t\219\153\223`BE|\163\224\225\148\136\219\196o\166\179\255\175\14\178ol\22\177Do#\209;\21\19/\217\0\22\19o\214D\206\rk\198\196\158\246\160\184\t\137\222\166\152\137\170\159\148\241Q?W\251\168\175~\172r\192`\235;\178yh\215\129\apV\26-zG\b!\132\144\138x\3G\28\195\215\173sN\192\0\0\0\0IEND\174B`\130'
},Render={Hash='c6b95601',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\2\206IDATx\218\237\153\219\139MQ\28\199?k\24\151\209\136\24\247\a\147{i<L\t)J\195<\200%\138\146\146\136\146\ay\242\15x\149\228\193\195<M)IR(%j\26%\154\210\196\200\157Hr\201}\220F\31\15\246\1956\206\153s\153}\206\236S\231[\171\221n\255\214\218\159\223^{\173\253\251\2536T\149\191\212Zu\131zZ}\162v\170u\149\0>L\221\161>\242\127\157Wk\211\f\191H\189\225\192jK#x\141zH\253i~:\144&\248\t\234%\vS\159\186&\r\240s\213\a\22\167\247\234\236$afE\239\240\132<\237\23\171o\29\156\186\2131I\192oS{c\3?V\143\168K\178\216/U?\152\140N\14\22~\171\250{\128\27t\170kc\246M\234G\147\213\129b\225\155\212\175y\222\228\178\218\162>7y\253RW\228\226\r\253\224\199\0017\129\217)\217\208^\3\205!\132\23\217\fj\250\157\31M\17<\192$\224\162:>\231\f\168\203\129\142\254\179R\164>\3\239\1626\26\24\21{`\r@\161\187\2045`u\b\1617\163\3\234p\160\vh*`\208\143\192\237\168u\3w\128\251\192\187\16\194\207\28\235\172\14\152\2L\6\166\1\243\129\133\209q~\204\225\184.\0\27C\b\1912\r\1847\143E\245LmWw\171\243J\28\2485\171\135\213\135\253\24\218\213\144\169C\166(\241\139zV\221\165\206\28\194xj\147\218\21\227:\254\143\19\234\150\216\197\167\145A\171:*e\193a\171\218\17q\158Pk\0\130z\fx\t\\\b!tW@n\177\28\216\v\252\0\246\a*Tj=\208X\205s\171JQ\6vR]W\137\240\141\234\253h{\251\174\182V\18\252\196\f\233c\175\186\172R\0288\147%\236x\165\206H;\252\154\28\177\211uud\154\29\184\146G\0x<\173\240Ss\228\204qmI\163\3\155\v\200m?\169\vJ\197RSd\191B\242\129z\224\220@i\225P80\182@\2519\192)uI\210\142\f/\178\223\251"\250\180D\r\2455p\23\184\a\244D9\239\173\16B_\185\214\192\246\18\212\129>\169m\234\244r\188B]%x.\245\192N`e\201\29\b!\244DU\136R\232z9f\0\160\20\127Un\133\16\30\149k\29\212\170=\t\175\131}\229\254\160-S\191%\4\255X\0291\20_\229\245Q%y0\234SW\rud\250j\16\14\28LC|49J+\251\n\0\255\174\238I[\1607K=\150\165\\\25\255yq.\137\26k(\1773\141\192"\254V\162\27\128\175\192\v\224j\b\225M\181\28RU\n\244\a\205n\216\243\243\22\218\a\0\0\0\0IEND\174B`\130'
},Rocket={Hash='a0ada935',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\3XIDATx\218\237\153KHUA\24\199\191\241A\161\189(\v\147\204\2\193\158\6\210\162\130\130(L2(\180\173\2372\220\216kUD\4\5\6%B\20\130\130\180(\137Z\212"\b\f"]TDQ\22b\16\0187\131\158RY\154^\173_\155\17\14\199\243\188w\142^\234\254\225r\185\135\255|\243\255f\230|\243\159\185"i\164\241\127C\165\1700`\177\136\20\232\159\227"\210\171\148\138\167\170\216\25@\5\208\b<\5~2\25\253\192\154T\19^\0044\0\159\b\134;\169"<\0158\v\140\16\14\189\211-<\3\168\a~\144\24^\218cfM\161\248\229"rED6%\17f\210K\1561E\226w\138\200\147$\197\139\136\18856\3\192B\17\217."3E\228\149\136<SJ\1418\240\14\139H\163\161\146\221gjDk\129a\219\250\28\1\214\217xg|\214\244\128C\28/\212\152\16\127\212%\248q\27\239\164\135\1446\160P\2432\129]@\204G\252\31\189\185E"\254\22\160,\188\253\30B\154]b/\2133\226\134\231Q\137\127\15\204\183\240v\0\227.\220\184\149\235\208\199)\143\4\14E!\30\160\218\194\203\a>zp{\252\170\149K\187a\175\196\147\17\127\195\182Iu\248\172\227>\159\190\170\\\218]\136B\2520\176\196\194\173\vXIJ<\250ku\224\15\2\139\18\17_\225#\164\193\230m\6\2&\208\5\2288\244W\14\140\249U\1830\t\156\247\16\241\5\152g\225\182\132\2444=\192>`-\176Y\219\232\184\3\239\5\144\157h\2\229\30\213\228\132\133W\226\193K\6q`}\178\165s\3p\211&p\24\200\179p.\19\r\234\141:I\224\28\240\21h\177=\143G \254jT\1742\2156\250G"\16\127\23\152\17TS(7\170\148\26\18\145!\203\163\2\195c\244PD\170\148R\163SuH)\6>\27\26\249\219@\238t\28\19K\r$\209\6d\201t\1X\169M]X\252\2\14\166\202MC\216\153\232\6V;,\201\218(\196\229\0005@3p\rh\2*\173g\128\16I|\215\213+\219\214v\183.\211]\166\197o\5\222\185\136y\f\20\5LbT[\142|\135\193i\210\'\174\137\4\149)\241\219t\199^\1369\136*\181\188\19#\192%{\162\154\183\5x\237\16s\150\t\241\133\192\183\128\235\185\221\161\253\\\160\204\197y\22h\235\252\219\197(*\19\t\\\15\241B\142\3\v\2\196\156\3\156v\185\188\157d\211\147\17\191\204et\188P\238s\137;\225\165\188p?\140\141\240\178\18\213\t\220\218\205v\17\127@D.\6\176-\157"R\25\214F\184\137\220\152\192\196\245\187<\127\16B\252\144\169\234\211\19r\249|\0002=\226\221\243Y6\185&\235~\134\222\226\195\160\206\'\230\30\151v\157\198\r\156.\159a\208\26 f&\240&r\241\150\1577\bF\129cAk6\176\215r4\237\136\204:\251\220kN\236\172\237\192\170\4\255\19+3f\21\\\170C\177\254\30\215\149\165\207\242\233\22\145GJ\169\193D:SJ\197D$fr\192\149\195(\173\208\226cJ\1691I#\141\127\27\127\1~\230\16Rg\127\18\166\0\0\0\0IEND\174B`\130'
},Search={Hash='cc6705ab',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\1\248IDATx\218\237\152=K\28A\24\199\255\147\2388\194\165R\243\210\t\129|\0=\181\138\160\129p\141\'\6R\2499R\2501\146\15p\216\b\n\154"E\1444\137\220\153*\16\17+\139+\4\155\128\193\16\162\1914#\28\227\168\231\238\204\238\30\204\31\182xfw\158y~\243\250\204JIIIIe\202d\169\4\24I\211\146Z\146\230%=\1454n_\159H\234K\218\149\244QR\207\24Ce\136\129\5`\159\225\245\3xS\133\192k\192:\217\213\1je\5?\1\244\200\175.0QF\207\251\130\191\4\182\129U`\18\168\219g\210\150m\219o|\16\181"\1|\211\230\'\208\28\162n\211~{m:\21\21\252+O\227\159\129\198=|4l\29W\v\177\1317\192wO\20772\248jxFb\223n\199\209\0f<s~6\135\191)\207\154\152\202\27\231\131[\222\189v\236\29c\204\183\204\'\1661=I;Nq+&\192\188co\4\24X\215\199\203\152\0O\29\251k\0\0\215\199\179\152k\224\204\153\175\245\0>\235\142\207\179\152#P\153\2281+\192\137c?\14\208\158\155F\156\198\4\232;\246\\\0\0\215\199aL\128]\199^\t\0\176rG\27A\23q\211s\1445s\250\27<\200.\128\231\177S\137=\a\226\0x\148\193\215C{\177\25\212f\17\201\220b\164d\238\28xQTF\218\137\144N\191/\250B\211\rx\161\1\248\v\180\139\190Rv\t\171\194!j7L\167at\14|\176A\151\a\145\225\183\202\5\176u\181`\129vU \f0\r\172\1_\128#\155\252\253\6\142\129O\192;\223>_\25\136\156\29\208\2\2548\16\255\128\183\t"A$\136\209\133X\190awZ\26u\136_\165\253\213\14\b1\166Q\18\176d{\190\216\2045B\2385\166\164\164\164\164J\235?\4Ba~H\137\127`\0\0\0\0IEND\174B`\130'
},Settings={Hash='a6ec23a2',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\3CIDATx\218\237\154\187O\21A\20\198\191\185A@im\136\137\209\234\162\136\152\152P\168\21Z\248H\140\137\162\1606J\23241\177\0\255\3+\v%\26[_\248\15\b\196\152\248\172\240\141\128\177\179Q\v\140\149\168\133\151\159\205\16o\200\206\236\206\238,\1\227\233\238\238\156o\190ow\206\1539g\175\20\217\128F`\28\168\241\215j\192\24\208\168\229n\192N\220\182#\246|\149\01844y\2385\175\4\1Kj\255\190\0\160\a\24\6\170K\24GU;gOQ\160su\1\248\r\216\158\193\167\219\19\196\221\25\252;\129\217:\159\161\24\228SE\0\155\129\v\192;\143\128I`\b\216\156\145|>\17\192Q\15\137Y\160\211\142\171\0\199\129\247\132\219\f\208\a\152\20\242\v\214\19"`8e\242Y`\0xEq{\t\244\167\144\a\184\146\196\213\184\130H\2103Ik\151I\178\249*i\1511\230C\166,d\a\238\177\142\203\129\252\158$\242\2067P\31T\146\30\228x\19s\146>J\250b\127\183J\218 \169%\'\249\183ERig\134\245\t\240\27\184\1\236\5\154\18p\154\128}\192M;\150\fq\214\25kc\25H\153\236!\208\30\128\183\5x\156\130y:\22\249\138\205\20.\187\14\172\202\129\219\0\\\244\224\190\6*1\4\156\fMm\129\248W=\248\1891\4\188\247,\155\134\b\248\171<\203i\186(x\187\'`\219c\229I\160\195\19\216mEN\163\a\29\215\239\24c\166c\t0\198\188\147t\215q\251\144\207\183\193\214\169]\142j\233\184\195o\164\132\rkD\210\137$\14\192\139\132\235\191$M\200\22\224!\246=)\207GXF\205\192\\ \151Q\3\212\2+\179)cLGI\133\204\140\164M\1.\243\149\28e\229\151\18\207=\159B+\202<\27\133)Q@0vE\210|\160Ok\137\2\214\5\142\159\175H\186\31\232\180\161\172 \150\180>\208m\188\193\230\250.I\171\19\6\\\146\1808`[$uK\26\139\172a\183\1645\t\215\'%\157O\184\254S\210D\218S\185\224H_7Kx\3\183\29s\r\22\1\221\228\0\173\1\219"\146\223\186\168\25\\o\213\162\2243\14\224Gy\142\209\142\195\220S\199\28S1\158N\159g\'\28\142\128\127\205\131\1274\134\0\3\188(\169\160\185\236\193\157X\232\25\197\16\209\159r&y\ft\4\174\249\')\152\167b\145\207Z\212\215\128[\192~\155\211\147\14k\al\182\169\197*\234\203j\171\252\176m\149\207v\142VI\27\29{M9m\149\128\'_\182y\223\132\171\181\216&\233\233\138m-J:\155B\254\171\164~I/#\144{.\233tJ\27s\173\1643!\203\167\'c{\221\0\189\192t\142\1651\5\28\vh\175\31\t\141\129\208\15\28m\192 \240\198C\226\141\29\211\230I\175\197?p8D,\213\'\166\173Q>1\213\1\30\177;f5\227\248B\2,F\21\184\2\28^\242t\17C@hI\185\162\237\191\0G\199,\207\189\229a\246\2396\163\t\127\183\185\23\163\0Zl\127\0\230\221\162\31\207M\129\242\0\0\0\0IEND\174B`\130'
},Steal={Hash='b7c1c3db',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\2\130IDATx\218\237\154\177k\20Q\16\198\127s\158\30^\162\225"\6S\28\202\129\1A\180\bD\212B<\17\242\15\136\216\216\217(V\249\19\20\27m\4\177\1454\209&E\130M@\tZ(\17\210\168\215X\136\137\tb\163\16\131\137\231\169\a\159\133/\176\172g\238\221\222&\185\149\253\2248\222\1763o\190}\243f\230\237.$\28\214\174\1I%\224(\144mQ\181\14\1886\179\247[\194\\R\143\164\135j\31\147\146z\182\130\192\3\197\135\177M\r!I\187\129%`[L\247\163\14\244\154\217J\171\138\217\136\19\14\132\156\175\1w\129O\158\250}\192\21 \23\240\227 \240r\179\b\236\f\141\'\205l\164\197U\236\a.\4D]Q\28\201\196\20\2\171\17tV\226\1528C\194\145\r-k\0310\212 D\1948\20\26\151$\157kq\238Rh|Z\210\190&:\223\129Y3\251\28\142\199nI\163\146\234\234|\212%\221\147\212\5`\146r\192S\224D\194\162g\0068\147\1\174&\208y\128\147\192e\147T\1\142$t\15WLR-PP\146\134\154IR\146\211\232\255U\a\214\171\252\192\19\224KH>\216 \159\183\138\185\6=P/P\246j6=s\239uw\237vI\133\181\254]R^\210b\0279}AR\222\217*\184_\206\141o\248\24\240\r\161\25I\187\128E\215F/K\186if\213(\29d\0\175\204\172*\233\182\179\187\4|\144\212\r<\247\r\161A\143\235\222\185e\237\15\200\14\187\255\17\224ZD\2\203\129\246|\r{\129=\174P5\245-kf^wPR\161\225\137\200l~C\14\235f_}V7+\233\146\135\189G\235\16;\v\28\136\232\231\130\153M\255\195n\17\24\142k\19\15K*\134dSN\127\162\141M<\225lL\133\228E7gS\248\166\209<\240\17\184\5\236w\178\209vNR\1\187\0w\128ok\171\226\230\26\242\n5\207J\252\2\184\232\178D\16\167\128q`GD\2?\128\243\192\179\6u\224>p<.\2i+\145\18H\t\164\4R\2)\129\148@J %\144\18\216\24\2\191\18\236\255\207\f0\159`\2s\25w I*\198\205=\239\153\229\239\183.\157\1427\192\177\140{7[\6\166\19\228\252c\160lf\171\22zB1\192\159\239\30\242\29\234x\21\168\152\217[Rt\b~\3\18">\127\147\2451\142\0\0\0\0IEND\174B`\130'
},Target={Hash='9a07eebc',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\4OIDATx\218\237\153MlUU\16\199\255\23(\1556\214\b\t\198\20C[m\17W\194B\136\1860\138\203\130\198\26\18\148\2124,(\176+\186 \238q\141\1506\178\5\220I7\160AL\180\v\165A\132jL\1766\184\224\171\130\173\241=\b`\202\207\205!\185L\230\222w\223}\1676\209Nr\1477o\230\204\1579g\190\206\\i\17\22\225\255\rI\f!\192RI\155$\189,i\189\164nI\143Kj\t,UI\215%]\148tN\210W\146\190K\146dnA\173\aV\3\31\2W\169\31\174\132\181m\v\161\248J\224\16p\151\198\225.0\4\172\248\183\148\223\14\252A|\184\tl\159\183\24\0\150K\26\146\212\159\193rM\210\168\1641I\151$M\135G\146V\133\167C\210K\146\182\132\24\241\224\176\164\129$I\254\142\185\235\205\192\231\25;\247-\208\19\2\185p\208\3[\1293\0252O\2\205\177\148_\158\161\252\f\176\3H\26\144\157\0}\192l\134\17M1\f8\236\b\255\1X\19\241\132\219\129\243\206{Fb\4\172\133o\128\214\f\254n\224=\22440\5T\1953\5|\25h\221\25k[\1291\231}\219\26I\1496\219\156\243\148\a\158\2>\5\238\23\2006\247\129c@g\134\17\246$n\148J\177!\207[\159_\227\240\189\5\220.\1456o\1\189\25\238dc\226\2272\21\214\22\169\29\14\223\190\130\187\158w\26\251\28\185\239\26\190;uU\236P\226m\170L\156\157\247\148?\15\f\0kC\250m\14\191w\3\0232\140\232u\178\211\184\225;PT\249eNo\211\227\248\252m\167%\216\5,\201\145\189$\24r\207q\167N\195\187\213\240\\.Tk\128\23\205\194\171va\bX\171\252\230:Nx\179c\196Qg#\167\r\207\166"\194?0\139\14\25\250Z\199uv\149H\18{\28W\2342<\159\24\158\253V\142w\220\27\f>f\240\30\211C]\1444\226\212\131Q\160\18\158\227N\254\31\146\244\163\233\203z\f\207\2155tsw\230\231\188c\vE*\r\3\142\2423\25\173GW\141S8e\232\207\25\250OE\f\176/\2390\244)C\2396\244\209\156\180\249\153\225}\198\208\127u\138\233C-w\17\3l\254o6\244\170\161\183\24z%\199\128\191\fo\139\161W\156F\242\161dQ$\6\230\245>\20[\160g@\213\224\171\f>mp[!O\231\188\207\210V\215\144\253\136\193+E\f\184^\195\128\223\f\254\138\193\223\1514\235\200\157\t\1804\188j\240K\6\127\178\134n\174\1\191\24\188\195\224_\24|g\186\250&IrQ\210FI\199\195\142U\194\239\141I\146L\154Q\204\206\26\178\159\173\161[\161B6\236\164I[\200v\151(d{\141\1409\224\233\26\151\169\253E\4\191`\22]sZ\137c\134\231^\157\173\196kN+q$V+\1774\f\157\210\176\197\240t\134\6\204\26\177\167@3\183\215Q\190\234\212\1557J5s\25\237\244\25\167\157\238\205h\167\'\130!\235R\237\244\186\160\248DF;\253\166c\232\217R\237t\16\208\22.\17i\232\155\167\v\205\160#\183\191\161\vM\0162d\132\204\2\237\14_\175\227NE\160jw>\229\158\127\26\222\131e/\2457\157\219Vk\198K\143\22<\1419\224\136\245\249\212\165~\194\185\212?\22s\1722\1503V\233\2\6\129S\192dj\1722\25\254\27\180\1692\181\246\209\168c\149\156K\197\131\147h\1438\216\234\204\184/\15\199\16\222\20\198|81\209\23a\180\216\239\248<\192\137(\163\197\212p\247d\134O\143\3\175\2159\220]\22\242\252\217\f\153\'\162\rw\205I\140\228\4\231tp\183\183\129\245!\t4\133ge\248\239\157\208\30\252\158#g8\218\206g\24\178-d\134\216p\163\225\128\173\195\136\21\192GN\177+\3w\128\131\165Se\131\134\180\1\aB\159R/\\\14k\27\250\200\23\2433\235\243\2253\235\6I]\146\158\144\244 \16oI\186"iR\210\247\2253\235\248\130\127f]\132E\248\15\192?\213\219\194ev(\227C\0\0\0\0IEND\174B`\130'
},Tiny={Hash='a4a85683',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\1BIDATx\218\237\1531N\195@\20Dgs\1\136D\1338B\148\138\27\208\208\248\30\152\v$\169\160\228d\136\142;\144,H\164\1312\145\30\205F$\198"6\138\147\253\228\143\180\133\215\150v\230\235{4\187+9\254)\128\2\136i\20\22\5D\1901\235j\157\208\161\0006\22\n\161\147\181z\214[\181\183\163j\223\2S\224\t\24\252\242\221 }3\5\202\\z\253\20X\174\245\251;0\228\'\134\233\221\n\v\224$G\1\0\243\26\1\213\185<\4$\17\19\218c\146\155m\142Z\144\191\203\213\251Gf\2017\20\1457\249-"l\144_\0191NN\179\0\198V\3]\31\232{\180\245\\\191\25\141\247\133F\251\136\208@@\148t~\160\250\197\16\194\197\209\199\233\27I\241\16\213\151T\250O\236.\228.\228.\228.\228\2408}t\27\26\224\190\198\215\31,\147\183!b\v\249\188E4$\159\167\b\211G\139-\14w?+\207K\224l\31Q\162-\230\146\174j\230\175%}\228\218\255%\240\2<\174.8\170\229Os\151\1923\240\182\171\v\14\191#\179\16\167\255\138\215J46\185\21\157\165Q\200\225pt\130/+J\242\131^)\165\203\0\0\0\0IEND\174B`\130'
},Unlock={Hash='5faeeff3',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\1\191IDATx\218\237\1531/\4A\24\134\223q\141\v\'9\137\159\128\234\26\167\16\173J\195U"\146+\21\226\151\16\254\129\134\142\6Q\171\149\18\21\167A!\167p\146\187\139\136\194\1630\0186\203\218\189u\179\155\204\155l\179\187\223\204\251\204\2367\243\237\174\228\229V&\205\198\128\162\164\21I\243\146\166%\141IBRS\210\185\164\19I\a\198\152\151\204\141\4P\a\154D\235\22X\206\146\241\2\176C|m\3\133,\0\236\146\\[\174\205\175\134\152z\177\163;\5\20\129!\160\nl\1\207!\247/\1852?\f<\6\204\180\128\234/1\21\224.\16s\3\f\186\0X\v\24y\5f\255\16W\t\153\137\186\v\128\163\128\137\189\24\177\219\129\216}\23\0\23_\f\188\1\149\24\177\211\1\128k\23\0005\224\30x\0\214\19\228\207Wu2\177\19\199\132\224\155\17c\18y\25\200{-\228\1r\1\0L\2\199@\135\148\20\150\19\159\tm\151\232\201T\146\2166t&\169\220\231\193}\1464c\140i\244:\3\155\14\204\203\246\185\145\198\ft$\r;z\196;\198\152\145^\1p\250\202\24\177?\248e\212\3x\0\15\16\170+I\139\146J\246\168\217sn\202\222\152\186\4\202!\237\148\129\171^K\142~\0,D\188\4\165\n\240\31\27Y\201\24\211\253\161\173\146\164v\15872\147\135$\158Kx-\243I<\n4\242\144\196\216\213\166\6\148\236QKb\222U\18\251j\212\151\18\30\192\3\164\v\208u\232\175\157\6\192\169C\128\200\190\179\252a\171\165\143\15[\189\255;\0&\128C\160\205\255\171m\251\26\151\151\151W\164\222\1\186>\136\250\181\196\205\159\0\0\0\0IEND\174B`\130'
},Utility={Hash='d8e949c2',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\3:IDATx\218\237\153KH\21Q\28\198\255\147\168%-\180\135Vd\233\162R\174E\144D.4z!TF+\233Am\162E-j\19HB\2082\b\23\213\202\160\b[\216C\220\20\t\237\148\160\141YH\5\217\162\133\137)\149iT\226\235\215f.\28\134\185w\206\204\1563\151\194ou\185w\230;\223w^\255\239\156+\242\143\195\241\251\18\168\20\145\17\199qfl4\n\228\139\200A\17i\18\145\26\17Y-"#"2("OE\228\185\2278\vQ\201\171\129Q\224\21\176\217\130\248z\224=\217\241\22\168\139#>\141\223\192E\131\226\143\0\211\4c\2\168\141+^E\23P\18S\252F`JC\252\15`gX\242\173\192x\0\241\'`W\f\3\247m\245\252Z`\f=\252\2\246F\16_\1721u\194\139W\26\168\1:\128YM\19\251B\242\239\15\224\156\141,\222\211P\5p\195]\188\198L\0g5:f\149&W\169\206C\235\1286\224\167\137\233\164i\160Q\131\231\132\187V\215\152\216\153\180G\2h\2120p9\128\163Y\153\226m\166\182W-\19\192v\r\3]\1=?\167<\251\21\200K\196\4P\4\fh\24\248\2\156\4\170\128%Y\196\167Qi\178\208\249\154\0\28\160\147\240\152\2z\129;\25\196\0034\152\136\26~U\180Dy\190\21{\216\0227\236\249\225\156\242\220!`\222\162\129\2108\245\194\207D\187\242\251\22w4la\208D\209SM\244\1\5Jl\248\128]\\2\21\143\171\129\254\244p\2y@\143e\241C@\161\201\3\202R\229\243u\203\226\199\128*+gSw\15\183\137\30`\189\214\1538\130\248Z\17\233\19\145e1\169zEdHDR"R("\19"\210/"\143\28\199ym\171\231\203\128a\3=\220\238\30\246\147\3\144\239V\2048\152\6\206\228\228N\6\184\29S\2528\176;W\226/\196\20?\0l\240l\201\155\146\18_\15\204\196\16\223\t\20yb\199\164\187M\166l\139\175\208\184\193\200\1329\160\197\147V[<\153\201\158\t`90\24Q\252$\208\228\225\234\202R\176R\166\197;\192\195\24\229\191Z\225*w\175.\131\170n\202\164\129\171\17\197?\3\138\21\158\134\16\247P\163F\162\3p4B\182_\0\174y\142\135\a",\254x&\220\237m2d\163\127\128S>\\y\17\143\152\209\166\19\176\2\248\24\178\177\225l\183l\137\153\136\152\237_\0e\154\220vM\0007#\132\177\130\1449\170;\130\137Q\160<\136\252t\b\194Y\1818\133\156\162QG\162#\27i\157\230\191(\233\27\178=\6\18m\216\145\152\a*2\253W\240Y\147\228\141/Ir&\142\251\145\188\212|\249\129\26\198rd\226\152\151\224\188\230\208\181\2\142\165\172\165kbN\141\226\233\151;4\194\216\225\132NyA&n\249\189xE7\140%d\226\174\27G\188x\162f+\245\165\149\192\183\f\215\25%\146\3\0;\128{\238\218\236\6\154u\14+\143\129\239\192;w]8\178\136E\252\191\248\vXl\200\16\175\n4D\0\0\0\0IEND\174B`\130'
},Warning={Hash='2b2af7c9',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\2\6IDATx\218\237\152\189k\20A\28\134\1599\17\147\136\193\198\248q\137X\136g\25EmR\216\165\208^A\17b\163\133`\165\130\133\136`\227\31\161},\21,\236b!\22B:Q\4A\20\148T\26\200\a!\185\199f\193#\230\238v\247\246n\231d\31XX\216\25\246}\231\2471;\v\21\21\21\21\255%\234\172\250%\185f\135M\252A\245\151\127YV\15\15\147\129g\254\203\211a\17\127Z\221\218\193\192\150z.v\241A}c{\222\170!f\3W\237\206\149X\197\143\170_S\24\248\174\238-\234\189\181\2=\220\a\142\166\24W\a\238\197\182\250S\234\138\233YU\143\197d\224\185\217\153\143E\252\140\2184\31\231\203\22_S\223\155\159EuW\153\6n\218;7\202\18?\174\254(\192\192\146\186\191\1406\250\0168\212\225\249\203\164e\214\147\251v\28\0\30\fz\245\27\234F\151\149=\2102\190\222e\236\134\218\24\164\129W\221\242b\1359\221x=(\241\23\211$v\14\3\170\23\250-~\183\250\177\143\6>\171{\250Y\196\183\129~\230\234q\224V\150\t!\195\234O\0\159\128T-/\132\16\182G \229\171\150\129F\b\225g\209\17x\156V|\143\140\3\143\138\206\253iu3\227\6\149\165\141ngS\157.\210\192B\142\29\246E"\188\158\220ge\161(\241\151-\143K=\21\177:\n|\0\202:||\3N\134\16V\243\22\241\221\30\196\167\253\22\234\196\20p\'o\234Lf<&\22Y\196\173\172\168\147y"\240\4\24\139\224\2087\150h\25\2161\177\168.\212JS\157IU\196j\rx\a\156\141\236\215\211"p&\132\208\236\150B\215#\20\15p\n\152\235\24\1u_\242\189\19\235\175\240%\224D\b\225w\187\b\204E,\30`\2\184\214)\133\214\136\159\181N\221gD\157W\215\141\143\245D\219\b\21\21\21\21\209\240\a\f\f\212\173\27\255w\231\0\0\0\0IEND\174B`\130'
},Widgets={Hash='8014a591',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\1\182IDATx\218\237\153AJ\28A\20\134\1917\168$\144\140nC\152\141F\\\1844.#\134@<\128\23\16=\193\136\23\16\244\n\158\192\149\b\158@\132\2364\184QC\b3\227\r\f\153Q2\1423\240\187H\v\210t\207L5\173\233\144\247C/\186\171\254W\239\171\174\170n\170\192\229r!\169"i_RK\201jK\250"iq@\156eI\231\146\186\t1\186Q\217\202\128\24\243Q[\237\148\\Z\146\14$\205<N\254J\195\169\'\233cJ\195U\r\175jJ\140O)\240I\250)\169B\212\243!\170K\178X\195o\251\244X\146~Kz\19\139Q\146\212\b\204e\175\4|\14\28qS\209\245X\31\128\23\0011^\2\v\177g\239\128\201\192\\\150J\192\235\f\211f<v_\206!F\150<\202\165\127}\1r\0\ap\0\ap\0\ap\0\ap\0\ap\0\a\248\239\1n3x\218E\2\248\26X_\192Ia\0\204\236;\176\27`\2171\179\31E\155\3k\1926\208\233S\167\3l\1\235y5j\146\148\193\247\222\204N\19\199\134\244\138?\251;\163\177\162.pif7)\190Y\224"t\30\141\228\189*D\t\158e\176\214\128_\192D\128\231\1840\203\168\153\221\1\155\1\150\30\176\129\178i\238\169@$\173\14\177\217\\{\216d\206}\14\228\0041\6L\147\188\223\218\2\234f&\128\17\n\168h8}\243_\t\ax&\128\235\f\190f\145\0\14\3=u\160Q\152W i&:0\27F\221\180C\190\191\rQ\145\180\'\169\217\231\152\245\232)?`.\151+\155\238\1o\27\161\186\157j}\197\0\0\0\0IEND\174B`\130'
},World={Hash='73b3b0f5',Data=
'\137PNG\r\n\26\n\0\0\0\rIHDR\0\0\0000\0\0\0000\b\6\0\0\0W\2\249\135\0\0\4\132IDATx\218\197\154Kh\157E\20\199\255\'\205\163\210\164\162\181\v\211\23\5\177.,\4\5\27\159MS\151B\208UE\\h\17\\\t\237\166P\212M!\161"\226\178\180)\193\162\196\218\135\27\169HLk\209\16\180\138.\4\155\250"\166j\141i\30m\2104&\185?7s\225\235t\190/\223\189\247\251n\14\\\194\1579s\30\1479g\206\249\2075UH\192\29\146\30\151\180CR\171\164\251%\173\143a\191,iH\210\215\146\206J\0260\179\155Z\14\2\30\5\186\129I\202\167I\224\b\208ZM\195w\2\231\201\158\206\1my\26\190\0308\145\194\144Y\183\179\215\128i\247\185\230\198fS\172\255\16h\206\218\248\231\128\137\24\133\243\192L\25;>\r,\196\204\141\3\29Y\24n\192[1Jn$\24P\n\253\a\140\5\198\v@\'`\229\26_\v\188\23\16\188\224\148fI\31\1]1r{\128\218rv>d\252\f\249\208_No\v0\20\227\132\149\226\192\193*\26\255;\176;\162\187\t8\19\224\235,%`\v\129\204\146\a}\0144\6l\168\3z\0031\209\145&UNTi\231?\5V&\216R\231x\252\236\212\156\228\192\201*\25?\2\172Iq\26\26\129\159\188\181\189q\204O\a\178M\30T\0\158*!\30[\2\217i{\136\241| ?\231A\239\151\145\210\253\164\210\31*\204\252K*\15\154\0056\149\225@#0\234\201\218&I5\142g\183\183\166>\227RjQ\210\tIO\154\217p\169\139\205lZ\210\187\222\240\203E\239Vz%\241|\134;~\0198\6l\201\160\172\185\219\201+\210\4\208\16\n\222\233\140\234\155w\128{2.*Oyz\218k$\181{|\171*\212\211/i\171\153\2375\179\177\140\143\226\'\222\2476\1\253\25\29\151\5\224\r\160&\199\158d\163\167\179O\192\159\145\129\171\192/e\24\255\15\208^\165\1420Zz\255!\175\238\249\18\184\211\245\169i\131y\nx\176\138-\237@\244R\172\145\20-S\2556\179)3{E\210\22I\31\167\144\185\207\204~\172"\158p%\154a\253\243:\19\201\189\191Iz\193\193 qtA\210\225*\3"\215\163_j\150\184@f%\189()\14\187\217cf\5-#\249\0144\6\156\184 \233UIxS\167\205l`\25l^\237\a\197-A\156\16<\207\187lS\236\162\238]&@\237\150 \22p920\186\196\226\21\192f`\213r\29\25/\141\14\215J\186(i\157\155_\vl0\179\145\152\152X\4\174J\250\214\253\29\145\244\189\164\239$}cf\215s6~\147\164h#4T\235\128\214\157\145\193\29\146\142%\200yH\210\3\145\239\187\138\21\'\240\131\164\1I_I\2343\179\201\140}\240/\203\193"\214\25\165\147K\236\194\222\148\23\220<0\232\154\145]\192V\160\190\194\255\192iOG[\177\156\158\240J\224\187\18\132\28\174\176\188\254\2x\19\184\175D\227\215\0s^\131\223P\156<\226)\218\151 \232\181\140\138\191E\a[ZJ\a^\247\214\31\138N\182z\147W\2262\r\176\214\161\205Y\209\254\20\1987\1\255z\235\30\241\153\206y\f]\t\2\247d\232\192T\210\145u\250\222\190\173\140\0140\181yLs@K\2\240;\152\161\19\221qG\tx\216CH\n\192\19q\158\30\247\4\255\f\172\142\225\221\16\3\139\151K\199\221{\155\143F\\L\r\203\0\235\\tG\233\fP\23\195\255l\198\176\203\175\192K@\3P\15|\230\205\143-Y\194\0\29\1p\1837\193\137\238\28\240\163\27\192p\0\209{&m\206\237\138\1c\155\2\188\155sp \132\201\30(\245\129\163\' \228\146\31\216\142w4g\227\143\150\252\212\2282MO\f\230s0\138\235;\5\149\210\\\f\160|\20XQ\201#_g &p\187\190\223!f-1<i\225\152\217\24\20\251@\217\143|\129\192\30O\168oN\185\26\'\171g\214\177\212\1[\130\19\205\238\17:\237C\247T\228\161{*\229Cw\1\248 \215n\15\216\14\156\205!\243\244\197\222\17699\178\205\149\214\19\21\24=\14\28\186\1730+\5z\207\192\145\6I\143\185n\169\248s\155\141!V\215\130^\1464\232~n3hfs\149\232\255\31[y\130\140\18_\177\222\0\0\0\0IEND\174B`\130'
}}end function a.c()local b=a.cache.c if not b then b={c=__modImpl()}a.cache.c=b
end return b.c end end do local function __modImpl()local b=a.a()local c=a.c()
local d=string.format local e=task.spawn local f=b.Services.HttpService local g=
'depresivo_hub'local h=
[[https://github.com/erikdkennedy/figtree/raw/master/fonts/ttf/Figtree-%s.ttf]]
local i={{'Regular',400},{'SemiBold',600}}local function HttpGet(j)return(game):
HttpGet(j)end local j={Family='rbxasset://fonts/families/Montserrat.json',Images
={Logo='rbxassetid://18867880732'}}local function Download()local k={}for l,m in i do local n=d('%s_Figtree-%s.ttf',g,
m[1])if not isfile(n)then k[#k+1]={m,n}end end if#k>0 then local l=#k local m=
Instance.new'BindableEvent'for n,o in k do e(function()local p,q=pcall(HttpGet,
d(h,o[1][1]))if p then writefile(o[2],q)else warn('figtree download failed:',o[1
][1],q)end l-=1 if l==0 then m:Fire()end end)end m.Event:Wait()m:Destroy()end
local l={}for m,n in i do local o=d('%s_Figtree-%s.ttf',g,n[1])l[#l+1]={name=n[1
],weight=n[2],style='normal',assetId=getcustomasset(o)}end local m=g..
'_Figtree.json'writefile(m,f:JSONEncode{name='Figtree',faces=l})j.Family=
getcustomasset(m)end function j.LoadFont()if not getcustomasset then return end
local k,l=pcall(Download)if not k then warn(
'figtree failed to load, using montserrat:',l)end end function j.Font(k)return
Font.new(j.Family,k or Enum.FontWeight.Regular)end local function Embedded(k,l,m
)local n,o=pcall(function()local n=d(
'%s_%s-%s.png',g,l,m.Hash)if not isfile(n)then writefile(n,m.Data)end return
getcustomasset(n)end)if not n then warn('icon',l,'failed:',o)return end k.Image=
o end function j.Icon(k,l)local m=j.Images[l]if m then k.Image=m return k end
local n=c[l]or c[string.upper(string.sub(l,1,1))..string.sub(l,2)]if n and
getcustomasset then Embedded(k,l,n)elseif not n then warn('no icon named',l)end
return k end return j end function a.d()local b=a.cache.d if not b then b={c=
__modImpl()}a.cache.d=b end return b.c end end do local function __modImpl()
local b=a.a()local c=string.format local d=b.Services.HttpService local e=
'depresivo_hub'local f="https://japi.rest/discord/v1/user/%s"local g=
'https://cdn.discordapp.com/avatars/%s/%s.png?size=64'local h=
'https://cdn.discordapp.com/embed/avatars/0.png'local i={[
[[985c10b9c3c49f08a520e113cce20879dc976695b09438138f147afc430fb08a]] ]=
'611676758697181295',[
[[0c141f8715615971ed19824ec135143cfaa96432d48d38c8f0da00bab401b0931e52e934cbfa0f7f15bdb718dfc745ef]]
]='611676758697181295',
bc8f5c1e74a46913ec8efd66c4ed761f2348e308102d531e6d6b7da27657348f=
'1503892033725534269',[
[[511BF2B36D38AC0A9FAB358D5B10F78EFA51F1E9D586D2433FB78917C5AAE65869F2E57D8F02297CDAAEA7653C8369BA0D98E82E9F75AA39EEB132083CD694D8]]
]='1503892033725534269',[
[[1246f1c8ad4ab0726a5cc5a0ed7d19ccc1bc4e78c86bbb302d429786f7984f83]] ]=
'1481575186393464844',[
[[8df726ccd50a1456c2442b5ed7865b86be556195d88ee168e5f8071d668ec150]] ]=
'707961796115431425',[
[[78f2df322ca92ba2070ed497e422a563d342d593c083a917c8b938e4ea20bb59]] ]=
'979824685229424660',[
[[63fb1dee0705d2417fb1b35a9d23d12a5a8f038148387fb0d6488adfd72045a3]] ]=
'1213846445124231238',[
[[0fa8a3da35790d8d7e6859c278437a7959a04571714d65f807d729316548d10d]] ]=
'1523389141734129838',
da5a0f9e35f0d7f96b6ab5837ec36a8e332d4c91ff15c0627ce2d6fd1c9c0f18=
'1503123461080350831'}local j={}local k local l local function Get(m)local n=
request{Url=m,Method='GET'}if not n.Success then error(c('%s returned %s',m,
tostring(n.StatusCode)))end return n.Body end function j.Id()local m=rawget(
getgenv(),'gethwid')or gethwid if type(m)~='function'then return nil end local n
,o=pcall(m)if not n then warn('couldnt read hwid:',o)return nil end return i[o]
end local function Avatar(m,n)local o=c('%s_discord-%s-%s.png',e,m,n or'default'
)if not isfile(o)then writefile(o,Get(if
n then c(g,m,n)else h))end return getcustomasset(o)end local function Fetch(m)
local n={Id=m,Name='Discord user'}local o,p=pcall(function()return d:JSONDecode(
Get(c(f,m))).data end)if not o or type(p)~='table'then warn(
'discord lookup failed:',p)else n.Name=p.global_name or p.username or n.Name n.
Username=p.username end local q,r=pcall(Avatar,m,o and type(p)=='table'and p.
avatar or nil)if q then n.Avatar=r else warn('discord avatar failed:',r)end
return n end function j.Short(m,n)local o=utf8.len(m)if o and n<o then m=string.
sub(m,1,((utf8.offset(m,n)))-1)..'\u{2026}'end return(string.gsub(string.gsub(
string.gsub(m,'&','&amp;'),'<',"&lt;"),'>','&gt;'))end function j.Profile()if k
then return k end local m=j.Id()if not m or not request then return nil end if l
then table.insert(l,coroutine.running())return coroutine.yield()end local n={}l=
n local o=Fetch(m)k=o l=nil for p,q in n do task.spawn(q,o)end return o end
return j end function a.e()local b=a.cache.e if not b then b={c=__modImpl()}a.
cache.e=b end return b.c end end do local function __modImpl()local b=a.a()local
c=a.b()local d=a.d()local e=a.e()local f=math.clamp local g=math.floor local h=
math.round local i=math.abs local j=math.exp local k=math.min local l=math.sqrt
local m=math.ceil local n=string.format local o=string.gsub local p=task.spawn
local q=task.defer local r=task.delay local s=task.wait local t=Instance.new
local u=UDim2.new local v=UDim2.fromOffset local w=UDim2.fromScale local x=UDim.
new local y=Vector2.new local z=Vector3.new local A=Color3.fromRGB local B=
Color3.fromHSV local C=ColorSequence.new local D=NumberSequence.new local E=b.
Services.UserInputService local F=b.Services.TweenService local G=b.Services.
RunService local H=b.Services.GuiService local I=Enum.UserInputType.MouseButton1
local J=Enum.UserInputType.MouseButton2 local K=Enum.UserInputType.Touch local L
=Enum.UserInputType.MouseMovement local M=Enum.TextXAlignment.Left local N=Enum.
TextXAlignment.Right local O=Enum.AutomaticSize.X local P=Enum.AutomaticSize.Y
local Q=Enum.SortOrder.LayoutOrder local R=b.Define{Widgets={},MenuAccent=
'b29cff'}local S=table.freeze{Accent=Color3.fromHex(R.MenuAccent),Window=A(23,20
,25),Bar=A(36,34,39),Section=A(30,27,33),Header=A(27,25,30),Divider=A(22,19,24),
Edge=A(43,40,45),Field=A(36,33,40),Track=A(46,43,50),Mute=A(70,66,78),Off=A(58,
54,64),Text=A(240,238,244),Sub=A(150,146,156),Faint=A(95,91,103),Ink=A(28,24,36)
,Knob=A(250,250,252),Toast=A(22,20,26),Good=A(140,230,165),Warn=A(255,196,110),
Bad=A(255,120,120)}local T=S.Window:Lerp(S.Accent,0.16)local U=C(Color3.new(1,1,
1),A(184,184,184))local V=C(Color3.new(1,1,1),A(214,214,220))local W=C(Color3.
new(1,1,1),A(200,200,200))local X={Backquote='`',Equals='=',LeftAlt='LAlt',LeftControl='LCtrl',LeftShift='LShift',Minus='-',Return=
'Enter',RightShift='RShift',RightControl='RCtrl',RightAlt='RAlt'}local Y={Theme=S,Fonts={},Pages={}}
local Z=Y.Fonts local _={TextButton=true,TextBox=true,TextLabel=true}local aa=2
local ab={Frame={BorderSizePixel=0},CanvasGroup={BorderSizePixel=0,
BackgroundTransparency=1},TextLabel={BorderSizePixel=0,BackgroundTransparency=1,
TextSize=13,TextXAlignment=M,TextColor3=S.Text},TextButton={BorderSizePixel=0,
AutoButtonColor=false,Text='',TextSize=13,TextColor3=S.Text},TextBox={
BorderSizePixel=0,ClearTextOnFocus=false,TextSize=13,TextColor3=S.Text,
PlaceholderColor3=S.Faint},ImageLabel={BorderSizePixel=0,BackgroundTransparency=
1},ScrollingFrame={BorderSizePixel=0,BackgroundTransparency=1,ScrollBarThickness
=0,CanvasSize=u(0,0,0,0),AutomaticCanvasSize=P}}local function New(ac,ad,ae)
local af=t(ac)if _[ac]then af.FontFace=Z.Regular end for ag,ah in(ab[ac]or{})do
af[ag]=ah end for ag,ah in ad do af[ag]=ah end if _[ac]and(ac~='TextButton'or ad
.Text or ad.TextSize or ad.TextColor3 or ad.FontFace)then local ag=(t'UIPadding'
)ag.Name='Lift'ag.PaddingBottom=x(0,aa)ag.Parent=af end af.Parent=ae return af
end local ac=b.Define{MenuNoAnimations=false,MenuNoGradients=false,
MenuNoRounding=false,MenuBarSide='Bottom'}local ad=ac.MenuNoAnimations==true
local ae=ac.MenuNoGradients==true local af=false local 
function Gradient(ag,ah)if ae then return nil end return New('UIGradient',ag,ah)
end local function Corner(ag,ah)if af then return nil end return New('UICorner',
{CornerRadius=if ah then x(0,if ah<=12 then ah*2 else ah)else x(1,0)},ag)end local function Corners(ag,ah
,ai)if af then return nil end return New('UICorner',{TopLeftRadius=x(0,if ah<=12 then ah*2 else ah),
TopRightRadius=x(0,if ah<=12 then ah*2 else ah),BottomLeftRadius=x(0,if ai<=12 then ai*2 else ai),BottomRightRadius=x(0,if ai<=12 then ai*2 else ai)},ag)
end local function Stroke(ag,ah)return New('UIStroke',{Color=ah or S.Edge,
ApplyStrokeMode=Enum.ApplyStrokeMode.Border},ag)end local function Shadow(ag,ah,
ai)return New('UIShadow',{Color=Color3.new(),Transparency=ai or 0.6,BlurRadius=
x(0,ah)},ag)end local function Padding(ag,ah,ai,aj,ak)local al=ag:
FindFirstChildOfClass'UIPadding'or New('UIPadding',{},ag)al.PaddingTop=x(0,ah)al
.PaddingBottom=x(0,(aj or ah)+(if al.Name=='Lift'then aa else 0))al.PaddingLeft=
x(0,ak or ai)al.PaddingRight=x(0,ai)return al end local function List(ag,ah,ai)
return New('UIListLayout',{Padding=x(0,ah),SortOrder=Q,FillDirection=if ai then
Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical,VerticalAlignment
=if ai then Enum.VerticalAlignment.Center else Enum.VerticalAlignment.Top},ag)
end local function Icon(ag,ah,ai)return d.Icon(New('ImageLabel',ah,ai),ag)end
local function Hex(ag)return'#'..ag:ToHex()end local function Pressed(ag)return
ag.UserInputType==I or ag.UserInputType==K end local function Within(ag,ah)local
ai,aj=ag.AbsolutePosition,ag.AbsoluteSize return ah.X>=ai.X and ah.Y>=ai.Y and
ah.X<=ai.X+aj.X and ah.Y<=ai.Y+aj.Y end local function KeyName(ag)if not ag then
return"None"end return X[ag.Name]or ag.Name end local function Number(ag)if ag==
g(ag)then return n('%d',ag)end return(o(n("%.2f",ag),'%.?0+$',''))end Y.New=New
Y.Corner=Corner Y.Corners=Corners Y.Gradient=Gradient Y.Stroke=Stroke Y.Shadow=
Shadow Y.Padding=Padding Y.List=List Y.Icon=Icon Y.Hex=Hex Y.KeyName=KeyName
local ag local function Hold(ah,ai)ag={Move=ah,Stop=ai}end local ah=TweenInfo.
new(0.35,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)local function 
Draggable(ai,aj,ak,al)ai.InputBegan:Connect(function(am)if not Pressed(am)or(al
and not al(am.Position))then return end local an,ao=am.Position,aj.Position
local ap=ao Hold(function(aq)local ar=aq-an local as=ao+v(ar.X,ar.Y)local at=aj.
Parent local au=if at and at:IsA'GuiBase2d'then at.AbsoluteSize else y(1920,1080
)local av,aw=aj.AbsoluteSize,aj.AnchorPoint local ax=as.X.Scale*au.X+as.X.Offset
-aw.X*av.X local ay=as.Y.Scale*au.Y+as.Y.Offset-aw.Y*av.Y local az=y(f(ax,0,math
.max(au.X-av.X,0)),f(ay,0,math.max(au.Y-av.Y,0)))ap=as+v(az.X-ax,az.Y-ay)if ad
then aj.Position=ap else F:Create(aj,ah,{Position=ap}):Play()end end,ak and
function()ak(ap)end)end)end b.Connect(E.InputChanged,function(ai)if ag and(ai.
UserInputType==L or ai.UserInputType==K)then ag.Move(ai.Position)end end)b.
Connect(E.InputEnded,function(ai)if not ag or not Pressed(ai)then return end
local aj=ag.Stop ag=nil if aj then aj()end end)Y.Hold=Hold Y.Draggable=Draggable
local ai={}local aj={}local ak=false local function Motion(al,am,an,ao)local ap=
{Apply=ao,D=an,K=am,X=al,V=0,T=al}ao(al,0)return ap end local function Snap(al,
am)al.X,al.V,al.T=am,0,am ai[al]=nil al.Apply(am,0)end local function Go(al,am,
an)if ad then Snap(al,am)return end al.T=am al.V+=an or 0 if ak then aj[al]=true
else ai[al]=true end end local function Fade(al,am)Go(al,if am then 1 else 0)end
b.Connect(G.PreRender,function(al)al=k(al,3.333333333333333E-2)ak=true for am in
ai do am.V=j(-am.D*al)*((am.T-am.X)*am.K*al+am.V)am.X+=am.V*al if i(am.T-am.X)<
1e-3 and i(am.V)<1e-3 then am.X,am.V=am.T,0 ai[am]=nil end local an,ao=pcall(am.
Apply,am.X,am.V)if not an then ai[am]=nil warn('animation failed:',ao)end end ak
=false for am in aj do ai[am]=true end table.clear(aj)end)local function Fader(
al,am,an,ao,ap,aq,ar)return Motion(aq,300,32,function(as)local at=1-f(as,0,1)am.
GroupTransparency=at al.BackgroundTransparency=at an.Transparency=at ao.
Transparency=ap+(1-ap)*at if ar then ar(as)end end)end Y.Motion=Motion Y.Go=Go Y
.Snap=Snap Y.Fade=Fade function Y.Settle()for al in ai do Snap(al,al.T)end end
local al={}local am local function Close()local an=am if not an then return end
am=nil local ao=al[an.Frame]if ao then Go(ao.Fade,0)else an.Frame.Visible=false
end if an.Closed then an.Closed()end end local function Show(an,ao,ap,aq)Close()
local ar=al[an]local as=if ar then ar.Shell.Parent else an.Parent local at=H:
GetGuiInset()local au,av=ao.AbsolutePosition+at,ao.AbsoluteSize local aw=if as
then as.AbsoluteSize else y(1920,1080)local ax=an.Size.X.Offset local ay=f(au.X+
av.X-ax,8,aw.X-ax-8)local az=au.Y+av.Y+4 if az+ap>aw.Y-8 then az=au.Y-ap-4 end
am={Owner=ao,Closed=aq,Frame=an}if ar then ar.Base=v(ay,az)ar.Shell.Visible=true
Snap(ar.Fade,0)Go(ar.Fade,1)else an.Position=v(ay,az)an.Visible=true end end
local function IsOpen(an)return am~=nil and am.Owner==an end b.Connect(E.
InputBegan,function(an)if not am or not(Pressed(an)or an.UserInputType==J)then
return end if Within(am.Frame,an.Position)or(am.Owner and Within(am.Owner,an.
Position))then return end Close()end)Y.Close=Close local an local ao local 
function Popup(ap,aq)local ar=New('Frame',{Name=aq,AutomaticSize=Enum.
AutomaticSize.XY,BackgroundColor3=S.Window,Visible=false,ZIndex=20},an)Corner(ar
,6)local as=Stroke(ar)local at=Shadow(ar,8)local au=New('CanvasGroup',{Name=
'Body',Size=v(ap,0),AutomaticSize=P},ar)Corner(au,6)local av={Shell=ar,Base=v(0,
0)}av.Fade=Fader(ar,au,as,at,0.6,0,function(aw)ar.Position=av.Base+v(0,(1-aw)*-6
)ar.Visible=aw>0.01 or(am~=nil and am.Frame==au)end)al[au]=av return au end Y.
Popup=Popup Y.Show=Show local ap={}do local aq={}local ar local as local at
local au local av,aw,ax=26,2,6 local ay={}local az={}local function Pick(aA)if
au then au:Set(aA.Text)end Close()end local function Row(aA)local aB=aq[aA]if aB
then return aB end local aC=New("TextButton",{Name='Option',LayoutOrder=aA,Size=
u(1,0,0,av),BackgroundColor3=S.Edge,BackgroundTransparency=1,TextXAlignment=M,
TextColor3=S.Sub,TextTruncate=Enum.TextTruncate.AtEnd},as)Corner(aC,4)Padding(aC
,0,28,0,10)local aD=Motion(0,400,40,function(aD)aC.BackgroundTransparency=1-aD
end)ay[aC]=Motion(1,380,16,function(aE)aC.TextTransparency=1-f(aE,0,1)end)aC.
MouseEnter:Connect(function()Fade(aD,true)end)aC.MouseLeave:Connect(function()
Fade(aD,false)end)aC.Activated:Connect(function()Pick(aC)end)aq[aA]=aC return aC
end function ap.Build()ar=Popup(200,'DropdownWindow')Padding(ar,4,4)as=New(
'ScrollingFrame',{Name='List',Size=u(1,0,0,0),ScrollBarThickness=2,
ScrollBarImageColor3=S.Edge},ar)List(as,aw)at=Icon('Check',{Name='Check',
AnchorPoint=y(1,0.5),Position=u(1,20,0.5,0),Size=v(14,14),ImageColor3=S.Accent})
end function ap.Open(aA,aB,aC)if IsOpen(aB)then Close()return end au=aA local aD
=#aA.List for aE,aF in aA.List do local aG=Row(aE)aG.Text=aF aG.Visible=true aG.
BackgroundTransparency=1 aG.TextColor3=if aF==aA.Value then S.Accent else S.Sub
Snap(ay[aG],0)r((k(aE,5)+1)*0.035000000149,Go,ay[aG],1)if aF==aA.Value then at.Parent=aG
end end for aE=aD+1,#aq do aq[aE].Visible=false end if not table.find(aA.List,aA
.Value)then at.Parent=nil end local aE=math.min(aD,ax)*(av+aw)-aw as.Size=u(1,0,
0,aE)as.CanvasPosition=Vector2.zero ar.Size=v(aB.AbsoluteSize.X,0)local aF=az[aC
]or Motion(0,350,22,function(aF)aC.Rotation=aF*180 end)az[aC]=aF Fade(aF,true)
Show(ar,aB,aE+8,function()Fade(aF,false)au=nil end)end end local aq={}do local
ar local as local at={}local au={'Toggle','Hold','Always'}local av local aw={}
local ax local function Render(ay)if not av then return end for az,aA in au do
local aB=av.Mode==aA Fade(aw[aA],aB)if aB and ay then Snap(ax,(az-1)/3)elseif aB
then Go(ax,(az-1)/3,if(az-1)/3>ax.X then 2 else-2)end end end function aq.Build(
)ar=Popup(176,'KeybindWindow')Padding(ar,8,8)List(ar,6)local ay=New('TextLabel',
{Name='Title',LayoutOrder=1,Text='Mode',TextSize=12,TextColor3=S.Sub,Size=u(1,0,
0,14)},ar)local az=New('TextButton',{Name='Clear',Text='Clear',TextSize=12,
TextColor3=S.Sub,BackgroundTransparency=1,AnchorPoint=y(1,0),Position=w(1,0),
Size=w(0,1),AutomaticSize=O},ay)local aA=Motion(0,400,40,function(aA)az.
TextColor3=S.Sub:Lerp(S.Accent,aA)end)az.MouseEnter:Connect(function()Fade(aA,
true)end)az.MouseLeave:Connect(function()Fade(aA,false)end)az.Activated:Connect(
function()if av then av:SetBind(nil)end Close()end)local aB=New('Frame',{Name=
'Modes',LayoutOrder=2,Size=u(1,0,0,26),BackgroundColor3=S.Edge},ar)Corner(aB)
Padding(aB,2,2)as=New('Frame',{Name='Pill',AnchorPoint=y(0.5,0.5),Size=w(
0.3333333333333333,1),BackgroundColor3=S.Window:Lerp(S.Accent,0.22)},aB)Corner(
as)Shadow(as,6,0.7)ax=Motion(0,450,24,function(aC,aD)local aE=k(i(aD)*0.08+1,1.3
)as.Position=w(aC+0.16666666666666666,0.5)as.Size=u(0.3333333333333333*aE,0,1/l(
aE),0)end)for aC,aD in au do local aE=New('TextButton',{Name='Mode',Text=aD,
FontFace=Z.SemiBold,BackgroundTransparency=1,ZIndex=2,Position=w((aC-1)/3,0),
Size=w(0.3333333333333333,1)},aB)aE.Activated:Connect(function()if av then av:
SetMode(aD)Render()end end)at[aD]=aE aw[aD]=Motion(0,400,40,function(aF)aE.
TextColor3=S.Sub:Lerp(S.Text,aF)end)end end function aq.Target()return av end
function aq.Open(ay,az)if IsOpen(az)then Close()return end av=ay Render(true)
Show(ar,az,62,function()local aA=av av=nil if aA and aA.Render then aA.Render()
end end)end end local ar={}do local as local at local au local av local aw local
ax local ay local az local aA local aB local aC,aD,aE=0,0,1 local function 
Render()local aF=B(aC,aD,aE)au.Color=C(Color3.new(1,1,1),B(aC,1,1))av.Position=
w(aD,1-aE)av.BackgroundColor3=aF ax.Position=w(aC,0.5)ax.BackgroundColor3=B(aC,1
,1)ay.Text="#"..aF:ToHex():upper()az.BackgroundColor3=aF aA.Color=B(aC,aD,aE/1.5
)end local function Commit()Render()if aB then aB:Set(B(aC,aD,aE))end end local 
function Slide(aF,aG)local function Update(aH)local aI,aJ=aF.AbsolutePosition,aF
.AbsoluteSize aG(f((aH.X-aI.X)/aJ.X,0,1),f((aH.Y-aI.Y)/aJ.Y,0,1))Commit()end aF.
InputBegan:Connect(function(aH)if Pressed(aH)then Update(aH.Position)Hold(Update
)end end)end local function Knob(aF)local aG=New("Frame",{Name='Dragger',
AnchorPoint=y(0.5,0.5),Size=v(14,14),ZIndex=3},aF)Corner(aG)New('UIStroke',{
Color=Color3.new(1,1,1),Thickness=2},aG)Shadow(aG,6)return aG end function ar.
Build()as=Popup(210,'ColorWindow')as.AutomaticSize=Enum.AutomaticSize.None as.
Size=v(210,226)at=New('TextButton',{Name='Palette',Position=v(10,10),Size=u(1,-
20,0,150),BackgroundTransparency=1},as)local aF=New("CanvasGroup",{Size=w(1,1)},
at)Corner(aF,4)local aG=New('Frame',{Size=w(1,1),BackgroundColor3=Color3.new(1,1
,1)},aF)au=New('UIGradient',{},aG)local aH=New('Frame',{Size=w(1,1),
BackgroundColor3=Color3.new()},aF)New('UIGradient',{Rotation=90,Transparency=D(1
,0)},aH)av=Knob(at)aw=New('TextButton',{Name='Hue',Position=v(10,170),Size=u(1,-
20,0,10),BackgroundColor3=Color3.new(1,1,1)},as)Corner(aw)local aI={}for aJ=0,6
do aI[#aI+1]=ColorSequenceKeypoint.new(aJ/6,B((aJ/6)%1,1,1))end New('UIGradient'
,{Color=C(aI)},aw)ax=Knob(aw)ay=New('TextBox',{Name='Hex',FontFace=Z.SemiBold,
Position=v(10,192),Size=u(1,-54,0,24),BackgroundColor3=S.Edge,TextColor3=A(200,
196,206),TextXAlignment=M,PlaceholderText='#FFFFFF'},as)Corner(ay,6)Padding(ay,0
,8)ay.FocusLost:Connect(function()local aJ,aK=pcall(Color3.fromHex,ay.Text)if aJ
then aC,aD,aE=aK:ToHSV()end Commit()end)az=New('Frame',{Name='Current',
AnchorPoint=y(1,0),Position=u(1,-10,0,192),Size=v(24,24)},as)Corner(az)aA=New(
'UIStroke',{Thickness=2},az)Slide(at,function(aJ,aK)aD,aE=aJ,1-aK end)Slide(aw,
function(aJ)aC=aJ end)end function ar.Open(aF,aG)if IsOpen(aG)then Close()return
end aB=aF aC,aD,aE=aF.Value:ToHSV()Render()Show(as,aG,226,function()aB=nil end)
end end local as={}function as.Toggle(at,au)local av=New('TextButton',{Name='Toggle',Size=u(1,0,0,20),BackgroundTransparency=1,Text=au.Name,TextXAlignment=M},at)local aw=New('Frame',{Name='Box',AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-2,0.5,0),Size=UDim2.fromOffset(34,18)},av)Corner(aw,9)local ax=Stroke(aw,S.Mute)local ay=New('Frame',{Name='Knob',Position=v(2,2),Size=v(14,14),BackgroundColor3=S.Knob},aw)Corner(ay,7)local az=au.Enabled==true local aA=Motion(if az then 1 else 0,300,35,function(aA)aw.BackgroundColor3=S.Field:Lerp(S.Accent,aA)ax.Transparency=aA av.TextColor3=S.Sub:Lerp(S.Text,aA)end)local aB=Motion(if az then 1 else 0,380,16,function(aB)ay.Position=v(2+16*math.clamp(aB,0,1),2)end)au.Render=function()local aC=au.Enabled==true if aC==az then return end az=aC Fade(aA,aC)Fade(aB,aC)end av.Activated:Connect(function()au:Toggle()end)au.Render()return 20 end function as.
Slider(at,au)local av=New('Frame',{Name='Slider',Size=u(1,0,0,34),
BackgroundTransparency=1},at)New('TextLabel',{Name='Label',Text=au.Name,Size=u(1
,-80,0,16)},av)local aw=New('TextBox',{Name='Value',AnchorPoint=y(1,0),Position=
w(1,0),Size=v(80,16),BackgroundTransparency=1,TextXAlignment=N,TextColor3=S.Sub,
FontFace=Z.SemiBold,TextSize=12},av)local ax=New('TextButton',{Name='Track',
AnchorPoint=y(0,1),Position=u(0,0,1,-4),Size=u(1,0,0,8),BackgroundColor3=S.Track
},av)Corner(ax)local ay=New('Frame',{Name='Fill',BackgroundColor3=S.Accent},ax)
Corner(ay)Gradient({Color=U},ay)local az=New('Frame',{Name='Thumb',AnchorPoint=
y(0.5,0.5),Size=v(22,14),BackgroundColor3=S.Knob,ZIndex=2},ax)Corner(az)
Gradient({Rotation=90,Color=V},az)Shadow(az,5)local aA=au.Step or 1 local aB=au.
Suffix or''local aC,aD,aE=300,0,1 local aF=''local function Paint()local aG=h(k(
1.6,i(aD)*0.0025+1)*20)/20 local aH=h(f(aD*0.004,-6,6)*2)/2 local aI=n(
'%.2f %.2f %.1f',aG,aE,aH)if aI==aF then return end aF=aI az.Size=v(22*aG*aE,14*
f(1/aG,0.75,1)*aE)az.Rotation=aH end local aG=Motion((au.Value-au.Min)/(au.Max-
au.Min),280,18,function(aG,aH)local aI=f(aG,0,1)ay.Size=u(aI,22-22*aI,1,0)az.
Position=u(aI,11-22*aI,0.5,0)aD=aH*aC Paint()end)local aH=Motion(1,450,22,
function(aH)aE=h(aH*50)/50 Paint()end)au.Render=function()Go(aG,(au.Value-au.Min
)/(au.Max-au.Min))aw.Text=Number(au.Value)..aB end local function Slide(aI)local
aJ=f((aI.X-ax.AbsolutePosition.X-11)/(ax.AbsoluteSize.X-22),0,1)local aK=au.Min+
(au.Max-au.Min)*aJ local aL=f(h(aK/aA)*aA,au.Min,au.Max)if i(aL-au.Value)>1e-9
then au:SetValue(aL)end end ax.InputBegan:Connect(function(aI)if Pressed(aI)then
aC=ax.AbsoluteSize.X aG.K,aG.D=900,45 Go(aH,1.12)Slide(aI.Position)Hold(Slide,
function()aG.K,aG.D=280,18 Go(aH,1)end)end end)aw.Focused:Connect(function()aw.
Text=Number(au.Value)end)aw.FocusLost:Connect(function()local aI=tonumber(aw.
Text)if aI then au:SetValue(aI)end au.Render()end)au.Render()return 34 end local 
function Field(at,au,av)local aw=New('Frame',{Name='Field',Size=u(1,0,0,48),
BackgroundTransparency=1},at)New('TextLabel',{Name='Label',Text=au.Name,Size=u(1
,0,0,16)},aw)local ax=New(av,{Name='Box',Position=v(0,22),Size=u(1,0,0,26),
BackgroundColor3=S.Field,TextXAlignment=M,TextColor3=S.Sub,TextTruncate=Enum.
TextTruncate.AtEnd},aw)Corner(ax,6)Stroke(ax)Padding(ax,0,if av=='TextButton'
then 30 else 10,0,10)return aw,ax end function as.Dropdown(at,au)local av,aw=
Field(at,au,'TextButton')local ax=Icon('Arrow',{Name='Arrow',AnchorPoint=y(1,0.5
),Position=u(1,24,0.5,0),Size=v(18,18),ImageColor3=S.Sub},aw)au.Render=function(
)aw.Text=au.Value end aw.Activated:Connect(function()ap.Open(au,aw,ax)end)au.
Render()return 48 end function as.TextBox(at,au)local av,aw=Field(at,au,
'TextBox')aw.PlaceholderText=au.Placeholder or''aw.TextColor3=S.Text au.Render=
function()aw.Text=au.Value end aw.FocusLost:Connect(function()if aw.Text~=au.
Value then au:Set(aw.Text)end end)au.Render()return 48 end function as.Button(at
,au)local av=New('TextButton',{Name='Button',Size=u(1,0,0,28),BackgroundColor3=S
.Field,Text=au.Name,FontFace=Z.SemiBold},at)Corner(av,6)Stroke(av)av.Activated:
Connect(function()au:Press()end)return 28 end function as.Order(at,au)local av,
aw,ax=3,26,6 local ay=table.clone(au.Value)local az=m(#ay/av)local aA=22+az*aw+(
az-1)*ax local aB=New('Frame',{Name='Order',Size=u(1,0,0,aA),
BackgroundTransparency=1},at)New('TextLabel',{Name='Label',Text=au.Name,Size=u(1
,0,0,16)},aB)local aC=New('Frame',{Name='Grid',Position=v(0,22),Size=u(1,0,1,-22
),BackgroundTransparency=1},aB)local aD={}local aE local function Place(aF)aF.
Box.Position=u(aF.C/av,aF.C*ax/av,0,aF.R*(aw+ax))end local function Settle(aF)
for aG,aH in ay do local aI=aD[aH]aI.Number.Text=tostring(aG)if aH==aE then
continue end local aJ,aK=(aG-1)%av,g((aG-1)/av)if aF then Snap(aI.Col,aJ)Snap(aI
.Row,aK)else Go(aI.Col,aJ)Go(aI.Row,aK)end end end for aF,aG in ay do local aH=
New('TextButton',{Name='Chip',Size=u(1/av,-(av-1)*ax/av,0,aw),BackgroundColor3=S
.Field,Text=aG,TextSize=12,FontFace=Z.SemiBold,TextColor3=S.Text,AutoButtonColor
=false},aC)Corner(aH,6)local aI=Stroke(aH)local aJ=New('UIScale',{},aH)local aK=
New('TextLabel',{Name='Slot',Position=v(7,0),Size=v(12,aw),TextSize=11,
TextColor3=S.Sub,TextXAlignment=M},aH)local aL={Box=aH,C=0,D=0,Number=aK,R=0,L=0
}local function Paint()local aM,aN=f(aL.L,0,1),f(aL.D,0,1)aJ.Scale=1+0.08*aL.L
aI.Color=S.Edge:Lerp(S.Bad,aN*0.6):Lerp(S.Accent,aM)aH.BackgroundColor3=S.Field:
Lerp(S.Bad,aN*0.28):Lerp(S.Accent,0.18*aM)aH.TextColor3=S.Text:Lerp(S.Sub,aN)end
aL.Col=Motion(0,420,30,function(aM)aL.C=aM Place(aL)end)aL.Row=Motion(0,420,30,
function(aM)aL.R=aM Place(aL)end)aL.Lift=Motion(0,500,26,function(aM)aL.L=aM
Paint()end)aL.Dead=Motion(if au.Off[aG]then 1 else 0,300,30,function(aM)aL.D=aM
Paint()end)aD[aG]=aL aH.InputBegan:Connect(function(aM)if aM.UserInputType==Enum
.UserInputType.MouseButton2 and not aE then au:SetOff(aG,not au.Off[aG])return
end if not Pressed(aM)or aE then return end aE=aG aH.ZIndex,aK.ZIndex=5,6 local
aN=y(aM.Position.X-aH.AbsolutePosition.X,aM.Position.Y-aH.AbsolutePosition.Y)
Fade(aL.Lift,true)Hold(function(aO)local aP,aQ=aC.AbsolutePosition,aC.
AbsoluteSize local aR=(aQ.X+ax)/av local aS,aT=aO.X-aP.X-aN.X,aO.Y-aP.Y-aN.Y
Snap(aL.Col,aS/aR)Snap(aL.Row,aT/(aw+ax))local aU=f(g((aS+(aR-ax)*0.5)/aR),0,av-
1)local aV=f(g((aT+aw*0.5+ax*0.5)/(aw+ax)),0,az-1)local aW=f(aV*av+aU+1,1,#ay)
local aX=table.find(ay,aG)if aX and aW~=aX then table.remove(ay,aX)table.insert(
ay,aW,aG)Settle(false)end end,function()aE=nil aH.ZIndex,aK.ZIndex=1,1 Fade(aL.
Lift,false)Settle(false)au:Set(table.clone(ay))end)end)end au.Render=function()
for aF,aG in aD do Fade(aG.Dead,au.Off[aF]==true)end if aE then return end ay=
table.clone(au.Value)Settle(false)end Settle(true)return aA end function as.
Color(at,au)local av=New("TextButton",{Name='Color',Size=u(1,0,0,20),
BackgroundTransparency=1,Text=au.Name,TextXAlignment=M,TextColor3=S.Text},at)
local aw=New('Frame',{Name='Swatch',AnchorPoint=y(1,0.5),Position=u(1,-2,0.5,0),
Size=v(18,18)},av)Corner(aw)local ax=New('UIStroke',{Thickness=2},aw)au.Render=
function()local ay,az,aA=au.Value:ToHSV()aw.BackgroundColor3=au.Value ax.Color=
B(ay,az,aA/1.5)end av.Activated:Connect(function()ar.Open(au,aw)end)au.Render()
return 20 end local at=TweenInfo.new(0.18,Enum.EasingStyle.Quart,Enum.
EasingDirection.Out)local au local function Tip(av,aw)if not aw or ''==aw then
return end local ax,ay,az local aA local function Build()if ax then return end
local aB=New('Frame',{Name='Tip',Size=v(0,22),ClipsDescendants=true,
BackgroundColor3=A(20,20,20),BackgroundTransparency=1,ZIndex=200},an)Corner(aB,6
)ay=New('UIStroke',{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Color=A(34,34,34
),Thickness=1.5,Transparency=1},aB)Padding(aB,0,6)az=New('TextLabel',{
AnchorPoint=y(0,0.5),Position=w(0,0.5),AutomaticSize=Enum.AutomaticSize.XY,
TextSize=14,TextColor3=A(151,151,151),TextTransparency=1,Text=aw,ZIndex=101},aB)
ax=aB end local function Place()local aB=E:GetMouseLocation()local aC=ax aC.
Position=v(aB.X+20,aB.Y+20)end local function Fade(aB,aC)F:Create(ax,aC,{
BackgroundTransparency=if aB then 0 else 1}):Play()F:Create(ay,aC,{Transparency=
if aB then 0 else 1}):Play()F:Create(az,aC,{TextTransparency=if aB then 0 else 1
}):Play()end local aB aB=function(aC)if aA then aA:Disconnect()aA=nil end if au
==aB then au=nil end if not ax then return end local aD=if aC then TweenInfo.
new(0)else at F:Create(ax,aD,{Size=v(0,22)}):Play()Fade(false,aD)end av.
MouseEnter:Connect(function()Build()if au and au~=aB then au(true)end au=aB
Place()local aC=az if aC.TextBounds.X==0 then G.PreRender:Wait()end if au~=aB
then return end F:Create(ax,at,{Size=v(m(aC.TextBounds.X)+12,22)}):Play()Fade(
true,at)if aA then aA:Disconnect()end aA=G.PreRender:Connect(function()local aD=
Y.Window local aE=E:GetMouseLocation()-H:GetGuiInset()if not aD or not aD.
Opening()or not av.Visible or not Within(av,z(aE.X,aE.Y,0))then aB(false)return
end Place()end)end)av.MouseLeave:Connect(function()aB(false)end)end local av={}
local aw local function Section(ax,ay)local az=New('Frame',{Name='Section',Size=
w(1,0),AutomaticSize=P,BackgroundColor3=S.Section,BackgroundTransparency=0.7},ax)Corner(az,6)Stroke(az)
local aA=#ay.List==0 local aB=New('Frame',{Name='Header',Size=u(1,0,0,40), BackgroundColor3=S.Header,BackgroundTransparency=0.6},az)Corners(aB,6,if aA then 6 else 0)New('TextLabel',{
Name='Title',Position=v(12,0),Size=u(1,-130,1,0), FontFace=Z.SemiBold,TextSize=
15,TextTruncate=Enum.TextTruncate.AtEnd,Text=(string.gsub(ay.Name,'(%l)(%u)','%1 %2'))},aB)Tip(aB,ay.Tooltip) New('TextLabel',{Name='Tooltip',Visible=false,Position=v(12,26), Size=u(1,-130,0,13),TextSize=12,
TextColor3=S.Sub,TextTruncate=Enum.TextTruncate.AtEnd,Text=ay.Tooltip or''},aB)
local aC=New('Frame',{Name='Controls',AnchorPoint=y(1,0.5),Position=u(1,-10,0.5,
0),Size=v(0,22),AutomaticSize=O,BackgroundTransparency=1},aB)List(aC,8,true).
HorizontalAlignment=Enum.HorizontalAlignment.Right local aD local function Press
()local aE=aw aw=if aE==ay then nil else ay if aE and av[aE]then av[aE]()end if
av[ay]then av[ay]()end end local function MakeChip()if aD then return aD end
local aE=New('TextButton',{Name='Chip',LayoutOrder=1,Size=v(0,20),AutomaticSize=
O,BackgroundColor3=S.Field,TextSize=11,FontFace=Z.SemiBold,TextColor3=S.Sub,Text
=KeyName(ay.Bind)},aC)Corner(aE,5)Padding(aE,0,7)aE.Activated:Connect(Press)aE.
MouseButton2Click:Connect(function()aq.Open(ay,aC)end)aD=aE return aE end aB.
InputBegan:Connect(function(aE)if aE.UserInputType==Enum.UserInputType.
MouseButton2 then end end)local aE,aF if ay.Action then aE
=New('TextButton',{Name="Run",LayoutOrder=2,Size=v(46,22),BackgroundColor3=S.
Accent,Text=ay.Button or'Run',FontFace=Z.SemiBold,TextSize=12,TextColor3=S.Ink,Visible=false},
aC)Corner(aE)else aE=New('TextButton',{Name='Switch',LayoutOrder=2,Size=v(36,20)
,BackgroundColor3=S.Off},aC)Corner(aE)aF=New('Frame',{Name='Knob',AnchorPoint=y(
0,0.5),Size=v(16,16),BackgroundColor3=S.Knob},aE)Corner(aF)Shadow(aF,4)end local
aG if aF then local aH,aI=1,0 aF.AnchorPoint=y(0.5,0.5)aG=Motion(if ay.Enabled
then 1 else 0,380,22,function(aJ,aK)local aL=if aG then aG.T else aJ local aM=if
aJ<aL then 1 elseif aL<aJ then-1 else 0 if aI~=0 and aM~=aI and i(aK)>0.5 then
aH=math.max(1-i(aK)/10*0.3,0.7)aI=0 end aH+=(1-aH)*0.18 local aN=k(i(aK)*0.15+1,
1.25)aE.BackgroundColor3=S.Off:Lerp(S.Accent,f(aJ,0,1))aF.Position=u(0,10+f(aJ,-
8E-2,1.08)*16,0.5,0)aF.Size=v(16*aN*aH,16*(2-aH)/l(aN))end)av[ay]=function()
local aJ=if ay.Enabled then 1 else 0 local aK=aG if aK.T~=aJ then aI=if aJ>aK.X
then 1 else-1 Go(aK,aJ,if ay.Enabled then 8 else-8)end end end local aH=av[ay]av
[ay]=function()local aI=false if aI or aD then  local aJ=MakeChip()aJ.Visible=aI aJ.Text=if aw==ay then'...'else KeyName(ay
.Bind)aJ.TextColor3=if ay.Bind then S.Text else S.Faint end if aH then aH()end
end aE.Activated:Connect(function()ay:Toggle()end)av[ay]()if aA then return end
New('Frame',{Name='Divider',AnchorPoint=y(0,1),Position=w(0,1),Size=u(1,0,0,1),
BackgroundColor3=S.Divider},aB)local aI=New('Frame',{Name='Content',Position=v(0,40), Size=w(1,0),AutomaticSize=P,BackgroundTransparency=1},az)Padding(aI,10,12,
12,12)List(aI,8)for aJ,aK in ay.List do local aL=as[aK.Kind]if aL then aL(aI,aK)
local aM=aI:GetChildren()local aN=aM[#aM]aK.Root=aN if aN:IsA'GuiObject'then aN.
Visible=aK.Visible~=false Tip(aN,aK.Tooltip)end end end end local ax={Button=28,Color=20,Dropdown=48,Order=80,TextBox=48,Toggle=20,Slider=34}local function Estimate(ay)local az=40  for aA,aB in ay.List do if aB.Visible~=false then az+=(
if aB.Kind=='Order'then 16+m(#aB.Value/3)*32 else ax[aB.Kind]or 20)+8 end end
return az+if#ay.List>0 then 14 else 0 end b.Connect(E.InputBegan,function(ay,az)
local _mb=getgenv().__MBFromInput(ay,az)if ay.UserInputType~=Enum.UserInputType.Keyboard and not(_mb and aw)then return end local aA=aw if aA then aw=nil if ay.KeyCode~=Enum.KeyCode.Escape then local aB=if ay.KeyCode==Enum.KeyCode.Backspace then nil else(_mb or ay.KeyCode)q(aA.SetBind,aA,aB)end av[aA]()return end end)table.insert(getgenv().__MBCaps,function(nm)local aA=aw if not aA then return false end aw=nil q(aA.SetBind,aA,getgenv().__MBind(nm))av[aA]()return true end)local ay=false local az=146 local function TabWidth(aA,aB)return if ay then az else aA.Wide()end local function Column(aA,aB,_one)
local aC=New('ScrollingFrame',{Name='Column',Position=if _one then w(0,0)else w(aB*0.5,0),Size=if _one then w(1,1)else w(0.5,1)},aA)Padding(aC,10,if _one or aB==0 then(if _one then 10 else 5)else 10,10,if _one or aB==0 then 10 else 5)List(aC,10)
return aC end local function Fill(aA)if true then local _c=Column(aA.Frame,0,true)aA.Columns={_c,_c}else aA.Columns={Column(aA.Frame,0),Column(aA.Frame,1)}end aA.Used={0,0}for aB,aC in aA.Modules do b.Breathe()if av[aC]or aC.Hidden then continue end local aD=if aA.Used[1]<=aA.Used[2]then 1 else 2 aA.Used[aD]+=
Estimate(aC)Section(aA.Columns[aD],aC)end end function Y.Select(aA)local aB=Y.
Current if aB==aA then return end Close()Y.Current=aA if not aA.Built then aA.
Built=true aA.Build(aA)end Fade(aA.Active,true)Go(aA.Width,TabWidth(aA,true))if
not aB then Snap(aA.Slide,0)return end local aC=Y.Window.Pages.AbsoluteSize.X
local aD=if aA.Index>aB.Index then 1 else-1 Fade(aB.Active,false)Go(aB.Width,
TabWidth(aB,false))aB.Leaving=true aA.Leaving=false if not aA.Frame.Visible then
Snap(aA.Slide,aD*aC)end Go(aA.Slide,0)Go(aB.Slide,-aD*aC)end function Y.Page(aA,
aB,aC)local aD=Y.Window local aE={Name=aA,Build=aC,Built=false,Index=#Y.Pages+1}
aE.Frame=New('Frame',{Name='Page',Size=w(1,1),BackgroundTransparency=1,Visible=
false},aD.Pages)aE.Tab=New('TextButton',{Name='Tab',LayoutOrder=aE.Index,Size=v(
36,36),BackgroundColor3=T,BackgroundTransparency=1,ClipsDescendants=true},aD.
Tabs)Corner(aE.Tab)aE.Ring=Stroke(aE.Tab,S.Window:Lerp(S.Accent,0.3))aE.Ring.
Transparency=1 aE.Glyph=Icon(aB,{Name='Glyph',Visible=false,AnchorPoint=y(0.5,0.5),Position=u(
0,18,0.5,0),Size=v(16,16),ScaleType=Enum.ScaleType.Fit,ImageColor3=S.Faint},aE.
Tab)aE.Label=New('TextLabel',{Name='Label',Position=v(14,0),Size=w(0,1),
AutomaticSize=O,FontFace=Z.SemiBold,TextSize=12,Text=(({Steal='Teleport',Blatant='Misc',Render='Esp',World='Auto Buy',Widgets='Guis'})[aA]or aA),TextTransparency=1},aE.
Tab)aE.Wide=function()local aF=aE.Label.TextBounds.X return 28+(if aF>0 then aF
else#aA*7)end aE.Label:GetPropertyChangedSignal'TextBounds':Connect(function()if not ay then Go(aE.Width,aE.Wide())end end)aE.Width=Motion(
TabWidth(aE,false),300,30,function(aF)aE.Tab.Size=v(aF,36)end)aE.Active=Motion(0
,300,35,function(aF)aE.Tab.BackgroundTransparency=1-aF aE.Ring.Transparency=1-aF
aE.Label.TextTransparency=0.5*(1-aF) aE.Glyph.ImageColor3=S.
Faint:Lerp(S.Text,aF)end)aE.Slide=Motion(0,200,28,function(aF)aE.Frame.Position=
v(aF,0)if aE.Leaving and i(aF)>=aD.Pages.AbsoluteSize.X-0.5 then aE.Leaving=
false end aE.Frame.Visible=Y.Current==aE or aE.Leaving==true end)aE.Tab.
Activated:Connect(function()Y.Select(aE)end)Y.Pages[#Y.Pages+1]=aE return aE end
local function Window()local aA=New('Frame',{Name='Window',AnchorPoint=y(0.5,0.5
),Position=w(0.500000000577,0.5),Size=v(620,480),BackgroundColor3=S.Window},an)Corner(aA,6)
local aB=Stroke(aA)local aC=Shadow(aA,16,0.5)local aD=New('CanvasGroup',{Name=
'Body',AnchorPoint=y(0.5,0.5),Position=w(0.5,0.5),Size=v(620,480)},aA)Corner(aD,
6)local _bgM=New('ImageLabel',{Name='Bg',Size=w(1,1),ZIndex=0,BackgroundTransparency=1,ImageTransparency=0.35,ScaleType=Enum.ScaleType.Crop,Visible=false},aD)_G.__SE_AddBg(_bgM)New('TextButton',{Modal=true,BackgroundTransparency=1,Size=v(0,0)},aD)local aE=New('Frame',{Name='Bar',AnchorPoint=y(0,1),Position=w(0,1),Size=u(1,0,0,50),
BackgroundColor3=S.Bar,BackgroundTransparency=0.35},aD)local aF=Corners(aE,0,6)local aG=Gradient({Rotation=
270,Color=W},aE)local aH=New('Frame',{Name='Divider',Size=u(1,0,0,1),
BackgroundColor3=S.Edge},aE)local aI=New('Frame',{Name='Row',Size=w(1,1),
BackgroundTransparency=1},aE)local aJ=Padding(aI,0,12,0,10)local aK=List(aI,8,
true)local aL=Icon('Logo',{Name='Logo',LayoutOrder=0,Size=v(22,22),ImageColor3=S
.Accent},aI)aL.Visible=false local aM=New('Frame',{Name='Name',LayoutOrder=2,Size=u(0,0,1,0),
AutomaticSize=O,BackgroundTransparency=1},aI)List(aM,5,true)New('TextLabel',{
Name='Title',LayoutOrder=1,Size=u(0,0,1,0),AutomaticSize=O,FontFace=Z.SemiBold,
TextSize=16,Text='DEPRESIVINI PRV HUB'},aM)local aN=New('TextLabel',{Name='Build',Visible=false,
LayoutOrder=2,AutomaticSize=Enum.AutomaticSize.XY,BackgroundColor3=S.Edge,
BackgroundTransparency=0,FontFace=Z.SemiBold,TextSize=10,TextColor3=S.Sub,
TextXAlignment=Enum.TextXAlignment.Center,Text=Y.Build},aM)Corner(aN,4)Padding(
aN,3,3)local aO=New('Frame',{Name='Tabs',LayoutOrder=3,Size=u(0,0,1,0),
AutomaticSize=O,BackgroundTransparency=1},aI)local aP=List(aO,6,true)local aQ=
Padding(aO,0,0,0,4)local aR=New('Frame',{Name='Pages',Size=u(1,0,1,-50),
BackgroundTransparency=1,ClipsDescendants=true},aD)local aS=New('Frame',{Name=
'Right',AnchorPoint=y(1,0.5),Position=u(1,-10,0.5,0),Size=v(0,36),AutomaticSize=
O,BackgroundTransparency=1},aE)local aT=List(aS,10,true)local aU=50 local aV=170
local aW=x(0,6)local aX=x(0,0)local aY,aZ local function Arrange()if aY and aZ
then aZ.LayoutOrder=if ay then 1 else 2 aY.LayoutOrder=if ay then 2 else 1 aY.
TextXAlignment=if ay then M else N end end local function SetSide(a_)ay=a_==
'Left'or a_=='Right'Arrange()local a0=a_=='Top'or a_=='Left'local a1=if a0 then
0 else 1 local a2=Enum.FillDirection.Horizontal local a3=Enum.FillDirection.
Vertical if ay then aE.AnchorPoint=y(a1,0)aE.Position=w(a1,0)aE.Size=u(0,aV,1,0)
aH.AnchorPoint=y(1-a1,0)aH.Position=w(1-a1,0)aH.Size=u(0,1,1,0)aR.Position=v(if
a0 then aV else 0,0)aR.Size=u(1,-aV,1,0)else aE.AnchorPoint=y(0,a1)aE.Position=
w(0,a1)aE.Size=u(1,0,0,aU)aH.AnchorPoint=y(0,1-a1)aH.Position=w(0,1-a1)aH.Size=
u(1,0,0,1)aR.Position=v(0,if a0 then aU else 0)aR.Size=u(1,0,1,-aU)end aL.Parent
=if ay then aM else aI aM.Size=if ay then u(0,0,0,26)else u(0,0,1,0)aK.
FillDirection=if ay then a3 else a2 aK.VerticalAlignment=if ay then Enum.
VerticalAlignment.Top else Enum.VerticalAlignment.Center aK.Padding=x(0,if ay
then 12 else 8)aJ.PaddingTop=x(0,if ay then 14 else 0)aJ.PaddingLeft=x(0,if ay
then 12 else 10)aO.Size=if ay then w(1,0)else u(0,0,1,0)aO.AutomaticSize=if ay
then P else O aP.FillDirection=if ay then a3 else a2 aQ.PaddingLeft=x(0,if ay
then 0 else 4)aS.AnchorPoint=if ay then y(0,1)else y(1,0.5)aS.Position=if ay
then u(0,12,1,-12)else u(1,-10,0.5,0)aS.Size=if ay then v(0,0)else v(0,36)aS.
AutomaticSize=if ay then Enum.AutomaticSize.XY else O aT.FillDirection=if ay
then a3 else a2 aT.VerticalAlignment=if ay then Enum.VerticalAlignment.Bottom
else Enum.VerticalAlignment.Center if aF then aF.TopLeftRadius=if a_=='Top'or a_
=='Left'then aW else aX aF.TopRightRadius=if 'Top'==a_ or a_=='Right'then aW else
aX aF.BottomLeftRadius=if a_=='Bottom'or a_=='Left'then aW else aX aF.
BottomRightRadius=if 'Bottom'==a_ or a_=='Right'then aW else aX end if aG then aG
.Rotation=if a_=='Top'then 90 elseif a_=='Left'then 0 elseif a_=='Right'then 180
else 270 end for a4,a5 in Y.Pages do Snap(a5.Width,TabWidth(a5,Y.Current==a5))a5
.Active.Apply(a5.Active.X,0)end end SetSide('Left')local a_=an:FindFirstAncestorWhichIsA'BasePlayerGui'local function Grabbable(a0)local a1=H:
GetGuiInset()for a2,a3 in(a_):GetGuiObjectsAtPosition(a0.X,a0.Y+a1.Y)do if a3:
IsA'GuiButton'or a3:IsA'TextBox'then return false end if a3==aA then return true
end if a3:IsDescendantOf(aA)then if a3:IsA'ScrollingFrame'and a0.X>a3.
AbsolutePosition.X+a3.AbsoluteWindowSize.X then return false end elseif a3.
BackgroundTransparency<1 then return false end end return false end if a_ then
Draggable(aA,aA,nil,Grabbable)else Draggable(aI,aA)end local a0=New('Frame',{
Name='Profile',LayoutOrder=1,Size=v(0,30),AutomaticSize=O,BackgroundTransparency
=1,Visible=false},aS)List(a0,8,true)aY=New("TextLabel",{Name='User',LayoutOrder=
1,RichText=true,Size=w(0,1),AutomaticSize=O,TextSize=11,TextColor3=S.Sub,
TextXAlignment=N,LineHeight=1.05},a0)local a1=New('ImageLabel',{Name='Avatar',
LayoutOrder=2,Size=v(26,26)},a0)aZ=a1 Corner(a1)New('UIStroke',{Color=S.Accent,
Transparency=0.45,Thickness=1.5},a1)Arrange()local a2=aY p(function()local _lp=game:GetService('Players').LocalPlayer local a4=n('<font size="13" color="%s" weight="semibold">%s</font>',Hex(S.Text),e.Short(_lp.DisplayName,16))a2.Text=a4..'\n@'..e.Short(_lp.Name,16)a1.Image='rbxthumb://type=AvatarHeadShot&id='.._lp.UserId..'&w=48&h=48'a0.Visible=true end) local a3=true local a4=New('UIScale',
{},aD)local a5={}local a6=(setmetatable({},{__mode='k'}))local function Collect(
)table.clear(a5)local a7=Y.Current for a8,a9 in{aE,a7 and a7.Frame}do for ba,bb
in a9:GetDescendants()do if not(bb:IsA'TextLabel'or bb:IsA'TextButton'or bb:IsA
'TextBox')then continue end local bc=a6[bb]if not bc then bc=New('UIScale',{Name
='Counter'},bb)a6[bb]=bc end a5[#a5+1]=bc end end end local function Counter(a7)
for a8,a9 in a5 do a9.Scale=1/a7 end end Y.Window={Frame=aA,Tabs=aO,Right=aS,
Pages=aR,SetSide=SetSide,Opening=function()return a3 end,Open=Fader(aA,aD,aB,aC,
0.500000000235,1,function(a7)local a8=f(a7/0.7,0,1)local a9=if a8>=1 then 1 else 1+0.04*(1-
a8*a8*(3-2*a8))aA.Size=v(620*a9,480*a9)a4.Scale=a9 Counter(a9)if a9==1 then
table.clear(a5)end aA.Visible=a3 or a7>0.01 end),Collect=Collect,Set=function(a7
)a3=a7 end}end function Y.Toggle(aA)local aB=Y.Window local aC=if aA==nil then
not aB.Opening()else aA aB.Set(aC)aB.Collect()if aC then aB.Frame.Visible=true
else Close()end Fade(aB.Open,aC)end local aA local aB={Info={S.Accent,'Logo'},
Success={S.Good,'Check'},Warning={S.Warn,'Warning'},Error={S.Bad,'Warning'}}
local aC=0 function Y.Notify(aD,aE,aF,aG,aH)do return nil end local aI=aB[aF or'Info']or aB.Info
aC+=1 local aJ=New('Frame',{Name='Toast',LayoutOrder=aC,Size=v(0,48),
AutomaticSize=O,BackgroundColor3=S.Toast},aA)Corner(aJ)local aK=Stroke(aJ)local
aL=New('UIShadow',{Color=Color3.new(),Transparency=0.5,BlurRadius=x(0,14),Offset
=v(0,4)},aJ)local aM=New('CanvasGroup',{Name='Body',Size=u(0,0,1,0),
AutomaticSize=O},aJ)Corner(aM)Padding(aM,0,20,0,8)List(aM,10,true)local aN=New(
'Frame',{Name='Chip',LayoutOrder=1,Size=v(32,32),BackgroundColor3=S.Window:Lerp(
aI[1],0.22)},aM)Corner(aN)if aH then local aO=New('ImageLabel',{Size=w(1,1),
BackgroundTransparency=1,ScaleType=Enum.ScaleType.Crop,Image=aH},aN)Corner(aO)
else Icon(aI[2],{AnchorPoint=y(0.5,0.5),Position=w(0.5,0.5),Size=v(19,19),
ImageColor3=aI[1]},aN)end New("TextLabel",{Name='Text',LayoutOrder=2,RichText=
true,Size=u(0,0,1,0),AutomaticSize=O,TextSize=12,TextColor3=S.Sub,LineHeight=1.1
,Text=n('<font size="13" color="%s" weight="semibold">%s</font>\n%s',Hex(S.Text)
,aD,aE)},aM)local aO=aA:GetChildren()if#aO>5 then local aP for aQ,aR in aO do if
aR:IsA'Frame'and(not aP or(aR).LayoutOrder<(aP).LayoutOrder)then aP=aR end end
if aP then aP:Destroy()end end local aP=Fader(aJ,aM,aK,aL,0.5,0)Go(aP,1)r(aG or
4,function()Go(aP,0)r(0.35,aJ.Destroy,aJ)end)end local aD={}function Y.Listen(aE
)aD[#aD+1]=aE end local aE=string.gsub local aF={}local aG={}local aH={}local aI
={}local aJ={'Size',"Position"}local aK={UICorner={'CornerRadius'},UIPadding={
'PaddingTop','PaddingBottom','PaddingLeft','PaddingRight'},UIListLayout={
'Padding'},UIGridLayout={'CellSize','CellPadding'},UIStroke={'Thickness'},
UIShadow={'BlurRadius','Offset'},UISizeConstraint={'MinSize','MaxSize'},
ScrollingFrame={'Size','Position','CanvasSize','ScrollBarThickness'},TextLabel={
'Size','Position','TextSize','Text'},TextButton={'Size','Position','TextSize',
'Text'},TextBox={'Size','Position','TextSize'}}local function Grow(aL,aM)local
aN=typeof(aL)if aN=='UDim2'then return u(aL.X.Scale,h(aL.X.Offset*aM),aL.Y.Scale
,h(aL.Y.Offset*aM))elseif 'UDim'==aN then return x(aL.Scale,h(aL.Offset*aM))
elseif aN=='Vector2'then return y(h(aL.X*aM),h(aL.Y*aM))elseif aN=='number'then
return if aL>0 then math.max(h(aL*aM),1)else aL elseif aN=='string'then return(
aE(aL,'size="(%d+)"',function(aO)return n('size="%d"',h((tonumber(aO))*aM))end))
end return aL end local function Apply(aL,aM,aN)local aO=aL local aP=aO[aN]if aM
.Last[aN]~=nil and aP~=aM.Last[aN]then aM.Base[aN]=aP end local aQ=Grow(aM.Base[
aN],aH[aM.Root]or 1)aM.Last[aN]=aQ aO[aN]=aQ end local function Track(aL,aM)
local aN=aK[aL.ClassName]or(if aL:IsA'GuiObject'then aJ else nil)if not aN or aI
[aL]then return end local aO={Root=aM,Base={},Last={},Links={}}aI[aL]=aO for aP,
aQ in aN do if(aQ=='Text'and not(aL).RichText)or(aQ=='Position'and aL==aM)then
continue end aO.Base[aQ]=(aL)[aQ]aO.Links[#aO.Links+1]=aL:
GetPropertyChangedSignal(aQ):Connect(function()if(aL)[aQ]~=aO.Last[aQ]then
Apply(aL,aO,aQ)end end)Apply(aL,aO,aQ)end end local function Untrack(aL)local aM
=aI[aL]if not aM then return end aI[aL]=nil for aN,aO in aM.Links do aO:
Disconnect()end end function Y.SetScale(aL,aM)aF[aL]=aM local aN=aG[aL]if not aN
then return end aH[aN]=aM/100 for aO,aP in aI do if aP.Root~=aN then continue
end for aQ in aP.Base do Apply(aO,aP,aQ)end end end function Y.ScaleSlider(aL,aM
,aN)local aO=aL:CreateSlider{Name=aN or'Scale',Min=50,Max=200,Default=100,Step=5
,Suffix='%',Tooltip='How big the '..aM..' overlay is',Function=function(aO)Y.
SetScale(aM,aO)end}Y.SetScale(aM,aO.Value)return aO end function Y.Place(aL,aM,
aN,aO)aG[aL]=aM aH[aM]=(aF[aL]or 100)/100 Track(aM,aM)for aP,aQ in aM:
GetDescendants()do Track(aQ,aM)end aM.DescendantAdded:Connect(function(aP)Track(
aP,aM)end)aM.DescendantRemoving:Connect(Untrack)local aP=R.Widgets[aL]aM.
Position=if type(aP)=='table'and#aP==4 then u(aP[1],aP[2],aP[3],aP[4])else aO q(
function()local aQ=an.AbsoluteSize local aR,aS=aM.AbsolutePosition,aM.
AbsoluteSize if aR.X+aS.X<20 or aR.Y+aS.Y<20 or aR.X>aQ.X-20 or aR.Y>aQ.Y-20
then aM.Position=aO end end)Draggable(aN,aM,function(aQ)R.Widgets[aL]={aQ.X.
Scale,aQ.X.Offset,aQ.Y.Scale,aQ.Y.Offset}b.Save()end)end function Y.Widget(aL,aM
,aN,aO)local aP=New('Frame',{Name=aL,Size=v(aN,0),AutomaticSize=P,
BackgroundColor3=S.Window,Visible=false},ao)Corner(aP,6)Stroke(aP)Shadow(aP,10)
local aQ=New('Frame',{Name='Top',Size=u(1,0,0,40),BackgroundColor3=S.Bar},aP)
Corners(aQ,6,0)Gradient({Rotation=90,Color=W},aQ)New('Frame',{AnchorPoint=y(0,1)
,Position=w(0,1),Size=u(1,0,0,1),BackgroundColor3=S.Edge},aQ)Icon(aM,{Position=
v(12,10),Size=v(20,20),ImageColor3=S.Accent},aQ)New('TextLabel',{Text=aL,
FontFace=Z.SemiBold,TextSize=15,Position=v(40,0),Size=u(1,-50,1,0)},aQ)local aR=
New('Frame',{Name="Body",Position=v(0,40),Size=w(1,0),AutomaticSize=P,
BackgroundTransparency=1},aP)Y.Place(aL,aP,aQ,aO)return{Frame=aP,Top=aQ,Body=aR}
end local function Bind(aL)local aM=aL.Render aL.Render=function()local aN=av[aL
]if aN then aN()end if aM then aM()end for aO,aP in aD do aP(aL)end end end Y.
Build='c293955'd.LoadFont()Z.Regular=d.Font(Enum.FontWeight.Regular)Z.SemiBold
=d.Font(Enum.FontWeight.SemiBold)an=b.Clean(New('ScreenGui',{Name='Twilight',
ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.
Sibling,DisplayOrder=100},b.GetHui()))ao=New('Frame',{Name="Overlay",Size=w(1,1)
,BackgroundTransparency=1},an)Y.Overlay=ao if _G.__SQ then _G.__SQ(an) end local function Sink(aL)if aL:IsA
'GuiObject'and aL.BackgroundTransparency<1 then aL.Active=true end end an.
ChildAdded:Connect(Sink)ao.ChildAdded:Connect(Sink)Window()aA=New('Frame',{Name=
'Notifications',AnchorPoint=y(0.5,0),Position=u(0.5,0,0,16),Size=u(0,420,1,-32),
BackgroundTransparency=1,ZIndex=30},an)List(aA,8).HorizontalAlignment=Enum.
HorizontalAlignment.Center ap.Build()aq.Build()ar.Build()for aL,aM in c.Order do
local aN=c.Categories[aM]local aO=Y.Page(aM,aM,function(aO)aO.Modules=aN.Modules
Fill(aO)end)if aM=='Settings'then aO.Tab.LayoutOrder=2 aO.Tab.Parent=Y.Window.Right end end
Y.Page('Keybinds','Keyboard',function(_pg)local _col=Column(_pg.Frame,0,true)local _mods={}local _want={AutoBuy=1,JoinPS=1,CarpetSpeed=1,ClickToAp=1,CloneIn=1,DropBrainrot=1,Invisible=1,Menu=1,Reset=1,Teleport=1,['Nearest & Priority']=1}for _,_m in c.Modules do if _want[_m.Name]then _mods[#_mods+1]=_m end end
table.sort(_mods,function(a,b)local x,z=a.Bind~=nil,b.Bind~=nil if x~=z then return x end return a.Name<b.Name end)local _listen
for _i,_m in _mods do local _r=New('Frame',{Size=u(1,-6,0,40),BackgroundColor3=S.Section,BackgroundTransparency=0.7,LayoutOrder=_i},_col)Corner(_r,6)Stroke(_r)
New('TextLabel',{Position=v(14,0),Size=u(1,-130,1,0),Text=(string.gsub(_m.Name,'(%l)(%u)','%1 %2')),FontFace=Z.SemiBold,TextSize=14},_r) local _c=New('TextButton',{AnchorPoint=y(1,0.5),Position=u(1,-10,0.5,0),Size=v(84,26),BackgroundColor3=S.Field,FontFace=Z.SemiBold,TextSize=12,TextColor3=if _m.Bind then S.Text else S.Faint,Text=KeyName(_m.Bind)},_r)Corner(_c,6)
_c.Activated:Connect(function()if _listen then _listen.chip.Text=KeyName(_listen.mod.Bind)end _listen={mod=_m,chip=_c}_c.Text='...'end)end
b.Connect(E.InputBegan,function(_k,_p)local _mb=getgenv().__MBFromInput(_k,_p)if _listen and(_k.UserInputType==Enum.UserInputType.Keyboard or _mb)then local L=_listen _listen=nil if _k.KeyCode~=Enum.KeyCode.Escape then local _nk=if _k.KeyCode==Enum.KeyCode.Backspace then nil else(_mb or _k.KeyCode)L.mod:SetBind(_nk)local r=av[L.mod]if r then r()end end L.chip.Text=KeyName(L.mod.Bind)L.chip.TextColor3=if L.mod.Bind then S.Text else S.Faint end end)table.insert(getgenv().__MBCaps,function(nm)if not _listen then return false end local L=_listen _listen=nil L.mod:SetBind(getgenv().__MBind(nm))local r=av[L.mod]if r then r()end L.chip.Text=KeyName(L.mod.Bind)L.chip.TextColor3=S.Text return true end)end)
table.insert(c.Added,function(aL)Bind(aL)for aM,aN in aD do aN(aL)
end if av[aL]or aL.Hidden then return end for aM,aN in Y.Pages do if aN.Name==aL.Category and
aN.Built and aN.Used then local aO=if aN.Used[1]<=aN.Used[2]then 1 else 2 aN.
Used[aO]+=Estimate(aL)Section(aN.Columns[aO],aL)end end end)q(function()for aL,
aM in c.Modules do Bind(aM)end for aL,aM in c.Modules do for aN,aO in aD do aO(
aM)end end Y.Select(Y.Pages[1])end)function Y.Loaded(aL)local aM=os.clock()b.
LoadedAt=aM p(function()local aN=os.clock()+15 while getgenv().LoadPending and
os.clock()<aN do s(0.1)end local aO=getgenv().LoadedIn getgenv().LoadedIn=nil
local aP=KeyName(c.Modules.Menu and c.Modules.Menu.Bind)local aQ=if aO then n(
[[You loaded in %.1fs, Twilight in %.2fs, press %s to open the menu]],aO,aM-aL,
aP)else n('Ready in %.2fs, press %s to open the menu',aM-aL,aP)do local _sec=aO or(aM-aL)local _f=Instance.new'Frame'_f.Name='LoaderToast'_f.AnchorPoint=Vector2.new(1,1)_f.Position=UDim2.new(1,-14,1,-14)_f.Size=UDim2.fromOffset(200,48)_f.BackgroundColor3=Color3.fromRGB(10,10,12)_f.BorderSizePixel=0 _f.ZIndex=60 _f.Parent=Y.Overlay
local _c=Instance.new'UICorner'_c.CornerRadius=UDim.new(0,14)_c.Parent=_f
local _st=Instance.new'UIStroke'_st.Color=Color3.fromRGB(255,105,180)_st.Thickness=1.5 _st.Parent=_f
local _t=Instance.new'TextLabel'_t.BackgroundTransparency=1 _t.Position=UDim2.fromOffset(14,6)_t.Size=UDim2.new(1,-28,0,20)_t.Font=Enum.Font.GothamBold _t.TextSize=14 _t.TextColor3=Color3.new(1,1,1)_t.TextXAlignment=Enum.TextXAlignment.Left _t.Text='Angelicide Loader'_t.ZIndex=61 _t.Parent=_f
local _u=Instance.new'TextLabel'_u.BackgroundTransparency=1 _u.Position=UDim2.fromOffset(14,26)_u.Size=UDim2.new(1,-28,0,16)_u.Font=Enum.Font.GothamMedium _u.TextSize=12 _u.TextColor3=Color3.fromRGB(255,105,180)_u.TextXAlignment=Enum.TextXAlignment.Left _u.Text=string.format('%.1fs',_sec)_u.ZIndex=61 _u.Parent=_f
task.delay(6,function()_f:Destroy()end)end end)end b.Menu=Y return Y end function a.f()local
aa=a.cache.f if not aa then aa={c=__modImpl()}a.cache.f=aa end return aa.c end
end do local function __modImpl()local aa=task.spawn local ab={}ab.__index=ab
function ab.new()return setmetatable({Callbacks={}},ab)end function ab.Connect(
ac,ad)ac.Callbacks[ad]=true return function()ac.Callbacks[ad]=nil end end
function ab.Fire(ac,...)for ad in ac.Callbacks do aa(ad,...)end end return ab
end function a.g()local aa=a.cache.g if not aa then aa={c=__modImpl()}a.cache.g=
aa end return aa.c end end do local function __modImpl()local aa=a.a()local ab=a
.g()local ac=math.huge local ad=task.spawn local ae=task.wait local af=aa.
Services.Players local ag=aa.LocalPlayer local ah={List={},Added=ab.new(),
Removed=ab.new(),CharacterAdded=ab.new(),Posing=false}local ai={}local aj={}
local ak=35815907 local al=100 local am={}local function Rank(an)local ao=am[an]
if ao then return ao end local ap,aq=pcall(an.GetRankInGroup,an,ak)if not ap
then warn('rank check failed:',aq)return nil end am[an]=aq return aq end local 
function Bind(an,ao)if an.PartsConnection then an.PartsConnection:Disconnect()
end an.Character=ao an.Humanoid=nil an.Root=nil local ap=false local function 
Take(aq)if aq.Name=="Humanoid"and aq:IsA'Humanoid'then an.Humanoid=aq elseif aq.
Name=='HumanoidRootPart'and aq:IsA'BasePart'then an.Root=aq else return end if
not ap and an.Humanoid and an.Root then ap=true ah.CharacterAdded:Fire(an)end
end an.PartsConnection=ao.ChildAdded:Connect(Take)for aq,ar in ao:GetChildren()
do Take(ar)end end local function Add(an)if ah.List[an]then return end local ao=
{Player=an,Local=an==ag}ah.List[an]=ao ao.Connection=an.CharacterAdded:Connect(
function(ap)Bind(ao,ap)end)if an.Character then Bind(ao,an.Character)end if not
ao.Local then ad(Rank,an)end ah.Added:Fire(ao)end local function Remove(an)local
ao=ah.List[an]if not ao then return end ah.List[an]=nil ai[an]=nil aj[an]=nil am
[an]=nil if ao.Connection then ao.Connection:Disconnect()end if ao.
PartsConnection then ao.PartsConnection:Disconnect()end ah.Removed:Fire(ao)end
function ah.Get(an)return ah.List[an]end function ah.Carrying(an)local ao=an:
GetAttribute'Stealing'if ao==nil or ao==false then return nil end local ap=an:
GetAttribute'StealingIndex'return if type(ap)=='string'then ap else''end
function ah.Holding(an)local ao=an.Character return ao and ao:
FindFirstChildOfClass'Tool'end function ah.Closest(an,ao)local ap local aq=ac
for ar,as in ah.List do local at=as.Root if as.Local or not at or not at.Parent
then continue end if ao and not ao(as)then continue end local au=(at.Position-an
).Magnitude if aq>au then ap,aq=as,au end end return ap,aq end function ah.
IsFriend(an)if an==ag then return false end local ao=ai[an]if ao~=nil then
return ao end if not aj[an]then aj[an]=true ad(function()local ap,aq=pcall(ag.
IsFriendsWithAsync,ag,an.UserId)if not ap then warn('friend check failed:',aq)
end ai[an]=ap and aq==true aj[an]=nil end)end return false end function ah.
IsStaff(an)if an==ag then return false end local ao=Rank(an)return ao==nil or ao
>=al end function ah.Character()local an=ag.Character local ao=an and(an:
FindFirstChild'HumanoidRootPart')local ap=an and an:FindFirstChildOfClass
'Humanoid'if not ao or not ap or ap.Health<=0 then return nil,nil,nil end return
an,ao,ap end function ah.Feet()local an,ao,ap=ah.Character()if not an or not ao
or not ap then return 3 end local aq=ac for ar,as in an:GetChildren()do if not
as:IsA'BasePart'or as==ao then continue end local at,au=as.CFrame,as.Size local
av=(math.abs(at.RightVector.Y)*au.X+math.abs(at.UpVector.Y)*au.Y+math.abs(at.
LookVector.Y)*au.Z)*0.5 aq=math.min(aq,at.Position.Y-av)end local ar=ap.
HipHeight+ao.Size.Y*0.5 return if ac>aq then math.max(ar,ao.Position.Y-aq)else
ar end function ah.FindTool(an)local ao=ag.Character local ap=ag:
FindFirstChildOfClass'Backpack'local aq=(ao and ao:FindFirstChild(an))or(ap and
ap:FindFirstChild(an))return if aq and aq:IsA'Tool'then aq else nil end function
ah.Equip(an,ao)local ap,aq,ar=ah.Character()if not ap or not ar then return
false end if an.Parent==ap then return true end ar:EquipTool(an)local as=os.
clock()+(ao or 1)while an.Parent~=ap and os.clock()<as do ae()end return an.
Parent==ap end aa.Connect(af.PlayerAdded,Add)aa.Connect(af.PlayerRemoving,Remove
)for an,ao in af:GetPlayers()do Add(ao)end aa.Clean(function()for an,ao in ah.
List do if ao.Connection then ao.Connection:Disconnect()end end end)return ah
end function a.h()local aa=a.cache.h if not aa then aa={c=__modImpl()}a.cache.h=
aa end return aa.c end end do local function __modImpl()local aa=a.a()local ab=
aa.LocalPlayer local ac={Flying=table.freeze{'Flying Carpet',"Cupid's Wings",
"Witch's Broom",'Waverider',"Santa's Sleigh",'Skeleton Dragon','Flying Bee'},
Prefer=nil,Hold=false}local function Owned(ad,ae)local af=ad:FindFirstChild(ae)
return if af and af:IsA'Tool'then af else nil end function ac.Held(ad)if not ad
then return nil end for ae,af in ac.Flying do local ag=Owned(ad,af)if ag then
return ag end end return nil end function ac.Equip()local ad=ab.Character local
ae=ad and ad:FindFirstChildOfClass'Humanoid'local af=ab:FindFirstChildOfClass
'Backpack'if ac.Hold or not ae or not af or ac.Held(ad)then return false end
local ag=if ac.Prefer then Owned(af,ac.Prefer)else nil for ah,ai in ac.Flying do
ag=ag or Owned(af,ai)end if not ag then return false end ae:EquipTool(ag)return
true end return ac end function a.i()local aa=a.cache.i if not aa then aa={c=
__modImpl()}a.cache.i=aa end return aa.c end end  do local function 
__modImpl()local aa=a.a()local ab=a.b()local ac=a.h()local ad=a.i()local ae=math
.min local af=aa.Services.RunService local ag=aa.LocalPlayer local ah={[Enum.
HumanoidStateType.Physics]=true,[Enum.HumanoidStateType.Ragdoll]=true,[Enum.
HumanoidStateType.FallingDown]=true,[Enum.HumanoidStateType.Freefall]=true,[Enum
.HumanoidStateType.Jumping]=true}local ai local aj local ak local al local am=
false local an=0 local ao=0 local ap=0 local function Flatten(aq)local ar=aq.
AssemblyLinearVelocity aq.AssemblyLinearVelocity=Vector3.new(0,ar.Y,0)end local 
function Busy()local aq=ab.Modules.AutoBuy return aq~=nil and aq.Enabled and aq.
Chasing==true end local function Step()local aq,ar,as=ac.Character()if aq~=al
then al,am,an,ao=aq,false,0,0 end if not aq or not ar or not as or Busy()then
return end local at=as.MoveDirection local au=at.Magnitude>=0.05 local av=ah[as:
GetState()]==true if am and not au then an=os.clock()+0.080000000428 end am=au if os.
clock()<an then Flatten(ar)return end if ac.Carrying(ag)then return end if not
ad.Held(aq)then if ak.Enabled and os.clock()-ap>1 then ap=os.clock()ad.Equip()
end return end if not au then if not av and os.clock()-ao<0.25 then Flatten(ar)
end return end local aw=at.Unit local ax=ar.AssemblyLinearVelocity ar.
AssemblyLinearVelocity=Vector3.new(aw.X*aj.Value,ax.Y,aw.Z*aj.Value)ao=os.clock(
)end ai=ab.Categories.Blatant:CreateModule{Name='CarpetSpeed',Was='GearSpeed',
Tooltip='Faster with a flying gear',Function=function(aq)if not aq then return
end ai:Clean(function()local ar,as=ac.Character()if as then local at=as.
AssemblyLinearVelocity as.AssemblyLinearVelocity=Vector3.new(0,ae(at.Y,0),0)end
end)ai:Clean(af.Heartbeat:Connect(Step))end}aj={Value=140}ak={Enabled=true}return ai end function a.k()local aa=a.cache.k if not aa then aa={c=__modImpl()}a.cache.k=aa
end return aa.c end end  do local function __modImpl()local aa=a.a()local ab=a.b(
)local ac=a.h()local ad=aa.Services.UserInputService local ae=aa.Services.
RunService local af=aa.Services.Workspace local ag=0.35 local ah=50 local ai=
Vector3.new(0,3.5,0)local aj local ak local al=RaycastParams.new()al.FilterType=
Enum.RaycastFilterType.Exclude local function Ceiling(am)local an={am.Parent}for
ao=1,10 do al.FilterDescendantsInstances=an local ap=af:Raycast(am.Position,ai,
al)if not ap then return false end if ap.Instance.CanCollide then return true
end an[#an+1]=ap.Instance end return false end local function Hop()local am,an,
ao=ac.Character()if not an or not ao or Ceiling(an)then return end local ap=an.
AssemblyLinearVelocity local aq=ao.JumpPower local ar=ap.Y*ag+aq*(1-ag)an.
AssemblyLinearVelocity=Vector3.new(ap.X,if aq>ar then aq else ar,ap.Z)end aj=ab.
Categories.Blatant:CreateModule{Name='InfiniteJump',Tooltip='Jump in the air',
Function=function(am)if not am then return end local an=false aj:Clean(ad.
JumpRequest:Connect(function()if not ak.Enabled then Hop()end end))aj:Clean(ad.
InputBegan:Connect(function(ao,ap)if not ap and ao.KeyCode==Enum.KeyCode.Space
then an=true end end))aj:Clean(ad.InputEnded:Connect(function(ao)if ao.KeyCode==
Enum.KeyCode.Space then an=false end end))aj:Clean(ae.Heartbeat:Connect(function
(ao)if not ak.Enabled or not an then return end local ap,aq=ac.Character()if not
aq then return end local ar=aq.AssemblyLinearVelocity local as=if Ceiling(aq)
then af.Gravity*ao else ah aq.AssemblyLinearVelocity=Vector3.new(ar.X,as,ar.Z)
end))end}ak={Enabled=true}return aj end function a.m()local aa=a.cache.m if not aa then aa={c=__modImpl()}
a.cache.m=aa end return aa.c end end do local function __modImpl()local _n=__ANG.net return{Event=_n.Event,Function=_n.Function,Unreliable=_n.Unreliable}end function a.n()local aa=a.cache.n if not aa then aa={c=__modImpl()}a.cache.n=aa end return aa.c end end do local function 
__modImpl()local aa=a.a()local ab=a.b()local ac=a.n()local ad=a.h()local ae=a.i(
)local af=math.abs local ag=math.ceil local ah=math.floor local ai=math.huge
local aj=math.max local ak=math.min local al=math.sqrt local am=task.spawn local
an=task.wait local ao=aa.Services.RunService local ap=aa.Services.Workspace
local aq=aa.Services.Players local ar=aa.LocalPlayer local as=0.7 local at=160
local au=400 local av=0.15 local aw=120 local ax=4 local ay=60 local az=9000
local aA=2.5 local aB=300 local aC=800 local aD=
'75c9466d-e4c0-4b02-b26a-c3615fcc1e42'local aE=0.33552958170573 local aF=
0.23073854446411 local aG=Vector3.new(1,0,1)local aH=Vector3.new(0,-7,0)local aI
={{Min=Vector3.new(15.7,-0.5,-78.5),Max=Vector3.new(86.1,24,-47.3)},{Min=Vector3
.new(10.6,-0.5,-134.9),Max=Vector3.new(108.3,24,-113.7)},{Min=Vector3.new(10.6,-
0.5,-113.7),Max=Vector3.new(108.3,5,-78.5)}}local aJ={Status='idle',Busy=false,
Aborted=false}local aK=RaycastParams.new()aK.FilterType=Enum.RaycastFilterType.
Exclude aK.RespectCanCollide=true aK.IgnoreWater=true local aL=OverlapParams.
new()aL.FilterType=Enum.RaycastFilterType.Exclude aL.RespectCanCollide=true aL.
MaxParts=8 local aM=Instance.new'Part'aM.Anchored=true aM.CanCollide=false aM.
CanQuery=false aM.CanTouch=false local aN=OverlapParams.new()aN.FilterType=Enum.
RaycastFilterType.Include aN.MaxParts=1 local function RefreshFilter()local aO={
}for aP,aQ in aq:GetPlayers()do if aQ.Character then aO[#aO+1]=aQ.Character end
end aK.FilterDescendantsInstances=aO aL.FilterDescendantsInstances=aO local aP,
aQ=ad.Character()local aR=if aQ then aQ.CollisionGroup else'Default'aK.
CollisionGroup=aR aL.CollisionGroup=aR end local function BoxSolid(aO,aP)for aQ,
aR in ap:GetPartBoundsInBox(aO,aP,aL)do local aS=aR.Size if aj(aS.X,aS.Y,aS.Z)<
aw and not aR:IsA'TriangleMeshPart'then return true end aM.CFrame,aM.Size=aO,aP
aN.FilterDescendantsInstances={aR}if#ap:GetPartsInPart(aM,aN)>0 then return true
end end return false end local function BodyVolume()local aO,aP,aQ=ad.Character(
)if not aO or not aP or not aQ then return nil,0 end local aR,aS,aT=0,0,0 for aU
,aV in aO:GetChildren()do if not aV:IsA'BasePart'then continue end local aW=aV.
Position-aP.Position local aX=aV.Size*0.5 aR=aj(aR,al(aW.X*aW.X+aW.Z*aW.Z)+aj(aX
.X,aX.Z))aS=ak(aS,aW.Y-aX.Y)aT=aj(aT,aW.Y+aX.Y)end local aU=aj(aT-aS-0.5,1)
return{Size=Vector3.new(aR*2,aU,aR*2),Offset=Vector3.new(0,aS+0.5+aU*0.5,0)},aQ.
HipHeight+aP.Size.Y*0.5 end local function Distance(aO,aP)local aQ,aR=aO.X-aP.X,
aO.Z-aP.Z return al(aQ*aQ+aR*aR)end local aO={}local function BuildZones()if#aO>
0 then return end local aP=ap:FindFirstChild'Plots'local aQ=if aP then aP:
GetChildren()else{}for aR,aS in aQ do local aT=aS:GetAttribute'Order'==1 and aS:
FindFirstChild'MainRoot'or nil if aT and aT:IsA'BasePart'then for aU,aV in aI do
aO[#aO+1]={Frame=aT.CFrame*CFrame.new((aV.Min+aV.Max)/2),Half=(aV.Max-aV.Min)/2}
end return end end end local function ZoneAt(aP)for aQ,aR in aO do local aS=aR.
Frame:PointToObjectSpace(aP)if af(aS.X)<=aR.Half.X+1.200000000211 and af(aS.Z)<=aR.Half.Z+
1.2 then return aR end end return nil end local function Grounded(aP,aQ,aR)local
aS=aQ-aP local aT=aj(1,ag(aS.Magnitude/aA))for aU=0,aT do local aV=aP+aS*(aU/aT)
local aW=ZoneAt(aV)if aW and aW~=aR then return false end local aX=ap:Raycast(aV
,aH,aK)if not aX or aX.Normal.Y<0.6 then return false end end return true end
local function Sweep(aP,aQ,aR,aS)local aT=(aR-aQ)*aG return aT.Magnitude<0.05 or
ap:Blockcast(CFrame.new(aQ+aP.Offset),aS,aT,aK)==nil end local function Clear(aP
,aQ,aR,aS)return Sweep(aP,aQ,aR,aP.Size)and Grounded(aQ,aR,aS)end local function 
Vis(aP,aQ,aR,aS,aT)local aU={aP,aQ}local aV={}local aW={}local aX={}local aY=0
local aZ=false local a_=aR.Size.X*0.5+as local a0=aR.Size+Vector3.new(1,0,1)
local function Add(a1)if#aU>=at then aZ=true return end for a2,a3 in aU do if
Distance(a3,a1)<1 then return end end local a2=ap:Raycast(a1+Vector3.new(0,3,0),
Vector3.new(0,-20,0),aK)if not a2 or a2.Normal.Y<0.65 then return end local a3=
Vector3.new(a1.X,aj(a2.Position.Y+aS,aP.Y),a1.Z)local a4=ZoneAt(a3)if(a4 and a4
~=aT)or BoxSolid(CFrame.new(a3+aR.Offset),aR.Size)then return end aU[#aU+1]=a3
aX[#aX+1]=#aU end local function Corners(a1,a2)local a3,a4,a5,a6 if af(a1.
UpVector.Y)>0.98 then a3=(a1.RightVector*aG).Unit a4=(a1.LookVector*aG).Unit a5,
a6=a2.X*0.5,a2.Z*0.5 else local a7=a1-a1.Position a3,a4=Vector3.xAxis,Vector3.
zAxis a5=(af(a7.RightVector.X)*a2.X+af(a7.UpVector.X)*a2.Y+af(a7.LookVector.X)*
a2.Z)*0.5 a6=(af(a7.RightVector.Z)*a2.X+af(a7.UpVector.Z)*a2.Y+af(a7.LookVector.
Z)*a2.Z)*0.5 end local a7=Vector3.new(a1.Position.X,aP.Y,a1.Position.Z)for a8,a9
in{-1,1}do for b,ba in{-1,1}do Add(a7+a3*(a9*(a5+a_))+a4*(ba*(a6+a_)))end end
end local function Discover(a1)if aV[a1]or not a1:IsA'BasePart'then return end
aV[a1]=true local a2=a1.Size if aj(a2.X,a2.Y,a2.Z)<aw then Corners(a1.CFrame,a2)
end end local function Edge(a1,a2)local a3=if a2>a1 then a1*4096+a2 else a2*4096
+a1 local a4=aW[a3]if a4~=nil then return not a4 end aY+=1 if au<aY then aZ=true
return false end local a5,a6=aU[a1],aU[a2]local a7=Distance(a5,a6)local a8 if a2
==2 and 3<a7 then local a9=a5+((a6-a5)*aG).Unit*(a7-3)a8=ap:Blockcast(CFrame.
new(a5+aR.Offset),a0,(a9-a5)*aG,aK)or ap:Blockcast(CFrame.new(a9+aR.Offset),aR.
Size,(a6-a9)*aG,aK)elseif a7>=0.05 then a8=ap:Blockcast(CFrame.new(a5+aR.Offset)
,if a2==2 then aR.Size else a0,(a6-a5)*aG,aK)end local a9=nil==a8 and Grounded(
a5,a6,aT)aW[a3]=not a9 if a8 then Discover(a8.Instance)end return a9 end local
a1={[1]=0}local a2={[1]=1}local a3={}local a4={[1]=true}local function Adopt(a5)
local a6,a7=ai for a8 in a3 do local a9=if a8<a5 then a8*4096+a5 else a5*4096+a8
if aW[a9]~=true then local b=a1[a8]+Distance(aU[a8],aU[a5])if b<a6 then a7,a6=a8
,b end end end if a7 and(not a1[a5]or a6<a1[a5])then a1[a5],a2[a5]=a6,a7 a4[a5]=
true end end local function Settle()local a5=aX aX={}for a6,a7 in a5 do Adopt(a7
)end end local a5=os.clock()local a6=false while not aZ and os.clock()-a5<=av do
local a7,a8=ai for a9 in a4 do local b=a1[a9]+Distance(aU[a9],aQ)if a7>b then a8
,a7=a9,b end end if not a8 then break end a4[a8]=nil if a8~=1 and not Edge(a2[a8
],a8)then Settle()local a9={}for b in a3 do a9[#a9+1]=b end table.sort(a9,
function(b,ba)return a1[b]+Distance(aU[b],aU[a8])<a1[ba]+Distance(aU[ba],aU[a8])
end)local b=false for ba,bb in a9 do if Edge(bb,a8)then a1[a8],a2[a8],b=a1[bb]+
Distance(aU[bb],aU[a8]),bb,true break end end Settle()if not b then continue end
end a3[a8]=true if a8==2 then a6=true break end for a9=1,#aU do if not a3[a9]
then local b=a1[a8]+Distance(aU[a8],aU[a9])if not a1[a9]or b<a1[a9]then a1[a9],
a2[a9]=b,a8 a4[a9]=true end end end end if not a6 then return nil end local a7={
}local a8=2 while a8~=1 do table.insert(a7,1,a8)a8=a2[a8]end table.insert(a7,1,1
)local a9={aP}local b=1 while b<#a7 do local ba=#a7 while ba>b+1 and not Edge(a7
[b],a7[ba])do ba-=1 end a9[#a9+1]=aU[a7[ba] ]b=ba end a9[#a9]=aQ return a9 end
local aP={}aP.__index=aP function aP.new()return setmetatable({Items={},Size=0},
aP)end function aP.Push(aQ,aR,aS)aQ.Size+=1 local aT=aQ.Size aQ.Items[aT]={aR,aS
}while aT>1 do local aU=aT//2 if aQ.Items[aU][2]<=aS then break end aQ.Items[aT]
,aQ.Items[aU]=aQ.Items[aU],aQ.Items[aT]aT=aU end end function aP.Pop(aQ)local aR
=aQ.Items[1]aQ.Items[1]=aQ.Items[aQ.Size]aQ.Items[aQ.Size]=nil aQ.Size-=1 local
aS=1 while true do local aT,aU=aS*2,aS*2+1 local aV=aS if aT<=aQ.Size and aQ.
Items[aT][2]<aQ.Items[aV][2]then aV=aT end if aU<=aQ.Size and aQ.Items[aU][2]<aQ
.Items[aV][2]then aV=aU end if aV==aS then break end aQ.Items[aS],aQ.Items[aV]=
aQ.Items[aV],aQ.Items[aS]aS=aV end return aR[1]end local aQ={{1,0},{-1,0},{0,1},
{0,-1},{1,1},{1,-1},{-1,1},{-1,-1}}local function Grid(aR,aS,aT,aU)local aV=aR.Y
local aW,aX=ak(aR.X,aS.X)-ay,aj(aR.X,aS.X)+ay local aY,aZ=ak(aR.Z,aS.Z)-ay,aj(aR
.Z,aS.Z)+ay local a_=ah((aX-aW)/ax)+1 local a0=ah((aZ-aY)/ax)+1 local a1=Vector3
.new(aS.X,aV,aS.Z)local function Key(a2,a3)return a3*a_+a2 end local function 
Point(a2,a3)return Vector3.new(aW+a2*ax,aV,aY+a3*ax)end local a2={}local 
function Free(a3,a4)if a3<0 or a4<0 or a3>=a_ or a0<=a4 then return false end
local a5=Key(a3,a4)local a6=a2[a5]if a6==nil then local a7=Point(a3,a4)local a8=
not BoxSolid(CFrame.new(a7+aT.Offset),aT.Size)and Grounded(a7,a7,aU)a2[a5]=a8
return a8 end return a6 end local a3,a4=ah((aR.X-aW)/ax+0.5),ah((aR.Z-aY)/ax+0.5
)local a5=Key(a3,a4)local a6={[a5]=aR}local a7={[a5]=0}local a8={[a5]=a5}local
a9={}local b=aP.new()b:Push(a5,(a1-aR).Magnitude)local ba=0 local bb=os.clock()
while b.Size>0 and az>ba do local bc=b:Pop()if a9[bc]then continue end local c=
a6[bc]local d=a8[bc]if d~=bc and not Clear(aT,a6[d],c,aU)then local e,f=bc%a_,bc
//a_ local g,h=ai for i,j in aQ do local k=Key(e+j[1],f+j[2])if a9[k]and a7[k]+(
a6[k]-c).Magnitude<g then h,g=k,a7[k]+(a6[k]-c).Magnitude end end if h then a8[
bc],a7[bc]=h,g end end a9[bc]=true ba+=1 if(c-a1).Magnitude<ax*0.75 then local e
={a1}local f=bc while f~=a5 do table.insert(e,1,a6[f])f=a8[f]end table.insert(e,
1,aR)return e end local e,f=bc%a_,bc//a_ if bc==a5 then e,f=a3,a4 end for g,h in
aQ do local i,j=e+h[1],f+h[2]local k=Key(i,j)if a9[k]or not Free(i,j)then
continue end a6[k]=Point(i,j)local l=a8[bc]local m=a7[l]+(a6[l]-a6[k]).Magnitude
if a7[k]==nil or m<a7[k]then a7[k],a8[k]=m,l b:Push(k,m+(a1-a6[k]).Magnitude)end
end if os.clock()-bb>0.02 then an()bb=os.clock()end end return nil end function
aJ.Plan(aR)local aS,aT=ad.Character()local aU,aV=BodyVolume()if not aT or not aU
then return nil end RefreshFilter()BuildZones()local aW=aT.Position local aX=
ZoneAt(aW)local aY=Vector3.new(aR.X,aW.Y,aR.Z)if Clear(aU,aW,aY,aX)then return{
aW,aY}end return Vis(aW,aY,aU,aV,aX)or Grid(aW,aY,aU,aX)end local aR={Character=
nil,Pending=false}local aS=0 local aT local function Ready(aU)local aV=aU:
GetAttribute'CooldownUntil'local aW=aU:GetAttribute'CooldownTime'local aX=os.
clock()if type(aV)=='number'then aS=aj(aS,aX+aV-ap:GetServerTimeNow())end if
type(aW)=='number'and aW>0 then aS=aj(aS,aX+aW)end if aT~=aU then aT=aU aa.
Connect(aU.AttributeChanged,function()Ready(aU)end)end return aX>=aS end local
aU,aV,aW,aX=3,0.35,0.06,0.05 local aY=3 local aZ=0 local a_ local a0=-ai local 
function Grab(a1)ae.Hold=true if ad.Equip(a1,0.5)then return true end ae.Hold=
false return false end local function Missed()aZ=os.clock()+aY ae.Hold=false ae.
Equip()end local function WatchFire(a1,a2)local a3=false local a4={a2.ChildAdded
:Connect(function(a4)if a4.Name=='FlightPower'or a4.Name=='FlightSpin'then a3=
true end end),a1:GetAttributeChangedSignal'CooldownTime':Connect(function()local
a4=a1:GetAttribute'CooldownTime'a3=a3 or(type(a4)=='number'and a4>0)end)}return
function()return a3 or not Ready(a1)end,function()for a5,a6 in a4 do a6:
Disconnect()end end end local function Shoot(a1)local a2=ac.Event(aD)if a2 then
a2:FireServer(aE,a1.Position)return true end local a3=ac.Event'UseItem'if a3
then a3:FireServer(aF)end return a3~=nil end local function FireGrapple()local
a1,a2,a3=ad.Character()local a4=ad.FindTool'Grapple Hook'if not a1 or not a2 or
not a3 or not a4 or not Ready(a4)or os.clock()<aZ or ar:GetAttribute'Stealing'or
not Grab(a4)then return false end local a5,a6=WatchFire(a4,a2)local a7=false for
a8=1,aU do if a4.Parent~=a1 or not Shoot(a2)then break end local a9=os.clock()
repeat ao.Heartbeat:Wait()a7=a5()until a7 or os.clock()-a9>aV or a4.Parent~=a1
if a7 or a4.Parent~=a1 then break end end a6()if not a7 then Missed()return
false end a_,a0=a1,os.clock()an(aW)if a4.Parent~=a1 then ae.Hold=false return
true end a3:UnequipTools()an(aX)ae.Hold=false ae.Equip()return true end function
aJ.Prime()if aR.Character==ar.Character then return true end if aR.Pending then
return false end aR.Pending=true local a1,a2,a3=ad.Character()if a3 and a3.
FloorMaterial~=Enum.Material.Air and FireGrapple()then aR.Character=ar.Character
end aR.Pending=false return aR.Character==ar.Character end local function 
TakeBoost()while aR.Pending do ao.Heartbeat:Wait()end if aR.Character==ar.
Character then aR.Character=nil return true end aR.Pending=true local a2=
FireGrapple()aR.Pending=false return a2 end function aJ.Engage(a2)if a2 then
TakeBoost()return end ae.Equip()TakeBoost()local a3=os.clock()repeat if ae.Held(
ar.Character)then return end ae.Equip()ao.Heartbeat:Wait()until os.clock()-a3>1
end local a2=0.4 local a3=1.5 local function Shot(a4,a5,a6)local a7=ad.FindTool
'Grapple Hook'if not a7 or not Ready(a7)or os.clock()<aZ or aR.Pending or ae.
Hold or ar:GetAttribute'Stealing'or not Grab(a7)then return false end local a8,
a9=WatchFire(a7,a5)local b=false local ba=os.clock()+a2 while not a6()and a7.
Parent==a4 and os.clock()<ba do Shoot(a5)local bb=os.clock()repeat ao.Heartbeat:
Wait()until a8()or a6()or a7.Parent~=a4 or os.clock()-bb>aV or os.clock()>=ba if
a8()then b=true a_,a0=a4,os.clock()break end end a9()if b or a6()then ae.Hold=
false ae.Equip()else Missed()end return b end function aJ.Launch()while aR.
Pending do ao.Heartbeat:Wait()end if aR.Character==ar.Character then aR.
Character=nil end local a4,a5=ad.Character()local a6=false local function Until(
)return if a4 and a_==a4 then a0+a3 else-ai end if a4 and a5 then local function 
Stopped()return a6 end task.spawn(function()local a7=true while not a6 and ar.
Character==a4 and a5.Parent do if not(os.clock()>=Until()and Shot(a4,a5,Stopped)
)and a7 then ae.Equip()end a7=false ao.Heartbeat:Wait()end end)end return
function()return os.clock()<Until()end,function()a6=true end end function aJ.
AwaitEngage()local a4=os.clock()+1.5 while aR.Pending and os.clock()<a4 do ao.
Heartbeat:Wait()end end function aJ.Halt()local a4,a5=ad.Character()if a5 then
local a6=a5.AssemblyLinearVelocity a5.AssemblyLinearVelocity=Vector3.new(0,a6.Y,
0)end end function aJ.Follow(a4,a5)local a6,a7,a8=ad.Character()if not a6 or not
a7 or not a8 then return false,'no character'end local a9=2 local b,ba=os.clock(
),a7.Position local bb,bc=a7.Position,a7.Position while not aJ.Aborted and ar.
Character==a6 and a8.Health>0 do local c=ao.PreSimulation:Wait()local d=(bc-bb)*
aG local e=(a7.Position-bb)*aG if(e-d).Magnitude>aj(8,d.Magnitude*2)or(d.
Magnitude>0.001 and e:Dot(d.Unit)<-2)then aJ.Halt()return false,
'position corrected by server'end if(a7.Position-ba).Magnitude>0.5 then b,ba=os.
clock(),a7.Position elseif os.clock()-b>1 then aJ.Halt()return false,
'movement stalled'end local f=(a4[a9]-a7.Position)*aG while f.Magnitude<=0.6 do
a9+=1 if a9>#a4 then aJ.Halt()return true,'arrived'end f=(a4[a9]-a7.Position)*aG
end a8:Move(Vector3.zero)local g=ak(a5()*c,f.Magnitude)local h=f.Unit*(g/aj(c,
4.166666666666667E-3))a7.AssemblyLinearVelocity=Vector3.new(h.X,a7.
AssemblyLinearVelocity.Y,h.Z)bb,bc=a7.Position,a7.Position+f.Unit*g end return
false,'interrupted'end local function Settled()local a4=ab.Modules.Optimizer
while a4 and a4.Settling do ao.Heartbeat:Wait()end end local a4=Color3.fromRGB(
177,156,255)local a5={}function aJ.ClearPaths()for a6 in a5 do a6()end end local 
function Draw(a6)local a7={}local a8,a9,b=ad.Character()local ba=Vector3.new(0,
if a9 and b then b.HipHeight+a9.Size.Y*0.5-0.25 else 2.8,0)local bb=ap.
CurrentCamera local function Piece(bc,c,d)local e=Instance.new'Part'e.Name=
'Route'e.Shape=d e.Anchored=true e.CanCollide=false e.CanQuery=false e.CanTouch=
false e.CastShadow=false e.Material=Enum.Material.Neon e.Color=a4 e.Transparency
=0.35 e.Size=bc e.CFrame=c e.Parent=bb a7[#a7+1]=e end for bc,c in a6 do local d
=c-ba Piece(Vector3.one*0.9,CFrame.new(d),Enum.PartType.Ball)local e=if a6[bc+1]
then a6[bc+1]-ba else nil if e and(e-d).Magnitude>0.05 then Piece(Vector3.new(
0.35,0.35,(e-d).Magnitude),CFrame.lookAt((d+e)/2,e),Enum.PartType.Block)end end
local function Erase()for bc,c in a7 do c:Destroy()end table.clear(a7)a5[Erase]=
nil end a5[Erase]=true return function()end end aa.Clean(aJ.ClearPaths)aJ.Draw=
Draw function aJ.Walk(a6,a7,a8)if not(a8 and a8.Rush)then Settled()end aJ.Busy,
aJ.Aborted=true,false aJ.ClearPaths()local a9=a8 and a8.Speed or aB local b=a8~=
nil and a8.Show==true local ba=false local bb=true if not a7 and not(a8 and a8.
Engage==false)then am(function()ba=TakeBoost()and bb end)end local bc=0 local 
function Speed()if a7 then return a7 end local c=ar.Character if not ae.Held(c)
and os.clock()>=bc then bc=os.clock()+0.25 am(ae.Equip)end local d,e,f=ad.
Character()if not ae.Held(c)then return if f then f.WalkSpeed else 16 end return
if ba and not(a8 and a8.Cap)then aj(aC,a9)else a9 end local c,e=false,'no path'
for f=1,3 do if aJ.Aborted then e='aborted'break end local g,h=ad.Character()if
h and Distance(h.Position,a6)<0.6 then c,e=true,'arrived'break end aJ.Status=
'planning'local i=aJ.Plan(a6)if not i then e='no path'break end aJ.Status=
'walking'local j=if b then Draw(i)else nil c,e=aJ.Follow(i,Speed)if j then j()
end if c then break end an(0.15)end bb=false aJ.Busy=false aJ.Status=e return c,
e end function aJ.Abort()aJ.Aborted=true end return aJ end function a.o()local
aa=a.cache.o if not aa then aa={c=__modImpl()}a.cache.o=aa end return aa.c end
end do local function __modImpl()
local aa = a.a()
local ab = a.b()
-- ===== INVISIBLE: motor de D3 (clon de HumanoidRootPart + anim trick + shadow) =====
local RunService = aa.Services.RunService
local LP = aa.LocalPlayer
local INVIS_ANIM = "18537363391"
if _G.D3InvisAnimId == nil then _G.D3InvisAnimId = "99304685759272" end
if _G.D3InvisAnimTime == nil then _G.D3InvisAnimTime = 0 end
if _G.D3InvisAnimSpin == nil then _G.D3InvisAnimSpin = false end
local function invisAnimId() return string.match(tostring(_G.D3InvisAnimId), "%d+") or INVIS_ANIM end
local MARK_OK, MARK_STUCK = Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 0, 0)

local mod, depthSlider, rotSlider, autoToggle
local alive = true
local outer = {}

local function getDepth()
	local v = tonumber(depthSlider and depthSlider.Value) or 8.5
	return 0.01 + (math.clamp(v, 0, 8.5) / 10) * 0.19
end
local function getRotation()
	return tonumber(rotSlider and rotSlider.Value) or 180
end

-- ---------------------------------------------------------- anti die (de D3)
local antiDieConns = {}
local lastSafePos = nil
local function preserveState(character)
	local hum = character:FindFirstChildOfClass("Humanoid")
	if not hum then return {} end
	local state = { WalkSpeed = hum.WalkSpeed, JumpPower = hum.JumpPower, Tools = {} }
	for _, tool in pairs(character:GetChildren()) do
		if tool:IsA("Tool") then table.insert(state.Tools, tool:Clone()) end
	end
	return state
end
local function restoreState(character, state)
	local hum = character:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	hum.WalkSpeed = state.WalkSpeed; hum.JumpPower = state.JumpPower
	for _, tool in pairs(state.Tools) do tool.Parent = character end
end
local setupAntiDie
setupAntiDie = function(character)
	for _, c in pairs(antiDieConns) do if c then pcall(function() c:Disconnect() end) end end
	antiDieConns = {}
	if not character then return end
	local hum = character:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	hum.BreakJointsOnDeath = false
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	local ff = Instance.new("ForceField"); ff.Visible = false; ff.Parent = character
	table.insert(antiDieConns, hum:GetPropertyChangedSignal("Health"):Connect(function()
		if _G.AntiDieDisabled then return end
		if hum.Health <= 0 then hum.Health = hum.MaxHealth end
	end))
	table.insert(antiDieConns, hum.Died:Connect(function()
		if _G.AntiDieDisabled then return end
		task.wait(0.1)
		local state = preserveState(character)
		local newHum = Instance.new("Humanoid")
		newHum.Name = hum.Name; newHum.Parent = character
		newHum.Health = newHum.MaxHealth
		restoreState(character, state)
		workspace.CurrentCamera.CameraSubject = newHum
		hum:Destroy(); task.wait(0.1); setupAntiDie(character)
	end))
	local root = character:FindFirstChild("HumanoidRootPart")
	if root then
		lastSafePos = root.Position
		table.insert(antiDieConns, RunService.Heartbeat:Connect(function()
			if _G.AntiDieDisabled then return end
			if not root or not root.Parent then return end
			local pos = root.Position
			if _G._isTpMoving or _G.isCloning or _G.D3FlightActive or _G.D3Flinging then
				lastSafePos = pos
				return
			end
			if pos.Y < -500 and lastSafePos then
				root.CFrame = CFrame.new(lastSafePos)
				_G.InvisVoidSaves = (tonumber(_G.InvisVoidSaves) or 0) + 1
			else
				lastSafePos = pos
			end
		end))
	end
end
local function teardownAntiDie()
	for _, c in pairs(antiDieConns) do if c then pcall(function() c:Disconnect() end) end end
	antiDieConns = {}
	local char = LP.Character
	if char then
		local ff = char:FindFirstChildOfClass("ForceField")
		if ff then ff:Destroy() end
	end
end

-- ---------------------------------------------------------- estado
local semiIsActive          = false
local autoStarted           = false   -- encendido por "Auto on steal" (se apaga al terminar el robo)
local syncing               = false   -- el modulo cambia su propio Toggle
local invisStealConnections = {}
local invisHRPIndicator     = nil
local invisAnimTrack        = nil
local invisOldHRP           = nil
local invisClone            = nil
local invisChar             = nil
local invisHipHeight        = nil
local invisIsStuck          = false
local invisStealStopPending = false

local startInvisSteal, stopInvisSteal

-- apaga el invis y deja el Toggle del modulo en OFF
local function fullOff()
	autoStarted = false
	stopInvisSteal()
	if mod and mod.Enabled then
		syncing = true
		pcall(mod.Toggle, mod, false)
		syncing = false
	end
end

stopInvisSteal = function()
	if not semiIsActive and not invisOldHRP then return end
	semiIsActive = false; invisIsStuck = false
	_G.D3InvisActive = false
	_G.__D3BodyShowUntil = os.clock() + 6
	do
		-- el juego recrea "DoubleRig" (copia del cuerpo en la posicion del servidor, inclinada) al apagar: eliminarla
		local pf0 = workspace:FindFirstChild(LP.Name)
		local function _killDouble(pf)
			if not pf then return end
			for _, n in ipairs({ "DoubleRig", "Constraints" }) do
				local o = pf:FindFirstChild(n)
				if o then pcall(function() o:Destroy() end) end
			end
		end
		task.spawn(function()
			local tEnd = os.clock() + 3
			local conn, connFor
			while os.clock() < tEnd do
				local pf = workspace:FindFirstChild(LP.Name)
				if not (_G.D3FlightActive or _G.isCloning or _G._isTpMoving) then _killDouble(pf) end
				if pf and pf ~= connFor then
					if conn then pcall(function() conn:Disconnect() end) end
					connFor = pf
					conn = pf.ChildAdded:Connect(function(ch)
						if (ch.Name == "DoubleRig" or ch.Name == "Constraints") and not (_G.D3FlightActive or _G.isCloning or _G._isTpMoving) then task.defer(function() pcall(function() ch:Destroy() end) end) end
					end)
				end
				task.wait(0.05)
			end
			if conn then pcall(function() conn:Disconnect() end) end
		end)
	end
	teardownAntiDie()
	if invisHRPIndicator then pcall(function() invisHRPIndicator:Destroy() end); invisHRPIndicator = nil end
	if invisAnimTrack then
		pcall(function() invisAnimTrack:Stop() end)
		pcall(function() invisAnimTrack:Destroy() end)
		invisAnimTrack = nil
	end
	for _, c in ipairs(invisStealConnections) do pcall(function() c:Disconnect() end) end
	invisStealConnections = {}
	local _char = LP.Character
	local _hum  = _char and _char:FindFirstChildOfClass("Humanoid")
	if invisOldHRP and invisOldHRP.Parent and _char and _hum and _char == invisChar then
		local visPos = (invisClone and invisClone.Parent and invisClone.CFrame)
			or (_char:FindFirstChild("UpperTorso") and _char.UpperTorso.CFrame)
			or (_char:FindFirstChild("Torso") and _char.Torso.CFrame)
			or invisOldHRP.CFrame
		local tempParent = Instance.new("Model"); tempParent.Parent = game
		_char.Parent = tempParent
		invisOldHRP.Parent = _char
		_char.PrimaryPart = invisOldHRP
		_char.Parent = workspace
		invisOldHRP.CanCollide = true
		for _, v in pairs(_char:GetDescendants()) do
			if (v:IsA("Weld") or v:IsA("Motor6D") or v:IsA("WeldConstraint")) and invisClone then
				if v.Part0 == invisClone then pcall(function() v.Part0 = invisOldHRP end) end
				if v.Part1 == invisClone then pcall(function() v.Part1 = invisOldHRP end) end
			end
		end
		if invisClone then pcall(function() invisClone:Destroy() end); invisClone = nil end
		local here = invisOldHRP.Position
		local okPos = typeof(visPos) == "CFrame"
		if okPos then
			local p = visPos.Position
			if p.Magnitude < 5 then okPos = false end
			if (p - here).Magnitude > (tonumber(_G.InvisRestoreMax) or 250) then okPos = false end
		end
		_G.InvisRestoreDiag = okPos and "restored to clone position"
			or "clone position rejected, stayed put"
		if okPos then pcall(function() invisOldHRP.CFrame = visPos end) end
		pcall(function()
			for _, bp in ipairs(_char:GetDescendants()) do
				if bp:IsA("BasePart") then
					bp.AssemblyLinearVelocity = Vector3.zero
					bp.AssemblyAngularVelocity = Vector3.zero
				end
			end
		end)
		do
			-- reasegura el restore: el HRP real vuelve a la posicion del clon y derecho
			local _fixPos = okPos and visPos.Position or nil
			task.spawn(function()
				for i = 1, 24 do
					task.wait()
					local c = LP.Character
					local rr = c and c:FindFirstChild("HumanoidRootPart")
					if not rr or c ~= _char or _G.D3FlightActive or _G.isCloning then break end
					local cf = rr.CFrame
					local bad = false
					if cf.UpVector.Y < 0.9 then
						local lv = cf.LookVector
						local flat = Vector3.new(lv.X, 0, lv.Z)
						if flat.Magnitude < 0.05 then flat = Vector3.new(0, 0, -1) end
						cf = CFrame.new(cf.Position, cf.Position + flat.Unit)
						bad = true
					end
					if _fixPos and i <= 6 and not _G.D3FlightActive and not _G.isCloning and not _G._isTpMoving and not _G.__AngelicideVelFlying and (cf.Position - _fixPos).Magnitude > 6 then
						cf = CFrame.new(_fixPos) * (cf - cf.Position)
						bad = true
					end
					if bad then
						pcall(function()
							rr.CFrame = cf
							rr.AssemblyLinearVelocity = Vector3.zero
							rr.AssemblyAngularVelocity = Vector3.zero
						end)
					end
				end
			end)
		end
		pcall(function() _hum.HipHeight = invisHipHeight or 0 end)
		pcall(function() workspace.CurrentCamera.CameraSubject = _hum end)
		tempParent:Destroy()
	elseif invisOldHRP and _char ~= invisChar then
		pcall(function() invisOldHRP:Destroy() end)
		if invisClone then pcall(function() invisClone:Destroy() end) end
	end
	invisOldHRP = nil; invisClone = nil; invisChar = nil
	do
		local char = LP.Character
		local hum  = char and char:FindFirstChildOfClass("Humanoid")
		local hrp  = char and char:FindFirstChild("HumanoidRootPart")
		for _, holder in ipairs({ char, LP:FindFirstChild("Backpack") }) do
			if holder then
				for _, p in ipairs(holder:GetDescendants()) do
					if p:IsA("BasePart") then pcall(function() p.LocalTransparencyModifier = 0 end) end
				end
			end
		end
		task.spawn(function()
			for _ = 1, 10 do
				local ch = LP.Character
				local h  = ch and ch:FindFirstChildOfClass("Humanoid")
				if ch then
					local animator = h and h:FindFirstChildOfClass("Animator")
					if animator then
						for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
							if tr.Animation and tr.Animation.AnimationId:find(invisAnimId(), 1, true) then pcall(function() tr:Stop(0) end) end
						end
					end
					for _, p in ipairs(ch:GetDescendants()) do
						if p:IsA("BasePart") then
							if p.Name == "HumanoidRootPart" or p.Name:find("HITBOX") or p.Name:find("Hitbox") then
								if p.Transparency < 1 then pcall(function() p.Transparency = 1 end) end
								if p.LocalTransparencyModifier ~= 0 then pcall(function() p.LocalTransparencyModifier = 0 end) end
							else
								if p.LocalTransparencyModifier ~= 0 then pcall(function() p.LocalTransparencyModifier = 0 end) end
								if p.Transparency >= 0.9 then pcall(function() p.Transparency = 0 end) end
							end
						elseif p:IsA("Motor6D") then
							pcall(function() p.Transform = CFrame.new() end)
						end
					end
				end
				task.wait(0.08)
			end
		end)
		if hrp then
			pcall(function() hrp.Anchored = false end)
			local lv = hrp.CFrame.LookVector
			local flat = Vector3.new(lv.X, 0, lv.Z)
			if flat.Magnitude > 0.05 then
				pcall(function() hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + flat.Unit) end)
			else
				pcall(function() hrp.CFrame = CFrame.new(hrp.Position) end)
			end
		end
		if hum then
			pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
			pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true) end)
			pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true) end)
			pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true) end)
			pcall(function() hum.PlatformStand = false end)
			pcall(function() hum.AutoRotate = true end)
			local animator = hum:FindFirstChildOfClass("Animator")
			if animator then
				for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do pcall(function() tr:Stop(0) end) end
			end
			pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
			pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
			pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
			local animate = char:FindFirstChild("Animate")
			if animate and (animate:IsA("LocalScript") or animate:IsA("Script")) then
				task.delay(0.05, function()
					if not (animate and animate.Parent) then return end
					task.delay(0.06, function()
						local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
						if h then
							pcall(function() h:ChangeState(Enum.HumanoidStateType.Landed) end)
							pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end)
							pcall(function() h:Move(Vector3.zero, true) end)
						end
					end)
				end)
			end
		end
		pcall(function()
			local pm = LP:FindFirstChild("PlayerScripts")
			if pm then pm = pm:FindFirstChild("PlayerModule") end
			if pm then require(pm):GetControls():Enable() end
		end)
	end
end

-- byAuto = true: solo si estas robando (como D3 con InvisRequireSteal)
startInvisSteal = function(byAuto)
	if semiIsActive then return true end
	if byAuto and _G.D3InvisRequireSteal ~= false and LP:GetAttribute("Stealing") ~= true then
		_G.D3InvisStartDiag = "not stealing, invis refused"
		return false
	end
	if not LP.Character or not LP.Character:FindFirstChild("Humanoid") then return false end
	local char = LP.Character; local hum = char.Humanoid
	if hum.Health <= 0 then return false end
	setupAntiDie(char)
	local playerFolder = workspace:FindFirstChild(LP.Name)
	if playerFolder then
		local doubleRig = playerFolder:FindFirstChild("DoubleRig")
		if doubleRig then doubleRig:Destroy() end
		local constraints = playerFolder:FindFirstChild("Constraints")
		if constraints then constraints:Destroy() end
		local folderConn = playerFolder.ChildAdded:Connect(function(child)
			if child.Name == "DoubleRig" or child.Name == "Constraints" then child:Destroy() end
		end)
		table.insert(invisStealConnections, folderConn)
	end
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	invisHipHeight = hum.HipHeight
	invisOldHRP = char:FindFirstChild("HumanoidRootPart")
	if not invisOldHRP or not invisOldHRP.Parent then teardownAntiDie(); return false end
	local tempParent = Instance.new("Model"); tempParent.Parent = game
	char.Parent = tempParent
	invisClone = invisOldHRP:Clone(); invisClone.Parent = char
	invisOldHRP.Parent = workspace.CurrentCamera
	invisClone.CFrame = invisOldHRP.CFrame
	char.PrimaryPart = invisClone
	char.Parent = workspace
	for _, v in pairs(char:GetDescendants()) do
		if v:IsA("Weld") or v:IsA("Motor6D") then
			if v.Part0 == invisOldHRP then v.Part0 = invisClone end
			if v.Part1 == invisOldHRP then v.Part1 = invisClone end
		end
	end
	tempParent:Destroy()
	invisChar = char
	semiIsActive = true
	_G.D3InvisActive = true
	local function playAnimTrick()
		if char and char:FindFirstChild("Humanoid") and hum.Health > 0 then
			local anim = Instance.new("Animation")
			anim.AnimationId = "http://www.roblox.com/asset/?id=" .. invisAnimId()
			local animator = hum:FindFirstChild("Animator") or Instance.new("Animator", hum)
			invisAnimTrack = animator:LoadAnimation(anim)
			invisAnimTrack.Priority = Enum.AnimationPriority.Action4
			invisAnimTrack.Looped = true
			invisAnimTrack:Play(0, 1, 0); anim:Destroy()
			local animStoppedConn = invisAnimTrack.Stopped:Connect(function()
				if semiIsActive then playAnimTrick() end
			end)
			table.insert(invisStealConnections, animStoppedConn)
			task.delay(0, function()
				if invisAnimTrack then
					invisAnimTrack.TimePosition = tonumber(_G.D3InvisAnimTime) or 0
					if _G.D3InvisAnimSpin == true then
						task.delay(0.1, function()
							if invisAnimTrack then invisAnimTrack:AdjustSpeed(math.huge) end
						end)
					end
				end
			end)
		end
	end
	playAnimTrick()
	local hideAt = os.clock() + (tonumber(_G.D3InvisAnimShow) or 0.4)
	local shadow, shadowAnimator, shadowPairs = nil, nil, nil
	local mirror, mirrorSeen, mirrorFrame = {}, {}, 0
	local function bodyPart(p)
		return p ~= nil and p:IsA("BasePart") and p.Parent == char
	end
	local function dropShadow()
		for _, st in pairs(mirror) do pcall(function() st:Stop(0) end) end
		mirror, mirrorSeen = {}, {}
		if shadow then pcall(function() shadow:Destroy() end) end
		shadow, shadowAnimator, shadowPairs = nil, nil, nil
	end
	local function buildShadow()
		local model = Instance.new("Model")
		model.Name = "D3InvisShadow"
		local parts = {}
		local function shadowPart(real)
			if not real then return nil end
			local sp = parts[real.Name]
			if sp then return sp end
			sp = Instance.new("Part")
			sp.Name = real.Name
			sp.Size = real.Size
			sp.CFrame = real.CFrame
			sp.Transparency = 1
			sp.CanCollide = false
			sp.CanQuery = false
			sp.CanTouch = false
			sp.CastShadow = false
			sp.Massless = true
			sp.Anchored = real.Name == "HumanoidRootPart"
			sp.Parent = model
			parts[real.Name] = sp
			return sp
		end
		local function shadowAtt(real)
			local sp = real and shadowPart(real.Parent)
			if not sp then return nil end
			local at = sp:FindFirstChild(real.Name)
			if not at then
				at = Instance.new("Attachment")
				at.Name = real.Name
				at.CFrame = real.CFrame
				at.Parent = sp
			end
			return at
		end
		local pairsOut, m6, ac = {}, 0, 0
		for _, j in ipairs(char:GetDescendants()) do
			local sj
			if j:IsA("Motor6D") and bodyPart(j.Part1) and j.Part0 then
				sj = Instance.new("Motor6D")
				sj.Part0 = shadowPart(j.Part0)
				sj.Part1 = shadowPart(j.Part1)
				sj.C0, sj.C1 = j.C0, j.C1
				sj.Parent = sj.Part1
				m6 = m6 + 1
			elseif j:IsA("AnimationConstraint") and j.IsKinematic and j.Attachment0 and j.Attachment1
				and bodyPart(j.Attachment1.Parent) then
				local a0, a1 = shadowAtt(j.Attachment0), shadowAtt(j.Attachment1)
				if a0 and a1 then
					sj = Instance.new("AnimationConstraint")
					sj.Attachment0, sj.Attachment1 = a0, a1
					sj.IsKinematic = true
					sj.Parent = a1.Parent
					ac = ac + 1
				end
			end
			if sj then
				sj.Name = j.Name
				pairsOut[#pairsOut + 1] = { j, sj }
			end
		end
		local ctl = Instance.new("AnimationController")
		ctl.Parent = model
		local an = Instance.new("Animator")
		pcall(function() an.PreferLodEnabled = false end)
		an.Parent = ctl
		model.PrimaryPart = parts.HumanoidRootPart
		model.Parent = workspace.CurrentCamera
		shadow, shadowAnimator, shadowPairs = model, an, pairsOut
		_G.D3InvisHideDiag = ("hiding invis anim on %d Motor6D + %d AnimationConstraint"):format(m6, ac)
	end
	local syncConn = (RunService.PreAnimation or RunService.RenderStepped):Connect(function()
		if not shadowAnimator then return end
		local real = hum:FindFirstChildOfClass("Animator")
		if not real then return end
		local root, sroot = char.PrimaryPart, shadow and shadow.PrimaryPart
		if root and sroot then sroot.CFrame = root.CFrame end
		mirrorFrame = mirrorFrame + 1
		for _, t in ipairs(real:GetPlayingAnimationTracks()) do
			local id = t ~= invisAnimTrack and t.Animation and t.Animation.AnimationId or ""
			if id ~= "" and not string.find(id, invisAnimId(), 1, true) then
				local st = mirror[t]
				if not st then
					local an2 = Instance.new("Animation")
					an2.AnimationId = id
					local ok, r = pcall(function() return shadowAnimator:LoadAnimation(an2) end)
					an2:Destroy()
					if ok and r then
						st = r
						st.Priority = t.Priority
						st.Looped = t.Looped
						st:Play(0, t.WeightCurrent, t.Speed)
						mirror[t] = st
					end
				end
				if st then
					mirrorSeen[t] = mirrorFrame
					st:AdjustWeight(t.WeightCurrent, 0)
					st:AdjustSpeed(t.Speed)
					st.TimePosition = t.TimePosition
				end
			end
		end
		for t, st in pairs(mirror) do
			if mirrorSeen[t] ~= mirrorFrame then
				pcall(function() st:Stop(0); st:Destroy() end)
				mirror[t] = nil
				mirrorSeen[t] = nil
			end
		end
	end)
	local hideConn = RunService.PreSimulation:Connect(function()
		if _G.D3InvisHideAnim == false or os.clock() < hideAt then return end
		if not shadowPairs then buildShadow() end
		local stale = false
		for _, pr in ipairs(shadowPairs) do
			if pr[1].Parent then pr[1].Transform = pr[2].Transform else stale = true end
		end
		if stale then dropShadow() end
	end)
	table.insert(invisStealConnections, syncConn)
	table.insert(invisStealConnections, hideConn)
	table.insert(invisStealConnections, { Disconnect = dropShadow })
	local healthConn = RunService.Heartbeat:Connect(function()
		if _G.AntiDieDisabled then return end
		if char and char:FindFirstChild("Humanoid") then
			local h = char.Humanoid
			h.Health = h.MaxHealth
			h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			local state = h:GetState()
			if state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll then
				h:ChangeState(Enum.HumanoidStateType.Running)
			end
		end
	end)
	table.insert(invisStealConnections, healthConn)
	invisHRPIndicator = Instance.new("Part")
	invisHRPIndicator.Name = "RootMark"
	invisHRPIndicator.Shape = Enum.PartType.Ball
	invisHRPIndicator.Size = Vector3.new(1.5, 1.5, 1.5)
	invisHRPIndicator.Color = MARK_OK
	invisHRPIndicator.Material = Enum.Material.Neon
	invisHRPIndicator.Transparency = 1
	invisHRPIndicator.CanCollide = false
	invisHRPIndicator.CanQuery = false
	invisHRPIndicator.CanTouch = false
	invisHRPIndicator.Anchored = true
	invisHRPIndicator.CastShadow = false
	invisHRPIndicator.Parent = workspace.CurrentCamera
	local lastTargetPos = nil; local graceFrames = 60
	local placedCF, placedVel = nil, nil
	local lastVelT, lastVelV = os.clock(), Vector3.zero
	local posConn = RunService.PreSimulation:Connect(function()
		if char and char:FindFirstChild("Humanoid") and hum.Health > 0 and invisOldHRP then
			local root = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
			if root then
				if graceFrames > 0 then
					graceFrames = graceFrames - 1
				elseif not invisIsStuck and lastTargetPos then
					local actualPos = invisOldHRP.Position
					local expect = lastTargetPos + lastVelV * math.min(os.clock() - lastVelT, 0.1)
					local distance = (actualPos - expect).Magnitude
					local limit = (tonumber(_G.InvisStuckDist) or 2.25) + lastVelV.Magnitude * 0.05
					if distance > limit and not _G.__SXE_VelFlying and not _G.isCloning then
						invisIsStuck = true
						if invisHRPIndicator then invisHRPIndicator.Color = MARK_STUCK end
						if _G.D3InvisAutoFix ~= false and not invisStealStopPending then
							task.spawn(function()
								invisStealStopPending = true
								local wasAuto = autoStarted
								stopInvisSteal()
								task.wait(0.5)
								invisStealStopPending = false
								if alive and not semiIsActive and mod and mod.Enabled then
									startInvisSteal(wasAuto)
								end
							end)
						end
					end
				end
				if not (invisOldHRP and invisOldHRP.Parent and root) then return end
				local cf = root.CFrame
					- Vector3.new(0, hum.HipHeight + (root.Size.Y / 2) - 1 + getDepth(), 0)
				invisOldHRP.CFrame = cf * CFrame.Angles(math.rad(getRotation()), 0, 0)
				invisOldHRP.Velocity = root.Velocity
				invisOldHRP.CanCollide = false
				if invisOldHRP.Parent ~= workspace.CurrentCamera then
					invisOldHRP.Parent = workspace.CurrentCamera
				end
				lastTargetPos = cf.Position
				lastVelT, lastVelV = os.clock(), root.AssemblyLinearVelocity
				placedCF, placedVel = invisOldHRP.CFrame, root.Velocity
				if invisHRPIndicator then
					invisHRPIndicator.Position = invisOldHRP.Position
					invisHRPIndicator.Color = invisIsStuck and MARK_STUCK or MARK_OK
				end
			end
		end
	end)
	table.insert(invisStealConnections, posConn)
	local flingConn = RunService.PostSimulation:Connect(function(dt)
		local cf0, v0 = placedCF, placedVel
		placedCF = nil
		if _G.D3InvisFlingGuard == false or not (cf0 and v0) then return end
		if not (invisOldHRP and invisOldHRP.Parent) then return end
		local step = tonumber(dt) or 0
		local fall = Vector3.new(0, -workspace.Gravity * step, 0)
		local kick = (invisOldHRP.Velocity - (v0 + fall)).Magnitude
		local spin = invisOldHRP.AssemblyAngularVelocity.Magnitude
		if kick <= (tonumber(_G.InvisFlingSpeed) or 80) and spin <= (tonumber(_G.InvisFlingSpin) or 40) then return end
		invisOldHRP.CFrame = cf0 + v0 * step
		invisOldHRP.Velocity = v0
		invisOldHRP.AssemblyAngularVelocity = Vector3.zero
		_G.D3InvisFlingStops = (tonumber(_G.D3InvisFlingStops) or 0) + 1
	end)
	table.insert(invisStealConnections, flingConn)
	local noCol, noColList, noColAt = {}, {}, 0
	local function noColScan()
		local list, seen = {}, {}
		local function add(p)
			if p and not seen[p] and p ~= invisClone and p ~= invisOldHRP
				and p:IsA("BasePart") and not p.Anchored then
				seen[p] = true
				list[#list + 1] = p
			end
		end
		if invisOldHRP and invisOldHRP.Parent then
			local ok, got = pcall(function() return invisOldHRP:GetConnectedParts(true) end)
			if ok and type(got) == "table" then
				local free = true
				for _, p in ipairs(got) do
					if p.Anchored then free = false break end
				end
				if free then
					for _, p in ipairs(got) do add(p) end
				end
			end
		end
		for _, p in ipairs(char:GetDescendants()) do add(p) end
		noColList = list
	end
	local function noColApply()
		if _G.D3InvisNoCollide == false then return end
		local now = os.clock()
		if now - noColAt >= 0.25 then
			noColAt = now
			noColScan()
		end
		for _, p in ipairs(noColList) do
			if p.Parent and p.CanCollide then
				noCol[p] = true
				p.CanCollide = false
			end
		end
	end
	pcall(noColApply)
	local noColConn = RunService.PreSimulation:Connect(function() pcall(noColApply) end)
	table.insert(invisStealConnections, noColConn)
	table.insert(invisStealConnections, { Disconnect = function()
		for p in pairs(noCol) do
			if p.Parent and not p.CanCollide then pcall(function() p.CanCollide = true end) end
		end
		noCol = {}
	end })
	local charConn = LP.CharacterAdded:Connect(function()
		fullOff()
	end)
	table.insert(invisStealConnections, charConn)
	return true
end

-- ---------------------------------------------------------- barrido de tools / forcefield
outer[#outer + 1] = RunService.RenderStepped:Connect(function()
	if semiIsActive or os.clock() > (_G.__D3BodyShowUntil or 0) then return end
	local ch = LP.Character
	if not ch then return end
	for _, c in ipairs(ch:GetChildren()) do
		if c:IsA("BasePart") then
			if c.Name ~= "HumanoidRootPart" and c.LocalTransparencyModifier ~= 0 then c.LocalTransparencyModifier = 0 end
		elseif not c:IsA("Tool") then
			for _, d in ipairs(c:GetDescendants()) do
				if d:IsA("BasePart") and d.LocalTransparencyModifier ~= 0 then d.LocalTransparencyModifier = 0 end
			end
		end
	end
end)

local sweepAt = 0
outer[#outer + 1] = RunService.Heartbeat:Connect(function()
	if not semiIsActive then return end
	local now = os.clock()
	if now - sweepAt < (tonumber(_G.InvisSweepGap) or 0.2) then return end
	sweepAt = now
	local ch = LP.Character
	if not ch then return end
	for _, c in ipairs(ch:GetChildren()) do
		if c:IsA("Tool") then
			for _, d in ipairs(c:GetDescendants()) do
				if d:IsA("BasePart") and d.LocalTransparencyModifier ~= 1 then
					d.LocalTransparencyModifier = 1
				end
			end
		elseif c:IsA("ForceField") and c.Visible then
			c.Visible = false
		end
	end
end)

-- ---------------------------------------------------------- auto on steal (D3 "Auto Invis")
do
	local stealWasActive = false
	local autoWas = false
	local noStealSince = nil
	outer[#outer + 1] = RunService.Heartbeat:Connect(function()
		local auto = autoToggle ~= nil and autoToggle.Enabled == true
		if autoWas and not auto then
			stealWasActive = false
			if semiIsActive and autoStarted then fullOff() end
		end
		autoWas = auto
		local stealingNow = LP:GetAttribute("Stealing") == true
		-- invis must never stay on outside of a steal (drop, reset, death, steal ended):
		-- applies to the auto mode, however the invis was started
		if semiIsActive and _G.D3InvisRequireSteal ~= false and (autoStarted or auto) then
			local _ch = LP.Character
			local _hm = _ch and _ch:FindFirstChildOfClass("Humanoid")
			if _hm and _hm.Health <= 0 then
				noStealSince = nil
				fullOff()
				_G.D3InvisStartDiag = "dead, invis off"
			elseif not stealingNow then
				noStealSince = noStealSince or os.clock()
				if os.clock() - noStealSince >= (tonumber(_G.D3InvisOffGrace) or 0.05) then
					noStealSince = nil
					fullOff()
					_G.D3InvisStartDiag = "steal ended, invis off"
				end
			else
				noStealSince = nil
			end
		else
			noStealSince = nil
		end
		if not auto then return end
		if stealingNow and not stealWasActive then
			stealWasActive = true
			task.delay(0.3, function()
				if alive and LP:GetAttribute("Stealing") == true and not semiIsActive then
					if startInvisSteal(true) then
						autoStarted = true
						if mod and not mod.Enabled then
							syncing = true
							pcall(mod.Toggle, mod, true)
							syncing = false
						end
					end
				end
			end)
		elseif not stealingNow and stealWasActive then
			stealWasActive = false
			if semiIsActive and autoStarted then fullOff() end
		end
	end)
end

_G.InvisStop = stopInvisSteal
_G.InvisActive = function() return semiIsActive end
_G.D3InvisActive = false

mod = ab.Categories.Blatant:CreateModule{Name = "Invisible", Fresh = true, Tooltip = "Hides you from other players",
	Function = function(on)
		if syncing then return end
		if on then
			autoStarted = false
			if not startInvisSteal(false) then
				task.defer(function()
					if mod.Enabled then
						syncing = true
						pcall(mod.Toggle, mod, false)
						syncing = false
					end
				end)
			end
		else
			autoStarted = false
			stopInvisSteal()
		end
	end}
depthSlider = mod:CreateSlider{Name = "Depth", Min = 0, Max = 8.5, Default = 8.5, Step = 0.1}
rotSlider = mod:CreateSlider{Name = "Rotation", Min = 180, Max = 360, Default = 220}
autoToggle = mod:CreateToggle{Name = "Auto on steal", Default = true, Tooltip = "Turns on while stealing"}

aa.Connect(LP.CharacterAdded, function()
	if semiIsActive or (mod and mod.Enabled) then fullOff() end
end)
aa.Connect(LP.CharacterRemoving, function()
	if semiIsActive or (mod and mod.Enabled) then fullOff() end
end)
aa.Connect(LP:GetAttributeChangedSignal("Stealing"), function()
	if semiIsActive and _G.D3InvisRequireSteal ~= false and LP:GetAttribute("Stealing") ~= true
		and (autoStarted or (autoToggle ~= nil and autoToggle.Enabled == true)) then
		task.delay(tonumber(_G.D3InvisOffGrace) or 0.05, function()
			if semiIsActive and LP:GetAttribute("Stealing") ~= true then fullOff() end
		end)
	end
end)
aa.Clean(function()
	alive = false
	if semiIsActive then pcall(stopInvisSteal) end
	teardownAntiDie()
	for _, c in ipairs(outer) do pcall(function() c:Disconnect() end) end
end)
return mod end function a.p()local aa=a.cache.p if not aa then aa=
{c=__modImpl()}a.cache.p=aa end return aa.c end end do local function __modImpl(
)local aa=a.a()local ab=a.b()local ac=a.h()local ad=string.find local ae=aa.
Services.RunService local af=aa.Services.Workspace local ag=20 local ah local ai
={}local function Collidable(aj)local ak={}for al,am in aj:GetDescendants()do if
am:IsA'BasePart'and am.CanCollide then ak[#ak+1]=am end end return ak end local 
function Add(aj)ai[aj]={}end local function Clone(aj)if aj:IsA'Model'and ad(aj.
Name,'^%d+_Clone$')then Add(aj)end end local function Character(aj)local ak=aj.
Character if not aj.Local and ak then Add(ak)end end local function Step()local
aj,ak=ac.Character()if not ak then return end local al=ak.Position for am,an in
ai do if not am.Parent then ai[am]=nil continue end if(am:GetPivot().Position-al
).Magnitude>ag then continue end if#an==0 then an=Collidable(am)ai[am]=an end
for ao,ap in an do if ap.CanCollide then ap.CanCollide=false end end end end ah=
ab.Categories.Blatant:CreateModule{Name='NoCollide',Tooltip=
'Walk through players',Function=function(aj)if not aj then return end ah:Clean(
function()table.clear(ai)end)for ak,al in ac.List do Character(al)end for ak,al
in af:GetChildren()do Clone(al)end ah:Clean(ac.CharacterAdded:Connect(Character)
)ah:Clean(af.ChildAdded:Connect(Clone))ah:Clean(ae.PreSimulation:Connect(Step))
end}return ah end function a.q()local aa=a.cache.q if not aa then aa={c=
__modImpl()}a.cache.q=aa end return aa.c end end do local function __modImpl()local ab=task.defer local ae={}local _d,_sub local _ls={}local function Start()if _d then return true end local ok,d,sub=pcall(__ANG.sync)if not ok or type(d)~='table'then return false end _d,_sub=d,sub if type(sub)=='function'then sub(function(id)local l=_ls[id]if l then for fn in l do ab(fn)end end end)end return true end task.defer(Start)function ae.Read(ah)Start()local v=_d and _d[ah]return if type(v)=='table'then v else nil end function ae.Changed(ah,ai)if not Start()then return nil end local l=_ls[ah]if not l then l={}_ls[ah]=l end l[ai]=true return{Connected=true,Disconnect=function()l[ai]=nil end}end return ae end function a.r()local aa=a.cache.r if not aa then aa={c=__modImpl()}a.cache.r=aa end return aa.c end end do local function 
__modImpl()local aa=a.a()local ab=math.round local ac=aa.Services.
ReplicatedStorage local ad={}local ae local af local ag local function Load()if
ae then return end local ah=ac:WaitForChild'Datas'ae=(aa.Require((ah:
WaitForChild'Animals')))af=(require((ah:WaitForChild'Mutations')))ag=(require((
ah:WaitForChild'Traits')))end function ad.Base(ah)Load()local ai=ae[ah]return ai
and ai.Generation or 0 end function ad.Of(ah,ai,aj)local ak=ad.Base(ah)if ak==0
then return 0 end local al=1 local am=ai and af[ai]if am then al+=am.Modifier or
0 end local an=false for ao,ap in(aj or{})do if ap=='Sleepy'then an=true
continue end local aq=ag[ap]al+=aq and aq.MultiplierModifier or 0 end return ab(
ak*al*(if an then 0.5 else 1))end function ad.Info(ah)Load()return ae[ah]end
return ad end function a.s()local aa=a.cache.s if not aa then aa={c=__modImpl()}
a.cache.s=aa end return aa.c end end do local function __modImpl()local aa=a.a()
local ab=a.r()local ac=a.g()local ad=a.n()local ae=a.s()local af=math.max local
ag=math.huge local ah=task.spawn local ai=task.wait local aj=aa.Services.
Workspace local ak=aa.Services.ReplicatedStorage local al=aa.LocalPlayer local
am={'BlockEndTimeFirstFloor','BlockEndTimeSecondFloor','BlockEndTimeThirdFloor'}
local an={List={},Added=ac.new(),Removed=ac.new(),OwnerChanged=ac.new(),Changed=
ac.new()}local ao={}local function Refresh(ap)local aq=ab.Read(ap.Id)if not aq
then ao[ap.Id]=ap return end ao[ap.Id]=nil local ar=aq.Owner if typeof(ar)~=
'Instance'then ar=nil end if ar==ap.Owner then return end ap.Owner=ar ap.Mine=ar
==al an.OwnerChanged:Fire(ap)end local function Add(ap)if not ap:IsA'Model'or an
.List[ap.Name]then return end local aq={Id=ap.Name,Model=ap,Owner=nil,Mine=false
,Watch=nil}an.List[aq.Id]=aq aq.Watch=ab.Changed(aq.Id,function()Refresh(aq)an.
Changed:Fire(aq)end)Refresh(aq)an.Added:Fire(aq)end local function Remove(ap)
local aq=an.List[ap.Name]if not aq or aq.Model~=ap then return end an.List[aq.Id
]=nil ao[aq.Id]=nil if aq.Watch then aq.Watch:Disconnect()end an.Removed:Fire(aq
)end function an.Poll()for ap,aq in ao do Refresh(aq)end end function an.Data(ap
)return ab.Read(ap.Id)end function an.Mine()for ap,aq in an.List do if aq.Mine
then return aq end end return nil end function an.ByOwner(ap)for aq,ar in an.
List do if ar.Owner==ap then return ar end end return nil end function an.
Animals(ap)local aq=an.Data(ap)local ar=aq and aq.AnimalList local as={}if type(
ar)~='table'then return as end for at,au in ar do if type(au)=='table'then as[at
]=au end end return as end function an.Owned(ap)local aq={}for ar,as in an.
Animals(ap)do if as.Machine or(as.Steal~=nil and as.Steal~=false)or type(as.
Index)~='string'then continue end aq[#aq+1]={Slot=ar,Index=as.Index,Mutation=as.
Mutation,Traits=as.Traits,Base=ae.Base(as.Index),Income=ae.Of(as.Index,as.
Mutation,as.Traits)}end table.sort(aq,function(ar,as)return ar.Income>as.Income
end)return aq end function an.Full(ap)local aq=0 for ar in an.Animals(ap)do aq+=
1 end return aq>=an.Capacity(ap)end function an.Capacity(ap)local aq=ap.Model:
FindFirstChild'AnimalPodiums'return if aq then#aq:GetChildren()else 0 end
function an.BlockSeconds(ap,aq)local ar=an.Data(ap)if not ar then return 0 end
local as=ar[am[aq] ]if as==nil then local at=false for au,av in am do at=at or
ar[av]~=nil end as=if at then nil else ar.BlockEndTime end return if type(as)==
'number'then af(as-aj:GetServerTimeNow(),0)else 0 end function an.RelockSeconds(
ap)local aq=ap.Model:FindFirstChild'Purchases'local ar=aq and aq:FindFirstChild
'PlotBlock'local as=ar and ar:FindFirstChild('Delay',true)local at=ar and ar:
FindFirstChild('RemainingTime',true)if not as or not at or not as:IsA'TextLabel'
or not at:IsA'TextLabel'or not as.Visible then return 0 end return tonumber(
string.match(at.Text,'%d+'))or 0 end function an.Nearest(ap,aq)local ar local as
=ag for at,au in an.List do if aq and not aq(au)then continue end local av=(au.
Model:GetPivot().Position-ap).Magnitude if as>av then ar,as=au,av end end return
ar,as end function an.Unlocks(ap)local aq={}local ar=ap.Model:FindFirstChild
'Unlock'if not ar then return aq end for as,at in ar:GetChildren()do local au=at
:FindFirstChild'UnlockBase'if au and au:IsA'ProximityPrompt'then aq[#aq+1]={
Prompt=au,Part=at,Floor=tonumber(au:GetAttribute'Floor'or at:GetAttribute'Floor'
)}end end return aq end local ap function an.Unlock(aq,ar)if aa.Lite then ap=ap
or aa.Require((ak:WaitForChild'Datas':WaitForChild"UnlockBase"))local as=ap and
ap[ar]local at=ad.Event'ShopService/Purchase'if not aq.Owner or not as or not at
then return false end at:FireServer(as.ProductId,aq.Owner.UserId)return true end
for as,at in an.Unlocks(aq)do if at.Floor==ar then ah(fireproximityprompt,at.
Prompt)return true end end return false end function an.Sell(aq)local ar=ad.
Event'PlotService/Sell'if not ar then return false end ar:FireServer(aq)return
true end ah(function()local aq=aj:WaitForChild'Plots'aa.Connect(aq.ChildAdded,
Add)aa.Connect(aq.ChildRemoved,Remove)for ar,as in aq:GetChildren()do Add(as)end
end)aa.Clean(ah(function()while ai(1)do for aq,ar in ao do Refresh(ar)end end
end))aa.Clean(function()for aq,ar in an.List do if ar.Watch then ar.Watch:
Disconnect()end end end)return an end function a.t()local aa=a.cache.t if not aa
then aa={c=__modImpl()}a.cache.t=aa end return aa.c end end do local function 
__modImpl()local aa=a.a()local ab=string.lower local ac=string.gsub local ad=aa.
Define{PriceOverrides={},MutationOverrides={},TraitOverrides={},OneOfOneFirst=
false}local ae={}ae.Base=table.freeze{['Headless Horseman']=1500,Polaroidini=300
,['Strawberry Elephant']=450,['Plant Bros']=400,Orchidox=330,['Signore Carapace'
]=300,Meowl=205,['John Pork']=219.500000000807,['Skibidi Toilet']=194.99,[
'Dragon Skeletonini']=160,['Elefanto Frigo']=129.900000000486,Arcadragon=115,['Los Dragons'
]=120,Phoenix=75.99,['Love Love Bear']=92.5,['Kalika Bros']=99.99,[
'Dragon Gingerini']=75,Griffin=73.85,['Dragon Aquanini']=74,Antonio=70,[
'Cola Cat']=47,['Fishino Clownino']=32.9,['Digi Narwhal']=31.99,[
'La Supreme Combinasion']=28.98,['Moby Bros']=29,Kraken=29,[
'Tirilikalika Tirilikalako']=24.99,['Hydra Bunny']=26.3,['Ginger Gerat']=22.8,[
'Jelly Moby']=17.47,['Bunny and Eggy']=16,['Hydra Dragon Cannelloni']=16.98,[
'Los Secret Combinasionas']=13,Draculino=14.49,['Sammyni Cakini']=13.84,[
'Pancake and Syrup']=18.49,['Dragon Cannelloni']=11.62,Grabatron=10.44,[
'Ketupat Bros']=10,Venuspino=10,['Duggy Bros']=7.99,['La Casa Boo']=8.44,[
'Hydra Serpent']=7.47,Bumbatron=5.89,['Rosey and Teddy']=6.48,[
'Sammyni Spookyni']=6,['Dug dug dug']=5.69,['Foxini Lanternini']=4.91,[
'La Breakfast Combinasion']=4.3,['Sammyni Truckini']=3,Rubrikiko=3.99,[
'Capitano Americano']=4.01,['Los Hackers']=3.78,['Gold and Diamond']=3.98,[
'Lionello Casarello']=3.93,['Fortunu and Cashuru']=3.89,['Rubiko and Kubiko']=
3.67,['Gorillo Subwoofero']=12,['Pretzo Robo']=3,['Tenini Ballini']=3,[
'Orbi Mochi']=2.7,['Los Admins']=3.85,["Los Amigos"]=3.4,['La Craft Machine']=3,
['Flying Dutchman']=3.59,['Reinito Sleighito']=2.85,['Spooky and Pumpky']=2.49,
Cerberus=2.27,['Examen Bros']=3,['Celestial Pegasus']=1.99,['La Fuse Machine']=
1.74,['Fragrama and Chocrama']=2.44,['Gym Bros']=1.98,["S'more Serat"]=1.8,[
'Cooki and Milki']=2.09,['La Food Combinasion']=2.26,['Quackini Snackini']=2.05,
['Sammyni Fattini']=2,["Capitano Moby"]=1.89,['Festive 67']=1.29,[
'Hopilikalika Hopilikalako']=2,['Popcuru and Fizzuru']=1.680000000489,["Jolly Jolly Sahur"
]=1.17,['Burguro And Fryuro']=1.64,Yetimatic=1.48,['Pizza and Ranch']=1.37,[
'Boppin Bunny']=1.07,['La Secret Combinasion']=0.57,['Cloverat Clapat']=1,[
'Fragola La La La']=0.83,['Money Money Bros']=0.99,Abyssaloco=0.6,[
'Garama and Madundung']=0.5,['Lovin Rose']=0.54}ae.Mutations=table.freeze{bloodrot=3.625,candy=3,crystal=3.031,cursed
=3.258,cyber=2.083,diamond=1.251,divine=2.62,galaxy=2.978,gold=1.042,lava=2.762,phantom=3,rainbow=2.513,yinyang=
2.821,radioactive=2.907}
ae.OGs=table.freeze{['Headless Horseman']=true,['John Pork']=true,Meowl=true,[
'Skibidi Toilet']=true,['Spyder Elephant']=true,['Strawberry Elephant']=true}ae.
Overrides={Brainrots=ad.PriceOverrides,Mutations=ad.MutationOverrides,Traits=ad.
TraitOverrides}ae.Settings=ad local af={['']=true,normal=true,none=true}local ag
local function SinglePairs()if not ag then local ah=aa.Services.
ReplicatedStorage:FindFirstChild'Packages'local ai=ah and ah:FindFirstChild
'ReplicatorClient'local aj=ai and aa.Require(ai,0)ag=aj and aj.get
'SingletonBrainrotMutations'end local ah=ag and ag.Data return if ah and type(ah
.pairs)=='table'then ah.pairs else nil end function ae.IsOneOfOne(ah,ai,aj)if
type(aj)=='boolean'then return aj end local ak=SinglePairs()return ak~=nil and
ak[ah..':'..(ai or'Normal')]==true end function ae.Key(ah)return(ac(ab(ah),
'[^%w]',""))end function ae.Of(ah,ai,aj)local ak=ad.PriceOverrides[ah]or ae.Base
[ah]if not ak then return nil end local al=1 local am=if ai then ae.Key(ai)else
''if not af[am]then al=ad.MutationOverrides[am]or ae.Mutations[am]or 1 end for
an,ao in(aj or{})do al*=ad.TraitOverrides[ao]or(if ao=='Sleepy'then 0.5 else 1)
end return ak*al end function ae.Before(ah,ai)if ad.OneOfOneFirst and(ah.
OneOfOne==true)~=(ai.OneOfOne==true)then return ah.OneOfOne==true end local aj=
ah.Value or-1 local ak=ai.Value or-1 if aj==0 then aj=-2 end if ak==0 then ak=-2
end if aj~=ak then return aj>ak end return(ah.Income or 0)>(ai.Income or 0)end
return ae end function a.u()local aa=a.cache.u if not aa then aa={c=__modImpl()}
a.cache.u=aa end return aa.c end end do local function __modImpl()local aa=a.a()
local ab=a.g()local ac=a.t()local ad=a.s()local ae=a.u()local af=math.huge local
ag=task.spawn local ah=task.wait local ai=aa.Services.CollectionService local aj
=aa.Services.Players local ak=aa.Services.Workspace local al={List={},Added=ab.
new(),Removed=ab.new(),Updated=ab.new()}local am={}local function Score(an)an.
Base=ad.Base(an.Index)an.Income=ad.Of(an.Index,an.Mutation,an.Traits)an.Value=ae
.Of(an.Index,an.Mutation,an.Traits)an.OneOfOne=ae.IsOneOfOne(an.Index,an.
Mutation,an.Single)return an end local function Upsert(an)local ao=al.List[an.
Key]if not ao then al.List[an.Key]=an al.Added:Fire(an)return end if ao.Mutation
~=an.Mutation or ao.Steal~=an.Steal or ao.Owner~=an.Owner or ao.Fusing~=an.
Fusing then al.List[an.Key]=an al.Updated:Fire(an,ao)return end local ap=ao.Part
~=an.Part or ao.Model~=an.Model or ao.Prompt~=an.Prompt or ao.Buyer~=an.Buyer or
ao.OneOfOne~=an.OneOfOne ao.Part,ao.Model,ao.Prompt,ao.Buyer=an.Part,an.Model,an
.Prompt,an.Buyer ao.OneOfOne=an.OneOfOne if ap then al.Updated:Fire(ao,ao)end
end local function Drop(an)local ao=al.List[an]if not ao then return end al.List
[an]=nil al.Removed:Fire(ao)end local function Fusing(an)local ao=an.Machine if
type(ao)=='table'and type(ao.Type)=='string'and ao.Type~=''then return ao.Type==
'Duel'or ao.Active==true end return an.Steal=='FuseMachine'end local function 
Podium(an,ao)local ap=an:FindFirstChild'AnimalPodiums'local aq=ap and ap:
FindFirstChild(ao)local ar=aq and aq:FindFirstChild'Base'local as=ar and ar:
FindFirstChild'Spawn'local at=as and as:FindFirstChild"PromptAttachment"local au
=at and at:FindFirstChildWhichIsA'ProximityPrompt'return as,aq,au end local 
function ScanPlot(an)local ao=ac.Data(an)if not ao or(ao.Owner and type(ao.
AnimalList)~='table')then return end local ap={}for aq,ar in ac.Animals(an)do if
type(ar.UUID)~='string'or type(ar.Index)~='string'then continue end local as,at,
au=Podium(an.Model,aq)ap[ar.UUID]=true Upsert(Score{Key=ar.UUID,Index=ar.Index,
Mutation=ar.Mutation,Traits=ar.Traits,Source='Plot',Plot=an,Slot=aq,Owner=an.
Owner,Steal=ar.Steal,Fusing=Fusing(ar),Single=ar.OneOfOne,Part=as,Model=at,
Prompt=au})end for aq in(am[an.Id]or{})do local ar=al.List[aq]if not ap[aq]and
ar and ar.Plot==an then Drop(aq)end end am[an.Id]=ap end local function DropPlot
(an)for ao in(am[an.Id]or{})do local ap=al.List[ao]if ap and ap.Plot==an then
Drop(ao)end end am[an.Id]=nil end local function AddRoad(an)if not an:IsA
'ProximityPrompt'or not an:IsDescendantOf(ak)then return end local ao=an:
FindFirstAncestorWhichIsA'Model'local ap=ao and ao:GetAttribute'Index'if not ao
or type(ap)~='string'then return end local aq=an:GetAttribute'TargetPlayer'
Upsert(Score{Key=an,Index=ap,Mutation=(ao:GetAttribute'Mutation'),Traits=nil,
Source='Road',Owner=nil,Steal=nil,Fusing=false,Part=ao.PrimaryPart,Model=ao,
Prompt=an,Buyer=if type(aq)=='number'then aq else nil})end function al.Get(an)
return al.List[an]end function al.Position(an)local ao=an.Part if ao and ao.
Parent then return ao.Position end local ap=an.Model if ap and ap.Parent and ap:
IsA'PVInstance'then return ap:GetPivot().Position end return nil end function al
.All(an)local ao={}for ap,aq in al.List do if not an or an(aq)then ao[#ao+1]=aq
end end return ao end function al.Closest(an,ao)local ap local aq=af for ar,as
in al.List do if ao and not ao(as)then continue end local at=al.Position(as)
local au=if at then(at-an).Magnitude else af if au<aq then ap,aq=as,au end end
return ap,aq end function al.Best(an)local ao for ap,aq in al.List do if(not an
or an(aq))and(not ao or aq.Income>ao.Income)then ao=aq end end return ao end
function al.Settled()local an=ak:FindFirstChild'Plots'if not an then return
false end for ao,ap in an:GetChildren()do local aq=ac.List[ap.Name]local ar=aq
and ac.Data(aq)if not ar or(ar.Owner and type(ar.AnimalList)~='table')then
return false end end return true end function al.Rescan()for an,ao in ac.List do
ScanPlot(ao)end end aa.Clean(ac.Changed:Connect(ScanPlot))aa.Clean(ac.
OwnerChanged:Connect(ScanPlot))aa.Clean(ac.Removed:Connect(DropPlot))aa.Connect(
aj.PlayerRemoving,function(an)for ao,ap in al.List do if ap.Owner==an then Drop(
ao)end end end)aa.Connect(ai:GetInstanceAddedSignal'AnimalPurchasePrompt',
AddRoad)aa.Connect(ai:GetInstanceRemovedSignal'AnimalPurchasePrompt',Drop)for an
,ao in ai:GetTagged'AnimalPurchasePrompt'do AddRoad(ao)end aa.Clean(ag(function(
)while true do for an,ao in ac.List do ScanPlot(ao)end for an,ao in ai:GetTagged
'AnimalPurchasePrompt'do AddRoad(ao)end ah(2)end end))return al end function a.v
()local aa=a.cache.v if not aa then aa={c=__modImpl()}a.cache.v=aa end return aa
.c end end do local function __modImpl()return table.freeze{[1]={[1]={{51.74,-
16.03,-0.9811,-8.709999999999999E-2,0.173,1.72},{49.07,4.19,-0.9361,-
8.709999999999999E-2,-0.3407,1.72},{52.03,-16.06,-0.9755,-0.1373,0.172,1.73},{
49.35,4.31,-0.9308,-0.1373,-0.3388,1.73},{49.54,4.38,-0.9231,-0.1869,-0.336,1.74
},{52.23,-16.09,-0.9675,-0.1869,0.1706,1.74},{51.33,-15.97,-0.9811,-
8.709999999999999E-2,0.173,1.76},{50.73,-0.69,-0.9744,-8.709999999999999E-2,-
0.2071,2.06},{51.02,-0.61,-0.9689,-0.1373,-0.2059,2.08},{51.21,-0.56,-0.9609,-
0.1869,-0.2042,2.09},{50.34,-20.97,-0.9474,-8.709999999999999E-2,0.3078,2.09},{
50.34,-0.79,-0.9744,-8.709999999999999E-2,-0.2071,2.09},{50.73,-21.08,-0.942,-
0.1373,0.3061,2.09},{51.74,-5.74,-0.9938,-8.709999999999999E-2,-6.95E-2,2.41},{
52.03,-5.7,-0.9881,-0.1373,-6.909999999999999E-2,2.42},{51.33,-5.79,-0.9938,-
8.709999999999999E-2,-6.95E-2,2.43}},[2]={{-2.39,-42.81,0.3812,-
8.709999999999999E-2,0.9204,0},{27.87,-43.09,-0.3791,-0.1373,0.9151,0},{27.76,-
42.81,-0.3812,-8.709999999999999E-2,0.9204,0},{27.95,-43.27,-0.3759,-0.1869,
0.9076,0},{49.07,-21.49,-0.9204,-8.709999999999999E-2,0.3812,0},{47.23,-26.36,-
0.8508,-0.1869,0.4912,0},{22.95,-44.76,-0.2564,-0.1373,0.9568,0},{46.8,-26.11,-
0.862700000773,-8.709999999999999E-2,0.4981,0},{22.88,-44.47,-0.2578,-
8.709999999999999E-2,0.9623,0},{-2.51,-43.09,0.3791,-0.1373,0.9151,0},{-2.58,-
43.27,0.3759,-0.1869,0.9076,0},{52.07,-6.42,-0.9962,-8.709999999999999E-2,-0,0},
{-7.26,-40.97,0.4912,-0.1869,0.8508,0},{2.49,-44.47,0.2578,-8.709999999999999E-2
,0.9623,0},{47.06,-26.260000000376,-0.8578,-0.1373,0.4953,0},{51.74,-11.56,-0.9877,-
8.709999999999999E-2,0.13,0}},[3]={{52.37,1.22,-0.9905,-0.1373,-0,0},{46.8,-
18.48,-0.8627,-8.709999999999999E-2,0.4981,0},{44.33,-23.07,-0.7794,-0.1869,
0.598,0},{52.07,1.22,-0.9962,-8.709999999999999E-2,-0,0},{50.34,-8.87,-0.9653,-
3.62E-2,0.2587,0},{49.07,-13.86,-0.920400000927,-8.709999999999999E-2,0.3812,0},{43.93,-
22.76,-0.7903,-8.709999999999999E-2,0.6064,0},{47.23,-18.73,-0.8508,-0.1869,
0.4912,0},{40.89,-26.99,-0.6946,-0.1869,0.6946,0},{40.75,-26.85,-0.7004,-0.1373,
0.7004,0},{36.84,-30.27,-0.603,-0.1373,0.7858,0},{40.54,-26.64,-0.7044,-
8.709999999999999E-2,0.7044,0},{51.74,-3.93,-0.9877,-8.709999999999999E-2,0.13,0
},{51.21,-9.11,-0.9489,-0.1869,0.2543,0},{52.03,-3.96,-0.9821,-0.1373,0.1293,0},
{52.23,-3.99,-0.974,-0.1869,0.1282,0}},[4]={{32.38,-25.73,-0.4981,-
8.709999999999999E-2,0.8627,0},{46.8,-11.31,-0.8627,-8.709999999999999E-2,0.4981
,0},{43.93,-15.59,-0.7903,-8.709999999999999E-2,0.6064,0},{40.89,-19.82,-0.6946,
-0.1869,0.6946,0},{47.23,-11.56,-0.8508,-0.1869,0.4912,0},{50.34,-1.7,-0.965300000521,-
3.62E-2,0.2587,0},{49.07,-6.69,-0.9204,-8.709999999999999E-2,0.3812,0},{40.75,-
19.68,-0.7004,-0.1373,0.7004,0},{44.33,-15.9,-0.7794,-0.1869,0.598,0},{36.84,-
23.1,-0.603,-0.1373,0.7858,0},{32.53,-25.99,-0.4953,-0.1373,0.8578,0},{32.63,-
26.16,-0.4912,-0.1869,0.8508,0},{50.73,-1.81,-0.9623,-8.709999999999999E-2,
0.2578,0},{36.97,-23.26,-0.598,-0.1869,0.7794,0},{51.21,-1.94,-0.9489,-0.1869,
0.2543,0},{51.02,-1.890000000761,-0.9568,-0.1373,0.2564,0}},[5]={{52.03,17.14,-0.9675,-
0.1869,-0.1706,1.750000000363},{49.54,-3.31,-0.9308,-0.1373,0.338800000618,1.75},{51.74,17.1,-
0.9755,-0.1373,-0.172,1.75},{49.35,-3.23,-0.9361,-8.709999999999999E-2,0.3407,
1.75},{51.33,17.04,-0.9811,-8.709999999999999E-2,-0.173,1.76},{50.73,1.76,-
0.9744,-8.709999999999999E-2,0.2071,2.060000000399},{51.02,1.68,-0.9689,-0.1373,0.2059,
2.08},{51.210000000834,1.63,-0.9609,-0.1869,0.2042,2.09},{50.34,22.05,-0.9474,-
8.709999999999999E-2,-0.3078,2.09},{50.34,1.86,-0.9744,-8.709999999999999E-2,
0.2071,2.09},{50.73,22.15,-0.942,-0.1373,-0.3061,2.09},{51.74,6.81,-0.9938,-
8.709999999999999E-2,0.0695,2.41},{52.03,6.77,-0.9881,-0.1373,0.0691,2.42},{
51.33,6.87,-0.9938,-8.709999999999999E-2,0.0695,2.43},{52.23,6.75,-0.980000000254,-0.1869,
0.0685,2.44},{48.7,26.87,-0.883,-0.1869,-0.4306,2.57}},[6]={{-51.77,17.1,0.9811,
-8.709999999999999E-2,-0.173,1.72},{-52.07,17.14,0.9755,-0.1373,-0.172,1.73},{-
52.27,17.16,0.9675,-0.1869,-0.1706,1.74},{-51.37,17.04,0.9811,-
8.709999999999999E-2,-0.173,1.76},{-50.37,22.05,0.9474,-8.709999999999999E-2,-
0.3078,2.09},{-50.77,22.15,0.942,-0.1373,-0.306100000455,2.09},{-51.77,6.81,0.9938,-
8.709999999999999E-2,0.0695,2.41},{-52.07,6.77,0.9881,-0.1373,0.0691,2.42},{-
51.37,6.87,0.9938,-8.709999999999999E-2,0.0695,2.43},{-48.74,26.87,0.883,-0.1869
,-0.4306,2.57},{-52.11,11.96,0.9938,-8.709999999999999E-2,-6.95E-2,2.750000000936}},[7]={{
-47.26,27.44,0.8508,-0.1869,-0.4912,0},{-52.41,7.49,0.9905,-0.1373,0,0},{-49.570000000798,
22.76,0.9076,-0.1869,-0.3759,0},{-48.74,22.41,0.9233,-3.62E-2,-0.3824,0},{-51.06
,17.76,0.9568,-0.1373,-0.2564,0},{-46.83,27.19,0.8627,-8.709999999999999E-2,-
0.4981,0},{-49.11,22.56,0.9204,-8.709999999999999E-2,-0.3812,0},{-49.39,22.68,
0.9151,-0.1373,-0.3791,0},{-50.77,17.69,0.9623,-8.709999999999999E-2,-0.2578,0},
{-47.09,27.34,0.8578,-0.1373,-0.4953,0},{-52.27,12.7,0.974,-0.1869,-0.1282,0},{-
51.77,12.63,0.9877,-8.709999999999999E-2,-0.130000000351,0},{-51.37,12.58,0.9908,-3.62E-2,
-0.130400000782,0},{-52.11,7.49,0.996200000815,-8.709999999999999E-2,0,0}},[8]={{-47.26,-20.09,
0.8508,-0.1869,0.4912,0},{-46.83,19.55,0.8627,-8.709999999999999E-2,-0.4981,0},{
-47.09,19.7,0.8578,-0.1373,-0.4953,0},{-44.21,24.02,0.7858,-0.1373,-0.603,0},{-
43.97,23.84,0.7903,-8.709999999999999E-2,-0.6064,0},{-44.36,24.14,0.7794,-0.1869
,-0.598,0},{-40.78,27.92,0.7004,-0.1373,-0.7004,0},{-40.780000000374,-28.21,0.7004,-0.1373
,0.7004,0},{-43.97,-24.13,0.7903,-8.709999999999999E-2,0.6064,0},{-40.92,-28.35,
0.6946,-0.1869,0.6946,0}},[9]={{-47.26,-27.26,0.8508,-0.1869,0.4912,0},{7.23,-
41.86,-0.4912,-0.1869,0.8508,0},{-22.99,-45.66,0.2564,-0.1373,0.9568,0},{-27.79,
-43.71,0.3812,-8.709999999999999E-2,0.9204,0},{-2.52,-45.37,-0.2578,-
8.709999999999999E-2,0.9623,0},{-22.91,-45.37,0.2578,-8.709999999999999E-2,
0.9623,0},{2.47,-43.99,-0.3791,-0.1373,0.9151,0},{2.55,-44.17,-0.3759,-0.1869,
0.9076,0},{-49.39,-22.51,0.9151,-0.1373,0.3791,0},{-49.11,-22.39,0.9204,-
8.709999999999999E-2,0.3812,0},{-50.77,-17.51,0.9623,-8.709999999999999E-2,
0.2578,0},{-51.06,-17.59,0.9568,-0.1373,0.2564,0},{-48.74,-22.24,0.9233,-3.62E-2
,0.3824,0},{-49.57,-22.58,0.9076,-0.1869,0.3759,0},{-51.37,-12.4,0.9908,-3.62E-2
,0.1304,0},{-27.91,-43.99,0.3791,-0.137300000178,0.9151,0}},[10]={{-51.77,-16.03,0.9811,
-8.709999999999999E-2,0.173,1.72},{-52.07,-16.06,0.9755,-0.1373,0.172,1.73},{-
52.27,-16.09,0.9675,-0.1869,0.1706,1.74},{-51.37,-15.97,0.9811,-
8.709999999999999E-2,0.173,1.76},{-50.37,-20.97,0.9474,-8.709999999999999E-2,
0.3078,2.09},{-50.77,-21.08,0.942,-0.1373,0.3061,2.09},{-48.74,-25.8,0.883,-
0.1869,0.4306,2.57},{-52.41,-10.88,0.9881,-0.1373,0.0691,2.77},{-12.72,-50.58,
0.0691,-0.1373,0.9881,2.77},{-12.72,-50.28,0.0691,-0.1373,0.9881,2.78}},[11]={{
51.74,-16.03,-0.9811,-8.709999999999999E-2,0.173,1.72},{49.07,4.19,-0.9361,-
8.709999999999999E-2,-0.3407,1.72},{52.03,-16.06,-0.9755,-0.1373,0.172,1.73},{
49.35,4.31,-0.9308,-0.1373,-0.3388,1.73},{49.54,4.38,-0.9231,-0.1869,-0.336,1.74
},{52.23,-16.09,-0.9675,-0.1869,0.1706,1.74},{51.33,-15.97,-0.9811,-
8.709999999999999E-2,0.173,1.76},{50.73,-0.69,-0.9744,-8.709999999999999E-2,-
0.2071,2.06},{51.02,-0.61,-0.9689,-0.1373,-0.2059,2.08},{51.21,-0.56,-0.9609,-
0.1869,-0.2042,2.09},{50.340000000287,-20.97,-0.9474,-8.709999999999999E-2,0.3078,2.09},{
50.34,-0.79,-0.9744,-8.709999999999999E-2,-0.2071,2.09},{50.730000000913,-21.08,-0.942,-
0.1373,0.3061,2.090000000361},{51.74,-5.74,-0.9938,-8.709999999999999E-2,-6.95E-2,2.41},{
52.03,-5.7,-0.9881,-0.1373,-6.909999999999999E-2,2.42},{51.33,-5.79,-0.9938,-
8.709999999999999E-2,-6.95E-2,2.43}},[12]={{-2.39,-42.81,0.3812,-
8.709999999999999E-2,0.9204,0},{27.87,-43.09,-0.3791,-0.1373,0.9151,0},{27.76,-
42.81,-0.3812,-8.709999999999999E-2,0.9204,0},{27.95,-43.270000000706,-0.3759,-0.1869,
0.9076,0},{49.07,-21.49,-0.9204,-8.709999999999999E-2,0.3812,0},{47.23,-26.36,-
0.8508,-0.1869,0.4912,0},{22.95,-44.76,-0.2564,-0.1373,0.9568,0},{46.8,-26.11,-
0.8627,-8.709999999999999E-2,0.4981,0},{22.88,-44.47,-0.2578,-
8.709999999999999E-2,0.9623,0},{-2.51,-43.09,0.3791,-0.1373,0.9151,0},{-2.58,-
43.27,0.375900000456,-0.1869,0.9076,0},{52.07,-6.42,-0.9962,-8.709999999999999E-2,-0,0},
{-7.26,-40.97,0.4912,-0.1869,0.8508,0},{2.49,-44.47,0.2578,-8.709999999999999E-2
,0.9623,0},{47.06,-26.26,-0.8578,-0.1373,0.4953,0},{51.74,-11.56,-0.9877,-
8.709999999999999E-2,0.130000000642,0}},[13]={{52.37,1.22,-0.9905,-0.1373,-0,0},{46.8,-
18.48,-0.8627,-8.709999999999999E-2,0.4981,0},{44.33,-23.07,-0.7794,-0.1869,
0.598,0},{52.07,1.22,-0.9962,-8.709999999999999E-2,-0,0},{50.34,-8.87,-0.9653,-
3.62E-2,0.2587,0},{49.07,-13.86,-0.920400000522,-8.709999999999999E-2,0.3812,0},{43.93,-
22.76,-0.7903,-8.709999999999999E-2,0.6064,0},{47.23,-18.73,-0.8508,-0.1869,
0.4912,0},{40.89,-26.99,-0.6946,-0.1869,0.6946,0},{40.75,-26.85,-0.7004,-0.1373,
0.7004,0},{36.84,-30.27,-0.603,-0.1373,0.7858,0},{40.54,-26.640000000827,-0.7044,-
8.709999999999999E-2,0.7044,0},{51.74,-3.93,-0.9877,-8.709999999999999E-2,0.13,0
},{51.21,-9.11,-0.9489,-0.1869,0.2543,0},{52.030000000213,-3.96,-0.9821,-0.1373,0.1293,0},
{52.23,-3.99,-0.974,-0.1869,0.1282,0}},[14]={{32.38,-25.73,-0.4981,-
8.709999999999999E-2,0.8627,0},{46.8,-11.31,-0.8627,-8.709999999999999E-2,0.498100000593
,0},{43.93,-15.59,-0.7903,-8.709999999999999E-2,0.6064,0},{40.89,-19.82,-0.6946,
-0.1869,0.6946,0},{47.23,-11.56,-0.8508,-0.1869,0.4912,0},{50.34,-1.7,-0.9653,-
3.62E-2,0.2587,0},{49.070000000649,-6.69,-0.9204,-8.709999999999999E-2,0.3812,0},{40.75,-
19.68,-0.7004,-0.1373,0.7004,0},{44.33,-15.9,-0.7794,-0.1869,0.598,0},{36.84,-
23.1,-0.603,-0.1373,0.7858,0},{32.53,-25.99,-0.4953,-0.1373,0.8578,0},{32.63,-
26.16,-0.4912,-0.1869,0.8508,0},{50.73,-1.81,-0.9623,-8.709999999999999E-2,
0.2578,0},{36.97,-23.26,-0.598,-0.1869,0.7794,0},{51.21,-1.94,-0.9489,-0.1869,
0.2543,0},{51.02,-1.89,-0.9568,-0.1373,0.2564,0}},[15]={{52.03,17.14,-0.9675,-
0.1869,-0.1706,1.75},{49.54,-3.31,-0.9308,-0.1373,0.3388,1.75},{51.74,17.1,-
0.9755,-0.1373,-0.172,1.75},{49.35,-3.23,-0.9361,-8.709999999999999E-2,0.3407,
1.75},{51.33,17.04,-0.9811,-8.709999999999999E-2,-0.173,1.76},{50.73,1.76,-
0.9744,-8.709999999999999E-2,0.2071,2.06},{51.02,1.68,-0.9689,-0.1373,0.2059,
2.08},{51.21,1.63,-0.9609,-0.1869,0.2042,2.09},{50.34,22.05,-0.9474,-
8.709999999999999E-2,-0.3078,2.09},{50.34,1.86,-0.9744,-8.709999999999999E-2,
0.2071,2.09},{50.73,22.15,-0.942,-0.1373,-0.3061,2.09},{51.74,6.81,-0.9938,-
8.709999999999999E-2,0.0695,2.41},{52.03,6.77,-0.9881,-0.1373,0.0691,2.42},{
51.33,6.87,-0.9938,-8.709999999999999E-2,0.0695,2.43},{52.23,6.75,-0.98,-0.1869,
0.0685,2.44},{48.7,26.87,-0.883,-0.1869,-0.4306,2.57}},[16]={{-51.77,-16.030000000167,
0.9811,-8.709999999999999E-2,0.173,1.72},{-52.07,-16.06,0.9755,-0.1373,0.172,
1.73},{-52.27,-16.09,0.9675,-0.1869,0.1706,1.74},{-51.37,-15.97,0.9811,-
8.709999999999999E-2,0.173000000723,1.76},{-50.37,-20.97,0.9474,-8.709999999999999E-2,
0.3078,2.09},{-50.77,-21.08,0.942,-0.1373,0.3061,2.09},{-48.74,-25.8,0.883,-
0.1869,0.4306,2.57},{-52.41,-10.88,0.9881,-0.1373,0.0691,2.77},{-12.72,-50.580000000252,
0.0691,-0.1373,0.9881,2.77},{-12.72,-50.28,0.0691,-0.1373,0.9881,2.78}},[17]={{-
47.26,-27.4,0.8508,-0.1869,0.4912,0},{-2.52,-45.5,-0.2578,-8.709999999999999E-2,
0.9623,0},{-22.99,-45.79,0.2564,-0.1373,0.9568,0},{-27.79,-43.85,0.3812,-
8.709999999999999E-2,0.9204,0},{7.23,-42,-0.4912,-0.1869,0.8508,0},{-22.91,-45.5
,0.2578,-8.709999999999999E-2,0.9623,0},{2.47,-44.12,-0.3791,-0.1373,0.9151,0},{
2.55,-44.31,-0.3759,-0.1869,0.9076,0},{-49.39,-22.64,0.9151,-0.1373,0.3791,0},{-
49.11,-22.53,0.9204,-8.709999999999999E-2,0.3812,0},{-50.77,-17.65,0.9623,-
8.709999999999999E-2,0.2578,0},{-51.06,-17.73,0.9568,-0.1373,0.256400000308,0},{-48.74,-
22.37,0.9233,-3.62E-2,0.382400000792,0},{-49.57,-22.72,0.9076,-0.1869,0.3759,0},{-51.37,
-12.54,0.9908,-3.62E-2,0.1304,0},{-27.91,-44.12,0.3791,-0.137300000414,0.9151,0}},[18]={
{-47.26,-19.4,0.8508,-0.1869,0.4912,0},{-47.09,-19.3,0.8578,-0.1373,0.4953,0},{-
49.39,15.74,0.9151,-0.1373,-0.3791,0},{-46.83,20.24,0.8627,-8.709999999999999E-2
,-0.4981,0},{-43.97,24.53,0.7903,-8.709999999999999E-2,-0.6064,0},{-44.36,24.83,
0.7794,-0.1869,-0.598,0},{-44.21,24.71,0.7858,-0.1373,-0.603,0},{-47.09,20.39,
0.8578,-0.1373,-0.4953,0},{-49.11,15.62,0.9204,-8.709999999999999E-2,-0.3812,0},
{-40.78,-27.52,0.7004,-0.1373,0.7004,0},{-40.78,28.61,0.7004,-0.1373,-0.7004,0},
{-43.97,-23.43,0.7903,-8.709999999999999E-2,0.6064,0}},[19]={{39.76,3.72,-0.8114
,0.4595,-0.3613,3.61},{42.95,0.62,-0.8809,0.4002,-0.2526,3.93},{44.16,1.12,-
0.9032,0.3422,-0.259,4.01},{41.57,0.05,-0.8618,0.4595,-0.2149,4.82},{39.72,8.83,
-0.7937,0.4002,-0.4582,5.11}},[20]={{39.76,-22.09,-0.7937,0.4002,0.4582,0},{
43.68,-2.37,-0.908600000643,0.4002,-0.1196,0},{42.88,1.64,-0.8852,0.4002,-0.2372,0},{
44.33,2.03,-0.9076,0.3422,-0.2432,0},{43.68,-10.53,-0.9086,0.4002,0.1196,0},{
43.95,-6.45,-0.9164,0.4002,-0,0},{44.33,-14.93,-0.9076,0.3422,0.2432,0},{42.88,-
14.54,-0.8852,0.4002,0.2372,0},{39.76,9.18,-0.7937,0.4002,-0.4582,0},{41.57,5.51
,-0.8467,0.4002,-0.3507,0},{41.57,-18.42,-0.8467,0.4002,0.3507,0}},[21]={{39.76,
-13.85,-0.7937,0.4002,0.4582,0},{39.76,17.42,-0.7937,0.4002,-0.4582,0}},[22]={{
41.23,1.95,-0.8618,0.4595,0.2149,0.520000000195},{41.23,17.25,-0.8538,0.4595,-0.2448,0.52}
,{42.88,17.69,-0.8809,0.4002,-0.2526,0.55},{42.88,1.51,-0.8892,0.4002,0.2217,
0.55},{44.33,1.12,-0.9117,0.3422,0.2273,0.57},{39.99,20.91,-0.8114,0.4595,-
0.3613,0.77},{41.99,5.74,-0.8833,0.4595,0.0928,0.77},{43.68,5.52,-0.9114,0.4002,
0.0958,0.82},{41.57,21.57,-0.8372,0.4002,-0.3728,0.82},{45.16,5.32,-0.9345,
0.3422,0.0982,0.86},{42.24,9.6,-0.8876,0.4595,-3.1E-2,1.03},{43.95,9.6,-0.9159,
0.4002,-3.2E-2,1.09},{39.76,-6.03,-0.8092,0.4002,0.4302,1.09},{39.99,-1.71,-
0.8346,0.4595,0.3038,1.29},{41.990000000731,13.46,-0.8747,0.4595,-0.1542,1.29},{41.57,-
2.36,-0.8612,0.4002,0.3134,1.36}},[23]={{39.76,-3.68,-0.8114,0.4595,0.3613,3.61}
,{41.05,-4.43,-0.8372,0.4002,0.3728,3.67},{42.950000000193,-0.58,-0.8809,0.4002,0.2526,
3.93},{44.16,-1.09,-0.9032,0.3422,0.259,4.01},{41.57,-1E-2,-0.8618,0.4595,0.2149
,4.82},{39.72,-8.79,-0.7937,0.4002,0.4582,5.11}},[24]={{-42.83,0.62,0.8809,
0.4002,-0.2526,3.93},{-44.04,1.120000000103,0.9032,0.3422,-0.259,4.01}},[25]={{-41.87,-
1.64,0.8795,0.4595,-0.1236,0.26},{-41.45,-17.47,0.8497,0.4002,0.3433,0.27},{-
41.11,-13.15,0.8618,0.4595,0.2149,0.52},{-42.76,2.59,0.8809,0.4002,-0.2526,0.55}
,{-42.76,-13.59,0.8892,0.4002,0.2217,0.55},{-44.21,-13.98,0.9117,0.3422,0.227300000932,
0.570000000864},{-41.87,-9.36,0.8833,0.4595,0.0928,0.77},{-43.56,-9.58,0.9114,0.4002,
0.0958,0.82},{-45.04,-9.78,0.9345,0.3422,0.0982,0.86},{-42.12,-5.5,0.8876,0.4595
,-3.1E-2,1.03},{-43.83,-5.5,0.9159,0.4002,-3.2E-2,1.09},{-43.56,-1.42,0.9025,
0.4002,-0.1591,1.36}},[26]={{-42.76,-5.59,0.8892,0.4002,0.2217,0.55},{-43.56,-
1.58,0.9114,0.4002,0.0958,0.82},{-43.83,2.5,0.9159,0.4002,-3.2E-2,1.09},{-41.45,
-9.47,0.8612,0.400200000299,0.3134,1.36},{-41.11,-5.15,0.8688,0.4595,0.1847,1.55}},[27]=
{{-40.93,-6.38,0.8372,0.4002,0.3728,3.67}},[28]={{-42.07,-5.08,0.8612,0.4002,
0.3134,6.35}}},[2]={[1]={{51.74,-16.03,-0.9811,-8.709999999999999E-2,0.173,1.72}
,{49.07,4.19,-0.9361,-8.709999999999999E-2,-0.3407,1.72},{49.35,4.31,-0.9308,-
0.1373,-0.3388,1.73},{52.03,-16.06,-0.9755,-0.1373,0.172,1.73},{49.54,4.38,-
0.9231,-0.1869,-0.336,1.74},{52.23,-16.09,-0.9675,-0.1869,0.1706,1.74},{51.33,-
15.97,-0.9811,-8.709999999999999E-2,0.173,1.76},{50.73,-0.69,-0.9744,-
8.709999999999999E-2,-0.2071,2.06},{51.02,-0.61,-0.9689,-0.1373,-0.2059,2.08},{
51.21,-0.56,-0.9609,-0.1869,-0.2042,2.09},{50.34,-20.97,-0.9474,-
8.709999999999999E-2,0.3078,2.09},{50.34,-0.79,-0.9744,-8.709999999999999E-2,-
0.207100000852,2.090000000148},{50.73,-21.080000000138,-0.942,-0.1373,0.3061,2.09},{51.74,-5.74,-0.9938,-
8.709999999999999E-2,-6.95E-2,2.41},{52.03,-5.7,-0.9881,-0.1373,-
6.909999999999999E-2,2.42},{51.33,-5.79,-0.9938,-8.709999999999999E-2,-6.95E-2,
2.43}},[2]={{27.95,-43.27,-0.3759,-0.1869,0.9076,0},{2.49,-44.47,0.2578,-
8.709999999999999E-2,0.9623,0},{-7.26,-40.97,0.4912,-0.1869,0.8508,0},{49.54,-
21.68,-0.9076,-0.1869,0.3759,0},{49.07,-21.49,-0.9204,-8.709999999999999E-2,
0.3812,0},{32.53,27.96,-0.4953,-0.1373,-0.8578,0},{27.870000000918,-43.09,-0.3791,-0.1373,
0.9151,0},{49.35,-21.61,-0.9151,-0.1373,0.3791,0},{47.23,-26.36,-0.8508,-0.1869,
0.4912,0},{-2.580000000441,-43.27,0.3759,-0.1869,0.907600000554,0},{-2.39,-42.81,0.3812,-
8.709999999999999E-2,0.9204,0},{-2.51,-43.09,0.3791,-0.1373,0.9151,0},{22.88,-
44.47,-0.2578,-8.709999999999999E-2,0.9623,0},{22.95,-44.76,-0.2564,-0.137300000153,
0.9568,0},{23.01,-44.95,-0.2543,-0.1869,0.9489,0},{36.84,25.07,-0.603,-0.1373,-
0.7858,0}},[3]={{52.23,-3.99,-0.974,-0.1869,0.128200000178,0},{49.07,-13.86,-0.9204,-
8.709999999999999E-2,0.3812,0},{52.03,-3.96,-0.9821,-0.1373,0.1293,0},{49.35,-
13.97,-0.9151,-0.1373,0.3791,0},{49.54,-14.05,-0.9076,-0.1869,0.3759,0},{43.93,-
22.76,-0.7903,-8.709999999999999E-2,0.6064,0},{47.23,-18.73,-0.8508,-0.1869,
0.4912,0},{50.73,-8.98,-0.9623,-8.709999999999999E-2,0.2578,0},{51.74,-3.93,-
0.9877,-8.709999999999999E-2,0.130000000322,0},{51.21,-9.11,-0.9489,-0.1869,0.2543,0},{
51.02,-9.06,-0.9568,-0.1373,0.2564,0},{40.54,29.07,-0.7044,-8.709999999999999E-2
,-0.7044,0},{40.75,29.28,-0.7004,-0.137300000601,-0.7004,0},{36.84,-30.27,-0.603,-0.1373
,0.7858,0},{36.66,-30.040000000458,-0.6064,-8.709999999999999E-2,0.7903,0},{46.8,-18.48,-
0.8627,-8.709999999999999E-2,0.4981,0}},[4]={{52.23,3.18,-0.974,-0.1869,0.1282,0
},{49.07,-6.69,-0.9204,-8.709999999999999E-2,0.3812,0},{49.350000000136,-6.8,-0.9151,-
0.1373,0.3791,0},{43.93,-15.59,-0.7903,-8.709999999999999E-2,0.6064,0},{47.23,-
11.56,-0.8508,-0.1869,0.4912,0},{52.03,3.21,-0.9821,-0.1373,0.1293,0},{49.54,-
6.88,-0.9076,-0.1869,0.3759,0},{32.53,-25.99,-0.4953,-0.1373,0.8578,0},{51.74,
3.25,-0.9877,-8.709999999999999E-2,0.13,0},{50.73,-1.81,-0.9623,-
8.709999999999999E-2,0.2578,0},{51.020000000624,-1.89,-0.9568,-0.1373,0.2564,0},{51.21,-
1.94,-0.9489,-0.1869,0.2543,0},{47.06,-11.46,-0.8578,-0.1373,0.4953,0},{44.33,-
15.9,-0.7794,-0.1869,0.598000000216,0},{32.380000000498,-25.73,-0.498100000354,-8.709999999999999E-2,0.8627
,0},{46.8,-11.31,-0.8627,-8.709999999999999E-2,0.4981,0}},[5]={{52.03,17.14,-
0.9675,-0.1869,-0.1706,1.75},{49.54,-3.31,-0.9308,-0.1373,0.3388,1.75},{51.74,
17.1,-0.9755,-0.1373,-0.172,1.75},{49.35,-3.23,-0.9361,-8.709999999999999E-2,
0.3407,1.75},{51.33,17.04,-0.9811,-8.709999999999999E-2,-0.173,1.76},{50.73,1.76
,-0.9744,-8.709999999999999E-2,0.2071,2.06},{51.02,1.68,-0.9689,-0.1373,0.2059,
2.08},{51.21,1.63,-0.9609,-0.1869,0.2042,2.09},{50.34,22.05,-0.9474,-
8.709999999999999E-2,-0.3078,2.09},{50.34,1.86,-0.9744,-8.709999999999999E-2,
0.2071,2.09},{50.73,22.15,-0.942,-0.1373,-0.3061,2.09},{51.74,6.81,-0.9938,-
8.709999999999999E-2,0.0695,2.41},{52.03,6.77,-0.9881,-0.1373,0.0691,2.42},{
51.33,6.87,-0.9938,-8.709999999999999E-2,0.0695,2.43},{52.23,6.75,-0.98,-0.1869,
0.0685,2.44},{48.7,26.87,-0.883,-0.1869,-0.4306,2.57}},[6]={{-51.77,17.1,0.9811,
-8.709999999999999E-2,-0.173,1.72},{-52.07,17.14,0.9755,-0.1373,-0.172,1.73},{-
52.27,17.16,0.9675,-0.1869,-0.1706,1.74},{-51.37,17.04,0.9811,-
8.709999999999999E-2,-0.173,1.76},{-50.37,22.05,0.9474,-8.709999999999999E-2,-
0.3078,2.09},{-50.77,22.15,0.942,-0.1373,-0.3061,2.09},{-51.77,6.81,0.9938,-
8.709999999999999E-2,0.0695,2.41},{-52.07,6.77,0.9881,-0.1373,0.0691,2.42},{-
51.37,6.87,0.9938,-8.709999999999999E-2,0.0695,2.43},{-48.74,26.87,0.883,-0.1869
,-0.4306,2.57},{-52.11,11.96,0.9938,-8.709999999999999E-2,-6.95E-2,2.75}},[7]={{
-49.57,22.76,0.9076,-0.1869,-0.375900000795,0},{-47.09,27.34,0.8578,-0.1373,-0.4953,0},{
-51.77,12.63,0.9877,-8.709999999999999E-2,-0.13,0},{-49.39,22.68,0.9151,-0.1373,
-0.3791,0},{-47.26,27.44,0.8508,-0.1869,-0.4912,0},{-49.11,22.56,0.9204,-
8.709999999999999E-2,-0.3812,0},{-52.07,12.67,0.9821,-0.1373,-0.1293,0},{-51.25,
17.81,0.9489,-0.1869,-0.2543,0},{-52.110000000533,7.49,0.9962,-8.709999999999999E-2,0,0},{
-52.27,12.7,0.974,-0.1869,-0.1282,0},{-52.41,7.49,0.9905,-0.1373,0,0},{-50.77,
17.69,0.9623,-8.709999999999999E-2,-0.2578,0}},[8]={{-47.09,19.7,0.8578,-0.1373,
-0.4953,0},{-43.97,-24.13,0.7903,-8.709999999999999E-2,0.6064,0},{-40.92,-28.35,
0.6946,-0.1869,0.6946,0},{-47.26,-20.09,0.8508,-0.1869,0.4912,0},{-47.09,-19.99,
0.8578,-0.1373,0.4953,0},{-43.97,23.84,0.7903,-8.709999999999999E-2,-0.6064,0},{
-40.92,28.06,0.6946,-0.1869,-0.6946,0},{-44.36,24.14,0.7794,-0.1869,-0.598,0},{-
44.21,24.02,0.7858,-0.1373,-0.603,0},{-46.83,19.55,0.8627,-8.709999999999999E-2,
-0.4981,0},{-40.78,-28.21,0.7004,-0.1373,0.7004,0}},[9]={{-51.25,-17.64,0.9489,-
0.1869,0.2543,0},{-47.09,-27.16,0.8578,-0.1373,0.4953,0},{-22.99,-45.66,0.2564,-
0.1373,0.9568,0},{-23.04,-45.85,0.2543,-0.1869,0.9489,0},{-47.260000000479,-27.26,0.8508,-
0.1869,0.4912,0},{-52.07,-12.5,0.9821,-0.1373,0.1293,0},{-49.57,-22.58,0.9076,-
0.1869,0.3759,0},{-49.39,-22.51,0.9151,-0.1373,0.3791,0},{-2.52,-45.37,-0.2578,-
8.709999999999999E-2,0.9623,0},{-49.11,-22.39,0.9204,-8.709999999999999E-2,
0.381200000497,0},{-52.27,-12.52,0.974,-0.1869,0.1282,0}},[10]={{-51.77,-16.03,0.9811,-
8.709999999999999E-2,0.173,1.72},{-52.07,-16.06,0.9755,-0.1373,0.172,1.73},{-
52.27,-16.09,0.9675,-0.1869,0.1706,1.74},{-51.37,-15.97,0.9811,-
8.709999999999999E-2,0.173,1.76},{-50.37,-20.97,0.9474,-8.709999999999999E-2,
0.3078,2.09},{-50.77,-21.08,0.942,-0.1373,0.3061,2.09},{-48.740000000888,-25.800000000342,0.883,-
0.1869,0.4306,2.57},{-52.41,-10.88,0.9881,-0.1373,0.0691,2.77},{-12.72,-50.58,
0.0691,-0.1373,0.9881,2.770000000603},{-12.72,-50.28,0.0691,-0.1373,0.988100000327,2.78}},[11]={{
51.74,-16.03,-0.9811,-8.709999999999999E-2,0.173,1.72},{49.07,4.19,-0.9361,-
8.709999999999999E-2,-0.3407,1.72},{49.35,4.31,-0.9308,-0.137300000502,-0.3388,1.73},{
52.03,-16.06,-0.9755,-0.1373,0.172,1.73},{49.54,4.38,-0.9231,-0.1869,-0.336,1.74
},{52.23,-16.09,-0.9675,-0.1869,0.1706,1.74},{51.33,-15.97,-0.9811,-
8.709999999999999E-2,0.173,1.760000000845},{50.73,-0.690000000942,-0.9744,-8.709999999999999E-2,-
0.2071,2.06},{51.02,-0.61,-0.9689,-0.1373,-0.2059,2.08},{51.21,-0.56,-0.9609,-
0.1869,-0.2042,2.09},{50.34,-20.97,-0.9474,-8.709999999999999E-2,0.3078,2.09},{
50.34,-0.79,-0.9744,-8.709999999999999E-2,-0.2071,2.09},{50.73,-21.08,-0.942,-
0.1373,0.3061,2.09},{51.74,-5.74,-0.9938,-8.709999999999999E-2,-6.95E-2,2.41},{
52.03,-5.7,-0.9881,-0.1373,-6.909999999999999E-2,2.42},{51.33,-5.79,-0.9938,-
8.709999999999999E-2,-6.95E-2,2.43}},[12]={{27.95,-43.27,-0.3759,-0.1869,0.9076,
0},{2.49,-44.47,0.2578,-8.709999999999999E-2,0.9623,0},{-7.26,-40.97,0.4912,-
0.1869,0.8508,0},{49.54,-21.68,-0.9076,-0.1869,0.3759,0},{49.07,-21.49,-0.9204,-
8.709999999999999E-2,0.3812,0},{32.53,27.96,-0.4953,-0.1373,-0.8578,0},{27.87,-
43.09,-0.3791,-0.1373,0.9151,0},{49.35,-21.61,-0.9151,-0.1373,0.3791,0},{47.23,-
26.36,-0.8508,-0.1869,0.491200000939,0},{-2.58,-43.27,0.3759,-0.1869,0.907600000413,0},{-2.39,-
42.81,0.3812,-8.709999999999999E-2,0.9204,0},{-2.51,-43.09,0.3791,-0.1373,0.9151
,0},{22.88,-44.47,-0.2578,-8.709999999999999E-2,0.9623,0},{22.95,-44.76,-0.2564,
-0.1373,0.9568,0},{23.01,-44.95,-0.2543,-0.1869,0.9489,0},{36.84,25.07,-0.603,-
0.1373,-0.7858,0}},[13]={{52.23,-3.99,-0.974,-0.1869,0.1282,0},{49.07,-13.86,-
0.9204,-8.709999999999999E-2,0.3812,0},{52.03,-3.96,-0.9821,-0.1373,0.1293,0},{
49.35,-13.97,-0.9151,-0.1373,0.3791,0},{49.54,-14.05,-0.9076,-0.1869,0.3759,0},{
43.93,-22.76,-0.7903,-8.709999999999999E-2,0.6064,0},{47.23,-18.73,-0.8508,-
0.1869,0.4912,0},{50.730000000434,-8.98,-0.9623,-8.709999999999999E-2,0.2578,0},{51.74,-
3.93,-0.9877,-8.709999999999999E-2,0.13,0},{51.21,-9.11,-0.9489,-0.1869,0.2543,0
},{51.02,-9.06,-0.9568,-0.1373,0.2564,0},{40.54,29.07,-0.7044,-
8.709999999999999E-2,-0.7044,0},{40.75,29.28,-0.7004,-0.1373,-0.7004,0},{36.84,-
30.27,-0.603,-0.1373,0.7858,0},{36.66,-30.04,-0.6064,-8.709999999999999E-2,
0.7903,0},{46.8,-18.48,-0.8627,-8.709999999999999E-2,0.4981,0}},[14]={{52.23,
3.18,-0.974,-0.1869,0.1282,0},{49.07,-6.69,-0.9204,-8.709999999999999E-2,0.3812,
0},{49.35,-6.8,-0.9151,-0.1373,0.3791,0},{43.93,-15.59,-0.7903,-
8.709999999999999E-2,0.606400000547,0},{47.23,-11.56,-0.8508,-0.1869,0.4912,0},{52.03,
3.21,-0.9821,-0.1373,0.1293,0},{49.54,-6.88,-0.9076,-0.1869,0.3759,0},{32.53,-
25.99,-0.4953,-0.1373,0.8578,0},{51.74,3.25,-0.9877,-8.709999999999999E-2,0.13,0
},{50.73,-1.81,-0.9623,-8.709999999999999E-2,0.257800000653,0},{51.02,-1.89,-0.9568,-
0.1373,0.2564,0},{51.21,-1.94,-0.9489,-0.1869,0.2543,0},{47.06,-11.46,-0.8578,-
0.1373,0.4953,0},{44.330000000947,-15.9,-0.7794,-0.1869,0.598,0},{32.38,-25.73,-0.4981,-
8.709999999999999E-2,0.8627,0},{46.8,-11.31,-0.8627,-8.709999999999999E-2,0.4981
,0}},[15]={{52.03,17.14,-0.9675,-0.1869,-0.1706,1.75},{49.54,-3.31,-0.9308,-
0.1373,0.3388,1.75},{51.74,17.1,-0.9755,-0.1373,-0.172,1.75},{49.35,-3.23,-
0.9361,-8.709999999999999E-2,0.3407,1.75},{51.33,17.04,-0.9811,-
8.709999999999999E-2,-0.173,1.76},{50.73,1.76,-0.9744,-8.709999999999999E-2,
0.2071,2.06},{51.02,1.68,-0.968900000636,-0.1373,0.2059,2.08},{51.21,1.63,-0.9609,-
0.1869,0.2042,2.09},{50.34,22.05,-0.9474,-8.709999999999999E-2,-0.3078,2.09},{
50.34,1.86,-0.9744,-8.709999999999999E-2,0.2071,2.09},{50.73,22.15,-0.942,-
0.1373,-0.3061,2.09},{51.74,6.81,-0.9938,-8.709999999999999E-2,0.0695,2.41},{
52.03,6.77,-0.9881,-0.1373,0.0691,2.42},{51.33,6.87,-0.9938,-
8.709999999999999E-2,0.0695,2.43},{52.23,6.75,-0.98,-0.1869,0.0685,2.44},{48.7,
26.87,-0.883,-0.1869,-0.4306,2.570000000784}},[16]={{-51.77,-16.03,0.9811,-
8.709999999999999E-2,0.173,1.72},{-52.07,-16.06,0.9755,-0.1373,0.172,1.73},{-
52.27,-16.09,0.9675,-0.1869,0.1706,1.74},{-51.37,-15.97,0.9811,-
8.709999999999999E-2,0.173,1.76},{-50.37,-20.97,0.9474,-8.709999999999999E-2,
0.3078,2.09},{-50.77,-21.08,0.942,-0.1373,0.3061,2.09},{-48.74,-25.8,0.883,-
0.1869,0.4306,2.57},{-52.41,-10.88,0.9881,-0.1373,0.0691,2.77},{-12.72,-50.58,
0.0691,-0.1373,0.9881,2.77},{-12.72,-50.28,0.0691,-0.1373,0.9881,2.78}},[17]={{-
51.25,-17.78,0.9489,-0.1869,0.254300000528,0},{-47.09,-27.3,0.8578,-0.1373,0.4953,0},{-
22.99,-45.79,0.2564,-0.1373,0.9568,0},{-23.04,-45.98,0.254300000258,-0.1869,0.9489,0},{-
47.26,-27.4,0.8508,-0.1869,0.4912,0},{-52.07,-12.63,0.9821,-0.1373,0.1293,0},{-
49.57,-22.72,0.9076,-0.1869,0.3759,0},{-49.39,-22.64,0.9151,-0.1373,0.3791,0},{-
2.52,-45.5,-0.2578,-8.709999999999999E-2,0.9623,0},{-49.11,-22.53,0.9204,-
8.709999999999999E-2,0.3812,0},{-52.27,-12.660000000951,0.974,-0.1869,0.1282,0}},[18]={{-
47.09,20.39,0.8578,-0.1373,-0.4953,0},{-40.92,-27.66,0.6946,-0.1869,0.6946,0},{-
40.92,28.76,0.6946,-0.1869,-0.6946,0},{-49.39,15.74,0.9151,-0.1373,-0.3791,0},{-
49.11,15.62,0.9204,-8.709999999999999E-2,-0.3812,0},{-43.97,-23.43,0.7903,-
8.709999999999999E-2,0.6064,0},{-43.97,24.53,0.7903,-8.709999999999999E-2,-
0.6064,0},{-47.09,-19.3,0.8578,-0.1373,0.4953,0},{-46.83,20.24,0.8627,-
8.709999999999999E-2,-0.4981,0},{-44.36,24.83,0.7794,-0.1869,-0.598,0},{-44.21,
24.71,0.7858,-0.1373,-0.603,0}},[19]={{39.76,3.72,-0.8114,0.4595,-0.3613,3.61},{
42.95,0.62,-0.8809,0.4002,-0.2526,3.93},{44.16,1.12,-0.9032,0.3422,-0.259,4.01},
{41.57,0.05,-0.8618,0.4595,-0.2149,4.82},{39.72,8.83,-0.7937,0.4002,-0.4582,5.11
}},[20]={{39.76,-22.09,-0.7937,0.4002,0.4582,0},{43.68,-2.37,-0.9086,0.4002,-
0.1196,0},{43.68,-10.53,-0.9086,0.4002,0.1196,0},{39.76,9.18,-0.7937,0.4002,-
0.4582,0},{42.88,-14.54,-0.8852,0.4002,0.2372,0},{41.57,-18.42,-0.846700000313,0.4002,
0.3507,0},{43.95,-6.45,-0.9164,0.4002,-0,0},{41.57,5.51,-0.8467,0.4002,-0.3507,0
},{42.88,1.64,-0.8852,0.4002,-0.2372,0},{44.33,-14.93,-0.9076,0.3422,0.2432,0},{
44.33,2.03,-0.9076,0.3422,-0.2432,0}},[21]={{39.76,-13.85,-0.7937,0.4002,0.4582,
0},{39.76,17.42,-0.7937,0.4002,-0.4582,0}},[22]={{41.23,1.95,-0.8618,0.4595,
0.2149,0.52},{41.23,17.25,-0.8538,0.4595,-0.2448,0.52},{42.88,17.69,-0.8809,
0.4002,-0.2526,0.55},{42.88,1.51,-0.8892,0.4002,0.2217,0.55},{44.33,1.12,-0.9117
,0.3422,0.2273,0.57},{39.99,20.91,-0.8114,0.4595,-0.3613,0.77},{41.99,5.74,-
0.8833,0.4595,0.0928,0.77},{43.68,5.52,-0.9114,0.4002,0.0958,0.82},{41.570000000676,21.57,
-0.8372,0.4002,-0.3728,0.82},{45.16,5.32,-0.9345,0.3422,0.0982,0.86},{42.24,9.6,
-0.8876,0.4595,-3.1E-2,1.03},{43.95,9.6,-0.9159,0.4002,-3.2E-2,1.09},{39.76,-
6.03,-0.809200000934,0.4002,0.4302,1.09},{39.99,-1.71,-0.8346,0.4595,0.3038,1.29},{41.99
,13.460000000573,-0.8747,0.4595,-0.1542,1.29},{41.57,-2.36,-0.8612,0.4002,0.3134,1.360000000623}},[
23]={{39.76,-3.68,-0.8114,0.4595,0.3613,3.61},{41.05,-4.43,-0.8372,0.4002,0.3728
,3.67},{42.95,-0.58,-0.8809,0.4002,0.2526,3.93},{44.16,-1.09,-0.9032,0.3422,
0.259,4.01},{41.57,-1E-2,-0.8618,0.4595,0.2149,4.82},{39.72,-8.79,-0.7937,0.4002
,0.4582,5.11}},[24]={{-42.83,0.62,0.8809,0.4002,-0.2526,3.93},{-44.04,1.120000000837,
0.9032,0.3422,-0.259,4.010000000502}},[25]={{-41.87,-1.64,0.8795,0.4595,-0.1236,0.26},{-
41.45,-17.47,0.849700000437,0.4002,0.3433,0.27},{-41.11,-13.15,0.8618,0.4595,0.2149,0.52
},{-42.76,2.59,0.8809,0.4002,-0.2526,0.55},{-42.76,-13.59,0.8892,0.4002,0.2217,
0.55},{-44.21,-13.98,0.9117,0.3422,0.2273,0.57},{-41.87,-9.36,0.8833,0.4595,
0.0928,0.77},{-43.56,-9.58,0.9114,0.4002,0.0958,0.82},{-45.04,-9.78,0.9345,
0.3422,0.0982,0.86},{-42.12,-5.5,0.8876,0.4595,-3.1E-2,1.03},{-43.83,-5.5,0.9159
,0.4002,-3.2E-2,1.09},{-43.56,-1.42,0.9025,0.4002,-0.1591,1.36}},[26]={{-42.76,-
5.59,0.8892,0.4002,0.2217,0.55},{-43.560000000305,-1.58,0.9114,0.4002,0.0958,0.82},{-43.83
,2.5,0.9159,0.4002,-3.2E-2,1.09},{-41.45,-9.47,0.8612,0.4002,0.3134,1.36},{-
41.11,-5.15,0.8688,0.4595,0.1847,1.55}},[27]={{-40.93,-6.38,0.8372,0.4002,0.3728
,3.67}},[28]={{-42.07,-5.08,0.8612,0.4002,0.3134,6.35}}},[3]={[1]={{51.74,-16.03
,-0.9811,-8.709999999999999E-2,0.173,1.72},{49.07,4.19,-0.9361,-
8.709999999999999E-2,-0.3407,1.72},{52.03,-16.06,-0.9755,-0.1373,0.172,1.730000000451},{
49.35,4.31,-0.9308,-0.1373,-0.3388,1.73},{49.54,4.38,-0.9231,-0.1869,-0.336,1.74
},{52.23,-16.09,-0.9675,-0.1869,0.1706,1.74},{51.33,-15.970000000571,-0.9811,-
8.709999999999999E-2,0.173,1.76},{50.73,-0.69,-0.9744,-8.709999999999999E-2,-
0.2071,2.06},{51.02,-0.61,-0.9689,-0.1373,-0.2059,2.08},{51.21,-0.56,-0.9609,-
0.1869,-0.2042,2.09},{50.34,-20.97,-0.9474,-8.709999999999999E-2,0.3078,2.09},{
50.34,-0.79,-0.9744,-8.709999999999999E-2,-0.2071,2.09},{50.73,-21.08,-0.942,-
0.1373,0.3061,2.09},{51.74,-5.74,-0.9938,-8.709999999999999E-2,-6.95E-2,2.41},{
52.03,-5.7,-0.9881,-0.1373,-6.909999999999999E-2,2.42},{51.33,-5.79,-0.9938,-
8.709999999999999E-2,-6.95E-2,2.43}},[2]={{2.49,-44.47,0.2578,-
8.709999999999999E-2,0.9623,0},{22.88,-44.47,-0.2578,-8.709999999999999E-2,
0.9623,0},{-7.26,-40.97,0.4912,-0.1869,0.8508,0},{27.76,-42.81,-0.3812,-
8.709999999999999E-2,0.9204,0},{22.95,-44.76,-0.2564,-0.1373,0.9568,0},{47.23,-
26.36,-0.8508,-0.1869,0.4912,0},{-2.58,-43.27,0.3759,-0.1869,0.9076,0},{-2.51,-
43.09,0.3791,-0.1373,0.9151,0},{50.34,-16.51,-0.9653,-3.62E-2,0.258700000448,0},{48.700000000529,-
21.34,-0.9233,-3.62E-2,0.3824,0},{49.07,-21.49,-0.9204,-8.709999999999999E-2,
0.381200000782,0},{51.74,-11.56,-0.9877,-8.709999999999999E-2,0.13,0},{51.02,-16.690000000118,-
0.9568,-0.1373,0.2564,0},{50.73,-16.61,-0.9623,-8.709999999999999E-2,0.2578,0},{
49.35,-21.61,-0.9151,-0.1373,0.3791,0},{49.54,-21.68,-0.9076,-0.1869,0.3759,0}},
[3]={{47.23,-18.73,-0.8508,-0.1869,0.4912,0},{36.84,-30.27,-0.603,-0.1373,0.7858
,0},{49.35,-13.97,-0.9151,-0.1373,0.3791,0},{36.97,-30.43,-0.598,-0.1869,0.7794,
0},{49.07,-13.86,-0.9204,-8.709999999999999E-2,0.3812,0},{48.7,-13.7,-0.9233,-
3.62E-2,0.3824,0},{50.73,-8.98,-0.9623,-8.709999999999999E-2,0.2578,0},{51.02,-
9.06,-0.9568,-0.1373,0.2564,0},{49.54,-14.05,-0.9076,-0.1869,0.3759,0},{51.74,-
3.93,-0.9877,-8.709999999999999E-2,0.13,0},{51.33,-3.87,-0.9908,-3.62E-2,0.1304,
0},{52.23,-3.99,-0.974,-0.1869,0.1282,0},{46.8,-18.48,-0.8627,-
8.709999999999999E-2,0.4981,0},{43.93,-22.76,-0.7903,-8.709999999999999E-2,
0.6064,0},{47.06,-18.63,-0.8578,-0.1373,0.4953,0},{40.89,-26.99,-0.6946,-0.1869,
0.6946,0}},[4]={{32.63,-26.160000000439,-0.4912,-0.1869,0.8508,0},{36.84,-23.1,-0.603,-
0.1373,0.7858,0},{47.23,-11.56,-0.8508,-0.1869,0.4912,0},{49.54,-6.88,-0.9076,-
0.1869,0.3759,0},{47.06,-11.46,-0.8578,-0.1373,0.4953,0},{46.8,-11.31,-0.8627,-
8.709999999999999E-2,0.4981,0},{49.35,-6.8,-0.9151,-0.1373,0.3791,0},{49.07,-
6.69,-0.9204,-8.709999999999999E-2,0.3812,0},{50.73,-1.81,-0.9623,-
8.709999999999999E-2,0.2578,0},{48.7,-6.53,-0.9233,-3.62E-2,0.3824,0},{51.02,-
1.89,-0.9568,-0.1373,0.2564,0},{51.33,3.3,-0.9908,-3.62E-2,0.1304,0},{43.93,-
15.59,-0.7903,-8.709999999999999E-2,0.6064,0},{44.33,-15.9,-0.7794,-0.1869,0.598
,0},{44.17,-15.78,-0.7858,-0.1373,0.603,0},{32.38,-25.73,-0.4981,-
8.709999999999999E-2,0.8627,0}},[5]={{46.44,31.45,-0.8331,-0.1869,-0.5206,1.65},
{49.54,-3.31,-0.9308,-0.1373,0.3388,1.75},{52.03,17.14,-0.9675,-0.1869,-0.1706,
1.75},{49.35,-3.23,-0.9361,-8.709999999999999E-2,0.3407,1.75},{51.74,17.1,-
0.9755,-0.1373,-0.172,1.75},{51.33,17.04,-0.9811,-8.709999999999999E-2,-0.173,
1.76},{50.73,1.76,-0.9744,-8.709999999999999E-2,0.2071,2.06},{51.02,1.68,-0.9689
,-0.1373,0.2059,2.08},{51.21,1.63,-0.9609,-0.1869,0.2042,2.09},{50.340000000221,1.86,-
0.9744,-8.709999999999999E-2,0.2071,2.09},{50.34,22.05,-0.9474,-
8.709999999999999E-2,-0.3078,2.09},{50.73,22.15,-0.942,-0.137300000894,-0.3061,2.09},{
51.74,6.81,-0.9938,-8.709999999999999E-2,0.0695,2.41},{52.03,6.77,-0.9881,-
0.1373,0.0691,2.42},{51.33,6.87,-0.9938,-8.709999999999999E-2,0.0695,2.43},{
52.23,6.75,-0.98,-0.1869,0.0685,2.44}},[6]={{-46.48,31.45,0.8331,-0.1869,-0.5206
,1.65},{-51.770000000116,17.1,0.9811,-8.709999999999999E-2,-0.173,1.720000000759},{-52.07,17.14,
0.9755,-0.1373,-0.172,1.73},{-51.37,17.04,0.9811,-8.709999999999999E-2,-0.173,
1.76},{-50.37,22.05,0.9474,-8.709999999999999E-2,-0.3078,2.09},{-50.77,22.15,
0.942,-0.1373,-0.306100000594,2.09},{-51.77,6.81,0.993800000344,-8.709999999999999E-2,0.0695,
2.41},{-52.07,6.77,0.9881,-0.1373,0.0691,2.42},{-51.37,6.87,0.9938,-
8.709999999999999E-2,0.0695,2.43},{-48.74,26.87,0.883,-0.1869,-0.4306,2.57},{-
52.11,11.96,0.9938,-8.709999999999999E-2,-6.95E-2,2.75}},[7]={{-50.37,17.58,
0.9653,-3.62E-2,-0.2587,0},{-43.97,31.47,0.7903,-8.709999999999999E-2,-0.6064,0}
,{-46.48,26.98,0.8655,-3.62E-2,-0.4997,0},{-52.410000000503,7.49,0.9905,-0.1373,0,0},{-
52.11,7.49,0.9962,-8.709999999999999E-2,0,0},{-51.25,17.81,0.9489,-0.1869,-
0.2543,0},{-50.770000000672,17.69,0.9623,-8.709999999999999E-2,-0.2578,0},{-51.06,17.76,
0.9568,-0.137300000839,-0.2564,0},{-52.27,12.7,0.974,-0.1869,-0.1282,0},{-51.77,12.63,
0.9877,-8.709999999999999E-2,-0.13,0},{-47.09,27.34,0.857800000293,-0.1373,-0.4953,0},{-
47.26,27.440000000258,0.8508,-0.1869,-0.4912,0}},[8]={{-40.92,-28.35,0.6946,-0.1869,0.6946
,0},{-40.78,27.92,0.7004,-0.1373,-0.7004,0},{-47.09,19.7,0.8578,-0.1373,-0.4953,
0},{-47.26,-20.09,0.8508,-0.1869,0.4912,0},{-43.97,-24.13,0.7903,-
8.709999999999999E-2,0.6064,0},{-44.36,-24.43,0.7794,-0.1869,0.598,0},{-40.78,-
28.21,0.7004,-0.1373,0.7004,0},{-40.92,28.06,0.6946,-0.186900000558,-0.6946,0},{-47.09,-
19.99,0.8578,-0.1373,0.4953,0},{-44.21,-24.31,0.7858,-0.1373,0.603,0},{-44.21,
24.02,0.7858,-0.1373,-0.603,0},{-44.36,24.14,0.7794,-0.1869,-0.598,0},{-43.97,
23.84,0.7903,-8.709999999999999E-2,-0.6064,0}},[9]={{-2.52,-45.37,-0.2578,-
8.709999999999999E-2,0.9623,0},{-27.79,-43.71,0.381200000769,-8.709999999999999E-2,
0.9204,0},{-27.98,-44.17,0.375900000894,-0.1869,0.9076,0},{6.98,-41.43,-0.4981,-
8.709999999999999E-2,0.8627,0},{-47.26,-27.26,0.850800000756,-0.1869,0.4912,0},{-49.11,-
22.39,0.9204,-8.709999999999999E-2,0.3812,0},{-46.83,-27.01,0.8627,-
8.709999999999999E-2,0.4981,0},{7.13,-41.69,-0.4953,-0.1373,0.8578,0},{-27.91,-
43.99,0.3791,-0.1373,0.9151,0},{-22.91,-45.37,0.2578,-8.709999999999999E-2,
0.9623,0},{2.47,-43.99,-0.3791,-0.1373,0.9151,0},{7.23,-41.86,-0.4912,-0.1869,
0.8508,0},{2.55,-44.17,-0.3759,-0.1869,0.9076,0},{2.36,-43.71,-0.3812,-
8.709999999999999E-2,0.9204,0},{-22.99,-45.66,0.2564,-0.1373,0.9568,0}},[10]={{-
51.77,-16.03,0.9811,-8.709999999999999E-2,0.173,1.72},{-52.07,-16.06,0.975500000372,-
0.137300000308,0.172000000928,1.73},{-52.27,-16.09,0.9675,-0.1869,0.1706,1.74},{-51.37,-15.97,
0.9811,-8.709999999999999E-2,0.173,1.76},{-50.37,-20.97,0.9474,-
8.709999999999999E-2,0.3078,2.090000000593},{-50.77,-21.08,0.942,-0.1373,0.3061,2.09},{-
48.74,-25.8,0.883,-0.1869,0.4306,2.57},{-52.41,-10.88,0.9881,-0.1373,0.0691,2.77
},{-12.72,-50.58,0.0691,-0.1373,0.9881,2.77},{-12.72,-50.28,0.0691,-0.1373,
0.9881,2.78}},[11]={{51.74,-16.03,-0.9811,-8.709999999999999E-2,0.173,1.72},{
49.07,4.19,-0.9361,-8.709999999999999E-2,-0.3407,1.72},{52.03,-16.06,-0.9755,-
0.1373,0.172,1.73},{49.35,4.31,-0.9308,-0.1373,-0.3388,1.73},{49.54,4.38,-0.9231
,-0.186900000771,-0.336,1.74},{52.23,-16.09,-0.9675,-0.1869,0.170600000583,1.74},{51.33,-15.97,-
0.9811,-8.709999999999999E-2,0.173,1.76},{50.73,-0.69,-0.9744,-
8.709999999999999E-2,-0.2071,2.06},{51.02,-0.61,-0.9689,-0.1373,-0.2059,2.08},{
51.21,-0.56,-0.9609,-0.1869,-0.2042,2.09},{50.34,-20.97,-0.9474,-
8.709999999999999E-2,0.3078,2.09},{50.34,-0.79,-0.9744,-8.709999999999999E-2,-
0.2071,2.09},{50.73,-21.08,-0.942,-0.1373,0.3061,2.09},{51.74,-5.74,-0.9938,-
8.709999999999999E-2,-6.95E-2,2.41},{52.03,-5.7,-0.9881,-0.1373,-
6.909999999999999E-2,2.42},{51.33,-5.79,-0.9938,-8.709999999999999E-2,-6.95E-2,
2.43}},[12]={{2.49,-44.47,0.2578,-8.709999999999999E-2,0.9623,0},{22.88,-44.47,-
0.2578,-8.709999999999999E-2,0.9623,0},{-7.26,-40.970000000592,0.4912,-0.1869,0.8508,0},{
27.76,-42.81,-0.3812,-8.709999999999999E-2,0.9204,0},{22.95,-44.76,-0.256400000707,-
0.1373,0.9568,0},{47.23,-26.36,-0.8508,-0.1869,0.4912,0},{-2.58,-43.27,0.3759,-
0.1869,0.9076,0},{-2.51,-43.09,0.3791,-0.1373,0.9151,0},{50.34,-16.51,-0.9653,-
3.62E-2,0.2587,0},{48.7,-21.34,-0.9233,-3.62E-2,0.3824,0},{49.07,-21.49,-0.9204,
-8.709999999999999E-2,0.3812,0},{51.74,-11.56,-0.9877,-8.709999999999999E-2,0.13
,0},{51.02,-16.69,-0.9568,-0.1373,0.2564,0},{50.73,-16.61,-0.9623,-
8.709999999999999E-2,0.2578,0},{49.35,-21.61,-0.9151,-0.1373,0.3791,0},{49.54,-
21.68,-0.9076,-0.1869,0.3759,0}},[13]={{47.23,-18.73,-0.8508,-0.1869,0.4912,0},{
36.84,-30.27,-0.603000000577,-0.1373,0.7858,0},{49.35,-13.97,-0.9151,-0.1373,0.3791,0},{
36.97,-30.43,-0.598,-0.1869,0.7794,0},{49.07,-13.86,-0.9204,-
8.709999999999999E-2,0.3812,0},{48.7,-13.7,-0.9233,-3.62E-2,0.3824,0},{50.73,-
8.98,-0.9623,-8.709999999999999E-2,0.2578,0},{51.02,-9.06,-0.9568,-0.1373,0.2564
,0},{49.54,-14.05,-0.9076,-0.1869,0.3759,0},{51.74,-3.93,-0.9877,-
8.709999999999999E-2,0.13,0},{51.33,-3.87,-0.9908,-3.62E-2,0.1304,0},{52.23,-
3.99,-0.974,-0.1869,0.1282,0},{46.8,-18.48,-0.8627,-8.709999999999999E-2,0.4981,
0},{43.93,-22.76,-0.7903,-8.709999999999999E-2,0.6064,0},{47.06,-18.63,-0.8578,-
0.1373,0.4953,0},{40.89,-26.99,-0.6946,-0.1869,0.694600000619,0}},[14]={{32.63,-26.16,-
0.4912,-0.1869,0.8508,0},{36.84,-23.1,-0.603,-0.1373,0.7858,0},{47.23,-11.56,-
0.8508,-0.1869,0.4912,0},{49.54,-6.88,-0.907600000295,-0.1869,0.3759,0},{47.06,-11.460000000665,-
0.8578,-0.1373,0.4953,0},{46.8,-11.31,-0.8627,-8.709999999999999E-2,0.4981,0},{
49.35,-6.8,-0.9151,-0.1373,0.3791,0},{49.07,-6.69,-0.9204,-8.709999999999999E-2,
0.3812,0},{50.73,-1.81,-0.9623,-8.709999999999999E-2,0.2578,0},{48.7,-6.53,-
0.923300000886,-3.62E-2,0.3824,0},{51.02,-1.89,-0.9568,-0.1373,0.2564,0},{51.33,3.3,-
0.9908,-3.62E-2,0.1304,0},{43.93,-15.59,-0.7903,-8.709999999999999E-2,0.6064,0},
{44.33,-15.9,-0.7794,-0.1869,0.598,0},{44.17,-15.78,-0.7858,-0.1373,0.603,0},{
32.38,-25.73,-0.4981,-8.709999999999999E-2,0.8627,0}},[15]={{46.44,31.45,-0.8331
,-0.1869,-0.5206,1.65},{49.54,-3.31,-0.9308,-0.1373,0.3388,1.75},{52.03,17.14,-
0.9675,-0.1869,-0.1706,1.75},{49.35,-3.23,-0.9361,-8.709999999999999E-2,0.3407,
1.75},{51.74,17.1,-0.9755,-0.1373,-0.172,1.75},{51.330000000531,17.040000000747,-0.9811,-
8.709999999999999E-2,-0.173,1.76},{50.73,1.76,-0.9744,-8.709999999999999E-2,
0.2071,2.06},{51.02,1.68,-0.9689,-0.1373,0.2059,2.08},{51.21,1.63,-0.9609,-
0.1869,0.2042,2.09},{50.34,1.860000000138,-0.9744,-8.709999999999999E-2,0.2071,2.09},{
50.34,22.05,-0.9474,-8.709999999999999E-2,-0.3078,2.09},{50.73,22.15,-0.942000000764,-
0.1373,-0.3061,2.09},{51.74,6.81,-0.9938,-8.709999999999999E-2,0.0695,2.41},{
52.03,6.77,-0.9881,-0.1373,0.0691,2.42},{51.33,6.87,-0.9938,-
8.709999999999999E-2,0.0695,2.43},{52.23,6.75,-0.98,-0.1869,0.0685,2.44}},[16]={
{-51.77,-16.03,0.9811,-8.709999999999999E-2,0.173,1.72},{-52.07,-16.06,0.9755,-
0.1373,0.172,1.73},{-52.270000000173,-16.09,0.9675,-0.1869,0.1706,1.74},{-51.37,-15.97,
0.9811,-8.709999999999999E-2,0.173,1.76},{-50.37,-20.97,0.9474,-
8.709999999999999E-2,0.3078,2.09},{-50.77,-21.08,0.942,-0.1373,0.3061,2.09},{-
48.74,-25.8,0.883,-0.1869,0.4306,2.57},{-52.41,-10.88,0.9881,-0.1373,0.0691,2.77
},{-12.72,-50.58,0.0691,-0.1373,0.9881,2.77},{-12.72,-50.28,0.0691,-0.1373,
0.9881,2.78}},[17]={{-2.52,-45.5,-0.2578,-8.709999999999999E-2,0.9623,0},{-27.790000000901
,-43.85,0.3812,-8.709999999999999E-2,0.9204,0},{-27.98,-44.310000000437,0.3759,-0.1869,
0.9076,0},{6.98,-41.57,-0.4981,-8.709999999999999E-2,0.8627,0},{-47.26,-27.4,
0.8508,-0.1869,0.4912,0},{-49.11,-22.53,0.9204,-8.709999999999999E-2,0.3812,0},{
-46.83,-27.15,0.8627,-8.709999999999999E-2,0.4981,0},{7.13,-41.83,-0.4953,-
0.1373,0.8578,0},{-27.91,-44.12,0.3791,-0.1373,0.9151,0},{-22.91,-45.5,0.2578,-
8.709999999999999E-2,0.9623,0},{2.47,-44.12,-0.3791,-0.1373,0.9151,0},{7.23,-42,
-0.4912,-0.1869,0.8508,0},{2.55,-44.31,-0.3759,-0.1869,0.9076,0},{2.36,-43.85,-
0.3812,-8.709999999999999E-2,0.9204,0},{-22.99,-45.79,0.256400000506,-0.1373,0.9568,0}},
[18]={{-40.92,-27.66,0.6946,-0.1869,0.6946,0},{-46.48,20.04,0.8655,-3.62E-2,-
0.4997,0},{-43.97,24.53,0.7903,-8.709999999999999E-2,-0.6064,0},{-47.26,-19.4,
0.8508,-0.1869,0.4912,0},{-43.97,-23.43,0.7903,-8.709999999999999E-2,0.6064,0},{
-40.78,-27.52,0.7004,-0.1373,0.7004,0},{-44.360000000294,-23.74,0.7794,-0.1869,0.598,0},{-
47.09,20.39,0.8578,-0.1373,-0.4953,0},{-47.09,-19.3,0.857800000849,-0.1373,0.4953,0},{-
44.21,-23.62,0.7858,-0.1373,0.603,0},{-40.78,28.61,0.7004,-0.1373,-0.7004,0},{-
44.21,24.71,0.7858,-0.1373,-0.603,0}},[19]={{39.76,3.72,-0.8114,0.459500000674,-0.3613,
3.61},{42.95,0.62,-0.8809,0.4002,-0.2526,3.93},{44.16,1.12,-0.9032,0.3422,-0.259000000907
,4.01},{41.57,0.05,-0.8618,0.4595,-0.2149,4.82},{39.72,8.83,-0.7937,0.4002,-
0.4582,5.11}},[20]={{43.95,-6.45,-0.9164,0.4002,0,0},{41.99,-2.59,-0.8806,0.459500000414
,-0.1159,0},{42.88,1.64,-0.8852,0.4002,-0.2372,0},{44.33,-14.93,-0.9076,0.3422,
0.2432,0},{41.99,-10.31,-0.8806,0.4595,0.1159,0},{44.33,2.03,-0.9076,0.3422,-
0.2432,0},{42.88,-14.54,-0.8852,0.4002,0.2372,0},{42.24,-6.45,-0.8882,0.4595,0,0
},{43.68,-2.37,-0.9086,0.4002,-0.1196,0},{39.76,-22.09,-0.7937,0.400200000212,0.4582,0},
{43.68,-10.53,-0.9086,0.4002,0.1196,0},{41.57,5.51,-0.8467,0.4002,-0.3507,0},{
41.57,-18.42,-0.8467,0.4002,0.3507,0},{39.76,9.18,-0.7937,0.4002,-0.4582,0}},[21
]={{39.76,-13.85,-0.7937,0.4002,0.4582,0},{39.76,17.42,-0.7937,0.4002,-0.4582,0}
},[22]={{41.23,1.95,-0.8618,0.4595,0.2149,0.52},{41.23,17.25,-0.8538,0.4595,-
0.2448,0.52},{42.88,17.69,-0.8809,0.4002,-0.2526,0.55},{42.88,1.51,-0.8892,
0.4002,0.221700000764,0.55},{44.33,1.12,-0.9117,0.3422,0.2273,0.57},{41.99,5.74,-0.8833,
0.4595,0.0928,0.77},{39.99,20.91,-0.8114,0.4595,-0.3613,0.77},{41.57,21.57,-
0.8372,0.4002,-0.3728,0.82},{43.68,5.52,-0.9114,0.4002,0.0958,0.82},{45.16,5.32,
-0.9345,0.3422,0.0982,0.86},{42.24,9.6,-0.8876,0.4595,-3.1E-2,1.03},{39.76,-6.03
,-0.8092,0.4002,0.4302,1.09},{43.95,9.600000000593,-0.9159,0.4002,-3.2E-2,1.09},{39.99,-
1.71,-0.8346,0.4595,0.3038,1.29},{41.99,13.46,-0.8747,0.4595,-0.1542,1.29},{
41.57,-2.36,-0.8612,0.4002,0.3134,1.36}},[23]={{39.76,-3.68,-0.8114,0.4595,
0.3613,3.61},{41.05,-4.43,-0.8372,0.4002,0.3728,3.67},{42.95,-0.58,-0.8809,
0.4002,0.2526,3.93},{44.16,-1.09,-0.9032,0.3422,0.259,4.01},{41.57,-1E-2,-0.8618
,0.4595,0.2149,4.82},{39.72,-8.79,-0.7937,0.4002,0.4582,5.11}},[24]={{-42.83,
0.62,0.8809,0.4002,-0.2526,3.93},{-44.04,1.12,0.9032,0.3422,-0.259,4.01}},[25]={
{-41.870000000323,-1.64,0.8795,0.4595,-0.1236,0.26},{-41.45,-17.47,0.8497,0.4002,0.3433,
0.27},{-41.11,-13.15,0.8618,0.4595,0.2149,0.52},{-42.76,2.59,0.8809,0.4002,-
0.2526,0.55},{-42.760000000141,-13.59,0.8892,0.4002,0.2217,0.55},{-44.21,-13.98,0.9117,
0.3422,0.2273,0.57},{-41.87,-9.36,0.8833,0.4595,0.0928,0.77},{-43.56,-9.58,
0.9114,0.4002,0.0958,0.82},{-45.04,-9.78,0.9345,0.3422,0.0982,0.86},{-42.12,-5.5
,0.8876,0.4595,-3.1E-2,1.03},{-43.83,-5.5,0.9159,0.4002,-3.2E-2,1.09},{-43.56,-
1.42,0.9025,0.4002,-0.1591,1.36}},[26]={{-42.76,-5.59,0.8892,0.4002,0.2217,0.55}
,{-41.87,-1.36,0.8833,0.4595,0.0928,0.77},{-43.560000000956,-1.58,0.9114,0.4002,0.0958,
0.82},{-43.83,2.5,0.9159,0.4002,-3.2E-2,1.09},{-41.45,-9.47,0.8612,0.4002,0.3134
,1.36},{-41.11,-5.150000000651,0.8688,0.4595,0.1847,1.55}},[27]={{-40.93,-6.38,0.8372,
0.4002,0.3728,3.67}},[28]={{-42.07,-5.08,0.8612,0.4002,0.3134,6.35}}},[4]={[1]={
{51.74,-16.03,-0.9811,-8.709999999999999E-2,0.173,1.72},{49.07,4.19,-0.9361,-
8.709999999999999E-2,-0.3407,1.72},{52.03,-16.06,-0.9755,-0.1373,0.172,1.73},{
49.35,4.31,-0.9308,-0.1373,-0.338800000432,1.73},{49.54,4.38,-0.9231,-0.1869,-0.336,1.74
},{52.23,-16.09,-0.9675,-0.1869,0.1706,1.74},{51.33,-15.97,-0.9811,-
8.709999999999999E-2,0.173,1.76},{50.730000000769,-0.69,-0.9744,-8.709999999999999E-2,-
0.2071,2.06},{51.02,-0.61,-0.9689,-0.1373,-0.2059,2.08},{51.21,-0.56,-0.9609,-
0.1869,-0.2042,2.09},{50.34,-20.97,-0.9474,-8.709999999999999E-2,0.3078,2.09},{
50.34,-0.79,-0.9744,-8.709999999999999E-2,-0.2071,2.09},{50.73,-21.08,-0.942000000125,-
0.1373,0.3061,2.09},{51.74,-5.74,-0.9938,-8.709999999999999E-2,-6.95E-2,2.41},{
52.03,-5.7,-0.9881,-0.1373,-6.909999999999999E-2,2.42},{51.33,-5.79,-0.9938,-
8.709999999999999E-2,-6.95E-2,2.43}},[2]={{47.23,-26.36,-0.8508,-0.1869,0.4912,0
},{-2.51,-43.09,0.379100000232,-0.1373,0.9151,0},{51.210000000831,-16.74,-0.9489,-0.1869,0.2543,0}
,{52.03,-11.6,-0.9821,-0.1373,0.1293,0},{50.34,-16.51,-0.9653,-3.62E-2,0.2587,0}
,{2.49,-44.47,0.2578,-8.709999999999999E-2,0.9623,0},{51.74,-11.56,-0.9877,-
8.709999999999999E-2,0.13,0},{49.35,-21.61,-0.915100000198,-0.1373,0.3791,0},{47.06,-
26.26,-0.8578,-0.1373,0.4953,0},{49.070000000727,-21.49,-0.9204,-8.709999999999999E-2,
0.3812,0},{-2.58,-43.27,0.3759,-0.1869,0.9076,0},{49.54,-21.68,-0.9076,-0.1869,
0.3759,0},{52.23,-11.63,-0.974,-0.1869,0.1282,0},{51.02,-16.69,-0.9568,-0.1373,
0.2564,0},{48.7,-21.34,-0.9233,-3.62E-2,0.3824,0},{50.73,-16.61,-0.9623,-
8.709999999999999E-2,0.2578,0}},[3]={{36.97,-30.43,-0.598,-0.1869,0.7794,0},{
49.07,-13.86,-0.9204,-8.709999999999999E-2,0.3812,0},{49.35,-13.97,-0.9151,-
0.1373,0.3791,0},{49.54,-14.05,-0.9076,-0.186900000566,0.3759,0},{52.57,1.22,-0.9824,-
0.1869,0,0},{51.21,-9.11,-0.9489,-0.1869,0.2543,0},{52.03,-3.96,-0.9821,-0.1373,
0.1293,0},{52.23,-3.99,-0.974,-0.1869,0.1282,0},{51.74,-3.93,-0.9877,-
8.709999999999999E-2,0.13,0},{47.06,-18.63,-0.8578,-0.1373,0.4953,0},{52.37,1.22
,-0.9905,-0.1373,0,0},{43.93,-22.76,-0.7903,-8.709999999999999E-2,0.6064,0},{
40.89,-26.99,-0.6946,-0.1869,0.6946,0},{36.66,-30.04,-0.6064,-
8.709999999999999E-2,0.7903,0},{40.54,-26.64,-0.7044,-8.709999999999999E-2,
0.7044,0},{36.84,-30.270000000975,-0.603,-0.1373,0.7858,0}},[4]={{52.03,3.21,-0.9821,-
0.1373,0.1293,0},{47.06,-11.46,-0.8578,-0.1373,0.4953,0},{47.23,-11.56,-0.8508,-
0.1869,0.4912,0},{52.23,3.18,-0.974,-0.1869,0.1282,0},{49.54,-6.88,-0.9076,-
0.1869,0.3759,0},{49.07,-6.69,-0.9204,-8.709999999999999E-2,0.3812,0},{49.35,-
6.8,-0.9151,-0.1373,0.3791,0},{51.21,-1.94,-0.9489,-0.1869,0.2543,0},{40.54,-
19.47,-0.7044,-8.709999999999999E-2,0.7044,0},{43.93,-15.59,-0.7903,-
8.709999999999999E-2,0.6064,0},{36.84,-23.1,-0.603,-0.1373,0.785800000316,0},{36.66,-
22.86,-0.6064,-8.709999999999999E-2,0.7903,0},{36.97,-23.26,-0.598,-0.1869,
0.7794,0},{40.89,-19.82,-0.6946,-0.1869,0.6946,0},{32.53,-25.99,-0.4953,-0.137300000652,
0.8578,0},{44.17,-15.78,-0.7858,-0.1373,0.603,0}},[5]={{46.44,31.45,-0.8331,-
0.1869,-0.5206,1.65},{49.54,-3.31,-0.9308,-0.1373,0.3388,1.75},{52.03,17.14,-
0.9675,-0.1869,-0.1706,1.75},{49.35,-3.23,-0.9361,-8.709999999999999E-2,0.3407,
1.75},{51.74,17.1,-0.9755,-0.1373,-0.172,1.75},{51.33,17.04,-0.9811,-
8.709999999999999E-2,-0.173,1.76},{50.73,1.76,-0.9744,-8.709999999999999E-2,
0.2071,2.06},{51.02,1.68,-0.9689,-0.1373,0.2059,2.08},{51.21,1.63,-0.9609,-
0.1869,0.2042,2.09},{50.34,1.86,-0.9744,-8.709999999999999E-2,0.2071,2.09},{
50.34,22.05,-0.9474,-8.709999999999999E-2,-0.3078,2.09},{50.73,22.15,-0.942,-
0.1373,-0.3061,2.09},{51.74,6.81,-0.9938,-8.709999999999999E-2,0.0695,2.41},{
52.03,6.77,-0.9881,-0.1373,0.0691,2.42},{51.33,6.87,-0.9938,-
8.709999999999999E-2,0.0695,2.430000000533},{52.23,6.750000000614,-0.98,-0.1869,0.0685,2.44}},[6]={{
-46.48,31.45,0.8331,-0.1869,-0.5206,1.65},{-51.77,17.1,0.9811,-
8.709999999999999E-2,-0.173,1.72},{-52.07,17.14,0.9755,-0.1373,-0.172,1.73},{-
51.37,17.04,0.9811,-8.709999999999999E-2,-0.173,1.76},{-50.37,22.05,0.9474,-
8.709999999999999E-2,-0.3078,2.09},{-50.77,22.15,0.942,-0.1373,-0.3061,2.09},{-
51.77,6.81,0.9938,-8.709999999999999E-2,0.0695,2.41},{-52.07,6.77,0.9881,-0.1373
,0.0691,2.42},{-51.37,6.87,0.9938,-8.709999999999999E-2,0.0695,2.43},{-48.74,
26.87,0.883,-0.1869,-0.4306,2.57},{-52.11,11.96,0.9938,-8.709999999999999E-2,-
6.95E-2,2.75}},[7]={{-52.11,7.49,0.9962,-8.709999999999999E-2,0,0},{-52.41,7.49,
0.9905,-0.1373,0,0},{-43.97,31.47,0.7903,-8.709999999999999E-2,-0.6064,0},{-
51.06,17.76,0.956800000388,-0.1373,-0.2564,0},{-46.48,26.980000000825,0.8655,-3.62E-2,-0.4997,0},{
-51.25,17.81,0.9489,-0.1869,-0.2543,0},{-46.83,27.19,0.8627,-
8.709999999999999E-2,-0.4981,0},{-47.26,27.440000000896,0.8508,-0.1869,-0.4912,0},{-49.110000000377,
22.56,0.920400000102,-8.709999999999999E-2,-0.3812,0},{-49.390000000908,22.68,0.9151,-0.1373,-
0.3791,0},{-52.07,12.67,0.9821,-0.1373,-0.1293,0},{-52.27,12.7,0.974,-0.1869,-
0.1282,0}},[8]={{-47.26,-20.09,0.8508,-0.1869,0.4912,0},{-43.97,-24.13,0.7903,-
8.709999999999999E-2,0.6064,0},{-40.78,27.92,0.7004,-0.1373,-0.7004,0},{-47.09,
19.7,0.8578,-0.1373,-0.4953,0},{-40.78,-28.21,0.7004,-0.1373,0.7004,0},{-44.36,-
24.43,0.7794,-0.1869,0.598,0},{-47.09,-19.99,0.8578,-0.1373,0.4953,0},{-40.92,
28.06,0.6946,-0.1869,-0.6946,0},{-40.92,-28.35,0.6946,-0.1869,0.6946,0},{-44.21,
-24.31,0.7858,-0.137300000629,0.603,0},{-43.97,23.84,0.7903,-8.709999999999999E-2,-
0.6064,0}},[9]={{-27.98,-44.17,0.3759,-0.1869,0.9076,0},{-2.52,-45.37,-0.2578,-
8.709999999999999E-2,0.9623,0},{7.23,-41.86,-0.4912,-0.1869,0.8508,0},{-47.26,-
27.26,0.8508,-0.1869,0.4912,0},{-49.39,-22.51,0.9151,-0.1373,0.3791,0},{-49.11,-
22.39,0.9204,-8.709999999999999E-2,0.3812,0},{-49.57,-22.58,0.9076,-0.1869,
0.375900000845,0},{-22.91,-45.37,0.2578,-8.709999999999999E-2,0.9623,0},{-27.91,-43.99,
0.3791,-0.1373,0.9151,0},{2.55,-44.17,-0.3759,-0.1869,0.9076,0},{6.98,-41.43,-
0.4981,-8.709999999999999E-2,0.8627,0},{2.47,-43.99,-0.379100000694,-0.1373,0.9151,0},{
7.13,-41.69,-0.4953,-0.1373,0.8578,0},{2.36,-43.71,-0.3812,-8.709999999999999E-2
,0.9204,0},{-22.99,-45.66,0.2564,-0.1373,0.9568,0}},[10]={{-51.77,-16.03,0.9811,
-8.709999999999999E-2,0.173,1.72},{-52.07,-16.06,0.975500000512,-0.1373,0.172,1.73},{-
52.27,-16.09,0.9675,-0.1869,0.1706,1.74},{-51.37,-15.97,0.9811,-
8.709999999999999E-2,0.173,1.76},{-50.37,-20.97,0.9474,-8.709999999999999E-2,
0.3078,2.09},{-50.77,-21.08,0.942,-0.1373,0.3061,2.09},{-48.74,-25.8,0.883,-
0.1869,0.4306,2.57},{-12.720000000138,-50.58,0.0691,-0.1373,0.9881,2.77},{-52.41,-10.88,
0.9881,-0.1373,0.0691,2.77},{-12.72,-50.28,0.0691,-0.1373,0.9881,2.78}},[11]={{
51.74,-16.03,-0.9811,-8.709999999999999E-2,0.173,1.72},{49.07,4.19,-0.9361,-
8.709999999999999E-2,-0.3407,1.72},{52.03,-16.06,-0.9755,-0.1373,0.172,1.73},{
49.35,4.31,-0.9308,-0.1373,-0.3388,1.73},{49.54,4.38,-0.9231,-0.1869,-0.336,1.74
},{52.23,-16.09,-0.9675,-0.1869,0.1706,1.74},{51.33,-15.97,-0.9811,-
8.709999999999999E-2,0.173,1.76},{50.73,-0.69,-0.9744,-8.709999999999999E-2,-
0.2071,2.06},{51.02,-0.61,-0.9689,-0.1373,-0.2059,2.08},{51.21,-0.56,-0.9609,-
0.1869,-0.2042,2.09},{50.34,-20.97,-0.9474,-8.709999999999999E-2,0.3078,2.09},{
50.34,-0.79,-0.9744,-8.709999999999999E-2,-0.2071,2.09},{50.73,-21.08,-0.942,-
0.1373,0.3061,2.09},{51.74,-5.74,-0.9938,-8.709999999999999E-2,-6.95E-2,2.41},{
52.03,-5.7,-0.9881,-0.1373,-6.909999999999999E-2,2.42},{51.33,-5.79,-0.9938,-
8.709999999999999E-2,-6.95E-2,2.43}},[12]={{49.07,-21.49,-0.9204,-
8.709999999999999E-2,0.3812,0},{51.21,-16.74,-0.9489,-0.1869,0.2543,0},{-2.51,-
43.09,0.3791,-0.1373,0.9151,0},{51.74,-11.56,-0.9877,-8.709999999999999E-2,0.13,
0},{50.34,-16.51,-0.9653,-3.62E-2,0.2587,0},{52.23,-11.63,-0.974,-0.1869,0.1282,
0},{2.49,-44.47,0.2578,-8.709999999999999E-2,0.9623,0},{52.03,-11.6,-0.9821,-
0.1373,0.1293,0},{49.54,-21.68,-0.9076,-0.1869,0.3759,0},{49.35,-21.61,-0.9151,-
0.1373,0.3791,0},{47.06,-26.26,-0.857800000175,-0.1373,0.4953,0},{23.01,-44.95,-0.2543,-
0.1869,0.9489,0},{22.95,-44.76,-0.2564,-0.1373,0.9568,0},{-2.58,-43.27,0.3759,-
0.1869,0.9076,0},{47.23,-26.36,-0.8508,-0.1869,0.4912,0},{27.76,-42.81,-0.3812,-
8.709999999999999E-2,0.9204,0}},[13]={{36.97,-30.43,-0.598,-0.1869,0.7794,0},{
49.07,-13.860000000908,-0.9204,-8.709999999999999E-2,0.3812,0},{49.35,-13.97,-0.9151,-
0.137300000142,0.3791,0},{49.54,-14.05,-0.9076,-0.1869,0.3759,0},{52.57,1.22,-0.9824,-
0.1869,0,0},{51.21,-9.11,-0.9489,-0.1869,0.2543,0},{52.03,-3.96,-0.9821,-0.1373,
0.1293,0},{52.23,-3.99,-0.974,-0.1869,0.1282,0},{51.74,-3.93,-0.9877,-
8.709999999999999E-2,0.13,0},{47.06,-18.63,-0.8578,-0.1373,0.4953,0},{52.37,1.22
,-0.9905,-0.1373,0,0},{43.93,-22.76,-0.7903,-8.709999999999999E-2,0.6064,0},{
40.890000000855,-26.99,-0.6946,-0.186900000869,0.6946,0},{36.66,-30.04,-0.6064,-
8.709999999999999E-2,0.7903,0},{40.54,-26.64,-0.7044,-8.709999999999999E-2,
0.7044,0},{36.84,-30.270000000192,-0.603,-0.1373,0.7858,0}},[14]={{52.03,3.21,-0.9821,-
0.1373,0.1293,0},{47.06,-11.46,-0.8578,-0.1373,0.4953,0},{47.23,-11.560000000731,-0.8508,-
0.1869,0.4912,0},{52.23,3.18,-0.974,-0.1869,0.1282,0},{49.54,-6.88,-0.9076,-
0.1869,0.3759,0},{49.07,-6.69,-0.9204,-8.709999999999999E-2,0.3812,0},{49.35,-
6.8,-0.9151,-0.1373,0.3791,0},{51.21,-1.94,-0.9489,-0.1869,0.2543,0},{40.54,-
19.47,-0.7044,-8.709999999999999E-2,0.7044,0},{43.93,-15.59,-0.7903,-
8.709999999999999E-2,0.6064,0},{36.84,-23.1,-0.603,-0.1373,0.7858,0},{36.66,-
22.86,-0.6064,-8.709999999999999E-2,0.7903,0},{36.97,-23.26,-0.598,-0.1869,
0.7794,0},{40.89,-19.82,-0.6946,-0.1869,0.6946,0},{32.53,-25.99,-0.4953,-0.137300000287,
0.8578,0},{44.17,-15.78,-0.7858,-0.1373,0.603,0}},[15]={{46.44,31.45,-0.8331,-
0.1869,-0.5206,1.65},{49.54,-3.31,-0.9308,-0.1373,0.3388,1.75},{52.03,17.14,-
0.9675,-0.1869,-0.1706,1.75},{49.35,-3.23,-0.9361,-8.709999999999999E-2,0.3407,
1.75},{51.74,17.1,-0.9755,-0.1373,-0.172,1.75},{51.33,17.04,-0.9811,-
8.709999999999999E-2,-0.173,1.76},{50.73,1.76,-0.9744,-8.709999999999999E-2,
0.2071,2.06},{51.02,1.68,-0.9689,-0.1373,0.2059,2.08},{51.21,1.63,-0.9609,-
0.1869,0.2042,2.09},{50.34,1.86,-0.9744,-8.709999999999999E-2,0.2071,2.09},{
50.34,22.050000000687,-0.9474,-8.709999999999999E-2,-0.3078,2.09},{50.73,22.15,-0.942,-
0.1373,-0.3061,2.09},{51.74,6.81,-0.9938,-8.709999999999999E-2,0.0695,2.41},{
52.03,6.77,-0.9881,-0.1373,0.0691,2.42},{51.33,6.87,-0.9938,-
8.709999999999999E-2,0.0695,2.43},{52.23,6.75,-0.98,-0.1869,0.0685,2.44}},[16]={
{-51.77,-16.03,0.981100000343,-8.709999999999999E-2,0.173,1.72},{-52.07,-16.06,0.9755,-
0.1373,0.172,1.73},{-52.27,-16.09,0.9675,-0.1869,0.1706,1.74},{-51.37,-15.97,
0.9811,-8.709999999999999E-2,0.173,1.76},{-50.37,-20.97,0.9474,-
8.709999999999999E-2,0.3078,2.09},{-50.77,-21.08,0.942,-0.1373,0.3061,2.09},{-
48.74,-25.8,0.883,-0.1869,0.4306,2.57},{-12.72,-50.58,0.0691,-0.1373,0.9881,2.77
},{-52.41,-10.88,0.9881,-0.1373,0.0691,2.77},{-12.72,-50.28,0.0691,-0.1373,
0.9881,2.78}},[17]={{-27.98,-44.31,0.3759,-0.1869,0.9076,0},{-2.52,-45.500000000814,-0.2578
,-8.709999999999999E-2,0.9623,0},{7.23,-42,-0.4912,-0.1869,0.8508,0},{-47.26,-
27.4,0.8508,-0.1869,0.4912,0},{-49.39,-22.64,0.9151,-0.1373,0.3791,0},{-49.11,-
22.53,0.9204,-8.709999999999999E-2,0.3812,0},{-49.57,-22.72,0.9076,-0.1869,
0.3759,0},{-22.91,-45.5,0.2578,-8.709999999999999E-2,0.9623,0},{-27.91,-44.12,
0.3791,-0.1373,0.9151,0},{2.55,-44.31,-0.3759,-0.1869,0.9076,0},{6.98,-41.57,-
0.4981,-8.709999999999999E-2,0.8627,0},{2.47,-44.12,-0.3791,-0.1373,0.9151,0},{
7.13,-41.83,-0.4953,-0.1373,0.8578,0},{2.36,-43.85,-0.3812,-8.709999999999999E-2
,0.9204,0},{-22.99,-45.79,0.2564,-0.1373,0.9568,0}},[18]={{-43.97,-23.43,0.7903,
-8.709999999999999E-2,0.6064,0},{-43.97,24.53,0.7903,-8.709999999999999E-2,-
0.6064,0},{-40.78,28.61,0.7004,-0.1373,-0.7004,0},{-46.48,20.04,0.8655,-3.62E-2,
-0.4997,0},{-47.09,20.39,0.8578,-0.1373,-0.4953,0},{-47.26,-19.4,0.8508,-0.1869,
0.4912,0},{-40.78,-27.52,0.7004,-0.1373,0.7004,0},{-44.36,-23.74,0.7794,-0.1869,
0.598,0},{-47.09,-19.3,0.8578,-0.1373,0.4953,0},{-40.92,-27.66,0.6946,-0.1869,
0.6946,0},{-44.21,-23.62,0.785800000318,-0.1373,0.603,0},{-46.83,20.24,0.8627,-
8.709999999999999E-2,-0.4981,0},{-49.39,15.74,0.9151,-0.137300000958,-0.3791,0},{-49.11,
15.620000000768,0.9204,-8.709999999999999E-2,-0.3812,0}},[19]={{39.76,3.72,-0.8114,0.4595,
-0.3613,3.61},{42.95,0.62,-0.8809,0.4002,-0.2526,3.93},{44.16,1.12,-0.9032,
0.3422,-0.259,4.01},{41.57,0.05,-0.8618,0.4595,-0.2149,4.82},{39.72,8.83,-0.7937
,0.4002,-0.4582,5.11}},[20]={{39.76,-22.09,-0.7937,0.4002,0.4582,0},{41.57,5.51,
-0.8467,0.4002,-0.3507,0},{42.24,-6.45,-0.8882,0.4595,0,0},{41.99,-2.59,-0.8806,
0.4595,-0.1159,0},{41.99,-10.31,-0.8806,0.4595,0.1159,0},{43.95,-6.45,-0.9164,
0.4002,0,0},{41.570000000184,-18.42,-0.8467,0.4002,0.3507,0},{44.33,2.03,-0.9076,0.342200000857,-
0.2432,0},{42.88,1.64,-0.8852,0.4002,-0.2372,0},{43.68,-10.53,-0.9086,0.4002,
0.1196,0},{42.88,-14.54,-0.8852,0.4002,0.2372,0},{44.33,-14.93,-0.9076,0.3422,
0.2432,0},{43.68,-2.37,-0.9086,0.4002,-0.1196,0},{39.76,9.18,-0.7937,0.4002,-
0.4582,0}},[21]={{39.76,-13.85,-0.793700000182,0.4002,0.4582,0},{39.76,17.42,-0.7937,
0.4002,-0.4582,0}},[22]={{41.23,1.95,-0.8618,0.4595,0.2149,0.52},{41.23,17.25,-
0.8538,0.4595,-0.2448,0.52},{42.88,17.69,-0.880900000672,0.4002,-0.2526,0.55},{42.88,
1.51,-0.8892,0.4002,0.2217,0.55},{44.33,1.12,-0.9117,0.3422,0.2273,0.57},{41.99,
5.74,-0.883300000847,0.4595,0.0928,0.77},{39.99,20.91,-0.8114,0.4595,-0.3613,0.77},{
41.57,21.57,-0.8372,0.4002,-0.3728,0.82},{43.68,5.52,-0.9114,0.4002,0.0958,0.82}
,{45.16,5.32,-0.9345,0.3422,0.0982,0.86},{42.24,9.6,-0.8876,0.4595,-3.1E-2,1.03}
,{39.76,-6.03,-0.8092,0.4002,0.4302,1.090000000689},{43.95,9.6,-0.9159,0.4002,-3.2E-2,1.09
},{39.99,-1.71,-0.8346,0.4595,0.3038,1.29},{41.99,13.46,-0.8747,0.4595,-0.1542,
1.29},{41.57,-2.36,-0.8612,0.4002,0.3134,1.36}},[23]={{39.76,-3.68,-0.8114,
0.4595,0.3613,3.61},{41.05,-4.43,-0.8372,0.4002,0.3728,3.67},{42.950000000775,-0.580000000681,-
0.8809,0.4002,0.2526,3.93},{44.16,-1.09,-0.9032,0.3422,0.259,4.01},{41.57,-1E-2,
-0.8618,0.4595,0.2149,4.82},{39.72,-8.79,-0.7937,0.400200000777,0.4582,5.11}},[24]={{-
42.83,0.62,0.8809,0.4002,-0.2526,3.93},{-44.04,1.12,0.9032,0.3422,-0.259,4.01}},
[25]={{-41.87,-1.64,0.8795,0.4595,-0.1236,0.26},{-41.45,-17.47,0.8497,0.4002,
0.343300000706,0.27},{-41.11,-13.15,0.8618,0.4595,0.2149,0.52},{-42.76,2.59,0.8809,
0.4002,-0.2526,0.55},{-42.76,-13.59,0.8892,0.4002,0.2217,0.55},{-44.21,-13.98,
0.9117,0.3422,0.2273,0.57},{-41.87,-9.36,0.8833,0.4595,0.0928,0.77},{-43.56,-
9.58,0.9114,0.4002,0.0958,0.82},{-45.04,-9.78,0.9345,0.3422,0.0982,0.860000000765},{-42.12
,-5.5,0.8876,0.4595,-3.1E-2,1.03},{-43.83,-5.5,0.9159,0.4002,-3.2E-2,1.090000000139},{-
43.560000000932,-1.42,0.9025,0.4002,-0.1591,1.36}},[26]={{-42.760000000102,-5.59,0.8892,0.4002,
0.2217,0.55},{-41.87,-1.36,0.8833,0.4595,0.0928,0.77},{-43.56,-1.58,0.9114,
0.4002,0.0958,0.82},{-43.83,2.5,0.9159,0.4002,-3.2E-2,1.09},{-41.45,-9.47,0.8612
,0.4002,0.3134,1.36},{-41.11,-5.15,0.8688,0.4595,0.1847,1.55}},[27]={{-40.93,-
6.38,0.8372,0.4002,0.3728,3.67}},[28]={{-42.07,-5.08,0.8612,0.4002,0.3134,6.35}}
},[5]={[1]={{51.74,-16.03,-0.9811,-8.709999999999999E-2,0.173,1.72},{49.07,4.19,
-0.9361,-8.709999999999999E-2,-0.3407,1.72},{52.03,-16.06,-0.9755,-0.1373,0.172,
1.73},{49.35,4.31,-0.9308,-0.1373,-0.3388,1.73},{49.54,4.38,-0.9231,-0.1869,-
0.336,1.74},{52.23,-16.09,-0.9675,-0.1869,0.1706,1.740000000942},{51.33,-15.970000000765,-0.9811,-
8.709999999999999E-2,0.173,1.76},{50.73,-0.69,-0.9744,-8.709999999999999E-2,-
0.2071,2.06},{51.02,-0.61,-0.9689,-0.1373,-0.2059,2.08},{51.21,-0.56,-0.9609,-
0.1869,-0.2042,2.09},{50.34,-20.97,-0.9474,-8.709999999999999E-2,0.3078,2.09},{
50.34,-0.79,-0.9744,-8.709999999999999E-2,-0.2071,2.09},{50.73,-21.08,-0.942,-
0.1373,0.3061,2.09},{51.74,-5.74,-0.9938,-8.709999999999999E-2,-6.95E-2,2.41},{
52.03,-5.7,-0.9881,-0.1373,-6.909999999999999E-2,2.42},{51.33,-5.79,-0.9938,-
8.709999999999999E-2,-6.95E-2,2.43}},[2]={{51.21,-16.74,-0.9489,-0.1869,0.2543,0
},{52.37,-6.42,-0.9905,-0.1373,-0,0},{52.57,-6.42,-0.9824,-0.1869,-0,0},{46.8,-
26.11,-0.8627,-8.709999999999999E-2,0.4981,0},{47.06,-26.26,-0.8578,-0.1373,
0.4953,0},{52.07,-6.42,-0.9962,-8.709999999999999E-2,-0,0},{52.03,-1.24,-0.9821,
-0.1373,-0.1293,0},{52.23,-1.21,-0.974,-0.1869,-0.1282,0},{51.74,-1.28,-0.9877,-
8.709999999999999E-2,-0.13,0},{51.74,-11.56,-0.9877,-8.709999999999999E-2,0.13,0
},{47.23,-26.36,-0.8508,-0.1869,0.4912,0},{51.21,3.91,-0.9489,-0.1869,-0.2543,0}
,{50.73,-16.61,-0.9623,-8.709999999999999E-2,0.2578,0},{52.03,-11.6,-0.9821,-
0.1373,0.1293,0},{49.35,-21.61,-0.9151,-0.1373,0.3791,0},{51.02,-16.69,-0.9568,-
0.1373,0.2564,0}},[3]={{40.75,-26.85,-0.7004,-0.1373,0.7004,0},{52.23,-3.99,-
0.974,-0.1869,0.1282,0},{40.89,-26.99,-0.6946,-0.1869,0.6946,0},{50.34,-8.87,-
0.9653,-3.62E-2,0.2586,0},{52.03,-3.96,-0.9821,-0.1373,0.1293,0},{44.33,-23.07,-
0.7794,-0.1869,0.598,0},{51.74,-3.93,-0.9877,-8.709999999999999E-2,0.13,0},{
44.17,-22.95,-0.7858,-0.1373,0.603000000186,0},{52.37,1.22,-0.9905,-0.1373,-0,0},{46.8,-
18.48,-0.8627,-8.709999999999999E-2,0.4981,0},{52.07,1.22,-0.9962,-
8.709999999999999E-2,-0,0},{51.21,-9.11,-0.9489,-0.1869,0.2543,0},{49.35,-13.97,
-0.9151,-0.1373,0.3791,0},{50.73,-8.98,-0.9623,-8.709999999999999E-2,0.2578,0},{
49.07,-13.86,-0.9204,-8.709999999999999E-2,0.3812,0},{47.23,-18.73,-0.8508,-
0.1869,0.4912,0}},[4]={{52.37,8.39,-0.9905,-0.1373,-0,0},{52.23,3.18,-0.974,-
0.1869,0.1282,0},{50.34,-1.7,-0.9653,-3.62E-2,0.2586,0},{44.17,-15.78,-0.785800000996,-
0.1373,0.603,0},{52.57,8.39,-0.9824,-0.1869,-0,0},{52.03,3.21,-0.9821,-0.1373,
0.1293,0},{40.89,-19.82,-0.6946,-0.1869,0.6946,0},{51.74,3.25,-0.9877,-
8.709999999999999E-2,0.13,0},{40.54,-19.47,-0.7044,-8.709999999999999E-2,0.7044,
0},{40.75,-19.68,-0.7004,-0.1373,0.7004,0},{44.33,-15.9,-0.7794,-0.1869,0.598,0}
,{50.73,-1.81,-0.9623,-8.709999999999999E-2,0.2578,0},{49.07,-6.69,-0.9204,-
8.709999999999999E-2,0.3812,0},{46.8,-11.31,-0.8627,-8.709999999999999E-2,0.4981
,0},{51.02,-1.89,-0.9568,-0.1373,0.2564,0},{47.06,-11.46,-0.8578,-0.1373,0.4953,
0}},[5]={{52.03,17.14,-0.9675,-0.1869,-0.1706,1.75},{49.54,-3.31,-0.9308,-0.1373
,0.3388,1.75},{49.35,-3.23,-0.9361,-8.709999999999999E-2,0.3407,1.75},{51.74,
17.1,-0.9755,-0.1373,-0.172,1.75},{51.33,17.04,-0.9811,-8.709999999999999E-2,-
0.173,1.76},{50.73,1.76,-0.9744,-8.709999999999999E-2,0.2071,2.06},{51.02,1.68,-
0.9689,-0.1373,0.2059,2.08},{51.21,1.63,-0.9609,-0.1869,0.2042,2.09},{50.34,
22.05,-0.9474,-8.709999999999999E-2,-0.3078,2.09},{50.34,1.86,-0.9744,-
8.709999999999999E-2,0.2071,2.09},{50.73,22.15,-0.942,-0.1373,-0.3061,2.09},{
51.74,6.81,-0.9938,-8.709999999999999E-2,0.0695,2.41},{52.03,6.77,-0.9881,-
0.1373,0.0691,2.42},{51.33,6.87,-0.9938,-8.709999999999999E-2,0.0695,2.43},{
52.23,6.75,-0.98,-0.1869,0.068500000908,2.44},{48.7,26.87,-0.883,-0.1869,-0.4306,2.57}},
[6]={{30.89,-7.75,-0.9606,-3.62E-2,0.2755,10.85},{31.71,-3.64,-0.9896,-3.62E-2,
0.1391,11.72},{31.98,0.54,-0.9993,-3.62E-2,-0,12.77},{33.79,-8.52,-0.9606,-
3.62E-2,0.2755,13.28},{32.32,-12.86,-0.9266,-3.62E-2,0.3744,13.54},{34.68,-4.03,
-0.9896,-3.62E-2,0.1391,13.74},{31.71,4.71,-0.9896,-3.62E-2,-0.1391,13.94},{
34.98,0.54,-0.999300000603,-3.62E-2,-0,14.36},{34.68,5.1,-0.9896,-3.62E-2,-0.1391,15.1},
{30.89,8.82,-0.9606,-3.62E-2,-0.2755,15.18},{32.32,13.93,-0.9266,-3.62E-2,-
0.3744,15.44},{36.69,-9.3,-0.9606,-3.62E-2,0.2755,15.9},{33.79,9.59,-0.9606,-
3.62E-2,-0.275500000871,15.92},{37.66,-4.42,-0.989600000428,-3.62E-2,0.1391,16.08},{32.89,-18.46
,-0.8655,-3.62E-2,0.4997,16.11},{35.09,-14.01,-0.9266,-3.62E-2,0.3744,16.280000000689}},[7
]={{30.89,-7.75,-0.9606,-3.62E-2,0.2755,7.6},{31.71,-3.64,-0.9896,-3.62E-2,
0.1391,8.15},{31.98,0.54,-0.9993,-3.62E-2,-0,9},{31.71,4.71,-0.9896,-3.62E-2,-
0.139100000365,10.06},{33.79,-8.52,-0.9606,-3.62E-2,0.2755,10.45},{32.32,-12.86,-0.9266,
-3.62E-2,0.3744,10.58},{34.68,-4.03,-0.9896,-3.62E-2,0.1391,10.7},{34.98,0.54,-
0.9993,-3.62E-2,-0,11.15},{30.89,8.82,-0.9606,-3.62E-2,-0.2755,11.24},{34.68,5.1
,-0.9896,-3.62E-2,-0.1391,11.76},{32.32,13.93,-0.9266,-3.62E-2,-0.3744,12.07},{
33.79,9.59,-0.9606,-3.62E-2,-0.2755,12.5},{36.69,-9.3,-0.9606,-3.62E-2,0.2755,
13.37},{37.66,-4.42,-0.9896,-3.62E-2,0.1391,13.44},{32.89,-18.46,-0.8655,-
3.62E-2,0.4997,13.49},{35.09,-14.01,-0.9266,-3.62E-2,0.3744,13.54}},[8]={{31.98,
0.54,-0.9993,-3.62E-2,-0,5.75},{31.71,4.71,-0.9896,-3.62E-2,-0.1391,5.85},{31.71
,-3.64,-0.9896,-3.62E-2,0.1391,6.13},{30.89,8.82,-0.9606,-3.62E-2,-0.2755,6.39},
{30.89,-7.75,-0.9606,-3.62E-2,0.2755,6.89},{34.98,0.54,-0.9993,-3.62E-2,-0,8.74}
,{34.68,5.1,-0.9896,-3.62E-2,-0.1391,8.79},{32.32,13.93,-0.9266,-3.62E-2,-0.3744
,8.9},{34.68,-4.03,-0.9896,-3.62E-2,0.1391,8.93},{33.79,9.59,-0.9606,-3.62E-2,-
0.2755,9.09},{32.32,-12.86,-0.9266,-3.62E-2,0.3744,9.09},{33.79,-8.52,-0.9606,-
3.62E-2,0.2755,9.34},{35.09,15.08,-0.926600000576,-3.62E-2,-0.3744,11.68},{35.09,-14.01,
-0.9266,-3.62E-2,0.3744,11.68},{37.98,0.54,-0.9993,-3.62E-2,-0,11.73},{37.66,5.5
,-0.9896,-3.62E-2,-0.1391,11.77}},[9]={{-27.98,-44.17,0.375900000625,-0.1869,0.9076,0},{
2.47,-43.99,-0.3791,-0.1373,0.9151,0},{-23.04,-45.85,0.2543,-0.1869,0.9489,0},{-
22.99,-45.66,0.2564,-0.1373,0.9568,0},{-27.79,-43.71,0.3812,-
8.709999999999999E-2,0.9204,0},{7.13,-41.69,-0.4953,-0.1373,0.8578,0},{6.98,-
41.43,-0.4981,-8.709999999999999E-2,0.862700000241,0},{-22.91,-45.37,0.2578,-
8.709999999999999E-2,0.9623,0},{-2.52,-45.37,-0.2578,-8.709999999999999E-2,
0.9623,0},{2.36,-43.71,-0.3812,-8.709999999999999E-2,0.9204,0},{-27.91,-43.99,
0.3791,-0.1373,0.915100000978,0},{2.55,-44.17,-0.3759,-0.186900000454,0.9076,0},{7.23,-41.86,-
0.4912,-0.1869,0.8508,0}},[10]={{-12.72,-50.58,0.0691,-0.1373,0.9881,2.77},{-
12.72,-50.28,0.0691,-0.1373,0.9881,2.78},{-12.72,-50.77,0.0685,-0.1869,0.98,2.78
},{-17.9,-50.24,0.2042,-0.1869,0.9609,3.13}},[11]={{51.74,-16.03,-0.9811,-
8.709999999999999E-2,0.173,1.72},{49.07,4.19,-0.9361,-8.709999999999999E-2,-
0.3407,1.72},{52.03,-16.06,-0.9755,-0.1373,0.172,1.73},{49.35,4.31,-0.9308,-
0.1373,-0.3388,1.73},{49.54,4.38,-0.9231,-0.1869,-0.336,1.74},{52.23,-16.09,-
0.9675,-0.186900000326,0.1706,1.74},{51.33,-15.97,-0.9811,-8.709999999999999E-2,0.173,
1.76},{50.73,-0.69,-0.9744,-8.709999999999999E-2,-0.2071,2.06},{51.02,-0.61,-
0.9689,-0.1373,-0.2059,2.08},{51.21,-0.56,-0.9609,-0.1869,-0.2042,2.09},{50.34,-
20.97,-0.9474,-8.709999999999999E-2,0.3078,2.09},{50.34,-0.79,-0.9744,-
8.709999999999999E-2,-0.207100000465,2.09},{50.730000000884,-21.08,-0.942,-0.1373,0.3061,2.09},{
51.74,-5.74,-0.9938,-8.709999999999999E-2,-6.95E-2,2.41},{52.03,-5.7,-0.9881,-
0.1373,-6.909999999999999E-2,2.42},{51.33,-5.79,-0.9938,-8.709999999999999E-2,-
6.95E-2,2.43}},[12]={{51.21,-16.74,-0.9489,-0.1869,0.2543,0},{52.37,-6.42,-
0.9905,-0.1373,-0,0},{52.57,-6.42,-0.9824,-0.1869,-0,0},{46.8,-26.11,-0.8627,-
8.709999999999999E-2,0.4981,0},{47.06,-26.26,-0.8578,-0.1373,0.4953,0},{52.07,-
6.42,-0.9962,-8.709999999999999E-2,-0,0},{52.03,-1.24,-0.9821,-0.1373,-0.1293,0}
,{52.23,-1.21,-0.974,-0.186900000625,-0.1282,0},{51.74,-1.28,-0.9877,-
8.709999999999999E-2,-0.13,0},{51.74,-11.56,-0.9877,-8.709999999999999E-2,0.13,0
},{47.23,-26.36,-0.8508,-0.1869,0.4912,0},{51.21,3.91,-0.9489,-0.1869,-0.2543,0}
,{50.73,-16.61,-0.9623,-8.709999999999999E-2,0.2578,0},{52.03,-11.6,-0.9821,-
0.1373,0.1293,0},{49.35,-21.61,-0.9151,-0.1373,0.3791,0},{51.02,-16.69,-0.9568,-
0.1373,0.2564,0}},[13]={{40.75,-26.85,-0.7004,-0.1373,0.7004,0},{52.23,-3.99,-
0.974,-0.1869,0.1282,0},{40.89,-26.99,-0.6946,-0.1869,0.6946,0},{50.34,-8.87,-
0.9653,-3.62E-2,0.2586,0},{52.03,-3.96,-0.9821,-0.1373,0.1293,0},{44.330000000728,-23.07,-
0.7794,-0.1869,0.598,0},{51.74,-3.93,-0.9877,-8.709999999999999E-2,0.13,0},{
44.17,-22.95,-0.7858,-0.1373,0.603000000177,0},{52.37,1.22,-0.9905,-0.1373,-0,0},{46.8,-
18.48,-0.8627,-8.709999999999999E-2,0.4981,0},{52.07,1.22,-0.9962,-
8.709999999999999E-2,-0,0},{51.21,-9.11,-0.9489,-0.1869,0.2543,0},{49.35,-13.97,
-0.9151,-0.1373,0.3791,0},{50.73,-8.98,-0.9623,-8.709999999999999E-2,0.2578,0},{
49.07,-13.86,-0.9204,-8.709999999999999E-2,0.3812,0},{47.230000000665,-18.73,-0.8508,-
0.1869,0.4912,0}},[14]={{52.37,8.39,-0.9905,-0.1373,-0,0},{52.23,3.18,-0.974,-
0.1869,0.128200000125,0},{50.34,-1.7,-0.9653,-3.62E-2,0.2586,0},{44.17,-15.780000000396,-0.7858,-
0.1373,0.603,0},{52.57,8.39,-0.9824,-0.1869,-0,0},{52.03,3.21,-0.9821,-0.1373,
0.1293,0},{40.89,-19.82,-0.6946,-0.1869,0.6946,0},{51.74,3.25,-0.9877,-
8.709999999999999E-2,0.13,0},{40.54,-19.47,-0.7044,-8.709999999999999E-2,0.7044,
0},{40.75,-19.68,-0.7004,-0.1373,0.700400000223,0},{44.33,-15.9,-0.7794,-0.1869,0.598,0}
,{50.73,-1.81,-0.9623,-8.709999999999999E-2,0.2578,0},{49.07,-6.69,-0.9204,-
8.709999999999999E-2,0.3812,0},{46.8,-11.31,-0.8627,-8.709999999999999E-2,0.4981
,0},{51.02,-1.89,-0.9568,-0.1373,0.2564,0},{47.06,-11.46,-0.8578,-0.1373,0.4953,
0}},[15]={{52.03,17.14,-0.9675,-0.1869,-0.1706,1.75},{49.54,-3.31,-0.9308,-
0.1373,0.3388,1.75},{49.35,-3.23,-0.9361,-8.709999999999999E-2,0.3407,1.75},{
51.74,17.1,-0.9755,-0.1373,-0.172,1.75},{51.33,17.04,-0.9811,-
8.709999999999999E-2,-0.173,1.76},{50.73,1.76,-0.9744,-8.709999999999999E-2,
0.2071,2.06},{51.02,1.68,-0.9689,-0.1373,0.2059,2.08},{51.21,1.63,-0.9609,-
0.1869,0.2042,2.09},{50.34,22.05,-0.9474,-8.709999999999999E-2,-0.3078,2.09},{
50.34,1.86,-0.9744,-8.709999999999999E-2,0.2071,2.09},{50.73,22.15,-0.942,-
0.1373,-0.3061,2.09},{51.74,6.81,-0.993800000606,-8.709999999999999E-2,0.0695,2.41},{
52.03,6.770000000701,-0.9881,-0.1373,0.0691,2.42},{51.330000000918,6.87,-0.9938,-
8.709999999999999E-2,0.0695,2.43},{52.23,6.75,-0.98,-0.1869,0.0685,2.44},{48.7,
26.87,-0.883,-0.1869,-0.4306,2.57}},[16]={{-12.72,-50.58,0.0691,-0.1373,0.9881,
2.77},{-12.72,-50.28,0.0691,-0.1373,0.9881,2.78},{-12.72,-50.77,0.0685,-0.186900000972,
0.98,2.78},{-17.9,-50.24,0.2042,-0.1869,0.9609,3.13}},[17]={{-27.98,-44.31,
0.3759,-0.1869,0.9076,0},{2.47,-44.12,-0.3791,-0.1373,0.9151,0},{-23.04,-45.98,
0.2543,-0.1869,0.9489,0},{-22.99,-45.79,0.2564,-0.1373,0.9568,0},{-27.79,-43.85,
0.3812,-8.709999999999999E-2,0.9204,0},{7.13,-41.83,-0.4953,-0.1373,0.8578,0},{
6.98,-41.57,-0.4981,-8.709999999999999E-2,0.8627,0},{-22.91,-45.5,0.2578,-
8.709999999999999E-2,0.9623,0},{-2.52,-45.5,-0.2578,-8.709999999999999E-2,0.9623
,0},{2.360000000974,-43.85,-0.3812,-8.709999999999999E-2,0.9204,0},{-27.91,-44.12,0.3791,-
0.1373,0.9151,0},{2.55,-44.31,-0.3759,-0.1869,0.9076,0},{7.23,-42,-0.4912,-
0.1869,0.8508,0}},[18]={{31.98,0.54,-0.9993,-3.62E-2,-0,5.71},{31.710000000503,-3.64,-
0.9896,-3.62E-2,0.1391,5.95},{31.71,4.71,-0.9896,-3.62E-2,-0.1391,5.95},{30.89,-
7.75,-0.9606,-3.62E-2,0.2755,6.6},{30.89,8.82,-0.9606,-3.62E-2,-0.2755,6.61},{
34.98,0.54,-0.9993,-3.62E-2,-0,8.71},{34.68,-4.03,-0.9896,-3.62E-2,0.1391,8.83},
{34.68,5.1,-0.9896,-3.62E-2,-0.1391,8.84},{32.32,-12.86,-0.9266,-3.62E-2,0.3744,
8.97},{32.32,13.93,-0.9266,-3.62E-2,-0.3744,8.97},{33.79,-8.52,-0.9606,-3.62E-2,
0.2755,9.18},{33.79,9.59,-0.960600000414,-3.62E-2,-0.2755,9.19},{35.09,-14.01,-0.9266,-
3.62E-2,0.3744,11.66},{35.09,15.08,-0.9266,-3.62E-2,-0.3744,11.66},{37.98,0.54,-
0.9993,-3.62E-2,-0,11.71},{37.66,-4.42,-0.9896,-3.62E-2,0.1391,11.78}},[19]={{
39.76,3.72,-0.8114,0.4595,-0.3613,3.61},{42.95,0.62,-0.8809,0.4002,-0.2526,3.93}
,{44.16,1.12,-0.9032,0.3422,-0.259,4.010000000957},{41.57,0.05,-0.8618,0.4595,-0.2149,4.82
},{39.72,8.83,-0.7937,0.400200000649,-0.4582,5.11},{42.19,5.12,-0.8747,0.4595,-0.1542,
11.91}},[20]={{44.33,-14.93,-0.9076,0.3422,0.2432,0},{39.99,4.86,-0.8206,0.4595,
-0.3399,0},{44.33,2.03,-0.9076,0.3422,-0.2432,0},{41.57,5.51,-0.8467,0.4002,-
0.3507,0},{39.99,-17.76,-0.8206,0.459500000461,0.3399,0},{43.95,-6.45,-0.9164,0.4002,-0,
0},{39.76,9.18,-0.7937,0.4002,-0.4582,0},{41.57,-18.420000000853,-0.8467,0.4002,0.3507,0},
{39.76,-22.09,-0.7937,0.4002,0.4582,0},{42.88,-14.54,-0.8852,0.4002,0.2372,0},{
42.88,1.64,-0.8852,0.4002,-0.2372,0},{43.68,-2.370000000514,-0.9086,0.4002,-0.1196,0},{
43.68,-10.53,-0.908600000922,0.4002,0.1196,0}},[21]={{39.76,-13.85,-0.7937,0.4002,0.4582
,0},{39.99,13.1,-0.8206,0.4595,-0.3399,0},{39.99,-9.53,-0.8206,0.4595,0.3399,0},
{39.76,17.42,-0.7937,0.4002,-0.4582,0}},[22]={{41.23,1.95,-0.8618,0.4595,0.2149,
0.52},{41.23,17.25,-0.8538,0.4595,-0.2448,0.52},{42.88,17.69,-0.8809,0.4002,-
0.2526,0.55},{42.880000000688,1.51,-0.8892,0.4002,0.2217,0.55},{44.33,1.12,-0.9117,0.3422,
0.2273,0.57},{41.99,5.74,-0.8833,0.4595,0.0928,0.77},{39.99,20.91,-0.8114,0.4595
,-0.3613,0.77},{43.68,5.52,-0.9114,0.4002,0.095800000723,0.82},{41.57,21.57,-0.8372,
0.4002,-0.3728,0.82},{45.16,5.32,-0.9345,0.3422,0.0982,0.86},{42.24,9.6,-0.8876,
0.4595,-3.1E-2,1.03},{43.95,9.6,-0.9159,0.4002,-3.2E-2,1.09},{39.76,-6.03,-
0.8092,0.4002,0.4302,1.09},{41.99,13.46,-0.8747,0.4595,-0.1542,1.29},{39.99,-
1.71,-0.8346,0.4595,0.3038,1.29},{43.68,13.68,-0.9025,0.400200000169,-0.1591,1.36}},[23]
={{39.76,-3.68,-0.8114,0.4595,0.3613,3.61},{41.05,-4.43,-0.837200000541,0.4002,0.3728,
3.67},{42.95,-0.58,-0.8809,0.4002,0.2526,3.93},{44.16,-1.09,-0.9032,0.3422,0.259
,4.01},{41.57,-1E-2,-0.8618,0.4595,0.2149,4.82},{39.72,-8.79,-0.7937,0.4002,
0.4582,5.11},{42.19,-5.08,-0.8747,0.4595,0.1542,11.91}},[24]={{43.48,-17.97,-
0.883,0.3422,0.3214,25.78},{40.71,-16.82,-0.8346,0.4595,0.3038,26.02},{43.68,-
5.72,-0.9025,0.4002,0.1591,27.98},{44.06,0.02,-0.9164,0.4002,-0,28.02},{43.68,
5.76,-0.907500000307,0.4002,-0.1275,28.58},{40.71,16.86,-0.8346,0.4595,-0.3038,31.6}},[
25]={{43.48,-17.97,-0.883,0.3422,0.3214,25.29},{40.71,-16.82,-0.8346,0.4595,
0.3038,25.52},{44.06,0.02,-0.9164,0.4002,-0,25.95},{43.68,-5.72,-0.9025,0.4002,
0.1591,25.98},{43.68,5.76,-0.9075,0.4002,-0.1275,26.21},{40.71,16.86,-0.8346,
0.4595,-0.3038,28.28}},[26]={{43.68,5.760000000221,-0.9075,0.4002,-0.1275,25.31},{44.06,
0.02,-0.9164,0.4002,-0,25.480000000221},{43.68,-5.72,-0.9025,0.4002,0.1591,25.61},{40.71,
16.86,-0.8346,0.4595,-0.3038,25.85},{43.48,-17.97,-0.883,0.3422,0.3214,26.9},{
40.71,-16.82,-0.8346,0.4595,0.3038,27.11}},[27]={{40.71,16.86,-0.8346,0.4595,-
0.3038,25.7},{43.68,5.76,-0.9075,0.4002,-0.1275,26.7},{44.06,0.02,-0.916400000361,0.4002
,-0,27.25},{43.68,-5.72,-0.9025,0.4002,0.1591,27.46},{43.48,-17.97,-0.883,0.3422
,0.3214,30.31},{40.71,-16.82,-0.8346,0.4595,0.3038,30.48}},[28]={{40.71,16.86,-
0.8346,0.4595,-0.3038,26.02},{43.68,5.76,-0.9075,0.4002,-0.1275,27.39},{44.060000000223,
0.020000000698,-0.916400000383,0.4002,-0,28.02},{43.68,-5.72,-0.9025,0.4002,0.1591,28.25},{43.48,-
17.97,-0.883,0.3422,0.3214,31.44},{40.71,-16.82,-0.8346,0.4595,0.3038,31.6}}},[6
]={[1]={{12.68,-50.58,-6.909999999999999E-2,-0.1373,0.9881,2.77},{12.68,-50.28,-
6.909999999999999E-2,-0.1373,0.9881,2.78},{12.68,-50.77,-6.8500000000000005E-2,-
0.1869,0.98,2.78},{17.86,-50.24,-0.2042,-0.1869,0.9609,3.13},{36.41,20.05,-
0.6573,-0.1869,-0.73,3.23}},[2]={{27.95,-43.27,-0.3759,-0.1869,0.9076,0},{2.49,-
44.470000000819,0.2578,-8.709999999999999E-2,0.9623,0},{23.01,-44.95,-0.2543,-0.1869,
0.9489,0},{22.95,-44.76,-0.2564,-0.1373,0.9568,0},{-2.39,-42.81,0.3812,-
8.709999999999999E-2,0.9204,0},{32.53,27.96,-0.4953,-0.1373,-0.8578,0},{27.76,-
42.81,-0.3812,-8.709999999999999E-2,0.9204,0},{27.87,-43.09,-0.3791,-0.1373,
0.9151,0},{-7.26,-40.97,0.4912,-0.1869,0.8508,0},{22.88,-44.47,-0.2578,-
8.709999999999999E-2,0.962300000359,0},{-2.51,-43.09,0.3791,-0.1373,0.9151,0},{-2.58,-
43.27,0.3759,-0.1869,0.9076,0},{32.38,27.7,-0.4981,-8.709999999999999E-2,-0.8627
,0},{36.84,25.07,-0.603,-0.1373,-0.7858,0},{32.63,28.13,-0.4912,-0.1869,-0.8508,
0},{36.66,24.83,-0.6064,-8.709999999999999E-2,-0.7903,0}},[3]={{-18.65,-30.65,
0.7416,-0.2504,0.6223,8.52},{10.08,-47.24,0.1685,-0.2419,0.9556,8.54},{-5.75,-
41.48,0.4841,-0.2504,0.8384,8.52},{26.23,-43.3,-0.3052,-0.1564,0.9393,7.53}},[4]
={{32.63,-26.16,-0.4912,-0.1869,0.8508,0},{32.38,-25.73,-0.4981,-
8.709999999999999E-2,0.8627,0},{32.53,-25.99,-0.4953,-0.1373,0.857800000661,0},{36.66,-
22.86,-0.6064,-8.709999999999999E-2,0.7903,0}},[5]={{36.410000000835,-18.97,-0.6573,-
0.1869,0.73,3.23}},[6]={{-46.48,31.45,0.8331,-0.1869,-0.5206,1.65},{-51.77,17.1,
0.9811,-8.709999999999999E-2,-0.173,1.72},{-52.07,17.14,0.9755,-0.1373,-0.172,
1.73},{-51.37,17.04,0.9811,-8.709999999999999E-2,-0.173,1.76},{-50.37,22.05,
0.9474,-8.709999999999999E-2,-0.3078,2.09},{-50.77,22.15,0.942,-0.1373,-0.3061,
2.090000000561},{-51.77,6.81,0.9938,-8.709999999999999E-2,0.0695,2.41},{-52.07,6.77,0.9881
,-0.1373,0.0691,2.42},{-51.37,6.87,0.9938,-8.709999999999999E-2,0.0695,2.43},{-
48.74,26.87,0.883,-0.1869,-0.4306,2.57},{-52.11,11.96,0.9938,-
8.709999999999999E-2,-6.95E-2,2.75}},[7]={{-50.37,17.580000000611,0.9653,-3.62E-2,-0.2587,
0},{-50.77,17.69,0.9623,-8.709999999999999E-2,-0.2578,0},{-51.06,17.76,0.9568,-
0.1373,-0.2564,0},{-48.74,22.41,0.9233,-3.62E-2,-0.3824,0},{-47.09,27.34,0.8578,
-0.1373,-0.4953,0},{-49.57,22.76,0.9076,-0.1869,-0.3759,0},{-51.370000000887,12.58,0.9908,
-3.62E-2,-0.1304,0},{-51.25,17.81,0.9489,-0.1869,-0.2543,0},{-43.97,31.47,0.7903
,-8.709999999999999E-2,-0.6064,0},{-52.11,7.49,0.9962,-8.709999999999999E-2,0,0}
,{-52.41,7.49,0.9905,-0.1373,0,0}},[8]={{-40.92,28.06,0.6946,-0.1869,-0.6946,0},
{-40.78,27.92,0.7004,-0.1373,-0.7004,0},{-47.09,19.7,0.8578,-0.1373,-0.4953,0},{
-47.09,-19.99,0.8578,-0.1373,0.4953,0},{-43.97,-24.13,0.7903,-
8.709999999999999E-2,0.6064,0},{-47.26,-20.09,0.8508,-0.1869,0.4912,0},{-44.36,-
24.43,0.7794,-0.1869,0.598,0},{-40.78,-28.21,0.7004,-0.1373,0.7004,0},{-44.21,-
24.31,0.7858,-0.1373,0.603,0},{-40.92,-28.35,0.6946,-0.1869,0.6946,0},{-44.36,
24.14,0.7794,-0.1869,-0.598,0}},[9]={{-27.98,-44.17,0.3759,-0.1869,0.9076,0},{-
50.77,-17.51,0.9623,-8.709999999999999E-2,0.2578,0},{-51.06,-17.59,0.9568,-
0.1373,0.2564,0},{-51.25,-17.64,0.9489,-0.1869,0.2543,0},{-48.74,-22.24,0.9233,-
3.62E-2,0.3824,0},{-50.37,-17.41,0.965300000255,-3.62E-2,0.2587,0},{-52.07,-12.5,0.9821,
-0.1373,0.1293,0},{-52.27,-12.52,0.974,-0.1869,0.1282,0},{-51.37,-12.4,0.9908,-
3.62E-2,0.1304,0},{2.55,-44.17,-0.3759,-0.1869,0.9076,0},{-49.11,-22.39,0.9204,-
8.709999999999999E-2,0.3812,0},{-23.04,-45.85,0.2543,-0.1869,0.9489,0},{-27.91,-
43.99,0.3791,-0.1373,0.9151,0},{-49.39,-22.51,0.9151,-0.1373,0.3791,0},{-27.79,-
43.71,0.3812,-8.709999999999999E-2,0.9204,0}},[10]={{-51.77,-16.03,0.9811,-
8.709999999999999E-2,0.173,1.72},{-52.07,-16.06,0.9755,-0.1373,0.172,1.73},{-
52.27,-16.09,0.967500000409,-0.1869,0.1706,1.74},{-51.37,-15.97,0.9811,-
8.709999999999999E-2,0.173,1.76},{-50.37,-20.97,0.9474,-8.709999999999999E-2,
0.3078,2.09},{-50.77,-21.08,0.942,-0.1373,0.3061,2.09},{-48.74,-25.8,0.883,-
0.1869,0.4306,2.57},{-52.41,-10.88,0.9881,-0.1373,0.0691,2.77},{-12.72,-50.58,
0.0691,-0.1373,0.9881,2.77},{-12.72,-50.28,0.0691,-0.1373,0.9881,2.78}},[11]={{
12.68,-50.58,-6.909999999999999E-2,-0.1373,0.9881,2.77},{12.680000000801,-50.280000000449,-
6.909999999999999E-2,-0.1373,0.9881,2.78},{12.68,-50.77,-6.8500000000000005E-2,-
0.1869,0.98,2.78},{17.86,-50.24,-0.2042,-0.1869,0.9609,3.13},{36.41,20.05,-
0.6573,-0.1869,-0.73,3.23}},[12]={{27.950000000715,-43.27,-0.3759,-0.1869,0.9076,0},{2.49,
-44.47,0.2578,-8.709999999999999E-2,0.9623,0},{23.01,-44.95,-0.2543,-0.1869,
0.9489,0},{22.95,-44.76,-0.2564,-0.1373,0.9568,0},{-2.39,-42.81,0.3812,-
8.709999999999999E-2,0.9204,0},{32.53,27.96,-0.4953,-0.1373,-0.8578,0},{27.76,-
42.81,-0.3812,-8.709999999999999E-2,0.920400000762,0},{27.87,-43.09,-0.3791,-0.1373,
0.9151,0},{-7.26,-40.97,0.4912,-0.1869,0.8508,0},{22.88,-44.47,-0.2578,-
8.709999999999999E-2,0.9623,0},{-2.51,-43.09,0.3791,-0.1373,0.9151,0},{-2.58,-
43.27,0.3759,-0.1869,0.9076,0},{32.38,27.7,-0.4981,-8.709999999999999E-2,-0.8627
,0},{36.84,25.07,-0.603,-0.1373,-0.7858,0},{32.63,28.13,-0.4912,-0.1869,-0.8508,
0},{36.66,24.83,-0.6064,-8.709999999999999E-2,-0.7903,0}},[13]={{-7.53,-45.5,
0.5506,0.3502,0.7578,8.33},{5.33,-50.65,0.2606,0.3256,0.9089,5.89},{18.5,-51.98,
-6.619999999999999E-2,0.3173,0.946,4.82}},[14]={{32.63,-26.16,-0.4912,-0.1869,
0.8508,0},{32.38,-25.73,-0.4981,-8.709999999999999E-2,0.8627,0},{32.53,-25.99,-
0.4953,-0.1373,0.8578,0},{36.660000000493,-22.86,-0.6064,-8.709999999999999E-2,0.7903,0}},
[15]={{36.41,-18.97,-0.6573,-0.1869,0.73,3.23}},[16]={{-51.77,-16.030000000889,0.9811,-
8.709999999999999E-2,0.173,1.72},{-52.07,-16.06,0.9755,-0.1373,0.172,1.73},{-
52.27,-16.09,0.9675,-0.1869,0.1706,1.74},{-51.37,-15.97,0.9811,-
8.709999999999999E-2,0.173,1.76},{-50.37,-20.97,0.9474,-8.709999999999999E-2,
0.3078,2.09},{-50.77,-21.08,0.942,-0.1373,0.3061,2.09},{-48.740000000931,-25.8,0.883,-
0.186900000191,0.4306,2.57},{-52.41,-10.88,0.9881,-0.1373,0.0691,2.77},{-12.72,-50.58,
0.0691,-0.1373,0.9881,2.77},{-12.72,-50.28,0.0691,-0.1373,0.9881,2.78}},[17]={{-
27.98,-44.31,0.3759,-0.1869,0.9076,0},{-50.77,-17.65,0.9623,-
8.709999999999999E-2,0.2578,0},{-51.06,-17.73,0.9568,-0.1373,0.2564,0},{-51.25,-
17.78,0.9489,-0.1869,0.2543,0},{-48.74,-22.37,0.9233,-3.62E-2,0.3824,0},{-50.37,
-17.54,0.9653,-3.62E-2,0.2587,0},{-52.07,-12.63,0.9821,-0.1373,0.1293,0},{-52.27
,-12.66,0.974,-0.1869,0.1282,0},{-51.37,-12.54,0.9908,-3.62E-2,0.1304,0},{2.55,-
44.310000000691,-0.3759,-0.1869,0.9076,0},{-49.11,-22.53,0.9204,-8.709999999999999E-2,
0.3812,0},{-23.04,-45.98,0.2543,-0.1869,0.9489,0},{-27.91,-44.12,0.3791,-0.1373,
0.9151,0},{-49.39,-22.64,0.9151,-0.1373,0.3791,0},{-27.79,-43.85,0.3812,-
8.709999999999999E-2,0.9204,0}},[18]={{-43.97,24.53,0.7903,-8.709999999999999E-2
,-0.6064,0},{-40.78,28.61,0.7004,-0.1373,-0.7004,0},{-47.09,20.39,0.8578,-0.1373
,-0.4953,0},{-48.74,15.47,0.9233,-3.62E-2,-0.3824,0},{-47.09,-19.3,0.8578,-
0.1373,0.4953,0},{-43.97,-23.43,0.7903,-8.709999999999999E-2,0.6064,0},{-40.78,-
27.52,0.7004,-0.1373,0.7004,0},{-44.21,24.71,0.7858,-0.1373,-0.603,0},{-44.36,-
23.74,0.7794,-0.1869,0.598,0},{-44.21,-23.62,0.7858,-0.1373,0.603,0},{-46.480000000244,
20.04,0.8655,-3.62E-2,-0.4997,0},{-40.920000000263,-27.66,0.6946,-0.1869,0.6946,0},{-47.26
,-19.4,0.8508,-0.1869,0.4912,0}},[19]={{-43.36,-17.97,0.883,0.3422,0.3214,25.78}
,{-43.56,-5.720000000757,0.9025,0.4002,0.1591,27.98},{-43.94,0.02,0.9164,0.4002,0,28.02}},
[20]={{-43.36,-17.97,0.883,0.3422,0.3214,25.26},{-43.94,0.02,0.9164,0.4002,0,
26.17},{-43.56,-5.72,0.9025,0.4002,0.1591,26.19}},[21]={{-43.94,0.02,0.9164,
0.4002,0,25.42},{-43.56,-5.72,0.902500000901,0.4002,0.1591,25.54},{-43.36,-17.97,0.883,
0.3422,0.3214,26.66}},[22]={{-43.940000000739,0.02,0.9164,0.4002,0,27.11},{-43.56,-5.720000000118,
0.9025,0.4002,0.1591,27.31},{-43.36,-17.97,0.883,0.3422,0.3214,30.09}},[23]={{-
43.94,0.02,0.9164,0.4002,0,28.02},{-43.56,-5.72,0.9025,0.4002,0.1591,28.25},{-
43.36,-17.97,0.883,0.3422,0.3214,31.44}},[24]={{-42.83,0.62,0.8809,0.4002,-
0.2526,3.930000000458},{-44.04,1.12,0.9032,0.3422,-0.259,4.01}},[25]={{-41.87,-1.64,0.8795
,0.4595,-0.1236,0.26},{-41.45,-17.47,0.8497,0.4002,0.3433,0.27},{-41.11,-13.15,
0.8618,0.4595,0.2149,0.52},{-42.76,2.59,0.8809,0.4002,-0.2526,0.55},{-42.76,-
13.59,0.8892,0.4002,0.2217,0.55},{-44.21,-13.98,0.9117,0.3422,0.2273,0.57},{-
41.87,-9.36,0.883300000248,0.459500000832,0.0928,0.77},{-43.56,-9.58,0.9114,0.4002,0.0958,0.82},
{-45.04,-9.78,0.9345,0.3422,0.0982,0.86},{-42.120000000872,-5.5,0.8876,0.4595,-3.1E-2,1.030000000116
},{-43.83,-5.5,0.9159,0.4002,-3.2E-2,1.09},{-43.56,-1.42,0.9025,0.4002,-0.1591,
1.36}},[26]={{-42.76,-5.59,0.8892,0.400200000335,0.2217,0.55},{-41.87,-1.36,0.8833,
0.4595,0.0928,0.77},{-43.56,-1.58,0.9114,0.4002,0.095800000324,0.82},{-43.83,2.5,0.9159,
0.4002,-3.2E-2,1.09},{-41.45,-9.47,0.8612,0.400200000196,0.3134,1.36},{-41.11,-5.15,
0.8688,0.4595,0.1847,1.55}},[27]={{-40.93,-6.38,0.8372,0.4002,0.3728,3.67}},[28]
={{-42.07,-5.08,0.8612,0.4002,0.3134,6.35}}},[7]={[1]={{12.68,-50.58,-
6.909999999999999E-2,-0.1373,0.9881,2.77},{12.68,-50.28,-6.909999999999999E-2,-
0.1373,0.9881,2.78},{12.68,-50.77,-6.8500000000000005E-2,-0.1869,0.98,2.78},{
17.86,-50.24,-0.2042,-0.1869,0.9609,3.13}},[2]={{-7.26,-40.970000000756,0.4912,-0.1869,
0.8508,0},{27.87,-43.09,-0.3791,-0.1373,0.9151,0},{22.95,-44.76,-0.2564,-0.1373,
0.9568,0},{27.76,-42.81,-0.3812,-8.709999999999999E-2,0.9204,0},{2.49,-44.47,
0.2578,-8.709999999999999E-2,0.9623,0},{22.88,-44.470000000637,-0.2578,-
8.709999999999999E-2,0.9623,0},{-2.51,-43.09,0.3791,-0.1373,0.9151,0},{-2.39,-
42.81,0.3812,-8.709999999999999E-2,0.9204,0},{-2.58,-43.27,0.3759,-0.1869,0.9076
,0},{23.01,-44.95,-0.2543,-0.1869,0.9489,0},{27.95,-43.27,-0.3759,-0.1869,0.9076
,0}},[3]={{-18.65,-30.65,0.7416,-0.2504,0.6223,8.52},{10.08,-47.24,0.1685,-
0.2419,0.9556,8.54},{-5.75,-41.48,0.4841,-0.2504,0.8384,8.52},{26.4,-44.28,-
0.3028,-0.1994,0.932,8.15}},[4]={{-12.68,-29.13,0.6223,-0.2504,0.7416,8.52},{
10.08,-39.74,0.1685,-0.2419,0.9556,8.54}},[5]={{10.08,-32.24,0.1685,-0.2419,
0.9556,8.54}},[6]={{-51.77,17.1,0.9811,-8.709999999999999E-2,-0.173,1.72},{-
52.07,17.14,0.9755,-0.1373,-0.172,1.730000000614},{-52.27,17.16,0.9675,-0.1869,-0.1706,
1.74},{-51.37,17.04,0.9811,-8.709999999999999E-2,-0.173,1.76},{-50.37,22.05,
0.9474,-8.709999999999999E-2,-0.3078,2.09},{-50.77,22.15,0.942,-0.1373,-0.3061,
2.09},{-51.77,6.81,0.9938,-8.709999999999999E-2,0.0695,2.41},{-52.07,6.77,0.9881
,-0.1373,0.0691,2.42},{-51.37,6.87,0.9938,-8.709999999999999E-2,0.0695,2.43},{-
48.74,26.87,0.883,-0.1869,-0.4306,2.57},{-52.11,11.96,0.9938,-
8.709999999999999E-2,-6.95E-2,2.75}},[7]={{-47.09,27.34,0.8578,-0.1373,-0.4953,0
},{-47.26,27.44,0.8508,-0.1869,-0.4912,0},{-52.07,12.67,0.9821,-0.1373,-0.1293,0
},{-51.25,17.81,0.9489,-0.1869,-0.2543,0},{-52.11,7.49,0.9962,-
8.709999999999999E-2,0,0},{-49.39,22.68,0.9151,-0.1373,-0.3791,0},{-49.11,22.56,
0.9204,-8.709999999999999E-2,-0.3812,0},{-49.57,22.76,0.9076,-0.1869,-0.3759,0},
{-52.27,12.7,0.974,-0.1869,-0.1282,0},{-51.06,17.76,0.9568,-0.1373,-0.2564,0},{-
50.77,17.69,0.9623,-8.709999999999999E-2,-0.2578,0},{-51.77,12.63,0.9877,-
8.709999999999999E-2,-0.13,0}},[8]={{-47.090000000664,19.7,0.8578,-0.1373,-0.4953,0},{-
43.97,-24.13,0.7903,-8.709999999999999E-2,0.6064,0},{-44.36,24.14,0.7794,-0.1869
,-0.598,0},{-44.36,-24.43,0.7794,-0.1869,0.598,0},{-47.09,-19.99,0.8578,-0.1373,
0.4953,0},{-47.26,-20.09,0.8508,-0.1869,0.4912,0},{-44.21,24.02,0.7858,-0.1373,-
0.603,0},{-46.83,19.55,0.8627,-8.709999999999999E-2,-0.4981,0},{-43.970000000731,23.84,
0.7903,-8.709999999999999E-2,-0.6064,0},{-40.92,-28.35,0.6946,-0.1869,0.6946,0}}
,[9]={{2.36,-43.71,-0.3812,-8.709999999999999E-2,0.9204,0},{-27.91,-43.99,0.3791
,-0.1373,0.9151,0},{-27.79,-43.71,0.3812,-8.709999999999999E-2,0.920400000995,0},{-2.52,
-45.37,-0.2578,-8.709999999999999E-2,0.9623,0},{-47.09,-27.16,0.8578,-0.137300000841,
0.4953,0},{-47.26,-27.26,0.8508,-0.1869,0.4912,0},{-27.98,-44.17,0.3759,-0.1869,
0.9076,0},{-23.04,-45.85,0.2543,-0.1869,0.9489,0},{-22.910000000992,-45.37,0.2578,-
8.709999999999999E-2,0.9623,0},{-52.07,-12.5,0.9821,-0.1373,0.1293,0},{-22.99,-
45.660000000656,0.2564,-0.1373,0.9568,0},{-51.25,-17.64,0.9489,-0.1869,0.2543,0}},[10]={{-
51.77,-16.03,0.9811,-8.709999999999999E-2,0.173,1.72},{-52.07,-16.06,0.9755,-
0.1373,0.172,1.73},{-52.27,-16.09,0.9675,-0.1869,0.1706,1.740000000989},{-51.37,-15.97,
0.9811,-8.709999999999999E-2,0.173,1.76},{-50.37,-20.97,0.9474,-
8.709999999999999E-2,0.3078,2.09},{-50.77,-21.08,0.942,-0.1373,0.3061,2.09},{-
48.74,-25.8,0.883,-0.1869,0.4306,2.57},{-12.72,-50.58,0.0691,-0.1373,0.9881,2.77
},{-52.41,-10.88,0.988100000626,-0.1373,0.0691,2.77},{-12.72,-50.28,0.069100000559,-0.1373,
0.9881,2.78}},[11]={{12.68,-50.58,-6.909999999999999E-2,-0.1373,0.9881,2.77},{
12.680000000504,-50.28,-6.909999999999999E-2,-0.1373,0.9881,2.78},{12.68,-50.77,-
6.8500000000000005E-2,-0.1869,0.98,2.78},{17.86,-50.24,-0.2042,-0.1869,0.9609,
3.13}},[12]={{-7.26,-40.97,0.4912,-0.1869,0.8508,0},{27.87,-43.09,-0.3791,-
0.1373,0.9151,0},{22.95,-44.76,-0.2564,-0.137300000125,0.9568,0},{27.76,-42.81,-0.3812,-
8.709999999999999E-2,0.9204,0},{2.49,-44.47,0.2578,-8.709999999999999E-2,0.9623,
0},{22.88,-44.47,-0.2578,-8.709999999999999E-2,0.9623,0},{-2.51,-43.09,0.3791,-
0.1373,0.9151,0},{-2.39,-42.81,0.3812,-8.709999999999999E-2,0.9204,0},{-2.58,-
43.27,0.3759,-0.1869,0.9076,0},{23.01,-44.95,-0.2543,-0.1869,0.9489,0},{27.95,-
43.27,-0.3759,-0.1869,0.9076,0}},[13]={{-7.53,-45.5,0.5506,0.3502,0.7578,8.33},{
5.33,-50.65,0.2606,0.3256,0.9089,5.89},{18.5,-51.98,-6.619999999999999E-2,0.3173
,0.946,4.82}},[14]={{-7.53,-45.5,0.5506,0.3502,0.7578,8.33},{5.33,-50.65,0.2606,
0.3256,0.9089,5.89},{18.5,-51.98,-6.619999999999999E-2,0.3173,0.946,4.82}},[15]=
{{-7.53,-45.5,0.5506,0.3502,0.7578,8.33},{5.33,-50.65,0.2606,0.3256,0.9089,5.89}
,{18.5,-51.98,-6.619999999999999E-2,0.3173,0.946,4.82}},[16]={{-51.77,-16.03,
0.9811,-8.709999999999999E-2,0.173,1.72},{-52.07,-16.06,0.9755,-0.1373,0.172,
1.73},{-52.27,-16.09,0.9675,-0.1869,0.1706,1.740000000259},{-51.37,-15.97,0.9811,-
8.709999999999999E-2,0.173,1.76},{-50.37,-20.97,0.9474,-8.709999999999999E-2,
0.3078,2.09},{-50.77,-21.08,0.942,-0.1373,0.3061,2.09},{-48.740000000906,-25.8,0.883,-
0.1869,0.4306,2.57},{-12.72,-50.58,0.0691,-0.1373,0.9881,2.77},{-52.41,-10.88,
0.9881,-0.1373,0.0691,2.77},{-12.72,-50.28,0.0691,-0.1373,0.9881,2.78}},[17]={{
2.36,-43.85,-0.3812,-8.709999999999999E-2,0.9204,0},{-27.91,-44.12,0.3791,-
0.137300000167,0.9151,0},{-27.79,-43.850000000369,0.3812,-8.709999999999999E-2,0.9204,0},{-2.52,-
45.5,-0.2578,-8.709999999999999E-2,0.9623,0},{-47.09,-27.3,0.8578,-0.1373,0.4953
,0},{-47.26,-27.4,0.8508,-0.1869,0.4912,0},{-27.98,-44.31,0.3759,-0.1869,0.9076,
0},{-23.04,-45.98,0.2543,-0.1869,0.9489,0},{-22.91,-45.5,0.2578,-
8.709999999999999E-2,0.9623,0},{-52.07,-12.63,0.9821,-0.137300000389,0.1293,0},{-22.99,-
45.79,0.2564,-0.1373,0.9568,0},{-51.25,-17.78,0.9489,-0.1869,0.2543,0}},[18]={{-
47.09,20.39,0.8578,-0.1373,-0.4953,0},{-43.97,-23.43,0.7903,-
8.709999999999999E-2,0.6064,0},{-44.36,24.83,0.7794,-0.1869,-0.598,0},{-44.36,-
23.74,0.7794,-0.1869,0.598,0},{-47.26,-19.4,0.8508,-0.1869,0.4912,0},{-47.09,-
19.3,0.8578,-0.1373,0.4953,0},{-43.97,24.53,0.7903,-8.709999999999999E-2,-0.6064
,0},{-46.83,20.24,0.8627,-8.709999999999999E-2,-0.4981,0},{-44.21,24.71,0.7858,-
0.1373,-0.603,0},{-49.11,15.62,0.9204,-8.709999999999999E-2,-0.3812,0},{-40.92,-
27.66,0.6946,-0.1869,0.6946,0}},[19]={{-43.360000000973,-17.97,0.883,0.3422,0.3214,25.78},
{-43.56,-5.72,0.9025,0.4002,0.1591,27.98},{-43.94,0.02,0.9164,0.4002,-0,28.02}},
[20]={{-43.36,-17.97,0.883,0.3422,0.3214,25.26},{-43.94,0.02,0.9164,0.4002,-0,
26.17},{-43.56,-5.72,0.9025,0.4002,0.1591,26.19}},[21]={{-43.94,0.02,0.9164,
0.4002,-0,25.42},{-43.56,-5.72,0.9025,0.4002,0.1591,25.54},{-43.36,-17.97,0.883,
0.3422,0.3214,26.66}},[22]={{-43.94,0.02,0.9164,0.4002,-0,27.11},{-43.56,-5.72,
0.9025,0.4002,0.1591,27.31},{-43.36,-17.97,0.883,0.3422,0.3214,30.09}},[23]={{-
43.94,0.02,0.9164,0.4002,-0,28.02},{-43.56,-5.72,0.9025,0.4002,0.1591,28.25},{-
43.36,-17.97,0.883,0.3422,0.3214,31.44}},[24]={{-42.83,0.62,0.8809,0.4002,-
0.2526,3.93},{-44.04,1.12,0.9032,0.3422,-0.259,4.01}},[25]={{-41.870000000877,-1.64,0.8795
,0.4595,-0.1236,0.26},{-41.45,-17.47,0.8497,0.4002,0.3433,0.27},{-41.11,-13.15,
0.8618,0.4595,0.2149,0.52},{-42.76,2.59,0.8809,0.4002,-0.2526,0.55},{-42.76,-
13.59,0.8892,0.4002,0.2217,0.55},{-44.21,-13.98,0.9117,0.3422,0.2273,0.57},{-
41.87,-9.36,0.8833,0.4595,0.0928,0.77},{-43.56,-9.58,0.9114,0.4002,0.0958,0.82},
{-45.04,-9.78,0.9345,0.3422,0.0982,0.86},{-42.12,-5.5,0.8876,0.4595,-3.1E-2,1.03
},{-43.83,-5.5,0.9159,0.4002,-3.2E-2,1.09},{-43.56,-1.42,0.9025,0.4002,-0.1591,
1.36}},[26]={{-42.76,-5.59,0.8892,0.4002,0.2217,0.55},{-43.56,-1.58,0.9114,
0.4002,0.0958,0.82},{-43.83,2.5,0.9159,0.4002,-3.2E-2,1.09},{-41.45,-9.47,0.8612
,0.4002,0.3134,1.36},{-41.11,-5.15,0.8688,0.4595,0.1847,1.55}},[27]={{-40.930000000429,-
6.38,0.8372,0.4002,0.3728,3.67}},[28]={{-42.07,-5.08,0.8612,0.4002,0.3134,6.35}}
},[8]={[1]={{51.74,-16.03,-0.9811,-8.709999999999999E-2,0.173,1.72},{49.070000000273,4.19,
-0.9361,-8.709999999999999E-2,-0.3407,1.72},{52.03,-16.060000000425,-0.9755,-0.1373,0.172,
1.730000000285},{49.35,4.31,-0.930800000753,-0.1373,-0.3388,1.73},{49.54,4.38,-0.9231,-0.1869,-
0.336,1.74},{52.23,-16.09,-0.9675,-0.1869,0.1706,1.74},{51.33,-15.97,-0.9811,-
8.709999999999999E-2,0.173,1.76},{50.73,-0.69,-0.9744,-8.709999999999999E-2,-
0.2071,2.06},{51.02,-0.61,-0.9689,-0.1373,-0.2059,2.08},{51.21,-0.56,-0.9609,-
0.1869,-0.2042,2.09},{50.34,-0.79,-0.9744,-8.709999999999999E-2,-0.2071,2.09},{
50.34,-20.97,-0.9474,-8.709999999999999E-2,0.3078,2.09},{50.73,-21.08,-0.942,-
0.1373,0.3061,2.09},{51.74,-5.74,-0.9938,-8.709999999999999E-2,-6.95E-2,2.41},{
52.03,-5.7,-0.9881,-0.1373,-6.909999999999999E-2,2.42},{51.33,-5.79,-0.9938,-
8.709999999999999E-2,-6.95E-2,2.43}},[2]={{47.23,-26.36,-0.8508,-0.1869,0.4912,0
},{52.03,-11.6,-0.9821,-0.1373,0.1293,0},{27.87,-43.09,-0.3791,-0.1373,0.9151,0}
,{52.03,-1.24,-0.9821,-0.1373,-0.1293,0},{27.95,-43.27,-0.3759,-0.1869,0.9076,0}
,{51.21,-16.74,-0.9489,-0.1869,0.2543,0},{27.76,-42.81,-0.3812,-
8.709999999999999E-2,0.9204,0},{22.95,-44.76,-0.2564,-0.1373,0.9568,0},{47.06,-
26.26,-0.8578,-0.1373,0.4953,0},{23.01,-44.95,-0.2543,-0.1869,0.9489,0},{22.88,-
44.470000000581,-0.2578,-8.709999999999999E-2,0.9623,0},{52.23,-1.21,-0.974,-0.1869,-
0.1282,0},{52.57,-6.420000000543,-0.9824,-0.1869,0,0},{52.37,-6.42,-0.9905,-0.1373,0,0},{
52.07,-6.42,-0.9962,-8.709999999999999E-2,0,0},{51.74,-11.56,-0.9877,-
8.709999999999999E-2,0.13,0}},[3]={{44.33,-23.07,-0.7794,-0.1869,0.598,0},{47.06
,-18.63,-0.8578,-0.1373,0.4953,0},{52.03,-3.96,-0.9821,-0.1373,0.1293,0},{51.21,
-9.11,-0.9489,-0.1869,0.2543,0},{47.23,-18.730000000626,-0.8508,-0.1869,0.4912,0},{51.02,-
9.06,-0.9568,-0.1373,0.2564,0},{36.66,-30.04,-0.6064,-8.709999999999999E-2,
0.7903,0},{50.73,-8.98,-0.9623,-8.709999999999999E-2,0.2578,0},{52.23,-3.99,-
0.974,-0.1869,0.1282,0},{51.74,-3.93,-0.9877,-8.709999999999999E-2,0.13,0},{
36.84,-30.27,-0.603,-0.1373,0.7858,0},{52.57,1.22,-0.9824,-0.1869,0,0},{49.07,-
13.86,-0.9204,-8.709999999999999E-2,0.3812,0},{36.97,-30.43,-0.598,-0.1869,
0.7794,0},{49.350000000395,-13.97,-0.9151,-0.1373,0.3791,0},{43.93,-22.76,-0.7903,-
8.709999999999999E-2,0.6064,0}},[4]={{44.33,-15.9,-0.7794,-0.1869,0.598,0},{
51.21,-1.94,-0.9489,-0.1869,0.2543,0},{52.03,3.21,-0.9821,-0.1373,0.1293,0},{
32.53,-25.99,-0.4953,-0.1373,0.8578,0},{32.63,-26.16,-0.4912,-0.1869,0.8508,0},{
32.38,-25.73,-0.4981,-8.709999999999999E-2,0.8627,0},{47.06,-11.46,-0.8578,-
0.1373,0.4953,0},{47.23,-11.56,-0.8508,-0.1869,0.4912,0},{49.07,-6.69,-0.9204,-
8.709999999999999E-2,0.3812,0},{51.02,-1.89,-0.9568,-0.1373,0.2564,0},{52.23,
3.18,-0.974,-0.1869,0.1282,0},{50.73,-1.81,-0.9623,-8.709999999999999E-2,0.2578,
0},{36.66,-22.86,-0.6064,-8.709999999999999E-2,0.7903,0},{49.54,-6.88,-0.9076,-
0.1869,0.3759,0},{36.84,-23.1,-0.603,-0.1373,0.7858,0},{43.93,-15.59,-0.7903,-
8.709999999999999E-2,0.6064,0}},[5]={{46.44,31.45,-0.8331,-0.1869,-0.5206,1.650000000295},
{49.54,-3.31,-0.9308,-0.1373,0.3388,1.75},{52.03,17.140000000383,-0.9675,-0.1869,-0.1706,
1.75},{49.35,-3.23,-0.9361,-8.709999999999999E-2,0.3407,1.75},{51.74,17.1,-
0.975500000467,-0.1373,-0.172,1.75},{51.33,17.04,-0.9811,-8.709999999999999E-2,-0.173,
1.76},{50.73,1.76,-0.9744,-8.709999999999999E-2,0.2071,2.06},{51.02,1.68,-0.9689
,-0.1373,0.2059,2.08},{51.21,1.63,-0.9609,-0.1869,0.2042,2.09},{50.34,1.86,-
0.9744,-8.709999999999999E-2,0.2071,2.09},{50.34,22.05,-0.9474,-
8.709999999999999E-2,-0.3078,2.09},{50.73,22.15,-0.942,-0.1373,-0.3061,2.09},{
51.74,6.81,-0.9938,-8.709999999999999E-2,0.0695,2.41},{52.03,6.77,-0.9881,-
0.1373,0.0691,2.42},{51.33,6.87,-0.9938,-8.709999999999999E-2,0.0695,2.43},{
52.23,6.75,-0.98,-0.1869,0.0685,2.44}},[6]={{30.89,-7.75,-0.9606,-3.62E-2,0.2755
,10.85},{31.71,-3.64,-0.9896,-3.62E-2,0.1391,11.72},{31.98,0.54,-0.9993,-3.62E-2
,0,12.77},{33.79,-8.52,-0.9606,-3.62E-2,0.2755,13.28},{32.32,-12.86,-0.9266,-
3.62E-2,0.3744,13.54},{34.68,-4.03,-0.9896,-3.62E-2,0.1391,13.74},{31.71,4.71,-
0.9896,-3.62E-2,-0.1391,13.94},{34.98,0.54,-0.9993,-3.62E-2,0,14.36},{34.68,5.1,
-0.9896,-3.62E-2,-0.1391,15.1},{30.89,8.82,-0.9606,-3.62E-2,-0.2755,15.18},{
36.69,-9.3,-0.9606,-3.62E-2,0.2755,15.9},{33.79,9.59,-0.9606,-3.62E-2,-0.2755,
15.92},{37.66,-4.42,-0.9896,-3.62E-2,0.1391,16.080000000485},{32.89,-18.46,-0.8655,-
3.62E-2,0.4997,16.11},{35.09,-14.01,-0.9266,-3.62E-2,0.3744,16.28},{37.98,0.54,-
0.9993,-3.62E-2,0,16.36}},[7]={{30.89,-7.75,-0.9606,-3.62E-2,0.2755,7.6},{31.71,
-3.64,-0.9896,-3.62E-2,0.1391,8.15},{31.98,0.54,-0.9993,-3.62E-2,0,9},{31.71,
4.71,-0.9896,-3.62E-2,-0.1391,10.06},{33.79,-8.52,-0.9606,-3.62E-2,0.2755,10.45}
,{32.32,-12.86,-0.9266,-3.62E-2,0.3744,10.58},{34.68,-4.03,-0.9896,-3.62E-2,
0.1391,10.7},{34.98,0.54,-0.9993,-3.62E-2,0,11.15},{30.89,8.82,-0.9606,-3.62E-2,
-0.2755,11.24},{34.68,5.1,-0.9896,-3.62E-2,-0.1391,11.76},{33.79,9.59,-0.9606,-
3.62E-2,-0.2755,12.5},{36.69,-9.3,-0.9606,-3.62E-2,0.2755,13.37},{37.66,-4.42,-
0.9896,-3.62E-2,0.1391,13.44},{32.89,-18.46,-0.8655,-3.62E-2,0.4997,13.49},{
35.09,-14.01,-0.9266,-3.62E-2,0.3744,13.54},{35.09,15.08,-0.9266,-3.62E-2,-
0.3744,13.61}},[8]={{31.98,0.54,-0.9993,-3.62E-2,0,5.75},{31.71,4.71,-0.9896,-
3.62E-2,-0.1391,5.85},{31.71,-3.64,-0.9896,-3.62E-2,0.1391,6.13},{30.89,8.82,-
0.9606,-3.62E-2,-0.2755,6.39},{30.89,-7.75,-0.9606,-3.62E-2,0.2755,6.89},{34.98,
0.54,-0.9993,-3.62E-2,0,8.74},{34.68,5.1,-0.9896,-3.62E-2,-0.139100000224,8.79},{34.68,-
4.03,-0.9896,-3.62E-2,0.1391,8.93},{33.79,9.59,-0.9606,-3.62E-2,-0.2755,9.09},{
32.32,-12.86,-0.9266,-3.62E-2,0.374400000677,9.09},{33.79,-8.52,-0.9606,-3.62E-2,0.2755,
9.34},{35.09,15.08,-0.9266,-3.62E-2,-0.3744,11.68},{35.09,-14.01,-0.9266,-
3.62E-2,0.3744,11.68},{37.98,0.54,-0.9993,-3.62E-2,0,11.73},{37.66,5.5,-0.9896,-
3.62E-2,-0.139100000269,11.77},{37.66,-4.42,-0.9896,-3.62E-2,0.1391,11.82}},[9]={{7.23,-
41.860000000494,-0.4912,-0.1869,0.8508,0},{-27.910000000679,-43.99,0.3791,-0.1373,0.9151,0},{-22.99,
-45.66,0.256400000246,-0.1373,0.9568,0},{-22.91,-45.37,0.2578,-8.709999999999999E-2,
0.9623,0},{2.36,-43.71,-0.3812,-8.709999999999999E-2,0.9204,0},{-2.52,-45.37,-
0.2578,-8.709999999999999E-2,0.9623,0},{2.55,-44.17,-0.3759,-0.1869,0.9076,0},{
2.47,-43.99,-0.3791,-0.1373,0.9151,0},{6.98,-41.43,-0.4981,-8.709999999999999E-2
,0.8627,0},{7.13,-41.69,-0.4953,-0.1373,0.8578,0},{-27.79,-43.71,0.3812,-
8.709999999999999E-2,0.9204,0},{-23.04,-45.85,0.2543,-0.1869,0.9489,0},{-27.98,-
44.17,0.3759,-0.1869,0.9076,0}},[10]={{-12.72,-50.58,0.0691,-0.1373,0.9881,2.77}
,{-12.72,-50.28,0.0691,-0.1373,0.9881,2.78},{-12.72,-50.77,0.0685,-0.1869,0.98,
2.78},{-17.9,-50.24,0.2042,-0.1869,0.9609,3.13}},[11]={{51.74,-16.03,-0.9811,-
8.709999999999999E-2,0.173,1.72},{49.07,4.19,-0.9361,-8.709999999999999E-2,-
0.3407,1.72},{52.03,-16.06,-0.9755,-0.1373,0.172,1.73},{49.35,4.31,-0.9308,-
0.1373,-0.3388,1.73},{49.54,4.38,-0.9231,-0.1869,-0.336,1.74},{52.23,-16.09,-
0.9675,-0.1869,0.1706,1.740000000315},{51.33,-15.97,-0.9811,-8.709999999999999E-2,0.173,
1.76},{50.730000000228,-0.69,-0.9744,-8.709999999999999E-2,-0.2071,2.06},{51.02,-0.61,-
0.9689,-0.1373,-0.2059,2.08},{51.21,-0.56,-0.9609,-0.1869,-0.2042,2.09},{50.34,-
0.79,-0.9744,-8.709999999999999E-2,-0.2071,2.09},{50.34,-20.97,-0.9474,-
8.709999999999999E-2,0.3078,2.09},{50.73,-21.08,-0.942,-0.1373,0.3061,2.09},{
51.74,-5.74,-0.9938,-8.709999999999999E-2,-6.95E-2,2.41},{52.030000000448,-5.7,-0.9881,-
0.1373,-6.909999999999999E-2,2.420000000209},{51.33,-5.79,-0.9938,-8.709999999999999E-2,-
6.95E-2,2.43}},[12]={{47.23,-26.36,-0.8508,-0.1869,0.4912,0},{52.03,-11.6,-
0.9821,-0.1373,0.1293,0},{27.87,-43.09,-0.3791,-0.1373,0.9151,0},{52.03,-1.24,-
0.9821,-0.1373,-0.1293,0},{27.95,-43.27,-0.3759,-0.1869,0.9076,0},{51.21,-16.74,
-0.9489,-0.186900000906,0.2543,0},{27.76,-42.81,-0.3812,-8.709999999999999E-2,0.9204,0},
{22.95,-44.76,-0.2564,-0.1373,0.9568,0},{47.06,-26.260000000956,-0.8578,-0.1373,0.4953,0},
{23.01,-44.95,-0.2543,-0.1869,0.9489,0},{22.88,-44.47,-0.2578,-
8.709999999999999E-2,0.9623,0},{52.23,-1.21,-0.974,-0.1869,-0.1282,0},{52.57,-
6.42,-0.9824,-0.1869,0,0},{52.37,-6.42,-0.9905,-0.1373,0,0},{52.07,-6.42,-0.9962
,-8.709999999999999E-2,0,0},{51.74,-11.56,-0.9877,-8.709999999999999E-2,0.13,0}}
,[13]={{44.33,-23.07,-0.7794,-0.1869,0.598000000412,0},{47.06,-18.63,-0.8578,-0.1373,
0.4953,0},{52.03,-3.96,-0.982100000396,-0.1373,0.1293,0},{51.21,-9.11,-0.948900000618,-0.1869,
0.2543,0},{47.23,-18.73,-0.8508,-0.1869,0.4912,0},{51.02,-9.06,-0.9568,-0.1373,
0.2564,0},{36.66,-30.04,-0.6064,-8.709999999999999E-2,0.7903,0},{50.73,-8.98,-
0.9623,-8.709999999999999E-2,0.2578,0},{52.23,-3.99,-0.974,-0.1869,0.1282,0},{
51.74,-3.93,-0.9877,-8.709999999999999E-2,0.13,0},{36.84,-30.27,-0.603,-0.1373,
0.7858,0},{52.57,1.22,-0.9824,-0.1869,0,0},{49.07,-13.86,-0.920400000436,-
8.709999999999999E-2,0.3812,0},{36.97,-30.43,-0.598,-0.1869,0.7794,0},{49.35,-
13.97,-0.9151,-0.1373,0.3791,0},{43.93,-22.76,-0.7903,-8.709999999999999E-2,
0.6064,0}},[14]={{44.33,-15.9,-0.7794,-0.1869,0.598,0},{51.21,-1.94,-0.9489,-
0.1869,0.2543,0},{52.03,3.21,-0.9821,-0.1373,0.1293,0},{32.53,-25.99,-0.4953,-
0.1373,0.8578,0},{32.63,-26.16,-0.4912,-0.1869,0.8508,0},{32.38,-25.73,-0.4981,-
8.709999999999999E-2,0.8627,0},{47.06,-11.46,-0.8578,-0.1373,0.4953,0},{47.23,-
11.56,-0.8508,-0.1869,0.4912,0},{49.07,-6.69,-0.9204,-8.709999999999999E-2,
0.3812,0},{51.02,-1.89,-0.9568,-0.1373,0.2564,0},{52.23,3.180000000764,-0.974,-0.1869,
0.1282,0},{50.73,-1.81,-0.9623,-8.709999999999999E-2,0.2578,0},{36.66,-22.86,-
0.6064,-8.709999999999999E-2,0.7903,0},{49.54,-6.88,-0.9076,-0.1869,0.375900000178,0},{
36.84,-23.1,-0.603,-0.1373,0.7858,0},{43.93,-15.590000000227,-0.7903,-8.709999999999999E-2
,0.6064,0}},[15]={{46.44,31.45,-0.8331,-0.1869,-0.5206,1.650000000106},{49.54,-3.31,-
0.9308,-0.1373,0.338800000319,1.75},{52.03,17.14,-0.9675,-0.1869,-0.1706,1.75},{49.35,-
3.23,-0.9361,-8.709999999999999E-2,0.3407,1.75},{51.74,17.1,-0.9755,-0.1373,-
0.172,1.75},{51.33,17.04,-0.9811,-8.709999999999999E-2,-0.173,1.76},{50.73,1.76,
-0.9744,-8.709999999999999E-2,0.2071,2.06},{51.02,1.68,-0.9689,-0.137300000297,0.2059,
2.08},{51.21,1.63,-0.9609,-0.1869,0.2042,2.09},{50.34,1.86,-0.9744,-
8.709999999999999E-2,0.2071,2.09},{50.34,22.05,-0.9474,-8.709999999999999E-2,-
0.3078,2.09},{50.730000000493,22.15,-0.942,-0.1373,-0.3061,2.09},{51.74,6.81,-0.9938,-
8.709999999999999E-2,0.0695,2.41},{52.03,6.77,-0.9881,-0.1373,0.0691,2.42},{
51.33,6.87,-0.9938,-8.709999999999999E-2,0.0695,2.43},{52.23,6.75,-0.98,-0.1869,
0.0685,2.440000000419}},[16]={{-12.72,-50.58,0.0691,-0.1373,0.9881,2.770000000299},{-12.72,-50.28,
0.0691,-0.1373,0.9881,2.78},{-12.72,-50.77,0.0685,-0.1869,0.98,2.78},{-17.9,-
50.24,0.2042,-0.1869,0.9609,3.13}},[17]={{7.23,-42,-0.4912,-0.1869,0.8508,0},{-
27.91,-44.12,0.3791,-0.1373,0.9151,0},{-22.99,-45.79,0.2564,-0.1373,0.9568,0},{-
22.91,-45.5,0.2578,-8.709999999999999E-2,0.9623,0},{2.36,-43.85,-0.3812,-
8.709999999999999E-2,0.9204,0},{-2.52,-45.5,-0.2578,-8.709999999999999E-2,0.9623
,0},{2.55,-44.31,-0.3759,-0.1869,0.9076,0},{2.47,-44.12,-0.3791,-0.1373,0.9151,0
},{6.98,-41.57,-0.4981,-8.709999999999999E-2,0.8627,0},{7.13,-41.83,-0.4953,-
0.1373,0.8578,0},{-27.79,-43.85,0.3812,-8.709999999999999E-2,0.9204,0},{-23.04,-
45.98,0.2543,-0.1869,0.9489,0},{-27.980000000556,-44.31,0.3759,-0.1869,0.9076,0}},[18]={{
11.57,32.2,-0.598,-0.1869,-0.7794,0}},[19]={{39.760000000256,3.72,-0.8114,0.4595,-0.3613,
3.61},{42.95,0.62,-0.8809,0.4002,-0.2526,3.93},{44.16,1.12,-0.9032,0.3422,-0.259
,4.01},{41.57,0.05,-0.8618,0.4595,-0.2149,4.82},{39.72,8.83,-0.7937,0.4002,-
0.4582,5.11}},[20]={{39.76,-22.09,-0.7937,0.4002,0.4582,0},{41.99,-2.59,-0.8806,
0.4595,-0.1159,0},{42.24,-6.45,-0.888200000151,0.4595,0,0},{44.33,2.03,-0.9076,0.3422,-
0.2432,0},{42.88,1.64,-0.8852,0.4002,-0.2372,0},{41.57,5.51,-0.8467,0.4002,-
0.3507,0},{43.95,-6.45,-0.9164,0.4002,0,0},{41.57,-18.42,-0.8467,0.4002,0.3507,0
},{42.88,-14.54,-0.8852,0.4002,0.2372,0},{44.33,-14.93,-0.9076,0.3422,0.2432,0},
{41.99,-10.31,-0.8806,0.4595,0.1159,0},{43.68,-10.53,-0.9086,0.4002,0.1196,0},{
43.68,-2.37,-0.9086,0.4002,-0.1196,0},{39.76,9.18,-0.7937,0.4002,-0.4582,0}},[21
]={{39.76,-13.85,-0.7937,0.4002,0.4582,0},{39.76,17.42,-0.7937,0.4002,-0.4582,0}
},[22]={{41.23,1.95,-0.861800000184,0.4595,0.2149,0.52},{41.23,17.25,-0.8538,0.459500000216,-
0.2448,0.52},{42.88,17.69,-0.8809,0.4002,-0.2526,0.55},{42.88,1.51,-0.8892,
0.4002,0.221700000234,0.550000000762},{44.33,1.12,-0.9117,0.3422,0.2273,0.57},{41.99,5.74,-0.8833,
0.4595,0.0928,0.77},{39.99,20.91,-0.8114,0.4595,-0.3613,0.77},{41.57,21.570000000453,-
0.8372,0.4002,-0.3728,0.82},{43.68,5.52,-0.9114,0.4002,0.0958,0.82},{45.16,5.32,
-0.9345,0.3422,0.0982,0.86},{42.24,9.6,-0.8876,0.4595,-3.1E-2,1.03},{39.76,-6.03
,-0.8092,0.4002,0.4302,1.09},{43.95,9.6,-0.9159,0.4002,-3.2E-2,1.09},{39.99,-
1.71,-0.8346,0.4595,0.3038,1.29},{41.99,13.46,-0.8747,0.4595,-0.1542,1.29},{
41.57,-2.36,-0.8612,0.4002,0.3134,1.36}},[23]={{39.76,-3.68,-0.8114,0.4595,
0.3613,3.61},{41.05,-4.43,-0.8372,0.4002,0.3728,3.67},{42.95,-0.58,-0.8809,
0.4002,0.2526,3.93},{44.16,-1.09,-0.9032,0.3422,0.259,4.01},{41.57,-1E-2,-0.8618
,0.4595,0.2149,4.82},{39.720000000745,-8.79,-0.7937,0.4002,0.4582,5.11}},[24]={{43.48,-
17.97,-0.883,0.3422,0.3214,25.78},{40.71,-16.82,-0.8346,0.459500000508,0.3038,26.02},{
43.68,-5.72,-0.9025,0.4002,0.1591,27.98},{44.06,0.02,-0.9164,0.4002,0,28.02},{
43.68,5.76,-0.9075,0.4002,-0.1275,28.58},{40.71,16.86,-0.8346,0.4595,-0.3038,
31.6}},[25]={{43.48,-17.97,-0.883,0.3422,0.3214,25.29},{40.71,-16.82,-0.8346,
0.4595,0.3038,25.52},{44.06,0.02,-0.9164,0.4002,0,25.95},{43.68,-5.72,-0.9025,
0.4002,0.1591,25.98},{43.68,5.76,-0.9075,0.4002,-0.1275,26.21},{40.71,16.860000000883,-
0.8346,0.4595,-0.3038,28.28}},[26]={{43.68,5.76,-0.9075,0.4002,-0.1275,25.31},{
44.06,0.02,-0.9164,0.4002,0,25.48},{43.68,-5.72,-0.902500000355,0.4002,0.1591,25.61},{
40.71,16.86,-0.8346,0.459500000944,-0.3038,25.85},{43.48,-17.97,-0.883,0.3422,0.3214,
26.9},{40.71,-16.82,-0.8346,0.4595,0.3038,27.11}},[27]={{40.71,16.86,-0.8346,
0.4595,-0.3038,25.7},{43.68,5.76,-0.907500000235,0.4002,-0.1275,26.7},{44.06,0.02,-
0.9164,0.4002,0,27.25},{43.68,-5.720000000208,-0.9025,0.4002,0.1591,27.46},{43.48,-17.97,-
0.883,0.3422,0.3214,30.31},{40.71,-16.82,-0.8346,0.4595,0.3038,30.48}},[28]={{
40.71,16.86,-0.8346,0.4595,-0.3038,26.02},{43.68,5.76,-0.9075,0.4002,-0.1275,
27.39},{44.06,0.02,-0.9164,0.4002,0,28.02},{43.68,-5.72,-0.9025,0.4002,0.1591,
28.25},{43.48,-17.97,-0.883,0.3422,0.3214,31.44},{40.71,-16.82,-0.8346,0.4595,
0.3038,31.6}}}}end function a.w()local aa=a.cache.w if not aa then aa={c=
__modImpl()}a.cache.w=aa end return aa.c end end do local function __modImpl()
local aa=a.a()local ab=math.max local ac=task.spawn local ad=task.wait local ae=
aa.Services.Workspace local af=aa.LocalPlayer local ag={}local ah={}local ai={}
local aj=(setmetatable({},{__mode='k'}))local ak=(setmetatable({},{__mode='k'}))
local al=0.25 local function Learn(am,an)if aj[am]then return end local ao=am:
GetAttribute"CooldownUntil"local ap=am:GetAttribute'CooldownTime'if type(ao)==
'number'then ai[am.Name]='Until'ah[am.Name]=ab(ah[am.Name]or 0,ao)end if type(ap
)=='number'and ap>0 and ak[am]~=ap then ak[am]=ap ai[am.Name]=ai[am.Name]or
'Time'ah[am.Name]=ab(ah[am.Name]or 0,an+ap)end end local function Restore(am,an)
local ao=ah[am.Name]if not ao then return end local ap=ao-an if ai[am.Name]==
'Until'then local aq=am:GetAttribute'CooldownUntil'if ap>0 and(type(aq)~=
'number'or aq<ao-0.5)then am:SetAttribute('CooldownUntil',ao)end return end
local aq=am:GetAttribute'CooldownTime'if aj[am]then if type(aq)=='number'and aq>
ap+1 then ah[am.Name]=an+aq aj[am]=nil return end am:SetAttribute("CooldownTime"
,ab(0,ap))if ap<=0 then aj[am]=nil end elseif 0>=ap and type(aq)=='number'and aq
>0 and ak[am]==aq then ak[am]=nil am:SetAttribute("CooldownTime",nil)elseif ap>
0.5 and(type(aq)~='number'or aq<ap-0.5)then aj[am]=true am:SetAttribute(
'CooldownTime',ap)end end local function Sweep(am,an)if not am then return end
for ao,ap in am:GetChildren()do if ap:IsA'Tool'then Learn(ap,an)Restore(ap,an)
end end end function ag.Left(am)local an=ah[am]return if an then ab(0,an-ae:
GetServerTimeNow())else 0 end aa.Clean(ac(function()while aa.Running do local am
=ae:GetServerTimeNow()Sweep(af.Character,am)Sweep(af:FindFirstChildOfClass
'Backpack',am)ad(al)end end))return ag end function a.x()local aa=a.cache.x if
not aa then aa={c=__modImpl()}a.cache.x=aa end return aa.c end end do local 
function __modImpl()local aa=a.a()local ab=a.h()local ac=a.i()local ad=a.o()
local ae=a.n()local af=a.x()local ag=math.clamp local ah=math.max local ai=math.
min local aj=math.abs local ak=task.spawn local al=task.wait local am=aa.
Services.RunService local an=aa.Services.HttpService local ao=aa.Services.
ReplicatedStorage local ap=aa.Services.Workspace local aq=aa.Services.Players
local ar=aa.LocalPlayer local as='Quantum Cloner'local at=6 local au=0.6 local
av=6 local aw=6 local ax=0.15 local ay,az,aA=0.05,0.999,8 local aB,aC=30,20
local aD=10 local aE=-4 local aF=Vector3.new(4,0.4,4)local aG=Color3.fromRGB(40,
40,46)local aH=10 local aI=20 local aJ=0.5 local aK=0.3 local aL=8 local aM,aN,
aO=150,400,0.03 local aP,aQ=2.5,3 local aR=8 local aS,aT=40,0.1 local aU=6 local
aV,aW=6,7.5 local aX=8.9 local aY={Delay=0.3}local function Root()local aZ=ar.
Character return aZ and(aZ:FindFirstChild'HumanoidRootPart')end local function 
Ping()return ar:GetNetworkPing()end local function Still(aZ)aZ.
AssemblyLinearVelocity=Vector3.zero aZ.AssemblyAngularVelocity=Vector3.zero end
local function Name()return(string.gsub(string.lower(an:GenerateGUID(false)),
'%-',''))end local function JumpIfClimbing(aZ,a_)if aj(a_-aZ.Position.Y)<=aD
then return end local a0=aZ.Parent and aZ.Parent:FindFirstChildOfClass'Humanoid'
if a0 then a0:ChangeState(Enum.HumanoidStateType.Jumping)a0.Jump=true end end
function aY.InWalls(aZ,a_)local a0=aZ:FindFirstChild'StealHitbox'if not a0 or
not a0:IsA'BasePart'then return false end local a2=a0.CFrame:PointToObjectSpace(
a_)local a3=a0.Size*0.5 return aj(a2.X)<=a3.X and aj(a2.Y)<=a3.Y and aj(a2.Z)<=
a3.Z end local aZ local a_ local a0='ItemUse/QuantumClonerTeleport/'..ar.Name
local function SwapLeft()if not aZ then local a2=ao:FindFirstChild'Packages'
local a3=a2 and a2:FindFirstChild'Debounce'local a4,a5=pcall(aa.Require,a3)a_=if
a4 and type(a5)=='function'then a5 else nil local a6=if a_ then debug.
getupvalue(a_,1)else nil aZ=if type(a6)=='table'then a6 else{}end local a2=
rawget(aZ,a0)return if type(a2)=='number'then ah(0,a2-os.clock())else 0 end
local function Hold(a2)local a3=os.clock()+at while a2()>0 and os.clock()<a3 do
al(0.05)end return a2()<=0 end local function Tool()return ab.FindTool(as)end
function aY.Left()local a2=Tool()if not a2 then return math.huge end local a3=a2
:GetAttribute'CooldownTime'return ah(if type(a3)=='number'then a3 else 0,af.
Left(a2.Name))end local function SwapButton()local a2=ar:FindFirstChildOfClass
"PlayerGui"local a3=a2 and a2:FindFirstChild'ToolsFrames'local a4=a3 and a3:
FindFirstChild'QuantumCloner'local a5=a4 and a4:FindFirstChild'TeleportToClone'
return if a5 and a5:IsA"GuiButton"then a5 else nil end local function CloneAt()
local a2=ap:FindFirstChild(ar.UserId..'_Clone')return if a2 and a2:IsA
'PVInstance'then a2:GetPivot().Position else nil end local function FireSwap(a2)
SwapLeft()if a_ and a_(a0,5)then return end local a3=ae.Event
"QuantumCloner/OnTeleport"if a3 then a3:FireServer()end end local a2=Vector3.
new(1,0,1)local function SwapLanded(a3,a4)local a5=a4~=nil and((a4-a3)*a2).
Magnitude>1.5 local a6=os.clock()+ag(Ping()*4,0.4,2)repeat local a7=Root()local
a8=CloneAt()if a7 and((a7.Position-a3)*a2).Magnitude>2.5 then return true end if
a5 and a7 and((a7.Position-(a4))*a2).Magnitude<1.5 then return true end if a5
and a8 and((a8-a3)*a2).Magnitude<1.5 then return true end am.Heartbeat:Wait()
until os.clock()>a6 return false end local function CloneModel()local a3=ap:
FindFirstChild(ar.UserId..'_Clone')return if a3 and a3:IsA'PVInstance'then a3
else nil end local function WaitPlaced(a3,a4,a5,a6)local a7=os.clock()+ag(Ping()
*3+0.2,0.3,1.5)repeat al()local a8=CloneModel()local a9=a8 and a8:GetPivot().
Position if a8 and a9 and(a8~=a5 or not a6 or((a9-a6)*a2).Magnitude>0.5)then
local b=(a9-a3)*a2 local ba=b:Dot(a4)if ba>=1.5 and(b-a4*ba).Magnitude<3 then
return true end end until os.clock()>a7 return false end local function Trace(a3
)local a4=Root()local a5=a4 and a4.Parent and a4.Parent:FindFirstChildOfClass
'Humanoid'local a6=''if a4 then local a7=a4.CFrame.LookVector a6=string.format(
' @(%.0f,%.0f,%.0f) yaw %.0f %s%s',a4.Position.X,a4.Position.Y,a4.Position.Z,
math.deg(math.atan2(-a7.X,-a7.Z)),if a5 then a5:GetState().Name else'',if ar:
GetAttribute'GiantPotion'~=nil then' giant'else'')end aY.Log[#aY.Log+1]=string.
format('%.2f %s%s',os.clock(),a3,a6)end local function Instant(a3)local a4,a5,a6
=ab.Character()local a7=Tool()if not a4 or not a5 or not a6 then return false,
'no character'end if not a7 then return false,'no Quantum Cloner'end if not
Hold(function()local a8=a7:GetAttribute'CooldownTime'return if type(a8)==
'number'then a8 else 0 end)then return false,'cloner on cooldown'end ad.
AwaitEngage()a6:UnequipTools()al()if a7.Parent~=a4 then a6:EquipTool(a7)local a8
=os.clock()+1 repeat am.Heartbeat:Wait()until a7.Parent==a4 or os.clock()>a8 if
a7.Parent~=a4 then return false,'cloner equip failed'end al(ag(Ping(),0.03,0.2))
end local a8=SwapButton()if not a8 then return false,'swap button missing'end
local a9=a5.CFrame.LookVector*a2 if a3 and(a9.Magnitude<1e-4 or a9.Unit:Dot(a3)<
0.99)then a5.CFrame=CFrame.lookAt(a5.Position,a5.Position+a3)Still(a5)Trace
'turned back to the wall'al(ag(Ping()*2,0.1,0.4))end local b=a5.Position local
ba=a5.CFrame.LookVector*Vector3.new(1,0,1)ba=if ba.Magnitude>1e-4 then ba.Unit
else Vector3.new(0,0,-1)local bb=CloneModel()local bc=bb and bb:GetPivot().
Position Trace'activate'a7:Activate()if not WaitPlaced(b,ba,bb,bc)then Trace
'not placed, activating again'a7:Activate()if not WaitPlaced(b,ba,bb,bc)then
Trace('not placed, clone at '..tostring(CloneAt()))return false,
'clone was not placed'end end return true end local function AtClone(a3)if not
a3 then return false end local a4=os.clock()+ag(Ping()*4,0.6,2)repeat local a5=
Root()if a5 and(a5.Position-a3).Magnitude<8 then return true end am.Heartbeat:
Wait()until os.clock()>a4 return false end local function Arm()local a3=Tool()if
a3 and ab.Equip(a3,1)then al(ag(Ping()*2,0.1,0.400000000437))end end local function SwapIn(
a3,a4)for a5=1,2 do if a4 then Arm()end if not Hold(SwapLeft)then return false,
'swap on cooldown'end local a6=CloneAt()FireSwap(SwapButton())if a3(a6)then
return true end Trace(if a5==1 then'swap not seen, retrying'else
'swap retry not seen')end return false,"clone placed but the swap did not land"
end local function Stow()local a3,a4,a5=ab.Character()if a5 then a5:
UnequipTools()end end local a4 function aY.Lead(a5,a6,a7)local a8=ar.Character
a4=a8 local a9 local b=false local ba=false ak(function()if a6>0 then al(a6)end
if b then a9=false return end ba=true Trace'reset started'a9=a5()end)local 
function Cancel()b=true if ba then a7()end end local function Await()local bb=os
.clock()+a6+10 while a9==nil and os.clock()<bb do am.Heartbeat:Wait()end if not
a9 then return false,'reset did not respawn you'end while(ar.Character==a8 or
not Root())and os.clock()<bb do am.Heartbeat:Wait()end if not Root()then return
false,'no character after the reset'end Trace'respawned'return true end return
Await,Cancel end function aY.Snug(a5,a6)local a7,a8=ab.Character()local a9=
Vector3.new(a6.X,0,a6.Z)if not a7 or not a8 or a9.Magnitude<1e-4 then return a5
end a9=a9.Unit local b=RaycastParams.new()b.FilterType=Enum.RaycastFilterType.
Exclude b.FilterDescendantsInstances={a7}b.RespectCanCollide=true local ba for
bb,bc in{1.5,0,-1.5}do local c=ap:Raycast(a5+Vector3.new(0,bc,0),a9*aL,b)if c
and(not ba or c.Distance<ba)then ba=c.Distance end end if not ba then return a5
end local bb=ba-a8.Size.Z*0.5-aK return if bb>0 then a5+a9*bb else a5 end local 
function HoldPose(a5,a6,a7,a8)local a9=Root()local b=a9 and a9.Parent and a9.
Parent:FindFirstChildOfClass'Humanoid'local ba=b and b.AutoRotate local bb=
CFrame.lookAt(a5,a5+a6)*(if a8 then CFrame.Angles(0,0,math.pi/2)else CFrame.
identity)if b then b.AutoRotate=false if a7 then b.PlatformStand=true end end if
a7 then ab.Posing=true end if a9 then a9.CFrame=bb Still(a9)end local bc=true
ak(function()while bc do local c=Root()if not c or not c.Parent then break end
if a7 then c.AssemblyLinearVelocity=Vector3.zero c.AssemblyAngularVelocity=
Vector3.zero local e=c.CFrame.LookVector*a2 local f=e.Magnitude>1e-4 and e.Unit:
Dot(a6)>=az and c.CFrame.UpVector:Dot(bb.UpVector)>=az if(c.Position-a5).
Magnitude>ay or not f then c.CFrame=bb end else local e=(a5-c.Position)*Vector3.
new(1,0,1)local f=if e.Magnitude>ax then e.Unit*ai(aB,e.Magnitude*aC)else
Vector3.zero c.AssemblyLinearVelocity=Vector3.new(f.X,c.AssemblyLinearVelocity.Y
,f.Z)c.AssemblyAngularVelocity=Vector3.zero end am.Heartbeat:Wait()end end)local 
function Done()if not bc then return end bc=false if a7 then ab.Posing=false end
if b and b.Parent then if ba~=nil then b.AutoRotate=ba end if a7 then b.
PlatformStand=false end end end if a7 then task.delay(aA,Done)end return Done
end local function Settle(a5)local a6=os.clock()local a7=0 while os.clock()-a6<
au do local a8=Root()if not a8 or not a8.Parent then return end if(a8.Position-
a5).Magnitude<=av and aj(a8.AssemblyLinearVelocity.Y)<aw then a7+=1 if a7>=2
then return end else a7=0 end am.Heartbeat:Wait()end end aY.Log={}function aY.
Through(a5,a6,a7,a8,a9,b)local ba=Root()if not ba then return false,
'no character'end local bb=Vector3.new(a6.X,0,a6.Z)if bb.Magnitude<1e-4 then bb=
ba.CFrame.LookVector*Vector3.new(1,0,1)end bb=bb.Unit local bc=Instance.new
'Part'bc.Name=Name()bc.Size=Vector3.new(12,1,12)local c=if b then ba.Size.X*0.5+
0.650000000286 else ab.Feet()+(if a7>25 then 2.5 else 0.5)bc.Position=Vector3.new(a5.X,a5.
Y-c,a5.Z)bc.Anchored=true bc.CanQuery=false bc.CanTouch=false bc.Transparency=1
bc.Parent=ap table.clear(aY.Log)Trace(string.format(
'hold for (%.0f,%.0f,%.0f)%s',a5.X,a5.Y,a5.Z,if b then' lying'else''))local e=
HoldPose(a5,bb,a9,b)Still(ba)al(aY.Delay)Settle(a5)local f=ar.Character if a8
and f~=a4 then e()bc:Destroy()return false,
'respawned before the clone was placed'end local g,h=Instant(bb)e()bc:Destroy()
local i=CloneAt()Trace(if g then string.format('placed, clone (%.0f,%.0f,%.0f)',
i and i.X or 0,i and i.Y or 0,i and i.Z or 0)else'place failed: '..tostring(h))
if not g then return false,if ar.Character~=f then
'respawned before the clone was placed'else h end if a8 then Stow()local j,k=a8(
)if not j then return false,k end end local j,k=SwapIn(if a8 then AtClone else
function(j)return SwapLanded(a5,j)end,a8~=nil)Trace(if j then'swap landed'else
tostring(k))return j,k end function aY.Respawn(a5)table.clear(aY.Log)local a6=ar
.Character if a6~=a4 then return false,'respawned before the clone was placed'
end local a7,a8=Instant()if not a7 then Trace("place failed: "..tostring(a8))
return false,if ar.Character~=a6 then'respawned before the clone was placed'else
a8 end Trace'placed'Stow()local a9,b=a5()if not a9 then return false,b end local
ba,bb=SwapIn(AtClone,true)Trace(if ba then'swap landed'else tostring(bb))return
ba,bb end local function InRing(a5,a6)local a7=a5:GetPivot().Position return aj(
a6.X-a7.X)<26 and aj(a6.Z-a7.Z)<26 end local function AwaitSwap(a5,a6)local a7=
os.clock()+a6 repeat local a8=Root()if a8 and(aY.InWalls(a5,a8.Position)or
InRing(a5,a8.Position))then return true end am.Heartbeat:Wait()until os.clock()>
a7 local a8=Root()return a8~=nil and InRing(a5,a8.Position)end local a5 local 
function ClearPad()if a5 then a5:Destroy()a5=nil end end local function Pad(a6,
a7,a8)ClearPad()local a9=Instance.new'Part'a9.Name=Name()a9.Size=aF a9.Position=
Vector3.new(a6.X,a7-aF.Y*0.5,a6.Z)a9.Anchored=true a9.CanCollide=not a8 a9.
CanTouch=false a9.CanQuery=false a9.Transparency=0.55 a9.Color=aG a9.CastShadow=
false a9.Material=Enum.Material.SmoothPlastic a9.Parent=ap a5=a9 local b=ab.
Feet()local ba=if a8 then am.Stepped:Connect(function()local ba=Root()if ba then
a9.CanCollide=ba.Position.Y-b>=a7-aJ end end)else nil ak(function()local bb=os.
clock()while a9.Parent and os.clock()-bb<aI do local bc=Root()if not bc or((bc.
Position-a9.Position)*Vector3.new(1,0,1)).Magnitude>aH then break end al(0.15)
end if ba then ba:Disconnect()end if a5==a9 then ClearPad()end end)end local 
function Carpet(a6)local a7=os.clock()repeat if ac.Held(ar.Character)then al(a6)
return end ac.Equip()am.Heartbeat:Wait()until os.clock()-a7>1.5 end local 
function LevelOf(a6)return if a6>23.15 then 3 elseif a6>=11 then 2 else 1 end
local function GoCFrame(a6,a7,a8,a9)if not a9 then Carpet(0.2)end local b=Root()
if not b then return false,nil end b.Anchored=false if a8 and a7 and not
AwaitSwap(a7,1.5)then Trace'not inside the base after the swap'return false,nil
end local ba=a6.Y local bb=b.Position.Y local bc=LevelOf(bb)==LevelOf(ba)if bc
then Trace"already on the podium's floor"elseif ba>23.15 then bb=21 elseif ba>=
11 then bb=14.5 elseif ba>=-6.9 and ba<=8.9 then bb=aE end local c=Vector3.new(
a6.X,bb,a6.Z)Trace(string.format('hop to (%.0f,%.0f,%.0f)',c.X,c.Y,c.Z))
JumpIfClimbing(b,c.Y)local e=b.Position local f=math.max(1,math.ceil((c-e).
Magnitude/aS))for g=1,f do if not b.Parent then return false,nil end b.CFrame=
CFrame.new(e:Lerp(c,g/f))Still(b)if g<f then al(aT)end end if not bc then Pad(c,
c.Y-ab.Feet(),false)end task.delay(0.5,Trace,'half a second after the hop')
return true,c end local function UnderHeight(a6,a7)if(a7 and 19<=a7)or(not a7
and a6>23.15)then return a6-aW end if(a7 and a7>=11)or(not a7 and a6>=11)then
return a6-aV end if(a7 and a7>=1)or(not a7 and a6>=-6.9 and a6<=8.9)then return
aE end return a6-aV end local function GoVelocity(a6,a7,a8,a9,b,ba)if not ba
then Carpet(0.03)end local bb=Root()if not bb then return false end bb.Anchored=
false if a9 and a8 and not AwaitSwap(a8,ag(Ping()*4,0.4,1.5))then Trace
'not inside the base after the swap'return false end Trace'glide start'Still(bb)
local bc=LevelOf(bb.Position.Y)==LevelOf(a6.Y)local c=Vector3.new(a6.X,if bc
then bb.Position.Y else UnderHeight(a6.Y,a7),a6.Z)local e=bb.Parent and bb.
Parent:FindFirstChildOfClass'Humanoid'local function States(f)if e then e:
SetStateEnabled(Enum.HumanoidStateType.Running,f)e:SetStateEnabled(Enum.
HumanoidStateType.Climbing,f)end end States(false)local f=os.clock()while os.
clock()-f<aP do bb=Root()if not bb or not bb.Parent or ar:GetAttribute'Stealing'
then break end local g=c-bb.Position if g.Magnitude<=aQ then break end local h=g
.Unit*(if os.clock()-f<aO then ai(aM,b or aN)else b or aN)if bb.Position.Y>=c.Y-
0.5 and h.Y>0 then h=Vector3.new(h.X,0,h.Z)end bb.AssemblyLinearVelocity=h am.
Heartbeat:Wait()end bb=Root()if not bb or not bb.Parent then States(true)return
false end local g=CFrame.new(c)*(bb.CFrame-bb.CFrame.Position)JumpIfClimbing(bb,
c.Y)Still(bb)if not bc then Pad(a6,c.Y-ab.Feet(),true)end bb.CFrame=g for h=1,aR
do am.Heartbeat:Wait()if not bb.Parent then break end if(bb.Position-c).
Magnitude>4 then bb.CFrame=g end end States(true)Trace'glide done'task.delay(0.5
,Trace,'half a second after the glide')return true end function aY.GoTo(a6,a7,a8
,a9,b,ba,bb)if a6=='Velocity'then return GoVelocity(a7,a8,a9,b,ba,bb)end local
bc,c=GoCFrame(a7,a9,b,bb)if not bc or not c then return bc end al(ag(Ping()*2,
0.2,0.6))local e=Root()if not e or((e.Position-c)*a2).Magnitude<=aU then return
bc end Trace(string.format(
'lagged back %.0f studs after the hop, gliding instead',((e.Position-c)*a2).
Magnitude))return GoVelocity(a7,a8,a9,false,ba,bb)end local a6={{Vector3.new(-
487.921448,16.850713,-75.768013),'N'},{Vector3.new(-332.37973,16.850722,-75.7621
),'N'},{Vector3.new(-487.134918,16.850713,-18.094154),'S'},{Vector3.new(-
316.300171,16.850713,-17.845898),'S'},{Vector3.new(-330.765381,16.850713,
31.424425),'N'},{Vector3.new(-502.989349000175,16.850713,31.17243),'N'},{Vector3.new(-
489.077087,16.850713,89.010147),'S'},{Vector3.new(-330.908936,16.850713,
88.930145),'S'},{Vector3.new(-331.264893,16.850713,138.209167),'N'},{Vector3.
new(-487.935181,16.850713,138.026321),'N'},{Vector3.new(-487.774933,16.850713,
195.882538),'S'},{Vector3.new(-330.799133,16.850575,196.022354),'S'}}local a7={{
Vector3.new(-335.725586,-3.048217,-74.984589),'N'},{Vector3.new(-503.214233,-
3.048217,-75.043137),'N'},{Vector3.new(-483.619385,-3.71843,-18.844337),'S'},{
Vector3.new(-316.147095,-3.048218,-18.818844),'S'},{Vector3.new(-335.985413,-
3.048218,32.051426),'N'},{Vector3.new(-503.277008,-3.048217,31.956175),'N'},{
Vector3.new(-483.74939,-3.048218,88.147003),'S'},{Vector3.new(-315.793823,-
3.048217,88.163979),'S'},{Vector3.new(-335.476654,-3.048218,139.001083),'N'},{
Vector3.new(-503.710083,-3.048218,138.989883),'N'},{Vector3.new(-315.654938,-
3.048218,195.302444),'S'},{Vector3.new(-483.859253,-3.048218,195.269043),'S'}}
local a8={-476.52,-476.52,-476.52,-476.52,-342.66,-342.66,-342.66,-342.66}local
a9={-479.51,-479.51,-479.51,-479.51,-339.48,-339.48,-339.48,-339.48}local b={
220.94090270996094,113.77315521240234,6.178487777709961,-101.07275390625,
221.44737243652344,113.41409301757813,6.249461650848389,-99.73458862304688}local
ba={['La Secret Combinasion']=true,['La Jolly Grande']=true}local bb,bc=7,3
local c,e=-3.048217,16.850713 local f,g,h,i=-410,18,45,2 local function 
ClosestBase(j)local k,l=1,math.huge for m=1,8 do local n=(j.X-a8[m])^2+(j.Z-b[m]
)^2 if l>n then k,l=m,n end end return k end local function Aligned(j,k,l)local
m=Vector3.new(l,j.Y,j.Z)if aj(m.X-j.X)<1 then return nil end local n={}for o,p
in aq:GetPlayers()do if p.Character then table.insert(n,p.Character)end end
local o=ap:FindFirstChild'Ledge'if o then table.insert(n,o)end local p=
RaycastParams.new()p.FilterType=Enum.RaycastFilterType.Exclude p.
FilterDescendantsInstances=n p.RespectCanCollide=true local q=ap:Raycast(m,6*k,p
)if not q then return nil end local r=OverlapParams.new()r.FilterType=Enum.
RaycastFilterType.Exclude r.FilterDescendantsInstances=n r.RespectCanCollide=
true if#ap:GetPartBoundsInBox(CFrame.new(m),Vector3.new(3,5,3),r)>0 then return
nil end if#ap:GetPartBoundsInBox(CFrame.new(q.Position+k*3),Vector3.new(3,5,3),r
)>0 then return nil end return m end function aY.Approach(j,k,l,m)local n=j.Y-(
if l and ba[l]then bc else 0)local o=bb<n local p=ClosestBase(j)local q=ag(k.Z-b
[p],-g,g)+b[p]local r=Vector3.new(if o then a9[p]else a8[p],if o then e else c,q
)local s=if p<=4 then Vector3.new(-1,0,0)else Vector3.new(1,0,0)local t='front'
if m~='Front'then local u=p<=4 local v=if m=='Side'then math.huge else(k-r).
Magnitude local w=if o then a6 else a7 for x,y in w do local z=y[1]if(z.X<f)~=u
or aj(z.Z-b[p])>=h then continue end local A=if y[2]=='N'then Vector3.new(0,0,-1
)else Vector3.new(0,0,1)z=Aligned(z,A,j.X)or z local B=z-A*i local C=(k-B).
Magnitude if v>C then r,s,v,t=B,A,C,'side'end end end if o then r+=Vector3.new(0
,2,0)end return r,s,t end function aY.Bases()local j={}for k=1,8 do j[k]=Vector3
.new(a8[k],-2,b[k])end return j end function aY.Here()local j=Root()if not j
then return false,'no character'end local k=j.Position local l,m=Instant()if not
l then return false,m end return SwapIn(function(n)return SwapLanded(k,n)end,
false)end aY.GroundPetY=aX return aY end function a.y()local aa=a.cache.y if not
aa then aa={c=__modImpl()}a.cache.y=aa end return aa.c end end do local function 
__modImpl()local aa=a.a()local ab=a.i()local ac=aa.Services.Players local ad=aa.
Services.RunService local ae=aa.Services.PathfindingService local af=aa.
LocalPlayer local ag local ah=false local ai={}ai._lagbacks=0 ai.Gen=0 ai.
PathMethod='VIS'ai.SolidLasers={}ai.Narrow=false ai.ShortEntry=false ai.Config={
BrainrotSpeed=700,CarpetSpeed=640,CarpetWait=0.05,CloneDelay=0.05,FlashRetries=8,GrappleWait=0.06,RiseSpeed=700,TPVelocity=600,StartDelay=0,TurnSpeed=240}
local aj=ai.Config ai.HoldAt=nil local ak=-math.huge function ai.Resample(al,am,
an)if not al or#al==0 then return al end an=math.clamp(tonumber(an)or 15,4,60)
local ao={}local ap=am for aq,ar in al do local as=(Vector3.new(ar.X,0,ar.Z)-
Vector3.new(ap.X,0,ap.Z)).Magnitude if as>=0.01 then local at=math.max(1,math.
ceil(as/an))for au=1,at do local av=au/at ao[#ao+1]=Vector3.new(ap.X+(ar.X-ap.X)
*av,ap.Y+(ar.Y-ap.Y)*av,ap.Z+(ar.Z-ap.Z)*av)end else ao[#ao+1]=ar end ap=ar end
if#ao>0 then ao[#ao]=al[#al]end return ao end local al={Cap=380,Want=470,Floor=
120,Step=25,ClimbStep=15,ClimbEvery=6,Snaps=0,LastAt=-math.huge,RoseAt=0}ai.Gov=
al ai.SpeedTiers={{90,190},{100,250},{150,320},{200,400},{250,430}}ai.LongSpeed=
430 local function GovSnap()if os.clock()-ak<1.5 then return end ak=os.clock()ai
._lagbacks=ai._lagbacks+1 al.Snaps+=1 al.LastAt=os.clock()al.Cap=math.max(al.
Floor,al.Cap-al.Step)al.Want=math.max(al.Floor,math.min(al.Want,al.Cap+al.Step*
0.5))local am=af.Character and af.Character:FindFirstChild'HumanoidRootPart'ai.
SnapLog=ai.SnapLog or{}if#ai.SnapLog>=10 then table.remove(ai.SnapLog,1)end ai.
SnapLog[#ai.SnapLog+1]=am and string.format('(%.0f,%.0f,%.0f) speed %.0f cap %d'
,am.Position.X,am.Position.Y,am.Position.Z,am.AssemblyLinearVelocity.Magnitude,
al.Cap)or'no root'end ai.GovSnap=GovSnap function ai.TierSpeed(am,an,ao)am=math.
min(tonumber(am)or 400,ai.LongSpeed)if an and ao then local ap=(ao-an).Magnitude
for aq,ar in ai.SpeedTiers do if ap<=ar[1]then am=math.min(am,ar[2])break end
end end if al.Snaps==0 then return am end return math.min(am,al.Cap)end aa.
Clean(task.spawn(function()while true do task.wait(1)if al.Cap<al.Want and os.
clock()-al.LastAt>al.ClimbEvery and os.clock()-al.RoseAt>al.ClimbEvery then al.
RoseAt=os.clock()al.Cap=math.min(al.Want,al.Cap+al.ClimbStep)end end end))aa.
Clean(task.spawn(function()local am,an=Vector3.zero while true do ad.Heartbeat:
Wait()local ao=af.Character and af.Character:FindFirstChild'HumanoidRootPart'if
not ao then an=nil continue end local ap,aq=ao.Position,ao.
AssemblyLinearVelocity if an then local ar=ap-an if ar.Magnitude>25 and am.
Magnitude>50 and ar.Unit:Dot(am.Unit)<-0.3 then GovSnap()end end local ar=ai.
HoldAt if ar and(ap-ar).Magnitude>25 then GovSnap()end an,am=ap,aq end end))
local am={Vector3.new(1,0,0),Vector3.new(-1,0,0),Vector3.new(0,0,1),Vector3.new(
0,0,-1)}local an={['structure base home']=true,Wall=true,Floor=true,Roof=true}
local ao={DeliveryHitbox=true,StealHitbox=true,LaserHitbox=true,AnimalTarget=
true,Multiplier=true,Laser=true,Hitbox=true,Spawn=true,MainRoot=true,Slope=true}
local function IsLaserPart(ap)local aq=ap and ap.Parent return aq~=nil and aq.
Name=='LaserHitbox'end local function LaserPlotUID(ap)local aq=ap.Parent local
ar=aq and aq.Parent return ar and ar.Name end local function LaserBlocks(ap)
local aq=LaserPlotUID(ap)local ar=ai.SolidLasers[aq]if ar and ar[ap.Name]then
return true end if ag and aq==ag then return false end return ap.CanCollide end
local ap={}local aq=false local function SetLaserQuery(ar)if(ar and true or
false)==aq then return end aq=ar and true or false if ar then table.clear(ap)
local as=workspace:FindFirstChild'Plots'if not as then return end for at,au in
as:GetChildren()do local av=au:FindFirstChild'LaserHitbox'if not av then
continue end for aw,ax in av:GetChildren()do if ax:IsA'BasePart'and not ax.
CanQuery then ap[ax]=true ax.CanQuery=true end end end return end for as in ap
do if as.Parent then as.CanQuery=false end end table.clear(ap)end local ar local
as=-math.huge local at=20 local au={}local function GetWorldQueryParts()if ar
and os.clock()-as<at then return ar end as=os.clock()ar={}local av=workspace:
FindFirstChild'Plots'for aw,ax in workspace:GetChildren()do if ax==av or ax==
workspace.Terrain then continue end local ay=false for az,aA in ac:GetPlayers()
do if aA.Character==ax then ay=true break end end if ay then continue end for az
,aA in ax:GetDescendants()do if aA:IsA'BasePart'and not aA.CanQuery then ar[#ar+
1]=aA end end end return ar end local function SetWorldQuery(av)if av then for
aw,ax in GetWorldQueryParts()do if ax.Parent and not ax.CanQuery then au[ax]=
true ax.CanQuery=true end end return end for aw in au do if aw.Parent then aw.
CanQuery=false end end table.clear(au)end local av={}local function SetPlotQuery
(aw,ax)if not ax then for ay in av do if ay.Parent then ay.CanQuery=false end
end table.clear(av)return end table.clear(av)if not aw then return end local ay=
workspace:FindFirstChild"Plots"local az=ay and ay:FindFirstChild(aw)if not az
then return end for aA,aB in az:GetDescendants()do if aB:IsA'BasePart'and not aB
.CanQuery and not IsLaserPart(aB)then av[aB]=true aB.CanQuery=true end end end
function ai.BodyGroup()local aw=af.Character and af.Character:FindFirstChild
'HumanoidRootPart'return aw and aw.CollisionGroup or'Default'end local function 
Blocks(aw)if not aw then return false end if IsLaserPart(aw)then return
LaserBlocks(aw)end if ao[aw.Name]then return false end if aw.CanCollide then
return true end if an[aw.Name]then return true end local ax=aw.Size if ax and
math.max(ax.X*ax.Y,ax.X*ax.Z,ax.Y*ax.Z)>150 then return true end return false
end local function BlocksWide(aw)if not aw then return false end if IsLaserPart(
aw)then return LaserBlocks(aw)end if ao[aw.Name]then return false end if aw.
CanCollide then return true end if an[aw.Name]then return true end local ax=aw.
Size if ax and math.max(ax.X*ax.Y,ax.X*ax.Z,ax.Y*ax.Z)>30 then return true end
return false end local function Block(aw,ax,ay)ay=ay or Blocks local az=
RaycastParams.new()az.FilterType=Enum.RaycastFilterType.Exclude az.IgnoreWater=
true az.CollisionGroup=ai.BodyGroup()local aA={}for aB,aC in ac:GetPlayers()do
if aC.Character then aA[#aA+1]=aC.Character end end local aB=aw for aC=1,16 do
az.FilterDescendantsInstances=aA local aD=ax-aB if aD.Magnitude<0.05 then return
nil end local aE=workspace:Raycast(aB,aD,az)if not aE then return nil end if ay(
aE.Instance)then return aE end aA[#aA+1]=aE.Instance aB=aE.Position+aD.Unit*0.3
end return nil end local function Clear(aw,ax)return Block(aw,ax)==nil end local 
function ClearWideRay(aw,ax)return Block(aw,ax,BlocksWide)==nil end local 
function Solid(aw)return aw.CanCollide end local function PathLen(aw)local ax,ay
=0,aw[1]for az=2,#aw do ax=ax+(aw[az]-ay).Magnitude ay=aw[az]end return ax end
local function RouteClimb(aw)local ax,ay=math.huge,-math.huge for az,aA in aw do
if aA.Y<ax then ax=aA.Y end if aA.Y>ay then ay=aA.Y end end local az=ay-ax local
aA=math.abs(aw[1].Y-aw[#aw].Y)local aB=az-aA return aB>0 and aB or 0 end local
aw=60 local ax=8 local ay=16 local az=2.5 local aA=6 local aB=30 local aC local 
function SweepDir(aD,aE)local aF=RaycastParams.new()aF.FilterType=Enum.
RaycastFilterType.Exclude aF.IgnoreWater=true aF.CollisionGroup=ai.BodyGroup()
local aG={}for aH,aI in ac:GetPlayers()do if aI.Character then aG[#aG+1]=aI.
Character end end local aH=aD for aI=1,24 do aF.FilterDescendantsInstances=aG
local aJ=aE-aH if aJ.Magnitude<0.05 then return false end local aK local aL=
pcall(function()aK=workspace:Spherecast(aH,az,aJ,aF)end)if not aL then aC=false
return nil end if not aK then return false end if Blocks(aK.Instance)then return
true end aG[#aG+1]=aK.Instance local aM=(aK.Distance or 0)-0.05 if aM>0 then aH=
aH+aJ.Unit*math.min(aM,aJ.Magnitude)end end return true end local function 
SweepBlocked(aD,aE,aF,aG)if nil==aC then aC=pcall(function()workspace:
Spherecast(Vector3.new(0,10000,0),1,Vector3.new(0,-1,0),RaycastParams.new())end)
end if not aC then return nil end local aH=aE-aD local aI=aH.Magnitude if aI<0.1
then return false end local aJ=aH/aI local aK=aD+aJ*math.min(aF or aA,0.4*aI)
local aL=aE-aJ*math.min(aG or aA,aI*0.4)local aM=SweepDir(aK,aL)if nil==aM then
return nil end if aM then return true end local aN=SweepDir(aL,aK)if aN==nil
then return nil end return aN end local function ClearWide(aD,aE,aF,aG)if not
Clear(aD,aE)then return false end local aH=SweepBlocked(aD,aE,aF,aG)if aH~=nil
then return not aH end local aI=Vector3.new(aE.X-aD.X,0,aE.Z-aD.Z)if aI.
Magnitude<0.1 then local aJ=Vector3.new(ay,0,0)local aK=Vector3.new(0,0,ay)
return ClearWideRay(aD+aJ,aE+aJ)and ClearWideRay(aD-aJ,aE-aJ)and ClearWideRay(aD
+aK,aE+aK)and ClearWideRay(aD-aK,aE-aK)end local aJ=Vector3.new(-aI.Z,0,aI.X).
Unit*ay local aK=Vector3.new(0,ay,0)return ClearWideRay(aD+aJ,aE+aJ)and
ClearWideRay(aD-aJ,aE-aJ)and ClearWideRay(aD+aK,aE+aK)and ClearWideRay(aD-aK,aE-
aK)end local function PullWide(aD)if#aD<=2 then return aD end local aE={aD[1]}
local aF=1 local aG=#aD while aG>aF do local aH=aG while aH>aF+1 do local aI,aJ=
aE[#aE],aD[aH]local aK=(aF==1)and aA or 0 local aL=(aH==aG)and aA or 0 if
ClearWide(aI,aJ,aK,aL)then break end aH=aH-1 end aE[#aE+1]=aD[aH]aF=aH end
return aE end local function PushOffWalls(aD)if#aD<=2 then return aD end local
aE=16 local aF=22 local aG={aD[1]}for aH=2,#aD-1 do local aI=aD[aH]local aJ=
Vector3.zero for aK,aL in am do local aM=Block(aI,aI+aL*aE,Blocks)if aM then
local aN=(aM.Position-aI).Magnitude if aE>aN then aJ=aJ-aL*(aE-aN)end end end
local aK=Block(aI,aI+Vector3.new(0,aE,0),Blocks)if aK then local aL=(aK.Position
-aI).Magnitude if aL<4 then aJ=aJ+Vector3.new(0,-(4-aL),0)end end if aJ.
Magnitude>0.1 then if aJ.Magnitude>aF then aJ=aJ.Unit*aF end local aL=aI+aJ aG[#
aG+1]=Clear(aG[#aG],aL)and aL or aI else aG[#aG+1]=aI end end aG[#aG+1]=aD[#aD]
return aG end local aD pcall(function()aD=Instance.new'VirtualInputManager'end)
local function VimSpace()if not aD then return end pcall(function()aD:
SendKeyEvent(true,Enum.KeyCode.Space,false,game)aD:SendKeyEvent(false,Enum.
KeyCode.Space,false,game)end)end local aE=125 local aF=25 local aG=3 local aH=8
local aI=25 local aJ=4 local function ClimbCap()return aj.RiseSpeed end local 
function ZeroVel(aK)if aK then aK.AssemblyLinearVelocity=Vector3.zero aK.
AssemblyAngularVelocity=Vector3.zero end end ai.ZeroVel=ZeroVel local function 
HasCarpet()local aK=af:FindFirstChildOfClass'Backpack'for aL,aM in ab.Flying do
if(aK and aK:FindFirstChild(aM))or(af.Character and af.Character:FindFirstChild(
aM))then return true end end return false end local aK=-10 local aL=4.250000000784
function ai.MoveThrough(aM,aN,aO,aP)if not aM or not aM.Parent or#aN==0 then
return end local aQ=type(aO)=='function'and aO or nil local aR=if aQ then aQ()
else(aO or aj.TPVelocity or aj.CarpetSpeed)local aS=ai.Gen if ai.DrawRoute then
pcall(ai.DrawRoute,aM.Position,aN)end local aT=1 local aU=false local aV local 
function finish()if aU then return end aU=true SetLaserQuery(false)if aM and aM.
Parent then aM.AssemblyLinearVelocity=Vector3.zero aM.AssemblyAngularVelocity=
Vector3.zero local aW=aN[#aN]if(aW-aM.Position).Magnitude<=aF and Block(aM.
Position,aW,Solid)==nil then if math.abs(aW.Y-aM.Position.Y)>10 then local aX=aM
.Parent:FindFirstChildOfClass'Humanoid'if aX then pcall(function()aX:
ChangeState(Enum.HumanoidStateType.Jumping)end)pcall(function()aX.Jump=true end)
end end local aX,aY=aM.CFrame:ToEulerAnglesYXZ()aM.CFrame=CFrame.new(aW)*CFrame.
Angles(0,aY,0)end end if aV then aV:Disconnect()end end local aW,aX=math.huge,0
local aY=aM.Position local aZ=0 local a_=aM.Parent and aM.Parent:
FindFirstChildOfClass'Humanoid'local a0=a_~=nil and a_.FloorMaterial~=Enum.
Material.Air local a2=false local a4 aV=ad.Heartbeat:Connect(function()if not aM
or not aM.Parent or aU then if aV then aV:Disconnect()end return end if ai.Gen~=
aS then finish()return end if not ab.Held(af.Character)then ab.Equip()if
HasCarpet()then aM.AssemblyLinearVelocity=Vector3.zero return end end do local
a5=aM.Position local a6=(Vector3.new(a5.X,0,a5.Z)-Vector3.new(aY.X,0,aY.Z)).
Magnitude if a6>aZ then aZ=a6 elseif a6<aZ-15 then GovSnap()aZ=a6 if ai.
LastStats and not ai.LastStats.lagInfo then ai.LastStats.lagInfo={carpet=af:
GetAttribute'HasFlyingCarpet'==true,reach=a6}end end end local a5=aM.Parent and
aM.Parent:FindFirstChildOfClass'Humanoid'if a5 then local a6=a5.FloorMaterial~=
Enum.Material.Air if a0 and not a6 and not a2 then a2=true pcall(function()a5:
ChangeState(Enum.HumanoidStateType.Jumping)end)pcall(function()a5.Jump=true end)
end a0=a6 if ah then a5.AutoRotate=false end end local a6=if aQ then aQ()else aR
local a7=math.max(aG,a6/60*1.25)local function Drive(a8,a9)local b=a8.Unit local
ba=a6 local bb=ClimbCap()if b.Y>0 and b.Y*ba>bb then ba=bb/b.Y end if ai.
SpeedActive then aM.CFrame=aM.CFrame+b*math.min(a9,ba/60)aM.
AssemblyLinearVelocity=Vector3.zero else aM.Velocity=Vector3.new(b.X*ba,b.Y*ba,b
.Z*ba)end end local a8=aM.Position local a9,b,ba,bb=math.huge,aT,a8,math.huge
for bc=aT,1,-1 do local c=if bc==1 then aY else aN[bc-1]local e=aN[bc]-c local f
=e:Dot(e)local g=if 1e-6<f then c+e*math.clamp((a8-c):Dot(e)/f,0,1)else c local
h=(a8-g).Magnitude if bc==aT then bb=h end if h<a9 then a9,b,ba=h,bc,g end end
if aT>b and a9+aJ<bb then aT=b aW,aX=math.huge,0 end if a9>aI then finish()
return end if a9>math.max(aH,a7+2)then aW,aX=math.huge,0 Drive(ba-a8,a9)return
end local bc=aN[aT]local c=bc-a8 local e=c.Magnitude if aT<#aN and e<26 then
local f=aN[1+aT]local g=f-bc if e>0.1 and g.Magnitude>0.1 and c.Unit:Dot(g.Unit)
<0.9 then a6=math.min(a6,aj.TurnSpeed)end end a7=math.max(aG,a6/60*1.25)if e<a7
then local f=false repeat aT=aT+1 if aT>#aN then finish()return end f=true bc=aN
[aT]c=bc-aM.Position e=c.Magnitude until a7<=e if f then VimSpace()aW,aX=math.
huge,0 end end if e>aW-0.05 then aX=1+aX else aX=0 end aW=e if aX>=6 then
finish()return end if e>=0.1 then if(aP or c.Y>10)and c.Y>5 and aT<#aN then
local f=aM.Parent and aM.Parent:FindFirstChildOfClass'Humanoid'if f then local g
=f:GetState()if g~=Enum.HumanoidStateType.Jumping and g~=Enum.HumanoidStateType.
Freefall then pcall(function()f:ChangeState(Enum.HumanoidStateType.Jumping)end)
pcall(function()f.Jump=true end)end end end Drive(c,e)end end)local a5=0 local
a6=aM.Position for a7,a8 in aN do a5=a5+(a6-a8).Magnitude a6=a8 end local a7=a5/
math.min(aE,aR)+2 local a8=0 while not aU and a8<a7 and ai.Gen==aS do task.wait(
0.05)a8=a8+0.05 end finish()ZeroVel(aM)end local aM=120 local aN=Instance.new
'Part'aN.Anchored=true aN.CanCollide=false aN.CanQuery=false aN.CanTouch=false
local aO=OverlapParams.new()aO.FilterType=Enum.RaycastFilterType.Include aO.
MaxParts=1 local function BoxSolid(aP,aQ,aR)for aS,aT in workspace:
GetPartBoundsInBox(aP,aQ,aR)do local aU=aT.Size if math.max(aU.X,aU.Y,aU.Z)<aM
and not aT:IsA'TriangleMeshPart'then return true end aN.CFrame,aN.Size=aP,aQ aO.
FilterDescendantsInstances={aT}if#workspace:GetPartsInPart(aN,aO)>0 then return
true end end return false end(function()local aP=math.floor local aQ=math.sqrt
local aR=math.min local aS=math.max local aT=math.abs local aU=4096 local aV=aU*
aU local aW=2048 local aX=300000 local aY=1 local aZ=3 local a_=8 local a0=16
local a2=1 local a4=26 local a5=220000 local a6=96 local a7=8192 local a8=
OverlapParams.new()a8.FilterType=Enum.RaycastFilterType.Exclude a8.
RespectCanCollide=true a8.MaxParts=8 local a9=RaycastParams.new()a9.FilterType=
Enum.RaycastFilterType.Exclude a9.RespectCanCollide=true a9.IgnoreWater=true
local b={}local ba local bb=Vector3.zero local bc,c,e=0,0,0 local f,g,h=4,2.5,5
local i=0 local function World(j,k,l,m)local n=j*0.5 return Vector3.new(bb.X+k*j
+n,bb.Y+l*j+n,bb.Z+m*j+n)end local function Cell(j,k)return aP((k.X-bb.X)/j),aP(
(k.Y-bb.Y)/j),aP((k.Z-bb.Z)/j)end local function IsSolid(j,k,l)if j<0 or k<0 or
l<0 or j>=bc or k>=c or l>=e then return true end local m=f*0.5 local n=bb.X+j*f
+m local o=bb.Y+k*f+m local p=bb.Z+l*f+m local q=(aP(n/f)+aW)+(aP(o/f)+aW)*aU+(
aP(p/f)+aW)*aV local r=b[q]if r~=nil then return r end local s=f+g local t=f<h
and h or f local u=BoxSolid(CFrame.new(n,o-m+t*0.5,p),Vector3.new(s,t,s),a8)b[q]
=u return u end local function SegmentClear(j,k,l,m,n)local o=k-j local p=o.
Magnitude if p<0.05 then return true end if workspace:Raycast(j,o,a9)then return
false end local q=aY<l and l or aY if workspace:Blockcast(CFrame.new(j),Vector3.
new(q*2,m,q*2),o,a9)~=nil then return false end if not n then return true end
local r=aR(aP(p),a6)if r<2 then return true end local s=o/r local t=Vector3.new(
q*2,aZ,q*2)for u=1,r-1 do if BoxSolid(CFrame.new(j+s*u),t,a8)then return false
end end return true end local j={}for k=-1,1 do for l=-1,1 do for m=-1,1 do if k
~=0 or l~=0 or 0~=m then j[#j+1]={k,l,m,aQ(k*k+l*l+m*m),(k~=0 and 1 or 0)+(l~=0
and 1 or 0)+(0~=m and 1 or 0),k+l*aU+m*aV}end end end end local function 
NoCornerCut(k,l,m,n)if n[5]<2 then return true end if n[1]~=0 and IsSolid(k+n[1]
,l,m)then return false end if n[2]~=0 and IsSolid(k,l+n[2],m)then return false
end if n[3]~=0 and IsSolid(k,l,m+n[3])then return false end return true end
local function SnapCell(k,l,m,n)if not IsSolid(k,l,m)then return k,l,m end for o
=1,a0 do for p=-o,o do for q=-o,o do local r=aT(p)==o or aT(q)==o for s=-o,o,(r
and 1 or o+o)do local t,u,v=k+p,l+q,m+s if not IsSolid(t,u,v)and n(t,u,v)then
return t,u,v end end end end end return k,l,m end local function NewHeap()return
{F={},K={},N=0}end local function HeapPush(k,l,m)local n=k.N+1 k.N=n local o,p=k
.F,k.K o[n],p[n]=l,m local q=n while q>1 do local r=aP(q*0.5)if o[r]<=o[q]then
break end o[r],o[q]=o[q],o[r]p[r],p[q]=p[q],p[r]q=r end end local function 
HeapPop(k)local l=k.N if l==0 then return nil end local m,n=k.F,k.K local o=n[1]
m[1],n[1]=m[l],n[l]l-=1 k.N=l local p=1 while true do local q,r,s=p+p,p+p+1,p if
q<=l and m[q]<m[s]then s=q end if l>=r and m[r]<m[s]then s=r end if s==p then
break end m[p],m[s]=m[s],m[p]n[p],n[s]=n[s],n[p]p=s end return o end local 
function GridLOS(k,l,m,n,o,p)local q,r,s=n-k,o-l,p-m local t=aP(aS(aT(q),aT(r),
aT(s))*2)if t<2 then return true end local u,v,w=q/t,r/t,s/t for x=1,t-1 do if
IsSolid(aP(k+u*x+0.5),aP(l+v*x+0.5),aP(m+w*x+0.5))then return false end end
return true end local k={['Lazy Theta*']={hw=1.25,los='lazy',gw=1},['Theta*']={
los='eager',gw=1,hw=1.25},['A*']={los='none',gw=1,hw=1.25},['Weighted A* 2.5']={
hw=2.5,gw=1,los='none'},['Weighted A* 5']={los='none',gw=1,hw=5},['Anytime A*']=
{anytime=true},['Beam A*']={los='none',gw=1,hw=1.25,beam=3000},Greedy={hw=1,gw=0,los=
'none'},['Greedy Theta*']={los='none',gw=0,hw=1,pull=true},Dijkstra={
los='none',gw=1,hw=0},['Bi A*']={bi=true,hw=1.25},['Bi Theta*']={hw=1.25,bi=true,pull=true},['Bi Dijkstra']={bi=true,hw=0}}ai.PathMethod='VIS'local function 
PullCells(l)if#l<3 then return l end local m={l[1]}local n=1 while n<#l do local
o=#l while o>n+1 do local p,q=m[#m],l[o]if GridLOS(p.x,p.y,p.z,q.x,q.y,q.z)then
break end o-=1 end m[#m+1]=l[o]n=o end return m end local function TrimHeap(l,m)
local n=table.create(l.N)for o=1,l.N do n[o]=o end local o=l.F table.sort(n,
function(p,q)return o[p]<o[q]end)local p,q=table.create(m),table.create(m)for r=
1,m do local s=n[r]p[r],q[r]=l.F[s],l.K[s]end l.F,l.K,l.N=p,q,m end local 
function SnapEnds(l,m,n)local o,p,q=Cell(l,m)local r,s,t=Cell(l,n)local u,v,w=
SnapCell(o,p,q,function(u,v,w)return not workspace:Raycast(m,World(l,u,v,w)-m,a9
)end)local x,y,z=SnapCell(r,s,t,function(x,y,z)return(World(l,x,y,z)-n).
Magnitude<=a_ end)return u,v,w,x,y,z end local function SearchUni(l,m,n,o)local
p,q,r,s,t,u=SnapEnds(l,m,n)local v=s+t*aU+u*aV local w=p+q*aU+r*aV local x={[w]=
{g=0,parent=w,z=r,y=q,x=p}}local y={}local z=NewHeap()HeapPush(z,0,w)local A,B,C
=o.los,o.gw,o.hw local function Heur(D,E,F)local G,H,I=D-s,E-t,F-u return aQ(G*G
+H*H+I*I)end local function BuildTo(D)local E,F={},x[D]while true do E[#E+1]=F
local G=x[F.parent]if not G or G==F then break end F=G end local G={}for H=#E,1,
-1 do G[#G+1]=E[H]end if o.pull then G=PullCells(G)end local H={}for I,J in G do
H[#H+1]=World(l,J.x,J.y,J.z)end return H end local D,E=w,Heur(p,q,r)local F=0
while z.N>0 do local G=HeapPop(z)if y[G]then continue end local H=x[G]if A==
'lazy'then local I=x[H.parent]if I~=H and not GridLOS(I.x,I.y,I.z,H.x,H.y,H.z)
then local J,K=math.huge for L,M in j do local N=G+M[6]local O=y[N]and x[N]if O
and O.g+M[4]<J then J,K=O.g+M[4],N end end if not K then continue end H.g,H.
parent=J,K end end y[G]=true F+=1 if aX<F then break end if F%a7==0 then if os.
clock()>i then break end ad.Heartbeat:Wait()end local I=Heur(H.x,H.y,H.z)if I<E
then E=I D=G end if G==v then return BuildTo(G)end local J,K,L=H.x,H.y,H.z for M
,N in j do local O=G+N[6]if y[O]then continue end local P,Q,R=J+N[1],K+N[2],L+N[
3]if IsSolid(P,Q,R)then continue end if not NoCornerCut(J,K,L,N)then continue
end local S,T if A=='none'then S,T=H.g+N[4],G else local U=x[H.parent]if 'eager'==
A and not GridLOS(U.x,U.y,U.z,P,Q,R)then S,T=H.g+N[4],G else local V,W,X=P-
U.x,Q-U.y,R-U.z S,T=U.g+aQ(V*V+W*W+X*X),H.parent end end local U=x[O]if not U
then x[O]={g=S,parent=T,x=P,z=R,y=Q}elseif S<U.g then U.g,U.parent,U.x,U.y,U.z=S
,T,P,Q,R else continue end HeapPush(z,B*S+C*Heur(P,Q,R),O)end if o.beam and z.N>
o.beam then TrimHeap(z,aP(o.beam*0.5))end end if D~=w then return BuildTo(D)end
return nil end local function SearchBi(l,m,n,o)local p,q,r,s,t,u=SnapEnds(l,m,n)
local v=p+q*aU+r*aV local w=s+t*aU+u*aV if v==w then return{World(l,s,t,u)}end
local function Side(x,y,z,A,B,C)local D=x+y*aU+z*aV return{nodes={[D]={g=0,parent=false,y=y,z
=z,x=x}},closed={},heap=NewHeap(),tx=A,ty=B,tz=C}end local x=Side(p
,q,r,s,t,u)local y=Side(s,t,u,p,q,r)HeapPush(x.heap,0,v)HeapPush(y.heap,0,w)
local z,A=math.huge local B=0 local function Step(C,D)if C.heap.N==0 then return
false end local E=HeapPop(C.heap)if C.closed[E]then return true end C.closed[E]=
true B+=1 if B>aX then return false end if B%a7==0 then if os.clock()>i then
return false end ad.Heartbeat:Wait()end local F=C.nodes[E]if D.closed[E]then
local G=F.g+D.nodes[E].g if z>G then z=G A=E end end local G,H,I=F.x,F.y,F.z for
J,K in j do local L=E+K[6]if C.closed[L]then continue end local M,N,O=G+K[1],H+K
[2],I+K[3]if IsSolid(M,N,O)then continue end if not NoCornerCut(G,H,I,K)then
continue end local P=F.g+K[4]local Q=C.nodes[L]if not Q then C.nodes[L]={g=P,parent=E,y=N,z=O,x=M}elseif P<Q.g then Q.g,Q.parent,Q.x,Q.y,Q.z=P,E,M,N,O else
continue end local R,S,T=M-C.tx,N-C.ty,O-C.tz HeapPush(C.heap,P+(o.hw or 1.25)*
aQ(R*R+S*S+T*T),L)end return true end while x.heap.N>0 and y.heap.N>0 do if A
and x.heap.F[1]+y.heap.F[1]>=z then break end if not Step(x,y)then break end if
not Step(y,x)then break end end if not A then return nil end local C={}local D={
}local E=x.nodes[A]while E do D[#D+1]=E E=E.parent and x.nodes[E.parent]end for
F=#D,1,-1 do C[#C+1]=D[F]end E=y.nodes[A]E=E.parent and y.nodes[E.parent]while E
do C[#C+1]=E E=E.parent and y.nodes[E.parent]end if o.pull then C=PullCells(C)
end local F={}for G,H in C do F[#F+1]=World(l,H.x,H.y,H.z)end return F end local
l={5,2.5,1.5,1.25}local function Search(m,n,o)local p=k[ai.PathMethod]or k[
'Lazy Theta*']if p.bi then return SearchBi(m,n,o,p)end if not p.anytime then
return SearchUni(m,n,o,p)end local q for r,s in l do if os.clock()>i then break
end local t=SearchUni(m,n,o,{hw=s,los='none',gw=1})if t then q=t end end return
q end local function Simplify(m,n,o)if not m or#m<3 then return m end local p={m
[1]}local q=1 for r=2,#m do if not SegmentClear(m[q],m[r+1]or m[r],n,o,false)
then p[#p+1]=m[r]q=r end end p[#p+1]=m[#m]return p end local function Smooth(m,n
,o)if not m or#m<3 or 0>=n then return m end local p={m[1]}for q=2,#m-1 do local
r,s,t=m[q-1],m[q],m[q+1]local u,v=r-s,t-s local w,x=u.Magnitude,v.Magnitude if w
<1e-3 or x<1e-3 then p[#p+1]=s continue end local y=aR(n,0.5*w,x*0.5)local z,A=s
+u.Unit*y,s+v.Unit*y local B={z}for C=1,o-1 do local D=C/o local E=1-D B[#B+1]=z
*(E*E)+s*(2*E*D)+A*(D*D)end B[#B+1]=A local C=true for D=1,#B-1 do if workspace:
Raycast(B[D],B[1+D]-B[D],a9)then C=false break end end if not C then p[#p+1]=s
continue end for D,E in B do p[#p+1]=E end end p[#p+1]=m[#m]return p end local 
function FitCell(m,n,o,p)local q=aT(n.X-m.X)+o*2 local r=aT(n.Y-m.Y)+a2+a4 local
s=aT(n.Z-m.Z)+o*2 local t=(q*r*s)/(p*p*p)if t<=a5 then return p end return p*(t/
a5)^(0.3333333333333333)end local function Attempt(m,n,o,p,q,r)p=FitCell(m,n,o,p
)f,g,h=p,q,r local s=p*131+q if s~=ba then table.clear(b)ba=s end bb=Vector3.
new(aP((aR(m.X,n.X)-o)/p)*p,aP((aR(m.Y,n.Y)-a2)/p)*p,aP((aR(m.Z,n.Z)-o)/p)*p)
local t=Vector3.new(aS(m.X,n.X)+o,aS(m.Y,n.Y)+a4,aS(m.Z,n.Z)+o)-bb bc=aP(t.X/p)+
1 c=aP(t.Y/p)+1 e=aP(t.Z/p)+1 if bc>=aU or c>=aU or e>=aU then return nil end
return Search(p,m,n)end local function AnchorEnds(m,n,o,p,q)if#m==1 then m[1]=n
m[2]=o return true end if SegmentClear(n,m[2],p,q,true)then m[1]=n else table.
insert(m,1,n)end local r=m[#m-1]if SegmentClear(r,o,p,q,true)or SegmentClear(r,
Vector3.new(o.X,r.Y,o.Z),p,q,true)then m[#m]=o return true end return false end
local m={Budget=0.15,MaxNodes=160,Pad=0.7,MaxChecks=400}ai.Vis=m ai.VisFallbacks
=0 local n={[Enum.HumanoidStateType.Running]=true,[Enum.HumanoidStateType.
RunningNoPhysics]=true,[Enum.HumanoidStateType.Landed]=true}local o,p local q=
1.8 local function BodyVolume()local r=af.Character local s=r and r:
FindFirstChild'HumanoidRootPart'local t=r and r:FindFirstChildOfClass'Humanoid'
if not s or not t then return nil,nil end local u=t.HipHeight+s.Size.Y*0.5 local
v=n[t:GetState()]and t.FloorMaterial~=Enum.Material.Air if not v and o==r then
return p,u end local w,x,y=0,0,0 for z,A in r:GetChildren()do if not A:IsA
'BasePart'then continue end local B=A.Position-s.Position local C=A.Size*0.5 w=
aS(w,aQ(B.X*B.X+B.Z*B.Z)+aS(C.X,C.Z))x=aR(x,B.Y-C.Y)y=aS(y,B.Y+C.Y)end if not v
then w=aR(w,q)end local z=aS(y-x-0.5,1)local A={Size=Vector3.new(w*2,z,w*2),
Offset=Vector3.new(0,x+0.5+z*0.5,0)}if v then o,p=r,A end return A,u end ai.
BodyVolume=BodyVolume local function Flat(r,s)local t,u=r.X-s.X,r.Z-s.Z return
aQ(t*t+u*u)end function m.Plan(r,s,t,u)local v={r,s}local w={}local x={}local y=
0 local z=false local A=t.Size.X*0.5+m.Pad local B={}local C={near=0,floor=0,
body=0}local D={}local function Add(E)if#v>=m.MaxNodes then z=true return end
for F,G in v do if Flat(G,E)<1 then C.near+=1 return end end local F=workspace:
Raycast(E+Vector3.new(0,3,0),Vector3.new(0,-20,0),a9)if not F or F.Normal.Y<0.65
then C.floor+=1 return end local G=Vector3.new(E.X,aS(F.Position.Y+u,r.Y),E.Z)if
BoxSolid(CFrame.new(G+t.Offset),t.Size,a8)then C.body+=1 return end v[#v+1]=G B[
#B+1]=#v end local function Box(E,F,G)G=G or A local H,I,J,K if aT(E.UpVector.Y)
>0.98 then local L,M=E.RightVector,E.LookVector J=Vector3.new(L.X,0,L.Z).Unit K=
Vector3.new(M.X,0,M.Z).Unit H,I=F.X*0.5,F.Z*0.500000000606 else local L=E-E.Position local
M=aT(L.RightVector.X)*F.X+aT(L.UpVector.X)*F.Y+aT(L.LookVector.X)*F.Z local N=
aT(L.RightVector.Z)*F.X+aT(L.UpVector.Z)*F.Y+aT(L.LookVector.Z)*F.Z J,K=Vector3.
xAxis,Vector3.zAxis H,I=0.5*M,N*0.5 end local L=Vector3.new(E.Position.X,r.Y,E.
Position.Z)for M,N in{-1,1}do for O,P in{-1,1}do Add(L+J*(N*(H+G))+K*(P*(I+G)))
end end end local function Discover(E)if not E or w[E]or not E:IsA'BasePart'then
return end w[E]=true if#D<8 then D[#D+1]=string.format('%s (%.0f,%.0f,%.0f)',E.
Name,E.Size.X,E.Size.Y,E.Size.Z)end if aS(E.Size.X,E.Size.Y,E.Size.Z)>=aM then
return end Box(E.CFrame,E.Size)end local function Sweep(E,F,G)local H=Vector3.
new(F.X-E.X,0,F.Z-E.Z)if H.Magnitude<0.05 then return nil end return workspace:
Blockcast(CFrame.new(E+t.Offset),G,H,a9)end local function Edge(E,F)local G=F>E
and E*4096+F or F*4096+E local H=x[G]if nil~=H then return not H end y+=1 if y>m
.MaxChecks then z=true return false end local I,J=v[E],v[F]local K=t.Size+
Vector3.new(1,0,1)local L if F==2 and Flat(I,J)>3 then local M=I+(Vector3.new(J.
X,I.Y,J.Z)-I).Unit*(Flat(I,J)-3)L=Sweep(I,M,K)or Sweep(M,J,t.Size)elseif F==2
then L=Sweep(I,J,t.Size)else L=Sweep(I,J,K)end x[G]=nil~=L if L then Discover(L.
Instance)end return L==nil end local E,F,G,H={[1]=0},{[1]=1},{},{[1]=true}local 
function Adopt(I)local J,K=math.huge for L in G do local M=L<I and L*4096+I or I
*4096+L if x[M]~=true then local N=E[L]+Flat(v[L],v[I])if J>N then K,J=L,N end
end end if K and(not E[I]or J<E[I])then E[I],F[I]=J,K H[I]=true end end local 
function Settle()local I=B B={}for J,K in I do Adopt(K)end end local I=os.clock(
)local J=false while not z do if os.clock()-I>m.Budget then z=true break end
local K,L=math.huge for M in H do local N=E[M]+Flat(v[M],s)if N<K then L,K=M,N
end end if not L then break end H[L]=nil if L~=1 and not Edge(F[L],L)then
Settle()local M={}for N in G do M[#M+1]=N end table.sort(M,function(N,O)return E
[N]+Flat(v[N],v[L])<E[O]+Flat(v[O],v[L])end)local N=false for O,P in M do if
Edge(P,L)then E[L],F[L],N=E[P]+Flat(v[P],v[L]),P,true break end end Settle()if
not N then continue end end G[L]=true if L==2 then J=true break end for M=1,#v
do if not G[M]then local N=E[L]+Flat(v[L],v[M])if not E[M]or N<E[M]then E[M],F[M
]=N,L H[M]=true end end end end ai.LastVis={Nodes=#v,Checks=y,Ms=(os.clock()-I)*
1000,Found=J,Rejects=C,Hits=D}if not J then return nil end local K={}local L=2
while 1~=L do table.insert(K,1,L)L=F[L]end table.insert(K,1,1)local M={}local N=
1 while N<#K do local O=#K while O>N+1 and not Edge(K[N],K[O])do O-=1 end M[#M+1
]=v[K[O] ]N=O end M[#M]=s ai.LastVis.Waypoints=#M return M end function ai.
SolvePath(r,s,t)t=t or{}local u=t.Cell or 4 local v=t.Radius or 2.5 local w=t.
Height or 5 local x=t.Padding or 40 local y={}for z,A in ac:GetPlayers()do if A.
Character then y[#y+1]=A.Character end end for z,A in t.Ignore or{}do y[#y+1]=A
end a8.FilterDescendantsInstances=y a9.FilterDescendantsInstances=y a8.
CollisionGroup=ai.BodyGroup()a9.CollisionGroup=a8.CollisionGroup i=os.clock()+(t
.Budget or 4)ba=nil table.clear(b)if SegmentClear(r,s,v,w,true)then return{s}end
if ai.PathMethod=='VIS'and 40>=x then local z,A=BodyVolume()if z then local B,C=
pcall(m.Plan,r,s,z,A)if B and C then return C end if not B and ai.LastVis then
ai.LastVis.Error=tostring(C)end end ai.VisFallbacks+=1 end local z,A={},{}for B,
C in{aR(35,x),aR(120,x),aR(300,x),x}do if not A[C]then A[C]=true z[#z+1]=C end
end local function Solve(B)local C,D=v for E,F in z do D=Attempt(r,s,F,B,v,w)if
D then break end end if not D and v>0 then for E,F in z do D=Attempt(r,s,F,B,0,w
)if D then C=0 break end end end return D,C end local function PathClear(B,C)for
D=1,#B-2 do if not SegmentClear(B[D],B[D+1],C,w,true)then return false end end
return true end local B={u}for C,D in{6,4}do if D<u then B[#B+1]=D end end local
C,D for E,F in B do local G,H=Solve(F)if G then G=Simplify(G,H,w)local I=
AnchorEnds(G,r,s,H,w)C,D=G,H if(I and PathClear(G,H))or E==#B then break end end
if os.clock()>i then break end end if not C then return nil end if t.Smooth~=
false then C=Smooth(C,t.SmoothRadius or 8,6)end ai.LastSolve={From=r,To=s,Nodes=
#C,Inflate=D}return C end function ai.SegmentClear(r,s,t,u,v)local w={af.
Character}a8.FilterDescendantsInstances=w a9.FilterDescendantsInstances=w a8.
CollisionGroup=ai.BodyGroup()a9.CollisionGroup=a8.CollisionGroup return
SegmentClear(r,s,t or 2.5,u or 5,v~=false)end end)();(function()local aP={
AnimalTarget=true,DeliveryHitbox=true,Hitbox=true,Laser=true,LaserHitbox=true,MainRoot=true,Multiplier=true,SecondFloor=true,Slope=true,ThirdFloor=true,Spawn=true,StealHitbox=true}local aQ={['structure base home']=true,Wall=true,
Floor=true,Roof=true}local aR=6 local aS=16 local aT=3 local aU,aV=0 local 
function CastSkip()local aW=os.clock()if aW-aU>1 then aU=aW local aX={}for aY,aZ
in ac:GetPlayers()do if aZ.Character then aX[#aX+1]=aZ.Character end end aV=aX
end return aV or{}end local function Blocks(aW)if not aW then return false end
if IsLaserPart(aW)then return LaserBlocks(aW)end if aP[aW.Name]then return false
end if aW.CanCollide then return true end if aQ[aW.Name]then return true end
local aX=aW.Size if not aX then return false end return math.max(aX.X*aX.Y,aX.X*
aX.Z,aX.Y*aX.Z)>400 and math.min(aX.X,aX.Y,aX.Z)<4 end ai.BlocksD3=Blocks local 
function SweepHit(aW,aX,aY,aZ)local a_=CastSkip()local a0=table.create(#a_+8)for
a2=1,#a_ do a0[a2]=a_[a2]end local a2=RaycastParams.new()a2.FilterType=Enum.
RaycastFilterType.Exclude a2.IgnoreWater=true a2.CollisionGroup=ai.BodyGroup()
local a4=(aX-aW).Magnitude if a4<0.05 then return nil end local a5=Vector3.new(
math.max(aY,0.100000000187)*2,math.max(aZ,0.1),math.max(aY,0.1)*2)local a6=Vector3.new(aX.X
-aW.X,0,aX.Z-aW.Z)local a7=if a6.Magnitude>0.5 then CFrame.lookAt(Vector3.zero,
a6)else CFrame.identity local a8,a9=aW,0 while a9<a4+1 do a2.
FilterDescendantsInstances=a0 local b=aX-a8 if b.Magnitude<0.05 then return nil
end local ba local bb=pcall(function()ba=workspace:Blockcast(a7+a8,a5,b,a2)end)
if not bb then ba=workspace:Raycast(a8,b,a2)end if not ba then return nil end if
Blocks(ba.Instance)then return ba end a0[#a0+1]=ba.Instance a9=a9+(ba.Position-
a8).Magnitude+0.3 a8=ba.Position+b.Unit*0.3 end return{Instance=nil,Position=aX}
end local function ClearWide(aW,aX)return SweepHit(aW,aX,0.5*aR,4)==nil end ai.
ClearWideD3=ClearWide ai.SweepD3=SweepHit end)();(function()local aP=math.floor
local aQ=math.abs local aR=math.max local aS=math.min local aT=math.sqrt local
aU=os.clock local aV=0.5 local aW=0.12 local aX=0.2 local aY=3 local aZ=1.5
local a_=1.2 local a0=2 local a2=1.5 local a4={true,'mid',false}local a5=30
local a6=30 local a7=80 local a8=60000 local a9={40,20,10}local b=150000 local
ba=250000 local bb={6,12,20,32,48}local bc={4,8}local c={3,6,10}local e={0.5,0.3
,0.700000000903}local f={1,-1}local g={}for h,i in{0,8,-8,16,-16,24,-24}do for j,k in{0,10,
16,22,30,38}do if i~=0 or k~=0 then g[#g+1]={i,k,aQ(i)+k*1.5}end end end table.
sort(g,function(h,i)return h[3]<i[3]end)local h=6 local i=4 local j={0.25,0.5,
0.75}local k=1.25 local l=8 local m=6 local n=3 local o=0.3 local p={1,0.66,0.4,
0.2}local q={0.2,0.4,0.66,1}local r=3 local s=3.5 local t={1,-1,0,0,0,0}local u=
{0,0,0,0,1,-1}local v={0,0,1,-1,0,0}local w={2,1,4,3,6,5}local x=OverlapParams.
new()x.FilterType=Enum.RaycastFilterType.Exclude x.MaxParts=160 local y=Instance
.new'Part'y.Anchored=true y.CanCollide=false y.CanQuery=false y.CanTouch=false
local z=OverlapParams.new()z.FilterType=Enum.RaycastFilterType.Include z.
MaxParts=1 local A=function(A)return true end local B,C=Vector3.zero,Vector3.
zero local D,E,F,G,H=1.8,3.5,3.3,0,5 local I,J=false,false local K=math.huge
local function Solid(L,M,N)local O=if N then CFrame.lookAt(L,L+N)else CFrame.
new(L)for P,Q in workspace:GetPartBoundsInBox(O,M,x)do if not A(Q)then continue
end local R=Q.Size if aR(R.X,R.Y,R.Z)<aM and not Q:IsA'TriangleMeshPart'then
return true end y.CFrame,y.Size=O,M z.FilterDescendantsInstances={Q}if#workspace
:GetPartsInPart(y,z)>0 then return true end end return false end local function 
Setup(L,M)B,C=L,M I,J=false,false local N,O,P=1.5,0,5 local Q=ai.BodyVolume and
ai.BodyVolume()if Q then N,O,P=Q.Size.X*0.5,Q.Offset.Y,Q.Size.Y end D,E,F,G,H=N+
o,N+m,N+n,O,P A=ai.BlocksD3 or A local R={}for S,T in ac:GetPlayers()do if T.
Character then R[#R+1]=T.Character end end x.FilterDescendantsInstances=R x.
CollisionGroup=ai.BodyGroup()end local function NearEnd(L)local M,N=L.X-B.X,L.Z-
B.Z local O,P=L.X-C.X,L.Z-C.Z local Q=l*l return M*M+N*N<=Q or O*O+P*P<=Q end
local function BodyFree(L,M,N,O)return not Solid(L+Vector3.new(0,G,0),Vector3.
new(2*M,N or H,M*2),O)end local function InBubble(L,M,N)local O,P=L.X-M.X,L.Z-M.
Z return aQ(L.Y-M.Y)<N and O*O+P*P<=s*s end local function Given(L,M)return(I
and InBubble(L,B,M))or(J and InBubble(L,C,M))end local function LegFree(L,M,N,O)
local P=M-L local Q=Vector3.new(P.X,0,P.Z)local R=if Q.Magnitude>0.5 then Q.Unit
else nil local S=aR(1,math.ceil(P.Magnitude/aS(1.5,D)))for T=0,S do if T%32==31
and aU()>K then return false end local U=L+P*(T/S)if(U-B).Magnitude<0.75 or(U-C)
.Magnitude<1.5 or Given(U,0.75)then continue end if not BodyFree(U,(N and not
NearEnd(U))and(O or E)or D,nil,R)then return false end end return true end local 
function SnapFree(L,M)local N,O if M.Y>L.Y then N,O=Vector3.new(L.X,M.Y,L.Z),
Vector3.new(M.X,M.Y,L.Z)else N,O=Vector3.new(M.X,L.Y,L.Z),Vector3.new(M.X,L.Y,M.
Z)end return LegFree(L,N,false)and LegFree(N,O,false)and LegFree(O,M,false)end
local function NewGrid(L,M,N,O,P)local Q,R=aS(B.X,C.X)-a5,aS(B.Z,C.Z)-a5 local S
,T=aR(B.X,C.X)+a5,aR(B.Z,C.Z)+a5 local U,V=aP((C.X-Q)/L+0.5),aP((C.Z-R)/L+0.5)
local W={Sz=L,Roomy=P,Free={},Near={},GX=U,GZ=V}W.OX,W.OZ=C.X-U*L,C.Z-V*L if M
then W.OY,W.GY,W.NY=M,0,1 else local X=aP((C.Y-N)/L+0.5)W.OY,W.GY=C.Y-X*L,X W.NY
=aP((O-W.OY)/L)+1 end W.NX=aP((S-W.OX)/L)+1 W.NZ=aP((T-W.OZ)/L)+1 return W end
local function CellPos(L,M,N,O)return Vector3.new(L.OX+M*L.Sz,L.OY+N*L.Sz,L.OZ+O
*L.Sz)end local function CellOf(L,M)return aP((M.X-L.OX)/L.Sz+0.5),aP((M.Y-L.OY)
/L.Sz+0.5),aP((M.Z-L.OZ)/L.Sz+0.5)end local function StartCell(L,M)local N,O,P=(
M.X-L.OX)/L.Sz,(M.Y-L.OY)/L.Sz,(M.Z-L.OZ)/L.Sz local Q=L.NY>1 and{aP(O),aP(O)+1}
or{0}local R={}for S,T in{aP(N),aP(N)+1}do for U,V in Q do for W,X in{aP(P),aP(P
)+1}do if T>=0 and V>=0 and X>=0 and T<L.NX and V<L.NY and X<L.NZ then R[#R+1]={
T,V,X,(CellPos(L,T,V,X)-M).Magnitude}end end end end table.sort(R,function(S,T)
return S[4]<T[4]end)for S,T in R do if SnapFree(M,CellPos(L,T[1],T[2],T[3]))then
return T[1],T[2],T[3]end end return CellOf(L,M)end local function CellFree(L,M,N
,O)if M<0 or N<0 or O<0 or M>=L.NX or N>=L.NY or O>=L.NZ then return false end
local P=M+(O+N*L.NZ)*L.NX local Q=L.Free[P]if Q==nil then local R=CellPos(L,M,N,
O)local S=if NearEnd(R)or not L.Roomy then D elseif L.Roomy=='mid'then D+a2 else
E Q=Given(R,L.Sz*0.5)or BodyFree(R,aR(S,L.Sz*0.5),aR(H,L.Sz))L.Free[P]=Q end
return Q end local function CellNear(L,M,N,O)local P=M+(O+N*L.NZ)*L.NX local Q=L
.Near[P]if Q==nil then local R=CellPos(L,M,N,O)Q=not NearEnd(R)and not BodyFree(
R,aR(E,L.Sz*0.5),aR(H,L.Sz))L.Near[P]=Q end return Q end local function Search(L
,M,N,O,P)local Q,R=L.NX,L.NZ local S,T,U=L.GX,L.GY,L.GZ local V=L.NY>1 and 6 or
4 local W,X={},{}local Y,Z,_={},{},0 local function Push(bd,be)_+=1 Y[_],Z[_]=bd
,be local bf=_ while 1<bf do local bg=aP(bf*0.5)if Y[bg]<=Y[bf]then break end Y[
bg],Y[bf]=Y[bf],Y[bg]Z[bg],Z[bf]=Z[bf],Z[bg]bf=bg end end local function Pop()
local bd=Z[1]Y[1],Z[1]=Y[_],Z[_]_-=1 local be=1 while true do local bf,bg,bh=be+
be,be+be+1,be if bf<=_ and Y[bf]<Y[bh]then bh=bf end if bg<=_ and Y[bg]<Y[bh]
then bh=bg end if bh==be then break end Y[be],Y[bh]=Y[bh],Y[be]Z[be],Z[bh]=Z[bh]
,Z[be]be=bh end return bd end local function Heur(bd,be,bf,bg)local bh,bi,bj=S-
bd,T-be,U-bf local bk=(bh~=0 and 1 or 0)+(bi~=0 and 1 or 0)+(bj~=0 and 1 or 0)if
bk==0 then return 0 end local bl=bg==0 or t[bg]*bh>0 or u[bg]*bi>0 or v[bg]*bj>0
return aQ(bh)+aQ(bj)+aQ(bi)*aZ+(bk-(bl and 1 or 0))*aY end local function Unwind
(bd)local be={}while bd do local bf=W[bd]be[#be+1]=bf bd=bf[6]end local bf={}for
bg=#be,1,-1 do bf[#bf+1]=be[bg]end return bf end local bd=(M+(O+N*R)*Q)*8 W[bd]=
{M,N,O,0,0,false}Push(0,bd)local be,bf=bd,aQ(S-M)+aQ(T-N)+aQ(U-O)local bg=0
while 0<_ do local bh=Pop()if X[bh]then continue end X[bh]=true bg+=1 if bg>ba
or(bg%256==0 and aU()>P)then break end local bi=W[bh]local bj,bk,bl,bm,bn=bi[1],
bi[2],bi[3],bi[4],bi[5]local bo=aQ(S-bj)+aQ(T-bk)+aQ(U-bl)if bo<bf then be,bf=bh
,bo end if bo==0 then return Unwind(bh),true end for bp=1,V do if bm~=0 and bp==
w[bm]then continue end local bq,br,bs=bj+t[bp],bk+u[bp],bl+v[bp]if not(bq==S and
br==T and bs==U)and not CellFree(L,bq,br,bs)then continue end local bt=bn+(bp>4
and aZ or 1)+((bm~=0 and bp~=bm)and aY or 0)+((L.Roomy~=true and CellNear(L,bq,
br,bs))and a0 or 0)local bu=(bq+(bs+br*R)*Q)*8+bp if X[bu]then continue end
local bv=W[bu]if bv and bv[5]<=bt then continue end W[bu]={bq,br,bs,bp,bt,bh}
Push(bt+a_*Heur(bq,br,bs,bp),bu)end end return Unwind(be),false end local 
function Corners(bd,be)local bf={}for bg=2,#be do local bh,bi=be[bg],be[bg+1]if
not bi or bi[4]~=bh[4]then bf[#bf+1]=CellPos(bd,bh[1],bh[2],bh[3])end end return
bf end local function Axis(bd)local be,bf,bg=aQ(bd.X)>0.05,aQ(bd.Y)>0.05,aQ(bd.Z
)>0.05 if be and not bf and not bg then return bd.X>0 and 1 or-1 end if bf and
not be and not bg then return bd.Y>0 and 2 or-2 end if bg and not be and not bf
then return bd.Z>0 and 3 or-3 end return 0 end local function Cube(bd,be)local
bf,bg={},bd local function Add(bh)if(bh-bg).Magnitude<0.05 then return end bf[#
bf+1]=bh bg=bh end for bh,bi in be do if bi.Y>bg.Y+0.05 then Add(Vector3.new(bg.
X,bi.Y,bg.Z))end if aQ(bi.X-bg.X)>0.05 then Add(Vector3.new(bi.X,bg.Y,bg.Z))end
if aQ(bi.Z-bg.Z)>0.05 then Add(Vector3.new(bg.X,bg.Y,bi.Z))end Add(bi)end local
bh,bi={},bd for bj,bk in bf do local bl=bf[bj+1]if bl and Axis(bk-bi)~=0 and
Axis(bk-bi)==Axis(bl-bk)then continue end bh[#bh+1]=bk bi=bk end bh[aR(#bh,1)]=
be[#be]return bh end local function FlatCell(bd)local be=aS(r,2*D)local bf=(aQ(B
.X-C.X)+bd)*(aQ(B.Z-C.Z)+bd)return aR(be,aT(bf/a8))end local function Direct(bd,
be)local bf=be-bd local bg=bf.Magnitude>0.5 and be-bf.Unit*aS(8,bf.Magnitude*0.4
)or be return ai.ClearWideD3(bd,bg)and LegFree(bd,be,true,F)end local function 
Straight(bd,be)if Direct(bd,be)then return{be}end local bf=Vector3.new(be.X-bd.X
,0,be.Z-bd.Z)if aQ(be.Y-bd.Y)>0.5 and bf.Magnitude>4 then local bg=bf.Unit for
bh,bi in a9 do if bi>=bf.Magnitude*0.8 then continue end if be.Y>bd.Y then local
bj=Vector3.new(bd.X,be.Y,bd.Z)+bg*bi if LegFree(bd,bj,false)and Direct(bj,be)
then return{bj,be}end else local bj=Vector3.new(be.X,bd.Y,be.Z)-bg*bi if Direct(
bd,bj)and LegFree(bj,be,false)then return{bj,be}end end end end if be.Y>bd.Y+0.5
then local bg=Vector3.new(bd.X,be.Y,bd.Z)if LegFree(bd,bg,false)and Direct(bg,be
)then return{bg,be}end end local bg=aR(bd.Y,be.Y)for bh,bi in bc do local bj,bk=
Vector3.new(bd.X,bg+bi,bd.Z),Vector3.new(be.X,bg+bi,be.Z)if LegFree(bd,bj,false)
and LegFree(bk,be,false)and Direct(bj,bk)then return{bj,bk,be}end end return nil
end local function Pivot(bd,be)local bf=Vector3.new(be.X-bd.X,0,be.Z-bd.Z)if bf.
Magnitude<12 then return nil end local bg=Vector3.new(-bf.Z,0,bf.X).Unit for bh,
bi in c do for bj,bk in e do for bl,bm in f do if aU()>K then return nil end
local bn=bd:Lerp(be,bk)+bg*(bi*bm)if Direct(bd,bn)and Direct(bn,be)then return
bn end end end end return nil end local function Bent(bd,be)local bf=Pivot(bd,be
)if bf then return{bf,be}end local bg=aR(bd.Y,be.Y)for bh,bi in bc do local bj,
bk=Vector3.new(bd.X,bg+bi,bd.Z),Vector3.new(be.X,bg+bi,be.Z)if LegFree(bd,bj,
false)and LegFree(bk,be,false)then bf=Pivot(bj,bk)if bf then return{bj,bf,bk,be}
end end end return nil end local function Arc(bd,be,bf,bg)local bh=Vector3.new(
be.X-bd.X,0,be.Z-bd.Z)local bi=Vector3.new(-bh.Z,0,bh.X).Unit*bf local bj={}for
bk=1,h-1 do local bl=bk/h bj[#bj+1]=bd:Lerp(be,bl)+bi*math.sin(math.pi*bl)+
Vector3.new(0,bg*4*bl*(1-bl),0)end bj[#bj+1]=be return bj end local function 
ArcTo(bd,be,bf)if Vector3.new(be.X-bd.X,0,be.Z-bd.Z).Magnitude<24 then return
nil end local bg=Vector3.new(0,G,0)for bh,bi in g do if aU()>K then return nil
end local bj=Arc(bd,be,bi[1],bi[2])local bk,bl=0,bd for bm,bn in bj do bk+=(bn-
bl).Magnitude bl=bn end if bk>=bf then continue end local bm=true for bn=2,#bj-1
do if ai.SweepD3(bj[bn-1]+bg,bj[bn]+bg,F,H)~=nil then bm=false break end end if
bm then for bn,bo in{{bd,bj[1]},{bj[#bj-1],bj[#bj]}}do if not(LegFree(bo[1],bo[2
],true,F)or LegFree(bo[1],bo[2],true,D+i))then bm=false break end end end if bm
then return bj,bk end end return nil end local function Explore(bd,be)local bf=
aU()+aV Setup(bd,be)K=bf if(be-bd).Magnitude<0.5 then return Cube(bd,{be}),
"here"end I=not BodyFree(bd,D)J=not BodyFree(be,D)local bg=Straight(bd,be)if bg
then return bg,'straight'end local bh=Bent(bd,be)if bh then return bh,'bent'end
local bi=ArcTo(bd,be,(be-bd).Magnitude*k)if bi then return bi,'over'end local bj
,bk=aR(bd.Y,be.Y),aS(bd.Y,be.Y)local bl={be.Y}if aQ(bd.Y-be.Y)>0.5 then bl[#bl+1
]=bd.Y end if aQ(bd.Y-be.Y)>3 then bl[#bl+1]=(bd.Y+be.Y)*0.5 end for bm,bn in bb
do bl[#bl+1]=bj+bn end local bm,bn=math.huge local bo={}for bp,bq in bl do if
aU()>bf then break end local br,bs=Vector3.new(bd.X,bq,bd.Z),Vector3.new(be.X,bq
,be.Z)if LegFree(bd,br,false)and LegFree(bs,be,false)then bo[#bo+1]={bq,br,bs,bp
>#bl-#bb}end end for bp,bq in a4 do for br,bs in bo do if aU()>bf then break end
if bq and bs[4]then continue end local bt,bu,bv=bs[1],bs[2],bs[3]local L=
NewGrid(FlatCell(a5*2),bt,nil,nil,bq)local M,N,O=StartCell(L,bu)local P,Q=
Search(L,M,0,O,aS(bf,aU()+aW))local R={bu,CellPos(L,M,0,O)}for S,T in Corners(L,
P)do R[#R+1]=T end if Q then R[#R+1]=be return Cube(bd,R),if bq==true then'flat'
elseif bq=='mid'then'flat-mid'else'flat-tight'end local S=P[#P]local T=(CellPos(
L,S[1],S[2],S[3])-bv).Magnitude if T<bm then bn,bm=R,T end end end local bp,bq=
bk-6,40+bj local br=(aQ(B.X-C.X)+a5*2)*(aQ(B.Z-C.Z)+a5*2)local bs=aR(aS(r,2*D),(
br*(bq-bp)/b)^(0.3333333333333333))for bt,bu in a4 do local bv=NewGrid(bs,nil,bp
,bq,bu)local L=aR(bf,aU()+aX)K=L local M,N,O=StartCell(bv,bd)local P,Q=Search(bv
,M,N,O,L)local R={CellPos(bv,M,N,O)}for S,T in Corners(bv,P)do R[#R+1]=T end if
Q then R[#R+1]=be return Cube(bd,R),if bu==true then'cube'elseif bu=='mid'then
'cube-mid'else'cube-tight'end local S=P[#P]local T=(CellPos(bv,S[1],S[2],S[3])-
be).Magnitude if T<bm then bn,bm=R,T end end if bn then if not LegFree(bn[#bn],
be,false)then return Cube(bd,bn),'blocked'end bn[#bn+1]=be return Cube(bd,bn),
'forced'end return Cube(bd,{Vector3.new(bd.X,bj,bd.Z),Vector3.new(be.X,bj,bd.Z),
Vector3.new(be.X,bj,be.Z),be}),'forced'end local function Over(bd,be,bf,bg)K=aU(
)+0.12 local bh=bg*0.9 local bi=ArcTo(bd,be,bh)if bi then return bi end if bg==
math.huge then return nil end local bj,bk={bd},bd for bl,bm in bf do if(bm-bk).
Magnitude>16 then for bn,bo in j do bj[#bj+1]=bk:Lerp(bm,bo)end end bj[#bj+1]=bm
bk=bm end local bl=#bj local bm=table.create(bl,0)for bn=bl-1,1,-1 do bm[bn]=bm[
bn+1]+(bj[1+bn]-bj[bn]).Magnitude end local bn,bo=bh for bp=bl-1,2,-1 do local
bq,br=ArcTo(bd,bj[bp],bn-bm[bp])if bq then for bs=bp+1,bl do bq[#bq+1]=bj[bs]end
bo,bn=bq,br+bm[bp]break end end local bp=0 for bq=2,bl-1 do bp+=(bj[bq]-bj[bq-1]
).Magnitude if bp>=bn then break end local br,bs=ArcTo(bj[bq],be,bn-bp)if br
then local bt={}for bu=2,bq do bt[#bt+1]=bj[bu]end for bu,bv in br do bt[#bt+1]=
bv end bo,bn=bt,bp+bs break end end return bo end local function Plan(bd,be)
local bf,bg=Explore(bd,be)if 'here'==bg or bg=='straight'or bg=='bent'or bg==
'over'then return bf,bg end local bh=math.huge if bg~='forced'and bg~='blocked'
then bh=0 local bi=bd for bj,bk in bf do bh+=(bk-bi).Magnitude bi=bk end end
local bi=Over(bd,be,bf,bh)if bi then return bi,'over'end return bf,bg end local 
function Entry(bd,be,bf)Setup(bd,be)K=aU()+aV I=not BodyFree(bd,D)J=not
BodyFree(be,D)if Straight(bd,be)then return be end local bg=be-bf*1.5 for bh,bi
in if ai.ShortEntry then q else p do local bj=be-bf*(aB*bi)if LegFree(bj,bg,
false)then return bj end end return be end local bd=8 local be=4 local bf=4
local bg=6 local function Across(bh,bi)return bh.Magnitude>0.05 and aQ(bh.Unit:
Dot(bi.Unit))<0.1 end local function Room(bh,bi)local bj={D+bf,E,E+3,E+6}local
bk=#bj for bl,bm in{0.25,0.5,0.75}do local bn,bo=bh+(bi-bh)*bm,0 for bp,bq in bj
do if not BodyFree(bn,bq)then break end bo=bp end bk=aS(bk,bo)end return bk end
local function Collapse(bh)local bi=2 while bi<=#bh-1 do local bj,bk=bh[bi]-bh[
bi-1],bh[1+bi]-bh[bi]if bj.Magnitude<0.05 or(bk.Magnitude>0.05 and bj.Unit:Dot(
bk.Unit)>0.999)then table.remove(bh,bi)else bi+=1 end end end local function 
Unjog(bh,bi)K=aU()+0.05 local bj={bh}for bk,bl in bi do bj[#bj+1]=bl end
Collapse(bj)local bk=false local bl=2 while bl<=#bj-1 do local bm=#bj local bn=
bj[1+bl]-bj[bl]local bo,bp=(-1)local bq=bn.Magnitude<=be local function Fits(br,
bs)return LegFree(br,bs,true)or(bq and LegFree(br,bs,true,D+bf))end if bn.
Magnitude>=0.05 and bn.Magnitude<=bd then if 3<=bl and Across(bj[bl]-bj[bl-1],bn
)then local br=bj[bl-1]+bn if Fits(bj[bl-2],br)and Fits(br,bj[bl+1])then local
bs=Room(br,bj[1+bl])if bl+1==bm or bs>=Room(bj[bl-1],bj[bl])then bp,bo='earlier'
,bs end end end if bl+2<bm and Across(bj[2+bl]-bj[bl+1],bn)then local br=bj[2+bl
]-bn if Fits(bj[bl],br)and Fits(br,bj[bl+3])then local bs=Room(bj[bl],br)if bo<
bs and bs>=Room(bj[bl+1],bj[bl+2])then bp,bo='later',bs end end end end if bp==
"earlier"then bj[bl-1]+=bn table.remove(bj,bl)elseif 'later'==bp then bj[bl+2]-=
bn table.remove(bj,bl+1)else bl+=1 continue end Collapse(bj)bk,bl=true,2 end
table.remove(bj,1)return bj,bk end local bh={0.3333333333333333,
0.6666666666666666}local function Taut(bi,bj)K=aU()+0.06 local bk,bl={},bi for
bm,bn in bj do for bo,bp in bh do bk[#bk+1]=bl:Lerp(bn,bp)end bk[#bk+1]=bn bl=bn
end local bm={}local function SegRoom(bn)local bo=bm[bn]if bo==nil then bo=Room(
if bn==1 then bi else bk[bn-1],bk[bn])bm[bn]=bo end return bo end local function 
Shortcut(bn,bo,bp)if LegFree(bn,bk[bp],true)then return true end if not LegFree(
bn,bk[bp],true,D+bf)then return false end local bq=math.huge for br=bo,bp do bq=
aS(bq,SegRoom(br))end return Room(bn,bk[bp])>=bq end local bn,bo,bp={bi},bi,1
while bp<=#bk do local bq=#bk while bq>bp and not Shortcut(bo,bp,bq)do bq=bq-1
end bn[#bn+1]=bk[bq]bo=bk[bq]bp=1+bq end Collapse(bn)table.remove(bn,1)return bn
end local bi={4,7,10}local bj=4 local bk={}for bl=0,7 do local bm=bl*math.pi/4
bk[#bk+1]=Vector3.new(math.cos(bm),0,math.sin(bm))end local function Vertical(bl
,bm)return aQ(bl.X-bm.X)<0.5 and aQ(bl.Z-bm.Z)<0.5 and aQ(bl.Y-bm.Y)>3 end local 
function RoomyLeg(bl,bm,bn)local bo=bm-bl local bp=aR(1,math.ceil(bo.Magnitude/
1.5))for bq=0,bp do local br=bl+bo*(bq/bp)local bs=(br-bn).Magnitude if bs>1.5
and not BodyFree(br,if bs<=bj then D else E)then return false end end return
true end local function Slant(bl,bm,bn)for bo,bp in bi do for bq,br in bk do
local bs=Vector3.new(bl.X+br.X*bp,bm,bl.Z+br.Z*bp)if RoomyLeg(bs,bl,bl)and bn(bs
)then return bs end end end return nil end local function Ease(bl,bm)K=aU()+0.05
local bn=false local bo=#bm if bo>=2 and Vertical(bm[bo-1],bm[bo])and not
RoomyLeg(bm[bo-1],bm[bo],bm[bo])then local bp=bm[bo-2]or bl local bq=Slant(bm[bo
],bm[bo-1].Y,function(bq)return LegFree(bp,bq,true)end)if bq then bm[bo-1],bn=bq
,true end end if#bm>=2 and Vertical(bl,bm[1])and not RoomyLeg(bm[1],bl,bl)then
local bp=bm[2]local bq=Slant(bl,bm[1].Y,function(bq)return LegFree(bq,bp,true)
end)if bq then bm[1],bn=bq,true end end return bn end local bl=math.cos(math.
rad(30))local bm={{0,14},{0,10},{4,14},{4,10},{8,14},{8,10},{12,14},{12,10},{0,6
},{0,4}}local function Round(bn,bo)K=aU()+0.08 local bp=table.clone(bo)local bq,
br,bs={},bn,false for bt=1,#bp-1 do local bu,bv=bp[bt],bp[bt+1]local L,M=br-bu,
bv-bu local N=false if L.Magnitude>1 and M.Magnitude>1 and(-L.Unit):Dot(M.Unit)<
bl then local O=-L.Unit local P=Room(br,bu)local function Keeps(Q,R,S)return
LegFree(Q,R,true)or(LegFree(Q,R,true,D+bf)and Room(Q,R)>=S)end for Q,R in bm do
local S,T=R[1],R[2]if S>0 and bt+1==#bp then continue end local U,V=bu+O*S,bv+O*
S local W,X=(U-br).Magnitude,V-U if T>W*0.45 or T>X.Magnitude*0.45 then continue
end if S>0 and not(Keeps(bu,U,P)and Keeps(U,V,Room(bu,bv))and Keeps(V,bp[bt+2],
Room(bv,bp[bt+2])))then continue end local Y,Z=U-O*T,U+X.Unit*T if(if S>0 then
Keeps(Y,Z,P)else LegFree(Y,Z,true))or(S==0 and T<=bg and LegFree(Y,Z,true,D+bf))
then bq[#bq+1]=Y bq[#bq+1]=Z bp[1+bt]=V br,N,bs=Z,true,true break end end end if
not N then bq[#bq+1]=bu br=bu end end bq[#bq+1]=bp[#bp]return bq,bs end ai.
GroundY=aK function ai.FloorY()local bn=af.Character and af.Character:
FindFirstChildOfClass'Humanoid'local bo=af.Character and af.Character:
FindFirstChild'HumanoidRootPart'local bp=if bn and bo then bn.HipHeight+bo.Size.
Y*0.5 else aL return aK+bp end function ai.RouteD3(bn,bo,bp)local bq=aU()local
br=ai.FloorY()local bs=bn local bt if bn.Y<br-0.5 then bt=Vector3.new(bn.X,br,bn
.Z)bn=bt end if bo.Y<br then bo=Vector3.new(bo.X,br,bo.Z)end SetLaserQuery(true)
local bu=bo if bp then local bv,L=pcall(Entry,bn,bo,bp)bu=bv and L or bo end
local bv,L,M=pcall(Plan,bn,bu)if bv and(M=='forced'or M=='blocked')and not ai.
Narrow then a5=a7 local N,O,P=pcall(Plan,bn,bu)a5=a6 if N and P~='forced'and P~=
'blocked'then L,M=O,P..'+wide'end end if not bv then ai.LastRouteError=tostring(
L)L,M=Cube(bn,{Vector3.new(bu.X,bn.Y,bn.Z),Vector3.new(bu.X,bn.Y,bu.Z),bu}),
'error'elseif#L>1 then local N,O,P=pcall(Unjog,bn,L)if N and P then L,M=O,M..
'+unjog'end local Q,R=pcall(Taut,bn,L)if Q then L,M=R,M..'+taut'end local S,T=
pcall(Ease,bn,L)if S and T then M=M..'+ease'end local U,V,W=pcall(Round,bn,L)if
U and W then L,M=V,M..'+round'end end if bu~=bo then local N=L[#L-1]or bn if L[#
L]==bu then local O=(N-bu):Dot(bp)local P=((N-bu)-bp*O)*Vector3.new(1,0,1)K=aU()
+0.05 if(O>0 and P.Magnitude<1)or LegFree(N,bo,true,D+a2)then L[#L]=nil end end
L[#L+1]=bo end SetLaserQuery(false)for N,O in L do if O.Y<br then L[N]=Vector3.
new(O.X,br,O.Z)end end if bt then table.insert(L,1,bt)M=M..'+rise'end bn=bs ai.
RouteSrc='cube-'..M ai.LastRoute={Src=M,Ms=(aU()-bq)*1000,Legs=#L,Entry=bu~=bo,
From=bn,To=bo,Goal=bu,Facing=bp,Path=table.clone(L),Error=not bv and ai.
LastRouteError or nil,At=os.clock()}ai.Routes=ai.Routes or{}table.insert(ai.
Routes,1,ai.LastRoute)ai.Routes[7]=nil return L end end)()local aP=15 local aQ=
12 local aR=2 local aS=2 function ai.Fly(aT,aU,aV,aW,aX)local aY=ai.Gen local aZ
=ai.LastRoute~=nil and string.find(ai.LastRoute.Src,'blocked',1,true)~=nil local
a_,a0=ai.Config.RiseSpeed,ai.Config.TurnSpeed ai.Config.RiseSpeed=aX.Rise or a_
ai.Config.TurnSpeed=aX.Turn or a0 ai._lagbacks=0 local a2=false local a4=ad.
Heartbeat:Connect(function()local a4=af.Character and af.Character:
FindFirstChildOfClass'Humanoid'if not a4 or not a4.Parent then return end if a4.
PlatformStand then a4.PlatformStand=false end if ai._lagbacks>=aS and not a2
then a2=true ai.Stop()end end)local a5=false local a6 local function Cleanup()a4
:Disconnect()if a6 then a6()end ai.Config.TurnSpeed=a0 ai.Config.RiseSpeed=a_ if
not a5 then return end local a7=af.Character and af.Character:
FindFirstChildOfClass"Humanoid"if a7 then a7.AutoRotate=true end end local a7=
function()return true end if aX.Launch then a7,a6=aX.Launch()end local a8,a9=aT.
Position,aW or aU[#aU]local function Speed()if aX.FlatSpeed then local _v=aX.FlatSpeed local _g=ai.Gov if _g and _g.Snaps>0 then _v=math.min(_v,_g.Cap)end return _v end local b=if a7()then(aX.Speed or 400)
else(aX.Unboosted or aX.Speed or 400)return ai.TierSpeed(b,a8,a9)end ZeroVel(aT)
local b=aT.Parent and aT.Parent:FindFirstChildOfClass'Humanoid'if b then pcall(
function()b:ChangeState(Enum.HumanoidStateType.Jumping)b.Jump=true end)end local
ba=aV and(aV*Vector3.new(1,0,1))or Vector3.zero if b and ba.Magnitude>1e-4 then
a5=true b.AutoRotate=false aT.CFrame=CFrame.lookAt(aT.Position,aT.Position+ba.
Unit)ZeroVel(aT)end local bb=ai.Resample(aU,aT.Position,aP)ai.MoveThrough(aT,bb,
Speed,true)local bc=aW or aU[#aU]for bd=1,aR do local be=af.Character and af.
Character:FindFirstChild'HumanoidRootPart'if aZ or a2 or ai.Gen~=aY or not be or
not be.Parent or(be.Position-bc).Magnitude<=aQ then break end a8,a9=be.Position,
bc local bf=ai.RouteD3(be.Position,bc,aV)local bg=ai.Resample((bf and#bf>0)and
bf or{bc},be.Position,aP)ai.MoveThrough(be,bg,Speed,true)end Cleanup()local bd=
af.Character and af.Character:FindFirstChild'HumanoidRootPart'if a2 or ai.Gen~=
aY or not bd or not bd.Parent then return false end ZeroVel(bd)return true end
function ai.Stop()ai.Gen+=1 end return ai end function a.z()local aa=a.cache.z
if not aa then aa={c=__modImpl()}a.cache.z=aa end return aa.c end end do local 
function __modImpl()local aa=a.a()local ab=a.n()local ac=a.t()local ad=a.x()
local ae=a.i()local af={}local ag={Busy=false,ShowPath=false}local ah=aa.
Services.Players local ai=aa.Services.RunService local aj=aa.LocalPlayer local
ak,al=false,0 af.__Royal_StripReady=true af.Royal_AntiVoid=true af.
RoyalApproachF2From1=true local am={TpSettings={GrabbleTPSpeed=485,Tool='Waverider',CloneDelayVal=
0.3}}ag.Settings=am.TpSettings do local an=RaycastParams.new(
)an.FilterType=Enum.RaycastFilterType.Exclude af.Royal_InVoid=function()if af.
Royal_AntiVoid==false then return false end local ao=aj.Character local ap=ao
and ao:FindFirstChild'HumanoidRootPart'if not ap or ap.Anchored then return
false end if ap.Position.Y>-20 or ap.AssemblyLinearVelocity.Y>-5 then return
false end local aq={}for ar,as in ipairs(ah:GetPlayers())do if as.Character then
aq[#aq+1]=as.Character end end an.FilterDescendantsInstances=aq return workspace
:Raycast(ap.Position,Vector3.new(0,-250,0),an)==nil end af.Royal_WaitOutVoid=
function()if not af.Royal_InVoid()then return end local ao=os.clock()repeat ai.
Heartbeat:Wait()until not af.Royal_InVoid()or os.clock()-ao>10 end end do local
an=pcall(function()aa.Connect(ai.PreSimulation,function(an)local ao=af.
__Royal_FlyPre if ao then ao(an)end end)end)if not an then aa.Connect(ai.Stepped
,function(ao,ap)local aq=af.__Royal_FlyPre if aq then aq(ap)end end)end aa.
Connect(ai.Heartbeat,function(ao)local ap=af.__Royal_FlyHb if ap then ap(ao)end
end)end do local an,ao=0 af.DrawPath=function(ap)an+=1 if ao then ao:Destroy()ao
=nil end if not(ag.ShowPath and ap and#ap>1)then return end local aq=an local ar
=Instance.new'Folder'ar.Name='TwilightPath'for as=2,#ap do local at,au=ap[as-1],
ap[as]local av=(au-at).Magnitude if av>0.05 then local aw=Instance.new'Part'aw.
Anchored,aw.CanCollide,aw.CanQuery,aw.CanTouch,aw.CastShadow=true,false,false,
false,false aw.Material=Enum.Material.Neon aw.Color=Color3.fromRGB(236,95,166)aw
.Transparency=0.25 aw.Size=Vector3.new(0.35,0.35,av)aw.CFrame=CFrame.lookAt((at+
au)/2,au)aw.Parent=ar end end ar.Parent=workspace ao=ar task.delay(10,function()
if an==aq and ao==ar then ao=nil ar:Destroy()end end)end aa.Clean(function()af.
DrawPath(nil)end)end af.Royal_PingMs=function()local an pcall(function()an=aj:
GetNetworkPing()*1000 end)if not(tonumber(an)and an>0)then pcall(function()an=((
game:GetService'Stats')).Network.ServerStatsItem['Data Ping']:GetValue()end)end
return tonumber(an)or 0 end af.Royal_PickTpSpeed=function(an)local ao=am.
TpSettings if an and 100>=an then return ao.NearSpeed or ao.GrabbleTPSpeed,
'near'end local ap=af.Royal_PingMs()if ap>=150 then return ao.Ping150 or ao.
GrabbleTPSpeed,'ping 150+'end if ap>=120 then return ao.Ping120 or ao.
GrabbleTPSpeed,'ping 120-150'end if ap>=100 then return ao.Ping100 or ao.
GrabbleTPSpeed,'ping 100-120'end return ao.GrabbleTPSpeed,'normal'end local 
function instantClone()local an=aj.Character if not an then return false end
local ao=an:FindFirstChildOfClass'Humanoid'local ap=an:FindFirstChild
'HumanoidRootPart'if not ao or not ap then return false end local aq=aj.Backpack
:FindFirstChild'Quantum Cloner'or an:FindFirstChild'Quantum Cloner'if not aq
then return false end local ar=ap.Position if aq.Parent~=an then pcall(function(
)ao:EquipTool(aq)end)ai.Heartbeat:Wait()end local as=aj:FindFirstChild
'PlayerGui'local at=as and as:FindFirstChild'ToolsFrames'local au=at and at:
FindFirstChild'QuantumCloner'local av=au and au:FindFirstChild'TeleportToClone'
if not av then return false end af.isCloning=true aq:Activate()local aw=0 pcall(
function()aw=aj:GetNetworkPing()end)local ax=math.clamp(aw+0.35,0.35,1)local ay=
false local az=os.clock()repeat ai.Heartbeat:Wait()if ap.Parent and(ap.Position-
ar).Magnitude>1.5 then ay=true break end av.Visible=true pcall(function()
firesignal(av.MouseButton1Click)end)pcall(function()firesignal(av.MouseButton1Up
)end)pcall(function()firesignal(av.Activated)end)until os.clock()-az>ax task.
delay(0.3,function()af.isCloning=false end)if af.RoyalStealDebug then print(
string.format('[royal clone] %s in %.2fs',ay and'swapped'or'no swap seen',os.
clock()-az))end return true end do local an=aj local ao={am.TpSettings.Tool}for
ap,aq in ipairs(ae.Flying)do if aq~=ao[1]then ao[#ao+1]=aq end end local 
function _normName(ap)return(string.lower(tostring(ap)):gsub('[^%w]',''))end
local function findTool(ap)local aq=an.Character local ar=an:FindFirstChild
'Backpack'local as=(aq and aq:FindFirstChild(ap))or(ar and ar:FindFirstChild(ap)
)if as then return as end local at=_normName(ap)if ''==at then return nil end for
au,av in ipairs{aq,ar}do if av then for aw,ax in ipairs(av:GetChildren())do if
ax:IsA'Tool'then local ay=_normName(ax.Name)if ay==at or string.find(ay,at,1,
true)then return ax end end end end end return nil end local ap local function 
_carpetInChar(aq)if not aq then return nil end if ap then local ar=aq:
FindFirstChild(ap)if ar then return ap end ap=nil end for ar,as in ipairs(ao)do
local at=aq:FindFirstChild(as)if at then ap=as return as end end return nil end
local aq=false local function equipCarpet()if af.isCloning then return nil end
local ar=an.Character local as=not findTool'Grapple Hook'if aq and not af.
__Royal_GrappleFired and not as then return _carpetInChar(ar)end if not af.
__Royal_GrappleFired and not as then return _carpetInChar(ar)end local at=ar and
ar:FindFirstChildOfClass'Humanoid'if not at then return nil end local au=
_carpetInChar(ar)if au then return au end local av=am and am.TpSettings and am.
TpSettings.Tool if av then local aw=findTool(av)if aw and aw:IsA'Tool'then if aw
.Parent~=ar then pcall(function()at:EquipTool(aw)end)end if ao[1]~=aw.Name then
ao[1]=aw.Name end ap=aw.Name return aw.Name end end for aw,ax in ipairs(ao)do
local ay=findTool(ax)if ay and ay:IsA'Tool'then if ay.Parent~=ar then pcall(
function()at:EquipTool(ay)end)end ap=ax return ax end end return nil end local
ar local function _grappleRemote()if ar and ar.Parent then return ar end local
as=ab.Event'75c9466d-e4c0-4b02-b26a-c3615fcc1e42'if as then ar=as end return as
end local as=_grappleRemote task.spawn(_grappleRemote)local function 
_shootGrapple(at,au)task.wait(math.clamp(an:GetNetworkPing(),0.03,0.2))for av=1,
2 do for aw=1,3 do pcall(function()at:FireServer(0.33)end)end local aw=os.clock(
)+0.4 repeat ai.Heartbeat:Wait()local ax=au:GetAttribute'CooldownTime'if type(ax
)=='number'and ax>0 then return true end until os.clock()>aw or au.Parent~=an.
Character if au.Parent~=an.Character then return false end end return false end
local function carpetEngage()if af.isCloning then return nil end if aq then
local at=os.clock()repeat ai.Heartbeat:Wait()until(not aq)or os.clock()-at>6
local au=an.Character if au then for av,aw in ipairs(ao)do local ax=au:
FindFirstChild(aw)if ax and ax:IsA'Tool'then return aw end end end return nil
end aq=true local at local au=0 local av=0 local aw=os.clock()while os.clock()-
aw<5 and au==0 do local ax=an.Character local ay=ax and ax:FindFirstChildOfClass
"Humanoid"local az=as()local aA=findTool'Grapple Hook'if aA and ay and ax and aA
.Parent~=ax then pcall(function()ay:EquipTool(aA)end)av=0 elseif ax and ax:
FindFirstChild'Grapple Hook'then av+=1 else av=0 end local aB=ax and ax:
FindFirstChild'Grapple Hook'if ax and aB and az and av>=2 and not(af.
Royal_InVoid and af.Royal_InVoid())then az=_grappleRemote()_shootGrapple(az,aB)
au=1 af.__Royal_GrappleFired=true local aC=os.clock()+0.1 while os.clock()<aC do
ai.Heartbeat:Wait()end at=equipCarpet()break end ai.Heartbeat:Wait()end if au>0
and not(at and an.Character and an.Character:FindFirstChild(at))then local ax=os
.clock()repeat at=equipCarpet()local ay=an.Character if at and ay and ay:
FindFirstChild(at)then break end ai.Heartbeat:Wait()until os.clock()-ax>0.4 end
aq=false return at end af.Royal_PulseGrapple=function()local at=_grappleRemote()
if not at then return false end if af.Royal_WaitOutVoid then af.
Royal_WaitOutVoid()end pcall(function()at:FireServer(0.33)end)pcall(function()at
:FireServer(0.33)end)pcall(function()at:FireServer(0.33)end)af.
__Royal_GrappleFired=true return true end af.Royal_FireGrapple=function()if not
as()then return false end local at=0 local au=os.clock()while os.clock()-au<1.5
and at<2 do local av=an.Character local aw=av and av:FindFirstChildOfClass
'Humanoid'local ax=findTool'Grapple Hook'if ax and aw and av and ax.Parent~=av
then pcall(function()aw:EquipTool(ax)end)at=0 elseif av and av:FindFirstChild
'Grapple Hook'then at+=1 else at=0 end ai.Heartbeat:Wait()end if not(an.
Character and an.Character:FindFirstChild'Grapple Hook')then return false end if
af.Royal_WaitOutVoid then af.Royal_WaitOutVoid()end _shootGrapple(
_grappleRemote(),an.Character:FindFirstChild'Grapple Hook')af.
__Royal_GrappleFired=true return true end af.Royal_CarpetEngage=carpetEngage af.
Royal_FindTool=findTool af.Royal_EquipCarpet=equipCarpet af.Royal_CarpetNames=ao
function ag.SetTool(at)if type(at)~='string'or at==''then return end am.
TpSettings.Tool=at for au=#ao,1,-1 do if ao[au]==at then table.remove(ao,au)end
end table.insert(ao,1,at)ap=nil end function ag.Prime()task.spawn(function()if
af.__Royal_GrappleFired then return end if not an.Character then an.
CharacterAdded:Wait()end pcall(carpetEngage)end)end end do function af.
RoyalSpeedClamp(an)local ao=750 local ap=tonumber(an)or(am and am.TpSettings and
tonumber(am.TpSettings.GrabbleTPSpeed))or ao if ao<ap then ap=ao end return ap
end end af.Royal_ExtraZones=af.Royal_ExtraZones or{}local an={Cash=
true,CashPad=true,Dev=true,FriendPanel=true,InvisibleWalls=true,Multiplier=true,PlotSign=true,Purchases=true,Road=true,RoadPanel=true,RoyalLandPlatform=true,RoyalTempPlatform=true,Slope=true,Sounds=true,SpawnLocation=true,ToolsAdds=true,TwilightPath=true,__PROJECTILES=true,Unlock=true,rods=true}local ao=60
local ap={zone=true,empty=true,low=true,far=true}local aq=false local function 
_zoneBounds(ar)local as={}if ar:IsA'BasePart'then as[1]=ar else for at,au in
ipairs(ar:GetDescendants())do if au:IsA'BasePart'then as[#as+1]=au end end end
local at,au,av,aw,ax,ay for az,aA in ipairs(as)do if aA.CanCollide and aA.
Transparency<0.95 and aA.Size.Magnitude>1 then local aB,aC=aA.CFrame,aA.Size/2
local aD,aE,aF=aB.RightVector,aB.UpVector,aB.LookVector local aG=math.abs(aD.X)*
aC.X+math.abs(aE.X)*aC.Y+math.abs(aF.X)*aC.Z local aH=math.abs(aD.Y)*aC.X+math.
abs(aE.Y)*aC.Y+math.abs(aF.Y)*aC.Z local aI=math.abs(aD.Z)*aC.X+math.abs(aE.Z)*
aC.Y+math.abs(aF.Z)*aC.Z local aJ=aB.Position at=math.min(at or math.huge,aJ.X-
aG)au=math.max(au or-math.huge,aJ.X+aG)av=math.min(av or math.huge,aJ.Y-aH)aw=
math.max(aw or-math.huge,aJ.Y+aH)ax=math.min(ax or math.huge,aJ.Z-aI)ay=math.
max(ay or-math.huge,aJ.Z+aI)end end return at,au,av,aw,ax,ay end function af.
Royal_AddZone(ar,as)as=as or 0 if not ar or an[ar.Name]then return'skip'end if#
af.Royal_ExtraZones>=ao then return'cap'end local at=ar:IsA'BasePart'if not at
and not(ar:IsA'Model'or ar:IsA'Folder')then return'empty'end local au,av,aw,ax,
ay,az=_zoneBounds(ar)if not au then return'empty'end if ax<-5 then return"low"
end if av-au>80 or az-ay>80 then if at or as>=3 then return'big'end local aA=ar:
GetChildren()if#aA==0 or#aA>300 then return'big'end local aB=true for aC,aD in
ipairs(aA)do local aE=af.Royal_AddZone(aD,as+1)if not ap[aE]then aB=false end
end return aB and'zone'or'big'end local aA=(au+av)/2 if aA<-545 or aA>-275 then
return'far'end local aB={minX=au,maxX=av,minZ=ay,maxZ=az,name=ar.Name}local aC=
af.Royal_ExtraZones for aD=#aC,1,-1 do local aE=aC[aD]if aE.minX<=aB.minX+0.5
and aE.maxX>=aB.maxX-0.5 and aE.minZ<=aB.minZ+0.5 and aE.maxZ>=aB.maxZ-0.5 then
return'zone'end if aB.minX<=aE.minX+0.5 and aB.maxX>=aE.maxX-0.5 and aB.minZ<=aE
.minZ+0.5 and aB.maxZ>=aE.maxZ-0.5 then table.remove(aC,aD)end end table.insert(
aC,aB)if af.Royal_RebuildOutlines and not aq then aq=true task.delay(2,function(
)aq=false pcall(af.Royal_RebuildOutlines)end)end return'zone'end do local ar=
game:GetService'Players'local as=game:GetService'RunService'local at=ar.
LocalPlayer local au={CARPET=450}if am and am.TpSettings then if tonumber(am.
TpSettings.GrabbleTPSpeed)then au.CARPET=math.min(750,(tonumber(am.TpSettings.
GrabbleTPSpeed)))end end local function isPlotUnlocked(av)local aw=ac.List[
tostring(av)]if not aw or not ac.Data(aw)then return false end return ac.
BlockSeconds(aw,1)<=0 end local av=setmetatable({},{__mode='k'})local aw={}local 
function _slotKey(ax)local ay=aw[ax]if ay==nil then ay=tostring(ax)aw[ax]=ay end
return ay end local function _cheapPos(ax)if not ax then return nil end if ax:
IsA'BasePart'then return ax.Position end local ay=ax.PrimaryPart if ay then
return ay.Position end local az=ax:FindFirstChildWhichIsA'BasePart'return az and
az.Position or nil end local function _plotWorldPos(ax)local ay=_cheapPos(ax)if
ay then return ay end for az,aA in ipairs{'PlotSign','MainRoot','Base','Floor',
'Spawn'}do ay=_cheapPos(ax:FindFirstChild(aA))if ay then return ay end end
return nil end local function getPetPosition(ax,ay)if not ax then return nil end
ay=_slotKey(ay)local az=av[ax]if az==nil then az={}av[ax]=az end local aA=az[ay]
if aA then return aA end local aB=ax:FindFirstChild'AnimalPodiums'if not aB then
return nil end local aC=aB:FindFirstChild(ay)if not aC then for aD,aE in ipairs(
aB:GetChildren())do if tostring(aE.Name)==ay then aC=aE break end end end if not
aC then return nil end local aD=aC:FindFirstChild'Base'local aE=aD and aD:
FindFirstChild'Spawn'local aF=_cheapPos(aE)or _cheapPos(aD)or _cheapPos(aC)if aF
then az[ay]=aF return aF end return nil end local function _findPlot(ax)local ay
=workspace:FindFirstChild'Plots'if not ay or ax==nil then return nil end local
az=tostring(ax)local aA=ay:FindFirstChild(az)if aA then return aA end for aB,aC
in ipairs(ay:GetChildren())do if aC.Name==az or tostring(aC.Name)==az then
return aC end end return nil end local function _ensurePetPos(ax)if not ax then
return nil end if ax.position then return ax.position end local ay=_findPlot(ax.
plot)if not ay then return nil end local az=getPetPosition(ay,ax.slot)if az then
ax.position=az return az end local aA=_plotWorldPos(ay)if aA then ax.plotHint=aA
end return nil end local ax={B={{coord=Vector3.new(-487.921448,16.850713000384,-
75.768013),facing='NORTH'},{coord=Vector3.new(-332.37973,16.850722,-75.7621),
facing='NORTH'},{coord=Vector3.new(-487.134918,16.850713,-18.094154),facing=
'SOUTH'},{coord=Vector3.new(-316.300171,16.850713,-17.845898),facing='SOUTH'}},C
={{coord=Vector3.new(-330.765381,16.850713,31.424425),facing='NORTH'},{coord=
Vector3.new(-502.989349000334,16.850713,31.17243),facing='NORTH'},{coord=Vector3.new(-
489.077087,16.850713,89.010147),facing='SOUTH'},{coord=Vector3.new(-330.908936,
16.850713,88.930145),facing='SOUTH'}},D={{coord=Vector3.new(-331.264893,
16.850713,138.209167),facing='NORTH'},{coord=Vector3.new(-487.935181,16.850713000738,
138.026321),facing='NORTH'},{coord=Vector3.new(-487.774933,16.850713,195.882538)
,facing='SOUTH'},{coord=Vector3.new(-330.799133,16.850575,196.022354),facing=
"SOUTH"}}}local ay={B={{coord=Vector3.new(-335.725586,-3.048217,-74.984589),
facing='NORTH'},{coord=Vector3.new(-503.214233,-3.048217,-75.043137),facing=
'NORTH'},{coord=Vector3.new(-483.619385,-3.71843,-18.844337),facing='SOUTH'},{
coord=Vector3.new(-316.147095,-3.048218,-18.818844),facing='SOUTH'}},C={{coord=
Vector3.new(-335.985413,-3.048218,32.051426),facing='NORTH'},{coord=Vector3.new(
-503.277008,-3.048217,31.956175),facing='NORTH'},{coord=Vector3.new(-483.74939,-
3.048218,88.147003),facing='SOUTH'},{coord=Vector3.new(-315.793823,-3.048217,
88.163979),facing='SOUTH'}},D={{coord=Vector3.new(-335.476654,-3.048218,
139.001083),facing='NORTH'},{coord=Vector3.new(-503.710083,-3.048218,138.989883)
,facing='NORTH'},{coord=Vector3.new(-315.654938,-3.048218,195.302444),facing=
'SOUTH'},{coord=Vector3.new(-483.859253,-3.048218,195.269043),facing='SOUTH'}}}
local az=7 local aA={['La Secret Combinasion']=true,['La Jolly Grande']=true}
local aB=3 local aC={[1]=Vector3.new(-476.52,-2,220.94),[2]=Vector3.new(-476.52,
-2,113.77),[3]=Vector3.new(-476.52,-2,6.18),[4]=Vector3.new(-476.520000000856,-2,-101.07),
[5]=Vector3.new(-342.66,-2,221.45),[6]=Vector3.new(-342.66,-2,113.41),[7]=
Vector3.new(-342.66,-2,6.25),[8]=Vector3.new(-342.66,-2,-99.73)}local aD={[1]=
Vector3.new(-479.51,18,220.94),[2]=Vector3.new(-479.51,18,113.77),[3]=Vector3.
new(-479.51,18,6.18),[4]=Vector3.new(-479.51,18,-101.07),[5]=Vector3.new(-339.48
,18,221.45),[6]=Vector3.new(-339.48,18,113.41),[7]=Vector3.new(-339.48,18,6.25),
[8]=Vector3.new(-339.48,18,-99.73)}local aE={[1]={minX=-525.25,maxX=-479.75,minY
=-10.1,maxY=43.9,minZ=196.61,maxZ=242.110000000399},[2]={minX=-525.25,maxX=-479.75,minY=-
10.1,maxY=43.9,minZ=89.61,maxZ=135.11},[3]={minX=-525.25,maxX=-479.75,minY=-10.1
,maxY=43.9,minZ=-17.39,maxZ=28.11},[4]={minX=-525.25,maxX=-479.75,minY=-10.1,
maxY=43.9,minZ=-124.39,maxZ=-78.89},[5]={minX=-339.44,maxX=-293.94,minY=-10.1,
maxY=43.9,minZ=199.11,maxZ=244.61},[6]={minX=-339.44,maxX=-293.94,minY=-10.1,
maxY=43.9,minZ=92.11,maxZ=137.61},[7]={minX=-339.44,maxX=-293.94,minY=-10.1,maxY
=43.9,minZ=-14.89,maxZ=30.61},[8]={minX=-339.44,maxX=-293.94,minY=-10.1,maxY=
43.9,minZ=-121.89,maxZ=-76.39}}local aF=8 local aG=6 local function _segClip(aH,
aI,aJ,aK,aL,aM,aN,aO)local aP,aQ=0,1 for aR=1,4 do local aS,aT if aR==1 then aS,
aT=-aJ,aH-aL elseif aR==2 then aS,aT=aJ,aM-aH elseif aR==3 then aS,aT=-aK,aI-aN
else aS,aT=aK,aO-aI end if aS>-1E-12 and aS<1e-12 then if aT<0 then return nil
end else local aU=aT/aS if aS<0 then if aU>aQ then return nil end if aU>aP then
aP=aU end else if aP>aU then return nil end if aU<aQ then aQ=aU end end end end
return aP,aQ end local function _segHitsPlotPad(aH,aI,aJ)local aK=aE[aJ]return
_segClip(aH.X,aH.Z,aI.X-aH.X,aI.Z-aH.Z,aK.minX-aF,aK.maxX+aF,aK.minZ-aF,aK.maxZ+
aF)~=nil end local aH=-3.048217 local aI=16.850713 local aJ=-410 local aK=8
local aL=45 local function getClosestBaseIdx(aM)local aN,aO=1,math.huge for aP=1
,8 do local aQ=aC[aP]local aR=(aM.X-aQ.X)^2+(aM.Z-aQ.Z)^2 if aO>aR then aO=aR aN
=aP end end return aN end local function buildFrontCandidate(aM,aN,aO)local aP=
aN and aD[aM]or aC[aM]local aQ=aN and aI or aH local aR=math.clamp(aO-aP.Z,-aK,
aK)+aP.Z local aS=Vector3.new(aP.X,aQ,aR)local aT=(aM<=4)and Vector3.new(-1,0,0)
or Vector3.new(1,0,0)return aS,aT end local function plotSides(aM,aN)local aO=aC
[aN]local aP=aN<=4 local aQ={}for aR,aS in pairs(aM)do for aT,aU in ipairs(aS)do
if((aU.coord.X<aJ)==aP)and math.abs(aU.coord.Z-aO.Z)<aL then aQ[#aQ+1]=aU end
end end return aQ end local function cloneDestCandidates(aM,aN,aO)local aP=aN.Y
if aA[aO]then aP=aN.Y-aB end if af.RoyalApproachF2From1==nil then af.
RoyalApproachF2From1=true end local aQ if af.RoyalApproachF2From1 then aQ=aP>
23.15 and ax or ay else aQ=az<aP and ax or ay end local aR=(aQ==ax)local aS=
getClosestBaseIdx(aN)local aT,aU=buildFrontCandidate(aS,aR,aM.Z)local aV={{coord
=aT,face=aU}}for aW,aX in ipairs(plotSides(aQ,aS))do local aY=aX.facing=='NORTH'
and Vector3.new(0,0,-1)or Vector3.new(0,0,1)aV[#aV+1]={coord=aX.coord,face=aY}end local _e=af.RoyalEntry if _e=='Front'then return{aV[1]}elseif _e=='Side'and#aV>1 then table.remove(aV,1)end return aV end local function resolveCloneDest(aM,aN,aO)local aP=
cloneDestCandidates(aM,aN,aO)local aQ,aR=aP[1].coord,aP[1].face local aS=(aM-aQ)
.Magnitude for aT=2,#aP do local aU=(aM-aP[aT].coord).Magnitude if aU<aS then aS
=aU aQ=aP[aT].coord aR=aP[aT].face end end return aQ,aR end local aM={AnimalTarget=true,DeliveryHitbox=true,Floor=true,MainRoot=true,Multiplier=true,Roof=true,RoyalLandPlatform=true,SecondFloor=true,Slope=true,Spawn=true,ThirdFloor=true,StealHitbox=true,__HITBOX=true}local aN={0,5,-5,14,-14}local aO=
RaycastParams.new()aO.IgnoreWater=true aO.FilterType=Enum.RaycastFilterType.
Exclude local function wallFrontPos(aP,aQ)if not aP or not aQ or aQ.Magnitude<
0.1 then return aP,'dest'end local aR=aQ.Unit local aS=Vector3.new(-aR.Z,0,aR.X)
aO.FilterDescendantsInstances={at.Character}local aT,aU='dest'local function 
considerAlong(aV,aW,aX,aY)if aW>(aY or 16)or aV<-2 or aV>28 then return end if
aU==nil or aU>aV then aU=aV aT=aX end end local function considerHit(aV)if not
aV then return end local aW=aV.Instance and aV.Instance.Name or''if aM[aW]then
return end if math.abs(aV.Normal.Y)>=0.5 then return end local aX=(aV.Position-
aP):Dot(aR)local aY=(aV.Position-aP-aR*aX).Magnitude considerAlong(aX,aY,aW,14)
end for aV,aW in ipairs(aN)do local aX=aP-aR*12+aS*aW+Vector3.new(0,2,0)
considerHit(workspace:Raycast(aX,40*aR,aO))end if aU==nil then return aP,'dest'
end local aV=aP+aR*aU aV=Vector3.new(aV.X,aP.Y,aV.Z)return aV,aT end local 
function _antiFall(aP,aQ)local aR=aP and aP.Parent local aS=aR and aR:
FindFirstChildOfClass'Humanoid'local aT local aU=false local aV aT=Instance.new
'Part'aT.Name='RoyalLandPlatform'aT.Size=Vector3.new(14,1,14)aT.Position=Vector3
.new(aQ.X,aQ.Y-3.15,aQ.Z)aT.Anchored=true aT.CanCollide=true aT.Transparency=1
aT.Parent=workspace task.delay(af.RoyalPlatLife or 2,function()if aT and aT.
Parent then aT:Destroy()end end)if aS then pcall(function()aS:SetStateEnabled(
Enum.HumanoidStateType.FallingDown,false)aS:SetStateEnabled(Enum.
HumanoidStateType.Ragdoll,false)aS:SetStateEnabled(Enum.HumanoidStateType.
Freefall,false)aS:ChangeState(Enum.HumanoidStateType.Running)end)end local aW=os
.clock()+1.1 local function stop(aX)if aU then return end aU=true if aV then aV:
Disconnect()aV=nil end if aS and aS.Parent then pcall(function()aS:
SetStateEnabled(Enum.HumanoidStateType.Freefall,true)aS:SetStateEnabled(Enum.
HumanoidStateType.FallingDown,true)aS:SetStateEnabled(Enum.HumanoidStateType.
Ragdoll,true)end)end if aX then if aT and aT.Parent then aT:Destroy()end end end
aV=as.Heartbeat:Connect(function()if aU then return end if os.clock()>aW then
stop(false)return end local aX=(aP and aP.Parent)and aP or nil if aX then local
aY=aX.AssemblyLinearVelocity if aY.Y<-2 then aX.AssemblyLinearVelocity=Vector3.
new(aY.X,0,aY.Z)end end end)return stop end local function vZero(aP)if aP then
aP.AssemblyLinearVelocity=Vector3.zero aP.AssemblyAngularVelocity=Vector3.zero
end end local function velMoveThrough(aP,aQ,aR,aS,aT)if not aP or not aP.Parent or#aQ==0 then return end local aU=aQ[#aQ]af.__Royal_VelFlying=true af.
__Royal_FlyHrp=aP local aV=af.RoyalSpeedClamp(aR or au.CARPET)aP.Anchored=false
pcall(function()if af.Royal_EquipCarpet then af.Royal_EquipCarpet()end end)do
local aW=os.clock()local aX=false while os.clock()-aW<1.2 do if af.
__Royal_TPCancel then break end local aY=aP.Parent local aZ=false for a_,a0 in
ipairs(af.Royal_CarpetNames or{"Witch's Broom"})do if aY and aY:FindFirstChild(
a0)then aZ=true break end end if aZ and(af.__Royal_GrappleFired or aX)then break
end if not af.__Royal_GrappleFired and not aX and af.Royal_FireGrapple then
local a_=at:FindFirstChild'Backpack'if(aY and aY:FindFirstChild'Grapple Hook')or
(a_ and a_:FindFirstChild'Grapple Hook')then aX=true pcall(af.Royal_FireGrapple)
end end pcall(function()if af.Royal_EquipCarpet then af.Royal_EquipCarpet()end
end)as.Heartbeat:Wait()end end if af.__Royal_TpT then af.__Royal_TpT.tool=os.
clock()end pcall(function()if af.Royal_PulseGrapple then af.Royal_PulseGrapple()
end end)local aW=aP.Parent local aX=aW and aW:FindFirstChildOfClass'Humanoid'
local function holdFall()if not(aX and aX.Parent)then return end pcall(function(
)aX.PlatformStand=false aX:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
aX:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)aX:SetStateEnabled(Enum.
HumanoidStateType.Landed,false)if aX:GetState()~=Enum.HumanoidStateType.Freefall
then aX:ChangeState(Enum.HumanoidStateType.Freefall)end end)end local function 
releaseFall()if not(aX and aX.Parent)then return end pcall(function()aX:
SetStateEnabled(Enum.HumanoidStateType.Landed,true)aX:SetStateEnabled(Enum.
HumanoidStateType.Running,true)aX:SetStateEnabled(Enum.HumanoidStateType.Jumping
,true)aX:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)end)end if aX then
pcall(function()aX.PlatformStand=false aX:SetStateEnabled(Enum.HumanoidStateType
.Freefall,true)aX:SetStateEnabled(Enum.HumanoidStateType.Landed,false)aX:
ChangeState(Enum.HumanoidStateType.Freefall)end)holdFall()end do local aY=os.
clock()repeat local aZ=tonumber(as.Heartbeat:Wait())or 0 until(aZ>0.001 and aZ<=
0.022)or os.clock()-aY>0.04 end do local aY=af.__Royal_TpT if aY and(af.
RoyalTpDebug or af.RoyalStealDebug)then local aZ=os.clock()local a_=af.
__Royal_SpawnAt print(string.format(
[[[royal tp] take-off %.2fs after spawn | strip wait %.2fs, target %.2fs, route %.2fs, tool %.2fs, start %.2fs]]
,a_ and(aZ-a_)or-1,(aY.strip or aY.start)-aY.start,(aY.pet or aY.strip or aY.
start)-(aY.strip or aY.start),(aY.route or aY.pet or aY.start)-(aY.pet or aY.
start),(aY.tool or aZ)-(aY.route or aY.pet or aY.start),aZ-(aY.tool or aZ)))end
af.__Royal_TpT=nil end af.__Royal_TookOff=os.clock()if aT then local aY,aZ=
pcall(aT,aP.Position,'takeoff')if aY and type(aZ)=='table'and#aZ>0 then aQ=aZ aU
=aQ[#aQ]end end local aY=aS and 1 or 4 local aZ=2 local a_=400 local a0,a2=16,10
local a4,a5,a6,a7 local function layRoute(a8)local a9={aP.Position}for b=1,#a8
do local ba=a8[b]if(ba-a9[#a9]).Magnitude>0.25 then a9[#a9+1]=ba end end local b
={a9[1]}for ba=2,#a9-1 do local bb,bc,bd=b[#b],a9[ba],a9[ba+1]local be,bf=bc-bb,
bd-bc if aS or(be.Magnitude>=4 and not(be.Magnitude>0.1 and bf.Magnitude>0.1 and
be.Unit:Dot(bf.Unit)>0.94))then b[#b+1]=bc end end b[#b+1]=a9[#a9]local ba=#b
local bb={}for bc=2,ba-1 do local bd,be=b[bc]-b[bc-1],b[bc+1]-b[bc]local bf,bg=
Vector3.new(bd.X,0,bd.Z),Vector3.new(be.X,0,be.Z)local bh=aV if a_<aV and bf.
Magnitude>0.1 and bg.Magnitude>0.1 then local bi=math.min(1,1-bf.Unit:Dot(bg.
Unit))bh=aV-(aV-a_)*bi end bb[bc]=bh end a4,a5,a6,a7=b,ba,2,bb end layRoute(aQ)
af.DrawPath(a4)if a5<2 then vZero(aP)releaseFall()af.__Royal_VelFlying=false af.
__Royal_FlyHrp=nil return end local a8=aV local a9=1.6666666666666665E-2 local b
=os.clock()local ba=false local bb=Vector3.zero local bc=af.Royal_CarpetNames or
{"Witch's Broom"}local function finish()if ba then return end ba=true af.
__Royal_FlyPre=nil af.__Royal_FlyHb=nil releaseFall()end local bd local function 
noCollideTool()local be=aP.Parent if not be then return end for bf=1,#bc do
local bg=be:FindFirstChild(bc[bf])if bg and bg~=bd then bd=bg for bh,bi in
ipairs(bg:GetDescendants())do if bi:IsA'BasePart'then pcall(function()bi.
CanCollide=false end)end end end end end local function carpetHeld()local be=aP.
Parent if not be then return false end for bf=1,#bc do if be:FindFirstChild(bc[
bf])then return true end end return false end local function applyVel(be)if be.
Magnitude<0.1 then return end bb=be aP.AssemblyLinearVelocity=Vector3.new(be.X*
a8,be.Y*a8,be.Z*a8)end local function passedWp()local be=a4[a6]if not be then
return true end local bf=aP.Position local bg=(be-bf).Magnitude if a6>=a5 then
return aZ>bg end if bg<aY then return true end if a6>1 then local bh=be-a4[a6-1]
if bh.Magnitude>0.05 then if(bf-a4[a6-1]):Dot(bh.Unit)>=bh.Magnitude-0.25 then
return true end end end return false end af.__Royal_FlyPre=function()if ba or
not aP or not aP.Parent then af.__Royal_FlyPre=nil return end holdFall()if not
carpetHeld()then pcall(function()if af.Royal_EquipCarpet then af.
Royal_EquipCarpet()end end)end noCollideTool()if passedWp()then a6+=1 end if a5<
a6 then finish()return end local be=os.clock()a9=math.clamp(be-b,
4.166666666666667E-3,3.333333333333333E-2)b=be local bf=a4[a6]-aP.Position local
bg=aV if a5>a6 and a7[a6]and bf.Magnitude<a0 then bg=math.min(bg,a7[a6])end if
a6-1>=2 and a7[a6-1]and(aP.Position-a4[a6-1]).Magnitude<a2 then bg=math.min(bg,
a7[a6-1])end if bf.Magnitude<bg*a9 then bg=math.max(bf.Magnitude/a9,20)end a8=bg
if bf.Magnitude>=0.1 then applyVel(bf.Unit)elseif bb.Magnitude>0.1 then
applyVel(bb)end end af.__Royal_FlyHb=function()if ba or not aP or not aP.Parent
then af.__Royal_FlyHb=nil return end if bb.Magnitude>0.1 then applyVel(bb)end
end local function routeTime()local be=0 for bf=2,a5 do be=be+(a4[bf]-a4[bf-1]).
Magnitude end return be/math.max(aV,1)+2 end local be=routeTime()local bf=os.
clock()local bg=0 local bh=aP.Position while not ba and(os.clock()-bf)<be and
not af.__Royal_TPCancel do as.Heartbeat:Wait()if aT and not ba and bg<3 and aP.
Parent and a6<=a5 then local bi,bj,bk=aP.Position,a4[a6-1],a4[a6]local bl=0 if
bj and bk then local bm=Vector3.new(bk.X-bj.X,0,bk.Z-bj.Z)local bn=Vector3.new(
bi.X-bj.X,0,bi.Z-bj.Z)local bo=bm.Magnitude if bo>0.050000000635 then local bp=math.clamp(
bn:Dot(bm)/(bo*bo),0,1)bl=(bn-bm*bp).Magnitude else bl=bn.Magnitude end end
local bm=(bi-bh).Magnitude>a8*a9*1.8+25 bh=bi local bn=a5<=a6 and bk~=nil and(bk
-bi).Magnitude<20 if bm and bl>25 and not bn then bg+=1 local bo,bp=pcall(aT,bi,
"moved")if bo and type(bp)=='table'and#bp>0 then layRoute(bp)af.DrawPath(a4)aU=
bp[#bp]be=routeTime()bf=os.clock()if af.RoyalStealDebug or af.Royal_RouteDebug
then print(string.format(
[[[royal tp] knocked %.0f studs off the path, new path from here]],bl))end end
end end end finish()if aP and aP.Parent and not af.__Royal_TPCancel then local
bi=aU or a4[a5]if bi and(aP.Position-bi).Magnitude<=12 then aP.CFrame=CFrame.
new(bi)end vZero(aP)end af.__Royal_VelFlying=false af.__Royal_FlyHrp=nil af.
__Royal_FlyPre=nil af.__Royal_FlyHb=nil af.DrawPath(nil)end local aP={{minX=-
450.3,maxX=-435.2,minY=-11.4,maxY=2.7,minZ=29.05,maxZ=51.300000000409},{minX=-445.66,maxX=-
434.56,minY=-10.12,maxY=3.8,minZ=54.67,maxZ=67.69},{minX=-385.76,maxX=-367.76,
minY=-10,maxY=5.84,minZ=56.26,maxZ=81.26},{minX=-443.550000000356,maxX=-434.52,minY=-11.4,
maxY=6.42,minZ=70.83,maxZ=87.11},{minX=-440.83,maxX=-438.98,minY=-9.5,maxY=-1.98
,minZ=36.37,maxZ=43.65},{minX=-386.35,maxX=-371.25,minY=-11.4,maxY=2.7,minZ=29.1
,maxZ=51.35}}local function _segmentHitsShop(aQ,aR)local function inside(aS)for
aT=1,#aP do local aU=aP[aT]if aS.X>=aU.minX-aG and aS.X<=aU.maxX+aG and aS.Y>=aU
.minY and aS.Y<=aU.maxY and aS.Z>=aU.minZ-aG and aS.Z<=aU.maxZ+aG then return
true end end return false end local aS=(aR-aQ).Magnitude if aS<0.05 then return
inside(aQ)end local aT=math.max(6,math.floor(aS/3))for aU=0,aT do if inside(aQ+(
aR-aQ)*(aU/aT))then return true end end return false end local function 
computeRoute(aQ,aR,aS)return{aR}end local function doClone()local aQ=at.
Character local aR=aQ and aQ:FindFirstChildOfClass'Humanoid'if not aQ or not aR
then return false end local aS,aT=pcall(instantClone)return aS and aT==true end
local function _makeOneWay(aQ)if not aQ then return end local aR local aS aR=as.
Stepped:Connect(function()if not aQ or not aQ.Parent then if aR then aR:
Disconnect()end return end local aT=at.Character local aU=aT and aT:
FindFirstChild'HumanoidRootPart'if aU then local aV=aU.Position.Y if not aS then
aS=aV end local aW=aV-aS local aX=(aU.AssemblyLinearVelocity.Y>1)or(aW>0.01 and
5>aW)if aX then aQ.CanCollide=false else aQ.CanCollide=(aV>aQ.Position.Y+0.100000000678)end
aS=aV end end)end local function goToBrainrot(aQ)if not aQ or af.
__Royal_TPCancel then return end af.__Royal_TookOff=af.__Royal_TookOff or os.
clock()local aR,aS,aT local aU=os.clock()repeat aR=at.Character aS=aR and aR:
FindFirstChild'HumanoidRootPart'aT=aR and aR:FindFirstChildOfClass'Humanoid'if
aS and aT then break end as.Heartbeat:Wait()until os.clock()-aU>3 if not aS or
not aT then return end if af.Royal_Stage then pcall(af.Royal_Stage,
'going to the brainrot')end aS.Anchored=false task.spawn(function()local aV=os.
clock()repeat local aW=at.Character local aX=false for aY,aZ in ipairs(af.
Royal_CarpetNames or{})do if aW and aW:FindFirstChild(aZ)then aX=true break end
end if aX then break end pcall(af.Royal_EquipCarpet)as.Heartbeat:Wait()until os.
clock()-aV>1.5 end)local aV=aQ.Y local aW=aS.Position.Y local aX=(aV>=11 and aV
<=23.15)if aV>23.15 then aW=21 elseif aX then aW=14.5 elseif aV>=-6.9 and aV<=
8.900000000656 then aW=-4 end local aY=aX and af.RoyalApproachF2From1 if aY then aW=aV-8
end local aZ=Vector3.new(aQ.X,aW,aQ.Z)if aY then local a_=Instance.new'Part'a_.
Name='RoyalTempPlatform'a_.Size=Vector3.new(6,1.5,6)a_.Position=aZ-Vector3.new(0
,3,0)a_.Anchored=true a_.CanCollide=false pcall(_makeOneWay,a_)a_.Transparency=1
a_.Parent=workspace task.spawn(function()local a0=tick()while tick()-a0<(af.
RoyalPlatLife or 2)do if at:GetAttribute'Stealing'then break end task.wait(0.05)
end if a_ and a_.Parent then a_:Destroy()end end)end if aV>23.150000000813 then local a_=
Instance.new'Part'a_.Name='RoyalLandPlatform'a_.Size=Vector3.new(14,1,14)a_.
Position=Vector3.new(aZ.X,aZ.Y-3.15,aZ.Z)a_.Anchored=true a_.CanCollide=true a_.
Transparency=1 a_.Parent=workspace local a0=os.clock()+(af.RoyalPlatLife or 2)
local a2 a2=as.Heartbeat:Connect(function()if os.clock()>a0 then if a2 then a2:
Disconnect()a2=nil end if a_ and a_.Parent then a_:Destroy()end return end local
a4=(aS and aS.Parent)and aS or nil if not a4 then return end local a5=a4.
AssemblyLinearVelocity if a5.Y<-2 then a4.AssemblyLinearVelocity=Vector3.new(a5.
X,0,a5.Z)end if a4.Position.Y<18 then a4.CFrame=CFrame.new(a4.Position.X,21,a4.
Position.Z)a4.AssemblyLinearVelocity=Vector3.zero a4.AssemblyAngularVelocity=
Vector3.zero end end)end if aS and aS.Parent then aS.CFrame=CFrame.new(aZ)aS.
AssemblyLinearVelocity=Vector3.zero aS.AssemblyAngularVelocity=Vector3.zero end
do local a_=0 pcall(function()a_=at:GetNetworkPing()end)local a0=os.clock()+0.5+
math.min(a_,0.5)local a2=0 while os.clock()<a0 and 3>a2 do as.Heartbeat:Wait()if
at:GetAttribute'Stealing'or af.__Royal_TPCancel then break end if not(aS and aS.
Parent)then break end local a4=aS.Position if Vector3.new(a4.X-aZ.X,0,a4.Z-aZ.Z)
.Magnitude>5 then a2+=1 aS.CFrame=CFrame.new(aZ)aS.AssemblyLinearVelocity=
Vector3.zero aS.AssemblyAngularVelocity=Vector3.zero end end end end local aQ=
function(aQ)if not aQ then return nil end return tostring(aQ.plot)..'|'..
tostring(aQ.slot)end local function _pickByMode(aR)if type(aR)~='table'or#aR==0
then return nil end return aR[1]end local function armSteal(...)end local 
function preFlyStrip(...)end local function scanAllPets()return{}end local 
function _padRoute(aR,aS,aT)if not(aT and aT.Magnitude>0.1)then return nil end
local aU=Vector3.new(aT.X,0,aT.Z).Unit local aV=getClosestBaseIdx(aS)local aW={}
local aX=aR local aY for aZ=1,8 do local a_=aE[aZ]if aX.X>=a_.minX and aX.X<=a_.
maxX and aX.Z>=a_.minZ and aX.Z<=a_.maxZ then aY=aZ break end end if aY==aV then
return nil end if aY then local aZ=aC[aY]local a_=(aY<=4)and 1 or-1 local a0=
math.clamp(aX.Z,aZ.Z-8,aZ.Z+8)aW[#aW+1]=Vector3.new(aZ.X-a_*2,aX.Y,a0)aX=Vector3
.new(aZ.X+a_*12,aX.Y,a0)aW[#aW+1]=aX end local aZ=aY or getClosestBaseIdx(aX)
local a_=aX.X<aJ local a0=aV<=4 if a_==a0 then local a2=aC[aV]local a4=a0 and 1
or-1 local a5=math.max(12,(aX.X-a2.X)*a4)local a6=a2.X+a4*a5 if math.abs(aX.X-a6
)>0.5 then aX=Vector3.new(a6,aX.Y,aX.Z)aW[#aW+1]=aX end aW[#aW+1]=Vector3.new(a6
,aX.Y,aS.Z)aW[#aW+1]=aS af.__Royal_PadWhy=
'same side: sideways, then straight in'return aW end local a2=false pcall(
function()local a4=OverlapParams.new()a4.FilterType=Enum.RaycastFilterType.
Exclude local a5={at.Character}local a6=workspace:FindFirstChild'Plots'if a6
then a5[#a5+1]=a6 end a4.FilterDescendantsInstances=a5 for a7,a8 in ipairs(
workspace:GetPartBoundsInBox(CFrame.new(-408.5,1.25,58),Vector3.new(96,11.5,72),
a4))do if a8.CanCollide and not a8:IsA'Terrain'and a8.Size.Magnitude>2 and a8.
Size.Y<40 and a8.Size.X<200 and a8.Size.Z<200 then a2=true break end end end)
local function clear(a4,a5)local a6=aF aF=6 local a7=true for a8=1,8 do if a8~=
aV and a8~=aZ and _segHitsPlotPad(a4,a5,a8)then a7=false break end end aF=a6 if
a7 and a2 and _segmentHitsShop(Vector3.new(a4.X,aH,a4.Z),Vector3.new(a5.X,aH,a5.
Z))then a7=false end return a7 end if clear(aX,aS)then aW[#aW+1]=aS af.
__Royal_PadWhy='other side: one straight line'return aW end for a4,a5 in ipairs{
30,45,60}do local a6=Vector3.new(aS.X-aU.X*a5,aX.Y,aS.Z-aU.Z*a5)if clear(aX,a6)
then aW[#aW+1]=a6 aW[#aW+1]=aS af.__Royal_PadWhy=
'other side: one bend in front of the door ('..a5..')'return aW end end local a4
=Vector3.new(aS.X-aU.X*30,aX.Y,aS.Z-aU.Z*30)aW[#aW+1]=a4 aW[#aW+1]=aS af.
__Royal_PadWhy='other side: forced bend'return aW end local function _routeLen(
aR,aS)local aT,aU=0,aR for aV=1,#aS do aT=aT+Vector3.new(aS[aV].X-aU.X,0,aS[aV].
Z-aU.Z).Magnitude aU=aS[aV]end return aT end local function _activeMid()local aR
={}local aS=af.Royal_ExtraZones or{}for aT=1,#aP do local aU=aP[aT]local aV=
false for aW,aX in ipairs(aS)do if aX.minX<aU.maxX and aX.maxX>aU.minX and aX.
minZ<aU.maxZ and aX.maxZ>aU.minZ then aV=true break end end if not aV then aR[#
aR+1]=aU end end return aR end af.Royal_ActiveMid=_activeMid local aR=0 local 
function _bestLanding(aS,aT,aU,aV,aW,aX,aY,aZ)local a_=cloneDestCandidates(aS,aT
,aU)if not a_ or#a_==0 then return nil end local a0=getClosestBaseIdx(aT)local
a2=aE[a0]local a4,a5,a6,a7=8,aG,1.5,1.5 local a8=aX and 0 or math.clamp(((
tonumber(aR)or 0)-400)/40,0,8)local a9={}local b=aS local ba for bb=1,8 do local
bc=aE[bb]if b.X>=bc.minX and b.X<=bc.maxX and b.Z>=bc.minZ and b.Z<=bc.maxZ then
ba=bb break end end if ba==a0 then return nil end if ba then local bb=aC[ba]
local bc=(ba<=4)and 1 or-1 local bd=math.clamp(b.Z,bb.Z-8,bb.Z+8)if math.abs(b.Z
-bd)>0.5 then a9[#a9+1]=Vector3.new(bb.X-bc*2,b.Y,bd)end b=Vector3.new(bb.X+bc*
math.max(tonumber(af.RoyalLaneOut)or 12.5,a8+2),b.Y,bd)a9[#a9+1]=b else for bb=1
,8 do if bb~=a0 then local bc=aE[bb]local bd=math.max(bc.minX-b.X,0,b.X-bc.maxX)
local be=math.max(bc.minZ-b.Z,0,b.Z-bc.maxZ)if math.max(bd,be)<a4+a6 then local
bf=a4+a6+a7+1 local bg,bh=b.X,b.Z if bd>=be then bg=(b.X>bc.maxX)and(bc.maxX+bf)
or(bc.minX-bf)else bh=(b.Z>bc.maxZ)and(bc.maxZ+bf)or(bc.minZ-bf)end b=Vector3.
new(bg,b.Y,bh)a9[#a9+1]=b break end end end end do local function inShop(bb,bc)
for bd=1,#aP do local be=aP[bd]local bf=a5+a6+a7 if bb>be.minX-bf and bb<be.maxX
+bf and bc>be.minZ-bf and bc<be.maxZ+bf then return true end end return false
end if inShop(b.X,b.Z)then local bb,bc for bd,be in ipairs{{1,0},{-1,0},{0,1},{0
,-1}}do for bf=1,120 do local bg,bh=b.X+be[1]*bf,b.Z+be[2]*bf if not inShop(bg,
bh)then if not bc or bf<bc then bc,bb=bf,Vector3.new(bg,b.Y,bh)end break end end
end if bb then b=bb a9[#a9+1]=b end end end local bb={}local bc=tonumber(af.
RoyalTargetPad)or 2.5 for bd=1,8 do local be=aE[bd]local bf=a4+a6 if bd==a0 then
bf=bc end local bg=math.max(be.minX-b.X,0,b.X-be.maxX)local bh=math.max(be.minZ-
b.Z,0,b.Z-be.maxZ)local bi=math.max(bg,bh)if bi<=bf then bf=math.max(0,bi-0.75)
end bb[#bb+1]={be.minX-bf,be.maxX+bf,be.minZ-bf,be.maxZ+bf}end local bd=
_activeMid()for be=1,#bd do local bf=bd[be]local bg=a5+a6 bb[#bb+1]={bf.minX-bg,
bf.maxX+bg,bf.minZ-bg,bf.maxZ+bg}end for be,bf in ipairs(af.Royal_ExtraZones or{
})do local bg=3 local bh=bg+a6 local bi=bf.maxX>a2.minX-1 and bf.minX<a2.maxX+1
and bf.maxZ>a2.minZ-1 and bf.minZ<a2.maxZ+1 if not bi then local bj,bk=(bf.minX+
bf.maxX)/2,(bf.minZ+bf.maxZ)/2 for bl=1,8 do local bm=aE[bl]if bj>bm.minX and bj
<bm.maxX and bk>bm.minZ and bk<bm.maxZ then bi=true break end end end if not bi
and not(b.X>bf.minX-bh-a7 and b.X<bf.maxX+bh+a7 and b.Z>bf.minZ-bh-a7 and b.Z<bf
.maxZ+bh+a7)then bb[#bb+1]={bf.minX-bh,bf.maxX+bh,bf.minZ-bh,bf.maxZ+bh}end end
local be=#bb local bf,bg,bh,bi=table.create(be),table.create(be),table.create(be
),table.create(be)for bj=1,be do local bk=bb[bj]bf[bj],bg[bj],bh[bj],bi[bj]=bk[1
]+0.01,bk[2]-0.01,bk[3]+0.01,bk[4]-0.01 end local bj,bk,bl,bm=a2.minX+0.01,a2.
maxX-0.01,a2.minZ+0.01,a2.maxZ-0.01 local function clear(bn,bo,bp)local bq,br,bs
,bt=bn.X,bn.Z,bo.X,bo.Z local bu,bv=bs-bq,bt-br local c,e=bq,bs if e<c then c,e=
e,c end local f,g=br,bt if f>g then f,g=g,f end for h=1,be do local i,j,k,l=bf[h
],bg[h],bh[h],bi[h]if bp and h==a0 then i,j,k,l=bj,bk,bl,bm end if e>=i and j>=c
and g>=k and f<=l then local m,n=_segClip(bq,br,bu,bv,i,j,k,l)if m and n-m>1e-9
then return false end end end return true end local function inside(bn,bo)for bp
=1,#bb do local bq=bb[bp]if bn>bq[1]and bn<bq[2]and bo>bq[3]and bo<bq[4]then
return true end end return false end local bn={b}for bo=1,#bb do local bp=bb[bo]
for bq,br in ipairs{{1,3,-1,-1},{2,3,1,-1},{2,4,1,1},{1,4,-1,1}}do local bs=
false if a8>0 then local bt=a7+a8 local bu,bv=bp[br[1] ]+br[3]*bt,bp[br[2] ]+br[
4]*bt if not inside(bu,bv)then bn[#bn+1]=Vector3.new(bu,b.Y,bv)bs=true end end
if not bs then local bt,bu=bp[br[1] ]+br[3]*a7,bp[br[2] ]+br[4]*a7 if not
inside(bt,bu)then bn[#bn+1]=Vector3.new(bt,b.Y,bu)end end end end local bo=#bn
local bp,bq,br={[1]=0},{},{}for bs=1,bo do local bt,bu=math.huge for bv=1,bo do
if not br[bv]and bp[bv]and bp[bv]<bt then bu,bt=bv,bp[bv]end end if not bu then
break end br[bu]=true local bv=bn[bu]for c=1,bo do if not br[c]then local e=bn[c
]local f=Vector3.new(e.X-bv.X,0,e.Z-bv.Z).Magnitude if bt+f<(bp[c]or math.huge)
and clear(bv,e)then bp[c]=bt+f bq[c]=bu end end end end local bs=_routeLen(aS,a9
)local bt local bu=((aS.X<aJ)==(a0<=4))local bv=bu and not aV and not aY and not
aW local c=(aZ and 10 or 6)+a8 if aW then a_={aW.cand}end for e,f in ipairs(a_)
do local g=f.coord local h=math.abs(f.face.X)>math.abs(f.face.Z)if aV and not h
then continue end if bv and h then continue end local i,j if h then local k=
tonumber(af.RoyalFrontSpan)or 8 i=math.max(a2.minZ+5,aC[a0].Z-k)j=math.min(a2.
maxZ-5,aC[a0].Z+k)else local k=tonumber(af.RoyalSideSpan)or 6 i=math.max(a2.minX
+5,g.X-k)j=math.min(a2.maxX-5,g.X+k)end if i>j then i,j=j,i end local k=math.
max(1,math.floor((j-i)/2.5))if aW then k=0 end for l=0,k do local m=i+(j-i)*l/k
local n=h and Vector3.new(g.X,g.Y,m)or Vector3.new(m,g.Y,g.Z)if aW then n=aW.s
end local o=Vector3.new(f.face.X,0,f.face.Z)local p=o.Magnitude>0.1 and(n-o.Unit
*c)or nil local q=0 if aZ and p then local r=Vector3.new(aZ.X-n.X,0,aZ.Z-n.Z)if
r.Magnitude>1 and r.Unit:Dot(o.Unit)>=0.6 then p=n-r.Unit*c q=r.Magnitude else
continue end end if p and(inside(p.X,p.Z)or not clear(p,n,true))then if aZ then
continue end p=nil end local r,s,t for u=1,bo do if bp[u]then local v=bn[u]if p
then local w=bp[u]+Vector3.new(p.X-v.X,0,p.Z-v.Z).Magnitude+c if(not t or w<s)
and clear(v,p)then r,s,t=u,w,true end end if not t then local w=bp[u]+Vector3.
new(n.X-v.X,0,n.Z-v.Z).Magnitude if(not s or s>w)and clear(v,n,true)then r,s=u,w
end end end end if r then local u=bs+s+(aZ and q or 0.1*Vector3.new(n.X-aT.X,0,n
.Z-aT.Z).Magnitude)if not bt or u<bt.cost then bt={cost=u,len=bs+s,node=r,s=n,
cand=f,front=h,stg=t and p or nil}end end end end if not bt then if bv then
return _bestLanding(aS,aT,aU,aV,aW,aX,true,aZ)end if a8>0 then return
_bestLanding(aS,aT,aU,aV,aW,true,aY,aZ)end return nil end local e={}local f=bt.
node while f and f~=1 do table.insert(e,1,bn[f])f=bq[f]end if af.
Royal_SimplePaths~=false then local g=bt.stg or bt.s local h=bt.stg==nil local i
=b.Y local j,k=tonumber(af.RoyalLaneW)or-464,tonumber(af.RoyalLaneE)or-354.6
local function laneFor(l)return(aJ>l)and j or k end local l,m=laneFor(b.X),
laneFor(g.X)local n=Vector3.new local o={{},{n(g.X,i,b.Z)},{n(b.X,i,g.Z)}}for p,
q in ipairs{l,m}do o[#o+1]={n(q,i,b.Z),n(q,i,g.Z)}o[#o+1]={n(q,i,g.Z)}o[#o+1]={
n(q,i,b.Z)}end if l~=m then for p,q in ipairs{b.Z,g.Z,8,108,-55,165}do o[#o+1]={
n(l,i,b.Z),n(l,i,q),n(m,i,q),n(m,i,g.Z)}end end local p=tonumber(af.
RoyalTurnCost)or 30 local function flatLen(q,r)return n(r.X-q.X,0,r.Z-q.Z).
Magnitude end local q,r,s for t,u in ipairs(o)do local v,w={},b for x=1,#u do if
flatLen(w,u[x])>0.5 then v[#v+1]=u[x]w=u[x]end end local x,y=true,0 w=b for z=1,
#v do if inside(v[z].X,v[z].Z)or not clear(w,v[z])then x=false break end y=y+
flatLen(w,v[z])w=v[z]end if x and clear(w,g,h)then y=y+flatLen(w,g)local z=y+p*#
v if not q or z<q then q,r,s=z,v,y end end end local t=bt.stg and c or 0 local u
=bt.len-bs-t if q and q<=u+(p+10)*#e then e=r bt.len=bs+s+t end end local g={}
for h=1,#a9 do g[#g+1]=a9[h]end for h=1,#e do g[#g+1]=e[h]end local h=(
wallFrontPos(bt.s,bt.cand.face))or bt.s if bt.stg then g[#g+1]=bt.stg end g[#g+1
]=bt.s if aZ then h=bt.s end if(h-bt.s).Magnitude>0.25 then g[#g+1]=h end local
i=string.format('%s, %d turn%s, %.0f studs',bt.front and"front"or'side',#e,#e==1
and''or's',bt.len)return h,bt.cand.face,g,i,{cand=bt.cand,s=bt.s}end do local aS
={Camera=true,Map=true,Plots=true,RenderedMovingAnimals=true,RoyalLandPlatform=true,TwilightPath=true,Terrain=true,RoyalTempPlatform=true}task.defer(
function()for aT,aU in ipairs(workspace:GetChildren())do if not(aS[aU.Name]or aU
:IsA'Terrain'or aU:IsA'Camera'or ar:GetPlayerFromCharacter(aU))then pcall(af.
Royal_AddZone,aU)end end end)end local function _routeBlocked(aS,aT,aU)local aV=
RaycastParams.new()aV.FilterType=Enum.RaycastFilterType.Exclude local aW={at.
Character}if aU then aW[#aW+1]=aU end local aX=workspace:FindFirstChild'Plots'
local aY=aX and af.__Royal_MyPlot and aX:FindFirstChild(af.__Royal_MyPlot)if aY
then aW[#aW+1]=aY end for aZ,a_ in ipairs(ar:GetPlayers())do if a_.Character
then aW[#aW+1]=a_.Character end end for aZ,a_ in ipairs(workspace:GetChildren())
do local a0=a_.Name if a0=="RoyalRouteOutlines"or a0=='RoyalLandPlatform'or a0==
'RoyalTempPlatform'then aW[#aW+1]=a_ end end aV.FilterDescendantsInstances=aW
pcall(function()aV.RespectCanCollide=true end)local aZ=Vector3.new(3.5,4,3.5)
local a_=aS local a0=#aT for a2=1,a0 do local a4=aT[a2]local a5=a4-a_ local a6=
a5.Magnitude if a6>0.5 then local a7 local a8=pcall(function()a7=workspace:
Blockcast(CFrame.new(a_),aZ,a5,aV)end)if not a8 then a7=workspace:Raycast(a_,a5,
aV)end if a7 and a7.Instance and math.abs(a7.Normal.Y)<0.5 then local a9=(a7.
Position-a_).Magnitude if not(a2==a0 and a9>a6-4)then return a7.Instance,a7.
Position end end end a_=a4 end return nil end local function _addHitZone(aS)if
not(aS and aS:IsA'BasePart')then return false end local aT=af.Royal_ExtraZones
if type(aT)~='table'or#aT>=60 then return false end local aU,aV=aS.CFrame,aS.
Size/2 local aW,aX,aY=aU.RightVector,aU.UpVector,aU.LookVector local aZ=math.
abs(aW.X)*aV.X+math.abs(aX.X)*aV.Y+math.abs(aY.X)*aV.Z local a_=math.abs(aW.Z)*
aV.X+math.abs(aX.Z)*aV.Y+math.abs(aY.Z)*aV.Z if aZ>60 or a_>60 then return false
end local a0=aU.Position local a2={minX=a0.X-aZ,maxX=a0.X+aZ,minZ=a0.Z-a_,maxZ=
a0.Z+a_,name='hit:'..aS.Name}for a4,a5 in ipairs(aT)do if a5.minX<=a2.minX+0.5
and a5.maxX>=a2.maxX-0.5 and a5.minZ<=a2.minZ+0.5 and a5.maxZ>=a2.maxZ-0.500000000209 then
return false end end aT[#aT+1]=a2 if af.Royal_RebuildOutlines then pcall(af.
Royal_RebuildOutlines)end return true end local aS={plan=nil}function aS.speed(
aT,aU)local aV pcall(function()local aW=aE[getClosestBaseIdx(aU)]local aX=math.
max(aW.minX-aT.X,0,aT.X-aW.maxX)local aY=math.max(aW.minZ-aT.Z,0,aT.Z-aW.maxZ)aV
=math.sqrt(aX*aX+aY*aY)end)local aW=am.TpSettings.GrabbleTPSpeed if af.
Royal_PickTpSpeed then aW=af.Royal_PickTpSpeed(aV)end return af.RoyalSpeedClamp(
aW)end function aS.boost(aT)return math.clamp(((tonumber(aT)or 0)-400)/40,0,8)
end function aS.near(aT,aU)return Vector3.new(aT.X-aU.X,0,aT.Z-aU.Z).Magnitude<=
2 and math.abs(aT.Y-aU.Y)<=8 end function aS.isOpen(aT,aU)local aV=aU.Y>=11 and
aU.Y<=23.15 return((aU.Y<=8.9 or aV)and isPlotUnlocked(aT.plot))and true or
false end function aS.solve(aT,aU,aV,aW)if aW then local aX=Vector3.new(aV.X,aH,
aV.Z)local aY,aZ,a_,a0,a2,a4=pcall(_bestLanding,aT,aV,aU.name,true,nil,nil,nil,
aX)if not(aY and aZ and a0)then aY,aZ,a_,a0,a2,a4=pcall(_bestLanding,aT,aV,aU.
name,true)end if aY and aZ and a0 then return aZ,a_,a0,a2,a4 end return nil end
local aX,aY,aZ,a_,a0,a2=pcall(_bestLanding,aT,aV,aU.name)if aX and aY then
return aY,aZ,a_,a0,a2 end return nil end function aS.take(aT,aU,aV,aW,aX)local
aY=aS.plan if not aY then return nil end if aY.uid~=aQ(aT)or aY.open~=aW then
return nil end if math.abs(aS.boost(aY.spd)-aS.boost(aX))>0.01 then return nil
end if(aY.petPos-aU).Magnitude>0.500000000301 or not aS.near(aY.from,aV)then return nil end
if aY.zc~=#(af.Royal_ExtraZones or{})then return nil end return aY end local 
function _doVelocityTPImpl(aT)if ak and(os.clock()-al)<30 then return end ak=
true af.__Royal_TPStarted=true af.__Royal_TPCancel=false al=os.clock()af.
__Royal_TpT={start=os.clock()}do local aU=os.clock()while not af.
__Royal_StripReady and os.clock()-aU<3 do as.Heartbeat:Wait()end end af.
__Royal_TpT.strip=os.clock()local aU=at.Character local aV=aU and aU:
FindFirstChild'HumanoidRootPart'local aW=aU and aU:FindFirstChildOfClass
'Humanoid'if not aV or not aW then ak=false af.__Royal_TPStarted=nil return end
local aX if type(aT)=='table'and(aT.plot or aT.name or aT.index)then aX={aT}
elseif type(aT)=='table'and#aT>0 then aX=aT else aX=scanAllPets()if#aX==0 then
local aY=os.clock()while#aX==0 and(os.clock()-aY)<2 do task.wait(0.1)aX=
scanAllPets()end end end if#aX==0 then ak=false return end local aY=_pickByMode(
aX)or aX[1]armSteal(aY)pcall(_ensurePetPos,aY)local aZ=aY.position or aY.
plotHint if not aZ then local a_=os.clock()repeat as.Heartbeat:Wait()pcall(
_ensurePetPos,aY)aZ=aY.position or aY.plotHint if not aZ then for a0=1,#aX do
local a2=aX[a0]pcall(_ensurePetPos,a2)local a4=a2.position or a2.plotHint if a4
then aY=a2 aZ=a4 armSteal(aY)break end end end until aZ or(os.clock()-a_)>2 end
local a_ do local a0 pcall(function()local a2=aE[getClosestBaseIdx(aZ)]local a4=
aV.Position local a5=math.max(a2.minX-a4.X,0,a4.X-a2.maxX)local a6=math.max(a2.
minZ-a4.Z,0,a4.Z-a2.maxZ)a0=math.sqrt(a5*a5+a6*a6)end)local a2,a4=am.TpSettings.
GrabbleTPSpeed,'normal'if af.Royal_PickTpSpeed then a2,a4=af.Royal_PickTpSpeed(
a0)end a_=af.RoyalSpeedClamp(a2)aR=a_ if af.RoyalStealDebug then print(string.
format("[royal tp] speed %d (%s, %.0f studs from base, ping %d)",a_,a4,a0 or-1,
af.Royal_PingMs and af.Royal_PingMs()or-1))end end local a0=aY.name if af.
__Royal_TpT then af.__Royal_TpT.pet=os.clock()end if not aZ then ak=false af.
__Royal_TPStarted=nil return end do local a2=_findPlot(aY.plot)local a4,a5,a6=
false if a2 then a4,a5,a6=pcall(function()return a2:GetBoundingBox()end)end if
a4 and a5 and a6 then local a7=a5:PointToObjectSpace(aV.Position)local a8=math.
abs(a7.X)<=a6.X/2+2 and math.abs(a7.Z)<=a6.Z/2+2 if a8 then preFlyStrip(aY.plot)
goToBrainrot(aZ)ak=false return end end end local a2=aZ.Y>=11 and aZ.Y<=23.15 if
(aZ.Y<=8.9 or a2)and isPlotUnlocked(aY.plot)then pcall(af.Royal_EquipCarpet)
local a4=Vector3.new(aZ.X,aH,aZ.Z)local a5 do local a6=getClosestBaseIdx(aZ)
local a7,a8=buildFrontCandidate(a6,false,aV.Position.Z)a5=a8 end preFlyStrip(aY.
plot)af.__Royal_VelFlying=true local a6,a7 local a8=(af.Royal_BestLanding~=false
)and aS.take(aY,aZ,aV.Position,true,a_)or nil local a9=a8 and a8.from or aV.
Position if af.Royal_BestLanding~=false then for b=1,3 do a6,a7=nil,nil local ba
,bb,bc,bd,be if b==1 and a8 then ba,bb,bd,be=true,a8.d,a8.r,
'planned while loading: '..tostring(a8.why)else ba,bb,bc,bd,be=pcall(
_bestLanding,aV.Position,aZ,a0,true,nil,nil,nil,a4)if not(ba and bb and bd)then
ba,bb,bc,bd,be=pcall(_bestLanding,aV.Position,aZ,a0,true)end if b>1 then a9=aV.
Position end end if ba and bb and bd then a6={}for bf=1,#bd do a6[bf]=Vector3.
new(bd[bf].X,aH,bd[bf].Z)end a6[#a6+1]=a4 a7=true if af.RoyalStealDebug or af.
Royal_RouteDebug then print('[royal route] unlocked: '..tostring(be)..
' + straight to pet')end end if not a6 or af.Royal_RouteCheck==false then break
end local bf=_routeBlocked(aV.Position,a6,_findPlot(aY.plot))if not bf or not
_addHitZone(bf)then break end if af.RoyalStealDebug or af.Royal_RouteDebug then
print('[royal route] path hits '..bf:GetFullName()..', re-routing')end end end
if not a6 then a6=computeRoute(aV.Position,a4,a5)if not a6 or#a6==0 then a6={a4}
end end if af.__Royal_TpT then af.__Royal_TpT.route=os.clock()end local function 
_replanOpen(b,ba)if af.Royal_BestLanding==false then return nil end if ba~=
'moved'and Vector3.new(b.X-a9.X,0,b.Z-a9.Z).Magnitude<6 then return nil end
local bb for bc=1,3 do local bd,be,bf=aS.solve(b,aY,aZ,true)if not(bd and bf)
then return bb end bb={}for bg=1,#bf do bb[bg]=Vector3.new(bf[bg].X,aH,bf[bg].Z)
end bb[#bb+1]=a4 if af.Royal_RouteCheck==false then break end local bg=
_routeBlocked(b,bb,_findPlot(aY.plot))if not bg or not _addHitZone(bg)then break
end end if af.RoyalStealDebug or af.Royal_RouteDebug then print(
'[royal route] path laid again from where you are ('..tostring(ba)..')')end
return bb end velMoveThrough(aV,a6,a_,a7,_replanOpen)if aV and aV.Parent then aV
.AssemblyLinearVelocity=Vector3.zero aV.AssemblyAngularVelocity=Vector3.zero end
if a2 and not af.__Royal_TPCancel then af.__Royal_VelFlying=false goToBrainrot(
aZ)end ak=false return end pcall(af.Royal_EquipCarpet)local a4,a5 local a6 local
a7=false local a8,a9 if af.Royal_BestLanding~=false then local b=aS.take(aY,aZ,
aV.Position,false,a_)local ba,bb,bc,bd,be,bf if b then ba,bb,bc,bd,be,bf=true,b.
d,b.f,b.r,'planned while loading: '..tostring(b.why),b.fx else ba,bb,bc,bd,be,bf
=pcall(_bestLanding,aV.Position,aZ,a0)end if ba and bb then a4,a5,a6=bb,bc,bd a8
,a9=bf,(b and b.from)or aV.Position a7=true if af.RoyalStealDebug or af.
Royal_RouteDebug then print('[royal route] '..tostring(be))end elseif not ba and
(af.RoyalStealDebug or af.Royal_RouteDebug)then print(
'[royal route] planner error: '..tostring(bb))end end local b=false do local ba=
aE[getClosestBaseIdx(aZ)]local bb=aV.Position local bc=math.max(ba.minX-bb.X,0,
bb.X-ba.maxX)local bd=math.max(ba.minZ-bb.Z,0,bb.Z-ba.maxZ)b=math.sqrt(bc*bc+bd*
bd)<=(tonumber(af.Royal_SideTPRange)or 100)end if not a4 then if af.
Royal_PadPaths~=false and not b then local ba=cloneDestCandidates(aV.Position,aZ
,a0)a4,a5=ba[1].coord,ba[1].face else a4,a5=resolveCloneDest(aV.Position,aZ,a0)
end if a5 and a5.Magnitude>0.1 then a4=wallFrontPos(a4,a5)end end preFlyStrip(aY
.plot)af.__Royal_VelFlying=true local ba=a5 and math.abs(a5.X)>math.abs(a5.Z)if
not a6 and af.Royal_PadPaths~=false and ba then local bb,bc=pcall(_padRoute,aV.
Position,a4,a5)if bb and bc then a6=bc if af.Royal_RouteDebug then print(
'[Route] '..tostring(af.__Royal_PadWhy))end end end if not a6 then a6=
computeRoute(aV.Position,a4,a5)end if not a6 or#a6==0 then a6={a4}end local 
function buildStepped(bb,bc)local bd={}local be=bc.Y local bf=a4.Y local bg=bc
local bh=0 for bi,bj in ipairs(bb)do bh=bh+Vector3.new(bj.X-bg.X,0,bj.Z-bg.Z).
Magnitude bg=bj end if bh<0.01 then bh=0.01 end bg=bc local bi=0 for bj,bk in
ipairs(bb)do bi=bi+Vector3.new(bk.X-bg.X,0,bk.Z-bg.Z).Magnitude local bl=be+(bf-
be)*(bi/bh)bd[#bd+1]=Vector3.new(bk.X,bl,bk.Z)bg=bk end if#bd>0 then bd[#bd]=a4
end return bd end local bb=buildStepped(a6,aV.Position)if a7 and af.
Royal_RouteCheck~=false then for bc=1,3 do local bd=_routeBlocked(aV.Position,bb
,_findPlot(aY.plot))if not bd or not _addHitZone(bd)then break end local be,bf,
bg,bh,bi,bj=pcall(_bestLanding,aV.Position,aZ,a0)if not(be and bf and bh)then
break end a4,a5,a6=bf,bg,bh a8,a9=bj,aV.Position bb=buildStepped(a6,aV.Position)
if af.RoyalStealDebug or af.Royal_RouteDebug then print(
'[royal route] path hit '..bd:GetFullName()..', re-routed: '..tostring(bi))end
end end local bc if a8 then bc=function(bd,be)if 'moved'~=be and(bd-a9).Magnitude
<3 then return nil end local bf,bg,bh,bi=pcall(_bestLanding,bd,aZ,a0,false,a8)if
bf and bg and bi then if af.RoyalStealDebug or af.Royal_RouteDebug then print(
'[royal route] path laid again from where you are ('..tostring(be)..')')end
return buildStepped(bi,bd)end return nil end end if af.__Royal_TpT then af.
__Royal_TpT.route=os.clock()end velMoveThrough(aV,bb,a_,a7,bc)if af.
__Royal_TPCancel then if aV and aV.Parent then vZero(aV)end return end local bd=
Vector3.new(0,0,-1)if a5 and a5.Magnitude>0.100000000305 then bd=Vector3.new(a5.X,0,a5.Z)if
bd.Magnitude<0.1 then bd=Vector3.new(0,0,-1)else bd=bd.Unit end end local be a4,
be=wallFrontPos(a4,a5)do local bf=0.45 local bg=string.lower(be or'')if string.
find(bg,'laser',1,true)then bf=0 end a4=a4+bd*bf end aV.Anchored=false local 
function _faceLook()if bd.Magnitude>0.1 and aV and aV.Parent then aV.CFrame=
CFrame.new(aV.Position,aV.Position+bd)end end _faceLook()vZero(aV)local bf=
_antiFall(aV,a4)armSteal(aY)local bg=tonumber(am and am.TpSettings and am.
TpSettings.CloneDelayVal)or 0.27 if bg>0 then task.wait(bg)end if af.
__Royal_TPCancel then if bf then pcall(bf,true)end return end if af.Royal_Stage
then pcall(af.Royal_Stage,'cloning in')end doClone()if bf then pcall(bf,false)
end af.isCloning=false if af.__Royal_TPCancel then return end goToBrainrot(aZ)
end local function doVelocityTP(aT)local aU,aV=pcall(_doVelocityTPImpl,aT)if not
aU then warn('[twilight tp] '..tostring(aV))end ak=false af.__Royal_TPStarted=
nil af.__Royal_VelFlying=false end function ag.IsOpen(aT)local aU=_ensurePetPos(
aT)or aT.position if not aU then return isPlotUnlocked(aT.plot)end return aS.
isOpen(aT,aU)end function ag.Bases()local aT={}for aU=1,8 do aT[aU]=aC[aU]end
return aT end function ag.Go(aT,aU)if ag.Busy then return false end ag.Busy=true
local aV=ac.Mine()af.__Royal_MyPlot=aV and aV.Id or nil af.Royal_Stage=aU local
aW=af.Royal_FindTool and af.Royal_FindTool'Grapple Hook'local aX=aW and aW:
GetAttribute'CooldownTime'if not(type(aX)=='number'and aX>0)then af.
__Royal_GrappleFired=false end local _ok,_op=pcall(ag.IsOpen,aT)af.__Royal_OpenBase=_ok and _op==true doVelocityTP(aT)af.__Royal_OpenBase=false af.Royal_Stage=nil ag.Busy=false return not af.__Royal_TPCancel end end function ag.Cancel()af.__Royal_TPCancel=
true end ag.Abort=ag.Cancel function ag.ReachFromBelow(ar)af.
RoyalApproachF2From1=ar~=false end function ag.SetEntry(_m)af.RoyalEntry=_m end function ag.Clone()return instantClone()end
function ag.CloneTool()local ar=aj.Character local as=aj:FindFirstChildOfClass
'Backpack'local at=(ar and ar:FindFirstChild'Quantum Cloner')or(as and as:
FindFirstChild'Quantum Cloner')return if at and at:IsA'Tool'then at else nil end
function ag.CloneLeft()local ar=ag.CloneTool()if not ar then return math.huge
end local as=ar:GetAttribute'CooldownTime'local at=ar:GetAttribute
'CooldownUntil'local au=math.max(if type(as)=='number'then as else 0,ad.Left(ar.
Name))if type(at)=='number'then au=math.max(au,at-workspace:GetServerTimeNow())
end return math.max(0,au)end aa.Clean(function()af.__Royal_TPCancel=true af.
__Royal_FlyPre,af.__Royal_FlyHb=nil,nil end)return ag end function a.A()local aa
=a.cache.A if not aa then aa={c=__modImpl()}a.cache.A=aa end return aa.c end end
do local function __modImpl()local aa=a.a()local ab=a.v()local ac=a.u()local ad=
a.h()local ae=a.o()local af=a.n()local ag=a.t()local ah=a.w()local ai=a.y()local
aj=a.z()local ak=a.g()local al=a.x()local am=a.i()local an=a.A()local ao=math.
abs local ap=math.ceil local aq=math.max local ar=string.format local as=string.
find local at=math.min local au=math.clamp local av=math.huge local aw=table.
concat local ax=table.unpack local ay=task.spawn local az=task.wait local aA=
Vector3.new local aB=CFrame.new local aC=CFrame.lookAlong local aD=aa.Services.
RunService local aE=aa.Services.Workspace local aF=aa.Services.ReplicatedStorage
local aG=aa.Services.Players local aH=aa.LocalPlayer local aI,aJ=0.55,3 local aK
,aL=1.6,2.1 local aM,aN=10,0.3 local aO=2.21 local aP=aA(2.4,4.6,2.4)local aQ=
aA(1,0,1)local aR=55 local aS,aT=0.75,3 local aU=0.500000000182 local aV,aW=1.6,40 local aX
={['Honey Bee']=true,Crystal=true,['John Pork']=true}local aY=aA(0,0.4,0)local
aZ={1.66,19.66,19.66}local a_={[2]={-1.15,-52.82,0.0402,0.3427,0.9386}}a_[3]=a_[
2]local a0={[2]={{-52.6,-24.88,0.925,0.2057,0.3194},{50.95,-28.8,-0.8799,0.1998,
0.4311}}}a0[3]=a0[2]local a2=table.freeze{Activate='Tools/Flash/Activate',
Effects='Tools/Flash/Effects'}local a4={{Begin=
'b77dde61-dd74-4f18-b329-2ac7f7e48f0b',Grab=
'0c1792e6-3df9-46fd-8b46-be6e4e6df08f',BeginArgs={{79,
'94fa9dee-cfa2-4cc2-ac2a-0659e5169fac'},{79,
'173cd914-bfdd-4c77-80bc-86864bd1ecb4'}},GrabArgs={{141,
'859270da-f6e7-4110-af2e-4c58fa259c75'},{141,
'b231811b-fa22-4265-81fe-424ea71ddb92'}}},{Begin=
'f1a4d3a5-b97a-4622-8fd6-232663ff697e',Grab=
'f5f26af9-cb1b-4588-bcc9-12fd78f64599',BeginArgs={{50,
'ba10cc43-8b93-4b7d-93b8-e1935730ebe3'},{50,
'ed327974-0c39-423a-b9c7-467b8fdac46d'}},GrabArgs={{16,
'7aae3e74-d52e-433a-83b1-9d5a507d2e80'},{16,
'c3eb316e-a4cc-4dc9-8b0e-1a770a7d99fd'}}}}local a5 local function StealRemotes()
if a5 and a5.Begin.Parent and a5.Grab.Parent then return a5.Build,a5.Begin,a5.
Grab end a5=nil for a6,a7 in a4 do local a8,a9=af.Event(a7.Begin),af.Event(a7.
Grab)if a8 and a9 then a5={Build=a7,Begin=a8,Grab=a9}return a7,a8,a9 end end
return nil,nil,nil end local a6={Route=aj,Clone=ai,Enabled=false,MinBase=20,
Picked=nil,Auto=nil,Paused=false,Mode='Priority',Travel=nil,FillTravel=nil,
IsCamping=nil,LoadLog={},Road=nil,Active=false,Name='',Start=0,Attempt=nil,
Camped=false,Busy=false,Target=nil,Status='idle',Abort=false,GummyUntil=0,
FlashRefused=nil,RagdollUntil=0,Shield=false}a6.Changed=ak.new()local a7={Picked
=true,Auto=true,Paused=true,Road=true}local a8={}for a9 in a7 do a8[a9]=rawget(
a6,a9)rawset(a6,a9,nil)end setmetatable(a6,{__index=a8,__newindex=function(a9,b,
ba)if not a7[b]then rawset(a9,b,ba)elseif a8[b]~=ba then a8[b]=ba a6.Changed:
Fire()end end})local function Character()return ad.Character()end local function 
Lift()local a9,b,ba=Character()return if b and ba then ba.HipHeight+b.Size.Y*0.5
else 2.7 end local function RagdollLeft()local a9=aH:GetAttribute
'RagdollEndTime'return aq(0,aq(a6.RagdollUntil,if type(a9)=='number'then a9 else
0)-aE:GetServerTimeNow())end local function Ragdolled(a9)if RagdollLeft()>0 or
aH:GetAttribute'Ragdoll'==true then return true end local b=a9:GetState()return
b==Enum.HumanoidStateType.Physics or b==Enum.HumanoidStateType.Ragdoll or b==
Enum.HumanoidStateType.FallingDown end local function GummyLeft()return aq(0,a6.
GummyUntil-os.clock())end aa.Connect(aH:GetAttributeChangedSignal
'RagdollEndTime',function()local a9=aH:GetAttribute'RagdollEndTime'if type(a9)==
'number'and a9>a6.RagdollUntil then a6.RagdollUntil=a9 end end)aa.Connect(aH:
GetAttributeChangedSignal"BlockTools",function()if aH:GetAttribute'BlockTools'
then a6.GummyUntil=os.clock()+3.05 end end)aa.Connect(aH.CharacterAdded,function
()a6.GummyUntil,a6.RagdollUntil=0,0 end)local function Carrying()local a9=aH:
GetAttribute'Stealing'return nil~=a9 and a9~=false end local a9=RaycastParams.
new()a9.FilterType=Enum.RaycastFilterType.Exclude a9.RespectCanCollide=true a9.
IgnoreWater=true local b=OverlapParams.new()b.FilterType=Enum.RaycastFilterType.
Exclude b.RespectCanCollide=true b.MaxParts=1 local ba local bb local bc local 
function StopFlashWatch()if bb then bb:Disconnect()bb=nil end end local function 
RefreshFilter()local bd={}for be,bf in aG:GetPlayers()do if bf.Character then bd
[#bd+1]=bf.Character end end if ba then bd[#bd+1]=ba end a9.
FilterDescendantsInstances=bd b.FilterDescendantsInstances=bd local be,bf=
Character()if bf then a9.CollisionGroup=bf.CollisionGroup b.CollisionGroup=bf.
CollisionGroup end end local function BodyClear(bd)return#aE:GetPartBoundsInBox(
aB(bd+aY),aP,b)==0 end local function Inside(bd,be,bf)local bg=bd.CFrame:
PointToObjectSpace(be)local bh=bd.Size*0.5+(bf or Vector3.zero)return ao(bg.X)<=
bh.X and ao(bg.Y)<=bh.Y and ao(bg.Z)<=bh.Z end local function FloorOf(bd)return
if bd<=10 then 1 elseif bd<=18 then 2 else 3 end local function SlotOf(bd)return
tonumber(bd.Slot)or 0 end local function PromptPosition(bd)local be=bd and bd.
Parent if be and be:IsA'Attachment'then return be.WorldPosition end if be and be
:IsA'BasePart'then return be.Position end return nil end local function 
IsStealPrompt(bd)return bd.ActionText=='Steal'or bd.Name=="Steal"or bd:
GetAttribute'State'=='Steal'end local function Available(bd)local be=bd.Prompt
if not(be and be.Parent)and bd.Part then local bf=bd.Part:FindFirstChild
'PromptAttachment'local bg=bf and bf:FindFirstChildWhichIsA'ProximityPrompt'if
bg then bd.Prompt,be=bg,bg end end if not be or not be.Parent or be.ActionText~=
'Steal'then return false,nil end return be.Enabled,be end local function Stolen(
bd)return type(bd.Steal)=='number'end local function Targetable(bd,be)local bf=
bd.Plot return bd.Source=='Plot'and bf~=nil and not bf.Mine and not bd.Fusing
and(be or not Stolen(bd))and bd.Base>=aq(a6.MinBase*
1e6,1)and bd.Slot~=nil and bf.Model:FindFirstChild'MainRoot'~=nil and(
PromptPosition(bd.Prompt)~=nil or(bd.Part~=nil and bd.Part.Parent~=nil))end
local function Same(bd,be)return bd.Index==be.Index and bd.Mutation==be.Mutation
and aw(bd.Traits or{},',')==aw(be.Traits or{},',')end local function Owned(bd)
local be=0 for bf,bg in ab.List do if bg.Plot and bg.Plot.Mine and Same(bg,bd)
then be+=1 end end return be end function a6.Ranked(bd)local be=ab.All(function(
be)return Targetable(be,bd)end)table.sort(be,ac.Before)return be end local bd={
Plot=nil,Slot=0,Until=0,Seen=0}local be=2 local bf={Due=false,Plot=nil,Token=0,Player=nil}local bg,bh,bi,bj=1.5,0.8,180,3 local bk,bl=0.1,150 local bm=6
function a6.Pick(bn)if bn.Source=='Road'then a6.Road=if a6.Road==bn.Key then nil
else bn.Key return end if bd.Plot and not(bn.Plot==bd.Plot and SlotOf(bn)==bd.
Slot)then bd.Plot=nil end if a6.Selected(bn)then a6.Picked,a6.Auto,a6.Paused=nil
,nil,true else a6.Picked,a6.Paused=bn.Key,false end end function a6.Selected(bn)
if bn.Source=="Road"then return a6.Road==bn.Key end return a6.Picked==bn.Key or(
a6.Picked==nil and a6.Auto==bn.Key)end function a6.PickedEntity()local bn=a6.
Picked if bn==nil then return nil end local bo=ab.Get(bn)if not bo then a6.
Picked=nil end return bo end a6.Available=Available a6.Stolen=Stolen a6.FloorOf=
FloorOf a6.SlotOf=SlotOf local bn=(setmetatable({},{__mode='k'}))local bo={At=0,Prompt=nil,Plain=false,Entity=nil}local bp={}local function Note(bq)bp[#bp+1]=
ar('%.2f %s',os.clock(),bq)if#bp>60 then table.remove(bp,1)end writefile(
'depresivo_hub_steal_log.txt',table.concat(bp,'\n'))end local function CampAnchor()local
bq=bd.Plot and bd.Plot.Model:FindFirstChild'AnimalPodiums'local br=bq and bq:
FindFirstChild(tostring(bd.Slot))local bs=br and br:FindFirstChild('Spawn',true)
local bt=bs and bs:FindFirstChild'PromptAttachment'return if bt and bt:IsA
'Attachment'then bt else nil end local function CampPrompt()local bq=CampAnchor(
)if not bq then return nil end local br for bs,bt in bq:GetChildren()do if bt:
IsA'ProximityPrompt'then if IsStealPrompt(bt)then return bt end br=br or bt end
end return br end local function Camping()if not bd.Plot then return false end
local bq,br=Character()local bs=CampAnchor()local bt=bs and bs.WorldPosition if
bt then bd.Seen=os.clock()end if os.clock()>bd.Until or Carrying()or not br then
Note(ar('camp ended: %s',if os.clock()>bd.Until then'time ran out'elseif
Carrying()then'carrying'else'no character'))bd.Plot=nil return false end if not
bt then if os.clock()-bd.Seen<be then return true end Note
'camp ended: podium missing'bd.Plot=nil return false end if((br.Position-bt)*aQ)
.Magnitude>25 or ao(br.Position.Y-bt.Y)>8 then Note(ar(
'camp ended: %.0f studs from the podium, %.0f up',((br.Position-bt)*aQ).
Magnitude,ao(br.Position.Y-bt.Y)))bd.Plot=nil return false end return true end
local function OnPodium()local bq,br=Character()if not br then return false end
local bs=ag.Mine()for bt,bu in ag.List do if bu==bs or not ai.InWalls(bu.Model,
br.Position)then continue end local bv=bu.Model:FindFirstChild'AnimalPodiums'
local c=ag.Animals(bu)local e=if bv then bv:GetChildren()else{}for f,g in e do
if c[g.Name]or c[tonumber(g.Name)]then continue end local h=g:FindFirstChild(
'Spawn',true)local i=h and h:FindFirstChild'PromptAttachment'if i and i:IsA
'Attachment'then local j=i.WorldPosition if((br.Position-j)*aQ).Magnitude<=bm
and ao(br.Position.Y-j.Y)<=8 then return true end end end return false end
return false end a6.IsCamping=function()return Camping()or OnPodium()end local 
function CampTarget()local bq=CampPrompt()if not bq then return nil,nil end for
br,bs in ab.List do if bs.Plot==bd.Plot and SlotOf(bs)==bd.Slot then a6.Auto=bs.
Key return bs,bq end end a6.Auto=nil return{Key='camp',Index='camp slot '..bd.
Slot,Source='Plot',Plot=bd.Plot,Slot=tostring(bd.Slot)},bq end local function 
Nearest()local bq,br=Character()if not br then return nil,nil end local function 
Usable(bs)return Targetable(bs)end local bs if a6.Mode=='Nearest'then bs=ab.
Closest(br.Position,Usable)elseif a6.Mode=='Highest'then bs=ab.Best(Usable)else
local bt=ab.All(Usable)table.sort(bt,ac.Before)bs=bt[1]end return bs,bs and bs.
Prompt end local function Decoy()local bq,br=Character()if not br then return
nil,nil end local bs,bt,bu=av for bv,c in ab.List do if c.Source=='Plot'and c.
Plot and not c.Plot.Mine and(Available(c)or(Stolen(c)and c.Prompt~=nil and c.
Prompt.Parent~=nil))then local e=PromptPosition(c.Prompt)local f=if e then(br.
Position-e).Magnitude else av if f<bs then bt,bu,bs=c,c.Prompt,f end end end if
not bt then return nil,nil end return{Key='decoy',Index='charging on '..
tostring(bt.Index),Source='Plot',Plot=bt.Plot,Slot=bt.Slot,Prompt=bu,Decoy=true}
,bu end local function PickSteal()if a6.Attempt then local bq=a6.Attempt.Entity
return bq,bq.Prompt end if Camping()then if bf.Player and bf.Plot==bd.Plot and
not bf.Due then return nil,nil end return CampTarget()end if Carrying()then
return Decoy()end if os.clock()-bo.At<0.1 and bo.Prompt and bo.Prompt.Parent
then return bo.Entity,bo.Prompt,bo.Plain end local bq,br local bs=false local bt
local bu=if a6.Busy then a6.Target else nil local bv=a6.PickedEntity()if bu and(
Available(bu))then bq,br=bu,bu.Prompt a6.Auto=bu.Key elseif bu and not bv and Stolen(bu)and Targetable(bu,true)then a6.Auto=bu.Key bs,bt=true,bu elseif bv then a6.Auto=nil
if Available(bv)then bq,br=bv,bv.Prompt else bs,bt=true,bv end elseif a6.Paused
then a6.Auto=nil else local c=if a6.Auto then ab.Get(a6.Auto)else nil if not(c
and Stolen(c)and Targetable(c,true))then bq,br=Nearest()a6.Auto=bq and bq.Key if
bq and not(Available(bq))then bq,br,bs,bt=nil,nil,true,bq end else bs,bt=true,c
end end local c=false if not bq and bs then if bt then
bq,br,c=bt,bt.Prompt,true else bq,br=Decoy()end end bo.At,bo.Entity,bo.Prompt,bo.Plain=os.clock(),
bq,br,c return bq,br,c end local function Fire(bq,br,bs,...)for bt,bu in br do
bq:FireServer(bs+bu[1],bu[2],...)end end local bq=(setmetatable({},{__mode='k'})
)local function Callbacks(br)local bs={}local bt,bu=pcall(getconnections,br)for
bv,c in if bt and type(bu)=='table'then bu else{}do local e=c.Function if type(e
)=='function'and not isexecutorclosure(e)then bs[#bs+1]=e end end return bs end
local function PromptCalls(br)local bs=bq[br]if not bs then bs={Callbacks(br.
PromptButtonHoldBegan),Callbacks(br.Triggered)}bq[br]=bs end local bt=bs return
bt[1],bt[2]end local function Run(br)if#br==0 then return false end for bs,bt in
br do ay(bt)end return true end local function Protect()local br,bs,bt=
Character()local bu=ad.FindTool"Grief Shield"if not br or not bt or not bu then
return end local bv,c=bu:GetAttribute'CooldownTime',bu:GetAttribute
"CooldownUntil"if(type(bv)=='number'and bv>0)or(type(c)=='number'and c>aE:
GetServerTimeNow())or al.Left(bu.Name)>0 then return end if not ad.Equip(bu,0.5)
then return end az()bu:Activate()az(0.03)end local function FireSteal(br,bs,bt)
if not bs.Parent or bn[bs]then return false,br end local bu,bv,c=StealRemotes()
local e=0 local f=aH.Character local g,h=aI,aJ local i=os.clock()local j,k=bs,br
local l,m,n=false,0 local o=br.Decoy==true bn[j]=true local function Distance()
local p,q=Character()local r=PromptPosition(j)return if q and r then(q.Position-
r).Magnitude else av end local function Hitbox()local p=k.Plot and k.Plot.Model:
FindFirstChild'StealHitbox'if not p or not p:IsA'BasePart'then return true end
local q,r=Character()return r~=nil and Inside(p,r.Position)end local function 
Charging()return bd.Plot~=nil and k.Plot==bd.Plot and SlotOf(k)==bd.Slot end
local function Alive()if j.Parent==nil and Charging()then local p=CampPrompt()if
p then Note'camp prompt was rebuilt, following it'bn[j]=nil j=p bn[j]=true end
end return aa.Running and a6.Enabled and aH.Character==f and j.Parent~=nil end
local function Ready()if k.Decoy or Carrying()or not j.Parent or Distance()>aM
or not Hitbox()then l=false return false end if os.clock()-i<g then l=true end
if not(j.Enabled and IsStealPrompt(j))then l=true return false end if Charging()
then l=true return true end if n then local p,q,r=Character()if os.clock()>m
then n=nil elseif q and r then local s=q.Position-aA(0,r.HipHeight+q.Size.Y*0.5,
0)if(q.Position-n).Magnitude<=0.5 or(s-n).Magnitude<=0.5 then l,n=true,nil end
end end return true end local p=af.Event(a2.Effects)local q=p and p.
OnClientEvent:Connect(function(q,r,s)if q~=aH or not Alive()or typeof(r)~=
'CFrame'or typeof(s)~='CFrame'then return end if(s.Position-r.Position).
Magnitude>0.5 then n,m=s.Position,os.clock()+0.300000000189 Ready()end end)local r=aG.
PlayerRemoving:Connect(function(r)if k.Plot and r==k.Plot.Owner and Alive()and
Ready()then l=true end end)local function Trigger()while os.clock()-i<g do az(
at(g-(os.clock()-i),0.03))if not Alive()then return false end end while Alive()
do local s=h-(os.clock()-i)local t,u,v=Character()if s<0 or not v then return
false end if not j:IsDescendantOf(aE)then return false end if not j.Enabled or
not IsStealPrompt(j)then if not Charging()then return false end az(0.03)continue
end local w=aH:GetAttribute'GiantPotion'~=nil local x=GummyLeft()local y=aH:
GetAttribute'BlockTools'==true or x>0 if not y and(w or not Ragdolled(v))then if
Distance()>aM or not Hitbox()then return false end if Charging()then Note(ar(
'grab sent %.2fs into the hold',os.clock()-i))end local z='grab remote'if bu and
c then Fire(c,bu.GrabArgs,e+aL,k.Plot.Model.Name,SlotOf(k))else local A,B=
PromptCalls(j)if not Run(B)then return false end z='game prompt'end Note(ar(
'grab %s via %s, %.2fs',tostring(k.Index),z,os.clock()-i))return true end if aq(
x,if w then 0 else RagdollLeft())>s then return false end az(at(s,0.03))end
return false end local function Retarget()if(l and Ready())or a6.Attempt or
Charging()then return false end local s,u=PickSteal()if u==j and k.Decoy and s
and not s.Decoy then k=s a6.Name=s.Index return true end if not s or not u or u
==j or not u.Parent or bn[u]then return false end local v,w=Character()local x=
PromptPosition(u)if not w or not x then return false end local y=(w.Position-x).
Magnitude if not k.Decoy and not(a6.Busy and s==a6.Target)and(a6.Picked~=nil or(
a6.Mode~='Highest'and y>=Distance()-2))then return false end bn[j]=nil j,k=u,s l
,n=false,nil bn[j]=true a6.Name=s.Index return true end local function Finish(s)
if q then q:Disconnect()end r:Disconnect()bn[j]=nil return s,k end if a6.Shield
and not bt and not k.Decoy and Available(k)then Protect()end if bu and bv then e
=aE:GetServerTimeNow()-aK Fire(bv,bu.BeginArgs,e)elseif not Run((PromptCalls(j))
)then a6.Status='steal remotes not found'return Finish(false)end if not k.Decoy
and Distance()<=aM and Hitbox()and(not Charging()or Ready())then local s=g-(os.
clock()-i)if s>0 then az(s)end if Alive()and Hitbox()then return Finish(Trigger(
))end end local s,u=false while Alive()do if Retarget()then u=nil end if os.
clock()-i>=h then if Ready()then s=Trigger()end break end if Ready()then u=u or
os.clock()if l or o or a6.Camped or os.clock()-(u)>=aN then s=Trigger()break end
else u=nil end az()end return Finish(s)end local function Track(br)local bs=os.
clock()+2 repeat if br.Confirmed then break end az(0.05)until not a6.Enabled or
aH.Character~=br.Char or os.clock()>=bs if br.Confirmed then while a6.Enabled
and aH.Character==br.Char and Carrying()do az(0.05)end bs=os.clock()+2 while a6.
Enabled and aH.Character==br.Char and Owned(br.Entity)<=br.Owned and not
Available(br.Entity)and os.clock()<bs do az(0.05)end if aH.Character==br.Char
and Owned(br.Entity)>br.Owned and a6.Picked==br.Entity.Key then a6.Picked=nil
end end br.Conn:Disconnect()end local function Watch(br)local bs={Entity=br,Char
=aH.Character,Owned=Owned(br),Confirmed=false}local bt=aH:GetAttribute'Stealing'
bs.Conn=aH:GetAttributeChangedSignal'Stealing':Connect(function()local bu=aH:
GetAttribute'Stealing'if aH.Character==bs.Char and bu~=nil and bu~=bt then bs.
Confirmed=true end bt=bu end)return bs end local function Cycle()local br,bs,bt=
PickSteal()if not br or not bs or not bs.Parent then return false end local bu=
if a6.Picked==br.Key then Watch(br)else nil a6.Attempt=bu a6.Active,a6.Name,a6.Start,a6.Entry=true,br.Index,os.clock(),br if bd.Plot~=nil or bt==true then Note(ar(
'cycle %s start, plain %s',br.Index,tostring(bt==true)))end local bv,c,e=pcall(
FireSteal,br,bs,bt)if not bv then warn("auto steal grab errored:",c)end a6.
Active=false if bd.Plot~=nil or(bv and c==true)then Note(ar(
'cycle %s ended after %.2fs, fired %s',br.Index,os.clock()-a6.Start,tostring(bv
and c==true)))end if a6.Attempt==bu then a6.Attempt=nil end if bv and c and not
bu and br.Decoy and e and a6.Picked==e.Key then bu=Watch(e)end if bu then if bv
and c then ay(Track,bu)else bu.Conn:Disconnect()end end return true end function
a6.Loop()while a6.Enabled do az(if Cycle()then 0.01 else 0.1)end end function a6
.WatchCamp()local br while a6.Enabled do local bs=a6.PickedEntity()local bt=bs
and PromptPosition(bs.Prompt)local bu,bv=Character()if bt and bv and(bv.Position
-bt).Magnitude<=aM then br=br or os.clock()else br=nil end a6.Camped=nil~=br and
os.clock()-br>=0.3 az(0.05)end a6.Camped=false end a6.GummyLeft=GummyLeft a6.
RagdollLeft=RagdollLeft a6.Ragdolled=Ragdolled a6.GrabMin=aI a6.HoldMax=aJ local function 
ClearLedge()if ba then ba:Destroy()ba=nil end end local function PlaceLedge(br)
ClearLedge()local bs=Instance.new'Part'bs.Name='Ledge'bs.Anchored=true bs.
CanTouch=false bs.Size=aA(aP.X+aT,0.5,aP.Z+aT)bs.Transparency=0.45 bs.Material=
Enum.Material.ForceField bs.Color=Color3.fromRGB(178,155,255)bs.CFrame=aB(br.X,
br.Y-ad.Feet()-0.25,br.Z)bs.Parent=aE ba=bs end local function SettleFlash(br)if
not(bb and bb.Connected)then return end local bs=false local bt=br:
GetPropertyChangedSignal'CFrame':Connect(function()bs=true end)local bu=os.
clock()+math.clamp(aH:GetNetworkPing()*2+0.1,0.2,aU)while not bs and bb and bb.
Connected and os.clock()<bu do aD.Heartbeat:Wait()end bt:Disconnect()
StopFlashWatch()if bc and(br.Position-bc).Magnitude>3 then br.
AssemblyLinearVelocity=Vector3.zero br.CFrame=aB(bc)*br.CFrame.Rotation end end
local function CeilingAbove(br,bs,bt)RefreshFilter()local bu=aE:Blockcast(aB(bs+
aY),aP,aA(0,bt-bs.Y,0),a9)if not bu or not bu.Instance:IsDescendantOf(br)then
return nil end return bs.Y+bu.Distance-0.150000000534-aS end local function Rise(br,bs)
local bt,bu,bv=Character()if not bu or not bv then return false end SettleFlash(
bu)local c=CeilingAbove(br,bu.Position,bs.Y)if not c then return false end local
e=bu.Position bv:ChangeState(Enum.HumanoidStateType.Jumping)bv.Jump=true local f
,g=bu.Position.Y,os.clock()local h=1.6666666666666665E-2 local i=os.clock()+3
while c-bu.Position.Y>0.05 and aa.Running and bv.Health>0 and os.clock()<i do if
((bu.Position-e)*aQ).Magnitude>3 then bu.AssemblyLinearVelocity=Vector3.zero
return false end if bu.Position.Y>f+0.02 then f,g=bu.Position.Y,os.clock()elseif
os.clock()-g>0.3 then break end bu.AssemblyLinearVelocity=aA(0,at(aR,(c-bu.
Position.Y)/aq(h,4.166666666666667E-3)),0)h=aD.Heartbeat:Wait()end bu.
AssemblyLinearVelocity=Vector3.zero if c-bu.Position.Y>1 then return false end
PlaceLedge(bu.Position)return true end local br local bs local function 
HoldCamera(bt)br=bt if bs then return end local bu=aE.CurrentCamera local bv=bu.
CameraType local c=aD.PreRender:Connect(function()local c=aH.Character local e=c
and(c:FindFirstChild"Head")if e and br then bu.CameraType=Enum.CameraType.
Scriptable bu.CFrame=aC(e.Position-br*12,br)end end)bs=function()c:Disconnect()
bu.CameraType=bv local e,f,g=Character()if g then bu.CameraSubject=g end bs=nil
br=nil end end local function ReleaseCamera()if bs then bs()end end local bt=-
math.huge local bu=20 local bv=0.4 local function FlashLeft(c)local f=c:
GetAttribute'CooldownUntil'local g=c:GetAttribute'CooldownTime'local h=aE:
GetServerTimeNow()local i=aq(if type(g)=='number'then g else 0,bt+bu-h)if type(f
)=='number'then i=aq(i,f-h)end return aq(0,i,al.Left(c.Name))end local function 
ToolReady(c)return FlashLeft(c)<=0 end local function FlashState(c)local f,g=
pcall(getconnections,c.Activated)if not f then return nil end for h,i in g do
local j=i.Function if not j or iscclosure(j)then continue end for k,l in debug.
getupvalues(j)do if type(l)=='table'and rawget(l,'Params')~=nil and rawget(l,
'Result')~=nil then return l end end end return nil end local function Valid(c)
return c~=nil and type(c.Result)=="table"and c.Result.Valid==true end local c=40
local f=2 local g=0.2617993877991494 local h=Vector3.new(1,0,1)local i=
RaycastParams.new()i.FilterType=Enum.RaycastFilterType.Exclude i.IgnoreWater=
true i.RespectCanCollide=true i.CollisionGroup="Player"local function FlashSkip(
)local j=aa.Services.CollectionService:GetTagged'FlashTeleportIgnore'for k,l in
aG:GetPlayers()do if l.Character then j[#j+1]=l.Character end end i.
FilterDescendantsInstances=j end local function FlashHit(j,k,l)local m local n=
aE:Blockcast(j,k,l,i)if n then m=n.Distance end local o=aE:Raycast(j.Position,l,
i)if o and(not m or o.Distance<m)then m=o.Distance end if(l*h).Magnitude>0.001
then local p=aq(k.X,k.Y,k.Z)local q=l.Unit*p local r=aE:Blockcast(j-q,k,l+q,i)if
r then local s=aq(0,r.Distance-p)if not m or m>s then m=s end end end return m
end local function FlashCompute(j)local k,l,m=j.Distance,j.RootSize,j.HipHeight
local n=j.RootCFrame*CFrame.new(0,-(m+l.Y*0.5),0)local o=j.CameraCFrame*CFrame.
fromOrientation(g,0,0)local p=CFrame.lookAlong(n.Position,o.LookVector)local q=
math.sqrt(l.X^2+l.Z^2)local r=Vector3.new(q,m+l.Y,q)local s=CFrame.new(0,r.Y*0.5
,0)local u,v=p*CFrame.new(0,0,-k),-av local function Consider(w)local x=((p.
Position-w.Position)*h).Magnitude if v<x then v,u=x,w end end FlashSkip()local w
=p*CFrame.new(0,0,-k)local x=w.Position-p.Position local y=FlashHit(p*s,r,x)if y
then Consider(CFrame.new(p.Position+x.Unit*y)*w.Rotation)for z,A in{r.Y*0.25,r.Y
*0.500000000268,r.Y,r.Y*1.25,r.Y*1.5,r.Y*2,0.5,1,2.5,5}do local B=p for C,D in{CFrame.new(0
,A,0),CFrame.new(0,0,-k),CFrame.new(0,-A,0)}do local E=B*D local F=E.Position-B.
Position local G=FlashHit(B*s,r,F)B=if G then CFrame.new(B.Position+F.Unit*G)*E.
Rotation else E end Consider(B)end else Consider(w)end local z,A=u:
ToOrientation()return{CFrame=CFrame.new(u.Position)*CFrame.fromOrientation(0,A,0
),Valid=aq(f,q)<=v}end local function Virtual(j)local k=aH.Character local l=k
and k:FindFirstChild'Head'local m=k and k.PrimaryPart local n=k and k:
FindFirstChildWhichIsA'Humanoid'if not l or not l:IsA'BasePart'or not m or not n
then return nil end local o={RootCFrame=m.CFrame,RootSize=m.Size,HipHeight=n.
HipHeight,CameraCFrame=aC(l.Position-j*12,j),Distance=c}local p,q=pcall(
FlashCompute,o)return if p then{Params=o,Result=q}else nil end local function 
FireFlash(j,k,l)local m,n=Character()local o=ad.FindTool'Flash Teleport'if not m
or not n or not o then a6.Status='no flash teleport'return false end local p=os.
clock()local q={}a6.FlashLog=q a6.FlashLogs=a6.FlashLogs or{}table.insert(a6.
FlashLogs,1,q)a6.FlashLogs[6]=nil local function Mark(r)q[#q+1]=ar('%.3f %s',os.
clock()-p,r)end a6.Status='waiting for flash cooldown'local r=aH:GetNetworkPing(
)local s=at(0.5*r,0.1)local u=at(r*0.5+0.05,0.4)local v,w=n.Position,os.clock()
local x=os.clock()+25 while(FlashLeft(o)>s or os.clock()-w<u)and os.clock()<x
and aa.Running and not a6.Abort do if(n.Position-v).Magnitude>0.3 then v,w=n.
Position,os.clock()end if FlashLeft(o)<bv and o.Parent~=m then local y,z,A=
Character()if A then A:EquipTool(o)end end aD.Heartbeat:Wait()end Mark'ready'ae.
AwaitEngage()if a6.Abort or FlashLeft(o)>s or not ad.Equip(o,a6.Travel and a6.
Travel.Equip)then return false end local z=FlashLeft(o)>0 Mark'equipped'local A=
af.Function(a2.Activate)local B=if A then Virtual(j)else nil if not Valid(B)then
HoldCamera(j)B=nil local C=os.clock()+2 repeat aD.PreRender:Wait()B=B or
FlashState(o)until Valid(B)or os.clock()>C if not Valid(B)then ReleaseCamera()
return false end end local C,D,E=false,false local F=n.Position local G local H
local function Landed(I)if C then return end C=true Mark'landed'local J=k(I)or I
H=J bc=J local K,L,M=Character()local N=if am.Prefer then ad.FindTool(am.Prefer)
else nil for O,P in am.Flying do N=N or ad.FindTool(P)end if N and M and N.
Parent~=m then M:EquipTool(N)end n.AssemblyLinearVelocity=Vector3.zero n.CFrame=
aB(J)*n.CFrame.Rotation end local I=af.Event(a2.Effects)local J=false local L
local M=I and I.OnClientEvent:Connect(function(M,N,O)if M==aH and typeof(O)==
'CFrame'and not G then G=O.Position Mark'effects'if not C and n.Parent then
Landed(O.Position)end end end)local N local O=false StopFlashWatch()L=aD.
Heartbeat:Connect(function()local P=n.Position if C then if not H or(P-H).
Magnitude<=3 then return end if not O and(P-F).Magnitude<4 then O=true Mark
"pulled back to the stand"end local Q=G~=nil and(P-G).Magnitude<4 if Q or(O and
N and E and os.clock()-N>0.05)then Mark(if Q then
'server moved, back to the podium'else'answered, back to the podium')n.
AssemblyLinearVelocity=Vector3.zero n.CFrame=aB(H)*n.CFrame.Rotation L:
Disconnect()end return end if(P-F).Magnitude<4 then return end if not J then J=
true Mark(ar('moved %.0f',(P-F).Magnitude))end if l then if Inside(l,P)then
Landed(P)end elseif G and(P-G).Magnitude<12 then Landed(P)end end)bb=L a6.Status
='flashing'Mark'fired'if A then ay(function()local P,Q,R=pcall(A.InvokeServer,A,
B.Params,B.Result)Mark("returned "..tostring(Q)..(if R~=nil then' '..tostring(R)
else''))E=if P then Q else nil a6.FlashRefused=if not P then tostring(Q)elseif
not Q then tostring(R)else nil if(P and Q)or(a6.FlashRefused=='OnCooldown'and
not z)then bt=aE:GetServerTimeNow()end D=true N=os.clock()end)else o:Activate()
aD.Heartbeat:Wait()aD.Heartbeat:Wait()end ReleaseCamera()x=os.clock()+2 while
not C and not(D and not E)and os.clock()<x and aa.Running do aD.Heartbeat:Wait()
end if D and not E then local P=os.clock()+0.3 while not C and os.clock()<P do
aD.Heartbeat:Wait()end end if not C and E and G then Landed(G)end if M then M:
Disconnect()end ay(function()local P=os.clock()+3 while L.Connected and os.
clock()<P and not(N and os.clock()-N>0.5)do az(0.05)end L:Disconnect()end)return
C or(E~=nil and E~=false)end local function PromptOf(j,k)local l=j:
FindFirstChild'AnimalPodiums'local m=l and l:FindFirstChild(tostring(k))local n=
m and m:FindFirstChild('Spawn',true)local o=n and n:FindFirstChild
'PromptAttachment'return if o and o:IsA'Attachment'then o.WorldPosition else nil
end local function StandWorld(j,k)RefreshFilter()local l=j:PointToWorldSpace(aA(
k[1],aO,k[2]))local m=aE:Raycast(l+aA(0,2,0),aA(0,-8,0),a9)if not m or m.Normal.
Y<0.95 then return nil,nil end return m.Position+aA(0,Lift(),0),j:
VectorToWorldSpace(aA(k[3],k[4],k[5])).Unit end local function PlayerNear(j)for
k,l in aG:GetPlayers()do local m=l~=aH and l.Character and l.Character:
FindFirstChild'HumanoidRootPart'if m and m:IsA'BasePart'and((m.Position-j)*aQ).
Magnitude<3 then return true end end return false end local function Usable(j)
return j~=nil and BodyClear(j)and not PlayerNear(j)end local function PickStand(
j,k)local l=ah[j:GetAttribute'Order']local m,n=Character()local o=j:
FindFirstChild'MainRoot'if not l or not n or not o or not o:IsA'BasePart'then
return nil,nil end local p=o.CFrame local q=p:PointToObjectSpace(n.Position)
local r={}for s,u in k do for v,w in l[u]or{}do r[#r+1]={w,(w[1]-q.X)^2+(w[2]-q.
Z)^2}end end table.sort(r,function(s,u)return s[2]<u[2]end)for s,u in r do local
v,w=StandWorld(p,u[1])if v and Usable(v)then return v,w end end return nil,nil
end local function PodiumSpot(j,k,l)local m=j:FindFirstChild'AnimalPodiums'local
n=m and m:FindFirstChild(tostring(k))local o=j:FindFirstChild'MainRoot'if not n
or not n:IsA'PVInstance'or not o or not o:IsA'BasePart'then return nil end
RefreshFilter()local p=n:GetPivot().Position local q=o.CFrame:PointToWorldSpace(
aA(0,aZ[FloorOf(k)],0)).Y local r=aA(p.X,l.Y,p.Z)local s=(r-l).Magnitude local u
=ap(s/0.5)for v=0,u do local w=r:Lerp(l,at(1,v*0.5/aq(s,0.001)))if BodyClear(w)
then local x=aE:Raycast(w,aA(0,-(Lift()+6),0),a9)if x and x.Normal.Y>=0.95 and x
.Instance:IsDescendantOf(j)and ao(x.Position.Y-q)<=1.5 then return w end end end
for v=0,u do local w=r:Lerp(l,at(1,v*0.5/aq(s,0.001)))if BodyClear(w)then local
x=w-aA(0,Lift(),0)local z=aE:Raycast(x+aY,aA(0,-1.400000000216,0),a9)if z and z.Instance:
IsDescendantOf(j)and z.Normal.Y>=0.95 then return w end end end return r end
local function BlueSide(j)local k,l=0,0 local m=aE:FindFirstChild'Plots'local n=
if m then m:GetChildren()else{}for o,p in n do local q=p:FindFirstChild
'MainRoot'if q and q:IsA'BasePart'then k+=q.Position.X l+=1 end end return j.X>=
(if l>0 then k/l else-409.6)end local function CloneSooner()local j=ad.FindTool
'Flash Teleport'local k=if j then FlashLeft(j)else av local l=a6.Travel if not l
then return false,k end local m=ai.Left()if l.Prefer=='Clone'then return av>m
and m<=aq(k,0.5),k end return l.Clone==true and k>0 and m<at(k,6),k end local 
function FlashIn(j,k,l,m)local n=j:FindFirstChild'StealHitbox'local o=os.clock()
+15 local p=0 local function SnapFor(q)return PodiumSpot(j,k,q)end while true do
p+=1 if FireFlash(m,SnapFor,if n and n:IsA'BasePart'then n else nil)then break
end if CloneSooner()then return false,true end local q,r=Character()local s=not
r or((r.Position-l)*aQ).Magnitude>3 if not aa.Running or a6.Abort or s or os.
clock()>o then a6.Status='flash didnt land after '..p..' tries'..(if a6.
FlashRefused then': '..a6.FlashRefused else"")return false end aD.Heartbeat:
Wait()end return true end local function PlanRoute(j,k,l)local m,n=Character()if
not n then return nil,true,false end aj.Narrow=not l local o=aj.RouteD3(n.
Position,j,k)aj.Narrow=false local p,q=0,n.Position for r,s in o do p+=(s-q).
Magnitude q=s end local r=(j-n.Position).Magnitude local s=if aj.LastRoute then
tostring(aj.LastRoute.Src)else''local u=as(s,'blocked',1,true)~=nil or as(s,
'forced',1,true)~=nil or#o==0 or(o[#o]-j).Magnitude>3 return o,u,p>aq(r*aV,r+aW)
end local function _closeSp(p,o,j)local cs=tonumber(p.CloseSpeed)local cd=tonumber(p.CloseDist)or 60 if cs and cs>0 and o and j and(o.Position-j).Magnitude<=cd then return cs end return nil end local function FlyTo(j,k,l,m,_flat)local n,o=Character()if not o then return false
end local p=a6.Travel or{}aj.ShortEntry=m==true local q=l or aj.RouteD3(o.
Position,j,k)local r=if p.Show then ae.Draw{o.Position,ax(q)}else nil local s=aj
.Fly(o,q,k,j,{FlatSpeed=_flat,Speed=_closeSp(p,o,j)or p.Speed or 300,Unboosted=p.Unboosted,Rise=p.Rise or 55,Turn=
p.Turn,Launch=ae.Launch})aj.ShortEntry=false if r then r()end local u,v=
Character()return s and not a6.Abort and nil~=v and(v.Position-j).Magnitude<=3
end local function FloorAt(j)return if j>23.15 then 3 elseif 11<=j then 2 else 1
end local function Reaching()return not(a6.Travel and a6.Travel.Under==false)end
local function EntryReady()local j,k=CloneSooner()local l=if a6.Travel and a6.
Travel.Clone then ai.Left()else av return at(k,l)<=1 end local function Direct(j
,k,l,m,o)local p=ai.InWalls(k,o.Position)local q,r=FloorAt(m.Y),FloorAt(o.
Position.Y)local s=Reaching()and q-r==1 local u=ag.BlockSeconds(j.Plot,q)>0
local v=not(u or a6.LasersUp(k,q))if not((p and(q==r or s or not u))or(v and aj.
ClearWideD3(o.Position,m)))then return nil end if not s and(o.Position-m).
Magnitude>60 then local w,x,z=PlanRoute(m,nil)if x or(z and EntryReady())then a6
.Status='the way in is a detour, using flash or clone'return nil end a6.Status=
'flying to the brainrot'local A=FlyTo(m,nil,w)ReleaseCamera()if not A and a6.
Abort then return false end else ae.Engage()end if not ai.GoTo(if a6.Travel then
a6.Travel.Approach or'CFrame'else'CFrame',m,l,k,false,a6.Travel and a6.Travel.
BrainrotSpeed)then a6.Status='couldnt reach the brainrot'return false end a6.
Status='on target'return true end local function LasersUp(j,k)local l=j:
FindFirstChild'LaserHitbox'local m=if l then l:GetChildren()else{}for o,p in m
do if p:IsA'BasePart'and p.CanCollide and(if k==1 then p.Position.Y<=9 else p.
Position.Y>9 and p.Position.Y<=25)then return true end end return false end a6.
LasersUp=LasersUp local function WalkIn(j,k,l,m,o)local p=Reaching()and l==2
local q=if p then 1 else l if l>2 or ag.BlockSeconds(j.Plot,q)>0 or LasersUp(k,q
)then return nil end local r=if p then CeilingAbove(k,aA(m.X,-4,m.Z),m.Y)else
nil local s=aA(m.X,if r then r-0.500000000759 elseif 2==l and not p then m.Y-2.5 else-4,m.Z
)local u,v=ai.Approach(m,o.Position,j.Index,'Front')local w,x,z=PlanRoute(s,v,p)
if x or(z and not p and EntryReady())then a6.Status=
'the way in is a detour, using flash or clone'return nil end a6.Status=if p then
'walking in under the brainrot, base is open'else'walking in, base is open'local
A=FlyTo(s,v,w)ReleaseCamera()if a6.Abort or not aa.Running then return false end
local B,C=Character()if C and(A or(not p and ai.InWalls(k,C.Position)))and ag.
BlockSeconds(j.Plot,q)<=0 and not LasersUp(k,q)then if p then Rise(k,m)end a6.
Status='on target'return true end aa.Menu.Notify('Teleport',
'Base locked mid-fligh⁠t, going in another way','Info',3)return nil end local j=
14 local function WarpIn(k,l,m,o)local p={name=tostring(k.Index),plot=l.Name,
slot=tostring(m)}local q=an.IsOpen(p)if not q then if an.CloneLeft()==av then a6
.Status='base is locked, needs a Quantum Cloner'return false end while an.
CloneLeft()>1 and not a6.Abort and aa.Running do a6.Status=ar(
'waiting for the cloner (%ds)',ap(an.CloneLeft()))az(0.1)end if a6.Abort or not
aa.Running then return false end end a6.Status=if q then'flying to the brainrot'
else'flying to the clone spot'an.Go(p,function(r)a6.Status=r end)if a6.Abort or
not aa.Running then return false end local r,s=Character()if not s or(s.Position
-o).Magnitude>j then a6.Status='didnt reach the brainrot'return false end a6.
Status='on target'return true end local function Run(k)local l=k.Plot.Model
local m=l:FindFirstChild'MainRoot'local o,p=Character()if not p or not m or not
m:IsA"BasePart"then return false end ClearLedge()StopFlashWatch()local q=SlotOf(
k)local r=m.CFrame local s=FloorOf(q)local v=PromptOf(l,q)if not v then a6.
Status="podium not found"return false end if a6.Travel and a6.Travel.Prefer=='Clone'then an.SetEntry(a6.Travel.Entry)return WarpIn(k,l,q,v)end local w=Direct(k,l,q,v,p)if w~=nil then
return w end local x=WalkIn(k,l,s,v,p)if x~=nil then return x end local z,A=
Character()if not A then return false end p=A local B=l:GetAttribute
'BaseSkinName'if aX[B]then if ai.Left()==av then a6.Status=
'needs a Quantum Cloner for '..B..' bases'return false end while ai.Left()>6 and
not a6.Abort and aa.Running do a6.Status=ar('waiting for the cloner (%ds)',ap(ai
.Left()))az(0.1)end if a6.Abort or not aa.Running then return false end aa.Menu.
Notify("Teleport",B..' base has windows, using the cloner','Info',3)return
WarpIn(k,l,q,v)end local C,D=CloneSooner()if C then if a6.Travel.Prefer~='Clone'
then aa.Menu.Notify('Teleport',if D<av then ar(
'Flash on cooldown (%ds), using the cloner',ap(D))else
'No Flash Teleport, using the cloner','Info',3)end return WarpIn(k,l,q,v)end if
D>0 then local E=if a6.Travel and a6.Travel.Clone then ai.Left()else av local F=
at(D,E)aa.Menu.Notify('Teleport',if av<=F then
'No Flash Teleport or Quantum Cloner'elseif E<av then ar(
'Flash and cloner on cooldown, teleport in %.1fs',F)else ar(
'Flash on cooldown, teleport in %.1fs',F),'Warning',3)end local E=BlueSide(p.
Position)~=BlueSide(m.Position)local F=(r:PointToObjectSpace(p.Position).X>=0)~=
(r:PointToObjectSpace(v).X>=0)local G=F or(s>=2 and E)local H,I local J=
Reaching()and s==2 if s>=2 and not J and(G or not Reaching())then local L=av
local M=if a6.Travel and a6.Travel.Entry then a6.Travel.Entry else'Multi'local N
=if M=='Front'then{a_[s]}elseif M=='Side'then{ax(a0[s])}else{a_[s],ax(a0[s])}for
O,P in N do local Q,R=StandWorld(r,P)if Q and Usable(Q)then local S=((Q-p.
Position)*aQ).Magnitude if S<L then H,I,L=Q,R,S end end end elseif G then H,I=
PickStand(l,{1,2,3,4,5,6,7,8,9,10})else H,I=PickStand(l,{q})end if not H or not
I then a6.Status='no usable stand'return false end a6.Status='flying to stand'if
not FlyTo(H,nil,nil,nil,a6.Travel and(_closeSp(a6.Travel,p,H)or tonumber(a6.Travel.Speed))or nil)then a6.Status='couldnt reach the stand'return false end local L
,M=Character()if not M or((M.Position-H)*aQ).Magnitude>3 then a6.Status=
'stopped short of the stand'return false end if a6.Travel and(a6.Travel.Delay or
0)>0 then az(a6.Travel.Delay)end local N,O=FlashIn(l,q,H,I)if O then aa.Menu.
Notify('Teleport','Flash missed, using the cloner','Info',3)return WarpIn(k,l,q,
v)end if not N then return false end az(au(aH:GetNetworkPing()*2,0.15,0.4))local
P,Q=Character()local R=bc if Q and R and((Q.Position-R)*aQ).Magnitude>6 and ai.
InWalls(l,Q.Position)then StopFlashWatch()a6.Status=
'lagged back after the flash, gliding'local S=Reaching()and 2==s local T=if S
then aA(v.X,-4,v.Z)else v if not ai.GoTo("Velocity",T,if S then nil else q,l,
false,a6.Travel and a6.Travel.BrainrotSpeed)then a6.Status=
'couldnt reach the brainrot'return false end end local S,T=Character()if T and v
.Y-T.Position.Y>3 then if s==2 and not Reaching()then a6.Status=
"flash landed below the brainrot's floor"return false end Rise(l,v)end a6.Status
='on target'return true end local function Launch(k)_G.D3FlightActive=true a6.Busy,a6.Abort,a6.Target=true,false,k ae.ClearPaths()local l,m=pcall(Run,k)if not l then a6.Status=
'run errored'warn('auto steal run errored:',m)end ReleaseCamera()_G.D3FlightActive=false a6.Busy=false
return l and m==true end function a6.Launch(k)if a6.Busy then return false end
return Launch(k)end function a6.Cancel()aj.Stop()an.Cancel()a6.Abort=true ae.
Abort()ReleaseCamera()end function a6.Choose(k)local l=a6.PickedEntity()if not l
and a6.Auto and not a6.Paused then local m=ab.Get(a6.Auto)l=if m and Targetable(
m,true)then m else nil end if l and k and not k(l)then l=nil end if not l then
local m=a6.Ranked(true)if not(m[1]and ac.OGs[m[1].Index])then for p,q in a6.Ranked(
true)do if Stolen(q)and ac.OGs[q.Index]then table.insert(m,1,q)break end end end
for p,q in m do if not k or k(q)then l=q break end end if not l then for p,q in
a6.Ranked(true)do if Stolen(q)and(not k or k(q))then l=q break end end end end
return l end function a6.Go(k)if a6.Busy then return nil,false end local l=a6.
Choose(k)if not l then a6.Status='no targets'return nil,false end return l,
Launch(l)end function a6.Spot(k)local l=k.Plot.Model local m=l:FindFirstChild
'MainRoot'if not m or not m:IsA'BasePart'then return nil end local p=SlotOf(k)
local q=m.CFrame:PointToWorldSpace(aA(0,aZ[FloorOf(p)],0))return PodiumSpot(l,p,
q+aA(0,Lift(),0))end a6.PromptOf=PromptOf a6.Reach=aM function a6.Camp(k)if a6.
Busy then return end local l=ag.Animals(k)local m=k.Model:FindFirstChild
'AnimalPodiums'if not m then return end if a6.FillTravel then a6.FillTravel()end
for p=1,#m:GetChildren()do local q=tostring(p)if m:FindFirstChild(q)and not l[q]
and not(l)[p]then bd.Plot=nil if Launch{Index='Camp',Slot=q,Plot=k,Key='camp'}
then bd.Plot,bd.Slot,bd.Until,bd.Seen=k,p,os.clock()+180,os.clock()a6.Status=
'camping slot '..q end return end end a6.Status='no empty podium'end a6.Smart=bf
local function DropGap(k,l)local m=k.Model:FindFirstChild('DeliveryHitbox',true)
if not m or not m:IsA'BasePart'then return nil end local p=m.CFrame:
PointToObjectSpace(l)local q=m.Size*0.5 local r=m.CFrame:PointToWorldSpace(aA(
au(p.X,-q.X,q.X),p.Y,au(p.Z,-q.Z,q.Z)))return((r-l)*aQ).Magnitude end local 
function SmartWatch(k,l,m)local p=os.clock()+bi local q,r=(os.clock())local s=0
local v=false local w=0 while bf.Token==m and aa.Running and os.clock()<p do az(
bk)local x=l.Character local A=x and(x:FindFirstChild'HumanoidRootPart')local B=
os.clock()if not l.Parent or not A then r,s,v=nil,0,false bf.Due=w>B continue
end local C=A.Position if r then local D=((C-r)*aQ).Magnitude/aq(B-q,
1.6666666666666665E-2)if bl>D then s=s*0.6+D*0.4 end end r,q=C,B if not ad.
Carrying(l)then v=false bf.Due=B<w a6.Status=if bf.Due then ar(
'smart camp: grabbing from %s',l.DisplayName)else ar(
"smart camp: waiting for %s to steal",l.DisplayName)continue end if not ai.
InWalls(k.Model,C)then v=true end if not v then bf.Due=B<w continue end local D=
DropGap(k,C)local E=if not D then av elseif D<1 then 0 elseif s>2 then D/(s*bh)
else av if E<=bg then w=B+bj end bf.Due=w>B a6.Status=if bf.Due then ar(
'smart camp: %s home in %.1fs, grabbing',l.DisplayName,E)elseif av>E then ar(
'smart camp: %s home in %.1fs',l.DisplayName,E)else ar(
'smart camp: %s is carrying',l.DisplayName)end if bf.Token==m then bf.Player,bf.
Plot,bf.Due=nil,nil,false a6.Status='smart camp ended'end end function a6.
SmartCamp(k,l)bf.Token+=1 if bf.Player==l then bf.Player,bf.Plot,bf.Due=nil,nil,
false bd.Plot=nil a6.Status='smart camp off'return end bf.Player,bf.Plot,bf.Due=
l,k,false ay(SmartWatch,k,l,bf.Token)a6.Camp(k)end function a6.Stop()aj.Stop()an
.Cancel()a6.Abort=true a6.Auto,a6.Paused=nil,false bd.Plot=nil bf.Player,bf.Plot
,bf.Due=nil,nil,false bf.Token+=1 ae.Abort()ReleaseCamera()ClearLedge()end aa.
Clean(a6.Stop)aa.Steal=a6 return a6 end function a.B()local aa=a.cache.B if not
aa then aa={c=__modImpl()}a.cache.B=aa end return aa.c end end  do local function __modImpl()local aa=a.a()
local ab=string.lower local ac=string.gsub local ad=string.match local ae=string
.gmatch local af=string.find local ag=aa.Services.HttpService local ah={{'Son',
'http://sonapi.duckdns.org:3001/son'},{'Griefer',
'http://sonapi.duckdns.org:3001/griefer'},{'Family',
[[https://gist.githubusercontent.com/josecastle21/fcc5696b9d37ae086a324d99e6b8fa5e/raw/fmly_badboys.json]]
}}local ai={discord=true,user=true,username=true,name=true,roblox=true,add=true,
['or']=true,its=true,it=true,to=true,the=true,son=true,sons=true,goodboy=true,
badboy=true,remove=true,grief=true,supreme=true,base=true,drag=true,void=true,
comp=true}local aj={Son={},Griefer={},Good={},Bad={},Reasons={},Discords={},Hubs
=(setmetatable({},{__mode='k'})),Loaded=false}local ak={'bt user','bt hub','bt '
}local function Strip(al)local am=(ac(al,'^[@%.%*\\/]+',''))am=(ac(am,
'[:,%*\\]+$',''))return(ac(am,'^[Uu][Ss][Ee][Rr]:',''))end local function Usable
(al,am)return#al>=am and ad(al,'^[%w_]+$')~=nil and not ai[ab(al)]end local 
function Clean(al)if type(al)~='string'then return nil end local am={}for an in
ae(al,'%S+')do am[#am+1]=an end if#am==1 then local an=Strip(am[1])return if
Usable(an,3)then ab(an)else nil end local an for ao,ap in am do local aq=Strip(
ap)if Usable(aq,6)and(not an or#aq>#an)then an=aq end end return if an then ab(
an)else nil end local function Absorb(al,am)if type(am)~='table'then return end
table.clear(al)for an,ao in am do local ap=Clean(ao)if ap then al[ap]=true end
end end local function Fetch(al)local am if request then local an,ao=pcall(
request,{Url=al,Method='GET'})am=if an and type(ao)=='table'then ao.Body else
nil end if not am then local an,ao=pcall(function()return(game):HttpGet(al)end)
am=if an then ao else nil end if not am then return nil end local an,ao=pcall(ag
.JSONDecode,ag,am)return if an then ao else nil end local function Family(al)
Absorb(aj.Good,al.good)Absorb(aj.Bad,al.bad)for am,an in(if type(al.reasons)==
'table'then al.reasons else{})do local ao=Clean(am)if ao and type(an)=='string'
and an~=''then aj.Reasons[ao]=an end end for am,an in(if type(al.links)=='table'
then al.links else{})do local ao=type(an)=='table'and an.discord local ap=Clean(
if type(an)=='table'and an.roblox then an.roblox else am)if ap and type(ao)==
'string'and ao~=''then aj.Discords[ap]=ao end end end function aj.Load()for al,
am in ah do local an=Fetch(am[2])if type(an)~='table'then warn(
'couldnt load the',ab(am[1]),'list, keeping the old one')continue end if am[1]==
'Family'then Family(an)else Absorb((aj)[am[1] ],an.usernames)end end aj.Loaded=
true end function aj.Scan(al)local am=al.Character local an={}local ao=if am
then am:GetDescendants()else{}for ap,aq in ao do if aq:IsA'TextLabel'and aq.
Visible and aq:FindFirstAncestorWhichIsA'BillboardGui'then an[#an+1]=ab(aq.Text)
end end local ap=table.concat(an,' | ')..' 'local aq=false for ar,as in ak do if
af(ap,as,1,true)then aq=true break end end aj.Hubs[al]=aq end local al=table.
freeze{AP=Color3.fromRGB(205,203,212),Owner=Color3.fromRGB(110,170,255),Griefer=
Color3.fromRGB(255,120,120),Bad=Color3.fromRGB(239,159,39),Son=Color3.fromRGB(
110,220,160),Good=Color3.fromRGB(74,158,255),BT=Color3.fromRGB(170,81,255)}
function aj.Tags(am,an)local ao=ab(am.Name)local ap={}if am:GetAttribute
'AdminCommands'then ap[#ap+1]={Text='AP',Color=al.AP}end if an then ap[#ap+1]={
Text='BASE OWNER',Color=al.Owner}end if aj.Griefer[ao]then ap[#ap+1]={Text=
'GRIEFER',Color=al.Griefer}end if aj.Bad[ao]then ap[#ap+1]={Text='BAD',Color=al.
Bad}end if aj.Son[ao]then ap[#ap+1]={Text='SON',Color=al.Son}end if aj.Good[ao]
then ap[#ap+1]={Text='FMLY',Color=al.Good}end if aj.Hubs[am]then ap[#ap+1]={Text
='BT',Color=al.BT}end return ap end return aj end function a.D()local aa=a.cache
.D if not aa then aa={c=__modImpl()}a.cache.D=aa end return aa.c end end do
local function __modImpl()local aa=a.a()local ab=a.h()local ac=a.B()local ad=a.
o()local ae=aa.LocalPlayer local af={Busy=false,Locked=false}function af.
CanSwing(ag)return not af.Locked and(ag or not af.Busy)and not ac.Busy and not
ad.Busy and not ab.Carrying(ae)end function af.Stow()local ag,ah,ai=ab.
Character()local aj=ab.FindTool'Bat'if ai and aj and aj.Parent==ae.Character
then ai:UnequipTools()end end local function Ping()return math.clamp(ae:
GetNetworkPing(),0.03,0.3)end function af.Swing()local ah,ai,aj=ab.Character()
local ak=ab.FindTool'Bat'if not ah or not aj or not ak then return nil end if ak
.Parent~=ah then aj:EquipTool(ak)task.wait(Ping())end if ak.Parent~=ah or not ak
.Enabled then return nil end ak:Activate()return ak end function af.Strike(ah)
local ai=ab.FindTool'Bat'local aj=ai and ai:FindFirstChild'Handle'if not aj or
not aj:IsA'BasePart'or not firetouchinterest then return end local ak=true task.
spawn(function()while ak and ah.Parent do firetouchinterest(aj,ah,0)
firetouchinterest(aj,ah,1)task.wait()end end)af.Swing()local al=os.clock()+Ping(
)*2+0.25 while ah.Parent and os.clock()<al do task.wait()end ak=false end return
af end function a.E()local aa=a.cache.E if not aa then aa={c=__modImpl()}a.cache
.E=aa end return aa.c end end 
 
 
 do local 
function __modImpl()local aa=a.a()local ab=a.d()local ac=a.f()local ad=Color3.
fromRGB local ae={}ae.Mutations=table.freeze{Gold=ad(255,205,90),Diamond=ad(120,
220,255),Rainbow=ad(255,140,220),Bloodrot=ad(225,60,80),Candy=ad(255,150,200),
Lava=ad(255,125,60),Galaxy=ad(160,125,255),YinYang=ad(225,225,230),Radioactive=
ad(140,255,90),Cursed=ad(175,80,225),Cyber=ad(80,220,255),Divine=ad(255,230,140)
,Crystal=ad(170,230,255),Phantom=ad(190,190,230)}local function Mount(af)local
ah=getthreadidentity()setthreadidentity(8)af.Parent=aa.GetHui()
setthreadidentity(ah)end function ae.Billboard(af,ah,ai,aj)local ak=Instance.new
'BillboardGui'ak.AlwaysOnTop=true ak.LightInfluence=0 ak.Size=UDim2.fromOffset(
aj or 200,ai*20)ak.StudsOffset=ah if af then ak.Adornee=af end local al={}for am
=1,ai do local an=Instance.new'TextLabel'an.BackgroundTransparency=1 an.Position
=UDim2.fromOffset(0,(am-1)*20)an.Size=UDim2.new(1,0,0,20)an.FontFace=ab.Font(
Enum.FontWeight.SemiBold)an.TextSize=if am==1 then 18 else 16 an.TextColor3=
Color3.new(1,1,1)an.TextStrokeTransparency=0 an.Parent=ak al[am]=an end Mount(ak
)return ak,al end function ae.Card(af,ah,ai,aj)local ak=ac.Theme local al,am=ae.
Billboard(af,ah,ai)al.Size=UDim2.new(0.6*aj,120,(0.85*ai+0.3)*0.6,18*ai+8)local
an=Instance.new'Frame'an.Size=UDim2.fromScale(1,1)an.BackgroundColor3=ak.Window
an.BackgroundTransparency=0.2 an.ZIndex=0 an.Parent=al local ao=Instance.new
'UICorner'ao.CornerRadius=UDim.new(0.15,0)ao.Parent=an local ap=Instance.new
'UIStroke'ap.Thickness=1 ap.Color=ak.Edge ap.Parent=an local aq=0.9/ai for ar,as
in am do as.Position=UDim2.fromScale(0.05,0.05+(ar-1)*aq)as.Size=UDim2.
fromScale(0.9,aq)as.ZIndex=1 as.TextScaled=true as.RichText=true as.
TextXAlignment=Enum.TextXAlignment.Left as.TextStrokeTransparency=0.6 local at=
Instance.new'UITextSizeConstraint'at.MaxTextSize=if 1==ar then 18 else 16 at.
MinTextSize=if ar==1 then 13 else 12 at.Parent=as end return al,am,ap end
function ae.Highlight(af,ah,ai)local aj=Instance.new'Highlight'aj.Adornee=af aj.
FillColor=ah aj.OutlineColor=ah aj.FillTransparency=ai aj.OutlineTransparency=0
aj.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop Mount(aj)return aj end function
ae.Line()return{From=nil,Beam=nil,To=nil}end function ae.Point(af,ah,ai,aj)if
not ah or not ai or not ai.Parent then if af.Beam then af.Beam.Enabled=false end
return end if not af.From or af.From.Parent~=ah then if af.From then af.From:
Destroy()end local ak=Instance.new'Attachment'ak.Name='Point'ak.Parent=ah af.
From=ak end if not af.To or af.To.Parent~=ai then if af.To then af.To:Destroy()
end local ak=Instance.new'Attachment'ak.Name='Point'ak.Parent=ai af.To=ak end if
not af.Beam or not af.Beam.Parent then local ak=Instance.new'Beam'ak.FaceCamera=
true ak.Width0,ak.Width1=0.35,0.35 ak.LightEmission=1 ak.LightInfluence=0 ak.
Transparency=NumberSequence.new(0.15)ak.Segments=2 af.Beam=ak end local ak=af.
Beam ak.Color=ColorSequence.new(aj)ak.Attachment0,ak.Attachment1=af.From,af.To
ak.Parent=ah ak.Enabled=true end function ae.Unpoint(af)for ah,ai in{af.Beam,af.
From,af.To}do if ai then ai:Destroy()end end af.Beam,af.From,af.To=nil,nil,nil
end function ae.Price(af)if not af or af<=0 then return'no price'end if af>=1e3
then return string.format('$%.1fK',af/1e3)end return string.format('$%.2f',af)
end local af={{1e15,'Qa'},{1e12,'T'},{1e9,'B'},{1e6,'M'},{1e3,'K'}}function ae.
Rate(ah)for ai,aj in af do if ah>=aj[1]then return string.format('$%.1f%s/s',ah/
aj[1],aj[2])end end return string.format('$%d/s',math.floor(ah))end return ae
end function a.I()local aa=a.cache.I if not aa then aa={c=__modImpl()}a.cache.I=
aa end return aa.c end end 
 
 do local function __modImpl()
local aa=a.a()local ab=a.b()local ac=a.t()local ad=a.I()local ae=a.e()local af=
math.floor local ah=string.format local ai=aa.Services.RunService local aj=
'#ff6b6b'local ak="#ffd166"local al local am={}local an={}local function Clock(
ao)local ap=af(ao)return ah("%d:%02d",af(ap/60),ap%60)end local function Drop(ao
)local ap=an[ao]if not ap then return end an[ao]=nil ap.Board:Destroy()end local _ui=a.f()local _box=_ui.New('Frame',{Name='BaseOpenTimer',AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,68),Size=UDim2.fromOffset(0,46),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=Color3.fromRGB(14,14,18),Visible=false,ZIndex=50},_ui.Overlay)_ui.Corner(_box,16)_ui.Stroke(_box)_ui.Padding(_box,0,20)
local _lbl=_ui.New('TextLabel',{Size=UDim2.fromOffset(0,46),AutomaticSize=Enum.AutomaticSize.X,RichText=true,Font=Enum.Font.GothamBold,TextSize=28,TextColor3=Color3.new(1,1,1),Text='',ZIndex=51},_box)
local function Update()local _ch=aa.LocalPlayer.Character local _rt=_ch and _ch:FindFirstChild'HumanoidRootPart'local _p=_rt and ac.Nearest(_rt.Position,function(p)return p.Owner~=nil end)local _sec=0 if _p then for _,_u in ac.Unlocks(_p)do local _f=_u.Floor if _f and am[_f]and am[_f].Enabled then local _s=ac.BlockSeconds(_p,_f)if _s>_sec then _sec=_s end end end end if _sec>0 then _lbl.Text=ah('<font color="%s">%ds</font>',aj,math.ceil(_sec))_box.Visible=true else _box.Visible=false end end al=ab.Categories.Render:CreateModule{Name='BaseESP',
Tooltip='Seconds until the base you are in opens',Function=function(ao)if not ao then _box.Visible=false return end
al:Clean(function()for ap in an do Drop(ap)end end)local ap=0.2 al:Clean(ai.
Heartbeat:Connect(function(aq)ap+=aq if ap>=0.2 then ap=0 Update()end end))end}
am[1]=al:CreateToggle{Name='First floor',Default=true}am[2]=al:CreateToggle{Name
='Second floor',Default=true}am[3]=al:CreateToggle{Name='Third floor',Default=
true}return al end function a.L()local aa=a.cache.L if not aa then aa={c=
__modImpl()}a.cache.L=aa end return aa.c end end do local function __modImpl()
local aa=a.a()local ab=a.b()local ac=a.v()local ad=a.t()local ae=a.I()local af=a
.f()local ah=task.spawn local ai=task.wait local aj=af.Theme local ak=Color3.
fromRGB(255,214,101)local al=aj.Accent local am=aj.Edge:Lerp(aj.Accent,0.55)
local an local ao local ap local aq local ar local as={}local function Passes(at
)if at.Income<math.max(ao.Value,20)*1e6 or at.Fusing or type(at.Steal)=='string'then return
false end if aq.Enabled and at.Source=='Road'then return false end local au=ad.
Mine()return not au or at.Plot~=au end local function Body(at,au)local av=at.
Plot if av and av.Model then local aw,ax=12 for ay,az in av.Model:GetChildren()
do if az:IsA'Model'and az.Name==at.Index then local aA=(az:GetPivot().Position-
au.Position).Magnitude if aA<aw then ax,aw=az,aA end end end return ax end
return au:FindFirstAncestorOfClass'Model'end local function Drop(at)local au=as[
at]if not au then return end as[at]=nil au.Board:Destroy()if au.Glow then au.
Glow:Destroy()end end local function Card(at)local au,av=ae.Billboard(at,Vector3.new(0,6,0),2,220)au.Size=UDim2.fromOffset(220,44)au.Enabled=ar.Value==0 for _i,_l in av do _l.Position=UDim2.fromOffset(0,(_i-1)*22)_l.Size=UDim2.new(1,0,0,22)_l.RichText=true _l.TextStrokeTransparency=0 _l.TextStrokeColor3=Color3.new(0,0,0)_l.TextXAlignment=Enum.TextXAlignment.Center _l.TextSize=if _i==1 then 18 else 16 end av[1].TextColor3=Color3.fromRGB(255,40,40)av[2].TextColor3=Color3.fromRGB(255,230,0)return{Board=au,Edge=Instance.new'UIStroke',Lifted=false,Labels=av,Part=at}end local function Lift(at,au)if not(at.Body and at.Body.Parent)
then at.Body=Body(au,at.Part)at.Lifted=false end local av=at.Body if at.Lifted
or not av or not av:IsA'Model'then return end local aw,ax=av:GetBoundingBox()
local ay=aw.Position.Y+ax.Y*0.5 at.Board.StudsOffset=Vector3.new(0,ay-at.Part.
Position.Y+1.6,0)at.Lifted=true end local function Tint(at)return if at.Mutation
then ae.Mutations[at.Mutation]else nil end local function Hex(at)return string.
format('#%02X%02X%02X',math.floor(at.R*255),math.floor(at.G*255),math.floor(at.B
*255))end local function Show(at)if not Passes(at)then Drop(at.Key)return end
local au=at.Part if not au or not au.Parent then return end local av=as[at.Key]
or(Card(au))as[at.Key]=av local aw=at.Value local ax=string.format('<font color="#FFE600">%s</font>',ae.Rate(at.Income or 0))if ap.
Enabled and at.Mutation then ax..=string.format('  <font color="%s">%s</font>',
Hex(Tint(at)or aj.Sub),at.Mutation)end av.Labels[1].Text=at.Index av.Labels[1].TextColor3=Color3.fromRGB(255,40,40)av.Labels[2].Text=ax Lift(av,at)end local function Rank()
local at={}for au in as do local av=ac.Get(au)if av then at[#at+1]=av end end
table.sort(at,function(au,av)return(au.Value or 0)>(av.Value or 0)end)for au,av
in at do local aw=as[av.Key]local ax=ar.Value==0 or au<=ar.Value local ay=false aw.Board.Enabled=ax aw.Edge.Color=Tint(av)or(if au==1 then
al elseif ay then am else aj.Edge)aw.Edge.Thickness=if ay then 2 else 1 aw.Labels[1].TextColor3=Color3.fromRGB(255,40,40)Lift(aw,av)if ay then if aw.
Body and not aw.Glow then aw.Glow=ae.Highlight(aw.Body,if au==1 then al else am,
1)end if aw.Glow then aw.Glow.Adornee=aw.Body aw.Glow.OutlineColor=if au==1 then
al else am end elseif aw.Glow then aw.Glow:Destroy()aw.Glow=nil end end end
local function Rebuild()if not an.Enabled then return end for at in as do Drop(
at)end for at,au in ac.List do Show(au)end Rank()end local function Follow()for
at,au in as do local av=ac.Get(at)local aw=av and av.Part if not aw or not aw.
Parent then Drop(at)elseif au.Part~=aw then au.Part=aw au.Board.Adornee=aw au.
Body=nil end end Rank()end an=ab.Categories.Render:CreateModule{Name=
'BrainrotESP',Default=true,Tooltip='Shows brainrot⁠s through walls',Function=function(at)if
not at then return end an:Clean(function()for au in as do Drop(au)end end)for au
,av in ac.List do Show(av)end Rank()an:Clean(ac.Added:Connect(Show))an:Clean(ac.
Updated:Connect(Show))an:Clean(ac.Removed:Connect(function(au)Drop(au.Key)end))
an:Clean(ah(function()while ai(0.5)do Follow()end end))end}ao=an:CreateSlider{
Name='Min income',Tooltip='Minimum inc⁠ome to label',Min=20,Max=500,Default=20,
Suffix='M/s',Function=Rebuild}ap=an:CreateToggle{Function=Rebuild,Default=
true,Name='Show mutation'}aq=an:CreateToggle{Name='Hide carpet brainrots',Tooltip=
'Hides red carpet brainrots',Function=Rebuild}ar=an:CreateSlider{Default=
0,Function=Rebuild,Max=15,Tooltip='Only labels the best ones, 0 for all',Min=0,Name=
'Show best'}return an end function a.M()local aa=a.cache.M if not aa then
aa={c=__modImpl()}a.cache.M=aa end return aa.c end end 
 do local function __modImpl()
local aa=a.a()local ab=a.b()local ac=task.defer local ad=aa.Services.Lighting
local ae=Color3.new(1,1,1)local af={'Ambient','OutdoorAmbient','Brightness',
'GlobalShadows','ExposureCompensation','FogEnd',"FogStart"}local ah local ai
local aj={}local ak local function Atmosphere()return ad:FindFirstChildOfClass
'Atmosphere'end local function Capture()for al,am in af do aj[am]=(ad)[am]end
local al=Atmosphere()ak=al and al.Density end local function ClearFog()ad.FogEnd
=1e9 ad.FogStart=0 local al=Atmosphere()if al then al.Density=0 end end local 
function RestoreFog()ad.FogEnd=aj.FogEnd ad.FogStart=aj.FogStart local al=
Atmosphere()if al and ak then al.Density=ak end end local function Enforce()ad.
Ambient=ae ad.OutdoorAmbient=ae ad.Brightness=1 ad.GlobalShadows=false ad.
ExposureCompensation=0 if ai.Enabled then ClearFog()end end local function 
Restore()ad.Ambient=aj.Ambient ad.OutdoorAmbient=aj.OutdoorAmbient ad.Brightness
=aj.Brightness ad.GlobalShadows=aj.GlobalShadows ad.ExposureCompensation=aj.
ExposureCompensation RestoreFog()end ah=ab.Categories.Render:CreateModule{Name=
"Fullbright",Tooltip='Removes darkness and fog',Function=function(al)if not al
then return end Capture()Enforce()ah:Clean(Restore)for am,an in af do ah:Clean(
ad:GetPropertyChangedSignal(an):Connect(Enforce))end local am=Atmosphere()if am
then ah:Clean(am:GetPropertyChangedSignal'Density':Connect(Enforce))end ah:
Clean(ad.ChildAdded:Connect(function(an)if an:IsA'Atmosphere'then ac(Enforce)ah:
Clean(an:GetPropertyChangedSignal'Density':Connect(Enforce))end end))end}ai=ah:
CreateToggle{Name='No fog',Default=true,Tooltip='Removes distance fog',Function=
function(al)if not ah.Enabled then return end if al then ClearFog()else
RestoreFog()end end}return ah end function a.O()local aa=a.cache.O if not aa
then aa={c=__modImpl()}a.cache.O=aa end return aa.c end end do local function 
__modImpl()local aa=a.a()local ab=a.b()local ac=a.t()local ad=a.h()local ae=a.I(
)local af=a.f()local ah=math.floor local ai=string.format local aj=aa.Services.
RunService local ak=Color3.fromRGB(255,105,180)local al local am local an local ao={}local ap local aq=ae.Line()local function Clear()if an then an:Destroy()end
an,ap=nil,nil ae.Unpoint(aq)end local function Update()local ar=ac.Mine()local
as=ar and(ar.Model:FindFirstChild'DeliveryHitbox'or ar.Model:FindFirstChild
'MainRoot')if not as or not as:IsA'BasePart'then Clear()return end if as~=ap
then Clear()ap=as an,ao=ae.Card(as,Vector3.new(0,10,0),2,8)an.Enabled=false ao[1].Text=
'Your base'ao[1].TextColor3=af.Theme.Accent ao[2].TextColor3=af.Theme.Sub end
local at,au=ad.Character()ao[2].Text=if au then ai('%d studs',ah((as.Position-au
.Position).Magnitude))else''if am.Enabled then ae.Point(aq,au,as,ak)else ae.
Unpoint(aq)end end al=ab.Categories.Render:CreateModule{Name='HomeESP',Tooltip=
'Marks your base',Function=function(ar)if not ar then return end al:Clean(Clear)
local as=0 al:Clean(aj.Heartbeat:Connect(function(at)as+=at if 0.2<=as then as=0
Update()end end))end}am=al:CreateToggle{Name='Line to base',Default=true}return
al end function a.P()local aa=a.cache.P if not aa then aa={c=__modImpl()}a.cache
.P=aa end return aa.c end end do local function __modImpl()local aa=a.a()local
ab=a.b()local ac=a.f()local ad=a.B()local ae=a.h()local af=math.clamp local ah=
math.sin local ai=string.format local aj=UDim2.new local ak=UDim2.fromOffset
local al=aa.LocalPlayer local am=ac.Theme local an=ac.New local ao=100 local ap=
2.5 local aq local ar local as local at=an('Frame',{Name='IndicatorPopup',AnchorPoint=Vector2.new(0.5,0),Position=aj(0.5,0,0,ao),Size=ak(0,30),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=0,BackgroundColor3=Color3.fromRGB(14,14,18),Visible=false,ZIndex=50},ac.Overlay)ac.Corner(at,15)
ac.Place('Holding',at,at,aj(0.5,0,0,ao))
local au=an('UIStroke',{Thickness=1,Color=Color3.fromRGB(58,58,68)},at)
an('UIPadding',{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,14)},at)
an('UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,8),VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder},at)
local aw=an('Frame',{LayoutOrder=1,Size=ak(8,8),BackgroundTransparency=0,BackgroundColor3=Color3.fromRGB(150,150,160)},at)ac.Corner(aw,4)
local ax=an('TextLabel',{LayoutOrder=2,RichText=true,Size=ak(0,30),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Font=Enum.Font.GothamMedium,TextSize=13,TextColor3=Color3.fromRGB(235,235,240),TextXAlignment=Enum.TextXAlignment.Left,Text=''},at)
local aF=ac.Motion(0,380,14,function()end)
local _I,_S,_V=a.I(),a.s(),a.v()
local _lk,_rc,_rn=nil,nil,nil
local function Show(_dot,_txt)aw.BackgroundColor3=_dot if ax.Text~=_txt then ax.Text=_txt end at.Visible=true end
local function Banner(_x)if not _x then at.Visible=false end end
local function Seconds(aG)return if 0<aG then ai('%.1fs',aG)else''end
local aH=0
local function Update(aI)aH+=aI or 1 if aH<0.1 then return end aH=0
local aJ=al.Character local aK=aJ and aJ:FindFirstChildOfClass'Humanoid'local aL=ae.Carrying(al)local aM=ad.GummyLeft()
local _sub=ac.Hex(Color3.fromRGB(150,150,160))
if aK and ad.Ragdolled(aK)then local _t=Seconds(ad.RagdollLeft())Show(am.Bad,ai('Ragdolled%s',if _t~=''then' '.._t else''))
elseif al:GetAttribute'BlockTools'==true or aM>0 then local _t=Seconds(aM)Show(am.Warn,ai('Tools blocked%s',if _t~=''then' '.._t else''))
elseif aL then
local _mu,_inc for _,_e in _V.List do if _e.Steal==al.UserId then _mu,_inc=_e.Mutation,_e.Income if _e.Index==aL then break end end end
if _inc and _inc>0 then _rc=_I.Rate(_inc) elseif _rn~=aL then _rn=aL _rc=nil local _ok,_v=pcall(function()local _n=_S.Of(aL)if _n and _n>0 then return _I.Rate(_n)end end)if _ok and _v then _rc=_v end end
local _mt=if _mu and _mu~='Default'and _mu~='None'then ai(' <font color="%s">(%s)</font>',ac.Hex(_I.Mutations[_mu]or Color3.new(1,1,1)),_mu)else''
local _txt=if aL==''then'Holding'else ai('<font color="%s">Holding:</font> <b>%s</b>%s%s',_sub,aL,_mt,if _rc then ai(' <font color="%s">-</font> <font color="%s"><b>%s</b></font>',_sub,ac.Hex(am.Good),_rc)else'')
Show(Color3.fromRGB(70,100,255),_txt)
else Show(Color3.fromRGB(150,150,160),'Not Holding')end end
aq=ab.Categories.
Render:CreateModule{Name='Indicators',Early=true,Tooltip=
'Shows a banner while st⁠ealing or ragdolled',Function=function(aI)if as then as:
Disconnect()as=nil end if aI then Update()as=aa.Services.RunService.PreRender:
Connect(Update)else Banner(nil)ac.Go(aF,0)end end}ar=aq:CreateToggle{Tooltip='Removed: no arrow is shown anymore',Name='Pickup arrow',Default=false}aa.Clean(
function()if as then as:Disconnect()end end)return aq end function a.Q()local aa
=a.cache.Q if not aa then aa={c=__modImpl()}a.cache.Q=aa end return aa.c end end
do local function __modImpl()local aa=a.a()local ab=a.b()local ac=a.h()local ad=
string.find local ae=math.floor local af=math.ceil local ah=task.defer local ai=
task.delay local aj=task.spawn local ak=task.wait local al=task.cancel local am=
aa.Services.CollectionService local an=aa.Services.MaterialService local ao=aa.
Services.ReplicatedStorage local ap=aa.Services.RunService local aq=aa.Services.
Workspace local ar=aa.Services.Players local as=aa.LocalPlayer local at={
ParticleEmitter=true,Fire=true,Smoke=true,Sparkles=true}local au={
ParticleEmitter=true,Trail=true,Beam=true,Fire=true,Smoke=true,Sparkles=true}
local av local aw local ax={}local ay={}local az={}local aA local function Game(
aB)if aa.Lite then return nil end local aC=ao for aD,aE in aB do aC=aC:
WaitForChild(aE)end return aa.Require(aC,0)end local function Matches(aB,aC)
local aD,aE=pcall(aB.QueryDescendants,aB,aC)if aD then return aE end local aF={}
for aG in string.gmatch(aC,'%a+')do aF[aG]=true end local aG={}for aH,aI in aB:
GetDescendants()do if aF[aI.ClassName]then aG[#aG+1]=aI end end return aG end
local function Sweep(aB,aC,aD)local aE=os.clock()for aF,aG in Matches(aB,aC)do
aD(aG)if os.clock()-aE>0.002 then ap.Heartbeat:Wait()aE=os.clock()end end end
local function Watch(aB,aC)az[aB]=aC if next(az)==nil and aA then aA:Disconnect(
)aA=nil elseif next(az)~=nil and not aA then aA=aq.DescendantAdded:Connect(
function(aD)for aE,aF in az do aF(aD)end end)end end local function Brainrot(aB)
local aC=aB.Parent while aC and aC~=aq do if aC.Name=='RenderedMovingAnimals'or(
aC:IsA'Model'and(aC:GetAttribute'Index'~=nil or aC:GetAttribute
'__AssetDescendantCount'~=nil))then return true end aC=aC.Parent end return
false end local function StepCallbacks(aB,aC)local aD={}for aE,aF in
getconnections(aB)do local aG=aF.Function if aG and not isexecutorclosure(aG)and
ad(debug.info(aG,'s'),aC,1,true)then aD[#aD+1]=aG end end return aD end local aB
=(setmetatable({},{__mode='k'}))local function Freeze(aC)if aB[aC]==nil then aB[
aC]=aC.Speed end aC:AdjustWeight(0)aC:AdjustSpeed(0)end local function Thaw(aC)
aC:AdjustSpeed(aB[aC]or 1)aB[aC]=nil aC:AdjustWeight(1)end local function 
AnimatorFacet(aC,aD)local aE={}local function Mute(aF)if not aF:IsA'Animator'or
aE[aF]or not aD(aF)then return end for aG,aH in aF:GetPlayingAnimationTracks()do
Freeze(aH)end aE[aF]=aF.AnimationPlayed:Connect(Freeze)end local function On()
Watch(aC,function(aF)if aF:IsA'Animator'then ah(Mute,aF)end end)Sweep(aq,
'Animator',Mute)end local function Off()Watch(aC,nil)for aF,aG in aE do aG:
Disconnect()if aF.Parent then for aH,aI in aF:GetPlayingAnimationTracks()do
Thaw(aI)end end end table.clear(aE)end return On,Off end local aC,aD=
AnimatorFacet('brainrot animations',Brainrot)local aE,aF=AnimatorFacet(
'npc animations',function(aE)local aF=aE:FindFirstAncestorWhichIsA'Model'return
nil~=aF and not Brainrot(aE)and ar:GetPlayerFromCharacter(aF)==nil end)local aG=
{}local function Stub(aH,aI,aJ)if type(aH)=='table'and type(aH[aI])=='function'
then aG[#aG+1]={Target=aH,Key=aI,Original=aH[aI]}aH[aI]=aJ end end local 
function Unstub(aH)for aI=#aG,1,-1 do local aJ=aG[aI]if aJ.Target==aH then aJ.
Target[aJ.Key]=aJ.Original table.remove(aG,aI)end end end local function Delete(
aH)if at[aH.ClassName]and aH.Parent then aH:Destroy()end end local aH,aI,aJ
local function ParticlesOn()aH=aH or Game{'Shared','VFX'}aI=aI or Game{
'Controllers','EffectController'}aJ=aJ or Game{'Controllers',
'SkullEmojiEffectController'}Stub(aH,'emit',function()end)Stub(aH,'enable',
function()end)Stub(aI,'Run',function()return false,false end)Stub(aI,'Activate',
function()return false end)Stub(aJ,'Play',function(aK)if type(aK)=='table'then
aK._isPlaying=false end end)Watch('particles',function(aK)if at[aK.ClassName]
then ah(Delete,aK)end end)Sweep(aq,'ParticleEmitter, Fire, Smoke, Sparkles',
Delete)end local function ParticlesOff()Watch('particles',nil)Unstub(aH)Unstub(
aI)Unstub(aJ)end local aK=(setmetatable({},{__mode="k"}))local aL,aM local 
function MuteEffect(aN)if not au[aN.ClassName]or aK[aN]~=nil or not Brainrot(aN)
then return end local aO=aN aK[aN]=aO.Enabled aO.Enabled=false if aO.Clear then
aO:Clear()end end local function EffectsOn()aL=aL or Game{'Shared','Animals'}aM=
aM or Game{'Packages','Trove'}local function Empty()return aM.new()end if aM
then Stub(aL,'ApplyMutation',Empty)Stub(aL,"ApplyTraits",Empty)end Watch(
'brainrot effects',function(aN)if au[aN.ClassName]then ah(MuteEffect,aN)end end)
Sweep(aq,'ParticleEmitter, Trail, Beam, Fire, Smoke, Sparkles',MuteEffect)end
local function EffectsOff()Watch('brainrot effects',nil)Unstub(aL)for aN,aO in
aK do if aN.Parent then(aN).Enabled=aO end end table.clear(aK)end local function 
DropOverhead(aN)local aO=aN.Parent if(aN:IsA'SurfaceGui'or aN:IsA'BillboardGui')
and aO and aO.Name=="FastOverheadTemplate"then aN:Destroy()end end local 
function OverheadsOn()Watch('overheads',function(aN)ah(DropOverhead,aN)end)
Sweep(aq,'SurfaceGui, BillboardGui',DropOverhead)end local function OverheadsOff
()Watch('overheads',nil)end local aN=(setmetatable({},{__mode='k'}))local aO
local function HideViewport(aP)if aP:IsA'ViewportFrame'and aP.Visible then aN[aP
]=true aP.Visible=false end end local function ViewportsOn()local aP=as:
FindFirstChildOfClass'PlayerGui'if aP then aO=aP.DescendantAdded:Connect(
function(aQ)ah(HideViewport,aQ)end)Sweep(aP,'ViewportFrame',HideViewport)end
Watch('viewports',function(aQ)ah(HideViewport,aQ)end)Sweep(aq,'ViewportFrame',
HideViewport)end local function ViewportsOff()Watch('viewports',nil)if aO then
aO:Disconnect()aO=nil end for aP in aN do if aP.Parent then aP.Visible=true end
end table.clear(aN)end local aP=(setmetatable({},{__mode='k'}))local aQ=(
setmetatable({},{__mode='k'}))local aR local aS={'ColorMap','MetalnessMap',
'NormalMap','RoughnessMap'}local function HideTexture(aT)if(aT:IsA'Decal'or aT:
IsA'Texture')and aP[aT]==nil then local aU=aT aP[aT]=aU.Transparency aU.
Transparency=1 end end local function BlankVariant(aT)if not aT:IsA
'MaterialVariant'or aQ[aT]then return end local aU={}for aV,aW in aS do aU[aV]=(
aT)[aW];(aT)[aW]=''end aQ[aT]=aU end local function TexturesOn()for aT,aU in an:
GetChildren()do BlankVariant(aU)end aR=an.ChildAdded:Connect(function(aT)ah(
BlankVariant,aT)end)Watch('textures',function(aT)if aT:IsA'Decal'then ah(
HideTexture,aT)end end)Sweep(aq,'Decal, Texture',HideTexture)end local function 
TexturesOff()Watch('textures',nil)if aR then aR:Disconnect()aR=nil end for aT,aU
in aP do if aT.Parent then(aT).Transparency=aU end end for aT,aU in aQ do for aV
,aW in aS do(aT)[aW]=aU[aV]end end table.clear(aP)table.clear(aQ)end local aT=(
setmetatable({},{__mode='k'}))local function HideAccessory(aU)if not aU:IsA
'Accessory'then return end for aV,aW in aU:GetDescendants()do if aW:IsA
'BasePart'then aT[aW]=true aW.LocalTransparencyModifier=1 end end end local 
function AccessoriesOn()Watch('accessories',function(aU)if aU:IsA'Accessory'then
ah(HideAccessory,aU)end end)Sweep(aq,'Accessory',HideAccessory)end local 
function AccessoriesOff()Watch('accessories',nil)for aU in aT do if aU.Parent
then aU.LocalTransparencyModifier=0 end end table.clear(aT)end local aU local aV
local function GradientsOn()if not aU then for aW,aX in StepCallbacks(ap.
PreRender,'Packages.Gradients')do for aY,aZ in debug.getupvalues(aX)do if type(
aZ)=='table'and#aZ>0 and type(rawget(aZ,1))=='string'then aU=aZ break end end
end end if aU then aV=table.clone(aU)table.clear(aU)end end local function 
GradientsOff()if aU and aV then table.move(aV,1,#aV,1,aU)aV=nil end end local aW
=(setmetatable({},{__mode='k'}))local aX={}local function NoRecolor()end local 
function MuteTools()for aY,aZ in StepCallbacks(ap.RenderStepped,'.ColorScript')
do for a_,a0 in debug.getupvalues(aZ)do local a2=type(a0)=='table'and rawget(a0,
'Recolor')if type(a2)=='function'and a2~=NoRecolor then aW[a0]=a2 rawset(a0,
'Recolor',NoRecolor)end end end end local function ToolsOn()MuteTools()local 
function Later()ai(1,MuteTools)end aX[#aX+1]=as.CharacterAdded:Connect(Later)
local aY=as:FindFirstChildOfClass'Backpack'if aY then aX[#aX+1]=aY.ChildAdded:
Connect(Later)end end local function ToolsOff()for aY,aZ in aX do aZ:Disconnect(
)end table.clear(aX)for aY,aZ in aW do rawset(aY,'Recolor',aZ)end table.clear(aW
)end local function NewStore()return{Saved={},Trash={}}end local function Put(aY
,aZ,a_,a0)local a2=aZ[a_]if a2==a0 then return end local a4=aY.Saved[aZ]or{}aY.
Saved[aZ]=a4 if a4[a_]==nil then a4[a_]={a2}end aZ[a_]=a0 end local function Pin
(aY,aZ,a_,a0)Put(aY,aZ,a_,a0)aY.Trash[#aY.Trash+1]=aZ:GetPropertyChangedSignal(
a_):Connect(function()if aZ[a_]~=a0 and not aa.Owned[aZ]then aZ[a_]=a0 end end)
end local function Undo(aY)aa.Empty(aY.Trash)for aZ,a_ in aY.Saved do for a0,a2
in a_ do(aZ)[a0]=a2[1]end end table.clear(aY.Saved)end local function Outside(aY
)local aZ=aq:FindFirstChild'Plots'local a_=as.Character return not(aZ and aY:
IsDescendantOf(aZ))and not(a_ and aY:IsDescendantOf(a_))end local aY=NewStore()
local aZ={PointLight=true,SpotLight=true,SurfaceLight=true}local function 
DimLight(a_)if aZ[a_.ClassName]then Pin(aY,a_,'Enabled',false)end end local 
function LightsOn()Watch('lights',function(a_)if aZ[a_.ClassName]then ah(
DimLight,a_)end end)Sweep(aq,'PointLight, SpotLight, SurfaceLight',DimLight)end
local function LightsOff()Watch('lights',nil)Undo(aY)end local a_=NewStore()
local a0 local function Silence(a2)if aa.Owned[a2]then return end if a2:IsA
'Sound'then Put(a_,a2,'Volume',0)elseif a2:IsA'SoundEffect'then Put(a_,a2,
'Enabled',false)end end local function SoundsOn()local a2=aa.Services.
SoundService Put(a_,a2,'AmbientReverb',Enum.ReverbType.NoReverb)Watch('sounds',
function(a4)ah(Silence,a4)end)a0=a2.DescendantAdded:Connect(function(a4)ah(
Silence,a4)end)Sweep(aq,'Sound',Silence)Sweep(a2,'Sound',Silence)end local 
function SoundsOff()Watch('sounds',nil)if a0 then a0:Disconnect()a0=nil end
Undo(a_)end local a2=NewStore()local a4=Enum.Material.SmoothPlastic local 
function Flatten(a5)if not a5:IsA'BasePart'or a5:FindFirstChildWhichIsA(
'ProximityPrompt',true)or not Outside(a5)then return end if a5.Material~=a4 then
if a5.CustomPhysicalProperties==nil then Put(a2,a5,'CustomPhysicalProperties',
PhysicalProperties.new(a5.Material))end Put(a2,a5,'Material',a4)end Put(a2,a5,
'Reflectance',0)Put(a2,a5,'CastShadow',false)end local function MaterialsOn()
Watch('materials',function(a5)if a5:IsA'BasePart'then ah(Flatten,a5)end end)
Sweep(aq,'BasePart',Flatten)end local function MaterialsOff()Watch('materials',
nil)Undo(a2)end local a5=NewStore()local a6={}local a7 local a8={EnvironmentDiffuseScale=0,EnvironmentSpecularScale=0,FogEnd=1e9,ShadowSoftness=0,GlobalShadows=
false,FogStart=0}local function Heavy(a9)return a9:IsA'PostEffect'or
a9:IsA'Sky'or a9:IsA'Atmosphere'end local function LightingOn()local a9=aa.
Services.Lighting for b,ba in a8 do Pin(a5,a9,b,ba)end Pin(a5,a9,'Technology',
Enum.Technology.Compatibility)local function Quiet(b)if aa.Owned[b]then return
end if b:IsA'PostEffect'then Pin(a5,b,'Enabled',false)elseif Heavy(b)then a6[#a6
+1]=b b.Parent=nil end end for b,ba in a9:GetChildren()do Quiet(ba)end a7=a9.
ChildAdded:Connect(function(b)ah(Quiet,b)end)end local function LightingOff()if
a7 then a7:Disconnect()a7=nil end Undo(a5)for a9,b in a6 do b.Parent=aa.Services
.Lighting end table.clear(a6)end local a9=NewStore()local b local function 
TerrainOn()local ba=aq:FindFirstChildOfClass'Terrain'if not ba then return end
Put(a9,ba,'WaterWaveSize',0)Put(a9,ba,'WaterWaveSpeed',0)Put(a9,ba,
'WaterReflectance',0)Put(a9,ba,'WaterTransparency',1)if gethiddenproperty(ba,
'Decoration')==true then sethiddenproperty(ba,'Decoration',false)b=ba end end
local function TerrainOff()Undo(a9)if b then sethiddenproperty(b,'Decoration',
true)b=nil end end local ba=NewStore()local bb={}local bc local bd=48 local be=8
local function Grass()local bf={}local bg=aq:FindFirstChild"Map"if not bg then
return bf end for bh,bi in bg:GetChildren()do if bi:IsA'BasePart'and bi:HasTag
'Grass'then bf[#bf+1]=bi end end return bf end local function DigCells(bf)local
bg,bh for bi,bj in bf do local bk=bj.Size/2 bg=if bg then bg:Min(bj.Position-bk)
else bj.Position-bk bh=if bh then bh:Max(bj.Position+bk)else bj.Position+bk end
if not bg or not bh then return nil end return Region3int16.new(Vector3int16.
new(ae((bg.X-be)/4),ae((bh.Y-bd)/4),ae((bg.Z-be)/4)),Vector3int16.new(af((bh.X+
be)/4),af((bh.Y+be)/4),af((bh.Z+be)/4)))end local function DigClear()local bf=aq
.Terrain if bf:CountCells()==0 then return end local bg=Grass()local bh=
DigCells(bg)if not bh then return end local bi,bj=bh.Min,bh.Max bb[#bb+1]={
Region=bf:CopyRegion(bh),Corner=bi}bf:FillRegion(Region3.new(Vector3.new(bi.X,bi
.Y,bi.Z)*4,Vector3.new(bj.X+1,bj.Y+1,bj.Z+1)*4),4,Enum.Material.Air)if#ba.Trash>
0 then return end for bk,bl in bg do Pin(ba,bl,'Transparency',0)Pin(ba,bl,
'CanCollide',true)end end local function DigReset()aa.Empty(ba.Trash)table.
clear(ba.Saved)table.clear(bb)end local function DigOn()bc=aj(function()while
true do if ao:GetAttribute'DiggingTerrainReady'then DigClear()elseif#bb>0 then
DigReset()end ak(0.5)end end)end local function DigOff()if bc then al(bc)bc=nil
end if not ao:GetAttribute'DiggingTerrainReady'then DigReset()return end Undo(ba
)for bf,bg in bb do aq.Terrain:PasteRegion(bg.Region,bg.Corner,false)end table.
clear(bb)end local bf=NewStore()local function QualityOn()local bg=settings().
Rendering Put(bf,bg,'QualityLevel',Enum.QualityLevel.Level01)Put(bf,bg,
'MeshPartDetailLevel',Enum.MeshPartDetailLevel.Level04)end local function 
QualityOff()Undo(bf)end local bg={Ground=true,Ground_Left=true,Ground_Right=true
,Collisions=true,Borders=true,Cave=true,GenerationBoard=true,StealsBoard=true,
LiveBoard=true,Model=true,Model1=true}local bh={AdminBoard=true,SoccerScoreBoard
=true,CrystalSpinWheel=true,EclipseSpinWheel=true,Beehive=true,Road=true,
TradePlazaPortal=true,Present=true,StPatricksPot=true,RoadPanel=true,Honey=true,
Trap=true,Dev=true,CrystalMap=true,SpawnLocation=true,UFO=true,['Haunted Base']=
true}local bi={EventBoard=true,Events=true,RenderedMovingAnimals=true,Plots=true
}local bj={HumanoidRootPart=true,Head=true,Torso=true,UpperTorso=true,LowerTorso
=true,LeftUpperArm=true,LeftLowerArm=true,LeftHand=true,RightUpperArm=true,
RightLowerArm=true,RightHand=true,LeftUpperLeg=true,LeftLowerLeg=true,LeftFoot=
true,RightUpperLeg=true,RightLowerLeg=true,RightFoot=true,['Left Arm']=true,[
'Right Arm']=true,['Left Leg']=true,['Right Leg']=true}local bk={AnimationConstraint=true,Animator=true,Attachment=true,BallSocketConstraint=true,Humanoid=true,Weld=true,WeldConstraint=true,Motor6D=true}local bl={}local 
function Interactive(bm)return bm:FindFirstChildWhichIsA('ProximityPrompt',true)
~=nil end local function Uuid(bm)return#bm==36 and ad(bm,
'^%x+%-%x+%-%x+%-%x+%-%x+$')~=nil end local function Strippable(bm)local bn=bm.
Name if bi[bn]or Interactive(bm)or(bm:IsA'Model'and ar:GetPlayerFromCharacter(bm
)~=nil)then return false end return bh[bn]or string.sub(bn,1,7)=='BeeHive'or(bm:
IsA'Model'and ad(bn,"'s Rainbow",1,true)~=nil)or(Uuid(bn)and bm:GetAttribute
'Index'==nil and bm:GetAttribute'__AssetDescendantCount'==nil)end local function 
StripTop(bm)if bm.Name=='Map'then for bn,bo in bm:GetChildren()do if not bg[bo.
Name]and not Interactive(bo)then bo:Destroy()end end bl[#bl+1]=bm.ChildAdded:
Connect(function(bn)ah(function()if bn.Parent and not bg[bn.Name]and not
Interactive(bn)then bn:Destroy()end end)end)elseif Strippable(bm)then bm:
Destroy()end end local function Bare(bm,bn)local bo=bm.ClassName if bo==
'WrapTarget'or bo=='WrapLayer'or bo=='NoCollisionConstraint'or bm.Name==
'__HITBOX'then return true end if bk[bo]or bj[bm.Name]then return false end
local bp=bm while bp and bp~=bn do if bp:IsA"Model"then return false end bp=bp.
Parent end return true end local function StripCharacter(bm)local bn=bm.
Character if bm.Local or not bn then return end for bo,bp in bn:GetDescendants()
do if Bare(bp,bn)then bp:Destroy()end end bl[#bl+1]=bn.DescendantAdded:Connect(
function(bo)ah(function()if bo.Parent and Bare(bo,bn)then bo:Destroy()end end)
end)end local function StripOn()for bm,bn in aq:GetChildren()do StripTop(bn)end
bl[#bl+1]=aq.ChildAdded:Connect(function(bm)ah(StripTop,bm)end)local bm=aq.
CurrentCamera for bn,bo in bm:GetChildren()do if(bo:IsA'ColorCorrectionEffect'or
bo:IsA'BlurEffect')and not aa.Owned[bo]then bo:Destroy()end end for bn,bo in ac.
List do StripCharacter(bo)end bl[#bl+1]=ac.CharacterAdded:Connect(StripCharacter
)end local function StripOff()aa.Empty(bl)end local bm=false local bn=false
local function Refresh()if bm then bn=true return end bm=true av.Settling=true
aj(function()repeat bn=false for bo,bp in ax do local bq=av.Enabled and(not bp.
Max or aw.Value=='Max')if(ay[bp]or false)~=bq then ay[bp]=bq local br,bs=pcall(
if bq then bp.On else bp.Off)ap.Heartbeat:Wait()if not br then warn(
'optimizer step failed:',bs)end end end until not bn bm=false av.Settling=false
end)end av=ab.Categories.Render:CreateModule{Name='Optimizer',Tooltip=
'Turns off laggy effects',Function=function(bo)if not bo then return end av:
Clean(function()for bp,bq in ax do if ay[bq]then bq.Off()end end table.clear(ay)
end)Refresh()end}local function Facet(bo,bp,bq)ax[#ax+1]={Max=bo,On=bp,Off=bq}
end Facet(false,ParticlesOn,ParticlesOff)Facet(false,EffectsOn,EffectsOff)Facet(
false,aC,aD)Facet(false,aE,aF)Facet(false,ViewportsOn,ViewportsOff)Facet(false,
GradientsOn,GradientsOff)Facet(false,ToolsOn,ToolsOff)Facet(false,LightsOn,
LightsOff)Facet(false,SoundsOn,SoundsOff)Facet(false,MaterialsOn,MaterialsOff)
Facet(false,LightingOn,LightingOff)Facet(false,TerrainOn,TerrainOff)Facet(false,
DigOn,DigOff)Facet(false,QualityOn,QualityOff)Facet(false,StripOn,StripOff)
Facet(true,OverheadsOn,OverheadsOff)Facet(true,TexturesOn,TexturesOff)Facet(true
,AccessoriesOn,AccessoriesOff)aw={Value='Max'}return av end function a.R()local aa=a.cache.R if not aa then aa={c=
__modImpl()}a.cache.R=aa end return aa.c end end do local function __modImpl()
local aa=a.a()local ab=a.b()local ac=a.h()local ad=a.I()local ae=math.floor
local af=string.format local ah=aa.Services.RunService local ai=aa.Services.
Workspace local aj=Color3.new(1,1,1)local ak=Color3.fromRGB(255,205,60
)local al local am local an local ao local ap local aq={}local function Drop(ar)
local as=aq[ar]if not as then return end aq[ar]=nil as.Glow:Destroy()as.Board:
Destroy()end local function Build(ar)if ar.Local or aq[ar.Player]then return end
local as,at=ad.Billboard(nil,Vector3.new(0,2.6,0),2)aq[ar.Player]={Glow=ad.
Highlight(nil,aj,an.Value/100),Board=as,Labels=at}end local function Hide(ar)ar.
Glow.Adornee=nil ar.Board.Enabled=false end local function Refresh()local ar=ai.
CurrentCamera local as=ar and ar.CFrame.Position for at,au in aq do local av=ac.
Get(at)local aw=av and av.Character local ax=av and av.Root local ay=av and av.
Humanoid if not aw or not ax or not ax.Parent or not ay or ay.Health<=0 then
Hide(au)continue end local az=if as then(as-ax.Position).Magnitude else 0 if az>
am.Value then Hide(au)continue end local aA=ac.Carrying(at)local aC=if aA
then ak else aj au.Glow.Adornee=aw au.Glow.FillColor=aC au.Glow.OutlineColor=aC
au.Glow.FillTransparency=an.Value/100 au.Board.Adornee=aw:FindFirstChild'Head'or
ax au.Board.Enabled=true local aD=at.DisplayName if ao.Enabled then aD..=af(
'  [%d]',ae(0.5+az))end au.Labels[1].Text=aD au.Labels[1].TextColor3=aC local aE
=ac.Holding(at)local aF=if aA then'stealing '..(if aA~=''then aA else
'a brainrot')elseif ap.Enabled and aE then aE.Name else''au.Labels[2].Text=aF au
.Labels[2].TextColor3=aC end end al=ab.Categories.Render:CreateModule{Name=
"PlayerESP",Tooltip='Shows players through walls',Function=function(ar)if not ar
then return end al:Clean(function()for as in aq do Drop(as)end end)for as,at in
ac.List do Build(at)end al:Clean(ac.Added:Connect(Build))al:Clean(ac.Removed:
Connect(function(as)Drop(as.Player)end))local as=0 al:Clean(ah.Heartbeat:
Connect(function(at)as+=at if as>=0.2 then as=0 Refresh()end end))end}am={Value=800}an={Value=40}ao={Enabled=false}ap={Enabled=true}return al end function a.S()local aa=a.cache.S if not aa then aa={c=__modImpl()}
a.cache.S=aa end return aa.c end end do local function __modImpl()local aa=a.a()
local ab=a.b()local ac=a.h()local ad=a.D()local ae=a.I()local af=aa.Services.
RunService local ah={SON=true,FMLY=true}local ai local aj={}local function Drop(
ak)local al=aj[ak]if al then aj[ak]=nil al.Board:Destroy()end end local function 
Refresh()for ak,al in ac.List do if al.Local then continue end local am={}for an
,ao in ad.Tags(ak,false)do if ah[ao.Text]then local ap=ao.Color am[#am+1]=string
.format('<font color="#%s">%s</font>',ap:ToHex(),ao.Text)end end local an=al.
Character and al.Character:FindFirstChild'Head'if#am==0 or not an then Drop(ak)
continue end local ao=aj[ak]if not ao then local ap,aq=ae.Billboard(an,Vector3.
new(0,2.2,0),1)aq[1].RichText=true ao={Board=ap,Label=aq[1]}aj[ak]=ao end ao.
Board.Adornee=an ao.Label.Text=table.concat(am,'  ')end for ak in aj do if not
ac.List[ak]then Drop(ak)end end end ai=ab.Categories.Render:CreateModule{Name='Fmly and Son Tags',Was='RosterTags',Tooltip='Tags SON and FM⁠LY players',Function=function(ak)if not ak
then return end ai:Clean(function()for al in aj do Drop(al)end end)if not ad.
Loaded then ai:Clean(task.spawn(ad.Load))end local al=0 ai:Clean(af.Heartbeat:
Connect(function(am)al+=am if al>=0.5 then al=0 Refresh()end end))end}return ai
end function a.T()local aa=a.cache.T if not aa then aa={c=__modImpl()}a.cache.T=
aa end return aa.c end end 
 do local function __modImpl()local aa=a.a()local ab=a.b()local ac=a
.t()local ad=aa.Services.Workspace local ae={Decorations=true,Skin=true}local af
=Color3.fromHSV(0.6,1,1)local ah local ai local aj local ak={}local al={}local
am local an=false local ao={}local function Wanted(ap)return ae[ap]==true or(ap
=='Laser'and aj.Enabled)end local function Trapped(ap)local aq=ap.Parent return
ap.Name=='structure base home'and aq~=nil and aq.Name=='CashPad'end local 
function PlotOf(ap,aq)local ar=ap.Parent while ar and ar.Parent do local as=ar.
Parent if as.Parent==aq then return if Wanted(ar.Name)then as.Name else nil end
ar=as end return nil end local function StyleOf(ap)local aq=ac.List[ap]return if
aq and aq.Mine then ak else al end local function Apply(ap,aq)local ar=StyleOf(
aq.Plot)ap.LocalTransparencyModifier=ar.Amount.Value local as=if ar.Tint.Enabled
then ar.Color.Value else nil if not as and not aq.Tinted then return end ap.
Color=as or aq.Color if aq.Texture then(ap).TextureID=if as then''else aq.
Texture end aq.Tinted=as~=nil end local function Restore(ap,aq)ap.
LocalTransparencyModifier=0 if not aq.Tinted then return end ap.Color=aq.Color
if aq.Texture then(ap).TextureID=aq.Texture end end local function Paint(ap,aq)
if Trapped(ap)then return end local ar=ao[ap]if not ar then local as=if ap:IsA
'MeshPart'and ap.TextureID~=''then ap.TextureID else nil ar={Plot=aq,Color=ap.
Color,Texture=as,Tinted=false}ao[ap]=ar end Apply(ap,ar)end local function Sweep
(ap)for aq,ar in ap:GetChildren()do for as,at in ar:GetChildren()do if not
Wanted(at.Name)then continue end for au,av in at:GetDescendants()do if av:IsA
'BasePart'then Paint(av,ar.Name)end end end end end local function Unpaint()for
ap,aq in ao do Restore(ap,aq)end table.clear(ao)end local function Reapply()if
not ah.Enabled then return end for ap,aq in ao do Apply(ap,aq)end end local 
function Reveal()if not an then return end for ap,aq in{{al,'Other bases'}}do local ar,as=aq[1],true ar.Amount:SetVisible(as)ar.
Tint:SetVisible(as)ar.Color:SetVisible(as and ar.Tint.Enabled)end end local 
function Group(ap,aq)ap.Amount=ah:CreateSlider{Name=aq..' transparency',Min=0,
Max=1,Default=0.7,Step=0.05,Function=Reapply}ap.Tint=ah:CreateToggle{Name=
'Color '..string.lower(aq),Function=function()Reveal()Reapply()end}ap.Color=ah:
CreateColor{Name=aq..' color',Default=af,Function=Reapply}end ah=ab.Categories.
Render:CreateModule{Name='Xray',Tooltip='Makes bases see-through',Function=
function(ap)if not ap then return end ah:Clean(Unpaint)ah:Clean(ac.OwnerChanged:
Connect(Reapply))local aq=ad:WaitForChild'Plots'am=aq ah:Clean(aq.
DescendantAdded:Connect(function(ar)if not ar:IsA'BasePart'then return end local
as=PlotOf(ar,aq)if as then Paint(ar,as)end end))ah:Clean(aq.DescendantRemoving:
Connect(function(ar)ao[ar]=nil end))Sweep(aq)end}ai={Value='Other bases'}ak.Amount={Value=0.75}ak.Tint={Enabled=true}ak.Color={Value=Color3.fromRGB(160,25,153)}Group(al,'Other bases')aj={Enabled=true}an=true Reveal()return ah end function a.V
()local aa=a.cache.V if not aa then aa={c=__modImpl()}a.cache.V=aa end return aa
.c end end do local function __modImpl()local aa=a.a()local ab=a.b()local ac
local ad=ab.Categories.Settings:CreateModule{Name='Menu',Tooltip=
'Opens and closes the menu',Bind=Enum.KeyCode.RightShift,Unblocked=true,Fresh=
true,Function=function(ad)aa.Menu.Toggle(ad)end}ac=ad:CreateToggle{Name='Start with menu closed',Default=true,Tooltip='Starts with th⁠e menu hidden'}local function 
Plain(ae,af,ah)ad:CreateToggle{Name=ae,Tooltip=ah,Function=function(ai)if aa.
Settings[af]==ai then return end aa.Settings[af]=ai aa.Save()aa.Menu.Notify(
'Menu','Reinject to apply this','Info',3)end}end Plain('Remove menu animations',
'MenuNoAnimations','Everything snaps instead of animating')Plain(
'Remove menu gradients','MenuNoGradients','Flat colours instead of gradients')
Plain('Remove menu rounding','MenuNoRounding','Square corners everywhere')local
ae ad:CreateColor{Name='Accent',Default=Color3.fromHex(aa.Settings.MenuAccent),
Tooltip='Menu highli⁠ght colour',Function=function(af)aa.Settings.MenuAccent=af:
ToHex()aa.Save()if ae then task.cancel(ae)end ae=task.delay(0.6,function()ae=nil
aa.Menu.Notify('Menu','Reinject to apply this','Info',3)end)end}aa.Settings.MenuBarSide='Left' aa.Menu.Window.SetSide('Left')if true then local af=aa.Menu.Window aa.Menu.Toggle(false)aa.Menu.Snap(af.Open,0)af.
Frame.Visible=false else ad.Enabled=true end return ad end function a.W()local
aa=a.cache.W if not aa then aa={c=__modImpl()}a.cache.W=aa end return aa.c end
end do local function __modImpl()local aa=a.a()local ab=a.b()local ac=a.u()local
ad=math.floor local ae=math.clamp local af=math.abs local ah=string.format local
ai=string.lower local aj=string.upper local ak=string.find local al=UDim2.new
local am=UDim2.fromOffset local an=UDim2.fromScale local ao=Vector2.new local ap
=aa.Services.ReplicatedStorage local aq=aa.Menu local ar=aq.Theme local as=aq.
New local at=aq.Fonts local au=Enum.TextXAlignment.Left local av=ar.Window:Lerp(
ar.Accent,0.22)local aw,ax,ay=26,2,9 local az={['Brainrot God']='#ffb65a',Secret
='#f0eef4',OG='#ffc850'}local function Data(aA)return aa.Require(ap:WaitForChild
'Datas':WaitForChild(aA))end local function Make(aA,aB,aC,aD,aE)return{Key=aA,
Name=aB,Search=ai(aB),Tag=aC,Color=aD,Default=aE}end local aA={{Title=
'Brainrots',Noun='brainrot',Money=true,Store=ac.Overrides.Brainrots,Listed=
function(aA)return ac.Base[aA.Key]~=nil end,Load=function()local aA,aB=Data
'Animals',Data'Rarities'local aC={}local aD={}for aE,aF in aA do if type(aE)~=
'string'or type(aF)~='table'or aF.LuckyBlock or aF.Egg then continue end local
aG=aF.Rarity or'Common'local aH=aB[aG]local aI=az[aG]or(if aH and typeof(aH.
Color)=='Color3'then aq.Hex(aH.Color)else aq.Hex(ar.Sub))local aJ=Make(aE,aF.
DisplayName or aE,aj(aG),aI,ac.Base[aE]or 0)aJ.Gen=tonumber(aF.Generation)or 0 aJ.Gradient=aH and aH.GradientPreset
aD[aJ]=tonumber(aF.Generation)or 0 aC[#aC+1]=aJ end table.sort(aC,function(aE,aF
)if aD[aE]~=aD[aF]then return aD[aE]>aD[aF]end return aE.Name<aF.Name end)return
aC end},{Title='Mutations',Noun='mutation',Money=false,Store=ac.Overrides.
Mutations,Listed=function(aA)return ac.Mutations[aA.Key]~=nil end,Load=function(
)local aA={}for aB in Data'Mutations'do if type(aB)=="string"then local aC=ac.
Key(aB)aA[#aA+1]=Make(aC,aB,'',aq.Hex(ar.Accent),ac.Mutations[aC]or 1)end end
table.sort(aA,function(aB,aC)return aB.Name<aC.Name end)return aA end},{Title=
'Traits',Noun='trait',Money=false,Store=ac.Overrides.Traits,Listed=function()
return true end,Load=function()local aA={}for aB,aC in Data'Traits'do if type(aB
)=='string'and type(aC)=='table'then local aD=if typeof(aC.Color)=='Color3'then
aq.Hex(aC.Color)else aq.Hex(ar.Sub)aA[#aA+1]=Make(aB,aC.Display or aB,'',aD,if
aB=='Sleepy'then 0.5 else 1)end end table.sort(aA,function(aB,aC)return aB.Name<
aC.Name end)return aA end}}local aB=#aA+1 local aC={}for aD,aE in aA do aC[aD]=
aE.Title end aC[aB]='Settings'local function Entries(aD)if not aD.Entries then
local aE=aD.Load()local aF={}for aG,aH in aE do aF[aH.Key]=aH end aD.Entries,aD.
ByKey=aE,aF end return aD.Entries,aD.ByKey end local function Number(aD)if aD==
ad(aD)then return ah('%d',aD)end return(string.gsub(ah("%.3f",aD),'%.?0+$',''))
end local function Show(aD,aE)return(if aD.Money then'$'else'x')..Number(aE)end
local aD={Rainbow=function(aD,aE)return aq.Hex(Color3.fromHSV(((aD-1)/math.max(
aE,1))%1,0.550000000537,1))end,Zebra=function(aD,aE)local aF=math.sin(math.pi*(aD-1)/math.
max(aE-1,1))return aq.Hex(Color3.fromRGB(245,244,248):Lerp(Color3.fromRGB(150,
146,160),aF))end,GreenRed=function(aD)return if aD%2==1 then'#6fd27a'else
'#ff7a7a'end}local aE={}local function Tag(aF)local aG=aF.Gradient local aH=aG
and aD[aG]if not aG or not aH then return ah(
'<font size="9" color="%s" weight="semibold">%s</font>',aF.Color,aF.Tag)end
local aI=aG..'|'..aF.Tag local aJ=aE[aI]if aJ then return aJ end local aK={}
local aL=#aF.Tag for aM=1,aL do local aN=string.sub(aF.Tag,aM,aM)aK[aM]=if aN==
' 'then' 'else ah('<font color="%s">%s</font>',aH(aM,aL),aN)end local aM=ah(
'<font size="9" weight="semibold">%s</font>',table.concat(aK))aE[aI]=aM return
aM end local function Label(aF,aG)if aF.Tag==''then return aF.Name end return aF
.Name..aG..Tag(aF)end local aF local function Switch(aG,aH,aI,aJ)local aK=as(
'TextButton',{Name=aH,Size=al(1,-6,0,52),BackgroundColor3=ar.Edge},aG)aq.Corner(
aK,6)as('TextLabel',{RichText=true,Position=am(12,0),Size=al(1,-70,1,0),TextSize
=11,TextColor3=ar.Sub,TextWrapped=true,Text=ah(
'<font size="13" color="%s" weight="semibold">%s</font>\n%s',aq.Hex(ar.Text),aH,
aI)},aK)local aL=as('Frame',{AnchorPoint=ao(1,0.5),Position=al(1,-12,0.5,0),Size
=am(36,20),BackgroundColor3=ar.Off},aK)aq.Corner(aL)local aM=as('Frame',{
AnchorPoint=ao(0.5,0.5),Size=am(16,16),BackgroundColor3=ar.Knob},aL)aq.Corner(aM
)local aN=ac.Settings local aO=aq.Motion(if aN[aJ]then 1 else 0,400,30,function(
aO)aM.Position=al(0,10+16*aO,0.5,0)aL.BackgroundColor3=ar.Off:Lerp(ar.Accent,ae(
aO,0,1))end)aK.Activated:Connect(function()aN[aJ]=not aN[aJ]aa.Save()aq.Fade(aO,
aN[aJ]==true)end)end local function Build(aG)local aH=aG.Frame local aI=1 local
aJ=''aq.Padding(aH,14,14,10,14)local aK=as('Frame',{Name='Header',Size=al(1,0,0,112),BackgroundTransparency=1},aH)local aL=as("TextButton",{Name='Back',Visible=false,AnchorPoint=ao(0,0.5),Position=an(0,0.5),Size=am(28,28),BackgroundTransparency=1
},aK)local aM=aq.Icon('Back',{AnchorPoint=ao(0.5,0.5),Position=an(0.5,0.5),Size=
am(18,18),ImageColor3=ar.Sub},aL)local aN=aq.Motion(0,400,40,function(aN)aM.
ImageColor3=ar.Sub:Lerp(ar.Text,aN)end)aL.MouseEnter:Connect(function()aq.Fade(
aN,true)end)aL.MouseLeave:Connect(function()aq.Fade(aN,false)end)aL.Activated:
Connect(function()for aO,aP in aq.Pages do if aP.Name=='Settings'then aq.Select(
aP)end end end)local aO=as('Frame',{Name='Lists',Position=am(0,0),Size=am(206,112),BackgroundTransparency=1},aK)aq.Corner(aO)aq.Padding(aO,3,3)local aP=as(
'Frame',{Name='Indicator',Visible=false,Size=an(1,1/aB),BackgroundColor3=av},aO)aq.Corner(aP)
aq.Shadow(aP,6,0.700000000958)local aQ=aq.Motion(0,450,24,function(aQ)aP.Position=an(0,aQ/aB)end)local aR=as('TextLabel',{Name='Count',AnchorPoint=ao(1,0.5),Position=al(1,
0,0,52),Size=am(120,16),TextSize=12,TextColor3=ar.Faint,TextXAlignment=Enum.
TextXAlignment.Right},aH)local aS=as('TextBox',{Name='Search',Position=am(0,120),Size=al(1,0,0,28),BackgroundColor3=ar.Edge,TextSize=12,TextXAlignment=au,
PlaceholderText='Search',Text=''},aH)aq.Corner(aS)aq.Padding(aS,0,12,0,32)aq.
Icon("Search",{AnchorPoint=ao(0,0.5),Position=al(0,-20,0.5,0),Size=am(13,13),
ImageColor3=ar.Faint},aS)local aT=as('TextButton',{Name='Add',AnchorPoint=ao(1,0.5),Position=al(1,0,0,168),Size=am(150,28),BackgroundColor3=ar.Accent,FontFace=at.SemiBold,TextSize=12,TextColor3=ar.Ink},aH)aq.Corner(aT)local aU=as(
'TextButton',{Name='Reset',AnchorPoint=ao(1,0.5),Position=al(1,0,0.5,0),Size=am(
110,28),BackgroundTransparency=1,FontFace=at.SemiBold,TextSize=12,TextColor3=ar.
Sub,Text='Reset',Visible=false},aK)aq.Corner(aU)aq.Stroke(aU,ar.Mute)local aV=
as('Frame',{Name='Viewport',Position=am(0,192),Size=al(1,0,1,-192),BackgroundTransparency=1,ClipsDescendants=true},aH)local aW={}local function 
Sheet(aX)local aY=aW[aX]if aY then return aY end local aZ=as('ScrollingFrame',{
Name='List',Size=an(1,1),ScrollBarThickness=2,ScrollBarImageColor3=ar.Edge},aV)
local a_={Grid=aZ,Cards={}}if aX==aB then aq.List(aZ,6)Switch(aZ,
'1 of 1 priority',
[[Puts brainrots the game marks as 1 OF 1 above everything else]],
'OneOfOneFirst')else a_.Layout=as('UIGridLayout',{SortOrder=Enum.SortOrder.
LayoutOrder,CellSize=al(1,-6,0,42),CellPadding=am(6,6)},aZ)end aq.Padding(aZ,0
,6,0,0)a_.Slide=aq.Motion(0,200,28,function(a0)aZ.Position=am(a0,0)aZ.Visible=aX
==aI or af(a0)<aV.AbsoluteSize.X-0.5 end)aW[aX]=a_ return a_ end local aX local _Move local _PosSet local function Card(aY)local aZ=Sheet(aI)local a_=aZ.Cards local a0=a_[aY]if a0 then
return a0 end local a2=as('Frame',{Name='Row',LayoutOrder=aY,BackgroundColor3=ar
.Edge,BackgroundTransparency=0.550000000843},aZ.Grid)aq.Corner(a2,6)local a4=as(
"TextLabel",{Name='Label',RichText=true,Position=am(12,0),Size=al(1,-120,1,0),
FontFace=at.SemiBold,TextSize=13,LineHeight=1.1,TextTruncate=Enum.TextTruncate.
AtEnd},a2)local a5=as('TextBox',{Name='Value',AnchorPoint=ao(1,0.5),Position=al(
1,-34,0.5,0),Size=am(70,24),BackgroundColor3=ar.Edge,TextSize=12,TextXAlignment=
Enum.TextXAlignment.Center},a2)aq.Corner(a5,6)local a6=as('TextButton',{Name=
'Remove',AnchorPoint=ao(1,0.5),Position=al(1,-8,0.5,0),Size=am(20,20),
BackgroundTransparency=1,Text='\u{d7}',TextSize=18,TextColor3=ar.Faint},a2)local _up=as('TextButton',{Name='Up',AnchorPoint=ao(1,0.5),Size=am(22,22),BackgroundColor3=ar.Edge,Text='\u{25B2}',TextSize=11,TextColor3=ar.Text,Visible=false},a2)aq.Corner(_up,6)local _dn=as('TextButton',{Name='Down',AnchorPoint=ao(1,0.5),Size=am(22,22),BackgroundColor3=ar.Edge,Text='\u{25BC}',TextSize=11,TextColor3=ar.Text,Visible=false},a2)aq.Corner(_dn,6)
local _pb=as('TextBox',{Name='Rank',AnchorPoint=ao(0,0.5),Position=al(0,8,0.5,0),Size=am(34,22),BackgroundColor3=ar.Edge,TextSize=12,TextColor3=ar.Text,TextXAlignment=Enum.TextXAlignment.Center,ClearTextOnFocus=true,Visible=false},a2)aq.Corner(_pb,6)
local a7={Frame=a2,Text=a4,Value=a5,Remove=a6,Item=nil,Up=_up,Dn=_dn,Pos=_pb}
_pb.FocusLost:Connect(function()if _PosSet then _PosSet(a7,_pb)end end)_up.Activated:Connect(function()_Move(a7,-1)end)_dn.Activated:Connect(function()_Move(a7,1)end)a5.FocusLost:Connect(function()
local a8=aA[aI]local a9=a7.Item local b=tonumber((string.gsub(a5.Text,'[^%d%.]',
"")))if b then(a8.Store)[a9.Key]=if a8.Listed(a9)and b==a9.Default then nil else
b aa.Save()end aX()end)local a8=aA[aI]a6.Activated:Connect(function()local _it=a7.Item a8.Store[_it.Key]=if a8.Money and a8.Listed(_it)then 0 else nil aa.Save()aX()end)a_[aY]=a7 return a7 end local aY={}aX=function()
if aI==aB then return end local aZ=aA[aI]local a_,a0=Entries(aZ)table.clear(aY)
local a2=0 local function Consider(a4)if aJ==''or ak(a4.Search,aJ,1,true)then aY
[#aY+1]={Item=a4,Value=aZ.Store[a4.Key]or a4.Default}end end for a4,a5 in a_ do if(aZ.Listed(a5)or aZ.Store[a5.Key]~=nil)and not(aZ.Money and aZ.Store[a5.Key]==0)then Consider(a5)end end for a4,a5 in aZ.Store do a2+=1 if not a0[a4]and not(aZ.Money and a5==0)then Consider(Make(a4,a4,if aZ.Money then
'UNKNOWN'else'',aq.Hex(ar.Sub),a5))end end table.sort(aY,function(a4,a5)if a4.
Value~=a5.Value then return a4.Value>a5.Value end return a4.Item.Name<a5.Item.
Name end)local a4=math.ceil(#aY/2)for a5,a6 in aY do local a7=Card(a5)local a8=
a5-1 a7.Frame.LayoutOrder=a8 local a9=aZ.Store[a6.Item.Key]~=nil
a7.Item=a6.Item a7.Text.Text=Label(a6.Item,'\n')a7.Value.Text=Show(aZ,a6.Value)
a7.Value.TextColor3=if a9 then ar.Accent else ar.Text a7.Remove.Visible=a9 or aZ.Money==true a7.Value.Position=al(1,if a9 then-34 else-10,0.500000000844,0)local _mn=aZ.Money==true a7.Value.Visible=not _mn a7.Up.Visible=_mn a7.Dn.Visible=_mn if _mn then local _bx=-34 a7.Dn.Position=al(1,_bx,0.5,0)a7.Up.Position=al(1,_bx-26,0.5,0)a7.Text.Text=Label(a6.Item,'\n')a7.Pos.Visible=true if not a7.Pos:IsFocused()then a7.Pos.Text=tostring(a5)end a7.Text.Position=am(48,0)a7.Text.Size=al(1,-142,1,0)else a7.Pos.Visible=false a7.Text.Position=am(12,0)a7.Text.Size=al(1,-120,1,0)end a7.Item=a6.Item a7.Frame.Visible=true end local
a5=Sheet(aI)for a6=#aY+1,#a5.Cards do a5.Cards[a6].Frame.Visible=false end aR.Text=ah('%d changed',a2)aT.Visible=aI==1 aU.Visible=aI~=1 and a2>0 end
_PosSet=function(a7,_pb)local _p=tonumber((string.gsub(_pb.Text,'[^%d]','')))local _s=aA[aI]local _k for _i,_e in aY do if _e.Item==a7.Item then _k=_i break end end if not _p or not _k then aX()return end local _o={}for _i,_e in aY do if _i~=_k then _o[#_o+1]=_e end end _p=math.clamp(_p,1,#_o+1)if _p==_k then aX()return end local _v if #_o==0 then _v=aY[_k].Value elseif _p==1 then _v=_o[1].Value+math.max(1,math.abs(_o[1].Value)*0.001)elseif _p>#_o then _v=math.max(_o[#_o].Value/2,0.0001)else local _hi,_lo=_o[_p-1].Value,_o[_p].Value if _hi==_lo then _hi=_lo+math.max(0.001,math.abs(_lo)*0.001)_s.Store[_o[_p-1].Item.Key]=_hi end _v=(_hi+_lo)/2 end _s.Store[a7.Item.Key]=_v aa.Save()aX()end
_Move=function(_cd,_dir)local _s=aA[aI]local _k=nil for _i,_e in aY do if _e.Item==_cd.Item then _k=_i break end end if not _k then return end local _o=aY[_k+_dir]if not _o then return end local _a=aY[_k]local _ka,_kb=_a.Item.Key,_o.Item.Key local _va=_s.Store[_ka]or _a.Value local _vb=_s.Store[_kb]or _o.Value if _va==_vb then local _n=_vb+math.max(1,math.abs(_vb)*0.001)if _dir<0 then _s.Store[_ka]=_n else _s.Store[_kb]=_n end else _s.Store[_ka]=_vb _s.Store[_kb]=_va end aa.Save()aX()end local aZ=
aq.Popup(250,'AddWindow')aq.Padding(aZ,6,6)aq.List(aZ,ax)local a_=as('TextBox',{
Name='Search',LayoutOrder=1,Size=al(1,0,0,28),BackgroundColor3=ar.Edge,TextSize=
12,TextXAlignment=au,Text=''},aZ)aq.Corner(a_,6)aq.Padding(a_,0,10)local a0=as(
'ScrollingFrame',{Name='Options',LayoutOrder=2,Size=al(1,0,0,ay*(aw+ax)),
ScrollBarThickness=2,ScrollBarImageColor3=ar.Edge,AutomaticCanvasSize=Enum.
AutomaticSize.None},aZ)local a2={}local a4={}local a5=aw+ax local function Paint
()local a6=aA[aI]local a7=ad(a0.CanvasPosition.Y/a5)for a8,a9 in a4 do local b=
a7+a8 local ba=a2[b]a9.Button.Visible=ba~=nil if ba then local bb=a6.Store[ba.Key]~=nil and a6.Store[ba.Key]~=0 a9.Key=ba.Key a9.Button.Position=am(0,(b-1)*a5)a9.Text.Text=Label(ba,
'   ')a9.Text.TextColor3=if bb then ar.Accent else ar.Text a9.Check.Visible=bb
end end end for a6=1,ay+1 do local a7=as('TextButton',{Name='Option',Size=al(1,-
6,0,aw),BackgroundColor3=ar.Edge,BackgroundTransparency=1},a0)aq.Corner(a7,5)
local a8={Button=a7,Text=as('TextLabel',{RichText=true,Position=am(8,0),Size=al(
1,-30,1,0),FontFace=at.SemiBold,TextSize=12,TextTruncate=Enum.TextTruncate.AtEnd
},a7),Check=aq.Icon('Check',{AnchorPoint=ao(1,0.5),Position=al(1,-6,0.5,0),Size=
am(14,14),ImageColor3=ar.Accent},a7),Key=""}a7.MouseEnter:Connect(function()a7.
BackgroundTransparency=0 end)a7.MouseLeave:Connect(function()a7.
BackgroundTransparency=1 end)a7.Activated:Connect(function()local a9=aA[aI]local
b,ba=Entries(a9)if a9.Store[a8.Key]~=nil and a9.Store[a8.Key]~=0 then a9.Store[a8.Key]=nil else a9.Store[a8.Key]=ba[a8.Key].Default end aa.Save()Paint()aX()end)a4[a6]=a8 end local 
function Refilter()local a6=aA[aI]local a7=Entries(a6)local a8=ai(a_.Text)table.
clear(a2)for a9,b in a7 do if(not a6.Listed(b)or a6.Store[b.Key]==0)and(a8==''or ak(b.Search,a8,1,true
))then a2[#a2+1]=b end end a0.CanvasSize=am(0,#a2*a5)a0.CanvasPosition=Vector2.
zero Paint()end aU.Activated:Connect(function()table.clear(aA[aI].Store)aa.Save(
)aX()end)a0:GetPropertyChangedSignal'CanvasPosition':Connect(Paint)a_:
GetPropertyChangedSignal'Text':Connect(Refilter)aS:GetPropertyChangedSignal
'Text':Connect(function()aJ=ai(aS.Text)aX()end)local _ab=as('TextBox',{Name='AddBox',Position=am(0,154),Size=al(1,-158,0,28),BackgroundColor3=ar.Edge,TextSize=12,TextXAlignment=au,PlaceholderText='Add brainrot...',Text=''},aH)aq.Corner(_ab)aq.Padding(_ab,0,12)
local function _match()local _s=aA[1]local _q=ai(_ab.Text)if _q==''then return nil end local _e=Entries(_s)for _,_it in _e do if(not _s.Listed(_it)or _s.Store[_it.Key]==0)and ak(_it.Search,_q,1,true)then return _it end end return nil end
_ab:GetPropertyChangedSignal'Text':Connect(function()local _m=_match()aT.Text=if _m then'+  Add '.._m.Name else'+  Add brainrot'end)
aT.Activated:Connect(function()local _m=_match()if not _m then return end local _s=aA[1]local _v=_m.Default if not _v or _v<=0 then _v=math.max((_m.Gen or 0)/1e6,0.01)end local _mn=math.huge for _,_it in Entries(_s)do if _s.Listed(_it)or _s.Store[_it.Key]~=nil then local _x=_s.Store[_it.Key]or _it.Default if type(_x)=='number'and _x>0 and _x<_mn then _mn=_x end end end for _k,_x in _s.Store do if type(_x)=='number'and _x>0 and _x<_mn then _mn=_x end end _v=if _mn==math.huge then 1 else math.max(_mn/2,0.0001) _s.Store[_m.Key]=_v aa.Save()_ab.Text=''aX()end)
local function _ordered()local _s=aA[1]local _l,_m=Entries(_s)local _o={}for _,_it in _l do if(_s.Listed(_it)or _s.Store[_it.Key]~=nil)and not(_s.Money and _s.Store[_it.Key]==0)then _o[#_o+1]={Item=_it,Value=_s.Store[_it.Key]or _it.Default}end end for _k,_v in _s.Store do if not _m[_k]and not(_s.Money and _v==0)then _o[#_o+1]={Item=Make(_k,_k,'UNKNOWN',aq.Hex(ar.Sub),_v),Value=_v}end end table.sort(_o,function(_a,_b)if _a.Value~=_b.Value then return _a.Value>_b.Value end return _a.Item.Name<_b.Item.Name end)return _o end
local function _flash(_b,_t)local _o=_b.Text _b.Text=_t task.delay(1.4,function()if _b.Parent then _b.Text=_o end end)end
local _expB=as('TextButton',{Name='Export',AnchorPoint=ao(1,0),Position=al(1,-86,0,120),Size=am(80,28),BackgroundColor3=ar.Edge,FontFace=at.SemiBold,TextSize=12,TextColor3=ar.Text,Text='Export'},aH)aq.Corner(_expB)
local _impB=as('TextButton',{Name='Import',AnchorPoint=ao(1,0),Position=al(1,0,0,120),Size=am(80,28),BackgroundColor3=ar.Edge,FontFace=at.SemiBold,TextSize=12,TextColor3=ar.Text,Text='Import'},aH)aq.Corner(_impB)
local _iw=as('Frame',{Name='ImportWindow',Size=an(1,1),BackgroundColor3=ar.Window,Visible=false,ZIndex=20},aH)aq.Corner(_iw,8)
as('TextLabel',{BackgroundTransparency=1,Position=am(12,10),Size=al(1,-24,0,20),FontFace=at.SemiBold,TextSize=14,TextColor3=ar.Text,TextXAlignment=au,Text='Import priority list',ZIndex=21},_iw)
local _tb=as('TextBox',{Name='Paste',Position=am(12,38),Size=al(1,-24,1,-100),BackgroundColor3=ar.Edge,FontFace=at.SemiBold,TextSize=12,TextColor3=ar.Text,TextXAlignment=au,TextYAlignment=Enum.TextYAlignment.Top,MultiLine=true,TextWrapped=true,ClearTextOnFocus=false,PlaceholderText='Paste a list like ["Meowl","John Pork","Strawberry Elephant"]',Text='',ZIndex=21},_iw)aq.Corner(_tb,6)
local _st=as('TextLabel',{BackgroundTransparency=1,AnchorPoint=ao(0,1),Position=al(0,12,1,-12),Size=al(1,-220,0,28),FontFace=at.SemiBold,TextSize=12,TextColor3=ar.Sub,TextXAlignment=au,TextWrapped=true,Text='',ZIndex=21},_iw)
local _ok=as('TextButton',{Name='Apply',AnchorPoint=ao(1,1),Position=al(1,-108,1,-12),Size=am(90,28),BackgroundColor3=ar.Accent,FontFace=at.SemiBold,TextSize=12,TextColor3=ar.Ink,Text='Import',ZIndex=21},_iw)aq.Corner(_ok)
local _no=as('TextButton',{Name='Cancel',AnchorPoint=ao(1,1),Position=al(1,-12,1,-12),Size=am(90,28),BackgroundColor3=ar.Edge,FontFace=at.SemiBold,TextSize=12,TextColor3=ar.Text,Text='Cancel',ZIndex=21},_iw)aq.Corner(_no)
_expB.Activated:Connect(function()local _n={}for _,_e in _ordered()do _n[#_n+1]=_e.Item.Key end local _txt=aa.Services.HttpService:JSONEncode(_n)local _c=setclipboard or toclipboard or(Clipboard and Clipboard.set)if _c then local _ok2=pcall(_c,_txt)_flash(_expB,if _ok2 then'Copied!'else'Failed')else _flash(_expB,'No clipboard')end end)
_impB.Activated:Connect(function()_st.Text=''_iw.Visible=true end)
_no.Activated:Connect(function()_iw.Visible=false end)
_ok.Activated:Connect(function()local _names,_seen={},{}for _n in string.gmatch(_tb.Text,'"(.-)"')do local _t=string.match(_n,'^%s*(.-)%s*$')if _t~=''and not _seen[ai(_t)]then _seen[ai(_t)]=true _names[#_names+1]=_t end end if #_names==0 then _st.Text='No names found. Use ["Name","Name"] format'return end local _s=aA[1]local _l,_m=Entries(_s)local _by={}for _,_it in _l do _by[ai(_it.Name)]=_it _by[ai(_it.Key)]=_it end local _vals={}for _i,_e in _ordered()do _vals[_i]=_e.Value end local _keys={}for _k in _s.Store do _keys[#_keys+1]=_k end for _,_it in _l do if _s.Listed(_it)then _s.Store[_it.Key]=0 end end for _,_k in _keys do local _it=_m[_k]if not(_it and _s.Listed(_it))then _s.Store[_k]=nil end end local _prev,_last=math.huge,_vals[#_vals]or 1 for _i,_n in _names do local _it=_by[ai(_n)]local _key=if _it then _it.Key else _n local _v=_vals[_i]if not _v then _last=math.max(_last*0.9,0.0001)_v=_last end if _v>=_prev then _v=_prev*0.999 end _prev=_v _s.Store[_key]=if _it and _s.Listed(_it)and _v==_it.Default then nil else _v end aa.Save()aX()_iw.Visible=false _tb.Text=''_flash(_impB,'Imported')end)
local a6={}local a7={}local function Pick(a8)local a9=aI aI=a8
local b=Sheet(a8)if a9~=a8 and aW[a9]then local ba=aV.AbsoluteSize.X local bb=if
a9<a8 then 1 else-1 if not b.Grid.Visible or af(b.Slide.X)<0.5 then aq.Snap(b.
Slide,bb*ba)end aq.Go(b.Slide,0)aq.Go(aW[a9].Slide,-bb*ba)end aq.Go(aQ,a8-1,if
a8-1>aQ.X then 2 else-2)for ba,bb in a7 do aq.Fade(bb,ba==a8)end aq.Close()local
ba=a8==aB aS.Visible=not ba _ab.Visible=(not ba)and a8==1 _expB.Visible=(not ba)and a8==1 _impB.Visible=_expB.Visible _iw.Visible=false aS.Size=if a8==1 then al(1,-172,0,28)else al(1,0,0,28) local _vy=if ba then 120 elseif a8==1 then 192 else 154 aV.Position=am(0,_vy)aV.Size=al(1,0,1,-_vy)if ba then aT.Visible,aU.Visible,aR.Text=false,false,
''return end aT.Text='+  Add '..aA[a8].Noun aX()end for a8,a9 in aC do local b=
as('TextButton',{Name=a9,Position=al(0,0,0,(a8-1)*29),Size=al(1,0,0,24),BackgroundColor3=ar.Edge,BackgroundTransparency=0.4,ZIndex=2,FontFace=at.SemiBold,TextSize=12,Text=a9},aO)
as('UICorner',{CornerRadius=UDim.new(0,8)},b)a7[a8]=aq.Motion(if a8==1 then 1 else 0,400,40,function(ba)b.TextColor3=ar.Sub:Lerp(ar.Text,ba)b.BackgroundTransparency=0.45-0.3*ba b.BackgroundColor3=ar.Edge:Lerp(ar.Accent,0.5*ba)end)b.Activated:Connect(function()Pick(a8)end)a6[a8]=b end Pick(
1)end aF=aq.Page('Priority','Priority',Build)aF.Lazy=true do local _w for _,_p in aq.Pages do if _p.Name=='World'then _w=_p end end if _w then local _lo=_w.Tab.LayoutOrder+1 for _,_p in aq.Pages do if _p~=aF and _p.Tab.Parent==_w.Tab.Parent and _p.Tab.LayoutOrder>=_lo then _p.Tab.LayoutOrder+=1 end end aF.Tab.LayoutOrder=_lo end end
return ab.Categories.Settings:CreateAction{Name='Open Priority',Button='Open',
Tooltip='Set your own brainrot values',Function=function()local aG=ab.Modules.
Menu if aG then aG:Toggle(true)end aq.Select(aF)end}end function a.X()local aa=a
.cache.X if not aa then aa={c=__modImpl()}a.cache.X=aa end return aa.c end end
do local function __modImpl()local aa=a.a()local ab=a.b()local ac=
'depresivo_hub_bundle.lua'return ab.Categories.Settings:CreateAction{Name='Reinject',
Tooltip='Reload⁠s the hub',Function=function()if not isfile(ac)then aa.Menu.
Notify('Reinject','Couldnt find '..ac,'Warning',4)return end local ad,ae=
loadstring(readfile(ac))if not ad then aa.Menu.Notify('Reinject',
'The bundle doesnt compile','Error',4)warn("reinject failed:",ae)return end aa.
NextFrame()task.defer(ad)end}end function a.Y()local aa=a.cache.Y if not aa then
aa={c=__modImpl()}a.cache.Y=aa end return aa.c end end do local function 
__modImpl()local aa=a.a()local ab=a.b()return ab.Categories.Settings:
CreateAction{Name='Unload',Tooltip='Turns everything off and unloads',Function=
aa.Stop}end function a.Z()local aa=a.cache.Z if not aa then aa={c=__modImpl()}a.
cache.Z=aa end return aa.c end end do local function __modImpl()local aa=a.a()
local ab=a.b()local ac=a.B()local ad=a.v()local ae=a.I()local af=task.spawn
local ah=aa.Services.RunService local ai=aa.Services.Workspace local aj=Color3.
fromRGB(255,0,0)local ak=Vector3.new(4,4,4)local al local am local an local
ao local ap local function Body(aq)local ar=aq.Plot local as=aq.Part if not ar
or not ar.Model or not as then return nil end local at,au=12 for av,aw in ar.
Model:GetChildren()do if aw:IsA'Model'and aw.Name==aq.Index then local ax=(aw:
GetPivot().Position-as.Position).Magnitude if ax<at then au,at=aw,ax end end end
return au end local function Stand(aq)local ar=ap if not ar then local as=
Instance.new'Part'as.Name='Marker'as.Size=ak as.Anchored=true as.CanCollide=
false as.CanQuery=false as.CanTouch=false as.CastShadow=false as.Transparency=
0 as.Color=aj as.Material=Enum.Material.Neon local at=Instance.new'Highlight'
at.FillColor=aj at.OutlineColor=aj at.FillTransparency=0 at.
OutlineTransparency=0 at.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop at.Parent
=as aa.Owned[as]=true aa.Owned[at]=true ar=as ap=as end local as=ar as.CFrame=
CFrame.new(aq.Position+Vector3.new(0,aq.Size.Y*0.5+ak.Y*0.5,0))if as.Parent~=ai
then as.Parent=ai end return as end local function Clear()if ao then ao:Destroy(
)ao=nil end if ap then ap:Destroy()ap=nil end end local function Mark()local aq=
ac.Picked or ac.Auto local ar=if aq~=nil then ad.Get(aq)else nil local as=ar and
ar.Part if not an.Enabled or not ar or ar.Source~='Plot'or not as or not as.
Parent then Clear()return end local at=Body(ar)if not at then if ao then ao:
Destroy()ao=nil end Stand(as)return end if ap then ap:Destroy()ap=nil end ao=ao
or ae.Highlight(at,aj,0.55)local au=ao if au.Adornee~=at then au.Adornee=at end
end al=ab.Categories.Steal:CreateModule{Name='AutoSteal',Tooltip=
'Automatically steals the selected brainrot',Function=function(aq)ac.Enabled=aq
if not aq then ac.Stop()return end al:Clean(af(ac.Loop))al:Clean(af(ac.WatchCamp
))al:Clean(Clear)local ar=0 al:Clean(ah.Heartbeat:Connect(function(as)ar+=as if
ar>=0.1 then ar=0 Mark()end end))end}am=al:CreateSlider{Name='Min base income',
Min=0,Max=500,Default=0,Suffix='M/s',Function=function(aq)ac.MinBase=aq end}ac.
MinBase=am.Value al:CreateDropdown{Name='Target',List={'Priority','Highest',
'Nearest'},Default='Priority',Tooltip='What to target when no⁠thing is selected',
Function=function(aq)ac.Mode=aq end}ac.Mode=al.Options.Target.Value an=al:
CreateToggle{Name='Highlight target',Tooltip=
'Highlights the target',Default=true}local _gs=al:CreateToggle{Name='Grief shield',Default=false,Tooltip
=[[Uses a Grief Shield before each steal when a brainrot is available]],Function
=function(aq)ac.Shield=aq end}pcall(function()am:Set(0)al.Options.Target:Set('Priority')an:Set(true)_gs:Set(false)end)ac.MinBase=0 ac.Mode='Priority'ac.Shield=false ab.Categories.Steal:CreateAction{Name='Nearest & Priority',Button='Switch',Tooltip='Switches the target between Priority and Nearest (set a keybind on it)',Function=function()local nm=if ac.Mode=='Nearest'then'Priority'else'Nearest' pcall(function()al.Options.Target:Set(nm)end)ac.Mode=nm aa.Menu.Notify('Target',nm..' mode','Info',2)end} return al end function a._()local aa=a.cache._ if
not aa then aa={c=__modImpl()}a.cache._=aa end return aa.c end end do local 
function __modImpl()local aa=a.a()local ab=a.b()local ac=a.t()local ad=a.h()
local ae=math.abs local af=math.huge local ah=aa.LocalPlayer local ai local 
function Unlock()local aj,ak=ad.Character()if not ak then return end local al=ac
.Nearest(ak.Position,function(al)return al.Owner~=nil and not al.Mine end)if not
al then return end local am local an=af for ao,ap in ac.Unlocks(al)do local aq=
ap.Part local ar=if aq:IsA'BasePart'then ae(aq.Position.Y-ak.Position.Y)else af
if ap.Floor and an>ar then am,an=ap.Floor,ar end end if am then ac.Unlock(al,am)
end end ai=ab.Categories.Blatant:CreateModule{Name='AutoUnlock',Tooltip=
'Unlocks your flo⁠or when you steal',Function=function(aj)if not aj then return
end ai:Clean(ah:GetAttributeChangedSignal'Stealing':Connect(function()if ad.
Carrying(ah)then Unlock()end end))end}return ai end function a.aa()local aa=a.
cache.aa if not aa then aa={c=__modImpl()}a.cache.aa=aa end return aa.c end end
do local function __modImpl()local aa=a.a()local ab=a.n()local ac=a.h()local ad=
math.max local ae=string.match local af=task.spawn local ah=task.wait local ai=
aa.Services.RunService local aj=aa.Services.Workspace local ak=aa.Services.
ReplicatedStorage local al=
[[^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$]]
local am='ReplicatedStorage.Controllers.AdminPanelController'local an={{
'e4ad4242-041d-4eb8-886f-d89431e26dbe','31e22262-a1a7-4f5f-b66c-551d0b72bbc5'},{
'a434c202-a33e-49b9-80a0-4957c24b60b8','fcec6acb-8d1e-4fa1-8d84-fbe0f52f5f0c'},{
'7f75af2a-1216-4237-b376-083f07f000c9','5de09977-5fee-4669-bf61-a08ed7c0d38f'}}
local ao={balloon=30,control=60,inverse=60,jail=60,jumpscare=60,morph=60,rocket=120,tiny=60,ragdoll=30}local ap={Commands={'rocket','ragdoll','balloon','jail',
'tiny','inverse','control','jumpscare','morph','laser'},Ends={},Laser=nil}local
aq local ar local as=false local function Guids(at)local au={}local av,aw=pcall(
debug.getconstants,at)if not av or type(aw)~='table'then return au end for ax,ay
in aw do if type(ay)=='string'and ae(ay,al)then au[#au+1]=ay end end return au
end local function Try(at,au)local av=ab.Function(at)if av then aq,ar=av,au end
return nil~=av end local function Dump()as=true if type(filtergc)~='function'
then return end local at,au=pcall(filtergc,"function",{Source=am,IgnoreExecutor=
true},false)if not at or type(au)~='table'then return end for av,aw in au do
local ax=Guids(aw)if#ax>=2 and(Try(ax[1],ax[2])or Try(ax[2],ax[1]))then return
end end end local function Resolve()if aq and aq.Parent then return aq,ar end if
not as then Dump()if aq then return aq,ar end end for at,au in an do if Try(au[1
],au[2])then return aq,ar end end return nil,nil end local at local function 
Cooldown(au)if at==nil then local av=ak:FindFirstChild'Datas'local aw=av and av:
FindFirstChild'AdminCommands'at=if aw and aw:IsA'ModuleScript'then aa.Require(aw
)else false end local av=at and at[au]return if type(av)=='table'and type(av.
cooldown)=='number'then av.cooldown else ao[au]or 0 end function ap.Remaining(au
)return ad(0,(ap.Ends[au]or 0)-os.clock())end function ap.Run(au,av)if av==
'laser'then ap.Shoot(au)return true end if not au.Parent or ap.Remaining(av)>0
then return false end local aw,ax=Resolve()if not aw then return false end local
ay=Cooldown(av)ap.Ends[av]=os.clock()+ay af(function()local az,aA,aB=pcall(aw.
InvokeServer,aw,ax,au,av)if not az then ap.Ends[av]=0 elseif type(aB)=='number'
then ap.Ends[av]=os.clock()+ad(0,aB+ay-aj:GetServerTimeNow())end end)return true
end function ap.All(au)for av,aw in ap.Commands do if aw~="laser"then ap.Run(au,
aw)end end end local au local function Aim()local av=ap.Laser local aw=av and av
.Parent and av.Character local ax=aw and aw:FindFirstChild'HumanoidRootPart'if
au and ax and ax:IsA'BasePart'then au.Hit=CFrame.new(ax.Position)au.Target=ax
end end function ap.Shoot(av)local aw=ac.FindTool'Laser Cape'if not aw then
return end if not au then local ax=ak:FindFirstChild'Packages'local ay=ax and ax
:FindFirstChild'PlayerMouse'au=if ay and ay:IsA'ModuleScript'then aa.Require(ay)
else nil end af(function()ap.Laser=av local ax=ai.PreRender:Connect(Aim)local ay
=ai.Stepped:Connect(Aim)if ac.Equip(aw)then ai.Heartbeat:Wait()Aim()if aw.
Enabled then aw:Activate()end end ah(0.2)ax:Disconnect()ay:Disconnect()if ap.
Laser==av then ap.Laser=nil end end)end aa.Admin=ap return ap end function a.ab(
)local aa=a.cache.ab if not aa then aa={c=__modImpl()}a.cache.ab=aa end return
aa.c end end do local function __modImpl()local aa=a.a()local ab=task.defer
local ac=task.delay local ad=task.wait local ae=aa.Services.Workspace local af=
aa.LocalPlayer local ah=aa.Services.SoundService local ai=aa.Services.
ContentProvider local aj='Heatseeker'local ak='Taser Gun'local al='FakeCopy'
local am='Missle_'local an='bazookaexplosion'local ao='rbxassetid://82273261'
local ap='rbxassetid://14582813693'local aq=0.31 local ar='FakeTaser'local as={
'Giant Potion','Quantum Cloner','Heatseeker'}local at={}local au={}local av={}
local aw=(setmetatable({},{__mode='k'}))local ax=(setmetatable({},{__mode='k'}))
local ay local az=CFrame.new()local aA=true local aB={}local aC=0 local aD={}
local function Quiet(aE)if at[aE]==nil then at[aE]=aE.Volume end aE.Volume=0 aE:
Stop()end local function Clear(aE)if aE.Name==al then return end if aE:IsA
'Sound'then Quiet(aE)elseif aE:IsA'BasePart'then if au[aE]==nil then au[aE]=aE.
Transparency local aF=aE aa.Connect(aF:GetPropertyChangedSignal'Transparency',
function()if aA and aF.Transparency~=1 then aF.Transparency=1 end end)end aE.
Transparency=1 elseif aE:IsA'ParticleEmitter'or aE:IsA'Beam'or aE:IsA'Trail'or
aE:IsA'Smoke'or aE:IsA'Fire'or aE:IsA'Light'then local aF=aE if av[aE]==nil then
av[aE]=aF.Enabled end aF.Enabled=false end end local function Strip(aE)Clear(aE)
for aF,aG in aE:GetDescendants()do Clear(aG)end aa.Connect(aE.DescendantAdded,
Clear)end local function Mute(aE)if aE:IsA'Sound'and aE.Name~=ar then if aB[aE]
==nil and at[aE]==nil then aB[aE]=aE.Volume end aE.Volume=0 aE:Stop()end end
local function Sweep(aE,aF)local aG=aE and aE:FindFirstChild(aF)if aG then for
aH,aI in aG:GetDescendants()do Mute(aI)end end end local function Release()for
aE,aF in aD do aF:Disconnect()end table.clear(aD)for aE,aF in aB do aE.Volume=aF
end table.clear(aB)end local function Hush()aC+=1 if aC>1 then return end local
aE=af:FindFirstChildOfClass'Backpack'for aF,aG in as do Sweep(af.Character,aG)
Sweep(aE,aG)end aD[1]=ae.DescendantAdded:Connect(function(aF)local aG=af.
Character if aG and aF:IsA'Sound'and aF:IsDescendantOf(aG)then Mute(aF)end end)
aD[2]=af.DescendantAdded:Connect(Mute)aD[3]=ah.DescendantAdded:Connect(Mute)end
local function Unhush()aC=math.max(aC-1,0)if aC==0 then Release()end end local 
function Effects(aE)if aE.Name==an or string.sub(aE.Name,1,#am)==am then Strip(
aE)end end local function FakeOf(aE)local aF=af:FindFirstChildOfClass'Backpack'
local aG=(aF and aF:FindFirstChild(ak))or(aE and aE:FindFirstChild(ak))return if
aG and aG:IsA'Tool'then aG else nil end local function Learn(aE)if aE.Name==ak
and aE:IsA'Tool'then local aF=aE ab(function()local aG=aF:FindFirstChild'Handle'
if not ay and aG and aG:IsA'BasePart'then ay=(aG:Clone())az=aF.Grip end end)end
end local function Disguise(aE)if not ax[aE]then ax[aE]=true Strip(aE)local aF=
aE:FindFirstChild'AimUI'if aF and aF:IsA'BillboardGui'then av[aF]=aF.Enabled aF.
Enabled=false end end if aw[aE]then return end local aF=af.Character local aG=aF
and aF:FindFirstChild'RightHand'local aH=FakeOf(aF)local aI=aH and aH:
FindFirstChild'Handle'local aJ=ay local aK=az if aH and aI and aI:IsA'BasePart'
then aJ,aK=aI,aH.Grip end if not aJ or not aG or not aG:IsA'BasePart'then return
end local aL=(aJ:Clone())if not aL then return end aL.Name=al aL.Anchored=false
aL.CanCollide=false aL.CanTouch=false aL.CanQuery=false aL.Massless=true local
aM=aG:FindFirstChild'RightGripAttachment'local aN=Instance.new'Weld'aN.Part0=aG
aN.C0=if aM and aM:IsA'Attachment'then aM.CFrame else CFrame.new(0,-1,0)aN.C1=aK
aN.Part1=aL aN.Parent=aL aL.Parent=aE aw[aE]=aL end local function Consider(aE)
Learn(aE)if aE.Name==aj and aE:IsA'Tool'then ab(Disguise,aE)end end local 
function Watch(aE)for aF,aG in aE:GetChildren()do Consider(aG)end aa.Connect(aE.
ChildAdded,Consider)end local function Arc(aE,aF)local aG=Instance.new
'Attachment'aG.Name='FakeArc'aG.Parent=aF local aH=Instance.new'Attachment'aH.
Name='FakeArc'aH.Parent=aE local aI=Instance.new'Beam'aI.Attachment0=aG aI.
Attachment1=aH aI.Color=ColorSequence.new(Color3.new(1,0.88,0))aI.Transparency=
NumberSequence.new(0)aI.Width0=1 aI.Width1=1 aI.CurveSize0=0 aI.CurveSize1=0 aI.
FaceCamera=true aI.LightEmission=0 aI.LightInfluence=1 aI.Segments=10 aI.Texture
=ap aI.TextureLength=1 aI.TextureMode=Enum.TextureMode.Stretch aI.TextureSpeed=1
aI.ZOffset=0 aI.Parent=aE ac(aq,function()aI:Destroy()aG:Destroy()aH:Destroy()
end)end local aE=Instance.new'Sound'aE.Name=ar aE.SoundId=ao aE.Volume=1 ab(
pcall,ai.PreloadAsync,ai,{aE})aa.Clean(aE)local function Speak()local aF=aE:
Clone()aa.Owned[aF]=true aF.Parent=ah local aG=os.clock()+3 while not aF.
IsLoaded and os.clock()<aG do ad(0.05)end local aH=if aF.TimeLength>0 then aF.
TimeLength else 1.3 local aI=os.clock()local aJ=0 aF.Stopped:Connect(function()
if aJ<5 and os.clock()-aI<aH-0.2 then aJ+=1 aF:Play()end end)aF:Play()ac(aH+1,aF
.Destroy,aF)end local function Tased()local aF=af.Character local aG=aF and aF:
FindFirstChild'HumanoidRootPart'local aH=aF and aF:FindFirstChild'RightHand'if
not aG or not aG:IsA'BasePart'then return end ab(Speak)Arc(aG,if aH and aH:IsA
'BasePart'then aH else aG)end for aF,aG in ae:GetChildren()do Effects(aG)end aa.
Connect(ae.ChildAdded,Effects)for aF,aG in{ae,aa.Services.ReplicatedStorage}do
aa.Connect(aG.DescendantAdded,Learn)local aH=aG:FindFirstChild(ak,true)if aH
then Learn(aH)end end if af.Character then Watch(af.Character)end aa.Connect(af.
CharacterAdded,Watch)local function Pack(aF)if aF:IsA'Backpack'then Watch(aF)end
end for aF,aG in af:GetChildren()do Pack(aG)end aa.Connect(af.ChildAdded,Pack)aa
.Clean(function()aA=false aC=0 Release()for aF,aG in at do aF.Volume=aG end for
aF,aG in au do aF.Transparency=aG end for aF,aG in av do(aF).Enabled=aG end for
aF,aG in aw do aG:Destroy()end table.clear(at)table.clear(au)table.clear(av)
table.clear(aw)table.clear(ax)if ay then ay:Destroy()ay=nil end end)return{Tased
=Tased,Unhush=Unhush,Hush=Hush}end function a.ac()local aa=a.cache.ac if not aa
then aa={c=__modImpl()}a.cache.ac=aa end return aa.c end end do local function 
__modImpl()local aa=a.a()local ab=a.n()local ac=a.g()local ad=string.lower local
ae=task.spawn local af={Message=ac.new()}local ah=string.match local ai=string.
format local aj=table.concat local ak=task.wait local al=aa.Services.Players
local am,an=0.5,2 local ao={}local ap=false local function Face(aq)local ar=ad(
aq)for as,at in al:GetPlayers()do if ad(at.Name)==ar then return ai(
"rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48",at.UserId)end end return nil
end local function Show(aq)if _G.__APNotify then pcall(_G.__APNotify,aq.Name,aq.Commands,Face(aq.Name),not aq.Incoming)end end local function Add(aq,ar,as)local at=(if aq then'in:'else
'out:')..ad(ar)local au=os.clock()local av=ao[at]if not av then av={Start=au,
Last=au,Commands={},Seen={},Name=ar,Incoming=aq}ao[at]=av ae(function()repeat
ak(0.1)until not aa.Running or os.clock()-av.Last>=am or os.clock()-av.Start>=an
ao[at]=nil if aa.Running and not ap then Show(av)end end)end av.Last=au if not
av.Seen[as]then av.Seen[as]=true av.Commands[#av.Commands+1]=as end end local 
function Forward(...)for aq=1,select('#',...)do local ar=select(aq,...)if type(
ar)~='string'then continue end af.Message:Fire(ar,ad(ar))local as,at=ah(ar,
'^(.-) ran "(%a+)" on you!')if as and at then Add(true,as,at)continue end local
au,av=ah(ar,'Successfully executed "(%a+)" on ([^!<]+)!')if au and av then Add(
false,av,au)end end end ae(function()local aq=ab.Event
'NotificationService/Notify'if not aq then warn'notification remote not found'
return end aa.Connect(aq.OnClientEvent,Forward)ak(3)local ar,as=pcall(
getconnections,aq.OnClientEvent)for at,au in if ar and type(as)=='table'then as
else{}do local av=au.Function if av and not isexecutorclosure(av)then ap=true
end end end)return af end function a.ae()local aa=a.cache.ae if not aa then aa={
c=__modImpl()}a.cache.ae=aa end return aa.c end end do local function __modImpl(
)local aa=a.a()local ab=math.random local ac=string.format local ad=aa.Services.
TeleportService local ae=aa.Services.HttpService local af=aa.LocalPlayer local
ah=
[[https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&excludeFullGames=true&limit=100%s]]
local ai={}function ai.Leave()af:Kick''game:Shutdown()end function ai.Rejoin()
local aj,ak=pcall(ad.TeleportToPlaceInstance,ad,game.PlaceId,game.JobId,af)if
not aj then warn('couldnt rejoin this server, joining another:',ak)ad:Teleport(
game.PlaceId,af)end end function ai.Hop()local aj for ak=1,5 do local al=request
{Url=ac(ah,game.PlaceId,if aj then'&cursor='..aj else''),Method='GET'}if al.
StatusCode~=200 then warn('server list failed:',al.StatusCode)return false end
local am=ae:JSONDecode(al.Body)local an={}for ao,ap in am.data or{}do if ap.id~=
game.JobId and ap.playing<ap.maxPlayers then an[#an+1]=ap.id end end if#an>0
then ad:TeleportToPlaceInstance(game.PlaceId,an[ab(1,#an)],af)return true end aj
=am.nextPageCursor if not aj then break end end warn
'no other server with free slots'return false end return ai end function a.af()
local aa=a.cache.af if not aa then aa={c=__modImpl()}a.cache.af=aa end return aa
.c end end do local function __modImpl()local aa=a.a()local ab=a.b()local ac=a.
ae()local ad=a.af()local ae=string.find local af=aa.LocalPlayer local ah local
ai
ah=ab.Categories.Blatant:CreateModule{Name='Auto Kick',Was='LeaveOnSteal',Tooltip=
'Leaves after a ste⁠al is delivered',Function=function(aj)if not aj then return
end ah:Clean(ac.Message:Connect(function(ak,al)if not ae(al,'you stole',1,true)
then return end local am=ab.Modules.JoinPS local _pl=am and am.Options['Private server link']local _has=_pl and _pl.Value~=''and ae(_pl.Value,'code=',1,true)~=nil af:Kick''if _has and am then am.Join()end end))end} ai={Value='Kick'}
do local _LP=game:GetService('Players').LocalPlayer
local function _kill(a)pcall(function()a.Disabled=true end)end
local function _stop(c)local h=c and c:FindFirstChildOfClass'Humanoid'local an=h and h:FindFirstChildOfClass'Animator'if an then for _,t in an:GetPlayingAnimationTracks()do pcall(function()t:Stop(0)end)end end end
local function _hook(c)if not c then return end local a=c:FindFirstChild'Animate'if a then _kill(a)end c.ChildAdded:Connect(function(h)if h.Name=='Animate'then _kill(h)end end)
task.spawn(function()local h=c:WaitForChild('Humanoid',10)local an=h and(h:FindFirstChildOfClass'Animator'or h:WaitForChild('Animator',10))if an then an.AnimationPlayed:Connect(function(t)pcall(function()t:Stop(0)end)end)end _stop(c)end)end
game:GetService('RunService').Stepped:Connect(function()_stop(_LP.Character)end)
_hook(_LP.Character)_LP.CharacterAdded:Connect(_hook)end
do local _ui=a.f()local PINK=Color3.new(1,1,1)local DARK=Color3.fromRGB(12,12,14)
local function mk(c,p,par)local o=Instance.new(c)for k,v in p do o[k]=v end o.Parent=par return o end
local function round(o,r)mk('UICorner',{CornerRadius=UDim.new(0,r)},o)end
local fr=mk('Frame',{Name='MiniUtility',Size=UDim2.fromOffset(236,114),BackgroundColor3=DARK,BorderSizePixel=0},_ui.Overlay)round(fr,14)
mk('UIStroke',{Color=PINK,Thickness=1.2,Transparency=0.55},fr)
local bg=mk('ImageLabel',{Name='Bg',Size=UDim2.fromScale(1,1),ZIndex=0,BackgroundTransparency=1,ImageTransparency=0.55,ScaleType=Enum.ScaleType.Crop,Visible=false},fr)round(bg,14)_G.__SE_AddBg(bg)
mk('TextLabel',{BackgroundTransparency=1,Position=UDim2.fromOffset(14,8),Size=UDim2.fromOffset(200,18),Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Color3.new(1,1,1),TextXAlignment=Enum.TextXAlignment.Left,Text='DEPRESIVINI PRV HUB',ZIndex=2},fr)
mk('TextLabel',{BackgroundTransparency=1,Position=UDim2.fromOffset(14,26),Size=UDim2.fromOffset(200,14),Font=Enum.Font.Gotham,TextSize=11,TextColor3=Color3.fromRGB(150,150,160),TextXAlignment=Enum.TextXAlignment.Left,Text='Mini Utility',ZIndex=2},fr)
mk('TextLabel',{BackgroundTransparency=1,Position=UDim2.fromOffset(14,52),Size=UDim2.fromOffset(200,14),Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=Color3.fromRGB(170,170,180),TextXAlignment=Enum.TextXAlignment.Left,Text='Server',ZIndex=2},fr)
local rj=mk('TextButton',{Position=UDim2.fromOffset(14,70),Size=UDim2.fromOffset(210,32),BackgroundColor3=Color3.fromRGB(0,0,0),AutoButtonColor=false,Font=Enum.Font.GothamBold,TextSize=13,TextColor3=Color3.new(1,1,1),Text='Rejoin',ZIndex=2},fr)round(rj,9)
rj.Activated:Connect(function()pcall(function()game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId,game.JobId,game:GetService('Players').LocalPlayer)end)end)
_ui.Place('MiniUtility',fr,fr,UDim2.fromOffset(16,70))end
return ah end function a.ag()local aa=a.cache.ag if
not aa then aa={c=__modImpl()}a.cache.ag=aa end return aa.c end end do local 
function __modImpl()local aa=a.a()local ab=a.b()local ac=a.B()local ad=a.h()
local ae=a.v()local af=a.t()local ah=a.i()local ai=string.format local aj=a.y()
local ak=a.A()local al=aa.LocalPlayer local am=task.spawn local an=task.wait
local ao=task.delay local ap=30 local aq=8 local ar local as local at local au
local av local aw local ax local ay local az local aA local aB local aC local aD
local aE local aF local aG local aH local aI local aJ local aK local aL local aM
local aN=0 local _cs,_cd local function Priority(aO)return(aO.Value or 0)>0 end local function 
Allowed(aO)if aI.Enabled and not Priority(aO)then return false end local aP=aO.
Owner return not(aP and ad.IsStaff(aP))end local aO=3 local aP=30 local aQ=0
local aR=false local function StopReturn()aQ+=1 if aR then ac.Cancel()end end
local function ReturnWatch(aS)if not aJ.Enabled then return end aQ+=1 local aT=
aQ local aU=al.Character local aV=0 local aW=false local aX local function Stop(
)if aX then aX:Disconnect()aX=nil end end aX=al:GetAttributeChangedSignal
'RagdollEndTime':Connect(function()if aT~=aQ then return Stop()end local aY=al:
GetAttribute'RagdollEndTime'if aW or type(aY)~='number'or aY<=aa.Services.
Workspace:GetServerTimeNow()then return end local aZ=al.Character local a_=aZ
and aZ:FindFirstChildOfClass'Humanoid'if not aZ or aZ~=aU or not a_ or a_.Health
<=0 or al:GetAttribute'Stealing'then return Stop()end local a0=ae.Get(aS.Key)if
not a0 or not(ac.Available(a0))then return Stop()end aV+=1 if aO<aV then return
Stop()end aW=true aa.Menu.Notify('Teleport','Hit, going back to '..tostring(a0.
Index),'Info',2)aR=true local a2=a_.Died:Connect(StopReturn)ac.Launch(a0)a2:
Disconnect()aR=false aW=false end)aa.Clean(Stop)ao(aP,Stop)end local function 
Fill(aS)local _sp,_bs=as.Value,aD.Value pcall(function()local _c=_cs and tonumber(_cs.Value)or 0 if _c>0 then local _e=ac.PickedEntity()if not _e then for _,_u in ac.Ranked()do if Allowed(_u)then _e=_u break end end end local _ch=al.Character local _rt=_ch and _ch:FindFirstChild'HumanoidRootPart'local _ps=_e and _e.Part and _e.Part.Position if _rt and _ps and(_rt.Position-_ps).Magnitude<=(_cd and tonumber(_cd.Value)or 60)then _sp=_c _bs=_c end end end)ac.Travel={Speed=_sp,CloseSpeed=_cs and _cs.Value,CloseDist=_cd and _cd.Value,Unboosted=au.Value,Show=av.Enabled,Rush=aS,
Approach=ax.Value,Rise=aB.Value,Turn=aC.Value,BrainrotSpeed=_bs,Entry=ay.
Value,Delay=az.Value,Equip=aA.Value,Clone=aE.Enabled or aH.Value=='Clone',Prefer
=aH.Value,Under=aG.Enabled}ak.Settings.GrabbleTPSpeed=_sp ak.Settings.
CloneDelayVal=aF.Value ak.ShowPath=av.Enabled ak.SetTool(aw.Value)ak.
ReachFromBelow(aG.Enabled)end ac.FillTravel=Fill local function Go(aS)
StopReturn()if aa.LocalPlayer:GetAttribute'Stealing'then aa.Menu.Notify(
"Teleport","Can't teleport while stealing",'Warning',3)return false end Fill(aS)
local aT=ac.PickedEntity()if aT and aT.Owner and ad.IsStaff(aT.Owner)then aa.
Menu.Notify('Teleport','Skipped '..tostring(aT.Index)..', owned by staff',
'Warning',3)end local aU,aV=ac.Go(Allowed)
return aU~=nil and aV end local function HasTarget()local aS=ac.PickedEntity()if
aS and Allowed(aS)then return true end for aT,aU in ac.Ranked()do if Allowed(aU)
then return true end end return false end local aS=RaycastParams.new()aS.
FilterType=Enum.RaycastFilterType.Exclude local function OnGround(aT)local aU=ac
.Route.FloorY()if aT.Position.Y<aU-1 then return false end aS.
FilterDescendantsInstances={aT.Parent}local aV=aa.Services.Workspace:Raycast(aT.
Position,Vector3.new(0,-80,0),aS)return aV~=nil and aV.Instance.CanCollide and
aV.Position.Y>=ac.Route.GroundY-0.5 end local function Prepared()if al:
GetAttribute"Stealing"then return false end local aT,aU=ad.Character()local aV=
false for aW,aX in ah.Flying do aV=aV or ad.FindTool(aX)~=nil end local aW=(aE.
Enabled or aH.Value=='Clone')and ad.FindTool'Quantum Cloner'~=nil return aU~=nil
and aV and(ad.FindTool'Flash Teleport'~=nil or aW)and OnGround(aU)end local aT={
['flying to stand']=true,['flying to the clone spot']=true,[
'flying to the brainrot']=true,['walking in, base is open']=true}local function 
Upgrade(aU,aV)while aU==aN and ac.Busy do af.Poll()ae.Rescan()local aW=ac.Target
local aX=ac.Choose(Allowed)if aW and aX and aX.Key~=aW.Key and aT[ac.Status]then
aV[#aV+1]=ai('better target %s +%.2fs',tostring(aX.Index),os.clock()-aa.Started)
ac.Cancel()return end an(0.1)end end local function Attempt(aU,aV)local aW=ac.
LoadLog local aX=os.clock()+ap while aU==aN and aK.Enabled and os.clock()<aX do
if ac.Busy or not HasTarget()or not Prepared()then an(0.1)continue end if aV
then task.defer(Upgrade,aU,aW)end local aY=#aW if Go(aV)then aW[#aW+1]=ai(
'landed +%.2fs',os.clock()-aa.Started)return end local aZ=#aW>aY aW[#aW+1]=ai(
'%s +%.2fs',tostring(ac.Status),os.clock()-aa.Started)do break end end if aU==aN and aK.Enabled and#aW>0 then aa.Menu.Notify('Teleport',
'Auto TP gave up: '..aW[#aW],'Warning',4)end end local function Patient(aU)ac.
LoadLog={}local aV=os.clock()+aq while not ae.Settled()and aU==aN and os.clock()
<aV do an(0.1)end ae.Rescan()if aM.Value>0 then an(aM.Value)end local aW=os.
clock()+ap while not(HasTarget()and Prepared())and aU==aN and os.clock()<aW do
an()end Attempt(aU,false)end local function Eager(aU)local aV={}ac.LoadLog=aV
local aW={}local function Mark(aX,aY)if aY and not aW[aX]then aW[aX]=true aV[#aV
+1]=ai('%s +%.2fs',aX,os.clock()-aa.Started)end return aY end Mark('armed',true)
for aX,aY in aj.Bases()do am(pcall,al.RequestStreamAroundAsync,al,aY,10)end
local aX while aU==aN do af.Poll()ae.Rescan()local aY,aZ=ad.Character()local a_=
false for a0,a2 in ah.Flying do a_=a_ or ad.FindTool(a2)~=nil end local a0,a2=
false,false for a4,a5 in ae.List do if a5.Source=='Plot'and a5.Plot and not a5.
Plot.Mine then a0=true a2=a2 or(a5.Part~=nil and a5.Part.Parent~=nil)end end
local a4=false Mark('plots',next(af.List)~=nil)for a5,a6 in af.List do a4=a4 or(
not a6.Mine and af.Data(a6)~=nil)end Mark('plot data',a4)Mark("brainrots",a0)
Mark('podiums',a2)local a5=Mark('target',HasTarget())Mark('character',aZ~=nil)
Mark('ground',aZ~=nil and OnGround(aZ))Mark('carpet',a_)Mark('flash',ad.FindTool
'Flash Teleport'~=nil)if a5 and Prepared()then break end aX=aX or os.clock()+ap
if os.clock()>(aX)then aV[#aV+1]='gave up waiting'return end an(0.05)end Mark(
'go',true)Attempt(aU,true)end local function Arm()aN+=1 if not aK.Enabled then
return end if aH.Value=='Clone'then ak.Prime()end am(if aL.Value=='Preload'then
Eager else Patient,aN)end ar=ab.Categories.Steal:CreateAction{Name='Teleport',
Was='Go To Target',Tooltip='Teleports to the selected brainrot',Function=
function()Go()end}as=ar:CreateSlider{Name='Speed',Min=50,Max=800,Default=485,
Suffix=' studs/s',Tooltip='Flying speed when getting in'}_cs=ar:CreateSlider{Name='Close speed',Min=0,Max=800,Default=0,Suffix=' studs/s',Tooltip='Speed used instead of Speed when the brainrot is close (0 = off)'}_cd=ar:CreateSlider{Name='Close distance',Min=10,Max=300,Default=60,Suffix=' studs',Tooltip='How near the brainrot must be to use Close speed'}at={Value=485}au={Value=120}av={Enabled=false}aw=ar:CreateDropdown{Name='Fly tool',List={'Waverider',
'Skeleton Dragon',"Witch's Broom",'Flying Carpet',"Cupid's Wings",
"Santa's Sleigh",'Flying Bee'},Default='Waverider',Tooltip=
'Flying gear to use, fall⁠s back to any other you own',Function=function(aU)ah.
Prefer=aU end}ah.Prefer=aw.Value ax={Value='CFrame'}ay={Value='Front'}aD=ar:CreateSlider{Default=400,Max=1000,Min=50,Suffix=' studs/s',Name='Brainrot speed',Tooltip='Final approach speed'}aB=
ar:CreateSlider{Name='Rise speed',Min=20,Max=1000,Default=600,Suffix=' studs/s',
Tooltip='Climbing speed'}aC={Value=160}aH=ar:CreateDropdown{Name='Tp with',List={'Flash','Clone'},Default='Flash',Tooltip='Which tool to get in with first'}aE=ar:CreateToggle{Name='Use clone if flash has cooldown',Tooltip='Clones in while Flash is on cooldown'}aG=ar:
CreateToggle{Tooltip=
'Steals upstairs brainrots from the floor below',Name='Reach 2nd floor from 1st',Default=true}aF=ar:CreateSlider{Name=
'Clone delay',Min=0,Max=1,Default=0.3,Step=0.01,Suffix='s',Tooltip=
'Wait before placing the clone',Function=function(aU)aj.Delay=aU end}aj.Delay=aF
.Value az=ar:CreateSlider{Name='Flash delay',Min=0,Max=1,Default=0.1,Step=0.01,Suffix='s',Tooltip='Wait at the stand before flashing'}aA=ar:CreateSlider{Name='Flash equip time',Min=0.1,Max=2,Default=0.6,Step=0.05,Suffix='s',Tooltip='Max wait for Flash to equip'} aJ={Enabled=false}aI=ar:CreateToggle{Name='Tp only to priority',
Tooltip='Only targets priced brainrots'}aK=ar:CreateToggle{Name=
'Auto TP on load',Tooltip='Teleports onc⁠e after joining',Function=function(aU)
local aV=ab.Modules.CframeTP local aW=aV and aV.Options['On load']if aU and aW
and aW.Enabled then aW:Toggle(false)end task.defer(Arm)end}aL={Value='On load'}aM=ar:
CreateSlider{Default=0,Max=10,Min=0,Name='Auto tp on load delay',Step=0.1,Tooltip='Extra wait before starting',Suffix='s'}task.defer(Arm)aa.Clean(function()aN+=1 aQ
+=1 end)return ar end function a.ah()local aa=a.cache.ah if not aa then aa={c=
__modImpl()}a.cache.ah=aa end return aa.c end end do local function __modImpl()
local aa=a.a()local ab=a.b()local ac=a.z()local ad=a.o()local ae=a.t()local af=a
.y()local ah=a.B()local ai=a.e()local aj={['611676758697181295']=true,[
'1503892033725534269']=true}local ak=ai.Id()if not(ak and aj[ak])then return nil
end local al=string.format local am=os.clock local an=aa.Services.
UserInputService local ao=aa.Services.Workspace local ap=aa.LocalPlayer local aq
local ar local as local at local au local av=false local aw={'Main',
'SecondFloor','ThirdFloor'}local function Root()local ax=ap.Character local ay=
ax and ax:FindFirstChild'HumanoidRootPart'local az=ax and ax:
FindFirstChildOfClass'Humanoid'return if ay and ay:IsA"BasePart"then ay else nil
,az end local function Mark()if not as or not ar.Enabled then if at then at.
Parent=nil end return end if not at then local ax=Instance.new'Part'ax.Name=
'TwilightWaypoint'ax.Shape=Enum.PartType.Ball ax.Size=Vector3.new(2,2,2)ax.
Material=Enum.Material.Neon ax.Color=aa.Menu.Theme.Accent ax.Transparency=0.3 ax
.Anchored=true ax.CanCollide=false ax.CanQuery=false ax.CanTouch=false at=aa.
Clean(ax)end local ax=at ax.Position=as ax.Parent=ao end local function SetGoal(
ax)as=ax Mark()aa.Menu.Notify('Waypoint',al('Set at %.0f, %.0f, %.0f',ax.X,ax.Y,
ax.Z),'Info',3)end local function StandHeight()local ax,ay=Root()return(if ay
then ay.HipHeight else 2)+(if ax then ax.Size.Y/2 else 1)end local function Pick
()if au then au:Disconnect()end aa.Menu.Notify('Waypoint',
"Click where it should go",'Info',3)au=aa.Clean(an.InputBegan:Connect(function(
ax,ay)if ay or ax.UserInputType~=Enum.UserInputType.MouseButton1 then return end
(au):Disconnect()au=nil local az=ao.CurrentCamera local aA=az:ScreenPointToRay(
ax.Position.X,ax.Position.Y)local aB=RaycastParams.new()aB.FilterType=Enum.
RaycastFilterType.Exclude aB.FilterDescendantsInstances={ap.Character,at}local
aC=ao:Raycast(aA.Origin,aA.Direction*2000,aB)if not aC then aa.Menu.Notify(
'Waypoint','Nothin⁠g there','Warning',3)return end SetGoal(aC.Position+Vector3.
new(0,StandHeight(),0))end))end local function Option(ax)local ay=ab.Modules.
Teleport local az=ay and ay.Options[ax]return az and(if az.Value~=nil then az.
Value else az.Enabled)end local function Fly()local ax=Root()if not as or not ax
then aa.Menu.Notify('Waypoint',if as then'No character'else
'Set a waypoint first','Warning',3)return end if av then ac.Stop()return end av=
true local ay=as local az=ax.Position local aA=''for aB,aC in ae.List do if not
af.InWalls(aC.Model,ay)then continue end local aD={}for aE,aF in aw do if ae.
BlockSeconds(aC,aE)>0 then aD[aF]=true aA..=' '..aE end end ac.SolidLasers[aB]=
aD end local aB=am()local aC=ac.RouteD3(az,ay,nil)local aD=am()-aB local aE=
tostring(ac.RouteSrc)local aF=0 local aG=az for aH,aI in aC do aF+=(aI-aG).
Magnitude aG=aI end local aH=if Option'Show path'then ad.Draw{az,table.unpack(aC
)}else nil local aI=am()local aJ=ac.Fly(ax,aC,nil,ay,{Speed=Option'Speed'or 300,
Unboosted=Option'No grapple speed',Rise=Option'Rise speed',Turn=Option
"Turn speed",Launch=ad.Launch})if aH then aH()end av=false table.clear(ac.
SolidLasers)local aK=Root()local aL=if aK then(aK.Position-ay).Magnitude else
math.huge local aM=aJ and aL<=3 local aN=al(
[[%s, %s, %d points, %.0f studs (straight %.0f), planned in %.0fms, flew %.1fs, %.1f studs off, %d lagbacks%s]]
,if aM then'arrived'else'missed',aE,#aC,aF,(ay-az).Magnitude,1000*aD,am()-aI,aL,
ac._lagbacks,if aA~=''then', locked floors'..aA else'')print('waypoint:',aN)aa.
Menu.Notify('Waypoint',aN,if aM then'Success'else'Warning',6)end local function 
PlotAt(ax)for ay,az in ae.List do if af.InWalls(az.Model,ax)then return az end
end return nil end local function Podium(ax,ay)local az=ax:FindFirstChild
'AnimalPodiums'if not az then return nil end local aA={}local aB=math.huge for
aC,aD in az:GetChildren()do local aE=aD:FindFirstChild('Spawn',true)if tonumber(
aD.Name)and aE and aE:IsA'BasePart'then aA[#aA+1]={Name=aD.Name,At=aE.Position}
aB=math.min(aB,math.abs(aE.Position.Y-ay.Y))end end local aC,aD=math.huge for aE
,aF in aA do local aG=((aF.At-ay)*Vector3.new(1,0,1)).Magnitude if math.abs(aF.
At.Y-ay.Y)<=aB+3 and aG<aC then aD,aC=aF.Name,aG end end return aD end local 
function Enter(ax,ay)if av then ah.Cancel()return end local az=Podium(ax.Model,
ay)if not az then aa.Menu.Notify('Waypoint','No podium in that base','Warning',3
)return end av=true local aA='Clone'ah.Travel={Speed=Option'Speed',CloseSpeed=Option'Close speed',CloseDist=Option'Close distance',
Unboosted=Option'No grapple speed',Show=Option'Show path',Approach=Option
'Go to brainrot',Rise=Option"Rise speed",Turn=Option'Turn speed',BrainrotSpeed=
Option'Brainrot speed',Entry=Option'Approach',Delay=Option'Brainrot delay',Equip=0.6,Clone=Option'Use clone if flash has cooldown'or aA=='Clone',
Prefer=aA,Under=Option'Reach 2nd floor from 1st'~=false}local aB=am()local aC=ah
.Launch{Index='Waypoint',Slot=az,Plot=ax,Key='waypoint'}av=false local aD=Root()
local aE=aD~=nil and math.abs(aD.Position.Y-ay.Y)<=6 local aF=al(
'%s via podium %s, %s, %.1fs%s',if aC then'got in'else'didnt get in',az,
tostring(ah.Status),am()-aB,if aC and not aE then(if ao:FindFirstChild'Ledge'
then", on the ledge under the waypoint's floor"else
", ended below the waypoint's floor")else'')print('waypoint:',aF)aa.Menu.Notify(
'Waypoint',aF,if aC then'Success'else'Warning',6)if aC and aE then Fly()end end
local function SetHere()local ax=Root()if ax then SetGoal(ax.Position)end end aq
=ab.Categories.Steal:CreateAction{Name='Waypoint (DEV MODULE)',Tooltip=
'Sets the Teleport target to where you stand',Button='Set',Function=SetHere}aq:
CreateButton{Name='Pick with mouse',Function=Pick}aq:CreateButton{Name='Clear',
Function=function()as=nil Mark()aa.Menu.Notify('Waypoint',
'Cleared, Teleport goe⁠s for brainrots again','Info',3)end}aq:CreateButton{Name=
'Stop',Function=function()ac.Stop()end}ar=aq:CreateToggle{Name='Show marker',Default=true,Function=Mark}local ax=ab.Modules.Teleport if ax then local ay=ax.
Function ax.Function=function(...)if as then ad.ClearPaths()local az=PlotAt(as)
if az then Enter(az,as)else Fly()end return end ay(...)end aa.Clean(function()ax
.Function=ay end)end function aq.Goal()return as end function aq.Entry()if not
as then return nil end local ay=PlotAt(as)local az=ay and Podium(ay.Model,as)if
not ay or not az then return nil end return{Plot=ay,Slot=az,Index="the waypoint"
,Key='waypoint',Owner=ay.Owner}end return aq end function a.ai()local aa=a.cache
.ai if not aa then aa={c=__modImpl()}a.cache.ai=aa end return aa.c end end do
local function __modImpl()local aa=a.a()local ab=a.b()local ac=a.h()local ad=
math.pi local ae=math.cos local af=math.sin local ah=math.random local ai=math.
min local aj=task.defer local ak=task.delay local al=aa.Services.
ReplicatedStorage local am=aa.Services.RunService local an=aa.Services.Workspace
local ao=aa.LocalPlayer local ap={{Command="jumpscare",Effect='Victim'},{Command
='nightvision',Effect='Victim'},{Command='inverse',Effect='Victim'},{Command=
'balloon',Effect='Victim'},{Command='control',Effect='Victim'},{Command=
'control',Effect='Executor'}}local aq local ar=function()end local as={}local at
local au=(setmetatable({},{__mode='k'}))local av=(setmetatable({},{__mode='k'}))
local aw=(setmetatable({},{__mode='k'}))local ax=0 local ay=0 local az=0 local
aA=false local aB=RaycastParams.new()aB.FilterType=Enum.RaycastFilterType.
Exclude local function SetCommands(aC)local aD=aa.Require((al:WaitForChild
'Datas':WaitForChild'AdminCommands'))for aE,aF in ap do local aG=aD[aF.Command]
local aH=aG and aG.effects if type(aH)~='table'then continue end local aI=as[aH]
or{}as[aH]=aI if aC and type(aH[aF.Effect])=='function'and not aI[aF.Effect]then
aI[aF.Effect]=aH[aF.Effect]aH[aF.Effect]=ar elseif not aC and aI[aF.Effect]then
aH[aF.Effect]=aI[aF.Effect]aI[aF.Effect]=nil end end end local function 
CarpetFlying(aC)return aC:FindFirstChild('FlightPower',true)~=nil or aC:
FindFirstChild('FlightSpin',true)~=nil end local function CaptureBody(aC)local
aD=aC:FindFirstChildOfClass'Humanoid'if not aD or aC~=ao.Character then return
end at=nil table.clear(au)table.clear(av)table.clear(aw)aA=ao:GetAttribute
'GiantPotion'~=nil if aA then return end at=aD.HipHeight for aE,aF in aC:
GetDescendants()do if aF:IsA'BasePart'then au[aF]=aF.Size aw[aF]=aF.Transparency
elseif aF:IsA'Attachment'then av[aF]=aF.CFrame elseif aF:IsA'Decal'then aw[aF]=
aF.Transparency end end end local function Recapture(aC,aD,aE)local aF,aG,aH=ac.
Character()if not aA or not aq.Enabled or not aF or not aG or not aH then return
end if ao:GetAttribute'GiantPotion'~=nil then return end if(aH.HipHeight==aC and
aG.Size==aD)or aE>=20 then CaptureBody(aF)return end ak(0.15,Recapture,aH.
HipHeight,aG.Size,1+aE)end local function KillForces(aC)for aD,aE in aC:
GetDescendants()do if aE:IsA'VectorForce'then aE:Destroy()end end end local 
function FixPhysics(aC,aD)if os.clock()-ax>0.25 then ax=os.clock()KillForces(aC)
end local aE=(aC:FindFirstChild'HumanoidRootPart')if aE and aD.PlatformStand and
not CarpetFlying(aC)and not ac.Posing then aD.PlatformStand=false local aF=aE.
AssemblyLinearVelocity if aF.Y>5 then aE.AssemblyLinearVelocity=Vector3.new(aF.X
,0,aF.Z)end aD:ChangeState(Enum.HumanoidStateType.GettingUp)end if ao:
GetAttribute'GiantPotion'~=nil then return end local aF=aC:GetAttribute
'NewHipHeight'local aG=if type(aF)=='number'then aF else at if aG and aD.
HipHeight~=aG then aD.HipHeight=aG end for aH,aI in au do if aH.Parent and aH.
Size~=aI then aH.Size=aI end end for aH,aI in av do if aH.Parent and aH.CFrame~=
aI then aH.CFrame=aI end end end local function MorphOf(aC)local aD=aC:
FindFirstChild'HumanoidRootPart'local aE=aC:FindFirstChild'Head'if not aD or not
(aE and aE:IsA'BasePart'and aE.Transparency>=1)then return nil end local aF=aD:
GetChildren()for aG,aH in aF do if not aH:IsA'WeldConstraint'then continue end
local aI=if aH.Part0==aD then aH.Part1 else aH.Part0 local aJ=aI and aI.Parent
if aJ and aJ:IsA"Model"and aJ.Parent==aC then return aJ end end return nil end
local function FixMorph(aC)local aD=MorphOf(aC)if aD then ay=os.clock()+65 aD:
Destroy()end if os.clock()>ay then return end for aE,aF in aw do local aG=aE if
aG.Parent and aG.Transparency~=aF then aG.Transparency=aF end end end local 
function EscapeJail(aC)if aC.Name~='Part'or not aC:IsA'BasePart'or not aC.
Anchored then return end local aD=aC.Size local aE,aF=ac.Character()if not aE or
not aF or ai(aD.X,aD.Y,aD.Z)>0.5 then return end if(aC.Position-aF.Position).
Magnitude>12 or os.clock()-az<1 then return end az=os.clock()local aG=aF.
Position local aH={aE}for aI,aJ in an:GetChildren()do if aJ.Name=='Part'and aJ:
IsA'BasePart'and(aJ.Position-aG).Magnitude<=12 then aH[#aH+1]=aJ end end aB.
FilterDescendantsInstances=aH local aI=ah()*ad*2 local aJ=aG+Vector3.new(ae(aI),
0,af(aI))*10 for aK=0,7 do local aL=aI+aK*ad/4 local aM=Vector3.new(ae(aL),0,af(
aL))*10 if not an:Raycast(aG,aM,aB)then aJ=aG+aM break end end aF.CFrame=CFrame.
new(aJ)*aF.CFrame.Rotation end local function WatchBody(aC)aq:Clean(aC.
DescendantAdded:Connect(function(aD)if aD:IsA'VectorForce'then aj(aD.Destroy,aD)
end end))end aq=ab.Categories.Utility:CreateModule{Name='AntiAdmin',Tooltip=
'Blocks admi⁠n commands',Function=function(aC)if not aC then return end
SetCommands(true)aq:Clean(function()SetCommands(false)end)local aD=ao.Character
if aD then WatchBody(aD)CaptureBody(aD)end aq:Clean(ao.CharacterAdded:Connect(
function(aE)WatchBody(aE)ak(0.2,CaptureBody,aE)end))aq:Clean(ao:
GetAttributeChangedSignal'GiantPotion':Connect(function()if aA and ao:
GetAttribute'GiantPotion'==nil then ak(0.15,Recapture,nil,nil,0)end end))aq:
Clean(an.ChildAdded:Connect(EscapeJail))aq:Clean(am.Heartbeat:Connect(function()
local aE,aF,aG=ac.Character()if not aE or not aG then return end FixPhysics(aE,
aG)FixMorph(aE)end))end}return aq end function a.aj()local aa=a.cache.aj if not
aa then aa={c=__modImpl()}a.cache.aj=aa end return aa.c end end do local 
function __modImpl()local aa=a.a()local ab=a.b()local ac=task.wait local ad=aa.
Services.RunService local ae=aa.Services.StarterGui local af=aa.LocalPlayer
local ah=Enum.HumanoidStateType.Dead local ai local aj=false local function 
GetHumanoid()local ak=af.Character return ak and ak:FindFirstChildOfClass
"Humanoid"end local function Reset()local ak=GetHumanoid()if not ak then return
end aj=true ak:SetStateEnabled(ah,true)ak.Health=0 ak:ChangeState(ah)end local 
function SetResetCallback(ak)while ai.Enabled and not pcall(ae.SetCore,ae,
'ResetButtonCallback',ak)do ac(0.5)end end ai=ab.Categories.Utility:CreateModule
{Name='AntiDeath',Tooltip='Keeps you alive',Function=function(ak)if not ak then
return end local al=ai:Clean(Instance.new'BindableEvent')ai:Clean(al.Event:
Connect(Reset))ai:Clean(function()pcall(ae.SetCore,ae,'ResetButtonCallback',true
)local am=GetHumanoid()if am then am:SetStateEnabled(ah,true)end end)ai:Clean(af
.CharacterAdded:Connect(function()aj=false end))ai:Clean(ad.Heartbeat:Connect(
function()local am=GetHumanoid()if not am or aj then return end if am:
GetStateEnabled(ah)then am:SetStateEnabled(ah,false)end if am.Health<am.
MaxHealth then am.Health=am.MaxHealth end end))SetResetCallback(al)end}return ai
end function a.ak()local aa=a.cache.ak if not aa then aa={c=__modImpl()}a.cache.
ak=aa end return aa.c end end do local function __modImpl()local aa=a.a()local
ab=a.b()local ac=a.n()local ad=a.h()local ae=string.find local af=task.defer
local ah=task.delay local ai=debug.getconstants local aj=debug.setconstant local
ak=aa.Services.ReplicatedStorage local al=aa.Services.RunService local am=aa.
LocalPlayer local an={{Source='FlashbangController',Effects={Flashbang=true}},{
Source='BeeLauncherController',Effects={['Bee Attack']=true}},{Source=
"BoogieBombController",Effects={Boogie=true}},{Source='PaintballGunController',
Effects={PaintballHitted=true}},{Source='CandyBombController',Effects={
CandyEffect=true}},{Source='CandyLauncherController',Effects={TurnIntoJelly=true
}},{Source='ConfettiLauncherController',Effects={["Confetti Launcher"]=true}},{
Source='FireExtinguisherController',Effects={['Fire Extinguisher']=true}},{
Source='SummerSoakerController',Effects={IcedWalk=true}},{Source=
'PumpkinLauncherController',Effects={TurnIntoPumpkinHead=true}},{Source=
'PhoenixPetController',Effects={SpawnPhoenix=true,CreatePhoenixShoot=true}},{
Source='ZombieBlasterController',Effects={FireZombieBlaster=true}},{Source=
'RadioactiveAirstrikeController',Effects={DropBombsAt=true,
CreateRadioctivatePuddles=true}},{Source='ChristmasLauncherController',Effects={
FireChristmasLauncher=true}},{Source='CandycaneBowController',Effects={
FireCandycaneBow=true}},{Source='TrapController',Effects={Trapped=true}}}local
ao={AlignOrientation=true,AlignPosition=true,BallSocketConstraint=true,SpringConstraint=true,WeldConstraint=true,RopeConstraint=true}local ap={
RootAttachment=true,RootRigAttachment=true}local aq={'CartSeated','TrainSeated',
'SleighSeated'}local ar local as=(setmetatable({},{__mode='k'}))local at={}local
au local av local aw=0 local ax=0 local ay=0 local az=false local aA=false local
aB={}local function Match(aC)local aD=as[aC]if aD~=nil then return aD or nil end
local aE=debug.info(aC,'s')for aF,aG in an do if ae(aE,aG.Source,1,true)then as[
aC]=aG return aG end end as[aC]=false return nil end local function Patch(aC,aD)
if at[aC]then return end local aE={}for aF,aG in ai(aC)do if type(aG)=='string'
and aD[aG]then aj(aC,aF,"__blocked")aE[aF]=aG end end if next(aE)~=nil then at[
aC]=aE end end local function Unpatch()for aC,aD in at do for aE,aF in aD do aj(
aC,aE,aF)end end table.clear(at)end local function Sweep()local aC={al.
RenderStepped}local aD=ac.Event'UseItem'local aE=ac.Event'SetInputEnabled'if aD
then aC[#aC+1]=aD.OnClientEvent end if aE then aC[#aC+1]=aE.OnClientEvent end
for aF,aG in aC do for aH,aI in getconnections(aG)do local aJ=aI.Function local
aK=aJ and Match(aJ)if aK then Patch(aJ,aK.Effects)end end end end local function 
RestoreInput()if aa.Lite then return end if not au then local aC=aa.Require((ak:
WaitForChild'Controllers':WaitForChild'CharacterController'))au=aC.Controls av=
aC.originalMoveFunction end au.moveFunction=av end local aC={InverseControls=
true,Freeze=true,FreezeLocalMovement=true}local function Lift(aD,aE)local aF=aD:
GetAttribute(aE)if aC[aE]and aF~=nil and aF~=false and aF~=0 then aD:
SetAttribute(aE,nil)end end local function WatchAttributes(aD)for aE in aC do
Lift(aD,aE)end return aD.AttributeChanged:Connect(function(aE)Lift(aD,aE)end)end
local function Foreign(aD,aE)if aD:IsA'WeldConstraint'or aD:IsA'Weld'then local
aF=(aD).Part0 local aG=(aD).Part1 return(nil~=aF and not aF:IsDescendantOf(aE))
or(aG~=nil and not aG:IsDescendantOf(aE))end if aD:IsA'Constraint'then local aF=
aD.Attachment0 and aD.Attachment0.Parent local aG=aD.Attachment1 and aD.
Attachment1.Parent return(aF~=nil and not aF:IsDescendantOf(aE))or(aG~=nil and
not aG:IsDescendantOf(aE))end return false end local function Held(aD,aE)for aF,
aG in aE:GetJoints()do if Foreign(aG,aD)then return true end end return false
end local function KillJoint(aD)if aD:IsA'Constraint'then aD.Enabled=false end
aD:Destroy()end local function BreakHolds(aD,aE)for aF,aG in aE:GetJoints()do if
Foreign(aG,aD)then KillJoint(aG)end end if os.clock()-ax<=0.2 then return end ax
=os.clock()for aF,aG in aD:GetDescendants()do if not aG:IsA'BasePart'then
continue end for aH,aI in aG:GetJoints()do if Foreign(aI,aD)then KillJoint(aI)
end end end for aF,aG in aE:GetChildren()do if aG:IsA'Attachment'and not ap[aG.
Name]then aG:Destroy()end end end local function SitEscape(aD,aE,aF)if az or os.
clock()-ay<0.6 then return end az=true ay=os.clock()aE.Sit=true aE.PlatformStand
=false aF.Anchored=false local aG=aF:FindFirstChild'WebTargetAttch'if aG then aG
:Destroy()end for aH,aI in aD:GetDescendants()do if ao[aI.ClassName]then aI:
Destroy()end end aE:ChangeState(Enum.HumanoidStateType.Running)ah(0.15,function(
)aE.Sit=false aE.PlatformStand=false aE:ChangeState(Enum.HumanoidStateType.
GettingUp)az=false end)end local function SetHeavy(aD,aE)if aE==aA then return
end aA=aE if aE and aD then for aF,aG in aD:GetDescendants()do if aG:IsA
'BasePart'then aB[aG]={aG.CustomPhysicalProperties,aG.Massless}aG.Massless=false
aG.CustomPhysicalProperties=PhysicalProperties.new(100,0.3,0.5)end end return
end for aF,aG in aB do if aF.Parent then aF.CustomPhysicalProperties=aG[1]aF.
Massless=aG[2]end end table.clear(aB)end local function CarpetFlying(aD)return
aD:FindFirstChild('FlightPower',true)~=nil or aD:FindFirstChild('FlightSpin',
true)~=nil end local function Seated(aD)if aD.Sit or aD.SeatPart then return
true end for aE,aF in aq do if am:GetAttribute(aF)then return true end end
return false end local function Unstuck()local aD=am.Character local aE=aD and
aD:FindFirstChildOfClass"Humanoid"local aF=aD and(aD:FindFirstChild
'HumanoidRootPart')if not aD or not aE or not aF or aE.Health<=0 or
CarpetFlying(aD)then return end if(not az and Seated(aE))or am:GetAttribute
'Stealing'then return end local aG=am:GetAttribute'Web'local aH=aD:GetAttribute
'InGummy'or am:GetAttribute'InGummy'local aI=aE:GetAttribute
"FreezeLocalMovement"or am:GetAttribute'FreezeLocalMovement'local aJ=Held(aD,aF)
local aK=not aH and(nil~=aG or aJ)SetHeavy(aD,aK)if aA then local aL=aE.
MoveDirection local aM=aF.AssemblyLinearVelocity aF.AssemblyLinearVelocity=
Vector3.new(aL.X*aE.WalkSpeed,aM.Y,aL.Z*aE.WalkSpeed)end if not aH and not aK
and os.clock()>=aw and nil==aI then return end if aG and not aH and aJ then
SitEscape(aD,aE,aF)end if az then return end if aE.PlatformStand and not ad.
Posing then aE.PlatformStand=false end if aF.Anchored then aF.Anchored=false end
if am:GetAttribute'BlockTools'then am:SetAttribute('BlockTools',nil)end if aI
then aE:SetAttribute('FreezeLocalMovement',nil)am:SetAttribute(
'FreezeLocalMovement',nil)end if am:GetAttribute'NoMouseLockOffset'then am:
SetAttribute('NoMouseLockOffset',nil)end if aE:GetState()==Enum.
HumanoidStateType.Physics then aE:ChangeState(Enum.HumanoidStateType.GettingUp)
end BreakHolds(aD,aF)end ar=ab.Categories.Utility:CreateModule{Name=
'AntiEffects',Tooltip='Blocks ite⁠m effects',Function=function(aD)if not aD then
return end aw=0 ar:Clean(function()Unpatch()SetHeavy(am.Character,false)end)
local aE=ac.Event'UseItem'if aE then ar:Clean(aE.OnClientEvent:Connect(function(
aF)if aF=='Trapped'then aw=os.clock()+8 end end))end local aF=ac.Event
'SetInputEnabled'if aF then ar:Clean(aF.OnClientEvent:Connect(function(aG)if not
aG then af(RestoreInput)end end))end ar:Clean(WatchAttributes(am))local function 
FreeJump()local aG=am:GetAttribute'JumpModifier'if type(aG)=='number'and aG<1
then am:SetAttribute('JumpModifier',nil)end end FreeJump()ar:Clean(am:
GetAttributeChangedSignal'JumpModifier':Connect(FreeJump))local aG={
FloatVelocity=true,SLEEPY_VFX_ATTACHMENT=true,HitEffect=true,TEMP_Halo=true}
local function Junk(aH)if aG[aH.Name]or aH:IsA'ParticleEmitter'or aH:IsA
'Highlight'then return true end if aH:IsA'Attachment'then return aH.Name:match
'^FlareAttachment'~=nil or(aH.Parent~=nil and aH.Parent:IsA'Attachment')end if
aH:IsA'LinearVelocity'then local aI=aH.Attachment0 return aH.
VelocityConstraintMode~=Enum.VelocityConstraintMode.Line and aI~=nil and aI.Name
:sub(1,5)=='Float'end return aH:IsA'Sound'and aH.Parent~=nil and aH.Parent.Name
=='HumanoidRootPart'and aH.Name:lower():find'slap'~=nil end local aH local aI
local function WatchBody(aJ)if aH then aH:Disconnect()aH=nil end if aI then aI:
Disconnect()aI=nil end if not aJ then return end for aK,aL in aJ:GetDescendants(
)do if aL.Parent and Junk(aL)then aL:Destroy()end end aH=aJ.DescendantAdded:
Connect(function(aK)af(function()if aK.Parent and Junk(aK)then aK:Destroy()end
end)end)aI=WatchAttributes(aJ)end WatchBody(am.Character)ar:Clean(function()
WatchBody(nil)end)ar:Clean(am.CharacterAdded:Connect(function(aJ)aA=false table.
clear(aB)WatchBody(aJ)end))Sweep()local aJ=0 ar:Clean(al.Heartbeat:Connect(
function(aK)Unstuck()aJ+=aK if aJ>=0.3 then aJ=0 Sweep()end end))end}return ar
end function a.al()local aa=a.cache.al if not aa then aa={c=__modImpl()}a.cache.
al=aa end return aa.c end end do local function __modImpl()local aa=a.a()local
ab=a.b()local ac=task.wait local ad=task.spawn local ae=aa.Services.
ReplicatedStorage local af local ah=function()end local ai local function Combat
()return(aa.Require(ae:WaitForChild'Controllers':WaitForChild'CombatController')
)end local function Hold(aj)local ak=aj.ApplyImpulse if ak==ah then return end
if not isexecutorclosure(ak)then ai=ak end aj.ApplyImpulse=ah end af=ab.
Categories.Utility:CreateModule{Name='AntiKnockback',Tooltip='Stops kno⁠ckback',
Function=function(aj)if not aj or aa.Lite then return end local ak=Combat()if
not af.Enabled then return end Hold(ak)af:Clean(ad(function()while ac(1)do Hold(
ak)end end))af:Clean(function()if ai and ak.ApplyImpulse==ah then ak.
ApplyImpulse=ai end end)end}return af end function a.am()local aa=a.cache.am if
not aa then aa={c=__modImpl()}a.cache.am=aa end return aa.c end end
do local 
function __modImpl()local aa=a.a()local ab=a.b()local ac=a.h()local ad=string.
sub local ae=string.find local af=math.max local ah=task.defer local ai=task.
delay local aj=task.spawn local ak=task.wait local al=aa.Services.RunService
local am=aa.Services.Workspace local an=aa.Services.ReplicatedStorage local ao=
aa.LocalPlayer local ap=Enum.HumanoidStateType.GettingUp local aq=Enum.
HumanoidStateType.Running local ar={[Enum.HumanoidStateType.Physics]=true,[Enum.
HumanoidStateType.Ragdoll]=true,[Enum.HumanoidStateType.FallingDown]=true}local
as={[Enum.HumanoidStateType.Physics]=true,[Enum.HumanoidStateType.Ragdoll]=true,
[Enum.HumanoidStateType.FallingDown]=true,[Enum.HumanoidStateType.
PlatformStanding]=true}local at={BallSocketConstraint=true,HingeConstraint=true}
local au local av local aw=(setmetatable({},{__mode='k'}))local ax=0 local ay
local az=true local aA={}local aB=(setmetatable({},{__mode='k'}))local aC=0
local aD=0 local aE=false local aF=0 local aG=false local aH={}local aI local aJ
local aK={}local aL local aM={}local function GetControls()if not av then local
aN=ao:WaitForChild'PlayerScripts':WaitForChild'PlayerModule'av=((aa.Require(aN))
):GetControls()end return av end local function Snapshot(aN)if aN~=ao.Character
then return end if ay==aN and(not az or ax>=10)then return end if ay~=aN then aB
=(setmetatable({},{__mode='k'}))end local aO=(setmetatable({},{__mode='k'}))
local aP=0 local aQ={}for aR,aS in aN:GetDescendants()do local aT=aS.ClassName
if at[aT]then aO[aS]=true aP+=1 elseif aT=='AnimationConstraint'then aQ[#aQ+1]=
aS end end aw,ax,ay=aO,aP,aN aA=aQ az=false end local function Learn()for aN,aO
in aA do if aO.Parent and aO.Enabled and aO.MaxTorque>0 then aB[aO]={aO.
MaxTorque,aO.MaxForce}end end end local function Broken()for aN,aO in aA do if
aO.Parent and(not aO.Enabled or aO.MaxTorque==0)then return true end end return
false end local function Restore()for aN,aO in aA do if aO.Parent then if not aO
.Enabled then aO.Enabled=true end if aO.MaxTorque==0 then local aP=aB[aO]aO.
MaxTorque=if aP then aP[1]else 3000 end end end end local function RigJoint(aN)
if aw[aN]then return true end local aO=aN.Name return ad(aO,-10)=='BallSocket'or
ad(aO,-6)=="Socket"end local function Left()local aN=ao:GetAttribute
'RagdollEndTime'return af(0,af(aC,if type(aN)=='number'then aN else 0)-am:
GetServerTimeNow())end local function Ragdolled(aN)return Left()>0 or ao:
GetAttribute'Ragdoll'==true or ar[aN:GetState()]or Broken()end local function 
Clear(aN)local aO=ao.Character if not aO then return end local aP=aO:
FindFirstChildOfClass'Humanoid'Restore()for aQ,aR in aO:GetChildren()do if aR:
IsA'BasePart'and aR.Anchored then aR.Anchored=false end end if aN then for aQ,aR
in aO:GetDescendants()do if at[aR.ClassName]then if not RigJoint(aR)then aR:
Destroy()end elseif aR:IsA'BasePart'and aR.Anchored then aR.Anchored=false end
end end if not aP then return end if not ac.Posing and(aP.PlatformStand or as[aP
:GetState()])then if aP.PlatformStand then aP.PlatformStand=false end pcall(aP.
ChangeState,aP,ap)pcall(aP.ChangeState,aP,aq)end if aa.Lite then return end
local aQ=am.CurrentCamera if aQ then if aQ.CameraType~=Enum.CameraType.Custom
then aQ.CameraType=Enum.CameraType.Custom end if aQ.CameraSubject~=aP then aQ.
CameraSubject=aP end end if ao.CameraMode==Enum.CameraMode.LockFirstPerson then
ao.CameraMode=Enum.CameraMode.Classic end if av then pcall(av.Enable,av)end end
local function OnRagdoll()if not au.Enabled then return end local aN=ao.
Character local aO=aN and aN:FindFirstChildOfClass'Humanoid'local aP=aO and aO:
GetState()local aQ=ao:GetAttribute'RagdollEndTime'local aR=if type(aQ)=='number'
then aQ else 0 if aR>am:GetServerTimeNow()then aC=af(aC,aR)end if not(aR>am:
GetServerTimeNow()or ao:GetAttribute'Ragdoll'==true or(aP~=nil and ar[aP]))then
return end aD=os.clock()+2 aG=false aE=true Clear(true)end local function Watch(
aN)if not aN:IsA'BasePart'then return end if aN.Anchored then aN.Anchored=false
end aK[#aK+1]=aN:GetPropertyChangedSignal'Anchored':Connect(function()if aN.
Anchored then aN.Anchored=false end end)end local function BindAnchors(aN)if aL
==aN then return end aa.Empty(aK)aL=aN aK[#aK+1]=aN.ChildAdded:Connect(Watch)for
aO,aP in aN:GetChildren()do Watch(aP)end end local function BindGuards(aN)local
aO=aN:FindFirstChildOfClass'Humanoid'if not aO or not aO:IsA'Humanoid'then
return end if aI==aN and aJ==aO then return end aa.Empty(aH)aI,aJ=aN,aO aG,az=
false,true Snapshot(aN)ai(1,function()if ao.Character==aN then Snapshot(aN)end
end)ai(3,function()if ao.Character==aN then Snapshot(aN)end end)local aP=false
aH[#aH+1]=aN.DescendantAdded:Connect(function(aQ)if ao.Character~=aN then return
end local aR=aQ.ClassName if at[aR]or aR=='AnimationConstraint'then az=true end
if not au.Enabled then return end if 'VectorForce'==aR or(at[aR]and not RigJoint(
aQ))then aD=os.clock()+2 aE=true if not aP then aP=true ah(function()aP=false if
ao.Character==aN and au.Enabled then Clear(true)end end)end end end)aH[#aH+1]=aN
.DescendantRemoving:Connect(function(aQ)local aR=aQ.ClassName if at[aR]or aR==
'AnimationConstraint'then az=true end end)aH[#aH+1]=(aO).StateChanged:Connect(
function(aQ,aR)if ao.Character==aN and ar[aR]then OnRagdoll()end end)end local 
function Connections(aN)local aO=#aM>0 for aP,aQ in aM do local aR,aS=pcall(
function()return aQ.Function end)if not aR or not aS then aO=false break end end
if aO then return aM end local aP={}local aQ=an:FindFirstChild'Packages'local aR
=aQ and aQ:FindFirstChild'Net'if not aR or type(getconnections)~='function'then
return aP end for aS,aT in aR:GetChildren()do if not aT:IsA'RemoteEvent'then
continue end local aU,aV=pcall(getconnections,(aT).OnClientEvent)if not aU or
type(aV)~='table'then continue end for aW,aX in aV do local aY=aX.Function local
aZ,a_=pcall(debug.info,aY,'s')if aY and aZ and type(a_)=='string'and ae(a_,aN,1,
true)then aP[#aP+1]=aX end end end aM=aP return aP end local function Cut(aN)
local aO=Connections'RagdollController'if#aO==0 then return false end for aP,aQ
in aO do pcall(function()if aN then aQ:Enable()else aQ:Disable()end end)end
return true end au=ab.Categories.Utility:CreateModule{Name='AntiRagdoll',Tooltip
='Stops you from ragdolling',Function=function(aN)if not aN then Cut(true)aa.
Empty(aH)aa.Empty(aK)aI,aJ,aL=nil,nil,nil return end if not aa.Lite then
GetControls()end if not au.Enabled then return end au:Clean(function()Cut(true)
aa.Empty(aH)aa.Empty(aK)aI,aJ,aL=nil,nil,nil end)au:Clean(ao.CharacterAdded:
Connect(function(aO)aC,aD,aE,aG=0,0,false,false BindAnchors(aO)BindGuards(aO)end
))if ao.Character then BindAnchors(ao.Character)BindGuards(ao.Character)end au:
Clean(ao:GetAttributeChangedSignal'RagdollEndTime':Connect(OnRagdoll))au:Clean(
ao:GetAttributeChangedSignal'Ragdoll':Connect(OnRagdoll))Cut(false)au:Clean(aj(
function()while true do ak(2)if au.Enabled then Cut(false)end end end))au:Clean(
aj(function()while true do ak(0.1)if not au.Enabled then continue end local aO=
ao:GetAttribute'RagdollEndTime'local aP=if type(aO)=='number'then aO else 0 if
aP>am:GetServerTimeNow()then aC=af(aC,aP)ao:SetAttribute('RagdollEndTime',0)aD=
os.clock()+2 end if os.clock()<aD then Clear(false)end end end))au:Clean(al.
Heartbeat:Connect(function()local aO=ao.Character local aP=aO and aO:
FindFirstChildOfClass'Humanoid'if not aO or not aP or not aO:FindFirstChild
'HumanoidRootPart'then return end local aQ=os.clock()if Ragdolled(aP)then aD=aQ+
1 end if aQ<aD+0.7 then local aR=aE or(aQ-aF)>0.5 if aR then aE,aF=false,aQ end
Clear(aR)else Learn()if not aG then aG=true Snapshot(aO)end end end))end}return
au end function a.an()local aa=a.cache.an if not aa then aa={c=__modImpl()}a.
cache.an=aa end return aa.c end end do local function __modImpl()local aa=a.a()
local ab=a.b()local ac=a.n()local ad=a.h()local ae=math.clamp local af=math.min
local ah=task.spawn local ai=task.wait local aj=aa.Services.RunService local ak=
aa.LocalPlayer local al='Body Swap Potion'local am=55 local an=0.6 local ao
local ap=0 local aq local ar=0 local as={}local at={}local au={}local av={}local 
function SwapBack(aw)local ax,ay,az=ad.Character()local aA=ad.FindTool(al)local
aB=ac.Event'UseItem'if not ax or not ay or not az or not aA or not aB then
return end if((aA:GetAttribute'CooldownTime'or 0))>0 then return end local aC=ax
:FindFirstChildOfClass'Tool'if aC==aA then aC=nil end if not ad.Equip(aA)then
return end ai(ae(ak:GetNetworkPing(),0.03,0.2))local aD=ay.Position aB:
FireServer(aw)local aE=os.clock()+0.8 while ay.Parent and(ay.Position-aD).
Magnitude<3 and os.clock()<aE do ai()end if aC and aC.Parent then az:EquipTool(
aC)else az:UnequipTools()end end local aw local function Swapped(ax,ay)for az,aA
in ax.Seen do local aB=at[az]local aC=(aA-ax.From).Magnitude if not aB or aC>am
or(aB-aA).Magnitude<3 then continue end local aD=av[az]local aE=aD~=nil and ay-
aD<=6 local aF=(if aE then ae(aC*0.25,1.5,5)else 2.5)+ax.Slack if(ax.To-aA).
Magnitude<=aF and(aB-ax.From).Magnitude<=aF then return az end end return nil
end local function Step()local ax,ay=ad.Character()if not ay then aq,aw=nil,nil
table.clear(as)table.clear(au)return end local az=os.clock()table.clear(at)for
aA,aB in ad.List do local aC=aB.Root if aB.Local or not aC or not aC.Parent then
continue end at[aA]=aC.Position local aD=ad.Holding(aA)if aD and aD.Name==al
then av[aA]=az end end local aA=ay.Position local aB=if aq then(aA-aq).Magnitude
else 0 if aq and 3<=aB and az-ap>=2 then aw={From=aq,To=aA,Seen=table.clone(au),
Slack=1+ar,Until=az+an}end local aC=aw if aC then local aD=Swapped(aC,az)if aD
then aw,ap=nil,az av[aD]=nil ah(SwapBack,aD)elseif az>aC.Until then aw=nil end
end aq=aA ar=af(aB,15)au,as,at=as,at,au end ao=ab.Categories.Utility:
CreateModule{Name='AntiSwap',Tooltip='Undoes bo⁠dy swaps',Function=function(ax)if
not ax then return end ao:Clean(function()aq,aw=nil,nil table.clear(as)table.
clear(at)table.clear(au)table.clear(av)end)ao:Clean(ad.Removed:Connect(function(
ay)av[ay.Player]=nil end))ao:Clean(aj.Heartbeat:Connect(Step))end}return ao end
function a.ao()local aa=a.cache.ao if not aa then aa={c=__modImpl()}a.cache.ao=
aa end return aa.c end end  do local function __modImpl()local ab=a.b()return ab.Categories.Utility:CreateModule{Name='ClickToAp',Tooltip='Click a player to run the next command of your Order',Function=function()end}end function a.aq()local aa=a.cache.aq if not aa then aa={c=__modImpl()}a.cache.aq=aa end return aa.c end end do local function __modImpl()local aa=a.a()local
ab=a.b()local ac=a.y()local ad=a.h()local ae=string.format local af=task.spawn
return ab.Categories.Utility:CreateAction{Name='CloneIn',Tooltip=
'Swaps to a clone where you stand',Function=function()if not ad.FindTool
'Quantum Cloner'then aa.Menu.Notify('CloneIn','No Quantum Cloner','Warning',3)
return end local ah=ac.Left()if 0.15<ah then aa.Menu.Notify('CloneIn',ae(
'On cooldown, wait %.1fs',ah),'Warning',3)return end aa.Menu.Notify('CloneIn',
'Placin⁠g clone','Info',2)af(function()local ai,aj=ac.Here()if not ai then aa.
Menu.Notify('CloneIn','Clone f⁠ailed: '..(aj or'never placed'),'Warning',3)end
end)end}end function a.ar()local aa=a.cache.ar if not aa then aa={c=__modImpl()}
a.cache.ar=aa end return aa.c end end do local function __modImpl()local aa=a.a(
)local ab=a.b()local ac=task.wait local ad=aa.Services.RunService local ae=aa.
LocalPlayer local af=Vector3.new(0,10000,0)local ah=5 local ai local aj=false
local function GetRoot()local ak=ae.Character return ak and(ak:FindFirstChild
'HumanoidRootPart')end local function Fling()local ak=os.clock()local al=0.1
repeat ad.Heartbeat:Wait()local am=GetRoot()if not am then break end local an=am
.AssemblyLinearVelocity am.AssemblyLinearVelocity=an*10000+af ad.PreRender:Wait(
)am=GetRoot()if am then am.AssemblyLinearVelocity=an end ad.Stepped:Wait()am=
GetRoot()if am then am.AssemblyLinearVelocity=an+Vector3.new(0,al,0)al=-al end
until not ae:GetAttribute'Stealing'or os.clock()-ak>ah end ai=ab.Categories.
Utility:CreateAction{Name='DropBrainrot',Tooltip='Drops your brainrot',Function=
function()if aj or not ae:GetAttribute'Stealing'then return end local ak=ab.
Modules.Invisible local al=ak~=nil and ak.Enabled if al then ak:Toggle(false)ac(
0.1)end aj=true local am,an=pcall(Fling)aj=false if al then ak:Toggle(true)end
local ao=GetRoot()if ao then ao.AssemblyLinearVelocity=Vector3.zero ao.
AssemblyAngularVelocity=Vector3.zero end if not am then warn('drop failed:',an)
end end}return ai end function a.as()local aa=a.cache.as if not aa then aa={c=
__modImpl()}a.cache.as=aa end return aa.c end end do local function __modImpl()
local aa=a.a()local ab=a.b()local ac=a.af()local ad=string.match local ae=string
.find local af=task.spawn local ah=task.defer local ai=task.wait local aj=aa.
Services.HttpService local ak=
[[_|WARNING:-DO-NOT-SHARE-THIS.--Sharing-this-will-allow-someone-to-log-in-as-you-and-to-steal-your-ROBUX-and-items.|_CAEQAhoGCAIQBBgBIhoKBGR1aWQSEjEyMzA3MjE0ODA4MjA0MTUxOCIZCgV1bmFtZRIQR2l1ZGFSb3R1bmRvMjAxNSISCgN1aWQSCzExNzQ2ODkzMTcxKAM.WhFxGlj4icHt6_c06JJ0gHA_n8nDcXfX2lCJRmLOdaIF19pqaaVJObwb4zn7hIsRLyxIds_XmiwbzyG_TIHHRDJVeYDSoMgGYvunM61Oln0ctIFmljor4KXdV5brvyEU-G1KeaQNc0iZq3l8lF-1vX857mL67WW63dmvvR1hfEaEd2hfN3mkcXQLuo_9y_Nl8o-LNQVO0vGg9i2-vXNr5A7xgn4GrH3mAp9avuHMxYiNZ5Gp-cd-3RgwltgDQvTC64pBQajGgrPtYEkWX44lqdROsBTPWJLFsUO0RxwzvDsifRETi6yy8GorbjJQqf9hDKwZVp5gEQf0D0lsv3h_5FVnvT_h_cltGOLBc4tchH9shJE1VL290DTchpCeYYy21qhOF2DSsQPu54tFCwWk0zKDCu3hyuNz-qRdZMpJVrjh_UJQyKq6IfZXjCrfr-FndkOBgJkdBcBWwOWU6RXn_HejXlk9iYNMWD6XgN7t9P-pt_FLO4obXa5vfr0NCZ9inyxJv3fSjW1TjdKCRBOX9vOgbu2prbBKzWjKKq-8xqlJ-9aOT1QdAmKSxTiKJ5Fq3ZdLP8zKeqjXo1Gl4d-m1JUXQ14dcg5YLICUUkiHdvd_aX_lQSLgUmt6fDQG_PIDhWFuuOWmfrbwEb_W1YAErV_plN1zs-9kaz9Na2nzhDzvAB0y-9uBWlgM4wE6yHOkYJo4HqFUm01jV9Tr4aW2s5ImEMsR-eeikKM5TzliehO3xpnk3a2F9ItqPb2pPchLs55ATO1i4hm58gSMpJt1LdJ5uJNAMgNSwdHfXtxJnwVD2S8Sx3Iv3BMJ6qoC5WB6Jii4ZmjQzkr26OeT2zjsXrn5lc_D1Z3P-qs6M8Wb0OXY27vxc3GEj0qyLGdKEOrkMK-2WGZIA51QL3R63ki6g5wnAzcvp0KO5aIMfgC3F_I.r-KGHdjULRaQcW29hZpdS-HZIFs]]
local al local am local function Headers(an)local ao={['Content-Type']=
'application/json',Cookie='.ROBLOSECURITY='..ak}for ap,aq in(an or{})do ao[ap]=
aq end return ao end local function Token()local an=request{Url=
'https://auth.roblox.com/v2/logout',Method='POST',Headers=Headers(),Body=''}
local ao=an.Headers or{}return ao['x-csrf-token']or ao['X-CSRF-TOKEN']or ao[
'X-Csrf-Token']end local function Resolve()local an=ad(am.Value,'code=([^&%s]+)'
)if not an then return false,'no code= in the link'end local ao=Token()if not ao
then return false,'auth failed'end local ap=request{Url=
'https://apis.roblox.com/sharelinks/v1/resolve-link',Method='POST',Headers=
Headers{['X-CSRF-TOKEN']=ao},Body=aj:JSONEncode{linkId=an,linkType='Server'}}if
ap.StatusCode~=200 then return false,'link lookup failed ('..ap.StatusCode..')'
end local aq=aj:JSONDecode(ap.Body).privateServerInviteData if not aq or not aq.
linkCode or not aq.placeId then return false,'the link has no private server'end
aa.Services.ExperienceService:LaunchExperience{placeId=aq.placeId,linkCode=aq.
linkCode}return true,'joining'end local function Join()local an,ao=Resolve()if
not an then warn('private server join failed:',ao)end return an end local 
function JoinOrLeave()if not Join()then ac.Leave()end end al=ab.Categories.
Utility:CreateAction{Name='JoinPS',Tooltip='Joins your pri⁠vate server',Function=
function()af(Join)end}am=al:CreateTextBox{Name='Private server link',Placeholder
='Paste a private server share link'}al.Join=Join al.JoinOrLeave=JoinOrLeave ah(
function()if am.Value==''or ae(am.Value,'code=',1,true)then return end ai(1)warn
'the saved private server link has no code=, it wont work'end)return al end
function a.at()local aa=a.cache.at if not aa then aa={c=__modImpl()}a.cache.at=
aa end return aa.c end end do local function __modImpl()local aa=a.a()local ab=a
.b()local ac=a.af()return ab.Categories.Utility:CreateAction{Name='Rejoin',
Tooltip='Rejoins this server',Function=function()aa.Menu.Notify('Rejoin',
'Rejoining this server','Info',3)ac.Rejoin()end}end function a.au()local aa=a.
cache.au if not aa then aa={c=__modImpl()}a.cache.au=aa end return aa.c end end
do local function __modImpl()local aa=a.a()local ab=a.n()local ac=task.wait
local ad=aa.LocalPlayer local ae='Tools/Cooldown'local af=string.pack('<ff',272,
272)local ah=0.5 local ai={Busy=false}local aj=false function ai.Stop()aj=ai.
Busy end local ak local function GetRemote()if ak and ak.Parent then return ak
end ak=ab.Event(ae)return ak end local function Holding(al)return al:
FindFirstChildOfClass'Tool'~=nil end local function UnequipAll()local al=ad.
Character local am=al and al:FindFirstChildOfClass'Humanoid'if not al or not am
or not Holding(al)then return end local an=os.clock()+ah repeat am:UnequipTools(
)ac()until not Holding(al)or os.clock()>an ac(math.clamp(ad:GetNetworkPing(),
0.05,0.3))end function ai.Now(al,am)if ai.Busy then return false end local an=
GetRemote()if not an then return false end ai.Busy=true aj=false if not am then
UnequipAll()end local ao=ad.Character local ap=ao and ao:FindFirstChildOfClass
'Humanoid'local aq=os.clock()+(al or 8)while not aj and ad.Character==ao and not
(ap and ap.Health<=0)and os.clock()<aq do if not(an and an.Parent)then an=
GetRemote()end if an then an:FireServer(af)end ac()end ai.Busy=false return ad.
Character~=ao or(ap~=nil and ap.Health<=0)end return ai end function a.av()local
aa=a.cache.av if not aa then aa={c=__modImpl()}a.cache.av=aa end return aa.c end
end do local function __modImpl()local aa=a.a()local ab=a.b()local ac=a.av()
local ad=a.ae()local ae=a.o()local af=string.find local ah=task.spawn local ai=
task.wait local aj=aa.Services.StarterGui local ak=aa.LocalPlayer local al local
am local an local function InstaReset()if ac.Busy then return end ah(function()
local ao=ab.Modules.Invisible if ao and ao.Enabled then ao:Toggle(false)end ac.
Now()end)end aa.Clean(ad.Message:Connect(function(ao)if am and am.Enabled and
af(ao,'You will jump',1,true)then InstaReset()end end))local function 
HookResetButton(ao)local ap=true if ao then if not an then local aq=Instance.new
'BindableEvent'aq.Event:Connect(InstaReset)an=aq end ap=an end for aq=1,10 do if
pcall(aj.SetCore,aj,"ResetButtonCallback",ap)then return end ai(0.2)end end al=
ab.Categories.Utility:CreateAction{Name='Reset',Tooltip='Instantl⁠y resets you',
Function=function()ae.Abort()aa.Menu.Notify('Reset','Reset⁠ting','Info',1)
InstaReset()end}am={Enabled=true} aa.Clean(function()if an then pcall(aj.SetCore,aj,'ResetButtonCallback',true
)an:Destroy()end end)return al end function a.aw()local aa=a.cache.aw if not aa
then aa={c=__modImpl()}a.cache.aw=aa end return aa.c end end do local function 
__modImpl()local aa=a.a()local ab=a.b()local ac=a.af()return ab.Categories.
Utility:CreateAction{Name='ServerHop',Tooltip='Joins anot⁠her server',Function=
function()aa.Menu.Notify('ServerHop','Finding a new server','Info',3)if not ac.
Hop()then aa.Menu.Notify('ServerHop','No other server w⁠ith free slots','Warning'
,4)end end}end function a.ax()local aa=a.cache.ax if not aa then aa={c=
__modImpl()}a.cache.ax=aa end return aa.c end end   
do local function __modImpl()local aa=a.a()local ab=a.b()local ac=a.f()local ad=
a.B()local ae=a.v()local af=a.u()local ah=a.I()local ai=string.format local aj=
math.clamp local ak=math.floor local al=math.ceil local am=UDim2.new local an=
UDim2.fromOffset local ao=UDim2.fromScale local ap=Color3.fromRGB local aq=ac.
Theme local ar=ac.New local as=aq.Window local at=as:Lerp(aq.Accent,0.14)local
au=ap(150,230,170)local av=ap(255,214,102)local aw=ap(235,165,90)local ax=ap(200
,50,50)local ay=ap(220,160,0)local az=ap(120,180,255)local aA=ap(205,202,212)
local aB,aC,aD=56,4,7 local aE=aB+aC local aF=aD+1 local aG=ah.Mutations local 
function Headshot(aH)return ai('rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48',
aH)end local aH local function CarpetIcon()if not aH then local aI=aa.Services.
ReplicatedStorage:FindFirstChild'Items'local aJ=aI and aI:FindFirstChild
'Flying Carpet'local aK=if aJ and aJ:IsA'Tool'then aJ.TextureId else''aH=if aK~=
''then aK else"rbxassetid://223080070"end return aH end local _TD local _TL local function TraitInfo(n)if not _TL then _TL=true pcall(function()local d=aa.Services.ReplicatedStorage:FindFirstChild'Datas'local t=d and d:FindFirstChild'Traits'if t then _TD=require(t)end end)end local v=_TD and _TD[n]if type(v)=='table'then local ic=v.Icon if ic~=nil then ic=tostring(ic)if ic:match'^%d+$'then ic='rbxassetid://'..ic end end return ic,(if typeof(v.Color)=='Color3'then v.Color else nil),tostring(v.Display or n)end return nil,nil,tostring(n)end
local aI local aJ local aK local aL=(setmetatable({},{__mode='k'}))local aM=0 local function Order(aN)
local aO=aL[aN.Key]if not aO then aM+=1 aL[aN.Key]=aM return aM end return aO
end local function Before(aN,aO)if af.Before(aN,aO)then return true end if af.
Before(aO,aN)then return false end return Order(aN)<Order(aO)end local aN={}
local aO={}local aP local aQ local aR local aS=ac.Widget('Target Selection','Target',380,am(1,-396,0,60))local aT=aS.Body aT.AutomaticSize=Enum.
AutomaticSize.None aT.Size=am(1,0,0,aD*aE-aC+16)
do for _,_c in aS.Frame:GetChildren()do if _c:IsA'UICorner'then _c.CornerRadius=UDim.new(0,18)end end local _hd=aS.Top _hd.BackgroundTransparency=1 for _,_c in _hd:GetChildren()do if _c:IsA'ImageLabel'or _c:IsA'UIGradient'or(_c:IsA'Frame'and _c.Size.Y.Offset==1)then _c:Destroy()end end for _,_c in _hd:GetChildren()do if _c:IsA'TextLabel'then _c.Text='Steal Target'_c.Font=Enum.Font.GothamBold _c.TextSize=14 _c.TextXAlignment=Enum.TextXAlignment.Center _c.Position=an(0,0)_c.Size=am(1,0,1,-1)ar('Frame',{Position=an(14,39),Size=am(1,-28,0,1),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.7,BorderSizePixel=0},_hd)break end end end
local _lastNear=0
local function _syncTabs()end
local aU=ar('ScrollingFrame',
{Position=an(8,8),Size=am(1,-16,0,aD*aE-aC),AutomaticCanvasSize=Enum.
AutomaticSize.None,ScrollingDirection=Enum.ScrollingDirection.Y,
ScrollBarThickness=3,ScrollBarImageColor3=aq.Accent,ScrollBarImageTransparency=
0.45,VerticalScrollBarInset=Enum.ScrollBarInset.Always},aT)local aV=ar(
'TextLabel',{RichText=true,Size=ao(1,1),TextXAlignment=Enum.TextXAlignment.
Center,TextSize=12,TextColor3=aq.Sub,Text=ai(
[[<font size="14" color="%s" weight="semibold">Scanning this server</font>
Brainrots show up here as plots load]]
,ac.Hex(aq.Text))},aU)local function Avatar(aW,aX,aY)local aZ=ar('ImageLabel',{
AnchorPoint=Vector2.new(1,0.5),Position=am(1,aX,0,29),Size=an(12,12),
BackgroundTransparency=0,BackgroundColor3=aq.Field,Visible=false},aW)ac.Corner(
aZ)ar('UIStroke',{Thickness=1.25,Color=aY},aZ)return aZ end for aW=1,aF do local
aX=ar('TextButton',{Size=am(1,-6,0,aB),BackgroundColor3=aq.Edge,Visible=false},
aU)ac.Corner(aX,13)local aY={Button=aX,Label=ar('TextLabel',{RichText=true,Position=an(46,4),Size=am(1,-56,0,18),TextSize=11,TextColor3=aq.Sub,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,TextTruncate=Enum.TextTruncate.AtEnd},aX),Gen=ar('TextLabel',{RichText=true
,AnchorPoint=Vector2.new(1,0.5),Position=am(1,-10,0,14),Size=an(144,14),FontFace
=ac.Fonts.SemiBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right},aX),
Owner=Avatar(aX,-11,aq.Good),Thief=Avatar(aX,-28,aq.Bad),Entity=nil}aY.OwnerRing
=(aY.Owner:FindFirstChildOfClass'UIStroke')aY.ThiefRing=(aY.Thief:
FindFirstChildOfClass'UIStroke')aY.Info=ar('TextLabel',{RichText=true,Position=an(46,23),Size=am(1,-56,0,14),TextSize=11,TextColor3=aq.Sub,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,TextTruncate=Enum.TextTruncate.AtEnd},aX)aY.TBox=ar('Frame',{Position=an(46,39),Size=am(1,-56,0,14),BackgroundTransparency=1},aX)ar('UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Center},aY.TBox)aY.TI={}
aY.Outline=ar("UIStroke",{Color=ay,Thickness=1.5,Enabled=false,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},aX)aY.Sel=ar('UIStroke',{Color=Color3.fromRGB(255,0,0),Transparency=0,Thickness=5,LineJoinMode=Enum.LineJoinMode.Round,Enabled=false,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},aX)aY.Single=ar(
'TextLabel',{AnchorPoint=Vector2.new(1,0.5),Position=am(1,-10,0,16),Size=an(0,12
),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=0,BackgroundColor3=
ax,FontFace=ac.Fonts.SemiBold,TextSize=9,TextColor3=Color3.new(1,1,1),
TextXAlignment=Enum.TextXAlignment.Center,Text='1 OF 1',Visible=false},aX)ac.
Corner(aY.Single)ac.Padding(aY.Single,0,4)ar('UIStroke',{Color=ay,Thickness=1},
aY.Single)aX.Activated:Connect(function()local aZ=aY.Entity if aZ and aZ.Source
=='Road'then if aJ and aJ.Enabled then aJ.Choose(aZ.Key)if aJ.Selected(aZ.Key)
then ad.Picked,ad.Auto,ad.Paused=nil,nil,true end end aR()elseif aZ then ad.
Pick(aZ)if ad.Picked==aZ.Key and aJ and aJ.Release then aJ.Release()end aR()end
end)aY.Rank=ar('TextLabel',{Position=an(8,14),Size=an(28,28),BackgroundColor3=Color3.fromRGB(18,18,22),BackgroundTransparency=0.35,Font=Enum.Font.GothamBold,TextSize=13,TextColor3=aq.Text,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Text=''},aX)ar('UICorner',{CornerRadius=UDim.new(0,7)},aY.Rank)aO[aW]=aY end local function Bind(aW,aX,aY)aW.Entity=aX aW.Button.Visible=
true aW.Button.Position=an(0,(aY-1)*aE)local aZ=if aX.Source=='Road'then(aJ~=nil
and aJ.Enabled and aJ.Selected(aX.Key))else ad.Selected(aX)local a_=ad.Stolen(aX
)aW.Button.BackgroundColor3=if aZ then Color3.new(1,1,1)else aq.Edge aW.Button.BackgroundTransparency=if aZ then 0.8 else 1 aW.Sel.Enabled=aZ local a0=ai(
'<font size="13" color="%s" weight="semibold">%s</font>',ac.Hex(if a_ then aq.
Sub elseif aZ then aq.Text else aA),aX.Index)local a2=aX.Mutation if a2 and a2~=
'Default'and 'None'~=a2 then a0 ..=ai('\n<font color="%s">%s</font>',ac.Hex(aG[a2
]or aq.Sub),a2)end aW.Label.Text=a0 local a4=aX.Value local a5=if a4 and 0<a4
then ai('<font color="%s">%s</font>  ',ac.Hex(if a_ then aq.Sub else au),ah.
Price(a4))else''aW.Gen.Text=a5..ai('<font color="%s">%s</font>',ac.Hex(if a_
then aq.Sub else av),ah.Rate(aX.Income or 0))local a6=aX.OneOfOne==true aW.
Single.Visible=a6 aW.Outline.Enabled=a6 local a7=aX.Owner local a8=aX.Source==
'Road'aW.Owner.Visible=nil~=a7 or a8 aW.OwnerRing.Color=if a8 then aw else aq.
Good if a8 then aW.Owner.Image=CarpetIcon()elseif a7 then aW.Owner.Image=
Headshot(a7.UserId)end local a9=if a8 and type(aX.Buyer)=='number'then aX.Buyer
else nil aW.Thief.Visible=a_ or a9~=nil aW.ThiefRing.Color=if a9 then az else aq
.Bad if a9 then aW.Thief.Image=Headshot(a9)elseif a_ then aW.Thief.Image=
Headshot(aX.Steal)end
aW.Owner.Visible=false aW.Thief.Visible=false aW.Gen.Visible=false aW.Rank.Text='#'..aY aW.Rank.BackgroundTransparency=if aZ then 0 else 0.35 aW.Label.Font=Enum.Font.GothamMedium aW.Rank.BackgroundColor3=if aZ then Color3.fromRGB(240,240,244)else Color3.fromRGB(18,18,22)aW.Rank.TextColor3=if aZ then Color3.fromRGB(20,20,24)else aq.Text
do local _mu=aX.Mutation local _ow=aX.Owner
local _mp=if _mu and _mu~='Default'and _mu~='None'and _mu~=''then ai('<font color="%s">  \u{00B7}  %s</font>',ac.Hex(aG[_mu]or aq.Sub),tostring(_mu))else''
local _col=ac.Hex(if a_ then aq.Sub elseif aZ then aq.Text else aA)
aW.Label.Text=ai('<b><font color="%s">%s</font></b><font color="%s">  \u{00B7}  %s</font>%s%s',_col,tostring(aX.Index),ac.Hex(aq.Good),ah.Rate(aX.Income or 0),_mp,if aZ then' <font color="#7CFF8A">\u{2713}</font>'else'')
local _sl=if aX.Slot~=nil then'Slot '..tostring(aX.Slot)elseif a8 then'Carpet'else''
local _on=if _ow then' \u{00B7} @'.._ow.Name else''
aW.Info.Text=ai('%s<font color="%s">%s%s</font>',if a_ then'<font color="#FF2828"><b>Being Stole</b></font>  'else'',ac.Hex(aq.Sub),_sl,_on)
local _k=0
local _tr=aX.Traits
if type(_tr)=='table'then
for _kk,_t in _tr do
local _nm=if type(_t)=='string'then _t elseif type(_kk)=='string'and _t then _kk else nil
if _nm and _k<12 then
_k+=1
local _ic=aW.TI[_k]
if not _ic then
_ic=ar('ImageLabel',{LayoutOrder=_k,Size=an(14,14),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit},aW.TBox)
ar('TextLabel',{Name='T',Size=ao(1,1),Font=Enum.Font.GothamBold,TextSize=8,TextColor3=Color3.new(1,1,1),BackgroundTransparency=0.35,Visible=false},_ic)
aW.TI[_k]=_ic
end
local _img,_cc,_dn=TraitInfo(_nm)
_ic.Image=_img or''
local _tx=_ic:FindFirstChild'T'
if _tx then _tx.Visible=_img==nil _tx.Text=string.sub(_dn,1,2)_tx.BackgroundColor3=_cc or Color3.fromRGB(70,70,80)end
_ic.Visible=true
end
end
end
for _i=_k+1,#aW.TI do aW.TI[_i].Visible=false end
end end aP=function()local aW=ak(aU.CanvasPosition.Y/aE)+1 for
aX,aY in aO do local aZ=aW+aX-1 local a_=aN[aZ]if a_ then Bind(aY,a_,aZ)else aY.
Entity=nil aY.Button.Visible=false end end end aQ=function()aN=if aI and aI.
Enabled then ad.Ranked(true)else{}if aJ and aJ.Enabled and aJ.Accepts then for
aW,aX in ae.All(function(aW)return aW.Source=="Road"and aJ.Accepts(aW.Prompt,aW.
Index)end)do aN[#aN+1]=aX end end table.sort(aN,Before)if ad.Mode=='Nearest'then local _ch=aa.LocalPlayer.Character local _hr=_ch and _ch:FindFirstChild'HumanoidRootPart'if _hr then local _d={}for _,_e in aN do local _p=ae.Position(_e)_d[_e]=if _p then(_p-_hr.Position).Magnitude else math.huge end table.sort(aN,function(x,y)return _d[x]<_d[y]end)end end aU.CanvasSize=an(0,al(#aN
*aE-aC))aV.Visible=#aN==0 aP()end local aW=false aR=function()if aW or not aS.
Frame.Visible then return end aW=true task.defer(function()aW=false if aS.Frame.
Visible then aQ()end end)end aa.Clean(ae.Added:Connect(aR))aa.Clean(ae.Removed:
Connect(aR))aa.Clean(ae.Updated:Connect(aR))aa.Clean(ad.Changed:Connect(aR))aa.
Changed(aR)aU:GetPropertyChangedSignal'CanvasPosition':Connect(aP)local _sbF=ar('Frame',{Name='StealBar',AnchorPoint=Vector2.new(0.5,0),Size=an(300,64),BackgroundColor3=Color3.fromRGB(14,14,18),BackgroundTransparency=0,Visible=false},ac.Overlay)
ac.Stroke(_sbF)ac.Corner(_sbF,6)
local _sbBg=ar('ImageLabel',{Name='Bg',Size=ao(1,1),ZIndex=0,BackgroundTransparency=1,ImageTransparency=0.5,ScaleType=Enum.ScaleType.Crop,Visible=false},_sbF)_G.__SE_AddBg(_sbBg)ac.Corner(_sbBg,6)
ac.Place('StealBar',_sbF,_sbF,am(0.5,0,0,120))
local _sbT=ar('TextLabel',{Position=an(8,5),Size=am(1,-16,0,18),ZIndex=2,Font=Enum.Font.GothamBold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Center,TextTruncate=Enum.TextTruncate.AtEnd,TextColor3=Color3.new(1,1,1)},_sbF)
local _sbK=ar('Frame',{Position=an(8,27),Size=am(1,-16,0,20),BackgroundColor3=Color3.fromRGB(34,32,40),BorderSizePixel=0,ClipsDescendants=true},_sbF)ac.Corner(_sbK,5)
local _sbM=ar('Frame',{Size=ao(0,1),BackgroundColor3=Color3.fromRGB(122,92,255),BorderSizePixel=0},_sbK)ac.Corner(_sbM,5)
local _sbG=ar('Frame',{AnchorPoint=Vector2.new(1,0),Position=ao(1,0),Size=ao(0,1),BackgroundColor3=Color3.fromRGB(255,214,0),BorderSizePixel=0,Visible=false},_sbK)ac.Corner(_sbG,5)
local _sbP=ar('TextLabel',{Size=ao(1,1),ZIndex=3,Font=Enum.Font.GothamBold,TextColor3=Color3.new(1,1,1),TextSize=12,TextXAlignment=Enum.TextXAlignment.Center,Text='0%'},_sbK)
local _sbS=ar('TextLabel',{Position=an(8,48),Size=am(1,-16,0,12),ZIndex=2,Font=Enum.Font.GothamBold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Center,TextColor3=Color3.fromRGB(255,214,0),Text='',Visible=false},_sbF)
local _sbNo,_sbNoT=false,0
local function _sbTitle()
local e=ad.Entry if not(ad.Active and type(e)=='table')then e=ad.Target end
if type(e)~='table'then e=nil end
local nm=(e and e.Index)or ad.Name or'brainrot'
local mu=e and e.Mutation
local mt=if mu and mu~='Default'and mu~='None'and mu~=''then tostring(mu)else'Base'
local rt=if e and e.Income then ah.Rate(e.Income)else nil
return ai('%s %s%s',mt,tostring(nm),if rt then' \u{00B7} '..rt else'')
end
local function BarTick()
local now=os.clock()
if now-_sbNoT>0.5 then _sbNoT=now local ok,r=pcall(ad.Ranked,true)_sbNo=(not ok)or type(r)~='table'or #r==0 end
local GR=tonumber(ad.GrabMin)or 0.55 local HO=tonumber(ad.HoldMax)or 3
local lp=aa.LocalPlayer
local ch=lp.Character local hm=ch and ch:FindFirstChildOfClass'Humanoid'
local sv=lp:GetAttribute'Stealing'
local carry=sv~=nil and sv~=false
local gl=ad.GummyLeft()
local title,col,txt,sub='',Color3.new(1,1,1),'0%',nil
local main,grab=0,nil
if lp:GetAttribute'BlockTools'==true or gl>0 then
title=if gl>0 then ai('Gummy blocked %.1fs',gl)else'Gummy blocked' col=ap(255,170,80)
elseif hm and ad.Ragdolled(hm)then
local rl=ad.RagdollLeft() title=if rl>0 then ai('Ragdolled %.1fs',rl)else'Ragdolled' col=ap(255,170,80)
elseif carry then
title='Carrying Brainrot!' col=ap(150,230,170) main=1 txt='Carrying'
elseif ad.Active then
title=_sbTitle() local el=now-ad.Start
if el<GR then main=aj(el/GR,0,1) txt=ai('%.2fs / %.2fs',el,GR)
else local he=el-GR local gw=GR/(GR+HO) grab=gw main=(1-gw)*aj(he/HO,0,1) txt=ai('+%.1fs / %.1fs',he,HO) end
elseif ad.Busy and ad.Target then
title=_sbTitle() txt=tostring(ad.Status or'Going')
else
local a0=ad.Attempt local a2=nil~=aJ and aJ.Enabled and aJ.Chasing==true
local st=if a2 and not(aI and aI.Enabled and ad.Busy)then ai(if aJ.Following then'Following %s'else'Buying %s',aJ.Target or'brainrot')elseif not(aI and aI.Enabled)then'Waiting for a carpet brainrot'elseif a0 then(if a0.Confirmed then'Confirming delivery'else'Confirming grab')elseif ad.Busy or ad.Smart.Player then tostring(ad.Status)elseif ad.Camped then'Camped, no dwell'else'Waiting for target'
if _sbNo and aI and aI.Enabled and not ad.Busy then title='No items' col=ap(255,90,120) else title=st end
if ad.Paused then sub='Paused' end
end
_sbT.Text=title _sbT.TextColor3=col
_sbP.Text=txt
_sbM.Size=ao(main,1)
if grab then _sbG.Size=ao(grab,1) _sbG.Visible=true else _sbG.Visible=false end
if sub then _sbS.Text=sub _sbS.Visible=true else _sbS.Visible=false end
end
local function Progress()_syncTabs()if ad.Mode=='Nearest'and os.clock()-_lastNear>0.5 then _lastNear=os.clock()aR()end end local a_ local function Show(a0)if aS.Frame
.Visible==a0 then return end aS.Frame.Visible=a0 if a_ then a_:Disconnect()a_=
nil end if not a0 then return end a_=aa.Services.RunService.PreRender:Connect(
Progress)aR()end aa.Clean(function()if a_ then a_:Disconnect()end end)local 
function Wanted()return aK~=nil and aK.Enabled and((aI~=nil and aI.Enabled)or(aJ
~=nil and aJ.Enabled))end aK=ab.Categories.Widgets:CreateModule{Name=
'Target Selection',Early=true,Default=true,Tooltip='Pick what to steal',Function
=function()Show(Wanted())end}do local _scS=ac.ScaleSlider(aK,'Target Selection')
local _UISr=game:GetService('UserInputService')
local _rh=ar('TextButton',{Name='ResizeHandle',AnchorPoint=Vector2.new(1,1),Position=am(1,-5,1,-4),Size=an(22,22),BackgroundTransparency=1,Text='\u{25E2}',TextSize=16,TextColor3=aq.Sub,Font=Enum.Font.GothamBold,AutoButtonColor=false,ZIndex=20},aS.Frame)
local _dr,_sx,_ss,_sw=false,0,100,1
_rh.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then _dr=true _sx=i.Position.X _ss=tonumber(_scS.Value)or 100 _sw=math.max(60,aS.Frame.AbsoluteSize.X) end
end)
_UISr.InputChanged:Connect(function(i)
if _dr and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then
local w=math.max(60,_sw+(i.Position.X-_sx))
local sc=math.clamp(math.floor(_ss*w/_sw+0.5),50,200)
if sc~=_scS.Value then _scS:Set(sc)end
end
end)
_UISr.InputEnded:Connect(function(i)
if _dr and(i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch)then _dr=false end
end)
end
local _sbC
local _sbMod
_sbMod=ab.Categories.Widgets:CreateModule{Name='Steal Bar',Early=true,Default=true,Tooltip='Grab and hold progress while stealing',Function=function(on)
_sbF.Visible=on
if _sbC then _sbC:Disconnect() _sbC=nil end
if on then _sbC=aa.Services.RunService.PreRender:Connect(BarTick) end
end}
ac.ScaleSlider(_sbMod,'StealBar')
aa.Clean(function()if _sbC then _sbC:Disconnect()end end)
local _bgImg=ar('ImageLabel',{Name='Bg',Size=ao(1,1),ZIndex=0,BackgroundTransparency=1,ImageTransparency=0.5,ScaleType=Enum.ScaleType.Crop,Visible=false},aS.Frame)ac.Corner(_bgImg,18)_G.__SE_AddBg(_bgImg)
local function _setBg(_u)_G.__SE_SetBg(_u)end
local _bgBox=aK:CreateTextBox{Name='Background image',Default='https://i.pinimg.com/736x/99/ac/83/99ac830687b566533c9668c9d8d02317.jpg',Tooltip='Image link for the window background (empty = none)',Function=function(_v)_setBg(_v)end}
task.defer(function()_setBg(_bgBox.Value)end)
ac.Listen(
function(a0)if a0.Name=='AutoSteal'or a0.Name=='AutoBuy'then aI,aJ=ab.Modules.
AutoSteal,ab.Modules.AutoBuy Show(Wanted())end end)aI,aJ=ab.Modules.AutoSteal,ab
.Modules.AutoBuy Show(Wanted())return aS end function a.aB()local aa=a.cache.aB
if not aa then aa={c=__modImpl()}a.cache.aB=aa end return aa.c end end do local 
function __modImpl()local aa=a.b()local ab=a.f()local ac=a.t()local ad=a.h()
local ae=string.format local af=math.ceil local ah=task.spawn local ai=task.wait
local aj=task.delay local ak=UDim2.new local al=UDim2.fromOffset local am=UDim2.
fromScale local an=ab.Theme local ao=ab.New local ap local aq local ar={}local
as=ao('Frame',{AnchorPoint=Vector2.new(0.5,0),Size=al(134,50),BackgroundColor3=an.Window,Visible=false},ab.Overlay)ao('UICorner',{CornerRadius=UDim.new(0,10)},as)ab.Stroke(as)ab.Shadow(as,10)ab.Place('Unlock',as,as,ak(0.5,0,0,64))
local _ubg=ao('ImageLabel',{Name='Bg',Size=UDim2.fromScale(1,1),ZIndex=0,BackgroundTransparency=1,ImageTransparency=0.35,ScaleType=Enum.ScaleType.Crop,Visible=false},as)ao('UICorner',{CornerRadius=UDim.new(0,10)},_ubg)_G.__SE_AddBg(_ubg) local at=ao('TextLabel',{Visible=false,RichText=true,Position=al(14,0),Size=ak(1,-130,1,0),TextSize=11,TextColor3=an.Sub,LineHeight=
1.15,TextTruncate=Enum.TextTruncate.AtEnd},as)local function Render()local au=aq
and aq.Owner at.Text=ae(
[[<font size="14" color="%s" weight="semibold">Unlock</font>
%s]],ab.Hex(an.Text
),if au then au.Name else'No base nearby')local av={}if aq then for aw,ax in ac.
Unlocks(aq)do if ax.Floor then av[ax.Floor]=true end end end local aw=os.clock()
local ax=if aq then ac.RelockSeconds(aq)else 0 for ay,az in ar do local aA=if aq
then ac.BlockSeconds(aq,ay)else 0 local aB=av[ay]==true and aA>0 az.Ring.Enabled
=aB az.Timer.Visible=false  if aB then az.Timer.Text=af(aA)..'s'az.Timer.
BackgroundColor3=an.Bad elseif 0<ax then az.Timer.Text=ax..'s'az.Timer.
BackgroundColor3=an.Warn end if aw>=az.Flash then az.Button.BackgroundColor3=an.
Field az.Button.TextColor3=if aB then an.Text else an.Faint end end end local 
function Press(au)local av=ar[au]if not aq or not av.Ring.Enabled then return
end local aw=ac.Unlock(aq,au)local ax=if aw then an.Good else an.Warn av.Flash=
os.clock()+0.4 av.Button.BackgroundColor3=an.Window:Lerp(ax,0.25)av.Button.
TextColor3=ax aj(0.4,Render)end for au=1,3 do local av=ao('TextButton',{
AnchorPoint=Vector2.new(1,0.5),Position=ak(1,-10-(3-au)*38,0.5,-2),Size=al(32,32
),BackgroundColor3=an.Field,Text=tostring(au),FontFace=ab.Fonts.SemiBold,
TextSize=14},as)ao('UICorner',{CornerRadius=UDim.new(0,8)},av)local aw=ab.Stroke(av,an.Bad)aw.Transparency=0.4
local ax=ao('TextLabel',{AnchorPoint=Vector2.new(0.5,0.5),Position=am(0.5,1),
Size=al(0,12),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=0,
BackgroundColor3=an.Bad,TextColor3=Color3.fromRGB(36,14,15),TextXAlignment=Enum.
TextXAlignment.Center,FontFace=ab.Fonts.SemiBold,TextSize=9,ZIndex=2},av)ab.
Corner(ax)ab.Padding(ax,0,4)ar[au]={Button=av,Timer=ax,Ring=aw,Flash=0}av.
Activated:Connect(function()Press(au)end)end local function Others(au)return au.
Owner~=nil and not au.Mine end ap=aa.Categories.Widgets:CreateModule{Name=
'Unlock Bar',Early=true,Tooltip='Unlock floo⁠rs in one click',Function=function(
au)as.Visible=au if not au then return end ap:Clean(ah(function()while true do
local av,aw=ad.Character()aq=if aw then ac.Nearest(aw.Position,Others)else nil
Render()ai(0.25)end end))end}ab.ScaleSlider(ap,'Unlock')return ap end function a
.aC()local aa=a.cache.aC if not aa then aa={c=__modImpl()}a.cache.aC=aa end
return aa.c end end 
 do local function __modImpl()
local aa=a.a()local ab=a.b()
local RunService=aa.Services.RunService
local Workspace=aa.Services.Workspace
local LP=aa.LocalPlayer
local ay,rangeO,hoverO
local lockedPrompt,lockedPart,lockedModel,bodyPos
local promptCache,promptCacheAt=nil,0
local abRag={[Enum.HumanoidStateType.Physics]=true,[Enum.HumanoidStateType.Ragdoll]=true,[Enum.HumanoidStateType.FallingDown]=true}
local abHarden,abTick,abJumped=0,0,false
local function firePurchase(prompt)
	if not prompt or not prompt.Parent or not prompt.Enabled then return end
	pcall(function()prompt.HoldDuration=0 end)
	pcall(function()if fireproximityprompt then fireproximityprompt(prompt)end end)
end
local function partAlive()return lockedPart and lockedPart.Parent and lockedModel and lockedModel.Parent end
local function promptAlive()return lockedPrompt and lockedPrompt.Parent and lockedPrompt.Enabled end
local function destroyBodyPos()
	if bodyPos then pcall(function()bodyPos:Destroy()end)bodyPos=nil end
end
local function hoverPart(char)return char:FindFirstChild("UpperTorso")or char:FindFirstChild("Torso")end
local function allPrompts()
	if promptCache and os.clock()-promptCacheAt<5 then
		local cleaned={}
		for _,p in ipairs(promptCache)do if p and p.Parent then cleaned[#cleaned+1]=p end end
		promptCache=cleaned
		return cleaned
	end
	local out,n={},0
	for _,obj in ipairs(Workspace:GetDescendants())do
		n=n+1
		if n%3000==0 then task.wait()end
		if obj:IsA("ProximityPrompt")then out[#out+1]=obj end
	end
	promptCache,promptCacheAt=out,os.clock()
	return out
end
local function scanConveyor()
	local results={}
	for _,obj in ipairs(allPrompts())do
		if obj.Parent and obj.Enabled then
			local tx=(obj.ActionText or""):lower()
			if tx:find("purchase")or tx:find("comprar")or tx:find("buy")then
				local part=obj.Parent
				local realPart=(part and part:IsA("Attachment")and part.Parent)or part
				if realPart and realPart:IsA("BasePart")then
					local model,cur=nil,realPart
					for _=1,8 do
						if cur and cur:IsA("Model")then model=cur break end
						cur=cur and cur.Parent
					end
					results[#results+1]={prompt=obj,part=realPart,model=model}
				end
			end
		end
	end
	return results
end
local function hoverStep()
	if not partAlive()then return end
	abTick=abTick+1
	if abTick<2 then return end
	abTick=0
	local char=LP.Character
	local part=char and hoverPart(char)
	if not part then return end
	local hum=char:FindFirstChildOfClass("Humanoid")
	local now=os.clock()
	if hum then
		if now-abHarden>0.5 then
			abHarden=now
			pcall(function()hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)end)
			pcall(function()hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)end)
			pcall(function()hum.BreakJointsOnDeath=false end)
		end
		local ragged=abRag[hum:GetState()]==true
		local et=tonumber(LP:GetAttribute("RagdollEndTime"))
		if et and(et-workspace:GetServerTimeNow())>0 then ragged=true end
		if ragged then
			pcall(function()hum:ChangeState(Enum.HumanoidStateType.GettingUp)end)
			local cam=workspace.CurrentCamera
			if cam and cam.CameraSubject~=hum then pcall(function()cam.CameraSubject=hum end)end
		end
	end
	local hover=tonumber(hoverO.Value)or 9
	local goal=lockedPart.Position+Vector3.new(0,hover,0)
	if not(bodyPos and bodyPos.Parent==part)then
		destroyBodyPos()
		bodyPos=Instance.new("BodyPosition")
		bodyPos.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
		bodyPos.P=20000
		bodyPos.D=1000
		bodyPos.Parent=part
	end
	bodyPos.Position=goal
end
local function buyStep()
	if not partAlive()or not promptAlive()then return end
	if not abJumped then
		abJumped=true
		local char=LP.Character
		local hum=char and char:FindFirstChildOfClass("Humanoid")
		if hum then pcall(function()hum:ChangeState(Enum.HumanoidStateType.Jumping)end)end
	end
	firePurchase(lockedPrompt)
end
local function reset()
	lockedPrompt,lockedPart,lockedModel=nil,nil,nil
	destroyBodyPos()
	abJumped=false
end
ay=ab.Categories.World:CreateModule{Name='AutoBuy',Early=true,
Tooltip='Buys the nearest carpet brainrot in range (hovers above it)',Function=function(on)
	if not on then return end
	ay:Clean(reset)
	ay:Clean(Workspace.DescendantAdded:Connect(function(d)
		if promptCache and d:IsA("ProximityPrompt")then promptCache[#promptCache+1]=d end
	end))
	ay:Clean(RunService.Heartbeat:Connect(hoverStep))
	ay:Clean(RunService.Heartbeat:Connect(buyStep))
	ay:Clean(LP.CharacterAdded:Connect(destroyBodyPos))
	ay:Clean(task.spawn(function()
		while true do
			task.wait(0.1)
			if lockedPart or lockedModel then
				if not partAlive()then reset()end
			else
				local ok,found=pcall(scanConveyor)
				local list=(ok and found)or{}
				local char=LP.Character
				local hrp=char and char:FindFirstChild("HumanoidRootPart")
				if hrp then
					local best,bestDist=nil,math.huge
					local radius=tonumber(rangeO.Value)or 17
					for _,e in ipairs(list)do
						if e.prompt and e.prompt.Parent and e.prompt.Enabled and e.part and e.part.Parent then
							local d=(hrp.Position-e.part.Position).Magnitude
							if d<=radius and d<bestDist then bestDist=d best=e end
						end
					end
					if best then
						lockedPrompt,lockedPart,lockedModel=best.prompt,best.part,best.model or best.part.Parent
						pcall(function()best.prompt.HoldDuration=0 end)
						firePurchase(best.prompt)
					end
				end
			end
		end
	end))
end}
-- compat con Target Selection (ya no lista brainrots de la alfombra)
function ay.Accepts()return false end function ay.Release()end function ay.Selected()return false end function ay.Choose()end
function ay.Release()end
function ay.Selected()return false end
function ay.Choose()end
rangeO=ay:CreateSlider{Default=17,Max=40,Name='Auto Buy Range',Suffix='',Min=5}
hoverO=ay:CreateSlider{Default=9,Max=20,Name='Auto Buy Float',Suffix='',Min=0}
return ay end function a.aE()local aa=a.cache.aE if not aa
then aa={c=__modImpl()}a.cache.aE=aa end return aa.c end end  end -- ===== ANTI BEE + ANTI DISCO (de D3), siempre prendido, sin GUI =====
task.spawn(function()
local __okAB,__eAB=pcall(function()
do
	if type(_G.__D3AntiBeeKill) == "function" then pcall(_G.__D3AntiBeeKill) end
	local Players = game:GetService("Players")
	local Lighting = game:GetService("Lighting")
	local SoundService = game:GetService("SoundService")
	local RunService = game:GetService("RunService")
	local LP = Players.LocalPlayer
	local alive = true
	local ab = {
		hits = 0, fovs = 0, moves = 0, rolls = 0, anims = 0,
		conns = {},
		preExisting = nil,
		baseFOV = nil,
		origMove = nil,
		guarded = false,
	}
	local function antiOn(name) return true end -- siempre prendido, sin gui
	local function beeOn() return antiOn("Anti-Bee") end
	local function discoOn() return antiOn("Anti-Disco") end
	local function anyOn() return beeOn() or discoOn() end
	local BEE_NAMES = {
		beehive = true, ["bee hive"] = true, beeblur = true, beeeffect = true,
		beelauncher = true, ["bee launcher"] = true, beeparticle = true,
		beeswarm = true, swarm = true, stinger = true,
		blue = true, honeyoverlay = true,
	}
	local DISCO_NAMES = { discoeffect = true }
	local DISCO_WORDS = { "boogie", "disco", "dance", "party", "groove", "funk", "rave" }
	local BEE_SOUNDS = { "buzz", "bee", "sting", "swarm", "hive" }
	local EFFECTS = {
		ColorCorrectionEffect = true, BloomEffect = true, BlurEffect = true,
		SunRaysEffect = true, DepthOfFieldEffect = true,
	}
	local function lower(s) return string.lower(tostring(s or "")) end
	local function killName(s)
		local l = lower(s)
		if beeOn() and BEE_NAMES[l] then return true end
		if discoOn() and DISCO_NAMES[l] then return true end
		return false
	end
	local function discoName(s)
		if not discoOn() then return false end
		s = lower(s)
		if s == "" then return false end
		for _, w in ipairs(DISCO_WORDS) do
			if string.find(s, w, 1, true) then return true end
		end
		return false
	end
	local function soundIsBad(s)
		local n = lower(s.Name) .. " " .. lower(s.SoundId)
		if beeOn() then
			for _, w in ipairs(BEE_SOUNDS) do
				if string.find(n, w, 1, true) then return true end
			end
		end
		if discoOn() then
			for _, w in ipairs(DISCO_WORDS) do
				if string.find(n, w, 1, true) then return true end
			end
		end
		return false
	end
	local function ourItem(d)
		if not d then return false end
		if d:IsA("Tool") then return true end
		local okT, t = pcall(function() return d:FindFirstAncestorWhichIsA("Tool") end)
		if okT and t then return true end
		local bp = LP:FindFirstChild("Backpack")
		if bp then
			local okB, inBp = pcall(function() return d:IsDescendantOf(bp) end)
			if okB and inBp then return true end
		end
		return false
	end
	local function busy()
		return _G._isTpMoving or _G.isCloning or _G._sideTP_isTpMoving
	end
	local function snapshotLighting()
		ab.preExisting = {}
		pcall(function()
			for _, d in ipairs(Lighting:GetDescendants()) do ab.preExisting[d] = true end
		end)
	end
	local function nuke(obj)
		if not obj or not obj.Parent then return end
		if ourItem(obj) then return end
		if killName(obj.Name) or discoName(obj.Name) then
			ab.hits = ab.hits + 1
			pcall(function() obj:Destroy() end)
			return
		end
		if beeOn() and EFFECTS[obj.ClassName] and ab.preExisting and not ab.preExisting[obj] then
			ab.hits = ab.hits + 1
			pcall(function() obj:Destroy() end)
		end
	end
	local function hush(s)
		if not s or not s:IsA("Sound") then return end
		if not soundIsBad(s) then return end
		pcall(function()
			s.Volume = 0
			s:Stop()
		end)
		ab.hits = ab.hits + 1
	end
	local function scrubChar(d)
		if not d or not d.Parent then return end
		if ourItem(d) then return end
		if d:IsA("Sound") then hush(d) return end
		if not (killName(d.Name) or discoName(d.Name)) then return end
		if d:IsA("Model") or d:FindFirstChildOfClass("Humanoid") then return end
		ab.hits = ab.hits + 1
		pcall(function()
			if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
				d.Enabled = false
			else
				d:Destroy()
			end
		end)
	end
	local function scrubGui(g)
		if not g or not g.Parent then return end
		if killName(g.Name) or discoName(g.Name) then
			ab.hits = ab.hits + 1
			pcall(function() g:Destroy() end)
		end
	end
	local function guardControls()
		if ab.guarded then return end
		pcall(function()
			local PS = LP:FindFirstChild("PlayerScripts")
			local PM = PS and PS:FindFirstChild("PlayerModule")
			if not PM then return end
			local Controls = require(PM):GetControls()
			if not Controls then return end
			if not ab.origMove then ab.origMove = Controls.moveFunction end
			if not ab.origMove then return end
			local function guarded(self, moveVector, relativeToCamera)
				return ab.origMove(self, moveVector, relativeToCamera)
			end
			ab.guardedFn = guarded
			Controls.moveFunction = guarded
			ab.Controls = Controls
			ab.guarded = true
		end)
	end
	local function reassertControls()
		if busy() then return end
		local C, g = ab.Controls, ab.guardedFn
		if not (C and g) then guardControls() return end
		if C.moveFunction ~= g then
			C.moveFunction = g
			ab.moves = ab.moves + 1
		end
	end
	local function hushBuzzScript()
		pcall(function()
			local bs = ab.beeScript
			if not (bs and bs.Parent) then
				if os.clock() - (ab.beeLookAt or 0) < 2 then return end
				ab.beeLookAt = os.clock()
				local PS = LP:FindFirstChild("PlayerScripts")
				bs = PS and PS:FindFirstChild("Bee", true)
				ab.beeScript = bs
			end
			if not bs then return end
			for _, d in ipairs(bs:GetDescendants()) do
				if d:IsA("Sound") then
					pcall(function()
						d.Volume = 0
						d:Stop()
					end)
				end
			end
		end)
	end
	local function stopDanceAnims()
		if not discoOn() then return end
		pcall(function()
			local ch = LP.Character
			local hum = ch and ch:FindFirstChildOfClass("Humanoid")
			local anim = hum and hum:FindFirstChildOfClass("Animator")
			if not anim then return end
			for _, tr in ipairs(anim:GetPlayingAnimationTracks()) do
				local id = (tr.Animation and tr.Animation.AnimationId) or ""
				if discoName(tr.Name) or discoName(id) then
					ab.anims = ab.anims + 1
					pcall(function() tr:Stop(0) end)
				end
			end
		end)
	end
	local function steadyCam(cam)
		if not discoOn() or busy() then return end
		local cf = cam.CFrame
		local rx, ry, rz = cf:ToEulerAnglesYXZ()
		if math.abs(rz) > 0.002 then
			cam.CFrame = CFrame.new(cf.Position) * CFrame.fromEulerAnglesYXZ(rx, ry, 0)
			ab.rolls = ab.rolls + 1
		end
	end
	local function watchChar(ch)
		if not ch then return end
		for _, d in ipairs(ch:GetDescendants()) do scrubChar(d) end
		ab.conns[#ab.conns + 1] = ch.DescendantAdded:Connect(function(d)
			if not anyOn() then return end
			scrubChar(d)
		end)
	end
	local function sweepExisting()
		pcall(function()
			for _, inst in ipairs(Lighting:GetDescendants()) do nuke(inst) end
		end)
		pcall(function()
			for _, d in ipairs(SoundService:GetDescendants()) do hush(d) end
		end)
		pcall(function()
			local pg = LP:FindFirstChildOfClass("PlayerGui")
			if pg then
				for _, g in ipairs(pg:GetChildren()) do scrubGui(g) end
			end
		end)
		pcall(function()
			local ch = LP.Character
			if ch then
				for _, d in ipairs(ch:GetDescendants()) do scrubChar(d) end
			end
		end)
	end
	snapshotLighting()
	ab.conns[#ab.conns + 1] = Lighting.DescendantAdded:Connect(function(o)
		if not anyOn() then return end
		nuke(o)
	end)
	pcall(function()
		ab.conns[#ab.conns + 1] = SoundService.DescendantAdded:Connect(function(d)
			if not anyOn() then return end
			hush(d)
		end)
	end)
	pcall(function()
		local pg = LP:FindFirstChildOfClass("PlayerGui")
		if not pg then return end
		ab.conns[#ab.conns + 1] = pg.ChildAdded:Connect(function(g)
			if not anyOn() then return end
			scrubGui(g)
		end)
	end)
	watchChar(LP.Character)
	ab.conns[#ab.conns + 1] = LP.CharacterAdded:Connect(function(ch)
		task.wait(0.2)
		if alive then watchChar(ch) end
	end)
	do
		local cam = workspace.CurrentCamera
		ab.baseFOV = (cam and cam.FieldOfView) or 70
		if ab.baseFOV < 55 or ab.baseFOV > 90 then ab.baseFOV = 70 end
	end
	ab.conns[#ab.conns + 1] = RunService.RenderStepped:Connect(function()
		if _G.D3Dead or not alive then return end
		local bee = beeOn()
		local disco = discoOn()
		if not (bee or disco) then return end
		local cam = workspace.CurrentCamera
		if not cam then return end
		if bee and math.abs(cam.FieldOfView - ab.baseFOV) > 0.5 then
			cam.FieldOfView = ab.baseFOV
			ab.fovs = ab.fovs + 1
		end
		steadyCam(cam)
		if bee then
			local hum = ab.hum
			if not (hum and hum.Parent) then
				local ch = LP.Character
				hum = ch and ch:FindFirstChildOfClass("Humanoid")
				ab.hum = hum
			end
			if hum and hum.CameraOffset.Magnitude > 0.05 then
				hum.CameraOffset = Vector3.zero
			end
		end
	end)
	task.spawn(function()
		local wasBee, wasDisco = false, false
		while alive and not _G.D3Dead do
			task.wait(0.25)
			local bee, disco = beeOn(), discoOn()
			if (bee and not wasBee) or (disco and not wasDisco) then
				local cam = workspace.CurrentCamera
				if bee and not wasBee and cam then
					local f = cam.FieldOfView
					if f >= 55 and f <= 90 then ab.baseFOV = f end
				end
				sweepExisting()
			end
			wasBee, wasDisco = bee, disco
			if bee then
				reassertControls()
				hushBuzzScript()
				local ch = LP.Character
				if ch then
					local hive = ch:FindFirstChild("Beehive")
					if hive then pcall(function() hive:Destroy() end) end
				end
			end
			if disco then stopDanceAnims() end
			if bee or disco then
				_G.D3AntiBeeDiag = ("%d removed, %d fov, %d control grabs, %d rolls, %d dances")
					:format(ab.hits, ab.fovs, ab.moves, ab.rolls, ab.anims)
			end
		end
	end)
	_G.__D3AntiBeeKill = function()
		alive = false
		for _, c in ipairs(ab.conns) do pcall(function() c:Disconnect() end) end
		if ab.guarded and ab.Controls and ab.origMove then
			pcall(function() ab.Controls.moveFunction = ab.origMove end)
		end
	end
end

end)
if not __okAB then warn('[anti bee/disco] '..tostring(__eAB)) end
end)

do local function __modImpl()
local aa=a.a() local ab=a.b() local ac=a.f() local ad=a.ab() local Plots=a.t() local Roster=a.D() local Pm=a.h()
local Players=aa.Services.Players
local UIS=aa.Services.UserInputService
local RunService=aa.Services.RunService
local Workspace=aa.Services.Workspace
local LP=aa.LocalPlayer
local Theme=ac.Theme local New=ac.New
local CMDS={{'ragdoll','🤸'},{'rocket','🚀'},{'jail','🔒'},{'balloon','🎈'}}
local CFG=_G.__APOrder
local function Active(mode)local t={} for _,c in CFG.Value do if not CFG.Off[c] and not (mode=='click' and CFG.NoClick[c]) and not (mode=='prox' and CFG.NoProx[c]) then t[#t+1]=c end end return t end
local EMO={ragdoll='🤸',rocket='🚀',jail='🔒',balloon='🎈',tiny='🐜',inverse='🔄',control='🎮',jumpscare='👻',morph='🎭'}
local NAME={ragdoll='Ragdoll',rocket='Rocket',jail='Jail',balloon='Balloon',tiny='Tiny',inverse='Inverse',control='Control',jumpscare='Jumpscare',morph='Morph'}
local SHOW_TAGS={['BASE OWNER']=true,SON=true,FMLY=true}
local W,ROW_H,GAP,ROWS=720,54,12,7
local WF='depresivini_ap_width.json'
do local ok,v=pcall(function() if isfile and isfile(WF) then return tonumber(game:GetService('HttpService'):JSONDecode(readfile(WF)).W) end end) if ok and v then W=math.clamp(v,600,1200) end end
local TOP_H=44
local HDR=16
local win=ac.Widget('Admin Panel','Target',W,UDim2.new(0,16,0.5,-250))
local body=win.Body
body.AutomaticSize=Enum.AutomaticSize.None
body.Size=UDim2.new(1,0,0,8+TOP_H+6+ROWS*(ROW_H+GAP)-GAP+8)
do
for _,c in win.Frame:GetChildren() do if c:IsA'UICorner' then c.CornerRadius=UDim.new(0,18) end end
local hd=win.Top hd.BackgroundTransparency=1
for _,c in hd:GetChildren() do if c:IsA'ImageLabel' or c:IsA'UIGradient' or (c:IsA'Frame' and c.Size.Y.Offset==1) then c:Destroy() end end
for _,c in hd:GetChildren() do if c:IsA'TextLabel' then c:Destroy() end end
hd.Size=UDim2.new(1,0,0,HDR)
win.Body.Position=UDim2.fromOffset(0,HDR)
win.Frame.BackgroundTransparency=1
for _,c in win.Frame:GetChildren() do if c:IsA'UIStroke' or c:IsA'ImageLabel' then c:Destroy() end end
end


-- ===== estado =====
local proxOn,spamming=false,false
local function CT() return ab.Modules.ClickToAp end
local function ClickOn() local m=CT() return m~=nil and m.Enabled==true end
local range=CFG.Range or 15
local ownerPlr=nil
local stealing={}

-- ===== helpers =====
local function Others(p) return p.Owner~=nil and not p.Mine end
local function OwnerNow()
local ch=LP.Character local rt=ch and ch:FindFirstChild'HumanoidRootPart'
if not rt then return nil end
local pl=Plots.Nearest(rt.Position,Others)
local o=pl and pl.Owner
if typeof(o)=='Instance' and o:IsA'Player' and o~=LP then return o end
return nil
end
local HttpService=game:GetService'HttpService'
local BLF='depresivini_ap_black.json'
local Black={}
pcall(function() if isfile and isfile(BLF) then for _,id in HttpService:JSONDecode(readfile(BLF)) do Black[id]=true end end end)
local function SaveBlack() pcall(function() local t={} for id in Black do t[#t+1]=id end writefile(BLF,HttpService:JSONEncode(t)) end) end
local function RunB(p,c) if Black[p.UserId] then return false end return ad.Run(p,c) end
local APS,APP,APN={}, {}, {}
local APREQ=(syn and syn.request) or http_request or request
local function HasAP(p)
local uid=p.UserId
if APS[uid]~=nil then return APS[uid] end
if p:GetAttribute'AdminCommands'==true then APS[uid]=true return true end
if APREQ and not APP[uid] and os.clock()>=(APN[uid] or 0) then
APP[uid]=true
task.spawn(function()
local ok,res=pcall(APREQ,{Url='https://inventory.roblox.com/v1/users/'..uid..'/items/GamePass/1227013099/is-owned',Method='GET'})
local done=false
if ok and type(res)=='table' and res.StatusCode==200 then
local b=tostring(res.Body):gsub('%s+',''):lower()
if b=='true' then APS[uid]=true done=true elseif b=='false' then APS[uid]=false done=true end
end
if not done then APN[uid]=os.clock()+15 end
APP[uid]=nil
end)
end
return false
end
local function Notify(t,m,k) aa.Menu.Notify(t,m,k or 'Info',2.5) end
local function NextReady(plr)
for _,c in Active('click') do if ad.Remaining(c)<=0 then return c end end
return nil
end
local function RunAll(plr,mode)
local any=false
for _,c in Active(mode) do if RunB(plr,c) then any=true end end
return any
end

-- ===== toolbar =====
local bar=New('Frame',{Position=UDim2.fromOffset(8,8),Size=UDim2.new(1,-16,0,TOP_H),BackgroundColor3=Theme.Field,BackgroundTransparency=0.35},body)
ac.Corner(bar,12)
local function Tool(x,w,text)
local b=New('TextButton',{Position=UDim2.fromOffset(x,9),Size=UDim2.fromOffset(w,26),BackgroundColor3=Theme.Field,Font=Enum.Font.GothamBold,TextSize=11,TextColor3=Theme.Text,Text=text,AutoButtonColor=false},bar)
ac.Corner(b,5) ac.Stroke(b)
return b
end
local spamBtn=Tool(8,96,'SP.BaseOWN')
local jailBtn=Tool(108,56,'JAIL')
local clickBtn=Tool(168,112,'CLICK.AP: OFF')
local proxBtn=Tool(284,88,'PROX: OFF')
local orderBtn=New('TextButton',{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-8,0,9),Size=UDim2.fromOffset(32,26),BackgroundColor3=Theme.Field,Font=Enum.Font.GothamBold,TextSize=15,TextColor3=Theme.Text,Text='\u{2699}',AutoButtonColor=false},bar)
ac.Corner(orderBtn,5) ac.Stroke(orderBtn)
local function Paint(b,on)
b.BackgroundColor3=if on then Theme.Window:Lerp(Theme.Good,0.3) else Theme.Field
b.TextColor3=if on then Theme.Good else Theme.Text
end
-- slider del proximity
local rLbl=New('TextLabel',{Position=UDim2.fromOffset(382,9),Size=UDim2.fromOffset(60,26),TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=Theme.Sub,Text='Dist: 15',BackgroundTransparency=1},bar)
local function StepB(x,t) local bb=New('TextButton',{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,x,0,11),Size=UDim2.fromOffset(24,22),BackgroundColor3=Theme.Field,Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Theme.Text,Text=t,AutoButtonColor=false},bar) ac.Corner(bb,5) ac.Stroke(bb) return bb end
local minusB=StepB(-72,'-')
local plusB=StepB(-44,'+')
local track=New('Frame',{Position=UDim2.fromOffset(446,18),Size=UDim2.new(1,-446-104,0,8),BackgroundColor3=Theme.Window,BorderSizePixel=0,Active=true},bar)
ac.Corner(track,5)
local fill=New('Frame',{Size=UDim2.fromScale(0,1),BackgroundColor3=Theme.Accent,BorderSizePixel=0},track)
local knob=New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0,0.5),Size=UDim2.fromOffset(8,16),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=2},track)
local function SetRange(v)
v=math.clamp(math.floor(v+0.5),5,50)
range=v
local pct=(v-5)/45
fill.Size=UDim2.fromScale(pct,1) knob.Position=UDim2.fromScale(pct,0.5)
rLbl.Text='Dist: '..v
end
SetRange(range)
local function SetW(w,sv) W=math.clamp(w,600,1200) win.Frame.Size=UDim2.fromOffset(W,0) if sv then pcall(function() writefile(WF,game:GetService('HttpService'):JSONEncode({W=W})) end) end end
SetW(W)
minusB.Activated:Connect(function() SetW(W-40,true) end)
plusB.Activated:Connect(function() SetW(W+40,true) end)
local dragging=false
local function FromMouse(x)
local ax,aw=track.AbsolutePosition.X,track.AbsoluteSize.X
if aw<=0 then return end
SetRange(5+45*math.clamp((x-ax)/aw,0,1))
end
track.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true FromMouse(i.Position.X) end
end)
UIS.InputChanged:Connect(function(i)
if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then FromMouse(i.Position.X) end
end)
UIS.InputEnded:Connect(function(i)
if dragging and (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then dragging=false CFG.Range=range CFG.Save() end
end)

-- ===== lista =====
local sf=New('ScrollingFrame',{Position=UDim2.fromOffset(8,8+TOP_H+6),Size=UDim2.new(1,-16,1,-(8+TOP_H+6+8)),AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ScrollingDirection=Enum.ScrollingDirection.Y,ScrollBarThickness=3,ScrollBarImageColor3=Theme.Accent,ScrollBarImageTransparency=0.45,VerticalScrollBarInset=Enum.ScrollBarInset.Always,BackgroundTransparency=1,BorderSizePixel=0},body)
local lay=Instance.new('UIListLayout') lay.Padding=UDim.new(0,GAP) lay.SortOrder=Enum.SortOrder.LayoutOrder lay.Parent=sf
local empty=New('TextLabel',{Position=UDim2.fromOffset(0,8+TOP_H+6),Size=UDim2.new(1,0,1,-(8+TOP_H+6)),TextSize=12,TextColor3=Theme.Sub,Text='No other players',Visible=false,BackgroundTransparency=1},body)
local rows={}

-- ===== Order pane =====
local pane=New('ScrollingFrame',{Position=UDim2.fromOffset(8,8+TOP_H+6),Size=UDim2.new(1,-16,1,-(8+TOP_H+6+8)),AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ScrollingDirection=Enum.ScrollingDirection.Y,ScrollBarThickness=3,ScrollBarImageColor3=Theme.Accent,ScrollBarImageTransparency=0.45,VerticalScrollBarInset=Enum.ScrollBarInset.Always,BackgroundTransparency=1,BorderSizePixel=0,Visible=false},body)
local pl=Instance.new('UIListLayout') pl.Padding=UDim.new(0,GAP) pl.SortOrder=Enum.SortOrder.LayoutOrder pl.Parent=pane
New('TextLabel',{Size=UDim2.new(1,0,0,16),LayoutOrder=0,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=Theme.Sub,Text='Order: CLICK = Click to AP, PROX = Proximity (lit = used). Spam and All use every ON command',BackgroundTransparency=1},pane)
local BuildOrder
local function Swap(i,j)
if j<1 or j>#CFG.Value then return end
CFG.Value[i],CFG.Value[j]=CFG.Value[j],CFG.Value[i]
CFG.Save() BuildOrder()
end
BuildOrder=function()
for _,c in pane:GetChildren() do if c.Name=='OrderRow' then c:Destroy() end end
for i,cmd in CFG.Value do
local r=New('Frame',{Name='OrderRow',LayoutOrder=i,Size=UDim2.new(1,-6,0,34),BackgroundColor3=Theme.Field,BackgroundTransparency=0.35},pane)
ac.Corner(r,10)
New('TextLabel',{Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-270,1,0),TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,TextSize=13,TextColor3=if CFG.Off[cmd] then Theme.Faint else Theme.Text,RichText=false,Text=i..'.  '..EMO[cmd]..'  '..NAME[cmd],BackgroundTransparency=1},r)
local function B(x,w,t)
local b=New('TextButton',{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,x,0.5,0),Size=UDim2.fromOffset(w,22),BackgroundColor3=Theme.Field,Font=Enum.Font.GothamBold,TextSize=11,TextColor3=Theme.Text,Text=t,AutoButtonColor=false},r)
ac.Corner(b,7) ac.Stroke(b)
return b
end
local on=B(-84,48,if CFG.Off[cmd] then 'OFF' else 'ON')
Paint(on,not CFG.Off[cmd])
on.Activated:Connect(function() CFG.Off[cmd]=if CFG.Off[cmd] then nil else true CFG.Save() BuildOrder() end)
local cl=B(-138,52,'CLICK')
Paint(cl,not CFG.Off[cmd] and not CFG.NoClick[cmd])
cl.Activated:Connect(function() CFG.NoClick[cmd]=if CFG.NoClick[cmd] then nil else true CFG.Save() BuildOrder() end)
local px=B(-194,52,'PROX')
Paint(px,not CFG.Off[cmd] and not CFG.NoProx[cmd])
px.Activated:Connect(function() CFG.NoProx[cmd]=if CFG.NoProx[cmd] then nil else true CFG.Save() BuildOrder() end)
B(-44,32,'\u{25B2}').Activated:Connect(function() Swap(i,i-1) end)
B(-8,32,'\u{25BC}').Activated:Connect(function() Swap(i,i+1) end)
end
end
BuildOrder()
orderBtn.Activated:Connect(function()
pane.Visible=not pane.Visible
sf.Visible=not pane.Visible
if pane.Visible then empty.Visible=false else empty.Visible=next(rows)==nil end
Paint(orderBtn,pane.Visible)
end)
local function Headshot(id) return string.format('rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48',id) end
local function Flash(btn,ok)
local col=if ok then Theme.Good else Theme.Warn
btn.BackgroundColor3=Theme.Window:Lerp(col,0.3) btn.TextColor3=col
task.delay(0.35,function() if btn.Parent then btn.BackgroundColor3=Theme.Field end end)
end
local function MakeRow(plr)
local row=New('Frame',{Size=UDim2.new(1,-6,0,ROW_H),BackgroundColor3=Theme.Field,BackgroundTransparency=0.35},sf)
ac.Corner(row,5)
local xb=New('TextButton',{Position=UDim2.fromOffset(6,ROW_H/2-14),Size=UDim2.fromOffset(28,28),BackgroundColor3=Theme.Field,Font=Enum.Font.GothamBold,TextSize=15,TextColor3=Theme.Bad,Text='X',AutoButtonColor=false},row)
ac.Corner(xb,5) ac.Stroke(xb)
local function PaintX() local bl=Black[plr.UserId]==true xb.Text=if bl then 'O' else 'X' xb.TextColor3=if bl then Theme.Good else Theme.Bad end
PaintX()
xb.Activated:Connect(function()
if Black[plr.UserId] then Black[plr.UserId]=nil else Black[plr.UserId]=true end
SaveBlack() PaintX()
Notify('Blacklist',plr.DisplayName..(if Black[plr.UserId] then ' blocked' else ' unblocked'))
end)
local av=New('ImageLabel',{Position=UDim2.fromOffset(40,ROW_H/2-17),Size=UDim2.fromOffset(34,34),BackgroundColor3=Theme.Window,BackgroundTransparency=0,Image=Headshot(plr.UserId)},row)
ac.Corner(av,5)
local nameL=New('TextLabel',{Position=UDim2.fromOffset(82,3),Size=UDim2.fromOffset(190,17),TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,TextSize=13,RichText=true,TextColor3=Theme.Text,TextTruncate=Enum.TextTruncate.AtEnd,Text=plr.DisplayName,BackgroundTransparency=1},row)
local userL=New('TextLabel',{Position=UDim2.fromOffset(82,19),Size=UDim2.fromOffset(190,14),TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=Theme.Sub,TextTruncate=Enum.TextTruncate.AtEnd,Text='@'..plr.Name,BackgroundTransparency=1},row)
local statL=New('TextLabel',{Position=UDim2.fromOffset(82,34),Size=UDim2.fromOffset(190,15),TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,TextSize=10,RichText=true,TextColor3=Theme.Sub,TextTruncate=Enum.TextTruncate.AtEnd,Text='',BackgroundTransparency=1},row)
local btns={}
local n=#CMDS+1
local cmdF=New('Frame',{Position=UDim2.fromOffset(280,0),Size=UDim2.new(1,-280-70,1,0),BackgroundTransparency=1},row)
for i=1,n do
local isAll=i==n
local label=if isAll then 'All' else CMDS[i][2]
local b=New('TextButton',{Position=UDim2.new((i-1)/n,2,0.5,-15),Size=UDim2.new(1/n,-4,0,30),BackgroundColor3=Theme.Field,Font=Enum.Font.GothamBold,TextSize=if isAll then 11 else 15,TextColor3=Theme.Text,Text=label,AutoButtonColor=false},cmdF)
ac.Corner(b,5) ac.Stroke(b)
b.Activated:Connect(function()
local ok=if isAll then RunAll(plr) else RunB(plr,CMDS[i][1])
Flash(b,ok)
end)
btns[i]={Button=b,Label=label,Cmd=if isAll then nil else CMDS[i][1]}
end
-- item que tiene en la mano (a la derecha del todo)
local itemF=New('Frame',{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-8,0.5,0),Size=UDim2.fromOffset(ROW_H-10,ROW_H-10),BackgroundColor3=Theme.Window,BackgroundTransparency=0.3},row)
ac.Corner(itemF,5) ac.Stroke(itemF)
local itemI=New('ImageLabel',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.new(1,-6,1,-6),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit,Image=''},itemF)
local itemT={Text=''}
rows[plr]={Row=row,Btns=btns,Name=nameL,Stat=statL,Item=itemI,ItemT=itemT,ItemKey='',Last='',LastS='',PaintX=PaintX}
end
local function Order(list)
table.sort(list,function(x,y)
local ox,oy=x==ownerPlr,y==ownerPlr
if ox~=oy then return ox end
local sx,sy=stealing[x]~=nil,stealing[y]~=nil
if sx~=sy then return sx end
return string.lower(x.DisplayName)<string.lower(y.DisplayName)
end)
end
local function Rebuild()
local list={}
for _,p in Players:GetPlayers() do if p~=LP then list[#list+1]=p end end
for p,r in rows do if not p.Parent then r.Row:Destroy() rows[p]=nil end end
Order(list)
for i,p in list do
if not rows[p] then MakeRow(p) end
rows[p].Row.LayoutOrder=i
end
empty.Visible=#list==0
body.Size=UDim2.new(1,0,0,8+TOP_H+6+math.max(#list,1)*(ROW_H+GAP)-GAP+8)
end
local function RefreshTags()
local changed=false
for p,r in rows do
local ok0,car=pcall(Pm.Carrying,p)
local nm=nil
if ok0 and car then
nm=if car~='' then car else (p:GetAttribute('StealingIndex') or 'a brainrot')
elseif p:GetAttribute('Stealing') then
nm=p:GetAttribute('StealingIndex') or 'a brainrot'
end
if (nm~=nil)~=(stealing[p]~=nil) then changed=true end
stealing[p]=nm
local tg={}
local ok,tags=pcall(Roster.Tags,p,p==ownerPlr)
if ok and type(tags)=='table' then
for _,t in tags do
if t.Text~='AP' and t.Text~='BASE OWNER' then tg[#tg+1]=string.format('<font color="#%s">[%s]</font>',t.Color:ToHex(),t.Text) end
end
end
local txt=p.DisplayName..(if #tg>0 then ' '..table.concat(tg,' ') else '')
if txt~=r.Last then r.Last=txt r.Name.Text=txt end
local sp={}
if p==ownerPlr then sp[#sp+1]='<font color="#6EAAFF">Base Owner</font>' end
if nm then sp[#sp+1]='<font color="#FF4B4B">STEALING: '..tostring(nm)..'</font>' end
if HasAP(p) then sp[#sp+1]='<font color="#FF3B3B">Has AP</font>' end
local st2=table.concat(sp,'  ')
if st2~=r.LastS then r.LastS=st2 r.Stat.Text=st2 end
r.PaintX()
r.Row.BackgroundColor3=if nm then Color3.fromRGB(60,30,12) elseif p==ownerPlr then Theme.Window:Lerp(Theme.Good,0.18) else Theme.Field
end
if changed then Rebuild() end
end
local function Tick()
local con=ClickOn()
clickBtn.Text='CLICK.AP: '..(if con then 'ON' else 'OFF') Paint(clickBtn,con)
for p,r in rows do
local tool=p.Character and p.Character:FindFirstChildOfClass'Tool'
local key=if tool then tool.Name else ''
if key~=r.ItemKey then
r.ItemKey=key
if tool then
local tex=tool.TextureId
if tex=='' then
local RS=game:GetService'ReplicatedStorage'
local it=RS:FindFirstChild('Items') or RS:FindFirstChild('Tools')
local ob=it and it:FindFirstChild(tool.Name)
if ob and (ob:IsA'Tool') then tex=ob.TextureId end
end
r.Item.Image=tex r.ItemT.Text=tool.Name
else r.Item.Image='' r.ItemT.Text='' end
end
local minAll=math.huge
for _,b in r.Btns do
if b.Cmd then
local left=ad.Remaining(b.Cmd)
if left<minAll then minAll=left end
if left>0.05 then b.Button.Text=math.ceil(left)..'s' b.Button.TextColor3=Theme.Faint else b.Button.Text=b.Label b.Button.TextColor3=Theme.Text end
end
end
for _,b in r.Btns do
if not b.Cmd then b.Button.TextColor3=if minAll>0.05 then Theme.Faint else Theme.Text end
end
end
end

jailBtn.Activated:Connect(function()
local o=OwnerNow()
if not o then Notify('Jail','No nearby base found','Warning') return end
Flash(jailBtn,RunB(o,'jail'))
end)
-- ===== Spam Base Owner =====
spamBtn.Activated:Connect(function()
if spamming then return end
local o=OwnerNow()
if not o then Notify('Spam Owner','No nearby base found','Warning') return end
spamming=true
spamBtn.Text='SPAMMING...' Paint(spamBtn,true)
Notify('Spam Owner','Spamming '..o.DisplayName)
task.spawn(function()
local count=0
local SO=Active()
for i,cmd in SO do
if not o.Parent then break end
if RunB(o,cmd) then count+=1 end
local nxt=SO[i+1]
if nxt and not (cmd=='rocket' and nxt=='jail') then task.wait(1+math.random()*0.1) end
end
task.wait(0.3)
spamming=false
spamBtn.Text='SP.BaseOWN' Paint(spamBtn,false)
Notify('Spam Owner','Sent '..count..' cmds to '..o.DisplayName)
end)
end)

-- ===== Click to AP =====
local rp=RaycastParams.new() rp.FilterType=Enum.RaycastFilterType.Exclude
local function Aimed()
local cam=Workspace.CurrentCamera if not cam then return nil end
local m=UIS:GetMouseLocation()
local ray=cam:ViewportPointToRay(m.X,m.Y)
local ch=LP.Character
rp.FilterDescendantsInstances=if ch then {ch} else {}
local hit=Workspace:Raycast(ray.Origin,ray.Direction*2000,rp)
local mdl=hit and hit.Instance:FindFirstAncestorOfClass'Model'
while mdl and not Players:GetPlayerFromCharacter(mdl) do mdl=mdl:FindFirstAncestorOfClass'Model' end
return mdl and Players:GetPlayerFromCharacter(mdl)
end
clickBtn.Activated:Connect(function()
local m=CT() if m then m:Toggle() end
end)
proxBtn.Activated:Connect(function()
proxOn=not proxOn
proxBtn.Text='PROX: '..(if proxOn then 'ON' else 'OFF') Paint(proxBtn,proxOn)
end)

-- ===== Proximity =====
local viz
local function Viz(on)
if not on then if viz then viz:Destroy() viz=nil end return end
if not viz then
viz=Instance.new('Part') viz.Name='Proximity' viz.Anchored=true viz.CanCollide=false viz.CanQuery=false viz.CanTouch=false viz.CastShadow=false
viz.Shape=Enum.PartType.Cylinder viz.Color=Theme.Accent viz.Transparency=0.65 viz.Material=Enum.Material.Neon
aa.Owned[viz]=true
viz.Parent=Workspace.CurrentCamera or Workspace
end
local ch=LP.Character local rt=ch and ch:FindFirstChild'HumanoidRootPart'
if rt then
viz.Size=Vector3.new(0.4,range*2,range*2)
viz.CFrame=rt.CFrame*CFrame.Angles(0,0,math.rad(90))+Vector3.new(0,-2.8,0)
end
end


-- ===== Notificaciones (solo cuando te tiran admin) =====
do
local TweenService=game:GetService('TweenService')
local holder=New('Frame',{Name='APNotify',AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,140),Size=UDim2.new(0,420,1,-160),BackgroundTransparency=1,Active=false},ac.Overlay)
local hl=Instance.new('UIListLayout') hl.Padding=UDim.new(0,8) hl.SortOrder=Enum.SortOrder.LayoutOrder hl.HorizontalAlignment=Enum.HorizontalAlignment.Center hl.Parent=holder
local EM={ragdoll='\u{1F938}',rocket='\u{1F680}',jail='\u{1F512}',balloon='\u{1F388}',tiny='\u{1F41C}',inverse='\u{1F504}',jumpscare='\u{1F47B}',morph='\u{1F3AD}',nightvision='\u{1F319}',control='\u{1F3AE}'}
local cnt=0
_G.__APNotify=function(name,cmds,face,out)
cnt+=1
local wrap=New('Frame',{Size=UDim2.new(1,0,0,80),BackgroundTransparency=1,LayoutOrder=cnt},holder)
local card=New('Frame',{Position=UDim2.fromOffset(0,-120),Size=UDim2.fromScale(1,1),BackgroundColor3=Theme.Window},wrap)
ac.Corner(card,14) ac.Stroke(card)
local nbg=New('ImageLabel',{Name='Bg',Size=UDim2.fromScale(1,1),ZIndex=0,BackgroundTransparency=1,ImageTransparency=0.5,ScaleType=Enum.ScaleType.Crop,Visible=false},card)
ac.Corner(nbg,14)
if _G.__SE_AddBg then _G.__SE_AddBg(nbg) end
local av=New('ImageLabel',{Position=UDim2.fromOffset(14,14),Size=UDim2.fromOffset(52,52),BackgroundColor3=Theme.Field,BackgroundTransparency=0,Image=face or ''},card)
ac.Corner(av)
New('TextLabel',{Position=UDim2.fromOffset(78,12),Size=UDim2.new(1,-92,0,26),TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,TextSize=18,TextColor3=Theme.Text,TextTruncate=Enum.TextTruncate.AtEnd,Text=name,BackgroundTransparency=1},card)
local parts={}
for _,c in cmds do parts[#parts+1]=(EM[c] or '')..' '..c end
New('TextLabel',{Position=UDim2.fromOffset(78,40),Size=UDim2.new(1,-92,0,26),TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamMedium,TextSize=15,RichText=true,TextColor3=Theme.Sub,TextTruncate=Enum.TextTruncate.AtEnd,Text=if out then 'you used <font color="#'..Theme.Good:ToHex()..'">'..table.concat(parts,', ')..'</font>' else 'used <font color="#'..Theme.Bad:ToHex()..'">'..table.concat(parts,', ')..'</font> on you',BackgroundTransparency=1},card)
TweenService:Create(card,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.fromOffset(0,0)}):Play()
task.delay(5,function()
if not card.Parent then return end
local tw=TweenService:Create(card,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.fromOffset(0,-120)})
tw.Completed:Connect(function() wrap:Destroy() end)
tw:Play()
end)
end
end

local CLICK_R=8
local function AimedR()
local cam=Workspace.CurrentCamera if not cam then return nil end
local m=UIS:GetMouseLocation()
local ray=cam:ViewportPointToRay(m.X,m.Y)
local o,dir=ray.Origin,ray.Direction.Unit
local best,bd=nil,CLICK_R
for _,pl in Players:GetPlayers() do
if pl~=LP and not Black[pl.UserId] then
local rt=pl.Character and pl.Character:FindFirstChild'HumanoidRootPart'
if rt then
local v=rt.Position-o
local t=v:Dot(dir)
if t>0 then
local d=(v-dir*t).Magnitude
if d<=bd then best,bd=pl,d end
end
end
end
end
return best
end
-- jugador a <=8 studs del rayo del mouse (atraviesa estructuras) en rojo mientras Click to AP esta prendido
local aimHL=Instance.new('Highlight')
aimHL.FillColor=Color3.fromRGB(255,0,0) aimHL.OutlineColor=Color3.fromRGB(255,0,0)
aimHL.FillTransparency=0.25 aimHL.OutlineTransparency=0
aimHL.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
aa.Owned[aimHL]=true
aa.Clean(function() aimHL:Destroy() end)
aa.Connect(RunService.Heartbeat,function()
local p=if ClickOn() then AimedR() else nil
local ch=p and p~=LP and p.Character or nil
if ch then
if aimHL.Adornee~=ch then aimHL.Adornee=ch end
if aimHL.Parent~=Workspace then aimHL.Parent=Workspace end
else
if aimHL.Parent~=nil then aimHL.Parent=nil end
if aimHL.Adornee~=nil then aimHL.Adornee=nil end
end
end)
-- 1 click = 1 comando, siguiendo el Order (CLICK)
local seq={t=nil,i=0,at=0}
local function NextSeq(p)
local list=Active('click')
local n=#list
if n==0 then return nil end
if seq.t~=p or os.clock()-seq.at>10 then seq.i=0 end
for k=1,n do
local idx=(seq.i+k-1)%n+1
if ad.Remaining(list[idx])<=0 then return list[idx],idx end
end
return nil
end
aa.Connect(UIS.InputBegan,function(i,gp)
if gp or not ClickOn() or i.UserInputType~=Enum.UserInputType.MouseButton1 then return end
local p=AimedR()
if not p or p==LP then return end
local c,idx=NextSeq(p)
if c then
if RunB(p,c) then seq.t=p seq.i=idx seq.at=os.clock() Notify('Click AP',c..' -> '..p.DisplayName) end
else Notify('Click AP','All commands on cooldown','Warning') end
end)
local M
M=ab.Categories.Widgets:CreateModule{Name='Admin Panel',Early=true,Default=true,Tooltip='Run Ragdoll, Rocket, Jail and Balloon on players',Function=function(on)
win.Frame.Visible=on
if not on then return end
if not Roster.Loaded then M:Clean(task.spawn(Roster.Load)) end
Rebuild()
M:Clean(function() Viz(false) proxOn=false end)
M:Clean(Players.PlayerAdded:Connect(Rebuild))
M:Clean(Players.PlayerRemoving:Connect(function() task.defer(Rebuild) end))
M:Clean(RunService.Heartbeat:Connect(function() Viz(proxOn) end))
M:Clean(task.spawn(function()
local t=0
while true do
Tick()
t+=1
if t%2==1 then
local o=OwnerNow()
if o~=ownerPlr then ownerPlr=o Rebuild() end
RefreshTags()
end
if proxOn then
local ch=LP.Character local rt=ch and ch:FindFirstChild'HumanoidRootPart'
if rt then
for _,p in Players:GetPlayers() do
local pr=p~=LP and p.Character and p.Character:FindFirstChild'HumanoidRootPart'
if pr and not Black[p.UserId] and (pr.Position-rt.Position).Magnitude<=range then RunAll(p,'prox') end
end
end
end
task.wait(0.25)
end
end))
end}
ac.ScaleSlider(M,'Admin Panel')
return M
end function a.APW() local aa=a.cache.APW if not aa then aa={c=__modImpl()}a.cache.APW=aa end return aa.c end end
do local function __modImpl()
local aa=a.a() local ab=a.b() local ac=a.f()
local UIS=aa.Services.UserInputService
local Theme=ac.Theme local New=ac.New
local W,RH=236,34
local win=ac.Widget('Steal Panel','Target',W,UDim2.new(0,16,0.5,60))
local body=win.Body
body.AutomaticSize=Enum.AutomaticSize.None
body.Size=UDim2.new(1,0,0,8+10*(RH+6)+2)
do
local hd=win.Top hd.BackgroundTransparency=1
for _,c in hd:GetChildren() do if c:IsA'ImageLabel' or c:IsA'UIGradient' or c:IsA'TextLabel' or (c:IsA'Frame' and c.Size.Y.Offset==1) then c:Destroy() end end
hd.Size=UDim2.new(1,0,0,16)
body.Position=UDim2.fromOffset(0,16)
end
local function Opt(mod,name) local m=ab.Modules[mod] return m and m.Options and m.Options[name] end
local function Row(i)
local r=New('Frame',{Position=UDim2.fromOffset(8,8+(i-1)*(RH+6)),Size=UDim2.new(1,-16,0,RH),BackgroundColor3=Theme.Field,BackgroundTransparency=0},body)
ac.Corner(r,5) ac.Stroke(r)
return r
end
local function Lbl(r,t) New('TextLabel',{Position=UDim2.fromOffset(10,0),Size=UDim2.fromOffset(80,RH),TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Theme.Text,Text=t,BackgroundTransparency=1},r) end
local function Btn(r)
return New('TextButton',{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-6,0.5,0),Size=UDim2.fromOffset(120,24),BackgroundColor3=Theme.Field,Font=Enum.Font.GothamBold,TextSize=11,TextColor3=Theme.Text,Text='',AutoButtonColor=false},r)
end
-- Priority / Nearest
local r1=Row(1) Lbl(r1,'Steal Mode')
local pB=Btn(r1) ac.Corner(pB,5) ac.Stroke(pB)
pB.Activated:Connect(function()
local o=Opt('AutoSteal','Target') if not o then return end
o:Set(if o.Value=='Nearest' then 'Priority' else 'Nearest')
end)
-- Inv Steal
local r2=Row(2) Lbl(r2,'Inv Steal')
local iB=Btn(r2) ac.Corner(iB,5) ac.Stroke(iB)
iB.Activated:Connect(function()
local m=ab.Modules.Invisible if not m then return end
task.spawn(function()
local act=_G.InvisActive and _G.InvisActive()
if act and not m.Enabled then m:Toggle() task.wait(0.1) end
m:Toggle()
end)
end)
-- sliders
local sliders={}
local function Slider(i,label,modName,optName,min,max,dec)
local r=Row(i) Lbl(r,label)
local vL=New('TextLabel',{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-8,0,0),Size=UDim2.fromOffset(44,RH),TextXAlignment=Enum.TextXAlignment.Right,Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=Theme.Sub,Text='',BackgroundTransparency=1},r)
local track=New('Frame',{Position=UDim2.fromOffset(86,RH/2-4),Size=UDim2.new(1,-86-58,0,8),BackgroundColor3=Theme.Window,BorderSizePixel=0,Active=true},r)
local fill=New('Frame',{Size=UDim2.fromScale(0,1),BackgroundColor3=Theme.Accent,BorderSizePixel=0},track)
local knob=New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0,0.5),Size=UDim2.fromOffset(8,16),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=2},track)
local function Paint(v)
local p=math.clamp((v-min)/(max-min),0,1)
fill.Size=UDim2.fromScale(p,1) knob.Position=UDim2.fromScale(p,0.5)
vL.Text=string.format('%.'..dec..'f',v)
end
local dragging=false
local function FromMouse(x)
local ax,aw=track.AbsolutePosition.X,track.AbsoluteSize.X
if aw<=0 then return end
local v=min+(max-min)*math.clamp((x-ax)/aw,0,1)
local f=10^dec
v=math.floor(v*f+0.5)/f
local o=Opt(modName,optName)
if o then o:Set(v) end
Paint(v)
end
track.InputBegan:Connect(function(inp)
if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=true FromMouse(inp.Position.X) end
end)
aa.Connect(UIS.InputChanged,function(inp)
if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then FromMouse(inp.Position.X) end
end)
aa.Connect(UIS.InputEnded,function(inp)
if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
sliders[#sliders+1]=function()
if dragging then return end
local o=Opt(modName,optName)
if o and tonumber(o.Value) then Paint(o.Value) end
end
end
Slider(3,'Depth','Invisible','Depth',0,8.5,1)
Slider(4,'Rotation','Invisible','Rotation',180,360,0)
-- Auto Walkspeed on steal + slider
local r5w=Row(5)
local wB=New('TextButton',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Theme.Text,Text='Auto Walkspeed',AutoButtonColor=false},r5w)
wB.Activated:Connect(function() local A=_G.AngelicideWalkApi if A then A.W.on=not A.W.on A.save() end end)
do
local r=Row(6) Lbl(r,'Walkspeed')
local vL=New('TextLabel',{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-8,0,0),Size=UDim2.fromOffset(44,RH),TextXAlignment=Enum.TextXAlignment.Right,Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=Theme.Sub,Text='',BackgroundTransparency=1},r)
local track=New('Frame',{Position=UDim2.fromOffset(86,RH/2-4),Size=UDim2.new(1,-86-58,0,8),BackgroundColor3=Theme.Window,BorderSizePixel=0,Active=true},r)
ac.Corner(track,2)
local fill=New('Frame',{Size=UDim2.fromScale(0,1),BackgroundColor3=Theme.Accent,BorderSizePixel=0},track)
ac.Corner(fill,2)
local knob=New('Frame',{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0,0.5),Size=UDim2.fromOffset(8,16),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=2},track)
ac.Corner(knob,2)
local mn,mx=16,27
local function Paint(v)
local p=math.clamp((v-mn)/(mx-mn),0,1)
fill.Size=UDim2.fromScale(p,1) knob.Position=UDim2.fromScale(p,0.5)
vL.Text=tostring(math.floor(v+0.5))
end
local dragging=false
local function FromMouse(x)
local ax,aw=track.AbsolutePosition.X,track.AbsoluteSize.X
if aw<=0 then return end
local v=math.floor(mn+(mx-mn)*math.clamp((x-ax)/aw,0,1)+0.5)
local A=_G.AngelicideWalkApi
if A then A.W.v=v end
Paint(v)
end
track.InputBegan:Connect(function(inp)
if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=true FromMouse(inp.Position.X) end
end)
aa.Connect(UIS.InputChanged,function(inp)
if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then FromMouse(inp.Position.X) end
end)
aa.Connect(UIS.InputEnded,function(inp)
if dragging and (inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch) then dragging=false local A=_G.AngelicideWalkApi if A then A.save() end end
end)
sliders[#sliders+1]=function()
if dragging then return end
local A=_G.AngelicideWalkApi
if A then Paint(A.W.v) end
end
end
-- Auto kick
local r5=Row(7)
local kB=New('TextButton',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Theme.Text,Text='Auto kick',AutoButtonColor=false},r5)
kB.Activated:Connect(function() local m=ab.Modules['Auto Kick'] if m then m:Toggle() end end)
-- link del server (oculto con puntos) + Set
local r6=Row(8)
local tb=New('TextBox',{Position=UDim2.fromOffset(8,5),Size=UDim2.new(1,-78,1,-10),BackgroundColor3=Theme.Window,BackgroundTransparency=0,Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Theme.Text,TextTransparency=1,PlaceholderText='',ClearTextOnFocus=false,Text='',TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true},r6)
ac.Corner(tb,5)
local dots=New('TextLabel',{Position=UDim2.fromOffset(8,5),Size=UDim2.new(1,-78,1,-10),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Theme.Text,TextXAlignment=Enum.TextXAlignment.Left,Text='',ZIndex=3},r6)
New('UIPadding',{PaddingLeft=UDim.new(0,8)},dots)
local function PaintDots()
if tb.Text=='' then dots.Text='Private server link' dots.TextColor3=Theme.Faint dots.Font=Enum.Font.GothamMedium dots.TextSize=12
else dots.Text=string.rep('\u{2022}',math.min(#tb.Text,20)) dots.TextColor3=Theme.Text dots.Font=Enum.Font.GothamBold dots.TextSize=14 end
end
tb:GetPropertyChangedSignal('Text'):Connect(PaintDots)
PaintDots()
local setB=New('TextButton',{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-6,0.5,0),Size=UDim2.fromOffset(58,RH-10),BackgroundColor3=Theme.Accent,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.new(1,1,1),Text='Set',AutoButtonColor=false},r6)
ac.Corner(setB,5)
local loaded=false
setB.Activated:Connect(function()
local o=Opt('JoinPS','Private server link')
if o then o:Set(tb.Text) setB.Text='OK' task.delay(0.8,function() setB.Text='Set' end) end
end)
-- Join PS
local r7=Row(9)
local jB=New('TextButton',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Theme.Text,Text='Join PS',AutoButtonColor=false},r7)
jB.Activated:Connect(function() local m=ab.Modules.JoinPS if m and m.Join then task.spawn(m.Join) end end)
-- Kick (te saca del server; si hay link de PS valido, entra a el)
local r8=Row(10)
local kkB=New('TextButton',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Theme.Text,Text='Kick',AutoButtonColor=false},r8)
kkB.Activated:Connect(function()
local m=ab.Modules.JoinPS
local pl=m and m.Options and m.Options['Private server link']
local has=pl and pl.Value~='' and string.find(pl.Value,'code=',1,true)~=nil
game:GetService('Players').LocalPlayer:Kick('')
if has and m.Join then m.Join() end
end)
local function Refresh()
local km=ab.Modules['Auto Kick']
local kon=km and km.Enabled==true
kB.Text='Auto kick: '..(if kon then 'ON' else 'OFF')
kB.TextColor3=if kon then Theme.Good else Theme.Text
if not loaded then local o=Opt('JoinPS','Private server link') if o then loaded=true if tb.Text=='' then tb.Text=o.Value or '' end end end
local o=Opt('AutoSteal','Target')
pB.Text=if o then tostring(o.Value) else 'N/A'
local im=ab.Modules.Invisible
local v=(_G.InvisActive~=nil and _G.InvisActive()==true) or (im~=nil and im.Enabled==true)
iB.Text=if im then (if v then 'ON' else 'OFF') else 'N/A'
iB.TextColor3=if v then Theme.Good else Theme.Bad
do local A=_G.AngelicideWalkApi local won=A and A.W.on==true
wB.Text='Auto Walkspeed: '..(if won then 'ON' else 'OFF')
wB.TextColor3=if won then Theme.Good else Theme.Text end
for _,f in sliders do f() end
end
local M
M=ab.Categories.Widgets:CreateModule{Name='Steal Panel',Early=true,Default=true,Tooltip='Priority/Nearest, Inv Steal, Depth, Rotation and Walkspeed',Function=function(on)
win.Frame.Visible=on
if not on then return end
M:Clean(task.spawn(function()
while true do
Refresh()
task.wait(0.25)
end
end))
end}
ac.ScaleSlider(M,'Steal Panel')
return M
end function a.SPNL()local aa=a.cache.SPNL if not aa then aa={c=__modImpl()}a.cache.SPNL=aa end return aa.c end end



do local function __modImpl()
local aa=a.a() local UI=a.I() local Plots=a.t()
local RunService=aa.Services.RunService
local LP=aa.LocalPlayer
local board
local function Owner()
local ch=LP.Character local rt=ch and ch:FindFirstChild'HumanoidRootPart'
if not rt then return nil end
local pl,d=Plots.Nearest(rt.Position,function(p) return p.Owner~=nil and not p.Mine end)
local o=pl and pl.Owner
if d and d<=110 and typeof(o)=='Instance' and o:IsA'Player' and o~=LP then return o end
return nil
end
local function Hide()
if board then board.Enabled=false board.Adornee=nil end
end
local function Show(head)
if not board then
local b,l=UI.Billboard(head,Vector3.new(0,3.6,0),1,320)
b.Size=UDim2.fromOffset(320,64)
local t=l[1]
t.Position=UDim2.fromOffset(0,0) t.Size=UDim2.fromScale(1,1)
t.Font=Enum.Font.GothamBold t.TextSize=42
t.TextColor3=Color3.fromRGB(255,30,30)
t.TextStrokeTransparency=0 t.TextStrokeColor3=Color3.new(0,0,0)
t.Text='BASE OWNER'
board=b
end
if board.Adornee~=head then board.Adornee=head end
board.Enabled=true
end
local acc=0
aa.Clean(RunService.Heartbeat:Connect(function(dt)
acc+=dt
if acc<0.2 then return end
acc=0
local o=Owner()
local ch=o and o.Character
local head=ch and (ch:FindFirstChild'Head' or ch:FindFirstChild'HumanoidRootPart')
if head then Show(head) else Hide() end
end))
aa.Clean(function() if board then board:Destroy() board=nil end end)
return true
end function a.BOE() local aa=a.cache.BOE if not aa then aa={c=__modImpl()}a.cache.BOE=aa end return aa.c end end

local aa={[109983668079237]=true,[96342491571673]=true,[
123923334828954]=true,[120148879522453]=true}while game.PlaceId==0 do task.wait(
)end if not aa[game.PlaceId]then return end local ab=a.a()ab.Run('Menu',function
()a.f()end)ab.Ready()ab.Run(
'Blatant/CarpetSpeed',function()a.k()end)ab.Run('Blatant/InfiniteJump',function()a.m()end)ab.Run('Blatant/Invisible',
function()a.p()end)ab.Run("Blatant/NoCollide",function()a.q()end)
ab.Run('Render/BaseESP',function()a.L()
end)ab.Run('Render/BrainrotESP',function()a.M()end)ab.Run('Render/Fullbright',function()a.O()end)ab.Run(
'Render/HomeESP',function()a.P()end)ab.Run('Render/Indicators',function()a.Q()
end)ab.Run("Render/Optimizer",function()a.R()end)ab.Run('Render/PlayerESP',
function()a.S()end)ab.Run('Render/RosterTags',function()a.T()end)ab.Run('Render/Xray',function()a.V()end)ab.
Run('Settings/Menu',function()a.W()end)ab.Run('Settings/Priority',function()a.X(
)end)ab.Run('Settings/Reinject',function()a.Y()end)ab.Run('Settings/Unload',
function()a.Z()end)ab.Run('Steal/AutoSteal',function()a._()end)ab.Run(
'Steal/AutoUnlock',function()a.aa()end)ab.Run("Steal/LeaveOnSteal",function()a.ag()end)ab.Run('Steal/Teleport',
function()a.ah()end)ab.Run('Steal/Waypoint',function()a.ai()end)ab.Run(
'Utility/AntiAdmin',function()a.aj()end)ab.Run('Utility/AntiDeath',function()a.
ak()end)ab.Run('Utility/AntiEffects',function()a.al()end)ab.Run(
'Utility/AntiKnockback',function()a.am()end)ab.Run('Utility/AntiRagdoll',
function()a.an()end)ab.Run('Utility/AntiSwap',function()a.ao()end)ab.Run('Utility/ClickToAp',function(
)a.aq()end)ab.Run('Utility/CloneIn',function()a.ar()end)ab.Run(
'Utility/DropBrainrot',function()a.as()end)ab.Run('Utility/JoinPS',function()a.
at()end)ab.Run('Utility/Rejoin',function()a.au()end)ab.Run("Utility/Reset",
function()a.aw()end)ab.Run('Utility/ServerHop',function()a.ax()end)ab.Run('Widgets/AdminPanel',function()a.APW()end)ab.Run('Widgets/StealPanel',function()a.SPNL()end)ab.Run('Render/BaseOwnerESP',function()a.BOE()end)ab.Run(
'Widgets/TargetSelection',function()a.aB()end)ab.Run('Widgets/UnlockBar',
function()a.aC()end)ab.Run(
'World/AutoBuy',function()a.aE()end)
ab.Menu.Loaded(ab.Started)