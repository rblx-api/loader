-- ⏱ KEY CON EXPIRACIÓN
local keyExpiry = 40355659691388
local now = os.time() * 1000
if now > keyExpiry then
  pcall(function()
    game:GetService("Players").LocalPlayer:Kick("KEY EXPIRADA")
  end)
  return
end

-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"axelo1231234", "Dexterclearman"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

--[[ Nocturne Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\xA9\x88";"\xC4\xB6\x48\x1B\xA7\xFB\x4D\xDA\x48\x1C\x68\xA9\xD5\x8B\x33\xC2\x3C\xDF\xE6\xA9\x25\x5F\x49\x10\x57\xB1\x05\x72\x50\xFE\xA0\x8B";"\xF0\x90\x3B\x69\x54\x50\xA5\xB3\x27\x64\x1B\xDA\xE5\xF8\xC7\x22\x37\xAE\x97\xD3\x41\x6D\x7E\x27\xAE\x54\x33\x4F\x71\x8D\xDC";"\x92\xAB\x5E\x00\x76\x75\x99\x45\xD1\x0E\x61\xD3\x90\x97\xF1\x5A\xE9\x5C\x60\xA2\x46\x1B\x1B\x47\xDF\x7E\xD1\xEB\xD7\xED\xF1\xCB"}
local _illIII11_l2={0xEF,0xDA,0x14,0x5C,0x40,0x53,0xB4,0x40,0xC6}
local _I11_l_i1il3={0x4,0x3,0x2,0x1}
local _1_l_i1illI2s={0x11,0x30,0x4F,0x6E}
local _i1illIII114={0x1,0x1,0x1,0x2,0x1,0x3,0x1,0x4,0x2,0x3}
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
