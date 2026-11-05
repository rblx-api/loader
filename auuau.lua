local function luraph_runtime1(...) error("Luraph runtime function, not devirtualized") end

local ... = ...
local v = table.pack(...)

if not ce_like_loadstring_fn then
	if not l_fastload_enabled or not is_from_loader then
		game:GetService("Players").LocalPlayer:Kick("[Luarmor]: Use the loadstring, do not run this directly")
		wait(5)
		while true do
		end
	end
end

local str = "?"
loadstring = ce_like_loadstring_fn or loadstring
local flag = false

pcall(function()
	flag = true
	local UserGameSettings = UserSettings():GetService("UserGameSettings")
	if not UserGameSettings:GetTutorialState("nil  nil  ") then
		str = ""
		local n = ({ wait() })[1] * 1000000

		local function fn(arg)
			local n2 = 1103515245
			local n3 = 12345
			local n4 = 99999999
			local n5 = arg % 2147483648
			local n6 = 1
			return function(arg2, arg3)
				local v2 = n4
				local n7 = n2 * n5 + n3
				local n8 = n7 % v2 + n6
				n6 += 1
				n5 = n8
				n3 = n7 % 4858 * (v2 % 5782)
				return arg2 + n8 % arg3 - arg2 + 1
			end
		end
		local v2 = fn(n - n % 1)
		UserGameSettings:SetTutorialState("nil  nil  ", true)
		local n2 = 0
		for i = 1, 16 do
			local n3 = 0
			local n4 = 1
			for i2 = 1, 5 do
				local flag2 = v2(10, 20) > 15
				UserGameSettings:SetTutorialState("nil  nil  " .. n2, flag2)
				n3 += (flag2 and 1 or 0) * n4
				n4 *= 2
				n2 += 1
			end
			str ..= ("qwertyuiopasdfghjklzxcvbnm098765"):sub(n3 + 1, n3 + 1)
		end
	else
		str = ""
		local n = 0
		for i = 1, 16 do
			local n2 = 0
			local n3 = 1
			for i2 = 1, 5 do
				n2 += (UserGameSettings:GetTutorialState("nil  nil  " .. n) and 1 or 0) * n3
				n3 *= 2
				n += 1
			end
			str ..= ("qwertyuiopasdfghjklzxcvbnm098765"):sub(n2 + 1, n2 + 1)
		end
	end
end)

while not flag do
end

local now = os.clock()

if devsignature_sig then
	print([[        Luarmor - Lua whitelist service
        This is a signature - If you are seeing this, you know what not to do :3
        Have a good day!
        https://luarmor.net/
    ]])
end

local flag2 = nil
local flag3 = nil
local v2 = ({ table.unpack(v, 1, v.n) })[3]

if v2 and v2[1] then
end

local floor = math.floor
local random = math.random
local remove = table.remove
local char = string.char
local n = 0
local n2 = 2
local tbl = {}
local tbl2 = {}

for i = 1, 256 do tbl2[i] = i end

repeat
	local v3 = random(1, #tbl2)
	local v4 = remove(tbl2, v3)
	tbl[v4] = char(v4 - 1)
until #tbl2 == 0

local tbl3 = {}

local function fn()
	if #tbl3 == 0 then
		n = (n * 149 + 4033097371307) % 35184372088832
		repeat
			n2 = n2 * 37 % 257
		until n2 ~= 1
		local n3 = n2 % 32
		local n4 = floor(n / 2 ^ (13 - (n2 - n3) / 32)) % 4294967296 / 2 ^ n3
		local n5 = floor(n4 % 1 * 4294967296) + floor(n4)
		local n6 = n5 % 65536
		local n7 = (n5 - n6) / 65536
		local n8 = n6 % 256
		local n9 = n7 % 256
		tbl3 = { n8, (n6 - n8) / 256, n9, (n7 - n9) / 256 }
	end
	return table.remove(tbl3)
end

local tbl4 = {}
local v3 = tbl4

local function fn2(arg, arg2)
	local v4 = tbl4
	if not v4[arg2] then
		tbl3 = {}
		local v5 = tbl
		n = arg2 % 35184372088832
		n2 = arg2 % 255 + 2
		v4[arg2] = ""
		local n3 = 77
		for i = 1, #arg do
			n3 = (string.byte(arg, i) + fn() + n3) % 256
			v4[arg2] = v4[arg2] .. v5[n3 + 1]
		end
	end
	return arg2
end

local v4 = LUARMOR_SkipAntidebugDevMode
local LUARMOR_AllowKeyCheckSkip = LUARMOR_AllowKeyCheckSkip
local flag4 = ff97f23b97f93792992999 and ff97f23b97f93792992999() == "j" or false
local v6 = "eu1-roblox-auth.luarmor.net"
local USE_NON_SSL_NODE = USE_NON_SSL_NODE
local l_fastload_enabled = l_fastload_enabled
local n3 = os["time"](os["date"]("*t")) - os["time"](os["date"]("!*t"))
local n4

if n3 < 0 then
	n4 = (86400 + -(-n3 % 86400)) % 86400
else
	n4 = n3 % 86400
end

local n5 = n4 / 3600

if n5 >= 21 or n5 < 5 then
	local tbl5 = {}
	local v9 = "eu1-roblox-auth.luarmor.net"
	local v10 = "eu2-roblox-auth.luarmor.net"
	tbl5[1] = v9
	tbl5[2] = v10
	v6 = tbl5[math["random"](1, 2)]
elseif n5 >= 5 and n5 < 15 then
	local tbl5 = {}
	local v9 = "as1-roblox-auth.luarmor.net"
	local v10 = "as2-roblox-auth.luarmor.net"
	local v11 = "as3-roblox-auth.luarmor.net"
	local v12 = "as5-roblox-auth.luarmor.net"
	local v13 = "as6-roblox-auth.luarmor.net"
	local v14 = "as7-roblox-auth.luarmor.net"
	local v15 = "au1-roblox-auth.luarmor.net"
	local v16 = "au2-roblox-auth.luarmor.net"
	local v17 = "au3-roblox-auth.luarmor.net"
	local v18 = "au4-roblox-auth.luarmor.net"
	local v19 = "au5-roblox-auth.luarmor.net"
	tbl5[1] = v9
	tbl5[2] = v10
	tbl5[3] = v11
	tbl5[4] = v12
	tbl5[5] = v13
	tbl5[6] = v14
	tbl5[7] = v15
	tbl5[8] = v16
	tbl5[9] = v17
	tbl5[10] = v18
	tbl5[11] = v19
	v6 = tbl5[math["random"](1, 11)]
elseif n5 >= 15 and n5 < 21 then
	local tbl5 = {}
	local v9 = "us1-roblox-auth.luarmor.net"
	local v10 = "us2-roblox-auth.luarmor.net"
	local v11 = "ca1-roblox-auth.luarmor.net"
	tbl5[1] = v9
	tbl5[2] = v10
	tbl5[3] = v11
	v6 = tbl5[math["random"](1, 2)]
else
	game:GetService("Players")["LocalPlayer"]:Kick("invalid timezone - send this screenshot to developer and Federal")
end

pcall(function()
	if game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(game:GetService("Players")["LocalPlayer"]) == "AU" then
		local tbl5 = {}
		local v9 = "au1-roblox-auth.luarmor.net"
		local v10 = "au2-roblox-auth.luarmor.net"
		local v11 = "au3-roblox-auth.luarmor.net"
		local v12 = "au4-roblox-auth.luarmor.net"
		local v13 = "au5-roblox-auth.luarmor.net"
		tbl5[1] = v9
		tbl5[2] = v10
		tbl5[3] = v11
		tbl5[4] = v12
		tbl5[5] = v13
		v6 = tbl5[math["random"](1, 5)]
	end
end)

local tbl5 = { ["Version"] = "3.4" }
tbl5["Host"] = flag4 and LT_R_RRT_H or "https://" .. v6
tbl5["ScriptID"] = "228007939ebc976d2228d5cfc1391c69"
tbl5["ScriptVersion"] = "0141"
tbl5["Name"] = "Boris - Green Duels V2"

if USE_NON_SSL_NODE then
	tbl5["Host"] = "http://mc.felinemastery.xyz"
	v6 = "mc.felinemastery.xyz"
end

local flag5 = type(({ table.unpack(v, 1, v.n) })[1]) ~= "table"
local flag6 = false
local fn3 = nil
local n6 = nil
local tbl6 = nil
local tbl7 = nil
local flag7 = nil
local v9 = nil
local tbl8 = nil
local print = print
local next = next
local v12 = string["char"]
local identifyexecutor = identifyexecutor
local game = game
local pcall = pcall
local v16 = string["gmatch"]
local v17 = debug["traceback"]
local tonumber = tonumber
local setmetatable = setmetatable
local rawget = rawget
local wait = wait
local v22 = debug["getinfo"]
local loadstring = loadstring
local v24 = os["time"]
local v25 = string["byte"]
local v26 = string["sub"]
local spawn = spawn
local v28 = game:GetService("RunService")["Heartbeat"]
local v29 = os["clock"]
local rconsoleprint = rconsoleprint
local v31 = math["huge"]
local tostring = tostring
local pairs = pairs
local v34 = string["find"]
local getgenv = getgenv
local flag8 = false

local function fn4(arg, arg2)
	loadstring("local t,r = ...\nspawn(function() while wait() do pcall(function() game:GetService(\"CoreGui\").RobloxPromptGui.promptOverlay.ErrorPrompt.TitleFrame.ErrorTitle.Text = t\ngame:GetService(\"CoreGui\").RobloxPromptGui.promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text = r end) end end)\ngame:GetService('Players').LocalPlayer:Kick(r)\n        ")(arg, arg2)
	while wait() do
	end
end

local tbl9 = {}
local flag9 = false
local v36 = string["format"]
local v37 = string["sub"]
local v38 = table["concat"]
local type = type
local v40 = pairs
local v41 = wait
local v42 = coroutine["wrap"]

local fn5 = syn and (syn["websocket"] and syn["websocket"]["connect"]) or WebSocket and WebSocket["connect"] or WebsocketClient and function(arg)
	local v43 = WebsocketClient["new"](arg)
	v43:Connect()
	return v43
end

local fn6 = nil

fn6 = function(arg)
	local tbl10 = {}
	for k, v43 in v40(arg) do
		local n7 = #tbl10 + 1
		local v44 = "\"%s\":%s,"
		local v45 = v3
		local flag10 = type(v43) == "table" and fn6(v43)
		if not flag10 then
			local v46 = v3
			flag10 = "\"" .. v43 .. "\""
		end
		tbl10[n7] = v36(v44, k, flag10)
	end
	return "{" .. v37(v38(tbl10), 0, -2) .. "}"
end

local function fn7(arg)
	local function fn8(arg2)
		if arg2 == "PONG" then
			if flag8 then
				local v43 = v3
				rconsoleprint("[" .. os["clock"]() .. "] [PONG] Server ---> Client \n")
			end
			arg["LastPong"] = tick()
			return
		end
		local v43 = v3
		local v44 = string["match"](arg2, "|__(%d+)__|")
		if flag8 then
			local v45 = v3
			rconsoleprint("[" .. os["clock"]() .. "] [RESPONSE] Server ---> Client: " .. arg2 .. "\n")
		end
		if v44 then
			local v45 = arg["Requests"][v44 + 0]
			local v46 = v3
			v45:Fire(arg2:gsub("|__(%d+)__|", ""))
			return v45:Destroy()
		end
		return arg["OnMessageSignal"]:Fire(arg2)
	end
	local fn9 = nil

	fn9 = function()
		if flag8 then
			local v43 = v3
			rconsoleprint("[" .. os["clock"]() .. "] [CLOSED] ")
		end
		arg["__OBJECT_ACTIVE"] = false
		if arg["SocketClosed"] or flag9 then
			if flag8 then rconsoleprint(" (ALREADY CLOSED)\n") end
			return
		end
		local n7 = 0
		local v43
		while true do
			if flag8 then
				local v44 = v3
				rconsoleprint("[" .. os["clock"]() .. "] Attempting to reconnect to wshttpemu\n")
			end
			local v44 = v24()
			local flag10 = false
			local v45 = nil
			v43 = nil
			spawn(function()
				local v46, v47 = pcall(fn5, arg["Url"])
				v45 = v46
				v43 = v47
				flag10 = true
			end)
			while not flag10 and v24() < v44 + 8 do v41() end
			if flag8 then
				local v46 = v3
				rconsoleprint("[" .. os["clock"]() .. "] ######## L_PASS: d: " .. tostring(flag10) .. ", ok: " .. tostring(v45) .. "\n")
			end
			if not flag10 then
				flag6 = false
				n7 = 10
				if flag8 then warn("[2] Unable to connect (timeout)") end
			end
			if not v45 then
				n7 += 1
				if n7 > 5 then flag6 = false end
				v41(n7 < 4 and 10 or 120)
				continue
			end
			break
		end
		if flag8 then
			local v44 = v3
			rconsoleprint("[" .. os["clock"]() .. "] [CONNECT] Reconnected\n")
		end
		arg["__OBJECT_ACTIVE"] = true
		arg["Websocket"] = v43
		flag6 = arg
		local v44 = v3
		v43:Send(fn6({
			["Opcode"] = "PING",
			["Data"] = {},
		}))
		pcall(function()
			v43["OnClose"]:Connect(fn9)
			v43["OnMessage"]:Connect(fn8)
		end)
		pcall(function()
			v43["ConnectionClosed"]:Connect(fn9)
			v43["DataReceived"]:Connect(fn8)
		end)
	end
	pcall(function()
		local v43 = v3
		arg["Websocket"]["OnClose"]:Connect(fn9)
		local v44 = v3
		arg["Websocket"]["OnMessage"]:Connect(fn8)
	end)
	pcall(function()
		local v43 = v3
		arg["Websocket"]["DataReceived"]:Connect(fn8)
		local v44 = v3
		arg["Websocket"]["ConnectionClosed"]:Connect(fn9)
	end)
	arg["LastPong"] = tick()
	while v41(10) do
		if flag8 then
			local v43 = v3
			rconsoleprint("[" .. os["clock"]() .. "] [PING] Client ---> Server\n")
		end
		if arg["__OBJECT_ACTIVE"] then
			local v43 = v3
			arg["Websocket"]:Send(fn6({
				["Opcode"] = "PING",
				["Data"] = {},
			}))
			if tick() - arg["LastPong"] > 20 then
				if flag8 then
					local v44 = v3
					rconsoleprint("[" .. os["clock"]() .. "] [WARN] Server timeout\n")
					warn("Server timeout")
				end
				arg["Websocket"]:Close()
			end
		end
	end
end

tbl9.new = function(arg, arg2)
	local tbl10 = {}
	setmetatable(tbl10, arg)
	arg["__index"] = arg
	local v43 = v24()
	local flag10 = false
	local v44 = nil
	local v45 = nil
	spawn(function()
		local v46, v47 = pcall(fn5, arg2)
		v44 = v46
		v45 = v47
		flag10 = true
	end)
	while not flag10 and v24() < v43 + 8 do v41() end
	if not flag10 then
		flag6 = false
		error("Unable to connect to WS")
	end
	assert(v44, v45)
	arg["Websocket"] = v45
	arg["Url"] = arg2
	local v46 = v3
	arg["OnMessageSignal"] = Instance["new"]("BindableEvent")
	local v47 = v3
	arg["OnMessage"] = arg["OnMessageSignal"]["Event"]
	arg["Requests"] = {}
	arg["__OBJECT_ACTIVE"] = true
	v42(fn7)(arg)
	repeat
		v28:Wait()
	until arg["LastPong"]
	return tbl10
end

tbl9.request = function(arg, arg2)
	if flag8 then
		local v43 = v3
		rconsoleprint("[" .. os["clock"]() .. "] [REQUEST] Client ---> Server, ObjectActive: " .. tostring(arg["__OBJECT_ACTIVE"]) .. "\n")
	end
	local n7 = 0
	while not arg["__OBJECT_ACTIVE"] do
		n7 += 1
		v41(0.1)
		if not (n7 > 40) then continue end
		if flag8 then warn("[3] r_timeout") end
		flag6 = false
		return ""
	end
	if flag8 then
		local v43 = v3
		rconsoleprint("[" .. os["clock"]() .. "] [REQUEST] [!!!] OBJECT ACTIVE PASSED\n")
	end
	local v43 = math["random"](1, 99999999)
	local v44 = v3
	local v45 = Instance["new"]("BindableEvent")
	if flag8 then
		local v46 = v3
		rconsoleprint("[" .. os["clock"]() .. "] Event assigned\n")
	end
	arg["Requests"][v43] = v45
	local v46 = v3
	arg["Websocket"]:Send(fn6({
		["Opcode"] = "REQUEST",
		["Data"] = arg2,
		["Id"] = v43,
	}))
	if flag8 then
		local v47 = v3
		rconsoleprint("[" .. os["clock"]() .. "] Packet sent!\n")
	end
	local flag10 = false
	spawn(function()
		v41(30)
		if not flag10 then
			if flag8 then
				local v47 = v3
				rconsoleprint("[" .. os["clock"]() .. "] !!!!!! ALERT !!!!!!!!! REQ TIMEOUT !!!!!!!!\n")
			end
			local v47 = arg["Requests"][v43]
			v47:Fire("")
			if flag8 then
				local v48 = v3
				rconsoleprint("[" .. os["clock"]() .. "] Responded with something empty\n")
			end
			return v47:Destroy()
		end
	end)
	local v47 = v45["Event"]
	flag10 = true
	return (v47:Wait())
end

tbl9.close = function(arg)
	arg["SocketClosed"] = true
	arg["Websocket"]:Close()
end

local v43 = script_key or "none"
local n7 = 0
local flag10 = false

spawn(function()
	flag10 = true
	while not flag7 do
		n7 += 1
		v28:Wait()
	end
end)

while not flag10 do v28:Wait() end

local function fn8()
	local v44 = n7
	while n7 == v44 do v28:Wait() end
end

local function fn9(arg)
	if arg then error("devirt: for loop without back edge") end
	while wait() do
	end
end

local function fn10(arg)
	for i = 1, 2 do
		local n8 = arg % 9915 + 4
		local n9 = nil
		local n10 = nil
		for i2 = 1, 3 do
			n9 = arg % 4155 + 3
			if i2 % 2 == 1 then n9 += 522 end
			n10 = arg % 9996 + 1
			if n10 % 2 ~= 1 then n10 *= 3 end
		end
		local n11 = arg % 9999995 + 1 + 4948
		local n12 = arg % 1000
		local n13 = fn3((arg - n12) / 1000) % 1000
		local n14 = arg % (n8 * n9 + 9999) + 4948
		arg = (n12 * n13 + n11 + arg % (419824125 - n11 + n12) + (n14 + (n12 * n9 + n13)) % 999999 * (n11 + n14 % n10)) % 99999999999
	end
	return arg
end

local n8 = 1
local v44 = syn and syn["request"] or request or http_request

if identifyexecutor and ({ identifyexecutor() })[1] == "Krampus" then
	n8 = 9
elseif identifyexecutor and ({ identifyexecutor() })[1] == "ScriptWare" then
	if ({ identifyexecutor() })[2] == "Mac" then
		n8 = 5
	else
		n8 = 2
	end
elseif FLUXUS_LOADED or EVON_LOADED or WRD_LOADED or COMET_LOADED or OZONE_LOADED or TRIGON_LOADED then
	n8 = 4
elseif KRNL_LOADED then
	n8 = 3
elseif Electron_Loaded then
	n8 = 6
elseif identifyexecutor and ({ identifyexecutor() })[1] == "Sirhurt" then
	n8 = 7
elseif identifyexecutor and ({ identifyexecutor() })[1] == "Solara" then
	n8 = 11
elseif identifyexecutor and ({ identifyexecutor() })[1] == "incognito" then
	n8 = 11
elseif identifyexecutor and ({ identifyexecutor() })[1] == "NX" then
	n8 = 11
elseif identifyexecutor and ({ identifyexecutor() })[1] == "Xeno" then
	n8 = 11
elseif identifyexecutor and ({ identifyexecutor() })[1] == "Nezur" then
	n8 = 11
elseif identifyexecutor and ({ identifyexecutor() })[1] == "Rebel" then
	n8 = 15
end

if identifyexecutor() == "Wind" then n8 = 11 end

local function fn11(arg, arg2)
	tbl7 = {}
	tbl6 = {}
	for i = 0, arg do
		local v45 = v12(i)
		tbl6[i] = v45
		tbl6[v45] = i
	end
	for i = 1, #arg2 do
		local v45 = arg2[i]
		tbl7[i - 1] = v45
		tbl7[v45] = i - 1
	end
end

local tbl10 = {}
local v45 = "a"
local v46 = "b"
local v47 = "Q"
local v48 = "k"
local v49 = "O"
local v50 = "I"
local v51 = "1"
local v52 = "l"
local v53 = "0"
local v54 = "9"
local v55 = "E"
local v56 = "3"
local v57 = "J"
local v58 = "7"
local v59 = "G"
local v60 = "T"
tbl10[1] = v45
tbl10[2] = v46
tbl10[3] = v47
tbl10[4] = v48
tbl10[5] = v49
tbl10[6] = v50
tbl10[7] = v51
tbl10[8] = v52
tbl10[9] = v53
tbl10[10] = v54
tbl10[11] = v55
tbl10[12] = v56
tbl10[13] = v57
tbl10[14] = v58
tbl10[15] = v59
tbl10[16] = v60
fn11(255, tbl10)

fn3 = function(arg) return arg - arg % 1 end

local function fn12(arg)
	local n9 = 1103515245
	local n10 = 12345
	local n11 = 99999999
	local n12 = arg % 2147483648
	local n13 = 1
	return function(arg2, arg3)
		local v61 = n11
		local n14 = n9 * n12 + n10
		local n15 = n14 % v61 + n13
		n13 += 1
		n12 = n15
		n10 = n14 % 4859 * (v61 % 5781)
		return arg2 + n15 % arg3 - arg2 + 1
	end
end

local function fn13(arg)
	for i = 1, 2 do
		local n9 = arg % 9915 + 4
		local n10 = nil
		local n11 = nil
		for i2 = 1, 3 do
			n10 = arg % 4155 + 3
			if i2 % 2 == 1 then n10 += 522 end
			n11 = arg % 9996 + 1
			if n11 % 2 ~= 1 then n11 *= 3 end
		end
		local n12 = arg % 9999995 + 1 + 4948
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 4948
		arg = (n13 * n14 + n12 + arg % (419824125 - n12 + n13) + (n15 + (n13 * n10 + n14)) % 999999 * (n12 + n15 % n11)) % 99999999999
	end
	return arg
end

local function fn14()
end

local function fn15(arg)
	local tbl11 = {}
	local tbl12 = {}
	local tbl13 = {}
	for i = 1, 13 do
		local tbl14 = {}
		local tbl15 = {}
		tbl11[tbl14] = tbl15
		tbl12[tbl15] = i
		tbl13[tbl14] = tbl15
	end
	if arg then
		tbl12 = arg[2]
		tbl13 = arg[3]
		tbl11 = arg[1]
	end
	local n9 = 0
	local n10 = 0
	local n11 = 0
	for k, v61 in next, tbl11, nil do
		local v62 = tbl12[v61]
		if tbl13[k] == v61 then n9 += 1 end
		n10 += 1
		n11 = n10 % 2 == 0 and n11 * v62 or n11 + v62 + n10
	end
	if n9 ~= 13 then n6 = -1 end
	tbl8 = { tbl11, tbl12, tbl13 }
	n6 = n11
	return false
end

local function fn16(arg)
	for i = 1, 2 do
		local n9 = arg % 9915 + 4
		local n10 = nil
		local n11 = nil
		for i2 = 1, 3 do
			n10 = arg % 4155 + 3
			if i2 % 2 == 1 then n10 += 522 end
			n11 = arg % 9996 + 1
			if n11 % 2 ~= 1 then n11 *= 3 end
		end
		local n12 = arg % 9999995 + 1 + 4948
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 4948
		arg = (n13 * n14 + n12 + arg % (419824125 - n12 + n13) + (n15 + (n13 * n10 + n14)) % 999999 * (n12 + n15 % n11)) % 99999999999
	end
	return arg
end

local function fn17(arg)
	for i = 1, 2 do
		local n9 = arg % 9915 + 4
		local n10 = nil
		local n11 = nil
		for i2 = 1, 3 do
			n10 = arg % 4155 + 3
			if i2 % 2 == 1 then n10 += 522 end
			n11 = arg % 9996 + 1
			if n11 % 2 ~= 1 then n11 *= 3 end
		end
		local n12 = arg % 9999995 + 1 + 4948
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 4948
		arg = (n13 * n14 + n12 + arg % (419824125 - n12 + n13) + (n15 + (n13 * n10 + n14)) % 999999 * (n12 + n15 % n11)) % 99999999999
	end
	return arg
end

local function fn18(arg)
	local n9 = 1103515245
	local n10 = 12345
	local n11 = 99999999
	local n12 = arg % 2147483648
	local n13 = 1
	return function(arg2, arg3)
		local v61 = n11
		local n14 = n9 * n12 + n10
		local n15 = n14 % v61 + n13
		n13 += 1
		n12 = n15
		n10 = n14 % 4859 * (v61 % 5781)
		return arg2 + n15 % arg3 - arg2 + 1
	end
end

local n9 = 68
fn14(67, "%", " - Loading Luarmor client...")
n6 = -1
fn15()

while n6 == -1 do
end

local v61 = fn18(n7 + n6)

if n8 == 9 or n8 == 15 then
	local n10 = 0
	pcall(function()
		local function fn19(arg) tostring(arg[1]) end
		fn19(setmetatable({}, { ["__index"] = function()
			local fn20 = nil
			fn20 = function()
				n10 += 1
				return fn20()
			end
			fn20()
		end }))
	end)
	local n11 = 0
	pcall(function()
		v44(setmetatable({}, { ["__index"] = function()
			local fn19 = nil
			fn19 = function()
				n11 += 1
				return fn19()
			end
			fn19()
		end }))
	end)
	if n11 + n10 < 20000 then
		n9 = 19
	elseif n11 - n10 ~= 0 then
		n9 = 189
	end
end

local function fn19(arg, arg2, arg3)
	local v62 = v3
	local tbl11 = { ["Method"] = "GET" }
	if arg2 then
		tbl11 = setmetatable(tbl11, { ["__index"] = function(arg4, arg5)
			if arg5 == "Url" then
				local v63 = v3
				local v64 = v16(v17(), "[^:]*:(%d+)")
				local v65 = v64()
				local v66 = v64()
				local n10 = 1
				pcall(function()
					n10 = tonumber(v66) - tonumber(v65)
				end)
				if (n8 == 9 or n8 == 15) and (n10 ~= 0 or v65 ~= v66) then
					n9 = 121
					while arg3 do
					end
				end
				return arg
			end
			return rawget(tbl11, arg5)
		end })
	else
		tbl11["Url"] = arg
	end
	local v63 = v44(tbl11)
	if v63["StatusCode"] == 0 then
		if flag8 then
			warn("[CRITICAL] received StatusCode = 0; most likely an executor problem. Re-execute the script")
		end
		local v64 = v3
		writefile("luarmor-err-code0.txt", "[CRITICAL] received StatusCode = 0; most likely an executor problem. Re-execute the script")
	end
	return v63["Body"], v63["Headers"]
end

fn8()

local function fn20(arg)
	if getgenv()[8753563] == 22044 and n8 ~= 11 then
		if flag8 then
			warn("Cannot load Luarmor client (0x561c) task collision detected.. \nYou are trying to execute 2 Luarmor scripts very frequently. Please wait 2-3 seconds after first one loads, then execute the other script.")
		end
		spawn(function()
			wait(5)
			getgenv()[8753563] = nil
		end)
		fn9()
	end
	getgenv()[8753563] = 22044
	local flag11 = false
	local tbl11 = { v22, setmetatable, tostring }
	tbl11[-1] = n8 == 3 and function()
	end or v44
	local v62 = v26
	local v63 = v25
	local v64 = v24
	local v65 = loadstring
	local v66 = pcall
	tbl11[4] = v12
	tbl11[5] = v62
	tbl11[6] = v63
	tbl11[7] = v64
	tbl11[8] = v65
	tbl11[9] = v66

	local function fn21()
		flag11 = true
		return " ":rep(16777215)
	end
	local v67 = setmetatable({}, { ["__tostring"] = function()
		flag11 = true
		return " ":rep(16777215)
	end })
	for k, v68 in next, tbl11, nil do
		if k ~= -1 then
			local flag12 = n8 ~= 11
			if flag12 then
				local v69 = v3
				flag12 = v22(v68)["what"] == "Lua"
			end
			if flag12 then flag11 = true end
		end
		if v68 ~= print and v68 ~= tostring then
			local v69 = print
			local v70 = tostring
			local error = error
			local env = getfenv()
			env["tostring"] = fn21
			env["error"] = fn21
			env["print"] = fn21
			if k == -1 then
				if n8 ~= 5 then pcall(v68, "") end
			else
				pcall(v68, v67)
			end
			env["tostring"] = v70
			env["print"] = v69
			env["error"] = error
		end
	end
	if flag11 and n8 ~= 11 then
		n9 = 85
		if arg then fn9(true) end
	end
	getgenv()[8753563] = nil
end

local v62 = n7
local v63 = nil
local flag11 = nil

while true do
	local v64 = pcall(function()
		local v64 = fn19
		local v65 = v3
		v63 = v64(tbl5["Host"] .. "/status", n8 == 9 or n8 == 15)
		local data = game:GetService("HttpService"):JSONDecode(v63)
		if not data["active"] then
			warn(data["message"])
			fn9()
		end
		if not data["versions"][tbl5["Version"]] then
			warn("This script is outdated! Try using the latest version.")
			fn9()
		end
		tbl5["Host"] = flag4 and LT_R_RRT_H or USE_NON_SSL_NODE and "http://mc.felinemastery.xyz" or "https://" .. v6
		local v66 = tbl5
		local v67 = v3
		v9 = data["versions"][v66["Version"]]
	end)
	fn8()
	if not v64 then
		if flag11 then break end
		fn14(69, "%", " - Trying failover EU host..")
		v6 = "eu1-roblox-auth.luarmor.net"
		tbl5["Host"] = flag4 and LT_R_RRT_H or "https://eu1-roblox-auth.luarmor.net"
		flag11 = true
	end
	if not v64 then continue end

	local function fn21(arg)
		local n10 = 1103515245
		local n11 = 12345
		local n12 = 99999999
		local n13 = arg % 2147483648
		local n14 = 1
		return function(arg2, arg3)
			local v65 = n12
			local n15 = n10 * n13 + n11
			local n16 = n15 % v65 + n14
			n14 += 1
			n13 = n16
			n11 = n15 % 4859 * (v65 % 5781)
			return arg2 + n16 % arg3 - arg2 + 1
		end
	end
	local flag12 = false
	spawn(function()
		if not pcall(function()
			local v65 = tbl9
			local new = v65.new
			local v66 = flag4 and LT_R_RRT_W
			local str2
			if v66 then
				str2 = v66
			else
				str2 = USE_NON_SSL_NODE
				if USE_NON_SSL_NODE then
					local v67 = v6
					local v68 = v3
					str2 = "ws://" .. v67 .. ":80/wshttpemu"
				end
			end
			if not str2 then
				local v67 = v6
				local v68 = v3
				str2 = "wss://" .. v67 .. ":443/wshttpemu"
			end
			flag6 = new(v65, str2)
		end) then
			local v65 = v3
			fn14(75, "%", " - Failed to connect to WS, falling back to HTTP.")
			flag6 = false
		end
		flag12 = true
	end)
	local n10 = n7 % 8585 * (v62 % 9910)
	fn20()
	if flag5 then n9 = 146 end
	fn14(85, "%", " - Connecting to server..")
	local v65 = fn21(n10 + v61(2, 4096))
	local v66 = v61(1111, 32768)
	local n11 = 12000 + ((1398563873 * ((1398563873 * ((1361 + n10 + n6 % 1000 + n6) % 1610612736) + 22491) % 95716599 + 1) + 22491) % 95716599 + 1) % 120000 - 12000 + 1
	local tbl11 = { n11 + v65(100000, 1000000), v66, n11 + v61(3333, 15625) + n7, (v65(10000, 1000000)) }
	n6 = -1
	fn15()
	local flag13 = false
	if n6 == -1 then
		n6 = 100
		flag13 = true
	end
	local n12 = 0
	local n13 = 0
	local n14 = 0
	local n15 = 1
	local tbl12 = { [0] = 0 }

	local function fn22(arg, arg2, arg3)
		local n16 = arg2 and arg or tbl6[arg]
		if not arg3 then
			n16 = (n16 + 4096 - tbl12[n12]) % 256
			n14 += n16
			n12 = (n12 + 1) % n15
		end
		local n17 = n16 % 16
		return tbl7[(n16 - n17) / 16] .. tbl7[n17]
	end

	local function fn23(arg)
		local n16 = 0
		for i = 1, #arg do n16 += v25(arg, i) end
		return n16
	end

	local function fn24(arg, arg2)
		local v67 = tbl7
		local n16 = (tbl7[v26(arg, 1, 1)] * 16 + v67[v26(arg, 2, 2)] + tbl12[n13]) % 256
		n13 = (n13 + 1) % n15
		if arg2 then return n16 end
		return tbl6[n16]
	end

	local function fn25(arg)
		local tbl13 = {}
		n13 = 0
		local n16 = 1
		while true do
			local v67 = fn24(v26(arg, n16, n16 + 1), true)
			n16 += 2
			local v68 = ""
			for i = 1, v67 do
				v68 ..= fn24(v26(arg, n16, n16 + 1))
				n16 += 2
			end
			tbl13[#tbl13 + 1] = v68
			if not (n16 > #arg) then continue end
			break
		end
		return tbl13
	end

	local function fn26(arg, arg2)
		local v67 = fn22(#arg, true, arg2)
		for i = 1, #arg do v67 ..= fn22(v26(arg, i, i), false, arg2) end
		return v67
	end

	local function fn27(arg, arg2, arg3)
		if arg == 1 then
			tbl12 = arg2
			n15 = arg3
		elseif arg == 2 then
			n12 = 0
			n14 = 0
		elseif arg == 3 then
			return n14
		end
	end
	local v67 = fn18(v61(2, 32768 + v24() % 2000) + n6 % 4096)
	local v68 = fn12(v65(1, 32768) + n7 + v24() % 1000)
	local v69 = v67(111111, 999999)
	local tbl13 = {}
	for i = 1, v69 % 30 + 1 do
		local fn28
		if i == 2 then
			fn28 = tostring
		elseif i == 8 then
			fn28 = print
		elseif i == 17 then
			fn28 = v26
		else
			fn28 = function()
			end
		end
		tbl13[i] = fn28
	end
	local n16 = v68(111111, 999999) + 7481
	local n17 = v67(1, 1234) * v68(2, 1235) + n6 % 80000
	local n18 = 10000 + ((1445613873 * ((1445613873 * ((n11 + n6) % 1627389952) + 23515) % 94716599 + 1) + 23515) % 94716599 + 1) % 100000 - 10000 + 1
	local tbl14 = { n18 + v67(100000, 1000000), n18 + v68(100000, 1000000), (v67(100000, 1000000)) }
	v4 = v4 or LUARMOR_AllowKeyCheckSkip
	if v4 then n9 = 218 end
	if flag13 then n9 = 250 end
	local v70 = tbl14[1]
	local n19 = 6235 + tbl11[4]
	local n20 = tbl11[2] + 7481
	local n21 = 5516 + tbl11[1]
	local str2 = ((((((fn26("" .. n16) .. fn26("" .. fn16(5516 + v69) .. fn13(n9 + n17) .. fn10(n16 - 7481))) .. fn26(n17 .. "") .. fn26("" .. v69)) .. fn26(tbl11[3] + 11948 .. "")) .. fn26("" .. v70) .. fn26("" .. n19)) .. fn26(tbl14[3] .. "") .. fn26("" .. n20)) .. fn26(tbl14[2] .. "") .. fn26("" .. n21)) .. fn26(str or "?")
	local str3 = fn26(fn17(fn27(3) + 6105) .. "", true) .. str2
	local tbl15 = {}
	local v71 = v68(111111, 999999)
	local v72 = n6
	getfenv()[tbl15] = v71
	local v73, v74 = fn19(tbl5["Host"] .. "/" .. v9 .. "/auth/" .. tbl5["ScriptID"] .. "/init?t=" .. str3 .. "&v=" .. tbl5["ScriptVersion"] .. "&k=" .. v43, n8 == 9 or n8 == 15)
	n6 = -1
	fn15(tbl8)
	while n6 == -1 do
	end
	while tbl11[2] ~= v66 do
	end
	local v75, v76, v77 = pairs(tbl13)
	local n22 = 0
	for k, v78 in v75, v76, v77 do
		if k == 2 and v78 ~= tostring then n9 = 147 end
		if k == 8 and v78 ~= print then n9 = 147 end
		if k == 17 and v78 ~= v26 then n9 = 147 end
		n22 = k
	end
	if n22 ~= v69 % 30 + 1 then n9 = 147 end
	local flag14 = false
	if n9 == 147 then flag14 = true end
	if n6 ~= v72 then
		n9 = 100
		flag14 = true
	end
	if v73 == "err" then
		while true do
		end
	else
		local fn28, n23, v78, n24, n25, v79, tbl16, n26, n27, n28
		do
			if v34(v73, "Old script, please use the latest version") then
				if l_fastload_enabled then
					l_fastload_enabled("flush")
					return
				end
			end
			if v26(v73, 1, 1) == "!" then
				local v80 = "Whitelist Error"
				local v81
				if string["find"](v73, ";;lrm_is_diff_msg") then
					v80 = "You are blacklisted"
					v81 = v26(v73, 2, #v73 - 17)
				else
					v81 = v26(v73, 2, #v73)
				end
				fn14(100, "[ AUTH ERROR ]", " - Unable to authenticate.", Color3["new"](1, 0, 0), "error")
				fn4(v80, v81)
				fn9()
			end
			if v74 then
				if not v74["Argwhudata"] then local v80 = v74["argwhudata"] end
			end
			local n29 = tbl11[4] % 256
			local tbl17 = { [0] = tbl11[1] % 256, tbl11[2] % 256, tbl11[3] % 256, n29 }
			fn8()
			fn28 = function(arg)
				local n30 = 1103515245
				local n31 = 12345
				local n32 = 99999999
				local n33 = arg % 2147483648
				local n34 = 1
				return function(arg2, arg3)
					local v80 = n32
					local n35 = n30 * n33 + n31
					local n36 = n35 % v80 + n34
					n34 += 1
					n33 = n36
					n31 = n35 % 4859 * (v80 % 5781)
					return arg2 + n36 % arg3 - arg2 + 1
				end
			end
			if getfenv()[tbl15] ~= v71 then
				n9 = 100
				flag14 = true
			end
			n23 = 1
			for i = 1, 30 do
				local v80 = tostring({})
				local n30
				if tostring({}) < v80 then
					n30 = n23 + 1
				else
					n30 = n23 * 2
				end
				n23 = n30 % 10000
			end
			fn27(1, tbl17, 4)
			v78 = fn25(v73)
			n24 = v78[1] - n16
			n25 = v78[4] - v69
			while n29 ~= tbl17[3] do
			end
			fn20()
			v79 = tbl17[3]
			tbl16 = {
				[0] = tbl17[0],
				[2] = tbl17[1],
				[4] = tbl17[2],
				[6] = v79,
				v78[9],
				[3] = v78[7],
				[5] = v78[2],
				[7] = v78[6],
			}
			fn27(1, tbl16, 8)
			n26 = v78[8] - tbl14[1]
			n27 = v78[3] - tbl14[2]
			n28 = v78[5] - tbl14[3]
			local str4 = "" .. fn17(tbl14[3] + 17418) .. fn16(tbl14[1] + 31) .. fn13(tbl14[2] + 16589)
			if v78[11] == str4 and ({ [str4] = true })[v78[11]] then
				flag2 = true
			else
				local str5 = "" .. fn10(tbl14[3] + 17418) .. fn13(tbl14[1] + 69) .. fn16(tbl14[2] + 16589)
				if v78[11] == str5 and ({ [str5] = true })[v78[11]] then flag2 = true end
			end
		end
		local n29, v80, str4
		do
			if flag2 then
				local flag15 = tonumber(v78[14] and v78[14] or "-1") == -1
				tonumber(v78[15] and v78[15] or "0")
			end
			n6 = -1
			fn15()
			if n6 == -1 then
				n9 = 250
				n6 = 100
			end
			n29 = n7 + v67(111111, 999999) + v68(1234, 5678) + n6 % 99915 + n23
			tbl14[4] = n7 + n6 % 9951
			v67(100000, 1000000 + n6 % 1000)
			tbl14[5] = n6 % 8005 + n23 + v68(100000, 1000000 + n6 % 5000)
			tbl14[6] = v67(100000, 1000000)
			fn27(2)
			v80 = v78[10]
			local v81 = tbl14[6]
			local v82 = tbl14[4]
			str4 = fn26("" .. fn13(v78[13] + 10641) .. fn17(n29 + n9) .. fn16(v78[10] + v69)) .. fn26(tbl14[5] .. "") .. fn26("" .. n29) .. fn26("" .. v81) .. fn26(v82 .. "")
		end
		local str5 = fn26(fn13(fn27(3) + 6105) .. "", true) .. str4
		local v81 = v78[12]
		local response = game:HttpGet(tbl5["Host"] .. "/" .. v9 .. "/auth/start/" .. v81 .. "?t=" .. str5)
		while v79 ~= tbl16[6] do
		end
		if response == "err" then
			while true do
			end
		else
			if v26(response, 1, 1) == "!" then
				game:GetService("Players")["LocalPlayer"]:Kick(response)
				fn9()
			end
			do
				local v82 = fn25(response)
				local n30 = 1
				local v83 = fn28(1 + v67(100, 1000 + n23) + v68(500, 5000 + n23) + n7 % 10000)
				local flag15 = false
				local n31 = 0
				local flag16 = false
				local flag17 = false
				local v84 = nil
				for i = 1, 3 do
					local v85 = v82[3]
					local str6 = fn13(tbl14[5] + 7481) .. fn13(tbl14[4] + fn23(flag16 and "?" or game["JobId"])) .. fn13(tbl14[6] + tbl14[2])
					if v85 == str6 and ({ [str6] = true })[v85] then
						flag3 = true
						if not (v82[8] and (v82[8] ~= "?" and v82[8])) then local v86 = "Unknown" end
						if not (v82[9] and v82[9]) then local v86 = "Unknown" end
						v84 = v82[6]
						do
							local n32 = v82[1] - tbl14[4]
							local n33 = v82[7] - tbl14[5]
							local n34 = v82[5] - tbl14[6]
							local v86 = n26
							local v87 = n27
							local v88 = n28
							n26 = function(arg)
								if not (flag15 or n31 < v29() - 8) then
									n30 = (n30 + arg % 66) % 6644
									return v86 * arg % n32 + arg * 3
								end
								while true do
								end
							end
							n27 = function(arg)
								local v89 = flag15
								local flag18
								if flag15 then
									flag18 = v89
								else
									flag18 = n31 < v29() - 8
								end
								if not flag18 then
									n30 = (n30 + arg % 50) % 5891
									return v87 * arg % 10000 + arg * (n33 % 4)
								end
								while true do
								end
							end
							n28 = function(arg)
								if not (flag15 or n31 < v29() - 8) then
									n30 = (n30 + arg % 35) % 6711
									return (arg + n34) % 100 * (arg % (v88 % 100 + 1))
								end
								while true do
								end
							end
						end
						flag17 = true
						break
					elseif i == 3 then
						flag17 = false
						v84 = nil
					else
						flag16 = true
						flag17 = false
						v84 = nil
					end
				end
				if not flag17 then
					while true do
					end
				else
					if not flag14 then
						local v85, genv, fn29, fn30, fn31, tbl17, tweenService, playerGui, iCollectProUIHost, v86
						local v87, fn32, iCollectProThemeIsHalloween, service, deviceClass, fn33, fn34, Players, RunService, UserInputService
						local TweenService, localPlayer, tbl18, tbl19, tbl20, tbl21, n32, tbl22, tweenInfo, tweenInfo2
						local tbl23, fn35, createUICorner, createUIStroke, fn36, iCollectProAPGameGui, fn37, iCollectProAPIsAllowed
						do
							local fn38, tbl24
							do
								do
									local tbl25, tbl26, fn39, obj, obj2, fn40, fn41, fn42, n33, localPlayer2
									local fn43, v88, n34, v89, v90, v91, v92, n35, fn44, v93
									local flag18, flag19, fn45, flag20, n36, flag21, fn46
									do
										local localPlayer3
										do
											do
												do
													while not flag12 do v28:Wait() end
													flag7 = true
													do
														local flag22 = false
														local flag23 = false
														local n37 = 0
														local n38 = 0
														local n39 = 0
														local flag24 = false
														local n40 = 0
														local n41 = 0
														local v94 = v78[12]
														spawn(function()
															flag23 = true
															while not flag9 do
																local n42 = v83(1000, n30 + 10000) + n30
																local n43 = v83(1000, n30 + 10000) + n30
																n40 = n42
																n41 = n43
																fn27(2)
																local v95 = fn26
																local str6 = fn26(n41 .. "") .. v95(fn17(n41 + v80) .. "" .. fn16(n40 + n16)) .. fn26(n40 .. "")
																local v96 = ""
																local v97 = v9
																local v98 = v3
																local str7 = tbl5["Host"] .. "/" .. v97 .. "/auth/heartbeat?t=" .. str6 .. "&s=" .. v94
																pcall(function()
																	if flag8 then
																		local v99 = v3
																		rconsoleprint("[" .. v29() .. "] Sending ticket...(" .. tostring(flag6) .. ")\n")
																	end
																	if flag6 == false then
																		v96 = fn19(str7)
																	else
																		v96 = flag6:request({ ["Url"] = str7 })
																	end
																	if flag8 then
																		local v99 = v3
																		rconsoleprint("[" .. v29() .. "] Ticket responded\n")
																	end
																	if v96 and #v96 > 3 then
																		if v96 == "NOT_FOUND" then
																			flag15 = true
																			flag2 = false
																			flag3 = false
																			n25 = 1
																			n24 = 2
																			local v99 = v3
																			game:GetService("Players")["LocalPlayer"]:Kick("A fatal Luarmor error occurred, please restart your script.")
																			fn9()
																		end
																		if v96 == "FAIL" then
																			flag15 = true
																			flag2 = false
																			flag3 = false
																			n25 = 1
																			n24 = 2
																			local v99 = v3
																			writefile("luarmor-dbgfail.txt", "resp:fail")
																			while true do
																			end
																		else
																			v96 = fn25(v96)[1]
																			if v96 == fn13(n40 * n41 % 100000 + n29 + 5516) .. "" then
																				n38 += 1
																				flag24 = true
																				flag22 = true
																			elseif v96 == fn10(n40 * n41 % 100000 + n29 + 5516 + 4919) .. "" then
																				flag24 = true
																				flag22 = true
																				flag9 = true
																				pcall(function()
																					flag6:close()
																				end)
																			else
																				flag15 = true
																				flag2 = false
																				flag3 = false
																				n25 = 1
																				n24 = 2
																				local v99 = v3
																				game:GetService("Players")["LocalPlayer"]:Kick("Heartbeat failure [0x01]. ttl: " .. n38)
																			end
																		end
																	end
																end)
																wait(20)
															end
														end)
														while not flag23 do v28:Wait() end
														flag23 = false
														spawn(function()
															flag23 = true
															local n42 = 200
															while true do
																n42 += 1
																if not flag9 and n42 >= 250 then
																	if flag24 then
																		n37 += 1
																		if n37 > 4 then
																			n37 = 0
																			if n39 < 10 then n39 += 1 end
																		end
																	else
																		n39 -= 1
																		if n39 <= 0 then
																			flag15 = true
																			flag2 = false
																			flag3 = false
																			n25 = 1
																			n24 = 2
																			local v95 = n38
																			writefile("luarmor-error-log.txt", "[0x2001] " .. v95 .. " v: " .. tostring(flag6))
																		end
																	end
																	flag24 = false
																	n42 = 0
																end
																n31 = v29()
																wait(0.18)
																if n31 ~= v29() then continue end
																flag15 = true
																flag2 = false
																flag3 = false
																n25 = 1
																n24 = 2
																local v95 = n38
																writefile("luarmor-error-log.txt", "[0x2022] " .. v95 .. " v: " .. tostring(flag6))
															end
														end)
														fn14(95, "%", " - Finalizing..")
														while not flag23 or not flag22 do wait() end
													end
												end
												do
													do
														do
															fn14(100, "[   SUCCESS   ]", " - Authenticated in " .. v29() - now .. "s", Color3["new"](0, 1, 0), "done")
															v85 = nil
															do
																local tbl27 = {
																	[6] = 53,
																	[20] = 214,
																	86,
																	[13] = 12,
																	[4] = 163,
																	[14] = 61,
																	[9] = 162,
																	[16] = 225,
																	[21] = 45,
																	[3] = 46,
																	[17] = 33,
																	[15] = 46,
																	[7] = 236,
																	74,
																	[19] = 64,
																	[5] = 254,
																	[18] = 110,
																	[12] = 50,
																	[22] = 11,
																	[23] = 51,
																	[10] = 195,
																	[8] = 88,
																	[11] = 80,
																}
																luraph_runtime1(v84, buffer.fromstring("\225\n\rxJ\148\184\146}\161\244\17\128Qo\144\172\148\163\217\2331K\160\213\231\243\147d0_\191\193p\140\212\247.F\150[\190\155\156r\24\u{383}\222\220\8\17\24\182F`\26\137A\2202\205m\r\174\182>E\196\220\252\"\131\168T\162\171\221ڼQ\241\234V\171 4n\3EƲhY\235\172\n\186[a\136\238\137K\17\28\199<\140\137\230ch#\253\179H\240[\215(\224j(\130š\242\160GH\155\178f\161?\159\3\130\130\r#.X\237\236a\157k\134\201UB%\227\130.\160\171_&\193\242muV\164\221\196'\251L\154\167%\251\250܍\177\216\239\158[\132嵇!D\156\173\t\r|\160#uA\14/\165A|\n]9\163cr\187#!\144\187ҿV\189;\174\15\254\221\3*4\180\31\173P\210\11>\2118\200\247\1596\232\194\209\1\177\206<\221\15\148ևsXh13i\16\133\212`m\221~k\236\t\203d\199\253\17\194\206K\244ɤ\208\243\169\233\15\142\171\221\215\nr\5ް2\188\150\182mԹ\21\159\17\163G\29\172L\142\202@\136\0074\158\153\181\251\139\132oˋ\197\27^\7\23G=D\184\193q+\21\235\6\23\r\153<C\222V\193\20\233\24\245\19\0\141s\30e\1510\213>W\1421\"OR<\224\12e\242ww\171\30\177\183VR\128\15\23\248\141\172\241\177ז\164\30\2023c}Zj\233AbOx\19377x\176\186zn\148\1703\15wN\7\255y\181\2298Z\251\3<\1906x\230\218Ɨ#am]\222ɏ\165<de\241\208T\179\183\157O\254)}5\"7Ϝ\128\145إ\177\140K\255-Ѱ\205\248\178\t5.\167\30v\23\23\148\147XS\152Q\235\8i\229M\"R\180\238R]\180j\149\204\225\140\\\190\137\7\226\146\27\186lI\146,\22c\148W\240\236\253\28\127\244\4\252\254#\173\22\188\23Q*\141!\187w\133\220\11\232C߽f\238ٸfA\197\223\193\220kb9\8k\178\27\209瓚\28L<\22bM\195է\157ɵR\t$\160\217~\147\r\230\211i\159 \31\144(tlc\159\236\148c\163?0\238\17\137\131\7齟\164\166\169č\190n\4\137$\141ߍ\24\20Eȋ\28\161\25\247\189\137_\0115t\153\26\11\14\190A\247ix\179\234\255\208 \197\22\237\213\7\144\18\219\30\206w\246\249T\170D\14\183\16<?\30n\239(l\160U^`\174\174\19\206\22\246\161\213l\133\215F\173\168rQ;\27\182\19\22\30\20pW{\137\138\166*Pj\237XH\195&R/\210\204\199Ɲ\23\135\144\160\192˸\129\160%3\213&\177\t\207\15W\130\171\188\153\140\227`v\230\171\235P\233\149>H\206tc\193\171\16R#\208\1\249L\242(\254<qPƽ@@`\198-\175\183\218\231\253nc\145\r\222o#)\247\153\135\159\"\12\202\24\157N+\144b\132'\215\233\244\255v\192|qE\235\187\235\171,_M9T\n\166\127̴\202\197\237\187G\172p\238\138n<\4e\128\237\194\2553\230\176,\137\215\16b#\222\19\178\253\209k\"\249sG \150elC\130\157B\201%\202\25\166\200a1v\0273L\247\28ky(\159x\18\31MAډ\166\199A4\159\173\132\7j<E\163݂s\5\1271\236`\211\253\181\145\185\15ы\210\26\29b\229G\186\164\130\178on,+\6\193\216Cc\145\157'6z\240\220\u{87}\238\161t\248|\237\169\133\164\31\134\167Y\192\228)zZ\243<S1\244w\244\0145d\4Dh49\145\127\237|\229m\214k#\134\213\198F\184-\172}TI\231\136\238NS_\233Bs\234\184\230\198.\17\184\236\"A\23\222\235\0015\28ϷIe\18<h\139\170\127\168B\203\"\151\231\189\14s\tui;\162NQ\225\154\236\247㎐\4b\177\226\187\243!ح!o\245\127\1528\165\242\233M\150`\175@\250\\K>\233\1555S\15fߧ\168\230[y\2\150\217Y\232\200\19\15\155$\31r\3\180\237t?E\1670}w\136\250J\18%3\132\5\242U\216;r7б\128\222<\241}\25\174\6\144\30\0eވ\145\1350\182\24d7\229\246\246\239\230rL\28\224\208\220\15\21\165\28\247\255'CS\163\204\01430\7)\r\n\20\16\28=\159P\230\226\141C\186i\178G\146>0!ݽY\149za\r\165eQ\223\r\239\148\199b\218Mh?`~\129\232\r\138Ip\199\2431\242'L\130\208r)\244\129-\244@P\180\155\164mf7\231\132\4\215>\26\140\161\195<\200\231\2099@\169l\7NB\128Zg_\2J\31b\134f\174\139%\219*\160\230\20\188\146\29-\212-ȑT\212*Q\151i\220r7\187z\129\179\20fsR\5$\158\186\134\t\136\237\224\148a\0000\148\226\206\30\229\n\245?,>\135\225\138\246}\0\131\234\22HU2\168\142\204\245\182f>F`깪\220\230\141/L\168O\174\201\r7\3&\221+\253\1879\2141\170\128IQ#\244\228S\178\248W\212\218\233b\224\165\nP\181\141\20F\"\143߉17\139\11\134m[\153e>\168\241̮Zsf\171\5A\241\128\20mڝ\133\145L\18\175=\199\127_\14\17r\5\1F\178U\17\241\153\163\251m]\183\222E!\164\168!\129[\160\156\\\152TЉ#\167\255:I%;7\25\218?o\221$.\12ᙪ\214h\204\210Z9a*\157b\253\133\202(7\11\149I\208\238\24 \173J\160\190\223 \152\154\243\222\224l\141\0O\149\184\181\2431\133\175Y\u{7BE}\23nP\0\254L\212F\167\240\16\6\244\137\228 KE\28P̼\245\240\143\154\234S\n\141\127}<\232\253B6\n\159AiX\155;\228j\153\201`. G\189\157g\142nԅ\0308\217\236Y1\186\150.}@\14V\3!`h\176\164t\191\2476d*G\172\131K\0176#h\12Q#>\29o+\164+Бq\135_XD\131\132\206\234:\147cZ|W\161\139( \11A\130\14q\183\185|\27\253B\199\231\174\204`U\141\11G\244]\136\175Hw\242N\161\2217\147\u{5F7}֦\253]\158\2\24\183\251\198P\194/\181\r\157\233=T-\221\201=7\25\228ȡ\162\132\1\245\181\t2\5\ty\219O\"W69\171\250\156W\137\251\167Ys&.C\152\199YU\n\168\tl\14366\253\25d\142\236\2082 \190\172\144\2\140v\160\194M\17a\17/=V\245\244\177\142\0057\205ceV(BOJie\144\146<\255\217\24A\11M}\154\11\223\22\234.h\139\206\"\177\229\145f\194\2290\"\0124\193\176\185\246\154\132\196##\187\6\238s\189询\17\155\227\189\250\228\17\227\236|\221\18\n89\130!\246-\26\225X\24\164?Wg\0\140\4\27.\1743\177UՄ\11\236.B(\188\160\198Tol\1\11Sl\250\139L\170˩\2425(\217\21\196O\8\29\128]\2456\24\252\134l\243\248\185\239fq\17\237\179l\2296E\21el\169\179c\238\236l\233+95\225\0\233\246\12\137\17R\0011\165_\182\217&D\251\2525t\164-\2332\0c/\15\16B\135+\201\3FT\252\19D)\204\252\254\12\235\195g:\nS\133\226\5\188\21⻙q\27s\216W\4\225R\141Dk6\143 o:YK\184huR\149\174\163\183\157£\25݊\243\192\22Ս\139\228z\167q\234f\142\182\233$\247#9\23\213}\18\229\150\127AB\128u\217\220g\175{\152¥\27\240\252\246\244MI\0314^r\189\29\132\12{\189\195mP\2079\0156S\1\228\17\231\145N\147N\249+\228\254'\139\163H\233[\135|*\187\128a\2264!>yB\0\14\217\14蝨\28\204q*52\246j\198\209T\133\188\164R.r\\\7\253\167\153wG\199l\24ju9\128`\253H\138\t\0\161\218M\215\201\2440j\175\179\216\229U\208:\134#\238\131V\21\237f\177Ə5M\203\193\207M\214\r\237(\207\0026\4s\249\172\28\245\223\217v\1864s\2314\214xp\200\222\219S\14\177i\224\153\167-\245\254\16\238\6\228\140\"\158{\142\145\12\133\169\252\"0X&܍\1288S\237\223\245\25\242\240zƹ=\164\208\237\243Ma\224<\6E\137V\165\241F(ݻS\176\23\t\1467\153\227\r\229\238\183/2\241U\185i=\u{AD}碄\179$v2\189\232\243\187Q\200t\138\164g\0053L\171t\28\206\22\233+\142\135N\31\203\236/s\159\24\231\235\191Vz\"\1992\223,\144\24\244\11\212`\236\244\186ncHT@N\248m6X\132G/\176?\206\3\188\177\180\205\26\254b9\248\n\232\171b,J\150\6\237JY\19\193\216\220o|\127\184+#d?\255Y\171\225\179g\147j\0\\=\192Y\203ݶ\233N\236\203\246O\165F\205Z\22\11\237\5\16X(g\6\1\254\29ݗy\139\149J\191\130\191\233l\15\251`\140w\135r \17\23\t'\28\22\17{u+\3<\14\168\140\\\20Q!y\tr\170y6\254\156\134\254\130\8k\151=\247\192]\150\156\180`owS\222b\232\220\197\252@\24.\243\216V\129[8>\201{lg\192S|\\[\21^@\216\221*s-=$P@\179\158\233E)Mk`\215ѿ\178͒m\200\196\127p!\202\6\168'\235\169\246Z\140\2225\176m\2\1663/\224\220\u{93}l\251\30\27\15\0\171\164\216T\234l\219\2458\230VP\207> \190BP\r\132)z\202\213\246\196\22\176\182\232@\163㗉\t-U\157=Z7`\227\20\179\25\247\192n\177\159\147\217j}\235j\223~\128n\192\179\4!\235\232<\227°\233:X\169չ\166\154\139\2029UN\19'\244\t\179g\164B\234\177\26\136\187\30d\156E`2\137\218\195M\242w\144\221i\6\3\179\170\157\243^\31\131\238\149.\188aeR\142\22槻\239A6;\16\212Y\166Ҷ\251Y\234\238!\182\164\216\12\149%8\29\165\133-\24\176\218H\186\14\224\30\24&\15\2\248\224\140\190A\149\175\6\237\151\225uj\212⌟\6;\152u\191H\4\178\238v\216\237\218\218\226\167`\184\251k\155\27\143\193l&\151\157\224\24+Έ\207'\18\162\153d\176\2\192:\205\251\r\141\14]\169c\229\223'\1\7\129\147\233jj\31=0\240v\155\28\208ݛ@Qſm\212\229\211?\128\147ľN \rn\244`\129\137/\169\139Oj\185\204ҩ\150\164B\253~`\141֦\129\138\218v\31\170\151\15\252\244\169\136<8/@㳐i\232l[\139\221\204\252\1420\242 \151\152'\183\173\5$}Z\255\243\\K\137\173\1431\226QcL\131\\|\6J\239\191\19Kv\190I\172\166\175g\12\167>\169x\139^\246z\213\n\u{97}\155\4,\195@[\29t\162n4Tw\31\27N\162\255\248\216l\152\245\2551\236\220\210h\174\218\227\173Cp\17\12\196\233\r\154U\243\158;\231\131?\u{5CA}\151R9\150_~\"\173\225\238C\230\138/\243Z\196\243w(\165\146\6\31\17O\195\198\230\r\218\21\209}\203\4\1\2\199\u{58C}\142\144\188\231\2505\247\2\242\22t뵰a\187\197y\21\180v\180\160q\188J/\240\21\170\2225\\\178\15\29{\19#U\183%\11Y\149\172\231\1999`\18\247\167\193[1\200\246%\25o\234\247\25\230\207g\129\12C\20\146\191\198z\158\204}\176mb\183_\1716\255\29NF\179\\\129\8\149\179\30\253\252+\187k%\146\177z\247UY\234\244\206\208\229\\e\0\251\20\0\144_\187\235\255\253\163\15\133\130ѿd*\251\\\186)\252\17e\191q\174hg\248H8T\230\150P\145\1684X\192/\234v*\213\n\"\168\2526_3\226\246צ\226e\22\25\1\255<7n\228\15\190$\158X\217\17\21\190\229\229]\139{\149\233\248\219)qK9\18\183I{G\200T\198h\185Q^\20I;\7\150\189\188\0\228\174\202\239j\155\185\213'gzJ\26)S\152\7\193\224A\131\202MW扙*U\255\29#\139\165\203e\193\02381\\\1\17\197\2\r\136)~-F᧗\184\208\24\245\186_\225B\246\158\1804+\244g\152\2015I\169\181\215\212\224\240\181VӾV\208?s\145\1\162\3?i\247\236MY\170\162|\3\20\1577C\2072\154S\0,H\30%#\1473\203'\195>\173\188\161o\157K\19N\4B\1659\0l\144\203ҍ3\137\252\155%y\181\158,\192\31\253\129\209\202&\172o\181\162\r\131\191o\148\17\171\2394\206\218K\247\255\147\236\245\175S<\173\141둛\246\"ղ\177\182cA\145\133\172\151n\252-uJ9"), tbl27, 315)()
															end
														end
														pcall(function()
															if setthreadidentity then setthreadidentity(8) end
														end)
														genv = type(getgenv) == "function" and getgenv() or _G
														do
															local CollectionService = game:GetService("CollectionService")
															fn29 = function(arg)
																if arg then
																	pcall(function()
																		CollectionService:AddTag(arg, v85[25])
																	end)
																end
																return arg
															end
														end
													end
													do
														local iCollectProUnload = genv.iCollectPro_Unload
														genv.iCollectPro_Gen = (tonumber(genv.iCollectPro_Gen) or 0) + v85[64]
														local iCollectProGen = genv.iCollectPro_Gen
														local tbl27 = {}
														if type(iCollectProUnload) == "function" then pcall(iCollectProUnload) end
														fn30 = function() return genv.iCollectPro_Gen == iCollectProGen end
														if genv.ICP_SAFE == nil then genv.ICP_SAFE = true end
														fn38 = function() return genv.ICP_SAFE ~= false end
														fn31 = function(arg, arg2)
															local connection = nil
															connection = arg:Connect(function(...)
																if not fn30() then
																	if connection then
																		pcall(function()
																			connection:Disconnect()
																		end)
																	end
																	return
																end
																return arg2(...)
															end)
															tbl27[#tbl27 + v85[64]] = connection
															return connection
														end
														genv.iCollectPro_Unload = function()
															for _, v94 in ipairs(tbl27) do
																pcall(function()
																	v94:Disconnect()
																end)
															end
															table.clear(tbl27)
															if type(genv.iCollectPro_WalkSpeedSet) == "function" then
																pcall(genv.iCollectPro_WalkSpeedSet, v85[139], true)
															end
															for _, v94 in ipairs({
																"iCollectPro_PodiumESPCleanup",
																v85[200],
																"iCollectPro_DisableAntiRagdoll",
																"iCollectPro_AntiDieOff",
																"iCollectPro_CarpetOff",
																"iCollectPro_TpCancel",
																"iCollectPro_FpsBoostOff",
																"iCollectPro_ExtrasOff",
																"iCollectPro_SaveNow",
															}) do
																local v95 = genv[v94]
																if type(v95) == "function" then pcall(v95) end
															end
															local tbl28 = {}
															pcall(function()
																local localPlayer4 = game:GetService("Players").LocalPlayer
																tbl28[#tbl28 + v85[64]] = localPlayer4 and localPlayer4:FindFirstChildOfClass("PlayerGui")
															end)
															pcall(function()
																tbl28[#tbl28 + 1] = gethui and gethui()
															end)
															pcall(function()
																tbl28[#tbl28 + 1] = game:GetService("CoreGui")
															end)
															pcall(function()
																for _, v94 in ipairs(game:GetService("CollectionService"):GetTagged("iCollectPro_UI")) do
																	pcall(function()
																		v94:Destroy()
																	end)
																end
															end)
															local tbl29 = {
																"lMWjwEoSnCPj",
																"bRXgmsaEVfze",
																"kzBUJxAKwhtf",
																v85[63],
																"qNvTxRbKzWme",
																v85[76],
																"XkPqFlyGearPicker",
																"XkPqBoostSettings",
																"XkPqKickToPS",
																v85[133],
																v85[145],
																"XkPqNoTargetDim",
																"XkPqKeybinds",
																"XkPqQuickBar",
																"XkPqTpSlot",
																"XkPqExtras",
																"__NextBaseAnchor",
															}
															for _, v94 in ipairs(tbl28) do
																if v94 then
																	for _, v95 in ipairs(tbl29) do
																		for i = 1, 8 do
																			local v96 = v94:FindFirstChild(v95)
																			if v96 then
																				pcall(function()
																					v96:Destroy()
																				end)
																				continue
																			end
																			break
																		end
																	end
																end
															end
															pcall(function()
																for _, v94 in ipairs({ v85[171], "__PodiumStandFloors" }) do
																	local v95 = workspace:FindFirstChild(v94)
																	if v95 then v95:Destroy() end
																end
															end)
															pcall(function()
																for _, child in ipairs(workspace.CurrentCamera:GetChildren()) do
																	if child:IsA("BasePart") and child.Name == v85[99] then child:Destroy() end
																end
															end)
															genv.AUTO_STEAL_ACTIVE = v85[139]
															genv.NEAREST_INSTANT_MODE = false
															genv.INSTANT_ANY = v85[139]
															genv.iCollectPro_WalkSpeedOn = false
														end
													end
												end
												do
													local tbl27 = { "XkPqTpSlot" }
													local tbl28 = { "TPtoSlotRow" }
													local function fn47()
														local tbl29 = {}
														pcall(function()
															local localPlayer4 = game:GetService("Players").LocalPlayer
															tbl29[#tbl29 + 1] = localPlayer4 and localPlayer4:FindFirstChildOfClass("PlayerGui")
														end)
														pcall(function()
															tbl29[#tbl29 + 1] = gethui and gethui()
														end)
														pcall(function()
															tbl29[#tbl29 + 1] = game:GetService(v85[185])
														end)
														return tbl29
													end
													local function iCollectProPurgeRetired()
														for _, v94 in ipairs(fn47()) do
															if v94 then
																for _, v95 in ipairs(tbl27) do
																	for i = 1, 8 do
																		local v96 = v94:FindFirstChild(v95)
																		if v96 then
																			pcall(function()
																				v96:Destroy()
																			end)
																			continue
																		end
																		break
																	end
																end
																for _, v95 in ipairs(tbl28) do
																	for i = 1, 8 do
																		local v96 = v94:FindFirstChild(v95, v85[192])
																		if v96 then
																			pcall(function()
																				v96:Destroy()
																			end)
																			continue
																		end
																		break
																	end
																end
															end
														end
													end
													iCollectProPurgeRetired()
													genv.iCollectPro_PurgeRetired = iCollectProPurgeRetired
													task.spawn(function()
														for i = 1, 10 do
															if not fn30() then return end
															pcall(iCollectProPurgeRetired)
															task.wait(1)
														end
													end)
												end
											end
											do
												do
													local localPlayer4 = game:GetService("Players").LocalPlayer
												end
												if not game:IsLoaded() then game.Loaded:Wait() end
												tbl17 = {
													SelectedPetData = nil,
													AllAnimalsCache = nil,
													DisableStealSpeed = nil,
													ListNeedsRedraw = v85[192],
													StealSpeedToggleFunc = nil,
													_ssUpdateBtn = nil,
													MobileScaleObjects = {},
													RefreshMobileScale = nil,
													RefreshMobileScaleFor = nil,
													MobileActionButtons = {},
													RefreshMobileActionButtons = nil,
												}
												tbl25 = { AUTO_STEAL = v85[139], RADIUS = 12 }
												do
													local tbl27 = {}
													local tbl28 = {
														min = Vector3.new(-337.448303, -3.898971, -122.397758),
														max = Vector3.new(-328.004578, -3.898971, 242.625626),
													}
													local tbl29 = {
														min = Vector3.new(-327.25766, -3.899109, -v85[96]),
														max = Vector3.new(-320.600891, -3.899109, 242.612259),
													}
													local tbl30 = {
														min = Vector3.new(-319.783386, -3.89897, -v85[196]),
														max = Vector3.new(-312.908325, -v85[148], v85[47]),
													}
													local tbl31 = {
														min = Vector3.new(-312.445648, -3.899108, -v85[83]),
														max = Vector3.new(-305.489899, -3.899108, 242.456818),
													}
													local tbl32 = {
														min = Vector3.new(-305.037048, -3.89897, -v85[158]),
														max = Vector3.new(-293.957489, -3.89897, 242.606873),
													}
													local tbl33 = {
														min = Vector3.new(-v85[86], -3.898972, -v85[147]),
														max = Vector3.new(-481.811737, -3.898972, 242.615005),
													}
													local tbl34 = {
														min = Vector3.new(-498.971069, -3.89897, -122.382767),
														max = Vector3.new(-v85[100], -3.89897, v85[6]),
													}
													local tbl35 = {
														min = Vector3.new(-506.436737, -3.898972, -122.411476),
														max = Vector3.new(-v85[170], -3.898972, 242.615982),
													}
													local tbl36 = {
														min = Vector3.new(-513.783569, -v85[35], -122.223297),
														max = Vector3.new(-506.801849, -3.898972, 242.62709),
													}
													local tbl37 = {
														min = Vector3.new(-v85[10], -3.898972, -122.409813),
														max = Vector3.new(-514.265015, -3.898972, v85[20]),
													}
													tbl27[1] = tbl28
													tbl27[2] = tbl29
													tbl27[3] = tbl30
													tbl27[4] = tbl31
													tbl27[5] = tbl32
													tbl27[6] = tbl33
													tbl27[7] = tbl34
													tbl27[8] = tbl35
													tbl27[9] = tbl36
													tbl27[10] = tbl37
												end
											end
											do
												local RunService2
												do
													local Players2 = game:GetService("Players")
													RunService2 = game:GetService("RunService")
													localPlayer3 = Players2.LocalPlayer
												end
												local v94 = nil
												local function fn47()
													localPlayer3.DevEnableMouseLock = true
													localPlayer3.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
													if v94 then v94:Disconnect() end
													v94 = fn31(RunService2.RenderStepped, function()
														local currentCamera = workspace.CurrentCamera
														if currentCamera and currentCamera.CameraSubject and currentCamera.CameraType == Enum.CameraType.Custom then
															currentCamera.CFrame = currentCamera.CFrame
														end
													end)
												end
												fn47()
												fn31(localPlayer3.CharacterAdded, function()
													task.wait(0.5)
													fn47()
												end)
											end
										end
										local v94
										do
											do
												local fn47
												do
													local tbl27, tbl28
													do
														tbl26 = {}
														tbl27 = {}
														tbl28 = {}
														fn39 = function()
															local character = localPlayer3.Character
															return character and character:FindFirstChild("HumanoidRootPart")
														end
														do
															local function fn48(arg)
																local parent = arg.Parent
																if not parent then return end
																if parent:IsA("Attachment") and parent.Parent then parent = parent.Parent end
																if parent:IsA("BasePart") then return parent.Position, parent end
																if parent:IsA(v85[174]) then return parent:GetPivot().Position, parent end
															end
															obj = setmetatable({}, { __mode = v85[93] })
															obj2 = setmetatable({}, { __mode = v85[93] })
															fn40 = function(arg)
																if not arg or not arg.Parent then return nil end
																local tbl29 = obj[arg]
																if not tbl29 then
																	local v95, v96 = fn48(arg)
																	if not v95 then return false end
																	local v97 = workspace:FindFirstChild(v85[2])
																	local name = nil
																	if v97 then
																		local model = arg:FindFirstAncestorWhichIsA("Model")
																		while model and model.Parent ~= v97 do model = model.Parent end
																		name = model and model.Name or nil
																	end
																	local animalPodiums = arg:FindFirstAncestor("AnimalPodiums")
																	local parent = nil
																	local z = nil
																	local parent2 = nil
																	if animalPodiums then
																		parent = arg
																		while parent and parent.Parent ~= animalPodiums do parent = parent.Parent end
																		parent2 = animalPodiums.Parent and animalPodiums.Parent:FindFirstChild(v85[53])
																		if parent2 and parent2:IsA("BasePart") then
																			z = parent2.CFrame:PointToObjectSpace(v95).Z
																		else
																			z = nil
																			parent2 = nil
																		end
																	end
																	tbl29 = { pos = v95, holder = v96, plot = name, slot = parent, root = parent2, relZ = z }
																	obj[arg] = tbl29
																else
																	local holder = tbl29.holder
																	if holder and holder.Parent then
																		local ok, pos = pcall(function()
																			return holder:IsA(v85[174]) and holder:GetPivot().Position or holder.Position
																		end)
																		if ok and pos then
																			tbl29.pos = pos
																			if tbl29.root and tbl29.root.Parent then
																				tbl29.relZ = tbl29.root.CFrame:PointToObjectSpace(pos).Z
																			end
																		end
																	end
																end
																return tbl29
															end
														end
													end
													fn41 = function(arg, arg2)
														if not arg or not arg.Parent then return false end
														if not arg.Enabled then return v85[139] end
														local v95 = fn40(arg)
														if not v95 then return false end
														if v95.plot and genv.iCollectPro_IsOwnPlot then
															local ok, result = pcall(genv.iCollectPro_IsOwnPlot, v95.plot)
															if ok and result == v85[192] then return false end
														end
														local v96 = v85[88]
														return (v95.pos - arg2).Magnitude <= math.max(typeof(arg.MaxActivationDistance) == v96 and arg.MaxActivationDistance > 0 and arg.MaxActivationDistance or tbl25.RADIUS, 13)
													end
													do
														local function fn48(arg, arg2)
															local now2 = os.clock()
															local v95 = tbl27[arg]
															if v95 and now2 - v95 < arg2 then return false end
															tbl27[arg] = now2
															return v85[192]
														end
														v94 = tbl27
														fn42 = function(arg, arg2, arg3)
															if not arg or not arg.Parent then return end
															if not arg.Enabled then return end
															if (arg.ActionText or "") ~= "Steal" then return end
															if not fn48(arg, arg3) then return end
															for i = 1, arg2 do
																pcall(function()
																	fireproximityprompt(arg, v85[164])
																end)
															end
														end
													end
													fn47 = function(arg)
														if tbl26[arg] then return end
														tbl26[arg] = true
														obj2[arg] = os.clock()
														pcall(function()
															arg.Style = Enum.ProximityPromptStyle.Custom
														end)
														local function fn48()
															if not fn30() then return end
															local v95 = fn39()
															if not v95 then return end
															if fn41(arg, v95.Position) then
																tbl25.AUTO_STEAL = true
																genv.AUTO_STEAL_ACTIVE = true
															end
														end
														fn48()
														pcall(function()
															fn31(arg:GetPropertyChangedSignal("Enabled"), function()
																if arg.Enabled then fn48() end
															end)
														end)
														fn31(arg.AncestryChanged, function()
															if not arg:IsDescendantOf(workspace) then
																tbl26[arg] = nil
																tbl27[arg] = nil
																tbl28[arg] = nil
															end
														end)
													end
												end
												do
													local function fn48()
														local plots = workspace:FindFirstChild("Plots")
														if not plots then return end
														for _, child in ipairs(plots:GetChildren()) do
															local animalPodiums = child:FindFirstChild("AnimalPodiums")
															if animalPodiums then
																for _, descendant in ipairs(animalPodiums:GetDescendants()) do
																	if descendant:IsA("ProximityPrompt") then fn47(descendant) end
																end
															end
														end
													end
													fn48()
												end
												fn31(workspace.DescendantAdded, function(arg)
													if arg:IsA("ProximityPrompt") and arg:FindFirstAncestor("AnimalPodiums") then fn47(arg) end
												end)
											end
											n33 = fn38() and 1 or 5
											localPlayer2 = game:GetService("Players").LocalPlayer
											do
												local function fn47()
													local ok, result = pcall(function()
														return Enum.RaycastFilterType.Exclude
													end)
													return ok and result or Enum.RaycastFilterType.Blacklist
												end
												local v95 = fn47()
												fn43 = function(arg)
													local raycastParams = RaycastParams.new()
													raycastParams.FilterType = v95
													raycastParams.IgnoreWater = v85[192]
													local filterDescendantsInstances = { arg.Parent }
													local position = arg.Position
													local n37 = 7
													for i = 1, 6 do
														raycastParams.FilterDescendantsInstances = filterDescendantsInstances
														local ok, result = pcall(function()
															return workspace:Raycast(position, Vector3.new(0, -n37, 0), raycastParams)
														end)
														if not ok or not result or not result.Instance then return nil end
														local instance = result.Instance
														local animalPodiums = instance:FindFirstAncestor("AnimalPodiums")
														if animalPodiums then
															while instance and instance.Parent ~= animalPodiums do instance = instance.Parent end
															return instance
														end
														if instance.CanCollide then return nil end
														n37 = n37 - (position.Y - result.Position.Y) - v85[130]
														if n37 <= 0 then return nil end
														position = result.Position - Vector3.new(0, v85[130], 0)
														filterDescendantsInstances[#filterDescendantsInstances + 1] = instance
													end
													return nil
												end
											end
										end
										v88 = nil
										n34 = 0
										v89 = nil
										v90 = v85[164]
										v91 = nil
										v92 = nil
										n35 = 0
										fn44 = function()
											if genv.__iCollectProDropBusy == v85[192] then return true end
											local num = tonumber(genv.__iCollectProDropUntil)
											return num ~= nil and os.clock() < num
										end
										v93 = nil
										flag18 = false
										flag19 = type(firesignal) == "function"
										fn45 = function() v89 = nil end
										flag20 = false
										n36 = v85[164]
										flag21 = false
										fn46 = function(arg, arg2)
											n36 = arg2 + 0.7
											table.clear(v94)
											fn45()
											n34 = 0
										end
									end
									do
										local function fn47()
											local ok, result = pcall(function()
												return localPlayer2:GetNetworkPing()
											end)
											return math.clamp((ok and tonumber(result) or 0.05) * v85[140], 0.02, v85[13])
										end
										local function fn48()
											local attribute = localPlayer2:GetAttribute(v85[44])
											local v94 = v85[88]
											if type(attribute) ~= v94 then return 0 end
											return attribute - workspace:GetServerTimeNow()
										end
										fn31(game:GetService("RunService").Heartbeat, function()
											local v94 = fn39()
											if not v94 then
												fn45()
												tbl25.AUTO_STEAL = false
												genv.AUTO_STEAL_ACTIVE = v85[139]
												return
											end
											local position = v94.Position
											local now2 = os.clock()
											local v95 = fn48()
											if v95 > 0 then
												flag20 = v85[192]
												local v96 = fn47()
												if v95 <= v96 then
													if not flag21 then
														flag21 = true
														fn46(now2, now2 + v95)
													end
												elseif v96 + v85[130] < v95 then
													flag21 = v85[139]
												end
											elseif flag20 then
												flag20 = false
												if not flag21 then fn46(now2, now2) end
												flag21 = false
											end
											local flag22 = now2 < n36 and (v95 <= v85[164] or flag21)
											if flag22 or now2 - n34 > v85[130] then
												n34 = now2
												v88 = fn43(v94)
											end
											local huge = math.huge
											local v96 = nil
											for k in pairs(tbl26) do
												if fn41(k, position) then
													local v97 = obj[k]
													local flag23
													if v88 then
														flag23 = v97.slot == v88
													elseif v97.root and v97.root.Parent and v97.relZ then
														flag23 = math.abs(v97.root.CFrame:PointToObjectSpace(position).Z - v97.relZ) <= 3.75
													else
														flag23 = true
													end
													local magnitude = (v97.pos - position).Magnitude
													flag23 = flag23 and magnitude < huge
													if flag23 then
														huge = magnitude
														v96 = k
													end
												end
											end
											tbl25.AUTO_STEAL = v96 ~= nil
											genv.AUTO_STEAL_ACTIVE = v96 ~= nil
											local flag23 = localPlayer2:GetAttribute(v85[26]) and true or false
											if flag23 and not flag18 then
												v91 = v89 or v92 or v93
												v92 = nil
												v93 = nil
											elseif flag18 and not flag23 then
												if fn44() then
													v92 = nil
													v91 = nil
												else
													v92 = v91
													n35 = now2
												end
											end
											flag18 = flag23
											local flag24 = not flag23
											if flag24 and v92 and fn44() then v92 = nil end
											if flag24 and v92 then
												local v97 = obj[v92]
												if now2 - n35 > 12 or not v92.Parent then
													v92 = nil
												elseif flag19 and not v92.Enabled and v97 and (v97.pos - position).Magnitude <= 13 then
													pcall(firesignal, v92.Triggered, localPlayer2)
												end
											end
											if fn44() then
												v93 = nil
												fn45()
												return
											end
											if flag24 and not v96 and v88 and flag19 then
												for k in pairs(tbl26) do
													local v97 = obj2[k]
													if v97 and now2 - v97 <= v85[169] and k.Parent then
														local v98 = fn40(k)
														local ok = v85[139]
														if v98 and v98.plot and genv.iCollectPro_IsOwnPlot then
															local result
															ok, result = pcall(genv.iCollectPro_IsOwnPlot, v98.plot)
															ok = ok and result == true
														end
														if v98 and not ok and v98.slot == v88 and (v98.pos - position).Magnitude <= 13 then
															v93 = k
															pcall(firesignal, k.Triggered, localPlayer2)
															break
														end
													end
												end
											end
											if not v96 or flag23 then
												fn45()
												return
											end
											if v96 ~= v89 then
												fn45()
												v89 = v96
												v90 = now2
												fn42(v96, flag22 and 4 or n33, v85[164])
												return
											end
											if flag22 then
												fn42(v96, 4, 0)
												return
											end
											fn42(v96, n33, now2 - v90 < v85[64] and 0 or v85[91])
										end)
									end
								end
								do
									local players, runService, replicatedStorage, workspace_, localPlayer2, tbl25, fn39, fn40
									do
										local currentCamera
										do
											do
												local httpService
												do
													do
														local userInputService
														do
															do
																do
																	local tbl26 = {
																		Players = game:GetService(v85[152]),
																		RunService = game:GetService("RunService"),
																		UserInputService = game:GetService("UserInputService"),
																		ReplicatedStorage = game:GetService("ReplicatedStorage"),
																		TweenService = game:GetService("TweenService"),
																		HttpService = game:GetService("HttpService"),
																		Workspace = game:GetService("Workspace"),
																		Lighting = game:GetService(v85[117]),
																		GuiService = game:GetService("GuiService"),
																		TeleportService = game:GetService("TeleportService"),
																	}
																	players = tbl26.Players
																	runService = tbl26.RunService
																	userInputService = tbl26.UserInputService
																	replicatedStorage = tbl26.ReplicatedStorage
																	tweenService = tbl26.TweenService
																	httpService = tbl26.HttpService
																	workspace_ = tbl26.Workspace
																end
															end
															localPlayer2 = players.LocalPlayer
															playerGui = localPlayer2:WaitForChild("PlayerGui")
															do
																local v88 = nil
																iCollectProUIHost = function()
																	if v88 and v88.Parent ~= nil then return v88 end
																	if v88 == playerGui then return playerGui end
																	local tbl26 = {}
																	if type(gethui) == "function" then
																		local ok, result = pcall(gethui)
																		if ok and typeof(result) == "Instance" then tbl26[#tbl26 + 1] = result end
																	end
																	local ok, result = pcall(function()
																		return game:GetService("CoreGui")
																	end)
																	if ok and result then tbl26[#tbl26 + v85[64]] = result end
																	tbl26[#tbl26 + v85[64]] = playerGui
																	for _, v89 in ipairs(tbl26) do
																		if pcall(function()
																			local screenGui = Instance.new("ScreenGui")
																			screenGui.Name = "ICP_HostProbe"
																			screenGui.Enabled = false
																			screenGui.ResetOnSpawn = false
																			screenGui.Parent = v89
																			screenGui:Destroy()
																		end) then
																			v88 = v89
																			pcall(function()
																				print("[iCollectPro] UI host: " .. tostring(v89.ClassName) .. " (" .. tostring(v89.Name) .. ")")
																			end)
																			return v89
																		end
																	end
																	v88 = playerGui
																	return playerGui
																end
															end
														end
														do
															genv.iCollectPro_UIHost = iCollectProUIHost
															currentCamera = workspace_.CurrentCamera
															do
																local function fn41()
																	if not userInputService.TouchEnabled then return false end
																	if not userInputService.MouseEnabled then return true end
																	local ok, result = pcall(function()
																		return workspace.CurrentCamera.ViewportSize
																	end)
																	if ok and result and result.X > 0 and result.Y > 0 then
																		return math.min(result.X, result.Y) < 900
																	end
																	return v85[139]
																end
																v86 = fn41()
															end
														end
													end
													local tbl26 = {
														Positions = {
															AutoSteal = {
																X = v85[198],
																Y = 0.35,
																OffsetX = v85[164],
																OffsetY = v85[164],
															},
															TargetControls = {
																X = 0.26,
																Y = v85[23],
																OffsetX = 0,
																OffsetY = v85[164],
															},
															JobId = {
																X = 0.5,
																Y = v85[198],
																OffsetX = 0,
																OffsetY = v85[164],
															},
															CurrentTarget = {
																X = v85[140],
																Y = 1,
																OffsetX = 0,
																OffsetY = -220,
															},
														},
														MobileGuiScale = 0.5,
														UIScale = 1,
														HideJobId = false,
														BlockNames = false,
														UILocked = false,
														StealNearest = false,
														StealHighest = true,
														StealPriority = false,
														DefaultToNearest = false,
														DefaultToHighest = false,
														DefaultToPriority = v85[139],
														InstantSteal = false,
														ZoneInstantMode = false,
														PodiumESP = false,
														NextBase = false,
														CarpetSpeed = v85[139],
														FlySpeedValue = 195,
														CarpetTool = "Flying Carpet",
														AutoEquipBat = true,
														AutoEquipAny = true,
														AntiDie = true,
														BatTool = v85[73],
														BatRadius = 8,
														CarpetSpeedKey = "Q",
														InfiniteJump = true,
														AutoTPPriority = v85[192],
														WalkSpeedOn = false,
														WalkSpeedAutoOnSteal = true,
														WalkSpeedValue = 27,
														WalkSpeedKey = v85[159],
														DropKey = v85[112],
														ManualInvisKey = v85[112],
														HideNumbers = false,
														SeeThroughBase = false,
														SeeThruOpacity = 0.75,
														AutoLeaveOnSteal = false,
														XrayBase = false,
														ManualInvis = false,
														KickToPS = false,
														KickPSLink = "",
														PlayerESP = v85[192],
														NoPlayerCollide = true,
														QuickBarFolded = v85[139],
														Theme = "default",
													}
													DeepCopy = function(arg)
														if type(arg) ~= "table" then return arg end
														local tbl27 = {}
														for k, v88 in pairs(arg) do tbl27[k] = DeepCopy(v88) end
														return tbl27
													end
													MergeDefaults = function(arg, arg2)
														for k, v88 in pairs(arg2) do
															local v89 = v85[19]
															if type(v88) == v89 then
																local v90 = v85[19]
																if type(arg[k]) ~= v90 then
																	arg[k] = DeepCopy(v88)
																else
																	MergeDefaults(arg[k], v88)
																end
															elseif arg[k] == nil then
																arg[k] = v88
															end
														end
													end
													v87 = DeepCopy(tbl26)
													if isfile and isfile("iCollectPro.json") then
														pcall(function()
															local json = readfile("iCollectPro.json")
															if not json or json == "" then return end
															local data = httpService:JSONDecode(json)
															local v88 = v85[19]
															if type(data) ~= v88 then return end
															MergeDefaults(data, tbl26)
															v87 = data
														end)
													end
												end
												local flag18
												do
													local v88, v89, v90 = ipairs({
														v85[39],
														"AutoInvisOnSteal",
														"InvisAutoOnSteal",
														v85[168],
														"InvisAngle",
														"InvisDepth",
														"InvisKey",
														"PriorityList",
														v85[125],
														"StealLogSelf",
														"StealWebhook",
														"StealLogger",
														"PrivateServerLink",
														"PSJobId",
														v85[110],
														"AutoKickEnabled",
													})
													flag18 = false
													for _, v91 in v88, v89, v90 do
														if v87[v91] ~= nil then
															v87[v91] = nil
															flag18 = v85[192]
														end
													end
												end
												if tonumber(v87.FlySpeedBumped) ~= 195 then
													v87.FlySpeedBumped = 195
													v87.FlySpeedValue = v85[111]
													flag18 = true
												end
												v87.SeeThroughBase = false
												genv.ICOLLECTPRO_ANTIDIE_ON = v87.AntiDie ~= false
												tbl24 = {
													"carpet",
													v85[22],
													v85[106],
													"broom",
													"hover",
													"glider",
													"wing",
													v85[55],
													v85[104],
													"cloud",
													"board",
													v85[114],
													"sleigh",
													"sled",
													"waverider",
													"surf",
													v85[103],
													v85[128],
													"scooter",
													"magic",
													"mount",
												}
												do
													local flag19 = false
													local function fn41()
														genv.iCollectPro_FlySpeed = math.clamp(tonumber(v87.FlySpeedValue) or 195, v85[45], 195)
													end
													local function iCollectProSaveNow()
														fn41()
														if writefile then
															pcall(function()
																writefile("iCollectPro.json", httpService:JSONEncode(DeepCopy(v87)))
															end)
														end
													end
													fn41()
													fn32 = function()
														if not writefile or flag19 then return end
														flag19 = true
														task.delay(0.5, function()
															flag19 = v85[139]
															iCollectProSaveNow()
														end)
													end
													genv.iCollectPro_SaveNow = iCollectProSaveNow
													if flag18 then iCollectProSaveNow() end
												end
											end
											do
												local service2, fn41
												do
													do
														do
															local function iCollectProThemeName()
																return tostring(v87.Theme) == "halloween" and "halloween" or "default"
															end
															iCollectProThemeIsHalloween = function()
																local v88 = v85[1]
																return iCollectProThemeName() == v88
															end
															genv.iCollectPro_ThemeName = iCollectProThemeName
														end
													end
													genv.iCollectPro_ThemeIsHalloween = iCollectProThemeIsHalloween
													service = game:GetService(v85[153])
													tbl25 = {
														Background = Color3.fromRGB(16, 10, 26),
														Surface = Color3.fromRGB(26, 15, 42),
														SurfaceHighlight = Color3.fromRGB(48, v85[182], 76),
														Accent1 = Color3.fromRGB(168, v85[94], 247),
														Accent2 = Color3.fromRGB(124, 45, 190),
														TextPrimary = Color3.fromRGB(240, 240, 240),
														TextSecondary = Color3.fromRGB(140, 140, 150),
														Success = Color3.fromRGB(30, v85[28], 90),
														Error = Color3.fromRGB(255, 60, 80),
													}
													fn39 = function(arg)
														if not arg then return nil end
														local plots = workspace_:FindFirstChild("Plots") and workspace_.Plots:FindFirstChild(arg.plot)
														if plots then
															local animalPodiums = plots:FindFirstChild("AnimalPodiums")
															if animalPodiums then
																local v88 = animalPodiums:FindFirstChild(arg.slot)
																if v88 then
																	local v89 = v88:FindFirstChild(v85[177])
																	if v89 then
																		local spawn_ = v89:FindFirstChild("Spawn")
																		if spawn_ then return spawn_ end
																		return v89:FindFirstChildWhichIsA("BasePart") or v89
																	end
																end
															end
														end
														return nil
													end
													do
														local n33 = 1920
														local v88 = v85[160]
														service2 = game:GetService(v85[131])
														fn40 = function()
															local viewportSize = currentCamera and currentCamera.ViewportSize
															if not viewportSize or viewportSize.X < v85[64] or viewportSize.Y < 1 then
																return Vector2.new(1920, v88)
															end
															return viewportSize
														end
														deviceClass = function()
															local v89 = fn40()
															if not v86 then return "desktop", v89 end
															local n34 = math.min(v89.X, v89.Y)
															local n35 = math.max(v89.X, v89.Y)
															if (n34 > 0 and n35 / n34 or 1.78) < 1.75 and n34 >= 600 then return "tablet", v89 end
															return v85[175], v89
														end
														tbl17.DeviceClass = deviceClass
														fn41 = function()
															local v89, v90 = deviceClass()
															local min = math.min
															local n34 = math.min(v90.X, v90.Y) / v88
															local v91 = min(math.max(v90.X, v90.Y) / n33, n34)
															local n35
															if v89 == "phone" then
																n35 = math.clamp(v91 * 1.45, 0.55, 1)
															elseif v89 == "tablet" then
																n35 = math.clamp(v91 * 1.2, 0.6, 1)
															else
																n35 = math.clamp(v91, v85[92], 1)
															end
															return math.clamp(n35 * math.clamp(tonumber(v87.UIScale) or 1, 0.5, v85[36]), 0.3, v85[36]), v89, v90
														end
													end
												end
												do
													do
														local function fn42(arg, arg2, arg3)
															local scale = tbl17.MobileScaleObjects[arg]
															scale = scale and scale.Scale or 1
															if scale <= 0 then scale = 1 end
															local absoluteSize = arg.AbsoluteSize
															if absoluteSize.X < 1 or absoluteSize.Y < v85[64] then return arg2 end
															local n33 = absoluteSize.X / scale
															local n34 = absoluteSize.Y / scale
															if n33 < 1 or n34 < v85[64] then return arg2 end
															local n35 = math.min(arg3.X * 0.92 / n33, arg3.Y * 0.86 / n34)
															if n35 < arg2 then return math.max(math.min(arg2, n35), 0.35) end
															return arg2
														end
														local function fn43(arg)
															local v88 = fn40()
															local absoluteSize = arg.AbsoluteSize
															local absolutePosition = arg.AbsolutePosition
															if absoluteSize.X < 1 or absoluteSize.Y < 1 then return end
															local screenGui = arg:FindFirstAncestorWhichIsA("ScreenGui")
															screenGui = screenGui and screenGui.IgnoreGuiInset
															local n33 = 0
															if screenGui then
																local ok, result = pcall(function()
																	return service2:GetGuiInset()
																end)
																if ok and result then n33 = result.Y end
															end
															local n34 = v85[164]
															if absolutePosition.X + absoluteSize.X > v88.X - 6 then
																n34 = v88.X - 6 - (absolutePosition.X + absoluteSize.X)
															end
															if absolutePosition.X + n34 < 6 then n34 = 6 - absolutePosition.X end
															local n35 = 0
															if v88.Y - v85[167] < absolutePosition.Y + absoluteSize.Y then
																n35 = v88.Y - 6 - (absolutePosition.Y + absoluteSize.Y)
															end
															if absolutePosition.Y + n35 < n33 + 6 then n35 = n33 + 6 - absolutePosition.Y end
															if n34 ~= 0 or n35 ~= 0 then
																local position = arg.Position
																arg.Position = UDim2.new(position.X.Scale, position.X.Offset + n34, position.Y.Scale, position.Y.Offset + n35)
															end
														end
														fn33 = function(parent, arg)
															if not parent then return end
															local uiScale = parent:FindFirstChildOfClass("UIScale")
															if uiScale then uiScale:Destroy() end
															local uiScale2 = Instance.new("UIScale")
															uiScale2.Name = "ResponsiveScale"
															uiScale2.Parent = parent
															if arg then
																task.defer(function()
																	if not parent.Parent or not uiScale2.Parent then return end
																	local v88, v89, v90 = fn41()
																	uiScale2.Scale = fn42(parent, v88, v90)
																	pcall(fn43, parent)
																end)
																return
															end
															tbl17.MobileScaleObjects[parent] = uiScale2
															if tbl17.RefreshMobileScale then
																tbl17.RefreshMobileScale()
																task.spawn(function()
																	local now2 = os.clock()
																	while os.clock() - now2 < 1.5 do
																		if not parent.Parent or not uiScale2.Parent then return end
																		if parent.AbsoluteSize.X > v85[64] and parent.AbsoluteSize.Y > 1 then
																			tbl17.RefreshMobileScale()
																			task.defer(tbl17.RefreshMobileScale)
																			return
																		end
																		task.wait()
																	end
																	tbl17.RefreshMobileScale()
																end)
															end
														end
														tbl17.RefreshMobileScale = function()
															local v88, v89, v90 = fn41()
															tbl17.CurrentUIScale = v88
															tbl17.CurrentDeviceClass = v89
															for k, mobileScaleObject in pairs(tbl17.MobileScaleObjects) do
																if k and k.Parent and mobileScaleObject and mobileScaleObject.Parent == k then
																	mobileScaleObject.Scale = fn42(k, v88, v90)
																else
																	tbl17.MobileScaleObjects[k] = nil
																end
															end
															task.defer(function()
																for k in pairs(tbl17.MobileScaleObjects) do if k and k.Parent then pcall(fn43, k) end end
															end)
														end
														tbl17.RefreshMobileScaleFor = function(arg)
															if not arg or not arg.Parent then return end
															local v88 = tbl17.MobileScaleObjects[arg]
															if not v88 or v88.Parent ~= arg then return end
															local v89, v90, v91 = fn41()
															tbl17.CurrentUIScale = v89
															tbl17.CurrentDeviceClass = v90
															v88.Scale = fn42(arg, v89, v91)
															task.defer(function()
																if arg.Parent then pcall(fn43, arg) end
															end)
														end
													end
												end
											end
										end
										local connection = nil
										local function fn41()
											if connection then connection:Disconnect() end
											currentCamera = workspace_.CurrentCamera or currentCamera
											if currentCamera then
												connection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
													tbl17.RefreshMobileScale()
												end)
											end
											tbl17.RefreshMobileScale()
										end
										fn41()
										fn31(workspace_:GetPropertyChangedSignal("CurrentCamera"), fn41)
									end
									do
										local fn41
										do
											fn41 = function(arg, arg2, arg3)
												local v88 = nil
												local v89 = nil
												local position = nil
												local position2 = nil
												arg.InputBegan:Connect(function(input)
													if v87.UILocked then return end
													if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
														v88 = v85[192]
														position = input.Position
														position2 = arg2.Position
														input.Changed:Connect(function()
															if input.UserInputState == Enum.UserInputState.End then
																v88 = v85[139]
																if arg3 then
																	v87.Positions[arg3] = {
																		X = arg2.Position.X.Scale,
																		Y = arg2.Position.Y.Scale,
																		OffsetX = arg2.Position.X.Offset,
																		OffsetY = arg2.Position.Y.Offset,
																	}
																	fn32()
																end
															end
														end)
													end
												end)
												arg.InputChanged:Connect(function(input)
													if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
														v89 = input
													end
												end)
												fn31(service.InputChanged, function(arg4)
													if arg4 == v89 and v88 then
														local n33 = arg4.Position - position
														arg2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n33.X, position2.Y.Scale, position2.Y.Offset + n33.Y)
													end
												end)
											end
											do
												local function fn42(arg, text, arg2, arg3)
													local num = tonumber(arg2) or v85[169]
													local lmWjwEoSnCPj = playerGui:FindFirstChild("lMWjwEoSnCPj")
													if lmWjwEoSnCPj then lmWjwEoSnCPj:Destroy() end
													local screenGui = Instance.new("ScreenGui", playerGui)
													screenGui.Name = "lMWjwEoSnCPj"
													fn29(screenGui)
													screenGui.ResetOnSpawn = false
													screenGui.IgnoreGuiInset = true
													screenGui.DisplayOrder = 1001
													local instance = Instance.new(v85[68], screenGui)
													instance.Name = "Toast"
													instance.AnchorPoint = Vector2.new(0.5, 0)
													instance.Size = UDim2.new(v85[164], 300, 0, 72)
													instance.Position = UDim2.new(v85[140], 0, 0, 76)
													instance.BackgroundColor3 = Color3.fromRGB(20, 12, 34)
													instance.BackgroundTransparency = 1
													instance.BorderSizePixel = v85[164]
													Instance.new(v85[5], instance).CornerRadius = UDim.new(v85[164], 14)
													fn33(instance, true)
													local instance2 = Instance.new(v85[181], instance)
													instance2.Rotation = v85[129]
													instance2.Color = ColorSequence.new({
														ColorSequenceKeypoint.new(0, Color3.fromRGB(v85[199], v85[144], v85[189])),
														ColorSequenceKeypoint.new(1, Color3.fromRGB(14, v85[82], 24)),
													})
													local instance3 = Instance.new(v85[115], instance)
													instance3.Thickness = 1.2
													instance3.Color = Color3.fromRGB(v85[28], 70, v85[136])
													instance3.Transparency = 1
													instance3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
													local imageLabel = Instance.new("ImageLabel", instance)
													imageLabel.Name = v85[162]
													imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
													imageLabel.Position = UDim2.new(0.5, v85[164], v85[140], v85[70])
													imageLabel.Size = UDim2.new(v85[64], 26, v85[64], 26)
													imageLabel.BackgroundTransparency = v85[64]
													imageLabel.Image = "rbxassetid://6014261993"
													imageLabel.ImageColor3 = Color3.new(0, 0, 0)
													imageLabel.ImageTransparency = v85[64]
													imageLabel.ScaleType = Enum.ScaleType.Slice
													imageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
													imageLabel.ZIndex = 0
													local textLabel = Instance.new("TextLabel", instance)
													textLabel.Name = v85[124]
													textLabel.Size = UDim2.new(1, -24, 0, 20)
													textLabel.Position = UDim2.new(v85[164], 12, 0, 9)
													textLabel.BackgroundTransparency = 1
													textLabel.Text = arg:upper()
													textLabel.Font = Enum.Font.GothamBlack
													textLabel.TextSize = 15
													textLabel.TextColor3 = Color3.fromRGB(v85[173], 232, 255)
													textLabel.TextXAlignment = Enum.TextXAlignment.Center
													textLabel.TextTruncate = Enum.TextTruncate.AtEnd
													textLabel.TextTransparency = 1
													textLabel.ZIndex = 2
													local frame = Instance.new("Frame", instance)
													frame.Name = "Rule"
													frame.AnchorPoint = Vector2.new(v85[140], 0)
													frame.Position = UDim2.new(0.5, 0, v85[164], 32)
													frame.Size = UDim2.new(0, 96, 0, 1)
													frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
													frame.BackgroundTransparency = 1
													frame.BorderSizePixel = v85[164]
													frame.ZIndex = 2
													local textLabel2 = Instance.new("TextLabel", instance)
													textLabel2.Name = v85[97]
													textLabel2.Size = UDim2.new(v85[64], -24, 0, 30)
													textLabel2.Position = UDim2.new(0, 12, 0, 39)
													textLabel2.BackgroundTransparency = 1
													textLabel2.Text = text
													textLabel2.Font = Enum.Font.GothamBold
													textLabel2.TextSize = 12
													textLabel2.TextWrapped = true
													textLabel2.TextColor3 = Color3.fromRGB(216, 190, 255)
													textLabel2.TextXAlignment = Enum.TextXAlignment.Center
													textLabel2.TextYAlignment = Enum.TextYAlignment.Top
													textLabel2.TextTransparency = 1
													textLabel2.ZIndex = 2
													task.spawn(function()
														pcall(function()
															local v88 = iCollectProUIHost()
															local instance4 = Instance.new(v85[98])
															instance4.Name = "__ICPToast"
															instance4.SoundId = "rbxassetid://139424207951815"
															instance4.Volume = 1
															instance4.Parent = v88
															instance4:Play()
															game:GetService("Debris"):AddItem(instance4, 6)
														end)
													end)
													local tweenInfo3 = TweenInfo.new(v85[146], Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
													tweenService:Create(instance, tweenInfo3, { BackgroundTransparency = v85[164] }):Play()
													tweenService:Create(imageLabel, tweenInfo3, { ImageTransparency = v85[49] }):Play()
													tweenService:Create(instance3, tweenInfo3, { Transparency = 0.4 }):Play()
													tweenService:Create(frame, tweenInfo3, { BackgroundTransparency = 0.15 }):Play()
													tweenService:Create(textLabel, tweenInfo3, { TextTransparency = 0 }):Play()
													tweenService:Create(textLabel2, tweenInfo3, { TextTransparency = 0 }):Play()
													task.delay(num, function()
														if not screenGui.Parent then
															if arg3 then pcall(arg3) end
															return
														end
														local tweenInfo4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
														tweenService:Create(instance, tweenInfo4, { BackgroundTransparency = v85[64] }):Play()
														tweenService:Create(imageLabel, tweenInfo4, { ImageTransparency = 1 }):Play()
														tweenService:Create(instance3, tweenInfo4, { Transparency = 1 }):Play()
														tweenService:Create(frame, tweenInfo4, { BackgroundTransparency = 1 }):Play()
														tweenService:Create(textLabel, tweenInfo4, { TextTransparency = 1 }):Play()
														local tween = tweenService:Create(textLabel2, tweenInfo4, { TextTransparency = 1 })
														tween:Play()
														tween.Completed:Wait()
														if screenGui.Parent then screenGui:Destroy() end
														if arg3 then pcall(arg3) end
													end)
												end
												local tbl26 = {}
												local flag18 = false
												local fn43 = nil
												fn43 = function()
													if flag18 then return end
													local v88 = table.remove(tbl26, 1)
													if not v88 then return end
													flag18 = v85[192]
													if not pcall(fn42, v88[v85[64]], v88[2], v88[3], function()
														flag18 = false
														fn43()
													end) then
														flag18 = false
													end
												end
												fn34 = function(arg, arg2, arg3)
													local v88 = tbl26[#tbl26]
													if v88 and v88[1] == arg and v88[2] == arg2 then return end
													tbl26[#tbl26 + 1] = { arg, arg2, arg3 }
													while v85[89] < #tbl26 do table.remove(tbl26, v85[64]) end
													fn43()
												end
											end
										end
										task.spawn(function()
											task.wait(2)
											pcall(fn34, "NEW TP SERVER !!", "JOIN DISCORD.GG/FREESCRIPTS", 15)
										end)
										do
											local iCollectProCaps = {}
											local tbl26 = {
												{
													"fireproximityprompt",
													"Instant Steal / auto grab - the whole point",
													true,
												},
												{
													v85[29],
													"the re-execute guard; two copies of the hub can run at once",
													v85[139],
												},
												{
													"gethui",
													"UI hiding; the panels fall back to PlayerGui and still work",
													v85[139],
												},
												{
													"setthreadidentity",
													"reading plot channels; the target list may stay empty",
													false,
												},
												{
													"getconnections",
													"Anti Bee / Anti Disco Ball controller kill",
													false,
												},
												{
													"sethiddenproperty",
													"FPS Boost cannot force Lighting.Technology",
													false,
												},
												{ "setfflag", v85[30], false },
												{
													"getfflag",
													"same - and without it the flags are not written at all",
													false,
												},
												{
													"writefile",
													"settings are not saved between runs",
													false,
												},
												{
													"readfile",
													"saved settings are not loaded",
													false,
												},
												{ v85[61], "saved settings are not loaded", false },
												{
													"setclipboard",
													"COPY job id, and the FastFlag export",
													false,
												},
												{
													"firesignal",
													"the (disabled) Admin Panel only",
													false,
												},
											}
											local tbl27 = {}
											local tbl28 = {}
											for _, v88 in ipairs(tbl26) do
												local v89 = v88[1]
												local flag18 = type(rawget(genv, v89)) == "function"
												if not flag18 then
													local ok, result = pcall(getfenv, 0)
													ok = ok and type(result) == "table"
													if ok then
														local v90 = v85[34]
														ok = type(result[v89]) == v90
													end
													if ok then flag18 = v85[192] end
												end
												iCollectProCaps[v89] = flag18
												if not flag18 then
													tbl27[#tbl27 + 1] = v89
													if v88[3] then tbl28[#tbl28 + 1] = { v89, v88[v85[67]] } end
												end
											end
											local executor = "unknown executor"
											pcall(function()
												if type(identifyexecutor) == "function" then
													local v88, v89 = identifyexecutor()
													executor = tostring(v88) .. (v89 and " " .. tostring(v89) or "")
												end
											end)
											iCollectProCaps.executor = executor
											local function iCollectProCapReport()
												print("[iCollectPro] executor: " .. executor)
												if #tbl27 == 0 then
													print("[iCollectPro] capabilities: all present")
												else
													print("[iCollectPro] MISSING: " .. table.concat(tbl27, ", "))
													for _, v88 in ipairs(tbl26) do
														if iCollectProCaps[v88[v85[64]]] == false then
															print(("   %-22s -> %s"):format(v88[1], v88[v85[67]]))
														end
													end
												end
												return iCollectProCaps
											end
											genv.iCollectPro_Caps = iCollectProCaps
											genv.iCollectPro_CapReport = iCollectProCapReport
											pcall(iCollectProCapReport)
											if v85[164] < #tbl28 then
												task.spawn(function()
													task.wait(v85[169])
													for _, v88 in ipairs(tbl28) do
														local v89 = v85[186]
														local v90 = v88[2]
														local v91 = v85[142]
														pcall(fn34, "EXECUTOR MISSING " .. v88[1]:upper(), v89 .. v90:upper() .. " - TRY ANOTHER ONE", v91)
														task.wait(v85[64])
													end
												end)
											end
										end
										task.spawn(function()
											local fn42, fn43, v88, fn44, fn45
											do
												local tbl26 = {}
												local function fn46(arg)
													return setmetatable({}, { __index = function(arg2, arg3)
														local v89 = tbl26[arg]
														if v89 == nil then return nil end
														return v89[arg3]
													end })
												end
												local module = nil
												task.spawn(function()
													local packages = replicatedStorage:WaitForChild("Packages", 60)
													if packages then
														local synchronizer = packages:WaitForChild("Synchronizer", 60)
														if synchronizer then
															pcall(function()
																module = require(synchronizer)
															end)
														end
													end
													local datas = replicatedStorage:WaitForChild("Datas", 60)
													if datas then
														for _, v89 in ipairs({ "Animals", "Mutations", "Traits" }) do
															local v90 = datas:WaitForChild(v89, 60)
															if v90 then
																local ok, result = pcall(require, v90)
																if ok then
																	local v91 = v85[19]
																	ok = type(result) == v91
																end
																if ok then tbl26[v89] = result end
															end
														end
													end
													if genv.iCollectPro_RescanPlots then pcall(genv.iCollectPro_RescanPlots) end
												end)
												fn42 = function(arg)
													if not arg then return v85[139] end
													if typeof(arg) == "Instance" then return arg == localPlayer2 end
													if type(arg) == "string" then return arg == localPlayer2.Name end
													return false
												end
												fn43 = function(arg)
													local ok, result = pcall(function()
														local v89 = getthreadidentity and getthreadidentity() or nil
														if setthreadidentity then setthreadidentity(8) end
														local tableFromChannel = module:GetTableFromChannel(arg)
														if v89 and setthreadidentity then pcall(setthreadidentity, v89) end
														return tableFromChannel
													end)
													if ok and type(result) == "table" then return result end
													return nil
												end
												v88 = fn46(v85[72])
												local Mutations = fn46("Mutations")
												local Traits = fn46("Traits")
												local tbl27 = {
													"",
													"K",
													v85[122],
													v85[18],
													"T",
													"Qa",
													"Qi",
													v85[31],
													"Sp",
													"Oc",
													"No",
													"Dc",
													"Ud",
													"Dd",
													"Td",
													"Qad",
													"Qid",
													v85[187],
													v85[69],
													v85[37],
													"Nod",
													"Vg",
													"Uvg",
													"Dvg",
													"Tvg",
												}
												fn44 = function(arg, arg2)
													local n33 = arg2 or 1
													local n34 = math.abs(arg)
													local n35 = math.floor(math.log(math.max(1, n34), v85[77]))
													local str6 = tbl27[n35 + 1] or "e+" .. n35
													return ("%." .. n33 .. v85[59]):format(math.floor(arg * (10 ^ n33 / 1000 ^ n35)) / 10 ^ n33):gsub("%.?0+$", "") .. str6
												end
												fn45 = function(arg, arg2, arg3)
													local v89 = v88[arg]
													if not v89 then return v85[164] end
													local generation = v89.Generation or v89.Price * 0.1
													local flag18 = arg2 and arg2 ~= "None"
													local n33 = 1
													if flag18 then
														local v90 = Mutations[arg2]
														if v90 and v90.Modifier then n33 = 1 + v90.Modifier end
													end
													local flag19 = false
													if type(arg3) == "table" then
														for _, v90 in ipairs(arg3) do
															if v90 == v85[32] then
																flag19 = v85[192]
															else
																local v91 = Traits[v90]
																if v91 and v91.MultiplierModifier then n33 += v91.MultiplierModifier end
															end
														end
													end
													local v90 = math.round(generation * n33)
													if flag19 then v90 = math.round(v90 * 0.5) end
													return v90
												end
											end
											local flag18 = true
											if v87.DefaultToPriority and v87.DefaultToHighest then v87.DefaultToHighest = false end
											if v87.DefaultToPriority and v87.DefaultToNearest then v87.DefaultToNearest = false end
											if v87.DefaultToHighest and v87.DefaultToNearest then v87.DefaultToNearest = false end
											if not v87.DefaultToPriority and not v87.DefaultToHighest and not v87.DefaultToNearest then
												v87.DefaultToHighest = true
											end
											local stealNearest = false
											if v87.DefaultToNearest then
												stealNearest = true
												v87.StealNearest = true
												v87.StealHighest = false
												v87.StealPriority = v85[139]
												v87.AutoTPPriority = true
											elseif v87.DefaultToHighest then
												v87.StealHighest = true
												v87.StealNearest = v85[139]
												v87.StealPriority = false
												v87.AutoTPPriority = v85[139]
											elseif v87.DefaultToPriority then
												v87.StealPriority = true
												v87.StealNearest = false
												v87.StealHighest = v85[139]
												v87.AutoTPPriority = true
											else
												stealNearest = v87.StealNearest
												if v87.InstantSteal == nil then v87.InstantSteal = false end
												if v87.StealPriority then
													v87.AutoTPPriority = true
												elseif v87.StealNearest then
													v87.AutoTPPriority = true
												elseif v87.StealHighest then
													v87.AutoTPPriority = v85[139]
												end
											end
											local stealHighest = false
											local stealPriority = false
											v87.StealHighest = v85[139]
											v87.StealPriority = false
											if not stealNearest then
												stealNearest = true
												v87.StealNearest = true
											end
											v87.AutoTPPriority = v85[192]
											local instantSteal = v87.InstantSteal == true
											genv.NEAREST_INSTANT_MODE = v87.InstantSteal == true and v87.ZoneInstantMode == true
											genv.INSTANT_ANY = v87.InstantSteal == v85[192]
											local flag19 = false
											local flag20 = false
											local n33 = 1
											local uid = nil
											local v89 = nil
											local allAnimalsCache = {}
											local fn46 = function() flag18 = stealNearest == v85[192] or stealHighest == true or stealPriority == true end
											fn46()
											local obj = setmetatable({}, { __mode = v85[93] })
											local obj2 = setmetatable({}, { __mode = "v" })
											local tween = nil
											local v90 = nil
											local tbl26 = {}
											local fn47 = function(arg)
												if not arg or not arg.plot then return false end
												local iCollectProIsOwnPlot = genv.iCollectPro_IsOwnPlot
												if type(iCollectProIsOwnPlot) == "function" then
													local ok, result = pcall(iCollectProIsOwnPlot, arg.plot)
													if ok then return result == true end
												end
												local v91 = workspace_:FindFirstChild(v85[2])
												if not v91 then return v85[139] end
												local v92 = v91:FindFirstChild(arg.plot)
												if not v92 then return false end
												local v93 = fn43(v92.Name)
												if v93 then return fn42(v93.Owner) end
												return false
											end
											do
												local tbl27 = {}
												local tbl28 = {}
												genv.iCollectPro_IsOwnPlot = function(arg)
													if not arg then return false end
													local str6 = tostring(arg)
													local now2 = os.clock()
													if tbl28[str6] and now2 - tbl28[str6] < v85[70] then return tbl27[str6] == true end
													local ok, result = pcall(function()
														local v91 = fn43(str6)
														local flag21 = v91 ~= nil
														local flag22
														if flag21 then
															local v92 = v85[192]
															flag22 = fn42(v91.Owner) == v92
														else
															flag22 = flag21
														end
														return flag22
													end)
													local flag21 = ok and result == true
													local v91 = tbl28
													tbl27[str6] = flag21
													v91[str6] = now2
													return flag21
												end
											end
											do
												local tbl27 = {}
												local tbl28 = {}
												genv.iCollectPro_PlotOwnerName = function(arg)
													if not arg then return nil end
													local str6 = tostring(arg)
													local now2 = os.clock()
													if tbl28[str6] and now2 - tbl28[str6] < v85[70] then return tbl27[str6] end
													local ok, result = pcall(function()
														local v91 = fn43(str6)
														local owner = v91 and v91.Owner
														if not owner then return nil end
														local name = typeof(owner) == "Instance" and owner.Name or tostring(owner)
														if name == "" then return nil end
														local v92 = players:FindFirstChild(name)
														if v92 and v92.DisplayName and v92.DisplayName ~= "" then return v92.DisplayName end
														return name
													end)
													result = ok and result or nil
													local v91 = tbl28
													tbl27[str6] = result
													v91[str6] = now2
													return result
												end
											end
											genv.iCollectPro_PlotAnimalCount = function(arg)
												if not arg then return nil end
												local ok, result = pcall(function()
													local v91 = fn43(tostring(arg))
													if type(v91) ~= "table" or type(v91.AnimalList) ~= "table" then return nil end
													local n34 = 0
													for _, v92 in pairs(v91.AnimalList) do if type(v92) == "table" then n34 += v85[64] end end
													return n34
												end)
												return ok and result or nil
											end
											genv.iCollectPro_MyPlotAnimalCount = function()
												local iCollectProMyPlot = genv.iCollectPro_MyPlot and genv.iCollectPro_MyPlot()
												if not iCollectProMyPlot then return nil end
												return genv.iCollectPro_PlotAnimalCount(iCollectProMyPlot.Name)
											end
											genv.iCollectPro_MyPlot = function()
												local plots = workspace:FindFirstChild("Plots")
												if not plots then return nil end
												local localPlayer3 = players.LocalPlayer
												if localPlayer3 then
													for _, child in ipairs(plots:GetChildren()) do
														local ok, result = pcall(function()
															local plotSign = child:FindFirstChild("PlotSign")
															plotSign = plotSign and plotSign:FindFirstChild("YourBase")
															return plotSign ~= nil and plotSign.Enabled == true
														end)
														if ok and result then return child end
													end
													for _, child in ipairs(plots:GetChildren()) do
														local ok, result = pcall(genv.iCollectPro_IsOwnPlot, child.Name)
														if ok and result == true then return child end
													end
													local str6 = tostring(localPlayer3.Name)
													local str7 = tostring(localPlayer3.DisplayName or localPlayer3.Name)
													local v91, v92, v93 = ipairs(plots:GetChildren())
													local n34 = 0
													local v94 = nil
													for _, v95 in v91, v92, v93 do
														local ok, result = pcall(genv.iCollectPro_PlotOwnerName, v95.Name)
														if ok and result and (result == str6 or result == str7) then
															n34 += 1
															v94 = v95
														end
													end
													if n34 == v85[64] then return v94 end
													return nil
												end
												local v91 = v85[180]
												if n27(v85[80]) <= v91 then return nil end
												while true do
												end
											end
											genv.iCollectPro_MyPlotWait = function(arg)
												local n34 = os.clock() + (tonumber(arg) or 8)
												while true do
													local v91 = genv.iCollectPro_MyPlot()
													if v91 then
														return v91
													else
														task.wait(v85[123])
														if os.clock() > n34 then break end
													end
												end
												return nil
											end
											genv.iCollectPro_MyPlotSpot = function(arg)
												local v91 = arg or genv.iCollectPro_MyPlot()
												if not v91 then return nil end
												local deliveryHitbox = v91:FindFirstChild("DeliveryHitbox")
												if deliveryHitbox and deliveryHitbox:IsA("BasePart") then
													return deliveryHitbox.Position + Vector3.new(0, 3, v85[164])
												end
												local v92 = v91:FindFirstChild(v85[53])
												if v92 and v92:IsA("BasePart") then return v92.Position + Vector3.new(0, 3, 0) end
												for _, v93 in ipairs({ "Spawn", "SpawnPoint", v85[90], "Base", v85[24] }) do
													local v94 = v91:FindFirstChild(v93, true)
													if v94 and v94:IsA("BasePart") then return v94.Position + Vector3.new(v85[164], 3, 0) end
												end
												local ok, result = pcall(function()
													return v91:GetPivot().Position + Vector3.new(0, 3, v85[164])
												end)
												if ok and result then return result end
												return nil
											end
											local fn48, fn49
											do
												local v91 = nil
												local n34 = -1
												fn48 = function()
													local n35 = -v85[64]
													v91 = nil
													n34 = n35
												end
												fn49 = function()
													local now2 = os.clock()
													if v91 and now2 - n34 < 0.1 then return v91 end
													local tbl27 = {}
													for _, v92 in ipairs(allAnimalsCache) do
														if v92.genValue >= v85[64] and not fn47(v92) then
															table.insert(tbl27, {
																petName = v92.name,
																mpsText = v92.genText,
																mpsValue = v92.genValue,
																owner = v92.owner,
																plot = v92.plot,
																slot = v92.slot,
																uid = v92.uid,
																mutation = v92.mutation,
																animalData = v92,
															})
														end
													end
													v91 = tbl27
													n34 = now2
													return tbl27
												end
											end
											local v91 = iCollectProUIHost()
											local cjPcVLFpwxgI = v91 and v91:FindFirstChild("cJPcVLFpwxgI")
											if cjPcVLFpwxgI then cjPcVLFpwxgI:Destroy() end
											local cjPcVLFpwxgI2 = playerGui and playerGui:FindFirstChild("cJPcVLFpwxgI")
											if cjPcVLFpwxgI2 then cjPcVLFpwxgI2:Destroy() end
											local brXgmsaEVfze = playerGui:FindFirstChild("bRXgmsaEVfze")
											if brXgmsaEVfze then brXgmsaEVfze:Destroy() end
											local tbl27, textLabel, instance, instance2
											do
												local screenGui = Instance.new("ScreenGui")
												screenGui.Name = "bRXgmsaEVfze"
												fn29(screenGui)
												screenGui.ResetOnSpawn = v85[139]
												screenGui.IgnoreGuiInset = v85[192]
												screenGui.DisplayOrder = v85[17]
												screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
												screenGui.Parent = playerGui
												tbl27 = {
													PANEL = Color3.fromRGB(28, 16, 46),
													PANEL2 = Color3.fromRGB(48, 26, 76),
													TEXT = Color3.fromRGB(240, v85[16], 255),
													STROKE = Color3.fromRGB(150, v85[141], v85[136]),
													GLOW = Color3.fromRGB(168, v85[94], 247),
													TRACK = Color3.fromRGB(34, 20, 54),
													TRACK2 = Color3.fromRGB(v85[57], 26, v85[101]),
													FILL1 = Color3.fromRGB(150, 70, 235),
													FILL2 = Color3.fromRGB(v85[126], v85[28], 255),
												}
												local instance3 = Instance.new(v85[68], screenGui)
												instance3.Name = "CurrentTargetHUD"
												instance3.AnchorPoint = Vector2.new(0.5, 1)
												instance3.Size = UDim2.new(0, 230, 0, 46)
												instance3.Position = UDim2.new(0.5, 0, 1, -220)
												instance3.BackgroundColor3 = tbl27.PANEL
												instance3.BackgroundTransparency = 0.02
												instance3.BorderSizePixel = 0
												instance3.ZIndex = v85[141]
												local currentTarget = v87.Positions and v87.Positions.CurrentTarget
												if currentTarget then
													instance3.Position = UDim2.new(currentTarget.X or 0.5, currentTarget.OffsetX or v85[164], currentTarget.Y or 1, currentTarget.OffsetY or -v85[48])
												end
												instance3.Active = v85[192]
												fn41(instance3, instance3, "CurrentTarget")
												fn33(instance3)
												Instance.new("UICorner", instance3).CornerRadius = UDim.new(0, v85[142])
												local instance4 = Instance.new(v85[115], instance3)
												instance4.Color = tbl27.STROKE
												instance4.Thickness = v85[64]
												instance4.Transparency = 0.35
												local uiStroke = Instance.new("UIStroke", instance3)
												uiStroke.Color = tbl27.GLOW
												uiStroke.Thickness = 3
												uiStroke.Transparency = 0.84
												uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
												local imageLabel = Instance.new("ImageLabel", instance3)
												imageLabel.Name = "Shadow"
												imageLabel.AnchorPoint = Vector2.new(v85[140], 0.5)
												imageLabel.Position = UDim2.new(0.5, v85[164], 0.5, 1)
												imageLabel.Size = UDim2.new(1, 20, 1, 20)
												imageLabel.BackgroundTransparency = 1
												imageLabel.Image = "rbxassetid://6014261993"
												imageLabel.ImageColor3 = Color3.new(0, v85[164], 0)
												imageLabel.ImageTransparency = 0.72
												imageLabel.ScaleType = Enum.ScaleType.Slice
												imageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
												imageLabel.ZIndex = 69
												textLabel = Instance.new("TextLabel", instance3)
												textLabel.Name = "TargetName"
												textLabel.Size = UDim2.new(1, -12, 0, v85[178])
												textLabel.Position = UDim2.fromOffset(v85[167], 3)
												textLabel.BackgroundTransparency = 1
												textLabel.Font = Enum.Font.GothamBold
												textLabel.TextSize = 11
												textLabel.TextColor3 = tbl27.TEXT
												textLabel.TextXAlignment = Enum.TextXAlignment.Center
												textLabel.TextTruncate = Enum.TextTruncate.AtEnd
												textLabel.ZIndex = 72
												textLabel.Text = v85[190]
												local instance5 = Instance.new(v85[68], instance3)
												instance5.Name = "ProgressBg"
												instance5.Size = UDim2.new(1, -10, 0, 18)
												instance5.Position = UDim2.fromOffset(5, 18)
												instance5.BackgroundColor3 = tbl27.TRACK
												instance5.BorderSizePixel = 0
												instance5.ZIndex = v85[101]
												Instance.new("UICorner", instance5).CornerRadius = UDim.new(0, 8)
												local uiStroke2 = Instance.new("UIStroke", instance5)
												uiStroke2.Color = tbl27.STROKE
												uiStroke2.Thickness = 1
												uiStroke2.Transparency = 0.55
												local instance6 = Instance.new(v85[68], instance5)
												instance6.Name = "InnerTrack"
												instance6.Size = UDim2.new(1, -2, v85[64], -v85[67])
												instance6.Position = UDim2.fromOffset(v85[64], 1)
												instance6.BackgroundColor3 = tbl27.TRACK2
												instance6.BackgroundTransparency = 0.15
												instance6.BorderSizePixel = 0
												instance6.ZIndex = 72
												Instance.new("UICorner", instance6).CornerRadius = UDim.new(v85[164], 7)
												instance = Instance.new(v85[68], instance5)
												instance.Name = v85[71]
												instance.Size = UDim2.new(0, v85[164], 1, 0)
												instance.BackgroundColor3 = tbl27.FILL1
												instance.BorderSizePixel = 0
												instance.ZIndex = v85[118]
												Instance.new("UICorner", instance).CornerRadius = UDim.new(0, 8)
												local colorSequence = ColorSequence.new
												local new = ColorSequenceKeypoint.new
												local fILL2 = tbl27.FILL2
												Instance.new("UIGradient", instance).Color = colorSequence({ ColorSequenceKeypoint.new(0, tbl27.FILL1), new(1, fILL2) })
												local uiStroke3 = Instance.new("UIStroke", instance)
												uiStroke3.Color = Color3.fromRGB(v85[11], 160, 255)
												uiStroke3.Thickness = v85[64]
												uiStroke3.Transparency = 0.45
												instance2 = Instance.new(v85[8], instance5)
											end
											instance2.Name = v85[43]
											instance2.Size = UDim2.new(1, 0, 1, 0)
											instance2.BackgroundTransparency = v85[64]
											instance2.Font = Enum.Font.GothamBold
											instance2.TextSize = 12
											instance2.TextColor3 = tbl27.TEXT
											instance2.TextStrokeTransparency = 0.7
											instance2.TextXAlignment = Enum.TextXAlignment.Center
											instance2.ZIndex = 74
											instance2.Text = "0%"
											local v92 = instance
											local kzBUJxAKwhtf = playerGui:FindFirstChild("kzBUJxAKwhtf")
											if kzBUJxAKwhtf then kzBUJxAKwhtf:Destroy() end
											local frame
											local screenGui = Instance.new("ScreenGui")
											screenGui.Name = "kzBUJxAKwhtf"
											fn29(screenGui)
											screenGui.ResetOnSpawn = v85[139]
											screenGui.IgnoreGuiInset = true
											screenGui.DisplayOrder = 999
											screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
											screenGui.Parent = v91
											frame = Instance.new("Frame", screenGui)
											frame.Name = v85[150]
											frame.AutomaticSize = Enum.AutomaticSize.Y
											local n34 = v86 and 1.3 or 1
											local v93 = v85[164]
											frame.Size = UDim2.new(v85[164], math.floor(240 * n34), v93, 0)
											do
												local x = v87.Positions.TargetControls and v87.Positions.TargetControls.X
												local y = v87.Positions.TargetControls and v87.Positions.TargetControls.Y
												local offsetX = v87.Positions.TargetControls and v87.Positions.TargetControls.OffsetX
												local offsetY = v87.Positions.TargetControls and v87.Positions.TargetControls.OffsetY
												if x == nil or y == nil then
													x = v87.Positions.AutoSteal.X + 0.24
													y = v87.Positions.AutoSteal.Y
													if x > 0.76 then x = math.max(0.02, v87.Positions.AutoSteal.X - 0.24) end
													if y > 0.72 then y = 0.72 end
													v87.Positions.TargetControls = { X = x, Y = y }
												end
												frame.Position = UDim2.new(x or v85[66], offsetX or 15, y or v85[23], offsetY or 0)
											end
											frame.BackgroundColor3 = Color3.fromRGB(v85[3], v85[142], v85[81])
											frame.BackgroundTransparency = v85[164]
											frame.BorderSizePixel = 0
											frame.ClipsDescendants = false
											frame.ZIndex = v85[12]
											fn33(frame)
											local tbl28 = { panels = { frame } }
											genv.iCollectPro_TogglePanels = function(visible)
												if visible == nil then visible = not (frame.Visible == v85[192]) end
												visible = visible and true or false
												for _, panel in ipairs(tbl28.panels) do if panel and panel.Parent then panel.Visible = visible end end
												return visible
											end
											genv.iCollectPro_PanelsVisible = function() return frame.Visible == true end
											if v86 then
												local parent = frame.Parent
												local v94 = frame
												local textButton = Instance.new("TextButton")
												textButton.Name = v85[179]
												textButton.AnchorPoint = Vector2.new(1, 0.5)
												textButton.Position = UDim2.new(v85[64], -14, 0.5, 0)
												textButton.Size = UDim2.fromOffset(52, 52)
												textButton.BackgroundColor3 = tbl25.Accent2
												textButton.BorderSizePixel = 0
												textButton.AutoButtonColor = false
												textButton.Text = ""
												textButton.ZIndex = 150
												textButton.Parent = parent
												Instance.new("UICorner", textButton).CornerRadius = UDim.new(1, 0)
												local uiStroke = Instance.new("UIStroke", textButton)
												uiStroke.Color = tbl25.Accent1
												uiStroke.Thickness = 1.4
												uiStroke.Transparency = 0.25
												uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
												local instance3 = Instance.new(v85[181], textButton)
												instance3.Rotation = v85[129]
												instance3.Color = ColorSequence.new({
													ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 70, 235)),
													ColorSequenceKeypoint.new(1, Color3.fromRGB(96, 34, 158)),
												})
												local imageLabel = Instance.new("ImageLabel", textButton)
												imageLabel.AnchorPoint = Vector2.new(0.5, v85[140])
												imageLabel.Position = UDim2.new(0.5, v85[164], 0.5, 3)
												imageLabel.Size = UDim2.new(1, 22, 1, v85[144])
												imageLabel.BackgroundTransparency = 1
												imageLabel.Image = "rbxassetid://6014261993"
												imageLabel.ImageColor3 = Color3.new(0, v85[164], v85[164])
												imageLabel.ImageTransparency = 0.6
												imageLabel.ScaleType = Enum.ScaleType.Slice
												imageLabel.SliceCenter = Rect.new(49, 49, 450, v85[154])
												imageLabel.ZIndex = 149
												local tbl29 = {}
												for i = 1, v85[70] do
													local frame2 = Instance.new("Frame", textButton)
													frame2.AnchorPoint = Vector2.new(0.5, 0.5)
													frame2.Position = UDim2.new(v85[140], 0, v85[140], (i - 2) * v85[82])
													frame2.Size = UDim2.fromOffset(22, v85[70])
													frame2.BackgroundColor3 = tbl25.TextPrimary
													frame2.BorderSizePixel = 0
													frame2.ZIndex = v85[4]
													Instance.new(v85[5], frame2).CornerRadius = UDim.new(1, v85[164])
													tbl29[i] = frame2
												end
												fn33(textButton)
												local function fn50()
													local visible = v94.Visible
													for i, v95 in ipairs(tbl29) do
														v95.Position = UDim2.new(0.5, 0, 0.5, visible and (i - 2) * 8 or 0)
														v95.BackgroundTransparency = not visible and i ~= 2 and v85[64] or 0
													end
													uiStroke.Transparency = visible and 0.25 or v85[188]
												end
												fn50()
												textButton.MouseButton1Click:Connect(function()
													local visible = not v94.Visible
													for _, panel in ipairs(tbl28.panels) do if panel and panel.Parent then panel.Visible = visible end end
													fn50()
												end)
											end
											local tbl29 = {
												BG = Color3.fromRGB(20, 12, 34),
												SURF = Color3.fromRGB(28, 16, 46),
												SURF2 = Color3.fromRGB(v85[79], 26, 76),
												TEXT = Color3.fromRGB(v85[173], v85[16], v85[149]),
												DIM = Color3.fromRGB(155, v85[15], v85[126]),
												AQUA = Color3.fromRGB(v85[163], 85, 247),
												AQUA2 = Color3.fromRGB(124, 45, v85[108]),
												AQUA_STROKE = Color3.fromRGB(150, 70, 230),
												GREEN1 = Color3.fromRGB(18, 88, 58),
												GREEN2 = Color3.fromRGB(21, 120, v85[52]),
												GREEN_STROKE = Color3.fromRGB(v85[189], 185, 120),
												OFF_BG = Color3.fromRGB(48, v85[182], v85[135]),
												OFF_TEXT = Color3.fromRGB(v85[33], 110, 180),
											}
											local createUICorner2 = function(parent, arg)
												local uiCorner = Instance.new("UICorner")
												uiCorner.CornerRadius = UDim.new(v85[164], arg)
												uiCorner.Parent = parent
												return uiCorner
											end
											local createUIStroke2 = function(parent, color, thickness, transparency)
												local uiStroke = Instance.new("UIStroke")
												uiStroke.Color = color
												uiStroke.Thickness = thickness or 1
												uiStroke.Transparency = transparency or 0
												uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
												uiStroke.Parent = parent
												return uiStroke
											end
											local fn50 = function(arg, arg2, arg3, arg4, arg5)
												tweenService:Create(arg, TweenInfo.new(arg2 or 0.2, arg4 or Enum.EasingStyle.Quint, arg5 or Enum.EasingDirection.Out), arg3):Play()
											end
											local fn51 = function(parent, arg, arg2, rotation)
												local instance3 = Instance.new(v85[181])
												instance3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, arg), ColorSequenceKeypoint.new(1, arg2) })
												instance3.Rotation = rotation or 0
												instance3.Parent = parent
												return instance3
											end
											createUICorner2(frame, 18)
											createUIStroke2(frame, tbl29.AQUA_STROKE, 1.2, v85[54])
											local instance3 = Instance.new(v85[157])
											instance3.Name = v85[162]
											instance3.AnchorPoint = Vector2.new(v85[140], 0.5)
											instance3.Position = UDim2.new(0.5, 0, v85[140], 2)
											instance3.Size = UDim2.new(1, v85[42], 1, v85[42])
											instance3.BackgroundTransparency = 1
											instance3.Image = "rbxassetid://6014261993"
											instance3.ImageColor3 = Color3.new(0, 0, v85[164])
											instance3.ImageTransparency = v85[49]
											instance3.ScaleType = Enum.ScaleType.Slice
											instance3.SliceCenter = Rect.new(49, v85[56], 450, 450)
											instance3.ZIndex = 99
											instance3.Parent = frame
											do
												local frame2 = Instance.new("Frame", frame)
												frame2.Size = UDim2.new(1, 0, 0, math.floor(36 * n34))
												frame2.BackgroundTransparency = 1
												frame2.ZIndex = v85[172]
												fn41(frame2, frame, "TargetControls")
												local textLabel2 = Instance.new("TextLabel", frame2)
												textLabel2.Size = UDim2.new(1, -28, 0, math.floor(22 * n34))
												textLabel2.Position = UDim2.new(0, v85[46], 0, math.floor(7 * n34))
												textLabel2.ZIndex = v85[155]
												textLabel2.BackgroundTransparency = 1
												textLabel2.Text = "TARGET CONTROLS"
												textLabel2.Font = Enum.Font.GothamBlack
												textLabel2.TextSize = 18 * n34
												textLabel2.TextColor3 = tbl29.TEXT
												textLabel2.TextXAlignment = Enum.TextXAlignment.Center
											end
											local frame2 = Instance.new("Frame", frame)
											frame2.AnchorPoint = Vector2.new(0.5, 0)
											frame2.Position = UDim2.new(0.5, 0, 0, math.floor(32 * n34))
											frame2.Size = UDim2.new(0, math.floor(124 * n34), 0, 1)
											frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
											frame2.BackgroundTransparency = 0.15
											frame2.BorderSizePixel = 0
											frame2.ZIndex = 101
											local frame3
											local frame4 = Instance.new("Frame", frame)
											frame4.AutomaticSize = Enum.AutomaticSize.Y
											frame4.Size = UDim2.new(1, -20, v85[164], v85[164])
											frame4.Position = UDim2.fromOffset(10, math.floor(v85[194] * n34))
											frame4.BackgroundColor3 = tbl29.SURF
											frame4.BorderSizePixel = 0
											frame4.ZIndex = 101
											createUICorner2(frame4, 16)
											createUIStroke2(frame4, tbl29.AQUA_STROKE, v85[64], 0.48)
											frame3 = Instance.new("Frame", frame4)
											frame3.AutomaticSize = Enum.AutomaticSize.Y
											frame3.Size = UDim2.new(1, -8, 0, 0)
											frame3.Position = UDim2.fromOffset(4, 4)
											frame3.BackgroundTransparency = 1
											frame3.ZIndex = v85[155]
											local uiListLayout = Instance.new("UIListLayout")
											uiListLayout.Padding = UDim.new(0, 6)
											uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
											uiListLayout.Parent = frame3
											local v94 = n34
											local fn52 = function(arg, text, arg2)
												local frame5 = Instance.new("Frame", arg)
												frame5.Name = text:gsub("%s+", "") .. "Row"
												frame5.Size = UDim2.new(1, 0, 0, math.floor(30 * v94))
												frame5.BackgroundColor3 = tbl29.SURF2
												frame5.BackgroundTransparency = 0.02
												frame5.BorderSizePixel = 0
												frame5.LayoutOrder = math.floor((arg2 or 0) / math.max(v85[64], 36 * v94)) + 1
												frame5.ZIndex = 103
												createUICorner2(frame5, 11)
												local v95 = createUIStroke2(frame5, tbl29.AQUA_STROKE, 1, 0.52)
												local textLabel2 = Instance.new("TextLabel", frame5)
												textLabel2.BackgroundTransparency = 1
												textLabel2.Position = UDim2.fromOffset(12, v85[164])
												textLabel2.Size = UDim2.new(1, -math.floor(118 * v94), 1, 0)
												textLabel2.TextTruncate = Enum.TextTruncate.AtEnd
												textLabel2.Font = Enum.Font.GothamBold
												textLabel2.Text = text
												textLabel2.TextColor3 = tbl29.TEXT
												textLabel2.TextSize = 12 * v94
												textLabel2.TextXAlignment = Enum.TextXAlignment.Left
												textLabel2.ZIndex = 104
												local textButton = Instance.new("TextButton", frame5)
												local v96 = v85[58]
												textButton.Name = text:gsub("%s+", "") .. v96
												textButton.AutoButtonColor = false
												local floor2 = math.floor
												local n35 = 22 * v94
												textButton.Size = UDim2.fromOffset(math.floor(96 * v94), floor2(n35))
												textButton.Position = UDim2.new(1, -math.floor(v85[75] * v94), 0.5, -math.floor(11 * v94))
												textButton.BackgroundColor3 = tbl29.OFF_BG
												textButton.BorderSizePixel = 0
												textButton.Text = ""
												textButton.ZIndex = v85[60]
												createUICorner2(textButton, v85[87])
												local v97 = createUIStroke2(textButton, tbl29.AQUA_STROKE, 1, 0.55)
												local frame6 = Instance.new("Frame", textButton)
												frame6.Size = UDim2.new(1, 0, 1, 0)
												frame6.BackgroundTransparency = v85[64]
												frame6.BorderSizePixel = 0
												frame6.ZIndex = v85[60]
												createUICorner2(frame6, 7)
												fn51(frame6, tbl29.GREEN1, tbl29.GREEN2, v85[164])
												local textLabel3 = Instance.new("TextLabel", textButton)
												textLabel3.BackgroundTransparency = 1
												textLabel3.Size = UDim2.fromScale(v85[64], 1)
												textLabel3.Font = Enum.Font.GothamBold
												textLabel3.TextSize = 11 * v94
												textLabel3.Text = v85[121]
												textLabel3.TextColor3 = tbl29.OFF_TEXT
												textLabel3.ZIndex = 105
												frame5.MouseEnter:Connect(function()
													fn50(frame5, 0.14, { BackgroundColor3 = Color3.fromRGB(62, 34, v85[191]) })
													fn50(v95, 0.14, { Transparency = 0.38 })
												end)
												frame5.MouseLeave:Connect(function()
													fn50(frame5, 0.14, { BackgroundColor3 = tbl29.SURF2 })
													fn50(v95, 0.14, { Transparency = v85[127] })
												end)
												return {
													row = frame5,
													label = textLabel2,
													button = textButton,
													knob = frame6,
													stateLabel = textLabel3,
													stroke = v97,
													rowStroke = v95,
												}
											end
											do
												local parent = frame3.Parent.Parent
												local frame5 = Instance.new("Frame", parent.Parent)
												frame5.Name = "GearPanelFrame"
												frame5.AutomaticSize = Enum.AutomaticSize.Y
												frame5.Size = UDim2.new(0, math.floor(240 * n34), 0, 0)
												frame5.BackgroundColor3 = tbl29.BG
												frame5.BackgroundTransparency = v85[164]
												frame5.BorderSizePixel = v85[164]
												frame5.ClipsDescendants = false
												frame5.ZIndex = v85[12]
												local gearPanel = v87.Positions.GearPanel
												if not (gearPanel and gearPanel.X and gearPanel.Y) then
													local targetControls = v87.Positions.TargetControls or { X = v85[66], Y = 0.35 }
													local n35 = (targetControls.X or 0.26) + 0.2
													if n35 > 0.74 then n35 = math.max(0.02, (targetControls.X or 0.26) - 0.2) end
													gearPanel = { X = n35, Y = targetControls.Y or 0.35, OffsetX = 15, OffsetY = 0 }
													v87.Positions.GearPanel = gearPanel
													fn32()
												end
												frame5.Position = UDim2.new(gearPanel.X, gearPanel.OffsetX or 0, gearPanel.Y, gearPanel.OffsetY or 0)
												task.defer(function()
													local v95 = tbl28.panels[v85[64]]
													if not (v95 and v95.Parent and frame5.Parent) then return end
													for i = 1, 20 do
														if not (v95.AbsoluteSize.X > 1 and frame5.AbsoluteSize.X > 1) then
															task.wait(0.05)
															continue
														end
														break
													end
													local absolutePosition = v95.AbsolutePosition
													local absolutePosition2 = frame5.AbsolutePosition
													local absoluteSize = v95.AbsoluteSize
													local absoluteSize2 = frame5.AbsoluteSize
													if absoluteSize.X < 1 or absoluteSize2.X < 1 then return end
													local n35 = math.min(absolutePosition.X + absoluteSize.X, absolutePosition2.X + absoluteSize2.X) - math.max(absolutePosition.X, absolutePosition2.X)
													local n36 = math.min(absolutePosition.Y + absoluteSize.Y, absolutePosition2.Y + absoluteSize2.Y) - math.max(absolutePosition.Y, absolutePosition2.Y)
													if n35 <= absoluteSize2.X * 0.25 or n36 <= absoluteSize2.Y * 0.25 then return end
													local v96 = fn40()
													local n37 = absolutePosition.X + absoluteSize.X + 16
													if n37 + absoluteSize2.X > v96.X - 8 then n37 = absolutePosition.X - absoluteSize2.X - v85[45] end
													frame5.Position = UDim2.new(frame5.Position.X.Scale, math.floor(math.max(v85[82], n37) - frame5.Position.X.Scale * v96.X), frame5.Position.Y.Scale, frame5.Position.Y.Offset)
													gearPanel.OffsetX = frame5.Position.X.Offset
													gearPanel.X = frame5.Position.X.Scale
													v87.Positions.GearPanel = gearPanel
													fn32()
												end)
												createUICorner2(frame5, 18)
												createUIStroke2(frame5, tbl29.AQUA_STROKE, 1.2, 0.4)
												fn33(frame5)
												frame5.Visible = parent.Visible
												table.insert(tbl28.panels, frame5)
												local instance4 = Instance.new(v85[157], frame5)
												instance4.Name = "Shadow"
												instance4.AnchorPoint = Vector2.new(0.5, 0.5)
												instance4.Position = UDim2.new(0.5, 0, 0.5, 2)
												instance4.Size = UDim2.new(v85[64], 24, v85[64], v85[42])
												instance4.BackgroundTransparency = 1
												instance4.Image = "rbxassetid://6014261993"
												instance4.ImageColor3 = Color3.new(v85[164], 0, 0)
												instance4.ImageTransparency = 0.72
												instance4.ScaleType = Enum.ScaleType.Slice
												instance4.SliceCenter = Rect.new(49, 49, 450, 450)
												instance4.ZIndex = 99
												local instance5 = Instance.new(v85[68], frame5)
												instance5.Size = UDim2.new(1, 0, 0, math.floor(36 * n34))
												instance5.BackgroundTransparency = 1
												instance5.ZIndex = 101
												fn41(instance5, frame5, "GearPanel")
												local textLabel2 = Instance.new("TextLabel", instance5)
												textLabel2.Size = UDim2.new(1, -28, v85[164], math.floor(22 * n34))
												textLabel2.Position = UDim2.new(0, 14, 0, math.floor(7 * n34))
												textLabel2.ZIndex = 102
												textLabel2.BackgroundTransparency = 1
												textLabel2.Text = "GEAR & SAFETY"
												textLabel2.Font = Enum.Font.GothamBlack
												textLabel2.TextSize = 18 * n34
												textLabel2.TextColor3 = tbl29.TEXT
												textLabel2.TextXAlignment = Enum.TextXAlignment.Center
												local instance6 = Instance.new(v85[68], frame5)
												instance6.AnchorPoint = Vector2.new(0.5, v85[164])
												instance6.Position = UDim2.new(0.5, 0, 0, math.floor(32 * n34))
												local v95 = v85[64]
												instance6.Size = UDim2.new(0, math.floor(124 * n34), 0, v95)
												instance6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
												instance6.BackgroundTransparency = v85[156]
												instance6.BorderSizePixel = 0
												instance6.ZIndex = v85[172]
												local frame6 = Instance.new("Frame", frame5)
												frame6.AutomaticSize = Enum.AutomaticSize.Y
												frame6.Size = UDim2.new(1, -20, v85[164], 0)
												frame6.Position = UDim2.fromOffset(10, math.floor(v85[194] * n34))
												frame6.BackgroundColor3 = tbl29.SURF
												frame6.BorderSizePixel = 0
												frame6.ZIndex = 101
												createUICorner2(frame6, 16)
												createUIStroke2(frame6, tbl29.AQUA_STROKE, 1, 0.48)
												local frame7 = Instance.new("Frame", frame6)
												frame7.AutomaticSize = Enum.AutomaticSize.Y
												frame7.Size = UDim2.new(1, -8, 0, 0)
												frame7.Position = UDim2.fromOffset(4, 4)
												frame7.BackgroundTransparency = 1
												frame7.ZIndex = 102
												local uiListLayout2 = Instance.new("UIListLayout", frame7)
												uiListLayout2.Padding = UDim.new(0, v85[167])
												uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
												tbl28.list = frame7
											end
											local instantSteal2 = fn52(frame3, "Instant Steal", 0)
											local podiumEsp, podiumESP, nextBase, nextBase2, carpetSpeed, antiDie, icollectproAntidieOn, infiniteJump, fn53
											local v95 = nil
											podiumEsp = nil
											podiumESP = v87.PodiumESP == true
											nextBase = nil
											nextBase2 = v87.NextBase == v85[192]
											carpetSpeed = v87.CarpetSpeed == true
											antiDie = nil
											icollectproAntidieOn = v87.AntiDie ~= false
											infiniteJump = false
											fn53 = function(arg, selectedPetData)
												fn46()
												local function fn54(arg2, arg3, arg4)
													if not arg4 then
													end
													if arg3 then
														arg2.button.BackgroundColor3 = tbl29.GREEN1
														arg2.knob.BackgroundTransparency = 0
														arg2.stateLabel.Text = "ON"
														arg2.stateLabel.TextColor3 = Color3.fromRGB(232, 255, 240)
														arg2.stroke.Color = tbl29.GREEN_STROKE
														arg2.stroke.Transparency = 0.22
													else
														arg2.button.BackgroundColor3 = tbl29.OFF_BG
														arg2.knob.BackgroundTransparency = 1
														arg2.stateLabel.Text = "OFF"
														arg2.stateLabel.TextColor3 = tbl29.OFF_TEXT
														arg2.stroke.Color = tbl29.AQUA_STROKE
														arg2.stroke.Transparency = 0.55
													end
													if arg2.rowStroke then arg2.rowStroke.Transparency = arg3 and 0.38 or 0.52 end
													if arg2.label then arg2.label.TextColor3 = arg3 and tbl29.TEXT or tbl29.TEXT end
												end
												fn54(instantSteal2, stealNearest and instantSteal, tbl25.Accent1)
												if v95 then
													if instantSteal then
														v95.stateLabel.Text = "ON"
														v95.stateLabel.TextColor3 = Color3.fromRGB(v85[16], 255, v85[173])
														v95.button.BackgroundColor3 = tbl29.GREEN1
														v95.knob.BackgroundTransparency = 0
														v95.stroke.Color = tbl29.GREEN_STROKE
														v95.stroke.Transparency = 0.22
													else
														v95.stateLabel.Text = "OFF"
														v95.stateLabel.TextColor3 = tbl29.OFF_TEXT
														v95.button.BackgroundColor3 = tbl29.OFF_BG
														v95.knob.BackgroundTransparency = 1
														v95.stroke.Color = tbl29.AQUA_STROKE
														v95.stroke.Transparency = v85[188]
													end
													if v95.rowStroke then v95.rowStroke.Transparency = instantSteal and 0.38 or 0.52 end
												end
												if podiumEsp then
													if podiumESP then
														podiumEsp.stateLabel.Text = "ON"
														podiumEsp.stateLabel.TextColor3 = Color3.fromRGB(232, 255, v85[173])
														podiumEsp.button.BackgroundColor3 = tbl29.GREEN1
														podiumEsp.knob.BackgroundTransparency = v85[164]
														podiumEsp.stroke.Color = tbl29.GREEN_STROKE
														podiumEsp.stroke.Transparency = 0.22
													else
														podiumEsp.stateLabel.Text = "OFF"
														podiumEsp.stateLabel.TextColor3 = tbl29.OFF_TEXT
														podiumEsp.button.BackgroundColor3 = tbl29.OFF_BG
														podiumEsp.knob.BackgroundTransparency = v85[64]
														podiumEsp.stroke.Color = tbl29.AQUA_STROKE
														podiumEsp.stroke.Transparency = 0.55
													end
													if podiumEsp.rowStroke then podiumEsp.rowStroke.Transparency = podiumESP and 0.38 or v85[127] end
												end
												if nextBase then
													if nextBase2 then
														nextBase.stateLabel.Text = v85[176]
														nextBase.stateLabel.TextColor3 = Color3.fromRGB(232, 255, v85[173])
														nextBase.button.BackgroundColor3 = tbl29.GREEN1
														nextBase.knob.BackgroundTransparency = 0
														nextBase.stroke.Color = tbl29.GREEN_STROKE
														nextBase.stroke.Transparency = 0.22
													else
														nextBase.stateLabel.Text = "OFF"
														nextBase.stateLabel.TextColor3 = tbl29.OFF_TEXT
														nextBase.button.BackgroundColor3 = tbl29.OFF_BG
														nextBase.knob.BackgroundTransparency = 1
														nextBase.stroke.Color = tbl29.AQUA_STROKE
														nextBase.stroke.Transparency = 0.55
													end
													if nextBase.rowStroke then nextBase.rowStroke.Transparency = nextBase2 and v85[41] or v85[127] end
												end
												if antiDie then
													if icollectproAntidieOn then
														antiDie.stateLabel.Text = "ON"
														antiDie.stateLabel.TextColor3 = Color3.fromRGB(232, 255, 240)
														antiDie.button.BackgroundColor3 = tbl29.GREEN1
														antiDie.knob.BackgroundTransparency = 0
														antiDie.stroke.Color = tbl29.GREEN_STROKE
														antiDie.stroke.Transparency = 0.22
													else
														antiDie.stateLabel.Text = "OFF"
														antiDie.stateLabel.TextColor3 = tbl29.OFF_TEXT
														antiDie.button.BackgroundColor3 = tbl29.OFF_BG
														antiDie.knob.BackgroundTransparency = v85[64]
														antiDie.stroke.Color = tbl29.AQUA_STROKE
														antiDie.stroke.Transparency = v85[188]
													end
													if antiDie.rowStroke then antiDie.rowStroke.Transparency = icollectproAntidieOn and 0.38 or 0.52 end
												end
												if uid and selectedPetData then
													for i, v96 in ipairs(selectedPetData) do
														if v96.uid == uid then
															n33 = i
															break
														end
													end
												end
												if tbl17.ListNeedsRedraw then
													tbl26 = {}
													tbl17.ListNeedsRedraw = v85[139]
												end
												selectedPetData = selectedPetData and selectedPetData[n33]
												tbl17.SelectedPetData = selectedPetData
												if arg then
													if not stealNearest then
														if selectedPetData then
															textLabel.Text = string.format("%s - %s", selectedPetData.petName or v85[38], selectedPetData.mpsText or "")
														else
															textLabel.Text = "Searching..."
														end
													end
												else
													textLabel.Text = "Disabled"
													if tween then
														tween:Cancel()
														tween = nil
													end
													instance.Size = UDim2.new(0, 0, 1, v85[164])
												end
												instance2.Text = string.format("%d%%", math.clamp(math.floor(instance.Size.X.Scale * 100 + v85[140]), 0, 100))
											end
											tbl17.UpdateAutoStealUI = function() fn53(flag18, fn49()) end
											task.spawn(function()
												while true do
													if instance and instance.Parent then
														if fn30() then
															local n35 = math.clamp(math.floor(instance.Size.X.Scale * 100 + v85[140]), 0, 100)
															instance2.Text = tostring(n35) .. "%"
															task.wait(0.05)
															continue
														end
													end
													break
												end
											end)
											do
												local parent = textLabel.Parent
												local size = parent.Size
												local udim2 = UDim2.new(size.X.Scale, size.X.Offset, size.Y.Scale, math.floor(size.Y.Offset * 2.15))
												local udim22 = UDim2.new(size.X.Scale, size.X.Offset, size.Y.Scale, math.floor(size.Y.Offset * v85[161]))
												local textLabel2 = Instance.new("TextLabel", parent)
												textLabel2.Name = "NoTargetHint"
												textLabel2.AnchorPoint = Vector2.new(0.5, 1)
												textLabel2.Position = UDim2.new(0.5, 0, 1, -8)
												textLabel2.Size = UDim2.fromOffset(math.max(v85[33], size.X.Offset - 16), 42)
												textLabel2.BackgroundTransparency = 1
												textLabel2.Font = Enum.Font.GothamBold
												textLabel2.TextSize = 11
												textLabel2.TextColor3 = Color3.fromRGB(255, 196, 96)
												textLabel2.TextWrapped = true
												textLabel2.TextTransparency = 1
												textLabel2.TextStrokeColor3 = Color3.fromRGB(20, 12, v85[81])
												textLabel2.TextStrokeTransparency = 0.5
												textLabel2.Text = "Make sure there are CARPET brainrots on other people's bases  -  Instant Steal wont work without them"
												textLabel2.ZIndex = 75
												textLabel2.Visible = v85[139]
												local v96 = nil
												local function fn54()
													if not v96 or not v96.Parent then
														local ok, result = pcall(function()
															local v97 = iCollectProUIHost()
															local instance4 = Instance.new(v85[98])
															instance4.Name = "__ICPNoTarget"
															instance4.SoundId = "rbxassetid://82418169358213"
															instance4.Volume = 1
															instance4.Parent = v97
															return instance4
														end)
														v96 = ok and result or nil
													end
													if v96 then
														pcall(function()
															v96.TimePosition = 0
															v96:Play()
														end)
													end
												end
												local function fn55()
													parent.Size = udim22
													local tbl30 = { Size = udim2 }
													tweenService:Create(parent, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), tbl30):Play()
												end
												local v97 = iCollectProUIHost()
												local xkPqNoTargetDim = v97:FindFirstChild("XkPqNoTargetDim")
												if xkPqNoTargetDim then xkPqNoTargetDim:Destroy() end
												local screenGui2 = Instance.new("ScreenGui")
												screenGui2.Name = v85[134]
												fn29(screenGui2)
												screenGui2.ResetOnSpawn = v85[139]
												screenGui2.IgnoreGuiInset = v85[192]
												screenGui2.DisplayOrder = v85[62]
												screenGui2.Enabled = false
												screenGui2.Parent = v97
												local instance4 = Instance.new(v85[68], screenGui2)
												instance4.Name = v85[193]
												instance4.Size = UDim2.fromScale(1, 1)
												instance4.BackgroundColor3 = Color3.new(0, 0, 0)
												instance4.BackgroundTransparency = v85[64]
												instance4.BorderSizePixel = 0
												instance4.Active = v85[139]
												instance4.ZIndex = 1
												local v98 = parent:FindFirstAncestorWhichIsA(v85[9])
												if v98 then
													pcall(function()
														v98.Parent = v97
														v98.DisplayOrder = 1600
													end)
												end
												local tbl30 = { "XkPqAutoKick", "XkPqBoostSettings", v85[132], v85[113] }
												local function fn56()
													local parent2 = screenGui2 and screenGui2.Parent
													if not parent2 then return v85[139] end
													for _, v99 in ipairs(tbl30) do
														local v100 = parent2:FindFirstChild(v99)
														if v100 and v100.Enabled then return true end
													end
													return false
												end
												local v99 = v85[139]
												local function fn57(arg)
													local flag21 = arg and true or v85[139]
													if not instance4 or not instance4.Parent then return end
													if flag21 == v99 then return end
													v99 = flag21
													if flag21 then
														screenGui2.Enabled = true
														tweenService:Create(instance4, TweenInfo.new(0.35), { BackgroundTransparency = 0.22 }):Play()
													else
														tweenService:Create(instance4, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
														task.delay(0.32, function()
															if not v99 and instance4.Parent then screenGui2.Enabled = v85[139] end
														end)
													end
												end
												local flag21 = false
												local function fn58(arg)
													if arg == flag21 then return end
													flag21 = arg
													if arg then
														textLabel2.Visible = true
														fn54()
														fn55()
														tweenService:Create(textLabel2, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()
													else
														local tbl31 = { Size = size }
														tweenService:Create(parent, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl31):Play()
														local tbl32 = { TextTransparency = v85[64] }
														local tween2 = tweenService:Create(textLabel2, TweenInfo.new(0.18), tbl32)
														tween2:Play()
														tween2.Completed:Wait()
														if not flag21 then textLabel2.Visible = false end
													end
												end
												local n35 = 0
												task.spawn(function()
													local n36 = 0
													while true do
														if parent and parent.Parent then
															if fn30() then
																local flag22 = textLabel.Text == "No target"
																if flag22 then
																	if n35 == 0 then
																		local v100 = v85[82]
																		n35 = os.clock() + v100
																	end
																else
																	n35 = 0
																end
																fn58(flag22)
																fn57(flag22 and not fn56() and os.clock() < n35)
																if flag22 then
																	n36 += 1
																	if v85[194] <= n36 then
																		fn55()
																		n36 = 0
																	end
																else
																	n36 = v85[164]
																end
																task.wait(v85[123])
																continue
															end
														end
														break
													end
												end)
											end
											instantSteal2.button.MouseButton1Click:Connect(function()
												local flag21 = not (stealNearest and instantSteal)
												stealNearest = flag21
												instantSteal = flag21
												if flag21 then
													stealHighest = false
													stealPriority = false
													v89 = nil
												end
												flag19 = v85[139]
												flag20 = v85[139]
												v87.StealNearest = stealNearest
												v87.StealHighest = stealHighest
												v87.StealPriority = stealPriority
												v87.InstantSteal = instantSteal
												fn46()
												genv.NEAREST_INSTANT_MODE = instantSteal and v87.ZoneInstantMode == true
												genv.INSTANT_ANY = instantSteal and v89 == nil
												fn32()
												tbl17.ListNeedsRedraw = false
												fn53(flag18, fn49())
											end)
											local RunService2 = game:GetService("RunService")
											local v96 = iCollectProUIHost()
											local tbl30 = {
												RED = Color3.fromRGB(255, 60, v85[189]),
												ORANGE = Color3.fromRGB(255, 150, 40),
												YELLOW = Color3.fromRGB(v85[149], 225, 60),
												GREEN = Color3.fromRGB(70, 235, 110),
												CYAN = Color3.fromRGB(55, 225, 235),
												BLUE = Color3.fromRGB(55, 185, 255),
												PURPLE = Color3.fromRGB(v85[95], 95, 255),
												HUB = Color3.fromRGB(168, 85, v85[197]),
												PINK = Color3.fromRGB(v85[149], 95, 190),
												WHITE = Color3.fromRGB(255, 255, 255),
												BLACK = Color3.fromRGB(20, v85[3], v85[3]),
											}
											local tbl31 = {}
											do
												local floorColor = {}
												local color = Color3.fromRGB(70, 20, 130)
												local color2 = Color3.fromRGB(v85[12], 35, 175)
												local color3 = Color3.fromRGB
												local v97 = v85[195]
												local v98 = v85[120]
												floorColor[1] = color
												floorColor[2] = color2
												do
													local values = table.pack(color3(v97, 55, v98))
													table.move(values, 1, values.n, 3, floorColor)
												end
												tbl31.FLOOR_COLOR = floorColor
											end
											local vector = Vector3.new(6, 0.14, v85[167])
											genv.iCollectPro_PodiumCollideOn = v85[192]
											local n35 = 0.3
											local n36 = 0.5
											local n37 = 0.14
											local v97, n38, n39, now2, tbl32, color, color2, tbl33, vector2, vector3
											local tbl34, tbl35, tbl36, flag21, plots, v98, fn54, fn55, fn56, createBoxHandleAdornment
											local fn57, fn58, v99, tbl37, iCollectProPodiumESPCleanup, fn59
											do
												local lineThickness = 0.06
												v97 = v85[67]
												n38 = 0.12
												n39 = 0
												now2 = nil
												local function fn60() return math.floor(math.clamp(v85[184] * (fn40().Y / 1080), 40, 72) + 0.5) end
												tbl32 = {
													SHOW = v87.HideNumbers ~= true,
													PX = fn60(),
													ASPECT = v85[107],
													HEIGHT = 5.4,
													RING = 1.8,
													BG_T = 0.06,
													MAX_DIST = 320,
													ON_TOP = true,
												}
												color = Color3.fromRGB(9, 6, v85[78])
												color2 = Color3.fromRGB(255, v85[74], 255)
												tbl33 = {
													{ 18.5, 1.531, -14.476, 90 },
													{ 18.5, 1.531, -6.976, 90 },
													{ v85[143], 1.531, 0.524, 90 },
													{ 18.5, 1.531, 8.024, v85[129] },
													{ 18.5, 1.531, 15.524, 90 },
													{ -18.536, v85[109], 15.524, -90 },
													{ -v85[183], v85[109], v85[84], -90 },
													{ -18.536, 1.531, 0.524, -90 },
													{ -18.536, v85[109], -v85[165], -90 },
													{ -18.536, 1.531, -14.476, -90 },
													{ 18.5, v85[14], -14.476, 90 },
													{ 18.5, 19.531, -6.976, 90 },
													{ 18.5, v85[14], 0.524, v85[129] },
													{ 18.5, 19.531, 8.024, 90 },
													{ 18.5, 19.531, v85[102], 90 },
													{ -18.38, 19.531, -14.452, -v85[129] },
													{ -18.38, 19.531, -6.952, -90 },
													{ -18.38, v85[14], 0.548, -90 },
													{ 18.5, 36.531, -12.476, 90 },
													{ v85[143], 36.531, -4.976, 90 },
													{ 18.5, 36.531, 2.524, 90 },
													{ 18.5, 36.531, 10.024, v85[129] },
													{ 18.5, 36.531, v85[151], 90 },
													{ -18.472, v85[137], -v85[85], -90 },
													{ -v85[40], 36.531, -5.001, -v85[129] },
													{ -18.471, v85[137], v85[21], -v85[129] },
													{ -18.471, 36.531, 9.999, -90 },
													{ -18.471, 36.531, v85[27], -90 },
												}
												vector2 = Vector3.new(v85[167], 0.25, 6)
												vector3 = Vector3.new(v85[169], v85[123], 4)
												local tbl38 = {}
												tbl34 = {}
												tbl35 = {}
												tbl36 = {}
												local tbl39 = {}
												flag21 = false
												plots = nil
												v98 = nil
												local function fn61(arg)
													tbl38[#tbl38 + 1] = arg
													arg.Parent = v96
													return arg
												end
												local tbl40 = {}
												local tbl41 = {}
												local tbl42 = {}
												local v100 = nil
												local v101 = nil
												local v102 = nil
												local v103 = nil
												local animalPodiums = nil
												local flag22 = false
												fn54 = function()
													if v100 then
														pcall(function()
															v100:Disconnect()
														end)
														v100 = nil
													end
													v101 = nil
													for k in pairs(tbl40) do
														pcall(function()
															if k.Parent then k.LocalTransparencyModifier = 0 end
														end)
													end
													table.clear(tbl40)
													for k, v104 in pairs(tbl41) do
														pcall(function()
															if k.Parent then
																k.TextTransparency = v104.t
																k.TextStrokeTransparency = v104.s
															end
														end)
													end
													table.clear(tbl41)
													table.clear(tbl42)
													v102 = nil
													v103 = nil
													animalPodiums = nil
													flag22 = false
												end
												local function fn62(arg, localTransparencyModifier)
													if animalPodiums and arg:IsDescendantOf(animalPodiums) then return end
													if arg:IsA("BasePart") then
														tbl40[arg] = true
														arg.LocalTransparencyModifier = localTransparencyModifier
														return
													end
													if arg:IsA("TextLabel") or arg:IsA("TextButton") then
														if tbl41[arg] == nil and arg.TextTransparency < 1 then
															tbl41[arg] = { t = arg.TextTransparency, s = arg.TextStrokeTransparency }
															arg.TextTransparency = v85[64]
															arg.TextStrokeTransparency = v85[64]
														end
													end
												end
												local function fn63(arg, arg2)
													local ok, result = pcall(function()
														return arg:GetDescendants()
													end)
													if not ok or not result then return end
													for _, v104 in ipairs(result) do pcall(fn62, v104, arg2) end
												end
												fn55 = function(arg)
													local flag23 = v87.SeeThroughBase == true
													local n40
													if flag23 then
														n40 = math.clamp(tonumber(v87.SeeThruOpacity) or v85[64], 0, 1)
													else
														n40 = flag23
													end
													n40 = n40 or nil
													if not arg or not arg.Parent or not n40 then
														if v102 then fn54() end
														return
													end
													if v102 == arg and v103 == n40 then return end
													fn54()
													v102 = arg
													v103 = n40
													animalPodiums = arg:FindFirstChild("AnimalPodiums")
													fn63(arg, n40)
													v100 = fn31(arg.DescendantAdded, function(arg2)
														if v102 ~= arg then return end
														local n41 = #tbl42
														if n41 >= 1500 then
															flag22 = true
															table.clear(tbl42)
															return
														end
														tbl42[n41 + 1] = arg2
													end)
													local tbl43 = {}
													v101 = tbl43
													task.spawn(function()
														while v101 == tbl43 and fn30() do
															task.wait(0.2)
															if v101 ~= tbl43 then return end
															local v104 = v103
															if not v104 or not v102 or not v102.Parent then return end
															if flag22 then
																flag22 = false
																pcall(fn63, v102, v104)
															elseif #tbl42 > 0 then
																local v105 = tbl42
																tbl42 = {}
																for _, v106 in ipairs(v105) do if v106.Parent then pcall(fn62, v106, v104) end end
															end
														end
													end)
												end
												fn56 = function()
													for _, v104 in ipairs(tbl38) do
														pcall(function()
															v104:Destroy()
														end)
													end
													table.clear(tbl38)
													table.clear(tbl34)
													table.clear(tbl36)
													for _, v104 in ipairs(tbl39) do
														pcall(function()
															if v104.Parent then v104:Destroy() end
														end)
													end
													table.clear(tbl39)
												end
												createBoxHandleAdornment = function(adornee, cFrame, size, color3, transparency, arg)
													local boxHandleAdornment = Instance.new("BoxHandleAdornment")
													boxHandleAdornment.Adornee = adornee
													boxHandleAdornment.Size = size
													boxHandleAdornment.CFrame = cFrame
													boxHandleAdornment.Color3 = color3
													boxHandleAdornment.Transparency = transparency
													boxHandleAdornment.AlwaysOnTop = false
													boxHandleAdornment.ZIndex = 0
													fn61(boxHandleAdornment)
													tbl34[#tbl34 + 1] = {
														a = boxHandleAdornment,
														base = transparency,
														col = color3,
														slot = n39,
														pulse = arg and true or false,
														t0 = now2 and now2 + (n39 - 1) * 0.035 or nil,
													}
													return boxHandleAdornment
												end
												fn57 = function(adornee, color3)
													local selectionBox = Instance.new("SelectionBox")
													selectionBox.Adornee = adornee
													selectionBox.Color3 = color3
													selectionBox.SurfaceColor3 = color3
													selectionBox.LineThickness = lineThickness
													selectionBox.Transparency = 0
													selectionBox.SurfaceTransparency = v85[64]
													tbl34[#tbl34 + 1] = {
														a = selectionBox,
														base = v85[164],
														col = color3,
														slot = n39,
														pulse = false,
														sel = true,
														t0 = now2 and now2 + (n39 - 1) * 0.035 or nil,
													}
													return fn61(selectionBox)
												end
												fn58 = function(arg, arg2, arg3, arg4)
													local n40 = lineThickness * 1.6
													local n41 = arg3.X * 0.5
													local n42 = arg3.Z * 0.5
													local n43 = arg3.Y * 0.5
													local v104 = v85[164]
													createBoxHandleAdornment(arg, arg2 * CFrame.new(0, n43, n42), Vector3.new(arg3.X, n40, n40), arg4, v104)
													createBoxHandleAdornment(arg, arg2 * CFrame.new(0, n43, -n42), Vector3.new(arg3.X, n40, n40), arg4, 0)
													createBoxHandleAdornment(arg, arg2 * CFrame.new(n41, n43, v85[164]), Vector3.new(n40, n40, arg3.Z), arg4, 0)
													createBoxHandleAdornment(arg, arg2 * CFrame.new(-n41, n43, v85[164]), Vector3.new(n40, n40, arg3.Z), arg4, 0)
												end
												v99 = nil
												local function iCollectProPop()
													if not v99 or not v99.Parent then
														local ok, result = pcall(function()
															local sound = Instance.new("Sound")
															sound.Name = "__ICPPop"
															sound.SoundId = "rbxassetid://102289499477049"
															sound.Volume = 0.6
															sound.Parent = v96
															return sound
														end)
														v99 = ok and result or nil
													end
													if v99 then
														pcall(function()
															v99.TimePosition = 0
															v99:Play()
														end)
													end
												end
												genv.iCollectPro_Pop = iCollectProPop
												local tbl43 = { "rbxassetid://95003901725897", "rbxassetid://72335876826381", "rbxassetid://82122230376488" }
												tbl37 = {}
												local function fn64()
													local v104 = tbl43[math.random(1, #tbl43)]
													local v105 = tbl37[v104]
													if not v105 or not v105.Parent then
														if n28(1994) > 1475 then
															local ok, result = pcall(function()
																local sound = Instance.new("Sound")
																sound.Name = "__ICPHover"
																sound.SoundId = v104
																sound.Volume = 0.12
																sound.Parent = v96
																return sound
															end)
															v105 = ok and result or nil
															tbl37[v104] = v105
														else
															while true do
															end
														end
													end
													if v105 then
														pcall(function()
															v105.Volume = v85[13]
															v105.TimePosition = v85[164]
															v105:Play()
														end)
													end
												end
												local v104 = nil
												local n40 = 0
												local v105 = nil
												local v106 = v85[64]
												local function fn65(arg, arg2, arg3)
													if not arg or not arg.scale or not arg.scale.Parent then return end
													tweenService:Create(arg.scale, TweenInfo.new(0.18, arg3 or Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = arg2 }):Play()
												end
												local function fn66(arg)
													if arg.armed then return 1.4 end
													if arg.stand then return 1.18 end
													if arg.hover then return 1.22 end
													return v106
												end
												local function fn67(arg, arg2)
													if not arg then return end
													arg.armed = arg2 and true or false
													if arg.ring and arg.ring.Parent then
														tweenService:Create(arg.ring, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
															Color = arg2 and Color3.fromRGB(255, 255, v85[149]) or arg.rim,
															Transparency = arg2 and 0 or 0.08,
															Thickness = arg2 and tbl32.RING * 2 or tbl32.RING,
														}):Play()
													end
													if arg.halo and arg.halo.Parent then
														tweenService:Create(arg.halo, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = arg2 and 0.42 or 0.86 }):Play()
													end
													fn65(arg, fn66(arg))
												end
												local function fn68(arg, arg2)
													if not arg then return end
													if arg2 and arg.hover ~= true then fn64() end
													arg.hover = arg2 and true or false
													if arg.ring and arg.ring.Parent and not arg.armed then
														tweenService:Create(arg.ring, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = arg2 and v85[164] or 0.08 }):Play()
													end
													if arg.halo and arg.halo.Parent and not arg.armed then
														tweenService:Create(arg.halo, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = arg2 and 0.66 or 0.86 }):Play()
													end
													if arg.glow and arg.glow.Parent and not arg.armed then
														tweenService:Create(arg.glow, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = arg2 and v85[23] or 0.7, Thickness = arg2 and 5 or 3 }):Play()
													end
													if not (3399 >= n24) then
														fn65(arg, fn66(arg))
														return
													end
													while true do
													end
												end
												local function fn69(arg, arg2)
													if not arg then return end
													local stand = arg2 and v85[192] or false
													if arg.stand == stand then return end
													arg.stand = stand
													fn65(arg, fn66(arg))
												end
												local function fn70(arg)
													if not arg or not arg.root or not arg.root.Parent then return end
													local disc = arg.disc
													local instance4 = Instance.new(v85[68])
													instance4.Name = "Burst"
													instance4.AnchorPoint = Vector2.new(0.5, v85[140])
													instance4.Position = UDim2.fromScale(0.5, disc * 0.5)
													instance4.Size = UDim2.fromScale(1, disc)
													instance4.BackgroundColor3 = Color3.fromRGB(255, 255, v85[149])
													instance4.BackgroundTransparency = 0.3
													instance4.BorderSizePixel = v85[164]
													instance4.ZIndex = v85[89]
													Instance.new(v85[5], instance4).CornerRadius = UDim.new(1, v85[164])
													instance4.Parent = arg.root
													tweenService:Create(instance4, TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.fromScale(2.6, disc * 2.6), BackgroundTransparency = 1 }):Play()
													task.delay(0.5, function()
														if instance4.Parent then instance4:Destroy() end
													end)
												end
												local function fn71(arg, arg2, arg3)
													iCollectProPop()
													local now3 = os.clock()
													if v104 == arg2 and now3 - n40 < 0.6 then
														v104 = nil
														n40 = 0
														v105 = nil
														fn67(arg3, v85[139])
														fn70(arg3)
														local iCollectProTpToSlot = genv.iCollectPro_TpToSlot
														local v107 = v85[34]
														if type(iCollectProTpToSlot) == v107 then
															task.spawn(iCollectProTpToSlot, arg, arg2)
														else
															fn34("TP to Slot", "not ready yet")
														end
														return
													end
													if v105 and v105 ~= arg3 then fn67(v105, false) end
													v104 = arg2
													n40 = now3
													v105 = arg3
													fn67(arg3, true)
													task.delay(0.6, function()
														if v104 == arg2 and v105 == arg3 then
															v104 = nil
															v105 = nil
															fn67(arg3, false)
														end
													end)
												end
												local flag23 = false
												local n41 = 0
												local function fn72(adornee, arg, backgroundColor3, arg2)
													if not tbl32.SHOW or not adornee or not arg then return end
													local v107 = color
													local v108 = backgroundColor3:Lerp(Color3.new(1, 1, v85[64]), 0.28)
													local n42 = 1 / tbl32.ASPECT
													local v109 = v98
													local billboardGui = Instance.new("BillboardGui")
													billboardGui.Name = "__PodiumNum"
													billboardGui.Adornee = adornee
													billboardGui.AlwaysOnTop = tbl32.ON_TOP
													billboardGui.LightInfluence = 0
													billboardGui.MaxDistance = v87.SeeThroughBase == true and 6000 or tbl32.MAX_DIST
													billboardGui.Size = UDim2.fromOffset(tbl32.PX, math.floor(tbl32.PX * tbl32.ASPECT))
													billboardGui.StudsOffsetWorldSpace = Vector3.new(v85[164], arg2, v85[164])
													billboardGui.Active = v85[192]
													local frame5 = Instance.new("Frame", billboardGui)
													frame5.Name = "Root"
													frame5.BackgroundTransparency = 1
													frame5.Size = UDim2.fromScale(v85[64], 1)
													frame5.ZIndex = 1
													local uiScale = Instance.new("UIScale", frame5)
													uiScale.Scale = v85[64]
													local frame6 = Instance.new("Frame", frame5)
													frame6.Name = "Stem"
													frame6.AnchorPoint = Vector2.new(0.5, 0)
													frame6.Position = UDim2.fromScale(0.5, n42 - 0.02)
													frame6.Size = UDim2.new(v85[164], v85[67], 1 - n42 + v85[198], 0)
													frame6.BackgroundColor3 = v108
													frame6.BorderSizePixel = 0
													frame6.ZIndex = 1
													local uiGradient = Instance.new("UIGradient", frame6)
													uiGradient.Rotation = 90
													local new = NumberSequenceKeypoint.new
													uiGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(v85[164], 0.3), new(1, 1) })
													local frame7 = Instance.new("Frame", frame5)
													frame7.Name = "Halo"
													frame7.AnchorPoint = Vector2.new(0.5, 0)
													frame7.Position = UDim2.fromScale(0.5, -0.035)
													frame7.Size = UDim2.new(1.14, v85[164], n42 * 1.14, 0)
													frame7.BackgroundColor3 = backgroundColor3
													frame7.BackgroundTransparency = 0.86
													frame7.BorderSizePixel = v85[164]
													frame7.ZIndex = 1
													Instance.new("UICorner", frame7).CornerRadius = UDim.new(1, v85[164])
													local frame8 = Instance.new("Frame", frame5)
													frame8.Name = "Glow"
													frame8.AnchorPoint = Vector2.new(v85[140], v85[164])
													frame8.Position = UDim2.fromScale(0.5, -0.012)
													frame8.Size = UDim2.new(1.06, 0, n42 * 1.06, 0)
													frame8.BackgroundTransparency = v85[64]
													frame8.ZIndex = 1
													Instance.new(v85[5], frame8).CornerRadius = UDim.new(1, 0)
													local instance4 = Instance.new(v85[115], frame8)
													instance4.Color = backgroundColor3
													instance4.Thickness = 3
													instance4.Transparency = 0.7
													local frame9 = Instance.new("Frame", frame5)
													frame9.Name = "Badge"
													frame9.AnchorPoint = Vector2.new(0.5, 0)
													frame9.Position = UDim2.fromScale(0.5, 0)
													frame9.Size = UDim2.new(1, 0, n42, v85[164])
													frame9.BackgroundColor3 = v107
													frame9.BackgroundTransparency = tbl32.BG_T
													frame9.BorderSizePixel = 0
													frame9.ZIndex = 2
													Instance.new("UICorner", frame9).CornerRadius = UDim.new(1, 0)
													local uiGradient2 = Instance.new("UIGradient", frame9)
													uiGradient2.Rotation = v85[129]
													local colorSequence = ColorSequence.new
													local tbl44 = {}
													local v110 = ColorSequenceKeypoint.new(0, backgroundColor3:Lerp(Color3.new(1, 1, v85[64]), 0.14))
													local v111 = ColorSequenceKeypoint.new(0.5, backgroundColor3:Lerp(color, 0.6))
													local new2 = ColorSequenceKeypoint.new
													local v112 = v85[64]
													tbl44[1] = v110
													tbl44[2] = v111
													do
														local values = table.pack(new2(v112, color))
														table.move(values, 1, values.n, 3, tbl44)
													end
													uiGradient2.Color = colorSequence(tbl44)
													local uiStroke = Instance.new("UIStroke", frame9)
													uiStroke.Color = v108
													uiStroke.Thickness = tbl32.RING
													uiStroke.Transparency = 0.08
													local instance5 = Instance.new(v85[68], frame9)
													instance5.Name = "Inner"
													instance5.AnchorPoint = Vector2.new(0.5, v85[140])
													instance5.Position = UDim2.fromScale(0.5, v85[140])
													instance5.Size = UDim2.fromScale(0.76, 0.76)
													instance5.BackgroundTransparency = v85[64]
													instance5.ZIndex = v85[70]
													Instance.new("UICorner", instance5).CornerRadius = UDim.new(1, v85[164])
													local uiStroke2 = Instance.new("UIStroke", instance5)
													uiStroke2.Color = v108
													uiStroke2.Thickness = 1
													uiStroke2.Transparency = 0.6
													local instance6 = Instance.new(v85[68], frame9)
													instance6.Name = "Sheen"
													instance6.AnchorPoint = Vector2.new(0.5, 0)
													instance6.Position = UDim2.fromScale(0.5, 0.08)
													instance6.Size = UDim2.fromScale(0.64, 0.24)
													instance6.BackgroundColor3 = Color3.new(1, 1, 1)
													instance6.BackgroundTransparency = 0.8
													instance6.BorderSizePixel = 0
													instance6.ZIndex = v85[70]
													Instance.new("UICorner", instance6).CornerRadius = UDim.new(1, 0)
													local uiGradient3 = Instance.new("UIGradient", instance6)
													uiGradient3.Rotation = 90
													local new3 = NumberSequenceKeypoint.new
													local v113 = v85[64]
													uiGradient3.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, v85[156]), new3(1, v113) })
													local iCollectProThemeIsHalloween2 = genv.iCollectPro_ThemeIsHalloween
													local flag24 = iCollectProThemeIsHalloween2 and iCollectProThemeIsHalloween2() or false
													local n43 = 0.16
													local color3 = color
													local n44 = 0.16
													local v114 = color2
													if flag24 then
														local v115 = backgroundColor3:Lerp(Color3.fromRGB(26, 5, 0), 0.6)
														local v116 = v85[140]
														local v117 = backgroundColor3:Lerp(Color3.fromRGB(255, 216, 130), v116)
														local v118 = backgroundColor3:Lerp(Color3.fromRGB(18, 3, v85[164]), 0.78)
														frame9.BackgroundColor3 = Color3.new(v85[64], v85[64], 1)
														local colorSequence2 = ColorSequence.new
														local tbl45 = {}
														local v119 = ColorSequenceKeypoint.new(0, backgroundColor3:Lerp(v117, 0.35))
														local v120 = ColorSequenceKeypoint.new(0.6, backgroundColor3)
														local new4 = ColorSequenceKeypoint.new
														local v121 = v85[64]
														tbl45[1] = v119
														tbl45[2] = v120
														do
															local values = table.pack(new4(v121, v118))
															table.move(values, 1, values.n, 3, tbl45)
														end
														uiGradient2.Color = colorSequence2(tbl45)
														uiStroke.Color = v115
														uiStroke.Transparency = 0.25
														uiStroke2.Transparency = 1
														instance6.BackgroundTransparency = 1
														local instance7 = Instance.new(v85[68], frame5)
														instance7.Name = "Drop"
														instance7.AnchorPoint = Vector2.new(0.5, 0.5)
														instance7.Position = UDim2.fromScale(0.5, n42 * 0.5 + 0.055)
														instance7.Size = UDim2.fromScale(0.92, n42 * 0.86)
														instance7.BackgroundColor3 = Color3.fromRGB(8, 2, 0)
														instance7.BackgroundTransparency = 0.55
														instance7.BorderSizePixel = v85[164]
														instance7.ZIndex = v85[64]
														Instance.new("UICorner", instance7).CornerRadius = UDim.new(1, v85[164])
														for _, v122 in ipairs({
															{ -0.335, 0.26, 0.7, 0.3 },
															{ -0.18, 0.34, 0.9, 0.66 },
															{ v85[164], 0.4, v85[64], 1 },
															{ 0.18, 0.34, 0.9, v85[127] },
															{ 0.335, 0.26, 0.7, 0.18 },
														}) do
															local instance8 = Instance.new(v85[68], frame9)
															instance8.Name = "Lobe"
															instance8.AnchorPoint = Vector2.new(0.5, v85[140])
															instance8.Position = UDim2.fromScale(v85[140] + v122[v85[64]], 0.5)
															instance8.Size = UDim2.fromScale(v122[2], v122[3])
															instance8.BackgroundColor3 = v115:Lerp(backgroundColor3, v122[4])
															instance8.BorderSizePixel = 0
															instance8.ZIndex = 3
															Instance.new("UICorner", instance8).CornerRadius = UDim.new(1, v85[164])
															local uiGradient4 = Instance.new("UIGradient", instance8)
															uiGradient4.Rotation = 0
															local colorSequence3 = ColorSequence.new
															local tbl46 = {}
															local v123 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, v85[149], v85[149]))
															local v124 = ColorSequenceKeypoint.new(v85[41], Color3.fromRGB(226, 226, 226))
															local new5 = ColorSequenceKeypoint.new
															local color4 = Color3.fromRGB
															tbl46[1] = v123
															tbl46[2] = v124
															do
																local values = table.pack(new5(1, color4(104, 104, 104)))
																table.move(values, 1, values.n, 3, tbl46)
															end
															uiGradient4.Color = colorSequence3(tbl46)
														end
														local frame10 = Instance.new("Frame", frame9)
														frame10.Name = "Dusk"
														frame10.AnchorPoint = Vector2.new(0.5, v85[140])
														frame10.Position = UDim2.fromScale(0.5, 0.5)
														frame10.Size = UDim2.fromScale(1, 1)
														frame10.BackgroundColor3 = Color3.fromRGB(20, 4, v85[164])
														frame10.BorderSizePixel = 0
														frame10.ZIndex = 3
														Instance.new(v85[5], frame10).CornerRadius = UDim.new(v85[64], v85[164])
														local instance8 = Instance.new(v85[181], frame10)
														instance8.Rotation = 118
														local numberSequence = NumberSequence.new
														local tbl46 = {}
														local v122 = NumberSequenceKeypoint.new(v85[164], 1)
														local v123 = NumberSequenceKeypoint.new(0.52, v85[64])
														local new5 = NumberSequenceKeypoint.new
														local v124 = v85[64]
														tbl46[1] = v122
														tbl46[2] = v123
														do
															local values = table.pack(new5(v124, 0.34))
															table.move(values, 1, values.n, 3, tbl46)
														end
														instance8.Transparency = numberSequence(tbl46)
														local instance9 = Instance.new(v85[68], frame9)
														instance9.Name = "Dawn"
														instance9.AnchorPoint = Vector2.new(0.5, 0.5)
														instance9.Position = UDim2.fromScale(v85[140], v85[140])
														instance9.Size = UDim2.fromScale(1, 1)
														instance9.BackgroundColor3 = Color3.fromRGB(255, 226, 160)
														instance9.BorderSizePixel = v85[164]
														instance9.ZIndex = 3
														Instance.new("UICorner", instance9).CornerRadius = UDim.new(1, v85[164])
														local instance10 = Instance.new(v85[181], instance9)
														instance10.Rotation = 118
														local numberSequence2 = NumberSequence.new
														local tbl47 = {}
														local v125 = NumberSequenceKeypoint.new(0, 0.62)
														local v126 = NumberSequenceKeypoint.new(0.45, 1)
														local new6 = NumberSequenceKeypoint.new
														local v127 = v85[64]
														tbl47[1] = v125
														tbl47[2] = v126
														do
															local values = table.pack(new6(v127, 1))
															table.move(values, 1, values.n, 3, tbl47)
														end
														instance10.Transparency = numberSequence2(tbl47)
														local instance11 = Instance.new(v85[68], frame9)
														instance11.Name = "Spec"
														instance11.AnchorPoint = Vector2.new(0.5, 0.5)
														instance11.Position = UDim2.fromScale(0.315, 0.245)
														instance11.Size = UDim2.fromScale(0.3, 0.22)
														instance11.Rotation = -24
														instance11.BackgroundColor3 = Color3.fromRGB(255, 244, 214)
														instance11.BackgroundTransparency = 0.48
														instance11.BorderSizePixel = v85[164]
														instance11.ZIndex = v85[70]
														Instance.new("UICorner", instance11).CornerRadius = UDim.new(1, 0)
														local instance12 = Instance.new(v85[181], instance11)
														instance12.Rotation = 118
														local new7 = NumberSequenceKeypoint.new
														instance12.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.15), new7(1, 1) })
														local frame11 = Instance.new("Frame", frame9)
														frame11.Name = "Rim"
														frame11.AnchorPoint = Vector2.new(0.5, 0.5)
														frame11.Position = UDim2.fromScale(v85[140], 0.5)
														frame11.Size = UDim2.fromScale(0.985, 0.985)
														frame11.BackgroundTransparency = 1
														frame11.ZIndex = 3
														Instance.new(v85[5], frame11).CornerRadius = UDim.new(v85[64], v85[164])
														local uiStroke3 = Instance.new("UIStroke", frame11)
														uiStroke3.Color = backgroundColor3:Lerp(Color3.fromRGB(255, 206, 128), 0.7)
														uiStroke3.Thickness = math.max(1.5, tbl32.RING * 0.9)
														uiStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
														local instance13 = Instance.new(v85[181], frame11)
														instance13.Rotation = 118
														local numberSequence3 = NumberSequence.new
														local tbl48 = {}
														local v128 = NumberSequenceKeypoint.new(0, 1)
														local v129 = NumberSequenceKeypoint.new(0.55, 1)
														local v130 = NumberSequenceKeypoint.new(0.82, v85[123])
														local new8 = NumberSequenceKeypoint.new
														local v131 = v85[64]
														local v132 = v85[130]
														tbl48[1] = v128
														tbl48[2] = v129
														tbl48[3] = v130
														do
															local values = table.pack(new8(v131, v132))
															table.move(values, 1, values.n, 4, tbl48)
														end
														instance13.Transparency = numberSequence3(tbl48)
														local instance14 = Instance.new(v85[68], frame5)
														instance14.Name = "Stalk"
														instance14.AnchorPoint = Vector2.new(0.5, v85[64])
														instance14.Position = UDim2.fromScale(0.5, 0.085)
														instance14.Size = UDim2.fromScale(0.145, 0.105)
														instance14.Rotation = -11
														instance14.BackgroundColor3 = Color3.fromRGB(v85[135], 100, 32)
														instance14.BorderSizePixel = 0
														instance14.ZIndex = 5
														Instance.new("UICorner", instance14).CornerRadius = UDim.new(0.45, v85[164])
														local uiGradient4 = Instance.new("UIGradient", instance14)
														uiGradient4.Rotation = 0
														local new9 = ColorSequenceKeypoint.new
														local v133 = v85[64]
														local color4 = Color3.fromRGB
														local v134 = v85[141]
														local v135 = v85[3]
														uiGradient4.Color = ColorSequence.new({
															ColorSequenceKeypoint.new(0, Color3.fromRGB(146, 184, 74)),
															new9(v133, color4(52, v134, v135)),
														})
														local v136 = backgroundColor3:Lerp(Color3.new(v85[164], 0, 0), 0.9)
														for _, v137 in ipairs({ { "◣", 0.285 }, { "◢", 0.715 } }) do
															local textLabel2 = Instance.new("TextLabel", frame9)
															textLabel2.Name = "EyeLip"
															textLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
															textLabel2.Position = UDim2.fromScale(v137[v85[67]], 0.3)
															textLabel2.Size = UDim2.fromScale(v85[66], 0.26)
															textLabel2.BackgroundTransparency = 1
															textLabel2.Font = Enum.Font.GothamBlack
															textLabel2.Text = v137[1]
															textLabel2.TextScaled = true
															textLabel2.TextColor3 = Color3.fromRGB(v85[149], 188, 74)
															textLabel2.TextTransparency = v85[123]
															textLabel2.ZIndex = 5
															local instance15 = Instance.new(v85[8], frame9)
															instance15.Name = "Eye"
															instance15.AnchorPoint = Vector2.new(0.5, 0.5)
															instance15.Position = UDim2.fromScale(v137[2], 0.285)
															instance15.Size = UDim2.fromScale(0.26, 0.26)
															instance15.BackgroundTransparency = 1
															instance15.Font = Enum.Font.GothamBlack
															instance15.Text = v137[1]
															instance15.TextScaled = true
															instance15.TextColor3 = v136
															instance15.ZIndex = v85[167]
														end
														local frame12 = Instance.new("Frame", frame9)
														frame12.Name = "Spill"
														frame12.AnchorPoint = Vector2.new(0.5, v85[140])
														frame12.Position = UDim2.fromScale(0.5, 0.68)
														frame12.Size = UDim2.fromScale(0.66, 0.42)
														frame12.BackgroundColor3 = Color3.fromRGB(255, 176, 52)
														frame12.BackgroundTransparency = 0.6
														frame12.BorderSizePixel = 0
														frame12.ZIndex = 3
														Instance.new("UICorner", frame12).CornerRadius = UDim.new(1, v85[164])
														local color5 = Color3.fromRGB(255, 214, 104)
														n43 = 0.055
														color3 = Color3.fromRGB(30, 7, 0)
														n44 = 0.36
														v114 = color5
													end
													local instance7 = Instance.new(v85[8], frame9)
													instance7.Name = "Num"
													instance7.BackgroundTransparency = v85[64]
													instance7.Size = UDim2.fromScale(1, 1)
													instance7.Font = Enum.Font.GothamBlack
													instance7.Text = tostring(arg)
													instance7.TextColor3 = v114
													instance7.TextScaled = true
													instance7.ZIndex = 4
													local uiPadding = Instance.new("UIPadding", instance7)
													uiPadding.PaddingTop = UDim.new(n44, 0)
													uiPadding.PaddingBottom = UDim.new(n43, 0)
													uiPadding.PaddingLeft = UDim.new(0.13, 0)
													uiPadding.PaddingRight = UDim.new(0.13, v85[164])
													local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", instance7)
													uiTextSizeConstraint.MaxTextSize = 44
													uiTextSizeConstraint.MinTextSize = 8
													local instance8 = Instance.new(v85[115], instance7)
													instance8.Color = color3
													instance8.Thickness = flag24 and 2.2 or 1.6
													instance8.Transparency = flag24 and 0.05 or 0.28
													local textButton = Instance.new("TextButton", frame5)
													textButton.Name = "Hit"
													textButton.Text = ""
													textButton.AutoButtonColor = false
													textButton.BackgroundTransparency = v85[64]
													textButton.AnchorPoint = Vector2.new(0.5, v85[140])
													textButton.Position = UDim2.fromScale(0.5, n42 * 0.5)
													textButton.Size = UDim2.fromScale(1.34, n42 * 1.34)
													textButton.ZIndex = 6
													local tbl45 = {
														bb = billboardGui,
														root = frame5,
														ring = uiStroke,
														halo = frame7,
														glow = instance4,
														scale = uiScale,
														rim = v108,
														disc = n42,
														hitBox = textButton,
														num = instance7,
														slot = arg,
														hover = v85[139],
														stand = false,
														armed = v85[139],
													}
													tbl36[#tbl36 + v85[64]] = tbl45
													textButton.MouseEnter:Connect(function()
														fn68(tbl45, true)
													end)
													textButton.MouseLeave:Connect(function()
														fn68(tbl45, false)
													end)
													if v109 then
														textButton.MouseButton1Click:Connect(function()
															fn71(v109, arg, tbl45)
														end)
													end
													if flag23 then
														n41 += 1
														local n45 = (n41 - v85[64]) * 0.035
														uiScale.Scale = 0
														billboardGui.Enabled = false
														task.delay(n45, function()
															if billboardGui.Parent and uiScale.Parent then
																billboardGui.Enabled = true
																tweenService:Create(uiScale, TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
															end
														end)
													end
													return fn61(billboardGui)
												end
												local function fn73(parent, cFrame)
													local ok, result = pcall(function()
														local attachment = Instance.new("Attachment")
														attachment.Name = "ICP_SlotTag"
														attachment.CFrame = cFrame
														attachment.Parent = parent
														return attachment
													end)
													if ok and result then
														tbl39[#tbl39 + 1] = result
														return result
													end
													return nil
												end
												local function iCollectProSweepSlotTags()
													local plots2 = workspace:FindFirstChild("Plots")
													if not plots2 then return end
													for _, child in ipairs(plots2:GetChildren()) do
														local v107 = child:FindFirstChild(v85[53])
														if v107 then
															for _, child2 in ipairs(v107:GetChildren()) do
																if child2:IsA("Attachment") and child2.Name == "ICP_SlotTag" then
																	pcall(function()
																		child2:Destroy()
																	end)
																end
															end
														end
													end
												end
												genv.iCollectPro_SweepSlotTags = iCollectProSweepSlotTags
												local v107 = nil
												local function createFolder()
													if v107 and v107.Parent then return v107 end
													local podiumStandFloors = workspace:FindFirstChild("__PodiumStandFloors")
													if podiumStandFloors then
														pcall(function()
															podiumStandFloors:Destroy()
														end)
													end
													local folder = Instance.new("Folder")
													folder.Name = "__PodiumStandFloors"
													folder.Parent = workspace
													v107 = folder
													return folder
												end
												local function fn74()
													if v107 and v107.Parent then
														pcall(function()
															v107:ClearAllChildren()
														end)
													end
												end
												local function iCollectProDropStandFloors()
													if v107 then
														pcall(function()
															v107:Destroy()
														end)
														v107 = nil
													end
													local podiumStandFloors = workspace:FindFirstChild("__PodiumStandFloors")
													if podiumStandFloors then
														pcall(function()
															podiumStandFloors:Destroy()
														end)
													end
												end
												genv.iCollectPro_DropStandFloors = iCollectProDropStandFloors
												local function fn75()
													local plots2 = workspace:FindFirstChild("Plots")
													if not plots2 then return 0 end
													local v108 = createFolder()
													local v109 = v85[164]
													local n42 = 0
													local n43 = 0
													local iCollectProStandFloorCount = 0
													for _, child in ipairs(plots2:GetChildren()) do
														local mainRoot = child:FindFirstChild("MainRoot")
														if not (mainRoot and mainRoot:IsA("BasePart")) then n42 += 1 end
														if mainRoot and mainRoot:IsA("BasePart") then
															n43 += 1
															for i, v110 in ipairs(tbl33) do
																if pcall(function()
																	local cframe = CFrame.Angles
																	local n44 = CFrame.new(v110[1], v110[2], v110[3]) * cframe(0, math.rad(v110[v85[169]]), 0)
																	local part = Instance.new("Part")
																	part.Name = child.Name .. "_Podium_" .. tostring(i)
																	part.Anchored = true
																	part.CanCollide = true
																	part.CanTouch = false
																	part.CanQuery = false
																	part.CastShadow = false
																	part.Transparency = 1
																	part.Size = vector
																	part.CFrame = mainRoot.CFrame * n44 * CFrame.new(0, -0.12, 0)
																	local pathfindingModifier = Instance.new("PathfindingModifier")
																	pathfindingModifier.PassThrough = true
																	pathfindingModifier.Parent = part
																	part.Parent = v108
																end) then
																	iCollectProStandFloorCount += 1
																else
																	v109 += 1
																end
															end
														end
													end
													print(("[iCollectPro] stand floors: plates=%d plots=%d failed=%d noMainRoot=%d"):format(iCollectProStandFloorCount, n43, v109, n42))
													genv.iCollectPro_StandFloorCount = iCollectProStandFloorCount
													return iCollectProStandFloorCount
												end
												local function fn76()
													if genv.iCollectPro_TpBusy and genv.iCollectPro_TpBusy() then return end
													local v108 = v107
													local flag24 = not v108 or not v108.Parent
													if not flag24 then
														local v109 = v85[164]
														flag24 = #v108:GetChildren() == v109
													end
													if flag24 then
														fn75()
														return
													end
													for _, child in ipairs(v108:GetChildren()) do
														if child:IsA("BasePart") and child.CanCollide ~= true then
															pcall(function()
																child.CanCollide = true
															end)
														end
													end
												end
												local tbl44 = {}
												local color3 = Color3.fromRGB(190, 74, 8)
												local color4 = Color3.fromRGB(226, 102, 12)
												local color5 = Color3.fromRGB
												tbl44[1] = color3
												tbl44[2] = color4
												do
													local values = table.pack(color5(255, 138, 28))
													table.move(values, 1, values.n, 3, tbl44)
												end
												local function fn77(arg)
													local iCollectProThemeIsHalloween2 = genv.iCollectPro_ThemeIsHalloween
													iCollectProThemeIsHalloween2 = iCollectProThemeIsHalloween2 and iCollectProThemeIsHalloween2() and tbl44 or tbl31.FLOOR_COLOR
													if arg <= 10 then return iCollectProThemeIsHalloween2[1] end
													if arg <= 18 then return iCollectProThemeIsHalloween2[2] end
													return iCollectProThemeIsHalloween2[3]
												end
												local function fn78(arg)
													local decorations = (arg:FindFirstChild("Base") or arg):FindFirstChild("Decorations")
													local tbl45 = {}
													if decorations then
														for _, child in ipairs(decorations:GetChildren()) do
															if child:IsA("BasePart") and child.Transparency < 1 then tbl45[#tbl45 + 1] = child end
														end
													end
													table.sort(tbl45, function(arg2, arg3)
														return arg2.Size.X * arg2.Size.Z > arg3.Size.X * arg3.Size.Z
													end)
													return tbl45
												end
												genv.iCollectPro_SlotCount = #tbl33
												genv.iCollectPro_SlotCF = function(arg, arg2)
													if typeof(arg) ~= "Instance" then return nil end
													local num = tonumber(arg2)
													if not num or not tbl33[num] then return nil end
													local animalPodiums2 = arg:FindFirstChild("AnimalPodiums")
													animalPodiums2 = animalPodiums2 and animalPodiums2:FindFirstChild(tostring(num))
													if animalPodiums2 then
														local ok, result = pcall(fn78, animalPodiums2)
														if ok and result and result[1] then
															local v108 = result[1]
															return CFrame.new(v108.Position + Vector3.new(0, v108.Size.Y * 0.5, v85[164])), true
														end
													end
													local mainRoot = arg:FindFirstChild("MainRoot")
													if mainRoot then
														local v108 = tbl33[num]
														local cframe = CFrame.Angles
														return CFrame.new((mainRoot.CFrame * (CFrame.new(v108[1], v108[v85[67]], v108[3]) * cframe(0, math.rad(v108[4]), 0))).Position + Vector3.new(0, vector2.Y * 0.5, 0)), false
													end
													return nil
												end
												local function fn79(arg, arg2, arg3)
													n39 = arg3 or 0
													local v108 = arg[1]
													for i, v109 in ipairs(arg) do
														local cFrame = v109.CFrame
														createBoxHandleAdornment(v108, v108.CFrame:Inverse() * cFrame, v109.Size + Vector3.new(0.03, 0.03, 0.03), arg2, i == 1 and 0.3 or 0.5, true)
														fn57(v109, arg2)
													end
													fn72(v108, arg3, arg2, v108.Size.Y * v85[140] + tbl32.HEIGHT)
												end
												local function fn80(arg, arg2, arg3, arg4)
													n39 = arg4 or 0
													local cframe = CFrame.Angles
													local n42 = CFrame.new(arg2[v85[64]], arg2[2], arg2[3]) * cframe(0, math.rad(arg2[v85[169]]), 0)
													createBoxHandleAdornment(arg, n42, vector2, arg3, n35 + n37, true)
													local n43 = n36 + n37
													createBoxHandleAdornment(arg, n42 * CFrame.new(v85[164], 0.25, 0), vector3, arg3, n43, true)
													fn58(arg, n42, vector2, arg3)
													local v108 = fn73(arg, n42)
													if v108 then fn72(v108, arg4, arg3, tbl32.HEIGHT) end
												end
												local function fn81(arg)
													local mainRoot = arg:FindFirstChild("MainRoot")
													if mainRoot and mainRoot:IsA("BasePart") then return mainRoot.Position end
													local ok, result = pcall(function()
														return arg:GetPivot().Position
													end)
													return ok and result or nil
												end
												local function fn82()
													if not plots then return nil end
													local character = localPlayer2.Character
													character = character and character:FindFirstChild("HumanoidRootPart")
													if not character then return nil end
													local v108 = nil
													local v109 = nil
													for _, child in ipairs(plots:GetChildren()) do
														local v110 = fn81(child)
														if v110 then
															local magnitude = (v110 - character.Position).Magnitude
															if not v108 or magnitude < v108 then
																v108 = magnitude
																v109 = child
															end
														end
													end
													return v109
												end
												local flag24 = false
												local function fn83()
													if not flag21 or not plots then return end
													fn56()
													flag23 = flag24
													n41 = 0
													now2 = flag24 and os.clock() or nil
													flag24 = false
													fn74()
													fn75()
													local v108 = v98
													if not v108 or not v108.Parent then
														v108 = fn82()
														v98 = v108
													end
													if v108 then
														fn55(v108)
														local mainRoot = v108:FindFirstChild("MainRoot")
														local animalPodiums2 = v108:FindFirstChild("AnimalPodiums")
														if mainRoot and animalPodiums2 then
															for i = 1, #tbl33 do
																local v109 = animalPodiums2:FindFirstChild(tostring(i))
																v109 = v109 and fn78(v109)
																local v110 = fn77(i)
																if v109 and v109[v85[64]] then
																	fn79(v109, v110, i)
																else
																	fn80(mainRoot, tbl33[i], v110, i)
																end
															end
														end
													end
												end
												genv.iCollectPro_RefreshSeeThrough = function()
													fn54()
													if flag21 then fn83() end
												end
												genv.iCollectPro_RebuildPodiums = function()
													if flag21 then
														flag24 = true
														fn83()
													end
												end
												genv.iCollectPro_PodiumNumbersOn = function() return tbl32.SHOW == true end
												genv.iCollectPro_SetPodiumNumbers = function(arg)
													local show = arg and true or false
													if show == tbl32.SHOW then return end
													tbl32.SHOW = show
													if flag21 then
														flag24 = show
														fn83()
													end
												end
												local flag25 = false
												local function fn84()
													if flag25 or not flag21 then return end
													flag25 = true
													task.delay(0.4, function()
														flag25 = false
														fn83()
													end)
												end
												local function fn85(arg)
													local animalPodiums2 = arg:WaitForChild("AnimalPodiums", 20)
													if animalPodiums2 and flag21 then
														tbl35[#tbl35 + 1] = fn31(animalPodiums2.ChildAdded, fn84)
														tbl35[#tbl35 + 1] = fn31(animalPodiums2.ChildRemoved, fn84)
													end
												end
												iCollectProPodiumESPCleanup = function()
													flag21 = false
													for _, v108 in ipairs(tbl35) do
														pcall(function()
															v108:Disconnect()
														end)
													end
													table.clear(tbl35)
													fn56()
													fn54()
													if v99 then
														pcall(function()
															v99:Destroy()
														end)
														v99 = nil
													end
													for k, v108 in pairs(tbl37) do
														pcall(function()
															if v108 then v108:Destroy() end
														end)
														tbl37[k] = nil
													end
													v98 = nil
													pcall(iCollectProSweepSlotTags)
													pcall(iCollectProDropStandFloors)
													genv.iCollectPro_PodiumESPCleanup = nil
												end
												fn59 = function()
													if genv.iCollectPro_PodiumESPCleanup then pcall(genv.iCollectPro_PodiumESPCleanup) end
													plots = workspace:FindFirstChild(v85[2]) or workspace:WaitForChild("Plots", 10)
													if not plots then return end
													local ipairs = ipairs
													local tbl45 = {}
													local workspace = workspace
													local CoreGui = game:GetService("CoreGui")
													tbl45[1] = workspace
													tbl45[2] = CoreGui
													tbl45[3] = v96
													for _, v110 in ipairs(tbl45) do
														for _, v111 in ipairs({ "__PodiumMarkers", "__PodiumTest", "__PodiumCollide", "__PodiumStandFloors" }) do
															local v112 = v110:FindFirstChild(v111)
															if v112 then v112:Destroy() end
														end
													end
													pcall(iCollectProSweepSlotTags)
													flag21 = true
													v98 = nil
													flag24 = v85[192]
													fn83()
													for _, child in ipairs(plots:GetChildren()) do task.spawn(fn85, child) end
													task.spawn(function()
														while flag21 and fn30() do
															local v110 = fn82()
															if v110 and v110 ~= v98 then
																v98 = v110
																fn83()
															end
															task.wait(0.5)
														end
													end)
													tbl35[#tbl35 + 1] = fn31(plots.ChildAdded, function(arg)
														task.spawn(fn85, arg)
														fn84()
													end)
													task.spawn(function()
														while flag21 and fn30() do
															pcall(fn76)
															task.wait(1)
														end
													end)
													local n42 = 0
													tbl35[#tbl35 + 1] = fn31(RunService2.Heartbeat, function(arg)
														n42 += arg
														if n42 < 0.05 then return end
														n42 = 0
														local now3 = os.clock()
														local color6 = Color3.new(v85[64], 1, 1)
														for _, v110 in ipairs(tbl34) do
															if v110.a.Parent then
																local v111 = math.sin(now3 * v97 - (v110.slot or 0) * v85[188])
																local base = v110.base
																if v110.pulse then base = math.clamp(v110.base + v111 * n38, 0, v85[64]) end
																if v110.t0 then
																	local n43 = (now3 - v110.t0) / 0.36
																	if n43 >= 1 then
																		v110.t0 = nil
																	elseif n43 <= 0 then
																		base = v85[64]
																	else
																		base = 1 - (1 - base) * n43
																	end
																end
																v110.a.Transparency = math.clamp(base, 0, v85[64])
																if v110.col then
																	local n43 = v111 > v85[164] and v111 ^ v85[70] * 0.45 or 0
																	local col = n43 > 0.004 and v110.col:Lerp(color6, n43) or v110.col
																	v110.a.Color3 = col
																	if v110.sel then v110.a.SurfaceColor3 = col end
																end
															end
														end
													end)
													local n43 = 0
													tbl35[#tbl35 + 1] = fn31(RunService2.Heartbeat, function(arg)
														n43 += arg
														if n43 < 0.04 then return end
														n43 = 0
														local ok, result = pcall(function()
															return service:GetMouseLocation()
														end)
														if not ok or not result then return end
														for i = #tbl36, 1, -v85[64] do
															local v110 = tbl36[i]
															local hitBox = v110 and v110.hitBox
															if not hitBox or not hitBox.Parent then
																table.remove(tbl36, i)
															else
																local absolutePosition = hitBox.AbsolutePosition
																local absoluteSize = hitBox.AbsoluteSize
																local flag26 = absoluteSize.X > 0 and result.X >= absolutePosition.X and result.X <= absolutePosition.X + absoluteSize.X and result.Y >= absolutePosition.Y and result.Y <= absolutePosition.Y + absoluteSize.Y
																if flag26 ~= (v110.hover == true) then fn68(v110, flag26) end
															end
														end
													end)
													local function fn86()
														local ok, result = pcall(function()
															return Enum.RaycastFilterType.Exclude
														end)
														if ok and result then return result end
														return Enum.RaycastFilterType.Blacklist
													end
													local v110 = fn86()
													local function fn87(arg)
														if arg:FindFirstAncestor("__PodiumStandFloors") then
															local match = tostring(arg.Name):match("_Podium_(%d+)$")
															return match and tonumber(match) or nil
														end
														local animalPodiums2 = arg:FindFirstAncestor("AnimalPodiums")
														if not animalPodiums2 then return nil end
														while arg and arg.Parent ~= animalPodiums2 do arg = arg.Parent end
														return arg and tonumber(arg.Name) or nil
													end
													local function fn88()
														local character = localPlayer2.Character
														local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
														if not humanoidRootPart then return nil end
														local raycastParams = RaycastParams.new()
														raycastParams.FilterType = v110
														raycastParams.IgnoreWater = true
														local filterDescendantsInstances = { character }
														local position = humanoidRootPart.Position
														local n44 = 7
														for i = 1, 6 do
															raycastParams.FilterDescendantsInstances = filterDescendantsInstances
															local ok, result = pcall(function()
																return workspace:Raycast(position, Vector3.new(v85[164], -n44, 0), raycastParams)
															end)
															if not ok or not result or not result.Instance then return nil end
															local instance4 = result.Instance
															local v111 = fn87(instance4)
															if v111 then return v111 end
															if instance4.CanCollide then return nil end
															n44 = n44 - (position.Y - result.Position.Y) - v85[130]
															if n44 <= 0 then return nil end
															position = result.Position - Vector3.new(0, 0.05, 0)
															filterDescendantsInstances[#filterDescendantsInstances + 1] = instance4
														end
														return nil
													end
													local n44 = 0
													tbl35[#tbl35 + 1] = fn31(RunService2.Heartbeat, function(arg)
														n44 += arg
														if n44 < 0.1 then return end
														n44 = 0
														local v111 = fn88()
														for i = #tbl36, 1, -1 do
															local v112 = tbl36[i]
															if not v112 or not v112.bb or not v112.bb.Parent then
																table.remove(tbl36, i)
															else
																local flag26 = v111 ~= nil and v112.slot == v111
																if flag26 ~= (v112.stand == true) then fn69(v112, flag26) end
															end
														end
													end)
													genv.iCollectPro_PodiumESPCleanup = iCollectProPodiumESPCleanup
												end
											end
											podiumEsp = fn52(frame3, "Podium ESP", 72 * v94)
											local function fn60()
												if genv.iCollectPro_PodiumCollideOn == v85[139] then
													fn34("PODIUM COLLISION", "TEMPORARILY UNAVAILABLE - ESP STILL WORKS, EMPTY SLOTS JUST DO NOT HOLD YOU UP", 6)
												end
											end
											podiumEsp.button.MouseButton1Click:Connect(function()
												podiumESP = not podiumESP
												v87.PodiumESP = podiumESP
												fn32()
												if podiumESP then
													fn59()
													fn60()
												else
													iCollectProPodiumESPCleanup()
												end
												tbl17.ListNeedsRedraw = false
												fn53(flag18, fn49())
											end)
											if podiumESP then
												task.spawn(fn59)
												task.spawn(fn60)
											end
											do
												local CoreGui = game:GetService("CoreGui")
												local tbl38 = {}
												local vector4 = Vector3.new(-342.439, 10.399, 113.107)
												local vector5 = Vector3.new(-342.439, 10.465, 6.107)
												local vector6 = Vector3.new(-476.752, 10.465, 114.107)
												local vector7 = Vector3.new(-476.752, 10.465, 7.107)
												local vector8 = Vector3.new(-342.44, 10.464, 220.107)
												local vector9 = Vector3.new(-476.752, 10.465, 221.107)
												local vector10 = Vector3.new(-342.439, 10.465, -100.893)
												local vector11 = Vector3.new
												tbl38[1] = vector4
												tbl38[2] = vector5
												tbl38[3] = vector6
												tbl38[4] = vector7
												tbl38[5] = vector8
												tbl38[6] = vector9
												tbl38[7] = vector10
												do
													local values = table.pack(vector11(-476.752, 10.465, -99.893))
													table.move(values, 1, values.n, 8, tbl38)
												end
												local v100 = utf8.char(11015)
												local tbl39 = {}
												local tbl40 = {}
												local tbl41 = {}
												local part = nil
												local billboardGui = nil
												local function fn61(arg)
													local ok, result = pcall(function()
														return (arg:GetBoundingBox())
													end)
													if not ok or not result then return nil end
													local position = result.Position
													local v101 = nil
													local v102 = nil
													for i, v103 in ipairs(tbl38) do
														local n40 = position.X - v103.X
														local n41 = position.Z - v103.Z
														local v104 = math.sqrt(n40 * n40 + n41 * n41)
														if not v101 or v104 < v101 then
															v101 = v104
															v102 = i
														end
													end
													return v101 and v101 <= 6 and v102 or nil
												end
												local function fn62(arg) return arg.Text:gsub("^%s+", ""):gsub("%s+$", "") == "Empty Base" end
												genv.iCollectPro_EmptyBasesInOrder = function()
													local tbl42 = {}
													local plots2 = workspace:FindFirstChild("Plots")
													if not plots2 then return tbl42 end
													for _, child in ipairs(plots2:GetChildren()) do
														local plotSign = child:FindFirstChild("PlotSign")
														local model = plotSign and plotSign:FindFirstChild("Model")
														plotSign = plotSign and plotSign:FindFirstChild("SurfaceGui")
														plotSign = plotSign and plotSign:FindFirstChild(v85[68])
														plotSign = plotSign and plotSign:FindFirstChild("TextLabel")
														if model and plotSign and fn62(plotSign) then
															local v101 = fn61(model)
															if v101 then tbl42[#tbl42 + 1] = { idx = v101, plot = child } end
														end
													end
													table.sort(tbl42, function(arg, arg2)
														return arg.idx < arg2.idx
													end)
													for i, v101 in ipairs(tbl42) do tbl42[i] = v101.plot end
													return tbl42
												end
												local function fn63()
													if not billboardGui or not part or not part.Parent then return end
													local v101 = nil
													for i = 1, #tbl38 do
														local v102 = tbl39[i]
														if v102 and v102.label and v102.label.Parent and fn62(v102.label) then
															v101 = i
															break
														else
															v101 = nil
														end
													end
													if v101 then
														part.CFrame = tbl39[v101].cf
														billboardGui.Enabled = v85[192]
														genv.iCollectPro_NextBaseIdx = v101
														genv.iCollectPro_NextBasePlot = tbl39[v101].plot
														genv.iCollectPro_NextBaseCF = tbl39[v101].cf
													else
														billboardGui.Enabled = false
														genv.iCollectPro_NextBaseIdx = nil
														genv.iCollectPro_NextBasePlot = nil
														genv.iCollectPro_NextBaseCF = nil
													end
												end
												local function fn64(arg)
													if tbl40[arg] then return end
													tbl40[arg] = v85[192]
													table.insert(tbl41, arg:GetPropertyChangedSignal("Text"):Connect(fn63))
												end
												local function fn65()
													local v101 = workspace:FindFirstChild(v85[2])
													if not v101 then return end
													for _, child in ipairs(v101:GetChildren()) do
														local plotSign = child:FindFirstChild("PlotSign")
														local model = plotSign and plotSign:FindFirstChild("Model")
														plotSign = plotSign and plotSign:FindFirstChild("SurfaceGui")
														plotSign = plotSign and plotSign:FindFirstChild("Frame")
														plotSign = plotSign and plotSign:FindFirstChild("TextLabel")
														if model and plotSign then
															local v102 = fn61(model)
															if v102 then
																tbl39[v102] = { label = plotSign, cf = select(1, model:GetBoundingBox()), plot = child }
																fn64(plotSign)
															end
														end
													end
													fn63()
												end
												local function iCollectProNextBaseCleanup()
													for _, v101 in ipairs(tbl41) do
														pcall(function()
															v101:Disconnect()
														end)
													end
													table.clear(tbl41)
													table.clear(tbl39)
													table.clear(tbl40)
													if part then
														pcall(function()
															part:Destroy()
														end)
													end
													part = nil
													billboardGui = nil
													genv.iCollectPro_NextBaseIdx = nil
													genv.iCollectPro_NextBasePlot = nil
													genv.iCollectPro_NextBaseCF = nil
													genv.iCollectPro_NextBaseCleanup = nil
												end
												local function fn66()
													if genv.iCollectPro_NextBaseCleanup then pcall(genv.iCollectPro_NextBaseCleanup) end
													local nextBaseAnchor = CoreGui:FindFirstChild("__NextBaseAnchor")
													if nextBaseAnchor then nextBaseAnchor:Destroy() end
													table.clear(tbl41)
													table.clear(tbl39)
													table.clear(tbl40)
													part = Instance.new("Part")
													part.Name = "__NextBaseAnchor"
													fn29(part)
													part.Anchored = true
													part.CanCollide = false
													part.CanQuery = v85[139]
													part.CanTouch = false
													part.Transparency = v85[64]
													part.Size = Vector3.new(v85[64], 1, 1)
													part.Parent = CoreGui
													billboardGui = Instance.new("BillboardGui")
													billboardGui.Name = "NextBaseBillboard"
													billboardGui.Adornee = part
													billboardGui.Size = UDim2.fromScale(32, v85[178])
													billboardGui.StudsOffset = Vector3.new(0, 10, 0)
													billboardGui.MaxDistance = math.huge
													billboardGui.AlwaysOnTop = v85[192]
													billboardGui.LightInfluence = 0
													billboardGui.Enabled = false
													billboardGui.Parent = part
													local textLabel2 = Instance.new("TextLabel", billboardGui)
													textLabel2.BackgroundTransparency = 1
													textLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
													textLabel2.Position = UDim2.fromScale(0.5, 0.3)
													textLabel2.Size = UDim2.fromScale(0.95, v85[140])
													textLabel2.Font = Enum.Font.GothamBlack
													textLabel2.Text = v100 .. "  NEXT  " .. v100
													textLabel2.TextScaled = true
													textLabel2.TextColor3 = Color3.fromRGB(128, 60, 255)
													textLabel2.TextStrokeColor3 = Color3.fromRGB(v85[164], v85[164], 0)
													textLabel2.TextStrokeTransparency = 0
													local textLabel3 = Instance.new("TextLabel", billboardGui)
													textLabel3.BackgroundTransparency = 1
													textLabel3.AnchorPoint = Vector2.new(0.5, v85[140])
													textLabel3.Position = UDim2.fromScale(0.5, 0.72)
													textLabel3.Size = UDim2.fromScale(0.95, 0.42)
													textLabel3.Font = Enum.Font.GothamBlack
													textLabel3.Text = "EMPTY BASE"
													textLabel3.TextScaled = v85[192]
													textLabel3.TextColor3 = Color3.fromRGB(v85[149], 255, 255)
													textLabel3.TextStrokeColor3 = Color3.fromRGB(0, 0, v85[164])
													textLabel3.TextStrokeTransparency = 0
													local plots2 = workspace:FindFirstChild(v85[2]) or workspace:WaitForChild("Plots", 10)
													if not plots2 then return end
													fn65()
													table.insert(tbl41, fn31(plots2.DescendantAdded, function(arg)
														if arg:IsA("TextLabel") then task.defer(fn65) end
													end))
													table.insert(tbl41, fn31(plots2.ChildAdded, function()
														task.defer(fn65)
													end))
													genv.iCollectPro_NextBaseCleanup = iCollectProNextBaseCleanup
												end
												nextBase = fn52(frame3, "Next Base", 108 * v94)
												nextBase.button.MouseButton1Click:Connect(function()
													nextBase2 = not nextBase2
													v87.NextBase = nextBase2
													fn32()
													if nextBase2 then
														fn66()
													else
														iCollectProNextBaseCleanup()
													end
													tbl17.ListNeedsRedraw = false
													fn53(flag18, fn49())
												end)
												if nextBase2 then task.spawn(fn66) end
											end
											antiDie = fn52(tbl28.list, "Anti Die", 36 * v94)
											do
												local flag22 = false
												local function fn61(arg)
													icollectproAntidieOn = arg and v85[192] or false
													genv.ICOLLECTPRO_ANTIDIE_ON = icollectproAntidieOn
													if icollectproAntidieOn then
														if genv.iCollectPro_AntiDieOn then pcall(genv.iCollectPro_AntiDieOn) end
													elseif genv.iCollectPro_AntiDieOff then
														pcall(genv.iCollectPro_AntiDieOff)
													end
													tbl17.ListNeedsRedraw = false
													fn53(flag18, fn49())
												end
												antiDie.button.MouseButton1Click:Connect(function()
													v87.AntiDie = not (v87.AntiDie ~= false)
													fn32()
													flag22 = v85[139]
													fn61(v87.AntiDie ~= false)
												end)
												local v100 = v85[139]
												local function fn62() return localPlayer2:GetAttribute("Stealing") and true or false end
												local function fn63()
													local v101 = fn62()
													if v101 and not v100 then
														if not icollectproAntidieOn then
															flag22 = true
															fn61(true)
															fn34("Anti Die is On", "held on while stealing")
														end
													elseif not v101 and v100 and flag22 then
														flag22 = false
														fn61(v87.AntiDie ~= false)
													end
													v100 = v101
												end
												fn31(localPlayer2:GetAttributeChangedSignal("Stealing"), fn63)
												task.spawn(function()
													while fn30() do
														fn63()
														task.wait(0.2)
													end
												end)
											end
											local v100 = iCollectProUIHost()
											local fn61
											do
												local function fn62(arg)
													return (tostring(arg):lower():gsub("’", ""):gsub("'", ""):gsub("%s+", " "):gsub("^ ", ""):gsub(" $", ""))
												end
												local tbl38 = {
													["flying carpet"] = true,
													["cupids wings"] = true,
													["santas sleigh"] = true,
													waverider = true,
													["wave rider"] = true,
													jetpack = true,
													["jet pack"] = true,
													hoverboard = true,
													broomstick = true,
													glider = true,
												}
												local tbl39 = { "carpet", "jetpack", "jet pack", "hoverboard", "glider", "broomstick", "waverider" }
												local function fn63(arg)
													local v101 = fn62(arg)
													if tbl38[v101] then return v85[192] end
													local v102 = fn62(v87.CarpetTool or "")
													if v102 ~= "" and v101 == v102 then return v85[192] end
													for _, v103 in ipairs(tbl39) do if v101:find(v103, v85[64], true) then return v85[192] end end
													return false
												end
												fn61 = function()
													local tbl40 = {}
													local tbl41 = {}
													local function fn64(arg)
														if not arg then return end
														for _, child in ipairs(arg:GetChildren()) do
															if child:IsA("Tool") and not tbl40[child.Name] and fn63(child.Name) then
																tbl40[child.Name] = v85[192]
																tbl41[#tbl41 + 1] = { name = child.Name, icon = child.TextureId or "" }
															end
														end
													end
													fn64(localPlayer2.Character)
													fn64(localPlayer2:FindFirstChildOfClass("Backpack"))
													table.sort(tbl41, function(arg, arg2)
														return arg.name < arg2.name
													end)
													return tbl41
												end
											end
											local textButton, v101, fn62
											do
												local frame5 = Instance.new("Frame", tbl28.list)
												frame5.Name = "FlyGearRow"
												frame5.Size = UDim2.new(1, 0, v85[164], math.floor(30 * v94))
												frame5.BackgroundColor3 = tbl29.SURF2
												frame5.BackgroundTransparency = 0.02
												frame5.BorderSizePixel = 0
												frame5.LayoutOrder = 7
												frame5.ZIndex = 103
												createUICorner2(frame5, 11)
												local v102 = createUIStroke2(frame5, tbl29.AQUA_STROKE, 1, 0.52)
												local textLabel2 = Instance.new("TextLabel", frame5)
												textLabel2.BackgroundTransparency = 1
												textLabel2.Position = UDim2.fromOffset(12, 0)
												textLabel2.Size = UDim2.new(1, -math.floor(118 * v94), 1, 0)
												textLabel2.TextTruncate = Enum.TextTruncate.AtEnd
												textLabel2.Font = Enum.Font.GothamBold
												textLabel2.Text = "Fly Gear"
												textLabel2.TextColor3 = tbl29.TEXT
												textLabel2.TextSize = v85[142] * v94
												textLabel2.TextXAlignment = Enum.TextXAlignment.Left
												textLabel2.ZIndex = 104
												textButton = Instance.new("TextButton", frame5)
												textButton.Name = "FlyGearChip"
												textButton.AutoButtonColor = false
												local floor2 = math.floor
												textButton.Size = UDim2.new(v85[164], math.floor(96 * v94), 0, floor2(22 * v94))
												local v103 = v85[140]
												textButton.Position = UDim2.new(1, -math.floor(106 * v94), v103, -math.floor(11 * v94))
												textButton.BackgroundColor3 = tbl29.OFF_BG
												textButton.BorderSizePixel = 0
												textButton.Font = Enum.Font.GothamBold
												textButton.TextSize = 11 * v94
												textButton.TextColor3 = tbl29.OFF_TEXT
												textButton.Text = "AUTO"
												textButton.TextTruncate = Enum.TextTruncate.AtEnd
												textButton.ZIndex = 104
												createUICorner2(textButton, v85[87])
												v101 = createUIStroke2(textButton, tbl29.AQUA_STROKE, 1, 0.55)
												fn62 = function()
													local text = tostring(v87.CarpetTool or "")
													if text == "" then
														textButton.Text = "AUTO"
														textButton.TextColor3 = tbl29.OFF_TEXT
														textButton.BackgroundColor3 = tbl29.OFF_BG
														v101.Color = tbl29.AQUA_STROKE
														v101.Transparency = v85[188]
													else
														textButton.Text = text
														textButton.TextColor3 = Color3.fromRGB(232, 255, 240)
														textButton.BackgroundColor3 = tbl29.GREEN1
														v101.Color = tbl29.GREEN_STROKE
														v101.Transparency = 0.22
													end
												end
												fn62()
												frame5.MouseEnter:Connect(function()
													fn50(frame5, 0.14, { BackgroundColor3 = Color3.fromRGB(62, 34, 96) })
													fn50(v102, 0.14, { Transparency = v85[41] })
												end)
												frame5.MouseLeave:Connect(function()
													fn50(frame5, 0.14, { BackgroundColor3 = tbl29.SURF2 })
													fn50(v102, 0.14, { Transparency = 0.52 })
												end)
											end
											local xkPqFlyGearPicker = v100:FindFirstChild("XkPqFlyGearPicker")
											if xkPqFlyGearPicker then xkPqFlyGearPicker:Destroy() end
											local screenGui2 = Instance.new("ScreenGui")
											screenGui2.Name = v85[113]
											fn29(screenGui2)
											screenGui2.ResetOnSpawn = false
											screenGui2.IgnoreGuiInset = true
											screenGui2.DisplayOrder = 1000
											screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
											screenGui2.Enabled = false
											screenGui2.Parent = v100
											local textButton2 = Instance.new("TextButton", screenGui2)
											textButton2.Name = "Scrim"
											textButton2.Size = UDim2.fromScale(1, v85[64])
											textButton2.BackgroundColor3 = Color3.new(v85[164], v85[164], 0)
											textButton2.BackgroundTransparency = 0.45
											textButton2.BorderSizePixel = v85[164]
											textButton2.Text = ""
											textButton2.AutoButtonColor = false
											textButton2.ZIndex = v85[126]
											local frame5 = Instance.new("Frame", textButton2)
											frame5.Name = "Card"
											frame5.AnchorPoint = Vector2.new(0.5, 0.5)
											frame5.Position = UDim2.fromScale(0.5, 0.5)
											frame5.Size = UDim2.fromOffset(396, 424)
											frame5.BackgroundColor3 = tbl29.BG
											frame5.BorderSizePixel = v85[164]
											frame5.Active = v85[192]
											frame5.ZIndex = 201
											createUICorner2(frame5, 20)
											createUIStroke2(frame5, tbl29.AQUA_STROKE, 1.4, 0.3)
											fn33(frame5)
											local v102 = v85[129]
											fn51(frame5, Color3.fromRGB(v85[199], v85[144], 60), Color3.fromRGB(14, 8, 24), v102)
											local imageLabel = Instance.new("ImageLabel", frame5)
											imageLabel.AnchorPoint = Vector2.new(v85[140], v85[140])
											imageLabel.Position = UDim2.new(0.5, 0, v85[140], 4)
											imageLabel.Size = UDim2.new(1, v85[194], 1, 40)
											imageLabel.BackgroundTransparency = 1
											imageLabel.Image = "rbxassetid://6014261993"
											imageLabel.ImageColor3 = Color3.new(0, 0, v85[164])
											imageLabel.ImageTransparency = v85[188]
											imageLabel.ScaleType = Enum.ScaleType.Slice
											imageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
											imageLabel.ZIndex = 200
											local textLabel2 = Instance.new("TextLabel", frame5)
											textLabel2.Size = UDim2.new(1, -96, 0, 22)
											textLabel2.Position = UDim2.fromOffset(48, 18)
											textLabel2.BackgroundTransparency = 1
											textLabel2.Text = "SELECT FLY GEAR"
											textLabel2.Font = Enum.Font.GothamBlack
											textLabel2.TextSize = v85[45]
											textLabel2.TextColor3 = tbl29.TEXT
											textLabel2.TextXAlignment = Enum.TextXAlignment.Center
											textLabel2.ZIndex = 202
											do
												local instance4 = Instance.new(v85[8], frame5)
												instance4.Size = UDim2.new(1, -96, v85[164], 14)
												instance4.Position = UDim2.fromOffset(48, 42)
												instance4.BackgroundTransparency = v85[64]
												instance4.Text = "from your backpack"
												instance4.Font = Enum.Font.GothamBold
												instance4.TextSize = v85[138]
												instance4.TextColor3 = tbl29.AQUA
												instance4.TextXAlignment = Enum.TextXAlignment.Center
												instance4.ZIndex = 202
												local textButton3 = Instance.new("TextButton", frame5)
												textButton3.AnchorPoint = Vector2.new(1, 0)
												textButton3.Position = UDim2.new(1, -16, v85[164], 18)
												textButton3.Size = UDim2.fromOffset(v85[182], v85[182])
												textButton3.BackgroundColor3 = tbl29.SURF2
												textButton3.BorderSizePixel = 0
												textButton3.Font = Enum.Font.GothamBlack
												textButton3.TextSize = 13
												textButton3.TextColor3 = tbl29.TEXT
												textButton3.Text = "X"
												textButton3.AutoButtonColor = false
												textButton3.ZIndex = 203
												createUICorner2(textButton3, v85[87])
												createUIStroke2(textButton3, tbl29.AQUA_STROKE, 1, 0.5)
												local frame6 = Instance.new("Frame", frame5)
												frame6.AnchorPoint = Vector2.new(0.5, 0)
												frame6.Position = UDim2.new(v85[140], 0, 0, 66)
												frame6.Size = UDim2.new(1, -44, v85[164], 1)
												frame6.BackgroundColor3 = Color3.fromRGB(v85[149], 255, 255)
												frame6.BackgroundTransparency = 0.85
												frame6.BorderSizePixel = 0
												frame6.ZIndex = 202
												local scrollingFrame = Instance.new("ScrollingFrame", frame5)
												scrollingFrame.Position = UDim2.fromOffset(v85[45], 98)
												scrollingFrame.Size = UDim2.new(1, -32, 1, -118)
												scrollingFrame.BackgroundTransparency = 1
												scrollingFrame.BorderSizePixel = 0
												scrollingFrame.ScrollBarThickness = 4
												scrollingFrame.ScrollBarImageColor3 = tbl29.AQUA
												scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
												scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
												scrollingFrame.ZIndex = 202
												local uiGridLayout = Instance.new("UIGridLayout", scrollingFrame)
												uiGridLayout.CellSize = UDim2.fromOffset(108, 128)
												uiGridLayout.CellPadding = UDim2.fromOffset(10, v85[138])
												uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
												uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
												local function fn63() screenGui2.Enabled = false end
												textButton3.MouseButton1Click:Connect(fn63)
												textButton2.MouseButton1Click:Connect(fn63)
												local function fn64(arg, layoutOrder)
													local name = arg.name
													local flag22 = name == ""
													local visible = tostring(v87.CarpetTool or "") == name
													local textButton4 = Instance.new("TextButton", scrollingFrame)
													textButton4.LayoutOrder = layoutOrder
													textButton4.BackgroundColor3 = visible and tbl29.GREEN1 or tbl29.SURF
													textButton4.BorderSizePixel = 0
													textButton4.Text = ""
													textButton4.AutoButtonColor = false
													textButton4.ZIndex = 203
													createUICorner2(textButton4, 14)
													local v103 = createUIStroke2(textButton4, visible and tbl29.GREEN_STROKE or tbl29.AQUA_STROKE, visible and 1.6 or 1.2, visible and 0.1 or 0.55)
													local uiGradient = Instance.new("UIGradient", textButton4)
													uiGradient.Rotation = 90
													local function fn65(arg2)
														if arg2 then
															local new = ColorSequenceKeypoint.new
															local color3 = Color3.fromRGB
															local v104 = v85[184]
															uiGradient.Color = ColorSequence.new({
																ColorSequenceKeypoint.new(v85[164], Color3.fromRGB(30, 118, 78)),
																new(1, color3(14, 66, v104)),
															})
														else
															local new = ColorSequenceKeypoint.new
															local v104 = v85[64]
															local color3 = Color3.fromRGB
															uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(46, 27, 74)), new(v104, color3(24, 14, 40)) })
														end
													end
													fn65(visible)
													local frame7 = Instance.new("Frame", textButton4)
													frame7.AnchorPoint = Vector2.new(0.5, 0)
													frame7.Position = UDim2.new(0.5, 0, v85[164], 10)
													frame7.Size = UDim2.fromOffset(72, v85[101])
													frame7.BackgroundColor3 = Color3.fromRGB(14, 9, 24)
													frame7.BorderSizePixel = 0
													frame7.ZIndex = 204
													createUICorner2(frame7, v85[142])
													createUIStroke2(frame7, visible and tbl29.GREEN_STROKE or tbl29.AQUA_STROKE, 1, visible and 0.45 or 0.72)
													fn51(frame7, Color3.fromRGB(26, 16, 42), Color3.fromRGB(12, 7, 20), 90)
													if arg.icon and arg.icon ~= "" then
														local imageLabel2 = Instance.new("ImageLabel", frame7)
														imageLabel2.AnchorPoint = Vector2.new(0.5, v85[140])
														imageLabel2.Position = UDim2.fromScale(0.5, 0.5)
														imageLabel2.Size = UDim2.fromOffset(58, 58)
														imageLabel2.BackgroundTransparency = 1
														imageLabel2.Image = arg.icon
														imageLabel2.ScaleType = Enum.ScaleType.Fit
														imageLabel2.ZIndex = 205
													else
														local textLabel3 = Instance.new("TextLabel", frame7)
														textLabel3.Size = UDim2.fromScale(v85[64], 1)
														textLabel3.BackgroundTransparency = 1
														textLabel3.Font = Enum.Font.GothamBlack
														textLabel3.TextSize = flag22 and 16 or 24
														textLabel3.TextColor3 = tbl29.AQUA
														local str6 = flag22 and "AUTO"
														local text
														if str6 then
															text = str6
														else
															text = name:sub(1, v85[64]):upper()
														end
														textLabel3.Text = text
														textLabel3.ZIndex = 205
													end
													local textLabel3 = Instance.new("TextLabel", textButton4)
													textLabel3.Position = UDim2.fromOffset(6, 88)
													textLabel3.Size = UDim2.new(1, -12, 0, 32)
													textLabel3.BackgroundTransparency = 1
													textLabel3.Font = Enum.Font.GothamBold
													textLabel3.TextSize = 10
													textLabel3.TextColor3 = visible and Color3.fromRGB(216, 255, 232) or tbl29.TEXT
													textLabel3.TextWrapped = true
													textLabel3.TextYAlignment = Enum.TextYAlignment.Top
													textLabel3.Text = flag22 and "Auto (first mount found)" or name
													textLabel3.ZIndex = 204
													local instance5 = Instance.new(v85[8], textButton4)
													instance5.AnchorPoint = Vector2.new(1, 0)
													instance5.Position = UDim2.new(1, -8, 0, 8)
													instance5.Size = UDim2.fromOffset(18, 18)
													instance5.BackgroundColor3 = tbl29.GREEN2
													instance5.BorderSizePixel = v85[164]
													instance5.Font = Enum.Font.GothamBlack
													instance5.TextSize = 11
													instance5.TextColor3 = Color3.fromRGB(v85[16], 255, 240)
													instance5.Text = "✓"
													instance5.Visible = visible
													instance5.ZIndex = 206
													createUICorner2(instance5, 9)
													createUIStroke2(instance5, tbl29.GREEN_STROKE, 1, 0.3)
													textButton4.MouseEnter:Connect(function()
														if tostring(v87.CarpetTool or "") ~= name then
															v103.Transparency = v85[123]
															local new = ColorSequenceKeypoint.new
															local color3 = Color3.fromRGB
															uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(v85[164], Color3.fromRGB(64, 38, 102)), new(1, color3(34, 20, 56)) })
														end
													end)
													textButton4.MouseLeave:Connect(function()
														if tostring(v87.CarpetTool or "") ~= name then
															v103.Transparency = 0.55
															fn65(false)
														end
													end)
													textButton4.MouseButton1Click:Connect(function()
														v87.CarpetTool = name
														fn32()
														fn62()
														fn63()
														fn34("Fly Gear", flag22 and "auto-pick" or name)
													end)
												end
												local function fn65()
													for _, child in ipairs(scrollingFrame:GetChildren()) do
														if child:IsA("TextButton") then child:Destroy() end
													end
													local v103 = fn61()
													fn64({ name = "", icon = "" }, v85[64])
													local n40 = 1
													for _, v104 in ipairs(v103) do
														n40 += 1
														fn64(v104, n40)
													end
													if #v103 == 0 then
														instance4.Text = "no fly gear in your backpack"
													elseif #v103 == v85[64] then
														instance4.Text = "1 fly gear in your backpack"
													else
														instance4.Text = string.format("%d fly gear in your backpack", #v103)
													end
													scrollingFrame.CanvasSize = UDim2.new(0, v85[164], 0, math.max(v85[64], math.ceil(n40 / 3)) * 138 + 8)
												end
												textButton.MouseButton1Click:Connect(function()
													if screenGui2.Enabled then
														fn63()
													else
														fn65()
														screenGui2.Enabled = v85[192]
														local refreshMobileScaleFor = tbl17.RefreshMobileScaleFor
														if refreshMobileScaleFor then
															task.defer(refreshMobileScaleFor, frame5)
															task.delay(0.1, refreshMobileScaleFor, frame5)
														end
													end
												end)
											end
											textButton.MouseEnter:Connect(function()
												fn50(v101, 0.14, { Transparency = 0.2 })
											end)
											textButton.MouseLeave:Connect(function()
												fn50(v101, 0.14, { Transparency = tostring(v87.CarpetTool or "") == "" and v85[188] or v85[146] })
											end)
											local tbl38
											do
												local v103 = iCollectProUIHost()
												local function fn63(arg, arg2, arg3, arg4)
													local textButton3 = Instance.new("TextButton", arg)
													textButton3.Name = arg4:gsub("%s+", "") .. "Pill"
													textButton3.AutoButtonColor = false
													local floor2 = math.floor
													local n40 = 22 * v94
													textButton3.Size = UDim2.new(0.5, -math.floor(12 * v94), 0, floor2(n40))
													textButton3.Position = UDim2.new(arg2, arg3, 0.5, -math.floor(11 * v94))
													textButton3.BackgroundColor3 = tbl29.OFF_BG
													textButton3.BorderSizePixel = 0
													textButton3.Text = ""
													textButton3.ZIndex = v85[60]
													createUICorner2(textButton3, 7)
													local v104 = createUIStroke2(textButton3, tbl29.AQUA_STROKE, 1, 0.55)
													local frame6 = Instance.new("Frame", textButton3)
													frame6.Size = UDim2.new(1, 0, v85[64], 0)
													frame6.BackgroundTransparency = v85[64]
													frame6.BorderSizePixel = v85[164]
													frame6.ZIndex = v85[60]
													createUICorner2(frame6, 7)
													fn51(frame6, tbl29.GREEN1, tbl29.GREEN2, v85[164])
													local instance4 = Instance.new(v85[8], textButton3)
													instance4.BackgroundTransparency = 1
													instance4.Size = UDim2.fromScale(1, 1)
													instance4.Font = Enum.Font.GothamBold
													instance4.TextSize = 11 * v94
													instance4.Text = arg4:upper()
													instance4.TextColor3 = tbl29.OFF_TEXT
													instance4.ZIndex = 105
													return { button = textButton3, knob = frame6, stateLabel = instance4, stroke = v104 }
												end
												tbl38 = {
													head = function(arg, layoutOrder, text)
														local frame6 = Instance.new("Frame", arg)
														frame6.Size = UDim2.new(1, -v85[167], 0, math.floor(22 * v94))
														frame6.BackgroundTransparency = 1
														frame6.LayoutOrder = layoutOrder
														frame6.ZIndex = 203
														local textLabel3 = Instance.new("TextLabel", frame6)
														textLabel3.BackgroundTransparency = 1
														textLabel3.Position = UDim2.fromOffset(4, 0)
														textLabel3.Size = UDim2.new(1, -8, v85[64], 0)
														textLabel3.Font = Enum.Font.GothamBlack
														textLabel3.Text = text
														textLabel3.TextColor3 = tbl29.AQUA
														textLabel3.TextSize = 10 * v94
														textLabel3.TextXAlignment = Enum.TextXAlignment.Left
														textLabel3.ZIndex = 204
														return textLabel3
													end,
													chipRow = function(arg, layoutOrder, text, arg2)
														local frame6 = Instance.new("Frame", arg)
														frame6.Name = text:gsub("%s+", "") .. "Row"
														frame6.Size = UDim2.new(1, 0, v85[164], math.floor(30 * v94))
														frame6.BackgroundColor3 = tbl29.SURF2
														frame6.BackgroundTransparency = 0.02
														frame6.BorderSizePixel = 0
														frame6.LayoutOrder = layoutOrder
														frame6.ZIndex = 103
														createUICorner2(frame6, 11)
														local v104 = createUIStroke2(frame6, tbl29.AQUA_STROKE, 1, 0.52)
														local instance4 = Instance.new(v85[8], frame6)
														instance4.BackgroundTransparency = 1
														instance4.Position = UDim2.fromOffset(12, v85[164])
														local v105 = v85[64]
														instance4.Size = UDim2.new(1, -math.floor(118 * v94), v105, 0)
														instance4.TextTruncate = Enum.TextTruncate.AtEnd
														instance4.Font = Enum.Font.GothamBold
														instance4.Text = text
														instance4.TextColor3 = tbl29.TEXT
														instance4.TextSize = 12 * v94
														instance4.TextXAlignment = Enum.TextXAlignment.Left
														instance4.ZIndex = 104
														local textButton3 = Instance.new("TextButton", frame6)
														textButton3.AutoButtonColor = false
														local v106 = v85[164]
														local floor2 = math.floor
														local n40 = 22 * v94
														textButton3.Size = UDim2.new(v85[164], math.floor(96 * v94), v106, floor2(n40))
														local v107 = v85[140]
														textButton3.Position = UDim2.new(1, -math.floor(106 * v94), v107, -math.floor(11 * v94))
														textButton3.BackgroundColor3 = tbl29.OFF_BG
														textButton3.BorderSizePixel = 0
														textButton3.Font = Enum.Font.GothamBold
														textButton3.TextSize = 11 * v94
														textButton3.TextColor3 = tbl29.OFF_TEXT
														textButton3.Text = v85[121]
														textButton3.TextTruncate = Enum.TextTruncate.AtEnd
														textButton3.ZIndex = v85[60]
														createUICorner2(textButton3, 7)
														local v108 = createUIStroke2(textButton3, tbl29.AQUA_STROKE, v85[64], 0.55)
														frame6.MouseEnter:Connect(function()
															fn50(frame6, 0.14, { BackgroundColor3 = Color3.fromRGB(62, v85[81], 96) })
															fn50(v104, 0.14, { Transparency = 0.38 })
														end)
														frame6.MouseLeave:Connect(function()
															fn50(frame6, 0.14, { BackgroundColor3 = tbl29.SURF2 })
															fn50(v104, 0.14, { Transparency = 0.52 })
														end)
														textButton3.MouseButton1Click:Connect(arg2)
														return function(text2, arg3)
															textButton3.Text = text2
															if arg3 then
																textButton3.BackgroundColor3 = tbl29.GREEN1
																textButton3.TextColor3 = Color3.fromRGB(232, 255, v85[173])
																v108.Color = tbl29.GREEN_STROKE
																v108.Transparency = v85[146]
															else
																textButton3.BackgroundColor3 = tbl29.OFF_BG
																textButton3.TextColor3 = tbl29.OFF_TEXT
																v108.Color = tbl29.AQUA_STROKE
																v108.Transparency = 0.55
															end
														end
													end,
													pair = function(arg, layoutOrder, arg2, arg3)
														local frame6 = Instance.new("Frame", arg)
														frame6.Name = arg2:gsub("%s+", "") .. arg3:gsub("%s+", "") .. "Row"
														frame6.Size = UDim2.new(1, 0, 0, math.floor(30 * v94))
														frame6.BackgroundColor3 = tbl29.SURF2
														frame6.BackgroundTransparency = 0.02
														frame6.BorderSizePixel = 0
														frame6.LayoutOrder = layoutOrder
														frame6.ZIndex = 103
														createUICorner2(frame6, 11)
														local v104 = createUIStroke2(frame6, tbl29.AQUA_STROKE, 1, 0.52)
														local v105 = fn63(frame6, 0, math.floor(8 * v94), arg2)
														local v106 = fn63(frame6, 0.5, math.floor(4 * v94), arg3)
														frame6.MouseEnter:Connect(function()
															fn50(frame6, 0.14, { BackgroundColor3 = Color3.fromRGB(62, v85[81], 96) })
															fn50(v104, 0.14, { Transparency = 0.38 })
														end)
														frame6.MouseLeave:Connect(function()
															fn50(frame6, 0.14, { BackgroundColor3 = tbl29.SURF2 })
															fn50(v104, 0.14, { Transparency = v85[127] })
														end)
														v105.row = frame6
														v106.row = frame6
														v105.rowStroke = v104
														v106.rowStroke = v104
														return { row = frame6, left = v105, right = v106 }
													end,
													paint = function(arg, arg2)
														if arg2 then
															arg.button.BackgroundColor3 = tbl29.GREEN1
															arg.knob.BackgroundTransparency = 0
															arg.stateLabel.Text = v85[176]
															arg.stateLabel.TextColor3 = Color3.fromRGB(232, 255, 240)
															arg.stroke.Color = tbl29.GREEN_STROKE
															arg.stroke.Transparency = 0.22
														else
															arg.button.BackgroundColor3 = tbl29.OFF_BG
															arg.knob.BackgroundTransparency = 1
															arg.stateLabel.Text = "OFF"
															arg.stateLabel.TextColor3 = tbl29.OFF_TEXT
															arg.stroke.Color = tbl29.AQUA_STROKE
															arg.stroke.Transparency = 0.55
														end
														if arg.rowStroke then arg.rowStroke.Transparency = arg2 and 0.38 or v85[127] end
													end,
													card = function(name, text, arg, arg2)
														local v104 = v103:FindFirstChild(name)
														if v104 then v104:Destroy() end
														local screenGui3 = Instance.new("ScreenGui")
														screenGui3.Name = name
														screenGui3.ResetOnSpawn = false
														screenGui3.IgnoreGuiInset = v85[192]
														screenGui3.DisplayOrder = 1000
														screenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
														screenGui3.Enabled = v85[139]
														fn29(screenGui3)
														screenGui3.Parent = v103
														local textButton3 = Instance.new("TextButton", screenGui3)
														textButton3.Size = UDim2.fromScale(v85[64], v85[64])
														textButton3.BackgroundColor3 = Color3.new(0, 0, 0)
														textButton3.BackgroundTransparency = 0.45
														textButton3.BorderSizePixel = 0
														textButton3.Text = ""
														textButton3.AutoButtonColor = v85[139]
														textButton3.ZIndex = 200
														local instance4 = Instance.new(v85[68], textButton3)
														instance4.AnchorPoint = Vector2.new(0.5, 0.5)
														instance4.Position = UDim2.fromScale(0.5, 0.5)
														instance4.Size = UDim2.fromOffset(arg, arg2)
														instance4.BackgroundColor3 = tbl29.BG
														instance4.BorderSizePixel = 0
														instance4.Active = true
														instance4.ZIndex = 201
														createUICorner2(instance4, 20)
														createUIStroke2(instance4, tbl29.AQUA_STROKE, 1.4, 0.3)
														fn33(instance4)
														fn51(instance4, Color3.fromRGB(v85[199], v85[144], 60), Color3.fromRGB(14, v85[82], 24), 90)
														local imageLabel2 = Instance.new("ImageLabel", instance4)
														imageLabel2.AnchorPoint = Vector2.new(v85[140], 0.5)
														imageLabel2.Position = UDim2.new(v85[140], 0, 0.5, 4)
														imageLabel2.Size = UDim2.new(1, 40, v85[64], 40)
														imageLabel2.BackgroundTransparency = 1
														imageLabel2.Image = "rbxassetid://6014261993"
														imageLabel2.ImageColor3 = Color3.new(v85[164], 0, 0)
														imageLabel2.ImageTransparency = 0.55
														imageLabel2.ScaleType = Enum.ScaleType.Slice
														imageLabel2.SliceCenter = Rect.new(v85[56], 49, 450, 450)
														imageLabel2.ZIndex = v85[126]
														local textLabel3 = Instance.new("TextLabel", instance4)
														textLabel3.Size = UDim2.new(v85[64], -v85[191], v85[164], 24)
														textLabel3.Position = UDim2.fromOffset(48, 14)
														textLabel3.BackgroundTransparency = 1
														textLabel3.Text = text
														textLabel3.Font = Enum.Font.GothamBlack
														textLabel3.TextSize = 18
														textLabel3.TextColor3 = tbl29.TEXT
														textLabel3.TextXAlignment = Enum.TextXAlignment.Center
														textLabel3.ZIndex = 202
														local textButton4 = Instance.new("TextButton", instance4)
														textButton4.AnchorPoint = Vector2.new(1, 0)
														textButton4.Position = UDim2.new(v85[64], -16, 0, v85[46])
														textButton4.Size = UDim2.fromOffset(26, 26)
														textButton4.BackgroundColor3 = tbl29.SURF2
														textButton4.BorderSizePixel = 0
														textButton4.Font = Enum.Font.GothamBlack
														textButton4.TextSize = 13
														textButton4.TextColor3 = tbl29.TEXT
														textButton4.Text = "X"
														textButton4.AutoButtonColor = v85[139]
														textButton4.ZIndex = 203
														createUICorner2(textButton4, 7)
														createUIStroke2(textButton4, tbl29.AQUA_STROKE, 1, v85[140])
														local instance5 = Instance.new(v85[68], instance4)
														instance5.AnchorPoint = Vector2.new(v85[140], 0)
														instance5.Position = UDim2.new(v85[140], 0, 0, 44)
														instance5.Size = UDim2.new(0, 124, 0, v85[64])
														instance5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
														instance5.BackgroundTransparency = 0.15
														instance5.BorderSizePixel = 0
														instance5.ZIndex = 202
														local instance6 = Instance.new(v85[68], instance4)
														instance6.Name = v85[97]
														instance6.Position = UDim2.fromOffset(10, 54)
														instance6.Size = UDim2.new(v85[64], -20, v85[64], -64)
														instance6.BackgroundColor3 = tbl29.SURF
														instance6.BorderSizePixel = 0
														instance6.ZIndex = 201
														createUICorner2(instance6, 16)
														createUIStroke2(instance6, tbl29.AQUA_STROKE, v85[64], 0.48)
														local scrollingFrame = Instance.new("ScrollingFrame", instance6)
														scrollingFrame.Position = UDim2.fromOffset(v85[169], v85[169])
														scrollingFrame.Size = UDim2.new(1, -v85[82], v85[64], -8)
														scrollingFrame.BackgroundTransparency = 1
														scrollingFrame.BorderSizePixel = 0
														scrollingFrame.ScrollBarThickness = 4
														scrollingFrame.ScrollBarImageColor3 = tbl29.AQUA
														scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
														scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
														scrollingFrame.ZIndex = 202
														local uiListLayout2 = Instance.new("UIListLayout", scrollingFrame)
														uiListLayout2.Padding = UDim.new(0, v85[167])
														uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
														scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
														scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
														local uiPadding = Instance.new("UIPadding", scrollingFrame)
														uiPadding.PaddingTop = UDim.new(0, 4)
														uiPadding.PaddingBottom = UDim.new(0, v85[167])
														local tbl39 = {
															gui = screenGui3,
															body = scrollingFrame,
															card = instance4,
															close = function()
																screenGui3.Enabled = false
															end,
															open = function()
																screenGui3.Enabled = true
																local refreshMobileScaleFor = tbl17.RefreshMobileScaleFor
																if refreshMobileScaleFor then
																	task.defer(refreshMobileScaleFor, instance4)
																	task.delay(0.1, refreshMobileScaleFor, instance4)
																end
															end,
															toggle = function()
																if screenGui3.Enabled then
																	tbl39.close()
																else
																	tbl39.open()
																end
															end,
														}
														textButton4.MouseButton1Click:Connect(tbl39.close)
														textButton3.MouseButton1Click:Connect(tbl39.close)
														return tbl39
													end,
													opt = function(arg, layoutOrder, text, arg2, arg3)
														local instance4 = Instance.new(v85[68], arg)
														instance4.Size = UDim2.new(1, -6, 0, math.floor(38 * v94))
														instance4.BackgroundColor3 = tbl29.SURF2
														instance4.BorderSizePixel = v85[164]
														instance4.LayoutOrder = layoutOrder
														instance4.ZIndex = 203
														createUICorner2(instance4, 11)
														local v104 = createUIStroke2(instance4, tbl29.AQUA_STROKE, 1, 0.52)
														local textLabel3 = Instance.new("TextLabel", instance4)
														textLabel3.BackgroundTransparency = 1
														textLabel3.Position = UDim2.fromOffset(v85[142], 0)
														local v105 = v85[64]
														textLabel3.Size = UDim2.new(1, -math.floor(104 * v94), v105, 0)
														textLabel3.TextTruncate = Enum.TextTruncate.AtEnd
														textLabel3.Font = Enum.Font.GothamBold
														textLabel3.Text = text
														textLabel3.TextColor3 = tbl29.TEXT
														textLabel3.TextSize = 12 * v94
														textLabel3.TextXAlignment = Enum.TextXAlignment.Left
														textLabel3.ZIndex = 204
														local textButton3 = Instance.new("TextButton", instance4)
														textButton3.AutoButtonColor = v85[139]
														local floor2 = math.floor
														local n40 = 22 * v94
														textButton3.Size = UDim2.fromOffset(math.floor(72 * v94), floor2(n40))
														textButton3.Position = UDim2.new(1, -math.floor(84 * v94), 0.5, -math.floor(11 * v94))
														textButton3.BackgroundColor3 = tbl29.OFF_BG
														textButton3.BorderSizePixel = 0
														textButton3.Font = Enum.Font.GothamBold
														textButton3.TextSize = 11 * v94
														textButton3.Text = v85[121]
														textButton3.TextColor3 = tbl29.OFF_TEXT
														textButton3.ZIndex = 204
														createUICorner2(textButton3, 7)
														local v106 = createUIStroke2(textButton3, tbl29.AQUA_STROKE, 1, 0.55)
														local function fn64()
															if arg2() and v85[192] then
																textButton3.BackgroundColor3 = tbl29.GREEN1
																textButton3.Text = "ON"
																textButton3.TextColor3 = Color3.fromRGB(232, v85[149], 240)
																v106.Color = tbl29.GREEN_STROKE
																v106.Transparency = v85[146]
																v104.Transparency = 0.38
															else
																textButton3.BackgroundColor3 = tbl29.OFF_BG
																textButton3.Text = "OFF"
																textButton3.TextColor3 = tbl29.OFF_TEXT
																v106.Color = tbl29.AQUA_STROKE
																v106.Transparency = v85[188]
																v104.Transparency = v85[127]
															end
														end
														textButton3.MouseButton1Click:Connect(function()
															arg3(not (arg2() and v85[192] or false))
															fn64()
														end)
														fn64()
														return fn64
													end,
													key = function(arg, layoutOrder, text, arg2, arg3)
														local instance4 = Instance.new(v85[68], arg)
														instance4.Name = text:gsub("%s+", "") .. "KeyRow"
														instance4.Size = UDim2.new(1, -v85[167], 0, math.floor(30 * v94))
														instance4.BackgroundColor3 = tbl29.SURF2
														instance4.BackgroundTransparency = v85[198]
														instance4.BorderSizePixel = 0
														instance4.LayoutOrder = layoutOrder
														instance4.ZIndex = 203
														createUICorner2(instance4, 11)
														local v104 = createUIStroke2(instance4, tbl29.AQUA_STROKE, 1, 0.52)
														local textLabel3 = Instance.new("TextLabel", instance4)
														textLabel3.BackgroundTransparency = 1
														textLabel3.Position = UDim2.fromOffset(12, v85[164])
														textLabel3.Size = UDim2.new(1, -math.floor(118 * v94), 1, 0)
														textLabel3.TextTruncate = Enum.TextTruncate.AtEnd
														textLabel3.Font = Enum.Font.GothamBold
														textLabel3.Text = text
														textLabel3.TextColor3 = tbl29.TEXT
														textLabel3.TextSize = 12 * v94
														textLabel3.TextXAlignment = Enum.TextXAlignment.Left
														textLabel3.ZIndex = 204
														local textButton3 = Instance.new("TextButton", instance4)
														textButton3.AutoButtonColor = false
														local floor2 = math.floor
														local n40 = 22 * v94
														textButton3.Size = UDim2.new(0, math.floor(96 * v94), 0, floor2(n40))
														textButton3.Position = UDim2.new(1, -math.floor(106 * v94), 0.5, -math.floor(11 * v94))
														textButton3.BackgroundColor3 = tbl29.OFF_BG
														textButton3.BorderSizePixel = 0
														textButton3.Font = Enum.Font.GothamBold
														textButton3.TextSize = 11 * v94
														textButton3.TextColor3 = tbl29.OFF_TEXT
														textButton3.Text = "NONE"
														textButton3.TextTruncate = Enum.TextTruncate.AtEnd
														textButton3.ZIndex = 204
														createUICorner2(textButton3, v85[87])
														local v105 = createUIStroke2(textButton3, tbl29.AQUA_STROKE, 1, 0.55)
														local function fn64()
															local text2 = tostring(v87[arg2] or "NONE")
															if text2 == "NONE" then
																textButton3.Text = v85[112]
																textButton3.BackgroundColor3 = tbl29.OFF_BG
																textButton3.TextColor3 = tbl29.OFF_TEXT
																v105.Color = tbl29.AQUA_STROKE
																v105.Transparency = 0.55
																v104.Transparency = 0.52
															else
																textButton3.Text = text2
																textButton3.BackgroundColor3 = tbl29.GREEN1
																textButton3.TextColor3 = Color3.fromRGB(232, v85[149], 240)
																v105.Color = tbl29.GREEN_STROKE
																v105.Transparency = 0.22
																v104.Transparency = 0.38
															end
														end
														fn64()
														instance4.MouseEnter:Connect(function()
															fn50(instance4, 0.14, { BackgroundColor3 = Color3.fromRGB(62, v85[81], v85[191]) })
														end)
														instance4.MouseLeave:Connect(function()
															fn50(instance4, 0.14, { BackgroundColor3 = tbl29.SURF2 })
														end)
														local tbl39 = { [Enum.KeyCode.Backspace] = true, [Enum.KeyCode.Delete] = v85[192], [Enum.KeyCode.Escape] = true }
														local flag22 = false
														local v106 = nil
														textButton3.MouseButton1Click:Connect(function()
															if flag22 then return end
															flag22 = true
															textButton3.Text = "press a key"
															textButton3.BackgroundColor3 = tbl29.SURF
															textButton3.TextColor3 = tbl29.AQUA
															v105.Color = tbl29.AQUA_STROKE
															v105.Transparency = 0.2
															v106 = fn31(service.InputBegan, function(arg4, arg5)
																if arg5 or arg4.UserInputType ~= Enum.UserInputType.Keyboard then return end
																local name = arg4.KeyCode.Name
																if name == "Unknown" then return end
																if v106 then
																	v106:Disconnect()
																	v106 = nil
																end
																flag22 = false
																if tbl39[arg4.KeyCode] then
																	v87[arg2] = "NONE"
																	fn32()
																	fn64()
																	fn34(arg3, "key cleared")
																	return
																end
																v87[arg2] = name
																fn32()
																fn64()
																fn34(arg3, "key: " .. name)
															end)
														end)
														return fn64
													end,
													slider = function(arg, layoutOrder, text, arg2, arg3, arg4, arg5, arg6)
														local frame6 = Instance.new("Frame", arg)
														frame6.Size = UDim2.new(1, -6, v85[164], math.floor(58 * v94))
														frame6.BackgroundColor3 = tbl29.SURF2
														frame6.BorderSizePixel = 0
														frame6.LayoutOrder = layoutOrder
														frame6.ZIndex = 203
														createUICorner2(frame6, 11)
														createUIStroke2(frame6, tbl29.AQUA_STROKE, v85[64], 0.52)
														local textLabel3 = Instance.new("TextLabel", frame6)
														textLabel3.BackgroundTransparency = 1
														textLabel3.Position = UDim2.fromOffset(12, 6)
														textLabel3.Size = UDim2.new(1, -86, v85[164], math.floor(18 * v94))
														textLabel3.Font = Enum.Font.GothamBold
														textLabel3.Text = text
														textLabel3.TextColor3 = tbl29.TEXT
														textLabel3.TextSize = 12 * v94
														textLabel3.TextXAlignment = Enum.TextXAlignment.Left
														textLabel3.ZIndex = 204
														local instance4 = Instance.new(v85[8], frame6)
														instance4.AnchorPoint = Vector2.new(1, v85[164])
														instance4.Position = UDim2.new(1, -v85[142], 0, 5)
														local floor2 = math.floor
														local n40 = v85[3] * v94
														instance4.Size = UDim2.fromOffset(math.floor(58 * v94), floor2(n40))
														instance4.BackgroundColor3 = tbl29.SURF
														instance4.BorderSizePixel = 0
														instance4.Font = Enum.Font.GothamBold
														instance4.TextSize = 12 * v94
														instance4.TextColor3 = Color3.fromRGB(216, 190, v85[149])
														instance4.ZIndex = 204
														createUICorner2(instance4, 6)
														local v104 = createUIStroke2(instance4, tbl29.AQUA_STROKE, v85[64], v85[140])
														local frame7 = Instance.new("Frame", frame6)
														frame7.Position = UDim2.fromOffset(v85[142], math.floor(36 * v94))
														frame7.Size = UDim2.new(v85[64], -24, 0, 10)
														frame7.BackgroundColor3 = Color3.fromRGB(30, 18, 48)
														frame7.BorderSizePixel = 0
														frame7.ZIndex = 204
														createUICorner2(frame7, 6)
														local frame8 = Instance.new("Frame", frame7)
														frame8.Size = UDim2.new(0, 0, 1, 0)
														frame8.BackgroundColor3 = tbl29.AQUA
														frame8.BorderSizePixel = v85[164]
														frame8.ZIndex = 205
														createUICorner2(frame8, 6)
														local frame9 = Instance.new("Frame", frame7)
														frame9.AnchorPoint = Vector2.new(0.5, v85[140])
														frame9.Size = UDim2.fromOffset(18, 18)
														frame9.BackgroundColor3 = Color3.fromRGB(216, 182, 255)
														frame9.BorderSizePixel = v85[164]
														frame9.ZIndex = 206
														createUICorner2(frame9, 20)
														createUIStroke2(frame9, tbl29.AQUA, 1.4, 0.15)
														local textButton3 = Instance.new("TextButton", frame6)
														textButton3.BackgroundTransparency = 1
														textButton3.Text = ""
														textButton3.AutoButtonColor = false
														textButton3.Position = UDim2.fromOffset(v85[167], math.floor(26 * v94))
														textButton3.Size = UDim2.new(v85[64], -12, 0, math.floor(30 * v94))
														textButton3.ZIndex = 210
														local n41 = math.max(1, math.floor(1 / arg4 + 0.001))
														local function fn64(arg7)
															local n42 = math.clamp((arg7 - arg2) / (arg3 - arg2), 0, 1)
															frame8.Size = UDim2.new(n42, 0, 1, 0)
															frame9.Position = UDim2.new(n42, v85[164], 0.5, 0)
															instance4.Text = tostring(math.floor(arg7 * n41 + 0.5) / n41)
														end
														fn64(arg5())
														local flag22 = false
														local function fn65(arg7)
															local n42 = math.clamp(math.floor((arg2 + (arg3 - arg2) * math.clamp((arg7 - frame7.AbsolutePosition.X) / math.max(v85[64], frame7.AbsoluteSize.X), 0, 1)) * n41 + v85[140]) / n41, arg2, arg3)
															fn64(n42)
															arg6(n42)
														end
														local function fn66(arg7)
															flag22 = arg7
															v104.Color = arg7 and tbl29.GREEN_STROKE or tbl29.AQUA_STROKE
															v104.Transparency = arg7 and 0.2 or v85[140]
														end
														textButton3.InputBegan:Connect(function(input)
															if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
																fn66(true)
																fn65(input.Position.X)
															end
														end)
														fn31(service.InputChanged, function(arg7)
															if flag22 and (arg7.UserInputType == Enum.UserInputType.MouseMovement or arg7.UserInputType == Enum.UserInputType.Touch) then
																fn65(arg7.Position.X)
															end
														end)
														fn31(service.InputEnded, function(arg7)
															local flag23 = flag22
															if flag22 then
																flag23 = arg7.UserInputType == Enum.UserInputType.MouseButton1 or arg7.UserInputType == Enum.UserInputType.Touch
															end
															if flag23 then
																fn66(false)
																fn32()
															end
														end)
														return fn64
													end,
												}
											end
											do
												local XkPqBoostSettings = tbl38.card("XkPqBoostSettings", "STEAL BOOST", 340, 260)
												local v103 = v85[78]
												v87.WalkSpeedValue = math.clamp(tonumber(v87.WalkSpeedValue) or 27, v103, 29)
												local v104 = v85[139]
												local v105 = nil
												local fn63 = nil
												local function iCollectProWalkSpeedSet(iCollectProWalkSpeedOn, arg)
													iCollectProWalkSpeedOn = iCollectProWalkSpeedOn and true or false
													v104 = iCollectProWalkSpeedOn
													genv.iCollectPro_WalkSpeedOn = iCollectProWalkSpeedOn
													if not arg then
														v87.WalkSpeedOn = iCollectProWalkSpeedOn
														fn32()
													end
													if v105 then
														v105:Disconnect()
														v105 = nil
													end
													if fn63 then fn63() end
													if not iCollectProWalkSpeedOn then return end
													v105 = fn31(runService.Heartbeat, function(arg2)
														local character = localPlayer2.Character
														if not character then return end
														local humanoid = character:FindFirstChildOfClass("Humanoid")
														local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
														if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then return end
														if localPlayer2:GetAttribute("Stealing") ~= true then return end
														local moveDirection = humanoid.MoveDirection
														if moveDirection.Magnitude <= 0 then return end
														local n40 = math.clamp(tonumber(v87.WalkSpeedValue) or 27, 5, 29)
														if n40 <= humanoid.WalkSpeed then return end
														humanoidRootPart.CFrame = humanoidRootPart.CFrame + moveDirection * (n40 - humanoid.WalkSpeed) * (arg2 or 0.016)
													end)
												end
												genv.iCollectPro_WalkSpeedSet = iCollectProWalkSpeedSet
												genv.iCollectPro_WalkSpeedOn = false
												tbl17.DisableStealSpeed = function() iCollectProWalkSpeedSet(false, true) end
												tbl38.head(XkPqBoostSettings.body, 8, "WALK SPEED")
												local v106 = tbl38.opt(XkPqBoostSettings.body, 9, "Walk Speed", function()
													return v104
												end, function(arg)
													iCollectProWalkSpeedSet(arg)
												end)
												tbl38.opt(XkPqBoostSettings.body, 10, "Auto on Steal", function()
													return v87.WalkSpeedAutoOnSteal ~= false
												end, function(walkSpeedAutoOnSteal)
													v87.WalkSpeedAutoOnSteal = walkSpeedAutoOnSteal
													fn32()
													if not walkSpeedAutoOnSteal and v104 then iCollectProWalkSpeedSet(false) end
												end)
												tbl38.slider(XkPqBoostSettings.body, 12, "Speed  (Recommended 27)", v103, 29, 1, function()
													return tonumber(v87.WalkSpeedValue) or 27
												end, function(walkSpeedValue)
													v87.WalkSpeedValue = walkSpeedValue
												end)
												fn63 = function()
													pcall(v106)
													if XkPqBoostSettings.refresh then pcall(XkPqBoostSettings.refresh) end
												end
												fn31(service.InputBegan, function(arg, arg2)
													if arg2 or arg.UserInputType ~= Enum.UserInputType.Keyboard then return end
													if service:GetFocusedTextBox() then return end
													local str6 = tostring(v87.WalkSpeedKey or "NONE")
													if str6 == "NONE" then return end
													local ok, result = pcall(function()
														return Enum.KeyCode[str6]
													end)
													if ok and result and arg.KeyCode == result then
														iCollectProWalkSpeedSet(not v104)
														fn34("Walk Speed", v104 and "ON" or "OFF")
													end
												end)
												local n40 = 0
												local function fn64() n40 += 1 end
												local function fn65()
													n40 += v85[64]
													local v107 = n40
													task.spawn(function()
														while true do
															task.wait(2)
															if v107 ~= n40 then
																return
															else
																if v87.WalkSpeedAutoOnSteal == v85[139] then return end
																if not localPlayer2:GetAttribute(v85[26]) then return end
																if not v104 then return end
																iCollectProWalkSpeedSet(false, true)
																task.wait(0.15)
																if v107 ~= n40 then return end
																if localPlayer2:GetAttribute("Stealing") and v87.WalkSpeedAutoOnSteal ~= false then
																	iCollectProWalkSpeedSet(true, true)
																	if v85[139] then return end
																	continue
																end
																break
															end
														end
													end)
												end
												local v107 = nil
												local function fn66()
													if v87.WalkSpeedAutoOnSteal == false then
														fn64()
														return
													end
													local flag22 = localPlayer2:GetAttribute(v85[26]) and true or false
													if flag22 == v107 then return end
													v107 = flag22
													iCollectProWalkSpeedSet(flag22, true)
													if flag22 then
														fn65()
													else
														fn64()
													end
												end
												fn31(localPlayer2:GetAttributeChangedSignal("Stealing"), fn66)
												task.defer(fn66)
												if v87.WalkSpeedOn then
													task.defer(function()
														iCollectProWalkSpeedSet(true, true)
													end)
												end
												local v108 = tbl38.chipRow(frame3, 5, "Steal Boost", XkPqBoostSettings.toggle)
												local v109 = nil
												local v110 = nil
												local function refresh()
													local flag22 = genv.iCollectPro_WalkSpeedOn == true
													local str6 = flag22 and "SPEED" or "OFF"
													if str6 ~= v109 or flag22 ~= v110 then
														v109 = str6
														v110 = flag22
														v108(str6, flag22)
													end
												end
												XkPqBoostSettings.refresh = refresh
												refresh()
												task.spawn(function()
													while fn30() do
														refresh()
														task.wait(0.3)
													end
												end)
											end
											do
												local XkPqKeybinds = tbl38.card("XkPqKeybinds", "KEYBINDS", 340, math.floor(148 + 262 * v94))
												tbl38.head(XkPqKeybinds.body, v85[64], "STEAL BOOST")
												tbl38.key(XkPqKeybinds.body, 3, "Walk Speed", "WalkSpeedKey", "Walk Speed")
												tbl38.head(XkPqKeybinds.body, 4, "MOVEMENT")
												tbl38.key(XkPqKeybinds.body, 5, "Fly Speed", "CarpetSpeedKey", "Fly Speed")
												tbl38.head(XkPqKeybinds.body, 6, "BRAINROT")
												tbl38.key(XkPqKeybinds.body, v85[87], "Drop Brainrot", "DropKey", "Drop Brainrot")
												tbl38.head(XkPqKeybinds.body, 8, "INVIS")
												tbl38.key(XkPqKeybinds.body, 9, "Manual Invis", "ManualInvisKey", "Manual Invis")
												local textLabel3 = Instance.new("TextLabel", XkPqKeybinds.body)
												textLabel3.LayoutOrder = 10
												textLabel3.Size = UDim2.new(1, -v85[167], v85[164], math.floor(v85[45] * v94))
												textLabel3.BackgroundTransparency = 1
												textLabel3.Font = Enum.Font.GothamMedium
												textLabel3.Text = v86 and "no keyboard here - use the panel rows" or "tap a key to rebind  -  backspace to clear"
												textLabel3.TextColor3 = tbl29.DIM
												textLabel3.TextSize = 9 * v94
												textLabel3.TextXAlignment = Enum.TextXAlignment.Center
												textLabel3.ZIndex = 204
												fn31(service.InputBegan, function(arg, arg2)
													if arg2 or arg.UserInputType ~= Enum.UserInputType.Keyboard then return end
													if service:GetFocusedTextBox() then return end
													local str6 = tostring(v87.DropKey or "NONE")
													if str6 == "NONE" then return end
													local ok, result = pcall(function()
														return Enum.KeyCode[str6]
													end)
													if ok and result and arg.KeyCode == result then
														local iCollectProDropBrainrot = genv.iCollectPro_DropBrainrot
														if type(iCollectProDropBrainrot) == "function" then
															fn34("Drop Brainrot", "dropping")
															task.spawn(iCollectProDropBrainrot)
														end
													end
												end)
												fn31(service.InputBegan, function(arg, arg2)
													if arg2 or arg.UserInputType ~= Enum.UserInputType.Keyboard then return end
													if service:GetFocusedTextBox() then return end
													local str6 = tostring(v87.ManualInvisKey or v85[112])
													if str6 == v85[112] then return end
													local ok, result = pcall(function()
														return Enum.KeyCode[str6]
													end)
													if ok and result and arg.KeyCode == result then
														local iCollectProInvisManual = genv.iCollectPro_InvisManual
														if type(iCollectProInvisManual) ~= "function" then
															fn34("Manual Invis", "not ready yet")
															return
														end
														v87.ManualInvis = not (v87.ManualInvis == v85[192])
														fn32()
														pcall(iCollectProInvisManual, v87.ManualInvis)
														fn34("Manual Invis", v87.ManualInvis and "ON" or "OFF")
													end
												end)
												local v103 = tbl38.chipRow(tbl28.list, v85[167], "Keybinds", XkPqKeybinds.toggle)
												local v104 = nil
												local function fn63()
													local v105 = v85[164]
													for _, v106 in ipairs({ "WalkSpeedKey", "CarpetSpeedKey", "DropKey", "ManualInvisKey" }) do
														if tostring(v87[v106] or "NONE") ~= "NONE" then v105 += v85[64] end
													end
													local str6 = v105 == 0 and "NONE SET" or tostring(v105) .. " BOUND"
													if str6 ~= v104 then
														v104 = str6
														v103(str6, v105 > 0)
													end
												end
												fn63()
												task.spawn(function()
													while fn30() do
														fn63()
														task.wait(v85[54])
													end
												end)
											end
											for _, v103 in ipairs({ "iCollectPro_Kick", "iCollectPro_SetPSLink", "iCollectPro_CookieSrc", "iCollectPro_CookieProbe" }) do
												genv[v103] = nil
											end
											do
												local ok, result = pcall(function()
													local datas = replicatedStorage:WaitForChild("Datas", 10)
													return datas and require(datas:WaitForChild("Animals", 10))
												end)
												local flag22 = ok and type(result) == "table" and result or nil
												local str6 = nil
												local str7 = nil
												local function fn63()
													local ok2, result2 = pcall(function()
														return localPlayer2:GetAttribute("StealingIndex")
													end)
													if not ok2 or result2 == nil or result2 == "" then return end
													str6 = tostring(result2)
													str7 = "Unknown"
													local v103 = flag22 and flag22[result2]
													if type(v103) == "table" and v103.Rarity then str7 = tostring(v103.Rarity) end
												end
												fn31(localPlayer2:GetAttributeChangedSignal("StealingIndex"), fn63)
												fn31(localPlayer2:GetAttributeChangedSignal(v85[26]), fn63)
												task.defer(fn63)
												local function fn64()
													fn63()
													if str6 then
														local str8 = " " .. str6 .. "\n\nDISCORD.GG/FREESCRIPTS"
														return "You stole a " .. tostring(str7) .. str8
													end
													return "You stole a brainrot\n\nDISCORD.GG/FREESCRIPTS"
												end
												Color3.fromRGB(70, 220, 140)
												local function fn65()
												end
												local fn66 = nil
												local fn67 = nil
												local function fn68()
												end
												local function fn69()
													if n24 >= 3408 then
														while v85[192] do
														end
													end
													return v87.AutoLeaveOnSteal == v85[192] or v87.KickToPS == true
												end
												local function fn70()
													if fn69() then
														fn66()
													else
														fn67()
													end
												end
												local function fn71(arg)
													v87.AutoLeaveOnSteal = arg and v85[192] or false
													if v87.AutoLeaveOnSteal then v87.KickToPS = false end
													fn32()
													fn70()
													fn68()
													if v87.AutoLeaveOnSteal then
														fn34("AUTO KICK", "armed - leaves the server on steal", 3)
													else
														fn34("AUTO KICK", "off - nothing happens when you steal", 3)
													end
												end
												local flag23 = false
												local tbl39 = {}
												local function fn72()
													local iCollectProKickOut = genv.iCollectPro_KickOut
													if type(iCollectProKickOut) == "function" then
														flag23 = true
														pcall(iCollectProKickOut)
													end
												end
												genv.iCollectPro_LeaveServer = function()
													pcall(function()
														localPlayer2:Kick(fn64())
													end)
												end
												fn67 = function()
													for _, v103 in ipairs(tbl39) do
														pcall(function()
															v103:Disconnect()
														end)
													end
													tbl39 = {}
												end
												local flag24 = false
												local v103 = nil
												local iCollectProMyPlot = nil
												local n40 = 0
												local flag25 = false
												local function fn73()
													local v104 = iCollectProMyPlot
													if not v104 or not v104.Parent then
														local iCollectProMyPlot2 = genv.iCollectPro_MyPlot and genv.iCollectPro_MyPlot()
														iCollectProMyPlot = iCollectProMyPlot2
														v104 = iCollectProMyPlot2
													end
													if not v104 then return nil end
													local iCollectProPlotAnimalCount = genv.iCollectPro_PlotAnimalCount
													if type(iCollectProPlotAnimalCount) ~= "function" then return nil end
													local ok2, result2 = pcall(iCollectProPlotAnimalCount, v104.Name)
													return ok2 and result2 or nil
												end
												local function fn74()
													local plots2 = workspace:FindFirstChild("Plots")
													if not plots2 then return nil end
													for _, child in ipairs(plots2:GetChildren()) do
														local ok2, result2 = pcall(fn43, child.Name)
														local animalList = ok2 and type(result2) == "table" and result2.AnimalList
														if type(animalList) ~= "table" then continue end
														for _, v104 in pairs(animalList) do
															if type(v104) == "table" and v104.Steal == localPlayer2.UserId then return child.Name end
														end
													end
													return nil
												end
												local function fn75(arg)
													local v104 = fn74()
													if v104 then
														local iCollectProMyPlot2 = genv.iCollectPro_MyPlot and genv.iCollectPro_MyPlot()
														return iCollectProMyPlot2 ~= nil and iCollectProMyPlot2.Name == v104
													end
													if arg then return false end
													local character = localPlayer2.Character
													character = character and character:FindFirstChild("HumanoidRootPart")
													local v105 = workspace:FindFirstChild(v85[2])
													if not character or not v105 then return v85[139] end
													local iCollectProMyPlot2 = genv.iCollectPro_MyPlot and genv.iCollectPro_MyPlot()
													if not iCollectProMyPlot2 then return false end
													local v106 = nil
													local v107 = nil
													for _, child in ipairs(v105:GetChildren()) do
														local mainRoot = child:FindFirstChild("MainRoot")
														local position
														if mainRoot and mainRoot:IsA("BasePart") then
															position = mainRoot.Position
														else
															local ok2, result2 = pcall(function()
																return child:GetPivot().Position
															end)
															position = ok2 and result2 or nil
														end
														if position then
															local magnitude = (position - character.Position).Magnitude
															if not v106 or magnitude < v106 then
																v107 = child
																v106 = magnitude
															end
														end
													end
													return v107 ~= nil and v107 == iCollectProMyPlot2
												end
												local function fn76()
													if not fn69() then
														flag24 = v85[139]
														return
													end
													local ok2, result2 = pcall(function()
														return localPlayer2:GetAttribute("Stealing")
													end)
													if not ok2 then return end
													if result2 then
														pcall(fn63)
														flag24 = true
														n40 += v85[64]
														flag25 = fn75()
														iCollectProMyPlot = genv.iCollectPro_MyPlot and genv.iCollectPro_MyPlot()
														v103 = fn73()
														return
													end
													if not flag24 then return end
													flag24 = false
													if flag23 then return end
													if flag25 then
														flag25 = false
														return
													end
													local v104 = v103
													n40 += 1
													local v105 = n40
													task.spawn(function()
														local now3 = os.clock()
														while os.clock() - now3 < 8 do
															if v105 ~= n40 or flag23 or not fn30() then return end
															local v106 = fn73()
															if v106 then
																if v104 and v106 > v104 then
																	fn72()
																	return
																end
																if not v104 then v104 = v106 end
															end
															task.wait(0)
														end
													end)
												end
												fn66 = function()
													fn67()
													flag23 = false
													flag24 = false
													flag25 = false
													tbl39[#tbl39 + v85[64]] = fn31(localPlayer2:GetAttributeChangedSignal("Stealing"), fn76)
													tbl39[#tbl39 + v85[64]] = fn31(localPlayer2:GetAttributeChangedSignal("StealingIndex"), function()
														pcall(fn63)
													end)
													task.defer(function()
														local ok2, result2 = pcall(function()
															return localPlayer2:GetAttribute("Stealing")
														end)
														if ok2 and result2 then
															pcall(fn63)
															flag24 = v85[192]
															flag25 = fn75(true)
															iCollectProMyPlot = genv.iCollectPro_MyPlot and genv.iCollectPro_MyPlot()
															v103 = fn73()
														end
													end)
												end
												if v87.AutoLeaveOnSteal == true and v87.KickToPS == true then v87.KickToPS = false end
												if fn69() then
													fn66()
													fn65()
												end
												local v104 = tbl38.chipRow(tbl28.list, 0, "Auto Kick", function()
													fn71(not (v87.AutoLeaveOnSteal == true))
												end)
												local v105 = nil
												local function fn77()
													local v106 = fn69()
													local str8 = v87.AutoLeaveOnSteal == true and "ON" or v87.KickToPS == true and "TO PS" or v85[121]
													if str8 ~= v105 then
														v105 = str8
														v104(str8, v106)
													end
												end
												fn68 = fn77
												fn77()
												task.spawn(function()
													while fn30() do
														fn77()
														task.wait(0.4)
													end
												end)
												genv.iCollectPro_StartAutoKick = function()
													v87.AutoLeaveOnSteal = true
													v87.KickToPS = false
													fn32()
													fn68()
													fn66()
												end
												genv.iCollectPro_StopAutoKick = function()
													v87.AutoLeaveOnSteal = v85[139]
													fn32()
													fn68()
													fn70()
												end
												genv.iCollectPro_SetKickToPS = function(arg)
													v87.KickToPS = arg and true or false
													if v87.KickToPS then v87.AutoLeaveOnSteal = false end
													fn32()
													fn68()
													fn70()
													if v87.KickToPS then fn34("KICK TO PS", "armed - joins your private server on steal", 3) end
												end
											end
											local function fn63()
												local RunService3 = game:GetService("RunService")
												local Players2 = game:GetService("Players")
												local v103 = localPlayer2
												local tbl39 = {
													ParticleEmitter = true,
													Beam = true,
													Trail = true,
													Fire = v85[192],
													Smoke = true,
													Sparkles = true,
													Explosion = true,
													PointLight = true,
													SpotLight = true,
													SurfaceLight = true,
												}
												local function fn64(arg)
													if pcall(function()
														arg:Destroy()
													end) then
														return
													end
													pcall(function()
														for _, descendant in ipairs(arg:GetDescendants()) do
															if descendant:IsA("BasePart") then
																descendant.Transparency = 1
																descendant.CanCollide = false
																descendant.CanQuery = false
																descendant.CastShadow = false
																descendant.LocalTransparencyModifier = v85[64]
															elseif tbl39[descendant.ClassName] then
																descendant.Enabled = false
															elseif descendant:IsA("Sound") then
																descendant.Volume = 0
																descendant:Stop()
															end
														end
													end)
												end
												local function fn65(arg)
													if not arg then return end
													for _, child in ipairs(arg:GetChildren()) do if child:IsA("Accessory") then fn64(child) end end
												end
												local obj3 = setmetatable({}, { __mode = v85[93] })
												local function fn66(arg)
													if not arg or obj3[arg] then return end
													obj3[arg] = true
													fn65(arg)
													arg.ChildAdded:Connect(function(child)
														if fn30() and child:IsA("Accessory") then task.defer(fn64, child) end
													end)
												end
												local function fn67(arg)
													if arg.Character then task.spawn(fn66, arg.Character) end
													fn31(arg.CharacterAdded, fn66)
												end
												task.defer(function()
													for _, player in ipairs(Players2:GetPlayers()) do
														pcall(fn67, player)
														task.wait(0.05)
													end
												end)
												fn31(Players2.PlayerAdded, function(arg)
													task.defer(fn67, arg)
												end)
												fn31(workspace.DescendantAdded, function(arg)
													if arg.ClassName == "Accessory" then
														local parent = arg.Parent
														if parent and parent:FindFirstChildOfClass("Humanoid") then
															if n28(2847) > -13 then
																task.defer(fn64, arg)
															else
																while true do
																end
															end
														end
													end
												end)
												task.spawn(function()
													while fn30() do
														for _, player in ipairs(Players2:GetPlayers()) do
															if player.Character then fn65(player.Character) end
															task.wait(0.05)
														end
														for _, child in ipairs(workspace:GetChildren()) do
															if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") then
																fn65(child)
																task.wait(0.05)
															end
														end
														task.wait(10)
													end
												end)
												local tbl40 = { "Base", "PlotSign", "FriendPanel", "Cash", "Laser", "Decorations", "Skin", "Unlock", "Purchases" }
												local tbl41 = {}
												local tbl42 = {}
												local n40 = 0
												local function fn68(arg, arg2)
													if not arg:IsA("BasePart") then return end
													if tbl41[arg] == nil then tbl41[arg] = arg.Transparency == arg2 and 0 or arg.Transparency end
													local v104 = tbl41[arg]
													if v104 >= 1 then return end
													local transparency = v104 + (v85[64] - v104) * arg2
													if math.abs(arg.Transparency - transparency) > 0.01 then arg.Transparency = transparency end
												end
												local function fn69(arg, arg2, arg3)
													if not arg or arg3 ~= n40 then return end
													fn68(arg, arg2)
													local n41 = 0
													for _, descendant in ipairs(arg:GetDescendants()) do
														if arg3 ~= n40 then return end
														fn68(descendant, arg2)
														n41 += v85[64]
														if n41 % 250 == v85[164] then task.wait() end
													end
													tbl42[#tbl42 + 1] = arg.DescendantAdded:Connect(function(descendant)
														if arg3 == n40 then fn68(descendant, arg2) end
													end)
												end
												local function fn70(arg, arg2, arg3)
													if not arg or arg3 ~= n40 then return end
													for _, v104 in ipairs(tbl40) do
														if arg3 ~= n40 then return end
														fn69(arg:FindFirstChild(v104), arg2, arg3)
													end
													if arg3 ~= n40 then return end
													tbl42[#tbl42 + 1] = arg.ChildAdded:Connect(function(child)
														if arg3 ~= n40 then return end
														for _, v104 in ipairs(tbl40) do
															if child.Name == v104 then
																fn69(child, arg2, arg3)
																break
															end
														end
													end)
													local animalPodiums = arg:FindFirstChild("AnimalPodiums")
													if not animalPodiums then return end
													local function fn71(arg4)
														for _, child in ipairs(arg4:GetChildren()) do
															if child.Name == "Claim" then
																fn69(child, arg2, arg3)
															elseif child.Name == v85[177] then
																fn69(child:FindFirstChild("Decorations"), arg2, arg3)
															end
														end
													end
													for _, child in ipairs(animalPodiums:GetChildren()) do fn71(child) end
													tbl42[#tbl42 + 1] = animalPodiums.ChildAdded:Connect(function(child)
														if arg3 ~= n40 then return end
														task.wait(0.1)
														if arg3 == n40 then fn71(child) end
													end)
												end
												local function fn71()
													for _, v104 in ipairs(tbl42) do
														pcall(function()
															v104:Disconnect()
														end)
													end
													local n41 = n40 + v85[64]
													tbl42 = {}
													n40 = n41
												end
												local function fn72()
													fn71()
													local v104 = n40
													task.spawn(function()
														while v104 == n40 and not workspace:FindFirstChild("Plots") do task.wait(0.5) end
														local plots2 = workspace:FindFirstChild("Plots")
														if v104 ~= n40 or not plots2 then return end
														for _, child in ipairs(plots2:GetChildren()) do
															if v104 ~= n40 then return end
															pcall(fn70, child, 0.9, v104)
															task.wait()
														end
														tbl42[#tbl42 + 1] = plots2.ChildAdded:Connect(function(child)
															if v104 ~= n40 then return end
															task.wait(0.2)
															pcall(fn70, child, 0.9, v104)
														end)
													end)
												end
												local function fn73()
													fn71()
													local v104 = tbl41
													tbl41 = {}
													for k, v105 in pairs(v104) do
														pcall(function()
															if k.Parent then k.Transparency = v105 end
														end)
													end
													local v105 = n40
													task.spawn(function()
														local plots2 = workspace:FindFirstChild("Plots")
														if not plots2 then return end
														local n41 = 0
														for _, descendant in ipairs(plots2:GetDescendants()) do
															if n40 ~= v105 then return end
															if descendant:IsA("BasePart") and math.abs(descendant.Transparency - 0.9) < 0.001 then
																pcall(function()
																	descendant.Transparency = 0
																end)
															end
															n41 += 1
															if n41 % 500 == 0 then task.wait() end
														end
													end)
												end
												if v87.XrayBase == true then task.delay(v85[64], fn72) end
												local function fn74(arg)
													local match = tostring(arg or ""):match("^%s*(.-)%s*$")
													if match == "" then return nil end
													if not match:find("://", v85[64], true) then return match end
													return match:match("[?&]privateServerLinkCode=([^&]+)") or match:match("[?&]linkCode=([^&]+)") or match:match("[?&]code=([^&]+)")
												end
												local now3 = v85[164]
												local function iCollectProKickOut()
													if os.clock() - now3 < 3 then return end
													now3 = os.clock()
													if v87.KickToPS == true then
														local v104 = fn74(v87.KickPSLink)
														if v104 and v104 ~= "" then
															if pcall(function()
																game:GetService("ExperienceService"):LaunchExperience({ placeId = game.PlaceId, linkCode = v104 })
															end) then
																return
															end
														end
													end
													if pcall(function()
														game:Shutdown()
													end) then
														return
													end
													pcall(function()
														v103:Kick("")
													end)
												end
												genv.iCollectPro_KickOut = iCollectProKickOut
												task.spawn(function()
													local playerGui2 = v103:FindFirstChildOfClass("PlayerGui") or v103:WaitForChild("PlayerGui", 10)
													if not playerGui2 then return end
													local obj4 = setmetatable({}, { __mode = "k" })
													local function fn75() return (v87.AutoLeaveOnSteal == true or v87.KickToPS == true) and fn30() end
													local function fn76(arg)
														if type(arg) ~= "string" then return false end
														return arg:gsub("<[^>]->", ""):lower():find("you stole", v85[64], true) ~= nil
													end
													local function fn77(arg) return arg:IsA(v85[8]) or arg:IsA("TextButton") or arg:IsA("TextBox") end
													local function fn78(arg)
														if obj4[arg] then return end
														obj4[arg] = true
														if fn75() and fn76(arg.Text) then
															iCollectProKickOut()
															return
														end
														arg:GetPropertyChangedSignal("Text"):Connect(function()
															if fn75() and fn76(arg.Text) then iCollectProKickOut() end
														end)
													end
													local function fn79(arg)
														fn31(arg.DescendantAdded, function(arg2)
															if fn77(arg2) then fn78(arg2) end
														end)
														local v104 = v85[164]
														for _, descendant in ipairs(arg:GetDescendants()) do
															v104 += 1
															if v104 % 200 == 0 then task.wait() end
															if fn77(descendant) then fn78(descendant) end
														end
													end
													while fn30() and not fn75() do task.wait(1) end
													if not fn30() then return end
													fn31(playerGui2.ChildAdded, fn79)
													for _, child in ipairs(playerGui2:GetChildren()) do fn79(child) end
												end)
												local n41 = 4.2
												local flag22 = false
												local tbl43 = {}
												local humanoidRootPart = nil
												local clone = nil
												local v104 = nil
												local hipHeight = nil
												local tbl44 = nil
												local flag23 = false
												local flag24 = false
												local fn75 = nil
												local flag25 = false
												local function fn76()
													if genv.iCollectPro_InvisHold == v85[192] then return false end
													return flag25
												end
												local function fn77() return 0.01 + n41 / 10 * 0.19 end
												local function fn78(arg) tbl43[#tbl43 + 1] = arg end
												local function fn79(arg, arg2, part0)
													for _, descendant in ipairs(arg:GetDescendants()) do
														if descendant:IsA("Weld") or descendant:IsA("Motor6D") then
															if descendant.Part0 == arg2 then descendant.Part0 = part0 end
															if descendant.Part1 == arg2 then descendant.Part1 = part0 end
														end
													end
												end
												local function fn80()
													flag22 = false
													flag23 = false
													for _, v105 in ipairs(tbl43) do
														pcall(function()
															v105:Disconnect()
														end)
													end
													tbl43 = {}
													if tbl44 then
														for k, v105 in pairs(tbl44) do
															if k and k.Parent then
																pcall(function()
																	k.LocalTransparencyModifier = v105
																end)
															end
														end
														tbl44 = nil
													end
													if v104 then
														pcall(function()
															v104:AdjustSpeed(1)
															v104:Stop(0)
															v104:Destroy()
														end)
														v104 = nil
													end
													local character = v103.Character
													local humanoid = character and character:FindFirstChildOfClass("Humanoid")
													if humanoidRootPart and humanoidRootPart:IsDescendantOf(game) and humanoid then
														local instance4 = Instance.new(v85[174])
														instance4.Parent = game
														character.Parent = instance4
														humanoidRootPart.Parent = character
														character.PrimaryPart = humanoidRootPart
														character.Parent = workspace
														humanoidRootPart.CanCollide = true
														fn79(character, clone, humanoidRootPart)
														if clone then
															local cFrame = clone.CFrame
															clone:Destroy()
															clone = nil
															humanoidRootPart.CFrame = cFrame
														end
														humanoid.HipHeight = hipHeight or 0
														instance4:Destroy()
													end
													humanoidRootPart = nil
													clone = nil
													genv.iCollectPro_InvisActive = false
													if character then
														pcall(function()
															for _, descendant in ipairs(character:GetDescendants()) do
																if descendant:IsA("BasePart") and descendant.LocalTransparencyModifier > 0.01 then
																	descendant.LocalTransparencyModifier = v85[164]
																end
															end
														end)
													end
													if humanoid and humanoid.Parent then
														local flag26 = genv.ICOLLECTPRO_ANTIDIE_ON ~= false
														pcall(function()
															humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not flag26)
															humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not flag26)
															humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, not flag26)
														end)
														pcall(function()
															humanoid.PlatformStand = false
															humanoid.HipHeight = hipHeight or humanoid.HipHeight
															if humanoid.Health > 0 then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
														end)
													end
													pcall(function()
														local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")
														if humanoidRootPart2 then
															humanoidRootPart2.Anchored = v85[139]
															humanoidRootPart2.CanCollide = v85[192]
															humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
															humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
														end
														local currentCamera = workspace.CurrentCamera
														if currentCamera and humanoid and humanoid.Parent then
															if currentCamera.CameraType == Enum.CameraType.Scriptable then
																currentCamera.CameraType = Enum.CameraType.Custom
															end
															currentCamera.CameraSubject = humanoid
														end
													end)
													hipHeight = nil
												end
												local fn81 = nil
												fn81 = function(arg, arg2)
													if not (arg and arg2 and arg2.Health > 0) then return end
													local animation = Instance.new("Animation")
													animation.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
													v104 = (arg2:FindFirstChildOfClass("Animator") or Instance.new("Animator", arg2)):LoadAnimation(animation)
													v104.Priority = Enum.AnimationPriority.Action4
													v104.Looped = true
													v104:Play(0, 1, 0)
													animation:Destroy()
													fn78(v104.Stopped:Connect(function()
														if flag22 then fn81(arg, arg2) end
													end))
													task.defer(function()
														if not v104 then return end
														v104.TimePosition = 0.7
														task.delay(0.1, function()
															if v104 then v104:AdjustSpeed(math.huge) end
														end)
													end)
												end
												fn75 = function()
													local character = v103.Character
													local humanoid = character and character:FindFirstChildOfClass("Humanoid")
													if not humanoid or flag22 then return false end
													local v105 = workspace:FindFirstChild(v103.Name)
													if v105 then
														for _, v106 in ipairs({ "DoubleRig", "Constraints" }) do
															local v107 = v105:FindFirstChild(v106)
															if v107 then v107:Destroy() end
														end
														fn78(v105.ChildAdded:Connect(function(child)
															if child.Name == "DoubleRig" or child.Name == "Constraints" then child:Destroy() end
														end))
													end
													for _, v106 in ipairs({ "Dead", "FallingDown", "Ragdoll" }) do
														humanoid:SetStateEnabled(Enum.HumanoidStateType[v106], false)
													end
													hipHeight = humanoid.HipHeight
													humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
													if not (humanoidRootPart and humanoidRootPart.Parent) then return false end
													local model = Instance.new("Model")
													model.Parent = game
													character.Parent = model
													clone = humanoidRootPart:Clone()
													clone.Parent = character
													humanoidRootPart.Parent = workspace.CurrentCamera
													clone.CFrame = humanoidRootPart.CFrame
													character.PrimaryPart = clone
													character.Parent = workspace
													fn79(character, humanoidRootPart, clone)
													model:Destroy()
													flag22 = true
													fn81(character, humanoid)
													tbl44 = {}
													for _, descendant in ipairs(character:GetDescendants()) do
														if descendant:IsA("BasePart") then
															tbl44[descendant] = descendant.LocalTransparencyModifier
															descendant.LocalTransparencyModifier = 1
														end
													end
													fn78(character.DescendantAdded:Connect(function(descendant)
														if not (flag22 and descendant:IsA("BasePart")) then return end
														if tbl44 and tbl44[descendant] == nil then tbl44[descendant] = descendant.LocalTransparencyModifier end
														pcall(function()
															descendant.LocalTransparencyModifier = 1
														end)
													end))
													fn78(RunService3.Heartbeat:Connect(function()
														if not flag22 or not humanoid.Parent then return end
														humanoid.Health = humanoid.MaxHealth
														humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
														local state = humanoid:GetState()
														if state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll then
															humanoid:ChangeState(Enum.HumanoidStateType.Running)
														end
													end))
													local position = nil
													local n42 = 60
													fn78(RunService3.PreSimulation:Connect(function()
														if not (flag22 and humanoidRootPart and humanoid.Health > 0) then return end
														local primaryPart = character.PrimaryPart or character:FindFirstChild("HumanoidRootPart")
														if not primaryPart then return end
														if n42 > v85[164] then
															n42 -= 1
														elseif not flag23 and position then
															if (humanoidRootPart.Position - position).Magnitude > 2.25 or (clone and (clone.Position - position).Magnitude or v85[164]) > 8 then
																flag23 = true
																if not flag24 then
																	task.spawn(function()
																		flag24 = v85[192]
																		pcall(fn80)
																		task.wait(0.5)
																		flag24 = false
																		local now4 = os.clock()
																		while genv.iCollectPro_InvisHold == v85[192] and os.clock() - now4 < 10 do
																			task.wait(0.1)
																		end
																		if not fn76() then return end
																		if not pcall(fn75) then
																			task.wait(1)
																			if fn76() then pcall(fn75) end
																		end
																	end)
																end
															end
														end
														local n43 = primaryPart.CFrame - Vector3.new(0, humanoid.HipHeight + primaryPart.Size.Y / 2 - 1 + fn77(), 0)
														local v106 = v85[164]
														humanoidRootPart.CFrame = n43 * CFrame.Angles(math.rad(180), 0, v106)
														humanoidRootPart.AssemblyLinearVelocity = primaryPart.AssemblyLinearVelocity
														humanoidRootPart.CanCollide = false
														if humanoidRootPart.Parent ~= workspace.CurrentCamera then
															humanoidRootPart.Parent = workspace.CurrentCamera
														end
														position = n43.Position
													end))
													fn78(v103.CharacterAdded:Connect(function()
														if flag22 then fn80() end
													end))
													genv.iCollectPro_InvisActive = true
													return true
												end
												local function iCollectProInvisStop() if flag22 then pcall(fn80) end end
												genv.iCollectPro_InvisStop = iCollectProInvisStop
												local function iCollectProInvisSync()
													if not fn76() then
														if flag22 then pcall(fn80) end
														return
													end
													if flag22 then return end
													pcall(fn75)
												end
												genv.iCollectPro_InvisSync = iCollectProInvisSync
												genv.iCollectPro_InvisManual = function(arg)
													flag25 = arg and true or false
													iCollectProInvisSync()
													return flag25
												end
												genv.iCollectPro_InvisManualOn = function() return flag25 end
												if v87.ManualInvis == true then
													flag25 = true
													task.delay(v85[67], function()
														if fn30() and flag25 and not flag22 then pcall(iCollectProInvisSync) end
													end)
												end
												fn31(v103.CharacterAdded, function()
													if not flag25 then return end
													task.delay(1.5, function()
														if fn30() and flag25 and not flag22 then pcall(iCollectProInvisSync) end
													end)
												end)
												local folder = nil
												local tbl45 = {}
												local function fn82()
													if folder and folder.Parent then return folder end
													folder = Instance.new("Folder")
													folder.Name = "iCollectProPlayerESP"
													fn29(folder)
													folder.Parent = iCollectProUIHost()
													return folder
												end
												local function fn83(arg)
													local v105 = tbl45[arg]
													if v105 then
														pcall(function()
															v105:Destroy()
														end)
													end
													tbl45[arg] = nil
												end
												local function createHighlight(arg)
													local v105 = tbl45[arg]
													if v105 and v105.Parent then return v105 end
													local highlight = Instance.new("Highlight")
													highlight.Name = "ESP_" .. arg.Name
													highlight.FillTransparency = 0.55
													highlight.OutlineTransparency = v85[164]
													highlight.FillColor = Color3.fromRGB(168, 85, 247)
													highlight.OutlineColor = Color3.fromRGB(200, 150, v85[149])
													highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
													highlight.Parent = fn82()
													tbl45[arg] = highlight
													return highlight
												end
												fn31(Players2.PlayerRemoving, fn83)
												task.spawn(function()
													task.wait(4)
													while fn30() do
														task.wait(0.4)
														pcall(function()
															local flag26 = v87.PlayerESP ~= v85[139]
															local v105 = v85[1]
															local outlineColor = tostring(v87.Theme) == v105
															local color3 = outlineColor and Color3.fromRGB(v85[149], 140, v85[182]) or Color3.fromRGB(168, v85[94], 247)
															outlineColor = outlineColor and Color3.fromRGB(v85[149], 214, 96) or Color3.fromRGB(v85[126], v85[28], 255)
															for _, v106 in pairs(tbl45) do
																if v106.FillColor ~= color3 then v106.FillColor = color3 end
																if v106.OutlineColor ~= outlineColor then
																	v106.OutlineColor = outlineColor
																end
															end
															for _, player in ipairs(Players2:GetPlayers()) do
																local character = player ~= v103 and player.Character
																local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")
																if flag26 and humanoidRootPart2 then
																	local v106 = createHighlight(player)
																	if v106.Adornee ~= character then v106.Adornee = character end
																	if not v106.Enabled then v106.Enabled = true end
																else
																	local v106 = tbl45[player]
																	if v106 then
																		v106.Enabled = v85[139]
																		v106.Adornee = nil
																	end
																end
															end
														end)
													end
												end)
												local obj4 = setmetatable({}, { __mode = "k" })
												local function fn84() return v87.NoPlayerCollide ~= false and fn30() end
												local function fn85(arg)
													local name = arg.Name
													return name:match("^%d+_Clone$") ~= nil or name:find("Clone", 1, true) ~= nil
												end
												local function fn86(arg)
													if not arg:IsA("BasePart") then return end
													if obj4[arg] and arg.CanCollide == false then return end
													obj4[arg] = true
													pcall(function()
														arg.CanCollide = false
														arg.CanTouch = false
														if not (n25 >= 9067) then return end
														while true do
														end
													end)
												end
												local function fn87(arg)
													if not arg then return end
													for _, descendant in ipairs(arg:GetDescendants()) do fn86(descendant) end
													if not obj4[arg] then
														obj4[arg] = true
														arg.DescendantAdded:Connect(function(descendant)
															if fn84() then fn86(descendant) end
														end)
													end
												end
												local function iCollectProNoCollideSweep()
													if not fn84() then return end
													for _, player in ipairs(Players2:GetPlayers()) do
														if player ~= v103 and player.Character then fn87(player.Character) end
													end
													for _, child in ipairs(workspace:GetChildren()) do
														if child:IsA("Model") and child ~= v103.Character and fn85(child) then fn87(child) end
													end
												end
												genv.iCollectPro_NoCollideSweep = iCollectProNoCollideSweep
												local function fn88(arg)
													if arg == v103 then return end
													fn31(arg.CharacterAdded, function(arg2)
														task.wait(0.2)
														if fn84() then fn87(arg2) end
													end)
												end
												for _, player in ipairs(Players2:GetPlayers()) do fn88(player) end
												fn31(Players2.PlayerAdded, fn88)
												fn31(workspace.ChildAdded, function(arg)
													if not fn84() then return end
													if arg:IsA("Model") and arg ~= v103.Character and fn85(arg) then
														task.wait(0.1)
														fn87(arg)
													end
												end)
												task.spawn(function()
													task.wait(5)
													while fn30() do
														pcall(iCollectProNoCollideSweep)
														task.wait(8)
													end
												end)
												genv.iCollectPro_ExtrasOff = function()
													pcall(iCollectProInvisStop)
													pcall(fn73)
												end
												local frame6 = Instance.new("Frame", frame3.Parent.Parent.Parent)
												frame6.Name = "ExtrasPanelFrame"
												frame6.AutomaticSize = Enum.AutomaticSize.Y
												frame6.Size = UDim2.new(v85[164], math.floor(250 * v94), 0, 0)
												frame6.BackgroundColor3 = tbl29.BG
												frame6.BorderSizePixel = 0
												frame6.ZIndex = v85[12]
												frame6.Visible = v87.ExtrasOpen == true
												local extrasPanel = v87.Positions.ExtrasPanel
												if not (extrasPanel and extrasPanel.X and extrasPanel.Y) then
													extrasPanel = { X = 0.62, Y = 0.3, OffsetX = v85[164], OffsetY = 0 }
												end
												frame6.Position = UDim2.new(extrasPanel.X, extrasPanel.OffsetX or v85[164], extrasPanel.Y, extrasPanel.OffsetY or v85[164])
												createUICorner2(frame6, 18)
												createUIStroke2(frame6, tbl29.AQUA_STROKE, 1.2, 0.4)
												Instance.new("UIPadding", frame6).PaddingBottom = UDim.new(0, 10)
												fn33(frame6)
												local frame7 = Instance.new("Frame", frame6)
												frame7.Size = UDim2.new(1, 0, 0, math.floor(36 * v94))
												frame7.BackgroundTransparency = v85[64]
												frame7.ZIndex = v85[172]
												fn41(frame7, frame6, "ExtrasPanel")
												local textLabel3 = Instance.new("TextLabel", frame7)
												textLabel3.Size = UDim2.new(1, -28, 0, math.floor(22 * v94))
												textLabel3.Position = UDim2.new(0, 14, v85[164], math.floor(7 * v94))
												textLabel3.BackgroundTransparency = 1
												textLabel3.Text = "EXTRAS"
												textLabel3.Font = Enum.Font.GothamBlack
												textLabel3.TextSize = 18 * v94
												textLabel3.TextColor3 = tbl29.TEXT
												textLabel3.TextXAlignment = Enum.TextXAlignment.Center
												textLabel3.ZIndex = 102
												local frame8 = Instance.new("Frame", frame6)
												frame8.AnchorPoint = Vector2.new(0.5, 0)
												frame8.Position = UDim2.new(0.5, v85[164], 0, math.floor(32 * v94))
												local v105 = v85[164]
												frame8.Size = UDim2.new(0, math.floor(124 * v94), v105, 1)
												frame8.BackgroundColor3 = Color3.fromRGB(v85[149], 255, 255)
												frame8.BackgroundTransparency = 0.15
												frame8.BorderSizePixel = 0
												frame8.ZIndex = 101
												local frame9 = Instance.new("Frame", frame6)
												frame9.AutomaticSize = Enum.AutomaticSize.Y
												frame9.Size = UDim2.new(1, -20, v85[164], 0)
												frame9.Position = UDim2.fromOffset(v85[138], math.floor(40 * v94))
												frame9.BackgroundColor3 = tbl29.SURF
												frame9.BorderSizePixel = 0
												frame9.ZIndex = 101
												createUICorner2(frame9, v85[45])
												createUIStroke2(frame9, tbl29.AQUA_STROKE, 1, 0.48)
												local uiPadding = Instance.new("UIPadding", frame9)
												uiPadding.PaddingTop = UDim.new(0, 4)
												uiPadding.PaddingBottom = UDim.new(0, 4)
												uiPadding.PaddingLeft = UDim.new(0, 4)
												uiPadding.PaddingRight = UDim.new(0, v85[169])
												local uiListLayout2 = Instance.new("UIListLayout", frame9)
												uiListLayout2.Padding = UDim.new(0, 6)
												uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
												local tbl46 = {}
												local function fn89() for _, v106 in ipairs(tbl46) do pcall(v106) end end
												local function fn90(arg, arg2, arg3, arg4)
													local v106 = tbl38.chipRow(frame9, arg, arg2, function()
														arg4(not (arg3() and true or v85[139]))
														fn89()
													end)
													for _, child in ipairs(frame9:GetChildren()) do
														if child:IsA("Frame") and child.LayoutOrder == arg then
															local textLabel4 = child:FindFirstChildOfClass("TextLabel")
															local textButton3 = child:FindFirstChildOfClass("TextButton")
															if textButton3 then
																local floor2 = math.floor
																local n42 = v85[144] * v94
																textButton3.Size = UDim2.new(v85[164], math.floor(54 * v94), 0, floor2(n42))
																textButton3.Position = UDim2.new(1, -math.floor(62 * v94), 0.5, -math.floor(11 * v94))
															end
															if textLabel4 then
																textLabel4.Position = UDim2.fromOffset(v85[138], v85[164])
																textLabel4.Size = UDim2.new(v85[64], -math.floor(v85[52] * v94), 1, 0)
																textLabel4.TextSize = 11 * v94
															end
														end
													end
													local v107 = nil
													local function fn91()
														local flag26 = arg3() and true or false
														if flag26 ~= v107 then
															v107 = flag26
															v106(flag26 and v85[176] or "OFF", flag26)
														end
													end
													tbl46[#tbl46 + 1] = fn91
													fn91()
												end
												tbl38.head(frame9, 1, "BASE")
												fn90(2, "Xray Base", function()
													return v87.XrayBase == true
												end, function(arg)
													v87.XrayBase = arg and true or v85[139]
													fn32()
													if v87.XrayBase then
														fn72()
													else
														fn73()
													end
												end)
												tbl38.head(frame9, 3, "STEAL")
												fn90(4, "Manual Invis", function()
													return v87.ManualInvis == v85[192]
												end, function(arg)
													v87.ManualInvis = arg and v85[192] or false
													fn32()
													if type(genv.iCollectPro_InvisManual) == "function" then
														pcall(genv.iCollectPro_InvisManual, v87.ManualInvis)
													end
													fn34("Manual Invis", v87.ManualInvis and "on" or "off")
												end)
												fn90(5, "Auto Kick on Steal", function()
													return v87.AutoLeaveOnSteal == v85[192]
												end, function(arg)
													local iCollectProStartAutoKick = arg and genv.iCollectPro_StartAutoKick or genv.iCollectPro_StopAutoKick
													local v106 = v85[34]
													if type(iCollectProStartAutoKick) == v106 then pcall(iCollectProStartAutoKick) end
												end)
												fn90(v85[167], "Kick to PS on Steal", function()
													return v87.KickToPS == true
												end, function(arg)
													if type(genv.iCollectPro_SetKickToPS) == "function" then pcall(genv.iCollectPro_SetKickToPS, arg) end
												end)
												local frame10 = Instance.new("Frame", frame9)
												frame10.Name = "PSLinkRow"
												frame10.Size = UDim2.new(v85[64], v85[164], 0, math.floor(30 * v94))
												frame10.BackgroundColor3 = tbl29.SURF2
												frame10.BackgroundTransparency = v85[198]
												frame10.BorderSizePixel = 0
												frame10.LayoutOrder = 7
												frame10.ZIndex = 103
												frame10.ClipsDescendants = true
												createUICorner2(frame10, 11)
												createUIStroke2(frame10, tbl29.AQUA_STROKE, v85[64], 0.52)
												local textBox = Instance.new("TextBox", frame10)
												textBox.BackgroundTransparency = v85[64]
												textBox.Position = UDim2.fromOffset(12, 0)
												textBox.Size = UDim2.new(v85[64], -24, 1, 0)
												textBox.Font = Enum.Font.GothamBold
												textBox.TextSize = 11 * v94
												textBox.TextColor3 = tbl29.TEXT
												textBox.PlaceholderText = "paste PS link or code"
												textBox.PlaceholderColor3 = tbl29.OFF_TEXT
												textBox.Text = tostring(v87.KickPSLink or "")
												textBox.ClearTextOnFocus = false
												textBox.TextXAlignment = Enum.TextXAlignment.Left
												textBox.ZIndex = 104
												textBox.FocusLost:Connect(function()
													v87.KickPSLink = (textBox.Text or ""):match("^%s*(.-)%s*$")
													textBox.Text = v87.KickPSLink
													fn32()
													fn34("Kick to PS", v87.KickPSLink ~= "" and "link saved" or "link cleared")
												end)
												tbl38.head(frame9, 8, "PLAYERS")
												fn90(9, "Player ESP", function()
													return v87.PlayerESP ~= v85[139]
												end, function(arg)
													v87.PlayerESP = arg and true or v85[139]
													fn32()
												end)
												fn90(10, "No Player Collide", function()
													return v87.NoPlayerCollide ~= false
												end, function(arg)
													v87.NoPlayerCollide = arg and true or false
													fn32()
													if v87.NoPlayerCollide then pcall(genv.iCollectPro_NoCollideSweep) end
												end)
												local chipRow = nil
												local function fn91() chipRow(frame6.Visible and "CLOSE" or "OPEN", frame6.Visible) end
												local function toggleVisible()
													frame6.Visible = not frame6.Visible
													v87.ExtrasOpen = frame6.Visible
													fn32()
													fn91()
													if frame6.Visible and tbl17.RefreshMobileScaleFor then task.defer(tbl17.RefreshMobileScaleFor, frame6) end
												end
												chipRow = tbl38.chipRow
												chipRow = chipRow(tbl28.list, 9, "Extras", toggleVisible)
												fn91()
												task.spawn(function()
													while fn30() do
														if frame6.Visible then fn89() end
														task.wait(0.4)
													end
												end)
											end
											fn63()
											local v103 = tbl24
											local tbl39 = { "bat" }
											for _, v104 in ipairs(v103) do tbl39[#tbl39 + 1] = v104 end
											local fn64 = function(arg, arg2)
												local str6 = tostring(arg):lower()
												for _, v104 in ipairs(arg2) do if str6:find(v104, 1, true) then return true end end
												return false
											end
											local fn65 = function(arg, arg2, arg3)
												local character = localPlayer2.Character
												local backpack = localPlayer2:FindFirstChildOfClass("Backpack")
												if arg then arg = tostring(arg):lower() end
												local str6 = arg or ""
												local v104 = nil
												local v105 = nil
												local v106 = nil
												local function fn66(arg4)
													if not arg4 then return end
													for _, child in ipairs(arg4:GetChildren()) do
														if child:IsA("Tool") then
															local str7 = child.Name:lower()
															if str6 ~= "" and str7 == str6 then
																local v107 = v104
																local v108
																if v104 then
																	v108 = v107
																else
																	v108 = child
																end
																v104 = v108
															elseif arg2 and fn64(str7, arg2) then
																v105 = v105 or child
															elseif str6 ~= "" and str7:find(str6, 1, true) then
																v105 = v105 or child
															end
															v106 = v106 or child
														end
													end
												end
												fn66(character)
												fn66(backpack)
												if arg3 then return v104 or v105 or v106 end
												return v104 or v105
											end
											local fn66 = function(arg)
												local str6 = tostring(v87.CarpetTool or ""):lower()
												local flag22 = str6 ~= ""
												local flag23
												if flag22 then
													flag23 = tostring(arg):lower() == str6
												else
													flag23 = flag22
												end
												return flag23
											end
											local fn67 = function()
												local character = localPlayer2.Character
												if not character then return false end
												for _, child in ipairs(character:GetChildren()) do
													if child:IsA("Tool") and not fn64(child.Name, tbl39) and not fn66(child.Name) then return v85[192] end
												end
												return false
											end
											local fn68 = function() return fn65(v87.CarpetTool, v103, v85[139]) ~= nil end
											local fn69 = function()
												fn34("NEED A FLYING TOOL", "YOU NEED A FLYING TOOL (CARPET, BROOM, JETPACK...) TO USE FLY SPEED", 5)
											end
											game:GetService(v85[152])
											local fn70
											local v104 = nil
											fn70 = function(arg)
												carpetSpeed = arg and v85[192] or false
												v87.CarpetSpeed = carpetSpeed
												genv.iCollectPro_CarpetOn = carpetSpeed
												if v104 then
													pcall(function()
														v104:Disconnect()
													end)
													v104 = nil
												end
												if not carpetSpeed then return end
												if type(tbl17.DisableStealSpeed) == "function" then
													pcall(tbl17.DisableStealSpeed)
												elseif type(genv.iCollectPro_WalkSpeedSet) == "function" then
													pcall(genv.iCollectPro_WalkSpeedSet, false, v85[192])
												end
												local n40 = 0
												local n41 = 0
												v104 = fn31(runService.Heartbeat, function()
													local iCollectProTpBusy = genv.iCollectPro_TpBusy
													if iCollectProTpBusy and iCollectProTpBusy() then return end
													local now3 = os.clock()
													if now3 - n40 < math.clamp(9 / math.clamp(tonumber(v87.FlySpeedValue) or 250, 16, 500), 0.016666666666666666, 0.08) then
														return
													end
													n40 = now3
													local character = localPlayer2.Character
													if not character then return end
													local humanoid = character:FindFirstChildOfClass("Humanoid")
													local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
													if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then return end
													if fn67() then return end
													local v105 = fn65(v87.CarpetTool, v103, v85[139])
													if v105 and v105.Parent ~= character then
														local now4 = os.clock()
														if now4 - n41 > 0.4 then
															n41 = now4
															pcall(function()
																humanoid:EquipTool(v105)
															end)
														end
													end
													local n42 = math.clamp(tonumber(v87.FlySpeedValue) or 200, 16, 500)
													local moveDirection = humanoid.MoveDirection
													if moveDirection.Magnitude > 0 then
														humanoidRootPart.Velocity = Vector3.new(moveDirection.X * n42, humanoidRootPart.Velocity.Y, moveDirection.Z * n42)
													else
														humanoidRootPart.Velocity = Vector3.new(v85[164], humanoidRootPart.Velocity.Y, 0)
													end
												end)
											end
											local fn71
											do
												local v105 = nil
												local connection = nil
												local connection2 = nil
												local v106 = nil
												local n40 = 0
												local flag22 = false
												local function fn72()
													local playerGui2 = localPlayer2:FindFirstChild("PlayerGui")
													playerGui2 = playerGui2 and playerGui2:FindFirstChild("TouchGui")
													playerGui2 = playerGui2 and playerGui2:FindFirstChild("TouchControlFrame")
													local jumpButton = playerGui2 and playerGui2:FindFirstChild("JumpButton")
													if not jumpButton then return end
													if connection then
														pcall(function()
															connection:Disconnect()
														end)
													end
													if connection2 then
														pcall(function()
															connection2:Disconnect()
														end)
													end
													connection = jumpButton.InputBegan:Connect(function(input)
														if input.UserInputType == Enum.UserInputType.Touch then flag22 = true end
													end)
													connection2 = jumpButton.InputEnded:Connect(function(input)
														if input.UserInputType == Enum.UserInputType.Touch then flag22 = false end
													end)
												end
												fn71 = function(arg)
													infiniteJump = arg and true or v85[139]
													v87.InfiniteJump = infiniteJump
													for _, v107 in ipairs({ v105, connection, connection2, v106 }) do
														pcall(function()
															v107:Disconnect()
														end)
													end
													v105 = nil
													connection = nil
													connection2 = nil
													v106 = nil
													flag22 = false
													if not infiniteJump then return end
													task.spawn(function()
														for i = v85[64], 10 do
															if not infiniteJump then return end
															local playerGui2 = localPlayer2:FindFirstChild("PlayerGui")
															playerGui2 = playerGui2 and playerGui2:FindFirstChild("TouchGui")
															playerGui2 = playerGui2 and playerGui2:FindFirstChild("TouchControlFrame")
															if playerGui2 and playerGui2:FindFirstChild("JumpButton") then
																fn72()
																return
															end
															task.wait(0.5)
														end
													end)
													v106 = fn31(localPlayer2.CharacterAdded, function()
														flag22 = v85[139]
														task.delay(v85[64], function()
															if infiniteJump then fn72() end
														end)
													end)
													v105 = fn31(runService.Heartbeat, function()
														if not service:IsKeyDown(Enum.KeyCode.Space) and not flag22 then return end
														local now3 = tick()
														if now3 - n40 < 0.1 then return end
														local character = localPlayer2.Character
														if not character then return end
														local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
														local humanoid = character:FindFirstChildOfClass("Humanoid")
														if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then return end
														n40 = now3
														humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, 55, humanoidRootPart.Velocity.Z)
													end)
												end
											end
											do
												local flySpeed = fn52(frame3, "Fly Speed", 180 * v94)
												local function fn72() tbl38.paint(flySpeed, carpetSpeed == true) end
												fn72()
												flySpeed.button.MouseButton1Click:Connect(function()
													if not carpetSpeed and fn67() then
														fn34("Fly Speed", "blocked while carrying a brainrot")
														return
													end
													if not carpetSpeed and not fn68() then
														fn69()
														return
													end
													fn70(not carpetSpeed)
													fn32()
													fn72()
												end)
												task.spawn(function()
													local v105 = nil
													while fn30() do
														if carpetSpeed ~= v105 then
															v105 = carpetSpeed
															fn72()
														end
														task.wait(0.3)
													end
												end)
											end
											do
												local v105 = tbl38.pair(frame3, 7, "Drop", "Reset")
												local left = v105.left
												local right = v105.right
												left.stateLabel.Text = "DROP"
												left.stateLabel.TextColor3 = tbl29.TEXT
												left.button.BackgroundColor3 = tbl29.AQUA2
												left.stroke.Color = tbl29.AQUA_STROKE
												left.stroke.Transparency = 0.3
												local flag22 = v85[139]
												left.button.MouseButton1Click:Connect(function()
													if flag22 then return end
													local iCollectProDropBrainrot = genv.iCollectPro_DropBrainrot
													if type(iCollectProDropBrainrot) ~= "function" then
														fn34("Drop Brainrot", "not ready yet")
														return
													end
													flag22 = v85[192]
													left.stateLabel.Text = "..."
													task.spawn(function()
														pcall(iCollectProDropBrainrot)
														local iCollectProDropReady = genv.iCollectPro_DropReady
														if type(iCollectProDropReady) == "function" then
															local now3 = os.clock()
															while not iCollectProDropReady() and os.clock() - now3 < 2 do
																left.stateLabel.Text = "WAIT"
																task.wait(0.05)
															end
														end
														left.stateLabel.Text = "DROP"
														flag22 = false
													end)
												end)
												right.stateLabel.Text = "RESET"
												right.stateLabel.TextColor3 = tbl29.TEXT
												right.button.BackgroundColor3 = tbl29.AQUA2
												right.stroke.Color = tbl29.AQUA_STROKE
												right.stroke.Transparency = 0.3
												local flag23 = false
												local n40 = 0
												local function iCollectProInstaReset()
													if flag23 or os.clock() < n40 then return false, "cooldown" end
													local character = localPlayer2.Character
													if not character then return false, "no character" end
													local humanoid = character:FindFirstChildOfClass("Humanoid")
													local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
													if not humanoidRootPart or not humanoid then return false, "no character" end
													flag23 = true
													if genv.ICOLLECTPRO_ANTIDIE_ON ~= false then
														genv.ICOLLECTPRO_ANTIDIE_ON = false
														if type(genv.iCollectPro_AntiDieOff) == "function" then pcall(genv.iCollectPro_AntiDieOff) end
													end
													genv.iCollectPro_IsResetting = true
													genv.__iCollectProDropBusy = true
													local flag24 = v85[139]
													local function fn72()
														if flag24 then return end
														flag24 = true
														genv.iCollectPro_IsResetting = false
														genv.__iCollectProDropBusy = false
														local function fn73()
															local character2 = localPlayer2.Character
															local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")
															pcall(function()
																local currentCamera = workspace.CurrentCamera
																if not currentCamera then return end
																if currentCamera.CameraType == Enum.CameraType.Scriptable then
																	currentCamera.CameraType = Enum.CameraType.Custom
																end
																if humanoid2 then currentCamera.CameraSubject = humanoid2 end
															end)
															if humanoid2 and humanoid2.Parent then
																pcall(function()
																	humanoid2.PlatformStand = v85[139]
																	if humanoid2.Health > 0 then humanoid2:ChangeState(Enum.HumanoidStateType.Running) end
																end)
															end
															pcall(function()
																local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
																if humanoidRootPart2 then
																	humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
																	humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
																end
															end)
														end
														fn73()
														task.delay(1.5, fn73)
														if nil then
															genv.ICOLLECTPRO_ANTIDIE_ON = v85[192]
															local v106 = v85[34]
															if type(genv.iCollectPro_AntiDieOn) == v106 then pcall(genv.iCollectPro_AntiDieOn) end
														end
														local v106 = v85[67]
														n40 = os.clock() + v106
														flag23 = false
													end
													pcall(function()
														local currentCamera = workspace.CurrentCamera
														if not currentCamera then return end
														local cFrame = currentCamera.CFrame
														currentCamera.CameraType = Enum.CameraType.Scriptable
														currentCamera.CFrame = cFrame
													end)
													pcall(function()
														humanoid.BreakJointsOnDeath = v85[192]
														humanoid.PlatformStand = true
														humanoid:ChangeState(Enum.HumanoidStateType.Physics)
														humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
														humanoidRootPart.AssemblyLinearVelocity = Vector3.new(v85[164], 3000000, 0)
													end)
													local connection = nil
													connection = localPlayer2.CharacterAdded:Connect(function()
														if connection then
															pcall(function()
																connection:Disconnect()
															end)
															connection = nil
														end
														task.wait(v85[54])
														fn72()
													end)
													task.delay(2.5, function()
														if connection then
															pcall(function()
																connection:Disconnect()
															end)
															connection = nil
														end
														fn72()
													end)
													return v85[192]
												end
												genv.iCollectPro_InstaReset = iCollectProInstaReset
												right.button.MouseButton1Click:Connect(function()
													if flag23 then return end
													if os.clock() < n40 then
														fn34("Insta Reset", ("cooling down - %.1fs left"):format(n40 - os.clock()))
														return
													end
													local flag24 = false
													pcall(function()
														flag24 = iCollectProInstaReset()
													end)
													if not flag24 then
														fn34("Insta Reset", "no character to reset")
														return
													end
													right.stateLabel.Text = "..."
													task.spawn(function()
														local now3 = os.clock()
														while flag23 and os.clock() - now3 < 6 do task.wait(0.1) end
														while os.clock() < n40 do
															right.stateLabel.Text = ("%.1fs"):format(n40 - os.clock())
															task.wait(0.1)
														end
														right.stateLabel.Text = "RESET"
													end)
												end)
											end
											genv.iCollectPro_AutoNextBaseOn = nil
											genv.iCollectPro_CurrentPodium = nil
											do
												local flag22 = v85[139]
												local tbl40 = {}
												local tbl41 = {}
												local tbl42 = {}
												local tbl43 = nil
												local qualityLevel = nil
												local tbl44 = {}
												local v105 = nil
												local v106 = nil
												local flag23 = v85[139]
												local tbl45 = {}
												local flag24 = v85[139]
												local v107 = nil
												local service2 = game:GetService(v85[117])
												local function fn72(arg)
													return arg:IsDescendantOf(workspace) and arg:FindFirstAncestor("__PodiumStandFloors") ~= nil
												end
												local function fn73(arg)
													if fn72(arg) then return end
													if arg:IsA("BasePart") then
														if tbl40[arg] == nil then
															tbl40[arg] = {
																mat = arg.Material,
																ref = arg.Reflectance,
																cast = arg.CastShadow,
																fid = arg:IsA("MeshPart") and arg.RenderFidelity or nil,
															}
														end
														arg.CastShadow = v85[139]
														arg.Material = Enum.Material.SmoothPlastic
														arg.Reflectance = 0
														if arg:IsA("MeshPart") then arg.RenderFidelity = Enum.RenderFidelity.Performance end
														return
													end
													if arg:IsA("ParticleEmitter") or arg:IsA("Beam") or arg:IsA("Trail") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") or arg:IsA("PointLight") or arg:IsA("SpotLight") or arg:IsA("SurfaceLight") then
														if tbl41[arg] == nil then tbl41[arg] = arg.Enabled end
														arg.Enabled = v85[139]
														if arg:IsA("ParticleEmitter") then
															pcall(function()
																arg:Clear()
															end)
														end
														return
													end
													if arg:IsA("Decal") or arg:IsA("Texture") then
														if tbl42[arg] == nil then tbl42[arg] = arg.Transparency end
														arg.Transparency = 1
													end
												end
												local function fn74()
													local character = localPlayer2.Character
													return (pcall(function()
														for _, descendant in ipairs(workspace:GetDescendants()) do
															if descendant:IsA("Animator") and (not character or not descendant:IsDescendantOf(character)) then
																pcall(function()
																	for _, v108 in ipairs(descendant:GetPlayingAnimationTracks()) do v108:Stop(v85[164]) end
																end)
															end
														end
													end))
												end
												local tbl46 = {
													{ "DFIntDebugFRMQualityLevelOverride", "1" },
													{ "DFFlagTextureQualityOverrideEnabled", "True" },
													{ "DFIntTextureQualityOverride", "0" },
													{ "DFIntAnimationLodFacsDistanceMin", "0" },
													{ "DFIntAnimationLodFacsDistanceMax", "0" },
													{ "DFIntAnimationLodFacsVisibilityDenominator", "0" },
												}
												local function fn75()
													if type(setfflag) ~= "function" or type(getfflag) ~= "function" then return 0 end
													local n40 = 0
													for _, v108 in ipairs(tbl46) do
														local v109 = v108[v85[64]]
														local v110 = v108[2]
														if tbl45[v109] == nil then
															local ok, result = pcall(getfflag, v109)
															if not ok then
																tbl45[v109] = false
															else
																tbl45[v109] = tostring(result)
															end
														end
														if tbl45[v109] ~= false then if pcall(setfflag, v109, v110) then n40 += 1 end end
													end
													return n40
												end
												local function fn76()
													if type(setfflag) ~= "function" then return end
													for k, v108 in pairs(tbl45) do if v108 ~= v85[139] then pcall(setfflag, k, v108) end end
													table.clear(tbl45)
												end
												local tbl47 = {
													MeshPart = { "MeshId", "TextureID" },
													SpecialMesh = { "MeshId", "TextureId" },
													Decal = { "Texture" },
													Texture = { "Texture" },
												}
												local function fn77()
													if flag24 then return end
													flag24 = true
													task.spawn(function()
														local ContentProvider = game:GetService("ContentProvider")
														local plots2 = workspace:FindFirstChild("Plots") or workspace
														local tbl48 = {}
														local tbl49 = {}
														pcall(function()
															for _, descendant in ipairs(plots2:GetDescendants()) do
																if not (#tbl48 >= 400) then
																	local v108 = tbl47[descendant.ClassName]
																	if v108 then
																		for _, v109 in ipairs(v108) do
																			local ok, result = pcall(function()
																				return descendant[v109]
																			end)
																			if ok and type(result) == "string" and result ~= "" and not tbl49[result] then
																				tbl49[result] = true
																				tbl48[#tbl48 + 1] = result
																			end
																		end
																	end
																	continue
																end
																break
															end
														end)
														local n40 = 0
														for i = 1, #tbl48, 20 do
															if not flag22 or not fn30() then return end
															local tbl50 = {}
															for i2 = i, math.min(i + 20 - 1, #tbl48) do tbl50[#tbl50 + 1] = tbl48[i2] end
															pcall(function()
																ContentProvider:PreloadAsync(tbl50)
															end)
															n40 += #tbl50
															task.wait()
														end
														if n40 > 0 then print(("[iCollectPro] asset warm-up: %d ids"):format(n40)) end
													end)
												end
												local function fn78()
													fn75()
													pcall(function()
														local level01 = Enum.QualityLevel.Level01
														settings().Rendering.QualityLevel = level01
													end)
													pcall(function()
														service2.GlobalShadows = false
														service2.Brightness = 1
														service2.EnvironmentDiffuseScale = 0
														service2.EnvironmentSpecularScale = 0
													end)
													local v108 = v85[34]
													if type(sethiddenproperty) == v108 then
														pcall(function()
															sethiddenproperty(service2, "Technology", Enum.Technology.Compatibility)
														end)
													end
													for _, child in ipairs(service2:GetChildren()) do
														if child:IsA("PostEffect") then
															if tbl41[child] == nil then tbl41[child] = child.Enabled end
															pcall(function()
																child.Enabled = false
															end)
														end
													end
												end
												local function fn79()
													local ok, result = pcall(function()
														return workspace:GetDescendants()
													end)
													if not ok or not result then return v85[164] end
													local v108 = v85[164]
													for _, v109 in ipairs(result) do if pcall(fn73, v109) then v108 += 1 end end
													return v108
												end
												local function fn80()
													v106 = nil
													if v105 then
														pcall(function()
															v105:Disconnect()
														end)
														v105 = nil
													end
													table.clear(tbl44)
													flag23 = v85[139]
													for k, v108 in pairs(tbl40) do
														pcall(function()
															if k.Parent then
																k.Material = v108.mat
																k.Reflectance = v108.ref
																k.CastShadow = v108.cast
																if v108.fid and k:IsA("MeshPart") then k.RenderFidelity = v108.fid end
															end
														end)
													end
													table.clear(tbl40)
													for k, v108 in pairs(tbl41) do
														pcall(function()
															if k.Parent then k.Enabled = v108 end
														end)
													end
													table.clear(tbl41)
													for k, v108 in pairs(tbl42) do
														pcall(function()
															if k.Parent then k.Transparency = v108 end
														end)
													end
													table.clear(tbl42)
													if tbl43 then
														pcall(function()
															service2.GlobalShadows = tbl43.shadows
															service2.Brightness = tbl43.bright
															service2.EnvironmentDiffuseScale = tbl43.diff
															service2.EnvironmentSpecularScale = tbl43.spec
														end)
														local v108 = v85[34]
														if type(sethiddenproperty) == v108 and tbl43.tech then
															pcall(function()
																sethiddenproperty(service2, "Technology", tbl43.tech)
															end)
														end
														tbl43 = nil
													end
													if qualityLevel then
														pcall(function()
															settings().Rendering.QualityLevel = qualityLevel
														end)
														qualityLevel = nil
													end
													pcall(fn76)
												end
												local function fn81()
													pcall(function()
														tbl43 = {
															shadows = service2.GlobalShadows,
															bright = service2.Brightness,
															diff = service2.EnvironmentDiffuseScale,
															spec = service2.EnvironmentSpecularScale,
															tech = service2.Technology,
														}
													end)
													pcall(function()
														qualityLevel = settings().Rendering.QualityLevel
													end)
													fn78()
													local v108 = fn79()
													pcall(fn74)
													pcall(fn77)
													v105 = fn31(workspace.DescendantAdded, function(arg)
														if not flag22 then return end
														local n40 = #tbl44
														if n40 >= 2000 then
															flag23 = v85[192]
															table.clear(tbl44)
															return
														end
														tbl44[n40 + 1] = arg
													end)
													local tbl48 = {}
													v106 = tbl48
													task.spawn(function()
														local n40 = 0
														while v106 == tbl48 and fn30() do
															task.wait(0.3)
															if v106 ~= tbl48 then return end
															if flag23 then
																flag23 = false
																pcall(fn79)
															elseif #tbl44 > 0 then
																local v109 = tbl44
																tbl44 = {}
																for _, v110 in ipairs(v109) do if v110.Parent then pcall(fn73, v110) end end
															end
															n40 += 0.3
															if n40 >= 2 then
																pcall(fn78)
																pcall(fn74)
																n40 = 0
															end
														end
													end)
													return v108
												end
												local v108 = v85[121]
												tbl38.chipRow(tbl28.list, 21, "FPS Boost", function()
													flag22 = not flag22
													if flag22 then
														local v109 = v85[164]
														if not pcall(function()
															v109 = fn81()
														end) then
															flag22 = false
															fn80()
															v107("OFF", false)
															fn34("FPS BOOST", "failed - nothing was changed", v85[70])
															return
														end
														v107("ON", true)
														fn34("FPS BOOST", ("on - stripped %d objects, shadows and particles off"):format(v109), 4)
													else
														pcall(fn80)
														v107("OFF", false)
														fn34("FPS Boost", "off - the scene is back to normal", 3)
													end
												end)(v108, false)
												local chipRow = nil
												local function fn82()
													local iCollectProSetTheme = genv.iCollectPro_SetTheme
													if type(iCollectProSetTheme) ~= "function" then
														fn34("THEME", "not ready yet")
														return
													end
													local flag25 = iCollectProSetTheme(tostring(v87.Theme) == "halloween" and "default" or "halloween") == "halloween"
													chipRow(flag25 and "SPOOKY" or "DEFAULT", flag25)
													if flag25 then
														fn34("HAPPY HALLOWEEN", "PODIUMS ARE PUMPKINS NOW - TAP THEME AGAIN FOR THE PURPLE", 6)
													else
														fn34("THEME", "back to default", 3)
													end
												end
												chipRow = tbl38.chipRow
												chipRow = chipRow(tbl28.list, v85[144], "Theme", fn82)
												local v109 = nil
												local function fn83()
													local v110 = v85[1]
													local flag25 = tostring(v87.Theme) == v110
													local str6 = flag25 and "SPOOKY" or "DEFAULT"
													if str6 ~= v109 then
														v109 = str6
														chipRow(str6, flag25)
													end
												end
												fn83()
												task.spawn(function()
													while fn30() do
														fn83()
														task.wait(0.4)
													end
												end)
												genv.iCollectPro_FpsBoostOff = function()
													if flag22 then
														flag22 = v85[139]
														pcall(fn80)
													end
												end
											end
											local tbl40 = {
												{ "FIntDebugTextureManagerSkipMips", "7" },
												{ "FIntDefaultMeshCacheSizeMB", "256" },
												{ "FIntRenderShadowMapDepthCacheMemLimit", "192" },
												{ "FIntRenderMaxShadowAtlasUsageBeforeDownscale", "80" },
												{ "FIntTerrainOTAMaxTextureSize", "1024" },
												{ "FIntUITextureMaxRenderTextureSize", "1024" },
												{ "FIntDebugForceMSAASamples", "1" },
												{ "FIntRenderLocalLightFadeInMs", "0" },
												{ "FIntRobloxGuiBlurIntensity", "0" },
												{ "FIntFRMMinGrassDistance", "0" },
												{ "FIntFRMMaxGrassDistance", "0" },
												{ "FFlagFastGPULightCulling3", "True" },
												{ "FFlagDebugGraphicsPreferD3D11", "True" },
											}
											genv.iCollectPro_CopyFastFlags = function()
												local tbl41 = {}
												local n40 = 0
												for _, v105 in ipairs(tbl40) do
													local v106 = v85[34]
													if type(getfflag) == v106 then
														if pcall(getfflag, v105[1]) then
															tbl41[#tbl41 + v85[64]] = ("  \"%s\": \"%s\""):format(v105[1], v105[2])
														else
															n40 += 1
														end
													else
														tbl41[#tbl41 + v85[64]] = ("  \"%s\": \"%s\""):format(v105[1], v105[2])
													end
												end
												local str6 = "{\n" .. table.concat(tbl41, ",\n") .. "\n}"
												local writeClipboard = setclipboard or toclipboard or syn and syn.write_clipboard
												local v105 = v85[34]
												if type(writeClipboard) == v105 and pcall(writeClipboard, str6) then
													local v106 = v85[82]
													fn34("FASTFLAGS COPIED", ("%d flags on your clipboard - paste into Bloxstrap Engine Settings, then RESTART Roblox"):format(#tbl41), v106)
												else
													print(str6)
													fn34("FASTFLAGS", "no clipboard - the JSON is in your console", 6)
												end
												if n40 > 0 then print(("[iCollectPro] %d startup flags skipped (not in this client)"):format(n40)) end
												return str6
											end
											local flag22 = false
											genv.iCollectPro_TpToSlot = function(arg, arg2)
												if flag22 or not arg or not arg.Parent or not arg2 then return end
												local iCollectProSlotCF = genv.iCollectPro_SlotCF
												local iCollectProTpFlyTo = genv.iCollectPro_TpFlyTo
												local v105 = v85[34]
												if type(iCollectProSlotCF) ~= v105 or type(iCollectProTpFlyTo) ~= "function" then
													fn34("TP to Slot", "not ready yet")
													return
												end
												local v106 = iCollectProSlotCF(arg, arg2)
												if not v106 then
													fn34("TP to Slot", ("slot %d has no spot here"):format(arg2))
													return
												end
												local n40 = v106.Position + Vector3.new(v85[164], 3.5, 0)
												if carpetSpeed then
													fn34("CARPET SPEED STILL ACTIVE", "TURN IT OFF TO CONTINUE", 5)
													return
												end
												flag22 = true
												task.spawn(function()
													local v107 = v85[139]
													local str6 = "failed"
													pcall(function()
														local v108, v109 = iCollectProTpFlyTo(n40, { tool = v87.CarpetTool, plot = arg, speed = v85[28] })
														v107 = v108
														str6 = v109
													end)
													flag22 = false
													if not v107 then fn34("TP to Slot", "stopped - " .. tostring(str6)) end
												end)
											end
											do
												local flag23 = false
												local n40 = 0
												local function fn72()
													local ok, result = pcall(function()
														return Enum.RaycastFilterType.Exclude
													end)
													return ok and result or Enum.RaycastFilterType.Blacklist
												end
												local v105 = fn72()
												local function fn73()
													local character = localPlayer2.Character
													local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
													if not humanoidRootPart then return nil end
													local raycastParams = RaycastParams.new()
													raycastParams.FilterType = v105
													raycastParams.IgnoreWater = true
													local filterDescendantsInstances = { character }
													local position = humanoidRootPart.Position
													local n41 = 7
													for i = 1, 6 do
														raycastParams.FilterDescendantsInstances = filterDescendantsInstances
														local ok, result = pcall(function()
															return workspace:Raycast(position, Vector3.new(0, -n41, 0), raycastParams)
														end)
														if not ok or not result or not result.Instance then return nil end
														local instance4 = result.Instance
														if instance4:FindFirstAncestor("__PodiumStandFloors") then
															local match, v106 = tostring(instance4.Name):match("^(.*)_Podium_(%d+)$")
															local plots2 = workspace:FindFirstChild("Plots")
															local v107 = match and plots2 and plots2:FindFirstChild(match)
															if v107 and v106 then return v107, tonumber(v106) end
															return nil
														end
														local animalPodiums = instance4:FindFirstAncestor("AnimalPodiums")
														if animalPodiums then
															while instance4 and instance4.Parent ~= animalPodiums do instance4 = instance4.Parent end
															instance4 = instance4 and tonumber(instance4.Name)
															if instance4 and animalPodiums.Parent then return animalPodiums.Parent, instance4 end
															return nil
														end
														if instance4.CanCollide then return nil end
														n41 = n41 - (position.Y - result.Position.Y) - v85[130]
														if n41 <= 0 then return nil end
														position = result.Position - Vector3.new(v85[164], 0.05, 0)
														filterDescendantsInstances[#filterDescendantsInstances + v85[64]] = instance4
													end
													return nil
												end
												local function fn74(arg)
													arg = arg and arg:FindFirstChild("PlotSign")
													arg = arg and arg:FindFirstChild("SurfaceGui")
													arg = arg and arg:FindFirstChild("Frame")
													arg = arg and arg:FindFirstChild("TextLabel")
													if not arg then return v85[139] end
													local iCollectProRealSignText = genv.iCollectPro_RealSignText
													return tostring(type(iCollectProRealSignText) == "function" and iCollectProRealSignText(arg) or arg.Text):gsub("^%s+", ""):gsub("%s+$", ""):lower() == "empty base"
												end
												local function fn75(arg, arg2)
													local v106 = workspace:FindFirstChild(v85[2])
													if not v106 then return nil end
													local iCollectProMyPlot = genv.iCollectPro_MyPlot and genv.iCollectPro_MyPlot()
													local iCollectProNextBasePlot = genv.iCollectPro_NextBasePlot
													local flag24 = typeof(iCollectProNextBasePlot) == "Instance" and iCollectProNextBasePlot.Parent and iCollectProNextBasePlot ~= iCollectProMyPlot
													if flag24 then flag24 = not (arg2 and arg2[iCollectProNextBasePlot]) end
													if flag24 then return iCollectProNextBasePlot end
													local iCollectProEmptyBasesInOrder = genv.iCollectPro_EmptyBasesInOrder
													if type(iCollectProEmptyBasesInOrder) == "function" then
														local ok, result = pcall(iCollectProEmptyBasesInOrder)
														if ok and type(result) == "table" then
															for _, v107 in ipairs(result) do
																local flag25 = v107 ~= iCollectProMyPlot
																if flag25 then flag25 = not (arg2 and arg2[v107]) end
																if flag25 then return v107 end
															end
														end
													end
													local iCollectProMyPlotSpot = nil
													pcall(function()
														iCollectProMyPlotSpot = genv.iCollectPro_MyPlotSpot and genv.iCollectPro_MyPlotSpot(iCollectProMyPlot) or localPlayer2.Character.HumanoidRootPart.Position
													end)
													local v107 = nil
													local v108 = nil
													for _, child in ipairs(v106:GetChildren()) do
														local flag25 = child ~= arg and child ~= iCollectProMyPlot
														if flag25 then flag25 = not (arg2 and arg2[child]) end
														if flag25 and fn74(child) then
															local ok, result = pcall(function()
																return child:GetPivot().Position
															end)
															if ok and result then
																local magnitude = iCollectProMyPlotSpot and (result - iCollectProMyPlotSpot).Magnitude or 0
																if not v107 or magnitude < v107 then
																	v108 = child
																	v107 = magnitude
																end
															end
														end
													end
													return v108
												end
												local now3 = v85[164]
												local function fn76()
													if localPlayer2:GetAttribute("Stealing") then return v85[192] end
													local ok, result = pcall(fn67)
													return ok and result == v85[192]
												end
												local flag24 = v85[139]
												local fn77 = nil
												local function fn78(arg) if fn77 then pcall(fn77, arg, true) end end
												local function fn79()
													if fn77 then pcall(fn77, v87.AutoTpEmptyBase == true and "ON" or "OFF", v87.AutoTpEmptyBase == true) end
												end
												local function fn80(arg)
													local boundingBox, vector4 = arg:GetBoundingBox()
													local cframe
													if vector4.X > 200 or vector4.Y > 200 or vector4.Z > 200 then
														local mainRoot = arg:FindFirstChild("MainRoot")
														cframe = CFrame.new((mainRoot and mainRoot:IsA("BasePart") and mainRoot.Position or boundingBox.Position) + Vector3.new(v85[164], v85[142], 0))
														vector4 = Vector3.new(53, 48, 65)
													else
														cframe = boundingBox
													end
													return cframe, vector4
												end
												local function fn81(arg, arg2)
													local iCollectProSlotCF = genv.iCollectPro_SlotCF
													local iCollectProTpFlyTo = genv.iCollectPro_TpFlyTo
													if type(iCollectProSlotCF) ~= "function" or type(iCollectProTpFlyTo) ~= "function" then
														return false, "not ready"
													end
													local character = localPlayer2.Character
													local humanoid = character and character:FindFirstChildOfClass("Humanoid")
													local now4 = os.clock()
													while true do
														if humanoid and os.clock() - now4 < 3 then
															local v106 = fn65(v87.CarpetTool, v103, false)
															if v106 then
																if v106.Parent ~= character then
																	pcall(function()
																		humanoid:EquipTool(v106)
																	end)
																end
																if v106.Parent ~= character then
																	task.wait(0.1)
																	continue
																end
															else
																task.wait(0.1)
																continue
															end
														end
														break
													end
													character = character and character:FindFirstChild("HumanoidRootPart")
													local ok, result, result2 = pcall(function()
														return fn80(arg)
													end)
													if not (ok and result and result2) then return v85[139], "no base box" end
													local n41 = Vector3.new(-409.6 - result.Position.X >= 0 and v85[64] or -v85[64], 0, 0) * (result2.X * 0.5 + 12)
													local n42 = Vector3.new(result.Position.X, 0, result.Position.Z) + n41
													local y = nil
													local mainRoot = arg:FindFirstChild("MainRoot")
													pcall(function()
														local raycastParams = RaycastParams.new()
														raycastParams.FilterType = Enum.RaycastFilterType.Exclude
														local filterDescendantsInstances = {}
														local ipairs = ipairs
														local Players2 = game:GetService("Players")
														for _, player in ipairs(Players2:GetPlayers()) do
															if player.Character then
																filterDescendantsInstances[#filterDescendantsInstances + v85[64]] = player.Character
															end
														end
														local podiumStandFloors = workspace:FindFirstChild("__PodiumStandFloors")
														if podiumStandFloors then
															filterDescendantsInstances[#filterDescendantsInstances + 1] = podiumStandFloors
														end
														local vector4 = Vector3.new(n42.X, result.Position.Y + result2.Y * 0.5 + 30, n42.Z)
														for i = 1, v85[82] do
															raycastParams.FilterDescendantsInstances = filterDescendantsInstances
															local hit = workspace:Raycast(vector4, Vector3.new(v85[164], -400, v85[164]), raycastParams)
															if hit then
																if hit.Instance.CanCollide then
																	y = hit.Position.Y
																	break
																else
																	filterDescendantsInstances[#filterDescendantsInstances + 1] = hit.Instance
																	vector4 = hit.Position - Vector3.new(0, 0.05, v85[164])
																	continue
																end
															end
															break
														end
													end)
													if not y then
														y = mainRoot and mainRoot:IsA("BasePart") and mainRoot.Position.Y or result.Position.Y - result2.Y * 0.5
													end
													local vector4 = Vector3.new(n42.X, y + 3.5, n42.Z)
													local vector5 = Vector3.new(result.Position.X, y + 3.5, result.Position.Z)
													if character then
														for _, v106 in ipairs({ vector4, vector5 }) do
															local character2 = localPlayer2.Character
															character2 = character2 and character2:FindFirstChild("HumanoidRootPart")
															if character2 and (character2.Position - v106).Magnitude > 4 then
																local flag25 = false
																local str6 = "error"
																pcall(function()
																	local v107, v108 = iCollectProTpFlyTo(v106, { tool = v87.CarpetTool, plot = arg, speed = 150, direct = v85[192] })
																	flag25 = v107
																	str6 = v108
																end)
																if not flag25 then return false, str6 end
															end
														end
													end
													local num = tonumber(arg2)
													if num then
														local v106 = iCollectProSlotCF(arg, num)
														if v106 then
															local n43 = v106.Position + Vector3.new(0, 3.5, 0)
															local character2 = localPlayer2.Character
															character2 = character2 and character2:FindFirstChild("HumanoidRootPart")
															if character2 and (character2.Position - n43).Magnitude > v85[169] then
																pcall(function()
																	iCollectProTpFlyTo(n43, { tool = v87.CarpetTool, plot = arg, speed = 150 })
																end)
															end
														end
													end
													return true, "arrived"
												end
												local function fn82(arg, arg2)
													if fn76() then
														now3 = os.clock()
														return
													end
													if not fn75(arg) then
														fn34("AUTO TP", "no empty base to go to", 3)
														n40 = os.clock() + 3
														flag24 = true
														return
													end
													local iCollectProInstaReset = genv.iCollectPro_InstaReset
													if type(iCollectProInstaReset) ~= "function" then return end
													flag23 = v85[192]
													flag24 = v85[192]
													task.spawn(function()
														local flag25 = carpetSpeed == true
														if flag25 then pcall(fn70, false) end
														local function fn83()
															local character = localPlayer2.Character
															character = character and character:FindFirstChild("HumanoidRootPart")
															local plots2 = workspace:FindFirstChild("Plots")
															if not character or not plots2 then return false end
															for _, child in ipairs(plots2:GetChildren()) do
																local ok, result, result2 = pcall(function()
																	return fn80(child)
																end)
																if ok and result and result2 then
																	local v106 = result:PointToObjectSpace(character.Position)
																	local n41 = result2.X * 0.5
																	local flag26 = math.abs(v106.X) <= n41
																	if flag26 then
																		local n42 = result2.Y * 0.5
																		flag26 = math.abs(v106.Y) <= n42
																	end
																	if flag26 and math.abs(v106.Z) <= result2.Z * v85[140] then return true end
																end
															end
															return false
														end
														local character = localPlayer2.Character
														local flag26 = false
														local v106 = fn83()
														if v106 then
															fn78("RESET...")
															pcall(function()
																flag26 = iCollectProInstaReset()
															end)
														else
															flag26 = true
														end
														local flag27
														if flag26 then
															local now4 = os.clock()
															while true do
																if v106 and fn30() and os.clock() - now4 < 8 then
																	local character2 = localPlayer2.Character
																	if not (character2 and character2 ~= character and character2:FindFirstChild("HumanoidRootPart") and character2:FindFirstChildOfClass("Humanoid")) then
																		task.wait(0.05)
																		continue
																	end
																end
																break
															end
															local now5 = os.clock()
															while genv.iCollectPro_IsResetting and os.clock() - now5 < 1 do task.wait() end
															local character2 = localPlayer2.Character
															local flag28 = fn30() and character2 and (character2 ~= character or not v106)
															flag27 = false
															if flag28 then
																local tbl41 = {}
																local v107 = v85[164]
																local n41 = 0
																while true do
																	if n41 < 3 and v107 < 8 then
																		if not (not fn30() or fn76()) then
																			local v108 = fn75(arg, tbl41)
																			if not v108 then
																				fn34("TP EMPTY BASE", "no empty base left to go to", 3)
																				break
																			else
																				fn78("NEXT BASE")
																				local flag29 = false
																				local flag30 = true
																				task.spawn(function()
																					local n42 = v85[164]
																					while true do
																						if flag30 and fn30() then
																							task.wait(0.2)
																							if not flag30 then return end
																							if not fn74(v108) then
																								n42 += v85[64]
																							else
																								n42 = 0
																							end
																							if not (n42 >= 2) then continue end
																							flag29 = true
																							flag30 = v85[139]
																							local iCollectProTpCancel = genv.iCollectPro_TpCancel
																							local v109 = v85[34]
																							if type(iCollectProTpCancel) == v109 then
																								pcall(iCollectProTpCancel)
																							end
																							return
																						end
																						break
																					end
																				end)
																				local v109
																				flag27, v109 = fn81(v108, arg2)
																				flag30 = false
																				if flag27 then
																					break
																				else
																					if flag29 then
																						v107 += v85[64]
																						fn34("TP EMPTY BASE", "next base changed - re-routing", 2)
																						task.wait()
																					else
																						n41 += 1
																						tbl41[v108] = true
																						fn34("TP EMPTY BASE", "trip failed (" .. tostring(v109) .. ") - trying another base", 3)
																					end
																					continue
																				end
																			end
																		end
																	end
																	break
																end
															end
														else
															fn34("AUTO TP", "reset did not go through - not moving", 3)
															flag27 = false
														end
														if flag25 and fn30() then pcall(fn70, true) end
														n40 = os.clock() + (flag27 and 8 or 3)
														flag23 = false
														fn79()
													end)
												end
												local instance4 = Instance.new(v85[68], frame3)
												instance4.Name = "TPEmptyBaseRow"
												instance4.Size = UDim2.new(1, v85[164], 0, math.floor(30 * v94))
												instance4.BackgroundColor3 = tbl29.SURF2
												instance4.BackgroundTransparency = 0.02
												instance4.BorderSizePixel = 0
												instance4.LayoutOrder = 8
												instance4.ZIndex = 103
												createUICorner2(instance4, 11)
												createUIStroke2(instance4, tbl29.AQUA_STROKE, 1, 0.52)
												local textButton3 = Instance.new("TextButton", instance4)
												textButton3.Name = "TPEmptyPill"
												textButton3.AutoButtonColor = false
												local floor2 = math.floor
												textButton3.Size = UDim2.new(1, -math.floor(16 * v94), 0, floor2(22 * v94))
												textButton3.Position = UDim2.new(0, math.floor(8 * v94), 0.5, -math.floor(11 * v94))
												textButton3.BackgroundColor3 = tbl29.AQUA2
												textButton3.BorderSizePixel = 0
												textButton3.Font = Enum.Font.GothamBold
												textButton3.TextSize = 11 * v94
												textButton3.TextColor3 = tbl29.TEXT
												textButton3.Text = "TP EMPTY BASE"
												textButton3.ZIndex = 104
												createUICorner2(textButton3, 7)
												local v106 = createUIStroke2(textButton3, tbl29.AQUA_STROKE, 1, 0.3)
												local function fn83(text, arg)
													textButton3.Text = text
													textButton3.BackgroundColor3 = arg and tbl29.GREEN1 or tbl29.AQUA2
													v106.Color = arg and tbl29.GREEN_STROKE or tbl29.AQUA_STROKE
												end
												fn77 = function(arg)
													if arg == "ON" or arg == "OFF" then
														fn83("TP EMPTY BASE", v85[139])
													else
														fn83(arg, v85[192])
													end
												end
												local function iCollectProTpEmptyBase()
													if flag23 then return false end
													if fn76() then
														fn34("TP EMPTY BASE", "not while carrying a brainrot", v85[70])
														return v85[139]
													end
													local v107, v108 = fn73()
													fn82(v107, v108)
													return true
												end
												genv.iCollectPro_TpEmptyBase = iCollectProTpEmptyBase
												genv.iCollectPro_TpEmptyBusy = function() return flag23 == true end
												textButton3.MouseButton1Click:Connect(iCollectProTpEmptyBase)
											end
											local function fn72()
												local character = localPlayer2.Character
												if not character then return nil end
												for _, child in ipairs(character:GetChildren()) do if child:IsA("Tool") then return child end end
												return nil
											end
											genv.iCollectPro_EquipBatNow = function()
												local character = localPlayer2.Character
												local humanoid = character and character:FindFirstChildOfClass("Humanoid")
												if not humanoid or humanoid.Health <= 0 then return end
												local str6 = tostring(v87.BatTool or "Bat"):lower()
												local v105 = fn72()
												if v105 then
													local str7 = v105.Name:lower()
													if str6 ~= "" and str7:find(str6, 1, true) or fn64(str7, tbl39) or fn66(str7) then return end
												end
												local v106 = fn65(v87.BatTool, tbl39, v87.AutoEquipAny ~= v85[139])
												if not v106 or v106.Parent == character then return end
												pcall(function()
													humanoid:EquipTool(v106)
												end)
												if v106.Parent ~= character then
													pcall(function()
														v106.Parent = character
													end)
												end
											end
											do
												local function fn73()
													local ok, result = pcall(function()
														return Enum.RaycastFilterType.Exclude
													end)
													if ok and result then return result end
													return Enum.RaycastFilterType.Blacklist
												end
												local v105 = fn73()
												genv.iCollectPro_OnPodium = function()
													local character = localPlayer2.Character
													local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
													if not humanoidRootPart then return false end
													local raycastParams = RaycastParams.new()
													raycastParams.FilterType = v105
													raycastParams.IgnoreWater = v85[192]
													local filterDescendantsInstances = { character }
													local position = humanoidRootPart.Position
													local n40 = 7
													for i = 1, v85[167] do
														raycastParams.FilterDescendantsInstances = filterDescendantsInstances
														local ok, result = pcall(function()
															return workspace:Raycast(position, Vector3.new(v85[164], -n40, 0), raycastParams)
														end)
														if not ok or not result or not result.Instance then return false end
														local instance4 = result.Instance
														if instance4:FindFirstAncestor("AnimalPodiums") or instance4:FindFirstAncestor("__PodiumStandFloors") then
															return v85[192]
														end
														if instance4.CanCollide then return false end
														n40 = n40 - (position.Y - result.Position.Y) - 0.05
														if n40 <= v85[164] then return false end
														position = result.Position - Vector3.new(0, 0.05, 0)
														filterDescendantsInstances[#filterDescendantsInstances + 1] = instance4
													end
													return false
												end
											end
											fn31(runService.Heartbeat, function()
											end)
											fn31(service.InputBegan, function(arg, arg2)
												if arg2 then return end
												if arg.UserInputType ~= Enum.UserInputType.Keyboard then return end
												if service:GetFocusedTextBox() then return end
												local str6 = tostring(v87.CarpetSpeedKey or "Q")
												if str6 == "NONE" then return end
												local ok, result = pcall(function()
													return Enum.KeyCode[str6]
												end)
												if ok and result and arg.KeyCode == result then
													if not carpetSpeed and fn67() then
														fn34("Fly Speed", "blocked while carrying a brainrot")
														return
													end
													if not carpetSpeed and not fn68() then
														fn69()
														return
													end
													fn70(not carpetSpeed)
													fn32()
												end
											end)
											genv.iCollectPro_CarpetOff = function() fn70(false) end
											genv.iCollectPro_CarpetOn = carpetSpeed == true
											genv.iCollectPro_CarpetSet = function(arg)
												local flag23 = arg and v85[192] or false
												if flag23 and not carpetSpeed then
													if fn67() then
														fn34("Fly Speed", "blocked while carrying a brainrot")
														return v85[139]
													end
													if not fn68() then
														fn69()
														return false
													end
												end
												fn70(flag23)
												fn32()
												return carpetSpeed == true
											end
											genv.iCollectPro_CarpetIsOn = function() return carpetSpeed == true end
											if carpetSpeed then
												task.spawn(function()
													fn70(true)
												end)
											end
											task.spawn(function()
												fn71(v87.InfiniteJump ~= false)
											end)
											task.spawn(function()
												if 15979 >= n26(3897) then
													while v85[192] do
														if fn30() then
															task.wait(1.5)
															if instantSteal then
																instantSteal = false
																flag19 = false
																flag20 = false
																v87.InstantSteal = false
																genv.NEAREST_INSTANT_MODE = v85[139]
																genv.INSTANT_ANY = false
																task.wait(0.05)
																instantSteal = true
																v87.InstantSteal = true
																genv.NEAREST_INSTANT_MODE = v87.ZoneInstantMode == v85[192]
																genv.INSTANT_ANY = v89 == nil
															end
															continue
														end
														break
													end
													return
												end
												while true do
												end
											end)
											do
												local function fn73(arg)
													if not arg then return nil end
													local v105 = obj2[arg.uid]
													if v105 and v105.Parent then return v105 end
													local v106 = workspace_.Plots:FindFirstChild(arg.plot)
													if not v106 then return nil end
													local animalPodiums = v106:FindFirstChild("AnimalPodiums")
													if not animalPodiums then return nil end
													local animalList = fn43(v106.Name)
													animalList = animalList and animalList.AnimalList
													if not animalList then
														local v107 = animalPodiums:FindFirstChild(arg.slot)
														if v107 then
															local base = v107:FindFirstChild("Base")
															base = base and base:FindFirstChild("Spawn")
															if base then
																local promptAttachment = base:FindFirstChild("PromptAttachment")
																if promptAttachment then
																	for _, child in ipairs(promptAttachment:GetChildren()) do
																		if child:IsA("ProximityPrompt") then
																			obj2[arg.uid] = child
																			return child
																		end
																	end
																end
															end
														end
														return nil
													end
													local str6 = arg.name and arg.name:lower() or ""
													local slot = arg.slot
													local v107 = nil
													for k, v108 in pairs(animalList) do
														if type(v108) == "table" and tostring(k) == slot then
															local index = v108.Index
															local flag23 = v88[v108.Index]
															if flag23 then flag23 = (flag23.DisplayName or index):lower() == str6 end
															if flag23 then
																v107 = animalPodiums:FindFirstChild(tostring(k))
																break
															else
																v107 = nil
															end
														else
															v107 = nil
														end
													end
													v107 = v107 or animalPodiums:FindFirstChild(arg.slot)
													if v107 then
														local base = v107:FindFirstChild("Base")
														base = base and base:FindFirstChild("Spawn")
														if base then
															local promptAttachment = base:FindFirstChild("PromptAttachment")
															if promptAttachment then
																for _, child in ipairs(promptAttachment:GetChildren()) do
																	if child:IsA("ProximityPrompt") and child.Enabled and child.ActionText == "Steal" then
																		obj2[arg.uid] = child
																		return child
																	end
																end
															end
															local position = base.Position
															local x = position.X
															local z = position.Z
															local huge = math.huge
															local v108 = nil
															for _, descendant in pairs(v106:GetDescendants()) do
																if descendant:IsA("ProximityPrompt") and descendant.Enabled and descendant.ActionText == "Steal" then
																	local parent = descendant.Parent
																	local position2
																	if parent and parent:IsA("BasePart") then
																		position2 = parent.Position
																	else
																		local isBasePart = parent and parent:IsA("Attachment") and parent.Parent and parent.Parent:IsA("BasePart")
																		position2 = nil
																		if isBasePart then position2 = parent.Parent.Position end
																	end
																	if position2 then
																		local y = position.Y
																		if str6:find("la secret combinasion") then y = position.Y - 5 end
																		if math.sqrt((position2.X - x) ^ 2 + (position2.Z - z) ^ 2) < 5 and position2.Y > y then
																			local n40 = position2.Y - y
																			if n40 < huge then
																				huge = n40
																				v108 = descendant
																			end
																		end
																	end
																end
															end
															if v108 then
																obj2[arg.uid] = v108
																return v108
															end
														end
													end
													return nil
												end
												local function fn74(arg)
													if obj[arg] then return end
													local tbl41 = { holdCallbacks = {}, triggerCallbacks = {}, holdEndCallbacks = {}, ready = true }
													local ok, result = pcall(getconnections, arg.PromptButtonHoldBegan)
													if ok and type(result) == "table" then
														for _, v105 in ipairs(result) do
															if type(v105.Function) == "function" then table.insert(tbl41.holdCallbacks, v105.Function) end
														end
													end
													local ok2, result2 = pcall(getconnections, arg.Triggered)
													if ok2 then
														local v105 = v85[19]
														ok2 = type(result2) == v105
													end
													if ok2 then
														for _, v105 in ipairs(result2) do
															if type(v105.Function) == "function" then table.insert(tbl41.triggerCallbacks, v105.Function) end
														end
													end
													local ok3, result3 = pcall(getconnections, arg.PromptButtonHoldEnded)
													if ok3 and type(result3) == "table" then
														for _, v105 in ipairs(result3) do
															if type(v105.Function) == "function" then table.insert(tbl41.holdEndCallbacks, v105.Function) end
														end
													end
													if #tbl41.holdCallbacks > 0 or #tbl41.triggerCallbacks > 0 or #tbl41.holdEndCallbacks > 0 then
														obj[arg] = tbl41
													end
												end
												local function fn75(arg) for _, v105 in ipairs(arg) do task.spawn(v105) end end
												local function fn76(arg)
													local v105 = fn43(arg)
													if v105 then return fn42(v105.Owner) end
													return v85[139]
												end
												local function fn77()
													local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
													if not humanoidRootPart then return nil, math.huge, nil end
													local plots2 = workspace:FindFirstChild("Plots")
													if not plots2 then return nil, math.huge, nil end
													local huge = math.huge
													local v105 = nil
													local name = nil
													for _, child in ipairs(plots2:GetChildren()) do
														if not fn76(child.Name) then
															local huge2 = math.huge
															pcall(function()
																local position = humanoidRootPart.Position
																huge2 = (child:GetPivot().Position - position).Magnitude
															end)
															if huge2 > 100 then
															else
																local animalPodiums = child:FindFirstChild("AnimalPodiums")
																if not animalPodiums then
																else
																	for _, child2 in ipairs(animalPodiums:GetChildren()) do
																		local base = child2:FindFirstChild("Base")
																		base = base and base:FindFirstChild("Spawn")
																		if base then
																			local magnitude = (base.Position - humanoidRootPart.Position).Magnitude
																			if not (magnitude > 60 or magnitude >= huge) then
																				local promptAttachment = base:FindFirstChild("PromptAttachment")
																				if promptAttachment then
																					local proximityPrompt = promptAttachment:FindFirstChildOfClass("ProximityPrompt")
																					if proximityPrompt and proximityPrompt.Parent and proximityPrompt.Enabled then
																						name = child2.Name
																						huge = magnitude
																						v105 = proximityPrompt
																					end
																				end
																			end
																		end
																	end
																end
															end
														end
													end
													return v105, huge, name
												end
												local function fn78(arg, arg2)
													local v105 = obj[arg]
													if not v105 or not v105.ready then return v85[139] end
													v105.ready = false
													task.spawn(function()
														if v90 ~= arg2 then
															if tween then tween:Cancel() end
															v92.Size = UDim2.new(v85[164], 0, v85[64], v85[164])
															v90 = arg2
														end
														if #v105.holdCallbacks > 0 then
															fn75(v105.holdCallbacks)
															if not flag3 then return end
														end
														v92.Size = UDim2.new(0, v85[164], 1, 0)
														v92.BackgroundTransparency = v85[164]
														tween = tweenService:Create(v92, TweenInfo.new(1.2, Enum.EasingStyle.Linear), { Size = UDim2.new(1, v85[164], 1, v85[164]) })
														tween:Play()
														tween.Completed:Wait()
														if v90 == arg2 and #v105.triggerCallbacks > v85[164] then fn75(v105.triggerCallbacks) end
														v105.ready = true
													end)
													return true
												end
												local function fn79(arg, arg2)
													if not arg or not arg.Parent then return false end
													fn74(arg)
													if not obj[arg] then return false end
													if v90 ~= arg2 then
														if tween then
															tween:Cancel()
															tween = nil
														end
														v92.Size = UDim2.new(v85[164], v85[164], 1, 0)
													end
													return fn78(arg, arg2)
												end
												local function fn80() for _, v105 in pairs(obj2) do if v105 and v105.Parent then fn74(v105) end end end
												task.spawn(function()
													while task.wait(2) do
														if fn30() then
															if flag18 then fn80() end
															continue
														end
														break
													end
												end)
												local tbl41 = {}
												local function fn81(arg, arg2)
													if not arg then return "" end
													local str6 = "@" .. tostring(arg2 or "") .. "|"
													for k, v105 in pairs(arg) do
														if type(v105) == "table" then
															str6 ..= tostring(k) .. tostring(v105.Index) .. tostring(v105.Mutation)
														end
													end
													return str6
												end
												local function fn82(arg)
													local flag23 = v85[139]
													pcall(function()
														local v105 = fn43(arg.Name)
														if not v105 then return end
														local animalList = v105.AnimalList
														local owner = v105.Owner
														if fn42(owner) then
															tbl41[arg.Name] = nil
															for i = #allAnimalsCache, 1, -1 do
																if allAnimalsCache[i].plot == arg.Name then
																	table.remove(allAnimalsCache, i)
																	flag23 = true
																end
															end
															return
														end
														if not animalList or next(animalList) == nil then
															tbl41[arg.Name] = nil
															for i = #allAnimalsCache, 1, -1 do
																if allAnimalsCache[i].plot == arg.Name then
																	table.remove(allAnimalsCache, i)
																	flag23 = v85[192]
																end
															end
															return
														end
														local name = typeof(owner) == "Instance" and owner.Name or owner ~= nil and tostring(owner) or "Unknown"
														local v106 = fn81(animalList, name)
														if tbl41[arg.Name] == v106 then return end
														for i = #allAnimalsCache, v85[64], -v85[64] do
															if allAnimalsCache[i].plot == arg.Name then table.remove(allAnimalsCache, i) end
														end
														for k, v107 in pairs(animalList) do
															local v108 = v85[19]
															if type(v107) == v108 then
																local index = v107.Index
																local v109 = v88[v107.Index]
																if v109 then
																	local mutation = v107.Mutation or "None"
																	if mutation == "Yin Yang" then mutation = "YinYang" end
																	local str6 = v107.Traits and #v107.Traits > 0 and table.concat(v107.Traits, ", ") or "None"
																	local v110 = fn45(index, v107.Mutation, v107.Traits)
																	table.insert(allAnimalsCache, {
																		name = v109.DisplayName or index,
																		genText = "$" .. fn44(v110) .. "/s",
																		genValue = v110,
																		mutation = mutation,
																		traits = str6,
																		owner = name,
																		plot = arg.Name,
																		slot = tostring(k),
																		uid = arg.Name .. "_" .. tostring(k),
																	})
																end
															end
														end
														tbl41[arg.Name] = v106
														flag23 = true
													end)
													if flag23 then
														table.sort(allAnimalsCache, function(arg2, arg3)
															return arg2.genValue > arg3.genValue
														end)
														tbl17.AllAnimalsCache = allAnimalsCache
														tbl17.ListNeedsRedraw = true
														if fn48 then fn48() end
														if tbl17.UpdateAutoStealUI then tbl17.UpdateAutoStealUI() end
													end
												end
												local function fn83(arg)
													task.spawn(function()
														local v105 = v85[164]
														local v106 = nil
														while not v106 and v105 < 40 do
															if not fn30() then return end
															v106 = fn43(arg.Name)
															if not v106 then
																v105 += v85[64]
																task.wait(0.07)
															end
														end
														pcall(fn82, arg)
													end)
													local function fn84(arg2)
														if not arg2 then return end
														fn31(arg2.ChildAdded, function()
															task.wait(0.15)
															fn82(arg)
														end)
														fn31(arg2.ChildRemoved, function()
															for i = #allAnimalsCache, 1, -1 do
																if allAnimalsCache[i].plot == arg.Name then table.remove(allAnimalsCache, i) end
															end
															tbl41[arg.Name] = nil
															_getPetsCache = nil
															for k in pairs(obj2) do
																local name = arg.Name
																if k:sub(1, #arg.Name) == name then obj2[k] = nil end
															end
															tbl17.ListNeedsRedraw = v85[192]
															if tbl17.UpdateAutoStealUI then tbl17.UpdateAutoStealUI() end
															task.wait(0.15)
															fn82(arg)
														end)
													end
													local animalPodiums = arg:FindFirstChild("AnimalPodiums")
													fn84(animalPodiums)
													fn31(arg.ChildAdded, function(arg2)
														if arg2.Name == "AnimalPodiums" then
															fn84(arg2)
															fn82(arg)
														end
													end)
													fn31(arg.ChildRemoved, function(arg2)
														if arg2.Name == "AnimalPodiums" then
															for i = #allAnimalsCache, 1, -1 do
																if allAnimalsCache[i].plot == arg.Name then table.remove(allAnimalsCache, i) end
															end
															tbl41[arg.Name] = nil
															_getPetsCache = nil
															tbl17.ListNeedsRedraw = true
															if tbl17.UpdateAutoStealUI then tbl17.UpdateAutoStealUI() end
														end
													end)
													task.spawn(function()
														task.wait(math.random() * 3)
														while arg.Parent do
															if fn30() then
																task.wait(3)
																pcall(fn82, arg)
																continue
															end
															break
														end
													end)
												end
												local plots2 = workspace_:WaitForChild("Plots", v85[82])
												if plots2 then
													for _, child in ipairs(plots2:GetChildren()) do fn83(child) end
													fn31(plots2.ChildAdded, function(arg)
														task.wait(0.5)
														fn83(arg)
													end)
													fn31(plots2.ChildRemoved, function(arg)
														tbl41[arg.Name] = nil
														_getPetsCache = nil
														for i = #allAnimalsCache, 1, -1 do
															if allAnimalsCache[i].plot == arg.Name then table.remove(allAnimalsCache, i) end
														end
														for k in pairs(obj2) do
															local name = arg.Name
															if k:sub(1, #arg.Name) == name then obj2[k] = nil end
														end
														tbl17.ListNeedsRedraw = true
														if tbl17.UpdateAutoStealUI then tbl17.UpdateAutoStealUI() end
													end)
													local function iCollectProRescanPlots()
														if not plots2 or not plots2.Parent then return end
														local children = plots2:GetChildren()
														for _, child in ipairs(children) do tbl41[child.Name] = nil end
														for _, child in ipairs(children) do pcall(fn82, child) end
														tbl17.ListNeedsRedraw = v85[192]
														if tbl17.UpdateAutoStealUI then tbl17.UpdateAutoStealUI() end
													end
													genv.iCollectPro_RescanPlots = iCollectProRescanPlots
													local function fn84()
														for _, v105 in ipairs({ 0.3, 1.5, 4 }) do
															task.delay(v105, function()
																if fn30() then pcall(iCollectProRescanPlots) end
															end)
														end
													end
													fn31(game:GetService(v85[152]).PlayerAdded, fn84)
													fn31(game:GetService("Players").PlayerRemoving, fn84)
													local tbl42 = {}
													for _, child in ipairs(plots2:GetChildren()) do tbl42[child] = true end
													task.spawn(function()
														while fn30() do
															local flag23 = v85[192]
															pcall(function()
																flag23 = #fn49() == 0
															end)
															pcall(function()
																if not plots2 or not plots2.Parent then return end
																for _, child in ipairs(plots2:GetChildren()) do
																	if not tbl42[child] then
																		tbl42[child] = v85[192]
																		task.spawn(function()
																			pcall(fn83, child)
																		end)
																	end
																	if flag23 then tbl41[child.Name] = nil end
																	pcall(fn82, child)
																end
															end)
															task.wait(flag23 and 1 or 5)
														end
													end)
												end
												local function fn84(arg)
													if #arg == 0 then
														if textLabel.Text ~= v85[190] then
															textLabel.Text = "No target"
															if tween then
																tween:Cancel()
																tween = nil
															end
															v90 = nil
															v92.Size = UDim2.new(0, v85[164], 1, 0)
														end
														return
													end
													if v89 then
														for i, v105 in ipairs(arg) do
															if v105.uid == v89 then
																if n33 ~= i then
																	n33 = i
																	uid = v105.uid
																end
																textLabel.Text = string.format("%s - %s", v105.petName or "Unknown", v105.mpsText or "")
																return
															end
														end
														v89 = nil
													end
													if stealNearest then
														local character = localPlayer2.Character
														local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
														if humanoidRootPart then
															local huge = math.huge
															local v105, v106, v107 = ipairs(arg)
															local n40 = 1
															for k, v108 in v105, v106, v107 do
																local animalData = v108.animalData and fn39(v108.animalData)
																if animalData and animalData:IsA("BasePart") then
																	local magnitude = (humanoidRootPart.Position - animalData.Position).Magnitude
																	if magnitude < huge then
																		huge = magnitude
																		n40 = k
																	end
																end
															end
															if arg[n40] then
																local v108 = arg[n40]
																textLabel.Text = string.format("%s - %s", v108.petName or "Unknown", v108.mpsText or "")
															end
															if not instantSteal and n33 ~= n40 then
																n33 = n40
																uid = arg[n40] and arg[n40].uid
															end
														end
													elseif stealHighest then
														if n33 ~= 1 then
															n33 = 1
															uid = arg[1] and arg[1].uid
														end
													end
												end
												fn31(runService.Heartbeat, function()
													if not flag18 then return end
													fn84(fn49())
												end)
												task.spawn(function()
													while v85[192] do
														if fn30() then
															task.wait(0.5)
															if flag18 then
																local v105 = fn49()
																if v85[164] < #v105 then
																	tbl17.ListNeedsRedraw = false
																	fn53(flag18, v105)
																end
															end
															continue
														end
														break
													end
												end)
												fn31(runService.Heartbeat, function()
													if not flag18 then return end
													if instantSteal then
														if tween then
															tween:Cancel()
															tween = nil
														end
														if textLabel.Text == "No target" then
															v92.Size = UDim2.new(v85[164], v85[164], v85[64], v85[164])
														else
															v92.Size = UDim2.new(1, v85[164], 1, 0)
														end
														v92.BackgroundTransparency = 0
														if not flag20 then
															flag20 = true
															task.spawn(function()
																if not game:IsLoaded() then game.Loaded:Wait() end
																task.wait(v85[140])
																flag19 = true
															end)
														end
														if flag19 then
															if stealNearest and not v89 then
																local v105, v106 = fn77()
																if v105 then
																end
															else
																local v105 = fn49()
																if #v105 > 0 then
																	if #v105 < n33 then n33 = #v105 end
																	if n33 < 1 then n33 = 1 end
																	local v106 = v105[n33]
																	if v106 and not fn47(v106.animalData) then
																		local v107 = obj2[v106.uid]
																		if not v107 or not v107.Parent then fn73(v106.animalData) end
																	end
																end
															end
														end
														return
													end
													local v105 = fn49()
													if #v105 == 0 then return end
													if #v105 < n33 then n33 = #v105 end
													if n33 < v85[64] then n33 = v85[64] end
													local v106 = v105[n33]
													if not v106 or fn47(v106.animalData) then return end
													local v107 = obj2[v106.uid]
													if not v107 or not v107.Parent then v107 = fn73(v106.animalData) end
													if v107 then fn79(v107, v106.uid) end
												end)
											end
											task.spawn(function()
												while task.wait(0.5) do
													if fn30() then
														fn53(flag18, fn49())
														continue
													end
													break
												end
											end)
											task.spawn(function()
												task.wait(1)
												tbl17.ListNeedsRedraw = true
												fn53(flag18, fn49())
											end)
											task.spawn(function()
												while v85[192] do
													if fn30() then
														tbl17.AllAnimalsCache = allAnimalsCache
														task.wait(0.5)
														continue
													end
													break
												end
											end)
										end)
										task.spawn(function()
											if playerGui:FindFirstChild("IuCZFoVLhUds") then playerGui.IuCZFoVLhUds:Destroy() end
											local screenGui = Instance.new("ScreenGui")
											screenGui.Name = "IuCZFoVLhUds"
											fn29(screenGui)
											screenGui.ResetOnSpawn = false
											screenGui.IgnoreGuiInset = true
											screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
											screenGui.Parent = iCollectProUIHost()
											local function fn42(arg, arg2)
												local instance = Instance.new(arg)
												local v88 = pairs
												local tbl26 = arg2 or {}
												for k, v89 in v88(tbl26) do instance[k] = v89 end
												return instance
											end
											local Frame = fn42("Frame", {
												Name = "Outer",
												AnchorPoint = Vector2.new(0.5, 1),
												Size = UDim2.new(0, 520, 0, 46),
												Position = UDim2.new(v85[140], 0, 1, -86),
												BackgroundColor3 = Color3.fromRGB(18, 14, 28),
												BorderSizePixel = v85[164],
												Parent = screenGui,
											})
											local uiScale = Instance.new("UIScale")
											uiScale.Name = "ResponsiveScale"
											uiScale.Parent = Frame
											local n33 = 520
											local v88 = v85[57]
											local function fn43()
												local v89, vector2 = deviceClass()
												if not vector2 or vector2.X < 1 or vector2.Y < 1 then vector2 = Vector2.new(1920, v85[160]) end
												local flag18 = vector2.Y > vector2.X
												if v89 == v85[175] then
													flag18 = flag18 and 0.72 or v85[41]
												elseif v89 == "tablet" then
													flag18 = flag18 and 0.56 or 0.3
												else
													flag18 = 0.3
												end
												local n34
												if v89 == "desktop" then
													local v90 = v85[49]
													n34 = math.clamp(math.min(vector2.X / 1920, vector2.Y / 1080), v90, 1.2)
												else
													n34 = vector2.X * flag18 / n33
												end
												uiScale.Scale = math.clamp(math.min(n34, vector2.Y * (v89 == "desktop" and 0.11 or 0.085) / v88, vector2.X * 0.94 / n33), 0.4, 1.25)
												Frame.Position = UDim2.new(0.5, 0, v85[64], -math.floor(vector2.Y * 0.08 + 0.5))
											end
											fn43()
											local connection = nil
											local function fn44()
												if connection then
													pcall(function()
														connection:Disconnect()
													end)
													connection = nil
												end
												local currentCamera = workspace.CurrentCamera
												if currentCamera then connection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn43) end
												fn43()
											end
											fn44()
											fn31(workspace:GetPropertyChangedSignal("CurrentCamera"), fn44)
											fn42("UICorner", { CornerRadius = UDim.new(v85[164], v85[178]), Parent = Frame })
											fn42("UIStroke", {
												Color = Color3.fromRGB(v85[28], 70, 230),
												Thickness = 1,
												Transparency = 0.18,
												ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
												Parent = Frame,
											})
											local uiGradient = Instance.new("UIGradient")
											uiGradient.Rotation = v85[164]
											local colorSequence = ColorSequence.new
											local tbl26 = {}
											local v89 = ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 22, 44))
											local v90 = ColorSequenceKeypoint.new(0.35, Color3.fromRGB(22, 17, 34))
											local v91 = ColorSequenceKeypoint.new(0.72, Color3.fromRGB(16, v85[142], 26))
											local new = ColorSequenceKeypoint.new
											local color = Color3.fromRGB
											local v92 = v85[199]
											tbl26[1] = v89
											tbl26[2] = v90
											tbl26[3] = v91
											do
												local values = table.pack(new(1, color(23, 18, v92)))
												table.move(values, 1, values.n, 4, tbl26)
											end
											uiGradient.Color = colorSequence(tbl26)
											uiGradient.Parent = Frame
											fn42("Frame", {
												Name = "Sheen",
												Position = UDim2.new(0, 14, 0, v85[70]),
												Size = UDim2.new(1, -28, v85[164], 1),
												BackgroundColor3 = Color3.fromRGB(255, 255, 255),
												BackgroundTransparency = 0.95,
												BorderSizePixel = 0,
												ZIndex = 3,
												Parent = Frame,
											})
											local Frame2 = fn42("Frame", {
												Name = "Dot",
												AnchorPoint = Vector2.new(0.5, v85[140]),
												Position = UDim2.new(0, v85[144], v85[140], 0),
												Size = UDim2.new(0, 9, 0, 9),
												BackgroundColor3 = Color3.fromRGB(150, v85[141], v85[136]),
												BorderSizePixel = 0,
												ZIndex = 2,
												Parent = Frame,
											})
											fn42("UICorner", { CornerRadius = UDim.new(1, v85[164]), Parent = Frame2 })
											fn42(v85[115], {
												Color = Color3.fromRGB(190, 140, 255),
												Thickness = 1,
												Transparency = 0.35,
												ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
												Parent = Frame2,
											})
											local TextLabel = fn42("TextLabel", {
												Name = v85[124],
												BackgroundTransparency = 1,
												Position = UDim2.new(0, 38, v85[164], 0),
												Size = UDim2.new(0, 130, 1, 0),
												Font = Enum.Font.GothamBold,
												Text = "PUBLIC METHOD",
												TextSize = 15,
												TextColor3 = Color3.fromRGB(245, 246, 248),
												TextXAlignment = Enum.TextXAlignment.Left,
												TextYAlignment = Enum.TextYAlignment.Center,
												ZIndex = v85[67],
												Parent = Frame,
											})
											TextLabel.AutoLocalize = false
											TextLabel.TextStrokeTransparency = 0.92
											local TextLabel2 = fn42("TextLabel", {
												Name = "Invite",
												BackgroundTransparency = 1,
												Position = UDim2.new(0, 188, 0, 0),
												Size = UDim2.new(0, 178, 1, 0),
												Font = Enum.Font.GothamBlack,
												Text = "DISCORD.GG/FREESCRIPTS",
												TextSize = 17,
												TextScaled = true,
												TextColor3 = Color3.fromRGB(255, v85[149], 255),
												TextXAlignment = Enum.TextXAlignment.Center,
												TextYAlignment = Enum.TextYAlignment.Center,
												ZIndex = 2,
												Parent = Frame,
											})
											TextLabel2.AutoLocalize = false
											TextLabel2.TextStrokeColor3 = Color3.fromRGB(v85[194], v85[46], 70)
											TextLabel2.TextStrokeTransparency = 0.4
											local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel2)
											uiTextSizeConstraint.MaxTextSize = 15
											uiTextSizeConstraint.MinTextSize = 8
											local uiPadding = Instance.new("UIPadding", TextLabel2)
											uiPadding.PaddingTop = UDim.new(v85[164], 8)
											uiPadding.PaddingBottom = UDim.new(0, 8)
											uiPadding.PaddingLeft = UDim.new(0, 8)
											uiPadding.PaddingRight = UDim.new(0, 8)
											local uiGradient2 = Instance.new("UIGradient")
											uiGradient2.Rotation = v85[164]
											local colorSequence2 = ColorSequence.new
											local tbl27 = {}
											local v93 = ColorSequenceKeypoint.new(v85[164], Color3.fromRGB(v85[33], 45, 210))
											local v94 = ColorSequenceKeypoint.new(0.35, Color3.fromRGB(200, 130, v85[149]))
											local v95 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, v85[149], 255))
											local v96 = ColorSequenceKeypoint.new(0.65, Color3.fromRGB(200, 130, v85[149]))
											local new2 = ColorSequenceKeypoint.new
											local color2 = Color3.fromRGB
											local v97 = v85[33]
											tbl27[1] = v93
											tbl27[2] = v94
											tbl27[3] = v95
											tbl27[4] = v96
											do
												local values = table.pack(new2(1, color2(v97, 45, 210)))
												table.move(values, 1, values.n, 5, tbl27)
											end
											uiGradient2.Color = colorSequence2(tbl27)
											uiGradient2.Parent = TextLabel2
											task.spawn(function()
												local now2 = tick()
												while true do
													if TextLabel2 and TextLabel2.Parent then
														if fn30() then
															local v98 = v85[64]
															uiGradient2.Offset = Vector2.new((tick() - now2) * 0.35 % 2 - v98, v85[164])
															task.wait()
															continue
														end
													end
													break
												end
											end)
											local function fn45(arg)
												fn42("Frame", {
													Position = UDim2.new(v85[164], arg, 0.5, -11),
													Size = UDim2.new(v85[164], 1, 0, 22),
													BackgroundColor3 = Color3.fromRGB(110, 60, 170),
													BackgroundTransparency = 0.15,
													BorderSizePixel = 0,
													ZIndex = 2,
													Parent = Frame,
												})
											end
											fn45(180)
											fn45(374)
											fn45(450)
											fn42("TextLabel", {
												BackgroundTransparency = 1,
												Position = UDim2.new(v85[164], 388, 0, 8),
												Size = UDim2.new(0, 50, 0, 10),
												Font = Enum.Font.GothamBold,
												Text = "FPS",
												TextSize = 9.5,
												TextColor3 = Color3.fromRGB(155, v85[15], v85[126]),
												TextXAlignment = Enum.TextXAlignment.Left,
												TextYAlignment = Enum.TextYAlignment.Center,
												ZIndex = v85[67],
												Parent = Frame,
											}).AutoLocalize = false
											local TextLabel3 = fn42("TextLabel", {
												BackgroundTransparency = 1,
												Position = UDim2.new(0, 388, 0, v85[3]),
												Size = UDim2.new(v85[164], 52, 0, 17),
												Font = Enum.Font.GothamBold,
												Text = "0",
												TextSize = v85[78],
												TextColor3 = Color3.fromRGB(190, 140, 255),
												TextXAlignment = Enum.TextXAlignment.Left,
												TextYAlignment = Enum.TextYAlignment.Center,
												ZIndex = 2,
												Parent = Frame,
											})
											TextLabel3.AutoLocalize = false
											fn42("TextLabel", {
												BackgroundTransparency = 1,
												Position = UDim2.new(0, 462, 0, 8),
												Size = UDim2.new(0, 50, v85[164], 10),
												Font = Enum.Font.GothamBold,
												Text = "PING",
												TextSize = 9.5,
												TextColor3 = Color3.fromRGB(155, 120, 200),
												TextXAlignment = Enum.TextXAlignment.Left,
												TextYAlignment = Enum.TextYAlignment.Center,
												ZIndex = 2,
												Parent = Frame,
											}).AutoLocalize = v85[139]
											local TextLabel4 = fn42("TextLabel", {
												BackgroundTransparency = 1,
												Position = UDim2.new(0, 462, 0, 20),
												Size = UDim2.new(0, 52, 0, 17),
												Font = Enum.Font.GothamBold,
												Text = "0ms",
												TextSize = 15,
												TextColor3 = Color3.fromRGB(190, 140, 255),
												TextXAlignment = Enum.TextXAlignment.Left,
												TextYAlignment = Enum.TextYAlignment.Center,
												ZIndex = 2,
												Parent = Frame,
											})
											TextLabel4.AutoLocalize = false
											local n34 = 0
											local now2 = tick()
											fn31(runService.Heartbeat, function()
												n34 += 1
												local now3 = tick()
												if now3 - now2 >= 1 then
													TextLabel3.Text = tostring(n34)
													if n34 >= 60 then
														TextLabel3.TextColor3 = Color3.fromRGB(56, 214, 110)
													elseif n34 >= 30 then
														TextLabel3.TextColor3 = Color3.fromRGB(255, 165, 0)
													else
														TextLabel3.TextColor3 = Color3.fromRGB(220, 60, 60)
													end
													n34 = 0
													now2 = now3
												end
											end)
											task.spawn(function()
												while true do
													if Frame and Frame.Parent then
														if fn30() then
															local n35 = math.floor(localPlayer2:GetNetworkPing() * 1000)
															TextLabel4.Text = tostring(n35) .. "ms"
															if n35 < 80 then
																TextLabel4.TextColor3 = Color3.fromRGB(56, 214, 110)
															elseif n35 < 150 then
																TextLabel4.TextColor3 = Color3.fromRGB(255, 165, 0)
															else
																TextLabel4.TextColor3 = Color3.fromRGB(220, 60, 60)
															end
															task.wait(0.25)
															continue
														end
													end
													break
												end
											end)
										end)
										task.spawn(function()
											local tbl26 = {
												BG = Color3.fromRGB(20, v85[142], 34),
												SURF = Color3.fromRGB(28, 16, 46),
												SURF2 = Color3.fromRGB(48, 26, 76),
												TEXT = Color3.fromRGB(240, 232, 255),
												DIM = Color3.fromRGB(155, v85[15], 200),
												AQUA = Color3.fromRGB(v85[163], 85, 247),
												AQUA2 = Color3.fromRGB(124, 45, 190),
												AQUA_STROKE = Color3.fromRGB(150, 70, v85[136]),
												GREEN1 = Color3.fromRGB(18, 88, 58),
												GREEN2 = Color3.fromRGB(21, 120, 76),
												GREEN_STROKE = Color3.fromRGB(60, 185, 120),
											}
											local function createUICorner2(parent, arg)
												local uiCorner = Instance.new("UICorner")
												uiCorner.CornerRadius = UDim.new(v85[164], arg)
												uiCorner.Parent = parent
												return uiCorner
											end
											local function createUIStroke2(parent, color, thickness, transparency)
												local uiStroke = Instance.new("UIStroke")
												uiStroke.Color = color
												uiStroke.Thickness = thickness or 1
												uiStroke.Transparency = transparency or 0
												uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
												uiStroke.Parent = parent
												return uiStroke
											end
											local function createUIGradient(parent, arg, arg2, rotation)
												local uiGradient = Instance.new("UIGradient")
												uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, arg), ColorSequenceKeypoint.new(1, arg2) })
												uiGradient.Rotation = rotation or 0
												uiGradient.Parent = parent
												return uiGradient
											end
											local v88 = iCollectProUIHost()
											local qNvTxRbKzWme = v88:FindFirstChild("qNvTxRbKzWme")
											if qNvTxRbKzWme then qNvTxRbKzWme:Destroy() end
											local screenGui = Instance.new("ScreenGui")
											screenGui.Name = "qNvTxRbKzWme"
											fn29(screenGui)
											screenGui.ResetOnSpawn = false
											screenGui.IgnoreGuiInset = true
											screenGui.DisplayOrder = 999
											screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
											screenGui.Parent = v88
											local jobId = v87.Positions and v87.Positions.JobId
											local instance = Instance.new(v85[68], screenGui)
											instance.Name = "JobIdFrame"
											instance.AnchorPoint = Vector2.new(v85[140], 0)
											instance.Size = UDim2.new(0, 320, 0, 160)
											instance.Position = UDim2.new(jobId and jobId.X or 0.5, jobId and jobId.OffsetX or 0, jobId and jobId.Y or 0.02, jobId and jobId.OffsetY or v85[164])
											instance.BackgroundColor3 = tbl26.BG
											instance.BorderSizePixel = 0
											instance.ClipsDescendants = false
											instance.ZIndex = 100
											createUICorner2(instance, 18)
											createUIStroke2(instance, tbl26.AQUA_STROKE, 1.2, 0.4)
											fn33(instance)
											local imageLabel = Instance.new("ImageLabel", instance)
											imageLabel.Name = "Shadow"
											imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
											imageLabel.Position = UDim2.new(0.5, 0, 0.5, 2)
											imageLabel.Size = UDim2.new(1, 24, 1, 24)
											imageLabel.BackgroundTransparency = v85[64]
											imageLabel.Image = "rbxassetid://6014261993"
											imageLabel.ImageColor3 = Color3.new(0, 0, 0)
											imageLabel.ImageTransparency = 0.72
											imageLabel.ScaleType = Enum.ScaleType.Slice
											imageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
											imageLabel.ZIndex = 99
											local frame = Instance.new("Frame", instance)
											frame.Size = UDim2.new(1, 0, 0, 44)
											frame.BackgroundTransparency = 1
											frame.ZIndex = 101
											fn41(frame, instance, "JobId")
											local instance2 = Instance.new(v85[8], frame)
											instance2.Size = UDim2.new(1, -28, v85[164], 24)
											instance2.Position = UDim2.new(0, 14, 0, v85[138])
											instance2.BackgroundTransparency = 1
											instance2.Text = "SERVER JOB ID"
											instance2.Font = Enum.Font.GothamBlack
											instance2.TextSize = 18
											instance2.TextColor3 = tbl26.TEXT
											instance2.TextXAlignment = Enum.TextXAlignment.Center
											instance2.ZIndex = 102
											local frame2 = Instance.new("Frame", instance)
											frame2.AnchorPoint = Vector2.new(0.5, 0)
											frame2.Position = UDim2.new(0.5, 0, 0, 38)
											frame2.Size = UDim2.new(0, 124, v85[164], 1)
											frame2.BackgroundColor3 = Color3.fromRGB(v85[149], 255, 255)
											frame2.BackgroundTransparency = v85[156]
											frame2.BorderSizePixel = 0
											frame2.ZIndex = 101
											local frame3 = Instance.new("Frame", instance)
											frame3.Position = UDim2.fromOffset(v85[138], 46)
											frame3.Size = UDim2.new(1, -20, 0, v85[101])
											frame3.BackgroundColor3 = tbl26.SURF
											frame3.BorderSizePixel = 0
											frame3.ZIndex = 101
											createUICorner2(frame3, 16)
											createUIStroke2(frame3, tbl26.AQUA_STROKE, 1, 0.48)
											local textBox = Instance.new("TextBox", frame3)
											textBox.Name = "JobIdBox"
											textBox.Position = UDim2.fromOffset(7, v85[87])
											textBox.Size = UDim2.new(1, -14, 0, 26)
											textBox.BackgroundColor3 = tbl26.SURF2
											textBox.BorderSizePixel = 0
											textBox.Font = Enum.Font.Code
											textBox.TextSize = 12
											textBox.TextColor3 = tbl26.TEXT
											textBox.TextXAlignment = Enum.TextXAlignment.Center
											textBox.TextTruncate = Enum.TextTruncate.AtEnd
											textBox.ClearTextOnFocus = v85[139]
											textBox.TextEditable = false
											textBox.Selectable = true
											textBox.ZIndex = 102
											createUICorner2(textBox, 9)
											local v89 = createUIStroke2(textBox, tbl26.AQUA_STROKE, v85[64], 0.55)
											local textButton = Instance.new("TextButton", frame3)
											textButton.Name = "CopyButton"
											textButton.AutoButtonColor = v85[139]
											textButton.Position = UDim2.fromOffset(7, 39)
											textButton.Size = UDim2.new(0.5, -11, 0, 26)
											textButton.BackgroundColor3 = tbl26.AQUA2
											textButton.BorderSizePixel = v85[164]
											textButton.Text = "COPY"
											textButton.Font = Enum.Font.GothamBold
											textButton.TextSize = 12
											textButton.TextColor3 = tbl26.TEXT
											textButton.ZIndex = v85[155]
											createUICorner2(textButton, 9)
											local v90 = createUIStroke2(textButton, tbl26.AQUA_STROKE, 1, 0.35)
											createUIGradient(textButton, tbl26.AQUA, tbl26.AQUA2, v85[164])
											local visible = v87.HideJobId == true
											local textButton2 = Instance.new("TextButton", frame3)
											textButton2.Name = "EyeToggle"
											textButton2.AutoButtonColor = false
											textButton2.Text = ""
											textButton2.Position = UDim2.new(0.5, 4, 0, 39)
											textButton2.Size = UDim2.new(0.5, -11, 0, 26)
											textButton2.BackgroundColor3 = tbl26.SURF2
											textButton2.BorderSizePixel = 0
											textButton2.ZIndex = v85[155]
											createUICorner2(textButton2, 9)
											local v91 = createUIStroke2(textButton2, tbl26.AQUA_STROKE, 1, 0.5)
											local uiListLayout = Instance.new("UIListLayout", textButton2)
											uiListLayout.FillDirection = Enum.FillDirection.Horizontal
											uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
											uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
											uiListLayout.Padding = UDim.new(0, v85[87])
											uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
											local frame4 = Instance.new("Frame", textButton2)
											frame4.Name = "EyeIcon"
											frame4.LayoutOrder = 1
											frame4.Size = UDim2.fromOffset(v85[3], 14)
											frame4.BackgroundTransparency = v85[64]
											frame4.ZIndex = 103
											local frame5 = Instance.new("Frame", frame4)
											frame5.AnchorPoint = Vector2.new(v85[140], 0.5)
											frame5.Position = UDim2.fromScale(0.5, 0.5)
											frame5.Size = UDim2.fromOffset(v85[3], 13)
											frame5.BackgroundTransparency = v85[64]
											frame5.ZIndex = 103
											Instance.new("UICorner", frame5).CornerRadius = UDim.new(1, 0)
											local v92 = createUIStroke2(frame5, tbl26.TEXT, v85[36], 0.1)
											local frame6 = Instance.new("Frame", frame4)
											frame6.AnchorPoint = Vector2.new(v85[140], 0.5)
											frame6.Position = UDim2.fromScale(0.5, v85[140])
											frame6.Size = UDim2.fromOffset(v85[167], 6)
											frame6.BackgroundColor3 = tbl26.TEXT
											frame6.BorderSizePixel = 0
											frame6.ZIndex = 104
											Instance.new("UICorner", frame6).CornerRadius = UDim.new(1, 0)
											local frame7 = Instance.new("Frame", frame4)
											frame7.Name = "Slash"
											frame7.AnchorPoint = Vector2.new(0.5, 0.5)
											frame7.Position = UDim2.fromScale(0.5, 0.5)
											frame7.Size = UDim2.fromOffset(24, 2)
											frame7.Rotation = -32
											frame7.BackgroundColor3 = tbl26.TEXT
											frame7.BorderSizePixel = 0
											frame7.ZIndex = 105
											frame7.Visible = visible
											Instance.new("UICorner", frame7).CornerRadius = UDim.new(v85[64], v85[164])
											createUIStroke2(frame7, tbl26.SURF2, 1.4, 0.05)
											local textLabel = Instance.new("TextLabel", textButton2)
											textLabel.Name = "EyeLabel"
											textLabel.LayoutOrder = 2
											textLabel.AutomaticSize = Enum.AutomaticSize.X
											textLabel.Size = UDim2.fromOffset(v85[164], 14)
											textLabel.BackgroundTransparency = 1
											textLabel.Font = Enum.Font.GothamBold
											textLabel.TextSize = 12
											textLabel.TextColor3 = tbl26.TEXT
											textLabel.Text = "HIDE"
											textLabel.ZIndex = 103
											local function fn42(arg) return (arg:gsub("%w", "•")) end
											local function fn43()
												local str6 = tostring(game.JobId or "")
												if str6 == "" then return nil end
												return str6
											end
											local function fn44()
												local v93 = fn43()
												if v93 then
													textBox.Text = visible and fn42(v93) or v93
												else
													textBox.Text = "— no JobId (Studio / private) —"
												end
												textBox.TextColor3 = v93 and visible and tbl26.DIM or tbl26.TEXT
												frame7.Visible = visible
												textLabel.Text = visible and "SHOW" or "HIDE"
												textButton2.BackgroundColor3 = visible and tbl26.GREEN1 or tbl26.SURF2
												v91.Color = visible and tbl26.GREEN_STROKE or tbl26.AQUA_STROKE
												v91.Transparency = visible and 0.22 or v85[140]
												local color = visible and Color3.fromRGB(232, 255, 240) or tbl26.TEXT
												textLabel.TextColor3 = color
												v92.Color = color
												frame6.BackgroundColor3 = color
												v89.Color = visible and tbl26.GREEN_STROKE or tbl26.AQUA_STROKE
												v89.Transparency = visible and 0.4 or 0.55
											end
											fn44()
											textButton2.MouseButton1Click:Connect(function()
												visible = not visible
												v87.HideJobId = visible
												fn32()
												fn44()
											end)
											textButton2.MouseEnter:Connect(function()
												tweenService:Create(v91, TweenInfo.new(0.14), { Transparency = 0.12 }):Play()
											end)
											textButton2.MouseLeave:Connect(function()
												tweenService:Create(v91, TweenInfo.new(0.14), { Transparency = visible and 0.22 or 0.5 }):Play()
											end)
											textBox.Focused:Connect(function()
												if not fn43() or visible then
													textBox:ReleaseFocus()
													return
												end
												textBox.SelectionStart = 1
												textBox.CursorPosition = #textBox.Text + v85[64]
											end)
											local v93 = v85[164]
											local function fn45(text, arg)
												v93 += 1
												local v94 = v93
												textButton.Text = text
												if arg then
													textButton.BackgroundColor3 = tbl26.GREEN1
													v90.Color = tbl26.GREEN_STROKE
													v90.Transparency = 0.2
												else
													textButton.BackgroundColor3 = Color3.fromRGB(120, v85[194], 60)
													v90.Color = Color3.fromRGB(220, v85[129], 120)
													v90.Transparency = 0.2
												end
												task.delay(1.2, function()
													if v93 ~= v94 or not textButton.Parent then return end
													textButton.Text = "COPY"
													textButton.BackgroundColor3 = tbl26.AQUA2
													v90.Color = tbl26.AQUA_STROKE
													v90.Transparency = v85[23]
												end)
											end
											textButton.MouseEnter:Connect(function()
												if textButton.Text == "COPY" then
													tweenService:Create(v90, TweenInfo.new(0.14), { Transparency = 0.1 }):Play()
												end
											end)
											textButton.MouseLeave:Connect(function()
												if textButton.Text == "COPY" then
													tweenService:Create(v90, TweenInfo.new(0.14), { Transparency = 0.35 }):Play()
												end
											end)
											textButton.MouseButton1Click:Connect(function()
												local v94 = fn43()
												if not v94 then
													fn45("NO ID", false)
													return
												end
												local writeClipboard = setclipboard or toclipboard or syn and syn.write_clipboard
												if not writeClipboard then
													fn45("NO CLIPBOARD", v85[139])
													return
												end
												local ok = pcall(writeClipboard, v94)
												fn45(ok and "COPIED!" or "FAILED", ok)
											end)
											local function fn46(name, position, text)
												local textButton3 = Instance.new("TextButton", instance)
												textButton3.Name = name
												textButton3.AutoButtonColor = false
												textButton3.Position = position
												textButton3.Size = UDim2.new(0.5, -13, 0, 28)
												textButton3.BackgroundColor3 = tbl26.SURF
												textButton3.BorderSizePixel = 0
												textButton3.Font = Enum.Font.GothamBold
												textButton3.TextSize = 12
												textButton3.TextColor3 = tbl26.TEXT
												textButton3.Text = text
												textButton3.ZIndex = 101
												createUICorner2(textButton3, 9)
												local v94 = createUIStroke2(textButton3, tbl26.AQUA_STROKE, 1, 0.5)
												local frame8 = Instance.new("Frame", textButton3)
												frame8.AnchorPoint = Vector2.new(0, 0.5)
												frame8.Position = UDim2.new(0, v85[138], v85[140], 0)
												frame8.Size = UDim2.fromOffset(6, 6)
												frame8.BackgroundColor3 = tbl26.AQUA_STROKE
												frame8.BorderSizePixel = 0
												frame8.ZIndex = 102
												createUICorner2(frame8, 8)
												return textButton3, v94, frame8
											end
											local BlockNamesButton, v94, v95 = fn46("BlockNamesButton", UDim2.new(0, 10, 0, 124), "HIDE NAMES")
											local HideNumbersButton, v96, v97 = fn46("HideNumbersButton", UDim2.new(0.5, 3, 0, 124), "SHOW #")
											local function fn47(arg, arg2, arg3, arg4, arg5, arg6)
												arg.Text = arg5 .. (arg4 and "  ON" or "  OFF")
												arg.BackgroundColor3 = arg4 and tbl26.GREEN1 or tbl26.SURF
												local color = arg4 and Color3.fromRGB(232, 255, 240)
												local dim
												if color then
													dim = color
												else
													dim = arg6 and tbl26.DIM or tbl26.TEXT
												end
												arg.TextColor3 = dim
												arg2.Color = arg4 and tbl26.GREEN_STROKE or tbl26.AQUA_STROKE
												arg2.Transparency = arg4 and 0.22 or (arg6 and 0.7 or v85[140])
												arg3.BackgroundColor3 = arg4 and tbl26.GREEN_STROKE or tbl26.AQUA_STROKE
												arg3.BackgroundTransparency = arg6 and 0.55 or 0
											end
											local function fn48() fn47(BlockNamesButton, v94, v95, v87.BlockNames == true, "HIDE NAMES", v85[139]) end
											local function fn49()
												fn47(HideNumbersButton, v96, v97, v87.HideNumbers ~= v85[192], "SHOW #", v87.PodiumESP ~= true)
											end
											fn48()
											fn49()
											BlockNamesButton.MouseButton1Click:Connect(function()
												v87.BlockNames = not (v87.BlockNames == true)
												fn32()
												fn48()
												if genv.iCollectPro_SweepBlockNames then task.spawn(genv.iCollectPro_SweepBlockNames) end
											end)
											HideNumbersButton.MouseButton1Click:Connect(function()
												v87.HideNumbers = not (v87.HideNumbers == true)
												fn32()
												fn49()
												if genv.iCollectPro_SetPodiumNumbers then pcall(genv.iCollectPro_SetPodiumNumbers, v87.HideNumbers ~= true) end
											end)
											local function fn50(arg) tweenService:Create(arg, TweenInfo.new(0.14), { Transparency = 0.12 }):Play() end
											BlockNamesButton.MouseEnter:Connect(function()
												fn50(v94)
											end)
											BlockNamesButton.MouseLeave:Connect(function()
												fn48()
											end)
											HideNumbersButton.MouseEnter:Connect(function()
												fn50(v96)
											end)
											HideNumbersButton.MouseLeave:Connect(function()
												fn49()
											end)
											task.spawn(function()
												local flag18 = false
												local flag19 = nil
												while fn30() do
													if not flag18 and genv.iCollectPro_SetPodiumNumbers then
														pcall(genv.iCollectPro_SetPodiumNumbers, v87.HideNumbers ~= true)
														flag18 = true
													end
													if flag19 ~= (v87.PodiumESP == true) then
														flag19 = v87.PodiumESP == true
														fn49()
													end
													task.wait(0.5)
												end
											end)
										end)
									end
									do
										local RunService2, localPlayer3, flag18, iCollectProStopWalkFling, fn41
										do
											task.spawn(function()
												local RunService3 = game:GetService("RunService")
												local ReplicatedStorage = game:GetService("ReplicatedStorage")
												local localPlayer4 = game:GetService(v85[152]).LocalPlayer
												local tbl26 = {}
												local v88 = nil
												local humanoid = nil
												local humanoidRootPart = nil
												local animator = nil
												local vector = Vector3.new(0, 0, 0)
												local function fn42() return genv.ICOLLECTPRO_ANTIDIE_ON == v85[139] or genv.iCollectPro_IsResetting == true end
												local function fn43() return genv.__iCollectProDropBusy == true end
												local function fn44()
													if not v88 then return v85[139] end
													if not v88:FindFirstChildWhichIsA("Tool") then return false end
													local humanoidRootPart2 = v88:FindFirstChild("HumanoidRootPart")
													if humanoidRootPart2 then
														for _, child in ipairs(humanoidRootPart2:GetChildren()) do
															if child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyGyro") then
																return true
															end
														end
													end
													return false
												end
												local function fn45()
													if fn43() then return v85[139] end
													if not humanoid then return false end
													local state = humanoid:GetState()
													return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.GettingUp
												end
												local controls = nil
												local function fn46()
													if not controls then
														local playerScripts = localPlayer4:FindFirstChild("PlayerScripts")
														local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
														if not playerModule then return end
														pcall(function()
															controls = require(playerModule):GetControls()
														end)
													end
													if controls then
														pcall(function()
															controls:Enable()
														end)
													end
												end
												local function fn47()
													if not v88 then return end
													local v89 = fn44()
													local function fn48(arg)
														for _, child in ipairs(arg:GetChildren()) do
															if child:IsA("BallSocketConstraint") or child:IsA("NoCollisionConstraint") or child:IsA("HingeConstraint") or child:IsA("Attachment") and (child.Name == "A" or child.Name == v85[18]) then
																child:Destroy()
															elseif child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyGyro") then
																if not v89 then child:Destroy() end
															elseif child:IsA("Motor6D") then
																child.Enabled = true
															elseif child:IsA("BasePart") then
																for _, child2 in ipairs(child:GetChildren()) do
																	if child2:IsA("Motor6D") then
																		child2.Enabled = true
																	elseif child2:IsA("BallSocketConstraint") or child2:IsA("NoCollisionConstraint") or child2:IsA("HingeConstraint") then
																		child2:Destroy()
																	elseif child2:IsA("Attachment") and (child2.Name == "A" or child2.Name == v85[18]) then
																		child2:Destroy()
																	end
																end
															end
														end
													end
													pcall(function()
														fn48(v88)
													end)
													if animator then
														for _, v90 in pairs(animator:GetPlayingAnimationTracks()) do
															local str6 = v90.Animation and v90.Animation.Name:lower() or ""
															if str6:find("rag") or str6:find("fall") or str6:find("hurt") or str6:find("down") then
																v90:Stop(0)
															end
														end
													end
												end
												local function fn48(arg)
													pcall(function()
														arg.BreakJointsOnDeath = false
													end)
													pcall(function()
														arg.RequiresNeck = false
													end)
													pcall(function()
														arg:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
													end)
													pcall(function()
														arg:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
													end)
												end
												local function fn49(arg)
													pcall(function()
														arg.Health = arg.MaxHealth
													end)
													pcall(function()
														arg:ChangeState(Enum.HumanoidStateType.Running)
													end)
												end
												local function fn50(arg)
													v88 = arg
													humanoid = arg:WaitForChild("Humanoid", 10)
													humanoidRootPart = arg:WaitForChild("HumanoidRootPart", 10)
													animator = humanoid and humanoid:WaitForChild("Animator", 10)
													vector = Vector3.new(0, v85[164], 0)
													if humanoid and not fn42() then fn48(humanoid) end
												end
												local function iCollectProDisableAntiRagdoll()
													for _, v89 in pairs(tbl26) do
														pcall(function()
															v89:Disconnect()
														end)
													end
													tbl26 = {}
												end
												local function iCollectProEnableAntiRagdoll()
													iCollectProDisableAntiRagdoll()
													if not humanoid or not humanoidRootPart then return end
													local v89 = humanoid
													if not fn42() then fn48(v89) end
													table.insert(tbl26, fn31(v89:GetPropertyChangedSignal("Health"), function()
														if fn42() then return end
														if v89.Parent and v89.Health <= 0 then fn49(v89) end
													end))
													table.insert(tbl26, fn31(v89.Died, function()
														if fn42() then return end
														if v89.Parent then fn49(v89) end
													end))
													local v90 = v85[164]
													table.insert(tbl26, fn31(RunService3.Heartbeat, function()
														if not v89.Parent or fn42() then return end
														local now2 = os.clock()
														if now2 - v90 >= 1 then
															v90 = now2
															fn48(v89)
														end
														if v89.Health <= 0 then fn49(v89) end
													end))
													local position = nil
													local n33 = v85[164]
													local position2 = nil
													local function fn51()
														local character = localPlayer4.Character
														return character and character:FindFirstChild("HumanoidRootPart")
													end
													local function fn52()
														local attribute = localPlayer4:GetAttribute("RagdollEndTime")
														if type(attribute) ~= "number" then return 0 end
														return attribute - workspace:GetServerTimeNow()
													end
													local function fn53()
														local flag19 = fn43() or genv.iCollectPro_IsResetting == true or genv.iCollectPro_CarpetOn == true
														local flag20
														if flag19 then
															flag20 = flag19
														else
															flag20 = type(genv.iCollectPro_TpBusy) == "function" and genv.iCollectPro_TpBusy() == true
														end
														return flag20 or fn44()
													end
													local function fn54()
														if fn53() then return end
														local v91 = fn51()
														if not v91 then return end
														n33 = math.max(n33, os.clock() + 0.35)
														if not position then position = position2 or v91.Position end
														pcall(function()
															v91.AssemblyLinearVelocity = Vector3.zero
															v91.AssemblyAngularVelocity = Vector3.zero
														end)
													end
													local function fn55()
														local flag19 = position ~= nil
														local flag20
														if flag19 then
															flag20 = os.clock() < n33 or fn52() > 0
														else
															flag20 = flag19
														end
														return flag20
													end
													local function fn56(arg, arg2)
														if arg2 then
															local moveDirection = v89.MoveDirection
															if v85[164] < moveDirection.Magnitude then
																position += Vector3.new(moveDirection.X, v85[164], moveDirection.Z) * v89.WalkSpeed * arg2
															end
														end
														local v91, v92 = arg.CFrame:ToEulerAnglesYXZ()
														arg.CFrame = CFrame.new(position) * CFrame.Angles(v85[164], v92, 0)
														arg.AssemblyLinearVelocity = Vector3.zero
														arg.AssemblyAngularVelocity = Vector3.zero
													end
													table.insert(tbl26, fn31(humanoid.StateChanged, function()
														if fn45() then
															fn54()
															if not fn44() then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
															fn47()
															workspace.CurrentCamera.CameraSubject = humanoid
															fn46()
														end
													end))
													table.insert(tbl26, fn31(localPlayer4:GetAttributeChangedSignal("RagdollEndTime"), function()
														if fn52() > 0 then
															fn54()
															fn46()
														end
													end))
													local packages = ReplicatedStorage:FindFirstChild("Packages")
													packages = packages and packages:FindFirstChild("Net")
													for _, v91 in ipairs({ "RE/CombatService/ApplyImpulse", "RE/Ragdoll" }) do
														local v92 = packages and packages:FindFirstChild(v91)
														if v92 and v92:IsA("RemoteEvent") then
															table.insert(tbl26, fn31(v92.OnClientEvent, function()
																fn54()
															end))
														end
													end
													table.insert(tbl26, fn31(v88.DescendantAdded, function()
														if fn45() then fn47() end
													end))
													table.insert(tbl26, fn31(RunService3.PreSimulation, function()
														if not position or fn53() or not fn55() then return end
														local v91 = fn51()
														if v91 then pcall(fn56, v91) end
													end))
													table.insert(tbl26, fn31(RunService3.Heartbeat, function(arg)
														local v91 = fn51()
														if not v91 then return end
														if fn52() > 0 then
															fn46()
															if not position then fn54() end
														end
														if fn45() then fn47() end
														if position then
															if fn53() then
																position = nil
															elseif fn55() then
																pcall(fn56, v91, arg)
															else
																position = nil
																pcall(function()
																	v91.AssemblyLinearVelocity = Vector3.zero
																	v91.AssemblyAngularVelocity = Vector3.zero
																end)
															end
														else
															position2 = v91.Position
														end
													end))
													pcall(RunService3.UnbindFromRenderStep, RunService3, "iCollectProCamLock")
													pcall(function()
														RunService3:BindToRenderStep("iCollectProCamLock", Enum.RenderPriority.Camera.Value - 1, function()
															if not fn30() or genv.iCollectPro_IsResetting == true then return end
															local currentCamera = workspace.CurrentCamera
															local character = localPlayer4.Character
															if not currentCamera or not character or not v89.Parent then return end
															local cameraSubject = currentCamera.CameraSubject
															if cameraSubject ~= v89 and typeof(cameraSubject) == "Instance" and cameraSubject:IsDescendantOf(character) then
																currentCamera.CameraSubject = v89
															end
														end)
													end)
													table.insert(tbl26, { Disconnect = function()
														pcall(RunService3.UnbindFromRenderStep, RunService3, "iCollectProCamLock")
													end })
													fn46()
													fn47()
												end
												genv.iCollectPro_EnableAntiRagdoll = iCollectProEnableAntiRagdoll
												genv.iCollectPro_DisableAntiRagdoll = iCollectProDisableAntiRagdoll
												genv.iCollectPro_AntiDieOn = function()
													local character = localPlayer4.Character
													local humanoid2 = character and character:FindFirstChildOfClass("Humanoid")
													if humanoid2 then fn48(humanoid2) end
												end
												genv.iCollectPro_AntiDieOff = function()
													local character = localPlayer4.Character
													local humanoid2 = character and character:FindFirstChildOfClass("Humanoid")
													if not humanoid2 then return end
													pcall(function()
														humanoid2:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
													end)
													pcall(function()
														if n28(4631) <= 89 then
															humanoid2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
															return
														end
														while true do
														end
													end)
													pcall(function()
														humanoid2:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
													end)
													pcall(function()
														humanoid2.BreakJointsOnDeath = true
													end)
													pcall(function()
														humanoid2.RequiresNeck = true
													end)
												end
												fn31(localPlayer4.CharacterAdded, function(arg)
													iCollectProDisableAntiRagdoll()
													v88 = nil
													humanoid = nil
													humanoidRootPart = nil
													animator = nil
													local humanoid2 = arg:WaitForChild("Humanoid", 10)
													local humanoidRootPart2 = arg:WaitForChild("HumanoidRootPart", 10)
													if not humanoid2 or not humanoidRootPart2 then return end
													task.wait(0.2)
													fn50(arg)
													iCollectProEnableAntiRagdoll()
												end)
												if localPlayer4.Character then
													fn50(localPlayer4.Character)
													iCollectProEnableAntiRagdoll()
												end
											end)
											task.spawn(function()
												local StarterGui = game:GetService("StarterGui")
												local bindableEvent = Instance.new("BindableEvent")
												bindableEvent.Name = "iCollectProResetHook"
												bindableEvent.Event:Connect(function()
													if genv.ICOLLECTPRO_ANTIDIE_ON ~= false then
														fn34("Anti Die is On", "reset blocked - turn it off first")
														return
													end
													local character = localPlayer2.Character
													local humanoid = character and character:FindFirstChildOfClass("Humanoid")
													if humanoid then
														genv.iCollectPro_IsResetting = v85[192]
														pcall(function()
															humanoid.Health = 0
														end)
														task.delay(v85[64], function()
															genv.iCollectPro_IsResetting = v85[139]
														end)
													end
												end)
												for i = 1, 20 do
													if pcall(function()
														StarterGui:SetCore("ResetButtonCallback", bindableEvent)
													end) then
														return
													end
													task.wait(0.5)
												end
											end)
											task.spawn(function()
												local Players2 = game:GetService("Players")
												local function fn42(arg) return (arg:gsub("%W", "%%%0")) end
												local function fn43()
													local tbl26 = {}
													for _, player in ipairs(Players2:GetPlayers()) do
														if player.Name and player.Name ~= "" then tbl26[#tbl26 + 1] = player.Name end
														if player.DisplayName and player.DisplayName ~= "" and player.DisplayName ~= player.Name then
															tbl26[#tbl26 + v85[64]] = player.DisplayName
														end
													end
													table.sort(tbl26, function(arg, arg2)
														return #arg > #arg2
													end)
													return tbl26
												end
												local function fn44(arg, arg2)
													local match = arg:match("^%s*(.-)'s%s+Base%s*$")
													if match then for _, v88 in ipairs(arg2) do if match == v88 then return "DISCORD.GG/FREESCRIPTS" end end end
													for _, v88 in ipairs(arg2) do
														if arg:find(v88, 1, true) then arg = arg:gsub(fn42(v88), "DISCORD.GG/FREESCRIPTS") end
													end
													return arg
												end
												local obj = setmetatable({}, { __mode = "k" })
												local obj2 = setmetatable({}, { __mode = "k" })
												local function fn45(arg)
													local ok, result = pcall(function()
														return arg:GetAttribute("ICP_RealText")
													end)
													if ok and type(result) == "string" and result ~= "" and result ~= "DISCORD.GG/FREESCRIPTS" then
														return result
													end
													return nil
												end
												local function fn46(arg, arg2)
													if type(arg2) ~= "string" or arg2 == "" or arg2 == "DISCORD.GG/FREESCRIPTS" then return end
													pcall(function()
														arg:SetAttribute("ICP_RealText", arg2)
													end)
												end
												local function fn47(arg, arg2, arg3, arg4, arg5)
													local v88 = arg2(arg)
													if type(v88) ~= "string" then return end
													if v88 ~= "DISCORD.GG/FREESCRIPTS" and obj2[arg] ~= v88 then
														obj[arg] = v88
														fn46(arg, v88)
													elseif obj[arg] == nil or obj[arg] == "DISCORD.GG/FREESCRIPTS" then
														obj[arg] = fn45(arg) or arg5 or obj[arg]
														fn46(arg, obj[arg])
													end
													local v89 = obj[arg]
													if v89 == nil or v89 == "DISCORD.GG/FREESCRIPTS" then
														local flag19 = v88 ~= "DISCORD.GG/FREESCRIPTS" and v88
														if flag19 then
															v89 = flag19
														else
															v89 = fn45(arg) or arg5
														end
													end
													if type(v89) ~= "string" or v89 == "" then return end
													local flag19 = v87.BlockNames == v85[192] and fn44(v89, arg4) or v89
													if v88 ~= flag19 then if not pcall(arg3, arg, flag19) then return end end
													obj2[arg] = flag19
												end
												local function fn48(arg, arg2, arg3)
													local v88 = arg2(arg)
													if type(v88) ~= "string" or v88 == "" then return end
													if v88 ~= "DISCORD.GG/FREESCRIPTS" and obj2[arg] ~= v88 then
														obj[arg] = v88
														fn46(arg, v88)
													elseif obj[arg] == nil or obj[arg] == "DISCORD.GG/FREESCRIPTS" then
														obj[arg] = fn45(arg) or obj[arg]
													end
													local flag19 = obj[arg]
													if flag19 == nil or flag19 == "DISCORD.GG/FREESCRIPTS" then
														flag19 = v88 ~= "DISCORD.GG/FREESCRIPTS" and v88 or fn45(arg)
													end
													if type(flag19) ~= "string" or flag19 == "" then return end
													flag19 = v87.BlockNames == true and "DISCORD.GG/FREESCRIPTS" or flag19
													if v88 ~= flag19 then if not pcall(arg3, arg, flag19) then return end end
													obj2[arg] = flag19
												end
												local function fn49(arg) return arg.Text end
												local function fn50(arg, text) arg.Text = text end
												local function fn51(arg) return arg.DisplayName end
												local function fn52(arg, displayName) arg.DisplayName = displayName end
												local function fn53(arg)
													local iCollectProPlotOwnerName = genv.iCollectPro_PlotOwnerName
													local v88 = v85[34]
													if type(iCollectProPlotOwnerName) ~= v88 then return nil end
													local ok, result = pcall(iCollectProPlotOwnerName, arg)
													if ok and type(result) == "string" and result ~= "" then return result .. "'s Base" end
													return nil
												end
												local function fn54()
													local v88 = fn43()
													local plots = workspace:FindFirstChild("Plots")
													if plots then
														for _, child in ipairs(plots:GetChildren()) do
															local plotSign = child:FindFirstChild("PlotSign")
															if plotSign then
																local flag19 = nil
																for _, descendant in ipairs(plotSign:GetDescendants()) do
																	if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
																		if flag19 == nil and descendant.Text == "DISCORD.GG/FREESCRIPTS" and obj[descendant] == nil then
																			flag19 = fn53(child.Name) or false
																		end
																		fn47(descendant, fn49, fn50, v88, flag19 or nil)
																	end
																end
															end
														end
													end
													for _, player in ipairs(Players2:GetPlayers()) do
														local character = player.Character
														if character then
															local humanoid = character:FindFirstChildOfClass("Humanoid")
															if humanoid then
																local displayName = player.DisplayName
																if not displayName or displayName == "" then displayName = player.Name end
																fn47(humanoid, fn51, fn52, v88, displayName)
															end
															for _, descendant in ipairs(character:GetDescendants()) do
																if descendant:IsA("TextLabel") and descendant:FindFirstAncestorWhichIsA("BillboardGui") then
																	fn47(descendant, fn49, fn50, v88)
																end
															end
														end
													end
													local rngMachine = workspace:FindFirstChild("RNGMachine")
													if rngMachine then
														for _, descendant in ipairs(rngMachine:GetDescendants()) do
															if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
																fn47(descendant, fn49, fn50, v88)
															end
														end
													end
													for _, child in ipairs(workspace:GetChildren()) do
														if child:IsA(v85[174]) and child.Name:find("_Clone", 1, true) then
															local humanoid = child:FindFirstChildOfClass("Humanoid")
															if humanoid then fn48(humanoid, fn51, fn52) end
															for _, descendant in ipairs(child:GetDescendants()) do
																if descendant:IsA("TextLabel") and descendant:FindFirstAncestorWhichIsA("BillboardGui") then
																	fn48(descendant, fn49, fn50)
																end
															end
														end
													end
												end
												genv.iCollectPro_SweepBlockNames = function() pcall(fn54) end
												genv.iCollectPro_RealSignText = function(arg) return obj[arg] or arg and arg.Text or "" end
												task.spawn(function()
													while fn30() do
														pcall(fn54)
														task.wait(1)
													end
												end)
												fn31(Players2.PlayerAdded, function()
													task.delay(1, function()
														pcall(fn54)
													end)
												end)
											end)
											task.spawn(function()
												local tbl26 = {}
												local function fn42(arg)
													return tostring(arg or ""):lower():gsub("%s+", " "):find("collect zone", v85[64], true) ~= nil
												end
												local function fn43()
													local plots = workspace:FindFirstChild("Plots")
													if not plots then return end
													for _, child in ipairs(plots:GetChildren()) do
														for _, descendant in ipairs(child:GetDescendants()) do
															if (descendant:IsA("TextLabel") or descendant:IsA("TextBox")) and not tbl26[descendant] and fn42(descendant.Text) then
																tbl26[descendant] = true
															end
														end
													end
												end
												local function fn44()
													for k in pairs(tbl26) do
														if not k.Parent then
															tbl26[k] = nil
														elseif k.Text ~= "iCollectPro" then
															pcall(function()
																k.Text = "iCollectPro"
															end)
														end
													end
												end
												local now2 = v85[164]
												while fn30() do
													if os.clock() - now2 > 8 then
														now2 = os.clock()
														pcall(fn43)
													end
													pcall(fn44)
													task.wait(1)
												end
											end)
											task.spawn(function()
												local tbl26 = {}
												local function fn42(arg)
													return tostring(arg or ""):gsub("^%s+", ""):gsub("%s+$", ""):lower() == "empty base"
												end
												local function fn43(arg)
													if tbl26[arg] then return tbl26[arg] end
													local tbl27 = { t = arg.TextTransparency, s = arg.TextStrokeTransparency, strokes = {} }
													for _, descendant in ipairs(arg:GetDescendants()) do
														if descendant:IsA("UIStroke") then tbl27.strokes[descendant] = descendant.Enabled end
													end
													tbl26[arg] = tbl27
													return tbl27
												end
												local function fn44(arg, arg2, arg3, arg4)
													pcall(function()
														arg.TextTransparency = arg3 and 1 or arg2.t
														arg.TextStrokeTransparency = arg3 and v85[64] or arg2.s
													end)
													if not arg4 then
														for k, stroke in pairs(arg2.strokes) do
															if k.Parent then
																pcall(function()
																	k.Enabled = arg3 and false or stroke
																end)
															else
																arg2.strokes[k] = nil
															end
														end
														return
													end
													for _, descendant in ipairs(arg:GetDescendants()) do
														if descendant:IsA("UIStroke") then
															if arg2.strokes[descendant] == nil then arg2.strokes[descendant] = descendant.Enabled end
															pcall(function()
																descendant.Enabled = arg3 and false or arg2.strokes[descendant]
															end)
														end
													end
												end
												local function fn45()
													local v88 = workspace:FindFirstChild(v85[2])
													if not v88 then return end
													for _, child in ipairs(v88:GetChildren()) do
														local plotSign = child:FindFirstChild("PlotSign")
														if plotSign then
															for _, descendant in ipairs(plotSign:GetDescendants()) do
																if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then fn43(descendant) end
															end
														end
													end
												end
												local tbl27 = {}
												local function fn46()
													for k, v88 in pairs(tbl26) do
														if not k.Parent then
															tbl26[k] = nil
															tbl27[k] = nil
														else
															local v89 = fn42(k.Text)
															local now2 = os.clock()
															if v89 ~= (tbl27[k] == true) then
																tbl27[k] = v89
																v88.deepAt = now2
																fn44(k, v88, v89, true)
															elseif v89 then
																local flag19 = now2 - (v88.deepAt or 0) > 2
																if flag19 then v88.deepAt = now2 end
																fn44(k, v88, true, flag19)
															end
														end
													end
												end
												local n33 = 0
												while v85[192] do
													if fn30() then
														if os.clock() - n33 > 3 then
															n33 = os.clock()
															pcall(fn45)
														end
														pcall(fn46)
														task.wait(0.25)
														continue
													end
													break
												end
											end)
											RunService2 = game:GetService("RunService")
											do
												local Players2 = game:GetService("Players")
												local Workspace = game:GetService("Workspace")
												localPlayer3 = Players2.LocalPlayer
												local tbl26 = {}
												flag18 = false
												iCollectProStopWalkFling = function()
													flag18 = false
													for _, v88 in ipairs(tbl26) do
														if typeof(v88) == "RBXScriptConnection" then
															pcall(function()
																v88:Disconnect()
															end)
														end
													end
													tbl26 = {}
												end
												fn41 = function()
													flag18 = true
													local character = localPlayer3.Character
													if not character then
														if not flag3 then return end
														return
													end
													local upperTorso = nil
													for _, child in pairs(Workspace.CurrentCamera:GetChildren()) do
														if child.Name == "UpperTorso" or child.Name == "Torso" then
															upperTorso = child
															break
														end
													end
													if not upperTorso then
														upperTorso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
													end
													if not upperTorso then
														for _, child in pairs(Workspace.CurrentCamera:GetChildren()) do
															if child.Name == "HumanoidRootPart" then
																upperTorso = child
																break
															end
														end
														upperTorso = upperTorso or character:FindFirstChild("HumanoidRootPart")
													end
													if not upperTorso then return end
													table.insert(tbl26, RunService2.Stepped:Connect(function()
														if not flag18 then return end
														for _, player in ipairs(Players2:GetPlayers()) do
															if player ~= localPlayer3 and player.Character then
																for _, child in ipairs(player.Character:GetChildren()) do
																	if child:IsA("BasePart") and child.CanCollide then child.CanCollide = false end
																end
															end
														end
													end))
													local thread = coroutine.create(function()
														pcall(function()
															upperTorso.AssemblyLinearVelocity = Vector3.zero
															upperTorso.AssemblyAngularVelocity = Vector3.zero
														end)
														RunService2.Heartbeat:Wait()
														while flag18 do
															RunService2.Heartbeat:Wait()
															if not (not upperTorso or not upperTorso.Parent) then
																local velocity = upperTorso.Velocity
																local velocity2 = velocity * 10000 + Vector3.new(0, 10000, v85[164])
																if velocity2.Magnitude > 12000 then velocity2 = velocity2.Unit * 12000 end
																upperTorso.Velocity = velocity2
																RunService2.RenderStepped:Wait()
																if upperTorso then upperTorso.Velocity = velocity end
																RunService2.Stepped:Wait()
																if upperTorso then upperTorso.Velocity = velocity + Vector3.new(0, 0.1, 0) end
																continue
															end
															break
														end
													end)
													coroutine.resume(thread)
													table.insert(tbl26, thread)
												end
											end
										end
										do
											local flag19 = false
											genv.iCollectPro_DropBrainrot = function()
												if flag18 or flag19 then return end
												flag19 = true
												genv.__iCollectProDropBusy = v85[192]
												local v88 = v85[169]
												genv.__iCollectProDropUntil = os.clock() + v88
												local flag20 = genv.iCollectPro_InvisActive == v85[192]
												if flag20 then
													genv.iCollectPro_InvisHold = true
													if type(genv.iCollectPro_InvisStop) == "function" then pcall(genv.iCollectPro_InvisStop) end
													local now2 = os.clock()
													while os.clock() - now2 < 1.5 do
														RunService2.Heartbeat:Wait()
														local character = localPlayer3.Character
														local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
														if not (humanoidRootPart and humanoidRootPart.Parent == character and humanoidRootPart:IsDescendantOf(workspace) and not humanoidRootPart.Anchored and humanoidRootPart.AssemblyLinearVelocity.Magnitude < 8) then
															continue
														end
														break
													end
													for i = 1, 4 do RunService2.Heartbeat:Wait() end
													pcall(function()
														local character = localPlayer3.Character
														character = character and character:FindFirstChild("HumanoidRootPart")
														if character then
															character.AssemblyLinearVelocity = Vector3.zero
															character.AssemblyAngularVelocity = Vector3.zero
														end
													end)
												end
												fn41()
												task.delay(0.6, function()
													iCollectProStopWalkFling()
													genv.__iCollectProDropBusy = false
													flag19 = false
													genv.__iCollectProDropUntil = os.clock() + 4
													genv.iCollectPro_InvisHold = false
													if flag20 and type(genv.iCollectPro_InvisSync) == "function" then
														task.delay(4, function()
															pcall(genv.iCollectPro_InvisSync)
														end)
													end
												end)
											end
											genv.iCollectPro_DropReady = function() return not flag18 and not flag19 end
										end
										genv.iCollectPro_StopWalkFling = iCollectProStopWalkFling
									end
								end
							end
							do
								local HttpService
								do
									do
										task.spawn(function()
											local RunService2 = game:GetService("RunService")
											local localPlayer2 = game:GetService("Players").LocalPlayer
											local function fn39()
												local ok, result = pcall(function()
													return Enum.RaycastFilterType.Exclude
												end)
												if ok and result then return result end
												return Enum.RaycastFilterType.Blacklist
											end
											local v88 = fn39()
											local function fn40()
												local character = localPlayer2.Character
												local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
												if not humanoidRootPart then return false end
												local raycastParams = RaycastParams.new()
												raycastParams.FilterType = v88
												raycastParams.IgnoreWater = true
												local filterDescendantsInstances = { character }
												local position = humanoidRootPart.Position
												local n33 = 7
												for i = 1, 6 do
													raycastParams.FilterDescendantsInstances = filterDescendantsInstances
													local ok, result = pcall(function()
														return workspace:Raycast(position, Vector3.new(0, -n33, 0), raycastParams)
													end)
													if not ok or not result or not result.Instance then return v85[139] end
													local instance = result.Instance
													if instance:FindFirstAncestor("AnimalPodiums") then return true end
													if instance.CanCollide then return v85[139] end
													n33 = n33 - (position.Y - result.Position.Y) - 0.05
													if n33 <= v85[164] then return false end
													position = result.Position - Vector3.new(0, 0.05, 0)
													filterDescendantsInstances[#filterDescendantsInstances + 1] = instance
												end
												return false
											end
											local tbl25 = {}
											local function fn41()
												local character = localPlayer2.Character
												if not character then return end
												for _, child in ipairs(character:GetChildren()) do
													if child:IsA("Tool") and child.Enabled and tbl25[child] == nil then
														tbl25[child] = v85[192]
														pcall(function()
															child.Enabled = false
														end)
													end
												end
											end
											local function fn42()
												for k in pairs(tbl25) do
													pcall(function()
														if k.Parent then k.Enabled = v85[192] end
													end)
												end
												table.clear(tbl25)
											end
											fn31(localPlayer2.CharacterAdded, function()
												table.clear(tbl25)
											end)
											local n33 = v85[164]
											fn31(RunService2.Heartbeat, function(arg)
												n33 += arg
												if n33 < v85[13] then return end
												n33 = 0
												if fn40() then
													fn41()
												elseif next(tbl25) ~= nil then
													fn42()
												end
											end)
										end)
										if not pcall(function()
											local Players2 = game:GetService("Players")
											local RunService2 = game:GetService("RunService")
											local Workspace = game:GetService("Workspace")
											local PathfindingService = game:GetService("PathfindingService")
											local localPlayer2 = Players2.LocalPlayer
											local function fn39()
												local ok, result = pcall(function()
													return Enum.RaycastFilterType.Exclude
												end)
												if ok and result then return result end
												return Enum.RaycastFilterType.Blacklist
											end
											local v88 = fn39()
											local function fn40(arg)
												if arg and arg.Parent then
													arg.AssemblyLinearVelocity = Vector3.zero
													arg.AssemblyAngularVelocity = Vector3.zero
												end
											end
											local function fn41(arg, arg2, arg3)
												local n33 = tonumber(arg) or 185
												local n34 = tonumber(arg3) or 55
												if n34 <= 0 or n34 >= n33 or not arg2 then return n33 end
												if arg2 >= 85 then return n33 end
												if arg2 <= 12 then return n34 end
												return n34 + (n33 - n34) * ((arg2 - 12) / 73)
											end
											local function fn42(arg)
												if fn38() then return 55 end
												local n33 = math.clamp(95 + (tonumber(arg) or v85[164]) * 0.9, 125, 250)
												local ok, result = pcall(function()
													return localPlayer2:GetNetworkPing() * 1000
												end)
												if ok and type(result) == "number" and result > v85[164] then
													n33 *= math.clamp(1 - (result - 70) / 320, 0.6, 1)
												end
												if not (n24 > 3414) then return math.clamp(n33, 85, 250) end
												while true do
												end
											end
											local v89 = tbl24
											local function fn43(arg)
												local str6 = tostring(arg):lower()
												for _, v90 in ipairs(v89) do if str6:find(v90, 1, true) then return true end end
												return v85[139]
											end
											local function fn44(arg)
												local character = localPlayer2.Character
												local backpack = localPlayer2:FindFirstChildOfClass("Backpack")
												local str6 = tostring(arg or ""):lower()
												local v90 = nil
												local v91 = nil
												local function fn45(arg2)
													if not arg2 then return end
													for _, child in ipairs(arg2:GetChildren()) do
														if child:IsA("Tool") then
															local str7 = child.Name:lower()
															if str6 ~= "" and str7 == str6 then
																v90 = v90 or child
															elseif fn43(str7) then
																v91 = v91 or child
															end
														end
													end
												end
												fn45(character)
												fn45(backpack)
												return v90 or v91
											end
											if n24 <= 3395 then
												while v85[192] do
												end
											end
											local function fn45()
												local character = localPlayer2.Character
												local backpack = localPlayer2:FindFirstChildOfClass("Backpack")
												for _, v90 in ipairs({ character, backpack }) do
													if v90 then for _, child in ipairs(v90:GetChildren()) do if child:IsA("Tool") then return child end end end
												end
												return nil
											end
											local function fn46(arg)
												local character = localPlayer2.Character
												local humanoid = character and character:FindFirstChildOfClass("Humanoid")
												if not character or not humanoid then return nil end
												local v90 = fn44(arg) or fn45()
												if v90 and v90.Parent ~= character then
													pcall(function()
														humanoid:EquipTool(v90)
													end)
												end
												return v90
											end
											local function fn47(arg, arg2)
												local n33 = os.clock() + (tonumber(arg2) or 0.7)
												while true do
													local v90 = fn46(arg)
													if v90 then
														return v90
													else
														RunService2.Heartbeat:Wait()
														if not (n33 < os.clock()) then continue end
														break
													end
												end
												return nil
											end
											local tbl25 = {
												Enum.HumanoidStateType.Ragdoll,
												Enum.HumanoidStateType.FallingDown,
												Enum.HumanoidStateType.Physics,
											}
											local connection = nil
											local v90 = nil
											local tbl26 = nil
											local function fn48()
												if connection then
													pcall(function()
														connection:Disconnect()
													end)
													connection = nil
												end
												if v90 and v90.Parent and tbl26 then
													for k, v91 in pairs(tbl26) do
														pcall(function()
															v90:SetStateEnabled(k, v91)
														end)
													end
												end
												v90 = nil
												tbl26 = nil
											end
											local function fn49()
												fn48()
												local character = localPlayer2.Character
												local humanoid = character and character:FindFirstChildOfClass("Humanoid")
												if not humanoid then return end
												v90 = humanoid
												tbl26 = {}
												for _, v91 in ipairs(tbl25) do
													pcall(function()
														tbl26[v91] = humanoid:GetStateEnabled(v91)
														humanoid:SetStateEnabled(v91, false)
													end)
												end
												connection = RunService2.Heartbeat:Connect(function()
													if not fn30() then return end
													if genv.iCollectPro_IsResetting then return end
													local character2 = localPlayer2.Character
													local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")
													if not humanoid2 or not humanoid2.Parent then return end
													pcall(function()
														if localPlayer2:GetAttribute("RagdollEndTime") then
															localPlayer2:SetAttribute("RagdollEndTime", Workspace:GetServerTimeNow())
														end
														local state = humanoid2:GetState()
														if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Physics then
															humanoid2:ChangeState(Enum.HumanoidStateType.Running)
														end
														if humanoid2.Health < humanoid2.MaxHealth then humanoid2.Health = humanoid2.MaxHealth end
													end)
												end)
											end
											local tbl27 = {
												DeliveryHitbox = v85[192],
												StealHitbox = true,
												LaserHitbox = true,
												AnimalTarget = true,
												Multiplier = true,
												Laser = true,
												Hitbox = true,
												Spawn = v85[192],
												MainRoot = v85[192],
												SecondFloor = true,
												ThirdFloor = v85[192],
												Slope = true,
											}
											local function fn50(arg)
												if not arg then return false end
												if tbl27[arg.Name] then return v85[139] end
												return arg.CanCollide == true
											end
											local v91 = fn50
											local tbl28 = {}
											local n33 = 0
											local function fn51()
												local now2 = os.clock()
												if now2 - n33 < 5 and #tbl28 > 0 then return tbl28 end
												n33 = now2
												tbl28 = {}
												local v92 = Workspace:FindFirstChild(v85[2])
												if v92 then
													for _, child in ipairs(v92:GetChildren()) do
														local plotSign = child:FindFirstChild("PlotSign")
														if plotSign then tbl28[#tbl28 + v85[64]] = plotSign end
													end
												end
												return tbl28
											end
											local function fn52()
												local tbl29 = {}
												for _, player in ipairs(Players2:GetPlayers()) do
													if player.Character then tbl29[#tbl29 + v85[64]] = player.Character end
												end
												for _, v92 in ipairs({ "__PodiumStandFloors", "__PodiumCollide" }) do
													local v93 = Workspace:FindFirstChild(v92)
													if v93 then tbl29[#tbl29 + 1] = v93 end
												end
												for _, v92 in ipairs(fn51()) do if v92.Parent then tbl29[#tbl29 + 1] = v92 end end
												return tbl29
											end
											local function fn53(arg, arg2, arg3)
												local v92 = arg3 or fn50
												local raycastParams = RaycastParams.new()
												raycastParams.FilterType = v88
												raycastParams.IgnoreWater = true
												local v93 = fn52()
												for i = 1, v85[45] do
													raycastParams.FilterDescendantsInstances = v93
													local n34 = arg2 - arg
													if n34.Magnitude < 0.05 then return nil end
													local hit = Workspace:Raycast(arg, n34, raycastParams)
													if not hit then return nil end
													if v92(hit.Instance) then return hit end
													v93[#v93 + 1] = hit.Instance
													arg = hit.Position + n34.Unit * 0.3
												end
												return nil
											end
											local function iCollectProTpIsClear(arg, arg2) return fn53(arg, arg2) == nil end
											local n34 = 2
											local v92 = v85[67]
											local function fn54(arg, arg2)
												if not iCollectProTpIsClear(arg, arg2) then return v85[139] end
												local n35 = arg2 - arg
												local vector = Vector3.new(n35.X, 0, n35.Z)
												local vector2 = Vector3.new(v85[164], 2.5, 0)
												local vector3 = Vector3.new(0, -v92, 0)
												if vector.Magnitude < 0.1 then
													local vector4 = Vector3.new(2, 0, v85[164])
													local vector5 = Vector3.new(0, 0, 2)
													return iCollectProTpIsClear(arg + vector4, arg2 + vector4) and iCollectProTpIsClear(arg - vector4, arg2 - vector4) and iCollectProTpIsClear(arg + vector5, arg2 + vector5) and iCollectProTpIsClear(arg - vector5, arg2 - vector5)
												end
												local n36 = Vector3.new(-vector.Z, 0, vector.X).Unit * n34
												return iCollectProTpIsClear(arg + n36, arg2 + n36) and iCollectProTpIsClear(arg - n36, arg2 - n36) and iCollectProTpIsClear(arg + vector2, arg2 + vector2) and iCollectProTpIsClear(arg + vector3, arg2 + vector3)
											end
											local function fn55(arg, arg2)
												if n27(1936) >= 8042 then
													if not iCollectProTpIsClear(arg, arg2) then return false end
													local vector = Vector3.new(arg2.X - arg.X, 0, arg2.Z - arg.Z)
													if vector.Magnitude < 0.1 then return true end
													local n35 = Vector3.new(-vector.Z, v85[164], vector.X).Unit * 10
													local vector2 = Vector3.new(v85[164], v85[138], v85[164])
													return fn53(arg + n35, arg2 + n35, v91) == nil and fn53(arg - n35, arg2 - n35, v91) == nil and fn53(arg + vector2, arg2 + vector2, v91) == nil and fn53(arg - vector2, arg2 - vector2, v91) == nil
												end
												while true do
												end
											end
											local tbl29 = {}
											local vector = Vector3.new(1, 0, 0)
											local vector2 = Vector3.new(-1, 0, 0)
											local vector3 = Vector3.new(v85[164], 0, 1)
											local vector4 = Vector3.new
											local n35 = -v85[64]
											tbl29[1] = vector
											tbl29[2] = vector2
											tbl29[3] = vector3
											do
												local values = table.pack(vector4(0, 0, n35))
												table.move(values, 1, values.n, 4, tbl29)
											end
											local function fn56(arg)
												if #arg <= v85[67] then return arg end
												local tbl30 = { arg[v85[64]] }
												local n36 = 1
												while n36 < #arg do
													local n37 = #arg
													while n37 > n36 + 1 and not fn55(tbl30[#tbl30], arg[n37]) do n37 -= 1 end
													tbl30[#tbl30 + 1] = arg[n37]
													n36 = n37
												end
												return tbl30
											end
											local function fn57(arg)
												if #arg <= 2 then return arg end
												local v93 = v85[138]
												local tbl30 = { arg[v85[64]] }
												for i = 2, #arg - v85[64] do
													local v94 = arg[i]
													local vector5 = Vector3.zero
													for _, v95 in ipairs(tbl29) do
														local v96 = fn53(v94, v94 + v95 * v93, fn50)
														if v96 then
															local magnitude = (v96.Position - v94).Magnitude
															if magnitude < v93 then vector5 -= v95 * (v93 - magnitude) end
														end
													end
													if vector5.Magnitude > 0.1 then
														if vector5.Magnitude > 14 then vector5 = vector5.Unit * 14 end
														local n36 = v94 + vector5
														if iCollectProTpIsClear(tbl30[#tbl30], n36) then
															tbl30[#tbl30 + v85[64]] = n36
														else
															tbl30[#tbl30 + v85[64]] = v94
														end
													else
														tbl30[#tbl30 + 1] = v94
													end
												end
												tbl30[#tbl30 + v85[64]] = arg[#arg]
												return tbl30
											end
											local function fn58(arg, arg2)
												local v93 = PathfindingService:CreatePath({
													AgentRadius = v85[142],
													AgentHeight = 5,
													AgentCanJump = v85[192],
													AgentJumpHeight = 10,
													AgentMaxSlope = 89,
												})
												local tbl30 = { arg }
												local vector5 = Vector3.new(arg2.X, arg.Y, arg2.Z)
												if pcall(function()
													v93:ComputeAsync(arg, vector5)
												end) and v93.Status == Enum.PathStatus.Success then
													for _, v94 in ipairs(v93:GetWaypoints()) do
														if (v94.Position - arg).Magnitude >= 8 then
															tbl30[#tbl30 + 1] = v94.Position + Vector3.new(0, 3, 0)
															arg = v94.Position
														end
													end
												end
												tbl30[#tbl30 + 1] = arg2
												local v94 = fn57(tbl30)
												local v95 = fn56(v94)
												if v95[#v95] ~= arg2 then v95[#v95 + v85[64]] = arg2 end
												return v95
											end
											local function fn59(arg, arg2)
												if not arg2 or #arg2 == 0 then return false end
												for _, v93 in ipairs(arg2) do
													if not fn54(arg, v93) then return false end
													arg = v93
												end
												return true
											end
											local function iCollectProTpPlanRoute(arg, arg2, arg3)
												if fn54(arg, arg2) then return { arg2 } end
												for _, v93 in ipairs({ 16, 30, 48, v85[141], 95, 130 }) do
													local n36 = math.max(arg.Y, arg2.Y) + v93
													local vector5 = Vector3.new(arg.X, n36, arg.Z)
													local vector6 = Vector3.new(arg2.X, n36, arg2.Z)
													if fn54(arg, vector5) and fn54(vector5, vector6) and fn54(vector6, arg2) then
														return { vector5, vector6, arg2 }
													end
												end
												local v93 = fn58(arg, arg2)
												if v93 and #v93 > 0 and fn59(arg, v93) then return v93 end
												if arg3 then return nil end
												return { arg2 }
											end
											local function fn60(arg, arg2)
												if not arg2 or #arg2 == 0 then return nil end
												local tbl30 = {}
												for _, v93 in ipairs(arg2) do
													if fn54(arg, v93) then
														tbl30[#tbl30 + 1] = v93
														arg = v93
														continue
													end
													local v94 = iCollectProTpPlanRoute(arg, v93, true)
													if not v94 then return nil end
													for _, v95 in ipairs(v94) do tbl30[#tbl30 + 1] = v95 end
													arg = v93
												end
												return tbl30
											end
											local v93 = v85[164]
											local flag18 = false
											local function fn61(arg, arg2, arg3, arg4)
												if #arg == 0 then return false, "no path" end
												local character = localPlayer2.Character
												character = character and character:FindFirstChild("HumanoidRootPart")
												if not character then return v85[139], "no character" end
												local v94 = v85[64]
												local flag19 = false
												local connection2 = nil
												local str6 = "arrived"
												local huge = math.huge
												local n36 = 0
												local n37 = 0
												local function fn62(arg5)
													if flag19 then return end
													flag19 = true
													str6 = arg5 or str6
													if connection2 then
														pcall(function()
															connection2:Disconnect()
														end)
														connection2 = nil
													end
													local character2 = localPlayer2.Character
													fn40(character2 and character2:FindFirstChild("HumanoidRootPart"))
												end
												connection2 = RunService2.Heartbeat:Connect(function(deltaTime)
													if not fn30() then return fn62("unloaded") end
													if flag19 then return end
													if v93 ~= arg4 then return fn62("cancelled") end
													local character2 = localPlayer2.Character
													character2 = character2 and character2:FindFirstChild("HumanoidRootPart")
													if not character2 or not character2.Parent then return fn62("no character") end
													local now2 = os.clock()
													if now2 - n37 > 0.3 then
														n37 = now2
														fn46(arg3)
													end
													local n38 = math.clamp(tonumber(deltaTime) or 0.016666666666666666, 0.0041666666666666666, 0.1)
													local n39 = arg[v94] - character2.Position
													local magnitude = n39.Magnitude
													local n40 = math.max(3, arg2 * n38 * 1.3)
													while magnitude < n40 do
														v94 += 1
														if #arg < v94 then return fn62("arrived") end
														huge = math.huge
														n36 = 0
														n39 = arg[v94] - character2.Position
														magnitude = n39.Magnitude
													end
													if huge - 0.05 < magnitude then
														n36 += v85[64]
													else
														n36 = 0
													end
													huge = magnitude
													if n36 >= 18 then return fn62("blocked") end
													if magnitude >= 0.1 then
														local unit = n39.Unit
														local n41 = math.min(fn41(arg2, (arg[#arg] - character2.Position).Magnitude), magnitude / n38)
														local n42 = unit.Y * n41
														if n42 > 75 then n42 = 75 end
														character2.AssemblyLinearVelocity = Vector3.new(unit.X * n41, n42, unit.Z * n41)
													end
												end)
												local v95 = v85[164]
												local position = character.Position
												for _, v96 in ipairs(arg) do
													v95 += (position - v96).Magnitude
													position = v96
												end
												local n38 = v95 / math.min(200, math.max(v85[3], arg2)) + 3
												local now2 = os.clock()
												while true do
													if not flag19 and os.clock() - now2 < n38 then
														if not (v93 ~= arg4 or not fn30()) then
															task.wait(0.05)
															continue
														end
													end
													break
												end
												if not flag19 then fn62(v93 ~= arg4 and "cancelled" or "timeout") end
												return str6 == "arrived", str6
											end
											local function fn62(arg)
												local character = localPlayer2.Character
												local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
												if not humanoidRootPart then return end
												local now2 = os.clock()
												while os.clock() - now2 < 0.45 and v93 == arg do
													if not humanoidRootPart.Parent then return end
													humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 55, 0)
													RunService2.Heartbeat:Wait()
												end
												fn40(humanoidRootPart)
											end
											local function fn63(arg, arg2)
												local character = localPlayer2.Character
												local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
												local humanoid = character and character:FindFirstChildOfClass("Humanoid")
												if not humanoidRootPart then return end
												local v94, v95 = humanoidRootPart.CFrame:ToEulerAnglesYXZ()
												local cFrame = CFrame.new(arg) * CFrame.Angles(0, v95, 0)
												for i = 1, v85[82] do
													if v93 ~= arg2 or not humanoidRootPart.Parent then return end
													pcall(function()
														humanoidRootPart.CFrame = cFrame
														humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
														humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
													end)
													if humanoid and humanoid.Parent then
														pcall(function()
															humanoid:ChangeState(Enum.HumanoidStateType.Landed)
														end)
													end
													RunService2.Heartbeat:Wait()
												end
												if humanoid and humanoid.Parent then
													pcall(function()
														humanoid:ChangeState(Enum.HumanoidStateType.Running)
													end)
												end
											end
											local tbl30 = {}
											local function fn64()
												for k, v94 in pairs(tbl30) do
													pcall(function()
														if k.Parent then k.CanCollide = v94 end
													end)
												end
												table.clear(tbl30)
											end
											local function fn65(arg)
												if arg:IsA("BasePart") and arg.CanCollide then
													tbl30[arg] = arg.CanCollide
													arg.CanCollide = false
												end
											end
											local function fn66()
												fn64()
												for _, v94 in ipairs({ "__PodiumStandFloors", "__PodiumCollide" }) do
													local v95 = Workspace:FindFirstChild(v94)
													if v95 then for _, child in ipairs(v95:GetChildren()) do pcall(fn65, child) end end
												end
											end
											local function fn67(arg, arg2)
												arg2 = arg2 and arg2:FindFirstChild("MainRoot")
												local tbl31
												if arg2 and arg2:IsA("BasePart") then
													local cFrame = arg2.CFrame
													tbl31 = { cFrame.LookVector, -cFrame.LookVector, cFrame.RightVector, -cFrame.RightVector }
												else
													tbl31 = {}
													local vector5 = Vector3.new(1, 0, 0)
													local vector6 = Vector3.new(-1, 0, v85[164])
													local vector7 = Vector3.new(0, v85[164], 1)
													local vector8 = Vector3.new
													tbl31[1] = vector5
													tbl31[2] = vector6
													tbl31[3] = vector7
													do
														local values = table.pack(vector8(0, 0, -1))
														table.move(values, 1, values.n, 4, tbl31)
													end
												end
												local tbl32 = {}
												for _, v94 in ipairs(tbl31) do
													local vector5 = Vector3.new(v94.X, v85[164], v94.Z)
													if vector5.Magnitude > 0.1 then tbl32[#tbl32 + 1] = vector5.Unit end
												end
												local tbl33 = {}
												for i = 1, #tbl32 do
													for i2 = i + v85[64], #tbl32 do
														local n36 = tbl32[i] + tbl32[i2]
														if n36.Magnitude > 0.1 then tbl33[#tbl33 + 1] = n36.Unit end
													end
												end
												for _, v94 in ipairs(tbl33) do tbl32[#tbl32 + v85[64]] = v94 end
												for _, v94 in ipairs({ 14, 22, 32, 44, 58 }) do
													for _, v95 in ipairs(tbl32) do
														for _, v96 in ipairs({ v85[164], 6, 14 }) do
															local n36 = arg + v95 * v94 + Vector3.new(0, v96, 0)
															if fn54(n36, arg) then return n36, "side" end
														end
													end
												end
												for _, v94 in ipairs({ 10, 16, 24, v85[81] }) do
													local n36 = arg + Vector3.new(0, v94, 0)
													if fn54(n36, arg) then return n36, "above" end
												end
												return nil
											end
											local function fn68(arg, arg2, arg3)
												local mainRoot = arg3 and arg3:FindFirstChild("MainRoot")
												if not mainRoot or not mainRoot:IsA("BasePart") then return nil end
												local ok, result = pcall(function()
													return mainRoot.CFrame:PointToObjectSpace(arg2)
												end)
												if not ok or not result then return nil end
												local position = (mainRoot.CFrame * CFrame.new(0, result.Y, math.clamp(result.Z, -10, 10))).Position
												local vector5 = Vector3.new(position.X, arg.Y, position.Z)
												if not fn54(vector5, position) or not fn54(position, arg2) then return nil end
												local tbl31 = {}
												if (arg - vector5).Magnitude > 4 then tbl31[#tbl31 + 1] = vector5 end
												tbl31[#tbl31 + v85[64]] = position
												tbl31[#tbl31 + v85[64]] = arg2
												return tbl31
											end
											local function fn69(arg, arg2, arg3)
												local v94 = arg3 and arg3:FindFirstChild(v85[53])
												if not v94 or not v94:IsA("BasePart") then return nil end
												local cFrame = v94.CFrame
												local ok, result = pcall(function()
													return cFrame:PointToObjectSpace(arg2)
												end)
												if not ok or not result then return nil end
												local n36 = math.clamp(result.Z, -v85[142], 15)
												local flag19 = result.Y > 10
												local n37 = -math.huge
												local plotSign = arg3:FindFirstChild("PlotSign")
												if plotSign then
													local ok2, result2, result3 = pcall(function()
														return plotSign:GetBoundingBox()
													end)
													if ok2 and result2 and result3 then
														local n38 = result2.Position + Vector3.new(v85[164], result3.Y * 0.5, 0)
														local ok3, result4 = pcall(function()
															return cFrame:PointToObjectSpace(n38)
														end)
														if ok3 and result4 then n37 = result4.Y end
													end
												end
												for _, v95 in ipairs({ -44, v85[184], -56, 56, -72, 72 }) do
													local position = (cFrame * CFrame.new(v85[164], result.Y, v95)).Position
													local position2 = (cFrame * CFrame.new(0, result.Y, n36)).Position
													if fn54(position, position2) and fn54(position2, arg2) then
														local tbl31 = {}
														local n38 = 34
														if n37 > -math.huge then n38 = math.max(34, n37 + 18) end
														local position3 = (cFrame * CFrame.new(0, n38, v95)).Position
														flag19 = flag19 and fn54(position3, position)
														if flag19 then tbl31[#tbl31 + 1] = position3 end
														tbl31[#tbl31 + 1] = position
														tbl31[#tbl31 + 1] = position2
														tbl31[#tbl31 + v85[64]] = arg2
														return tbl31
													end
												end
												return nil
											end
											local function fn70(arg, arg2, arg3)
												if fn54(arg, arg2) then return { arg2 } end
												local tbl31 = {}
												local v94 = fn69(arg, arg2, arg3)
												if v94 then tbl31[#tbl31 + 1] = v94 end
												local v95 = fn68(arg, arg2, arg3)
												if v95 then tbl31[#tbl31 + v85[64]] = v95 end
												local v96 = fn67(arg2, arg3)
												if v96 then tbl31[#tbl31 + 1] = { v96, arg2 } end
												for _, v97 in ipairs(tbl31) do
													local v98 = fn60(arg, v97)
													if v98 and fn59(arg, v98) then return v98 end
												end
												local v97 = iCollectProTpPlanRoute(arg, arg2, true)
												if v97 and fn59(arg, v97) then return v97 end
												return nil
											end
											local function fn71(arg, arg2, arg3, arg4)
												local character = localPlayer2.Character
												character = character and character:FindFirstChild("HumanoidRootPart")
												if not character then return false, "no character" end
												if fn54(character.Position, arg) then return fn61({ arg }, math.min(arg2, 130), arg3, arg4) end
												return false, "blocked"
											end
											genv.iCollectPro_TpFlyToolName = function(arg)
												local v94 = fn44(arg)
												return v94 and v94.Name or nil
											end
											genv.iCollectPro_TpCancel = function() v93 += v85[64] end
											genv.iCollectPro_TpBusy = function() return flag18 end
											genv.iCollectPro_TpFlyTo = function(arg, arg2)
												if typeof(arg) ~= "Vector3" then return false, "no destination" end
												if flag18 then return false, "already flying" end
												arg2 = arg2 or {}
												local character = localPlayer2.Character
												local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
												character = character and character:FindFirstChildOfClass("Humanoid")
												if not humanoidRootPart or not character or character.Health <= 0 then return false, "no character" end
												v93 += 1
												local v94 = v93
												flag18 = true
												local tool = arg2.tool
												tonumber(arg2.radius)
												local n36 = math.clamp(tonumber(arg2.speed) or 0, 0, 400)
												if n36 < 16 then
													n36 = fn42((humanoidRootPart.Position - arg).Magnitude)
												elseif fn38() then
													local n37 = math.clamp(tonumber(genv.iCollectPro_FlySpeed) or v85[33], 55, 320)
													n36 = math.clamp(n36, math.min(n36, n37), 320)
												end
												local flag19 = false
												local str6 = "failed"
												if not pcall(function()
													fn49()
													pcall(function()
														humanoidRootPart.Anchored = v85[139]
													end)
													fn47(tool, 0.7)
													fn66()
													if arg2.direct then
														local v95, v96 = fn61({ arg }, n36, tool, v94)
														flag19 = v95
														str6 = v96
													end
													local direct = arg2.direct and v85[164] or 3
													for i = 1, direct do
														if v93 == v94 then
															local character2 = localPlayer2.Character
															character2 = character2 and character2:FindFirstChild("HumanoidRootPart")
															if not character2 then
																flag19 = false
																str6 = "no character"
																break
															else
																local v95 = fn70(character2.Position, arg, arg2.plot)
																if not v95 then
																	flag19 = false
																	str6 = "no clear route"
																	if i < 3 then fn62(v94) end
																else
																	local v96, v97 = fn61(v95, n36, tool, v94)
																	flag19 = v96
																	str6 = v97
																end
																if not (flag19 or v93 ~= v94) then
																	if i < v85[70] then fn62(v94) end
																	continue
																end
															end
														end
														break
													end
													if v93 == v94 and not flag19 and not arg2.direct then
														local v95, v96 = fn71(arg, fn42(v85[42]), tool, v94)
														flag19 = v95
														str6 = v96
													end
													fn64()
													if flag19 and v93 == v94 then
														fn63(arg, v94)
													elseif v93 == v94 and not arg2.direct then
														fn62(v94)
													end
												end) then
													flag19 = false
													str6 = "error"
												end
												fn64()
												fn48()
												local character2 = localPlayer2.Character
												fn40(character2 and character2:FindFirstChild("HumanoidRootPart"))
												flag18 = false
												return flag19, str6
											end
											genv.iCollectPro_TpIsClear = iCollectProTpIsClear
											genv.iCollectPro_TpPlanRoute = iCollectProTpPlanRoute
										end) then
											warn("[iCollectPro] flight engine failed to build")
										end
										task.spawn(function()
											game:GetService("ReplicatedStorage")
											local localPlayer2 = game:GetService(v85[152]).LocalPlayer
											genv.iCollectPro_GrabStats = { fired = 0, slot = nil, remote = "off" }
											genv.iCollectPro_FastSteal = v85[139]
										end)
										task.spawn(function()
											if not workspace.StreamingEnabled then return end
											local localPlayer2 = game:GetService("Players").LocalPlayer
											local function fn39(arg)
												local v88 = arg:FindFirstChild(v85[53])
												if v88 and v88:IsA("BasePart") then return v88.Position end
												local ok, result = pcall(function()
													return arg:GetPivot().Position
												end)
												return ok and result or nil
											end
											while fn30() do
												local v88 = workspace:FindFirstChild(v85[2])
												if v88 then
													for _, child in ipairs(v88:GetChildren()) do
														if not fn30() then return end
														local v89 = fn39(child)
														if v89 then
															pcall(function()
																localPlayer2:RequestStreamAroundAsync(v89)
															end)
														end
													end
												end
												task.wait(20)
											end
										end)
										Players = game:GetService("Players")
										RunService = game:GetService("RunService")
										UserInputService = game:GetService("UserInputService")
										TweenService = game:GetService("TweenService")
										HttpService = game:GetService("HttpService")
										localPlayer = Players.LocalPlayer
										tbl18 = {
											rocket = 120,
											ragdoll = 30,
											balloon = 30,
											inverse = 60,
											nightvision = 60,
											jail = 60,
											tiny = 60,
											jumpscare = v85[189],
											morph = 60,
										}
										tbl19 = {
											v85[104],
											"inverse",
											"jail",
											"jumpscare",
											"morph",
											"nightvision",
											"ragdoll",
											v85[55],
											"tiny",
										}
										tbl20 = {
											balloon = "Balloon",
											inverse = "Inverse",
											jail = "Jail",
											jumpscare = "Jumpscare",
											morph = "Morph",
											nightvision = "Night Vision",
											ragdoll = "Ragdoll",
											rocket = "Rocket",
											tiny = "Tiny",
										}
										tbl21 = {
											{ icon = "✂️", cmd = "ragdoll" },
											{ icon = "🔒", cmd = "jail" },
											{ icon = "🚀", cmd = v85[55] },
											{ icon = "🎈", cmd = "balloon" },
										}
										n32 = #tbl21 * 35 - 3 + v85[194] + v85[169]
										tbl22 = {
											BG = Color3.fromRGB(20, v85[142], 34),
											SURF = Color3.fromRGB(28, 16, 46),
											SURF2 = Color3.fromRGB(48, 26, 76),
											ROW = Color3.fromRGB(34, 20, 54),
											ROW_HOVER = Color3.fromRGB(62, 34, 96),
											ROW_PET = Color3.fromRGB(24, 60, v85[57]),
											ROW_PET_HOVER = Color3.fromRGB(30, 84, 62),
											TEXT = Color3.fromRGB(v85[173], v85[16], v85[149]),
											DIM = Color3.fromRGB(155, 120, v85[126]),
											AQUA = Color3.fromRGB(168, 85, v85[197]),
											AQUA2 = Color3.fromRGB(124, 45, 190),
											STROKE = Color3.fromRGB(150, 70, 230),
											GREEN = Color3.fromRGB(18, 88, 58),
											GREEN_STROKE = Color3.fromRGB(v85[189], 185, v85[15]),
											GREEN_TEXT = Color3.fromRGB(232, 255, 240),
											ERROR = Color3.fromRGB(150, 40, 60),
											OFF_TEXT = Color3.fromRGB(v85[33], 110, 180),
										}
										tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
										tweenInfo2 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
										genv.iCollectPro_AP_DISABLED = true
										tbl23 = {
											PanelVisible = true,
											SettingsOpen = false,
											Locked = v85[139],
											ClickToAP = v85[139],
											ProximityAP = false,
											ProximityRange = 15,
											SkipFriends = false,
											SpamOn = {},
											SpamDelay = {},
											SpamOrder = {
												"balloon",
												"rocket",
												"jail",
												"inverse",
												"jumpscare",
												"morph",
												"nightvision",
												"ragdoll",
												"tiny",
											},
											Pos = nil,
											W = nil,
											H = nil,
										}
										if isfile and isfile("iCollectProAdmin.json") then
											pcall(function()
												local json = readfile("iCollectProAdmin.json")
												if not json or json == "" then return end
												local data = HttpService:JSONDecode(json)
												local v88 = v85[19]
												if type(data) ~= v88 then return end
												for k, v89 in pairs(data) do tbl23[k] = v89 end
											end)
										end
										do
											local v88 = v85[19]
											if type(tbl23.SpamOn) ~= v88 then tbl23.SpamOn = {} end
										end
									end
									if type(tbl23.SpamDelay) ~= "table" then tbl23.SpamDelay = {} end
									do
										local tbl25 = {}
										local tbl26 = {}
										local spamOrder = {}
										for _, v88 in ipairs(tbl19) do
											tbl25[v88] = v85[192]
											if tbl23.SpamOn[v88] == nil then tbl23.SpamOn[v88] = true end
											tbl23.SpamDelay[v88] = math.clamp(tonumber(tbl23.SpamDelay[v88]) or 1, 0.1, 5)
										end
										if type(tbl23.SpamOrder) ~= "table" then tbl23.SpamOrder = {} end
										for _, v88 in ipairs(tbl23.SpamOrder) do
											if tbl25[v88] and not tbl26[v88] then
												tbl26[v88] = true
												spamOrder[#spamOrder + 1] = v88
											end
										end
										for _, v88 in ipairs(tbl19) do
											if not tbl26[v88] then
												tbl26[v88] = true
												spamOrder[#spamOrder + 1] = v88
											end
										end
										tbl23.SpamOrder = spamOrder
									end
								end
								do
									local flag18 = false
									fn35 = function()
										if not writefile or flag18 then return end
										flag18 = true
										task.delay(0.4, function()
											flag18 = false
											pcall(function()
												writefile("iCollectProAdmin.json", HttpService:JSONEncode(tbl23))
												if not flag2 then return end
											end)
										end)
									end
								end
							end
							createUICorner = function(parent, arg)
								local uiCorner = Instance.new("UICorner")
								uiCorner.CornerRadius = UDim.new(0, arg)
								uiCorner.Parent = parent
								return uiCorner
							end
							createUIStroke = function(parent, color, thickness, transparency)
								local uiStroke = Instance.new("UIStroke")
								uiStroke.Color = color
								uiStroke.Thickness = thickness or 1
								uiStroke.Transparency = transparency or v85[164]
								uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
								uiStroke.Parent = parent
								return uiStroke
							end
							fn36 = function(arg, arg2)
								pcall(function()
									TweenService:Create(arg, tweenInfo, { BackgroundColor3 = arg2 }):Play()
								end)
							end
							iCollectProAPGameGui = function()
								local playerGui2 = localPlayer:FindFirstChildOfClass("PlayerGui")
								if not playerGui2 then return nil end
								local adminPanel = nil
								pcall(function()
									adminPanel = playerGui2:FindFirstChild("AdminPanel")
								end)
								return adminPanel
							end
							genv.iCollectPro_APGameGui = iCollectProAPGameGui
							fn37 = function(arg)
								if not arg then return end
								if typeof(firesignal) == "function" then
									pcall(function()
										firesignal(arg.MouseButton1Click)
									end)
									pcall(function()
										firesignal(arg.MouseButton1Down)
									end)
									pcall(function()
										firesignal(arg.Activated)
									end)
								else
									pcall(function()
										local n33 = arg.AbsolutePosition.X + arg.AbsoluteSize.X / 2
										local n34 = arg.AbsolutePosition.Y + arg.AbsoluteSize.Y / 2 + 58
										local VirtualInputManager = game:GetService("VirtualInputManager")
										VirtualInputManager:SendMouseButtonEvent(n33, n34, v85[164], true, game, 0)
										VirtualInputManager:SendMouseButtonEvent(n33, n34, v85[164], false, game, 0)
									end)
								end
							end
							do
								local tbl25 = {}
								local tbl26 = {}
								iCollectProAPIsAllowed = function(arg)
									if not arg then return false end
									if tbl25[arg.UserId] then return true end
									local str6 = tostring(arg.Name or ""):lower()
									local str7 = tostring(arg.DisplayName or ""):lower()
									for k in pairs(tbl26) do
										local str8 = tostring(k):lower()
										if str8 == str6 or str8 == str7 then return true end
									end
									return false
								end
								genv.iCollectPro_APAllow = function(arg)
									local num = tonumber(arg)
									if num then
										tbl25[num] = true
										return true
									end
									if type(arg) == "string" and arg ~= "" then
										tbl26[arg] = true
										return true
									end
									return false
								end
							end
						end
						do
							do
								local tbl24, fn38, fn39, fn40, fn41, textLabel, fn42, iCollectProAPRun, tbl25, tbl26
								local fn43, fn44, fn45, iCollectProAPFireAll, fn46, fn47, fn48, fn49, screenGui, frame
								local scrollingFrame, frame2, scrollingFrame2, tbl27, fn50, fn51
								do
									do
										local fn52, fn53
										do
											do
												do
													genv.iCollectPro_APIsAllowed = iCollectProAPIsAllowed
													tbl24 = {
														iCollectPro = Color3.fromRGB(v85[163], 85, 247),
													}
													do
														local tbl28 = {}
														local tbl29 = {}
														fn38 = nil
														local function fn54(arg)
															local userId = arg and arg.UserId
															if not userId or tbl28[userId] ~= nil or tbl29[userId] then return end
															tbl29[userId] = true
															task.spawn(function()
																local ok, result = pcall(function()
																	return localPlayer:IsFriendsWith(userId)
																end)
																tbl29[userId] = nil
																if ok then
																	tbl28[userId] = result and v85[192] or false
																	if result and fn38 then pcall(fn38) end
																end
															end)
														end
														fn39 = function(arg)
															if tbl23.SkipFriends ~= true or not arg or arg == localPlayer then return v85[139] end
															if tbl28[arg.UserId] == nil then
																fn54(arg)
																return false
															end
															return tbl28[arg.UserId] == true
														end
														fn40 = function()
															for _, player in ipairs(Players:GetPlayers()) do if player ~= localPlayer then fn54(player) end end
														end
													end
												end
												do
													fn41 = function(arg)
														if iCollectProAPIsAllowed(arg) then return "iCollectPro" end
														if fn39(arg) then return "friend" end
														return nil
													end
													textLabel = nil
													fn42 = function(arg) if textLabel and textLabel.Parent then textLabel.Text = tostring(arg) end end
													iCollectProAPRun = function(arg, arg2)
														if not arg then return false end
														local v88 = fn41(arg)
														if v88 then
															fn42(tostring(arg.Name) .. (v88 == "friend" and " is a whitelisted friend - skipped" or " uses iCollectPro - skipped"))
															return false
														end
														local v89 = iCollectProAPGameGui()
														if not v89 then
															fn42("no admin panel in this server")
															return false
														end
														local flag18 = false
														local notFound = nil
														pcall(function()
															local adminPanel = v89:FindFirstChild("AdminPanel")
															if not adminPanel then return end
															local content = adminPanel:FindFirstChild("Content")
															content = content and content:FindFirstChild("ScrollingFrame")
															if not content then return end
															local v90 = content:FindFirstChild(arg2) or content:FindFirstChild(arg2, true)
															if not v90 then
																notFound = "command " .. tostring(arg2)
																return
															end
															fn37(v90)
															task.wait(0.05)
															local profiles = adminPanel:FindFirstChild("Profiles")
															profiles = profiles and profiles:FindFirstChild("ScrollingFrame")
															if not profiles then return end
															local v91 = profiles:FindFirstChild(arg.Name) or profiles:FindFirstChild(arg.Name, v85[192])
															if not v91 then
																notFound = tostring(arg.Name) .. " not in the admin list"
																return
															end
															fn37(v91)
															flag18 = true
														end)
														if not flag18 and notFound then fn42("not found: " .. notFound) end
														return flag18
													end
													genv.iCollectPro_APRun = iCollectProAPRun
													do
														local tbl28 = {}
														tbl25 = {}
														tbl26 = {}
														fn43 = function(arg)
															local v88 = iCollectProAPGameGui()
															if v88 then
																local visible = nil
																pcall(function()
																	local adminPanel = v88:FindFirstChild("AdminPanel")
																	adminPanel = adminPanel and adminPanel:FindFirstChild("Content")
																	adminPanel = adminPanel and adminPanel:FindFirstChild("ScrollingFrame")
																	local timer = adminPanel and adminPanel:FindFirstChild(arg)
																	timer = timer and timer:FindFirstChild("Timer")
																	if timer then visible = timer.Visible end
																end)
																if visible ~= nil then return visible end
															end
															if not tbl28[arg] then return false end
															local v89 = tbl28[arg]
															return os.clock() - v89 < (tbl18[arg] or v85[164])
														end
														fn44 = function()
															local balloon = tbl18.balloon or 30
															local now2 = os.clock()
															local flag18 = false
															for k, v88 in pairs(tbl26) do
																if type(v88) == "number" and now2 - v88 < balloon then
																	flag18 = true
																else
																	tbl26[k] = nil
																end
															end
															return flag18
														end
														fn45 = function(arg, arg2)
															tbl28[arg] = os.clock()
															if arg == "balloon" and arg2 then tbl26[arg2.UserId] = os.clock() end
														end
													end
												end
												do
													local function fn54(arg)
														local character = arg and arg.Character
														character = character and character:FindFirstChildOfClass("Humanoid")
														return character ~= nil and character.Health > 0
													end
													local function fn55(arg, arg2)
														local now2 = os.clock()
														local n33 = nil
														local n34 = 0
														while os.clock() - now2 < arg2 do
															if not fn30() then return false end
															local character = arg and arg.Character
															local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
															local humanoid = character and character:FindFirstChildOfClass("Humanoid")
															if humanoidRootPart and humanoid and humanoid.Health > 0 then
																local n35 = 0
																local state = nil
																local n36 = 0
																pcall(function()
																	n35 = math.abs(humanoidRootPart.AssemblyLinearVelocity.Y)
																	state = humanoid:GetState()
																	n36 = humanoidRootPart.Position.Y
																end)
																local flag18 = state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping
																n33 = n33 and math.abs(n36 - n33)
																local n37 = n33 or 999
																n33 = n36
																if not flag18 and n35 < v85[167] and n37 < 1.5 then
																	n34 += v85[64]
																	if n34 >= 2 then return v85[192] end
																else
																	n34 = 0
																end
															end
															task.wait(0.1)
														end
														return false
													end
													fn52 = function(arg)
														for i = 1, v85[169] do
															if not fn30() then return v85[139] end
															if i == 1 then task.wait(3) end
															fn55(arg, 8)
															if fn54(arg) then
																local ok, result = pcall(iCollectProAPRun, arg, "jail")
																if ok and result then
																	fn45("jail", arg)
																	task.wait(0.6)
																	if fn54(arg) then return true end
																end
															end
															task.wait(0.3)
														end
														return false
													end
												end
											end
											do
												local fn54
												do
													iCollectProAPFireAll = function(arg)
														local v88 = fn41(arg)
														if v88 then
															fn42(tostring(arg.Name) .. (v88 == "friend" and " is a whitelisted friend - skipped" or " uses iCollectPro - skipped"))
															return
														end
														local n33 = 0
														for _, v89 in ipairs(tbl19) do
															if not fn43(v89) then
																task.delay(n33 * (0.1 + math.random() * 0.05), function()
																	if not fn30() then return end
																	if iCollectProAPRun(arg, v89) then fn45(v89, arg) end
																end)
																n33 += v85[64]
															end
														end
														fn42(("sent %d to %s"):format(n33, tostring(arg.DisplayName)))
													end
													genv.iCollectPro_APFireAll = iCollectProAPFireAll
													fn53 = function()
														for _, v88 in ipairs(tbl19) do if not fn43(v88) then return v88 end end
														return nil
													end
													do
														local function fn55(arg, arg2, arg3, arg4)
															local tbl28 = { arg.X, arg.Y, arg.Z }
															local tbl29 = { arg2.X, arg2.Y, arg2.Z }
															local tbl30 = { arg3.X, arg3.Y, arg3.Z }
															local n33 = 0
															local n34 = 1e9
															for i = v85[64], 3 do
																if math.abs(tbl29[i]) < 1e-06 then
																	if tbl28[i] < tbl30[i] - arg4 or tbl28[i] > tbl30[i] + arg4 then return false end
																	continue
																end
																local n35 = (tbl30[i] - arg4 - tbl28[i]) / tbl29[i]
																local n36 = (tbl30[i] + arg4 - tbl28[i]) / tbl29[i]
																if not (n36 < n35) then
																	local v88 = n36
																	n36 = n35
																	n35 = v88
																end
																if n33 < n36 then n33 = n36 end
																if n35 < n34 then n34 = n35 end
																if not (n34 < n33) then continue end
																return v85[139]
															end
															return true
														end
														fn54 = function()
															local currentCamera = workspace.CurrentCamera
															if not currentCamera then return nil end
															local v88 = nil
															pcall(function()
																local mouseLocation = UserInputService:GetMouseLocation()
																v88 = currentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
															end)
															if not v88 then return nil end
															local huge = math.huge
															local v89 = nil
															for _, player in ipairs(Players:GetPlayers()) do
																if player ~= localPlayer and player.Character then
																	local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
																	if humanoidRootPart and fn55(v88.Origin, v88.Direction, humanoidRootPart.Position, 8) then
																		local magnitude = (v88.Origin - humanoidRootPart.Position).Magnitude
																		if magnitude < huge then
																			huge = magnitude
																			v89 = player
																		end
																	end
																end
															end
															return v89
														end
													end
												end
												do
													local v88 = nil
													local highlight = nil
													local function fn55()
														if v88 then
															pcall(function()
																v88:Disconnect()
															end)
															v88 = nil
														end
														if highlight then
															pcall(function()
																highlight:Destroy()
															end)
															highlight = nil
														end
													end
													fn46 = function()
														fn55()
														pcall(function()
															highlight = Instance.new("Highlight")
															highlight.FillTransparency = 0.6
															highlight.OutlineColor = tbl22.STROKE
															highlight.FillColor = tbl22.AQUA
															highlight.Parent = iCollectProUIHost()
															fn29(highlight)
														end)
														v88 = fn31(RunService.RenderStepped, function()
															if not tbl23.ClickToAP then return end
															local v89 = fn54()
															if highlight then highlight.Adornee = v89 and v89.Character or nil end
														end)
													end
													fn47 = nil
													genv.iCollectPro_APClickToAP = function(arg)
														tbl23.ClickToAP = arg and true or v85[139]
														fn35()
														if tbl23.ClickToAP then
															fn46()
														else
															fn55()
														end
														fn42("click to AP " .. (tbl23.ClickToAP and v85[176] or "OFF"))
														if fn47 then pcall(fn47) end
														return tbl23.ClickToAP
													end
												end
												fn31(UserInputService.InputBegan, function(arg, arg2)
													if arg2 or not tbl23.ClickToAP then return end
													if arg.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
													local v88 = fn54()
													if not v88 then return end
													local v89 = fn41(v88)
													if v89 then
														fn42(tostring(v88.Name) .. (v89 == "friend" and " is a whitelisted friend - skipped" or " uses iCollectPro - skipped"))
														return
													end
													local v90 = fn53()
													if not v90 then
														fn42("everything is on cooldown")
														return
													end
													task.spawn(function()
														if iCollectProAPRun(v88, v90) then
															fn45(v90, v88)
															fn42("sent " .. v90 .. " to " .. tostring(v88.Name))
														end
													end)
												end)
											end
										end
										do
											local v88 = nil
											local part = nil
											local n33 = 0
											local function fn54()
												n33 += 1
												if v88 then
													pcall(function()
														v88:Disconnect()
													end)
													v88 = nil
												end
												if part then
													pcall(function()
														part:Destroy()
													end)
													part = nil
												end
											end
											fn48 = function()
												fn54()
												local v89 = n33
												v88 = fn31(RunService.Heartbeat, function()
													if v89 ~= n33 or not tbl23.ProximityAP then return end
													local character = localPlayer.Character
													character = character and character:FindFirstChild("HumanoidRootPart")
													if not character then return end
													if not (part and part.Parent) then
														part = Instance.new("Part")
														part.Name = "__iCollectProAPRange"
														part.Anchored = v85[192]
														part.CanCollide = false
														part.CanQuery = false
														part.CanTouch = false
														part.CastShadow = false
														part.Shape = Enum.PartType.Cylinder
														part.Color = tbl22.AQUA
														part.Transparency = 0.6
														part.Parent = workspace.CurrentCamera or workspace
													end
													local num = tonumber(tbl23.ProximityRange) or v85[78]
													part.Size = Vector3.new(0.5, num * v85[67], num * 2)
													part.CFrame = character.CFrame * CFrame.Angles(0, v85[164], 1.5707963267948966) + Vector3.new(v85[164], -2.5, v85[164])
												end)
												task.spawn(function()
													while v89 == n33 and fn30() do
														task.wait(0.2 + math.random() * 0.08)
														if tbl23.ProximityAP then
															local character = localPlayer.Character
															character = character and character:FindFirstChild("HumanoidRootPart")
															if character and fn53() then
																local n34 = tonumber(tbl23.ProximityRange) or 15
																for _, player in ipairs(Players:GetPlayers()) do
																	local character2 = player ~= localPlayer and player.Character
																	character2 = character2 and character2:FindFirstChild("HumanoidRootPart")
																	if character2 and (character2.Position - character.Position).Magnitude <= n34 and not fn41(player) then
																		iCollectProAPFireAll(player)
																	end
																end
															end
														end
													end
												end)
											end
											genv.iCollectPro_APProximity = function(arg)
												tbl23.ProximityAP = arg and v85[192] or false
												fn35()
												if tbl23.ProximityAP then
													fn48()
												else
													fn54()
												end
												fn42("proximity AP " .. (tbl23.ProximityAP and "ON" or "OFF"))
												if fn47 then pcall(fn47) end
												return tbl23.ProximityAP
											end
										end
										do
											do
												local function iCollectProAPNearestOwner()
													local character = localPlayer.Character
													character = character and character:FindFirstChild("HumanoidRootPart")
													if not character then return nil end
													local plots = workspace:FindFirstChild("Plots")
													if not plots then return nil end
													local v88 = nil
													local huge = math.huge
													for _, child in ipairs(plots:GetChildren()) do
														local plotSign = child:FindFirstChild("PlotSign")
														if plotSign then
															local yourBase = nil
															pcall(function()
																yourBase = plotSign:FindFirstChild("YourBase")
															end)
															if not (yourBase and yourBase.Enabled) then
																local isBasePart = nil
																pcall(function()
																	isBasePart = plotSign:IsA("BasePart") and plotSign or plotSign:FindFirstChildWhichIsA("BasePart", true)
																end)
																if isBasePart then
																	local magnitude = (character.Position - isBasePart.Position).Magnitude
																	if magnitude < huge then
																		v88 = child
																		huge = magnitude
																	end
																end
															end
														end
													end
													if not v88 then return nil end
													local v89 = nil
													pcall(function()
														local plotSign = v88:FindFirstChild("PlotSign")
														plotSign = plotSign and plotSign:FindFirstChild("SurfaceGui")
														plotSign = plotSign and plotSign:FindFirstChild(v85[68])
														plotSign = plotSign and plotSign:FindFirstChild("TextLabel")
														if not plotSign then return end
														local iCollectProRealSignText = genv.iCollectPro_RealSignText and genv.iCollectPro_RealSignText(plotSign) or plotSign.Text
														iCollectProRealSignText = iCollectProRealSignText:match("^(.-)'") or iCollectProRealSignText
														for _, player in ipairs(Players:GetPlayers()) do
															if player.DisplayName == iCollectProRealSignText or player.Name == iCollectProRealSignText then
																v89 = player
																break
															end
														end
													end)
													return v89
												end
												genv.iCollectPro_APNearestOwner = iCollectProAPNearestOwner
												local flag18 = false
												fn49 = function(arg)
													if flag18 then return end
													local v88 = iCollectProAPNearestOwner()
													if not v88 then
														fn42("no base near you")
														return
													end
													if v88 == localPlayer then
														fn42("that is your own base")
														return
													end
													local v89 = fn41(v88)
													if v89 then
														fn42(tostring(v88.Name) .. (v89 == "friend" and " is a whitelisted friend - skipped" or " uses iCollectPro - skipped"))
														return
													end
													local tbl28 = {}
													local ipairs = ipairs
													local spamOrder = tbl23.SpamOrder or tbl19
													for _, v91 in ipairs(spamOrder) do if tbl23.SpamOn[v91] ~= false then tbl28[#tbl28 + 1] = v91 end end
													if #tbl28 == 0 then
														fn42("nothing selected in SETTINGS")
														return
													end
													flag18 = true
													if arg then
														arg.Text = "SPAMMING..."
														arg.BackgroundColor3 = tbl22.AQUA
													end
													fn42("spamming " .. tostring(v88.DisplayName))
													task.spawn(function()
														local n33 = 0
														for i, v91 in ipairs(tbl28) do
															if fn30() then
																if v91 == "jail" then
																	if fn52(v88) then n33 += 1 end
																else
																	local ok, result = pcall(iCollectProAPRun, v88, v91)
																	if ok and result then
																		fn45(v91, v88)
																		n33 += 1
																	end
																end
																local v92 = tbl28[i + 1]
																if v92 then
																	if not (v91 == "rocket" and v92 == "jail") then
																		task.wait((tbl23.SpamDelay and tbl23.SpamDelay[v91] or 1) + math.random() * 0.1)
																	end
																end
																continue
															end
															break
														end
														task.wait(0.3)
														flag18 = false
														if arg and arg.Parent then
															arg.Text = "SPAM BASE OWNER"
															arg.BackgroundColor3 = tbl22.SURF2
														end
														fn42(("sent %d to %s"):format(n33, tostring(v88.DisplayName)))
													end)
												end
											end
										end
									end
									genv.iCollectPro_APSpamOwner = function() fn49(nil) end
									screenGui = nil
									frame = nil
									scrollingFrame = nil
									frame2 = nil
									scrollingFrame2 = nil
									tbl27 = {}
									fn50 = nil
									do
										local tbl28 = {}
										fn51 = function(arg, arg2)
											local v88 = tbl28[arg]
											if v88 then
												if arg2.Parent then arg2.Image = v88 end
												return
											end
											task.spawn(function()
												local ok, image = pcall(function()
													return Players:GetUserThumbnailAsync(arg, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
												end)
												if ok and image then
													tbl28[arg] = image
													if arg2.Parent then arg2.Image = image end
												end
											end)
										end
									end
								end
								do
									local fn52
									do
										local createFrame
										do
											do
												local function fn53(arg)
													local flag18 = false
													pcall(function()
														flag18 = arg:GetAttribute("Stealing") and true or v85[139]
													end)
													local str6 = nil
													local v88 = v85[164]
													pcall(function()
														local character = arg.Character
														if not character then return end
														for _, child in ipairs(character:GetChildren()) do
															if child:IsA("Tool") or child:IsA("Model") then
																local attribute = child:GetAttribute("Index")
																if type(attribute) ~= "string" or attribute == "" then attribute = child.Name end
																local attribute2 = child:GetAttribute("Mutation")
																if attribute2 == nil or attribute2 == "" then attribute2 = "None" end
																if attribute2 == "Yin Yang" then attribute2 = "YinYang" end
																local n33 = 0
																pcall(function()
																	local datas = game:GetService("ReplicatedStorage"):FindFirstChild("Datas")
																	datas = datas and datas:FindFirstChild(v85[72])
																	datas = datas and require(datas)
																	local v89 = datas and datas[attribute]
																	if v89 then
																		local num = tonumber(v89.Generation)
																		local n34
																		if num then
																			n34 = num
																		else
																			n34 = (tonumber(v89.Price) or 0) * 0.1
																		end
																		n33 = n34
																	end
																end)
																if n33 > 0 then
																	v88 = n33
																	str6 = tostring(child:GetAttribute("DisplayName") or child.Name)
																	if attribute2 ~= "None" then str6 ..= " [" .. tostring(attribute2) .. "]" end
																	flag18 = true
																	break
																else
																end
															end
														end
													end)
													return flag18, str6, v88
												end
												local function fn54(arg)
													local n33 = tonumber(arg) or 0
													if n33 >= 1e12 then return ("$%.2fT/s"):format(n33 / 1e12) end
													if n33 >= 1e9 then return ("$%.2fB/s"):format(n33 / 1e9) end
													if n33 >= 1000000 then return ("$%.2fM/s"):format(n33 / 1000000) end
													if n33 >= v85[77] then return ("$%.1fK/s"):format(n33 / 1000) end
													return ("$%.0f/s"):format(n33)
												end
												local function fn55(parent, arg)
													if not arg then
														arg = Instance.new("UIScale")
														arg.Parent = parent
													end
													pcall(function()
														arg.Scale = 0.92
														TweenService:Create(arg, tweenInfo2, { Scale = 1 }):Play()
													end)
													return arg
												end
												createFrame = function(arg, arg2)
													local frame3 = Instance.new("Frame")
													frame3.Name = "APRow_" .. tostring(arg.UserId)
													frame3.Size = UDim2.new(1, -v85[169], 0, v85[79])
													frame3.BackgroundColor3 = tbl22.ROW
													frame3.BackgroundTransparency = 0.15
													frame3.BorderSizePixel = v85[164]
													frame3.LayoutOrder = 10 + (arg2 or 0)
													frame3.Parent = scrollingFrame
													createUICorner(frame3, 8)
													local flag18 = false
													local function fn56() return flag18 and tbl22.ROW_PET or tbl22.ROW end
													frame3.MouseEnter:Connect(function()
														fn36(frame3, flag18 and tbl22.ROW_PET_HOVER or tbl22.ROW_HOVER)
													end)
													frame3.MouseLeave:Connect(function()
														fn36(frame3, fn56())
													end)
													local instance = Instance.new(v85[157], frame3)
													instance.Size = UDim2.new(v85[164], 34, v85[164], 34)
													instance.Position = UDim2.new(0, 7, 0.5, -17)
													instance.BackgroundColor3 = tbl22.SURF2
													instance.BorderSizePixel = 0
													instance.ScaleType = Enum.ScaleType.Crop
													createUICorner(instance, 17)
													fn51(arg.UserId, instance)
													local textLabel2 = Instance.new("TextLabel", frame3)
													textLabel2.Position = UDim2.new(0, 48, 0, v85[164])
													textLabel2.Size = UDim2.new(1, -(n32 + v85[189]), v85[64], v85[164])
													textLabel2.BackgroundTransparency = 1
													textLabel2.Text = tostring(arg.DisplayName)
													textLabel2.Font = Enum.Font.GothamBold
													textLabel2.TextSize = 12
													textLabel2.TextColor3 = tbl22.TEXT
													textLabel2.TextXAlignment = Enum.TextXAlignment.Left
													textLabel2.TextTruncate = Enum.TextTruncate.AtEnd
													local textLabel3 = Instance.new("TextLabel", frame3)
													textLabel3.Position = UDim2.new(v85[164], 48, 0, 27)
													textLabel3.Size = UDim2.new(0, 0, 0, 16)
													textLabel3.BackgroundTransparency = v85[64]
													textLabel3.Text = ""
													textLabel3.RichText = true
													textLabel3.Font = Enum.Font.GothamMedium
													textLabel3.TextSize = 11
													textLabel3.TextColor3 = tbl22.DIM
													textLabel3.TextXAlignment = Enum.TextXAlignment.Left
													textLabel3.TextTruncate = Enum.TextTruncate.AtEnd
													local textLabel4 = Instance.new("TextLabel", frame3)
													textLabel4.AnchorPoint = Vector2.new(v85[64], 0)
													textLabel4.Position = UDim2.new(1, -(n32 + 4), 0, 0)
													textLabel4.Size = UDim2.new(0, 96, v85[64], v85[164])
													textLabel4.BackgroundTransparency = 1
													textLabel4.Text = ""
													textLabel4.Font = Enum.Font.GothamMedium
													textLabel4.TextSize = 10
													textLabel4.TextColor3 = tbl22.DIM
													textLabel4.TextXAlignment = Enum.TextXAlignment.Right
													textLabel4.TextTruncate = Enum.TextTruncate.AtEnd
													local frame4 = Instance.new("Frame", frame3)
													frame4.AnchorPoint = Vector2.new(1, v85[164])
													frame4.Position = UDim2.new(v85[64], -v85[169], v85[164], 0)
													frame4.Size = UDim2.new(0, n32, 1, 0)
													frame4.BackgroundTransparency = v85[64]
													local function fn57()
														local x = frame3.AbsoluteSize.X
														if x <= 0 then return end
														local n33 = x - 48 - 8 - n32
														local n34 = textLabel4.Text ~= "" and math.clamp(n33 - 130, 0, 80) or v85[164]
														local n35 = math.max(0, n33 - n34 - 8)
														textLabel4.Size = UDim2.new(0, n34, 1, 0)
														if textLabel3.Text ~= "" then
															textLabel2.Size = UDim2.new(v85[164], n35, 0, 26)
															textLabel2.Position = UDim2.new(0, 48, v85[164], v85[70])
															textLabel3.Size = UDim2.new(0, n35, 0, 16)
														else
															textLabel2.Size = UDim2.new(v85[164], n35, 1, 0)
															textLabel2.Position = UDim2.new(0, 48, v85[164], v85[164])
															textLabel3.Size = UDim2.new(v85[164], v85[164], 0, 16)
														end
													end
													frame3:GetPropertyChangedSignal("AbsoluteSize"):Connect(fn57)
													task.defer(fn57)
													local v88 = nil
													local tbl28 = {}
													for i, v89 in ipairs(tbl21) do
														local textButton = Instance.new("TextButton", frame4)
														textButton.Size = UDim2.new(0, 32, 0, 34)
														textButton.Position = UDim2.new(0, (i - 1) * 35, 0.5, -17)
														textButton.BackgroundColor3 = tbl22.SURF2
														textButton.BorderSizePixel = v85[164]
														textButton.Text = v89.icon
														textButton.TextSize = 17
														textButton.Font = Enum.Font.GothamBlack
														textButton.TextColor3 = tbl22.TEXT
														textButton.AutoButtonColor = false
														createUICorner(textButton, 8)
														local tbl29 = { b = textButton, cmd = v89.cmd, base = tbl22.SURF2, blocked = false, hover = false, scale = nil }
														tbl28[#tbl28 + 1] = tbl29
														textButton.MouseEnter:Connect(function()
															tbl29.hover = true
															if not tbl29.blocked then fn36(textButton, tbl22.ROW_HOVER) end
														end)
														textButton.MouseLeave:Connect(function()
															tbl29.hover = false
															fn36(textButton, tbl29.base)
														end)
														textButton.MouseButton1Click:Connect(function()
															tbl29.scale = fn55(textButton, tbl29.scale)
															if v88 then
																fn42(tostring(arg.Name) .. (v88 == "friend" and " is a whitelisted friend - skipped" or " uses iCollectPro - skipped"))
																return
															end
															if fn43(v89.cmd) then return end
															if v89.cmd == v85[104] and fn44() then return end
															task.spawn(function()
																if iCollectProAPRun(arg, v89.cmd) then
																	fn45(v89.cmd, arg)
																	fn42(v89.cmd .. " -> " .. tostring(arg.DisplayName))
																end
															end)
														end)
														if not tbl25[v89.cmd] then tbl25[v89.cmd] = {} end
														table.insert(tbl25[v89.cmd], textButton)
													end
													local textButton = Instance.new("TextButton", frame4)
													textButton.Size = UDim2.new(0, 40, 0, 35)
													textButton.Position = UDim2.new(v85[164], #tbl21 * 35, v85[140], -17)
													textButton.BackgroundColor3 = tbl22.AQUA2
													textButton.BorderSizePixel = 0
													textButton.Text = "ALL"
													textButton.TextSize = 11
													textButton.Font = Enum.Font.GothamBlack
													textButton.TextColor3 = Color3.new(1, v85[64], 1)
													textButton.AutoButtonColor = false
													createUICorner(textButton, 8)
													local v89 = nil
													textButton.MouseEnter:Connect(function()
														if not v88 then fn36(textButton, tbl22.AQUA) end
													end)
													textButton.MouseLeave:Connect(function()
														fn36(textButton, v88 and tbl22.SURF2 or tbl22.AQUA2)
													end)
													textButton.MouseButton1Click:Connect(function()
														v89 = fn55(textButton, v89)
														if v88 then
															fn42(tostring(arg.Name) .. (v88 == "friend" and " is a whitelisted friend - skipped" or " uses iCollectPro - skipped"))
															return
														end
														task.spawn(iCollectProAPFireAll, arg)
													end)
													task.spawn(function()
														while frame3.Parent and fn30() do
															local ok, result = pcall(fn41, arg)
															v88 = ok and result or nil
															local text = tbl22.TEXT
															local str6 = ""
															if v88 then
																text = tbl24[v88] or Color3.fromRGB(255, 255, 100)
																str6 = " [" .. v88 .. "]"
															end
															textLabel2.TextColor3 = text
															local text2 = tostring(arg.DisplayName) .. str6
															if textLabel2.Text ~= text2 then textLabel2.Text = text2 end
															local v90, v91, v92 = fn53(arg)
															local text3 = ""
															if not v90 then
																pcall(function()
																	local character = arg.Character
																	local tool = character and character:FindFirstChildOfClass("Tool")
																	if tool then text3 = tostring(tool.Name) end
																end)
															end
															local text4
															if v91 then
																text4 = "<font color=\"#b98cff\">" .. v91 .. "</font> " .. "<font color=\"#7ce8b0\">" .. fn54(v92) .. "</font>"
															else
																text4 = ""
																if v90 then text4 = "<font color=\"#7ce8b0\">carrying a brainrot</font>" end
															end
															if textLabel3.Text ~= text4 then
																textLabel3.Text = text4
																fn57()
															end
															if flag18 ~= v90 then
																flag18 = v90
																fn36(frame3, fn56())
															end
															if textLabel4.Text ~= text3 then
																textLabel4.Text = text3
																fn57()
															end
															local flag19 = v88 ~= nil
															for _, v93 in ipairs(tbl28) do
																if v93.b.Parent then
																	local v94 = fn43(v93.cmd)
																	local flag20 = v93.cmd == "balloon" and fn44()
																	if flag19 then
																		v93.blocked = true
																		v93.base = tbl22.SURF
																		v93.b.TextTransparency = 0.5
																		v93.b.TextColor3 = tbl22.OFF_TEXT
																	elseif v94 or flag20 then
																		v93.blocked = true
																		v93.base = tbl22.ERROR
																		v93.b.TextTransparency = 0.35
																		v93.b.TextColor3 = tbl22.OFF_TEXT
																	else
																		v93.blocked = false
																		v93.base = tbl22.SURF2
																		v93.b.TextTransparency = 0
																		v93.b.TextColor3 = tbl22.TEXT
																	end
																	if not v93.hover or v93.blocked then v93.b.BackgroundColor3 = v93.base end
																end
															end
															if textButton.Parent then
																textButton.BackgroundColor3 = flag19 and tbl22.SURF or tbl22.AQUA2
																textButton.TextTransparency = flag19 and 0.5 or v85[164]
															end
															task.wait(v85[140])
														end
													end)
													return frame3
												end
											end
										end
										local v88 = nil
										local function fn53()
											local tbl28 = {}
											for _, player in ipairs(Players:GetPlayers()) do
												if player ~= localPlayer and not fn39(player) then tbl28[#tbl28 + 1] = player.UserId end
											end
											table.sort(tbl28)
											return table.concat(tbl28, ",")
										end
										fn52 = function(arg)
											if not scrollingFrame then return end
											local v89 = fn53()
											local n33 = 0
											for _, v90 in pairs(tbl27) do
												v90 = v90 and v90.Parent
												if v90 then n33 += 1 end
											end
											local n34 = v89 == "" and 0 or select(v85[67], v89:gsub(",", "")) + 1
											if not arg and v89 == v88 and n33 == n34 then return end
											v88 = v89
											for k, v90 in pairs(tbl27) do
												if v90 and v90.Parent then
													pcall(function()
														v90:Destroy()
													end)
												end
												tbl27[k] = nil
											end
											table.clear(tbl25)
											local n35 = 0
											for _, player in ipairs(Players:GetPlayers()) do
												if player ~= localPlayer and not fn39(player) then
													n35 += 1
													local ok, result = pcall(createFrame, player, n35)
													if ok and result then tbl27[player.UserId] = result end
												end
											end
										end
									end
									do
										fn38 = function() fn52(true) end
										do
											local function fn53(arg, layoutOrder)
												local frame3 = Instance.new("Frame")
												frame3.Size = UDim2.new(1, -4, v85[164], 30)
												frame3.BackgroundColor3 = tbl22.ROW
												frame3.BackgroundTransparency = 0.25
												frame3.BorderSizePixel = 0
												frame3.LayoutOrder = layoutOrder
												frame3.Parent = scrollingFrame2
												createUICorner(frame3, 7)
												local textButton = Instance.new("TextButton", frame3)
												textButton.Size = UDim2.new(0, 16, 0, 22)
												textButton.Position = UDim2.new(0, 4, 0.5, -11)
												textButton.BackgroundTransparency = 1
												textButton.Text = "▲"
												textButton.TextSize = 10
												textButton.Font = Enum.Font.GothamBold
												textButton.TextColor3 = tbl22.AQUA
												local textButton2 = Instance.new("TextButton", frame3)
												textButton2.Size = UDim2.new(0, 16, 0, 22)
												textButton2.Position = UDim2.new(0, 21, v85[140], -11)
												textButton2.BackgroundTransparency = 1
												textButton2.Text = "▼"
												textButton2.TextSize = 10
												textButton2.Font = Enum.Font.GothamBold
												textButton2.TextColor3 = tbl22.AQUA
												local textLabel2 = Instance.new("TextLabel", frame3)
												textLabel2.Size = UDim2.new(v85[164], 92, 1, 0)
												textLabel2.Position = UDim2.new(v85[164], 40, v85[164], 0)
												textLabel2.BackgroundTransparency = 1
												textLabel2.Text = tbl20[arg] or arg
												textLabel2.Font = Enum.Font.GothamBold
												textLabel2.TextSize = 11
												textLabel2.TextColor3 = tbl22.TEXT
												textLabel2.TextXAlignment = Enum.TextXAlignment.Left
												local textButton3 = Instance.new("TextButton", frame3)
												textButton3.Size = UDim2.new(0, 18, v85[164], 20)
												textButton3.Position = UDim2.new(0, 136, 0.5, -10)
												textButton3.BackgroundColor3 = tbl22.SURF2
												textButton3.BorderSizePixel = 0
												textButton3.Text = "-"
												textButton3.TextSize = v85[178]
												textButton3.Font = Enum.Font.GothamBold
												textButton3.TextColor3 = tbl22.AQUA
												textButton3.AutoButtonColor = false
												createUICorner(textButton3, v85[89])
												local textLabel3 = Instance.new("TextLabel", frame3)
												textLabel3.Size = UDim2.new(v85[164], 38, 1, v85[164])
												textLabel3.Position = UDim2.new(0, 157, 0, 0)
												textLabel3.BackgroundTransparency = 1
												textLabel3.Font = Enum.Font.GothamBold
												textLabel3.TextSize = 11
												textLabel3.TextColor3 = tbl22.AQUA
												local textButton4 = Instance.new("TextButton", frame3)
												textButton4.Size = UDim2.new(0, 18, 0, v85[3])
												textButton4.Position = UDim2.new(0, 196, v85[140], -10)
												textButton4.BackgroundColor3 = tbl22.SURF2
												textButton4.BorderSizePixel = 0
												textButton4.Text = "+"
												textButton4.TextSize = 13
												textButton4.Font = Enum.Font.GothamBold
												textButton4.TextColor3 = tbl22.AQUA
												textButton4.AutoButtonColor = false
												createUICorner(textButton4, 5)
												local textButton5 = Instance.new("TextButton", frame3)
												textButton5.AnchorPoint = Vector2.new(v85[64], 0.5)
												textButton5.Size = UDim2.new(0, 42, 0, 20)
												textButton5.Position = UDim2.new(1, -8, v85[140], 0)
												textButton5.BorderSizePixel = 0
												textButton5.TextSize = v85[138]
												textButton5.Font = Enum.Font.GothamBold
												textButton5.AutoButtonColor = false
												createUICorner(textButton5, 5)
												local v88 = createUIStroke(textButton5, tbl22.STROKE, 1, 0.55)
												local function fn54()
													textLabel3.Text = ("%.1fs"):format(tonumber(tbl23.SpamDelay[arg]) or 1)
													local flag18 = tbl23.SpamOn[arg] ~= v85[139]
													textButton5.Text = flag18 and v85[176] or v85[121]
													textButton5.BackgroundColor3 = flag18 and tbl22.GREEN or tbl22.SURF
													textButton5.TextColor3 = flag18 and tbl22.GREEN_TEXT or tbl22.OFF_TEXT
													v88.Color = flag18 and tbl22.GREEN_STROKE or tbl22.STROKE
													v88.Transparency = flag18 and 0.22 or 0.55
												end
												fn54()
												textButton3.MouseButton1Click:Connect(function()
													tbl23.SpamDelay[arg] = math.clamp((tonumber(tbl23.SpamDelay[arg]) or 1) - 0.1, 0.1, 5)
													fn54()
													fn35()
												end)
												textButton4.MouseButton1Click:Connect(function()
													tbl23.SpamDelay[arg] = math.clamp((tonumber(tbl23.SpamDelay[arg]) or 1) + 0.1, 0.1, 5)
													fn54()
													fn35()
												end)
												textButton5.MouseButton1Click:Connect(function()
													tbl23.SpamOn[arg] = not (tbl23.SpamOn[arg] ~= v85[139])
													fn54()
													fn35()
												end)
												local function fn55(arg2)
													local spamOrder = tbl23.SpamOrder
													for i, v89 in ipairs(spamOrder) do
														if v89 == arg then
															local n33 = i + arg2
															if n33 >= 1 and n33 <= #spamOrder then
																local v90 = spamOrder[i]
																spamOrder[i] = spamOrder[n33]
																spamOrder[n33] = v90
																fn35()
																if fn50 then fn50() end
															end
															return
														end
													end
												end
												textButton.MouseButton1Click:Connect(function()
													fn55(-1)
													if not (n24 > 3406) then return end
													while true do
													end
												end)
												textButton2.MouseButton1Click:Connect(function()
													fn55(1)
												end)
											end
											fn50 = function()
												if not scrollingFrame2 then return end
												for _, child in ipairs(scrollingFrame2:GetChildren()) do
													if child:IsA("Frame") then
														pcall(function()
															child:Destroy()
														end)
													end
												end
												for i, v88 in ipairs(tbl23.SpamOrder) do pcall(fn53, v88, i) end
											end
										end
									end
									local locked = tbl23.Locked == true
									local function fn53(arg, arg2)
										local flag18 = nil
										local position = nil
										local position2 = nil
										local v88 = nil
										arg.InputBegan:Connect(function(input)
											if locked then return end
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												flag18 = true
												position = input.Position
												position2 = arg2.Position
												input.Changed:Connect(function()
													if input.UserInputState == Enum.UserInputState.End then
														flag18 = false
														tbl23.Pos = { x = arg2.Position.X.Offset, y = arg2.Position.Y.Offset }
														fn35()
													end
												end)
											end
										end)
										arg.InputChanged:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
												v88 = input
											end
										end)
										fn31(UserInputService.InputChanged, function(arg3)
											if locked then
												flag18 = v85[139]
												return
											end
											if arg3 == v88 and flag18 then
												local n33 = arg3.Position - position
												arg2.Position = UDim2.new(0, position2.X.Offset + n33.X, 0, position2.Y.Offset + n33.Y)
											end
										end)
									end
									local function fn54(arg, text, layoutOrder, backgroundColor3, arg2)
										local textButton = Instance.new("TextButton", arg)
										textButton.Size = UDim2.new(1, -6, v85[164], 28)
										textButton.LayoutOrder = layoutOrder
										textButton.BackgroundColor3 = backgroundColor3 or tbl22.SURF2
										textButton.BorderSizePixel = 0
										textButton.Text = text
										textButton.Font = Enum.Font.GothamBold
										textButton.TextSize = 11
										textButton.TextColor3 = tbl22.TEXT
										textButton.AutoButtonColor = false
										createUICorner(textButton, 8)
										local v88 = createUIStroke(textButton, tbl22.STROKE, 1, 0.5)
										textButton.MouseEnter:Connect(function()
											TweenService:Create(v88, tweenInfo, { Transparency = v85[156] }):Play()
										end)
										textButton.MouseLeave:Connect(function()
											TweenService:Create(v88, tweenInfo, { Transparency = 0.5 }):Play()
										end)
										if arg2 then textButton.MouseButton1Click:Connect(arg2) end
										return textButton, v88
									end
									local function fn55()
										if genv.iCollectPro_AP_DISABLED then
											pcall(function()
												local xkPqMobileBar = iCollectProUIHost()
												local xkPqAdminPanel = xkPqMobileBar and xkPqMobileBar:FindFirstChild("XkPqAdminPanel")
												if xkPqAdminPanel then xkPqAdminPanel:Destroy() end
												xkPqMobileBar = xkPqMobileBar and xkPqMobileBar:FindFirstChild("XkPqMobileBar")
												if xkPqMobileBar then xkPqMobileBar:Destroy() end
											end)
											return
										end
										if frame then return end
										local v88 = iCollectProUIHost()
										local xkPqAdminPanel = v88:FindFirstChild("XkPqAdminPanel")
										if xkPqAdminPanel then xkPqAdminPanel:Destroy() end
										screenGui = Instance.new("ScreenGui")
										screenGui.Name = "XkPqAdminPanel"
										fn29(screenGui)
										screenGui.ResetOnSpawn = v85[139]
										screenGui.IgnoreGuiInset = true
										screenGui.DisplayOrder = 1002
										screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
										screenGui.Parent = v88
										frame = Instance.new("Frame", screenGui)
										frame.Name = "AdminPanel"
										frame.Size = UDim2.fromOffset(math.clamp(tonumber(tbl23.W) or 620, 420, 1200), math.clamp(tonumber(tbl23.H) or 430, 280, 900))
										local pos = tbl23.Pos
										local v89 = frame
										local position = type(pos) == "table"
										if position then position = UDim2.fromOffset(pos.x or v85[15], pos.y or 120) end
										v89.Position = position or UDim2.fromOffset(120, v85[15])
										frame.BackgroundColor3 = tbl22.BG
										frame.BorderSizePixel = v85[164]
										frame.ZIndex = v85[12]
										createUICorner(frame, 18)
										createUIStroke(frame, tbl22.STROKE, 1.2, 0.4)
										fn33(frame)
										local imageLabel = Instance.new("ImageLabel", frame)
										imageLabel.AnchorPoint = Vector2.new(v85[140], 0.5)
										imageLabel.Position = UDim2.new(0.5, v85[164], 0.5, 2)
										imageLabel.Size = UDim2.new(v85[64], 24, 1, 24)
										imageLabel.BackgroundTransparency = v85[64]
										imageLabel.Image = "rbxassetid://6014261993"
										imageLabel.ImageColor3 = Color3.new(0, 0, 0)
										imageLabel.ImageTransparency = 0.72
										imageLabel.ScaleType = Enum.ScaleType.Slice
										imageLabel.SliceCenter = Rect.new(49, 49, v85[154], v85[154])
										imageLabel.ZIndex = 99
										local frame3 = Instance.new("Frame", frame)
										frame3.Size = UDim2.new(1, 0, 0, 38)
										frame3.BackgroundTransparency = 1
										frame3.ZIndex = 101
										fn53(frame3, frame)
										local instance = Instance.new(v85[8], frame3)
										instance.Position = UDim2.new(0, 14, 0, 8)
										instance.Size = UDim2.new(1, -86, 0, 22)
										instance.BackgroundTransparency = v85[64]
										instance.Text = "ADMIN PANEL"
										instance.Font = Enum.Font.GothamBlack
										instance.TextSize = 18
										instance.TextColor3 = tbl22.TEXT
										instance.TextXAlignment = Enum.TextXAlignment.Center
										instance.ZIndex = 102
										local textButton = Instance.new("TextButton", frame)
										textButton.Name = "LockToggle"
										textButton.AnchorPoint = Vector2.new(v85[64], 0)
										textButton.Position = UDim2.new(1, -12, 0, 9)
										textButton.Size = UDim2.fromOffset(24, 24)
										textButton.BackgroundColor3 = tbl22.SURF2
										textButton.BorderSizePixel = 0
										textButton.Text = "🔓"
										textButton.Font = Enum.Font.GothamBlack
										textButton.TextSize = 12
										textButton.TextColor3 = tbl22.TEXT
										textButton.AutoButtonColor = false
										textButton.ZIndex = 103
										createUICorner(textButton, 7)
										local v90 = createUIStroke(textButton, tbl22.STROKE, 1, v85[140])
										local function fn56()
											textButton.Text = locked and "🔒" or "🔓"
											textButton.BackgroundColor3 = locked and tbl22.GREEN or tbl22.SURF2
											v90.Color = locked and tbl22.GREEN_STROKE or tbl22.STROKE
											v90.Transparency = locked and v85[146] or 0.5
										end
										local function iCollectProAPSetLocked(arg)
											locked = arg and v85[192] or v85[139]
											tbl23.Locked = locked
											pcall(function()
												screenGui:SetAttribute("ICP_Pinned", locked)
											end)
											fn56()
											fn35()
											fn42(locked and "locked - cannot be dragged, and Ctrl leaves it up" or "unlocked - drag it, and Ctrl hides it")
										end
										iCollectProAPSetLocked(locked)
										textButton.MouseButton1Click:Connect(function()
											iCollectProAPSetLocked(not locked)
										end)
										genv.iCollectPro_APSetLocked = iCollectProAPSetLocked
										genv.iCollectPro_APLocked = function() return locked end
										local frame4 = Instance.new("Frame", frame)
										frame4.AnchorPoint = Vector2.new(0.5, 0)
										frame4.Position = UDim2.new(v85[140], 0, 0, 34)
										frame4.Size = UDim2.new(0, 124, 0, 1)
										frame4.BackgroundColor3 = Color3.fromRGB(255, v85[149], 255)
										frame4.BackgroundTransparency = 0.15
										frame4.BorderSizePixel = 0
										frame4.ZIndex = 101
										local frame5 = Instance.new("Frame", frame)
										frame5.Position = UDim2.fromOffset(10, 44)
										frame5.Size = UDim2.new(0, 158, 1, -78)
										frame5.BackgroundColor3 = tbl22.SURF
										frame5.BorderSizePixel = 0
										frame5.ZIndex = 101
										createUICorner(frame5, 14)
										createUIStroke(frame5, tbl22.STROKE, 1, 0.5)
										local frame6 = Instance.new("Frame", frame5)
										frame6.Position = UDim2.fromOffset(4, 6)
										frame6.Size = UDim2.new(1, -v85[82], 1, -v85[142])
										frame6.BackgroundTransparency = 1
										frame6.ZIndex = 102
										local uiListLayout = Instance.new("UIListLayout", frame6)
										uiListLayout.Padding = UDim.new(0, v85[167])
										uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
										local spamBaseOwner = nil
										spamBaseOwner = fn54(frame6, "SPAM BASE OWNER", 1, tbl22.SURF2, function()
											fn49(spamBaseOwner)
										end)
										local proximity = fn54(frame6, "PROXIMITY: OFF", 2, tbl22.SURF2, function()
											task.spawn(function()
												pcall(genv.iCollectPro_APProximity, not (tbl23.ProximityAP == true))
											end)
										end)
										local clickToAp = fn54(frame6, "CLICK TO AP: OFF", 3, tbl22.SURF2, function()
											task.spawn(function()
												pcall(genv.iCollectPro_APClickToAP, not (tbl23.ClickToAP == true))
											end)
										end)
										local friends = fn54(frame6, "FRIENDS: OFF", 4, tbl22.SURF2, function()
											tbl23.SkipFriends = not (tbl23.SkipFriends == v85[192])
											fn35()
											if tbl23.SkipFriends then
												fn40()
												fn42("friends whitelisted - hiding them from the list")
											else
												fn42("friends whitelist off")
											end
											fn47()
											fn52(true)
										end)
										local instance2 = Instance.new(v85[68], frame6)
										instance2.Size = UDim2.new(v85[64], -6, 0, 28)
										instance2.LayoutOrder = 5
										instance2.BackgroundColor3 = tbl22.SURF2
										instance2.BorderSizePixel = 0
										instance2.ZIndex = 103
										createUICorner(instance2, 8)
										createUIStroke(instance2, tbl22.STROKE, 1, 0.5)
										local textLabel2 = Instance.new("TextLabel", instance2)
										textLabel2.Position = UDim2.fromOffset(9, v85[164])
										textLabel2.Size = UDim2.new(1, -76, 1, 0)
										textLabel2.BackgroundTransparency = 1
										textLabel2.Font = Enum.Font.GothamBold
										textLabel2.TextSize = 10
										textLabel2.TextColor3 = tbl22.TEXT
										textLabel2.TextXAlignment = Enum.TextXAlignment.Left
										textLabel2.ZIndex = 104
										local function fn57() textLabel2.Text = "RANGE  " .. tostring(tonumber(tbl23.ProximityRange) or v85[78]) end
										local function fn58(arg)
											tbl23.ProximityRange = math.clamp((tonumber(tbl23.ProximityRange) or 15) + arg, 5, 80)
											fn57()
											fn35()
										end
										local textButton2 = Instance.new("TextButton", instance2)
										textButton2.AnchorPoint = Vector2.new(1, 0.5)
										textButton2.Position = UDim2.new(v85[64], -38, 0.5, 0)
										textButton2.Size = UDim2.fromOffset(24, 20)
										textButton2.BackgroundColor3 = tbl22.SURF
										textButton2.BorderSizePixel = 0
										textButton2.Text = "-"
										textButton2.Font = Enum.Font.GothamBold
										textButton2.TextSize = 13
										textButton2.TextColor3 = tbl22.AQUA
										textButton2.AutoButtonColor = v85[139]
										textButton2.ZIndex = 104
										createUICorner(textButton2, 5)
										textButton2.MouseButton1Click:Connect(function()
											fn58(-1)
										end)
										local textButton3 = Instance.new("TextButton", instance2)
										textButton3.AnchorPoint = Vector2.new(v85[64], 0.5)
										textButton3.Position = UDim2.new(v85[64], -8, 0.5, 0)
										textButton3.Size = UDim2.fromOffset(v85[42], 20)
										textButton3.BackgroundColor3 = tbl22.SURF
										textButton3.BorderSizePixel = 0
										textButton3.Text = "+"
										textButton3.Font = Enum.Font.GothamBold
										textButton3.TextSize = v85[178]
										textButton3.TextColor3 = tbl22.AQUA
										textButton3.AutoButtonColor = v85[139]
										textButton3.ZIndex = 104
										createUICorner(textButton3, 5)
										textButton3.MouseButton1Click:Connect(function()
											fn58(1)
										end)
										fn57()
										fn54(frame6, "SPAM SETTINGS", v85[167], tbl22.AQUA2, function()
											if frame2 then
												frame2.Visible = not frame2.Visible
												tbl23.SettingsOpen = frame2.Visible
												fn35()
												if frame2.Visible then
													fn50()
													if tbl17.RefreshMobileScaleFor then
														task.defer(tbl17.RefreshMobileScaleFor, frame2)
														task.delay(0.1, tbl17.RefreshMobileScaleFor, frame2)
													end
												end
											end
										end)
										fn47 = function()
											local flag18 = tbl23.ProximityAP == true
											local flag19 = tbl23.ClickToAP == true
											proximity.Text = "PROXIMITY: " .. (flag18 and "ON" or v85[121])
											proximity.BackgroundColor3 = flag18 and tbl22.GREEN or tbl22.SURF2
											proximity.TextColor3 = flag18 and tbl22.GREEN_TEXT or tbl22.TEXT
											clickToAp.Text = "CLICK TO AP: " .. (flag19 and v85[176] or "OFF")
											clickToAp.BackgroundColor3 = flag19 and tbl22.GREEN or tbl22.SURF2
											clickToAp.TextColor3 = flag19 and tbl22.GREEN_TEXT or tbl22.TEXT
											local flag20 = tbl23.SkipFriends == true
											friends.Text = "FRIENDS: " .. (flag20 and "SAFE" or "OFF")
											friends.BackgroundColor3 = flag20 and tbl22.GREEN or tbl22.SURF2
											friends.TextColor3 = flag20 and tbl22.GREEN_TEXT or tbl22.TEXT
										end
										fn47()
										if tbl23.SkipFriends then fn40() end
										local frame7 = Instance.new("Frame", frame)
										frame7.Position = UDim2.fromOffset(176, v85[184])
										frame7.Size = UDim2.new(v85[64], -186, 1, -78)
										frame7.BackgroundColor3 = tbl22.SURF
										frame7.BorderSizePixel = 0
										frame7.ZIndex = 101
										createUICorner(frame7, v85[46])
										createUIStroke(frame7, tbl22.STROKE, 1, 0.5)
										scrollingFrame = Instance.new("ScrollingFrame", frame7)
										scrollingFrame.Position = UDim2.fromOffset(v85[169], 5)
										scrollingFrame.Size = UDim2.new(v85[64], -8, 1, -10)
										scrollingFrame.BackgroundTransparency = 1
										scrollingFrame.BorderSizePixel = 0
										scrollingFrame.ScrollBarThickness = 4
										scrollingFrame.ScrollBarImageColor3 = tbl22.AQUA
										scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
										scrollingFrame.CanvasSize = UDim2.new(0, 0, v85[164], 0)
										scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
										scrollingFrame.ZIndex = 102
										local uiListLayout2 = Instance.new("UIListLayout", scrollingFrame)
										uiListLayout2.Padding = UDim.new(v85[164], 5)
										uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
										Instance.new("UIPadding", scrollingFrame).PaddingBottom = UDim.new(0, 8)
										textLabel = Instance.new("TextLabel", frame)
										textLabel.AnchorPoint = Vector2.new(0, 1)
										textLabel.Position = UDim2.new(0, 14, 1, -v85[82])
										textLabel.Size = UDim2.new(1, -28, 0, 18)
										textLabel.BackgroundTransparency = 1
										textLabel.Font = Enum.Font.GothamBold
										textLabel.TextSize = 10
										textLabel.TextColor3 = tbl22.DIM
										textLabel.TextXAlignment = Enum.TextXAlignment.Left
										textLabel.TextTruncate = Enum.TextTruncate.AtEnd
										textLabel.Text = "ready"
										textLabel.ZIndex = 102
										local textButton4 = Instance.new("TextButton", frame)
										textButton4.Name = "Resize"
										textButton4.AnchorPoint = Vector2.new(1, 1)
										textButton4.Position = UDim2.new(1, -5, 1, -5)
										textButton4.Size = UDim2.fromOffset(20, 20)
										textButton4.BackgroundTransparency = v85[64]
										textButton4.Text = "◢"
										textButton4.Font = Enum.Font.GothamBlack
										textButton4.TextSize = v85[78]
										textButton4.TextColor3 = tbl22.STROKE
										textButton4.TextTransparency = 0.35
										textButton4.AutoButtonColor = false
										textButton4.ZIndex = v85[51]
										local flag18 = false
										local position2 = nil
										local size = nil
										local function fn59()
											local responsiveScale = frame:FindFirstChild("ResponsiveScale")
											responsiveScale = responsiveScale and responsiveScale.Scale or 1
											if not responsiveScale or responsiveScale <= 0.05 then responsiveScale = 1 end
											return responsiveScale
										end
										textButton4.MouseEnter:Connect(function()
											TweenService:Create(textButton4, tweenInfo, { TextTransparency = v85[164] }):Play()
										end)
										textButton4.MouseLeave:Connect(function()
											if not flag18 then TweenService:Create(textButton4, tweenInfo, { TextTransparency = 0.35 }):Play() end
										end)
										textButton4.InputBegan:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												flag18 = v85[192]
												position2 = input.Position
												size = frame.Size
												textButton4.TextTransparency = 0
											end
										end)
										fn31(UserInputService.InputChanged, function(arg)
											if not flag18 then return end
											if arg.UserInputType ~= Enum.UserInputType.MouseMovement and arg.UserInputType ~= Enum.UserInputType.Touch then
												return
											end
											local v91 = fn59()
											local n33 = (arg.Position.X - position2.X) / v91
											local n34 = (arg.Position.Y - position2.Y) / v91
											local clamp = math.clamp
											frame.Size = UDim2.fromOffset(math.clamp(math.floor(size.X.Offset + n33), 420, 1200), clamp(math.floor(size.Y.Offset + n34), 280, 900))
										end)
										fn31(UserInputService.InputEnded, function(arg)
											if not flag18 then return end
											if arg.UserInputType ~= Enum.UserInputType.MouseButton1 and arg.UserInputType ~= Enum.UserInputType.Touch then
												return
											end
											flag18 = v85[139]
											textButton4.TextTransparency = 0.35
											tbl23.W = frame.Size.X.Offset
											tbl23.H = frame.Size.Y.Offset
											fn35()
											if tbl17.RefreshMobileScaleFor then task.defer(tbl17.RefreshMobileScaleFor, frame) end
										end)
										frame2 = Instance.new("Frame", screenGui)
										frame2.Name = "AdminSettings"
										frame2.Size = UDim2.fromOffset(300, 420)
										frame2.Position = UDim2.fromOffset(frame.Position.X.Offset + frame.Size.X.Offset + v85[46], frame.Position.Y.Offset)
										frame2.BackgroundColor3 = tbl22.BG
										frame2.BorderSizePixel = 0
										frame2.Visible = tbl23.SettingsOpen == true
										frame2.ZIndex = v85[12]
										createUICorner(frame2, 18)
										createUIStroke(frame2, tbl22.STROKE, 1.2, 0.4)
										fn33(frame2)
										local frame8 = Instance.new("Frame", frame2)
										frame8.Size = UDim2.new(1, v85[164], 0, 38)
										frame8.BackgroundTransparency = v85[64]
										frame8.ZIndex = 101
										fn53(frame8, frame2)
										local textLabel3 = Instance.new("TextLabel", frame8)
										textLabel3.Position = UDim2.new(0, v85[46], 0, 8)
										textLabel3.Size = UDim2.new(v85[64], -56, 0, v85[144])
										textLabel3.BackgroundTransparency = 1
										textLabel3.Text = "SPAM SETTINGS"
										textLabel3.Font = Enum.Font.GothamBlack
										textLabel3.TextSize = 16
										textLabel3.TextColor3 = tbl22.TEXT
										textLabel3.TextXAlignment = Enum.TextXAlignment.Center
										textLabel3.ZIndex = 102
										local textButton5 = Instance.new("TextButton", frame2)
										textButton5.AnchorPoint = Vector2.new(v85[64], v85[164])
										textButton5.Position = UDim2.new(1, -v85[142], 0, 9)
										textButton5.Size = UDim2.fromOffset(v85[42], 24)
										textButton5.BackgroundColor3 = tbl22.SURF2
										textButton5.BorderSizePixel = v85[164]
										textButton5.Text = "X"
										textButton5.Font = Enum.Font.GothamBlack
										textButton5.TextSize = 12
										textButton5.TextColor3 = tbl22.TEXT
										textButton5.AutoButtonColor = false
										textButton5.ZIndex = 103
										createUICorner(textButton5, v85[87])
										createUIStroke(textButton5, tbl22.STROKE, 1, v85[140])
										textButton5.MouseButton1Click:Connect(function()
											frame2.Visible = false
											tbl23.SettingsOpen = false
											fn35()
										end)
										local textLabel4 = Instance.new("TextLabel", frame2)
										textLabel4.Position = UDim2.fromOffset(v85[46], 34)
										textLabel4.Size = UDim2.new(1, -28, 0, 26)
										textLabel4.BackgroundTransparency = 1
										textLabel4.Font = Enum.Font.GothamMedium
										textLabel4.TextSize = 9
										textLabel4.TextColor3 = tbl22.DIM
										textLabel4.TextWrapped = v85[192]
										textLabel4.Text = "The order SPAM BASE OWNER fires in, and how long it waits after each one. Arrows reorder, ON/OFF drops one out."
										textLabel4.TextXAlignment = Enum.TextXAlignment.Left
										textLabel4.ZIndex = 102
										scrollingFrame2 = Instance.new("ScrollingFrame", frame2)
										scrollingFrame2.Position = UDim2.fromOffset(10, 64)
										scrollingFrame2.Size = UDim2.new(v85[64], -v85[3], 1, -110)
										scrollingFrame2.BackgroundTransparency = 1
										scrollingFrame2.BorderSizePixel = 0
										scrollingFrame2.ScrollBarThickness = 4
										scrollingFrame2.ScrollBarImageColor3 = tbl22.AQUA
										scrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y
										scrollingFrame2.CanvasSize = UDim2.new(v85[164], v85[164], 0, 0)
										scrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
										scrollingFrame2.ZIndex = 102
										local uiListLayout3 = Instance.new("UIListLayout", scrollingFrame2)
										uiListLayout3.Padding = UDim.new(0, 5)
										uiListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
										local textButton6 = Instance.new("TextButton", frame2)
										textButton6.AnchorPoint = Vector2.new(0.5, v85[64])
										textButton6.Position = UDim2.new(0.5, 0, 1, -12)
										textButton6.Size = UDim2.new(1, -20, 0, 28)
										textButton6.BackgroundColor3 = tbl22.SURF2
										textButton6.BorderSizePixel = 0
										textButton6.Text = "RESET TO DEFAULT"
										textButton6.Font = Enum.Font.GothamBold
										textButton6.TextSize = 11
										textButton6.TextColor3 = tbl22.TEXT
										textButton6.AutoButtonColor = false
										textButton6.ZIndex = 102
										createUICorner(textButton6, 8)
										createUIStroke(textButton6, tbl22.STROKE, 1, 0.5)
										textButton6.MouseButton1Click:Connect(function()
											tbl23.SpamOrder = { "balloon", "rocket", "jail", "inverse", "jumpscare", "morph", "nightvision", "ragdoll", "tiny" }
											for _, v91 in ipairs(tbl19) do
												tbl23.SpamDelay[v91] = 1
												tbl23.SpamOn[v91] = true
											end
											fn35()
											fn50()
											fn42("spam settings reset")
										end)
										frame.Visible = tbl23.PanelVisible ~= false
										if frame.Visible and tbl17.RefreshMobileScaleFor then
											task.defer(tbl17.RefreshMobileScaleFor, frame)
											task.delay(0.1, tbl17.RefreshMobileScaleFor, frame)
										end
										fn52(true)
										fn50()
										fn31(Players.PlayerAdded, function()
											task.delay(1, function()
												if frame and frame.Visible then fn52() end
											end)
										end)
										fn31(Players.PlayerRemoving, function(arg)
											if arg then tbl26[arg.UserId] = nil end
											task.delay(v85[140], function()
												if frame and frame.Visible then fn52() end
											end)
										end)
										task.spawn(function()
											while frame and frame.Parent and fn30() do
												task.wait(1)
												if frame.Visible then pcall(fn52) end
											end
										end)
									end
									genv.iCollectPro_ToggleAdminPanel = function()
										if genv.iCollectPro_AP_DISABLED then return end
										fn55()
										if not frame then return end
										frame.Visible = not frame.Visible
										tbl23.PanelVisible = frame.Visible
										fn35()
										if frame.Visible then
											fn52()
											if tbl17.RefreshMobileScaleFor then
												task.defer(tbl17.RefreshMobileScaleFor, frame)
												task.delay(0.1, tbl17.RefreshMobileScaleFor, frame)
											end
										end
									end
									task.spawn(function()
										if not fn30() then return end
										if genv.iCollectPro_AP_DISABLED then return end
										pcall(fn55)
										if tbl23.ClickToAP then pcall(fn46) end
										if tbl23.ProximityAP then pcall(fn48) end
									end)
								end
							end
							local UserInputService2, HttpService
							do
								local CollectionService
								do
									UserInputService2 = game:GetService("UserInputService")
									CollectionService = game:GetService("CollectionService")
									HttpService = game:GetService("HttpService")
									local localPlayer2 = game:GetService("Players").LocalPlayer
								end
								local tbl24 = {
									IuCZFoVLhUds = true,
									qNvTxRbKzWme = v85[192],
									lMWjwEoSnCPj = v85[192],
									bRXgmsaEVfze = true,
									XkPqMobileBar = v85[192],
									XkPqQuickBar = true,
									ICPWatermark = true,
								}
								local flag18 = false
								local function iCollectProSetUIHidden(arg)
									local v88 = arg and v85[192] or v85[139]
									if v88 == flag18 then return flag18 end
									flag18 = v88
									local ok, result = pcall(function()
										return CollectionService:GetTagged("iCollectPro_UI")
									end)
									if not ok or not result then return flag18 end
									for _, v89 in ipairs(result) do
										if v89:IsA("ScreenGui") then
											if v88 then
												local flag19 = false
												pcall(function()
													local v90 = v85[192]
													flag19 = v89:GetAttribute("ICP_Pinned") == v90
												end)
												if not tbl24[v89.Name] and not flag19 then
													pcall(function()
														if v89:GetAttribute("ICP_HiddenWas") == nil then v89:SetAttribute("ICP_HiddenWas", v89.Enabled) end
														v89.Enabled = false
													end)
												end
											else
												pcall(function()
													local attribute = v89:GetAttribute("ICP_HiddenWas")
													if attribute ~= nil then
														v89.Enabled = attribute and true or false
														v89:SetAttribute("ICP_HiddenWas", nil)
													end
												end)
											end
										end
									end
									return flag18
								end
								genv.iCollectPro_ShowAllUI = function()
									flag18 = v85[139]
									pcall(function()
										for _, v88 in ipairs(CollectionService:GetTagged("iCollectPro_UI")) do
											if v88:IsA("ScreenGui") then
												pcall(function()
													v88:SetAttribute("ICP_HiddenWas", nil)
													v88.Enabled = true
												end)
											end
										end
									end)
								end
								genv.iCollectPro_SetUIHidden = iCollectProSetUIHidden
								genv.iCollectPro_UIHidden = function() return flag18 end
								genv.iCollectPro_ToggleUI = function()
									if not (3392 >= n24) then return iCollectProSetUIHidden(not flag18) end
									while true do
									end
								end
								fn31(UserInputService2.InputBegan, function(arg, arg2)
									if arg2 or arg.UserInputType ~= Enum.UserInputType.Keyboard then return end
									if UserInputService2:GetFocusedTextBox() then return end
									if arg.KeyCode == Enum.KeyCode.LeftControl or arg.KeyCode == Enum.KeyCode.RightControl then
										local flag19 = v85[139]
										pcall(function()
											for _, v88 in ipairs(CollectionService:GetTagged("iCollectPro_UI")) do
												if v88:IsA("ScreenGui") and v88:GetAttribute("ICP_HiddenWas") ~= nil then
													flag19 = true
													break
												end
											end
										end)
										flag18 = flag19
										iCollectProSetUIHidden(not flag19)
									end
								end)
							end
							local function fn38()
								if not UserInputService2.TouchEnabled then return false end
								if not UserInputService2.MouseEnabled then return true end
								local ok, result = pcall(function()
									return workspace.CurrentCamera.ViewportSize
								end)
								if ok and result and result.X > 0 and result.Y > v85[164] then return math.min(result.X, result.Y) < 900 end
								return false
							end
							if fn38() and not genv.iCollectPro_AP_DISABLED then
								local fn39, textButton
								do
									do
										local tbl24
										do
											local tbl25 = {}
											tbl24 = nil
											if isfile and isfile("iCollectProMobile.json") then
												pcall(function()
													local json = readfile("iCollectProMobile.json")
													local data = json and json ~= "" and HttpService:JSONDecode(json)
													if type(data) == "table" then
														if 4789 > n27(2734) then
															tbl25 = data
															if tonumber(data.x) and tonumber(data.y) then
																tbl24 = { x = tonumber(data.x), y = tonumber(data.y) }
															end
														else
															while true do
															end
														end
													end
												end)
											end
											local function fn40()
												if not writefile then return end
												pcall(function()
													writefile("iCollectProMobile.json", HttpService:JSONEncode(tbl25))
												end)
											end
											fn39 = function(x, y)
												local v88 = tbl25
												tbl25.x = x
												v88.y = y
												fn40()
											end
										end
										do
											local v88
											do
												v88 = iCollectProUIHost()
												do
													local xkPqMobileBar = v88:FindFirstChild("XkPqMobileBar")
													if xkPqMobileBar then xkPqMobileBar:Destroy() end
												end
											end
											local screenGui = Instance.new("ScreenGui")
											screenGui.Name = "XkPqMobileBar"
											fn29(screenGui)
											screenGui.ResetOnSpawn = false
											screenGui.IgnoreGuiInset = true
											screenGui.DisplayOrder = 1700
											screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
											screenGui.Parent = v88
											textButton = Instance.new("TextButton", screenGui)
										end
										textButton.Name = "AdminToggle"
										textButton.AnchorPoint = Vector2.new(1, 0.5)
										textButton.Position = tbl24 and UDim2.fromOffset(tbl24.x, tbl24.y) or UDim2.new(1, -14, 0.5, -62)
									end
									textButton.Size = UDim2.fromOffset(52, 52)
									textButton.BackgroundColor3 = Color3.fromRGB(124, 45, 190)
									textButton.BorderSizePixel = 0
									textButton.AutoButtonColor = false
									textButton.Text = ""
									textButton.ZIndex = v85[28]
									Instance.new("UICorner", textButton).CornerRadius = UDim.new(1, 0)
									do
										local uiStroke = Instance.new("UIStroke", textButton)
										uiStroke.Color = Color3.fromRGB(v85[163], v85[94], v85[197])
										uiStroke.Thickness = 1.4
										uiStroke.Transparency = 0.25
										uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
									end
								end
								do
									do
										local uiGradient = Instance.new("UIGradient", textButton)
										uiGradient.Rotation = 90
										uiGradient.Color = ColorSequence.new({
											ColorSequenceKeypoint.new(v85[164], Color3.fromRGB(150, 70, 235)),
											ColorSequenceKeypoint.new(1, Color3.fromRGB(96, v85[81], 158)),
										})
									end
									do
										local imageLabel = Instance.new("ImageLabel", textButton)
										imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
										imageLabel.Position = UDim2.new(0.5, 0, 0.5, 3)
										imageLabel.Size = UDim2.new(1, v85[144], 1, 22)
										imageLabel.BackgroundTransparency = 1
										imageLabel.Image = "rbxassetid://6014261993"
										imageLabel.ImageColor3 = Color3.new(0, 0, 0)
										imageLabel.ImageTransparency = 0.6
										imageLabel.ScaleType = Enum.ScaleType.Slice
										imageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
										imageLabel.ZIndex = 149
									end
									do
										local textLabel = Instance.new("TextLabel", textButton)
										textLabel.Size = UDim2.fromScale(1, 1)
										textLabel.BackgroundTransparency = 1
										textLabel.Font = Enum.Font.GothamBlack
										textLabel.TextSize = 17
										textLabel.TextColor3 = Color3.fromRGB(240, 232, 255)
										textLabel.Text = "AP"
										textLabel.ZIndex = 151
									end
								end
								do
									local flag18 = v85[139]
									local flag19 = v85[139]
									local position = nil
									local position2 = nil
									textButton.InputBegan:Connect(function(input)
										if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
											local v88 = v85[139]
											flag18 = true
											flag19 = v88
											position = input.Position
											position2 = textButton.Position
										end
									end)
									fn31(UserInputService2.InputChanged, function(arg)
										if not flag18 then return end
										if arg.UserInputType ~= Enum.UserInputType.Touch and arg.UserInputType ~= Enum.UserInputType.MouseMovement then
											return
										end
										local n33 = arg.Position.X - position.X
										local n34 = arg.Position.Y - position.Y
										local flag20 = math.abs(n33) > 8
										local flag21
										if flag20 then
											flag21 = flag20
										else
											local v88 = v85[82]
											flag21 = math.abs(n34) > v88
										end
										if flag21 then flag19 = true end
										if flag19 then
											textButton.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n33, position2.Y.Scale, position2.Y.Offset + n34)
										end
									end)
									fn31(UserInputService2.InputEnded, function(arg)
										if not flag18 then return end
										if arg.UserInputType ~= Enum.UserInputType.Touch and arg.UserInputType ~= Enum.UserInputType.MouseButton1 then
											return
										end
										flag18 = false
										if flag19 then
											local absolutePosition = textButton.AbsolutePosition
											local absoluteSize = textButton.AbsoluteSize
											local n33 = math.floor(absolutePosition.X + absoluteSize.X)
											local n34 = math.floor(absolutePosition.Y + absoluteSize.Y * 0.5)
											textButton.Position = UDim2.fromOffset(n33, n34)
											fn39(n33, n34)
											return
										end
										local iCollectProToggleAdminPanel = genv.iCollectPro_ToggleAdminPanel
										if type(iCollectProToggleAdminPanel) == "function" then pcall(iCollectProToggleAdminPanel) end
									end)
								end
								task.spawn(function()
									local v88 = nil
									while textButton.Parent and fn30() do
										local iCollectProUIHidden = genv.iCollectPro_UIHidden
										local flag18 = type(iCollectProUIHidden) == "function" and iCollectProUIHidden() == true or false
										if flag18 ~= v88 then
											textButton.Visible = not flag18
											v88 = flag18
										end
										task.wait(0.3)
									end
								end)
							end
						end
						local CollectionService, tbl24, fn38, fn39
						do
							do
								local tbl25, frame, instance, textButton, frame2, instance2, tbl26
								do
									local createUICorner2, createUIStroke2, v88, tbl27
									do
										do
											task.spawn(function()
												local localPlayer2 = game:GetService("Players").LocalPlayer
												local tbl28 = {
													boogiebombcontroller = v85[192],
													beelaunchercontroller = true,
													beehivecontroller = v85[192],
													flyingbeecontroller = true,
												}
												local function fn40(arg)
													local flag18 = not arg or type(debug) ~= "table"
													local flag19
													if flag18 then
														flag19 = flag18
													else
														local v89 = v85[34]
														flag19 = type(debug.info) ~= v89
													end
													if flag19 then return nil end
													local ok, result = pcall(debug.info, arg, "s")
													if not ok or type(result) ~= "string" then return nil end
													return result:match("([^%.]+)$")
												end
												local tbl29 = {}
												local function fn41()
													local v89 = v85[34]
													if type(getconnections) ~= v89 then return 0 end
													local packages = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
													packages = packages and packages:FindFirstChild("Net")
													if not packages then return 0 end
													local n33 = 0
													for _, child in ipairs(packages:GetChildren()) do
														if child:IsA("RemoteEvent") then
															local ok, result = pcall(getconnections, child.OnClientEvent)
															if ok and type(result) == "table" then
																for _, v90 in ipairs(result) do
																	local v91 = fn40(v90.Function)
																	if v91 and tbl28[v91:lower()] then
																		local flag18 = v85[139]
																		pcall(function()
																			if v90.Enabled == false then flag18 = true end
																		end)
																		if not flag18 then
																			if not pcall(function()
																				v90:Disable()
																			end) then
																				pcall(function()
																					v90.Enabled = v85[139]
																				end)
																			end
																			n33 += 1
																			if not tbl29[v91] then
																				tbl29[v91] = true
																				print("[iCollectPro] disabled " .. v91)
																			end
																		end
																	end
																end
															end
														end
													end
													return n33
												end
												task.spawn(function()
													while fn30() do
														pcall(fn41)
														task.wait(10)
													end
												end)
												local Lighting = game:GetService("Lighting")
												local function fn42()
													local flag18 = false
													pcall(function()
														for _, child in ipairs(Lighting:GetChildren()) do
															if child:IsA("ColorCorrectionEffect") and child.Name == "DiscoEffect" then
																flag18 = true
																child:Destroy()
															end
														end
														if flag18 then
															for _, child in ipairs(Lighting:GetChildren()) do
																if child:IsA("BlurEffect") then child:Destroy() end
															end
															local colorCCorrection = Lighting:FindFirstChild("ColorCCorrection")
															if colorCCorrection then colorCCorrection.Enabled = v85[192] end
															local currentCamera = workspace.CurrentCamera
															if currentCamera and currentCamera.FieldOfView ~= 70 then currentCamera.FieldOfView = 70 end
														end
													end)
													return flag18
												end
												fn31(Lighting.ChildAdded, function(arg)
													if arg:IsA("ColorCorrectionEffect") and arg.Name == "DiscoEffect" then task.defer(fn42) end
												end)
												task.spawn(function()
													while fn30() do
														pcall(fn42)
														task.wait(v85[140])
													end
												end)
												local tbl30 = {
													["108604090597149"] = true,
													["115137415977055"] = true,
													["507777268"] = v85[192],
													["73368331228913"] = true,
													["130668738990029"] = true,
													["128060030509218"] = true,
													["103523748788483"] = v85[192],
													["123093512130685"] = v85[192],
													["125589250385930"] = v85[192],
													["77833964716913"] = true,
													["93618892818415"] = true,
												}
												local function fn43(arg) return tostring(arg or ""):match("(%d+)%s*$") end
												local tbl31 = { "boogie", "disco", "discoball", "bee", "bees", "beehive", "beegear", "buzzing" }
												local function fn44(arg)
													local str6 = tostring(arg):lower()
													for _, v89 in ipairs(tbl31) do if str6:find(v89, 1, v85[192]) then return v85[192] end end
													return false
												end
												local function fn45(arg)
													return arg:IsA("ParticleEmitter") or arg:IsA("Beam") or arg:IsA("Trail") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") or arg:IsA("PointLight") or arg:IsA("SpotLight") or arg:IsA("Highlight") or arg:IsA("Sound")
												end
												local function fn46(arg)
													pcall(function()
														if arg:IsA("Sound") then
															arg.Volume = 0
															arg.Playing = false
															arg:Stop()
														elseif arg:IsA("ParticleEmitter") or arg:IsA("Beam") or arg:IsA("Trail") then
															arg.Enabled = v85[139]
															if arg:IsA("ParticleEmitter") then arg:Clear() end
														elseif arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") then
															arg.Enabled = false
														elseif arg:IsA("PointLight") or arg:IsA("SpotLight") then
															arg.Enabled = v85[139]
														elseif arg:IsA("Highlight") then
															arg.Enabled = false
														end
													end)
												end
												local tbl32 = {}
												local function fn47(arg)
													if not arg then return end
													local ok, result = pcall(function()
														return arg.Animation and arg.Animation.AnimationId
													end)
													if not ok then return end
													local v89 = fn43(result)
													if v89 and tbl30[v89] then
														pcall(function()
															arg:Stop(v85[164])
														end)
														return v85[192]
													end
													return false
												end
												local function fn48(arg)
													for _, v89 in ipairs(tbl32) do
														pcall(function()
															v89:Disconnect()
														end)
													end
													table.clear(tbl32)
													if not arg then return end
													local humanoid = arg:FindFirstChildOfClass("Humanoid")
													local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
													if not animator then return end
													tbl32[#tbl32 + 1] = animator.AnimationPlayed:Connect(function(arg2)
														fn47(arg2)
													end)
													pcall(function()
														for _, v89 in ipairs(animator:GetPlayingAnimationTracks()) do fn47(v89) end
													end)
												end
												local connection = nil
												local function fn49(arg)
													if connection then
														pcall(function()
															connection:Disconnect()
														end)
														connection = nil
													end
													if not arg then return end
													fn48(arg)
													pcall(function()
														for _, descendant in ipairs(arg:GetDescendants()) do
															if fn45(descendant) and fn44(descendant.Name) then fn46(descendant) end
														end
													end)
													connection = arg.DescendantAdded:Connect(function(descendant)
														if not fn30() then return end
														if fn45(descendant) and fn44(descendant.Name) then
															fn46(descendant)
															task.defer(fn46, descendant)
															task.delay(0.15, fn46, descendant)
														end
													end)
												end
												if localPlayer2.Character then pcall(fn49, localPlayer2.Character) end
												fn31(localPlayer2.CharacterAdded, function(arg)
													task.wait(0.2)
													pcall(fn49, arg)
												end)
												local tbl33 = { "bee", "buzzing", "boogie", "disco" }
												local function fn50(arg)
													local str6 = tostring(arg):lower()
													for _, v89 in ipairs(tbl33) do if str6:find(v89, v85[64], true) then return true end end
													return false
												end
												local function fn51()
													for _, v89 in ipairs({ workspace, game:GetService("SoundService") }) do
														pcall(function()
															for _, descendant in ipairs(v89:GetDescendants()) do
																if descendant:IsA("Sound") and fn50(descendant.Name) then
																	if descendant.Playing or descendant.Volume > 0 then fn46(descendant) end
																end
															end
														end)
													end
												end
												fn31(workspace.DescendantAdded, function(arg)
													if arg:IsA(v85[98]) and fn50(arg.Name) then
														fn46(arg)
														task.defer(fn46, arg)
													end
												end)
												local function fn52(arg)
													pcall(function()
														for _, descendant in ipairs(arg:GetDescendants()) do
															if descendant:IsA("BasePart") then
																descendant.Transparency = 1
															elseif fn45(descendant) then
																fn46(descendant)
															end
														end
														if arg:IsA("BasePart") then arg.Transparency = v85[64] end
													end)
												end
												fn31(workspace.DescendantAdded, function(arg)
													if not (arg:IsA("Model") or arg:IsA("BasePart")) then return end
													local str6 = tostring(arg.Name):lower()
													if str6:find("disco", 1, v85[192]) or str6:find("boogie", 1, v85[192]) then
														fn52(arg)
														task.defer(fn52, arg)
													end
												end)
												task.spawn(function()
													while fn30() do
														pcall(fn51)
														pcall(function()
															local character = localPlayer2.Character
															if not character then return end
															for _, descendant in ipairs(character:GetDescendants()) do
																if fn45(descendant) and fn44(descendant.Name) then fn46(descendant) end
															end
															local humanoid = character:FindFirstChildOfClass("Humanoid")
															humanoid = humanoid and humanoid:FindFirstChildOfClass("Animator")
															if humanoid then for _, v89 in ipairs(humanoid:GetPlayingAnimationTracks()) do fn47(v89) end end
														end)
														task.wait(1)
													end
												end)
												print("[iCollectPro] ANTI BEE + ANTI DISCO BALL active (controller kill + backstop)")
											end)
											task.spawn(function()
												local Players2 = game:GetService("Players")
												local RunService2 = game:GetService("RunService")
												local localPlayer2 = Players2.LocalPlayer
												local tbl28 = {
													"Inverse",
													"Inversed",
													"Inverted",
													"Invert",
													"Balloon",
													"Tiny",
													"NightVision",
													"Jumpscare",
													"Morph",
													"Jailed",
												}
												local function fn40()
													for _, v89 in ipairs(tbl28) do
														pcall(function()
															if localPlayer2:GetAttribute(v89) ~= nil and localPlayer2:GetAttribute(v89) ~= false then
																localPlayer2:SetAttribute(v89, v85[139])
															end
														end)
													end
												end
												for _, v89 in ipairs(tbl28) do
													pcall(function()
														fn31(localPlayer2:GetAttributeChangedSignal(v89), function()
															pcall(fn40)
														end)
													end)
												end
												local vector = Vector3.new(v85[164], 1, 0)
												local flag18 = false
												fn31(RunService2.RenderStepped, function()
													local currentCamera = workspace.CurrentCamera
													if not currentCamera then return end
													if not pcall(function()
														local cFrame = currentCamera.CFrame
														if cFrame.UpVector.Y >= 0 then
															if flag18 then flag18 = false end
															return
														end
														if not flag18 then
															flag18 = v85[192]
															pcall(fn40)
														end
														local position = cFrame.Position
														currentCamera.CFrame = CFrame.lookAt(position, position + cFrame.LookVector, vector)
													end) then
														flag18 = false
													end
												end)
												task.spawn(function()
													while fn30() do
														pcall(function()
															local playerGui2 = localPlayer2:FindFirstChildOfClass("PlayerGui")
															if playerGui2 then
																local nightVision = playerGui2:FindFirstChild("NightVision", true)
																if nightVision and nightVision:IsA("LayerCollector") and nightVision.Enabled then
																	nightVision.Enabled = false
																end
															end
														end)
														pcall(fn40)
														task.wait(1)
													end
												end)
												print("[iCollectPro] ANTI INVERSE active (always on)")
											end)
											tbl25 = {
												BG = Color3.fromRGB(v85[3], 12, 34),
												SURF = Color3.fromRGB(28, 16, 46),
												SURF2 = Color3.fromRGB(v85[79], 26, v85[52]),
												TEXT = Color3.fromRGB(v85[173], 232, 255),
												DIM = Color3.fromRGB(155, 120, v85[126]),
												AQUA = Color3.fromRGB(168, 85, v85[197]),
												AQUA2 = Color3.fromRGB(124, 45, 190),
												STROKE = Color3.fromRGB(150, 70, 230),
												GREEN1 = Color3.fromRGB(18, 88, 58),
												GREEN_STROKE = Color3.fromRGB(v85[189], 185, 120),
												GREEN_TEXT = Color3.fromRGB(v85[16], v85[149], v85[173]),
												OFF_BG = Color3.fromRGB(48, 26, 74),
												OFF_TEXT = Color3.fromRGB(v85[33], 110, 180),
												BUSY = Color3.fromRGB(124, 45, 190),
											}
											createUICorner2 = function(parent, arg)
												local uiCorner = Instance.new("UICorner")
												uiCorner.CornerRadius = UDim.new(0, arg)
												uiCorner.Parent = parent
												return uiCorner
											end
											createUIStroke2 = function(parent, color, thickness, transparency)
												local uiStroke = Instance.new("UIStroke")
												uiStroke.Color = color
												uiStroke.Thickness = thickness or 1
												uiStroke.Transparency = transparency or 0
												uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
												uiStroke.Parent = parent
												return uiStroke
											end
											v88 = v85[79]
											do
												local function fn40(arg, ...)
													local v89 = genv[arg]
													if type(v89) ~= "function" then return false end
													local v90 = table.pack(pcall(v89, ...))
													return v90[1], v90[2]
												end
												local function fn41(arg, arg2)
													local v89 = genv[arg]
													local v90 = v85[34]
													if type(v89) ~= v90 then return arg2 end
													local ok, result = pcall(v89)
													if not ok then return arg2 end
													return result
												end
												tbl27 = {
													{
														id = "invis",
														label = "INVIS",
														toggle = true,
														on = function()
															return v87.ManualInvis == true
														end,
														fire = function()
															if type(genv.iCollectPro_InvisManual) ~= "function" then
																fn34("Manual Invis", "not ready yet")
																return
															end
															v87.ManualInvis = not (v87.ManualInvis == true)
															fn32()
															fn40("iCollectPro_InvisManual", v87.ManualInvis)
															fn34("Manual Invis", v87.ManualInvis and "ON" or "OFF")
														end,
													},
													{
														id = "drop",
														label = "DROP",
														busy = function()
															local v89 = v85[192]
															return fn41("iCollectPro_DropReady", true) ~= v89
														end,
														fire = function()
															if type(genv.iCollectPro_DropBrainrot) ~= "function" then
																fn34("Drop Brainrot", "not ready yet")
																return
															end
															task.spawn(genv.iCollectPro_DropBrainrot)
														end,
													},
													{
														id = "reset",
														label = "RESET",
														fire = function()
															if type(genv.iCollectPro_InstaReset) ~= "function" then
																fn34("Insta Reset", "not ready yet")
																return
															end
															local ok, result = pcall(genv.iCollectPro_InstaReset)
															if ok and result == v85[139] then fn34("Insta Reset", "cooling down") end
														end,
													},
													{
														id = "boost",
														label = "BOOST",
														toggle = true,
														on = function()
															return genv.iCollectPro_WalkSpeedOn == v85[192]
														end,
														fire = function()
															local flag18 = not (genv.iCollectPro_WalkSpeedOn == true)
															if not fn40("iCollectPro_WalkSpeedSet", flag18) then
																fn34("Walk Speed", "not ready yet")
																return
															end
															fn34("Walk Speed", flag18 and v85[176] or v85[121])
														end,
													},
													{
														id = "fly",
														label = "FLY",
														toggle = true,
														on = function()
															return fn41("iCollectPro_CarpetIsOn", false) == true
														end,
														fire = function()
															if not fn40("iCollectPro_CarpetSet", not (fn41("iCollectPro_CarpetIsOn", false) == true)) then
																fn34("Fly Speed", "not ready yet")
															end
														end,
													},
													{
														id = "tp",
														label = "TP BASE",
														busy = function()
															return fn41("iCollectPro_TpEmptyBusy", false) == true
														end,
														fire = function()
															if not fn40("iCollectPro_TpEmptyBase") then fn34("TP Empty Base", "not ready yet") end
														end,
													},
													{
														id = "panels",
														label = "PANELS",
														toggle = true,
														on = function()
															return fn41("iCollectPro_PanelsVisible", false) == true
														end,
														fire = function()
															if not fn40("iCollectPro_TogglePanels") then fn34("Panels", "not ready yet") end
														end,
													},
													{
														id = "hideui",
														label = "HIDE UI",
														toggle = true,
														on = function()
															return fn41("iCollectPro_UIHidden", false) == true
														end,
														fire = function()
															fn40("iCollectPro_ToggleUI")
														end,
													},
												}
											end
										end
										do
											local v89
											do
												v89 = iCollectProUIHost()
												do
													local xkPqQuickBar = v89:FindFirstChild("XkPqQuickBar")
													if xkPqQuickBar then xkPqQuickBar:Destroy() end
												end
											end
											local screenGui = Instance.new("ScreenGui")
											screenGui.Name = "XkPqQuickBar"
											fn29(screenGui)
											screenGui.ResetOnSpawn = false
											screenGui.IgnoreGuiInset = true
											screenGui.DisplayOrder = 1650
											screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
											screenGui.Parent = v89
											frame = Instance.new("Frame", screenGui)
										end
									end
									do
										do
											frame.Name = "QuickBar"
											frame.AutomaticSize = Enum.AutomaticSize.Y
											frame.Size = UDim2.fromOffset(194, 0)
											frame.BackgroundColor3 = tbl25.BG
											frame.BorderSizePixel = v85[164]
											frame.ZIndex = v85[15]
											createUICorner2(frame, 18)
											createUIStroke2(frame, tbl25.STROKE, 1.2, 0.4)
											do
												local quickBar = v87.Positions and v87.Positions.QuickBar
												if not (quickBar and quickBar.X and quickBar.Y) then
													quickBar = {
														X = 0,
														Y = 0.5,
														OffsetX = v85[46],
														OffsetY = -132,
													}
													if v87.Positions then v87.Positions.QuickBar = quickBar end
												end
												frame.Position = UDim2.new(quickBar.X, quickBar.OffsetX or 0, quickBar.Y, quickBar.OffsetY or 0)
											end
										end
										fn33(frame)
										do
											local imageLabel = Instance.new("ImageLabel", frame)
											imageLabel.Name = "Shadow"
											imageLabel.AnchorPoint = Vector2.new(0.5, v85[140])
											imageLabel.Position = UDim2.new(0.5, 0, 0.5, 2)
											imageLabel.Size = UDim2.new(1, 24, 1, 24)
											imageLabel.BackgroundTransparency = 1
											imageLabel.Image = "rbxassetid://6014261993"
											imageLabel.ImageColor3 = Color3.new(0, 0, v85[164])
											imageLabel.ImageTransparency = 0.72
											imageLabel.ScaleType = Enum.ScaleType.Slice
											imageLabel.SliceCenter = Rect.new(49, v85[56], 450, 450)
											imageLabel.ZIndex = 119
										end
									end
									do
										instance = Instance.new(v85[68], frame)
										instance.Name = "Head"
										instance.Size = UDim2.new(1, 0, 0, 32)
										instance.BackgroundTransparency = 1
										instance.ZIndex = 121
										do
											local textLabel = Instance.new("TextLabel", instance)
											textLabel.Position = UDim2.fromOffset(12, 6)
											textLabel.Size = UDim2.new(1, -46, 0, v85[3])
											textLabel.BackgroundTransparency = v85[64]
											textLabel.Text = "QUICK"
											textLabel.Font = Enum.Font.GothamBlack
											textLabel.TextSize = 14
											textLabel.TextColor3 = tbl25.TEXT
											textLabel.TextXAlignment = Enum.TextXAlignment.Left
											textLabel.ZIndex = 122
										end
									end
									do
										textButton = Instance.new("TextButton", instance)
										textButton.Name = "Fold"
										textButton.AnchorPoint = Vector2.new(1, v85[140])
										textButton.Position = UDim2.new(1, -v85[138], 0.5, 0)
										textButton.Size = UDim2.fromOffset(22, 22)
										textButton.BackgroundColor3 = tbl25.SURF2
										textButton.BorderSizePixel = 0
										textButton.Font = Enum.Font.GothamBlack
										textButton.TextSize = 12
										textButton.TextColor3 = tbl25.TEXT
										textButton.Text = "-"
										textButton.AutoButtonColor = false
										textButton.ZIndex = 123
										createUICorner2(textButton, 7)
										createUIStroke2(textButton, tbl25.STROKE, 1, 0.5)
										frame2 = Instance.new("Frame", frame)
										frame2.AnchorPoint = Vector2.new(0.5, 0)
										frame2.Position = UDim2.new(0.5, v85[164], v85[164], 29)
										frame2.Size = UDim2.new(0, 70, v85[164], v85[64])
										frame2.BackgroundColor3 = Color3.fromRGB(255, v85[149], 255)
										frame2.BackgroundTransparency = 0.15
										frame2.BorderSizePixel = v85[164]
										frame2.ZIndex = 121
										instance2 = Instance.new(v85[68], frame)
										instance2.Name = "Body"
										instance2.AutomaticSize = Enum.AutomaticSize.Y
										instance2.Size = UDim2.new(v85[64], -20, 0, 0)
										instance2.Position = UDim2.fromOffset(v85[138], 36)
										instance2.BackgroundColor3 = tbl25.SURF
										instance2.BorderSizePixel = 0
										instance2.ZIndex = 121
										createUICorner2(instance2, 14)
										createUIStroke2(instance2, tbl25.STROKE, v85[64], 0.48)
										do
											local uiPadding = Instance.new("UIPadding", instance2)
											uiPadding.PaddingTop = UDim.new(0, 6)
											uiPadding.PaddingBottom = UDim.new(0, 6)
											uiPadding.PaddingLeft = UDim.new(0, 6)
											uiPadding.PaddingRight = UDim.new(0, v85[167])
										end
									end
									do
										local uiGridLayout = Instance.new("UIGridLayout", instance2)
										uiGridLayout.CellSize = UDim2.fromOffset(72, v88)
										uiGridLayout.CellPadding = UDim2.fromOffset(6, 6)
										uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
										uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
									end
									Instance.new("UIPadding", frame).PaddingBottom = UDim.new(0, 10)
									tbl26 = {}
									for i, v89 in ipairs(tbl27) do
										do
											local textButton2 = Instance.new("TextButton", instance2)
											textButton2.Name = v89.id
											textButton2.LayoutOrder = i
											textButton2.BackgroundColor3 = tbl25.OFF_BG
											textButton2.BorderSizePixel = v85[164]
											textButton2.AutoButtonColor = false
											textButton2.Font = Enum.Font.GothamBlack
											textButton2.TextSize = 12
											textButton2.TextColor3 = tbl25.OFF_TEXT
											textButton2.Text = v89.label
											textButton2.TextWrapped = true
											textButton2.ZIndex = 122
											createUICorner2(textButton2, 10)
											local v90 = createUIStroke2(textButton2, tbl25.STROKE, 1, 0.5)
											local uiScale = Instance.new("UIScale", textButton2)
											uiScale.Scale = 1
											textButton2.MouseButton1Click:Connect(function()
												pcall(function()
													uiScale.Scale = 0.9
													tweenService:Create(uiScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
												end)
												task.spawn(function()
													pcall(v89.fire)
												end)
											end)
											tbl26[#tbl26 + 1] = { def = v89, btn = textButton2, stroke = v90, was = nil }
										end
									end
								end
								do
									local fn40, quickBarFolded
									do
										fn40 = function()
											for _, v88 in ipairs(tbl26) do
												if v88.btn.Parent then
													local was
													if v88.def.busy and v88.def.busy() then
														was = "busy"
													elseif v88.def.toggle then
														local ok
														ok, was = pcall(v88.def.on)
														was = ok and was and "on" or "off"
													else
														was = "idle"
													end
													if was ~= v88.was then
														v88.was = was
														if was == "on" then
															v88.btn.BackgroundColor3 = tbl25.GREEN1
															v88.btn.TextColor3 = tbl25.GREEN_TEXT
															v88.stroke.Color = tbl25.GREEN_STROKE
															v88.stroke.Transparency = 0.22
														elseif was == "busy" then
															v88.btn.BackgroundColor3 = tbl25.BUSY
															v88.btn.TextColor3 = tbl25.TEXT
															v88.stroke.Color = tbl25.AQUA
															v88.stroke.Transparency = 0.2
														elseif was == "idle" then
															v88.btn.BackgroundColor3 = tbl25.AQUA2
															v88.btn.TextColor3 = tbl25.TEXT
															v88.stroke.Color = tbl25.STROKE
															v88.stroke.Transparency = 0.3
														else
															v88.btn.BackgroundColor3 = tbl25.OFF_BG
															v88.btn.TextColor3 = tbl25.OFF_TEXT
															v88.stroke.Color = tbl25.STROKE
															v88.stroke.Transparency = v85[140]
														end
													end
												end
											end
										end
										fn40()
										quickBarFolded = v87.QuickBarFolded == v85[192]
										do
											local function fn41()
												instance2.Visible = not quickBarFolded
												frame2.Visible = not quickBarFolded
												textButton.Text = quickBarFolded and "+" or "-"
												frame.Size = UDim2.fromOffset(194, quickBarFolded and 32 or 0)
												frame.AutomaticSize = quickBarFolded and Enum.AutomaticSize.None or Enum.AutomaticSize.Y
											end
											fn41()
											textButton.MouseButton1Click:Connect(function()
												quickBarFolded = not quickBarFolded
												v87.QuickBarFolded = quickBarFolded
												fn32()
												fn41()
											end)
										end
									end
									do
										local flag18 = v85[139]
										local position = nil
										local position2 = nil
										local v88 = nil
										instance.InputBegan:Connect(function(input)
											if v87.UILocked then return end
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												flag18 = true
												position = input.Position
												position2 = frame.Position
												input.Changed:Connect(function()
													if input.UserInputState == Enum.UserInputState.End then
														flag18 = false
														if v87.Positions then
															v87.Positions.QuickBar = {
																X = frame.Position.X.Scale,
																Y = frame.Position.Y.Scale,
																OffsetX = frame.Position.X.Offset,
																OffsetY = frame.Position.Y.Offset,
															}
															fn32()
														end
													end
												end)
											end
										end)
										instance.InputChanged:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
												v88 = input
											end
										end)
										fn31(service.InputChanged, function(arg)
											if flag18 and arg == v88 and position and position2 then
												local n33 = arg.Position - position
												frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n33.X, position2.Y.Scale, position2.Y.Offset + n33.Y)
											end
										end)
									end
									if v87.QuickBar == nil then v87.QuickBar = v86 and true or false end
									frame.Visible = v87.QuickBar == v85[192]
									genv.iCollectPro_ToggleQuickBar = function(arg)
										if arg == nil then arg = not frame.Visible end
										frame.Visible = arg and true or v85[139]
										v87.QuickBar = frame.Visible
										fn32()
										if frame.Visible and tbl17.RefreshMobileScaleFor then task.defer(tbl17.RefreshMobileScaleFor, frame) end
										return frame.Visible
									end
									genv.iCollectPro_QuickBarVisible = function() return frame.Visible == true end
									task.spawn(function()
										while fn30() and frame.Parent do
											if frame.Visible and not quickBarFolded then pcall(fn40) end
											task.wait(0.3)
										end
									end)
								end
							end
							do
								if n26(2744) >= 13948 then
									local localPlayer2, fn40, screenGui, textLabel, fn41
									do
										localPlayer2 = game:GetService("Players").LocalPlayer
										fn40 = function() return iCollectProUIHost() end
										do
											local n33 = 360
											local n34 = 30
											screenGui = nil
											textLabel = nil
											local uiScale = nil
											local connection = nil
											local function fn42()
												if not (textLabel and textLabel.Parent and uiScale) then return end
												local v88, vector2 = deviceClass()
												if not vector2 or vector2.X < v85[64] or vector2.Y < v85[64] then vector2 = Vector2.new(1920, 1080) end
												local flag18 = vector2.Y > vector2.X
												if v88 == "phone" then
													flag18 = flag18 and 0.72 or 0.38
												elseif v88 == "tablet" then
													flag18 = flag18 and 0.56 or 0.3
												else
													flag18 = 0.3
												end
												local n35
												if v88 == "desktop" then
													local v89 = v85[49]
													n35 = math.clamp(math.min(vector2.X / 1920, vector2.Y / 1080), v89, 1.2)
												else
													n35 = vector2.X * flag18 / n33
												end
												uiScale.Scale = math.clamp(math.min(n35, vector2.Y * (v88 == "desktop" and 0.075 or v85[91]) / n34, vector2.X * 0.94 / n33), 0.4, 1.25)
												textLabel.Position = UDim2.new(v85[140], v85[164], 1, -math.floor(vector2.Y * 0.012 + 0.5) - 4)
											end
											fn41 = function()
												local v88 = fn40()
												local icpWatermark = v88:FindFirstChild("ICPWatermark")
												if icpWatermark then
													pcall(function()
														icpWatermark:Destroy()
													end)
												end
												screenGui = Instance.new("ScreenGui")
												screenGui.Name = "ICPWatermark"
												pcall(fn29, screenGui)
												screenGui.ResetOnSpawn = v85[139]
												screenGui.IgnoreGuiInset = true
												screenGui.DisplayOrder = 2000
												screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
												screenGui.Parent = v88
												textLabel = Instance.new("TextLabel", screenGui)
												textLabel.Name = "Mark"
												textLabel.AnchorPoint = Vector2.new(v85[140], v85[64])
												textLabel.Position = UDim2.new(0.5, v85[164], 1, -8)
												textLabel.Size = UDim2.fromOffset(360, 30)
												textLabel.BackgroundColor3 = Color3.fromRGB(20, 12, 34)
												textLabel.BackgroundTransparency = 0.2
												textLabel.Font = Enum.Font.GothamBlack
												textLabel.TextSize = v85[45]
												textLabel.TextScaled = true
												textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
												textLabel.TextStrokeColor3 = Color3.fromRGB(40, 14, 70)
												textLabel.TextStrokeTransparency = 0.4
												textLabel.Text = "DISCORD.GG/FREESCRIPTS"
												textLabel.Visible = v85[139]
												Instance.new("UICorner", textLabel).CornerRadius = UDim.new(0, v85[138])
												local uiStroke = Instance.new("UIStroke", textLabel)
												uiStroke.Color = Color3.fromRGB(v85[28], 70, v85[136])
												uiStroke.Thickness = 1.2
												uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
												local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", textLabel)
												uiTextSizeConstraint.MaxTextSize = 16
												uiTextSizeConstraint.MinTextSize = 8
												local uiPadding = Instance.new("UIPadding", textLabel)
												uiPadding.PaddingTop = UDim.new(0, 5)
												uiPadding.PaddingBottom = UDim.new(0, 5)
												uiPadding.PaddingLeft = UDim.new(0, 8)
												uiPadding.PaddingRight = UDim.new(v85[164], 8)
												uiScale = Instance.new("UIScale")
												uiScale.Name = "ResponsiveScale"
												uiScale.Parent = textLabel
												if connection then
													pcall(function()
														connection:Disconnect()
													end)
													connection = nil
												end
												local currentCamera = workspace.CurrentCamera
												if currentCamera then
													connection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
														pcall(fn42)
													end)
												end
												pcall(fn42)
											end
											pcall(fn41)
											fn31(workspace:GetPropertyChangedSignal("CurrentCamera"), function()
												if connection then
													pcall(function()
														connection:Disconnect()
													end)
													connection = nil
												end
												local currentCamera = workspace.CurrentCamera
												if currentCamera then
													connection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
														pcall(fn42)
													end)
												end
												pcall(fn42)
											end)
										end
									end
									do
										local function fn42()
											local iuCZFoVLhUds = fn40():FindFirstChild("IuCZFoVLhUds")
											if not iuCZFoVLhUds then return v85[139] end
											local flag18 = false
											for _, descendant in ipairs(iuCZFoVLhUds:GetDescendants()) do
												if descendant:IsA(v85[8]) and descendant.Name == "Invite" then
													flag18 = v85[192]
													if descendant.Text ~= "DISCORD.GG/FREESCRIPTS" then
														pcall(function()
															descendant.Text = "DISCORD.GG/FREESCRIPTS"
														end)
													end
													if not descendant.Visible then
														pcall(function()
															descendant.Visible = true
														end)
													end
													if v85[130] < descendant.TextTransparency then
														pcall(function()
															descendant.TextTransparency = 0
														end)
													end
												end
											end
											return flag18
										end
										local function fn43() return type(rawget(genv, "iCollectPro_Gen")) == "number" end
										local n33 = 0
										task.spawn(function()
											while fn30() do
												local flag18 = false
												pcall(function()
													flag18 = fn42()
												end)
												if not (screenGui and screenGui.Parent) then pcall(fn41) end
												if not fn43() then pcall(fn41) end
												if textLabel then
													if textLabel.Text ~= "DISCORD.GG/FREESCRIPTS" then
														pcall(function()
															textLabel.Text = "DISCORD.GG/FREESCRIPTS"
														end)
													end
													pcall(function()
														textLabel.Visible = not flag18
													end)
												end
												if not flag18 and not (screenGui and screenGui.Parent and textLabel and textLabel.Parent and textLabel.Text == "DISCORD.GG/FREESCRIPTS") then
													n33 += 1
												else
													n33 = 0
												end
												if n33 >= 3 then
													pcall(function()
														localPlayer2:Kick("NEGGY THIS SCRIPT IS OWNED BY iCollectPro AND ITS FREE")
													end)
													return
												end
												task.wait(0.5)
											end
										end)
									end
									task.spawn(function()
										task.wait(v85[67])
										if not fn30() then return end
										local tbl25 = {
											"polsec",
											"POLSEC",
											"PolSec",
											"Polsec",
											"scriptdumper",
											"dumpstring",
											"functiondump",
											"saveinstance",
											"decompile",
											"unluac",
										}
										local tbl26 = {}
										local env = getfenv and getfenv() or {}
										for _, v88 in ipairs(tbl25) do
											if rawget(genv, v88) ~= nil or rawget(env, v88) ~= nil then tbl26[#tbl26 + 1] = v88 end
										end
										if v85[164] < #tbl26 then
											print("[iCollectPro] wrapper/dump sniff (informational only): " .. table.concat(tbl26, ", "))
										end
									end)
								else
									while v85[192] do
									end
								end
								CollectionService = game:GetService("CollectionService")
								tbl24 = {}
								do
									local function fn40(arg, arg2, arg3, arg4, arg5, arg6)
										tbl24[("%d,%d,%d"):format(arg, arg2, arg3)] = Color3.fromRGB(arg4, arg5, arg6)
									end
									fn40(16, 10, 26, 13, 9, v85[89])
									fn40(20, v85[142], 34, 17, 11, 6)
									fn40(18, 14, 28, 18, v85[142], v85[167])
									fn40(28, 16, 46, 30, 18, 9)
									fn40(48, v85[182], 76, 54, 31, v85[142])
									fn40(v85[79], 26, 74, 52, 30, 12)
									fn40(62, 34, 96, 76, 44, v85[45])
									fn40(34, 20, 54, 34, 21, v85[138])
									fn40(46, 26, 72, 48, 29, v85[142])
									fn40(30, 18, v85[79], 32, 19, v85[82])
									fn40(36, v85[144], 60, 42, 25, v85[138])
									fn40(14, 8, v85[42], 14, 9, 4)
									fn40(46, 27, 74, 50, 29, 11)
									fn40(24, 14, 40, 26, v85[78], 6)
									fn40(26, 16, 42, 28, 17, v85[82])
									fn40(12, 7, 20, 13, v85[82], 3)
									fn40(v85[46], 9, v85[42], 15, 9, 4)
									fn40(28, 22, 44, 30, 20, 9)
									fn40(22, 17, 34, v85[42], 16, 7)
									fn40(16, 12, v85[182], 17, 11, v85[89])
									fn40(23, 18, 36, 26, 17, v85[82])
									fn40(40, 14, 70, 44, 18, v85[169])
									fn40(168, v85[94], 247, 255, 140, 26)
									fn40(124, 45, v85[108], 198, 82, 8)
									fn40(v85[28], v85[141], 230, 255, 122, 18)
									fn40(150, v85[141], 235, 255, 128, v85[3])
									fn40(200, 150, 255, v85[149], 214, 96)
									fn40(190, v85[33], v85[149], v85[149], 180, 70)
									fn40(216, 190, 255, 255, 206, 132)
									fn40(216, 182, v85[149], 255, 200, v85[15])
									fn40(205, 160, v85[149], 255, 196, 110)
									fn40(200, v85[51], 255, 255, v85[163], 54)
									fn40(v85[33], 45, 210, 206, 78, v85[167])
									fn40(96, v85[81], 158, 170, 62, v85[169])
									fn40(128, 60, v85[149], 255, 132, v85[144])
									fn40(110, 60, 170, 176, 92, v85[46])
									fn40(64, 38, v85[155], 84, 50, 18)
									fn40(34, 20, 56, 44, 26, 10)
									fn40(240, 232, 255, 255, 241, 218)
									fn40(155, 120, v85[126], 186, 138, 78)
									fn40(140, 110, 180, 150, 112, 62)
									fn40(140, v85[33], 150, 150, 122, 96)
									fn40(18, 88, 58, 24, 86, 18)
									fn40(21, 120, 76, 36, 116, 22)
									fn40(60, 185, 120, 126, v85[126], 40)
									fn40(v85[16], 255, 240, 236, 255, 206)
									fn40(30, 118, 78, 40, 112, v85[3])
									fn40(14, 66, 44, v85[3], 68, 12)
									fn40(56, 214, 110, v85[33], 210, 50)
								end
							end
							fn38 = function(arg)
								local round = math.round
								local n33 = arg.B * 255
								return ("%d,%d,%d"):format(math.round(arg.R * v85[149]), math.round(arg.G * 255), round(n33))
							end
							do
								local tbl25 = {
									"BackgroundColor3",
									"TextColor3",
									"TextStrokeColor3",
									"ImageColor3",
									"ScrollBarImageColor3",
									"PlaceholderColor3",
									"Color",
								}
								local tbl26 = {}
								for k, v88 in pairs(tbl24) do
									local str6
									do
										local round = math.round
										local n33 = v88.B * 255
										str6 = ("%d,%d,%d"):format(math.round(v88.R * v85[149]), math.round(v88.G * 255), round(n33))
									end
									if tbl24[str6] then warn("[iCollectPro] theme map collision on " .. str6) end
									do
										local v89 = tonumber
										local match = k.match
										tbl26[str6] = Color3.fromRGB(tonumber(k:match("^(%d+)")), tonumber(k:match(",(%d+),")), v89(match(k, ",(%d+)$")))
									end
								end
								local function fn40(arg, arg2)
									local v88 = arg2 and tbl24 or tbl26
									local tbl27 = {}
									local flag18 = v85[139]
									for _, keypoint in ipairs(arg.Color.Keypoints) do
										local v89 = v88[fn38(keypoint.Value)]
										if v89 then flag18 = true end
										tbl27[#tbl27 + 1] = ColorSequenceKeypoint.new(keypoint.Time, v89 or keypoint.Value)
									end
									if flag18 and #tbl27 >= v85[67] then
										pcall(function()
											arg.Color = ColorSequence.new(tbl27)
										end)
									end
								end
								fn39 = function(arg, arg2)
									if arg:IsA("UIGradient") then
										pcall(fn40, arg, arg2)
										return
									end
									arg2 = arg2 and tbl24 or tbl26
									for _, v88 in ipairs(tbl25) do
										local ok, result = pcall(function()
											return arg[v88]
										end)
										if ok and typeof(result) == "Color3" then
											local v89 = arg2[fn38(result)]
											if v89 then
												pcall(function()
													arg[v88] = v89
												end)
											end
										end
									end
								end
							end
						end
						local str6, fn40, fn41, fn42, fn43, fn44, fn45
						do
							do
								local fn46, fn47
								do
									do
										str6 = "default"
										do
											local TweenService2 = game:GetService("TweenService")
											local tweenInfo3 = TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
											local obj = setmetatable({}, { __mode = "k" })
											fn46 = function(arg)
												if obj[arg] then return end
												local flag18 = arg:IsA(v85[68]) and tostring(arg.Name):match("Row$") ~= nil
												local isGuiButton = arg:IsA("GuiButton")
												if not flag18 and not isGuiButton then return end
												obj[arg] = true
												if flag18 then
													local backgroundColor3 = nil
													local flag19 = false
													arg.MouseEnter:Connect(function()
														if str6 ~= "halloween" then return end
														if not flag19 then
															flag19 = true
															backgroundColor3 = arg.BackgroundColor3
														end
														task.defer(function()
															if not flag19 or str6 ~= "halloween" or not arg.Parent then return end
															local n623496 = tbl24["62,34,96"]
															if n623496 then
																pcall(function()
																	TweenService2:Create(arg, tweenInfo3, { BackgroundColor3 = n623496 }):Play()
																end)
															end
														end)
													end)
													arg.MouseLeave:Connect(function()
														flag19 = false
														local v88 = backgroundColor3
														task.defer(function()
															if flag19 or str6 ~= "halloween" or not v88 or not arg.Parent then return end
															pcall(function()
																TweenService2:Create(arg, tweenInfo3, { BackgroundColor3 = v88 }):Play()
															end)
														end)
													end)
													return
												end
												local function fn48()
													if str6 ~= "halloween" then return end
													task.defer(function()
														if not arg.Parent then return end
														fn39(arg, true)
														local ok, result = pcall(function()
															return arg:GetDescendants()
														end)
														if ok and result then for _, v88 in ipairs(result) do fn39(v88, v85[192]) end end
													end)
												end
												arg.MouseEnter:Connect(fn48)
												arg.MouseLeave:Connect(fn48)
											end
										end
									end
									do
										local tbl25 = {
											"BackgroundColor3",
											"TextColor3",
											"TextStrokeColor3",
											"ImageColor3",
											"Color",
										}
										local obj = setmetatable({}, { __mode = v85[93] })
										fn47 = function(arg)
											if obj[arg] or arg:IsA("UIGradient") then return end
											obj[arg] = true
											for _, v88 in ipairs(tbl25) do
												local ok, result = pcall(function()
													return arg:GetPropertyChangedSignal(v88)
												end)
												if ok and result then
													result:Connect(function()
														if str6 ~= v85[1] or not fn30() then return end
														local ok2, result2 = pcall(function()
															return arg[v88]
														end)
														if ok2 and typeof(result2) == "Color3" then
															local v89 = tbl24[fn38(result2)]
															if v89 then
																pcall(function()
																	arg[v88] = v89
																end)
															end
														end
													end)
												end
											end
										end
									end
								end
								do
									do
										do
											local function fn48(arg, arg2)
												local ok, result = pcall(function()
													return arg:GetDescendants()
												end)
												if not ok or not result then return end
												for _, v88 in ipairs(result) do
													fn39(v88, arg2)
													if arg2 then
														pcall(fn46, v88)
														pcall(fn47, v88)
													end
												end
											end
											fn40 = function(arg)
												local ok, result = pcall(function()
													return CollectionService:GetTagged(v85[25])
												end)
												if not ok or not result then return end
												for _, v88 in ipairs(result) do fn48(v88, arg) end
											end
										end
									end
									do
										local obj = setmetatable({}, { __mode = "k" })
										fn41 = function(arg)
											if obj[arg] then return end
											obj[arg] = true
											fn31(arg.DescendantAdded, function(arg2)
												if str6 ~= "halloween" then return end
												task.defer(function()
													if arg2.Parent then
														fn39(arg2, true)
														pcall(fn46, arg2)
														pcall(fn47, arg2)
													end
												end)
											end)
										end
									end
								end
							end
							do
								local screenGui = nil
								local n33 = 0
								fn42 = function()
									n33 += 1
									if screenGui then
										pcall(function()
											screenGui:Destroy()
										end)
										screenGui = nil
									end
								end
								local function fn46(parent, arg)
									local frame = Instance.new("Frame")
									frame.Name = "Bat"
									frame.BackgroundTransparency = v85[64]
									frame.Active = false
									frame.AnchorPoint = Vector2.new(0.5, 0.5)
									local n34 = math.random(16, 30)
									frame.Size = UDim2.fromOffset(n34 * 2.2, n34)
									frame.Parent = parent
									local color = Color3.fromRGB(18, 10, 6)
									local frame2 = Instance.new("Frame", frame)
									frame2.AnchorPoint = Vector2.new(0.5, 0.5)
									frame2.Position = UDim2.fromScale(0.5, 0.5)
									frame2.Size = UDim2.fromScale(0.2, 0.78)
									frame2.BackgroundColor3 = color
									frame2.BackgroundTransparency = 0.25
									frame2.BorderSizePixel = v85[164]
									Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
									local tbl25 = {}
									for i = -v85[64], 1, 2 do
										local frame3 = Instance.new("Frame", frame)
										frame3.AnchorPoint = Vector2.new(i < 0 and 1 or 0, 0.5)
										frame3.Position = UDim2.fromScale(0.5 + i * 0.09, 0.5)
										frame3.Size = UDim2.fromScale(0.42, 0.56)
										frame3.BackgroundColor3 = color
										frame3.BackgroundTransparency = 0.25
										frame3.BorderSizePixel = 0
										Instance.new(v85[5], frame3).CornerRadius = UDim.new(0.6, 0)
										tbl25[#tbl25 + 1] = { f = frame3, s = i }
									end
									task.spawn(function()
										local n35 = math.random() < 0.5 and 1 or -1
										local n36 = math.random(8, 78) / 100
										local n37 = math.random(v85[28], 300) / 10
										local v88 = v85[12]
										local n38 = math.random(4, 11) / v88
										local n39 = math.random(9, v85[45]) / 100
										local now2 = os.clock()
										while true do
											if arg == n33 and fn30() and frame.Parent then
												local n40 = (os.clock() - now2) / n37
												if not (n40 >= 1) then
													frame.Position = UDim2.fromScale(n35 > 0 and -0.1 + n40 * 1.2 or 1.1 - n40 * 1.2, n36 + math.sin(n40 * 12) * n38)
													local n41 = math.sin(os.clock() / n39) * 26
													for _, v89 in ipairs(tbl25) do v89.f.Rotation = n41 * v89.s end
													task.wait(0.033333333333333333)
													continue
												end
											end
											break
										end
										if frame.Parent then frame:Destroy() end
									end)
								end
								fn43 = function()
									fn42()
									n33 += 1
									local v88 = n33
									local v89 = iCollectProUIHost()
									local icpHwBats = v89:FindFirstChild("ICP_HW_Bats")
									if icpHwBats then icpHwBats:Destroy() end
									screenGui = Instance.new("ScreenGui")
									screenGui.Name = "ICP_HW_Bats"
									screenGui.ResetOnSpawn = false
									screenGui.IgnoreGuiInset = v85[192]
									screenGui.DisplayOrder = 300
									fn29(screenGui)
									screenGui.Parent = v89
									task.spawn(function()
										while v88 == n33 and fn30() and screenGui and screenGui.Parent do
											local n34 = 0
											for _, child in ipairs(screenGui:GetChildren()) do if child.Name == v85[73] then n34 += 1 end end
											if n34 < 4 then pcall(fn46, screenGui, v88) end
											local v90 = v85[138]
											task.wait(math.random(v85[3], 55) / v90)
										end
									end)
								end
							end
							do
								local n33 = 0
								fn44 = function() n33 += v85[64] end
								fn45 = function()
									fn44()
									n33 += 1
									local v88 = n33
									task.spawn(function()
										local v89 = iCollectProUIHost()
										local tbl25 = {}
										local color = Color3.fromRGB(226, 150, 44)
										local color2 = Color3.fromRGB(255, 224, 130)
										local n34 = 0
										while v88 == n33 and fn30() do
											local now2 = os.clock()
											if v85[67] < now2 - n34 then
												tbl25 = {}
												for _, child in ipairs(v89:GetChildren()) do
													if child:IsA("BillboardGui") and child.Name == "__PodiumNum" then
														local root = child:FindFirstChild("Root")
														local badge = root and root:FindFirstChild("Badge")
														badge = badge and badge:FindFirstChild("Num")
														if badge then tbl25[#tbl25 + 1] = { n = badge, p = math.random() * 6.28 } end
													end
												end
												n34 = now2
											end
											for _, v90 in ipairs(tbl25) do
												if v90.n.Parent then
													v90.n.TextColor3 = color:Lerp(color2, math.clamp(v85[140] + 0.5 * (math.sin(now2 * 5.5 + v90.p) * 0.6 + math.sin(now2 * 11.3 + v90.p * 2) * 0.4), 0, 1))
												end
											end
											task.wait(0.055555555555555552)
										end
									end)
								end
							end
						end
						local fn46, fn47, fn48, fn49
						do
							do
								local n33 = 0
								fn46 = function() n33 += v85[64] end
								fn47 = function()
									fn46()
									n33 += 1
									local v88 = n33
									task.spawn(function()
										while v88 == n33 and fn30() do
											pcall(function()
												local v89 = playerGui
												for _, v90 in ipairs({ iCollectProUIHost(), v89 }) do
													v90 = v90 and v90:FindFirstChild("lMWjwEoSnCPj")
													v90 = v90 and v90:FindFirstChild("Toast")
													if v90 then
														for _, child in ipairs(v90:GetChildren()) do
															if child:IsA("UIStroke") then
																local now2 = os.clock()
																local v91 = v85[140]
																child.Transparency = 0.32 + 0.22 * (0.5 + 0.5 * math.sin(now2 * 9.1)) * (0.5 + v91 * math.sin(now2 * 21.7))
															end
														end
													end
												end
											end)
											task.wait(0.05)
										end
									end)
								end
							end
							do
								local v88, fn50
								do
									v88 = v85[164]
									fn50 = function()
										local ok, result = pcall(function()
											return CollectionService:GetTagged(v85[25])
										end)
										if ok and result then
											for _, v89 in ipairs(result) do
												if v89.Name ~= "__NextBaseAnchor" then continue end
												local nextBaseBillboard = v89:FindFirstChild("NextBaseBillboard")
												if nextBaseBillboard then return nextBaseBillboard end
											end
										end
										return nil
									end
									do
										local function fn51(arg)
											if not arg then return end
											pcall(function()
												for _, child in ipairs(arg:GetChildren()) do if child.Name == "ICP_HW_Gourd" then child:Destroy() end end
												arg.StudsOffset = Vector3.new(0, 10, v85[164])
												for _, child in ipairs(arg:GetChildren()) do
													if child:IsA("TextLabel") and child.Text:find("NEXT", 1, true) then
														child.TextColor3 = Color3.fromRGB(128, v85[189], 255)
													end
												end
											end)
										end
										fn48 = function()
											v88 += v85[64]
											fn51(fn50())
										end
									end
								end
								do
									local function fn51(parent, arg)
										local frame = Instance.new("Frame")
										frame.Name = "ICP_HW_Gourd"
										frame.AnchorPoint = Vector2.new(0.5, 0.5)
										frame.Position = UDim2.fromScale(arg, 0.34)
										frame.Size = UDim2.fromScale(0.1, 0.42)
										frame.BackgroundTransparency = v85[64]
										frame.ZIndex = 4
										frame.Parent = parent
										local frame2 = Instance.new("Frame", frame)
										frame2.AnchorPoint = Vector2.new(v85[140], 0.5)
										frame2.Position = UDim2.fromScale(0.5, 0.58)
										frame2.Size = UDim2.fromScale(v85[64], 0.82)
										frame2.BackgroundColor3 = Color3.new(1, 1, 1)
										frame2.BorderSizePixel = 0
										frame2.ZIndex = 4
										Instance.new("UICorner", frame2).CornerRadius = UDim.new(v85[64], 0)
										local uiGradient = Instance.new("UIGradient", frame2)
										uiGradient.Rotation = 118
										local colorSequence = ColorSequence.new
										local tbl25 = {}
										local v89 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 96))
										local new = ColorSequenceKeypoint.new
										local color = Color3.fromRGB
										local v90 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(246, 122, v85[45]))
										tbl25[1] = v89
										tbl25[2] = v90
										do
											local values = table.pack(new(1, color(120, 38, 2)))
											table.move(values, 1, values.n, 3, tbl25)
										end
										uiGradient.Color = colorSequence(tbl25)
										for _, v91 in ipairs({ -v85[66], 0.26 }) do
											local frame3 = Instance.new("Frame", frame2)
											frame3.AnchorPoint = Vector2.new(0.5, 0.5)
											frame3.Position = UDim2.fromScale(0.5 + v91, 0.5)
											frame3.Size = UDim2.fromScale(0.32, 0.9)
											frame3.BackgroundColor3 = Color3.fromRGB(146, 50, 4)
											frame3.BackgroundTransparency = v85[188]
											frame3.BorderSizePixel = v85[164]
											frame3.ZIndex = 5
											Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, v85[164])
										end
										local frame3 = Instance.new("Frame", frame)
										frame3.AnchorPoint = Vector2.new(0.5, v85[64])
										frame3.Position = UDim2.fromScale(0.5, 0.2)
										frame3.Size = UDim2.fromScale(0.22, 0.2)
										frame3.Rotation = -v85[142]
										frame3.BackgroundColor3 = Color3.fromRGB(92, 124, 42)
										frame3.BorderSizePixel = 0
										frame3.ZIndex = 6
										Instance.new(v85[5], frame3).CornerRadius = UDim.new(0.5, 0)
										for _, v91 in ipairs({ { "◣", 0.31 }, { "◢", 0.69 } }) do
											local textLabel = Instance.new("TextLabel", frame2)
											textLabel.AnchorPoint = Vector2.new(0.5, v85[140])
											textLabel.Position = UDim2.fromScale(v91[v85[67]], 0.4)
											textLabel.Size = UDim2.fromScale(0.3, 0.34)
											textLabel.BackgroundTransparency = 1
											textLabel.Font = Enum.Font.GothamBlack
											textLabel.Text = v91[v85[64]]
											textLabel.TextScaled = true
											textLabel.TextColor3 = Color3.fromRGB(30, 8, 0)
											textLabel.ZIndex = v85[87]
										end
									end
									fn49 = function()
										fn48()
										v88 += v85[64]
										local v89 = v88
										local color = Color3.fromRGB(226, 150, 44)
										local color2 = Color3.fromRGB(255, 224, v85[51])
										task.spawn(function()
											while v89 == v88 and fn30() do
												pcall(function()
													local v90 = fn50()
													if v90 then
														local n33 = 0
														for _, child in ipairs(v90:GetChildren()) do if child.Name == "ICP_HW_Gourd" then n33 += 1 end end
														if n33 < 2 then
															for _, child in ipairs(v90:GetChildren()) do
																if child.Name == "ICP_HW_Gourd" then child:Destroy() end
															end
															fn51(v90, 0.075)
															fn51(v90, 0.925)
														end
														local now2 = os.clock()
														local n34 = 0.5 + 0.5 * (math.sin(now2 * 5.5) * 0.6 + math.sin(now2 * 11.3) * 0.4)
														for _, child in ipairs(v90:GetChildren()) do
															if child:IsA("TextLabel") and child.Text:find("NEXT", 1, v85[192]) then
																child.TextColor3 = color:Lerp(color2, math.clamp(n34, 0, 1))
															end
														end
														v90.StudsOffset = Vector3.new(0, v85[138] + math.sin(now2 * 1.7) * 0.9, 0)
													end
												end)
												task.wait(0.05)
											end
										end)
									end
								end
							end
						end
						local fn50, fn51
						do
							local tbl25 = { "rbxassetid://130567343979549", "rbxassetid://92430614337078" }
							local n33 = 0
							local v88 = nil
							local v89 = Random.new(os.clock() * 1000000)
							fn50 = function()
								n33 += 1
								local v90 = v88
								v88 = nil
								if not v90 then return end
								task.spawn(function()
									pcall(function()
										for i = 1, 6 do
											if not v90.Parent then return end
											v90.Volume = v85[198] * (1 - i / v85[167])
											task.wait(0.033333333333333333)
										end
										v90:Stop()
										v90:Destroy()
									end)
								end)
							end
							fn51 = function()
								fn50()
								n33 += 1
								local v90 = n33
								if not pcall(function()
									local instance = Instance.new(v85[98])
									instance.Name = "ICP_HW_Ambience"
									instance.SoundId = tbl25[v89:NextInteger(1, #tbl25)]
									instance.Volume = 0.02
									instance.Looped = true
									fn29(instance)
									instance.Parent = game:GetService("SoundService")
									instance:Play()
									v88 = instance
								end) then
									return
								end
								task.spawn(function()
									while v90 == n33 and fn30() do
										task.wait(2)
										local v91 = v88
										if v90 ~= n33 or not v91 or not v91.Parent then return end
										if not v91.IsPlaying then
											pcall(function()
												v91:Play()
											end)
										end
									end
								end)
							end
						end
						do
							local function fn52(arg)
								str6 = arg and "halloween" or "default"
								fn40(arg)
								if arg then
									fn43()
									fn45()
									fn47()
									fn49()
									fn51()
								else
									fn42()
									fn44()
									fn46()
									fn48()
									fn50()
								end
							end
							genv.iCollectPro_SetTheme = function(arg)
								local theme = tostring(arg) == "halloween" and "halloween" or "default"
								v87.Theme = theme
								fn32()
								fn52(theme == v85[1])
								local iCollectProRebuildPodiums = genv.iCollectPro_RebuildPodiums
								if type(iCollectProRebuildPodiums) == "function" then pcall(iCollectProRebuildPodiums) end
								return theme
							end
							genv.iCollectPro_ThemeApplied = function() return str6 end
							task.spawn(function()
								for i = 1, 20 do
									if not fn30() then return end
									if iCollectProThemeIsHalloween() then
										fn52(v85[192])
										break
									end
									task.wait(0.25)
								end
								while fn30() do
									local ok, result = pcall(function()
										return CollectionService:GetTagged(v85[25])
									end)
									if ok and result then for _, v88 in ipairs(result) do fn41(v88) end end
									if str6 == "halloween" then fn40(true) end
									task.wait(0.33)
								end
							end)
						end
						return
					end
					while true do
					end
				end
			end
		end
	end
end

fn14(100, "[  ERROR  ]", " - Failed to load Luarmor client --> " .. tostring(v63), Color3["new"](1, 0, 0), "error")