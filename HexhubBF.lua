-- ⏱ KEY CON EXPIRACIÓN
local keyExpiry = 1789742592840
local now = os.time() * 1000
if now > keyExpiry then
  pcall(function()
    game:GetService("Players").LocalPlayer:Kick("KEY EXPIRADA")
  end)
  return
end

-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"DxrUNtejlvhubHt"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

--[[ Stick Obfuscador v1.2 ]]
local _M
do _M=function()
local _1_l_i1illI1={"\xF2\x46\xE9\xBE\x73\x9B\x76\xCB\x61\x4F\xDB\x86\x2C\xE7\x25\xF7\x21\xEF\xC4\x75\x06\x5C\x70\xA9\x5D\xA1";"\xA4\x15\x2C\x7F\x90\x4C\xBC\x9D\x2A\x31\x87\xD5\xFF\x30";"\x1A\xB2\xCF\x9A\x35\xF3\x19\xFF\x47\x96\x3A\x75\x1A\xDA\x7F\x8E\x48\xC0\xFE\xB1\xFE";"\xDB\x6E\x1A\x58\x6A\xA8\x43\xBD\x19\x54\xF9\xB0\xC5\x10\x25\xD1\x09\x81\xB0\x76\x3C\x53\x84\x46\x46\x9E\x06\x3C";"\x14\xA7\xEC\x87\x51\xE6\x15\xF7\x5A\x76\x2B\x62";"\xD8\x75\x15\x43\xEE\x2A\xDF\x23\x89\x44\xBF\x8C\xC6\x10\xA2\x48\xA0\x5E\x3D\x64\x2B\x4F\xDF\x01\x8B\x48\xD1\xE4\x48";"\x42\xE8\x8D\xC1\x13\x37\xC7\x31\x9C\xD7\x65\x3C\x4F\x80\xBC\x4D\x88\x1A\x21\xF7\xA6\xEF\x00\xCA\xC0\x1A\xB7\xBA\x1F\x2A\x7F";"\x3D\x91\xA8\xFD\x0E\xCD\x39\x10\xBC\xA8\x1B\x55\x65\xA1\x5F\xAC\x6F\x3B\x06\x9F";"\xCE\x64\x09\x5D\x92\xB5\x53\xA8\x08\x2E\xE1\xB8\xCD\x11\xDD\xCC\x06\x96\xA5\x0A\x27\x6B\x88\x4E\xA1\x9B\x36\x3B\x9B";"\xE7\x4E\xE7\xB3\x56\x92\x7E\xDE\x64\x73\xCC\x8E\x22\xFD\x04\xF2\x29\xE3\xD1\x50\x1C\x56\x78\xA4\x65";"\x9D\x23\x4E\x03\xD4\x77\x93\x6E\xDB\xED\xA3\xF6\x8A\x52\x9F\x0F\xCE\x49\x7A\x35\x63\x3D\xD3\x01\x84\x44";"\xB4\x09\x31\x61\xB4\x5D\xA8\x94\x3E\x09\x82\xDC\xED\x25\xEB\x2E\xF2\xAA\x86\x29\x5F\x17\xAF\x6D";"\x7D\xDF\x6A\x3F\xF7\x0B\xFB\x52\xF9\xD6\x59\x17\xAF\x67\x98\x6A\xB0\x68\x40\xD0\x9D\xDD\xE9\x35\xE1\x38\x96\xC0\x63\x0C\x5A\x89"}
local _illIII11_l2={0xA5,0x4,0x5F,0x1F,0xD8,0xC,0xF2,0x26,0x9E}
local _I11_l_i1il3={0x6,0x2,0x4,0xA,0x3,0x8,0x7,0xD,0xB,0xC,0x9,0x1,0x5}
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
