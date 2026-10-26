local n = 3835640773
local n2 = 375366920
local n3 = 349235746
local genv

if type(getgenv) ~= "function" then
	genv = _G
else
	genv = getgenv() or _G
end

local sabcomAutoJoinerGen = (tonumber(genv.SabcomAutoJoinerGen) or 0) + 1
local v = bit32.band(n2, n3)
genv.SabcomAutoJoinerGen = sabcomAutoJoinerGen
local sabcomAutoJoinerGen2 = genv.SabcomAutoJoinerGen

if type(genv.SabcomCancelJoin) == "function" then
	pcall(genv.SabcomCancelJoin)
end

if genv.SabcomAutoJoinerGui then
	pcall(function()
		genv.SabcomAutoJoinerGui:Destroy()
	end)
end

genv.SabcomAutoJoiner = true
local Players = game:GetService("Players")
game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
game:GetService("UserInputService")
game:GetService("GuiService")
game:GetService("SoundService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local function fn(arg)
	if type(getgenv) == "function" then
		local genv2 = getgenv()

		if type(genv2) == "table" then
			if type(genv2[arg]) == "function" then
				return genv2[arg]
			end
		end
	end

	if type(getfenv) == "function" then
		local ok, result = pcall(function()
			return getfenv()[arg]
		end)

		if ok then
			if type(result) == "function" then
				return result
			end
		end
	end

	local value = rawget(_G, arg)
	if type(value) ~= "function" then
		return nil
	end
	return value
end

local function fn2()
	local queueOnTeleport = fn("queue_on_teleport") or fn("queueonteleport")

	if type(queueOnTeleport) ~= "function" then
		if type(syn) == "table" then
			queueOnTeleport = syn.queue_on_teleport
		end
	end

	if type(queueOnTeleport) ~= "function" then
		if type(fluxus) == "table" then
			queueOnTeleport = fluxus.queue_on_teleport
		end
	end

	if type(queueOnTeleport) ~= "function" then
		return
	end

	pcall(queueOnTeleport, [[task.spawn(function()
    local url = "https://swagfinder.net/api/script/esp"
    local function grab()
        local src
        pcall(function()
            src = game:HttpGet(url)
        end)
        if type(src) ~= "string" or src == "" or string.sub(src, 1, 1) ~= "l" then
            local req = request or http_request
            if type(req) ~= "function" and type(syn) == "table" then
                req = syn.request
            end
            if type(req) ~= "function" and type(http) == "table" then
                req = http.request
            end
            if type(req) == "function" then
                local ok, res = pcall(req, { Url = url, Method = "GET" })
                if ok and type(res) == "table" then
                    src = res.Body or res.body
                end
            end
        end
        if type(src) == "string" and string.sub(src, 1, 1) == "l" then
            return src
        end
        return nil
    end
    for _ = 1, 20 do
        local src = grab()
        if src then
            local loader = loadstring or load
            if type(loader) == "function" then
                local ok, fn = pcall(loader, src)
                if ok and type(fn) == "function" then
                    pcall(fn)
                end
            end
            return
        end
        task.wait(0.5)
    end
end)
]])
end

local function fn3()
	local v2 = loadstring
	if type(v2) ~= "function" then
		return
	end

	local ok, result = pcall(v2, [[task.spawn(function()
    local url = "https://swagfinder.net/api/script/esp"
    local function grab()
        local src
        pcall(function()
            src = game:HttpGet(url)
        end)
        if type(src) ~= "string" or src == "" or string.sub(src, 1, 1) ~= "l" then
            local req = request or http_request
            if type(req) ~= "function" and type(syn) == "table" then
                req = syn.request
            end
            if type(req) ~= "function" and type(http) == "table" then
                req = http.request
            end
            if type(req) == "function" then
                local ok, res = pcall(req, { Url = url, Method = "GET" })
                if ok and type(res) == "table" then
                    src = res.Body or res.body
                end
            end
        end
        if type(src) == "string" and string.sub(src, 1, 1) == "l" then
            return src
        end
        return nil
    end
    for _ = 1, 20 do
        local src = grab()
        if src then
            local loader = loadstring or load
            if type(loader) == "function" then
                local ok, fn = pcall(loader, src)
                if ok and type(fn) == "function" then
                    pcall(fn)
                end
            end
            return
        end
        task.wait(0.5)
    end
end)
]])

	if ok then
		if type(result) == "function" then
			task.spawn(result)
			return
		end
	end
end

fn2()
fn3(v + 177507210)

localPlayer.OnTeleport:Connect(function()
	fn2()
end)

local tbl = {
	usa = { label = "USA", ws = "wss://swagfinder.net/ws", http = "https://swagfinder.net/api/relay" },
	europe = {
		label = "Europe",
		ws = "wss://swag-finder-133576888541.europe-west4.run.app/ws",
		http = "https://swag-finder-133576888541.europe-west4.run.app/api/relay",
	},
}

local n4 = n // 27
local relayRegion = "usa"
local ws = tbl.usa.ws
local http = tbl.usa.http
local fn4 = nil
local v2 = nil
local v3 = nil
local v4 = nil
local fn5 = nil
local fn6 = nil
local fn7 = nil
local v5 = nil

local function fn8()
	local function fn9(arg)
		local genv2

		if type(getgenv) ~= "function" then
			genv2 = genv
		else
			genv2 = getgenv() or genv
		end

		return (string.gsub(tostring(genv2.SwagFinderPayloadSecret or genv2.RELAY_PAYLOAD_SECRET or "ba887f7ec6285ec5ca7027e1d82525f9"), "^%s*(.-)%s*$", "%1"))
	end

	local v6 = fn9(463587733)

	local function fn10(arg)
		return (string.gsub(tostring(arg or ""), "^%s*(.-)%s*$", "%1"))
	end

	local n5 = 365516005

	local function fn11()
		local genv2

		if type(getgenv) ~= "function" then
			genv2 = genv
		else
			genv2 = getgenv() or genv
		end

		local tbl2 = {}
		n5 = 1840853870
		local tbl3 = {}

		local function fn12(arg)
			local v7 = fn10(arg)

			if v7 ~= "" then
				if tbl2[v7] then
					return
				end
				tbl2[v7] = true
				tbl3[#tbl3 + 1] = v7
				return
			end
		end

		fn12(genv2 and genv2.SwagFinderPayloadSecret, 448257445)
		fn12(genv2 and genv2.RELAY_PAYLOAD_SECRET, 448257445)
		fn12(genv.SwagFinderPayloadSecret, 448257445)
		fn12(genv.RELAY_PAYLOAD_SECRET, 448257445)
		fn12(v6, 448257445)
		return tbl3
	end

	fn4 = function()
		local n6 = 491125528
		local n7 = 2372875213
		local genv2

		if type(getgenv) ~= "function" then
			genv2 = genv
		else
			genv2 = getgenv() or genv
		end

		local tbl2 = {}
		local swagFinderKey, scriptKey

		if genv2 then
			swagFinderKey = genv2.SwagFinderKey
			scriptKey = genv2.script_key
			n6 = bit32.band(n6, n7) + 268486672
		else
			swagFinderKey = genv2
			scriptKey = genv2
		end

		local swagFinderKey2 = genv.SwagFinderKey
		local scriptKey2 = genv.script_key
		local value = rawget(_G, "SwagFinderKey")
		local v7 = table.pack(rawget(_G, "script_key"))
		tbl2[1] = swagFinderKey
		tbl2[2] = scriptKey
		tbl2[3] = swagFinderKey2
		tbl2[4] = scriptKey2
		tbl2[5] = value

		do
			local values = table.pack(table.unpack(v7, 1, v7.n))
			table.move(values, 1, values.n, 6, tbl2)
		end

		if type(shared) == "table" then
			table.insert(tbl2, shared.SwagFinderKey)
			table.insert(tbl2, shared.script_key)
		end

		local n8 = 507210176

		local function fn12()
			table.insert(tbl2, script_key)
		end

		n8 = 34899749
		pcall(fn12)

		for _, v8 in ipairs(tbl2) do
			while type(v8) == "string" do
				local v9 = string.gsub(v8, "^%s*(.-)%s*$", "%1")

				if v9 ~= "" then
					if v9 ~= "nil" then
						genv.SwagFinderKey = v9
						genv.script_key = v9

						if type(genv2) == "table" then
							genv2.SwagFinderKey = v9
							genv2.script_key = v9
						end

						if type(_G) == "table" then
							_G.SwagFinderKey = v9
							_G.script_key = v9
						end

						if type(shared) ~= "table" then
							return v9
						end
						shared.SwagFinderKey = v9
						shared.script_key = v9
						return v9
					end

					local v10 = table.pack(V_1())
					if v10[1] then
						v8 = v10[3]
						continue
					end
					return ""
				end

				local v10 = table.pack(V_1())
				if v10[1] then
					v8 = v10[3]
					continue
				end
				return ""
			end
		end

		return ""
	end

	v2 = fn4()
	local v7 = tostring
	local name

	if localPlayer then
		name = localPlayer.Name or ""
	else
		name = ""
	end

	v3 = v7(name)
	local v8 = tostring
	local userId, n6, fn12, fn13, fn14, fn15, n7, fn16

	if localPlayer then
		userId = localPlayer.UserId or ""
	else
		userId = ""
		v4 = v8(userId)
		n6 = 237540407

		fn12 = function(arg)
			local state = 1
			local tbl2, fn17, tbl3, n8, n9, tbl4, v9, tbl5, n10, v10, v11, v12, v13, v14, v15, v16, v17, v18, n11

			while true do
				if state == 1 then
					local v19 = arg
					tbl2 = {}
					local n12 = 833887613 // n6
					tbl2[1] = 1116352408
					tbl2[2] = 1899447441
					tbl2[3] = 3049323471
					tbl2[4] = 3921009573
					tbl2[5] = 961987163
					tbl2[6] = 1508970993
					tbl2[7] = 2453635748
					tbl2[8] = 2870763221
					tbl2[9] = 3624381080
					tbl2[10] = 310598401
					tbl2[11] = 607225278
					tbl2[12] = 1426881987
					tbl2[13] = 1925078388
					tbl2[14] = 2162078206
					tbl2[15] = 2614888103
					tbl2[16] = 3248222580
					tbl2[17] = 3835390401
					tbl2[18] = 4022224774
					tbl2[19] = 264347078
					tbl2[20] = 604807628
					tbl2[21] = 770255983
					tbl2[22] = 1249150122
					tbl2[23] = 1555081692
					tbl2[24] = 1996064986
					tbl2[25] = 2554220882
					tbl2[26] = 2821834349
					tbl2[27] = 2952996808
					tbl2[28] = 3210313671
					tbl2[29] = 3336571891
					tbl2[30] = 3584528711
					tbl2[31] = 113926993
					tbl2[32] = 338241895
					tbl2[33] = 666307205
					tbl2[34] = 773529912
					tbl2[35] = 1294757372
					tbl2[36] = 1396182291
					tbl2[37] = 1695183700
					tbl2[38] = 1986661051
					tbl2[39] = 2177026350
					tbl2[40] = 2456956037
					tbl2[41] = 2730485921
					tbl2[42] = 2820302411
					tbl2[43] = 3259730800
					tbl2[44] = 3345764771
					tbl2[45] = 3516065817
					tbl2[46] = 3600352804
					tbl2[47] = 4094571909
					tbl2[48] = 275423344
					tbl2[49] = 430227734
					tbl2[50] = 506948616
					tbl2[51] = 659060556
					tbl2[52] = 883997877
					tbl2[53] = 958139571
					tbl2[54] = 1322822218
					tbl2[55] = 1537002063
					tbl2[56] = 1747873779
					tbl2[57] = 1955562222
					tbl2[58] = 2024104815
					tbl2[59] = 2227730452
					tbl2[60] = 2361852424
					tbl2[61] = 2428436474
					tbl2[62] = 2756734187
					tbl2[63] = 3204031479
					tbl2[64] = 3329325298

					fn17 = function(arg2, arg3)
						return bit32.bor(bit32.rshift(arg2, arg3), bit32.lshift(arg2, 32 - arg3))
					end

					tbl3 = { string.byte(v19, 1, #v19) }
					n8 = #tbl3 * 8
					table.insert(tbl3, 128)
					state = 2
				elseif state == 2 then
					if #tbl3 % 64 ~= 56 then
						state = 42
					else
						state = 3
					end
				elseif state == 3 then
					n9 = 7
					state = 4
				elseif state == 4 then
					table.insert(tbl3, bit32.band(bit32.rshift(n8, n9 * 8), 255))

					if q_1 <= 0 then
						state = 7
					else
						state = 5
					end
				elseif state == 5 then
					if V_1 <= M_1 then
						state = 6
					else
						state = 8
					end
				elseif state == 6 then
					n9 = V_1
					state = 4
				elseif state == 7 then
					if V_1 >= M_1 then
						state = 41
					else
						state = 8
					end
				elseif state == 8 then
					tbl4 = {
						1779033703,
						3144134277,
						1013904242,
						2773480762,
						1359893119,
						2600822924,
						528734635,
						1541459225,
					}

					if q_1 <= 0 then
						state = 11
					else
						state = 9
					end
				elseif state == 9 then
					if V_1 <= M_1 then
						state = 10
					else
						state = 36
					end
				elseif state == 10 then
					v9 = V_1
					state = 13
				elseif state == 11 then
					if V_1 >= M_1 then
						state = 12
					else
						state = 36
					end
				elseif state == 12 then
					v9 = V_1
					state = 13
				elseif state == 13 then
					tbl5 = {}
					n10 = 0
					state = 14
				elseif state == 14 then
					local n12 = v9 + n10 * 4
					tbl5[n10] = bit32.bor(bit32.lshift(tbl3[n12], 24), bit32.lshift(tbl3[n12 + 1], 16), bit32.lshift(tbl3[n12 + 2], 8), tbl3[n12 + 3])

					if q_2 <= 0 then
						state = 17
					else
						state = 15
					end
				elseif state == 15 then
					if V_2 <= M_2 then
						state = 16
					else
						state = 18
					end
				elseif state == 16 then
					n10 = V_2
					state = 14
				elseif state == 17 then
					if V_2 >= M_2 then
						state = 40
					else
						state = 18
					end
				elseif state == 18 then
					if q_2 <= 0 then
						state = 21
					else
						state = 19
					end
				elseif state == 19 then
					if V_2 <= M_2 then
						state = 20
					else
						state = 27
					end
				elseif state == 20 then
					v10 = V_2
					state = 23
				elseif state == 21 then
					if V_2 >= M_2 then
						state = 22
					else
						state = 27
					end
				elseif state == 22 then
					v10 = V_2
					state = 23
				elseif state == 23 then
					local bxor = bit32.bxor
					tbl5[v10] = bit32.band(tbl5[v10 - 16] + bit32.bxor(fn17(tbl5[v10 - 15], 7, 88829325), fn17(tbl5[v10 - 15], 18, 88829325), bit32.rshift(tbl5[v10 - 15], 3)) + tbl5[v10 - 7] + bxor(fn17(tbl5[v10 - 2], 17, 88829325), fn17(tbl5[v10 - 2], 19, 88829325), bit32.rshift(tbl5[v10 - 2], 10)), 4294967295)

					if q_2 <= 0 then
						state = 26
					else
						state = 24
					end
				elseif state == 24 then
					if V_2 <= M_2 then
						state = 25
					else
						state = 27
					end
				elseif state == 25 then
					v10 = V_2
					state = 23
				elseif state == 26 then
					if V_2 >= M_2 then
						state = 39
					else
						state = 27
					end
				elseif state == 27 then
					v11 = tbl4[1]
					v12 = tbl4[2]
					v13 = tbl4[3]
					v14 = tbl4[4]
					v15 = tbl4[5]
					v16 = tbl4[6]
					v17 = tbl4[7]
					v18 = tbl4[8]
					n11 = 0
					state = 28
				elseif state == 28 then
					local bxor = bit32.bxor
					local v19 = bit32.band(v18 + bit32.bxor(fn17(v15, 6, 88829325), fn17(v15, 11, 88829325), fn17(v15, 25, 88829325)) + bxor(bit32.band(v15, v16), bit32.band(bit32.bnot(v15), v17)) + tbl2[n11 + 1] + tbl5[n11], 4294967295)
					local bxor2 = bit32.bxor
					local band = bit32.band
					local v20 = bit32.band(bit32.bxor(fn17(v11, 2, 88829325), fn17(v11, 13, 88829325), fn17(v11, 22, 88829325)) + bxor2(bit32.band(v11, v12), bit32.band(v11, v13), band(v12, v13)), 4294967295)
					local v21 = bit32.band(v14 + v19, 4294967295)
					v18 = v17
					v14 = v13
					v17 = v16
					v13 = v12
					v16 = v15
					v12 = v11
					v15 = v21
					v11 = bit32.band(v19 + v20, 4294967295)

					if q_2 <= 0 then
						state = 31
					else
						state = 29
					end
				elseif state == 29 then
					if V_2 <= M_2 then
						state = 30
					else
						state = 32
					end
				elseif state == 30 then
					n11 = V_2
					state = 28
				elseif state == 31 then
					if V_2 >= M_2 then
						state = 38
					else
						state = 32
					end
				elseif state == 32 then
					tbl4[1] = bit32.band(tbl4[1] + v11, 4294967295)
					tbl4[2] = bit32.band(tbl4[2] + v12, 4294967295)
					tbl4[3] = bit32.band(tbl4[3] + v13, 4294967295)
					tbl4[4] = bit32.band(tbl4[4] + v14, 4294967295)
					tbl4[5] = bit32.band(tbl4[5] + v15, 4294967295)
					tbl4[6] = bit32.band(tbl4[6] + v16, 4294967295)
					tbl4[7] = bit32.band(tbl4[7] + v17, 4294967295)
					tbl4[8] = bit32.band(tbl4[8] + v18, 4294967295)

					if q_1 <= 0 then
						state = 35
					else
						state = 33
					end
				elseif state == 33 then
					if V_1 <= M_1 then
						state = 34
					else
						state = 36
					end
				elseif state == 34 then
					v9 = V_1
					state = 13
				elseif state == 35 then
					if V_1 >= M_1 then
						state = 37
					else
						state = 36
					end
				elseif state == 36 then
					return string.format("%08x%08x%08x%08x%08x%08x%08x%08x", tbl4[1], tbl4[2], tbl4[3], tbl4[4], tbl4[5], tbl4[6], tbl4[7], tbl4[8])
				elseif state == 37 then
					v9 = V_1
					state = 13
				elseif state == 38 then
					n11 = V_2
					state = 28
				elseif state == 39 then
					v10 = V_2
					state = 23
				elseif state == 40 then
					n10 = V_2
					state = 14
				elseif state == 41 then
					n9 = V_1
					state = 4
				elseif state == 42 then
					table.insert(tbl3, 0)
					state = 2
				end
			end
		end

		n6 = 462802622

		fn5 = function(arg)
			return fn12(arg)
		end

		n5 = bit32.bxor(n5, 298671941)

		fn13 = function(arg)
			return (arg:gsub("..", function(arg2)
				local char = string.char
				local num = tonumber(arg2, 16)
				if num then
					return char(num)
				end
				return char(0)
			end))
		end

		fn6 = function(arg, arg2)
			local n8 = 3734932059
			local n9 = 1347952690
			local str = tostring(arg or "")

			if #str > 64 then
				str = fn13(fn5(str))
			end

			local str2 = str .. string.rep("\0", 64 - #str)
			bit32.bor(n8, 1079311649)
			local tbl2 = {}
			local tbl3 = {}
			local n10 = 1

			while true do
				local v9 = str2:byte(n10)
				tbl2[n10] = string.char(bit32.bxor(v9, 54))
				tbl3[n10] = string.char(bit32.bxor(v9, 92))

				if q_1 <= 0 then
					if V_1 >= M_1 then
						n10 = V_1
						continue
					end
					break
				else
					if V_1 <= M_1 then
						n10 = V_1
						continue
					end
					break
				end
			end

			local v9 = fn5
			local str3 = table.concat(tbl2)
			local v10 = tostring
			local v11 = fn13(v9(str3 .. v10(arg2 or "")))
			return fn5(table.concat(tbl3) .. v11)
		end

		fn7 = function()
			local tbl2 = {}
			local getHwid = genv.get_hwid
			local getHWID_ = genv.getHWID
			local v9 = gethwid
			local v10 = get_hwid
			local v11 = getHWID
			tbl2[1] = genv.gethwid
			tbl2[2] = getHwid
			tbl2[3] = getHWID_
			tbl2[4] = v9
			tbl2[5] = v10
			tbl2[6] = v11

			for _, v12 in ipairs(tbl2) do
				if type(v12) ~= "function" then
					continue
				end
				local ok, result = pcall(v12)

				if ok then
					if result then
						if not (#tostring(result) >= 8) then
							continue
						end
						return fn5("swag-hwid|" .. tostring(result))
					end
				end
			end

			local ok, result = pcall(game.GetService, game, "RbxAnalyticsService")

			if ok then
				if result then
					local ok2, result2 = pcall(function()
						return result:GetClientId()
					end)

					if ok2 then
						if result2 then
							if #tostring(result2) >= 8 then
								return fn5("swag-analytics|" .. tostring(result2))
							end
						end
					end
				end
			end

			return fn5("swag-account|" .. v4)
		end

		fn14 = function(arg, arg2, arg3)
			local str = tostring(arg3 or "")
			local v9 = fn13(tostring(arg2 or ""))

			if str ~= "" then
				if v9 ~= "" then
					if str ~= "" then
						if arg ~= "" then
							local n8 = #str
							local n9 = #v9
							local tbl2 = {}
							local n10 = #arg
							local n11 = 1
							local byte

							if 1 <= 0 then
								if n11 >= n10 then
									while true do
										byte = v9.byte
										tbl2[n11] = string.char(bit32.bxor(arg:byte(n11), str:byte((n11 - 1) % n8 + 1), byte(v9, (n11 - 1) % n9 + 1)))

										if q_1 <= 0 then
											if V_1 >= M_1 then
												n11 = V_1
												continue
											end
											break
										else
											if V_1 <= M_1 then
												n11 = V_1
												continue
											end
											break
										end
									end
								end
							elseif n11 <= n10 then
								while true do
									byte = v9.byte
									tbl2[n11] = string.char(bit32.bxor(arg:byte(n11), str:byte((n11 - 1) % n8 + 1), byte(v9, (n11 - 1) % n9 + 1)))

									if q_1 <= 0 then
										if V_1 >= M_1 then
											n11 = V_1
											continue
										end
										break
									else
										if V_1 <= M_1 then
											n11 = V_1
											continue
										end
										break
									end
								end
							end

							return table.concat(tbl2)
						end
					end

					return ""
				end

				return ""
			end

			return ""
		end

		fn15 = function(arg, arg2, arg3)
			local n8 = 903098526
			local str = tostring(arg3 or "")
			local str2 = tostring(arg2 or "")

			if str ~= "" then
				if str2 ~= "" then
					if arg ~= "" then
						local tbl2 = {}
						local tbl3 = {}
						local n9 = #arg
						local n10 = 1
						local v9, n11, v10, byte

						if 1 <= 0 then
							if n10 >= n9 then
								v9 = n10

								while true do
									n11 = math.floor((v9 - 1) / 32)
									v10 = tbl3[n11]

									if not v10 then
										v10 = fn13(fn5(str .. "\0" .. str2 .. "\0" .. tostring(n11)))
										tbl3[n11] = v10
									end

									byte = v10.byte
									tbl2[v9] = string.char(bit32.bxor(arg:byte(v9), byte(v10, (v9 - 1) % 32 + 1)))

									if q_1 <= 0 then
										if V_1 >= M_1 then
											v9 = V_1
											continue
										end
									elseif V_1 <= M_1 then
										v9 = V_1
										continue
									end

									break
								end
							end
						elseif n10 <= n9 then
							v9 = n10

							while true do
								n11 = math.floor((v9 - 1) / 32)
								v10 = tbl3[n11]

								if v10 then
									byte = v10.byte
									tbl2[v9] = string.char(bit32.bxor(arg:byte(v9), byte(v10, (v9 - 1) % 32 + 1)))

									if q_1 <= 0 then
										if V_1 >= M_1 then
											v9 = V_1
											continue
										end
									elseif V_1 <= M_1 then
										v9 = V_1
										continue
									end

									break
								else
									v10 = fn13(fn5(str .. "\0" .. str2 .. "\0" .. tostring(n11)))
									tbl3[n11] = v10
									byte = v10.byte
									tbl2[v9] = string.char(bit32.bxor(arg:byte(v9), byte(v10, (v9 - 1) % 32 + 1)))

									if q_1 <= 0 then
										if V_1 >= M_1 then
											v9 = V_1
											continue
										end
									elseif V_1 <= M_1 then
										v9 = V_1
										continue
									end

									break
								end
							end
						end

						return table.concat(tbl2)
					end

					return ""
				end

				return ""
			end

			return ""
		end

		n7 = 395122542

		fn16 = function(arg)
			if type(arg) ~= "table" then
				return nil
			end
			local v9 = fn13(tostring(arg.p or ""))

			if v9 ~= "" then
				local num = tonumber(arg.e)

				for _, v10 in ipairs(fn11()) do
					local v11

					if num ~= 3 then
						if num ~= 2 then
							return nil
						end
						v11 = fn14(v9, arg.n, v10)
					else
						local v12 = fn6(v10, "e3|" .. tostring(arg.n) .. "|" .. tostring(arg.p))
						if string.lower(tostring(arg.m or "")) ~= v12 then
							continue
						end
						v11 = fn15(v9, tostring(arg.n), v10)
					end

					local ok, result = pcall(HttpService.JSONDecode, HttpService, v11)

					if ok then
						if type(result) ~= "table" then
							continue
						end

						if result.name then
							return result
						end

						if result.brainrot then
							return result
						end
					end
				end

				return nil
			end

			return nil
		end

		n7 = 135618100
		v5 = fn16
		return
	end

	v4 = v8(userId)
	n6 = 237540407

	fn12 = function(arg)
		local state = 1
		local tbl2, fn17, tbl3, n8, n9, tbl4, v9, tbl5, n10, v10, v11, v12, v13, v14, v15, v16, v17, v18, n11

		while true do
			if state == 1 then
				local v19 = arg
				tbl2 = {}
				local n12 = 833887613 // n6
				tbl2[1] = 1116352408
				tbl2[2] = 1899447441
				tbl2[3] = 3049323471
				tbl2[4] = 3921009573
				tbl2[5] = 961987163
				tbl2[6] = 1508970993
				tbl2[7] = 2453635748
				tbl2[8] = 2870763221
				tbl2[9] = 3624381080
				tbl2[10] = 310598401
				tbl2[11] = 607225278
				tbl2[12] = 1426881987
				tbl2[13] = 1925078388
				tbl2[14] = 2162078206
				tbl2[15] = 2614888103
				tbl2[16] = 3248222580
				tbl2[17] = 3835390401
				tbl2[18] = 4022224774
				tbl2[19] = 264347078
				tbl2[20] = 604807628
				tbl2[21] = 770255983
				tbl2[22] = 1249150122
				tbl2[23] = 1555081692
				tbl2[24] = 1996064986
				tbl2[25] = 2554220882
				tbl2[26] = 2821834349
				tbl2[27] = 2952996808
				tbl2[28] = 3210313671
				tbl2[29] = 3336571891
				tbl2[30] = 3584528711
				tbl2[31] = 113926993
				tbl2[32] = 338241895
				tbl2[33] = 666307205
				tbl2[34] = 773529912
				tbl2[35] = 1294757372
				tbl2[36] = 1396182291
				tbl2[37] = 1695183700
				tbl2[38] = 1986661051
				tbl2[39] = 2177026350
				tbl2[40] = 2456956037
				tbl2[41] = 2730485921
				tbl2[42] = 2820302411
				tbl2[43] = 3259730800
				tbl2[44] = 3345764771
				tbl2[45] = 3516065817
				tbl2[46] = 3600352804
				tbl2[47] = 4094571909
				tbl2[48] = 275423344
				tbl2[49] = 430227734
				tbl2[50] = 506948616
				tbl2[51] = 659060556
				tbl2[52] = 883997877
				tbl2[53] = 958139571
				tbl2[54] = 1322822218
				tbl2[55] = 1537002063
				tbl2[56] = 1747873779
				tbl2[57] = 1955562222
				tbl2[58] = 2024104815
				tbl2[59] = 2227730452
				tbl2[60] = 2361852424
				tbl2[61] = 2428436474
				tbl2[62] = 2756734187
				tbl2[63] = 3204031479
				tbl2[64] = 3329325298

				fn17 = function(arg2, arg3)
					return bit32.bor(bit32.rshift(arg2, arg3), bit32.lshift(arg2, 32 - arg3))
				end

				tbl3 = { string.byte(v19, 1, #v19) }
				n8 = #tbl3 * 8
				table.insert(tbl3, 128)
				state = 2
			elseif state == 2 then
				if #tbl3 % 64 ~= 56 then
					state = 42
				else
					state = 3
				end
			elseif state == 3 then
				n9 = 7
				state = 4
			elseif state == 4 then
				table.insert(tbl3, bit32.band(bit32.rshift(n8, n9 * 8), 255))

				if q_1 <= 0 then
					state = 7
				else
					state = 5
				end
			elseif state == 5 then
				if V_1 <= M_1 then
					state = 6
				else
					state = 8
				end
			elseif state == 6 then
				n9 = V_1
				state = 4
			elseif state == 7 then
				if V_1 >= M_1 then
					state = 41
				else
					state = 8
				end
			elseif state == 8 then
				tbl4 = {
					1779033703,
					3144134277,
					1013904242,
					2773480762,
					1359893119,
					2600822924,
					528734635,
					1541459225,
				}

				if q_1 <= 0 then
					state = 11
				else
					state = 9
				end
			elseif state == 9 then
				if V_1 <= M_1 then
					state = 10
				else
					state = 36
				end
			elseif state == 10 then
				v9 = V_1
				state = 13
			elseif state == 11 then
				if V_1 >= M_1 then
					state = 12
				else
					state = 36
				end
			elseif state == 12 then
				v9 = V_1
				state = 13
			elseif state == 13 then
				tbl5 = {}
				n10 = 0
				state = 14
			elseif state == 14 then
				local n12 = v9 + n10 * 4
				tbl5[n10] = bit32.bor(bit32.lshift(tbl3[n12], 24), bit32.lshift(tbl3[n12 + 1], 16), bit32.lshift(tbl3[n12 + 2], 8), tbl3[n12 + 3])

				if q_2 <= 0 then
					state = 17
				else
					state = 15
				end
			elseif state == 15 then
				if V_2 <= M_2 then
					state = 16
				else
					state = 18
				end
			elseif state == 16 then
				n10 = V_2
				state = 14
			elseif state == 17 then
				if V_2 >= M_2 then
					state = 40
				else
					state = 18
				end
			elseif state == 18 then
				if q_2 <= 0 then
					state = 21
				else
					state = 19
				end
			elseif state == 19 then
				if V_2 <= M_2 then
					state = 20
				else
					state = 27
				end
			elseif state == 20 then
				v10 = V_2
				state = 23
			elseif state == 21 then
				if V_2 >= M_2 then
					state = 22
				else
					state = 27
				end
			elseif state == 22 then
				v10 = V_2
				state = 23
			elseif state == 23 then
				local bxor = bit32.bxor
				tbl5[v10] = bit32.band(tbl5[v10 - 16] + bit32.bxor(fn17(tbl5[v10 - 15], 7, 88829325), fn17(tbl5[v10 - 15], 18, 88829325), bit32.rshift(tbl5[v10 - 15], 3)) + tbl5[v10 - 7] + bxor(fn17(tbl5[v10 - 2], 17, 88829325), fn17(tbl5[v10 - 2], 19, 88829325), bit32.rshift(tbl5[v10 - 2], 10)), 4294967295)

				if q_2 <= 0 then
					state = 26
				else
					state = 24
				end
			elseif state == 24 then
				if V_2 <= M_2 then
					state = 25
				else
					state = 27
				end
			elseif state == 25 then
				v10 = V_2
				state = 23
			elseif state == 26 then
				if V_2 >= M_2 then
					state = 39
				else
					state = 27
				end
			elseif state == 27 then
				v11 = tbl4[1]
				v12 = tbl4[2]
				v13 = tbl4[3]
				v14 = tbl4[4]
				v15 = tbl4[5]
				v16 = tbl4[6]
				v17 = tbl4[7]
				v18 = tbl4[8]
				n11 = 0
				state = 28
			elseif state == 28 then
				local bxor = bit32.bxor
				local v19 = bit32.band(v18 + bit32.bxor(fn17(v15, 6, 88829325), fn17(v15, 11, 88829325), fn17(v15, 25, 88829325)) + bxor(bit32.band(v15, v16), bit32.band(bit32.bnot(v15), v17)) + tbl2[n11 + 1] + tbl5[n11], 4294967295)
				local bxor2 = bit32.bxor
				local band = bit32.band
				local v20 = bit32.band(bit32.bxor(fn17(v11, 2, 88829325), fn17(v11, 13, 88829325), fn17(v11, 22, 88829325)) + bxor2(bit32.band(v11, v12), bit32.band(v11, v13), band(v12, v13)), 4294967295)
				local v21 = bit32.band(v14 + v19, 4294967295)
				v18 = v17
				v14 = v13
				v17 = v16
				v13 = v12
				v16 = v15
				v12 = v11
				v15 = v21
				v11 = bit32.band(v19 + v20, 4294967295)

				if q_2 <= 0 then
					state = 31
				else
					state = 29
				end
			elseif state == 29 then
				if V_2 <= M_2 then
					state = 30
				else
					state = 32
				end
			elseif state == 30 then
				n11 = V_2
				state = 28
			elseif state == 31 then
				if V_2 >= M_2 then
					state = 38
				else
					state = 32
				end
			elseif state == 32 then
				tbl4[1] = bit32.band(tbl4[1] + v11, 4294967295)
				tbl4[2] = bit32.band(tbl4[2] + v12, 4294967295)
				tbl4[3] = bit32.band(tbl4[3] + v13, 4294967295)
				tbl4[4] = bit32.band(tbl4[4] + v14, 4294967295)
				tbl4[5] = bit32.band(tbl4[5] + v15, 4294967295)
				tbl4[6] = bit32.band(tbl4[6] + v16, 4294967295)
				tbl4[7] = bit32.band(tbl4[7] + v17, 4294967295)
				tbl4[8] = bit32.band(tbl4[8] + v18, 4294967295)

				if q_1 <= 0 then
					state = 35
				else
					state = 33
				end
			elseif state == 33 then
				if V_1 <= M_1 then
					state = 34
				else
					state = 36
				end
			elseif state == 34 then
				v9 = V_1
				state = 13
			elseif state == 35 then
				if V_1 >= M_1 then
					state = 37
				else
					state = 36
				end
			elseif state == 36 then
				return string.format("%08x%08x%08x%08x%08x%08x%08x%08x", tbl4[1], tbl4[2], tbl4[3], tbl4[4], tbl4[5], tbl4[6], tbl4[7], tbl4[8])
			elseif state == 37 then
				v9 = V_1
				state = 13
			elseif state == 38 then
				n11 = V_2
				state = 28
			elseif state == 39 then
				v10 = V_2
				state = 23
			elseif state == 40 then
				n10 = V_2
				state = 14
			elseif state == 41 then
				n9 = V_1
				state = 4
			elseif state == 42 then
				table.insert(tbl3, 0)
				state = 2
			end
		end
	end

	n6 = 462802622

	fn5 = function(arg)
		return fn12(arg)
	end

	n5 = bit32.bxor(n5, 298671941)

	fn13 = function(arg)
		return (arg:gsub("..", function(arg2)
			local char = string.char
			local num = tonumber(arg2, 16)
			if num then
				return char(num)
			end
			return char(0)
		end))
	end

	fn6 = function(arg, arg2)
		local n8 = 3734932059
		local n9 = 1347952690
		local str = tostring(arg or "")

		if #str > 64 then
			str = fn13(fn5(str))
		end

		local str2 = str .. string.rep("\0", 64 - #str)
		bit32.bor(n8, 1079311649)
		local tbl2 = {}
		local tbl3 = {}
		local n10 = 1

		while true do
			local v9 = str2:byte(n10)
			tbl2[n10] = string.char(bit32.bxor(v9, 54))
			tbl3[n10] = string.char(bit32.bxor(v9, 92))

			if q_1 <= 0 then
				if V_1 >= M_1 then
					n10 = V_1
					continue
				end
				break
			else
				if V_1 <= M_1 then
					n10 = V_1
					continue
				end
				break
			end
		end

		local v9 = fn5
		local str3 = table.concat(tbl2)
		local v10 = tostring
		local v11 = fn13(v9(str3 .. v10(arg2 or "")))
		return fn5(table.concat(tbl3) .. v11)
	end

	fn7 = function()
		local tbl2 = {}
		local getHwid = genv.get_hwid
		local getHWID_ = genv.getHWID
		local v9 = gethwid
		local v10 = get_hwid
		local v11 = getHWID
		tbl2[1] = genv.gethwid
		tbl2[2] = getHwid
		tbl2[3] = getHWID_
		tbl2[4] = v9
		tbl2[5] = v10
		tbl2[6] = v11

		for _, v12 in ipairs(tbl2) do
			if type(v12) ~= "function" then
				continue
			end
			local ok, result = pcall(v12)

			if ok then
				if result then
					if not (#tostring(result) >= 8) then
						continue
					end
					return fn5("swag-hwid|" .. tostring(result))
				end
			end
		end

		local ok, result = pcall(game.GetService, game, "RbxAnalyticsService")

		if ok then
			if result then
				local ok2, result2 = pcall(function()
					return result:GetClientId()
				end)

				if ok2 then
					if result2 then
						if #tostring(result2) >= 8 then
							return fn5("swag-analytics|" .. tostring(result2))
						end
					end
				end
			end
		end

		return fn5("swag-account|" .. v4)
	end

	fn14 = function(arg, arg2, arg3)
		local str = tostring(arg3 or "")
		local v9 = fn13(tostring(arg2 or ""))

		if str ~= "" then
			if v9 ~= "" then
				if str ~= "" then
					if arg ~= "" then
						local n8 = #str
						local n9 = #v9
						local tbl2 = {}
						local n10 = #arg
						local n11 = 1
						local byte

						if 1 <= 0 then
							if n11 >= n10 then
								while true do
									byte = v9.byte
									tbl2[n11] = string.char(bit32.bxor(arg:byte(n11), str:byte((n11 - 1) % n8 + 1), byte(v9, (n11 - 1) % n9 + 1)))

									if q_1 <= 0 then
										if V_1 >= M_1 then
											n11 = V_1
											continue
										end
										break
									else
										if V_1 <= M_1 then
											n11 = V_1
											continue
										end
										break
									end
								end
							end
						elseif n11 <= n10 then
							while true do
								byte = v9.byte
								tbl2[n11] = string.char(bit32.bxor(arg:byte(n11), str:byte((n11 - 1) % n8 + 1), byte(v9, (n11 - 1) % n9 + 1)))

								if q_1 <= 0 then
									if V_1 >= M_1 then
										n11 = V_1
										continue
									end
									break
								else
									if V_1 <= M_1 then
										n11 = V_1
										continue
									end
									break
								end
							end
						end

						return table.concat(tbl2)
					end
				end

				return ""
			end

			return ""
		end

		return ""
	end

	fn15 = function(arg, arg2, arg3)
		local n8 = 903098526
		local str = tostring(arg3 or "")
		local str2 = tostring(arg2 or "")

		if str ~= "" then
			if str2 ~= "" then
				if arg ~= "" then
					local tbl2 = {}
					local tbl3 = {}
					local n9 = #arg
					local n10 = 1
					local v9, n11, v10, byte

					if 1 <= 0 then
						if n10 >= n9 then
							v9 = n10

							while true do
								n11 = math.floor((v9 - 1) / 32)
								v10 = tbl3[n11]

								if not v10 then
									v10 = fn13(fn5(str .. "\0" .. str2 .. "\0" .. tostring(n11)))
									tbl3[n11] = v10
								end

								byte = v10.byte
								tbl2[v9] = string.char(bit32.bxor(arg:byte(v9), byte(v10, (v9 - 1) % 32 + 1)))

								if q_1 <= 0 then
									if V_1 >= M_1 then
										v9 = V_1
										continue
									end
								elseif V_1 <= M_1 then
									v9 = V_1
									continue
								end

								break
							end
						end
					elseif n10 <= n9 then
						v9 = n10

						while true do
							n11 = math.floor((v9 - 1) / 32)
							v10 = tbl3[n11]

							if v10 then
								byte = v10.byte
								tbl2[v9] = string.char(bit32.bxor(arg:byte(v9), byte(v10, (v9 - 1) % 32 + 1)))

								if q_1 <= 0 then
									if V_1 >= M_1 then
										v9 = V_1
										continue
									end
								elseif V_1 <= M_1 then
									v9 = V_1
									continue
								end

								break
							else
								v10 = fn13(fn5(str .. "\0" .. str2 .. "\0" .. tostring(n11)))
								tbl3[n11] = v10
								byte = v10.byte
								tbl2[v9] = string.char(bit32.bxor(arg:byte(v9), byte(v10, (v9 - 1) % 32 + 1)))

								if q_1 <= 0 then
									if V_1 >= M_1 then
										v9 = V_1
										continue
									end
								elseif V_1 <= M_1 then
									v9 = V_1
									continue
								end

								break
							end
						end
					end

					return table.concat(tbl2)
				end

				return ""
			end

			return ""
		end

		return ""
	end

	n7 = 395122542

	fn16 = function(arg)
		if type(arg) ~= "table" then
			return nil
		end
		local v9 = fn13(tostring(arg.p or ""))

		if v9 ~= "" then
			local num = tonumber(arg.e)

			for _, v10 in ipairs(fn11()) do
				local v11

				if num ~= 3 then
					if num ~= 2 then
						return nil
					end
					v11 = fn14(v9, arg.n, v10)
				else
					local v12 = fn6(v10, "e3|" .. tostring(arg.n) .. "|" .. tostring(arg.p))
					if string.lower(tostring(arg.m or "")) ~= v12 then
						continue
					end
					v11 = fn15(v9, tostring(arg.n), v10)
				end

				local ok, result = pcall(HttpService.JSONDecode, HttpService, v11)

				if ok then
					if type(result) ~= "table" then
						continue
					end

					if result.name then
						return result
					end

					if result.brainrot then
						return result
					end
				end
			end

			return nil
		end

		return nil
	end

	n7 = 135618100
	v5 = fn16
end

fn8(n4 + 81553006)
local n5 = v - n4
local n6 = n3 + n4 + 73518622

if not WebSocket.connect then
	if not WebSocket.Connect then
		local connect, connect2

		if syn.websocket then
			if not syn.websocket.connect then
				if not syn.websocket.Connect then
					if Krnl.WebSocket then
						local connect3 = Krnl.WebSocket.connect

						if not connect3 then
							local connect4 = Krnl.WebSocket.Connect

							if not connect4 then
								connect = websocket.connect

								if not connect then
									connect2 = websocket.Connect

									if connect2 then
									end
								end
							end
						end
					else
						connect = websocket.connect

						if not connect then
							connect2 = websocket.Connect

							if connect2 then
							end
						end
					end
				end
			end
		elseif Krnl.WebSocket then
			if not Krnl.WebSocket.connect then
				if not Krnl.WebSocket.Connect then
					connect = websocket.connect

					if not connect then
						connect2 = websocket.Connect

						if connect2 then
						end
					end
				end
			end
		elseif not websocket.connect then
			if websocket.Connect then
			end
		end
	end
end

if syn.request then
end

local v6 = nil
local v7 = nil

local function fn9()
	local n7 = 237005093

	local function fn10()
		local flag = type(writefile) == "function"
		if flag then
			return type(readfile) == "function"
		end
		return flag
	end

	local function fn11(arg, arg2)
		if type(arg) ~= "string" then
			return nil
		end

		if arg ~= "" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, arg)

			if arg2 + 414178051 ~= 482430796 then
				if ok then
					if type(result) == "table" then
						return result
					end
				end
			else
				bit32.bxor(arg2, 2006431197)

				if ok then
					if type(result) == "table" then
						return result
					end
				end
			end

			return nil
		end

		return nil
	end

	local n8 = 312977146
	n7 = 161845021

	local function fn12()
		if fn10() then
			local ok, result = pcall(readfile, "swagfinder/autojoiner.json")
			if ok then
				return fn11(result, 173752003)
			end
			local ok2, result2 = pcall(readfile, "sabcom-autojoiner.json")
			if ok2 then
				return fn11(result2, 173752003)
			end
			return nil
		end

		return nil
	end

	n8 = 424124010
	v6 = fn12
	local n9 = 466519529

	local function fn13(arg)
		if fn10() then
			local ok, result = pcall(HttpService.JSONEncode, HttpService, arg)

			if ok then
				if type(result) ~= "string" then
					return false
				end

				pcall(function()
					if type(isfolder) == "function" then
						if type(makefolder) == "function" then
							if not isfolder("swagfinder") then
								makefolder("swagfinder")
								return
							end
						end
					end
				end)

				local ok2 = pcall(writefile, "swagfinder/autojoiner.json", result)
				if ok2 then
					return ok2
				end
				return (pcall(writefile, "sabcom-autojoiner.json", result))
			end

			return false
		end

		return false
	end

	n9 = 116485997
	v7 = fn13
end

fn9(457496131)
local tbl2 = {}
local tbl3 = {}
local v8 = v6()
local v9, config

if type(v8) ~= "table" then
	if type(genv.SabcomJoinSettings) == "table" then
		tbl2 = genv.SabcomJoinSettings
	end

	local flag = type(genv.SabcomJoinConfig) == "table"
	local v10 = table.pack(bit32.band(n6, 4294967295))
	local v11 = table.pack(bit32.band(v10[1], 65535))
	local n7 = 4165085035 + bit32.band(16810 * v11[1] + bit32.lshift(bit32.band(16810 * bit32.rshift(v10[1], 16) + 4100 * v11[1], 65535), 16), 4294967295)
	local v12 = table.pack(bit32.band(sabcomAutoJoinerGen, 4294967295))
	local v13 = table.pack(bit32.band(v12[1], 65535))
	local v14 = bit32.band(16809 * v13[1] + bit32.lshift(bit32.band(16809 * bit32.rshift(v12[1], 16) + 4100 * v13[1], 65535), 16), 4294967295)
	local v15 = table.pack(bit32.band(bit32.bor(n6, sabcomAutoJoinerGen), 4294967295))
	local v16 = table.pack(bit32.band(v15[1], 65535))
	local v17 = bit32.band(31918 * v16[1] + bit32.lshift(bit32.band(31918 * bit32.rshift(v15[1], 16) + 57335 * v16[1], 65535), 16), 4294967295)
	local v18 = table.pack(bit32.band(bit32.bxor(564815137, sabcomAutoJoinerGen), 4294967295))
	local v19 = table.pack(bit32.band(v18[1], 65535))
	local n8 = n7 + v14 + v17 + bit32.band(16809 * v19[1] + bit32.lshift(bit32.band(16809 * bit32.rshift(v18[1], 16) + 4100 * v19[1], 65535), 16), 4294967295)

	if flag then
		tbl3 = genv.SabcomJoinConfig
	end

	n6 = n8 + 129882261
	v9 = tbl2
	config = tbl3
else
	if type(v8.settings) ~= "table" then
		local autoJoin = v8.autoJoin
		local v10 = bit32.rshift(n4, 14)

		if autoJoin ~= nil then
			tbl2 = v8
		elseif v8.forceAttempts ~= nil then
			tbl2 = v8
		end

		n4 = v10 + 142052099
	else
		tbl2 = v8.settings
	end

	if type(v8.filters) ~= "table" then
		if type(v8.config) ~= "table" then
			v9 = tbl2
			config = tbl3
		else
			v9 = tbl2
			config = v8.config
		end
	else
		v9 = tbl2
		config = v8.filters
	end
end

genv.SabcomJoinSettings = v9
genv.SabcomJoinConfig = config

local function fn10(arg, arg2, arg3)
	local v10 = v9[arg]

	if arg3 ~= 456450757 then
		bit32.bxor(arg3, 2034821231)

		if v10 == nil then
			v9[arg] = arg2
		end
	elseif v10 == nil then
		v9[arg] = arg2
		return v9[arg]
	end

	return v9[arg]
end

local n7 = 61825022
local flag = fn10("autoJoin", false, n7 + 394625735) == true
fn10("hideTeleportError", true, 456450757)
local v10 = bit32.bxor(n6, 983468004)
local forceAttempts = fn10("forceAttempts", 280, v10)

if forceAttempts ~= "inf" then
	if forceAttempts ~= math.huge then
		if tonumber(forceAttempts) then
		end
	end
end

fn10("spamForce", false, 456450757)
fn10("preemptNewest", true, 456450757)
local v11 = bit32.bxor(n6, 983468004)
fn10("soundOnFind", true, v11)
fn10("showHiddenCount", false, n7 + 394625735)
fn10("streamSafe", false, n4 + 314389988)
local v12 = tostring
local v13 = bit32.bxor(n6, 983468004)
local soundId = fn10("soundId", "9046615797", v13)
v12(soundId)
local flag2 = fn10("backgroundBlur", true, n7 + 394625735) ~= false

local function fn11(arg, arg2, arg3)
	local str = tostring(fn10(arg, arg2, 456450757))
	local v14 = pcall
	local n8 = 277935954

	local function fn12()
		local v15 = Enum.KeyCode[str]
		n8 = 1736065503
		return v15
	end

	local v15 = bit32.bxor(arg3, 295725848)
	n8 = bit32.bxor(277935954, v15)
	local v16, v17 = v14(fn12)

	if v16 then
		if typeof(v17) == "EnumItem" then
			return v17
		end
	end

	return Enum.KeyCode[arg2]
end

local tbl4 = {}
local v14 = bit32.bxor(n6, 820707797)
tbl4.toggleUi = fn11("bindToggleUi", "RightShift", v14)
tbl4.cancelJoin = fn11("bindCancelJoin", "RightAlt", 289498356)
tbl4.clearFeed = fn11("bindClearFeed", "Delete", n4 - 4147529709)

local function fn12(arg)
	local n8 = 3367592434
	local n9 = 1723053966
	local lower = string.lower
	local v15 = tostring
	arg = arg or "usa"
	local exitTo = nil

	while true do
		local v16 = table.pack(v15(arg))
		v15 = table.pack(table.unpack(v16, 1, v16.n))
		lower = lower(table.unpack(v16, 1, v16.n))

		if lower ~= "us" then
			if lower ~= "us" then
				exitTo = 1
				break
			end
		else
			break
		end
	end

	if exitTo == 1 then
		if lower ~= "united states" then
			if lower ~= "es" then
				if lower ~= "espana" then
					if lower ~= "españa" then
						if lower ~= "in" then
							if lower ~= "kr" then
								local n10 = n8 - n9

								if lower ~= "south korea" then
									if lower ~= "seoul" then
										if lower ~= "tx" then
											if lower ~= "texas" then
												if lower ~= "us-south" then
													if lower ~= "nl" then
														if lower ~= "holland" then
															if lower ~= "amsterdam" then
																if lower ~= "swag-finder" then
																	if lower ~= "swagfinder" then
																		if lower == "eu" then
																			lower = "europe"
																		end
																	else
																		lower = "europe"
																	end
																else
																	lower = "europe"
																end
															else
																lower = "netherlands"
															end
														else
															lower = "netherlands"
														end
													else
														lower = "netherlands"
													end
												else
													lower = "dallas"
												end
											else
												lower = "dallas"
											end
										else
											lower = "dallas"
										end
									else
										lower = "korea"
									end
								else
									lower = "korea"
								end
							else
								lower = "korea"
							end
						else
							lower = "india"
						end
					else
						lower = "spain"
					end
				else
					lower = "spain"
				end
			else
				lower = "spain"
			end
		else
			lower = "usa"
		end
	else
		lower = "usa"
	end

	local v16 = tbl[lower]
	bit32.bor(n9, 624571326)
	if v16 then
		return lower
	end
	return "usa"
end

local function fn13(arg)
	relayRegion = fn12(arg)
	v9.relayRegion = relayRegion
	local v15 = tbl[relayRegion]
	ws = v15.ws
	http = v15.http
end

local relayRegion2 = fn10("relayRegion", "usa", 456450757)
fn13(relayRegion2)
local n8 = n7 - n4
local n9 = n6 + 103223329
local flag3 = true

local function fn14()
	local v15 = flag3
	if flag3 then
		return genv.SabcomAutoJoinerGen == sabcomAutoJoinerGen2
	end
	return v15
end

local tbl5 = {}
local v15 = table.pack(bit32.band(n4, 4294967295))
local v16 = table.pack(bit32.band(n9, 4294967295))
local v17 = table.pack(bit32.band(v15[1], 65535))
local v18 = table.pack(bit32.rshift(v15[1], 16))
local v19 = table.pack(bit32.band(v16[1], 65535))
bit32.band(v17[1] * v19[1] + bit32.lshift(bit32.band(v17[1] * bit32.rshift(v16[1], 16) + v18[1] * v19[1], 65535), 16), 4294967295)
tbl5[1] = "Bacuru and Egguru"
tbl5[2] = "Bananito"
tbl5[3] = "Baskito"
tbl5[4] = "Camera Ramena"
tbl5[5] = "Capitano Gullini"
tbl5[6] = "Chicleteira Cupideira"
tbl5[7] = "Chicleteira Noelteira"
tbl5[8] = "Chimnino"
tbl5[9] = "Churrito Bunnito"
tbl5[10] = "Cigno Fulgoro"
tbl5[11] = "Craburger"
tbl5[12] = "DJ Panda"
tbl5[13] = "John Doe"
tbl5[14] = "La Grande Combinasion"
tbl5[15] = "Los 25"
tbl5[16] = "Los 67"
tbl5[17] = "Los Candies"
tbl5[18] = "Los Combinasionas"
tbl5[19] = "Los Mobilis"
tbl5[20] = "Los Sweethearts"
tbl5[21] = "Mariachi Corazoni"
tbl5[22] = "Mieteteira Bicicleteira"
tbl5[23] = "Noo my Gold"
tbl5[24] = "Noo my Heart"
tbl5[25] = "Octoball"
tbl5[26] = "Rocketini Frostini"
tbl5[27] = "Snailo Clovero"
tbl5[28] = "Spaghetti Tualetti"
tbl5[29] = "Spinny Hammy"
tbl5[30] = "Sushi Inu"
tbl5[31] = "Swag Soda"
tbl5[32] = "Swaggy Bros"
tbl5[33] = "Tacorillo Crocodillo"
tbl5[34] = "Chicleteira Surfeiteira"
tbl5[35] = "Girafini Raftini"
tbl5[36] = "Ganganzelli Trulala"
tbl5[37] = "Avocadorilla"
tbl5[38] = "Brutto Gialutto"
tbl5[39] = "Zombie Tralala"
tbl5[40] = "Vulturino Skeletono"
tbl5[41] = "Wheelchair Granny"
tbl5[42] = "Yess my examine"
tbl5[43] = "Trenostruzzo Turbo 4000"
tbl5[44] = "Trickolino"
tbl5[45] = "Tripitio Tralaleritos"
tbl5[46] = "Triplito Tralaleritos"
tbl5[47] = "Tung Tung Tung Sahur"
tbl5[48] = "To to to Sahur"
tbl5[49] = "Torrtuginni Dragonfrutini"
tbl5[50] = "Strawberrita"
tbl5[51] = "Telemorte"
tbl5[52] = "Tenini Ballini"
tbl5[53] = "Serafinna Medusella"
tbl5[54] = "Sand Sand Sand"
tbl5[55] = "Santa Hotspot"
tbl5[56] = "Santteo"
tbl5[57] = "Secret Lucky Block"
tbl5[58] = "Sammyini Spyderini"
tbl5[59] = "Sammyni Spyderini"
tbl5[60] = "Quesadilla Crocodila"
tbl5[61] = "Quesadillo Vampiro"
tbl5[62] = "Rang Ring Bus"
tbl5[63] = "Reindeer Tralala"
tbl5[64] = "Pot Hotspot"
tbl5[65] = "Pot Pumpkin"
tbl5[66] = "Pumpkin Spyderini"
tbl5[67] = "Pumpkini Spyderini"
tbl5[68] = "Please my Present"
tbl5[69] = "Paradiso Axolottino"
tbl5[70] = "Perrito Burrito"
tbl5[71] = "Pirulito Bicicleteira"
tbl5[72] = "Pirulitoita Bicicleteira"
tbl5[73] = "Noo my examine"
tbl5[74] = "Noo my Present"
tbl5[75] = "Noo my Resume"
tbl5[76] = "Nooo My Hotspot"
tbl5[77] = "Naughty Naughty"
tbl5[78] = "Noo my Candy"
tbl5[79] = "Noo my Eggs"
tbl5[80] = "Love Love Love Sahur"
tbl5[81] = "Luck Luck Luck Sahur"
tbl5[82] = "Mi Gatito"
tbl5[83] = "Los Spyderinis"
tbl5[84] = "Los Tortus"
tbl5[85] = "Los Tralaleritos"
tbl5[86] = "Los Trios"
tbl5[87] = "Los Jobcitos"
tbl5[88] = "Los Karkeritos"
tbl5[89] = "Los Matteos"
tbl5[90] = "Los Mi Gatitos"
tbl5[91] = "Los Nooo My Hotspotsitos"
tbl5[92] = "Los Quesadillas"
tbl5[93] = "Los Cucarachas"
tbl5[94] = "Los Bunitos"
tbl5[95] = "Los Burritos"
tbl5[96] = "Los Chicleiras"
tbl5[97] = "Los Chicleteiras"
tbl5[98] = "Las Vaquitas Saturnitas"
tbl5[99] = "Lavadarito Spinito"
tbl5[100] = "Lavadorito Spinito"
upv104.match = "GetService"
error("devirt: corrupt/encrypted register index 1734 (at 190:1478)")