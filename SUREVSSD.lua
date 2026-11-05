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
-- [Script interno 1] https://luauprotect.win/files/v1/loaders/fafc69c0141cdb734159ab873889599e27a95cd1
__ZYROX.s[1] = function(...)
local function __lpFailure(code,detail) local msg="[LuauProtect]["..code.."] "..tostring(detail or "") if type(warn)=="function" then warn(msg) elseif type(print)=="function" then print(msg) end return nil end _bsdata0={2911119948,"VZf-Kdzk9YUcvL1fZCTU_NSgmQZVYaY_Q48AiBH0R5S_fnr",2602354338,3133700684,2621153865,"3izzf1NqWT13FJiQoaFaE2PDnlYqZOrTd6yogI9Cuu9GCPT",2020905095,3348168063,"qMIHc9aFJG80iLm6p0fVni_JWVuowkuhdjKkQqVR_YqLZS",423397514} do local __e=(getgenv and getgenv()) or _G __e._bsdata0=_bsdata0 local __k=nil local __envs={} if type(getfenv)=="function" then for __level=0,2 do local __ok,__env=pcall(getfenv,__level) if __ok and type(__env)=="table" then __envs[#__envs+1]=__env end end end __envs[#__envs+1]=_G __envs[#__envs+1]=__e for _,__env in ipairs(__envs) do local __candidate=rawget(__env,"script_key") if type(__candidate)=="string" and #__candidate>0 then __k=__candidate break end end if __k then local __n=#__k local __a=math.ceil(__n/3) local __b=math.ceil(__n*2/3) __e._bskey0={837759324,string.sub(__k,1,__a),650937930,519910933,668621264,string.sub(__k,__a+1,__b),2043837772,2038399979,string.sub(__k,__b+1),853122432} end __k=nil __envs=nil __e=nil end do if type(loadstring) ~= "function" then return __lpFailure("EXECUTOR", "loadstring not available") end local __got, source = pcall(function() return game:HttpGet("https://luauprotect.win/v1_access_marbeg.lua/046zw0mc0DmqLj_9fDWviJGEjom_jlL9YFgeOPeI3svTmiKwoW7ZyNALszUp6T7bKiV2UQVeKN3MnLQrcCWJOB-HWK6JgstOmBNQoT1B4amaiuxwk56SlxOym-3DzABN0l9STL09rw") end) if not __got then return __lpFailure("HTTP", source) end if type(source) ~= "string" then return __lpFailure("HTTP", "Expected Luau text") end if string.sub(source,1,15):lower():find("<!doctype html",1,true) or string.sub(source,1,6):lower():find("<html",1,true) then return __lpFailure("HTTP_HTML","Server returned HTML instead of Luau") end if #source < 2000 then return __lpFailure("SHORT_RESPONSE", "Loader body is incomplete or server returned an error: "..string.sub(source,1,120)) end local __compiled, compiled = pcall(loadstring, source) source = nil if not __compiled then return __lpFailure("COMPILE",compiled) end if type(compiled) ~= "function" then return __lpFailure("COMPILE","loadstring returned no function") end local __ok,__out=pcall(compiled) if not __ok then return __lpFailure("ACCESS",__out) end return __out end
end
-- [Fin script interno 1]

-- [Script principal]
script_key = "8b5dc2f0f9e99b0006fbe011c06ad05944da68";
__ZYROX.s[1]()
end)(...)