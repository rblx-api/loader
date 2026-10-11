-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime1(...)
	error("Luraph runtime function, not devirtualized")
end

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
tbl5[v3[fn2("-\187\163M\25\167\217@", 4026654723750)]] = "961739126e147c6fe65a84672843de28"
tbl5[v3[fn2("|\153\251\252\129+\213c\238\189\31]\198", 318911054121)]] = "0014"
tbl5[v3[fn2("\255u\7\188", 2453574945005)]] = "anti tp bat"

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
local v43 = syn
local v44

if v43 then
	v44 = syn[v3[fn2("Z\185\149\247\174\30\161\141\220", 26705847902503)]] and syn[v3[fn2("\137ҫ\217\r2\137v\146", 25551540215028)]][v3[fn2("fӟ\144\186|\152", 30015221198129)]]
else
	v44 = v43
end

local fn5

if v44 then
	fn5 = v44
else
	fn5 = WebSocket and WebSocket[v3[fn2("\202Be\155Q\245>", 758084862658)]]
end

fn5 = fn5 or WebsocketClient and function(arg)
	local v45 = WebsocketClient[v3[fn2("\188m\224", 16394390485924)]](arg)
	v45:Connect()
	return v45
end

local fn6 = nil

fn6 = function(arg)
	local tbl10 = {}

	for k, v45 in v40(arg) do
		local n7 = #tbl10 + 1
		local v46 = v3[fn2("'\200\247\146 \170_\227", 34886936526570)]
		local v47 = v3
		local flag10 = v39(v45) == v47[fn2("\20/x-\133", 7497094208326)] and fn6(v45)

		if not flag10 then
			local v48 = v3
			flag10 = v3[fn2("=", 18649317131224)] .. v45 .. v48[fn2("Z", 173951484066)]
		end

		tbl10[n7] = v36(v46, k, flag10)
	end

	return v3[fn2("i", 24314551883892)] .. v37(v38(tbl10), 0, -2) .. v3[fn2("\194", 22373167419748)]
end

local function fn7(arg)
	local function fn8(arg2)
		if arg2 == v3[fn2(",\196P\\", 10051603965073)] then
			if flag8 then
				local v45 = v3
				v30(v3[fn2("\188", 31749367165824)] .. os[v3[fn2("\0302\18I\236", 28036254623230)]]() .. v45[fn2("]F\213\251\200_\178F\20\156:\132P\20@C\245\5rT\147\137\228\134\r\254\141{\211", 1801793767054)])
			end

			arg[v3[fn2(",\186lJ\254\246p\224", 16202184833777)]] = tick()
			return
		end

		local v45 = v3
		local v46 = string[v3[fn2("\159\11\208\29\209", 9071247761664)]](arg2, v45[fn2("\188\201\31<\247\150\244\169-\6\18", 23326679258332)])

		if flag8 then
			local v47 = v3
			v30(v3[fn2("\7", 33022863833122)] .. os[v3[fn2("\127>\184\15\133", 17304951340788)]]() .. v3[fn2("\1651f.\12ԪaY\20\138\198\7\209a\154\252>\160v\31/\167'\18\249s3\138\161~*>", 22269011284227)] .. arg2 .. v47[fn2(" ", 17028991270387)])
		end

		if v46 then
			local v47 = arg[v3[fn2("Ƣn!\210\2\204y", 20264274119096)]][v46 + 0]
			local v48 = v3
			v47:Fire(arg2:gsub(v3[fn2("2\186\6u\237\151?\157\214\218\26", 16177488018138)], v48[fn2("", 19126073050516)]))
			return v47:Destroy()
		end

		return arg[v3[fn2("\222Jͮlw\170\t\1\159\242Xx\250i", 33181782472886)]]:Fire(arg2)
	end

	local fn9 = nil

	fn9 = function()
		if flag8 then
			local v45 = v3
			v30(v3[fn2("\20", 25372219857997)] .. os[v3[fn2("\31\244\136j\213", 5980924483010)]]() .. v45[fn2("\245\140.:\174\129O1!\183\\", 29455784635176)])
		end

		arg[v3[fn2("\154p\255\171h\15\253<\144\234\187\20\22\154\6", 7238314531413)]] = false

		if arg[v3[fn2("\150\184\188@_\170\153\19\224ڥ5", 8969239175329)]] or flag9 then
			if flag8 then
				v30(v3[fn2("\215̡\147q1\177\167\170\11O\146&\250\134\170g|", 12225997515898)])
			end

			return
		end

		local n7 = 0
		local v45

		while true do
			if flag8 then
				local v46 = v3
				v30(v3[fn2("\8", 25877967691300)] .. os[v3[fn2("\242\131\241\176\153", 32213237790000)]]() .. v46[fn2("\158\5\232\183M\152\162w\231Y\191\203\31\168H\18Cu\188<\171s\200\226N\20\133\25n\255\209ȴV\192\30ǁv", 28825478949085)])
			end

			local v46 = v24()
			local flag10 = false
			local v47 = nil
			v45 = nil

			v27(function()
				local v48, v49 = v15(fn5, arg[v3[fn2("\23\20\24", 29848786136214)]])
				v47 = v48
				v45 = v49
				flag10 = true
			end)

			while not flag10 and v24() < v46 + 8 do
				v41()
			end

			if flag8 then
				local v48 = v3
				v30(v3[fn2("\128", 29034864994720)] .. os[v3[fn2("\175\nP\245\156", 12251768106130)]]() .. v3[fn2("z\24ث\148\2523\254\223\1\222Q\227{\241\197\249\\\11_h\181", 34490713701753)] .. v32(flag10) .. v3[fn2("\127\132\31\28g\n", 10375883892159)] .. v32(v47) .. v48[fn2("\12", 27328637166443)])
			end

			if not flag10 then
				flag6 = false
				n7 = 10

				if flag8 then
					warn(v3[fn2("\226\255\210W,\15\226\250ESIn\195\237\222O\184\158,R\173\222\226\25\17\167\176R\229\224\251", 13362051035292)])
				end
			end

			if not v47 then
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
			local v46 = v3
			v30(v3[fn2("\194", 33361102829917)] .. os[v3[fn2("nG\178p\189", 1458185897294)]]() .. v46[fn2("\148\235A|\17\230\0113\2209x\22|\149\178\167\141\242\182\164\19x\130\238", 2558804855119)])
		end

		arg[v3[fn2("\204*c\136֯\156\235c\228#\163\143\18\204", 14980229346943)]] = true
		arg[v3[fn2("\196\28p0\225\186\219]\246", 13544592716102)]] = v45
		flag6 = arg
		local v46 = v3

		v45:Send(fn6({
			[v3[fn2("\144\157\26\202J\143", 30815183269914)]] = v46[fn2("\158\177\19U", 18578448008086)],
			[v3[fn2("\222U\224\t", 256632127727)]] = {},
		}))

		v15(function()
			v45[v3[fn2("k(\166.\2433M", 11661192079980)]]:Connect(fn9)
			v45[v3[fn2("\15\210\249~|\227\202\248q", 12796171824781)]]:Connect(fn8)
		end)

		v15(function()
			v45[v3[fn2(" URU\22\156\133D\244\18\140\156u\238\15*", 31006315147468)]]:Connect(fn9)
			v45[v3[fn2("v\150P\222B\136';\166\162\1439", 3526275763412)]]:Connect(fn8)
		end)
	end

	v15(function()
		local v45 = v3
		arg[v3[fn2("\0Q8\178\17K1\246R", 27593859490914)]][v45[fn2("Q\211s\145*Q?", 8519327620862)]]:Connect(fn9)
		local v46 = v3
		arg[v3[fn2("\197,r \183r\1669N", 8460270018247)]][v46[fn2("Ó@Qd\143\153|\223", 32507452028482)]]:Connect(fn8)
	end)

	v15(function()
		local v45 = v3
		arg[v3[fn2("\29i\"\207\r\254\208\235\162", 33601628338749)]][v45[fn2("\127\0\163\179\239\249y\205g\245RE", 27001135915578)]]:Connect(fn8)
		local v46 = v3
		arg[v3[fn2("Z_\28\178_Aͣ8", 23336343229669)]][v46[fn2("h\177\227\15\189\1384\185\128\r\248H7\209\205\244", 11453953583531)]]:Connect(fn9)
	end)

	arg[v3[fn2("U0\18973y\172\177", 26105607905016)]] = tick()

	while v41(10) do
		if flag8 then
			local v45 = v3
			v30(v3[fn2("\145", 14951237432932)] .. os[v3[fn2("\2286\234N\229", 22975554966421)]]() .. v45[fn2("ח\31]\186]\218A}\226[{\251\17t\146էړg\20\toć:\170", 14658096969043)])
		end

		if arg[v3[fn2("\200tK\173\215\207e8\175\212\11Or\171\158", 15693215676695)]] then
			local v45 = v3

			arg[v3[fn2("t\168\177Eņ\218\30\232", 31886810313728)]]:Send(fn6({
				[v3[fn2("+\30H\139\251Z", 29989450607897)]] = v45[fn2("\234\23\201\8", 21721386241797)],
				[v3[fn2("\227o\137\144", 9220502430091)]] = {},
			}))

			if tick() - arg[v3[fn2("\161\183W҉G\174\t", 26743430013258)]] > 20 then
				if flag8 then
					local v46 = v3
					v30(v3[fn2("=", 25162833812362)] .. os[v3[fn2("\2501\245\132\"", 26944225862149)]]() .. v46[fn2("\240\161\251\171\150\228~\247ֶ\166T\188\2\n\31\4\nlA!\3P\242", 20296487356886)])
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
	local v45 = v24()
	local flag10 = false
	local v46 = nil
	local v47 = nil

	v27(function()
		local v48, v49 = v15(fn5, arg2)
		v46 = v48
		v47 = v49
		flag10 = true
	end)

	while not flag10 and v24() < v45 + 8 do
		v41()
	end

	if not flag10 then
		flag6 = false
		error(v3[fn2("\184y\139\177~s\r\17\174\255$3ٲv\2472N_\151S\1428", 21285433757039)])
	end

	assert(v46, v47)
	arg[v3[fn2("\232\nl\8\221\198\244\158\162", 15444099971119)]] = v47
	arg[v3[fn2("\212\216b", 32886494459811)]] = arg2
	local v48 = v3
	arg[v3[fn2("\154\254+\5n)\173\161d\163\227\187\2262\186", 7107314031067)]] = Instance[v3[fn2("f̜", 13855987348072)]](v48[fn2("\12\2423\140\203\204q\2223\23\184\t\169", 19879862814802)])
	local v49 = v3
	arg[v3[fn2("\246M\198tb߸\2464", 4490525347926)]] = arg[v3[fn2(">RVz5\150\2A\180;\184ķ\181\202", 26856176345523)]][v49[fn2(">4z\139p", 25648179928398)]]
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
		local v45 = v3
		v30(v3[fn2("v", 34172876422225)] .. os[v3[fn2("\1532\200F\140", 32307729954184)]]() .. v3[fn2("O\221\216+\241\133\255\226;\180\16\22\27\253\203\u{58C}\246l\7\148o\130TO\4\nO\140\200\0u?\140u\183\132J\245hS\144\30<\219\3", 4505558192228)] .. v32(arg[v3[fn2("\239調\168\155^Q\134(\151\189m\150\196", 22259347312890)]]) .. v45[fn2("\200", 12545982344612)])
	end

	local n7 = 0

	while not arg[v3[fn2("\214\240x\235\156NC\182\231{\193cx\215d", 1803941316240)]] do
		n7 += 1
		v41(0.1)

		if n7 > 40 then
			if flag8 then
				warn(v3[fn2("\1950\131r\170\212EȪ\218Bil", 4536697655425)])
			end

			flag6 = false
			return v3[fn2("", 22063920336964)]
		end
	end

	if flag8 then
		local v45 = v3
		v30(v3[fn2("Y", 27805393085735)] .. os[v3[fn2("\207\199us@", 9663971337000)]]() .. v45[fn2("bp\228\206D\24\1659\145\143\129bc\145\235\171\\\3\127[\2340x\247[\199GvH\160Q\147?\225̣w\tC", 19677993191318)])
	end

	local v45 = math[v3[fn2("\158\226\202\\\232\159", 458501751211)]](1, 99999999)
	local v46 = v3
	local v47 = Instance[v3[fn2("J\3\167", 23438351816004)]](v46[fn2("\203%q\241\205e\171\179\26\144\200.v", 12404244098336)])

	if flag8 then
		local v48 = v3
		v30(v3[fn2("o", 27769958524166)] .. os[v3[fn2(">\238W\231\186", 6757263513749)]]() .. v48[fn2("\221O\190w\196!\176\224\7\187#ʮgm\217c", 26137821142806)])
	end

	arg[v3[fn2("\227\197\200eba\232\t", 21769706098482)]][v45] = v47
	local v48 = v3

	arg[v3[fn2("\178\18Q\147\250:[\134\176", 17162139319919)]]:Send(fn6({
		[v3[fn2("~\148\234\238Ɗ", 22738250781368)]] = v48[fn2("\142YQϺ\16\149", 21390663667153)],
		[v3[fn2("s\182\11\31", 24974923258587)]] = arg2,
		[v3[fn2("\183\1", 1700858955312)]] = v45,
	}))

	if flag8 then
		local v49 = v3
		v30(v3[fn2("\215", 27636810474634)] .. os[v3[fn2("-O0\128\243", 26764905505118)]]() .. v49[fn2("\229\171\27\129\190\143\178\29\245<<\251}yL", 15506378897513)])
	end

	local flag10 = false

	v27(function()
		v41(30)

		if not flag10 then
			if flag8 then
				local v49 = v3
				v30(v3[fn2("\178", 20659423169320)] .. os[v3[fn2("͗q;\138", 2741346535929)]]() .. v49[fn2("\195wkZ\144wȺ\168\1644\255\201\252U=\131\243\6\174KR!\250\179?ä\203\200\249\131\225<=c\8\216H\2452C\236\245\5\156", 29761810394181)])
			end

			local v49 = arg[v3[fn2("į\140R\1966\251\147", 8061899644244)]][v45]
			v49:Fire(v3[fn2("", 10378031441345)])

			if flag8 then
				local v50 = v3
				v30(v3[fn2("\19", 4223155474269)] .. os[v3[fn2("\138J\234w\251", 2422435481808)]]() .. v50[fn2("\220\225Ȣ\212/\159\152\17\130\1\192\160\175\215+\170\142-\222\01938\151\237#G\250s}\166a\1", 34310319570129)])
			end

			return v49:Destroy()
		end
	end)

	local v49 = v47[v3[fn2("6y\14\152\246", 14892179830317)]]
	flag10 = true
	return (v49:Wait())
