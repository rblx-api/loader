--[[ Stick Obfuscador v1.2 | hex_escape · ironbrew · luraph · moonsec · xor_loop · bytecode ]]
-- lua 5.1 / luau : loadstring|load|+getrenv/getgenv
local _M
do
 _M=function()
-- Stick LPH layer
local _i1illIII116=assert
local _II11_l_i1i7=select
local function __LPH_MACRO_MATH(x) return x end
local function __LPH_MACRO_1996(...) return _II11_l_i1i7(1,...) end
local _1_l_i1illI1={"\x26\xE1\xA1\x71\xDF\x81\x16\xD5\x0E\xE3\x14\x49\xE6\x3B";"\x16\xD4\xDA\x04\xF8\xEB\x7B\x3D\xAE\x85\x5E\x31\x8E\x0D\x5D\xEC\xA5\x63\x1A\xCF\xA3\x4E\x82\xC0\x77\xD0\xEC\xBB\x2B\x65";"\x01\xDF";"\x27\xA1\xEB\x22\x19\x06\x90\x02\x87\xE2\x2C\x4D\xE3\x57\x97\x10\x8B\x07\x34\xBB\xC0\x68\xF1\xE8\x9B\x67\x96\xC0"}
local _illIII11_l2={0x47,0x8D,0xE3,0x27,0xEE,0xF3,0x6B,0xD1,0x1E}
local _I11_l_i1il3={0x1,0x2,0x4,0x3}
local _1_l_i1illI2s={0x11,0x30,0x4F,0x6E}
local _i1illIII114={0x1,0x1,0x1,0x2,0x1,0x3,0x1,0x4,0x2,0x3}
local __i1illIII16,_lIII11_l_i17,__l_i1illII8=string.char,string.byte,table.concat
local _II11_l_i1i5
do
 local _b32=bit32
 local _b=bit
 if _b32 and _b32.bxor then
  _II11_l_i1i5=_b32.bxor
 elseif _b and _b.bxor then
  _II11_l_i1i5=_b.bxor
 else
  _II11_l_i1i5=function(a,b)
   local r,p=0,1
   a=a-a%1
   b=b-b%1
   a=a-256*(a/256-a/256%1)
   b=b-256*(b/256-b/256%1)
   if a<0 then a=a+256 end
   if b<0 then b=b+256 end
   for _=1,8 do
    local x,y=a%2,b%2
    if x~=y then r=r+p end
    a=(a-x)/2
    b=(b-y)/2
    p=p*2
   end
   return r
  end
 end
end
local _illIII11_l11
local function _llIII11_l_9(_i1illIII115,_1_l_i1illI2)
  local _I11_l_i1il4={}
  for _illIII11_l3=1,#_i1illIII115 do
   local z=_lIII11_l_i17(_i1illIII115,_illIII11_l3)
   z=_II11_l_i1i5(z,_illIII11_l2[((_illIII11_l3-1)%#_illIII11_l2)+1])
   z=_II11_l_i1i5(z,(_1_l_i1illI2+(_illIII11_l3-1)*13)%256)
   _I11_l_i1il4[_illIII11_l3]=__i1illIII16(z)
  end
  return __l_i1illII8(_I11_l_i1il4)
end
local _I11_l_i1il12,_1_l_i1illI10=1,{}
while _I11_l_i1il12<=#_i1illIII114 do
 local _i1illIII1113=_i1illIII114[_I11_l_i1il12]
 if _i1illIII1113==1 then
  local _II11_l_i1i6=_i1illIII114[_I11_l_i1il12+1]
  local slot=_I11_l_i1il3[_II11_l_i1i6]
  _1_l_i1illI10[_II11_l_i1i6]=_llIII11_l_9(_1_l_i1illI1[slot],_1_l_i1illI2s[_II11_l_i1i6])
  _I11_l_i1il12=_I11_l_i1il12+2
 elseif _i1illIII1113==2 then
  _illIII11_l11=__l_i1illII8(_1_l_i1illI10)
  _I11_l_i1il12=_I11_l_i1il12+1
 elseif _i1illIII1113==7 then
  _I11_l_i1il12=_I11_l_i1il12+2
 elseif _i1illIII1113==3 then
  break
 else
  _I11_l_i1il12=_I11_l_i1il12+1
 end
end
local __l_i1illII0=__i1illIII16(108,111,97,100,115,116,114,105,110,103)
local _llIII11_l_1=getfenv and getfenv() or _ENV or _G
local _lIII11_l_i116=loadstring or load
if not _lIII11_l_i116 and _llIII11_l_1 then _lIII11_l_i116=_llIII11_l_1[__l_i1illII0] or _llIII11_l_1[ __i1illIII16(108,111,97,100) ] end
if not _lIII11_l_i116 and getrenv then
 local r=getrenv()
 _lIII11_l_i116=r.loadstring or r.load or r[__l_i1illII0]
end
if not _lIII11_l_i116 and getgenv then
 local g=getgenv()
 _lIII11_l_i116=g.loadstring or g.load
end
if not _lIII11_l_i116 then error("sin loadstring/load") end
local _II11_l_i1i14,__i1illIII115=_lIII11_l_i116(_illIII11_l11)
if not _II11_l_i1i14 then error(__i1illIII115 or "load fail") end
if setfenv and getfenv then pcall(setfenv,_II11_l_i1i14,getfenv()) end
return _II11_l_i1i14()
 end
end
return _M()
