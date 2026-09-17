--[[ Stick Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\xD2\x39\x2F\x6B\xEF\x8D\xF5\xDA\xB5\x0D\xFA\x8B\xC0\x54\x68\x6E\x41";"\x7B\x84\xC5\xEA\x5B\x57\x7E\xEF\x9D\xF9\x78\x55\x70\xEE\xB1\x87\x91\x04\x24\x98\xDE\x87\x1C\x69\x0D\x19\x1A\xD4";"\x52\xA1\xCD\xE0\x7B\x74\x3B\x6D\x7D\xD8\x32\x1F\x11\x88\xFB\xD4\xB5\xE3\xAB\xD2\xFE";"\x14\xE7\xE6\xCB\x44\xB5\x9D\xCF\xBF\x9B\x1B\x34\x5E\xCB\x52\x66\x7B\x29\x07\xF9\xA1\xE0\x3F\x48\xEB\xFC\xF9";"\xF7\x0D\x41\x77\xE2\xD1\xF2\x6B\x19\x47\xFC\xD8\xF5\x6C\x0D\x02\x10\x84\xA0\x25\x47\x06\x90";"\xC7\x14\xA3\xB5\x0A\x7C\x55\x20\x5A\x51\xCB\x93\x34\xC1\x9A\xD8\xD1\xAF\x87\x5E\x1F\x2B";"\xB9\x48\xE8\xD9\x20\x1D\x5D\x44\x46\x0C\xDA\x88\x23\xAC\xBB\xD8\xCF\x9E\xD0\x33\x3F\x5F\x27\x36\x68\x5C\x2E\x02";"\xBB\x2C\x45\x0F\xEB\xF5\xB6\x85\x95\xA1\xB1\xFF\xF1\x09\x00\x25\x5C\x6E\x29\x3C\x0E\x22\x94\x8C\xC5\xA6\xD2\xB4\x23\xEC";"\x35\xCC\x69\x45\xA5\x95\xD6\xC0\xDA\x85\x50\x7A\xBF\x29\x17\x29\x52\x4E\x0B\xB7\x80\xC2\xBA";"\x99\x67\x09\x3A\xC0\x36\x79\x27\x26\x63\xFA\xD5\xDA\x4B\x4B\x8E\xFE\xA5\xE8\x68";"\xFE\x7B\x60\x3E\xCE\xB9\xD3\x33\x52\x2F\x98\xBD\x99\x59\x63\x03\xF9\xD3\x81\x43\x08\x3D\xAD\xBB\xDE\x8C";"\x89\x78\x18\x50\x20\x3F\x29\x1C\x6E\x4E\xA8\xF5\x91\x1B\xE4\xAD\xEE\xF3\xB6\x21\x69\x52\xAF\x81\x2B\x3D"}
local _illIII11_l2={0xEE,0xA,0x5F,0x8,0x8A,0x8F,0xD8,0xD9,0xB8}
local _I11_l_i1il3={0x1,0xB,0xC,0x6,0x3,0x2,0x4,0x9,0x8,0x5,0xA,0x7}
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
