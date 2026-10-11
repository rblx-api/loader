--[[ Stick Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\xAA\xEB\x77\xB4\xD8\xF9\xD2\x09\x5E\x20\x2F\x9A\x2C\x78\x78\x5A\xBF\xC6\x55";"\x19\x47\x03\xC8\xB8\xC5\xB2\x6D\x6F\x8A\xD6\x78\x59\x5D\x1F\x3F";"\x02\x5E\xEA\x00\x6B\x57\x37\x35\x26\x97\xD1\x2B\xC4\x8D\xC7\xF4\xA3\xA6\x29";"\x3B\x62\xAD\x6E\x4D\x28\x46\xD3\xDD\xA7\xA8\x20\xFE\xAC\xAC\x85\x7F\x50";"\xDA\x9F\x43\xD3\xFE\xD3\xA1\xB2\xBD\x01\x0D\xBD\x1E\x1B\x0E\x26\x83\x6A\xF8\x99";"\x79\x3D\xE1\x30\x9D\xFD\x82\x52\x0A\xEB\xAC\x16\xBF\xEA\x67\x1C\xBA\xC9\x09"}
local _illIII11_l2={0x46,0x13,0xE7,0x32,0x7B,0xE,0x6B,0xD6,0xCA}
local _I11_l_i1il3={0x4,0x3,0x6,0x2,0x1,0x5}
local _1_l_i1illI2s={0x11,0x30,0x4F,0x6E,0x8D,0xAC}
local _i1illIII114={0x1,0x1,0x1,0x2,0x1,0x3,0x1,0x4,0x1,0x5,0x1,0x6,0x2,0x3}
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
