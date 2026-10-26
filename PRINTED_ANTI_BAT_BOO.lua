--[[ Nocturne Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\xAF\x32\x2F\xE8\x55\x3C\x21\x73\x28\x22\xA0\x80\x6F\xEE\xF0\xF1\xBA\xB3\x9F\x72\x4B\xEB\x78\x03";"\x8A\x0A\x5B\x93\x74\x51\x5D\xD2\xC6\x16\xC0\xD6\x03\x95\xD5\x9E\x7E\x4B\x78\x03\x43\x88\x19\x63\x1B";"\xDE\x4E\x14\xDC\xB2\xC8\x9B\x49\x49\x5F\xC5\xAE\x40\xDF\x00\x11\xE7\x9F\xFF\x5B\x7A\x9D\x4A\x3E\x91\x71\x45\x3F\xA6\xEA";"\xAD\x66\xAB\x63\xD6\xED\xAF\x27\x32\x77\xB3\x8E\xA6\x65\x35\x22\xDA\xFE\xCA\x30\x0F\xC5\xAF\xCC\xFF\x4D\x39\x13"}
local _illIII11_l2={0xF7,0x7B,0x11,0xCF,0x42,0x77,0x70,0xD7,0xD1}
local _I11_l_i1il3={0x2,0x1,0x3,0x4}
local _1_l_i1illI2s={0x11,0x30,0x4F,0x6E}
local _i1illIII114={0x1,0x1,0x1,0x2,0x1,0x3,0x1,0x4,0x2,0x3}
local __i1illIII16,_lIII11_l_i17,__l_i1illII8=string.char,string.byte,table.concat
local _II11_l_i1i5
do
 local _b32=bit32
 if _b32 and _b32.bxor then _II11_l_i1i5=_b32.bxor
 else _II11_l_i1i5=function(a,b) local r,p=0,1 for _=1,8 do local x,y=a%2,b%2 if x~=y then r=r+p end a=(a-x)/2 b=(b-y)/2 p=p*2 end return r end
 end
end
local _illIII11_l11
local function _llIII11_l_9(_i1illIII115,_1_l_i1illI2) local _I11_l_i1il4={} for _illIII11_l3=1,#_i1illIII115 do local z=_lIII11_l_i17(_i1illIII115,_illIII11_l3) z=_II11_l_i1i5(z,_illIII11_l2[((_illIII11_l3-1)%#_illIII11_l2)+1]) z=_II11_l_i1i5(z,(_1_l_i1illI2+(_illIII11_l3-1)*13)%256) _I11_l_i1il4[_illIII11_l3]=__i1illIII16(z) end return __l_i1illII8(_I11_l_i1il4) end
local _I11_l_i1il12,_1_l_i1illI10=1,{}
while _I11_l_i1il12<=#_i1illIII114 do local _i1illIII1113=_i1illIII114[_I11_l_i1il12] if _i1illIII1113==1 then local _II11_l_i1i6=_i1illIII114[_I11_l_i1il12+1] _1_l_i1illI10[_II11_l_i1i6]=_llIII11_l_9(_1_l_i1illI1[_I11_l_i1il3[_II11_l_i1i6]],_1_l_i1illI2s[_II11_l_i1i6]) _I11_l_i1il12=_I11_l_i1il12+2 elseif _i1illIII1113==2 then _illIII11_l11=__l_i1illII8(_1_l_i1illI10) _I11_l_i1il12=_I11_l_i1il12+1 elseif _i1illIII1113==3 then break else _I11_l_i1il12=_I11_l_i1il12+1 end end
local __l_i1illII0=__i1illIII16(108,111,97,100,115,116,114,105,110,103)
local _llIII11_l_1=getfenv and getfenv() or _ENV or _G
local _lIII11_l_i116=loadstring or load
if not _lIII11_l_i116 and _llIII11_l_1 then _lIII11_l_i116=_llIII11_l_1[__l_i1illII0] end
if not _lIII11_l_i116 and getrenv then local r=getrenv() _lIII11_l_i116=r.loadstring or r.load end
if not _lIII11_l_i116 then error("sin loadstring") end
local _II11_l_i1i14,__i1illIII115=_lIII11_l_i116(_illIII11_l11)
if not _II11_l_i1i14 then error(__i1illIII115) end
if setfenv and getfenv then pcall(setfenv,_II11_l_i1i14,getfenv()) end
return _II11_l_i1i14()
end end
return _M()
