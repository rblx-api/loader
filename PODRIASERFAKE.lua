--[[ Stick Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\x45\x39\x25\xC1\x59\x30\xA8\xD4\xF0\xC9\xAF\xD9\x5B\xED\xBE\x3C\xAE\x6C\x7F\x23\x53\xAF\x73\x0A\xB6\x22\x1A\xE3\x99\xC7\x21";"\xE0\x96\xC0\x22\x84\x97\x05\xAF\xCE\xD5\x5C\x6E\xA8\x15";"\x23\x59\x07\xE1\x47\xD0\x4A\xF4\xD6\xA9\xCD\xB9\x75\xCD\x5C\xDC\x48\x4C\x5D\x43\x2D\xCF";"\x9A\xA3\xBC\x1B\x9E\xEE\x6B\x1D\x71\x54\x2B\x19\x89\x20\x23\xF1\x8C\xAA\xAC\xE4\x82\x10\xB3\xD5\x7F\xF3\x3E\x3F";"\xA3\xC7\x9E\x78\xB8\xCD\x48\xE0\xC4\x3F\x0D\x13\xE8\x59\x49\x8B\x4C\x49\x51\xCE\x86\x63";"\xDE\xAA";"\x64\x1A\x44\xA6\x78\x13\x89\x3B\x11\xEA\x8E\xFE\x3A\x8E";"\xE5\x8F\xD3\x26\x23\x18\x97\x22\x4B\x68\x05\x66\xB7\x5B\x8F\x07\x93\xD0\x8B\x9F\xE6\x20\x86\xE3\xCD\x1C";"\xD1\xA4\x32\x9E\x7E\x01\x97\x64\x50\x7F\x07\x67\x7A\xD0\x87\x1D\x8F\xAE";"\x02\x76\xE6\x02\xA6\xF7\x6B\x97\xB7\xB6\xEC\x9A\x94\x2A\x7D\xFF\x69\x23\x3C\x60\x0C\xE8\xB0\xC9\x71"}
local _illIII11_l2={0xDE,0xB6,0xD4,0x24,0x8E,0xEB,0x65,0xE5,0xD3}
local _I11_l_i1il3={0x5,0x4,0x8,0x9,0x7,0x1,0x3,0xA,0x2,0x6}
local _1_l_i1illI2s={0x11,0x30,0x4F,0x6E,0x8D,0xAC,0xCB,0xEA,0x9,0x28}
local _i1illIII114={0x1,0x1,0x1,0x2,0x1,0x3,0x1,0x4,0x1,0x5,0x1,0x6,0x1,0x7,0x1,0x8,0x1,0x9,0x1,0xA,0x2,0x3}
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
