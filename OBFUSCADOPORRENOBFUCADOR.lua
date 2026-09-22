local r1wro2q8=type local r1shsfuh=tostring local rf49pxn=tonumber local r1c98rw3=math.floor local rrkz0dh=string.byte local r1baz0sk=string.char local rbyfq7j=string.sub local r10wtcm6=string.find local r33a6mu=table.concat local ryu9bdd=table.unpack local r1lj476v=select local rhzd39v=error local rb1ulbd=math.max local r1joji3m=getmetatable local ry75iom=rawget local r1qe1gbn=next
local r1cayg3t="1MdAqEDomnx+wwoK5KE="
local r1p1o9ip="8OaNZapkbJt2S0jSxrw="
local r1xty2qa="w2VPJt44FlohpeW0NhI="
local r10rkjvq="tjGgtFK4A8c6hUqCzss="
local r1a7e6ht="HXBdbf2cAKnbdfcBWRk="
local r1sitkkt="0J2MnF9TK5mi8249a7I="
local r4ptpya="9qL1F+5lYAo7SlhubFI="
local r1wkfqzp="s52G4SLTQDWN/eR2rVk="
local rfqd4o2="7LHmwIbU8xqF4oD/oiM="
local r1exb5ut="e2p9bFrr3RZV4YfZxw=="
local r1sb9cpn="OpXYw5cCh0f4/gqrG70="
local rgsddck=function(s) local a="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" local r={} for i=1,64 do r[rbyfq7j(a,i,i)]=i-1 end local o={} local p=1 while p<=#s do local c1=rbyfq7j(s,p,p) local c2=rbyfq7j(s,p+1,p+1) local c3=rbyfq7j(s,p+2,p+2) local c4=rbyfq7j(s,p+3,p+3) p=p+4 local n1=r[c1] or 0 local n2=r[c2] or 0 local n3=c3=="=" and 0 or (r[c3] or 0) local n4=c4=="=" and 0 or (r[c4] or 0) local n=n1*262144+n2*4096+n3*64+n4 o[#o+1]=r1baz0sk(r1c98rw3(n/65536)%256) if c3~="=" then o[#o+1]=r1baz0sk(r1c98rw3(n/256)%256) end if c4~="=" then o[#o+1]=r1baz0sk(n%256) end end return r33a6mu(o) end
local r1d4hmyd=function(s,st,inv,inv2,st2) st=rf49pxn(st) or 0 st2=rf49pxn(st2) or 0 local function m32(a,b) local al=a%65536 local ah=r1c98rw3(a/65536)%65536 local bl=b%65536 local bh=r1c98rw3(b/65536)%65536 return (al*bl+((al*bh+ah*bl)%65536)*65536)%4294967296 end local b=rgsddck(s) local o={} for i=1,#b do local y=rrkz0dh(b,i) if not y then return nil end if inv2 then st2=(m32(st2,22695477)+1)%4294967296 local k2=r1c98rw3(st2/16777216)%256 local mapped=inv2[y+1] if mapped==nil then return nil end y=(mapped-k2+256)%256 end st=(m32(st,1664525)+1013904223)%4294967296 local k=r1c98rw3(st/16777216)%256 local mapped=inv[y+1] if mapped==nil then return nil end o[i]=r1baz0sk((mapped-k+256)%256) end return r33a6mu(o) end
local r1vxdtjp=function(s) local p=1 local L=#s return {u8=function() if p>L then return nil end local v=rrkz0dh(s,p) p=p+1 return v end,u16=function() if p+1>L then return nil end local a=rrkz0dh(s,p) local b=rrkz0dh(s,p+1) p=p+2 return a+b*256 end,u32=function() if p+3>L then return nil end local a=rrkz0dh(s,p) local b=rrkz0dh(s,p+1) local c=rrkz0dh(s,p+2) local d=rrkz0dh(s,p+3) p=p+4 return (a+b*256+c*65536+d*16777216)%4294967296 end,take=function(_,n) n=rf49pxn(n) if not n or n<0 or p+n-1>L then return nil end local v=rbyfq7j(s,p,p+n-1) p=p+n return v end,pos=function() return p end} end
local rycmesy=(function() local parts={} local inv={44,59,177,139,42,148,230,113,232,187,132,213,142,193,118,110,223,17,89,190,130,182,155,183,171,202,28,93,86,143,120,134,136,154,237,164,49,5,128,61,203,153,3,87,151,133,157,19,21,146,103,219,207,236,50,85,175,77,66,199,0,244,91,220,68,222,29,218,250,9,57,194,255,201,109,165,1,147,226,158,186,161,217,252,39,254,198,108,215,111,239,116,82,248,123,234,72,149,206,172,60,31,63,209,173,46,137,170,32,233,26,8,45,205,12,221,126,95,65,34,27,11,51,6,184,241,208,70,214,14,41,251,140,122,145,152,69,100,96,102,52,191,23,253,245,4,180,156,90,10,238,38,224,195,73,78,16,101,18,76,242,160,22,174,169,127,167,181,94,246,92,129,159,144,227,35,243,197,216,240,67,2,84,47,138,33,40,121,185,200,75,15,192,83,141,162,212,56,53,112,107,150,62,24,25,98,7,43,97,131,115,13,228,125,119,80,163,231,37,71,74,124,189,99,64,58,168,55,235,54,48,36,225,247,105,88,178,188,249,210,30,229,79,114,81,20,135,104,166,204,179,176,106,196,117,211} local inv2={233,210,16,192,139,20,135,4,193,126,14,39,236,32,45,180,239,127,196,108,47,121,188,237,167,212,87,123,88,163,216,140,125,226,204,109,115,68,40,220,17,106,195,155,234,59,153,228,86,252,85,165,201,97,69,9,176,98,219,110,122,42,3,31,73,54,251,0,37,137,129,191,80,217,30,205,107,208,247,185,159,90,65,169,131,213,223,182,101,51,186,146,1,92,112,241,145,44,243,100,60,66,52,105,21,23,138,128,114,148,61,184,136,168,74,56,75,222,198,82,255,11,235,152,246,13,249,179,72,94,71,55,248,63,96,111,203,38,124,83,48,103,207,189,91,242,162,24,134,34,25,22,161,158,175,238,211,166,79,149,230,7,29,76,151,227,133,190,104,171,84,58,6,214,183,53,144,57,130,147,143,231,102,224,202,18,229,221,177,15,2,194,206,172,178,33,240,19,156,181,253,170,99,77,244,232,199,26,173,12,70,113,67,160,28,49,78,36,117,35,46,5,218,8,154,141,50,225,27,93,43,209,120,254,245,116,41,10,118,197,174,95,132,200,250,215,187,150,164,81,119,62,142,89,157,64} parts[1]=r1d4hmyd(r1cayg3t,28677820,inv,inv2,3536228149) parts[8]=r1d4hmyd(r1p1o9ip,3458329584,inv,inv2,3104221257) parts[4]=r1d4hmyd(r1xty2qa,3339248245,inv,inv2,3328216106) parts[3]=r1d4hmyd(r10rkjvq,2235745345,inv,inv2,2433290604) parts[7]=r1d4hmyd(r1a7e6ht,2354851374,inv,inv2,4220160267) parts[2]=r1d4hmyd(r1sitkkt,1132254790,inv,inv2,2588942963) parts[6]=r1d4hmyd(r4ptpya,1251360819,inv,inv2,3748425224) parts[10]=r1d4hmyd(r1wkfqzp,1370466848,inv,inv2,896422577) parts[9]=r1d4hmyd(rfqd4o2,266963948,inv,inv2,3893210469) parts[11]=r1d4hmyd(r1exb5ut,2474006783,inv,inv2,834357174) parts[5]=r1d4hmyd(r1sb9cpn,147894954,inv,inv2,1603496075) local rawParts={} for i=1,11 do rawParts[#rawParts+1]=parts[i] end local raw=r33a6mu(rawParts) if not raw or #raw==0 then return nil end local R=r1vxdtjp(raw) local x={} x.magic=R:u32() x.version=R:u8() x.level=R:u8() x.seed=R:u32() x.opcount=R:u16() x.gxor=R:u8() x.gbias=R:u8() x.root=R:u16() x.stringCount=R:u16() x.codeCount=R:u16() x.check=R:u32() x.decoy=R:u16() x.payloadPos=R:pos() x._raw=raw local h=2166136261 for i=x.payloadPos,#raw do h=(h*65599+rrkz0dh(raw,i)+17)%4294967296 end if x.magic~=1380864567 or x.version~=11 or x.level~=3 or x.seed~=3220043456 or x.opcount~=57 or x.gxor~=14 or x.gbias~=172 or x.root~=0 or x.stringCount~=3 or x.codeCount~=1 or h~=x.check then return nil end x.strings={} local sc=R:u16() if sc~=x.stringCount then return nil end for i=1,sc do local n=R:u16() x.strings[i]={d=R:take(n),key=(x.seed+(i-1)*709607)%4294967296} end x.codes={} local cc=R:u16() if cc~=x.codeCount then return nil end for ci=1,cc do local c={params={},variadic=R:u8()~=0,constants={},blocks={},byState={}} local pc=R:u8() for j=1,pc do c.params[j]=R:u16() end c.stateKey=R:u32() c.opXor=R:u8() c.bias=R:u8() local kc=R:u16() for j=1,kc do local t=R:u8() if t==0 then c.constants[j]={t=0} elseif t==1 then c.constants[j]={t=1,s=R:u16()} elseif t==2 then c.constants[j]={t=2,b=R:u8()~=0} elseif t==3 then c.constants[j]={t=3,s=R:u16()} elseif t==4 then c.constants[j]={t=4,c=R:u16()} else return nil end end local bc=R:u16() c.root=R:u32() for j=1,bc do local token=R:u32() local nxt=R:u32() local guard=R:u32() local ic=R:u16() local b={token=token,next=nxt,guard=guard,inst={}} for q=1,ic do local ln=R:u16() b.inst[q]=R:take(ln) end c.blocks[j]=b c.byState[token]=b end x.codes[ci]=c end return x end)()
if not rycmesy then return end
local r10cx781=function(ctx,id) local c=ctx.strCache[id] if c~=nil then return c end local e=rycmesy.strings[id+1] if not e then return "" end local d=e.d local o={} local k=e.key for i=1,#d do k=(k*1664525+1013904223)%4294967296 local b=rrkz0dh(d,i) local plain=(b-r1c98rw3(k/16777216)%256-(i-1)*13)%256 o[i]=r1baz0sk(plain) end local s=r33a6mu(o) ctx.strCache[id]=s return s end
local r17jvbxa=function(v) return v~=nil and v~=false end
local rqpln7z={}
local r14j455k=function(v) return {tag=rqpln7z,values=v,n=v.n or #v} end
local rbwqh57=function(v) return r1wro2q8(v)=="table" and v.tag==rqpln7z and r1wro2q8(v.values)=="table" end
local r1m24kjq=function(...) local a={...} a.n=r1lj476v('#',...) return a end
local r1gbr0k2=function(a) local n=a.n or #a local last=a[n] if rbwqh57(last) then a[n]=nil n=n-1 for i=1,last.n do a[n+i]=last.values[i] end a.n=n+last.n end return a end
local r18d8ylv=function(parent,global) return {values={},declared={},parent=parent,global=global} end
local r1st1xm=function(e,n) local p=e while p do if p.global then return p.base[n] elseif p.declared[n] then return p.values[n] end p=p.parent end return nil end
local rxkhkrn=function(e,n,v) local p=e while p do if p.global then p.base[n]=v return elseif p.declared[n] then p.values[n]=v return end p=p.parent end e.values[n]=v e.declared[n]=true end
local rhslbww=function(e,n,v) e.values[n]=v e.declared[n]=true end
local r60wlgb=function(ctx,i) local c=ctx.code.constants[i+1] if not c then return nil end if c.r then return c.v elseif c.t==0 then c.r=true c.v=nil return nil elseif c.t==2 then c.r=true c.v=(c.b==true) return c.v elseif c.t==3 then local s=r10cx781(ctx,c.s) c.r=true c.v=s return s elseif c.t==1 then local n=rf49pxn(r10cx781(ctx,c.s)) c.r=true c.v=n return n elseif c.t==4 then return rycmesy.codes[c.c+1] end return nil end
local r10ac0t6=function(blob,key) local o={} local k=key for i=1,#blob do k=(k*1664525+1013904223)%4294967296 local b=rrkz0dh(blob,i) o[i]=r1baz0sk((b-r1c98rw3(k/16777216)%256-(i-1)*13+512)%256) end return r33a6mu(o) end
local rjwizxr; local rxqh1lg; local ri93qes
rjwizxr=function(fn,args,env) local v=r1m24kjq(fn(ryu9bdd(args,1,args.n or #args))) return v end
rxqh1lg=function(code,env) return function(...) local a=r1m24kjq(...) local v=ri93qes(code,env,a) return ryu9bdd(v,1,v.n or #v) end end
local function r3ibdbv(ctx,A,B,C) local v=r60wlgb(ctx,A) ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=v end
local function r1szs531(ctx,A,B,C) ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=r1st1xm(ctx.env,r10cx781(ctx,A)) end
local function r1lw9kog(ctx,A,B,C) local v=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 rxkhkrn(ctx.env,r10cx781(ctx,A),v) end
local function royfmca(ctx,A,B,C) local v=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 rhslbww(ctx.env,r10cx781(ctx,A),v) end
local function r17jxo2u(ctx,A,B,C) ctx.stack[ctx.sp]=nil ctx.sp=rb1ulbd(0,ctx.sp-1) end
local function rt3axpw(ctx,A,B,C) local v=ctx.stack[ctx.sp] ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=v end
local function r1wcosj4(ctx,A,B,C) ctx.env=r18d8ylv(ctx.env,false) end
local function re8v85z(ctx,A,B,C) ctx.env=ctx.env.parent or ctx.env end
local function r11heqte(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a+b end
local function r1heu63n(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a-b end
local function r1pdtmux(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a*b end
local function r1qxhm5i(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a/b end
local function r1yzx36l(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=r1c98rw3(a/b) end
local function rz54rax(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a%b end
local function r11dvam2(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a^b end
local function r4kzsku(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a..b end
local function r1v0cw8p(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=r1shsfuh(a)..r1shsfuh(b) end
local function rqn0o7e(ctx,A,B,C) ctx.stack[ctx.sp]=r1shsfuh(ctx.stack[ctx.sp]) end
local function r1v0cv80(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a==b end
local function rg45d7c(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a~=b end
local function r1d4a7qt(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a<b end
local function rer9upa(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a<=b end
local function rie7uku(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a>b end
local function r11asi7a(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=a>=b end
local function r1brv3qo(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 if r17jvbxa(a) then ctx.stack[ctx.sp]=b else ctx.stack[ctx.sp]=a end end
local function rcz9wn8(ctx,A,B,C) local b=ctx.stack[ctx.sp] local a=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 if r17jvbxa(a) then ctx.stack[ctx.sp]=a else ctx.stack[ctx.sp]=b end end
local function r1vxo1wg(ctx,A,B,C) ctx.stack[ctx.sp]=-ctx.stack[ctx.sp] end
local function r14o8rem(ctx,A,B,C) ctx.stack[ctx.sp]=not r17jvbxa(ctx.stack[ctx.sp]) end
local function r1gn5sq9(ctx,A,B,C) return A end
local function r6uiyg8(ctx,A,B,C) local v=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 if r17jvbxa(v) then return ctx.fall else return A end end
local function r2b26qm(ctx,A,B,C) local n=A local a={} for i=n,1,-1 do a[i]=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 end a=r1gbr0k2(a) local fn=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 local out=rjwizxr(fn,a,ctx.env) ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=out[1] end
local function r80g63c(ctx,A,B,C) local n=A local a={} for i=n,1,-1 do a[i]=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 end a=r1gbr0k2(a) local fn=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 local out=rjwizxr(fn,a,ctx.env) ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=r14j455k(out) end
local function rsnlhep(ctx,A,B,C) local n=A local a={} for i=n,1,-1 do a[i]=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 end a=r1gbr0k2(a) local fn=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 local self=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 for i=#a,1,-1 do a[i+1]=a[i] end a[1]=self local out=rjwizxr(fn,a,ctx.env) ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=(C~=0 and r14j455k(out) or out[1]) end
local function r13k9it9(ctx,A,B,C) ctx.returned=true ctx.returnValues={n=1,[1]=ctx.stack[ctx.sp]} return 0 end
local function ryns9np(ctx,A,B,C) local top=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 local vals={} local n=0 if rbwqh57(top) then for i=1,ctx.sp do n=n+1 vals[n]=ctx.stack[i] end for i=1,top.n do n=n+1 vals[n]=top.values[i] end else for i=1,ctx.sp do n=n+1 vals[n]=ctx.stack[i] end n=n+1 vals[n]=top end vals.n=n ctx.returned=true ctx.returnValues=vals return 0 end
local function rw0duxl(ctx,A,B,C) local co=r60wlgb(ctx,A) ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=rxqh1lg(co,ctx.env) end
local function r17opfka(ctx,A,B,C) ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]={} end
local function r1q23pxo(ctx,A,B,C) local k=ctx.stack[ctx.sp] local o=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=o[k] end
local function rr4wxhi(ctx,A,B,C) local k=ctx.stack[ctx.sp] local o=ctx.stack[ctx.sp-1] ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=o[k] end
local function r1voyg0p(ctx,A,B,C) local v=ctx.stack[ctx.sp] if A>=1000 then ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 local o=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 local start=A-1000 if C~=0 and rbwqh57(v) then for i=1,v.n do o[start+i-1]=v.values[i] end else o[start]=v end ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=o else local k=ctx.stack[ctx.sp-1] local o=ctx.stack[ctx.sp-2] ctx.stack[ctx.sp]=nil ctx.stack[ctx.sp-1]=nil ctx.sp=ctx.sp-2 o[k]=v ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=o end end
local function r1ai74ih(ctx,A,B,C) local o=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=o[r10cx781(ctx,A)] end
local function rszxx1t(ctx,A,B,C) local v=ctx.stack[ctx.sp] local o=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 o[r10cx781(ctx,A)]=v ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=o end
local function r1z0261z(ctx,A,B,C) ctx.stack[ctx.sp]=#ctx.stack[ctx.sp] end
local function r9sxbw(ctx,A,B,C) local step=ctx.stack[ctx.sp] local stop=ctx.stack[ctx.sp-1] local start=ctx.stack[ctx.sp-2] ctx.stack[ctx.sp]=nil ctx.stack[ctx.sp-1]=nil ctx.stack[ctx.sp-2]=nil ctx.sp=ctx.sp-3 if r1wro2q8(start)~="number" or r1wro2q8(stop)~="number" or r1wro2q8(step)~="number" then rhzd39v("REN: invalid numeric for operands",0) end if step==0 then rhzd39v("REN: numeric for step is zero",0) end local name=r10cx781(ctx,A) local num={base=ctx.env,name=name,stop=stop,step=step} local depth=#ctx.numericStack+1 ctx.numericStack[depth]=num if (step>=0 and start>stop) or (step<0 and start<stop) then ctx.numericStack[depth]=nil return B end local it=r18d8ylv(ctx.env,false) rhslbww(it,name,start) it.iter=true ctx.env=it end
local function r38wjbt(ctx,A,B,C) local depth=#ctx.numericStack local num=ctx.numericStack[depth] if not num then rhzd39v("REN: numeric for state missing",0) end local cur=r1st1xm(ctx.env,num.name) ctx.env=ctx.env.parent or ctx.env local next=cur+num.step if (num.step>=0 and next<=num.stop) or (num.step<0 and next>=num.stop) then local it=r18d8ylv(ctx.env,false) rhslbww(it,num.name,next) it.iter=true ctx.env=it return B else ctx.numericStack[depth]=nil return ctx.fall end end
local function r187eqvb(ctx,A,B,C) local control=ctx.stack[ctx.sp] local state=ctx.stack[ctx.sp-1] local iterator=ctx.stack[ctx.sp-2] ctx.stack[ctx.sp]=nil ctx.stack[ctx.sp-1]=nil ctx.stack[ctx.sp-2]=nil ctx.sp=ctx.sp-3 local original=iterator local mt=r1joji3m(iterator) local iterf=nil if r1wro2q8(mt)=="table" then iterf=ry75iom(mt,"__iter") end if iterf~=nil then local r=rjwizxr(iterf,{original,n=1},ctx.env) iterator=r[1] state=r[2] control=r[3] elseif r1wro2q8(iterator)=="table" then iterator=r1qe1gbn state=original control=nil end ctx.generic={base=ctx.env,iterator=iterator,state=state,control=control} end
local function ran0nje(ctx,A,B,C) local g=ctx.generic if ctx.env.iter then ctx.env=ctx.env.parent or ctx.env end local out=rjwizxr(g.iterator,{g.state,g.control,n=2},ctx.env) if out[1]==nil then return B end g.control=out[1] local it=r18d8ylv(g.base,false) it.iter=true local list=r10cx781(ctx,A) local pos=1 local p=1 while p<=#list do local q=r10wtcm6(list,",",p,true) local name if q then name=rbyfq7j(list,p,q-1) p=q+1 else name=rbyfq7j(list,p) p=#list+1 end rhslbww(it,name,out[pos]) pos=pos+1 end ctx.env=it end
local function r19mw8hh(ctx,A,B,C) ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=r14j455k(ctx.varargs) end
local function r10dw7qd(ctx,A,B,C) ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=ctx.varargs[1] end
local function rb3ezfp(ctx,A,B,C) local top=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 local vals=rbwqh57(top) and top.values or {[1]=top,n=1} for i=1,A do ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]=vals[i] end end
local function r1n51xfp(ctx,A,B,C) ctx.sp=ctx.sp+1 ctx.stack[ctx.sp]={k=1,env=ctx.env,n=r10cx781(ctx,A)} end
local function rxbg04e(ctx,A,B,C) local o=ctx.stack[ctx.sp] ctx.stack[ctx.sp]={k=2,o=o,p=r10cx781(ctx,A)} end
local function r177zxxp(ctx,A,B,C) local k=ctx.stack[ctx.sp] local o=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]={k=2,o=o,p=k} end
local function r13y8vmf(ctx,A,B,C) local r=ctx.stack[ctx.sp] if r.k==1 then ctx.stack[ctx.sp]=r1st1xm(r.env,r.n) else ctx.stack[ctx.sp]=r.o[r.p] end end
local function r1koznax(ctx,A,B,C) local v=ctx.stack[ctx.sp] local r=ctx.stack[ctx.sp-1] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 if r.k==1 then rxkhkrn(r.env,r.n,v) else r.o[r.p]=v end end
local function r49mldn(ctx,A,B,C) local n=A local vals={} for i=n,1,-1 do vals[i]=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 end local refs={} for i=n,1,-1 do refs[i]=ctx.stack[ctx.sp] ctx.stack[ctx.sp]=nil ctx.sp=ctx.sp-1 end for i=1,n do local r=refs[i] local v=vals[i] if r.k==1 then rxkhkrn(r.env,r.n,v) else r.o[r.p]=v end end end
local function rjfvify(ctx,A,B,C)  end
local r1d4zmmk={}
local r152ysz8={17,7,12,27,51,16,43,25,54,48,32,30,44,14,57,52,39,50,34,26,56,5,46,49,22,42,21,55,1,19,29,23,28,11,24,10,38,36,41,15,6,35,45,9,40,47,2,20,18,13,8,31,53,33,3,4,37}
for i=1,57 do r1d4zmmk[i]=nil end
r1d4zmmk[17]=r3ibdbv
r1d4zmmk[7]=r1szs531
r1d4zmmk[12]=r1lw9kog
r1d4zmmk[27]=royfmca
r1d4zmmk[51]=r17jxo2u
r1d4zmmk[16]=rt3axpw
r1d4zmmk[43]=r1wcosj4
r1d4zmmk[25]=re8v85z
r1d4zmmk[54]=r11heqte
r1d4zmmk[48]=r1heu63n
r1d4zmmk[32]=r1pdtmux
r1d4zmmk[30]=r1qxhm5i
r1d4zmmk[44]=r1yzx36l
r1d4zmmk[14]=rz54rax
r1d4zmmk[57]=r11dvam2
r1d4zmmk[52]=r4kzsku
r1d4zmmk[39]=r1v0cw8p
r1d4zmmk[50]=rqn0o7e
r1d4zmmk[34]=r1v0cv80
r1d4zmmk[26]=rg45d7c
r1d4zmmk[56]=r1d4a7qt
r1d4zmmk[5]=rer9upa
r1d4zmmk[46]=rie7uku
r1d4zmmk[49]=r11asi7a
r1d4zmmk[22]=r1brv3qo
r1d4zmmk[42]=rcz9wn8
r1d4zmmk[21]=r1vxo1wg
r1d4zmmk[55]=r14o8rem
r1d4zmmk[1]=r1gn5sq9
r1d4zmmk[19]=r6uiyg8
r1d4zmmk[29]=r2b26qm
r1d4zmmk[23]=r80g63c
r1d4zmmk[28]=rsnlhep
r1d4zmmk[11]=r13k9it9
r1d4zmmk[24]=ryns9np
r1d4zmmk[10]=rw0duxl
r1d4zmmk[38]=r17opfka
r1d4zmmk[36]=r1q23pxo
r1d4zmmk[41]=rr4wxhi
r1d4zmmk[15]=r1voyg0p
r1d4zmmk[6]=r1ai74ih
r1d4zmmk[35]=rszxx1t
r1d4zmmk[45]=r1z0261z
r1d4zmmk[9]=r9sxbw
r1d4zmmk[40]=r38wjbt
r1d4zmmk[47]=r187eqvb
r1d4zmmk[2]=ran0nje
r1d4zmmk[20]=r19mw8hh
r1d4zmmk[18]=r10dw7qd
r1d4zmmk[13]=rb3ezfp
r1d4zmmk[8]=r1n51xfp
r1d4zmmk[31]=rxbg04e
r1d4zmmk[53]=r177zxxp
r1d4zmmk[33]=r13y8vmf
r1d4zmmk[3]=r1koznax
r1d4zmmk[4]=r49mldn
r1d4zmmk[37]=rjfvify
local r1iuh5vv={0,37,55,56,10,31,24,45,30,39,50,1,23,15,12,11,25,28,34,2,42,4,7,17,20,32,52,8,16,54,27,5,22,26,44,43,40,49,3,9,33,46,18,29,48,14,21,35,41,38,47,13,6,51,19,53,36}
local rtsevbs=function(ctx) if ctx and ctx.code and ctx.code.stateKey==0 then local p=r10cx781(ctx,0) local f=r1st1xm(ctx,"print") if r1wro2q8(f)=="function" then f(p) end end return nil end
local xseed=function(a,b,c) return ((3220043456+((a*65599)%4294967296)+((b*257)%4294967296)+c*8191)%4294967296) end
local ri93qes=function(code,outer,args) local ctx={code=code,env=r18d8ylv(outer,false),stack={},sp=0,varargs=args or {n=0},strCache={},numericStack={},generic=nil,returned=false,returnValues=nil,fall=0} local root=ctx.env for i=1,#code.params do local nm=r10cx781(ctx,code.params[i]) rhslbww(root,nm,args[i]) end local state=code.root while state~=0 do local block=code.byState[state] if not block then rhzd39v("REN: bad state",0) end local guard=(3220043456+block.token)%4294967296 for i=1,#block.inst do local blob=block.inst[i] for q=1,#blob do guard=(guard*65599+rrkz0dh(blob,q)+17)%4294967296 end end if guard~=block.guard then rhzd39v("REN: VM integrity",0) end if #r1d4zmmk~=57 or #r152ysz8~=57 then rhzd39v("REN: handler integrity",0) end ctx.fall=block.next local jumped=false for si=1,#block.inst do local rawblob=block.inst[si] local innerKey=(xseed(code.stateKey,block.token,si)) local blob=r10ac0t6(rawblob,innerKey) local pos=1 local enc=rrkz0dh(blob,pos) pos=pos+1 local delta=(code.bias+block.token%256+(si-1)*17+172)%256 local physical=(enc-14-code.opXor-delta)%256 local op=r1iuh5vv[physical+1] if op==nil then rhzd39v("REN: opcode",0) end local mask=(code.stateKey+block.token+si*1199540897)%4294967296 local vals={} for oi=1,3 do local t=rrkz0dh(blob,pos) pos=pos+1 if t==0 then vals[oi]=nil elseif t==1 then local a=rrkz0dh(blob,pos) local b=rrkz0dh(blob,pos+1) local c=rrkz0dh(blob,pos+2) local d=rrkz0dh(blob,pos+3) pos=pos+4 local v=(a+b*256+c*65536+d*16777216-mask)%4294967296 vals[oi]=v>=2147483648 and v-4294967296 or v elseif t==2 then local a=rrkz0dh(blob,pos) local b=rrkz0dh(blob,pos+1) pos=pos+2 vals[oi]=(a+b*256-(mask%65536)+65536)%65536 end end local h=r1d4zmmk[r152ysz8[op+1]] if not h then rhzd39v("REN: handler",0) end local ns=h(ctx,vals[1],vals[2],vals[3]) if ctx.returned then return ctx.returnValues end if ns~=nil then state=ns jumped=true break end end if not jumped then state=ctx.fall end end return ctx.returnValues or {n=1,[1]=nil} end
local r14i9q4e = r18d8ylv(nil,true)
r14i9q4e.base=_ENV
return ri93qes(rycmesy.codes[1],r14i9q4e,r1m24kjq())