end

tbl9.close = function(arg)
	arg[v3[fn2("\241\199\234^{\15\210n\242Θ\147", 28222017627819)]] = true
	arg[v3[fn2("\248Ot\178\26\"\163W\188", 11388453333358)]]:Close()
end

local v45 = script_key or v3[fn2("O8\150\147", 28215574980261)]
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
	local v46 = n7

	while n7 == v46 do
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

		local n11 = arg % 9999995 + 1 + 7762
		local n12 = arg % 1000
		local n13 = fn3((arg - n12) / 1000) % 1000
		local n14 = arg % (n8 * n9 + 9999) + 7762
		arg = (n12 * n13 + n11 + arg % (419824125 - n11 + n12) + (n14 + n12 * n9 + n13) % 999999 * (n11 + n14 % n10)) % 99999999999
	end

	return arg
end

local n8 = 1
local v46 = syn and syn[v3[fn2("D\180\156f\239S\239", 24172813637616)]] or request or http_request

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
		local v47 = v12(i)
		tbl6[i] = v47
		tbl6[v47] = i
	end

	for i = 1, #arg2 do
		local v47 = arg2[i]
		tbl7[i - 1] = v47
		tbl7[v47] = i - 1
	end
end

local tbl10 = {}
local v47 = v3[fn2("?", 4071753256656)]
local v48 = v3[fn2("\170", 20685193759552)]
local v49 = v3[fn2("\235", 33316004297011)]
local v50 = v3[fn2(" ", 9831480173508)]
local v51 = v3[fn2(".", 12166939913283)]
local v52 = v3[fn2("\188", 20310446426595)]
local v53 = v3[fn2("\30", 7856808696981)]
local v54 = v3[fn2("J", 30505936187130)]
local v55 = v3[fn2("\22", 31005241372875)]
local v56 = v3[fn2("y", 15134852888335)]
local v57 = v3[fn2("p", 7987809197327)]
local v58 = v3[fn2("\227", 12325858553047)]
local v59 = v3[fn2("M", 14182414824344)]
local v60 = v3[fn2(")", 20544529287869)]
local v61 = v3[fn2("F", 24744061721092)]
local v62 = v3[fn2("\174", 28931782633792)]
tbl10[1] = v47
tbl10[2] = v48
tbl10[3] = v49
tbl10[4] = v50
tbl10[5] = v51
tbl10[6] = v52
tbl10[7] = v53
tbl10[8] = v54
tbl10[9] = v55
tbl10[10] = v56
tbl10[11] = v57
tbl10[12] = v58
tbl10[13] = v59
tbl10[14] = v60
tbl10[15] = v61
tbl10[16] = v62
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
		local v63 = n11
		local n14 = n9 * n12 + n10
		local n15 = n14 % v63 + n13
		n13 += 1
		n12 = n15
		n10 = n14 % 4859 * v63 % 5781
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

		local n12 = arg % 9999995 + 1 + 7762
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 7762
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
		tbl11 = arg[1]
		tbl12 = arg[2]
		tbl13 = arg[3]
	end

	local n9 = 0
	local n10 = 0
	local n11 = 0

	for k, v63 in v11, tbl11, nil do
		local v64 = tbl12[v63]

		if tbl13[k] == v63 then
			n9 += 1
		end

		n10 += 1
		n11 = n10 % 2 == 0 and n11 * v64 or n11 + v64 + n10
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

		local n12 = arg % 9999995 + 1 + 7762
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 7762
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

		local n12 = arg % 9999995 + 1 + 7762
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 7762
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
		local v63 = n11
		local n14 = n9 * n12 + n10
		local n15 = n14 % v63 + n13
		n13 += 1
		n12 = n15
		n10 = n14 % 4859 * v63 % 5781
		return arg2 + n15 % arg3 - arg2 + 1
	end
end

local n9 = 68
fn14(67, v3[fn2("\132", 3840891719161)], v3[fn2("\148\243v\159\160\235\254v\22\198&3\183[\220h\254qŎJ\25\208K\154\157\246]", 12721007603271)])
n6 = -1
fn15()

while n6 == -1 do
end

