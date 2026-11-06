--[[ Stick Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\x22\x64\x94\xDA\xC1\x7E\xEE\xC5\x34\xBE\xAE\x19\x4A\x20\xFA\x2D\x69\xB9\xD0\x6D\x8C\xC1\xAC\x4C";"\x66\x7B\x98\x83\x17\xBA\x3F\x1A\xBB\xFA\xA2\x34\x59\x3E\x38\xB2\xBD\x6A";"\x4D\x40\xE0\xA5\xE3\x5A\x87\x64\x94\x9B\xD7\x08\x64\x5C\xCB\x52\xA9\x5D\x6B\x56\x8F\xB1\x96";"\x53\x0B\x6F\x25\x62\x91\x19\x31\xC0\x8E\x84\x11\xE8\xD9\x1E\xDD\x8C\x09\x70\x52\x85";"\xFB\xA7\x50"}
local _illIII11_l2={0x5F,0x15,0xDE,0x86,0xF7,0x58,0xC3,0xC0,0x23}
local _I11_l_i1il3={0x1,0x3,0x2,0x4,0x5}
local _1_l_i1illI2s={0x11,0x30,0x4F,0x6E,0x8D}
local _i1illIII114={0x1,0x1,0x1,0x2,0x1,0x3,0x1,0x4,0x1,0x5,0x2,0x3}
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
