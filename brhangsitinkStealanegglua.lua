--[[ Stick Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\xE5\x79\x1D\xF2\xA4\x92\x3E\xAF\xB3\x03\x83\xE1\x69\x78\x71\xAE\xD0\x44";"\xAD\x52\xB2\x30\x5E\x3C\x91\xED\xF3\x14\xAC\xA2\xA7\xD0\xDF\x69\x12\x60\xF6\x4D\x30\xDD\x25\x07\xE7";"\x42\xAF\x9A\x73\x14\x21\xD8\x9A\x9C\x9D\x6C\x3E\xD8\xAF\xC4\x43\x01\x5F\xC9\xE1\x9E\x12\x19\x6A\xDD\xBD\x96\x2E";"\x84\x75\x3D\xBE\xBF\x1E\xDD\xE3\x93\x0F\xE4\xEC\x46\x34\x94\x27\x32\x0D\xFE\x02\x14\xFD\xAD\x89\xC6";"\x0D\x94\xBB\x47\x3D\xF7\x51\x0A\x07\x9E\x65\x08\xC4\xDD\xEF\xCF\xBE\xE9\x7E\x93\x93\x14\x25\x61\xB9\x49\x38\xED\x18\x76";"\x29\xDD\x5A\xC1\xDB\xB1\x73\x04\x6E\x95\x45\x43\x22\x4B\x0B\xFE\x86\xFB\x06\xE8\xA0\x02\x9B\xD6\x61\x12\x00\x93\x60\x1B";"\x67\x99\x99\x03\x1D\x7E\xB5\x46\x31\xDA\x01\x01\xE5\x91\xCF\x42\x50\xA5\x5E\xDF\xF6\x1D\x00\x2C\xA4\xC5";"\x5D\xAF\xE2\x02\x81\xC7\x1A\x5A\x48\xDD\x65\x53\x9A\xE4\x43\xDD\xCE\xC9\x33\xAA\xFE\x15\x68\x71";"\xD5\x27";"\x4F\xD6\xF8\x11\x7D\x35\x93\xCC\xD8\x5C\x27\x4B\x82\x9F\xAC\x00\x78\x2B\xBC\xAC\xDF\x56";"\x13\xFC\xAA\x4D\x3D\x72\xED\x67\x67\xB8\x5A\x3C\xB3\xC6\xE5\x2E\xB7\xB2\x4A\x92\xFE";"\x32\xBB\x53\xB5\xE7\xD0\x78\x61\x71\xC1\x5D\x26\x2C\x3A\x36\xF5\x95\x86\x17\xC8\xAD\x33\xCD\x8F\x6B\x76";"\xC3\x32\x7A\xF8\x80\xD9\x19\x2D\x55\x4D\xA1\xAA\x09\x7E"}
local _illIII11_l2={0x7E,0x9C,0xEA,0x10,0x71,0x23,0xF5,0x99,0x91}
local _I11_l_i1il3={0x3,0xB,0x8,0xC,0xD,0x1,0x4,0x2,0xA,0x7,0x5,0x6,0x9}
local _1_l_i1illI2s={0x11,0x30,0x4F,0x6E,0x8D,0xAC,0xCB,0xEA,0x9,0x28,0x47,0x66,0x85}
local _i1illIII114={0x1,0x1,0x1,0x2,0x1,0x3,0x1,0x4,0x1,0x5,0x1,0x6,0x1,0x7,0x1,0x8,0x1,0x9,0x1,0xA,0x1,0xB,0x1,0xC,0x1,0xD,0x2,0x3}
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
