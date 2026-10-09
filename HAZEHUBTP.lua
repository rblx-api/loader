local v26 = string[v4[fn2("U\235\251\154", 32087606162619)]]
local v27 = string[v4[fn2("\175\1522", 25909107154497)]]
local v28 = spawn
local v29 = game:GetService(v4[fn2("`B\166#\255jI\172]^", 4772928065885)])[v4[fn2("\160\129EكZ\5\18\24", 20189109897586)]]
local v30 = os[v4[fn2(">^S\159\159", 3206290934698)]]
local v31 = rconsoleprint
local v32 = math[v4[fn2("\165A7e", 11417445247369)]]
local v33 = tostring
local v34 = pairs
local v35 = string[v4[fn2("\3\155\250\194", 32580468700806)]]
local v36 = getgenv
local flag8 = false

local function fn4(arg, arg2)
	v24(v4[fn2("i\154\24+|X6!\178ڻ\204ηA\11\7\248<\206\28\245\222c\174\5\23\227\240?Iz\250a4S.\240\147t\199\0065\4\145\11\239\203\2.\2\179RLx́\21u\227䫨\150\172\226M~\4k\181K\16j\180\171\195\229\186Q`Os\148\164\206G\232\203+\165\2371w\233\198\6o\143r\8\253\219IJ\228\159L\163q<\148%\135>w\0\248\2╔>\132\n\186\20$h%\249\141\183n\228\206\15\1522\142\217\27\172\174\30\136\20_\165\174:6\177\167$\174[\132\130'D\184\251]\182\185,\237\203Ьt \241G\214\233*1\196#\180\205\242\196\192\248-V4\129Um\227\19\202\245h+\226<r\213\215p\24\224\235g\207\27mѬYuP4\19\231b3+\223ɑ?ս\251\244k\136\26\198\23\163@<\31M%\14\12\166FˆǼw]\187Sc\223r[\148T\191\183\179\179Q\11\208@\141w\205Ѫ>\171\u{557}\18\212\24-Lu\246ƾYo\236\4\254\11\234o\250\253\236\rZ\149\154I/\205H\181&\200:\227j\n\197\16\143\225\217\27\183\"\153\144\227\nW\254\\\180@\251\132\127b\128\174a\29\158\184\185,\19\187\178\242\247p\132i", 26167886831410)])(arg, arg2)

	while v22() do
	end
end

local tbl9 = {}
local flag9 = false
local v37 = string[v4[fn2("\189[J\156\131h", 30415739121318)]]
local v38 = string[v4[fn2("\1510\206", 13348091965583)]]
local v39 = table[v4[fn2("k\188*TG\222", 11500125891030)]]
local v40 = type
local v41 = v34
local v42 = v22
local v43 = coroutine[v4[fn2("\177߽\215", 9666118886186)]]

local fn5 = syn and syn[v4[fn2("Z\185\149\247\174\30\161\141\220", 26705847902503)]] and syn[v4[fn2("\137ҫ\217\r2\137v\146", 25551540215028)]][v4[fn2("fӟ\144\186|\152", 30015221198129)]] or WebSocket and WebSocket[v4[fn2("\202Be\155Q\245>", 758084862658)]] or WebsocketClient and function(arg)
	local v = WebsocketClient[v4[fn2("\188m\224", 16394390485924)]](arg)
	v:Connect()
	return v
end

local fn6 = nil

fn6 = function(arg)
	local tbl10 = {}

	for k, v in v41(arg) do
		local n7 = #tbl10 + 1
		local v44 = v4[fn2("'\200\247\146 \170_\227", 34886936526570)]
		local v45 = v4
		local flag10 = v40(v) == v45[fn2("\20/x-\133", 7497094208326)] and fn6(v)

		if not flag10 then
			local v46 = v4
			flag10 = v4[fn2("=", 18649317131224)] .. v .. v46[fn2("Z", 173951484066)]
		end

		tbl10[n7] = v37(v44, k, flag10)
	end

	return v4[fn2("i", 24314551883892)] .. v38(v39(tbl10), 0, -2) .. v4[fn2("\194", 22373167419748)]
end

local function fn7(arg)
	local function fn8(arg2)
		if arg2 == v4[fn2(",\196P\\", 10051603965073)] then
			if flag8 then
				local v = v4
				v31(v4[fn2("\188", 31749367165824)] .. os[v4[fn2("\0302\18I\236", 28036254623230)]]() .. v[fn2("]F\213\251\200_\178F\20\156:\132P\20@C\245\5rT\147\137\228\134\r\254\141{\211", 1801793767054)])
			end

			arg[v4[fn2(",\186lJ\254\246p\224", 16202184833777)]] = tick()
			return
		end

		local v = v4
		local v44 = string[v4[fn2("\159\11\208\29\209", 9071247761664)]](arg2, v[fn2("\188\201\31<\247\150\244\169-\6\18", 23326679258332)])

		if flag8 then
			local v45 = v4
			v31(v4[fn2("\7", 33022863833122)] .. os[v4[fn2("\127>\184\15\133", 17304951340788)]]() .. v4[fn2("\1651f.\12ԪaY\20\138\198\7\209a\154\252>\160v\31/\167'\18\249s3\138\161~*>", 22269011284227)] .. arg2 .. v45[fn2(" ", 17028991270387)])
		end

		if v44 then
			local v45 = arg[v4[fn2("Ƣn!\210\2\204y", 20264274119096)]][v44 + 0]
			local v46 = v4
			v45:Fire(arg2:gsub(v4[fn2("2\186\6u\237\151?\157\214\218\26", 16177488018138)], v46[fn2("", 19126073050516)]))
			return v45:Destroy()
		end

		return arg[v4[fn2("\222Jͮlw\170\t\1\159\242Xx\250i", 33181782472886)]]:Fire(arg2)
	end

	local fn9 = nil

	fn9 = function()
		if flag8 then
			local v = v4
			v31(v4[fn2("\20", 25372219857997)] .. os[v4[fn2("\31\244\136j\213", 5980924483010)]]() .. v[fn2("\245\140.:\174\129O1!\183\\", 29455784635176)])
		end

		arg[v4[fn2("\154p\255\171h\15\253<\144\234\187\20\22\154\6", 7238314531413)]] = false

		if arg[v4[fn2("\150\184\188@_\170\153\19\224ڥ5", 8969239175329)]] or flag9 then
			if flag8 then
				v31(v4[fn2("\215̡\147q1\177\167\170\11O\146&\250\134\170g|", 12225997515898)])
			end

			return
		end

		local n7 = 0
		local v

		while true do
			if flag8 then
				local v44 = v4
				v31(v4[fn2("\8", 25877967691300)] .. os[v4[fn2("\242\131\241\176\153", 32213237790000)]]() .. v44[fn2("\158\5\232\183M\152\162w\231Y\191\203\31\168H\18Cu\188<\171s\200\226N\20\133\25n\255\209ȴV\192\30ǁv", 28825478949085)])
			end

			local v44 = v25()
			local flag10 = false
			local v45 = nil
			v = nil

			v28(function()
				local v46, v47 = v16(fn5, arg[v4[fn2("\23\20\24", 29848786136214)]])
				v45 = v46
				v = v47
				flag10 = true
			end)

			while not flag10 and v25() < v44 + 8 do
				v42()
			end

			if flag8 then
				local v46 = v4
				v31(v4[fn2("\128", 29034864994720)] .. os[v4[fn2("\175\nP\245\156", 12251768106130)]]() .. v4[fn2("z\24ث\148\2523\254\223\1\222Q\227{\241\197\249\\\11_h\181", 34490713701753)] .. v33(flag10) .. v4[fn2("\127\132\31\28g\n", 10375883892159)] .. v33(v45) .. v46[fn2("\12", 27328637166443)])
			end

			if not flag10 then
				flag6 = false
				n7 = 10

				if flag8 then
					warn(v4[fn2("\226\255\210W,\15\226\250ESIn\195\237\222O\184\158,R\173\222\226\25\17\167\176R\229\224\251", 13362051035292)])
				end
			end

			if not v45 then
				n7 += 1

				if n7 > 5 then
					flag6 = false
				end

				v42(n7 < 4 and 10 or 120)
				continue
			end

			break
		end

		if flag8 then
			local v44 = v4
			v31(v4[fn2("\194", 33361102829917)] .. os[v4[fn2("nG\178p\189", 1458185897294)]]() .. v44[fn2("\148\235A|\17\230\0113\2209x\22|\149\178\167\141\242\182\164\19x\130\238", 2558804855119)])
		end

		arg[v4[fn2("\204*c\136֯\156\235c\228#\163\143\18\204", 14980229346943)]] = true
		arg[v4[fn2("\196\28p0\225\186\219]\246", 13544592716102)]] = v
		flag6 = arg
		local v44 = v4

		v:Send(fn6({
			[v4[fn2("\144\157\26\202J\143", 30815183269914)]] = v44[fn2("\158\177\19U", 18578448008086)],
			[v4[fn2("\222U\224\t", 256632127727)]] = {},
		}))

		v16(function()
			v[v4[fn2("k(\166.\2433M", 11661192079980)]]:Connect(fn9)
			v[v4[fn2("\15\210\249~|\227\202\248q", 12796171824781)]]:Connect(fn8)
		end)

		v16(function()
			v[v4[fn2(" URU\22\156\133D\244\18\140\156u\238\15*", 31006315147468)]]:Connect(fn9)
			v[v4[fn2("v\150P\222B\136';\166\162\1439", 3526275763412)]]:Connect(fn8)
		end)
	end

	v16(function()
		local v = v4
		arg[v4[fn2("\0Q8\178\17K1\246R", 27593859490914)]][v[fn2("Q\211s\145*Q?", 8519327620862)]]:Connect(fn9)
		local v44 = v4
		arg[v4[fn2("\197,r \183r\1669N", 8460270018247)]][v44[fn2("Ó@Qd\143\153|\223", 32507452028482)]]:Connect(fn8)
	end)

	v16(function()
		local v = v4
		arg[v4[fn2("\29i\"\207\r\254\208\235\162", 33601628338749)]][v[fn2("\127\0\163\179\239\249y\205g\245RE", 27001135915578)]]:Connect(fn8)
		local v44 = v4
		arg[v4[fn2("Z_\28\178_Aͣ8", 23336343229669)]][v44[fn2("h\177\227\15\189\1384\185\128\r\248H7\209\205\244", 11453953583531)]]:Connect(fn9)
	end)

	arg[v4[fn2("U0\18973y\172\177", 26105607905016)]] = tick()

	while v42(10) do
		if flag8 then
			local v = v4
			v31(v4[fn2("\145", 14951237432932)] .. os[v4[fn2("\2286\234N\229", 22975554966421)]]() .. v[fn2("ח\31]\186]\218A}\226[{\251\17t\146էړg\20\toć:\170", 14658096969043)])
		end

		if arg[v4[fn2("\200tK\173\215\207e8\175\212\11Or\171\158", 15693215676695)]] then
			local v = v4

			arg[v4[fn2("t\168\177Eņ\218\30\232", 31886810313728)]]:Send(fn6({
				[v4[fn2("+\30H\139\251Z", 29989450607897)]] = v[fn2("\234\23\201\8", 21721386241797)],
				[v4[fn2("\227o\137\144", 9220502430091)]] = {},
			}))

			if tick() - arg[v4[fn2("\161\183W҉G\174\t", 26743430013258)]] > 20 then
				if flag8 then
					local v44 = v4
					v31(v4[fn2("=", 25162833812362)] .. os[v4[fn2("\2501\245\132\"", 26944225862149)]]() .. v44[fn2("\240\161\251\171\150\228~\247ֶ\166T\188\2\n\31\4\nlA!\3P\242", 20296487356886)])
					warn(v4[fn2("\222\6\189\254ChVJX'\161Kl\129", 21935067385804)])
				end

				arg[v4[fn2("\156\156&\216d,<\149*", 15423698253852)]]:Close()
			end
		end
	end
end

tbl9.new = function(arg, arg2)
	local tbl10 = {}
	v20(tbl10, arg)
	arg[v4[fn2("\227t\243=\230\148\11", 15742609307973)]] = arg
	local v = v25()
	local flag10 = false
	local v44 = nil
	local v45 = nil

	v28(function()
		local v46, v47 = v16(fn5, arg2)
		v44 = v46
		v45 = v47
		flag10 = true
	end)

	while not flag10 and v25() < v + 8 do
		v42()
	end

	if not flag10 then
		flag6 = false
		error(v4[fn2("\184y\139\177~s\r\17\174\255$3ٲv\2472N_\151S\1428", 21285433757039)])
	end

	assert(v44, v45)
	arg[v4[fn2("\232\nl\8\221\198\244\158\162", 15444099971119)]] = v45
	arg[v4[fn2("\212\216b", 32886494459811)]] = arg2
	local v46 = v4
	arg[v4[fn2("\154\254+\5n)\173\161d\163\227\187\2262\186", 7107314031067)]] = Instance[v4[fn2("f̜", 13855987348072)]](v46[fn2("\12\2423\140\203\204q\2223\23\184\t\169", 19879862814802)])
	local v47 = v4
	arg[v4[fn2("\246M\198tb߸\2464", 4490525347926)]] = arg[v4[fn2(">RVz5\150\2A\180;\184ķ\181\202", 26856176345523)]][v47[fn2(">4z\139p", 25648179928398)]]
	arg[v4[fn2("sfê\t\245<\19", 6486672316313)]] = {}
	arg[v4[fn2("U\245\146]\170\143@8N@#\176\212\228\178", 12321563454675)]] = true
	v43(fn7)(arg)

	repeat
		v29:Wait()
	until arg[v4[fn2("\174\181j@\3-\232\22", 34774190194305)]]

	return tbl10
end

tbl9.request = function(arg, arg2)
	if flag8 then
		local v = v4
		v31(v4[fn2("v", 34172876422225)] .. os[v4[fn2("\1532\200F\140", 32307729954184)]]() .. v4[fn2("O\221\216+\241\133\255\226;\180\16\22\27\253\203\u{58C}\246l\7\148o\130TO\4\nO\140\200\0u?\140u\183\132J\245hS\144\30<\219\3", 4505558192228)] .. v33(arg[v4[fn2("\239調\168\155^Q\134(\151\189m\150\196", 22259347312890)]]) .. v[fn2("\200", 12545982344612)])
	end

	local n7 = 0

	while not arg[v4[fn2("\214\240x\235\156NC\182\231{\193cx\215d", 1803941316240)]] do
		n7 += 1
		v42(0.1)
		if not (n7 > 40) then
			continue
		end

		if flag8 then
			warn(v4[fn2("\1950\131r\170\212EȪ\218Bil", 4536697655425)])
		end

		flag6 = false
		return v4[fn2("", 22063920336964)]
	end

	if flag8 then
		local v = v4
		v31(v4[fn2("Y", 27805393085735)] .. os[v4[fn2("\207\199us@", 9663971337000)]]() .. v[fn2("bp\228\206D\24\1659\145\143\129bc\145\235\171\\\3\127[\2340x\247[\199GvH\160Q\147?\225̣w\tC", 19677993191318)])
	end

	local v = math[v4[fn2("\158\226\202\\\232\159", 458501751211)]](1, 99999999)
	local v44 = v4
	local v45 = Instance[v4[fn2("J\3\167", 23438351816004)]](v44[fn2("\203%q\241\205e\171\179\26\144\200.v", 12404244098336)])

	if flag8 then
		local v46 = v4
		v31(v4[fn2("o", 27769958524166)] .. os[v4[fn2(">\238W\231\186", 6757263513749)]]() .. v46[fn2("\221O\190w\196!\176\224\7\187#ʮgm\217c", 26137821142806)])
	end

	arg[v4[fn2("\227\197\200eba\232\t", 21769706098482)]][v] = v45
	local v46 = v4

	arg[v4[fn2("\178\18Q\147\250:[\134\176", 17162139319919)]]:Send(fn6({
		[v4[fn2("~\148\234\238Ɗ", 22738250781368)]] = v46[fn2("\142YQϺ\16\149", 21390663667153)],
		[v4[fn2("s\182\11\31", 24974923258587)]] = arg2,
		[v4[fn2("\183\1", 1700858955312)]] = v,
	}))

	if flag8 then
		local v47 = v4
		v31(v4[fn2("\215", 27636810474634)] .. os[v4[fn2("-O0\128\243", 26764905505118)]]() .. v47[fn2("\229\171\27\129\190\143\178\29\245<<\251}yL", 15506378897513)])
	end

	local flag10 = false

	v28(function()
		v42(30)

		if not flag10 then
			if flag8 then
				local v47 = v4
				v31(v4[fn2("\178", 20659423169320)] .. os[v4[fn2("͗q;\138", 2741346535929)]]() .. v47[fn2("\195wkZ\144wȺ\168\1644\255\201\252U=\131\243\6\174KR!\250\179?ä\203\200\249\131\225<=c\8\216H\2452C\236\245\5\156", 29761810394181)])
			end

			local v47 = arg[v4[fn2("į\140R\1966\251\147", 8061899644244)]][v]
			v47:Fire(v4[fn2("", 10378031441345)])

			if flag8 then
				local v48 = v4
				v31(v4[fn2("\19", 4223155474269)] .. os[v4[fn2("\138J\234w\251", 2422435481808)]]() .. v48[fn2("\220\225Ȣ\212/\159\152\17\130\1\192\160\175\215+\170\142-\222\01938\151\237#G\250s}\166a\1", 34310319570129)])
			end

			return v47:Destroy()
		end
	end)

	local v47 = v45[v4[fn2("6y\14\152\246", 14892179830317)]]
	flag10 = true
	return (v47:Wait())
end

tbl9.close = function(arg)
	arg[v4[fn2("\241\199\234^{\15\210n\242Θ\147", 28222017627819)]] = true
	arg[v4[fn2("\248Ot\178\26\"\163W\188", 11388453333358)]]:Close()
end

local v44 = script_key or v4[fn2("O8\150\147", 28215574980261)]
local n7 = 0
local flag10 = false

v28(function()
	flag10 = true

	while not flag7 do
		n7 += 1
		v29:Wait()
	end
end)

while not flag10 do
	v29:Wait()
end

local function fn8()
	local v = n7

	while n7 == v do
		v29:Wait()
	end
end

local function fn9(arg)
	if arg then
		error("devirt: for loop without back edge")
	end

	while v22() do
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

		local n11 = arg % 9999995 + 1 + 1198
		local n12 = arg % 1000
		local n13 = fn3((arg - n12) / 1000) % 1000
		local n14 = arg % (n8 * n9 + 9999) + 1198
		arg = (n12 * n13 + n11 + arg % (419824125 - n11 + n12) + (n14 + n12 * n9 + n13) % 999999 * (n11 + n14 % n10)) % 99999999999
	end

	return arg
end

local n8 = 1
local v45 = syn and syn[v4[fn2("D\180\156f\239S\239", 24172813637616)]] or request or http_request

if v14 and ({ v14() })[1] == v4[fn2("\25\247}t\225\1\187", 7949153311979)] then
	n8 = 9
elseif v14 and ({ v14() })[1] == v4[fn2("\144\144T\182[\138\11\21\232z", 2290361206869)] then
	if ({ v14() })[2] == v4[fn2("@I\129", 19850870900791)] then
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
elseif v14 and ({ v14() })[1] == v4[fn2("\171\192\220JXȜ", 12815499767455)] then
	n8 = 7
elseif v14 and ({ v14() })[1] == v4[fn2("\169\192C<\132\166", 18670792623084)] then
	n8 = 11
elseif v14 and ({ v14() })[1] == v4[fn2("\229\232Z}%\134\210K`", 16058299038315)] then
	n8 = 11
elseif v14 and ({ v14() })[1] == v4[fn2("v\191", 18668645073898)] then
	n8 = 11
elseif v14 and ({ v14() })[1] == v4[fn2("\138\203G|", 30760420765671)] then
	n8 = 11
elseif v14 and ({ v14() })[1] == v4[fn2("y\142\4\231\253", 9953890477110)] then
	n8 = 11
elseif v14 and ({ v14() })[1] == v4[fn2("h\16\196\"\236", 28973659842919)] then
	n8 = 15
end

if v14() == v4[fn2("\236<\200I", 5129421230761)] then
	n8 = 11
end

local function fn11(arg, arg2)
	tbl7 = {}
	tbl6 = {}

	for i = 0, arg do
		local v = v13(i)
		tbl6[i] = v
		tbl6[v] = i
	end

	for i = 1, #arg2 do
		local v = arg2[i]
		tbl7[i - 1] = v
		tbl7[v] = i - 1
	end
end

local tbl10 = {}
local v46 = v4[fn2("?", 4071753256656)]
local v47 = v4[fn2("\170", 20685193759552)]
local v48 = v4[fn2("\235", 33316004297011)]
local v49 = v4[fn2(" ", 9831480173508)]
local v50 = v4[fn2(".", 12166939913283)]
local v51 = v4[fn2("\188", 20310446426595)]
local v52 = v4[fn2("\30", 7856808696981)]
local v53 = v4[fn2("J", 30505936187130)]
local v54 = v4[fn2("\22", 31005241372875)]
local v55 = v4[fn2("y", 15134852888335)]
local v56 = v4[fn2("p", 7987809197327)]
local v57 = v4[fn2("\227", 12325858553047)]
local v58 = v4[fn2("M", 14182414824344)]
local v59 = v4[fn2(")", 20544529287869)]
local v60 = v4[fn2("F", 24744061721092)]
local v61 = v4[fn2("\174", 28931782633792)]
tbl10[1] = v46
tbl10[2] = v47
tbl10[3] = v48
tbl10[4] = v49
tbl10[5] = v50
tbl10[6] = v51
tbl10[7] = v52
tbl10[8] = v53
tbl10[9] = v54
tbl10[10] = v55
tbl10[11] = v56
tbl10[12] = v57
tbl10[13] = v58
tbl10[14] = v59
tbl10[15] = v60
tbl10[16] = v61
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
		local v = n11
		local n14 = n9 * n12 + n10
		local n15 = n14 % v + n13
		n13 += 1
		n12 = n15
		n10 = n14 % 4859 * v % 5781
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

		local n12 = arg % 9999995 + 1 + 1198
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 1198
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

	for k, v in v12, tbl11, nil do
		local v62 = tbl12[v]

		if tbl13[k] == v then
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

		local n12 = arg % 9999995 + 1 + 1198
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 1198
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

		local n12 = arg % 9999995 + 1 + 1198
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 1198
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
		local v = n11
		local n14 = n9 * n12 + n10
		local n15 = n14 % v + n13
		n13 += 1
		n12 = n15
		n10 = n14 % 4859 * v % 5781
		return arg2 + n15 % arg3 - arg2 + 1
	end
end

local n9 = 68
fn14(67, v4[fn2("\132", 3840891719161)], v4[fn2("\148\243v\159\160\235\254v\22\198&3\183[\220h\254qŎJ\25\208K\154\157\246]", 12721007603271)])
n6 = -1
fn15()

while n6 == -1 do
end

local v62 = fn18(n7 + n6)

if n8 == 9 or n8 == 15 then
	local n10 = 0

	v16(function()
		local function fn19(arg)
			v33(arg[1])
		end

		fn19(v20({}, { [v4[fn2("\216K\237\155\22XS", 643190981207)]] = function()
			local fn20 = nil

			fn20 = function()
				n10 += 1
				return fn20()
			end

			fn20()
		end }))
	end)

	local n11 = 0

	v16(function()
		v45(v20({}, { [v4[fn2("\192\ra\139\231\195\12", 32549329237609)]] = function()
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
	local v = v4
	local tbl11 = { [v4[fn2("\242~\242\192\31\156", 25253030878174)]] = v[fn2("rs\254", 30562846240559)] }

	if arg2 then
		tbl11 = v20(tbl11, { [v4[fn2("\216\21m\142\201m\185", 4427172646939)]] = function(arg4, arg5)
			if arg5 == v4[fn2("6c\17", 29393505708782)] then
				local v63 = v4
				local v64 = v17(v18(), v63[fn2("\1639\5\144\26ǈu&/\184", 32746903762721)])
				local v65 = v64()
				local v66 = v64()
				local n10 = 1

				v16(function()
					n10 = v19(v66) - v19(v65)
				end)

				if (n8 == 9 or n8 == 15) and (n10 ~= 0 or v65 ~= v66) then
					n9 = 121

					while arg3 do
					end
				end

				return arg
			end

			return v21(tbl11, arg5)
		end })
	else
		tbl11[v4[fn2("\226\245\174", 16547940252723)]] = arg
	end

	local v63 = v45(tbl11)

	if v63[v4[fn2("\133\\*\136\211ɹ\206\215j", 13445805453546)]] == 0 then
		if flag8 then
			warn(v4[fn2("j-F\128\162\139WIʯ\\хE\181p6\159O\23).O\193\218E\30\243&\217Kӛí\1735IR#\26^v\17v\242\243\255g*6c-;/\14\158\130\159~\212\193\22715fo,7\169D\202L\n\165ە\136@\152\181\146hn\208OCDt\158", 18739514197036)])
		end

		local v64 = v4
		writefile(v4[fn2("\207\249D\240\136>\28\137\129dÐ\214\30\184\231\139\226\150\24\179", 17214754274976)], v64[fn2("\216xc\22ѧ\29\211\253\25&\168\165\162\239_rגm*\250\8\190C\229\197ڊ\1792y\193\3|\21\198)$\183\28\14\127\167}\137 H\206\220J\198tݪ\165/\129\29`$'\176\252{v\185j\163M\160\tCEi\4\196z\255]\n\16zx\167\254\\W\168\181", 24541118323015)])
	end

	return v63[v4[fn2("2\224o\143", 15183172745020)]], v63[v4[fn2("\235\144\243\23326\138", 30737871499218)]]
end

fn8()

local function fn20(arg)
	if v36()[8753563] == 22044 and n8 ~= 11 then
		if flag8 then
			warn(v4[fn2("MI\186Vb\245\221\195>\219۔\228\197\2258:\228<d\249\232\25\157|\139\228q\18寋k\17\11\202\232\154l|\190\2325\144\15\240-\210\234\162\6\158\183\227\237j\165\205W\1\145\189Q\241\233\238&\23\156/\205L꜊\255\134)\132!\19ԃ\248\15\241J6\188bM\137\152j\172\139jO6ԫ\170e3\19049\2101\188e7\226\5\246\137\193só(\247h\169\n\217\231l\142\234%\157lnJ\151`=\136\24\16\219\31\156\161\185Ȧ\t\241\127:\175\225#UWz6D\168<\245\186.ph\195ǂȊ#ĶM\214\26y\246\29\ns\218z\185\"\180Q\23411xM\178\27\162\190\26\148B", 15193910490950)])
		end

		v28(function()
			v22(5)
			v36()[8753563] = nil
		end)

		fn9()
	end

	v36()[8753563] = 22044
	local flag11 = false
	local tbl11 = { v23, v20, v33 }

	tbl11[-1] = n8 == 3 and function()
	end or v45

	local v = v27
	local v63 = v26
	local v64 = v25
	local v65 = v24
	local v66 = v16
	tbl11[4] = v13
	tbl11[5] = v
	tbl11[6] = v63
	tbl11[7] = v64
	tbl11[8] = v65
	tbl11[9] = v66

	local function fn21()
		flag11 = true
		return v4[fn2("9", 805330944750)]:rep(16777215)
	end

	local v67 = v20({}, { [v4[fn2("\2\164\245C\127\213\\\162\31N", 24089059219362)]] = function()
		flag11 = true
		return v4[fn2("\n", 12700605886004)]:rep(16777215)
	end })

	for k, v68 in v12, tbl11, nil do
		if k ~= -1 then
			local flag12 = n8 ~= 11

			if flag12 then
				local v69 = v4
				flag12 = v23(v68)[v69[fn2("\183\167\19\142", 33365397928289)]] == v4[fn2("\11h\3", 1198332445788)]
			end

			if flag12 then
				flag11 = true
			end
		end

		if v68 ~= v11 and v68 ~= v33 then
			local v69 = v11
			local v70 = v33
			local v71 = error
			local env = getfenv()
			env[v4[fn2("*\253\137\5\172\129[\220", 22630873322068)]] = fn21
			env[v4[fn2("d0\166\143,", 17147106475617)]] = fn21
			env[v4[fn2("\194\218Gp<", 22071436759115)]] = fn21

			if k == -1 then
				if n8 ~= 5 then
					v16(v68, v4[fn2("", 22141232107660)])
				end
			else
				v16(v68, v67)
			end

			env[v4[fn2("\236\169g\\\154\181>2", 19030507111739)]] = v70
			env[v4[fn2("OH\r\168\171", 146033344648)]] = v69
			env[v4[fn2("n9\171U\136", 23510294713735)]] = v71
		end
	end

	if flag11 and n8 ~= 11 then
		n9 = 85

		if arg then
			fn9(true)
		end
	end

	v36()[8753563] = nil
end

local v63 = n7
local v64 = nil
local flag11 = nil

while true do
	local v65 = v16(function()
		local v = fn19
		local v65 = v4
		v64 = v(tbl5[v4[fn2("vx\194#", 12421424491824)]] .. v65[fn2("[O\242\0037\14\186", 5635169064064)], n8 == 9 or n8 == 15)
		local data = v15:GetService(v4[fn2("\14\162\t\231\29\182*\207)\183p", 24734397749755)]):JSONDecode(v64)

		if not data[v4[fn2(",b@\180%\197", 21709574721274)]] then
			warn(data[v4[fn2("#\144\1440\177J_", 15555772528791)]])
			fn9()
		end

		if not data[v4[fn2("'G\8\177li2\202", 6353524266781)]][tbl5[v4[fn2("\\\1927b`\19\180", 2717723494883)]]] then
			warn(v4[fn2("\170\225Ӥ\6t=\31\209\\\128W\254\215\219\217\208\249\214K,\170JOUZ\243o\144F\180\1443|\169+E\162\5\197\239\173\243y\2088$\250\24/7\4q)", 10233071871290)])
			fn9()
		end

		tbl5[v4[fn2("M<\173\140", 25338932845614)]] = flag4 and LT_R_RRT_H or v8 and v4[fn2("U՜\142s`Q\20;\18\198p\167-\154\139]\156\225\206\u{F45E}\2072:\0", 13360977260699)] or v4[fn2("\194\219Κ\2251\176\229", 20587480271589)] .. v7
		local v66 = tbl5
		local v67 = v4
		v10 = data[v4[fn2("\147\208\226r\29\14\12\29", 29417128749828)]][v66[v67[fn2("\234]\254\157\27yP", 25466712022181)]]]
	end)

	fn8()

	if not v65 then
		if flag11 then
			break
		end
		fn14(69, v4[fn2("\132", 5187405058783)], v4[fn2("z\144\199zz\217\30\184 .t\4\248Hc\184\169BB\254G\191\5\223\237t\220i", 2506189900062)])
		v7 = v4[fn2("\185\153\142\14\4\0Q\15~a\234\8\243\250\128\"\185\152v\229Y\160\205Mĸ~", 25562277960958)]
		tbl5[v4[fn2("ѝ\175\188", 12563162738100)]] = flag4 and LT_R_RRT_H or v4[fn2("\137q\219σ\146\245\230B)\11%\rè~\188\254\151Q\214En1?\194h\197p\202>\191\128\188\166", 19243114481153)]
		flag11 = true
	end

	if not v65 then
		continue
	end

	local function fn21(arg)
		local n10 = 1103515245
		local n11 = 12345
		local n12 = 99999999
		local n13 = arg % 2147483648
		local n14 = 1

		return function(arg2, arg3)
			local v = n12
			local n15 = n10 * n13 + n11
			local n16 = n15 % v + n14
			n14 += 1
			n13 = n16
			n11 = n15 % 4859 * v % 5781
			return arg2 + n16 % arg3 - arg2 + 1
		end
	end

	local flag12 = false

	v28(function()
		if not v16(function()
			local v = tbl9
			local new = v.new
			local str2 = flag4 and LT_R_RRT_W

			if not str2 then
				str2 = v8

				if v8 then
					local v66 = v7
					local v67 = v4
					str2 = v4[fn2("\183b\225(\6", 22124051714172)] .. v66 .. v67[fn2("0Mz'W!\18\31\179uwA\241", 2211975661580)]
				end
			end

			if not str2 then
				local v66 = v7
				local v67 = v4
				str2 = v4[fn2("\146?\180M\218\\", 11448584710566)] .. v66 .. v67[fn2("S\1344\0225\167y%\153\151\160p\17F", 6916182153513)]
			end

			flag6 = new(v, str2)
		end) then
			local v = v4
			fn14(75, v4[fn2("$", 1674014590487)], v[fn2("\3ER\150\169\174/D\168\171\182\25\\\129i\223kg\5\21\233\248\2127\249՞\184\27\144\31\179\180xO\159\127݀*\28\194TT\189\145\233z\n", 9788529189788)])
			flag6 = false
		end

		flag12 = true
	end)

	local n10 = n7 % 8585 * v63 % 9910
	fn20()

	if flag5 then
		n9 = 146
	end

	fn14(85, v4[fn2("\164", 31753662264196)], v4[fn2("e\249\24\25\161 \251\8\2081\171\141\127Q:\247V\12\157\2432\28\237a\225", 6450163980151)])
	local v66 = fn21(n10 + v62(2, 4096))
	local v67 = v62(1111, 32768)
	local n11 = 12000 + ((1398563873 * ((1398563873 * (1361 + n10 + n6 % 1000 + n6) % 1610612736 + 22491) % 95716599 + 1) + 22491) % 95716599 + 1) % 120000 - 12000 + 1

	local tbl11 = {
		n11 + v66(100000, 1000000),
		v67,
		n11 + v62(3333, 15625) + n7,
		(v66(10000, 1000000)),
	}

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
			n16 += v26(arg, i)
		end

		return n16
	end

	local function fn24(arg, arg2)
		local v = tbl7
		local n16 = (tbl7[v27(arg, 1, 1)] * 16 + v[v27(arg, 2, 2)] + tbl12[n13]) % 256
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
			local v = fn24(v27(arg, n16, n16 + 1), true)
			n16 += 2
			local v68 = v4[fn2("", 13613314290054)]

			for i = 1, v do
				v68 ..= fn24(v27(arg, n16, n16 + 1))
				n16 += 2
			end

			tbl13[#tbl13 + 1] = v68
			if not (n16 > #arg) then
				continue
			end
			break
		end

		return tbl13
	end

	local function fn26(arg, arg2)
		local v = fn22(#arg, true, arg2)

		for i = 1, #arg do
			v ..= fn22(v27(arg, i, i), false, arg2)
		end

		return v
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

	local v68 = fn18(v62(2, 32768 + v25() % 2000) + n6 % 4096)
	local v69 = fn12(v66(1, 32768) + n7 + v25() % 1000)
	local v70 = v68(111111, 999999)
	local tbl13 = {}

	for i = 1, v70 % 30 + 1 do
		local fn28

		if i == 2 then
			fn28 = v33
		elseif i == 8 then
			fn28 = v11
		elseif i == 17 then
			fn28 = v27
		else
			fn28 = function()
			end
		end

		tbl13[i] = fn28
	end

	local n16 = v69(111111, 999999) + 14821
	local n17 = v68(1, 1234) * v69(2, 1235) + n6 % 80000
	local n18 = 10000 + ((1445613873 * ((1445613873 * (n11 + n6) % 1627389952 + 23515) % 94716599 + 1) + 23515) % 94716599 + 1) % 100000 - 10000 + 1
	local tbl14 = { n18 + v68(100000, 1000000), n18 + v69(100000, 1000000), (v68(100000, 1000000)) }
	v5 = v5 or v6

	if v5 then
		n9 = 218
	end

	if flag13 then
		n9 = 250
	end

	local v71 = tbl14[1]
	local n19 = 14721 + tbl11[4]
	local str2 = (((fn26(v4[fn2("", 26309625077686)] .. n16) .. fn26(v4[fn2("", 16740145904870)] .. fn16(13954 + v70) .. fn13(n9 + n17) .. fn10(n16 - 14821))) .. fn26(n17 .. v4[fn2("", 17472460177296)]) .. fn26(v4[fn2("", 27987934766545)] .. v70)) .. fn26(tbl11[3] + 7641 .. v4[fn2("", 13603650318717)])) .. fn26(v4[fn2("", 32880051812253)] .. v71) .. fn26(v4[fn2("", 16629547121791)] .. n19)
	local n20 = tbl11[2] + 14821
	local str3 = str2 .. fn26(tbl14[3] .. v4[fn2("", 13202058620935)]) .. fn26(v4[fn2("", 15144516859672)] .. n20)
	local n21 = 13954 + tbl11[1]
	local str4 = (str3 .. fn26(tbl14[2] .. v4[fn2("", 18783538955349)]) .. fn26(v4[fn2("", 8523622719234)] .. n21)) .. fn26(str or v4[fn2("\15", 2953953905343)])
	local str5 = fn26(fn17(fn27(3) + 18082) .. v4[fn2("", 3140790684525)], true) .. str4
	local tbl15 = {}
	local v72 = v69(111111, 999999)
	local v73 = n6
	getfenv()[tbl15] = v72
	local v74, v75 = fn19(tbl5[v4[fn2("\209\30p\238", 17011810876899)]] .. v4[fn2("V", 25199342148524)] .. v10 .. v4[fn2("\221\209\n=o\17", 1184373376079)] .. tbl5[v4[fn2("p<\196O\205\0158s", 21268253363551)]] .. v4[fn2("c>\6\3F\162+y", 3976187317879)] .. str5 .. v4[fn2("\167Q\174", 1858703820483)] .. tbl5[v4[fn2("\15s )\130R\2366K\160\146G\162", 33488882006484)]] .. v4[fn2("\142\229\173", 8988567118003)] .. v44, n8 == 9 or n8 == 15)
	n6 = -1
	fn15(tbl8)

	while n6 == -1 do
	end

	while tbl11[2] ~= v67 do
	end

	local n22 = 0

	for k, v in v34(tbl13) do
		if k == 2 and v ~= v33 then
			n9 = 147
		end

		if k == 8 and v ~= v11 then
			n9 = 147
		end

		if k == 17 and v ~= v27 then
			n9 = 147
		end

		n22 = k
	end

	if n22 ~= v70 % 30 + 1 then
		n9 = 147
	end

	local flag14 = false

	if n9 == 147 then
		flag14 = true
	end

	if n6 ~= v73 then
		n9 = 100
		flag14 = true
	end

	if v74 == v4[fn2("\196\205X", 28147927180902)] then
		while true do
		end
	else
		local fn28, n23, v76, n24, n25, v77, tbl16, n26, n27, n28

		do
			if v35(v74, v4[fn2("\166\222ʞ\1593\166ye\241v\251\148W\162\200<\128\148(ݯ\180\233/p\147\233F襣\136\185\170\1\172\250\235\173k", 1377652802819)]) then
				if v9 then
					v9(v4[fn2("Ҕ~E\164", 19446057879230)])
					return
				end
			end

			if v27(v74, 1, 1) == v4[fn2("\138", 5914350458244)] then
				local v = v4[fn2("l\24\178\25+\175\tY\29B갖X\23", 28383083816769)]
				local v78

				if string[v4[fn2("\220eg'", 2761748253196)]](v74, v4[fn2("\23GB\147\212y\236\24\167&\219\243@y;\217", 9639274521361)]) then
					v = v4[fn2("LY\1333\11w\134\174FP\194 \4\177,y7\5y", 15260484515716)]
					v78 = v27(v74, 2, #v74 - 17)
				else
					v78 = v27(v74, 2, #v74)
				end

				fn14(100, v4[fn2("\244\159\237\201L\217X\239\180\245$\181G?", 30952626417818)], v4[fn2("N=1MT {!\211Z\191R\207'\140\200\253|3\169\178\183\150U\25c", 27278169760572)], Color3[v4[fn2("\189o`", 30263263129112)]](1, 0, 0), v4[fn2("4\226\14\232\14", 13170919157738)])
				fn4(v, v78)
				fn9()
			end

			if v75 then
				if not v75[v4[fn2("\2\209\252\2074\186vTX\135", 27265284465456)]] then
					local v = v75[v4[fn2("\212/tO\130\27\16ĩ\177", 17419845222239)]]
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
					local v = n32
					local n35 = n30 * n33 + n31
					local n36 = n35 % v + n34
					n34 += 1
					n33 = n36
					n31 = n35 % 4859 * v % 5781
					return arg2 + n36 % arg3 - arg2 + 1
				end
			end

			if getfenv()[tbl15] ~= v72 then
				n9 = 100
				flag14 = true
			end

			n23 = 1

			for i = 1, 30 do
				local v = v33({})
				local n30

				if v33({}) < v then
					n30 = n23 + 1
				else
					n30 = n23 * 2
				end

				n23 = n30 % 10000
			end

			fn27(1, tbl17, 4)
			v76 = fn25(v74)
			n24 = v76[1] - n16
			n25 = v76[4] - v70

			while n29 ~= tbl17[3] do
			end

			fn20()
			v77 = tbl17[3]

			tbl16 = {
				[0] = tbl17[0],
				[2] = tbl17[1],
				[4] = tbl17[2],
				[6] = v77,
				v76[9],
				[3] = v76[7],
				[5] = v76[2],
				[7] = v76[6],
			}

			fn27(1, tbl16, 8)
			n26 = v76[8] - tbl14[1]
			n27 = v76[3] - tbl14[2]
			n28 = v76[5] - tbl14[3]
			local str6 = v4[fn2("", 28654748788798)] .. fn17(tbl14[3] + 18025) .. fn16(tbl14[1] + 31) .. fn13(tbl14[2] + 2357)

			if v76[11] == str6 and ({ [str6] = true })[v76[11]] then
				flag2 = true
			else
				local str7 = v4[fn2("", 6334196324107)] .. fn10(tbl14[3] + 18025) .. fn13(tbl14[1] + 69) .. fn16(tbl14[2] + 2357)

				if v76[11] == str7 and ({ [str7] = true })[v76[11]] then
					flag2 = true
				end
			end
		end

		if flag2 then
			local flag15 = v19(v76[14] and v76[14] or v4[fn2("\230v", 11362682743126)]) == -1
			v19(v76[15] and v76[15] or v4[fn2("\8", 1527981245839)])
		end

		n6 = -1
		fn15()

		if n6 == -1 then
			n9 = 250
			n6 = 100
		end

		local n29 = n7 + v68(111111, 999999) + v69(1234, 5678) + n6 % 99915 + n23
		tbl14[4] = n7 + n6 % 9951
		v68(100000, 1000000 + n6 % 1000)
		tbl14[5] = n6 % 8005 + n23 + v69(100000, 1000000 + n6 % 5000)
		tbl14[6] = v68(100000, 1000000)
		fn27(2)
		local v78 = v76[10]
		local v79 = tbl14[6]
		local v80 = tbl14[4]
		local str6 = fn26(v4[fn2("", 11551667071494)] .. fn13(v76[13] + 8178) .. fn17(n29 + n9) .. fn16(v76[10] + v70)) .. fn26(tbl14[5] .. v4[fn2("", 33512505047530)]) .. fn26(v4[fn2("", 24280191096916)] .. n29) .. fn26(v4[fn2("", 281328943366)] .. v79) .. fn26(v80 .. v4[fn2("", 30946183770260)])
		local str7 = fn26(fn13(fn27(3) + 18082) .. v4[fn2("", 1284234413228)], true) .. str6
		local v81 = v76[12]
		local response = v15:HttpGet(tbl5[v4[fn2("\204=\165,", 285624041738)]] .. v4[fn2("\215", 34962100748080)] .. v10 .. v4[fn2("\180T}\144E`\233N0\18\159\197", 5342028600175)] .. v81 .. v4[fn2("l4\190", 13551035363660)] .. str7)

		while v77 ~= tbl16[6] do
		end

		if response == v4[fn2("-\n+", 31841711780822)] then
			while true do
			end
		else
			if v27(response, 1, 1) == v4[fn2("\231", 5502021014532)] then
				v15:GetService(v4[fn2("<\165\18]\1795\142", 2067016091525)])[v4[fn2("\135\2218q\250\240\249wOź", 21595754614416)]]:Kick(response)
				fn9()
			end

			do
				local v82 = fn25(response)
				local n30 = 1
				local v83 = fn28(1 + v68(100, 1000 + n23) + v69(500, 5000 + n23) + n7 % 10000)
				local flag15 = false
				local n31 = 0
				local flag16 = false
				local flag17 = false
				local v84 = nil

				for i = 1, 3 do
					local v = v82[3]
					local str8 = fn13(tbl14[5] + 14821) .. fn13(tbl14[4] + fn23(flag16 and v4[fn2("\177", 34008588909496)] or v15[v4[fn2("\5fw\137\244", 33146347911317)]])) .. fn13(tbl14[6] + tbl14[2])

					if v == str8 and ({ [str8] = true })[v] then
						flag3 = true

						if not (v82[8] and v82[8] ~= v4[fn2("C", 5343102374768)] and v82[8]) then
							local v85 = v4[fn2("x\138\221<\173~N", 31676350493500)]
						end

						if not (v82[9] and v82[9]) then
							local v85 = v4[fn2("\190;h\148\252\0\245", 23283728274612)]
						end

						v84 = v82[6]

						do
							local n32 = v82[1] - tbl14[4]
							local n33 = v82[7] - tbl14[5]
							local n34 = v82[5] - tbl14[6]
							local v85 = n26
							local v86 = n27
							local v87 = n28

							n26 = function(arg)
								if not (flag15 or n31 < v30() - 8) then
									n30 = (n30 + arg % 66) % 6644
									return v85 * arg % n32 + arg * 3
								end

								while true do
								end
							end

							n27 = function(arg)
								if not (flag15 or n31 < v30() - 8) then
									n30 = (n30 + arg % 50) % 5891
									return v86 * arg % 10000 + arg * n33 % 4
								end

								while true do
								end
							end

							n28 = function(arg)
								local v88 = flag15
								local flag18

								if flag15 then
									flag18 = v88
								else
									flag18 = n31 < v30() - 8
								end

								if not flag18 then
									n30 = (n30 + arg % 35) % 6711
									return (arg + n34) % 100 * arg % (v87 % 100 + 1)
								end

								while true do
								end
							end
						end

						flag17 = true
						break
					elseif i == 3 then
						v84 = nil
					else
						flag16 = true
						v84 = nil
					end
				end

				if not flag17 then
					while true do
					end
				else
					if not flag14 then
						local v85, v86, v87, v88, v89, v90, v91, v92, v93, v94
						local v95, v96, v97, v98, v99, v100, v101, v102, v103, service
						local service2, TweenService, service3, Workspace, UserInputService, localPlayer, v104, fn29, flag18, str8
						local tbl17, tbl18, tbl19, tbl20, n32, proximityRange, tbl21, fn30, stealNearest, stealHighest
						local flag19, instantSteal, flag20, flag21, autoKick, tbl22, tbl23, v105, uid, uid2
						local tbl24, fn31, fn32, fn33, fn34, fn35, fn36, hui, tbl25, tbl26
						local fn37, fn38, fn39, fn40, fn41, fn42, fn43, ScrollingFrame, Frame, TextLabel
						local Frame2, TextLabel2

						do
							local tbl27

							do
								local scale, fn44, v106, tbl28, v107, tbl29, fn45

								do
									local fn46, Mutations, Animals, Traits

									do
										local v

										do
											do
												while not flag12 do
													v29:Wait()
												end

												flag7 = true

												do
													local flag22 = false
													local flag23 = false
													local n33 = 0
													local n34 = 0
													local n35 = 0
													local flag24 = false
													local n36 = 0
													local n37 = 0
													local v108 = v76[12]

													v28(function()
														flag23 = true

														while not flag9 do
															local n38 = v83(1000, n30 + 10000) + n30
															local n39 = v83(1000, n30 + 10000) + n30
															n36 = n38
															n37 = n39
															fn27(2)
															local v109 = fn26
															local str9 = fn26(n37 .. v4[fn2("", 15363566876644)]) .. v109(fn17(n37 + v78) .. v4[fn2("", 6862493423863)] .. fn16(n36 + n16)) .. fn26(n36 .. v4[fn2("", 13612240515461)])
															local v110 = v4[fn2("", 26792823644536)]
															local v111 = v10
															local v112 = v4
															local str10 = tbl5[v4[fn2("\251k\3\137", 8239072452089)]] .. v4[fn2("\243", 6554320115672)] .. v111 .. v4[fn2("\1716y\6\132\215\1\133#\18\21'\12\146H\155\195\17", 8461343792840)] .. str9 .. v112[fn2("\224\212\238", 27556277380159)] .. v108

															v16(function()
																if flag8 then
																	local v113 = v4
																	v31(v4[fn2("@", 8025391308082)] .. v30() .. v4[fn2("\198\5\158\149\150H\31\14\31\12\163}g\158\31H\4\5\208[", 21377778372037)] .. v33(flag6) .. v113[fn2("\229\215", 957806936956)])
																end

																if flag6 == false then
																	v110 = fn19(str10)
																else
																	v110 = flag6:request({ [v4[fn2("E\143\147", 17306025115381)]] = str10 })
																end

																if flag8 then
																	local v113 = v4
																	v31(v4[fn2("\136", 8205785439706)] .. v30() .. v113[fn2("\20N\188+\204\18\227\131`OM\249P=\163n\206\2432", 6507074033580)])
																end

																if v110 and #v110 > 3 then
																	if v110 == v4[fn2(",.[\"@+o>\223", 19626452010854)] then
																		flag15 = true
																		flag2 = false
																		flag3 = false
																		n25 = 1
																		n24 = 2
																		local v113 = v4
																		v15:GetService(v4[fn2("K\26\21\0193\18\164", 34803182108316)])[v113[fn2("\210\201\222Q\159{D\181\180\253d", 29684498623485)]]:Kick(v4[fn2("\3\174d\163\173\15\196\248\n\148\211g\189\226M\252,\146?T\145^m\161\29J\31mM\158n\1\176D\232\133\t\2291r*\138W\145\0190\29\152I\176\177\147X^3\153O۴", 33049708197947)])
																		fn9()
																	end

																	if v110 == v4[fn2("Ɖ\162J", 30249304059403)] then
																		flag15 = true
																		flag2 = false
																		flag3 = false
																		n25 = 1
																		n24 = 2
																		local v113 = v4
																		writefile(v4[fn2("\231\151|(\168\248]\170\254\215\233V\231k\136M\172\129\168", 14824532030958)], v113[fn2("s25z\154\234a\131\145", 15250820544379)])

																		while true do
																		end
																	else
																		v110 = fn25(v110)[1]

																		if v110 == fn13(n36 * n37 % 100000 + n29 + 13954) .. v4[fn2("", 28489387501476)] then
																			n34 += 1
																			flag24 = true
																			flag22 = true
																		elseif v110 == fn10(n36 * n37 % 100000 + n29 + 13954 + 4919) .. v4[fn2("", 15233640150891)] then
																			flag24 = true
																			flag22 = true
																			flag9 = true

																			v16(function()
																				flag6:close()
																			end)
																		else
																			flag15 = true
																			flag2 = false
																			flag3 = false
																			n25 = 1
																			n24 = 2
																			local v113 = v4
																			v15:GetService(v4[fn2("\197>x\169\18fL", 29485850323780)])[v113[fn2("\172\15\203V*\147lM\179R\26", 24838553885276)]]:Kick(v4[fn2("\174\191bRRQ*\193ع'\25\154\n\158j\6\129\242\184\187\21\21D\245\225tL\179\160(", 22159486275741)] .. n34)
																		end
																	end
																end
															end)

															v22(20)
														end
													end)

													while not flag23 do
														v29:Wait()
													end

													flag23 = false

													v28(function()
														flag23 = true
														local n38 = 200

														while true do
															n38 += 1

															if not flag9 and n38 >= 250 then
																if flag24 then
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
																		n25 = 1
																		n24 = 2
																		local v109 = n34
																		writefile(v4[fn2("\rq\227Ŗ\196C\12d5\169P\130\23\225R%\162/\160\157", 15647043369196)], v4[fn2("\226\254\178K\216\255Z+Z", 8167129554358)] .. v109 .. v4[fn2("\250\193X\28", 24571184011619)] .. v33(flag6))
																	end
																end

																flag24 = false
																n38 = 0
															end

															n31 = v30()
															v22(0.18)
															if n31 ~= v30() then
																continue
															end
															flag15 = true
															flag2 = false
															flag3 = false
															n25 = 1
															n24 = 2
															local v109 = n34
															writefile(v4[fn2("\221aK\192\216\12q\174n\167\"\232\6\199\17:\166y\t=)", 26022927261355)], v4[fn2("\206\224\168?\226v\231\19\29", 709765005973)] .. v109 .. v4[fn2("\169d\175m", 10312531191172)] .. v33(flag6))
														end
													end)

													fn14(95, v4[fn2("\132", 22787644412646)], v4[fn2("\"\140\144$Il~ٳz\219Z\206:\t", 447764005281)])

													while not flag23 or not flag22 do
														v22()
													end
												end
											end

											do
												fn14(100, v4[fn2("^\156\160\174\193/5\1494\0U\206\225\165}", 10029054698620)], v4[fn2("[Q7ð=\11x\218~\1302}\200\234/m\228.\159", 31806277219253)] .. v30() - now .. v4[fn2("\252", 21953321553885)], Color3[v4[fn2("wܽ", 20447889574499)]](0, 1, 0), v4[fn2("\211\225ף", 11135042529410)])
												v85 = nil

												do
													local tbl30 = {
														[20] = 216,
														[5] = 2,
														[4] = 84,
														[9] = 224,
														[21] = 121,
														[2] = 202,
														[14] = 63,
														[6] = 115,
														105,
														[18] = 164,
														[12] = 188,
														[23] = 142,
														[22] = 128,
														[3] = 142,
														[19] = 244,
														[13] = 12,
														[16] = 217,
														[15] = 193,
														[10] = 175,
														[17] = 145,
														[8] = 204,
														[7] = 27,
														[11] = 182,
													}

													luraph_runtime1(v84, buffer.fromstring("E\142[$d7\23\2367\158\11\22\8l\171;\26ȵ\\\31\165\147\1478\181\143\239#!(\1658?g\132\204NT\241\22\166\178T\147\188)\245\166s \130^\147\236\228\171\25\135?C\156\197\203\4\19\0128xɧ\157C\3@t\223'3\230\245\169T\235a\154-\220o\219\17\252;\165=C\239\188\197\255\232Pn\21\153`\189\164\1760(\137S\219\5\254\11\200\231\1\208\229D\229\229Oq\186\158\168;\30\244\238gYc\251\8\168\144\136\tLW\217l8\141g\255\0204\195H\210K\137\158B\226(oj\247\14\128\247\226%\253\u{90}\183\212}\184\224\185\25\205jg\237Y\252\159\28/Xt\3\152\217f20\7)\193'\133詨\212\249\247X\201T{\217\247q7HR\130\247\1406<\232\220\232\174fuЏ\134()\189\239\151k\248\167u\202\215\203\31\225\197\255G\225\226\137\17i2\155\133\171ۚTx\150\195\208m\163\1@\163\136\156\255c\236l o>o?/\160F\192*\214\2208* \219\rm\152A\176\136}X1gsԸ\29\219X\3낂\n\5\133\29Ӈ\226\204\219a9OƩ\0291\190\177(\190Am\0267\229=\201e;\230l#\221B\156\15\205\215.&<\155\176\160g[\197\25\172\241\1\163\128\t\144b1\177\208\243O (cD\129\184f@U?\245\195|~Ÿ\2509l\139\247\156T|\1284\186\225[[)\17bv\26\219\222t\149|NGW\153%(\249\188\4U\201\0115\1666\202\12\140\140\21켩\28\185\240W(\164\167\165\251\243$\147sﰌ\233]G\220\16\176q\166\185\226\2376Ö\129\192\21\176\3\190]\231^\234\211<\11＜>\135ʉ\17\169\153RͳV\216jj\205\224þ\137\12\250\242\11\200\201H\":\23\n\2\17\161\200ɐ\18q\141\188\29\178Z6\147\242\130LG\162\179\254\2\2\t\138\149\186\172\nF\2022w\155\0165+\177\4\192W\12n\\\147Mi\t_J-\1382^\172\0\8\0080x̺x\230\237]9H\133Ist\226#8G\226\235\224d\30o\229\175\210\26\156\129\176\29\3\217\3KM\185˻0\224R6Dg\2289\208\250d\170M\158P\144\194eb\3\147\195ﺫ\196\220\228\220\240\6\173o*\210¬G\6a\134\185\184\185\225<\2309\149\229\202\234L\221\219Ȫ\232\190\236\237\tv\172\195\14\182\192{\129j>\254\177\145l\242\22+IϿ\199D\170þ\2078H\218GT\254\208\21\153w\147\204K\130LwK\156\133y\246\15\25\161x\191\17Eƶ\238:\226\247E\189\6.\242},\238\2zd\152\239\170{\149\19\183\189(\247T_\29\247N\233D\6=dW\248`=n\142j\t\236v\209b\244\163\151革:\176\12\127\209|\21\167\248\151坉~\23e\25\139\127\178>\179\159\189}\0216\165\224\195\224ϥZ\232Ʀ\180 'akI\196tТ\28\29햨u\28\178W\226\161\249\189\174f\242\188\128{\232\224\219\230\223\227B\4\224\152\n\2240\188\233P(\179\0246\253\244\208\223\248\186 \167\228\n2lj\233\200\215\19\245_4 \253\218ﲚ\27\177J\220\248\170\183}\8p\210<\237\198m؞\27(\222\218\23\237\182\224\25c/\142s\204o\138E\204)\183\223\243v\225z\183\134\221\tg!\160\143\253J\208Xt\221dm\149\238%1\243EG\245!\171\192\240\184\230\145 \140\132!\26\139\7\29\139t\23\232\156W\187\202d\128臎X/\182Sfd\142\254\158\128Y\254\163\177\212\196\219\0\0210\15\132JD\154\132\25\197\19\145\5勤\159\27\217\226\17\162>\134ٕ\205\28\134\242\240=(\138\172\193\195\220\27\27O\192\235\175go3\"\170j\220B@\183\251\132\171z\234]\184V\29\137\232\166\25\156xlx%Ȉ\157\0030\158\4m\255gփ\185[\135W<\163v\2296cA%\181\170\tp[\153#\215T#\nhd\150\163\184\t\175\199\214\216r\28l\158[\11\213\22\180\22\253\181 (\nXE\170\155eг\232\238\206sG\250\182[\216\230\200Q*Y\194\15\18U\29\179\188\168\"\193,\138\219\1935\133\215\26+p\242. W\206-Q\132]F\253\202\212s\225\163߷\19\139\153\27\163k\24\166\207\234O\238B\0\2175\221##\18&Al\128,\244\221yG\4mt\201E\229\18\164\152\2\12|ޓ\253\251\21AFrd\177\172Cd/\187\212M\161K\215UY\150\251\136K\168\144\147v\\\\\146j\217)\133\176Uw=\246^\186\181Gb\30\17\16,\227\151\220\217Ǔh\193\11O\200<\226K\253\127\"J\22\190\234\u{46294}W\210\229i4\241\150\140(\165\29\232\8\233i\215BC\195-;\4\237\3u\189`\16R\164e\0\203I\246Q!7Qe\1714\19\157\27\22\196b.S\180\242\154\226\173C\177\227M[\132\230j\177]s\165\189(\16M*\185So\181\200ޡ\149\142=#\214\207\"\184\224X\0287\130\185\210\244\1948\26\176\166\1456w\180\155\228\236E\31\143\28\235\146\208d~\224\208b%\182\148\162\143\142\235R\197\"IK\241o\01665\163\27W\22\159\r\185\168>\160F\242L\189\187\14)GH\203|\162\172}\2NSSv\31\179n\2\188{\20\2393x\189\201G\155\127\253;\2367F\190R\176]\142c\165I\253S\217_M\236\226\157\194t\t')G\6\224\143az/,\244\146\172\176\172\23\244\241\224\159\251#\179P\170\149\192Yy\u{5FB}\31\151m\155\224\222\226yB\152\3\152\238vt3̋?\225\216M\129\17\140\23\196d\1974\184\24mX\234\25[o\133\245H\130I\1\166\167\242*\223\7\170$\14\29\15\149\191\156c\148~>\196KI\130\20\184\186\187\\\197Zb\2\21\254pV_O\r\237\196\195Ny[CN\244\224\168[\3\243\152C\245ʘd\190\128˝g!]\12b0ջS\152\207u:\29\247\174B\179\15\186bmEJ3\136\3\203<^ݯ\218\3\135\202\5ʦfޥ9;\201\231.J\231]\187u(U\18\199\251\139\246$k\2167\187\239\255n[\12\166\171A\19}\187,CB\206\244-\208)+\t\129\238L\0012d\236Һ:\214>\248EJ\234!\209A\180\238\178 @\16\2544\244\1469;\1949\172\147\210|F\243(\179\8{ߒ\168\t\7\u{5CA}\25\140&\190w\17\174\12[\155D\247\145\158\219\225C\238\196\237\149\\\216%\136\167\25\217A\251\0\151>\146\227t!\200EDa\171\132\21\255M\164\238\"C|\239We\228\29p\187V}\27\5\159r\141.\n\232\127\152E\238\30\1335\25>\238|\234\150\251m8\131wr\136\201t0\236\12\202\20S\236\29s\2103Ts\8\187\214\208:u\210u\168\141?{\159\230f\230\213\2263\184?Hjg\3r\182\17þ\20\211Q\163\230Z\253q\25\207\201W\143\181*gi\251\27\131t\241\208~\142\143\170W\243\5\"R\158g\188g4\239\\\135\168\131\195yz</p\16\144dGm\1915;\24\243\27\142\196^\222\3\130\173T\27+C\26@\166d\249\1523G\148\232\8v'\214c -\12\1\191\191\135\163\182\240l6]\200Z\144or\26\16&\189\12CJ\17\196[\183\149J\215{L\n\2263\17T\197bc\198\248\158\200\220\14\162F\232)\244=`\23bѰ\131T\30y\198\220\192o0\157\175\174\219\224\157\153[̽\227\226\208\14\18\190Iw\24\237d7\2\2380\127\30\209#\203u\nO\168\21FNh\188\152CE\231\239\2394z\156\241\236\150-\151\tI\235\22\155\149Jy\149\219+\2338mP\189i\12\166\175Z\165 \140,\196Q\1\146ؤ\192O\196&F\n'\7@O\5\218,T\133$\21\189\166 q\214sa#\201\215Q\217vs\250\136\227sg\134B\136\2#\138\131\226'\207\216\237>\209˦\206jܐ\25\239\251\240\215\19\176\229\237\19\31\14/!\11\178uR0\27\227\129\26\18\254\207\206\202\229\178.q\145k\134\239\169\201g\233U\28\221wDm0\0172\25j\\\173%7̪Q|\155y\23(J\24\24^m\184\161\142k\158k\240(tH\143\245\206\245\190\r\180\160\127B9\28\146\131%\232\170o\"\215\29\12\242̕\16\145\214j\156\18G\223\\\253\219Xn\15}\205\250oBғh\25\1789\181*\244f\153\129\27\191\22\184\188Te`\230\226ɹ%\1523\15\199p\184\21555c\253\2\127A\236\2016\159CO؍\r\251\219m\2347\198N\26ۦ\154\252\176@A~+P^\236\227\"`N\206\245\248>\134\181\\\253\163\204o\252\163\170觭\189O:\31\134\209\245\176\1735\177\139M䞹-\5\189I\177r\14\175\255\163\rˊT\153\229k\0310\224\139\212j\152~G\240\163\228\14\209\216\t\240$\1530pi.2\236n\240c%|\235<\190B\0014\168\199_\1389;\215^^\203+\135\186\242WU\245\179\130\171\241\17jI\"[\27\180\189\1\28\179{K\213\12%[D\8\249\198p\162/\208\193_0\229G˫\162\29ݮ\151&\166\22\218\214\12֙\165\186\rڂ\179\238\29\139\163\241\29\148\149\137\253\238#\141\135\6Ab\2\209\14!g\188eÔ\189\198\203\211Z\225\213fI\20\141\198뉞\148n\209o_\224\141\147J\212$\136\21\250\137ؽ\233\158\223S]{g\156\254\206\218\2516\247\170\130\245\183\5\178\8\8p\127O\2541̴\197\4\236\242ڼR\131\146\240$\213,\236\255|}\11\149\156[\186\255}[\17\129\19{\8\179\128\136_\17\19\1415d\161\219b\\\188\162-\156\"\163wr\7N\169\169'i\167\242\173\26\173\4<\139l\1\145\"\228\219\"\247\23\237\r,\207K;ǘ\206\206\0237\5\7c\165a$\132\29k\176N\235o\208x9\0178\134wT\189!\0\226R\161\176ʼ\138\251\130\224\178\127\181\184\240j\127\251(\169\249\8\211Yb\165F_͜\185|\153I\145\172\209\199\"\161\tf\196U\157\r\151\214[M \197K\167\191\152/\149\182P\172\172\30v\188&\248\155?TG\18I\228(h\15\157\174w\29H\191\128d\208r\241\155f\192\223F2\129ȏH[\168P\235\204>1\237+\22\165|\24\194g\153\234\210IZ\24935g~5!J\242\3]P\1эm\176\246\198\234V\195\228s\244~\239N\148\162\n\132q\185+\175\213_}\176U\220\28\244\148\177N\202َ\n\237z\172\166\142\146\30'\167Z+\2440\28\159\211\21A\137\196:~\232p\232b\204Òs\229LO\142^\240\225\5\26oJ\252\145\14c\132Z\161\31\176\r~1\149\n\133\161\223\17k\204\242\"\18\146\155k\20Fx)\164\135X\209f\193\204Ȅ^Mg\229\11\232\247Ǣ\251C\168\250\182q\179\201b\173BԠ\231Cľ\243\11}\214\2214%ށ\252U\31S7|fg\244\6\194Vo\233\n1~\242\23&\215k\198\212g~f\r\192h/ R\26[\238y\131\186\231\147\r\132\160g\197\218IV\236\251\5\168\\\130\224\r\188s*\169L\203\233B\137߰\169\253淧\153\197\212\2542\209\226\238\227\224\18=\142\166\177/\169\31\248xr\219\23\136\162\218\248x\213/T\3hZ\2528\128\7)\254ˍ\\z\217\4\196}\159\222\220\0189\n_W\196\21v\165\142\178M+\128\193\218\208J\140\132|\172\240\209_\241\31\179\236-\160\4\168V'\175~Ix\191\216\245ʙ\nі\250BnI\158\226.\132\16\180nǟ\249\158\7\146\221p\6\172G\139Z\242\242\143&\177\160.\140\242\247\1\234W\151\139n.\135\151S\184\n\212\247knߗR\178(\157\29\2369K\185hc\132\225\253\227\0ܸ\154\223\29\173\151\248\241\191\158M4\3Zq\1825͡\252\197q\"\202\221\253*\5_m\211Qp\130\252m0A\144\243\8R#\183\140\240Ѷ\130\31\184\28\245\244\190\1\184*\141\150O\\`\2108\192@]\241ᘔ\172\214(\231\29ſ\230mI\144\226\3\226N\185*\23\4\146=\175ev\209\215\206\245\132b\205S\5\133\15\223\236\245\15\2+\151o\17z\24^\194Q\143v\194_@D\235\u{61C}\202\218\224^i@0\11\17!'\189\183\15\11=\131\142pS\193U\208\2388\178\156\158O^f1\197\221 c{\"\18\1512\246\24]\153]A\25n32\191\147\174ٛ"), tbl30, 318)()
												end
											end

											pcall(function()
												if setthreadidentity then
													setthreadidentity(v85[176])
												end
											end)

											v86 = workspace
											v87 = game
											v88 = task
											v89 = math
											v90 = string
											v91 = table
											v92 = ipairs
											v93 = pairs
											v94 = pcall
											v95 = type
											v96 = tostring
											v97 = tonumber
											v98 = Vector3
											v99 = CFrame
											v100 = Color3
											v101 = UDim2
											v102 = Instance
											v103 = Enum

											if not v87:IsLoaded() then
												v87.Loaded:Wait()
											end

											service = v87:GetService(v85[173])
											service2 = v87:GetService(v85[102])
											TweenService = v87:GetService("TweenService")
											service3 = v87:GetService(v85[189])
											Workspace = v87:GetService("Workspace")
											UserInputService = v87:GetService("UserInputService")
											localPlayer = service.LocalPlayer
											v104 = localPlayer:WaitForChild(v85[158])

											do
												local packages = service3:WaitForChild("Packages")
												v = service3:WaitForChild(v85[111])
												local Synchronizer = require(packages:WaitForChild("Synchronizer"))

												fn46 = function(arg)
													if not arg then
														return v85[112]
													end

													if typeof(arg) == "Instance" then
														return arg == localPlayer
													end

													if v95(arg) == "string" then
														return arg == localPlayer.Name
													end
													return v85[112]
												end

												fn29 = function(arg)
													local v108, v109 = v94(function()
														local v108 = getthreadidentity and getthreadidentity() or nil

														if setthreadidentity then
															setthreadidentity(8)
														end

														local tableFromChannel = Synchronizer:GetTableFromChannel(arg)

														if v108 and setthreadidentity then
															v94(setthreadidentity, v108)
														end

														return tableFromChannel
													end)

													if v108 and v95(v109) == "table" then
														return v109
													end
													return nil
												end
											end
										end

										do
											do
												Animals = require(v:WaitForChild("Animals"))
												Mutations = require(v:WaitForChild("Mutations"))
												Traits = require(v:WaitForChild("Traits"))

												do
													local HttpService = v87:GetService("HttpService")
													flag18 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
													str8 = v85[179]

													if flag18 then
														local viewportSize = v86.CurrentCamera and v86.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
														str8 = v89.min(viewportSize.X, viewportSize.Y) < 600 and "phone" or "tablet"
													end

													scale = str8 == "phone" and 0.58 or str8 == "tablet" and 0.8 or 1

													v94(function()
														if 11770 >= n27(1801) then
															if makefolder and isfolder and not isfolder("SlicedzHub") then
																makefolder("SlicedzHub")
															end

															return
														end

														while true do
														end
													end)

													if str8 == "phone" then
														tbl17 = {
															Keybinds = {
																X = v85[99],
																Y = v85[59],
																OffsetX = 0,
																OffsetY = 0,
															},
															Admin = {
																X = 0.19,
																Y = 0.02,
																OffsetX = 0,
																OffsetY = 0,
															},
															JobCopier = {
																X = 0.56,
																Y = 0.01,
																OffsetX = v85[117],
																OffsetY = 0,
															},
															TargetControls = {
																X = 0.82,
																Y = 0.02,
																OffsetX = 0,
																OffsetY = v85[117],
															},
															StealPanel = {
																X = 0.01,
																Y = v85[153],
																OffsetX = 0,
																OffsetY = 0,
															},
															Visuals = {
																X = 0.62,
																Y = 0.72,
																OffsetX = 0,
																OffsetY = 0,
															},
															Protection = {
																X = 0.19,
																Y = v85[153],
																OffsetX = 0,
																OffsetY = 0,
															},
															Invis = {
																X = 0.19,
																Y = 0.55,
																OffsetX = 0,
																OffsetY = 0,
															},
														}
													elseif str8 == v85[56] then
														tbl17 = {
															Keybinds = {
																X = 0.02,
																Y = v85[19],
																OffsetX = v85[117],
																OffsetY = 0,
															},
															StealPanel = {
																X = 0.02,
																Y = 0.3,
																OffsetX = v85[117],
																OffsetY = 0,
															},
															JobCopier = {
																X = v85[65],
																Y = 0.02,
																OffsetX = 0,
																OffsetY = 0,
															},
															TargetControls = {
																X = 0.8,
																Y = 0.04,
																OffsetX = v85[117],
																OffsetY = 0,
															},
															Visuals = {
																X = 0.8,
																Y = 0.5,
																OffsetX = 0,
																OffsetY = 0,
															},
															Admin = {
																X = v85[59],
																Y = 0.72,
																OffsetX = 0,
																OffsetY = 0,
															},
															Protection = {
																X = 0.2,
																Y = 0.04,
																OffsetX = 0,
																OffsetY = 0,
															},
															Invis = {
																X = 0.38,
																Y = 0.04,
																OffsetX = 0,
																OffsetY = v85[117],
															},
														}
													else
														tbl17 = {
															StealPanel = {
																X = v85[59],
																Y = 0.35,
																OffsetX = 0,
																OffsetY = 0,
															},
															TargetControls = {
																X = 0.845,
																Y = 0.06,
																OffsetX = 0,
																OffsetY = v85[117],
															},
															Visuals = {
																X = 0.845,
																Y = v85[193],
																OffsetX = v85[117],
																OffsetY = v85[117],
															},
															JobCopier = {
																X = 0.5,
																Y = 0.02,
																OffsetX = 0,
																OffsetY = v85[117],
															},
															Keybinds = {
																X = 0.02,
																Y = v85[168],
																OffsetX = 0,
																OffsetY = 0,
															},
															Admin = {
																X = 0.02,
																Y = 0.72,
																OffsetX = 0,
																OffsetY = 0,
															},
															Protection = {
																X = 0.155,
																Y = 0.05,
																OffsetX = 0,
																OffsetY = 0,
															},
															Invis = {
																X = 0.29,
																Y = 0.05,
																OffsetX = 0,
																OffsetY = 0,
															},
														}
													end

													tbl18 = {
														StealPanel = false,
														TargetControls = false,
														Visuals = str8 == "phone",
														JobCopier = str8 == "phone",
														Keybinds = false,
														Admin = str8 == "phone",
														SlotNumbers = false,
														Protection = str8 == "phone",
														Invis = str8 == "phone",
													}

													tbl19 = {
														stealNearest = false,
														stealHighest = false,
														instantSteal = false,
														autoKick = false,
														xray = false,
														brainrotESP = false,
														slotESP = v85[112],
														nextBase = v85[112],
														hideJobId = false,
														infiniteJump = false,
														lineToBase = false,
														fpsBoost = v85[112],
														float = false,
														carpetSpeed = false,
														slotNumbers = true,
														proximityAP = v85[112],
														antiDie = false,
														antiRagdoll = v85[112],
														autoResetBalloon = false,
														autoTurret = false,
														walkSpeed = true,
														autoInvis = false,
														autoRecover = true,
													}

													tbl20 = {
														clone = "V",
														float = "Z",
														drop = "G",
														reset = v85[182],
														carpet = "Q",
														invis = "U",
														ws = "H",
													}

													n32 = 70
													proximityRange = v85[96]

													tbl21 = {
														angle = 225,
														depth = v85[176],
														ws = v85[139],
													}

													fn44 = function(arg, arg2, arg3)
														local v108 = v97(arg)
														if v108 == nil or v108 ~= v108 or v108 == v89.huge or v108 == -v89.huge then
															return nil
														end

														if arg2 and v108 < arg2 then
															return nil
														end

														if arg3 and v108 > arg3 then
															return nil
														end
														return v108
													end

													local function fn47(arg, arg2)
														if v95(arg2) ~= "table" then
															return
														end
														local v108 = fn44(arg2.X, -0.5, 1.5)
														local v109 = fn44(arg2.Y, -0.5, 1.5)
														local v110 = fn44(arg2.OffsetX, -3000, 3000)
														local v111 = fn44(arg2.OffsetY, -v85[94], 3000)

														if v108 ~= nil then
															arg.X = v108
														end

														if v109 ~= nil then
															arg.Y = v109
														end

														if v110 ~= nil then
															arg.OffsetX = v110
														end

														if v111 ~= nil then
															arg.OffsetY = v111
														end
													end

													local function fn48(arg)
														if v95(arg) ~= "string" or arg == "" then
															return false
														end

														local v108, v109 = v94(function()
															return v103.KeyCode[arg]
														end)

														return v108 and v109 ~= nil
													end

													local function fn49(arg)
														if v95(arg) ~= "table" then
															return
														end

														for k in v93(tbl19) do
															if v95(arg[k]) == "boolean" then
																tbl19[k] = arg[k]
															end
														end
													end

													v94(function()
														if isfile and isfile("SlicedzHub/SlicedzHubConfig.json") then
															local json = readfile("SlicedzHub/SlicedzHubConfig.json")

															if json and json ~= "" then
																local v108, v109 = v94(HttpService.JSONDecode, HttpService, json)

																if v108 and v95(v109) == "table" and v109.Version == 2 then
																	fn47(tbl17.StealPanel, v109.StealPanel)
																	fn47(tbl17.TargetControls, v109.TargetControls)
																	fn47(tbl17.Visuals, v109.Visuals)
																	fn47(tbl17.JobCopier, v109.JobCopier)
																	fn47(tbl17.Keybinds, v109.Keybinds)
																	fn47(tbl17.Admin, v109.Admin)
																	fn47(tbl17.Protection, v109.Protection)
																	fn47(tbl17.Invis, v109.Invis_Pos)
																	fn49(v109.Toggles)

																	if v95(v109.Keybinds2) == "table" then
																		for k in v93(tbl20) do
																			if fn48(v109.Keybinds2[k]) then
																				tbl20[k] = v109.Keybinds2[k]
																			end
																		end
																	end

																	local v110 = fn44(v109.FOV, v85[115], 180)

																	if v110 ~= nil then
																		n32 = v110
																	end

																	local v111 = fn44(v109.ProxRange, 5, v85[133])

																	if v111 ~= nil then
																		proximityRange = v111
																	end

																	if v95(v109.Invis) == "table" then
																		local v112 = fn44(v109.Invis.angle, 0, 360)

																		if v112 then
																			tbl21.angle = v112
																		end

																		local v113 = fn44(v109.Invis.depth, v85[117], 18)

																		if v113 then
																			tbl21.depth = v113
																		end

																		local v114 = fn44(v109.Invis.ws, 15, 35)

																		if v114 then
																			tbl21.ws = v114
																		end
																	end

																	local v112 = v85[67]

																	if v95(v109.Collapsed) == v112 then
																		for k in v93(tbl18) do
																			local v113 = v85[30]

																			if v95(v109.Collapsed[k]) == v113 then
																				tbl18[k] = v109.Collapsed[k]
																			end
																		end
																	end
																end
															end
														end
													end)

													fn30 = function()
														if not writefile then
															return
														end

														v94(function()
															writefile("SlicedzHub/SlicedzHubConfig.json", HttpService:JSONEncode({
																Version = v85[198],
																StealPanel = tbl17.StealPanel,
																TargetControls = tbl17.TargetControls,
																Visuals = tbl17.Visuals,
																JobCopier = tbl17.JobCopier,
																Keybinds = tbl17.Keybinds,
																Admin = tbl17.Admin,
																Protection = tbl17.Protection,
																Invis_Pos = tbl17.Invis,
																Keybinds2 = tbl20,
																FOV = n32,
																ProxRange = proximityRange,
																Invis = tbl21,
																Toggles = tbl19,
																Collapsed = tbl18,
															}))
														end)
													end
												end
											end

											v106 = fn30
											stealNearest = tbl19.stealNearest
											stealHighest = tbl19.stealHighest
											flag19 = false
											instantSteal = tbl19.instantSteal
											flag20 = false
											flag21 = false
											autoKick = tbl19.autoKick
											tbl22 = {}
											tbl28 = {}
											tbl23 = {}
											v107 = nil
											tbl29 = {}
											v105 = v85[48]
											uid = nil
											uid2 = nil
											tbl24 = {}

											do
												local connection = nil

												local function fn47()
													localPlayer.DevEnableMouseLock = v85[8]
													localPlayer.DevCameraOcclusionMode = v103.DevCameraOcclusionMode.Invisicam

													if connection then
														connection:Disconnect()
													end

													connection = service2.RenderStepped:Connect(function(...) end)
												end

												fn47()

												localPlayer.CharacterAdded:Connect(function()
													v88.wait(v85[65])
													fn47()
												end)
											end
										end
									end

									local fn47, fn48

									do
										do
											do
												local tbl30 = {
													"",
													"K",
													"M",
													"B",
													"T",
													v85[83],
													"Qi",
													"Sx",
													v85[81],
													"Oc",
													"No",
													"Dc",
													"Ud",
													v85[38],
													"Td",
													"Qad",
													"Qid",
													"Sxd",
													"Spd",
													"Ocd",
													"Nod",
													"Vg",
													"Uvg",
													"Dvg",
													"Tvg",
												}

												fn47 = function(arg, arg2)
													local v = arg2 or v85[48]
													local v108 = v89.abs(arg)
													local v109 = v89.floor(v89.log(v89.max(1, v108), 1000))
													local str9 = tbl30[v109 + v85[48]] or "e+" .. v109
													return ("%." .. v .. "f"):format(v89.floor(arg * 10 ^ v / 1000 ^ v109) / 10 ^ v):gsub("%.?0+$", "") .. str9
												end
											end
										end

										fn48 = function(arg, arg2, arg3)
											local v = Animals[arg]
											if not v then
												return 0
											end
											local generation = v.Generation or v.Price * v85[114]
											local flag22 = arg2 and arg2 ~= "None"
											local n33 = 1

											if flag22 then
												local v108 = Mutations[arg2]

												if v108 and v108.Modifier then
													n33 = 1 + v108.Modifier
												end
											end

											local v108 = v85[67]
											local flag23 = false

											if v95(arg3) == v108 then
												for _, v109 in v92(arg3) do
													if v109 == "Sleepy" then
														flag23 = true
													else
														local v110 = Traits[v109]

														if v110 and v110.MultiplierModifier then
															n33 += v110.MultiplierModifier
														end
													end
												end
											end

											local v109 = v89.round(generation * n33)

											if flag23 then
												v109 = v89.round(v109 * 0.5)
											end

											return v109
										end

										fn31 = function(P)if not P then return nil;end;local L= Workspace :FindFirstChild("Plots");local v=L and(L:FindFirstChild(P.plot));if not v then return nil;end;L=v:FindFirstChild("AnimalPodiums");if not L then return nil;end;v=L:FindFirstChild(P.slot);if not v then return nil;end;P=v:FindFirstChild("Base");if not P then return nil;end;L=P:FindFirstChild("Spawn");if L then return L;end;return P:FindFirstChildWhichIsA("BasePart")or P;end

										local function fn49(arg)
											if not arg or not arg.plot then
												return false
											end
											local plots = Workspace:FindFirstChild("Plots")
											plots = plots and plots:FindFirstChild(arg.plot)
											if not plots then
												return false
											end
											local v, v108 = v94(fn29, plots.Name)
											if v and v108 and v108.Owner then
												return fn46(v108.Owner)
											end
											return false
										end
									end

									do
										do
											local function fn49(arg)
												if not arg or arg == "None" then
													return ""
												end
												local str9

												if arg == "Cursed" then
													str9 = "<font color='rgb(200,0,0)'>Cur</font><font color='rgb(0,0,0)'>sed</font>"
												elseif arg == "Gold" then
													str9 = "<font color='rgb(255,215,0)'>Gold</font>"
												elseif arg == v85[124] then
													str9 = "<font color='rgb(0,255,255)'>Diamond</font>"
												elseif arg == v85[25] then
													str9 = "<font color='rgb(255,255,255)'>Yin</font><font color='rgb(0,0,0)'>Yang</font>"
												elseif arg == "Candy" then
													str9 = "<font color='rgb(255,105,180)'>Candy</font>"
												elseif arg == "Divine" then
													str9 = "<font color='rgb(255,255,255)'>Divine</font>"
												elseif arg == v85[136] then
													local tbl30 = {
														"rgb(255,0,0)",
														"rgb(255,127,0)",
														"rgb(255,255,0)",
														"rgb(0,255,0)",
														"rgb(0,0,255)",
														"rgb(75,0,130)",
														"rgb(148,0,211)",
													}

													str9 = ""

													for i = 1, #arg do
														str9 ..= "<font color='" .. tbl30[(i - 1) % #tbl30 + 1] .. "'>" .. arg:sub(i, i) .. "</font>"
													end
												elseif arg == "Radioactive" then
													str9 = "<font color='rgb(132,255,0)'>Radioactive</font>"
												elseif arg ~= v85[12] then
													str9 = arg
												else
													str9 = "<font color='rgb(170,85,255)'>Galaxy</font>"
												end

												return "<font weight='800'>" .. str9 .. " </font>"
											end

											fn32 = function(arg)
												if arg == "Gold" then
													return v100.fromRGB(255, 215, 0)
												end

												if arg == "Diamond" then
													return v100.fromRGB(v85[117], 255, 255)
												end

												if arg == v85[180] then
													return v100.fromRGB(200, 0, 0)
												end

												if arg == "YinYang" then
													return v100.fromRGB(255, 255, v85[63])
												end

												if arg == v85[26] then
													return v100.fromRGB(255, 105, v85[110])
												end

												if arg == "Divine" then
													return v100.fromRGB(255, v85[63], 255)
												end

												if arg == "Rainbow" then
													return v100.fromRGB(148, v85[117], 211)
												end

												if arg == v85[103] then
													return v100.fromRGB(132, 255, v85[117])
												end

												if arg == "Galaxy" then
													return v100.fromRGB(v85[32], 85, v85[63])
												end
												return v100.fromRGB(255, v85[192], 120)
											end

											fn33 = function(arg)
												arg = arg and arg.mutation
												if arg and arg ~= "None" and arg ~= "" then
													return fn49(arg), true
												end
												return "", v85[112]
											end
										end
									end

									fn34 = function()
										if n26(2942) >= 10761 then
											flag19 = stealNearest or stealHighest
										else
											while v85[8] do
											end
										end
									end

									fn35 = function(...) end

									do
										local function fn49(arg)
											if not arg then
												return ""
											end
											local str9 = ""

											for k, v in v93(arg) do
												if v95(v) == "table" then
													str9 ..= v96(k) .. v96(v.Index) .. v96(v.Mutation)
												end
											end

											return str9
										end

										fn45 = function(arg)
											local flag22 = false

											v94(function()
												local v = fn29(arg.Name)
												if not v then
													return
												end
												local animalList = v.AnimalList
												local owner = v.Owner
												local flag23 = not owner or fn46(owner)

												if not flag23 then
													local v108 = v85[184]
													flag23 = typeof(owner) == v108 and not service:FindFirstChild(owner.Name)
												end

												if flag23 then
													tbl28[arg.Name] = nil

													for i = #tbl22, 1, -1 do
														if tbl22[i].plot == arg.Name then
															v91.remove(tbl22, i)
															flag22 = true
														end
													end

													return
												end

												if not animalList then
													tbl28[arg.Name] = nil

													for i = #tbl22, v85[48], -v85[48] do
														if tbl22[i].plot == arg.Name then
															v91.remove(tbl22, i)
															flag22 = true
														end
													end

													return
												end

												local v108 = fn49(animalList)
												if tbl28[arg.Name] == v108 then
													return
												end

												for i = #tbl22, 1, -1 do
													if tbl22[i].plot == arg.Name then
														v91.remove(tbl22, i)
													end
												end

												for k, v109 in v93(animalList) do
													if v95(v109) == "table" then
														local index = v109.Index
														local v110 = Animals[v109.Index]

														if v110 then
															local mutation = v109.Mutation or "None"

															if mutation == v85[123] then
																mutation = "YinYang"
															end

															local v111 = fn48(index, v109.Mutation, v109.Traits)

															v91.insert(tbl22, {
																name = v110.DisplayName or index,
																genText = "$" .. fn47(v111) .. "/s",
																genValue = v111,
																mutation = mutation,
																owner = owner,
																plot = arg.Name,
																slot = v96(k),
																uid = arg.Name .. "_" .. v96(k),
															})
														end
													end
												end

												tbl28[arg.Name] = v108
												flag22 = v85[8]
											end)

											if flag22 then
												v91.sort(tbl22, function(arg2, arg3)
													return arg2.genValue > arg3.genValue
												end)

												v107 = nil

												if brainrotESPEnabled then
													v88.defer(function()
														v94(function()
															_espLastHash = nil
															refreshBrainrotESP()
														end)
													end)
												end
											end
										end
									end
								end

								do
									do
										do
											do
												do
													local function fn46(arg)
														local v = nil
														local n33 = 0

														while not v and n33 < 40 do
															v = fn29(arg.Name)

															if not v then
																n33 += v85[48]
																v88.wait(0.07)
															end
														end

														if not v then
															return
														end
														fn45(arg)

														local function fn47(arg2)
															if not arg2 then
																return
															end

															arg2.ChildAdded:Connect(function()
																v88.wait(0.15)
																fn45(arg)
															end)

															arg2.ChildRemoved:Connect(function()
																for i = #tbl22, 1, -1 do
																	if tbl22[i].plot == arg.Name then
																		v91.remove(tbl22, i)
																	end
																end

																tbl28[arg.Name] = nil
																v107 = nil

																for k in v93(tbl23) do
																	local name = arg.Name

																	if k:sub(1, #arg.Name) == name then
																		tbl23[k] = nil
																	end
																end

																v88.wait(v85[175])
																fn45(arg)
															end)
														end

														fn47(arg:FindFirstChild("AnimalPodiums"))

														arg.ChildAdded:Connect(function(child)
															if child.Name == "AnimalPodiums" then
																fn47(child)
																fn45(arg)
															end
														end)

														arg.ChildRemoved:Connect(function(child)
															if child.Name == "AnimalPodiums" then
																for i = #tbl22, 1, -1 do
																	if tbl22[i].plot == arg.Name then
																		v91.remove(tbl22, i)
																	end
																end

																tbl28[arg.Name] = nil
																v107 = nil
															end
														end)

														v88.spawn(function()
															while arg.Parent do
																v88.wait(10)
																fn45(arg)
															end
														end)
													end

													v88.spawn(function()
														local plots = Workspace:WaitForChild("Plots", 10)
														if not plots then
															return
														end

														for _, child in v92(plots:GetChildren()) do
															v88.spawn(fn46, child)
														end

														plots.ChildAdded:Connect(function(child)
															v88.wait(0.5)
															fn46(child)
														end)

														plots.ChildRemoved:Connect(function(child)
															tbl28[child.Name] = nil
															v107 = nil

															for i = #tbl22, v85[48], -1 do
																if tbl22[i].plot == child.Name then
																	v91.remove(tbl22, i)
																end
															end

															for k in v93(tbl23) do
																local name = child.Name

																if k:sub(1, #child.Name) == name then
																	tbl23[k] = nil
																end
															end
														end)

														v88.wait(4)
													end)
												end
											end

											do
												local function fn46(arg)
													if not arg then
														return nil
													end
													local v = tbl23[arg.uid]
													if v and v.Parent then
														return v
													end
													local plots = Workspace:FindFirstChild("Plots")
													plots = plots and plots:FindFirstChild(arg.plot)
													if not plots then
														return nil
													end
													local animalPodiums = plots:FindFirstChild("AnimalPodiums")
													if not animalPodiums then
														return nil
													end
													local v108 = fn29(plots.Name)
													local v109 = animalPodiums:FindFirstChild(arg.slot)

													if v108 and v108.AnimalList and v109 then
														local base = v109:FindFirstChild("Base")
														base = base and base:FindFirstChild("Spawn")

														if base then
															local promptAttachment = base:FindFirstChild("PromptAttachment")

															if promptAttachment then
																for _, child in v92(promptAttachment:GetChildren()) do
																	if child:IsA("ProximityPrompt") and child.Enabled and child.ActionText == "Steal" then
																		tbl23[arg.uid] = child
																		return child
																	end
																end
															end

															local position = base.Position
															local x = position.X
															local z = position.Z
															local huge = v89.huge
															local v110 = nil

															for _, descendant in v93(plots:GetDescendants()) do
																if descendant:IsA("ProximityPrompt") and descendant.Enabled and descendant.ActionText == "Steal" then
																	local parent = descendant.Parent
																	local position2

																	if parent and parent:IsA(v85[9]) then
																		position2 = parent.Position
																	else
																		local isBasePart = parent and parent:IsA("Attachment") and parent.Parent and parent.Parent:IsA("BasePart")
																		position2 = nil

																		if isBasePart then
																			position2 = parent.Parent.Position
																		end
																	end

																	if position2 then
																		if v89.sqrt((position2.X - x) ^ v85[198] + (position2.Z - z) ^ 2) < 5 and position2.Y > position.Y then
																			local n33 = position2.Y - position.Y

																			if n33 < huge then
																				huge = n33
																				v110 = descendant
																			end
																		end
																	end
																end
															end

															if v110 then
																tbl23[arg.uid] = v110
																return v110
															end
														end
													elseif v109 then
														local base = v109:FindFirstChild("Base")
														base = base and base:FindFirstChild("Spawn")

														if base then
															local promptAttachment = base:FindFirstChild("PromptAttachment")

															if promptAttachment then
																for _, child in v92(promptAttachment:GetChildren()) do
																	if child:IsA("ProximityPrompt") then
																		tbl23[arg.uid] = child
																		return child
																	end
																end
															end
														end
													end

													return nil
												end
											end

											fn36 = function(arg)
												if tbl29[arg] then
													return
												end
												local tbl30 = { holdCallbacks = {}, triggerCallbacks = {}, holdEndCallbacks = {}, ready = true }
												local v, v108 = v94(getconnections, arg.PromptButtonHoldBegan)
												local flag22

												if v then
													local v109 = v85[67]
													flag22 = v95(v108) == v109
												else
													flag22 = v
												end

												if flag22 then
													for _, v109 in v92(v108) do
														if v95(v109.Function) == "function" then
															v91.insert(tbl30.holdCallbacks, v109.Function)
														end
													end
												end

												local flag23, v109 = v94(getconnections, arg.Triggered)

												if flag23 then
													local v110 = v85[67]
													flag23 = v95(v109) == v110
												end

												if flag23 then
													for _, v110 in v92(v109) do
														local v111 = v85[151]

														if v95(v110.Function) == v111 then
															v91.insert(tbl30.triggerCallbacks, v110.Function)
														end
													end
												end

												local v110, v111 = v94(getconnections, arg.PromptButtonHoldEnded)

												if v110 and v95(v111) == "table" then
													for _, v112 in v92(v111) do
														if v95(v112.Function) == "function" then
															v91.insert(tbl30.holdEndCallbacks, v112.Function)
														end
													end
												end

												tbl29[arg] = tbl30
											end

											local function fn46(arg)
												for _, v in v92(arg) do
													v88.spawn(v)
												end
											end
										end

										do
											local fn46

											do
												do
													local function fn47()
														if v94(function()
															v87:Shutdown()
														end) then
															return
														end

														v94(function()
															localPlayer:Kick("")
														end)
													end

													local obj = setmetatable({}, { __mode = "k" })

													local function fn48(arg)
														if v95(arg) ~= "string" then
															return v85[112]
														end
														return arg:lower():find("you stole", v85[48], true) ~= nil
													end

													fn46 = function(arg)
														if obj[arg] then
															return
														end
														obj[arg] = true
														if autoKick and fn48(arg.Text) then
															fn47()
															return
														end

														arg:GetPropertyChangedSignal("Text"):Connect(function()
															if autoKick and fn48(arg.Text) then
																fn47()
															end
														end)
													end
												end
											end

											do
												local function fn47(arg)
													for _, descendant in v92(arg:GetDescendants()) do
														if descendant:IsA("TextLabel") or descendant:IsA(v85[68]) or descendant:IsA("TextBox") then
															fn46(descendant)
														end
													end

													arg.DescendantAdded:Connect(function(descendant)
														if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA(v85[145]) then
															fn46(descendant)
														end
													end)
												end

												v88.spawn(function()
													local playerGui = localPlayer:WaitForChild("PlayerGui")

													for _, child in v92(playerGui:GetChildren()) do
														v94(fn47, child)
													end

													playerGui.ChildAdded:Connect(function(child)
														v94(fn47, child)
													end)
												end)
											end
										end
									end

									do
										local Frame3, Frame4

										do
											do
												hui = gethui()

												tbl25 = {
													BG = v100.fromRGB(v85[76], v85[36], 10),
													SURF = v100.fromRGB(v85[85], v85[36], 10),
													SURF2 = v100.fromRGB(44, v85[155], 16),
													TEXT = v100.fromRGB(255, 235, 235),
													DIM = v100.fromRGB(180, 80, 80),
													AQUA = v100.fromRGB(v85[183], 60, v85[54]),
													AQUA2 = v100.fromRGB(v85[32], v85[115], 30),
													AQUA_STROKE = v100.fromRGB(v85[127], 50, 50),
												}

												tbl26 = {
													BG = v100.fromRGB(22, v85[36], 10),
													SURF = v100.fromRGB(26, 10, v85[36]),
													SURF2 = v100.fromRGB(44, 16, 16),
													TEXT = v100.fromRGB(255, v85[51], 235),
													DIM = v100.fromRGB(180, 80, 80),
													AQUA = v100.fromRGB(220, 60, 60),
													AQUA2 = v100.fromRGB(170, 30, 30),
													AQUA_STROKE = v100.fromRGB(200, 50, v85[133]),
													GREEN1 = v100.fromRGB(18, 88, 58),
													GREEN2 = v100.fromRGB(21, 120, 76),
													GREEN_STROKE = v100.fromRGB(60, 185, 120),
													OFF_BG = v100.fromRGB(52, v85[74], 18),
													OFF_TEXT = v100.fromRGB(160, 70, v85[192]),
												}

												tbl27 = {
													PANEL = v100.fromRGB(26, v85[36], 10),
													PANEL2 = v100.fromRGB(44, 16, 16),
													TEXT = v100.fromRGB(255, v85[51], 235),
													STROKE = v100.fromRGB(v85[127], 50, v85[133]),
													GLOW = v100.fromRGB(220, v85[54], 60),
													TRACK = v100.fromRGB(36, 14, v85[6]),
													TRACK2 = v100.fromRGB(50, 18, 18),
													FILL1 = v100.fromRGB(v85[87], 60, 60),
													FILL2 = v100.fromRGB(255, 120, v85[69]),
												}

												fn37 = function(arg, arg2, arg3)
													local flag22 = nil
													local v = nil
													local position = nil
													local position2

													arg.InputBegan:Connect(function(input)
														if input.UserInputType == v103.UserInputType.MouseButton1 or input.UserInputType == v103.UserInputType.Touch then
															flag22 = true
															position2 = input.Position
															position = arg2.Position

															input.Changed:Connect(function()
																if input.UserInputState == v103.UserInputState.End then
																	flag22 = false

																	if arg3 then
																		local position3 = arg2.Position
																		local v108 = fn44(position3.X.Scale, -v85[65], 1.5)
																		local v109 = fn44(position3.Y.Scale, -0.5, v85[121])
																		local v110 = fn44(position3.X.Offset, -3000, 3000)
																		local v111 = fn44(position3.Y.Offset, -v85[94], 3000)

																		if v108 and v109 and v110 and v111 then
																			tbl17[arg3] = { X = v108, Y = v109, OffsetX = v110, OffsetY = v111 }
																			v106()
																		end
																	end
																end
															end)
														end
													end)

													arg.InputChanged:Connect(function(input)
														if input.UserInputType == v103.UserInputType.MouseMovement or input.UserInputType == v103.UserInputType.Touch then
															v = input
														end
													end)

													UserInputService.InputChanged:Connect(function(input)
														if flag22 and input == v then
															local n33 = input.Position - position2
															arg2.Position = v101.new(position.X.Scale, position.X.Offset + n33.X, position.Y.Scale, position.Y.Offset + n33.Y)
														end
													end)
												end

												fn38 = function(parent, arg)
													local v = v102.new(v85[138])
													v.CornerRadius = UDim.new(0, arg)
													v.Parent = parent
													return v
												end

												fn39 = function(parent, color, thickness, transparency)
													local UIStroke = v102.new("UIStroke")
													UIStroke.Color = color
													UIStroke.Thickness = thickness or v85[48]
													UIStroke.Transparency = transparency or 0
													UIStroke.ApplyStrokeMode = v103.ApplyStrokeMode.Border
													UIStroke.Parent = parent
													return UIStroke
												end

												fn40 = function(arg, arg2, arg3)
													TweenService:Create(arg, TweenInfo.new(arg2 or v85[137], v103.EasingStyle.Quint, v103.EasingDirection.Out), arg3):Play()
												end

												fn41 = function(parent, arg, arg2, rotation)
													local UIGradient = v102.new("UIGradient")
													UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, arg), ColorSequenceKeypoint.new(1, arg2) })
													UIGradient.Rotation = rotation or 0
													UIGradient.Parent = parent
													return UIGradient
												end

												fn42 = function(arg)
													local v = v102.new(v85[186], arg)
													v.Scale = scale
													return v
												end

												fn43 = function(arg, arg2, arg3, arg4, arg5, arg6)
													arg5 = arg5 or tbl26
													arg6 = arg6 or {}
													local size = arg6.size or v85[85]
													local v = v102.new(v85[68], arg2)
													v.AutoButtonColor = false
													v.Size = v101.fromOffset(size, size)
													v.Position = arg6.position or v101.new(1, -(size + 8), v85[117], 9)
													v.BackgroundColor3 = arg5.SURF2
													v.BorderSizePixel = 0
													v.Text = "-"
													v.Font = v103.Font.GothamBlack
													v.TextSize = arg6.textSize or 18
													v.TextColor3 = arg5.TEXT
													v.ZIndex = arg6.zindex or 105
													fn38(v, arg6.radius or 7)
													local v108 = fn39(v, arg5.AQUA_STROKE, v85[48], arg6.strokeT or 0.55)
													local hoverBg = arg6.hoverBg or v100.fromRGB(58, 20, 20)

													v.MouseEnter:Connect(function()
														fn40(v, v85[199], { BackgroundColor3 = hoverBg })
														fn40(v108, 0.12, { Transparency = 0.25 })
													end)

													v.MouseLeave:Connect(function()
														fn40(v, 0.12, { BackgroundColor3 = arg5.SURF2 })
														fn40(v108, 0.12, { Transparency = arg6.strokeT or 0.55 })
													end)

													local flag22 = arg.AutomaticSize == v103.AutomaticSize.Y
													local offset = arg.Size.Y.Offset
													local clipsDescendants = arg.ClipsDescendants
													local flag23 = tbl18[arg4] or false
													local flag24 = false
													local headerH = arg6.headerH or v85[149]

													local function fn46()
														return arg.Size.X.Scale, arg.Size.X.Offset
													end

													local function fn47()
														local uiScale = arg:FindFirstChildOfClass("UIScale")
														return uiScale and uiScale.Scale > v85[117] and uiScale.Scale or 1
													end

													local function fn48()
														if not flag22 then
															return offset
														end
														local n33 = arg.AbsoluteSize.Y / fn47()
														if headerH + v85[132] < n33 then
															return n33
														end
														return nil
													end

													local function fn49()
														local v109, v110 = fn46()

														if flag22 then
															arg.AutomaticSize = v103.AutomaticSize.Y
															arg.Size = v101.new(v109, v110, 0, v85[117])
														else
															arg.Size = v101.new(v109, v110, v85[117], offset)
														end

														arg.ClipsDescendants = clipsDescendants
														flag24 = v85[112]
													end

													local function fn50(arg7)
														if n27(118) >= 8760 then
															local v109, v110 = fn46()
															local v111 = fn48()
															arg.AutomaticSize = v103.AutomaticSize.None

															if not arg6.noClip then
																arg.ClipsDescendants = true
															end

															v.Text = "+"

															if arg7 or not v111 then
																arg.Size = v101.new(v109, v110, v85[117], headerH)
																arg3.Visible = false
																return
															end

															arg.Size = v101.new(v109, v110, 0, v111)

															if arg6.noClip then
																arg3.Visible = false
															end

															flag24 = true
															local tween = TweenService:Create(arg, TweenInfo.new(0.22, v103.EasingStyle.Quint, v103.EasingDirection.Out), { Size = v101.new(v109, v110, v85[117], headerH) })
															tween:Play()

															tween.Completed:Connect(function()
																arg3.Visible = false
																flag24 = false
															end)

															return
														end

														while true do
														end
													end

													local function fn51(arg7)
														local v109, v110 = fn46()
														v.Text = "-"

														if arg7 then
															arg3.Visible = true
															fn49()
															return
														end

														flag24 = v85[8]
														local n33

														if flag22 then
															arg3.Visible = true
															arg.AutomaticSize = v103.AutomaticSize.Y
															arg.Size = v101.new(v109, v110, v85[117], 0)
															arg.ClipsDescendants = v85[112]
															service2.RenderStepped:Wait()
															n33 = fn48() or arg.AbsoluteSize.Y / fn47()
															arg.AutomaticSize = v103.AutomaticSize.None

															if arg6.noClip then
																arg3.Visible = false
															else
																arg.ClipsDescendants = true
															end

															arg.Size = v101.new(v109, v110, 0, headerH)
														else
															arg3.Visible = not arg6.noClip
															n33 = offset
														end

														local tween = TweenService:Create(arg, TweenInfo.new(0.22, v103.EasingStyle.Quint, v103.EasingDirection.Out), { Size = v101.new(v109, v110, 0, n33) })
														tween:Play()

														tween.Completed:Connect(function()
															arg3.Visible = true
															fn49()
														end)
													end

													v.MouseButton1Click:Connect(function()
														if flag24 then
															return
														end
														flag23 = not flag23
														tbl18[arg4] = flag23
														fn30()

														if flag23 then
															fn50(false)
														else
															fn51(false)
														end
													end)

													if flag23 then
														v88.defer(function()
															fn50(true)
														end)
													end

													return v
												end

												do
													local ScreenGui = v102.new("ScreenGui")
													ScreenGui.Name = v85[57] .. v96(v89.random(v85[128], 900000))
													ScreenGui.ResetOnSpawn = false
													ScreenGui.Parent = hui
													Frame3 = v102.new("Frame", ScreenGui)
												end
											end

											Frame3.Size = v101.new(v85[117], v85[108], v85[117], 335)
											Frame3.Position = v101.new(tbl17.StealPanel.X, tbl17.StealPanel.OffsetX, tbl17.StealPanel.Y, tbl17.StealPanel.OffsetY)
											Frame3.BackgroundColor3 = tbl25.BG
											Frame3.BackgroundTransparency = 0
											Frame3.BorderSizePixel = 0
											Frame3.ClipsDescendants = true
											fn38(Frame3, 14)
											fn39(Frame3, tbl25.AQUA_STROKE, 1.3, 0.25)
											fn42(Frame3)
											Frame4 = v102.new("Frame", Frame3)
											Frame4.Size = v101.new(1, 0, 0, 48)
											Frame4.BackgroundTransparency = 1
											fn37(Frame4, Frame3, v85[47])

											do
												local TextLabel3 = v102.new("TextLabel", Frame4)
												TextLabel3.Size = v101.new(v85[48], -v85[116], v85[117], v85[157])
												TextLabel3.Position = v101.new(0, 16, v85[117], 10)
												TextLabel3.BackgroundTransparency = 1
												TextLabel3.Text = v85[135]
												TextLabel3.Font = v103.Font.GothamBlack
												TextLabel3.TextSize = 20
												TextLabel3.TextColor3 = tbl25.TEXT
												TextLabel3.TextXAlignment = v103.TextXAlignment.Center
											end
										end

										do
											local Frame5 = v102.new("Frame", Frame3)
											Frame5.AnchorPoint = Vector2.new(v85[65], 0)
											Frame5.Position = v101.new(0.5, 0, 0, 38)
											Frame5.Size = v101.new(0, 120, 0, v85[48])
											Frame5.BackgroundColor3 = v100.fromRGB(255, 255, 255)
											Frame5.BackgroundTransparency = 0.15
											Frame5.BorderSizePixel = v85[117]
										end

										ScrollingFrame = v102.new("ScrollingFrame", Frame3)
										ScrollingFrame.Size = v101.new(v85[48], -24, v85[117], 253)
										ScrollingFrame.Position = v101.new(v85[117], v85[142], 0, 56)
										ScrollingFrame.BackgroundTransparency = 1
										ScrollingFrame.BorderSizePixel = 0
										ScrollingFrame.ClipsDescendants = true
										ScrollingFrame.ScrollingDirection = v103.ScrollingDirection.Y
										ScrollingFrame.AutomaticCanvasSize = v103.AutomaticSize.None
										ScrollingFrame.ScrollBarImageTransparency = v85[48]
										ScrollingFrame.ScrollBarThickness = 0
										ScrollingFrame.CanvasSize = v101.new(0, v85[117], 0, 0)
										Frame = v102.new("Frame", ScrollingFrame)
										Frame.Name = "Holder"
										Frame.BackgroundTransparency = 1
										Frame.BorderSizePixel = 0
										Frame.Position = v101.new(0, v85[117], 0, v85[117])
										Frame.Size = v101.new(1, v85[117], 0, 0)
										Frame.ClipsDescendants = false

										do
											local UIListLayout = v102.new("UIListLayout", Frame)
											UIListLayout.Padding = UDim.new(v85[117], 5)
											UIListLayout.SortOrder = v103.SortOrder.LayoutOrder
										end

										fn43(Frame3, Frame4, ScrollingFrame, "StealPanel", tbl25)
									end
								end
							end

							do
								local v

								do
									do
										do
											local stealHUDSa = v104:FindFirstChild("StealHUD_SA")

											if stealHUDSa then
												stealHUDSa:Destroy()
											end
										end

										do
											local v106 = v102.new(v85[40])
											v106.Name = "StealHUD_SA"
											v106.ResetOnSpawn = v85[112]
											v106.IgnoreGuiInset = true
											v106.DisplayOrder = 998
											v106.ZIndexBehavior = v103.ZIndexBehavior.Sibling
											v106.Parent = gethui()
											v = v102.new(v85[73], v106)
										end
									end

									v.Name = v85[148]
									v.AnchorPoint = Vector2.new(v85[65], v85[48])
									v.Size = v101.new(0, 230, 0, 46)
									v.Position = v101.new(0.5, v85[117], 1, str8 == "phone" and -100 or str8 == "tablet" and -v85[156] or -220)

									do
										local UIScale = v102.new("UIScale", v)
										local n33 = str8 == "phone" and 0.85
										local scale

										if n33 then
											scale = n33
										else
											scale = str8 == "tablet" and 0.92
										end

										scale = scale or 1
										UIScale.Scale = scale
									end
								end

								do
									do
										v.BackgroundColor3 = tbl27.PANEL
										v.BackgroundTransparency = 0.02
										v.BorderSizePixel = 0
										v.ZIndex = 70
										fn38(v, v89.floor(12))
										fn39(v, tbl27.STROKE, 1, 0.35)

										do
											local UIStroke = v102.new("UIStroke", v)
											UIStroke.Color = tbl27.GLOW
											UIStroke.Thickness = 3
											UIStroke.Transparency = 0.84
											UIStroke.ApplyStrokeMode = v103.ApplyStrokeMode.Border
										end
									end

									do
										local ImageLabel = v102.new("ImageLabel", v)
										ImageLabel.AnchorPoint = Vector2.new(v85[65], 0.5)
										ImageLabel.Position = v101.new(0.5, 0, 0.5, 1)
										ImageLabel.Size = v101.new(1, 20, 1, 20)
										ImageLabel.BackgroundTransparency = v85[48]
										ImageLabel.Image = "rbxassetid://6014261993"
										ImageLabel.ImageColor3 = v100.new(0, 0, v85[117])
										ImageLabel.ImageTransparency = 0.72
										ImageLabel.ScaleType = v103.ScaleType.Slice
										ImageLabel.SliceCenter = Rect.new(v85[39], 49, 450, 450)
										ImageLabel.ZIndex = 69
									end
								end

								local Frame3

								do
									TextLabel = v102.new("TextLabel", v)
									TextLabel.Name = "TargetName"
									TextLabel.Size = v101.new(1, -v85[142], 0, 13)
									TextLabel.Position = v101.fromOffset(v85[147], 3)
									TextLabel.BackgroundTransparency = 1
									TextLabel.Font = v103.Font.GothamBold
									TextLabel.TextSize = v85[162]
									TextLabel.TextColor3 = tbl27.TEXT
									TextLabel.TextXAlignment = v103.TextXAlignment.Center
									TextLabel.TextTruncate = v103.TextTruncate.AtEnd
									TextLabel.ZIndex = 72
									TextLabel.Text = "No target"
									Frame3 = v102.new("Frame", v)
									Frame3.Name = "ProgressBg"
									Frame3.Size = v101.new(1, -10, 0, v85[74])
									Frame3.Position = v101.fromOffset(5, 18)
									Frame3.BackgroundColor3 = tbl27.TRACK
									Frame3.BorderSizePixel = v85[117]
									Frame3.ZIndex = 72
									fn38(Frame3, v89.floor(8))
									fn39(Frame3, tbl27.STROKE, 1, v85[152])

									do
										local Frame4 = v102.new("Frame", Frame3)
										Frame4.Name = "InnerTrack"
										Frame4.Size = v101.new(1, -2, 1, -2)
										Frame4.Position = v101.fromOffset(1, 1)
										Frame4.BackgroundColor3 = tbl27.TRACK2
										Frame4.BackgroundTransparency = 0.15
										Frame4.BorderSizePixel = 0
										Frame4.ZIndex = v85[174]
										fn38(Frame4, v89.floor(v85[92]))
									end
								end

								Frame2 = v102.new("Frame", Frame3)
								Frame2.Name = "ProgressFill"
								Frame2.Size = v101.new(v85[117], v85[117], 1, v85[117])
								Frame2.BackgroundColor3 = tbl27.FILL1
								Frame2.BorderSizePixel = v85[117]
								Frame2.ZIndex = 73
								fn38(Frame2, v89.floor(v85[176]))
								fn41(Frame2, tbl27.FILL1, tbl27.FILL2, 0)

								do
									local v106 = v85[48]
									fn39(Frame2, v100.fromRGB(v85[63], 130, v85[156]), v106, 0.45)
								end

								TextLabel2 = v102.new("TextLabel", Frame3)
							end

							TextLabel2.Name = "Percent"
							TextLabel2.Size = v101.new(v85[48], 0, 1, 0)
							TextLabel2.BackgroundTransparency = 1
							TextLabel2.Font = v103.Font.GothamBold
							TextLabel2.TextSize = 12
							TextLabel2.TextColor3 = tbl27.TEXT
						end

						local fn44, fn45, nearest, highest, autoKick2, instantSteal2, infiniteJump, tbl27, tbl28, v
						local antiDie, antiRag, turret, balloon, floatRef, carpetRef, invisRef, wsRef, flag22

						do
							do
								local Frame3

								do
									local Frame4

									do
										do
											TextLabel2.TextStrokeTransparency = 0.7
											TextLabel2.TextXAlignment = v103.TextXAlignment.Center
											TextLabel2.ZIndex = 74
											TextLabel2.Text = "0%"

											do
												local targetControlsSa = hui:FindFirstChild("TargetControls_SA")

												if targetControlsSa then
													targetControlsSa:Destroy()
												end
											end
										end

										do
											local ScreenGui = v102.new("ScreenGui")
											ScreenGui.Name = "TargetControls_SA"
											ScreenGui.ResetOnSpawn = false
											ScreenGui.IgnoreGuiInset = v85[8]
											ScreenGui.DisplayOrder = 999
											ScreenGui.ZIndexBehavior = v103.ZIndexBehavior.Sibling
											ScreenGui.Parent = hui
											Frame4 = v102.new("Frame", ScreenGui)
										end

										Frame4.AutomaticSize = v103.AutomaticSize.Y
										Frame4.Size = v101.new(0, v85[78], 0, v85[117])
										Frame4.Position = v101.new(tbl17.TargetControls.X, tbl17.TargetControls.OffsetX, tbl17.TargetControls.Y, tbl17.TargetControls.OffsetY)
										Frame4.BackgroundColor3 = tbl26.BG
										Frame4.BackgroundTransparency = 0
										Frame4.BorderSizePixel = 0
										Frame4.ClipsDescendants = v85[112]
										Frame4.ZIndex = 100
										fn38(Frame4, 18)
										fn39(Frame4, tbl26.AQUA_STROKE, 1.2, 0.4)
										fn42(Frame4)

										do
											local ImageLabel = v102.new("ImageLabel", Frame4)
											ImageLabel.AnchorPoint = Vector2.new(0.5, v85[65])
											ImageLabel.Position = v101.new(0.5, 0, v85[65], 2)
											ImageLabel.Size = v101.new(1, 24, 1, v85[157])
											ImageLabel.BackgroundTransparency = 1
											ImageLabel.Image = "rbxassetid://6014261993"
											ImageLabel.ImageColor3 = v100.new(0, 0, 0)
											ImageLabel.ImageTransparency = 0.72
											ImageLabel.ScaleType = v103.ScaleType.Slice
											ImageLabel.SliceCenter = Rect.new(49, 49, v85[80], 450)
											ImageLabel.ZIndex = 99
										end
									end

									local Frame5

									do
										do
											Frame5 = v102.new("Frame", Frame4)
											Frame5.Size = v101.new(1, 0, 0, 44)
											Frame5.BackgroundTransparency = 1
											Frame5.ZIndex = v85[4]
											fn37(Frame5, Frame4, v85[37])

											do
												local TextLabel3 = v102.new("TextLabel", Frame5)
												TextLabel3.Size = v101.new(v85[48], -v85[139], 0, 24)
												TextLabel3.Position = v101.new(0, v85[6], 0, 10)
												TextLabel3.ZIndex = 102
												TextLabel3.BackgroundTransparency = 1
												TextLabel3.Text = v85[122]
												TextLabel3.Font = v103.Font.GothamBlack
												TextLabel3.TextSize = v85[74]
												TextLabel3.TextColor3 = tbl26.TEXT
												TextLabel3.TextXAlignment = v103.TextXAlignment.Center
											end
										end

										do
											local Frame6 = v102.new("Frame", Frame4)
											Frame6.AnchorPoint = Vector2.new(v85[65], 0)
											Frame6.Position = v101.new(0.5, 0, 0, v85[178])
											Frame6.Size = v101.new(v85[117], 124, 0, 1)
											Frame6.BackgroundColor3 = v100.fromRGB(255, v85[63], v85[63])
											Frame6.BackgroundTransparency = v85[175]
											Frame6.BorderSizePixel = v85[117]
											Frame6.ZIndex = 101
										end
									end

									local Frame6 = v102.new("Frame", Frame4)
									Frame6.AutomaticSize = v103.AutomaticSize.Y
									Frame6.Size = v101.new(1, -20, 0, v85[117])
									Frame6.Position = v101.fromOffset(v85[36], 48)
									Frame6.BackgroundColor3 = tbl26.SURF
									Frame6.BorderSizePixel = v85[117]
									Frame6.ZIndex = v85[4]
									fn38(Frame6, v85[155])
									fn39(Frame6, tbl26.AQUA_STROKE, 1, 0.48)
									Frame3 = v102.new("Frame", Frame6)
									Frame3.AutomaticSize = v103.AutomaticSize.Y
									Frame3.Size = v101.new(1, -10, 0, 0)
									Frame3.Position = v101.fromOffset(v85[23], 5)
									Frame3.BackgroundTransparency = 1
									Frame3.ZIndex = 102
									local UIListLayout = v102.new("UIListLayout", Frame3)
									UIListLayout.Padding = UDim.new(0, v85[176])
									UIListLayout.SortOrder = v103.SortOrder.LayoutOrder
									fn43(Frame4, Frame5, Frame6, "TargetControls")
								end

								do
									do
										fn44 = function(arg, text, layoutOrder)
											local Frame4 = v102.new("Frame", arg)
											local v106 = v85[50]
											Frame4.Name = text:gsub("%s+", "") .. v106
											Frame4.Size = v101.new(1, 0, v85[117], 36)
											Frame4.BackgroundColor3 = tbl26.SURF2
											Frame4.BackgroundTransparency = v85[59]
											Frame4.BorderSizePixel = 0
											Frame4.LayoutOrder = layoutOrder
											Frame4.ZIndex = v85[125]
											fn38(Frame4, 11)
											local v107 = fn39(Frame4, tbl26.AQUA_STROKE, 1, 0.52)
											local TextLabel3 = v102.new("TextLabel", Frame4)
											TextLabel3.BackgroundTransparency = 1
											TextLabel3.Position = v101.fromOffset(12, v85[117])
											TextLabel3.Size = v101.new(1, -100, 1, v85[117])
											TextLabel3.Font = v103.Font.GothamBold
											TextLabel3.Text = text
											TextLabel3.TextColor3 = tbl26.TEXT
											TextLabel3.TextSize = 12
											TextLabel3.TextXAlignment = v103.TextXAlignment.Left
											TextLabel3.ZIndex = v85[188]
											local TextButton = v102.new("TextButton", Frame4)
											TextButton.AutoButtonColor = false
											TextButton.Size = v101.fromOffset(72, 22)
											TextButton.Position = v101.new(1, -v85[2], v85[65], -11)
											TextButton.BackgroundColor3 = tbl26.OFF_BG
											TextButton.BorderSizePixel = v85[117]
											TextButton.Text = ""
											TextButton.ZIndex = 104
											fn38(TextButton, 7)
											local v108 = fn39(TextButton, tbl26.AQUA_STROKE, 1, 0.55)
											local v109 = v102.new(v85[73], TextButton)
											v109.Size = v101.new(1, 0, 1, 0)
											v109.BackgroundTransparency = 1
											v109.BorderSizePixel = v85[117]
											v109.ZIndex = 104
											fn38(v109, 7)
											fn41(v109, tbl26.GREEN1, tbl26.GREEN2, 0)
											local TextLabel4 = v102.new("TextLabel", TextButton)
											TextLabel4.BackgroundTransparency = 1
											TextLabel4.Size = v101.fromScale(v85[48], 1)
											TextLabel4.Font = v103.Font.GothamBold
											TextLabel4.TextSize = 11
											TextLabel4.Text = v85[181]
											TextLabel4.TextColor3 = tbl26.OFF_TEXT
											TextLabel4.ZIndex = 105

											Frame4.MouseEnter:Connect(function()
												fn40(Frame4, 0.14, { BackgroundColor3 = v100.fromRGB(58, 20, 20) })
												fn40(v107, v85[144], { Transparency = 0.38 })
											end)

											Frame4.MouseLeave:Connect(function()
												fn40(Frame4, 0.14, { BackgroundColor3 = tbl26.SURF2 })
												fn40(v107, 0.14, { Transparency = v85[193] })
											end)

											return { row = Frame4, label = TextLabel3, button = TextButton, knob = v109, stateLabel = TextLabel4, stroke = v108, rowStroke = v107 }
										end

										fn45 = function(arg, text, text2, layoutOrder)
											local Frame4 = v102.new("Frame", arg)
											local v106 = v85[50]
											Frame4.Name = text:gsub("%s+", "") .. v106
											Frame4.Size = v101.new(1, v85[117], 0, 36)
											Frame4.BackgroundColor3 = tbl26.SURF2
											Frame4.BackgroundTransparency = 0.02
											Frame4.BorderSizePixel = v85[117]
											Frame4.LayoutOrder = layoutOrder
											Frame4.ZIndex = 103
											fn38(Frame4, 11)
											local v107 = fn39(Frame4, tbl26.AQUA_STROKE, 1, v85[193])
											local v108 = v102.new(v85[66], Frame4)
											v108.BackgroundTransparency = 1
											v108.Position = v101.fromOffset(12, 0)
											v108.Size = v101.new(1, -100, 1, 0)
											v108.Font = v103.Font.GothamBold
											v108.Text = text
											v108.TextColor3 = tbl26.TEXT
											v108.TextSize = 12
											v108.TextXAlignment = v103.TextXAlignment.Left
											v108.ZIndex = 104
											local v109 = v102.new(v85[68], Frame4)
											v109.AutoButtonColor = v85[112]
											v109.Size = v101.fromOffset(72, v85[76])
											v109.Position = v101.new(1, -82, v85[65], -11)
											v109.BackgroundColor3 = tbl26.AQUA2
											v109.BorderSizePixel = 0
											v109.Text = text2
											v109.ZIndex = 104
											v109.Font = v103.Font.GothamBold
											v109.TextSize = v85[162]
											v109.TextColor3 = tbl26.TEXT
											fn38(v109, v85[92])
											local v110 = fn39(v109, tbl26.AQUA, 1, 0.35)

											Frame4.MouseEnter:Connect(function()
												fn40(Frame4, 0.14, { BackgroundColor3 = v100.fromRGB(58, 20, 20) })
												fn40(v107, v85[144], { Transparency = 0.38 })
											end)

											Frame4.MouseLeave:Connect(function()
												fn40(Frame4, 0.14, { BackgroundColor3 = tbl26.SURF2 })
												fn40(v107, 0.14, { Transparency = 0.52 })
											end)

											v109.MouseButton1Down:Connect(function()
												fn40(v109, 0.08, { BackgroundColor3 = tbl26.AQUA })
											end)

											v109.MouseButton1Up:Connect(function()
												fn40(v109, 0.14, { BackgroundColor3 = tbl26.AQUA2 })
											end)

											return { row = Frame4, label = v108, button = v109, stroke = v110, rowStroke = v107 }
										end

										nearest = fn44(Frame3, "Nearest", 1)
										highest = fn44(Frame3, "Highest", 2)
										autoKick2 = fn44(Frame3, "Auto Kick", v85[62])
										instantSteal2 = fn44(Frame3, "Instant Steal", 4)
										infiniteJump = fn44(Frame3, "Infinite Jump", 5)

										do
											local function fn46(arg, arg2, arg3, layoutOrder)
												local v106 = v102.new(v85[73], arg)
												v106.Name = "DualRow"
												v106.Size = v101.new(1, v85[117], v85[117], 36)
												v106.BackgroundColor3 = tbl26.SURF2
												v106.BackgroundTransparency = 0.02
												v106.BorderSizePixel = 0
												v106.LayoutOrder = layoutOrder
												v106.ZIndex = 103
												fn38(v106, 11)
												local v107 = fn39(v106, tbl26.AQUA_STROKE, v85[48], 0.52)

												v106.MouseEnter:Connect(function()
													fn40(v106, 0.14, { BackgroundColor3 = v100.fromRGB(58, 20, v85[129]) })
													fn40(v107, 0.14, { Transparency = 0.38 })
												end)

												v106.MouseLeave:Connect(function()
													fn40(v106, v85[144], { BackgroundColor3 = tbl26.SURF2 })
													fn40(v107, 0.14, { Transparency = 0.52 })
												end)

												local function fn47(text, arg4)
													local v108 = v102.new(v85[68], v106)
													v108.AutoButtonColor = false
													v108.Size = v101.new(v85[65], -9, 0, 24)
													v108.Position = v101.new(arg4, arg4 == 0 and 6 or 3, 0.5, -12)
													v108.BackgroundColor3 = tbl26.AQUA2
													v108.BorderSizePixel = 0
													v108.Text = text
													v108.ZIndex = 104
													v108.Font = v103.Font.GothamBold
													v108.TextSize = 11
													v108.TextColor3 = tbl26.TEXT
													fn38(v108, v85[92])
													local v109 = fn39(v108, tbl26.AQUA, 1, 0.35)

													v108.MouseButton1Down:Connect(function()
														fn40(v108, 0.08, { BackgroundColor3 = tbl26.AQUA })
													end)

													v108.MouseButton1Up:Connect(function()
														fn40(v108, 0.14, { BackgroundColor3 = tbl26.AQUA2 })
													end)

													return { button = v108, stroke = v109 }
												end

												return { row = v106, left = fn47(arg2, 0), right = fn47(arg3, 0.5), rowStroke = v107 }
											end

											local reset = fn46(Frame3, v85[101], "RESET", 6)
											tbl27 = { button = reset.left.button }
											tbl28 = { button = reset.right.button }
										end
									end

									do
										local Frame4 = v102.new("Frame", Frame3)
										Frame4.Size = v101.new(1, 0, 0, 5)
										Frame4.BackgroundTransparency = 1
										Frame4.LayoutOrder = 99
									end

									do
										local function fn46()
											local ScreenGui = v102.new("ScreenGui")
											ScreenGui.Name = "Visuals_SA"
											ScreenGui.ResetOnSpawn = false
											ScreenGui.IgnoreGuiInset = true
											ScreenGui.DisplayOrder = v85[29]
											ScreenGui.ZIndexBehavior = v103.ZIndexBehavior.Sibling
											ScreenGui.Parent = hui
											local Frame4 = v102.new("Frame", ScreenGui)
											Frame4.AutomaticSize = v103.AutomaticSize.Y
											Frame4.Size = v101.new(0, 240, 0, v85[117])
											Frame4.Position = v101.new(tbl17.Visuals.X, tbl17.Visuals.OffsetX, tbl17.Visuals.Y, tbl17.Visuals.OffsetY)
											Frame4.BackgroundColor3 = tbl26.BG
											Frame4.BackgroundTransparency = 0
											Frame4.BorderSizePixel = 0
											Frame4.ClipsDescendants = false
											Frame4.ZIndex = 100
											fn38(Frame4, 18)
											fn39(Frame4, tbl26.AQUA_STROKE, v85[95], 0.4)
											fn42(Frame4)
											local ImageLabel = v102.new("ImageLabel", Frame4)
											ImageLabel.AnchorPoint = Vector2.new(v85[65], 0.5)
											ImageLabel.Position = v101.new(0.5, 0, v85[65], 2)
											ImageLabel.Size = v101.new(v85[48], 24, 1, v85[157])
											ImageLabel.BackgroundTransparency = 1
											ImageLabel.Image = "rbxassetid://6014261993"
											ImageLabel.ImageColor3 = v100.new(0, 0, 0)
											ImageLabel.ImageTransparency = v85[52]
											ImageLabel.ScaleType = v103.ScaleType.Slice
											ImageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
											ImageLabel.ZIndex = 99
											local v106 = v102.new(v85[73], Frame4)
											v106.Size = v101.new(1, 0, 0, 44)
											v106.BackgroundTransparency = 1
											v106.ZIndex = 101
											fn37(v106, Frame4, "Visuals")
											local TextLabel3 = v102.new("TextLabel", v106)
											TextLabel3.Size = v101.new(v85[48], -28, 0, 24)
											TextLabel3.Position = v101.new(0, 14, 0, 10)
											TextLabel3.ZIndex = 102
											TextLabel3.BackgroundTransparency = 1
											TextLabel3.Text = "VISUALS"
											TextLabel3.Font = v103.Font.GothamBlack
											TextLabel3.TextSize = v85[74]
											TextLabel3.TextColor3 = tbl26.TEXT
											TextLabel3.TextXAlignment = v103.TextXAlignment.Center
											local Frame5 = v102.new("Frame", Frame4)
											Frame5.AnchorPoint = Vector2.new(0.5, v85[117])
											Frame5.Position = v101.new(v85[65], 0, 0, 38)
											Frame5.Size = v101.new(0, 124, 0, v85[48])
											Frame5.BackgroundColor3 = v100.fromRGB(255, 255, v85[63])
											Frame5.BackgroundTransparency = 0.15
											Frame5.BorderSizePixel = 0
											Frame5.ZIndex = 101
											local Frame6 = v102.new("Frame", Frame4)
											Frame6.AutomaticSize = v103.AutomaticSize.Y
											Frame6.Size = v101.new(1, -20, 0, 0)
											Frame6.Position = v101.fromOffset(v85[36], 48)
											Frame6.BackgroundColor3 = tbl26.SURF
											Frame6.BorderSizePixel = 0
											Frame6.ZIndex = v85[4]
											fn38(Frame6, 16)
											fn39(Frame6, tbl26.AQUA_STROKE, 1, v85[118])
											local Frame7 = v102.new("Frame", Frame6)
											Frame7.AutomaticSize = v103.AutomaticSize.Y
											Frame7.Size = v101.new(v85[48], -10, 0, v85[117])
											Frame7.Position = v101.fromOffset(5, 5)
											Frame7.BackgroundTransparency = 1
											Frame7.ZIndex = 102
											local UIListLayout = v102.new("UIListLayout", Frame7)
											UIListLayout.Padding = UDim.new(0, 8)
											UIListLayout.SortOrder = v103.SortOrder.LayoutOrder
											fn43(Frame4, v106, Frame6, "Visuals")
											local v107 = v102.new(v85[73], Frame7)
											v107.Size = v101.new(1, 0, 0, 5)
											v107.BackgroundTransparency = 1
											v107.LayoutOrder = 99
											return Frame7
										end

										v = fn46()
									end
								end
							end

							local gui

							do
								local function fn46()
									local ScreenGui = v102.new("ScreenGui")
									ScreenGui.Name = "Protection_SA"
									ScreenGui.ResetOnSpawn = false
									ScreenGui.IgnoreGuiInset = true
									ScreenGui.DisplayOrder = 999
									ScreenGui.ZIndexBehavior = v103.ZIndexBehavior.Sibling
									ScreenGui.Parent = hui
									local Frame3 = v102.new("Frame", ScreenGui)
									Frame3.AutomaticSize = v103.AutomaticSize.Y
									Frame3.Size = v101.new(0, v85[78], 0, 0)
									Frame3.Position = v101.new(tbl17.Protection.X, tbl17.Protection.OffsetX, tbl17.Protection.Y, tbl17.Protection.OffsetY)
									Frame3.BackgroundColor3 = tbl26.BG
									Frame3.BackgroundTransparency = 0
									Frame3.BorderSizePixel = 0
									Frame3.ClipsDescendants = false
									Frame3.ZIndex = 100
									fn38(Frame3, 18)
									fn39(Frame3, tbl26.AQUA_STROKE, 1.2, 0.4)
									fn42(Frame3)
									local ImageLabel = v102.new("ImageLabel", Frame3)
									ImageLabel.AnchorPoint = Vector2.new(0.5, v85[65])
									ImageLabel.Position = v101.new(0.5, 0, v85[65], 2)
									ImageLabel.Size = v101.new(1, 24, v85[48], v85[157])
									ImageLabel.BackgroundTransparency = 1
									ImageLabel.Image = "rbxassetid://6014261993"
									ImageLabel.ImageColor3 = v100.new(0, 0, 0)
									ImageLabel.ImageTransparency = 0.72
									ImageLabel.ScaleType = v103.ScaleType.Slice
									ImageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
									ImageLabel.ZIndex = 99
									local Frame4 = v102.new("Frame", Frame3)
									Frame4.Size = v101.new(1, 0, 0, v85[149])
									Frame4.BackgroundTransparency = 1
									Frame4.ZIndex = 101
									fn37(Frame4, Frame3, "Protection")
									local TextLabel3 = v102.new("TextLabel", Frame4)
									TextLabel3.Size = v101.new(v85[48], -28, 0, 24)
									TextLabel3.Position = v101.new(0, v85[6], 0, v85[36])
									TextLabel3.ZIndex = 102
									TextLabel3.BackgroundTransparency = v85[48]
									TextLabel3.Text = "PROTECTION"
									TextLabel3.Font = v103.Font.GothamBlack
									TextLabel3.TextSize = v85[74]
									TextLabel3.TextColor3 = tbl26.TEXT
									TextLabel3.TextXAlignment = v103.TextXAlignment.Center
									local Frame5 = v102.new("Frame", Frame3)
									Frame5.AnchorPoint = Vector2.new(0.5, v85[117])
									Frame5.Position = v101.new(0.5, 0, 0, v85[178])
									Frame5.Size = v101.new(0, v85[97], 0, 1)
									Frame5.BackgroundColor3 = v100.fromRGB(v85[63], 255, 255)
									Frame5.BackgroundTransparency = v85[175]
									Frame5.BorderSizePixel = 0
									Frame5.ZIndex = 101
									local Frame6 = v102.new("Frame", Frame3)
									Frame6.AutomaticSize = v103.AutomaticSize.Y
									Frame6.Size = v101.new(1, -20, 0, v85[117])
									Frame6.Position = v101.fromOffset(10, v85[71])
									Frame6.BackgroundColor3 = tbl26.SURF
									Frame6.BorderSizePixel = 0
									Frame6.ZIndex = 101
									fn38(Frame6, 16)
									fn39(Frame6, tbl26.AQUA_STROKE, v85[48], 0.48)
									local Frame7 = v102.new("Frame", Frame6)
									Frame7.AutomaticSize = v103.AutomaticSize.Y
									Frame7.Size = v101.new(1, -10, 0, v85[117])
									Frame7.Position = v101.fromOffset(5, 5)
									Frame7.BackgroundTransparency = 1
									Frame7.ZIndex = 102
									local UIListLayout = v102.new("UIListLayout", Frame7)
									UIListLayout.Padding = UDim.new(0, 8)
									UIListLayout.SortOrder = v103.SortOrder.LayoutOrder
									fn43(Frame3, Frame4, Frame6, "Protection")
									local Frame8 = v102.new("Frame", Frame7)
									Frame8.Size = v101.new(1, 0, 0, 5)
									Frame8.BackgroundTransparency = 1
									Frame8.LayoutOrder = v85[72]

									return {
										gui = ScreenGui,
										antiDie = fn44(Frame7, "Anti Die", v85[48]),
										antiRag = fn44(Frame7, "Anti Ragdoll", 2),
										turret = fn44(Frame7, "Auto Turret", v85[62]),
										balloon = fn44(Frame7, "Balloon Reset", 4),
									}
								end

								local v106 = fn46()
								gui = v106.gui
								antiDie = v106.antiDie
								antiRag = v106.antiRag
								turret = v106.turret
								balloon = v106.balloon
							end

							local v106

							do
								local function fn46()
									local ScreenGui = v102.new("ScreenGui")
									ScreenGui.Name = v85[113]
									ScreenGui.ResetOnSpawn = false
									ScreenGui.IgnoreGuiInset = true
									ScreenGui.DisplayOrder = v85[29]
									ScreenGui.ZIndexBehavior = v103.ZIndexBehavior.Sibling
									ScreenGui.Parent = hui
									local Frame3 = v102.new("Frame", ScreenGui)
									Frame3.AutomaticSize = v103.AutomaticSize.Y
									Frame3.Size = v101.new(0, v85[78], 0, 0)
									Frame3.Position = v101.new(tbl17.Keybinds.X, tbl17.Keybinds.OffsetX, tbl17.Keybinds.Y, tbl17.Keybinds.OffsetY)
									Frame3.BackgroundColor3 = tbl26.BG
									Frame3.BackgroundTransparency = v85[117]
									Frame3.BorderSizePixel = 0
									Frame3.ClipsDescendants = false
									Frame3.ZIndex = 100
									fn38(Frame3, v85[74])
									fn39(Frame3, tbl26.AQUA_STROKE, 1.2, v85[153])
									fn42(Frame3)
									local v107 = v102.new(v85[167], Frame3)
									v107.AnchorPoint = Vector2.new(0.5, 0.5)
									v107.Position = v101.new(0.5, 0, 0.5, 2)
									v107.Size = v101.new(1, 24, 1, 24)
									v107.BackgroundTransparency = 1
									v107.Image = "rbxassetid://6014261993"
									v107.ImageColor3 = v100.new(0, 0, 0)
									v107.ImageTransparency = 0.72
									v107.ScaleType = v103.ScaleType.Slice
									v107.SliceCenter = Rect.new(49, 49, v85[80], v85[80])
									v107.ZIndex = 99
									local Frame4 = v102.new("Frame", Frame3)
									Frame4.Size = v101.new(1, v85[117], 0, 44)
									Frame4.BackgroundTransparency = 1
									Frame4.ZIndex = 101
									fn37(Frame4, Frame3, "Keybinds")
									local TextLabel3 = v102.new("TextLabel", Frame4)
									TextLabel3.Size = v101.new(1, -28, 0, 24)
									TextLabel3.Position = v101.new(0, 14, v85[117], v85[36])
									TextLabel3.ZIndex = v85[154]
									TextLabel3.BackgroundTransparency = 1
									TextLabel3.Text = flag18 and "ACTIONS" or "KEYBINDS"
									TextLabel3.Font = v103.Font.GothamBlack
									TextLabel3.TextSize = 18
									TextLabel3.TextColor3 = tbl26.TEXT
									TextLabel3.TextXAlignment = v103.TextXAlignment.Center
									local Frame5 = v102.new("Frame", Frame3)
									Frame5.AnchorPoint = Vector2.new(0.5, 0)
									Frame5.Position = v101.new(0.5, v85[117], 0, 38)
									Frame5.Size = v101.new(0, 124, 0, v85[48])
									Frame5.BackgroundColor3 = v100.fromRGB(255, v85[63], 255)
									Frame5.BackgroundTransparency = v85[175]
									Frame5.BorderSizePixel = 0
									Frame5.ZIndex = 101
									local Frame6 = v102.new("Frame", Frame3)
									Frame6.AutomaticSize = v103.AutomaticSize.Y
									Frame6.Size = v101.new(v85[48], -20, 0, 0)
									Frame6.Position = v101.fromOffset(v85[36], 48)
									Frame6.BackgroundColor3 = tbl26.SURF
									Frame6.BorderSizePixel = 0
									Frame6.ZIndex = 101
									fn38(Frame6, 16)
									fn39(Frame6, tbl26.AQUA_STROKE, 1, v85[118])
									local Frame7 = v102.new("Frame", Frame6)
									Frame7.AutomaticSize = v103.AutomaticSize.Y
									Frame7.Size = v101.new(1, -v85[36], 0, 0)
									Frame7.Position = v101.fromOffset(5, 5)
									Frame7.BackgroundTransparency = 1
									Frame7.ZIndex = v85[154]
									local UIListLayout = v102.new("UIListLayout", Frame7)
									UIListLayout.Padding = UDim.new(v85[117], 8)
									UIListLayout.SortOrder = v103.SortOrder.LayoutOrder
									fn43(Frame3, Frame4, Frame6, "Keybinds")
									local Frame8 = v102.new("Frame", Frame7)
									Frame8.Size = v101.new(v85[48], 0, 0, 5)
									Frame8.BackgroundTransparency = v85[48]
									Frame8.LayoutOrder = 99
									local v108 = nil

									local function fn47(arg, text, arg2, layoutOrder)
										local v109 = v102.new(v85[73], arg)
										local v110 = v85[50]
										v109.Name = text:gsub("%s+", "") .. v110
										v109.Size = v101.new(1, 0, 0, 36)
										v109.BackgroundColor3 = tbl26.SURF2
										v109.BackgroundTransparency = 0.02
										v109.BorderSizePixel = 0
										v109.LayoutOrder = layoutOrder
										v109.ZIndex = 103
										fn38(v109, 11)
										local v111 = fn39(v109, tbl26.AQUA_STROKE, 1, 0.52)
										local TextLabel4 = v102.new("TextLabel", v109)
										TextLabel4.BackgroundTransparency = 1
										TextLabel4.Position = v101.fromOffset(12, 0)
										TextLabel4.Size = v101.new(1, -100, 1, 0)
										TextLabel4.Font = v103.Font.GothamBold
										TextLabel4.Text = text
										TextLabel4.TextColor3 = tbl26.TEXT
										TextLabel4.TextSize = v85[142]
										TextLabel4.TextXAlignment = v103.TextXAlignment.Left
										TextLabel4.ZIndex = 104
										local TextButton = v102.new("TextButton", v109)
										TextButton.AutoButtonColor = false
										TextButton.Size = v101.fromOffset(72, 22)
										TextButton.Position = v101.new(1, -82, 0.5, -v85[162])
										TextButton.BackgroundColor3 = tbl26.OFF_BG
										TextButton.BorderSizePixel = v85[117]
										TextButton.Text = tbl20[arg2]
										TextButton.ZIndex = 104
										TextButton.Font = v103.Font.GothamBold
										TextButton.TextSize = 11
										TextButton.TextColor3 = tbl26.TEXT
										fn38(TextButton, 7)
										local v112 = fn39(TextButton, tbl26.AQUA_STROKE, 1, 0.55)
										local flag23 = v85[112]

										local function fn48()
											return flag23 and tbl26.GREEN1 or tbl26.SURF2
										end

										local function fn49()
											return flag23 and tbl26.GREEN_STROKE or tbl26.AQUA_STROKE
										end

										local function fn50()
											return flag23 and tbl26.GREEN2 or tbl26.OFF_BG
										end

										local function fn51(arg3)
											flag23 = arg3 and true or false
											fn40(v109, 0.16, { BackgroundColor3 = fn48() })
											fn40(v111, v85[77], { Color = fn49(), Transparency = flag23 and 0.22 or 0.52 })
											fn40(TextButton, v85[77], { BackgroundColor3 = fn50() })
											fn40(v112, 0.16, { Color = fn49(), Transparency = flag23 and v85[137] or 0.55 })
										end

										v109.MouseEnter:Connect(function()
											fn40(v109, 0.14, { BackgroundColor3 = flag23 and tbl26.GREEN2 or v100.fromRGB(58, v85[129], v85[129]) })
											fn40(v111, v85[144], { Transparency = flag23 and v85[114] or 0.38 })
										end)

										v109.MouseLeave:Connect(function()
											fn40(v109, 0.14, { BackgroundColor3 = fn48() })
											fn40(v111, 0.14, { Transparency = flag23 and 0.22 or v85[193] })
										end)

										TextButton.MouseButton1Click:Connect(function()
											if v108 then
												return
											end
											v108 = arg2
											TextButton.Text = v85[49]
											fn40(TextButton, 0.14, { BackgroundColor3 = tbl26.AQUA2 })
											fn40(v112, 0.14, { Color = tbl26.AQUA, Transparency = 0.2 })
											local connection = nil

											connection = UserInputService.InputBegan:Connect(function(input)
												if input.UserInputType ~= v103.UserInputType.Keyboard then
													return
												end
												connection:Disconnect()
												v108 = nil
												local name = input.KeyCode.Name

												if name ~= "Escape" and name ~= "Unknown" then
													tbl20[arg2] = name
													fn30()
												end

												TextButton.Text = tbl20[arg2]
												fn40(TextButton, 0.14, { BackgroundColor3 = fn50() })
												fn40(v112, 0.14, { Color = fn49(), Transparency = flag23 and 0.2 or 0.55 })
											end)
										end)

										return { row = v109, label = TextLabel4, button = TextButton, stroke = v112, rowStroke = v111, setActive = fn51 }
									end

									local v109, walkSpeed, float, carpetSpeed

									if flag18 then
										v109 = fn44(Frame7, v85[146], 1)
										walkSpeed = fn44(Frame7, v85[190], 2)
										float = fn44(Frame7, "Float", 3)
										carpetSpeed = fn44(Frame7, "Carpet Speed", 4)
										local clone = fn45(Frame7, v85[104], "CLONE", v85[23])
										local drop = fn45(Frame7, v85[10], "DROP", v85[147])
										local instantReset = fn45(Frame7, "Instant Reset", "RESET", v85[92])

										clone.button.MouseButton1Click:Connect(function()
											if _G.instantClone then
												v88.spawn(_G.instantClone)
											end

											clone.button.Text = "CLONED"

											v88.delay(0.8, function()
												if clone.button.Parent then
													clone.button.Text = "CLONE"
												end
											end)
										end)

										drop.button.MouseButton1Click:Connect(function()
											if _G.dropBrainrot then
												v88.spawn(_G.dropBrainrot)
											end

											drop.button.Text = v85[163]

											v88.delay(0.8, function()
												if drop.button.Parent then
													drop.button.Text = "DROP"
												end
											end)
										end)

										instantReset.button.MouseButton1Click:Connect(function()
											if _G.FlingUp then
												v88.spawn(_G.FlingUp)
											end

											instantReset.button.Text = "RESETTING"

											v88.delay(1, function()
												if instantReset.button.Parent then
													instantReset.button.Text = "RESET"
												end
											end)
										end)
									else
										v109 = fn47(Frame7, v85[146], v85[89], 1)
										walkSpeed = fn47(Frame7, "WalkSpeed", v85[93], 2)
										fn47(Frame7, "Auto Clone", "clone", 3)
										float = fn47(Frame7, "Float", v85[194], 4)
										carpetSpeed = fn47(Frame7, "Carpet Speed", "carpet", 5)
										fn47(Frame7, v85[10], "drop", 6)
										fn47(Frame7, "Instant Reset", v85[33], 7)
									end

									return { gui = ScreenGui, floatRef = float, carpetRef = carpetSpeed, invisRef = v109, wsRef = walkSpeed }
								end

								v106 = fn46()
							end

							local gui2 = v106.gui
							floatRef = v106.floatRef
							carpetRef = v106.carpetRef
							invisRef = v106.invisRef
							wsRef = v106.wsRef
							flag22 = not flag18

							if flag22 then
								UserInputService.InputBegan:Connect(function(input, gameProcessed)
									if gameProcessed then
										return
									end

									if input.KeyCode == v103.KeyCode.LeftControl then
										if gui2 then
											gui2.Enabled = not gui2.Enabled
										end

										if gui then
											gui.Enabled = not gui.Enabled
										end
									end
								end)
							end
						end

						local fn46

						do
							do
								do
									local function fn47()
										local ScreenGui = v102.new("ScreenGui")
										ScreenGui.Name = "JobCopier_SA"
										ScreenGui.ResetOnSpawn = false
										ScreenGui.IgnoreGuiInset = true
										ScreenGui.DisplayOrder = 999
										ScreenGui.ZIndexBehavior = v103.ZIndexBehavior.Sibling
										ScreenGui.Parent = hui
										local Frame3 = v102.new("Frame", ScreenGui)
										Frame3.Size = v101.new(0, 360, 0, 108)
										Frame3.AnchorPoint = Vector2.new(0.5, 0)
										Frame3.Position = v101.new(tbl17.JobCopier.X, tbl17.JobCopier.OffsetX, tbl17.JobCopier.Y, tbl17.JobCopier.OffsetY)
										Frame3.BackgroundColor3 = tbl26.BG
										Frame3.BackgroundTransparency = 0
										Frame3.BorderSizePixel = 0
										Frame3.ClipsDescendants = v85[112]
										Frame3.ZIndex = 100
										fn38(Frame3, 18)
										fn39(Frame3, tbl26.AQUA_STROKE, 1.2, 0.4)
										fn42(Frame3)
										local ImageLabel = v102.new("ImageLabel", Frame3)
										ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
										ImageLabel.Position = v101.new(0.5, 0, 0.5, 2)
										ImageLabel.Size = v101.new(1, 24, 1, 24)
										ImageLabel.BackgroundTransparency = 1
										ImageLabel.Image = "rbxassetid://6014261993"
										ImageLabel.ImageColor3 = v100.new(v85[117], v85[117], v85[117])
										ImageLabel.ImageTransparency = 0.72
										ImageLabel.ScaleType = v103.ScaleType.Slice
										ImageLabel.SliceCenter = Rect.new(49, 49, v85[80], 450)
										ImageLabel.ZIndex = 99
										local v106 = v102.new(v85[73], Frame3)
										v106.Size = v101.new(v85[48], v85[117], 0, 44)
										v106.BackgroundTransparency = 1
										v106.ZIndex = 101
										fn37(v106, Frame3, v85[14])
										local TextLabel3 = v102.new("TextLabel", v106)
										TextLabel3.Size = v101.new(1, -28, 0, 24)
										TextLabel3.Position = v101.new(0, v85[6], 0, 10)
										TextLabel3.ZIndex = 102
										TextLabel3.BackgroundTransparency = v85[48]
										TextLabel3.Text = "JOB ID"
										TextLabel3.Font = v103.Font.GothamBlack
										TextLabel3.TextSize = 18
										TextLabel3.TextColor3 = tbl26.TEXT
										TextLabel3.TextXAlignment = v103.TextXAlignment.Center
										local v107 = v102.new(v85[73], Frame3)
										v107.AnchorPoint = Vector2.new(0.5, 0)
										v107.Position = v101.new(0.5, 0, 0, 38)
										v107.Size = v101.new(0, 124, 0, 1)
										v107.BackgroundColor3 = v100.fromRGB(255, v85[63], v85[63])
										v107.BackgroundTransparency = 0.15
										v107.BorderSizePixel = 0
										v107.ZIndex = v85[4]
										local Frame4 = v102.new("Frame", Frame3)
										Frame4.Size = v101.new(v85[48], -v85[129], v85[117], 52)
										Frame4.Position = v101.fromOffset(10, 48)
										Frame4.BackgroundColor3 = tbl26.SURF
										Frame4.BorderSizePixel = v85[117]
										Frame4.ZIndex = v85[4]
										fn38(Frame4, 16)
										fn39(Frame4, tbl26.AQUA_STROKE, 1, 0.48)
										fn43(Frame3, v106, Frame4, "JobCopier")
										local TextLabel4 = v102.new("TextLabel", Frame4)
										TextLabel4.Size = v101.new(1, -10, 0, 22)
										TextLabel4.Position = v101.fromOffset(v85[23], 5)
										TextLabel4.BackgroundColor3 = tbl26.SURF2
										TextLabel4.BackgroundTransparency = 0.02
										TextLabel4.BorderSizePixel = 0
										TextLabel4.ZIndex = 103
										TextLabel4.Font = v103.Font.Code
										TextLabel4.TextSize = 11
										TextLabel4.TextColor3 = tbl26.TEXT
										TextLabel4.TextXAlignment = v103.TextXAlignment.Center
										TextLabel4.TextTruncate = v103.TextTruncate.AtEnd
										fn38(TextLabel4, v85[162])
										fn39(TextLabel4, tbl26.AQUA_STROKE, 1, 0.52)
										local hideJobId = tbl19.hideJobId

										local function fn48()
											local jobId = v87.JobId

											if jobId == "" then
												jobId = "(no job id)"
											end

											TextLabel4.Text = hideJobId and v90.rep("•", v89.min(#jobId, 36)) or jobId
										end

										fn48()

										local function fn49(text, arg, arg2)
											local v108 = v102.new(v85[68], Frame4)
											v108.AutoButtonColor = v85[112]
											v108.Size = v101.new(arg2, -7, 0, 20)
											v108.Position = v101.new(arg, v85[23], v85[117], 30)
											v108.BackgroundColor3 = tbl26.SURF2
											v108.BorderSizePixel = 0
											v108.Text = text
											v108.ZIndex = 103
											v108.Font = v103.Font.GothamBold
											v108.TextSize = 11
											v108.TextColor3 = tbl26.TEXT
											fn38(v108, 11)
											local v109 = fn39(v108, tbl26.AQUA_STROKE, 1, 0.52)

											v108.MouseEnter:Connect(function()
												fn40(v108, v85[144], { BackgroundColor3 = v100.fromRGB(v85[5], 20, 20) })
												fn40(v109, 0.14, { Transparency = 0.38 })
											end)

											v108.MouseLeave:Connect(function()
												fn40(v108, v85[144], { BackgroundColor3 = tbl26.SURF2 })
												fn40(v109, 0.14, { Transparency = 0.52 })
											end)

											return v108, v109
										end

										local copy, v108 = fn49("COPY", v85[117], 0.5)
										local v109 = fn49(hideJobId and v85[100] or "HIDE", v85[65], v85[65])
										v109.Position = v101.new(0.5, 2, 0, 30)

										copy.MouseButton1Click:Connect(function()
											local jobId = v87.JobId

											if jobId ~= "" and setclipboard then
												v94(function()
													setclipboard(jobId)
												end)

												copy.Text = "COPIED"
												fn40(copy, 0.14, { BackgroundColor3 = tbl26.GREEN2 })
												fn40(v108, v85[144], { Color = tbl26.GREEN_STROKE, Transparency = 0.2 })

												v88.delay(1.2, function()
													if copy.Parent then
														copy.Text = "COPY"
														fn40(copy, v85[144], { BackgroundColor3 = tbl26.SURF2 })
														fn40(v108, 0.14, { Color = tbl26.AQUA_STROKE, Transparency = 0.52 })
													end
												end)
											end
										end)

										v109.MouseButton1Click:Connect(function()
											hideJobId = not hideJobId
											v109.Text = hideJobId and "SHOW" or "HIDE"
											tbl19.hideJobId = hideJobId
											fn30()
											fn48()
										end)

										v87:GetPropertyChangedSignal("JobId"):Connect(fn48)
									end

									fn47()
								end

								do
									fn46 = function(arg, arg2)
										if arg2 then
											arg.button.BackgroundColor3 = tbl26.GREEN1
											arg.knob.BackgroundTransparency = 0
											arg.stateLabel.Text = "ON"
											arg.stateLabel.TextColor3 = v100.fromRGB(232, 255, 240)
											arg.stroke.Color = tbl26.GREEN_STROKE
											arg.stroke.Transparency = 0.22
											arg.rowStroke.Transparency = 0.38
										else
											arg.button.BackgroundColor3 = tbl26.OFF_BG
											arg.knob.BackgroundTransparency = 1
											arg.stateLabel.Text = v85[181]
											arg.stateLabel.TextColor3 = tbl26.OFF_TEXT
											arg.stroke.Color = tbl26.AQUA_STROKE
											arg.stroke.Transparency = v85[152]
											arg.rowStroke.Transparency = 0.52
										end
									end

									fn46(nearest, stealNearest)
									fn46(highest, stealHighest)
									fn46(autoKick2, autoKick)
									fn46(instantSteal2, instantSteal)

									nearest.button.MouseButton1Click:Connect(function()
										stealNearest = not stealNearest

										if stealNearest then
											stealHighest = false
											fn46(highest, false)
										end

										fn34()
										_G.NEAREST_INSTANT_MODE = stealNearest and instantSteal
										fn46(nearest, stealNearest)
										tbl19.stealNearest = stealNearest
										tbl19.stealHighest = stealHighest
										fn30()
									end)

									highest.button.MouseButton1Click:Connect(function()
										stealHighest = not stealHighest

										if stealHighest then
											stealNearest = false
											fn46(nearest, false)
										end

										fn34()
										fn46(highest, stealHighest)
										tbl19.stealHighest = stealHighest
										tbl19.stealNearest = stealNearest
										fn30()
									end)

									autoKick2.button.MouseButton1Click:Connect(function()
										autoKick = not autoKick
										fn46(autoKick2, autoKick)
										tbl19.autoKick = autoKick
										fn30()
									end)

									instantSteal2.button.MouseButton1Click:Connect(function()
										instantSteal = not instantSteal
										flag20 = false
										flag21 = v85[112]
										_G.NEAREST_INSTANT_MODE = stealNearest and instantSteal
										fn46(instantSteal2, instantSteal)
										tbl19.instantSteal = instantSteal
										fn30()
									end)

									do
										local function fn47()
											local infiniteJump2 = tbl19.infiniteJump
											local connection = nil
											local connection2 = nil
											local connection3 = nil
											local connection4 = nil
											local flag23 = false
											local n33 = 0

											local function fn48()
												local playerGui = localPlayer:FindFirstChild("PlayerGui")
												playerGui = playerGui and playerGui:FindFirstChild("TouchGui")
												local jumpButton = playerGui and playerGui:FindFirstChild(v85[58])
												jumpButton = jumpButton and jumpButton:FindFirstChild("JumpButton")
												if not jumpButton then
													return
												end

												if connection2 then
													connection2:Disconnect()
												end

												if connection3 then
													connection3:Disconnect()
												end

												connection2 = jumpButton.InputBegan:Connect(function(input)
													if n27(4164) >= 18028 then
														if input.UserInputType == v103.UserInputType.Touch then
															flag23 = true
														end

														return
													end

													while true do
													end
												end)

												connection3 = jumpButton.InputEnded:Connect(function(input)
													if input.UserInputType == v103.UserInputType.Touch then
														flag23 = false
													end
												end)
											end

											local function fn49(arg)
												infiniteJump2 = arg

												if connection then
													connection:Disconnect()
													connection = nil
												end

												if connection2 then
													connection2:Disconnect()
													connection2 = nil
												end

												if connection3 then
													connection3:Disconnect()
													connection3 = nil
												end

												if connection4 then
													connection4:Disconnect()
													connection4 = nil
												end

												flag23 = v85[112]
												if not arg then
													return
												end

												v88.spawn(function()
													for i = 1, v85[36] do
														local playerGui = localPlayer:FindFirstChild("PlayerGui")
														playerGui = playerGui and playerGui:FindFirstChild("TouchGui")

														if playerGui and playerGui:FindFirstChild("TouchControlFrame") and playerGui.TouchControlFrame:FindFirstChild("JumpButton") then
															fn48()
															break
														else
															v88.wait(0.5)
														end
													end
												end)

												connection4 = localPlayer.CharacterAdded:Connect(function()
													flag23 = false
													v88.delay(v85[48], fn48)
												end)

												connection = service2.Heartbeat:Connect(function(...) end)
											end

											fn46(infiniteJump, infiniteJump2)

											if infiniteJump2 then
												fn49(true)
											end

											infiniteJump.button.MouseButton1Click:Connect(function()
												fn49(not infiniteJump2)
												fn46(infiniteJump, infiniteJump2)
												tbl19.infiniteJump = infiniteJump2
												fn30()
											end)

											local tbl29 = {}
											local flag24 = false
											local n34 = nil
											local v106 = nil

											local function fn50()
												flag24 = v85[112]

												for _, v107 in v92(tbl29) do
													if typeof(v107) == "RBXScriptConnection" then
														v107:Disconnect()
													end
												end

												tbl29 = {}
											end

											local function fn51()
												if flag24 then
													return
												end
												flag24 = true
												local character = localPlayer.Character
												if not character then
													flag24 = false
													return
												end
												local v107 = character:FindFirstChild(v85[171])

												if not v107 then
													for _, child in v92(v86.CurrentCamera:GetChildren()) do
														if child.Name == "HumanoidRootPart" then
															v107 = child
															break
														end
													end
												end

												if not v107 then
													flag24 = false
													return
												end
												n34 = v107.CFrame - v107.CFrame.Position
												v106 = v107
												tbl29[#tbl29 + v85[48]] = service2.Stepped:Connect(function(...) end)
												tbl29[#tbl29 + v85[48]] = service2.Stepped:Connect(function(...) end)

												local thread = coroutine.create(function()
													if _G.invisibleStealEnabled then
														v107.CFrame = v107.CFrame * v99.new(0, 3, 0)
													end

													while flag24 do
														service2.Heartbeat:Wait()

														if not (not v107 or not v107.Parent) then
															local velocity = v107.Velocity
															v107.Velocity = velocity * v85[105] + v98.new(0, 10000, 0)
															service2.RenderStepped:Wait()

															if v107 and v107.Parent then
																v107.Velocity = velocity
															end

															service2.Stepped:Wait()

															if v107 and v107.Parent then
																v107.Velocity = velocity + v98.new(0, v85[114], v85[117])
															end

															continue
														end

														break
													end
												end)

												coroutine.resume(thread)
												tbl29[#tbl29 + 1] = thread
											end

											local function dropBrainrot()
												if flag24 then
													return
												end
												fn51()

												v88.delay(0.4, function()
													fn50()
													v88.wait(0.05)

													if v106 and v106.Parent and n34 then
														v94(function()
															v106.CFrame = v99.new(v106.Position) * n34
															v106.RotVelocity = v98.zero
														end)
													end
												end)
											end

											_G.dropBrainrot = dropBrainrot

											tbl27.button.MouseButton1Click:Connect(function()
												dropBrainrot()
												tbl27.button.Text = v85[163]

												v88.delay(v85[170], function()
													if tbl27.button.Parent then
														tbl27.button.Text = v85[101]
													end
												end)
											end)
										end

										fn47()
									end
								end

								do
									local function fn47()
										local v106 = v85[24]

										if n26(1843) <= v106 then
											local v107 = v86
											local service4 = v87:GetService(v85[177])
											local float = tbl19.float
											local v108 = nil
											local connection = nil

											local function fn48()
												if connection then
													connection:Disconnect()
													connection = nil
												end

												if v108 then
													v94(function()
														v108:Destroy()
													end)

													v108 = nil
												end
											end

											local function fn49()
												fn48()
												local character = localPlayer.Character
												local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
												character = character and character:FindFirstChildOfClass("Humanoid")
												if not humanoidRootPart or not character then
													return
												end
												local Part = v102.new("Part")
												Part.Name = "Part"
												Part.Size = v98.new(7, 1, 7)
												Part.Anchored = true
												Part.CanCollide = v85[8]
												Part.CanTouch = false
												Part.CanQuery = v85[112]
												Part.Transparency = v85[48]
												Part.CastShadow = false
												Part.Locked = true
												Part.Massless = true
												Part.Material = v103.Material.SmoothPlastic
												Part.CFrame = v99.new(humanoidRootPart.Position - v98.new(0, 3.35, 0))
												Part.Parent = v107
												v108 = Part
												connection = service2.Heartbeat:Connect(function(...) end)
											end

											local function fn50(arg, arg2)
												if not arg then
													return
												end

												if arg.setActive then
													arg.setActive(arg2)
												else
													fn46(arg, arg2)
												end
											end

											local function setFloat(arg)
												float = arg

												if arg then
													fn49()
												else
													fn48()
												end

												fn50(floatRef, float)
												tbl19.float = float
												fn30()
											end

											_G.setFloat = setFloat

											_G.toggleFloat = function()
												setFloat(not float)
											end

											fn50(floatRef, float)

											if float then
												v88.spawn(function()
													v88.wait(v85[48])
													fn49()
												end)
											end

											if flag18 and floatRef then
												floatRef.button.MouseButton1Click:Connect(function()
													setFloat(not float)
												end)
											end

											localPlayer.CharacterAdded:Connect(function()
												if float then
													v88.delay(v85[65], fn49)
												end
											end)

											localPlayer:GetAttributeChangedSignal(v85[165]):Connect(function()
												if float and localPlayer:GetAttribute(v85[165]) then
													setFloat(v85[112])
												end
											end)

											local function instantClone()
												local character = localPlayer.Character
												local humanoid = character and character:FindFirstChildOfClass("Humanoid")
												if not humanoid then
													return
												end
												local v109 = localPlayer:FindFirstChild(v85[13])
												local quantumCloner = v109 and v109:FindFirstChild("Quantum Cloner") or character:FindFirstChild("Quantum Cloner")
												if not quantumCloner then
													return
												end

												if quantumCloner.Parent ~= character then
													v94(function()
														humanoid:EquipTool(quantumCloner)
													end)

													v88.wait()
												end

												local playerGui = localPlayer:FindFirstChild("PlayerGui")
												playerGui = playerGui and playerGui:FindFirstChild("ToolsFrames")
												playerGui = playerGui and playerGui:FindFirstChild("QuantumCloner")
												playerGui = playerGui and playerGui:FindFirstChild("TeleportToClone")
												if not playerGui then
													return
												end

												v94(function()
													quantumCloner:Activate()
												end)

												v88.wait(0.05)
												playerGui.Visible = true

												if typeof(firesignal) == "function" then
													v94(function()
														firesignal(playerGui.MouseButton1Click)
													end)

													v94(function()
														firesignal(playerGui.MouseButton1Up)
													end)

													v94(function()
														firesignal(playerGui.Activated)
													end)
												end
											end

											_G.instantClone = instantClone

											if _G.AntiDieDisabled == nil then
												_G.AntiDieDisabled = false
											end

											local flag23 = v85[112]

											v94(function()
												service.RespawnTime = v85[117]
											end)

											local function instantReset()
												if flag23 then
													return
												end
												local v109 = localPlayer
												if not v109 then
													return
												end
												local character = v109.Character
												local v110 = character and character:FindFirstChildOfClass(v85[7])
												if not v110 then
													return
												end
												flag23 = v85[8]
												_G.mynxxResetAt = os.clock()
												local antiDieDisabled = _G.AntiDieDisabled
												_G.AntiDieDisabled = true

												v94(function()
													v110.BreakJointsOnDeath = true
												end)

												v94(function()
													v110:SetStateEnabled(v103.HumanoidStateType.Dead, true)
												end)

												v94(function()
													v110.Health = v85[117]
												end)

												v88.spawn(function()
													local flag24 = false
													local connection2 = nil

													connection2 = v109.CharacterAdded:Connect(function()
														flag24 = true

														if connection2 then
															connection2:Disconnect()
															connection2 = nil
														end
													end)

													local now2 = os.clock()

													while not flag24 and os.clock() - now2 < 5 do
														v88.wait(0.05)
													end

													if connection2 then
														connection2:Disconnect()
														connection2 = nil
													end

													_G.AntiDieDisabled = antiDieDisabled
													flag23 = false
												end)
											end

											_G.InstantReset = instantReset
											_G.mynxxInstaReset = instantReset

											local function flingUp()
												local v109 = service2
												local character = localPlayer.Character
												local humanoid = character and character:FindFirstChildOfClass("Humanoid")
												local primaryPart

												if character then
													primaryPart = character.PrimaryPart or character:FindFirstChild("HumanoidRootPart")
												else
													primaryPart = character
												end

												if not primaryPart or not humanoid or humanoid.Health <= 0 then
													return
												end
												_G.FlingActive = true

												v94(function()
													humanoid.Sit = false
													humanoid.PlatformStand = v85[8]

													if primaryPart.Anchored then
														primaryPart.Anchored = false
													end
												end)

												local v110 = v98.new(0, v85[187], v85[117])
												local now2 = os.clock()

												while os.clock() - now2 < 0.15 do
													local character2 = localPlayer.Character
													humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")

													if character2 then
														primaryPart = character2.PrimaryPart or character2:FindFirstChild(v85[171])
													else
														primaryPart = character2
													end

													if not (not primaryPart or not humanoid or humanoid.Health <= 0) then
														if primaryPart.Anchored then
															primaryPart.Anchored = false
														end

														primaryPart.AssemblyLinearVelocity = v110
														primaryPart.Velocity = v110
														v109.Heartbeat:Wait()
														continue
													end

													break
												end

												v94(function()
													if humanoid and humanoid.Parent then
														humanoid.PlatformStand = false
														humanoid:ChangeState(v103.HumanoidStateType.GettingUp)
													end
												end)

												_G.FlingActive = false
											end

											_G.FlingUp = flingUp
											local v109 = v102.new(v85[22])

											v109.Event:Connect(function()
												v94(instantReset)
											end)

											v88.spawn(function()
												for i = 1, 12 do
													if not v94(function()
														v87:GetService("StarterGui"):SetCore("ResetButtonCallback", v109)
													end) then
														v88.wait(v85[48])
														continue
													end

													break
												end
											end)

											local n33 = 0

											local function executeReset(arg)
												if arg then
													if tick() - n33 < 20 then
														return
													end
													n33 = tick()
												end

												v88.spawn(flingUp)
											end

											_G.executeReset = executeReset
											local autoResetBalloon = tbl19.autoResetBalloon
											fn46(balloon, autoResetBalloon)

											balloon.button.MouseButton1Click:Connect(function()
												autoResetBalloon = not autoResetBalloon
												fn46(balloon, autoResetBalloon)
												tbl19.autoResetBalloon = autoResetBalloon
												fn30()
											end)

											local obj = setmetatable({}, { __mode = "k" })

											local function fn51(arg)
												if autoResetBalloon and v95(arg) == "string" and v90.find(arg, "ran \"balloon\" on you", 1, true) then
													executeReset(true)
												end
											end

											local function fn52(arg)
												if obj[arg] then
													return
												end
												obj[arg] = true
												fn51(arg.Text)

												arg:GetPropertyChangedSignal("Text"):Connect(function()
													fn51(arg.Text)
												end)
											end

											local function fn53(arg)
												return arg:IsA("TextLabel") or arg:IsA("TextButton")
											end

											local function fn54(arg)
												for _, descendant in v92(arg:GetDescendants()) do
													if fn53(descendant) then
														fn52(descendant)
													end
												end

												arg.DescendantAdded:Connect(function(descendant)
													if n24 > v85[161] then
														while v85[8] do
														end
													end

													if fn53(descendant) then
														fn52(descendant)
													end
												end)
											end

											for _, child in v92(v104:GetChildren()) do
												v94(fn54, child)
											end

											v104.ChildAdded:Connect(function(child)
												v94(fn54, child)
											end)

											tbl28.button.MouseButton1Click:Connect(function()
												v88.spawn(flingUp)
												tbl28.button.Text = "RESETTING"

												v88.delay(v85[48], function()
													if tbl28.button.Parent then
														tbl28.button.Text = v85[31]
													end
												end)
											end)

											local antiDie2 = tbl19.antiDie
											local connection2 = nil
											local connection3 = nil
											local connection4 = nil

											local function fn55(arg)
												v94(function()
													arg.BreakJointsOnDeath = false
												end)

												v94(function()
													arg.RequiresNeck = false
												end)

												v94(function()
													arg:SetStateEnabled(v103.HumanoidStateType.Dead, false)
												end)

												v94(function()
													arg:SetStateEnabled(v103.HumanoidStateType.Ragdoll, false)
												end)

												v94(function()
													arg:SetStateEnabled(v103.HumanoidStateType.FallingDown, false)
												end)

												v94(function()
													arg:SetStateEnabled(v103.HumanoidStateType.Physics, false)
												end)
											end

											local function fn56(arg)
												v94(function()
													arg.BreakJointsOnDeath = v85[8]
												end)

												v94(function()
													arg.RequiresNeck = true
												end)

												v94(function()
													arg:SetStateEnabled(v103.HumanoidStateType.Dead, true)
												end)

												v94(function()
													arg:SetStateEnabled(v103.HumanoidStateType.Ragdoll, v85[8])
												end)

												v94(function()
													arg:SetStateEnabled(v103.HumanoidStateType.FallingDown, true)
												end)

												v94(function()
													arg:SetStateEnabled(v103.HumanoidStateType.Physics, v85[8])
												end)
											end

											local function fn57(arg)
												v94(function()
													arg.Health = arg.MaxHealth
												end)

												v94(function()
													arg:ChangeState(v103.HumanoidStateType.Running)
												end)
											end

											local function fn58()
												if connection2 then
													v94(function()
														connection2:Disconnect()
													end)

													connection2 = nil
												end

												if connection3 then
													v94(function()
														connection3:Disconnect()
													end)

													connection3 = nil
												end

												if connection4 then
													v94(function()
														connection4:Disconnect()
													end)

													connection4 = nil
												end
											end

											local function fn59()
												fn58()
												if not antiDie2 then
													return
												end
												local character = localPlayer.Character
												local humanoid = character and character:FindFirstChildOfClass("Humanoid")
												if not humanoid then
													return
												end
												fn55(humanoid)

												connection2 = humanoid:GetPropertyChangedSignal(v85[42]):Connect(function()
													if _G.AntiDieDisabled then
														return
													end

													if humanoid.Health <= 0 then
														fn57(humanoid)
													end
												end)

												connection3 = humanoid.Died:Connect(function()
													if _G.AntiDieDisabled then
														return
													end
													fn57(humanoid)
												end)

												connection4 = service2.Heartbeat:Connect(function(...) end)
											end

											local function setAntiDie(arg)
												antiDie2 = arg
												fn46(antiDie, antiDie2)
												tbl19.antiDie = antiDie2
												fn30()

												if arg then
													fn59()
												else
													fn58()
													local character = localPlayer.Character
													character = character and character:FindFirstChildOfClass("Humanoid")

													if character then
														fn56(character)
													end
												end
											end

											_G.setAntiDie = setAntiDie
											fn46(antiDie, antiDie2)

											if antiDie2 then
												v88.spawn(function()
													v88.wait(1)
													fn59()
												end)
											end

											antiDie.button.MouseButton1Click:Connect(function()
												setAntiDie(not antiDie2)
											end)

											localPlayer.CharacterAdded:Connect(function(character)
												if not antiDie2 then
													return
												end
												local humanoid = character:WaitForChild("Humanoid", v85[23])

												if humanoid then
													fn55(humanoid)
												end

												v88.wait(v85[114])
												fn59()
											end)

											local v110 = localPlayer
											local tbl29 = {}
											local v111 = nil
											local v112 = nil
											local v113 = nil
											local animator = nil
											local v114 = v98.new(0, 0, 0)

											local function fn60()
												if not v111 then
													return false
												end

												if not v111:FindFirstChildWhichIsA("Tool") then
													return false
												end
												local humanoidRootPart = v111:FindFirstChild("HumanoidRootPart")

												if n24 < 7680 then
													while v85[8] do
													end
												end

												if humanoidRootPart then
													for _, child in v92(humanoidRootPart:GetChildren()) do
														if child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyGyro") then
															return true
														end
													end
												end

												return v85[112]
											end

											local function fn61()
												if not v112 then
													return false
												end
												local state = v112:GetState()
												return state == v103.HumanoidStateType.Physics or state == v103.HumanoidStateType.Ragdoll or state == v103.HumanoidStateType.FallingDown or state == v103.HumanoidStateType.GettingUp
											end

											local function fn62()
												v94(function()
													local playerModule = v110:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10)
													require(playerModule):GetControls():Enable()
												end)
											end

											local function fn63()
												if not v111 then
													return
												end
												local v115 = fn60()

												local function fn64(arg)
													for _, child in v92(arg:GetChildren()) do
														if child:IsA(v85[1]) or child:IsA("NoCollisionConstraint") or child:IsA(v85[88]) or child:IsA("Attachment") and (child.Name == v85[43] or child.Name == "B") then
															child:Destroy()
														elseif child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyGyro") then
															if not v115 then
																child:Destroy()
															end
														elseif child:IsA("Motor6D") then
															child.Enabled = v85[8]
														elseif child:IsA("BasePart") then
															for _, child2 in v92(child:GetChildren()) do
																if child2:IsA("BallSocketConstraint") or child2:IsA("NoCollisionConstraint") or child2:IsA(v85[88]) or child2:IsA("Motor6D") then
																	if child2:IsA("Motor6D") then
																		child2.Enabled = true
																	else
																		child2:Destroy()
																	end
																elseif child2:IsA("Attachment") and (child2.Name == "A" or child2.Name == "B") then
																	child2:Destroy()
																end
															end
														end
													end
												end

												v94(function()
													fn64(v111)
												end)

												if animator then
													for _, v116 in v93(animator:GetPlayingAnimationTracks()) do
														local str9 = v116.Animation and v116.Animation.Name:lower() or ""

														if str9:find(v85[27]) or str9:find("fall") or str9:find(v85[131]) or str9:find("down") then
															v116:Stop(0)
														end
													end
												end
											end

											local function fn64(arg)
												v111 = arg
												v112 = arg:WaitForChild(v85[7], 10)
												v113 = arg:WaitForChild(v85[171], v85[36])
												animator = v112 and v112:WaitForChild("Animator", v85[36])
												v114 = v98.new(0, 0, v85[117])
											end

											local function fn65()
												for _, v115 in v93(tbl29) do
													v94(function()
														v115:Disconnect()
													end)
												end

												tbl29 = {}
											end

											local function fn66()
												fn65()
												if not v112 or not v113 then
													return
												end

												v91.insert(tbl29, v112.StateChanged:Connect(function()
													if _G.AntiRagdollEnabled and fn61() then
														if not fn60() then
															v112:ChangeState(v103.HumanoidStateType.Running)
														end

														fn63()

														v94(function()
															v86.CurrentCamera.CameraSubject = v112
														end)

														fn62()
													end

													if not flag2 then
														return
													end
												end))

												if not (n24 > 7700) then
													v94(function()
														local reCombatServiceApplyImpulse = service3:FindFirstChild(v85[169])
														reCombatServiceApplyImpulse = reCombatServiceApplyImpulse and reCombatServiceApplyImpulse:FindFirstChild(v85[20])
														reCombatServiceApplyImpulse = reCombatServiceApplyImpulse and reCombatServiceApplyImpulse:FindFirstChild("RE/CombatService/ApplyImpulse")

														if reCombatServiceApplyImpulse then
															v91.insert(tbl29, reCombatServiceApplyImpulse.OnClientEvent:Connect(function()
																if _G.AntiRagdollEnabled and fn61() then
																	v113.AssemblyLinearVelocity = v98.new(0, 0, v85[117])
																end
															end))
														end
													end)

													v91.insert(tbl29, v111.DescendantAdded:Connect(function()
														if _G.AntiRagdollEnabled and fn61() then
															fn63()
														end
													end))

													v91.insert(tbl29, service2.Heartbeat:Connect(function(...) end))
													fn62()
													fn63()
													return
												end

												while true do
												end
											end

											local function fn67()
												_G.AntiRagdollEnabled = true

												if v110.Character then
													fn64(v110.Character)
													fn66()
												end
											end

											local function fn68()
												_G.AntiRagdollEnabled = false
												fn65()
											end

											local antiRagdoll = tbl19.antiRagdoll

											local function toggleAntiRagdoll(arg)
												antiRagdoll = arg
												fn46(antiRag, antiRagdoll)
												tbl19.antiRagdoll = antiRagdoll
												fn30()

												if arg then
													fn67()
												else
													fn68()
												end
											end

											_G.toggleAntiRagdoll = toggleAntiRagdoll
											fn46(antiRag, antiRagdoll)

											if antiRagdoll then
												v88.spawn(function()
													v88.wait(1)
													fn67()
												end)
											end

											antiRag.button.MouseButton1Click:Connect(function()
												toggleAntiRagdoll(not antiRagdoll)
											end)

											v110.CharacterAdded:Connect(function(character)
												fn65()
												v111 = nil
												v112 = nil
												v113 = nil
												animator = nil
												local humanoid = character:WaitForChild("Humanoid", v85[36])
												local humanoidRootPart = character:WaitForChild("HumanoidRootPart", v85[36])
												if not humanoid or not humanoidRootPart then
													return
												end
												v88.wait(v85[137])
												fn64(character)

												if antiRagdoll then
													fn66()
												end
											end)

											local autoTurret = tbl19.autoTurret

											local function setAutoTurret(arg)
												autoTurret = arg
												fn46(turret, autoTurret)
												tbl19.autoTurret = autoTurret
												fn30()
											end

											_G.setAutoTurret = setAutoTurret
											fn46(turret, autoTurret)

											turret.button.MouseButton1Click:Connect(function()
												setAutoTurret(not autoTurret)
											end)

											v88.spawn(function()
												local function fn69()
													local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
													return character, character:WaitForChild("HumanoidRootPart"), (character:WaitForChild(v85[7]))
												end

												local function fn70(arg)
													for _, descendant in v92(arg:GetDescendants()) do
														if descendant:IsA("BillboardGui") then
															local textLabel = descendant:FindFirstChildWhichIsA("TextLabel", true)
															if textLabel and textLabel.Text:find("!") then
																return true
															end
														end
													end

													return false
												end

												local function fn71(arg)
													for _, descendant in v92(arg:GetDescendants()) do
														if descendant:IsA("BasePart") and descendant ~= arg then
															descendant.Transparency = 0.5
															descendant.CanCollide = false
															descendant.CanTouch = false
															descendant.CanQuery = false
														elseif descendant:IsA("BillboardGui") and descendant.Name ~= "SentryLabel" then
															descendant:Destroy()
														elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
															descendant.Transparency = 0.5
														end
													end

													if arg:IsA(v85[9]) and arg.Name ~= "ProxyVisual" then
														arg.Transparency = v85[48]
														arg.CanCollide = false
													end
												end

												local function fn72()
													local v115, v116 = fn69()
													local huge = v89.huge
													local v117 = nil

													for _, descendant in v92(v86:GetDescendants()) do
														if descendant.Name:match("^Sentry_") then
															if fn70(descendant) then
																local isBasePart = descendant:IsA("BasePart") and descendant or descendant:FindFirstChildWhichIsA("BasePart", true)

																if isBasePart then
																	local magnitude = (v116.Position - isBasePart.Position).Magnitude

																	if magnitude < huge then
																		huge = magnitude
																		v117 = descendant
																	end
																end
															end
														end
													end

													return v117
												end

												while true do
													if autoTurret then
														if localPlayer:GetAttribute(v85[165]) == true then
															v88.wait(v85[65])
														else
															local v115 = fn72()

															if v115 then
																while true do
																	local v116 = autoTurret
																	local parent

																	if autoTurret then
																		parent = v115
																	else
																		parent = v116
																	end

																	parent = parent and v115.Parent

																	if parent and localPlayer:GetAttribute(v85[165]) ~= true then
																		local v117, v118, v119 = fn69()
																		local bat = localPlayer.Backpack:FindFirstChild("Bat") or v117:FindFirstChild("Bat")
																		fn71(v115)
																		local v120 = v99.new(v118.Position + v118.CFrame.LookVector * v85[132], v118.Position)

																		if v115:IsA(v85[11]) then
																			v115:PivotTo(v120)
																		elseif v115:IsA(v85[9]) then
																			v115.CFrame = v120
																		end

																		if bat then
																			if bat.Parent ~= v117 then
																				v119:EquipTool(bat)
																			end

																			bat:Activate()
																		end

																		v88.wait(0.1)
																		if not fn70(v115) then
																			break
																		end
																		continue
																	end

																	break
																end
															end
														end
													end

													v88.wait(0.1)
												end
											end)

											local carpetSpeed = tbl19.carpetSpeed
											local connection5 = nil
											local tbl30 = { v85[98], "Cupid's Wings", "Santa's Sleigh", "Witch's Broom", "Wave Rider", "Waverider" }

											local function fn69(arg)
												if not arg then
													return nil
												end

												for _, v115 in v92(tbl30) do
													local v116 = arg:FindFirstChild(v115)
													if v116 and v116:IsA("Tool") then
														return v116
													end
												end

												return nil
											end

											local function setCarpetSpeed(arg)
												carpetSpeed = arg

												if connection5 then
													connection5:Disconnect()
													connection5 = nil
												end

												fn50(carpetRef, carpetSpeed)
												tbl19.carpetSpeed = carpetSpeed
												fn30()
												if not arg then
													return
												end
												connection5 = service2.Heartbeat:Connect(function(...) end)
											end

											_G.setCarpetSpeed = setCarpetSpeed
											fn50(carpetRef, carpetSpeed)

											if carpetSpeed then
												v88.spawn(function()
													v88.wait(1)
													setCarpetSpeed(true)
												end)
											end

											if flag18 and carpetRef then
												carpetRef.button.MouseButton1Click:Connect(function()
													setCarpetSpeed(not carpetSpeed)
													if not flag2 then
														return
													end
												end)
											end

											UserInputService.InputBegan:Connect(function(input, gameProcessed)
												if gameProcessed or input.UserInputType ~= v103.UserInputType.Keyboard then
													return
												end
												local name = input.KeyCode.Name

												if name == tbl20.clone then
													v88.spawn(instantClone)
												elseif name == tbl20.float then
													setFloat(not float)
												elseif name == tbl20.carpet then
													setCarpetSpeed(not carpetSpeed)
												elseif name == tbl20.drop then
													if _G.dropBrainrot then
														v88.spawn(_G.dropBrainrot)
													end
												elseif name == tbl20.reset then
													v88.spawn(flingUp)
												end
											end)

											local lineToBase = tbl19.lineToBase
											local Beam = nil
											local v115 = nil
											local Attachment = nil

											local function fn70()
												local v116 = v107:FindFirstChild(v85[84])
												if not v116 then
													return nil
												end

												for _, child in v92(v116:GetChildren()) do
													local plotSign = child:FindFirstChild("PlotSign")
													plotSign = plotSign and plotSign:FindFirstChildWhichIsA(v85[185], v85[8])
													plotSign = plotSign and plotSign:FindFirstChildWhichIsA("TextLabel", true)

													if plotSign then
														local str9 = plotSign.Text:lower()
														if str9:find(localPlayer.DisplayName:lower(), 1, true) or str9:find(localPlayer.Name:lower(), v85[48], true) then
															return child
														end
													end
												end

												return nil
											end

											local function fn71()
												if Beam then
													v94(function()
														Beam:Destroy()
													end)
												end

												if v115 then
													v94(function()
														v115:Destroy()
													end)
												end

												if Attachment then
													v94(function()
														Attachment:Destroy()
													end)
												end

												Beam = nil
												v115 = nil
												Attachment = nil
											end

											local function fn72()
												if not lineToBase then
													return
												end
												local v116 = fn70()
												if not v116 then
													return
												end
												local character = localPlayer.Character
												character = character and character:FindFirstChild("HumanoidRootPart")
												if not character then
													return
												end
												fn71()
												local mainRoot = v116:FindFirstChild("MainRoot") or v116:FindFirstChildWhichIsA("BasePart")
												if not mainRoot then
													return
												end
												v115 = v102.new(v85[160])
												v115.Parent = character
												Attachment = v102.new("Attachment")
												Attachment.Position = v98.new(0, 5, 0)
												Attachment.Parent = mainRoot
												Beam = v102.new("Beam")
												Beam.Attachment0 = v115
												Beam.Attachment1 = Attachment
												Beam.FaceCamera = true
												Beam.LightEmission = 0.5
												Beam.Color = ColorSequence.new(v100.fromRGB(255, 255, v85[63]))
												Beam.Transparency = NumberSequence.new(0)
												Beam.Width0 = v85[107]
												Beam.Width1 = 0.7
												Beam.TextureMode = v103.TextureMode.Wrap
												Beam.TextureSpeed = 0
												Beam.Parent = character
											end

											local lineToBase2 = fn44(v, "Line to Base", 6)
											fn46(lineToBase2, lineToBase)

											if lineToBase then
												v88.spawn(function()
													v88.wait(v85[48])
													fn72()
												end)
											end

											lineToBase2.button.MouseButton1Click:Connect(function()
												lineToBase = not lineToBase
												fn46(lineToBase2, lineToBase)

												if lineToBase then
													fn72()
												else
													fn71()
												end

												tbl19.lineToBase = lineToBase
												fn30()
											end)

											localPlayer.CharacterAdded:Connect(function()
												if lineToBase then
													v88.delay(0.5, fn72)
												end
											end)

											service2.Heartbeat:Connect(function(...) end)
											local fpsBoost = tbl19.fpsBoost
											local connection6 = nil

											local function fn73(arg)
												return service:GetPlayerFromCharacter(arg) ~= nil
											end

											local function fn74(arg, arg2)
												local model = arg:FindFirstAncestorOfClass("Model")
												local v116 = model and fn73(model)

												if arg:IsA("Animator") and not v116 then
													for _, v117 in v93(arg:GetPlayingAnimationTracks()) do
														v117:Stop(v85[117])
													end

													arg.AnimationPlayed:Connect(function(arg3)
														arg3:Stop(0)
													end)
												end

												if (arg:IsA("Accessory") or arg:IsA(v85[126])) and model then
													arg:Destroy()
													return
												end

												if not v116 then
													if arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Beam") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") or arg:IsA("Highlight") then
														arg.Enabled = false
													end

													if arg:IsA(v85[45]) then
														arg:Destroy()
														return
													end

													if arg:IsA(v85[141]) then
														arg.TextureID = ""
													end

													if arg2 and (arg:IsA(v85[75]) or arg:IsA("SpotLight") or arg:IsA("SurfaceLight")) and arg.Parent ~= service4 then
														v94(function()
															arg:Destroy()
														end)

														return
													end
												end

												if arg:IsA("BasePart") then
													arg.Material = v103.Material.Plastic
													arg.Reflectance = 0
													arg.CastShadow = false
												end

												if arg:IsA("SurfaceAppearance") or arg:IsA(v85[17]) or arg:IsA(v85[3]) then
													arg:Destroy()
												end
											end

											local function fn75(arg)
												fpsBoost = arg

												if connection6 then
													connection6:Disconnect()
													connection6 = nil
												end

												if not arg then
													return
												end
												service4.GlobalShadows = false
												service4.FogEnd = 1000000
												service4.FogStart = 0
												service4.EnvironmentDiffuseScale = v85[117]
												service4.EnvironmentSpecularScale = 0.1

												for _, child in v93(service4:GetChildren()) do
													if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("SunRaysEffect") or child:IsA(v85[46]) or child:IsA(v85[61]) then
														child:Destroy()
													end
												end

												v88.spawn(function()
													local descendants = v107:GetDescendants()

													for i = 1, #descendants do
														v94(fn74, descendants[i], true)

														if i % v85[115] == 0 then
															v88.wait()
														end
													end
												end)

												connection6 = v107.DescendantAdded:Connect(function(descendant)
													if not fpsBoost then
														return
													end

													v88.defer(function()
														v94(fn74, descendant, false)
													end)
												end)
											end

											local fpsBoost2 = fn44(v, "FPS Boost", 7)
											fn46(fpsBoost2, fpsBoost)

											if fpsBoost then
												v88.spawn(function()
													v88.wait(1)
													fn75(true)
												end)
											end

											fpsBoost2.button.MouseButton1Click:Connect(function()
												fn75(not fpsBoost)
												fn46(fpsBoost2, fpsBoost)
												tbl19.fpsBoost = fpsBoost
												fn30()
											end)

											local Frame3 = v102.new("Frame", v)
											Frame3.Size = v101.new(1, 0, v85[117], v85[34])
											Frame3.BackgroundColor3 = tbl26.SURF2
											Frame3.BackgroundTransparency = 0.02
											Frame3.BorderSizePixel = v85[117]
											Frame3.LayoutOrder = v85[176]
											Frame3.ZIndex = 103
											fn38(Frame3, 11)
											local v116 = fn39(Frame3, tbl26.AQUA_STROKE, 1, v85[193])
											local TextLabel3 = v102.new("TextLabel", Frame3)
											TextLabel3.BackgroundTransparency = 1
											TextLabel3.Position = v101.fromOffset(12, 0)
											TextLabel3.Size = v101.fromOffset(40, v85[34])
											TextLabel3.Font = v103.Font.GothamBold
											TextLabel3.Text = v85[16]
											TextLabel3.TextColor3 = tbl26.TEXT
											TextLabel3.TextSize = 12
											TextLabel3.TextXAlignment = v103.TextXAlignment.Left
											TextLabel3.ZIndex = 104
											local v117 = v102.new(v85[66], Frame3)
											v117.BackgroundTransparency = 1
											v117.Position = v101.new(1, -46, 0, v85[117])
											v117.Size = v101.fromOffset(36, 36)
											v117.Font = v103.Font.GothamBold
											v117.Text = v96(n32)
											v117.TextColor3 = tbl26.TEXT
											v117.TextSize = v85[162]
											v117.TextXAlignment = v103.TextXAlignment.Right
											v117.ZIndex = 104
											local TextButton = v102.new("TextButton", Frame3)
											TextButton.AutoButtonColor = false
											TextButton.Text = ""
											TextButton.BackgroundTransparency = 1
											TextButton.Position = v101.fromOffset(52, v85[117])
											TextButton.Size = v101.new(v85[48], -104, 1, 0)
											TextButton.ZIndex = 104
											local Frame4 = v102.new("Frame", TextButton)
											Frame4.AnchorPoint = Vector2.new(v85[117], 0.5)
											Frame4.Position = v101.new(0, 0, v85[65], 0)
											Frame4.Size = v101.new(1, 0, 0, 5)
											Frame4.BackgroundColor3 = tbl26.OFF_BG
											Frame4.BorderSizePixel = 0
											Frame4.ZIndex = 104
											fn38(Frame4, 3)
											local Frame5 = v102.new("Frame", Frame4)
											Frame5.Size = v101.new(0, v85[117], v85[48], v85[117])
											Frame5.BackgroundColor3 = tbl26.AQUA
											Frame5.BorderSizePixel = 0
											Frame5.ZIndex = 105
											fn38(Frame5, v85[62])
											local Frame6 = v102.new("Frame", Frame4)
											Frame6.Size = v101.fromOffset(12, v85[142])
											Frame6.AnchorPoint = Vector2.new(v85[65], 0.5)
											Frame6.Position = v101.new(v85[117], 0, 0.5, 0)
											Frame6.BackgroundColor3 = tbl26.TEXT
											Frame6.BorderSizePixel = 0
											Frame6.ZIndex = v85[120]
											fn38(Frame6, 6)
											fn39(Frame6, tbl26.AQUA, 1.5, 0.2)

											Frame3.MouseEnter:Connect(function()
												fn40(Frame3, v85[144], { BackgroundColor3 = v100.fromRGB(58, 20, 20) })
												fn40(v116, 0.14, { Transparency = 0.38 })
											end)

											Frame3.MouseLeave:Connect(function()
												fn40(Frame3, 0.14, { BackgroundColor3 = tbl26.SURF2 })
												fn40(v116, 0.14, { Transparency = 0.52 })
											end)

											local function fn76(arg, arg2)
												local v118 = v89.clamp(v89.floor(arg + 0.5), 30, 180)
												n32 = v118
												v117.Text = v96(v118)
												local n34 = (v118 - 30) / 150
												Frame5.Size = v101.new(n34, 0, 1, 0)
												Frame6.Position = v101.new(n34, 0, v85[65], v85[117])

												if arg2 then
													fn30()
												end
											end

											fn76(n32, false)
											service2.RenderStepped:Connect(function(...) end)
											local flag24 = false

											local function fn77(arg)
												local v118 = v85[64]
												fn76(v85[115] + v89.clamp((arg - Frame4.AbsolutePosition.X) / v89.max(Frame4.AbsoluteSize.X, 1), 0, 1) * v118, false)
											end

											TextButton.InputBegan:Connect(function(input)
												if input.UserInputType == v103.UserInputType.MouseButton1 or input.UserInputType == v103.UserInputType.Touch then
													flag24 = v85[8]
													fn77(input.Position.X)
												end
											end)

											UserInputService.InputChanged:Connect(function(input)
												if flag24 and (input.UserInputType == v103.UserInputType.MouseMovement or input.UserInputType == v103.UserInputType.Touch) then
													fn77(input.Position.X)
												end
											end)

											UserInputService.InputEnded:Connect(function(input)
												if (input.UserInputType == v103.UserInputType.MouseButton1 or input.UserInputType == v103.UserInputType.Touch) and flag24 then
													flag24 = false
													fn30()
												end
											end)

											fn45(v, "Reset FOV", "RESET", v85[109]).button.MouseButton1Click:Connect(function()
												fn76(70, v85[8])
											end)

											return
										end

										while true do
										end
									end

									fn47()
								end
							end

							do
								local flag23, fn47

								do
									local fn48

									do
										v88.spawn(function()
											while v85[8] do
												v88.wait(1.5)

												if instantSteal then
													instantSteal = false
													flag20 = v85[112]
													flag21 = false
													_G.NEAREST_INSTANT_MODE = false
													v88.wait(0.05)
													instantSteal = true
													_G.NEAREST_INSTANT_MODE = stealNearest and v85[8]
												end
											end
										end)

										flag23 = true
										fn47 = nil

										fn47 = function()
											local v106 = fn35()

											if not flag19 or #v106 == 0 then
												TextLabel.Text = "No target"
											else
												local v107 = v106[v105] or v106[1]

												if v107 then
													TextLabel.Text = v90.format("%s  %s", v107.petName or "?", v107.mpsText or "")
												end
											end

											if not flag23 then
												return
											end
											flag23 = false

											for _, child in v92(Frame:GetChildren()) do
												if child:IsA("TextButton") then
													child:Destroy()
												end
											end

											tbl24 = {}

											if #v106 == 0 then
												Frame.Size = v101.new(1, 0, v85[117], 0)
												ScrollingFrame.CanvasSize = v101.new(0, 0, 0, 0)
												return
											end

											for i = 1, #v106 do
												local v107 = v106[i]
												local v108 = v102.new(v85[68])
												v108.Size = v101.new(1, 0, 0, 38)
												v108.BackgroundColor3 = tbl25.SURF2
												v108.BorderSizePixel = 0
												v108.Text = ""
												v108.AutoButtonColor = false
												v108.Parent = Frame
												v108.ClipsDescendants = true
												v108.ZIndex = 1
												fn38(v108, 9)
												local Frame3 = v102.new("Frame", v108)
												Frame3.Size = v101.new(1, 0, v85[48], v85[117])
												Frame3.BackgroundColor3 = v100.fromRGB(8, 10, 12)
												Frame3.BackgroundTransparency = v85[196]
												Frame3.BorderSizePixel = 0
												Frame3.Visible = false
												Frame3.ZIndex = 2
												fn38(Frame3, 9)
												local UIGradient = v102.new("UIGradient", Frame3)
												UIGradient.Rotation = 90
												local colorSequence = ColorSequence.new
												local tbl29 = {}
												local v109 = ColorSequenceKeypoint.new(v85[117], v100.fromRGB(0, 0, 0))
												local v110 = ColorSequenceKeypoint.new(0.45, v100.fromRGB(18, v85[76], 18))
												tbl29[1] = v109
												tbl29[2] = v110

												do
													local values = table.pack(ColorSequenceKeypoint.new(v85[48], v100.fromRGB(0, v85[117], v85[117])))
													table.move(values, 1, values.n, 3, tbl29)
												end

												UIGradient.Color = colorSequence(tbl29)
												local numberSequence = NumberSequence.new
												local tbl30 = {}
												local v111 = NumberSequenceKeypoint.new(0, 0.12)
												local v112 = NumberSequenceKeypoint.new(v85[164], 0.3)
												local v113 = NumberSequenceKeypoint.new(v85[152], 0.52)
												local new = NumberSequenceKeypoint.new
												local v114 = v85[48]
												tbl30[1] = v111
												tbl30[2] = v112
												tbl30[3] = v113

												do
													local values = table.pack(new(v114, 0.18))
													table.move(values, 1, values.n, 4, tbl30)
												end

												UIGradient.Transparency = numberSequence(tbl30)
												local Frame4 = v102.new("Frame", v108)
												Frame4.Size = v101.fromOffset(22, v85[76])
												Frame4.Position = v101.fromOffset(8, v85[176])
												Frame4.BackgroundColor3 = tbl25.SURF
												Frame4.ZIndex = v85[62]
												Frame4.BorderSizePixel = 0
												fn38(Frame4, 5)
												fn39(Frame4, tbl25.AQUA_STROKE, 1, 0.45)
												local TextLabel3 = v102.new("TextLabel", Frame4)
												TextLabel3.Size = v101.new(1, 0, v85[48], 0)
												TextLabel3.BackgroundTransparency = v85[48]
												TextLabel3.Text = "#" .. i
												TextLabel3.Font = v103.Font.GothamBold
												TextLabel3.TextSize = 11
												TextLabel3.TextColor3 = tbl25.TEXT
												TextLabel3.TextXAlignment = v103.TextXAlignment.Center
												TextLabel3.ZIndex = 4
												local TextLabel4 = v102.new("TextLabel", v108)
												TextLabel4.Size = v101.new(1, -v85[140], 0, 16)
												TextLabel4.Position = v101.fromOffset(38, v85[132])
												TextLabel4.BackgroundTransparency = v85[48]
												TextLabel4.Text = v107.petName or "Unknown"
												TextLabel4.Font = v103.Font.GothamBold
												TextLabel4.TextSize = 12
												TextLabel4.TextColor3 = tbl25.TEXT
												TextLabel4.TextXAlignment = v103.TextXAlignment.Left
												TextLabel4.ZIndex = 4
												local UITextSizeConstraint = v102.new("UITextSizeConstraint", TextLabel4)
												UITextSizeConstraint.MinTextSize = 8
												UITextSizeConstraint.MaxTextSize = v85[142]
												local TextLabel5 = v102.new("TextLabel", v108)
												TextLabel5.Size = v101.new(0, 88, v85[117], 16)
												TextLabel5.Position = v101.new(1, -96, 0, 4)
												TextLabel5.BackgroundTransparency = v85[48]
												TextLabel5.Text = v107.mpsText or "$0/s"
												TextLabel5.Font = v103.Font.GothamBold
												TextLabel5.TextSize = v85[142]
												TextLabel5.TextColor3 = v100.fromRGB(56, 214, v85[200])
												TextLabel5.TextXAlignment = v103.TextXAlignment.Right
												TextLabel5.TextTruncate = v103.TextTruncate.AtEnd
												TextLabel5.ZIndex = 4
												local v115, v116 = fn33(v107)
												local v117 = v102.new(v85[66], v108)
												v117.Size = v101.new(1, -108, 0, 16)
												v117.Position = v101.fromOffset(38, 18)
												v117.BackgroundTransparency = 1
												v117.RichText = v116
												v117.Text = v115
												v117.Font = v103.Font.GothamBold
												v117.TextSize = v85[142]
												v117.TextColor3 = fn32(v107.mutation)
												v117.TextXAlignment = v103.TextXAlignment.Left
												v117.ZIndex = v85[132]
												v117.Visible = v115 ~= ""
												local UITextSizeConstraint2 = v102.new("UITextSizeConstraint", v117)
												UITextSizeConstraint2.MinTextSize = 8
												UITextSizeConstraint2.MaxTextSize = 12
												tbl24[i] = { button = v108, selectedOverlay = Frame3, rankBox = Frame4, rankLabel = TextLabel3, petData = v107 }

												v108.MouseButton1Click:Connect(function()
													if uid2 == v107.uid then
														uid2 = nil
														uid = nil
														_G.NEAREST_INSTANT_MODE = stealNearest and instantSteal
													else
														v105 = i
														uid = v107.uid
														uid2 = v107.uid
														flag19 = true
														_G.NEAREST_INSTANT_MODE = v85[112]
													end

													flag23 = true
													fn47()
												end)
											end

											for _, v107 in v92(tbl24) do
												local visible = v107.petData and uid2 and v107.petData.uid == uid2
												v107.button.BackgroundColor3 = visible and v100.fromRGB(44, 128, 79) or tbl25.SURF2

												if v107.selectedOverlay then
													v107.selectedOverlay.Visible = visible
												end

												if v107.rankBox then
													v107.rankBox.BackgroundColor3 = visible and v100.fromRGB(v85[134], 97, 60) or tbl25.SURF
												end
											end

											local n33 = #v106 > 0 and #v106 * 38 + (#v106 - 1) * 5 or v85[117]
											Frame.Size = v101.new(v85[48], 0, 0, n33)
											ScrollingFrame.CanvasSize = v101.new(0, v85[117], v85[117], n33)
										end

										v88.spawn(function()
											while v88.wait(v85[198]) do
												if flag19 then
													for _, v106 in v93(tbl23) do
														if v106 and v106.Parent then
															fn36(v106)
														end
													end
												end
											end
										end)

										service2.Heartbeat:Connect(function() TextLabel2 .Text= v89 .floor( Frame2 .Size.X.Scale*100).."%";end)

										do
											local tbl29 = {}

											fn48 = function(arg, arg2)
												local now2 = os.clock()
												local v106 = tbl29[arg]
												if v106 and now2 - v106 < arg2 then
													return false
												end
												tbl29[arg] = now2
												return true
											end
										end
									end

									local function fn49(arg, arg2, arg3)
										if not arg or not arg.Parent or not arg.Enabled then
											return
										end

										if not fn48(arg, arg3) then
											return
										end
										local n33 = arg2 or 1

										for i = 1, n33 do
											v94(fireproximityprompt, arg)
										end
									end
								end

								local function fn48(arg)
									if #arg == 0 then
										return
									end

									if uid2 then
										for k, v106 in v92(arg) do
											if v106.uid == uid2 then
												if v105 ~= k then
													v105 = k
													uid = v106.uid
												end

												TextLabel.Text = v90.format("%s - %s", v106.petName or "Unknown", v106.mpsText or "")
												return
											end
										end

										uid2 = nil
									end

									if stealNearest then
										local character = localPlayer.Character
										local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

										if humanoidRootPart then
											local huge = v89.huge
											local v106, v107, v108 = v92(arg)
											local n33 = 1

											for k, v109 in v106, v107, v108 do
												local animalData = v109.animalData and fn31(v109.animalData)

												if animalData and animalData:IsA("BasePart") then
													local magnitude = (humanoidRootPart.Position - animalData.Position).Magnitude

													if magnitude < huge then
														huge = magnitude
														n33 = k
													end
												end
											end

											if arg[n33] then
												local v109 = arg[n33]
												TextLabel.Text = v90.format("%s - %s", v109.petName or "Unknown", v109.mpsText or "")
											end

											if not instantSteal and v105 ~= n33 then
												v105 = n33
												uid = arg[n33] and arg[n33].uid
											end
										end
									elseif stealHighest then
										if v105 ~= 1 then
											v105 = v85[48]
											uid = arg[1] and arg[1].uid
										end
									end
								end

								service2.Heartbeat:Connect(function(...) end)

								v88.spawn(function()
									while v85[8] do
										v88.wait(0.5)
										flag23 = v85[8]
										fn47()
									end
								end)
							end
						end

						do
							do
								do
									local function fn47(arg)
										local plots = Workspace:FindFirstChild("Plots")

										if not plots then
											if n25 > 6411 then
												while v85[8] do
												end
											end

											return v85[112]
										end

										local v106 = plots:FindFirstChild(arg)
										if not v106 then
											return v85[112]
										end
										local plotSign = v106:FindFirstChild("PlotSign")
										if not plotSign then
											return false
										end
										local yourBase = plotSign:FindFirstChild("YourBase")
										return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled
									end

									local function fn48()
										local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
										if not humanoidRootPart then
											return nil, v89.huge
										end
										local plots = Workspace:FindFirstChild("Plots")
										if not plots then
											return nil, v89.huge
										end
										local huge = v89.huge
										local v106 = nil

										for _, child in v92(plots:GetChildren()) do
											if not fn47(child.Name) then
												local huge2 = v89.huge

												v94(function()
													local position = humanoidRootPart.Position
													huge2 = (child:GetPivot().Position - position).Magnitude
												end)

												if huge2 > 100 then
												else
													local animalPodiums = child:FindFirstChild("AnimalPodiums")

													if not animalPodiums then
													else
														for _, child2 in v92(animalPodiums:GetChildren()) do
															local base = child2:FindFirstChild("Base")
															base = base and base:FindFirstChild("Spawn")

															if base then
																local magnitude = (base.Position - humanoidRootPart.Position).Magnitude

																if not (magnitude > 60 or magnitude >= huge) then
																	local v107 = base:FindFirstChild(v85[106])

																	if v107 then
																		local proximityPrompt = v107:FindFirstChildOfClass("ProximityPrompt")

																		if proximityPrompt and proximityPrompt.Parent and proximityPrompt.Enabled then
																			huge = magnitude
																			v106 = proximityPrompt
																		end
																	end
																end
															end
														end
													end
												end
											end
										end

										return v106, huge, nil
									end
								end
							end

							do
								local fn47, fn48, fn49

								do
									service2.Heartbeat:Connect(function(...) end)
									fn47 = nil
									fn48 = nil
									fn49 = nil

									do
										local function fn50()
											local tbl29 = {}
											local flag23 = false
											local tbl30 = { "Base", v85[55], "FriendPanel", "Cash", v85[53], "Skin", v85[28], "Purchases" }

											local function fn51(arg)
												if not flag23 then
													return
												end

												if not arg:IsA("BasePart") then
													return
												end

												if tbl29[arg] == nil then
													tbl29[arg] = arg.Transparency
												end

												if tbl29[arg] < v85[107] then
													arg.Transparency = 0.7
												end
											end

											local function fn52()
												for k, v106 in v93(tbl29) do
													if k.Parent then
														v94(function()
															k.Transparency = v106
														end)
													end
												end

												v91.clear(tbl29)
											end

											local tbl31 = {}
											local n33 = 0

											local function fn53(arg, arg2)
												if not arg or arg2 ~= n33 then
													return
												end
												fn51(arg)
												local descendants = arg:GetDescendants()

												for i = 1, #descendants do
													if arg2 ~= n33 then
														return
													end
													fn51(descendants[i])
													if i % 300 ~= 0 then
														continue
													end
													v88.wait()
													if arg2 ~= n33 then
														return
													end
												end
											end

											local function fn54(arg, arg2)
												if not arg or arg2 ~= n33 then
													return
												end
												fn53(arg, arg2)
												if arg2 ~= n33 then
													return
												end

												tbl31[#tbl31 + 1] = arg.DescendantAdded:Connect(function(descendant)
													if arg2 ~= n33 then
														return
													end
													fn51(descendant)
												end)
											end

											local function fn55(arg, arg2)
												if not arg or arg2 ~= n33 then
													return
												end

												for _, v106 in v92(tbl30) do
													if arg2 ~= n33 then
														return
													end
													fn54(arg:FindFirstChild(v106), arg2)
												end

												if arg2 ~= n33 then
													return
												end

												tbl31[#tbl31 + 1] = arg.ChildAdded:Connect(function(child)
													if arg2 ~= n33 then
														return
													end

													for _, v106 in v92(tbl30) do
														if child.Name == v106 then
															fn54(child, arg2)
															break
														end
													end
												end)

												local animalPodiums = arg:FindFirstChild("AnimalPodiums")

												if animalPodiums then
													local function fn56(arg3)
														for _, child in v92(arg3:GetChildren()) do
															if child.Name == "Claim" then
																fn54(child, arg2)
															elseif child.Name == "Base" then
																fn54(child:FindFirstChild("Decorations"), arg2)
															elseif child:IsA(v85[11]) and child.Name ~= "Decorations" then
																fn54(child, arg2)
															end
														end
													end

													for _, child in v92(animalPodiums:GetChildren()) do
														fn56(child)
													end

													tbl31[#tbl31 + 1] = animalPodiums.ChildAdded:Connect(function(child)
														if arg2 ~= n33 then
															return
														end
														v88.wait(0.1)
														if arg2 ~= n33 then
															return
														end
														fn56(child)
													end)
												end
											end

											local function fn56(arg)
												local plots = v86:FindFirstChild("Plots")
												if not plots then
													return
												end

												for _, child in v92(plots:GetChildren()) do
													if arg ~= n33 then
														return
													end
													fn55(child, arg)
												end

												tbl31[#tbl31 + 1] = plots.ChildAdded:Connect(function(child)
													if arg ~= n33 then
														return
													end
													v88.wait(0.2)
													fn55(child, arg)
												end)
											end

											fn47 = function()
												flag23 = true
												n33 += 1
												local v106 = n33

												for _, v107 in v92(tbl31) do
													if typeof(v107) == "RBXScriptConnection" then
														v94(function()
															v107:Disconnect()
														end)
													end
												end

												tbl31 = {}

												v88.spawn(function()
													while v106 == n33 and not v86:FindFirstChild("Plots") do
														v88.wait()
													end

													if v106 ~= n33 then
														return
													end
													v94(fn56, v106)
												end)
											end

											fn48 = function()
												flag23 = v85[112]
												n33 += v85[48]

												for _, v106 in v92(tbl31) do
													if typeof(v106) == "RBXScriptConnection" then
														v94(function()
															v106:Disconnect()
														end)
													end
												end

												tbl31 = {}
												fn52()
											end

											local flag24 = v85[112]

											service.PlayerAdded:Connect(function()
												if not flag23 or flag24 then
													return
												end
												flag24 = true

												v88.spawn(function()
													v88.wait(v85[65])
													flag24 = false

													if flag23 then
														n33 += 1
														local v106 = n33

														for _, v107 in v92(tbl31) do
															if typeof(v107) == "RBXScriptConnection" then
																v94(function()
																	v107:Disconnect()
																end)
															end
														end

														tbl31 = {}
														v94(fn56, v106)
													end
												end)
											end)

											fn49 = function()
												return flag23
											end
										end

										fn50()
									end
								end

								local function fn50()
									local tbl29 = nil
									local fn51 = nil
									local fn52 = nil
									local fn53 = nil
									local tbl30 = nil
									local fn54 = nil
									local fn55 = nil

									local function fn56()
										tbl29 = {
											active = false,
											markers = {},
											fills = {},
											conns = {},
											collideParts = {},
											labelAnchors = {},
											labelsByPlot = {},
											currentPlot = nil,
											pending = false,
										}

										local v106 = v100.fromRGB(255, 60, 60)
										local v107 = v100.fromRGB(255, 255, 255)
										local n33 = 0.05
										local v108 = v85[198]
										local n34 = 0.12
										local v109 = v98.new(6, v85[44], 6)
										local v110 = v98.new(4, 0.25, 4)

										local tbl31 = {
											{ 18.5, 1.531, -14.476, 90 },
											{ 18.5, 1.531, -6.976, 90 },
											{ 18.5, 1.531, 0.524, v85[21] },
											{ 18.5, 1.531, v85[191], 90 },
											{ 18.5, 1.531, 15.524, 90 },
											{ -18.536, v85[150], 15.524, -90 },
											{ -18.536, v85[150], v85[191], -90 },
											{ -18.536, 1.531, 0.524, -90 },
											{ -v85[70], 1.531, -6.976, -90 },
											{ -18.536, 1.531, -14.476, -90 },
											{ 18.5, 19.531, -14.476, 90 },
											{ 18.5, 19.531, -6.976, v85[21] },
											{ 18.5, 19.531, 0.524, 90 },
											{ 18.5, v85[82], 8.024, 90 },
											{ v85[41], v85[82], v85[18], 90 },
											{ -18.38, 19.531, -v85[143], -v85[21] },
											{ -18.38, 19.531, -6.952, -90 },
											{ -v85[195], 19.531, 0.548, -90 },
											{ 18.5, 36.531, -12.476, 90 },
											{ 18.5, 36.531, -4.976, 90 },
											{ v85[41], 36.531, 2.524, 90 },
											{ 18.5, 36.531, 10.024, 90 },
											{ 18.5, 36.531, 17.524, 90 },
											{ -18.472, 36.531, -v85[130], -90 },
											{ -18.471, 36.531, -5.001, -90 },
											{ -18.471, 36.531, v85[166], -90 },
											{ -v85[35], 36.531, v85[197], -90 },
											{ -18.471, 36.531, 17.499, -90 },
										}

										local v111 = Random.new(os.clock() * 1000000)

										local tbl32 = {
											"Part",
											"Mesh",
											"MeshPart",
											"Union",
											"Wedge",
											"Cylinder",
											v85[11],
											v85[73],
											"Handle",
											"Body",
											"Root",
										}

										local function fn57()
											return tbl32[v111:NextInteger(1, #tbl32)]
										end

										local function fn58(arg)
											tbl29.markers[#tbl29.markers + 1] = arg
											arg.Parent = gethui and gethui() or v87:GetService(v85[119])
											return arg
										end

										local function fn59()
											for _, marker in v92(tbl29.markers) do
												v94(function()
													marker:Destroy()
												end)
											end

											v91.clear(tbl29.markers)
											v91.clear(tbl29.fills)

											for _, collidePart in v92(tbl29.collideParts) do
												v94(function()
													collidePart:Destroy()
												end)
											end

											v91.clear(tbl29.collideParts)

											for _, labelAnchor in v92(tbl29.labelAnchors) do
												v94(function()
													labelAnchor:Destroy()
												end)
											end

											v91.clear(tbl29.labelAnchors)
											v91.clear(tbl29.labelsByPlot)
											tbl29.currentPlot = nil
										end

										local function fn60(adornee, cFrame, size, color3, transparency, arg)
											local BoxHandleAdornment = v102.new("BoxHandleAdornment")
											BoxHandleAdornment.Adornee = adornee
											BoxHandleAdornment.Size = size
											BoxHandleAdornment.CFrame = cFrame
											BoxHandleAdornment.Color3 = color3
											BoxHandleAdornment.Transparency = transparency
											BoxHandleAdornment.AlwaysOnTop = false
											BoxHandleAdornment.ZIndex = 0
											fn58(BoxHandleAdornment)

											if arg then
												tbl29.fills[#tbl29.fills + 1] = { a = BoxHandleAdornment, base = transparency }
											end

											return BoxHandleAdornment
										end

										local function fn61(arg, arg2, arg3, arg4)
											local n35 = n33 * 1.6
											local n36 = arg3.X * 0.5
											local n37 = arg3.Z * 0.5
											local n38 = arg3.Y * v85[65]
											fn60(arg, arg2 * v99.new(v85[117], n38, n37), v98.new(arg3.X, n35, n35), arg4, 0)
											fn60(arg, arg2 * v99.new(0, n38, -n37), v98.new(arg3.X, n35, n35), arg4, 0)
											local v112 = v85[117]
											fn60(arg, arg2 * v99.new(n36, n38, 0), v98.new(n35, n35, arg3.Z), arg4, v112)
											fn60(arg, arg2 * v99.new(-n36, n38, 0), v98.new(n35, n35, arg3.Z), arg4, 0)
										end

										local function fn62(cFrame)
											local Part = v102.new("Part")
											Part.Name = fn57()
											Part.Anchored = true
											Part.CanCollide = true
											Part.CanQuery = false
											Part.CanTouch = false
											Part.CastShadow = false
											Part.Transparency = 1
											Part.Massless = v85[8]
											Part.Size = v109
											Part.CFrame = cFrame
											Part.Parent = v86.CurrentCamera
											tbl29.collideParts[#tbl29.collideParts + 1] = Part
										end

										local function fn63(cFrame)
											local Part = v102.new("Part")
											Part.Name = fn57()
											Part.Anchored = true
											Part.CanCollide = false
											Part.CanQuery = false
											Part.CanTouch = false
											Part.CastShadow = false
											Part.Transparency = 1
											Part.Size = v98.new(0.1, 0.1, v85[114])
											Part.CFrame = cFrame
											Part.Parent = v86.CurrentCamera
											tbl29.labelAnchors[#tbl29.labelAnchors + 1] = Part
											return Part
										end

										local function fn64(arg, adornee, arg2, color)
											local BillboardGui = v102.new("BillboardGui")
											BillboardGui.Adornee = adornee
											BillboardGui.Size = v101.new(2.2, 20, 1.35, 12)
											BillboardGui.StudsOffset = v98.new(v85[117], 3.2, 0)
											BillboardGui.AlwaysOnTop = true
											BillboardGui.LightInfluence = 0
											BillboardGui.MaxDistance = 400
											BillboardGui.ClipsDescendants = false
											BillboardGui.Enabled = false
											local v112 = v102.new(v85[73])
											v112.Size = v101.new(1, 0, v85[48], v85[117])
											v112.BackgroundColor3 = v100.fromRGB(v85[176], v85[176], 12)
											v112.BackgroundTransparency = 0.55
											v112.BorderSizePixel = 0
											v112.Parent = BillboardGui
											local UICorner = v102.new("UICorner")
											UICorner.CornerRadius = UDim.new(0.3, v85[117])
											UICorner.Parent = v112
											local UIStroke = v102.new("UIStroke")
											UIStroke.Color = color
											UIStroke.Thickness = v85[132]
											UIStroke.Transparency = 0.7
											UIStroke.ApplyStrokeMode = v103.ApplyStrokeMode.Border
											UIStroke.Parent = v112
											local Frame3 = v102.new("Frame")
											Frame3.Size = v101.new(1, 0, v85[48], v85[117])
											Frame3.BackgroundTransparency = 1
											Frame3.Parent = v112
											local UICorner2 = v102.new("UICorner")
											UICorner2.CornerRadius = UDim.new(0.3, 0)
											UICorner2.Parent = Frame3
											local UIStroke2 = v102.new("UIStroke")
											UIStroke2.Color = color
											UIStroke2.Thickness = 1.5
											UIStroke2.Transparency = 0
											UIStroke2.ApplyStrokeMode = v103.ApplyStrokeMode.Border
											UIStroke2.Parent = Frame3
											local TextLabel3 = v102.new("TextLabel")
											TextLabel3.Size = v101.new(1, 0, 1, 0)
											TextLabel3.BackgroundTransparency = 1
											TextLabel3.Text = v96(arg2)
											TextLabel3.Font = v103.Font.GothamBlack
											TextLabel3.TextScaled = v85[8]
											TextLabel3.TextColor3 = v107
											TextLabel3.TextXAlignment = v103.TextXAlignment.Center
											TextLabel3.TextYAlignment = v103.TextYAlignment.Center
											TextLabel3.Parent = v112
											local UIPadding = v102.new("UIPadding")
											UIPadding.PaddingLeft = UDim.new(0.1, 0)
											UIPadding.PaddingRight = UDim.new(v85[114], 0)
											UIPadding.PaddingTop = UDim.new(v85[60], 0)
											UIPadding.PaddingBottom = UDim.new(0.08, 0)
											UIPadding.Parent = TextLabel3
											local UITextSizeConstraint = v102.new("UITextSizeConstraint")
											UITextSizeConstraint.MaxTextSize = 500
											UITextSizeConstraint.MinTextSize = 6
											UITextSizeConstraint.Parent = TextLabel3
											local v113 = v102.new(v85[86])
											v113.Color = color
											v113.Thickness = 2
											v113.Transparency = 0
											v113.LineJoinMode = v103.LineJoinMode.Round
											v113.Parent = TextLabel3
											fn58(BillboardGui)

											if not tbl29.labelsByPlot[arg] then
												tbl29.labelsByPlot[arg] = {}
											end

											local v114 = tbl29.labelsByPlot[arg]
											v114[#v114 + 1] = BillboardGui
										end

										local function fn65(arg, arg2, arg3, arg4)
											local angles = v99.Angles
											local v112 = v85[117]
											local n35 = arg2.CFrame * v99.new(arg3[1], arg3[2], arg3[v85[62]]) * angles(0, v89.rad(arg3[4]), v112)
											local v113 = fn63(n35)
											fn60(v113, v99.new(), v109, v106, 0.55, true)
											fn60(v113, v99.new(v85[117], 0.25, 0), v110, v106, 0.42, true)
											fn61(v113, v99.new(), v109, v106)
											fn62(n35)
											fn64(arg, v113, arg4, v106)
										end

										local function fn66()
											local character = localPlayer.Character
											character = character and character:FindFirstChild("HumanoidRootPart")
											if not character then
												return nil
											end
											local v112 = v86:FindFirstChild(v85[84])
											if not v112 then
												return nil
											end
											local position = character.Position
											local huge = v89.huge
											local v113 = nil

											for _, child in v92(v112:GetChildren()) do
												local v114 = child:FindFirstChild(v85[15])

												if v114 then
													local magnitude = (v114.Position - position).Magnitude

													if magnitude < huge then
														huge = magnitude
														v113 = child
													end
												end
											end

											if v85[91] < huge then
												return nil
											end
											return v113
										end

										local function fn67(arg)
											local v112 = fn66()
											if not arg and v112 == tbl29.currentPlot then
												return
											end
											tbl29.currentPlot = v112
											local flag23 = tbl19.slotNumbers ~= v85[112]

											for k, v113 in v93(tbl29.labelsByPlot) do
												local enabled = flag23 and k == v112

												for _, v114 in v92(v113) do
													if v114 and v114.Parent then
														v114.Enabled = enabled
													end
												end
											end
										end

										local function fn68()
											if not tbl29.active then
												return
											end
											fn59()
											local plots = v86:FindFirstChild("Plots")
											if not plots then
												return
											end

											for _, child in v92(plots:GetChildren()) do
												local v112 = child:FindFirstChild(v85[15])

												if v112 then
													for i = v85[48], #tbl31 do
														fn65(child, v112, tbl31[i], i)
													end
												end
											end

											fn67()
										end

										local function fn69()
											if tbl29.pending or not tbl29.active then
												return
											end
											tbl29.pending = v85[8]

											v88.delay(v85[153], function()
												tbl29.pending = false
												fn68()
											end)
										end

										fn51 = function()
											if tbl29.active then
												return
											end
											local plots = v86:FindFirstChild("Plots")

											if not plots then
												v88.spawn(function()
													if v86:WaitForChild("Plots", 30) then
														fn51()
													end
												end)

												return
											end

											tbl29.active = true
											fn68()

											local function fn70(arg)
												if not arg:FindFirstChild("MainRoot") then
													if arg:WaitForChild("MainRoot", 30) and tbl29.active then
														fn69()
													end
												end
											end

											for _, child in v92(plots:GetChildren()) do
												v88.spawn(fn70, child)
											end

											tbl29.conns[#tbl29.conns + 1] = plots.ChildAdded:Connect(function(child)
												v88.spawn(fn70, child)
												fn69()
											end)

											tbl29.conns[#tbl29.conns + 1] = v86:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
												if tbl29.active then
													fn69()
												end
											end)

											local n35 = 0
											local n36 = 0

											tbl29.conns[#tbl29.conns + 1] = service2.Heartbeat:Connect(function(deltaTime)
												if not tbl29.active then
													return
												end
												n35 += deltaTime
												n36 += deltaTime

												if n35 >= 0.05 then
													n35 = 0
													local n37 = v89.sin(os.clock() * v108) * n34

													for _, fill in v92(tbl29.fills) do
														if fill.a.Parent then
															fill.a.Transparency = v89.clamp(fill.base + n37, v85[117], 1)
														end
													end
												end

												if n36 >= v85[65] then
													n36 = 0
													fn67()
												end
											end)
										end

										fn52 = function()
											if not tbl29.active then
												return
											end
											tbl29.active = v85[112]

											for _, conn in v92(tbl29.conns) do
												v94(function()
													conn:Disconnect()
												end)
											end

											v91.clear(tbl29.conns)
											fn59()
										end

										fn53 = function()
											if tbl29.active then
												fn67(true)
											end
										end

										tbl30 = { active = false, bases = {}, connected = {}, conns = {}, anchor = nil, bb = nil }
										local tbl33 = {}
										local v112 = v98.new(-342.439, 10.399, 113.107)
										local v113 = v98.new(-v85[79], 10.465, 6.107)
										local v114 = v98.new(-476.752, 10.465, v85[159])
										local v115 = v98.new(-476.752, 10.465, v85[90])
										local v116 = v98.new(-342.44, 10.464, 220.107)
										local v117 = v98.new(-476.752, 10.465, 221.107)
										local v118 = v98.new(-342.439, 10.465, -100.893)
										local new = v98.new
										tbl33[1] = v112
										tbl33[2] = v113
										tbl33[3] = v114
										tbl33[4] = v115
										tbl33[5] = v116
										tbl33[6] = v117
										tbl33[7] = v118

										do
											local values = table.pack(new(-476.752, 10.465, -99.893))
											table.move(values, 1, values.n, 8, tbl33)
										end

										local v119 = utf8.char(11015)

										local function fn70(arg)
											local v120, v121 = v94(function()
												return (arg:GetBoundingBox())
											end)

											if not v120 then
												return nil
											end
											local position = v121.Position
											local v122 = nil
											local v123 = nil

											for k, v124 in v92(tbl33) do
												local n35 = position.X - v124.X
												local n36 = position.Z - v124.Z
												local v125 = v89.sqrt(n35 * n35 + n36 * n36)

												if not v122 or v125 < v122 then
													v122 = v125
													v123 = k
												end
											end

											return v122 and v122 <= 6 and v123 or nil
										end

										local function fn71(arg)
											return arg.Text:gsub("^%s+", ""):gsub("%s+$", "") == "Empty Base"
										end

										local function fn72()
											if not tbl30.active or not tbl30.bb then
												return
											end
											local v120 = nil

											for i = v85[48], #tbl33 do
												local v121 = tbl30.bases[i]

												if v121 and v121.label and v121.label.Parent and fn71(v121.label) then
													v120 = i
													break
												else
													v120 = nil
												end
											end

											if v120 then
												tbl30.anchor.CFrame = tbl30.bases[v120].cf
												tbl30.bb.Enabled = v85[8]
											else
												tbl30.bb.Enabled = false
											end
										end

										local function fn73(arg)
											if tbl30.connected[arg] then
												return
											end
											tbl30.connected[arg] = v85[8]
											tbl30.conns[#tbl30.conns + 1] = arg:GetPropertyChangedSignal("Text"):Connect(fn72)
										end

										local function fn74()
											if not tbl30.active then
												return
											end
											local plots = v86:FindFirstChild("Plots")
											if not plots then
												return
											end

											for _, child in v92(plots:GetChildren()) do
												local plotSign = child:FindFirstChild("PlotSign")
												local model = plotSign and plotSign:FindFirstChild("Model")
												local frame = plotSign and plotSign:FindFirstChild(v85[185])
												frame = frame and frame:FindFirstChild("Frame")
												frame = frame and frame:FindFirstChild(v85[66])

												if model and frame then
													local v120 = fn70(model)

													if v120 then
														tbl30.bases[v120] = { label = frame, cf = select(1, model:GetBoundingBox()) }
														fn73(frame)
													end
												end
											end

											fn72()
										end

										fn54 = function()
											if tbl30.active then
												return
											end
											local plots = v86:FindFirstChild("Plots")

											if not plots then
												v88.spawn(function()
													if v86:WaitForChild("Plots", 30) then
														fn54()
													end
												end)

												return
											end

											tbl30.active = true
											local Part = v102.new("Part")
											Part.Name = fn57()
											Part.Anchored = v85[8]
											Part.CanCollide = false
											Part.CanQuery = false
											Part.CanTouch = false
											Part.Transparency = 1
											Part.Size = v98.new(1, 1, 1)
											Part.Parent = v86.CurrentCamera
											tbl30.anchor = Part
											local BillboardGui = v102.new("BillboardGui")
											BillboardGui.Adornee = Part
											BillboardGui.Size = v101.fromScale(32, 13)
											BillboardGui.StudsOffset = v98.new(0, v85[36], v85[117])
											BillboardGui.MaxDistance = v89.huge
											BillboardGui.AlwaysOnTop = true
											BillboardGui.LightInfluence = v85[117]
											BillboardGui.Enabled = false
											BillboardGui.Parent = Part
											tbl30.bb = BillboardGui
											local TextLabel3 = v102.new("TextLabel", BillboardGui)
											TextLabel3.BackgroundTransparency = 1
											TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5)
											TextLabel3.Position = v101.fromScale(0.5, 0.3)
											TextLabel3.Size = v101.fromScale(0.95, v85[65])
											TextLabel3.Font = v103.Font.GothamBlack
											TextLabel3.Text = v119 .. "  NEXT  " .. v119
											TextLabel3.TextScaled = true
											TextLabel3.TextColor3 = v100.fromRGB(255, 60, 60)
											TextLabel3.TextStrokeColor3 = v100.fromRGB(0, 0, v85[117])
											TextLabel3.TextStrokeTransparency = 0
											local v120 = v102.new(v85[66], BillboardGui)
											v120.BackgroundTransparency = 1
											v120.AnchorPoint = Vector2.new(0.5, v85[65])
											v120.Position = v101.fromScale(v85[65], 0.72)
											v120.Size = v101.fromScale(0.95, 0.42)
											v120.Font = v103.Font.GothamBlack
											v120.Text = "EMPTY BASE"
											v120.TextScaled = v85[8]
											v120.TextColor3 = v100.fromRGB(255, 255, 255)
											v120.TextStrokeColor3 = v100.fromRGB(0, v85[117], 0)
											v120.TextStrokeTransparency = 0
											fn74()

											tbl30.conns[#tbl30.conns + 1] = plots.DescendantAdded:Connect(function(descendant)
												if descendant:IsA(v85[66]) then
													v88.defer(fn74)
												end
											end)

											tbl30.conns[#tbl30.conns + v85[48]] = plots.ChildAdded:Connect(function()
												v88.defer(fn74)
											end)

											tbl30.conns[#tbl30.conns + 1] = v86:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
												if tbl30.active and tbl30.anchor then
													tbl30.anchor.Parent = v86.CurrentCamera
												end
											end)
										end

										fn55 = function()
											if not tbl30.active then
												return
											end
											tbl30.active = v85[112]

											for _, conn in v92(tbl30.conns) do
												v94(function()
													conn:Disconnect()
												end)
											end

											v91.clear(tbl30.conns)
											v91.clear(tbl30.connected)
											v91.clear(tbl30.bases)

											if tbl30.anchor then
												v94(function()
													tbl30.anchor:Destroy()
												end)
											end

											tbl30.anchor = nil
											tbl30.bb = nil
										end
									end

									fn56()
									local xrayBases = fn44(v, "Xray Bases", 1)

									if tbl19.xray then
										v88.spawn(function()
											v88.wait(v85[65])
											fn47()
										end)
									end

									fn46(xrayBases, tbl19.xray)

									xrayBases.button.MouseButton1Click:Connect(function()
										if fn49() then
											fn48()
										else
											fn47()
										end

										fn46(xrayBases, fn49())
										tbl19.xray = fn49()
										fn30()
									end)

									local slotEsp = fn44(v, "Slot ESP", 3)
									local Frame3 = v102.new("Frame", v)
									Frame3.Name = "SlotNumbersSub"
									Frame3.BackgroundTransparency = 1
									Frame3.BorderSizePixel = 0
									Frame3.Size = v101.new(1, 0, v85[117], 0)
									Frame3.LayoutOrder = 4
									Frame3.ClipsDescendants = true
									Frame3.Visible = v85[112]
									Frame3.ZIndex = v85[125]
									local slotNumbers = fn44(Frame3, "Slot Numbers", 1)
									slotNumbers.row.Size = v101.new(v85[48], -18, 0, 34)
									slotNumbers.row.Position = v101.fromOffset(v85[74], 1)
									slotNumbers.row.BackgroundColor3 = v100.fromRGB(v85[34], v85[142], 12)
									slotNumbers.label.TextSize = 11
									slotNumbers.label.Position = v101.fromOffset(v85[155], v85[117])
									local Frame4 = v102.new("Frame", slotNumbers.row)
									Frame4.Size = v101.new(0, 3, 0.6, v85[117])
									Frame4.Position = v101.new(0, 6, 0.2, 0)
									Frame4.BackgroundColor3 = tbl26.AQUA
									Frame4.BackgroundTransparency = 0.15
									Frame4.BorderSizePixel = v85[117]
									Frame4.ZIndex = 105
									fn38(Frame4, v85[198])
									fn46(slotNumbers, tbl19.slotNumbers ~= false)

									slotNumbers.button.MouseButton1Click:Connect(function()
										tbl19.slotNumbers = not (tbl19.slotNumbers ~= false)
										fn46(slotNumbers, tbl19.slotNumbers)
										fn53()
										fn30()
									end)

									local TextButton = v102.new("TextButton", slotEsp.row)
									TextButton.AutoButtonColor = false
									TextButton.Size = v101.fromOffset(v85[155], 16)
									TextButton.Position = v101.new(0, v85[92], 0.5, -8)
									TextButton.BackgroundColor3 = v100.fromRGB(70, 22, 22)
									TextButton.BorderSizePixel = 0
									TextButton.Text = "-"
									TextButton.Font = v103.Font.GothamBlack
									TextButton.TextSize = 14
									TextButton.TextColor3 = tbl26.TEXT
									TextButton.Visible = false
									TextButton.ZIndex = 105
									fn38(TextButton, 4)
									local v106 = fn39(TextButton, tbl26.AQUA, 1, v85[153])

									TextButton.MouseEnter:Connect(function()
										fn40(TextButton, v85[199], { BackgroundColor3 = tbl26.AQUA2 })
										fn40(v106, 0.12, { Transparency = v85[114] })
									end)

									TextButton.MouseLeave:Connect(function()
										fn40(TextButton, 0.12, { BackgroundColor3 = v100.fromRGB(v85[192], v85[76], 22) })
										fn40(v106, 0.12, { Transparency = 0.4 })
									end)

									local position = slotEsp.label.Position
									local tween = nil

									local function fn57(arg, arg2)
										if tween then
											tween:Cancel()
											tween = nil
										end

										TextButton.Text = arg and "-" or "+"

										if arg then
											Frame3.Visible = true
											if arg2 then
												Frame3.Size = v101.new(v85[48], 0, 0, 36)
												return
											end
											tween = TweenService:Create(Frame3, TweenInfo.new(0.24, v103.EasingStyle.Back, v103.EasingDirection.Out), { Size = v101.new(1, 0, 0, 36) })
											tween:Play()
										else
											if arg2 then
												Frame3.Size = v101.new(1, v85[117], v85[117], 0)
												Frame3.Visible = false
												return
											end

											tween = TweenService:Create(Frame3, TweenInfo.new(v85[77], v103.EasingStyle.Quint, v103.EasingDirection.In), { Size = v101.new(1, 0, v85[117], 0) })
											tween:Play()

											tween.Completed:Connect(function(playbackState)
												if playbackState == v103.PlaybackState.Completed then
													Frame3.Visible = false
												end
											end)
										end
									end

									local function fn58(arg)
										local active = tbl29.active
										TextButton.Visible = active
										local v107 = active and v101.fromOffset(30, v85[117]) or position

										if arg then
											slotEsp.label.Position = v107
										else
											fn40(slotEsp.label, 0.18, { Position = v107 })
										end

										fn57(active and not tbl18.SlotNumbers, arg)
									end

									TextButton.MouseButton1Click:Connect(function()
										tbl18.SlotNumbers = not tbl18.SlotNumbers
										fn30()
										fn58(false)
									end)

									if tbl19.slotESP then
										v88.spawn(function()
											v88.wait(0.5)
											fn51()
											fn58(v85[8])
										end)
									end

									fn46(slotEsp, tbl19.slotESP)

									slotEsp.button.MouseButton1Click:Connect(function()
										if tbl29.active then
											fn52()
										else
											fn51()
										end

										fn46(slotEsp, tbl29.active)
										tbl19.slotESP = tbl29.active
										fn58(false)
										fn30()
									end)

									local nextEmptyBase = fn44(v, "Next Empty Base", v85[23])

									if tbl19.nextBase then
										v88.spawn(function()
											v88.wait(0.5)
											fn54()
										end)
									end

									fn46(nextEmptyBase, tbl19.nextBase)

									nextEmptyBase.button.MouseButton1Click:Connect(function()
										if tbl30.active then
											fn55()
										else
											fn54()
										end

										fn46(nextEmptyBase, tbl30.active)
										tbl19.nextBase = tbl30.active
										fn30()
									end)
								end

								fn50()
							end
						end

						do
							v88.spawn(function()
								local brainrotESP = tbl19.brainrotESP

								local function fn47()
									for _, child in v92(Workspace:GetChildren()) do
										if child.Name == "XiBrainrotESP" then
											v94(function()
												child:Destroy()
											end)
										end
									end

									local CoreGui = v87:GetService("CoreGui")

									for _, child in v92(CoreGui:GetChildren()) do
										if child:IsA("Highlight") and child.Name == "XiBrainrotESP_Highlight" then
											v94(function()
												child:Destroy()
											end)
										end
									end

									for _, descendant in v92(Workspace:GetDescendants()) do
										if descendant:IsA("BillboardGui") and v90.sub(descendant.Name, 1, 12) == "BrainrotESP_" then
											v94(function()
												descendant:Destroy()
											end)
										end
									end
								end

								fn47()
								local Folder = v102.new("Folder")
								Folder.Name = "XiBrainrotESP"
								Folder.Parent = Workspace
								local tbl29 = {}
								local tbl30 = {}
								local n33 = 0
								local v106 = nil
								local v107 = nil
								local displayName = localPlayer.DisplayName

								local tbl31 = {
									Cursed = v100.fromRGB(v85[127], 0, 0),
									Gold = v100.fromRGB(255, 215, 0),
									Diamond = v100.fromRGB(0, 255, 255),
									YinYang = v100.fromRGB(220, 220, v85[183]),
									Rainbow = v100.fromRGB(255, v85[91], 200),
									Lava = v100.fromRGB(255, 100, v85[129]),
									Candy = v100.fromRGB(255, 105, 180),
									Bloodrot = v100.fromRGB(139, 0, 0),
									Radioactive = v100.fromRGB(0, 255, 0),
									Divine = v100.fromRGB(255, v85[63], v85[63]),
								}

								local function fn48(arg)
									if not arg then
										return nil
									end
									local attribute = arg:GetAttribute("_BR_UID")
									if attribute then
										return v96(attribute)
									end
									n33 += 1
									local str9 = "br_" .. v96(n33)
									arg:SetAttribute("_BR_UID", str9)
									return str9
								end

								local function fn49(arg)
									return arg and arg ~= "None" and arg ~= "N/A" and tbl31[arg] or v100.fromRGB(v85[117], 255, 150)
								end

								local function fn50(arg)
									if n26(313) > 4529 then
										local v108 = v96(arg or "")
										if v108 == "" then
											return nil
										end
										local match, v109 = v108:gsub("%s+", ""):match("%$?([%d%.]+)([KkMmBb]?)/s")
										if not match then
											return nil
										end
										local v110 = v97(match)
										if not v110 then
											return nil
										end
										local str9 = (v109 or ""):upper()
										if str9 == "B" then
											return v110 * 1000, true
										end

										if str9 == "M" then
											return v110, false
										end

										if str9 == "K" then
											return v110 / 1000, false
										end
										return v110 / 1000000, false
									end

									while true do
									end
								end

								local function fn51(arg)
									local n34 = arg or 0
									if n34 >= 1000 then
										local n35 = n34 / 1000
										return v89.floor(n35) == n35 and v90.format("$%dB/s", n35) or v90.format("$%.1fB/s", n35)
									end

									if n34 >= 1 then
										return v89.floor(n34) == n34 and v90.format("$%dM/s", n34) or v90.format("$%.1fM/s", n34)
									end

									if n34 >= 0.001 then
										local n35 = n34 * 1000
										return v89.floor(n35) == n35 and v90.format("$%dK/s", n35) or v90.format("$%.1fK/s", n35)
									end
									return v90.format("$%d/s", v89.floor(n34 * 1000000 + 0.5))
								end

								local function fn52()
									local v108 = Workspace:FindFirstChild(v85[84])
									if not v108 then
										return nil
									end

									for _, child in v92(v108:GetChildren()) do
										local plotSign = child:FindFirstChild("PlotSign")
										if not plotSign then
											continue
										end
										local v109 = plotSign:FindFirstChild(v85[185])
										if not v109 then
											continue
										end
										local v110 = v109:FindFirstChild(v85[73])
										if not v110 then
											continue
										end
										local textLabel = v110:FindFirstChild("TextLabel")

										if textLabel and textLabel:IsA("TextLabel") then
											local v111 = v96(textLabel.Text or "")
											if v111:find(displayName, 1, true) and v111:find("'s Base", 1, true) then
												return child
											end
										end
									end

									return nil
								end

								local function fn53(arg)
									if not arg then
										return nil
									end
									local huge = v89.huge
									local huge2 = v89.huge
									local huge3 = v89.huge
									local n34 = -v89.huge
									local n35 = -v89.huge
									local n36 = -v89.huge
									local flag23 = false

									for _, descendant in v92(arg:GetDescendants()) do
										if descendant:IsA("BasePart") then
											local position = descendant.Position
											local n37 = descendant.Size / v85[198]

											if position.X - n37.X < huge then
												huge = position.X - n37.X
											end

											if position.Y - n37.Y < huge2 then
												huge2 = position.Y - n37.Y
											end

											if position.Z - n37.Z < huge3 then
												huge3 = position.Z - n37.Z
											end

											if n34 < position.X + n37.X then
												n34 = position.X + n37.X
											end

											if n35 < position.Y + n37.Y then
												n35 = position.Y + n37.Y
											end

											flag23 = true

											if n36 < position.Z + n37.Z then
												n36 = position.Z + n37.Z
											end
										end
									end

									if not flag23 then
										return nil
									end
									return { minX = huge, maxX = n34, minY = huge2, maxY = n35, minZ = huge3, maxZ = n36 }
								end

								local function fn54()
									v106 = fn52()
									v107 = fn53(v106)
								end

								local function fn55(arg)
									local BillboardGui = v102.new("BillboardGui")
									BillboardGui.Name = "BrainrotESP_" .. v96(arg.uid)
									BillboardGui.Size = v101.new(0, 128, 0, 56)
									BillboardGui.StudsOffset = v98.new(0, 1, 0)
									BillboardGui.AlwaysOnTop = true
									BillboardGui.LightInfluence = 0
									BillboardGui.MaxDistance = 2500
									BillboardGui.ResetOnSpawn = false
									local Frame3 = v102.new("Frame", BillboardGui)
									Frame3.Name = "Container"
									Frame3.Size = v101.new(v85[48], 0, v85[48], v85[117])
									Frame3.BackgroundColor3 = v100.fromRGB(v85[142], 12, v85[142])
									Frame3.BackgroundTransparency = 0.45
									Frame3.BorderSizePixel = 0
									v102.new("UICorner", Frame3).CornerRadius = UDim.new(0, v85[147])
									local UIStroke = v102.new("UIStroke", Frame3)
									UIStroke.Name = "Stroke"
									UIStroke.Thickness = 1.2
									UIStroke.Color = v100.fromRGB(60, v85[54], 60)
									local TextLabel3 = v102.new("TextLabel", Frame3)
									TextLabel3.Name = "Tag"
									TextLabel3.Size = v101.new(v85[48], -v85[147], 0, 10)
									TextLabel3.Position = v101.new(v85[117], v85[62], 0, 2)
									TextLabel3.BackgroundTransparency = 1
									TextLabel3.Font = v103.Font.GothamBold
									TextLabel3.TextSize = 10
									TextLabel3.TextXAlignment = v103.TextXAlignment.Left
									TextLabel3.TextColor3 = v100.fromRGB(60, 60, 60)
									TextLabel3.Text = ""
									local TextLabel4 = v102.new("TextLabel", Frame3)
									TextLabel4.Name = "Name"
									TextLabel4.Size = v101.new(1, -6, 0, 12)
									TextLabel4.Position = v101.new(v85[117], 3, 0, 10)
									TextLabel4.BackgroundTransparency = 1
									TextLabel4.Font = v103.Font.GothamBold
									TextLabel4.TextSize = v85[162]
									TextLabel4.TextWrapped = v85[8]
									TextLabel4.TextYAlignment = v103.TextYAlignment.Top
									TextLabel4.TextXAlignment = v103.TextXAlignment.Left
									TextLabel4.TextTruncate = v103.TextTruncate.None
									TextLabel4.TextColor3 = v100.fromRGB(255, 255, 255)
									TextLabel4.Text = v96(arg.name or arg.petName or "Brainrot")
									local TextLabel5 = v102.new("TextLabel", Frame3)
									TextLabel5.Name = "Gen"
									TextLabel5.Size = v101.new(1, -6, v85[117], 14)
									TextLabel5.Position = v101.new(v85[117], 3, 0, 25)
									TextLabel5.BackgroundTransparency = 1
									TextLabel5.Font = v103.Font.ArialBold
									TextLabel5.TextSize = v85[155]
									TextLabel5.TextXAlignment = v103.TextXAlignment.Left
									TextLabel5.TextTruncate = v103.TextTruncate.AtEnd
									TextLabel5.TextColor3 = v100.fromRGB(v85[117], 255, 120)
									TextLabel5.TextStrokeTransparency = 0.82
									TextLabel5.TextStrokeColor3 = v100.fromRGB(v85[117], v85[117], 0)
									TextLabel5.Text = v96(arg.genText or "")
									local v108 = v102.new(v85[66], Frame3)
									v108.Name = "Info"
									v108.Size = v101.new(v85[48], -6, v85[117], 10)
									v108.Position = v101.new(v85[117], 3, 1, -12)
									v108.BackgroundTransparency = v85[48]
									v108.Font = v103.Font.Gotham
									v108.TextSize = 9
									v108.TextXAlignment = v103.TextXAlignment.Right
									v108.TextColor3 = v100.fromRGB(v85[87], 210, 210)
									v108.Text = ""
									return BillboardGui
								end

								local function fn56(arg, arg2, arg3)
									if not arg or not arg.Parent then
										return
									end
									local container = arg:FindFirstChild("Container")
									if not container then
										return
									end
									local stroke = container:FindFirstChild("Stroke")
									local tag = container:FindFirstChild("Tag")
									local name = container:FindFirstChild("Name")
									local gen = container:FindFirstChild("Gen")
									local info = container:FindFirstChild("Info")
									local mutation = arg2.mutation
									local visible = mutation and mutation ~= "" and mutation ~= "None" and mutation ~= "N/A"
									local v108 = fn49(mutation)

									if stroke then
										stroke.Color = visible and v108 or v100.fromRGB(60, v85[54], 60)
									end

									if tag then
										tag.Visible = visible
										tag.Text = visible and v90.upper(v96(mutation)) or ""
										tag.TextColor3 = v108
									end

									if name then
										name.Text = v96(arg2.name or arg2.petName or "Brainrot")
										name.TextWrapped = true
										name.TextTruncate = v103.TextTruncate.None
										name.TextYAlignment = v103.TextYAlignment.Top
										name.Position = visible and v101.new(0, v85[62], v85[117], 12) or v101.new(0, 3, 0, 8)
										name.Size = v101.new(1, -v85[147], 0, 24)
									end

									if gen then
										gen.Text = v96(arg2.genText or "")
										gen.Position = visible and v101.new(0, 3, 0, 39) or v101.new(0, 3, 0, 36)
									end

									if info then
										if arg3 and arg2.adornee and arg2.adornee.Parent then
											info.Text = v96(v89.floor((arg3.Position - arg2.adornee.Position).Magnitude)) .. " studs"
										else
											info.Text = ""
										end
									end

									arg.Adornee = arg2.adornee
								end

								local function fn57()
									for k, v108 in v93(tbl29) do
										if v108.bb then
											v94(function()
												v108.bb:Destroy()
											end)
										end

										tbl29[k] = nil
									end

									for _, descendant in v92(Workspace:GetDescendants()) do
										if descendant:IsA("BillboardGui") and v90.sub(descendant.Name, 1, 12) == "BrainrotESP_" then
											v94(function()
												descendant:Destroy()
											end)
										end
									end
								end

								local tbl32 = {
									STOLEN = v85[8],
									STEAL = true,
									PURCHASE = true,
									COMPRAR = v85[8],
									BUY = true,
									COLLECT = true,
									COLETAR = true,
									CASH = true,
									VALUE = true,
									BASE = v85[8],
									EMPTY = v85[8],
									GENERATION = v85[8],
									COMMON = v85[8],
									UNCOMMON = true,
									RARE = true,
									EPIC = true,
									LEGENDARY = true,
									DIVINE = true,
									RAINBOW = true,
									CURSED = v85[8],
									GOLD = true,
									DIAMOND = true,
									CANDY = true,
									MUTATION = v85[8],
								}

								local function fn58(arg)
									if not arg or arg == "" then
										return false
									end
									local match = arg:gsub("<[^>]+>", ""):match("^%s*(.-)%s*$") or ""
									if #match <= v85[48] then
										return false
									end
									local str9 = match:upper()
									if str9:find("^%$") or str9:find("/S$") or str9:find("^[%d%.]+") then
										return v85[112]
									end
									return not tbl32[str9]
								end

								local function fn59(arg)
									if v95(arg) ~= "string" then
										return nil
									end
									local str9 = arg:gsub("<[^>]+>", ""):upper()
									if not str9:find("%$") or not str9:find("/S") then
										return nil
									end
									local str10 = str9:gsub("%$", ""):gsub("/S", ""):gsub("%s+", "")
									local v108 = v97(str10:match("[%d%.]+"))
									if not v108 then
										return nil
									end

									if str10:find("B") then
										return v108 * 1e9
									end

									if str10:find("M") then
										return v108 * 1000000
									end

									if str10:find("K") then
										return v108 * 1000
									end
									return v108
								end

								local function fn60(arg)
									if not arg then
										return nil, nil, 0
									end
									local v108 = v85[117]
									local str9 = nil
									local v109 = nil

									for _, descendant in v92(arg:GetDescendants()) do
										if descendant:IsA("BillboardGui") or descendant:IsA(v85[185]) then
											for _, descendant2 in v92(descendant:GetDescendants()) do
												if descendant2:IsA(v85[66]) and descendant2.Text then
													local v110 = fn59(descendant2.Text)

													if v110 and v110 > v108 then
														str9 = descendant2.Text:gsub("<[^>]+>", "")
														local parent = descendant2.Parent

														if parent then
															local match = nil

															for _, child in v92(parent:GetChildren()) do
																if child:IsA("TextLabel") and child.Name == "DisplayName" then
																	match = (child.Text or ""):gsub("<[^>]+>", ""):match("^%s*(.-)%s*$")
																	if not fn58(match) then
																		match = nil
																		continue
																	end
																else
																	match = nil
																	continue
																end

																break
															end

															local v111

															if not match then
																local n34 = v85[117]
																local v112 = nil

																for _, child in v92(parent:GetChildren()) do
																	if child:IsA("TextLabel") then
																		local match2 = (child.Text or ""):gsub("<[^>]+>", ""):match("^%s*(.-)%s*$") or ""

																		if fn58(match2) and #match2 > n34 then
																			n34 = #match2
																			v112 = match2
																		end
																	end
																end

																v111 = v112 or match
															else
																v111 = match
															end

															if v111 then
																v108 = v110
																v109 = v111
															else
																v108 = v110
															end
														else
															v108 = v110
														end
													end
												end
											end
										end
									end

									return v109, str9, v108
								end

								local function fn61()
									local tbl33 = {}
									local debris = Workspace:FindFirstChild("Debris") or Workspace

									for _, child in v92(debris:GetChildren()) do
										if child:IsA(v85[11]) or child:IsA(v85[9]) then
											local v108, v109, v110 = fn60(child)

											if v110 and v110 >= 10000000 then
												local isBasePart = child:IsA("BasePart") and child or child:IsA("Model") and child.PrimaryPart

												if not isBasePart and child:IsA(v85[11]) then
													for _, child2 in v92(child:GetChildren()) do
														if child2:IsA(v85[9]) then
															isBasePart = child2
															break
														end
													end
												end

												if isBasePart then
													v91.insert(tbl33, { name = v108, gen = v109, gv = v110, part = isBasePart, model = child })
												end
											end
										end
									end

									return tbl33
								end

								local function fn62()
									local v108 = fn61()
									local tbl33 = {}
									local tbl34 = {}

									for _, descendant in v92(Workspace:GetDescendants()) do
										if descendant:IsA("ProximityPrompt") and descendant.Enabled then
											local v109 = v90.lower(v96(descendant.ActionText or ""))

											if v109:find("purchase", 1, v85[8]) or v109:find("comprar", 1, true) or v109:find("buy", 1, true) then
												local parent = descendant.Parent

												if parent and parent:IsA("Attachment") then
													parent = parent.Parent
												end

												if parent and parent:IsA("BasePart") then
													local n34 = 15
													local v110 = nil

													for _, v111 in v92(v108) do
														if v111.part and v111.part.Parent then
															local magnitude = (v111.part.Position - parent.Position).Magnitude

															if magnitude < n34 then
																n34 = magnitude
																v110 = v111
															end
														end
													end

													local name, gen, gv

													if v110 then
														name = v110.name or "Brainrot"
														gen = v110.gen or ""
														gv = v110.gv or 0
													else
														local parent2 = parent
														local v111 = parent

														while parent2 and parent2.Parent and parent2.Parent ~= Workspace do
															v111 = parent2
															parent2 = parent2.Parent
														end

														local v112, v113, v114 = fn60(v111)
														local flag23 = v114 and v114 >= 10000000
														name = "Brainrot"
														gen = ""
														gv = 0

														if flag23 then
															name = v112 or name

															if v113 then
																gen = v113
																gv = v114
															else
																gv = v114
															end
														end
													end

													if gv >= 10000000 then
														local str9 = "conv_" .. (fn48(parent) or v96(descendant))

														if not tbl34[str9] then
															tbl34[str9] = true

															v91.insert(tbl33, {
																uid = str9,
																kind = "CONVEYOR",
																name = name,
																petName = name,
																genText = gen,
																genValue = gv,
																mutation = "None",
																adornee = parent,
															})
														end
													end
												end
											end
										end
									end

									v91.sort(tbl33, function(arg, arg2)
										return (v97(arg.genValue) or v85[117]) > (v97(arg2.genValue) or 0)
									end)

									local tbl35 = {}

									for i = 1, v89.min(v85[62], #tbl33) do
										tbl35[i] = tbl33[i]
									end

									return tbl35
								end

								local function fn63(...) end
								local function fn64(...) end

								local function fn65()
									if not brainrotESP then
										return
									end
									local tbl33 = {}
									local v108 = fn63()

									for i = 1, #v108 do
										tbl33[#tbl33 + 1] = v108[i]
									end

									for i = 1, #tbl30 do
										tbl33[#tbl33 + v85[48]] = tbl30[i]
									end

									v91.sort(tbl33, function(arg, arg2)
										return (v97(arg.genValue) or 0) > (v97(arg2.genValue) or 0)
									end)

									fn64(tbl33)
								end

								local brainrotEsp = fn44(v, "Brainrot ESP", v85[198])
								fn46(brainrotEsp, brainrotESP)

								if brainrotESP then
									v88.spawn(function()
										v88.wait(0.5)
										fn54()

										v94(function()
											tbl30 = fn62()
										end)

										v94(fn65)
									end)
								end

								brainrotEsp.button.MouseButton1Click:Connect(function()
									brainrotESP = not brainrotESP
									fn46(brainrotEsp, brainrotESP)

									if brainrotESP then
										v88.spawn(function()
											fn54()

											v94(function()
												tbl30 = fn62()
											end)

											v94(fn65)
										end)

										if n25 >= 6415 then
											while true do
											end
										end
									else
										fn57()
									end

									tbl19.brainrotESP = brainrotESP
									fn30()
								end)

								v88.spawn(function()
									while true do
										fn54()
										v88.wait(v85[198])
									end
								end)

								v88.spawn(function()
									while true do
										v88.wait(v85[95])

										if brainrotESP then
											v94(function()
												tbl30 = fn62()
											end)
										end
									end
								end)

								v88.spawn(function()
									while v85[8] do
										v88.wait(0.2)

										if brainrotESP then
											v94(fn65)
										end
									end
								end)

								v88.spawn(function()
									while true do
										v88.wait(2)

										if brainrotESP and next(tbl29) == nil then
											v94(function()
												tbl30 = fn62()
											end)

											v94(fn65)
										end
									end
								end)
							end)

							v88.spawn(function()
								local currentCamera = Workspace.CurrentCamera
								local xxSlicedzStatusHUDxX = v104:FindFirstChild("XxSlicedzStatusHUDxX")

								if xxSlicedzStatusHUDxX then
									xxSlicedzStatusHUDxX:Destroy()
								end

								local ScreenGui = v102.new("ScreenGui")
								ScreenGui.Name = "XxSlicedzStatusHUDxX"
								ScreenGui.ResetOnSpawn = v85[112]
								ScreenGui.IgnoreGuiInset = true
								ScreenGui.ZIndexBehavior = v103.ZIndexBehavior.Sibling
								ScreenGui.Parent = gethui()

								local function fn47(arg, arg2)
									local v106 = v102.new(arg)
									local tbl29 = arg2 or {}

									for k, v107 in v93(tbl29) do
										v106[k] = v107
									end

									return v106
								end

								local v106 = fn47(v85[73], {
									Name = "Outer",
									AnchorPoint = Vector2.new(0.5, 1),
									Size = v101.new(0, 470, 0, 44),
									Position = v101.new(0.5, 0, 1, str8 == "phone" and -64 or str8 == "tablet" and -78 or -86),
									BackgroundColor3 = v100.fromRGB(v85[96], 16, 20),
									BorderSizePixel = 0,
									Parent = ScreenGui,
								})

								local UIScale = v102.new("UIScale")
								UIScale.Name = "ResponsiveScale"
								UIScale.Parent = v106

								local function fn48()
									local viewportSize = currentCamera and currentCamera.ViewportSize or Vector2.new(1920, 1080)
									local v107 = v89.min(viewportSize.X / 1920, viewportSize.Y / 1080)
									local n33 = str8 == "phone" and 0.55
									local flag23

									if n33 then
										flag23 = n33
									else
										flag23 = str8 == v85[56] and v85[52]
									end

									UIScale.Scale = v89.clamp(v107, flag23 or v85[52], 1)
								end

								fn48()

								if currentCamera then
									currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn48)
								end

								fn47("UICorner", { CornerRadius = UDim.new(0, 11), Parent = v106 })

								fn47("UIStroke", {
									Color = v100.fromRGB(160, 40, 40),
									Thickness = 1,
									Transparency = v85[164],
									ApplyStrokeMode = v103.ApplyStrokeMode.Border,
									Parent = v106,
								})

								local UIGradient = v102.new("UIGradient")
								UIGradient.Rotation = v85[117]
								local colorSequence = ColorSequence.new
								local tbl29 = {}
								local v107 = ColorSequenceKeypoint.new(0, v100.fromRGB(v85[76], 24, 30))
								local v108 = ColorSequenceKeypoint.new(0.35, v100.fromRGB(17, v85[74], 23))
								local v109 = ColorSequenceKeypoint.new(0.72, v100.fromRGB(13, 14, 18))
								local new = ColorSequenceKeypoint.new
								local v110 = v85[48]
								local fromRGB = v100.fromRGB
								local v111 = v85[157]
								tbl29[1] = v107
								tbl29[2] = v108
								tbl29[3] = v109

								do
									local values = table.pack(new(v110, fromRGB(18, 19, v111)))
									table.move(values, 1, values.n, 4, tbl29)
								end

								UIGradient.Color = colorSequence(tbl29)
								UIGradient.Parent = v106

								fn47(v85[73], {
									Name = "Sheen",
									Position = v101.new(0, 10, v85[117], 3),
									Size = v101.new(1, -20, 0, v85[48]),
									BackgroundColor3 = v100.fromRGB(255, 255, 255),
									BackgroundTransparency = 0.95,
									BorderSizePixel = 0,
									ZIndex = 3,
									Parent = v106,
								})

								local Frame3 = fn47("Frame", {
									Name = "Dot",
									AnchorPoint = Vector2.new(v85[65], v85[65]),
									Position = v101.new(0, 18, 0.5, 0),
									Size = v101.new(0, 8, 0, 8),
									BackgroundColor3 = v100.fromRGB(v85[127], v85[133], 50),
									BorderSizePixel = v85[117],
									ZIndex = v85[198],
									Parent = v106,
								})

								fn47(v85[138], { CornerRadius = UDim.new(1, 0), Parent = Frame3 })

								fn47("UIStroke", {
									Color = v100.fromRGB(v85[183], 80, 80),
									Thickness = 1,
									Transparency = 0.35,
									ApplyStrokeMode = v103.ApplyStrokeMode.Border,
									Parent = Frame3,
								})

								local TextLabel3 = fn47("TextLabel", {
									Name = "Title",
									BackgroundTransparency = 1,
									Position = v101.new(0, v85[115], v85[117], v85[117]),
									Size = v101.new(0, v85[32], v85[48], 0),
									Font = v103.Font.GothamBold,
									Text = "SLICEDZ HUB",
									TextSize = 15,
									TextColor3 = v100.fromRGB(245, 246, 248),
									TextXAlignment = v103.TextXAlignment.Left,
									TextYAlignment = v103.TextYAlignment.Center,
									ZIndex = 2,
									Parent = v106,
								})

								TextLabel3.AutoLocalize = false
								TextLabel3.TextStrokeTransparency = 0.92

								local TextLabel4 = fn47("TextLabel", {
									Name = "Invite",
									BackgroundTransparency = 1,
									Position = v101.new(0, v85[156], 0, v85[117]),
									Size = v101.new(0, 175, 1, 0),
									Font = v103.Font.GothamBlack,
									Text = "discord.gg/pubmethod",
									TextSize = 15,
									TextColor3 = v100.fromRGB(255, 255, 255),
									TextXAlignment = v103.TextXAlignment.Center,
									TextYAlignment = v103.TextYAlignment.Center,
									ZIndex = v85[198],
									Parent = v106,
								})

								TextLabel4.AutoLocalize = false
								TextLabel4.TextStrokeColor3 = v100.fromRGB(60, v85[36], 10)
								TextLabel4.TextStrokeTransparency = 0.4
								local UIGradient2 = v102.new("UIGradient")
								UIGradient2.Rotation = v85[117]
								local colorSequence2 = ColorSequence.new
								local tbl30 = {}
								local v112 = ColorSequenceKeypoint.new(0, v100.fromRGB(200, 30, 40))
								local v113 = ColorSequenceKeypoint.new(0.35, v100.fromRGB(255, v85[21], 100))
								local v114 = ColorSequenceKeypoint.new(0.5, v100.fromRGB(255, 255, v85[63]))
								local v115 = ColorSequenceKeypoint.new(0.65, v100.fromRGB(255, v85[21], 100))
								local new2 = ColorSequenceKeypoint.new
								local fromRGB2 = v100.fromRGB
								local v116 = v85[127]
								tbl30[1] = v112
								tbl30[2] = v113
								tbl30[3] = v114
								tbl30[4] = v115

								do
									local values = table.pack(new2(1, fromRGB2(v116, 30, 40)))
									table.move(values, 1, values.n, 5, tbl30)
								end

								UIGradient2.Color = colorSequence2(tbl30)
								UIGradient2.Parent = TextLabel4

								v88.spawn(function()
									local now2 = tick()

									while TextLabel4 and TextLabel4.Parent do
										UIGradient2.Offset = Vector2.new((tick() - now2) * 0.35 % 2 - 1, 0)
										v88.wait()
									end
								end)

								local function fn49(arg)
									fn47("Frame", {
										Position = v101.new(v85[117], arg, 0.5, -10),
										Size = v101.new(0, 1, 0, v85[129]),
										BackgroundColor3 = v100.fromRGB(160, 40, 40),
										BackgroundTransparency = v85[175],
										BorderSizePixel = v85[117],
										ZIndex = 2,
										Parent = v106,
									})
								end

								fn49(310)
								fn49(382)

								fn47("TextLabel", {
									BackgroundTransparency = v85[48],
									Position = v101.new(0, 324, 0, 6),
									Size = v101.new(v85[117], 42, 0, v85[36]),
									Font = v103.Font.GothamBold,
									Text = "FPS",
									TextSize = 9,
									TextColor3 = v100.fromRGB(180, 80, 80),
									TextXAlignment = v103.TextXAlignment.Left,
									TextYAlignment = v103.TextYAlignment.Center,
									ZIndex = 2,
									Parent = v106,
								}).AutoLocalize = v85[112]

								fn47("TextLabel", {
									BackgroundTransparency = v85[48],
									Position = v101.new(0, 324, 0, 17),
									Size = v101.new(v85[117], 46, v85[117], v85[155]),
									Font = v103.Font.GothamBold,
									Text = "0",
									TextSize = 14,
									TextColor3 = v100.fromRGB(220, 80, 80),
									TextXAlignment = v103.TextXAlignment.Left,
									TextYAlignment = v103.TextYAlignment.Center,
									ZIndex = 2,
									Parent = v106,
								}).AutoLocalize = false

								fn47("TextLabel", {
									BackgroundTransparency = v85[48],
									Position = v101.new(0, 396, v85[117], v85[147]),
									Size = v101.new(0, 50, 0, 10),
									Font = v103.Font.GothamBold,
									Text = "PING",
									TextSize = 9,
									TextColor3 = v100.fromRGB(180, 80, 80),
									TextXAlignment = v103.TextXAlignment.Left,
									TextYAlignment = v103.TextYAlignment.Center,
									ZIndex = v85[198],
									Parent = v106,
								}).AutoLocalize = false

								local v117 = fn47(v85[66], {
									BackgroundTransparency = 1,
									Position = v101.new(0, 396, 0, 17),
									Size = v101.new(0, 60, v85[117], 16),
									Font = v103.Font.GothamBold,
									Text = "0ms",
									TextSize = 14,
									TextColor3 = v100.fromRGB(220, 80, 80),
									TextXAlignment = v103.TextXAlignment.Left,
									TextYAlignment = v103.TextYAlignment.Center,
									ZIndex = 2,
									Parent = v106,
								})

								v117.AutoLocalize = false
								tick()
								service2.Heartbeat:Connect(function(...) end)

								v88.spawn(function()
									while v106 and v106.Parent do
										local v118 = v89.floor(localPlayer:GetNetworkPing() * 1000)
										v117.Text = v96(v118) .. "ms"

										if v118 < 80 then
											v117.TextColor3 = v100.fromRGB(56, 214, 110)
										elseif v118 < v85[64] then
											v117.TextColor3 = v100.fromRGB(255, 165, 0)
										else
											v117.TextColor3 = v100.fromRGB(v85[183], 60, 60)
										end

										v88.wait(v85[44])
									end
								end)
							end)

							do
								local v106 = nil

								local function fn47()
									_G.InvisStealAngle = tbl21.angle
									_G.SinkSliderValue = tbl21.depth
									_G.MynxxWSValue = tbl21.ws
									_G.MynxxWSEnabled = tbl19.walkSpeed
									_G.AutoInvisDuringSteal = tbl19.autoInvis
									_G.AutoRecoverLagback = tbl19.autoRecover
									_G.invisibleStealEnabled = v85[112]

									local function fn48()
										tbl21.angle = _G.InvisStealAngle
										tbl21.depth = _G.SinkSliderValue
										tbl21.ws = _G.MynxxWSValue
										tbl19.walkSpeed = _G.MynxxWSEnabled
										tbl19.autoInvis = _G.AutoInvisDuringSteal
										tbl19.autoRecover = _G.AutoRecoverLagback
										fn30()
									end

									local flag23 = false
									local tbl29 = {}
									local tbl30 = {}
									local tbl31 = {}
									local n33 = 0
									local n34 = 0
									local n35 = 0
									local flag24 = v85[112]
									local v107 = nil
									local v108 = nil
									local humanoidRootPart = nil
									local clone = nil
									local hipHeight = nil
									local connection = nil
									local fn49 = nil

									local function fn50()
										if v107 and v107.Parent then
											v107:Destroy()
										end

										v107 = nil
										flag24 = false

										if v108 then
											v108:Disconnect()
											v108 = nil
										end
									end

									local function fn51()
										if flag24 then
											return
										end
										flag24 = v85[8]

										for _, v109 in v93(tbl31) do
											if v109 and v109.Parent then
												v109:Destroy()
											end
										end

										tbl31 = {}
									end

									local function fn52()
										for _, v109 in v93(tbl31) do
											v94(function()
												if v109 and v109.Parent then
													v109:Destroy()
												end
											end)
										end

										tbl31 = {}
										fn50()
										n33 = 0
										n35 = 0

										v94(function()
											if v86.CurrentCamera then
												for _, child in v93(v86.CurrentCamera:GetChildren()) do
													if child.Name == "LagbackGhost" then
														child:Destroy()
													end
												end
											end
										end)
									end

									local function fn53(arg)
										if flag24 then
											return
										end
										local now2 = tick()
										if now2 - n35 < 0.05 then
											return
										end
										n35 = now2

										if now2 - n34 > 1 then
											n33 = 0
											n34 = now2
										end

										n33 += 1

										if v85[92] <= n33 then
											if n27(57) >= 2289 then
												fn51()
												return
											end

											while v85[8] do
											end
										end

										for _, v109 in v93(tbl31) do
											if v109 and v109.Parent then
												v109:Destroy()
											end
										end

										tbl31 = {}
										local Part = v102.new("Part")
										Part.Name = "LagbackGhost"
										Part.Shape = v103.PartType.Ball
										Part.Size = v98.new(v85[62], 3, v85[62])
										Part.Color = v100.fromRGB(v85[63], 0, 0)
										Part.Material = v103.Material.Glass
										Part.Transparency = 0.3
										Part.CanCollide = false
										Part.Anchored = v85[8]
										Part.CastShadow = false
										Part.Position = arg + v98.new(0, 5, 0)
										Part.Parent = v86.CurrentCamera
										tbl31[#tbl31 + 1] = Part
									end

									local tbl32 = { enabled = false, conn = nil }

									local function setWalkSpeedEnabled(enabled)
										tbl32.enabled = enabled

										if tbl32.conn then
											tbl32.conn:Disconnect()
											tbl32.conn = nil
										end

										if fn49 then
											fn49()
										end

										if not enabled then
											return
										end

										tbl32.conn = service2.Heartbeat:Connect(function(deltaTime)
											if _G.FlingActive then
												return
											end

											if not localPlayer:GetAttribute("Stealing") then
												return
											end
											local character = localPlayer.Character
											local humanoid = character and character:FindFirstChildOfClass("Humanoid")
											character = character and character:FindFirstChild("HumanoidRootPart")
											if not humanoid or not character or humanoid.Health <= 0 then
												return
											end
											local n36 = v97(_G.MynxxWSValue) or 28

											if humanoid.MoveDirection.Magnitude > 0 and n36 > humanoid.WalkSpeed then
												character.CFrame = character.CFrame + humanoid.MoveDirection * (n36 - humanoid.WalkSpeed) * deltaTime
											end
										end)
									end

									_G.setWalkSpeedEnabled = setWalkSpeedEnabled

									local function setWalkSpeedValue(arg)
										local v109 = v89.clamp(v89.floor((v97(arg) or 28) + v85[65]), 15, 35)
										_G.MynxxWSValue = v109
										return v109
									end

									_G.setWalkSpeedValue = setWalkSpeedValue
									setWalkSpeedValue(_G.MynxxWSValue)

									local function fn54()
										local v109 = v86:FindFirstChild(localPlayer.Name)
										if not v109 then
											return
										end
										local doubleRig = v109:FindFirstChild("DoubleRig")

										if doubleRig then
											local humanoidRootPart2 = doubleRig:FindFirstChild("HumanoidRootPart") or doubleRig:FindFirstChildWhichIsA(v85[9])

											if humanoidRootPart2 then
												fn53(humanoidRootPart2.Position)
											end

											doubleRig:Destroy()
										end

										local constraints = v109:FindFirstChild("Constraints")

										if constraints then
											constraints:Destroy()
										end

										tbl30[#tbl30 + v85[48]] = v109.ChildAdded:Connect(function(child)
											if child.Name == "DoubleRig" then
												v88.defer(function()
													if not child or not child.Parent then
														return
													end
													local v110 = child:FindFirstChild(v85[171]) or child:FindFirstChildWhichIsA(v85[9])

													if v110 then
														fn53(v110.Position)
													end

													child:Destroy()
												end)
											elseif child.Name == "Constraints" then
												child:Destroy()
											end
										end)
									end

									if not _G._xenFixRig then
										local flag25 = false

										local tbl33 = {
											{ "Root", v85[171], "LowerTorso" },
											{ "Waist", "LowerTorso", "UpperTorso" },
											{ "Neck", "UpperTorso", "Head" },
											{ "LeftShoulder", "UpperTorso", "LeftUpperArm" },
											{ "LeftElbow", "LeftUpperArm", "LeftLowerArm" },
											{ "LeftWrist", "LeftLowerArm", "LeftHand" },
											{ "RightShoulder", "UpperTorso", "RightUpperArm" },
											{ "RightElbow", "RightUpperArm", "RightLowerArm" },
											{ "RightWrist", "RightLowerArm", "RightHand" },
											{ "LeftHip", "LowerTorso", "LeftUpperLeg" },
											{ "LeftKnee", "LeftUpperLeg", "LeftLowerLeg" },
											{ "LeftAnkle", "LeftLowerLeg", "LeftFoot" },
											{ "RightHip", "LowerTorso", "RightUpperLeg" },
											{ "RightKnee", "RightUpperLeg", "RightLowerLeg" },
											{ "RightAnkle", "RightLowerLeg", "RightFoot" },
										}

										local function fn55()
											local character = localPlayer.Character
											if not character then
												return
											end
											local humanoid = character:FindFirstChildOfClass("Humanoid")
											if not humanoid or humanoid.RigType ~= v103.HumanoidRigType.R15 or humanoid.Health <= v85[117] then
												return
											end

											for _, v109 in v92(tbl33) do
												local v110 = character:FindFirstChild(v109[v85[198]])
												local v111 = character:FindFirstChild(v109[3])

												if v110 and v111 then
													local flag26 = false

													for _, child in v92(v111:GetChildren()) do
														if child:IsA("Motor6D") and child.Name == v109[1] then
															flag26 = true
															break
														end
													end

													if not flag26 then
														local v112 = v110:FindFirstChild(v109[1] .. "RigAttachment")
														local v113 = v111:FindFirstChild(v109[1] .. "RigAttachment")

														if v112 and v113 then
															for _, child in v92(v111:GetChildren()) do
																if child:IsA("AnimationConstraint") and child.Name == v109[1] then
																	v94(function()
																		child.Enabled = false
																	end)
																end
															end

															v94(function()
																local Motor6D = v102.new("Motor6D")
																local v114 = v110
																local v115 = v111
																local cFrame = v112.CFrame
																local cFrame2 = v113.CFrame
																Motor6D.Name = v109[1]
																Motor6D.Part0 = v114
																Motor6D.Part1 = v115
																Motor6D.C0 = cFrame
																Motor6D.C1 = cFrame2
																Motor6D.Parent = v111
															end)
														end
													end
												end
											end
										end

										_G._xenFixRig = function()
											if flag25 then
												return false
											end
											flag25 = v85[8]
											local v109 = v94(fn55)
											flag25 = false
											return v109
										end
									end

									local function fn55()
										local character = localPlayer.Character
										local humanoid = character and character:FindFirstChildOfClass("Humanoid")
										if not humanoid or humanoid.Health <= v85[117] then
											return false
										end
										hipHeight = humanoid.HipHeight
										humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
										if not humanoidRootPart or not humanoidRootPart.Parent then
											return false
										end

										for _, child in v93(humanoidRootPart:GetChildren()) do
											if child:IsA(v85[160]) and (child.Name:find("Beam") or child.Name:find("Attach")) then
												child:Destroy()
											end
										end

										for _, child in v93(humanoidRootPart:GetChildren()) do
											if child:IsA("Beam") then
												child:Destroy()
											end
										end

										local Model = v102.new("Model")
										Model.Parent = v87
										character.Parent = Model
										clone = humanoidRootPart:Clone()
										clone.Parent = character
										humanoidRootPart.Parent = v86.CurrentCamera
										clone.CFrame = humanoidRootPart.CFrame
										character.PrimaryPart = clone
										character.Parent = v86

										for _, descendant in v93(character:GetDescendants()) do
											if descendant:IsA("Weld") or descendant:IsA("Motor6D") then
												if descendant.Part0 == humanoidRootPart then
													descendant.Part0 = clone
												end

												if descendant.Part1 == humanoidRootPart then
													descendant.Part1 = clone
												end
											end
										end

										Model:Destroy()

										v88.defer(function()
											if _G._xenFixRig then
												_G._xenFixRig()
											end
										end)

										return v85[8]
									end

									local function fn56()
										local character = localPlayer.Character
										local humanoid = character and character:FindFirstChildOfClass("Humanoid")
										if not humanoidRootPart or not humanoidRootPart:IsDescendantOf(v86) or not humanoid or humanoid.Health <= 0 then
											return
										end
										local v109 = v102.new(v85[11])
										v109.Parent = v87
										character.Parent = v109
										humanoidRootPart.Parent = character
										character.PrimaryPart = humanoidRootPart
										character.Parent = v86
										humanoidRootPart.CanCollide = true

										for _, descendant in v93(character:GetDescendants()) do
											if descendant:IsA("Weld") or descendant:IsA("Motor6D") then
												if descendant.Part0 == clone then
													descendant.Part0 = humanoidRootPart
												end

												if descendant.Part1 == clone then
													descendant.Part1 = humanoidRootPart
												end
											end
										end

										v109:Destroy()

										if clone then
											local cFrame = clone.CFrame
											clone:Destroy()
											clone = nil
											humanoidRootPart.CFrame = cFrame
										end

										humanoidRootPart = nil

										if hipHeight then
											humanoid.HipHeight = hipHeight
										end

										v88.defer(function()
											if _G._xenFixRig then
												_G._xenFixRig()
											end
										end)

										fn52()
									end

									local fn57 = nil

									fn57 = function()
										local character = localPlayer.Character
										character = character and character:FindFirstChildOfClass("Humanoid")
										if not character or character.Health <= 0 then
											return
										end
										local Animation = v102.new("Animation")
										Animation.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
										local v109 = (character:FindFirstChildOfClass("Animator") or v102.new("Animator", character)):LoadAnimation(Animation)
										v109.Priority = v103.AnimationPriority.Action4
										v109:Play(0, 1, 0)
										Animation:Destroy()
										tbl29[#tbl29 + 1] = v109

										v109.Stopped:Connect(function()
											if flag23 then
												fn57()
											end
										end)

										v88.defer(function()
											v109.TimePosition = 0.7

											v88.delay(0.3, function()
												v94(function()
													v109:AdjustSpeed(v89.huge)
												end)
											end)
										end)
									end

									local n36 = 0

									local function fn58()
										fn52()
										if not flag23 then
											return
										end
										flag23 = false
										_G.invisibleStealEnabled = false

										for _, v109 in v93(tbl29) do
											v94(function()
												v109:Stop(0)
											end)
										end

										tbl29 = {}

										if connection then
											connection:Disconnect()
											connection = nil
										end

										for _, v109 in v92(tbl30) do
											v94(function()
												v109:Disconnect()
											end)
										end

										tbl30 = {}
										fn56()
										fn52()
										local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

										if humanoid then
											v94(function()
												local animator = humanoid:FindFirstChildOfClass("Animator")

												if animator then
													for _, v109 in v92(animator:GetPlayingAnimationTracks()) do
														if v109.Priority == v103.AnimationPriority.Action4 or v109.Priority == v103.AnimationPriority.Action3 then
															v109:Stop(0)
														end
													end
												end

												humanoid:ChangeState(v103.HumanoidStateType.GettingUp)

												v88.defer(function()
													if humanoid and humanoid.Parent then
														humanoid:ChangeState(v103.HumanoidStateType.Running)
													end
												end)
											end)
										end

										if tbl32.enabled and _G.MynxxWSEnabled then
											setWalkSpeedEnabled(false)
										end

										n36 = tick()

										if fn49 then
											fn49()
										end
									end

									local function fn59()
										if flag23 then
											return
										end
										local character = localPlayer.Character
										if not character or not character:FindFirstChildOfClass(v85[7]) then
											return
										end
										flag23 = true
										_G.invisibleStealEnabled = v85[8]
										tbl29 = {}
										fn54()

										if not fn55() then
											flag23 = v85[112]
											_G.invisibleStealEnabled = false

											if fn49 then
												fn49()
											end

											return
										end

										v88.wait(0.05)
										fn57()

										v88.delay(1, function()
											if _G.invisibleStealEnabled and _G.MynxxWSEnabled and not tbl32.enabled then
												setWalkSpeedEnabled(v85[8])
											end
										end)

										local position = nil
										local n37 = 5

										connection = service2.PreSimulation:Connect(function()
											local character2 = localPlayer.Character
											local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
											if not humanoid or humanoid.Health <= 0 or not humanoidRootPart then
												return
											end
											local primaryPart = character2.PrimaryPart or character2:FindFirstChild(v85[171])
											if not primaryPart then
												return
											end

											if n37 > 0 then
												n37 -= 1
												position = nil
											elseif position then
												local position2 = humanoidRootPart.Position

												if (position2 - position).Magnitude > 6 and not _G.RecoveryInProgress and localPlayer:GetAttribute("Stealing") then
													position = nil
													fn53(position2)

													if _G.AutoRecoverLagback and _G._forceInvisToggle then
														_G.RecoveryInProgress = true

														v88.spawn(function()
															v94(_G._forceInvisToggle)
															v88.wait(0.6)

															if localPlayer:GetAttribute("Stealing") then
																if n28(2088) <= 2885 then
																	v94(_G._forceInvisToggle)
																else
																	while v85[8] do
																	end
																end
															end

															_G.RecoveryInProgress = false
														end)
													end
												end
											end

											if clone then
												clone.CanCollide = v85[8]
											end

											if humanoidRootPart and humanoidRootPart.Parent then
												for _, child in v93(humanoidRootPart:GetChildren()) do
													if child:IsA("Attachment") or child:IsA("Beam") then
														child:Destroy()
													end
												end

												local n38 = (v97(_G.SinkSliderValue) or 8) * 0.5
												local v109 = humanoidRootPart
												local n39 = primaryPart.CFrame - v98.new(0, n38, v85[117])
												local angles = v99.Angles
												local rad = v89.rad
												local n40 = v97(_G.InvisStealAngle) or 180
												local v110 = v85[117]
												v109.CFrame = n39 * angles(rad(n40), 0, v110)
												humanoidRootPart.AssemblyLinearVelocity = primaryPart.AssemblyLinearVelocity
												humanoidRootPart.CanCollide = false
												position = humanoidRootPart.Position
											end
										end)

										if fn49 then
											fn49()
										end
									end

									_G.toggleInvisibleSteal = function()
										if tick() - n36 < 0.3 then
											return
										end

										if flag23 then
											fn58()
										else
											fn59()
										end
									end

									_G._forceInvisToggle = function()
										if flag23 then
											fn58()
										else
											fn59()
										end
									end

									local function fn60()
										local character = localPlayer.Character
										character = character and character:FindFirstChildOfClass("Humanoid")

										if character then
											character.Died:Connect(function()
												fn50()
												fn52()
												n33 = 0
											end)
										end
									end

									fn60()

									localPlayer.CharacterAdded:Connect(function(character)
										v88.wait(0.1)
										fn50()
										fn52()
										n33 = 0

										v94(function()
											for _, child in v93(v86.CurrentCamera:GetChildren()) do
												if child:IsA(v85[9]) and child.Name == "HumanoidRootPart" then
													child:Destroy()
												end
											end
										end)

										if humanoidRootPart then
											v94(function()
												humanoidRootPart:Destroy()
											end)

											humanoidRootPart = nil
										end

										if clone then
											v94(function()
												clone:Destroy()
											end)

											clone = nil
										end

										flag23 = false
										_G.invisibleStealEnabled = false

										if connection then
											connection:Disconnect()
											connection = nil
										end

										fn60()

										if fn49 then
											fn49()
										end

										v88.wait(0.2)
										local currentCamera = v86.CurrentCamera
										character = character and character:FindFirstChildOfClass("Humanoid")

										if currentCamera and character then
											currentCamera.CameraSubject = character
											currentCamera.CameraType = v103.CameraType.Custom
										end
									end)

									v88.spawn(function()
										local flag25 = false
										v88.wait(1)
										local flag26 = false

										while v88.wait(0.15) do
											if not _G.AutoInvisDuringSteal then
												flag25 = false
												flag26 = false
											else
												local attribute = localPlayer:GetAttribute("Stealing")

												if attribute and not flag26 and not _G.invisibleStealEnabled then
													v88.spawn(function()
														v88.wait(0.5)

														if localPlayer:GetAttribute("Stealing") and not _G.invisibleStealEnabled then
															v94(_G._forceInvisToggle)
															flag25 = true
														end
													end)
												end

												if not attribute and flag25 and _G.invisibleStealEnabled then
													v88.wait(0.3)

													if not localPlayer:GetAttribute("Stealing") then
														v94(_G._forceInvisToggle)
														flag25 = false
													end
												end

												flag26 = attribute
											end
										end
									end)

									local ScreenGui = v102.new("ScreenGui")
									ScreenGui.Name = "Invis_SA"
									ScreenGui.ResetOnSpawn = false
									ScreenGui.IgnoreGuiInset = true
									ScreenGui.DisplayOrder = 999
									ScreenGui.ZIndexBehavior = v103.ZIndexBehavior.Sibling
									ScreenGui.Parent = hui
									v106 = ScreenGui
									local v109 = v102.new(v85[73], ScreenGui)
									v109.AutomaticSize = v103.AutomaticSize.Y
									v109.Size = v101.new(0, v85[78], 0, v85[117])
									v109.Position = v101.new(tbl17.Invis.X, tbl17.Invis.OffsetX, tbl17.Invis.Y, tbl17.Invis.OffsetY)
									v109.BackgroundColor3 = tbl26.BG
									v109.BorderSizePixel = 0
									v109.ClipsDescendants = v85[112]
									v109.ZIndex = 100
									fn38(v109, 18)
									fn39(v109, tbl26.AQUA_STROKE, v85[95], 0.4)
									fn42(v109)
									local v110 = v102.new(v85[167], v109)
									v110.AnchorPoint = Vector2.new(0.5, 0.5)
									v110.Position = v101.new(0.5, 0, 0.5, 2)
									v110.Size = v101.new(1, v85[157], v85[48], 24)
									v110.BackgroundTransparency = 1
									v110.Image = "rbxassetid://6014261993"
									v110.ImageColor3 = v100.new(v85[117], v85[117], 0)
									v110.ImageTransparency = 0.72
									v110.ScaleType = v103.ScaleType.Slice
									v110.SliceCenter = Rect.new(49, 49, 450, 450)
									v110.ZIndex = v85[72]
									local Frame3 = v102.new("Frame", v109)
									Frame3.Size = v101.new(1, v85[117], v85[117], 44)
									Frame3.BackgroundTransparency = 1
									Frame3.ZIndex = 101
									fn37(Frame3, v109, "Invis")
									local TextLabel3 = v102.new("TextLabel", Frame3)
									TextLabel3.Size = v101.new(1, -28, 0, 24)
									TextLabel3.Position = v101.new(v85[117], 14, 0, 10)
									TextLabel3.ZIndex = 102
									TextLabel3.BackgroundTransparency = 1
									TextLabel3.Text = "INVISIBLE STEAL"
									TextLabel3.Font = v103.Font.GothamBlack
									TextLabel3.TextSize = v85[74]
									TextLabel3.TextColor3 = tbl26.TEXT
									TextLabel3.TextXAlignment = v103.TextXAlignment.Center
									local Frame4 = v102.new("Frame", v109)
									Frame4.AnchorPoint = Vector2.new(0.5, 0)
									Frame4.Position = v101.new(0.5, v85[117], v85[117], 38)
									Frame4.Size = v101.new(v85[117], 124, 0, v85[48])
									Frame4.BackgroundColor3 = v100.fromRGB(255, 255, 255)
									Frame4.BackgroundTransparency = 0.15
									Frame4.BorderSizePixel = 0
									Frame4.ZIndex = 101
									local Frame5 = v102.new("Frame", v109)
									Frame5.AutomaticSize = v103.AutomaticSize.Y
									Frame5.Size = v101.new(1, -20, v85[117], v85[117])
									Frame5.Position = v101.fromOffset(v85[36], 48)
									Frame5.BackgroundColor3 = tbl26.SURF
									Frame5.BorderSizePixel = v85[117]
									Frame5.ZIndex = 101
									fn38(Frame5, 16)
									fn39(Frame5, tbl26.AQUA_STROKE, 1, 0.48)
									local Frame6 = v102.new("Frame", Frame5)
									Frame6.AutomaticSize = v103.AutomaticSize.Y
									Frame6.Size = v101.new(v85[48], -10, 0, 0)
									Frame6.Position = v101.fromOffset(v85[23], 5)
									Frame6.BackgroundTransparency = 1
									Frame6.ZIndex = 102
									local UIListLayout = v102.new("UIListLayout", Frame6)
									UIListLayout.Padding = UDim.new(0, 8)
									UIListLayout.SortOrder = v103.SortOrder.LayoutOrder
									fn43(v109, Frame3, Frame5, "Invis")
									local Frame7 = v102.new("Frame", Frame6)
									Frame7.Size = v101.new(v85[48], v85[117], 0, 5)
									Frame7.BackgroundTransparency = 1
									Frame7.LayoutOrder = 99

									local function fn61(text, arg, arg2, arg3, arg4, arg5, layoutOrder)
										local v111 = v102.new(v85[73], Frame6)
										v111.Size = v101.new(1, 0, v85[117], v85[34])
										v111.BackgroundColor3 = tbl26.SURF2
										v111.BackgroundTransparency = 0.02
										v111.BorderSizePixel = 0
										v111.LayoutOrder = layoutOrder
										v111.ZIndex = v85[125]
										fn38(v111, 11)
										local v112 = fn39(v111, tbl26.AQUA_STROKE, v85[48], v85[193])
										local v113 = v102.new(v85[66], v111)
										v113.BackgroundTransparency = 1
										v113.Position = v101.fromOffset(v85[142], 0)
										v113.Size = v101.fromOffset(62, 36)
										v113.Font = v103.Font.GothamBold
										v113.Text = text
										v113.TextColor3 = tbl26.TEXT
										v113.TextSize = 12
										v113.TextXAlignment = v103.TextXAlignment.Left
										v113.ZIndex = 104
										local TextLabel4 = v102.new("TextLabel", v111)
										TextLabel4.BackgroundTransparency = 1
										TextLabel4.Position = v101.new(1, -46, 0, 0)
										TextLabel4.Size = v101.fromOffset(v85[34], 36)
										TextLabel4.Font = v103.Font.GothamBold
										TextLabel4.TextColor3 = tbl26.TEXT
										TextLabel4.TextSize = 11
										TextLabel4.TextXAlignment = v103.TextXAlignment.Right
										TextLabel4.ZIndex = 104
										local TextButton = v102.new("TextButton", v111)
										TextButton.AutoButtonColor = v85[112]
										TextButton.Text = ""
										TextButton.BackgroundTransparency = 1
										TextButton.Position = v101.fromOffset(76, 0)
										TextButton.Size = v101.new(v85[48], -128, 1, 0)
										TextButton.ZIndex = 104
										local Frame8 = v102.new("Frame", TextButton)
										Frame8.AnchorPoint = Vector2.new(0, 0.5)
										Frame8.Position = v101.new(v85[117], v85[117], v85[65], 0)
										Frame8.Size = v101.new(1, 0, 0, 5)
										Frame8.BackgroundColor3 = tbl26.OFF_BG
										Frame8.BorderSizePixel = 0
										Frame8.ZIndex = 104
										fn38(Frame8, 3)
										local Frame9 = v102.new("Frame", Frame8)
										Frame9.Size = v101.new(v85[117], v85[117], v85[48], v85[117])
										Frame9.BackgroundColor3 = tbl26.AQUA
										Frame9.BorderSizePixel = v85[117]
										Frame9.ZIndex = 105
										fn38(Frame9, 3)
										local v114 = v102.new(v85[73], Frame8)
										v114.Size = v101.fromOffset(12, v85[142])
										v114.AnchorPoint = Vector2.new(0.5, v85[65])
										v114.Position = v101.new(0, 0, 0.5, 0)
										v114.BackgroundColor3 = tbl26.TEXT
										v114.BorderSizePixel = v85[117]
										v114.ZIndex = 106
										fn38(v114, 6)
										fn39(v114, tbl26.AQUA, 1.5, 0.2)

										v111.MouseEnter:Connect(function()
											fn40(v111, v85[144], { BackgroundColor3 = v100.fromRGB(v85[5], 20, v85[129]) })
											fn40(v112, 0.14, { Transparency = 0.38 })
										end)

										v111.MouseLeave:Connect(function()
											fn40(v111, 0.14, { BackgroundColor3 = tbl26.SURF2 })
											fn40(v112, 0.14, { Transparency = 0.52 })
										end)

										local function fn62()
											local v115 = v89.clamp(v97(arg4()) or arg, arg, arg2)
											local n37 = (v115 - arg) / (arg2 - arg)
											Frame9.Size = v101.new(n37, 0, 1, v85[117])
											v114.Position = v101.new(n37, 0, 0.5, 0)
											TextLabel4.Text = v96(v89.floor(v115 + 0.5))
										end

										local function fn63(arg6, arg7)
											local v115 = v89.clamp(v89.floor(arg6 / arg3 + v85[65]) * arg3, arg, arg2)
											arg5(v115)
											fn62()

											if arg7 then
												fn48()
											end
										end

										fn62()
										local flag25 = false

										local function fn64(arg6)
											local n37 = arg2 - arg
											fn63(arg + v89.clamp((arg6 - Frame8.AbsolutePosition.X) / v89.max(Frame8.AbsoluteSize.X, v85[48]), 0, 1) * n37, false)
										end

										TextButton.InputBegan:Connect(function(input)
											if input.UserInputType == v103.UserInputType.MouseButton1 or input.UserInputType == v103.UserInputType.Touch then
												flag25 = true
												fn64(input.Position.X)
											end
										end)

										UserInputService.InputChanged:Connect(function(input)
											if flag25 and (input.UserInputType == v103.UserInputType.MouseMovement or input.UserInputType == v103.UserInputType.Touch) then
												fn64(input.Position.X)
											end
										end)

										UserInputService.InputEnded:Connect(function(input)
											if (input.UserInputType == v103.UserInputType.MouseButton1 or input.UserInputType == v103.UserInputType.Touch) and flag25 then
												flag25 = false
												fn48()
											end
										end)

										return { render = fn62 }
									end

									local function fn62(arg, arg2)
										if not arg then
											return
										end

										if arg.setActive then
											arg.setActive(arg2)
										else
											fn46(arg, arg2)
										end
									end

									local enabled = fn44(Frame6, "Enabled", 1)
									local walkSpeed = fn44(Frame6, "WalkSpeed", v85[198])

									fn61("Speed", 15, 35, v85[48], function()
										return _G.MynxxWSValue
									end, function(arg)
										setWalkSpeedValue(arg)
									end, 3)

									local autoInvisOnSteal = fn44(Frame6, "Auto Invis On Steal", 4)
									local autoRecover = fn44(Frame6, "Auto Recover", 5)

									fn61("Rotation", v85[117], 360, 5, function()
										return _G.InvisStealAngle
									end, function(invisStealAngle)
										_G.InvisStealAngle = invisStealAngle
									end, 6)

									fn61("Depth", 0, v85[74], 1, function()
										return _G.SinkSliderValue
									end, function(sinkSliderValue)
										_G.SinkSliderValue = sinkSliderValue
									end, 7)

									fn49 = function()
										fn46(enabled, flag23)
										fn62(invisRef, flag23)
										fn46(walkSpeed, tbl32.enabled)
										fn62(wsRef, tbl32.enabled)
										fn46(autoInvisOnSteal, _G.AutoInvisDuringSteal)
										fn46(autoRecover, _G.AutoRecoverLagback)
									end

									enabled.button.MouseButton1Click:Connect(function()
										_G.toggleInvisibleSteal()
									end)

									walkSpeed.button.MouseButton1Click:Connect(function()
										_G.MynxxWSEnabled = not tbl32.enabled
										setWalkSpeedEnabled(_G.MynxxWSEnabled)
										fn48()
									end)

									autoInvisOnSteal.button.MouseButton1Click:Connect(function()
										_G.AutoInvisDuringSteal = not _G.AutoInvisDuringSteal
										fn49()
										fn48()
									end)

									autoRecover.button.MouseButton1Click:Connect(function()
										_G.AutoRecoverLagback = not _G.AutoRecoverLagback
										fn49()
										fn48()
									end)

									if flag18 then
										if invisRef then
											invisRef.button.MouseButton1Click:Connect(function()
												_G.toggleInvisibleSteal()
											end)
										end

										if wsRef then
											wsRef.button.MouseButton1Click:Connect(function()
												_G.MynxxWSEnabled = not tbl32.enabled
												setWalkSpeedEnabled(_G.MynxxWSEnabled)
												fn48()
											end)
										end
									else
										UserInputService.InputBegan:Connect(function(input, gameProcessed)
											if gameProcessed or input.UserInputType ~= v103.UserInputType.Keyboard then
												return
											end
											local name = input.KeyCode.Name

											if name == tbl20.invis then
												_G.toggleInvisibleSteal()
											elseif name == tbl20.ws then
												_G.MynxxWSEnabled = not tbl32.enabled
												setWalkSpeedEnabled(_G.MynxxWSEnabled)
												fn48()
											end
										end)
									end

									if _G.MynxxWSEnabled then
										v88.defer(function()
											setWalkSpeedEnabled(true)
										end)
									else
										fn49()
									end
								end

								fn47()

								if flag22 then
									UserInputService.InputBegan:Connect(function(input, gameProcessed)
										if gameProcessed then
											return
										end

										if input.KeyCode == v103.KeyCode.LeftControl and v106 then
											v106.Enabled = not v106.Enabled
										end
									end)
								end
							end
						end

						do
							local adminGui = nil

							local function fn47()
								local tbl29 = {
									Accent = v100.fromRGB(255, 255, 255),
									Accent1 = v100.fromRGB(v85[183], v85[54], 60),
									Accent2 = v100.fromRGB(170, 30, 30),
									Error = v100.fromRGB(v85[63], 60, 80),
									SurfaceHighlight = v100.fromRGB(v85[71], 16, 16),
									TextSecondary = v100.fromRGB(200, 170, 170),
								}

								local tbl30 = { BalloonedPlayers = {}, AdminButtonCache = {} }
								local flag23 = v85[112]
								local v106 = nil

								local tbl31 = {
									ProximityRange = proximityRange,
									Positions = { AdminPanel = tbl17.Admin },
									ClickToAP = false,
									ClickToAPSingleCommand = false,
									TpSettings = { Tool = "Flying Carpet" },
									HideAdminPanel = v85[112],
									DisableProximitySpamOnMoby = false,
									DisableProximitySpamOnKawaifu = false,
									DisableClickToAPOnMoby = false,
									DisableClickToAPOnKawaifu = v85[112],
									CancelAPPanelOnMoby = v85[112],
									CancelAPPanelOnKawaifu = false,
								}

								local v107 = fn30

								local function fn48()
									proximityRange = tbl31.ProximityRange
									v107()
								end

								local function fn49(arg)
									if not arg or not arg.Character then
										return false
									end
									return arg.Character:FindFirstChild("_moby_highlight") ~= nil
								end

								local function fn50(arg)
									if not arg or not arg.Character then
										return v85[112]
									end
									return arg.Character:FindFirstChild("KaWaifu_NeonHighlight") ~= nil
								end

								local function fn51(arg, arg2)
									local slicedzNotifSa = v104:FindFirstChild("SlicedzNotif_SA")

									if slicedzNotifSa then
										slicedzNotifSa:Destroy()
									end

									local v108 = v102.new(v85[40], gethui())
									v108.Name = "SlicedzNotif_SA"
									v108.ResetOnSpawn = v85[112]
									local v109 = v102.new(v85[73], v108)
									v109.Size = v101.new(0, 290, 0, 54)
									v109.Position = v101.new(v85[65], -145, 0, 80)
									v109.BackgroundColor3 = v100.fromRGB(6, 6, v85[142])
									v109.BackgroundTransparency = 1
									v109.BorderSizePixel = v85[117]
									v102.new("UICorner", v109).CornerRadius = UDim.new(0, 9)
									local UIStroke = v102.new("UIStroke", v109)
									UIStroke.Thickness = 1
									UIStroke.Color = tbl29.Accent2
									UIStroke.Transparency = 1
									local Frame3 = v102.new("Frame", v109)
									Frame3.Size = v101.new(0, 3, 1, -v85[142])
									Frame3.Position = v101.new(v85[117], 5, 0, 6)
									Frame3.BackgroundColor3 = tbl29.Accent1
									Frame3.BorderSizePixel = 0
									Frame3.BackgroundTransparency = 1
									v102.new("UICorner", Frame3).CornerRadius = UDim.new(v85[48], 0)
									local TextLabel3 = v102.new("TextLabel", v109)
									TextLabel3.Size = v101.new(v85[48], -v85[76], v85[117], v85[74])
									TextLabel3.Position = v101.new(0, 16, 0, 7)
									TextLabel3.BackgroundTransparency = 1
									TextLabel3.Text = v96(arg):upper()
									TextLabel3.Font = v103.Font.GothamBlack
									TextLabel3.TextSize = 11
									TextLabel3.TextColor3 = tbl29.Accent1
									TextLabel3.TextXAlignment = v103.TextXAlignment.Left
									TextLabel3.TextTransparency = 1
									local TextLabel4 = v102.new("TextLabel", v109)
									TextLabel4.Size = v101.new(1, -v85[76], 0, 15)
									TextLabel4.Position = v101.new(0, 16, 0, 27)
									TextLabel4.BackgroundTransparency = 1
									TextLabel4.Text = v96(arg2)
									TextLabel4.Font = v103.Font.GothamMedium
									TextLabel4.TextSize = 10
									TextLabel4.TextColor3 = tbl29.TextSecondary
									TextLabel4.TextXAlignment = v103.TextXAlignment.Left
									TextLabel4.TextTransparency = 1
									local tweenInfo = TweenInfo.new(0.2, v103.EasingStyle.Quad, v103.EasingDirection.Out)
									TweenService:Create(v109, tweenInfo, { BackgroundTransparency = 0.08 }):Play()
									TweenService:Create(UIStroke, tweenInfo, { Transparency = 0.3 }):Play()
									TweenService:Create(Frame3, tweenInfo, { BackgroundTransparency = 0 }):Play()
									TweenService:Create(TextLabel3, tweenInfo, { TextTransparency = 0 }):Play()
									TweenService:Create(TextLabel4, tweenInfo, { TextTransparency = 0 }):Play()

									v88.delay(2, function()
										if not v108.Parent then
											return
										end
										local tweenInfo2 = TweenInfo.new(v85[137], v103.EasingStyle.Quad, v103.EasingDirection.In)
										TweenService:Create(v109, tweenInfo2, { BackgroundTransparency = 1 }):Play()
										TweenService:Create(UIStroke, tweenInfo2, { Transparency = 1 }):Play()
										TweenService:Create(Frame3, tweenInfo2, { BackgroundTransparency = v85[48] }):Play()
										TweenService:Create(TextLabel3, tweenInfo2, { TextTransparency = 1 }):Play()
										TweenService:Create(TextLabel4, tweenInfo2, { TextTransparency = 1 }):Play()
										v88.wait(v85[44])

										if v108.Parent then
											v108:Destroy()
										end
									end)
								end

								local function fireClick_(arg)
									if not arg then
										return false
									end

									return (v94(function()
										local v108 = v85[151]

										if typeof(firesignal) == v108 then
											if arg.MouseButton1Click then
												firesignal(arg.MouseButton1Click)
											end

											if arg.MouseButton1Down then
												firesignal(arg.MouseButton1Down)
											end

											if arg.Activated then
												firesignal(arg.Activated)
											end
										else
											local n33 = arg.AbsolutePosition.X + arg.AbsoluteSize.X / 2
											local n34 = arg.AbsolutePosition.Y + arg.AbsoluteSize.Y / 2 + 58
											local VirtualInputManager = v102.new("VirtualInputManager")
											VirtualInputManager:SendMouseButtonEvent(n33, n34, 0, true, v87, v85[117])
											VirtualInputManager:SendMouseButtonEvent(n33, n34, 0, false, v87, v85[117])
										end
									end))
								end

								_G.fireClick = fireClick_

								_G.runAdminCommand = function(arg, arg2)
									if not arg or not arg2 or arg2 == "" then
										return false
									end
									local adminPanel = v104:WaitForChild("AdminPanel", 5)
									if not adminPanel then
										return false
									end

									local v108, v109 = v94(function()
										return adminPanel.AdminPanel:WaitForChild("Content"):WaitForChild("ScrollingFrame")
									end)

									if not v108 or not v109 then
										return v85[112]
									end
									local v110 = v109:FindFirstChild(arg2)
									if not v110 then
										return false
									end

									if not fireClick_(v110) then
										return false
									end
									v88.wait(0.05)

									local v111, v112 = v94(function()
										return adminPanel:WaitForChild("AdminPanel"):WaitForChild("Profiles"):WaitForChild("ScrollingFrame")
									end)

									if not v111 or not v112 then
										return false
									end
									local v113 = v112:FindFirstChild(arg.Name)
									if not v113 then
										return false
									end

									if not fireClick_(v113) then
										return false
									end
									return true
								end

								local tbl32 = { "balloon", "inverse", "jail", "jumpscare", "morph", "nightvision", "ragdoll", "rocket", "tiny" }
								local Highlight = v102.new("Highlight")
								Highlight.Name = "DebrokClickAPHighlight"
								Highlight.FillColor = tbl29.Accent1
								Highlight.FillTransparency = 0.3
								Highlight.OutlineColor = tbl29.Accent1
								Highlight.OutlineTransparency = 0
								Highlight.DepthMode = v103.HighlightDepthMode.AlwaysOnTop
								Highlight.Adornee = nil
								Highlight.Parent = gethui()

								local function fn52(arg)
									local adminPanel = v104:FindFirstChild("AdminPanel")

									if adminPanel then
										local v108, v109 = v94(function()
											local timer = adminPanel.AdminPanel.Content.ScrollingFrame:FindFirstChild(arg)
											timer = timer and timer:FindFirstChild("Timer")
											return timer and timer.Visible
										end)

										if v108 and v109 then
											return true
										end
									end

									if v95(nil) == "table" then
										if v106[arg] then
										end
									end

									return false
								end

								local function fn53(arg)
									if v95(nil) == "table" then
										v106[arg] = tick()
									end

									if tbl30.AdminButtonCache and tbl30.AdminButtonCache[arg] then
										for _, v108 in v92(tbl30.AdminButtonCache[arg]) do
											if v108 and v108.Parent then
												v94(function()
													v108.BackgroundColor3 = tbl29.Error
												end)

												v88.delay(v85[23], function()
													if v108 and v108.Parent then
														v94(function()
															v108.BackgroundColor3 = arg == "balloon" and tbl30.BalloonedPlayers and next(tbl30.BalloonedPlayers) ~= nil and tbl29.Error or tbl29.SurfaceHighlight
														end)
													end
												end)
											end
										end
									end
								end

								local function fn54()
									local flag24 = tbl30.BalloonedPlayers and next(tbl30.BalloonedPlayers) ~= nil

									if tbl30.AdminButtonCache and tbl30.AdminButtonCache.balloon then
										for _, v108 in v92(tbl30.AdminButtonCache.balloon) do
											if v108 and v108.Parent then
												v94(function()
													v108.BackgroundColor3 = flag24 and tbl29.Error or tbl29.SurfaceHighlight
												end)
											end
										end
									end
								end

								local function fn55()
									local tbl33 = {}

									for _, v108 in v92({ "ragdoll", "balloon", "rocket", "jail" }) do
										tbl33[v108] = true
										if not fn52(v108) then
											return v108
										end
									end

									for _, v108 in v92(tbl32) do
										if not tbl33[v108] and not fn52(v108) then
											return v108
										end
									end

									return nil
								end

								local function fn56(arg, arg2)
									local n33 = v97(arg2) or 0.1
									local n34 = 0

									for _, v108 in v92(tbl32) do
										if not fn52(v108) then
											v88.delay(n34 * n33, function()
												if not arg or not arg.Parent or arg == localPlayer then
													return
												end
												local v109, v110 = v94(_G.runAdminCommand, arg, v108)

												if v109 and v110 then
													fn53(v108)

													if v108 == "balloon" then
														tbl30.BalloonedPlayers[arg.UserId] = true
														fn54()
													end
												end
											end)

											n34 += 1
										end
									end
								end

								local n33 = 0

								local function fn57()
									local tbl33 = {}
									local character = localPlayer.Character
									character = character and character:FindFirstChild("HumanoidRootPart")
									if not character then
										return tbl33
									end
									local v108 = v97(tbl31.ProximityRange) or v85[96]

									for _, player in v92(service:GetPlayers()) do
										if player ~= localPlayer and player.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
											if (player.Character.HumanoidRootPart.Position - character.Position).Magnitude <= v108 then
												if not (tbl31.DisableProximitySpamOnMoby and fn49(player) or tbl31.DisableProximitySpamOnKawaifu and fn50(player)) then
													v91.insert(tbl33, player)
												end
											end
										end
									end

									v91.sort(tbl33, function(arg, arg2)
										return arg.UserId < arg2.UserId
									end)

									return tbl33
								end

								local function fn58()
									local v108 = fn57()
									if #v108 <= 0 then
										return
									end
									local v109 = fn55()
									if not v109 then
										return
									end
									n33 = n33 % #v108 + 1
									local v110 = v108[n33]
									if not v110 then
										return
									end
									local v111, v112 = v94(_G.runAdminCommand, v110, v109)

									if v111 and v112 then
										fn53(v109)

										if v109 == "balloon" then
											tbl30.BalloonedPlayers[v110.UserId] = true
											fn54()
										end
									end
								end

								local function fn59(arg, arg2, arg3, arg4)
									local v108 = v98.new(arg4 / 2, arg4 / 2, arg4 / 2)
									local n34 = arg3 - v108
									local n35 = arg3 + v108

									local function fn60(arg5, arg6)
										if v89.abs(arg6) < 1e-08 then
											if arg5 >= 0 then
												return v89.huge
											end
											return -v89.huge
										end

										return arg5 / arg6
									end

									local v109 = fn60(n34.X - arg.X, arg2.X)
									local v110 = fn60(n35.X - arg.X, arg2.X)

									if not (v110 < v109) then
										local v111 = v110
										v110 = v109
										v109 = v111
									end

									local v111 = fn60(n34.Y - arg.Y, arg2.Y)
									local v112 = fn60(n35.Y - arg.Y, arg2.Y)

									if not (v112 < v111) then
										local v113 = v111
										v111 = v112
										v112 = v113
									end

									if v110 > v111 or v112 > v109 then
										return false
									end

									if v112 > v110 then
										v110 = v112
									end

									if not (v111 < v109) then
										v111 = v109
									end

									local v113 = fn60(n34.Z - arg.Z, arg2.Z)
									local v114 = fn60(n35.Z - arg.Z, arg2.Z)

									if not (v114 < v113) then
										local v115 = v113
										v113 = v114
										v114 = v115
									end

									if v110 > v113 or v114 > v111 then
										return false
									end
									return true
								end

								service2.RenderStepped:Connect(function(...) end)

								UserInputService.InputBegan:Connect(function(input, gameProcessed)
									if gameProcessed then
										return
									end

									if input.UserInputType ~= v103.UserInputType.MouseButton1 then
										return
									end

									if not tbl31.ClickToAP then
										return
									end
									local currentCamera = Workspace.CurrentCamera
									local mouseLocation = UserInputService:GetMouseLocation()
									local v108 = currentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
									local huge = v89.huge
									local v109 = nil

									for _, player in v92(service:GetPlayers()) do
										if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Parent then
											local position = player.Character.HumanoidRootPart.Position

											if fn59(v108.Origin, v108.Direction, position, 8) then
												local magnitude = (v108.Origin - position).Magnitude

												if magnitude < huge then
													huge = magnitude
													v109 = player
												end
											end
										end
									end

									if not v109 then
										return
									end

									if tbl31.DisableClickToAPOnMoby and fn49(v109) then
										fn51("CLICK TO AP", "Disabled on Moby users")
										return
									end

									if tbl31.DisableClickToAPOnKawaifu and fn50(v109) then
										fn51("CLICK TO AP", "Disabled on Kawaifu users")
										return
									end
									local flag24 = false

									for _, v110 in v92(tbl32) do
										if not fn52(v110) then
											flag24 = true
											break
										end
									end

									if flag24 then
										if tbl31.ClickToAPSingleCommand then
											local v110 = fn55()

											if v110 then
												local v111, v112 = v94(_G.runAdminCommand, v109, v110)

												if v111 and v112 then
													fn53(v110)

													if v110 == "balloon" then
														tbl30.BalloonedPlayers[v109.UserId] = v85[8]
														fn54()
													end

													fn51("CLICK AP", "Sent " .. v110 .. " to " .. v109.Name)
												else
													fn51("CLICK AP", "Failed to send " .. v110 .. " to " .. v109.Name)
												end
											else
												fn51("CLICK AP", "All commands on cooldown")
											end
										else
											fn56(v109)
											fn51("CLICK AP", "Triggered on " .. v109.Name)
										end
									else
										local adminPanel = v104:WaitForChild("AdminPanel", 5)

										if adminPanel then
											local v110 = adminPanel:WaitForChild("AdminPanel"):WaitForChild("Profiles"):WaitForChild("ScrollingFrame"):FindFirstChild(v109.Name)

											if v110 then
												fireClick(v110)
												fn51("CLICK AP", "Selected " .. v109.Name)
											end
										end
									end
								end)

								local flag24 = false

								local function fn60()
									if flag24 then
										return
									end
									flag24 = true
									v88.spawn(function(...) end)
								end

								service2.Heartbeat:Connect(function(...) end)

								local function fn61()
									local function fn62(arg)
										local v108, v109 = v94(function()
											return v90.lower(v96(arg.Text or ""))
										end)

										return v108 and v109 or ""
									end

									local function fn63(arg)
										if not arg then
											return v85[112]
										end
										local v108 = v85[117]
										local flag25 = false
										local flag26 = false
										local flag27 = false

										for _, descendant in v92(arg:GetDescendants()) do
											if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
												local v109 = fn62(descendant)

												if v109:find("admin panel", 1, v85[8]) then
													flag25 = true
												end

												if v109:find("player list", v85[48], true) then
													flag26 = true
												end

												if v109 == "tp" then
													flag27 = true
												end

												if v109 == "⚔" or v109 == "🔒" or v109 == "🚀" or v109 == "🎈" then
													v108 += 1
												end
											end
										end

										return flag25 and flag26 and v108 >= v85[132] and not flag27
									end

									local function fn64(arg)
										if not arg or not arg:IsA("ScreenGui") then
											return false
										end

										if arg.Name == "XiAdminPanel" then
											return true
										end

										if fn63(arg) then
											return true
										end
										return false
									end

									local tbl33 = {}

									v94(function()
										v91.insert(tbl33, v104)
									end)

									v94(function()
										local CoreGui = v87:GetService("CoreGui")

										if CoreGui then
											v91.insert(tbl33, CoreGui)
										end
									end)

									for _, v108 in v92(tbl33) do
										for _, child in v92(v108:GetChildren()) do
											if fn64(child) then
												v94(function()
													child:Destroy()
												end)
											end
										end
									end
								end

								local function fn62()
									fn61()

									local tbl33 = {
										Text = v100.fromRGB(245, 247, 250),
										SubText = v100.fromRGB(v85[110], 100, 100),
										Accent = v100.fromRGB(255, 255, 255),
										AccentSoft = v100.fromRGB(80, 28, 28),
										AccentBright = v100.fromRGB(215, v85[183], 230),
										PanelTop = v100.fromRGB(14, v85[176], v85[176]),
										PanelTop2 = v100.fromRGB(v85[142], 6, v85[147]),
										PanelInner = v100.fromRGB(12, 6, 6),
										ControlsBar = v100.fromRGB(12, 6, 6),
										RowA = v100.fromRGB(22, v85[36], 10),
										RowB = v100.fromRGB(18, 8, 8),
										RowHover = v100.fromRGB(38, 14, 14),
										RowLine = v100.fromRGB(60, v85[129], 20),
										ButtonBg = v100.fromRGB(18, v85[176], 8),
										ButtonStroke = v100.fromRGB(80, v85[139], 28),
										LockedFill = v100.fromRGB(86, 69, v85[85]),
										Danger = v100.fromRGB(167, 58, 62),
										Yellow = v100.fromRGB(255, 213, 96),
										White = v100.fromRGB(255, 255, 255),
										PanelCorner = 3,
										RowCorner = v85[62],
										ButtonCorner = v85[62],
										AvatarCorner = 3,
										RowHeight = 54,
										ButtonSize = 38,
										BoxSize = v85[116],
										IconSize = 17,
									}

									tbl33.ActionsWidth = 5 * tbl33.ButtonSize
									tbl33.SafeGap = v85[142]
									tbl33.NameSize = v85[155]
									tbl33.UserSize = 12
									tbl33.StatusSize = 11

									local tbl34 = {
										{ label = "🏃", action = "ragdoll" },
										{ label = "🔒", action = "jail" },
										{ label = "🚀", action = "rocket" },
										{ label = "🎈", action = "balloon" },
										{ label = "TP", action = "tp" },
									}

									local tbl35 = { ragdoll = v85[115], jail = 60, rocket = 120, balloon = 30 }

									local function fn63(arg, arg2)
										local v108 = v102.new(arg)
										local tbl36 = arg2 or {}

										for k, v109 in v93(tbl36) do
											v108[k] = v109
										end

										return v108
									end

									local function fn64(parent, arg)
										local UICorner = v102.new("UICorner")
										UICorner.CornerRadius = UDim.new(0, arg or 10)
										UICorner.Parent = parent
										return UICorner
									end

									local function fn65(parent, color, thickness, transparency)
										local UIStroke = v102.new("UIStroke")
										UIStroke.ApplyStrokeMode = v103.ApplyStrokeMode.Border
										UIStroke.LineJoinMode = v103.LineJoinMode.Round
										UIStroke.Color = color
										UIStroke.Thickness = thickness or 1
										UIStroke.Transparency = transparency or 0
										UIStroke.Parent = parent
										return UIStroke
									end

									local function fn66(parent, arg, arg2, rotation)
										local UIGradient = v102.new("UIGradient")
										UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, arg), ColorSequenceKeypoint.new(1, arg2) })
										UIGradient.Rotation = rotation or 0
										UIGradient.Parent = parent
										return UIGradient
									end

									local tbl36 = {}
									local tbl37 = { ragdoll = {}, jail = {}, rocket = {}, balloon = {}, tp = {} }
									local tbl38 = {}

									local function fn67(arg)
										return tbl35[arg] or 0
									end

									local function fn68(arg)
										if not flag3 then
											return
										end
										local v108 = tbl36[arg]
										local v109 = fn67(arg)
										if not v108 or v109 <= 0 then
											return false
										end
										return tick() - v108 < v109
									end

									local function fn69(arg, arg2)
										local box = arg:FindFirstChild("Box")
										local stroke = box and box:FindFirstChild("Stroke")
										local fill = box and box:FindFirstChild("Fill")
										if not box or not stroke or not fill then
											return
										end

										if arg2 == "normal" then
											fill.BackgroundColor3 = tbl33.ButtonBg
											fill.BackgroundTransparency = v85[60]
											stroke.Color = tbl33.ButtonStroke
											stroke.Transparency = 1
										elseif arg2 == "hover" then
											fill.BackgroundColor3 = tbl33.RowHover
											fill.BackgroundTransparency = 0
											stroke.Color = tbl33.AccentBright
											stroke.Transparency = 1
										elseif arg2 == "locked" then
											fill.BackgroundColor3 = v100.fromRGB(145, 34, 34)
											fill.BackgroundTransparency = 0.02
											stroke.Color = v100.fromRGB(255, 120, v85[69])
											stroke.Transparency = 0.35
										end
									end

									local function fn70(arg, arg2)
										local tbl39 = tbl37[arg] or {}

										for _, v108 in v92(tbl39) do
											if v108 and v108.Parent then
												local attribute = v108:GetAttribute("TargetPlayerName")
												local v109 = attribute and service:FindFirstChild(attribute) or nil
												local flag25 = v109 and rpIsAdminPanelBlockedForPlayer and rpIsAdminPanelBlockedForPlayer(v109) or false
												local v110 = arg2 or flag25
												v108.Active = not v110
												v108:SetAttribute("Locked", v110)

												if v110 then
													fn69(v108, "locked")
												else
													fn69(v108, "normal")
												end
											end
										end
									end

									local function fn71(arg)
										return tbl31.CancelAPPanelOnMoby and fn49 and fn49(arg) or tbl31.CancelAPPanelOnKawaifu and fn50 and fn50(arg)
									end

									local function fn72(arg)
										if not arg then
											return
										end
										local v108 = tbl38 and tbl38[arg.UserId]
										if not v108 or not v108.Parent then
											return
										end
										local actions = v108:FindFirstChild("Actions")
										if not actions then
											return
										end
										local v109 = fn71(arg)

										for _, child in v92(actions:GetChildren()) do
											if child:IsA("TextButton") then
												local attribute = child:GetAttribute("ActionName")
												local v110 = v109 or attribute and fn68(attribute) or v85[112]
												child.Active = not v110
												child:SetAttribute("Locked", v110)

												if v110 then
													fn69(child, "locked")
												else
													fn69(child, "normal")
												end
											end
										end
									end

									local function fn73(arg)
										if fn67(arg) <= 0 then
											return
										end
										tbl36[arg] = tick()
										fn70(arg, v85[8])

										v88.spawn(function()
											while fn68(arg) do
												v88.wait(v85[137])
											end

											fn70(arg, false)
										end)
									end

									local function fn74(arg, arg2)
										if _G.runAdminCommand then
											local v108, v109 = v94(_G.runAdminCommand, arg, arg2)
											return v108 and v109
										end
										local v108 = v85[151]
										if v95(runAdminCommand) == v108 then
											local v109, v110 = v94(runAdminCommand, arg, arg2)
											return v109 and v110
										end
										return false
									end

									local function fn75(arg)
										if not arg then
											return nil
										end
										local plots = Workspace:FindFirstChild("Plots")
										if not plots then
											return nil
										end

										for _, child in v92(plots:GetChildren()) do
											local v108 = fn29(child.Name)

											if v108 and v108.Owner then
												local owner = v108.Owner
												if typeof(owner) == "Instance" and owner == arg then
													return child
												end

												if v95(owner) == "string" and owner == arg.Name then
													return child
												end
											end
										end

										for _, child in v92(plots:GetChildren()) do
											local plotSign = child:FindFirstChild("PlotSign")
											local textLabel = plotSign and plotSign:FindFirstChild(v85[185]) and plotSign.SurfaceGui:FindFirstChild("Frame") and plotSign.SurfaceGui.Frame:FindFirstChild("TextLabel")

											if textLabel then
												local v108 = v96(textLabel.Text or "")
												local match = v108:match("^(.-)'") or v108
												if match == arg.DisplayName or match == arg.Name then
													return child
												end
											end
										end

										return nil
									end

									local function fn76(arg)
										if not arg then
											return nil
										end
										local v108 = arg:FindFirstChild(v85[55])
										if not v108 then
											return nil
										end

										if v108:IsA("BasePart") then
											return v108
										end

										if v108:IsA("Model") then
											return v108.PrimaryPart or v108:FindFirstChildWhichIsA("BasePart", true)
										end
										return v108:FindFirstChildWhichIsA("BasePart", v85[8])
									end

									local function fn77(arg)
										local character = localPlayer.Character
										local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
										local humanoid = character and character:FindFirstChild("Humanoid")
										if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
											return false, "No character"
										end
										local v108 = fn75(arg)
										if not v108 then
											return false, "Base not found"
										end
										local v109 = fn76(v108)
										if not v109 then
											return v85[112], "Sign not found"
										end
										local tool = tbl31.TpSettings.Tool
										local v110 = localPlayer.Backpack:FindFirstChild(tool) or character:FindFirstChild(tool)

										if v110 then
											humanoid:EquipTool(v110)
											v88.wait(0.01)
										end

										local cFrame = v109.CFrame
										local lookVector = cFrame.LookVector
										local n34 = -cFrame.LookVector
										riseToY(humanoidRootPart, 40)
										local n35 = v109.Position + lookVector * 20
										local n36 = v109.Position + n34 * v85[129]
										local position = humanoidRootPart.Position
										local v111 = v98.new(position.X, v85[117], position.Z)
										n35 = (v98.new(n35.X, 0, n35.Z) - v111).Magnitude < (v98.new(n36.X, 0, n36.Z) - v111).Magnitude and n35 or n36
										local v112 = v98.new(n35.X, -4.8, n35.Z)
										humanoidRootPart.Velocity = v98.zero
										humanoidRootPart.CFrame = v99.new(v112)
										humanoidRootPart.Velocity = v98.zero

										waitUntilHeartbeat(function()
											return humanoidRootPart and humanoidRootPart.Parent and (humanoidRootPart.Position - v112).Magnitude <= 2 and humanoid and humanoid.FloorMaterial ~= v103.Material.Air
										end, 3)

										humanoidRootPart.Velocity = v98.zero
										return true
									end

									local tbl39 = {
										adminGui = fn63(v85[40], {
											Name = "XiAdminPanel",
											ResetOnSpawn = false,
											IgnoreGuiInset = true,
											ZIndexBehavior = v103.ZIndexBehavior.Sibling,
											Parent = gethui(),
										}),
									}

									tbl39.outer = fn63("Frame", {
										Name = "Frame",
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = v101.fromOffset(530, 44),
										AutomaticSize = v103.AutomaticSize.Y,
										Position = v101.new(tbl31.Positions.AdminPanel.X, tbl31.Positions.AdminPanel.OffsetX or v85[117], tbl31.Positions.AdminPanel.Y, tbl31.Positions.AdminPanel.OffsetY or v85[117]),
										ZIndex = 10,
										Parent = tbl39.adminGui,
									})

									tbl39.backdrop = fn63("Frame", {
										Name = "Backdrop",
										BackgroundColor3 = v100.fromRGB(8, 9, 12),
										BackgroundTransparency = 0.5,
										BorderSizePixel = v85[117],
										Position = v101.fromOffset(-3, -v85[198]),
										Size = v101.new(1, 6, v85[48], 4),
										AutomaticSize = v103.AutomaticSize.Y,
										ZIndex = v85[117],
										Parent = tbl39.outer,
									})

									fn64(tbl39.backdrop, 8)
									fn65(tbl39.backdrop, tbl33.AccentSoft, 1, 0.82)

									tbl39.topCard = fn63(v85[73], {
										Name = "TopCard",
										BackgroundColor3 = tbl33.PanelTop,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = v101.new(1, 0, 0, 42),
										Parent = tbl39.outer,
									})

									fn64(tbl39.topCard, tbl33.PanelCorner)
									fn65(tbl39.topCard, tbl33.AccentSoft, 1.2, 1)
									fn66(tbl39.topCard, tbl33.PanelTop, tbl33.PanelTop2, 90)

									tbl39.refreshBtn = fn63("TextButton", {
										Size = v101.fromOffset(72, 24),
										Position = v101.fromOffset(v85[36], 8),
										BackgroundColor3 = v100.fromRGB(24, 27, 33),
										AutoButtonColor = v85[112],
										Text = "Refresh",
										Font = v103.Font.GothamBold,
										TextSize = v85[36],
										TextColor3 = tbl33.Text,
										Visible = false,
										Visible = false,
										Parent = tbl39.topCard,
									})

									tbl39.closeBtn = fn63("TextButton", {
										Size = v101.fromOffset(v85[74], 18),
										Position = v101.new(1, -v85[139], 0, v85[36]),
										BackgroundColor3 = v100.fromRGB(v85[76], 24, v85[115]),
										AutoButtonColor = false,
										Text = "□",
										Font = v103.Font.GothamBlack,
										TextSize = 9,
										TextColor3 = tbl33.Text,
										Visible = v85[112],
										Parent = tbl39.topCard,
									})

									tbl39.title = fn63("TextLabel", {
										BackgroundTransparency = v85[48],
										AnchorPoint = Vector2.new(0.5, v85[117]),
										Position = v101.new(0.5, 0, 0, 8),
										Size = v101.new(0, 220, v85[117], 22),
										TextXAlignment = v103.TextXAlignment.Center,
										Text = "Admin Commands",
										Font = v103.Font.GothamBlack,
										TextSize = 16,
										TextColor3 = tbl33.Text,
										Visible = v85[112],
										Parent = tbl39.topCard,
									})

									tbl39.controlsBar = fn63("Frame", {
										Name = "ControlsBar",
										BackgroundColor3 = v100.fromRGB(8, 9, 12),
										BackgroundTransparency = v85[117],
										BorderSizePixel = 0,
										Position = v101.fromOffset(6, 6),
										Size = v101.new(1, -12, v85[117], 40),
										Parent = tbl39.topCard,
									})

									fn64(tbl39.controlsBar, 8)

									tbl39.controls = fn63("Frame", {
										Name = "Controls",
										BackgroundTransparency = 1,
										Position = v101.fromOffset(8, v85[132]),
										Size = v101.new(1, -16, v85[48], -8),
										Parent = tbl39.controlsBar,
									})

									tbl39.proxBtn = fn63("TextButton", {
										Name = "ProximityAPButton",
										Size = v101.fromOffset(52, 24),
										Position = v101.fromOffset(2, v85[92]),
										BackgroundColor3 = v100.fromRGB(20, v85[76], 28),
										AutoButtonColor = false,
										Text = "Prox",
										Font = v103.Font.GothamBold,
										TextSize = 10,
										TextColor3 = tbl33.Text,
										Parent = tbl39.controls,
									})

									fn64(tbl39.proxBtn, 3)
									tbl39.proxBtnStroke = fn65(tbl39.proxBtn, tbl33.ButtonStroke, 1, 0.28)

									tbl39.spamBaseBtn = fn63(v85[68], {
										Size = v101.fromOffset(90, v85[157]),
										Position = v101.fromOffset(62, v85[92]),
										BackgroundColor3 = v100.fromRGB(v85[129], 22, 28),
										AutoButtonColor = false,
										Text = "Spam Base Owner",
										Font = v103.Font.GothamBold,
										TextSize = v85[36],
										TextColor3 = tbl33.Text,
										Parent = tbl39.controls,
									})

									fn64(tbl39.spamBaseBtn, 3)
									tbl39.spamStroke = fn65(tbl39.spamBaseBtn, tbl33.ButtonStroke, v85[48], 0.28)

									tbl39.rangeLabel = fn63("TextLabel", {
										BackgroundTransparency = 1,
										Position = v101.fromOffset(160, 7),
										Size = v101.fromOffset(v85[178], 24),
										Text = v96(v89.floor(tbl31.ProximityRange or 15)),
										Font = v103.Font.GothamBold,
										TextSize = 12,
										TextColor3 = tbl33.Text,
										Parent = tbl39.controls,
									})

									tbl39.proxSliderBg = fn63(v85[73], {
										BackgroundColor3 = v100.fromRGB(v85[54], 18, 18),
										BorderSizePixel = 0,
										Position = v101.fromOffset(198, 17),
										Size = v101.fromOffset(170, v85[147]),
										Parent = tbl39.controls,
									})

									fn64(tbl39.proxSliderBg, 3)

									tbl39.proxFill = fn63(v85[73], {
										BackgroundColor3 = tbl33.White,
										BorderSizePixel = v85[117],
										Size = v101.new(0, 0, 1, 0),
										Parent = tbl39.proxSliderBg,
									})

									fn64(tbl39.proxFill, 3)

									tbl39.proxKnob = fn63("Frame", {
										BackgroundColor3 = tbl33.White,
										BorderSizePixel = 0,
										AnchorPoint = Vector2.new(0.5, v85[65]),
										Position = v101.new(0, v85[117], 0.5, 0),
										Size = v101.fromOffset(16, v85[155]),
										Parent = tbl39.proxSliderBg,
									})

									fn64(tbl39.proxKnob, 3)
									tbl39.proxKnobStroke = fn65(tbl39.proxKnob, v100.fromRGB(18, 21, 27), 1.2, 0.35)

									tbl39.listHolder = fn63("Frame", {
										Name = "ListHolder",
										BackgroundColor3 = tbl33.PanelInner,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Position = v101.new(0, 0, 0, 46),
										Size = v101.new(1, 0, v85[117], 0),
										AutomaticSize = v103.AutomaticSize.Y,
										Parent = tbl39.outer,
									})

									fn64(tbl39.listHolder, tbl33.PanelCorner)
									tbl39.pad = v102.new("UIPadding")
									tbl39.pad.PaddingTop = UDim.new(0, 2)
									tbl39.pad.PaddingBottom = UDim.new(0, 2)
									tbl39.pad.PaddingLeft = UDim.new(0, v85[132])
									tbl39.pad.PaddingRight = UDim.new(0, v85[132])
									tbl39.pad.Parent = tbl39.listHolder
									fn63("UIListLayout", { SortOrder = v103.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = tbl39.listHolder })
									fn37(tbl39.topCard, tbl39.outer, "Admin")
									v102.new(v85[186], tbl39.outer).Scale = str8 == "phone" and v85[65] or str8 == v85[56] and 0.75 or 1

									fn43(tbl39.outer, tbl39.topCard, tbl39.listHolder, "Admin", { SURF2 = tbl33.ButtonBg, TEXT = tbl33.Text, AQUA_STROKE = tbl33.ButtonStroke }, {
										size = 24,
										radius = tbl33.ButtonCorner,
										textSize = 16,
										position = v101.new(1, -36, 0, 17),
										strokeT = 0.28,
										hoverBg = tbl33.RowHover,
										zindex = 20,
										headerH = 48,
										noClip = true,
									})

									adminGui = tbl39.adminGui
									local tbl40 = {}
									local tbl41 = {}
									local v108 = v85[117]

									local function fn78()
										local flag25 = flag23 == v85[8]
										tbl39.proxBtn.BackgroundColor3 = flag25 and v100.fromRGB(80, 24, 24) or v100.fromRGB(18, 8, 8)
										tbl39.proxBtn.TextColor3 = tbl33.Text
										tbl39.proxBtnStroke.Color = flag25 and v100.fromRGB(220, 80, 80) or tbl33.ButtonStroke
									end

									local Part = nil

									local function fn79()
										if flag23 then
											if not Part then
												Part = v102.new("Part")
												Part.Name = "XiProxViz"
												Part.Anchored = v85[8]
												Part.CanCollide = v85[112]
												Part.Shape = v103.PartType.Cylinder
												Part.Color = tbl33.AccentBright
												Part.Transparency = 0.6
												Part.CastShadow = false
												Part.Parent = Workspace
											end

											local character = localPlayer.Character
											character = character and character:FindFirstChild("HumanoidRootPart")

											if character then
												Part.Size = v98.new(0.5, (tbl31.ProximityRange or 15) * v85[198], (tbl31.ProximityRange or 15) * v85[198])
												Part.CFrame = character.CFrame * v99.Angles(0, 0, v89.rad(90))
											end
										elseif Part then
											Part:Destroy()
											Part = nil
										end
									end

									local function fn80(arg)
										local v109 = v85[133]
										local v110 = v89.clamp(arg or 15, 5, v109)
										tbl31.ProximityRange = v110
										fn48()
										local n34 = (v110 - 5) / (v109 - 5)
										tbl39.proxFill.Size = v101.new(n34, v85[117], 1, 0)
										tbl39.proxKnob.Position = v101.new(n34, 0, 0.5, 0)
										tbl39.rangeLabel.Text = v96(v89.floor(v110 + 0.5))
										fn79()
									end

									fn80(tbl31.ProximityRange or v85[96])
									fn78()
									tbl30.ProximityAPButton = tbl39.proxBtn
									tbl30.ProximityAPButtonStroke = tbl39.proxBtnStroke
									tbl30.AdminProxBtn = tbl39.proxBtn
									local flag25 = false

									tbl39.proxSliderBg.InputBegan:Connect(function(input)
										if input.UserInputType == v103.UserInputType.MouseButton1 or input.UserInputType == v103.UserInputType.Touch then
											flag25 = true
											_G.ADMIN_PANEL_SLIDER_DRAG = true
										end
									end)

									UserInputService.InputEnded:Connect(function(input)
										if input.UserInputType == v103.UserInputType.MouseButton1 or input.UserInputType == v103.UserInputType.Touch then
											flag25 = false
											_G.ADMIN_PANEL_SLIDER_DRAG = false
										end
									end)

									UserInputService.InputChanged:Connect(function(input)
										if flag25 and (input.UserInputType == v103.UserInputType.MouseMovement or input.UserInputType == v103.UserInputType.Touch) then
											fn80(5 + v89.clamp((input.Position.X - tbl39.proxSliderBg.AbsolutePosition.X) / tbl39.proxSliderBg.AbsoluteSize.X, 0, 1) * 45)
										end
									end)

									tbl39.proxBtn.MouseButton1Click:Connect(function()
										flag23 = not flag23
										fn78()
										fn79()
										fn51("PROXIMITY AP", flag23 and "ENABLED" or "DISABLED")
									end)

									tbl39.spamBaseBtn.MouseButton1Click:Connect(function()
										local character = localPlayer.Character
										local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
										if not humanoidRootPart then
											fn51("SPAM OWNER", "No character found")
											return
										end
										local huge = v89.huge
										local plots = Workspace:FindFirstChild("Plots")
										local v109 = nil

										if plots then
											v109 = nil

											for _, child in v92(plots:GetChildren()) do
												local plotSign = child:FindFirstChild("PlotSign")

												if plotSign then
													local yourBase = plotSign:FindFirstChild("YourBase")

													if not yourBase or not yourBase.Enabled then
														local position = plotSign:IsA("BasePart") and plotSign.Position or plotSign.PrimaryPart and plotSign.PrimaryPart.Position

														if not position then
															position = plotSign:FindFirstChildWhichIsA("BasePart", true)
															position = position and position.Position
														end

														if position then
															local magnitude = (humanoidRootPart.Position - position).Magnitude

															if magnitude < huge then
																huge = magnitude
																v109 = child
															end
														end
													end
												end
											end
										end

										if not v109 then
											fn51("SPAM OWNER", "No nearby base found")
											return
										end
										local v110 = nil
										local v111 = fn29(v109.Name)

										if v111 and v111.Owner then
											local owner = v111.Owner

											if typeof(owner) == "Instance" then
												v110 = owner
											elseif v95(owner) == "string" then
												v110 = service:FindFirstChild(owner)
											end
										end

										if not v110 then
											local plotSign = v109:FindFirstChild("PlotSign")
											local textLabel = plotSign and plotSign:FindFirstChild("SurfaceGui") and plotSign.SurfaceGui:FindFirstChild(v85[73]) and plotSign.SurfaceGui.Frame:FindFirstChild("TextLabel")

											if textLabel then
												local text = textLabel.Text
												local match = text and text:match("^(.-)'") or text

												if match then
													for _, player in v92(service:GetPlayers()) do
														if player.DisplayName == match or player.Name == match then
															v110 = player
															break
														end
													end
												end
											end
										end

										if not v110 or v110 == localPlayer then
											fn51("SPAM OWNER", "Owner not found or is you")
											return
										end
										tbl39.spamBaseBtn.BackgroundColor3 = v100.fromRGB(80, 24, 24)
										tbl39.spamBaseBtn.TextColor3 = tbl33.Text
										fn51("SPAM OWNER", "Spamming " .. v110.DisplayName)

										v88.spawn(function()
											local v112 = v85[117]

											for _, v113 in v92({ "balloon", "inverse", "jail", "jumpscare", "morph", "nightvision", "ragdoll", "rocket", "tiny" }) do
												if fn74(v110, v113) then
													v112 += v85[48]
												end

												v88.wait(0.15)
											end

											v88.wait(v85[137])
											tbl39.spamBaseBtn.BackgroundColor3 = v100.fromRGB(20, 22, 28)
											tbl39.spamBaseBtn.TextColor3 = tbl33.Text
											fn51("SPAM OWNER", "Sent " .. v112 .. " commands to " .. v110.DisplayName)
										end)
									end)

									local function fn81()
										local tbl42 = {}

										for _, child in v92(tbl39.listHolder:GetChildren()) do
											if child:IsA("Frame") and child.Name:match("^Row_") then
												v91.insert(tbl42, {
													row = child,
													createIndex = v97(child:GetAttribute("CreateIndex")) or v89.huge,
													playerName = child:GetAttribute("PlayerName") or "",
												})
											end
										end

										v91.sort(tbl42, function(arg, arg2)
											if arg.createIndex ~= arg2.createIndex then
												return arg.createIndex < arg2.createIndex
											end
											return arg.playerName < arg2.playerName
										end)

										for k, v109 in v92(tbl42) do
											v109.row.LayoutOrder = k
										end
									end

									local function fn82(arg)
										local v109 = tbl40[arg.UserId]
										if not v109 or not v109.Parent then
											return
										end
										local attribute = arg:GetAttribute("Stealing")
										local attribute2 = arg:GetAttribute("StealingIndex")

										if attribute then
											v109.Text = "STEALING • " .. v96(attribute2 or "Unknown")
											v109.TextColor3 = tbl33.Yellow
										else
											v109.Text = ""
										end
									end

									local function fn83(arg, arg2, arg3)
										local str9 = arg2 == "kawaifu" and "KAWAIFU" or "MOBY"
										local flag26 = arg2 == "kawaifu" and v100.fromRGB(228, 91, 176) or v100.fromRGB(180, v85[133], 50)
										local n34 = arg2 == "kawaifu" and v85[5] or 38
										local userTagMoby = arg:FindFirstChild("UserTag_MOBY") or arg:FindFirstChild("UserTag_KAWAIFU")

										if userTagMoby then
											userTagMoby:Destroy()
										end

										local TextLabel3 = fn63("TextLabel", {
											Name = "UserTag_" .. str9,
											BackgroundColor3 = flag26,
											BorderSizePixel = v85[117],
											Position = v101.fromOffset(arg3, 8),
											Size = v101.fromOffset(n34, 16),
											Text = str9,
											Font = v103.Font.GothamBold,
											TextSize = v85[109],
											TextColor3 = v100.fromRGB(255, 255, v85[63]),
											TextXAlignment = v103.TextXAlignment.Center,
											ZIndex = 11,
											Parent = arg,
										})

										fn64(TextLabel3, v85[23])
										return TextLabel3
									end

									local function fn84(arg)
										if fn50 and fn50(arg) then
											return "kawaifu"
										end

										if fn49 and fn49(arg) then
											return "moby"
										end
										return nil
									end

									local function fn85(arg)
										local v109 = tbl38[arg.UserId]
										if not v109 or not v109.Parent then
											return
										end
										fn72(arg)
										local userTagMoby = v109:FindFirstChild("UserTag_MOBY") or v109:FindFirstChild("UserTag_KAWAIFU")
										local v110 = fn84(arg)

										if not v110 then
											if userTagMoby then
												userTagMoby:Destroy()
											end

											return
										end

										local function fn86(arg2)
											arg2 = arg2 and arg2:FindFirstChild("DisplayNameLabel")
											local isTextLabel = arg2 and arg2:IsA("TextLabel")
											local n34 = 90

											if isTextLabel then
												local x = arg2.TextBounds.X
												local flag26 = x and x > 0
												local n35 = 90

												if flag26 then
													n34 = x
												else
													n34 = n35
												end
											end

											return v85[133] + n34 + 8
										end

										local str9 = v110 == "kawaifu" and "UserTag_KAWAIFU" or "UserTag_MOBY"
										local v111 = fn86(v109)

										if userTagMoby and userTagMoby.Name == str9 then
											userTagMoby.Position = v101.fromOffset(v111, 8)
										else
											if userTagMoby then
												userTagMoby:Destroy()
											end

											fn83(v109, v110, v111)
										end

										v88.defer(function()
											local v112 = tbl38[arg.UserId]
											if not v112 or not v112.Parent then
												return
											end
											local v113 = fn84(arg)
											local userTagMoby2 = v112:FindFirstChild("UserTag_MOBY") or v112:FindFirstChild("UserTag_KAWAIFU")

											if not v113 then
												if userTagMoby2 then
													userTagMoby2:Destroy()
												end

												return
											end

											local str10 = v113 == "kawaifu" and "UserTag_KAWAIFU" or "UserTag_MOBY"
											local v114 = fn86(v112)

											if userTagMoby2 and userTagMoby2.Name == str10 then
												userTagMoby2.Position = v101.fromOffset(v114, 8)
											else
												if userTagMoby2 then
													userTagMoby2:Destroy()
												end

												fn83(v112, v113, v114)
											end
										end)
									end

									local function fn86(arg, arg2, arg3, arg4)
										local TextButton = fn63("TextButton", {
											Size = v101.fromOffset(tbl33.ButtonSize, tbl33.ButtonSize),
											BackgroundTransparency = 1,
											AutoButtonColor = false,
											Text = "",
											LayoutOrder = arg3,
											Parent = arg,
										})

										local v109 = fn63(v85[73], {
											Name = "Box",
											AnchorPoint = Vector2.new(0.5, 0.5),
											Position = v101.new(0.5, v85[117], 0.5, 0),
											Size = v101.fromOffset(tbl33.BoxSize, tbl33.BoxSize),
											BackgroundTransparency = 1,
											BorderSizePixel = 0,
											Parent = TextButton,
										})

										fn64(v109, 6)
										local v110 = v85[147]

										fn64(fn63("Frame", {
											Name = "Fill",
											BackgroundColor3 = tbl33.ButtonBg,
											BackgroundTransparency = 0.08,
											BorderSizePixel = 0,
											Size = v101.fromScale(1, 1),
											Parent = v109,
										}), v110)

										fn65(v109, tbl33.ButtonStroke, 1.1, v85[48]).Name = "Stroke"

										fn63(v85[66], {
											BackgroundTransparency = 1,
											AnchorPoint = Vector2.new(0.5, v85[65]),
											Position = v101.new(v85[65], 0, 0.5, 0),
											Size = v101.fromOffset(tbl33.BoxSize, tbl33.BoxSize),
											Text = arg2.label,
											Font = v103.Font.GothamBold,
											TextSize = tbl33.IconSize,
											TextColor3 = tbl33.Text,
											TextXAlignment = v103.TextXAlignment.Center,
											TextYAlignment = v103.TextYAlignment.Center,
											Parent = TextButton,
										})

										TextButton:SetAttribute("Locked", false)
										TextButton:SetAttribute("ActionName", arg2.action)
										TextButton:SetAttribute("TargetPlayerName", arg4 and arg4.Name or "")
										fn69(TextButton, "normal")

										TextButton.MouseEnter:Connect(function()
											if TextButton:GetAttribute("Locked") then
												return
											end
											fn69(TextButton, "hover")
											if not (n25 >= 6412) then
												return
											end

											while true do
											end
										end)

										TextButton.MouseLeave:Connect(function()
											if TextButton:GetAttribute("Locked") then
												return
											end
											fn69(TextButton, "normal")
										end)

										v91.insert(tbl37[arg2.action], TextButton)
										local v111 = fn68(arg2.action)
										local v112 = fn71(arg4)
										v111 = v111 or v112
										TextButton.Active = not v111
										TextButton:SetAttribute("Locked", v111)

										if v111 then
											fn69(TextButton, "locked")
										end

										TextButton.MouseButton1Click:Connect(function()
											if fn71(arg4) then
												fn51("ADMIN", "AP Panel blocked on Moby users")
												fn72(arg4)
												return
											end

											if arg2.action == "tp" then
												local v113, v114 = fn77(arg4)
												if not v113 then
													fn51("ADMIN", "Failed TP: " .. v96(v114 or arg4 and arg4.Name or "target"))
													return
												end
												fn51("ADMIN", "TP'd to first floor of " .. (arg4 and arg4.Name or "target"))
												return
											end

											if fn68(arg2.action) then
												return
											end
											local name = arg4 and arg4.Name or "target"
											fn51("ADMIN", "Attempting " .. arg2.action .. " on " .. name)
											fn73(arg2.action)

											if fn74(arg4, arg2.action) == false then
												fn51("ADMIN", "Failed to send " .. arg2.action .. " to " .. name)
											else
												fn51("ADMIN", "Sent " .. arg2.action .. " to " .. name)
											end
										end)

										return TextButton
									end

									local function fn87(arg)
										if not arg or arg == localPlayer then
											return
										end

										if tbl38[arg.UserId] and tbl38[arg.UserId].Parent then
											return
										end
										local n34 = 0

										for _, child in v92(tbl39.listHolder:GetChildren()) do
											if child:IsA("Frame") and child.Name:match("^Row_") then
												n34 += 1
											end
										end

										local rowA = n34 % 2 == v85[117] and tbl33.RowA or tbl33.RowB

										local Frame3 = fn63("Frame", {
											Name = ("Row_%d"):format(arg.UserId),
											BackgroundColor3 = rowA,
											BackgroundTransparency = 0.4,
											BorderSizePixel = 0,
											Size = v101.new(v85[48], v85[117], 0, tbl33.RowHeight),
											ZIndex = v85[23],
											Parent = tbl39.listHolder,
										})

										v108 += 1
										Frame3:SetAttribute("CreateIndex", v108)
										Frame3:SetAttribute("PlayerName", arg.Name)
										fn64(Frame3, tbl33.RowCorner)
										fn65(Frame3, tbl33.AccentSoft, 1, 0.98)
										Frame3.ClipsDescendants = true
										tbl38[arg.UserId] = Frame3

										Frame3.MouseEnter:Connect(function()
											Frame3.BackgroundColor3 = tbl33.RowHover
										end)

										Frame3.MouseLeave:Connect(function()
											Frame3.BackgroundColor3 = rowA
										end)

										local Frame4 = fn63("Frame", {
											BackgroundColor3 = v100.fromRGB(9, v85[36], 14),
											BorderSizePixel = 0,
											Size = v101.fromOffset(34, 34),
											Position = v101.fromOffset(8, 10),
											Parent = Frame3,
										})

										fn64(Frame4, 8)
										fn65(Frame4, tbl33.AccentSoft, v85[48], v85[52])

										fn64(fn63(v85[167], {
											BackgroundTransparency = 1,
											Size = v101.fromScale(1, 1),
											Position = v101.fromOffset(0, 0),
											Image = "rbxthumb://type=AvatarHeadShot&id=" .. arg.UserId .. "&w=150&h=150",
											ZIndex = v85[36],
											Parent = Frame4,
										}), 8)

										local n35 = -(tbl33.ActionsWidth + tbl33.SafeGap)

										fn63("TextLabel", {
											Name = "DisplayNameLabel",
											BackgroundTransparency = 1,
											Position = v101.fromOffset(50, 6),
											Size = v101.new(1, n35, 0, 20),
											TextXAlignment = v103.TextXAlignment.Left,
											Text = arg.DisplayName,
											Font = v103.Font.GothamBold,
											TextSize = tbl33.NameSize,
											TextColor3 = tbl33.Text,
											ZIndex = v85[36],
											Parent = Frame3,
										})

										fn85(arg)

										fn63("TextLabel", {
											BackgroundTransparency = 1,
											Position = v101.fromOffset(50, 23),
											Size = v101.new(1, n35, 0, 16),
											TextXAlignment = v103.TextXAlignment.Left,
											Text = "@" .. arg.Name,
											Font = v103.Font.GothamMedium,
											TextSize = tbl33.UserSize,
											TextColor3 = tbl33.SubText,
											ZIndex = v85[36],
											Parent = Frame3,
										})

										tbl40[arg.UserId] = fn63("TextLabel", {
											Name = "Status",
											BackgroundTransparency = 1,
											Position = v101.fromOffset(50, 37),
											Size = v101.new(1, n35, 0, 14),
											TextXAlignment = v103.TextXAlignment.Left,
											Text = "",
											Font = v103.Font.GothamBold,
											TextSize = tbl33.StatusSize,
											TextColor3 = tbl33.Yellow,
											ZIndex = v85[36],
											Parent = Frame3,
										})

										local Frame5 = fn63("Frame", {
											Name = "Actions",
											BackgroundTransparency = 1,
											AnchorPoint = Vector2.new(v85[48], 0.5),
											Position = v101.new(1, -8, 0.5, 0),
											Size = v101.fromOffset(tbl33.ActionsWidth, tbl33.ButtonSize),
											ZIndex = 12,
											Parent = Frame3,
										})

										local UIListLayout = v102.new("UIListLayout")
										UIListLayout.FillDirection = v103.FillDirection.Horizontal
										UIListLayout.SortOrder = v103.SortOrder.LayoutOrder
										UIListLayout.HorizontalAlignment = v103.HorizontalAlignment.Left
										UIListLayout.VerticalAlignment = v103.VerticalAlignment.Center
										UIListLayout.Padding = UDim.new(0, 0)
										UIListLayout.Parent = Frame5

										for k, v109 in v92(tbl34) do
											fn86(Frame5, v109, k, arg)
										end

										fn63("Frame", {
											Name = "Line",
											BackgroundColor3 = tbl33.RowLine,
											BackgroundTransparency = 0.93,
											BorderSizePixel = 0,
											Position = v101.new(v85[117], 16, 1, -1),
											Size = v101.new(1, -v85[116], 0, 1),
											Parent = Frame3,
										})

										Frame3.InputBegan:Connect(function(input)
											if input.UserInputType ~= v103.UserInputType.MouseButton1 then
												return
											end

											if fn71(arg) then
												fn51("ADMIN", "AP Panel blocked on Moby users")
												fn72(arg)
												return
											end

											local tbl42 = { "ragdoll", "jail", "rocket", "balloon", "jumpscare", "inverse", "tiny", "morph" }
											local v109, v110, v111 = v92(tbl42)
											local flag26 = false

											for _, v112 in v109, v110, v111 do
												if not fn68(v112) then
													flag26 = v85[8]
													break
												end
											end

											if flag26 then
												local flag27 = false

												for _, v112 in v92(tbl42) do
													if not fn68(v112) then
														fn73(v112)

														if fn71(arg) then
															fn51("ADMIN", "AP Panel blocked on Moby users")
															fn72(arg)
															break
														else
															fn74(arg, v112)
															v88.wait(v85[99])
															flag27 = true
														end
													end
												end

												if flag27 then
													fn51("ADMIN", "Triggered ALL on " .. arg.Name)
												end
											end
										end)

										local tbl42 = {}

										v91.insert(tbl42, arg:GetAttributeChangedSignal("Stealing"):Connect(function()
											if not (n24 > 7715) then
												fn82(arg)
												return
											end

											while true do
											end
										end))

										v91.insert(tbl42, arg:GetAttributeChangedSignal("StealingIndex"):Connect(function()
											fn82(arg)
										end))

										v91.insert(tbl42, arg.CharacterAdded:Connect(function(character)
											v88.defer(function()
												fn85(arg)

												v94(function()
													character.DescendantAdded:Connect(function()
														v88.defer(function()
															fn85(arg)
														end)
													end)

													character.DescendantRemoving:Connect(function()
														v88.defer(function()
															fn85(arg)
														end)
													end)
												end)
											end)
										end))

										if arg.Character then
											v91.insert(tbl42, arg.Character.DescendantAdded:Connect(function()
												v88.defer(function()
													fn85(arg)
												end)
											end))

											v91.insert(tbl42, arg.Character.DescendantRemoving:Connect(function()
												v88.defer(function()
													fn85(arg)
												end)
											end))
										end

										tbl41[arg.UserId] = tbl42
										fn82(arg)
										fn85(arg)
										fn72(arg)
										fn81()
									end

									local function fn88(player)
										local v109 = tbl38[player.UserId]

										if v109 then
											if n25 >= 6414 then
												while v85[8] do
												end
											end

											v109:Destroy()
											tbl38[player.UserId] = nil
										end

										tbl40[player.UserId] = nil
										local v110 = tbl41[player.UserId]

										if v110 then
											for _, v111 in v92(v110) do
												v94(function()
													v111:Disconnect()
												end)
											end

											tbl41[player.UserId] = nil
										end
									end

									tbl39.refreshBtn.MouseButton1Click:Connect(function()
										for _, player in v92(service:GetPlayers()) do
											if player ~= localPlayer then
												fn87(player)
												fn82(player)
											end
										end

										fn81()
										fn51("ADMIN PANEL", "Player list refreshed")
									end)

									for _, player in v92(service:GetPlayers()) do
										if player ~= localPlayer then
											fn87(player)
										end
									end

									service.PlayerAdded:Connect(function(player)
										v88.defer(function()
											fn87(player)
										end)
									end)

									service.PlayerRemoving:Connect(fn88)

									v88.spawn(function()
										while tbl39.adminGui.Parent do
											fn79()

											for _, player in v92(service:GetPlayers()) do
												if player ~= localPlayer then
													fn85(player)
												end
											end

											v88.wait(0.25)
										end
									end)

									if tbl31.HideAdminPanel then
										tbl39.adminGui.Enabled = false
									end
								end

								fn62()
							end

							fn47()

							if flag22 then
								UserInputService.InputBegan:Connect(function(input, gameProcessed)
									if gameProcessed then
										return
									end

									if input.KeyCode == v103.KeyCode.LeftControl and adminGui then
										adminGui.Enabled = not adminGui.Enabled
									end
								end)
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

fn14(100, v4[fn2("n\218\192\176\129w\151\190\193\1756", 21845944094585)], v4[fn2("-\209 \r\161\128\30\181)\162\169\194\240\156\19Ȣs\0212\188p\207(\188\240\176\157\230\2\142\167\11\226\159&\233", 10693721171687)] .. v33(v64), Color3[v4[fn2("\211\207k", 18772801209419)]](1, 0, 0), v4[fn2(" `\4\162\157", 18561267614598)])