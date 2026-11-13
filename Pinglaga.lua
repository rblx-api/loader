-- ZYROX GENERATOR: webhooks, loggers and outgoing HTTP requests blocked.
local __ZYROX = { s = {} }
do
  local Z = __ZYROX
  local dummy
  dummy = setmetatable({}, { __index = function() return dummy end, __call = function() return dummy end })
  Z.block = function() return { Success = false, StatusCode = 403, StatusMessage = "Blocked", Body = "{}", Headers = {}, Cookies = {} } end
  Z.post = function() return "{}" end
  Z.ws = function() return dummy end
  pcall(function() request = Z.block end)
  pcall(function() http_request = Z.block end)
  pcall(function() if syn then syn = setmetatable({ request = Z.block }, { __index = syn }) end end)
  pcall(function() if http then http = setmetatable({ request = Z.block }, { __index = http }) end end)
  pcall(function() if fluxus then fluxus = setmetatable({ request = Z.block }, { __index = fluxus }) end end)
  pcall(function() if WebSocket then WebSocket = setmetatable({ connect = Z.ws, Connect = Z.ws }, { __index = WebSocket }) end end)
end
-- [End protection]
return (function(...)
-- Do not save this file
-- Always use the loadstring 
  _bsdata0={2754300393,37400340,2660423,1670443284,1794579547,38296992,"\137\36\120\82\14\218\117\211\6\150\188\170\128\88\156\208\33\63\146\100\144",6853189,21797448,"59464d8065a51abf55d666a55135c47bf42a50782dfc9066c6f5ff189ce4da3be7cea869524a9918f0e85a206198f8fb087eec4ae27f445deae1c43be9c7a7fec43b5c","\156\38\118\93\192\163\95\133\230\132\162\148\13\179\252\124\91\40\12\0\197\125\134\49\53\197","8eb90556057087e586a737f40c3a09d893415ced94b0e69be2bfe78ff90096c59f27cfd87991ec34eb9baf780f7b6d59d6dcedd8d9a02e605c7a5a86008c1c17ca2d18369e05594ef242a02f5c23bda4be2a04d8a0eb029251bda58ba8c1882197e738242bf727094d84bb0ced297bfee2691a3fc47345f4c24f8f11243ae58ee287dbf978194c7d3e44f552b584114b6cd8d27ed0a6699c82d40910168d54d323f2439a8120e240a3c5487cff24c9ecbf8a7700fd4659c8b0326df0b9c7e5e07c8a8b777ef9f4ad5c5733224ea60f34d9932d6531"};
local f,b,a="static_content_170926","13a0bcaa0ba-nomid";pcall(function()a=readfile(f.."/init-"..b..".lua")end) if a and #a>2000 then a=loadstring(a) else a=nil; end;
if a then return a() else pcall(makefolder,f) a=game:HttpGet("https://cdn.luarmor.net/v4_init_novemide.lua"..(_ca920af6193 or "")) writefile(f.."/init-"..b..".lua", a); ldrupd8m=a; return loadstring(a)(b) end
  
end)(...)