local v63 = fn18(n7 + n6)

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
		v46(v19({}, { [v3[fn2("\192\ra\139\231\195\12", 32549329237609)]] = function()
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
	local v64 = v3
	local tbl11 = { [v3[fn2("\242~\242\192\31\156", 25253030878174)]] = v64[fn2("rs\254", 30562846240559)] }

	if arg2 then
		tbl11 = v19(tbl11, { [v3[fn2("\216\21m\142\201m\185", 4427172646939)]] = function(arg4, arg5)
			if arg5 == v3[fn2("6c\17", 29393505708782)] then
				local v65 = v3
				local v66 = v16(v17(), v65[fn2("\1639\5\144\26ǈu&/\184", 32746903762721)])
				local v67 = v66()
				local v68 = v66()
				local n10 = 1

				v15(function()
					n10 = v18(v68) - v18(v67)
				end)

				if (n8 == 9 or n8 == 15) and (n10 ~= 0 or v67 ~= v68) then
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

	local v65 = v46(tbl11)

	if v65[v3[fn2("\133\\*\136\211ɹ\206\215j", 13445805453546)]] == 0 then
		if flag8 then
			warn(v3[fn2("j-F\128\162\139WIʯ\\хE\181p6\159O\23).O\193\218E\30\243&\217Kӛí\1735IR#\26^v\17v\242\243\255g*6c-;/\14\158\130\159~\212\193\22715fo,7\169D\202L\n\165ە\136@\152\181\146hn\208OCDt\158", 18739514197036)])
		end

		local v66 = v3
		writefile(v3[fn2("\207\249D\240\136>\28\137\129dÐ\214\30\184\231\139\226\150\24\179", 17214754274976)], v66[fn2("\216xc\22ѧ\29\211\253\25&\168\165\162\239_rגm*\250\8\190C\229\197ڊ\1792y\193\3|\21\198)$\183\28\14\127\167}\137 H\206\220J\198tݪ\165/\129\29`$'\176\252{v\185j\163M\160\tCEi\4\196z\255]\n\16zx\167\254\\W\168\181", 24541118323015)])
	end

	return v65[v3[fn2("2\224o\143", 15183172745020)]], v65[v3[fn2("\235\144\243\23326\138", 30737871499218)]]
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
	end or v46

	local v64 = v26
	local v65 = v25
	local v66 = v24
	local v67 = v23
	local v68 = v15
	tbl11[4] = v12
	tbl11[5] = v64
	tbl11[6] = v65
	tbl11[7] = v66
	tbl11[8] = v67
	tbl11[9] = v68

	local function fn21()
		flag11 = true
		return v3[fn2("9", 805330944750)]:rep(16777215)
	end

	local v69 = v19({}, { [v3[fn2("\2\164\245C\127\213\\\162\31N", 24089059219362)]] = function()
		flag11 = true
		return v3[fn2("\n", 12700605886004)]:rep(16777215)
	end })

	for k, v70 in v11, tbl11, nil do
		if k ~= -1 then
			local flag12 = n8 ~= 11

			if flag12 then
				local v71 = v3
				flag12 = v22(v70)[v71[fn2("\183\167\19\142", 33365397928289)]] == v3[fn2("\11h\3", 1198332445788)]
			end

			if flag12 then
				flag11 = true
			end
		end

		if v70 ~= v10 and v70 ~= v32 then
			local v71 = v10
			local v72 = v32
			local v73 = error
			local env = getfenv()
			env[v3[fn2("*\253\137\5\172\129[\220", 22630873322068)]] = fn21
			env[v3[fn2("d0\166\143,", 17147106475617)]] = fn21
			env[v3[fn2("\194\218Gp<", 22071436759115)]] = fn21

			if k == -1 then
				if n8 ~= 5 then
					v15(v70, v3[fn2("", 22141232107660)])
				end
			else
				v15(v70, v69)
			end

			env[v3[fn2("\236\169g\\\154\181>2", 19030507111739)]] = v72
			env[v3[fn2("OH\r\168\171", 146033344648)]] = v71
			env[v3[fn2("n9\171U\136", 23510294713735)]] = v73
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

local v64 = n7
local v65 = nil
local flag11 = nil
local tbl11

while true do
	local v66 = v15(function()
		local v66 = fn19
		local v67 = v3
		v65 = v66(tbl5[v3[fn2("vx\194#", 12421424491824)]] .. v67[fn2("[O\242\0037\14\186", 5635169064064)], n8 == 9 or n8 == 15)
		local data = v14:GetService(v3[fn2("\14\162\t\231\29\182*\207)\183p", 24734397749755)]):JSONDecode(v65)

		if not data[v3[fn2(",b@\180%\197", 21709574721274)]] then
			warn(data[v3[fn2("#\144\1440\177J_", 15555772528791)]])
			fn9()
		end

		if not data[v3[fn2("'G\8\177li2\202", 6353524266781)]][tbl5[v3[fn2("\\\1927b`\19\180", 2717723494883)]]] then
			warn(v3[fn2("\170\225Ӥ\6t=\31\209\\\128W\254\215\219\217\208\249\214K,\170JOUZ\243o\144F\180\1443|\169+E\162\5\197\239\173\243y\2088$\250\24/7\4q)", 10233071871290)])
			fn9()
		end

		local v68 = tbl5
		local v69 = v3[fn2("M<\173\140", 25338932845614)]
		local v70 = flag4 and LT_R_RRT_H
		local v71

		if v70 then
			v71 = v70
		else
			local v72 = v7

			if v7 then
				v71 = v3[fn2("U՜\142s`Q\20;\18\198p\167-\154\139]\156\225\206\u{F45E}\2072:\0", 13360977260699)]
			else
				v71 = v72
			end
		end

		v68[v69] = v71 or v3[fn2("\194\219Κ\2251\176\229", 20587480271589)] .. v6
		local v72 = tbl5
		local v73 = v3
		v9 = data[v3[fn2("\147\208\226r\29\14\12\29", 29417128749828)]][v72[v73[fn2("\234]\254\157\27yP", 25466712022181)]]]
	end)

	fn8()

	if not v66 then
		if flag11 then
			break
		end
		fn14(69, v3[fn2("\132", 5187405058783)], v3[fn2("z\144\199zz\217\30\184 .t\4\248Hc\184\169BB\254G\191\5\223\237t\220i", 2506189900062)])
		v6 = v3[fn2("\185\153\142\14\4\0Q\15~a\234\8\243\250\128\"\185\152v\229Y\160\205Mĸ~", 25562277960958)]
		tbl5[v3[fn2("ѝ\175\188", 12563162738100)]] = flag4 and LT_R_RRT_H or v3[fn2("\137q\219σ\146\245\230B)\11%\rè~\188\254\151Q\214En1?\194h\197p\202>\191\128\188\166", 19243114481153)]
		flag11 = true
	end

	if not v66 then
		continue
	end

	local function fn21(arg)
		local n10 = 1103515245
		local n11 = 12345
		local n12 = 99999999
		local n13 = arg % 2147483648
		local n14 = 1

		return function(arg2, arg3)
			local v67 = n12
			local n15 = n10 * n13 + n11
			local n16 = n15 % v67 + n14
			n14 += 1
			n13 = n16
			n11 = n15 % 4859 * v67 % 5781
			return arg2 + n16 % arg3 - arg2 + 1
		end
	end

	local flag12 = false

	v27(function()
		if not v15(function()
			local v67 = tbl9
			local new = v67.new
			local str2 = flag4 and LT_R_RRT_W

			if not str2 then
				str2 = v7

				if v7 then
					local v68 = v6
					local v69 = v3
					str2 = v3[fn2("\183b\225(\6", 22124051714172)] .. v68 .. v69[fn2("0Mz'W!\18\31\179uwA\241", 2211975661580)]
				end
			end

			local str3

			if str2 then
				str3 = str2
			else
				local v68 = v6
				local v69 = v3
				str3 = v3[fn2("\146?\180M\218\\", 11448584710566)] .. v68 .. v69[fn2("S\1344\0225\167y%\153\151\160p\17F", 6916182153513)]
			end

			flag6 = new(v67, str3)
		end) then
			local v67 = v3
			fn14(75, v3[fn2("$", 1674014590487)], v67[fn2("\3ER\150\169\174/D\168\171\182\25\\\129i\223kg\5\21\233\248\2127\249՞\184\27\144\31\179\180xO\159\127݀*\28\194TT\189\145\233z\n", 9788529189788)])
			flag6 = false
		end

		flag12 = true
	end)

	local n10 = n7 % 8585 * v64 % 9910
	fn20()

	if flag5 then
		n9 = 146
	end

	fn14(85, v3[fn2("\164", 31753662264196)], v3[fn2("e\249\24\25\161 \251\8\2081\171\141\127Q:\247V\12\157\2432\28\237a\225", 6450163980151)])
	local v67 = fn21(n10 + v63(2, 4096))
	local v68 = v63(1111, 32768)
	local n11 = 12000 + ((1398563873 * ((1398563873 * (1361 + n10 + n6 % 1000 + n6) % 1610612736 + 22491) % 95716599 + 1) + 22491) % 95716599 + 1) % 120000 - 12000 + 1
	local tbl12 = { n11 + v67(100000, 1000000), v68, n11 + v63(3333, 15625) + n7, (v67(10000, 1000000)) }
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
	local tbl13 = { [0] = 0 }

	local function fn22(arg, arg2, arg3)
		arg2 = arg2 and arg or tbl6[arg]

		if not arg3 then
			arg2 = (arg2 + 4096 - tbl13[n12]) % 256
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
		local v69 = tbl7
		local n16 = (tbl7[v26(arg, 1, 1)] * 16 + v69[v26(arg, 2, 2)] + tbl13[n13]) % 256
		n13 = (n13 + 1) % n15
		if arg2 then
			return n16
		end
		return tbl6[n16]
	end

	local function fn25(arg)
		local tbl14 = {}
		n13 = 0
		local n16 = 1

		while true do
			local v69 = fn24(v26(arg, n16, n16 + 1), true)
			n16 += 2
			local v70 = v3[fn2("", 13613314290054)]

			for i = 1, v69 do
				v70 ..= fn24(v26(arg, n16, n16 + 1))
				n16 += 2
			end

			tbl14[#tbl14 + 1] = v70
			if not (n16 > #arg) then
				continue
			end
			break
		end

		return tbl14
	end

	local function fn26(arg, arg2)
		local v69 = fn22(#arg, true, arg2)

		for i = 1, #arg do
			v69 ..= fn22(v26(arg, i, i), false, arg2)
		end

		return v69
	end

	local function fn27(arg, arg2, arg3)
		if arg == 1 then
			tbl13 = arg2
			n15 = arg3
		elseif arg == 2 then
			n12 = 0
			n14 = 0
		elseif arg == 3 then
			return n14
		end
	end

	local v69 = fn18(v63(2, 32768 + v24() % 2000) + n6 % 4096)
	local v70 = fn12(v67(1, 32768) + n7 + v24() % 1000)
	local v71 = v69(111111, 999999)
	local tbl14 = {}

	for i = 1, v71 % 30 + 1 do
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

		tbl14[i] = fn28
	end

	local n16 = v70(111111, 999999) + 1493
	local n17 = v69(1, 1234) * v70(2, 1235) + n6 % 80000
	local n18 = 10000 + ((1445613873 * ((1445613873 * (n11 + n6) % 1627389952 + 23515) % 94716599 + 1) + 23515) % 94716599 + 1) % 100000 - 10000 + 1
	local tbl15 = { n18 + v69(100000, 1000000), n18 + v70(100000, 1000000), (v69(100000, 1000000)) }

	if v4 or v5 then
		n9 = 218
	end

	if flag13 then
		n9 = 250
	end

	local n19 = tbl12[3] + 15227
	local str2 = ((fn26(v3[fn2("", 26309625077686)] .. n16) .. fn26(v3[fn2("", 16740145904870)] .. fn16(17705 + v71) .. fn13(n9 + n17) .. fn10(n16 - 1493))) .. fn26(n17 .. v3[fn2("", 17472460177296)]) .. fn26(v3[fn2("", 27987934766545)] .. v71)) .. fn26(n19 .. v3[fn2("", 13603650318717)])
	local v72 = tbl15[1]
	local n20 = 7115 + tbl12[4]
	local n21 = tbl12[2] + 1493
	local n22 = 17705 + tbl12[1]
	local str3 = (((str2 .. fn26(v3[fn2("", 32880051812253)] .. v72) .. fn26(v3[fn2("", 16629547121791)] .. n20)) .. fn26(tbl15[3] .. v3[fn2("", 13202058620935)]) .. fn26(v3[fn2("", 15144516859672)] .. n21)) .. fn26(tbl15[2] .. v3[fn2("", 18783538955349)]) .. fn26(v3[fn2("", 8523622719234)] .. n22)) .. fn26(str or v3[fn2("\15", 2953953905343)])
	local str4 = fn26(fn17(fn27(3) + 6762) .. v3[fn2("", 3140790684525)], true) .. str3
	local tbl16 = {}
	local v73 = v70(111111, 999999)
	local v74 = n6
	getfenv()[tbl16] = v73
	local v75, v76 = fn19(tbl5[v3[fn2("\209\30p\238", 17011810876899)]] .. v3[fn2("V", 25199342148524)] .. v9 .. v3[fn2("\221\209\n=o\17", 1184373376079)] .. tbl5[v3[fn2("p<\196O\205\0158s", 21268253363551)]] .. v3[fn2("c>\6\3F\162+y", 3976187317879)] .. str4 .. v3[fn2("\167Q\174", 1858703820483)] .. tbl5[v3[fn2("\15s )\130R\2366K\160\146G\162", 33488882006484)]] .. v3[fn2("\142\229\173", 8988567118003)] .. v45, n8 == 9 or n8 == 15)
	n6 = -1
	fn15(tbl8)

	while n6 == -1 do
	end

	while tbl12[2] ~= v68 do
	end

	local n23 = 0

	for k, v77 in v33(tbl14) do
		if k == 2 and v77 ~= v32 then
			n9 = 147
		end

		if k == 8 and v77 ~= v10 then
			n9 = 147
		end

		if k == 17 and v77 ~= v26 then
			n9 = 147
		end

		n23 = k
	end

	if n23 ~= v71 % 30 + 1 then
		n9 = 147
	end

	local flag14 = false

	if n9 == 147 then
		flag14 = true
	end

	if n6 ~= v74 then
		n9 = 100
		flag14 = true
	end

	if v75 == v3[fn2("\196\205X", 28147927180902)] then
		while true do
		end
	else
		local fn28, n24, v77, n25, n26, v78, tbl17, n27, n28, n29

		do
			if v34(v75, v3[fn2("\166\222ʞ\1593\166ye\241v\251\148W\162\200<\128\148(ݯ\180\233/p\147\233F襣\136\185\170\1\172\250\235\173k", 1377652802819)]) then
				if v8 then
					v8(v3[fn2("Ҕ~E\164", 19446057879230)])
					return
				end
			end

			if v26(v75, 1, 1) == v3[fn2("\138", 5914350458244)] then
				local v79 = v3[fn2("l\24\178\25+\175\tY\29B갖X\23", 28383083816769)]
				local v80

				if string[v3[fn2("\220eg'", 2761748253196)]](v75, v3[fn2("\23GB\147\212y\236\24\167&\219\243@y;\217", 9639274521361)]) then
					v79 = v3[fn2("LY\1333\11w\134\174FP\194 \4\177,y7\5y", 15260484515716)]
					v80 = v26(v75, 2, #v75 - 17)
				else
					v80 = v26(v75, 2, #v75)
				end

				fn14(100, v3[fn2("\244\159\237\201L\217X\239\180\245$\181G?", 30952626417818)], v3[fn2("N=1MT {!\211Z\191R\207'\140\200\253|3\169\178\183\150U\25c", 27278169760572)], Color3[v3[fn2("\189o`", 30263263129112)]](1, 0, 0), v3[fn2("4\226\14\232\14", 13170919157738)])
				fn4(v79, v80)
				fn9()
			end

			if v76 then
				if not v76[v3[fn2("\2\209\252\2074\186vTX\135", 27265284465456)]] then
					local v79 = v76[v3[fn2("\212/tO\130\27\16ĩ\177", 17419845222239)]]
				end
			end

			local n30 = tbl12[4] % 256
			local tbl18 = { [0] = tbl12[1] % 256, tbl12[2] % 256, tbl12[3] % 256, n30 }
			fn8()

			fn28 = function(arg)
				local n31 = 1103515245
				local n32 = 12345
				local n33 = 99999999
				local n34 = arg % 2147483648
				local n35 = 1

				return function(arg2, arg3)
					local v79 = n33
					local n36 = n31 * n34 + n32
					local n37 = n36 % v79 + n35
					n35 += 1
					n34 = n37
					n32 = n36 % 4859 * v79 % 5781
					return arg2 + n37 % arg3 - arg2 + 1
				end
			end

			if getfenv()[tbl16] ~= v73 then
				n9 = 100
				flag14 = true
			end

			n24 = 1

			for i = 1, 30 do
				local v79 = v32({})
				local n31

				if v32({}) < v79 then
					n31 = n24 + 1
				else
					n31 = n24 * 2
				end

				n24 = n31 % 10000
			end

			fn27(1, tbl18, 4)
			v77 = fn25(v75)
			n25 = v77[1] - n16
			n26 = v77[4] - v71

			while n30 ~= tbl18[3] do
			end

			fn20()
			v78 = tbl18[3]

			tbl17 = {
				[0] = tbl18[0],
				[2] = tbl18[1],
				[4] = tbl18[2],
				[6] = v78,
				v77[9],
				[3] = v77[7],
				[5] = v77[2],
				[7] = v77[6],
			}

			fn27(1, tbl17, 8)
			n27 = v77[8] - tbl15[1]
			n28 = v77[3] - tbl15[2]
			n29 = v77[5] - tbl15[3]
			local str5 = v3[fn2("", 28654748788798)] .. fn17(tbl15[3] + 1876) .. fn16(tbl15[1] + 31) .. fn13(tbl15[2] + 8254)

			if v77[11] == str5 and ({ [str5] = true })[v77[11]] then
				flag2 = true
			else
				local str6 = v3[fn2("", 6334196324107)] .. fn10(tbl15[3] + 1876) .. fn13(tbl15[1] + 69) .. fn16(tbl15[2] + 8254)

				if v77[11] == str6 and ({ [str6] = true })[v77[11]] then
					flag2 = true
				end
			end
		end

		local n30, v79, str5

		do
			if flag2 then
				local flag15 = v18(v77[14] and v77[14] or v3[fn2("\230v", 11362682743126)]) == -1
				v18(v77[15] and v77[15] or v3[fn2("\8", 1527981245839)])
			end

			n6 = -1
			fn15()

			if n6 == -1 then
				n9 = 250
				n6 = 100
			end

			n30 = n7 + v69(111111, 999999) + v70(1234, 5678) + n6 % 99915 + n24
			tbl15[4] = n7 + n6 % 9951
			v69(100000, 1000000 + n6 % 1000)
			tbl15[5] = n6 % 8005 + n24 + v70(100000, 1000000 + n6 % 5000)
			tbl15[6] = v69(100000, 1000000)
			fn27(2)
			v79 = v77[10]
			local v80 = tbl15[6]
			local v81 = tbl15[4]
			str5 = fn26(v3[fn2("", 11551667071494)] .. fn13(v77[13] + 10806) .. fn17(n30 + n9) .. fn16(v77[10] + v71)) .. fn26(tbl15[5] .. v3[fn2("", 33512505047530)]) .. fn26(v3[fn2("", 24280191096916)] .. n30) .. fn26(v3[fn2("", 281328943366)] .. v80) .. fn26(v81 .. v3[fn2("", 30946183770260)])
		end

		local str6 = fn26(fn13(fn27(3) + 6762) .. v3[fn2("", 1284234413228)], true) .. str5
		local v80 = v77[12]
		local response = v14:HttpGet(tbl5[v3[fn2("\204=\165,", 285624041738)]] .. v3[fn2("\215", 34962100748080)] .. v9 .. v3[fn2("\180T}\144E`\233N0\18\159\197", 5342028600175)] .. v80 .. v3[fn2("l4\190", 13551035363660)] .. str6)

		while v78 ~= tbl17[6] do
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
				local v81 = fn25(response)
				local n31 = 1
				local v82 = fn28(1 + v69(100, 1000 + n24) + v70(500, 5000 + n24) + n7 % 10000)
				local flag15 = false
				local n32 = 0
				local flag16 = false
				local flag17 = false
				local v83 = nil

				for i = 1, 3 do
					local v84 = v81[3]
					local str7 = fn13(tbl15[5] + 1493) .. fn13(tbl15[4] + fn23(flag16 and v3[fn2("\177", 34008588909496)] or v14[v3[fn2("\5fw\137\244", 33146347911317)]])) .. fn13(tbl15[6] + tbl15[2])

					if v84 == str7 and ({ [str7] = true })[v84] then
						flag3 = true

						if not (v81[8] and v81[8] ~= v3[fn2("C", 5343102374768)] and v81[8]) then
							local v85 = v3[fn2("x\138\221<\173~N", 31676350493500)]
						end

						if not (v81[9] and v81[9]) then
							local v85 = v3[fn2("\190;h\148\252\0\245", 23283728274612)]
						end

						v83 = v81[6]

						do
							local n33 = v81[1] - tbl15[4]
							local n34 = v81[7] - tbl15[5]
							local n35 = v81[5] - tbl15[6]
							local v85 = n27
							local v86 = n28
							local v87 = n29

							n27 = function(arg)
								if not (flag15 or n32 < v29() - 8) then
									n31 = (n31 + arg % 66) % 6644
									return v85 * arg % n33 + arg * 3
								end

								while true do
								end
							end

							n28 = function(arg)
								if not (flag15 or n32 < v29() - 8) then
									n31 = (n31 + arg % 50) % 5891
									return v86 * arg % 10000 + arg * n34 % 4
								end

								while true do
								end
							end

							n29 = function(arg)
								if not (flag15 or n32 < v29() - 8) then
									n31 = (n31 + arg % 35) % 6711
									return (arg + n35) % 100 * arg % (v87 % 100 + 1)
								end

								while true do
								end
							end
						end

						flag17 = true
						break
					elseif i == 3 then
						v83 = nil
					else
						flag16 = true
						v83 = nil
					end
				end

				if not flag17 then
					while true do
					end
				else
					if not flag14 then
						do
							while not flag12 do
								v28:Wait()
							end

							flag7 = true

							do
								local flag18 = false
								local flag19 = false
								local n33 = 0
								local n34 = 0
								local n35 = 0
								local flag20 = false
								local n36 = 0
								local n37 = 0
								local v84 = v77[12]

								v27(function()
									flag19 = true

									while not flag9 do
										local n38 = v82(1000, n31 + 10000) + n31
										local n39 = v82(1000, n31 + 10000) + n31
										n36 = n38
										n37 = n39
										fn27(2)
										local v85 = fn26
										local str7 = fn26(n37 .. v3[fn2("", 15363566876644)]) .. v85(fn17(n37 + v79) .. v3[fn2("", 6862493423863)] .. fn16(n36 + n16)) .. fn26(n36 .. v3[fn2("", 13612240515461)])
										local v86 = v3[fn2("", 26792823644536)]
										local v87 = v9
										local v88 = v3
										local str8 = tbl5[v3[fn2("\251k\3\137", 8239072452089)]] .. v3[fn2("\243", 6554320115672)] .. v87 .. v3[fn2("\1716y\6\132\215\1\133#\18\21'\12\146H\155\195\17", 8461343792840)] .. str7 .. v88[fn2("\224\212\238", 27556277380159)] .. v84

										v15(function()
											if flag8 then
												local v89 = v3
												v30(v3[fn2("@", 8025391308082)] .. v29() .. v3[fn2("\198\5\158\149\150H\31\14\31\12\163}g\158\31H\4\5\208[", 21377778372037)] .. v32(flag6) .. v89[fn2("\229\215", 957806936956)])
											end

											if flag6 == false then
												v86 = fn19(str8)
											else
												v86 = flag6:request({ [v3[fn2("E\143\147", 17306025115381)]] = str8 })
											end

											if flag8 then
												local v89 = v3
												v30(v3[fn2("\136", 8205785439706)] .. v29() .. v89[fn2("\20N\188+\204\18\227\131`OM\249P=\163n\206\2432", 6507074033580)])
											end

											if v86 and #v86 > 3 then
												if v86 == v3[fn2(",.[\"@+o>\223", 19626452010854)] then
													flag15 = true
													flag2 = false
													flag3 = false
													n26 = 1
													n25 = 2
													local v89 = v3
													v14:GetService(v3[fn2("K\26\21\0193\18\164", 34803182108316)])[v89[fn2("\210\201\222Q\159{D\181\180\253d", 29684498623485)]]:Kick(v3[fn2("\3\174d\163\173\15\196\248\n\148\211g\189\226M\252,\146?T\145^m\161\29J\31mM\158n\1\176D\232\133\t\2291r*\138W\145\0190\29\152I\176\177\147X^3\153O۴", 33049708197947)])
													fn9()
												end

												if v86 == v3[fn2("Ɖ\162J", 30249304059403)] then
													flag15 = true
													flag2 = false
													flag3 = false
													n26 = 1
													n25 = 2
													local v89 = v3
													writefile(v3[fn2("\231\151|(\168\248]\170\254\215\233V\231k\136M\172\129\168", 14824532030958)], v89[fn2("s25z\154\234a\131\145", 15250820544379)])

													while true do
													end
												else
													v86 = fn25(v86)[1]

													if v86 == fn13(n36 * n37 % 100000 + n30 + 17705) .. v3[fn2("", 28489387501476)] then
														n34 += 1
														flag20 = true
														flag18 = true
													elseif v86 == fn10(n36 * n37 % 100000 + n30 + 17705 + 4919) .. v3[fn2("", 15233640150891)] then
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
														n26 = 1
														n25 = 2
														local v89 = v3
														v14:GetService(v3[fn2("\197>x\169\18fL", 29485850323780)])[v89[fn2("\172\15\203V*\147lM\179R\26", 24838553885276)]]:Kick(v3[fn2("\174\191bRRQ*\193ع'\25\154\n\158j\6\129\242\184\187\21\21D\245\225tL\179\160(", 22159486275741)] .. n34)
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
									local n38 = 200

									while true do
										n38 += 1

										if not flag9 and n38 >= 250 then
											if flag20 then
												n33 += 1

												if n33 > 4 then
													n33 = 0

													if n35 < 10 then
														n35 += 1
													end
												end
											else
												n35 -= 1

												if n35 <= 0 then
													flag15 = true
													flag2 = false
													flag3 = false
													n26 = 1
													n25 = 2
													local v85 = n34
													writefile(v3[fn2("\rq\227Ŗ\196C\12d5\169P\130\23\225R%\162/\160\157", 15647043369196)], v3[fn2("\226\254\178K\216\255Z+Z", 8167129554358)] .. v85 .. v3[fn2("\250\193X\28", 24571184011619)] .. v32(flag6))
												end
											end

											flag20 = false
											n38 = 0
										end

										n32 = v29()
										v21(0.18)
										if n32 ~= v29() then
											continue
										end
										flag15 = true
										flag2 = false
										flag3 = false
										n26 = 1
										n25 = 2
										local v85 = n34
										writefile(v3[fn2("\221aK\192\216\12q\174n\167\"\232\6\199\17:\166y\t=)", 26022927261355)], v3[fn2("\206\224\168?\226v\231\19\29", 709765005973)] .. v85 .. v3[fn2("\169d\175m", 10312531191172)] .. v32(flag6))
									end
								end)

								fn14(95, v3[fn2("\132", 22787644412646)], v3[fn2("\"\140\144$Il~ٳz\219Z\206:\t", 447764005281)])

								while not flag19 or not flag18 do
									v21()
								end
							end
						end

						fn14(100, v3[fn2("^\156\160\174\193/5\1494\0U\206\225\165}", 10029054698620)], v3[fn2("[Q7ð=\11x\218~\1302}\200\234/m\228.\159", 31806277219253)] .. v29() - now .. v3[fn2("\252", 21953321553885)], Color3[v3[fn2("wܽ", 20447889574499)]](0, 1, 0), v3[fn2("\211\225ף", 11135042529410)])

						do
							local v84 = nil

							local tbl18 = {
								[8] = 18,
								[22] = 32,
								[23] = 156,
								[18] = 45,
								[17] = 214,
								[7] = 54,
								[4] = 102,
								[14] = 126,
								[12] = 40,
								[19] = 78,
								[11] = 156,
								[21] = 243,
								[6] = 116,
								[2] = 22,
								196,
								[3] = 231,
								[10] = 200,
								[9] = 13,
								[5] = 75,
								[16] = 69,
								[13] = 12,
								[15] = 237,
								[20] = 59,
							}

							luraph_runtime1(v83, buffer.fromstring("p\"\227?.\165\207\199g\147!\0296\2267\1321\128\173\128\214\239ޟ'z$\245b\130\188\137\230\1483\243\215\201\31\178\171\227eK\15x\164\195s\220(@Y\6K\205\31\204\198\246\224N\176\224bY\7\"\148/\238j\u{85}\179\251lB1\223\3\216CȺk\151\137e\5\21\24\166&\179\132\160k\30h\178Oa{/\2\\\176\203\199~\206\250eꎑI\240,21}\226-\240\164$\165K\0\0024\219\237\1\239ܪ)c\131W\0123\"\240\168\245U;I\t\168Y\t@:\145\135\153\5\142(\235\191\7\231ܵI\19\248\165\132\183{\226%I#\206\r\n}*\0001\141\134\162\17\25赗uXŒgNR\140L\29\5K\246\238Ef\239\183\242\246T\130Z\2321\139\232\238\179\0\180+\127x5\171+\211z\236\0184\249@\2{\2220\21,\201ŻK\27\160\242\201V\133\"koھ\238G\141l\135\159\245[\23/òm\213\2vRa2d\215(\128\26\225\14\175dn\239@\179A\248\141\244\239\165#R\0\135&\212k\164\224\247\184\20\1386O7t\163\135\158\24\177nN\240\153\167bu*,N\127\4/\23َP\162\243]\138\249\0023>s\128\149\225l\29\30\194ݦL\28@\132\167\156BMxmT\192;{d\152o\25c|'\216\233?R$\3\169\183\218z\8\22\232\235\233G\26mO\175(}\132\166g\195ُr\199\223\221\24\221\11ȣc\152\231\2.-\226\227Ă\21CQ\229+\161\189\222W'u\188ǈ\204L\189\1355h\155\202[\213m2ٌ\156\214b<\201eC\194\211Y\20\242m\25Y\142=\190\224\212/\190%\19k\17xV\7\220\2422h\153\137\141\153\2441i\155\172\140\7\206\16_\21k=\184ż\136\242k\1409\204\18Si\3d\219(\140\31B\210<X$\230\187\4,s\237\202=\144\138\248\30{K\2129\\狊\161\152΄\206\217Η\12N\213\237\20w=\177\135\197D\197\231\14\187܌Y(\204$\8\149\191\254\236\8\2063\226ղ\195\207\6H\229q\219H\21\175;\150\198\244\193\12\4\245\230\153\5\128\1|O\127\137O\252\22lB\190\196!\251\172\254\143ν\24\6\23~C\145T0\245\133\169\224~V\159\29\220\211\236H\247\252@0W\210\206)\11Qg\142y։'\246\1304C\28j\149\251\243\143e3\0271\5G\231\171\1\22\134$\155\197I\158Rɽ\147\170T5(\27\241JA@ȫ%\246g*\186:\158\144\23\203#u\221FLɺɳ)>\30\230v\205\251\208vZ#2\24\153\178h\244\173\8\220\206\n\250\245`\242\254*\135z\230\128\203\252CL\154\129\127\18=P\246\216\24\246\1628\218\199\4\131\195 \216\215\14\218\27e\u{38B}\234\210o\181\138\217)\16m\191\175U|\203\24!\n\132\15\145\198cv\166\155&\242\239\231\248/\127\20))\134U]\165\224)\173\248\226U\22L\142\174xM\24w\252z/ʆ\189~\r\\\u{5F8}\247~E~\1\221,\11y\227\128>W\159\130\t\209>\133 R\2404\159\1988\247\174\157\19\243\233\128\232'\169\215d~\184\174\27q\181l$\205\\3\154u\3\145W\177=\173\218\15\253\242/\152\20\18\0\31\238-w\31\170\237\r\192Ǚd\r\247*\6\202I\167ƌ_\\\146\228\24s\0002V{[R\24gkTM\23\29\181\172\188;\208\2439\136\2289\201%\198ĻQu\237$\11+\31\28nq\249!\179\161\254G{\23V|;\173\152\233\218%\149\16#\143E\230^G\253\240\174\224\26\155d\n&\183\139\146ʟ\28\236\2125\4Q\5\152\241\248\0009\23@.\238=\5m\1633d\255\229\216:d\129c\134K\2238\1\142\248:\12\150\u{5FC}&\158\147JKa\148\159#l\189\31\140\148\139:L%7\201\192\215\27R\206\219\5^U)\1920\4w\179\197*i\155\239\179«\154ŉ\188`qp\231\1s\219\220W\244?\t:b\245\209\241\171(o\130\220\219yR*\176\t荛\17\255\3_w\22\255\159\211Zp)\12\20j\162.\236\28-\165\128\7E!\20fi\183\211\t*\208\213C\217{Z\157\26\231\220\18\214X\1갯\202w\188\189\210&jd\235H\"y\192\2168\t\134\151/\171Ҿ\193\173\218vS\142\17<\132\0299\152\191\241\248,\6\241\248\16\249\158\161\234\155;\28\180/wx\141\188\128\0K\217 j\133\173\24\172+n\255xB\178\176Q\228Uȱe9\239\207Q\30Q\17\175pz\133\218HD\24\159\135\228~'\225\24\198c\144\165\2\173\0\6\170D_\156\196\24#~C\148\154\143\131\132\183\149;\199\235H4Ys\7*H#\146\247\165}9\233x\231\197\252&\30_&b\168\194`r\193\177#%(LRT\184'Y\190\136>B(\255+%\166d\249\205yl\197w\247\179\255\225F\228n\239\169\214%\24892\213\240#\28 \225\192\205\232c\245\193\250\19Tld\171$\214\"L\239lflU\209\250?\231\r\249\206$AĢږ\166\238\211o\135\139?^\224@\242\230\14\240\15\0065\21)\129\248\n\26^\175\202\6\233\131J\207u\226\20\177|\25O`G\181\24\246c\242M>f\208Q\128\148\127_9\155\147\23\176\251\rgY\174YB{\14\27Y\192ַ\254\156\239\254\236\1384G\n.4[\178\152\145\22\2406\ro6\29\11\23\186t\234\159V)\186"), tbl18, 274)()

							if n27(1344) > 12225 then
								local UserInputService, flag18, tbl19, tbl20, fn29, position, cFrame, fn30, fn31, fn32
								local tbl21, fn33, color, color2, color3, color4, color5, ScreenGui, Frame

								do
									local service, RunService, CoreGui, localPlayer, part, tbl22, n33, n34, v85, fn34
									local fn35, fn36, fn37, thread, fn38

									do
										local Players

										do
											local HttpService, NetworkClient

											do
												print = function()
												end

												warn = function()
												end

												pcall(function()
												end)

												service = game:GetService(v84[13])
												UserInputService = game:GetService("UserInputService")
												RunService = game:GetService("RunService")
												Players = game:GetService("Players")
												HttpService = game:GetService("HttpService")
												CoreGui = game:GetService("CoreGui")
												NetworkClient = game:GetService("NetworkClient")
												localPlayer = Players.LocalPlayer

												if not localPlayer then
													repeat
														task.wait(0.1)
														localPlayer = Players.LocalPlayer
													until localPlayer
												end

												flag18 = v84[65]

												do
													local function fn39(arg, arg2)
														local str7 = arg2 or "hook_bg.png"
														local getCustomAsset = getcustomasset or getsynasset or syn and syn.get_custom_asset
														if not getCustomAsset then
															return ""
														end

														if isfile and isfile(str7) then
															local ok, result = pcall(getCustomAsset, str7)

															if ok and result and result ~= "" then
																if 6889 >= n28(1979) then
																	return result
																end

																while true do
																end
															end
														end

														if writefile then
															pcall(function()
																local request_ = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request
																local body = nil

																if request_ then
																	local v86 = request_({ Url = arg, Method = "GET" })
																	local body2 = v86 and (v86.Body or v86.body)
																	body = nil

																	if body2 then
																		body = v86.Body or v86.body

																		if n25 > 5454 then
																			while true do
																			end
																		end
																	end
																end

																if not body and game.HttpGet then
																	body = game:HttpGet(arg)
																end

																if body and #body > 0 then
																	writefile(str7, body)
																end
															end)

															if isfile and isfile(str7) then
																local v86 = v84[48]

																if n28(827) <= v86 then
																	local ok, result = pcall(getCustomAsset, str7)
																	if ok and result and result ~= "" then
																		return result
																	end
																else
																	while true do
																	end
																end
															end
														end

														return ""
													end

													tbl19 = {
														Circle = "rbxassetid://266543268",
														Logo = fn39("https://files.catbox.moe/et2mq4.png", v84[43]),
														Background = fn39("https://files.catbox.moe/l5h4hn.png", "hooklagger_bg.png"),
													}
												end
											end

											tbl20 = {
												enabled = false,
												guiVisible = true,
												keybind = "Z",
												version = v84[80],
												targetPos = Vector3.new(-538.104, 7.471, v84[61]),
												position = {
													X_Scale = 0.5,
													X_Offset = -v84[41],
													Y_Scale = 0.5,
													Y_Offset = -98,
												},
												scale = v84[40],
											}

											do
												local function fn39()
													pcall(function()
														if isfile and isfile("hookantianti_v5.json") and readfile then
															local ok, result = pcall(function()
																return HttpService:JSONDecode(readfile(v84[63]))
															end)

															if ok and type(result) == "table" then
																if result.Keybind ~= nil then
																	tbl20.keybind = tostring(result.Keybind)
																end

																if result.Version ~= nil then
																	local version = tostring(result.Version):upper()

																	if version == v84[46] or version == "V2" or version == v84[77] or version == "V4" or version == "V5" or version == "V6" then
																		tbl20.version = version
																	else
																		tbl20.version = "V5"
																		if not flag3 then
																			return
																		end
																	end
																end
															end
														end
													end)

													if tbl20.version ~= "V1" and tbl20.version ~= "V2" and tbl20.version ~= "V3" and tbl20.version ~= "V4" and tbl20.version ~= v84[80] and tbl20.version ~= "V6" then
														tbl20.version = v84[80]
													end
												end

												fn29 = function()
													pcall(function()
														if writefile then
															writefile("hookantianti_v5.json", HttpService:JSONEncode({ Keybind = tbl20.keybind, Version = tbl20.version }))
														end
													end)
												end

												fn39()
											end

											part = nil
											tbl22 = {}
											n33 = 0
											position = nil
											cFrame = nil
											n34 = v84[38]
											v85 = nil

											fn34 = function(arg, arg2, arg3)
												if not arg then
													return false
												end
												local v86 = sethiddenproperty or set_hidden_property or sethiddenprop or set_hidden_prop

												if v86 then
													if pcall(v86, arg, arg2, arg3) then
														return true
													end
												end

												return pcall(function()
													arg[arg2] = arg3
												end)
											end

											fn35 = function()
												pcall(function()
													if setsimulationradius then
														setsimulationradius(math.huge, math.huge)
													end

													fn34(localPlayer, "MaximumSimulationRadius", math.huge)
													fn34(localPlayer, "SimulationRadius", math.huge)
													fn34(workspace, "InterpolationThrottling", Enum.InterpolationThrottlingMode.Disabled)
													fn34(workspace, "FallenPartsDestroyHeight", -500000)

													pcall(function()
														workspace.FallenPartsDestroyHeight = -500000
													end)

													if settings().Physics then
														pcall(function()
															local disabled = Enum.EnviromentalPhysicsThrottle.Disabled
															settings().Physics.PhysicsEnvironmentalThrottle = disabled
															settings().Physics.AllowSleep = false
														end)
													end

													if settings().Network then
														pcall(function()
															local disabled = Enum.InterpolationThrottlingMode.Disabled
															settings().Network.InterpolationThrottling = disabled
														end)
													end

													if NetworkClient and NetworkClient.SetOutgoingKBPSLimit then
														NetworkClient:SetOutgoingKBPSLimit(math.huge)
													end
												end)
											end
										end

										fn35()

										fn36 = function(arg)
											if not arg then
												return nil
											end
											return arg:FindFirstChild("HumanoidRootPart") or arg:FindFirstChild("Torso") or arg:FindFirstChild("UpperTorso") or arg.PrimaryPart
										end

										do
											local function fn39(arg)
												if not arg then
													if n28(532) < 8052 then
														return nil
													end

													while v84[66] do
													end
												end

												local huge = math.huge
												local n35 = nil

												for _, player in ipairs(Players:GetPlayers()) do
													if player ~= localPlayer and player.Character then
														local v86 = fn36(player.Character)
														local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

														if v86 and (not humanoid or humanoid.Health > 0) then
															local magnitude = (arg.Position - v86.Position).Magnitude

															if magnitude < huge then
																local head = player.Character:FindFirstChild("Head")

																if head then
																	n35 = head.Position + Vector3.new(0, v84[20], 0)
																	huge = magnitude
																else
																	n35 = v86.Position + Vector3.new(v84[38], 5, 0)
																	huge = magnitude
																end
															end
														end
													end
												end

												return n35
											end

											fn37 = function(cFrame2)
												if not part or not part.Parent or not part:IsDescendantOf(workspace) then
													pcall(function()
														if part then
															part:Destroy()
														end
													end)

													part = Instance.new("Part")
													part.Name = v84[37]
													part.Size = Vector3.new(2, v84[4], 1)
													part.Anchored = true
													part.CanCollide = false
													part.CanTouch = v84[65]
													part.CanQuery = v84[65]
													part.Transparency = 1
													part.Massless = true

													if cFrame2 then
														part.CFrame = cFrame2
													end

													part.Parent = workspace
												end

												return part
											end

											thread = nil

											fn38 = function()
												if not tbl20.enabled then
													return
												end
												local character = localPlayer.Character
												if not character then
													return
												end
												local v86 = fn36(character)
												if not v86 then
													return
												end
												local humanoid = character:FindFirstChildOfClass("Humanoid")

												if humanoid then
													pcall(function()
														humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
														humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, v84[65])
														humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, v84[65])
													end)
												end

												fn35()

												for _, player in ipairs(Players:GetPlayers()) do
													if player ~= localPlayer and player.Character then
														for _, descendant in ipairs(player.Character:GetDescendants()) do
															if descendant:IsA("BasePart") and descendant.CanCollide then
																descendant.CanCollide = v84[65]
															end
														end
													end
												end

												local v87 = fn37()
												if not v87 then
													return
												end
												local rad = math.rad
												local random2 = math.random
												local v88 = v84[55]
												local cframe = CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), rad(random2(0, v88)))

												pcall(function()
													if v86.AssemblyLinearVelocity.Magnitude < 0.1 then
														v86.AssemblyLinearVelocity = Vector3.new(v84[38], 0.01, 0)
													end
												end)

												if tbl20.version == v84[35] then
													if not position then
														position = v86.Position
													end

													if not cFrame then
														cFrame = v86.CFrame
													end

													if v85 then
														pcall(function()
															v85:Cancel()
														end)

														v85 = nil
													end

													pcall(function()
														local lookVector = v86.CFrame.LookVector

														if lookVector.Magnitude < v84[19] and cFrame then
															lookVector = cFrame.LookVector
														end

														local vector = Vector3.new(lookVector.X, v84[38], lookVector.Z)

														if vector.Magnitude < 0.01 then
															vector = Vector3.new(0, 0, -1)
														end

														v86.CFrame = CFrame.new(position, position + vector)
														local v89 = v84[23]
														v86.AssemblyLinearVelocity = Vector3.new((math.random() - 0.5) * 0.04, 0.02, (math.random() - 0.5) * v89)
														v86.AssemblyAngularVelocity = Vector3.zero
													end)

													n33 = (n33 + 1.6) % 6.2831853071795862
													n34 += v84[40]
													local n35 = n34 % v84[11]
													local v89 = position
													local y = v89.Y
													local vector

													if n35 == 0 then
														local n36 = math.random() * 3.1415926535897931 * 2
														local n37 = math.random(8, 14)
														local z = v89.Z
														vector = Vector3.new(v89.X + math.cos(n36) * n37, y + math.random(0, 1), z + math.sin(n36) * n37)
													elseif n35 == 1 then
														local v90 = v84[71]
														local n36 = math.random() * v90 * 2
														local n37 = math.random(4, 9)
														vector = Vector3.new(v89.X + math.cos(n36) * n37, y, v89.Z + math.sin(n36) * n37)
													elseif n35 == 2 then
														local n36 = math.random() * 3.1415926535897931 * 2
														local n37 = math.random(3, v84[47])
														local z = v89.Z
														vector = Vector3.new(v89.X + math.cos(n36) * n37, y + math.random(18, 28), z + math.sin(n36) * n37)
													else
														local z = v89.Z
														vector = Vector3.new(v89.X + math.random(-12, 12), y + math.random(5, 20), z + math.random(-12, 12))
													end

													local vector2

													if n34 % 3 == 1 then
														local z = vector.Z
														vector2 = Vector3.new(vector.X + math.random(-40, 40), -v84[17] - math.random(0, 20000), z + math.random(-40, 40))
													else
														local vector3 = Vector3.new
														local n36 = (math.random() - 0.5) * 1.5
														local v90 = v84[54]
														local n37 = (math.random() - v90) * 1.5
														local v91 = v84[54]
														vector2 = vector + vector3(n36, n37, (math.random() - v91) * v84[73])
													end

													v87.CFrame = CFrame.new(vector2) * cframe
													local random3 = math.random
													local n36 = -v84[21]
													v87.AssemblyLinearVelocity = Vector3.new(math.random(-v84[21], v84[21]), math.random(-9999999, 9999999), random3(n36, 9999999))
													local random4 = math.random
													v87.AssemblyAngularVelocity = Vector3.new(math.random(-9999999, v84[21]), math.random(-9999999, v84[21]), random4(-9999999, 9999999))
												elseif tbl20.version == "V5" then
													local position2 = v86.Position
													n33 = (n33 + 1.2) % v84[51]
													local z = position2.Z
													local vector = Vector3.new(position2.X, position2.Y + math.clamp((math.sin(n33 * 4) + 1) * 22.5, 0, 45), z)
													v87.CFrame = CFrame.new(vector) * cframe
													local v89 = v84[49]
													v87.AssemblyLinearVelocity = Vector3.new(0, math.cos(n33 * v84[11]) * v89, 0)
													v87.AssemblyAngularVelocity = Vector3.new(0, 30, 0)
												elseif tbl20.version == "V4" then
													if not position then
														position = v86.Position
													end

													local v89 = v84[54]
													local vector = Vector3.new((math.random() - 0.5) * 0.04, 0.02, (math.random() - v89) * 0.04)

													pcall(function()
														if v86 and position then
															v86.CFrame = CFrame.new(position, position + v86.CFrame.LookVector)
															v86.AssemblyLinearVelocity = vector
														end
													end)

													n33 = (n33 + 0.95) % v84[51]
													local n35 = 14 + math.sin(n33 * 3.5) * 6
													local n36 = math.cos(n33) * n35
													local n37 = math.sin(n33) * n35
													local n38 = math.sin(n33 * 4) * 4.5 + math.cos(n33 * 2.5) * 2.5
													local vector2 = Vector3.new
													local v90 = v84[54]
													local n39 = (math.random() - v90) * 0.4
													local v91 = v84[54]
													local n40 = (math.random() - v91) * 0.4
													local v92 = v84[54]
													local v93 = vector2(n39, n40, (math.random() - v92) * 0.4)
													v87.CFrame = CFrame.new(position + Vector3.new(n36, n38, n37) + v93) * cframe
													local random3 = math.random
													v87.AssemblyLinearVelocity = Vector3.new(math.random(-v84[21], v84[21]), -9999999, random3(-9999999, 9999999))
													local random4 = math.random
													local n41 = -v84[21]
													local v94 = v84[21]
													v87.AssemblyAngularVelocity = Vector3.new(math.random(-9999999, v84[21]), math.random(-9999999, 9999999), random4(n41, v94))
												elseif tbl20.version == "V3" then
													local n35 = fn39(v86) or v86.Position + Vector3.new(0, 4.5, v84[38])
													local v89 = v84[54]
													v87.CFrame = CFrame.new(n35 + Vector3.new((math.random() - v89) * 0.08, (math.random() - 0.5) * 0.08, (math.random() - 0.5) * 0.08)) * cframe
													local n36 = -v84[21]
													local random3 = math.random
													local v90 = v84[21]
													v87.AssemblyLinearVelocity = Vector3.new(math.random(-9999999, 9999999), n36, random3(-9999999, v90))
													local random4 = math.random
													local n37 = -v84[21]
													v87.AssemblyAngularVelocity = Vector3.new(math.random(-9999999, v84[21]), math.random(-9999999, 9999999), random4(n37, 9999999))
												elseif tbl20.version == "V2" then
													local targetPos = tbl20.targetPos or Vector3.new(-538.104, 7.471, 60.085)
													local v89 = v84[45]
													v87.CFrame = CFrame.new(targetPos + Vector3.new((math.random() - 0.5) * v89, (math.random() - 0.5) * 0.06, (math.random() - 0.5) * 0.06)) * cframe
													local random3 = math.random
													v87.AssemblyLinearVelocity = Vector3.new(math.random(-9999999, 9999999), -9999999, random3(-9999999, 9999999))
													local random4 = math.random
													v87.AssemblyAngularVelocity = Vector3.new(math.random(-9999999, 9999999), math.random(-9999999, v84[21]), random4(-9999999, 9999999))
												else
													v87.CFrame = CFrame.new(v86.Position.X + math.random(-100000, 100000), -v84[82] - math.random(10000, 100000), v86.Position.Z + math.random(-100000, 100000)) * cframe
													local n35 = -v84[21]
													local random3 = math.random
													v87.AssemblyLinearVelocity = Vector3.new(math.random(-9999999, 9999999), n35, random3(-9999999, 9999999))
													local random4 = math.random
													v87.AssemblyAngularVelocity = Vector3.new(math.random(-v84[21], v84[21]), math.random(-9999999, 9999999), random4(-9999999, 9999999))
												end

												fn34(v86, "PhysicsRepRootPart", v86)
												fn34(v86, "PhysicsRepRootPart", v87)
											end
										end
									end

									local tbl23

									do
										do
											do
												local function fn39()
													for _, v86 in ipairs(tbl22) do
														if v86 then
															pcall(function()
																v86:Disconnect()
															end)
														end
													end

													table.clear(tbl22)
													position = nil
													cFrame = nil
													n33 = 0
													n34 = 0

													if v85 then
														pcall(function()
															v85:Cancel()
														end)

														v85 = nil
													end

													if thread then
														pcall(function()
															task.cancel(thread)
														end)

														thread = nil
													end

													pcall(function()
														if n27(v84[44]) > 5964 then
															local v86 = fn36(localPlayer.Character)

															if v86 then
																pcall(function()
																	v86.AssemblyLinearVelocity = Vector3.zero
																	v86.AssemblyAngularVelocity = Vector3.zero
																end)

																if part then
																	part.CFrame = v86.CFrame
																	part.AssemblyLinearVelocity = Vector3.zero
																	part.AssemblyAngularVelocity = Vector3.zero
																end

																fn34(v86, "PhysicsRepRootPart", v86)

																pcall(function()
																	v86:ApplyImpulse(Vector3.new(0, 0.001, 0))
																end)
															end

															return
														end

														while true do
														end
													end)
												end

												fn30 = function(arg)
													if not arg then
														fn39()
														return
													end
													fn35()
													local v86 = fn36(localPlayer.Character)

													if v86 then
														position = v86.Position
														cFrame = v86.CFrame
													end

													n33 = 0
													n34 = v84[38]
													local v87 = fn37(v86 and v86.CFrame)

													if v86 and v87 then
														if v86.CFrame then
															v87.CFrame = v86.CFrame
														end

														fn34(v86, "PhysicsRepRootPart", v86)
														fn34(v86, v84[24], v87)
													end

													if #tbl22 == 0 then
														table.insert(tbl22, RunService.Stepped:Connect(fn38))
														table.insert(tbl22, RunService.Heartbeat:Connect(fn38))
														table.insert(tbl22, RunService.RenderStepped:Connect(fn38))

														if pcall(function()
															return RunService.PreRender
														end) and RunService.PreRender then
															pcall(function()
																table.insert(tbl22, RunService.PreRender:Connect(fn38))
															end)
														end

														if pcall(function()
															return RunService.PreSimulation
														end) and RunService.PreSimulation then
															pcall(function()
																table.insert(tbl22, RunService.PreSimulation:Connect(fn38))
															end)
														end

														if pcall(function()
															if v84[78] > n27(3008) then
																return RunService.PostSimulation
															end

															while true do
															end
														end) and RunService.PostSimulation then
															pcall(function()
																table.insert(tbl22, RunService.PostSimulation:Connect(fn38))
															end)
														end
													end

													if not thread then
														thread = task.spawn(function()
															while tbl20.enabled do
																fn38()
																task.wait()
															end
														end)
													end
												end
											end
										end

										localPlayer.CharacterAdded:Connect(function(character)
											task.defer(function()
												fn35()

												if tbl20.enabled then
													local v86

													for i = 1, v84[42] do
														v86 = fn36(character)
														if not v86 then
															task.wait(v84[10])
															continue
														end
														break
													end

													if v86 and tbl20.enabled then
														position = v86.Position
														cFrame = v86.CFrame
														n33 = v84[38]
														n34 = v84[38]
														local v87 = fn37(v86.CFrame)

														if v87 then
															v87.CFrame = v86.CFrame
															fn34(v86, "PhysicsRepRootPart", v86)
															fn34(v86, "PhysicsRepRootPart", v87)
														end
													end
												end
											end)
										end)

										tbl11 = {
											Presets = {
												Snappy = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
												Smooth = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
												Spring = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
											},
											to = function(arg, arg2, arg3)
												local v86 = v84[18]
												local tween = service:Create(arg, type(arg2) == v86 and tbl11.Presets[arg2] or arg2, arg3)
												tween:Play()
												return tween
											end,
										}

										fn31 = function(arg, arg2, arg3)
											local instance = Instance.new(arg)
											local v86 = pairs
											local tbl24 = arg2 or {}

											for k, v87 in v86(tbl24) do
												if k ~= v84[62] then
													instance[k] = v87
												end
											end

											local v87 = ipairs
											local tbl25 = arg3 or {}

											for _, v88 in v87(tbl25) do
												v88.Parent = instance
											end

											if arg2 and arg2.Parent then
												instance.Parent = arg2.Parent
											end

											return instance
										end

										fn32 = function(arg, arg2)
											return fn31("UICorner", { CornerRadius = UDim.new(0, arg or v84[15]), Parent = arg2 })
										end

										tbl21 = { apply = function(parent, arg)
											parent.BackgroundTransparency = (arg or {}).transparency or 0.15
											local v86 = fn31

											local tbl24 = {
												Rotation = 90,
												Color = ColorSequence.new({
													ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
													ColorSequenceKeypoint.new(1, Color3.fromRGB(205, 210, 230)),
												}),
											}

											local numberSequence = NumberSequence.new
											local tbl25 = {}
											local v87 = NumberSequenceKeypoint.new(0, 0.55)
											local v88 = NumberSequenceKeypoint.new(0.5, 0.85)
											local new = NumberSequenceKeypoint.new
											tbl25[1] = v87
											tbl25[2] = v88

											do
												local values = table.pack(new(1, 0.7))
												table.move(values, 1, values.n, 3, tbl25)
											end

											tbl24.Transparency = numberSequence(tbl25)
											tbl24.Parent = parent
											v86("UIGradient", tbl24)

											fn31("UIStroke", {
												Thickness = 1,
												Color = Color3.fromRGB(255, 255, 255),
												Transparency = 0.86,
												ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
												Parent = parent,
											})
										end }

										tbl23 = {}

										do
											local tbl24 = {}

											RunService.RenderStepped:Connect(function(deltaTime)
												for i = #tbl24, v84[40], -1 do
													local v86 = tbl24[i]

													if v86 and v86.Parent then
														v86.Rotation = (v86.Rotation + deltaTime * v84[75]) % v84[55]
													else
														table.remove(tbl24, i)
													end
												end
											end)

											tbl23.attach = function(arg)
												local UIStroke = fn31("UIStroke", {
													Thickness = v84[70],
													Color = Color3.fromRGB(255, 255, 255),
													Transparency = v84[38],
													ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
													Parent = arg,
												})

												local v86 = fn31
												local tbl25 = {}
												local colorSequence = ColorSequence.new
												local tbl26 = {}
												local v87 = ColorSequenceKeypoint.new(0, Color3.fromRGB(75, v84[38], 125))
												local v88 = ColorSequenceKeypoint.new(0.2, Color3.fromRGB(165, 35, 240))
												local v89 = ColorSequenceKeypoint.new(0.45, Color3.fromRGB(235, 95, v84[25]))
												local v90 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, v84[25]))
												local v91 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(235, 95, 255))
												local v92 = ColorSequenceKeypoint.new(0.8, Color3.fromRGB(165, 35, 240))
												tbl26[1] = v87
												tbl26[2] = v88
												tbl26[3] = v89
												tbl26[4] = v90
												tbl26[5] = v91
												tbl26[6] = v92

												do
													local values = table.pack(ColorSequenceKeypoint.new(v84[40], Color3.fromRGB(75, 0, 125)))
													table.move(values, 1, values.n, 7, tbl26)
												end

												tbl25.Color = colorSequence(tbl26)
												local numberSequence = NumberSequence.new
												local tbl27 = {}
												local v93 = NumberSequenceKeypoint.new(0, v84[76])
												local v94 = NumberSequenceKeypoint.new(0.25, 0.4)
												local v95 = NumberSequenceKeypoint.new(v84[54], 0)
												local v96 = NumberSequenceKeypoint.new(0.75, v84[14])
												local new = NumberSequenceKeypoint.new
												tbl27[1] = v93
												tbl27[2] = v94
												tbl27[3] = v95
												tbl27[4] = v96

												do
													local values = table.pack(new(1, 0.75))
													table.move(values, 1, values.n, 5, tbl27)
												end

												tbl25.Transparency = numberSequence(tbl27)
												tbl25.Rotation = v84[38]
												tbl25.Parent = UIStroke
												local UIGradient = v86("UIGradient", tbl25)
												tbl24[#tbl24 + 1] = UIGradient

												return {
													stroke = UIStroke,
													gradient = UIGradient,
													brighten = function(arg2, arg3)
														if not (9521 >= n26) then
															tbl11.to(UIStroke, tbl11.Presets.Smooth, { Thickness = arg3 and 2.4 or 1.8 })
															return
														end

														while true do
														end
													end,
												}
											end
										end
									end

									fn33 = function(arg, arg2, arg3, arg4)
										local ImageLabel = fn31("ImageLabel", {
											AnchorPoint = Vector2.new(0.5, 0.5),
											Position = UDim2.fromOffset(arg2, arg3),
											Size = UDim2.fromOffset(v84[38], v84[38]),
											BackgroundTransparency = v84[40],
											Image = tbl19.Circle,
											ImageColor3 = arg4 or Color3.fromRGB(v84[16], 70, v84[27]),
											ImageTransparency = 0.4,
											ZIndex = v84[74],
											Parent = arg,
										})

										local n35 = math.max(arg.AbsoluteSize.X, arg.AbsoluteSize.Y) * 2.2
										local tween = service:Create(ImageLabel, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(n35, n35), ImageTransparency = 1 })
										tween:Play()

										tween.Completed:Connect(function()
											ImageLabel:Destroy()
										end)

										if not flag3 then
											return
										end
									end

									pcall(function()
										local hookAntiAntiUIV5 = CoreGui:FindFirstChild("HookAntiAntiUI_v5")

										if hookAntiAntiUIV5 then
											hookAntiAntiUIV5:Destroy()
										end
									end)

									pcall(function()
										local hookAntiAntiUIV5 = localPlayer:FindFirstChild("PlayerGui") and localPlayer.PlayerGui:FindFirstChild("HookAntiAntiUI_v5")

										if hookAntiAntiUIV5 then
											hookAntiAntiUIV5:Destroy()
										end
									end)

									do
										local function fn39()
											if gethui then
												local ok, parent = pcall(gethui)

												if ok and parent then
													local folder = Instance.new("Folder")

													local ok2 = pcall(function()
														folder.Parent = parent
													end)

													folder:Destroy()

													if ok2 then
														if not (n25 > 5449) then
															return parent
														end

														while true do
														end
													end
												end
											end

											local ok, parent = pcall(function()
												return game:GetService(v84[83])
											end)

											if ok and parent then
												local folder = Instance.new("Folder")

												local ok2 = pcall(function()
													if not (v84[34] >= n25) then
														folder.Parent = parent
														return
													end

													while true do
													end
												end)

												folder:Destroy()

												if ok2 then
													if syn and syn.protect_gui then
														pcall(syn.protect_gui, parent)
													end

													return parent
												end

												if n26 < 9521 then
													while true do
													end
												end
											end

											return localPlayer:WaitForChild("PlayerGui")
										end

										local color6 = Color3.fromRGB(v84[15], 3, v84[15])
										color = Color3.fromRGB(26, 6, 22)
										color2 = Color3.fromRGB(v84[16], 70, 239)
										color3 = Color3.fromRGB(190, 32, 168)
										color4 = Color3.fromRGB(v84[25], v84[25], 255)
										Color3.fromRGB(200, 165, 220)
										color5 = Color3.fromRGB(140, v84[26], 145)

										ScreenGui = fn31("ScreenGui", {
											Name = "HookAntiAntiUI_v5",
											ResetOnSpawn = v84[65],
											DisplayOrder = v84[8],
											IgnoreGuiInset = true,
											ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
										})

										ScreenGui.Parent = fn39()

										Frame = fn31("Frame", {
											Name = "Main",
											Size = UDim2.new(0, 270, 0, v84[31]),
											Position = UDim2.new(tbl20.position.X_Scale or 0.5, tbl20.position.X_Offset or -v84[41], tbl20.position.Y_Scale or v84[54], tbl20.position.Y_Offset or -98),
											BackgroundColor3 = color6,
											BackgroundTransparency = 0.08,
											BorderSizePixel = 0,
											Active = true,
											ClipsDescendants = true,
											Parent = ScreenGui,
										})
									end

									fn32(14, Frame)
									tbl23.attach(Frame)
								end

								local fn34, fn35, fn36

								do
									do
										do
											fn31(v84[79], {
												Scale = (tonumber(tbl20.scale) or v84[40]) * 0.85,
												Parent = Frame,
											})

											do
												local v85 = fn31(v84[28], {
													Name = "Backdrop",
													BackgroundTransparency = v84[40],
													Image = tbl19.Background,
													ScaleType = Enum.ScaleType.Crop,
													AnchorPoint = Vector2.new(1, 0),
													Position = UDim2.new(1, 10, 0, -v84[22]),
													Size = UDim2.new(0, 180, 1, v84[29]),
													ImageTransparency = v84[64],
													ZIndex = 1,
													Parent = Frame,
												})

												fn32(14, v85)
											end
										end

										do
											local Frame2 = fn31("Frame", {
												Size = UDim2.new(1, -20, 0, 34),
												Position = UDim2.new(v84[38], 12, 0, v84[22]),
												BackgroundTransparency = 1,
												ZIndex = 10,
												Parent = Frame,
											})

											fn31("ImageLabel", {
												Position = UDim2.fromOffset(2, 5),
												Size = UDim2.fromOffset(24, 24),
												BackgroundTransparency = 1,
												Image = tbl19.Logo ~= "" and tbl19.Logo or "rbxassetid://135967866518085",
												ZIndex = v84[2],
												Parent = Frame2,
											}, {
												(fn31("UICorner", { CornerRadius = UDim.new(0, 5) })),
											})

											fn31("TextLabel", {
												Size = UDim2.new(1, -36, 1, v84[38]),
												Position = UDim2.new(v84[38], 32, 0, 0),
												BackgroundTransparency = 1,
												Text = "HOOK ANTI ANTI",
												TextColor3 = color4,
												Font = Enum.Font.GothamBlack,
												TextSize = 13,
												TextXAlignment = Enum.TextXAlignment.Left,
												ZIndex = 11,
												Parent = Frame2,
											})
										end
									end

									do
										local flag19 = false
										local v85 = nil
										local position2 = nil
										local position3 = nil

										local function fn37(arg)
											local n33 = arg.Position - position2
											Frame.Position = UDim2.new(position3.X.Scale, position3.X.Offset + n33.X, position3.Y.Scale, position3.Y.Offset + n33.Y)
										end

										Frame.InputBegan:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												local guiObjectsAtPosition = ScreenGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
												local flag20 = v84[65]

												for _, v86 in ipairs(guiObjectsAtPosition) do
													if v86:IsA("TextBox") or v86:IsA("TextButton") and (v86.Name == v84[72] or v86.Name == "KeybindBtn" or v86.Name == "ModeBtn") then
														flag20 = true
														break
													end
												end

												if not flag20 then
													flag19 = true
													position2 = input.Position
													position3 = Frame.Position
													local connection = nil

													connection = input.Changed:Connect(function()
														if input.UserInputState == Enum.UserInputState.End then
															flag19 = false

															if connection then
																connection:Disconnect()
															end

															tbl20.position = {
																X_Scale = Frame.Position.X.Scale,
																X_Offset = Frame.Position.X.Offset,
																Y_Scale = Frame.Position.Y.Scale,
																Y_Offset = Frame.Position.Y.Offset,
															}

															fn29()
														end
													end)
												end
											end
										end)

										Frame.InputChanged:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
												v85 = input
											end
										end)

										UserInputService.InputChanged:Connect(function(input)
											if input == v85 and flag19 then
												if n26 < 9517 then
													while true do
													end
												else
													fn37(input)
												end
											end
										end)
									end

									do
										do
											local Frame2 = fn31("Frame", {
												Size = UDim2.new(1, -24, 1, -v84[67]),
												Position = UDim2.new(0, 12, 0, 42),
												BackgroundTransparency = 1,
												ZIndex = 5,
												Parent = Frame,
											})

											fn31("UIListLayout", {
												Padding = UDim.new(v84[38], 6),
												SortOrder = Enum.SortOrder.LayoutOrder,
												Parent = Frame2,
											})

											fn34 = function(arg)
												local Frame3 = fn31("Frame", {
													Size = UDim2.new(1, 0, 0, arg or v84[58]),
													BackgroundColor3 = color,
													BorderSizePixel = 0,
													ClipsDescendants = true,
													ZIndex = 5,
													Parent = Frame2,
												})

												fn32(8, Frame3)
												tbl21.apply(Frame3, { transparency = v84[32] })
												fn31(v84[7], { Color = color3, Transparency = v84[5], Thickness = 1, Parent = Frame3 })
												return Frame3
											end
										end
									end

									fn35 = nil

									do
										local flag19 = false

										fn36 = function()
											if flag19 then
												return
											end
											flag19 = true

											task.delay(0.04, function()
												flag19 = false
											end)

											tbl20.enabled = not tbl20.enabled

											if fn35 then
												fn35(tbl20.enabled)
											end

											fn30(tbl20.enabled)
										end
									end
								end

								do
									local v85 = fn34(42)

									fn31(v84[56], {
										Size = UDim2.new(v84[40], -74, 0, 16),
										Position = UDim2.new(0, v84[15], v84[38], 5),
										BackgroundTransparency = 1,
										Text = v84[53],
										TextColor3 = color4,
										Font = Enum.Font.GothamBold,
										TextSize = 12,
										TextXAlignment = Enum.TextXAlignment.Left,
										ZIndex = v84[30],
										Parent = v85,
									})

									local TextLabel = fn31("TextLabel", {
										Size = UDim2.new(1, -74, 0, 14),
										Position = UDim2.new(v84[38], 12, 0, v84[57]),
										BackgroundTransparency = 1,
										Text = "OFF",
										TextColor3 = color5,
										Font = Enum.Font.GothamBold,
										TextSize = 9,
										TextXAlignment = Enum.TextXAlignment.Left,
										ZIndex = 6,
										Parent = v85,
									})

									local Frame2 = fn31("Frame", {
										AnchorPoint = Vector2.new(1, 0.5),
										Position = UDim2.new(v84[40], -10, v84[54], v84[38]),
										Size = UDim2.fromOffset(v84[42], 20),
										BackgroundColor3 = Color3.fromRGB(32, v84[30], 26),
										BorderSizePixel = 0,
										ZIndex = 7,
										Parent = v85,
									})

									fn32(10, Frame2)

									local UIStroke = fn31("UIStroke", {
										Thickness = 1.2,
										Color = color3,
										Transparency = 0.5,
										Parent = Frame2,
									})

									local v86 = fn31(v84[39], {
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										Size = UDim2.fromOffset(v84[69], 14),
										Position = UDim2.fromOffset(3, 3),
										BorderSizePixel = v84[38],
										ZIndex = 8,
										Parent = Frame2,
									}, { (fn31(v84[12], { CornerRadius = UDim.new(1, v84[38]) })) })

									fn35 = function(arg)
										TextLabel.Text = arg and v84[52] or "OFF"
										TextLabel.TextColor3 = arg and color2 or color5
										tbl11.to(Frame2, tbl11.Presets.Spring, { BackgroundColor3 = arg and color3 or Color3.fromRGB(32, v84[30], v84[59]) })

										tbl11.to(v86, tbl11.Presets.Spring, {
											Position = arg and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3),
											BackgroundColor3 = arg and Color3.fromRGB(255, v84[25], v84[25]) or Color3.fromRGB(200, v84[60], 205),
										})

										tbl11.to(UIStroke, tbl11.Presets.Spring, { Color = arg and color2 or color3, Transparency = arg and v84[81] or v84[54] })
									end

									fn31("TextButton", {
										Name = v84[72],
										Size = UDim2.new(1, 0, 1, 0),
										BackgroundTransparency = 1,
										Text = "",
										ZIndex = 9,
										Parent = v85,
									}).MouseButton1Click:Connect(function()
										local mouseLocation = UserInputService:GetMouseLocation()
										fn33(v85, mouseLocation.X - v85.AbsolutePosition.X, mouseLocation.Y - v85.AbsolutePosition.Y, color2)
										fn36()
									end)
								end

								local TextButton

								do
									do
										do
											local v85 = fn34(42)

											fn31("TextLabel", {
												Size = UDim2.new(v84[40], -84, 1, v84[38]),
												Position = UDim2.new(0, v84[15], v84[38], 0),
												BackgroundTransparency = 1,
												Text = v84[6],
												TextColor3 = color4,
												Font = Enum.Font.GothamBold,
												TextSize = 12,
												TextXAlignment = Enum.TextXAlignment.Left,
												ZIndex = 6,
												Parent = v85,
											})

											local TextButton2 = fn31("TextButton", {
												Name = "ModeBtn",
												AnchorPoint = Vector2.new(v84[40], v84[54]),
												Position = UDim2.new(1, -v84[29], 0.5, 0),
												Size = UDim2.fromOffset(68, v84[9]),
												BackgroundColor3 = Color3.fromRGB(18, 4, v84[3]),
												BackgroundTransparency = 0.3,
												Text = tbl20.version or "V5",
												Font = Enum.Font.GothamBlack,
												TextSize = 11,
												TextColor3 = color2,
												AutoButtonColor = v84[65],
												ZIndex = 7,
												Parent = v85,
											})

											fn32(6, TextButton2)

											fn31("UIStroke", {
												Thickness = 1,
												Color = color3,
												Transparency = v84[54],
												Parent = TextButton2,
											})

											TextButton2.MouseButton1Click:Connect(function()
												local mouseLocation = UserInputService:GetMouseLocation()
												fn33(v85, mouseLocation.X - v85.AbsolutePosition.X, mouseLocation.Y - v85.AbsolutePosition.Y, color2)

												if tbl20.version == "V1" then
													tbl20.version = "V2"
												elseif tbl20.version == "V2" then
													tbl20.version = "V3"
												elseif tbl20.version == v84[77] then
													tbl20.version = "V4"
												elseif tbl20.version == "V4" then
													if n27(1896) >= 11672 then
														tbl20.version = v84[80]
														position = nil
													else
														while true do
														end
													end
												elseif tbl20.version == "V5" then
													if n26 > 9538 then
														while true do
														end
													else
														tbl20.version = "V6"
														position = nil
														cFrame = nil
													end
												elseif 1186 > n29(4556) then
													tbl20.version = v84[46]
												else
													while true do
													end
												end

												TextButton2.Text = tbl20.version
												fn29()
											end)
										end
									end

									do
										local v85 = fn34(v84[58])

										fn31("TextLabel", {
											Size = UDim2.new(v84[40], -84, 1, v84[38]),
											Position = UDim2.new(0, 12, 0, 0),
											BackgroundTransparency = 1,
											Text = "Keybind",
											TextColor3 = color4,
											Font = Enum.Font.GothamBold,
											TextSize = v84[15],
											TextXAlignment = Enum.TextXAlignment.Left,
											ZIndex = 6,
											Parent = v85,
										})

										TextButton = fn31("TextButton", {
											Name = "KeybindBtn",
											AnchorPoint = Vector2.new(v84[40], 0.5),
											Position = UDim2.new(1, -v84[29], v84[54], 0),
											Size = UDim2.fromOffset(68, 24),
											BackgroundColor3 = Color3.fromRGB(v84[68], 4, 20),
											BackgroundTransparency = 0.3,
											Text = tbl20.keybind or v84[1],
											Font = Enum.Font.GothamBlack,
											TextSize = v84[2],
											TextColor3 = color2,
											AutoButtonColor = false,
											ZIndex = 7,
											Parent = v85,
										})
									end
								end

								do
									fn32(6, TextButton)

									do
										local UIStroke = fn31("UIStroke", {
											Thickness = v84[40],
											Color = color3,
											Transparency = 0.5,
											Parent = TextButton,
										})

										local flag19 = false

										TextButton.MouseButton1Click:Connect(function()
											if flag19 then
												return
											end
											flag19 = true
											flag18 = true
											TextButton.Text = "..."
											TextButton.TextColor3 = color4
											tbl11.to(UIStroke, tbl11.Presets.Snappy, { Transparency = 0.1, Color = color2 })
											local connection = nil

											connection = UserInputService.InputBegan:Connect(function(input)
												local flag20 = input.UserInputType == Enum.UserInputType.Keyboard
												local pos = input.UserInputType.Name:find("Gamepad")

												if flag20 or pos then
													connection:Disconnect()

													if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonSelect then
														TextButton.Text = tbl20.keybind
														TextButton.TextColor3 = color2
													else
														local name = input.KeyCode.Name
														tbl20.keybind = name
														TextButton.Text = name
														TextButton.TextColor3 = color2
														fn29()
													end

													flag19 = false
													flag18 = false
													tbl11.to(UIStroke, tbl11.Presets.Snappy, { Transparency = 0.5, Color = color3 })
												end
											end)
										end)
									end
								end

								do
									local function fn37(arg, arg2)
										if not arg2 or arg2 == "" or arg2 == "None" then
											return false
										end
										local flag19 = arg.UserInputType == Enum.UserInputType.Keyboard
										local pos = arg.UserInputType.Name:find("Gamepad")
										if flag19 or pos then
											return arg.KeyCode.Name == arg2
										end
										return false
									end

									UserInputService.InputBegan:Connect(function(input, gameProcessed)
										if flag18 then
											return
										end
										local flag19 = not gameProcessed

										if flag19 and fn37(input, tbl20.keybind) then
											fn36()
										end

										if flag19 and input.KeyCode == Enum.KeyCode.RightControl then
											tbl20.guiVisible = not tbl20.guiVisible
											Frame.Visible = tbl20.guiVisible
										end
									end)
								end
							else
								while v84[66] do
								end
							end
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

fn14(100, v3[fn2("n\218\192\176\129w\151\190\193\1756", 21845944094585)], v3[fn2("-\209 \r\161\128\30\181)\162\169\194\240\156\19Ȣs\0212\188p\207(\188\240\176\157\230\2\142\167\11\226\159&\233", 10693721171687)] .. v32(v65), Color3[v3[fn2("\211\207k", 18772801209419)]](1, 0, 0), v3[fn2(" `\4\162\157", 18561267614598)])