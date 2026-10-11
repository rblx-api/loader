--[[ Stick Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\x38\xE6\x50\x04\xD9\x0B\x8D\xED\xC0\xA6\x29\xB4\xD4\x43\xCA\x15\x5A\x55\x50\xF6";"\xF4\x10\xE8\xE6\x7A\x66\xB5\xC9\xF0\xE8\x87\x2D\x4A\xB6\xAF\x15\x48\x4D\x4C\x75\xF0\xA3\x5B\x60\x8C\x9E";"\x32\xAA\x31\x01\x8E\x16\xCB\x83\x80\x8F\x32\xA7\xF2\x68\x69\x5F\x00\x0E\x0D\x9B";"\xC1\x44\xE0\xEA\x48\x21\xEA\x09\x70\x5A\xC5\x06\x6A\xFB\xB8\x2C\xD0\xEB\xEB\x14\x9E\xE9\x62\x0A";"\xBE\x25\xC3\xC5\xAF\xC0\x09\x30\x5F\x3B\xA6\x22\x4D\xDA\x5B\xD7\xCF\xCA\xC8\x29\xF9\xC8\x41\x29\x13\x4A\x49\x17\xCC\x6C\x73\x82";"\x93\x14\xBE\xBB\x21\x2F\xEF\x5E\x3B\x3E\x96\x11\x2A\xB1\xC9\x34\x6F\xE1\xA2\x25\xC9\x92\x29";"\x14\x96\xBE\xA7\x23\x7A\xAC\x9B\xBA\xED\x0B\xC5\x36\xB0\xBF\x29\x2C\x3C\x64\x83\x5F\x1D\x60\x5D\xF0\xED\xD4\xE7\x2A\xE1\xAB";"\x72\xED\x42\x12\xB2\xB8\x01\x75\x5C\xB0\x36\xB4\xCB\x4D\x51\x85\xDB\xC9\xCB\xBF\x39\x68\x8D\xB0\x5A\x52\x70\x4B";"\xC0\x44\x64\x60\xF7\xF4\x20\x1F\x26\x6A\xDC\x4A\xB4\x38\x03\xA9\xA6\xBE\xE0\x3F\x80\xC6\xEB\x8E\x1B\x68\x47\x75";"\xAE\x24\xC0\xDD\x27\x0E\xB6\xA3\xD4\x30\xB2\x4F\x4C\xDA\xCD\x4A\x3A\x2E\x44\x32\xFE\xC7\x4D\x60\x9C\x99\xD2\x81\x49";"\x30\xFF\x71\x4C\x81\x8B\x5D\x27\x46\x1D\x6B\xAE\x97\x02\x6B\xDC\xC3\xCE\xDD\x4A\x64\x26\xCC\xA9\x6D\x0B";"\x0A\x9E\x20\x77\x9A\xF0\x2E\x99\xBB\xDC\x18\xDC\xA2\x38\x7F\xAD\xA6\x37\x6C\x93\x56\x5D\xCE\xC7\x3D\x60\x55\xB4";"\x9F\x02\x22\x7A\x8E\xFF\x28\x5E\x3E\x1C\x87\x5B\xAC\x35\x7A\xE4\xEE\xAD\xA9\x5F\xD8";"\xE4\x68\xC6\x9C\x44\xDB\x4F\x25\x04\x1C\xFF\x2C\x0E\x8E\xF5\xCF\xCA\x9E";"\x43\xD3\x1A\xEA\x30\x38\xE7\xA2\xE5\xBE\x79\x8D\x8E\xF5\xA3\x76\x34\x5D\x6A\xA5\x47\x5F\x27";"\x41\x81\x02\x79\xE0\xAC\x72\x3E\xA0\xFE\x15\x8D\xA6\x22\x44\xE7\xB5\x28\x3B\xAD\x43\x50\xEE\x9F"}
local _illIII11_l2={0xD3,0x55,0x88,0x84,0xE,0x7C,0xB6,0xF2,0xCA}
local _I11_l_i1il3={0xA,0x4,0x5,0xD,0x8,0xC,0x1,0x7,0x2,0x6,0xE,0x9,0xB,0x10,0x3,0xF}
local _1_l_i1illI2s={0x11,0x30,0x4F,0x6E,0x8D,0xAC,0xCB,0xEA,0x9,0x28,0x47,0x66,0x85,0xA4,0xC3,0xE2}
local _i1illIII114={0x1,0x1,0x1,0x2,0x1,0x3,0x1,0x4,0x1,0x5,0x1,0x6,0x1,0x7,0x1,0x8,0x1,0x9,0x1,0xA,0x1,0xB,0x1,0xC,0x1,0xD,0x1,0xE,0x1,0xF,0x1,0x10,0x2,0x3}
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
