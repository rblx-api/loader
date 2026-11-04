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
local function __lpFailure(code,detail) local msg="[LuauProtect]["..code.."] "..tostring(detail or "") if type(warn)=="function" then warn(msg) elseif type(print)=="function" then print(msg) end return nil end _bsdata0={1823073902,"tu26l7cHIpxPgG9cwNKbibhmi_kSf0tRFZjA8RP1ghQo1L1",1397060190,2526410000,3697724496,"oIz_Dau1FD-OROwI1oP-T0vBUr89zQoHy6XW1OG_nLzhsbx",3232403139,2665012472,"5WHnifhsT6gfyWrTjchG-_YFxNI8VgAHTKcrtNFLXT27Uv",534252643} do local __e=(getgenv and getgenv()) or _G __e._bsdata0=_bsdata0 local __k=nil local __envs={} if type(getfenv)=="function" then for __level=0,2 do local __ok,__env=pcall(getfenv,__level) if __ok and type(__env)=="table" then __envs[#__envs+1]=__env end end end __envs[#__envs+1]=_G __envs[#__envs+1]=__e for _,__env in ipairs(__envs) do local __candidate=rawget(__env,"script_key") if type(__candidate)=="string" and #__candidate>0 then __k=__candidate break end end if __k then local __n=#__k local __a=math.ceil(__n/3) local __b=math.ceil(__n*2/3) __e._bskey0={4197013489,string.sub(__k,1,__a),726148468,90720337,3378952183,string.sub(__k,__a+1,__b),4203169806,720480032,string.sub(__k,__b+1),1002712346} end __k=nil __envs=nil __e=nil end do if type(loadstring) ~= "function" then return __lpFailure("EXECUTOR", "loadstring not available") end local __got, source = pcall(function() return game:HttpGet("https://luauprotect.win/v1_access_marbeg.lua/XysyCPn_RGNDRXy7SmED9FH9kUJ7SDkr8r_AimJukaIUvLjaFS9G3E-wjT9YlFrrppp5LHZ7rfNEH5g5pwqFemlipjh-rFFwCVjIHIskiNYaEbk95ZrkyqurEcikwU4ZFnkNiJJdhw") end) if not __got then return __lpFailure("HTTP", source) end if type(source) ~= "string" then return __lpFailure("HTTP", "Expected Luau text") end if string.sub(source,1,15):lower():find("<!doctype html",1,true) or string.sub(source,1,6):lower():find("<html",1,true) then return __lpFailure("HTTP_HTML","Server returned HTML instead of Luau") end if #source < 2000 then return __lpFailure("SHORT_RESPONSE", "Loader body is incomplete or server returned an error: "..string.sub(source,1,120)) end local __compiled, compiled = pcall(loadstring, source) source = nil if not __compiled then return __lpFailure("COMPILE",compiled) end if type(compiled) ~= "function" then return __lpFailure("COMPILE","loadstring returned no function") end local __ok,__out=pcall(compiled) if not __ok then return __lpFailure("ACCESS",__out) end return __out end
end)(...)