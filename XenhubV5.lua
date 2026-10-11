-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"amirjuegatutu", "chicosguapos55"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

--[[ Stick Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\xC1\xF6\x58\x29\x15\xE9\x9E\x1B\xB8\x00\x6A\xF7\xE1\x3E\x27\x2C\xA8\x39\xF0";"\xDC\xAE\x15\x67\xC5\x2B\x4B\xD7\x6C\x40\x64\x98\xF7\x24\xAF\x88\x7B\xE1\x2E\xA7\x0D\x7C\xA8\x19\x0D\xEC\x6C\xA5\xD2\xA6";"\x09\x77\xC8\xD9\x07\xE6\x8F\x0A\xC0\xE6\x87\x06\x45\x92\x6B\x04\xBF\x73\xAF\x7E\xFC\x95\x28\xC7\xCA\x6E\xD0\x28";"\x69\x48\xED\x90\x67\xC2\xB5\xFC\x47\xA9";"\xBA\xC6\xFA\x81\x23\xC7\xBC\x68\x82\x2A\x4A\xC3\x55\x97\x06\x3A\x8D\x59\x97\x95\x55\x21\x11\xB1\xF2\x51\xC8\x03\x70\xCA\xAC\x97";"\xAB\xCD\x3A\x1E\xF6\x0B\x36\x3E\x8A\x70\x05\x95\x95\x5F\x98\xF0\xA0\x15\xD4\x96\x1F\x1F\xD3\x22\x20\xC4\x96\x43"}
local _illIII11_l2={0xA1,0xDF,0x5F,0x3B,0xF3,0xD,0x66,0xD2,0x7B}
local _I11_l_i1il3={0x2,0x6,0x1,0x5,0x3,0x4}
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
